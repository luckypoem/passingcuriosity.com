---
layout     : post
title      : "Notes: Turbo Charge Your Drupal Site"
categories : [ddu2011]
tags       : [drupal]
location   : Brisbane, Queensland
excerpt    : |
  Turbo changing Drupal sites through the power of caching.
---

Kim Pepper from PreviousNext presenting on turbo charging your Drupal site.

Who am I? About 15 years in web dev industry. Worked on large, scalable
infrastructure (~65M requests/day). Founder and technical directory of
PreviousNext.

People of try to optimise at the wrong level: `for` vs `while`. The goal is to
server more visitors, more quickly (to them).

Pragmatics: small to medium sites, up to 100K visits per month, run on a
single VPS, 80/20 rule. A fairly typical 

First law of scalability: stop users from hitting your site
===========================================================

Avoiding requests from the browser is the first, best way to reduce load. The
HTTP protocol was designed to make this easy to do, so do it. Cache control
headers, conditional downloading, etc.

Send `Cache-Control: public, max-age=?` and `Expires`. Use `Cache-Control` in
preference.

Send `Last-Modified` and `ETag` headers allowing clients to do conditional
requests using `If-Modified-Since` and `If-None-Match` and get responses with
`304 Not Modified`.

Also need to look into the caching `Vary` headers.

Cache headers are respected by browser, local proxy, transparent proxies at
ISPs, reverse proxies in the data centre, your web server. You need to
configure caching headers correctly.

If you have to make requests
============================

Use a reverse proxy like Varnish, Squid, Nginx, even Apache can do it.

Varnish is very fast and very efficient, has high security and builds on the
features of the Linux kernel.

Tell Varnish about the backend server/s

    backend "default" { .host = "127.0.0.1"; .port = "8080"; // ... }

Modify an incoming request to make sure it's cachable:

    sub vcl_recv {
      // Strip out analytics cookies.
      // Normalise cookies, remove empty ones
      // Don't cache install.php, update.php, cron.php
      // Ignore GZIP requests for compressed formats
      // Normalise Accept-Encoding for gzip/deflate
    }

Comes with a number of tools to monitor and examine the behaviour of a Varnish
server. `varnishhist` displays a histogram: x is time to server request, `#`
is cache miss, `|` is cache hit.

Why Cookies are Evil
--------------------

Maintain state in a stateless protocol. Disables caching (and you want it
to!). You can use `Vary: Cookies` to cache pages (but they'll be per-cookies,
don't fill your cache).

In Drupal, use either Pressflow (D6) or D7 that uses lazy session
establishment so that you don't have session cookies until the session is
used.

If you only need cookies on some paths, strip them out everywhere else.

Also: try stripping cookie'd data out of pages and include it through AJAX (or
ESI if you're using Varnish).

Use a CDN
---------

The killer in page load times is TCP handshake, slow-start, etc. Using a CDN
kills the first (keep-alive reduces the second).

Rackspace Cloudfiles integrates with Limelight Networks have a node in Sydney.

Use the CDN module and/or FileConveyer (needed when the CDN does not do pull
through).

If you *must* hit Apache
------------------------

Do automatic traffic-level optimisation: use `mod_deflate` on text content.

`ETags` might be evil (especially if you're coming of different front-end
nodes). Not required anyway and `Last-Modified` is better, so just use it.
Certainly shouldn't be using inode number.

Use `mod_expires` to send long cache expiry headers for static resources.

Don't serve Drupal 404 pages for what looks like static content.

Apache's default configuration is middle of the road, but focuses on serving
files. 

Determine how many clients you can handle with available resources and
actually set `max_clients`. `max_clients = $RAM / $apache_size`.

If you *must* run Drupal
------------------------

Avoid hitting the database: use the page cache, block cache, views cache.

See the Views Content Cache module which can flush views caches when content
of specific types is modified.

Use op-code caches like APC, but make sure your cache is large enough to hold
Drupal (and, if you use it, data). You might need to use the PECL version
rather than the package versions.

Use the Drupal caching sub-system. By default it goes in the database, but
CacheRouter (or in Pressflow, or D7 core?) lets you put various caches in
other backends.

Avoid database writes: reads are slow, but writes are many times slower. Use
syslog rather than dblog.

If you must write to the database, can you do it asynchronously? Use the
queuing solutions (Drupal Queue talking to beanstalkd) to move things out of
the request cycle.

If you must hit the database: use InnoDB, set the bufferpool size large
enough. Use `mysqltuner.pl`

Questions
---------

Hasn't looked at ESI.

Normally run Varnish, Apache, MySQL all on the same machine. First step is
normally to move to a dedicated database server; then maybe move Varnish.


