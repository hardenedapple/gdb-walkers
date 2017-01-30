set python print-stack full
source ~/.config/gdb/dumb-term.py
source ~/.config/gdb/commands.py
source ~/.config/gdb/functions.py
# walker.py has to be called after shell-pipe.py because shell-pipe.py defines
# some helper functions that walker.py uses.
source ~/.config/gdb/walker.py

# Really often used variation of whereis.
define whereami
    printf "%s %s\n", $_function_of($pc), $_whereis($pc)
end
