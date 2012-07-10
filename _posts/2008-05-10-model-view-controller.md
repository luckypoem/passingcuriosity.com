--- 
wordpressid: 9
wordpressurl: http://barcamp2.wordpress.com/?p=9
layout: post
title: Model View Controller
tags: bcperth09
categories: [barcamp]
location: Perth, Western Australia
excerpt: |
  Some notes from a Barcamp talk about Model-View-Controller in ASP.Net.
---

(In ASP.net)

Separation of concerns. Model does data stuff. View is presentation. Controller plumbs data from the models and views.

<h3>MVC Pizza</h3>

Mark, Vinnie, Carmella.

Carmella (the controller) recieves phone orders. Tells Mark (the model) to make it. He gives is to her and she passes it on to Vinnie (the view) to delivers it to the user.

<h3>DetailsÖ</h3>

Lots of rather thin metaphores for invariant interfaces allowing you to modify/replace specific components.

Looks heaps like an ASP clone of Rails/CakePHP/etc.

Has standard routing of URLs to controller/action.

Built-in unit testing support, etc.
