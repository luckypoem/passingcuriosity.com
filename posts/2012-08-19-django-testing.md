---
title: PyconAU 2012: Django Testing
tags: PyconAU 2012, Python, django, testing
location: Hobart, Tasmania
excerpt: Notes from a talk about testing Django solutions at Pycon AU 2012.
---

Testing is good but can be tedious.

You'll be testing in the browser anyway; if you can get into good habits of
automating some of these, you'll same time and effort. Cheat to make testing
quicker and easier. Laziness #ftw!

[django-positions](https://github.com/jpwatts/django-positions)

    ./manage.py validate

    ./manage.py test

    ./manage.py startapp mustsee
    
Add a model and then add a test.

