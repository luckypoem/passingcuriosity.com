--- 
wordpress_id: 925
layout: post
title: SPIP tags with multiple aliases
wordpress_url: http://passingcuriosity.com/?p=925
---
This is yet another post about creating tags for use in [SPIP][] templates. First I'll describe how to create tags with multiple "names" (e.g. `#INCLURE` and `#INCLUDE`) and then I'll build on this technique, my previous post [Dynamic tags, fake arguments, and AST mangling in SPIP](/2009/dynamic-tags-fake-arguments-ast-mangling-in-spip/), and a pattern used in SPIP's code to create suites of tags with multiple similar but slightly different functions. 

[SPIP]: http://www.spip.net/

As usual, you'll need to know [PHP][], and the [SPIP template language](/2008/spip-template-languag/) before this will make much sense, and I'd recommend reading my posts about [creating static tags](/2008/creating-custom-tags-spip-static/), [dynamic tags](/2009/creating-custom-tags-spip-dynamic/), and [faking tag arguments](/2009/dynamic-tags-fake-arguments-ast-mangling-in-spip/) as well. 

<!--more-->

SPIP tags are just a specially named function that accepts an AST node as a parameter and returns that AST node modified so that the code generator will generate the PHP code to implement the function. With static tags this means filling the node with some PHP code that evaluates to a string (often just a string literal with, perhaps, some variable interpolation). The functions for dynamic tags, on the other hand, fill their AST node with PHP code that, when evaluated by the code generator, generates more PHP. This second piece of PHP will form part of the page template and will [potentially] be evaluated at each request. 

## Different but same

It's sometimes desirable to make certain tags available under more than one name. The canonical example of this from SPIP's built-in tags is `#INCLURE`/`#INCLUDE`. Rather than provide just the French `#INCLURE` tag or just the English (and PHP-ish) `#INCLUDE`, SPIP provides both. This can help make your API more user friendly and is easy enough to do: just define a second tag function that calls the first (notice that I check for an overriding version of my original tag implementation and call that instead):

<pre lang="php">
    /* The original tag */
    function balise_FOO_dist($p) {
        $p->code = "'This is foo'";
        return $p;
    }

    /* The additional name */
    function balise_BAR_dist($p) {
        if ( function_exists('balise_FOO') ) {
             return balise_FOO($p);
        } else {
             return balise_FOO_dist($p);
        }
    }
</pre>

## Similar but different

If you're looking for identical functionality under a different name (see [#INCLURE][] and [#INCLUDE][]), this is all you need, but imagine that you, like me, have a number of tags with related but slightly different functionality. You *could* implement each of them -- copy-and-pasting the code and changing perhaps a single variable  -- or extract the common code into a set of library functions -- slowing things down slightly -- *or* you could implement a generic tag and a number of wrappers around it. SPIP does this in a number of places, but the best example is the `#ENV`, `#CONFIG` and `#GET` tags, each of which are *actually* implemented by the same piece of code (the `balise_ENV_dist` function, as it turns out).

This is easily accomplished by adding a second, optional, parameter to your main tag function and then passing different values from your stub tags. This is the approach that [`#ENV`][#ENV], `#CONFIG`, and `#GET` use: `balise_ENV_dist` check the environment by default, but if it's passed a second parameter (the `'$GLOBALS["meta"]'` that `#CONFIG` passes it, for example), then it operates on *that* instead. 

## Mangling for fun and profit

A second, but rather more involved, option for passing values into other tags is described in my [faking tag arguments](/2009/dynamic-tags-fake-arguments-ast-mangling-in-spip/) post. This can be useful when you don't control the code that you are wrapping. Perhaps you want to modify the `#MODELE` tag in such a way that it adds the name and line number of the tag to the environment of the model it calls. Rather than duplicating the code for `balise_MODELE_dist` and modifying it slightly, you could write a wrapper around it `balise_MODELE` and just add another two parameters (`skeleton` and `line`) to the AST before calling `balise_MODELE_dist`. As far as `balise_MODEL_dist` is concerned, it's as though some conscientious web-master has gone through every template adding `{skeleton=filename}{line=123}` to every call.

The difficult bit is to modify the AST correctly, but that's not too hard and you can [read the post](/2009/dynamic-tags-fake-arguments-ast-mangling-in-spip/) to find out how.

## Conclusion

This is a powerful technique that can simplify the code for plug-ins with large numbers of similar tags immensely. Rather than producing large amounts of "boiler-plate" code, or defining large libraries of API functions, I can just reuse my existing generic code in ways that hide it's complexity and power, thereby making the API much more simple and obvious to my users.

[#INCLURE]: http://trac.rezo.net/trac/spip/browser/spip/ecrire/public/balises.php#balise_INCLURE_dist
[#INCLUDE]: http://trac.rezo.net/trac/spip/browser/spip/ecrire/public/balises.php#balise_INCLUDE_dist
[#ENV]: http://trac.rezo.net/trac/spip/browser/spip/ecrire/public/balises.php#balise_ENV_dist
[PHP]: http://www.php.net/
