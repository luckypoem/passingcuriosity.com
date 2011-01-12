---
layout   : post
title    : Python 2.5 and Django GIS on Snow Leopard
location : Perth, Western Australia
category : development
tags     : [django, geo, snow leopard, libraries]
excerpt  : |
  This is a brief rundown on what it took me to install Django and its dependancies on Snow Leopard.
---

I'm working with Python 2.5 and Django 1.1 (because that's what is deployed on
the server) and need to use some of the GIS features that Django ships with.
This means that I'll need a bunch of libraries installed to access the
database, handle geospatial data, process images, and more.

I'm working on a fresh new install of Snow Leopard, so I've taken the
opportunity to ditch [Mac Ports][ports] and switch to [Homebrew][brew]. While
`brew` doesn't insist on installing its own X11, or perl, or gcc, or any of
the other things that `port` likes to install (even when they're already
installed!), it doesn't handle multiple architectures very nicely. For reasons
that escape me, `python2.5` on Snow Leopard is 32-bit only. This means that
the libraries it loads (and the libraries *they* load) must be 32-bit. Alas,
`brew` builds and installs 64-bit only libraries and executables. It's
possible to convince it to build a package for 32-bit, but this seems to be on
a per-package basis and *doesn't* apply to any packages installed as
dependancies. Thankfully there's only a handful, but it's still a pain to edit
each of them.

Python Imaging Library
----------------------

Installing *PIL*, as it's commonly referred to, requires a few tweaks for Snow
Leopard. The most important is convincing it to build 32-bit libraries, but I
also want to get it to link against the system Freetype library (so that I can
use the font-handling API) and against `libjpeg`.

The process goes something like this:

{% highlight sh %}
brew edit jpeg # To build 32-bit
brew install jpeg
curl -o Imaging-1.1.7.tar.gz http://effbot.org/media/downloads/Imaging-1.1.7.tar.gz
tar xvf Imaging-1.1.7.tar.gz
cd Imaging-1.1.7
sed -E -i .bak -e 's#FREETYPE_ROOT = None#FREETYPE_ROOT = "/usr/X11"#' setup.py
python setup.py build
python setup.py install
{% endhighlight %}



[ports]: http://www.macports.org/
[brew]: http://wiki.github.com/mxcl/homebrew/