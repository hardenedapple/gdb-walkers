vshcmd: > gdb demos/tree_debug
vshcmd: > python import demos.tree_walker
vshcmd: > tbreak tree.c:93
vshcmd: > run 10
vshcmd: > pipe tree-elements tree_root | if {}->children[0] == 0 && {}->children[1] == 0 | show printf "%d\n", {}->datum
Reading symbols from demos/tree_debug...done.
(gdb) (gdb) Temporary breakpoint 1 at 0x4009b7: file demos/tree.c, line 93.
(gdb) Starting program: /home/matthew/share/repos/gdb-config/demos/tree_debug 10

Temporary breakpoint 1, main (argc=2, argv=0x7fffffffe4e8) at demos/tree.c:93
93	    free_tree(tree_root);
(gdb) 1753820418
1255532675
679162307
131589623
(gdb) quit
A debugging session is active.

	Inferior 1 [process 391] will be killed.

Quit anyway? (y or n) 
vshcmd: > y
gdb-config [12:36:49] $ 
vshcmd: > sudo bash -c "echo 0 > /proc/sys/kernel/yama/ptrace_scope"
[sudo] password for matthew: 
(gdb) 
vshcmd: > # vimcmd; .,.+4Vrerun
vshcmd: > detach
vshcmd: > quit
vshcmd: > gdb ~/share/repos/neovim/build/bin/nvim
vshcmd: > attach-matching nvim walker-test
Detaching from program: /home/matthew/share/repos/neovim/build/bin/nvim, process 866
(gdb) gdb-config [14:16:23] $ Reading symbols from /home/matthew/share/repos/neovim/build/bin/nvim...done.
(gdb) [New LWP 930]
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/usr/lib/libthread_db.so.1".
0x00007fbcb0072889 in syscall () from /usr/lib/libc.so.6
(gdb) 
vshcmd: > pipe nvim-folds &curwin->w_folds | show print *{}
$20 = {fd_top = 11, fd_len = 4, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 0 '\000'}
$21 = {fd_top = 16, fd_len = 4, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 0 '\000'}
$22 = {fd_top = 23, fd_len = 28, fd_nested = {ga_len = 3, ga_maxlen = 10, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x7fbcae03e400}, fd_flags = 2 '\002', fd_small = 0 '\000'}
$23 = {fd_top = 1, fd_len = 4, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 2 '\002'}
$24 = {fd_top = 7, fd_len = 4, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 2 '\002'}
$25 = {fd_top = 14, fd_len = 9, fd_nested = {ga_len = 1, ga_maxlen = 10, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x7fbcae03e600}, fd_flags = 2 '\002', fd_small = 2 '\002'}
$26 = {fd_top = 3, fd_len = 4, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 2 '\002'}
$27 = {fd_top = 53, fd_len = 7, fd_nested = {ga_len = 1, ga_maxlen = 10, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x7fbcae03e800}, fd_flags = 2 '\002', fd_small = 0 '\000'}
$28 = {fd_top = 1, fd_len = 5, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 2 '\002'}
$29 = {fd_top = 62, fd_len = 5, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 0 '\000'}
$30 = {fd_top = 69, fd_len = 14, fd_nested = {ga_len = 1, ga_maxlen = 10, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x7fbcae03ea00}, fd_flags = 2 '\002', fd_small = 0 '\000'}
$31 = {fd_top = 4, fd_len = 7, fd_nested = {ga_len = 1, ga_maxlen = 10, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x7fbcae03ec00}, fd_flags = 2 '\002', fd_small = 2 '\002'}
$32 = {fd_top = 1, fd_len = 5, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 2 '\002'}
$33 = {fd_top = 85, fd_len = 11, fd_nested = {ga_len = 1, ga_maxlen = 10, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x7fbcae03ee00}, fd_flags = 2 '\002', fd_small = 0 '\000'}
$34 = {fd_top = 1, fd_len = 4, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 2 '\002'}
(gdb) 
vshcmd: > pipe eval &curwin->w_folds | nvim-folds | show print *{}
$5 = {fd_top = 11, fd_len = 4, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 0 '\000'}
$6 = {fd_top = 16, fd_len = 4, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 0 '\000'}
$7 = {fd_top = 23, fd_len = 28, fd_nested = {ga_len = 3, ga_maxlen = 10, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x7fbcae03e400}, fd_flags = 2 '\002', fd_small = 0 '\000'}
$8 = {fd_top = 1, fd_len = 4, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 2 '\002'}
$9 = {fd_top = 7, fd_len = 4, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 2 '\002'}
$10 = {fd_top = 14, fd_len = 9, fd_nested = {ga_len = 1, ga_maxlen = 10, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x7fbcae03e600}, fd_flags = 2 '\002', fd_small = 2 '\002'}
$11 = {fd_top = 3, fd_len = 4, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 2 '\002'}
$12 = {fd_top = 53, fd_len = 7, fd_nested = {ga_len = 1, ga_maxlen = 10, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x7fbcae03e800}, fd_flags = 2 '\002', fd_small = 0 '\000'}
$13 = {fd_top = 1, fd_len = 5, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 2 '\002'}
$14 = {fd_top = 62, fd_len = 5, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 0 '\000'}
$15 = {fd_top = 69, fd_len = 14, fd_nested = {ga_len = 1, ga_maxlen = 10, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x7fbcae03ea00}, fd_flags = 2 '\002', fd_small = 0 '\000'}
$16 = {fd_top = 4, fd_len = 7, fd_nested = {ga_len = 1, ga_maxlen = 10, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x7fbcae03ec00}, fd_flags = 2 '\002', fd_small = 2 '\002'}
$17 = {fd_top = 1, fd_len = 5, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 2 '\002'}
$18 = {fd_top = 85, fd_len = 11, fd_nested = {ga_len = 1, ga_maxlen = 10, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x7fbcae03ee00}, fd_flags = 2 '\002', fd_small = 0 '\000'}
$19 = {fd_top = 1, fd_len = 4, fd_nested = {ga_len = 0, ga_maxlen = 0, ga_itemsize = 48, ga_growsize = 10, ga_data = 0x0}, fd_flags = 2 '\002', fd_small = 2 '\002'}
(gdb) 
vshcmd: > pipe nvim-undohist curbuf->b_u_oldhead | show print *{}
$1 = {uh_next = {ptr = 0x0, seq = 0}, uh_prev = {ptr = 0x7fbcaf512600, seq = 140448371910144}, uh_alt_next = {ptr = 0x0, seq = 0}, uh_alt_prev = {ptr = 0x0, seq = 0}, uh_seq = 1, uh_walk = 0, uh_entry = 0x7fbcaf4fb600, uh_getbot_entry = 0x0, uh_cursor = {lnum = 8, col = 0, coladd = 0}, uh_cursor_vcol = -1, uh_flags = 0, uh_namedm = {{mark = {lnum = 0, col = 0, coladd = 0}, fnum = 0, timestamp = 0, additional_data = 0x0} <repeats 26 times>}, uh_visual = {vi_start = {lnum = 0, col = 0, coladd = 0}, vi_end = {lnum = 0, col = 0, coladd = 0}, vi_mode = 0, vi_curswant = 0}, uh_time = 1491393020, uh_save_nr = 0}
$2 = {uh_next = {ptr = 0x7fbcaf50e000, seq = 140448371892224}, uh_prev = {ptr = 0x0, seq = 0}, uh_alt_next = {ptr = 0x0, seq = 0}, uh_alt_prev = {ptr = 0x0, seq = 0}, uh_seq = 2, uh_walk = 0, uh_entry = 0x7fbcaf55b7f0, uh_getbot_entry = 0x0, uh_cursor = {lnum = 9, col = 0, coladd = 0}, uh_cursor_vcol = -1, uh_flags = 1, uh_namedm = {{mark = {lnum = 0, col = 0, coladd = 0}, fnum = 0, timestamp = 0, additional_data = 0x0} <repeats 26 times>}, uh_visual = {vi_start = {lnum = 0, col = 0, coladd = 0}, vi_end = {lnum = 0, col = 0, coladd = 0}, vi_mode = 0, vi_curswant = 0}, uh_time = 1491393021, uh_save_nr = 0}
(gdb) 
vshcmd: > pipe eval curbuf->b_u_oldhead | nvim-undohist | show print *{}
$3 = {uh_next = {ptr = 0x0, seq = 0}, uh_prev = {ptr = 0x7fbcaf512600, seq = 140448371910144}, uh_alt_next = {ptr = 0x0, seq = 0}, uh_alt_prev = {ptr = 0x0, seq = 0}, uh_seq = 1, uh_walk = 0, uh_entry = 0x7fbcaf4fb600, uh_getbot_entry = 0x0, uh_cursor = {lnum = 8, col = 0, coladd = 0}, uh_cursor_vcol = -1, uh_flags = 0, uh_namedm = {{mark = {lnum = 0, col = 0, coladd = 0}, fnum = 0, timestamp = 0, additional_data = 0x0} <repeats 26 times>}, uh_visual = {vi_start = {lnum = 0, col = 0, coladd = 0}, vi_end = {lnum = 0, col = 0, coladd = 0}, vi_mode = 0, vi_curswant = 0}, uh_time = 1491393020, uh_save_nr = 0}
$4 = {uh_next = {ptr = 0x7fbcaf50e000, seq = 140448371892224}, uh_prev = {ptr = 0x0, seq = 0}, uh_alt_next = {ptr = 0x0, seq = 0}, uh_alt_prev = {ptr = 0x0, seq = 0}, uh_seq = 2, uh_walk = 0, uh_entry = 0x7fbcaf55b7f0, uh_getbot_entry = 0x0, uh_cursor = {lnum = 9, col = 0, coladd = 0}, uh_cursor_vcol = -1, uh_flags = 1, uh_namedm = {{mark = {lnum = 0, col = 0, coladd = 0}, fnum = 0, timestamp = 0, additional_data = 0x0} <repeats 26 times>}, uh_visual = {vi_start = {lnum = 0, col = 0, coladd = 0}, vi_end = {lnum = 0, col = 0, coladd = 0}, vi_mode = 0, vi_curswant = 0}, uh_time = 1491393021, uh_save_nr = 0}
(gdb) 
vshcmd: > pipe nvim-buffers | show print {}->b_ffname
vshcmd: > pipe nvim-buffers | if {}->b_ffname | if $_regex({}->b_ffname, ".*tree.*") | show print {}->b_ffname
$3 = (char_u *) 0x7fbcafa21000 "/home/matthew/share/repos/gdb-config/demos/tree.c"
(gdb) quit
A debugging session is active.

	Inferior 1 [process 866] will be detached.

Quit anyway? (y or n) 
vshcmd: > pipe nvim-tabs | show print *{}
$6 = {handle = 1, tp_next = 0x7fbcae04e1a0, tp_topframe = 0x7fbcafa15040, tp_curwin = 0x7fbcae0af000, tp_prevwin = 0x7fbcafa59000, tp_firstwin = 0x7fbcafa59000, tp_lastwin = 0x7fbcae0af000, tp_old_Rows = 87, tp_old_Columns = 318, tp_ch_used = 2, tp_first_diff = 0x0, tp_diffbuf = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, tp_diff_invalid = 0, tp_snapshot = {0x0, 0x0}, tp_winvar = {di_tv = {v_type = VAR_DICT, v_lock = VAR_FIXED, vval = {v_number = -1348302976, v_special = (unknown: 2946664320), v_float = 6.9390718210174743e-310, v_string = 0x7fbcafa28780 "", v_list = 0x7fbcafa28780, v_dict = 0x7fbcafa28780, v_partial = 0x7fbcafa28780}}, di_flags = 5 '\005', di_key = ""}, tp_vars = 0x7fbcafa28780, tp_localdir = 0x0}
$7 = {handle = 2, tp_next = 0x7fbcae04e8a0, tp_topframe = 0x7fbcaf5eb440, tp_curwin = 0x7fbcae162000, tp_prevwin = 0x7fbcafa59000, tp_firstwin = 0x7fbcae162000, tp_lastwin = 0x7fbcae162000, tp_old_Rows = 87, tp_old_Columns = 318, tp_ch_used = 2, tp_first_diff = 0x0, tp_diffbuf = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, tp_diff_invalid = 0, tp_snapshot = {0x0, 0x0}, tp_winvar = {di_tv = {v_type = VAR_DICT, v_lock = VAR_FIXED, vval = {v_number = -1374423040, v_special = (unknown: 2920544256), v_float = 6.9390705305148453e-310, v_string = 0x7fbcae13f800 "", v_list = 0x7fbcae13f800, v_dict = 0x7fbcae13f800, v_partial = 0x7fbcae13f800}}, di_flags = 5 '\005', di_key = ""}, tp_vars = 0x7fbcae13f800, tp_localdir = 0x0}
$8 = {handle = 3, tp_next = 0x0, tp_topframe = 0x7fbcae07d540, tp_curwin = 0x0, tp_prevwin = 0x0, tp_firstwin = 0x0, tp_lastwin = 0x0, tp_old_Rows = 0, tp_old_Columns = 0, tp_ch_used = 2, tp_first_diff = 0x0, tp_diffbuf = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, tp_diff_invalid = 0, tp_snapshot = {0x0, 0x0}, tp_winvar = {di_tv = {v_type = VAR_DICT, v_lock = VAR_FIXED, vval = {v_number = -1374422272, v_special = (unknown: 2920545024), v_float = 6.9390705305527896e-310, v_string = 0x7fbcae13fb00 "", v_list = 0x7fbcae13fb00, v_dict = 0x7fbcae13fb00, v_partial = 0x7fbcae13fb00}}, di_flags = 5 '\005', di_key = ""}, tp_vars = 0x7fbcae13fb00, tp_localdir = 0x7fbcaf566290 "/home/matthew"}
(gdb) quit
A debugging session is active.

	Inferior 1 [process 866] will be detached.

Quit anyway? (y or n) 
vshcmd: > pipe nvim-tabs | if {}->tp_localdir | show print {}->tp_localdir
$5 = (char_u *) 0x7fbcaf566290 "/home/matthew"
(gdb) 
vshcmd: > pipe nvim-tabs | nvim-windows {}
0x7fbcafa59000
0x7fbcae0af000
0x7fbcae162000
0x7fbcae1dc000
(gdb) 
vshcmd: > pipe nvim-windows
0x7fbcafa59000
0x7fbcae0af000
0x7fbcae162000
0x7fbcae1dc000
(gdb) 
vshcmd: > pipe nvim-windows curtab
0x7fbcae1dc000
(gdb) 
vshcmd: > watch main_loop.events->headtail.next
Hardware watchpoint 1: main_loop.events->headtail.next
(gdb) 
vshcmd: > cont
Continuing.

Thread 1 "nvim" hit Hardware watchpoint 1: main_loop.events->headtail.next

Old value = (struct _queue *) 0x7fbcafa182a8
New value = (struct _queue *) 0x7fbcae0bda70
QUEUE_INSERT_TAIL (h=0x7fbcafa182a8, q=0x7fbcae0bda70) at ../src/nvim/lib/queue.h:81
81	  h->prev = q;
(gdb) 
vshcmd: > bt
#0  QUEUE_INSERT_TAIL (h=0x7fbcafa182a8, q=0x7fbcae0bda70) at ../src/nvim/lib/queue.h:81
#1  0x00000000004bfd7f in multiqueue_push (this=0x7fbcafa182a0, event=...) at /home/matthew/share/repos/neovim/src/nvim/event/multiqueue.c:215
#2  0x00000000004bf8cd in multiqueue_put_event (this=0x7fbcafa182a0, event=...) at /home/matthew/share/repos/neovim/src/nvim/event/multiqueue.c:134
#3  0x00000000005a3178 in create_cursorhold_event () at /home/matthew/share/repos/neovim/src/nvim/os/input.c:89
#4  0x00000000005a3239 in os_inchar (buf=0x0, maxlen=0, ms=-1, tb_change_cnt=0) at /home/matthew/share/repos/neovim/src/nvim/os/input.c:107
#5  0x00000000006300cd in state_enter (s=0x7ffd379da2c0) at /home/matthew/share/repos/neovim/src/nvim/state.c:49
#6  0x000000000056f498 in normal_enter (cmdwin=false, noexmode=false) at /home/matthew/share/repos/neovim/src/nvim/normal.c:464
#7  0x0000000000535b50 in main (argc=3, argv=0x7ffd379da618) at /home/matthew/share/repos/neovim/src/nvim/main.c:553
(gdb) 
vshcmd: > frame 2
#2  0x00000000004bf8cd in multiqueue_put_event (this=0x7fbcafa182a0, event=...) at /home/matthew/share/repos/neovim/src/nvim/event/multiqueue.c:134
134	  multiqueue_push(this, event);
(gdb) 
vshcmd: > finish
Run till exit from #2  0x00000000004bf8cd in multiqueue_put_event (this=0x7fbcafa182a0, event=...) at /home/matthew/share/repos/neovim/src/nvim/event/multiqueue.c:134
0x00000000005a3178 in create_cursorhold_event () at /home/matthew/share/repos/neovim/src/nvim/os/input.c:89
89	  multiqueue_put(main_loop.events, cursorhold_event, 0);
(gdb) 
vshcmd: > disable 1
(gdb) 
vshcmd: > pipe nvim-mqueue main_loop.events | show print *{}
$3 = (MultiQueueItem *) 0x7fbcae0bda20
(gdb) 
vshcmd: > pipe nvim-mqueue main_loop.events; deref | show print {}
$2 = (Event *) 0x7fbcae0bda20
(gdb) 
vshcmd: > print *main_loop.events
$2 = {parent = 0x0, headtail = {next = 0x7fbcafa182a8, prev = 0x7fbcafa182a8}, put_cb = 0x4bf2ce <loop_on_put>, data = 0x9af420 <main_loop>, size = 13}
(gdb) 
vshcmd: > break stuff_inserted
Breakpoint 2 at 0x47149d: file /home/matthew/share/repos/neovim/src/nvim/edit.c, line 6338.
(gdb) 
vshcmd: > cont
Continuing.

Thread 1 "nvim" hit Breakpoint 2, stuff_inserted (c=97, count=1, no_esc=0) at /home/matthew/share/repos/neovim/src/nvim/edit.c:6338
6338	  char_u last = NUL;
(gdb) 
vshcmd: > bt
#0  stuff_inserted (c=97, count=1, no_esc=0) at /home/matthew/share/repos/neovim/src/nvim/edit.c:6338
#1  0x00000000005860db in do_put (regname=46, reg=0x0, dir=1, count=1, flags=0) at /home/matthew/share/repos/neovim/src/nvim/ops.c:2673
#2  0x000000000057f80f in nv_put (cap=0x7ffd379da360) at /home/matthew/share/repos/neovim/src/nvim/normal.c:7765
#3  0x00000000005711c1 in normal_execute (state=0x7ffd379da2c0, key=112) at /home/matthew/share/repos/neovim/src/nvim/normal.c:1135
#4  0x000000000063011b in state_enter (s=0x7ffd379da2c0) at /home/matthew/share/repos/neovim/src/nvim/state.c:58
#5  0x000000000056f498 in normal_enter (cmdwin=false, noexmode=false) at /home/matthew/share/repos/neovim/src/nvim/normal.c:464
#6  0x0000000000535b50 in main (argc=3, argv=0x7ffd379da618) at /home/matthew/share/repos/neovim/src/nvim/main.c:553
(gdb) 
vshcmd: > up
#1  0x00000000005860db in do_put (regname=46, reg=0x0, dir=1, count=1, flags=0) at /home/matthew/share/repos/neovim/src/nvim/ops.c:2673
2673	      (void)stuff_inserted(command_start_char, count, false);
(gdb) 
vshcmd: > finish
Run till exit from #1  0x00000000005860db in do_put (regname=46, reg=0x0, dir=1, count=1, flags=0) at /home/matthew/share/repos/neovim/src/nvim/ops.c:2673
nv_put (cap=0x7ffd379da360) at /home/matthew/share/repos/neovim/src/nvim/normal.c:7768
7768	    if (savereg != NULL) {
(gdb) 
vshcmd: > pipe nvim-buffblocks &readbuf1 | show printf "%s\n", {}->b_str

ahello there
(gdb) 
vshcmd: > pipe array mapblock_T *; maphash; 256 | eval *{} | if {} != 0 | nvim-mapblock | show print-string {}->m_keys; "  -->  "; {}->m_str; "\n"
\x80\xfdRvimple_completers_trigger  -->  complete#trigger('completers#trigger')
\x80k3  -->  =UltiSnips#ListSnippets()
\x80\xfdRISurround  -->  =\x80\xfdQ95_insert(1)
\x80\xfdRIsurround  -->  =\x80\xfdQ95_insert()
\x80\xfdR(sexp_insert_backspace)  -->  sexp#backspace_insertion()
\x80\xfdR(sexp_insert_double_quote)  -->  sexp#quote_insertion('"')
\x80\xfdR(sexp_insert_closing_curly)  -->  sexp#closing_insertion('}')
\x80\xfdR(sexp_insert_closing_square)  -->  sexp#closing_insertion(']')
\x80\xfdR(sexp_insert_closing_round)  -->  sexp#closing_insertion(')')
\x80\xfdR(sexp_insert_opening_curly)  -->  sexp#opening_insertion('{')
\x80\xfdR(sexp_insert_opening_square)  -->  sexp#opening_insertion('[')
\x80\xfdR(sexp_insert_opening_round)  -->  sexp#opening_insertion('(')
\x80\xfdRremove_vimple_completers_trigger  -->  \x80\xfdRvimple_completers_trigger
\x80\xfco  -->  o
\x80\xfcO  -->  O
  -->  c
	  -->  :call UltiSnips#SaveLastVisualSelection()gvs
	  -->  :call UltiSnips#ExpandSnippet()
  -->  :nohlsearch:diffupdate:syntax sync fromstart
  -->  "_c
  -->  \x80\xfdR(RepeatRedo)
 wl  -->  :call  \x80\xfdQ54_MoveWindow('l')
 wk  -->  :call  \x80\xfdQ54_MoveWindow('k')
 wj  -->  :call  \x80\xfdQ54_MoveWindow('j')
 wh  -->  :call  \x80\xfdQ54_MoveWindow('h')
 st  -->  :silent TQFSelect! 
 qd  -->  :QFilterBuf! %
 qb  -->  :QFilterBuf %
 qs  -->  :QuickfixSort
 qr  -->  :QFRemoveCurrent!
 ll  -->  \x80\xfdRvimple_filter
 mu  -->  \x80\xfdRVimpleMRU
 mb  -->  :VFMBadd
 mc  -->  \x80\xfdRvfm_browse_bufs
 mp  -->  \x80\xfdRvfm_browse_paths
 md  -->  \x80\xfdRvfm_browse_dirs
 ma  -->  \x80\xfdRvfm_browse_args
 me  -->  \x80\xfdRvfm_browse_files
 rk  -->  :SyntasticReset
 ok  -->  :SyntasticCheck
 al  -->  :SidewaysRight
 ah  -->  :SidewaysLeft
 pk  -->  :PymodeLint
 hq  -->  :Hgqseries
 hv  -->  :Hglogthis
 hg  -->  :Hglog
 hs  -->  :Hgstatus
 hc  -->  :Hgcommit
 hf  -->  :Hgpull
 hp  -->  :Hgpush
 hd  -->  :Hgvdiff
 sb  -->  :GrepBufs 
 sd  -->  :GrepHere 
 sg  -->  :Grepper -tool git 
 ss  -->  :Grepper -tool grep 
 so  -->  \x80\xfdR(GrepperOperator)
 so  -->  \x80\xfdR(GrepperOperator)
 gv  -->  :Gitv! --all
 gv  -->  :Gitv! --all
 gg  -->  :Gitv --all
 cpf  -->  :CtrlPFunky
 gs  -->  :Gstatus
 gc  -->  :Gcommit
 gf  -->  :Gpurr
 gp  -->  :Gpush
 gd  -->  :Gdiff
 gw  -->  :Gwrite
 fd  -->  :DiffOrig
 ff  -->  :Find 
 fm  -->  :Rename 
 fr  -->  :Unlink
 cpm  -->  :CtrlPMRU
 cpu  -->  :CtrlPUndo
 cpt  -->  :CtrlPTag
 cpq  -->  :CtrlPQuickfix
 cpc  -->  :CtrlPChange
 cpb  -->  :CtrlPBuffer
 mm  -->  \x80\xfdRvfm_argument
 z  -->  :
 '  -->  :
 cn  -->  :setlocal completeopt-=longest
 cl  -->  :setlocal completeopt+=longest
 nh  -->  :nohlsearch
 sh  -->  :Occur! 
 u  -->  :update
 b  -->  :ls:b 
 em  -->  :='let @'. v:register .' = '. string(getreg(v:register))\x80kl
#  -->  \x80\xfdR(visualstar-#)
'\x80\xfd,  -->  \x80\xfd,
'  -->  `
*  -->  \x80\xfdR(visualstar-*)
++  -->  VMATH_YankAndAnalyse()
,  -->  \x80\xfdRSneakNext
,  -->  \x80\xfdRSneakNext
,  -->  \x80\xfdRSneakNext
,  -->  \x80\xfdRSneakNext
.  -->  \x80\xfdR(RepeatDot)
;  -->  \x80\xfdRSneakPrevious
;  -->  \x80\xfdRSneakPrevious
;  -->  \x80\xfdRSneakPrevious
;  -->  \x80\xfdRSneakPrevious
<p  -->  :call \x80\xfdQ110_putline(']p', 'Below')<']
<P  -->  :call \x80\xfdQ110_putline('[p', 'Above')<']
<  -->  <gv
=p  -->  :call \x80\xfdQ110_putline(']p', 'Below')=']
=P  -->  :call \x80\xfdQ110_putline('[p', 'Above')=']
>p  -->  :call \x80\xfdQ110_putline(']p', 'Below')>']
>P  -->  :call \x80\xfdQ110_putline('[p', 'Above')>']
>  -->  >gv
D  -->  DVB_Duplicate()
F\x80\xfd2  -->  \x80\xfd,:silent Occur! 
Q  -->  :call \x80\xfdQ2_Again()
S  -->  \x80\xfdRVSurround
S  -->  \x80\xfdRSneak_S
T\x80\xfd2  -->  \x80\xfd,:silent TQFSelect! 
U  -->  \x80\xfdR(RepeatUndoLine)
U  -->  \x80\xfdRSneak_S
X  -->  \x80\xfdR(Exchange)
Y  -->  y$
Z  -->  \x80\xfdRSneak_S
[xx  -->  \x80\xfdRunimpaired_line_xml_encode
[x  -->  \x80\xfdRunimpaired_xml_encode
[x  -->  \x80\xfdRunimpaired_xml_encode
[uu  -->  \x80\xfdRunimpaired_line_url_encode
[u  -->  \x80\xfdRunimpaired_url_encode
[u  -->  \x80\xfdRunimpaired_url_encode
[yy  -->  \x80\xfdRunimpaired_line_string_encode
[y  -->  \x80\xfdRunimpaired_string_encode
[y  -->  \x80\xfdRunimpaired_string_encode
[p  -->  \x80\xfdRunimpairedPutAbove
[ov  -->  :set virtualedit+=all
[ox  -->  :set cursorline cursorcolumn
[ow  -->  :setlocal wrap=\x80\xfdQ110_statusbump()
[os  -->  :setlocal spell=\x80\xfdQ110_statusbump()
[or  -->  :setlocal relativenumber=\x80\xfdQ110_statusbump()
[on  -->  :setlocal number=\x80\xfdQ110_statusbump()
[ol  -->  :setlocal list=\x80\xfdQ110_statusbump()
[oi  -->  :set ignorecase=\x80\xfdQ110_statusbump()
[oh  -->  :set hlsearch=\x80\xfdQ110_statusbump()
[od  -->  :diffthis
[ou  -->  :setlocal cursorcolumn=\x80\xfdQ110_statusbump()
[oc  -->  :setlocal cursorline=\x80\xfdQ110_statusbump()
[ob  -->  :set background=light
[e  -->  \x80\xfdRunimpairedMoveSelectionUp
[e  -->  \x80\xfdRunimpairedMoveUp
[   -->  \x80\xfdRunimpairedBlankUp
[n  -->  \x80\xfdRunimpairedContextPrevious
[n  -->  \x80\xfdRunimpairedContextPrevious
[f  -->  \x80\xfdRunimpairedDirectoryPrevious
[T  -->  \x80\xfdRunimpairedTFirst
[t  -->  \x80\xfdRunimpairedTPrevious
[  -->  \x80\xfdRunimpairedQPFile
[Q  -->  \x80\xfdRunimpairedQFirst
[q  -->  \x80\xfdRunimpairedQPrevious
[  -->  \x80\xfdRunimpairedLPFile
[L  -->  \x80\xfdRunimpairedLFirst
[l  -->  \x80\xfdRunimpairedLPrevious
[B  -->  \x80\xfdRunimpairedBFirst
[b  -->  \x80\xfdRunimpairedBPrevious
[A  -->  \x80\xfdRunimpairedAFirst
[a  -->  \x80\xfdRunimpairedAPrevious
[ok  -->  :call \x80\xfdQ25_UseVimForMan()
]xx  -->  \x80\xfdRunimpaired_line_xml_decode
]x  -->  \x80\xfdRunimpaired_xml_decode
]x  -->  \x80\xfdRunimpaired_xml_decode
]uu  -->  \x80\xfdRunimpaired_line_url_decode
]u  -->  \x80\xfdRunimpaired_url_decode
]u  -->  \x80\xfdRunimpaired_url_decode
]yy  -->  \x80\xfdRunimpaired_line_string_decode
]y  -->  \x80\xfdRunimpaired_string_decode
]y  -->  \x80\xfdRunimpaired_string_decode
]p  -->  \x80\xfdRunimpairedPutBelow
]ov  -->  :set virtualedit-=all
]ox  -->  :set nocursorline nocursorcolumn
]ow  -->  :setlocal nowrap=\x80\xfdQ110_statusbump()
]os  -->  :setlocal nospell=\x80\xfdQ110_statusbump()
]or  -->  :setlocal norelativenumber=\x80\xfdQ110_statusbump()
]on  -->  :setlocal nonumber=\x80\xfdQ110_statusbump()
]ol  -->  :setlocal nolist=\x80\xfdQ110_statusbump()
]oi  -->  :set noignorecase=\x80\xfdQ110_statusbump()
]oh  -->  :set nohlsearch=\x80\xfdQ110_statusbump()
]od  -->  :diffoff
]ou  -->  :setlocal nocursorcolumn=\x80\xfdQ110_statusbump()
]oc  -->  :setlocal nocursorline=\x80\xfdQ110_statusbump()
]ob  -->  :set background=dark
]e  -->  \x80\xfdRunimpairedMoveSelectionDown
]e  -->  \x80\xfdRunimpairedMoveDown
]   -->  \x80\xfdRunimpairedBlankDown
]n  -->  \x80\xfdRunimpairedContextNext
]n  -->  \x80\xfdRunimpairedContextNext
]f  -->  \x80\xfdRunimpairedDirectoryNext
]T  -->  \x80\xfdRunimpairedTLast
]t  -->  \x80\xfdRunimpairedTNext
]  -->  \x80\xfdRunimpairedQNFile
]Q  -->  \x80\xfdRunimpairedQLast
]q  -->  \x80\xfdRunimpairedQNext
]  -->  \x80\xfdRunimpairedLNFile
]L  -->  \x80\xfdRunimpairedLLast
]l  -->  \x80\xfdRunimpairedLNext
]B  -->  \x80\xfdRunimpairedBLast
]b  -->  \x80\xfdRunimpairedBNext
]A  -->  \x80\xfdRunimpairedALast
]a  -->  \x80\xfdRunimpairedANext
]ok  -->  :unmap <buffer> K
`  -->  '
aI  -->  \x80\xfdR(OuterDENTURE)
aI  -->  \x80\xfdR(OuterDENTURE)
ai  -->  \x80\xfdR(OuterDenture)
ai  -->  \x80\xfdR(OuterDenture)
aa  -->  \x80\xfdRSidewaysArgumentTextobjA
aa  -->  \x80\xfdRSidewaysArgumentTextobjA
cov  -->  :set =(&virtualedit =~# "all") ? 'virtualedit-=all' : 'virtualedit+=all'
cox  -->  :set =&cursorline && &cursorcolumn ? 'nocursorline nocursorcolumn' : 'cursorline cursorcolumn'
cow  -->  :setlocal =\x80\xfdQ110_toggle("wrap")
cos  -->  :setlocal =\x80\xfdQ110_toggle("spell")
cor  -->  :setlocal =\x80\xfdQ110_toggle("relativenumber")
con  -->  :setlocal =\x80\xfdQ110_toggle("number")
col  -->  :setlocal =\x80\xfdQ110_toggle("list")
coi  -->  :set =\x80\xfdQ110_toggle("ignorecase")
coh  -->  :set =\x80\xfdQ110_toggle("hlsearch")
cod  -->  :=&diff ? 'diffoff' : 'diffthis'
cou  -->  :setlocal =\x80\xfdQ110_toggle("cursorcolumn")
coc  -->  :setlocal =\x80\xfdQ110_toggle("cursorline")
cob  -->  :set background==&background == 'dark' ? 'light' : 'dark'
cS  -->  \x80\xfdRCSurround
cs  -->  \x80\xfdRCsurround
cxx  -->  \x80\xfdR(ExchangeLine)
cxc  -->  \x80\xfdR(ExchangeClear)
cx  -->  \x80\xfdR(Exchange)
cgc  -->  \x80\xfdRChangeCommentary
cr  -->  \x80\xfdRCoerce
cw  -->  dwi
ds  -->  \x80\xfdRDsurround
f\x80\xfd2  -->  \x80\xfd,:silent Occur 
gs  -->  \x80\xfdR(submode-before-entering:scrolling:with:gs)\x80\xfdR(submode-before-entering:scrolling)\x80\xfdR(submode-enter:scrolling)
g  -->  \x80\xfdR(submode-before-entering:windows:with:g)\x80\xfdR(submode-before-entering:windows)\x80\xfdR(submode-enter:windows)
g+  -->  \x80\xfdR(submode-before-entering:undo/redo:with:g+)\x80\xfdR(submode-before-entering:undo/redo)\x80\xfdR(submode-enter:undo/redo)
g-  -->  \x80\xfdR(submode-before-entering:undo/redo:with:g-)\x80\xfdR(submode-before-entering:undo/redo)\x80\xfdR(submode-enter:undo/redo)
gx  -->  \x80\xfdRNetrwBrowseXVis
gx  -->  \x80\xfdRNetrwBrowseX
g#  -->  \x80\xfdR(visualstar-g#)
g\x80\xfc\x80\xfd,  -->  \x80\xfdR(visualstar-g*)
g\x80K9  -->  \x80\xfdR(visualstar-g*)
g*  -->  \x80\xfdR(visualstar-g*)
gS  -->  \x80\xfdRVgSurround
gcu  -->  \x80\xfdRCommentary\x80\xfdRCommentary
gcc  -->  \x80\xfdRCommentaryLine
gc  -->  \x80\xfdRCommentary
gc  -->  \x80\xfdRCommentary
gc  -->  \x80\xfdRCommentary
gk  -->  @='4k'
gj  -->  @='4j'
g6  -->  :exe 6 . "wincmd w"
g5  -->  :exe 5 . "wincmd w"
g4  -->  :exe 4 . "wincmd w"
g3  -->  :exe 3 . "wincmd w"
g2  -->  :exe 2 . "wincmd w"
g1  -->  :exe 1 . "wincmd w"
gV  -->  "`[".getregtype(v:register)[0]."`]"
iI  -->  \x80\xfdR(InnerDENTURE)
iI  -->  \x80\xfdR(InnerDENTURE)
ii  -->  \x80\xfdR(InnerDenture)
ii  -->  \x80\xfdR(InnerDenture)
ia  -->  \x80\xfdRSidewaysArgumentTextobjI
ia  -->  \x80\xfdRSidewaysArgumentTextobjI
q\x80\xfd,  -->  	
q\x80\xfd2  -->  
s  -->  \x80\xfdRSneak_s
s  -->  \x80\xfdRSneak_s
t\x80\xfd2  -->  \x80\xfd,:silent TQFSelect 
u  -->  \x80\xfdR(RepeatUndo)
u  -->  \x80\xfdRSneak_s
yO  -->  :call \x80\xfdQ110_setup_paste()O
yo  -->  :call \x80\xfdQ110_setup_paste()o
ySS  -->  \x80\xfdRYSsurround
ySs  -->  \x80\xfdRYSsurround
yss  -->  \x80\xfdRYssurround
yS  -->  \x80\xfdRYSurround
ys  -->  \x80\xfdRYsurround
zf  -->  \x80\xfdR(submode-before-entering:folds:with:zf)\x80\xfdR(submode-before-entering:folds)\x80\xfdR(submode-enter:folds)
zw  -->  ysiw
\x80F1  -->  :!cscope -Rb:cs reset
\x80\xfdR(submode-rhs:scrolling:for:b)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â b  -->  \x80\xfdR(submode-rhs:scrolling:for:b)\x80\xfdR(submode-enter:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:f)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â f  -->  \x80\xfdR(submode-rhs:scrolling:for:f)\x80\xfdR(submode-enter:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:u)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â u  -->  \x80\xfdR(submode-rhs:scrolling:for:u)\x80\xfdR(submode-enter:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:d)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â d  -->  \x80\xfdR(submode-rhs:scrolling:for:d)\x80\xfdR(submode-enter:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:k)  -->  10
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â k  -->  \x80\xfdR(submode-rhs:scrolling:for:k)\x80\xfdR(submode-enter:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:j)  -->  10
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â j  -->  \x80\xfdR(submode-rhs:scrolling:for:j)\x80\xfdR(submode-enter:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:y)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â y  -->  \x80\xfdR(submode-rhs:scrolling:for:y)\x80\xfdR(submode-enter:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:e)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â e  -->  \x80\xfdR(submode-rhs:scrolling:for:e)\x80\xfdR(submode-enter:scrolling)
\x80\xfdR(submode-leave:scrolling)  -->  @=\x80\xfdQ146_on_leaving_submode('scrolling')
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â   -->  \x80\xfdR(submode-leave:scrolling)
\x80\xfdR(submode-before-action:scrolling)  -->  \x80\xfdQ146_on_executing_action('scrolling')
\x80\xfdR(submode-enter:scrolling)  -->  \x80\xfdR(submode-before-action:scrolling)\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â 
\x80\xfdR(submode-before-entering:scrolling)  -->  \x80\xfdQ146_on_entering_submode('scrolling')
\x80\xfdR(submode-before-entering:scrolling:with:gs)  -->  jk
\x80\xfdR(submode-rhs:scrolling:for:q)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â q  -->  \x80\xfdR(submode-rhs:scrolling:for:q)\x80\xfdR(submode-leave:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â   -->  \x80\xfdR(submode-rhs:scrolling:for:)\x80\xfdR(submode-leave:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â   -->  \x80\xfdR(submode-rhs:scrolling:for:)\x80\xfdR(submode-leave:scrolling)
\x80\xfdR(submode-rhs:folds:for:z)  -->  zz
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â z  -->  \x80\xfdR(submode-rhs:folds:for:z)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:b)  -->  zb
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â b  -->  \x80\xfdR(submode-rhs:folds:for:b)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:t)  -->  zt
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â t  -->  \x80\xfdR(submode-rhs:folds:for:t)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:C)  -->  zC
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â C  -->  \x80\xfdR(submode-rhs:folds:for:C)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:c)  -->  zc
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â c  -->  \x80\xfdR(submode-rhs:folds:for:c)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:O)  -->  zO
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â O  -->  \x80\xfdR(submode-rhs:folds:for:O)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:o)  -->  zo
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â o  -->  \x80\xfdR(submode-rhs:folds:for:o)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:v)  -->  zv
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â v  -->  \x80\xfdR(submode-rhs:folds:for:v)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:x)  -->  zx
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â x  -->  \x80\xfdR(submode-rhs:folds:for:x)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:R)  -->  zR
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â R  -->  \x80\xfdR(submode-rhs:folds:for:R)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:r)  -->  zr
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â r  -->  \x80\xfdR(submode-rhs:folds:for:r)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:M)  -->  zM
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â M  -->  \x80\xfdR(submode-rhs:folds:for:M)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:m)  -->  zm
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â m  -->  \x80\xfdR(submode-rhs:folds:for:m)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:6)  -->  6w
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â 6  -->  \x80\xfdR(submode-rhs:folds:for:6)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:5)  -->  5w
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â 5  -->  \x80\xfdR(submode-rhs:folds:for:5)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:4)  -->  4w
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â 4  -->  \x80\xfdR(submode-rhs:folds:for:4)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:3)  -->  3w
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â 3  -->  \x80\xfdR(submode-rhs:folds:for:3)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:2)  -->  2w
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â 2  -->  \x80\xfdR(submode-rhs:folds:for:2)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:1)  -->  1w
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â 1  -->  \x80\xfdR(submode-rhs:folds:for:1)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:])  -->  ]z
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â ]  -->  \x80\xfdR(submode-rhs:folds:for:])\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:[)  -->  [z
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â [  -->  \x80\xfdR(submode-rhs:folds:for:[)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:k)  -->  zk
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â k  -->  \x80\xfdR(submode-rhs:folds:for:k)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:j)  -->  zj
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â j  -->  \x80\xfdR(submode-rhs:folds:for:j)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-leave:folds)  -->  @=\x80\xfdQ146_on_leaving_submode('folds')
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â   -->  \x80\xfdR(submode-leave:folds)
\x80\xfdR(submode-before-action:folds)  -->  \x80\xfdQ146_on_executing_action('folds')
\x80\xfdR(submode-enter:folds)  -->  \x80\xfdR(submode-before-action:folds)\x80\xfdR(submode-prefix:folds)Â Â Â Â Â 
\x80\xfdR(submode-before-entering:folds)  -->  \x80\xfdQ146_on_entering_submode('folds')
\x80\xfdR(submode-before-entering:folds:with:zf)  -->  jk
\x80\xfdR(submode-rhs:folds:for:q)  -->  
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â q  -->  \x80\xfdR(submode-rhs:folds:for:q)\x80\xfdR(submode-leave:folds)
\x80\xfdR(submode-rhs:folds:for:)  -->  
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â   -->  \x80\xfdR(submode-rhs:folds:for:)\x80\xfdR(submode-leave:folds)
\x80\xfdR(submode-rhs:folds:for:)  -->  
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â   -->  \x80\xfdR(submode-rhs:folds:for:)\x80\xfdR(submode-leave:folds)
\x80\xfdR(submode-rhs:windows:for:T)  -->  T
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â T  -->  \x80\xfdR(submode-rhs:windows:for:T)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:L)  -->  L
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â L  -->  \x80\xfdR(submode-rhs:windows:for:L)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:K)  -->  K
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â K  -->  \x80\xfdR(submode-rhs:windows:for:K)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:J)  -->  J
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â J  -->  \x80\xfdR(submode-rhs:windows:for:J)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:H)  -->  H
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â H  -->  \x80\xfdR(submode-rhs:windows:for:H)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:x)  -->  x
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â x  -->  \x80\xfdR(submode-rhs:windows:for:x)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:R)  -->  R
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â R  -->  \x80\xfdR(submode-rhs:windows:for:R)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:r)  -->  r
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â r  -->  \x80\xfdR(submode-rhs:windows:for:r)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:o)  -->  o
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â o  -->  \x80\xfdR(submode-rhs:windows:for:o)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:c)  -->  c
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â c  -->  \x80\xfdR(submode-rhs:windows:for:c)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:=)  -->  =
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â =  -->  \x80\xfdR(submode-rhs:windows:for:=)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:_)  -->  10-
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â _  -->  \x80\xfdR(submode-rhs:windows:for:_)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:+)  -->  10+
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â +  -->  \x80\xfdR(submode-rhs:windows:for:+)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:[)  -->  -
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â [  -->  \x80\xfdR(submode-rhs:windows:for:[)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:])  -->  +
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â ]  -->  \x80\xfdR(submode-rhs:windows:for:])\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:<)  -->  10<
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â <  -->  \x80\xfdR(submode-rhs:windows:for:<)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:>)  -->  10>
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â >  -->  \x80\xfdR(submode-rhs:windows:for:>)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:,)  -->  <
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â ,  -->  \x80\xfdR(submode-rhs:windows:for:,)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:.)  -->  >
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â .  -->  \x80\xfdR(submode-rhs:windows:for:.)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:s)  -->  s
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â s  -->  \x80\xfdR(submode-rhs:windows:for:s)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:v)  -->  v
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â v  -->  \x80\xfdR(submode-rhs:windows:for:v)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:6)  -->  6w
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â 6  -->  \x80\xfdR(submode-rhs:windows:for:6)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:5)  -->  5w
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â 5  -->  \x80\xfdR(submode-rhs:windows:for:5)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:4)  -->  4w
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â 4  -->  \x80\xfdR(submode-rhs:windows:for:4)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:3)  -->  3w
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â 3  -->  \x80\xfdR(submode-rhs:windows:for:3)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:2)  -->  2w
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â 2  -->  \x80\xfdR(submode-rhs:windows:for:2)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:1)  -->  1w
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â 1  -->  \x80\xfdR(submode-rhs:windows:for:1)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:p)  -->  p
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â p  -->  \x80\xfdR(submode-rhs:windows:for:p)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:b)  -->  b
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â b  -->  \x80\xfdR(submode-rhs:windows:for:b)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:t)  -->  t
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â t  -->  \x80\xfdR(submode-rhs:windows:for:t)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:l)  -->  l
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â l  -->  \x80\xfdR(submode-rhs:windows:for:l)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:k)  -->  k
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â k  -->  \x80\xfdR(submode-rhs:windows:for:k)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:j)  -->  j
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â j  -->  \x80\xfdR(submode-rhs:windows:for:j)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:h)  -->  h
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â h  -->  \x80\xfdR(submode-rhs:windows:for:h)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-leave:windows)  -->  @=\x80\xfdQ146_on_leaving_submode('windows')
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â   -->  \x80\xfdR(submode-leave:windows)
\x80\xfdR(submode-before-action:windows)  -->  \x80\xfdQ146_on_executing_action('windows')
\x80\xfdR(submode-enter:windows)  -->  \x80\xfdR(submode-before-action:windows)\x80\xfdR(submode-prefix:windows)Â Â Â Â Â 
\x80\xfdR(submode-before-entering:windows)  -->  \x80\xfdQ146_on_entering_submode('windows')
\x80\xfdR(submode-before-entering:windows:with:g)  -->  jk
\x80\xfdR(submode-rhs:windows:for:q)  -->  
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â q  -->  \x80\xfdR(submode-rhs:windows:for:q)\x80\xfdR(submode-leave:windows)
\x80\xfdR(submode-rhs:windows:for:)  -->  
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â   -->  \x80\xfdR(submode-rhs:windows:for:)\x80\xfdR(submode-leave:windows)
\x80\xfdR(submode-rhs:windows:for:)  -->  
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â   -->  \x80\xfdR(submode-rhs:windows:for:)\x80\xfdR(submode-leave:windows)
\x80\xfdR(submode-rhs:undo/redo:for:+)  -->  g+
\x80\xfdR(submode-prefix:undo/redo)Â Â Â Â Â +  -->  \x80\xfdR(submode-rhs:undo/redo:for:+)\x80\xfdR(submode-enter:undo/redo)
\x80\xfdR(submode-rhs:undo/redo:for:-)  -->  g-
\x80\xfdR(submode-prefix:undo/redo)Â Â Â Â Â -  -->  \x80\xfdR(submode-rhs:undo/redo:for:-)\x80\xfdR(submode-enter:undo/redo)
\x80\xfdR(submode-before-entering:undo/redo:with:g+)  -->  g+
\x80\xfdR(submode-leave:undo/redo)  -->  @=\x80\xfdQ146_on_leaving_submode('undo/redo')
\x80\xfdR(submode-prefix:undo/redo)Â Â Â Â Â   -->  \x80\xfdR(submode-leave:undo/redo)
\x80\xfdR(submode-before-action:undo/redo)  -->  \x80\xfdQ146_on_executing_action('undo/redo')
\x80\xfdR(submode-enter:undo/redo)  -->  \x80\xfdR(submode-before-action:undo/redo)\x80\xfdR(submode-prefix:undo/redo)Â Â Â Â Â 
\x80\xfdR(submode-before-entering:undo/redo)  -->  \x80\xfdQ146_on_entering_submode('undo/redo')
\x80\xfdR(submode-before-entering:undo/redo:with:g-)  -->  g-
\x80\xfdR(submode-rhs:undo/redo:for:q)  -->  
\x80\xfdR(submode-prefix:undo/redo)Â Â Â Â Â q  -->  \x80\xfdR(submode-rhs:undo/redo:for:q)\x80\xfdR(submode-leave:undo/redo)
\x80\xfdR(submode-rhs:undo/redo:for:)  -->  
\x80\xfdR(submode-prefix:undo/redo)Â Â Â Â Â   -->  \x80\xfdR(submode-rhs:undo/redo:for:)\x80\xfdR(submode-leave:undo/redo)
\x80\xfdR(submode-rhs:undo/redo:for:)  -->  
\x80\xfdR(submode-prefix:undo/redo)Â Â Â Â Â   -->  \x80\xfdR(submode-rhs:undo/redo:for:)\x80\xfdR(submode-leave:undo/redo)
\x80\xfdRNetrwBrowseXVis  -->  :call netrw#BrowseXVis()
\x80\xfdRNetrwBrowseX  -->  :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())
\x80K9  -->  \x80\xfdR(visualstar-*)
\x80\xfdQ124_(extra_commands)  -->  \x80\xfdQ124_extra_commands()
\x80\xfdQ124_(count)  -->  \x80\xfdQ124_count()
\x80\xfdR(visualstar-g#)  -->  :call \x80\xfdQ124_search('?', 1)\x80\xfdQ124_(count)\x80\xfdQ124_(extra_commands)
\x80\xfdR(visualstar-g*)  -->  :call \x80\xfdQ124_search('/', 1)\x80\xfdQ124_(count)\x80\xfdQ124_(extra_commands)
\x80\xfdR(visualstar-#)  -->  :call \x80\xfdQ124_search('?', 0)\x80\xfdQ124_(count)\x80\xfdQ124_(extra_commands)
\x80\xfdR(visualstar-*)  -->  :call \x80\xfdQ124_search('/', 0)\x80\xfdQ124_(count)\x80\xfdQ124_(extra_commands)
\x80\xfdR(visualstar-g#)  -->  g#
\x80\xfdR(visualstar-g*)  -->  g*
\x80\xfdR(visualstar-#)  -->  #
\x80\xfdR(visualstar-*)  -->  *
\x80\xfdRVimpleMRU  -->  :echo vimple#undolist#print_mru() . "\n":buffer 
\x80\xfdRvimple_filter  -->  :Filter
\x80\xfdRvimple_spell_suggest  -->  :call SpellSuggest(expand('<cword>'))
\x80\xfdRvimple_ident_search_forward  -->  :call IdentSearch(1)
\x80\xfdRvimple_ident_search  -->  :call IdentSearch(0)
\x80\xfdRvimple_tag_search  -->  :call TagSearch()
\x80\xfdRvfm_argument  -->  :call feedkeys(":VFMArgument \")
\x80\xfdRvfm_browse_bufs  -->  :VFMBufs
\x80\xfdRvfm_browse_args  -->  :VFMArglist
\x80\xfdRvfm_browse_paths  -->  :call VimFindsMeOpts('&path')
\x80\xfdRvfm_browse_dirs  -->  :VFMCD
\x80\xfdRvfm_browse_files  -->  :VFMEdit
\x80\xfdRunimpaired_line_xml_decode  -->  :call \x80\xfdQ110_Transform("xml_decode",v:count1)
\x80\xfdRunimpaired_xml_decode  -->  :call \x80\xfdQ110_Transform("xml_decode",visualmode())
\x80\xfdRunimpaired_xml_decode  -->  :call \x80\xfdQ110_TransformSetup("xml_decode")g@
\x80\xfdRunimpaired_line_xml_encode  -->  :call \x80\xfdQ110_Transform("xml_encode",v:count1)
\x80\xfdRunimpaired_xml_encode  -->  :call \x80\xfdQ110_Transform("xml_encode",visualmode())
\x80\xfdRunimpaired_xml_encode  -->  :call \x80\xfdQ110_TransformSetup("xml_encode")g@
\x80\xfdRunimpaired_line_url_decode  -->  :call \x80\xfdQ110_Transform("url_decode",v:count1)
\x80\xfdRunimpaired_url_decode  -->  :call \x80\xfdQ110_Transform("url_decode",visualmode())
\x80\xfdRunimpaired_url_decode  -->  :call \x80\xfdQ110_TransformSetup("url_decode")g@
\x80\xfdRunimpaired_line_url_encode  -->  :call \x80\xfdQ110_Transform("url_encode",v:count1)
\x80\xfdRunimpaired_url_encode  -->  :call \x80\xfdQ110_Transform("url_encode",visualmode())
\x80\xfdRunimpaired_url_encode  -->  :call \x80\xfdQ110_TransformSetup("url_encode")g@
\x80\xfdRunimpaired_line_string_decode  -->  :call \x80\xfdQ110_Transform("string_decode",v:count1)
\x80\xfdRunimpaired_string_decode  -->  :call \x80\xfdQ110_Transform("string_decode",visualmode())
\x80\xfdRunimpaired_string_decode  -->  :call \x80\xfdQ110_TransformSetup("string_decode")g@
\x80\xfdRunimpaired_line_string_encode  -->  :call \x80\xfdQ110_Transform("string_encode",v:count1)
\x80\xfdRunimpaired_string_encode  -->  :call \x80\xfdQ110_Transform("string_encode",visualmode())
\x80\xfdRunimpaired_string_encode  -->  :call \x80\xfdQ110_TransformSetup("string_encode")g@
\x80\xfdRunimpairedPutBelow  -->  :call \x80\xfdQ110_putline(']p', 'Below')
\x80\xfdRunimpairedPutAbove  -->  :call \x80\xfdQ110_putline('[p', 'Above')
\x80\xfdRunimpairedPaste  -->  :call \x80\xfdQ110_setup_paste()
\x80\xfdRunimpairedMoveSelectionDown  -->  :call \x80\xfdQ110_MoveSelectionDown(v:count1)
\x80\xfdRunimpairedMoveSelectionUp  -->  :call \x80\xfdQ110_MoveSelectionUp(v:count1)
\x80\xfdRunimpairedMoveDown  -->  :call \x80\xfdQ110_Move('+',v:count1,'Down')
\x80\xfdRunimpairedMoveUp  -->  :call \x80\xfdQ110_Move('--',v:count1,'Up')
\x80\xfdRunimpairedBlankDown  -->  :call \x80\xfdQ110_BlankDown(v:count1)
\x80\xfdRunimpairedBlankUp  -->  :call \x80\xfdQ110_BlankUp(v:count1)
\x80\xfdRunimpairedContextNext  -->  :call \x80\xfdQ110_ContextMotion(0)
\x80\xfdRunimpairedContextPrevious  -->  :call \x80\xfdQ110_ContextMotion(1)
\x80\xfdRunimpairedContextNext  -->  :call \x80\xfdQ110_Context(0)
\x80\xfdRunimpairedContextPrevious  -->  :call \x80\xfdQ110_Context(1)
\x80\xfdRunimpairedOPrevious  -->  \x80\xfdRunimpairedDirectoryPrevious:echohl WarningMSG|echo "[o is deprecated. Use [f"|echohl NONE
\x80\xfdRunimpairedONext  -->  \x80\xfdRunimpairedDirectoryNext:echohl WarningMSG|echo "]o is deprecated. Use ]f"|echohl NONE
\x80\xfdRunimpairedDirectoryPrevious  -->  :edit =fnamemodify(\x80\xfdQ110_fnameescape(\x80\xfdQ110_FileByOffset(-v:count1)), ':.')
\x80\xfdRunimpairedDirectoryNext  -->  :edit =fnamemodify(\x80\xfdQ110_fnameescape(\x80\xfdQ110_FileByOffset(v:count1)), ':.')
\x80\xfdRunimpairedTLast  -->  :exe "".(v:count ? v:count : "")."tlast"
\x80\xfdRunimpairedTFirst  -->  :exe "".(v:count ? v:count : "")."tfirst"
\x80\xfdRunimpairedTNext  -->  :exe "".(v:count ? v:count : "")."tnext"
\x80\xfdRunimpairedTPrevious  -->  :exe "".(v:count ? v:count : "")."tprevious"
\x80\xfdRunimpairedQNFile  -->  :exe "".(v:count ? v:count : "")."cnfile"zv
\x80\xfdRunimpairedQPFile  -->  :exe "".(v:count ? v:count : "")."cpfile"zv
\x80\xfdRunimpairedQLast  -->  :exe "".(v:count ? v:count : "")."clast"zv
\x80\xfdRunimpairedQFirst  -->  :exe "".(v:count ? v:count : "")."cfirst"zv
\x80\xfdRunimpairedQNext  -->  :exe "".(v:count ? v:count : "")."cnext"zv
\x80\xfdRunimpairedQPrevious  -->  :exe "".(v:count ? v:count : "")."cprevious"zv
\x80\xfdRunimpairedLNFile  -->  :exe "".(v:count ? v:count : "")."lnfile"zv
\x80\xfdRunimpairedLPFile  -->  :exe "".(v:count ? v:count : "")."lpfile"zv
\x80\xfdRunimpairedLLast  -->  :exe "".(v:count ? v:count : "")."llast"zv
\x80\xfdRunimpairedLFirst  -->  :exe "".(v:count ? v:count : "")."lfirst"zv
\x80\xfdRunimpairedLNext  -->  :exe "".(v:count ? v:count : "")."lnext"zv
\x80\xfdRunimpairedLPrevious  -->  :exe "".(v:count ? v:count : "")."lprevious"zv
\x80\xfdRunimpairedBLast  -->  :exe "".(v:count ? v:count : "")."blast"
\x80\xfdRunimpairedBFirst  -->  :exe "".(v:count ? v:count : "")."bfirst"
\x80\xfdRunimpairedBNext  -->  :exe "".(v:count ? v:count : "")."bnext"
\x80\xfdRunimpairedBPrevious  -->  :exe "".(v:count ? v:count : "")."bprevious"
\x80\xfdRunimpairedALast  -->  :exe "".(v:count ? v:count : "")."last"
\x80\xfdRunimpairedAFirst  -->  :exe "".(v:count ? v:count : "")."first"
\x80\xfdRunimpairedANext  -->  :exe "".(v:count ? v:count : "")."next"
\x80\xfdRunimpairedAPrevious  -->  :exe "".(v:count ? v:count : "")."previous"
\x80kD  -->  c
\x80kb  -->  c
\x80k3  -->  :call UltiSnips#ListSnippets()
\x80\xfdRVgSurround  -->  :call \x80\xfdQ95_opfunc(visualmode(),visualmode() ==# 'V' ? 0 : 1)
\x80\xfdRVSurround  -->  :call \x80\xfdQ95_opfunc(visualmode(),visualmode() ==# 'V' ? 1 : 0)
\x80\xfdRYSurround  -->  :set opfunc=\x80\xfdQ95_opfunc2g@
\x80\xfdRYsurround  -->  :set opfunc=\x80\xfdQ95_opfuncg@
\x80\xfdRYSsurround  -->  :call \x80\xfdQ95_opfunc2(v:count1)
\x80\xfdRYssurround  -->  :call \x80\xfdQ95_opfunc(v:count1)
\x80\xfdRCSurround  -->  :call \x80\xfdQ95_changesurround(1)
\x80\xfdRCsurround  -->  :call \x80\xfdQ95_changesurround()
\x80\xfdRDsurround  -->  :call \x80\xfdQ95_dosurround(\x80\xfdQ95_inputtarget())
\x80\xfdRSurroundRepeat  -->  .
\x80\xfdRSneakPrevious  -->  \x80\xfdRSneak_,
\x80\xfdRSneakNext  -->  \x80\xfdRSneak_;
\x80\xfdRSneakPrevious  -->  \x80\xfdRSneak_,
\x80\xfdRSneakNext  -->  \x80\xfdRSneak_;
\x80\xfdRSneakPrevious  -->  \x80\xfdRSneak_,
\x80\xfdRSneakNext  -->  \x80\xfdRSneak_;
\x80\xfdR(SneakStreakBackward)  -->  \x80\xfdRSneakLabel_S
\x80\xfdR(SneakStreak)  -->  \x80\xfdRSneakLabel_s
\x80\xfdR(SneakStreakBackward)  -->  \x80\xfdRSneakLabel_S
\x80\xfdR(SneakStreak)  -->  \x80\xfdRSneakLabel_s
\x80\xfdR(SneakStreakBackward)  -->  \x80\xfdRSneakLabel_S
\x80\xfdR(SneakStreak)  -->  \x80\xfdRSneakLabel_s
\x80\xfdRVSneakPrevious  -->  \x80\xfdRSneak_,
\x80\xfdRVSneakNext  -->  \x80\xfdRSneak_;
\x80\xfdRVSneakBackward  -->  \x80\xfdRSneak_S
\x80\xfdRVSneakForward  -->  \x80\xfdRSneak_s
\x80\xfdRSneakBackward  -->  \x80\xfdRSneak_S
\x80\xfdRSneakForward  -->  \x80\xfdRSneak_s
\x80\xfdRSneakLabel_S  -->  :call sneak#wrap(v:operator, 2, 1, 2, 2)
\x80\xfdRSneakLabel_s  -->  :call sneak#wrap(v:operator, 2, 0, 2, 2)
\x80\xfdRSneakLabel_S  -->  :call sneak#wrap(visualmode(), 2, 1, 2, 2)
\x80\xfdRSneakLabel_s  -->  :call sneak#wrap(visualmode(), 2, 0, 2, 2)
\x80\xfdRSneakLabel_S  -->  :call sneak#wrap('', 2, 1, 2, 2)
\x80\xfdRSneakLabel_s  -->  :call sneak#wrap('', 2, 0, 2, 2)
\x80\xfdRSneak_T  -->  :call sneak#wrap(v:operator, 1, 1, 0, 0)
\x80\xfdRSneak_t  -->  :call sneak#wrap(v:operator, 1, 0, 0, 0)
\x80\xfdRSneak_T  -->  :call sneak#wrap(visualmode(), 1, 1, 0, 0)
\x80\xfdRSneak_t  -->  :call sneak#wrap(visualmode(), 1, 0, 0, 0)
\x80\xfdRSneak_T  -->  :call sneak#wrap('', 1, 1, 0, 0)
\x80\xfdRSneak_t  -->  :call sneak#wrap('', 1, 0, 0, 0)
\x80\xfdRSneak_F  -->  :call sneak#wrap(v:operator, 1, 1, 1, 0)
\x80\xfdRSneak_f  -->  :call sneak#wrap(v:operator, 1, 0, 1, 0)
\x80\xfdRSneak_F  -->  :call sneak#wrap(visualmode(), 1, 1, 1, 0)
\x80\xfdRSneak_f  -->  :call sneak#wrap(visualmode(), 1, 0, 1, 0)
\x80\xfdRSneak_F  -->  :call sneak#wrap('', 1, 1, 1, 0)
\x80\xfdRSneak_f  -->  :call sneak#wrap('', 1, 0, 1, 0)
\x80\xfdRSneak_,  -->  :call sneak#rpt(v:operator, 1)
\x80\xfdRSneak_;  -->  :call sneak#rpt(v:operator, 0)
\x80\xfdRSneak_,  -->  :call sneak#rpt(visualmode(), 1)
\x80\xfdRSneak_;  -->  :call sneak#rpt(visualmode(), 0)
\x80\xfdRSneak_,  -->  :call sneak#rpt('', 1)
\x80\xfdRSneak_;  -->  :call sneak#rpt('', 0)
\x80\xfdRSneakRepeat  -->  :call sneak#wrap(v:operator, sneak#util#getc(), sneak#util#getc(), sneak#util#getc(), sneak#util#getc())
\x80\xfdRSneak_S  -->  :call sneak#wrap(v:operator, 2, 1, 2, 1)
\x80\xfdRSneak_s  -->  :call sneak#wrap(v:operator, 2, 0, 2, 1)
\x80\xfdRSneak_S  -->  :call sneak#wrap(visualmode(), 2, 1, 2, 1)
\x80\xfdRSneak_s  -->  :call sneak#wrap(visualmode(), 2, 0, 2, 1)
\x80\xfdRSneak_S  -->  :call sneak#wrap('', 2, 1, 2, 1)
\x80\xfdRSneak_s  -->  :call sneak#wrap('', 2, 0, 2, 1)
\x80\xfdRSidewaysArgumentTextobjI  -->  :call sideways#textobj#Argument('i')
\x80\xfdRSidewaysArgumentTextobjI  -->  :call sideways#textobj#Argument('i')
\x80\xfdRSidewaysArgumentTextobjA  -->  :call sideways#textobj#Argument('a')
\x80\xfdRSidewaysArgumentTextobjA  -->  :call sideways#textobj#Argument('a')
\x80\xfdRSidewaysRight  -->  :SidewaysRight
\x80\xfdRSidewaysLeft  -->  :SidewaysLeft
\x80\xfdR(sexp_capture_next_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'v', 1, 1)
\x80\xfdR(sexp_capture_next_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'n', 1, 1) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_capture_next_element)", b:sexp_count)
\x80\xfdR(sexp_capture_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'v', 0, 1)
\x80\xfdR(sexp_capture_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'n', 0, 1) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_capture_prev_element)", b:sexp_count)
\x80\xfdR(sexp_emit_tail_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'v', 1, 0)
\x80\xfdR(sexp_emit_tail_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'n', 1, 0) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_emit_tail_element)", b:sexp_count)
\x80\xfdR(sexp_emit_head_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'v', 0, 0)
\x80\xfdR(sexp_emit_head_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'n', 0, 0) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_emit_head_element)", b:sexp_count)
\x80\xfdR(sexp_swap_element_forward)  -->  :call sexp#docount(v:prevcount, 'sexp#swap_element', 'v', 1, 0)
\x80\xfdR(sexp_swap_element_forward)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#swap_element', 'n', 1, 0) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_swap_element_forward)", b:sexp_count)
\x80\xfdR(sexp_swap_element_backward)  -->  :call sexp#docount(v:prevcount, 'sexp#swap_element', 'v', 0, 0)
\x80\xfdR(sexp_swap_element_backward)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#swap_element', 'n', 0, 0) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_swap_element_backward)", b:sexp_count)
\x80\xfdR(sexp_swap_list_forward)  -->  :call sexp#docount(v:prevcount, 'sexp#swap_element', 'v', 1, 1)
\x80\xfdR(sexp_swap_list_forward)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#swap_element', 'n', 1, 1) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_swap_list_forward)", b:sexp_count)
\x80\xfdR(sexp_swap_list_backward)  -->  :call sexp#docount(v:prevcount, 'sexp#swap_element', 'v', 0, 1)
\x80\xfdR(sexp_swap_list_backward)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#swap_element', 'n', 0, 1) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_swap_list_backward)", b:sexp_count)
\x80\xfdR(sexp_splice_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#splice_list(b:sexp_count) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_splice_list)", b:sexp_count)
\x80\xfdR(sexp_raise_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#raise', 'v', '')
\x80\xfdR(sexp_raise_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#raise', 'n', 'sexp#select_current_element', 'n', 1) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_raise_element)", b:sexp_count)
\x80\xfdR(sexp_raise_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#raise', 'v', '')
\x80\xfdR(sexp_raise_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#raise', 'n', 'sexp#select_current_list', 'n', 0, 0) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_raise_list)", b:sexp_count)
\x80\xfdR(sexp_insert_at_list_tail)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#insert_at_list_terminal(1) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_insert_at_list_tail)", b:sexp_count)
\x80\xfdR(sexp_insert_at_list_head)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#insert_at_list_terminal(0) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_insert_at_list_head)", b:sexp_count)
\x80\xfdR(sexp_curly_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '{', '}', 1, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_curly_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '{', '}', 1, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_curly_tail_wrap_element)", b:sexp_count)
\x80\xfdR(sexp_curly_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '{', '}', 0, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_curly_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '{', '}', 0, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_curly_head_wrap_element)", b:sexp_count)
\x80\xfdR(sexp_square_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '[', ']', 1, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_square_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '[', ']', 1, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_square_tail_wrap_element)", b:sexp_count)
\x80\xfdR(sexp_square_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '[', ']', 0, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_square_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '[', ']', 0, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_square_head_wrap_element)", b:sexp_count)
\x80\xfdR(sexp_round_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '(', ')', 1, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_round_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '(', ')', 1, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_round_tail_wrap_element)", b:sexp_count)
\x80\xfdR(sexp_round_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '(', ')', 0, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_round_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '(', ')', 0, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_round_head_wrap_element)", b:sexp_count)
\x80\xfdR(sexp_curly_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '{', '}', 1, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_curly_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '{', '}', 1, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_curly_tail_wrap_list)", b:sexp_count)
\x80\xfdR(sexp_curly_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '{', '}', 0, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_curly_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '{', '}', 0, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_curly_head_wrap_list)", b:sexp_count)
\x80\xfdR(sexp_square_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '[', ']', 1, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_square_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '[', ']', 1, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_square_tail_wrap_list)", b:sexp_count)
\x80\xfdR(sexp_square_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '[', ']', 0, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_square_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '[', ']', 0, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_square_head_wrap_list)", b:sexp_count)
\x80\xfdR(sexp_round_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '(', ')', 1, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_round_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '(', ')', 1, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_round_tail_wrap_list)", b:sexp_count)
\x80\xfdR(sexp_round_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '(', ')', 0, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_round_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '(', ')', 0, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_round_head_wrap_list)", b:sexp_count)
\x80\xfdR(sexp_indent_top)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#indent(1, b:sexp_count) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_indent_top)", b:sexp_count)
\x80\xfdR(sexp_indent)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#indent(0, b:sexp_count) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_indent)", b:sexp_count)
\x80\xfdR(sexp_select_next_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'o', 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_select_next_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_select_next_element)", b:sexp_count) | endif
\x80\xfdR(sexp_select_next_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'v', 1)
\x80\xfdR(sexp_select_next_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'n', 1)
\x80\xfdR(sexp_select_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'o', 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_select_prev_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_select_prev_element)", b:sexp_count) | endif
\x80\xfdR(sexp_select_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'v', 0)
\x80\xfdR(sexp_select_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'n', 0)
\x80\xfdR(sexp_move_to_next_top_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#move_to_adjacent_element('o', b:sexp_count, 1, 0, 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_next_top_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_next_top_element)", b:sexp_count) | endif
\x80\xfdR(sexp_move_to_next_top_element)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 1, 0, 1)
\x80\xfdR(sexp_move_to_next_top_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#move_to_adjacent_element('n', b:sexp_count, 1, 0, 1)
\x80\xfdR(sexp_move_to_prev_top_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#move_to_adjacent_element('o', b:sexp_count, 0, 0, 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_prev_top_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_prev_top_element)", b:sexp_count) | endif
\x80\xfdR(sexp_move_to_prev_top_element)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 0, 0, 1)
\x80\xfdR(sexp_move_to_prev_top_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#move_to_adjacent_element('n', b:sexp_count, 0, 0, 1)
\x80\xfdR(sexp_move_to_next_element_tail)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('o', b:sexp_count, 1, 1, 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_next_element_tail)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_next_element_tail)", b:sexp_count) | endif
\x80\xfdR(sexp_move_to_next_element_tail)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 1, 1, 0)
\x80\xfdR(sexp_move_to_next_element_tail)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('n', b:sexp_count, 1, 1, 0)
\x80\xfdR(sexp_move_to_prev_element_tail)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('o', b:sexp_count, 0, 1, 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_prev_element_tail)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_prev_element_tail)", b:sexp_count) | endif
\x80\xfdR(sexp_move_to_prev_element_tail)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 0, 1, 0)
\x80\xfdR(sexp_move_to_prev_element_tail)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('n', b:sexp_count, 0, 1, 0)
\x80\xfdR(sexp_move_to_next_element_head)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('o', b:sexp_count, 1, 0, 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_next_element_head)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_next_element_head)", b:sexp_count) | endif
\x80\xfdR(sexp_move_to_next_element_head)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 1, 0, 0)
\x80\xfdR(sexp_move_to_next_element_head)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('n', b:sexp_count, 1, 0, 0)
\x80\xfdR(sexp_move_to_prev_element_head)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('o', b:sexp_count, 0, 0, 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_prev_element_head)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_prev_element_head)", b:sexp_count) | endif
\x80\xfdR(sexp_move_to_prev_element_head)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 0, 0, 0)
\x80\xfdR(sexp_move_to_prev_element_head)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('n', b:sexp_count, 0, 0, 0)
\x80\xfdR(sexp_move_to_next_bracket)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#move_to_nearest_bracket('o', 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_next_bracket)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_next_bracket)", b:sexp_count) | endif
\x80\xfdR(sexp_move_to_next_bracket)  -->  :call sexp#docount(v:prevcount, 'sexp#move_to_nearest_bracket', 'v', 1)
\x80\xfdR(sexp_move_to_next_bracket)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#move_to_nearest_bracket', 'n', 1)
\x80\xfdR(sexp_move_to_prev_bracket)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#move_to_nearest_bracket('o', 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_prev_bracket)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_prev_bracket)", b:sexp_count) | endif
\x80\xfdR(sexp_move_to_prev_bracket)  -->  :call sexp#docount(v:prevcount, 'sexp#move_to_nearest_bracket', 'v', 0)
\x80\xfdR(sexp_move_to_prev_bracket)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#move_to_nearest_bracket', 'n', 0)
\x80\xfdR(sexp_inner_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_element('o', 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_inner_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_inner_element)", b:sexp_count) | endif
\x80\xfdR(sexp_inner_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_element('v', 1)
\x80\xfdR(sexp_outer_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_element('o', 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_outer_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_outer_element)", b:sexp_count) | endif
\x80\xfdR(sexp_outer_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_element('v', 0)
\x80\xfdR(sexp_inner_string)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_string('o', 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_inner_string)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_inner_string)", b:sexp_count) | endif
\x80\xfdR(sexp_inner_string)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_string('v', 1)
\x80\xfdR(sexp_outer_string)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_string('o', 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_outer_string)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_outer_string)", b:sexp_count) | endif
\x80\xfdR(sexp_outer_string)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_string('v', 0)
\x80\xfdR(sexp_inner_top_list)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_top_list('o', 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_inner_top_list)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_inner_top_list)", b:sexp_count) | endif
\x80\xfdR(sexp_inner_top_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_top_list('v', 1)
\x80\xfdR(sexp_outer_top_list)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_top_list('o', 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_outer_top_list)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_outer_top_list)", b:sexp_count) | endif
\x80\xfdR(sexp_outer_top_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_top_list('v', 0)
\x80\xfdR(sexp_inner_list)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#docount(b:sexp_count, 'sexp#select_current_list', 'o', 1, 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_inner_list)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_inner_list)", b:sexp_count) | endif
\x80\xfdR(sexp_inner_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_current_list', 'v', 1, 1)
\x80\xfdR(sexp_outer_list)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#docount(b:sexp_count, 'sexp#select_current_list', 'o', 0, 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_outer_list)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_outer_list)", b:sexp_count) | endif
\x80\xfdR(sexp_outer_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_current_list', 'v', 0, 1)
\x80\xfdR(RepeatRedo)  -->  :call repeat#wrap("\<C-R>",v:count)
\x80\xfdR(RepeatUndoLine)  -->  :call repeat#wrap('U',v:count)
\x80\xfdR(RepeatUndo)  -->  :call repeat#wrap('u',v:count)
\x80\xfdR(RepeatDot)  -->  :exe repeat#run(v:count)
\x80\xfdR(GrepperOperator)  -->  :call grepper#operator(visualmode())
\x80\xfdR(GrepperOperator)  -->  :set opfunc=grepper#operatorg@
\x80\xfdQ63_:  -->  :=v:count ? v:count : ''
\x80\xfdR(ExchangeLine)  -->  ':set operatorfunc=\x80\xfdQ62_exchange_set'.(v:count1 == 1 ? '' : v:count1).'g@_'
\x80\xfdR(ExchangeClear)  -->  :call \x80\xfdQ62_exchange_clear()
\x80\xfdR(Exchange)  -->  :call \x80\xfdQ62_exchange_set(visualmode(), 1)
\x80\xfdR(Exchange)  -->  ':set operatorfunc=\x80\xfdQ62_exchange_set'.(v:count1 == 1 ? '' : v:count1).'g@'
\x80\xfdR(OuterDENTURE)  -->  :call dentures#select(line('.'), 1, 1, 'operator')
\x80\xfdR(OuterDenture)  -->  :call dentures#select(line('.'), 1, 0, 'operator')
\x80\xfdR(InnerDENTURE)  -->  :call dentures#select(line('.'), 0, 1, 'operator')
\x80\xfdR(InnerDenture)  -->  :call dentures#select(line('.'), 0, 0, 'operator')
\x80\xfdR(OuterDENTURE)  -->  dentures#select(line('.'), 1, 1, mode())
\x80\xfdR(OuterDenture)  -->  dentures#select(line('.'), 1, 0, mode())
\x80\xfdR(InnerDENTURE)  -->  dentures#select(line('.'), 0, 1, mode())
\x80\xfdR(InnerDenture)  -->  dentures#select(line('.'), 0, 0, mode())
\x80\xffX  -->  :CtrlP
\x80\xfdRCommentaryUndo  -->  \x80\xfdRCommentary\x80\xfdRCommentary
\x80\xfdRChangeCommentary  -->  c:call \x80\xfdQ56_textobject(1)
\x80\xfdRCommentary  -->  :call \x80\xfdQ56_textobject(0)
\x80\xfdRCommentaryLine  -->  :set opfunc=\x80\xfdQ56_go|exe 'norm! 'v:count1.'g@_'
\x80\xfdRCommentary  -->  :set opfunc=\x80\xfdQ56_gog@
\x80\xfdRCommentary  -->  :call \x80\xfdQ56_go(line("'<"),line("'>"))
\x80\xfdRCoerce  -->  :call \x80\xfdQ55_coerce(nr2char(getchar()))
\x80\xfc\x80k8  -->  :call \x80\xfdQ50_NextColor(0, 1)
\x80\xfd  -->  :call \x80\xfdQ50_NextColor(-1, 1)
\x80k8  -->  :call \x80\xfdQ50_NextColor(1, 1)
\x80\xfdRremove_vimple_ident_search_forward  -->  \x80\xfdRvimple_ident_search_forward
\x80\xfdRremove_vimple_ident_search  -->  \x80\xfdRvimple_ident_search
\x80\xfdRremove_vimple_spell_suggest  -->  \x80\xfdRvimple_spell_suggest
\x80\xfdRremove_vimple_tag_search  -->  \x80\xfdRvimple_tag_search
\x80k5  -->  :GundoToggle
\x80\xfc   -->  \x80\xffX
\x80ku  -->  DVB_Drag('up')
\x80kd  -->  DVB_Drag('down')
\x80kr  -->  DVB_Drag('right')
\x80kl  -->  DVB_Drag('left')
\x80\xfd/  -->  \x80\xfd,:silent RunCommand
\x80k2  -->  y:exe getreg('"')
\x80k2  -->  :call RunCommand(0)
\x80k9  -->  :Neomake!
\x80F2  -->  :!ctags -R --fields=+iaS --extra=+qf .
\x80k;  -->  :%s/\s\+$//:nohlsearch
\x80\xfd2  -->  \x80\xfd,:silent call helpers#plumb_this()
\x80\xfd.  -->  \x80\xfd."*ygv
  -->  
S  -->  \x80\xfdRISurround
s  -->  \x80\xfdRIsurround
	  -->  =UltiSnips#ExpandSnippet()
  -->  \x80\xfdRIsurround
  -->  complete#trigger('completers#datetime')
  -->  complete#trigger('completers#abbrevs')
-  -->  _
_  -->  -
(gdb) 
vshcmd: > pipe array mapblock_T *; maphash; 256 | eval *{} | if {} != 0 | nvim-mapblock | show printf "%s  -->  %s\n", {0}->m_keys, {0}->m_str
€ýRvimple_completers_trigger  -->  complete#trigger('completers#trigger')
€k3  -->  =UltiSnips#ListSnippets()
€ýRISurround  -->  =€ýQ95_insert(1)
€ýRIsurround  -->  =€ýQ95_insert()
€ýR(sexp_insert_backspace)  -->  sexp#backspace_insertion()
€ýR(sexp_insert_double_quote)  -->  sexp#quote_insertion('"')
€ýR(sexp_insert_closing_curly)  -->  sexp#closing_insertion('}')
€ýR(sexp_insert_closing_square)  -->  sexp#closing_insertion(']')
€ýR(sexp_insert_closing_round)  -->  sexp#closing_insertion(')')
€ýR(sexp_insert_opening_curly)  -->  sexp#opening_insertion('{')
€ýR(sexp_insert_opening_square)  -->  sexp#opening_insertion('[')
€ýR(sexp_insert_opening_round)  -->  sexp#opening_insertion('(')
€ýRremove_vimple_completers_trigger  -->  €ýRvimple_completers_trigger
€üo  -->  o
€üO  -->  O
  -->  c
	  -->  :call UltiSnips#SaveLastVisualSelection()gvs
	  -->  :call UltiSnips#ExpandSnippet()
  -->  :nohlsearch:diffupdate:syntax sync fromstart
  -->  "_c
  -->  €ýR(RepeatRedo)
 wl  -->  :call  €ýQ54_MoveWindow('l')
 wk  -->  :call  €ýQ54_MoveWindow('k')
 wj  -->  :call  €ýQ54_MoveWindow('j')
 wh  -->  :call  €ýQ54_MoveWindow('h')
 st  -->  :silent TQFSelect! 
 qd  -->  :QFilterBuf! %
 qb  -->  :QFilterBuf %
 qs  -->  :QuickfixSort
 qr  -->  :QFRemoveCurrent!
 ll  -->  €ýRvimple_filter
 mu  -->  €ýRVimpleMRU
 mb  -->  :VFMBadd
 mc  -->  €ýRvfm_browse_bufs
 mp  -->  €ýRvfm_browse_paths
 md  -->  €ýRvfm_browse_dirs
 ma  -->  €ýRvfm_browse_args
 me  -->  €ýRvfm_browse_files
 rk  -->  :SyntasticReset
 ok  -->  :SyntasticCheck
 al  -->  :SidewaysRight
 ah  -->  :SidewaysLeft
 pk  -->  :PymodeLint
 hq  -->  :Hgqseries
 hv  -->  :Hglogthis
 hg  -->  :Hglog
 hs  -->  :Hgstatus
 hc  -->  :Hgcommit
 hf  -->  :Hgpull
 hp  -->  :Hgpush
 hd  -->  :Hgvdiff
 sb  -->  :GrepBufs 
 sd  -->  :GrepHere 
 sg  -->  :Grepper -tool git 
 ss  -->  :Grepper -tool grep 
 so  -->  €ýR(GrepperOperator)
 so  -->  €ýR(GrepperOperator)
 gv  -->  :Gitv! --all
 gv  -->  :Gitv! --all
 gg  -->  :Gitv --all
 cpf  -->  :CtrlPFunky
 gs  -->  :Gstatus
 gc  -->  :Gcommit
 gf  -->  :Gpurr
 gp  -->  :Gpush
 gd  -->  :Gdiff
 gw  -->  :Gwrite
 fd  -->  :DiffOrig
 ff  -->  :Find 
 fm  -->  :Rename 
 fr  -->  :Unlink
 cpm  -->  :CtrlPMRU
 cpu  -->  :CtrlPUndo
 cpt  -->  :CtrlPTag
 cpq  -->  :CtrlPQuickfix
 cpc  -->  :CtrlPChange
 cpb  -->  :CtrlPBuffer
 mm  -->  €ýRvfm_argument
 z  -->  :
 '  -->  :
 cn  -->  :setlocal completeopt-=longest
 cl  -->  :setlocal completeopt+=longest
 nh  -->  :nohlsearch
 sh  -->  :Occur! 
 u  -->  :update
 b  -->  :ls:b 
 em  -->  :='let @'. v:register .' = '. string(getreg(v:register))€kl
#  -->  €ýR(visualstar-#)
'€ý,  -->  €ý,
'  -->  `
*  -->  €ýR(visualstar-*)
++  -->  VMATH_YankAndAnalyse()
,  -->  €ýRSneakNext
,  -->  €ýRSneakNext
,  -->  €ýRSneakNext
,  -->  €ýRSneakNext
.  -->  €ýR(RepeatDot)
;  -->  €ýRSneakPrevious
;  -->  €ýRSneakPrevious
;  -->  €ýRSneakPrevious
;  -->  €ýRSneakPrevious
<p  -->  :call €ýQ110_putline(']p', 'Below')<']
<P  -->  :call €ýQ110_putline('[p', 'Above')<']
<  -->  <gv
=p  -->  :call €ýQ110_putline(']p', 'Below')=']
=P  -->  :call €ýQ110_putline('[p', 'Above')=']
>p  -->  :call €ýQ110_putline(']p', 'Below')>']
>P  -->  :call €ýQ110_putline('[p', 'Above')>']
>  -->  >gv
D  -->  DVB_Duplicate()
F€ý2  -->  €ý,:silent Occur! 
Q  -->  :call €ýQ2_Again()
S  -->  €ýRVSurround
S  -->  €ýRSneak_S
T€ý2  -->  €ý,:silent TQFSelect! 
U  -->  €ýR(RepeatUndoLine)
U  -->  €ýRSneak_S
X  -->  €ýR(Exchange)
Y  -->  y$
Z  -->  €ýRSneak_S
[xx  -->  €ýRunimpaired_line_xml_encode
[x  -->  €ýRunimpaired_xml_encode
[x  -->  €ýRunimpaired_xml_encode
[uu  -->  €ýRunimpaired_line_url_encode
[u  -->  €ýRunimpaired_url_encode
[u  -->  €ýRunimpaired_url_encode
[yy  -->  €ýRunimpaired_line_string_encode
[y  -->  €ýRunimpaired_string_encode
[y  -->  €ýRunimpaired_string_encode
[p  -->  €ýRunimpairedPutAbove
[ov  -->  :set virtualedit+=all
[ox  -->  :set cursorline cursorcolumn
[ow  -->  :setlocal wrap=€ýQ110_statusbump()
[os  -->  :setlocal spell=€ýQ110_statusbump()
[or  -->  :setlocal relativenumber=€ýQ110_statusbump()
[on  -->  :setlocal number=€ýQ110_statusbump()
[ol  -->  :setlocal list=€ýQ110_statusbump()
[oi  -->  :set ignorecase=€ýQ110_statusbump()
[oh  -->  :set hlsearch=€ýQ110_statusbump()
[od  -->  :diffthis
[ou  -->  :setlocal cursorcolumn=€ýQ110_statusbump()
[oc  -->  :setlocal cursorline=€ýQ110_statusbump()
[ob  -->  :set background=light
[e  -->  €ýRunimpairedMoveSelectionUp
[e  -->  €ýRunimpairedMoveUp
[   -->  €ýRunimpairedBlankUp
[n  -->  €ýRunimpairedContextPrevious
[n  -->  €ýRunimpairedContextPrevious
[f  -->  €ýRunimpairedDirectoryPrevious
[T  -->  €ýRunimpairedTFirst
[t  -->  €ýRunimpairedTPrevious
[  -->  €ýRunimpairedQPFile
[Q  -->  €ýRunimpairedQFirst
[q  -->  €ýRunimpairedQPrevious
[  -->  €ýRunimpairedLPFile
[L  -->  €ýRunimpairedLFirst
[l  -->  €ýRunimpairedLPrevious
[B  -->  €ýRunimpairedBFirst
[b  -->  €ýRunimpairedBPrevious
[A  -->  €ýRunimpairedAFirst
[a  -->  €ýRunimpairedAPrevious
[ok  -->  :call €ýQ25_UseVimForMan()
]xx  -->  €ýRunimpaired_line_xml_decode
]x  -->  €ýRunimpaired_xml_decode
]x  -->  €ýRunimpaired_xml_decode
]uu  -->  €ýRunimpaired_line_url_decode
]u  -->  €ýRunimpaired_url_decode
]u  -->  €ýRunimpaired_url_decode
]yy  -->  €ýRunimpaired_line_string_decode
]y  -->  €ýRunimpaired_string_decode
]y  -->  €ýRunimpaired_string_decode
]p  -->  €ýRunimpairedPutBelow
]ov  -->  :set virtualedit-=all
]ox  -->  :set nocursorline nocursorcolumn
]ow  -->  :setlocal nowrap=€ýQ110_statusbump()
]os  -->  :setlocal nospell=€ýQ110_statusbump()
]or  -->  :setlocal norelativenumber=€ýQ110_statusbump()
]on  -->  :setlocal nonumber=€ýQ110_statusbump()
]ol  -->  :setlocal nolist=€ýQ110_statusbump()
]oi  -->  :set noignorecase=€ýQ110_statusbump()
]oh  -->  :set nohlsearch=€ýQ110_statusbump()
]od  -->  :diffoff
]ou  -->  :setlocal nocursorcolumn=€ýQ110_statusbump()
]oc  -->  :setlocal nocursorline=€ýQ110_statusbump()
]ob  -->  :set background=dark
]e  -->  €ýRunimpairedMoveSelectionDown
]e  -->  €ýRunimpairedMoveDown
]   -->  €ýRunimpairedBlankDown
]n  -->  €ýRunimpairedContextNext
]n  -->  €ýRunimpairedContextNext
]f  -->  €ýRunimpairedDirectoryNext
]T  -->  €ýRunimpairedTLast
]t  -->  €ýRunimpairedTNext
]  -->  €ýRunimpairedQNFile
]Q  -->  €ýRunimpairedQLast
]q  -->  €ýRunimpairedQNext
]  -->  €ýRunimpairedLNFile
]L  -->  €ýRunimpairedLLast
]l  -->  €ýRunimpairedLNext
]B  -->  €ýRunimpairedBLast
]b  -->  €ýRunimpairedBNext
]A  -->  €ýRunimpairedALast
]a  -->  €ýRunimpairedANext
]ok  -->  :unmap <buffer> K
`  -->  '
aI  -->  €ýR(OuterDENTURE)
aI  -->  €ýR(OuterDENTURE)
ai  -->  €ýR(OuterDenture)
ai  -->  €ýR(OuterDenture)
aa  -->  €ýRSidewaysArgumentTextobjA
aa  -->  €ýRSidewaysArgumentTextobjA
cov  -->  :set =(&virtualedit =~# "all") ? 'virtualedit-=all' : 'virtualedit+=all'
cox  -->  :set =&cursorline && &cursorcolumn ? 'nocursorline nocursorcolumn' : 'cursorline cursorcolumn'
cow  -->  :setlocal =€ýQ110_toggle("wrap")
cos  -->  :setlocal =€ýQ110_toggle("spell")
cor  -->  :setlocal =€ýQ110_toggle("relativenumber")
con  -->  :setlocal =€ýQ110_toggle("number")
col  -->  :setlocal =€ýQ110_toggle("list")
coi  -->  :set =€ýQ110_toggle("ignorecase")
coh  -->  :set =€ýQ110_toggle("hlsearch")
cod  -->  :=&diff ? 'diffoff' : 'diffthis'
cou  -->  :setlocal =€ýQ110_toggle("cursorcolumn")
coc  -->  :setlocal =€ýQ110_toggle("cursorline")
cob  -->  :set background==&background == 'dark' ? 'light' : 'dark'
cS  -->  €ýRCSurround
cs  -->  €ýRCsurround
cxx  -->  €ýR(ExchangeLine)
cxc  -->  €ýR(ExchangeClear)
cx  -->  €ýR(Exchange)
cgc  -->  €ýRChangeCommentary
cr  -->  €ýRCoerce
cw  -->  dwi
ds  -->  €ýRDsurround
f€ý2  -->  €ý,:silent Occur 
gs  -->  €ýR(submode-before-entering:scrolling:with:gs)€ýR(submode-before-entering:scrolling)€ýR(submode-enter:scrolling)
g  -->  €ýR(submode-before-entering:windows:with:g)€ýR(submode-before-entering:windows)€ýR(submode-enter:windows)
g+  -->  €ýR(submode-before-entering:undo/redo:with:g+)€ýR(submode-before-entering:undo/redo)€ýR(submode-enter:undo/redo)
g-  -->  €ýR(submode-before-entering:undo/redo:with:g-)€ýR(submode-before-entering:undo/redo)€ýR(submode-enter:undo/redo)
gx  -->  €ýRNetrwBrowseXVis
gx  -->  €ýRNetrwBrowseX
g#  -->  €ýR(visualstar-g#)
g€ü€ý,  -->  €ýR(visualstar-g*)
g€K9  -->  €ýR(visualstar-g*)
g*  -->  €ýR(visualstar-g*)
gS  -->  €ýRVgSurround
gcu  -->  €ýRCommentary€ýRCommentary
gcc  -->  €ýRCommentaryLine
gc  -->  €ýRCommentary
gc  -->  €ýRCommentary
gc  -->  €ýRCommentary
gk  -->  @='4k'
gj  -->  @='4j'
g6  -->  :exe 6 . "wincmd w"
g5  -->  :exe 5 . "wincmd w"
g4  -->  :exe 4 . "wincmd w"
g3  -->  :exe 3 . "wincmd w"
g2  -->  :exe 2 . "wincmd w"
g1  -->  :exe 1 . "wincmd w"
gV  -->  "`[".getregtype(v:register)[0]."`]"
iI  -->  €ýR(InnerDENTURE)
iI  -->  €ýR(InnerDENTURE)
ii  -->  €ýR(InnerDenture)
ii  -->  €ýR(InnerDenture)
ia  -->  €ýRSidewaysArgumentTextobjI
ia  -->  €ýRSidewaysArgumentTextobjI
q€ý,  -->  	
q€ý2  -->  
s  -->  €ýRSneak_s
s  -->  €ýRSneak_s
t€ý2  -->  €ý,:silent TQFSelect 
u  -->  €ýR(RepeatUndo)
u  -->  €ýRSneak_s
yO  -->  :call €ýQ110_setup_paste()O
yo  -->  :call €ýQ110_setup_paste()o
ySS  -->  €ýRYSsurround
ySs  -->  €ýRYSsurround
yss  -->  €ýRYssurround
yS  -->  €ýRYSurround
ys  -->  €ýRYsurround
zf  -->  €ýR(submode-before-entering:folds:with:zf)€ýR(submode-before-entering:folds)€ýR(submode-enter:folds)
zw  -->  ysiw
€F1  -->  :!cscope -Rb:cs reset
€ýR(submode-rhs:scrolling:for:b)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â b  -->  €ýR(submode-rhs:scrolling:for:b)€ýR(submode-enter:scrolling)
€ýR(submode-rhs:scrolling:for:f)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â f  -->  €ýR(submode-rhs:scrolling:for:f)€ýR(submode-enter:scrolling)
€ýR(submode-rhs:scrolling:for:u)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â u  -->  €ýR(submode-rhs:scrolling:for:u)€ýR(submode-enter:scrolling)
€ýR(submode-rhs:scrolling:for:d)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â d  -->  €ýR(submode-rhs:scrolling:for:d)€ýR(submode-enter:scrolling)
€ýR(submode-rhs:scrolling:for:k)  -->  10
€ýR(submode-prefix:scrolling)Â Â Â Â Â k  -->  €ýR(submode-rhs:scrolling:for:k)€ýR(submode-enter:scrolling)
€ýR(submode-rhs:scrolling:for:j)  -->  10
€ýR(submode-prefix:scrolling)Â Â Â Â Â j  -->  €ýR(submode-rhs:scrolling:for:j)€ýR(submode-enter:scrolling)
€ýR(submode-rhs:scrolling:for:y)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â y  -->  €ýR(submode-rhs:scrolling:for:y)€ýR(submode-enter:scrolling)
€ýR(submode-rhs:scrolling:for:e)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â e  -->  €ýR(submode-rhs:scrolling:for:e)€ýR(submode-enter:scrolling)
€ýR(submode-leave:scrolling)  -->  @=€ýQ146_on_leaving_submode('scrolling')
€ýR(submode-prefix:scrolling)Â Â Â Â Â   -->  €ýR(submode-leave:scrolling)
€ýR(submode-before-action:scrolling)  -->  €ýQ146_on_executing_action('scrolling')
€ýR(submode-enter:scrolling)  -->  €ýR(submode-before-action:scrolling)€ýR(submode-prefix:scrolling)Â Â Â Â Â 
€ýR(submode-before-entering:scrolling)  -->  €ýQ146_on_entering_submode('scrolling')
€ýR(submode-before-entering:scrolling:with:gs)  -->  jk
€ýR(submode-rhs:scrolling:for:q)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â q  -->  €ýR(submode-rhs:scrolling:for:q)€ýR(submode-leave:scrolling)
€ýR(submode-rhs:scrolling:for:)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â   -->  €ýR(submode-rhs:scrolling:for:)€ýR(submode-leave:scrolling)
€ýR(submode-rhs:scrolling:for:)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â   -->  €ýR(submode-rhs:scrolling:for:)€ýR(submode-leave:scrolling)
€ýR(submode-rhs:folds:for:z)  -->  zz
€ýR(submode-prefix:folds)Â Â Â Â Â z  -->  €ýR(submode-rhs:folds:for:z)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:b)  -->  zb
€ýR(submode-prefix:folds)Â Â Â Â Â b  -->  €ýR(submode-rhs:folds:for:b)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:t)  -->  zt
€ýR(submode-prefix:folds)Â Â Â Â Â t  -->  €ýR(submode-rhs:folds:for:t)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:C)  -->  zC
€ýR(submode-prefix:folds)Â Â Â Â Â C  -->  €ýR(submode-rhs:folds:for:C)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:c)  -->  zc
€ýR(submode-prefix:folds)Â Â Â Â Â c  -->  €ýR(submode-rhs:folds:for:c)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:O)  -->  zO
€ýR(submode-prefix:folds)Â Â Â Â Â O  -->  €ýR(submode-rhs:folds:for:O)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:o)  -->  zo
€ýR(submode-prefix:folds)Â Â Â Â Â o  -->  €ýR(submode-rhs:folds:for:o)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:v)  -->  zv
€ýR(submode-prefix:folds)Â Â Â Â Â v  -->  €ýR(submode-rhs:folds:for:v)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:x)  -->  zx
€ýR(submode-prefix:folds)Â Â Â Â Â x  -->  €ýR(submode-rhs:folds:for:x)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:R)  -->  zR
€ýR(submode-prefix:folds)Â Â Â Â Â R  -->  €ýR(submode-rhs:folds:for:R)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:r)  -->  zr
€ýR(submode-prefix:folds)Â Â Â Â Â r  -->  €ýR(submode-rhs:folds:for:r)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:M)  -->  zM
€ýR(submode-prefix:folds)Â Â Â Â Â M  -->  €ýR(submode-rhs:folds:for:M)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:m)  -->  zm
€ýR(submode-prefix:folds)Â Â Â Â Â m  -->  €ýR(submode-rhs:folds:for:m)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:6)  -->  6w
€ýR(submode-prefix:folds)Â Â Â Â Â 6  -->  €ýR(submode-rhs:folds:for:6)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:5)  -->  5w
€ýR(submode-prefix:folds)Â Â Â Â Â 5  -->  €ýR(submode-rhs:folds:for:5)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:4)  -->  4w
€ýR(submode-prefix:folds)Â Â Â Â Â 4  -->  €ýR(submode-rhs:folds:for:4)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:3)  -->  3w
€ýR(submode-prefix:folds)Â Â Â Â Â 3  -->  €ýR(submode-rhs:folds:for:3)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:2)  -->  2w
€ýR(submode-prefix:folds)Â Â Â Â Â 2  -->  €ýR(submode-rhs:folds:for:2)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:1)  -->  1w
€ýR(submode-prefix:folds)Â Â Â Â Â 1  -->  €ýR(submode-rhs:folds:for:1)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:])  -->  ]z
€ýR(submode-prefix:folds)Â Â Â Â Â ]  -->  €ýR(submode-rhs:folds:for:])€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:[)  -->  [z
€ýR(submode-prefix:folds)Â Â Â Â Â [  -->  €ýR(submode-rhs:folds:for:[)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:k)  -->  zk
€ýR(submode-prefix:folds)Â Â Â Â Â k  -->  €ýR(submode-rhs:folds:for:k)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:j)  -->  zj
€ýR(submode-prefix:folds)Â Â Â Â Â j  -->  €ýR(submode-rhs:folds:for:j)€ýR(submode-enter:folds)
€ýR(submode-leave:folds)  -->  @=€ýQ146_on_leaving_submode('folds')
€ýR(submode-prefix:folds)Â Â Â Â Â   -->  €ýR(submode-leave:folds)
€ýR(submode-before-action:folds)  -->  €ýQ146_on_executing_action('folds')
€ýR(submode-enter:folds)  -->  €ýR(submode-before-action:folds)€ýR(submode-prefix:folds)Â Â Â Â Â 
€ýR(submode-before-entering:folds)  -->  €ýQ146_on_entering_submode('folds')
€ýR(submode-before-entering:folds:with:zf)  -->  jk
€ýR(submode-rhs:folds:for:q)  -->  
€ýR(submode-prefix:folds)Â Â Â Â Â q  -->  €ýR(submode-rhs:folds:for:q)€ýR(submode-leave:folds)
€ýR(submode-rhs:folds:for:)  -->  
€ýR(submode-prefix:folds)Â Â Â Â Â   -->  €ýR(submode-rhs:folds:for:)€ýR(submode-leave:folds)
€ýR(submode-rhs:folds:for:)  -->  
€ýR(submode-prefix:folds)Â Â Â Â Â   -->  €ýR(submode-rhs:folds:for:)€ýR(submode-leave:folds)
€ýR(submode-rhs:windows:for:T)  -->  T
€ýR(submode-prefix:windows)Â Â Â Â Â T  -->  €ýR(submode-rhs:windows:for:T)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:L)  -->  L
€ýR(submode-prefix:windows)Â Â Â Â Â L  -->  €ýR(submode-rhs:windows:for:L)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:K)  -->  K
€ýR(submode-prefix:windows)Â Â Â Â Â K  -->  €ýR(submode-rhs:windows:for:K)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:J)  -->  J
€ýR(submode-prefix:windows)Â Â Â Â Â J  -->  €ýR(submode-rhs:windows:for:J)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:H)  -->  H
€ýR(submode-prefix:windows)Â Â Â Â Â H  -->  €ýR(submode-rhs:windows:for:H)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:x)  -->  x
€ýR(submode-prefix:windows)Â Â Â Â Â x  -->  €ýR(submode-rhs:windows:for:x)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:R)  -->  R
€ýR(submode-prefix:windows)Â Â Â Â Â R  -->  €ýR(submode-rhs:windows:for:R)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:r)  -->  r
€ýR(submode-prefix:windows)Â Â Â Â Â r  -->  €ýR(submode-rhs:windows:for:r)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:o)  -->  o
€ýR(submode-prefix:windows)Â Â Â Â Â o  -->  €ýR(submode-rhs:windows:for:o)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:c)  -->  c
€ýR(submode-prefix:windows)Â Â Â Â Â c  -->  €ýR(submode-rhs:windows:for:c)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:=)  -->  =
€ýR(submode-prefix:windows)Â Â Â Â Â =  -->  €ýR(submode-rhs:windows:for:=)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:_)  -->  10-
€ýR(submode-prefix:windows)Â Â Â Â Â _  -->  €ýR(submode-rhs:windows:for:_)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:+)  -->  10+
€ýR(submode-prefix:windows)Â Â Â Â Â +  -->  €ýR(submode-rhs:windows:for:+)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:[)  -->  -
€ýR(submode-prefix:windows)Â Â Â Â Â [  -->  €ýR(submode-rhs:windows:for:[)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:])  -->  +
€ýR(submode-prefix:windows)Â Â Â Â Â ]  -->  €ýR(submode-rhs:windows:for:])€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:<)  -->  10<
€ýR(submode-prefix:windows)Â Â Â Â Â <  -->  €ýR(submode-rhs:windows:for:<)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:>)  -->  10>
€ýR(submode-prefix:windows)Â Â Â Â Â >  -->  €ýR(submode-rhs:windows:for:>)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:,)  -->  <
€ýR(submode-prefix:windows)Â Â Â Â Â ,  -->  €ýR(submode-rhs:windows:for:,)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:.)  -->  >
€ýR(submode-prefix:windows)Â Â Â Â Â .  -->  €ýR(submode-rhs:windows:for:.)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:s)  -->  s
€ýR(submode-prefix:windows)Â Â Â Â Â s  -->  €ýR(submode-rhs:windows:for:s)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:v)  -->  v
€ýR(submode-prefix:windows)Â Â Â Â Â v  -->  €ýR(submode-rhs:windows:for:v)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:6)  -->  6w
€ýR(submode-prefix:windows)Â Â Â Â Â 6  -->  €ýR(submode-rhs:windows:for:6)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:5)  -->  5w
€ýR(submode-prefix:windows)Â Â Â Â Â 5  -->  €ýR(submode-rhs:windows:for:5)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:4)  -->  4w
€ýR(submode-prefix:windows)Â Â Â Â Â 4  -->  €ýR(submode-rhs:windows:for:4)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:3)  -->  3w
€ýR(submode-prefix:windows)Â Â Â Â Â 3  -->  €ýR(submode-rhs:windows:for:3)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:2)  -->  2w
€ýR(submode-prefix:windows)Â Â Â Â Â 2  -->  €ýR(submode-rhs:windows:for:2)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:1)  -->  1w
€ýR(submode-prefix:windows)Â Â Â Â Â 1  -->  €ýR(submode-rhs:windows:for:1)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:p)  -->  p
€ýR(submode-prefix:windows)Â Â Â Â Â p  -->  €ýR(submode-rhs:windows:for:p)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:b)  -->  b
€ýR(submode-prefix:windows)Â Â Â Â Â b  -->  €ýR(submode-rhs:windows:for:b)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:t)  -->  t
€ýR(submode-prefix:windows)Â Â Â Â Â t  -->  €ýR(submode-rhs:windows:for:t)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:l)  -->  l
€ýR(submode-prefix:windows)Â Â Â Â Â l  -->  €ýR(submode-rhs:windows:for:l)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:k)  -->  k
€ýR(submode-prefix:windows)Â Â Â Â Â k  -->  €ýR(submode-rhs:windows:for:k)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:j)  -->  j
€ýR(submode-prefix:windows)Â Â Â Â Â j  -->  €ýR(submode-rhs:windows:for:j)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:h)  -->  h
€ýR(submode-prefix:windows)Â Â Â Â Â h  -->  €ýR(submode-rhs:windows:for:h)€ýR(submode-enter:windows)
€ýR(submode-leave:windows)  -->  @=€ýQ146_on_leaving_submode('windows')
€ýR(submode-prefix:windows)Â Â Â Â Â   -->  €ýR(submode-leave:windows)
€ýR(submode-before-action:windows)  -->  €ýQ146_on_executing_action('windows')
€ýR(submode-enter:windows)  -->  €ýR(submode-before-action:windows)€ýR(submode-prefix:windows)Â Â Â Â Â 
€ýR(submode-before-entering:windows)  -->  €ýQ146_on_entering_submode('windows')
€ýR(submode-before-entering:windows:with:g)  -->  jk
€ýR(submode-rhs:windows:for:q)  -->  
€ýR(submode-prefix:windows)Â Â Â Â Â q  -->  €ýR(submode-rhs:windows:for:q)€ýR(submode-leave:windows)
€ýR(submode-rhs:windows:for:)  -->  
€ýR(submode-prefix:windows)Â Â Â Â Â   -->  €ýR(submode-rhs:windows:for:)€ýR(submode-leave:windows)
€ýR(submode-rhs:windows:for:)  -->  
€ýR(submode-prefix:windows)Â Â Â Â Â   -->  €ýR(submode-rhs:windows:for:)€ýR(submode-leave:windows)
€ýR(submode-rhs:undo/redo:for:+)  -->  g+
€ýR(submode-prefix:undo/redo)Â Â Â Â Â +  -->  €ýR(submode-rhs:undo/redo:for:+)€ýR(submode-enter:undo/redo)
€ýR(submode-rhs:undo/redo:for:-)  -->  g-
€ýR(submode-prefix:undo/redo)Â Â Â Â Â -  -->  €ýR(submode-rhs:undo/redo:for:-)€ýR(submode-enter:undo/redo)
€ýR(submode-before-entering:undo/redo:with:g+)  -->  g+
€ýR(submode-leave:undo/redo)  -->  @=€ýQ146_on_leaving_submode('undo/redo')
€ýR(submode-prefix:undo/redo)Â Â Â Â Â   -->  €ýR(submode-leave:undo/redo)
€ýR(submode-before-action:undo/redo)  -->  €ýQ146_on_executing_action('undo/redo')
€ýR(submode-enter:undo/redo)  -->  €ýR(submode-before-action:undo/redo)€ýR(submode-prefix:undo/redo)Â Â Â Â Â 
€ýR(submode-before-entering:undo/redo)  -->  €ýQ146_on_entering_submode('undo/redo')
€ýR(submode-before-entering:undo/redo:with:g-)  -->  g-
€ýR(submode-rhs:undo/redo:for:q)  -->  
€ýR(submode-prefix:undo/redo)Â Â Â Â Â q  -->  €ýR(submode-rhs:undo/redo:for:q)€ýR(submode-leave:undo/redo)
€ýR(submode-rhs:undo/redo:for:)  -->  
€ýR(submode-prefix:undo/redo)Â Â Â Â Â   -->  €ýR(submode-rhs:undo/redo:for:)€ýR(submode-leave:undo/redo)
€ýR(submode-rhs:undo/redo:for:)  -->  
€ýR(submode-prefix:undo/redo)Â Â Â Â Â   -->  €ýR(submode-rhs:undo/redo:for:)€ýR(submode-leave:undo/redo)
€ýRNetrwBrowseXVis  -->  :call netrw#BrowseXVis()
€ýRNetrwBrowseX  -->  :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())
€K9  -->  €ýR(visualstar-*)
€ýQ124_(extra_commands)  -->  €ýQ124_extra_commands()
€ýQ124_(count)  -->  €ýQ124_count()
€ýR(visualstar-g#)  -->  :call €ýQ124_search('?', 1)€ýQ124_(count)€ýQ124_(extra_commands)
€ýR(visualstar-g*)  -->  :call €ýQ124_search('/', 1)€ýQ124_(count)€ýQ124_(extra_commands)
€ýR(visualstar-#)  -->  :call €ýQ124_search('?', 0)€ýQ124_(count)€ýQ124_(extra_commands)
€ýR(visualstar-*)  -->  :call €ýQ124_search('/', 0)€ýQ124_(count)€ýQ124_(extra_commands)
€ýR(visualstar-g#)  -->  g#
€ýR(visualstar-g*)  -->  g*
€ýR(visualstar-#)  -->  #
€ýR(visualstar-*)  -->  *
€ýRVimpleMRU  -->  :echo vimple#undolist#print_mru() . "\n":buffer 
€ýRvimple_filter  -->  :Filter
€ýRvimple_spell_suggest  -->  :call SpellSuggest(expand('<cword>'))
€ýRvimple_ident_search_forward  -->  :call IdentSearch(1)
€ýRvimple_ident_search  -->  :call IdentSearch(0)
€ýRvimple_tag_search  -->  :call TagSearch()
€ýRvfm_argument  -->  :call feedkeys(":VFMArgument \")
€ýRvfm_browse_bufs  -->  :VFMBufs
€ýRvfm_browse_args  -->  :VFMArglist
€ýRvfm_browse_paths  -->  :call VimFindsMeOpts('&path')
€ýRvfm_browse_dirs  -->  :VFMCD
€ýRvfm_browse_files  -->  :VFMEdit
€ýRunimpaired_line_xml_decode  -->  :call €ýQ110_Transform("xml_decode",v:count1)
€ýRunimpaired_xml_decode  -->  :call €ýQ110_Transform("xml_decode",visualmode())
€ýRunimpaired_xml_decode  -->  :call €ýQ110_TransformSetup("xml_decode")g@
€ýRunimpaired_line_xml_encode  -->  :call €ýQ110_Transform("xml_encode",v:count1)
€ýRunimpaired_xml_encode  -->  :call €ýQ110_Transform("xml_encode",visualmode())
€ýRunimpaired_xml_encode  -->  :call €ýQ110_TransformSetup("xml_encode")g@
€ýRunimpaired_line_url_decode  -->  :call €ýQ110_Transform("url_decode",v:count1)
€ýRunimpaired_url_decode  -->  :call €ýQ110_Transform("url_decode",visualmode())
€ýRunimpaired_url_decode  -->  :call €ýQ110_TransformSetup("url_decode")g@
€ýRunimpaired_line_url_encode  -->  :call €ýQ110_Transform("url_encode",v:count1)
€ýRunimpaired_url_encode  -->  :call €ýQ110_Transform("url_encode",visualmode())
€ýRunimpaired_url_encode  -->  :call €ýQ110_TransformSetup("url_encode")g@
€ýRunimpaired_line_string_decode  -->  :call €ýQ110_Transform("string_decode",v:count1)
€ýRunimpaired_string_decode  -->  :call €ýQ110_Transform("string_decode",visualmode())
€ýRunimpaired_string_decode  -->  :call €ýQ110_TransformSetup("string_decode")g@
€ýRunimpaired_line_string_encode  -->  :call €ýQ110_Transform("string_encode",v:count1)
€ýRunimpaired_string_encode  -->  :call €ýQ110_Transform("string_encode",visualmode())
€ýRunimpaired_string_encode  -->  :call €ýQ110_TransformSetup("string_encode")g@
€ýRunimpairedPutBelow  -->  :call €ýQ110_putline(']p', 'Below')
€ýRunimpairedPutAbove  -->  :call €ýQ110_putline('[p', 'Above')
€ýRunimpairedPaste  -->  :call €ýQ110_setup_paste()
€ýRunimpairedMoveSelectionDown  -->  :call €ýQ110_MoveSelectionDown(v:count1)
€ýRunimpairedMoveSelectionUp  -->  :call €ýQ110_MoveSelectionUp(v:count1)
€ýRunimpairedMoveDown  -->  :call €ýQ110_Move('+',v:count1,'Down')
€ýRunimpairedMoveUp  -->  :call €ýQ110_Move('--',v:count1,'Up')
€ýRunimpairedBlankDown  -->  :call €ýQ110_BlankDown(v:count1)
€ýRunimpairedBlankUp  -->  :call €ýQ110_BlankUp(v:count1)
€ýRunimpairedContextNext  -->  :call €ýQ110_ContextMotion(0)
€ýRunimpairedContextPrevious  -->  :call €ýQ110_ContextMotion(1)
€ýRunimpairedContextNext  -->  :call €ýQ110_Context(0)
€ýRunimpairedContextPrevious  -->  :call €ýQ110_Context(1)
€ýRunimpairedOPrevious  -->  €ýRunimpairedDirectoryPrevious:echohl WarningMSG|echo "[o is deprecated. Use [f"|echohl NONE
€ýRunimpairedONext  -->  €ýRunimpairedDirectoryNext:echohl WarningMSG|echo "]o is deprecated. Use ]f"|echohl NONE
€ýRunimpairedDirectoryPrevious  -->  :edit =fnamemodify(€ýQ110_fnameescape(€ýQ110_FileByOffset(-v:count1)), ':.')
€ýRunimpairedDirectoryNext  -->  :edit =fnamemodify(€ýQ110_fnameescape(€ýQ110_FileByOffset(v:count1)), ':.')
€ýRunimpairedTLast  -->  :exe "".(v:count ? v:count : "")."tlast"
€ýRunimpairedTFirst  -->  :exe "".(v:count ? v:count : "")."tfirst"
€ýRunimpairedTNext  -->  :exe "".(v:count ? v:count : "")."tnext"
€ýRunimpairedTPrevious  -->  :exe "".(v:count ? v:count : "")."tprevious"
€ýRunimpairedQNFile  -->  :exe "".(v:count ? v:count : "")."cnfile"zv
€ýRunimpairedQPFile  -->  :exe "".(v:count ? v:count : "")."cpfile"zv
€ýRunimpairedQLast  -->  :exe "".(v:count ? v:count : "")."clast"zv
€ýRunimpairedQFirst  -->  :exe "".(v:count ? v:count : "")."cfirst"zv
€ýRunimpairedQNext  -->  :exe "".(v:count ? v:count : "")."cnext"zv
€ýRunimpairedQPrevious  -->  :exe "".(v:count ? v:count : "")."cprevious"zv
€ýRunimpairedLNFile  -->  :exe "".(v:count ? v:count : "")."lnfile"zv
€ýRunimpairedLPFile  -->  :exe "".(v:count ? v:count : "")."lpfile"zv
€ýRunimpairedLLast  -->  :exe "".(v:count ? v:count : "")."llast"zv
€ýRunimpairedLFirst  -->  :exe "".(v:count ? v:count : "")."lfirst"zv
€ýRunimpairedLNext  -->  :exe "".(v:count ? v:count : "")."lnext"zv
€ýRunimpairedLPrevious  -->  :exe "".(v:count ? v:count : "")."lprevious"zv
€ýRunimpairedBLast  -->  :exe "".(v:count ? v:count : "")."blast"
€ýRunimpairedBFirst  -->  :exe "".(v:count ? v:count : "")."bfirst"
€ýRunimpairedBNext  -->  :exe "".(v:count ? v:count : "")."bnext"
€ýRunimpairedBPrevious  -->  :exe "".(v:count ? v:count : "")."bprevious"
€ýRunimpairedALast  -->  :exe "".(v:count ? v:count : "")."last"
€ýRunimpairedAFirst  -->  :exe "".(v:count ? v:count : "")."first"
€ýRunimpairedANext  -->  :exe "".(v:count ? v:count : "")."next"
€ýRunimpairedAPrevious  -->  :exe "".(v:count ? v:count : "")."previous"
€kD  -->  c
€kb  -->  c
€k3  -->  :call UltiSnips#ListSnippets()
€ýRVgSurround  -->  :call €ýQ95_opfunc(visualmode(),visualmode() ==# 'V' ? 0 : 1)
€ýRVSurround  -->  :call €ýQ95_opfunc(visualmode(),visualmode() ==# 'V' ? 1 : 0)
€ýRYSurround  -->  :set opfunc=€ýQ95_opfunc2g@
€ýRYsurround  -->  :set opfunc=€ýQ95_opfuncg@
€ýRYSsurround  -->  :call €ýQ95_opfunc2(v:count1)
€ýRYssurround  -->  :call €ýQ95_opfunc(v:count1)
€ýRCSurround  -->  :call €ýQ95_changesurround(1)
€ýRCsurround  -->  :call €ýQ95_changesurround()
€ýRDsurround  -->  :call €ýQ95_dosurround(€ýQ95_inputtarget())
€ýRSurroundRepeat  -->  .
€ýRSneakPrevious  -->  €ýRSneak_,
€ýRSneakNext  -->  €ýRSneak_;
€ýRSneakPrevious  -->  €ýRSneak_,
€ýRSneakNext  -->  €ýRSneak_;
€ýRSneakPrevious  -->  €ýRSneak_,
€ýRSneakNext  -->  €ýRSneak_;
€ýR(SneakStreakBackward)  -->  €ýRSneakLabel_S
€ýR(SneakStreak)  -->  €ýRSneakLabel_s
€ýR(SneakStreakBackward)  -->  €ýRSneakLabel_S
€ýR(SneakStreak)  -->  €ýRSneakLabel_s
€ýR(SneakStreakBackward)  -->  €ýRSneakLabel_S
€ýR(SneakStreak)  -->  €ýRSneakLabel_s
€ýRVSneakPrevious  -->  €ýRSneak_,
€ýRVSneakNext  -->  €ýRSneak_;
€ýRVSneakBackward  -->  €ýRSneak_S
€ýRVSneakForward  -->  €ýRSneak_s
€ýRSneakBackward  -->  €ýRSneak_S
€ýRSneakForward  -->  €ýRSneak_s
€ýRSneakLabel_S  -->  :call sneak#wrap(v:operator, 2, 1, 2, 2)
€ýRSneakLabel_s  -->  :call sneak#wrap(v:operator, 2, 0, 2, 2)
€ýRSneakLabel_S  -->  :call sneak#wrap(visualmode(), 2, 1, 2, 2)
€ýRSneakLabel_s  -->  :call sneak#wrap(visualmode(), 2, 0, 2, 2)
€ýRSneakLabel_S  -->  :call sneak#wrap('', 2, 1, 2, 2)
€ýRSneakLabel_s  -->  :call sneak#wrap('', 2, 0, 2, 2)
€ýRSneak_T  -->  :call sneak#wrap(v:operator, 1, 1, 0, 0)
€ýRSneak_t  -->  :call sneak#wrap(v:operator, 1, 0, 0, 0)
€ýRSneak_T  -->  :call sneak#wrap(visualmode(), 1, 1, 0, 0)
€ýRSneak_t  -->  :call sneak#wrap(visualmode(), 1, 0, 0, 0)
€ýRSneak_T  -->  :call sneak#wrap('', 1, 1, 0, 0)
€ýRSneak_t  -->  :call sneak#wrap('', 1, 0, 0, 0)
€ýRSneak_F  -->  :call sneak#wrap(v:operator, 1, 1, 1, 0)
€ýRSneak_f  -->  :call sneak#wrap(v:operator, 1, 0, 1, 0)
€ýRSneak_F  -->  :call sneak#wrap(visualmode(), 1, 1, 1, 0)
€ýRSneak_f  -->  :call sneak#wrap(visualmode(), 1, 0, 1, 0)
€ýRSneak_F  -->  :call sneak#wrap('', 1, 1, 1, 0)
€ýRSneak_f  -->  :call sneak#wrap('', 1, 0, 1, 0)
€ýRSneak_,  -->  :call sneak#rpt(v:operator, 1)
€ýRSneak_;  -->  :call sneak#rpt(v:operator, 0)
€ýRSneak_,  -->  :call sneak#rpt(visualmode(), 1)
€ýRSneak_;  -->  :call sneak#rpt(visualmode(), 0)
€ýRSneak_,  -->  :call sneak#rpt('', 1)
€ýRSneak_;  -->  :call sneak#rpt('', 0)
€ýRSneakRepeat  -->  :call sneak#wrap(v:operator, sneak#util#getc(), sneak#util#getc(), sneak#util#getc(), sneak#util#getc())
€ýRSneak_S  -->  :call sneak#wrap(v:operator, 2, 1, 2, 1)
€ýRSneak_s  -->  :call sneak#wrap(v:operator, 2, 0, 2, 1)
€ýRSneak_S  -->  :call sneak#wrap(visualmode(), 2, 1, 2, 1)
€ýRSneak_s  -->  :call sneak#wrap(visualmode(), 2, 0, 2, 1)
€ýRSneak_S  -->  :call sneak#wrap('', 2, 1, 2, 1)
€ýRSneak_s  -->  :call sneak#wrap('', 2, 0, 2, 1)
€ýRSidewaysArgumentTextobjI  -->  :call sideways#textobj#Argument('i')
€ýRSidewaysArgumentTextobjI  -->  :call sideways#textobj#Argument('i')
€ýRSidewaysArgumentTextobjA  -->  :call sideways#textobj#Argument('a')
€ýRSidewaysArgumentTextobjA  -->  :call sideways#textobj#Argument('a')
€ýRSidewaysRight  -->  :SidewaysRight
€ýRSidewaysLeft  -->  :SidewaysLeft
€ýR(sexp_capture_next_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'v', 1, 1)
€ýR(sexp_capture_next_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'n', 1, 1) | call €ýQ90_repeat_set("\€ýR(sexp_capture_next_element)", b:sexp_count)
€ýR(sexp_capture_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'v', 0, 1)
€ýR(sexp_capture_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'n', 0, 1) | call €ýQ90_repeat_set("\€ýR(sexp_capture_prev_element)", b:sexp_count)
€ýR(sexp_emit_tail_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'v', 1, 0)
€ýR(sexp_emit_tail_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'n', 1, 0) | call €ýQ90_repeat_set("\€ýR(sexp_emit_tail_element)", b:sexp_count)
€ýR(sexp_emit_head_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'v', 0, 0)
€ýR(sexp_emit_head_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'n', 0, 0) | call €ýQ90_repeat_set("\€ýR(sexp_emit_head_element)", b:sexp_count)
€ýR(sexp_swap_element_forward)  -->  :call sexp#docount(v:prevcount, 'sexp#swap_element', 'v', 1, 0)
€ýR(sexp_swap_element_forward)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#swap_element', 'n', 1, 0) | call €ýQ90_repeat_set("\€ýR(sexp_swap_element_forward)", b:sexp_count)
€ýR(sexp_swap_element_backward)  -->  :call sexp#docount(v:prevcount, 'sexp#swap_element', 'v', 0, 0)
€ýR(sexp_swap_element_backward)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#swap_element', 'n', 0, 0) | call €ýQ90_repeat_set("\€ýR(sexp_swap_element_backward)", b:sexp_count)
€ýR(sexp_swap_list_forward)  -->  :call sexp#docount(v:prevcount, 'sexp#swap_element', 'v', 1, 1)
€ýR(sexp_swap_list_forward)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#swap_element', 'n', 1, 1) | call €ýQ90_repeat_set("\€ýR(sexp_swap_list_forward)", b:sexp_count)
€ýR(sexp_swap_list_backward)  -->  :call sexp#docount(v:prevcount, 'sexp#swap_element', 'v', 0, 1)
€ýR(sexp_swap_list_backward)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#swap_element', 'n', 0, 1) | call €ýQ90_repeat_set("\€ýR(sexp_swap_list_backward)", b:sexp_count)
€ýR(sexp_splice_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#splice_list(b:sexp_count) | call €ýQ90_repeat_set("\€ýR(sexp_splice_list)", b:sexp_count)
€ýR(sexp_raise_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#raise', 'v', '')
€ýR(sexp_raise_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#raise', 'n', 'sexp#select_current_element', 'n', 1) | call €ýQ90_repeat_set("\€ýR(sexp_raise_element)", b:sexp_count)
€ýR(sexp_raise_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#raise', 'v', '')
€ýR(sexp_raise_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#raise', 'n', 'sexp#select_current_list', 'n', 0, 0) | call €ýQ90_repeat_set("\€ýR(sexp_raise_list)", b:sexp_count)
€ýR(sexp_insert_at_list_tail)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#insert_at_list_terminal(1) | call €ýQ90_repeat_set("\€ýR(sexp_insert_at_list_tail)", b:sexp_count)
€ýR(sexp_insert_at_list_head)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#insert_at_list_terminal(0) | call €ýQ90_repeat_set("\€ýR(sexp_insert_at_list_head)", b:sexp_count)
€ýR(sexp_curly_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '{', '}', 1, g:sexp_insert_after_wrap)
€ýR(sexp_curly_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '{', '}', 1, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_curly_tail_wrap_element)", b:sexp_count)
€ýR(sexp_curly_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '{', '}', 0, g:sexp_insert_after_wrap)
€ýR(sexp_curly_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '{', '}', 0, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_curly_head_wrap_element)", b:sexp_count)
€ýR(sexp_square_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '[', ']', 1, g:sexp_insert_after_wrap)
€ýR(sexp_square_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '[', ']', 1, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_square_tail_wrap_element)", b:sexp_count)
€ýR(sexp_square_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '[', ']', 0, g:sexp_insert_after_wrap)
€ýR(sexp_square_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '[', ']', 0, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_square_head_wrap_element)", b:sexp_count)
€ýR(sexp_round_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '(', ')', 1, g:sexp_insert_after_wrap)
€ýR(sexp_round_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '(', ')', 1, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_round_tail_wrap_element)", b:sexp_count)
€ýR(sexp_round_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '(', ')', 0, g:sexp_insert_after_wrap)
€ýR(sexp_round_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '(', ')', 0, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_round_head_wrap_element)", b:sexp_count)
€ýR(sexp_curly_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '{', '}', 1, g:sexp_insert_after_wrap)
€ýR(sexp_curly_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '{', '}', 1, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_curly_tail_wrap_list)", b:sexp_count)
€ýR(sexp_curly_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '{', '}', 0, g:sexp_insert_after_wrap)
€ýR(sexp_curly_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '{', '}', 0, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_curly_head_wrap_list)", b:sexp_count)
€ýR(sexp_square_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '[', ']', 1, g:sexp_insert_after_wrap)
€ýR(sexp_square_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '[', ']', 1, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_square_tail_wrap_list)", b:sexp_count)
€ýR(sexp_square_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '[', ']', 0, g:sexp_insert_after_wrap)
€ýR(sexp_square_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '[', ']', 0, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_square_head_wrap_list)", b:sexp_count)
€ýR(sexp_round_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '(', ')', 1, g:sexp_insert_after_wrap)
€ýR(sexp_round_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '(', ')', 1, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_round_tail_wrap_list)", b:sexp_count)
€ýR(sexp_round_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '(', ')', 0, g:sexp_insert_after_wrap)
€ýR(sexp_round_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '(', ')', 0, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_round_head_wrap_list)", b:sexp_count)
€ýR(sexp_indent_top)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#indent(1, b:sexp_count) | call €ýQ90_repeat_set("\€ýR(sexp_indent_top)", b:sexp_count)
€ýR(sexp_indent)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#indent(0, b:sexp_count) | call €ýQ90_repeat_set("\€ýR(sexp_indent)", b:sexp_count)
€ýR(sexp_select_next_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'o', 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_select_next_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_select_next_element)", b:sexp_count) | endif
€ýR(sexp_select_next_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'v', 1)
€ýR(sexp_select_next_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'n', 1)
€ýR(sexp_select_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'o', 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_select_prev_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_select_prev_element)", b:sexp_count) | endif
€ýR(sexp_select_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'v', 0)
€ýR(sexp_select_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'n', 0)
€ýR(sexp_move_to_next_top_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#move_to_adjacent_element('o', b:sexp_count, 1, 0, 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_next_top_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_next_top_element)", b:sexp_count) | endif
€ýR(sexp_move_to_next_top_element)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 1, 0, 1)
€ýR(sexp_move_to_next_top_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#move_to_adjacent_element('n', b:sexp_count, 1, 0, 1)
€ýR(sexp_move_to_prev_top_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#move_to_adjacent_element('o', b:sexp_count, 0, 0, 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_prev_top_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_prev_top_element)", b:sexp_count) | endif
€ýR(sexp_move_to_prev_top_element)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 0, 0, 1)
€ýR(sexp_move_to_prev_top_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#move_to_adjacent_element('n', b:sexp_count, 0, 0, 1)
€ýR(sexp_move_to_next_element_tail)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('o', b:sexp_count, 1, 1, 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_next_element_tail)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_next_element_tail)", b:sexp_count) | endif
€ýR(sexp_move_to_next_element_tail)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 1, 1, 0)
€ýR(sexp_move_to_next_element_tail)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('n', b:sexp_count, 1, 1, 0)
€ýR(sexp_move_to_prev_element_tail)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('o', b:sexp_count, 0, 1, 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_prev_element_tail)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_prev_element_tail)", b:sexp_count) | endif
€ýR(sexp_move_to_prev_element_tail)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 0, 1, 0)
€ýR(sexp_move_to_prev_element_tail)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('n', b:sexp_count, 0, 1, 0)
€ýR(sexp_move_to_next_element_head)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('o', b:sexp_count, 1, 0, 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_next_element_head)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_next_element_head)", b:sexp_count) | endif
€ýR(sexp_move_to_next_element_head)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 1, 0, 0)
€ýR(sexp_move_to_next_element_head)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('n', b:sexp_count, 1, 0, 0)
€ýR(sexp_move_to_prev_element_head)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('o', b:sexp_count, 0, 0, 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_prev_element_head)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_prev_element_head)", b:sexp_count) | endif
€ýR(sexp_move_to_prev_element_head)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 0, 0, 0)
€ýR(sexp_move_to_prev_element_head)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('n', b:sexp_count, 0, 0, 0)
€ýR(sexp_move_to_next_bracket)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#move_to_nearest_bracket('o', 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_next_bracket)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_next_bracket)", b:sexp_count) | endif
€ýR(sexp_move_to_next_bracket)  -->  :call sexp#docount(v:prevcount, 'sexp#move_to_nearest_bracket', 'v', 1)
€ýR(sexp_move_to_next_bracket)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#move_to_nearest_bracket', 'n', 1)
€ýR(sexp_move_to_prev_bracket)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#move_to_nearest_bracket('o', 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_prev_bracket)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_prev_bracket)", b:sexp_count) | endif
€ýR(sexp_move_to_prev_bracket)  -->  :call sexp#docount(v:prevcount, 'sexp#move_to_nearest_bracket', 'v', 0)
€ýR(sexp_move_to_prev_bracket)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#move_to_nearest_bracket', 'n', 0)
€ýR(sexp_inner_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_element('o', 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_inner_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_inner_element)", b:sexp_count) | endif
€ýR(sexp_inner_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_element('v', 1)
€ýR(sexp_outer_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_element('o', 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_outer_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_outer_element)", b:sexp_count) | endif
€ýR(sexp_outer_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_element('v', 0)
€ýR(sexp_inner_string)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_string('o', 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_inner_string)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_inner_string)", b:sexp_count) | endif
€ýR(sexp_inner_string)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_string('v', 1)
€ýR(sexp_outer_string)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_string('o', 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_outer_string)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_outer_string)", b:sexp_count) | endif
€ýR(sexp_outer_string)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_string('v', 0)
€ýR(sexp_inner_top_list)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_top_list('o', 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_inner_top_list)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_inner_top_list)", b:sexp_count) | endif
€ýR(sexp_inner_top_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_top_list('v', 1)
€ýR(sexp_outer_top_list)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_top_list('o', 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_outer_top_list)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_outer_top_list)", b:sexp_count) | endif
€ýR(sexp_outer_top_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_top_list('v', 0)
€ýR(sexp_inner_list)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#docount(b:sexp_count, 'sexp#select_current_list', 'o', 1, 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_inner_list)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_inner_list)", b:sexp_count) | endif
€ýR(sexp_inner_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_current_list', 'v', 1, 1)
€ýR(sexp_outer_list)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#docount(b:sexp_count, 'sexp#select_current_list', 'o', 0, 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_outer_list)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_outer_list)", b:sexp_count) | endif
€ýR(sexp_outer_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_current_list', 'v', 0, 1)
€ýR(RepeatRedo)  -->  :call repeat#wrap("\<C-R>",v:count)
€ýR(RepeatUndoLine)  -->  :call repeat#wrap('U',v:count)
€ýR(RepeatUndo)  -->  :call repeat#wrap('u',v:count)
€ýR(RepeatDot)  -->  :exe repeat#run(v:count)
€ýR(GrepperOperator)  -->  :call grepper#operator(visualmode())
€ýR(GrepperOperator)  -->  :set opfunc=grepper#operatorg@
€ýQ63_:  -->  :=v:count ? v:count : ''
€ýR(ExchangeLine)  -->  ':set operatorfunc=€ýQ62_exchange_set'.(v:count1 == 1 ? '' : v:count1).'g@_'
€ýR(ExchangeClear)  -->  :call €ýQ62_exchange_clear()
€ýR(Exchange)  -->  :call €ýQ62_exchange_set(visualmode(), 1)
€ýR(Exchange)  -->  ':set operatorfunc=€ýQ62_exchange_set'.(v:count1 == 1 ? '' : v:count1).'g@'
€ýR(OuterDENTURE)  -->  :call dentures#select(line('.'), 1, 1, 'operator')
€ýR(OuterDenture)  -->  :call dentures#select(line('.'), 1, 0, 'operator')
€ýR(InnerDENTURE)  -->  :call dentures#select(line('.'), 0, 1, 'operator')
€ýR(InnerDenture)  -->  :call dentures#select(line('.'), 0, 0, 'operator')
€ýR(OuterDENTURE)  -->  dentures#select(line('.'), 1, 1, mode())
€ýR(OuterDenture)  -->  dentures#select(line('.'), 1, 0, mode())
€ýR(InnerDENTURE)  -->  dentures#select(line('.'), 0, 1, mode())
€ýR(InnerDenture)  -->  dentures#select(line('.'), 0, 0, mode())
€ÿX  -->  :CtrlP
€ýRCommentaryUndo  -->  €ýRCommentary€ýRCommentary
€ýRChangeCommentary  -->  c:call €ýQ56_textobject(1)
€ýRCommentary  -->  :call €ýQ56_textobject(0)
€ýRCommentaryLine  -->  :set opfunc=€ýQ56_go|exe 'norm! 'v:count1.'g@_'
€ýRCommentary  -->  :set opfunc=€ýQ56_gog@
€ýRCommentary  -->  :call €ýQ56_go(line("'<"),line("'>"))
€ýRCoerce  -->  :call €ýQ55_coerce(nr2char(getchar()))
€ü€k8  -->  :call €ýQ50_NextColor(0, 1)
€ý  -->  :call €ýQ50_NextColor(-1, 1)
€k8  -->  :call €ýQ50_NextColor(1, 1)
€ýRremove_vimple_ident_search_forward  -->  €ýRvimple_ident_search_forward
€ýRremove_vimple_ident_search  -->  €ýRvimple_ident_search
€ýRremove_vimple_spell_suggest  -->  €ýRvimple_spell_suggest
€ýRremove_vimple_tag_search  -->  €ýRvimple_tag_search
€k5  -->  :GundoToggle
€ü   -->  €ÿX
€ku  -->  DVB_Drag('up')
€kd  -->  DVB_Drag('down')
€kr  -->  DVB_Drag('right')
€kl  -->  DVB_Drag('left')
€ý/  -->  €ý,:silent RunCommand
€k2  -->  y:exe getreg('"')
€k2  -->  :call RunCommand(0)
€k9  -->  :Neomake!
€F2  -->  :!ctags -R --fields=+iaS --extra=+qf .
€k;  -->  :%s/\s\+$//:nohlsearch
€ý2  -->  €ý,:silent call helpers#plumb_this()
€ý.  -->  €ý."*ygv
  -->  
S  -->  €ýRISurround
s  -->  €ýRIsurround
	  -->  =UltiSnips#ExpandSnippet()
  -->  €ýRIsurround
  -->  complete#trigger('completers#datetime')
  -->  complete#trigger('completers#abbrevs')
-  -->  _
_  -->  -
(gdb) 
vshcmd: > pipe nvim-maps | show print-string {0}->m_keys; "  -->  "; {0}->m_str; "\n"
\x80\xfdRvimple_completers_trigger  -->  complete#trigger('completers#trigger')
\x80k3  -->  =UltiSnips#ListSnippets()
\x80\xfdRISurround  -->  =\x80\xfdQ95_insert(1)
\x80\xfdRIsurround  -->  =\x80\xfdQ95_insert()
\x80\xfdR(sexp_insert_backspace)  -->  sexp#backspace_insertion()
\x80\xfdR(sexp_insert_double_quote)  -->  sexp#quote_insertion('"')
\x80\xfdR(sexp_insert_closing_curly)  -->  sexp#closing_insertion('}')
\x80\xfdR(sexp_insert_closing_square)  -->  sexp#closing_insertion(']')
\x80\xfdR(sexp_insert_closing_round)  -->  sexp#closing_insertion(')')
\x80\xfdR(sexp_insert_opening_curly)  -->  sexp#opening_insertion('{')
\x80\xfdR(sexp_insert_opening_square)  -->  sexp#opening_insertion('[')
\x80\xfdR(sexp_insert_opening_round)  -->  sexp#opening_insertion('(')
\x80\xfdRremove_vimple_completers_trigger  -->  \x80\xfdRvimple_completers_trigger
\x80\xfco  -->  o
\x80\xfcO  -->  O
  -->  c
	  -->  :call UltiSnips#SaveLastVisualSelection()gvs
	  -->  :call UltiSnips#ExpandSnippet()
  -->  :nohlsearch:diffupdate:syntax sync fromstart
  -->  "_c
  -->  \x80\xfdR(RepeatRedo)
 wl  -->  :call  \x80\xfdQ54_MoveWindow('l')
 wk  -->  :call  \x80\xfdQ54_MoveWindow('k')
 wj  -->  :call  \x80\xfdQ54_MoveWindow('j')
 wh  -->  :call  \x80\xfdQ54_MoveWindow('h')
 st  -->  :silent TQFSelect! 
 qd  -->  :QFilterBuf! %
 qb  -->  :QFilterBuf %
 qs  -->  :QuickfixSort
 qr  -->  :QFRemoveCurrent!
 ll  -->  \x80\xfdRvimple_filter
 mu  -->  \x80\xfdRVimpleMRU
 mb  -->  :VFMBadd
 mc  -->  \x80\xfdRvfm_browse_bufs
 mp  -->  \x80\xfdRvfm_browse_paths
 md  -->  \x80\xfdRvfm_browse_dirs
 ma  -->  \x80\xfdRvfm_browse_args
 me  -->  \x80\xfdRvfm_browse_files
 rk  -->  :SyntasticReset
 ok  -->  :SyntasticCheck
 al  -->  :SidewaysRight
 ah  -->  :SidewaysLeft
 pk  -->  :PymodeLint
 hq  -->  :Hgqseries
 hv  -->  :Hglogthis
 hg  -->  :Hglog
 hs  -->  :Hgstatus
 hc  -->  :Hgcommit
 hf  -->  :Hgpull
 hp  -->  :Hgpush
 hd  -->  :Hgvdiff
 sb  -->  :GrepBufs 
 sd  -->  :GrepHere 
 sg  -->  :Grepper -tool git 
 ss  -->  :Grepper -tool grep 
 so  -->  \x80\xfdR(GrepperOperator)
 so  -->  \x80\xfdR(GrepperOperator)
 gv  -->  :Gitv! --all
 gv  -->  :Gitv! --all
 gg  -->  :Gitv --all
 cpf  -->  :CtrlPFunky
 gs  -->  :Gstatus
 gc  -->  :Gcommit
 gf  -->  :Gpurr
 gp  -->  :Gpush
 gd  -->  :Gdiff
 gw  -->  :Gwrite
 fd  -->  :DiffOrig
 ff  -->  :Find 
 fm  -->  :Rename 
 fr  -->  :Unlink
 cpm  -->  :CtrlPMRU
 cpu  -->  :CtrlPUndo
 cpt  -->  :CtrlPTag
 cpq  -->  :CtrlPQuickfix
 cpc  -->  :CtrlPChange
 cpb  -->  :CtrlPBuffer
 mm  -->  \x80\xfdRvfm_argument
 z  -->  :
 '  -->  :
 cn  -->  :setlocal completeopt-=longest
 cl  -->  :setlocal completeopt+=longest
 nh  -->  :nohlsearch
 sh  -->  :Occur! 
 u  -->  :update
 b  -->  :ls:b 
 em  -->  :='let @'. v:register .' = '. string(getreg(v:register))\x80kl
#  -->  \x80\xfdR(visualstar-#)
'\x80\xfd,  -->  \x80\xfd,
'  -->  `
*  -->  \x80\xfdR(visualstar-*)
++  -->  VMATH_YankAndAnalyse()
,  -->  \x80\xfdRSneakNext
,  -->  \x80\xfdRSneakNext
,  -->  \x80\xfdRSneakNext
,  -->  \x80\xfdRSneakNext
.  -->  \x80\xfdR(RepeatDot)
;  -->  \x80\xfdRSneakPrevious
;  -->  \x80\xfdRSneakPrevious
;  -->  \x80\xfdRSneakPrevious
;  -->  \x80\xfdRSneakPrevious
<p  -->  :call \x80\xfdQ110_putline(']p', 'Below')<']
<P  -->  :call \x80\xfdQ110_putline('[p', 'Above')<']
<  -->  <gv
=p  -->  :call \x80\xfdQ110_putline(']p', 'Below')=']
=P  -->  :call \x80\xfdQ110_putline('[p', 'Above')=']
>p  -->  :call \x80\xfdQ110_putline(']p', 'Below')>']
>P  -->  :call \x80\xfdQ110_putline('[p', 'Above')>']
>  -->  >gv
D  -->  DVB_Duplicate()
F\x80\xfd2  -->  \x80\xfd,:silent Occur! 
Q  -->  :call \x80\xfdQ2_Again()
S  -->  \x80\xfdRVSurround
S  -->  \x80\xfdRSneak_S
T\x80\xfd2  -->  \x80\xfd,:silent TQFSelect! 
U  -->  \x80\xfdR(RepeatUndoLine)
U  -->  \x80\xfdRSneak_S
X  -->  \x80\xfdR(Exchange)
Y  -->  y$
Z  -->  \x80\xfdRSneak_S
[xx  -->  \x80\xfdRunimpaired_line_xml_encode
[x  -->  \x80\xfdRunimpaired_xml_encode
[x  -->  \x80\xfdRunimpaired_xml_encode
[uu  -->  \x80\xfdRunimpaired_line_url_encode
[u  -->  \x80\xfdRunimpaired_url_encode
[u  -->  \x80\xfdRunimpaired_url_encode
[yy  -->  \x80\xfdRunimpaired_line_string_encode
[y  -->  \x80\xfdRunimpaired_string_encode
[y  -->  \x80\xfdRunimpaired_string_encode
[p  -->  \x80\xfdRunimpairedPutAbove
[ov  -->  :set virtualedit+=all
[ox  -->  :set cursorline cursorcolumn
[ow  -->  :setlocal wrap=\x80\xfdQ110_statusbump()
[os  -->  :setlocal spell=\x80\xfdQ110_statusbump()
[or  -->  :setlocal relativenumber=\x80\xfdQ110_statusbump()
[on  -->  :setlocal number=\x80\xfdQ110_statusbump()
[ol  -->  :setlocal list=\x80\xfdQ110_statusbump()
[oi  -->  :set ignorecase=\x80\xfdQ110_statusbump()
[oh  -->  :set hlsearch=\x80\xfdQ110_statusbump()
[od  -->  :diffthis
[ou  -->  :setlocal cursorcolumn=\x80\xfdQ110_statusbump()
[oc  -->  :setlocal cursorline=\x80\xfdQ110_statusbump()
[ob  -->  :set background=light
[e  -->  \x80\xfdRunimpairedMoveSelectionUp
[e  -->  \x80\xfdRunimpairedMoveUp
[   -->  \x80\xfdRunimpairedBlankUp
[n  -->  \x80\xfdRunimpairedContextPrevious
[n  -->  \x80\xfdRunimpairedContextPrevious
[f  -->  \x80\xfdRunimpairedDirectoryPrevious
[T  -->  \x80\xfdRunimpairedTFirst
[t  -->  \x80\xfdRunimpairedTPrevious
[  -->  \x80\xfdRunimpairedQPFile
[Q  -->  \x80\xfdRunimpairedQFirst
[q  -->  \x80\xfdRunimpairedQPrevious
[  -->  \x80\xfdRunimpairedLPFile
[L  -->  \x80\xfdRunimpairedLFirst
[l  -->  \x80\xfdRunimpairedLPrevious
[B  -->  \x80\xfdRunimpairedBFirst
[b  -->  \x80\xfdRunimpairedBPrevious
[A  -->  \x80\xfdRunimpairedAFirst
[a  -->  \x80\xfdRunimpairedAPrevious
[ok  -->  :call \x80\xfdQ25_UseVimForMan()
]xx  -->  \x80\xfdRunimpaired_line_xml_decode
]x  -->  \x80\xfdRunimpaired_xml_decode
]x  -->  \x80\xfdRunimpaired_xml_decode
]uu  -->  \x80\xfdRunimpaired_line_url_decode
]u  -->  \x80\xfdRunimpaired_url_decode
]u  -->  \x80\xfdRunimpaired_url_decode
]yy  -->  \x80\xfdRunimpaired_line_string_decode
]y  -->  \x80\xfdRunimpaired_string_decode
]y  -->  \x80\xfdRunimpaired_string_decode
]p  -->  \x80\xfdRunimpairedPutBelow
]ov  -->  :set virtualedit-=all
]ox  -->  :set nocursorline nocursorcolumn
]ow  -->  :setlocal nowrap=\x80\xfdQ110_statusbump()
]os  -->  :setlocal nospell=\x80\xfdQ110_statusbump()
]or  -->  :setlocal norelativenumber=\x80\xfdQ110_statusbump()
]on  -->  :setlocal nonumber=\x80\xfdQ110_statusbump()
]ol  -->  :setlocal nolist=\x80\xfdQ110_statusbump()
]oi  -->  :set noignorecase=\x80\xfdQ110_statusbump()
]oh  -->  :set nohlsearch=\x80\xfdQ110_statusbump()
]od  -->  :diffoff
]ou  -->  :setlocal nocursorcolumn=\x80\xfdQ110_statusbump()
]oc  -->  :setlocal nocursorline=\x80\xfdQ110_statusbump()
]ob  -->  :set background=dark
]e  -->  \x80\xfdRunimpairedMoveSelectionDown
]e  -->  \x80\xfdRunimpairedMoveDown
]   -->  \x80\xfdRunimpairedBlankDown
]n  -->  \x80\xfdRunimpairedContextNext
]n  -->  \x80\xfdRunimpairedContextNext
]f  -->  \x80\xfdRunimpairedDirectoryNext
]T  -->  \x80\xfdRunimpairedTLast
]t  -->  \x80\xfdRunimpairedTNext
]  -->  \x80\xfdRunimpairedQNFile
]Q  -->  \x80\xfdRunimpairedQLast
]q  -->  \x80\xfdRunimpairedQNext
]  -->  \x80\xfdRunimpairedLNFile
]L  -->  \x80\xfdRunimpairedLLast
]l  -->  \x80\xfdRunimpairedLNext
]B  -->  \x80\xfdRunimpairedBLast
]b  -->  \x80\xfdRunimpairedBNext
]A  -->  \x80\xfdRunimpairedALast
]a  -->  \x80\xfdRunimpairedANext
]ok  -->  :unmap <buffer> K
`  -->  '
aI  -->  \x80\xfdR(OuterDENTURE)
aI  -->  \x80\xfdR(OuterDENTURE)
ai  -->  \x80\xfdR(OuterDenture)
ai  -->  \x80\xfdR(OuterDenture)
aa  -->  \x80\xfdRSidewaysArgumentTextobjA
aa  -->  \x80\xfdRSidewaysArgumentTextobjA
cov  -->  :set =(&virtualedit =~# "all") ? 'virtualedit-=all' : 'virtualedit+=all'
cox  -->  :set =&cursorline && &cursorcolumn ? 'nocursorline nocursorcolumn' : 'cursorline cursorcolumn'
cow  -->  :setlocal =\x80\xfdQ110_toggle("wrap")
cos  -->  :setlocal =\x80\xfdQ110_toggle("spell")
cor  -->  :setlocal =\x80\xfdQ110_toggle("relativenumber")
con  -->  :setlocal =\x80\xfdQ110_toggle("number")
col  -->  :setlocal =\x80\xfdQ110_toggle("list")
coi  -->  :set =\x80\xfdQ110_toggle("ignorecase")
coh  -->  :set =\x80\xfdQ110_toggle("hlsearch")
cod  -->  :=&diff ? 'diffoff' : 'diffthis'
cou  -->  :setlocal =\x80\xfdQ110_toggle("cursorcolumn")
coc  -->  :setlocal =\x80\xfdQ110_toggle("cursorline")
cob  -->  :set background==&background == 'dark' ? 'light' : 'dark'
cS  -->  \x80\xfdRCSurround
cs  -->  \x80\xfdRCsurround
cxx  -->  \x80\xfdR(ExchangeLine)
cxc  -->  \x80\xfdR(ExchangeClear)
cx  -->  \x80\xfdR(Exchange)
cgc  -->  \x80\xfdRChangeCommentary
cr  -->  \x80\xfdRCoerce
cw  -->  dwi
ds  -->  \x80\xfdRDsurround
f\x80\xfd2  -->  \x80\xfd,:silent Occur 
gs  -->  \x80\xfdR(submode-before-entering:scrolling:with:gs)\x80\xfdR(submode-before-entering:scrolling)\x80\xfdR(submode-enter:scrolling)
g  -->  \x80\xfdR(submode-before-entering:windows:with:g)\x80\xfdR(submode-before-entering:windows)\x80\xfdR(submode-enter:windows)
g+  -->  \x80\xfdR(submode-before-entering:undo/redo:with:g+)\x80\xfdR(submode-before-entering:undo/redo)\x80\xfdR(submode-enter:undo/redo)
g-  -->  \x80\xfdR(submode-before-entering:undo/redo:with:g-)\x80\xfdR(submode-before-entering:undo/redo)\x80\xfdR(submode-enter:undo/redo)
gx  -->  \x80\xfdRNetrwBrowseXVis
gx  -->  \x80\xfdRNetrwBrowseX
g#  -->  \x80\xfdR(visualstar-g#)
g\x80\xfc\x80\xfd,  -->  \x80\xfdR(visualstar-g*)
g\x80K9  -->  \x80\xfdR(visualstar-g*)
g*  -->  \x80\xfdR(visualstar-g*)
gS  -->  \x80\xfdRVgSurround
gcu  -->  \x80\xfdRCommentary\x80\xfdRCommentary
gcc  -->  \x80\xfdRCommentaryLine
gc  -->  \x80\xfdRCommentary
gc  -->  \x80\xfdRCommentary
gc  -->  \x80\xfdRCommentary
gk  -->  @='4k'
gj  -->  @='4j'
g6  -->  :exe 6 . "wincmd w"
g5  -->  :exe 5 . "wincmd w"
g4  -->  :exe 4 . "wincmd w"
g3  -->  :exe 3 . "wincmd w"
g2  -->  :exe 2 . "wincmd w"
g1  -->  :exe 1 . "wincmd w"
gV  -->  "`[".getregtype(v:register)[0]."`]"
iI  -->  \x80\xfdR(InnerDENTURE)
iI  -->  \x80\xfdR(InnerDENTURE)
ii  -->  \x80\xfdR(InnerDenture)
ii  -->  \x80\xfdR(InnerDenture)
ia  -->  \x80\xfdRSidewaysArgumentTextobjI
ia  -->  \x80\xfdRSidewaysArgumentTextobjI
q\x80\xfd,  -->  	
q\x80\xfd2  -->  
s  -->  \x80\xfdRSneak_s
s  -->  \x80\xfdRSneak_s
t\x80\xfd2  -->  \x80\xfd,:silent TQFSelect 
u  -->  \x80\xfdR(RepeatUndo)
u  -->  \x80\xfdRSneak_s
yO  -->  :call \x80\xfdQ110_setup_paste()O
yo  -->  :call \x80\xfdQ110_setup_paste()o
ySS  -->  \x80\xfdRYSsurround
ySs  -->  \x80\xfdRYSsurround
yss  -->  \x80\xfdRYssurround
yS  -->  \x80\xfdRYSurround
ys  -->  \x80\xfdRYsurround
zf  -->  \x80\xfdR(submode-before-entering:folds:with:zf)\x80\xfdR(submode-before-entering:folds)\x80\xfdR(submode-enter:folds)
zw  -->  ysiw
\x80F1  -->  :!cscope -Rb:cs reset
\x80\xfdR(submode-rhs:scrolling:for:b)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â b  -->  \x80\xfdR(submode-rhs:scrolling:for:b)\x80\xfdR(submode-enter:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:f)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â f  -->  \x80\xfdR(submode-rhs:scrolling:for:f)\x80\xfdR(submode-enter:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:u)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â u  -->  \x80\xfdR(submode-rhs:scrolling:for:u)\x80\xfdR(submode-enter:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:d)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â d  -->  \x80\xfdR(submode-rhs:scrolling:for:d)\x80\xfdR(submode-enter:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:k)  -->  10
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â k  -->  \x80\xfdR(submode-rhs:scrolling:for:k)\x80\xfdR(submode-enter:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:j)  -->  10
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â j  -->  \x80\xfdR(submode-rhs:scrolling:for:j)\x80\xfdR(submode-enter:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:y)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â y  -->  \x80\xfdR(submode-rhs:scrolling:for:y)\x80\xfdR(submode-enter:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:e)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â e  -->  \x80\xfdR(submode-rhs:scrolling:for:e)\x80\xfdR(submode-enter:scrolling)
\x80\xfdR(submode-leave:scrolling)  -->  @=\x80\xfdQ146_on_leaving_submode('scrolling')
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â   -->  \x80\xfdR(submode-leave:scrolling)
\x80\xfdR(submode-before-action:scrolling)  -->  \x80\xfdQ146_on_executing_action('scrolling')
\x80\xfdR(submode-enter:scrolling)  -->  \x80\xfdR(submode-before-action:scrolling)\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â 
\x80\xfdR(submode-before-entering:scrolling)  -->  \x80\xfdQ146_on_entering_submode('scrolling')
\x80\xfdR(submode-before-entering:scrolling:with:gs)  -->  jk
\x80\xfdR(submode-rhs:scrolling:for:q)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â q  -->  \x80\xfdR(submode-rhs:scrolling:for:q)\x80\xfdR(submode-leave:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â   -->  \x80\xfdR(submode-rhs:scrolling:for:)\x80\xfdR(submode-leave:scrolling)
\x80\xfdR(submode-rhs:scrolling:for:)  -->  
\x80\xfdR(submode-prefix:scrolling)Â Â Â Â Â   -->  \x80\xfdR(submode-rhs:scrolling:for:)\x80\xfdR(submode-leave:scrolling)
\x80\xfdR(submode-rhs:folds:for:z)  -->  zz
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â z  -->  \x80\xfdR(submode-rhs:folds:for:z)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:b)  -->  zb
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â b  -->  \x80\xfdR(submode-rhs:folds:for:b)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:t)  -->  zt
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â t  -->  \x80\xfdR(submode-rhs:folds:for:t)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:C)  -->  zC
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â C  -->  \x80\xfdR(submode-rhs:folds:for:C)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:c)  -->  zc
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â c  -->  \x80\xfdR(submode-rhs:folds:for:c)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:O)  -->  zO
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â O  -->  \x80\xfdR(submode-rhs:folds:for:O)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:o)  -->  zo
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â o  -->  \x80\xfdR(submode-rhs:folds:for:o)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:v)  -->  zv
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â v  -->  \x80\xfdR(submode-rhs:folds:for:v)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:x)  -->  zx
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â x  -->  \x80\xfdR(submode-rhs:folds:for:x)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:R)  -->  zR
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â R  -->  \x80\xfdR(submode-rhs:folds:for:R)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:r)  -->  zr
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â r  -->  \x80\xfdR(submode-rhs:folds:for:r)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:M)  -->  zM
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â M  -->  \x80\xfdR(submode-rhs:folds:for:M)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:m)  -->  zm
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â m  -->  \x80\xfdR(submode-rhs:folds:for:m)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:6)  -->  6w
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â 6  -->  \x80\xfdR(submode-rhs:folds:for:6)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:5)  -->  5w
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â 5  -->  \x80\xfdR(submode-rhs:folds:for:5)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:4)  -->  4w
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â 4  -->  \x80\xfdR(submode-rhs:folds:for:4)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:3)  -->  3w
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â 3  -->  \x80\xfdR(submode-rhs:folds:for:3)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:2)  -->  2w
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â 2  -->  \x80\xfdR(submode-rhs:folds:for:2)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:1)  -->  1w
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â 1  -->  \x80\xfdR(submode-rhs:folds:for:1)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:])  -->  ]z
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â ]  -->  \x80\xfdR(submode-rhs:folds:for:])\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:[)  -->  [z
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â [  -->  \x80\xfdR(submode-rhs:folds:for:[)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:k)  -->  zk
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â k  -->  \x80\xfdR(submode-rhs:folds:for:k)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-rhs:folds:for:j)  -->  zj
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â j  -->  \x80\xfdR(submode-rhs:folds:for:j)\x80\xfdR(submode-enter:folds)
\x80\xfdR(submode-leave:folds)  -->  @=\x80\xfdQ146_on_leaving_submode('folds')
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â   -->  \x80\xfdR(submode-leave:folds)
\x80\xfdR(submode-before-action:folds)  -->  \x80\xfdQ146_on_executing_action('folds')
\x80\xfdR(submode-enter:folds)  -->  \x80\xfdR(submode-before-action:folds)\x80\xfdR(submode-prefix:folds)Â Â Â Â Â 
\x80\xfdR(submode-before-entering:folds)  -->  \x80\xfdQ146_on_entering_submode('folds')
\x80\xfdR(submode-before-entering:folds:with:zf)  -->  jk
\x80\xfdR(submode-rhs:folds:for:q)  -->  
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â q  -->  \x80\xfdR(submode-rhs:folds:for:q)\x80\xfdR(submode-leave:folds)
\x80\xfdR(submode-rhs:folds:for:)  -->  
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â   -->  \x80\xfdR(submode-rhs:folds:for:)\x80\xfdR(submode-leave:folds)
\x80\xfdR(submode-rhs:folds:for:)  -->  
\x80\xfdR(submode-prefix:folds)Â Â Â Â Â   -->  \x80\xfdR(submode-rhs:folds:for:)\x80\xfdR(submode-leave:folds)
\x80\xfdR(submode-rhs:windows:for:T)  -->  T
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â T  -->  \x80\xfdR(submode-rhs:windows:for:T)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:L)  -->  L
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â L  -->  \x80\xfdR(submode-rhs:windows:for:L)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:K)  -->  K
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â K  -->  \x80\xfdR(submode-rhs:windows:for:K)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:J)  -->  J
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â J  -->  \x80\xfdR(submode-rhs:windows:for:J)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:H)  -->  H
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â H  -->  \x80\xfdR(submode-rhs:windows:for:H)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:x)  -->  x
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â x  -->  \x80\xfdR(submode-rhs:windows:for:x)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:R)  -->  R
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â R  -->  \x80\xfdR(submode-rhs:windows:for:R)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:r)  -->  r
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â r  -->  \x80\xfdR(submode-rhs:windows:for:r)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:o)  -->  o
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â o  -->  \x80\xfdR(submode-rhs:windows:for:o)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:c)  -->  c
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â c  -->  \x80\xfdR(submode-rhs:windows:for:c)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:=)  -->  =
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â =  -->  \x80\xfdR(submode-rhs:windows:for:=)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:_)  -->  10-
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â _  -->  \x80\xfdR(submode-rhs:windows:for:_)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:+)  -->  10+
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â +  -->  \x80\xfdR(submode-rhs:windows:for:+)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:[)  -->  -
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â [  -->  \x80\xfdR(submode-rhs:windows:for:[)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:])  -->  +
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â ]  -->  \x80\xfdR(submode-rhs:windows:for:])\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:<)  -->  10<
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â <  -->  \x80\xfdR(submode-rhs:windows:for:<)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:>)  -->  10>
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â >  -->  \x80\xfdR(submode-rhs:windows:for:>)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:,)  -->  <
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â ,  -->  \x80\xfdR(submode-rhs:windows:for:,)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:.)  -->  >
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â .  -->  \x80\xfdR(submode-rhs:windows:for:.)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:s)  -->  s
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â s  -->  \x80\xfdR(submode-rhs:windows:for:s)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:v)  -->  v
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â v  -->  \x80\xfdR(submode-rhs:windows:for:v)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:6)  -->  6w
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â 6  -->  \x80\xfdR(submode-rhs:windows:for:6)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:5)  -->  5w
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â 5  -->  \x80\xfdR(submode-rhs:windows:for:5)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:4)  -->  4w
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â 4  -->  \x80\xfdR(submode-rhs:windows:for:4)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:3)  -->  3w
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â 3  -->  \x80\xfdR(submode-rhs:windows:for:3)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:2)  -->  2w
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â 2  -->  \x80\xfdR(submode-rhs:windows:for:2)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:1)  -->  1w
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â 1  -->  \x80\xfdR(submode-rhs:windows:for:1)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:p)  -->  p
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â p  -->  \x80\xfdR(submode-rhs:windows:for:p)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:b)  -->  b
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â b  -->  \x80\xfdR(submode-rhs:windows:for:b)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:t)  -->  t
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â t  -->  \x80\xfdR(submode-rhs:windows:for:t)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:l)  -->  l
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â l  -->  \x80\xfdR(submode-rhs:windows:for:l)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:k)  -->  k
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â k  -->  \x80\xfdR(submode-rhs:windows:for:k)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:j)  -->  j
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â j  -->  \x80\xfdR(submode-rhs:windows:for:j)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-rhs:windows:for:h)  -->  h
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â h  -->  \x80\xfdR(submode-rhs:windows:for:h)\x80\xfdR(submode-enter:windows)
\x80\xfdR(submode-leave:windows)  -->  @=\x80\xfdQ146_on_leaving_submode('windows')
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â   -->  \x80\xfdR(submode-leave:windows)
\x80\xfdR(submode-before-action:windows)  -->  \x80\xfdQ146_on_executing_action('windows')
\x80\xfdR(submode-enter:windows)  -->  \x80\xfdR(submode-before-action:windows)\x80\xfdR(submode-prefix:windows)Â Â Â Â Â 
\x80\xfdR(submode-before-entering:windows)  -->  \x80\xfdQ146_on_entering_submode('windows')
\x80\xfdR(submode-before-entering:windows:with:g)  -->  jk
\x80\xfdR(submode-rhs:windows:for:q)  -->  
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â q  -->  \x80\xfdR(submode-rhs:windows:for:q)\x80\xfdR(submode-leave:windows)
\x80\xfdR(submode-rhs:windows:for:)  -->  
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â   -->  \x80\xfdR(submode-rhs:windows:for:)\x80\xfdR(submode-leave:windows)
\x80\xfdR(submode-rhs:windows:for:)  -->  
\x80\xfdR(submode-prefix:windows)Â Â Â Â Â   -->  \x80\xfdR(submode-rhs:windows:for:)\x80\xfdR(submode-leave:windows)
\x80\xfdR(submode-rhs:undo/redo:for:+)  -->  g+
\x80\xfdR(submode-prefix:undo/redo)Â Â Â Â Â +  -->  \x80\xfdR(submode-rhs:undo/redo:for:+)\x80\xfdR(submode-enter:undo/redo)
\x80\xfdR(submode-rhs:undo/redo:for:-)  -->  g-
\x80\xfdR(submode-prefix:undo/redo)Â Â Â Â Â -  -->  \x80\xfdR(submode-rhs:undo/redo:for:-)\x80\xfdR(submode-enter:undo/redo)
\x80\xfdR(submode-before-entering:undo/redo:with:g+)  -->  g+
\x80\xfdR(submode-leave:undo/redo)  -->  @=\x80\xfdQ146_on_leaving_submode('undo/redo')
\x80\xfdR(submode-prefix:undo/redo)Â Â Â Â Â   -->  \x80\xfdR(submode-leave:undo/redo)
\x80\xfdR(submode-before-action:undo/redo)  -->  \x80\xfdQ146_on_executing_action('undo/redo')
\x80\xfdR(submode-enter:undo/redo)  -->  \x80\xfdR(submode-before-action:undo/redo)\x80\xfdR(submode-prefix:undo/redo)Â Â Â Â Â 
\x80\xfdR(submode-before-entering:undo/redo)  -->  \x80\xfdQ146_on_entering_submode('undo/redo')
\x80\xfdR(submode-before-entering:undo/redo:with:g-)  -->  g-
\x80\xfdR(submode-rhs:undo/redo:for:q)  -->  
\x80\xfdR(submode-prefix:undo/redo)Â Â Â Â Â q  -->  \x80\xfdR(submode-rhs:undo/redo:for:q)\x80\xfdR(submode-leave:undo/redo)
\x80\xfdR(submode-rhs:undo/redo:for:)  -->  
\x80\xfdR(submode-prefix:undo/redo)Â Â Â Â Â   -->  \x80\xfdR(submode-rhs:undo/redo:for:)\x80\xfdR(submode-leave:undo/redo)
\x80\xfdR(submode-rhs:undo/redo:for:)  -->  
\x80\xfdR(submode-prefix:undo/redo)Â Â Â Â Â   -->  \x80\xfdR(submode-rhs:undo/redo:for:)\x80\xfdR(submode-leave:undo/redo)
\x80\xfdRNetrwBrowseXVis  -->  :call netrw#BrowseXVis()
\x80\xfdRNetrwBrowseX  -->  :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())
\x80K9  -->  \x80\xfdR(visualstar-*)
\x80\xfdQ124_(extra_commands)  -->  \x80\xfdQ124_extra_commands()
\x80\xfdQ124_(count)  -->  \x80\xfdQ124_count()
\x80\xfdR(visualstar-g#)  -->  :call \x80\xfdQ124_search('?', 1)\x80\xfdQ124_(count)\x80\xfdQ124_(extra_commands)
\x80\xfdR(visualstar-g*)  -->  :call \x80\xfdQ124_search('/', 1)\x80\xfdQ124_(count)\x80\xfdQ124_(extra_commands)
\x80\xfdR(visualstar-#)  -->  :call \x80\xfdQ124_search('?', 0)\x80\xfdQ124_(count)\x80\xfdQ124_(extra_commands)
\x80\xfdR(visualstar-*)  -->  :call \x80\xfdQ124_search('/', 0)\x80\xfdQ124_(count)\x80\xfdQ124_(extra_commands)
\x80\xfdR(visualstar-g#)  -->  g#
\x80\xfdR(visualstar-g*)  -->  g*
\x80\xfdR(visualstar-#)  -->  #
\x80\xfdR(visualstar-*)  -->  *
\x80\xfdRVimpleMRU  -->  :echo vimple#undolist#print_mru() . "\n":buffer 
\x80\xfdRvimple_filter  -->  :Filter
\x80\xfdRvimple_spell_suggest  -->  :call SpellSuggest(expand('<cword>'))
\x80\xfdRvimple_ident_search_forward  -->  :call IdentSearch(1)
\x80\xfdRvimple_ident_search  -->  :call IdentSearch(0)
\x80\xfdRvimple_tag_search  -->  :call TagSearch()
\x80\xfdRvfm_argument  -->  :call feedkeys(":VFMArgument \")
\x80\xfdRvfm_browse_bufs  -->  :VFMBufs
\x80\xfdRvfm_browse_args  -->  :VFMArglist
\x80\xfdRvfm_browse_paths  -->  :call VimFindsMeOpts('&path')
\x80\xfdRvfm_browse_dirs  -->  :VFMCD
\x80\xfdRvfm_browse_files  -->  :VFMEdit
\x80\xfdRunimpaired_line_xml_decode  -->  :call \x80\xfdQ110_Transform("xml_decode",v:count1)
\x80\xfdRunimpaired_xml_decode  -->  :call \x80\xfdQ110_Transform("xml_decode",visualmode())
\x80\xfdRunimpaired_xml_decode  -->  :call \x80\xfdQ110_TransformSetup("xml_decode")g@
\x80\xfdRunimpaired_line_xml_encode  -->  :call \x80\xfdQ110_Transform("xml_encode",v:count1)
\x80\xfdRunimpaired_xml_encode  -->  :call \x80\xfdQ110_Transform("xml_encode",visualmode())
\x80\xfdRunimpaired_xml_encode  -->  :call \x80\xfdQ110_TransformSetup("xml_encode")g@
\x80\xfdRunimpaired_line_url_decode  -->  :call \x80\xfdQ110_Transform("url_decode",v:count1)
\x80\xfdRunimpaired_url_decode  -->  :call \x80\xfdQ110_Transform("url_decode",visualmode())
\x80\xfdRunimpaired_url_decode  -->  :call \x80\xfdQ110_TransformSetup("url_decode")g@
\x80\xfdRunimpaired_line_url_encode  -->  :call \x80\xfdQ110_Transform("url_encode",v:count1)
\x80\xfdRunimpaired_url_encode  -->  :call \x80\xfdQ110_Transform("url_encode",visualmode())
\x80\xfdRunimpaired_url_encode  -->  :call \x80\xfdQ110_TransformSetup("url_encode")g@
\x80\xfdRunimpaired_line_string_decode  -->  :call \x80\xfdQ110_Transform("string_decode",v:count1)
\x80\xfdRunimpaired_string_decode  -->  :call \x80\xfdQ110_Transform("string_decode",visualmode())
\x80\xfdRunimpaired_string_decode  -->  :call \x80\xfdQ110_TransformSetup("string_decode")g@
\x80\xfdRunimpaired_line_string_encode  -->  :call \x80\xfdQ110_Transform("string_encode",v:count1)
\x80\xfdRunimpaired_string_encode  -->  :call \x80\xfdQ110_Transform("string_encode",visualmode())
\x80\xfdRunimpaired_string_encode  -->  :call \x80\xfdQ110_TransformSetup("string_encode")g@
\x80\xfdRunimpairedPutBelow  -->  :call \x80\xfdQ110_putline(']p', 'Below')
\x80\xfdRunimpairedPutAbove  -->  :call \x80\xfdQ110_putline('[p', 'Above')
\x80\xfdRunimpairedPaste  -->  :call \x80\xfdQ110_setup_paste()
\x80\xfdRunimpairedMoveSelectionDown  -->  :call \x80\xfdQ110_MoveSelectionDown(v:count1)
\x80\xfdRunimpairedMoveSelectionUp  -->  :call \x80\xfdQ110_MoveSelectionUp(v:count1)
\x80\xfdRunimpairedMoveDown  -->  :call \x80\xfdQ110_Move('+',v:count1,'Down')
\x80\xfdRunimpairedMoveUp  -->  :call \x80\xfdQ110_Move('--',v:count1,'Up')
\x80\xfdRunimpairedBlankDown  -->  :call \x80\xfdQ110_BlankDown(v:count1)
\x80\xfdRunimpairedBlankUp  -->  :call \x80\xfdQ110_BlankUp(v:count1)
\x80\xfdRunimpairedContextNext  -->  :call \x80\xfdQ110_ContextMotion(0)
\x80\xfdRunimpairedContextPrevious  -->  :call \x80\xfdQ110_ContextMotion(1)
\x80\xfdRunimpairedContextNext  -->  :call \x80\xfdQ110_Context(0)
\x80\xfdRunimpairedContextPrevious  -->  :call \x80\xfdQ110_Context(1)
\x80\xfdRunimpairedOPrevious  -->  \x80\xfdRunimpairedDirectoryPrevious:echohl WarningMSG|echo "[o is deprecated. Use [f"|echohl NONE
\x80\xfdRunimpairedONext  -->  \x80\xfdRunimpairedDirectoryNext:echohl WarningMSG|echo "]o is deprecated. Use ]f"|echohl NONE
\x80\xfdRunimpairedDirectoryPrevious  -->  :edit =fnamemodify(\x80\xfdQ110_fnameescape(\x80\xfdQ110_FileByOffset(-v:count1)), ':.')
\x80\xfdRunimpairedDirectoryNext  -->  :edit =fnamemodify(\x80\xfdQ110_fnameescape(\x80\xfdQ110_FileByOffset(v:count1)), ':.')
\x80\xfdRunimpairedTLast  -->  :exe "".(v:count ? v:count : "")."tlast"
\x80\xfdRunimpairedTFirst  -->  :exe "".(v:count ? v:count : "")."tfirst"
\x80\xfdRunimpairedTNext  -->  :exe "".(v:count ? v:count : "")."tnext"
\x80\xfdRunimpairedTPrevious  -->  :exe "".(v:count ? v:count : "")."tprevious"
\x80\xfdRunimpairedQNFile  -->  :exe "".(v:count ? v:count : "")."cnfile"zv
\x80\xfdRunimpairedQPFile  -->  :exe "".(v:count ? v:count : "")."cpfile"zv
\x80\xfdRunimpairedQLast  -->  :exe "".(v:count ? v:count : "")."clast"zv
\x80\xfdRunimpairedQFirst  -->  :exe "".(v:count ? v:count : "")."cfirst"zv
\x80\xfdRunimpairedQNext  -->  :exe "".(v:count ? v:count : "")."cnext"zv
\x80\xfdRunimpairedQPrevious  -->  :exe "".(v:count ? v:count : "")."cprevious"zv
\x80\xfdRunimpairedLNFile  -->  :exe "".(v:count ? v:count : "")."lnfile"zv
\x80\xfdRunimpairedLPFile  -->  :exe "".(v:count ? v:count : "")."lpfile"zv
\x80\xfdRunimpairedLLast  -->  :exe "".(v:count ? v:count : "")."llast"zv
\x80\xfdRunimpairedLFirst  -->  :exe "".(v:count ? v:count : "")."lfirst"zv
\x80\xfdRunimpairedLNext  -->  :exe "".(v:count ? v:count : "")."lnext"zv
\x80\xfdRunimpairedLPrevious  -->  :exe "".(v:count ? v:count : "")."lprevious"zv
\x80\xfdRunimpairedBLast  -->  :exe "".(v:count ? v:count : "")."blast"
\x80\xfdRunimpairedBFirst  -->  :exe "".(v:count ? v:count : "")."bfirst"
\x80\xfdRunimpairedBNext  -->  :exe "".(v:count ? v:count : "")."bnext"
\x80\xfdRunimpairedBPrevious  -->  :exe "".(v:count ? v:count : "")."bprevious"
\x80\xfdRunimpairedALast  -->  :exe "".(v:count ? v:count : "")."last"
\x80\xfdRunimpairedAFirst  -->  :exe "".(v:count ? v:count : "")."first"
\x80\xfdRunimpairedANext  -->  :exe "".(v:count ? v:count : "")."next"
\x80\xfdRunimpairedAPrevious  -->  :exe "".(v:count ? v:count : "")."previous"
\x80kD  -->  c
\x80kb  -->  c
\x80k3  -->  :call UltiSnips#ListSnippets()
\x80\xfdRVgSurround  -->  :call \x80\xfdQ95_opfunc(visualmode(),visualmode() ==# 'V' ? 0 : 1)
\x80\xfdRVSurround  -->  :call \x80\xfdQ95_opfunc(visualmode(),visualmode() ==# 'V' ? 1 : 0)
\x80\xfdRYSurround  -->  :set opfunc=\x80\xfdQ95_opfunc2g@
\x80\xfdRYsurround  -->  :set opfunc=\x80\xfdQ95_opfuncg@
\x80\xfdRYSsurround  -->  :call \x80\xfdQ95_opfunc2(v:count1)
\x80\xfdRYssurround  -->  :call \x80\xfdQ95_opfunc(v:count1)
\x80\xfdRCSurround  -->  :call \x80\xfdQ95_changesurround(1)
\x80\xfdRCsurround  -->  :call \x80\xfdQ95_changesurround()
\x80\xfdRDsurround  -->  :call \x80\xfdQ95_dosurround(\x80\xfdQ95_inputtarget())
\x80\xfdRSurroundRepeat  -->  .
\x80\xfdRSneakPrevious  -->  \x80\xfdRSneak_,
\x80\xfdRSneakNext  -->  \x80\xfdRSneak_;
\x80\xfdRSneakPrevious  -->  \x80\xfdRSneak_,
\x80\xfdRSneakNext  -->  \x80\xfdRSneak_;
\x80\xfdRSneakPrevious  -->  \x80\xfdRSneak_,
\x80\xfdRSneakNext  -->  \x80\xfdRSneak_;
\x80\xfdR(SneakStreakBackward)  -->  \x80\xfdRSneakLabel_S
\x80\xfdR(SneakStreak)  -->  \x80\xfdRSneakLabel_s
\x80\xfdR(SneakStreakBackward)  -->  \x80\xfdRSneakLabel_S
\x80\xfdR(SneakStreak)  -->  \x80\xfdRSneakLabel_s
\x80\xfdR(SneakStreakBackward)  -->  \x80\xfdRSneakLabel_S
\x80\xfdR(SneakStreak)  -->  \x80\xfdRSneakLabel_s
\x80\xfdRVSneakPrevious  -->  \x80\xfdRSneak_,
\x80\xfdRVSneakNext  -->  \x80\xfdRSneak_;
\x80\xfdRVSneakBackward  -->  \x80\xfdRSneak_S
\x80\xfdRVSneakForward  -->  \x80\xfdRSneak_s
\x80\xfdRSneakBackward  -->  \x80\xfdRSneak_S
\x80\xfdRSneakForward  -->  \x80\xfdRSneak_s
\x80\xfdRSneakLabel_S  -->  :call sneak#wrap(v:operator, 2, 1, 2, 2)
\x80\xfdRSneakLabel_s  -->  :call sneak#wrap(v:operator, 2, 0, 2, 2)
\x80\xfdRSneakLabel_S  -->  :call sneak#wrap(visualmode(), 2, 1, 2, 2)
\x80\xfdRSneakLabel_s  -->  :call sneak#wrap(visualmode(), 2, 0, 2, 2)
\x80\xfdRSneakLabel_S  -->  :call sneak#wrap('', 2, 1, 2, 2)
\x80\xfdRSneakLabel_s  -->  :call sneak#wrap('', 2, 0, 2, 2)
\x80\xfdRSneak_T  -->  :call sneak#wrap(v:operator, 1, 1, 0, 0)
\x80\xfdRSneak_t  -->  :call sneak#wrap(v:operator, 1, 0, 0, 0)
\x80\xfdRSneak_T  -->  :call sneak#wrap(visualmode(), 1, 1, 0, 0)
\x80\xfdRSneak_t  -->  :call sneak#wrap(visualmode(), 1, 0, 0, 0)
\x80\xfdRSneak_T  -->  :call sneak#wrap('', 1, 1, 0, 0)
\x80\xfdRSneak_t  -->  :call sneak#wrap('', 1, 0, 0, 0)
\x80\xfdRSneak_F  -->  :call sneak#wrap(v:operator, 1, 1, 1, 0)
\x80\xfdRSneak_f  -->  :call sneak#wrap(v:operator, 1, 0, 1, 0)
\x80\xfdRSneak_F  -->  :call sneak#wrap(visualmode(), 1, 1, 1, 0)
\x80\xfdRSneak_f  -->  :call sneak#wrap(visualmode(), 1, 0, 1, 0)
\x80\xfdRSneak_F  -->  :call sneak#wrap('', 1, 1, 1, 0)
\x80\xfdRSneak_f  -->  :call sneak#wrap('', 1, 0, 1, 0)
\x80\xfdRSneak_,  -->  :call sneak#rpt(v:operator, 1)
\x80\xfdRSneak_;  -->  :call sneak#rpt(v:operator, 0)
\x80\xfdRSneak_,  -->  :call sneak#rpt(visualmode(), 1)
\x80\xfdRSneak_;  -->  :call sneak#rpt(visualmode(), 0)
\x80\xfdRSneak_,  -->  :call sneak#rpt('', 1)
\x80\xfdRSneak_;  -->  :call sneak#rpt('', 0)
\x80\xfdRSneakRepeat  -->  :call sneak#wrap(v:operator, sneak#util#getc(), sneak#util#getc(), sneak#util#getc(), sneak#util#getc())
\x80\xfdRSneak_S  -->  :call sneak#wrap(v:operator, 2, 1, 2, 1)
\x80\xfdRSneak_s  -->  :call sneak#wrap(v:operator, 2, 0, 2, 1)
\x80\xfdRSneak_S  -->  :call sneak#wrap(visualmode(), 2, 1, 2, 1)
\x80\xfdRSneak_s  -->  :call sneak#wrap(visualmode(), 2, 0, 2, 1)
\x80\xfdRSneak_S  -->  :call sneak#wrap('', 2, 1, 2, 1)
\x80\xfdRSneak_s  -->  :call sneak#wrap('', 2, 0, 2, 1)
\x80\xfdRSidewaysArgumentTextobjI  -->  :call sideways#textobj#Argument('i')
\x80\xfdRSidewaysArgumentTextobjI  -->  :call sideways#textobj#Argument('i')
\x80\xfdRSidewaysArgumentTextobjA  -->  :call sideways#textobj#Argument('a')
\x80\xfdRSidewaysArgumentTextobjA  -->  :call sideways#textobj#Argument('a')
\x80\xfdRSidewaysRight  -->  :SidewaysRight
\x80\xfdRSidewaysLeft  -->  :SidewaysLeft
\x80\xfdR(sexp_capture_next_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'v', 1, 1)
\x80\xfdR(sexp_capture_next_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'n', 1, 1) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_capture_next_element)", b:sexp_count)
\x80\xfdR(sexp_capture_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'v', 0, 1)
\x80\xfdR(sexp_capture_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'n', 0, 1) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_capture_prev_element)", b:sexp_count)
\x80\xfdR(sexp_emit_tail_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'v', 1, 0)
\x80\xfdR(sexp_emit_tail_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'n', 1, 0) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_emit_tail_element)", b:sexp_count)
\x80\xfdR(sexp_emit_head_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'v', 0, 0)
\x80\xfdR(sexp_emit_head_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'n', 0, 0) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_emit_head_element)", b:sexp_count)
\x80\xfdR(sexp_swap_element_forward)  -->  :call sexp#docount(v:prevcount, 'sexp#swap_element', 'v', 1, 0)
\x80\xfdR(sexp_swap_element_forward)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#swap_element', 'n', 1, 0) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_swap_element_forward)", b:sexp_count)
\x80\xfdR(sexp_swap_element_backward)  -->  :call sexp#docount(v:prevcount, 'sexp#swap_element', 'v', 0, 0)
\x80\xfdR(sexp_swap_element_backward)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#swap_element', 'n', 0, 0) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_swap_element_backward)", b:sexp_count)
\x80\xfdR(sexp_swap_list_forward)  -->  :call sexp#docount(v:prevcount, 'sexp#swap_element', 'v', 1, 1)
\x80\xfdR(sexp_swap_list_forward)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#swap_element', 'n', 1, 1) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_swap_list_forward)", b:sexp_count)
\x80\xfdR(sexp_swap_list_backward)  -->  :call sexp#docount(v:prevcount, 'sexp#swap_element', 'v', 0, 1)
\x80\xfdR(sexp_swap_list_backward)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#swap_element', 'n', 0, 1) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_swap_list_backward)", b:sexp_count)
\x80\xfdR(sexp_splice_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#splice_list(b:sexp_count) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_splice_list)", b:sexp_count)
\x80\xfdR(sexp_raise_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#raise', 'v', '')
\x80\xfdR(sexp_raise_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#raise', 'n', 'sexp#select_current_element', 'n', 1) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_raise_element)", b:sexp_count)
\x80\xfdR(sexp_raise_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#raise', 'v', '')
\x80\xfdR(sexp_raise_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#raise', 'n', 'sexp#select_current_list', 'n', 0, 0) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_raise_list)", b:sexp_count)
\x80\xfdR(sexp_insert_at_list_tail)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#insert_at_list_terminal(1) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_insert_at_list_tail)", b:sexp_count)
\x80\xfdR(sexp_insert_at_list_head)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#insert_at_list_terminal(0) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_insert_at_list_head)", b:sexp_count)
\x80\xfdR(sexp_curly_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '{', '}', 1, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_curly_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '{', '}', 1, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_curly_tail_wrap_element)", b:sexp_count)
\x80\xfdR(sexp_curly_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '{', '}', 0, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_curly_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '{', '}', 0, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_curly_head_wrap_element)", b:sexp_count)
\x80\xfdR(sexp_square_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '[', ']', 1, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_square_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '[', ']', 1, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_square_tail_wrap_element)", b:sexp_count)
\x80\xfdR(sexp_square_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '[', ']', 0, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_square_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '[', ']', 0, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_square_head_wrap_element)", b:sexp_count)
\x80\xfdR(sexp_round_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '(', ')', 1, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_round_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '(', ')', 1, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_round_tail_wrap_element)", b:sexp_count)
\x80\xfdR(sexp_round_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '(', ')', 0, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_round_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '(', ')', 0, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_round_head_wrap_element)", b:sexp_count)
\x80\xfdR(sexp_curly_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '{', '}', 1, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_curly_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '{', '}', 1, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_curly_tail_wrap_list)", b:sexp_count)
\x80\xfdR(sexp_curly_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '{', '}', 0, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_curly_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '{', '}', 0, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_curly_head_wrap_list)", b:sexp_count)
\x80\xfdR(sexp_square_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '[', ']', 1, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_square_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '[', ']', 1, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_square_tail_wrap_list)", b:sexp_count)
\x80\xfdR(sexp_square_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '[', ']', 0, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_square_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '[', ']', 0, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_square_head_wrap_list)", b:sexp_count)
\x80\xfdR(sexp_round_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '(', ')', 1, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_round_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '(', ')', 1, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_round_tail_wrap_list)", b:sexp_count)
\x80\xfdR(sexp_round_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '(', ')', 0, g:sexp_insert_after_wrap)
\x80\xfdR(sexp_round_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '(', ')', 0, g:sexp_insert_after_wrap) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_round_head_wrap_list)", b:sexp_count)
\x80\xfdR(sexp_indent_top)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#indent(1, b:sexp_count) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_indent_top)", b:sexp_count)
\x80\xfdR(sexp_indent)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#indent(0, b:sexp_count) | call \x80\xfdQ90_repeat_set("\\x80\xfdR(sexp_indent)", b:sexp_count)
\x80\xfdR(sexp_select_next_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'o', 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_select_next_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_select_next_element)", b:sexp_count) | endif
\x80\xfdR(sexp_select_next_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'v', 1)
\x80\xfdR(sexp_select_next_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'n', 1)
\x80\xfdR(sexp_select_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'o', 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_select_prev_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_select_prev_element)", b:sexp_count) | endif
\x80\xfdR(sexp_select_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'v', 0)
\x80\xfdR(sexp_select_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'n', 0)
\x80\xfdR(sexp_move_to_next_top_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#move_to_adjacent_element('o', b:sexp_count, 1, 0, 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_next_top_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_next_top_element)", b:sexp_count) | endif
\x80\xfdR(sexp_move_to_next_top_element)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 1, 0, 1)
\x80\xfdR(sexp_move_to_next_top_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#move_to_adjacent_element('n', b:sexp_count, 1, 0, 1)
\x80\xfdR(sexp_move_to_prev_top_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#move_to_adjacent_element('o', b:sexp_count, 0, 0, 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_prev_top_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_prev_top_element)", b:sexp_count) | endif
\x80\xfdR(sexp_move_to_prev_top_element)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 0, 0, 1)
\x80\xfdR(sexp_move_to_prev_top_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#move_to_adjacent_element('n', b:sexp_count, 0, 0, 1)
\x80\xfdR(sexp_move_to_next_element_tail)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('o', b:sexp_count, 1, 1, 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_next_element_tail)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_next_element_tail)", b:sexp_count) | endif
\x80\xfdR(sexp_move_to_next_element_tail)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 1, 1, 0)
\x80\xfdR(sexp_move_to_next_element_tail)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('n', b:sexp_count, 1, 1, 0)
\x80\xfdR(sexp_move_to_prev_element_tail)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('o', b:sexp_count, 0, 1, 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_prev_element_tail)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_prev_element_tail)", b:sexp_count) | endif
\x80\xfdR(sexp_move_to_prev_element_tail)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 0, 1, 0)
\x80\xfdR(sexp_move_to_prev_element_tail)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('n', b:sexp_count, 0, 1, 0)
\x80\xfdR(sexp_move_to_next_element_head)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('o', b:sexp_count, 1, 0, 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_next_element_head)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_next_element_head)", b:sexp_count) | endif
\x80\xfdR(sexp_move_to_next_element_head)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 1, 0, 0)
\x80\xfdR(sexp_move_to_next_element_head)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('n', b:sexp_count, 1, 0, 0)
\x80\xfdR(sexp_move_to_prev_element_head)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('o', b:sexp_count, 0, 0, 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_prev_element_head)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_prev_element_head)", b:sexp_count) | endif
\x80\xfdR(sexp_move_to_prev_element_head)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 0, 0, 0)
\x80\xfdR(sexp_move_to_prev_element_head)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('n', b:sexp_count, 0, 0, 0)
\x80\xfdR(sexp_move_to_next_bracket)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#move_to_nearest_bracket('o', 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_next_bracket)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_next_bracket)", b:sexp_count) | endif
\x80\xfdR(sexp_move_to_next_bracket)  -->  :call sexp#docount(v:prevcount, 'sexp#move_to_nearest_bracket', 'v', 1)
\x80\xfdR(sexp_move_to_next_bracket)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#move_to_nearest_bracket', 'n', 1)
\x80\xfdR(sexp_move_to_prev_bracket)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#move_to_nearest_bracket('o', 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_prev_bracket)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_move_to_prev_bracket)", b:sexp_count) | endif
\x80\xfdR(sexp_move_to_prev_bracket)  -->  :call sexp#docount(v:prevcount, 'sexp#move_to_nearest_bracket', 'v', 0)
\x80\xfdR(sexp_move_to_prev_bracket)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#move_to_nearest_bracket', 'n', 0)
\x80\xfdR(sexp_inner_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_element('o', 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_inner_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_inner_element)", b:sexp_count) | endif
\x80\xfdR(sexp_inner_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_element('v', 1)
\x80\xfdR(sexp_outer_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_element('o', 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_outer_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_outer_element)", b:sexp_count) | endif
\x80\xfdR(sexp_outer_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_element('v', 0)
\x80\xfdR(sexp_inner_string)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_string('o', 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_inner_string)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_inner_string)", b:sexp_count) | endif
\x80\xfdR(sexp_inner_string)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_string('v', 1)
\x80\xfdR(sexp_outer_string)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_string('o', 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_outer_string)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_outer_string)", b:sexp_count) | endif
\x80\xfdR(sexp_outer_string)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_string('v', 0)
\x80\xfdR(sexp_inner_top_list)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_top_list('o', 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_inner_top_list)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_inner_top_list)", b:sexp_count) | endif
\x80\xfdR(sexp_inner_top_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_top_list('v', 1)
\x80\xfdR(sexp_outer_top_list)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_top_list('o', 0) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_outer_top_list)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_outer_top_list)", b:sexp_count) | endif
\x80\xfdR(sexp_outer_top_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_top_list('v', 0)
\x80\xfdR(sexp_inner_list)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#docount(b:sexp_count, 'sexp#select_current_list', 'o', 1, 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_inner_list)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_inner_list)", b:sexp_count) | endif
\x80\xfdR(sexp_inner_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_current_list', 'v', 1, 1)
\x80\xfdR(sexp_outer_list)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#docount(b:sexp_count, 'sexp#select_current_list', 'o', 0, 1) | if v:operator ==? "c" |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_outer_list)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call \x80\xfdQ90_repeat_set(v:operator . "\\x80\xfdR(sexp_outer_list)", b:sexp_count) | endif
\x80\xfdR(sexp_outer_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_current_list', 'v', 0, 1)
\x80\xfdR(RepeatRedo)  -->  :call repeat#wrap("\<C-R>",v:count)
\x80\xfdR(RepeatUndoLine)  -->  :call repeat#wrap('U',v:count)
\x80\xfdR(RepeatUndo)  -->  :call repeat#wrap('u',v:count)
\x80\xfdR(RepeatDot)  -->  :exe repeat#run(v:count)
\x80\xfdR(GrepperOperator)  -->  :call grepper#operator(visualmode())
\x80\xfdR(GrepperOperator)  -->  :set opfunc=grepper#operatorg@
\x80\xfdQ63_:  -->  :=v:count ? v:count : ''
\x80\xfdR(ExchangeLine)  -->  ':set operatorfunc=\x80\xfdQ62_exchange_set'.(v:count1 == 1 ? '' : v:count1).'g@_'
\x80\xfdR(ExchangeClear)  -->  :call \x80\xfdQ62_exchange_clear()
\x80\xfdR(Exchange)  -->  :call \x80\xfdQ62_exchange_set(visualmode(), 1)
\x80\xfdR(Exchange)  -->  ':set operatorfunc=\x80\xfdQ62_exchange_set'.(v:count1 == 1 ? '' : v:count1).'g@'
\x80\xfdR(OuterDENTURE)  -->  :call dentures#select(line('.'), 1, 1, 'operator')
\x80\xfdR(OuterDenture)  -->  :call dentures#select(line('.'), 1, 0, 'operator')
\x80\xfdR(InnerDENTURE)  -->  :call dentures#select(line('.'), 0, 1, 'operator')
\x80\xfdR(InnerDenture)  -->  :call dentures#select(line('.'), 0, 0, 'operator')
\x80\xfdR(OuterDENTURE)  -->  dentures#select(line('.'), 1, 1, mode())
\x80\xfdR(OuterDenture)  -->  dentures#select(line('.'), 1, 0, mode())
\x80\xfdR(InnerDENTURE)  -->  dentures#select(line('.'), 0, 1, mode())
\x80\xfdR(InnerDenture)  -->  dentures#select(line('.'), 0, 0, mode())
\x80\xffX  -->  :CtrlP
\x80\xfdRCommentaryUndo  -->  \x80\xfdRCommentary\x80\xfdRCommentary
\x80\xfdRChangeCommentary  -->  c:call \x80\xfdQ56_textobject(1)
\x80\xfdRCommentary  -->  :call \x80\xfdQ56_textobject(0)
\x80\xfdRCommentaryLine  -->  :set opfunc=\x80\xfdQ56_go|exe 'norm! 'v:count1.'g@_'
\x80\xfdRCommentary  -->  :set opfunc=\x80\xfdQ56_gog@
\x80\xfdRCommentary  -->  :call \x80\xfdQ56_go(line("'<"),line("'>"))
\x80\xfdRCoerce  -->  :call \x80\xfdQ55_coerce(nr2char(getchar()))
\x80\xfc\x80k8  -->  :call \x80\xfdQ50_NextColor(0, 1)
\x80\xfd  -->  :call \x80\xfdQ50_NextColor(-1, 1)
\x80k8  -->  :call \x80\xfdQ50_NextColor(1, 1)
\x80\xfdRremove_vimple_ident_search_forward  -->  \x80\xfdRvimple_ident_search_forward
\x80\xfdRremove_vimple_ident_search  -->  \x80\xfdRvimple_ident_search
\x80\xfdRremove_vimple_spell_suggest  -->  \x80\xfdRvimple_spell_suggest
\x80\xfdRremove_vimple_tag_search  -->  \x80\xfdRvimple_tag_search
\x80k5  -->  :GundoToggle
\x80\xfc   -->  \x80\xffX
\x80ku  -->  DVB_Drag('up')
\x80kd  -->  DVB_Drag('down')
\x80kr  -->  DVB_Drag('right')
\x80kl  -->  DVB_Drag('left')
\x80\xfd/  -->  \x80\xfd,:silent RunCommand
\x80k2  -->  y:exe getreg('"')
\x80k2  -->  :call RunCommand(0)
\x80k9  -->  :Neomake!
\x80F2  -->  :!ctags -R --fields=+iaS --extra=+qf .
\x80k;  -->  :%s/\s\+$//:nohlsearch
\x80\xfd2  -->  \x80\xfd,:silent call helpers#plumb_this()
\x80\xfd.  -->  \x80\xfd."*ygv
  -->  
S  -->  \x80\xfdRISurround
s  -->  \x80\xfdRIsurround
	  -->  =UltiSnips#ExpandSnippet()
  -->  \x80\xfdRIsurround
  -->  complete#trigger('completers#datetime')
  -->  complete#trigger('completers#abbrevs')
-  -->  _
_  -->  -
(gdb) 
vshcmd: > pipe nvim-maps | show printf "%s  -->  %s\n", {0}->m_keys, {0}->m_str
€ýRvimple_completers_trigger  -->  complete#trigger('completers#trigger')
€k3  -->  =UltiSnips#ListSnippets()
€ýRISurround  -->  =€ýQ95_insert(1)
€ýRIsurround  -->  =€ýQ95_insert()
€ýR(sexp_insert_backspace)  -->  sexp#backspace_insertion()
€ýR(sexp_insert_double_quote)  -->  sexp#quote_insertion('"')
€ýR(sexp_insert_closing_curly)  -->  sexp#closing_insertion('}')
€ýR(sexp_insert_closing_square)  -->  sexp#closing_insertion(']')
€ýR(sexp_insert_closing_round)  -->  sexp#closing_insertion(')')
€ýR(sexp_insert_opening_curly)  -->  sexp#opening_insertion('{')
€ýR(sexp_insert_opening_square)  -->  sexp#opening_insertion('[')
€ýR(sexp_insert_opening_round)  -->  sexp#opening_insertion('(')
€ýRremove_vimple_completers_trigger  -->  €ýRvimple_completers_trigger
€üo  -->  o
€üO  -->  O
  -->  c
	  -->  :call UltiSnips#SaveLastVisualSelection()gvs
	  -->  :call UltiSnips#ExpandSnippet()
  -->  :nohlsearch:diffupdate:syntax sync fromstart
  -->  "_c
  -->  €ýR(RepeatRedo)
 wl  -->  :call  €ýQ54_MoveWindow('l')
 wk  -->  :call  €ýQ54_MoveWindow('k')
 wj  -->  :call  €ýQ54_MoveWindow('j')
 wh  -->  :call  €ýQ54_MoveWindow('h')
 st  -->  :silent TQFSelect! 
 qd  -->  :QFilterBuf! %
 qb  -->  :QFilterBuf %
 qs  -->  :QuickfixSort
 qr  -->  :QFRemoveCurrent!
 ll  -->  €ýRvimple_filter
 mu  -->  €ýRVimpleMRU
 mb  -->  :VFMBadd
 mc  -->  €ýRvfm_browse_bufs
 mp  -->  €ýRvfm_browse_paths
 md  -->  €ýRvfm_browse_dirs
 ma  -->  €ýRvfm_browse_args
 me  -->  €ýRvfm_browse_files
 rk  -->  :SyntasticReset
 ok  -->  :SyntasticCheck
 al  -->  :SidewaysRight
 ah  -->  :SidewaysLeft
 pk  -->  :PymodeLint
 hq  -->  :Hgqseries
 hv  -->  :Hglogthis
 hg  -->  :Hglog
 hs  -->  :Hgstatus
 hc  -->  :Hgcommit
 hf  -->  :Hgpull
 hp  -->  :Hgpush
 hd  -->  :Hgvdiff
 sb  -->  :GrepBufs 
 sd  -->  :GrepHere 
 sg  -->  :Grepper -tool git 
 ss  -->  :Grepper -tool grep 
 so  -->  €ýR(GrepperOperator)
 so  -->  €ýR(GrepperOperator)
 gv  -->  :Gitv! --all
 gv  -->  :Gitv! --all
 gg  -->  :Gitv --all
 cpf  -->  :CtrlPFunky
 gs  -->  :Gstatus
 gc  -->  :Gcommit
 gf  -->  :Gpurr
 gp  -->  :Gpush
 gd  -->  :Gdiff
 gw  -->  :Gwrite
 fd  -->  :DiffOrig
 ff  -->  :Find 
 fm  -->  :Rename 
 fr  -->  :Unlink
 cpm  -->  :CtrlPMRU
 cpu  -->  :CtrlPUndo
 cpt  -->  :CtrlPTag
 cpq  -->  :CtrlPQuickfix
 cpc  -->  :CtrlPChange
 cpb  -->  :CtrlPBuffer
 mm  -->  €ýRvfm_argument
 z  -->  :
 '  -->  :
 cn  -->  :setlocal completeopt-=longest
 cl  -->  :setlocal completeopt+=longest
 nh  -->  :nohlsearch
 sh  -->  :Occur! 
 u  -->  :update
 b  -->  :ls:b 
 em  -->  :='let @'. v:register .' = '. string(getreg(v:register))€kl
#  -->  €ýR(visualstar-#)
'€ý,  -->  €ý,
'  -->  `
*  -->  €ýR(visualstar-*)
++  -->  VMATH_YankAndAnalyse()
,  -->  €ýRSneakNext
,  -->  €ýRSneakNext
,  -->  €ýRSneakNext
,  -->  €ýRSneakNext
.  -->  €ýR(RepeatDot)
;  -->  €ýRSneakPrevious
;  -->  €ýRSneakPrevious
;  -->  €ýRSneakPrevious
;  -->  €ýRSneakPrevious
<p  -->  :call €ýQ110_putline(']p', 'Below')<']
<P  -->  :call €ýQ110_putline('[p', 'Above')<']
<  -->  <gv
=p  -->  :call €ýQ110_putline(']p', 'Below')=']
=P  -->  :call €ýQ110_putline('[p', 'Above')=']
>p  -->  :call €ýQ110_putline(']p', 'Below')>']
>P  -->  :call €ýQ110_putline('[p', 'Above')>']
>  -->  >gv
D  -->  DVB_Duplicate()
F€ý2  -->  €ý,:silent Occur! 
Q  -->  :call €ýQ2_Again()
S  -->  €ýRVSurround
S  -->  €ýRSneak_S
T€ý2  -->  €ý,:silent TQFSelect! 
U  -->  €ýR(RepeatUndoLine)
U  -->  €ýRSneak_S
X  -->  €ýR(Exchange)
Y  -->  y$
Z  -->  €ýRSneak_S
[xx  -->  €ýRunimpaired_line_xml_encode
[x  -->  €ýRunimpaired_xml_encode
[x  -->  €ýRunimpaired_xml_encode
[uu  -->  €ýRunimpaired_line_url_encode
[u  -->  €ýRunimpaired_url_encode
[u  -->  €ýRunimpaired_url_encode
[yy  -->  €ýRunimpaired_line_string_encode
[y  -->  €ýRunimpaired_string_encode
[y  -->  €ýRunimpaired_string_encode
[p  -->  €ýRunimpairedPutAbove
[ov  -->  :set virtualedit+=all
[ox  -->  :set cursorline cursorcolumn
[ow  -->  :setlocal wrap=€ýQ110_statusbump()
[os  -->  :setlocal spell=€ýQ110_statusbump()
[or  -->  :setlocal relativenumber=€ýQ110_statusbump()
[on  -->  :setlocal number=€ýQ110_statusbump()
[ol  -->  :setlocal list=€ýQ110_statusbump()
[oi  -->  :set ignorecase=€ýQ110_statusbump()
[oh  -->  :set hlsearch=€ýQ110_statusbump()
[od  -->  :diffthis
[ou  -->  :setlocal cursorcolumn=€ýQ110_statusbump()
[oc  -->  :setlocal cursorline=€ýQ110_statusbump()
[ob  -->  :set background=light
[e  -->  €ýRunimpairedMoveSelectionUp
[e  -->  €ýRunimpairedMoveUp
[   -->  €ýRunimpairedBlankUp
[n  -->  €ýRunimpairedContextPrevious
[n  -->  €ýRunimpairedContextPrevious
[f  -->  €ýRunimpairedDirectoryPrevious
[T  -->  €ýRunimpairedTFirst
[t  -->  €ýRunimpairedTPrevious
[  -->  €ýRunimpairedQPFile
[Q  -->  €ýRunimpairedQFirst
[q  -->  €ýRunimpairedQPrevious
[  -->  €ýRunimpairedLPFile
[L  -->  €ýRunimpairedLFirst
[l  -->  €ýRunimpairedLPrevious
[B  -->  €ýRunimpairedBFirst
[b  -->  €ýRunimpairedBPrevious
[A  -->  €ýRunimpairedAFirst
[a  -->  €ýRunimpairedAPrevious
[ok  -->  :call €ýQ25_UseVimForMan()
]xx  -->  €ýRunimpaired_line_xml_decode
]x  -->  €ýRunimpaired_xml_decode
]x  -->  €ýRunimpaired_xml_decode
]uu  -->  €ýRunimpaired_line_url_decode
]u  -->  €ýRunimpaired_url_decode
]u  -->  €ýRunimpaired_url_decode
]yy  -->  €ýRunimpaired_line_string_decode
]y  -->  €ýRunimpaired_string_decode
]y  -->  €ýRunimpaired_string_decode
]p  -->  €ýRunimpairedPutBelow
]ov  -->  :set virtualedit-=all
]ox  -->  :set nocursorline nocursorcolumn
]ow  -->  :setlocal nowrap=€ýQ110_statusbump()
]os  -->  :setlocal nospell=€ýQ110_statusbump()
]or  -->  :setlocal norelativenumber=€ýQ110_statusbump()
]on  -->  :setlocal nonumber=€ýQ110_statusbump()
]ol  -->  :setlocal nolist=€ýQ110_statusbump()
]oi  -->  :set noignorecase=€ýQ110_statusbump()
]oh  -->  :set nohlsearch=€ýQ110_statusbump()
]od  -->  :diffoff
]ou  -->  :setlocal nocursorcolumn=€ýQ110_statusbump()
]oc  -->  :setlocal nocursorline=€ýQ110_statusbump()
]ob  -->  :set background=dark
]e  -->  €ýRunimpairedMoveSelectionDown
]e  -->  €ýRunimpairedMoveDown
]   -->  €ýRunimpairedBlankDown
]n  -->  €ýRunimpairedContextNext
]n  -->  €ýRunimpairedContextNext
]f  -->  €ýRunimpairedDirectoryNext
]T  -->  €ýRunimpairedTLast
]t  -->  €ýRunimpairedTNext
]  -->  €ýRunimpairedQNFile
]Q  -->  €ýRunimpairedQLast
]q  -->  €ýRunimpairedQNext
]  -->  €ýRunimpairedLNFile
]L  -->  €ýRunimpairedLLast
]l  -->  €ýRunimpairedLNext
]B  -->  €ýRunimpairedBLast
]b  -->  €ýRunimpairedBNext
]A  -->  €ýRunimpairedALast
]a  -->  €ýRunimpairedANext
]ok  -->  :unmap <buffer> K
`  -->  '
aI  -->  €ýR(OuterDENTURE)
aI  -->  €ýR(OuterDENTURE)
ai  -->  €ýR(OuterDenture)
ai  -->  €ýR(OuterDenture)
aa  -->  €ýRSidewaysArgumentTextobjA
aa  -->  €ýRSidewaysArgumentTextobjA
cov  -->  :set =(&virtualedit =~# "all") ? 'virtualedit-=all' : 'virtualedit+=all'
cox  -->  :set =&cursorline && &cursorcolumn ? 'nocursorline nocursorcolumn' : 'cursorline cursorcolumn'
cow  -->  :setlocal =€ýQ110_toggle("wrap")
cos  -->  :setlocal =€ýQ110_toggle("spell")
cor  -->  :setlocal =€ýQ110_toggle("relativenumber")
con  -->  :setlocal =€ýQ110_toggle("number")
col  -->  :setlocal =€ýQ110_toggle("list")
coi  -->  :set =€ýQ110_toggle("ignorecase")
coh  -->  :set =€ýQ110_toggle("hlsearch")
cod  -->  :=&diff ? 'diffoff' : 'diffthis'
cou  -->  :setlocal =€ýQ110_toggle("cursorcolumn")
coc  -->  :setlocal =€ýQ110_toggle("cursorline")
cob  -->  :set background==&background == 'dark' ? 'light' : 'dark'
cS  -->  €ýRCSurround
cs  -->  €ýRCsurround
cxx  -->  €ýR(ExchangeLine)
cxc  -->  €ýR(ExchangeClear)
cx  -->  €ýR(Exchange)
cgc  -->  €ýRChangeCommentary
cr  -->  €ýRCoerce
cw  -->  dwi
ds  -->  €ýRDsurround
f€ý2  -->  €ý,:silent Occur 
gs  -->  €ýR(submode-before-entering:scrolling:with:gs)€ýR(submode-before-entering:scrolling)€ýR(submode-enter:scrolling)
g  -->  €ýR(submode-before-entering:windows:with:g)€ýR(submode-before-entering:windows)€ýR(submode-enter:windows)
g+  -->  €ýR(submode-before-entering:undo/redo:with:g+)€ýR(submode-before-entering:undo/redo)€ýR(submode-enter:undo/redo)
g-  -->  €ýR(submode-before-entering:undo/redo:with:g-)€ýR(submode-before-entering:undo/redo)€ýR(submode-enter:undo/redo)
gx  -->  €ýRNetrwBrowseXVis
gx  -->  €ýRNetrwBrowseX
g#  -->  €ýR(visualstar-g#)
g€ü€ý,  -->  €ýR(visualstar-g*)
g€K9  -->  €ýR(visualstar-g*)
g*  -->  €ýR(visualstar-g*)
gS  -->  €ýRVgSurround
gcu  -->  €ýRCommentary€ýRCommentary
gcc  -->  €ýRCommentaryLine
gc  -->  €ýRCommentary
gc  -->  €ýRCommentary
gc  -->  €ýRCommentary
gk  -->  @='4k'
gj  -->  @='4j'
g6  -->  :exe 6 . "wincmd w"
g5  -->  :exe 5 . "wincmd w"
g4  -->  :exe 4 . "wincmd w"
g3  -->  :exe 3 . "wincmd w"
g2  -->  :exe 2 . "wincmd w"
g1  -->  :exe 1 . "wincmd w"
gV  -->  "`[".getregtype(v:register)[0]."`]"
iI  -->  €ýR(InnerDENTURE)
iI  -->  €ýR(InnerDENTURE)
ii  -->  €ýR(InnerDenture)
ii  -->  €ýR(InnerDenture)
ia  -->  €ýRSidewaysArgumentTextobjI
ia  -->  €ýRSidewaysArgumentTextobjI
q€ý,  -->  	
q€ý2  -->  
s  -->  €ýRSneak_s
s  -->  €ýRSneak_s
t€ý2  -->  €ý,:silent TQFSelect 
u  -->  €ýR(RepeatUndo)
u  -->  €ýRSneak_s
yO  -->  :call €ýQ110_setup_paste()O
yo  -->  :call €ýQ110_setup_paste()o
ySS  -->  €ýRYSsurround
ySs  -->  €ýRYSsurround
yss  -->  €ýRYssurround
yS  -->  €ýRYSurround
ys  -->  €ýRYsurround
zf  -->  €ýR(submode-before-entering:folds:with:zf)€ýR(submode-before-entering:folds)€ýR(submode-enter:folds)
zw  -->  ysiw
€F1  -->  :!cscope -Rb:cs reset
€ýR(submode-rhs:scrolling:for:b)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â b  -->  €ýR(submode-rhs:scrolling:for:b)€ýR(submode-enter:scrolling)
€ýR(submode-rhs:scrolling:for:f)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â f  -->  €ýR(submode-rhs:scrolling:for:f)€ýR(submode-enter:scrolling)
€ýR(submode-rhs:scrolling:for:u)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â u  -->  €ýR(submode-rhs:scrolling:for:u)€ýR(submode-enter:scrolling)
€ýR(submode-rhs:scrolling:for:d)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â d  -->  €ýR(submode-rhs:scrolling:for:d)€ýR(submode-enter:scrolling)
€ýR(submode-rhs:scrolling:for:k)  -->  10
€ýR(submode-prefix:scrolling)Â Â Â Â Â k  -->  €ýR(submode-rhs:scrolling:for:k)€ýR(submode-enter:scrolling)
€ýR(submode-rhs:scrolling:for:j)  -->  10
€ýR(submode-prefix:scrolling)Â Â Â Â Â j  -->  €ýR(submode-rhs:scrolling:for:j)€ýR(submode-enter:scrolling)
€ýR(submode-rhs:scrolling:for:y)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â y  -->  €ýR(submode-rhs:scrolling:for:y)€ýR(submode-enter:scrolling)
€ýR(submode-rhs:scrolling:for:e)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â e  -->  €ýR(submode-rhs:scrolling:for:e)€ýR(submode-enter:scrolling)
€ýR(submode-leave:scrolling)  -->  @=€ýQ146_on_leaving_submode('scrolling')
€ýR(submode-prefix:scrolling)Â Â Â Â Â   -->  €ýR(submode-leave:scrolling)
€ýR(submode-before-action:scrolling)  -->  €ýQ146_on_executing_action('scrolling')
€ýR(submode-enter:scrolling)  -->  €ýR(submode-before-action:scrolling)€ýR(submode-prefix:scrolling)Â Â Â Â Â 
€ýR(submode-before-entering:scrolling)  -->  €ýQ146_on_entering_submode('scrolling')
€ýR(submode-before-entering:scrolling:with:gs)  -->  jk
€ýR(submode-rhs:scrolling:for:q)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â q  -->  €ýR(submode-rhs:scrolling:for:q)€ýR(submode-leave:scrolling)
€ýR(submode-rhs:scrolling:for:)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â   -->  €ýR(submode-rhs:scrolling:for:)€ýR(submode-leave:scrolling)
€ýR(submode-rhs:scrolling:for:)  -->  
€ýR(submode-prefix:scrolling)Â Â Â Â Â   -->  €ýR(submode-rhs:scrolling:for:)€ýR(submode-leave:scrolling)
€ýR(submode-rhs:folds:for:z)  -->  zz
€ýR(submode-prefix:folds)Â Â Â Â Â z  -->  €ýR(submode-rhs:folds:for:z)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:b)  -->  zb
€ýR(submode-prefix:folds)Â Â Â Â Â b  -->  €ýR(submode-rhs:folds:for:b)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:t)  -->  zt
€ýR(submode-prefix:folds)Â Â Â Â Â t  -->  €ýR(submode-rhs:folds:for:t)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:C)  -->  zC
€ýR(submode-prefix:folds)Â Â Â Â Â C  -->  €ýR(submode-rhs:folds:for:C)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:c)  -->  zc
€ýR(submode-prefix:folds)Â Â Â Â Â c  -->  €ýR(submode-rhs:folds:for:c)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:O)  -->  zO
€ýR(submode-prefix:folds)Â Â Â Â Â O  -->  €ýR(submode-rhs:folds:for:O)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:o)  -->  zo
€ýR(submode-prefix:folds)Â Â Â Â Â o  -->  €ýR(submode-rhs:folds:for:o)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:v)  -->  zv
€ýR(submode-prefix:folds)Â Â Â Â Â v  -->  €ýR(submode-rhs:folds:for:v)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:x)  -->  zx
€ýR(submode-prefix:folds)Â Â Â Â Â x  -->  €ýR(submode-rhs:folds:for:x)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:R)  -->  zR
€ýR(submode-prefix:folds)Â Â Â Â Â R  -->  €ýR(submode-rhs:folds:for:R)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:r)  -->  zr
€ýR(submode-prefix:folds)Â Â Â Â Â r  -->  €ýR(submode-rhs:folds:for:r)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:M)  -->  zM
€ýR(submode-prefix:folds)Â Â Â Â Â M  -->  €ýR(submode-rhs:folds:for:M)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:m)  -->  zm
€ýR(submode-prefix:folds)Â Â Â Â Â m  -->  €ýR(submode-rhs:folds:for:m)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:6)  -->  6w
€ýR(submode-prefix:folds)Â Â Â Â Â 6  -->  €ýR(submode-rhs:folds:for:6)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:5)  -->  5w
€ýR(submode-prefix:folds)Â Â Â Â Â 5  -->  €ýR(submode-rhs:folds:for:5)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:4)  -->  4w
€ýR(submode-prefix:folds)Â Â Â Â Â 4  -->  €ýR(submode-rhs:folds:for:4)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:3)  -->  3w
€ýR(submode-prefix:folds)Â Â Â Â Â 3  -->  €ýR(submode-rhs:folds:for:3)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:2)  -->  2w
€ýR(submode-prefix:folds)Â Â Â Â Â 2  -->  €ýR(submode-rhs:folds:for:2)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:1)  -->  1w
€ýR(submode-prefix:folds)Â Â Â Â Â 1  -->  €ýR(submode-rhs:folds:for:1)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:])  -->  ]z
€ýR(submode-prefix:folds)Â Â Â Â Â ]  -->  €ýR(submode-rhs:folds:for:])€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:[)  -->  [z
€ýR(submode-prefix:folds)Â Â Â Â Â [  -->  €ýR(submode-rhs:folds:for:[)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:k)  -->  zk
€ýR(submode-prefix:folds)Â Â Â Â Â k  -->  €ýR(submode-rhs:folds:for:k)€ýR(submode-enter:folds)
€ýR(submode-rhs:folds:for:j)  -->  zj
€ýR(submode-prefix:folds)Â Â Â Â Â j  -->  €ýR(submode-rhs:folds:for:j)€ýR(submode-enter:folds)
€ýR(submode-leave:folds)  -->  @=€ýQ146_on_leaving_submode('folds')
€ýR(submode-prefix:folds)Â Â Â Â Â   -->  €ýR(submode-leave:folds)
€ýR(submode-before-action:folds)  -->  €ýQ146_on_executing_action('folds')
€ýR(submode-enter:folds)  -->  €ýR(submode-before-action:folds)€ýR(submode-prefix:folds)Â Â Â Â Â 
€ýR(submode-before-entering:folds)  -->  €ýQ146_on_entering_submode('folds')
€ýR(submode-before-entering:folds:with:zf)  -->  jk
€ýR(submode-rhs:folds:for:q)  -->  
€ýR(submode-prefix:folds)Â Â Â Â Â q  -->  €ýR(submode-rhs:folds:for:q)€ýR(submode-leave:folds)
€ýR(submode-rhs:folds:for:)  -->  
€ýR(submode-prefix:folds)Â Â Â Â Â   -->  €ýR(submode-rhs:folds:for:)€ýR(submode-leave:folds)
€ýR(submode-rhs:folds:for:)  -->  
€ýR(submode-prefix:folds)Â Â Â Â Â   -->  €ýR(submode-rhs:folds:for:)€ýR(submode-leave:folds)
€ýR(submode-rhs:windows:for:T)  -->  T
€ýR(submode-prefix:windows)Â Â Â Â Â T  -->  €ýR(submode-rhs:windows:for:T)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:L)  -->  L
€ýR(submode-prefix:windows)Â Â Â Â Â L  -->  €ýR(submode-rhs:windows:for:L)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:K)  -->  K
€ýR(submode-prefix:windows)Â Â Â Â Â K  -->  €ýR(submode-rhs:windows:for:K)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:J)  -->  J
€ýR(submode-prefix:windows)Â Â Â Â Â J  -->  €ýR(submode-rhs:windows:for:J)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:H)  -->  H
€ýR(submode-prefix:windows)Â Â Â Â Â H  -->  €ýR(submode-rhs:windows:for:H)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:x)  -->  x
€ýR(submode-prefix:windows)Â Â Â Â Â x  -->  €ýR(submode-rhs:windows:for:x)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:R)  -->  R
€ýR(submode-prefix:windows)Â Â Â Â Â R  -->  €ýR(submode-rhs:windows:for:R)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:r)  -->  r
€ýR(submode-prefix:windows)Â Â Â Â Â r  -->  €ýR(submode-rhs:windows:for:r)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:o)  -->  o
€ýR(submode-prefix:windows)Â Â Â Â Â o  -->  €ýR(submode-rhs:windows:for:o)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:c)  -->  c
€ýR(submode-prefix:windows)Â Â Â Â Â c  -->  €ýR(submode-rhs:windows:for:c)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:=)  -->  =
€ýR(submode-prefix:windows)Â Â Â Â Â =  -->  €ýR(submode-rhs:windows:for:=)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:_)  -->  10-
€ýR(submode-prefix:windows)Â Â Â Â Â _  -->  €ýR(submode-rhs:windows:for:_)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:+)  -->  10+
€ýR(submode-prefix:windows)Â Â Â Â Â +  -->  €ýR(submode-rhs:windows:for:+)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:[)  -->  -
€ýR(submode-prefix:windows)Â Â Â Â Â [  -->  €ýR(submode-rhs:windows:for:[)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:])  -->  +
€ýR(submode-prefix:windows)Â Â Â Â Â ]  -->  €ýR(submode-rhs:windows:for:])€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:<)  -->  10<
€ýR(submode-prefix:windows)Â Â Â Â Â <  -->  €ýR(submode-rhs:windows:for:<)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:>)  -->  10>
€ýR(submode-prefix:windows)Â Â Â Â Â >  -->  €ýR(submode-rhs:windows:for:>)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:,)  -->  <
€ýR(submode-prefix:windows)Â Â Â Â Â ,  -->  €ýR(submode-rhs:windows:for:,)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:.)  -->  >
€ýR(submode-prefix:windows)Â Â Â Â Â .  -->  €ýR(submode-rhs:windows:for:.)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:s)  -->  s
€ýR(submode-prefix:windows)Â Â Â Â Â s  -->  €ýR(submode-rhs:windows:for:s)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:v)  -->  v
€ýR(submode-prefix:windows)Â Â Â Â Â v  -->  €ýR(submode-rhs:windows:for:v)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:6)  -->  6w
€ýR(submode-prefix:windows)Â Â Â Â Â 6  -->  €ýR(submode-rhs:windows:for:6)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:5)  -->  5w
€ýR(submode-prefix:windows)Â Â Â Â Â 5  -->  €ýR(submode-rhs:windows:for:5)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:4)  -->  4w
€ýR(submode-prefix:windows)Â Â Â Â Â 4  -->  €ýR(submode-rhs:windows:for:4)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:3)  -->  3w
€ýR(submode-prefix:windows)Â Â Â Â Â 3  -->  €ýR(submode-rhs:windows:for:3)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:2)  -->  2w
€ýR(submode-prefix:windows)Â Â Â Â Â 2  -->  €ýR(submode-rhs:windows:for:2)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:1)  -->  1w
€ýR(submode-prefix:windows)Â Â Â Â Â 1  -->  €ýR(submode-rhs:windows:for:1)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:p)  -->  p
€ýR(submode-prefix:windows)Â Â Â Â Â p  -->  €ýR(submode-rhs:windows:for:p)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:b)  -->  b
€ýR(submode-prefix:windows)Â Â Â Â Â b  -->  €ýR(submode-rhs:windows:for:b)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:t)  -->  t
€ýR(submode-prefix:windows)Â Â Â Â Â t  -->  €ýR(submode-rhs:windows:for:t)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:l)  -->  l
€ýR(submode-prefix:windows)Â Â Â Â Â l  -->  €ýR(submode-rhs:windows:for:l)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:k)  -->  k
€ýR(submode-prefix:windows)Â Â Â Â Â k  -->  €ýR(submode-rhs:windows:for:k)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:j)  -->  j
€ýR(submode-prefix:windows)Â Â Â Â Â j  -->  €ýR(submode-rhs:windows:for:j)€ýR(submode-enter:windows)
€ýR(submode-rhs:windows:for:h)  -->  h
€ýR(submode-prefix:windows)Â Â Â Â Â h  -->  €ýR(submode-rhs:windows:for:h)€ýR(submode-enter:windows)
€ýR(submode-leave:windows)  -->  @=€ýQ146_on_leaving_submode('windows')
€ýR(submode-prefix:windows)Â Â Â Â Â   -->  €ýR(submode-leave:windows)
€ýR(submode-before-action:windows)  -->  €ýQ146_on_executing_action('windows')
€ýR(submode-enter:windows)  -->  €ýR(submode-before-action:windows)€ýR(submode-prefix:windows)Â Â Â Â Â 
€ýR(submode-before-entering:windows)  -->  €ýQ146_on_entering_submode('windows')
€ýR(submode-before-entering:windows:with:g)  -->  jk
€ýR(submode-rhs:windows:for:q)  -->  
€ýR(submode-prefix:windows)Â Â Â Â Â q  -->  €ýR(submode-rhs:windows:for:q)€ýR(submode-leave:windows)
€ýR(submode-rhs:windows:for:)  -->  
€ýR(submode-prefix:windows)Â Â Â Â Â   -->  €ýR(submode-rhs:windows:for:)€ýR(submode-leave:windows)
€ýR(submode-rhs:windows:for:)  -->  
€ýR(submode-prefix:windows)Â Â Â Â Â   -->  €ýR(submode-rhs:windows:for:)€ýR(submode-leave:windows)
€ýR(submode-rhs:undo/redo:for:+)  -->  g+
€ýR(submode-prefix:undo/redo)Â Â Â Â Â +  -->  €ýR(submode-rhs:undo/redo:for:+)€ýR(submode-enter:undo/redo)
€ýR(submode-rhs:undo/redo:for:-)  -->  g-
€ýR(submode-prefix:undo/redo)Â Â Â Â Â -  -->  €ýR(submode-rhs:undo/redo:for:-)€ýR(submode-enter:undo/redo)
€ýR(submode-before-entering:undo/redo:with:g+)  -->  g+
€ýR(submode-leave:undo/redo)  -->  @=€ýQ146_on_leaving_submode('undo/redo')
€ýR(submode-prefix:undo/redo)Â Â Â Â Â   -->  €ýR(submode-leave:undo/redo)
€ýR(submode-before-action:undo/redo)  -->  €ýQ146_on_executing_action('undo/redo')
€ýR(submode-enter:undo/redo)  -->  €ýR(submode-before-action:undo/redo)€ýR(submode-prefix:undo/redo)Â Â Â Â Â 
€ýR(submode-before-entering:undo/redo)  -->  €ýQ146_on_entering_submode('undo/redo')
€ýR(submode-before-entering:undo/redo:with:g-)  -->  g-
€ýR(submode-rhs:undo/redo:for:q)  -->  
€ýR(submode-prefix:undo/redo)Â Â Â Â Â q  -->  €ýR(submode-rhs:undo/redo:for:q)€ýR(submode-leave:undo/redo)
€ýR(submode-rhs:undo/redo:for:)  -->  
€ýR(submode-prefix:undo/redo)Â Â Â Â Â   -->  €ýR(submode-rhs:undo/redo:for:)€ýR(submode-leave:undo/redo)
€ýR(submode-rhs:undo/redo:for:)  -->  
€ýR(submode-prefix:undo/redo)Â Â Â Â Â   -->  €ýR(submode-rhs:undo/redo:for:)€ýR(submode-leave:undo/redo)
€ýRNetrwBrowseXVis  -->  :call netrw#BrowseXVis()
€ýRNetrwBrowseX  -->  :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())
€K9  -->  €ýR(visualstar-*)
€ýQ124_(extra_commands)  -->  €ýQ124_extra_commands()
€ýQ124_(count)  -->  €ýQ124_count()
€ýR(visualstar-g#)  -->  :call €ýQ124_search('?', 1)€ýQ124_(count)€ýQ124_(extra_commands)
€ýR(visualstar-g*)  -->  :call €ýQ124_search('/', 1)€ýQ124_(count)€ýQ124_(extra_commands)
€ýR(visualstar-#)  -->  :call €ýQ124_search('?', 0)€ýQ124_(count)€ýQ124_(extra_commands)
€ýR(visualstar-*)  -->  :call €ýQ124_search('/', 0)€ýQ124_(count)€ýQ124_(extra_commands)
€ýR(visualstar-g#)  -->  g#
€ýR(visualstar-g*)  -->  g*
€ýR(visualstar-#)  -->  #
€ýR(visualstar-*)  -->  *
€ýRVimpleMRU  -->  :echo vimple#undolist#print_mru() . "\n":buffer 
€ýRvimple_filter  -->  :Filter
€ýRvimple_spell_suggest  -->  :call SpellSuggest(expand('<cword>'))
€ýRvimple_ident_search_forward  -->  :call IdentSearch(1)
€ýRvimple_ident_search  -->  :call IdentSearch(0)
€ýRvimple_tag_search  -->  :call TagSearch()
€ýRvfm_argument  -->  :call feedkeys(":VFMArgument \")
€ýRvfm_browse_bufs  -->  :VFMBufs
€ýRvfm_browse_args  -->  :VFMArglist
€ýRvfm_browse_paths  -->  :call VimFindsMeOpts('&path')
€ýRvfm_browse_dirs  -->  :VFMCD
€ýRvfm_browse_files  -->  :VFMEdit
€ýRunimpaired_line_xml_decode  -->  :call €ýQ110_Transform("xml_decode",v:count1)
€ýRunimpaired_xml_decode  -->  :call €ýQ110_Transform("xml_decode",visualmode())
€ýRunimpaired_xml_decode  -->  :call €ýQ110_TransformSetup("xml_decode")g@
€ýRunimpaired_line_xml_encode  -->  :call €ýQ110_Transform("xml_encode",v:count1)
€ýRunimpaired_xml_encode  -->  :call €ýQ110_Transform("xml_encode",visualmode())
€ýRunimpaired_xml_encode  -->  :call €ýQ110_TransformSetup("xml_encode")g@
€ýRunimpaired_line_url_decode  -->  :call €ýQ110_Transform("url_decode",v:count1)
€ýRunimpaired_url_decode  -->  :call €ýQ110_Transform("url_decode",visualmode())
€ýRunimpaired_url_decode  -->  :call €ýQ110_TransformSetup("url_decode")g@
€ýRunimpaired_line_url_encode  -->  :call €ýQ110_Transform("url_encode",v:count1)
€ýRunimpaired_url_encode  -->  :call €ýQ110_Transform("url_encode",visualmode())
€ýRunimpaired_url_encode  -->  :call €ýQ110_TransformSetup("url_encode")g@
€ýRunimpaired_line_string_decode  -->  :call €ýQ110_Transform("string_decode",v:count1)
€ýRunimpaired_string_decode  -->  :call €ýQ110_Transform("string_decode",visualmode())
€ýRunimpaired_string_decode  -->  :call €ýQ110_TransformSetup("string_decode")g@
€ýRunimpaired_line_string_encode  -->  :call €ýQ110_Transform("string_encode",v:count1)
€ýRunimpaired_string_encode  -->  :call €ýQ110_Transform("string_encode",visualmode())
€ýRunimpaired_string_encode  -->  :call €ýQ110_TransformSetup("string_encode")g@
€ýRunimpairedPutBelow  -->  :call €ýQ110_putline(']p', 'Below')
€ýRunimpairedPutAbove  -->  :call €ýQ110_putline('[p', 'Above')
€ýRunimpairedPaste  -->  :call €ýQ110_setup_paste()
€ýRunimpairedMoveSelectionDown  -->  :call €ýQ110_MoveSelectionDown(v:count1)
€ýRunimpairedMoveSelectionUp  -->  :call €ýQ110_MoveSelectionUp(v:count1)
€ýRunimpairedMoveDown  -->  :call €ýQ110_Move('+',v:count1,'Down')
€ýRunimpairedMoveUp  -->  :call €ýQ110_Move('--',v:count1,'Up')
€ýRunimpairedBlankDown  -->  :call €ýQ110_BlankDown(v:count1)
€ýRunimpairedBlankUp  -->  :call €ýQ110_BlankUp(v:count1)
€ýRunimpairedContextNext  -->  :call €ýQ110_ContextMotion(0)
€ýRunimpairedContextPrevious  -->  :call €ýQ110_ContextMotion(1)
€ýRunimpairedContextNext  -->  :call €ýQ110_Context(0)
€ýRunimpairedContextPrevious  -->  :call €ýQ110_Context(1)
€ýRunimpairedOPrevious  -->  €ýRunimpairedDirectoryPrevious:echohl WarningMSG|echo "[o is deprecated. Use [f"|echohl NONE
€ýRunimpairedONext  -->  €ýRunimpairedDirectoryNext:echohl WarningMSG|echo "]o is deprecated. Use ]f"|echohl NONE
€ýRunimpairedDirectoryPrevious  -->  :edit =fnamemodify(€ýQ110_fnameescape(€ýQ110_FileByOffset(-v:count1)), ':.')
€ýRunimpairedDirectoryNext  -->  :edit =fnamemodify(€ýQ110_fnameescape(€ýQ110_FileByOffset(v:count1)), ':.')
€ýRunimpairedTLast  -->  :exe "".(v:count ? v:count : "")."tlast"
€ýRunimpairedTFirst  -->  :exe "".(v:count ? v:count : "")."tfirst"
€ýRunimpairedTNext  -->  :exe "".(v:count ? v:count : "")."tnext"
€ýRunimpairedTPrevious  -->  :exe "".(v:count ? v:count : "")."tprevious"
€ýRunimpairedQNFile  -->  :exe "".(v:count ? v:count : "")."cnfile"zv
€ýRunimpairedQPFile  -->  :exe "".(v:count ? v:count : "")."cpfile"zv
€ýRunimpairedQLast  -->  :exe "".(v:count ? v:count : "")."clast"zv
€ýRunimpairedQFirst  -->  :exe "".(v:count ? v:count : "")."cfirst"zv
€ýRunimpairedQNext  -->  :exe "".(v:count ? v:count : "")."cnext"zv
€ýRunimpairedQPrevious  -->  :exe "".(v:count ? v:count : "")."cprevious"zv
€ýRunimpairedLNFile  -->  :exe "".(v:count ? v:count : "")."lnfile"zv
€ýRunimpairedLPFile  -->  :exe "".(v:count ? v:count : "")."lpfile"zv
€ýRunimpairedLLast  -->  :exe "".(v:count ? v:count : "")."llast"zv
€ýRunimpairedLFirst  -->  :exe "".(v:count ? v:count : "")."lfirst"zv
€ýRunimpairedLNext  -->  :exe "".(v:count ? v:count : "")."lnext"zv
€ýRunimpairedLPrevious  -->  :exe "".(v:count ? v:count : "")."lprevious"zv
€ýRunimpairedBLast  -->  :exe "".(v:count ? v:count : "")."blast"
€ýRunimpairedBFirst  -->  :exe "".(v:count ? v:count : "")."bfirst"
€ýRunimpairedBNext  -->  :exe "".(v:count ? v:count : "")."bnext"
€ýRunimpairedBPrevious  -->  :exe "".(v:count ? v:count : "")."bprevious"
€ýRunimpairedALast  -->  :exe "".(v:count ? v:count : "")."last"
€ýRunimpairedAFirst  -->  :exe "".(v:count ? v:count : "")."first"
€ýRunimpairedANext  -->  :exe "".(v:count ? v:count : "")."next"
€ýRunimpairedAPrevious  -->  :exe "".(v:count ? v:count : "")."previous"
€kD  -->  c
€kb  -->  c
€k3  -->  :call UltiSnips#ListSnippets()
€ýRVgSurround  -->  :call €ýQ95_opfunc(visualmode(),visualmode() ==# 'V' ? 0 : 1)
€ýRVSurround  -->  :call €ýQ95_opfunc(visualmode(),visualmode() ==# 'V' ? 1 : 0)
€ýRYSurround  -->  :set opfunc=€ýQ95_opfunc2g@
€ýRYsurround  -->  :set opfunc=€ýQ95_opfuncg@
€ýRYSsurround  -->  :call €ýQ95_opfunc2(v:count1)
€ýRYssurround  -->  :call €ýQ95_opfunc(v:count1)
€ýRCSurround  -->  :call €ýQ95_changesurround(1)
€ýRCsurround  -->  :call €ýQ95_changesurround()
€ýRDsurround  -->  :call €ýQ95_dosurround(€ýQ95_inputtarget())
€ýRSurroundRepeat  -->  .
€ýRSneakPrevious  -->  €ýRSneak_,
€ýRSneakNext  -->  €ýRSneak_;
€ýRSneakPrevious  -->  €ýRSneak_,
€ýRSneakNext  -->  €ýRSneak_;
€ýRSneakPrevious  -->  €ýRSneak_,
€ýRSneakNext  -->  €ýRSneak_;
€ýR(SneakStreakBackward)  -->  €ýRSneakLabel_S
€ýR(SneakStreak)  -->  €ýRSneakLabel_s
€ýR(SneakStreakBackward)  -->  €ýRSneakLabel_S
€ýR(SneakStreak)  -->  €ýRSneakLabel_s
€ýR(SneakStreakBackward)  -->  €ýRSneakLabel_S
€ýR(SneakStreak)  -->  €ýRSneakLabel_s
€ýRVSneakPrevious  -->  €ýRSneak_,
€ýRVSneakNext  -->  €ýRSneak_;
€ýRVSneakBackward  -->  €ýRSneak_S
€ýRVSneakForward  -->  €ýRSneak_s
€ýRSneakBackward  -->  €ýRSneak_S
€ýRSneakForward  -->  €ýRSneak_s
€ýRSneakLabel_S  -->  :call sneak#wrap(v:operator, 2, 1, 2, 2)
€ýRSneakLabel_s  -->  :call sneak#wrap(v:operator, 2, 0, 2, 2)
€ýRSneakLabel_S  -->  :call sneak#wrap(visualmode(), 2, 1, 2, 2)
€ýRSneakLabel_s  -->  :call sneak#wrap(visualmode(), 2, 0, 2, 2)
€ýRSneakLabel_S  -->  :call sneak#wrap('', 2, 1, 2, 2)
€ýRSneakLabel_s  -->  :call sneak#wrap('', 2, 0, 2, 2)
€ýRSneak_T  -->  :call sneak#wrap(v:operator, 1, 1, 0, 0)
€ýRSneak_t  -->  :call sneak#wrap(v:operator, 1, 0, 0, 0)
€ýRSneak_T  -->  :call sneak#wrap(visualmode(), 1, 1, 0, 0)
€ýRSneak_t  -->  :call sneak#wrap(visualmode(), 1, 0, 0, 0)
€ýRSneak_T  -->  :call sneak#wrap('', 1, 1, 0, 0)
€ýRSneak_t  -->  :call sneak#wrap('', 1, 0, 0, 0)
€ýRSneak_F  -->  :call sneak#wrap(v:operator, 1, 1, 1, 0)
€ýRSneak_f  -->  :call sneak#wrap(v:operator, 1, 0, 1, 0)
€ýRSneak_F  -->  :call sneak#wrap(visualmode(), 1, 1, 1, 0)
€ýRSneak_f  -->  :call sneak#wrap(visualmode(), 1, 0, 1, 0)
€ýRSneak_F  -->  :call sneak#wrap('', 1, 1, 1, 0)
€ýRSneak_f  -->  :call sneak#wrap('', 1, 0, 1, 0)
€ýRSneak_,  -->  :call sneak#rpt(v:operator, 1)
€ýRSneak_;  -->  :call sneak#rpt(v:operator, 0)
€ýRSneak_,  -->  :call sneak#rpt(visualmode(), 1)
€ýRSneak_;  -->  :call sneak#rpt(visualmode(), 0)
€ýRSneak_,  -->  :call sneak#rpt('', 1)
€ýRSneak_;  -->  :call sneak#rpt('', 0)
€ýRSneakRepeat  -->  :call sneak#wrap(v:operator, sneak#util#getc(), sneak#util#getc(), sneak#util#getc(), sneak#util#getc())
€ýRSneak_S  -->  :call sneak#wrap(v:operator, 2, 1, 2, 1)
€ýRSneak_s  -->  :call sneak#wrap(v:operator, 2, 0, 2, 1)
€ýRSneak_S  -->  :call sneak#wrap(visualmode(), 2, 1, 2, 1)
€ýRSneak_s  -->  :call sneak#wrap(visualmode(), 2, 0, 2, 1)
€ýRSneak_S  -->  :call sneak#wrap('', 2, 1, 2, 1)
€ýRSneak_s  -->  :call sneak#wrap('', 2, 0, 2, 1)
€ýRSidewaysArgumentTextobjI  -->  :call sideways#textobj#Argument('i')
€ýRSidewaysArgumentTextobjI  -->  :call sideways#textobj#Argument('i')
€ýRSidewaysArgumentTextobjA  -->  :call sideways#textobj#Argument('a')
€ýRSidewaysArgumentTextobjA  -->  :call sideways#textobj#Argument('a')
€ýRSidewaysRight  -->  :SidewaysRight
€ýRSidewaysLeft  -->  :SidewaysLeft
€ýR(sexp_capture_next_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'v', 1, 1)
€ýR(sexp_capture_next_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'n', 1, 1) | call €ýQ90_repeat_set("\€ýR(sexp_capture_next_element)", b:sexp_count)
€ýR(sexp_capture_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'v', 0, 1)
€ýR(sexp_capture_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'n', 0, 1) | call €ýQ90_repeat_set("\€ýR(sexp_capture_prev_element)", b:sexp_count)
€ýR(sexp_emit_tail_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'v', 1, 0)
€ýR(sexp_emit_tail_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'n', 1, 0) | call €ýQ90_repeat_set("\€ýR(sexp_emit_tail_element)", b:sexp_count)
€ýR(sexp_emit_head_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'v', 0, 0)
€ýR(sexp_emit_head_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#stackop', 'n', 0, 0) | call €ýQ90_repeat_set("\€ýR(sexp_emit_head_element)", b:sexp_count)
€ýR(sexp_swap_element_forward)  -->  :call sexp#docount(v:prevcount, 'sexp#swap_element', 'v', 1, 0)
€ýR(sexp_swap_element_forward)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#swap_element', 'n', 1, 0) | call €ýQ90_repeat_set("\€ýR(sexp_swap_element_forward)", b:sexp_count)
€ýR(sexp_swap_element_backward)  -->  :call sexp#docount(v:prevcount, 'sexp#swap_element', 'v', 0, 0)
€ýR(sexp_swap_element_backward)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#swap_element', 'n', 0, 0) | call €ýQ90_repeat_set("\€ýR(sexp_swap_element_backward)", b:sexp_count)
€ýR(sexp_swap_list_forward)  -->  :call sexp#docount(v:prevcount, 'sexp#swap_element', 'v', 1, 1)
€ýR(sexp_swap_list_forward)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#swap_element', 'n', 1, 1) | call €ýQ90_repeat_set("\€ýR(sexp_swap_list_forward)", b:sexp_count)
€ýR(sexp_swap_list_backward)  -->  :call sexp#docount(v:prevcount, 'sexp#swap_element', 'v', 0, 1)
€ýR(sexp_swap_list_backward)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#swap_element', 'n', 0, 1) | call €ýQ90_repeat_set("\€ýR(sexp_swap_list_backward)", b:sexp_count)
€ýR(sexp_splice_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#splice_list(b:sexp_count) | call €ýQ90_repeat_set("\€ýR(sexp_splice_list)", b:sexp_count)
€ýR(sexp_raise_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#raise', 'v', '')
€ýR(sexp_raise_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#raise', 'n', 'sexp#select_current_element', 'n', 1) | call €ýQ90_repeat_set("\€ýR(sexp_raise_element)", b:sexp_count)
€ýR(sexp_raise_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#raise', 'v', '')
€ýR(sexp_raise_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#raise', 'n', 'sexp#select_current_list', 'n', 0, 0) | call €ýQ90_repeat_set("\€ýR(sexp_raise_list)", b:sexp_count)
€ýR(sexp_insert_at_list_tail)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#insert_at_list_terminal(1) | call €ýQ90_repeat_set("\€ýR(sexp_insert_at_list_tail)", b:sexp_count)
€ýR(sexp_insert_at_list_head)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#insert_at_list_terminal(0) | call €ýQ90_repeat_set("\€ýR(sexp_insert_at_list_head)", b:sexp_count)
€ýR(sexp_curly_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '{', '}', 1, g:sexp_insert_after_wrap)
€ýR(sexp_curly_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '{', '}', 1, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_curly_tail_wrap_element)", b:sexp_count)
€ýR(sexp_curly_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '{', '}', 0, g:sexp_insert_after_wrap)
€ýR(sexp_curly_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '{', '}', 0, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_curly_head_wrap_element)", b:sexp_count)
€ýR(sexp_square_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '[', ']', 1, g:sexp_insert_after_wrap)
€ýR(sexp_square_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '[', ']', 1, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_square_tail_wrap_element)", b:sexp_count)
€ýR(sexp_square_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '[', ']', 0, g:sexp_insert_after_wrap)
€ýR(sexp_square_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '[', ']', 0, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_square_head_wrap_element)", b:sexp_count)
€ýR(sexp_round_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '(', ')', 1, g:sexp_insert_after_wrap)
€ýR(sexp_round_tail_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '(', ')', 1, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_round_tail_wrap_element)", b:sexp_count)
€ýR(sexp_round_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '(', ')', 0, g:sexp_insert_after_wrap)
€ýR(sexp_round_head_wrap_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('e', '(', ')', 0, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_round_head_wrap_element)", b:sexp_count)
€ýR(sexp_curly_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '{', '}', 1, g:sexp_insert_after_wrap)
€ýR(sexp_curly_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '{', '}', 1, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_curly_tail_wrap_list)", b:sexp_count)
€ýR(sexp_curly_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '{', '}', 0, g:sexp_insert_after_wrap)
€ýR(sexp_curly_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '{', '}', 0, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_curly_head_wrap_list)", b:sexp_count)
€ýR(sexp_square_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '[', ']', 1, g:sexp_insert_after_wrap)
€ýR(sexp_square_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '[', ']', 1, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_square_tail_wrap_list)", b:sexp_count)
€ýR(sexp_square_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '[', ']', 0, g:sexp_insert_after_wrap)
€ýR(sexp_square_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '[', ']', 0, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_square_head_wrap_list)", b:sexp_count)
€ýR(sexp_round_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '(', ')', 1, g:sexp_insert_after_wrap)
€ýR(sexp_round_tail_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '(', ')', 1, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_round_tail_wrap_list)", b:sexp_count)
€ýR(sexp_round_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('v', '(', ')', 0, g:sexp_insert_after_wrap)
€ýR(sexp_round_head_wrap_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#wrap('f', '(', ')', 0, g:sexp_insert_after_wrap) | call €ýQ90_repeat_set("\€ýR(sexp_round_head_wrap_list)", b:sexp_count)
€ýR(sexp_indent_top)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#indent(1, b:sexp_count) | call €ýQ90_repeat_set("\€ýR(sexp_indent_top)", b:sexp_count)
€ýR(sexp_indent)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#indent(0, b:sexp_count) | call €ýQ90_repeat_set("\€ýR(sexp_indent)", b:sexp_count)
€ýR(sexp_select_next_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'o', 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_select_next_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_select_next_element)", b:sexp_count) | endif
€ýR(sexp_select_next_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'v', 1)
€ýR(sexp_select_next_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'n', 1)
€ýR(sexp_select_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'o', 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_select_prev_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_select_prev_element)", b:sexp_count) | endif
€ýR(sexp_select_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'v', 0)
€ýR(sexp_select_prev_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_adjacent_element', 'n', 0)
€ýR(sexp_move_to_next_top_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#move_to_adjacent_element('o', b:sexp_count, 1, 0, 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_next_top_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_next_top_element)", b:sexp_count) | endif
€ýR(sexp_move_to_next_top_element)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 1, 0, 1)
€ýR(sexp_move_to_next_top_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#move_to_adjacent_element('n', b:sexp_count, 1, 0, 1)
€ýR(sexp_move_to_prev_top_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#move_to_adjacent_element('o', b:sexp_count, 0, 0, 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_prev_top_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_prev_top_element)", b:sexp_count) | endif
€ýR(sexp_move_to_prev_top_element)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 0, 0, 1)
€ýR(sexp_move_to_prev_top_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#move_to_adjacent_element('n', b:sexp_count, 0, 0, 1)
€ýR(sexp_move_to_next_element_tail)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('o', b:sexp_count, 1, 1, 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_next_element_tail)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_next_element_tail)", b:sexp_count) | endif
€ýR(sexp_move_to_next_element_tail)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 1, 1, 0)
€ýR(sexp_move_to_next_element_tail)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('n', b:sexp_count, 1, 1, 0)
€ýR(sexp_move_to_prev_element_tail)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('o', b:sexp_count, 0, 1, 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_prev_element_tail)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_prev_element_tail)", b:sexp_count) | endif
€ýR(sexp_move_to_prev_element_tail)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 0, 1, 0)
€ýR(sexp_move_to_prev_element_tail)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('n', b:sexp_count, 0, 1, 0)
€ýR(sexp_move_to_next_element_head)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('o', b:sexp_count, 1, 0, 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_next_element_head)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_next_element_head)", b:sexp_count) | endif
€ýR(sexp_move_to_next_element_head)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 1, 0, 0)
€ýR(sexp_move_to_next_element_head)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('n', b:sexp_count, 1, 0, 0)
€ýR(sexp_move_to_prev_element_head)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('o', b:sexp_count, 0, 0, 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_prev_element_head)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_prev_element_head)", b:sexp_count) | endif
€ýR(sexp_move_to_prev_element_head)  -->  :call sexp#move_to_adjacent_element('v', v:prevcount, 0, 0, 0)
€ýR(sexp_move_to_prev_element_head)  -->  :let b:sexp_count = v:count | call sexp#move_to_adjacent_element('n', b:sexp_count, 0, 0, 0)
€ýR(sexp_move_to_next_bracket)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#move_to_nearest_bracket('o', 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_next_bracket)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_next_bracket)", b:sexp_count) | endif
€ýR(sexp_move_to_next_bracket)  -->  :call sexp#docount(v:prevcount, 'sexp#move_to_nearest_bracket', 'v', 1)
€ýR(sexp_move_to_next_bracket)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#move_to_nearest_bracket', 'n', 1)
€ýR(sexp_move_to_prev_bracket)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#move_to_nearest_bracket('o', 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_prev_bracket)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_move_to_prev_bracket)", b:sexp_count) | endif
€ýR(sexp_move_to_prev_bracket)  -->  :call sexp#docount(v:prevcount, 'sexp#move_to_nearest_bracket', 'v', 0)
€ýR(sexp_move_to_prev_bracket)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#move_to_nearest_bracket', 'n', 0)
€ýR(sexp_inner_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_element('o', 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_inner_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_inner_element)", b:sexp_count) | endif
€ýR(sexp_inner_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_element('v', 1)
€ýR(sexp_outer_element)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_element('o', 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_outer_element)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_outer_element)", b:sexp_count) | endif
€ýR(sexp_outer_element)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_element('v', 0)
€ýR(sexp_inner_string)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_string('o', 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_inner_string)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_inner_string)", b:sexp_count) | endif
€ýR(sexp_inner_string)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_string('v', 1)
€ýR(sexp_outer_string)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_string('o', 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_outer_string)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_outer_string)", b:sexp_count) | endif
€ýR(sexp_outer_string)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_string('v', 0)
€ýR(sexp_inner_top_list)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_top_list('o', 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_inner_top_list)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_inner_top_list)", b:sexp_count) | endif
€ýR(sexp_inner_top_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_top_list('v', 1)
€ýR(sexp_outer_top_list)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#select_current_top_list('o', 0) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_outer_top_list)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_outer_top_list)", b:sexp_count) | endif
€ýR(sexp_outer_top_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#select_current_top_list('v', 0)
€ýR(sexp_inner_list)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#docount(b:sexp_count, 'sexp#select_current_list', 'o', 1, 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_inner_list)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_inner_list)", b:sexp_count) | endif
€ýR(sexp_inner_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_current_list', 'v', 1, 1)
€ýR(sexp_outer_list)  -->  :let b:sexp_count = v:count | execute "normal! vvm`" | call sexp#docount(b:sexp_count, 'sexp#select_current_list', 'o', 0, 1) | if v:operator ==? "c" |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_outer_list)\<C-r>.\<C-Bslash>\<C-n>", b:sexp_count) | else |   call €ýQ90_repeat_set(v:operator . "\€ýR(sexp_outer_list)", b:sexp_count) | endif
€ýR(sexp_outer_list)  -->  :let b:sexp_count = v:count | execute "normal! m`" | call sexp#docount(b:sexp_count, 'sexp#select_current_list', 'v', 0, 1)
€ýR(RepeatRedo)  -->  :call repeat#wrap("\<C-R>",v:count)
€ýR(RepeatUndoLine)  -->  :call repeat#wrap('U',v:count)
€ýR(RepeatUndo)  -->  :call repeat#wrap('u',v:count)
€ýR(RepeatDot)  -->  :exe repeat#run(v:count)
€ýR(GrepperOperator)  -->  :call grepper#operator(visualmode())
€ýR(GrepperOperator)  -->  :set opfunc=grepper#operatorg@
€ýQ63_:  -->  :=v:count ? v:count : ''
€ýR(ExchangeLine)  -->  ':set operatorfunc=€ýQ62_exchange_set'.(v:count1 == 1 ? '' : v:count1).'g@_'
€ýR(ExchangeClear)  -->  :call €ýQ62_exchange_clear()
€ýR(Exchange)  -->  :call €ýQ62_exchange_set(visualmode(), 1)
€ýR(Exchange)  -->  ':set operatorfunc=€ýQ62_exchange_set'.(v:count1 == 1 ? '' : v:count1).'g@'
€ýR(OuterDENTURE)  -->  :call dentures#select(line('.'), 1, 1, 'operator')
€ýR(OuterDenture)  -->  :call dentures#select(line('.'), 1, 0, 'operator')
€ýR(InnerDENTURE)  -->  :call dentures#select(line('.'), 0, 1, 'operator')
€ýR(InnerDenture)  -->  :call dentures#select(line('.'), 0, 0, 'operator')
€ýR(OuterDENTURE)  -->  dentures#select(line('.'), 1, 1, mode())
€ýR(OuterDenture)  -->  dentures#select(line('.'), 1, 0, mode())
€ýR(InnerDENTURE)  -->  dentures#select(line('.'), 0, 1, mode())
€ýR(InnerDenture)  -->  dentures#select(line('.'), 0, 0, mode())
€ÿX  -->  :CtrlP
€ýRCommentaryUndo  -->  €ýRCommentary€ýRCommentary
€ýRChangeCommentary  -->  c:call €ýQ56_textobject(1)
€ýRCommentary  -->  :call €ýQ56_textobject(0)
€ýRCommentaryLine  -->  :set opfunc=€ýQ56_go|exe 'norm! 'v:count1.'g@_'
€ýRCommentary  -->  :set opfunc=€ýQ56_gog@
€ýRCommentary  -->  :call €ýQ56_go(line("'<"),line("'>"))
€ýRCoerce  -->  :call €ýQ55_coerce(nr2char(getchar()))
€ü€k8  -->  :call €ýQ50_NextColor(0, 1)
€ý  -->  :call €ýQ50_NextColor(-1, 1)
€k8  -->  :call €ýQ50_NextColor(1, 1)
€ýRremove_vimple_ident_search_forward  -->  €ýRvimple_ident_search_forward
€ýRremove_vimple_ident_search  -->  €ýRvimple_ident_search
€ýRremove_vimple_spell_suggest  -->  €ýRvimple_spell_suggest
€ýRremove_vimple_tag_search  -->  €ýRvimple_tag_search
€k5  -->  :GundoToggle
€ü   -->  €ÿX
€ku  -->  DVB_Drag('up')
€kd  -->  DVB_Drag('down')
€kr  -->  DVB_Drag('right')
€kl  -->  DVB_Drag('left')
€ý/  -->  €ý,:silent RunCommand
€k2  -->  y:exe getreg('"')
€k2  -->  :call RunCommand(0)
€k9  -->  :Neomake!
€F2  -->  :!ctags -R --fields=+iaS --extra=+qf .
€k;  -->  :%s/\s\+$//:nohlsearch
€ý2  -->  €ý,:silent call helpers#plumb_this()
€ý.  -->  €ý."*ygv
  -->  
S  -->  €ýRISurround
s  -->  €ýRIsurround
	  -->  =UltiSnips#ExpandSnippet()
  -->  €ýRIsurround
  -->  complete#trigger('completers#datetime')
  -->  complete#trigger('completers#abbrevs')
-  -->  _
_  -->  -
(gdb) 
vshcmd: > detach
Detaching from program: /home/matthew/share/repos/neovim/build/bin/nvim, process 866
(gdb) 
vshcmd: > quit
gdb-config [15:46:50] $ 
