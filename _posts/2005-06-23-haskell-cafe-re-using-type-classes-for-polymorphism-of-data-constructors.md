--- 
wordpress_id: 1431
layout: post
title: "[Haskell-cafe] Re: Using type classes for polymorphism of data constructors"
wordpress_url: http://passingcuriosity.com/2005/haskell-cafe-re-using-type-classes-for-polymorphism-of-data-constructors/
---

[Re: Using type classes for polymorphism of data constructors](http://haskell.org/pipermail/haskell-cafe/2005-June/010434.html)

A message on the [Haskell-cafe](http://haskell.org/pipermail/haskell-cafe/)
mailing list gives an alternative (better, even) approach to the polymorphism
of formulae using differential types. It works just as well as my solution,
and results in much more complex (and therefore complete) types:

<code>Main> <span style="font-weight: bold;">:t (Impl (Prop "p") (Poss (Prop "p")))</span>Impl (Prop "p") (Poss (Prop "p")) :: PC2 PC0 (Modal1 PC0)</code>

I'm not yet sure which route I'll take. My approach results in a single data
type (PC, Modal, etc) for each language, which is good, but the types don't
mean much and it isn't Haskell-98 (or, at least, Hugs won't load it as such).
Ralf's approach also works, the types is assigns formulae contain more
information and it **is** Haskell-98.

I'll probably wind up using a version based on Ralf's example, unless I run
into problems.
