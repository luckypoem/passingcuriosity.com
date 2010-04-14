---
display  : post
title    : CCK, hook_form_alter and friends
tags     : [drupal, php, code, cck, forms]
location : Perth, Western Australia
excerpt  : |
  An overview of the somewhat detailed process of altering and embedding a
  CCK node type form in the users' profile page.
---

This is a pretty long post about a pretty detailed requirement that makes use
of a few basic techniques. 

1. I have a CCK node type with a user reference.
2. I have a view displaying them on the user profile page.
3. I want to embed the add node form -- with the extraneous fields hidden --
   on the profile page as well.

Create a node type
==================

Use CCK to create the `my_type` node type as you usually do. Be sure to add a
user reference field.

Use Views to display the nodes for the current user on the user profile 
(you'll need to create a Profile display).

Embed the form in the profile page
==================================

Embedding the form is pretty easy:

{% highlight php %}
/**
 * Implementation of hook_profile_alter().
 *
 * Add the my_type node form to the profile page.
 */
function example_profile_alter(&$account) {
  global $user;

  module_load_include('inc', 'node', 'node.pages');
  $node = array(
    'uid' => $user->uid,
    'name' => $user->name,
    'language' => '',
    'type' => 'my_type',
  );

  // Get the node form
  $form = drupal_get_form('my_type_node_form', $node);

  // Add the form in a new section at the bottom
  $account->content['Add My Type'] = array(
    '#title' => t('Add My Type'),
    '#weight' => 1000,
    '#value' => $form,
  );
}
{% endhighlight %}

Alter the form to suit the page
===============================

{% highlight php %}
/**
 * Implementation of hook_form_alter().
 *
 * Add the callback to modify the form IFF on a user profile page.
 */
function example_form_alter(&$form, &$form_state, $form_id) {
  if ('my_type_node_form' == $form_id AND arg(0) == 'user') {
    $form['#after_build'][] = '_example_update_form';
  }	
}

/**
 * Alter the form after it's been built.
 */
function _example_update_form($form, &$form_state) {
  //
  // Do stuff to the form now that the CCK fields have been added.
  // 
  return $form;
}
{% endhighlight %}