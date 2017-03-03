'''
Define walkers over neovim data structures.

So far all that's implemented is walking over fold arrays, and walking over
undo trees.

To have this file autoloaded when inspecting a newly built version of nvim, put
a small file containing just the line `import neovim_walkers` in the file
~/.config/gdb/autoloads/<full/path/to/nvim/binary>-gdb.py

If anyone knows of a way to tell gdb to just search for the basename so I can
just have the file ~/.config/gdb/autoloads/nvim-gdb.py I would love to hear of
it.

'''
import itertools as itt
import gdb
from helpers import offsetof, eval_int

class NvimFold(gdb.Walker):
    '''Walk over all folds defined in a garray_T recursively.

    If it is the first walker it can take an argument of the garray of folds

    Use:
        pipe nvim-folds <fold array>
        pipe eval <equation> | nvim-folds

    Example:
        pipe nvim-folds &curwin->w_folds

    '''
    name = 'nvim-folds'
    # TODO -- should be able to add this tag automatically in
    # gdb.register_walker() by checking gdb.current_objfile().
    tags = ['nvim']

    def __init__(self, args, first, _):
        self.nested_offset = offsetof('fold_T', 'fd_nested')
        if first:
            self.start_addr = eval_int(self.eval_user_expressions(args))
            return
        self.start_addr = None

    def iter_folds(self, init_addr):
        gar_ptr = '((garray_T *){})'.format(init_addr)
        array_walk = 'array fold_T; {0}->ga_data; {0}->ga_len'.format(gar_ptr)
        for fold in gdb.create_pipeline(array_walk):
            yield fold
            yield from self.iter_folds(fold + self.nested_offset)

    def iter_def(self, inpipe):
        if self.start_addr:
            yield from self.iter_folds(self.start_addr)
        else:
            for element in inpipe:
                yield from self.iter_folds(element)


class NvimUndoTree(gdb.Walker):
    '''Walk over all undo headers in the undo tree.

    Use:
        pipe nvim-undohist <undo header>
        pipe eval <equation> | nvim-undohist

    Example:
        pipe nvim-undohist curbuf->b_u_oldhead

    '''
    name = 'nvim-undohist'
    tags = ['nvim']

    def __init__(self, args, first, _):
        if first:
            self.start_addr = eval_int(self.eval_user_expressions(args))
            return
        self.start_addr = None

    def walk_alts(self, init_addr):
        # First walk over all in the 'alt_next' direction
        next_text = ('follow-until ' +
                     '((u_header_T *){})->uh_alt_next.ptr;'.format(init_addr) +
                     ' {} == 0; ((u_header_T *){})->uh_alt_next.ptr')
        prev_text = ('follow-until ' +
                     '((u_header_T *){})->uh_alt_prev.ptr;'.format(init_addr) +
                     ' {} == 0; ((u_header_T *){})->uh_alt_prev.ptr')
        for uh in itt.chain(gdb.create_pipeline(next_text),
                            gdb.create_pipeline(prev_text)):
            yield uh
            yield from self.walk_hist(uh)

    def walk_hist(self, init_addr):
        wlkr_text = ('follow-until ' +
                     '((u_header_T *){})->uh_prev.ptr;'.format(init_addr) +
                     ' {} == 0; ((u_header_T *){})->uh_prev.ptr')
        for uh in gdb.create_pipeline(wlkr_text):
            yield uh
            yield from self.walk_alts(uh)

    def iter_def(self, inpipe):
        if self.start_addr:
            yield self.start_addr
            yield from self.walk_alts(self.start_addr)
            yield from self.walk_hist(self.start_addr)
        else:
            for element in inpipe:
                yield element
                yield from self.walk_alts(element)
                yield from self.walk_hist(element)


for walker in [NvimFold, NvimUndoTree]:
    gdb.register_walker(walker)
