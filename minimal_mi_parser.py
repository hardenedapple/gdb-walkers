'''
Currently superfluous, since I'm writing a python API plugin and can use
gdb.execute_mi.

However, I'm reasonably proud of this -- having written it before realising
that gdb.execute_mi existed -- and want to keep it somewhere.

Shouldn't be anything problematic about keeping it around in the repo.  Maybe
it'll come in handy some time in the future.

'''
import collections
import string
import logging
import sys


# vimcmd: !python -m doctest %
# Note -- conversion from `vsh` logs into docstring tests using vim macros:
# Further note: Recording those macros for any future use, but python didn't
# like literal escape characters and literal ^M's in the comments.  Hence have
# replaced with `\e' and `\n' respectively.
#   let @a = 'dgc[[>pms'']:put =''    ''''''''''''''\n''s:-1put =''    ''''''''''''''\n'
#   let @b = '/vsh\n^ct>>>\emx/Comb\nd^"xDdd''x"x]p'
# Requires only a little bit extra manual labour (especially around
# exceptions).

logger = logging.getLogger(__name__)
logging.basicConfig(stream=sys.stdout, level=logging.ERROR)

# Combinator type is a function taking a string and returning a
# CombinatorRet.
CombinatorRet = collections.namedtuple('CombinatorRet', \
            ['success', 'value', 'remaining'])

def no_match_value(remaining):
    return CombinatorRet(success=False, value=None, remaining=remaining)

def eol(line):
    if line:
        return no_match_value(line)
    return CombinatorRet(True, '', '')

def non_quote_char():
    '''
    >>> non_quote_char()('"')
    CombinatorRet(success=False, value=None, remaining='"')
    >>> non_quote_char()('\\\\"This is a quoted string\\\\"')
    CombinatorRet(success=True, value='\\\\"', remaining='This is a quoted string\\\\"')
    >>> non_quote_char()('Hello world"')
    CombinatorRet(success=True, value='H', remaining='ello world"')
    >>> non_quote_char()('')
    CombinatorRet(success=False, value=None, remaining='')
    '''
    def retfunc(line):
        isbackslash = False
        ret = ''
        for char in line:
            if char == '\\' and not ret:
                ret = '\\'
                continue
            if char == '"' and not ret:
                return no_match_value(line)
            return CombinatorRet(True, ret+char, line[len(ret)+1:])
        assert (not ret and not line)
        return no_match_value('')
    return retfunc

def just(prefix):
    def retfunc(line):
        if line.startswith(prefix):
            return CombinatorRet(True, prefix, line[len(prefix):])
        return no_match_value(line)
    return retfunc

def zero_or_more(subparser):
    def retfunc(line):
        retval = []
        x = subparser(line)
        while x.success:
            retval.append(x.value)
            x = subparser(x.remaining)
        logger.debug('zero_or_more: ' + repr(retval))
        return CombinatorRet(True, retval, x.remaining)
    return retfunc

def zero_or_one(subparser):
    def retfunc(line):
        x = subparser(line)
        if not x:
            logger.debug('zero_or_one: Zero')
            return CombinatorRet(True, '', line)
        logger.debug(f'zero_or_one: {repr(x)}')
        return x
    return retfunc

def one_or_more(subparser):
    def retfunc(line):
        retval = []
        x = subparser(line)
        while x.success:
            retval.append(x.value)
            x = subparser(x.remaining)
        logger.debug('one_or_more: ' + repr(retval))
        return CombinatorRet(True, retval, x.remaining) if retval else no_match_value(line)
    return retfunc

def string_of(subparser):
    '''
    >>> string_of(non_quote_char())('"hello world')
    CombinatorRet(success=False, value=None, remaining='"hello world')
    >>> string_of(non_quote_char())('"hello" world')
    CombinatorRet(success=False, value=None, remaining='"hello" world')
    >>> string_of(non_quote_char())('h"ello" world')
    CombinatorRet(success=True, value='h', remaining='"ello" world')
    >>> string_of(non_quote_char())('hello world')
    CombinatorRet(success=True, value='hello world', remaining='')
    '''
    def retfunc(line):
        parsed = one_or_more(subparser)(line)
        if parsed.success:
            logger.debug(f'string_of: {parsed.value}')
            return CombinatorRet(True, ''.join(parsed.value), parsed.remaining)
        return parsed
    return retfunc


def ignore_delimiters(subparser, start, end):
    '''
    >>> ignore_delimiters(just('hello'), just('['), just(']'))('[hello]')
    CombinatorRet(success=True, value='hello', remaining='')
    >>> ignore_delimiters(just('hello'), just('['), just(']'))('[hello')
    CombinatorRet(success=False, value=None, remaining='[hello')
    >>> ignore_delimiters(just('hello'), just('['), just(']'))('hello]')
    CombinatorRet(success=False, value=None, remaining='hello]')
    '''
    def retfunc(line):
        fail_ret = no_match_value(line)
        retval = start(line)
        if not retval.success:
            return fail_ret
        retval = subparser(retval.remaining)
        if not retval.success:
            return fail_ret
        value_to_ret = retval.value
        retval = end(retval.remaining)
        if not retval.success:
            return fail_ret
        logger.debug('ignore_delimiters: ' + repr(value_to_ret))
        return CombinatorRet(True, value_to_ret, retval.remaining)
    return retfunc

def ignored(subparser):
    '''
    >>> ignored(just('hello'))('hello')
    CombinatorRet(success=True, value=None, remaining='')
    >>> ignored(just('hello'))('help')
    CombinatorRet(success=False, value=None, remaining='help')
    '''
    def retfunc(line):
        sub = subparser(line)
        if not sub.success:
            return sub
        logger.debug(f'Ignoring {sub.value}')
        return CombinatorRet(sub.success, None, sub.remaining)
    return retfunc

def mi_const():
    '''
    >>> mi_const()('hello "world"')
    CombinatorRet(success=False, value=None, remaining='hello "world"')
    >>> mi_const()('"hello world')
    CombinatorRet(success=False, value=None, remaining='"hello world')
    >>> mi_const()('"hello world"')
    CombinatorRet(success=True, value='hello world', remaining='')
    >>> mi_const()('')
    CombinatorRet(success=False, value=None, remaining='')
    '''
    return ignore_delimiters(string_of(non_quote_char()), just('"'), just('"'))

def char_in_set(charset):
    def retfunc(line):
        if not line:
            return no_match_value(line)
        if line[0] in charset:
            return CombinatorRet(True, line[0], line[1:])
        return no_match_value(line)
    return retfunc

def token_char():
    '''
    >>> token_char()('hello')
    CombinatorRet(success=True, value='h', remaining='ello')
    >>> token_char()('-hello')
    CombinatorRet(success=True, value='-', remaining='hello')
    '''
    return char_in_set(string.ascii_letters + string.digits + '-')

def mi_variable():
    '''
    >>> mi_variable()('hello')
    CombinatorRet(success=True, value='hello', remaining='')
    >>> mi_variable()('hello-this')
    CombinatorRet(success=True, value='hello-this', remaining='')
    >>> mi_variable()('"hello-this')
    CombinatorRet(success=False, value=None, remaining='"hello-this')
    >>> mi_variable()('hell=o-this')
    CombinatorRet(success=True, value='hell', remaining='=o-this')
    '''
    return string_of(token_char())

def sequence_elements(*args):
    if not args:
        return lambda line: CombinatorRet(True, value='', remaining=line)
    def retfunc(line):
        total_value = []
        remaining = line
        for sub in args:
            next = sub(remaining)
            logger.debug(f'tmp sequence_elements: {repr(next)}')
            if not next.success:
                return no_match_value(line)
            total_value.append(next.value)
            remaining = next.remaining
        ret = CombinatorRet(True, value=total_value, remaining=remaining)
        logger.debug(f'sequence_elements: {repr(ret)}')
        return ret
    return retfunc

def or_combine(*args):
    def retfunc(line):
        retval = no_match_value(line)
        for x in args:
            retval = x(line)
            if retval.success:
                logger.debug('or_combine: ' + repr(retval.value))
                return retval
        return retval
    return retfunc

def recursive(func_taking_parser):
    cache_object = None
    def retfunc(line):
        nonlocal cache_object
        if cache_object:
            return cache_object(line)
        cache_object = func_taking_parser(retfunc)
        return cache_object(line)
    return retfunc

def __mi_complex(sub, conversion):
    ignore_comma = ignored(just(','))
    def retfunc(line):
        cur = sub(line)
        if not cur.success:
            return cur
        elements_seen = []
        while True:
            remaining = cur.remaining
            elements_seen.append(cur.value)
            tmp = ignore_comma(remaining)
            if not tmp.success:
                break
            remaining = tmp.remaining
            cur = sub(remaining)
            if not cur.success:
                raise RuntimeError('Comma not followed by value')
        retval = conversion(elements_seen)
        logger.debug(f'__mi_complex: {retval}')
        return CombinatorRet(True, retval, remaining)
    return retfunc

def __mi_list(sub):
    return __mi_complex(sub, list)

def __mi_list_basic_parser(line):
    if line.startswith('[]'):
        return CombinatorRet(True, [], line[2:])
    return no_match_value(line)

def mi_list(sub):
    '''
    >>> actual_list = '[{file="test.c",fullname="/home/mmalcomson/test.c",debug-fully-read="false"},{file="/usr/include/stdio.h",fullname="/usr/include/stdio.h",debug-fully-read="false"}]'
    >>> mi_list(mi_value)(actual_list)
    CombinatorRet(success=True, value=[{'file': 'test.c', 'fullname': '/home/mmalcomson/test.c', 'debug-fully-read': 'false'}, {'file': '/usr/include/stdio.h', 'fullname': '/usr/include/stdio.h', 'debug-fully-read': 'false'}], remaining='')
    >>> mi_list(mi_value)('[file="hello",other="world"]')
    CombinatorRet(success=True, value=[('file', 'hello'), ('other', 'world')], remaining='')
    '''
    return or_combine(
        __mi_list_basic_parser,
        ignore_delimiters(__mi_list(sub), just('['), just(']')),
        ignore_delimiters(__mi_list(mi_result(sub)), just('['), just(']')))

def __mi_tuple(sub):
    return __mi_complex(sub, dict)

def __mi_tuple_basic_parser(line):
    if line.startswith('{}'):
        return CombinatorRet(True, {}, line[2:])
    return no_match_value(line)

def mi_tuple(sub):
    '''
    >>> mi_tuple(mi_value)('{file="/usr/include/stdio.h",fullname="/usr/include/stdio.h",debug-fully-read="false"}')
    CombinatorRet(success=True, value={'file': '/usr/include/stdio.h', 'fullname': '/usr/include/stdio.h', 'debug-fully-read': 'false'}, remaining='')
    >>> actual_tuple = '{file="test.c",fullname="/home/mmalcomson/test.c",debug-fully-read="false"}'
    >>> mi_tuple(mi_value)(actual_tuple)
    CombinatorRet(success=True, value={'file': 'test.c', 'fullname': '/home/mmalcomson/test.c', 'debug-fully-read': 'false'}, remaining='')
    '''
    return or_combine(
        __mi_tuple_basic_parser,
        ignore_delimiters(__mi_tuple(mi_result(sub)), just('{'), just('}')))

def _mi_value(sub):
    return or_combine(mi_const(), mi_tuple(sub), mi_list(sub))
mi_value = recursive(_mi_value)

def mi_result(sub_val):
    '''
    >>> mi_result(mi_value)('file="test.c"')
    CombinatorRet(success=True, value=('file', 'test.c'), remaining='')
    >>> mi_result(mi_value)('=file="test.c"')
    CombinatorRet(success=False, value=None, remaining='=file="test.c"')
    >>> mi_result(mi_value)('file="test.c",extra="world"')
    CombinatorRet(success=True, value=('file', 'test.c'), remaining=',extra="world"')
    >>> actual_data = 'files=[{file="test.c",fullname="/home/mmalcomson/test.c",debug-fully-read="false"},{file="/usr/include/stdio.h",fullname="/usr/include/stdio.h",debug-fully-read="false"}]'
    >>> mi_result(mi_value)(actual_data)
    CombinatorRet(success=True, value=('files', [{'file': 'test.c', 'fullname': '/home/mmalcomson/test.c', 'debug-fully-read': 'false'}, {'file': '/usr/include/stdio.h', 'fullname': '/usr/include/stdio.h', 'debug-fully-read': 'false'}]), remaining='')
    '''
    sub_parser = sequence_elements(mi_variable(), just('='), sub_val)
    def retfunc(line):
        res = sub_parser(line)
        if not res.success:
            return res
        logger.debug('mi_result: ' + repr((res.value[0], res.value[2])))
        return CombinatorRet(True, (res.value[0], res.value[2]), res.remaining)
    return retfunc


#def tracefunc(frame, event, arg, indent=[0]):
#      if event == "call":
#          indent[0] += 2
#          print("-" * indent[0] + "> call function", frame.f_code.co_name)
#      elif event == "return":
#          print("<" + "-" * indent[0], "exit function", frame.f_code.co_name)
#          indent[0] -= 2
#      return tracefunc
#
#import sys
#sys.setprofile(tracefunc)
#sys.setprofile(lambda *args: None)

def __mi_tail(sub):
    '''
    >>> __mi_tail(mi_result(mi_value))(',hello="world"')
    CombinatorRet(success=True, value=[('hello', 'world')], remaining='')
    >>> __mi_tail(mi_result(mi_value))(',hello="world",this="test"')
    CombinatorRet(success=True, value=[('hello', 'world'), ('this', 'test')], remaining='')
    >>> __mi_tail(mi_result(mi_value))('hello="world",this="test"')
    CombinatorRet(success=True, value='', remaining='hello="world",this="test"')
    >>> __mi_tail(mi_result(mi_value))(',hello="world",')
    Traceback (most recent call last):
        ...
    RuntimeError: Comma not followed by value
    >>> 
    '''
    ignore_comma = ignored(just(','))
    all_after = __mi_complex(sub, lambda x: x)
    def retfunc(line):
        tmp = ignore_comma(line)
        if not tmp.success:
            return CombinatorRet(True, '', line)
        logger.debug(f'__mi_tail')
        ret = all_after(tmp.remaining)
        if not ret.success:
            raise RuntimeError('__mi_tail: Comma not followed by value')
        return ret
    return retfunc


eol = or_combine(just('\r\n'), just('\n'))

def mi_result_class():
    '''
    >>> mi_result_class()('done')
    CombinatorRet(success=True, value='done', remaining='')
    >>> mi_result_class()('other')
    CombinatorRet(success=False, value=None, remaining='other')
    >>> mi_result_class()('donethis')
    CombinatorRet(success=True, value='done', remaining='this')
    '''
    return or_combine(*[just(x) for x in ('done', 'running', 'connected', 'error', 'exit')])


def mi_result_record():
    '''
    >>> mi_result_record()('^running,files=[{file="test.c",fullname="/home/mmalcomson/test.c",debug-fully-read="false"},{file="/usr/include/stdio.h",fullname="/usr/include/stdio.h",debug-fully-read="false"}]')
    Traceback (most recent call last):
        ...
    RuntimeError: Failed to run GDB MI command.  Result-Class: running
    >>> 
    >>> mi_result_record()('^doxe,files=[{file="test.c",fullname="/home/mmalcomson/test.c",debug-fully-read="false"},{file="/usr/include/stdio.h",fullname="/usr/include/stdio.h",debug-fully-read="false"}]')
    Traceback (most recent call last):
        ...
    AssertionError
    >>> 
    >>> mi_result_record()('^done,files=[{file="test.c"},{file="/usr/include/stdio.h",fullname="/usr/include/stdio.h"}]\\r\\n')
    CombinatorRet(success=True, value=[('files', [{'file': 'test.c'}, {'file': '/usr/include/stdio.h', 'fullname': '/usr/include/stdio.h'}])], remaining='')
    >>> mi_result_record()('^done,files=[{file="test.c"},{file="/usr/include/stdio.h",fullname="/usr/include/stdio.h"}],other="hello"\\r\\n')
    CombinatorRet(success=True, value=[('files', [{'file': 'test.c'}, {'file': '/usr/include/stdio.h', 'fullname': '/usr/include/stdio.h'}]), ('other', 'hello')], remaining='')
    '''
    starttok = ignored(just('^'))
    res_class = mi_result_class()
    res_parser = __mi_tail(mi_result(mi_value))
    def retfunc(line):
        tmp = starttok(line)
        logger.debug(f'temp: mi_result_record: {repr(tmp)}')
        assert (tmp.success)
        tmp = res_class(tmp.remaining)
        logger.debug(f'temp: mi_result_record: {repr(tmp)}')
        assert (tmp.success)
        if tmp.value != 'done':
            raise RuntimeError(f'Failed to run GDB MI command.  Result-Class: {tmp.value}')
        ret = res_parser(tmp.remaining)
        logger.debug(f'mi_result_record: {repr(ret)}')
        tmp = eol(ret.remaining)
        assert (tmp.success)
        return CombinatorRet(True, ret.value, tmp.remaining)
    return retfunc

def mi_stream_record():
    '''
    >>> mi_stream_record()('~"hello"\\r\\n')
    CombinatorRet(success=True, value=None, remaining='')
    >>> mi_stream_record()('~"hello"\\r\\nworld')
    CombinatorRet(success=True, value=None, remaining='world')
    >>> mi_stream_record()('@"hello"\\r\\nworld')
    CombinatorRet(success=True, value=None, remaining='world')
    >>> mi_stream_record()('&"hello"\\r\\nworld')
    CombinatorRet(success=True, value=None, remaining='world')
    >>> mi_stream_record()('&"hello"x\\r\\nworld')
    CombinatorRet(success=False, value=None, remaining='&"hello"x\\r\\nworld')
    '''
    return ignored(sequence_elements(or_combine(*[just(x) for x in '~@&']),
                                     mi_const(),
                                     eol))

def mi_async_class():
    return just('stopped')

def mi_async_output():
    '''
    >>> mi_async_output()('stopped')
    CombinatorRet(success=True, value='', remaining='')
    >>> mi_async_output()('stopped,file="world"')
    CombinatorRet(success=True, value=[('file', 'world')], remaining='')
    >>> mi_async_output()('stopped,file="world",hello="there"')
    CombinatorRet(success=True, value=[('file', 'world'), ('hello', 'there')], remaining='')
    >>> mi_async_output()('')
    CombinatorRet(success=True, value='', remaining='')
    >>> mi_async_output()('stopped,')
    Traceback (most recent call last):
        ...
    RuntimeError: __mi_tail: Comma not followed by value
    '''
    res_class = mi_async_class()
    res_parser = __mi_tail(mi_result(mi_value))
    def retfunc(line):
        tmp = res_class(line)
        if not tmp:
            return tmp
        return res_parser(tmp.remaining)
    return retfunc


def mi_async_record():
    '''
    >>> mi_async_record()('*stopped\\r\\n')
    CombinatorRet(success=True, value=None, remaining='')
    >>> mi_async_record()('*stopped\\r\\nworld')
    CombinatorRet(success=True, value=None, remaining='world')
    >>> mi_async_record()('+stopped\\r\\nworld')
    CombinatorRet(success=True, value=None, remaining='world')
    >>> mi_async_record()('=stopped\\r\\nworld')
    CombinatorRet(success=True, value=None, remaining='world')
    >>> mi_async_record()('=stoppedx\\r\\nworld')
    CombinatorRet(success=False, value=None, remaining='=stoppedx\\r\\nworld')
    >>> mi_async_record()('=stopped,file="World"\\r\\nworld')
    CombinatorRet(success=True, value=None, remaining='world')
    '''
    return ignored(sequence_elements(or_combine(*[just(x) for x in '*+=']),
                                    mi_async_output(),
                                    eol))


def mi_oob_record():
    '''
    >>> mi_oob_record()('*stopped\\r\\n')
    CombinatorRet(success=True, value=None, remaining='')
    >>> mi_oob_record()('*stopped\\r\\nworld')
    CombinatorRet(success=True, value=None, remaining='world')
    >>> mi_oob_record()('+stopped\\r\\nworld')
    CombinatorRet(success=True, value=None, remaining='world')
    >>> mi_oob_record()('=stopped\\r\\nworld')
    CombinatorRet(success=True, value=None, remaining='world')
    >>> mi_oob_record()('=stoppedx\\r\\nworld')
    CombinatorRet(success=False, value=None, remaining='=stoppedx\\r\\nworld')
    >>> mi_oob_record()('=stopped,file="World"\\r\\nworld')
    CombinatorRet(success=True, value=None, remaining='world')
    >>> mi_oob_record()('~"hello"\\r\\n')
    CombinatorRet(success=True, value=None, remaining='')
    >>> mi_oob_record()('~"hello"\\r\\nworld')
    CombinatorRet(success=True, value=None, remaining='world')
    >>> mi_oob_record()('@"hello"\\r\\nworld')
    CombinatorRet(success=True, value=None, remaining='world')
    >>> mi_oob_record()('&"hello"\\r\\nworld')
    CombinatorRet(success=True, value=None, remaining='world')
    >>> mi_oob_record()('&"hello"x\\r\\nworld')
    CombinatorRet(success=False, value=None, remaining='&"hello"x\\r\\nworld')
    '''
    return or_combine(mi_async_record(), mi_stream_record())


#def mi_result_from_output():
#    oobs = zero_or_more(mi_oob_record())
#    res = zero_or_one(mi_result_record())
#    prompt = just('(gdb) ')
#    def retfunc(line):
#        x = oobs(line)
#        logger.debug(f'mi_result_from_output: {repr(x)}')
#        assert (x.success)
#        ret = res(x.remaining)
#        logger.debug(f'mi_result_from_output: {repr(ret)}')
#        if not ret.success:
#            return no_match_value(line)
#        tmp = prompt(ret.remaining)
#        logger.debug(f'mi_result_from_output: {repr(tmp)}')
#        if not tmp.success:
#            return no_match_value(line)
#        tmp = eol(tmp.remaining)
#        logger.debug(f'mi_result_from_output: {repr(tmp)}')
#        if not tmp.success:
#            return no_match_value(line)
#        return CombinatorRet(True, ret.value, tmp.remaining)
#    return retfunc

def mi_echod_command():
    '''
    >>> mi_echod_command()('-symbol-info-functions --name foo --include-nondebug\\r\\n')
    CombinatorRet(success=True, value=None, remaining='')
    >>> mi_echod_command()('-symbol-info-functions --name foo --include-nondebug\\r\\n^done,whatever="thingy"')
    CombinatorRet(success=True, value=None, remaining='^done,whatever="thingy"')
    '''
    return ignored(sequence_elements(
        just('-'),
        string_of(char_in_set(string.ascii_letters + string.digits + '- ')),
        eol))

def mi_result_from_output():
    sub = sequence_elements(
            zero_or_one(mi_echod_command()),
            zero_or_more(mi_oob_record()),
            zero_or_one(mi_result_record()),
            just('(gdb) '),
            eol)
    def retfunc(line):
        x = sub(line)
        if not x.success:
            return x
        return CombinatorRet(True, x.value[2], x.remaining)
    return retfunc

#import minimal_mi_parser as mip
#import os
#import time
#class MI():
#        '''Helper class for handling one specific machine interface function
#        call.
#
#        I wanted to use the below command:
#            `interpreter-exec mi -file-list-exec-source-files`
#
#        Unfortunately, `interpreter-exec` output is not actually returned
#        by `gdb.execute`.  Rather it gets printed to the terminal directly.
#        Hence start a new UI with a specific TTY that we've opened, and
#        use that to communicate.
#
#        Hence do some shenanigans opening PTY's and starting a new UI in order
#        to just send this one command.
#        '''
#        @classmethod
#        def setup(cls):
#            global _miui
#            if _miui is not None:
#                return _miui
#            import pty
#            import ctypes
#            masterfd, slavefd = pty.openpty()
#            libc = ctypes.CDLL('libc.so.6')
#            libc.ptsname.restype = ctypes.c_char_p
#            pty_name = libc.ptsname(masterfd).decode('utf8')
#            # Unfortunately can not avoid the message that this prints.
#            gdb.execute('new-ui mi {}'.format(pty_name))
#            os.set_blocking(masterfd, False)
#            ret = MI(masterfd, slavefd)
#            logger.debug('Initialised MI')
#            ret.consume_initialisation()
#            _miui = ret
#            return ret
#
#        def __init__(self, masterfd, slavefd):
#            self.masterfd = masterfd
#            self.slavefd = slavefd
#            self.curdata = b''
#
#        def read_one_output(self):
#            while b'(gdb) \r\n' not in self.curdata:
#                logger.debug(f'{self.curdata}')
#                try:
#                    self.curdata += os.read(self.masterfd, 999)
#                except BlockingIOError:
#                    time.sleep(0.1)
#            return self.curdata.decode('utf8')
#
#        def consume_initialisation(self):
#            self.read_one_output()
#            logger.debug(f'{self.curdata}')
#            self.curdata = b''
#
#        def get_function_list(self, name, include_nondebug):
#            format = '-symbol-info-functions --name {}{}\n'.format(
#                    name, ' --include-nondebug' if include_nondebug else '')
#            os.write(self.masterfd, format.encode('utf8'))
#            logger.debug('Send function query')
#            returned_data = self.read_one_output()
#            result = mip.mi_result_from_output()(returned_data)
#            assert (not result.remaining)
#            assert (result.success)
#            assert (len(result.value) == 1)
#            assert (result.value[0][0] == 'symbols')
#            return result.value[0][1]
#
#
