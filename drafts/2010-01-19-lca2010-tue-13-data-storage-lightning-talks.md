---
---

Bucardo
-------

Replication for PostgreSQL. Named after a goat. DML triggers on every
replicated table to send.

Master/slave replication, light weight (slave doesn't need any triggers).
Slave is writable out of the box.

Master/master replication. Need to do your own conflict resolution. 

No smooth DDL. Schema changes mean shutdown, perform changes, restart.

In production at a large e-commerce site. 1500 transactions per second. About
7 years. Need help.

