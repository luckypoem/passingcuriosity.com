---
layout : post
title  : Non-ACID transactions in MySQL
---
From the MySQL 5.0 documentation <http://dev.mysql.com/doc/refman/5.0/en/commit.html>:

If you use tables from more than one transaction-safe storage engine (such as
InnoDB and BDB), and the transaction isolation level is not SERIALIZABLE, it
is possible that when one transaction commits, another ongoing transaction
that uses the same tables will see only some of the changes made by the first
transaction.

What this means of course, is that MySQL's implementation of transactions may
not, in certain circumstances, actually be transactions. And that this failure
of atomicity will happen silently and that it's up to me to remember whether
or not I need to be careful when using any given set of tables.

I thought that they were supposed to have fixed the "it's not a real
relational database" problems in MySQL? Because if transactions don't ensure
ACI_ and the storage engines don't ensure the ___D, then what's the point?
You've got a store that is not necessarily internally consistent, never mind
consistent with external systems...