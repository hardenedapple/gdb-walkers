'''Helper functions -- used throughout the config files.

The uintptr_t variable has to be a global variable because other functions want
to use it.

If using `from helpers import uintptr_t`, the `start_handler()` function
doesn't change the value everywhere else because these other modules get their
own local copy -- I don't know the logic behind this.

Hence I either have to import the module everywhere and use qualified names,
or source it directly in the gdbinit file.

'''
import gdb


def find_uintptr_t():
    '''Find a uintptr_t equivalent and store it in the global namespace.'''
    voidptr_t = gdb.parse_and_eval('(char *)0').type
    size_and_types = {val.sizeof: val for val in
                      map(gdb.lookup_type, ['unsigned int', 'unsigned long',
                                            'unsigned long long'])}
    try:
        return size_and_types[voidptr_t.sizeof]
    except KeyError:
        raise RuntimeError('Failed to find size of pointer type')


# First guess -- on starting the program we update this.
# This is because we don't actually know the size of a pointer type until we
# attach to the process.
uintptr_t = find_uintptr_t()


def eval_int(gdb_expr):
    '''Return the python integer value of `gdb_expr`

    This is to be used over `int(gdb.parse_and_eval(gdb_expr))` to
    account for the given description being a symbol.

    '''
    return int(gdb.parse_and_eval(gdb_expr).cast(uintptr_t))


def start_handler(_):
    '''Upon startup, find the pointer type for this program'''
    global uintptr_t
    uintptr_t = find_uintptr_t()
    # Remove us from the handler -- there is no reason to keep finding the same
    # pointer type.
    # NOTE:
    #   This may have trouble when inspecting both 32bit and 64 bit programs in
    #   the same gdb session.
    #   In that case, just manually run
    #      (gdb) python find_uintptr_t()
    #   and you should be fine.
    gdb.events.new_objfile.disconnect(start_handler)


# Update uintptr_t value on first objfile added because by then we'll know what
# the current program file architecture is. If we find the current pointer type
# before we do anything else gdb just guesses.
gdb.events.new_objfile.connect(start_handler)
