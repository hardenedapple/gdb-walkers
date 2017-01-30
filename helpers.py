'''Helper functions -- used throughout the config files.'''
import gdb

# This is just the first guess -- We can't yet find the length of a pointer.
# Functions that want to use uintptr_t should call find_ptr_t() first to update
# the global value with what makes sense.
uintptr_t = gdb.lookup_type('unsigned long')
def find_ptr_t():
    '''Find a uintptr_t equivalent and store it in the global namespace.'''
    # We need the size of a pointer in order to do pointer arithmetic.
    #
    # Because the size of a pointer is not known until we are connected to a
    # process, and gdb can switch between processes, we need to update the
    # current uintptr_t object we have each time Pipeline is called.
    global uintptr_t
    # Note, we can't rely on every program including "stdint.h", so we have a
    # little logic to find the size of a pointer here.
    try:
        uintptr_t = gdb.lookup_type('uintptr_t')
        # TODO should make the below except clause only trigger if the error
        # was because uintptr_t could not be found.
    except gdb.error:
        pointer_size = int(gdb.parse_and_eval('sizeof(char *)'))
        int_type = gdb.lookup_type('unsigned int')
        long_type = gdb.lookup_type('unsigned long')
        if int_type.sizeof == pointer_size:
            uintptr_t = int_type
        elif long_type.sizeof == pointer_size:
            uintptr_t = long_type
        else:
            # TODO I *should* think more about this -- I have the feeling I'm
            # missing a lot of cases and that it's likely to break in many special
            # cases.
            # On the other hand, I can't see it being a problem soon, and hence
            # can't see this being a priority soon.
            raise GdbWalkerError('Failed to find size of pointer type')


def eval_int(gdb_expr):
    '''Return a python integer representing the gdb expression '''
    return int(gdb.parse_and_eval(gdb_expr).cast(uintptr_t))


def start_handler(event):
    '''Upon startup, find the pointer type for this program'''
    find_ptr_t()
    # Remove us from the stop handler -- there is no reason to keep finding the
    # same pointer type.
    # NOTE:
    #   This may have trouble when switching between a 32bit and 64 bit process
    #   in the same gdb session.
    #   In that case, just manually run
    #      (gdb) python find_ptr_t()
    #   and you should be fine.
    gdb.events.stop.disconnect(start_handler)

gdb.events.stop.connect(start_handler)


