---
layout: post
title: Sydney Drupal Meetup, March 2013
tags: drupal, sydney, acquia, performance, profiling, xhprof
excerpt: My first Drupal meetup since moving to Sydney.
---

I attended my first [meetup with the Sydney Drupal group][1] tonight and saw a
couple of interesting talks:

1. Chris Harrop from Acquia introduced their devcloud platform and some of the
   other tools and services they offer.

2. Murray Woodman presented some performance measurements of node loading when
   using [Entitycache][2] and other techniques.

3. Justin Randall gave a pretty thorough introduction to using XHProf to detect
   and identify performance problems and regressions.

[1]: http://www.meetup.com/drupalsydney/events/78491452/
[2]: http://drupal.org/project/entitycache

Acquia
======

Chris' talk about Acquia's offerings was very short and quite high level. I was
interested to see their "checklist-style" Drupal evaluation and testing tool as
I'd was looking at a similar sort of run-the-tests-in-this-checklist tool
yesterday.

Also: I got a code for a free dev environment on their cloud service.

Node Weight
===========

The bulk of Murray's talk was to present benchmarks of several approaches to
improving `entity_load` performance in Drupal sites.

He compared:

1. Setting `innodb_buffer_pool_size` appropriately to your machine and
   workload.

2. Enabling the MySQL query cache.

3. Installing the [Entitycache][2] module.

4. Using APC to store cached objects.

5. Several combinations of the above.

The biggest and quickest win was installing *entitycache* (which resulted in an
"80%" performance improvement), with the other techniques yeilding smaller
improvements.

XHProf
======

Justin began his presentation with a quote:

> Don't bring logic to a data fight.

Analysing system performance and identifying performance problems can be
complex and real data on specific cases is more useful and more reliable than
logic. "Don't trust your gut, use science."

After a bit of good advice about performance -- it's a process not a goal;
test, and fix, client and network issues first -- Justin dug into using
[XHProf][3] to record and analyse performance profiles of Drupal pages.

[3]: https://github.com/facebook/xhprof

The XHProf extension has so small an impact on performance that you can run
it on production servers ready and waiting for a performance problem to
profile (which degrades performance by around "<10%").

Along with the XHProf extension are several tools to process and analyse the
recorded profiles:

- The moderately awful [web interface][4] which comes with the extension.

- The [XHProf Drupal module][5].

- [Mark Sonnabaum's XHProf CLI][6] tool to aggregate multiple profiles so that
  runs can be compared more reliably (when, e.g., checking for performance
  regressions in a patch).

[4]: https://github.com/facebook/xhprof/tree/master/xhprof_html
[5]: http://drupal.org/project/xhprof
[6]: https://github.com/msonnabaum/XHProfCLI

A good tip, which hadn't occured to me, was to use the [`auto_prepend_file`][7]
feature in PHP to enable XHProf. This is application agnostic, does not require
changes to the application code, and ensures that your profiles include the
whole application.

[7]: http://php.net/auto-prepend-file

The idea of building XHProf into my production environments, with a prepend
file configured and waiting to enable profiling (or automatically profiling,
say, 1% of requests) is intriguing.

Conclusion
==========

So this was a pretty good introduction to the Drupal community in Sydney, and
it was nice to see how other groups run meetups (though I gather there have
been some recent changes here).
