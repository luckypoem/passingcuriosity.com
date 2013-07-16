---
wordpressid: 450
wordpressurl: http://passingcuriosity.com/?p=450
layout: post
title: Hierarchical Rights in Drupal
tags: drupal, authorisation, permissions, ideas
location: Perth, Western Australia
excerpt: 
  There's been a bit of noise about alternatives to the rather limited 
  permissions system in Drupal. Here are a few of my thoughts about one 
  proposal.
---

I discovered a blog post called [More flexible rights
management?](http://www.garfieldtech.com/blog/hierarchical-acls) by Larry
Garfield at some point over the last three days (that being how long Safari
has been running). Having a few thoughts about it and a pressing need to write
a blog post for today, I'll get them down "on paper" and call it a job done.
Larry references Markus Wolff and his description (in a post called [A
pragmatic approach to rights
management](http://blog.wolff-hamburg.de/archives/25-A-pragmatic-approach-to-rights-management.html))
of an permissions management system. Markus' system (he in turn references a
former boss, but I shall ascribe it to him anyway) looks like this:

* Rights are denoted by dot-separated, reverse hierarchical names (e.g:
  ''Application.Component.Subcomponent.Right'').

* Permissions can specify rights with wild-cards (e.g. ''Application.*'').

* Rights can also be negated (e.g. ''-Application.Shutdown'').

Thus a user who can do anything *except* shut the application down might have
a permissions list like:

``````php
    $user->perm = array("Application.*", "-Application.Shutdown");
``````

As such schemes go this one is adequate, but as a replacement for Drupal's
current system it's not that crash hot. In fact, all it brings to the table is
a little more convenience: it is no more expressive than the current system.
Now convenience is a pretty cool thing and the Drupal permissions system could
really, *really*, **really** do with some more convenience, but if there's to
be a new system, I'd much rather see something genuinely more powerful.

My suggestion is this: rather than have a single hierarchy of rights which
jumbles variously the rights, the objects, and the implementers of both into
one great big messy tree, why not have rights permissions be a tuple of a
right and an object specifier. This will result in two smaller, less
complicated trees the paths of which can be clearly and easily interpreted.
With this scheme, many of the permissions seen on most Drupal sites would be
replaced with a much smaller collection of rights and a similarly small number
of object specifiers.

The current system includes five permissions (create, delete own, delete any,
edit own, and edit any) for each and every content type. In my suggested
system, these would be replaces with just those five rights which would, when
granted, be applied to particular object specifiers. The "edit any story
content" permission might become "(Core.EditAny, Node.Story)", for example.

One advantage such a scheme would have is in breaking down some of the super
permissions like the various "administer ..." permissions. Rather than
creating large numbers of new permissions, it would be possible to grant
"Core.Administer" right to a particular group of settings. Again, this will
reduce the large number of permissions (approaching one per module) and
replace them with a single reusable permission applied to a range of domains.
The "administer menu" permission might be replaced with "(Core.Administer,
Menu)" or, more excitingly, with "(Core.Administer, Menu.PrimaryLinks)".

Having written a little about this, I'm not entirely sure that it's a good
idea or a good fit for Drupal. Such a flexible system would certainly have a
smaller UI (in terms of screen real-estate) than the current approach, but it
would be more complex. It would make core more powerful, but it wouldn't
obviate the need for third-party modules to augment or replace the system when
it can't implement a required policy. In fact it's a stupid idea, so forget
about it and lets all just pretend that I didn't say anything.
