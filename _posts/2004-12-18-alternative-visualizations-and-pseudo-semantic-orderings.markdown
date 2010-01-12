--- 
layout: post
title: Alternative Visualizations and Pseudo-semantic Orderings
wordpress_id: 1386
wordpress_url: http://passingcuriosity.com/2004/alternative-visualizations-and-pseudo-semantic-orderings/
---

I've started thinking about alternative visualisation methods in the last
couple of days. The most promising alternative is an adjacency matrix tweaked
slightly to handle the added temporal "dimension". An adjacency matrix will [I
hope] make patterns easier to spot, will be easier to code, and will probably
be a lot faster to run. The added speed will enable the use of a number of
run-time effects to aid in exploration of the data sets (highlighting related
elements, selecting temporal "regions" of the data set, etc).

On the the other hand, the lecture yesterday by [Thomas Meyer][1] (which
happened to be the final day of the [Logic Summer School][2]) was about belief
revision and mentioned using epistemic entrenchment to impose an ordering on
the set of clauses (or rather beliefs). The though struck me that this
technique, or one similar, might be just what I need to impose some form of
ordering on the set of clauses to be able to plot them effectively.

[1]: http://www.cse.unsw.edu.au/~tmeyer/pubs.html
[2]: http://lss.rsise.anu.edu.au

The only problem is that any such ordering would not be stable, so it would
not allow comparison between two visualisations of different set of clauses
(in the most obvious way at least). This might be applicable to both the
radial network layout and an adjacency matrix. The radial layout might derive
a clauses polar coordinates from its position in the ordering and from the
time at which it was created. On the other hand, having a non-temporal
ordering relation allow the adjacency matrix to be more useful in animating
the graphs growth and development. I imagine that such a visualisation's
appearance would be obvious to experts in automated reasoning, but it seems a
lot more promising (and useful) than layout out the graphs to minimise edge
crossings, etc.
