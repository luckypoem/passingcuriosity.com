---
wordpressid: 1526
layout: post
title: LaTeX output for HsColour
wordpressurl: http://passingcuriosity.com/2006/latex-output-for-hscolour/
---
On a somewhat related subject to my last post (<a href="http://interestingexperience.blogspot.com/2006/05/wanted-latex-packages.html">the one about LaTeX</a>), I've just started working on adding LaTeX support to <a href="http://www.cs.york.ac.uk/fp/darcs/hscolour/">hscolour</a>. The structure of the program has made it easy to add support for LaTeX output: all I had to do is add two items to a pattern match (for option handling), and define a function to render the code to LaTeX (plus a few helpers to escape LaTeX special characters, <emph>etc.</emph>).<br /><br />Once I've managed to get it working adequately, I'll submit a darcs patch to the maintainer.<br /><br />See also Malcolm's posts about hscolour: <a href="http://nhc98.blogspot.com/2005/12/colourising-code.html">one</a> and <a href="http://nhc98.blogspot.com/2006/01/improvements-to-hscolour.html">two</a>.<br /><br /><span class="tags"><strong>Tags:</strong> <a rel="tag" href="http://del.icio.us/thsutton/haskell">Haskell</a> <a rel="tag" href="http://del.icio.us/thsutton/latex">LaTeX</a></span>
