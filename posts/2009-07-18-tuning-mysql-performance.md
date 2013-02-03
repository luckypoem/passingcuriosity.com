---
wordpressid: 1331
layout: post
title: Notes on "Tuning MySQL performance"
wordpressurl: http://passingcuriosity.com/?p=1331
---
[Trent "lathiat" Lloyd](http://lathiat.net/) talking about MySQL performance tuning. The slides are available on his [talks page](http://lathiat.net/talks).

<!--more-->

Default MySQL configuration
-------------------------------------

Use small amounts of memory (8-64MB) and then push stuff back out to disk. Small number of conc. connections/users, small temp. table sizes. *Very conservative.*

Show global status
-------------------------

"SHOW GLOBAL STATUS" returns 240 rows. 

* Com_insert (number of inserts run)
* Com_select (number of selects run)
* Connections (currently)
* Created_tmp_tables (temporary tables for joins, etc)
* Created_tmp_disk_tables (number of temporary tables it's put on disk)

Should have 1/10th reads to requests (i.e. 90% cache hits).

Settings
----------

`tmp_table_size = 64M` (def. 32M) `max_heap_table_size` (should be the same). 

`query_cache_size = 64M` (caching results based on the exact query text). Shouldn't be much higher or it will be slower due to overhead of flushing the cache every write. He's had 3-4 customers in last 6 months who've set this too high.

`table_cache = 1024` keep instances of tables instead of closing them. Avoids having to open, close, open, close, tables.

`max_connections = 200` each connections use 3-4MB. Too many open connections and your RAM is gone!

MyISAM or InnoDB?
--------------------------

*MyISAM*: non-transactional, no rollback. Not ACID. The original engine.

*InnoDB*: newer engine, transactional, can rollback. Actually ACID. Has higher overheads, as might be expected.

Can turn InnoDB's persistance to get consistency but much faster.

MyISAM uses a key buffer to cache the keys. `key_buffer_size = 1GB` (def. 8MB) to avoid accessing disc every query.

`innodb_buffer_pool_size = 2G` the buffer for both keys and data. Actually allocates this RAM at load. Based on RAM size: 0-75% of RAM.

Other stuff
--------------

There are tools which will analyse a config file and estimate memory usage.

See [Trent's web-site](http://lathiat.net/) for the slides, links, etc.
