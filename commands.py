'''
Miscellaneous gdb helper commands.


The commands defined here are:
    `shellpipe`
    `attach-matching`
    `whereami`

'''
import subprocess as sp
import re
import gdb
import helpers
from helpers import eval_int, function_disassembly


class ShellPipe(gdb.Command):
    '''Pass the output of a gdb command into a shell command.

    This command splits the gdb command line at an unquoted exclamation mark
    `!`, into a gdb command and a shell command.
    It then runs the gdb command, and pipes the input into the shell command.
    If the shell command prints to stdout or stderr that is printed to the
    screen.

    It hence allows commands along the lines of
        (gdb) shellpipe disassemble main ! grep mov

    '''
    def __init__(self):
        super(ShellPipe, self).__init__('shellpipe', gdb.COMMAND_USER)

    def invoke(self, arg, _):
        # XXX allow escaped `!` chars to be used in the gdb command.
        gdb_command, shell_command = arg.split('!', 1)
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
        func_addr = eval_int(''.join(args[:-1]))
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
        gdb.execute('pipe hypothetical-call-stack | show wheresthis {} | devnull')
        print()


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
        curfp = eval_int('$rbp')
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
        pos = eval_int('$pc')
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
        return 'call-graph will {}ignore non-debug symbols'.format(
            'not ' if self.value else '')

    def get_show_string(self, curval):
        return curval + ': ' + self.get_set_string()


def retpoints(addr, arch):
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


def add_tracers(regexp):
    'Trace all functions matching `regexp` in the current symbol table.'
    # Ensure we never end up with duplicate traced points (which would mess up
    # our output).
    remove_tracers(regexp)
    arch = gdb.current_arch()
    # If the symbol is non-debug, use the direct memory address location.
    # Otherwise use symbolic names so we can see what's happening.
    #
    # We have to disassemble based on the address to distinguish non-debug
    # symbols with the same name, in our `function_disassembly()` function.
    #
    # In order to have nice output, we create a string that describes the
    # function properly -- though non-debug symbols with the same name will
    # have the same output for entry tracepoints.
    file_regex = '.*' if gdb.parameter('call-graph-nondebug') else '.+'
    # Avoid duplicate symbols -- very often happens in non-debug
    # symbols where the same function has many names (e.g.
    # __GI___libc_longjmp, __libc_longjmp, __libc_siglongjmp, _longjmp,
    # longjmp, siglongjmp) all have the same address.
    seen_addresses = set()
    for symbol in gdb.search_symbols(regexp, file_regex):
        addr = int(symbol.value().cast(helpers.uintptr_t))

        if addr in seen_addresses:
            continue
        seen_addresses.add(addr)

        # Use hex just because it's pretty for `info call-graph exact`.
        entry_loc, func_name = '*{}'.format(hex(addr)), symbol.name
        CallGraph.entry_breakpoints.append(EntryBreak(entry_loc, func_name))
        for retloc, retdesc in retpoints(addr, arch):
            CallGraph.return_breakpoints.append(ReturnBreak(retloc, retdesc))


def remove_tracers(regexp):
    'Remove all trace points matching `regexp` in the CallGraph class lists.'
    remaining_entry_bps = []

    for bp in CallGraph.entry_breakpoints:
        if re.match(regexp, bp.location):
            bp.delete()
        else:
            remaining_entry_bps.append(bp)

    remaining_return_bps = []
    for bp in CallGraph.return_breakpoints:
        func_name = bp.location[1:bp.location.rfind('+')]
        if re.match(regexp, func_name):
            bp.delete()
        else:
            remaining_return_bps.append(bp)

    CallGraph.entry_breakpoints = remaining_entry_bps
    CallGraph.return_breakpoints = remaining_return_bps


class EntryBreak(gdb.Breakpoint):
    '''Subclass of gdb.Breakpoint that never stops execution and prints the
    current function indentation.

    This class prints a string representing _entering_ a function and adds an
    indentation level from the CallGraph data.

    '''
    def __init__(self, loc, func_name):
        super(EntryBreak, self).__init__(loc, gdb.BP_BREAKPOINT,
                                         -1, True, False)
        self.func_name = func_name

    def stop(self):
        CallGraph.indent_level += 4
        print('{} --> {}'.format(' '*CallGraph.indent_level, self.func_name))
        return False


class ReturnBreak(gdb.Breakpoint):
    '''Subclass of gdb.Breakpoint that never stops execution and prints the
    current function indentation.

    This class prints a string representing _exiting_ a function and removes an
    indentation level from the CallGraph data.

    '''
    def __init__(self, loc, desc):
        super(ReturnBreak, self).__init__(loc, gdb.BP_BREAKPOINT,
                                          -1, True, False)
        self.desc = desc

    def stop(self):
        print('{} <-- {}'.format(' '*CallGraph.indent_level, self.desc))
        CallGraph.indent_level -= 4
        return False


class CallGraph(gdb.Command):
    '''Prefix command for call graph tracing commands.'''
    entry_breakpoints = []
    return_breakpoints = []
    indent_level = 0

    @classmethod
    def clear_previous_breakpoints(cls):
        for bp in cls.entry_breakpoints:
            bp.delete()
        cls.entry_breakpoints = []
        for bp in cls.return_breakpoints:
            bp.delete()
        cls.return_breakpoints = []
        cls.indent_level = 0

    def __init__(self):
        super(CallGraph, self).__init__('call-graph', gdb.COMMAND_USER,
                                        gdb.COMPLETE_COMMAND, True)


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
        add_tracers(arg)


class CallGraphUpdate(gdb.Command):
    '''Add or remove tracers matching REGEXP.

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

    Usage:
        call-graph update [+ | -] REGEXP

    '''
    def __init__(self):
        super(CallGraphUpdate, self).__init__('call-graph update',
                                              gdb.COMMAND_USER)

    def invoke(self, arg, _):
        args = gdb.string_to_argv(arg)
        if len(args) != 2:
            raise ValueError('call-graph update must have two arguments')

        if args[0] not in ['+', '-']:
            raise ValueError('Usage: call-graph update [+ | -] REGEXP')

        if args[0] == '+':
            add_tracers(args[1])
            return

        remove_tracers(args[1])


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
            for bp in CallGraph.entry_breakpoints:
                print('\t', bp.location.strip('*'))
            return

        for bp in CallGraph.entry_breakpoints:
            print('\t', bp.func_name)


AttachMatching()
ShellPipe()
GlobalUsed()
PrintHypotheticalStack()
CallGraph()
CallGraphClear()
CallGraphInit()
CallGraphUpdate()
CallGraphInfo()
CallGraphNonDebug()
