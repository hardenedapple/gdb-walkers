set python print-stack full
source ~/.config/gdb/basic-config.py
source ~/.config/gdb/commands.py
source ~/.config/gdb/functions.py
source ~/.config/gdb/walker.py
source ~/.config/gdb/neovim_integration.py

define whereis
    printf "%s %s\n", $_function_of($arg0), $_whereis($arg0)
end
define whereami
    whereis $pc
end
