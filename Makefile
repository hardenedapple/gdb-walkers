.PHONY: test
test: demos/tree_debug demos/tree demos/list
	runtest --srcdir testsuite --tool gdb_config

demos/tree_debug: demos/tree.c
	gcc -g demos/tree.c -o demos/tree_debug

demos/tree: demos/tree.c
	gcc demos/tree.c -o demos/tree

demos/list: demos/list.c
	gcc -g demos/list.c -o demos/list
