--- 
wordpress_id: 1445
layout: post
title: More on Literate Haskell
wordpress_url: http://passingcuriosity.com/2005/more-on-literate-haskell/
---
I've been having fun extending my environment for literate Haskell programming in LaTeX. While I still haven't looked at the <a href="http://labelledtableaux.blogspot.com/2005/07/literate-haskell.html#comments">suggestion</a> my previous post provoked (though I'll get round to it eventually), I have been taking the opportunity to learn some of the more <emph>programme-y</emph> things one can do in LaTeX.<br /><br />The macro I use for the title of each module (called <span style="font-family: monospace;">\module</span> funnily enough) now checks to see if it is a sub-module (i.e. contains a '.' in its name) and makes it a <span style="font-family: monospace;">\subsection</span> if it does. For now, this will be enough, but later on there will be some configurability to this to make sure that we don't typeset modules as sub-sections of random other modules.<br /><br />I'm also planning on making the pretty-printing code build a list of imported modules as it typesets the Haskell and then include the appropriate files (I've got an <span style="font-family: monospace;">\import</span> macro all ready and waiting) afterward.<br /><br />I like playing with LaTeX.
