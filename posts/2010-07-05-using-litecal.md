---
layout: post
title: Using Litecal
category: [drupal]
tags: drupal, views, date, calendar
location: Perth, Western Australia
excerpt: 
  This is a quick introduction to using the litecal module to display month
  calendars on Drupal powered web-sites.
---

[litecal][litecal] is a small Drupal module written by [Development Seed][ds]
to provide a lightweight calendar display for Drupal sites. Like the larger 
and more powerful [calendar][calendar] module, `litecal` is depends on both
the Views and Date API modules. Unlike `calendar`, `litecal` is relatively 
small and quite easy to understand. The rest of this post will guide you 
through installing and using `litecal` to create a calendar of events on 
your Drupal site.

[litecal]: http://code.developmentseed.org/litecal/node/285
[ds]: http://www.developmentseed.org/
[calendar]: http://drupal.org/project/calendar

----

## Installing `litecal`

As mentioned above, `litecal` has a number of dependancies. You'll need to 
download and install the following modules:

1. [Litecal][litecal] itself.
2. [Content][cck] and Text - to store the event data.
3. [Date][date] and Date API - to process and store date data.
4. [Views][views] - to display the calendar.

[views]: http://drupal.org/project/views
[date]: http://drupal.org/project/date
[cck]: http://drupal.org/project/cck

Once you've installed the modules you may need to configure them (you'll need
to have set the site timezone, if nothing else), and then move on to the next 
step.

## Creating the node type

Before you can display events on a calendar, you'll need somewhere to store
them so the first step is creating a new content type. 

![Create an event content type](/files/2010/07/litecal-event-type.jpg)

Next you'll need to add a few fields to it. You can store the event name and
description in the `title` and `body` fields, but you'll need to add a new
text field for the location and a new date field for the date. Make sure that:

* The date field is required (you can't have an event with no date).
* The "to date" is optional.
* At least year, month and day are selected under granularity.

When you're done you should have something like the following:

![Manage fields on calendar event](/files/2010/07/litecal-type-fields.jpg)

Now that you've got a *Calendar Event* node type, create a few dummy nodes so
that there's something to display on the calendar. Four or five should do it,
but make sure that a few are *this month* and one or two in past or future
months, or your calendar will be a bit empty!

![Create some Calendar Event nodes](/files/2010/07/litecal-create-nodes.jpg)

## Creating the view

Now you need to create a view to display the calendar events in a calendar.
Create a new view for nodes and add the following:

1. A filter `Node: Type = Calendar Event`.

2. A `Date: Date (node)` argument (select the *Current date* as default 
   argument, *Month* granularity, both *From* and *To* dates, and *OR* 
   method).

3. A `Content: Date - From date` field from your content type, a `Content: 
   Location` field, and a `Node: Title` field.
   
Your view should look something like this:

![Create a view](/files/2010/07/litecal-create-view.jpg)

Now add a new `Page` display to the view, set its *Name* to `Calendar`, the
*Path* to `calendar`, and override the *Style* and set it to `Litecal` (leave
the style options as the default values).

![Add a calendar display](/files/2010/07/litecal-calendar-display.jpg)

Save the view, then select the correct display under *Live Preview* and you
should see the dummy nodes you created earlier on a calendar of the current
month. If not, then you've missed a step above (perhaps the default value or 
granularity for the argument?).

![The calendar in live preview](/files/2010/07/litecal-preview.jpg)

You should also be able to visit `/calendar` and see the same calendar as a
page:

![The calendar in a page](/files/2010/07/litecal-calendar-page.jpg)

## Conclusion

You've seen how easy it is to get started with the `litecal` module. In the
next post, I'm going to introduce a few more sophisticated ways you can use
`litecal` to build more complete user interface.
