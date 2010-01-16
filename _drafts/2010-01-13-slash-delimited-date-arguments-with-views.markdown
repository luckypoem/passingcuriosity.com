---
layout   : post
title    : Slash delimited date arguments with views
tags     : [php, code, drupal, path, arguments, views]
location : Perth, Western Australia
excerpt  : |
  Date arguments for Drupal views only support values like *2010-01* and
  *2010-01-13*. This is a short guide to building views with URLs like
  `/view/2010/01/` in spite of this limitation.
---

[Views][views] is an extremely powerful module for [Drupal][drupal] which
makes is easy to create custom "views" of data in a Drupal system. Together
with the [Content Construction Kit][cck] and modules like [date][date] you can
store exactly the data you need and make it accessible in the formats that
will be more useful. Going one step further and ensuring that it is consistent
with the non-views portions of your site can some times be a little tricky or
require compromises, particularly when it comes to URLs.

I've just spent a few hours looking at argument handling with Views 2 (which
changed considerably from Views 1) and implementing my preferred URL scheme. I
couldn't find much in the way of guidance for this, so I'm blogging it!

First, the goal is this: I have an "event" content type with an "event date"
field. I'm using a [pathauto][pathauto] pattern like this:

events/[field_event_date-yyyy]/[field_event_date-mm]/[field_event_date-dd]/[title-raw]

These events will be listed in a view with a calendar display using the
fabulous [litecal][litecal] module from [Development Seed][ds]. Calendar views
require a [date][date] argument so that the view can fetch the data to be
displayed on the calendar. Unlike *node* date arguments (which filter against
the date a node was created or updated ), *date* date arguments (which filter
against a Date CCK field) do not support filtering against year, month, and
day separately -- you have to choose between year, year-month, or
year-month-day. I'd like the view to act as an "index" to the above URL scheme
so this simply will not do. Thankfully, it's not too complex to work around
this limitation.

Because `/` separates two arguments you can't format a date like `YYYY/MM`:
this is two arguments, not one, and the *date* date arguments can't filter
by year and month independently and, even if it were possible, the calendar 
display uses the *first* date view to determine what to display. Given the 
facilities at my disposal, it's not too hard to figure out where to go:

1. Add a "Null" argument to accept the year value in the URL.

   Use PHP to supply a default value: `return date('Y');`

   And to validate: `return (! ! preg_match('/^[0-9]{4}$/', $argument));`

2. Add a second "Null" argument to accept the month value in the URL.

   Use PHP to supply a default value: `return date('n');`

   And to validate: `return (preg_match('/^[0-9]{1,2}$/', $argument) and 
   (1 * $argument >= 1) and (1 * $argument <= 31));`

3. Add a "Date (node)" argument based on the appropriate CCK field.

   Use PHP to supply a default value:

       $v = arg(1).'-'.arg(2);
       if (! preg_match('/^[0-9]{4}-[0-9]{1,2}$/', $v))
           $v = date('Y-m');
       return $v;

Now change the display *style* to "litecal" (it will probably work with the
calendar module as well) and it's pretty much done. The only problem is with 
the URL's that the view display generates for the previous/next links.

I wound up hacking the code to fix that.

[cck]: http://drupal.org/project/cck
[date]: http://drupal.org/project/date
[drupal]: http://drupal.org/
[ds]: http://developmentseed.org/
[litecal]: http://github.com/developmentseed/litecal
[pathauto]: http://drupal.org/project/pathauto
[views]: http://drupal.org/project/views