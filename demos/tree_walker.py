'''
Example file that creates a walker over elements in the tree defined in tree.c

'''

import gdb
from helpers import eval_uint
import walkers

class TreeElements(walkers.Walker):
    '''Walk over all elements in the tree.

    Only works for the tree defined in tree.c

    Use:
        pipe tree-elements tree_root

    Example:
        // All pure leaf elements in the tree.
        pipe tree-elements tree_root | if {}->children[0] == 0 && {}->children[1] == 0
        pipe eval tree_root | tree-elements | ...

    '''
    name = 'tree-elements'
    tags = ['tree-demo']

    def __init__(self, start_addr):
        self.start_addr = start_addr

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(cls.Ele('node_t *', eval_uint(args)) if first else None)

    def iter_elements(self, init_addr):
        if init_addr.v == 0:
            return

        left_child = self.eval_command(init_addr, '{}->children[0]')
        right_child = self.eval_command(init_addr, '{}->children[1]')
        yield from self.iter_elements(right_child)
        yield from self.iter_elements(left_child)
        yield init_addr

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_addr, inpipe, self.iter_elements)

