---
layout  : main
title   : Drupal Archives
section : Past
feed    : /drupal/atom.xml
---

Drupal Archives
===============

This is an archive of posts about [Drupal][drupal].

[drupal]: http://www.drupal.org/

{% for post in site.categories.drupal %}
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