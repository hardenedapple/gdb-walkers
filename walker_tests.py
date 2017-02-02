'''
A test framework for my gdb extensions desgined to be run from *outside* gdb.

We mock the gdb package.

'''
# vimcmd: !python -m unittest walker_tests

from types import ModuleType
import unittest
import unittest.mock as mock

fake_gdb = mock.MagicMock()
fake_gdb.COMMAND_USER = 1
fake_helpers = mock.MagicMock()

import sys
sys.modules['gdb'] = fake_gdb
sys.modules['helpers'] = fake_helpers

import walker


# First Test:
#   GdbWalker() class
#       GdbWalker.eval_user_expressions()
#           should split on all 

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
            fake_helpers.eval_int.reset_mock()
            self.assertEqual(walker.walker_defs.GdbWalker.eval_user_expressions(test_str),
                             test_str.replace(replace_str, '0x1'))
            # __index__() accounts for using the hex() method.
            fake_helpers.eval_int.assert_has_calls([mock.call(expression_str),
                                                    mock.call().__index__()])

        fake_helpers.eval_int.reset_mock()
        harder_string = r'$#(char *)&(myfunction(with, arguments))#strings random other $#main+4 + 8#'
        self.assertEqual(walker.walker_defs.GdbWalker.eval_user_expressions(harder_string),
                         r'0x1strings random other 0x1')
        fake_helpers.eval_int.assert_has_calls([mock.call(r'(char *)&(myfunction(with, arguments))'),
                                                mock.call().__index__(),
                                                mock.call(r'main+4 + 8'),
                                                mock.call().__index__()])
        fake_helpers.eval_int.reset_mock()

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
            fake_helpers.eval_int.reset_mock()
            argstr = '{type}; {start_addr}; {count}'.format(**test)
            w = walker.walker_defs.Array(argstr, True, False)
            if test['type'].find('*') == -1:
                fake_gdb.lookup_type.assert_called_once_with(test['type'])

            pre_parsed = test.get('expr_parsed', ('', ''))
            calls = []
            if pre_parsed != ('', ''):
                # This includes a call to __index__() because I call hex() on
                # the resultant value.
                calls.extend([mock.call(pre_parsed[1]), mock.call().__index__()])
            calls.append(mock.call('0x1' if pre_parsed[0] == 'start_addr'
                                    else test['start_addr']))
            calls.append(mock.call('0x1' if pre_parsed[0] == 'count'
                                   else test['count']))

            fake_helpers.eval_int.assert_has_calls(calls)


