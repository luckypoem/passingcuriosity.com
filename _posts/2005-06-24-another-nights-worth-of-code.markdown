--- 
wordpress_id: 1433
layout: post
title: Another Night's Worth of Code
wordpress_url: http://passingcuriosity.com/2005/another-nights-worth-of-code/
---
I've just finished the first major part of my first step along the road to [real] implementation: I now have a working type for propositional calculus, a simple representation of a tableau branch, can saturate said branch (modulo the rules which branch) and generate a model (which is simply a list of literals at this point).<br /><br />Next, I need to extend this tableau implementation to support branching and then complete the logic with correct rules for branching connectives (disjunction and implication). Once that is done, I'll rewrite my language parser and code generator so that I can actually generate this implementation of the propositional calculus from the definition.<br /><br />Once that is done, I'll move on to the basic propositional modal logic: K. Getting K to work will require that I implement labels, relations and extend my language so that it can import and extend existing logics. Once that is done, I'll move onto a more complex modal logic (perhaps S4) before tackling intuitionistic logic (which uses two-part labels).
