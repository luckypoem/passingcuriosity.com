---
title: Sydney Devops Meetup, July 2013
location: Sydney, New South Wales
tags: devops, meetup
excerpt: 
  After 4 and a half months in Sydney, I've finally made it to the Sydney Devops
  Meetup.
---

The [Sydney Devops Meetup](http://meetup.com/sydney-devops)

## Introductory Remarks

The web is fundamentally inconsistent -- pages are already potentially stale as
soon as they are served. Web applications that are written in ways that attempt
to enforce consistency (never caching pages, etc.) are throwing away the
opportunity to improve their performance.

### Cachability ###

> Google Team say that only 5% of HTML responses are cachable.

HTTP is inherantly cachable: any proxy between the client and the server can
cache any response unless you

Responses are divided into two aspects:

- The head of the response
- The body of the response

### Personalisation ###

Two approaches to personalisation of pages:

- Server side

- Client side

## Database Caching ##

Developers love building relational databases, usually optimising for write
speed and to maintain consistency. The system, as a whole, is read-dominant
and inherently inconsistent.

We [can] know the result of most queries before the query arrives. Maintain one
or more flat tables with cached, pre-processed data for specific use-cases. No
more joins, etc. Use the Command Query Responsibility Segregation (CQRS) pattern
to split the commands which prepare data (adding a product to an order) and the
queries which fetch data (retrieving my orders). See a blog post by Udi Dahan on
this pattern.

Use CQRS:

- when you have a read-heavy work load
- when you can predict the incoming queries

Impacts:

- denormalisation of data
- reads are faster (no joins)
- writes are slower (writing cache)

Costs:

- Architecture
- Developer and operations training
- Message queuing system

## Application Caching

Systems like memcached which sit between your code and your persistent data
store. Similar to CQRS, but rather than ameliorate the impact of expensive
operations at write time, we do the expensive reads and cache the results. The
hope is that the application cache is faster than the database.

Using an application cache:

- The first instance of a complext read still sucks.

- Can still suffer contention on database tables.

Use application caching:

- When you have identical, repetitive reads.

- When there is time pressure.

- When you can't scale your database systems any more.

Effects:

- Reduced app server costs
- Reduced db server costs
- additional ops requirements

Costs:

- Increases costs for application cache systems.

## Doughnut Caching

Caching resources with personalisation at request time, with the cache filling
in the blanks. Akamai's ESI is probably an instance of this?

Minimising the amount of content that is uncachable, by stripping out the
uncachable portions of each page.

- More complex programming model.

- Harder to introduce progressive enhancement.

## Reverse Proxies - Static files

Reverse proxy, caches static files and other cachable resources and passes
requests for dynamic content through to the application server.

85 requests to build a page (average of top 300,000 sites) last year. Now
90-something. 1.2 MB to 1.4 MB for a page.

Use this approach:

- All the time

Effect

- Easily maintained, no code changes

- Improve the operation of application tier through superior TCP session
  management.

- Still expensive serving files from your datacentre compared to a CDN.

## Reverse Proxies - Dynamic

Use a reverse proxy and configure the application to make pages cachable.

- Using the `Vary` header can allow caching of personalised responses at the
  expense of low cache hit ratios.

- Breaking some of the rules of HTTP can allow us to improve the cache hit
  ratio. Varnish is good at this.

With Varnish, unset the Set-Cookie header and cache the response. This will
likely result in *lots* of sessions being created in the application (one per
request that hits the app, rather than one per user).

When the user submits a POST request, Varnish will let the Set-Cookie header
through, from which point all traffic will go straight through to the
application server.

Set a cookie with the number of items in the cart. Now a page with only the
"X items in cart" message making it uncachable is cachable.

> 97 Things a Software Architect Should Know

## Reverse Proxies - Doughnut Caching

Doughnut caching in HTTP land is called "Edge Side Includes" (which I preciently
mentioned above). ESI is a pseudo-standard originated by Akamai and supported
in part by Varnish and some other CDNs.

Effect:

- Heavily couples the ESI layer and application servers

- Get a higher cache hit ratio than with cookie nuking.

## Content Delivery Networks

Obvious choice for static files.

- Bandwidth is cheaper than in your DC
- Throughput and latency is generally better.

Benefits come from geography and exceptionally good networking (one hopes).

Decent CDNs support things like:

- ESI
- Rules engines to allow for de-personalisation.

Similar to reverse proxies with ESI, the application can become tightly coupled
to the CDN. Propietary, lock-in, etc.

Push personalisation and functionality into JavaScript and AJAX and stick
content behind a CDN with caching and you can survive outages with degraded
service ("limited service mode"). Do this:

- When your HA requirements go beyond redundant things

- Performance is critical

- You can write JS.
