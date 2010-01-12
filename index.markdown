---
layout  : main
title   : Home
section : Home
---

Welcome
=======

I registered the domain *Passing Curiosity* with the intention that it
become a productive outlet for my rather short attention span. Rather
than waste man-years clicking "Open Link in New Tab" on
[Wikipedia][wp], I would make that time productive by summarising what
I read. Dead time, no more! 

[wp]: http://en.wikipedia.org/wiki/ "Wikipedia, the free encyclopedia"

Alas, I got distracted.

Blogs
=====

I've kept a number of blogs over the years. You can find almost
everything collected here. 
Recent posts include:

{% for post in site.posts limit:5 %}
<div class="section list">
  <h1>{{ post.date | date_to_string }}</h1>
  <p class="line">
    <a class="title" href="{{ post.url }}">{{ post.title }}</a>
  </p>
  <p class="excerpt">{{ post.excerpt }}</p>
</div>
{% endfor %}

And you can find a more comprehensive list in
[the archives](/archives/).
