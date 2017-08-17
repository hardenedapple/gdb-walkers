import gdb
import os
import sys
from contextlib import suppress
import importlib

# TODO
#   Import `walkers` module properly.
#   Store the confdir variable in the `walkers` module.
#   Store the `gdb.walkers{}` dict in the `walkers` module.

if os.getenv('TERM') == 'dumb':
    gdb.execute('set pagination off')


gdb.confdir = os.path.expanduser('~/.config/gdb')
if gdb.confdir not in sys.path:
    sys.path.append(gdb.confdir)

gdb.objfile_name = None

# TODO
#   At the moment I don't know whether to use a MetaPathFinder or a
#   PathEntryFinder.
#   Characteristics I want are:
#       Can ensure import_module(x) isn't cached.
#       Can translate that call into something that does a non-standard import.
class AutoImportsFinder(importlib.abc.MetaPathFinder):
    @staticmethod
    def __get_filename():
        if gdb.objfile_name is None:
            raise ImportError
        gdb.confdir = os.path.expanduser('~/.config/gdb')
        matchname = os.path.basename(gdb.objfile_name) + '-gdb.py'
        return '{}/autoimports/{}'.format(gdb.confdir, matchname)

    def find_spec(self, fullname, path, target=None):
        if path == [gdb.confdir + '/autoimports']:
            actual_path = self.__get_filename()
            # Ignore the race condition here ...
            if os.path.exists(actual_path):
                return importlib.machinery.ModuleSpec(
                    fullname,
                    importlib.machinery.SourceFileLoader(fullname, actual_path),
                    origin=actual_path)
        return None


sys.meta_path.append(AutoImportsFinder())

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
    basename = os.path.basename(progname)
    # TODO Check whether we need a name here.
    #       We can't pass the name directly, which means we either need some
    #       escaping method or to be able to always hook into the same
    #       Finder/Loader.
    #       progname is already in gdb.objfile_name, which means the
    #       Finder/Loader already has access to it.
    #       If we can ensure the import machinery doesn't cache things and skip
    #       our special Finder/Loader, then we can just use the same string
    #       each time.
    #
    #   I believe a unique name is required ... in PEP302 it lists the
    #   responsibilities of load_module(), which icludes checking for an
    #   existing module object in sys.modules
    #   If I break that I expect there'll be a host of complications.
    load_name = 'autoimports.' + basename.replace('.', '_')
    with suppress(ModuleNotFoundError):
        importlib.import_module(load_name)
    gdb.objfile_name = None


gdb.events.new_objfile.connect(importer)

import walkers
import walker_defs
