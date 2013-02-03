---
wordpressid: 1395
layout: post
title: On the Benefits of Documentation and Its Reading
wordpressurl: http://passingcuriosity.com/2005/on-the-benefits-of-documentation-and-its-reading/
---

I am stupid. That is the only possible explanation for the way I've wasted
most of the last couple of weeks of work, by hard-coding a number of
transformations into my code when the library I'm using (*[prefuse][1]*, just
in case you'd forgotten) supports `java.awt.geom.AffineTransform`, in all it's
glory, or should that be gory. So now, I've been hacking out all my size
handling code; all my device co-ordinate handling code; all the uncommented,
unnecessary, inexplicable cruft that has been cluttering up my code, and
replacing it all with a single `AffineTransform` applied to the `Display`.

[1]: http://prefuse.org/

This has meant that I've been able to trash my idea of creating a new class.
I'd already pretty much finished `AdjacencyMatrixManager` which was to know
the size we were drawing at (i.e. the dimensions of the matrix we were filling
in) and be able to convert points in a useful co-ordinate system (such as one
with the origin at the bottom-left) into device co-ordinates. As quick as it
was to hack up, it didn't take much longer to tear out again.

Now, all my classes are smaller (most of the are just a couple of one-liners
in an interface stub), my code is [probably] going to be faster (there are a
lot fewer method calls), and it is a lot simpler, with all of the stupidity
caused by the device co-ordinates confined to one place.

The only problem I can see will be in adding interface elements that I don't
want the `AffineTransform` to be applied to. Things like tooltips mustn't be
transformed, or we'll wind up with huge, unreadable text the obscures its
subject. On the other hand, it will be a lot easier to do things like
highlighting effects, and such like as I no longer need to pass around various
parameters.

On the whole, this is the better path, even though I may need to start poking
at *prefuse*'s insides.
