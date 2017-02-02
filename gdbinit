set python print-stack full
source basic-config.py
source commands.py
source functions.py
source walker.py

define wheresthis
    printf "%s %s\n", $_function_of($arg0), $_whereis($arg0)
end
define whereami
    wheresthis $pc
end
