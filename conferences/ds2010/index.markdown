---
layout  : main
title   : DrupalSouth 2010 Archives
section : Past
feed    : /conferences/ds2010/atom.xml
---

DrupalSouth 2010 Archives
=========================

This is an archive of posts about [DrupalSouth 2010][ds2010].

[ds2010]: http://wellington2010.drupalsouth.net.nz/

{% for post in site.categories.drupalsouth %}
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