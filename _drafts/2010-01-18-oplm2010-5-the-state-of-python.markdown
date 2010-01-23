---
layout     : post
title      : The State of Python
location   : Wellington, New Zealand
categories : [lca]
tags       : [lca2010, oplm2010, python]
excerpt    : |
  The fifth talk at the Open Programming Language Miniconf 2010 was The State
  of Python by Richard Jones.
---

The fifth talk at the [Open Programming Language Miniconf 2010][oplm2010] was
[The State of Python][talk] by [Richard Jones][rj]. Richard presented a
somewhat meandering collection of things that people should be aware of.

[oplm2010]: http://blogs.tucs.org.au/oplm/
[talk]: http://blogs.tucs.org.au/oplm/programme/#python3
[rj]: http://mechanicalcat.net/richard

First, Richard gave a very brief overview of the **20 years** since Python
development began in December, 1989. Version 0.9.0 was released in February
1991 and version 1.5.2 (purportedly known as "ye olde faithful") was released
in April 1999. Around the middle of 2006 the ideas that were floating around
about "things we ought to think about fixing maybe at some point" began to
solidify. Python 3000 was branched and [PEP 3000][pep3000] written. Version
3.0 was released in November 2008 and version 3.1 followed soon after in June
2009.

[pep3000]: http://www.python.org/dev/peps/pep-3000/

There are a lot of changes in Python 3.0, many of which are not backward
compatible. A lot, though, are niggles that have been the subject of
complaints for years. Some of the most visible changes (i.e. those which will
break the most code) include:

* `print` and `exec` are now functions rather than part of the syntax.

* More functions and methods in the standard library (`map`, for instance)
  were changed to return iterators rather than lists.

* All text is now Unicode. As a result, many I/O operations have been changed
  to return bytes rather than strings.

* Exceptions raised while handling an exception will "know" the original
  exception. This makes it possible to write more useful top-level exception
  handlers. 

* Still on exceptions, string exceptions are gone: they're all objects now.

* While we're thinking about objects (and classes): old-style classes are gone
  completely. You no longer need to explicitly inherit from object. Hooray!

* The standard library has been reorganised and a number of modules have been
  made compliant with [PEP8][pep8].

[pep8]: http://www.python.org/dev/peps/pep-0008/

* A bunch of old built-ins have been pushed into the library or removed
  completely.


Stuff in 2.6
------------

`multiprocessing` for doing concurrent stuff with multiple processes.

`io` and `json` were back-ported. `io` is the core of the I/O system in py3k,
but it's just a library in 2.6

Advanced string formatting.

Abstract base classes.

Octal and binary literals now have syntax: `0x21 == 17`, `0b1101 == 13`.

Class decorators which can allow you to implement things like singleton
patterns through a decorator.

Added numbers, fractions, cmath, ssl modules. The `ssl` module forms the core
of some of the new networking modules for things like SFTP.

New toys in `math`, `functools`, `itertools`, `collections`. These include
`NaN` and `inf` constants; `map`, `reduce`, etc; permutations, etc; abstract
base classes for collection sets, named tuple, etc.

Stuff in 3.1
------------

`python` can now execute packages (and zip files) making it easier to package
and distribute

`unittest` supports skipping tests (things not to run on a platform, for
example).

Representations of floating point numbers now find the shortest consistent

`io` and `json` modules rewritten in C.

`memoryview` object is a mutable byte array.

A standard ordered dictionary in the collections module.

Also: lots and lots and lots of bugs fixed.

But is still breaks old code.

When 2.7 is released (expected in June), the only differences with respect to
py3k are syntactic (which can be enabled with `from __future__ import ...`).
Aside from bug-fixes, 2.7 will be the last release in the 2.x series.

Books
-----

[Dive into Python 3][] (Apress)

Programming in Python 3

[Invent Your Own Games in Python][invent]

IronPython in Action (Manning)

and a bunch of others

[dip3]: http://diveintopython3.org/
[invent]: http://inventwithpython.com/

**IronPython** is Python on CLR. They're focussing on VS integration before
working on py3k compatibility.

**Jython** is Python compiled to the JVM. Want to target CPython 2.7 in the
next release.

**PyPy** is Python in Python (which we'll here about in a later talk).

Migration
---------

Migration has be slow and steady as expected. 

* SQLAlchemy -- so db layers too
* Distribute -- was `setuptools`
* pygame
* Django -- *mostly* ported as sprints last year
* numpy -- they have a plan, but not yet the manpower

There's a good wiki page on http://wiki.python.org/ about porting python to
Py3k, a porting mailing list, and a useful archive of differences and
resolutions.

Less than 1% of packages on the PyPI explicitly list Py3k in their
categorisation. The graph is linear-ish, though.

Tools
-----

`2to3` was created to port Python2 code automatically.

`2to3c` does a similar thing for C extensions.

`3to2` will backport Py3k code to 2.

Moratorium
----------

There is a moratorium on syntax, semantics, and built-ins changes for at least
two years after Python 3.1 was released. This is to allow the community a
chance to get used to everything and let the other implementations catch up.
Not because it's "finished" (which it isn't).

Python 3 Speedup
----------------

Two projects of interest:

* Google's *Unladen Swallow* project to be merged into Py3k, bringing LLVM
  based JIT, etc. to the party.

* A more rational GIL.

The GIL is fine on single cores, but comes a cropper on multi-core systems. On
a single core, two threads run fine. One a multicore system, GIL blows
resources consumption through the roof: the program will be much, much, much
slower.

The new approach reduces GIL contention considerably, and makes parallelism
much more useful.

Community
---------

* Kiwi PyCon
* Planet Python (~40 posts on a busy day, all on topic)
* There's a forum
* PyPI comments

And a [PyCon AU](http://au.pycon.org/) is definitely going to happen (probably
in Sydney).

Cool Stuff
----------

http://www.skulpt.org is an implementation of Python entirely in JavaScript in
the web browser.

Shed Skin 0.3 is a Python-to-C++ compiler. Improved type inference, support
for `map`, `filter`, `reduce` and the `with` statement.

tinypy has its first app on the iPhone app store. Inspired by/similar to/based
on? cython/pyrex (the "generate a C module from this pseudo-Python").


Distribution
------------

Distribute replaces `setuptools`

`pip` replaces `easy_install` and is much better.

Web
---

Django 1.2 on the way (alpha in Jan). Full Python 3 support in a year or so.

`virtualenv` is awesome and cool. It creates a stand-alone python environment
so that you can test out or deploy or whatever without interfering with other
packages and requirements. Use it!