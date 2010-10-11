---
layout      : post
title       : Using ImageMagick and GD2 together with Drupal ImageCache
category    : drupal
tags        : [php, images, resize, imagemagick, gd]
location    : Perth, Western Australia
excerpt     : |
  A quick (working!) introduction to using ImageMagick in custom ImageCache 
  actions while using GD as your default toolkit.
---

A lot of Drupal sites use [ImageCache][] and [ImageAPI][] to automatically
scale and process images for display. Most of them (the vast majority, unless
I miss my guess) will be using the [GD] toolkit and running with `mod_php`
embedded in Apache. This is fine in most cases, but sometimes it's definitely
the wrong thing to do; in my case, I'm processing large image files (~4M or
so) and keeping my memory limit down. The easiest way to do this is to offload
the processing to another process. Something like ImageMagick perhaps? With a
custom action from [ImageCache Actions][], this is simple!

A quick Google led me to an article called [Create PDF thumbnails with
imagecache and ImageMagick while GD is still the default
toolkit](http://drupal.org/node/641372) which supplies the following code
(simplified a little by removing the PDF-y bits):

{% highlight php %}
<?php
$w = 246; // change to your preferred thumbnail width
if (!_imageapi_imagemagick_convert($image->source.'[0]', $image->source.'.png', array(0 => '-thumbnail '.$w))) return FALSE;
$img = imagecreatefrompng($image->source.'.png');
file_delete($image->source.'.png');
$image->resource = $img;
$image->toolkit = 'imageapi_gd';
$image->info = array('extension' => 'jpeg');
return TRUE;
?>
{% endhighlight %}

Alas, this code it pretty useless: because it stomps on `$image->info` any
further actions on this `$image` will probably break.

Thankfully, there's an easy fix: when you update `$image`, make sure you
update everything that needs fixing. Here's the amended code:

{% highlight php %}
// "Thumbnail" the image
$width = 600;
if (!_imageapi_imagemagick_convert($image->source, $image->source.'.png', array(0 => '-thumbnail '.$width))) return FALSE;

// Load it back in as a GD resource
$img = imagecreatefrompng($image->source.'.png');

// Get the "deets" on the new image
$info = getimagesize($image->source.'.png');
$image->resource = $img;
$image->toolkit = 'imageapi_gd';
$image->info = array(
  'width' => $info[0],
  'height' => $info[1],
  'extension' => 'png',
  'file_size' => filesize($image->source.'.png'),
  'mime_type' => $info['mime'],
);

// Clean up
file_delete($image->source.'.png');

return $image;
{% endhighlight %}

Make sure that you've enabled the ImageMagick toolkit, drop this code in a
custom action and you'll be on externally processing images in no time!

[ImageCache]: http://drupal.org/project/imagecache
[ImageAPI]: http://drupal.org/project/imageapi
[ImageCache Actions]: http://drupal.org/project/imagecache_actions
[GD]: http://www.php.net/gd