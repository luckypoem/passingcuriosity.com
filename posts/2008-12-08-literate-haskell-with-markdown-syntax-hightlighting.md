---
wordpressid: 394
wordpressurl: http://passingcuriosity.com/?p=394
layout: post
title: Literate Haskell with Markdown and Syntax Highlighting
tags: haskell, literate programming, markdown, syntax, pandoc, latex
location: Perth, Western Australia
excerpt: 
  This post describes the scripts I (used to) use to turn a literate Haskell
  programme (with Markdown formatted literate comments) into HTML and PDFs
  using Pandoc.
---

There are two schools of thought when it comes to documenting programs and
libraries: some embed fragments of code within the documentation (so called
"*literate* programming") and others embed fragments of documentation in their
code (i.e. comments). The "comments" approach makes it easy to generate API
documentation and the like (a feature [built-in to Haskell's Hackage
system][haddock]) but help me write blog posts and other documents containing
code, which is where literate programming shines. Happily, Haskell supports
both of these approaches and has a few rather useful tools available to make
both easier. In this post, I'll describe how to take literate Haskell with
Markdown formatted text and produce syntax highlighted documents in HTML and
PDF.

The basic idea of literate programming is that my document is a sequence of
code "chunks" and documentation "chunks". Haskell tools can ignore the
documentation chunks when compiling the code and documentation tools can
ignore or, hopefully, prettyify the code when preparing the document for
publishing. The [Haskell 98 report][literate98] describes two ways to denote
code chunks in a literate Haskell file: the TeX way and with "Bird tracks". In
the TeX way, each block of code is wrapped with TeX macros:

``````latex
\begin{code}
-- Some Haskell
\end{code}
``````

whereas with "Bird tracks" each code line begins with a `>`:

``````literatehaskell
> -- Some Haskell
``````

TeX style code chunks are excellent when my document is a TeX (common for
academic papers), and "Bird tracks" are more convenient when I'm writing
pretty much anything else (such as blog posts).

[Markdown][markdown] is a simple plain text syntax created by [John
Gruber](http://daringfireball.com/) designed to resemble the conventions of
e-mail so the "Bird tracks" style of literate Haskell is a good fit. It's
reasonably simply to learn so I won't bother to say any more about Markdown
itself.

Once I've got some literate Haskell all documented in Markdown I'm ready to
produce a document. The first step is to add syntax highlighting to the code
chunks using [hscolour][]. `hscolour` can generate its output in several
formats, but we'll use HTML with CSS styles. I'm a UNIX person, so I usually
use `hscolour` as a filter:

``````bash
    cat blah.lhs | hscolour -lit -css > blah.mkd
``````

This pipeline takes `blah.lhs`, performs syntax highlighting on it
(interpreting it as literate Haskell), generates HTML for use with CSS and
stores the result in `blah.mkd`. I've now got a file with with literate chunks
untouched (they're still Markdown) and the code chunks converted into HTML.
The next step is to convert this Markdown+HTML file into "pure" HTML for
publishing.

There are a few ways to convert Markdown into HTML: use the [pandoc][] Haskell
program, use the original
[`markdown`](http://daringfireball.net/projects/markdown/) perl program, rely
on your blogging software (many packages support [PHP
Markdown](http://michelf.com/projects/php-markdown/)), etc. `pandoc` is a
Haskell program, very fast, and can generate more than just HTML output, so I
use it quite a bit. Again, I tend to use `pandoc` as a filter:

``````bash
    cat blah.mkd | pandoc -sS --no-wrap -c hscolour.css > blah.html
``````

This pipeline takes `blah.mkd`, translates it from Markdown to HTML (both
options are the implicit defaults) and puts the result into `blah.html`. It
also uses fancy typography (`-S`), creates a complete document ('-s'),
includes a link to the `hscolour.css` stylesheet, and does *not* wrap the
code. This last point is essential if the document contains `hscolour` output
-- if it *does* wrap the code, then the highlighted Haskell code will be
displayed incorrectly.

I often combine both steps into a single pipeline:

``````bash
cat blah.lhs | hscolour -lit -css | pandoc --no-wrap -sS -c hscolour.css \
> blah.html
``````

Generating a PDF by way of LaTeX is simple -- just change the output format
for both `hscolour` and `pandoc`:

``````bash
cat blah.lhs | hscolour -lit -latex | pandoc --no-wrap -sS -t latex \
> blah.tex
``````

and then do whatever you normally do to get a PDF:

``````bash
pdflatex blah.tex && pdflatex blah.tex && pdflatex blah.tex 
``````


But I usually cram all of this into a `Makefile`:

``````makefile
.SUFFIXES: .lhs .mkd .html .tex .pdf

PANDOC := pandoc --no-wrap -sS
HSCOLOUR := hscolour -lit

.lhs.mkd:
    cat $< | $(HSCOLOUR) -css > $@

.lhs.html:
    cat $< | $(HSCOLOUR) -css | $(PANDOC) -t html -c hscolour.css > $@

.lhs.tex:
    cat $< | $(HSCOLOUR) -latex | $(PANDOC) -t latex> $@

.tex.pdf:
    pdflatex $< && pdflatex $< && pdflatex $<
``````

And call `make` to sort it all out for me:

``````bash
make blah.html
``````

[haddock]: http://haskell.org/haddock/ "Haddock: A Haskell Documentation Tool"
[literate98]: http://www.haskell.org/onlinereport/literate.html "Haskell 98 Report -- 9.6 Literate comments"
[pandoc]: http://hackage.haskell.org/cgi-bin/hackage-scripts/package/pandoc "The Pandoc package on Hackage"
[hscolour]: http://hackage.haskell.org/cgi-bin/hackage-scripts/package/hscolour "The hscolour package on Hackage"
[markdown]: http://daringfireball.net/projects/markdown/syntax
