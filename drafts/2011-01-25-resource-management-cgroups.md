---
title : Resource Management with CGroups
---

As hardware is getting more powerful, we've putting higher loads on boxes.
Cgroups provides an in-kernel feature to control resource management and
allocation (with libraries and tools to interface to them)

Resources like: CPU/-SET, memory, I/O, network, etc.

Great usecase: make sure `sshd` has higher priority for system resource
allocation so you can always log in.

Control group - trackerd and monitored

Memory resource controller

Cgroup scheduler.

I/O controller - designate the portion of I/O bandwidth (based on controller
queue depth)

Network controller - tagging with cgroups, used for shaping, etc.

Device controller for allowing access to specific devices. CPU sets to bind to
certain CPUs, cpuacct for accounting, etc.

Hierachical model: assign a process to a cgroup at start, then all children
inherit the cgroup. Allocation are per-cgroup, and cgroups are hierarchical
(e.g. `daemons`, `daemons/http`).

Command Line tools
==================

cgexec to start a process in a cgroup

cgclassify to "move" a proc.

`cgcreate`/`cgdelete` to add/remove cgroups.

CGroups and VMs
===============

Limit VMs to never exceed:

  group virt {
      memory {
        memory.limit_in_bytes = 3.5G;
      }
      cpuset {
        cpuset.cpus = 1-3;
      }
  }

  CGROUP_DAEMON="memory:/virt"

`cgred` is another daemon manages cgroups for users and groups.

Look at: RHEL6 docs, Fedora overview, Zonker at ServerWatch, Using Cgroups on
Debian.
