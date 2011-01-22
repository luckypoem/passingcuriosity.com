---
layout     : post
title      : "Notes: Exportables by Simon Hobbs"
categories : [ddu2011]
tags       : [drupal]
location   : Brisbane, Queensland
excerpt    : |
  Notes on Simon Hobbs (sime) talking about exportables.
---

Simon Hobbs (sime), from Melbourne, introducing the Exportable functionality from
CTools.

How many people understand the concept of/have used Features?

Exportables are objects that can live in the database, in code, or both. Code is
good for deployment, database is good for modification. Exportables gives us the
best of both worlds.

Part of CTools: export, object caching, form wizard, AJAX forms, etc., etc. Lots
of cool stuff.

1. Deploy code
2. Update database
3. `drush feature-update`
4. Go to (1)

Views introduced templating in around 4.7 to work around the "start from scratch
in this clunky UI" problem. Revisited the ideas a few times and pulled it out
into CTools.

Benefits of implementing exportables:

1. Site builders can control details.
2. You objects can be used in Features, Profiles, Distributions.
3. Fit into enterprise development workflows.

(Earle's stuff, Development Seed stuff, etc.)

(Would be good to see support in things like Skinr, Inject CSS, etc. So that site
admins can override and configure things.)

Yet another dependancy?
-----------------------

In D7 CTools is "practically core" -- a bunch of modules that you *will* be using
depend on it: Views 3, Strongarm, Feeds, WYSIWYG, Open Layers, Panels, Context,
Services, Boxes.

Example
-------

A "hello world" demo module to be extended with support for exportables:
`eg_exportable`. All of merlinofchaos' work ships with online help and include
example modules. See https://github.com/simesy/examples/

The module just creates a table (no UI, etc.)

Step 1: Tell Exportable about your data 
---------------------------------------

Add an `export` key to your `hook_schema` with a description of your objects.
Features can now handle your stuff.

**I'm already getting tired.**

Step 2: Export UI
-----------------

1. Specify a CTools plugin directory (by implementing a hook) so that it will be
able to find the implementation of your `export_ui`.

2. Add the plugin info (`module/plugins/export_ui/whatever.inc`). References the
schema from *step 1* which includes your `export` key. This pretty much just
works, nothing more is needed and you get all the functionality you're used to
from Views: clone a *thing*, export a *thing*, import a *thing*.

Other functionality you'll probably need to implement includes:

- Implement your own creation UI.
- Extend your export class with your own load and save routines.

See the `help/` directory in CTools for more documentation, or look at the [Skinr
Export](https://github.com/ericduran/skinr_export).

Questions
---------

CTools automatically imports the code-defined stuff into the database
automatically and will keep track of them. Can tell when things have been
overridden in the database (possibly using a flag that is modified by the API,
making things identical after a change still says *Overridden*).

You don't *need* a machine name in your exportables, but you'll get warnings and
conflicts because it'll fallback to your primary key.

The default mode of operation is to load exportables into the database. The
various status checking operations are cached and happen in UI operations, so
it's all still performant. You can, however, tell it your stuff is code-only.

The proliferation of hooks might be a problem for performance or the sanity of
developers.

With this work, there's been a push to give unique identifiers to things like
`node`, `vocabular` and `user` so that they are reliably exportable. `UUID` is
one example of this, which assigns a UUID to each node and lets these be exported
with features.

