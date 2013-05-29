# Keynote by Manuel Chakravarty

## The Essence of Functional Programming

Extraterrestrials certainly won't use human languages, but must be
technologically advanced (otherwise: how space travel?) with good
understanding of science and technology (physical constants and laws). Could
there be some common language of computation?

Alonzo Church's lambda calculus has only three [syntactic] rules:

- $M, N -> x$

- $\lambda x . M$

- $M N$

There are other fundamental calculi and models, including Alan Turing's
universal machines.

Church and Turing described their models at the same time and for very similar
purposes: the study of computation and its limits. See also Hilbert's
programme and the Entsheidungsproblem:

> **Is there an algorithm** to decide whether a given statement is provable
> from a set of axioms using the rules of first-order logic?

The answer, of course, is that an algorithm is not possible. Proving such a
thing -- the impossibility of an algorithm -- takes a similar approach in both
cases:

1. Design a formalisation of universal computation.

2. Show that the desired program cannot be defined.

Church-Turing thesis: these two calculi are equivalent (can express exactly
the same programs). However, the lambda calculus is "drastically" more general
than Turing's machines.

The structure of the simply typed lambda calculus has the same structure as
intuitionistic propositional logic (Curry & Howard). Both structures are
instances of cartesian closed categories (Curry, Howard, Lambek
correspondence).

The implication is that Church didn't *invent* the lambda calculus, he
discovered an inevitable structure.

Clearly, any aliens with sufficient mathematical and computation knowledge
would be aware of the lambda calculus (or a similar structure).

The languages dervied from LC have a range of features which are, in some
sense, necessary consequences of that relationship:

- well-defined semantics

- HOFs and closures

- types

- immutability

- purity

These impact on a range of practical considerations:

- concurrency and parallelism

- meta programming

- strong isolation and, as a result, easier reuse

- safety

- formal reasoning

So we have a core, languages based on it, features that derive from this
basis, with good practical benefits.

## Software development methodology based on this essence

> Functional programming as a *development methodology*, not just a language
> category.
> 
> The key to functional software develpment is a consistent focus on
> *properties*.

The properties of software:

1. Have a rigorous specification in some formal (or semi-formal) language.

2. ?

3. ?

Examples of properties include the *purity* of a function, the type of a term
(such as `map :: [a] -> (a -> b) -> [b]`).  Step 2 of the design/development
process described in in How to Design Programs is "Write down a signature".

Quickcheck properties.

Algebraic and categorical structures like Functor, Monoid, Monad, etc.
Hopefully instantiated in programs in ways which actually do obey the laws of
those structures.

## I/O in Haskell

Performing I/O in non-strict (or lazy) languages is problematic due to out-of-
order execution. Such techniques as common sub-expression elimination, dead
code elimination, etc. will, when applied to code performing I/O can change
the semantics.

1. Potential solutions which destroy purity were unacceptible:

- Prohibit code transformations like these (which we'll need to optimise and
  compile efficient code).

- Enforce strict evaluation ordering.

Instead: stay pure, maintain local reasoning, etc.

2. Stream-based or CPS

    readName :: [Response] -> ([Request], String)
    readName ~(Str fn : ~(Str ln : _))
      = ( [ReadChan stdin, ReadChan stdin]
        , fn ++ " " ++ sn)

Then, continuation passing style:

    readName :: FailCont -> StrCont -> Behaviour
    readName abort succ
      = readChan stdin abort (\fn ->
      	readChan stdin abort (\sn ->
  		succ (fn ++ " " ++ sn)))

But this is hideous and hard to write and debug.

3. Use the properties of I/O

A function which performs I/O accepts some arguments and produces a result,
just like a pure function, but *also* takes a state-of-the-world and produces
a new state-of-the-world. 

Eugenio Moggi ("a hardcore theory person, and a nice person too") noticed that
this structure is, essentially, a monad. Wrote a paper on computation and
monads.

Philip Wadler translated from the category theory to the lambda calculus
(embodied in Haskell).

> Monads, Functors, Monoids, etc as API patterns.

# Case study

Goal to exploit the parallelism of commodity hardware (mobile phones, desktop
computers, and the like). Performance is important, but productivity is more
important: semi-automatic parallelisation; no explicit concurrency (writing
locks, etc).

Use three kinds of properties:

1. Types (being in Haskell)

2. State minimisation (can't eliminate)

3. Combinator libraries and embedded languages

Example: sparse matrix / vector multiplication.

Use types to ensure purity which, in turn, ensures non-interference between
computations. Only pure computations are safe to automatically parallelise.

Repa and Accelerate beating (sequential) C program.

To achieve high performance we need to generate quite C-like code (unboxed,
mutable arrays; C-like loops) but want to maintain a pure interface for
maintainability, etc.

Hiding local state within the API (combinator library) makes it possible to
have this C-like implementation *inside* the pure abstraction.

Massively parallel architectures like GPUs (24k threads). No divergence
(conditionals), recursion, function pointers, garbage collection. Haskell will
not be able to target these architecures any time soon. Instead, embed a
language for expressing computations in this model within the large language.
This also lets us adapt implements of this embedded language to specific
hardware.

> Functional software development is property-driven development.
