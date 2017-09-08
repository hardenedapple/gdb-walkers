.PHONY: test
test: demos/tree_debug demos/tree demos/list
	runtest --srcdir testsuite --tool gdb_walkers

demos/tree_debug: demos/tree.c
	gcc -g demos/tree.c -o demos/tree_debug

demos/tree: demos/tree.c
	gcc demos/tree.c -o demos/tree

demos/list: demos/list.c
	gcc -g demos/list.c -o demos/list

demos/cpp_structures: demos/cpp_structures.cpp
	g++ -g demos/cpp_structures.cpp -o demos/cpp_structures

clean:
	+rm demos/list demos/tree demos/tree_debug gdb_walkers.log gdb_walkers.sum
