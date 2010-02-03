--- 
layout   : post
title    : Django form fields and templates
tags     : [django, html, web, forms]
location : Perth, Western Australia
excerpt  : |
  Determining the type of a form field object from a Django template requires
  writing a new filter.
wordpress_id: 1271
wordpress_url: http://passingcuriosity.com/?p=1271
---

I've been working with [Django][django] for the last little while (or long
while) and something that stumped me for a while was a useful, generic
approach to marking-up forms in HTML. In particular, making it possible to use
CSS to style classes of fields (all checkboxes, for instance, or all
date-pickers) effectively. Doing so requires being able to write a selector to
pick such elements out, but I found it very difficult to do so.

[django]: http://djangoproject.org/

The only way, as far as I (and [the replies on django-users@](http://groups.google.com/group/django-users/browse_thread/thread/16493dd43303efd3)), is to write a template filter to extract a such a value for you. Thankfully, this it pretty easy:

{% highlight python %}
    @register.filter
    def field_type(field):
        """
        Get the name of the field class.
        """
        if hasattr(field, 'field'):
            field = field.field
        s = str(type(field.widget).__name__)
        s = s.rpartition('Input')[0]
        s = s.lower()
        return s
{% endhighlight %}

I can use the above filter to add a class to my form markup:

{% highlight html+django %}
    {% for field in form %}
        {% if field.is_visible %}
            <div class="form-field form-{{ field|field_type }}">
                {{ field.label_tag}}
                {{ field.errors }}
                {{ field }}
            </div>
        {% else %}
                {{ field }}
        {% endif %}
    {% endfor %}
{% endhighlight %}

Which I can then use in my CSS to style particular widgets without having to do them one-by-one using ID's:

{% highlight css %}
.form-field label {
    display: block;
    width: 15%;
    float: left;
}

div.form-checkbox label {
    width: 85%;
    float: right;
    clear: right;
}
div.form-checkbox input {
    float: left;
    margin-left: 12%;
}
{% endhighlight %}
