---
wordpressid: 1393
layout: post
title: "Input Processing: The Joys of a Dodgy Hack"
wordpressurl: http://passingcuriosity.com/2005/input-processing-the-joys-of-a-dodgy-hack/
---

Just finished a rewrite of the input processing scripts. I now have a single
Python script that reads a SOFTIE log from a file and does a few things with
it. The first new feature is that it processes the option and parameter
declarations output at the start of the log and warns the user if
`very_verbose`, `print_kept` and `print_deleted` are not turned on. It
understands enough to set and unset option flags and parameters, but the
parsing is a little stupid. It will ignore warning lines, but treats
everything else that looks like a parameter or option as a parameter or
option, until it sees the start of the theorem proper.

It then proceeds to build a number of lists of clause `Node`s. There is a list
of all clauses and a list each of those that were kept, deleted and subsumed.
Whilst building the lists of clauses, it keeps an eye on the *time* (i.e. the
iteration) and increments it when necessary.

Once it is done building the lists of clauses, it, by default, prints out the
list of kept clauses as a graph in the XML dialect used by [prefuse][1], with
the nodes and edges bearing the attributes that the visualisation software
expects.

[1]

Though it would probably be faster if written with more care (or in a text
processing language like Perl or awk), this new script has turned what used to
be a 5 (or more) stage process with 3 passes over the log file, into a single
stage process with one pass over the data. It doesn't spawn any processes and
doesn't use much memory (as opposed to the old shell scripts, and the libxml2
Python scripts respectively).
