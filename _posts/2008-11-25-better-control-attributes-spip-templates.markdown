--- 
wordpress_id: 325
wordpress_url: http://passingcuriosity.com/?p=325
layout   : post
title    : A better way to control attributes in SPIP templates
tags     : [spip, php, code, html, attributes]
location : Perth, Western Australia
excerpt  : |
  This post describes a PHP function to replace SPIP's inserer_attribut and
  extraire_attribut filters with a single jQuery-inspired attr filter.
---

*Edit:* En español: 
"[Una mejor manera de controlar los atributos en SPIP][en-es]".

[en-es]: http://nqnwebs.com/blog/article/una-mejor-manera-de-controlar-los

Lots of SPIP tags and filters generate HTML mark-up as output (the `#LOGO_*`
tags and `|image_*` filters are the most prominent) and we often need or want
to modify this mark-up in our templates. There are several built-in filters to
help with this
([`inserer_attribut`](http://www.spip.net/en_article2465.html#inserer_attribut)
to insert an attribute and
[`extraire_attribut`](http://www.spip.net/en_article2465.html#extraire_attribut)
to extract the value of an attribute) but they are pretty long and tedious to
type. Given that I uses these filters quite often when implementing such
things as image galleries, and I still have to think quite hard to type the
French words correctly the can be a bit annoying. Thankfully, a small wrapper
(see below) can smooth these small annoyances away.

When it comes to accessing and modifying the values of attributes nothing, in
my opinion, comes any where near to [jQuery's attributes
API](http://docs.jquery.com/Attributes). The single [jQuery `attr`
method](http://docs.jquery.com/Attributes/attr) allows you to get and set the
value for any attribute on any node: it takes one or two parameters, the name
of the attribute and, optionally, the value. If only the name is specified,
then `attr` simply extracts and returns the value of the attribute. If both a
name and a value are specified, then `attr` modifies the object setting
specified attribute to the specified value. This "polymorphic" style of
interface -- where a single method has two complementary behaviours which are
distinguished by the number and/or types of the arguments -- is everywhere in
jQuery and is part of what makes it so concise and so productive. Seeing as
it's the best structure for such interfaces that I know (and also, one I use
daily), I decided that my wrapper should mirror it. Thus the `attr` filter was
born.

Like the jQuery `attr` method, the SPIP `attr` filter takes one or two
parameters (and an implicit "object", but we'll ignore if for now). If only
one, it passes the input on to `extraire_attribut` to get and return the
value. If called with two parameters, it calls `inserer_attribut` instead to
modify the tag. Like the idea, the code is reasonably straightforward; the
only even slightly unusual but is the use of
[`func_get_args`](http://php.net/func_get_args "PHP manual for func_get_args")
to get an array of the arguments passed into the function call. With such an
array, we can use [`count`](http://php.net/count "PHP manual for count") to
check how many arguments the function was given and decide whether we should
get or set the attribute. This is safer than specifying and checking a default
value (`FALSE` or `NULL`, for example) because some user may genuinely want to
use that value (perhaps `NULL` will mean delete the attribute in a future
version?) and silently ignoring user input is never good.

{% highlight php %}
include_spip("inc/filtres");

/**
 * The `attr` function allows the user to get and set the attributes of an
 * HTML tag. It is intended to be used as a SPIP filter and depends on 
 * existing SPIP functionality.
 *
 * @param $tag
 *     The HTML code.
 * @param $name
 *     The name of the attribute.
 * @param $val...
 *     The new value for the attribute $nom. Optional.
 * @return
 *     If $val was given, the code for tag with $name=$val
 *     Otherwise, the value for the $name attribute in $tag.
 */
function attr($tag, $name){
        $args = func_get_args();
 
        if (count($args) > 2) {
                // SET
                return  inserer_attribut($tag, $name, $args[2]);
        } else {
                // GET
                return extraire_attribut($tag, $name);
        }
}
{% endhighlight %}

Simply copy the code into the `mes_fonctions.php` file for your site (see
"Adding your own filters" in [SPIP's
Filters](http://www.spip.net/en_article2465.html)) and use `attr` in your SPIP
templates:

{% highlight html %}
<a href="[(#FICHIER|attr{src})]" class="lightbox" title="#TITRE">
    [(#FICHIER|image_reduire{100,100}|attr{alt,#TITRE})]
</a>
{% endhighlight %}

There are a few changes that could be made to this function: passing `$args`
directly to `inserer_attribut` and `extraire_attribut` rather than the
individual variables, adding a `$value=FALSE` parameter for the sake of
documentation and then ignoring it (I'm not sure if this will work and don't
care enough to try it), deleting attributes when passed e.g. `NULL` as a
value, etc. For the time being, however, it does the job.

A final note: you'll probably need to be running PHP 5 for this to work -- the
`func_get_args` documentation (linked above) mentions version 5.3.0 -- and the
code above was modified after I last tested it, but should work anyway.