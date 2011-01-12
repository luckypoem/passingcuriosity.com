---
layout  : main
title   : LCA2011 Archives
section : Past
feed    : /conferences/lca2011/atom.xml
---

LCA 2011 Archives
=================

This is an archive of posts about [linux.conf.au 2011][lca2011].

[lca2011]: http://lca2011.linux.org.au/

{% for post in site.categories.lca2011 %}
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