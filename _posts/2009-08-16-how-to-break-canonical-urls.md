--- 
wordpressid: 1883
layout: post
title: Reversing the arrow; or how to break canonical URLs
wordpressurl: http://passingcuriosity.com/?p=1883
---

My colleagues and I have recently been working to improve our practices when
it comes to semantic mark-up, document structure, metadata, and other fun
stuff. Part of this has entailed developing (or having Pierre, who was doing
an internship with us at the time, develop) metadata management features for
[the CMS we use][spip]. This new plug-in has a number of features, which
basically boil down to automatically generating a number of `<meta />` and
`<link />` elements based on the client's data.

[spip]: http://www.spip.net/ "SPIP"

This is all fairly normal -- any CMS that *doesn't* do this (either by default
or with the help of a plug-in or extension of some sort) is pretty defective
-- but it can raise a few issues, especially when we make mistakes. In the
rest of this post I'll describe our mistake and it's effects.

## Generating metadata ##

Our [metadata plug-in](http://www.spip-contrib.net/Plugin-SEO,3121) has four
main features. It can:

1. generate (and, if configured, let the user manage) page metadata;
2. generate canonical URIs;
3. embed Google Webmasters Tools verify; and
4. embed Google Analytics tracking code.

The metadata the plug-in embeds include title, description, keywords, copyright, and authorship  `<meta />` elements, and a [robots directive][robots]. If it's enabled it'll also output `<meta />` and `<script>` elements for Google Webmaster Tools and Google Analytics (we're looking at extending this support for other tools including [Xiti][xiti]).

[robots]: http://www.robotstxt.org/meta.html
[xiti]: http://www.atinternet.com/en/Products/XiTiFree.aspx

The problem, and the topic of this post, is our support for canonical URLs. The "Canonical URLs" feature is a exactly what it sounds like: a method which allows a document to specify the official, *canonical* URL by which it's content should be indexed and accessed. This helps resolve the "duplicate content" problem and is supported and encouraged by Google (see [Specify your canonical](http://googlewebmastercentral.blogspot.com/2009/02/specify-your-canonical.html)), Yahoo! (see [Fighting Duplication: Adding more arrows to your quiver](http://www.ysearchblog.com/2009/02/12/fighting-duplication-adding-more-arrows-to-your-quiver/)), Bing (see [partnering to help solve duplicate content issues](http://www.bing.com/community/blogs/webmaster/archive/2009/02/12/partnering-to-help-solve-duplicate-content-issues.aspx)) and Ask.com (see [Ask Is Going "Canonical"!](http://blog.ask.com/2009/02/ask-is-going-canonical.html)), amongst others.

## The problem ##

Our plug-in currently includes markup like this on every page it generates:

{% highlight html %}
<link rev="canonical" href="http://example.com/An-Article.html" />
{% endhighlight %}

If your familiar with [X]HTML, you may have noticed a problem with this: we've
used the `@rev` attribute instead of a `@rel`. This is a small difference --
just a single character; just three bits difference in ASCII -- but the effect
on the semantics of the metadata we're generating and embedding on every page
is large.

### `rel` vs. `rev` ###

The `@rel` attribute specifies the *relation* between the subject (the
document containing the `<link>`) and the *object* (the URI specified in the
`@href`). That is, `<link rel="help" href="help.html" />` says that the `help`
for this document is `help.html`. It's like an arrow pointing *from* this
document, to another document.

The `@rev` attribute, on the other hand, inverts this meaning. That is, `<link
rev="help" href="foo.html" />` says that this document is the `help` for
`foo.html`. It's like an arrow pointing *to* this document from some other
document.

Allowing this reversed relation may make sense for some relationships (namely,
those which are ignored by pretty much everything), but with something like
*canonical* -- which is interpreted by search engines -- it can be dangerous.
Our metadata plug-in is generating code which says, on every version of every
page (and every page has as many as half a dozen URIs under SPIP), you
shouldn't use that page (the genuine canonical URL), *I'm* the real deal! That
is, we're telling the world at large that the canonical URL is *not*
canonical. This is bad and wrong (though I suspect that the search engines
probably just ignore such claims).

Needless to say, I'm going to fix this (or have one of the others do it) and
push the new version to our sites first thing on Monday morning.

### Why does such a thing exist? ###

In the mean time, I wondered why anyone could possibly want such a thing? I've
not read too much into this topic, but it seems reasonable to think that the
`@rel` attribute was originally included for the sake of symmetry. Alas,
symmetry is great in a closed system -- one where you *can* trust all claims
because you know that every part of the system can be trusted -- but can cause
problems in an open system like the web -- where you *can't* necessarily trust
every participant in the system.

Given that we *have* `@rev` (though it's probably going to go away in HTML5,
and similar updates to XHTML), what is it used for? One use case is using URL
shortening services like [TinyURL](http://tinyurl.com),
[Bitly](http://bit.ly/), [Tr.im](http://tr.im/), etc. If you use
[Twitter](http://twitter.com/) or some similar service you're probably
familiar with these: they essentially give a shorter alias to a long URL.
Doing this with a reversed canonical is patently stupid (see [Counting the
ways that rev="canonical" hurts the
Web](http://www.mnot.net/blog/2009/04/14/rev_canonical_bad) for the reasons
*why* its stupid), and I'm pretty sure no search engine or semantic web
application will actually use it (intentionally, at least), but there you go.

## Conclusion ##

For more information, see the ["rel" attribute frequently asked
questions](http://microformats.org/wiki/rel-faq) at the [Microformats
wiki](http://microformats.org/wiki/), or search the web for such phrases as
["canonical url rev
rel"](http://www.google.com/search?q=canonical+url+rev+rel). There's plenty of
information out there.

Thanks to Pierre Rousset (who still needs a web-site I can link to when I
mention him) for his typo which lead me to this interesting topic, [Mark
Aeschlimann](http://odysseyweb.com.au/) who noticed and questioned it, and the
various people who've written about and documented `<link>`, `@rel`, `@rev`
and related topics.
