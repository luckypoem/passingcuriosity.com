---
---

Problem?
========

Dropbox: automatically store and sync files between the machines via the
cloud.

Work in an agency/organisation full of people that can't use a file server.
Graphic designers using instant messenger to exchange files.

Difficult to find the "current" version, especially when they don't have a
"system".

Subversion: too hard, so back to the status quo.

Dropbox expensive (1.3 TB of data), slow (AU and NZ tubes are narrow), account
management (primitive), security (pretty good).

Watch for changes, transfer and synchronise

First go
========

Subversion with a cron job.

Problem: delete a folder and the `.svn` file goes too. This breaks the
Subversion repository. Woops.

Second
======

Git and cron.

Bunch of shell scripts and stuff making this work properly - detect conflicts
and make sure they don't clobber each other.

http://github.com/benbalbo/iizip