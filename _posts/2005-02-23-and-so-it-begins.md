--- 
wordpress_id: 1562
layout: post
title: And so it begins...
wordpress_url: http://passingcuriosity.com/2005/and-so-it-beings/
---
On Friday, Pietro gave me a few papers and chapters to read regarding the theoretical aspect of my Honours project: techniques for extracting counter-models from open tableaux and implementing these techniques (or at least support for them) in the Tableau Work Bench. I've just finished my first reading of the first of these papers, and I'll note some points below.

----------------------

I've just gone over the research report  *A tableau system for modal logic S4 with an efficient proof-search procedure* by Toshimasa Matsumoto. It will take a few more readings (both of the paper itself and of those it references) before I get most of it, but it seems quite cool. As I understand it, the basic idea is to use the histories to prevent re-application of formulae and the attendant loops. This is quite straight forward. The bits I am still trying to wrap my head around are the way the tableau rules for <span style="font-style: italic;">C</span><span style="font-weight: bold;">S4</span> accomplish this. I think that I've nearly got it worked out in my head, I just need to think about it a bit more.

What happens is applying rule (T) takes <tt>&Gamma;, <span class="BOX">&#9744;</span>&alpha;</tt> to <tt>&Gamma;, <span class="BLACKBOX">&nabla;</span>&alpha;, &alpha;</tt> and does not modify the history. When the transitional rules, (S4)<sub>s</sub> and (S4)<sub>t</sub> are applied, the <tt><span class="BLACKBOX">&nabla;</span>&alpha;</tt> is converted back to <tt><span class="BOX">&#9744;</span>&alpha;</tt> and is recorded in the history iff the current history is strictly smaller (i.e. subset but not equal to) than the history with <tt><span class="BOX">&#9744;</span>&alpha;</tt> added to it, i.e. the history does not already contain <tt><span class="BOX">&#9744;</span>&alpha;</tt>. This is cool, and I almost understand how the tableau rules do it.

The (T) rule, unless I am completely wrong, replaces the <span class="BOX">&#9744;</span> tree rule I am familiar with. The (S4)<sub>s</sub> and (S4)<sub>t</sub> rules replace the <span class="DIAMOND">&loz;</span> rule I am familiar with. The (S4)<sub>s</sub> and <sub>t</sub> rules also keep track of the applied <span class="BOX">&#9744;</span>s by updating the history. This is somewhat the equivalent of ticking the <span class="DIAMOND">&loz;</span>, and noting a world for a <span class="BOX">&#9744;</span> in the system I learnt last year.

The completeness proof, proof of termination and time complexity analysis all look interesting, but the most important part of the paper, for my purposes, is the section on constructing counter-models from an open tableau. As well as being relevant to what I'll be working on, this section was easier to read, as its content was somewhat familiar.

PS: I have used &nabla; above to stand in for the filled box used in the paper, primarily because I can't be bothered making an image of a black box. In addition, neither the &#9744;, nor the &loz; are all that appropriate either.
