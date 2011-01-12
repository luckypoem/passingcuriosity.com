---
layout  : main
title   : DrupalDownunder 2011 Archives
section : Past
feed    : /conferences/ddu2011/atom.xml
---

DrupalDownunder 2011 Archives
=============================

This is an archive of posts about [DrupalDownunder 2011][ddu2011].

[ddu2011]: http://drupaldownunder.org/

{% for post in site.categories.ddu2011 %}
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