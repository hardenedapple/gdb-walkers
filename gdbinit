set python print-stack full
source ~/.config/gdb/dumb-term.py
source ~/.config/gdb/helpers.py
# Must source helpers.py first -- those functions are used in many places.
source ~/.config/gdb/commands.py
source ~/.config/gdb/functions.py
source ~/.config/gdb/walker.py

# Really often used variation of whereis.
define whereami
    printf "%s %s\n", $_function_of($pc), $_whereis($pc)
end
