---
layout     : post
title      : Speech Synthesis for [more of] dthe Web
tags       : [code, drupal, accessibility, speech, synthesis]
categories : [drupal]
location   : Wellington, New Zealand
excerpt    : |
  A potential client was telling us their requirements for a new web-site and 
  asked about speech synthesis for users without a screen reader. The idea 
  intrigued me and this is the result.
---

When we think about speech synthesis the image that immediately leaps to many
of us is that of the profoundly blind people (people who cannot see at all)
using a screen reader. After a moment we might also think about hard to use
telephone menu systems. This is a shame because speech synthesis -- the
automatic transformation of *text* into *audio* -- can be useful in a wide
range of circumstances (and isn't particularly useful in those that first
sprang to mind).

[ab]: #

Our first image of speech synthesis being for the profoundly blind is, in
particular, concealing a wide range of cases in which it can be useful to
other users. The inability to access textual information is often context
dependent: people driving a car, operating machinery or engaged in many manual
tasks cannot look away to read information they need; and many people who are
fully or partially sighted may have difficulty some of the time: particular
combinations of colours or longer texts may be hard or impossible for people
with low literacy or cognitive disabilities like dyslexia to read. In these
cases and more users may benefit from access to audible versions but a lot of
them may not have access to sometimes expensive screen reader technology. To
help these users we can pre-generate audio versions of our content and make it
available to them.

The current version is very much a prototype: it uses the [espeak][espeak]
open source text synthesis engine to generate audio, [LAME][lame] to encode it
as MP3 and a reusable Flash movie to play it to the user. This has some very
real problems:

* The user must have Flash to access the content.

* There is no way for the user to access links, tables or images (other than
  trying to find them in the text).

* It's not possible to offload generation to other machines or to serve the
  generated audio files from a CDN or other more suitable service.

If this prototype eventuates in a real system I plan to make the following
changes:

* Use XSLT to process the combined [SSML][ssml]/[XHTML][xhtml] input document
  and generate both audio files and a [SMIL][smil] timeline to coordinate it
  with other content such as the display of images and the option to activate
  links.

* Decouple the application with the synthesis jobs posted to a queue and a
  daemon processing jobs, making the files available wherever necessary, and
  notifying the web application on completion.

[ssml]: #
[xhtml]: #
[smil]: #
[xslt]: #
[lame]: http://lame.sourceforge.net/
[espeak]: http://espeak.sf.net/