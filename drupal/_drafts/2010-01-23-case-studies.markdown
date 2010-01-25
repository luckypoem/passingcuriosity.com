---
layout   : post
title    : Briefs and Case Studies
tags     : [drupalsouth, case study, drupal]
location : Wellington, New Zealand
excerpt  : |
  After lunch I listened to a series of case studies of Drupal projects that
  three attendees have undertaken.
---

Claudine Chionh: Using Drupal for collaborative historical research
===================================================================

Claudine Chionh spoke about [Using Drupal for collaborative historical
research][talk].

[talk]: http://wellington2010.drupalsouth.net.nz/session/using-drupal-for-collaborative-historical-research

Using Drupal to publish information about the convicts transported to
Australia (particularly Melbourne and Tasmania). Based on convict conduct
records that are manually being transcribed (transcribing copperplate
handwriting with wacky 18-19th century spelling is difficult to automate).

Details of about around 40,000 convicts (~1M rows). Accepting submissions from
members of the public.

Challenges
----------

Two technical staff on the project (project based government funding)

* 'Amateur' developer
* Isolation (from the Drupal community, wider community, etc.)

Benefits
--------

Values: free, open, etc.

Low cost: absolutely essential given that this is an academic project with
limited funding that needs to be stretched as far as possible. Paying for
proprietary software is pretty much out of the realm o

Framework: modular, define our own content types (very much publishing
database on the web), define user roles. It's pretty hard to imagine life
without CCK and Views now. Roles include super-powered developers; researchers
who can access the data, but can't delete; will be introducing volunteers for
transcription, where workflow will help. 

Also allow public to submit details from their own research to be confirmed
and linked against existing data.

Themeing
--------

Been using fusion out of the box. Need to hire a designer. 

Accounts
--------

Why don't users follow instructions?

Please give me a password.

Confusion with simplenews subscription.

Privatemsg
----------

Stores messages in Drupal database

Which part of "do not reply" is confusing you?

Other staff
-----------

Not using the site

Not giving feedback


Should use
----------

Table wizard and migrate?


Dave Sparks : I am not a developer
==================================

Dave Sparks speaking about Drupal from a client-side/project management
perspective. Three of four things that they do every day with Drupal...

Only really one question he gets asked: "how much" (hopefully also "how
soon?"). Pretty complicated question to answer: could take a whole day, lots
of assumptions. Lots of clients are refugees (from Joomla!, ASP, etc.)

How we talk drupal with clients
-------------------------------

Make sure you're speaking the same language: don't use language and jargon for
developers when speaking to non-technical clients.

Drupal should seem easy, but the specific language can be scary. Using the
client's language to help get them on board and educate them later. Work with
them so that they can learn the language.

What would Drupal do
--------------------

You need to know what's going on - SSO, Twitter integration, what every - and
what's possible. And you need to know what the client wants.

Getting the client on the same page as the audience, the developer/s, the
designer/s, etc. A good starting place is what would Drupal do? This is a
starting place; then customise.

Drupal is like a dolphin: old enough to have had the corners nocked off;
streamlined and cuts through the water. This normality helps to explain things
to clients: this is the way hundreds of thousands of people do it; why,
exactly, do you want to do it differently?

Maybe they want an "opinion" section (because "blogs" are dirty). Take the
Drupal starting point and customise as required. [National Business
Review](http://www.nbr.co.nz/). 

Lower cost and lower risk on these bits gives you more of each for the cool
stuff.

How routine beats process
-------------------------

A routine is something you do over and over until it's second nature. A
process is something you do start to finish (and you can break). Most people
(clients, event) are creatures of habit.

Have a bedtime routine, not a process.

Design, build, theme, go live. Or build, design, theme, go live. Or whatever
it takes.

1. Talks Drupal with clients in their language
2. Ask them "What would Drupal do?"
3. Get them into a routine

Aaron Fulton: vetspace.co.nz
============================

New Zealand Veterinary Association: two organisations merged. They both had a
lot of different systems and spreadsheets and such. They decided to build a
single CRM system and [website](http://www.vetspace.org.nz/).

iMIS

Merging the two along with a few SIGs and such, they put out an RFP and got
back a few "no thanks'" and a few "you'll need Drupal". Needed to integrate
with the wacky CRM.

Something of a challenge dealing with three other organisations (CRM,
Catalyst, and a partner in Sydney wanting exactly the same integration).

Trying to sync everything from the back-office system to the web-site. 

Handles their publishing stuff (NZ Vet. J., books), membership registration,
user details, etc.

Does differential pricing (user logs in, Drupal asks CRM for quote, makes them
pay, notifies CRM)

iMIS talks SOAP to Drupal which talks MNET to Moodle. The iMIS <-> Drupal
connection is for quoting and purchasing. Drupal <-> Moodle gives access
immediately.