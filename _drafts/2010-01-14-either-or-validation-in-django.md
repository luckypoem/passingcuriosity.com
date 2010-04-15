---
layout    : post
title     : "Either-or" validation in Django
tags      : [python, code, django, forms, validation]
location  : Perth, Western Australia
excerpt   : |
  A quite note on using Django form validation to ensure that the user
  supplies at least one of a set of fields (at least one of home, work or
  mobile telephone numbers, for example).
---

Django provides a relatively interesting library for implementing HTML forms,
but there are reasonably simple things that I'd like to do which seem to be
hard to do, or dirty. One of these things is "either-or" validation of form
fields. By this, I mean requiring that the user supply either this value or
that value (or possibly both).

Here is my use case: I'm creating a contact form that users can use to request
information form the site owners. They are required to provide a name, an
e-mail address, a message, and either a mobile phone number or a home phone
number or both. Optionally they may also select the location their message
pertains to. This seems relatively straight forward, but there are a few
caveats: the most important is that it needs to fit within a set of templates
which mark each field of a bound form with a tick (if it's valid) or a cross
(if it's invalid).

The obvious place for this is the `clean` method on the form class -- I'm
validating the set of values supplied to the form, not that a particular value
is valid in a particular field. Implemented thus, the error message ends up
being for the "form", rather than either field. Alas, this winds up marking
both fields as valid in spite of the fact that at least one of them needs to
be modified before the form will validate.

My current solution looks like this:

<code lang="python">
def clean(self):
   cleaned_data = self.cleaned_data
   home = cleaned_data.get('home')
   mobile = cleaned_data.get('mob')
   if not ( home or mobile ) :
       self._errors['home'] = ErrorList([''])
       self._errors['mob'] = ErrorList([''])
       m = "Please supply your home or mobile phone number"
       raise forms.ValidationError(m)
   return cleaned_data
</code>