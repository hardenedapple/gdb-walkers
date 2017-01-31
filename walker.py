'''
A GdbWalker class that produces an iterator over something to be part of a
pipeline.

'''

import enum
import gdb
import abc
import re
import collections

gdb.walkers = {}

class GdbWalkerError(gdb.GdbError):
    pass

class GdbWalkerExistsError(GdbWalkerError):
    pass

class GdbWalkerValueError(GdbWalkerError):
    pass


class Pipeline(gdb.Command):
    '''Combine logical filters to work on many addresses in sequence.

    `pipe` command to string multiple commands together.

    Usage:
        pipe walker1 | walker2 | walker3 ...

    Use:
        (gdb) python print([name for name in gdb.walkers])
    to see what walkers are available.

    Use:
        (gdb) python print(gdb.walkers[name].__doc__)
    to show the help for that walker.
    '''
    def __init__(self):
        super(Pipeline, self).__init__('pipe', gdb.COMMAND_USER)
        # TODO Make this a parameter you can set inside gdb
        self.default = 'eval'

    def create_walker(self, walker_def, first=False, last=False):
        '''
        Find walker called for by walker_def, initialise it with the walker_def
        arguments.

        Treat the first word in a walker definition as the walker name.
        Look up the walker registered under that name, if it exists then use
        that walker, otherwise put the first word back into the walker
        arguments and use the default walker.

        When initialising the walker, tell it if it is the first walker and/or
        if it's the last walker.

        '''
        command_split = walker_def.strip().split(None, maxsplit=1)

        assert(len(command_split) <= 2)
        walker_name = command_split[0]
        args = command_split[1] if len(command_split) == 2 else ''

        # Default walker is to evaluate the expression
        if walker_name not in gdb.walkers:
            args = walker_name + ' ' + args
            walker_name = self.default

        walker = gdb.walkers[walker_name]
        if walker.require_input and first or walker.require_output and last:
            raise GdbWalkerValueError('Walker "{}" either requires an input or '
                                      'an output and has been put somewhere '
                                      'where this is not given to it.'.format(
                                          walker_name))
        # May raise GdbWalkerValueError if the walker doesn't like the arguments
        # it's been given.
        return walker(args if args else None, first, last)

    def connect_pipe(self, source, segments, drain):
        '''
        Each walker in the pipe is called with the iterator returned by its
        predecessor.

        Return the iterator that the last walker returns.

        '''
        # If there is one element in the pipe, we are given
        # source=element, segments=[], drain=None
        #
        # If there are two elements in the pipe, we are given
        # source=first, segments=[], drain=second
        #
        # Otherwise we are given
        # source=first, segments=[rest], drain=last

        walker = source.iter_def(inpipe=[])
        if not segments and not drain:
            return walker

        for segment in segments:
            walker = segment.iter_def(inpipe=walker)

        walker = drain.iter_def(inpipe=walker)
        return walker

    def invoke(self, arg, from_tty):
        '''
        Split our arguments into walker definitions.
        Instantiate the walkers with these definitions.
        Join the walkers together.

        Iterate over all elements coming out the end of the pipe, printing them
        out as a hex value to screen.
        '''
        self.dont_repeat()
        # XXX allow escaped `|` chars by removing the escaped characters after
        # splitting.
        args = arg.split(' | ')
        # Create the first walker with an argument that tells it it's going to
        # be the first.
        only_one = len(args) == 1
        first_val = self.create_walker(args[0], first=True, last=only_one)
        middle = [self.create_walker(val) for val in args[1:-1] if val]
        end = None if only_one else self.create_walker(args[-1],
                                                       first=False, last=True)

        pipeline_end = self.connect_pipe(first_val, middle, end)

        # element should be an integer
        if pipeline_end is None:
            return

        for element in pipeline_end:
            print(hex(element))

    def complete(self, _, word):
        return [key for key in gdb.walkers if key.startswith(word)]


class Walker(gdb.Command):
    '''Prefix command for walker introspection commands.

    There are two subcommands under `walker`.
        walker help -- ask for help on specific walkers
        walker apropos -- list walkers whose documentation matches a string.

    '''
    def __init__(self):
        # It doesn't say anywhere, but -1 appears to be the constant to give
        # so that I can provide the PREFIX argument while still using the
        # complete() function to provide manual completion.
        super(Walker, self).__init__('walker', gdb.COMMAND_USER, -1, True)

    def invoke(self, *_):
        pass

    def complete(self, text, word):
        num_words = len(gdb.string_to_argv(text))
        if num_words > 1:
            return []
        return [val for val in ['help', 'apropos'] if val.startswith(word)]

class WalkerHelp(gdb.Command):
    '''Get help on a walker

    This command has a few different forms.
        walker help [walker]
            Prints the full help string for a walker to the screen.
        walker help walkers
            Prints all walkers have been given to the screen.
        walker help tags
            Prints all walker tags to the screen.
        walker help tag [tag]
            Prints walkers registered with the given tag and their one-line
            summary to the screen.

    '''
    def __init__(self):
        super(WalkerHelp, self).__init__('walker help', gdb.COMMAND_SUPPORT)
        self.options_dict = {
            'walkers':  self.all_walkers,
            'tags':     self.all_tags,
            'tag':      self.one_tag,
        }

    def all_walkers(self, _):
        for name, walker in gdb.walkers.items():
            print(name, '--', walker.__doc__.split('\n', 1)[0])

    def all_tags(self, _):
        # NOTE I know this is extremely wasteful, but the likelyhood we're
        # going to have a huge number of walkers is small.
        all_tags = set()
        for walker in gdb.walkers.values():
            all_tags.update(set(walker.tags))
        for tag in sorted(list(all_tags)):
            print(tag)

    def one_tag(self, tagname):
        for name, walker in gdb.walkers.items():
            if tagname in walker.tags:
                print(name, '--', walker.__doc__.split('\n', 1)[0])

    def one_walker(self, name):
        walker = gdb.walkers.get(name)
        if not walker:
            raise gdb.GdbError('No walker {} found'.format(name))
        print(walker.__doc__)

    def invoke(self, args, _):
        argv = gdb.string_to_argv(args)
        num_args = len(argv)
        if num_args != 1 and not (num_args == 2 and argv[0] == 'tag'):
            print(self.__doc__)
            raise gdb.GdbError('Invalid arguments to `walker help`')

        if num_args == 2:
            subcommand = argv[0]
            argument = argv[1]
        else:
            subcommand = argument = argv[0]

        action = self.options_dict.get(subcommand, self.one_walker)
        action(argument)

    def complete(self, text, word):
        # It's strange, but it appears that this function is called twice when
        # asking for all completions.
        # The two print statements below demonstrate this nicely.
        # I guess it doesn't matter.
        # print('Text: ', text, len(text))
        # print('Word: ', word, len(word))
        num_words = len(gdb.string_to_argv(text))
        if num_words > 1 or num_words == 1 and not word:
            if num_words > 2:
                return []
            if num_words == 2 and not word:
                return []
            # Completion is a tag -- find all tags and return those matching
            # the start of this word.
            matching_tags = set()
            for walker in gdb.walkers.values():
                matching_tags.update({val for val in walker.tags
                                      if val.startswith(word)})
            return matching_tags

        matching_walkers = [val for val in gdb.walkers if val.startswith(word)]
        matching_walkers.extend(val for val in ['tag', 'tags', 'walkers']
                                if val.startswith(word))
        return matching_walkers

class WalkerApropos(gdb.Command):
    '''Search for walkers matching REGEXP

    walker apropos prints walkers matching REGEXP and their short description.
    It matches REGEXP on walker names, walker tags, and walker documentation.
    We use python regular expressions.

    Usage:
        walker apropos REGEXP

    '''
    def __init__(self):
        super(WalkerApropos, self).__init__('walker apropos', gdb.COMMAND_SUPPORT)

    def invoke(self, args, _):
        for name, walker in gdb.walkers.items():
            strings = walker.tags + [name, walker.__doc__]
            if any(re.search(args, val, re.IGNORECASE) for val in strings):
                print(name, '--', walker.__doc__.split('\n', 1)[0])


# TODO
#    Error messages are stored in the class.
#       (so that self.parse_args() gives useful error messages)
#
#    I should be able to get the current 'Architecture' type from the file
#    without having to have started the program.
#       This would mean InstructionWalker could be called without starting the
#       inferior process.
#
#    Rename everything to match the functional paradigm? The question is really
#    what names would be most helpful for me (or anyone else) when searching
#    for a walker that matches my needs?
#       eval => map
#       if   => filter
#       I could have double names for some -- I would just need to change
#       register_walker so that it checks for 'name' and 'functional_name'
#       items in the class.

def register_walker(walker_class):
    if gdb.walkers.setdefault(walker_class.name, walker_class) != walker_class:
        raise GdbWalkerExistsError('A walker with the name "{}" already '
                                   'exits!'.format(walker_class.name))


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
    require_input = False
    require_output = False
    tags = []

    def __init__(self, args, first, last):
        pass

    @abc.abstractmethod
    def iter_def(self, inpipe):
        pass

    @staticmethod
    def eval_int(description):
        '''
        Return the integer value of `description`

        This is to be used over `int(gdb.parse_and_eval(description))` to
        account for the given description being a symbol.

        '''
        return int(gdb.parse_and_eval(description).cast(uintptr_t))

    @classmethod
    def eval_user_expressions(cls, string):
        return_parts = []
        # TODO Make this a 'proper' parser -- for now I just hope no-one's
        # using '#' characters in their gdb expressions.
        pattern = r'\$#([^#]*)#'
        prev_end = 0
        for match in re.finditer(pattern, string):
            return_parts.append(string[prev_end:match.start()])
            return_parts.append(hex(cls.eval_int(match.group(1))))
            prev_end = match.end()

        return_parts.append(string[prev_end:])
        return ''.join(return_parts)

    @classmethod
    def parse_args(cls, args, nargs=None, split_string=None,
                   strip_whitespace=True, maxsplit=-1):
        if not args: return []
        # Replace ${} covered expressions in the string with gdb 
        args = cls.eval_user_expressions(args)

        # TODO Ignore escaped versions of split_string, then remove the escape
        # characters (i.e. backslashes) after splitting.
        retval = args.split(split_string, maxsplit)
        argc = len(retval)
        if nargs is not None and (argc < nargs[0] or argc > nargs[1]):
            raise GdbWalkerValueError('Walker "{}" takes between {} and {} '
                                      'arguments.'.format(cls.name, nargs[0],
                                                          nargs[1]))
        if strip_whitespace:
            retval = [val.strip() for val in retval]
        return retval

    @staticmethod
    def form_command(cmd_parts, element):
        addr_str = '{}'.format(hex(int(element)))
        return addr_str.join(cmd_parts)


class EvalWalker(GdbWalker):
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
        # XXX allow escaping '{}' here
        if first:
            self.command_parts = self.parse_args(args, [1, 1], '{}', False)
            self.__iter_helper = self.__iter_without_input
            return

        self.command_parts = self.parse_args(args, None, '{}', False)
        self.__iter_helper = self.__iter_with_input

    def __iter_without_input(self, _):
        yield self.eval_int(self.command_parts[0])

    def __iter_with_input(self, inpipe):
        for element in inpipe:
            yield self.eval_int(self.form_command(self.command_parts, element))

    def iter_def(self, inpipe):
        return self.__iter_helper(inpipe)


class ShowWalker(GdbWalker):
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


class InstructionWalker(GdbWalker):
    '''Next `count` instructions starting at `start-address`.

    Usage:
        instructions [start-address]; [end-address]; [count]

    See gdb info Architecture.disassemble() for the meaning of arguments.
    `end-address` may be `None` to only use `count` as a limit on the number of
    instructions.

    If we're first in the pipeline, `start-address` is required, otherwise it is
    assumed to be the address given to us in the previous pipeline.

    Example:
        instructions main; main+10
        instructions main; NULL; 100
        // A pointless reimplementation of `disassemble`
        pipe instructions main, NULL, 10 | show x/i {}

    '''
    name = 'instructions'
    tags = ['data']

    def __init__(self, args, first, _):
        cmd_parts = self.parse_args(args, [2,3] if first else [1,2], ';')
        # TODO Find a way to get the architecture without requiring the program
        # to be running.
        frame = gdb.selected_frame()
        self.arch = frame.architecture()

        if first: self.start_address = self.eval_int(cmd_parts.pop(0))
        end = cmd_parts.pop(0)
        self.end_address = None if end == 'NULL' else self.eval_int(end)
        self.count = self.eval_int(cmd_parts.pop(0)) if cmd_parts else None

    def disass(self, start_address):
        '''
        Helper function.
        '''
        # TODO find the default arguments for this function so I can remove all
        # the conditions.
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


class IfWalker(GdbWalker):
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
            if self.eval_int(command):
                yield element


class HeadWalker(GdbWalker):
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
        self.limit = self.eval_int(self.parse_args(args, [1, 1])[0])

    def iter_def(self, inpipe):
        for count, element in enumerate(inpipe):
            if count >= self.limit:
                break
            yield element


class TailWalker(GdbWalker):
    '''Limit walker to last `N` items of pipeline.

    Usage:
        tail [N]

    '''
    name = 'tail'
    require_input = True
    tags = ['general']

    def __init__(self, args, *_):
        self.limit = self.eval_int(self.parse_args(args, [1, 1])[0])

    def iter_def(self, inpipe):
        # Could have the supposedly constant memory version of having a list
        # of the number of elements required, and setting each of those values
        # in turn, wrapping around when reaching the end.
        # In practice, it turns out this doesn't actually change the running
        # time.
        all_elements = list(inpipe)
        for element in all_elements[-self.limit:]:
            yield element


class CountWalker(GdbWalker):
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


class ArrayWalker(GdbWalker):
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
            self.start_addr = self.eval_int(start_addr)
            self.__iter_helper = self.__iter_first
        else:
            typename, count = self.parse_args(args, [2, 2], ';')
            self.start_addr = None
            self.__iter_helper = self.__iter_pipe

        # TODO This is hacky, and we don't handle char[], &char that users
        # might like to use.
        if typename.find('*') != -1:
            self.element_size = uintptr_t.sizeof
        else:
            self.element_size = gdb.lookup_type(typename).sizeof

        self.count = self.eval_int(count)

    def __iter_first(self, _):
        num_left = self.count
        cur_pos = self.start_addr
        while num_left > 0:
            yield cur_pos
            num_left -= 1
            cur_pos += self.element_size

    def __iter_pipe(self, inpipe):
        for element in inpipe:
            self.start_addr = int(element)
            yield from self.__iter_first(None)

    def iter_def(self, inpipe):
        return self.__iter_helper(inpipe)


class UntilWalker(GdbWalker):
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
            if not self.eval_int(self.form_command(self.command_parts, element)):
                break
            yield element


class SinceWalker(GdbWalker):
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
            if self.eval_int(self.form_command(self.command_parts, element)):
                break
        for element in inpipe:
            yield element


class TerminatedWalker(GdbWalker):
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
            self.start = self.eval_int(start)
        else:
            test_expr, follow_expr = self.parse_args(args, [2, 2], ';')
            self.start = None
        
        # Here we split the arguments into something that will form the
        # arguments next.
        self.test_cmd = self.parse_args(test_expr, None, '{}', False)
        self.follow_cmd = self.parse_args(follow_expr, None, '{}', False)

    def follow_to_termination(self, start):
        while self.eval_int(self.form_command(self.test_cmd, start)) == 0:
            yield start
            start = self.eval_int(self.form_command(self.follow_cmd, start))

    def iter_def(self, inpipe):
        if self.start:
            assert not inpipe
            yield from self.follow_to_termination(self.start)
        else:
            for element in inpipe:
                yield from self.follow_to_termination(element)


class DevnullWalker(GdbWalker):
    '''Completely consume the previous walker, but yield nothing.

    Usage:
        pipe ... | devnull

    '''
    name = 'devnull'
    require_input = True
    tags = ['general']
    
    def iter_def(self, inpipe):
        for element in inpipe:
            pass


class ReverseWalker(GdbWalker):
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


class FunctionsWalker(GdbWalker):
    '''Walk through the call tree of all functions.

    Given a function name/address, walk over all functions this function calls,
    and all functions called by those etc up to maxdepth.

    It skips all functions defined in a file that doesn't match file-regex.
    This part is very important as it avoids searching all functions in
    used libraries.

    NOTE:
        This walker is far from perfect. It does not account for calling a
        function using the "jmp" instructions, or for calling a function
        indirectly.

        If gdb can't tell what function something is calling with the
        `disassemble` command (i.e. if the disassembly instructions aren't
        annotated with the function name) then this function will not pick it
        up.

    Usage:
        called-functions [funcname | funcaddr]; [file-regex]; [maxdepth]

    '''
    name = 'called-functions'
    tags = ['data']

    # TODO
    #   Allow default arguments?
    def __init__(self, args, first, _):
        self.cmd_parts = self.parse_args(args, [3,3] if first else [2,2], ';')
        self.maxdepth = self.eval_int(self.cmd_parts[-1])
        self.file_regex = self.cmd_parts[-2].strip()

        self.func_stack = []
        self.seen_funcs = set()
        if first: self.__add_addr(self.eval_int(self.cmd_parts[0]), 0)
        self.arch = gdb.selected_frame().architecture()

    def __add_addr(self, addr, depth):
        if addr and addr not in self.seen_funcs:
            self.seen_funcs.add(addr)
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
        while len(self.func_stack) != 0:
            func_addr, depth = self.func_stack.pop()
            if self.maxdepth >= 0 and depth >= self.maxdepth:
                break

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

            for val in self.arch.disassemble(func_block.start,
                                             func_block.end)[:-1]:
                new_addr = self.__func_addr(val)
                self.__add_addr(new_addr, depth + 1)

    def iter_def(self, inpipe):
        if not inpipe:
            yield from self.__iter_helper()
        else:
            # Deal with each given function (and all their descendants) in
            # turn.
            for element in inpipe:
                # Reset seen functions each time.
                # This means that we may very well get duplicates for each of
                # the function addresses we start with, but at least the user
                # knows what's happening (i.e. doesn't go away thinking that
                # function X never calls function Y because function A called
                # it and we didn't report the duplicate in function X).
                self.seen_funcs.clear()
                self.__add_addr(element)
                yield from self.__iter_helper()


for walker in [EvalWalker, ShowWalker, InstructionWalker, HeadWalker,
               TailWalker, IfWalker, ArrayWalker, CountWalker, TerminatedWalker,
               UntilWalker, DevnullWalker, SinceWalker, ReverseWalker,
               FunctionsWalker]:
    register_walker(walker)


Pipeline()
Walker()
WalkerHelp()
WalkerApropos()
