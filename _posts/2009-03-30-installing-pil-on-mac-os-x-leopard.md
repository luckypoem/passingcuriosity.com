--- 
wordpress_id: 1045
layout: post
title: Installing the Python Imaging Library on Mac OS X Leopard
wordpress_url: http://passingcuriosity.com/?p=1045
---
Like many other developers, I work on a variety of UNIX-like operating systems 
including Linuxen, BSDs, and Mac OS X. While it's generally pretty easy to 
build and install new software on Linux and BSD-based systems, it can be 
something of a pain in the arse to get some things to build on OS X, 
particularly when the multiple-architectures stuff comes into play. The most 
recent trouble I've had is in installing [Python Imaging Library](http://www.pythonware.com/products/pil/) (henceforth PIL).

*[PIL]: Python Imaging Library

Thankfully, it's not too hard to figure out the problems and get it built, 
installed and passing the tests. This post provides a few pointers to getting 
PIL working on OS X 10.5.6 with the Python 2.6 package and a bunch of libraries 
installed using Macports.

<!--more-->

The first thing to do is download the source code from the [PIL download page](http://www.pythonware.com/products/pil/). Unpack it as
usual and then try to build it in the usual `distutils` fashion:

    tar xzf Imaging-1.1.6.tar.gz && \
    cd Imaging-1.1.6 && \
    python2.6 setup.py build
    
If your system is like mine, the build process will error out like this:

> ld: in /opt/local/lib/libxml2.2.dylib, file is not of required architecture 
> for architecture ppc
> 
> collect2: ld returned 1 exit status
> 
> lipo: can't open input file: /var/folders/nk/nka0oBX-Gsy7r+w2hIFEfk+++TI/-Tmp-//ccMSWw7I.out
> (No such file or directory)
> 
> error: command 'gcc' failed with exit status 1

This is a relatively straight-forward error: it's complaining that a library it
needs doesn't support an architecture that it's trying to compile for, namely 
PPC. There are two ways to fix this:

1. Build this file manually without support for PPC (quick and easy); or
2. Install universal versions of all of the libraries that PIL depends on 
   (likely to be slow and tedious but not particularly difficult).

### Building manually ###

The first option is the quickest, so I'll describe it first. Simply copy the gcc
command that failed (it starts "gcc" and wraps over the next five lines) and 
paste it into your Terminal. Then delete the `-arch ppc` (if you're on an x86 
machine) or the `-arch i386` (if you're on a PPC) and run the edited command. 
When it completes, simply run `python2.6 setup.py build` again and it'll take up
where it left off and you'll soon be ready to `python2.6 setup.py install`.

### Installing universal libraries ###

The second option is a little bit more painful, because there are a number of 
libraries that you may need to reinstall as Universal. I'll give instructions 
that I used and for [Macports][macports]. If you use something else, you'll 
need to figure it out yourself.

Installing a universal version of a Macports package is pretty easy. All you 
need to do is add the `+universal` variant to it like so:

    sudo port install apackage +universal

Updating an already installed package as a universal is similar:

    sudo port upgrade apackage +universal

I had to update the following packages (in order) before PIL would build:

1. [libxml2](http://xmlsoft.org/); and
2. [zlib](http://www.zlib.net/)

But you may also need to reinstall:

3. [jpeg](http://www.ijg.org/); and
4. [freetype2](http://freetype.sourceforge.net/)

With that done, `setup.py` should be able to build and install PIL. 

The complete set of commands then is:

    sudo port upgrade libxml2 +universal
    sudo port upgrade zlib +universal
    sudo port upgrade jpeg +universal
    sudo port upgrade freetype +universal
    tar xzf Imaging-1.1.6.tar.gz
    cd Imaging-1.1.6/
    python2.6 setup.py build
    sudo python2.6 setup.py install
    python2.6 selftest.py

With luck, you should now be ready to go!

### References ###

I used the following references in tracking this information down:

1. [a comment](http://www.p16blog.com/p16/2008/05/appengine-installing-pil-on-os-x-1053.html#comment-6a00e54fa872f38833010535c1c365970c) on a blog post about 
   [Installing PIL on OS X 10.5.3](http://www.p16blog.com/p16/2008/05/appengine-installing-pil-on-os-x-1053.html).
1. a [message by Christopher Barker to the Image-SIG list](http://mail.python.org/pipermail/image-sig/2008-April/004939.html).
3. If you're a fink person, you might find [Kill PIL – The Python Imaging Library Headache or Building PIL on Mac OS X](http://blog.tlensing.org/2008/12/04/kill-pil-–-the-python-imaging-library-headache/) helpful.
