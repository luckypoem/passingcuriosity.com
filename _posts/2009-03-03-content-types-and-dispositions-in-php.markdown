--- 
wordpress_id: 446
wordpress_url: http://passingcuriosity.com/?p=446
layout   : post
title    : Content types and dispositions in PHP
location : Perth, Western Australia
excerpt  : |
  Exporting data as CSV is pretty run of the mill for most web developers 
  (though generating "valid" CSV is not exactly trivial), but every time I do
  I find myself figuring out how to force the browsers to save it to a file.
  This quick post is about using a Content-Disposition header to strongly 
  suggest that browsers save the data to a file.
---

This is more for myself than the world (I keep forgetting it and have to look
it up every time I need it), but it's a blog post and it's on the Third so it
counts for [World Blogging Month][woblomo].

[womoblo]: http://woblomo.com/ "March is World Blogging Month (WoBloMo)"

Exporting data is an important feature for almost any web-application, but
it's one that many implement poorly or skip all together. Most of my day job
is focused on creating static-ish web-sites, but every now and again I need to
gather and process data in ways that my normal tools can't handle. When I
*do*, I inevitably reach for CSV when it comes time to export data. Producing
CSV is a potentially complex and messy business: there are so many different
conventions for quoting and escaping that the name "comma separated values" is
really the least important aspect of the whole thing.

That said, I normally don't bother with any of that and just (being, of
necessity, a PHP user):

{% highlight php %}
    <?php
    echo implode(",", $values), "\n";
    ?>
{% endhighlight %}

It's probably just a bunch of integers anyway, so there won't be any commas
anyway.

After I've got that working, I need to force the browser to prompt the user to
save the file otherwise the clients -- many not particularly computer literate
-- will get all confusified. Thankfully, the W3C have considered this (or the
people who wrote the MIME RFCs, I'm not entirely sure which is the chicken and
which the egg) and given us a mechanism to specify exactly this: the
*Content-Disposition* header in HTTP/1.1.

A *Content-Disposition* header looks something like this (from [RFC2183][]):

<pre><code lang="http">
    Content-Disposition: attachment; filename=genome.jpeg;
      modification-date="Wed, 12 Feb 1997 16:29:51 -0500";
</code></pre>

Like many headers, the value (the bit after the colon) can have several parts
separated with a semicolon. The first part (`attachment` in the example above)
tells the browser what to do with this content. "Attachment" indicates that
this is an attachment, as opposed to content which ought to be displayed, and
should be downloaded or indexed or whatever the client usually does with such
things. The `filename` parameter tells the client the original filename
associated with the content, generally so that the client can display the
correct default in the whatever "save as" dialogue it displays to the user.
The final parameter in the example specifies the date that the content was
last modified, again so that the client can set the date on the file if it is
saved.

Sending *Content-Disposition* is as easy as sending any other header with
HTTP. In PHP, my code generally looks a little something like this (Notice
that the `filename` parameter is quoted, as [RFC2616][] describes):

{% highlight php %}
    $filename = "thingo-". date('Y-m-d H:i') .".csv;
    header("Content-Type: text/csv");
    header("Content-Disposition: attachment; filename=\"$filename\""
{% endhighlight %}

After which, I'm ready to loop and `echo` away.

Alternatively, pretty much every browser out there will prompt the user to
save a file with the `application/octet-stream` MIME type. Sending such a MIME
type instead of a *Content-Disposition* header will save you a few dozen bytes
and a function call which could -- conceivably -- go wrong, but it *doesn't*
specify a filename, so you're liable to wind up with your script's name (often
something like `export.php`).

It's important to note that, while it is widely implemented, the
*Content-Disposition* header is **not** part of the HTTP standard and does
have [security implications](http://tools.ietf.org/html/rfc2183#page-9)
(though these generally boil down to: some users are stupid and trust things
that come through the intertubes).

[RFC2183]: http://tools.ietf.org/html/rfc2183 [RFC2616]:
http://www.w3.org/Protocols/rfc2616/rfc2616-sec19.html#sec19.5.1
