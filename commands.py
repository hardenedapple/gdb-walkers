'''
Miscellaneous gdb helper commands.


The commands defined here are:
    `shellpipe`
    `attach-matching`
    `whereami`

'''
import gdb
import subprocess as sp
import re
from helpers import eval_int

# TODO
#   Why does gdb.lookup_global_symbol() not find global variables.
#   So far it only appears to find function names.
#
#   Get current architecture without having started the process.
#
#   Find length of a pointer without having started the process.

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
        arch = gdb.selected_frame().architecture()
        func_addr = eval_int(''.join(args[:-1]))
        # Let possible error raise -- user needs to know something went wrong.
        func_block = gdb.block_for_pc(func_addr)
        if not func_block:
            print('Block for {} could not be found'.format(
                ''.join(args[:-1])))
            return

        glob_name = args[-1]
        # Since func_block.end is where the block ends, this is *after* the
        # last instruction (usually a ret).
        # Hence, we should ignore the last instruction given from the
        # disassembly as this is after the last instruction of the function.

        glob_uses = [
            self.make_info(val) for val in
            arch.disassemble(func_block.start, func_block.end)[:-1]
            if val['asm'].split()[-1] == '<{}>'.format(glob_name)
        ]

        if glob_uses:
            print('"{}" uses "{}" in the following places'.format(
                func_block.function.name, glob_name))
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


class FuncGraph(gdb.Command):
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
    def __init__(self):
        super(FuncGraph, self).__init__('func-graph', gdb.COMMAND_USER)
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

        print_str = '{}{}{}{} {}:{}'.format( ' '*curindent, direction_string,
                                            block.function.name, offset_str,
                                            line.symtab.filename, line.line)

        print(print_str)


AttachMatching()
ShellPipe()
GlobalUsed()
PrintHypotheticalStack()
