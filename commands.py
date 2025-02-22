'''
Miscellaneous gdb helper commands.


The commands defined here are:
    `shellpipe`
    `attach-matching`
    `whereami`

'''
import subprocess as sp
from collections import defaultdict
import operator
import re
import gdb
from helpers import (eval_uint, function_disassembly, func_and_offset,
                     file_func_split, as_uintptr, FakeSymbol,
                     search_symbol_wrapper)


class ShellPipe(gdb.Command):
    '''Pass the output of a gdb command into a shell command.

    This command splits the gdb command line at an unquoted exclamation mark
    `!`, into a gdb command and a shell command.
    It then runs the gdb command, and pipes the input into the shell command.
    If the shell command prints to stdout or stderr that is printed to the
    screen.

    N.B. in recent versions of GDB this is superceded by the in-built `pipe`
    command.

    It hence allows commands along the lines of
        (gdb) shellpipe disassemble main ! grep mov

    '''
    def __init__(self):
        super(ShellPipe, self).__init__('shellpipe', gdb.COMMAND_USER)

    def invoke(self, arg, _):
        # XXX allow escaped `!` chars to be used in the gdb command.
        # Currently handling this by ensuring any `!` not meant for seperating
        # commands is right next to another character.
        gdb_command, shell_command = arg.split(' ! ', 1)
        gdb_command = gdb_command.strip()
        shell_command = shell_command.strip()

        shell_input = gdb.execute(gdb_command, False, True)

        completed_handle = sp.run(shell_command,
                                  input=shell_input,
                                  stdout=sp.PIPE, stderr=sp.PIPE,
                                  shell=True,
                                  universal_newlines=True)
        print(completed_handle.stdout, end='')
        if completed_handle.stderr:
            print('\nSTDERR\n{}'.format(completed_handle.stderr), end='')
        if completed_handle.returncode != 0:
            print('\nShell process returned with exit code: '
                  '{}'.format(completed_handle.returncode))


class AttachMatching(gdb.Command):
    '''Attach to a process whose arguments match a regular expression.

    `attach-matching` searches for processes whose command line matches an
    argument. If there is only one matching process, attach to it, otherwise
    print out the process ID's and command lines of each process.

    Usage:
        attach-matching vim test_file.txt
        attach-matching xterm .+sh

    '''

    def __init__(self):
        super(AttachMatching, self).__init__('attach-matching',
                                             gdb.COMMAND_RUNNING)

    def invoke(self, arg, _):
        self.dont_repeat()
        argv = gdb.string_to_argv(arg)
        process = argv[0]
        search_pattern = ' '.join(argv[1:])

        matching_processes = []
        # TODO pgrep output doesn't contain information about whether spaces
        # are there because an argument has spaces in it or there to make the
        # output look pretty.
        # I could do extra parsing by checking /proc/<pid>/cmdline directly and
        # removing the process name from what I'm comparing to a regular
        # expression, but I don't think that's too useful.
        processes = sp.check_output(['pgrep', '-a', process]).splitlines()
        for pid, cmdline in [val.decode('utf-8').split(None, maxsplit=1)
                             for val in processes]:
            if re.search(search_pattern, cmdline):
                matching_processes.append((pid, cmdline))

        if len(matching_processes) == 1:
            gdb.execute('attach {}'.format(matching_processes[0][0]))
        else:
            print(len(matching_processes), ' matching processes')
            for pid, cmdline in matching_processes:
                print(pid, cmdline)


class GlobalUsed(gdb.Command):
    '''Is a given global used in a function

    Takes either the memory address of a function, or the symbol referring to a
    function and prints out all uses of a global symbol in that function.

    NOTE:
        Far from perfect.
        Can't see indirect addressing, (i.e.
        myvar = &global_var; call_func(myvar); ) nor can it see direct
        assembly addressing (i.e. "movabs" ).

        It's really quite useful though -- which is why this flawed
        implementation is kept around.

    Usage:
        global-used [function-name | function-address] [global name]

    '''
    def __init__(self):
        super(GlobalUsed, self).__init__(
            'global-used', gdb.COMMAND_FILES, gdb.COMPLETE_SYMBOL)

    # TODO
    #   gdb misses the direct encoding of a global variable.
    #   I would like to change that.
    '''
    Questions:
      Does gdb miss direct encoding of a global variable?
      Answer: Yes
      Proof:
          Everything is compiled with gcc 6.3.1  gcc -Wall -W -g ~/test.c -o ~/test
          With the test file (n.b may act strangely -- I haven't made any
          real attempt to ensure it makes sense, just to proove the point).
              #include <stdio.h>
              #include <stdlib.h>

              static int glob_var;

              void asm_set_val()
              {
                  // movabs should load from the given instruction into rax (see below)
                  // http://stackoverflow.com/questions/19415184/load-from-a-64-bit-address-into-other-register-than-rax
                  asm ("movabs 0x601034, %%rax\n\t"
                          : :);
              }


              int main()
              {
                  asm_set_val();
                  printf("The global variable is: %d\n", glob_var);
                  return 0;
              }


          Do the following:

              vshcmd: > # Testing whether gdb notices direct addressing.
              vshcmd: > gdb ~/test
              Reading symbols from /home/matthew/test...done.
              (gdb)
              vshcmd: > start
              Temporary breakpoint 1 at 0x40050b: file /home/matthew/test.c, line 15.
              Starting program: /home/matthew/test

              Temporary breakpoint 1, main () at /home/matthew/test.c:15
              warning: Source file is more recent than executable.
              15	int main()
              (gdb)
              vshcmd: > print &glob_var
              $1 = (int *) 0x601034 <glob_var>
              (gdb)
              vshcmd: > disassemble asm_set_val
              Dump of assembler code for function asm_set_val:
                 0x00000000004004f6 <+0>:	push   %rbp
                 0x00000000004004f7 <+1>:	mov    %rsp,%rbp
                 0x00000000004004fa <+4>:	movabs 0x601034,%rax
                 0x0000000000400504 <+14>:	nop
                 0x0000000000400505 <+15>:	pop    %rbp
                 0x0000000000400506 <+16>:	retq
              End of assembler dump.
              (gdb)
              vshcmd: > detach
              Detaching from program: /home/matthew/test, process 31978
              The global variable is: 0
              (gdb)


          While with the following test file

             #include <stdio.h>
             #include <stdlib.h>

             static int glob_var;

             void asm_set_val(int src)
             {
                 glob_var = src;
             }


             int main()
             {
                 asm_set_val(10);
                 printf("The global variable is: %d\n", glob_var);
                 return 0;
             }

          Do the same to show it can pick things up.
              vshcmd: > # Testing whether gdb notices direct addressing.
              vshcmd: > gdb ~/test
              Reading symbols from /home/matthew/test...done.
              (gdb)
              vshcmd: > start
              Temporary breakpoint 1 at 0x40050d: file /home/matthew/test.c, line 14.
              Starting program: /home/matthew/test

              Temporary breakpoint 1, main () at /home/matthew/test.c:14
              14	    asm_set_val(10);
              (gdb)
              vshcmd: > print &glob_var
              $1 = (int *) 0x601034 <glob_var>
              (gdb)
              vshcmd: > disassemble asm_set_val
              Dump of assembler code for function asm_set_val:
                 0x00000000004004f6 <+0>:	push   %rbp
                 0x00000000004004f7 <+1>:	mov    %rsp,%rbp
                 0x00000000004004fa <+4>:	mov    %edi,-0x4(%rbp)
                 0x00000000004004fd <+7>:	mov    -0x4(%rbp),%eax
                 0x0000000000400500 <+10>:	mov    %eax,0x200b2e(%rip)        # 0x601034 <glob_var>
                 0x0000000000400506 <+16>:	nop
                 0x0000000000400507 <+17>:	pop    %rbp
                 0x0000000000400508 <+18>:	retq
              End of assembler dump.
              (gdb)
              vshcmd: > detach
              Detaching from program: /home/matthew/test, process 32009
              (gdb) The global variable is: 10
    '''
    @staticmethod
    def make_info(instruction):
        address = gdb.execute('output/a {}'.format(instruction['addr']),
                              False, True)
        return address + '\t' + instruction['asm']

    def invoke(self, arg, _):
        args = gdb.string_to_argv(arg)
        func_addr = eval_uint(''.join(args[:-1]))
        # Let possible error raise -- user needs to know something went wrong.
        func_dis, func_name, func_file = function_disassembly(func_addr)
        glob_name = args[-1]

        glob_uses = [
            self.make_info(val) for val in func_dis
            if val['asm'].split()[-1] == '<{}>'.format(glob_name)
        ]

        if glob_uses:
            print('"{}" uses "{}" in the following places'.format(
                func_name, glob_name))
            print('\n'.join(glob_uses))


class PrintHypotheticalStack(gdb.Command):
    '''Print each function name and file position in hypothetical call stack.

    NOTE:
        This command doesn't print the addresses where things were called, but
        the address of each function that was called. This makes things much
        simpler in the implementation of the `called-functions` walker.

    '''
    def __init__(self):
        super(PrintHypotheticalStack, self).__init__('hypothetical-stack',
                                                     gdb.COMMAND_DATA)

    def invoke(self, arg, _):
        if arg and arg.split() != []:
            raise ValueError('hypothetical-stack takes no arguments')
        gdb.execute('gdb-pipe hypothetical-call-stack | show whereis $cur | devnull')
        print()


class PrintString(gdb.Command):
    '''Print a string without quotation marks and without allocating memory.

    The gdb command `printf "%s\\n", $_as_string(<something>)` allocates memory
    in the inferior, and you have no reference with which to free it.

    In order to avoid this you can do things like
        set variable $tmpvar = (char *)$_as_string(<something>)
        printf "%s\\n", $tmpvar
        call free($tmpvar)
    but this means you have $tmpvar in the gdb environment.

    Commands such as `output` and `print` print the text with surrounding
    quotes to show this is a string.

    This `print-string` command prints each string argument without any
    surrounding quotes and without putting the string into the inferior.

    Some other differences to `printf` are:
        `print-string` prints non-printable characters backslash escaped
        instead of directly.
        `print-string` can handle NULL pointers (and some other problematic
        pointers) by simply printing out 'UNK <invalid pointer>'.

    Use:
        print-string <string arg1>; <string arg2>; ...

    Example:
        print-string $_as_string($pc); "  is at function  "; $_function_of($pc)

    '''
    def __init__(self):
        super(PrintString, self).__init__('print-string', gdb.COMMAND_DATA)

    def parse_args(self, arg):
        in_string = False
        retargs = []
        curarg = []
        for char in arg:
            if char == '"':
                in_string = not in_string
            if char == ';' and not in_string:
                retargs.append(''.join(curarg))
                curarg = []
                continue
            curarg.append(char)

        if curarg:
            retargs.append(''.join(curarg))
            curarg = []
        return [val.strip() for val in retargs if val.strip()]

    def invoke(self, arg, _):
        args = self.parse_args(arg)
        for argument in args:
            try:
                tmp = gdb.parse_and_eval(argument)
            except gdb.error as e:
                # Assume whatever error in parsing happens is because we're
                # given a literal string.
                raise ValueError(
                    'Failed to parse `{}` as a gdb value'.format(argument))

            try:
                value = tmp.string(errors='backslashreplace')
            except gdb.MemoryError as e:
                if e.args[0].startswith(
                    'Cannot access memory at address'):
                    value = 'UNK {}'.format(tmp)
                else:
                    raise
            except gdb.error as e:
                if e.args[0].startswith(
                    'Trying to read string with inappropriate type'):
                    value = str(tmp)
                else:
                    raise

            print(value, end='')


# Alternate thoughts about FuncGraph
#
#   Questions:
#       How are the gdb `finish` statements implemented?
#       What about the dtrace return probes?
#           NOTE these include the position where the return instruction came?
#           If I read the manual correctly, this is just the position of the
#           ret instruction, not the position in the source code of the
#           `return` statement.
#           http://docs.oracle.com/cd/E19253-01/817-6223/chp-fbt/index.html
#       stap return probes?
#           watching the frame pointer $rbp?
#           looking at the return address stored in the stack, and setting a
#             breakpoint there? (would this break if calling that function
#             recursively?)
#           Finding all `ret` instructions of the function and placing
#             breakpoints there?
#
#
#   Given a regexp, iterate through all functions in the symtab and on each
#   function that matches put a break point.
#
#   Returning breakpoints are the problem.
#   I am thinking of three different options
#       1)  Don't do anything about them.
#           On each breakpoint, search the current stack, if that function isn't
#           at that position in the stack (known by looking at the stack
#           pointer), then it must have returned in the intervening time.
#
#           Problems:
#               The last set of returns won't be printed
#               This could be overcome by putting a listener on gdb.events.stop
#
#       2)  disassemble the function and put a breakpoint on the return
#           instruction.
#           When the return instruction is hit, print a "leaving" thing.
#
#           Problems:
#               At the moment (because there isn't any way to access the
#               minimal_symbol structures inside gdb) we need debugging
#               information.
#
#       3)  Make a "finish" breakpoint for the current frame.
#           This would print the "leaving" thing.
#
#           Problems:
#               Same as above -- how to define the command.
#               Would have to make a breakpoint each time a given function is
#               called (as opposed to previous ones that don't).
#
#   My best answer is option (2) -- it is the fastest by far (though it has a
#   higher startup cost).
#   I've overcome the problem with defining what should happen on the command
#   by defining the `stop()` function to print what I want, and always return
#   False. This means I never actually stop, which makes it even faster!!

class FuncGraph1(gdb.Command):
    '''Continues the program, printing out the function call graph.

    Usage:
        func-graph

    Example;
        vshcmd: > gdb demos/tree
        vshcmd: > start  10
        vshcmd: > func-graph
        vshcmd: > watch $rbp
        vshcmd: > command 2
        vshcmd: > silent
        vshcmd: > func-graph
        vshcmd: > cont
        vshcmd: > end
        vshcmd: > cont

    '''
    # NOTE Don't use this
    #   It's really slow.
    #   It has a terrible user interface
    #   It probably has a bunch of missed edge cases.
    #   I only wrote it to see if it would work.
    #   There's a much better option below (call-graph and its subcommands).
    def __init__(self):
        super(FuncGraph1, self).__init__('func-graph', gdb.COMMAND_USER)
        self.indent = 0
        self.fp_stack = []

    def update_fp_stack(self):
        '''Update fp stack according to if $fp was seen before.

        Return False if $fp was seen before (and hence if we think we are
        leaving a function), True otherwise.

        '''
        curfp = eval_uint('$rbp')
        if not self.fp_stack or curfp < self.fp_stack[-1]:
            self.fp_stack.append(curfp)
            return True

        # The frame pointer decreases upon entering a new function, and
        # increases otherwise.
        # Because strange things can happen with the indirected @plt functions,
        # we take all frame pointers that are below the current one off our
        # stack.
        self.fp_stack.pop()
        return False

    def invoke(self, *_):
        pos = eval_uint('$pc')
        line = gdb.find_pc_line(pos)
        if not line.symtab:
            return

        try:
            block = gdb.block_for_pc(pos)
        except RuntimeError as e:
            if e.args == ('Cannot locate object file for block.',):
                return
            raise

        if block.function is None:
            print('First found block no function', pos)
            return
        while block.function.name is None:
            if block.superblock:
                block = block.superblock
            else:
                print('No superblock at', pos)
                return
            if block.function is None:
                print('Function iterated to None in', pos)
                return

        offset = pos - block.start
        offset_str = '+{}'.format(offset) if offset else ''

        entering = self.update_fp_stack()

        if entering:
            curindent = self.indent
            self.indent += 4
            direction_string = '-->'
        else:
            self.indent -= 4
            curindent = self.indent
            direction_string = '<--'

        print_str = '{}{}{}{} {}:{}'.format(' '*curindent, direction_string,
                                            block.function.name, offset_str,
                                            line.symtab.filename, line.line)

        print(print_str)


# NOTE: Would like to have the call-graph-* parameters set as COMMAND_USER to
# match the call-graph command, but this is an "Invalid command class argument"
# and raises a RuntimeError.
class CallGraphDynlibs(gdb.Parameter):
    '''Should `call-graph` trace symbols in dynamic libraries.

    Boolean - true => trace dynamic library functions.
              false => do not trace dynamic library functions.

    '''
    def __init__(self):
        super(CallGraphDynlibs, self).__init__('call-graph-dynlibs',
                                                gdb.COMMAND_NONE,
                                                gdb.PARAM_BOOLEAN)

    def get_set_string(self):
        return 'call-graph will {}include dynamic libraries'.format(
            '' if self.value else 'not ')

    def get_show_string(self, curval):
        return curval + ': ' + self.get_set_string()


class CallGraphNonDebug(gdb.Parameter):
    '''Should `call-graph` include non-debug symbols.

    Boolean - true => use non-debug symbols.
              false => ignore non-debug symbols.

    '''
    def __init__(self):
        super(CallGraphNonDebug, self).__init__('call-graph-nondebug',
                                                gdb.COMMAND_NONE,
                                                gdb.PARAM_BOOLEAN)

    def get_set_string(self):
        return 'call-graph will {} non-debug symbols'.format(
            'use' if self.value else 'ignore')

    def get_show_string(self, curval):
        return curval + ': ' + self.get_set_string()


class CallGraphEnabled(gdb.Parameter):
    '''Should `call-graph` be active?

    Boolean: true => `call-graph` breakpoints are enabled.
             false => `call-graph` breakpoints are disabled.

    '''
    def __init__(self):
        super(CallGraphEnabled, self).__init__('call-graph-enabled',
                                               gdb.COMMAND_NONE,
                                               gdb.PARAM_BOOLEAN)
        # Default is enabled
        self.value = True

    def set_call_graph_activity(self):
        '''Disable all breakpoints for the call-graph command'''
        for addr in CallGraph.entry_breaks.keys():
            CallGraph.entry_breaks[addr].enabled = self.value
            try:
                for bp in CallGraph.ret_breaks[addr]:
                    bp.enabled = self.value
            except KeyError:
                raise RuntimeError('Tracer in entry dict, not in return dict'
                                    ': {}'.format(addr))

    def get_set_string(self):
        self.set_call_graph_activity()
        return 'call-graph tracing is {}'.format(
            'enabled' if self.value else 'disabled')

    def get_show_string(self, curval):
        return curval + ': ' + self.get_set_string()


class CallGraphOutput(gdb.Parameter):
    '''File call-graph should write to or 'stdout'.

    When set, this value determines where call-graph writes its output to.
    i.e. `set call-graph-output trace.txt`
    means that future call-graph output will go into trace.txt.

    Note: output will be appended to the file.
    If you want to truncate the file between uses, use the shell.
        `(gdb) !: > trace.txt`

    '''
    def __init__(self):
        super(CallGraphOutput, self).__init__(
            'call-graph-output', gdb.COMMAND_NONE, gdb.PARAM_STRING)
        # Default
        self.value = 'stdout'

    def redirect_output(self):
        old_file = CallGraph.output_file
        if self.value == 'stdout':
            CallGraph.output_file = sys.stdout
        else:
            new_file = open(self.value, 'a')
            CallGraph.output_file = new_file

        if old_file != sys.stdout:
            old_file.close()

    def get_set_string(self):
        self.redirect_output()
        return 'call-graph trace output directed to {}'.format(self.value)

    def get_show_string(self, curval):
        return self.get_set_string()


class CallGraph(gdb.Command):
    '''Prefix command for call graph tracing commands.

    These tracing commands put an internal breakpoint on the entry point and
    exit point of each function specified on the command line.
    The breakpoints print an indentation representing the current function
    nesting level, an arrow indicating whether this is an entry or exit point,
    and the function name that is currently being entered/exited.

    The format of regular expressions for this command is
        file_regex:func_regex
    If `file_regex` matches the empty string '', then non-debugging symbols are
    searched too.

    If there is no colon in the pattern then the pattern is treated solely as a
    function regex.
    In this case all files are used, and whether non-debugging symbols are used
    or not depends on the value of `call-graph-nondebug`.
    The `call-graph-nondebug` parameter may be set with the gdb `set` command.

    You can disable and enable the call-graph tracing by setting the parameter
    `set call-graph-enabled [on|off]`.

    `call-graph` output may be directed to a file with
    `set call-graph-output [file]`, and back to stdout with
    `set call-graph-output stdout`.
    When being directed to a file the output is buffered, one way to ensure
    buffered output is writted to disk is by directing the output back to the
    same file.

    By default, call-graph ignores functions in the dynamic libraries (i.e.
    libc etc). This can be configured using `set call-graph-dynlib`.

    '''
    entry_breaks = {}
    ret_breaks = {}
    indent_level = 0
    output_file = sys.stdout

    @classmethod
    def do_trace(cls, message):
        cls.output_file.write(message)
        cls.output_file.write('\n')

    @classmethod
    def clear_previous_breakpoints(cls):
        # Can't iterate over the keys directly because we're modifying the
        # dictionary, the keys() method returns a view into it, and modifying a
        # structure while iterating over it will raise an exception.
        all_addresses = list(cls.entry_breaks.keys())
        for addr in all_addresses:
            remove_addr_trace(addr)

        cls.indent_level = 0

    def __init__(self):
        super(CallGraph, self).__init__('call-graph', gdb.COMMAND_USER,
                                        gdb.COMPLETE_COMMAND, True)


def fn_return_addresses(addr, arch):
    '''Return a list of addresses for all ret instructions in function `symbol`

    Disassembles the function that `symbol` refers to, and returns a list of
    the position of those return instructions in a format ready for creating a
    breakpoint with.
    The specific format returned is `*<symbol-name>+<offset>`.

    '''
    func_dis, func_name, _ = function_disassembly(addr, arch)
    start = func_dis[0]['addr']
    description = lambda val: func_name + '+{}'.format(val['addr'] - start)
    location = lambda val: '*{}'.format(val['addr'])
    return [(location(val), description(val))
            for val in func_dis if val['asm'].startswith('ret') ]


def add_tracer(symbol, arch):
    '''Trace the function defined by symbol.

    `symbol` should have a `value()` method, a `symtab.filename` member (i.e.
    a symtab member that itself has a filename member), and a `name` member.

    '''
    addr = int(as_uintptr(symbol.value()))

    # Use hex just because it's pretty for `info call-graph exact`.
    entry_loc, *names = ('*{}'.format(hex(addr)),
                         symbol.name, symbol.symtab.filename)

    # Avoid duplicate symbols by checking if the address already has a
    # breakpoint  -- very often happens in non-debug symbols where the same
    # function has many names (e.g. __GI___libc_longjmp, __libc_longjmp,
    # __libc_siglongjmp, _longjmp, longjmp, siglongjmp) all have the same
    # address.
    # This also means that if the given regexp matches functions already
    # traced, we don't end up with duplicate tracers.
    should_enable = gdb.parameter('call-graph-enabled')
    if addr not in CallGraph.entry_breaks:
        new_bp = EntryBreak(entry_loc, *names)
        new_bp.enabled = should_enable
        CallGraph.entry_breaks[addr] = new_bp
    if addr not in CallGraph.ret_breaks:
        new_bps = [
            ReturnBreak(retloc, retdesc, *names)
            for retloc, retdesc in fn_return_addresses(addr, arch)]
        for bp in new_bps:
            bp.enabled = should_enable
        CallGraph.ret_breaks[addr] = new_bps


def trace_matching_functions(regexp):
    'Trace all functions matching `regexp` in the current symbol table.'
    file_regex, func_regex = file_func_split(regexp)
    if file_regex is None:
        file_regex = '.*' if gdb.parameter('call-graph-nondebug') else '.+'

    arch = gdb.current_arch()
    # We have to break on address to distinguish symbols with the same name in
    # different files.
    #
    # In order to have nice output, we create a string that describes the
    # function for a human -- though symbols with the same name will have the
    # same output for entry tracepoints.
    for symbol in search_symbol_wrapper(func_regex, file_regex,
                                        gdb.parameter('call-graph-dynlibs')):
        add_tracer(symbol, arch)


def remove_addr_trace(del_addr):
    'Remove tracers on the function at `addr`.'
    # The following code would be more elegant, and should work in any
    # situation the data structures are allowed to get in.
    #
    # try:
    #     CallGraph.entry_breaks[del_addr].delete()
    #     del CallGraph.entry_breaks[del_addr]
    # except KeyError:
    #     return
    # for bp in CallGraph.ret_breaks[del_addr]:
    #     bp.delete()
    # del CallGraph.ret_breaks[del_addr]
    #
    # But I use the below to give warning if anything strange is happening.
    missing_key = False
    try:
        CallGraph.entry_breaks[del_addr].delete()
        del CallGraph.entry_breaks[del_addr]
    except KeyError:
        missing_key = True

    try:
        for bp in CallGraph.ret_breaks[del_addr]:
            bp.delete()
        del CallGraph.ret_breaks[del_addr]
    except KeyError:
        if not missing_key:
            raise RuntimeError('Tracer in entry dict not in return dict')
        return

    if missing_key:
        raise RuntimeError('Tracer in return dict, not in entry dict')


def remove_matching_tracers(regexp):
    'Remove all trace points matching `regexp` in the CallGraph class lists.'
    file_regex, func_regex = file_func_split(regexp)
    # If no file_regex given, remove *all* matching functions.
    # We don't predicate this on `call-graph-nondebug` because it's confusing
    # if non-debug functions aren't removed after changing the value.
    file_regex = '.*' if file_regex is None else file_regex

    entry_dels = [(addr, bp) for addr, bp in CallGraph.entry_breaks.items()
                  if re.match(func_regex, bp.func_name)
                  and re.search(file_regex, bp.filename)]

    for addr, _ in entry_dels:
        remove_addr_trace(addr)


class EntryBreak(gdb.Breakpoint):
    '''Subclass of gdb.Breakpoint that never stops execution and prints the
    current function indentation.

    This class prints a string representing _entering_ a function and adds an
    indentation level from the CallGraph data.

    '''
    def __init__(self, loc, desc, filename):
        super(EntryBreak, self).__init__(loc, gdb.BP_BREAKPOINT,
                                         -1, True, False)
        self.desc = desc
        self.func_name = desc
        self.filename = filename

    def stop(self):
        CallGraph.indent_level += 4
        CallGraph.do_trace('{} --> {}'.format(' '*CallGraph.indent_level, self.desc))
        return False


class ReturnBreak(gdb.Breakpoint):
    '''Subclass of gdb.Breakpoint that never stops execution and prints the
    current function indentation.

    This class prints a string representing _exiting_ a function and removes an
    indentation level from the CallGraph data.

    '''
    def __init__(self, loc, desc, func_name, filename):
        super(ReturnBreak, self).__init__(loc, gdb.BP_BREAKPOINT,
                                          -1, True, False)
        self.desc = desc
        self.func_name = func_name
        self.filename = filename

    def stop(self):
        CallGraph.do_trace('{} <-- {}'.format(' '*CallGraph.indent_level, self.desc))
        CallGraph.indent_level -= 4
        return False


class CallGraphClear(gdb.Command):
    '''Remove the current call-flow tracing breakpoints.

    This removes the current tracing implemented by `call-graph trace REGEXP`.
    After this has been called, no tracing will be implemented.

    Usage:
        call-graph clear

    '''
    def __init__(self):
        super(CallGraphClear, self).__init__('call-graph clear',
                                             gdb.COMMAND_USER)

    def invoke(self, *_):
        self.dont_repeat()
        CallGraph.clear_previous_breakpoints()


class CallGraphInit(gdb.Command):
    '''Trace execution flow through functions matching REGEXP.

    For the format of REGEXP, see `help call-graph`.

    This command is useful to view the flow of code as it is executed.
    Only one set of tracers may be active at one time.

    Usage:
        call-graph init REGEXP
        call-graph init REGEXP

    '''
    def __init__(self):
        super(CallGraphInit, self).__init__('call-graph init',
                                            gdb.COMMAND_USER)

    def invoke(self, arg, _):
        self.dont_repeat()
        CallGraph.clear_previous_breakpoints()
        trace_matching_functions(arg)


class CallGraphUpdate(gdb.Command):
    '''Add or remove tracers matching REGEXP.

    For the format of REGEXP, see `help call-graph`.

    This command is useful to incrementally update the functions currently
    traced. For example you might want to trace create_tree and free_tree but
    not create_random_tree, you can run the following commands:
        call-graph clear
        call-graph update + create_tree
        call-graph update + free_tree
    Or you can run:
        call-graph clear
        call-graph init .*_tree
        call-graph update - create_random_tree

    For when there are more than one function with the same name, you can pass
    the argument "exact" and a memory address instead of a regular expression.
    Memory addresses of currently traced functions can be seen with
        info call-graph exact

    Usage:
        call-graph update [+ | -] <REGEXP>
        call-graph update [+ | -] exact <address>

    '''
    usage_string = 'Usage: call-graph [+ | -] [<REGEXP> | exact <address>]'
    def __init__(self):
        super(CallGraphUpdate, self).__init__('call-graph update',
                                              gdb.COMMAND_USER)

    def update_exact(self, direction, addr):
        '''Add or remove a function from tracing that starts at a given memory
        address instead of whose name matches a regular expression.'''
        func_name, offset = func_and_offset(int(addr, base=0))
        # Checks we don't give an invalid address to remove_addr_trace(), or
        # add_tracer().
        if func_name is None or offset != 0:
            raise ValueError('{} does not start a function'.format(addr))

        if direction == '+':
            arch = gdb.current_arch()
            return add_tracer(FakeSymbol.from_valuestring(func_name, addr), arch)

        remove_addr_trace(int(addr, 0))

    def invoke(self, arg, _):
        args = gdb.string_to_argv(arg)
        if len(args) != 2 and len(args) != 3:
            raise ValueError(self.usage_string)

        if args[0] not in ['+', '-']:
            raise ValueError(self.usage_string)

        if len(args) == 3:
            assert args[1] == 'exact', self.usage_string
            self.update_exact(args[0], args[2])
            return

        if args[0] == '+':
            trace_matching_functions(args[1])
            return

        remove_matching_tracers(args[1])


class CallGraphInfo(gdb.Command):
    '''Print all functions currently traced with call-graph

    If given the `exact` argument, print the addresses of each entry
    breakpoint.

    This may be needed if there are multiple functions with the same name in
    your program (to avoid.
    '''
    def __init__(self):
        super(CallGraphInfo, self).__init__('info call-graph',
                                            gdb.COMMAND_STATUS)

    def invoke(self, arg, _):
        args = gdb.string_to_argv(arg)
        if len(args) > 1 or (len(args) == 1 and args[0] != 'exact'):
            raise ValueError('Usage: info call-graph [exact]')

        print('Functions currently traced by call-graph:')

        # If ask for exact location, print the address the breakpoint is at.
        if args:
            for bp in CallGraph.entry_breaks.values():
                print('\t', bp.location.strip('*'), '\t', bp.desc)
            return

        for bp in CallGraph.entry_breaks.values():
            print('\t', bp.desc)


class Stack():
    '''Representation of a gdb stack.

    '''
    def __init__(self, sym_list):
        self.sym_list = sym_list

    @classmethod
    def from_current_stack(cls):
        current_frame = gdb.selected_frame()
        function_stack = []
        while current_frame:
            function_stack.append(current_frame.function())
            current_frame = current_frame.older()
        return cls(function_stack)

    def _internal_hash(self):
        # Hash based on addresses of the functions
        # in the stack.
        return tuple(
            int(helpers.as_uintptr(symbol.value()))
            for symbol in self.sym_list)

    def __eq__(self, other):
        # NOTE
        #   We might be able to speed this function up by short-circuiting the
        #   evaluation (i.e. iterate over each value in each objects sym_list,
        #   checking if the address of each pair of symbols is equal, returning
        #   False on the first that isn't).
        return self._internal_hash() == other._internal_hash()

    def __str__(self):
        return '\n'.join(sym.name for sym in self.sym_list)

    def __hash__(self):
        return self._internal_hash().__hash__()


class StackStats(gdb.Command):
    '''Prefix command to do with counting stacks that have been seen.

    The idea behind this function is to provide something similar to a dtrace
    aggregation on stacks.

    One can put a breapoint on a given function that records the calling stack
    trace, then after a period of running the process view how many times that
    function was called and where from.

    '''
    saved_stacks = defaultdict(int)

    @classmethod
    def add_stack(cls, stack):
        cls.saved_stacks[stack] += 1

    @classmethod
    def clear_stacks(cls):
        cls.saved_stacks = defaultdict(int)

    def __init__(self):
        super(StackStats, self).__init__('stack-stats', gdb.COMMAND_STACK,
                                         gdb.COMPLETE_COMMAND, True)


class StackStatsRecord(gdb.Command):
    '''Add the current stack to the set of recorded stacks.

    Example:
        break some_function
        command
        if $_any_caller_matches('other_function')
        stack-stats display
        stack-stats clear
        else
        stack-stats record
        end
        end


    '''
    # TODO Maybe add an argument to add the stack from frame x to frame y?
    def __init__(self):
        super(StackStatsRecord, self).__init__('stack-stats record',
                                               gdb.COMMAND_USER)

    def invoke(self, *_):
        self.dont_repeat()
        StackStats.add_stack(Stack.from_current_stack())


class StackStatsDisplay(gdb.Command):
    '''Display the set of recorded stacks.'''
    def __init__(self):
        super(StackStatsDisplay, self).__init__('stack-stats display',
                                                gdb.COMMAND_USER)

    def invoke(self, *_):
        self.dont_repeat()
        for stack, count in sorted(StackStats.saved_stacks.items(),
                                   key=operator.itemgetter(1),
                                   reverse=True):
            print('### Stack seen', count, 'times:')
            print(stack)
            print()


class StackStatsClear(gdb.Command):
    '''Clear the recorded set of stacks.'''
    def __init__(self):
        super(StackStatsClear, self).__init__('stack-stats clear',
                                              gdb.COMMAND_USER)

    def invoke(self, *_):
        self.dont_repeat()
        StackStats.clear_stacks()


AttachMatching()
ShellPipe()
GlobalUsed()
PrintHypotheticalStack()
PrintString()
CallGraph()
CallGraphClear()
CallGraphInit()
CallGraphUpdate()
CallGraphInfo()
CallGraphNonDebug()
CallGraphDynlibs()
CallGraphEnabled()
CallGraphOutput()
StackStats()
StackStatsRecord()
StackStatsDisplay()
StackStatsClear()
