'''
Contains walkers for the C++ standard library.

Since the implementation is not a part of the standard and subject to change
without notice, the walkers in this file are inherently unstable.
'''

from helpers import eval_int
import walkers

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

    def __init__(self, args, first, _):
        self.start = self.calc(args.strip()) if first else None

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

        yield from (self.Ele(element.t, e.v)
                    for e in
                    walkers.create_pipeline(walker_text))

    def iter_def(self, inpipe):
        yield from self.call_with(self.start, inpipe, self.__iter_helper)


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

    def __init__(self, args, first, _):
        self.start = self.calc(args.strip()) if first else None

    def __iter_helper(self, element):
        walker_text = ('follow-until {0}._M_impl._M_start; '
                       '{{}} >= {0}._M_impl._M_finish; '
                       '{{}} + 1').format(element)
        yield from walkers.create_pipeline(walker_text)

    def iter_def(self, inpipe):
        yield from self.call_with(self.start, inpipe, self.__iter_helper)
