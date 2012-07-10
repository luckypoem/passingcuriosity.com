--- 
wordpressid: 109
layout: post
title: Computed Attributes in Core Data, How?
wordpressurl: http://passingcuriosity.com/?p=17
---
I've worked through a few Core Data and Cocoa tutorials in the last few weeks and most of them are exceedingly awesome. That fact that there are so many capable Cocoa developers out there who spend time creating tutorials and sharing their hard earned experience is fantastic and speaks volumes about the Cocoa and the wider Mac communities. To (not really) give a little back and (more) attempt to solicit suggestions I'll be posting about some of the problems that I've run into trying to move beyond the "getting started" tutorials and ways to solve them. First up is computed attributes in Core Data applications.

<!--more-->

Many of the Core Data tutorials available use a personnel database as an example (perhaps after the *RaiseMan* example in [Cocoa Programming for Mac OS
X](http://www.amazon.com/exec/obidos/ASIN/0321503619/thomsutt-20/ref=nosim) and I seem to recall seeing a guide or piece of sample code from Apple along similar lines?). I'm
not one to buck a trend and it's easier to build on something than to start from scratch, so I'll do the same. Continuing from where I left my post on [using bindings
operators with Core Data](/2008/binding-operators-with-core-data/) we'll first extend our app to display the number of employees in each department.

This is pretty simple: just add a second column to the departments `NSTableView`, title it "Staff" and bind it to the `Departments.arrangedObjects` with the path `employees.@count`. You'll probably also want to make sure it is *not* editable (it'd be a strange use case indeed in which it *would* be editable).

<img src="/files/files/2008/07/counting-department-employees-ib.png" alt="Adding department staff numbers" width="500" height="470" class="aligncenter size-full wp-image-27" />

As in my last post, we're using bindings to call `count:` on the array of employees for each department. Last time we just used it as a flag, but this time we're actually displaying it. Save the NIB (or XIB) and rebuild the app. You should now get employee counts like this:

<img src="/files/files/2008/07/counting-department-employees.png" alt="Counting department employees" width="500" height="291" class="aligncenter size-full wp-image-23" />

Great! We made the change we were after: the user now gets to see (and use) the number of employees in each department. If our employment practices were more complex we might have part-time and job-sharing employees and need to display Full Time Equivalent staff members: this should be pretty easy too. We could add an 'fte' field between `0.0`&mdash;`1.0` to the *Person* entity and rather than just counting the number of staff we could total up their fte values fields by binding to `employees.@sum.fte`. At least, we might expect to be able to. Alas, I couldn't get it too work.

Even if it *did* work, I'm far from convinced that this is the "Right Way"(tm) to solve this problem. Surely there is a way to add a computed field like this one to a Core Data model without having to use a custom `NSManagedObject` subclass and to recalculate the value of transient property it every time it's requested (or using KVO or some such to recalculate it every time the fields it depends on change)? If so, I haven't been able to figure it out...

I've described a way to work around this problem using a subclass of `NSValueTransformer` in my post [Emulating Operators for Core
Data](/2008/emulating-operators-for-core-data/).
