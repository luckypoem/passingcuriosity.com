---
title: PyconAU 2012: Writing command-line applications
tags: PyconAU 2012, Python, command-line, user interface
location: Hobart, Tasmania
excerpt: Notes from a talk about writing command-line applications in Python at Pycon AU 2012.
---

Graeme Cross, How to write a well-behaved Python command-line application.

Goals include developing programs which are robust and well-maintained;
include a flexible, powerful interface; stay within the command-line paradigm
(pipes); handles errors and signals; well tested and documented.

We're dealing with 2.6/2.7 in this session, there are some differences in
Python 3 releases.

The slides and code are available at http://www.curiousvenn.com/.

What is a well-behaved application? "Do one thing well", be UNIX, robustly
handle bad input, gracefully handle errors, be well documented, platform
aware.

Use Python for its wide platform support; syntax; scalability; extensive
library ecosystem.

Scripts should use the following pattern:

    if __name__ == 'main':
        print "running"

so that they can be imported for use as a library, testing, etc.

