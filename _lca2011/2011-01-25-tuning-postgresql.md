---
title     : Tuning PostgreSQL
---

Shoaib Mir, Fujitsu Australia.

Procedures for diagnosing performance problems
==============================================

In, I assume, no particular order:

1. Application analytics
2. SQL
3. Memory
4. Storage
5. File system
6. PostgreSQL configuration file

Application
-----------

What type of IO is the application doing on the database? Write heavy, reading large amounts of data? Bulk loading jobs? Analytical queries?

SQL
---

Use query analytics tools to identify long running queries. EPQA, pgfouine

Use `EXPLAIN ANALYZE` to debug slow queries, but avoid `EXPLAIN ANALYZE` with
DML style queries in a production environment. The output of `EXPLAIN ANALYZE`
can be confusing, but there are tools available to explain the explanation.

`EXPLAIN ANALYZE` runs a query and then tells you about it (so don't DROP,
DELETE, etc.)

Memory
------

Size of the database small to fit in RAM, DW like DB (get faster disks).

There's a contrib module for examining the buffer cache: `pg_buffercase`.

Query plans (using disk?) using the disk to sort is generally a bad thing. 

Storage
-------

What type of storage setup? Direct attached storage or a SAN? Unless your SAN
is tuned correctly, it's usually better to use direct attached.

RAID: usually recommend RAID-10 for write-heavy activity, RAID-5 slow with
parity.

iostat output and looking for waits and queue sizes. Use nagios, etc. to look
at them.

RAID controller settings: write-back cache, most battery backed these days,
monitor battery health.

Tablespaces can help distribute data across different storage. Start with
indexes and tables on separate disks, then maybe try transaction logs.

File systems
------------

They recommend using XFS due to its performance in benchmarking. Better
journalling. Doesn't support write barrier, so use `nobarrier` but make sure
you've got a battery backed disk controller.

Configuraiton
-------------

`shared_buffers`: allocated on database server start. Good base line is 25% of
RAM. Use `pg_buffercache` to monitor shared buffers and make sure there isn't
too much.

`effective_cache_size`: total amount of OS cache available to the database
server. Used in planning queries. Higher values result in more aggressive
query plans. ~75% of available memory (look for free and cached numbers).

`work_mem` is the amount of memory used for sorting operations (per session).
Avoid disk sorting (use `EXPLAIN ANALYZE` to check queries). Not easy to find
an optimal value.

`maintenance_work_mem` amount of memory used by DDL operations. Value depends
on the size of tables. Can be set per-session. Can improve performance of,
e.g., index creation by raising temporarily.

`autovacuum` thresholds for automatic analysis and vacuum on tables.
Thresholds can be tuned by lookingf at `pg_stat_user_tables`. Worker threads
introduced in 8.3.

`default_statistic_target` value for gathering sampiing stats for a table when ANALYZE is done. Should be set to 100 at least (default is 10 in 8.3).

`checkpoint_segments` number of files in `pg_xlog`

Benchmarking the database server
================================

Normally use Bonnie++ 1.96 to benchmark storage.

pgBench for database server.

Do benchmarks when setting up a new database server and keep doing them to see how performance changes.

Monitoring
==========

`iostat`, `dtstat`, `top`, etc.

`check_postgres.pl` plugin for database health monitoring

Nagios and Ganglia for trend analysis and alert monitoring.