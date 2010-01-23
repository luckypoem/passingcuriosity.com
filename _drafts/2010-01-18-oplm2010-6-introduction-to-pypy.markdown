---
layout     : post
title      : An Introduction to PyPy
categories : [lca]
tags       : [lca2010, oplm2010, python]
location   : Wellington, New Zealand
---

[Michael Hudson][mh] from [Canonical][can] giving an Introduction to PyPy. He 

Introduction
------------

PyPy is an implementation of Python in Python. It's also grown into a
framework for implementing dynamic languages (interpreters). An an open source
project. In 2005-07 it was funded by the EU.

PyPy can produce a binary that looks very much like CPython to the user. It supports some, but not all, extension modules - socket, mmap, termios...

Can produce binary for CLR and JVM.

It can also produce binaries with more features (stackless, etc).

Motivation
----------

PyPy grew out of a desire to modify/extend the *implementation* of Python,
rather than the language itself (which was the focus of the community at the
time).

Increase performance (JIT, etc)

Ease of porting

Problems with CPython
---------------------

CPython is fine, but:

It's writtein in C which makes port to e.g. CLI hard.

Things like psyco and stackless are hard to maintain as CPython changes.

Big Idea
--------

Take a description of the language. Analyse this descriptions and decide:

whether to include stackless/JIT
which GC
which platform.

Now:

1. Spec of Python.
2. Translation/compiler framework.
3. A Python customised to your platform/environment.

How specify?
------------

Write Py interp in RPython - a subset that is amenable to static analysis.

This allowed to run it on CPython and, thus, do unit testing, etc.

Compiler
--------

The compiler takes as input live Python objects.

It abstractly interprets the bytecode of the functions to produce flow graphs.
Performs more analysis and gradually reduce level abstraction. Finally C or
other source code is generated.

When implementing, only expected to feed it their Python interpreter. Then
realised that this applied to many other [dynamic] languages. There are
implementations of Prolog, Squeak, JavaScript, etc.

The LxOxP problem
-----------------

One of the meta goals, ameliorating the so-called LxOxP problem: given L
languages, O platforms, and P implementation decisions, we don't want LxOxP
different implementations. 

Currently working on the second JIT implementation. First worked but was
"completely crazy": transformed the control flow graph of an interpreter into
that of a compiler. This sounds like a Futamura projection to me.

The new one does tracing like tracemonkey and tamarind. It finds "traces" -
frequently executed sequences of bytecodes. Once identified as "hot" a trace
will be recorded and machine code generated and used in subsequent calls.

Status
------

Build PyPy and you get something that looks like 2.5.2. 2.6 should be
reasonable easy, but it's not particularly interesting and this is a research
project.

You also get a `__pypy__` module that lets you know about the current
interpreter.

Depending on what you're doing you can wind up with slower than CPython to
20%+ performance increases.

Stackless is used for EVE Online - each client connection is a stackless
"thread". Good for many tens to hundreds of thousands of "threads".

Three backends: C/POSIX (Linux is best supported), CLI (.Net and, hopefully,
Mono), JVM (pretty much any JVM).

JIT performance is variable. Int bashing is very fast with the JIT (50x faster
than CPython), bad ones are twice a slow as CPython. Supports ia32 (amd64 is
on the way). You can also (in an [experimental] branch) JIT to CLR which Mono
or .Net will then JIT to native.

Sandboxing
----------

You can use PyPy to build an interpreter which passes all system calls through
a monitor process to implement sandboxing and other security features.

Future Work
-----------

JIT JIT JIT: making it more practical: generate faster code, reduce or cap
memory usage.

Better platform integration with, e.g., JVM and .Net.

Questions
---------

They use the Richards simulation framework benchmark, Django's template
engine, PL shootout and a bunch of other stuff for the bench marking along
with a bunch of fairly normal Python benchmarks.