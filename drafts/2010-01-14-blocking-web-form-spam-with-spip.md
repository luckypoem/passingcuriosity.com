---
layout   : post
title    : Reducing web form spam with SPIP
tags     : [php, code, SPIP, forms]
location : Perth, Western Australia
excerpt  : |
  We've been having some issues with spam web form submissions on some of our
  SPIP web sites recently. Here are some thoughts on reducing the problem.
---

We've been seeing an increase of SPAM on a number of sites lately. Yirra Yaakin is having a problem with the SPIP Listes subscription form being spammed (and thus filling spip_auteurs with junk accounts) and Orbit Fitness has been seeing some spam on their contact form (even with a "honey pot" field in the form).

We might want to think about adding support for a SPAM-filtering service to the various plug-ins. There are a number of services to choose from, mostly focussing on blog comments:

* Akismet (by the Wordpress people) <http://akismet.com/development/>
* Mollom (by some of the same people who develop/ed Drupal) <http://mollom.com/download>
* Defensio (which I've never heard of before, but Mollom feel the need to compare themselves with) <http://defensio.com/downloads/php5/>

Akismet is the "original" popular spam filtering service, Mollom has a nice UI (in the Drupal plug-in, at least) in that it feeds a new comment to Mollom and will ask the user to do a CAPTCHA if the service says SPAM or maybe SPAM.

All three have a PHP library that we can use (and even if we don't want to use them, all three are reasonably simple RESTful APIs which are pretty easy to implement).

There are also a few SPIP plug-ins including:

* A few CAPTCHA plug-ins
* NoSPAM (used on SPIP-Contrib, if "Utilisé par spip-contrib" means what I think it does) <http://www.spip-contrib.net/NoSPAM,1165>

The NoSPAM one looks interesting, but not immediately useful for our purposes.

We might want to think about moving toward using CVT -- the new form 'technology' in SPIP 2.0 -- to do forms <http://www.spip.net/en_article3980.html> <http://www.spip.net/en_article4249.html>. For most sites, the "contact" forms will be pretty much identical (a plug-in that we just install), but they are easy to customise when we need to (if we do the PHP right, we'll just need to customise the form template, and maybe change a global array with a list of field names, or some such). By the looks of it, the NoSPAM plug-in seems to interact with CVT to allow you to specify any #FORMULAIRE_FOO to be checked for SPAM...