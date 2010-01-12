--- 
wordpress_id: 92
layout: post
title: Binding Operators With Core Data
wordpress_url: http://passingcuriosity.com/?p=10
---
Tim Isted posted an excellent tutorial on building [Core Data applications with multiple windows](http://www.timisted.net/blog/archive/multiple-windows-with-core-data/) which really cleared up some of the mystery of using Core Data for me. He guides you through the process of modifying a "Core Data Document-based Application" project to support multiple windows per document. There are a few enhancements to the project that simply cry out to be made.

<!--more-->

Tim notes that the user interface can be improved by ensuring that the "add" and "remove" buttons for the *Departments* and *People* are enabled and disabled based on the state of the model. This is, as he points out, pretty simple, and it's described in very nearly every bindings tutorial out there. Simply bind "Enabled" to the <code>canAdd</code> and <code>canRemove</code> keys of the appropriate <code>NSArrayController</code>s.

Properly enabling and disabling the "open employee window" button is slightly more difficult: where the other bindings in this tutorial simply bind values (the departments to display, the name of the person, etc.) here we're interested in binding to a property of the value -- whether it's empty or not -- rather than the value itself. Happily, this is almost as trivial as the previous cases. Rather than simply binding the values of a controller or model we'll need to use an *operator* to transform the value of a controller key so that we can use it.

The enabled binding expects its bound value to be a boolean: a widget is either enabled or disabled. The select of an <code>NSArrayController</code> is some other collection or other (I'm not entirely sure which, but it's definitely not a <code>BOOL</code>). To transform this possibly empty collection of <code>NSManagedObject</code>s into an empty-or-not <code>BOOL</code> we can exploit one of it's operators <code>@count</code> (the rest are describe in the [Set and Array Operators](http://developer.apple.com/documentation/Cocoa/Conceptual/KeyValueCoding/Concepts/ArrayOperators.html#//apple_ref/doc/uid/20002176-BAJEAIEE) section of the [Key-Value Coding Programming Guide](http://developer.apple.com/documentation/Cocoa/Conceptual/KeyValueCoding/index.html)). <code>@count</code> is basically just the good old <code>count:</code> method from <code>NSArray</code>: called on a collection, it returns the cardinality of that collection as an <code>int</code>. As we all know, most C-based and C-like languages allow you to treat pretty much anything as a <code>BOOL</code> with <code>0</code> being <code>NO</code> and every other value <code>YES</code>. This is exactly what we want.

To solve our problem then, we should bind "Enabled" for the "open employee window" button to "People.selection.@count". Now the button should be disabled when no people are selected and enabled when there are people are selected.

<img src="http://passingcuriosity.com/wp-content/uploads/2008/07/no-selection-disabled.png" alt="Button disabled with no selection" title="Button disabled with no selection" width="500" height="225" class="aligncenter size-full wp-image-11" />

<img src="http://passingcuriosity.com/wp-content/uploads/2008/07/selection-enabled.png" alt="Button enabled with selection" title="Button enabled with selection" width="500" height="225" class="aligncenter size-ful wp-image-12" />

Alas, the rest of the set and array operators (`@sum`, etc.) don't seem to work. See more on this problem in [Computed Attributes in Core Data, How?](/index.php/2008-07/computed-properties-with-core-data) and one (not entirely pleasing) solution in [Emulating Operators for Core Data](/index.php/2008-07/emulating-operators-for-core-data).
