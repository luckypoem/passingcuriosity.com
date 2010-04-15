--- 
wordpress_id: 1643
layout: post
title: Lock-Free Data Structures using STMs in Haskell
wordpress_url: http://passingcuriosity.com/2005/lock-free-data-structures-using-stms-in-haskell/
---
<a class="title" href="http://research.microsoft.com/%7Esimonpj/papers/stm/lock-free.htm">Lock-Free Data Structures using STMs in Haskell</a>. Anthony Discolo, Tim Harris, Simon Marlow, Simon Peyton Jones, and Satnam Singh. Submitted to FLOPS'06.<br /><br />An interesting paper demonstrating the use of STM (and it's superiority over explicit locking) in Haskell. The authors present two Haskell implementations of the ArrayBlockingQueue class from Java: one using STM and the other explicit locking. Not only did the version using STM outperformed the explicit locking version consistently in the multi-CPU benchmarks, but the STM code is <emph>much</emph> simpler.<br /><br />Previously: <a href="http://troacss.blogspot.com/2005/01/composable-memory-transactions.html">1</a> <a href="http://troacss.blogspot.com/2005/01/more-on-composable-memory-transactions.html">2</a><br /><a href="http://lambda-the-ultimate.org/node/view/1151">LtU</a> | <a href="http://del.icio.us/url/a901a1a4275c9867e3f39986ef16e648">Del.icio.us</a>
