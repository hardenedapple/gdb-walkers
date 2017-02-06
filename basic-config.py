import gdb
import os
import sys

if os.getenv('TERM') == 'dumb':
    gdb.execute('set pagination off')

if '~/.config/gdb/' not in sys.path:
    sys.path.append(os.path.expanduser('~/.config/gdb/'))


if not hasattr(gdb, 'current_arch'):
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
    del cur_arch
