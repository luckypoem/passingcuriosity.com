---
wordpressid: 1051
wordpressurl: http://passingcuriosity.com/?p=1051
layout: post
title: Authorising user actions in SPIP
location: Perth, Western Australia
tags: spip, php, code, authorisation, security
excerpt: |
  One of the APIs that many SPIP plug-ins will need to use is `autoriser()` --
  the function which determines whether a user should be permitted to perform
  a given operation. As I couldn't find any document on using this function, 
  here are a few notes.
---

One of the APIs that many SPIP plug-ins will need to use is `autoriser()` --
the function which determines whether a user should be permitted to perform a
given operation. As I couldn't find any document on using this function, I'll
provide a few notes below.

Checking that a user if authorised to perform an action is a little more
haphazard than I'd like in SPIP ("No authorisation check? No worries!" is not
a particularly comforting approach), but it seems to get the job done even if
it does depend on more developer discipline than seems warranted. Checking
that a user is "authorised" to perform an action is done by calling the
[`autoriser()`](http://doc.spip.org/@autoriser) function with arguments to
describe the operation. If it returns `true` then the operation is authorised,
it not, then it isn't.

Like most of SPIP's core functions, `autoriser` is implemented in a way that
makes it easy to override and extend its functions: rather than make any
decision itself, it simply delegates the decision to the first function it
finds that can decide for that type of operation and object (or object, or
operation).

First, though, lets look at `autoriser`'s arguments:

{% highlight php %}
function autoriser_dist($faire, $type='', $id=0, $qui = NULL, $opt = NULL)
{% endhighlight %}

This first (and only required) argument is `$faire` (French, I'm told, for "to
do") which takes a string: the name of the operation. The second argument
`$type` is another string: the type of object being operated on; and the third
is an integer: the ID of the particular object, if there is one. The fourth,
`$qui` ("who") is an array of details of the current user; and the fifth, I
assume, is an array of optional values if the previous four are not enough to
make some decisions).

Only the first of these -- the operation being performed -- is required and
only the first should need to be specified in the vast majority of situations
(it'll work out the user by itself and there are many operations without a
`$type` or an `$id`). Once it's been called, `autoriser` uses these values to
look for a function that can make a decision for the given type and
operations.

You can see the code of [`/ecrire/inc/autoriser.php` (around line
87)](http://trac.rezo.net/trac/spip/browser/spip/ecrire/inc/autoriser.php#L87)
for the particular functions that it will call, but the full list of
alternatives that ''autoriser($faire, $type, $id, $qui, $opts)'' is (in order
of preference):

1. `autoriser_$type_$faire()`
2. `autoriser_$type()`
3. `autoriser_$faire()`
4. `autoriser_default()`
5. `autoriser_$type_$faire_dist()`
6. `autoriser_$type_dist()`
7. `autoriser_$faire_dist()`
8. `autoriser_default_dist()`

Adding authorisation checks to your plug-in is easy: just implement one of
these checking functions (in a file that'll be included by a `<fonctons>`
entry in your `plugin.xml` file is probably best) and then get `autoriser` to
call it when appropriate.

From `aplugin_fonctions.php` or some other file:

{% highlight php %}
/**
 * Perform authorisation checks for "elephant" objects.
 */
function autoriser_elephant($faire, $type='elephant', $id=0, $qui=NULL, $opt=NULL) {
   if ( '0minirezo' == $qui['statut'] ) {
       return true;
   }
   return false;
}
{% endhighlight %}

With this code in place, only administrators will be able to perform actions
(or, strictly speaking, perform actions checked with the `autoriser` function)
on *elephant* objects. Any call specifying `$type='elephant'` will use the
above function to determine if the operation should proceed.

In `exec/anaction.php` or similar, we might use code like this:

{% highlight php %}
if ( autoriser('kill', 'elephant', $id_elephant) ) {
   launch_missiles_at('elephant', $id_elephant);
} else {
   echo _T('aplugin:cannot_shoot_elephant'), _T('aplugin:permission_denied');
}
{% endhighlight %}


Which will try the following functions, in order, to decide whether or not to
`launch_missiles_at()` our poor elephant:

1. `autoriser_elephant_kill()`
2. `autoriser_elephant()`
3. `autoriser_kill()`
4. `autoriser_default()`
5. `autoriser_elephant_kill_dist()`
6. `autoriser_elephant_dist()`
7. `autoriser_kill_dist()`
8. `autoriser_default_dist()`

That's about all there is to it. Of course, there's a lot more you can do to
make your authorisation decisions: per-user and per-object configurations you
might like implement (similar to the way SPIP allows us to restrict
administrators and editors "to a section"), time-based or geographic
restrictions (editing during working hours only, or from an IP address in
Africa), or restricting access to those within your organisation's network.

The world of authorisation is your oyster!
