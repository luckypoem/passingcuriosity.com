---
layout  : main
title   : Archives
section : Past
feed    : /atom.xml
---

Archives
========

This is the complete archive of posts at *[Passing Curiosity](/)* in
reverse chronological order.

Posts before September 2007 were originally posted on other -- now
defunct -- blogs. I'm gradually cleaning them up, but there may be
some broken links and the like.

{% for post in site.posts %}
<div class="section list">
  <h1>{{ post.date | date_to_string }}</h1>
  <p class="line">
    <a class="title" href="{{ post.url }}">{{ post.title }}</a>
  </p>
  <p class="excerpt">{% if post.excerpt %}
	{{ post.excerpt }}
  {% else %}
    {{ post.content | html_truncate }}
  {% endif %}</p>
</div>
{% endfor %}

