--- 
wordpressid: 1997
layout: post
title: Haskell on Snow Leopard
wordpressurl: http://passingcuriosity.com/?p=1997
---

Being the closet Apple fanboy that I am, I pre-ordered Snow Leopard and had my
Macbook upgraded the day of release. Unfortunately, this had the effect of
completely breaking my Haskell environment. **I've managed to resolve all of
the problems that I encountered and have noted the various solutions here. See
the end of this post for notes.**

Thanks to HowManyFiles you can now read a Japanese Translation:  [日本語訳](http://haskell.g.hatena.ne.jp/HowManyFiles/20100211).

First, there's the matter of getting GHC to compile anything. The problem is
that Snow Leopard, and all it's compilers, are now 64-bit by default. Alas,
the code GHC generates on on Mac OS X is 32-bit and thus the assembler and
linker both error out resulting in errors like this:

    /var/folders/1J/1JKije6yHpm78qqdjF5N2U+++TI/-Tmp-/ghc7743_0/ ghc7743_0.s:1357:0:
    suffix or operands invalid for `push'

    /var/folders/1J/1JKije6yHpm78qqdjF5N2U+++TI/-Tmp-/ghc7743_0/ ghc7743_0.s:1401:0:
    suffix or operands invalid for `push'</code>

The solution is to get GHC to pass `-m32` flags to the compiler (if used),
assembler, and linker.

The quickest way [^1] to do this is by editing `/usr/bin/ghc` -- a shell
script which calls the "real" GHC binary -- to add the flags `-optc-m32
-opta-m32 -optl-m32`. This ensures that the arguments are passed to all
invocations of the compiler.

[^1]: Explained in [this Haskell-Cafe
thread](http://www.mail-archive.com/haskell-cafe@haskell.org/msg64038.html).

Alas, this is not the end of the story. The next step in setting up a Haskell
development environment is to install
[cabal-install](http://haskell.org/cabal/). This depends on the
[HTTP](http://hackage.haskell.org/package/HTTP) and
[zlib](http://hackage.haskell.org/package/zlib) packages. `HTTP` is no problem
now that we can build and run `./Setup.lhs`, but `zlib` appears to be broken
and reports "incompatible version" errors at runtime. The error itself seems
to originate in `Codec/Compression/Zlib/Stream.hsc`, but other than that, I'm
completely stumped.

The only way forward for me is to either leave my Haskell development for a
while (even Hugs won't install with [Macports](http://www.macports.org/)) or,
what I'll actually do, do all my development on Linux in a
[VirtualBox](http://www.virtualbox.org/). This is obviously less than ideal
and I hope that the GHC developers can fix the issue in time for the next
point release of GHC.

# Update #

The first problem is getting GHC to compile, assemble, and link 32-bit code.
This involves a modifying the `ghc` script as noted above, but also requires
that you pass a bunch of flags to `Setup` and cabal if the code you're
compiling links against external libraries (libcurl or libpq, for example). My
command lines look like this:

{% highlight sh %}
./Setup configure --ld-options="-arch i386" --gcc-option=-m32
{% endhighlight %}

The `--gcc-option=-m32` probably isn't necessary (the `-optc-m32` inserted in
`/usr/bin/ghc` does the very same thing), but the other option is required to
convince the linker to use the correct architecture. Otherwise linking will
fail and you'll get nothing or, even worse, a broken library or executable.
This could probably even be incorporated into the `/usr/bin/ghc` edits above
(`-optl-arch\ i386` or similar might do it).

The second problem I encountered ([I've seen this problem before in the
context of Python packages](/2009/installing-pil-on-mac-os-x-leopard/)) is
managing to have 32-bit libraries to link against. This last point doesn't
matter if you aren't linking against external libraries, but if you are then
you may be installing some of *them* with
[Macports](http://www.macports.org/). In this case, do please make sure that
you install the *universal* variants of every package that you'll want to link
against. Without this you'll be installing *x86_64* only and the *i386*
Haskell code will not be able to link. The easiest way is to edit
`/opt/local/etc/macports/variants.conf` to contain `+universal` *before* you
start installing things. Because rebuilding every package is no fun.

If you're upgrading to Snow Leopard and already have a bunch of stuff
installed, then you might want to rebuild it all as universal. Make the change
mentioned above and then force macports to rebuild everything as
[suggested](http://weblog.rubyonrails.org/2009/8/30/upgrading-to-snow-leopard)
by the Ruby on Rails people:

{% highlight sh %}
sudo port selfupdate
sudo port sync
sudo port upgrade --force installed
{% endhighlight %}
