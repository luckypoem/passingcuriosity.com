---
layout   : post
title    : Date-based Drupal interfaces with litecal
tags     : [drupal, php, web, development, calendar]
location : Perth, Western Australia
excerpt  : 
  The litecal module, part of Development Seed's excellent Open Atrium,
  provides a light weight month calendar style plugin for Drupal views. This
  post describes the way I've made use of it.
---

Part of [Development Seed][ds]'s excellent [Open Atrium][oa] intranet package,
[litecal][litecal] is a Drupal module that provides a one-month calendar style
plugin for [views][views]. It is significantly smaller than [calendar][cal]
(the `tar` archive is about 2% of the size) and its significantly fewer
features are exactly the ones I need, so I think it's pretty cool.

Installing `litecal` is pretty easy, just install the module and its
dependencies:

1. [CCK][cck]
2. [Date][date]
3. [Views][views]
4. [Litecal][litecal] (though I use [my own fork][thsutton-litecal])

Once it's installed, actually using `litecal` isn't any harder: create a view;
add a display; add a date argument; set the style to `litecal`; and you're
done! Hoorah.

## `/`-delimited dates in URLs ##

As it stands, though, I find this slightly less than ideal. In particular, the
URLs that this setup will need (whether as a view page, or through a panel)
will look something like `the-calendar/2010-03` whereas I prefer something
like `the-calendar/2010/03`. It *is* possible to get it to work this way, but
is a more than a little dirty, so don't just follow along without
understanding what's going on!

As with every other part of Drupal view arguments are split using slashes and
the Date API is no different: it allows you to specify a single argument in
the format `YYYY[-MM[-DD]]`. Unlike the built-in date handlers (for the node
created and updated timestamps) there are no separate year, month, and day
arguments, but even if there were litecal will only use one date. The problem
then is have a single Date API argument to the view, but have several date
components in the path.

Through the magic of Null arguments, PHP to generate the default value of an
argument, and some code changes to `litecal` this challenge can be met! First,
the argument handling: add two Null arguments to the view (listed under
Global) and move them immediately before the Date argument. Your view arguments should look something like this:

![Null, Null, and Date arguments](/files/files/2010/03/07/arguments.png)

Then configure the Date argument to use the values of these Null arguments for
its default: edit the argument's options, set default value to **use PHP
code** and enter a snippet like this:

{% highlight php %}
{% endhighlight %}

Note that this code uses calls to [`arg()`][arg] to get the values of the two
Null arguments. This is fragile and will need to be updated for each path use
use this on! If anyone knows of a better way to get the values of other
arguments from within an argument, then please contact me (see the bottom of
this page). In any case, the Date argument is now using the values in the Null
arguments to determine its value and URLs like `the-calendar/2010/03` should
now work!

The second step is to modify Litecal to generate these URLs. My initial
approach was to [hack the code to modify the two arguments preceding the date
argument][v1] but that was a bit naughty, so I've since [added an option to
control enable this date munging][v2]. It's still reasonably ugly, but doesn't
force me to use this technique on every view that uses Litecal.


[arg]: http://api.drupal.org/api/function/arg/7
[ds]: http://developmentseed.org/
[oa]: http://openatrium.com/ "Open Atrium"
[litecal]: http://code.developmentseed.org/litecal/
[date]: http://drupal.org/project/date
[cck]: http://drupal.org/project/cck
[cal]: http://drupal.org/project/calendar
[screenshot]: http://farm4.static.flickr.com/3380/3632339609_f12b733b30.jpg
[views]: http://drupal.org/project/views
[thsutton-litecal]: http://github.com/thsutton/litecal
[v1]: http://github.com/thsutton/litecal/commit/45988a6297e9bd1bc7918600577d0e8c214b2574
[v2]: http://github.com/thsutton/litecal/commit/c23ffc68979387bd673053d4e55f1e2f30f5c761

[contact]: mailto: