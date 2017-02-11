.PHONY: test
test: demos/tree_debug demos/tree
	runtest --srcdir testsuite --tool gdb_config

demos/tree_debug: demos/tree.c
	gcc -g demos/tree.c -o demos/tree_debug

demos/tree: demos/tree.c
	gcc demos/tree.c -o demos/tree


