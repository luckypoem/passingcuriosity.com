---
title    : CSS isn't the only thing broken in IE
tags     : [web, javascript, dom, internet explorer]
location : Perth, Western Australia
excerpt  :
  It's CSS isn't the only thing broken about Internet Explorer. It also has
  some pretty odd event handling as well.
---

A buggy implementation of the CSS box model and various departures from other
standards are not the only issues to deal with when making a web site Internet
Explorer-proof (never mind "idiot", IE is the web version of "intellectual
cripple"). You also need to work around one of the worst implementations of
JavaScript, DOM, and event handling ever vomited upon innocent computers.

{% highlight javascript %}
var fn = function(){
	window.alert('The situation is being handled');
};

$('input:radio').bind("change", fn);

if ($.browser.msie) {
	$('input:radio').bind("click", fn);
}
{% endhighlight %}