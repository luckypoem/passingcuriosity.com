---
layout      : post
title       : The State of PHP
categories  : [lca2011]
tags        : [java, jvm]
excerpt     : |
  Adam Harvey on the State of PHP.
---

Brought to you by the number 2.2250738585072011e-308 (which triggered a bug in
the interpreter).

PHP 5.2
=======

End of lifed with 5.2.15 (broke `open_basedir`).

5.2.16 (broke 32-bit).

5.2.17 (official end of life).

Don't expect any further releases. But most of the distros are going to keep
maintaining. Please upgrade.

PHP 5.3
=======

Current stable branch. 5.3.5 released on Jan 6, actively developed. Quite
stable. Name spaces, closures and lambdas, heaps of standard library
improvements.

- `crypt()` (5.3.2) is now PHP's own implementation instead of a thin wrapper
  around `crypt(3)`. Better than `hash()`, use it. No more need to `bcrypt`
  most of the time.

Not going anywhere for quite some time. Probably a good couple of years before
it'll be deprecated.

PHP 6
=====

First branched in circa 2005 and in development for some 5 years. Grand goal
was to integrate Unicode in the language. Actually became the too hard basket
for issues that can't be fixed now.

Also spawned a lot of books.

Put to death in March 2010 and trunk was rebranched from 5.3.

Trunk
=====

This is all subject to change, but...

It will probably be numbered PHP 5.4 (could be 5.5, could by 6, could be 7),
with fewer user-visible features than PHP 5.3, but still quite exciting.

Finally removed `register_globals`, `safe_mode`, SQLite2, computed break and
continue.

Alas, `goto` and `magic_quotes` remains.

New Stuff
---------

Traits: effectively mixins, essentially "compiler assisted copy and paste"
(that's basically how it's implemented). Overloads `use`.

Closures are getting finished (they can be bound to an object and act like an
method).

DBA gets Tokyo Cabinet.

JSON serialise support.

One more thing
--------------

PHP is not very fast.

5.4 will bundle APC (but switched off by default).

Lots of tweaks to the ZendEngine: string interning, HashTable optimisations,
vm execution improvements.

~20% on "real world" benchmarks.

A few % savings on memory usage.



