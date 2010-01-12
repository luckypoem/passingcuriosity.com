--- 
wordpress_id: 1381
layout: post
title: Graphviz, Dot, Large Graphs and Crashing!
wordpress_url: http://passingcuriosity.com/2004/graphviz-dot-large-graphs-and-crashing/
---

I came in this morning to discover that the Graphviz run with LCL005 consumed
some nine and one quarter hours of real time and was killed, I can only
assume, due to memory usage. Hacked up a simple C program to replace the shell
script in converting "^clause" lines from `runtime_data.dump` to 'dot'. It
removes duplicate parents, outputs them in ascending id order, etc. It's also
a lot quicker than the shell script.

One of the smaller problems (SET012) ran in a rather short amount of time, and
generated a graph that renders to 19616×809px in PNG. It will probably be a
good idea to keep working with this problem due to its smaller graph. GRP024
also runs much quicker than LCL005 (though it still takes quite a lot longer
than SET012).

Approaches may be:

* Assign explicit ranks based on the iteration the clause was generated in
  then try to find a radial layout filter;

* Have a `style=invis` central node, with edges to every other node, where
  each edge is weighted inversely proportionally to the iteration the clause
  was generated in (higher weights tend to shorter and straighter).

* Explicitly setting node ranks to the iteration number seems "cleaner" to me.
  Another alternative is to "declare" all nodes to be in clusters, then define
  the edges between them. It would then be possible to use the cluster ranking
  options to let Graphviz have more control over the layout.

Another problem is that the prover does not appear to be able to provide
enough information for my purposes. It does not appear to expose individual
events (clause creation and deletion) or any information on clauses beyond the
clause selected as "given" during each iteration.

### Later: ###

> I have added some code to the prover (and a flag to control it) that will
> output deleted clauses, though it does not (for reasons I have yet to
> determine) print a clauses ID. Once this problem is solved and the output is
> amended to output reasons for deletions, it should be possible to generate a
> data model for an animation, even if the animation itself is not yet
> possible.

### Later still: ###

> It looks like `proc_gen()` is breaking clauses before we get them. For
> example, the parents of a clause are printed (very_verbose), followed by a
> message "Subsumed by ?", then out "** DELETED" message no longer has access
> to the clauses parents. The problem was caused by using a copy of the clause
> that was made before being passed to `proc_gen()` which has the side effect,
> apparently, of adding the parents list to the clause structure.

### Even Later: ###

> A trace of proving the theorem SET012 with the appropriate options enabled
> (print_kept, print_deleted, etc) is 2.3M in total, of which all but 32K is
> useful event data.
