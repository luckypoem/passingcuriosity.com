---
layout  : main
title   : Barcamp Archives
section : Past
feed    : /barcamp/atom.xml
---

Barcamp Archives
================

This is an archive of posts about attending [Barcamp][bc] ([in Perth][bcp], so
far).

[bc]: http://barcamp.org/
[bcp]: http://barcampperth.org/

[lca2010]: http://www.lca2010.org.nz/

{% for post in site.categories.barcamp %}
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