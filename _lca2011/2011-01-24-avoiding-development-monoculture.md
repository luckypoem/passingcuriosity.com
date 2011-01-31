---
layout      : post
title       : Cruz, Jon A. *Avoiding Development Monoculture*
location    : Brisbane, Queensland
categories  : [lca2011]
tags        : [development]
excerpt     : |
  Some things to consider in avoiding development monoculture.
---

There are approaches that might seem good, but actually cause problems. Some
approaches not been considered. End result is ofter pain.

Maslow's second most well known contribution is Maslow's Maxim: when all you
have is a hammer, everything looks like a nail.

You need to think differently! Areas to consider:

- Different users - there is no one true user of your system.
- Different operating systems - including different distos.
- Different displays - not just the hardware, but the interaction model.
- Different hardware - 
- Different modularity - 
- Different languages - have strengths and weaknesses.
- Different tools

Different Users
===============

Some people suggest that 3-5 people are enough for software testing to be
effective. But you need 3-5 different *types* of people.

"One size fits all" is usually incorrect.

Issues of users to consider: industry and role, age, computer experience.
These and many, many other attributes affect habits and modes of interaction,
and their established mental models.

Different Operating Systems
===========================

Write once, debug everywhere. Porting, slightly incompatible implementations,
alternative solutions that might be available.

Some much variety between vastly different and even similar systems. Not
testing will result in errors. Porting or maintaining applications between
operating systems will often expose bugs in that effect multiple platforms.

Different Displays
==================

GUI toolkits: GTK+, QT. Choosing one may lock the other out. You need to
consider these issues.

Decoupling things so that they shared and reusable between, e.g., web and
desktop interfaces.

Command-line interfaces. In some roles, for some user groups, this is
absolutely essential.

Text User Interfaces.

Different Hardware
==================

Slow, low-memory, ("power efficient").

Available interface devices (keyboards, touch screens, etc.).

Server farms: at large scales some approaches just don't work, some libraries
just can't handle large scales.

Small form factors, display density and dimensions, etc.


Different Modularity
====================

Separating code into relatively orthogonal pieces. Encourage reuse, enable
testing.

Different Languages
===================

Approach problems in different ways: C++, Lisp, Java, C#, etc.

Concepts in one can often be brought to another: interfaces from Java to C++,
functional concepts, dataflow, etc.

Different Tools
===============

IDE lock-in can be limiting: ties in to a certain approach to develop,
limiting contribution, dependant on vendor changes.

Grounded in odd concepts: Development Studio's inverted idea of Test Driven
Development.

Tools for the job:

* Graphics
* Icons
* Editing
* Debugging
* Source control

All often integrated into an IDE, but a jack of all trades is master of none.
