---
layout   : post
title    : Angela Byron on Drupal 7
tags     : [drupalsouth, drupal 7]
location : Wellington, New Zealand
excerpt  : |
  On Saturday afternoon at DrupalSouth, Angela "webchick" Byron spoke about
  the forthcoming Drupal 7 release.
---

On Saturday afternoon at DrupalSouth, [Angela "webchick" Byron][ab] spoke
about the forthcoming Drupal 7 release.

[ab]: http://www.webchick.net/

She started w/ Drupal in 05 in GSoC. D7 release managed. Works for Lullabot

Where does Drupal come from?
============================

1. Release current version

2. Open next version for development (branch to HEAD) and the oldest version
   goes into retirement.

3. "Code thaw" - fix things that annoy you, add features, integrate new stuff.

4. "Code freeze" - squashing bugs, alpha, beta, release candidates.

5. GOTO step 1.

6. Port all your modules.

Feb 08, 6 released. Sept 09 Feature freeze. Oct 15 09 Code freeze. Nov 15 09
polish phase. Now testing and waiting for it to be ready.

When is it ready? When "critical bugs" reaches 0.

Should I build production sites on D7? NO! Jesus don't do that; it's got how
ever many critical security bugs.

Show I start porting modules and themes no? Hell yes.

New thingo #D7CX : people who're promising that their modules and stuff will
not blow up and piss the [user] developers off. Trying to avoid the situation
with D6 where contrib took a year to catch up.

Question: There was a deadwood module which helped port things to D6. Is there
such a thing for D7? It's been folded into coder or devel or something?

There will not be any official support for Drupal 5. That's what unsupported
means. No alerts or anything for D5. When upgrading, do D5 -> D6 -> D7 (that's
the official path anyway: you can't skip major versions).

Two options at install: standard and minimal. Checks that the environment
meets the requirements and reports much more nicely.

One of the major improvement is a PDO-based database abstraction layer.
Supports replication, etc. hook_query_alter()

Proper timezone support.

Security: `update.php` is not tied to UID 1, there's a permission now.

New overlay that helps differentiate frontend and backend. Toolbar and
shortcuts. Blocks, nodes, menus, etc. all have contextual links now.

Help has been re-written to have *about* and *uses* and stuff. The front-page
doesn't have that silly message anymore.

Killed story, now have *article* and *basic page*. Images in core (and image
cache, called image styles). Removed "teaser splitter" Renamed input formats
to text formats. Have tags by default.

Vertical tabs and other UI improvements. This work was driven by the three
laboratory usability test.

Also has install and update for contrib modules and themes (but not core).

The table based themes are gone. New "stark" theme which is no theme at all.
Accessibility work is ongoing with the intention that it'll be usable out of
the box on government projects, etc. which have hard usability requirements.

Ships with jQuery UI now, and it's used in the dashboard as something of a
showcase. Encouraging developers to think about blocks for administrators.

CCK is in core now (as fields). Works not just for nodes, but for users as
well. Have now added an "entity" abstraction which super classes node, user,
term, etc. all of which can use fields.

Permissions now have optional descriptions. Will never ever have a "select all
permissions" feature: that's what the admin role is (and you can edit a role
and use web developer tool bar to popular form fields). Uses JS to
automatically "tick" permissions when you tick them for authenticated users.

**RDF** Drupal comes with native RDFa support (which Dries is really excited
about) (holygoat.co.uk). Drupal 7 automatically includes a bunch of metadata
stuff. Discovery, FOAF, etc. Woo.

**Testing** In D6, Angela was the testing bot (which wasn't fun). Now use the
testing framework to add automated tests which can be done by the robot and
also through the web interface. Useful for unit testing "personal" projects as
well.

800 contributors to D7 so far.

7:30 PM at UStay.