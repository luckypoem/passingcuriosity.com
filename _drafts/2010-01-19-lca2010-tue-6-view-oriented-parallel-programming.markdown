---
layout     : post
title      : Notes on View-Oriented Parallel Programming
tags       : [lca2010, parallel, programming, ]
categories : [lca]
---

[View-Oriented Parallel Programming][talk] by Zhiyi Huang from the Universtity
of Otago.

[talk]: http://multicorenz.wordpress.com/2009/11/29/miniconf-abstracts-and-bios/

Working on parallel programming for about 20? years. This is their recent
work. James focussed on share everything, Lenz talked about message passing.
This is something between the two extremes.

Parallel comuitng is inevitable.

The essence of parallel is multi-tasking, which we naturally find trivaly easy. Parallel programming, though, seems fundamentally difficult, generally due to tool issues.

The criteria for cound PP paradigms:

1. Easy to understand the model.
2. Easy to use the paradigm.
3. Enable high performance. Otherwise, why bother with it?

MPI, for example, can very easy to understand, but implementations can be
difficult to use, debug, etc.

Two fundemenatl issues:

1. Time: synchronisation, ordering, scheduling
2. Space: mutual exclusion, data race

One issue can often be converted into the other: MPI converts the space issues
into time (the shared memory converted into a slower message passing
mechanism).

Two forms of IPC
================

Message passing

- Easy to understand, difficult to use, enable high performance for dist mem
  syst.
- MPI

Shared Memory

- Easy to use, but sometimes difficult to understand.

WTF?

SM-based PP problems
--------------------

Data race: concurrent access to locations resulting in inconsistent access to
data. Debugging is very hard, because they are not usually repeatable.

*Transactional memory*: a good potential soluction byt has performance
problems with heavily contended resources. Still have races (avoiding STM),
difficult for distibuted.

*View oriented parallel programming* is a framework that van be implemented
for both shared and distributed memory, and integrate with transactional or
locking.

View-oriented parallel programming
----------------------------------

in VOPP shared data are partitioned into non-overlapping sets of data. When
some data needs to be shared between processes, need to create a view:

- consist of data objects that are always processed as an *atomic* set in a
  programme (all or nothing).
- can be created and destroyed at any time (also merged).
- each has a unique identified.
- use primitives like `aquire_view` and `release_view` when accessing. Can be
  ameliorated with compiler support.

The idea is language independent.

Example
-------

Producer/consumer problem:

{% highlight c %}

view_malloc(1, SizeofView, flag);
C = acquire(1)
Produce(X)
release_view(1);

aquire_view(1);
Consume(1);
relase_view(1);
{% endhighlight %}



Advantages
----------

Easy to use - enforces consistency of shared mem.

Easy to understand, the mental model is simpler than locking, since VOPP only
concerns programmers with partioning and access, insted of races and mutex in
lock-based prog.

Performance enabling - finely-tuned paritioning can make hings fast. Competes
with MPI on distributed performance.

Philosophy
----------

Shared memory is a crit res that needs used w/ care in PP - shared mem/cache
will be a bootlenexk in multi-core, contention. Don't use unless nec. then
create a view.

Race free
---------

Partitioned, use views to guarantee mutex on data that *must* be shared. Use
the memory management system to enforce the views mechanism - get page faults
if trying to go around.

Deadlock free
-------------

Composite view of views. Nested v azquisition is unn essary and probitbied 

Deadlock avoided by acquiring the primary views in the same order.

Transactional memory can be used to avoid deadlock as well. "Just" rollback
clashes.

Protability
-----------

Hiding the diffs of mem arch within the view : diffs in cache, shm, dist mem are hidden. Have implemented on clusters, etc.

Enables optimal implementations for specific architectures hidden within the
abstraction.

Advanced classes:

single writer, composite view
produces/consumer view
atomically operated view
multiple write view - handle, detect races
transactional memory view - avoid deadlock

Implementations
---------------

VODCA - OSS fort Linux clusters released in 2006. vodca.org

Matotai a COPP imp on CMT computers like Niagara 1 and 2. Source available by
request.

Cluser - 128 Itanium 2 proces running Linux connected w/ INfiniBand (Tsunghua
Univ).

VODCA and MPI get very close performance (though VODCA is slightly less
scalable in number of processors). 

VOPP outperforms OpenMP, MPI on Gauss (after about 8 CPUs).

A bunch of other results where VOPP performs at least as well as OpenMP, MPI,
often being more scalable as well.

Conclusion
----------

VOPP prov effective way to regulate IPC.

Race and deaflock problems are removed by VOPP

Good fromwork to integrate locking mechanisms and/or transactional memory.

VOPP performs well on shared memory and distributed system.