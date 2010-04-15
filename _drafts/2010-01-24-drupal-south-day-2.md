---
layout     : post
title      : Day Two of DrupalSouth 
categories : [drupal, lca]
location   : Wellington, New Zealand
excerpt    : |
  My second day at DrupalSouth started late, but I still managed to learn
  about modules playing nicely together, three case studies, MySQL
  optimisation, Features and Drush, and Aegir.
---

Having gone to bed at about 4:00 AM, I was a bit late this morning and arrived
just in time to sneak into the group photo at around ten o'clock. After a
coffee it was time to jump into the remaining morning sessions. First Chris
Burgess' session *Doesn't Play Nicely!* then a set of three case studies of
interesting Drupal projects. After lunch I watch Peter Lieverdink's session 
*MySQL > YourSQL* before ducking out of a few for some 


Doesn't Play Nicely!
====================

Chris' session -- titled *Doesn't Play Nicely!* -- was about the problems that
can arise when modules and themes interfere with each other. He used a few
examples to illustrate some of the most common issues and the ways that they
can be avoided. I'll skip the examples (largely because I didn't take too much
note of them) in favour of the potential problems:

* Almost all of the **global variables and settings** (including the almost
  invisible static variables scattered in many parts of the Drupal API) will
  affect related code if your module changes them. If a module changes the
  active menu, or interferes with the operation of `hook_cron()` then it's
  hardly surprising that other menu or cron related code might fail.

  While this might seem unlikely, similar things can happen when `$user` and
  `$node` get trodden from within module functions. It's often worth while to
  stay away from names like these (which are used throughout Drupal).

  Elysia Cron removing `cron_semaphore` temporarily which ties up other
  `hook_cron()` implementations.


**Incorrect hook implementations** defined in a module need to be completely
documented. #521446 such as `hook_message_alter()` where OG misinterprets and
overwrites `$message['body']`. Everything should be well and completely
documented. (Or unintentional hook implementations! Make sure that your
"private" functions are *definitely* not hook implementations).

**PHP definition conflicts** are reasonably easy to introduce and result in
fatal errors. Check before hand, namespace, or use something like the
`libraries` module.

**Drupal theme and module name collisions** can be a problem. You cannot have
both a module named `acme` and a theme named `acme`.

**Depending on a specific-version** can be problematic as there's no way to
depend on a specific version. Either don't do it, or check in the install, or
import the code.

**Drupal paths** can be tricky in the presence of internationalisation, pURLs,
and other modules that interact with paths. Always use
`drupal_get_path_alias('node/'.$nid)` rather than building a string yourself.

**Filters and `hook_nodeapi()`** can be rife with problems introduced due to
the order of invocations. Interesting to think about input formats being
applied to input text. Are there security implications if the wrong filters
are combined? What about modifications to content in `hook_nodeapi()`?

In Summary
----------

Consider everything as a potential security hole unless and until you know otherwise.

Do "namespacing" (not by using the actual `namespace` functionality) properly
within themes and modules.

Assume that other module authors will want to use your functions. Document
them clearly and avoid breaking functionality with changes.

Don't assume that the other modules in a site are playing nicely and don't
assume that a clash is with only a single other module. It may not even be
their fault.

Other stuff
-----------

Namespacing FAPI and similar semi-global names that can tread on each other
(e.g. two modules using `formalter` to add an field set called `image`).

There's a module to set module weights on the modules admin page.

The system table contains paths to modules. 

Workflow, rules and actions modules often don't play nicely together. In
particular, rule execution and workflow transitions seem particularly
sensitive to ordering.

