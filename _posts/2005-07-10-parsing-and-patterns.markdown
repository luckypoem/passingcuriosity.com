--- 
wordpress_id: 1437
layout: post
title: Parsing and Patterns
wordpress_url: http://passingcuriosity.com/2005/parsing-and-patterns/
---

The logic compiler generates Haskell code to implement a calculus. This
includes a data-type to represent formulae, a function to resolve those
formulae into sub-formulae, functions to format them for output, miscellaneous
utility functions and a parser to parse formulae in the language the calculus
operates with. As the code stands currently, the logic language allows the
user to define operators with arbitrary arity and fixity. One might, if one
were of a mind, define a 4-fix **#** operator with an arity of 3. A formula
with such an operator might look like:

<code style="text-align: center;">&alpha;<sub>1</sub> &alpha;<sub>2</sub> &alpha;<sub>3</sub> # &alpha;<sub>4</sub></code>

As the code stands, the generated parser is built using the <a href="http://www.cs.uu.nl/people/daan/download/parsec/parsec.html#buildExpressionParser">buildExpressionParser</a> facility of the <a href="http://www.cs.uu.nl/~daan/parsec.html">Parsec</a> parser library. Unfortunately, `buildExpressionParser` is only capable of handling expression languages with unary prefix, binary infix and unary postfix operators, meaning that we can't generate parsers for all calculi that can be defined with our language.

To fix this, I'm going to have to write a more general expression parser
generator (hopefully using `buildExpressionParser` as a base) that can handle
operators of arbitrary arity and fixity. Either that, restrict the system to
only unary and binary operators which would make implementing some
[conceivable] logics very difficult, if not impossible.

On the other hand, `buildExpressionParser` has greatly simplified the pattern
handling code in the compiler. In our language (which is so simple as to not
need a name), we define rules such as: 

`Resolve "a->b" to "~a" or "b".`

The patterns (the bits in quote marks) are formulae using the operators of the
calculus, with arbitrary alphabetic names for variables (which can stand for
any sub-formula - we can make no distinction at this point between
sub-formulae and propositions as I haven't got round to implementing that
yet). Our compiler generates *at run time* a parser for the
formulae of the calculus and uses it to parse the rule patterns and generate
appropriate snippets of code which we use for pattern-matching in the Haskell
code implementing the calculus. For example, the rule above would be
translated to the Haskell code 

{% highlight haskell %}
resolve (Impl a b) = Or [(Neg a), b]
{% endhighlight %}

Once we've parsed the pattern and generated a function, we get the pattern
matching at run-time for free from Haskell.
