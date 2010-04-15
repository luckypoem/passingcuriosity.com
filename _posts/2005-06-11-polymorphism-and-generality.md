--- 
wordpress_id: 1426
layout: post
title: Polymorphism and Generality
wordpress_url: http://passingcuriosity.com/2005/polymorphism-and-generality/
---
One of the main goals of this project, to my mind at least, is generality. The prover must be easily extendable with support for a wide range (ideally, the entire range) of labelled tableaux calculi. Furthermore, it ought to be possible to define new logics as extensions to existing logics: propositional modal logic, for example, is an extension of the propositional calculus to support two new operators: &#9671; and &#9633;.<br /><br />Unfortunately, I've not been able to get determine just how to get this level of flexibility to work under Haskell's type system. I've asked the <a href="http://haskell.org/mailman/listinfo/haskell-cafe">Haskell-cafe</a> mailing list for pointers and, in the mean time, have moved on to doing this composition in the compiler for my mini-language rather than in the generated Haskell code.<br /><br />Hopefully, I'll get this to work as it will be quite useful and, unless I'm mistaken, interesting.
