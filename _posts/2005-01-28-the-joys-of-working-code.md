--- 
wordpressid: 1397
layout: post
title: The Joys of Working Code
wordpressurl: http://passingcuriosity.com/2005/the-joys-of-working-code/
---

I've discovered that the `AffineTransform` support in **prefuse** appears to
be broken. Flipping (i.e. scaling by a negative factor) doesn't work, or at
least misplaces the transformed co-ordinates. Rotating the display appears to
expose some form of redrawing bug, as parts of the display aren't drawn (or
need the display to be panned or scrolled).

This is in addition to what I imagine is a race condition of some description
that causes a `ConcurrentModificationException` (if that is the correct
exception class) to be thrown by a collection somewhere in the bowels of the
library.

All in all, I'm glad that:

1. the `AffineTransform` modification didn't take too much time;

2. that I've been able to get some diagrams done for my presentation; and

3. that not much was riding on this project.

While it would have been nice to have a complete package to deliver to my
supervisor, I can deal with having a dodgy hack. In addition, I don't think
I'll be able to get my log filter scripts completed in time for my
presentation or, probably, the end of the project. I'd have liked to have more
than one problem displayable, but I can't seem to get the filters to deal with
things like subsumption and demodulation properly.

Curses!
