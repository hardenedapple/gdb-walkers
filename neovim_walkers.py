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


# For walking over buffers
# (gdb) pipe follow-until firstbuf; {} == 0; ((buf_T *){})->b_next
class NvimBuffers(gdb.Walker):
    '''Walk over all buffers

    Convenience walker, is equivalent to
        (gdb) pipe follow-until firstbuf; {} == 0; ((buf_T *){})->b_next

    Use:
        pipe nvim-buffers | ...

    '''
    name = 'nvim-buffers'
    def iter_def(self, inpipe):
        wlkr_text = 'follow-until firstbuf; {} == 0; ((buf_T *){})->b_next'
        yield from gdb.create_pipeline(wlkr_text)


class NvimTabs(gdb.Walker):
    '''Walk over all vim tabs

    Convenience walker, is equivalent to
        (gdb) pipe follow-until first_tabpage; {} == 0; ((tabpage_T *){})->tp_next

    Use:
        pipe nvim-tabs | ...

    '''
    name = 'nvim-tabs'
    def iter_def(self, inpipe):
        wlkr_text = 'follow-until first_tabpage; {} == 0; ((tabpage_T *){})->tp_next'
        yield from gdb.create_pipeline(wlkr_text)


class NvimWindows(gdb.Walker):
    '''Walk over all vim windows or windows in a given tab

    Convenience walker,
        (gdb) pipe nvim-windows <tab_ptr>
        (gdb) // Is equivalent to
        (gdb) pipe follow-until <tab_ptr>->tp_firstwin; {} == 0; ((win_T *){})->w_next
    and
        (gdb) pipe nvim-windows
        (gdb) // Is equivalent to
        (gdb) pipe nvim-tabs | nvim-windows {}

    Use:
        pipe nvim-windows [tab_ptr]

    Examples:
        pipe nvim-windows | ...

    '''
    name = 'nvim-windows'

    def __init__(self, args, *_):
        self.startptr = args if args else None

    def __make_wlkr_text(self, element):
        # So the user can put '{}' in their tabpage definition.
        startptr = eval_int(self.startptr.format(element)
                if element is not None else self.startptr)
        # The current tab doesn't have windows stored in it.
        if startptr == eval_int('curtab'):
            # Deosn't really matter if startptr is evaluated or not before
            # passing to follow-until (because follow-until evaluates the
            # expression as an integer anyway).
            # But we have to evaluate it to check if the tab pointer is to
            # curtab.
            startptr = 'firstwin'
        else:
            startptr = '((tabpage_T *){})->tp_firstwin'.format(startptr)

        ret = 'follow-until {};'.format(startptr)
        return ret + '{} == 0; ((win_T *){})->w_next'

    def __iter_helper(self, element):
        if self.startptr:
            yield from gdb.create_pipeline(self.__make_wlkr_text(element))
        else:
            yield from gdb.create_pipeline('nvim-tabs | nvim-windows {}')

    def iter_def(self, inpipe):
        if inpipe:
            for element in inpipe:
                yield from self.__iter_helper(element)
        else:
            yield from self.__iter_helper(None)


for walker in [NvimFold, NvimUndoTree, NvimBuffers, NvimTabs, NvimWindows]:
    gdb.register_walker(walker)
