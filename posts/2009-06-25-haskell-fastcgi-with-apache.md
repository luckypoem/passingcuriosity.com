---
layout: post
title: Haskell FastCGI with Apache
tags: haskell, web, fastcgi
location: Perth, Western Australia
excerpt: 
  Getting started writing web applications in Haskell is pretty easy with
  FastCGI.
wordpressid: 1290
wordpressurl: http://passingcuriosity.com/?p=1290
---

It's pretty easy to get started with Haskell web-applications using the
[cgi][hs-cgi] and [fastcgi][hs-fastcgi] packages, but a little bit of extra
documentation never hurt anything. What follows is a brief run-down of getting
a Haskell FastCGI program compiled and working under Apache with
`mod_fastcgi`.

[hs-cgi]: http://hackage.haskell.org/package/cgi
[hs-fastcgi]: http://hackage.haskell.org/package/fastcgi

Installing the software
-----------------------

There are two important pieces of software to install before we can build our
application: Apache with `mod_fastcgi`, and the Haskell FastCGI library. You
should install Apache as you normally do. This probably involves one of the
following commands:

{% highlight sh %}
    sudo pacman -S apache # On Arch Linux
    sudo aptitude install apache2 # On Debian, Ubuntu, etc.
    sudo port install apache2 # On Mac OS X with Macports
{% endhighlight %}

### Installing the FastCGI module

Next, you will need to install `mod_fastcgi`. This may be packaged for your
system, in which case you can use `pacman`, `aptitude`, `port`, etc. as
appropriate. If it is not, you'll need to build it. Happily, this is dead
easy:

Download and unpack the `mod_fastcgi` source from
[http://www.fastcgi.com/dist/][fastcgi]. Edit `Makefile.AP2` to point to your
Apache root (the directory which contains `build/`). In my case (on Arch
Linux), this was `/usr/lib/httpd/`. Compile and install it with `make -f
Makefile.AP2 && make -f Makefile.AP2 install`.

[fastcgi]: <http://www.fastcgi.com/dist/>

Next, you'll need to enable the module. The "correct" way to do this varies
wildly from distribution to distribution. In particular, Debian-based systems
like to spread this out over some three or four files.

Edit your Apache configuration (mine was in `/etc/httpd/conf/httpd.conf`) to
load the module:

{% highlight apache %}
    LoadModule fastcgi_module modules/mod_fastcgi.so
{% endhighlight %}

There are a number of ways to configure the module, but the easiest is to add
it as a handler for `.fcgi` files. Add the following snippet to `httpd.conf`:

{% highlight apache %}
    <IfModule fastcgi_module>
        AddHandle fastcgi-script .fcgi
    </IfModule>
{% endhighlight %}

You'll still need to add the `ExecCGI` option to the directories which contain
the `.fcgi` files to be run. I'm planning to use my `~/public_html/`
directory, so I amended the `<Directory>` section in
`/etc/httpd/conf/extras/httpd-userdir.conf`:

{% highlight apache %}
    Options +ExecCGI
{% endhighlight %}

Restart Apache and you're good to go. If anything goes wrong, try looking at the [`mod_fastcgi` documentation](http://www.fastcgi.com/mod_fastcgi/docs/mod_fastcgi.html).

### Installing the Haskell libraries

Installing the Haskell libraries should be a little more straightforward: just
use [Cabal][cabal].

[cabal]: <http://haskell.org/cabal/>

1. `cabal update`
2. `cabal install --global cgi`
3. `cabal install --global fastcgi`

If your `cabal` does not know how to become root, you may need to prefix those
`cabal install` commands with `sudo` (or, better yet, edit `~/.cabal/config`
to specify `root-cmd: sudo`).

Your environment is now ready to build and run FastCGI applications in
Haskell.

Building a test application
---------------------------

A simple Haskell FastCGI application looks like this (largely cribbed from
[Paul Brown's blog][blog]:

[blog]: <http://mult.ifario.us/p/wiring-haskell-into-a-fastcgi-web-server

{% highlight haskell %}
    module Main ( main ) where

    import Control.Concurrent
    import Network.FastCGI

    action :: CGI CGIResult
    action = do
        setHeader "Content-type" "text/plain"
        tid <- liftIO myThreadId
        output $ unlines 
            [ "I am a FastCGI process!"
            , "Hear me roar!"
            , ""
            , show tid
            ]

    main :: IO ()
    main = runFastCGIConcurrent' forkIO 10 action
{% endhighlight %}

Copy and paste that code into a file (I'll call it `Main.hs`) and compile it:

{% highlight sh %}
    ghc -threaded --make -o ~/test.fcgi Main.hs
{% endhighlight %}

You'll now have a file `~/public_html/test.fcgi` which you can call using
`curl`. The first request might be a little slow, but subsequent requests
should be much faster:

{% highlight sh %}
    curl --include http://localhost/~$USER/test.fcgi
{% endhighlight %}

Congratulations! You now have a working Haskell FastCGI application hosted
under Apache. If you have any suggestions, comments, or questions, please
leave a comment.
