---
title : Making the GPU do its job
---

Keith Packard has gone on a hiring spring.

All the kernel work is done: 

* KMS (move the mode setting into kernel, rather than frob PCI from the X
  server)

* GEMS

Efforts to get 2D graphics accelerated on the GPU
-------------------------------------------------

Characterising 2D graphics:

* Text, images
* Little bit of video
* Lots of tiny operations (draw a glyph) compared with the typical 3D draw
  these thousand vertexes.
* Mostly static

Ivan Sutherland (1963) at MIT: first computer graphics.

General purpose CPU isn't fast enough, special purpose co-processor is added,
additional functionality added to the co-processor (chaining, conditional,
arithmetic), the co-processor gets too slow so you add another one.

Wait, what? It's just a general CPU now. Let's fold it back into the CPU and
reset to a new graphics co-processor. On the Design of Display Processors;
CACM Vol. 11, No. 6; June 1968.

We're currently late in this cycle: GPUs have lots of functionality and look a
lot like a general purpose processor. People are using them for heaps of
stuff; why not push 2D there as well.

Architecture
------------

1. 2D App (talks to)
2. Cairo (talks, via XRender, to)
3. X Server (talks, via driver, to)
4. Linux (GEM) (controlling the)
5. GPU

1. 3D App
2. Mesa (GL)
3. Linux (GEM)
4. GPU

Duplicated code for a given device in the X Server and Mesa.

**Problems** Performance is not adequate. Better performance means better
power. Writing two drivers (2d and 3d) is not fun.

Measurement
-----------

Chris Wilson has done work to allow us to do measurement. 

Used to use synthetic micro-benchmarks: gradients are important, make the
benchmark go quicker, but it doesn't speed the application...

Instead, created `cairo-trace` which records the Cairo operations performed by
an application. `cairo-perf-trace` can then replay these traces for testing.
This lets them make changes and *know* (rather than guess) that it improves
performance in application X.

Lets us tell that sometimes (GSM, evolution, poppler) it's *worse* to use the
GPU.

`cairo-drm` aims to get the X Server out of the rendering process, Cairo will
just talk to the kernel driver and ship stuff directly to the GPU. The
benchmarking above lets you see that doing this blows the old methods away
(firefox). But now we have to write three drivers! This isn't really a
solution (too many cards), but does prove the point that the GPU can help
here.

Can't *not* write a 3D driver: must support OpenGL. What about getting Cairo
to use OpenGL and kinda sorta remove the 2D/3D distinction: `cairo-gl`. This
is distinct form `cairo-glitz` (an implementation of XRender on top of
OpenGL).

Cairo has evolved quite a bit since then and `cairo-gl` knows about this and
does better things. Also shared based approach is possibly on the way. This is
currently not at all compelling (but there is a pretty clear roadmap).

What about non-Cairo applications?
----------------------------------

Punt them all to software rendering? In particular, what about Qt? Maybe fix
them to use Cairo?

Move X to speak to OpenGL? Glamor does this, but very early.

Make the X server depend on Cairo.

Cooperating with other GPU users
--------------------------------

GPU-assisted vide decode
Applications using OpenGL directly

GEM in the kernel makes sharing possible