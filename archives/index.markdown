---
layout  : main
title   : Archives
section : Past
---

Archives
========

This is the complete archive of posts at *[Passing Curiosity](/)* in
reverse chronological order.

{% for post in site.posts %}
<div class="section list">
  <h1>{{ post.date | date_to_string }}</h1>
  <p class="line">
    <a class="title" href="{{ post.url }}">{{ post.title }}</a>
  </p>
  <p class="excerpt">{{ post.excerpt }}</p>
</div>
{% endfor %}
