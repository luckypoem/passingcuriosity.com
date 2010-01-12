--- 
wordpress_id: 1431
layout: post
title: "[Haskell-cafe] Re: Using type classes for polymorphism of data constructors"
wordpress_url: http://passingcuriosity.com/2005/haskell-cafe-re-using-type-classes-for-polymorphism-of-data-constructors/
---
<a href="http://haskell.org/pipermail/haskell-cafe/2005-June/010434.html"> [Haskell-cafe] Re: Using type classes for polymorphism of data constructors</a><br /><br />A message on the <a href="http://haskell.org/pipermail/haskell-cafe/">Haskell-cafe</a> mailing list gives an alternative (better, even) approach to the polymorphism of formul&aelig; using differential types. It works just as well as my solution, and results in much more complex (and therefore complete) types:<code>Main&gt; <span style="font-weight: bold;">:t (Impl (Prop "p") (Poss (Prop "p")))</span><br/>Impl (Prop "p") (Poss (Prop "p")) :: PC2 PC0 (Modal1 PC0)</code>I'm not yet sure which route I'll take. My approach results in a single data type (PC, Modal, etc) for each language, which is good, but the types don't mean much and it isn't Haskell-98 (or, at least, Hugs won't load it as such). Ralf's approach also works, the types is assigns formul&aelig; contain more information and it <span  style="font-weight: bold;">is</span> Haskell-98.<br /><br />I'll probably wind up using a version based on Ralf's example, unless I run into problems.
