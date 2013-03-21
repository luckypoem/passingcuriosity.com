---
title: PyconAU 2012: Python's dark corners
tags: PyconAU 2012, programming languages, python, corner cases
location: Hobart, Tasmania
excerpt: Notes from a talk at Pycon AU 2012.
---

Peter Lovett is a programmer and trainer.

Python's dark corners. Covering 2.x with a few tips on 3; things to avoid,
etc. Python is a fantastic language but it's not perfect and there are a few
dark corners which need to be worked around.

Python is a deceptively simple language: the surface simplicity hides a deal
of complexity.

Reference to the algorithmic trading incident.

OO
--

Python really is object oriented. This has a few more implications: "modules"
and functions are first-class.

References
----------

Python uses references by default. Use `is` for reference equality, not `==`.
Some types (int, tuple, etc) are immutable.

Rebinding is sometimes an accident. When of a built-in, it's often
catastrophic. Use `__builtin__` to get these things back.

Pass by reference is the default (and only option). The only pass by value is
to copy it. Lots of options for lists (slice `[:]`), the `copy` module.

Operators
---------

No `++` or `--` operators. "Mutating" operators are designed so as not to be
mutating: `+=`, etc. rather than `++`.

Typing
------

If you're checking types, you're doing it wrong. "Duck typing". #sigh

Numerics
--------

Floating point arithmetic is floating point arithmetic.

Tuples
------

Immutable, but only the tuple itself (i.e. the references it contains, not
their referents).

Arguments
---------

- Support both ordinal and keyword parameters.

- Default values. Default values are created at load time, so should probably
  be immutable.

Namespaces
----------

Scoping: scoping of variables is based on use within the scope, not dynamic.

Visibility of globals. Better to just avoid variables in global scope.

