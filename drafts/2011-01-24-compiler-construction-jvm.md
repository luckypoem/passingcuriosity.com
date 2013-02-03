---
layout      : post
title       : Most complex look at "Hello World"
categories  : [lca2011]
tags        : [java, jvm]
excerpt     : |
  Steve 
---

Tom Lee, senior consultant for Shine Technologies. Hobbyist compiler
enthusiast, contributed to (C)Python:

- `try:except:finally:` syntax in Python 2.5
- AST compilation in Python 2.6
- AST optimisation in Python 2.7/3k

Why target JVM?
===============

Leveraging the large ecosystem of libraries and tools.

Highly tuned and well optimised for long-running processes.

Memory management.

Enterprise friendly (whatever that means) - write in what you like and give
the client a JAR.

Compiler Construction 101
=========================

Most compilers have a structure something like this (most "real" compilers
will have more, potentially many more, phases):

1. *Source code*
2. `Scanner`
3. *Tokens*
4. `Parser`
5. *AST*
6. `Code Generator`
7. *Target Code*

An examples
===========

    stmt ::= expr ";"
    expr ::= string | call
    call ::= name "(" args? ")" 
    args ::= expr ("," expr)*
    name ::= ID
    str ::= STRING

Using Scala's parser combinators makes implementing this type of language
pretty straightforward.

In scala:

- A trait for AST nodes
- A trait for expressions
- A trait for statements
- Case classes for everything else

Use BCEL to generate Java bytecode (you need to jump through the hoops that
the verifier wants). Need to 


