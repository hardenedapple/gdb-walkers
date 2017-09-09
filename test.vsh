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
[Inferior 2 (process 2126) exited normally]
(gdb) 
vshcmd: > call-graph update + free_tree
Traceback (most recent call last):
  File "~/.config/gdb/commands.py", line 852, in invoke
    trace_matching_functions(args[1])
  File "~/.config/gdb/commands.py", line 649, in trace_matching_functions
    arch = gdb.current_arch()
  File "/home/matthew/.config/gdb/helpers.py", line 99, in cur_arch
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
vshcmd: > 
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
(gdb) (gdb) 
vshcmd: > set variable $count = 0
vshcmd: > pipe array char; 1; 100 | take-while {.v} % 2 == 0 || $count++ < 5
vshcmd: > 
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
(gdb) (gdb) 
vshcmd: > set variable $count = 0
vshcmd: > pipe array char; 1; 100 | take-while (int){} % 2 == 0 || $count++ < 5
vshcmd: > 
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
(gdb) (gdb) 
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
vshcmd: > shellpipe pipe array char; 1; 5 ! cat > addresses
vshcmd: > shellpipe pipe array char; 6; 5 ! cat >> addresses
vshcmd: > pipe file addresses
vshcmd: > !rm addresses
vshcmd: > 
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
(gdb) (gdb) rm: cannot remove 'addresses': No such file or directory
(gdb) 
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
[Inferior 3 (process 2743) exited with code 01]
(gdb) 
vshcmd: > inferior 2
[Switching to inferior 2 [<null>] (/home/matthew/share/repos/gdb-config/demos/tree)]
(gdb) 
vshcmd: > start 20 100 Hello there this is a test
Temporary breakpoint 2 at 0xaae: main. (3 locations)
Starting program: /home/matthew/share/repos/gdb-config/demos/tree 20 100 Hello there this is a test

Temporary breakpoint 2, 0x0000555555554ae2 in main ()
(gdb) 
vshcmd: > set variable $i = -1
(gdb) 
vshcmd: > pipe array char*; argv; argc  | if $i++, $_output_contains("print *{}", "t") | show output $i
error parsing  argv  and casting to uintptr_t
Traceback (most recent call last):
  File "/home/matthew/.config/gdb/walkers.py", line 308, in invoke
    pipeline_end = create_pipeline(arg)
  File "/home/matthew/.config/gdb/walkers.py", line 272, in create_pipeline
    first_val = [create_walker(args[0], first=True, last=only_one)]
  File "/home/matthew/.config/gdb/walkers.py", line 240, in create_walker
    return walker(args if args else None, first, last)
  File "/home/matthew/.config/gdb/walker_defs.py", line 314, in __init__
    self.start_addr = eval_int(start_addr)
  File "/home/matthew/.config/gdb/helpers.py", line 56, in eval_int
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
 >  File "<string>", line 1
    else
       ^
SyntaxError: invalid syntax
Error while executing Python code.
(gdb) quit
A debugging session is active.

	Inferior 2 [process 16630] will be killed.

Quit anyway? (y or n) 
vshcmd: > y
gdb-config [09:30:21] $ 
vshcmd: > shellpipe disassemble main ! grep call
   0x0000555555554b10 <+50>:	callq  0x555555554790 <fprintf@plt>
   0x0000555555554b1a <+60>:	callq  0x5555555547b0 <exit@plt>
   0x0000555555554b2d <+79>:	callq  0x5555555547a0 <atoi@plt>
   0x0000555555554b3a <+92>:	callq  0x555555554a53 <create_random_tree>
   0x0000555555554b4a <+108>:	callq  0x5555555549e4 <free_tree>
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
vshcmd: > break -function 'create_and_print<std::__cxx11::list<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > >' -label after_defined
vshcmd: > cont
vshcmd: > pipe std-list &rand_container | show print-string {}->front(); "\n"
[Switching to inferior 5 [<null>] (/home/matthew/share/repos/gdb-config/demos/cpp_structures)]
(gdb) Temporary breakpoint 1 at 0xaae: main. (4 locations)
Starting program: /home/matthew/share/repos/gdb-config/demos/cpp_structures 10

Temporary breakpoint 1, main (argc=2, argv=0x7fffffffe4b8) at demos/cpp_structures.cpp:29
29	{
(gdb) Breakpoint 2 at 0x555555555b04: file demos/cpp_structures.cpp, line 24.
(gdb) Continuing.

Breakpoint 2, create_and_print<std::__cxx11::list<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > > (start=1283169405, end=0) at demos/cpp_structures.cpp:23
23	  container rand_container(start, end);
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
vshcmd: > break -function 'create_and_print<std::vector<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > >' -label after_defined
vshcmd: > cont
vshcmd: > pipe std-vector &rand_container | show print-string *{}; "\n"
Breakpoint 3 at 0x555555555b99: file demos/cpp_structures.cpp, line 24.
(gdb) Continuing.

Breakpoint 3, create_and_print<std::vector<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > > (start=1283169405, end=0) at demos/cpp_structures.cpp:23
23	  container rand_container(start, end);
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
[Inferior 5 (process 4061) exited normally]
(gdb) quit
gdb-config [20:04:57] $ 
