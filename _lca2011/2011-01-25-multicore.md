---
title       : Multicore and Parallel miniconf
tags        : [multicore, parallel]
categories  : [lca2011]
location    : Brisbane, Queensland
excerpt     : |
  Some notes from the multicore and parallel miniconf.
---

Verifying Parallel Software: Can Theory Meet Practice?
======================================================

Paul McKenney – CTO Linux, IBM.

Linearisability imposes a number of limits that cannot, even in principal, be
evaded. Non-linearizable algorithms are theoretically "faster".

Linearizability makes things simpler to analyse and verify, it applies much of
the time, it's something of a hammer (great for nails...) But it's not always
the right tool: with small, critical code paths the reduced complexity may not
be worth linearisation; code that interfaces with the outside world it can be
useless (network routing tables are the poster child); for stats gathering it
can be useless and expensive (if you're counting, does order really matter?)

Don't want it:

- extreme real-time response bounds (two mutually dependant primitives: you're
  either slow and nonlinearisable or nondeterministic).

- Non-strongly non-communtative algorithms.

- Planetary motions.

One of the ways to tolerate non-linearizability where we need it is to make
use of some of the approaches used in hardware. Also: splitting into separate
components.

We need to rethink the idea of "correctness criteria". Linearisability is a
property of a system, not [necessarily] a correctness criteria. Properties are
properties.

Would you trust a bridge designed by someone who doesn't understand the
properties of concrete?

Potential tools: partitioning, batching, sequential execution, pipelining.

Non-strongly non-commutative algorithms.

Questions
---------

**Vint Cerf**: Is there a relationship between linearisability and asynchrony
(dataflow machines, petrinets)? Non-linearisable algorithms are better able to
exploit potential speedups from them.

Have we made much progress dealing with state space explosion in the last few
decades? Hardware people have truly massive state spaces.

Can we use hashing? Parallelism has a very small number of data structures
that scale well (hashing is something of a default).

Is this whole thing assuming that we're using shared memory? Pretty much.
Shared memory is lower latency so you can be (and often are) higher grain
parallelism.


In Search of Transmission Capacity – a Multicore Dilemma
========================================================

Vinton Cerf – VicePresident and Chief Internet Evangelist, Google.

The speaker does not really know anything about computer architecture and
hardware and may not have any ideas worth discussing.

Many types: MIMD, SIMD, pipelines, map/reduce, natural parallelism
(cryptanalysis; many diverse, small tasks like indexing). Big issues:
intermediate data movement, pre-computation structuring. Which of these
tactics applies to a problem varies.

Notions
-------

Putting more cores on a multicore chip isn't terribly helpful unless you can
get the data in and out of them? Given the very low cost now, perhaps low
utilisation doesn't matter as much any more.

Using on and off-chip interconnects. Using optical methods (anecdote about
DARPA suggestion about free-space optics: processors inside a sphere squirting
light at each other). Someone saw something from HP about using fibre optics
for busses. One of the main benefits is with layout (non-interference of light
vs conductors).

What do data centres look like? 400,000 square feet, 2 megawatts, cooling;
they are truly massive. Memory and processing integrated together, massive
interconnects (40Gb/s). Perhaps we should be exploring more ways to do this
type of thing on smaller scales: embedding memory and processing together on
the chip (if you can use it, this is where FPGAs will kill CPUs every time).
The Erlang people have also done things to localise process data.

Google research about allocating jobs to machines based on data locality:
turns out first fit is pretty much it.

Algorithms designed to reduce power consumption. There's the transmission
algorithms in mobile technologies; an ANU research group instrumenting
machines to benchmark implementation power use; turning off functionality.
Low-powered and high-powered components to be switched out: CPUs, GPUs, etc.
Using fast-but-inaccurate analogue processor to approximate result, then
refine it with a slower digital processor. Is it feasible to use FPGAs that
reconfigure themselves with power requirements?

Recent quantum entanglement effect (head hurting), etc. Perhaps some of these
demonstrable effects operate through some of the additional dimensions. Yes,
superluminal communication is technically impossible.

Role of FPGAs? Has had much more impact in mobile (decoding hardware), in
general purpose computers it's hard to find functionality that would be worth
its weight.

Using GPUs to offload computations. The big problem is the problem that was
raised earlier: getting the data on and off.

Hacks
-----

Sony Playstation 3 supercomputers.

Thing like *@home* computation: SETI search, folding proteins, cracking DES,
etc. These types of solutions work because these tasks are naturally parallel:
the tasks can be divided, in some senses are *already* divided.

Using human beings as part of a parallel distributed processing system. Like
reCAPTCHA.



Is Parallel Programming Hard, And If So, Why?
=============================================

Paul McKenney – CTO Linux, IBM.

First experience with large-scale parallelism: five toddlers, the parents
seemed to spawn threads to deal with situations as needed (happens often with
that many little kids). There's probably strong evolutionary pressure to
naturally being able deal with concurrency.

Also in team sports (all the other players, other teams, refs, etc.); teaching
(an entire classroom of students); construction (keeping track of everything
going on); drivers (collision avoidance); air traffic control (controlling
many planes). Humans deal with this sort of stuff regularly.

OTOH, just being able to *act* concurrently doesn't imply that we can
naturally *programme* concurrency.

He's done: network simulation, parallel UNIX, AIX parallel Linux kernel, Linux
UNIX kernel.

Why is parallelism getting such a big issue now? Moore's law: clock rate
growth now changing to growth in number of cores. Economics: once cost
multiples of a house, now cost fractions of a used car. Then you needed a
really good reason to use multi-processors, but now it can now be used
everywhere as a matter of course. But, there's an acute shortage of people who
can deal with parallel programming.

We've seen this before in this industry: the "Great Software Crisis":

- 1960s: "low-cost" computer systems cost more than $100K.
- 1970: Minicomputers cost $25K
- Late 1970s: microcomputers cost << $1K

We solved this with popularisation letting large numbers of people learn how
to do it.

Three classes of attempted solutions
------------------------------------

**The Good**

- Orders of magnitude improvement in productivity.
- Orders of magnitude increase in the number of people able to use it.
- Preferably both.

Spreadsheet, presentations software and word processing software.
Computer-aided engineering (a summer worth of work in a weekend).

Note that these are all up toward the application level.

**The Fad**

- Lots of excitement at the time, but long forgotten.

An amazingly large number of long-forgotten programming languages.

Lot's of "low level" things.

**The Ugly**

- Was in use then, still in use now.
- To ugly to die.

The C language, `sed`, `awk`, `perl`, Visual BASIC.

Previous software crisis. US military put research psychologists on the case
and they found that two classes of people can reliably trained to programme:
mechanics and musicians (women helping the war effort were assigned based on
preference: cooking -> chemistry, sewing -> electronics). This making/fixing
and creative feeds in.

We need to think of things that fit into "the good" (or the "to ugly to die").

What's hard about programming?
------------------------------

Based on talking to people who *can* programme but don't like it:

1. People expect anything that seems intelligent to have common sense.

   Marketing as tools, not intelligent. Eliza, etc. not withstanding.

2. People expect intelligent beings to understand their intent.

   Using in situations with intent is implicitly known. GPS, browsers,
   autopilots, etc.

3. People expect to be successful despite fragmentary and incomplete plans.

   Get the computer to do the planning: logic programming, automated theorem
   proving, scheduling.

Points (1) and (2) don't have much to do with parallelism, but (3) is applies
to parallel programming at least a little more than programming in general.

What has worked in the past
---------------------------

Apprenticeship approach: pair a newbie with an experienced programmer and
they'll pick it up in a few months.

Learn from existing parallel open-source projects: Linux kernel, PostgreSQL,
Samba, ... Find one that matches your problem.

Exploit embarrassing parallelism: transform your problem into an embarrassing
one it you need to?

Take validation seriously, from the ground up.

Work out what you need up front: if serial approach is fast enough, ignore
parallelism. Avoid the trap of N+1: don't make it work on one and then aim for
two.

Make sure you have a solid core of experienced engineers: you don't want the
blind leading the blind!

Make sure all engineers have access to parallel hardware and understand it's
capabilities. Access to all source code is essential as many problems will
likely touch diverse areas of the codebase.

Patterns for success
--------------------

Let it be someone else's problem: push the parallelism into a database, queue
system, etc.

Treasure trivial solutions: partitioning like map/reduce.

Stick with single threaded code: if your application runs fast enough on a
single processor, then leave it be.

Traps and pitfalls
------------------

Single-threaded design, code, and APIs: lots of patterns like singleton are
cheap and easy in single-threaded code but cause bottlenecks; ordering
guarantees (can be very hard to enforce in parallel); stop-the-world
processing; global locks; etc.

Sequential team, but no available experts? There's training options available,
open source to learn from, etc.

Avoid having only one of something on the fast path: avoiding contention is
important.

Software janitors: you'll need staff that can maintenance parallel software.

Parallel PHP with HipHop
========================

Looks pretty cool: http://openparallel.wordpress.com/

Parallel Programming - an Overview of Non Mainstream Languages
==============================================================

Lenz Gschwendtner - Team Leader and Open Parallel

Learned parallel programming scaling up a website to handle large traffic.
Came up with a backend that scaled, message passing, etc. in perl. You can
scale that stuff and come up with interesting solutions, but eventually found
Erlang - a language designed for network-bound concurrent programming. Will
cover: functional programming, high-performance computing systems, "reborn" or
"undead", but not an expert in many of the things he's talking about.

Languages teach us to think: knowing additional languages can give you another
mindset, another way to approach.

Functional Languages
--------------------

Many functional programming languages spanning nearly whole history of
programming languages: IPL, Lisp, ML, SML, Haskell, OCaml, F#, Scala, Prolog,
etc.

Lisp: memory management and garbage collection.

ML: influence on many important languages. Grew out of an automated theorem
proving system. Also use garbage collection rather than manual (or other)
memory management. Pretty much dead, successor are SML and Caml (mostly
O'Caml). The most recent member of the lineage is Microsoft's F# language, has
been driving some uptake of functional languages (or, at least, programming).

Erlang (1986): share-nothing architecture, use message passing. Makes it
interesting to scale: doesn't make a difference whether you use one VM,
multiple VMs on one machine, or many VMs spread across many machines. The VM
scales (approximately?) linearly up to around 32 cores. Not good at linear
problems but generally very high performance with parallel. Syntax is most
common criticism (hoorah for Prolog heritage). Real functional language:
higher-order, tail call elimination.

Haskell (1990): strongly types, pure, etc. Also lots and lots of parallel
features.

Scala (2003): gaining popularity due to high-profile Web 2.0 people and
frustrated Java guys trying to find a way that sucks a bit less. Tight
integration with the rest of the JVM ecosystem.

Clojure: pretty much a lisp on JVM. Design from the ground up to be
concurrent. Supports STM, immutable data structure, 

[rust][] (2010): easy to use general programming language that's hard to fuck
up.

HPC
---

Challenge from DARPA for High Productivity Computing Systems: want a language
for high-performance *and* high-productivity. IBM with X10, Sun with Fortress,
Cray with Chapel.

X10: enforced locking protocol from parents to children.

Fortress: blend of FORTRAN with Scala, Haskell, etc. Different displays for
researchers (who are used to typeset maths) vs programmers (used to code).

Others
------

roarVM (2008): many-core VM based 

prolog

[rust]: https://github.com/graydon/rust/wiki/