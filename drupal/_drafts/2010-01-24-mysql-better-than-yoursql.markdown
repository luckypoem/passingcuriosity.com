---
layout     : post
title      : MySQL > YourSQL
tags       : [drupalsouth, drupal, mysql, database]
---

Make it better: InnoDB = no more lost data. Transactions. D7 will use InnoDB
by default.

Done? No: the default MySQL default configuration is generally pretty shit.
There are bunch of settings `default_storage_engine`,
`innodb_buffer_pool_size`, `innodb_log_buffer_size`, `innodb_log_file_size`,
`innodb_file_per_table`, `innodb_flush_method = O_DIRECT`.

http://cafuego.net/2009/10/10/mysql-yoursql