---
layout     : post
title      : Distributed Storage for KVM
tags       : [lca2010, distributed, storage, linux, kvm]
categories : [lca]
location   : Wellington, New Zealand
excerpt    : |
  Notes on Kazutaka Morita's talk at the Data Storage and Retrieval Miniconf
  about Distributed Storage for KVM.
---

The third session I attended on Tuesday was at the [Data Storage and Retrieval
Miniconf][miniconf] about [Distributed Storage for KVM][talk] by [MORITA Kazutaka][km] from the Open Source Software Computing Group at NTT Labs.

[km]:
[miniconf]: http://www.lca2010.org.nz/wiki/Miniconfs/Data_Storage_and_Retrieval
[talk]: http://miniconf.osda.asn.au/proposal/75/sheepdog-distributed-storage-system-kvm

[Sheepdog][sheepdog] is a distributed filesystem for QEMU/KVM. Like Amazon
EBD-like volume pool. Highly scalable, highly available and reliable. Single
flat storage pool composed of many nodes, VMs can access their block device
image from any client node.

[sheepdog]: http://www.osrg.net/sheepdog/

No single point of failure, zero configuration, fully symmetric. Automatically
add/remove nodes. Similar to Isilon. Makes management

Goals
=====

Managed autonomously - audtomatic dara relocation and load balancing

Scale to several handreds of nodes - linearly scaler in performatna and cpaacit

privde hightlu available/reliablevolums
data is replicated to multiple nodes
lost data auto recover

support useful vol manipulation
spanshot, cloning, thin provisioning

Design
======

Not a general file system.
--------------------------

Simplified the design
API designed specific to QEMU
Cannot use sheepdog as a general purpose filesystem.
One vlume can be attached to only one VM at a time.

How to store volumes
--------------------

Volumes divided into 4MB objects
Each is id'd by globally unque 64 bit it, and replicated to multiple nodes.

[Figure](http://www.osrg.net/sheepdog/design.html#virtual-disk-image-vdi)

Objects are stored using consistent hashing to select nodes. 

[Figure](http://www.osrg.net/sheepdog/design.html#object)

Cluster management
------------------

*Corosyn* supplies reliable and total ordered multicast. Enforces message
ordering, presumably to

[Mentioned](http://www.osrg.net/sheepdog/design.html#vdi-operation)

Demonstration
-------------

One sheepdog server node falls over (or gets killed). The object map reflects
the lack of (sufficient) replication of the relevant objects and they are
re-replicated to remaining nodes.

Scalability
-----------

Using some benchmark I didn't catch, there is a graph showing Sheepdog scaling
linearly, compared to a shared storage technology (which scales super-linearly
initially before appearing to trend to sub-linear).

Questions
---------


QPL. 

May have said asynchronous? (I assume it is)