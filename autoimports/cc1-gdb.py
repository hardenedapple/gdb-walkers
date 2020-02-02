'''
Define walkers over GCC data structures.

'''

import itertools as itt
import gdb
from helpers import as_int, offsetof, eval_uint, uintptr_size, find_type_size
import walkers
import walker_defs

class Passes(walkers.Walker):
    """Walk over all passes and subpasses from an `opt_pass *`.

    If there are no subpasses this would be the same as
    gdb-pipe linked-list <head>; opt_pass; next

    NOTE:
        When using $cur, this walker will give you the underlying `opt_pass`
        object.  When using $addr then whether you access the `opt_pass` object
        or the object of the child type is determined by `show print object`
        (the GDB setting).

    Use:
        gdb-pipe gcc-passes <pass_array>
        gdb-pipe eval <equation> | gcc-passes

    Example:
        gdb-pipe gcc-passes rest_of_compilation | show print $cur.name
        set print object on
        gdb-pipe gcc-passes rest_of_compilation | show print $addr->execute

    """
    name = 'gcc-passes'

    def __init__(self, start):
        self.nested_offset = offsetof('opt_pass', 'sub')
        self.start = start

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(cls.calc(args) if first else None)

    def iter_passes(self, init_addr):
        gdb.set_convenience_variable('cur', init_addr)
        list_walk = 'linked-list $cur; next'
        for gcc_pass in walkers.create_pipeline(list_walk):
            yield gcc_pass
            sub_value = gcc_pass['sub']
            if sub_value:
                yield from self.iter_passes(sub_value)

    def iter_def(self, inpipe):
        yield from self.call_with(self.start, inpipe, self.iter_passes)


def expr_direction_parse(cls, args, first, last):
    cmd_parts = cls.parse_args(args, [1,2] if first else [0,1], ';')
    if len(cmd_parts) == 1 + first:
        assert cmd_parts[-1] in ['forwards', 'backwards'], 'Direction must be one of "forwards" or "backwards".'
        forwards = True if cmd_parts[-1] == 'forwards' else False
    else:
        forwards = True
    expr = cls.calc(cmd_parts[0]) if first else None
    return cls(expr, forwards)


class InsnChain(walkers.Walker):
    '''Walk over all RTX insns in a chain.

    Follows the next/previous insn pointer in a chain.
    Is equivalent to
        gdb-pipe linked-list <start_insn>; u.fld[<1|0>].rt_rtx

    Use:
        gdb-pipe gcc-insns <start_insn>; [forwards|backwards]
        gdb-pipe eval <equation> | gcc-insns [forwards|backwards]

    Example:
        gdb-pipe gcc-insns *(x_rtl)->emit.seq->first | show call debug_rtx($addr)

    '''
    name = 'gcc-insns'

    def __init__(self, start_ele, forwards=True):
        self.start_ele = start_ele
        self.forwards = forwards

    @classmethod
    def from_userstring(cls, args, first, last):
        return expr_direction_parse(cls, args, first, last)

    def iter_insns(self, init_addr):
        yield from walker_defs.LinkedList.single_iter(
            start_ele=init_addr,
            next_member='u.fld[{}].rt_rtx'.format(1 if self.forwards else 0))

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_ele, inpipe, self.iter_insns)


# TODO Handle CFG information as well.
# Currently don't know where this information is, but in the dumps we get
# output around `goto` statements and `else` statements that we don't get
# simply iterating through the gimple.

class GimpleStatements(walkers.Walker):
    '''Walk over gimple statements in a sequence.

    Follows the next/prev pointer in a chain.
    Forwards direction is equivalent to
        gdb-pipe linked-list <start_stmt>; gimple; next

    Backwards direction is equivalent to the below (except that it still
    provides the first element)
        gdb-pipe follow-until <start_stmt>; {} == <start_stmt>; {}->prev

    Use:
        gdb-pipe gcc-gimple <start_stmt>; [forwards|backwards]
        gdb-pipe eval <equation> | gcc-gimple [forwards|backwards]

    Example:
        gdb-pipe gcc-gimple cfun->cfg->x_entry_block_ptr->next_bb->il.gimple.seq: \
            forwards | show call debug({})
    '''
    name = 'gcc-gimple'

    def __init__(self, start_ele, forwards=True):
        self.start_ele = start_ele
        self.forwards = forwards

    @classmethod
    def from_userstring(cls, args, first, last):
        return expr_direction_parse(cls, args, first, last)

    def iter_stmts(self, init):
        if self.forwards:
            yield from walker_defs.LinkedList.single_iter(
                start_ele=init,
                next_member='next')
        else:
            # In the gimple structure, `prev` forms a loop.
            # Check for NULL init
            start_addr = as_int(init.address)
            if not start_addr:
                return
            yield init
            yield from walker_defs.Terminated.single_iter(
                start_ele=self.eval_command(init, '*$cur.prev'),
                test_expr='$addr == {}'.format(start_addr),
                follow_expr='*$cur.prev')

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_ele, inpipe, self.iter_stmts)


class GimpleBlocks(walkers.Walker):
    '''Walk over basic blocks in a function.

    Follows the next_bb/prev_bb pointers of basic_block_def statements.
    Is equivalent to one of the below depending on direction.
        gdb-pipe linked-list <start_stmt>; next
        gdb-pipe linked-list <start_stmt>; prev

    Use:
        gdb-pipe gcc-bbs <start_stmt>; [forwards|backwards]
        gdb-pipe eval <equation> | gcc-bbs [forwards|backwards]

    Example:
        gdb-pipe gcc-bbs cfun->cfg->x_entry_block_ptr->next_bb
            | eval $addr->il.gimple.seq
            | gcc-gimple
            | show call debug($addr)
        gdb-pipe gcc-bbs cfun->cfg->x_exit_block_ptr->prev_bb; backwards
            | eval $addr->il.gimple.seq
            | gcc-gimple
            | show call debug($addr)

    '''
    name = 'gcc-bbs'

    def __init__(self, start_ele, forwards=True):
        self.start_ele = start_ele
        self.forwards = forwards

    @classmethod
    def from_userstring(cls, args, first, last):
        return expr_direction_parse(cls, args, first, last)

    def iter_bbs(self, init_addr):
        yield from walker_defs.LinkedList.single_iter(
            start_ele=init_addr,
            next_member='next_bb' if self.forwards else 'prev_bb')

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_ele, inpipe, self.iter_bbs)


## Stuff specifically for printing out RTX functions in the format ready for
#  reading in as an __RTL testcase.
class SetRTXFinishBreak(gdb.Command):
    '''Craate a finish breakpoint that calls `print_rtx_function`.

    When called this command creates a breakpoint upon returning from the
    current function (like the "finish" command), with the "commands"
    silent
    call `print_rtx_function(stderr, cfun, true)`
    end
    associated with that checkpoint.'''
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
