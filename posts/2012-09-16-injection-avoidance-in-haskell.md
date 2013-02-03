---
layout: post
title: Injection avoidance in Haskell.
tags: haskell, ghc, security, static
excerpt: A proof of concept technique for writing injection-proof APIs in Haskell.
---

This post contains a short proof-of-concept for a technique which allows
library authors to implement injection-proof interfaces. It combines two
techniques used by Bryan O'Sullivan in the [mysql-simple][2] and [text][1]
packages:

- Wrap injection-vulnerable string parameters in a new type with a restricted
  API.

- Use GHC's rewriting facilities to modify the code generated for literal
  values of string types.

This technique (which probably isn't new, but is new to me) works like this:

1. Create a new type which wraps your problematic strings.

2. Define an instance of `IsString` for this new type.

3. Implement a new "unsafe" version for the `fromString` method.

4. Use a rule to specialise `fromString` to your `fromStringUnsafe` function.

5. Define a "safe" version of the `fromString` method.

6. Use a rule to replace "safe" calls to `fromStringUnsafe` with your
   `fromStringSafe` function.

The first two steps result in an API in which writing unsafe code requires
explicit effort from the programmer. Rather than writing:

    result <- query_ $ "SELECT * FROM table WHERE id = " ++ theId

a programmer will need to write:

    result <- query_ $ fromString $ "SELECT * FROM table WHERE id = " ++ theId

This is certainly an improvement, but still allows unsafe operations to be
performed.

Steps three and four convince GHC to replace the `fromString` calls which
convert string values (be they literal as in the first example or dynamic as
in the second) into our custom type with calls to our own specialised
function. Functionally, this should have no impact on the program.

In steps five and six we use a technique from *text*, where we use knowledge
of GHC's internals to rewrite the code which handles our string literals and
replace this code with something a little more specialised. In the *text*
package, this results in code which goes straight from `GHC.CString.Addr#` to
`Text` values rather than going via an intermediate `String`.

So far this seems like a little bit of security theatre with a little bit of
optimisation, but it becomes more powerful when we make our implementations of
`fromString` and `fromStringUnsafe` call `error` and only `fromStringSafe`
actually create a `Query` (or whatever your type is).


[1]: http://hackage.haskell.org/package/text
[2]: http://hackage.haskell.org/package/mysql-simple
