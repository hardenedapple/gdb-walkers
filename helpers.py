'''Helper functions -- used throughout the config files.

The uintptr_t variable has to be a global variable because other functions want
to use it.

If using `from helpers import uintptr_t`, the `start_handler()` function
doesn't change the value everywhere else because these other modules get their
own local copy -- I don't know the logic behind this.

Hence I either have to import the module everywhere and use qualified names,
or source it directly in the gdbinit file.

'''
import gdb
import re
import collections


def find_uintptr_t():
    '''Find a uintptr_t equivalent and store it in the global namespace.'''
    voidptr_t = gdb.parse_and_eval('(char *)0').type
    size_and_types = {val.sizeof: val for val in
                      map(gdb.lookup_type, ['unsigned int', 'unsigned long',
                                            'unsigned long long'])}
    try:
        return size_and_types[voidptr_t.sizeof]
    except KeyError:
        raise RuntimeError('Failed to find size of pointer type')


# First guess -- on starting the program we update this.
# This is because we don't actually know the size of a pointer type until we
# attach to the process.
uintptr_t = find_uintptr_t()


def eval_int(gdb_expr):
    '''Return the python integer value of `gdb_expr`

    This is to be used over `int(gdb.parse_and_eval(gdb_expr))` to
    account for the given description being a symbol.

    '''
    return int(gdb.parse_and_eval(gdb_expr).cast(uintptr_t))


def start_handler(_):
    '''Upon startup, find the pointer type for this program'''
    global uintptr_t
    uintptr_t = find_uintptr_t()
    # Remove us from the handler -- there is no reason to keep finding the same
    # pointer type.
    # NOTE:
    #   This may have trouble when inspecting both 32bit and 64 bit programs in
    #   the same gdb session.
    #   In that case, just manually run
    #      (gdb) python find_uintptr_t()
    #   and you should be fine.
    gdb.events.new_objfile.disconnect(start_handler)


# Update uintptr_t value on first objfile added because by then we'll know what
# the current program file architecture is. If we find the current pointer type
# before we do anything else gdb just guesses.
gdb.events.new_objfile.connect(start_handler)

if not hasattr(gdb, 'current_arch'):
    def cur_arch():
        '''
        Get the current architecture.

        This only works if the program is currently running.

        If the gdb.current_arch() function is defined, then it's much better
        than this mock because it works even when the current process isn't
        running.

        '''
        return gdb.selected_frame().architecture()

    gdb.current_arch = cur_arch


class FakeSymbol():
    '''Fake a gdb.Symbol class.

    Can't make these directly because we don't have enough information.
    All we need for the current use-case is the value() method, and the name
    attribute.

    '''
    pointless_symtab = collections.namedtuple('symtab', ['filename'])
    symtab = pointless_symtab('')
    def __init__(self, name, value):
        self.name = name
        self._value = gdb.parse_and_eval(value)

    def value(self):
        return self._value


if not hasattr(gdb, 'search_symbols'):
    def file_symbols(filename, regexp):
        '''Iterate over all symbols defined in a file.'''
        if not filename:
            return

        try:
            unparsed, sal_options = gdb.decode_line("'{}':1".format(filename))
        except gdb.error as e:
            if e.args[0].startswith('No line 1 in file "'):
                return
            raise

        if unparsed:
            raise ValueError('Failed to parse {} as filename'.format(filename))

        # TODO Check source code and see if this is always the case.
        # NOTE: When there are more than one symbol and file options given from
        # the same source file, they all have the same set of symbol names.
        #   (as far as I can tell -- haven't yet looked at the gdb source).
        # Hence ignore any extra ones.
        sal = sal_options[0]
        for block in (sal.symtab.global_block(), sal.symtab.static_block()):
            yield from (sym for sym in block
                        if sym.is_function and re.match(regexp, sym.name))


    def search_symbols(regexp, file_regex, include_dynlibs=False):
        '''Return symbols matching REGEXP defined in files matching FILE_REGEXP

        If FILE_REGEXP matches the empty string, include Non-debug functions.

        '''
        include_non_debugging = re.search(file_regex, '') is not None
        try:
            # TODO substitute with
            # interpreter-exec mi -file-list-exec-source-files ?
            # This should have a well defined output, so I would have to worry
            # less about the output changing in the future.
            # Unfortunately, the output isn't nearly as simple to parse, and as
            # long as the output stays the same, this is both easy and robust
            # against strange filenames.
            #
            # I could use pygdbmi, but I really don't want to add a dependency
            # for this.
            # https://github.com/cs01/pygdbmi
            source_files = gdb.execute('info sources', False, True)
        except gdb.error as e:
            if e.args != ('No symbol table is loaded.  Use the "file" command.',):
                raise e
        else:
            source_lines = source_files.splitlines()
            loaded = source_lines[2]
            unloaded = source_lines[6]
            for filelist in loaded.split(', '), unloaded.split(', '):
                for filename in (val for val in filelist if
                                 re.search(file_regex, val)):
                    yield from file_symbols(filename, regexp)

        if include_non_debugging:
            # TODO not really sure whether this is a safe way of making sure we
            # only get the main program. Read the gdb source and see what's
            # actually happening.
            cur_progfile = gdb.current_progspace().filename

            # Don't filter functions directly with regexp because we want to
            # use python rexexp (to match the filter done above).
            all_symbols = gdb.execute('info functions', False, True)
            non_debug_start = all_symbols.find('Non-debugging symbols:')
            all_non_debugging = all_symbols[non_debug_start:].splitlines()[1:]
            # Just because it makes me feel better to let python free the big
            # string -- probably doesn't matter.
            del all_symbols
            for line in all_non_debugging:
                # If ValueError() is raised here, then my assumptions are
                # incorrect -- I need to know about it.
                # For example, `info functions` on $(which nvim) gives me the
                # lines
                # 0x00007ffff7bbb310  uv(float, long double,...)(...)@plt
                # 0x00007ffff7bbcd50  uv(float, long double,...)(...)
                # and others.
                # I don't know what to do with these, so I ignore them.
                # TODO Figure out what to do with these.
                try:
                    addr, name = line.split()
                except ValueError as e:
                    if e.args == ('too many values to unpack (expected 2)',):
                        continue
                    raise e

                # Assume users don't care about the indirection functions.
                if not re.match(regexp, name) or name.endswith('@plt'):
                    continue
                if not include_dynlibs:
                    sym_objfile = gdb.execute('info symbol {}'.format(addr),
                                              False, True).split()[-1]
                    if sym_objfile != cur_progfile:
                        continue

                yield FakeSymbol(name, addr)


    gdb.search_symbols = search_symbols


def function_disassembly(func_addr, arch=None, use_fallback=True):
    '''Return the disassembly and filename of the function at `func_addr`.

    If there are no debugging symbols, return the None as the filename.
        (function_disassembly, function_name or None, function_filename or None)

    If we have debugging information, but we can't find a function at the
    address specified, we return '' for the function_name and
    function_filename.

    If `use_fallback` is set to False, and there is are no debugging symbols
    for the current function, return (None, None, None).

    '''
    arch = arch or gdb.current_arch()

    try:
        func_block = gdb.block_for_pc(func_addr)

        # Bit of a hack, but I want the same thing to happen when gdb can't
        # find the object file (and hence raises an exception itself) as when
        # it just can't find the block.
        if func_block is None:
            raise RuntimeError('Cannot locate object file for block.')
    except RuntimeError as e:
        if e.args != ('Cannot locate object file for block.', ):
            raise e
    else:
        orig_block = func_block
        # This has happened a few times -- find out why/when.
        # When the file was compiled without debugging.
        if func_block is None:
            print(func_addr)

        # Often enough that it's a problem, despite being given the start of a
        # function as the address, we get a child block of the function.
        # Functions I've seen this happen with (all when inspecting a debug
        # build of neovim).
        #
        # src/valgrind.c je_valgrind_make_mem_undefined
        # src/valgrind.c je_valgrind_make_mem_defined
        # include/jemalloc/internal/atomic.h je_atomic_add_uint32
        #
        # I used the below to get this output.
        # if not func_block.function:
        #     print(func_addr)
        #     above = func_block.superblock.function
        #     if above:
        #         print(above.symtab.filename, above.name)

        while func_block and func_block.function is None:
            func_block = func_block.superblock

        if func_block:
            function_name = func_block.function.name
            function_filename = func_block.function.symtab.filename
        else:
            # Print this out for my information -- I don't know of a case when
            # this would happen, so if it does I have a chance to learn.
            print('Function not found at {}'.format(func_addr))
            func_block = orig_block
            function_name = ''
            function_filename = ''

        # No instruction is less than one byte.
        # If we provide an end point that is one byte less than the end of the
        # last instruction in the block, then this ends the disassembly on the
        # last instruction of the function.
        return (arch.disassemble(func_block.start, func_block.end-1),
                function_name,
                function_filename)

    if not use_fallback:
        return (None, None, None)

    # Fallback -- Use the gdb `disassemble` command to disassemble the entire
    # function, and find difference between the start and end of that function.

    # Rather than implementing a conversion function between a line in the
    # output of the `disassemble` command and a dictionary that matches the
    # output of the Architecture.disassemble() method, we just find the extent
    # of the current function with `disassemble {}`, and then return the list
    # made from Architecture.disassemble() directly.
    output = gdb.execute('disassemble {}'.format(func_addr), False, True)
    lines = output.splitlines()
    if not lines[0].startswith('Dump of assembler code for function'):
        raise RuntimeError('Failed to find function at {}'.format(func_addr))

    # Avoid the 'End of assembler dump.' line that is actually last.
    start_addr = int(lines[1].split()[0], base=16)
    last_pos = int(lines[-2].split()[0], base=16)
    function_name = re.search('Dump of assembler code for function (\S+):',
                              lines[0])
    function_name = function_name.groups()[0] if function_name else None
    return arch.disassemble(start_addr, last_pos), function_name, None


def func_and_offset(addr):
    '''Return the function and offset into that function of `addr`.

    If failed to find the function at the given address, return (None, None).

    '''
    # If given @plt addresses (or other problematic functions) just ignore
    # them and return an error message -- (better than raising an error?)
    try:
        block = gdb.block_for_pc(addr)
    except RuntimeError as e:
        # If this is an exception we don't know about, raise.
        if e.args != ('Cannot locate object file for block.',):
            raise

        # Attempt to work with symbols that don't have debugging information.
        retval = gdb.execute('info symbol {}'.format(addr),
                            False, True)
        # Checking for section ".text" removes @plt stubs and variables.
        if 'in section .text' not in retval:
            print('{} is not a .text location'.format(addr))
            return (None, None)

        # At the moment I believe that all awkward output (i.e. of the form
        # funcname(function, argument, types) in section .text of /home/matthew/temp_dir/gdb/gdb/gdb
        # are avoided because when there is debug info we've used the alternate
        # method. Hence, the output should be of the form
        # <funcname> + <offset> in section .text of <objfile>
        # If this isn't the case, alert user so I know there's a problem and
        # can investigate what I've missed.
        #
        # NOTE: I believe that digits are always printed in decimal -- can't
        # find any way to change this, so I believe there isn't one.
        # If this isn't the case, then I hopefully will notice the problem when
        # this function fails.
        sym_match = re.match('(\S+)( \+ (\d+))? in section .text', retval)
        if not sym_match:
            print('Cannot parse output from command `info symbol {}`.'.format(
                addr))
            return (None, None)

        offset = int(sym_match.group(3)) if sym_match.group(3) else 0
        return (sym_match.group(1), offset)

    while block.function is None:
        if block.superblock:
            block = block.superblock
        else:
            raise gdb.GdbError('Could not find enclosing function of '
                                '{} ({})'.format(addr, arg))

    offset = addr - block.start
    return (block.function.name, offset)
