Memoization generalises the idea that a program can learn from experience and
automatically improve. Memoization reduces the amount of time required for
learning by preventing rework.

Old architecture: 6us read/write, 12us add, 260us mult.

Memoisation techniques trade space for time. The factorial and fibonacci
functions are pretty bad examples for memoisation.

Evaluation: strict (applicative order, call by value, call by reference)
non-strict (normal order, call by name).

# Example: Letters and Numbers

Given a list of numbers, a target and a set of operators, generate a list of 
applications which get as close as possible to the target.

Using enumeration and search contains plenty of redundancy. Use a trie to
memoise and reuse results for sub-problems. The complex data structure (and
its garbage) means that the problem is still combinatorial (what does this
mean? are we talking about space/time complexity?)

> Not much difference between bad memoization and a space leak.

Memoisation can impact the semantics of your language (I/O, etc.)

Use memoisation on recursive problems with shared intermediate results.