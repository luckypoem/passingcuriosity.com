--- 
wordpress_id: 2102
layout: post
title: Lachlan Hardy's session The Open Web
wordpress_url: http://passingcuriosity.com/?p=2102
excerpt : |
  My notes on Lachlan Hardy's presentation "The Open Web" at Edge of
  the Web, 2009.
---
There are my notes on Lachlan Hardy's ([@lachlanhardy](http://twitter.com/lachlanhardy)) session *The Open Web*.

# What is the open web?

It's a buzz phrase as much as a real phrase. Definitions and usage
vary (some of them are a bit vacuous).

"My" definition: it stems from a common philosophical approach. It's a
shared interest in the progress and development of the web.

Open Web group on Google Groups. Diverse interested and membership.
Have come up with four points that, they believe, are required for
something to be "open":

1. An open specification, providing the freedom to implement.
   Unencumbered by patents and licensing.
2. One (preferably more) open source reference implementations. 
3. Supported by more than one vendor.
4. Public involvement in the evolution of the specification.

Some of these four points are contentious.

The big concepts and the philosophical concepts are hard and, as such,
they're evolving. This isn't the definition he was using last year and
will likely change.


# Small pieces

## Web standards ##

* **HTML, CSS, JS, DOM, Atom.**

   All have a baseline of useful support across major browsers.

* **XMPP**

   IM protocol that isn't ICQ, MSN, AIM, etc. It's an open standard
   used in Jabber, GTalk, etc.

They've been approved by open standards organisations (W3C, IETF,
etc.) and aren't controlled by a single entity.

## Open specifications ##

Specifications openly available, implementation, but not standardised.

[**OpenID**](openid) is a good example. Anyone can read and implement
the specification.

Another good example is the [**microformats**](microformats) movement.
Anyone can read and adhere to the conventions for semantic markup of
events (hCalendar), business cards (hCard), etc. Anyone can implement
an applications to read and write data according to the specification.

[OAuth][oauth] is another. Secure API authentication from desktop and web
applications. Granting someone else (a 3rd party iPhone app) access to
"something" (your account) on a service or server (Twitter).

[WebFinger][webfinger] is finger over HTTP. Specified via
implementation. Google and Yahoo! both support it (opted in). Use it
to connect an email address to an OpenID.

Use OpenID to authenticate, OAuth to authorise, etc.

[Activity Streams][activitystreams] extends [Atom][atom] to describe the activity
performed by a user. 

[Portable Contacts][portablecontacts] provides a common access pattern and schema for
contacts. A single unified way to transfer contacts, etc. between
services (e.g. import "friends" from GMail when signing up for
Twitter). Build around OAuth and vCard (hCard). BUild on a schema from
Open Social.

This is the reason we love the web! No-one has built a single
monolithic entity. Instead, it's being built by unrelated people and
orgs as a modular jigsaw puzzle. They are *design* and *intended* to
be used together. They're not standards, but they are **open**.
OpenID, e.g., has a legal foundation, Microformats are sorting their
IP out (victims of their own success), OAuth is forming and covered by
the Web Standards Foundation (which is open to anyone else).

## Cold Hard Cash ##

The goal is cheapter and better. Lachlan is not an OSS fanatic (he
used to be a .Net developer). This isn't an abstract philosophical
ideal. These technologies are a better business choice as well.

More people have looked at and worked on open standards than the
proprietary options. And you didn't have to pay any of them. All of
the work and development and progres has been done (and paid for) by
these other people.


## Open Architectures ##

Much less clearly defined.

* **URL**s should be readable. We can look at them and understand them
  and modify them. Using verbs: http://omniti.com/does/degin/,
  http://omniti.com/helps/national-geographic/. Much more readable and
  usable (and great for SEO). But this requires planning and design.

  Our information architecture should be reflected in our 

* **API**s don't need to be enourmous collections of methods, etc.
   (Ben Schwarz, [Smoke](github.com/benschwarz/smoke)) Use REST, it's simple, straightforward and
   everyone understands it.

# Example Time #

**Twitter**

* Simplicity: What can you do with 140 chars? Heaps!
* Ubiquity: Simplicity make ubiquity easy.
* Open API: Every one can access it (just fill in the form and get a
   key). They've got an enourmous ecosystem as a result.
* Microformats: 

**Gnolia**

* Died and came back with a rebrand.
* Outsourcing identity: you don't create an account with them, you
  sign in with an external identity provider (G, Y!, OpenID,
  Wordpress, AOL, LJ, TypePad, etc.)
* Microformats: hAtom, hCard, etc.


**OpenID**

* Literally dozens of OpenID implements to run your own server (or
  consumer)

# Use the Open Web #

The web connects stuff -- people, places, services, information. It's
not a monolithic stack, but a series of components and communities
which interrlate in new, interesting and changing ways.

Some things we should be doing more of:

* Use microformats in your content and it'll be inherantly more
  accessible.
* Make URLs accessible and hackable.
* Put all that junk stuck in PDF and DOC and RTF into an HTML web-page
  (and microformat it).
* Offer *relevant* web feeds. An Atom feed is not just for blog posts
  and your latest news. They're for anything that changes.
  isitchristmastimeyet.com ("NO") has an Atom feed.
* Offer an API: there's no reason not to.
* Offer web services. Your site shouldn't just be a web-site. Should 
  integrate with other services ("I want a Japanese restaurant here,
  now").
* Offer and accept OpenIDs. Google, Yahoo!, etc. are providing
  OpenIDs, but most of them won't consume. Once your users have
  identitied, you know things about them and offer them more and
  better services based on that knowledge.
* Offer OAuth access to user's data. It's a bit of a pain to
  implement, but well worth doing. Who are the third-parties? Some of
  them will be in your community.
* Personalise feeds. It's not enough to offer a service to an
  audience. We should be aimed to provide services for *Joe Bloggs*,
  and *Jane Doe*, not "person in the English speaking world."

Some of these things are hard and require significant effort, but
there are many low hanging fruit, and every one who gives it a go and
provides feedback can help make things better and stronger and easier.

# Questions and Answers #

**What about privacy? Insurers, etc. are already collecting and mining
and abusing this type of data.**

The response from techies is invariably: that data is already
available. These "open web" technologies are making things slightly
more formal and make it easier, but it's always been possible and it
already happening. Just look at Facebook's cooperation with
third-party commercial interests.

**What about multiple identities? Many of us have seperate identities
for seperate interests and activies.**

Many OpenID implementers, for example, support multiple "profiles" and
allow you to choose between them as needed. 

[microformats]: http://microformats.org/
[oauth]: http://google.com/search?q=OAuth
[openid]: http://google.com/search?q=OpenID
[webfinger]: http://google.com/search?q=WebFinger
[portablecontacts]: http://google.com/search?q=Portable+Contacts
[atom]: http://google.com/search?q=atom
[activitystreams]: http://google.com/search?q=Activity+Streams
