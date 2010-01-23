---
title: A year (and a half) of clutter
---

[Clutter][clutter] is a library for creating fast, visually rich, portable and
animated user interfaces.

[clutter]: http://www.clutter-project.org/

2008
====

He was in Istanbul having fun (involving alcohol). Released Clutter 0.8 at
GUADEC.

Intel started thinking about using Clutter for the [Mobil project][moblin].
OpenedHand was acquired by Intel.

[moblin]: http://moblin.org/

1.0 release delayed repeatedly, finally released a year later. During this:
performance, API, new animation framework. 1.2 in March.

1.x
===

1.x means API and ABI stability. Also means minimal amount of reliable API.
1.x has around 1600 documented public symbols. Only 250 symbols less than 0.8.

Full documentation. Not just list of symbols, but real documentation,
tutorial, etc.

~75KLOC codebase, +25KLOC since 0.8

14+ KLOC test
1700+ symbols in CLutter (99% doc)
~300 in COGL (90% doc)
1800+ single commits
35+ single authors, 15 from Intel


Implicit Animations
===================

Landed in 1.0, expanded in 1.2.

Began with an animation API in 0.2, but it wasn't very good at implicit
animations: you had to specify [potentially independent] beginning and end
states.

Implicit animations: specify the final state, the initial state is implicit
(on the scene graph) and the API works out the intermediate states.

Bind an interval of values to attributes of objects, then timeline (clock) and alpha (function bound to clock?).

Create anim; get state of actor; bind props; manage anim. All managed using a
variadic function: `clutter_actor_animate()` that does the memory management,
etc. that you used to do manually. It's greatest strength (and weakness) is the amount of complexity that it hides.

The revenge of `g_something_connect()`?

The Master Clock
================

The master clock is a construct which lies at the heart of the Clutter main
loop. Driven by simple concept of synching to Vblank. There's no point
producing more fps than you can display.

http://isglxgearsabenchmark.com/

Something changes; adv anims; proc events; layout; paint; wait for vblank. All
done implicitly: the only thing that client code needs to handle is "something
changes". This is all built on the GLib MainLoop. So you can also use other
Glib stuff like a GTK+ widget or [GStreamer][gst] filter.

[gst]: http://gstreamer.org/

OpenGL is not a good API. It has a massive flat namespace and everything that
could be miss-designed *was* miss-designed.

Clutter provides a CPU programming library. Integrated with Clutter: use the
COGL API to implement your own Clutter actors.

COGL is based on the concept of draw buffers (on- or off-screen). On-screen
draw buffers include windows, etc. Off-buffers like OpenGL frame buffers.

Geometry and what-to-paint to GPU. Vertex Buffer objects. All this is not just
dumped into the GPU; this would be extremely expensive: lots of state saving,
etc. Instead, COGL stores everything inside a journal which will be replayed
with [hopefully] a single OpenGL call. This will minimise the state changed
within the graphics system and [hopefully] be faster. "State Caching and
Batching"

Mesa: build state, create shader program and upload it to CPU. We know the
state, so do the program ourselves and upload it.

Break out into GL is not a great idea (save state, do GL, restore state).
Probably not a good idea.

The Future
----------

Will be following 6 month cycles (synchronise with Moblin and GNOME). Help let
Moblin and GNOMEShell (both based on clutter) take advantage of latest dev.

Freeze on 1.2 at beginning of Feb, release prob late Feb, early March.

Layout Managers: currently hard to create a complex actor (children); must
subclass Clutter group and do a lot of work (but not quite so much as a GTK+
widget). Have created *layout mangers* which let you specify the way children
should be laid out.

Improved Portability: to Windows, etc. Don't write GL ES code, but do get
feedback from OpenGL ES developers (it is being used on ES devices) and rely
on this community feedback as they can't test it.

Performance: working with the Intel graphics team to improve the performance
on modern GPUs to make GPU performance and UI responsiveness is better than
anything else.

2.0 starts now: planning for the 2.0 API break in two or three years
(depending on the Moblin and GNOME needs).

Questions
---------

Clutter doesn't have very high requirements with respect to OpenGL API.
They're almost ready for OpenGL 3.0. You can build it with VS, MingW and (yes)
it uses OpenGL on Windows.

Goal is to get Cairo 2d to be GL accelerated.

GNOMEShell is written in JavaScript and uses the GLib introspection stuff
(which is the way of the future). For languages that are slower on the uptake,
there are usual language-specific API bindings. There's an experimental perl
module that uses introspection.