set python print-stack full
source ~/.config/gdb/basic_config.py
source ~/.config/gdb/commands.py
source ~/.config/gdb/functions.py
add-auto-load-safe-path ~/.gdbinit

# gdb puts strings into the inferior when printing them with printf.
# It does this with malloc(3), and never frees them.
# https://sourceware.org/ml/gdb/2017-02/msg00046.html
# Hence, keep a track of the string position, and free them manually.
# i.e. the simple version of this command
#    printf "%s %s\n", $_function_of($arg0), $_whereis($arg0)
# can't be used.
#
# We could use the below to avoid this, but it puts the convenience variables
# $function_name_ptr and $line_pos_ptr into the gdb environment.
# define whereis
#     set variable $function_name_ptr =  (char *)$_function_of($arg0)
#     set variable $line_pos_ptr = (char *)$_whereis($arg0) 
#     printf "%s %s\n", $function_name_ptr, $line_pos_ptr
#     call free($function_name_ptr)
#     call free($line_pos_ptr)
# end
#
# Hence, I wrote a python command to print strings.
# It's the equivalent of
#   python print(str(gdb.parse_and_eval('...'))[1:-1], end='')
# but neater.
# 
# Note that this also avoids extra characters being printed from the python
# string not being NULL terminated and yet the `printf` command putting it into
# the inferior and then acting as though it were a NULL terminated string in
# the inferior.
define whereis
    print-string $_function_of($arg0); " "; $_whereis($arg0); "\n";
end

define whereami
    whereis $pc
end

define outputnl
  output $arg0
  print-string "\n"
end
