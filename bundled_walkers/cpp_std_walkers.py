'''
Contains walkers for the C++ standard library.

Since the implementation is not a part of the standard and subject to change
without notice, the walkers in this file are inherently unstable.
'''

import re
import operator
import gdb
# Need the global value so that we don't get a copy of helpers.uintptr_t, and
# instead we see the updates made by start_handler().
import helpers
from helpers import eval_int, function_disassembly

class StdList(gdb.Walker):
    '''Walk over elements in a std::list<T> list.

    The walker
        std-list <list start>; <element type>;
    is the equivalent of follow-until on the std::__detail::_List_node_base
    pointers of the underlying list cast to <element type>.

    Usage:
        std-list &l; int | show print {}
        eval &l | std-list int
        std-list &l; int | show print {}->front()

    '''
    name = 'std-list'
    tags = ['data']

    def __init__(self, args, first, _):
        if first:
            start, self.element_type = self.parse_args(args, [2, 2], ';')
            self.start = self.calc(start)
        else:
            self.element_type = args
            self.start = None

        # TODO Is the list type always of this form?
        # NOTE: the space between the last two angle brackets is required.
        self.list_type = "'std::__cxx11::list<{},std::allocator<{}> >'*".format(
            self.element_type, self.element_type)

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
        kwargs = {
            'type': l_type,
            'init': element.v,
            'next': '_M_next',
            'prev': '_M_prev',
            'cur': '{}'
        }
        length_node = '(({type}){init}).{prev}'.format(**kwargs)
        kwargs['end'] = eval_int(length_node)
        walker_text = ('follow-until (({type}){init});'
                       ' {cur} == {end};'
                       ' (({type}){cur}).{next}').format(**kwargs)

        yield from (self.Ele(self.list_type, e.v)
                    for e in
                    gdb.create_pipeline(walker_text))

    def iter_def(self, inpipe):
        yield from self.call_with(self.start, inpipe, self.__iter_helper)
