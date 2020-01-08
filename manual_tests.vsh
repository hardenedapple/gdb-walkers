vshcmd: > gdb demos/tree_debug
vshcmd: > python import demos.tree_walker
vshcmd: > tbreak tree.c:93
vshcmd: > run 10
vshcmd: > gdb-pipe tree-elements tree_root | if {}->children[0] == 0 && {}->children[1] == 0 | show printf "%d\n", {}->datum
vshcmd: > y
vshcmd: > sudo bash -c "echo 0 > /proc/sys/kernel/yama/ptrace_scope"
vshcmd: > # vimcmd; .,.+4Vrerun
vshcmd: > detach
vshcmd: > quit
vshcmd: > gdb ~/share/repos/neovim/build/bin/nvim
vshcmd: > attach-matching nvim walker-test
vshcmd: > shellpipe gdb-pipe nvim-garray &curwin->w_folds; fold_T ! cat > garray.txt
vshcmd: > shellpipe gdb-pipe nvim-folds &curwin->w_folds ! cat > folds.txt
vshcmd: > # Should be same if there are only top-level folds.
vshcmd: > # Otherwise nested folds should only be shown in the nvim-folds output.
vshcmd: > !diff folds.txt garray.txt
vshcmd: > # Check these fit with your vim process
vshcmd: > gdb-pipe nvim-folds &curwin->w_folds | show print *{}
vshcmd: > shellpipe gdb-pipe eval &curwin->w_folds | nvim-folds ! cat > garray.txt
vshcmd: > !diff folds.txt garray.txt   # Should be same
vshcmd: > !rm folds.txt garray.txt
vshcmd: > # Check these fit with your vim process
vshcmd: > # Note that this will print what text was originally in the changed range.
vshcmd: > # The easiest method to check everything makes sense is by deleting a line
vshcmd: > gdb-pipe nvim-undohist curbuf->b_u_oldhead | if {}->uh_entry->ue_array != 0 | show print *{} | array char *; {}->uh_entry->ue_array; {}->uh_entry->ue_size | show print *{}
vshcmd: > gdb-pipe nvim-undohist curbuf->b_u_oldhead | show print *{}
vshcmd: > shellpipe gdb-pipe nvim-undohist curbuf->b_u_oldhead ! cat > undohist.txt
vshcmd: > shellpipe gdb-pipe eval curbuf->b_u_oldhead | nvim-undohist ! cat > alt.txt
vshcmd: > !diff alt.txt undohist.txt   # Should be same
vshcmd: > !rm alt.txt undohist.txt
vshcmd: > gdb-pipe nvim-buffers | show print {}->b_ffname
vshcmd: > gdb-pipe nvim-buffers | if {}->b_ffname | if $_regex({}->b_ffname, ".*tree.*") | show print {}->b_ffname
vshcmd: > gdb-pipe nvim-tabs | show print *{}
vshcmd: > gdb-pipe nvim-tabs | if {}->tp_localdir | show print {}->tp_localdir
vshcmd: > gdb-pipe nvim-tabs | nvim-windows {}
vshcmd: > gdb-pipe nvim-windows
vshcmd: > gdb-pipe nvim-windows curtab
vshcmd: > watch main_loop.events->headtail.next
vshcmd: > cont
vshcmd: > bt
vshcmd: > frame 2
vshcmd: > finish
vshcmd: > disable 1
vshcmd: > gdb-pipe nvim-mqueue main_loop.events | show print *{}
vshcmd: > gdb-pipe nvim-mqueue main_loop.events | show print {}
vshcmd: > gdb-pipe nvim-mqueue main_loop.events; deref | show print *{}
vshcmd: > gdb-pipe nvim-mqueue main_loop.events; deref | show print {}
vshcmd: > print *main_loop.events
vshcmd: > break stuff_inserted
vshcmd: > cont
vshcmd: > bt
vshcmd: > up
vshcmd: > finish
vshcmd: > gdb-pipe nvim-buffblocks &readbuf1 | show printf "%s\n", {}->b_str
vshcmd: > gdb-pipe array mapblock_T *; maphash; 256 | eval *{} | if {} != 0 | nvim-mapblock | show print-string {}->m_keys; "  -->  "; {}->m_str; "\n"
vshcmd: > gdb-pipe array mapblock_T *; maphash; 256 | eval *{} | if {} != 0 | nvim-mapblock | show printf "%s  -->  %s\n", {}->m_keys, {}->m_str
vshcmd: > gdb-pipe nvim-maps | show print-string {}->m_keys; "  -->  "; {}->m_str; "\n"
vshcmd: > gdb-pipe nvim-maps | show printf "%s  -->  %s\n", {}->m_keys, {}->m_str
vshcmd: > gdb-pipe nvim-maps curbuf | show printf "%s  -->  %s\n", {}->m_keys, {}->m_str
vshcmd: > gdb-pipe nvim-buffers | nvim-maps | show printf "%s  -->  %s\n", {}->m_keys, {}->m_str
vshcmd: > detach
vshcmd: > quit
