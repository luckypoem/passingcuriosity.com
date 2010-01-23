---
layout     : post
title      : "Linux Containers: virtualization without overhead or strange patches"
tags       : 
categories : [lca]
location   : Wellington, New Zealand
---

[Linux Containers: virtualization without overhead or strange patches][talk]
by [Sam Vilain][sv] from Catalyst IT at the [Systems Administration
Miniconf][sysadm]



[talk]: http://sysadmin.miniconf.org/presentations10.html#05
[sv]: #
[sysadm]: http://sysadmin.miniconf.org/

Warning
-------

miniconf grade talk: not huge effort in checking, but it should be reasonably accurate.

Lots of approaches:

- emulate everything
- hypervisor
- syscall
- application

scale between functionality and performance.

QEMU runs complete kernels ontop of complete kernels

Hypervisors have thin layer between hw and kernel (and other kernels)

Containers push this layer up as high as possible.

Terminology
===========

Container is the abstract entity. What `lxc` utilities deal with. A bunch of
namespaces whihc might have controllers attached to them.

Every `task_struct` knows their namespace objects; cloned via `clone(2)`

System calls fgo through the task_struct, and can provide "customised" results.

Eg. PID namespacesL processes with a particular namespace see private PIDs.

Eric Biedermann's brainchild.

Restricting a process
---------------------

chroot() changes /proc/self/root

Capabailities - de-fang root

FS namespaces 

UTS

...

Controllers
-----------

Inflences some sort of scheduler: CPU, I/O, etc.

Came from IBM?

Network controllers (TC), CPU controllers (CONFIG_CGROUP_SHED), memory
controllers (RSS, swap), I/O controllers.

VServer
-------

VServer restricts visibility of objects; namespaces make numbers distinct.

Entr mech: added later with ns's; need to use init+getty.

Let things use mknod (unlike vserver)

Can do different user stuff on FS (unlike vserver?)

Benefits
========

Flexibility of management.

Filesystenms, processes visible from host without stopping guest.

100% speed

100% lightweight - using facilities that the kernel would be using anyway.

Freezing, unfreezing - live migration, even between kernel versions. Because
namespaces allow using the "same" unique identifiers (by hiding the "real"
system level identifier), you can freeze stuff and restore it even on
different kernel versions.

Questions
=========

VServer allows you to `mknod` or not - if so you can mknod and own the box.
Containers uses a whitelist.

You said their is no such thing as a container per se. The bits that make up
the I/O layer can be used independently. `lxc` treats it as one piece (and
it's one system call), but you can take or leave bits of it.

Stability: 2.6.27 (or .28) onward should support this stuff. It's all part of
the normal kernel.

Supports all the Linux architectures because it's just normal system stuff.

Solaris containers don't do memory limits very well. 

Will it share pages (mmap, executable, etc.)

Suspending and moving. Because all of the numbers given to a process is
abstracted through the namespaces, you can save the memory segments and
mappings and the namespaces mappings and restore them lately.

How lightweight can you make a container to freeze? A single process, just by
passing a few options for `fork()`.

There seems to be a "not invented here" issue with containers in the mainline
versus VServer, OpenVZ, etc.

OpenVZ is a VServer fork which abstracts everything similarly to Containers.
But the patch is very big (~10 time larger than VServer). They got involved
with containers, contributed patches, etc.

Restrict permissions to devices, but they are the same devices.