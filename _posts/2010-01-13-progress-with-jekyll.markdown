---
layout   : post
title    : Progress with Jekyll
tags     : [web, development, jekyll, meta]
location : Perth, Western Australia
excerpt  : |
  I've made a bit of progress hacking on this blog the last few nights...
---

I started this new incarnation of Passing Curiosity with stock [Jekyll][mjj],
the content [imported][mji] imported from my old Wordpress blog, and [Mark Reid][mr]'s excellent Creative Commons licenced [design][mrn].

[mji]: http://wiki.github.com/mojombo/jekyll/blog-migrations
[mjj]: github.com/mojombo/jekyll
[mr]: http://mark.reid.name/
[mrn]: http://github.com/mreid/mark.reid.name/

I pared it back from Mark's more complex use case and reworked the templates
and stylesheets a bit to make them more HTML5-y, but there's still a way to
go. Eventually, I'd like to use the new [semantic tags][tag5] throughout and
make the design my own.

[tag5]: http://diveintohtml5.org/semantics.html

I tweaked the 404 page to (naïvely) extract the words from bad URLs and
pre-fill the Google search box. Still on the search engines theme I also added
an [XML Sitemap][smp] template -- which lists the index, archive, and every
post -- and a `robots.txt` which references it.

[smp]: http://sitemaps.org/

Following [Benjamin Thomas][bt]' [guide][btc] I now use a custom `jekyll`
command which loads extension code when processing the site (without having to
fork Jekyll itself). At the moment, this is just loading [Jack Moffitt][jm]'s
[`html_truncatewords`][jmt] filter.

[bt]: http://benjaminthomas.org/
[btc]: http://benjaminthomas.org/2009-10-21/custom-liquid-tags-in-jekyll.html
[jm]: http://metajack.im/
[jmt]: http://github.com/metajack/jekyll/blob/master/lib/jekyll/filters.rb

The new filter is used in the index, archives, and Atom feed templates and the
`<meta>` tags to generate a description when a post does not have an excerpt.
I plan on extending the set of meta-data included in each page to include as
much of the [Dublin Core][dc] [Element Set][dces] as makes sense. Some of it
will come from the site and post YAML data, but others will need custom Liquid
tags to determine the correct values automatically.

[dc]: http://dublincore.org/
[dces]: http://dublincore.org/documents/dces/

In all, it's been a busy couple of evenings but Jekyll is refreshingly simply
and delightfully easy to start hacking with.

[lca]: http://www.lca2010.org.nz/ "linux.conf.au 2010 in Wellington, New Zealand"
[ds]: http://wellington2010.drupalsouth.net.nz/
[eotw09]: /2009/edge-of-the-web-2009-notes/