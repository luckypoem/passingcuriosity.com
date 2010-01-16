---
layout  : main
title   : LCA Archives
section : Past
feed    : /lca/atom.xml
---

LCA Archives
============

This is an archive of posts about [linux.conf.au 2010][lca2010].

[lca2010]: http://www.lca2010.org.nz/

{% for post in site.categories.lca %}
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