set python print-stack full
source ~/.config/gdb/dumb-term.py
source ~/.config/gdb/helpers.py
# Must source helpers.py first -- those functions are used in many places.
source ~/.config/gdb/commands.py
source ~/.config/gdb/functions.py
source ~/.config/gdb/walker.py

define wheresthis
    printf "%s %s\n", $_function_of($arg0), $_whereis($arg0)
end
define whereami
    wheresthis $pc
end
