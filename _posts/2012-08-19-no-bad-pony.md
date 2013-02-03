
What turns an idea into a bad pony? 

- Is just wrong, impractical, doesn't fit design.

- Take project in wrong direction

- Doesn't come with an offer of assistance.

Ideas that are wrong:

- violates a standard of best practice

- can't be implemented

- Rusty Russell Interface Level too high

- Idea violates DRY.

Impractical ideas:

- Not obviously wrong, but they aren't right either.

- Solving a problem that doesn't exist. E.g: DB cache doesn't use the ORM.

- Changes the design contract. (e.g: `syncdb` doesn't touch existing tables,
  even though it *could* add manytomany, but doesn't)

- Address smaller parts of a larger problem. 

- Architecture astronauting. Practicality counts; perfectionists with
  deadlines, etc.

Design:

- All the pieces that are part of Django have the same flavour, built by the
  same team, we like them.

- Replacing the template engine, the ORM, the test framework, etc. is not
  going to happen: we're happy with and want what we have.

- "I love Django but it'd be great if it was completely different." is never
  going to be compelling.

- The small learning curve (Forms and Models look very similar) is one of the
  good things about Django.

Ignores philosophy

- "Add GROUP BY, HAVING to ORM" misses the point that the ORM is not SQL, by
  default.

- Adding AJAX to Forms; Django is a server-side framework.

Just add a settings

- "A setting is a decision deferred"

- Simplicity is a virtue, just adding settings to core makes Django more
  complex and harder to learn.

Wrong direction

- Feature creep. Django is not a web-server or a database or anything else; it
  won't add features for these things, just use one of them.

- Add a backend. None of these things need to be in core. Adding it to core
  really means: "please look after this thing for me". This is why there are
  backend APIs.

- The core doesn't need to do everything, the community can do awesome stuff,
  just because it's in core doesn't mean it's good.

- Adding apps to `django.contrib`: what does we get from pulling them in?
  Nothing, except a slower development schedule. If anything we're pulling
  things *out* of contrib.

- What is `django.contrib`? "An collection of optional, defacto standard
  implementations of common patterns." These are pretty much universal.
  Tagging, etc.: not so much (and which one).

Non technical

- Here's a big job (but I'd like someone else to do it please)

- Process suggestions. If you want news round ups, more blog posts, etc., then
  pitch in!

- Massive features: schema evolution, support for non-SQL data stores, 

How do you get your pony?

- NO Putting your name on the ticket CC or saying "me to".
- NO Posting hyperbole on your blog because it doesn't have X.
- NO Playing games in the ticket tracker.

- Offer to help

- Or actually help out! Don't just write code, advocate for your code (why
  else will someone review).

