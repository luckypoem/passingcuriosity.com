---
wordpressid: 1675
layout: post
title: Transactional memory with data invariants (DRAFT)
tags: papers, cs, stm, haskell
wordpressurl: http://passingcuriosity.com/2006/transactional-memory-with-data-invariants-draft/
excerpt: |
  A few thoughts about a draft paper Transactional memory with data
  invariants.
---

*Transactional memory with data invariants* ([PDF][pdf]) by Tim Harris and
Simon Peyton Jones. Draft, under submission.

[pdf]: http://research.microsoft.com/~tharris/drafts/2006-invariants-draft.pdf

The authors present an extension to a *software transactional memory* system
(GHC with STM support) which automatically checks programmer specified data
invariants and rejects transactions which break them. They present a number of
examples illustrating the power of the concept:

* **range-limited variables** - variables the values of which cannot exceed a
  certain limit [at the end of a transaction, when the invariants are
  checked];

* **sorted lists** - a list of values that are maintained in ascending order
  specified as an invariant on individual nodes, or one whole lists; and

* **invariants as guards** - where invariants are used as guards on operations
  (and can block transactions, etc.)

This is yet another really interesting paper about software transactional
memory.

[Edit: The final version of the paper has been released and I have posted [my
comments](/2006/transactional-memory-with-data-invariants/)]
