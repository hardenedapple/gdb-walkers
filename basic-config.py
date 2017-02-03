import gdb
import os
import sys

if os.getenv('TERM') == 'dumb':
    gdb.execute('set pagination off')

if '~/.config/gdb/' not in sys.path:
    sys.path.append(os.path.expanduser('~/.config/gdb/'))

