'''
Functions and commands helpful for working with boost::interprocess data types.

'''
import gdb
import helpers
import walkers
import walker_defs

def raw_ptr_from_offsetptr(myvar):
    '''Get addr in memory of data from offset pointer.

    Given a gdb.Value representing a boost interprocess offset-pointer, return
    the actual position in memory of the data this pointer addresses.

    This is not a very clever function, it relies on the internals of the
    boost::interprocess offset pointers and is hence subject to breaking for
    different boost versions.

    We use the representation found in boost 1_65_1, which is that the offset
    pointer contains an offset from its own address to the address of the data
    it points to.

    This function ignores types, as the type of an offset pointer does not
    appear to contain information of the type it points to.

    '''
    addr_of_value = int(myvar.address)
    offset_value = int(myvar['internal']['m_offset'])
    return addr_of_value + offset_value


class Raw_ptr_from_Offsetptr(gdb.Function):
    '''Return raw address represented by the given interprocess offset pointer.

    Uses the observed behaviour that an interprocess offset vector points to
    an address at a given offset from itself, and that said offset is stored in
    the internal.m_offset member.

    NOTE:
        This function must be given an address pointer that exists in the
        memory of the underlying process.
        Hence an invokation like $_rawp_from_offsetp(ipvec.m_holder.m_start)
        will work, but an invokation like
            (gdb) set $start = ipvec.m_holder.m_start
            (gdb) print $_rawp_from_offsetp($start)
        will not.
        This is because the $start variable will be in gdb's memory space
        and not the memory space of the inferior.

        One can use temporary gdb variables by doing something like
            (gdb) set $start = &ipvec.m_holder.m_start
            (gdb) print $_rawp_from_offsetp(*$start)

    '''
    def __init__(self):
        super(Raw_ptr_from_Offsetptr, self).__init__('_rawp_from_offsetp')

    def invoke(self, value):
        return raw_ptr_from_offsetptr(value)


class InterprocessVector(walkers.Walker):
    '''Walk over items in a boost interprocess vector.

    NOTE:
        This walker takes the type of elements from the expression given.
        Hence the type passed to this walker *must* be of the same type as the
        vector you are inspecting.

    Usage:
        interprocess-vector &v | show print *{}
        eval &v | interprocess-vector | show print *{}
        eval 0x7ffeb | eval (boost::interprocess::vector<...>*){.v} |
            interprocess-vector | show print *{}

    '''
    name = 'interprocess-vector'
    tags = ['data', 'boost::interprocess']

    def __init__(self, start_ele):
        self.start_ele = start_ele

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(cls.calc(args.strip()) if first else None)

    def __iter_helper(self, ele):
        element = gdb.parse_and_eval(str(ele))
        element_type = element.type.target().template_argument(0)
        start_ptr = raw_ptr_from_offsetptr(element['m_holder']['m_start'])
        num_elements = int(element['m_holder']['m_size'])
        yield from walker_defs.Array.single_iter(
            True,
            start_ptr,
            num_elements,
            element_type.name + '*',
            element_type.sizeof)

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_ele, inpipe, self.__iter_helper)


Raw_ptr_from_Offsetptr()
