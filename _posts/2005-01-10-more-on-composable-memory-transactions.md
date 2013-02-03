---
wordpressid: 1551
layout: post
title: More on Composable Memory Transactions
wordpressurl: http://passingcuriosity.com/2005/more-on-composable-memory-transactions/
---

*Caveat: I am not an RTS expert, not a Haskell expert, nor a concurrency, languages, or OS guru. This little spiel is probably rife with errors, but I'll publish this post in the hope that someone will point them out.*

Having read the rest of the paper, its strikes me [even more than it did] just
how cool software transactional memory (STM) is. I wonder how effective it
would be in an language with object oriented features. In a language like
Haskell (what with its functional purity and laziness) it makes sense for the
atomicity of transactions to be guaranteed by the runtime systems thread
scheduler, but I couldn't help but see the potential the implementation in GHC
has for helping map Haskell threads onto OS thread primitives.

The simple scheme described in the paper for validating and committing
transactions might be extended, to allow concurrent validations and commits by
adding per TVar locks and locking the TVars accessed by a transaction. If I
recall correctly, deadlock and a number of other concurrency pitfalls could be
avoided by using a lock-ordering protocol of some description (probably just
ordering locks on the TVar pointer order). I'm not sure how much, if any,
improvement in throughput might be observed, but allowing concurrent commits
would probably increase the utility in adding more fine-grained multithreading
to Haskell, by easing the development of safe concurrent programs.

As I said at the top of this post, I am not an expert in any of the fields
touched on here, but I'd love to hear from those who are if anyone would like
to point out my errors.
