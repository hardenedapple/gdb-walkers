import gdb
import subprocess as sp
import re

class AttachMatching(gdb.Command):
    '''
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


AttachMatching()
