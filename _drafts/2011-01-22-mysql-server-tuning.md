---
layout     : post
title      : "Notes: MySQL Server Tuning"
categories : [ddu2011]
tags       : [drupal]
location   : Brisbane, Queensland
excerpt    : |
  Some notes on Arjen's talk MySQL Server Tuning: not an optional extra.  
---

Arjen Lentz runs OpenQuery, a MySQL consulting company. 

What do these mean: scaling, tuning, resilience? What do we do about them?
"Designing for success, just in case."

Tuning Parameters
=================

InnoDB storage engine

- Never ever use the default the sample configurations.

- `default_storage_engine` = InnoDB
  - `innodb_buffer_pool_size` = `512M` (default: `16M`)
  - `innodb_file_per_table` = `1` (default: `0`)
  - `innodb_flush_method` = `O_DIRECT`
  - `innodb_io_capacity` = `400`
  - `innodb_log_file_size` = `64M` (default: `5M`)

- Should always be 64-bit: MySQL is multi-threaded, single-process so a 32-bit
  system will be able to use only 4GB of RAM. Given that some buffers are
  per-connection, you can run out of memory quickly.

- The default configuration stores all tables in a single tablespace file.
  These files will grow to many GB and cannot be shrunk. Using one file per
  table makes things more portable.

- MySQL stores data in files on the file system. The default configuration
  caches data in MySQL and *also* caches in the filesystem layer. (Note,
  though, that some SAN and RAID equipment seems to have problems with this
  setting and will be slower with this setting.)

- Using an enhanced build will give you the ability to tune the I/O capacity.
  What units this is in, I'm not sure.

- When performing an update, MySQL must have the data written to disk. If the
  logs are full then they have to be flushed before a write can be logged.
  Small logs result in lots of I/O, very often. (Note that you cannot just
  change this value, you must follow the procedure in the refman.)

You can migrate MyISAM tables to InnoDB using a standard tool which is
distributed with MySQL:

- `mysql_convert_table_format --type=InnoDB --user=root --password='secret'
  --force dbname` but note that mysql the system database *must* remain
  MyISAM.

----

- `myisam_recover_options` = `QUICK,BACKUP`
- `table_cache` = `400` (default: `64`)
- `key_buffer_size` = `16M` (or > `128M` if you use MyISAM)
- `read_buffer_size` = `2M` (default: `256K`)
- `read_rnd_buffer_size` = `1M` (default: `128K`)

- Make recovery in the case of unclean restart fail. Do a back of the files
  and try a quick restore.

- Number of tables that can be used at a time. That is: connections * tables.

- Try to give it enough to fit all the indexes.

- Increasing the size of the read buffer will make table scans faster. Per
  connections.

- For reading multiple rows at a time. Per connection. ?

- GROUP BY/ORDER BY - `sort_buffer_size` = `2M` allocated per connection when
  needed.

Temporary Tables

- `tmp_table_size` = `32M` (The size of temporary tables to create during
  queries.)

- `max_heap_table_size` = `32M` (The maximum size for temporary tables to stay
  in RAM.) Should be the same.

Connections

- `max_connectsions` = `200` (default: `100`)
- `thread_cache_size` = `200` (Keep threads when the connection is closed)

- In `php.ini` do not allow persistent connections:
  `mysql.allow_peristent_connections=Off`

Query Cache

Turn it off when there're lots of writes as they clear the cache. The easiest
way to turn it off is to set the size to 0.

- `query_cache_size` = `64M` (default: `16M`)
- `query_cache_size_limit` = `128K` (default: `1M` or higher)

Large queries are typically rare, don't bother to cache them.

Errors

`log_warnings` = `2`

Binary logs

- `log_bin` = `hostname-bin`
- `expire_logs_days` = `21`

Slow query log

- `log_slow` = `hostname-slow.log`

- `long_query_time` = `1`

- `log_queries_not_using_indexes` (Note that this will log queries that ignore
  indexes for small tables, use MariaDB to get extra options to specify the
  minimum number of rows before logging kicks in)

Resilience
==========

Prevention is better than cure. Don't rely on an SLA: insurance doesn't
prevent your house from burning down.

You need a backup strategy and it needs to be implemented. You need both
logical and physical backups -- they serve different purposes. Replication,
SANs/RAID are *not* a backup strategy.

Use multi-master for resilience and maintenance. Dual masters with MMM,
automatic failover; works with Drupal 6 (though some modules assume that the
first object PK is always `1` which isn't true anymore).

Replication slaves for read-scalability. Support in Drupal 7, helps make
read-dominated loads.

Master-master replication: don't do more than two. Relay slaves, backup
slaves, reporting slaves.

Monitoring
==========

MySQL doesn't degrade gently, things just break. You need to monitor servers
to pick problems up before your server explodes.

- See Zabbix.com and tribily.com for MySQL monitoring

----

Use the [MariaDB](http://mariadb.com/) fork managed by Monty, which includes
numerous extensions and improvements.
