'''
Define the framework for creating walkers that can make a pipeline in gdb.

This module adds 4 commands `gdb-pipe` `walker` `walker help` and `walker apropos`.

It also adds the python functions walkers.register_walker() and
walkers.create_pipeline() that add a walker into the gdb walker namespace and
connect a group of walkers into an iterator respectively.

Finally, it introduces the walkers.Walker base class for defining new walkers.

'''

import abc
import gdb
import os
import re
import helpers
import inspect

# Define the framework
walkers = {}
objfile_name = None

def register_walker(walker_class):
    # Use the manually defined objfile name (defined in 'importer' in
    # basic-config.py)
    if objfile_name is not None:
        objfile_tag = os.path.basename(objfile_name)
        if objfile_tag not in walker_class.tags:
            walker_class.tags.append(objfile_tag)

    # Just ensure the protocol is followed.
    iter_func = walker_class.iter_def
    from_userstring = walker_class.from_userstring
    if (len(walker_class.__abstractmethods__) != 0
        or not isinstance(walker_class.name, str)
        or not inspect.isfunction(iter_func)
        or not inspect.getfullargspec(iter_func).args == ['self', 'inpipe']
        or not inspect.ismethod(from_userstring)
        or not inspect.getfullargspec(from_userstring).args == [
            'cls', 'args', 'first', 'last']):
        raise ValueError('Failure registering "{}"\n'
                         'All registered walkers must fully implement'
                         ' the Walker interface.\n'
                         'This consists of a `name` string attribute, a'
                         ' `from_userstring` classmethod\nthat returns an'
                         ' initialised object from the arguments "args",'
                         ' "first",\nand "last" determined by the command line the user'
                         ' typed to invoke a pipeline,\n'
                         'and an `iter_def` method that takes an'
                         ' iterator named "inpipe"'
                         ''.format(walker_class.__name__))

    if walkers.setdefault(walker_class.name, walker_class) != walker_class:
        raise KeyError('A walker with the name "{}" already exits!'.format(
            walker_class.name))


class WalkerMetaclass(abc.ABCMeta):
    '''Automatically register walkers once defined.'''
    def __init__(cls, *args, **kwargs):
        if cls.__name__ != 'Walker':
            register_walker(cls)
        return super().__init__(cls, args, kwargs)


class Walker(metaclass=WalkerMetaclass):
    '''
    Class for a walker type.

    These walkers are automatically registered to be used with the `gdb-pipe`
    command.

    Each walker class is instantiated with the arguments given to it as a
    string, and two parameters indicating whether it is first or last in a
    pipeline (it can be both).

    A walker is required to implement the method `iter_def(self, inpipe)`.
    This method is passed the previous iterator as `inpipe` (this may be None
    if the walker is first in a command line).
    It is required to return an iterator over python integers.
    These integers usually represent addresses in the program space.

    '''
    @abc.abstractproperty
    def name(self): pass
    require_input = False
    require_output = False
    tags = []

    # n.b. we can't specify the __init__() arguments here, as they can
    # reasonably be different for each walker.
    # The specified abstract interface is through the from_userstring() static
    # method.
    def __init__(self):
        pass

    @abc.abstractmethod
    def iter_def(self, inpipe):
        pass

    @abc.abstractclassmethod
    def from_userstring(cls, args, first, last):
        pass

    @staticmethod
    def calc(gdb_expr):
        try:
            return gdb.parse_and_eval(gdb_expr)
        except:
            print('Error parsing expression ', gdb_expr)
            cur = gdb.convenience_variable('cur')
            print('Current value of $cur = ', cur)
            if (cur.type.code == gdb.TYPE_CODE_PTR):
                print('Current value of *$cur = ', cur.dereference())
            print('########################################################################\n\n')
            raise

    @classmethod
    def single_iter(cls, *args, **kwargs):
        return cls(*args, **kwargs).iter_def(inpipe=[])

    @classmethod
    def parse_args(cls, args, nargs=None, split_string=None,
                   strip_whitespace=True, maxsplit=-1):
        '''General function for parsing walker arguments.

        Split based on the split string given (if None given, split on
        whitespace), then check the number of arguments are within nargs[0] and
        nargs[1].

        If strip_whitespace is given, then remove whitespace from all
        arguments.

        Return a list of strings as the arguments.

        '''
        if not args:
            if nargs[0] > 0:
                raise ValueError('Walker "{}" requires at least one argument'
                                 .format(cls.name))
            return []

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

    def format_command(self, element, args):
        '''Does args.format(element) but ensures can use {} instead of {0}.'''
        # Don't let the pipe element get removed.
        if element is None:
            element = 0
        gdb.set_convenience_variable('cur', element)
        return args

    def eval_command(self, element, args=None):
        '''Helper method

        Without `args` argument this function does
        return self.calc(self.format_command(element, self.cmd)).

        Otherwise uses `args` instead of `self.cmd`

         '''
        args = args if args else self.cmd
        return self.calc(self.format_command(element, args))

    def call_with(self, start, inpipe, helper):
        if start is not None:
            assert not inpipe
            yield from helper(start)
        else:
            for element in inpipe:
                yield from helper(element)


def create_walker(walker_def, first=False, last=False):
    '''
    Find walker called for by walker_def, initialise it with the walker_def
    arguments.

    Treat the first word in a walker definition as the walker name.
    Look up the walker registered under that name, if it exists then use
    that walker, otherwise put the first word back into the walker
    arguments and use the default walker 'eval'.

    When initialising the walker, tell it if it is the first walker and/or
    if it's the last walker.

    '''
    command_split = walker_def.strip().split(None, maxsplit=1)

    assert(1 <= len(command_split) <= 2)
    walker_name = command_split[0]
    args = command_split[1] if len(command_split) == 2 else ''

    # Default walker is to evaluate the expression
    if walker_name not in walkers:
        # TODO make suggestions (e.g. No walker "aray" .. did you mean "array"?)
        raise ValueError('Walker {} does not exist'.format(walker_name))

    walker = walkers[walker_name]
    if walker.require_input and first or walker.require_output and last:
        raise ValueError('Walker "{}" either requires an input or an '
                         'output and has been put somewhere where this '
                         'is not given to it.'.format(walker_name))
    # May raise ValueError if the walker doesn't like the arguments it's
    # been given.
    return walker.from_userstring(args if args else None, first, last)


def connect_pipe(segments):
    '''
    Each walker in the gdb-pipe is called with the iterator returned by its
    predecessor.

    Return the iterator that the last walker returns.

    '''
    walker = []
    for segment in segments:
        walker = segment.iter_def(inpipe=walker)

    return walker


def create_pipeline(arg):
    '''
    Split our arguments into walker definitions.
    Instantiate the walkers with these definitions.
    Join the walkers together.

    Return the iterator over all walkers.

    '''
    # XXX allow escaped ` | ` string (i.e. ` \| ` ).
    args = arg.split(' | ')
    # Create the first walker with an argument that tells it it's going to
    # be the first.
    only_one = len(args) == 1
    walker_list = [create_walker(args[0], first=True, last=only_one)]
    walker_list.extend([create_walker(val) for val in args[1:-1] if val])
    if not only_one:
        walker_list.append(create_walker(args[-1], first=False, last=True))

    return connect_pipe(walker_list)


class Pipeline(gdb.Command):
    '''Combine logical filters to work on many addresses in sequence.

    `gdb-pipe` command to string multiple commands together.

    Usage:
        gdb-pipe walker1 | walker2 | walker3 ...

    Use:
        (gdb) walker help walkers
    to see what walkers are available.

    Use:
        (gdb) walker help [walker]
    to show the help for that walker.
    '''

    def __init__(self):
        super(Pipeline, self).__init__('gdb-pipe', gdb.COMMAND_DATA)

    def invoke(self, arg, _):
        '''
        create the pipeline according to 'arg'.

        Iterate over all elements coming out the end of the gdb-pipe, printing them
        out as a hex value to screen.

        '''
        pipeline_end = create_pipeline(arg)

        # element should be an integer
        if pipeline_end is None:
            return

        for element in pipeline_end:
            gdb.set_convenience_variable('cur', element)
            gdb.execute('output $cur')
            gdb.execute('echo \\n')

    def complete(self, _, word):
        return [key for key in walkers if key.startswith(word)]


class WalkerCommand(gdb.Command):
    '''Prefix command for walker introspection commands.'''
    def __init__(self):
        super(WalkerCommand, self).__init__('walker', gdb.COMMAND_DATA,
                                            gdb.COMPLETE_COMMAND, True)


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

    @staticmethod
    def sorted_walkers():
        return sorted(walkers.items(), key=lambda x: x[0])

    @classmethod
    def all_walkers(cls, _):
        for name, walker in cls.sorted_walkers():
            print(name, '--', walker.__doc__.split('\n', 1)[0])

    @staticmethod
    def all_tags(_):
        # NOTE I know this is extremely wasteful, but the likelyhood we're
        # going to have a huge number of walkers is small.
        all_tags = set()
        for walker in walkers.values():
            all_tags.update(set(walker.tags))
        for tag in sorted(list(all_tags)):
            print(tag)

    @classmethod
    def one_tag(cls, tagname):
        for name, walker in cls.sorted_walkers():
            if tagname in walker.tags:
                print(name, '--', walker.__doc__.split('\n', 1)[0])

    @staticmethod
    def one_walker(name):
        walker = walkers.get(name)
        if not walker:
            raise KeyError('No walker {} found'.format(name))
        print(walker.__doc__)

    def invoke(self, args, _):
        argv = gdb.string_to_argv(args)
        num_args = len(argv)
        if num_args != 1 and not (num_args == 2 and argv[0] == 'tag'):
            print(self.__doc__)
            if num_args < 1:
                return
            raise ValueError('Invalid arguments to `walker help`')

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
            for walker in walkers.values():
                matching_tags.update({val for val in walker.tags
                                      if val.startswith(word)})
            return matching_tags

        matching_walkers = [val for val in walkers if val.startswith(word)]
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
        super(WalkerApropos, self).__init__('walker apropos',
                                            gdb.COMMAND_SUPPORT)

    def invoke(self, args, _):
        for name, walker in walkers.items():
            strings = walker.tags + [name, walker.__doc__]
            if any(re.search(args, val, re.IGNORECASE) for val in strings):
                print(name, '--', walker.__doc__.split('\n', 1)[0])


Pipeline()
WalkerCommand()
WalkerHelp()
WalkerApropos()
