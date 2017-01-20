'''
Introduce a `shellpipe` command.

This command splits the gdb command line at an unquoted exclamation mark `!`,
into a gdb command and a shell command.
It then runs the gdb command, and pipes the input into the shell command.
If the shell command prints to stdout or stderr that is printed to the screen.

It hence allows commands along the lines of
    (gdb) shellpipe disassemble main ! grep mov

'''
import gdb
import subprocess as sp

class ShellPipe(gdb.Command):
    '''Pass the output of a gdb command into a shell command.
    `shellpipe` pipes the output of a gdb command into a shell command.

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


ShellPipe()
