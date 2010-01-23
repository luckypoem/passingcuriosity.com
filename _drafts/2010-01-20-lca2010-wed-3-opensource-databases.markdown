---
layout     : post
title      : Survey of open source databases by Selena Deckelmann
tags       : [lca2010, databases]
categories : [lca]
---

[Survey of open source databases][talk] by [Selena Deckelmann][sd]

[talk]: http://www.lca2010.org.nz/programme/schedule/view_talk/50332
[sd]: http://www.chesnok.com/daily/

Which database will solve your problme.

2005: 

BerkelyDB: venerable k/v store from 80s
MySQL:
PostgreSQL: '80s, OSS in '90s
SQLite: around 2000

2010:

More and more and more and more OSS dbs. She found about 50 with going
communities, documentations, etc. Wouldn't be surprise if a new one was
announced during the talk.

MySQL vs PostgreSQL
-------------------

A favourite, but difficult to answer without asking "what are you trying to
solve".

I need to store and manipulate GIS data: PG

I need a DB for my blog: MySQL (by default)

I have ONE BILLION users to store and analyse data from.

For PostgreSQL, the goal is to be a replacement for Oracle.

And also: *performance*, your use case, test with real data.

Interoperability
----------------

Can I get my data in nd out of the database? How painfiul is it? 

Sustainability
--------------

How is the software being made? Is it sustainable, are they getting outside
commits, building a community?

No database solves all these issues, you'll probably be working with a
combination.

Chart: stead number since 1986, now enormous. 

Survey
======

25 projects, 12 responses. Not a professional surveyer.

Lots of questions

> Name?
Describe in a sentence or two.
Who is target user or audience? Case studies?
...
Use RCS?
WHat motivated you?
Roadmap for next year.
Commm supprt?
Lang frivers and/or protocols? Up to date?
Need help with partic drivers?
Some question I shold have asked?
What features set you apart from your peers?

And I did my own research
=========================

Three means of comparison:

1. Database model
2. Infrastructure features
3. Dev style

Models
------

How data is stored and what 

Relational

oltp - transaction processing
embedded - simplicitly
column - warehousing
mpp - massively parallel
streaming - query streams, not storage

OLTP : CUBRID (Korea, OSS in 2006, MySQL replacement), MySQL, PG
Emb : H2, HSQLDB, (both forks of hypersonic?) SQLite
Column: MonetDB, LucidDB, C-store/vertica, Cassandra, Hbase

Non-relational

Flatfile : See Tin (so small removed y from tiny)
Key-value : map-red, fail tol, cache
Multi-value: multi-dimensional - GT.M
Graph (inc. triple) : relationship queries
Document-oriented: semi-structured data

KV : Bdb, cassandra, hbase, memcache. riak, redis, tokyo, ydb
graph: Neo4j, 4store, Oarliament
Cod: CouchDB, BerkeleyDB-XML, MongoDB

This key-value space has to collapse eventually; there's simply too many
projects with too few differentiation.

Infrastructure
--------------

"Distributed"

Part./sharding : cassandra, hbase, voldemort, riak, mysql
Replication : BDB, CouchDB, Cassandra, MySQL, PG, Riak, Scalaris, Voldemort, ...

Rep: Syn/Async, Master/Slave, Multimaster

Memory vs Disc
--------------

In mem: memcaches, scalaris, redis, SQLite
Configurable: cassandra, hbase, hypertable, mnesia
Disk: everyone else

High Availability
-----------------

Node failover: Cassandra, HBase, Riak

Otherwise, use one of more of: heartbeat, DBRD, file system replication, etc.

Sustainable open development
============================

Code development model
----------------------

Code + modules: Drizzle, LucidDB, PostgreSQL
Monolithic: GT.M, Ingres, CUBRID
Infrastructure: Memcached, Redis, Scalaris

How the accept requests, etc.

Protocols (Redis chose not to implement memcached protocol)

Community Development Model
---------------------------

Benevolent dictator: Redis, XtraDB, MckoiDB
Feature driven (wait for req, rpt): Apac Derby, InfiniDB, SmallSQL
Small group: Couch, Monet, Riak
A mix: LucidDB, Drizzle, H2, PostgreSQL

Fewer people working on benev dict. Featur driven projects are less active.
Small groups tended to be from a company releasing internal projects. Then
"those are way to restrictive", which might be a sign of a mature projects.


Plans for the data
------------------

Intended to update Wikipedia.

Talk to people who write real surveys.

Contact more projects as only contacted 25 projects, and only so many
responded.

http://ossdbsurvey.org

The Future
==========

Protocols
---------

Some systems are implementing each other's protocols.

LucidDB, H2 both implemented the PostgreSQL protocol, Sphinx implemented MySQL
protocol and Tokyo Tyrant/Cabinet supports memcached proto

"Memcapable" certifies memcached implementations.

Need automated, repeatable tests for complex systems. Verifying that
replication works and does what it says is a complex task.

More people connections between projects. The Java world, for example, is kind
of "over there".

Talking to each other
---------------------

Databases talking to each other. Thrift came out of Facebook; a tool for
connecting systems together.

ThruDB: fascinating tool. code.google.com/p/thrudb/


Questions
=========

Many of the databases had SQL implementations: did you find anything about SQL
dialect compatibility? Not really, it's already been looked at pretty well and
has been documented.

How many of the new project are churn? Many, perhaps the majority of the
projects in the relational space are forks of current or dead projects. It's
pretty hard to find information because those that got to the "make a website"
stage usually kept going.

Have you seen any signs of consolidation at this point? The bigtable and
amazon papers had enough details that people have been using them as specs for
their own implementations. Everyone who needed one started their own project
and open sourced it. Yet to see much consolidation.

Didn't ask about OO vs pure relational databases.

There are a few practitioners here today. We didn't schedule a BOF (though
there is a MySQL one) but it would be nice to have a get together here.

The most amusing/big/fun project you've worked on with OSS databases.
Implemented a "cow say" module in PostgreSQL. `SELECT cow_say("Moo");` State
government in Nigeria chose to implement OSS, sent to PG hackers list "hey,
who wants to go to Nigeria" so she went and spent a week with developers (from
proprietary .Net backgrounds). Now using PG to store bunch of largely
demographic information, used for welfare type projects.

Didn't ask about licenses, but did research it. Many projects were dual
licensed, generally as a funding model.

Lots of forks of MySQL at least in part because MySQL never became a real open
source community project. 