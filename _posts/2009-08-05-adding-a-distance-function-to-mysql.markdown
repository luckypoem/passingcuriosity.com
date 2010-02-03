--- 
layout   : post
title    : Adding a distance function to MySQL
tags     : [mysql, django, geographical, gis, distance]
location : Perth, Western Australia
excerpt  : |
  This is a quick and rather hackish way to add a "distance" function to MySQL
  and call it from the Django ORM framework.
wordpress_id: 1217
wordpress_url: http://passingcuriosity.com/?p=1217
---

I've been working on a project which involves a little bit of geographical
information lately (using [Django](http://djangoproject.com/), if that's
important to you) and one of the problems I've encountered is MySQL's
incomplete implementation of the various functions that you'd expect of a
geographically-capable database system. One particular lack is a function to
calculate the distance between two points (or, even, other geometric forms).
Thankfully, it's possible to define it yourself (though convincing
[GeoDjango](http://geodjango.org/) to run it is another matter). There are
copies floating around in the 'tubes, but [the one I found at MySQL
forge](http://forge.mysql.com/tools/tool.php?id=41) (and also [on the author's
blog](http://pabloj.blogspot.com/2006/01/distance-function-for-mysql.html)) is
a bit broken.

Below, I'll mention *why* I think it's broken and the small change required to
"fix" it.

Alas, it doesn't work very well on current versions of MySQL (and judging by a
comment on the page, it didn't work meaningfully back in 2006): it defines a
new function `distance` from two `POINT`s to a `DOUBLE`. For some bizarre
reason, though, it `round`s it's result to 0 decimal places. This makes it
pretty useless for local `POINT`s in a coarse metric like degrees (where 1° of
latitude is around 111km) when your `POINT`s are local: you'll often get a
whole lots of `0`s in your results:

Thankfully, it's easy to fix: just remove the call to `round` (or, I suppose,
give it an accuracy rather than let it default to 0 places).

To [create the
function](http://dev.mysql.com/doc/refman/5.0/en/create-procedure.html) simply
run the following command somehow -- I prefer the `mysql` command-line, others
[phpMyAdmin][], and still more will put it in an XML file to be interpreted by
a rule engine which is called as part of a semi-automated deployment process
(these are the people that enjoy using Java):

{% highlight sql %}
-- Switch delimiter so the ; will work in the function body
DELIMITER $$

-- Create the function
CREATE FUNCTION `distance`(a POINT, b POINT) RETURNS double 
    DETERMINISTIC 
    COMMENT 'Calculate the distance between two points' 
    BEGIN 
        RETURN glength(linestringfromwkb(linestring(asbinary(a), asbinary(b)))); 
    END$$

-- Switch the delimiter back to ;
DELIMITER ;
{% endhighlight %}

You'll notice that this is calling both `asbinary` (to convert WKB values into
internal MySQL values) and then `linestringfromwkb` (to convert WKB into
internal MySQL values). Exactly *why* `linestring` takes MySQL values and
returns a WKB value, I'm not sure, but it does. If you need to support WKT
inputs, then you'll wind up calling conversion functions four or five times
per query.

Convincing Django to call this new function is another matter all together.
After a day and a half of trying to understand the GeoDjango back-ends, I gave
up (see [this thread on the GeoDjango mailing
list](http://groups.google.com/group/geodjango/browse_thread/thread/8f3e66b03c126a32)
for a little more information) and just used the `extra()` method to add a
call to the function as a new column and `order by` it:

{% highlight python %}
pc = Postcode.objects.get(postcode='0200')
sel = SortedDict([('distance', 'distance(location, geomfromtext(%s))')])
sel_p = (pc.location.wkt,)
locations = Locations.objects.extra(select=sel, select_params=sel_p, 
    order_by=['distance'])
{% endhighlight %}