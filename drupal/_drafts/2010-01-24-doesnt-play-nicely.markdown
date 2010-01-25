Admin Menu vs Menu Breadcrum or Local Menu or Nice Mens (but it's not Admin
Menu's fault).It's because other modules set the active menu to be Admin Menus
(and then do stuff that interferes with it).

Potential Conflicts
===================

**Global variables and settings** such as the current menu (stored as a
static). Elysia Cron removing `cron_semaphore` temporarily which ties up other
`hook_cron()` implementations.

Similar things can happen when `$user` and `$node` get trodden from within a
scope.

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
==========

Consider everything as a potential security hole unless and until you know otherwise.

Do "namespacing" (not by using the actual `namespace` functionality) properly
within themes and modules.

Assume that other module authors will want to use your functions. Document
them clearly and avoid breaking functionality with changes.

Don't assume that the other modules in a site are playing nicely and don't
assume that a clash is with only a single other module. It may not even be
their fault.

Other stuff
===========

Namespacing FAPI and similar semi-global names that can tread on each other
(e.g. two modules using `formalter` to add an field set called `image`).

There's a module to set module weights on the modules admin page.

The system table contains paths to modules. 

Workflow, rules and actions modules often don't play nicely together. In
particular, rule execution and workflow transitions seem particularly
sensitive to ordering.