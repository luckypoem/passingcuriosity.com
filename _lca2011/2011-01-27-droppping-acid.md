---
layout      : post
title       : 
categories  : [lca2011]
---

Dropping ACID: Eating data in a Web 2.0 Cloud world. Stewart Smith, Rackspace
(formerly Sun, MySQL).

Drizzle: database for cloud.

Eat my data: how everybody gets POSIX file I/O. Most programmers cannot write
a file safely to disk. It turns out that computers sometimes fail.

`close()` and `rename()` do not imply `sync()`. Apple `fsync()` does not sync.
POSIX standards don't help. (`fsync() { return 0; }` is POSIX compliant).

Not everything is simple in POSIX apps.

Modern web: many parts, some of it written by monkeys. Modern cloud: many,
many, many parts. Some with dubious care for your data (and, also, written by
monkeys).

ACID: atomicity, consistency, isolation, durability.

CAP (guers? theorem): it's impossible for a distributed theorem to provide all
three of consistency, availability and partition tolerance.

RDBMS
=====

MySQL/MariaDB: InnoDB (reinventing MyISAM is not a feature). `COMMIT` is
commit to disk, consistent (MVCC) and referentially integral (constraints).

Eating data (in RDBMS'): asynchronous replication, what do you do?

1. Convert to read only until you bring master back up.

2. ...

3. Slave promotion. So you've committed on the master, master fails, slave is
   promoted, data is gone.

Doing synchronous replication is generally slow and makes fault tolerance
difficult (on MySQL Cluster, `COMMIT` means the transaction is in memory on
multiple nodes, but the cluster itself will be consistent).

Semi-synchronous replications: commit to local disk but don't return success
until a slave has it too. But you can't bring masters back up.

Drizzle is working on a bunch of things including moving the replication
logging into engines to save on `fsync()`s (was around 4 per transaction).

NoSQL
=====

Theory: implementations are the problem, not relational databases (and SQL).

"Map/reduce functions in Erlang" vs "writing SQL queries" in hiring.

Being able to ask "have you tried turning it off and on again?" MySQL,
Drizzle, PostgreSQL all do this to a greater or lesser extent.

Reliable, deterministic recovery.

MongoDB is web-scale, but nodes are not crash safe. Think of it as ext2 with
sync disabled.

Cassandra
=========

Log structured, OLTP, eventually consistent.

