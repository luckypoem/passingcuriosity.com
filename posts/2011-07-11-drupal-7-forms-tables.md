---
layout: post
title: "Drupal 7: theming forms with tables"
categories: [drupal]
tags: drupal7, theme, render, forms, tables, ajax, ahah
location: Perth, Western Australia
excerpt: |
  This is a quick guide to using tables for layout of forms in Drupal 7
  without being naughty.
---

There are a few different ways to use tables to layout Drupal 7
forms. The most commonly described method (indeed, it's used in the
core [tableselect][1] form field type) is to create a custom form
field type that can process it's children and render as a table. This
is pretty limiting (`tableselect`, for instance, is pretty much just a
select field).

Another approach is to use `#prefix` and `#suffix` to wrap each field
in the table with the appropriate HTML tags to build the table. This,
though, means that changing the weights of elements, adding and
removing elements, or making pretty much any change to the form might
result in invalid or completely broken markup.

The approach I think is best is to treat the table similarly to the
way the forms API handles fieldsets: as a container with multiple
fields within it. This can be a little tricky to get working, but
seems to do the trick for me. The approach works like this:

Create a new form element that will be the table:

    $form['people'] = array(
      '#prefix' => '<div id="people">',
      '#suffix' => '</div>',
      '#tree' => TRUE,
      '#theme' => 'table',
      '#header' => array(t(First name), t('Family name')),
      '#rows' => array(),
    );

Then loop over your data to create the rows in the table. This is a
little tricky: if you just put your fields straight into
`$form['people']['#rows']` then FAPI won't see them (remember that it
won't traverse array components begining with a `#`) and so won't
process them. On the other hand, you *could* name your array
`$form['people']['rows']` but then the FAPI will generate quite noisy
field names and add additional values which will confuse
`theme_table()` when it comes time to render the whole lot.

Instead, we'll use references to build both include the fields in the
form (though in a way that they won't be actually output) *and* put
them in `$form['people']['#rows']` so the table will be rendered
nicely. This is possible mainly through the use of references!

Assuming you've got an array `$people` containing your data you can
loop over them to add the rows to your table like so (and yes, I know
this could be structured better):

    for ($i = 0; $i < count($people); $i++) {
    
      // Build the fields for this row in the table. We'll be adding
      // these to the form several times, so it's easier if they are
      // individual variables rather than in an array.

      $fname = array(
        '#id' => 'people-' . $i . '-fname',
	'#type' => 'textfield',
	'#default_value' => $people[$i]['fname'],
      );
      $sname = array(
        '#id' => 'people-' . $i . '-sname',
	'#type' => 'textfield',
	'#default_value' => $people[$i]['sname'],
      );
      

      // Include the fields so they'll be rendered and named
      // correctly, but they'll be ignored here when rendering as
      // we're using #theme => table.
      //
      // Note that we're using references to the variables, not just
      // copying the values into the array.

      $form['people'][] = array(
        'fname' => &$fname,
        'sname' => &$sname,
      );
      
      // Now add references to the fields to the rows that
      // `theme_table()` will use.
      //
      // As we've used references, the table will use the very same
      // field arrays as the FAPI used above.

      $form['people']['#rows'][] = array(
        array('data' => &$fname),
	array('data' => &$sname),
      );

      // Because we've used references we need to `unset()` our
      // variables. If we don't then every iteration of the loop will
      // just overwrite the variables we created the first time
      // through leaving us with a form with 3 copies of the same fields.
      
      unset($fname);
      unset($sname);
    }

Now you should have a form full of fields all laid out nicely in a
table. Hoorah!
