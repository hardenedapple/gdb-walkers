import gdb
import os
import sys
import importlib

if os.getenv('TERM') == 'dumb':
    gdb.execute('set pagination off')


confdir = os.path.expanduser('~/.config/gdb')
if confdir not in sys.path:
    sys.path.append(confdir)
del confdir

gdb.objfile_name = None

def importer(event):
    '''Emulates gdb auto-load scripts-directory but matches on basename.

    The provided auto-load functionality requires a full pathname match, so
    that a script to be loaded on debugging /full/path/to/debug/program must be
    placed in autoload-directory/full/path/to/debug/program-gdb.extension .

    This function means that you just need to create a file
    autoload-directory/program-gdb.py.

    '''
    progname = event.new_objfile.filename
    # Would like to use the gdb.current_objfile() function, but since I can't
    # use autoloading (because I need the entire filename instead of just the
    # basename), I have to manually store the current program file somewhere.
    gdb.objfile_name = progname
    matchname = os.path.basename(progname) + '-gdb.py'
    confdir = os.path.expanduser('~/.config/gdb')
    source_file = '{}/autoimports/{}'.format(confdir, matchname)
    # We check the file exists to avoid unnecessary output.
    # This could be done by taking all output (by passing True to gdb.execute)
    # and then throwing it away, but we want to show error messages to the
    # user.
    if os.path.exists(source_file):
        gdb.execute('source {}'.format(source_file), False, False)
    gdb.objfile_name = None


gdb.events.new_objfile.connect(importer)

import walkers
import walker_defs
