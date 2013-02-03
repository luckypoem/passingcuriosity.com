---
wordpressid: 139
wordpressurl: http://passingcuriosity.com/?p=62
layout: post
title: The SPIP Template Language
tags: spip
location: Perth, Western Australia
excerpt: |
  
---

SPIP, like many content management systems, provides a templating facility
based on the idea of loops. A template is a mixture of static content -- HTML
tags, for instance -- dynamic content placeholders -- that stand for things
like "the title", "the body", "the date of publication", etc.-- and loops --
which determine what and how much is displayed. Unlike some CMS', SPIP uses a
rather sophisticated language for its template system rather than just
providing a library of PHP functions that can be called. The placeholders in
SPIP templates look like `#VALUE` and can be supplied with arguments
`#VALUE{argument}`, modified using filters `#VALUE|uppercase` (which can also
take arguments `#VALUE|foo{bar}`), and bracketed with conditional content
which is output only when the tag has a non-empty `[<li>(#VALUE)</li>]`. I
can't remember if it's necessary, but I always wrap any tag with a parameter
or filter with brackets, just in case.


The loops look somewhat stranger with a pseudo HTML tag format. In general
each loop has :

- a name;

- a type (of things it iterates over, pretty much 1-to-1 with database
   tables);

- some of criteria (determine *which* things to loop over);

- a body; *and*

- optionally, some conditional content.

An example will help illustrate:

{% highlight html %}
    <B_aloop>
        <ol>
        <BOUCLE_aloop(ARTICLES){id_article IN 1,2,3,5,7,11}>
            <li>This article was published on: [(#DATE|affdate('Y'))].</li>
        </BOUCLE_aloop>
        </ol>
    </B_aloop>
        <p>There are no matching articles.</p>
    <//B_aloop>
{% endhighlight %}

Upon seeing this code SPIP does the following (along with some other stuff in
the database and caching layers). It retrieves all of the articles with an ID
of 1, 2, 3, 5, 7, or 11. If there *are* some articles it outputs `<ol>`,
followed by a line like `<li>This article was published on: 2008</li>` for
each article, followed by `</ol>`. If there were no matching articles, then it
instead outputs `<p>There are no matching articles.</p>`.

There are a few more details (the name of the loop above is "_aloop" not
"aloop", you can reach out of a loop to one that contains it like so
`#outerloop:VALUE`...), but that's basically it. For more details about the
specific loops, criteria, tags, and filters available in SPIP you can see the
[SPIP Glossary](http://www.spip.net/@?lang=en), though do note that SPIP, like
pretty much all open source software, has documentation that is a little bit
patchy in places, especially in English.

In my next SPIP post, I'll describe ways to extend SPIP with your own tags and
filters and alter on, I'll explore modifying and even creating our own custom
loops.
