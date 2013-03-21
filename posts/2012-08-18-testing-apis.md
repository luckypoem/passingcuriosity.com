---
title: PyconAU 2012: Testing and being lazy and stuff
tags: PyconAU 2012, Python, performance
location: Hobart, Tasmania
excerpt: Notes from a talk about testing Python web projects at Pycon AU 2012.
---

Diminishing returns on quality assurance activity. We, as engineers, need to
try to "hack the graph" and do more with less.

Reference to Terry Pratchett, *Moving Images*. Not just doing nothing,
actively investment in future laziness.

Works in Mozilla Services on Mozilla Sync Server.

WebTest
-------

Provides a WSGI interface for humans. Wraps a WSGI application and provides a
nice interface. Good for functional test of a WSGI application, not so much
for unit tests.

WSGIProxy
---------

Wrap a HTTP target as a WSGI application. Then you can wrap this in WebTest
and run your functional tests from above and run them against your live
service.

This is great for deployment testing and you get it for free!

FunkLoad
--------

Really good tool for load testing, but it wants us to invest in it completely
as a stand-alone tool. We wind-up repeating much the same code against a
slightly different API.

Using a dedicated tool for load testing is very important, dedicated tools
will take account of ramp-up and ramp-down to make sure measurements are
reliable, etc.

Reports, differential reports (how did a change impact performance), 

Tools
-----

1. WebTest
2. FunkLoad
3. Web server

or maybe

1. FunkLoad
2. WSGI intercept
3. In-process WSGI app

