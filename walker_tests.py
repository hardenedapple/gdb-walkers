'''
A test framework for my gdb extensions desgined to be run from *outside* gdb.

We mock the gdb package.

'''

from types import ModuleType
import unittest
import unittest.mock as mock

# Mock the gdb module
# This is currently a very hackish mocking, it works because I know I only use
# these functions/classes, and because I don't need to proove things have been
# called as yet.
class FakeGdbValue():
    def __init__(self, _=None): pass
    def __int__(self): return 1
    def cast(self, _): return self


class FakeGdbType():
    def __init__(self, _=None): self.sizeof = 1
    def pointer(self): return self


class FakeGdbFrameArch():
    '''Mocks both the Frame class *and* the Architecture class.'''
    def __init__(self, _=None): pass
    def architecture(self): return self
    def disassemble(self, *_): return [{'addr': 1}]


class FakeGdbCommand():
    def __init__(self, name, command_type):
        pass
    def dont_repeat(self):
        pass


fake_gdb = mock.MagicMock()
fake_gdb.COMMAND_USER = 1

import sys
sys.modules['gdb'] = fake_gdb


import walker


# First Test:
#   GdbWalker() class
#       GdbWalker.eval_user_expressions()
#           should split on all 

def eval_int_called(call_string):
    return [mock.call(call_string), mock.call().cast(walker.uintptr_t),
            mock.call().cast().__int__()]

class TestWalkerParsing(unittest.TestCase):
    '''
    Ensure the walker parsing methods function as expected.
    '''
    def test_eval_expr(self):
        '''
        Test that my parsing function does what's expected of it at the moment.
        '''
        test_strings = [
            r'$#main+4 + 8# random other strings',
            r'other random $#main+4 + 8# strings',
            r'strings random other $#main+4 + 8#',
        ]

        expression_str = 'main+4 + 8'
        replace_str = r'$#%s#' % expression_str
        for test_str in test_strings:
            fake_gdb.parse_and_eval.reset_mock()
            self.assertEqual(walker.GdbWalker.eval_user_expressions(test_str),
                             test_str.replace(replace_str, '0x1'))
            fake_gdb.parse_and_eval.assert_called_once_with(expression_str)

        fake_gdb.parse_and_eval.reset_mock()
        harder_string = r'$#(char *)&(myfunction(with, arguments))#strings random other $#main+4 + 8#'
        self.assertEqual(walker.GdbWalker.eval_user_expressions(harder_string),
                         r'0x1strings random other 0x1')
        fake_gdb.parse_and_eval.assert_has_calls(
            eval_int_called(r'(char *)&(myfunction(with, arguments))')
            + eval_int_called(r'main+4 + 8'))
        fake_gdb.parse_and_eval.reset_mock()

    def test_array_walker_parse(self):
        test_arguments = [
            {'type': 'struct mystructure',
             'start_addr': '0x7bffe',
             'count': '100' },
            {'type': 'struct mystructure **',
             'start_addr': '0x7bffe',
             'count': '100' },
            {'type': 'int',
             'start_addr': '$#value#',
             'count': '10',
             'expr_parsed': ('start_addr', 'value') },
            {'type': 'int',
             'start_addr': '0x7bffe',
             'count': '$#value#',
             'expr_parsed': ('count', 'value') },
            {'type': 'int *',
             'start_addr': '0x7bffe',
             'count': '100' }
        ]

        for test in test_arguments:
            fake_gdb.lookup_type.reset_mock()
            fake_gdb.parse_and_eval.reset_mock()
            argstr = '{type}, {start_addr}, {count}'.format(**test)
            w = walker.ArrayWalker(argstr, True, False)
            if test['type'].find('*') == -1:
                fake_gdb.lookup_type.assert_called_once_with(test['type'])

            pre_parsed = test.get('expr_parsed', ('', ''))
            calls = []
            if pre_parsed != ('', ''):
                calls.extend(eval_int_called(pre_parsed[1]))
            calls.extend(eval_int_called(
                '0x1' if pre_parsed[0] == 'start_addr'
                else test['start_addr']))
            calls.extend(eval_int_called(
                '0x1' if pre_parsed[0] == 'count'
                else test['count']))

            fake_gdb.parse_and_eval.assert_has_calls(calls)


