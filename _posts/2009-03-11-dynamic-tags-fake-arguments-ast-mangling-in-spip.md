--- 
wordpressid: 460
wordpressurl: http://passingcuriosity.com/?p=460
layout: post
title: Dynamic tags, fake arguments, and AST mangling in SPIP
tags: spip, php, code, syntax, ast, mangling
location: Perth, Western Australia
excerpt: |
  Sometimes a dynamic SPIP tag (one evaluated at request time) needs details
  about the template, but this information is not available. This post 
  describes a technique for passing data from the AST into the tag's static
  and dynamic evaluation functions.
---

One occasion in which [SPIP's dynamic tag
facilities](/2009/creating-custom-tags-spip-dynamic/) is a little lacking is
when you need to access details of the AST -- perhaps the name of the template
file, perhaps something else -- to generate your content. In this post I'll
describe the obvious (but wrong) approach to passing values into a dynamic tag
and another technique that actually works.

You should know about the [SPIP](http://www.spip.net/), its [template
language](/2008/spip-template-languag/), [static
tags](/2008/creating-custom-tags-spip-static/), [dynamic
tags](/2009/creating-custom-tags-spip-dynamic/) and be comfortable with
[PHP](http://www.php.net/) before reading this article.

Unlike static tags -- which are implemented by a single function -- dynamic
tags are comprised of a set of three functions (in a magically named file)
which are called by the SPIP engine as appropriate. This first of these three
functions (identical to the single function of static tags) is called
something like `balise_FOO()` and is responsible asking SPIP to call the other
two functions: `balise_FOO_stat()` -- which performs whatever static
calculations are required -- and `balise_FOO_dyn()` which performs the dynamic
calculations and display the final content to the user.

An example might make this more clearer. Suppose I'm creating a `#HITS` tag to
output the number of hits an article has received. My `balise_HITS` function
arranges for SPIP to call the `balise_HITS_*` functions like so:

1. It calls `balise_HITS_stat` to determine the static parameters for the tag
(e.g. "id_article=36").

2. It arranges to call `balise_HITS_dyn`, passing it the static parameters as
determined by `balise_HITS_stat`.

3. `balise_HITS_dyn` uses the static parameters to query the database, etc.
and produces the appropriate output.

The code to implement the `#HITS` tag might look like this:

{% highlight php %}
function balise_HITS($p, $nom='HITS') {
    $args = array('id_article');
    return calculer_balise_dynamique($p, $nom, $args);
}

function balise_HITS_stat($args, $filters) {
    return array($args[0]);
}

function balise_HITS_dyn($id_article) {
    $now = date('c');
    return "Article $id_article has had 1,000,000 hits as of $now!";
}
{% endhighlight %}

One way this can fall down is if I want to access details of, for example, the
SPIP templates in determining my static parameters. By the time I'm
determining the parameters, I no longer have access to the abstract-syntax
tree node passed to `balise_FOO`. All I've got at this point, is an array of
arguments to the tag and an array of filters applied to the tag.

## The obvious solution

The obvious solution is to add the value to the "`$args`" array I pass to
`calculer_balise_dynamique()`. Alas, this will not work as `$args` is not (in
spite of its usual name) an array of arguments. It is, in fact, an array of
the names of arguments which SPIP is to automatically fetch and pass on the
the `balise_*_stat()` call. Appending the name of the template file
(`"squelettes/foo.html"`, for instance) to `$args` tells SPIP to look for a
variable called `squelettes/foo.html` in the context the tag is being used and
pass it through to the next function. Needless to say, this doesn't work.

## The correct solution

The correct solution to this problem is to arrange for SPIP to add the values
you want to the `$arguments` array (or perhaps the `$filters` array, but this
may not be a good idea). This array contains the values I requested in the
call to `calculer_balise_dynamique` along with the values of the parameters
passed into the tag in the template. If I can't use the former route, then
it'll have to be the second -- I'll need to add a another "fake" parameter to
the AST node before I call `calculer_balise_dynamique`. (Yes, I agree. This is
a rather odd way to accomplish my goal, but that's how it goes in SPIP-land).

There are two parts of the SPIP AST that are relevant here: the `Champ` nodes
that represent tags, and the `Texte` nodes the represent "strings" (amongst
other things). The `$p` that is passed to my `balise_*` functions is an
instance of the `Champ` class and I'm going to add a new instance of the
`Texte` class representing my new "fake" parameter. Creating the new object is
pretty simple, just construct it and set it's `type` and `texte` members. The
following example adds a new parameter containing the name of the template
file:

{% highlight php %}
function balise_TEMPLATE($p, $nom='TEMPLATE') {
    $file = $p->descr['sourcefile'];

    // Create the new object
    $t = new Texte;
    $t->type = 'texte';
    $t->texte = $file;

    // Make sure that $p-param is an array (of the right dimensions)
    if (! is_array($p->param) ) {
        $p->param = array(array(0=>NULL));
    }

    // Append the object to the tag parameters
    $p->param[0][] = array($t);

    // Call SPIP's dynamic tags code
    $args = array();
    return calculer_balise_dynamique($p, $nom, $args);
}
{% endhighlight %}

First the previous code gets the name of the template file from the AST node
for the tag being processed. Then it creates a new `Texte` object with the
filename as its value. It ensures that the `$p->param` member of the `Champ`
object is an array (and yes, it *does* seem to start with a `NULL` so that we
can pretend that the arrays are 1-indexed) and then appends the new object to
it. All that's left is to call `calculer_balise_dynamique` as usual.

With this done, the value of the new "fake" parameter will be evaluated and
passed to the `balise_TEMPLATE_stat()` call in the `$args` array and then (if
I choose) passed on to the `balise_TEMPLATE_dyn()` call.

## Conclusion

This technique still strikes me as a bit odd, but it's the only way I can see
to implement this effect without introducing global variables. In my opinion,
`calculer_balise_dynamique` should take an array of argument values as an
optional fourth argument, but needing to do this sort of thing is probably
fairly rare (though I have seen it in the code for one or two built-in tags).
Even if this technique is the "Right Way(TM)" to pass extra values around,
then it really does need a helper function like `interprete_argument_balise`
instead of mucking around with AST internals in every tag that need it.
