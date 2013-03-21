---
title: PyconAU 2012: Server performance
tags: PyconAU 2012, Python, performance
location: Hobart, Tasmania
excerpt: Notes from a talk about server performance at Pycon AU 2012.
---

The low-hanging fruit when improving perceived performance is on the
front-end, not the back-end, and certainly not the small overhead of the HTTP
server.

Gunicorn:

> processes = 2-4 * cpus

The GIL essentially serialises thread processing. This impacts throughput in
threaded configurations.

Reverse proxy with nginx, etc. to decouple clients and app servers. Need to be
able to kill backlogged requests when they aren't needed; restarting some
servers won't clear a backlog.

Autoscaling configurations can cause load problems with fat applications;
pre-configuring for required maximums.

Server monitoring tools largely treat web apps as a black box, they show the
effects, not causes.

Sentry?

New Relic.

Apache modules are like "batteries included" for web-servers.

