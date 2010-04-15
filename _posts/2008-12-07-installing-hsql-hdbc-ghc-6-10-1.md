--- 
wordpress_id: 377
layout: post
title: Installing hsql and HDBC on GHC 6.10.1
wordpress_url: http://passingcuriosity.com/?p=377
---
I've become more interesting in using Haskell for web development lately, so I've started playing around with it a bit. As so much of web development is CRUD, that means I'll need a database access library. There are a two real options[^1] to consider when it comes to accessing SQL databases from Haskell: [hsql](http://hackage.haskell.org/cgi-bin/hackage-scripts/package/hsql) and [HDBC](http://software.complete.org/hdbc). The former has a native MySQL driver and the latter is actually maintained, but neither will build with the current GHC and Cabal without assistance. The rest of this post describes the [small] changes necessary to get both packages built and installed with GHC 6.10.1.

<!--more--> 

You may encounter numerous errors when trying to build hsql or HDBC, but most of them are pretty trivial to resolve. hsql 1.7 doesn't import a module that it needs, resulting in and error like this:

    Database/HSQL.hsc:66:7:
        Could not find module `System.Time':
          it is a member of package old-time-1.0.0.1, which is hidden

Just add `old-time` to the list of modules needed to build it in `hsql.cabal`:

    build-depends:  base, old-time

and try again. Next it will complain about a language extension being disabled (the messages mention things like `-XRankNTypes`). There are a few errors like this. Each time you see a new one, you can just add the extension it mentions (without the `-X`) to the list in `hsql.cabal` like so:

    extensions:     ForeignFunctionInterface, TypeSynonymInstances, CPP, RankNTypes

Finally, you'll get an error like:

    Database/HSQL/Types.hs:145:23: Not in scope: `throwDyn`

This is because it's being built against the new base library, when it needs things from the *old* one. There are two ways[^2] to fix this: tell Cabal to use the old base library, or change the code to look in the write place in the new base library. To use the old library (quickest and easiest) modify the `build-depends` line in `hsql.cabal` to specify a version:

    build-depends: base == 3.*, old-time

or pass it in as an argument to the `configure` phase:

    runhaskell Setup.lhs configure --constraint='base<4'

If you want to change the code instead, you'll need to change references to `Control.Exception` to `Control.OldException`[^3]. 

You may also encounter these errors when installing the various database driver modules. Just take the same approaches to each type of error and everything should go fine (GHC 6.10.1, Mac OS X 10.5.5). 

HDBC suffers from the same "old exception problem". You can either make it use the old version of `base`, or change the references to `Control.Exception` to `Control.OldException`. One that's done, you can install HDBC with:

    runhaskell Setup.lhs configure
    runhaskell Setup.lhs build
    runhaskell Setup.lhs haddock
    sudo runhaskell Setup.lhs install --global

Once you've installed the database driver modules of your choice (I used sqlite3 with both), you should be able to access databases from Haskell.

[^1]: [Takusen](http://hackage.haskell.org/cgi-bin/hackage-scripts/package/Takusen) is another (very interesting) alternative, but it has a funky `Setup.hs` that doesn't work with the Cabal version shipped with GHC. You'll have to wait for the maintainers to fix it.

[^2]: Both solutions were suggested in a [haskell-cafe@ thread about building HDBC](http://www.haskell.org/pipermail/haskell-cafe/2008-November/050307.html) by [Thomas Schilling](http://www.haskell.org/pipermail/haskell-cafe/2008-November/050312.html) and [Don Stewart](http://www.haskell.org/pipermail/haskell-cafe/2008-November/050313.html)

[^3]: Mentioned the [HDBC bug tracker](http://software.complete.org/software/issues/show/112).
