import gdb
import re

class OutputMatches(gdb.Function):
    '''Report whether the output of a given command includes some regex.

    This function is most useful to force existing gdb commands into a
    pipeline. So that one can do 
        pipe ... |  if $_output_contains("info symbol {}", ".text") | ...
    to filter based on whether an address given is in the text segment.

    Note, double quotes are required so that gdb passes the strings across to
    this python function as strings. Single quotes would be treated by gdb as
    quoting a file or function name (see info gdb section 'Program Variables'
    and section 'Examining the Symbol Table').

    Usage:
        $_output_contains(command_string, search_regex) => boolean

    '''
    def __init__(self):
        super(OutputMatches, self).__init__('_output_contains')

    def invoke(self, command, search_pattern):
        gdb_output = gdb.execute(command.string(), False, True)
        if re.search(search_pattern.string(), gdb_output):
            return True
        return False


class WhereIs(gdb.Function):
    '''Return source file and location of a .text address
    
    `$_whereis()` Returns the source file and line number of a .text memory
    address This is useful for piping into other commands, or running `gf` on
    in a vim buffer.

    Usage:
        $_whereis(some_function) => <file>:line#

    '''
    def __init__(self):
        super(WhereIs, self).__init__('_whereis')

    def invoke(self, arg):
        pos = gdb.find_pc_line(int(arg.cast(uintptr_t)))
        if not pos.symtab:
            return " $_whereis() Can't find symtab of address"
        return pos.symtab.filename + ':' + str(pos.line) 


class FunctionOf(gdb.Function):
    '''Return the function that this address is in.

    This is mainly useful for making nicely printed output (e.g. in a pipeline)

    Usage:
        $_function_of(0x400954)

    '''
    def __init__(self):
        super(FunctionOf, self).__init__('_function_of')

    def invoke(self, arg):
        pos_given = int(arg.cast(uintptr_t))

        # If given @plt addresses (or other problematic functions) just ignore
        # them and return an error message -- (better than raising an error?)
        try:
            block = gdb.block_for_pc(pos_given)
        except RuntimeError as e:
            if e.args == ('Cannot locate object file for block.',):
                return "$_function_of() Can't find {}".format(pos_given)
            raise

        while block.function.name is None:
            if block.superblock:
                block = block.superblock
            else:
                raise gdb.GdbError('Could not find enclosing function of '
                                   '{} ({})'.format(pos_given, arg))

        offset = pos_given - block.start
        offset_str = '+{}'.format(offset) if offset else ''

        return block.function.name + offset_str


# The functions below are taken from here
# https://github.com/tromey/gdb-helpers/blob/master/gdbhelpers
# thanks go to github user tromey for putting the functions online.
class Python(gdb.Function):
    '''$_python - evaluate a Python expression

    Usage:
        $_python(STR)

    This function evaluates a Python expression and returns
    the result to gdb.  STR is a string which is parsed and evalled.
    '''
    def __init__(self):
        super(Python, self).__init__('_python')

    def invoke(self, expr):
        return eval(expr.string())


class Typeof(gdb.Function):
    '''$_typeof - return the type of a value as a string.

    Usage:
        $_typeof(EXP)
    '''
    def __init__(self):
        super(Typeof, self).__init__('_typeof')

    def invoke(self, val):
        return str(val.dynamic_type)



OutputMatches()
WhereIs()
FunctionOf()
Python()
Typeof()
