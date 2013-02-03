---
wordpressid: 1436
layout: post
title: Done! or It's A Start!
wordpressurl: http://passingcuriosity.com/2005/done-or-its-a-start/
---

Last night (or, more correctly, this morning) I constructed a model: `~a, b`
for the formulae: `~a, a∨b` using only the tableau framework and an
automatically generated implementation of the propositional calculus:

<blockquote>Tableau> <span style="font-weight: bold;">prove [Neg (Prop "a"), Disj (Prop "a") (Prop "b")]</span><br/>Model [b,~a]</blockquote>

Now all I have to do is fix the bugs, extend what's there to labelled tableau
and test it all. :-)
