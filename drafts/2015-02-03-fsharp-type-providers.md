---
title: F# Type Providers
strapline: Learning about type providers at my first Sydney F# meetup
tags: fsharp, functional programming, meetup, event
location: Sydney, New South Wales
excerpt: 
  The Sydney F# meetup February meeting had a talk about type providers in
  February, so I went along.
---

I saw a few talks featuring F# type providers at ICFP last year and, for
some reason, thought it might be a nice idea to write a type provider
for the Vaultaire time series store. With that vague mission still in
the back of my mind months later, I attended my first [Sydney F#
meetup][meetup] to see a [presentation][pres] about type providers.

[meetup]: http://www.meetup.com/fsharpsydney/
[pres]: http://www.meetup.com/fsharpsydney/events/206069082/

Community news:

- There's some sort of F# introduction workshop coming soon (w/ online materials);
- Lots of open-sourcing from Microsoft;
- Discussion of "Your server as a Function" in F# (http://ghuntley.co);
- Some other blog posts and such;
- F# Show podcast (notebook beaker);

Talk
====

Aaron Powell works for Readify, predominately writes JavaScript.

Implemented the `|>` operator using Suite JS -- a macro language on top of
JavaScript.

https://github.com/aaronpowell/DisappointinglyAttributed
````
[<TypeProvider>]
type SampleTypeProvider(conf: TypeProviderConfig) as this =
  inherit TypeProviderForNamespaces()

  let namespaceName = "Sample.TypeProvider"
  let thisAss = Assemply.GetExecutingAssembly()

  let makeProvided (n: int) =
    let t = ProvidedTypeDefinition(thisAss, namespaceName, "Type" + string n
        , baseType = Some typeof<obj>)

    t.AddXmlDocDelayed(fun () -> sprintf "This provided type %s" (string n))

    let staticProp = ProvidedProperty(...)

    t

  let types = [ ... ]

  //
  do this.AddNamespace(namespaceName, types)
````

Then you can use it like so:

````
type foo = Sample.TypeProvider("lol")

let f1 = foo()
let f2 = foo()
````

Types (and their values) generated by a type provider gets type-checking, etc.
but also auto-completion, documentation, etc. Looks pretty much like Template
Haskell but very reflection-y and with lots and lots of integration into the
IDE.

> Scroll bars on the Window system bar thing! Lol

## Tips

Generate a `Load` method to, e.g., load the real file of the appropriate format
of the sample data used at compile time.

```
type Foo = FSharp.Data.JsonProvider<"""{"Id":"...","Name":"..."}""">
```

