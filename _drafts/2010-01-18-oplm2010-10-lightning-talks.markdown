---
layout     : post
title      : OPML lightning talks
categories : [lca]
tags       : [lca2010, oplm2010, lightning, talks]
location   : Wellington, New Zealand
---

Paul Bone
=========

PhD at UMelb, sponsored by NICTA. Works on Mercury (sometimes called logical,
functional but neither is entirely true.)

Mercury does case checking on switches (checking you've covered all the
`cases`). Type-based. Type-directed optimisation. Purely, like Haskell, but
strict. Uses Uniqueness for I/O: "instantiation annotation" on parameters on
procedures. Threads a world through side-effecting calls, ensures single use,
etc.

----


???
===

Dude talking about Go. Very much in the C family syntax wise. Pike said choose
between: efficient compilation, efficient execution, ease of programming.

Parallelism, type system, etc. Shouldn't be a lot of cruft to deal with.
Should be fun to write.

Simple, not op overload, no implicit conversion. Minimal set of features.

Type system is nice: has interfaces (implicitly implemented). No OO and thus
no OO inheritance. Does have sub-typing though? (Didn't understand that).

Does have garbage collection.

Goroutines (not coroutines): native support for parallelism. Cheap, easy to
spawn: uses message passing / channels (built in to the language) to
communicate. Multi-core built in (but it's not to crash hot yet).

Compilation is really fast: 8 seconds to compile the whole standard library
(which is getting quite large).

No generics, no exceptions. 

----

John Graves
===========

PhD. AUT in Auckland. Using Dragon speech recognition to write Python.

Using pygame for gesture recognition and Dragon for speech recognition.


----

Adam Harvey
===========

Use HTML5 `<video>` elements instead of Flash.
	
CineJS (Google Code). 

Very very alpha. 

Works on Firefox, Chrome, Safari.

Very very alpha.

Adding greyscale, edge detection, gaussian blur, etc. In the browser.

Theoretically have a WebGL filter.

----

Eric de Castro Lopo
====

Disciple Language and the Disciplined Disciple Compiler. Written by Ben
Lippmeier at ANU.

Does lots of things that most compilers don't do. Disciple is a 

- Haskell-like language
- Strict static types
- All the usual Haskell coolness
- Effects typing (inferring and tracking side-effects)
- Mutability tracked by the type system (regions)

DDC is the compiler, written in Haskell. ~50KLOC. Compiles to C99, then goes
through gcc. Maybe LLVM backend in the future.

Ben's PhD (esp. the first chapter), #disciplined on freenode, or see Eric.

Effects and mutability are awesome!

----

Exposing the OS via a RESTful API.

Most of the time writing web apps these days. Most of the world is putting
interesting stuff into the web-browser. How about putting all the stuff we'd
normally do in the shell in there as well?

----

1M, 10M, 100M lines of code in large project. These need to be split into
smaller components: tens to hundreds of components.

----

Andy Chilten
============

Distributed bug trackers. Only seen one tracker he's seen that he liked. More
of a command line person, so wanted a command line bug tracker (lets you build
stuff on top of it).

Store it all in files and get the "distributed" bit for free by storing it in
a git repository. This makes it easy to extract complete histories from the
repository.

It's called cil: Command line Issue Lister.

----

Tim Ansel
=========

With an important announcement!

At OSDC Richard Jones came up and said: I think we should have a PyCon in
Australia. He as Jones: what ever happened to that PyCon idea?

Now Tim is organising a PyCon in Sydney this year. Who wants to come, etc.