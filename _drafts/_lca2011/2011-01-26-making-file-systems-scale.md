---
layout      : post
title       : Scaling the Linux Kernel
categories  : [lca2011]
tags        : []
excerpt     : |
  Notes from Theodore Ts'o's talk on scaling the Linux kernel.
---

*Making file systems scale*. Theodore Ts'o, Google.

Back to 2001
------------

Linux 2.4 was released

IBM announced $1B investment

Linux had SMP, but it barely scaled to 4 CPUs.

SMP is expensive, and CPUs were still quite slow (compared to the overheads of
SMP). The coordination of SMP with shared memory access, cache coherency
(announcements of writes, snooping on the memory bus, etc.). The interconnect
is critically important for system performance (using techniques like NUMA to
"cheat" and add locality of memory and CPUs - breaking the symmetry - will
make things faster, but is very complex and hard to get right).

The bottom line is that a system with 4 CPUs is more expensive than 4 systems
with single CPUs. It pisses customers off when they buy hardware that doesn't
"work properly".

Measuring Scalability
=====================

Run one or more benchmarks on a single CPU system: Volanomark, FSCache,
Netperf, SpecWeb99, SPEC sdet, IOZONE, TPC-C/D/H. Need to make sure that the
benchmarks

Then run the same benchmarks on an *x* CPU system.

S = (*x* CPU system / 1 CPU system)

Scalability is really hard: on some benchmarks, 75% might be really good
(12/16 CPUs) when the system cost much more than 100% of the single CPU costs.

At the time Linux 2.4 barely scaled to 4 CPUs and was even slower than a
single CPU system on some benchmarks.

Linux Scalability Effort spearheaded by IBM's Linux Tech Centre with a bunch
of other companies participating. Weekly conference calls (minutes still
available on lse.sf.net). Doing regular benchmark measurements meant that it
was possible to observer results, set goals, etc. Find and fix the
bottlenecks. 2001-2003 this was being done regularly, then they declared
victory and everyone went home (except SGI who kept going with specialised
Altics stuff).

Scalability around 2003-2004 was not perfect, but pretty good. Scaled to 6-7
out of 8 CPUs on most benchmarks. Scaled to at least 12 out of 16 on many.
Scaled acceptably to 32.

Linux succeeded wildly on x86, but not necessarily on other platforms. People
who're spending $100Ks on Sparc or Power servers tended to prefer the other
"legacy" OS's (at least in the enterprise market). Then, few x86 servers had
more than 8-16 CPUs, so less need to scale beyond that. Linux was king of
scale-out computing (lots of web-heads running Linux).

Not much happened on the scalability happened for the next 4-5 years. Linux
started to be used in embedded and mobile markets. CPU freq stopped doubling
every 18 months and started growing more cores instead. Scalability is
starting to matter again: 4 socket servers and 8 cores on each socket...

It's time for kernel developers to think about scalability and application
developers to start thinking about multicore support.

File systems
============

For a long time, ext3 had "good enough" scalability. Many x86 loads didn't
push the file system because there were a lot of other bottlenecks in the way
first. Lots of enterprise databases do direct IO on pre-allocate files (the
one case ext3 is really good at).

Ext3 doesn't do well in head-to-head benchmarks, but most sysadmins don't care
about that due to the excellent tool support, etc.

Ext4 Scalability
===============

Spending 90% of time in spinlocks (2/3 journal start, 1/3 journal stop).

If you're doing multithreaded code using lots of locks document:

- For each field: which lock is supposed to protect that field.
- Locking order.

The functions were taking the two locks for the super-block and the
transaction.

Transactions are expensive, so you'd group operations into a single
transaction and commit every 5 seconds, etc. Each operation is bracketed by
start and stop calls.

Removing unnecessary locking
----------------------------

`stop()` was taking a lock protecting fields it wasn't using. Immediate
improvements. HP run benchmarks on a large system and increased throughput a
lot and decrease CPU slightly. Also used `lock_stat` to record lock activity.

More
----

Lots of places where it was taking the locks just to update a statistic and
accounting. Most of these can be changed to atomic variables rather than
mutex.

Use read/write locks for a lot of places.

This changes the profile: journal locks no longer most expensive (now in block
I/O layer). What's left is going to be really hard to fix: when the
transaction starts getting full, need to stop it and start a new one which
means waiting for everything on this transactions to finish.

Also: the way writes are submitted to BIO layer 4K at a time. Spend all this
time merging stuff into a single transaction only to chop it up into 4K writes
(which had to merge them again).

On that workload, on that hardware, for the first time ever ext4 was beating
XFS (but they've leaped ahead again). But there's still a bug that will cause
data corruption, so it's disabled.

Summing up
==========

We do need to pay attention to this stuff again. 

A lot of this stuff works in user space too: `atomic_t` if you import headers,
pthread mutexes, don't use spinlocks.

Valgrind drd tool to find data races. Lennart Poettering's mutrace tool to do
lock logging.

Questions
=========

Using `atomic_t` variables (for stats) didn't have a significant effect on
single thread. Don't expect removing them to have too much of a performance
effect. MySQL? suggested no atomic and call it an approximation.

Slowness on ext3 (from MySQL guys?): concurrent direct IO writes, stop the
world `sync()`.

Why not just go with XFS: there are certain applications where ext4 is still
better. Google uses it because they can turn off the journal (multiple copies
on multiple systems, don't care if the FS borks). If you have RAID and need
the I/O bandwidth then XFS might be the right solution for you.

Benchmarking makes work like this possible: time coding was dwarfed by time
benchmarking.
