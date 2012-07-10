--- 
wordpressid: 1423
layout: post
title: Parsing stuff in Haskell
wordpressurl: http://passingcuriosity.com/2005/parsing-stuff-in-haskell/
---
I've just started looking parsing in Haskell with <a href="http://www.cs.uu.nl/people/daan/parsec.html">Parsec</a>. After a few hours of reading the <a href="http://www.cs.uu.nl/people/daan/download/parsec/parsec.pdf">documentation (PDF, 424K)</a>and poking at the examples, I've managed to hack together a parser for my little language.<br /><br />Only a few hours after I started looking at Parsec, I've got a prototype which generates code in an abstract syntax suitable for passing to a semantics checker and code generator (the system will generate Haskell from specs written in my DSL, which is then linked against some infrastructure). Very cool. Haskell is great for my productivity.
