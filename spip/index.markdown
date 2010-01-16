---
layout  : main
title   : SPIP Archives
section : Past
feed    : /spip/atom.xml
---

SPIP Archives
=============

This is an archive of posts about the [SPIP][spip] content management system.

[spip]: http://www.spip.org/

{% for post in site.categories.spip %}
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