--- 
wordpress_id: 3
layout: post
title: Using Rails and Flex
wordpress_url: http://barcamp2.wordpress.com/?p=3
---
Short talk about using Flex (the <em>other</em>way to create .swf, aimed explicitly aimed at applications, rather than animation, games, etc). The approach is based on using a controller to implement RESTfulness and the like. Flex has lots of XMLness built-in, so this is pretty easy, once you’ve got the controllers generating XML in response to requests.

He began by getting rails to generate XML as he wanted it, and it was natural to start making use of it with Flex which is very much based around XML as a wire format.
<h3>Interesting Rails extras</h3>
<blockquote>
<pre><code>self.find_text_attributes = [ name, surname, nickname, email,
description, ... ]
</code></pre>
</blockquote>
Override the attributes that will be searched when find_text is called…
<blockquote>
<pre><code>self.attribute_group :narrow, [id, customer_name]
</code></pre>
</blockquote>
Comes from the REST controller. What does it do?
<h3>Interesting Flex extras</h3>
Is talking about Flex stuff I don’t know about. “ <em>Components</em>” what’s them then? Are they like <em>modules</em>? Or <em>classes</em>?

Flex uses event bubbling, as you could expect being all JS/AS-y and all. This seems correct.
<h3>Dynamism</h3>
Some Silverlight programmers raising points about Visual Studio doing autocomplete on XML objects, etc., etc. Apparently that isn’t what we want from Flex: it's supposed to be dynamic (makes sense given it's roots in prototype-based JavaScript).
