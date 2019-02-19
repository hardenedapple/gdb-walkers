'''
Define walkers over GCC data structures.

'''

import itertools as itt
import gdb
from helpers import offsetof, eval_uint, uintptr_size, find_type_size
import walkers
import walker_defs

class Passes(walkers.Walker):
    """Walk over all passes and subpasses from an `opt_pass *`.

    If there are no subpasses this would be the same as
    pipe linked-list <head>; opt_pass; next

    Use:
        pipe gcc-passes <pass_array>
        pipe eval <equation> | gcc-passes

    Example:
        pipe gcc-passes rest_of_compilation | show print {}->name

    """
    name = 'gcc-passes'

    def __init__(self, start):
        self.nested_offset = offsetof('opt_pass', 'sub')
        self.start = start

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(cls.calc(args) if first else None)

    def iter_passes(self, init_addr):
        pass_ptr = self.Ele('opt_pass *', init_addr.v)
        list_walk = 'linked-list {0}; opt_pass; next'.format(pass_ptr)
        for gcc_pass in walkers.create_pipeline(list_walk):
            yield gcc_pass
            value = gdb.parse_and_eval(str(gcc_pass)).dereference()
            sub_value = int(value['sub'])
            if sub_value:
                yield from self.iter_passes(self.Ele(gcc_pass.t, sub_value))

    def iter_def(self, inpipe):
        yield from self.call_with(self.start, inpipe, self.iter_passes)

