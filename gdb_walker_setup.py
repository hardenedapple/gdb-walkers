'''
This file does three things.

It adds to sys.path so that `import` statements work on files in this
directory.

It imports the walker module and the base walker definitions.

It sets up the autoimport mechanism for importing python modules upon loading
a new object file.

It also ensures that pagination is off if the $TERM environment variable is
'dumb'.

'''

import gdb
import os
import sys
from contextlib import suppress
import importlib
import importlib.abc
import pathlib
import re
import logging
logger = logging.getLogger(__name__)
logging.basicConfig(stream=sys.stdout, level=logging.ERROR)

# A little bit of hacking ...
# I calculate an important variable in the "global" namespace so I can use
# "import" on the walkers.
# Once I've done that I store the variables in the walkers module so as not to
# pollute the "global" namespace.
# There's a bit of interplay between that module and this file, but it's fine,
# just think of them as the same package.
confdir = str(pathlib.Path(__file__).parent.resolve())
if confdir not in sys.path:
    sys.path.append(confdir)

import walkers
import walker_defs

walkers.confdir = confdir
del confdir


def abstract_basename(fullname):
    # To handle `rr` https://rr-project.org/ having special names.
    basename = os.path.basename(fullname)
    if 'rr' in pathlib.PurePath(fullname).parts:
        basename = re.sub(r'mmap_hardlink_\d+_', '', basename)
        logger.debug(f'lookup against {basename}')
    return basename


class AutoImportsFinder(importlib.abc.PathEntryFinder):
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
        matchname = abstract_basename(walkers.objfile_name) + '-gdb.py'
        logger.debug(f'Translated to open filename: {matchname}')
        return '{}/autoimports/{}'.format(walkers.confdir, matchname)

    def find_spec(self, fullname, target=None):
        actual_path = self.__get_filename()
        # Ignore the race condition here ...
        # Hopefully no-one expects us to gracefully handle people deleting
        # our files in the middle of use ... we're a little helper script!
        if os.path.exists(actual_path):
            return importlib.machinery.ModuleSpec(
                fullname,
                importlib.machinery.SourceFileLoader(fullname, actual_path),
                origin=actual_path)
        else:
            return None


# Import just the package ... this allows us to store things off that package
# That's good because that's where the data makes sense to be.
import autoimports

def check_for_autoimport(path):
    # Check we're trying to import a subpackage of autoimports
    # n.b. we take advantage of our knowledge that autoimports is not a
    # namespace module and hence only has one element in autoimports.__path__
    if path == autoimports.__path__[0]:
        return AutoImportsFinder()
    raise ImportError


sys.path_hooks.insert(0, check_for_autoimport)

def importer(event):
    '''Emulates gdb auto-load scripts-directory but matches on basename.

    The provided auto-load functionality requires a full pathname match, so
    that a script to be loaded on debugging /full/path/to/debug/program must be
    placed in autoload-directory/full/path/to/debug/program-gdb.extension .

    This function means that you just need to create a file
    autoimports/program-gdb.py.

    NOTE: gdb can load the same objects more than once while open.
    The simplest example of this is calling `run` more than once on a binary.
    When this happens the file in autoimports/ will be imported twice, with the
    second time importing using the cached module in the Python process.

    '''
    progname = event.new_objfile.filename
    do_autoimport(progname)


def do_autoimport(progname):
    '''Implements importing helpers from the autoimports/ directory.

    This is a separate function so that it can easily be run from the gdb
    command prompt.
    One time when this might be necessary is if running under `rr` where the
    above event is not triggered for the main program.

    TODO Make this an actual user command rather than a python function.

    '''
    # Would like to use the gdb.current_objfile() function, but since I can't
    # use autoloading (because I need the entire filename instead of just the
    # basename), I have to manually store the current program file somewhere.
    logger.debug(f'autoimporting {progname}')
    walkers.objfile_name = progname
    basename = abstract_basename(progname)
    # I believe a unique name is required ... in PEP302 it lists the
    # responsibilities of load_module(), which icludes checking for an
    # existing module object in sys.modules
    # If I break that I expect there'll be a host of complications.
    # That unique name doesn't have to be sensible though, we can just have an
    # incrementing global variable.
    # This global variable actually indicates the position in gdb.objfiles()
    # where this objfile is stored.
    # That's not on purpose or anything though ...

    # If the same object is loaded twice, then we do the import twice making
    # sure that the second import works on the module object cached in the
    # Python process.
    # This isn't to allow anything in particular, but simply because that seems
    # like the most intuitive behaviour when loading an object file twice.
    if basename in autoimports.imported:
        logger.debug(f'{basename} already loaded')
        load_name = autoimports.imported[basename]
    else:
        load_name = 'autoimports.' + str(autoimports.index)
        autoimports.imported[basename] = load_name
        autoimports.index += 1

    with suppress(ImportError):
        importlib.import_module(load_name)
    walkers.objfile_name = None


gdb.events.new_objfile.connect(importer)

gdb.execute('source {}/commands.py'.format(walkers.confdir))
gdb.execute('source {}/functions.py'.format(walkers.confdir))
gdb.execute('source {}/gdb_syntax'.format(walkers.confdir))
