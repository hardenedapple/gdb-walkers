vshcmd: > gdb demos/tree_debug
vshcmd: > python import demos.tree_walker
vshcmd: > tbreak tree.c:93
vshcmd: > run 10
vshcmd: > pipe tree-elements tree_root | if {}->children[0] == 0 && {}->children[1] == 0 | show printf "%d\n", {}->datum
vshcmd: > y
vshcmd: > sudo bash -c "echo 0 > /proc/sys/kernel/yama/ptrace_scope"
vshcmd: > # vimcmd; .,.+4Vrerun
vshcmd: > detach
vshcmd: > quit
vshcmd: > gdb ~/share/repos/neovim/build/bin/nvim
vshcmd: > attach-matching nvim walker-test
vshcmd: > shellpipe pipe nvim-garray &curwin->w_folds; fold_T ! cat > garray.txt
vshcmd: > shellpipe pipe nvim-folds &curwin->w_folds ! cat > folds.txt
vshcmd: > !diff folds.txt garray.txt   # Should be same
vshcmd: > pipe nvim-folds &curwin->w_folds | show print *{}  # Check these fit with your vim process
vshcmd: > shellpipe pipe eval &curwin->w_folds | nvim-folds ! cat > folds.txt
vshcmd: > !diff folds.txt garray.txt   # Should be same
vshcmd: > !rm folds.txt garray.txt
vshcmd: > pipe nvim-undohist curbuf->b_u_oldhead | show print *{} # Check these fit with your vim process
vshcmd: > shellpipe pipe nvim-undohist curbuf->b_u_oldhead ! cat > undohist.txt
vshcmd: > shellpipe pipe eval curbuf->b_u_oldhead | nvim-undohist ! cat > alt.txt
vshcmd: > !diff alt.txt undohist.txt   # Should be same
vshcmd: > !rm alt.txt undohist.txt
vshcmd: > pipe nvim-buffers | show print {}->b_ffname
vshcmd: > pipe nvim-buffers | if {}->b_ffname | if $_regex({}->b_ffname, ".*tree.*") | show print {}->b_ffname
vshcmd: > pipe nvim-tabs | show print *{}
vshcmd: > pipe nvim-tabs | if {}->tp_localdir | show print {}->tp_localdir
vshcmd: > pipe nvim-tabs | nvim-windows {}
vshcmd: > pipe nvim-windows
vshcmd: > pipe nvim-windows curtab
vshcmd: > watch main_loop.events->headtail.next
vshcmd: > cont
vshcmd: > bt
vshcmd: > frame 2
vshcmd: > finish
vshcmd: > disable 1
vshcmd: > pipe nvim-mqueue main_loop.events | show print *{}
vshcmd: > pipe nvim-mqueue main_loop.events | show print {}
vshcmd: > pipe nvim-mqueue main_loop.events; deref | show print *{}
vshcmd: > pipe nvim-mqueue main_loop.events; deref | show print {}
vshcmd: > print *main_loop.events
vshcmd: > break stuff_inserted
vshcmd: > cont
vshcmd: > bt
vshcmd: > up
vshcmd: > finish
vshcmd: > pipe nvim-buffblocks &readbuf1 | show printf "%s\n", {}->b_str
vshcmd: > pipe array mapblock_T *; maphash; 256 | eval *{} | if {} != 0 | nvim-mapblock | show print-string {}->m_keys; "  -->  "; {}->m_str; "\n"
vshcmd: > pipe array mapblock_T *; maphash; 256 | eval *{} | if {} != 0 | nvim-mapblock | show printf "%s  -->  %s\n", {}->m_keys, {}->m_str
vshcmd: > pipe nvim-maps | show print-string {}->m_keys; "  -->  "; {}->m_str; "\n"
vshcmd: > pipe nvim-maps | show printf "%s  -->  %s\n", {}->m_keys, {}->m_str
vshcmd: > pipe nvim-maps curbuf | show printf "%s  -->  %s\n", {}->m_keys, {}->m_str
vshcmd: > pipe nvim-buffers | nvim-maps | show printf "%s  -->  %s\n", {}->m_keys, {}->m_str
vshcmd: > detach
vshcmd: > quit
