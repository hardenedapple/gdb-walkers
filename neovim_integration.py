import os
import string
import neovim
import gdb
from helpers import eval_int


def get_nvim_instance():
    nvim_socket_path = os.getenv('NEOVIM_SOCKET_ADDR')
    if not nvim_socket_path:
        raise OSError('No socket path NEOVIM_SOCKET_ADDR in environment')
    return neovim.attach('socket', path=nvim_socket_path)


def find_marked_window(nvim):
    for win in nvim.current.tabpage.windows:
        if win.vars.get('gdb_view'):
            return win
    return None


class MarkStack(gdb.Command):
    '''Put marks A-Z on each of the current stack.

    Can then view each of the relevant functions reasonably easily.

    Usage:
        nvim-mark-stack

    '''
    def __init__(self):
        super(MarkStack, self).__init__('mark-stack', gdb.COMMAND_USER)

    def invoke(self, arg, _):
        self.dont_repeat()
        if len(gdb.string_to_argv(arg)):
            raise ValueError('mark-stack takes no arguments')
        frame = gdb.selected_frame()
        nvim = get_nvim_instance()
        for mark in string.ascii_uppercase:
            # TODO Sometimes strange things are happening:
            # frame.older().pc() == frame.pc()
            # frame.older().find_sal().pc == 0 != frame.find_sal().pc
            # frame.find_sal().line != frame.older().find_sal().line
            # frame.name() != frame.older().name()
            #   Example problem is in gdb
            # #0  c_val_print_array (options=0x7fffffffdde0, original_value=<optimized out>, recurse=<optimized out>, stream=0xf62f40, address=<optimized out>, embedded_offset=0, valaddr=0x172efa0 "u_savecommon", type=<optimized out>) at /home/matthew/share/repos/gdb-source/gdb/c-valprint.c:307
            # #1  c_val_print (type=<optimized out>, embedded_offset=0, address=<optimized out>, stream=0xf62f40, recurse=<optimized out>, original_value=<optimized out>, options=0x7fffffffdde0) at /home/matthew/share/repos/gdb-source/gdb/c-valprint.c:511
            # #2  0x0000000000697420 in val_print (type=0x0, type@entry=0x18b3870, embedded_offset=0, address=25901168, address@entry=0, stream=stream@entry=0xf62f40, recurse=recurse@entry=0, val=val@entry=0x1811bd0, options=0x7fffffffde90, language=0x88f0e0 <c_language_defn>) at /home/matthew/share/repos/gdb-source/gdb/valprint.c:1120
            # #3  0x0000000000558eec in c_value_print (val=0x1811bd0, stream=0xf62f40, options=<optimized out>) at /home/matthew/share/repos/gdb-source/gdb/c-valprint.c:698
            # #4  0x00000000006273a8 in print_value (val=val@entry=0x1811bd0, fmtp=fmtp@entry=0x7fffffffdfa0) at /home/matthew/share/repos/gdb-source/gdb/printcmd.c:1233
            # #5  0x000000000062743e in print_command_1 (exp=<optimized out>, voidprint=1) at /home/matthew/share/repos/gdb-source/gdb/printcmd.c:1261
            # #6  0x0000000000495133 in cmd_func (cmd=0xe85630, args=0xe0d816 "$_function_of(&u_savecommon)", from_tty=1) at /home/matthew/share/repos/gdb-source/gdb/cli/cli-decode.c:1888
            # #7  0x00000000006837b3 in execute_command (p=<optimized out>, p@entry=0xe0d810 "print $_function_of(&u_savecommon)", from_tty=1) at /home/matthew/share/repos/gdb-source/gdb/top.c:674
            # #8  0x00000000005b1abc in command_handler (command=0xe0d810 "print $_function_of(&u_savecommon)") at /home/matthew/share/repos/gdb-source/gdb/event-top.c:590
            # #9  0x00000000005b1d88 in command_line_handler (rl=<optimized out>) at /home/matthew/share/repos/gdb-source/gdb/event-top.c:780
            # #10 0x00000000005b10fc in gdb_rl_callback_handler (rl=0x18b89f0 "print $_function_of(&u_savecommon)") at /home/matthew/share/repos/gdb-source/gdb/event-top.c:213
            # #11 0x00000000006c4463 in rl_callback_read_char () at /home/matthew/share/repos/gdb-source/readline/callback.c:220
            # #12 0x00000000005b103e in gdb_rl_callback_read_char_wrapper_noexcept () at /home/matthew/share/repos/gdb-source/gdb/event-top.c:175
            # #13 0x00000000005b10a9 in gdb_rl_callback_read_char_wrapper (client_data=<optimized out>) at /home/matthew/share/repos/gdb-source/gdb/event-top.c:192
            # #14 0x00000000005b15d0 in stdin_event_handler (error=<optimized out>, client_data=0xd95c10) at /home/matthew/share/repos/gdb-source/gdb/event-top.c:518
            # #15 0x00000000005b044d in gdb_wait_for_event (block=block@entry=0) at /home/matthew/share/repos/gdb-source/gdb/event-loop.c:859
            # #16 0x00000000005b0587 in gdb_do_one_event () at /home/matthew/share/repos/gdb-source/gdb/event-loop.c:322
            # #17 0x00000000005b0725 in gdb_do_one_event () at /home/matthew/share/repos/gdb-source/gdb/common/common-exceptions.h:221
            # #18 start_event_loop () at /home/matthew/share/repos/gdb-source/gdb/event-loop.c:371
            # #19 0x0000000000602fb8 in captured_command_loop (data=data@entry=0x0) at /home/matthew/share/repos/gdb-source/gdb/main.c:325
            # #20 0x00000000005b2693 in catch_errors (func=func@entry=0x602f90 <captured_command_loop(void*)>, func_args=func_args@entry=0x0, errstring=errstring@entry=0x832059 "", mask=mask@entry=RETURN_MASK_ALL) at /home/matthew/share/repos/gdb-source/gdb/exceptions.c:236
            # #21 0x0000000000603eae in captured_main (data=0x7fffffffe280) at /home/matthew/share/repos/gdb-source/gdb/main.c:1148
            # #22 gdb_main (args=args@entry=0x7fffffffe3a0) at /home/matthew/share/repos/gdb-source/gdb/main.c:1158
            # #23 0x000000000040ec95 in main (argc=<optimized out>, argv=<optimized out>) at /home/matthew/share/repos/gdb-source/gdb/gdb.c:32
            #
            # Find out why.
            #   (maybe something to do with tail-call optimisation?)
            # This is why I use frame.find_sal() instead of
            # gdb.find_pc_line(frame.pc())
            #   (that and it's a cleaner way to reference it)

            # Here we mark c_val_print_array() and c_val_print() in the same
            # position.
            pc_pos = frame.find_sal()
            # Can only add this position if we know the filename.
            # If we don't know the filename, clear this mark.
            # If we didn't clear the mark, then neovim would end up with
            if pc_pos.symtab:
                full_filename = os.path.abspath(pc_pos.symtab.filename)
                # Doesn't really matter if the buffer has already been loaded
                # -- this command doesn't do anything if it has.
                nvim.command('badd {}'.format(full_filename))
                bufnr = nvim.funcs.bufnr(full_filename)
                nvim.funcs.setpos("'{}".format(mark),
                                  [bufnr, pc_pos.line, 0, 0])
            else:
                nvim.command('delmark {}'.format(mark))

            frame = frame.older()
            if frame is None:
                # Clear all remaining marks (to make sure the user doesn't get
                # confused about what marks are from this run and what marks
                # are from previous runs).
                marks_to_clear = string.ascii_uppercase[
                    string.ascii_uppercase.find(mark) + 1:]
                nvim.command('delmarks {}'.format(marks_to_clear))
                return


class GoHere(gdb.Command):
    '''View the current position in a neovim buffer.

    Usage:
        # If there is a window with w:gdb_view set go there before moving to
        # current window.
        # Otherwise,
        gohere [default] [address]
        # Use current window
        gohere e [address]
        # Use vertical split window
        gohere vnew [address]
        # Use horizontal split window
        gohere new [address]

    Examples:
        gohere
        gohere default some_function
        gohere d some_function
        gohere vnew
        gohere vnew some_function

    '''
    def __init__(self):
        super(GoHere, self).__init__('gohere', gdb.COMMAND_USER)

    def invoke(self, arg, _):
        self.dont_repeat()
        args = gdb.string_to_argv(arg)
        if len(args) > 2:
            raise ValueError(
                'Usage: gohere [default | e | vnew | new] [address]')

        address = '$pc' if len(args) < 2 else args[1]
        open_method = 'default' if not args else args[0]

        pos = gdb.find_pc_line(eval_int(address))
        if not pos.symtab:
            raise ValueError("Can't find address {}".format(address))

        nvim = get_nvim_instance()

        if open_method == 'default':
            win = find_marked_window(nvim)
            if win:
                nvim.command('{} wincmd w'.format(win.number))
            open_method = 'e'

        nvim.command('{} +{} {}'.format(open_method, pos.line,
                                        os.path.abspath(pos.symtab.filename)))
        nvim.command('silent! {}foldopen!'.format(pos.line))


class ShowHere(gdb.Command):
    '''Run `gohere` with default arguments, and return to the current window.

    Usage:
        showhere [address]

    '''
    def __init__(self):
        super(ShowHere, self).__init__('showhere', gdb.COMMAND_USER)

    def invoke(self, arg, _):
        args = gdb.string_to_argv(arg)
        if len(args) > 1:
            raise ValueError('Usage: showhere [address]')
        address = '$pc' if not args else args[0]
        nvim = get_nvim_instance()
        curwin = nvim.current.window
        marked_win = find_marked_window(nvim)
        if not marked_win:
            tabwindows = list(nvim.current.tabpage.windows)
            if curwin.number != 1:
                tabwindows[curwin.number - 2].vars['gdb_view'] = 1
            else:
                try:
                    tabwindows[curwin.number].vars['gdb_view'] = 1
                except IndexError:
                    nvim.command('wincmd v')
                    nvim.current.window.vars['gdb_view'] = 1
                    nvim.command('wincmd w')

        gdb.execute('gohere default {}'.format(address))
        nvim.command('{} wincmd w'.format(curwin.number))


GoHere()
MarkStack()
ShowHere()
