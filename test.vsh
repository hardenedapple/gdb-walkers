vshcmd: > gdb
vshcmd: > add-inferior -exec demos/tree
vshcmd: > add-inferior -exec demos/tree_debug
vshcmd: > add-inferior -exec demos/list
vshcmd: > add-inferior -exec demos/cpp_structures
vshcmd: > inferior 3
(gdb) Added inferior 2
Reading symbols from demos/tree...(no debugging symbols found)...done.
(gdb) Added inferior 3
Reading symbols from demos/tree_debug...done.
(gdb) Added inferior 4
Reading symbols from demos/list...done.
(gdb) Added inferior 5
Reading symbols from demos/cpp_structures...done.
(gdb) [Switching to inferior 3 [<null>] (/home/matthew/share/repos/gdb-config/demos/tree_debug)]
(gdb) 
vshcmd: > # BELOW IS ORIGINAL
vshcmd: > start 10
Temporary breakpoint 1 at 0xaae: main. (3 locations)
Starting program: /home/matthew/share/repos/gdb-config/demos/tree_debug 10

Temporary breakpoint 1, main (argc=2, argv=0x7fffffffe4c8) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) 
vshcmd: > call-graph init .*
(gdb) 
vshcmd: > info call-graph
Functions currently traced by call-graph:
	 create_tree
	 free_tree
	 insert_entry
	 main
	 create_random_tree
(gdb) 
vshcmd: > info call-graph exact
Functions currently traced by call-graph:
	 0x555555554a25 	 create_tree
	 0x5555555549e4 	 free_tree
	 0x5555555548fa 	 insert_entry
	 0x555555554ade 	 main
	 0x555555554a53 	 create_random_tree
(gdb) 
vshcmd: > call-graph update - free_tree
(gdb) 
vshcmd: > info call-graph
Functions currently traced by call-graph:
	 create_tree
	 insert_entry
	 main
	 create_random_tree
(gdb) 
vshcmd: > call-graph update + free_tree
(gdb) 
vshcmd: > info call-graph
Functions currently traced by call-graph:
	 create_tree
	 insert_entry
	 main
	 create_random_tree
	 free_tree
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
[Inferior 3 (process 18022) exited normally]
(gdb) 
vshcmd: > set call-graph-enabled off
vshcmd: > run
call-graph tracing is disabled
(gdb) Starting program: /home/matthew/share/repos/gdb-config/demos/tree_debug 10
[Inferior 3 (process 18033) exited normally]
(gdb) 
vshcmd: > set call-graph-enabled on
call-graph tracing is enabled
(gdb) 
vshcmd: > set call-graph-output test.txt
vshcmd: > run
call-graph trace output directed to test.txt
(gdb) Starting program: /home/matthew/share/repos/gdb-config/demos/tree_debug 10
[Inferior 3 (process 18044) exited normally]
(gdb) 
vshcmd: > set call-graph-output stdout
call-graph trace output directed to stdout
(gdb) 
vshcmd: > !cat test.txt
 --> main
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
 --> main
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
 --> main
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
(gdb) 
vshcmd: > call-graph update + free_tree
Traceback (most recent call last):
  File "~/.config/gdb/commands.py", line 951, in invoke
    trace_matching_functions(args[1])
  File "~/.config/gdb/commands.py", line 748, in trace_matching_functions
    arch = gdb.current_arch()
  File "/home/matthew/.config/gdb/helpers.py", line 99, in cur_arch
    return gdb.selected_frame().architecture()
gdb.error: No frame is currently selected.
Error occurred in Python command: No frame is currently selected.
(gdb) quit
gdb-config [11:13:07] $ 
vshcmd: > !cat test.txt
(gdb) quit
gdb-config [10:43:10] $ 
vshcmd: > call-graph clear
(gdb) 
vshcmd: > info call-graph
Functions currently traced by call-graph:
(gdb) 
vshcmd: > inferior 2
[Switching to inferior 2 [<null>] (/home/matthew/share/repos/gdb-config/demos/tree)]
(gdb) 
vshcmd: > start 10
Temporary breakpoint 2 at 0xaae: main. (3 locations)
Starting program: /home/matthew/share/repos/gdb-config/demos/tree 10

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
	 0x7f478286e650 	 free_tree
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
[Inferior 2 (process 18458) exited normally]
(gdb) 
vshcmd: > call-graph update + free_tree
Traceback (most recent call last):
  File "~/.config/gdb/commands.py", line 951, in invoke
    trace_matching_functions(args[1])
  File "~/.config/gdb/commands.py", line 748, in trace_matching_functions
    arch = gdb.current_arch()
  File "/home/matthew/.config/gdb/helpers.py", line 96, in cur_arch
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
[Switching to inferior 2 [<null>] (/home/matthew/share/repos/gdb-config/demos/tree)]
(gdb) 
vshcmd: > start
Temporary breakpoint 1 at 0xaae: main. (3 locations)
Starting program: /home/matthew/share/repos/gdb-config/demos/tree 

Temporary breakpoint 1, 0x0000555555554ae2 in main ()
(gdb) 
vshcmd: > pipe called-functions main; .*; -1 | show whereis {.v}
main 		Unknown
create_random_tree 		Unknown
create_tree 		Unknown
insert_entry 		Unknown
free_tree 		Unknown
free_tree 		Unknown
(gdb) 
vshcmd: > pipe called-functions main; .*; -1 | if $_output_contains("global-used {.v} free_tree", "free_tree") | show hypothetical-stack
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
[Switching to inferior 3 [<null>] (/home/matthew/share/repos/gdb-config/demos/tree_debug)]
(gdb) 
vshcmd: > start
Temporary breakpoint 2 at 0xaae: main. (3 locations)
Starting program: /home/matthew/share/repos/gdb-config/demos/tree_debug 

Thread 3.1 "tree_debug" hit Temporary breakpoint 2, main (argc=1, argv=0x7fffffffe4c8) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) 
vshcmd: > pipe called-functions main; .*; -1 | show whereis {.v}
main demos/tree.c:85
create_random_tree demos/tree.c:69
create_tree demos/tree.c:62
insert_entry demos/tree.c:23
free_tree demos/tree.c:53
free_tree demos/tree.c:53
(gdb) 
vshcmd: > pipe called-functions main; .*; -1 | if $_output_contains("global-used {.v} free_tree", "free_tree") | show hypothetical-stack
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
[Switching to inferior 3 [process 16641] (/home/matthew/share/repos/gdb-config/demos/tree_debug)]
[Switching to thread 3.1 (process 16641)]
#0  main (argc=1, argv=0x7fffffffe4c8) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) 
vshcmd: > cont
Continuing.
Usage: /home/matthew/share/repos/gdb-config/demos/tree_debug <seed>
[Inferior 3 (process 16641) exited with code 01]
(gdb) 
vshcmd: > python import demos.tree_walker
(gdb) 
vshcmd: > tbreak tree.c:93
Temporary breakpoint 3 at 0x555555554b43: file demos/tree.c, line 93.
(gdb) 
vshcmd: > run 10
Starting program: /home/matthew/share/repos/gdb-config/demos/tree_debug 10

Thread 3.1 "tree_debug" hit Temporary breakpoint 3, main (argc=2, argv=0x7fffffffe4c8) at demos/tree.c:93
93	    free_tree(tree_root);
(gdb) 
vshcmd: > pipe tree-elements tree_root | if {}->children[0] == 0 && {}->children[1] == 0 | show printf "%d\n", {}->datum
1753820418
1255532675
679162307
131589623
(gdb) 
vshcmd: > pipe follow-until 1; {} > 10; {} + 1
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
vshcmd: > pipe array char; 1; 10
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
vshcmd: > pipe eval 1 | array char; {}; 10
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
vshcmd: > pipe follow-until 1; {} > 100; {} + 1 | head 10
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
vshcmd: > pipe follow-until 1; {} > 100; {} + 1 | if $count++ < 10
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
vshcmd: > pipe follow-until 1; {} > 100; {} + 1 | take-while $count++ < 10
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
vshcmd: > pipe array char; 1; 100 | take-while {.v} % 2 == 0 || $count++ < 5
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
vshcmd: > pipe array char; 1; 100 | take-while (int){} % 2 == 0 || $count++ < 5
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
vshcmd: > pipe follow-until 100; {} <= 0; {} - 1 | tail 10 | reverse
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
vshcmd: > pipe follow-until 20; {} <= 0; {} - 1 | tail -10 | reverse 
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
vshcmd: > pipe follow-until 100; {} <= 0; {} - 1 | skip-until {} == 10 | reverse
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
vshcmd: > pipe follow-until 1; {} > 20; {} + 1 | head -10
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
vshcmd: > shellpipe pipe array char; 1; 5 ! cat > addresses
vshcmd: > shellpipe pipe array char; 6; 5 ! cat >> addresses
vshcmd: > pipe file addresses
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
vshcmd: > pipe follow-until 1; {} > 100; $count++, {} + 1 | head 0 | devnull
vshcmd: > print $count
(gdb) (gdb) $1 = 0
(gdb) 
vshcmd: > set variable $count = 0
vshcmd: > pipe follow-until 1; {} > 100; $count++, {} + 1 | head 10 | devnull
vshcmd: > print $count
(gdb) (gdb) $2 = 9
(gdb) 
vshcmd: > set variable $sum = 0
vshcmd: > pipe follow-until 1; {} > 100; {} + 1 | eval $sum += {}, {} | devnull
vshcmd: > print $sum
(gdb) (gdb) $3 = 5050
(gdb) 
vshcmd: > pipe eval 1 | show printf "%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d\n", {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
111111111111111111111
(gdb) 
vshcmd: > pipe follow-until 1; {} > 100 && {} != 99; {} + 1 | count
0x64
(gdb) 
vshcmd: > inferior 4
[Switching to inferior 4 [<null>] (/home/matthew/share/repos/gdb-config/demos/list)]
(gdb) 
vshcmd: > tbreak list.c:70
vshcmd: > run 10
Temporary breakpoint 4 at 0xb04: file demos/list.c, line 70.
(gdb) Starting program: /home/matthew/share/repos/gdb-config/demos/list 10

Thread 4.1 "list" hit Temporary breakpoint 4, main (argc=2, argv=0x7fffffffe4d8) at demos/list.c:70
70	    free_list(list_head);
(gdb) 
vshcmd: > pipe linked-list list_head; list_t; next | show printf "%d\n", {}->datum
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
[Switching to inferior 3 [<null>] (/home/matthew/share/repos/gdb-config/demos/tree_debug)]
(gdb) 
vshcmd: > cont
The program is not being run.
(gdb) 
vshcmd: > start Hello there this is a set of arguments
Temporary breakpoint 1 at 0xaae: main. (3 locations)
Starting program: /home/matthew/share/repos/gdb-config/demos/tree_debug Hello there this is a set of arguments

Temporary breakpoint 1, main (argc=9, argv=0x7fffffffe468) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) 
vshcmd: > pipe follow-until argv + 1; *{} == 0; {} + 1 | max (*(char **){})[0] | show printf "%s\n", *{}
there
(gdb) 
vshcmd: > pipe follow-until argv + 1; *{} == 0; {} + 1 | min (*(char **){})[0] | show printf "%s\n", *{}
Hello
(gdb) 
vshcmd: > pipe follow-until argv + 1; *{} == 0; {} + 1 | sort (*(char **){})[0] | show printf "%s\n", *{}
Hello
a
arguments
is
of
set
there
this
(gdb) 
vshcmd: > pipe follow-until argv + 1; *{} == 0; {} + 1 | sort (*(char **){})[0] | dedup (*(char **){})[0] | show printf "%s\n", *{}
Hello
a
is
of
set
there
(gdb) 
vshcmd: > pipe array auto; argv; argc | array auto; *{}; 3 | show printf "%c", *{}
/hoHelthethiisassetofarg(gdb) 
vshcmd: > cont
Continuing.
Usage: /home/matthew/share/repos/gdb-config/demos/tree_debug <seed>
[Inferior 3 (process 8762) exited with code 01]
(gdb) 
vshcmd: > pipe defined-functions tree.c:.* | show whereis {.v}
create_tree demos/tree.c:62
free_tree demos/tree.c:53
insert_entry demos/tree.c:23
main demos/tree.c:85
create_random_tree demos/tree.c:69
(gdb) 
vshcmd: > cont
Continuing.
Usage: /home/matthew/share/repos/gdb-config/demos/tree_debug <seed>
[Inferior 3 (process 2363) exited with code 01]
(gdb) 
vshcmd: > start 20 100 Hello there this is a test
Temporary breakpoint 1 at 0xaae: main. (3 locations)
Starting program: /home/matthew/share/repos/gdb-config/demos/tree_debug 20 100 Hello there this is a test

Temporary breakpoint 1, main (argc=9, argv=0x7fffffffe468) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) 
vshcmd: > set variable $i = -1
(gdb) 
vshcmd: > pipe array char*; argv; argc  | if $i++, $_output_contains("print *{}", "t") | show output $i
0458(gdb) 
vshcmd: > cont
Continuing.
Usage: /home/matthew/share/repos/gdb-config/demos/tree_debug <seed>
[Inferior 3 (process 19621) exited with code 01]
(gdb) 
vshcmd: > inferior 2
[Switching to inferior 2 [<null>] (/home/matthew/share/repos/gdb-config/demos/tree)]
(gdb) 
vshcmd: > start 20 100 Hello there this is a test
Temporary breakpoint 4 at 0xae2 (4 locations)
Starting program: /home/matthew/share/repos/gdb-config/demos/tree 20 100 Hello there this is a test

Thread 2.1 "tree" hit Temporary breakpoint 4, 0x0000555555554ae2 in main ()
(gdb) 
vshcmd: > set variable $i = -1
(gdb) 
vshcmd: > pipe array char*; argv; argc  | if $i++, $_output_contains("print *{}", "t") | show output $i
error parsing  argc  and casting to uintptr_t
Traceback (most recent call last):
  File "/home/matthew/.config/gdb/walkers.py", line 328, in invoke
    pipeline_end = create_pipeline(arg)
  File "/home/matthew/.config/gdb/walkers.py", line 292, in create_pipeline
    walker_list = [create_walker(args[0], first=True, last=only_one)]
  File "/home/matthew/.config/gdb/walkers.py", line 260, in create_walker
    return walker.from_userstring(args if args else None, first, last)
  File "/home/matthew/.config/gdb/walker_defs.py", line 413, in from_userstring
    start_expr, count_expr, type_arg))
  File "/home/matthew/.config/gdb/walker_defs.py", line 395, in __first_noauto
    count, start_ele = __first(count_expr, start_expr)
  File "/home/matthew/.config/gdb/walker_defs.py", line 372, in __first
    return eval_uint(count_expr), cls.calc(start_expr)
  File "/home/matthew/.config/gdb/helpers.py", line 53, in eval_uint
    return int(gdb.parse_and_eval(gdb_expr).cast(__uintptr_t))
gdb.error: No symbol table is loaded.  Use the "file" command.
Error occurred in Python command: No symbol table is loaded.  Use the "file" command.
(gdb) 
vshcmd: > cont
Continuing.
Usage: /home/matthew/share/repos/gdb-config/demos/tree <seed>
[Inferior 2 (process 2756) exited with code 01]
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
   0x0000000000000b10 <+50>:	callq  0x790 <fprintf@plt>
   0x0000000000000b1a <+60>:	callq  0x7b0 <exit@plt>
   0x0000000000000b2d <+79>:	callq  0x7a0 <atoi@plt>
   0x0000000000000b3a <+92>:	callq  0xa53 <create_random_tree>
   0x0000000000000b4a <+108>:	callq  0x9e4 <free_tree>
(gdb) 
vshcmd: > inferior 2
[Switching to inferior 2 [<null>] (/home/matthew/share/repos/gdb-config/demos/tree)]
(gdb) 
vshcmd: > shellpipe disassemble main ! grep call
   0x0000000000000b10 <+50>:	callq  0x790 <fprintf@plt>
   0x0000000000000b1a <+60>:	callq  0x7b0 <exit@plt>
   0x0000000000000b2d <+79>:	callq  0x7a0 <atoi@plt>
   0x0000000000000b3a <+92>:	callq  0xa53 <create_random_tree>
   0x0000000000000b4a <+108>:	callq  0x9e4 <free_tree>
(gdb) 
vshcmd: > # Inspecting the CPP structures
vshcmd: > inferior 5
vshcmd: > start 10
vshcmd: > break -function 'create_container<std::__cxx11::list<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > >' -label after_defined
vshcmd: > cont
vshcmd: > pipe std-list &rand_container | show print-string {}->front(); "\n"
[Switching to inferior 5 [<null>] (/home/matthew/share/repos/gdb-config/demos/cpp_structures)]
(gdb) Temporary breakpoint 1 at 0xaae: main. (4 locations)
Starting program: /home/matthew/share/repos/gdb-config/demos/cpp_structures 10

Temporary breakpoint 1, main (argc=2, argv=0x7fffffffe4b8) at demos/cpp_structures.cpp:30
30	{
(gdb) Breakpoint 2 at 0x555555555dd0: file demos/cpp_structures.cpp, line 25.
(gdb) Continuing.

Breakpoint 2, create_container<std::__cxx11::list<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > > (start=1283169405, end=0) at demos/cpp_structures.cpp:24
24	  container rand_container(start, end);
(gdb) 1283169405
89128932
2124247567
1902734705
2141071321
965494256
108111773
850673521
1140597833
726325504
(gdb) 
vshcmd: > break -function 'create_container<std::vector<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > >' -label after_defined
vshcmd: > cont
vshcmd: > pipe std-vector &rand_container | show print-string *{}; "\n"
Breakpoint 3 at 0x555555555e65: file demos/cpp_structures.cpp, line 25.
(gdb) Continuing.

Breakpoint 3, create_container<std::vector<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > > (start=1283169405, end=0) at demos/cpp_structures.cpp:24
24	  container rand_container(start, end);
(gdb) 1283169405
89128932
2124247567
1902734705
2141071321
965494256
108111773
850673521
1140597833
726325504
(gdb) 
vshcmd: > cont
Continuing.
[Inferior 5 (process 5758) exited normally]
vshcmd: > # Working on map walker
vshcmd: > inferior 5
vshcmd: > break -function 'create_container<std::map<int, int, std::less<int>, std::allocator<std::pair<int const, int> > >, __gnu_cxx::__normal_iterator<std::pair<int, int>*, std::vector<std::pair<int, int>, std::allocator<std::pair<int, int> > > > >' -label after_defined
vshcmd: > run 10
Starting program: /home/matthew/share/repos/gdb-config/demos/cpp_structures 10

Breakpoint 1, create_container<std::map<int, int, std::less<int>, std::allocator<std::pair<int const, int> > >, __gnu_cxx::__normal_iterator<std::pair<int, int>*, std::vector<std::pair<int, int>, std::allocator<std::pair<int, int> > > > > (start={first = 0, second = 1283169405}, end={first = 0, second = 0}) at demos/cpp_structures.cpp:24
warning: Source file is more recent than executable.
24	  container rand_container(start, end);
(gdb) 
vshcmd: > disable pretty-printer
154 printers disabled
0 of 155 printers enabled
(gdb) 
vshcmd: > help ptype
Print definition of type TYPE.
Usage: ptype[/FLAGS] TYPE | EXPRESSION
Argument may be any type (for example a type name defined by typedef,
or "struct STRUCT-TAG" or "class CLASS-NAME" or "union UNION-TAG"
or "enum ENUM-TAG") or an expression.
The selected stack frame's lexical context is used to look up the name.
Contrary to "whatis", "ptype" always unrolls any typedefs.

Available FLAGS are:
  /r    print in "raw" form; do not substitute typedefs
  /m    do not print methods defined in a class
  /M    print methods defined in a class
  /t    do not print typedefs defined in a class
  /T    print typedefs defined in a class
(gdb) 
vshcmd: > ptype rand_container
type = std::map<int, int>
(gdb) 
vshcmd: > ptype &rand_container
type = class std::map<int, int> [with _Key = int, _Tp = int, _Compare = std::less<int>, _Alloc = std::allocator<std::pair<int const, int> >] {
  private:
    _Rep_type _M_t;

  public:
    map(void);
    map(const _Compare &, const _Alloc &);
    map(const std::map<int, int> &);
    map(std::map<int, int> &&);
    map(std::initializer_list<value_type>, const _Compare &, const _Alloc &);
    map(const _Alloc &);
    map(const std::map<int, int> &, const _Alloc &);
    map(std::map<int, int> &&, const _Alloc &);
    map(std::initializer_list<value_type>, const _Alloc &);
    ~map();
    std::map<int, int> & operator=(const std::map<int, int> &);
    std::map<int, int> & operator=(std::map<int, int> &&);
    std::map<int, int> & operator=(std::initializer_list<value_type>);
    _Alloc get_allocator(void) const;
    iterator begin(void);
    const_iterator begin(void) const;
    iterator end(void);
    const_iterator end(void) const;
    reverse_iterator rbegin(void);
    const_reverse_iterator rbegin(void) const;
    reverse_iterator rend(void);
    const_reverse_iterator rend(void) const;
    const_iterator cbegin(void) const;
    const_iterator cend(void) const;
    const_reverse_iterator crbegin(void) const;
    const_reverse_iterator crend(void) const;
    bool empty(void) const;
    size_type size(void) const;
    size_type max_size(void) const;
    _Key & operator[](const _Key &);
    _Key & operator[](_Key &&);
    _Key & at(const _Key &);
    const _Key & at(const _Key &) const;
    std::pair<iterator, bool> insert(const value_type &);
    void insert(std::initializer_list<value_type>);
    iterator insert(const_iterator, const value_type &);
    iterator erase(const_iterator);
    iterator erase(iterator);
    size_type erase(const _Key &);
    iterator erase(const_iterator, const_iterator);
    void swap(std::map<int, int> &);
    void clear(void);
    _Compare key_comp(void) const;
    std::map<_Key, _Key, _Compare, std::allocator<value_type> >::value_compare value_comp(void) const;
    iterator find(const _Key &);
    const_iterator find(const _Key &) const;
    size_type count(const _Key &) const;
    iterator lower_bound(const _Key &);
    const_iterator lower_bound(const _Key &) const;
    iterator upper_bound(const _Key &);
    const_iterator upper_bound(const _Key &) const;
    std::pair<iterator, iterator> equal_range(const _Key &);
    std::pair<const_iterator, const_iterator> equal_range(const _Key &) const;
    void map<__gnu_cxx::__normal_iterator<std::pair<int, int>*, std::vector<std::pair<int, int> > > >(__gnu_cxx::__normal_iterator<std::pair<_Key, _Key>*, std::vector<std::pair<int, int>> >, __gnu_cxx::__normal_iterator<std::pair<_Key, _Key>*, std::vector<std::pair<int, int>> >);

    typedef std::_Rb_tree<_Key, std::pair<_Key const, _Key>, std::_Select1st<std::pair<_Key const, _Key> >, _Compare, std::allocator<std::pair<_Key const, _Key> > > _Rep_type;
    typedef _Key key_type;
    typedef _Key mapped_type;
    typedef std::pair<_Key const, _Key> value_type;
    typedef _Compare key_compare;
    typedef _Alloc allocator_type;
    typedef std::_Rb_tree<_Key, std::pair<_Key const, _Key>, std::_Select1st<std::pair<_Key const, _Key> >, _Compare, std::allocator<std::pair<_Key const, _Key> > >::iterator iterator;
    typedef std::_Rb_tree<_Key, std::pair<_Key const, _Key>, std::_Select1st<std::pair<_Key const, _Key> >, _Compare, std::allocator<std::pair<_Key const, _Key> > >::const_iterator const_iterator;
    typedef std::_Rb_tree<_Key, std::pair<_Key const, _Key>, std::_Select1st<std::pair<_Key const, _Key> >, _Compare, std::allocator<std::pair<_Key const, _Key> > >::size_type size_type;
    typedef std::_Rb_tree<_Key, std::pair<_Key const, _Key>, std::_Select1st<std::pair<_Key const, _Key> >, _Compare, std::allocator<std::pair<_Key const, _Key> > >::reverse_iterator reverse_iterator;
    typedef std::_Rb_tree<_Key, std::pair<_Key const, _Key>, std::_Select1st<std::pair<_Key const, _Key> >, _Compare, std::allocator<std::pair<_Key const, _Key> > >::const_reverse_iterator const_reverse_iterator;
} *
(gdb) 
vshcmd: > ptype 
No symbol "typename" in current context.
(gdb) 
vshcmd: > print rand_container
$1 = {_M_t = {_M_impl = {<std::allocator<std::_Rb_tree_node<std::pair<int const,
 int> > >> = {<__gnu_cxx::new_allocator<std::_Rb_tree_node<std::pair<int const,
 int> > >> = {<No data fields>},
 <No data fields>},
 <std::_Rb_tree_key_compare<std::less<int> >> = {_M_key_compare = {<std::binary_function<int,
 int,
 bool>> = {<No data fields>},
 <No data fields>}},
 <std::_Rb_tree_header> = {_M_header = {_M_color = std::_S_red,
 _M_parent = 0x555555771150,
 _M_left = 0x555555770e90,
 _M_right = 0x555555771270},
 _M_node_count = 10},
 <No data fields>}}}
(gdb) 
vshcmd: > ptype rand_container._M_t._M_impl._M_header
type = struct std::_Rb_tree_node_base {
    std::_Rb_tree_color _M_color;
    _Base_ptr _M_parent;
    _Base_ptr _M_left;
    _Base_ptr _M_right;
  public:
    static _Base_ptr _S_minimum(_Base_ptr);
    static _Base_ptr _S_minimum(_Base_ptr);
    static _Base_ptr _S_maximum(_Base_ptr);
    static _Base_ptr _S_maximum(_Base_ptr);

    typedef std::_Rb_tree_node_base *_Base_ptr;
    typedef const std::_Rb_tree_node_base *_Const_Base_ptr;
}
(gdb) 
vshcmd: > print (void*)&rand_container._M_t._M_impl._M_node_count - (void*)&rand_container._M_t._M_impl._M_header
$3 = 32
(gdb) 
vshcmd: > print *(int*)((void*)rand_container._M_t._M_impl._M_header._M_parent + 32)
$4 = 3
(gdb) 
vshcmd: > print rand_container
$17 = {_M_t = {_M_impl = {<std::allocator<std::_Rb_tree_node<std::pair<int const,
 int> > >> = {<__gnu_cxx::new_allocator<std::_Rb_tree_node<std::pair<int const,
 int> > >> = {<No data fields>},
 <No data fields>},
 <std::_Rb_tree_key_compare<std::less<int> >> = {_M_key_compare = {<std::binary_function<int,
 int,
 bool>> = {<No data fields>},
 <No data fields>}},
 <std::_Rb_tree_header> = {_M_header = {_M_color = std::_S_red,
 _M_parent = 0x555555771150,
 _M_left = 0x555555770e90,
 _M_right = 0x555555771270},
 _M_node_count = 10},
 <No data fields>}}}
(gdb) 
vshcmd: > print *rand_container._M_t._M_impl._M_header._M_parent
vshcmd: > print *(int*)((void*)rand_container._M_t._M_impl._M_header._M_parent + 32)
vshcmd: > print *(int*)((void*)rand_container._M_t._M_impl._M_header._M_parent + 36)

vshcmd: > print *rand_container._M_t._M_impl._M_header._M_parent
vshcmd: > print *(int*)((void*)rand_container._M_t._M_impl._M_header._M_parent + 32)
vshcmd: > print *(int*)((void*)rand_container._M_t._M_impl._M_header._M_parent + 36)
$21 = {_M_color = std::_S_black, _M_parent = 0x7fffffffbba8, _M_left = 0x5555557710f0, _M_right = 0x5555557711b0}
(gdb) $22 = 3
(gdb) $23 = 1902734705
(gdb) 
vshcmd: > print *rand_container._M_t._M_impl._M_header._M_left
vshcmd: > print *(int*)((void*)rand_container._M_t._M_impl._M_header._M_left + 32)
vshcmd: > print *(int*)((void*)rand_container._M_t._M_impl._M_header._M_left + 36)
$28 = {_M_color = std::_S_black, _M_parent = 0x5555557710f0, _M_left = 0x0, _M_right = 0x0}
(gdb) $29 = 0
(gdb) $30 = 1283169405
(gdb) quit
A debugging session is active.

	Inferior 5 [process 5014] will be killed.

Quit anyway? (y or n) 
vshcmd: > y
gdb-config [17:47:06] $ 
vshcmd: > print *rand_container._M_t._M_impl._M_header._M_right
vshcmd: > print *(int*)((void*)rand_container._M_t._M_impl._M_header._M_right + 32)
vshcmd: > print *(int*)((void*)rand_container._M_t._M_impl._M_header._M_right + 36)
$25 = {_M_color = std::_S_red, _M_parent = 0x555555771240, _M_left = 0x0, _M_right = 0x0}
(gdb) $26 = 9
(gdb) $27 = 726325504
(gdb) 
vshcmd: > print rand_container
$8 = {_M_t = {_M_impl = {<std::allocator<std::_Rb_tree_node<std::pair<int const,
 int> > >> = {<__gnu_cxx::new_allocator<std::_Rb_tree_node<std::pair<int const,
 int> > >> = {<No data fields>},
 <No data fields>},
 <std::_Rb_tree_key_compare<std::less<int> >> = {_M_key_compare = {<std::binary_function<int,
 int,
 bool>> = {<No data fields>},
 <No data fields>}},
 <std::_Rb_tree_header> = {
    _M_header = {
        _M_color = std::_S_red,
        _M_parent = 0x555555771150,
        _M_left = 0x555555770e90,
        _M_right = 0x555555771270
        },
    _M_node_count = 10},
 <No data fields>}}}
(gdb) 
vshcmd: > ptype std::
type = int
(gdb) 
vshcmd: > ptype rand_container._M_t._M_impl._M_header
type = struct std::_Rb_tree_node_base {
    std::_Rb_tree_color _M_color;
    _Base_ptr _M_parent;
    _Base_ptr _M_left;
    _Base_ptr _M_right;
  public:
    static _Base_ptr _S_minimum(_Base_ptr);
    static _Base_ptr _S_minimum(_Base_ptr);
    static _Base_ptr _S_maximum(_Base_ptr);
    static _Base_ptr _S_maximum(_Base_ptr);

    typedef std::_Rb_tree_node_base *_Base_ptr;
    typedef const std::_Rb_tree_node_base *_Const_Base_ptr;
}
(gdb) 
vshcmd: > ptype rand_container._M_t._M_impl
type = struct std::_Rb_tree<int, std::pair<int const, int>, std::_Select1st<std::pair<int const, int> >, std::less<int>, std::allocator<std::pair<int const, int> > >::_Rb_tree_impl<std::less<int>, true> [with _Key_compare = std::less<int>] : public std::allocator<std::_Rb_tree_node<std::pair<int const, int> > >, public std::_Rb_tree_key_compare<_Key_compare>, public std::_Rb_tree_header {
  public:
    _Rb_tree_impl(void);
    _Rb_tree_impl(std::_Rb_tree<int, std::pair<int const, int>, std::_Select1st<std::pair<int const, int> >, _Key_compare, std::allocator<std::pair<int const, int> > >::_Rb_tree_impl<_Key_compare, true> &&);
    _Rb_tree_impl(const std::_Rb_tree<int, std::pair<int const, int>, std::_Select1st<std::pair<int const, int> >, _Key_compare, std::allocator<std::pair<int const, int> > >::_Rb_tree_impl<_Key_compare, true> &);
    _Rb_tree_impl(const _Key_compare &, std::_Rb_tree<int, std::pair<int const, int>, std::_Select1st<std::pair<int const, int> >, _Key_compare, std::allocator<std::pair<int const, int> > >::_Node_allocator &&);
}
(gdb) 
vshcmd: > print *(int*)((void*)rand_container._M_t._M_impl._M_header._M_left + 32)

(gdb) quit
gdb-config [09:44:32] $ >>> 
(gdb) quit
gdb-config [09:45:42] $ 
