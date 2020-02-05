vshcmd: > quit
vshcmd: > y
gdb [19:56:22] $ bash: y: command not found
gdb [19:56:22] $ 
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
Temporary breakpoint 1 at 0x400954: -qualified main. (4 locations)
Starting program: /home/matmal01/.config/gdb/demos/tree_debug 10

Temporary breakpoint 1, main (argc=2, argv=0x7fffffffdf88) at demos/tree.c:86
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
	 0x5555555552e4 	 create_tree
	 0x5555555552a3 	 free_tree
	 0x5555555551b9 	 insert_entry
	 0x55555555539d 	 main
	 0x555555555312 	 create_random_tree
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
[Inferior 3 (process 20592) exited normally]
(gdb) 
vshcmd: > set call-graph-enabled off
vshcmd: > run
call-graph tracing is disabled
(gdb) Starting program: /home/matthew/.config/gdb/demos/tree_debug 10
[Inferior 3 (process 20859) exited normally]
(gdb) 
vshcmd: > set call-graph-enabled on
call-graph tracing is enabled
(gdb) 
vshcmd: > !rm test.txt
vshcmd: > set call-graph-output test.txt
vshcmd: > run
rm: cannot remove 'test.txt': No such file or directory
(gdb) call-graph trace output directed to test.txt
(gdb) Starting program: /home/matthew/.config/gdb/demos/tree_debug 10
[Inferior 3 (process 20877) exited normally]
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
(gdb) (gdb) 
vshcmd: > call-graph clear
vshcmd: > info call-graph
(gdb) Functions currently traced by call-graph:
(gdb) 
vshcmd: > info call-graph
Functions currently traced by call-graph:
(gdb) 
vshcmd: > inferior 2
[Switching to inferior 2 [<null>] (/home/matmal01/.config/gdb/demos/tree)]
(gdb) 
vshcmd: > start 10
Temporary breakpoint 1 at 0x1256: main. (4 locations)
Starting program: /home/matthew/.config/gdb/demos/tree 10

Temporary breakpoint 1, 0x00005555555553a1 in main ()
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
	 0x5555555551b9 	 insert_entry
	 0x5555555552a3 	 free_tree
	 0x5555555552e4 	 create_tree
	 0x555555555312 	 create_random_tree
	 0x55555555539d 	 main
	 0x7ffff7ea22d0 	 free_tree
(gdb) 
vshcmd: > call-graph update - exact 0x5555555549e4
93824992233956 is not a .text location
Traceback (most recent call last):
  File "~/.config/gdb/commands.py", line 955, in invoke
    self.update_exact(args[0], args[2])
  File "~/.config/gdb/commands.py", line 937, in update_exact
    raise ValueError('{} does not start a function'.format(addr))
ValueError: 0x5555555549e4 does not start a function
Error occurred in Python: 0x5555555549e4 does not start a function
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
(gdb) 
vshcmd: > call-graph clear
(gdb) 
vshcmd: > info call-graph
Functions currently traced by call-graph:
(gdb) 
vshcmd: > inferior 2
[Switching to inferior 2 [<null>] (/home/matmal01/.config/gdb/demos/tree)]
(gdb) 
vshcmd: > start
Temporary breakpoint 2 at 0x400954: -qualified main. (4 locations)
Starting program: /home/matmal01/.config/gdb/demos/tree 
 --> main

Temporary breakpoint 2, 0x0000000000400988 in main ()
(gdb) 
vshcmd: > gdb-pipe called-functions main; .*; -1 | show whereis $cur
main 		Unknown
create_random_tree 		Unknown
create_tree 		Unknown
insert_entry 		Unknown
free_tree 		Unknown
free_tree 		Unknown
(gdb) 
vshcmd: > gdb-pipe called-functions main; .*; -1 | if $_output_contains("global-used $cur free_tree", "free_tree") | show hypothetical-stack
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
[Switching to inferior 3 [<null>] (/home/matmal01/.config/gdb/demos/tree_debug)]
(gdb) 
vshcmd: > start
Temporary breakpoint 3 at 0x400954: -qualified main. (4 locations)
Starting program: /home/matmal01/.config/gdb/demos/tree_debug 10

Thread 3.1 "tree_debug" hit Temporary breakpoint 3, main (argc=2, argv=0x7fffffffdf88) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) 
vshcmd: > gdb-pipe called-functions main; .*; -1 | show whereis $cur
main demos/tree.c:85
create_random_tree demos/tree.c:69
create_tree demos/tree.c:62
insert_entry demos/tree.c:23
free_tree demos/tree.c:53
free_tree demos/tree.c:53
(gdb) 
vshcmd: > gdb-pipe called-functions main; .*; -1 | if $_output_contains("global-used $cur free_tree", "free_tree") | show hypothetical-stack
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
vshcmd: > gdb-pipe called-functions main; .*; -1; unique | show whereis $cur
[Switching to inferior 3 [process 20621] (/home/matmal01/.config/gdb/demos/tree_debug)]
[Switching to thread 3.1 (process 20621)]
#0  main (argc=2, argv=0x7fffffffdf88) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) main demos/tree.c:85
create_random_tree demos/tree.c:69
create_tree demos/tree.c:62
insert_entry demos/tree.c:23
free_tree demos/tree.c:53
(gdb) 
vshcmd: > gdb-pipe called-functions main; .*; -1; unique | if $_output_contains("global-used $cur free_tree", "free_tree") | show hypothetical-stack
main demos/tree.c:85

main demos/tree.c:85
create_random_tree demos/tree.c:69

main demos/tree.c:85
free_tree demos/tree.c:53

(gdb) 
vshcmd: > inferior 2
[Switching to inferior 2 [process 20606] (/home/matmal01/.config/gdb/demos/tree)]
[Switching to thread 2.1 (process 20606)]
#0  0x0000000000400988 in main ()
(gdb) 
vshcmd: > gdb-pipe called-functions main; .*; -1; unique | show whereis $cur
main 		Unknown
create_random_tree 		Unknown
create_tree 		Unknown
insert_entry 		Unknown
free_tree 		Unknown
(gdb) 
vshcmd: > gdb-pipe called-functions main; .*; -1; unique | if $_output_contains("global-used $cur free_tree", "free_tree") | show hypothetical-stack
main 		Unknown

main 		Unknown
create_random_tree 		Unknown

main 		Unknown
free_tree 		Unknown

(gdb) 
vshcmd: > inferior 3
[Switching to inferior 3 [process 20621] (/home/matmal01/.config/gdb/demos/tree_debug)]
[Switching to thread 3.1 (process 20621)]
#0  main (argc=2, argv=0x7fffffffdf88) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) 
vshcmd: > cont
Continuing.
[Inferior 3 (process 20621) exited normally]
(gdb) 
vshcmd: > python import demos.tree_walker
(gdb) 
vshcmd: > tbreak tree.c:93
Temporary breakpoint 1 at 0x4009e7: file demos/tree.c, line 93.
(gdb) 
vshcmd: > run 10
Starting program: /home/matmal01/.config/gdb/demos/tree_debug 10

Temporary breakpoint 1, main (argc=2, argv=0x7fffffffdf88) at demos/tree.c:93
93	    free_tree(tree_root);
(gdb) 
vshcmd: > gdb-pipe tree-elements tree_root | if $cur->children[0] == 0 && $cur->children[1] == 0 | show printf "%d\n", $cur->datum
1753820418
1255532675
679162307
131589623
(gdb) 
vshcmd: > gdb-pipe follow-until 1; $cur > 10; $cur + 1
1
2
3
4
5
6
7
8
9
10
(gdb) 
vshcmd: > gdb-pipe array 1; 10
1
2
3
4
5
6
7
8
9
10
(gdb) 
vshcmd: > gdb-pipe eval 1 | array $cur; 10
1
2
3
4
5
6
7
8
9
10
(gdb) 
vshcmd: > gdb-pipe follow-until 1; $cur > 100; $cur + 1 | head 10
1
2
3
4
5
6
7
8
9
10
(gdb) 
vshcmd: > set variable $count = 0
(gdb) 
vshcmd: > gdb-pipe follow-until 1; $cur > 100; $cur + 1 | if $count++ < 10
1
2
3
4
5
6
7
8
9
10
(gdb) 
vshcmd: > set variable $count = 0
vshcmd: > gdb-pipe follow-until 1; $cur > 100; $cur + 1 | take-while $count++ < 10
(gdb) 1
2
3
4
5
6
7
8
9
10
(gdb) 
vshcmd: > set variable $count = 0
vshcmd: > gdb-pipe array 1; 100 | take-while $cur % 2 == 0 || $count++ < 5
(gdb) 1
2
3
4
5
6
7
8
9
10
(gdb) 
vshcmd: > set variable $count = 0
vshcmd: > gdb-pipe array 1; 100 | take-while (int)$cur % 2 == 0 || $count++ < 5
(gdb) 1
2
3
4
5
6
7
8
9
10
(gdb) 
vshcmd: > gdb-pipe follow-until 100; $cur <= 0; $cur - 1 | tail 10 | reverse
1
2
3
4
5
6
7
8
9
10
(gdb) 
vshcmd: > gdb-pipe follow-until 20; $cur <= 0; $cur - 1 | tail -10 | reverse 
1
2
3
4
5
6
7
8
9
10
(gdb) 
vshcmd: > gdb-pipe follow-until 100; $cur <= 0; $cur - 1 | skip-until $cur == 10 | reverse
1
2
3
4
5
6
7
8
9
10
(gdb) 
vshcmd: > gdb-pipe follow-until 1; $cur > 20; $cur + 1 | head -10
1
2
3
4
5
6
7
8
9
10
(gdb) 
vshcmd: > shellpipe gdb-pipe array 1; 5 | show printf "%x\n", $cur ! cat > addresses
vshcmd: > shellpipe gdb-pipe array 6; 5 | show printf "%x\n", $cur ! cat >> addresses
vshcmd: > gdb-pipe file addresses | eval (int)$cur
vshcmd: > !rm addresses
(gdb) (gdb) 1
2
3
4
5
6
7
8
9
10
(gdb) (gdb) 
vshcmd: > set variable $count = 0
vshcmd: > gdb-pipe follow-until 1; $cur > 100; $count++, $cur + 1 | head 0 | devnull
vshcmd: > print $count
(gdb) (gdb) $1 = 0
(gdb) 
vshcmd: > set variable $count = 0
vshcmd: > gdb-pipe follow-until 1; $cur > 100; $count++, $cur + 1 | head 10 | devnull
vshcmd: > print $count
(gdb) (gdb) $2 = 9
(gdb) 
vshcmd: > set variable $sum = 0
vshcmd: > gdb-pipe follow-until 1; $cur > 100; $cur + 1 | eval $sum += $cur, $cur | devnull
vshcmd: > print $sum
(gdb) (gdb) $3 = 5050
(gdb) 
vshcmd: > gdb-pipe eval 1 | show printf "%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d\n", $cur, $cur, $cur, $cur, $cur, $cur, $cur, $cur, $cur, $cur, $cur, $cur, $cur, $cur, $cur, $cur, $cur, $cur, $cur, $cur, $cur
111111111111111111111
(gdb) 
vshcmd: > gdb-pipe follow-until 1; $cur > 100 && $cur != 99; $cur + 1 | count
100
(gdb) 
gdb [10:33:55] $ 
vshcmd: > inferior 4
[Switching to inferior 4 [<null>] (/home/matmal01/.config/gdb/demos/list)]
(gdb) 
vshcmd: > tbreak list.c:70
vshcmd: > run 10
Temporary breakpoint 1 at 0x4009a8: file demos/list.c, line 70.
(gdb) Starting program: /home/matmal01/.config/gdb/demos/list 10

Temporary breakpoint 1, main (argc=2, argv=0x7fffffffdfa8) at demos/list.c:70
70	    free_list(list_head);
(gdb) 
vshcmd: > gdb-pipe linked-list list_head; ->next | show printf "%d\n", $cur->datum
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
[Switching to inferior 3 [<null>] (/home/matmal01/.config/gdb/demos/tree_debug)]
(gdb) 
vshcmd: > cont
The program is not being run.
(gdb) 
vshcmd: > start Hello there this is a set of arguments
Temporary breakpoint 2 at 0x400954: -qualified main. (4 locations)
Starting program: /home/matmal01/.config/gdb/demos/tree_debug Hello there this is a set of arguments

Thread 3.1 "tree_debug" hit Temporary breakpoint 2, main (argc=9, argv=0x7fffffffdf28) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) 
vshcmd: > gdb-pipe follow-until argv + 1; *$cur == 0; $cur + 1 | max (*(char **)$cur)[0] | show printf "%s\n", *$cur
there
(gdb) 
vshcmd: > gdb-pipe follow-until argv + 1; *$cur == 0; $cur + 1 | min (*(char **)$cur)[0] | show printf "%s\n", *$cur
Hello
(gdb) 
vshcmd: > gdb-pipe follow-until argv + 1; *$cur == 0; $cur + 1 | sort (*(char **)$cur)[0] | show printf "%s\n", *$cur
Hello
a
arguments
is
of
set
there
this
(gdb) 
vshcmd: > gdb-pipe follow-until argv + 1; *$cur == 0; $cur + 1 | sort (*(char **)$cur)[0] | dedup (*(char **)$cur)[0] | show printf "%s\n", *$cur
Hello
a
is
of
set
there
(gdb) 
vshcmd: > gdb-pipe array argv; argc | array *$cur; 3 | show printf "%c", *$cur
/hoHelthethiisassetofarg(gdb) 
vshcmd: > cont
Continuing.
Usage: /home/matmal01/.config/gdb/demos/tree_debug <seed>
[Inferior 3 (process 20714) exited with code 01]
(gdb) 
vshcmd: > gdb-pipe defined-functions tree.c:.* | show print $cur
$10 = (void *) 0x4007a6 <insert_entry>
$11 = (void *) 0x40088c <free_tree>
$12 = (void *) 0x4008cd <create_tree>
$13 = (void *) 0x4008fb <create_random_tree>
$14 = (void *) 0x400984 <main>
(gdb) 
vshcmd: > gdb-pipe defined-functions tree.c:.* | show whereis $cur
insert_entry demos/tree.c:23
free_tree demos/tree.c:53
create_tree demos/tree.c:62
create_random_tree demos/tree.c:69
main demos/tree.c:85
(gdb) 
vshcmd: > gdb-pipe defined-functions .* | show whereis $cur
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
Temporary breakpoint 3 at 0x400954: -qualified main. (4 locations)
Starting program: /home/matmal01/.config/gdb/demos/tree_debug 20 100 Hello there this is a test

Thread 3.1 "tree_debug" hit Temporary breakpoint 3, main (argc=9, argv=0x7fffffffdf38) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) 
vshcmd: > set variable $i = -1
(gdb) 
vshcmd: > gdb-pipe array argv; argc  | if $i++, $_output_contains("print *$cur", "t") | show output $i
0458(gdb) 
vshcmd: > cont
Continuing.
Usage: /home/matmal01/.config/gdb/demos/tree_debug <seed>
[Inferior 3 (process 20749) exited with code 01]
(gdb) 
vshcmd: > inferior 2
[Switching to inferior 2 [<null>] (/home/matmal01/.config/gdb/demos/tree)]
(gdb) 
vshcmd: > cont
The program is not being run.
(gdb) 
vshcmd: > start 20 100 Hello there this is a test
Temporary breakpoint 4 at 0x400954: -qualified main. (4 locations)
Starting program: /home/matmal01/.config/gdb/demos/tree 20 100 Hello there this is a test

Thread 2.1 "tree" hit Temporary breakpoint 4, 0x0000000000400988 in main ()
(gdb) 
vshcmd: > set variable $i = -1
(gdb) 
vshcmd: > gdb-pipe array argv; argc  | if $i++, $_output_contains("print *$cur", "t") | show output $i
Error parsing expression  argv
Current value of $cur =  0x7fffffffdf78
Current value of *$cur =  0x7fffffffe3f0 "is"
########################################################################


Traceback (most recent call last):
  File "/home/matmal01/.config/gdb/walkers.py", line 291, in invoke
    for element in pipeline_end:
  File "/home/matmal01/.config/gdb/walker_defs.py", line 152, in iter_def
    for element in inpipe:
  File "/home/matmal01/.config/gdb/walker_defs.py", line 246, in iter_def
    for element in inpipe:
  File "/home/matmal01/.config/gdb/walker_defs.py", line 469, in iter_def
    self.start_expr, self.count_expr)
  File "/home/matmal01/.config/gdb/walkers.py", line 178, in call_with
    yield from helper(*(self.calc(x) for x in helper_args))
  File "/home/matmal01/.config/gdb/walkers.py", line 178, in <genexpr>
    yield from helper(*(self.calc(x) for x in helper_args))
  File "/home/matmal01/.config/gdb/walkers.py", line 110, in calc
    return gdb.parse_and_eval(gdb_expr)
gdb.error: No symbol table is loaded.  Use the "file" command.
Error occurred in Python: No symbol table is loaded.  Use the "file" command.
(gdb) 
vshcmd: > cont
Continuing.
Usage: /home/matmal01/.config/gdb/demos/tree <seed>
[Inferior 2 (process 20758) exited with code 01]
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
Worked nicely
(gdb) 
vshcmd: > shellpipe disassemble main ! grep call
   0x0000000000400975 <+48>:	callq  0x400670 <fprintf@plt>
   0x000000000040097f <+58>:	callq  0x400690 <exit@plt>
   0x0000000000400992 <+77>:	callq  0x400680 <atoi@plt>
   0x000000000040099f <+90>:	callq  0x4008a1 <create_random_list>
   0x00000000004009af <+106>:	callq  0x40086a <free_list>
(gdb) 
vshcmd: > inferior 2
[Switching to inferior 2 [<null>] (/home/matmal01/.config/gdb/demos/tree)]
(gdb) 
vshcmd: > shellpipe disassemble main ! grep call
   0x00000000004009b4 <+48>:	callq  0x400650 <fprintf@plt>
   0x00000000004009be <+58>:	callq  0x400670 <exit@plt>
   0x00000000004009d1 <+77>:	callq  0x400660 <atoi@plt>
   0x00000000004009de <+90>:	callq  0x4008fb <create_random_tree>
   0x00000000004009ee <+106>:	callq  0x40088c <free_tree>
(gdb) 
vshcmd: > # Inspecting the CPP structures
vshcmd: > quit
vshcmd: > y
vshcmd: > gdb -q demos/cpp_structures
vshcmd: > add-auto-load-scripts-directory /usr/share/gdb/auto-load
vshcmd: > add-auto-load-safe-path /usr/share/gdb/auto-load
A debugging session is active.

	Inferior 1 [process 21869] will be killed.

Quit anyway? (y or n) gdb [10:49:00] $ Reading symbols from demos/cpp_structures...
(gdb) (gdb) (gdb) 
vshcmd: > inferior 5
vshcmd: > start 10
vshcmd: > break -function 'create_container<std::__cxx11::list<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > >' -label after_defined
vshcmd: > cont
vshcmd: > gdb-pipe pretty-printer rand_container
Temporary breakpoint 1 at 0x400d93: file demos/cpp_structures.cpp, line 30.
Starting program: /home/matmal01/.config/gdb/demos/cpp_structures 10

Temporary breakpoint 1, main (argc=2, argv=0x7fffffffdf88) at demos/cpp_structures.cpp:30
30	{
(gdb) Breakpoint 2 at 0x401304: file demos/cpp_structures.cpp, line 25.
(gdb) Continuing.

Breakpoint 2, create_container<std::__cxx11::list<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > > (start=1283169405, end=0) at demos/cpp_structures.cpp:24
24	  container rand_container(start, end);
(gdb) No pretty printer found for rand_container.
(gdb) 
vshcmd: > gdb-pipe pretty-printer rand_container; values
No pretty printer found for rand_container.
(gdb) 
vshcmd: > break -function 'create_container<std::vector<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > >' -label after_defined
vshcmd: > cont
vshcmd: > gdb-pipe pretty-printer rand_container | show print *$cur
Breakpoint 3 at 0x401399: file demos/cpp_structures.cpp, line 25.
(gdb) Continuing.

Breakpoint 3, create_container<std::vector<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > > (start=1283169405, end=0) at demos/cpp_structures.cpp:24
24	  container rand_container(start, end);
(gdb) $1 = 1283169405
$2 = 89128932
$3 = 2124247567
$4 = 1902734705
$5 = 2141071321
$6 = 965494256
$7 = 108111773
$8 = 850673521
$9 = 1140597833
(gdb) 
vshcmd: > gdb-pipe pretty-printer rand_container; values | show print $cur
$10 = 1283169405
$11 = 89128932
$12 = 2124247567
$13 = 1902734705
$14 = 2141071321
$15 = 965494256
$16 = 108111773
$17 = 850673521
$18 = 1140597833
(gdb) 
vshcmd: > break -function 'create_container<std::map<int, int, std::less<int>, std::allocator<std::pair<int const, int> > >, __gnu_cxx::__normal_iterator<std::pair<int, int>*, std::vector<std::pair<int, int>, std::allocator<std::pair<int, int> > > > >' -label after_defined
vshcmd: > cont
vshcmd: > gdb-pipe pretty-printer rand_container | show print *$cur
Breakpoint 4 at 0x4015aa: file demos/cpp_structures.cpp, line 25.
(gdb) Continuing.

Breakpoint 4, create_container<std::map<int, int, std::less<int>, std::allocator<std::pair<int const, int> > >, __gnu_cxx::__normal_iterator<std::pair<int, int>*, std::vector<std::pair<int, int>, std::allocator<std::pair<int, int> > > > > (start=..., end=...) at demos/cpp_structures.cpp:24
24	  container rand_container(start, end);
(gdb) $19 = 0
$20 = 1283169405
$21 = 1
$22 = 89128932
$23 = 2
$24 = 2124247567
$25 = 3
$26 = 1902734705
$27 = 4
$28 = 2141071321
$29 = 5
$30 = 965494256
$31 = 6
$32 = 108111773
$33 = 7
$34 = 850673521
$35 = 8
$36 = 1140597833
(gdb) 
vshcmd: > gdb-pipe std-map &rand_container | show print *$cur
$37 = {first = 0, second = 1283169405}
$38 = {first = 1, second = 89128932}
$39 = {first = 2, second = 2124247567}
$40 = {first = 3, second = 1902734705}
$41 = {first = 4, second = 2141071321}
$42 = {first = 5, second = 965494256}
$43 = {first = 6, second = 108111773}
$44 = {first = 7, second = 850673521}
$45 = {first = 8, second = 1140597833}
(gdb) 
vshcmd: > gdb-pipe pretty-printer rand_container; values | show print-string $cur; "\n"
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
vshcmd: > y
A debugging session is active.

	Inferior 1 [process 21885] will be killed.

Quit anyway? (y or n) gdb [10:49:21] $ 
