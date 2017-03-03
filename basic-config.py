import gdb
import os
import sys

if os.getenv('TERM') == 'dumb':
    gdb.execute('set pagination off')

confdir = os.path.expanduser('~/.config/gdb')
if confdir not in sys.path:
    sys.path.append(confdir)

gdb.execute('add-auto-load-safe-path {}/autoloads'.format(confdir))
gdb.execute('add-auto-load-scripts-directory {}/autoloads'.format(confdir))
