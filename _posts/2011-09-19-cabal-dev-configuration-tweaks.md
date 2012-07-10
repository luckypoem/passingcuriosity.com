---
layout: post
title: Tweaking the configuration of cabal-dev 
categories: [haskell]
tags: [haskell, cabal-dev, sandbox, configuration]
location: Perth, Western Australia
excerpt: |
  While cabal-dev is great, I need to make a few tweaks to its default
  configuration before it's useful.
---

I like [`cabal-dev`][1] but it's been giving me trouble for a while now. Using
`sudo` to install into the sandbox as root and failing to build any
combination of packages that share module names are the two most egregious
faults which have basically put me off using Haskell for a while now. After a
little research, I've managed to resolve both issues.

`cabal-dev` works by creating a Cabal configuration file for each sandbox and
passing it to the normal commands it uses to perform the various operations it
supports. Changing the configuration in this file does not have any effect as
it is regenerated every time `cabal-dev` is invoked. Instead I had to edit the
template file:
`~/Library/Haskell/ghc-7.0.3/lib/cabal-dev-0.8/share/admin/cabal-config.in` (I
use the [Haskell Platform][2] package for OS X, your location might vary).

"Global" installation in a sandbox
----------------------------------

I've no idea why, but my `cabal-config.in` was configured to perform a
*global* installation by default. While global and user installations both put
their files in the same place, global installations used `sudo` to during the
installation process. Fixing this is a simple as changing the line:

    user-install: False

Clashing module names
---------------------

By far the most serious of the two problems was the clashing of module names
across packages. Amongst other things, I couldn't install [Snap][3] because it
depends on two packages which contain modules called `Control.Monad.CatchIO`.
Again, the solution is a change to `cabal-config.in`. Both of the
`install-dirs` sections ought to look something like:

    install-dirs user
      prefix: ./
      -- bindir: $prefix/bin
      -- libdir: $prefix/lib
      libsubdir: $pkgid/$compiler
      -- libexecdir: $prefix/libexec
      -- datadir: $prefix/share
      datasubdir: $pkgid
      docdir: $datadir/doc/$pkgid
      -- htmldir: $docdir/html
      -- haddockdir: $htmldir

Note that the lines mentioning `$pkgid` have been uncommented. This will
result in cabal creating a per-package directory for the libraries, data,
documentation, etc. from each package. No more file name collisions!

[1]: http://hackage.haskell.org/package/cabal-dev
[2]: http://hackage.haskell.org/platform
[3]: http://snapframework.com/
