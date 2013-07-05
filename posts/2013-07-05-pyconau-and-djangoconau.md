---
layout: post
title: DjangoConAU 2013
tags: python, django, web, conference
location: Hobart, Tasmania
excerpt: 
  I'm attending DjangoCon Australia 2013 and, over the weekend, PyCon Australia
  2013 in Hobart, Tasmania.
---

I'm attending [DjangoConAU][1] 2013 (I believe this is the inaugural DjangoCon
Australia) today and PyCon Australia tomorrow. If last year is any guide, it's
going to be a pretty awesome weekend! I'll try to update this post over the
course of the day. Not real live blogging, more delayed telecast blogging.

[1]: http://www.djangocon.com.au/

Also: these are notes I'm typing during the sessions. They are probably errors
and such. I'll come back and tidy them up later. Maybe.

[DjangoCon Australia 2013 t-shirt](http://teespring.com/dcau2013)

# Alex Gaynor on the Divided Web and the Role of Frameworks

[Alex Gaynor on the Divided Web and the Role of Frameworks][2]. First person to
have spoken at DjangoCons on three continents (for a hour or two).

[2]: http://2013.pycon-au.org/programme/miniconfs/djangocon#gaynor

History of the web: the big bang, ENIAC, Apple II, T.B.L. and Mosaic.

Email and FTP are more applications, but the web technologies (HTML, HTTP,
etc.) are, effectively, platforms: they don't have any specific thing you do
with them, you do what you like.

1. Static content. In vim or something.

2. Dynamic content.

3. DHTML - nothing good came of this.

4. Microsoft invented AJAX (with ActiveX controls).

5. "Web 2.0" is what we think "web applicaiton" means these days.

Frameworks are being release (RoR & Django; see the Snakes and Rubies). These
made lots of stuff that was a pain ("database driven applications") more
convenient.

Most people land on one side or the other, but current practice seems to have
landed on "both": backend and frontend are both getting more and more complex.

Technologies are living longer: some of this stuff is likely to be the COBOL of
the future.

All these new tools and technologies don't create new capabilities, they make
existing capabilities more convenient to manage and to use. Rails and Django to
let you do something new.

Django was designed to allow small groups of people to build complex "web
applications" quickly. It still solves the same problem in 2013 as it did in
2005.

In 2009 there were a few more things that were though required: monitoring,
message quues, APIs, workers, search indexing. Django has nothing to say about
any of these (though many of them are addressed by third-party apps and
external packages).

In 2013 you need deployment, configuration management, to think about SOA,
real-time stuff (Websockets, etc.) and the crazy, crazy world of front-end
Javascript.

We're building more and more platforms for specific use cases.

In spite of all these new frameworks and tools addressing parts of a puzzle,
nothing has really encroached on Django and Rails yet. Either Django will start
addressing some of these cases or it'll be made obsolete by something better.

> Everything is getting more complex and bigger.

Deployment has always sucked but Alex has reason to believe that there is a
bright future.

- Applications in [Docker][3] containers.

[3]: http://www.docker.io/

- Servers configured with Chef & [Heat][4] (orchestration as a service; part of
  OpenStack?) which run your containers.

[4]: https://wiki.openstack.org/wiki/Heat

Most full-service cloud platforms include some sort of orchestration tool
(Heat, CloudFormation).


The "divide" of the title comes in a number of axes:

- small and big teams
- contractors and in-house
- "sites" and "apps"

The increase in complexity seems to be favouring one side of each divide. "The
ink is never dry".

## Q&A

Where does Django fit in a world which almost forces us to work in (or, at
least, interoperate with JS)?

> DHH's comment on Rails' JS helpers: "Yes, JS is horrible." Google is
> trying something interesting with Dart. It's probably not particularly
> feasible to implement Python on top of JS (like the Dart compat).
>
> "Best viewed in Chrome" must never come back.

# Jacob Kaplan-Moss on Porting Django apps to Python 3

> Hey y'all

Django 1.5 supports Python 3, in Django 1.6 it's considered stable. So let's
all use it.

First question is: whether we should use Python 3? The answer is yes. Python 3
is Python with "30% fewer warts". Biggest improvement is that Unicode really
works.

Second question is: can we use Python 3? This is essentially a question of your
application's dependencies and whether they've been ported yet.

Problems:

- First big problem is choice ot DB. If you use Postgres you're fine. SQLite
  works. MySQL has a connector (but there are licensing concerns, so the
  foundation can't recommend it). You should be using Postgres.

- Second big problem is your server/deployment software: modwsgi, uWSGI and
  synchronous gunicorn are all fine. gunicorn async is problematic (due to
  gevent). You may need to switch deployment and operation strategy.

- South, Celery, Raven (sentry), django-extensions, all work. But not
  django-compressor, django-tagging (last update 2009), django-social-auth,
  django-debug-toolbar, Haystack. But there are suitable alternatives to these
  (django-pipeline, django-auth, [django-taggit][]).
  
[django-taggit]: https://pypi.python.org/pypi/django-taggit

  Every time working with Python 3 Jacob has had to play this game evaluating
  apps and libraries for Python 3 support.

Third question is: should I use Python 3? This can be complicated, with the
additional costs of learning the new stuff, re-/evaluating apps and libraries
for Python 3 support. Perhaps the best advice is to use Python 3 if you can and
Python 2 if you must; Python 3 will be improved, get faster, etc. There's no
future for Python 2 (possibly decades, but still; RedHat have committed to
supporting it for 2030 or something).

## How do I use Python 3?

If you can, support only Python 3. It's not too hard to add support for Python
2 later if it becomes necessary during the development process.

Python 3 introduced a tool called `2to3` which converts Python 2 code for
Python 3 (by doing AST transformations and generating a patch). The Python 3
code being generated, makes it very hard to fix bugs and makes community
contribution very hard.

The "single source" approach is much better: write Python 3 code and include
shims to paper over the deficits when run under Python 2. If you have to
support Python 2 you should be using this technique.

3. Supporting both Python 2 and Python 3 *requires* automated testing. You
can't hope to maintain it without continuous integration.

4. Fix all the unicode handling issues that your test suite identifies. There
will be lots.

5. Iterate on test failures.

## Case Study: python.org

Decided to support only Python 3.3+ (if possible). Left single-source open if
it became necessary later.

Dependencies:

- Light CMS requirements. None of the existing CMS packages supported Python 3
  yet, decided to build it as the requirements were so simple.

- Quite complex and specific user, permissions and authentication requirements,
  so none of the apps would have been applicable anyway.

- Heavy integration with social media services. None of the social login tools
  (which they evaluated) had been ported at the time, so they moved on to other
  features and bugged the maintainers to port (and it worked).

- Moderate traffic requirements with extreme spikes related to releases, etc.

- Testing: django-discover-runner works fine on Python 3 (and is, essentially,
  included in Django 1.6).

- The hardest part of the process was "retraining our unicode three muscles to
  do things the Python 3 way".

	> The biggest thing you can do is eliminate the word "string" from your
	> vocabulary. Bytes are just bytes, text is text.

   `django.utils.encoding` does this.
	
It worked and it'll be launching in about a month (hopefully).

They estimate the project cost about 20% more to develop, mostly in terms of
increased development time. In large part, most of this time is probably just
changing maintenance costs into upfront costs. And the number is probably
smaller now.

## Case study: django-sitetree

Django application for managing a hierarchical navigation tree. Ported by Jeff
Triplett in [a single commit][c].

[c]: https://github.com/idlesign/django-sitetree/commit/c7475

Shared source approach with: Python 2.6+, Python 3.3+; Django 1.4+. This is a
reasonable set of minimum requirements.

There aren't any dependencies. If your app has dependencies, you may need to
port them too!

Using [Tox][tox] to run test suite in multiple environments. You'll pick up a
bunch of syntax issues with the changes in Python 3.

[tox]: http://tox.readthedocs.org

Django adds the `@python_2_unicode_compat` decorator to change `__unicode__`
into `__str__` if running on Python 2.

[Six](http://pythonhosted.org/six/) (included in `django.utils.six`) helps to
paper over some of the differences (metaclasses, type names of byte and text
types, etc.)

There's a [guide for porting to Python 3][port] with detailed documentation.

[port]: http://django.me/py3

Python 3 is ready, the WSGI containers are ported, the databases are ported,
the frameworks are ported. Now it's up to the community to port the libraries
and applications.

## Q&A

Is `from future import unicode` a good idea?

> Unicode literals aren't a thing in Python 3, but using stuff from future is probably a good idea. 

# Greg Turner on using FeinCMS

Greg is the filling in a core-contributor sandwich.

The web and web-content are becoming more complex: there are more technologies,
more devices, users expect richer experiences. See [NYT Snowfall][sf] for an
example. Teams are getting smaller and smaller (economics, etc.) We need to
build content which is future-proof, cross platform, clean and semantic.

[sf]: http://www.nytimes.com/projects/2012/snow-fall/

These are the problems that [FeinCMS][] attempts to solve. A document (page)
combines a services of lumps of content (content types, not the same thing as
Django content types).

[FeinCMS]: http://www.feincms.org/

See the [MCA site][].

[MCA]: http://mca.com.au/

FeinCMS provides a model and admin to use as a base in your own app. This
allows site admins to combine and embed different types of content in their
documents (instances of your FeinCMS models).

Each model has specific set of content types which are supported. This is kind
of ugly, [FeinCMStools][] makes it nicer. He's made a [demonstration][demo]
(see the tags).

1. Define the regions in your content type. https://github.com/ixc/feincmstools-demo/blob/master/djangosite/meetups/models.py#L17

2. Define content types which can go in your regions. https://github.com/ixc/feincmstools-demo/blob/master/djangosite/meetups/models.py#L23

3. There are lots of tables, so make sure you're careful with migrations, etc.

[demo]: https://github.com/ixc/feincmstools-demo

[FeinCMStools]: http://github.com/ixc/glamkit-feincmstools

Content types don't have to be content. Example of a content type, which offers
the site admin a choice of layouts which have been designed and built ready for
them to use.

## Q&A

How does FeinCMS handle structured content?

> They are just normal Django models, so they can be as structured and semantic as you like.

FeinCMS uses Django admin which some users dislike. Any tips on making it nicer?

> Not really. But they use `django-admintools`.  Would like to see a
> more heterogenous approach to admin, which many other CMS support and
> which better maps to user expectations.


# Russell Keith-Magee on Secrets of the Testing Masters

CTO of TradesCloud. Hiring soon if you want to move to Perth.

Testing is good and we should all be doing it. As we all know. First
contribution to django was adding app testing. It has lots of support for
testing contrib, but not everything. Introducing two testing tools which are
helpful and good and such.

## Problem: You need test data

Django's testing framework supports fixtures (declared in test case class).
Fixtures are easy to create, but hard to read, hard to update and include no
documentation. Also include a lot of rubbish which isn't relevant to the test
(1 line out of 18 when testing "admin can X"). You need to *know* that user 23
is the "staff user with no existing content".

Solution is `factory_boy`: an EDSL for creating test objects in your tests,
programmatically.

You create factory classes for your models. Provide place holder values, use
helpers to generate values (sequences for unique email addresses, lazy values
which are calculated late in the process).

Subfactories all you to create child objects. E.g. BlogPost factory has User
sub-factory for the post author. Can still be overridden on specific cases when
tests require. This overriding can traverse joins just like Django model stuff:
`PostF(author__firstname='thomas')`

Lets you access and override various bits of instance data and the creation
process.

Factory-boy also supports: SQLAlchemy and Mogo.

There's also a django-factory-boy package which includes pre-defined factories
for Django modules.

## Problem: You're dependant on an external service

Any external services that you use -- payment processing, social networks, etc.
-- will affect your ability to test. You might also have trouble testing your
failure cases.

Any internal services might be slow, unreliable or difficult to configure.
Things like deliberately slow password hashing, database failure, etc.

You can just ignore this and not test those bits.

You can use `mock` (Python 3.3 stdlib `unittest.mock`, installable on Python
2.7+); essentially organised monkeypatching.

- Mock object which provides pre-defined return values.

- `@patch` decorators to inject mock objects into an existing API.

Mock instances track how they are used, allowing you to assert various
properties about the way your code is used.

    obj = SomeObject()
    obj.method = Mock(return_value=3)
	obj.method.assert_...

`@patch` allows you to use a function (the decorated function) to replace an
existing function.

There are other similar packages, but Russell likes sticking with the standard
library unless really required.

PS: There will be an announcement during Russell's PyCon talk.

#  Simon Meers on Django Unstrained

Simon (DrMeers online) is part of the Django core team, having discovered
Django in 2008. Lots of clients with deadlines.

Django (like all real Open Source projects) is *our* framework, it's up to us
to improve it. We probably want to avoid adding more functionality to Django
core, but helping it to evolve to be an [even more] flexible platform for
third-party contribution. Rich third-party eco-system.

- [django-allauth](https://github.com/pennersr/django-allauth)

- [django-braces](https://github.com/brack3t/django-braces)

- `django-generic` containing snippets and patterns which you use over and over
  again. Simon's snippets package is on [his BitBucket account][sbb].
  
[sbb]: http://bitbucket.org/DrMeers

- [django-import-export](https://pypi.python.org/pypi/django-import-export) for
  CSV, etc.

- Nested inline forms has been discussed in tickets.

- Floppy forms and Crispy forms improve 

- Pass through manager just passes things through to the underlying queryset?
  This is something I could have used before.

[Simon's Github account](http://github.com/DrMeers/) will contain the slides at
some point.

# Tom Eastman on the coolest parts of backend development with Django

Catalyst IT (in Wellington) have a growing Django team. Come talk to Tom if you
might be interested in moving.

Large, reasonably high profile project for the Department of Education. 

- AngularJS, D3, Compass/SASS for frontend.
- Django, gunicorn, tastypie, celery and south.

Working in a large team means that back end developers can avoid front-end
stuff like browser quirks, etc. The job then has only three parts:

- Make it *correct*
- Make it *fast*
- Make it *secure*

## Correct

> Code without tests is broken by design.

And

>The converse of test-driven development is faith-based development.

Your tests should be run regularly. Using a tool based on things like `inotify`
allow you to see test results as you work.

*You must see your tests fail before they pass.* Without this, you can't tell
that your code makes the test pass. Either the code is wrong or the tests are
wrong.

*Testing errors is more important than testing the happy case.* It's unusual
for people to test error cases (only usually when the errors occur during
development). Write test cases which cover error cases.

Django gives you all the tools you need to test the things you need to test,
and do it properly.

Continous integration and rigours code review are two of the best inventions
ever. Tools like Jenkins and Gerrit make these reasonably easy to setup.

Took three tries to get integration testing to work:

1. Using the Selenium recorder. It generated hideous, unmaintainable code and
gave up.

2. PhantomJS is headless webkit controlable with JS. It shows promise but was
rather unstable.

3. Went back to Selenium having learned how to split tests from page
controllers (see [Effective Selenium testing][est]). This makes it easy to
maintain tests when pages change, etc.

[est]: http://hedleyproctor.com/2012/07/effective-selenium-testing/

## Fast

Varnish and CDNs are all fun, but can be difficult on sites that contain
non-public information, freshness requirements, etc. How do you keep your web
site fast without public caching?

Using etag and last-modified headers in Django. Use auto-updating timestamps in
models; with appropriate indexes in the database, it can be very fast to check
last-modified headers. Takes more DB queries to check freshness, but is almost
always a speedup; an example view takes 800ms to generate the full response vs
50ms to check modification.

1. Check authorisation.
2. If the etag matches, yay!
3. With no etag, serve from cache.
4. Generate (and cache) the page. (Invalidate cache on saves).

## Secure

If you, as a web developer, haven't read the OWASP Top 10 then you are a
liability to every site you work on.

Things that seem innocuous -- processing XML from clients -- are often unsafe.
Disable functionality that you don't need: XML, YAML, etc.

If your site requires logins then your site requires SSL. See Firesheep if you
haven't seen it.

Django forms are for validating import; not just generating HTML forms. Use
them for everything! Query strings, CSV records, etc. Even if you don't (yet)
have any rules to enforce, create a form so you'll have somewhere to put it.

Django can't protect you if you don't let it. If you bypass the ORM, then it's
**your** job to handle SQL injection. If you bypass the template language, then
it's **your** job to validate.

Annoy your pentester so they *really* want to find your bugs. Current project
has sent 18,000 emails about 500 errors.

## Q&A

Adding tests to a codebase without them?

> You need to be able to put your database into a known state for
> testing purposes. Doing smoke test (is it all 200 OK?) are quick and
> easy. Unit tests can be easy to start.

What are the most common issues found in code review?

> Silly mistakes. Often, the review comment is "why wasn't this
> tested?" Often it helps share knowledge about better ways, etc.
> throughout the whole team, to notice additional cases which need
> testing, etc.
>
> If nothing else, it helps to make sure that the whole team knows about
> the code base.

# Curtis Maloney on A state of REST

Curtis is responsible for:

- django-nap
- django-rated

Everyone who doesn't hangout on irc://freenode.net#django is missing out.

Django doesn't really have any REST frameworks; the API frameworks we have
are pretty useful and kinda REST-y, though.

- TastyPie

- Django REST Framework

- django-nap tries to make a faster, smaller TastyPie.

There are a bunch of features for an API frameworks. Let's look at a few of
them.

## Auth

Authentication -- identifying the user -- and authorisation -- deciding whether
the user can perform the operation.

TastyPie and DRF both include support for a bunch of authentication approaches.
NAP makes/allows you to do it yourself using existing tools.

See the "Fuck OAuth 2 video".

Both TastyPie and DRF include their own functionality; NAP allows you to
provide a callback.

## Data Formats

TastyPie and DRF both support many frameworks.

NAP supports a few, but only one at a time?

## Serialisation

## Shapes

TastyPie lets you define per-field visibility (list vs details)

NAP (and DRF?) you can specify it per-view.

## Pagination

TP: Custom class, offset and limit

DRF: django native pagination. page and size.

NAT: django native pagination. Page with size or offset with limit.

Pagination has security implications, unlimited page sizes can allow denial of
service.

## Rate limiting

Both TastyPie and DRF have their own rate limiting implementations.

NAT doesn't, because it's a separate concern (in django-rated).

## Filtering

Django ORM filtering is important, but a whitelist is important (don't let
people tranverse links).

## Versioning

TastyPie: ?

DRF: Viewset (collection of views for responding to HTTP verbs for a collection
of resources) with routing.

NAP: collect a bunch of Publishers into a version.

## Generic Views

Can be clumsy to reuse TastyPie resources in your own views.

DRF is built on the generic views approach. It's the first step in the tutorial.

Using HTTP responses which are also exceptions. So you can produce 

## Overview

TastyPie is a very quick way to expose a model as an API, but going further
means learning a lot about it's APIs and internals.

In compiling the talk, started to doubt continuing NAP at all because DRF is
pretty awesome.

# Core Developer Panel

Russell, Chris, JKM, Alex & Simon; moderated by Greg.

## What's the best and worst things about it?

Russell: The fact that it happens at all is pretty wonderful; but there's so
much more we could/should be doing.

Jacob: Watching people get into Python because of Django; the expectation was
that it'd see a little takeup from newspaper people and a few who already know
Python, seeing half a room say they learned the language because of Django is
amazing. The idea that some people consider themselves Django developers (and
not Python developers) is somewhat disheartening.

## Are their situations in which you don't use Django?

Alex: Doesn't use Django much at all in his current role.

Chris: Not much, mostly when required.

## Streamline vs bloat

Simon: Core should really, really be streamlined. But we need some more clarity
about the one true tagging app, menu app, etc.

Russell: Flask does the apps thing well, by having a registry of packages and
blesses specific implementations. Everyone should be able to know that pipeline
is better than django-compressor.

Jacob: It doesn't have to be the core team which does this; they'd much rather
support a community effort.

Alex: It's not going to happen (talked about it at three panels so far); also
risks stagnation, etc. (Audience member says bollocks, repectfully)

## Django 2.0

Jacob: there will never be a massive change destroying backward compatability
as long as I have anything to do with it; 2.0 will just be 1.9++

Chris: deprecation cycles, etc. are good and breaking stuff is bad.

## What would you add/remove from Django?

Russell: probably the stuff around apps/settings/startup. Settings have caused
as many problems as it's made. App labels (vs just module) are pretty awful.
But still being Django would be difficult.

Alex: the admin; there's been some reskinning but no real challenges to what
django admin should be.

Jacob: Danny Greenfeld is trying Django Admin 2.

## The Django Software Foundation

Core committers are all invited to be members, but not all choose to be.

Funding comes from a couple of places:

- Profits from DjangoCon US.

- Membership fees from corporate members.

It's been very difficult getting companies to join, in part because it's a
US-based NFP. It's also difficult to raise money without having something to
spend it on.

## Kickstarter campaigns, etc.

Alex: This is a good thing. Twisted have created a position to someone to
review patches, etc.

Jacob: The Django community navigates the fraught relationship between OSS and
money better than most. The community is pretty good at coming up with cash
where it's required to make things happen.

## What will the replacement for Django be?

Alex: wertzoig?

Jacob: Have you watched the metero screencast?

## What should people sprint on?

Russell: 1.6 is coming so people should sprint on triage if they can help;
Porting apps to Python 3; think and talk about the big issues.

Jacob: most of the low-hanging fruit have been picked and everything left is
pretty hard. Pick a specific bug that's addressing you, or work on a
third-party package.

# Dylan Jay on Pyramid, Django and Plone

There's a Djangocon tradition of asking people from other Python web frameworks
to speak so we can learn from them. This is that talk. Dylan is a core Plone
contributor and has never written a single line of code for Django; first web
app in 1995 with ISAPI.

Big explosion of web frameworks around 2004 of web frameworks, Rails, Django,
etc. These are all descended from the CGI lineage.

Seperate lineage of Zope then ZTK and Plone. Zope is *older* than almost
everything in the CGI lineage.

Third lineage of static site generates.

In 1996:

- Webservers serve files at paths.

- CGI = run a script

- OO was big

- CGI was shit, so dude wrote Zope based on objects with traversal and method
  invocation based on URL paths.

ZODB

ZTK:

- Turns out OO isn't really all that good; use adapters (`adaptor :: Interface
  i, j => i -> j`)

- Traversal turns into a multiadaptor of Contect, Request and method name to a
  browser view.

Plone:

- 300+ core contributors
- 400+ plugins (supporting current version)
- 1000+ commits/month
- Sprints, a foundation, etc.

Plone services like [ploud](https://ploud.com/) and
[pretagov](http://www.pretagov.com.au).

Plone is good at ticking the all boxes you see in government tenders (all by
itself).

The most important thing to consider when evaluating CMS platforms is roles:
reviewers, content editors, site administrators, integrators, frontend
developers, backend developers (in kind of increasing order of technical
ability).

Many of these roles will be present in a large content-oriented site. Being
able to separate and serve the needs of these different user groups.

Frameworks tend to have a straight-line effort/customisation trend, CMS tend to
have non-linear relationship. Once you've exceded some limit of customisation,
you're often better off choosing a framework rather than a CMS.

A framework allows you to start with a pretty blank slate whereas a CMS let's
you build-up from an already-function-filled starting point.

Pyramid is pretty much the opposite of pyramids:

- Not ancient
- Extensible and flexible (not unchanging for centuries)
- Small to big (not big to small)

