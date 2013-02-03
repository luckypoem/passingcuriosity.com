---
wordpressid: 2109
layout: post
title: Dmitry Baranovskiy's talk on Your JavaScript Library
excerpt: |
  My notes on Dmitry Baranovskiy's talk "Your JavaScript Library" at
  Edge of the Web, 2009.
---

There are my notes from [Dmitry Baranovkiy][db]'s session called *Your
JavaScript Library*. Dmitry is a JavaScript developer at [Atlassian][at],
creator of [Raphaël][rph] and [gRaphaël][grph] JavaScript libraries.

[db]: http://dmitry.baranovskiy.com/
[at]: http://atlassian.com/
[rph]: http://raphaeljs.com/
[grph]: http://g.raphaeljs.com/

You can see the [slides on
slideshare](http://www.slideshare.net/Dmitry.Baranovskiy/your-javascript-library).

# Introduction #

Unlike the server-side, you don't have a choice on client-end development: you
pretty much *must* use JavaScript.

At Atlassian, they've got a number of products and have abstracted their own
JavaScript library out of those code bases.

# Why should I write a library of my own? #

Everyone has snippets of JS they use on every project (`trim`,
`$`=`getElementById`). You build your little library of snippets, you share it
with your colleagues and friends, etc. and eventually you've got a library
project.

Roughly divided into:

* low level: taking care of nitty, gritty things like abstracting over
  DOM.
* high level:
* toolboxes:
* widgets: 

# API & Functionality #

The API is more important than functionality. The Twitter functionality, for
example, is primitive, while it's API is awesome.

Spend 80% on API, 20% on functionality.

Your library is the answer. What is the question? If your library is to be the
"correct" answer, you'll need to know the question, back to front.

Who is the target? Who will use the library and how? From, Java, Ruby, PHP,
JavaScript?

A good API looks as simple as the functionality it provides.

JavaScript is your friend. Don't try to "fix" it (i.e. reimplement class-based
OO).

# Performance #

Performance of JavaScript is usually a bottleneck. It's a cause for
complaints, no matter what, so make it as fast as possible. Develop and test
on IE6, because it's going to be run their and it's very, very, slow.

Some tips:

* Array iteration with `while` instead of `for`. (Just a matter of 
 `i <= a.length`, I think).

* Implement memoization (an object hidden in a closure). You could
  even implement this as a higher-order function.

See [JavaScript Performance Rocks](http://www.jsrocks.com/) by Thomas
Fuchs and Amy Hoy.

# Animation #

Lots of frameworks have animation functionality. Not only is it
pretty, but it's also useful (UI, affordances, etc.).
 
Animation has a drastic effect on performance: while an "onclick"
handler might be called on a few times, an animation function will be
called a few thousand times. A second.

Don't trust `setTimeout()`. Your function won't be called in 10 ms. It
will be called sometime, hopefully in around 10 ms.

# Bulletproof #

Unlike most other environments, JavaScript libraries need to be
bulletproof as they will be expected to co-exist with other libraries,
user code, etc.

## Global scope ##

Treat it like a public toilet. You can't avoid it, but while you're
there have the least contact possible: you have no idea who has been
here, or what they've done, and no idea who and what will come after.

Use a closure to hide your own library-level "global" stuff.

## Native Prototypes ## 

Adding methods to the prototypes of native types (`String`, `Number`,
etc.) can be dangerous.

Never, ever touch `Object.prototype`. It's just that dangerous. Worse:
you can't rely on the fact that no-one else touched it.

Adding, e.g. `Object.prototype.top = 3` can break everything that does
a `foreach` over objects. Use `Object.hasOwnProperty()` to make sure
it's in the object, and not just in it's prototype. 

Checking if something is an `Array`: `object && (object instanceof
Array)`. Will return false if `object` is from another context (an
`iframe`, for example). **Do not forget about <iframes>**

Another problem is the fact that `undefined` is just a variable (and
someone else can change it). If you need it, define your own (without
a value) or, just don't use it: `this.set(a || 5)` vs.
`this.set(undefined == a ? 5 : a)`.

# Packaging #

JS is one of the only environments in which code size counts. Reducing
your code size is important for performance, etc. (network traffic,
caching, etc.)

There a bunch of tools to shrink and compres JavaScript)

* JSMin
* Dojo ShrinkSafe
* Packer
* YUI Compressor (w/ gzip is best)

Raphael, e.g. is 121K, 52K minified, 18K gzipped.

Using local names for built-in functions can allow these tools to
generate short names, and then use the smaller name at call sites.
Adding, e.g., `var parseFloat = parseFloat;` can replace all the
`parseFloat()` calls in the minimized version with calls to, e.g.,
`a()`. We add some code and the minimized version gets smaller!

* 394b original = 235b minified
* 427b original = 216b minified (with `var parseFloat = parseFloat;`
  added)

Every function call, takes time (especially on IE6). Rather than
wrapping functions (like `setAttribute`) with local wrapper functions,
you can use a variable for the name and use subscripting to access the
function:

{% highlight javascript %}
var setAttribute = "setAttribute";
element[setAttribut]("width", 320);
{% endhighlight %}

# Error Handling #

Don't use an error handling function: all you're doing is making sure
that your error messages (when an exception is thrown) doesn't tell
you where the error was.

# JSLint #

Always use [JSLint](http://jslint.com/). If you haven't run your code
through JSLint, then it's not really JavaScript. It's not about being
cool, or smart, etc.  It's about saving time and bugs.

# Share the magic #

Once your library is done (and awesome!), share the magic! Open it up
and let others see and use and contribute.

# Questions and Answers #

**Have you looked at ways to make your code better for the modern JIT
JavaScript engines?**

He's not bothered with the new engines, etc. and won't be while IE6 is
on the list of supported browsers. Until that point, it's something of
a struggle to get anything to run fast enough on IE.
