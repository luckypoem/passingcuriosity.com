---
wordpressid: 83
layout: post
title: Treatments, Typography, and Markdown for SPIP
wordpressurl: http://passingcuriosity.com/?p=144
categories: [php, spip]
excerpt: |
  A quick and rather hackish way to replace SPIP's built-in text
  markup format with Markdown.
---

SPIP is a great content management system, but there are a few of it's
features that I dislike. One of the most directly user visible is it's
formatting language for text content (the "typographical shortcuts").
This language is effective enough in many circumstances but I find it
a little ugly and it has some fairly important limitations (try doing
multiple paragraphs in a list item without hackish `<br/>`s, for
example). Thankfully, the "shortcuts" are implemented as a "treatment"
for the `#TEXTE`, etc. tags and can be overridden quite easily.

In this post I'll describe how SPIP's "treatments" work and how they
can be overridden. In the process, you'll see how to replace the
built-in typographical shortcuts with my favourite light-weight
mark-up language -- [PHP Markdown Extra][phpmd] and [Smartypants][sp]
-- as well as a few less intrusive "tweaks".

[phpmd]: http://michelf.com/projects/php-markdown/extra/
[sp]: http://michelf.com/projects/php-smartypants/

<!--more-->

SPIP's template language is based on the idea of loops -- which "loop"
over the results of a database query -- and "tags" -- which output the
value of a column from the current row[^1]. If all you want to do is
loop over the contents of a database table and output some values then
you don't have to "do" anything: 

{% highlight html %}
<BOUCLE_aloop(my_table){par acolumn}>
    #ACOLUMN
    #ANOTHER_COLUMN
</BOUCLE_aloop>
{% endhighlight %}

SPIP will do what you want without any additional code of
configuration (assuming that your table is called `my_table` and has
columns called `acolumn` and `another_column`). This "default"
behaviour (assuming that loops and tags match with tables and columns)
makes it very easy to add new loops and tags: just modify the database
schema and it all "works".

There are lots of circumstances, though, where some additional
processing will need to be done on values before they are suitable for
display. Perhaps some special characters need to be escaped or some
formatting applied before the data it is suitable for output. You
*could* just apply a filter to the tag each and every time you use it:

{% highlight html %}
[(#ANOTHER_COLUMN|process_data)]
{% endhighlight %}

Or implement the tag in PHP:

{% highlight php %}
function balise_ANOTHER_COLUMN_dist($p) {
    $p->code = 'process_data('
        .champ_sql('another_column', $p) 
        .')';
    return $p;
}
{% endhighlight %}

Thankfully, you don't have to filter the tag in every template, or
implement the tag in PHP to use such "treatments": you can just tell
SPIP what function/s to call with the `$table_des_traitements` global
variable.

The `$table_des_traitements` variable is an array of arrays (hence the
"`table`") which SPIP uses to figure out exactly how to process a raw
database value into something that is safe to output in a page. The
"first" dimension of the array is the tag name -- `TEXTE`, `DATE`,
etc. -- and the second is the loop -- `documents`, `articles`, etc.
When SPIP is evaluating a tag (whether or not it has been implemented
in PHP), it checks the `$table_des_traitements` array to see if there
is a "treatment" for that tag/loop combination or, failing that, for
the tag everywhere (the `0`th element in the array). This happens in
[`champs_traitements()`](http://trac.rezo.net/trac/spip/browser/tags/spip-2.0.9/ecrire/public/references.php#L302)
and takes the "*star*" into account (where adding a `*` to the end of
a tag suppresses automatic filtering).

You can see the default values in
[`ecrire/public/interfaces.php`](http://trac.rezo.net/trac/spip/browser/tags/spip-2.0.9/ecrire/public/interfaces.php#L295),
but lets consider the trivial example of removing the leading number
from all `#TITRE`s  with the `supprimer_numero` filter (completely
ignoring the normal processing): 

{% highlight php %}
global $table_des_traitements;
$table_des_traitements['TITRE'][] = 'supprimer_numero(%s)';
{% endhighlight %}

Another trivial example might be to transform the `#TEXTE` of all
sections (but not articles, etc) to uppercase[^2] (again ignoring the
normal processing):

{% highlight php %}
global $table_des_traitements;
$table_des_traitements['TEXTE']['rubriques'] = 'strtoupper(%s)';
{% endhighlight %}

Getting back to my goal of replacing SPIP's built-in typographical
shortcuts language with the [PHP
Markdown](http://michelf.com/projects/php-markdown/extra/) and
[Smartypants](http://michelf.com/projects/php-smartypants/). The
`TEXTE` entry in `interfaces.php` has the value `'propre(%s,
$connect)'`. Replacing this call to `propre()` (which implements the
typographical shortcuts) is simply a matter of installing the
`markdown.php` and `smartypants.php` scripts and adding a similar line
to our `mes_options.php` file:

{% highlight php %}
global $table_des_traitements;

include_once "markdown.php";
include_once "smartypants.php";
$table_des_traitements['TEXTE'][] = 'SmartyPants(Markdown(%s))';
{% endhighlight %}

Now the value set in `interfaces.php` will be
`$table_des_traitements['TEXTE'][1]` instead of
`$table_des_traitements['TEXTE'][0]` and our new value will be the
default!

Alas, there is one very large drawback to doing this. While I've
replaced the very limited typographical shortcuts with the much more
powerful Markdown, this change has also *removed* the ability to embed
models in the `TEXTE` of articles, sections, etc. It's now *harder* to
use images and documents within `texte` and *completely impossible* to
embed forms and other interactive elements.

This is a serious drawback which I've still not figured out how to
work around.

[^1]: Please note that I am grossly oversimplifying things here: loops
can loop over other data, and tags can do much, much more than merely
output values from a database. But this is the basis for much of the
design and implementation and is the default behaviour.

[^2]: And thus probably breaking your document as XML tag and
attribute names are case sensitive and XHTML defines them all as
lower-case.
