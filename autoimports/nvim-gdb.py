'''
Define walkers over neovim data structures.

TODO Really need to update this for the new implementation (using $cur instead
of {}).

To have this file autoloaded when inspecting a newly built version of nvim, put
a small file containing just the line `import neovim_walkers` in the file
~/.config/gdb/autoloads/<full/path/to/nvim/binary>-gdb.py

'''
import itertools as itt
import gdb
from helpers import offsetof, eval_uint, uintptr_size, find_type_size
import walkers
import walker_defs


class NvimFold(walkers.Walker):
    '''Walk over all folds defined in a garray_T recursively.

    If it is the first walker it can take an argument of the garray of folds

    Use:
        gdb-pipe nvim-folds <fold array>
        gdb-pipe eval <equation> | nvim-folds

    Example:
        gdb-pipe nvim-folds &curwin->w_folds

    '''
    name = 'nvim-folds'

    def __init__(self, start):
        self.nested_offset = offsetof('fold_T', 'fd_nested')
        self.start = start

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(cls.calc(args) if first else None)

    def iter_folds(self, init_addr):
        gar_ptr = self.Ele('garray_T *', init_addr.v)
        array_walk = 'array fold_T; {0}->ga_data; {0}->ga_len'.format(gar_ptr)
        for fold in walkers.create_pipeline(array_walk):
            yield fold
            yield from self.iter_folds(
                self.Ele(fold.t, fold.v + self.nested_offset))

    def iter_def(self, inpipe):
        yield from self.call_with(self.start, inpipe, self.iter_folds)


class NvimUndoTree(walkers.Walker):
    '''Walk over all undo headers in the undo tree.

    Use:
        gdb-pipe nvim-undohist <undo header>
        gdb-pipe eval <equation> | nvim-undohist

    Example:
        gdb-pipe nvim-undohist curbuf->b_u_oldhead

    '''
    name = 'nvim-undohist'

    def __init__(self, start):
        self.start = start

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(eval_uint(args) if first else None)

    def walk_alts(self, init_addr):
        # First walk over all in the 'alt_next' direction
        next_iter = walker_defs.Terminated.single_iter(
            start_ele=self.calc('{}->uh_alt_next.ptr'.format(init_addr)),
            test_expr='{} == 0',
            follow_expr='{}->uh_alt_next.ptr')
        prev_iter = walker_defs.Terminated.single_iter(
            start_ele=self.calc('{}->uh_alt_prev.ptr'.format(init_addr)),
            test_expr='{} == 0',
            follow_expr='{}->uh_alt_prev.ptr')
        for uh in itt.chain(next_iter, prev_iter):
            yield uh
            yield from self.walk_hist(uh)

    def walk_hist(self, init_addr):
        for uh in walker_defs.Terminated.single_iter(
                start_ele=self.calc('{}->uh_prev.ptr'.format(init_addr)),
                test_expr='{} == 0',
                follow_expr='{}->uh_prev.ptr'):
            yield uh
            yield from self.walk_alts(uh)

    def __iter_helper(self, element):
        ele = self.Ele('u_header_T *', int(element))
        yield ele
        yield from self.walk_alts(ele)
        yield from self.walk_hist(ele)

    def iter_def(self, inpipe):
        yield from self.call_with(self.start, inpipe, self.__iter_helper)


class NvimBuffers(walkers.Walker):
    '''Walk over all buffers

    Convenience walker, is equivalent to
        (gdb) gdb-pipe follow-until firstbuf; {} == 0; {}->b_next
    i.e. it walks over all buffers in neovim.

    Use:
        gdb-pipe nvim-buffers | ...

    Example:
        // Print all buffers viewing a file whose path contains 'runtime'
        gdb-pipe nvim-buffers | \
                if {}->b_ffname | \
                if $_regex({}->b_ffname, ".*runtime.*") | \
                show print {}->b_ffname

    '''
    name = 'nvim-buffers'

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls()

    def iter_def(self, inpipe):
        yield from walker_defs.Terminated.single_iter(
            start_ele=self.calc('firstbuf'),
            test_expr='{} == 0',
            follow_expr='{}->b_next')


class NvimTabs(walkers.Walker):
    '''Walk over all vim tabs

    Convenience walker, is equivalent to
        (gdb) gdb-pipe follow-until first_tabpage; {} == 0; {}->tp_next
    i.e. it walks over all tabs in the instance.

    Use:
        gdb-pipe nvim-tabs | ...

    Example:
        gdb-pipe nvim-tabs | \
                if {}->tp_localdir | \
                show print {}->tp_localdir

    '''
    name = 'nvim-tabs'

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls()

    def iter_def(self, inpipe):
        yield from walker_defs.Terminated.single_iter(
            start_ele=self.calc('first_tabpage'),
            test_expr='{} == 0',
            follow_expr='{}->tp_next')


class NvimWindows(walkers.Walker):
    '''Walk over all vim windows or windows in a given tab

    Convenience walker,
        (gdb) gdb-pipe nvim-windows <tab_ptr>
        (gdb) // Is almost equivalent to
        (gdb) if <tab_ptr> == curtab
         > gdb-pipe follow-until firstwin; {} == 0; ((win_T *){})->w_next
         > else
         > gdb-pipe follow-until <tab_ptr>->tp_firstwin; {} == 0; ((win_T *){})->w_next
         > end
    and
        (gdb) gdb-pipe nvim-windows
        (gdb) // Is equivalent to
        (gdb) gdb-pipe nvim-tabs | nvim-windows {}

    i.e. with a tab pounter it walks over all windows in that tab, without an
    argument it walks over all windows in the neovim instance.

    Use:
        gdb-pipe nvim-windows [tab_ptr]

    Examples:
        // Print the buffers in each neovim window.
        gdb-pipe nvim-windows | show print ((win_T *){})->w_buffer->b_ffname

    '''
    name = 'nvim-windows'

    def __init__(self, startptr):
        self.startptr = startptr

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(args if args else None)

    def __walker_start(self, element):
        # So the user can put '{}' in their tabpage definition.
        startptr = eval_uint(self.format_command(element, self.startptr)
                             if element is not None else self.startptr)
        # The current tab doesn't have windows stored in it, hence if we're
        # asked to walk over windows in the current tab we need to work
        # differently.
        if startptr == eval_uint('curtab'):
            startstr = 'firstwin'
        else:
            startstr = '((tabpage_T *){})->tp_firstwin'.format(startptr)
        return self.calc(startstr)

    def __iter_helper(self, element):
        if self.startptr:
            yield from walker_defs.Terminated.single_iter(
                start_ele=self.__walker_start(element),
                test_expr='{} == 0',
                follow_expr='((win_T *){})->w_next')
        else:
            yield from walkers.create_pipeline('nvim-tabs | nvim-windows {}')

    def iter_def(self, inpipe):
        if inpipe:
            for element in inpipe:
                yield from self.__iter_helper(element)
        else:
            yield from self.__iter_helper(None)


class NvimMultiQueues(walkers.Walker):
    '''Walk over MultiQueueItems in a queue

    Pass in a MultiQueue pointer.

    Can either dereference links (i.e. convert a link in a multiqueue into the
    corresponding event) or not.

    If there is a semicolon and something after it, that tells this walker to
    dereference links.

    Use:
        gdb-pipe nvim-mqueue start-expression[; dereference] | ...
        gdb-pipe eval start-expression | nvim-mqueue <expr containing {}>[; dereference] | ...

    Example:
        // If always dereferencing, then every MultiQueueItem is an event (I think)
        gdb-pipe nvim-mqueue main_loop.events; dereference | show print *(Event *){}
        // Print each MultiQueueItem in the main_loop.
        gdb-pipe nvim-mqueue main_loop.events | show print *(MultiQueueItem *){}

    '''
    name = 'nvim-mqueue'
    def __init__(self, expr, deref, first):
        # Calculate a bunch of offsets and types for future use.
        self.mqi_q_offset = offsetof('MultiQueueItem', 'node')
        self.mq_headtail_offset = offsetof('MultiQueue', 'headtail')
        self.mqi_ptr = gdb.lookup_type('MultiQueueItem').pointer()
        self.queue_ptr = gdb.lookup_type('QUEUE').pointer()
        self.expr = expr
        self.deref = deref
        self.start = eval_uint(expr) if first else None

    @classmethod
    def from_userstring(cls, args, first, last):
        # Parse arguments
        arg_list = cls.parse_args(args, [1, 2], ';')
        expr = arg_list[0]
        deref = len(arg_list) == 2
        return cls(expr, deref, first)

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

            yield self.Ele('Event *' if self.deref else 'MultiQueueItem *',
                           item_ptr)

    def iter_def(self, inpipe):
        if inpipe:
            for element in inpipe:
                pos = self.eval_command(element, self.expr)
                yield from self.iter_queue(pos.v)
        else:
            yield from self.iter_queue(self.start)


class NvimCharBuffer(walkers.Walker):
    '''Walk over all buffblock_T items starting at given buffheader_T

    Equivalent to:
        linked-list &(<argument>->bh_first); buffblock_T; b_next

    Use:
        gdb-pipe nvim-buffblocks <buffheader_T> | ...
        gdb-pipe eval ... | nvim-buffblocks | ...

    Examples:
        gdb-pipe nvim-buffblocks &readbuf1 | show printf "%s\\n", {}->b_str
        gdb-pipe eval &readbuf1 | nvim-buffblocks

    '''
    name = 'nvim-buffblocks'
    def __init__(self, start):
        self.start = start

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(eval_uint(args) if first else None)

    def iter_helper(self, addr):
        yield from walker_defs.LinkedList.single_iter(
                start_ele=self.calc('&(((buffheader_T *){})->bh_first)'.format(addr)),
                list_type='buffblock_T',
                next_member='b_next')

    def iter_def(self, inpipe):
        yield from self.call_with(self.start, inpipe, self.iter_helper)


class NvimMapBlock(walkers.Walker):
    '''Walk over all mapblock_T structures in a linked list.

    Equivalent to
        linked-list <argument>; mapblock_T; m_next

    Usage:
        // Print all global mappings.
        gdb-pipe nvim-mapblock <mapblock_T *>
        gdb-pipe eval ... | nvim-buffblocks

    '''
    name = 'nvim-mapblock'
    def __init__(self, start_addr):
        self.start_addr = start_addr

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(eval_uint(args) if first else None)

    def iter_helper(self, addr):
        yield from walker_defs.LinkedList.single_iter(
                start_ele=self.Ele('mapblock_T', addr.v),
                list_type='mapblock_T',
                next_member='m_next')

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_addr, inpipe, self.iter_helper)


class NvimMappings(walkers.Walker):
    '''Walk over all mappings in a buffer, or all global mappings.

    Equivalent to
        gdb-pipe array mapblock_T *; maphash; 256 | eval *{} | if {} != 0 | nvim-mapblock
    or
        gdb-pipe array mapblock_T *; <buffer>->b_maphash; 256 | eval *{} | if {} != 0 | nvim-mapblock

    Usage:
        gdb-pipe nvim-maps <buffer>
        gdb-pipe nvim-maps

    Example:
        // print-string and printf are different because printf prints
        // non-printable characters directly while print-string escapes them with
        // a backslash.
        gdb-pipe nvim-maps | show print-string {}->m_keys; "  -->  "; {}->m_str; "\\n"
        gdb-pipe nvim-maps | show printf "%s  -->  %s\\n", {}->m_keys, {}->m_str
        // Or only maps of a given buffer
        gdb-pipe nvim-maps curbuf | ...
        gdb-pipe nvim-buffers | nvim-maps | ...

    '''
    name = 'nvim-maps'
    def __init__(self, first, use_global, start_buf):
        self.first = first
        self.use_global = use_global
        self.start_buf = start_buf

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(first,
                   first and not args,
                   None if not args else cls.Ele('buf_T *', eval_uint(args)))

    def __iter_helper(self, arg):
        map_array = 'maphash + 0' if self.use_global else '((buf_T *){})->b_maphash'.format(arg)
        start_ele = self.calc(map_array)
        yield from walkers.connect_pipe([
            walker_defs.Array(
                start=start_ele.v,
                count=256,
                typename=start_ele.t,
                element_size=uintptr_size()),
            walker_defs.Eval(cmd='*{}', first=False),
            walker_defs.If(cmd='{} != 0'),
            NvimMapBlock(start_addr=None)])

    def iter_def(self, inpipe):
        if not inpipe:
            yield from self.__iter_helper(self.start_buf)
        else:
            for element in inpipe:
                yield from self.__iter_helper(element)


class NvimGarray(walkers.Walker):
    '''Walk over all elements of a grow array in (Neo)Vim.

    Equivalent to
        gdb-pipe array <argument2>; <argument1>->ga_data; <argument1>->ga_len

    Use:
        gdb-pipe nvim-garray <growarray address>; <type>

    Example:
        gdb-pipe nvim-garray &curwin->w_folds; fold_T
    '''
    name = 'nvim-garray'

    def __init__(self, t, start):
        self.t = t
        self.start = start

    @classmethod
    def from_userstring(cls, args, first, last):
        cmd_parts = cls.parse_args(args, [2, 2] if first else [1, 1], ';')
        return cls(cmd_parts[-1],
                   eval_uint(cmd_parts[0]) if first else None)

    def iter_helper(self, arg):
        gar_ptr = '((garray_T *){})'.format(arg)
        yield from walker_defs.Array.single_iter(
            start=eval_uint('{}->ga_data'.format(gar_ptr)),
            count=eval_uint('{}->ga_len'.format(gar_ptr)),
            typename=self.t,
            element_size=find_type_size(self.t))

    def iter_def(self, inpipe):
        yield from self.call_with(self.start, inpipe, self.iter_helper)
