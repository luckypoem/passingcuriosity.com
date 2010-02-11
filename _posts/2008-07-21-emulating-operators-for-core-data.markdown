--- 
wordpress_id: 130
layout: post
title: Emulating Operators for Core Data
wordpress_url: http://passingcuriosity.com/?p=56
---
My last Cocoa post described a problem I encountered extending a Core Data tutorial by using bindings operators to aggregate a property of Core Data entities through a relationship. With a bit of grovelling through documentation and some help and guidance from [Tim Isted](http://www.timisted.net/) I've managed to get it to work, sort of.

Given Department and Employee entities and a 'employees/department' relationship between them, I tried to bind a column in an NSTableView to `employees.@sum.fte` to display the Full Time Equivalent staffing for each department. Alas, it was not to be and in this post I'll explain [a little] why this is not the case, and one way [a dirty, filthy hack] to work around it.

<!--more-->

The problem is caused by the way in which Core Data returns the collection of entities at the "other" end of a to-many relationship. Core Data, as you may already know, loads data from a backing store lazily, that is: only when it absolutely must (or is told to). This has a number of benefits from a whole-system point of view including reducing memory consumption, decreasing data staleness, etc., etc. Core Data does this using *faulting*: when a piece of data is needed that hasn't been loaded yet, it generates a fault (this is a grossly simplified over generalisation). Ordinarily this isn't a problem: if you're using entities through a controller (that prepares it's content) or, I suspect, through a one-to-one relationship then everything works transparently. It does become a problem in this case when you want to use the far end of a to-many relationship. Rather than return a `NSArray` and `NSSet` or some other standard collection class, the relationship returned an `_NSFaultingMutableSet` a private-ish (not the underscore) class that implements most of the interface of an `NSMutableSet`. The key word here is *most*.

Where `NSMutableSet`, `NSArray`, their subclasses, and assorted others allow the use of [set and array operators](http://developer.apple.com/documentation/Cocoa/Conceptual/KeyValueCoding/Concepts/ArrayOperators.html#//apple_ref/doc/uid/20002176-178593), `_NSFaultingMutableSet` apparently doesn't. Or not those that depend on the objects in the collection -- like `@sum`.

The new problem then is to convert this `_NSFaultingMutableSet` into something the widget can display. Looking at the binding inspector in Interface Builder, the most obvious option is that *Value Transformer* box. Thankfully, value transforms are reasonably simple, especially when they are one way. After you subclass `NSValueTransformer` to do what you need, create an instance, and register it with a given name (I did it in `[MyDocument init]` as suggested by Tim, how ever you do it, it probably needs to be done before the NIB is loaded). Then entering the name in the *Value Transformer* box in IB gets it called. A little bit of code using an `NSEnumerator` to emulate `@sum` and it now works:

<img src="/files/files/2008/07/emulating-operators-with-value-transformers.png" alt="Emulating Operators with an NSValueTransformer" title="Emulating Operators with an NSValueTransformer" width="478" height="210" class="size-full wp-image-57" />

Thanks to Tim Isted for his help, guidance, and sample code. Suggestions are welcome as to other, perhaps better, ways to get this to work.
