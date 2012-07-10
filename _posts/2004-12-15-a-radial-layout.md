--- 
layout: post
title: A Radial Layout
tags: srp, logic, graph, visualisation
location: Canberra, Australia
excerpt: |
  My first approach at generating a radial layout of the graph data logged by
  the theorem prover.
wordpressid: 1385
wordpressurl: http://passingcuriosity.com/2004/a-radial-layout/
---

All of my work to date [*as is now reflected by back posts below*] has been on
two tasks:

1. generating runtime data dumps; and

2. experimenting with radial layout techniques.

Generating data has been relatively easy. The automated reasoning system (one
based on [SCOTT][1] I believe) already had the capability to output most of
the data I need (like some statistics and the generated clauses that are kept)
so I simply added the capability to output clauses that are discarded. After
the data has been generated, I have a whole heap of scripts in a number of
languages to translate it into a variety of formats, from CSV-like formats
suitable for generating graphs of various statistics (using GNUplot) to a
simple XML dialect which is then transformed into a number of others (for a
couple of graph rendering packages) to dot (the language [Graphviz][2] uses to
describe graphs).

[1]: http://rsise.anu.edu.au/~jks/scott.html
[2]: http://www.graphviz.org/

On the radial layout front, I have been looking at papers describing a number
of visualisation toolkits and radial layout algorithms for graphs and trees.
I've modified a layout component from one of these toolkits ([prefuse][3]) to
display my data in a radial layout, where radial distance is proportional to
time. Unfortunately, this leads to very messy graphs like this one:

[3]: http://prefuse.sourceforge.net

![A naïve radial plot of the GRP024 problem](/radial/naive/GRP024-1000.png)

I'm going to try and simplify the dataset and see if that will help resolve
the problem. If not, I think we'll have to find another visualisation for the
data.
