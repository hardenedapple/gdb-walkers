import gdb
import os

if os.getenv('TERM') == 'dumb':
    gdb.execute('set pagination off')
