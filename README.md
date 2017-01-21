# GDB configuration files

Contains all the helper python commands and functions I've written for myself.

# NOTE -- this repo and README are under flux
Everything here is subject to change, at the moment the README is pretty much
just a collection of tricks I want to make sure I don't lose the ability to do
when working. (i.e. this is the place where poorly formed tests go).


# Tips & Tricks

Use `$count += 3, true` as one expression in `follow-until` or the like to get
useful side-affects.
This is why it splits on the semi-colon (that, and to emphasise how it's pretty
much just a for loop).

## Many ways of counting to ten

```
(gdb) pipe follow-until 1; {} > 10; {} + 1
(gdb) pipe array char; 1; 10
(gdb) pipe follow-until 1; {} > 100; {} + 1 | head 10
(gdb) set variable $count = 0
(gdb) pipe follow-until 1; {} > 100; {} + 1 | if $count++ < 10
(gdb) set variable $count = 0
(gdb) // The below differs from the above because the iteration is cut short.
(gdb) pipe follow-until 1; {} > 100; {} + 1 | take-while $count++ < 10
```

## Other tricks

foldl can be implemented by using side-effects (I know ... that doesn't quite
fit together right does it?)

```
(gdb) set variable $sum = 0
(gdb) pipe follow-until 1; {} > 100; {} + 1 | eval $sum += {}, {} | devnull
(gdb) print $sum
```
