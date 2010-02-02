---
layout   : post
title    : Paths with arguments in Panels
tags     : [php, code, drupal, path, arguments, panels, url]
location : Perth, Western Australia
excerpt  : |
  A short snippet of Drupal PHP code to generate a new path to access a panel
  with new values for one or more arguments.
---

I'm currently working on a Drupal site (well, I'm currently on holiday, but I
*have* been and will continue working on a Drupal site). One section of the
site allows users to browse a collection of nodes organised structured by the
terms of a hierarchical taxonomy. I choose to implement this as a
[Panels][panels] page containing two elements:

1. a "browser" widget for the taxonomy; and
2. a view to display the 

{% highlight php %}
/**
 * Find the path for the current panel with substitutions as in $args.
 *
 * @param $substitutions array
 *     Associative array of context id/value substitutions.
 * @return string
 *     The current path with the substitutions made.
 */
function path_for_current_panel_with_args($substitutions)
{

	//
	// Get the path components
	//
	$menu = menu_get_item();
	$path_elements = explode('/', $menu['path']);

	//
	// Get the argument values
	//
	$display = panels_get_current_page_display();
	$data = array();
	foreach ( $display->context as $name => $context ) {
		$data[$name] = $context->original_argument;
	}
	
	//
	// Replace current value/s with new value/s
	//
	foreach ( $substitutions as $name => $value) {
		$data[$name] = $value;
	}

	//
	// Build the new path
	//
	$npath = array();
	foreach ( $path_elements as $element ) {
		if ('%' == $element ) {
			$npath[] = array_shift($data);
		} else {
			$npath[] = $element;
		}
	}
	$npath = array_merge($npath,$data);
	$npath = rtrim(implode('/', $npath), '/');

	return drupal_get_path_alias($npath);
}

{% endhighlight %}