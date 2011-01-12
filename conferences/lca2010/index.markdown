---
layout  : main
title   : LCA2010 Archives
section : Past
feed    : /conferences/lca2010/atom.xml
---

LCA 2010 Archives
=================

This is an archive of posts about [linux.conf.au 2010][lca2010].

[lca2010]: http://www.lca2010.org.nz/

{% for post in site.categories.lca2010 %}
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