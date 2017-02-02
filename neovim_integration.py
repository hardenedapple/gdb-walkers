import neovim
import gdb
import os
from helpers import eval_int
import string

def get_nvim_instance():
    nvim_socket_path = os.getenv('NEOVIM_SOCKET_ADDR')
    if not nvim_socket_path:
        raise OSError('No socket path NEOVIM_SOCKET_ADDR in environment')
    return neovim.attach('socket', path=nvim_socket_path)


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
        frame = gdb.selected_frame()
        nvim = get_nvim_instance()
        for mark in string.ascii_uppercase:
            curpc = frame.pc()
            pc_pos = gdb.find_pc_line(int(curpc))
            # Can only add this position if we know the filename.
            # If we don't know the filename, clear this mark.
            # If we didn't clear the mark, then neovim would end up with
            if pc_pos.symtab:
                full_filename = os.path.abspath(pc_pos.symtab.filename)
                # Doesn't really matter if the buffer has already been loaded
                # -- this command doesn't do anything if it has.
                nvim.command('badd {}'.format(full_filename))
                bufnr = nvim.funcs.bufnr(full_filename)
                nvim.funcs.setpos("'{}".format(mark), [bufnr, pc_pos.line, 0, 0])
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
            raise ValueError('Usage: gohere [default | e | vnew | new] [address]')

        address = '$pc' if len(args) < 2 else args[1]
        open_method = 'default' if not args else args[0]

        pos = gdb.find_pc_line(eval_int(address))
        if not pos.symtab:
            raise ValueError("Can't find address {}".format(address))

        nvim = get_nvim_instance()

        if open_method == 'default':
            for win in nvim.current.tabpage.windows:
                if win.vars.get('gdb_view'):
                    nvim.command('{} wincmd w'.format(win.number))
                    break
            open_method = 'e'

        nvim.command('{} +{} {}'.format(open_method, pos.line,
                                        os.path.abspath(pos.symtab.filename)))
        nvim.command('{}foldopen!'.format(pos.line))


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
        gdb.execute('gohere default {}'.format(address))
        nvim.command('{} wincmd w'.format(curwin.number))




GoHere()
MarkStack()
ShowHere()
