'''Contains the definitions for general walkers

This module defines all the general walkers that can be applicable anywhere.
When making your own walkers, define them anywhere.
If inheriting from the walkers.Walker class, then walkers are automatically
registered, otherwise you must register them manually with
walkers.register_walker().

'''
import re
import operator
import gdb
from helpers import (eval_uint, function_disassembly, as_uintptr, uintptr_size,
                     file_func_split, search_symbols, find_type_size)
import walkers
import itertools as itt

# TODO
#   I would like to use the python standard argparse library to parse
#   arguments, but when it fails it exits instead of raising an error.
#       This means that any error in the command line by the user exits the gdb
#       process, which can't be the case.
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


class Eval(walkers.Walker):
    '''Parse args as a gdb expression.

    Replaces occurances of `{}` in the argument string with the values from a
    previous walker.
    Evaluates the resulting gdb expression, and outputs the value to the next
    walker.

    If `{}` does not appear in the argument string, takes no input and outputs
    one value.

    This is essentially a map command -- it modifies the stream of addresses in
    place.

    Use:
        pipe eval  <gdb expression>

    Example:
        pipe eval  {} + 8
        pipe eval  {} != 0 && ((struct complex_type *){})->field
        pipe eval  $saved_var->field

    '''

    name = 'eval'
    tags = ['general', 'interface']

    def __init__(self, cmd, first):
        self.cmd = cmd
        self.first = first

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(args, first)

    def iter_def(self, inpipe):
        if self.first:
            yield self.calc(self.cmd)
        else:
            yield from (self.eval_command(ele) for ele in inpipe)


class Show(walkers.Walker):
    '''Parse the expression as a gdb command, and print its output.

    This must have input, and it re-uses that input as its output.
    If this is the last command it doesn't yield anything.

    Use:
        show <gdb command>

    Example:
        show output {}
        show output (char *){}
        show output ((struct complex_type *){.v})->field
        show output {}->field

    '''
    name = 'show'
    require_input = True
    tags = ['general', 'interface']

    def __init__(self, args, last):
        self.is_last = last
        self.command = args

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(args, last)

    def iter_def(self, inpipe):
        for element in inpipe:
            command = self.format_command(element, self.command)
            gdb.execute(command, False)
            if not self.is_last:
                yield element


class Instruction(walkers.Walker):
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

    def __init__(self, start_ele, end_addr, count):
        self.arch = gdb.current_arch()
        self.start_ele = start_ele
        self.end_addr = end_addr
        self.count = count

    @classmethod
    def from_userstring(cls, args, first, last):
        cmd_parts = cls.parse_args(args, [2, 3] if first else [1, 2], ';')

        start_ele = cls.calc(cmd_parts.pop(0)) if first else None
        end = cmd_parts.pop(0)
        end_addr = None if end == 'NULL' else eval_uint(end)
        count = eval_uint(cmd_parts.pop(0)) if cmd_parts else None

        return cls(start_ele, end_addr, count)

    def disass(self, start_ele):
        '''
        Helper function.
        '''
        # TODO arch.disassemble default args.
        start_addr = start_ele.v
        if self.end_addr and self.count:
            return self.arch.disassemble(start_addr,
                                         self.end_addr,
                                         self.count)
        elif self.count:
            return self.arch.disassemble(start_addr, count=self.count)
        elif self.end_addr:
            return self.arch.disassemble(start_addr, self.end_addr)

        return self.arch.disassemble(start_addr)

    def iter_helper(self, start_ele):
        for instruction in self.disass(start_ele):
            yield self.Ele('void *', instruction['addr'])

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_ele, inpipe, self.iter_helper)


class If(walkers.Walker):
    '''Reproduces items that satisfy a condition.

    Replaces occurances of `{}` with the input address.

    Usage:
        if <condition>

    Example:
        if $_streq("Hello", (char_u *){})
        if ((complex_type *){}).field == 10
        if $count++ < 10

    '''
    name = 'if'
    require_input = True
    tags = ['general']

    def __init__(self, cmd):
        self.cmd = cmd

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(args)

    def iter_def(self, inpipe):
        for element in inpipe:
            if self.eval_command(element).v:
                yield element


class IfNth(walkers.Walker):
    '''Provides items where the Nth previous one satisfies a condition.

    Replaces occurances of `{}` with the input address.

    Usage:
        if-nth <condition>; <offset>

    Example:
        if-nth $_streq("Hello", (char_u *){}); 1
        if-nth ((sometype *){}).field == 10; -1

    '''
    name = 'if-nth'
    require_input = True
    tags = ['general']

    def __init__(self, cmd, offset):
        self.cmd = cmd
        self.offset = offset

    @classmethod
    def from_userstring(cls, args, first, last):
        cmd_parts = cls.parse_args(args, [2, 2], ';')
        return cls(cmd_parts[0], int(cmd_parts[1]))

    def positive_offset_ifn(self, inpipe):
        to_yield = []
        for count, element in enumerate(inpipe):
            if self.eval_command(element).v:
                to_yield.append(count + self.offset)
            if to_yield:
                if to_yield[0] == count:
                    yield element
                # Should never be to_yield[0] < count, but may as well handle
                # that case anyway.
                if to_yield[0] <= count:
                    to_yield.pop()

    def negative_offset_ifn(self, inpipe):
        previous = []
        cur_yield = None
        for element in inpipe:
            if len(previous) == -self.offset:
                cur_yield = previous.pop()
            assert len(previous) < -self.offset, "Should be an invariant of this loop"
            previous.append(element)
            if self.eval_command(element).v and cur_yield:
                yield cur_yield

    def iter_def(self, inpipe):
        if self.offset >= 0:
            yield from self.positive_offset_ifn(inpipe)
        else:
            yield from self.negative_offset_ifn(inpipe)


class Head(walkers.Walker):
    '''Only take first `N` items of the pipeline.

    Can use `head -N` to take all but the last N elements.

    Usage:
       head <N>

    '''
    name = 'head'
    require_input = True
    tags = ['general']

    def __init__(self, limit):
        self.limit = limit

    @classmethod
    def from_userstring(cls, args, first, last):
        # Don't use eval_uint as that means we can't use `-1`
        # eval_uint() is really there to eval anything that could be a pointer.
        return cls(int(gdb.parse_and_eval(args)))

    def iter_def(self, inpipe):
        if self.limit < 0:
            all_elements = list(inpipe)
            yield from all_elements[:self.limit]
        elif self.limit == 0:
            return
        else:
            for count, element in enumerate(inpipe):
                yield element
                if count + 1 >= self.limit:
                    break


class Tail(walkers.Walker):
    '''Limit walker to last `N` items of pipeline.

    Can use `tail -N` to pass all but the N first elements.

    Usage:
        tail <N>

    '''
    name = 'tail'
    require_input = True
    tags = ['general']

    def __init__(self, limit):
        self.limit = limit

    @classmethod
    def from_userstring(cls, args, first, last):
        # Don't use eval_uint as that means we can't use `-1`
        # eval_uint() is really there to eval anything that could be a pointer.
        return cls(int(gdb.parse_and_eval(args)))

    def iter_def(self, inpipe):
        if self.limit < 0:
            limit = abs(self.limit)
            # Consume the needed number of elements from our input
            for count, _ in enumerate(inpipe):
                if count + 1 >= limit:
                    break
            yield from inpipe
        elif self.limit > 0:
            # Could have the constant memory version of having a list of the
            # number of elements required, and setting each of those values in
            # turn, wrapping around when reaching the end.
            # In practice, this is a pain and doesn't change the running time.
            # I could look into whether the list is implemented as an array
            # etc, but it doesn't seem worth the trouble at the moment.
            all_elements = list(inpipe)
            yield from all_elements[-self.limit:]
        else:
            return


class Count(walkers.Walker):
    '''Count how many elements were in the previous walker.

    Usage:
        count

    Example:
        pipe instructions main; main+100 | count

    '''
    name = 'count'
    require_input = True
    tags = ['general']

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls()

    def iter_def(self, inpipe):
        i = None
        for i, _ in enumerate(inpipe):
            pass
        yield self.Ele('int', i + 1 if i is not None else 0)


class Array(walkers.Walker):
    '''Iterate over a pointer to each element in an array.

    Note that the types can sometimes be confusing here, walking over an array
    of `char *` means the walker produdces a stream of `char **` pointers.
    Similarly, walking over an array of `int` means the walker produces a
    stream of `int *` pointers.

    Usage:
        array type; start_address; count

        start_address and count are arbitrary expressions, if this walker is
        not the first walker in the pipeline then {} is replaced by the
        incoming element.

    Example:
        array char *; argv; argc

    '''
    name = 'array'
    tags = ['data']

    def __init__(self, first, start, count, typename, element_size):
        self.first = first
        self.typename = typename + '*' if typename else None
        self.element_size = element_size
        if first:
            self.start_addr = start
            self.count = count
        else:
            self.start_expr = start
            self.count_expr = count

    @classmethod
    def from_userstring(cls, args, first, last):
        type_arg, start_expr, count_expr = cls.parse_args(args, [3, 3], ';')

        def __first(count_expr, start_expr):
            return eval_uint(count_expr), cls.calc(start_expr)

        def __noauto(type_arg):
            element_size = find_type_size(type_arg)
            typename = type_arg
            return typename, element_size

        def __first_auto(start_expr, count_expr, _):
            count, start_ele = __first(count_expr, start_expr)
            start_addr, typename = start_ele.v, start_ele.t
            typename = typename.rstrip()
            typename = typename[:-1] if typename[-1] == '*' else typename
            return (start_addr, count, typename,
                    gdb.parse_and_eval(start_expr).type.target().sizeof)

        def __nofirst_auto(start_expr, count_expr, _):
            return (start_expr, count_expr, None, None)

        def __first_noauto(start_expr, count_expr, type_arg):
            count, start_ele = __first(count_expr, start_expr)
            start_addr = start_ele.v
            typename, element_size = __noauto(type_arg)
            return (start_addr, count, typename, element_size)

        def __nofirst_noauto(start_expr, count_expr, type_arg):
            typename, element_size = __noauto(type_arg)
            return (start_expr, count_expr, typename, element_size)

        options_dict = {
            (True, True): __first_auto,
            (False, True): __nofirst_auto,
            (True, False): __first_noauto,
            (False, False): __nofirst_noauto,
        }

        return cls(first,
                   *options_dict[first, type_arg == 'auto'](
                   start_expr, count_expr, type_arg))

    def __iter_single(self, start_addr, count, typename, element_size):
        pos = start_addr
        for _ in range(count):
            yield self.Ele(typename, pos)
            pos += element_size

    def __iter_known(self, element):
        start_addr = eval_uint(self.format_command(element, self.start_expr))
        count = eval_uint(self.format_command(element, self.count_expr))
        yield from self.__iter_single(start_addr, count,
                                      self.typename,
                                      self.element_size)

    def __iter_unknown(self, element):
        count = eval_uint(self.format_command(element, self.count_expr))
        start_ele = self.eval_command(element, self.start_expr)
        # Like in __init__() seems simpler to evaluate twice than go for
        # performance.
        element_size = gdb.parse_and_eval(
            self.format_command(element, self.start_expr)
        ).type.target().sizeof
        yield from self.__iter_single(start_ele.v, count, start_ele.t, element_size)

    def iter_def(self, inpipe):
        if self.first:
            yield from self.__iter_single(
                self.start_addr, self.count, self.typename, self.element_size)
        else:
            for iterobj in map(
                    self.__iter_known if self.typename else self.__iter_unknown,
                    inpipe):
                yield from iterobj


# Probably should do something about the code duplication between Max and Min
# here, but right now it seems much more effort than it's worth.
class Max(walkers.Walker):
    '''Pass through the value that results in the maximum expression.

    For each element, it evaluates the expression given, and returns the
    element for which this expression gives the maximum value.

    If more than one element give the same maximum value, then the first is
    returned.

    Use:
        pipe ... | max {}

    Example:
        // Find argument that starts with the last letter in the alphabet.
        pipe follow-until argv; *(char **){} == 0; ((char **){}) + 1 | \
            max (*(char *){})[0]

    '''
    name = 'max'
    require_input = True
    tags = ['general']

    def __init__(self, cmd):
        self.cmd = cmd

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(args)

    def iter_def(self, inpipe):
        try:
            _, retelement = max(
                ((self.eval_command(element).v, element) for element in inpipe),
                key=operator.itemgetter(0)
            )
            yield retelement
        except ValueError as e:
            if e.args != ('max() arg is an empty sequence',):
                raise


class Min(walkers.Walker):
    '''Pass through the value that results in the minimum expression.

    For each element, it evaluates the expression given, and returns the
    element for which this expression gives the minimum value.

    If more than one element give the same minimum value, then the first is
    returned.

    Use:
        pipe ... | min {}

    Example:
        // Find argument that starts with the last letter in the alphabet.
        pipe follow-until argv; *(char **){} == 0; ((char **){}) + 1 | \
            min (*(char *){})[0]

    '''
    name = 'min'
    require_input = True
    tags = ['general']

    def __init__(self, cmd):
        self.cmd = cmd

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(args)

    def iter_def(self, inpipe):
        try:
            _, retelement = min(
                ((self.eval_command(element).v, element) for element in inpipe),
                key=operator.itemgetter(0)
            )
            yield retelement
        except ValueError as e:
            if e.args != ('min() arg is an empty sequence',):
                raise


class Sort(walkers.Walker):
    '''Yield elements from the previous walker sorted on expression given.

    For each element, it evaluates the expression given. It then yields the
    elements in their sorted order.

    Reverse sorting is not supported: negate the expression as a workaround.

    Use:
        pipe ... | sort {}

    Example:
        // Sort arguments alphabetically
        pipe follow-until argv; *(char **){} == 0; ((char **){}) + 1 | \
            sort (*(char **){})[0]

    '''
    name = 'sort'
    require_input = True
    tags = ['general']

    def __init__(self, cmd):
        self.cmd = cmd

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(args)

    def iter_def(self, inpipe):
        retlist = sorted(
            ((self.eval_command(element).v, element) for element in inpipe),
            key=operator.itemgetter(0)
        )
        for _, element in retlist:
            yield element


class Dedup(walkers.Walker):
    '''Remove duplicate elements.

    For each element, evaluates the expression given and removes those that
    repeat the same value as the one previous.

    Use:
        pipe ... | dedup {}

    '''
    name = 'dedup'
    require_input = True
    tags = ['general']

    def __init__(self, cmd):
        self.cmd = cmd

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(args)

    def iter_def(self, inpipe):
        prev_value = None
        for element, value in ((ele, self.eval_command(ele).v) for ele in inpipe):
            if value == prev_value:
                continue
            prev_value = value
            yield element


class Until(walkers.Walker):
    '''Accept and pass through elements until a condition is broken.

    Can't be the first walker.

    Usage:
        pipe ... | take-while ((struct *){})->field != marker

    '''
    name = 'take-while'
    require_input = True
    tags = ['general']

    def __init__(self, cmd):
        self.cmd = cmd

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(args)

    def iter_def(self, inpipe):
        for element in inpipe:
            if not self.eval_command(element).v:
                break
            yield element


class Since(walkers.Walker):
    '''Skip items until a condition is satisfied.

    Returns all items in a walker since a condition was satisfied.

    Usage:
        pipe ... | skip-until ((struct *){})->field == $#marker#

    '''
    name = 'skip-until'
    require_input = True
    tags = ['general']

    def __init__(self, cmd):
        self.cmd = cmd

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(args)

    def iter_def(self, inpipe):
        for element in inpipe:
            if self.eval_command(element).v:
                yield element
                break
        yield from inpipe


class Terminated(walkers.Walker):
    '''Follow "next" expression until reach terminating condition.

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

    def __init__(self, start_ele, test_expr, follow_expr):
        self.start_ele = start_ele
        self.test_expr = test_expr
        self.follow_expr = follow_expr

    @classmethod
    def from_userstring(cls, args, first, last):
        if first:
            start_expr, test_expr, follow_expr = cls.parse_args(args, [3, 3], ';')
            start_ele = cls.calc(start_expr)
        else:
            test_expr, follow_expr = cls.parse_args(args, [2, 2], ';')
            start_ele = None
        return cls(start_ele, test_expr, follow_expr)

    def follow_to_termination(self, start_ele):
        while eval_uint(self.format_command(start_ele, self.test_expr)) == 0:
            yield start_ele
            start_ele = self.eval_command(start_ele, self.follow_expr)

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_ele, inpipe, self.follow_to_termination)


class LinkedList(walkers.Walker):
    '''Convenience walker for a NULL terminated linked list.

    The following walker
        linked-list list_head; list_T; list_next
    is the equivalent of
        follow-until list_head; {} == 0; ((list_T *){})->list_next

    Usage:
        linked-list <list start>; <list type>; <next member>
        linked-list <list type>; <next member>

    '''
    name = 'linked-list'
    tags = ['data']

    def __init__(self, start_ele, list_type, next_member):
        self.start_ele = start_ele
        self.list_type = list_type + '*'
        self.next_member = next_member

    @classmethod
    def from_userstring(cls, args, first, last):
        if first:
            start_expr, list_type, next_member = cls.parse_args(args, [3, 3], ';')
            start_ele = cls.calc(start_expr)
        else:
            list_type, next_member = cls.parse_args(args, [2, 2], ';')
            start_ele = None
        return cls(start_ele, list_type, next_member)

    def __iter_helper(self, element):
        yield from Terminated.single_iter(
            start_ele=self.Ele(self.list_type, element.v),
            test_expr='{} == 0',
            follow_expr='{{}}->{}'.format(self.next_member))

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_ele, inpipe, self.__iter_helper)


class Devnull(walkers.Walker):
    '''Completely consume the previous walker, but yield nothing.

    Usage:
        pipe ... | devnull

    '''
    name = 'devnull'
    require_input = True
    tags = ['general']

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls()

    def iter_def(self, inpipe):
        for _ in inpipe:
            pass


class Reverse(walkers.Walker):
    '''Reverse the iteration from the previous command.

    Usage:
        pipe ... | reverse

    Examples:
        pipe array char; 1; 10 | reverse

    '''
    name = 'reverse'
    require_input = True
    tags = ['general']

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls()

    def iter_def(self, inpipe):
        all_elements = list(inpipe)
        all_elements.reverse()
        for element in all_elements:
            yield element


class CalledFunctions(walkers.Walker):
    '''Walk through the call tree of all functions.

    Given a function name/address, walk over all functions this function calls,
    and all functions called by those etc up to maxdepth.

    It skips all functions defined in a file that doesn't match file-regexp.
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
        ... | called-functions <file-regexp>; <maxdepth>; [unique]
        called-functions <funcname | funcaddr>; <file-regexp>; <maxdepth>; [unique]

    '''
    name = 'called-functions'
    tags = ['data']

    # NOTE -- putting this in the class namespace is a hack so the
    # hypothetical-call-stack walker can find it.
    hypothetical_stack = []

    def __init__(self, maxdepth, file_regexp, start_expr, unique_funcs):
        self.func_stack = []
        self.arch = gdb.current_arch()
        self.maxdepth = maxdepth
        self.file_regexp = file_regexp
        # User asked for specific files, we only know the filename if there is
        # debugging information, hence ignore all functions that don't have
        # debugging info.
        self.dont_fallback = re.match(self.file_regexp, '') is not None
        self.unique_funcs = unique_funcs
        self.all_seen = set()

        # hypothetical_stack checks for recursion, but also allows the
        # hypothetical-call-stack walker to see what the current stack is.
        type(self).hypothetical_stack = []
        if start_expr:
            self.__add_addr(eval_uint(start_expr), 0)

    # TODO
    #   Allow default arguments?
    @classmethod
    def from_userstring(cls, args, first, last):
        cmd_parts = cls.parse_args(args, [3,4] if first else [2,3], ';')
        if cmd_parts[-1] == 'unique':
            cmd_parts.pop()
            unique = True
        else:
            unique = False
        return cls(eval_uint(cmd_parts[-1]),
                   cmd_parts[-2].strip(),
                   cmd_parts[0] if first else None,
                   unique)

    def __add_addr(self, addr, depth):
        if not addr:
            return
        if addr in self.all_seen:
            return
        if self.unique_funcs:
            if addr in self.all_seen:
                return
            self.all_seen.add(addr)
        # Use reverse stack because recursion is more likely a short-term
        # thing (have not checked whether this speeds anything up).
        if addr not in self.hypothetical_stack[::-1]:
            self.func_stack.append((addr, depth))

    @staticmethod
    def __func_addr(instruction):
        elements = instruction['asm'].split()
        # Make sure the format for this instruction is
        # call... addr <func_name>
        # Ignore those functions with '@' in them (to avoid @plt functions).
        #   Note this wouldn't actually matter much because the plt stubs don't
        #   have any `call` instructions in them. It just saves a little on
        #   time.
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

            # If func_dis is None no debugging info was found for this function
            # and the user required filtering by filename (which we don't know
            # without debugging info) -- hence ignore this.
            func_dis, _, fname = function_disassembly(func_addr, self.arch,
                                                      self.dont_fallback)
            if not func_dis or not re.match(self.file_regexp,
                                            '' if not fname else fname):
                continue

            # Store the current value in the hypothetical_stack for someone
            # else to query - remember to set the class attribute.
            type(self).hypothetical_stack[depth:] = [func_addr]
            yield self.Ele('void *', func_addr)

            # Go backwards through the list so that we pop off elements in the
            # order they will be called.
            for val in func_dis[::-1]:
                new_addr = self.__func_addr(val)
                self.__add_addr(new_addr, depth + 1)

    def iter_def(self, inpipe):
        if not inpipe:
            yield from self.__iter_helper()
            return

        # Deal with each given function (and all their descendants) in turn.
        for _, element in inpipe:
            type(self).hypothetical_stack = []
            self.__add_addr(element, 0)
            yield from self.__iter_helper()


class HypotheticalStack(walkers.Walker):
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

    def __init__(self):
        self.called_funcs_class = walkers.walkers['called-functions']

    @classmethod
    def from_userstring(cls, args, first, last):
        if args and args.split() != []:
            raise ValueError('hypothetical-call-stack takes no arguments')
        return cls()

    def iter_def(self, inpipe):
        if not inpipe:
            yield from (self.Ele('void *', ele) for ele in
                        self.called_funcs_class.hypothetical_stack)
            return

        for _ in inpipe:
            yield from (self.Ele('void *', ele) for ele in
                        self.called_funcs_class.hypothetical_stack)


class File(walkers.Walker):
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

    def __init__(self, filenames):
        self.filenames = filenames

    @classmethod
    def from_userstring(cls, args, first, last):
        if not first:
            raise ValueError('`file` walker cannot take input')
        return cls(gdb.string_to_argv(args))

    # NOTE, name unused argument `inpipe` so that connect_pipe() can pass the
    # argument via keyword.
    def iter_def(self, inpipe):
        for filename in self.filenames:
            with open(filename, 'r') as infile:
                for line in infile:
                    yield self.Ele('void *', int(line, base=16))


class DefinedFunctions(walkers.Walker):
    '''Walk over defined functions that match the given regexp.

    This walker iterates over all functions defined in the current program.
    It takes a regular expression of the form file_regexp:func_regexp and
    limits matches based on whether they are defined in a file that matches the
    file regexp and if the function name matches the function regexp.

    To ignore the file regexp, use the regular expression .*.

    By default the walker ignores all functions defined in dynamic libraries
    (by checking the output of 'info symbol {}' matches the current progspace
    filename). If you don't want to ignore these functions, give the argument
    'include-dynlibs' after the file and function regexps.

    Usage:
        pipe defined-functions file-regexp:function-regexp [include-dynlibs]

    Example:
        // Print those functions in tree.c that use the 'insert_entry' function
        pipe defined-functions tree.c:tree | \
            if $_output_contains("global-used {} insert_entry", "insert_entry") | \
            show whereis {}

        // Walk over all functions ending with 'tree' (including those in
        // dynamic libraries)
        pipe defined-functions .*:.*tree$ True | \
            show print-string $_function_of({}); "\\n"

    '''
    name = 'defined-functions'
    tags = ['data']

    def __init__(self, include_dynlibs, file_regexp, func_regexp):
        self.include_dynlibs = include_dynlibs
        # Specify '.+' as the default to tell search_symbols() to ignore files
        # without debugging information.
        self.file_regexp = file_regexp if file_regexp is not None else '.+'
        self.func_regexp = func_regexp

    @classmethod
    def from_userstring(cls, args, first, last):
        if not first:
            raise ValueError('defined-functions must be the first walker')
        argv = gdb.string_to_argv(args)
        if len(argv) > 2:
            raise ValueError('defined-functions takes a max of two arguments')
        if len(argv) == 2:
            include_dynlibs = bool(argv[1])
        else:
            include_dynlibs = False
        return cls(include_dynlibs, *file_func_split(argv[0]))

    # NOTE, name unused argument `inpipe` so that connect_pipe() can pass the
    # argument via keyword.
    def iter_def(self, inpipe):
        for symbol in search_symbols(self.func_regexp, self.file_regexp,
                                     self.include_dynlibs):
            yield self.Ele('void *', int(as_uintptr(symbol.value())))
