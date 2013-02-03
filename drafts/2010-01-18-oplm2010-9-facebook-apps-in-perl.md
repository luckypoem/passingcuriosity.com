---
layout     : post
title      : Creating Facebook Applications in Perl
categories : [lca]
tags       : [lca2010, oplm2010, perl, code]
location   : Wellington, New Zealand
---

Paul Fenwick from Perl Training Australia talking about building Facebook
applications in perl.

Warning: had talk in pretty good shape. But then talked to some people at
UStay. He neglected to follow his own advice: don't change your topic at 1:00
AM the morning it's due.

Also: this talk is about using free software to access information in Facebook
(a closed system).

Also: about extending your "exobrain" - the information and tasks and stuff
that are outside your brain.

Using Perl -- because he's familiar with it -- and JavaScript.

Social Networking War
---------------------

Lots of SNs. He's tried:

* Orkut
* MySpace
* Facebook

Facebook seems to be winning. On the other SNs, you need to talk to your
friends and stuff. On Facebook you use shitty apps and spam your friends.

Relationship
------------

Not a Facebook employee. Rather a troublemaker (finding and publishing
security and privacy flaws).

Coding about Facebook
---------------------

http://developers.facebook.com is Facebook "development" for dummies.

http://wiki.developers.facebook.com/ is the "real" documentation.

http://facebook.com/developers/ is the application to have an application.

Settings
--------

"Canvas" is for when you need to display stuff. It associates a facebook.com
URL with another URI (on your server, for instance). Also need a "Connect URL"
so that it can use FBML.

XFBML - superset of XHTML. Basically an additional namespace in your XHTML.
Also FBJS - superset of JavaScript.

This give you the ability to put widgets on your pages:
`<fb:comments></fb:comments>`. Note that XFBML doesn't have self closing tags
(though FBML does)!

"Real" Apps
===========

Using WWW::Facebook::API from CPAN.