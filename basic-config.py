import gdb
import os
import sys
from contextlib import suppress
import importlib

if os.getenv('TERM') == 'dumb':
    gdb.execute('set pagination off')

# A little bit of hacking ...
# I calculate an important variable in the "global" namespace so I can use
# "import" on the walkers.
# Once I've done that I store the variables in the walkers module so as not to
# pollute the "global" namespace.
# There's a bit of interplay between that module and this file, but it's fine,
# just think of them as the same package.
confdir = os.path.expanduser('~/.config/gdb')
if confdir not in sys.path:
    sys.path.append(confdir)

import walkers
import walker_defs

walkers.confdir = confdir
del confdir

# TODO
#   At the moment I don't know whether to use a MetaPathFinder or a
#   PathEntryFinder.
#   Characteristics I want are:
#       Can ensure import_module(x) isn't cached.
#       Can translate that call into something that does a non-standard import.
class AutoImportsFinder(importlib.abc.MetaPathFinder):
    '''A Finder for the import protocol.

    This Finder is implemented so that we can load files named e.g.
    libstdc++.so.6 in the autoimports/ directory.

    Without a specialised Finder we would have to have some sort of naming
    convention to remove '.' chars in the filename.
    The user would then have to store files as e.g. libstdc++_so_6

    '''
    @staticmethod
    def __get_filename():
        if walkers.objfile_name is None:
            raise ImportError
        matchname = os.path.basename(walkers.objfile_name) + '-gdb.py'
        return '{}/autoimports/{}'.format(walkers.confdir, matchname)

    def find_spec(self, fullname, path, target=None):
        if path == [walkers.confdir + '/autoimports']:
            actual_path = self.__get_filename()
            # Ignore the race condition here ...
            if os.path.exists(actual_path):
                return importlib.machinery.ModuleSpec(
                    fullname,
                    importlib.machinery.SourceFileLoader(fullname, actual_path),
                    origin=actual_path)
        return None


sys.meta_path.append(AutoImportsFinder())

# Import just the package ... this allows us to store things off that package
# That's good because that's where the data makes sense to be.
import autoimports
def importer(event):
    '''Emulates gdb auto-load scripts-directory but matches on basename.

    The provided auto-load functionality requires a full pathname match, so
    that a script to be loaded on debugging /full/path/to/debug/program must be
    placed in autoload-directory/full/path/to/debug/program-gdb.extension .

    This function means that you just need to create a file
    autoload-directory/program-gdb.py.

    NOTE: gdb can load the same objects more than once while open.
    The simplest example of this is calling `run` more than once on a binary.
    When this happens the file in autoimports/ will be imported twice.

    '''
    progname = event.new_objfile.filename
    # Would like to use the gdb.current_objfile() function, but since I can't
    # use autoloading (because I need the entire filename instead of just the
    # basename), I have to manually store the current program file somewhere.
    walkers.objfile_name = progname
    basename = os.path.basename(progname)
    # I believe a unique name is required ... in PEP302 it lists the
    # responsibilities of load_module(), which icludes checking for an
    # existing module object in sys.modules
    # If I break that I expect there'll be a host of complications.
    # That unique name doesn't have to be sensible though, we can just have an
    # incrementing global variable.
    # This global variable actually indicates the position in gdb.objfiles()
    # where this objfile is stored.
    # That's not on purpose or anything though ...

    # If the same object is loaded twice, then we import it twice.
    # This isn't to allow anything in particular, but simply because that seems
    # like the most intuitive behaviour when loading an object file twice.

    if basename in autoimports.imported:
        load_name = autoimports.imported[basename]
    else:
        load_name = 'autoimports.' + str(autoimports.index)
        autoimports.imported[basename] = load_name
        autoimports.index += 1

    with suppress(ModuleNotFoundError):
        importlib.import_module(load_name)
    walkers.objfile_name = None


gdb.events.new_objfile.connect(importer)
