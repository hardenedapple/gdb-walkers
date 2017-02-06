'''Contains the definitions for general walkers

This module defines all the general walkers that can be applicable anywhere.
When making your own walkers, define them anywhere, and load them into the
gdb.walkers dictionary with gdb.register_walker().

'''
import abc
import re
import gdb
# Need the global value so that we don't get a copy of helpers.uintptr_t, and
# instead we see the updates made by start_handler().
import helpers
from helpers import eval_int

# TODO
#   Everywhere I look for the start and end of a function by using
#       gdb.block_for_pc() and getting the block start and end, I should be
#       able to find the function start and end using a minimal_symbol type.
#       This would allow using these functions without debugging symbols, at
#       the moment this doesn't work.
#
#       Places where replacing gdb.block_for_pc() and block.{start,end} with
#       something to do with minimal_symbols would allow working without
#       debugging information:
#           `call-graph`
#           `global-used`
#           `$_function_of()`
#           `walker called-functions`
#
#   Error messages are stored in the class.
#       (so that self.parse_args() gives useful error messages)
#
#   Why does gdb.lookup_global_symbol() not find global variables.
#   So far it only appears to find function names.
#
#   Current symbol table should be available without starting the process.
#
#   I should be able to get the current 'Architecture' type from the file
#   without having to have started the program.
#      This would mean Instruction could be called without starting the
#      inferior process.
#
#   Rename everything to match the functional paradigm? The question is really
#   what names would be most helpful for me (or anyone else) when searching
#   for a walker that matches my needs?
#      eval => map
#      if   => filter
#      I could have double names for some -- I would just need to change
#      register_walker so that it checks for 'name' and 'functional_name'
#      items in the class.


class GdbWalker(abc.ABC):
    '''
    Class for a walker type.

    These walkers should be registered with register_walker() so that they can
    be used with the `pipe` command.

    Each walker class is instantiated with the arguments given to it as a
    string, and two parameters indicating whether it is first or last in a
    pipeline (it can be both).

    A walker is required to implement the method `iter_def(self, inpipe)`.
    This method is passed the previous iterator as `inpipe` (this may be None
    if the walker is first in a command line).
    It is required to return an iterator over python integers.
    These integers usually represent addresses in the program space.

    '''
    name = 'XXX Default XXX Must name this class XXXX'
    require_input = False
    require_output = False
    tags = []

    def __init__(self, args, first, last):
        pass

    @abc.abstractmethod
    def iter_def(self, inpipe):
        pass

    @classmethod
    def eval_user_expressions(cls, string):
        '''Take argument `string` and replace all occurances of $#<expression>#
        with the value of the enclosed expression as evaluated by
        gdb.parse_and_eval() before being cast to an integer.

        These valus are then put back into the input string as hexadecimal
        constants.

        e.g.
            "hello there $#1 + 10#"
            =>
            "hello there 0xb"

        '''
        return_parts = []
        # TODO Make this a 'proper' parser -- for now I just hope no-one's
        # using '#' characters in their gdb expressions.
        pattern = r'\$#([^#]*)#'
        prev_end = 0
        for match in re.finditer(pattern, string):
            return_parts.append(string[prev_end:match.start()])
            return_parts.append(hex(eval_int(match.group(1))))
            prev_end = match.end()

        return_parts.append(string[prev_end:])
        return ''.join(return_parts)

    @classmethod
    def parse_args(cls, args, nargs=None, split_string=None,
                   strip_whitespace=True, maxsplit=-1):
        '''General function for parsing walker arguments.

        Replace occurances of $#<expression># with the evaluated expression,
        then split based on the split string given (if None given split on
        whitespace), then check the number of arguments are within nargs[0] and
        nargs[1].

        If strip_whitespace is given, then remove whitespace from all
        arguments.

        Return a list of strings as the arguments.

        '''
        if not args:
            return []
        # Replace $## covered expressions in the string with gdb
        args = cls.eval_user_expressions(args)

        # TODO Ignore escaped versions of split_string, then remove the escape
        # characters (i.e. backslashes) after splitting.
        retval = args.split(split_string, maxsplit)
        argc = len(retval)
        if nargs is not None and (argc < nargs[0] or argc > nargs[1]):
            raise ValueError('Walker "{}" takes between {} and {} '
                             'arguments.'.format(cls.name, nargs[0], nargs[1]))
        if strip_whitespace:
            retval = [val.strip() for val in retval]
        return retval

    @staticmethod
    def form_command(cmd_parts, element):
        '''Join `cmd_parts` with the hexadecimal string of `element`'''
        addr_str = '{}'.format(hex(int(element)))
        return addr_str.join(cmd_parts)


class Eval(GdbWalker):
    '''Parse args as a gdb expression.

    Replaces occurances of `{}` in the argument string with the values from a
    previous walker.
    Parses the resulting gdb expression, and outputs the value to the next
    walker.

    If `{}` does not appear in the argument string, takes no input and outputs
    one value.

    This is essentially a map command -- it modifies the stream of addresses in
    place.

    Use:
        eval  <gdb expression>

    Example:
        eval  {} + 8
        eval  {} != 0 && ((struct complex_type *){})->field
        eval  $saved_var->field

    '''

    name = 'eval'
    tags = ['general', 'interface']

    def __init__(self, args, first, last):
        if first:
            self.command_parts = self.parse_args(args, [1, 1], '{}', False)
            self.__iter_helper = self.__iter_without_input
            return

        self.command_parts = self.parse_args(args, None, '{}', False)
        self.__iter_helper = self.__iter_with_input

    def __iter_without_input(self, _):
        yield eval_int(self.command_parts[0])

    def __iter_with_input(self, inpipe):
        for element in inpipe:
            yield eval_int(self.form_command(self.command_parts, element))

    def iter_def(self, inpipe):
        return self.__iter_helper(inpipe)


class Show(GdbWalker):
    '''Parse the expression as a gdb command, and print its output.

    This must have input, and it re-uses that input as its output.
    If this is the last command it doesn't output anything.

    Use:
        show <gdb command>

    Example:
        show output {}
        show output (char *){}
        show output ((struct complex_type *){})->field

    '''
    name = 'show'
    require_input = True
    tags = ['general', 'interface']

    def __init__(self, args, _, last):
        self.is_last = last
        self.command_parts = self.parse_args(args, None, '{}', False)

    def iter_def(self, inpipe):
        for element in inpipe:
            command = self.form_command(self.command_parts, element)
            gdb_output = gdb.execute(command, False, True)
            print(gdb_output, end='')
            if not self.is_last:
                yield element


class Instruction(GdbWalker):
    '''Next `count` instructions starting at `start-address`.

    Usage:
        instructions [start-address]; [end-address]; [count]

    See gdb info Architecture.disassemble() for the meaning of arguments.
    `end-address` may be `None` to only use `count` as a limit on the number of
    instructions.

    If we're first in the pipeline, `start-address` is required, otherwise it
    is assumed to be the address given to us in the previous pipeline.

    Example:
        instructions main; main+10
        instructions main; NULL; 100
        // A pointless reimplementation of `disassemble`
        pipe instructions main, NULL, 10 | show x/i {}

    '''
    name = 'instructions'
    tags = ['data']

    def __init__(self, args, first, _):
        cmd_parts = self.parse_args(args, [2, 3] if first else [1, 2], ';')
        self.arch = gdb.current_arch()

        if first:
            self.start_address = eval_int(cmd_parts.pop(0))
        end = cmd_parts.pop(0)
        self.end_address = None if end == 'NULL' else eval_int(end)
        self.count = eval_int(cmd_parts.pop(0)) if cmd_parts else None

    def disass(self, start_address):
        '''
        Helper function.
        '''
        # TODO arch.disassemble default args.
        if self.end_address and self.count:
            return self.arch.disassemble(start_address,
                                         self.end_address,
                                         self.count)
        elif self.count:
            return self.arch.disassemble(start_address,
                                         count=self.count)
        elif self.end_address:
            return self.arch.disassemble(start_address,
                                         self.end_address)

        return self.arch.disassemble(start_address)

    def iter_def(self, inpipe):
        if self.start_address:
            for instruction in self.disass(self.start_address):
                yield instruction['addr']
        else:
            for start_address in inpipe:
                for instruction in self.disass(start_address):
                    yield instruction['addr']


class If(GdbWalker):
    '''Reproduces items that satisfy a condition.

    Replaces occurances of `{}` with the input address.

    Usage:
        if [condition]

    Example:
        if $_streq("Hello", (char_u *){})
        if ((complex_type *){}).field == 10
        if $count++ < 10

    '''
    name = 'if'
    require_input = True
    tags = ['general']

    def __init__(self, args, *_):
        self.command_parts = self.parse_args(args, None, '{}', False)

    def iter_def(self, inpipe):
        for element in inpipe:
            command = self.form_command(self.command_parts, element)
            if eval_int(command):
                yield element


class Head(GdbWalker):
    '''Only take first `N` items of the pipeline.

    Usage:
       head [N]

    '''
    name = 'head'
    require_input = True
    tags = ['general']

    def __init__(self, args, *_):
        # Use eval_int() so  user can use variables from the inferior without
        # having to wrap them in $##.
        self.limit = eval_int(self.parse_args(args, [1, 1])[0])

    def iter_def(self, inpipe):
        for count, element in enumerate(inpipe):
            if count >= self.limit:
                break
            yield element


class Tail(GdbWalker):
    '''Limit walker to last `N` items of pipeline.

    Usage:
        tail [N]

    '''
    name = 'tail'
    require_input = True
    tags = ['general']

    def __init__(self, args, *_):
        self.limit = eval_int(self.parse_args(args, [1, 1])[0])

    def iter_def(self, inpipe):
        # Could have the supposedly constant memory version of having a list
        # of the number of elements required, and setting each of those values
        # in turn, wrapping around when reaching the end.
        # In practice, it turns out this doesn't actually change the running
        # time.
        all_elements = list(inpipe)
        for element in all_elements[-self.limit:]:
            yield element


class Count(GdbWalker):
    '''Count how many elements were in the previous walker.

    Usage:
        count

    Example:
        pipe instructions main, main+100 | count

    '''
    name = 'count'
    require_input = True
    tags = ['general']

    def iter_def(self, inpipe):
        i = 0
        for i, _ in enumerate(inpipe):
            pass
        yield i + 1


class Array(GdbWalker):
    '''Iterate over each element in an array.

    Usage:
        If this is the first walker:
            array type; start_address; count

        Otherwise:
            array type; count

    Example:
        array char *; argv; argc

    '''
    name = 'array'
    tags = ['data']

    def __init__(self, args, first, _):
        if first:
            typename, start_addr, count = self.parse_args(args, [3, 3], ';')
            self.start_addr = eval_int(start_addr)
            self.__iter_helper = self.__iter_first
        else:
            typename, count = self.parse_args(args, [2, 2], ';')
            self.start_addr = None
            self.__iter_helper = self.__iter_pipe

        # TODO This is hacky, and we don't handle char[], &char that users
        # might like to use.
        if typename.find('*') != -1:
            self.element_size = helpers.uintptr_t.sizeof
        else:
            self.element_size = gdb.lookup_type(typename).sizeof

        self.count = eval_int(count)

    def __iter_first(self, _):
        cur_pos = self.start_addr
        for _ in range(self.count):
            yield cur_pos
            cur_pos += self.element_size

    def __iter_pipe(self, inpipe):
        for element in inpipe:
            self.start_addr = int(element)
            yield from self.__iter_first(None)

    def iter_def(self, inpipe):
        return self.__iter_helper(inpipe)


class Until(GdbWalker):
    '''Accept and pass through elements until a condition is broken.

    Can't be the first walker.

    Usage:
        pipe ... | take-while ((struct *){})->field != marker

    '''
    name = 'take-while'
    require_input = True
    tags = ['general']

    def __init__(self, args, *_):
        self.command_parts = self.parse_args(args, None, '{}', False)

    def iter_def(self, inpipe):
        for element in inpipe:
            if not eval_int(self.form_command(self.command_parts, element)):
                break
            yield element


class Since(GdbWalker):
    '''Skip items until a condition is satisfied.

    Returns all items in a walker since a condition was satisfied.

    Usage:
        pipe ... | skip-until ((struct *){})->field == $#marker#

    '''
    name = 'skip-until'
    require_input = True
    tags = ['general']

    def __init__(self, args, *_):
        self.command_parts = self.parse_args(args, None, '{}', False)

    def iter_def(self, inpipe):
        for element in inpipe:
            if eval_int(self.form_command(self.command_parts, element)):
                break
        for element in inpipe:
            yield element


class Terminated(GdbWalker):
    '''Follow "next" pointer until reach terminating condition.

    Uses given expression to find the "next" pointer in a sequence, follows
    this expression until a terminating value is reached.
    The terminating value is determined by checking if a `test-expression`
    returns true.

    Usage:
        follow-until <test-expression>; <follow-expression>
        follow-until start-addr; <test-expression>; <follow-expression>

    Example:
        follow-until argv; *{} == 0; {} + sizeof(char **)
        pipe eval *(char **)argv \\
            | follow-until *(char *){} == 0; {} + sizeof(char) \\
            | show x/c {}

    '''
    name = 'follow-until'
    tags = ['data']

    def __init__(self, args, first, _):
        if first:
            start, test_expr, follow_expr = self.parse_args(args, [3, 3], ';')
            self.start = eval_int(start)
        else:
            test_expr, follow_expr = self.parse_args(args, [2, 2], ';')
            self.start = None

        # Here we split the arguments into something that will form the
        # arguments next.
        self.test_cmd = self.parse_args(test_expr, None, '{}', False)
        self.follow_cmd = self.parse_args(follow_expr, None, '{}', False)

    def follow_to_termination(self, start):
        while eval_int(self.form_command(self.test_cmd, start)) == 0:
            yield start
            start = eval_int(self.form_command(self.follow_cmd, start))

    def iter_def(self, inpipe):
        if self.start:
            assert not inpipe
            yield from self.follow_to_termination(self.start)
        else:
            for element in inpipe:
                yield from self.follow_to_termination(element)


class Devnull(GdbWalker):
    '''Completely consume the previous walker, but yield nothing.

    Usage:
        pipe ... | devnull

    '''
    name = 'devnull'
    require_input = True
    tags = ['general']

    def iter_def(self, inpipe):
        for _ in inpipe:
            pass


class Reverse(GdbWalker):
    '''Reverse the iteration from the previous command.

    Usage:
        pipe ... | reverse

    Examples:
        pipe array char; 1; 10 | reverse

    '''
    name = 'reverse'
    require_input = True
    tags = ['general']

    def iter_def(self, inpipe):
        all_elements = list(inpipe)
        all_elements.reverse()
        for element in all_elements:
            yield element


class Functions(GdbWalker):
    '''Walk through the call tree of all functions.

    Given a function name/address, walk over all functions this function calls,
    and all functions called by those etc up to maxdepth.

    It skips all functions defined in a file that doesn't match file-regex.
    This part is very important as it avoids searching all functions in
    used libraries.

    We avoid recursion by simply ignoring all functions already in the current
    hypothetical stack.

    This walker is often used with the `hypothetical-stack` command to print
    the current hypothetical stack.

    NOTE:
        This walker is far from perfect. It does not account for directly
        jumping to a function (using the "jmp" instructions) or for calling a
        function indirectly.

        If gdb can't tell what function something is calling with the
        `disassemble` command (i.e. if the disassembly instructions aren't
        annotated with the function name) then this walker will not pick it
        up.

    Usage:
        called-functions [funcname | funcaddr]; [file-regex]; [maxdepth]

    '''
    name = 'called-functions'
    tags = ['data']

    # NOTE -- putting this in the class namespace is a hack so the
    # hypothetical-call-stack walker can find it.
    hypothetical_stack = []

    # TODO
    #   Allow default arguments?
    def __init__(self, args, first, _):
        self.cmd_parts = self.parse_args(args, [3,3] if first else [2,2], ';')
        self.maxdepth = eval_int(self.cmd_parts[-1])
        self.file_regex = self.cmd_parts[-2].strip()

        self.func_stack = []
        # hypothetical_stack checks for recursion, but also allows the
        # hypothetical-call-stack walker to see what the current stack is.
        type(self).hypothetical_stack = []
        if first:
            self.__add_addr(eval_int(self.cmd_parts[0]), 0)
        self.arch = gdb.current_arch()

    def __add_addr(self, addr, depth):
        # Use reverse stack because recursion is more likely a short-term
        # thing.
        if addr and addr not in self.hypothetical_stack[::-1]:
            self.func_stack.append((addr, depth))

    @staticmethod
    def __func_addr(instruction):
        elements = instruction['asm'].split()
        # Make sure the format for this instruction is
        # call... addr <func_name>
        # Ignore those functions with @plt in them.
        # Return the address converted to a number.
        if re.match('<[^@]*>', elements[-1]) and len(elements) == 3 and \
                elements[0].startswith('call'):
            # Just assume it's always hex -- I can't see any way it isn't, but
            # this assumption makes me a little uneasy.
            return int(elements[1], base=16)
        return None

    def __iter_helper(self):
        '''
        Iterate over all instructions in a function, put each `call`
        instruction on a stack.

        Continue until no more functions are found, or until `maxdepth` is
        exceeded.

        Skip any recursion by ignoring any functions already in the
        hypothetical stack we have built up.

        '''
        while self.func_stack:
            func_addr, depth = self.func_stack.pop()
            if self.maxdepth >= 0 and depth > self.maxdepth:
                continue

            # Store the current value in the hypothetical_stack for someone
            # else to query - remember to set the class attribute.
            type(self).hypothetical_stack[depth:] = [func_addr]
            yield func_addr

            try:
                func_block = gdb.block_for_pc(func_addr)
            except RuntimeError as e:
                # Cannot locate object file for block
                if e.args == ('Cannot locate object file for block.', ):
                    func_block = None
                else:
                    raise e

            # Catches not found block and block where object file was not
            # found.
            if not func_block:
                continue

            func_file = func_block.function.symtab.filename
            if not re.match(self.file_regex, func_file):
                continue

            # Go backwards through the list so that we pop off elements in the
            # order they will be called.
            # Remove the last element in the list because the disassemble
            # function has been given the end of the block as it's end
            # argument, which is past the last retq instruction of the block.
            for val in self.arch.disassemble(func_block.start,
                                             func_block.end)[-2::-1]:
                new_addr = self.__func_addr(val)
                self.__add_addr(new_addr, depth + 1)

    def iter_def(self, inpipe):
        if not inpipe:
            yield from self.__iter_helper()
            return

        # Deal with each given function (and all their descendants) in turn.
        for element in inpipe:
            type(self).hypothetical_stack = []
            self.__add_addr(element, 0)
            yield from self.__iter_helper()


class File(GdbWalker):
    '''Walk over numbers read in from a file.

    Yields addresses read in from a file, one line at a time.
    Addresses in the file sholud be hexadecimal strings.

    Often used to concatenate two walkers.
        shellpipe pipe walker1 [args1 ..] ! cat > output.txt
        shellpipe pipe walker2 [args2 ..] ! cat >> output.txt
        pipe file output.txt | ...

    Usage:
        pipe file addresses.txt | ...

    '''
    name = 'file'
    tags = ['general']

    def __init__(self, args, first, _):
        if not first:
            raise ValueError('`file` walker cannot take input')
        self.filenames = gdb.string_to_argv(args)

    def iter_def(self, inpipe):
        for filename in self.filenames:
            with open(filename, 'r') as infile:
                for line in infile:
                    yield int(line, base=16)


class HypotheticalStack(GdbWalker):
    '''Print the hypothetical function stack called-functions has created.

    The `called-functions` walker creates a hypothetical stack each time it
    looks at what functions could be called.
    This hypothetical stack is kept around in the state of the called-functions
    walker.
    This walker prints out that stack.

    This walker is mainly useful in a pipeline preceded by `called-functions`,
    where it can print the current hypothetical position based on different
    queries.

    It yields all values it was given.

    You can also use it to show the last hypothetical call stack from the
    previous walker.

    NOTE:
        This walker doesn't walk over the addresses where things were called,
        but the addresses of each function that was called.
        This makes things much simpler in the implementation of the
        `called-functions` walker.

    Usage:
        pipe called-functions main; .*; -1 |
            if $_output_contains("global-used {} curwin", "curwin") |
            hypothetical-call-stack

        pipe called-functions main; .*; -1 | ...
        pipe hypothetical-call-stack

    '''
    name = 'hypothetical-call-stack'
    tags = ['data']

    def __init__(self, args, *_):
        if args and args.split() != []:
            raise ValueError('hypothetical-call-stack takes no arguments')
        self.called_funcs_class = gdb.walkers['called-functions']

    def iter_def(self, inpipe):
        if not inpipe:
            yield from self.called_funcs_class.hypothetical_stack
            return

        for _ in inpipe:
            yield from self.called_funcs_class.hypothetical_stack


for walker in [Eval, Show, Instruction, Head, Tail, If, Array, Count,
               Terminated, Until, Devnull, Since, Reverse, Functions, File,
               HypotheticalStack]:
    gdb.register_walker(walker)
