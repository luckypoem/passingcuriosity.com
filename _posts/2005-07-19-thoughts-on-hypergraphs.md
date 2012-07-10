--- 
wordpressid: 1443
layout: post
title: Thoughts on Hypergraphs
wordpressurl: http://passingcuriosity.com/2005/thoughts-on-hypergraphs/
---
<emph>I'll start this post with a disclaimer that I am a mathematically naive person and don't really know what I'm talking about.</emph><br /><br />After my <a href="http://labelledtableaux.blogspot.com/2005/07/renovation-in-progress.html">post</a> last night (or this morning), I though a bit more about hypergraphs and started playing with a few ideas for a data structure based on incidence lists (lists of every edge incident on a particular vertex). While I've got something that works (after a fashion and in a naive and trivial sort of way), I've come to a realisation that I don't really know what a lot of the things I might want to do to such graphs actually mean.<br /><br />What,if anything, do reflexivity, transitivity and symmetry mean in the context of a hypergraph? I've been trying to figure this out using the composition relation from arrow logic as an example but I'm still not sure I'm getting anywhere.<br /><br />Be that as it may, I've started working on a prototype of a hypergraph package for Haskell and if I can figure out how various things ought to work and how to generalise it to relations of arbitrary arity, I'll release it separately.
