import gdb
import os
import sys

if os.getenv('TERM') == 'dumb':
    gdb.execute('set pagination off')

curdirectory = os.path.dirname(os.path.realpath(__file__))
if curdirectory not in sys.path:
    sys.path.append(curdirectory)
del curdirectory

