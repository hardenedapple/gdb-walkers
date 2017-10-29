'''
Contains walkers for the C++ standard library.

Since the implementation is not a part of the standard and subject to change
without notice, the walkers in this file are inherently unstable.
'''

from helpers import eval_uint
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
        std-list &l | show print {}
        eval &l | std-list
        # If the address is known but no special
        eval ('std::__cxx11::list<int, std::allocator<int> >*')0x1111 | std-list
        # For the elements of that list.
        std-list &l | show print {}->front()

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
        std-vector &v | show print *{}
        eval &v | std-vector | show print *{}

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
