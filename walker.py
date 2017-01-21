'''
A GdbWalker class that produces an iterator over something to be part of a
pipeline.

'''

import enum
import gdb
import abc
import re

gdb.walkers = {}

# This is just the first guess, 
uintptr_t = gdb.lookup_type('unsigned long')
def find_ptr_t():
    '''
    Find the equivalent of uintptr_t and store it in the global namespace.

    '''
    # We need the size of a pointer in order to do pointer arithmetic.
    #
    # Because the size of a pointer is not known until we are connected to a
    # process, and gdb can switch between processes, we need to update the
    # current uintptr_t object we have each time Pipeline is called.
    global uintptr_t
    # Note, we can't rely on every program including "stdint.h", so we have a
    # little logic to find the size of a pointer here.
    try:
        uintptr_t = gdb.lookup_type('uintptr_t')
        # TODO should make the below except clause only trigger if the error
        # was because uintptr_t could not be found.
    except gdb.error:
        pointer_size = int(gdb.parse_and_eval('sizeof(char *)'))
        int_type = gdb.lookup_type('unsigned int')
        long_type = gdb.lookup_type('unsigned long')
        if int_type.sizeof == pointer_size:
            uintptr_t = int_type
        elif long_type.sizeof == pointer_size:
            uintptr_t = long_type
        else:
            # TODO I *should* think more about this -- I have the feeling I'm
            # missing a lot of cases and that it's likely to break in many special
            # cases.
            # On the other hand, I can't see it being a problem soon, and hence
            # can't see this being a priority soon.
            raise GdbWalkerError('Failed to find size of pointer type')


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

        walker = source.make_iter(inpipe=[])
        if not segments and not drain:
            return walker

        for segment in segments:
            walker = segment.make_iter(inpipe=walker)

        walker = drain.make_iter(inpipe=walker)
        return walker

    def invoke(self, arg, from_tty):
        '''
        Split our arguments into walker definitions.
        Instantiate the walkers with these definitions.
        Join the walkers together.

        Iterate over all elements coming out the end of the pipe, printing them
        out as a hex value to screen.
        '''
        # Call the global function to register the current uintptr_t type in
        # the global namespace.
        find_ptr_t()
        # XXX allow escaped `|` chars to be used in segments.
        self.dont_repeat()
        args = arg.split('|')
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


# TODO
#    Make the helper functions in GdbWalker() classmethods.
#       It just makes more sense that people can use them without instantiating
#       anything.
#    ArrayWalker should be able to take a terminating condition.
#        at least should be able to say NULL terminate instead of providing a
#        count
#    Make general function to split strings.
#        this function should also evaluate any maths inside a $() brace.
#        i.e. parse('$(main+4 + 8) {} right', split='{}')
#        would give something like ['0x400552 ', '', ' right']
#        This would also handle not splitting on escaped characters and removing
#        the backslash that escapes them.
#    Error messages are stored in the class.
#    Help is stored in docstring
#    Tags for searching amongst walkers are stored in self.tags
#    Pass dictionaries instead of just an integer
#        Each dictionary should have a 'point' element, but can include other
#        data.
#    Maybe make_iter should wrap the iter_def() call with a function that
#    ensures every element in the iterator is a gdb.Value with type 'char_u *'
#    Set default walker (when called without a walker name) inside gdb with
#        `set ...`
#    When should the walkers get the information that they're going to be
#    first/last?
#        During instantiation or when called?
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

    @abc.abstractmethod
    def __init__(self, args, first, last):
        pass

    @abc.abstractmethod
    def iter_def(self, inpipe):
        pass

    def make_iter(self, inpipe, flags={}):
        '''
        '''
        # Shouldn't be needed -- self.iter_def() should always return an
        # iterator...
        if self.require_input and not inpipe:
            raise GdbWalkerValueError(self.name + ' requires input from a pipe')
        return self.iter_def(inpipe)

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
    '''
    Parse args as a gdb expression.

    Replaces occurances of `{}` in the argument string with the values from a
    previous walker.
    Parses the resulting gdb expression, and outputs the value to the next
    walker.

    If `{}` does not appear in the argument string, takes no input and outputs
    one value.

    Use:
        eval  <gdb expression>

    Example:
        eval  {} + 8
        eval  {} != 0 && ((struct complex_type *){})->field
        eval  $saved_var->field

    '''

    name = 'eval'

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
    '''
    Parse the expression as a gdb command, and print its output.

    This must have input, and it re-uses that input as its output.
    If this is the last command it doesn't output anything.

    Use:
        show <gdb command>

    Example:
        show print {}
        show print (char *){}
        show print ((struct complex_type *){})->field

    '''
    name = 'show'
    require_input = True

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
    '''
    Next `count` instructions starting at `start-address`.

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

    def __init__(self, args, first, _):
        cmd_parts = [val for val in
                     self.parse_args(args, [2,3] if first else [1,2], ';')]
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
    '''
    Reproduces items that satisfy a condition.

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

    def __init__(self, args, *_):
        self.command_parts = self.parse_args(args, None, '{}', False)

    def iter_def(self, inpipe):
        for element in inpipe:
            command = self.form_command(self.command_parts, element)
            if self.eval_int(command):
                yield element


class HeadWalker(GdbWalker):
    '''
    Only take first `N` items of the pipeline.

    Usage:
       head [N]

    '''
    name = 'head'
    require_input = True

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
    '''
    Limit walker to last `N` items of pipeline.

    Usage:
        tail [N]

    '''
    name = 'tail'
    require_input = True

    def __init__(self, args, *_):
        self.limit = self.eval_int(self.parse_args(args, [1, 1])[0])

    def iter_def(self, inpipe):
        all_elements = list(inpipe)
        for element in all_elements[-self.limit:]:
            yield element


class CountWalker(GdbWalker):
    '''
    Count how many elements were in the previous walker.

    Usage:
        count

    Example:
        pipe instructions main, main+100 | count

    '''
    name = 'count'
    require_input = True

    def __init__(self, args, *_):
        pass

    def iter_def(self, inpipe):
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

    def __init__(self, args, *_):
        self.command_parts = self.parse_args(args, None, '{}', False)

    def iter_def(self, inpipe):
        for element in inpipe:
            if self.eval_int(self.form_command(self.command_parts, element)):
                yield element


class SinceWalker(GdbWalker):
    '''Skip items until a condition is satisfied.

    Usage:
        pipe ... | skip-until ((struct *){})->field == $#marker#


    '''
    name = 'skip-until'
    require_input = True

    def __init__(self, args, *_):
        self.command_parts = self.parse_args(args, None, '{}', False)

    def iter_def(self, inpipe):
        for element in inpipe:
            if self.eval_int(self.form_command(self.command_parts, element)):
                break
        for element in inpipe:
            yield element


class TerminatedWalker(GdbWalker):
    '''
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
    
    def __init__(self, args, *_):
        pass

    def iter_def(self, inpipe):
        for element in inpipe:
            pass


for walker in [EvalWalker, ShowWalker, InstructionWalker, HeadWalker,
               TailWalker, IfWalker, ArrayWalker, CountWalker, TerminatedWalker,
               UntilWalker, DevnullWalker, SinceWalker]:
    register_walker(walker)


Pipeline()
