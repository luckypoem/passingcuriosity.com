--- 
layout: post
title: Data, Data, Everywhere
tags: srp, logic, graph, visualisation, data processing
location: Canberra, Australia
excerpt: |
  The amount of data produced by the problems may pose a problem. LCL005
  produces more than 600MB of output and generates over 6,000,000 events.
  Processing this data into a graph description is the next phase of the
  project.
wordpressid: 1382
wordpressurl: http://passingcuriosity.com/2004/data-data-everywhere/
---

The amount of data produced by the problems may pose a problem. LCL005 for
example, produces more than 600MB of output and generates over 6,000,000
events.

Processing this data into a graph description is the next phase of the
project. Some fairly trivial (and very naive) shell scripts have been created
to split these files into a list of events for each iteration of the given
clause loop. These are however, excruciatingly slow and will need to be
rewritten in something a little faster. A few more scripts were created to
produce some event statistics and plot them using Gnuplot. These also will
need to be re-written in a language that has decent text processing facilities
(so as to remove the need to call three `cat|grep`'s per file). Awk may be a
good choice.

I seem to be missing some proportion of KEPT clauses. A trace of LCL403 for
instance does not list any KEPT clauses (except for those that form part of
the theory) whereas the statistics say that 29,208 clauses were kept. Most
confusing.
