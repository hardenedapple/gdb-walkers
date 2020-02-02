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
        gdb-pipe tree-elements tree_root

    Example:
        // All pure leaf elements in the tree.
        gdb-pipe tree-elements tree_root | if $cur->children[0] == 0 && $cur->children[1] == 0
        gdb-pipe eval tree_root | tree-elements | ...

    '''
    name = 'tree-elements'
    tags = ['tree-demo']

    def __init__(self, start_addr):
        self.start_addr = start_addr

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(cls.calc(args) if first else None)

    def iter_elements(self, init_addr):
        if not init_addr:
            return

        children = init_addr.dereference()['children']
        left_child = children[0]
        right_child = children[1]
        yield from self.iter_elements(right_child)
        yield from self.iter_elements(left_child)
        yield init_addr

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_addr, inpipe, self.iter_elements)

