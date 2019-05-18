'''Helper functions -- used throughout the walkers files.

'''
import gdb
import re
import contextlib
import collections

def file_func_split(regexp):
    '''Split  file_regexp:func_regexp  into its component parts.

    If there is no colon, then func_regexp is `regexp` and file_regexp is None

    '''
    file_func = regexp.split(':', maxsplit=1)
    if len(file_func) == 1:
        file_regex = None
        func_regex = file_func[0]
    else:
        file_regex, func_regex = file_func

    return file_regex, func_regex


def find_uintptr_t():
    '''Find a uintptr_t equivalent and store it in the global namespace.'''
    voidptr_t = gdb.parse_and_eval('(char *)0').type
    size_and_types = {val.sizeof: val for val in
                      map(gdb.lookup_type, ['unsigned int', 'unsigned long',
                                            'unsigned long long'])}
    try:
        return size_and_types[voidptr_t.sizeof]
    except KeyError:
        raise RuntimeError('Failed to find size of pointer type')


# First guess -- on starting the program we update this.
# This is because we don't actually know the size of a pointer type until we
# attach to a process.
__uintptr_t = find_uintptr_t()
def as_uintptr(x): return x.cast(__uintptr_t)
def uintptr_size(): return __uintptr_t.sizeof

def find_type_size(type_string):
    '''Return the size of the type described by type_string.

    This is different to simply using gdb.lookup_type().sizeof as it handles
    pointer types by simply returning the size of an uintptr_t type.

    The detection of whether the string is a pointer is very brittle: it simply
    searches for the character '*' in the type string.

    '''
    # TODO This is hacky, and we don't handle char[], &char that users
    # might like to use.
    if type_string.find('*') != -1:
        element_size = uintptr_size()
    else:
        element_size = gdb.lookup_type(type_string).sizeof
    return element_size


def eval_uint(gdb_expr):
    '''Return the python unsigned integer value of `gdb_expr` without it's type

    This is to be used over `int(gdb.parse_and_eval(gdb_expr))` to
    account for the given description being a symbol.

    '''
    # Cast to __uintptr_t to find addresses of functions (e.g.
    # gdb.parse_and_eval('main')).
    try:
        return int(gdb.parse_and_eval(gdb_expr).cast(__uintptr_t))
    except:
        print('error parsing ', gdb_expr, ' and casting to uintptr_t')
        raise


def start_handler(_):
    '''Upon startup, find the pointer type for this program'''
    global __uintptr_t
    __uintptr_t = find_uintptr_t()
    # Remove us from the handler -- there is no reason to keep finding the same
    # pointer type.
    # NOTE:
    #   This may have trouble when inspecting both 32bit and 64 bit programs in
    #   the same gdb session.
    #   TODO Check if this is the case ...
    #   In that case, just manually run
    #      (gdb) python find_uintptr_t()
    #   and you should be fine.
    gdb.events.new_objfile.disconnect(start_handler)


def offsetof(typename, field):
    return eval_uint('&((({} *)0)->{})'.format(typename, field))


# Update __uintptr_t value on first objfile added because by then we'll know
# what the current program file architecture is. If we find the current pointer
# type before we do anything else gdb just guesses.
gdb.events.new_objfile.connect(start_handler)

if not hasattr(gdb, 'current_arch'):
    if hasattr(gdb.selected_inferior(), 'architecture'):
        def cur_arch():
            '''Get the current architecture.'''
            return gdb.selected_inferior().architecture()
    else:
        def cur_arch():
            '''
            Get the current architecture.

            This only works if the program is currently running.

            If the gdb.current_arch() function is defined, then it's much better
            than this mock because it works even when the current process isn't
            running.

            '''
            return gdb.selected_frame().architecture()

    gdb.current_arch = cur_arch


class FakeSymbol():
    '''Fake a gdb.Symbol class.

    Can't make these directly because we don't have enough information.
    All we need for the current use-case is the value() method, and the name
    attribute.

    '''
    pointless_symtab = collections.namedtuple('symtab', ['filename'])
    symtab = pointless_symtab('')
    def __init__(self, name, value):
        self.name = name
        self._value = gdb.parse_and_eval(value)

    def value(self):
        return self._value


if not hasattr(gdb, 'search_symbols'):
    def file_symbols(filename, regexp):
        '''Iterate over all symbols defined in a file.'''
        if not filename:
            return

        try:
            unparsed, sal_options = gdb.decode_line("'{}':1".format(filename))
        except gdb.error as e:
            # n.b. This is very brittle -- nothing in gdb specifies these error
            # strings, so they could easily change.
            # Until I find a better way, I'm simply adding each exception I
            # come across that I know is fine to ignore.
            # The only real way to get this is to add search_symbols as a
            # function into the gdb python interface.
            if e.args[0].startswith('No line 1 in file "'):
                return
            if e.args[0].startswith('No source file named '):
                return
            raise

        if unparsed:
            raise ValueError('Failed to parse {} as filename'.format(filename))

        # TODO Check source code and see if this is always the case.
        # NOTE: When there are more than one symbol and file options given from
        # the same source file, they all have the same set of symbol names.
        #   (as far as I can tell -- haven't yet looked at the gdb source).
        # Hence ignore any extra ones.
        sal = sal_options[0]
        for block in (sal.symtab.global_block(), sal.symtab.static_block()):
            yield from (sym for sym in block
                        if sym.is_function and re.match(regexp, sym.name))


    def search_symbols(regexp, file_regex, include_dynlibs=False):
        '''Return symbols matching REGEXP defined in files matching FILE_REGEXP

        If FILE_REGEXP matches the empty string, include Non-debug functions.

        '''
        include_non_debugging = re.search(file_regex, '') is not None
        try:
            # TODO substitute with
            # interpreter-exec mi -file-list-exec-source-files ?
            # This should have a well defined output, so I would have to worry
            # less about the output changing in the future.
            # Unfortunately, the output isn't nearly as simple to parse, and as
            # long as the output stays the same, this is both easy and robust
            # against strange filenames.
            #
            # I could use pygdbmi, but I really don't want to add a dependency
            # for this.
            # https://github.com/cs01/pygdbmi
            source_files = gdb.execute('info sources', False, True)
        except gdb.error as e:
            if e.args != ('No symbol table is loaded.  Use the "file" command.',):
                raise e
        else:
            source_lines = source_files.splitlines()
            loaded = source_lines[2]
            unloaded = source_lines[6]
            for filelist in loaded.split(', '), unloaded.split(', '):
                for filename in (val for val in filelist if
                                 re.search(file_regex, val)):
                    yield from file_symbols(filename, regexp)

        if include_non_debugging:
            # TODO not really sure whether this is a safe way of making sure we
            # only get the main program. Read the gdb source and see what's
            # actually happening.
            cur_progfile = gdb.current_progspace().filename

            # Don't filter functions directly with regexp because we want to
            # use python rexexp (to match the filter done above).
            all_symbols = gdb.execute('info functions', False, True)
            non_debug_start = all_symbols.find('Non-debugging symbols:')
            all_non_debugging = all_symbols[non_debug_start:].splitlines()[1:]
            # Just because it makes me feel better to let python free the big
            # string -- probably doesn't matter.
            del all_symbols
            for line in all_non_debugging:
                # If ValueError() is raised here, then my assumptions are
                # incorrect -- I need to know about it.
                # For example, `info functions` on $(which nvim) gives me the
                # lines
                # 0x00007ffff7bbb310  uv(float, long double,...)(...)@plt
                # 0x00007ffff7bbcd50  uv(float, long double,...)(...)
                # and others.
                # I don't know what to do with these, so I ignore them.
                # TODO Figure out what to do with these.
                try:
                    addr, name = line.split()
                except ValueError as e:
                    if e.args == ('too many values to unpack (expected 2)',):
                        continue
                    raise e

                # Assume users don't care about the indirection functions.
                if not re.match(regexp, name) or name.endswith('@plt'):
                    continue
                if not include_dynlibs:
                    sym_objfile = gdb.execute('info symbol {}'.format(addr),
                                              False, True).split()[-1]
                    if sym_objfile != cur_progfile:
                        continue

                yield FakeSymbol(name, addr)


    gdb.search_symbols = search_symbols


def get_function_block(addr):
    '''Does gdb.block_for_pc(addr) but raises the same exception if object file
    can't be found as if the block found is None, static, or global.

    This is just for convenience.

    '''
    func_block = gdb.block_for_pc(addr)
    # Want the same thing to happen when gdb can't find the object file (and
    # hence raises an exception itself) as when it just can't find the block,
    # or found a static / global (i.e. file-sized) block instead of a function
    # block.
    # I've seen getting a static block when asking for the block at a
    # function address happen with je_extent_tree_szad_new() function when
    # debugging neovim.
    if func_block is None or func_block.is_static or func_block.is_global:
        raise RuntimeError('Cannot locate object file for block.')

    return func_block


def enumdesc_from_enumvalue(enumvalue):
    enum_intval = int(enumvalue)
    enum_type = enumvalue.type
    for name, field in enum_type.iteritems():
        if field.enumval == enum_intval:
            return name
    raise ValueError('Given value is not in the valid range of enum type {}'.format(test_val.type.name))


def function_disassembly(func_addr, arch=None, use_fallback=True):
    '''Return the disassembly and filename of the function at `func_addr`.

    If there are no debugging symbols, return the None as the filename.
        (function_disassembly, function_name or None, function_filename or None)

    If we have debugging information, but we can't find a function at the
    address specified, we return '' for the function_name and
    function_filename.

    If `use_fallback` is set to False, and there is are no debugging symbols
    for the current function, return (None, None, None).

    '''
    arch = arch or gdb.current_arch()

    try:
        func_block = get_function_block(func_addr)
    except RuntimeError as e:
        if e.args != ('Cannot locate object file for block.', ):
            raise e
    else:
        orig_block = func_block
        # This has happened a few times -- find out why/when.
        # When the file was compiled without debugging.
        if func_block is None:
            print(func_addr)

        # Often enough that it's a problem, despite being given the start of a
        # function as the address, we get a child block of the function.
        # Functions I've seen this happen with (all when inspecting a debug
        # build of neovim).
        #
        # src/valgrind.c je_valgrind_make_mem_undefined
        # src/valgrind.c je_valgrind_make_mem_defined
        # include/jemalloc/internal/atomic.h je_atomic_add_uint32
        #
        # I used the below to get this output.
        # if not func_block.function:
        #     print(func_addr)
        #     above = func_block.superblock.function
        #     if above:
        #         print(above.symtab.filename, above.name)

        while func_block and func_block.function is None:
            func_block = func_block.superblock

        if func_block:
            function_name = func_block.function.name
            function_filename = func_block.function.symtab.filename
        else:
            # Print this out for my information -- know when it happens so have
            # a chance to learn.
            print('Function not found at {}'.format(func_addr))
            func_block = orig_block
            function_name = ''
            function_filename = ''

        # No instruction is less than one byte.
        # If we provide an end point that is one byte less than the end of the
        # last instruction in the block, then this ends the disassembly on the
        # last instruction of the function.
        return (arch.disassemble(func_block.start, func_block.end-1),
                function_name,
                function_filename)

    if not use_fallback:
        return (None, None, None)

    # Fallback -- Use the gdb `disassemble` command to disassemble the entire
    # function, and find difference between the start and end of that function.

    # Rather than implementing a conversion function between a line in the
    # output of the `disassemble` command and a dictionary that matches the
    # output of the Architecture.disassemble() method, we just find the extent
    # of the current function with `disassemble {}`, and then return the list
    # made from Architecture.disassemble() directly.
    output = gdb.execute('disassemble {}'.format(func_addr), False, True)
    lines = output.splitlines()
    if not lines[0].startswith('Dump of assembler code for function'):
        raise RuntimeError('Failed to find function at {}'.format(func_addr))

    # Avoid the 'End of assembler dump.' line that is actually last.
    start_addr = int(lines[1].split()[0], base=16)
    last_pos = int(lines[-2].split()[0], base=16)
    function_name = re.search('Dump of assembler code for function (\S+):',
                              lines[0])
    function_name = function_name.groups()[0] if function_name else None
    return arch.disassemble(start_addr, last_pos), function_name, None


def func_and_offset(addr):
    '''Return the function and offset into that function of `addr`.

    If failed to find the function at the given address, return (None, None).

    '''
    # If given @plt addresses (or other problematic functions) just ignore
    # them and return an error message -- (better than raising an error?)
    try:
        block = get_function_block(addr)
    except RuntimeError as e:
        # If this is an exception we don't know about, raise.
        if e.args != ('Cannot locate object file for block.',):
            raise

        # Attempt to work with symbols that don't have debugging information.
        retval = gdb.execute('info symbol {}'.format(addr),
                            False, True)
        # Checking for section ".text" removes @plt stubs and variables.
        if 'in section .text' not in retval:
            print('{} is not a .text location'.format(addr))
            return (None, None)

        # At the moment I believe that all awkward output (i.e. of the form
        # funcname(function, argument, types) in section .text of /home/matthew/temp_dir/gdb/gdb/gdb
        # are avoided because when there is debug info we've used the alternate
        # method. Hence, the output should be of the form
        # <funcname> + <offset> in section .text of <objfile>
        # If this isn't the case, alert user so I know there's a problem and
        # can investigate what I've missed.
        #
        # NOTE: I believe that digits are always printed in decimal -- can't
        # find any way to change this, so I believe there isn't one.
        # If this isn't the case, then I hopefully will notice the problem when
        # this function fails.
        sym_match = re.match('(\S+)( \+ (\d+))? in section .text', retval)
        if not sym_match:
            print('Cannot parse output from command `info symbol {}`.'.format(
                addr))
            return (None, None)

        offset = int(sym_match.group(3)) if sym_match.group(3) else 0
        return (sym_match.group(1), offset)

    while block.function is None:
        if block.superblock:
            block = block.superblock
        else:
            raise gdb.GdbError('Could not find enclosing function of '
                                '{}'.format(addr))

    offset = addr - block.start
    return (block.function.name, offset)


@contextlib.contextmanager
def gdb_setting(name, setting):
    '''Context manager to ensure using a specific parameter for a given code
    block without affecting the users settings.

    NOTE: As yet only works on binary (on/off) parameters.
    NOTE: Be careful using this around code that can use users expressions.
          (A user may be surprised to find an expression behaving differently
          when run at the prompt and used in another command if e.g. the `print
          object` setting is changed).

    '''
    original = gdb.parameter(name)
    if original == True:
        original = 'on'
    elif original == False:
        original = 'off'

    # TODO Deal with other types in the future.
    gdb.execute('set {} {}'.format(name, setting))
    try:
        yield
    finally:
        gdb.execute('set {} {}'.format(name, original))
