---
wordpressid: 286
layout: post
title: Creating custom tags for SPIP - Dynamic Tags
wordpressurl: http://passingcuriosity.com/?p=286
---

A lot of the content on modern web-sites is dynamic: from lists of "currently
online" user and targeted advertising, to widgets full of live data, dynamism
is as much the catch cry of the Web 2.0 as "user created content". To add
dynamic elements like these to your SPIP site, you'll need to make use of it's
facility for dynamic tags (or break out into PHP, but then what's the point of
a template language?). In this article I'll describe SPIP's dynamic tags and
how to create your own. I'll also touch a little on SPIP plug-ins as they'll
make things a little easier.

If you haven't already read [Creating custom tags for SPIP -- Static
tags](/2008/creating-custom-tags-spip-static/) -- the previous post in this
little series -- you probably should do or this might seem a bit confusing.


# Dynamic tags in SPIP

SPIP is fairly complex and its design and implementation make it quite
expensive to generate pages. To stop this high cost from making it completely
unusable, SPIP has a built-in caching mechanism to ensure that that it can
serve most requests quickly. This makes process of generating a page and
displaying it to the user a little more complex in SPIP than it is in most
systems. Thankfully, it's not *too* much more complex:

Briefly (and a little inaccurately), the process of turning a SPIP template
into HTML fit for a client goes like this:

1. Parse the template into an AST
2. Evaluate the static portions of the AST
3. Generate PHP to calculate the dynamic portions at run-time
4. Cache this PHP for future requests
5. Evaluate the PHP and send [^1] the HTML to the client

[^1]: SPIP also does a second round of caching here, but we'll ignore it for
the time being.

``````php
// Handle the #DYNAMIC_EXAMPLE tag.
function balise_DYNAMIC_EXAMPLE($p) {
        $args = array();
        return calculer_balise_dynamique($p, // The AST node for this tag
                'DYNAMIC_EXAMPLE', // The name of the tag
                $args); // The environment to capture
}

// Determine the static parameters for the #DYNAMIC_EXAMPLE tag.
// The arguments to the tag and filters applied to it are passed in as
// the arguments to this function.
function balise_DYNAMIC_EXAMPLE_stat($args, $filters) {
        // Calculate the current date and time...
        $now = date('Y-m-d H:i:s');

        // Return the arguments to pass to the dynamic calls...
        return array($now);
}

// Calculate the dynamic value to be output. The array values 
// returned by balise_DYNAMIC_EXAMPLE_stat are passed in 
// the arguments.
function balise_DYNAMIC_EXAMPLE_dyn($then) {
        // Determine the current time.
        $now = date('Y-m-d H:i:s');

        // Return a message containing the value from
        // balise_DYNAMIC_EXAMPLE_stat and the value we just
        // generated.
        $s = "Page generated: $then<br />Now: $now";

        return $s;
}
``````

When we use `#DYNAMIC_EXAMPLE` in a template, SPIP calls out gathers up all
the values we asked for in `$args` (nothing, in this case), and passes them to
`balise_DYNAMIC_EXAMPLE_stat`. It then takes the array returned by that call
and generates some code like `"balise_DYNAMIC_EXAMPLE_dyn('2008-12-01
22:22:22')"` which forms part of the PHP code generated from the AST.

# Adding a user-interface

Given the great lengths the developers have gone to to make SPIP easy to
customise, it'd be silly if dynamic tags were limited to returning a string to
be output. Thankfully, they aren't. Instead of returning a string to output,
dynamic tags can return an array which will be used to find, parse and render
a template with dynamic content. Rather than modifying the code that
implements a tag, web-masters can just create a new template in their
`squelettes/` folder overriding the default one to generate the output they
want.

When using this feature, the `balise_*_dyn()` function returns an array
containing three elements:

1. the name of the template to evaluate;
2. the amount of time the result can be cached[^2]; *and*
3. an environment array to be passed (as `#ENV`) to the template.

[^2]: This is for the second round of caching alluded to in footnote 1.

The previous example modified to use a template might look like this:

``````php
function balise_DYNAMIC_EXAMPLE_dyn($then) {
        $now = date('Y-m-d H:i:s');

        $env = array(
            'then' => $then,
            'now' => $now,
        );
        return array('formulaires/dynamic_example', 0, $env);
}
``````

With a template called `squelettes/formulaires/dynamic_example.html` like so:

``````spip
    Page generated: #ENV{then}<br />
    Now: #ENV{now}
``````

# Going Further

I've barely scratched the surface of what's possible using SPIP's dynamic tags
feature in this article, but most of the ground work is here. In a few shorter
articles I'll be posting later today, I'll describe some tricks and techniques
that can help make the most of SPIP's tags -- both static and dynamic -- and
other features.
