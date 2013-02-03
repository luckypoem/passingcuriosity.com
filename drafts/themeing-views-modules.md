---
title    : Themeing Views from a module
category : drupal
tags     : [drupal, views, themeing, modules]
---

Themeing Views from a module is reasonable straightforward if you already know
how to do it, but a little tricky if you don't. Here is my account of themeing
a view in a module.


1. Create the module. I used [Features][features] to create a module that
"implements" my view. This isn't strictly necessary, but I'm not sure why
you'd want to theme a view in a module if it wasn't implementing the view as
well.

2. Implement `hook_theme()` as recommended in the advanced help that comes
with Views (see `/help/views/api-default-views` for more information). I
needed to include additional fields to those listed in the documentation.

You should wind up with something like this:

{% hightlight php %}
function example_theme($existing)
{
  return array(
    'views_view_fields__view_name__display_name' => array(
      'arguments' => array('view' => NULL, 'fields' => NULL, 'row' => NULL),
      'template' => 'views-view-fields--view-name--display-name',
      'original hook' => 'views_view_fields__view_name__display_name',
      'path' => drupal_get_path('module', 'example'),
      'preprocess functions' => array(
        'template_preprocess',
        'template_preprocess_views_view_fields',
      ),
    ),
  );
}
{% endhighlight %}

It's worth noting (for myself, if no-one else) that the recommendation to just
change the weight of the module didn't seem to work and I had to explicitly
enumerate the `preprocess functions`. I have no idea if this should have
worked -- perhaps that only holds if you're overriding a "top-level" item
rather than one of the view- or display-specific overrides?

[features]: http://drupal.org/project/features
[views]: http://drupal.org/project/views