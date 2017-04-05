# GDB extensions

Contains a few helper gdb functions and commands.
Most notable are the addition of `walkers` (idea taken from `mdb`) over complex
data structures, `call-graph` command (idea taken from `dtrace -F`), and
`shellpipe` that pipes the output of a command to a shell process.

The information passed between each walker is a single integer and a type
string. In many pipelines that type string is a pointer. Many walkers can take
a format marker of `{}` that marks where the string `((type)value)` is to be
placed. In these walkers the marker can be replaced with `{.v}` or `{.t}` to
use the value or type only respectively. Due to an implementation detail, if
you are using the same item in multiple places in one sub-expression, you can't
just use `{}`, but have to use `{0}` instead.
When using the value in a command that separates based on whitespace, sometimes
the marker `{}` will work, but other times not. It depends on whether the type
is `struct somestruct` or `int *`. To avoid surprises it's recommended to use
`{.v}` when the type information is not needed.

Note: In order to avoid surprises, `call-graph` by default doesn't work with
non-debug functions. This is so that naive regular expressions don't end up
tracing many many functions, and to avoid the problem of functions that return
with `jmp` rather than `ret` (which are much more common in non-debug
functions).
Tracing non-debug symbols can be activated with `set call-graph-nondebug on`.

To install, simply clone this repo to `~/.config/gdb/` and put the line
`source ~/.config/gdb/gdbinit` in your `~/.gdbinit` file.

### Examples
There is a demo walker `tree-elements` walking over all elements in a tree
structure defined in `demo_structure.py` (the tree structure is defined in
`tree.c`).
This can be sourced and tested with `source ~/.config/gdb/demos/tree_walker.py`
and `pipe tree-elements tree_root` respectively.
```
(gdb) gdb demos/tree_debug
Reading symbols from demos/tree_debug...done.
(gdb) start 10
Temporary breakpoint 1 at 0x400963: file demos/tree.c, line 86.
Starting program: /home/matthew/share/repos/gdb-walkers/demos/tree_debug 10

Temporary breakpoint 1, main (argc=2, argv=0x7fffffffe4c8) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) until 93
main (argc=2, argv=0x7fffffffe4c8) at demos/tree.c:93
93	    free_tree(tree_root);
(gdb) source demos/tree_walker.py
(gdb) // Show all pure leaf elements in the tree.
(gdb) pipe tree-elements tree_root | if {0}->children[0] == 0 && {0}->children[1] == 0 | show print *{}
$1 = {children = {0x0, 0x0}, datum = 1753820418}
$2 = {children = {0x0, 0x0}, datum = 1255532675}
$3 = {children = {0x0, 0x0}, datum = 679162307}
$4 = {children = {0x0, 0x0}, datum = 131589623}
(gdb)
```

This repo also contains some walkers over vim structures in
`neovim_walkers.py`, and these are automatically loaded when debugging a
program called `nvim`.

Writing your own walker should be easy -- define a class inheriting from
`gdb.Walker`, `__init__()` takes three arguments, the string the walker was
initialised with, whether the walker is first in the pipeline, and whether it
is last. Then the `iter_def()` method is called with an iterator over elements
from the preceding element in the pipe, and should return an iterator over
integers.

# Getting help

All commands introduced are documented with docstrings so that the gdb `help`
command provides adequate information.
For information about walkers, the `walker help` and `walker apropos` commands
should give you enough information to see what's going on.

# Tips & Tricks

Use `$count += 3, true` as one expression in `follow-until` or the like to get
useful side-affects.
This is why it splits on the semi-colon (that, and to emphasise how it's pretty
much just a for loop).

## Many ways of counting to ten

```
(gdb) pipe follow-until 1; {} > 10; {} + 1
(gdb) pipe array char; 1; 10
(gdb) pipe follow-until 1; {} > 100; {} + 1 | head 10
(gdb) set variable $count = 0
(gdb) pipe follow-until 1; {} > 100; {} + 1 | if $count++ < 10
(gdb) set variable $count = 0
(gdb) // The below differs from the above because the iteration is cut short.
(gdb) pipe follow-until 1; {} > 100; {} + 1 | take-while $count++ < 10
(gdb) set variable $count = 0
(gdb) pipe array char; 1; 100 | take-while (int){} % 2 == 0 || $count++ < 5
(gdb) pipe follow-until 100; {} <= 0; {} - 1 | tail 10 | reverse
(gdb) // Combine the addresses of more than one walker.
(gdb) shellpipe pipe array char; 1; 5 ! cat > addresses
(gdb) shellpipe pipe array char; 6; 5 ! cat >> addresses
(gdb) pipe file addresses
```

## Other tricks

### Show position of all calls in a function
```
(gdb) shellpipe disassemble main ! grep call
   0x0000000000400984 <+48>:	callq  0x400630 <fprintf@plt>
   0x000000000040098e <+58>:	callq  0x400650 <exit@plt>
   0x00000000004009a1 <+77>:	callq  0x400640 <atoi@plt>
   0x00000000004009ae <+90>:	callq  0x4008cb <create_random_tree>
   0x00000000004009be <+106>:	callq  0x40085c <free_tree>
(gdb) 
```

### foldl implemented through side-effects
I know ... that doesn't quite sound right does it?
```
(gdb) set variable $sum = 0
(gdb) pipe follow-until 1; {} > 100; {} + 1 | eval $sum += {0}, {0} | devnull
(gdb) print $sum
$1 = 5050
(gdb) 
```

### Find the indices of an array that match some condition
```
(gdb) start 20 100 Hello there this is a test
(gdb) set variable $i = -1
(gdb) pipe array char*; argv; argc  | if $i++, $_output_contains("print *{}", "t") | show print $i
$103 = 0
$108 = 4
$110 = 5
$114 = 8
(gdb) print argv[4]
$118 = 0x7fffffffe897 "there"
(gdb) print argv[5]
$117 = 0x7fffffffe89d "this"
(gdb) 
```

### List all functions called by main 
probably a bad idea in anything but the smallest program and their source code
file name and line number.
```
(gdb) pipe called-functions main; .*; -1 | show printf "%18s\t%s\n", $_function_of({}), $_whereis({})
              main	demos/tree.c:85
         free_tree	demos/tree.c:53
create_random_tree	demos/tree.c:69
      insert_entry	demos/tree.c:23
       create_tree	demos/tree.c:62
(gdb) 
```

### List all functions defined in tree.c that use a global variable
in this case, use the global function `free_tree`, if you have a global
variable this would work just as well.
```
(gdb) pipe defined-functions tree.c:.* | if $_output_contains("global-used {.v} free_tree", "free_tree") | show whereis {.v}
(gdb) // Walk over all functions ending with 'tree' (including those in dynamic libraries)
(gdb) pipe defined-functions .*:.*tree$ True | show print-string $_function_of({}); "\n"
(gdb) // NOTE, I use my own command `print-string` above to avoid
(gdb) // `printf "%s\n", $_function_of({})` as `printf "%s", <somestring>`
(gdb) // allocates the string in the inferior and provides no way of
(gdb) // `free()`ing it.
```

### List hypothetical call stack of functions called by main that use a global
```
(gdb) pipe called-functions main; .*; -1 | if $_output_contains("global-used {.v} free_tree", "free_tree") | show hypothetical-stack
main demos/tree.c:85

main demos/tree.c:85
create_random_tree demos/tree.c:69

main demos/tree.c:85
create_random_tree demos/tree.c:69
free_tree demos/tree.c:53

main demos/tree.c:85
free_tree demos/tree.c:53

(gdb) 
(gdb)
```

## Call Graph

This command does similar to `dtrace -F`.

Example

```
(gdb) gdb demos/tree
Reading symbols from demos/tree...done.
(gdb) start 10
Temporary breakpoint 1 at 0x400963: file demos/tree.c, line 86.
Starting program: /home/matthew/share/repos/gdb-walkers/demos/tree 10

Temporary breakpoint 1, main (argc=2, argv=0x7fffffffe4d8) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) call-graph init .*
(gdb) cont
Continuing.
     --> create_random_tree
         --> create_tree
         <-- *create_tree+45
         --> insert_entry
         <-- *insert_entry+229
         --> insert_entry
         <-- *insert_entry+229
         --> insert_entry
         <-- *insert_entry+229
         --> insert_entry
         <-- *insert_entry+229
         --> insert_entry
         <-- *insert_entry+229
         --> insert_entry
         <-- *insert_entry+229
         --> insert_entry
         <-- *insert_entry+229
         --> insert_entry
         <-- *insert_entry+229
         --> insert_entry
         <-- *insert_entry+229
         --> insert_entry
         <-- *insert_entry+229
     <-- *create_random_tree+136
     --> free_tree
         --> free_tree
             --> free_tree
                 --> free_tree
                 <-- *free_tree+64
                 --> free_tree
                 <-- *free_tree+64
             <-- *free_tree+64
             --> free_tree
                 --> free_tree
                 <-- *free_tree+64
                 --> free_tree
                 <-- *free_tree+64
             <-- *free_tree+64
         <-- *free_tree+64
         --> free_tree
             --> free_tree
             <-- *free_tree+64
             --> free_tree
                 --> free_tree
                     --> free_tree
                         --> free_tree
                         <-- *free_tree+64
                         --> free_tree
                             --> free_tree
                             <-- *free_tree+64
                             --> free_tree
                             <-- *free_tree+64
                         <-- *free_tree+64
                     <-- *free_tree+64
                     --> free_tree
                     <-- *free_tree+64
                 <-- *free_tree+64
                 --> free_tree
                     --> free_tree
                         --> free_tree
                         <-- *free_tree+64
                         --> free_tree
                         <-- *free_tree+64
                     <-- *free_tree+64
                     --> free_tree
                     <-- *free_tree+64
                 <-- *free_tree+64
             <-- *free_tree+64
         <-- *free_tree+64
     <-- *free_tree+64
 <-- *main+117
[Inferior 1 (process 10473) exited normally]
(gdb) 
```
