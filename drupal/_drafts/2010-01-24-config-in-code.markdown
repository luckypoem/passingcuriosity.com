---
layout     : post
title      : Config in Code with Drush and Features
tags       : [drupalsouth, drupal, drush, export, features, modules]
categories : [drupalsouth]
location   : Wellington, New Zealand
---

[Josh Waihi][jw] talking about [Config in code with Drush and Features][talk].
He'll be covering some of the things that help with development, staging,
production setups and similar issues.

[jw]: http://geek.joshwaihi.com/
[talk]: http://wellington2010.drupalsouth.net.nz/session/config-in-code-with-drush-and-features

Drupal is very flexible, a little bit like Play Doh. 

Modules help you build Drupal faster. But sometimes you need to do stuff that
*isn't* in code : things like content types, views, etc, etc. Moving this
stuff from development to staging to production is hard.

There are a few potential solutions
===================================

Solution 1: Features
--------------------

An module (and API) which allows other modules to export their database
configuration stuff into code. And an interface to maintain it with.

First you built your feature (an image gallery for example) using the usual
tools: CCK to store it, Image Cache to resize and filter it, Image Field to
integrate it, Views to display, etc. Then compile the feature with Features:
it'll generate a module which will "restore" those node types, views, etc.
which you can check in to version control (like Git, Wooo!).

The user interface for creating a feature is really simple: just give it the
basic `module.info` metadata and select the bits you want included (the
content types, views, etc) and click the button! It will wrap those bits up
and generate a new tarball for you to download.

Solution 2: Drush
-----------------

Swiss Army Knife for Drupal; it's there for speed: you use the command line
and avoid the presentation line.

Also: `drush_make`

Drush also has an API that allows modules to extend it (and also has it's own
plugins).