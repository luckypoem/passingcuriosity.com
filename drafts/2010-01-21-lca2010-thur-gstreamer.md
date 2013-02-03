---
---

Introduction 
============

Jan Schmidt works for Sun optimising media streaming performance on thin
client stuff (50%) and general GStreamer work (50%).

GStreamer is the mm framework that underlies GNOME and is used in a bunch of
stuff Nokia N900, Palm Pre, Amazon's ebook reader. Used mostly for multimedia
(but also for other things like scientific data sampling).

Playback, streaming, mixing, non-linear editing, etc. 

GStreamer History
=================

Started in 1999 (10 years old in June 2009). Added to GNOME in 0.6.

0.0.1 - 0.4.0 (Jun 99 - Feb 03) experimenting with design; plugins, elements,
pads; registry (of installed plugins); cothreads, bufferpools.

In GNOME 2.0 as early as 0.4.0, but it was pretty primitive

**0.6.x** the point at which GStreamer became useful at audio playback (video
playback still broken).

**0.8.x** another year and a half (Mar '04 - Dec'05), good at audio, video
OKish but still pretty bad at video. Totem and content creation Pitivi,
Flumotion. New capabilities (allows underlying library to determine that
plugins are capable of doing particular things).

**0.10.x** December 2005 (Fluidium? had capital to hire a bunch of GStreamer
devs for a while in Barcelona). Significant design changes; use OS threads
instead of co-threads; began API/ABI stability (for over four years now,
modulo slight rough spots); plugins split good/bad/ugly ("base" should provide
video playback and include examples of each type of plugin; "good" is freely
distributable plugins, "bad" is not ready, reliable, is going to move; "ugly"
is known patent encumbered, etc.)

When the plugins were split out (Oct 2005) commits dropped hugely. The switch
from CVS to Git in Jan '09 lead to an increase in commits. Git certainly seems
to make the developers much more productive (more commits, but the size of
commits didn't seem to change much). Quite a few peaks from hackfests,
peoples' holidays (having lots of time to hack).

Since Jan 2009
--------------

38 individual module releases (core, base, good, bad, ugly, gl, python
bindings). Two or three modules released each month, roll over on a three
month cycle (has worked pretty well for two years; only fallen over in the
last two months when Lars moved from Dublin to Melbourne).

Migrated from CVS (4,5,6 modules with manual surgery and a bunch of other
wackiness) to Git.

The registry was modified from an XML format to a binary format. This makes it
possible to remove the dependency on libxml2 (after disabling the graph
serialisation functionality).

Added presets (a system file with preset values for particular components)

`playbin2` element that encapsulated a lot of the functionality you'd expect
in a player applications. Has progressive downloading, compressed video
buffering, multitrack support. Totem uses `playbin2` as its backend.

Interlacing support (new capabilities so plugins can implement it)

Usable DVD playback

`appsec` and `appsink` are custom feed and output elements with make it easier
for custom application code to interact with GStreamer graphs.

Lots of work on RTP and RTSP support. Empathy and Telepathy use this for video
chat support.

HDV support (Edward's desire to edit video shot with his HDV camera)

Support for DVB cards and such to work in Totem, do video shifting, etc.

More mutexers, filtes, effects, formats. In particular for MPEG-TS, mp4/mov
(both of which GStreamer has been able to play but pretty average at
producing).

gst-plugins-gl

More external plugin projects (DSP and sound effects producers and such)

Cairo/X/GL hackfest. Meetup in Barcelona in November 2009, Carl Wirth, GST, X,
GL people talking about video playback in general and what it means for each
of them. Teaching Cairo about YUV formats and use Cairo to do rendering type
tasks: scaling, transformations, etc all easier as it's just a Cairo context.
Eventually this will let things like subtitle rendering get pushed off to the
video hardware.

Recently added a frame stepping framework that does pretty much what you'd
expect: allowing you to step forward and backward frame

Why do a 1.0
============

**CONS**

0.10 has been working as is for four years. Proves that new stuff can be added
without needing to break everything.

Designed for parallel installation. Changing the version number will case app
changes.

Breaking the API/ABI porting hassles.

Lull in development. There was an 18 month lull between 0.8 and 0.10 with no
bug fixes, etc.

Supporting 0.10 (some people are *paying* for support of the 0.10 release).

**PROS**

There are design flaws in 0.10. 

Remove deprecated API. `gst_element_get_page()` is racey (a demuxer might not
know about the pads it provides before hitting the start of a stream), use
iteration now. stream time, some gst_controller bits (change properties on
waveforms - Rhythmbox uses it for volume), playbin and decodebin, GstMixer,
RTP library APIs that went into a release, GstCollectPads.

Fix API warts - quite a few butt ugly things, GstImplementsInterface (does an
element currently implement an interface - mixer element with no mixer), tuner API, etc.

Symbolism of 1.0

Git makes things easier. A lot of the things that were hard under CVS are easy
now (branching, etc.).

Deficiencies: video clean-regions, make video buffer strides more explicit,
colour spaces. Public stuff that should have been private. ABI: where we're
out of padding on structures. FIXME: 0.11 backward compatibility.

**Helping developers**

Easier installation on non-Linux platforms (Kits for OS/X and Windows)

Higher level helper libraries. Totem has nearly 7k LOC to implement a
video widget, which anyone who implements playback winds up replicating in some fashion. A GStreamer video widget library would rule.

Improve the GstBus system. Create a pipeline for processing media, and get
messages from it on the bus. Split between asynchronous messages that can wait
for, e.g. the mainloop; and synchronous messages which must be handled
immediately in the thread (I need an X window now). Modifying this with some
sort of futures or something so that the pipeline will wait for responses.

**Invigorate development**

No more worrying about API/ABI stuff everywhere.

Moving plugins around currently has to wait for a release cycle which can be
months.

New features:

Better hardware acceleration support 

Proposal
========

New git playground.

Merge from master regularly

WIP branches to demonstrate ideas

Keep developing 0.10 as is. Pull branches together as 0.11.

Target GStreamer 1.0 in time for GNOME 3.0