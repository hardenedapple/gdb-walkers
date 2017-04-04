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
            self.start_addr = eval_int(args)
            return
        self.start_addr = None

    def iter_folds(self, init_addr):
        gar_ptr = '((garray_T *){})'.format(init_addr)
        array_walk = 'array fold_T; {0}->ga_data; {0}->ga_len'.format(gar_ptr)
        for fold in gdb.create_pipeline(array_walk):
            yield fold
            yield from self.iter_folds(fold + self.nested_offset)

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_addr, inpipe, self.iter_folds)


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
            self.start_addr = eval_int(args)
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
    i.e. it walks over all buffers in neovim.

    Use:
        pipe nvim-buffers | ...

    Example:
        // Print all buffers viewing a file whose path contains 'runtime'
        pipe nvim-buffers | \
                if ((buf_T *){})->b_ffname | \
                if $_regex(((buf_T *){})->b_ffname, ".*runtime.*") | \
                show print ((buf_T *){})->b_ffname

    '''
    name = 'nvim-buffers'
    def iter_def(self, inpipe):
        wlkr_text = 'follow-until firstbuf; {} == 0; ((buf_T *){})->b_next'
        yield from gdb.create_pipeline(wlkr_text)


class NvimTabs(gdb.Walker):
    '''Walk over all vim tabs

    Convenience walker, is equivalent to
        (gdb) pipe follow-until first_tabpage; {} == 0; ((tabpage_T *){})->tp_next
    i.e. it walks over all tabs in the instance.

    Use:
        pipe nvim-tabs | ...

    Example:
        pipe nvim-tabs | \
                if ((tabpage_T *){})->localdir | \
                show print ((tabpage_T *){})->localdir

    '''
    name = 'nvim-tabs'
    def iter_def(self, inpipe):
        wlkr_text = 'follow-until first_tabpage; {} == 0; ((tabpage_T *){})->tp_next'
        yield from gdb.create_pipeline(wlkr_text)


class NvimWindows(gdb.Walker):
    '''Walk over all vim windows or windows in a given tab

    Convenience walker,
        (gdb) pipe nvim-windows <tab_ptr>
        (gdb) // Is almost equivalent to
        (gdb) if <tab_ptr> == curtab
         > pipe follow-until firstwin; {} == 0; ((win_T *){})->w_next
         > else
         > pipe follow-until <tab_ptr>->tp_firstwin; {} == 0; ((win_T *){})->w_next
         > end
    and
        (gdb) pipe nvim-windows
        (gdb) // Is equivalent to
        (gdb) pipe nvim-tabs | nvim-windows {}

    i.e. with a tab pounter it walks over all windows in that tab, without an
    argument it walks over all windows in the neovim instance.

    Use:
        pipe nvim-windows [tab_ptr]

    Examples:
        // Print the buffers in each neovim window.
        pipe nvim-windows | show print ((win_T *){})->w_buffer->b_ffname

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
        yield from self.call_with(None, inpipe, self.__iter_helper)


class NvimMultiQueues(gdb.Walker):
    '''Walk over MultiQueueItems in a queue

    Pass in a MultiQueue pointer.

    Can either dereference links (i.e. convert a link in a multiqueue into the
    corresponding event) or not.

    If there is a semicolon and something after it, that tells this walker to
    dereference links.

    Use:
        pipe nvim-mqueue start-expression[; dereference] | ...
        pipe eval start-expression | nvim-mqueue <expr containing {}>[; dereference] | ...

    Example:
        // If always dereferencing, then every MultiQueueItem is an event (I think)
        pipe nvim-mqueue main_loop.events; dereference | show print *(Event *){}
        // Print each MultiQueueItem in the main_loop.
        pipe nvim-mqueue main_loop.events | show print *(MultiQueueItem *){}

    '''
    name = 'nvim-mqueue'
    def __init__(self, args, first, _):
        # Calculate a bunch of offsets and types for future use.
        self.mqi_q_offset = offsetof('MultiQueueItem', 'node')
        self.mq_headtail_offset = offsetof('MultiQueue', 'headtail')
        self.mqi_ptr = gdb.lookup_type('MultiQueueItem').pointer()
        self.queue_ptr = gdb.lookup_type('QUEUE').pointer()
        # Parse arguments
        arg_list = self.parse_args(args, [1, 2], ';')
        self.deref = len(arg_list) == 2
        self.expr = arg_list[0]
        self.start = eval_int(self.expr) if first else None

    def __ptr_to_type(self, pointer, ptype):
        return gdb.Value(pointer).cast(ptype).dereference()

    def __q_next(self, pointer):
        return int(self.__ptr_to_type(pointer, self.queue_ptr)['next'])

    def iter_queue(self, pointer):
        '''Given a MultiQueue, iterate over all events on it.

        If self.deref is true, iterate over events in all sub-queues too.

        '''
        q_start = pointer + self.mq_headtail_offset
        q_next = self.__q_next(q_start)

        # Gist of what to do taken from QUEUE_FOREACH(), multiqueue_remove(),
        # and QUEUE_DATA()/multiqueue_node_data()
        while q_next != q_start:
            item_ptr = q_next - self.mqi_q_offset
            item = self.__ptr_to_type(item_ptr, self.mqi_ptr)
            q_next = self.__q_next(q_next)

            # If we are dereferencing elements, yield the first event of the
            # linked queue.
            if self.deref and item['link']:
                child_queue_p = int(item['data']['queue'])
                item_ptr = self.__q_next(child_queue_p + self.mq_headtail_offset)
                item_ptr -= self.mqi_q_offset

            yield item_ptr

    def iter_def(self, inpipe):
        if inpipe:
            for element in inpipe:
                yield from self.iter_queue(self.expr.format(element))
        else:
            yield from self.iter_queue(self.start)


class NvimCharBuffer(gdb.Walker):
    '''Walk over all buffblock_T items starting at given buffheader_T

    Equivalent to:
        linked-list &(<argument>->bh_first); buffblock_T; b_next

    Use:
        pipe nvim-buffblocks <buffheader_T> | ...
        pipe eval ... | nvim-buffblocks | ...

    Examples:
        pipe nvim-buffblocks &readbuf1 | show printf "%s\n", ((buffblock_T *){})->b_str
        pipe eval &readbuf1 | nvim-buffblocks

    '''
    name = 'nvim-buffblocks'
    def __init__(self, args, first, _):
        if first:
            self.start_addr = eval_int(args)
        else:
            self.start_addr = None

    def iter_helper(self, addr):
        buff_list = ''.join(['linked-list &(((buffheader_T *){})->bh_first);'.format(addr),
                               'buffblock_T; b_next'])
        for buffblock in gdb.create_pipeline(buff_list):
            yield buffblock

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_addr, inpipe, self.iter_helper)


class NvimMapBlock(gdb.Walker):
    '''Walk over all mapblock_T structures in a linked list.

    Equivalent to
        linked-list <argument>; mapblock_T; m_next

    Usage:
        // Print all global mappings.
        pipe nvim-mapblock <mapblock_T *>
        pipe eval ... | nvim-buffblocks

    '''
    name = 'nvim-mapblock'
    def __init__(self, args, first, _):
        if first:
            self.start_addr = eval_int(args)
        else:
            self.start_addr = None

    def iter_helper(self, addr):
        map_list = ''.join(['linked-list {};'.format(addr),
                               'mapblock_T; m_next'])
        for mapping in gdb.create_pipeline(map_list):
            yield mapping

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_addr, inpipe, self.iter_helper)


class NvimMappings(gdb.Walker):
    '''Walk over all mappings in a buffer, or all global mappings.

    Equivalent to
        pipe array mapblock_T **; maphash; 256 | if *(mapblock_T **){} != 0 | eval ((mapblock_T *){})->m_next | nvim-mapblock
    or
        pipe array mapblock_T **; <buffer>->b_maphash; 256 | if *(mapblock_T **){} != 0 | eval ((mapblock_T *){})->m_next | nvim-mapblock

    Usage:
        pipe nvim-maps <buffer>
        pipe nvim-maps

    Example:
        // print-string and printf are different because printf prints
        // non-printable characters directly while print-string escapes them with
        // a backslash.
        pipe nvim-maps | show print-string ((mapblock_T*){})->m_keys; "  -->  "; ((mapblock_T*){})->m_str; "\n"
        pipe nvim-maps | show printf "%s  -->  %s\n", ((mapblock_T*){})->m_keys, ((mapblock_T*){})->m_str
        // Or only maps of a given buffer
        pipe nvim-maps curbuf | ...
        pipe nvim-buffers | nvim-maps | ...

    '''
    name = 'nvim-maps'
    __conversion_pipe = ' | if *(mapblock_T **){} != 0 | eval ((mapblock_T *){})->m_next | nvim-mapblock'
    def __init__(self, args, first, _):
        self.first = first
        self.use_global = first and not args
        self.start_buf = None if not args else eval_int(args)

    def __iter_helper(self, arg):
        map_array = 'maphash' if self.use_global else '((buf_T *){})->b_maphash'.format(arg)
        init_pipe = 'array mapblock_T **; {}; 256'.format(map_array)
        yield from gdb.create_pipeline(init_pipe + self.__conversion_pipe)

    def iter_def(self, inpipe):
        if not inpipe:
            yield from self.__iter_helper(self.start_buf)
        else:
            for element in inpipe:
                yield from self.__iter_helper(element)


for walker in [NvimFold, NvimUndoTree, NvimBuffers, NvimTabs, NvimWindows,
               NvimMultiQueues, NvimCharBuffer, NvimMapBlock, NvimMappings]:
    gdb.register_walker(walker)
