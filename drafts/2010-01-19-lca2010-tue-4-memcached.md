---
title      : Introduction to Memcached
tags       : [lca2010, memcached]
categories : [lca]
---

Mark Atwood (Director of COmmunity Development at gear6) talking about Memcached.

Kind of difficult to memcached: sometimes it's to people who know it
intimately, sometimes not. This is probably a mix. 

What is it?
===========

High performance, 
OSS, 
distributed (lots of ), 
memory (no persistence, just goes fast),
object (it doesn't care what you store, it's just a blob),
cache.


How did we get here
===================

Persistent app server process

local variables

FS caches

DB query caches

SHM caching

Apache server fragment caching

Problem is none of these things scale out, all they do is make your single
machine go faster.

Scaling out: multiple machines access the same memcached server. Add more machines as required.

Why doesn't MySQL query cache
=============================

A hack to make poorly written PHP applications work. 

Under heavy write load it fails (invalidate on every write). Heave load ->
fails. More CPU count -> fails (contention on shared global cache).

Application Changes
===================

Application requirements

Before doing something expensive (computing, db query, etc) look in the cache.
If you need to do/compute it, put it in the cache for later.

When coding, think of places to use it
======================================

In perl/python, when you have a big dict/hash to keep track of work. Or a
highly used big lookup table. There are modules to "tie" memcache to your
language's dictionary API. If you're in C and wishing you had a dict, use
memcache. Rather than sharing memory, stick it in memcache.

Patterns
========

**Session**

Keep session state in the memcache.
Turn key for PHP and for Django. Just enable to module.

**Rate limiting**

It's easy to do on one server/process. Keep the access count in the memcache.
Key of $prefix.$soureip.$currtime value of access count. Use ADD and MGET to
increment and check to limit.

**SQL query cache**

**MySQL user defined functions**

Accessing memcache from functions within the database server. 

**Other things**

* HTML fragments.
* Image thumbnails.
* Message headers and/or bodies.
* Unread message lists or counters.
* Contact list.
* Work queues.
* API keys.
* Nonces.
* Gearman staged work.
* Data fetched from the web or remote services.
* Structured file read cache (Wafflegrid) InnoDB buffer pool expanded into
  memcache.

Question
--------

The latest version has a very early implementation of access control. 

Memcache competes with the nosql/key-value people on the basis of performance.
There are tools (in libmemcache) to wrap other key-value type services in the
memcache protocol. It's possible that memcached might die as a product but the
protocol live on as an access mechanism for other K-V systems.