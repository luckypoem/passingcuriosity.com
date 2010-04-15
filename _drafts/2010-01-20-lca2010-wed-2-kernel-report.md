---
title: Seven challenges for the kernel community
---

Seven challenges for the kernel community by Jonathan Corbet. 

1. Vitality
2. Scalability
3. Storage
4. Visibility
5. Response
6. Containment
7. Hardware

Vitality
========

Andrew Morton: "Famous last words, but the actual patch volume _has_ to drop
off one day. We have to finish this thing one day." just under 4k, up to
routinely 10k-12k per version.

2.6.28 to .33-rc3 (roughly a year)
55,000 changesets by 2,700 developers at 320 [known] employers.
grew by 2.8 million lines
144 sets, 7330 lines of code every day.

At least 75% of the code coming in comes from people who are doing this as
their job. Lots of companies that 

2.6.28
------

GEM graphics memory manager (for GPU memory) - Begining of the end of a
multiyear project to get support for 3D graphics into the kernel.

ext4 lost experimental status

Code in the mainline kernel develops much more quickly than stuff in other
repositories. Thus introduced the staging tree to get this stuff into the
mainline kernel.

Wireless USB

2.6.29
------

Kernel mode setting. Other half of the 3D graphics story.

Filesystems - btrfs (later), squashfs (read only compresses)

WIMAX support

4096 CPU support

2.6.30
------

TOMOYO Linux (mandatory access system?)

Integrity measurement (using trusted computing, boot up and verify integrity
of the system) Useful for trusted systems (ATMs), but also anti features.

R6xx/R7xx radeon graphics support

Nilfs

2.6.31
------

Performance counter support for low level performance monitoring

Char devices in userspace

Kmemleak - mark and sweep GC techniques to find and debug 

TTM (Radeon version of GEM) and Radeoon KMS support. More 3d

Storage topology to help understand

2.6.32
------

Block scalability work

Performance countrer improvements

Scheduler ineractivity wirj

Jernsl SHM

HWPOISON



2.6.33
------

Dynamic ftrace

DRBD distributed storage device

I/O bandwidth controller

TCP Cookie Transactions (better scalability with lost of conns, resistance to some DoS)

Nouveau driver (they weren't expecting to merge here) reversed Nvidia graphics support.

Consensus
---------

Tokyo summit a few months ago: it's working pretty well and there's not that
much to improve.

Participation: cooperatively-developed resource. It only works if we all work
together.

Mike ??? leader of Google's internal kernel group. He talked about the
approach that they taken: improving and stabalising on an old kernels. They
are trying to move forward, but it's heaps of work because they have 12000?
patches. 30-ish engineers. They've realised that this is probably a bad idea
and are moving to more open approach working with the community and mainline
kernel.

Scalability
===========

Your phone may have two CPUs

Destoopes heading toward 8

Srrvers can have 32

Mnster systems have up to 4096.

Work
----

Workqueue code restructuring

Multieuque networking - drive high end network adaptors from more than one
CPU.

cpumask reworking - change status struct. CPUs grew, woldn't fit on stack

Problems
--------

`dcache_lock` - scalability problem on heavy I/O loads, realtime.

Networking - can druve 10G at wire speed. But only with large packets. Things don't really work very well with lots of small packets ()

Solid state storage devices. 100,000 operations/second no the horizon (vs 100
operations/second on rotating media). The block layer is going to be looking
more like the networking code. Adding interrupt mitigation code in block layer
was taken directly from the networking code. Will get more stream lined.

Scaling down 
------------

Scalability works both way: up to large systems and down to small ones.

[Bloatwatch plot](http://www.selenic.com/bloatwatch). The amount of resources
required to run the kernel is growing, but it's still slower than hardware
progress. Want more input from embedded space.

What's happening
----------------

Storage devices are getting large, but not always faster

Usage patterns are changing (was lots of small, not lots of large)

ext4
----

Bettwe perf.
Many limits liftes
Still ext3 compatabile.

Still stabilising but generally works quite well. Some distros are using it
but enterprise won't be deploying it for a while yet.

This is still something of a stop gap.

btrfs
-----

Totally new using a newer developments

* Better performance
* Full checksums of data and metadata
* Snapshots built in
* Internal volume management / RAID

Fedora 13 might be including a feature: snapshot before an update and roll
back if you don't like it.

Went in 2.6.29, still very experimental. It'll be quite some time before it
can be viewed as stable and ready for production.

Solid-state storage
-------------------

Rotating media is dying (well, not really)

Also present some challenges

Poor performance (especially over time)
Badly specified or implemented commands (TRIM)

Visibility
==========

Looking into the state of the system and seeing what's going on. What do we
want to know about our system, even our producton systems. Where should we be
focussing our optimisation
How can we shut up the smug DTrace fans?

SystemTap
---------

dyn tracing facility. Looks like DTrace, has some more features. 

Complex and difficult to use, reqs lots of anc data, disconn w/ kernel comm.

1.1 a few days ago.

Ftrace
------

Merge just over a year ago. Developed with kernel developers in mind. Pop w/
kdevs.

Lots of static tracing options, dynamic tracing in 2.6.33 (insert new trace
points w/out rebuilding the kernel.)

There is a lot of action going on here.

Perf Events
-----------

Was Perfcounter subsystem. 

Access to performance monitorung registers. Useful for low level opts.

Integrated with tracepoints to become central statistics collection facility.

Lots happening in this area.

Response (realtime)
===================

Deterministic response times, not just speed. Real time vs real fast. This is
require in embedded and devices (including Linux based Yamaha keyboards, TVs).

Also used in high-end financial trading platforms. There is lots and lots of
real money at stake. We can crash our financial systems much more efficiently
than every before.

RT preemption patch set. Deterministic realtime for linux. Large out of tree
patch.

Lots has gone into mainline:

* Threaded int hand
* mutexes
* priotiy inheritance
*Lots of latency reducation patchs

What's left:

* Sleeping spinlock (precursor work into 2.6.33)
* Problem areas (atomic kmaps, per-CPU variables)
* Big kernel lock removal (must come out, perople are working on it)

Deadline scheduling
-------------------

Realtime ppl like to talke about deadlines rather than priorities.

Thus deadline scheduling: three params:

* how much work (long to take)
* when by
* how often

Deadline scheduler can guarantee to fulfil by refusing jobs it can't meet.

SCHED_DEADLINE in the words, but lots of fetails to deal with yet.

Containment
===========

Two approaches that we see applied in Linux (and elsewhere):

1. Virtualisation - apparently isolated system, heterogeneity
2. Containers - homogeneity

Virtualisation is pretty much solved. There's performance and user space
management stuff and some Xen code to come in.

Virtualisation memory management:

KSM (kernel shared memory, now renamed) - scan for and share identical pages
between guests 2.6.32

Compcahe - swap out memory - to memory. Compress on way out, to get much
better utilisation. 2.6.33

Transcendent memory.

Containers
----------

In progress: namespace isolation. Draw boundaries around every single user
visible resouce. Multi-year project. 

In progress: resource controllers.

Longer-term: checkpoint/restart. Save state of container; restore later, maybe
elsewhere. Difficult problem. Secure against manipulation of files, kernel
changes.

Hardware
========

Used to talk a lot about hardware, but most of the problems have been or are
resolved. Nearly universal support, wider than almost any other system.


Graphics was the big bug bear, but this should be pretty much over by the end
of the year.

Network adapters: same old uncooperative vendor problems (fewer but they still
exist). Best answer is avoid them.

Questions
=========

Inclusiveness in the kernel developers group. Looking from the outside it
seems pretty difficult for new developers to become accepted. This is always a
concern and is something that we should be thinking about. Any process which
takes contributions form 2,700 developers can't really be *too* exclusive.
Giving classes, talks, papers on contributing; making LKML friendlier; but
there's more we can do. The core group does tend to be a bit cabalish.
Honestly, though we do fairly well.

Regressions, especially for old hardware that becomes less able to test. They
are definitely an issue that they try to find and deal with, but it's very
hard in the case of hardware. Generally though, hardware that people care
about will continue to work (report them!)