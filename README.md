# GDB extensions

Contains a few helper gdb functions and commands.
Most notable are the addition of `walkers` (idea taken from `mdb`) over complex
data structures, `call-graph` command (idea taken from `dtrace -F`), and
`shellpipe` that pipes the output of a command to a shell process.

Walkers that don't exist in `mdb` are over all functions called from another
one, and the corresponding printing of the hypothetical stack created from this
walker.
There are *many* walkers in `mdb` that aren't implemented here.

Note: In order to avoid surprises, `call-graph` by default doesn't work with
non-debug functions. This is so that naive regular expressions don't end up
tracing many many functions, and to avoid the problem of functions that return
with `jmp` rather than `ret` (which are much more common in non-debug
functions).
Tracing non-debug symbols can be activated with `set call-graph-nondebug on`.

To install, simply clone this repo to `~/.config/gdb/` and put the line
`source ~/.config/gdb/gdbinit` in your `~/.gdbinit` file.

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
(gdb) pipe array char; 1; 100 | take-while {} % 2 == 0 || $count++ < 5
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
(gdb) pipe follow-until 1; {} > 100; {} + 1 | eval $sum += {}, {} | devnull
(gdb) print $sum
$1 = 5050
(gdb) 
```

### Find the indices of an array that match some condition
```
(gdb) start 20 100 Hello there this is a test
(gdb) set variable $i = -1
(gdb) pipe array char*; argv; argc  | if $i++, $_output_contains("print/s *(char **){}", "t") | show print $i
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

### List hypothetical call stack of functions called by main that use a global
in this case, use the global function `free_tree`, if you have a global
variable this would work just as well.
```
(gdb) pipe called-functions main; .*; -1 | if $_output_contains("global-used {} free_tree", "free_tree") | show hypothetical-stack
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
Starting program: /home/matthew/share/repos/gdb-config/demos/tree 10

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
