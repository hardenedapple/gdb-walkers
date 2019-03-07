'''
Define walkers over GCC data structures.

'''

import itertools as itt
import gdb
from helpers import offsetof, eval_uint, uintptr_size, find_type_size
import walkers
import walker_defs

class Passes(walkers.Walker):
    """Walk over all passes and subpasses from an `opt_pass *`.

    If there are no subpasses this would be the same as
    pipe linked-list <head>; opt_pass; next

    Use:
        pipe gcc-passes <pass_array>
        pipe eval <equation> | gcc-passes

    Example:
        pipe gcc-passes rest_of_compilation | show print {}->name

    """
    name = 'gcc-passes'

    def __init__(self, start):
        self.nested_offset = offsetof('opt_pass', 'sub')
        self.start = start

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(cls.calc(args) if first else None)

    def iter_passes(self, init_addr):
        pass_ptr = self.Ele('opt_pass *', init_addr.v)
        list_walk = 'linked-list {0}; opt_pass; next'.format(pass_ptr)
        for gcc_pass in walkers.create_pipeline(list_walk):
            yield gcc_pass
            value = gdb.parse_and_eval(str(gcc_pass)).dereference()
            sub_value = int(value['sub'])
            if sub_value:
                yield from self.iter_passes(self.Ele(gcc_pass.t, sub_value))

    def iter_def(self, inpipe):
        yield from self.call_with(self.start, inpipe, self.iter_passes)


## Stuff specifically for printing out RTX functions in the format ready for
#  reading in as an __RTL testcase.
class SetRTXFinishBreak(gdb.Command):
    def __init__(self):
        super(SetRTXFinishBreak, self).__init__(
            'set-finish-rtx-print', gdb.COMMAND_USER)

    def invoke(self, _, __):
        fin_break = gdb.FinishBreakpoint(internal=True)
        fin_break.commands = '\n'.join(['silent',
                                        'call print_rtx_function(stderr, cfun, true)',
                                        'cont'])

class PrintRTX(gdb.Command):
    '''Call `print_rtx_function(stderr, cfun, true)` just after a given pass.

    This command prints the RTX of the function named by its first argument
    just after the pass named by its second.
    This is useful making starting points for RTL tests in GCC.

    Usage:
        print-rtx function_foo peephole2

    '''
    # TODO Figure out how to open a specific file in C and print to that file
    # instead of to stderr.
    # TODO Alternatively, redirect GCC's stderr to a given file (just before
    # running the command?).
    def __init__(self):
        super(PrintRTX, self).__init__('print-rtx', gdb.COMMAND_USER)

    def invoke(self, args, _):
        function_name, pass_address = args.split(None, 1)
        bp = gdb.Breakpoint('*{}'.format(pass_address))
        bp.condition = r'$_streq(function_name(cfun), "{}")'.format(
            function_name)
        bp.commands = '\n'.join(['set-finish-rtx-print', 'cont'])


SetRTXFinishBreak()
PrintRTX()
####
