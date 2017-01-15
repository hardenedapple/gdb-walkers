'''
A GdbWalker class that produces an iterator over something to be part of a
pipeline.

'''
import gdb
import abc
import enum

gdb.walkers = {}


class GdbWalkerError(gdb.GdbError):
    pass

class GdbWalkerExistsError(GdbWalkerError):
    pass

class GdbWalkerValueError(GdbWalkerError):
    pass


class Pipeline(gdb.Command):
    '''
    `pipe` command to string multiple commands together.
    '''
    def __init__(self):
        super(Pipeline, self).__init__('pipe', gdb.COMMAND_USER)
        # Make this a parameter set inside gdb
        self.default = 'address'

    def create_walker(self, walker_def, first=False, last=False):
        command_split = walker_def.strip().split(None, maxsplit=1)
        walker_name = command_split[0]
        args = command_split[1] if len(command_split) == 2 else ''

        # Default walker is to get the address
        if walker_name not in gdb.walkers:
            args = walker_name + ' ' + args
            walker_name = self.default

        walker = gdb.walkers[walker_name]
        if walker.require_input and first or walker.require_output and last:
            raise GdbWalkerValueError('Walker "{}" either requires an input or '
                                      'an output and has been put somewhere '
                                      'where this is not given to it.'.format(
                                          walker_name))
        if walker.require_args and not args:
            raise GdbWalkerValueError('Walker "{}" requires arguments.'.format(
                walker_name))

        # May raise GdbWalkerValueError if the walker doesn't like the arguments
        # it's been given.
        return walker(args, first, last)

    def connect_pipe(self, source, segments, drain):
        walker = source.make_iter(inpipe=[])
        if not segments and not drain:
            return walker
        for segment in segments:
            walker = segment.make_iter(inpipe=walker)
        if drain:
            walker = drain.make_iter(inpipe=walker)

        return walker

    def invoke(self, arg, from_tty):
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

        # element should be an gdb.Value of type address
        for element in pipeline_end:
            print(hex(element))


# TODO
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
#    Pass dictionaries instead of just an address
#        Each dictionary should have an 'address' element, but can include other
#        data.
#    Maybe make_iter should wrap the iter_def() call with a function that
#    ensures every element in the iterator is a gdb.Value with type 'char_u *'
#    Set default walker (when called without a walker name) inside gdb with
#        `set ...`
#    When should the walkers get the information that they're going to be
#    first/last?
#        During instantiation or when called?
#


def register_walker(walker_class):
    if gdb.walkers.setdefault(walker_class.name, walker_class) != walker_class:
        raise GdbWalkerExistsError('A walker with the name "{}" already '
                                   'exits!'.format(walker_class.name))


class GdbWalker(abc.ABC):
    '''
    '''
    require_input = False
    require_output = False
    require_args = True

    @abc.abstractmethod
    def __init__(self, args, flags):
        pass

    @abc.abstractmethod
    def iter_def(self, inpipe):
        pass

    def make_iter(self, inpipe, flags={}):
        '''
        '''
        if self.require_input and not inpipe:
            raise GdbWalkerValueError(self.name + ' requires input from a pipe')
        return self.iter_def(inpipe)

    # In the future this will remove escaped backslashes and evaluate everything
    # inside a $() brace. For now it just splits the string
    def parse_args(self, args, nargs=None, split_string=None,
                   strip_whitespace=True, maxsplit=-1):
        retval = args.split(split_string, maxsplit)
        argc = len(retval)
        if nargs is not None and (argc < nargs[0] or argc > nargs[1]):
            raise GdbWalkerValueError('Walker "{}" takes between {} and {} '
                                      'arguments.'.format(self.name, nargs[0],
                                                          nargs[1]))
        if strip_whitespace:
            retval = [val.strip() for val in retval]
        return retval

    def parse_command_template(self, args):
        cmd_parts = self.parse_args(args, None, '{}', False)
        if len(cmd_parts) == 1:
            cmd_parts[0] += ' '
            cmd_parts.append('')
        return cmd_parts

    def form_command(self, cmd_parts, element):
        addr_str = '{}'.format(hex(int(element)))
        return addr_str.join(cmd_parts)


class EvalWalker(GdbWalker):
    '''
    Parse args as a gdb expression.

    Replaces occurances of `{}` in the argument string with the addresses from a
    previous walker.
    Parses the resulting gdb expression, and outputs the value to the next
    walker.

    If `{}` does not appear in the argument string, takes no input and outputs
    one value.

    '''

    name = 'address'

    def __init__(self, args, first, last):
        # XXX allow escaping '{}' here
        if first:
            self.command_parts = self.parse_args(args, None, '{}', False)
            if len(self.command_parts) != 1:
                raise GdbWalkerValueError("Can't have input position in "
                                          "address walker when it's the "
                                          "first walker")

            self.__iter_helper = self.__iter_without_input
            return

        self.command_parts = self.parse_command_template(args)
        self.__iter_helper = self.__iter_with_input

    def __iter_without_input(self, _):
        yield int(gdb.parse_and_eval(self.command_parts[0]))

    def __iter_with_input(self, inpipe):
        for element in inpipe:
            yield int(gdb.parse_and_eval(
                self.form_command(self.command_parts, element)))

    def iter_def(self, inpipe):
        return self.__iter_helper(inpipe)

class PrintWalker(GdbWalker):
    '''
    Parse the expression as a gdb command, and print its output.

    This must have input, and it re-uses that input as its output.
    If this is the last command it doesn't output anything.

    '''
    name = 'print'
    require_input = True

    def __init__(self, args, _, last):
        self.is_last = last
        self.command_parts = self.parse_command_template(args)

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
        instructions [start-address], [end-address], [count]

    See gdb info Architecture.disassemble() for the meaning of arguments.
    `end-address` may be `None` to only use `count` as a limit on the number of
    instructions.

    If we're first in the pipeline, `start-address` is required, otherwise it is
    assumed to be the address given to us in the previous pipeline.

    '''
    name = 'instructions'

    def __init__(self, args, first, _):
        cmd_parts = [gdb.parse_and_eval(val) if val != 'NULL' else 'NULL'
                     for val in
                     self.parse_args(args, [2,3] if first else [1,2], ',')]
        # TODO Find a way to get the architecture without requiring the program
        # to be running.
        frame = gdb.selected_frame()
        self.arch = frame.architecture()

        if first: self.start_address = int(cmd_parts.pop(0))
        end = cmd_parts.pop(0)
        self.end_address = None if end == 'NULL' else int(end)
        self.count = int(cmd_parts.pop(0)) if cmd_parts else None

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

    '''
    name = 'if'
    require_input = True

    def __init__(self, args, *_):
        self.command_parts = self.parse_command_template(args)

    def iter_def(self, inpipe):
        for element in inpipe:
            command = self.form_command(self.command_parts, element)
            if int(gdb.parse_and_eval(command)):
                yield element


class HeadWalker(GdbWalker):
    '''
    Only take first `N` items of the pipeline.

    Usage;
       head [N]

    '''
    name = 'head'
    require_input = True

    def __init__(self, args, *_):
        self.limit = int(self.parse_args(args, [1, 1])[0])

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
        self.limit = int(self.parse_args(args, [1, 1])[0])

    def iter_def(self, inpipe):
        all_elements = list(inpipe)
        for element in all_elements[-self.limit:]:
            yield element


class ArrayWalker(GdbWalker):
    '''
    Iterate over each element in an array.

    Usage:
        If this is the first walker:
            array type start_address count

        Otherwise:
            array type count

    '''
    name = 'array'

    def __init__(self, args, first, _):
        if first:
            typename, start_addr, count = self.parse_args(args, [3, 3])
            self.start_addr = int(start_addr)
            self.__iter_helper = self.__iter_first
        else:
            typename, count = self.parse_args(args, [2, 2])
            self.start_addr = None
            self.__iter_helper = self.__iter_pipe

        if typename.find('*') != -1:
            # TODO This is hacky, and we don't handle char[], &char that users
            # might like to use.
            self.element_size = gdb.lookup_type('char').pointer().sizeof
        else:
            self.element_size = gdb.lookup_type(typename).sizeof

        self.count = int(count)

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

# class NextWalker(GdbWalker):
#     '''
#     Uses given expression to find 'next' address.

#     Follows these 'next' expressions until we get a NULL value.

#     '''

# class WalkerFilter(GdbWalker):
#     def __init__(self):
#         super(GdbWalker, self).__init__('if', {
#             require_input=True,
#             require_output=False,
#             num_args='*'
#         })

#     def setup(self, args):


#     def __iter__(self,
#         retval = gdb.parse_and_eval(args)

for walker in [EvalWalker, PrintWalker, InstructionWalker, HeadWalker,
               TailWalker, IfWalker, ArrayWalker]:
    register_walker(walker)

Pipeline()
