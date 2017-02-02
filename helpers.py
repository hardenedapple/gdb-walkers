'''Helper functions -- used throughout the config files.'''
import gdb

def find_uintptr_t():
    '''Find a uintptr_t equivalent and store it in the global namespace.'''
    voidptr_t = gdb.parse_and_eval('(char *)0').type
    size_and_types = { val.sizeof: val for val in
                      map(gdb.lookup_type,
                          ['unsigned int', 'unsigned long', 'unsigned long long']) }
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


def start_handler(event):
    '''Upon startup, find the pointer type for this program'''
    global uintptr_t
    uintptr_t = find_uintptr_t()
    # Remove us from the stop handler -- there is no reason to keep finding the
    # same pointer type.
    # NOTE:
    #   This may have trouble when switching between a 32bit and 64 bit process
    #   in the same gdb session.
    #   In that case, just manually run
    #      (gdb) python find_uintptr_t()
    #   and you should be fine.
    gdb.events.stop.disconnect(start_handler)

gdb.events.stop.connect(start_handler)


