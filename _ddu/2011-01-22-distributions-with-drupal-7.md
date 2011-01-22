---
layout     : post
title      : "Notes: Building Distributions with Drupal 7 and Imaginary Internet Access"
categories : [ddu2011]
tags       : [drupal]
location   : Brisbane, Queensland
excerpt    : |
  Notes on Dave Hall's talk on Building Distributions with Drupal 7 and
  imaginary internet access.
---

Dave Hall: own business, latest Four Kitchens recruit.

Drupal Distros
==============

Drupal distributions are a way of making products out of Drupal. Development
Seed describe them as stuffed toys: Drupal and modules is the stuffing and the
skin is the theme.

Original approach was to ship a codebase and a database dump. But this was very
inflexible.

With D6 you have core, modules, theme, install profile, etc.

Then the Development Seed crew came up with their stuff: Drupal, Views, CCK,
CTools, Features, modules, theme, and some custom features modules, with a
profile to coordinate them all.

In D7, they'll be more like the Lego space shuttle set. It's got lots of pieces
and an awesome results, largely because all the pieces have been very carefully
chosen to produce a specific outcome.

Code
====

Using `drush make`.

Using build kit, which kills some kittens by hacking core, but makes it much
more legitimate using patches applied in a make file (with comments!) This
removes the primary objection to core hacks in that it removes maintainability.
Patches in a make file are eminently maintainable.

In Drupal 7 installation profiles become first-class citizens: it has a `.info`
file, dependancies, and the dependancies are automatically resolved (no more
specifying all modules, in the correct order), has a `.install` with a
`hook_install()` (just like a module).

Using Features modules means that the `hook_install()` in the profile is
empty-ish: all the cruft that used to be here in in the modules now. Building a
profile the normal way involves duplicating a lot of the stock code for blocks,
themes, input filters, RDF, etc., etc., etc. Changing one of these options used
to need a `hook_update_NNNN()`, now regenerate the feature module and push the
upgrade.

Drupal 7 has given more of a structure to the problem space addressed by
installation profiles and the intention and the right way to do things is much
more obvious.

Features hasn't really changed in Drupal 7: importing, exporting, etc. all
works pretty much as it did in D6.

Example
=======

No Internet access, so no real demonstration.


Questions
=========

Something about using build kit?
--------------------------------

- `.build` defines the version of core and the install profile.

- `.make` lives in the profile and imports the modules and such, possibly
  recursively.

- Working on module `.make` files on GitHub that you can import. `admin.make`
  might include `admin` and `tao`. Then you can compose the sets of
  functionality that you want.


What is `.build`?
-----------------

A new convention for `drush make` files which define a platform: 

- The API and core versions.
- The core implementation (Drupal, Acquia Drupal, Pressflow, etc.)
- Any core patches.
- The profile to use.

Everything else is pulled in via recursively from the profile and module
`.make` files.

Can you explain how feature servers work?
-----------------------------------------

A functional equivalent to `http://updates.drupal.org/` that hosts your own.

Can you do authentication on feature servers?
---------------------------------------------

Drupal's update code can't do authentication, but make files can.


