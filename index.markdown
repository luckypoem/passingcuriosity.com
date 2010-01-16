---
layout  : main
title   : Home
section : Home
feed    : /atom.xml
---

Welcome
=======

I registered the domain *Passing Curiosity* with the intention that it
become a productive outlet for my rather short attention span. Rather
than waste man-years clicking "Open Link in New Tab" on
[Wikipedia][wp], I would make that time productive by summarising what
I read. Dead time, no more! 

[wp]: http://en.wikipedia.org/wiki/ "Wikipedia, the free encyclopedia"

Alas, I got distracted. Nearly three years have passed and *Passing
Curiosity* is still just a neglected blog.

Blog
====

This site currently plays host to my blog. Over the years I've
maintained a few and almost everything I posted to any of them can be
found here. 

You might like to view my [Linux.conf.au](/lca/), [Drupal](/drupal/), or
[SPIP](/spip) posts.

The most recent posts are:

{% for post in site.posts limit:5 %}
<div class="section list">
  <h1>{{ post.date | date_to_string }}</h1>
  <p class="line">
    <a class="title" href="{{ post.url }}">{{ post.title }}</a>
  </p>
  <p class="excerpt">
	{% if post.excerpt %}
	  {{ post.excerpt }}
    {% else %}
      {{ post.content | html_truncate }}
    {% endif %}
  </p>
</div>
{% endfor %}

The rest, you can find in [the archives](/archives/).
