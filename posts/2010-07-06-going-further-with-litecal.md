---
layout: post
title: Going Further with Litecal
category: drupal
tags: drupal, views, calendar, litecal
location: Perth, Western Australia
excerpt: 
  This article builds on my last by adding additional features to a calendar 
  view based on litecal.
---

My [last article](/2010/using-litecal/) was a quick introduction to the
`litecal` module. In this article, I'll show how to go further with Litecal to
create more complete user interfaces. You'll see how to use associate related
events by colour, how to add additional displays of the same data, and a few
tips on themeing Litecal.

----

## Using colour in the calendar

Most of us are familiar with programs like iCal which use colour "link"
related events together on a calendar. One way to make a Litecal-based view
immediately more usable is to implement this technique. Thankfully it's rather
easy to do thanks, once again, to [Development Seed][ds] and their
[Seed][seed] module. Seed contains useful code and customisations for Litecal
and a number of other modules. The name suggests that it's intended for
semi-internal use (maybe just Open Atrium, I'm not sure), but it's GPL and the
awesome people at DS released it so I don't feel too bad in making use of it.

[seed]: http://code.developmentseed.org/node/176
[ds]: http://developmentseed.org/

Do the usual dance of downloading, unpacking and installing the module from
the link above (Seed depends on [Context][context], so install that too). Once
that's done, you'll need to return to the view you created in the last
article.

[context]: http://drupal.org/project/context

Go back and edit your calendar. Select the Calendar display, update the *Style
options* and change *Color by* to `field_event_location_value`. Once you've
updated (or saved) the display, Litecal will use Seed to assign a colour to
each event displayed on *the calendar based on the value of the location
field*. Events at the same location (where "same" means "has the same CRC32")
will have the same colour! Seed only supports 16 colours but this should be
enough for most purposes and the colours themselves are easily overridden in
your theme stylesheet.

As great as this is (and you'll have to agree, it is pretty awesome) there are
a few little niggles. First, when Seed is installed Litecal might get confused
and fail to render events in the *Live Preview* (this might just be Theme
Developer, though). Second, Seed doesn't just add support for colours to
Litecal; it also overrides the user picture template and a bunch of other
stuff that you probably want left alone. Third, it's adding Context for no
particular reason (at least in this demo).

I'm still a bit puzzled by the first issue, but the others are readily solved
by pulling the colouring code out of Seed (look for the theme functions with
`crayon` in their names) and whacking it in another module, but you'll also
need to tweak the code of Litecal (look for the `module_exists('seed')`). I
hope that this colouring functionality will be merged into Litecal itself at
some point, or at least pulled out into a module that doesn't do a bunch of
other stuff too.

## Additional displays

A calendar by itself is great for little things -- "Yes, I'm free on Friday
13th" -- but might not be enough in cases where users need more complete
information at a glance. That's why so many calendar applications also display
events in a list or table view. With a pretty feature-full calendar, this list
view is next on the list! The goal is to add a table with the most pertinent
details about each event below the calendar display.

Having though of just this combination of use cases, Views makes this an
absolute cinch. Go back to your view and add a new *Attachment* display.
Change the name of your new display and override the *Style*, setting it to
*Table* (sorted by the Date field).

Edit the *Attachment settings* like this:

* *Inherit arguments* should be *yes* (so that the table displays the same
  month as the calendar).

* *Postition* should be *After* (it'll look a bit odd before the calendar).

* *Attach to* the calendar display you created in the first article.

There are a few more tweaks you might like to make at this point:

* Add *Sort criteria* in the *Default* display so that the events are sorted
  by *Content: Date* in ascending order. This might help keep things
  consistent in the event that you need to display the pager.

* Add *Filters* on *Date: Date (node)* to list only upcoming events in the
  table (those where *To date* is greater than or equal to now).

Other alternatives include:

* Using Panels instead of attachment Views to link the table to the calendar.
  This makes using the pager slightly simpler.

## Themeing Litecal

Given that it's called "Key", it'd be nice if the table display was actually a
key for the calendar display. You can add a column with the same colour as is
used in the calendar quite with a simple change to the view and a less simple
change to your theme. 

If you looked at the colouring code in Seed and the way it's invoke from
Litecal, you probably noticed that it's fairly simple: get the "key" value,
feed it to the colour picker code (`theme('crayon', $key)`) and use the result
to add a class to the element.

If you followed the instructions above, your calendar entries are colour coded
according to the location field. To add the correct colour to the table,
you'll need to add a new column containing this value and then use the theme
layer to turn this into a coloured splotch.

Edit your "Key" display and add a new *Content: Location* field. Re-order the
fields and move this new column to the top of the list as you want the
colour-coding to be the first item in each row. Save that and then load the
view in your browser. Using whatever inspector tool your web-browser provides
(or "View Source" if you're a sadist), determine the [longest] class on the
cells in the new column. Mine is: `views-field-field-event-location-value-1`.

This class is generated based on two facts: it is a view field, and the field
being displayed is `field-event-location-value-1`. You can use this to work
out what the theme function you are about to write should be called. It will
be something like this:

    <prefix>_views_view_field__<view_name>__attachment__<field_name>

where `<prefix>` is your theme name (or theme engine name), `<view_name>` is
the name you assigned your view when you created it, and `<field_name>` is the
name used in the class above (but with `_`s instead of `-`s).

Fill in the three blanks (you can almost always use `phptemplate` for the
prefix and expect it to work!) and add a function like this to the
`template.php` in your theme:

``````php
function phptemplate_views_view_field__events_calendar__attachment__field_event_location_value_1($view, $field, $row)
{
  // Get the "key". This is just the value that would be displayed in the 
  // table cell if we weren't messing with things.
  $text = $view->field[$field->options['id']]->advanced_render($row);
  
  $class = "crayon crayon-"theme('seed_crayon', $text);
  
  // Create a span with the class 
  $r = "<span class='$class' style='display:block;height:5px;width:15px;'></span>";
  
  return $r;
}
``````

Once this new function is in place you will need to refresh your theme caches
(just hitting "Save" on `/admin/build/themes` will do the trick). And now your
calendar page should look something like this:

![The finished calendar](/files/files/2010/07/litecal-themed-calendar.jpg)
