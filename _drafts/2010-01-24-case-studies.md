---
post     : post
title    : DrupalSouth Case Studies
tags     : [drupalsouth, drupal, case study]
location : Wellington, New Zealand
---

FixMyStreet
===========

Bringing [FixMyStreet][fmsuk] to New Zealand with [FixMyStreet.co.nz][fmsnz].
Allows people to submit issues with streets, etc. and will forward them on to
the appropriate council. Supports the Android and iPhone applications.

[fmsuk]: http://www.fixmystreet.com/
[fmsnz]: http://fixmystreet.org.nz/

It uses geonames and a few other webs services to geocode and reverse geocode
various bits and pieces (finding the appropriate council based on the
location, for example).

Modules: CCK, Views, Workflow, Geo, GMap, GMap Geo, Image Cache, Node form
columns, a few custom modules (confirm by email, geo for coding, reporting,
smart phone interface, etc.)

Down the track: augmented reality (publish as feed for visualisation),
standardisation (getting up in the US). May see some abuse of the service.

Building calculators with Drupal
================================

Kale Worsley from Egressive talking about how to build web-based calculators.

[NZTA][nzta] asked to build a predictor for traffic noise on a single segment
of road. It asks questions of the user and then make a prediction.

[nzta]: http://nzta.govt.nz/

Anon access, opt reg, multiple save points, conditional save fields,
calculation history, etc.

Make each calculator a node type and each calculation a node. This made it
possible to meet the requirements by leveraging modules like CCK, Views,
Computed fields, bulk operations, DOM PDF.

Lessons: put the calculations for computed fields in a module under version
control (rather than the Big Textarea o' PHP).

Cannot rely on JavaScript (it's a government project and must adhere to
accessibility guidelines).

Project management with Drupal
==============================

Egressive have a Drupal-based project management system. 10+ developers, 10-15
projects on the go at a time, forward planning.

* Tight deadlines
* Scope creep is a perpetual problem
* Convey project tasks to the developers can be difficult
* Time reporting and invoicing = intense pain
* Difficult to monitor progress both for management and clients
* Difficult to tell when a new project might be done

How to fix it?
--------------

...adopt or adapt the "best of breed" solution? No. We're developers, do our
own. Thus "Ned" was born in 2008 based on Drupal 5: customer, project and
issue tracking; usecase development (but didn't scale across many projects).
No time tracking, lots of custom code.

"Ned 2" in 2009: upgraded to 2009; time tracking; does nice reporting (but
only some) and views will make new ones pretty simple; other cool stuff. Using
new web-based time tracker is great; invoicing now trivial (can also link
invoices to particular money); far fewer invoicing errors; adaptable and easy
to tweak.

Todo
----

Interface enhancements to improve usability, with more convenience and
improved workflows. Developers and support staff have quite different
workflows.

Refactor to remove custom code (hacked case tracker).

More reports

Archiving old and inactive project and customers.

The future
----------

"Steve" Planning to make it available as a feature.