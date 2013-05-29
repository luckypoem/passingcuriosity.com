Ambrose Bonnaire-Sergeant @ambrosebs from UWA talking about gradually typed
Clojure.

One of the hard [social] problems is choosing which language to use. Part of
this is the typing regimen supported by a language. Gradual typing mixes both
dynamic and static typing in the same language and the same program. 
Essentially:

- untyped language with annotations.
- semantics for the interface between typed and untyped code.

Examples include:

- Typescript

- Typed Racket - wraps all untyped code in dynamically enforced contracts.
  Includes blame tracking to help determine where (higher-order) untyped code
  causes problems in static code.

Clojure is a dynamically typed-language; it's a lisp, so you can mess with the
language innards easily. `core.typed` implements gradual typing for clojure and
does static checking only (no contracts).

Adding better error detection and handling to the language:

- Detect [type] errors earlier. i.e. at compile time.

- Provide more descriptive errors, rather than a Java stack trace at runtime.

The type system was designed to be statically sound. Other languages aren't: 
Java's arrays are co-variance; Typescript functions are covariant in argument; 
Dart has array co-variance. Pragmatic, blah, blah, blah.

core.typed is designed to be a test bed; lots of inspiration (and cross 
pollination) from typed racket. Experimenation on interesting problems:

- What if there was a null type (a la `Option` or `Maybe`) on JVM?

- Multimethods are very general in Clojure and difficult to typecheck.

- Array covariance.

# Annotations

Start typechecking Clojure code by adding annotations.

- All top-level variables must be annotated.

- All local function parameters. (Only return types are inferred.)

- Some special forms have "typed" versions which are done with macros.

    ;; Annotation for a function. `Fn` is the type of a function; it's
    ;; arguments are types from args to results.
    (ann my-fn (Fn [Number -> Number]
    	       	   [Symbol -> Symbol]
		   [Boolean -> Keyword]))
    (defn my-fn [a]
      ...)

Programmers shouldn't need to change their code (structure, algorithm, etc.)
to please the type checker.

# Optional

Type checking is separate to compilation and is implemented as a function. It's
up to the programmer to use this when they want their code (a name space) to be
type checked.

*Occurrence* typing to update the type of bindings in conditional statements. 
So branches will know that the parameter being dispatched on is, e.g., a 
symbol. Can use this for some of the uses of dependant typing (sequence 
length).

    (cond
      (symbol? a) ...
      (number? a) ...
      :else ...)

*Variable-arity polymorphism* allows core.typed to specify types for lisp-y
one-or-more-arguments functions.

    (map + a)
    (map + a b c d e)

*Java interoperation* allows you to assert properties of Java-y bits (e.g.
nullness or non-nullness of return values from specific methods).

