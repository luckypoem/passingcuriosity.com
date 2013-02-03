
Continuous deployment. The same thing as continuous delivery for our purposes
here.

> Being able to deploy every good version of your software.

More than technology: techniology for automation, people, environment.

Fail fast, win fast; competitive advantage; real-time control; pivoting, etc.

Have a single path to production; optimising for resilience. "If it hurts, do
it more often." Automate as much as possible.

- Use vagrant to develop on as close to live as possible.
- Develop, test, commit.
- Run a build: unit tests, static analysis, coverage. Very fast.
- Iff: functional tests, integration tests.
- Iff: deploy to staging, test migration, smoke and UI tests.
- Iff: you can push the deploy button.
- Then: goes to production.
- Users are happy.
- Measure, monitor, analyse.
- Learn from the information and feedback into the loop.

Environments
------------

Make all environments look the same, minimising differences minimises
surprises. Use `vagrant` to provision virtual boxes (configured in similar
ways to staging and live environments).

Having a repeatable, versioned configuration. Use Puppet, Chef, shell scripts,
whatever. Just use *something*.

"Snowflake" servers (every one precious and unique) are bad, "phoenix" servers
are the goal.

Use Puppet for provisions and OS and services; Fabric for scripted tasks.

Use virtualenv and pip. Make all your configuration as code.

Use South for schema and data migrations. Split your expansion and contraction
columns: only drop the old columns after everything is working correctly in
production.

Testing
-------

Using Django's testing framework, driven by Jenkins. There's a django-jenkins
plugin.

Use `factory_boy` to generate testing data.

Test separation: don't run slow or flaky tests every build.

Build
-----

One way to build and deploy; all developers fit into the same process. Make
"don't deploy broken code" easier; 

Deploy
------

- django-dbbackup
- pull()
- apply_puppet()
- django-extensions
- syncdb
- collectstatic

Use feature flags. [Gargoyle](https://github.com/disqus/gargoyle/) or
[Waffle](https://github.com/jsocol/django-waffle/) in Django.

Monitor
-------

- Errors go into [Sentry](http://sentry.readthedocs.org).
- Munin
- NewRelic
- [django-statsd](http://django-statsd.readthedocs.org/)

Rollback
--------

Having some way to recover from bad or failed builds.


