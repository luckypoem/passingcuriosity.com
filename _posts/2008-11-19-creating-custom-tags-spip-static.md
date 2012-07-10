--- 
wordpressid: 249
wordpressurl: http://passingcuriosity.com/?p=249
layout: post
title: Creating custom tags for SPIP - Static tags
tags: [spip, php, code, template, tags]
location: Perth, Western Australia
excerpt: |
---

The SPIP template language has two constructions: loops (which determine the
objects to be "output") and tags (which actually output particular values).
The reasonably simple syntax of tags -- most look like ''#THE_TAG'' -- belies
their power and flexibility and the ease with which we can use them to extend
SPIP with additional features and integrate it with other PHP-based packages.

In this post, I'll describe how to create your own static SPIP tags. In a
future post, I'll cover dynamic tags, and how to package your tags (and other
code) as a plug-in. Before reading this post, you should be familiar with
[SPIP](http://www.spip.net/) and it's [template
language](/2008/spip-template-languag/), and with programming in PHP.


SPIP tags are used to "output" a "value". For many tags, this value is taken
from the context in which it is called: the title of the "current" article,
for example, or the logo the "current" news item. Others output global values
like the name of the web-site, or the version of the software. Still more tags
allow users to interact with the site (e.g. `#LOGIN_PUBLIC` which outputs a
log-in form *and* processes the log-in request when the user submits it) and a
few (like ''#SET'' and ''#GET'') implement the features of a general purpose
programming language and producing output is only a side effect. All of these
effects are achieved using the same relatively simple syntax and mechanism.

Tags can be divided into two groups based on their behaviour. *Static* tags
are those that output some statically determined value -- one that does not
necessarily change from one evaluation to another. The title of an article,
for example, will not *necessarily* change between one page view and another.
It *may*, but not necessarily. *Dynamic* tags are those that generate dynamic
output -- values that necessarily change between invocations. The current date
and time, for example. Implementing a static tag is significantly easier than
a dynamic tag, so we'll look at that first and leave dynamic tags to a later
post.

# Static tags

Static tags are those that output a "static" value. That is, a value that is
not expected to change over any particular time period. This means that SPIP
can evaluate a static tag once and then cache the result and reuse it in
future requests.

Like many aspects of SPIP, a tag (for the rest of this section, you can assume
that "tag" means "static tag") is a function[^1] with a special name -- the
name of the tag appended to "balise_". For example a tag called `#FOO` will be
implemented by a function called `balise_FOO`. Like much of SPIP, these
functions can be overridden by plug-ins, or site-specific files. When it sees
a `#FOO` tag, SPIP will first look for a function called `balise_FOO`, then
one called `balise_FOO_dist`, and then decide that the tag doesn't exist.

[^1]: In one sense, this is not entirely true: the function just manipulates
the abstract syntax tree node for the tag which will then be processed by SPIP
to generate the tag. For more on this see [details of the AST
(FR)](http://doc.spip.org/@details-sur-l-AST "dÈtails sur líAST").

Rather than blather on, I'll give you a trivial example: the `#HELLO_WORLD`
tag. This tag simply outputs the string "Hello World!" (To use the code,
simply copy the function into the file `mes_fonctions.php` in the root of your
SPIP installation):

{% highlight php %}
function balise_HELLO_WORLD($p) {
    $p->code = "'Hello World!'";
    return $p;
}
{% endhighlight %}

As you can see there are a few more details than just the name, namely, this
`$p` thing. The parameter to the function implementing the tag is a reference
to the abstract syntax tree node for that tag. This contains all of the
information about the tag that SPIP has about the tag, the filters called on
it, the brackets around it, the context, etc., etc., etc. All that is missing
is the value itself, which is where our function comes into play. After SPIP
has analysed the templates and handled everything *it* can, it calls the
function responsible for each tag to fill in the gaps.

There a numerous fields in the `Champ` object (the class is defined in
[`ecrire/public/interfaces.php`](http://trac.rezo.net/trac/spip/browser/spip/ecrire/public/interfaces.php)
but the definition isn't particularly edifying), but most of them are best
left alone and accessed by way of helper functions:

- `type` -- a string describing the type of AST node. Should be `"champ"` for
  tags.

- `nom_champ` -- the name of the tag without the `#`.

- `nom_boucle` -- the name of the loop. Tags aren't loops, so this will be
  empty.

- `avant` -- a list of preceding nodes that are conditional on this one.

- `apres` -- a list of succeeding nodes that are conditional on this one.

- `etoile` -- "star". The tag was called like ``#HELLO_WORLD*`` and, thus,
  should output raw, as opposed to HTML safe, values.

- `param` -- a list of parameters and filters to the tag call. This is pretty
  complex.

- `fonctions` -- similar to `param` but structured differently.

- `id_boucle` -- the name of the loop within which this tag occurs.

- `boucles` -- an array of AST nodes for the loops ("boulces") in the
  template.

- `type_requete` -- no idea.

- `code` -- the PHP code which, when `eval()`d, produces the value of the tag.

- `interdire_scripts` -- whether "scripts" will be interpreted. No idea.

- `ramasser_miettes` -- whether to "collect the crumbs". No idea.

- `descr` -- an array of values describing the AST node, the file it came
  from, etc.

- `ligne` -- the line number of the tag call in the template.

**An example** Replacing the contents of your `dist/sommaire.html` template
with this:

    [before (#HELLO_WORLD{arg1}|strtoupper) after]

might result in the following AST being passed to `balise_HELLO_WORLD` above
([download the full SPIP AST](/files/files/2008/11/spip-ast-example.txt)):

    type => "champ"
    nom_champ => "HELLO_WORLD"
    avant => the node/s for "before", ...
    apres => the node/s for "after", ...
    etoile => 
    param => [
            0 => "arg1" is in here, ...
            1 => "strtoupper" is in here, ...
            ]
    fonctions => [
            0 => "{arg1}" is also in here, ...
            1 => "strtoupper" is also in here, ...
            ]

Thankfully, you can ignore almost all of this and trust to the helpers. The
function [`interprete_argument_balise`
(FR)](http://doc.spip.org/@interprete_argument_balise "fonction
interprete_argument_balise") is particularly useful:
`interprete_argument_balise(1, $p)` returns the first argument in the AST node
`$p`.

Using what I've described so far, it's pretty to write a `#HELLO` tag which
output's a message "Hello *name*" when given a name, and "Hello World!"
otherwise (again, this code goes in `mes_fonctions.php`):

{% highlight php %}
function balise_HELLO($p) {
    $name = interprete_argument_balise(1, $p);
    if (! $name) {
        $name = "World!";
    }
    $p->code = "'Hello $name'";
    return $p;
}
{% endhighlight %}

There are a number of other issues involved in writing static templates. It's
good practice to make sure that your tags (and everything else, for that
matter) supports translation, especially if you're going to be distributing it
to others. Doing so is reasonably easy using the [`_T`
(FR)](http://doc.spip.org/@Les-chaines-de-langue "Les chaines de langue")
function and "lang" files. Getting data from a loop (article titles, section
IDs, etc.) is also reasonably straightforward with [`champ_sql`
(FR)](http://doc.spip.org/@champ_sql).

For more examples, you can have a look at the code for some of SPIP's built-in
tags in the code of [`ecrire/public/balises.php`
(FR)](http://doc.spip.org/balises-php) (I rather like
[`balise_INTRODUTION_dist`
(FR)](http://doc.spip.org/@balise_INTRODUCTION_dist)). If you do look to the
SPIP source code for examples, you should be aware that a lot of the built-in
tags are not implemented using this mechanism, but are magically drawn from
database columns with the same name. If you extend the database this magic
will work for you too, but that is beyond the scope of this post and will have
to wait for my post/s about writing SPIP plug-ins.
