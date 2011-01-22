---
layout     : post
title      : "Notes: Goodbye Centralisation, Hello Distribution"
categories : [ddu2011]
tags       : [drupal]
location   : Brisbane, Queensland
excerpt    : |
  Notes from Josh Waihi's keynote talk: Goodbye Centralisation, Hello
  Distribution.
---

Centralised version control system - single source of truth. Users get a
snapshot of the current state, change it, and push the changes back. CVS, SVN,
Perforce, ClearCase, etc. (Also: Word, Drupal, etc.)

Drupal uses this like so: report an issue, submit patches, tested by the
community, marked "ready to be committed", a committer picks up the patch and
commits it.

Suck for age, stupidness, losing history, moving, recording committers instead
of patch authors, no-offline operation. No real support for community
operations.

Distributions
-------------

UR REPO IZ TEH MASTAH!

Have a local copy of the repo. Make changes and commit to local repo. Merge
and push.

Git, Darcs, Mercurial, etc.

Pros
----

- Security and assurance of your repository.

- Fast, offline

- Lots of awesome tools for things like visualisation, access control, etc.

- More people in the Drupal community know Git than alternative systems.

- Works with standard protocols: SSH, HTTP, FTP and rsync.
