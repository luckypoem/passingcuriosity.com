---
wordpressid: 2120
layout: post
title: Nick Cowie's talk on Progressive Enhancement with CSS3
excerpt: 
  My notes on Nick Cowie's talk "Progressive Enhancement with CSS3" at 
  Edge of the Web 2009.
---
Notes from [Nick Cowie][nc]'s
([@nickobec](http://twitter.com/nickobec) talk [*Progressive
Enhancement with CSS: Or how I stopped worrying about IE6 and started
loving CSS3*](slides). As with the rest of these "notes" posts, what
follows may or may not accurately reflect Nick's actual opinions.

According to Helen Burgess' introduction: he's a library guy who does
web stuff. He self describes as a "reformed web standards fascist".

[nc]: http://nickcowie.com/
[slides]: http://www.slideshare.net/nickobec/progressive-enhancement-with-css3

# Introduction

Been doing web-sites for 15 years. Realised last year that he'd been
writing HTML/CSS for the same way for about 5 years. This talk is a result of the stuff he learned 

Many/most of us need to support IE6 and aim (fool ourselves) to have
pages display "identically" on "all" "supported" browsers.

# Why?

Some numbers from the [State Library of Western Australia][sl]:

* 10% Safari/Chrome
* 10% Firefox 3.5
* 5% Opera, Firefox 3, and others
* 15% IE8
* 47% IE7
* 13% IE6

[sl]: http://www.slwa.wa.gov.au/

What does this mean for CSS3 support?

# CSS3 Support #

What sort of support for CSS3 do these numbers imply? Given those
numbers, you can expect CSS3 features to "reach":

* 10% now
* 20% in 6 months
* 40% in 2 years
* 90% in 4 years
* 100% Who knows?

# Why bother? #

50% of users (in a Standford study) are willing to (or maybe actually
will) make a decision based on design issues in very short periods of
time.

# What is graceful degredation and progressive enhancement? #

*Graceful degredation* is starting at the top: using the best
techniques and making sure that it fails "well".

*Progressive enhancement* starts at the bottom and then adds on to
that for those that support it.

GD is easier and, perhaps, more readily future proof. PE is easier,
though, to add to an existing project.

# Validation #

Alas, the W3C validator rejects user-agent specific CSS properties
(such as their implementations of CSS3).

Even worse, the Microsoft implementations (using `filter:`) is not
even syntactically (nevermind semantically) valid CSS.

# An example CSS Zen Garden design #

An [example](http://nickcowie.com/eotw/) shows some of the power of
using CSS3. All of the effects and animations are implemented with
CSS3 transitions. In Safari4 everything works (even the transitions).
In Firefox 3, the transitions degrade and fail. In IE6, it's certainly
not as pretty, but is noticably the same design.

# Techniques

Using `@font-face`

* EOT for IE vs Real&trade; fonts.
* IE's wacky resource loading will download every font mentioned, not
  just those used in the document.
* Opera uses a default font until the "correct" fonts load, Safari
  will degrade, but IE will display nothing it the font fails to load.

Transparency

* Use `opacity`, but remember that the text, etc. is also transparent.
* Alternatively, us RGBa colours, but remember to set an RGB colour
  first, for those browsers that don't support them.

Rounded corners

* `border-radius` (`-webkit-border-radius`, `-moz-border-radius`).
* In WebKit, you need to have all four the same, or specify each
  individually. The shorthand doesn't work.

Shadows

* `text-shadow`
* Don't use the IE filter, it can lock the browser up.
* `box-shadow` works in IE5+, but is inherited.

Geometry and animations

* `transform`
* `transition` 

Gradients

* Supported in Safari and IE, but they work very differently.
* In Safari, linear or radial, but IE supports linear in vertical or
  horizontal dimensions.

Reflections and masking

* `box-reflect` is fun with `css-mask`

And much, much more.

All of these can be used now, and 

See *Surfin' Safari* or [css2.info](http://css3.info/).

# Questions and Answers #

**Have you seen a JavaScript library to implement support for this along the lines of the IE7.js, etc libraries?**

Not yet.

**Have you used Google Chrome Frame?**

No.

**Have you looked much at mobile browsers?**

Not until yesterday. It works surprisingly well in Safari on iPhone, iPod Touch. But the key to supporting (typically crippled) browsers is to provide fallbacks.

**What is your experience working with graphic designers and their opinion on progressive enhancement?**

He doesn't work a great deal with graphic designers. In the library, most of the graphic designers work on print and such. The designer that works on the web-site/s understands the web environment (and the limitations) very well.

**Have you worked with <some CSS government policy thingo>?**

The <thingo> doesn't say anything about CSS level support. It just specifies appearance, accessibility, etc. type stuff. So long as you don't go reflecting state government logos, etc...
