'''
A GdbWalker class that produces an iterator over something to be part of a
pipeline.

'''

import re
import gdb

# Define the framework for putting walkers into the gdb.walkers before loading
# walker_defs (which will do this a lot).
gdb.walkers = {}


def register_walker(walker_class):
    if gdb.walkers.setdefault(walker_class.name, walker_class) != walker_class:
        raise KeyError('A walker with the name "{}" already exits!'.format(
            walker_class.name))


gdb.register_walker = register_walker

# Keep these in their own module -- this avoids namespace clashes, and allows
# naming things Whatever instead of WhateverWalker
import walker_defs


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
            raise ValueError('Walker "{}" either requires an input or an '
                             'output and has been put somewhere where this '
                             'is not given to it.'.format(walker_name))
        # May raise ValueError if the walker doesn't like the arguments it's
        # been given.
        return walker(args if args else None, first, last)

    @staticmethod
    def connect_pipe(source, segments, drain):
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

    def invoke(self, arg, _):
        '''
        Split our arguments into walker definitions.
        Instantiate the walkers with these definitions.
        Join the walkers together.

        Iterate over all elements coming out the end of the pipe, printing them
        out as a hex value to screen.
        '''
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

    @staticmethod
    def all_walkers(_):
        for name, walker in gdb.walkers.items():
            print(name, '--', walker.__doc__.split('\n', 1)[0])

    @staticmethod
    def all_tags(_):
        # NOTE I know this is extremely wasteful, but the likelyhood we're
        # going to have a huge number of walkers is small.
        all_tags = set()
        for walker in gdb.walkers.values():
            all_tags.update(set(walker.tags))
        for tag in sorted(list(all_tags)):
            print(tag)

    @staticmethod
    def one_tag(tagname):
        for name, walker in gdb.walkers.items():
            if tagname in walker.tags:
                print(name, '--', walker.__doc__.split('\n', 1)[0])

    @staticmethod
    def one_walker(name):
        walker = gdb.walkers.get(name)
        if not walker:
            raise KeyError('No walker {} found'.format(name))
        print(walker.__doc__)

    def invoke(self, args, _):
        argv = gdb.string_to_argv(args)
        num_args = len(argv)
        if num_args != 1 and not (num_args == 2 and argv[0] == 'tag'):
            print(self.__doc__)
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
        super(WalkerApropos, self).__init__('walker apropos',
                                            gdb.COMMAND_SUPPORT)

    def invoke(self, args, _):
        for name, walker in gdb.walkers.items():
            strings = walker.tags + [name, walker.__doc__]
            if any(re.search(args, val, re.IGNORECASE) for val in strings):
                print(name, '--', walker.__doc__.split('\n', 1)[0])


Pipeline()
Walker()
WalkerHelp()
WalkerApropos()
