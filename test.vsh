vshcmd: > quit
vshcmd: > y
A debugging session is active.

	Inferior 5 [process 12634] will be killed.

Quit anyway? (y or n) gdb [12:46:36] $ 
vshcmd: > gdb
vshcmd: > add-auto-load-scripts-directory /usr/share/gdb/auto-load
vshcmd: > add-auto-load-safe-path /usr/share/gdb/auto-load
vshcmd: > add-inferior -exec demos/tree
vshcmd: > add-inferior -exec demos/tree_debug
vshcmd: > add-inferior -exec demos/list
vshcmd: > add-inferior -exec demos/cpp_structures
vshcmd: > set pagination off
vshcmd: > inferior 3
(gdb) (gdb) (gdb) [New inferior 2]
Added inferior 2
Reading symbols from demos/tree...
(No debugging symbols found in demos/tree)
(gdb) [New inferior 3]
Added inferior 3
Reading symbols from demos/tree_debug...
(gdb) [New inferior 4]
Added inferior 4
Reading symbols from demos/list...
(gdb) [New inferior 5]
Added inferior 5
Reading symbols from demos/cpp_structures...
(gdb) (gdb) [Switching to inferior 3 [<null>] (/home/matmal01/.config/gdb/demos/tree_debug)]
(gdb) 
vshcmd: > # BELOW IS ORIGINAL
vshcmd: > start 10
Temporary breakpoint 1 at 0x400954: main. (4 locations)
Starting program: /home/matmal01/.config/gdb/demos/tree_debug 10

Temporary breakpoint 1, main (argc=2, argv=0x7fffffffdfd8) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) 
vshcmd: > call-graph init .*
(gdb) 
vshcmd: > info call-graph
Functions currently traced by call-graph:
	 main
	 create_random_tree
	 free_tree
	 create_tree
	 insert_entry
(gdb) 
vshcmd: > info call-graph exact
Functions currently traced by call-graph:
	 0x400984 	 main
	 0x4008fb 	 create_random_tree
	 0x40088c 	 free_tree
	 0x4008cd 	 create_tree
	 0x4007a6 	 insert_entry
(gdb) 
vshcmd: > call-graph update - free_tree
(gdb) 
vshcmd: > info call-graph
Functions currently traced by call-graph:
	 main
	 create_random_tree
	 create_tree
	 insert_entry
(gdb) 
vshcmd: > call-graph update + free_tree
(gdb) 
vshcmd: > info call-graph
Functions currently traced by call-graph:
	 main
	 create_random_tree
	 free_tree
	 create_tree
	 insert_entry
(gdb) 
vshcmd: > cont
Continuing.
     --> create_random_tree
         --> create_tree
         <-- create_tree+45
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
     <-- create_random_tree+136
     --> free_tree
         --> free_tree
             --> free_tree
                 --> free_tree
                 <-- free_tree+64
                 --> free_tree
                 <-- free_tree+64
             <-- free_tree+64
             --> free_tree
                 --> free_tree
                 <-- free_tree+64
                 --> free_tree
                 <-- free_tree+64
             <-- free_tree+64
         <-- free_tree+64
         --> free_tree
             --> free_tree
             <-- free_tree+64
             --> free_tree
                 --> free_tree
                     --> free_tree
                         --> free_tree
                         <-- free_tree+64
                         --> free_tree
                             --> free_tree
                             <-- free_tree+64
                             --> free_tree
                             <-- free_tree+64
                         <-- free_tree+64
                     <-- free_tree+64
                     --> free_tree
                     <-- free_tree+64
                 <-- free_tree+64
                 --> free_tree
                     --> free_tree
                         --> free_tree
                         <-- free_tree+64
                         --> free_tree
                         <-- free_tree+64
                     <-- free_tree+64
                     --> free_tree
                     <-- free_tree+64
                 <-- free_tree+64
             <-- free_tree+64
         <-- free_tree+64
     <-- free_tree+64
 <-- main+117
[Inferior 3 (process 5318) exited normally]
(gdb) 
vshcmd: > set call-graph-enabled off
vshcmd: > run
call-graph tracing is disabled
(gdb) Starting program: /home/matmal01/.config/gdb/demos/tree_debug 10
[Inferior 3 (process 5331) exited normally]
(gdb) 
vshcmd: > set call-graph-enabled on
call-graph tracing is enabled
(gdb) 
vshcmd: > !rm test.txt
vshcmd: > set call-graph-output test.txt
vshcmd: > run
(gdb) call-graph trace output directed to test.txt
(gdb) Starting program: /home/matmal01/.config/gdb/demos/tree_debug 10
[Inferior 3 (process 5350) exited normally]
(gdb) 
vshcmd: > set call-graph-output stdout
call-graph trace output directed to stdout
(gdb) 
vshcmd: > !cat test.txt
vshcmd: > !rm test.txt
 --> main
     --> create_random_tree
         --> create_tree
         <-- create_tree+45
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
         --> insert_entry
         <-- insert_entry+229
     <-- create_random_tree+136
     --> free_tree
         --> free_tree
             --> free_tree
                 --> free_tree
                 <-- free_tree+64
                 --> free_tree
                 <-- free_tree+64
             <-- free_tree+64
             --> free_tree
                 --> free_tree
                 <-- free_tree+64
                 --> free_tree
                 <-- free_tree+64
             <-- free_tree+64
         <-- free_tree+64
         --> free_tree
             --> free_tree
             <-- free_tree+64
             --> free_tree
                 --> free_tree
                     --> free_tree
                         --> free_tree
                         <-- free_tree+64
                         --> free_tree
                             --> free_tree
                             <-- free_tree+64
                             --> free_tree
                             <-- free_tree+64
                         <-- free_tree+64
                     <-- free_tree+64
                     --> free_tree
                     <-- free_tree+64
                 <-- free_tree+64
                 --> free_tree
                     --> free_tree
                         --> free_tree
                         <-- free_tree+64
                         --> free_tree
                         <-- free_tree+64
                     <-- free_tree+64
                     --> free_tree
                     <-- free_tree+64
                 <-- free_tree+64
             <-- free_tree+64
         <-- free_tree+64
     <-- free_tree+64
 <-- main+117
(gdb) (gdb) 
vshcmd: > call-graph clear
vshcmd: > info call-graph
(gdb) Functions currently traced by call-graph:
(gdb) quit
gdb [11:44:33] $ 
vshcmd: > info call-graph
Functions currently traced by call-graph:
(gdb) 
vshcmd: > inferior 2
[Switching to inferior 2 [<null>] (/home/matthew/.config/gdb/demos/tree)]
(gdb) 
vshcmd: > start 10
Temporary breakpoint 2 at 0xaae: main. (4 locations)
Starting program: /home/matthew/.config/gdb/demos/tree 10

Temporary breakpoint 2, 0x0000555555554ae2 in main ()
(gdb) 
vshcmd: > call-graph init .*
(gdb) 
vshcmd: > info call-graph
Functions currently traced by call-graph:
(gdb) 
vshcmd: > set call-graph-nondebug on
call-graph will use non-debug symbols
(gdb) 
vshcmd: > set call-graph-dynlibs on
call-graph will include dynamic libraries
(gdb) 
vshcmd: > call-graph init (free_tree|insert_entry|create_tree|create_random_tree|main)
(gdb) 
vshcmd: > info call-graph
Functions currently traced by call-graph:
	 insert_entry
	 free_tree
	 create_tree
	 create_random_tree
	 main
	 free_tree
(gdb) 
vshcmd: > info call-graph exact
Functions currently traced by call-graph:
	 0x5555555548fa 	 insert_entry
	 0x5555555549e4 	 free_tree
	 0x555555554a25 	 create_tree
	 0x555555554a53 	 create_random_tree
	 0x555555554ade 	 main
	 0x7ffff7aef7c0 	 free_tree
(gdb) 
vshcmd: > call-graph update - exact 0x5555555549e4
(gdb) 
vshcmd: > info call-graph
Functions currently traced by call-graph:
	 insert_entry
	 create_tree
	 create_random_tree
	 main
	 free_tree
(gdb) 
vshcmd: > call-graph update + exact 0x5555555549e4
(gdb) 
vshcmd: > info call-graph
Functions currently traced by call-graph:
	 insert_entry
	 create_tree
	 create_random_tree
	 main
	 free_tree
	 free_tree
(gdb) 
vshcmd: > call-graph update - free_tree
(gdb) 
vshcmd: > info call-graph
Functions currently traced by call-graph:
	 insert_entry
	 create_tree
	 create_random_tree
	 main
(gdb) 
vshcmd: > set call-graph-dynlibs off
call-graph will not include dynamic libraries
(gdb) 
vshcmd: > call-graph update + free_tree
(gdb) 
vshcmd: > info call-graph
Functions currently traced by call-graph:
	 insert_entry
	 create_tree
	 create_random_tree
	 main
	 free_tree
(gdb) 
vshcmd: > info call-graph exact
Functions currently traced by call-graph:
	 0x5555555548fa 	 insert_entry
	 0x555555554a25 	 create_tree
	 0x555555554a53 	 create_random_tree
	 0x555555554ade 	 main
	 0x5555555549e4 	 free_tree
(gdb) 
vshcmd: > cont
Continuing.
     --> create_random_tree
         --> create_tree
         <-- create_tree+45
         --> insert_entry
         <-- insert_entry+233
         --> insert_entry
         <-- insert_entry+233
         --> insert_entry
         <-- insert_entry+233
         --> insert_entry
         <-- insert_entry+233
         --> insert_entry
         <-- insert_entry+233
         --> insert_entry
         <-- insert_entry+233
         --> insert_entry
         <-- insert_entry+233
         --> insert_entry
         <-- insert_entry+233
         --> insert_entry
         <-- insert_entry+233
         --> insert_entry
         <-- insert_entry+233
     <-- create_random_tree+138
     --> free_tree
         --> free_tree
             --> free_tree
                 --> free_tree
                 <-- free_tree+64
                 --> free_tree
                 <-- free_tree+64
             <-- free_tree+64
             --> free_tree
                 --> free_tree
                 <-- free_tree+64
                 --> free_tree
                 <-- free_tree+64
             <-- free_tree+64
         <-- free_tree+64
         --> free_tree
             --> free_tree
             <-- free_tree+64
             --> free_tree
                 --> free_tree
                     --> free_tree
                         --> free_tree
                         <-- free_tree+64
                         --> free_tree
                             --> free_tree
                             <-- free_tree+64
                             --> free_tree
                             <-- free_tree+64
                         <-- free_tree+64
                     <-- free_tree+64
                     --> free_tree
                     <-- free_tree+64
                 <-- free_tree+64
                 --> free_tree
                     --> free_tree
                         --> free_tree
                         <-- free_tree+64
                         --> free_tree
                         <-- free_tree+64
                     <-- free_tree+64
                     --> free_tree
                     <-- free_tree+64
                 <-- free_tree+64
             <-- free_tree+64
         <-- free_tree+64
     <-- free_tree+64
 <-- main+119
[Inferior 2 (process 24357) exited normally]
(gdb) 
vshcmd: > call-graph update + free_tree
Traceback (most recent call last):
  File "~/.config/gdb/commands.py", line 957, in invoke
    trace_matching_functions(args[1])
  File "~/.config/gdb/commands.py", line 750, in trace_matching_functions
    arch = gdb.current_arch()
  File "/home/matthew/.config/gdb/helpers.py", line 115, in cur_arch
    return gdb.selected_frame().architecture()
gdb.error: No frame is currently selected.
Error occurred in Python command: No frame is currently selected.
(gdb) 
vshcmd: > call-graph clear
(gdb) 
vshcmd: > info call-graph
Functions currently traced by call-graph:
(gdb) 
vshcmd: > inferior 2
[Switching to inferior 2 [<null>] (/home/matthew/.config/gdb/demos/tree)]
(gdb) 
vshcmd: > start
Temporary breakpoint 3 at 0xaae: main. (4 locations)
Starting program: /home/matthew/.config/gdb/demos/tree 10

Temporary breakpoint 3, 0x0000555555554ae2 in main ()
(gdb) 
vshcmd: > gdb-pipe called-functions main; .*; -1 | show whereis {.v}
main 		Unknown
create_random_tree 		Unknown
create_tree 		Unknown
insert_entry 		Unknown
free_tree 		Unknown
free_tree 		Unknown
(gdb) 
vshcmd: > gdb-pipe called-functions main; .*; -1 | if $_output_contains("global-used {.v} free_tree", "free_tree") | show hypothetical-stack
main 		Unknown

main 		Unknown
create_random_tree 		Unknown

main 		Unknown
create_random_tree 		Unknown
free_tree 		Unknown

main 		Unknown
free_tree 		Unknown

(gdb) 
vshcmd: > inferior 3
[Switching to inferior 3 [<null>] (/home/matthew/.config/gdb/demos/tree_debug)]
(gdb) 
vshcmd: > start
Temporary breakpoint 4 at 0xaae: main. (4 locations)
Starting program: /home/matthew/.config/gdb/demos/tree_debug 10

Thread 3.1 "tree_debug" hit Temporary breakpoint 4, main (argc=2, argv=0x7fffffffe558) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) 
vshcmd: > gdb-pipe called-functions main; .*; -1 | show whereis {.v}
main demos/tree.c:85
create_random_tree demos/tree.c:69
create_tree demos/tree.c:62
insert_entry demos/tree.c:23
free_tree demos/tree.c:53
free_tree demos/tree.c:53
(gdb) 
vshcmd: > gdb-pipe called-functions main; .*; -1 | if $_output_contains("global-used {.v} free_tree", "free_tree") | show hypothetical-stack
main demos/tree.c:85

main demos/tree.c:85
create_random_tree demos/tree.c:69

main demos/tree.c:85
create_random_tree demos/tree.c:69
free_tree demos/tree.c:53

main demos/tree.c:85
free_tree demos/tree.c:53

(gdb) 
vshcmd: > inferior 3
vshcmd: > gdb-pipe called-functions main; .*; -1; unique | show whereis {.v}
[Switching to inferior 3 [process 24373] (/home/matthew/.config/gdb/demos/tree_debug)]
[Switching to thread 3.1 (process 24373)]
#0  main (argc=2, argv=0x7fffffffe558) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) main demos/tree.c:85
create_random_tree demos/tree.c:69
create_tree demos/tree.c:62
insert_entry demos/tree.c:23
free_tree demos/tree.c:53
(gdb) 
vshcmd: > gdb-pipe called-functions main; .*; -1; unique | if $_output_contains("global-used {.v} free_tree", "free_tree") | show hypothetical-stack
main demos/tree.c:85

main demos/tree.c:85
create_random_tree demos/tree.c:69

main demos/tree.c:85
free_tree demos/tree.c:53

(gdb) 
vshcmd: > inferior 2
[Switching to inferior 2 [process 24365] (/home/matthew/.config/gdb/demos/tree)]
[Switching to thread 2.1 (process 24365)]
#0  0x0000555555554ae2 in main ()
(gdb) 
vshcmd: > gdb-pipe called-functions main; .*; -1; unique | show whereis {.v}
main 		Unknown
create_random_tree 		Unknown
create_tree 		Unknown
insert_entry 		Unknown
free_tree 		Unknown
(gdb) 
vshcmd: > gdb-pipe called-functions main; .*; -1; unique | if $_output_contains("global-used {.v} free_tree", "free_tree") | show hypothetical-stack
main 		Unknown

main 		Unknown
create_random_tree 		Unknown

main 		Unknown
free_tree 		Unknown

(gdb) 
vshcmd: > inferior 3
[Switching to inferior 3 [process 24373] (/home/matthew/.config/gdb/demos/tree_debug)]
[Switching to thread 3.1 (process 24373)]
#0  main (argc=2, argv=0x7fffffffe558) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) 
vshcmd: > cont
Continuing.
[Inferior 3 (process 24373) exited normally]
(gdb) 
vshcmd: > python import demos.tree_walker
(gdb) 
vshcmd: > tbreak tree.c:93
Temporary breakpoint 5 at 0x555555554b43: file demos/tree.c, line 93.
(gdb) 
vshcmd: > run 10
Starting program: /home/matthew/.config/gdb/demos/tree_debug 10

Thread 3.1 "tree_debug" hit Temporary breakpoint 5, main (argc=2, argv=0x7fffffffe558) at demos/tree.c:93
93	    free_tree(tree_root);
(gdb) 
vshcmd: > gdb-pipe tree-elements tree_root | if {}->children[0] == 0 && {}->children[1] == 0 | show printf "%d\n", {}->datum
1753820418
1255532675
679162307
131589623
(gdb) 
vshcmd: > gdb-pipe follow-until 1; {} > 10; {} + 1
0x1
0x2
0x3
0x4
0x5
0x6
0x7
0x8
0x9
0xa
(gdb) 
vshcmd: > gdb-pipe array char; 1; 10
0x1
0x2
0x3
0x4
0x5
0x6
0x7
0x8
0x9
0xa
(gdb) 
vshcmd: > gdb-pipe eval 1 | array char; {}; 10
0x1
0x2
0x3
0x4
0x5
0x6
0x7
0x8
0x9
0xa
(gdb) 
vshcmd: > gdb-pipe follow-until 1; {} > 100; {} + 1 | head 10
0x1
0x2
0x3
0x4
0x5
0x6
0x7
0x8
0x9
0xa
(gdb) 
vshcmd: > set variable $count = 0
vshcmd: > gdb-pipe follow-until 1; {} > 100; {} + 1 | if $count++ < 10
(gdb) 0x1
0x2
0x3
0x4
0x5
0x6
0x7
0x8
0x9
0xa
(gdb) 
vshcmd: > set variable $count = 0
vshcmd: > gdb-pipe follow-until 1; {} > 100; {} + 1 | take-while $count++ < 10
(gdb) 0x1
0x2
0x3
0x4
0x5
0x6
0x7
0x8
0x9
0xa
(gdb) 
vshcmd: > set variable $count = 0
vshcmd: > gdb-pipe array char; 1; 100 | take-while {.v} % 2 == 0 || $count++ < 5
(gdb) 0x1
0x2
0x3
0x4
0x5
0x6
0x7
0x8
0x9
0xa
(gdb) 
vshcmd: > set variable $count = 0
vshcmd: > gdb-pipe array char; 1; 100 | take-while (int){} % 2 == 0 || $count++ < 5
(gdb) 0x1
0x2
0x3
0x4
0x5
0x6
0x7
0x8
0x9
0xa
(gdb) 
vshcmd: > gdb-pipe follow-until 100; {} <= 0; {} - 1 | tail 10 | reverse
0x1
0x2
0x3
0x4
0x5
0x6
0x7
0x8
0x9
0xa
(gdb) 
vshcmd: > gdb-pipe follow-until 20; {} <= 0; {} - 1 | tail -10 | reverse 
0x1
0x2
0x3
0x4
0x5
0x6
0x7
0x8
0x9
0xa
(gdb) 
vshcmd: > gdb-pipe follow-until 100; {} <= 0; {} - 1 | skip-until {} == 10 | reverse
0x1
0x2
0x3
0x4
0x5
0x6
0x7
0x8
0x9
0xa
(gdb) 
vshcmd: > gdb-pipe follow-until 1; {} > 20; {} + 1 | head -10
0x1
0x2
0x3
0x4
0x5
0x6
0x7
0x8
0x9
0xa
(gdb) 
vshcmd: > shellpipe gdb-pipe array char; 1; 5 ! cat > addresses
vshcmd: > shellpipe gdb-pipe array char; 6; 5 ! cat >> addresses
vshcmd: > gdb-pipe file addresses
vshcmd: > !rm addresses
(gdb) (gdb) 0x1
0x2
0x3
0x4
0x5
0x6
0x7
0x8
0x9
0xa
(gdb) (gdb) 
vshcmd: > set variable $count = 0
vshcmd: > gdb-pipe follow-until 1; {} > 100; $count++, {} + 1 | head 0 | devnull
vshcmd: > print $count
(gdb) (gdb) $1 = 0
(gdb) 
vshcmd: > set variable $count = 0
vshcmd: > gdb-pipe follow-until 1; {} > 100; $count++, {} + 1 | head 10 | devnull
vshcmd: > print $count
(gdb) (gdb) $2 = 9
(gdb) 
vshcmd: > set variable $sum = 0
vshcmd: > gdb-pipe follow-until 1; {} > 100; {} + 1 | eval $sum += {}, {} | devnull
vshcmd: > print $sum
(gdb) (gdb) $3 = 5050
(gdb) 
vshcmd: > gdb-pipe eval 1 | show printf "%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d\n", {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
111111111111111111111
(gdb) 
vshcmd: > gdb-pipe follow-until 1; {} > 100 && {} != 99; {} + 1 | count
0x64
(gdb) 
vshcmd: > inferior 4
[Switching to inferior 4 [<null>] (/home/matthew/.config/gdb/demos/list)]
(gdb) 
vshcmd: > tbreak list.c:70
vshcmd: > run 10
Temporary breakpoint 6 at 0xb04: file demos/list.c, line 70.
(gdb) Starting program: /home/matthew/.config/gdb/demos/list 10

Thread 4.1 "list" hit Temporary breakpoint 6, main (argc=2, argv=0x7fffffffe578) at demos/list.c:70
70	    free_list(list_head);
(gdb) 
vshcmd: > gdb-pipe linked-list list_head; list_t; next | show printf "%d\n", {}->datum
679162307
54404747
906573271
1255532675
394002377
1753820418
385788725
1086128678
1311962008
1215069295
(gdb) 
vshcmd: > inferior 3
[Switching to inferior 3 [<null>] (/home/matthew/.config/gdb/demos/tree_debug)]
(gdb) 
vshcmd: > cont
Continuing.
[Inferior 3 (process 24384) exited normally]
(gdb) 
vshcmd: > start Hello there this is a set of arguments
Temporary breakpoint 1 at 0xaae: main. (4 locations)
Starting program: /home/matthew/.config/gdb/demos/tree_debug Hello there this is a set of arguments

Temporary breakpoint 1, main (argc=9, argv=0x7fffffffe4f8) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) 
vshcmd: > gdb-pipe follow-until argv + 1; *{} == 0; {} + 1 | max (*(char **){})[0] | show printf "%s\n", *{}
there
(gdb) 
vshcmd: > gdb-pipe follow-until argv + 1; *{} == 0; {} + 1 | min (*(char **){})[0] | show printf "%s\n", *{}
Hello
(gdb) 
vshcmd: > gdb-pipe follow-until argv + 1; *{} == 0; {} + 1 | sort (*(char **){})[0] | show printf "%s\n", *{}
Hello
a
arguments
is
of
set
there
this
(gdb) 
vshcmd: > gdb-pipe follow-until argv + 1; *{} == 0; {} + 1 | sort (*(char **){})[0] | dedup (*(char **){})[0] | show printf "%s\n", *{}
Hello
a
is
of
set
there
(gdb) 
vshcmd: > gdb-pipe array auto; argv; argc | array auto; *{}; 3 | show printf "%c", *{}
/hoHelthethiisassetofarg(gdb) 
vshcmd: > cont
Continuing.
Usage: /home/matthew/.config/gdb/demos/tree_debug <seed>
[Inferior 3 (process 24793) exited with code 01]
(gdb) 
vshcmd: > gdb-pipe defined-functions tree.c:.* | show whereis {.v}
create_tree demos/tree.c:62
free_tree demos/tree.c:53
insert_entry demos/tree.c:23
main demos/tree.c:85
create_random_tree demos/tree.c:69
(gdb) 
vshcmd: > gdb-pipe defined-functions .* | show whereis {.v}
create_tree demos/tree.c:62
free_tree demos/tree.c:53
insert_entry demos/tree.c:23
main demos/tree.c:85
create_random_tree demos/tree.c:69
(gdb) 
vshcmd: > cont
The program is not being run.
(gdb) 
vshcmd: > start 20 100 Hello there this is a test
Temporary breakpoint 2 at 0xaae: main. (4 locations)
Starting program: /home/matthew/.config/gdb/demos/tree_debug 20 100 Hello there this is a test

Temporary breakpoint 2, main (argc=9, argv=0x7fffffffe508) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) 
vshcmd: > set variable $i = -1
(gdb) 
vshcmd: > gdb-pipe array char*; argv; argc  | if $i++, $_output_contains("print *{}", "t") | show output $i
0458(gdb) 
vshcmd: > cont
Continuing.
Usage: /home/matthew/.config/gdb/demos/tree_debug <seed>
[Inferior 3 (process 24807) exited with code 01]
(gdb) 
vshcmd: > inferior 2
[Switching to inferior 2 [<null>] (/home/matthew/.config/gdb/demos/tree)]
(gdb) 
vshcmd: > cont
The program is not being run.
(gdb) 
vshcmd: > start 20 100 Hello there this is a test
Temporary breakpoint 3 at 0xaae: main. (4 locations)
Starting program: /home/matthew/.config/gdb/demos/tree 20 100 Hello there this is a test

Temporary breakpoint 3, 0x0000555555554ae2 in main ()
(gdb) 
vshcmd: > set variable $i = -1
(gdb) 
vshcmd: > gdb-pipe array char*; argv; argc  | if $i++, $_output_contains("print *{}", "t") | show output $i
error parsing  argc  and casting to uintptr_t
Traceback (most recent call last):
  File "/home/matthew/.config/gdb/walkers.py", line 332, in invoke
    pipeline_end = create_pipeline(arg)
  File "/home/matthew/.config/gdb/walkers.py", line 296, in create_pipeline
    walker_list = [create_walker(args[0], first=True, last=only_one)]
  File "/home/matthew/.config/gdb/walkers.py", line 264, in create_walker
    return walker.from_userstring(args if args else None, first, last)
  File "/home/matthew/.config/gdb/walker_defs.py", line 412, in from_userstring
    start_expr, count_expr, type_arg))
  File "/home/matthew/.config/gdb/walker_defs.py", line 394, in __first_noauto
    count, start_ele = __first(count_expr, start_expr)
  File "/home/matthew/.config/gdb/walker_defs.py", line 375, in __first
    return eval_uint(count_expr), cls.calc(start_expr)
  File "/home/matthew/.config/gdb/helpers.py", line 72, in eval_uint
    return int(gdb.parse_and_eval(gdb_expr).cast(__uintptr_t))
gdb.error: No symbol table is loaded.  Use the "file" command.
Error occurred in Python command: No symbol table is loaded.  Use the "file" command.
(gdb) 
vshcmd: > cont
Continuing.
Usage: /home/matthew/.config/gdb/demos/tree <seed>
[Inferior 2 (process 24815) exited with code 01]
(gdb) 
vshcmd: > if $_output_contains("echo \"Hello\"", "ell")
 >
vshcmd: > python print('Worked', 'nicely')
  >
vshcmd: > else
  >
vshcmd: > python print('FAIL', 'ED', sep='')
  >
vshcmd: > end
 >
vshcmd: > end
  File "<string>", line 1
    else
       ^
SyntaxError: invalid syntax
Error while executing Python code.
(gdb) 
vshcmd: > shellpipe disassemble main ! grep call
   0x0000555555554b10 <+50>:	callq  0x555555554790 <fprintf@plt>
   0x0000555555554b1a <+60>:	callq  0x5555555547b0 <exit@plt>
   0x0000555555554b2d <+79>:	callq  0x5555555547a0 <atoi@plt>
   0x0000555555554b3a <+92>:	callq  0x555555554a53 <create_random_tree>
   0x0000555555554b4a <+108>:	callq  0x5555555549e4 <free_tree>
(gdb) 
vshcmd: > inferior 2
[Switching to inferior 2 [<null>] (/home/matthew/.config/gdb/demos/tree)]
(gdb) 
vshcmd: > shellpipe disassemble main ! grep call
   0x0000555555554b10 <+50>:	callq  0x555555554790 <fprintf@plt>
   0x0000555555554b1a <+60>:	callq  0x5555555547b0 <exit@plt>
   0x0000555555554b2d <+79>:	callq  0x5555555547a0 <atoi@plt>
   0x0000555555554b3a <+92>:	callq  0x555555554a53 <create_random_tree>
   0x0000555555554b4a <+108>:	callq  0x5555555549e4 <free_tree>
(gdb) 
vshcmd: > # Inspecting the CPP structures
vshcmd: > inferior 5
vshcmd: > start 10
vshcmd: > break -function 'create_container<std::__cxx11::list<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > >' -label after_defined
vshcmd: > cont
vshcmd: > gdb-pipe std-list &rand_container | show print-string {}->_M_impl->_M_node->_M_data; "\n"
10
10
1283169405
89128932
2124247567
1902734705
2141071321
965494256
108111773
850673521
(gdb) 
vshcmd: > break -function 'create_container<std::vector<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > >' -label after_defined
vshcmd: > cont
vshcmd: > gdb-pipe std-vector &rand_container | show print-string *{}; "\n"
Breakpoint 3 at 0x401399: file demos/cpp_structures.cpp, line 25.
(gdb) Continuing.

Breakpoint 3, create_container<std::vector<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > > (start=10, end=33) at demos/cpp_structures.cpp:24
24	  container rand_container(start, end);
(gdb) 10
1283169405
89128932
2124247567
1902734705
2141071321
965494256
108111773
850673521
1140597833
(gdb) 
vshcmd: > break -function 'create_container<std::map<int, int, std::less<int>, std::allocator<std::pair<int const, int> > >, __gnu_cxx::__normal_iterator<std::pair<int, int>*, std::vector<std::pair<int, int>, std::allocator<std::pair<int, int> > > > >' -label after_defined
vshcmd: > cont
vshcmd: > gdb-pipe std-map &rand_container | show print-string *{}; "\n"
Breakpoint 4 at 0x4015aa: file demos/cpp_structures.cpp, line 25.
(gdb) Continuing.

Breakpoint 4, create_container<std::map<int, int, std::less<int>, std::allocator<std::pair<int const, int> > >, __gnu_cxx::__normal_iterator<std::pair<int, int>*, std::vector<std::pair<int, int>, std::allocator<std::pair<int, int> > > > > (start=..., end=...) at demos/cpp_structures.cpp:24
24	  container rand_container(start, end);
(gdb) {first = 0, second = 10}
{first = 1, second = 1283169405}
{first = 2, second = 89128932}
{first = 3, second = 2124247567}
{first = 4, second = 1902734705}
{first = 5, second = 2141071321}
{first = 6, second = 965494256}
{first = 7, second = 108111773}
{first = 8, second = 850673521}
{first = 9, second = 1140597833}
(gdb) 
vshcmd: > print rand_container
$3 = std::map with 10 elements = {[0] = 10, [1] = 1283169405, [2] = 89128932, [3] = 2124247567, [4] = 1902734705, [5] = 2141071321, [6] = 965494256, [7] = 108111773, [8] = 850673521, [9] = 1140597833}
(gdb) 
vshcmd: > set $tempvar = 0;
vshcmd: > gdb-pipe pretty-printers rand_container | show print-string *{}; "\n"
0
1283169405
1
89128932
2
2124247567
3
1902734705
4
2141071321
5
965494256
6
108111773
7
850673521
8
1140597833
(gdb) 
vshcmd: > quit
A debugging session is active.

	Inferior 5 [process 24853] will be killed.

Quit anyway? (y or n) 
vshcmd: > y
