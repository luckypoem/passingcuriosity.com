---
layout: post
title: Providing default settings for Django applications
tags: programing, python, django, application, settings
categories: [programing]
location: Perth, Western Australia
excerpt: 
  There doesn't seem to be an official way for a Django application to provide
  default values for its "custom" settings - you just document them somewhere
  and hope that the users take note. Here is some proof of concept code to 
  automatically inject an application's defaults into Django's settings.
---

The problem is a simple one: you're writing a Django application that needs a
setting or two. You know what they'll be in the vast majority of cases but you
want to make them configurable, just in case. As you're a good developer you
live by the maxim: Don't Repeat Yourself so you'd like to define each of these
values and, for ease of documentation, all of them in one place. Alas, you're
out of luck: Django does not provide any support for applications to supply
their own default values for settings. Thankfully though, all it takes is a
few lines of code and your application can shoehorn its own default values
into the global settings system.

First, a proviso to what follows: I am almost certain that this is a bad idea
and that you should do it. At the very least, you should make sure that your
setting names don't clash (I like to prefix them with the app name).

The goal is simple: your app should contain a `settings` module which defines
the default values for your application's settings. These values should be
injected into Django's settings system so that `manage.py diffsettings` and
similar functionality all work as you'd expect.

The approach is just as simple: add some code to the top-level module of your
application that loops over the values in your `app.settings` module and
inject them into the `django.conf.global_settings` module and (because it's
already been initialised by the time apps are loaded) the
`django.conf.settings` object (being careful not to stop on actual configured
with your default values).

The code itself is pretty simple. From `app/__init__.py`:

{% highlight python %}
def inject_app_defaults(application):
	"""Inject an application's default settings"""
	try:
		__import__('%s.settings' % application)
		import sys
		
		# Import our defaults, project defaults, and project settings
		_app_settings = sys.modules['%s.settings' % application]
		_def_settings = sys.modules['django.conf.global_settings']
		_settings = sys.modules['django.conf'].settings

		# Add the values from the application.settings module
		for _k in dir(_app_settings):
			if _k.isupper():
				# Add the value to the default settings module
				setattr(_def_settings, _k, getattr(_app_settings, _k))
				
				# Add the value to the settings, if not already present
				if not hasattr(_settings, _k):
					setattr(_settings, _k, getattr(_app_settings, _k))
	except ImportError:
		# Silently skip failing settings modules
		pass

inject_app_defaults(__name__)
{% endhighlight %}

You can see the code in a proof of concept application in my
[django-application-settings][gh] project on GitHub.

[gh]: http://github.com/thsutton/django-application-settings/
