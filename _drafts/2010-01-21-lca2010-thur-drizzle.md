---
layout : post
title : Drizzle
---

18 months ago sat down and looked at it 

Multi cores, 64 bit (well mostly), lots of RAM, modular architecture (more module, replaceable, etc.) Designed for web use.

Why Drizzle
-----------

{% highlight c %}
bool b = -1;
if (b == -1) { fail(); }
{% endhighlight %}

Came from MySQL 6.0: giant blob of code. Take things out of core and put them
in module-y bits. Add testing, code coverage, etc.