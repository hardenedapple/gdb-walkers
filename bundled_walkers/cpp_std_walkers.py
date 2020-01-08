'''
Contains walkers for the C++ standard library.

Since the implementation is not a part of the standard and subject to change
without notice, the walkers in this file are inherently unstable.

NOTE:
    If you're interested in using these walkers you may be better served by
    using the `pretty-printer` walker to use the pretty printers defined by the
    libstdc++ community.

'''

import gdb
from helpers import eval_uint, as_uintptr
import walkers
from walker_defs import Terminated

class StdList(walkers.Walker):
    '''Walk over elements in a std::list<T> list.

    The walker
        std-list <list start>
    is the equivalent of follow-until on the std::__detail::_List_node_base
    pointers of the underlying list cast to <element type>.

    NOTE:
        We take the type of the list from the expression given, no guarantees
        are given about failing gracefully if the expression is of the wrong
        type.

    Usage:
        gdb-pipe std-list &l | show print {}
        gdb-pipe eval &l | std-list
        # If the address is known but no special
        gdb-pipe eval ('std::__cxx11::list<int, std::allocator<int> >*')0x1111 | std-list
        # For the elements of that list.
        gdb-pipe std-list &l | show print {}->front()

    '''
    name = 'std-list'
    tags = ['data']

    def __init__(self, start_ele):
        self.start_ele = start_ele

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(cls.calc(args.strip()) if first else None)

    def __iter_helper(self, element):
        # Observations of the implementation of std::list<int>
        # The last element in the list is a node containing the number of
        # elements in the list.
        # Because the list is doubly linked we can get this last element by
        # dereferencing the _M_prev value of the head of the list.
        #
        # Hence we find our terminating value by fetching the 'prev' element
        # from the head.
        #
        # XXX
        # It seems this is not always the case.
        # I have at least once seen the first element of the list being the
        # node containing the number of elements in the list.
        l_type = 'std::__detail::_List_node_base*'
        start_ele = self.Ele(l_type, element.v)
        test_expr = '{} == ' + str(eval_uint('({})._M_prev'.format(start_ele)))

        yield from (self.Ele(element.t, e.v)
                    for e in
                    Terminated.single_iter(start_ele, test_expr,
                                           follow_expr='({})._M_next'))

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_ele, inpipe, self.__iter_helper)


class StdVector(walkers.Walker):
    '''Walk over elements in std::vector<T> vector.

    NOTE:
        This walker takes the type of the vector from the expression given.
        If the vector is not of the same type as the expression given there may
        very well be problems.

    Usage:
        gdb-pipe std-vector &v | show print *{}
        gdb-pipe eval &v | std-vector | show print *{}

    '''
    name = 'std-vector'
    tags = ['data']

    def __init__(self, start_ele):
        self.start_ele = start_ele

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(cls.calc(args.strip()) if first else None)

    def __iter_helper(self, element):
        yield from Terminated.single_iter(
            start_ele=self.calc('{0}._M_impl._M_start'.format(element)),
            test_expr='{{}} >= {0}._M_impl._M_finish'.format(element),
            follow_expr='{} + 1')

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_ele, inpipe, self.__iter_helper)


# TODO This doesn't import at the moment.
# Figure out exactly why, and what to do about it.
# from libstdcxx.v6.printers import StdMapPrinter

class StdMap(walkers.Walker):
    '''Walk across the nodes of a std::map.

    NOTE:
        This walker takes the type of the map from the expression given.
        If the map is not of the same type as the expression given there may
        very well be problems.

    Usage:
        gdb-pipe std-map &m | show print *{}
        gdb-pipe eval &m | std-map | show print *{}


    '''
    name = 'std-map'
    tags = ['data']

    def __init__(self, start_ele):
        # TODO As of yet I haven't figured out exactly when the auto-load
        # python scripts are loaded, and when this script is loaded.
        # I do know that this file is loaded before the auto-load scripts,
        # because I can't import this at the top level.
        # That is why this is imported here.
        # In the future I want to import this at the top level, after figuring
        # out the order that gdb does things in, and hopefully figuring out a
        # way around it.
        global StdMapPrinter
        from libstdcxx.v6.printers import StdMapPrinter
        self.start_ele = start_ele

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(cls.calc(args.strip()) if first else None)

    def _childiter_to_nodes(self, children_iter):
        while True:
            _ = next(children_iter)
            try:
                _ = next(children_iter)
            except StopIteration:
                raise IndexError('Uneven number of items in map!!')
            retval = int(as_uintptr(children_iter.pair.address))
            rettype = children_iter.pair.type.name
            yield self.Ele(rettype + '*', retval)

    def _iter_from_ele(self, start_ele):
        map_value = gdb.parse_and_eval(str(start_ele)).dereference()
        printer = StdMapPrinter('std::map', map_value)
        children_iter = printer.children()
        return self._childiter_to_nodes(children_iter)

    def __iter_helper(self, element):
        yield from self._iter_from_ele(element)

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_ele, inpipe, self.__iter_helper)
