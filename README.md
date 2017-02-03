# GDB configuration files

Contains all the helper python commands and functions I've written for myself.

# NOTE -- this repo and README are under flux
Everything here is subject to change, at the moment the README is pretty much
just a collection of tricks I want to make sure I don't lose the ability to do
when working. (i.e. this is the place where poorly formed tests go).


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
```

## Other tricks

foldl can be implemented by using side-effects (I know ... that doesn't quite
fit together right does it?)

```
(gdb) set variable $sum = 0
(gdb) pipe follow-until 1; {} > 100; {} + 1 | eval $sum += {}, {} | devnull
(gdb) print $sum
$1 = 5050
(gdb) 
```

Find the indices of an array that match some condition
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

List all functions called by main (probably a bad idea in anything but the
smallest program) and their source code file name and line number.
```
(gdb) pipe called-functions main; .*; -1 | show printf "%18s\t%s\n", $_function_of({}), $_whereis({})
              main	demos/tree.c:85
         free_tree	demos/tree.c:53
create_random_tree	demos/tree.c:69
      insert_entry	demos/tree.c:23
       create_tree	demos/tree.c:62
(gdb) 
```

List the hypothetical call stack of all functions called by main that use a
global variable (in this case, use the global function `free_tree`).
```
(gdb) pipe called-functions main; .*; -1 | if $_output_contains("global-used {} free_tree", "free_tree") | show hypothetical-stack | show printf "\n"
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

This command emulates `dtrace -F`.

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
