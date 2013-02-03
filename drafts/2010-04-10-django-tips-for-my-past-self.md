---
title    : Django tips for my past self
tags     : [tips, django]
location : Perth, Western Australia
excerpt  :
  Some advice about developing with Django (or pretty much anything) that I
  wish I'd known before I started.
---

Here are some suggestions about developing with Django that I would give my
past self if I could.

1. Use [git][git] (or [Subversion][svn], or [Mercurial][hg], or
   [Darcs][darcs], or whatever other version control system you prefer) from
   the start. But make sure to do it "properly" (whatever that means).

   While you're at it: look in to using a deployment tool. [Capistrano][cap]
   is *written* in Ruby, but it can deploy Python applications as well as it
   can Rails.

2. Don't be tempted to use an app name twice. You and Python both know that
   `awesomeapp.auth` and `django.contrib.auth` are different, but they're both
   the `auth` application to Django. You'll wind up with table name clashes
   and other pain that you might have avoided.

3. Use a single platform for development and testing. Nothing is more annoying 
   than replacing code that works in Python 2.6 on your Mac, but not in Python
   2.5 on your Debian server.

4. There is little as painful as trying to modify your schema. Use
   [South][south] or another schema management library. Similarly, nothing
   makes a data import process more tedious than repeating it: learn how to
   import and export model data and do so. You should fear no 
   `django-admin.py reset`!

5. This should go without saying, but deploy only complete finished apps. If
   you deploy (and `syncdb`) half done apps, then you'll have enormous fun
   trying to update them later (again: use a schema management library like
   South).

6. Making your apps reusable is no harder than not bothering, and makes them
   easier as well.

7. Any forms, models, or views module with more than one form, model, œview
   and more than a screen of code can be split out into sub-modules. But do
   make sure that you set `Meta.app_label` on the models and import them all
   where Django expects to find them.

8. Conventions are cool and you should follow them. In particular, try to 
   write code like that found in `django.contrib`.

I'm sure there are many more things that I've missed, but I'm still just a
novice at Django (as with everything else I do). If you want to suggest away,
see the contact details below.

[git]: http://git-scm.com/
[svn]: http://subversion.apache.org/
[hg]: http://mercurial.selenic.com/
[darcs]: http://darcs.net/
[cap]: http://www.capify.org/
[south]: http://south.aeracode.org/