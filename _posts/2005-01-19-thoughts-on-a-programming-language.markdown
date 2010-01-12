--- 
wordpress_id: 1553
layout: post
title: Thoughts on a Programming Language
wordpress_url: http://passingcuriosity.com/2005/thoughts-on-a-programming-language/
---

I've been thinking for quite a while now, that I'd like to have a go at
writing my own programming language. I've been slowly working my way, little
by little, through some of the ideas I'd like to experiment with in my
language over the last couple of years. The *Software Systems* and
*Programming Paradigms* units I took last year gave me a lot to think about,
as have exposure to languages like [Io][io], [Haskell][hs], [Scheme][s48],
[Python][py], [Java 1.5][java].

[io]: http://www.iolanguage.com/
[hs]: http://www.haskell.org/
[s48]: http://www.s48.org/
[py]: http://www.python.org/
[java]: http://java.sun.com/j2se/1.5.0/docs/guide/language/

Though I still have a lot to study in more depth (especially in the areas of
semantics and type systems, neither of which I have actually studied), I've
come up with a few features that I want in my language.


1. A lightweight, flexible type system.

   I'd like my language to have a type system that includes a number of
   features usually only found in heavy weight languages like Java, Common
   Lisp and C#. First amongst these is some form of inheritance and
   polymorphism. This has fairly obvious benefits, and is something I missed
   during my brief foray into the world of Haskell (either because it isn't
   possible, or I didn't know how). Second is some form of parametrised types
   to implement generics (and whatever else one uses parametrised types for).
   Parametrised types and generics are a more subtle beast. I don't really
   know if they will be any harder [than inheritance and polymorphism] to
   implement, but they will make any language immeasurably more usable,
   especially for collections and various patterns involving proxying of one
   form or another.

   Another aspect of the type system that will be essential is being light
   weight. If the language winds up supporting run-time loading of objects
   (like Java, C#, et al) it will need to support run-time type checking,
   which means that it'll have to have some form of type tagging, boxing, etc.
   I would like to keep this as minimal as possible, ideally, it would be [at
   most] a single word per object.

2. Support for object-oriented programming.

   Hand in hand with the specialisation and polymorphism and parametrisation
   (in my opinion at least) is support for object-oriented programming
   techniques. Whilst I'm still of two minds about making everything an
   object, I do think that the `<object>.<verb>` form makes a lot of
   sense for certain operations. I also think that supporting a restricted
   multiple inheritance, be it mix-ins or just interfaces, paired with
   polymorphism, can provide similar amounts of power to operator overloading
   in C++, or type classes in Haskell.

3. Fine grained memory access, if you want it.

   In addition to object orientation, I think that fine grained access to
   memory is essential. One of the main goals I have is to be able to do
   similar things with objects and collections in my language, as I can do
   with arrays of structs in C, with similar efficiency. This will probably
   mean that the user will need to have some way of controlling memory access,
   probably via the type system.

4. A functional flavour.

   Whilst I do like functional programming, sometimes (especially when dealing
   with things like the "tables" described in point 3) a little bit of
   statefulness is essential. As cool as the monads in Haskell are, I'm going
   to try making functional-ness optional. Things like predicates should be
   functions. Things like operators should, arguably, be functions. Accessor
   methods probably shouldn't.

5. Real support for concurrency.

   I love the idea of language level support for concurrency. Transactional
   Memory (see my [earlier][1] [posts][2]) is a brilliant idea. The paper on
   `undo` in C# is also fairly interesting. I intend to use native threading
   support in my run-time to implement things like co-routines and actors as
   well as more traditional concurrency primitives. This is one the aspects I
   find most interesting. Adding support for high level concurrency primitives
   will have, I hope, a similar degree of impact on the languages usability as
   generics.

[1]: /2005/composable-memory-transactions/
[2]: /2005/more-on-composable-memory-transactions/

On the whole, I'm not much closer to being able to write my own language than
I was last year, but my ideas have coalesced into a much more coherent form. I
hope to start working some time this year on it, which means I need to start
reading up on many aspects, especially formal semantics, in between doing my
Honours.

I'd better get started.
