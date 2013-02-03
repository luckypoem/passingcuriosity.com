---
wordpressid: 1390
layout: post
title: Onward, to a less nonsensical visualisation!
wordpressurl: http://passingcuriosity.com/2004/onward-to-a-less-nonsensical-visualisation/
---

![SET012-clip2.png](/matrix/initial/SET012-clip2.png)

The new, matrix inspired, visualisation method is coming along nicely and, as
can be seen in the picture linked above, allows one to identify possibly
interesting features of the dataset. In this case, there are three points
early in the graph that are well above the line formed by the given parent
edges. These three, and a number of strange plateaus in the line are probably
cause by factorisation.

Factorisation is a technique used by the prover to 'modify' clauses and is
done (in these cases at least) when the clauses are added to the "database" of
clauses. That is, when they are created. This leads to points that ignore,
almost completely, the rest of the graph.

The first thing on the agenda for the coming week is to finish and polish the
visualisation itself. Dealing with the gap a the start of the graph caused by
the clauses of the theorem not having any parents will be near the top of the
list, as will testing the layout code to ensure that it is not piling nodes on
top of each other (I believe that it is, though it didn't seem to be when I
had a quick look I've had at this problem). When the drawing code is complete
and correct, I'll move on to adding in some useful features like drawing the
axes, labelling rows and columns, etc.

After the essential features are implemented, the visualisation will need to
be evaluated with respect to the goal of my project. If it doesn't seem to
make the search process any more obvious, I'll have to reconsider my approach
to the problem. On the other hand, if this approach is useful, I'll start to
add some more exotic abilities to the application focusing on the dynamic
exploration of the dataset. Animation, dynamic colouring of graph elements and
querying and constraining the dataset will all, I hope, help the user explore
and understand the data set.

Another avenue that will need to be explored is the sheer size of the
visualisation. The SET012 graph has the same [*very approximately*] dimensions
as twenty seven and a half, 17 inch monitors side-by-side. Needless to say,
this will be difficult to navigate, especially on machines with a single, or
smaller, screens. Fortunately there is a lot of research the area of zoomable
interfaces, and a number of toolkits like [Piccolo][1] and [ZVTM][2] should
help implement some form of scaling.

[1]: http://www.cs.umd.edu/hcil/piccolo/
[2]: http://zvtm.sourceforge.net/
