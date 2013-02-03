---
layout: post
title: Writing view decorators for Django
tags: django, python, decorators, code
location: Perth, Western Australia
excerpt: |
  Using decorators to wrap and modify Django views is quick, easy, composable,
  and just about the most awesome thing I've seen in a while. It also takes a
  little bit of figuring out. Here's my explanation...
wordpressid: 1336
wordpressurl: http://passingcuriosity.com/?p=1336
---

Using decorators to wrap and modify Django views is quick, easy, composable,
and just about the most awesome thing I've seen in a while. It also takes a
little bit of figuring out. Here's my explanation...

More than just decoration
=========================

Using a decorator looks (in Python) like this:

{% highlight python %}
@a_decorator
def a_function(an_arg):
    return "Functionate: %s!" % (an_arg)
{% endhighlight %}

Where `a_decorator` is some function or other which takes an argument
(`a_function`, in this particular case) and returns a value. When Python loads
a module containing this code it creates a new function `a_function` as
normal, but then it calls `a_decorator` on it and binds the value it returns
to the name `a_function` rather than the original function created from the
definition. So how do we write these decorators? Just like a normal function!

{% highlight python %}
def a_decorator(the_func):
    """
    Make another a function more beautiful.
    """
    def _decorated(*args, **kwargs):
        return the_func(*args, **kwargs)
    return _decorated
{% endhighlight %}

But what about parameterised decorators? It's just a little more involved.
Recall that you use a decorator like this: `@the_decorator`. It turns out that
such decorator statements don't just *name* a decorator to be called, but can
also call a function to return a decorator to be called:

{% highlight python %}
def wrap_in_a(tag):
    """
    Wrap the result of a function in a `tag` HTML tag.
    """
    def _dec(func):
        def _new_func(*args, **kwargs):
            return "<%s>%s</%s>" % (tag, func(*args, **kwargs), tag)
        return _new_func
    return _dec

@wrap_in_a('div')
@login_required
def my_name(request):
    return request.user.first_name
{% endhighlight %}

The first decorator statement `@wrap_in_a('div')` calls `wrap_in_a('div')`
which returns a function (`_dec`). This function is then applied to the
following definition (`@login_required` applied to `my_name`). Simple!

It's probably a good idea to add a few more bits and pieces to the function
returned by a decorator (copying `__doc__` and `__dict__`, for instance), but
that's the core of it.

Using it in Django
==================

So this is all pretty cool, but how do we use it in Django? We'll here's a
`anonymous_required` decorator that you can use to redirect authenticated
users to their home page if they try to login again:

{% highlight python %}
def anonymous_required(function=None, home_url=None, redirect_field_name=None):
    """Check that the user is NOT logged in.

    This decorator ensures that the view functions it is called on can be 
    accessed only by anonymous users. When an authenticated user accesses
    such a protected view, they are redirected to the address specified in 
    the field named in `next_field` or, lacking such a value, the URL in 
    `home_url`, or the `USER_HOME_URL` setting.
    """
    if home_url is None:
        home_url = settings.USER_HOME_URL

    def _dec(view_func):
        def _view(request, *args, **kwargs):
            if request.user.is_authenticated():
                url = None
                if redirect_field_name and redirect_field_name in request.REQUEST:
                    url = request.REQUEST[redirect_field_name]
                if not url:
                    url = home_url
                if not url:
                    url = "/"
                return HttpResponseRedirect(url)
            else:
                return view_func(request, *args, **kwargs)

        _view.__name__ = view_func.__name__
        _view.__dict__ = view_func.__dict__
        _view.__doc__ = view_func.__doc__

        return _view

    if function is None:
        return _dec
    else:
        return _dec(function)
{% endhighlight %}

It's probably not very Django-ish, but you get the impression. Just use it
like Django's built-in `login_required` decorator:

{% highlight python %}
@anonynous_required
def a_view(request):
    return HttpResponse("We are anonymous! We are legion!")
{% endhighlight %}

Comments and suggestions welcome!

**Update:** Amended the example decorator above to work correctly as
`@anonymous_required`, `@anonymous_required(...)` or `foo =
anonymous_required(foo)`.
