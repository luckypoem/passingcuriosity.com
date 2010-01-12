--- 
wordpress_id: 1617
layout: post
title: No Thru Road!
wordpress_url: http://passingcuriosity.com/2005/no-thru-road/
---
I've been playing with <a href="http://www.cse.unsw.edu.au/~dons/hs-plugins/"><code>hs-plugins</code></a>, trying to get a version of my generated propositional calculus code working as a dynamically loaded plug-in. I've run into some difficulties with the type signatures of the plug-in API, a concrete plug-in, and the plug-in user.<br /><br />I've tried using <a href="http://www.haskell.org/ghc/docs/5.00/set/existential-quantification.html">existentially quantified constructors</a> as well as the more usual with class-constrained type variables, but I haven't been able to make any progress. If I can't manage to resolve the problem, it looks like I'll have to find another approach, perhaps by building an executable for each calculus (though that would suck as it'd have to compile everything, from scratch, for each and every calculus to get it to type-check).<br /><br />Worrying.<br /><br />If I can get it to work, I'll have an alpha release with support for K out as soon as possible.
