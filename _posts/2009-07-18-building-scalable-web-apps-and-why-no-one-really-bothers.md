--- 
wordpress_id: 1324
layout: post
title: Notes on "Building scalable web apps (and why no-one really bothers)"
wordpress_url: http://passingcuriosity.com/?p=1324
---
A presentation by [Adrian Chadd](http://www.creative.net.au/) (adrian@creative.net.au) on building scalable web applications.

<!--more-->

Failure in scaling means running out of: CPU, memory, disks, db, network. Any one of these can look like the others. People are pretty expensive, so most outfits buy more gear.

Sometimes, the resource isn't scalable (e.g. a DB server). Scaling isn't linear (2x machines do not get 2x performance).

(Facebook have written a PHP to native bytecode compiler, it's easier than rewriting it and makes it all faster.)

What about the "cloud"? Mostly marketing speak. Usually: dynamically allocated, managed resources. 

Given this all: how can we write stuff that scales?

1. How does the network work?
2. How does the computer work?
3. Live and historical monitoring (so we can tell what needs improvement)

The size of a code base does not correlate with the runtime performance. Typically large code bases will have layers upon layers of abstraction. If one layer has problems, it and everything that interacts with it may need to be modified.

A security layer that deserialises a tree of permissions every single request, for instance, may work well for 30 pages, but crash and burn for 30K.

### Disks ###

Disks are not infinitely fast. Static resources, logging, etc. What happens to your app when disk I/O is maxed out? If you can't load the bit of AJAX Javascript from disk, will everything die?

### DBs ###

phpBB, for instance, starts grinding at about 500k posts. People tend to assume that you can "just get a bigger DB server". What if you can't?

### Per-user utilisation ###

What happens when you have large numbers of concurrent users? If each connection requires large amounts of resources, it may work fine on a LAN (w/ millisecond range execution times) but crash and burn on the tubes (w/ hundreds of millisecond execution times). 

How you cope with this? Risk management: rather than doing the work for a worst case that *may* happen, perhaps do a little work upfront so that you *can* fix if it does happen.

How much of your app would you need to modify for it to work on an iPhone? All of it?: you fail.

### Networking ###

You LAN is not the internet and apps do not perform the same way! Applications behave differently on a WAN.

Learning how the network behaves is good and useful.

TCP/UDP (e.g. DNS would fall over w/ TCP)

HTTP: caching content yourself, client caching, etc.

### HTTP ###

Learn about HTTP and user experience.

Caching, content negotiation, etc.

Stop thinking that you can pigeon-hole yourself and actually learn about everything you need to know, not just your little web world. The reverse is true to: systems people should know how their systems are being used.

### Cloud ###

The systems version: lots of machines coming up and down as you want.

The Google and Yahoo! version: write your app this way and we'll take care of the running and moving and data tracking and such for you.

Databases like bigtable instead of relational databases. Content delivery through CDNs, etc. Seperated "how do you use the data" from "how do you move the data around". Using map/reduce, etc. makes it possible and easy to scale from 1 to 1,000,000 processors but is very different w.r.t. "normal" programming techniques (unless your a functional programmer).

Amazon S3 "cloud": virtual *nix machines under Xen. Use "storage" and "database" to distribute content and info.

Google Apps: Use their Python/Javascript frameworks; map/reduce, bigtable, etc. and Google do the "cloud" bits for you.

## Suggestions ##

Look at decoupling your app into bits and pieces to be tied together. Seperate data management, processing, page fragment generation, page generation, caching, etc.

Learning about HTTP, caching, the network, etc. even superficially. Learning to identify the bottlenecks.

Break the app up and you can start caching between the layers.

## Example ##

Load balancer in front of app servers. Use the reverse proxy with a crap load of RAM as a buffer: the app servers can free the request resources quickly and let the proxy handle the slowness.

Add a caching layer between the reverse proxy/balancer and web apps and assemble fragments from the apps at the front end. This only works for certain apps (portals, etc), typically few writes with huge numbers of reads, shared content between users (widgets for weather, etc.) Can replicate in multiple places.
