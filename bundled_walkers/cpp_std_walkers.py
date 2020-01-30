'''
Contains walkers for the C++ standard library.

Since the implementation is not a part of the standard and subject to change
without notice, the walkers in this file are inherently unstable.

NOTE:
    If you're interested in using these walkers you may be better served by
    using the `pretty-printer` walker to use the pretty printers defined by the
    libstdc++ community.

'''

import gdb
from helpers import eval_uint, as_uintptr
import walkers
from walker_defs import Terminated

# TODO This doesn't import at the moment.
# Figure out exactly why, and what to do about it.
# from libstdcxx.v6.printers import StdMapPrinter
class StdMap(walkers.Walker):
    '''Walk across the nodes of a std::map.

    NOTE:
        This walker takes the type of the map from the expression given.
        If the map is not of the same type as the expression given there may
        very well be problems.

    Usage:
        gdb-pipe std-map &m | show print *$cur
        gdb-pipe eval &m | std-map | show print *$cur


    '''
    name = 'std-map'
    tags = ['data']

    def __init__(self, start_ele):
        # TODO As of yet I haven't figured out exactly when the auto-load
        # python scripts are loaded, and when this script is loaded.
        # I do know that this file is loaded before the auto-load scripts,
        # because I can't import this at the top level.
        # That is why this is imported here.
        # In the future I want to import this at the top level, after figuring
        # out the order that gdb does things in, and hopefully figuring out a
        # way around it.
        global StdMapPrinter
        from libstdcxx.v6.printers import StdMapPrinter
        self.start_ele = start_ele

    @classmethod
    def from_userstring(cls, args, first, last):
        return cls(cls.calc(args.strip()) if first else None)

    def _childiter_to_nodes(self, children_iter):
        while True:
            try:
                _ = next(children_iter)
            except StopIteration:
                break
            try:
                _ = next(children_iter)
            except StopIteration:
                raise IndexError('Uneven number of items in map!!')
            yield children_iter.pair.address

    def _iter_from_ele(self, start_ele):
        map_value = start_ele.dereference()
        printer = StdMapPrinter('std::map', map_value)
        children_iter = printer.children()
        return self._childiter_to_nodes(children_iter)

    def __iter_helper(self, element):
        yield from self._iter_from_ele(element)

    def iter_def(self, inpipe):
        yield from self.call_with(self.start_ele, inpipe, self.__iter_helper)
