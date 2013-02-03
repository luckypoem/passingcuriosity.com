---
layout     : post
title      : Using performance counters to optimize task placement on multi-core systems
tags       : [lca2010]
categories : [lca]
location   : Wellington, New Zealand
---

[Using performance counters to optimize task placement on multi-core
systems][talk] by Bharata B Rao from IBM's Linux Technology Center in
Bangalore.

[talk]: http://www.lca2010.org.nz/programme/schedule/view_talk/50328

Share some of the experiences and results from optimising schedulers and work
placement on multi-core systems.

Modern platform characteristics
-------------------------------

Dual core system. Each core has two threads, a single L1 and a single L2. The
chip has a single L3 cache. The threads that share L1/L2 cache are a sibling
domain and the cores that share an L3 are a cache domain.

Architectures differ (POWER5 and POWER6 share L2 caches between coresœ as well).

Lots of workloads benefit from share caches through shared data. You can wind
up with contention on shared caches though. You thus often see both shared and
private caches to try and trade off the drawbacks and benefits.

C2Cbench - measures data transfer rate between producer and consumer threads.
Try run the threads on different cores in a cache domain. Then in different
cache domains, then calculate transfer rate. 6.4x faster within cache domain
versus between chips.

ebizzy benchmark (web app server workload simulation; reproduces a problem
encountered in an e-business company?). Take 4 instances: best case runs each
instance in a different cache domain (get ~1.6M records/s); worst case runs
without binding and has lots of cache contention (get ~600K records/s). Very
cache intensive application.

Task placement problem
----------------------

Two packages, each with two cores.

Mapping T1, T2 which are memory intensive (cache intensive) and T3, T4 which
are CPU intensive to the cores.

T1+T2 / T3+T4 is sub-optimal, contention in C1, under-utilisation in C2.
T1+T3 / T2+T4 is better, less contention, less under-utilisation.

Goals
-----

* Arrive at optimal task placement at run time. Shouldn't need hints from the
  admin or programmer.

* Should use extenrally observed task characteristics.

* Should detect and respond to changes to these characteristics during the
  processes lifetime.

* Should also honour the (other) goals of the scheduler (power, etc.)

Task placement optimisation layers:

1. Power-optimisation layer - how many cores do I need to run for this
   workload?

2. Fairness optimisation layer

3. Contention optimisation layer - how to I place the tasks on the CPUs to
   reduce contention.

Characterising tasks
--------------------

Either CPU hungry or memory hungry. Use per-task performance counters metrics to use cache misses, instructions retired and cycles to classify tasks.

* Memory hungry - cache misses

* CPU hungry - instructions retired and cycles.

Four derived metrics:

1. CPU demand is instructions retired * scaling fact / cpu clock cycles

2. Memory demand is cache misses * scaling fact / cpu clock cycles

3. CPU pressure sum of cpu demands of all tasks in a SMT/sibling domain

4. Memory pressure = sum of all memory demands of all tasks in a CPU/cache
   domain.

CPU pressure based load balancing between different SMT domains; balance tasks
to equalise CPU pressure between domains.

The goal is to equalise the CPU pressure and memory pressure between the
various domains by pulling tasks to low pressure domains from high pressure
domains. Don't factor NUMA into these discussions yet, just cache memory.

Results
-------

4 single thread ebizzy instances + 8 cpu hogs on 2x2 quad core machine. 12
tasks, 4 memory hungry and 8 are not. Two cases: default scheduling and memory
pressure balancing. Seemed to achieve 2x throughput in 1,2,3 instances of
ebizzy, but not so drastic improvement w/ 4 instances.

Another test with 2x VPR 2x GZIP. Binding 1 each per domain is ideal,
incorrect or without has little effect on GZIP and poor throughput on VPR, but
memory pressure scheduling improves VPR drastically (as opp the two).

kernbench (`make -j4`) (1.5s longer in elapsed time patches vs no patches).

Conclusion
----------

This is still very experimental work, but does demonstrate that there seem to
be potential gains here. 

Don't currently work very well with the load balancing.

Haven't done CPU pressure balancing yet.

ebizzy, speccpu, etc.

Questions
---------

When you have a multithreaded program, one might have dirtied a line that the
other thread wants resulting in a cache miss. This is a case which benefits
from shared caches, but this work is focussing on workloads that do not
benefit. The goal is to leave scheduling in these cases alone.

There's been a lot of work lately in using performance counters to guide
scheduling decisions. This is part

The patches will ideally allow you to use `perf` from user space. Currently,
being experimental, there is a clash and `perf` will get confused. The kernel
will be using at least 3 counters for each tasks.