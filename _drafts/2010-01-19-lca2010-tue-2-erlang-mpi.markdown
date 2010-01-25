---
layout     : post
title      : Erlang, MPI, and Open Standards
tags       : [lca2010, erlang, mpi, json, architecture]
categories : [lca]
location   : Wellington, New Zealand
---

The problem
-----------

Shared state, shared data, waiting for other processes.

Reading (w/ several backends) is usually not a problem (modulo out of date
data due to sync delays). Writing to multiple backends is often a problem.

Boils down to a problem of global locking. You often never realise how many
global locks until you try to parallelise it. When you try splitting it up,
you do notice.

Sounds familiar?
----------------

Not about solving this global lock problem. Actually about chopping a system
up into discrete components.

Iteration One
=============

Tries to solve:

1. Scalability issues - was running well onto a very good server that it
   outgrew.

   It wasn't possible to put it on a bigger machine and the obvious stuff (db
   server) was already done.

2. Asynchronous processes with a wide range of workloads (return in short
   times to literally days later)

   1. Queues
   2. Callback queues

Wrote a simple perl based environment with own message queue, own binary
message format, worked fast. 

End result was a cluster of servers running daemons with shared message
formats and routing.

First time taking it apart, decentralising, message driven architecture. First
time away from typical software development approach (i.e. creating a single
monolithic system).

Start with a few big daemons, but start seeing parts that could be split out.
Wound up with something like 20-25 daemons. 

Results
-------

Wound up writing a complete message passing infrastructure (MPI). Was perhaps
a little naive, but it worked (millions transactions).

Erlang
------

Worked with it for a while before finding Erlang. A functional PL with a few drastic approaches

* Functional programming language

* Built in message passing infrastructure

* Share nothing (very, very, very hard to share between processes). Instead
  uses message passing to communicate between processes (being functional, you
  can even send *functions*)

Once you're over that first step of "this is really weird", it's a really nice
language and environment. You don't have to think about processes any more as
the VM abstracts away pretty much everything. No need to worry about same VM,
other VM, other server distinctions with messaging: it's all very simple.

Issues
------

Not compatible with existing stuff. Feeling the pain of custom protocol.
Options are writing an compat layer, or rewriting.

Erlang can't be used here, but started playing with CouchDB, RabbitMQ,
ejabberd instead.

Playing with CouchDB for a while and currently use it in production. A
document datastore. Map-reduce approach to a key-data store.

RabbitMQ is a messaging queue running AMQP (A??? Message Queuing Protocol). 

ejabberd is a big fast Jabber/XMPP server. 

They are all big Erlang based server for open standards. All have very low
requirements compared to perl, PHP, etc. Having the VM to make that large
interpreter overhead (20+ perl interpreters!), but without having enormous
requirements like a JVM.

The more he played, the more he wished he could use it.

Iteration Two
=============

Avoid throwing away *everything*, but do it "right" this time.

AMQP - open standard, 2 (+?) OSS implementations, used in a few pretty big
players.

RabbitMQ.

Using JSON rather than XML. Open format, used by many, small footprint, easy
to use in multiple langauges (and human readable). Also: avoiding costs of
doing own binary protocols.

Erlang: compared to perl/php/ruby/... scales linearly to 32 cores, you don't
need to do anything "special" for multicore - just write normal Erlang. If you
need more power and can't scale in more boxes, you can scale in CPUs.
Distribution is very very easy, just push a BEAM file.

Still using perl for some stuff that it's good at.

Language independent
--------------------

Using AMQP and JSON makes it easy to integrate with pretty much any language.
Libraries for most languages/platforms, open standards.

Multicore Programming
=====================

Similar challenges to Internet programming:

* scaling to many servers
* load balancing, etc.

Can't just fun on more CPUs (as with servers). 

@norbu09

Questions
=========

Gearman seems to try to solve the same problem? There are many projects that
do, it's a personal choice.

Erlang syntax and string processing: any efforts to improve it? There's no
need to "improve" it, you just need to learn it. Part of the benefit of MP
architectures is being able to use the right tool for the job (perl for string
handling, for example).

Did you look at Google Protocol Buffers rather than JSON and XML? Not really,
JSON and XML are available in nearly everything, and JSON has a bunch of
things emerging on top of it.

Facebook chat intrastructure. Not based on ejabberd, but a bunch of Erlang
servers with serve long-polling HTTP connections. The backend is Erlang/C
which pushes message between 