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
        pipe linked-list <start_insn>; rtx_insn; u.fld[<1|0>].rt_rtx

    Use:
        pipe gcc-insns <start_insn>; [forwards|backwards]
        pipe eval <equation> | gcc-insns [forwards|backwards]

    Example:
        pipe gcc-insns (x_rtl)->emit.seq->first | show call debug_rtx({})

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
            list_type='rtx_insn',
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
        pipe linked-list <start_stmt>; gimple; next

    Backwards direction is equivalent to the below (except that it still
    provides the first element)
        pipe follow-until <start_stmt>; {} == <start_stmt>; {}->prev

    Use:
        pipe gcc-gimple <start_stmt>; [forwards|backwards]
        pipe eval <equation> | gcc-gimple [forwards|backwards]

    Example:
        pipe gcc-gimple cfun->cfg->x_entry_block_ptr->next_bb->il.gimple.seq: \
            forwards | show call debug({})
    '''
    name = 'gcc-gimple'

    def __init__(self, start_ele, forwards=True):
        self.start_ele = start_ele
        self.forwards = forwards

    @classmethod
    def from_userstring(cls, args, first, last):
        return expr_direction_parse(cls, args, first, last)

    def iter_stmts(self, init_addr):
        if self.forwards:
            yield from walker_defs.LinkedList.single_iter(
                start_ele=init_addr,
                list_type='gimple',
                next_member='next')
        else:
            # Check for NULL init_addr
            if not init_addr.v:
                return
            yield init_addr
            yield from walker_defs.Terminated.single_iter(
                start_ele=self.calc('{}->prev'.format(init_addr)),
                test_expr='{{}} == {}'.format(init_addr),
                follow_expr='{}->prev')

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_ele, inpipe, self.iter_stmts)


class GimpleBlocks(walkers.Walker):
    '''Walk over basic blocks in a function.

    Follows the next_bb/prev_bb pointers of basic_block_def statements.
    Is equivalent to one of the below depending on direction.
        pipe linked-list <start_stmt>; struct basic_block_def; next
        pipe linked-list <start_stmt>; struct basic_block_def; prev

    Use:
        pipe gcc-bbs <start_stmt>; [forwards|backwards]
        pipe eval <equation> | gcc-bbs [forwards|backwards]

    Example:
        pipe gcc-bbs cfun->cfg->x_entry_block_ptr->next_bb
            | eval {}->il.gimple.seq
            | gcc-gimple
            | show call debug({})
        pipe gcc-bbs cfun->cfg->x_exit_block_ptr->prev_bb
            | gcc-gimple
            | show call debug({})

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
            list_type='struct basic_block_def',
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
