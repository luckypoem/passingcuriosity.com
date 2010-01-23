---
title : PostgreSQL Development Today
---

Josh Berkus.

It's a very interesting time to talk about PostgreSQL development because
we're in the middle of the final commitfest for PostgreSQL 9.0. 

Wait what? Isn't this 8.5? A lot of 9.0 stuff that wasn't expected has landed:
Hot standby, streaming replication, Windows 64, DO(), new LISTEN/NOTIFY. So
this is 9.0.

Process
=======

PostgreSQL have been grappling with the development method/process lately. Had
a real problem with 8.2 dragging out 6 months after schedule. Biggest issue
was management of committer and reviewer time: scare committer time. Tom Lane
(alpha committer) doesn't want to spend 70 hours a week for 3 months reviewing
patches.

Now: review patches faster, review patches sooner (before they bitrot), review
every patch (don't miss any), scale up.

Every other month, clear the patch tracking tool: a commitfest. You can see
what's getting in, what's not, etc. Good place to find stuff to help with?

8.5/9.0: 4 commitfest/development period cycles, cleanup (integration a
review), beta, etc.

Hot Standby
===========

Simon Riggs single largest feature contributor for the last three years. 

8.0: Point in time recovery (PITR). Binary transaction log for recovery, but
it also contains everything you need to restore a server (possibly elsewhere).
First take a snapshot of the server, then accumulate the logs (in a secure
location), and you can replay the logs into the copied server.

This is much faster than normal `psql` backups, but much too slow for
failover.

8.3: introduced warm standby. Copy server, copy logs to a secure location, but
apply them as they are copied. This lets you fail over in a few seconds. But
this is a second hot machine, but it can't handle connections. This is
expensive.

Problem with transactions (everything is transactions): every operation (even
a read) is allocated a transaction ID (XID). It's not a readonly copy if
you're allocating XIDs. Instead allocate "ghost" XIDs for reads.

9.0: two years of effort to add support for readonly queries against the hot
standby. 

`conf/postgresql.com` (write ahead log stuff) use `archive_command` to `rsync`
or `cp` the logs. `recovery.conf` use `restore_command` to run `pg_standby` to
import the logs as they arrive. Everything else is pretty much as default.

`select pg_start_backup('hs');` tells PostgreSQL to make things safe to copy.
then `select pg_stop_backup();` to tell it to keep going. Then start this
newly copied slave and it'll be in readonly mode? One of the things is that
your replication is happening by copying log files: whatever your log timeout
is dictates the delay.

Problems with Hot Standby
-------------------------

It's a form of binary replication, but there are some things that mess this
stuff up (like VACUUM). Introduce `max_standby_delay` to allow the mirror to
stop performing updates and accumulate logs while a query that might get
broken by the update.

NTT have different problems:

1. must not loose any data, ever, no matter what
2. seconds of downtime (or less)
3. Single-node performance
4. Scalability: not an issue

Two developers at NTT developer a synchronous replication thingo, but it was
based around the way NTT use PG. 18 months of work turned is into "streaming
replication". 

1. Copy master, then start the slave as before
2. Slave starts `walreciever` which connects to `walsender` on the master
3. `walsender` sends transactions to `walreciever`. 
4. Copy logs as before and use them to catch up if the slave gets behind.

Turn `standby_mode` on and give it the connection details in `recovery.conf`
on the slave. Start the slave and it will automatically apply any logs that
are available, then connect to the master as above.

Binary replication solutions fix some of the issues with logical replication
(i.e. schema changes can be difficult/awkward).

