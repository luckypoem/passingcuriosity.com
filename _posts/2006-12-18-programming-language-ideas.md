---
wordpressid: 1402
layout: post
title: Programming language design ideas
wordpressurl: http://passingcuriosity.com/2006/1402/
---
This post will contain some of my musings on programming language design. At some point, my first programming language will be based on these ideas.

Transactions are an interesting solution to maintaining the consistency of shared memory concurrent systems, while the ?-calculus seems to be the bee's knees for distributed systems and the join calculus looks pretty cool for concurrency all round. I'm sure it's been done, but an extension of the join calculus to work over communication channels such as are used in the ?-calculus might be an interesting and useful foundation for a language.

Automatic parallelisation and vectorisation of code will be an interesting problem, particularly for areas like statistics and numerical analysis which are currently served by languages like [R](http://www.r-project.org/). Combining a real type-system with automatic vectorisation of folds and maps would, I think, make a more elegant and probably-not-slower solution to the problem, though it might lessen the ability to do exploratory programming.
