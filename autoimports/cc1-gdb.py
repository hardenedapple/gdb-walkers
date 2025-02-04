'''
Define walkers over GCC data structures.

'''

import gdb
from helpers import as_int
import walkers
import walker_defs
import logging
# N.b. if wanting to use the logging after having loaded and started to use
# this script in GDB can use the following:
# vshcmd: > pi
# vshcmd: > autoimports.__dict__['0'].logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)
# >>> >>>
#
# Where the number to use when accessing this module could be found by looking
# for the `cc1*` entry in the output of the below
# vshcmd: > pi
# vshcmd: > autoimports.imported
# >>> {'cc1plus': 'autoimports.0', 'ld-linux-x86-64.so.2': 'autoimports.1', 'system-supplied DSO at 0x6fffd000': 'autoimports.2', 'librrpreload.so': 'autoimports.3', 'libdl.so.2': 'autoimports.4', 'libzstd.so.1': 'autoimports.5', 'libm.so.6': 'autoimports.6', 'libc.so.6': 'autoimports.7'}
# >>>
#
# Once the logging has been initialised pointing at sys.stdout one would then
# use the below to change the log level.
# vshcmd: > autoimports.__dict__['0'].logger.setLevel(logging.ERROR)
#
# Could certainly make this smoother, but for the moment this is working well
# enough.
logger = logging.getLogger(__name__)
logger.debug('Loading')

class Passes(walkers.Walker):
    """Walk over all passes and subpasses from an `opt_pass *`.

    If there are no subpasses this would be the same as
    gdb-pipe linked-list <head>; opt_pass; next

    NOTE:
        Whether you access the `opt_pass` object or the object of the child
        type is determined by `show print object` (the GDB setting).

    Use:
        gdb-pipe gcc-passes <pass_array>
        gdb-pipe eval <equation> | gcc-passes $cur

    Example:
        set print object on
        gdb-pipe gcc-passes rest_of_compilation | show print $cur->execute

    """
    name = 'gcc-passes'

    def __init__(self, start_expr):
        self.start_expr = start_expr

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(args)

    def iter_passes(self, init_addr):
        list_walk = self.format_command(init_addr, 'linked-list $cur; ->next')
        for gcc_pass in walkers.create_pipeline(list_walk):
            yield gcc_pass
            sub_value = gcc_pass['sub']
            if sub_value:
                yield from self.iter_passes(sub_value)

    def iter_def(self, inpipe):
        yield from self.call_with(inpipe, self.iter_passes, self.start_expr)


def expr_direction_parse(cls, args):
    cmd_parts = cls.parse_args(args, [1,2])
    if len(cmd_parts) == 2:
        assert cmd_parts[1] in ['forwards', 'backwards'], 'Direction must be one of "forwards" or "backwards".'
        forwards = True if cmd_parts[1] == 'forwards' else False
    else:
        forwards = True
    expr = cmd_parts[0]
    return cls(expr, forwards)


class InsnChain(walkers.Walker):
    '''Walk over all RTX insns in a chain.

    Follows the next/previous insn pointer in a chain.
    Is equivalent to
        gdb-pipe linked-list <start_insn>; ->u.fld[<1|0>].rt_rtx

    Use:
        gdb-pipe gcc-insns <start_insn>; [forwards|backwards]
        gdb-pipe eval <equation> | gcc-insns [forwards|backwards]

    Example:
        gdb-pipe gcc-insns (x_rtl)->emit.seq->first | show call debug_rtx($cur)

    '''
    name = 'gcc-insns'

    def __init__(self, start_expr, forwards=True):
        self.start_expr = start_expr
        self.forwards = forwards

    @classmethod
    def from_userstring(cls, args, first, last):
        return expr_direction_parse(cls, args)

    def iter_insns(self, init_addr):
        yield from walker_defs.LinkedList.single_iter(
            start_expr=self.format_command(init_addr, '$cur'),
            next_member='->u.fld[{}].rt_rtx'.format(1 if self.forwards else 0))

    def iter_def(self, inpipe):
        yield from self.call_with(inpipe, self.iter_insns, self.start_expr)


class GccHashMap(walkers.Walker):
    '''Walk over all elements in a GCC hash_map data structure.

    Is equivalent to
        gdb-pipe array <hash-map>->m_table.m_entries; <hash-map>->m_table.m_size
                | if !(<empty-expression>)
    Where <empty-expression> defaults to `*$cur == 0x0`, but should be adjusted
    depending on the type of the hash map value.

    Use:
        gdb-pipe gcc-hash-map <hash-map>[; <empty-expression>]

    Example:
        gdb-pipe gcc-hash-map &public_nonlocal
        gdb-pipe gcc-hash-map &addressed_nonlocal; $cur->m_key == 0x0
    '''
    name = "gcc-hash-map"
    def __init__(self, start_expr, empty_expr='*$cur == 0x0'):
        self.start_expr = start_expr
        self.empty_expr = empty_expr

    @classmethod
    def from_userstring(cls, args, first, last):
        cmd_parts = cls.parse_args(args, [1,2])
        if len(cmd_parts) == 2:
            return cls(cmd_parts[0], cmd_parts[1])
        else:
            return cls(cmd_parts[0])

    def __iter_single(self, init_addr):
        yield from walkers.connect_pipe([
            walker_defs.Array(
                start=self.format_command(
                    init_addr, '$cur->m_table.m_entries'),
                count=self.format_command(
                    init_addr, '$cur->m_table.m_size')),
            walker_defs.If(cmd='!({})'.format(self.empty_expr))])

    def iter_def(self, inpipe):
        yield from self.call_with(inpipe, self.__iter_single, self.start_expr)


class GccVec(walkers.Walker):
    '''Walk over all elements in a GCC vec data structure.

    Is equivalent to
        gdb-pipe array (<value-type> *)(<vec>->m_vec + 1); <vec>->m_vec.m_vecpfx.m_num

    N.b. without a debug build the value type may not be automatically
    identified and it would have to be manually specified on the command line.

    N.b. must pass the address to a vector rather than a vector value itself.

    Use:
        gdb-pipe gcc-vec <vec>[; <value-type>]

    '''
    # TODO Would be really nice to handle `auto_vec` as well.
    # Should be something like the current 
    name = "gcc-vec"
    def __init__(self, start_expr, value_type):
        self.start_expr = start_expr
        self.value_type = value_type

    @classmethod
    def from_userstring(cls, args, first, last):
        cmd_parts = cls.parse_args(args, [1, 2])
        return cls(cmd_parts[0], cmd_parts[1] if len(cmd_parts) == 2 else None)

    def __iter_single(self, init_addr):
        first_ptr = self.eval_command(init_addr, '$cur')
        # TODO Maybe references as well.
        assert (first_ptr.type.code == gdb.TYPE_CODE_PTR)
        vec_type = first_ptr.type.target()
        # TODO Using this for the moment.  If this turns out to work in a
        # different set of situations than the below then should attempt one
        # and the other if that fails.
        #       'm_vec' in [field.name for field in vec_type.fields()]
        is_embed = (False if vec_type.name.startswith('auto_vec') else
                    vec_type.template_argument(2).name == 'vl_embed')
        logger.debug('Identified vector as {}embedded'.format(
            '' if is_embed else 'not '))
        # Embedded vectors have actual data stored directly after this
        # structure instead of on the heap.
        vec_str = '$cur' if is_embed else '$cur->m_vec'
        first_value = self.eval_command(init_addr, vec_str)

        # If this happens need to adjust code to handle such a thing.
        assert (not first_value.type.dynamic)
        # assert ('vl_embed' in first_value.type)
        # Would like to do the below, but the type has a Null type name in most
        # builds.  Hence can't do it generally and in those cases have to use
        # the type argument.
        if first_value.type.target().name and not self.value_type:
            value_type = first_value.type.target().template_argument(0)
            value_type = str(value_type)
        elif not self.value_type:
            raise ValueError('GDB does not fully understand type {}'
                             ', please specify value type directly.'.format(
                                 first_value.type))
        else:
            value_type = self.value_type
        logger.debug('Identified value_type as: {}'.format(value_type))

        yield from walker_defs.Array.single_iter(
                start=self.format_command(
                    init_addr, '({} *)({} + 1)'.format(value_type, vec_str)),
                count=self.format_command(
                    init_addr, '{}.m_vecpfx.m_num'.format(vec_str)))

    def iter_def(self, inpipe):
        yield from self.call_with(inpipe, self.__iter_single, self.start_expr)

class TreeChain(walkers.Walker):
    '''Walk over TREE nodes in a TREE_CHAIN.

    Is a convenience wrapper around the below:
        gdb-pipe linked-list <chain-head>; ->common.chain 

    Use:
        gdb-pipe gcc-tree-chain <chain-head>

    Example;
        gdb-pipe gcc-tree-chain fndecl->decl_common.attributes 
            | show call debug_tree($cur->list.value)
    '''
    name = 'gcc-tree-chain'
    def __init__(self, start_expr):
        self.start_expr = start_expr

    @classmethod
    def from_userstring(cls, args, first, last):
        cmd_parts = cls.parse_args(args, [1, 1])
        return cls(cmd_parts[0])
    
    def __iter_single(self, init_addr):
        yield from walker_defs.LinkedList.single_iter(
                start_expr = self.format_command(init_addr, '$cur'),
                next_member = '->common.chain')

    def iter_def(self, inpipe):
        yield from self.call_with(inpipe, self.__iter_single, self.start_expr)


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
        gdb-pipe follow-until <start_stmt>; $cur == <start_stmt>; $cur->prev

    Use:
        gdb-pipe gcc-gimple <start_stmt>; [forwards|backwards]
        gdb-pipe eval <equation> | gcc-gimple [forwards|backwards]

    Example:
        gdb-pipe gcc-gimple cfun->cfg->x_entry_block_ptr->next_bb->il.gimple.seq; forwards
                | show call debug($cur)
    '''
    name = 'gcc-gimple'

    def __init__(self, start_expr, forwards=True):
        self.start_expr = start_expr
        self.forwards = forwards

    @classmethod
    def from_userstring(cls, args, first, last):
        return expr_direction_parse(cls, args)

    def iter_stmts(self, init):
        if self.forwards:
            yield from walker_defs.LinkedList.single_iter(
                start_expr=self.format_command(init, '$cur'),
                next_member='->next')
        else:
            # In the gimple structure, `prev` forms a loop.
            # Check for NULL init
            start_addr = as_int(init)
            if not start_addr:
                return
            yield init
            yield from walker_defs.Terminated.single_iter(
                start_expr=self.format_command(init, '$cur->prev'),
                test_expr='$cur == (void*){}'.format(start_addr),
                follow_expr='$cur->prev')

    def iter_def(self, inpipe):
        yield from self.call_with(inpipe, self.iter_stmts, self.start_expr)


class GimpleBlocks(walkers.Walker):
    '''Walk over basic blocks in a function.

    Follows the next_bb/prev_bb pointers of basic_block_def statements.
    Is equivalent to one of the below depending on direction.
        gdb-pipe linked-list <start_stmt>; next
        gdb-pipe linked-list <start_stmt>; prev

    Use:
        gdb-pipe gcc-bbs <start_stmt>; [forwards|backwards]

    Example:
        gdb-pipe gcc-bbs cfun->cfg->x_entry_block_ptr->next_bb
            | gcc-gimple $cur->il.gimple.seq
            | show call debug($cur)
        gdb-pipe gcc-bbs cfun->cfg->x_exit_block_ptr->prev_bb; backwards
            | gcc-gimple $cur->il.gimple.seq
            | show call debug($cur)

    '''
    name = 'gcc-bbs'

    def __init__(self, start_expr, forwards=True):
        self.start_expr = start_expr
        self.forwards = forwards

    @classmethod
    def from_userstring(cls, args, first, last):
        return expr_direction_parse(cls, args)

    def iter_bbs(self, init_addr):
        yield from walker_defs.LinkedList.single_iter(
            start_expr=self.format_command(init_addr, '$cur'),
            next_member='->next_bb' if self.forwards else '->prev_bb')

    def iter_def(self, inpipe):
        yield from self.call_with(inpipe, self.iter_bbs, self.start_expr)


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
