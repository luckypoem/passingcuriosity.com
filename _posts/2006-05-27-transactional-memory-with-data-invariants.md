--- 
wordpressid: 1696
layout: post
title: Transactional memory with data invariants
tags: CS, Papers, Haskell
wordpressurl: http://passingcuriosity.com/2006/transactional-memory-with-data-invariants/
excerpt: |
  A few thoughts about a Transactional memory with data invariants by Tim
  Harris and SPJ.
---

*Transactional memory with data invariants* by Tim Harris and Simon Peyton
Jones. To appear in TRANSACT '06 ([PDF][pdf]).

[pdf]: http://research.microsoft.com/~tharris/papers/2006-transact.pdf

I [comment previously](/2006/transactional-memory-with-data-invariants-draft/)
on a draft version of this paper. In this 'final' version the authors have
removed the wrapper function which converted predicates (`:: STM a -> STM
Bool`) into actions that raise exceptions when the invariant doesn't hold (`::
STM a -> STM ()`) leaving the interface a little more consistent.

They have extended the STM monad to use phantom types to restrict the
operations an STM action can perform (`ReadOnly` or `Full`) to help restrict
the side effects of invariants. Another addition is support for invariants
over pairs of states: the state before the transaction began, and the state
about to be committed. This is accomplished with a new primitive: `old :: STM
a -> STM a` which executes an STM action in the state as it was when the
current transaction began. Finally, there is some new discussion of drawing on
the work in databases where a distinction is made between *assertions*, which
detect error conditions, and *triggers*, which are part of the programmes
logic.

A good paper made even better!
