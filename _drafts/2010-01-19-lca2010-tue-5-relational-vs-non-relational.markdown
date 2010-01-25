---
layout     : post
title      : Notes on Relational vs. Non-Relational
categories : [lca]
tags       : [lca2010, database, relation, nosql, requirements]
---

The fifth talk I attended was about *Relational vs. Non-Relational* by Josh
Berkus (PostgreSQL Experts Inc)

It's hard to keep track of all the non-relational (and even the relational
database projects out there). This is about evaluating and choosing which to
use and which of which.

Myth busting
============

1. "Revolutionary database design". There are **no new database designs**.
   There are new implementations, certainly, but the last new design (from his
   view) was streaming databases circa 2000. 
   
   Obviously there is great value in new implementations.

   (1) Quoted CouchDB, 2007 (application friendly, attributes, ad-hoc
   indexing, blah, blah). Also Pick, 1965.

2. NoSQL. There is no NoSQL movement. This is the wrong definition: just
   because it doesn't use SQL, doesn't mean that it works the same as another
   non-SQL database. 

   There's an enormous diversity: memcache is nothing like BerkelyDB-XML.
   Multi-value, Document, etc.
   
   Relational Databases are not all the same: embedded, OLTP, MPP, streaming,
   column-store

3. Need relational for transactions. Non relational DBs with robust
   transaction: BerkeleyDB, Amazon Dynamo. Relational w/out: MySQL MyISAM, MS
   Access.

   Generally, relational databases tend to have more mature transactions. E.g.
   Most of the current effort on Cassandra is on implementing their
   transactions.

4. Most people look for one database to rule them all. You should not be
   looking for one DB that does everything: you won't find it, it's not
   possible.

   Instead we should be looking for the database system that fits the
   requirements of the system. Or, more commonly now, use a combination: MySQL
   + memcache; PostgreSQL + CouchDB (semi-structured data in CouchDB, then do
   dynamic discovery, then summarise or report into PG).

   Or use a hybrid. MySQL NDB (NDB is distributed object store database, but
   people generally use it with MySQL on the front-end so that they can do SQL
   over the object); PostgreSQL Hstore (upto 1GB key-value store in a field); 
   HadoopDB (using PostgreSQL as a datastore on Hadoop).

How do I choose?
================

**Relational OLTP** (mature ones, anyway)

* Transactions: tend to be supported and mature
* Constraints: enforce data rules absolutely
* Consistency: enforce structure 100%
* Complex reporting: keep management happy
* Vertical scaling (but not horizontal)

**SQL vs. No-SQL** SQL promotes:

* Portability
* Managed changes over time
* Multi-application access
* Many mature tools

No-SQL allows:

* Programmers as DBAs
* No impedenace: no separate languages
* Fast interfaces: no protocols
* Fast development

Main reason for SQL-RDBMS is data lifetime: you expect the data to outlive the
application.

**Embedded Key-Value DBs** 

* Simple, small
* Memory constrained, emedded
* Store many objects very fast on a single node (but don't need complex data
  access)

**Dis K/V Stores**

* Availability Uber Alles (consistency not that important, scales to 100s)

**Multi-value/Object databases**

* Probably better than an ORM
* Most access by OID
* Multi-dimensional data access
  - good reporting within original design
  - works well with CUBE, compression
* Data is not shared...?

**Document DBs**

* semi structured ata (get it in first, sort the wheat from the chaff later;
  schema design by discovery)
* data mining
* simple slow replication

Conclusion
==========

Diff DB systems are better at different things. Every feature is a tradeoff.

Relational vs non-relational doesn't matter: pick the system that best fits
the requirements of the system.