'''
Example file that creates a walker over elements in the tree defined in tree.c

'''

import gdb
from helpers import eval_int

class TreeElements(gdb.Walker):
    '''Walk over all elements in the tree.

    Only works for the tree defined in tree.c

    Use:
        pipe tree-elements tree_root

    Example:
        // All pure leaf elements in the tree.
        pipe tree-elements tree_root | if {0}->children[0] == 0 && {0}->children[1] == 0
        pipe eval tree_root | tree-elements | ...

    '''
    name = 'tree-elements'
    tags = ['tree-demo']

    def __init__(self, args, first, _):
        if first:
            self.start_addr = self.ele('node_t *', eval_int(args))
            return
        self.start_addr = None

    def iter_elements(self, init_addr):
        if init_addr.v == 0:
            return

        left_child = '{}->children[0]'.format(init_addr)
        right_child = '{}->children[1]'.format(init_addr)
        yield from self.iter_elements(self.calc(right_child))
        yield from self.iter_elements(self.calc(left_child))
        yield init_addr

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_addr, inpipe, self.iter_elements)


gdb.register_walker(TreeElements)
