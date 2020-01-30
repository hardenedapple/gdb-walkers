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
(gdb) (gdb) [Switching to inferior 3 [<null>] (/home/matthew/.config/gdb/demos/tree_debug)]
(gdb) 
vshcmd: > # BELOW IS ORIGINAL
vshcmd: > start 10
Temporary breakpoint 1 at 0x1256: main. (4 locations)
Starting program: /home/matthew/.config/gdb/demos/tree_debug 10

Temporary breakpoint 1, main (argc=2, argv=0x7fffffffe4e8) at demos/tree.c:86
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
[Inferior 3 (process 20847) exited normally]
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
[Switching to inferior 2 [<null>] (/home/matthew/.config/gdb/demos/tree)]
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
[Switching to inferior 2 [<null>] (/home/matthew/.config/gdb/demos/tree)]
(gdb) 
vshcmd: > start
Temporary breakpoint 3 at 0x1256: main. (4 locations)
Starting program: /home/matthew/.config/gdb/demos/tree 10

Temporary breakpoint 3, 0x00005555555553a1 in main ()
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
[Switching to inferior 3 [<null>] (/home/matthew/.config/gdb/demos/tree_debug)]
(gdb) 
vshcmd: > start
Temporary breakpoint 2 at 0x1256: main. (4 locations)
Starting program: /home/matthew/.config/gdb/demos/tree_debug 

Thread 3.1 "tree_debug" hit Temporary breakpoint 2, main (argc=1, argv=0x7fffffffe4f8) at demos/tree.c:86
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
[Switching to inferior 3 [process 21088] (/home/matthew/.config/gdb/demos/tree_debug)]
[Switching to thread 3.1 (process 21088)]
#0  main (argc=1, argv=0x7fffffffe4f8) at demos/tree.c:86
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
[Switching to inferior 2 [process 21070] (/home/matthew/.config/gdb/demos/tree)]
[Switching to thread 2.1 (process 21070)]
#0  0x00005555555553a1 in main ()
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
[Switching to inferior 3 [<null>] (/home/matthew/.config/gdb/demos/tree_debug)]
(gdb) 
vshcmd: > cont
The program is not being run.
(gdb) 
vshcmd: > python import demos.tree_walker
(gdb) 
vshcmd: > tbreak tree.c:93
Temporary breakpoint 1 at 0x1402: file demos/tree.c, line 93.
(gdb) 
vshcmd: > run 10
Starting program: /home/matthew/.config/gdb/demos/tree_debug 10

Temporary breakpoint 1, main (argc=2, argv=0x7fffffffe4e8) at demos/tree.c:93
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
vshcmd: > gdb-pipe follow-until 1; $cur > 100; $cur + 1 | if $count++ < 10
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
16
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
vshcmd: > inferior 4
[Switching to inferior 4 [<null>] (/home/matthew/.config/gdb/demos/list)]
(gdb) 
vshcmd: > tbreak list.c:70
vshcmd: > run 10
Temporary breakpoint 6 at 0x13a4: file demos/list.c, line 70.
(gdb) Starting program: /home/matthew/.config/gdb/demos/list 10

Thread 4.1 "list" hit Temporary breakpoint 6, main (argc=2, argv=0x7fffffffe4f8) at demos/list.c:70
70	    free_list(list_head);
(gdb) 
vshcmd: > gdb-pipe linked-list list_head; next | show printf "%d\n", $cur->datum
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
The program is not being run.
(gdb) 
vshcmd: > start Hello there this is a set of arguments
Temporary breakpoint 3 at 0x1256: main. (4 locations)
Starting program: /home/matthew/.config/gdb/demos/tree_debug Hello there this is a set of arguments

Thread 3.1 "tree_debug" hit Temporary breakpoint 3, main (argc=9, argv=0x7fffffffe488) at demos/tree.c:86
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
Usage: /home/matthew/.config/gdb/demos/tree_debug <seed>
[Inferior 3 (process 21105) exited with code 01]
(gdb) 
vshcmd: > pi
vshcmd: > from helpers import search_symbols
vshcmd: > [str(x.value()) for x in search_symbols('.*', 'tree.c', False)]
vshcmd: > 
>>> >>> ['{node_t *(int32_t)} 0x5555555552e4 <create_tree>',
 '{void (node_t *)} 0x5555555552a3 <free_tree>',
 '{_Bool (node_t *,
 int32_t)} 0x5555555551b9 <insert_entry>',
 '{int (int,
 char **)} 0x55555555539d <main>',
 '{node_t *(uint32_t)} 0x555555555312 <create_random_tree>']
>>> 
(gdb) (gdb) 
vshcmd: > gdb-pipe defined-functions tree.c:.* | show print $cur
$1 = (void *) 0x5555555552e4 <create_tree>
$2 = (void *) 0x5555555552a3 <free_tree>
$3 = (void *) 0x5555555551b9 <insert_entry>
$4 = (void *) 0x55555555539d <main>
$5 = (void *) 0x555555555312 <create_random_tree>
(gdb) 
vshcmd: > gdb-pipe defined-functions tree.c:.* | show whereis $cur
create_tree demos/tree.c:62
free_tree demos/tree.c:53
insert_entry demos/tree.c:23
main demos/tree.c:85
create_random_tree demos/tree.c:69
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
Temporary breakpoint 4 at 0x1256: main. (4 locations)
Starting program: /home/matthew/.config/gdb/demos/tree_debug 20 100 Hello there this is a test

Thread 3.1 "tree_debug" hit Temporary breakpoint 4, main (argc=9, argv=0x7fffffffe498) at demos/tree.c:86
86	    if (argc != 2) {
(gdb) 
vshcmd: > set variable $i = -1
(gdb) 
vshcmd: > gdb-pipe array argv; argc  | if $i++, $_output_contains("print *$cur", "t") | show output $i
0458(gdb) 
vshcmd: > cont
Continuing.
Usage: /home/matthew/.config/gdb/demos/tree_debug <seed>
[Inferior 3 (process 21123) exited with code 01]
(gdb) 
vshcmd: > inferior 2
[Switching to inferior 2 [process 21070] (/home/matthew/.config/gdb/demos/tree)]
[Switching to thread 2.1 (process 21070)]
#0  0x00005555555553a1 in main ()
(gdb) 
vshcmd: > cont
Continuing.
[Inferior 2 (process 21070) exited normally]
(gdb) 
vshcmd: > start 20 100 Hello there this is a test
Temporary breakpoint 5 at 0x1256: main. (4 locations)
Starting program: /home/matthew/.config/gdb/demos/tree 20 100 Hello there this is a test

Temporary breakpoint 5, 0x00005555555553a1 in main ()
(gdb) 
vshcmd: > set variable $i = -1
(gdb) 
vshcmd: > gdb-pipe array argv; argc  | if $i++, $_output_contains("print *$cur", "t") | show output $i
Error parsing expression  argv
Current value of $cur =  0x7fffffffe4d8
Current value of *$cur =  0x7fffffffe8a1 "is"
########################################################################


Traceback (most recent call last):
  File "/home/matthew/.config/gdb/walkers.py", line 291, in invoke
    for element in pipeline_end:
  File "/home/matthew/.config/gdb/walker_defs.py", line 150, in iter_def
    for element in inpipe:
  File "/home/matthew/.config/gdb/walker_defs.py", line 252, in iter_def
    for element in inpipe:
  File "/home/matthew/.config/gdb/walker_defs.py", line 470, in iter_def
    self.calc(self.start_expr),
  File "/home/matthew/.config/gdb/walkers.py", line 110, in calc
    return gdb.parse_and_eval(gdb_expr)
gdb.error: No symbol table is loaded.  Use the "file" command.
Error occurred in Python: No symbol table is loaded.  Use the "file" command.
(gdb) 
vshcmd: > cont
Continuing.
Usage: /home/matthew/.config/gdb/demos/tree <seed>
[Inferior 2 (process 21134) exited with code 01]
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
   0x00005555555553cf <+50>:	callq  0x555555555070 <fprintf@plt>
   0x00005555555553d9 <+60>:	callq  0x555555555090 <exit@plt>
   0x00005555555553ec <+79>:	callq  0x555555555080 <atoi@plt>
   0x00005555555553f9 <+92>:	callq  0x555555555312 <create_random_tree>
   0x0000555555555409 <+108>:	callq  0x5555555552a3 <free_tree>
(gdb) 
vshcmd: > inferior 2
[Switching to inferior 2 [<null>] (/home/matthew/.config/gdb/demos/tree)]
(gdb) 
vshcmd: > shellpipe disassemble main ! grep call
   0x00005555555553cf <+50>:	callq  0x555555555070 <fprintf@plt>
   0x00005555555553d9 <+60>:	callq  0x555555555090 <exit@plt>
   0x00005555555553ec <+79>:	callq  0x555555555080 <atoi@plt>
   0x00005555555553f9 <+92>:	callq  0x555555555312 <create_random_tree>
   0x0000555555555409 <+108>:	callq  0x5555555552a3 <free_tree>
(gdb) 
vshcmd: > # Inspecting the CPP structures
vshcmd: > inferior 5
vshcmd: > start 10
vshcmd: > break -function 'create_container<std::__cxx11::list<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > >' -label after_defined
vshcmd: > cont
vshcmd: > gdb-pipe pretty-printer rand_container
[Switching to inferior 5 [<null>] (/home/matthew/.config/gdb/demos/cpp_structures)]
(gdb) Temporary breakpoint 1 at 0x1256: main. (4 locations)
Starting program: /home/matthew/.config/gdb/demos/cpp_structures 10
/usr/lib/../share/gcc-9.2.0/python/libstdcxx/v6/xmethods.py:731: SyntaxWarning: list indices must be integers or slices, not str; perhaps you missed a comma?
  refcounts = ['_M_refcount']['_M_pi']

Temporary breakpoint 1, main (argc=2, argv=0x7fffffffe4d8) at demos/cpp_structures.cpp:30
30	{
(gdb) Breakpoint 2 at 0x555555555886: file demos/cpp_structures.cpp, line 25.
(gdb) Continuing.

Breakpoint 2, create_container<std::__cxx11::list<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > > (start=1283169405, end=0) at demos/cpp_structures.cpp:24
24	  container rand_container(start, end);
(gdb) (int *) 0x55555556fef0
(int *) 0x55555556ff10
(int *) 0x55555556ff30
(int *) 0x55555556ff50
(int *) 0x55555556ff70
(int *) 0x55555556ff90
(int *) 0x55555556ffb0
(int *) 0x55555556ffd0
(int *) 0x55555556fff0
(gdb) 
vshcmd: > gdb-pipe pretty-printer rand_container; values
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
vshcmd: > break -function 'create_container<std::vector<int, std::allocator<int> >, __gnu_cxx::__normal_iterator<int*, std::vector<int, std::allocator<int> > > >' -label after_defined
vshcmd: > cont
vshcmd: > gdb-pipe pretty-printer rand_container | show print *$cur
Breakpoint 3 at 0x55555555591b: file demos/cpp_structures.cpp, line 25.
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
vshcmd: > break -function 'create_container<std::map<int, int, std::less<int>, std::allocator<std::pair<int const, int> > >, __gnu_cxx::__normal_iterator<std::pair<int, int>*, std::vector<std::pair<int, int>, std::allocator<std::pair<int, int> > > > >' -label after_defined
vshcmd: > cont
vshcmd: > gdb-pipe pretty-printer rand_container | show print *$cur
Breakpoint 4 at 0x555555555be4: file demos/cpp_structures.cpp, line 25.
(gdb) Continuing.

Breakpoint 4, create_container<std::map<int, int, std::less<int>, std::allocator<std::pair<int const, int> > >, __gnu_cxx::__normal_iterator<std::pair<int, int>*, std::vector<std::pair<int, int>, std::allocator<std::pair<int, int> > > > > (start={first = 0, second = 1283169405}, end={first = 0, second = 0}) at demos/cpp_structures.cpp:24
24	  container rand_container(start, end);
(gdb) $10 = 0
$11 = 1283169405
$12 = 1
$13 = 89128932
$14 = 2
$15 = 2124247567
$16 = 3
$17 = 1902734705
$18 = 4
$19 = 2141071321
$20 = 5
$21 = 965494256
$22 = 6
$23 = 108111773
$24 = 7
$25 = 850673521
$26 = 8
$27 = 1140597833
(gdb) 
vshcmd: > gdb-pipe std-map &rand_container | show print *$cur
$28 = {first = 0, second = 1283169405}
$29 = {first = 1, second = 89128932}
$30 = {first = 2, second = 2124247567}
$31 = {first = 3, second = 1902734705}
$32 = {first = 4, second = 2141071321}
$33 = {first = 5, second = 965494256}
$34 = {first = 6, second = 108111773}
$35 = {first = 7, second = 850673521}
$36 = {first = 8, second = 1140597833}
(gdb) 
vshcmd: > gdb-pipe pretty-printer rand_container; values | show print-string *$cur; "\n"
rand_container True
['rand_container']
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

	Inferior 5 [process 21221] will be killed.

Quit anyway? (y or n) gdb [12:09:35] $ 
