--- 
wordpressid: 1391
layout: post
title: The end is nigh. Or at least in sight.
wordpressurl: http://passingcuriosity.com/2005/the-end-is-nigh-or-at-least-in-sight/
---

The end is nigh, or in sight, depending on which way you look at it. There are
only a few weeks left of the summer scholarship program, and a lot of work
still to be done.

On the other hand, a meeting with my supervisor (John Slaney) today has
reassured me that I'm not doing as badly as I had expected, and when you look
at the graphs I've been drawing on a large scale, you can see why. The matrix
style diagrams display a number of features that clearly illustrate properties
of the system, and the problems being solved.

In the SET012 problem, we can clearly see repeating patterns which may be a
graphical reflection of the symmetry of the problem (from Set Theory and
regarding some relation between sets and another). Another interesting feature
is a number of peculiar 'gaps' in the graph where large numbers of factors are
generated consecutively. One of these gaps is several tens of clauses wide.

Also clearly visible are sloping vertical "lines" (in reality they are just
adjacent points). This appears to be caused by the method used by the
reasoning system. To generate new clauses from a given clause, the system
attempts to unify it with the clauses in the usable set. This process
traverses the list of usable clauses in reverse order which, for given clauses
that unify with a large number of usable clauses, gives the appearance of
sloping lines.

Other noticeable features include the appearance of a number of short
horizontal "lines", strangely regular patterns, patterns that appear to be
interrupted then continue and some patterns that bear a small resemblance to
the Game of Life and other cellular automata. I'm about to start working on
adding some useful features to help give some more meaning to the graph.
Unless I have a stroke of genius, this will probably be restricted to
colouring the nodes (to easily differentiate factors, given clauses, etc) and
highlighting those nodes that form part of the proof.

When these features are added in (hopefully be tomorrow or early next week),
I'll move on to dynamic exploration. Some form of "zoom" function whereby
those parts of the graph not in the immediate vicinity of the cursor are
scaled down may be useful due to the rather long horizontal axis. Another
feature that I'll have a go at implementing is a "cross-hair" on the cursor to
allow the user to view other relations involving the node/s they are
interested in, trace across to row and column labels, etc. Another possibility
is to have the system display the text of a clause, the method that generated
it and other possibly interesting data.

All in all, there is too much to do, and too little time.
