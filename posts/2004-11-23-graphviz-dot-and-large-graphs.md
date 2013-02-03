---
layout: post
title: Graphviz, Dot and Large Graphs
author: Thomas Sutton
tags: srp, logic, graph, visualisation
location: Canberra, Australia
excerpt: Notes on my graph visualisation project.
---

Today I started looking at transforming the data dumped by the theorem
prover into 'dot', the language used by [Graphviz][gv] (and a number
of other packages).  A quick and extremely dirty script translated the
data into 'dot' and I, foolishly as it turns out, started a test run
going of LCL005, to see just how big a graph it is. When I went home
for the day, it was still running.

[gv]: http://www.graphviz.org/

I need to find an easy way to determine the iteration in which clauses
are generated so that I can play silly buggers with weighted edges,
explicit rankings, etc.
