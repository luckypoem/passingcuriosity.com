---
layout   : post
title    : Over-engineered ROT in Haskell
tags     : [code, haskell, rot]
location : Perth, Western Australia
---


{% highlight haskell %}
-- | ROT cipher.
import Data.Char

class Rotable r where
	rot :: Int -> r -> r

instance Rotable Char where
	rot n l = chr $ (((ord l) - (ord 'a') + n) `mod` 26) + ord 'a'

instance (Rotable e) => Rotable [e] where
	rot n l = let r = rot n in map r l

rot14 :: (Rotable r) => r -> r
rot14 = rot 14
{% endhighlight %}