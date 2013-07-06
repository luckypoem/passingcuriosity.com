---
layout: post
title: PyCon Australia 2013, Day One
tags: python, conference
location: Hobart, Tasmania
excerpt: 
  These are my notes from day one of PyCon Australia 2013 in Hobart, Tasmania.
---

I'm attending [PyCon Australia][1] 2013 in Hobart, Tasmania. If [DjangoCon
Australia yesterday][dca] and PyCon Australia 2012 are any guide it's going to
be a pretty awesome weekend! I'll try to update this post over the course of
the day. Not real live blogging, more delayed telecast blogging. At some po

[1]: http://2013.pycon-au.org/
[dca]: /2013/pyconau-and-djangoconau/

I'm typing these notes during the sessions, so there may be errors and
omissions. Any such problems are my fault and not that of the speakers.

[Today's programme](http://2013.pycon-au.org/programme/schedule/saturday) is
pretty much jam packed with interesting-looking talks. You'll be able to find
videos of all the talks on [pyvideo.org](http://pyvideo.org/) eventually.

# Chris opening the conference

This year received a record number of submissions, has more days (yay for
miniconfs), more delegates (310) from more countries (Australia, New Zealand,
the US, Singapore, China, Europe and Asia).

Sponsored by heaps of awesome organisations: Google Australia, ACS, Tasmanian
Department of Tourism, etc, TASICT peak body,

PSF and DSF, aptira, secret lab, ancor, csiro, new relic, herouk, redhar,
biarri, rackspace, github, freelancer.com, typewrite facrory infoxchange, nsw
rural doctors network, planet innovation, moore's cloud, asdeqlabs, ...

Linux Australia is the parent organisation of PyCon Australia and provide
critical support for organising and running conferences like PyCon Australia.

Google and the Python Software Foundation provided financial aid for the
diversity and outreach programme which, including professional tickets, reached
$10,000 this year.

# Alex Gaynor on Computer Science, Software Engineering, and the Scientific Method #

Rackspace have a data centre in Sydney now.

The PSF are the fundraising and legal arm of the Python community. They don't
develop Python, CPython, etc. but try to empower the community to do and keep
doing great things. There's something of a disconnect between the PSF and the
general community; they are shaking the membership up: sponsors, fellows (like
current membership, nominated), supporting. Goal to build a bigger and better
community. "CI for our community."

PyCon US 2014 is in Montreal, Canada.

##

Engineering, science and art are fields of eneavour which may provide useful ways
of solving problems and serve as a model for programming.

Software has bugs and computers are terrible. NASA had order or magnitude of
increase in cost to make good software.

Software is slow: we squander every hardware improvement.

Software is slow to deliver (or we're just awful at estimating how long it'll
take). Estimating a hike (Melbourne to Sydney): 4 miles an hour, 8 hours a day;
straight lines, terrain, blisters, etc.

Conclusion: we don't know how to build software and we don't know how to design
software.

> I type a little and sometimes software comes out.

> Sometimes it works and sometimes it doesn't.

## Other industries

**Engineering**: intersection between science, technology and society. They take
existing fundamental sciences and use them to build things in the real world.

They use real science and real things to design real systems. We don't do that
and we don't use the rigour they do, though our systems are often as critical
as bridges.

**Science**: understand the world by doing fundamental research using the
scientific method. We don't do hypotheses, statistics, etc.

**Art**: a profession which not unrelated to ours. We tend to care about things
that we can't quantify (code aesthetics, etc.).

Epistemology: how do we know that our programs work? Often just "run it and it
worked", "millions of users and none have complained".

The cool thing about software is that we can do anything. We can *isolate* them
and do what we want to, we can *compose* almost any piece of software with any
other, we can *observe* every aspect of them. How can we use these abilities to
better know what our programs are doing and build better software.

Things like security are really hard: you can't tell it's broken until someone
breaks it.

We should be [doing more] testing,

Benchmarking -- properly

Logging and metrics can let us monitor, detect, diagnose and resolve problems
with our software.

Using the scientific method -- TDD -- in everyday software development (Test
as hypothesis.)

Programming is a lot like other industries: we build things like engineers, we
measure things like scientists, we care about aesthetics like artists. But we
have advantages -- like complete observability -- that they often lack.

Computer science and programming aren't the same thing, though our education and
training often don't cover things you need to be a good programmer.

Should have:
- logging and metrics
- version control
- [AOSA book](http://www.aosabook.org/)

We need to have and understand and use methodologies of software engineering and
programming.

## Q&A

Russell mentioned the endofunctors explanation of git branches. Mechanical
engineering has a big book of formulae which are the result of thousands of
years of experience. Is the difference a matter of age or is there some
fundamental difference between software engineering and real engineering?

> NASA and other reliable software practitioners have been able to bring bug
> rates down, which serves as something of an example that it is possible to
> improve. But we can definitely make it better and easier.

Mark on estimating and prediction, can large construction project management
serve as evidence that our problems with prediction might be a human factor
rather than a subject-matter factor?

> We are far better at estimating small things than large things (possibly
> super-linearly better). Ways to build large systems from smaller components
> will, we hope, make these problems more soluable.

We're often trapped by our own hubris: this was easy, the rest is bound to be
just as easy; expectations set by meeting deadlines by chance and death marches
in the other cases could be a problem?

> There's a boatload of research showing that piling on the resources doesn't
> just work. We need a better understanding of the tradeoffs involved in
> different approaches (studies on TDD showing approximate costs and reduced
> defect rates). We need to do more of this and actually use them in practice.

If we do make software engineering more predictable, more reliable, more like
real engineering, will we reduce the aesthetic aspects which many of us love?

> There seems to be, in my experience, a connection between aesthetic qualities
> of code and it's engineering quality. Beautiful code is usually simpler,
> reliable.

Back to open source specifically, can more, better and more available tooling
like version control, continuous integration, automatic instrumentation, etc.
help broaden the use of such techniques?

> Yes, making things more accessible to everyone.

Adam: how do you document risks -- especially complex risks -- for estimation, etc.

> I have no idea about this and I'm terrible at it.

Engineering firm -- civil, mechanical, and some software teams too. Engineers
will estimate things they aren't themselves doing, but we tend not to do that.
Can we take similar approaches?

> Mythical Man Month: it's critical to the success of a software project that
> they have a good designer to guide projects (BDFL, etc.) Don't think that's
> wrong and seems to work OK in open source, but the job title "architect" in
> corporations seems to correlate with badness. Maybe they are just all coincidentally
> bad at software?

Psychological biases in estimating. Only 45% of people will meet their 99%
confidence estimates. Psychological studies suggest that the only way we can
improve estimates is weighting by past performance.

> Good software engineers never write "bomb Baghdad" function, they write "bomb
> X". Some of the experience stuff won't necessarily work, but it should
> certainly inform our practice.

# Nick Coghlan on Nobody Expects the Python Packaging Authority #

Most people probably wouldn't use words like "fine" and "wonderful" to describe
the state of packaging in Python. There are lots of things that are fundamentally
broken in the way we do and deal with packaging in the Python community.

A lot of the problems are just a legacy of being old. Our packaging system
almost pre-dates Google, Inc. The software world has learned a lot about
effectively packaging software in the mean time.

- distutils 15 years old
- setuptools and easy_install from 2004
- pip, virtualenv 2007-2009

We'd like newcomers to Python to have a clear, easy to understand story about
packaging with scope to expand later when required.

Any new packaging system should be:

- Fast
- Easy
- Reasonably secure
- Integrate and play well with others, including the distro packaging systems.

Most of the issues holding packaging back (preventing clear guidelines) are
people problems. Largely: who is able to say "yes" and bless any new packaging
recommendations. PEP is the way Guido says yes to things; packaging tends to
have been approved just to get the problem to go away. Nick's had a lot more
involvement in packaging since joining RedHat and has volunteered as the person
who can say "yes" on packaging changes and improvements.

Richard Jones has stepped up as yes-sayer w.r.t. the Python Package Index.

PEP process has historically been targeted at the standard library. This is a
fundamentally broken way to address packaging problems; a packaging tool in a
PEP targeting Python 3.4 isn't very useful because no-one will use it (because
it isn't released). Discussion is going on outside/beside PEP, focusing as it
does on existing tools.

Avoiding changes that require users to change what they are doing.

The distribute fork was a political issue which is now over. Use setuptools 0.8+
now.

pip vs easy_install `pip` was designed as a non-broken easy_install (e.g. it
lets you uninstall things) but left some important things out (binary eggs,
which is particularly import on Windows). New format (wheel?) to be supported
in pip 1.4+ 

The final problem is "who do you believe?" with a lot of conflicting advice and
vitriol from historical conflicts floating around the internet.

The answer is: you should believe the Python Packaging Authority. Umbrella brand
or organisation to host all ongoing packaging work, waiting for releases before
Python packaging guide (which will go into "distributing software" guidelines on
python.org). Newcomers to Python will get clear directions from "Python" about
packaging.

## Goal 2: make it easier to get starter

Adding (parts of) `pip` to the standard library -- there's a PEP -- so that the
Python environment can bootstrap pip into your install.

But these changes to Python 3.4 don't help people now. Will probably add a guide
to PyPI so that everyone learns about the correct tools from the offical adivce.

## Goal 3

Fast, reliable, relatively secure. PyPI is quite complex and it's hard to run a
mirror; most tools don't support using mirrors (or don't make it hard).

The archive system (links to pages which it scrapes for things which look like
releases; having to download a package to see what it depends on) is kind of
crazy.

Using a geographically distributed CDN (donated by Fastly) makes things much
faster.

PEP438 is trying to remove the need to scan external link during an
installation. All new projects have link scanning turned off by default. Turned
off link scanning for existing packages which don't need it and allowing owners
to turn it off on existing packages. Some installs that used to take 20-30
minutes are now down to 2-3 minutes. Turning it off completely will break some
projects, but they are being very careful.

Another factor in the speed of installations is binary distribution, which
pip 1.4+ will support with the new format.

Metadata 2.0 format in PyPI and other tools will make things nicer. PEP 426 and
PEP 440.

If you can't afford to have the PyPI go down, you need to run your own mirror or
caching proxy. There is, and will be, no SLA for PyPI.

## Security

All this stuff used to happen over HTTP, letting people man in the middle, etc.
The Rubygems compromise suggests that we need to take this stuff more seriously;
assuming that PyPI and it's traffic is fine is not viable.

PyPI has a  certificate. Eventually all of python.org will require HTTPS.
Eventually all clients will verify HTTPS certificates.

Trusting mirrors is slightly problematic and they probably aren't the best
answer any more.

Using SSL places a lot of trust in the integrity of the PyPI systems. If you can
afford it, you should use your own index and audit everything. Trying to improve
the trust model, but this is a really hard problem (the Linux distros have done
it better than most, but it's still not done).

## Goal 4: Interoperability

Language developers think cross-platform tools are awesome because they can give
the same instructions to all users.

Integrators think they suck: new language, new tools, new security audits, more
work and cost.

PyPI wants (needs) to support both. Metadata 2.0 will include a lot more
information into the index metadata allowing platform packages to be built more
reliably. Will be able to include platform-specific metadata too. See metadata
standard in PEP 426 and PEP 440 (for tooling?)

## Q&A

Russell: There have been lots of attempts made to speed up the installation
process. One big speed change that doesn't seem to be there is local caching.

> pip 1.4+ will be able to use and maintain a local cache (it depends on the new
> format).

Tim: Debian have been doing signed packages for a long time. When they got
compromised they could show integrity. Are you doing something like that?

> There are interesting problems with key management in doing package signing.
> The PyPI server doesn't get audited and making beginners learn GPG key
> management is pretty much a non-starter.
>
> Getting to a point where people can trust PyPI to sign on their behalf will
> let beginners begin and more advanced people can manage their own keys and
> signing. The goal is end-to-end trust from the developer to the user.
>
> There's a bunch of research that we need to do before we can make decisions on
> these topics.

Lots of people love virtualenv for Python 2, pyvenv for Python 3. What do?

> You'll be able to keep using on virtualenv on Python 3; pyvenv is just a basic
> level of functionality out of the box.

Jacob: Thank you for working on this, I've been complaining about packaging
since I've been using Python. OWASP Top Ten number 9 is outdate dependencies.
There's pretty much nothing Python provides to help address this.

> We're looking at the update framework to help with this. It uses files with
> timestamps (15 minutes), metadata from the index server allowing you to check
> versions of packages (too expensive to download them all again as required
> currently).

# Jacon Kaplan-Moss on Building secure web apps in Python

Jacob is the co-BDFL for Django, currently Director of Security at Heroku.


The web is really scaring. The most basic mistakes in security engineering can
have catastrophic consequences.


Addressing the [OWASP Top 10][owasp10]. OWASP is the Open Web Application
Security Project, they publish a range of tools and documentation to help to
improve the security of web applications. Their Top 10 project lists important
and common security issues based on a survey.

[owasp10]: https://www.owasp.org/index.php/Top_10_2013

This talk will explain -- in broad strokes -- what each of the problems in the
Top 10 is, and how you can address them in each of three Python web frameworks:

- [Pyramid](http://docs.pylonsproject.org/projects/pyramid/en/latest/)
- [Flask](http://flask.pocoo.org/‎)
- [Django](http://www.djangoproject.com/)

## Injection

xkcd fans are probably familiar with [little Bobby Tables](http://xkcd.org/327/).

> Flask is perfect for slide drive development. Development drive by fitting
> your code on a presentation slide.

    GET /transactions?user=%27+or+1=1
    GET /transactions?user=%27%3B+DELETE+FROM+transactions%3B

Blackhats are doing things like downloading all your data and then deleting it
all. If you are

Stored injection -- injection via parameters which are under user control though
not actually in the request -- is a big deal.

### Mitigations

Please use an ORM. SQLAlchemy, Peewee, Django ORM, etc. We have an many good
ORMs in Python.

If you *must* write raw SQL, never treat your queries as a string.


Remember that injection means *injection*, not *SQL injection*. NoSQL databases
and all other systems which interpret a string can be vulnerable to injection.

Do not use interpolation or concatenation. Ever. You are not smarter than every
hacker ever. Be systematic.

## Vulnerabilities in sessions/auth

- Insecure credential storage
- Weak account management like password recovery.
- Poor session security (cookie theft, fixation, etc.).

Your entire site should be behind SSL. Everything.

- Flask: `flask-sslify`
- Django: `django-secure` (will be included into Django 1.7)
- Pyramid: couldn't find a solution.

Session security -- beyond mere transport security -- is a hard problem. You
should use your framework's session API (except Pyramid, follow the
documentation when it says to use Beaker instead).

Don't store anything useful in a cookie.

Be very careful with your secret keys.

You should probably consider the data in your sessions as user controlled and
potentially insecure.

Use a systematic approach, don't re-invent the wheel.

## XSS

Injection of markup, scripting, etc. into a page.

    GET /hello/jacob
	GET /hello/%3Cscript%3Ealert%28%27hacked%27%29%3C%2Fscript%3E

These attacks can be bad, but the solution is easy: use a template language
which escapes output data. Template languages which do not automatically
escape HTML are not suitable for use on the web.

- Flask: Jinja2
- Django: django.template
- Pyramid: Jinja2

Again the solution is: be systematic.

## Insecure direct object references

Pretending that this means "bad URLs". Using integer primary keys in URLs
invites people to change the URL and see what happens. Using slugs are still
guessable (I know, or suspect, that you're applying for a job on site X).
Using a hash, UUID, etc. is better.

Stop people from guessing URLs.

## Misconfiguration

There's no silver bullet, and not much that frameworks can do beyond providing
documentation.

- Flask and Django both have pretty good security checklists.
- django-secure includes a command that will check a bunch of settings.

And please turn off debug mode. Try searching for the debug mode string.

- Flask: app.debug = False
- Django settings.DEBUG = False
- Pyramid: debug_* = False

## Information disclosure

Fricking mailman sending you your password in plaintext (and storing your
password) every month.

You should be using bcrypt. If you are not a professional cryptographer, you are
almost certainly not competent to choose safe alternative password encryption
and storage.

## Insufficient access controls

Unguessable URLs often aren't unguessable. Django's password reset URLs assumed
it's hash was unguessable, but it wasn't.

You need to treat access control holistically, not piecemeal.

- Flask: flask-login
- Django: django.contrib.auth
- Pyramid: $pyramid_docs/latest/narr/security.html

## CRSF

Your system must have some way to verify that the requests being made to your
site are from users who intend to perform the action being requested.

Merely using POST requests is not enough; you need to introduce state and make
sure that incoming requests are legitimate requests with the correct details.

Django iterated 3 or 4 times trying to get the CSRF token correct.

- Flask: flask-csrf, Flask-WTF
- Django: built-in to Django's forms (make sure you use them).
- Pyramid: built-in but you need to enable it.

CSRF tokens use secret keys, make sure you don't leak it.

## Using components with known vulnerabilities

You can use tools like `pip list --outdated` to see what you're using and what's
available; but gives no information about security fixes, API stability and
compatability.

You need to have a good test suite and integrate against pinned *and* against
updated versions of your dependencies.

Follow the relevant mailing lists.

## Unvalidated redirects

In some circumstances you can force a system to, e.g, send a email to a user
and embed their own URL into links, etc.

Used in spear fishing, etc.

All three frameworks do poorly here.

## Score Card

Iffy on direct object refs

Poor on security misconfig

iffy on access control

poor on managing outdated dependencies

poor on unvalidated redirects.

## Q&A

Russell: Security is hard, let's go shopping. Plenty of security auditing
services but security is a process not a product.

> Leaving aside the scammers (scammers gotta scam), security auditing can be
> good and useful when you have an artefact to be evaluated (a piece of software
> or a bank vault). How many web applications are "done" and will be usefully
> auditable?
>
> Probably better to look at implementing security development life cycles
> instead in such situations.

With respect to insecure direct object reference, it's always nice to have
pretty useful URLs. Is login_required enough?

> Even with login_required, these URLs are still leaking information: how many
> applications you have, whether a particular person

Do things like same origin help protect against CSRF?

> No.
>
> Things like CSP (specify restrictions about code to be run in the context of
> your page).

How do you feel about taint mode? Should Python and/or Django look into adding a
taint mode?

> Think it wasn't much good in perl.

Not being able to tell about security updates to dependencies. Do you have any
thoughts about addressing these issues?

> Rubysec is trying to provide structured metadata about rubygems on security
> issues.
>
> Distutils metadata 2.0 has support for metadata extensions which should make
> this doable.

Pyramid seemed pretty weak in your presentation. Have/would you avoid it for
security issues?

> No, all the frameworks are pretty good. The issues are minor and can be
> addressed.
