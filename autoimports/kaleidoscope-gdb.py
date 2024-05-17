'''
Define helpers for working with Kaleidoscope.

N.b. this is only really helpful when running tests on Kaleidoscope (since the
code is firmware for keyboards and hence doesn't have an easy way of attaching
GDB to it).

The tests are not given a standard name -- they're given the name of the
testcase you define -- and there is no shared library they all use.  Hence the
autoimport mechanism will not naturally work with them.

'''

import gdb

class EventState(gdb.Function):
    '''Provide the name of a key state given the state name.'''
    def __init__(self):
        super(EventState, self).__init__('_event_state_name')

    def invoke(self, value):
        int_value = int(value)
        ret_elements = []
        if int_value   & 0b00000001:
            ret_elements.append('WAS_PRESSED')
        if int_value & 0b00000010:
            ret_elements.append('IS_PRESSED')
        if int_value == 0b10000000:
            ret_elements.append('INJECTED')
        if not ret_elements:
            return 'UNKNOWN'
        return ' & '.join(ret_elements)

EventState()
