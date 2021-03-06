---
title: Ontology in the Elements of Programming
tags: reading, books, programming, ontology, types, values
location: Sydney, New South Wales
excerpt: 
  I'm making another attempt at reading the Elements of Programming. Here is
  a quick overview of the ontology of types and values described in the first
  chapter.
---

The [Elements of Programming by Alexander Stepanov and Paul McJones][1] is
a book about grounding programming on mathematical foundations like other
scientific and engineering disciplines. The book begins by describing an
ontology of types and values and describing the way these are represented in
C++ programs. While reading chapter one I drew several diagrams of the
relationships between the various concepts described so here they are.

# Entities, species, and genera

The first set of concepts are *entity*, *species*, and *genera*, which are used
in roughly the same way as they are in biology. Unlike biology, each comes in
both *abstract* and *concrete* varieties.

-----------------------------------------------------------
  Concept   Abstract                        Concrete
----------- ------------------------------- ---------------   
  Entity    blue, 13                        Socrates, USA

  Species   colours, natural numbers        man, US State

  Genera    numbers, binary operators       mammal, biped
-----------------------------------------------------------

Table: Examples of abstract and concrete entities, species, and genera.

The link between the concrete and the abstract is made by *attributes*. An
attribute maps some concrete entity to some abstract entity. The "eye colour"
attribute, for example, maps the concrete entity "Socrates" to the abstract
entity "blue" and the "number of states" attribute maps the concrete entity
"Australia" to the abstract entity "6".

Along with their attributes, concrete entities - which exist in the world and
can change over time - also have an *identity*. The Haskell programmer in me
makes me a little sceptical of semi-mystical [haecceities][2] like this;
I can't help wondering if it's been introduced here to give a convenient
justification for things like pointer equality when the authors start applying
all this in C++.

![Concrete and abstract entities, species, and genera][f1]

# Values, value types, and objects

This is all very well and nice, but whither programming? Having established
entities, species, and genera, section 1.3 introduces the concepts value, value
type, and object. 

A *datum* is a particular finite sequence of bits. By itself a *datum* is
completely meaningless but we can associate an entity and a datum to form
a *value*. We say that the data is the *representation* of the value and the
entity is its *interpretation*. Note that we're talking about a value being
composed of an entity and bit sequence and, therefore, that these values are
ideals, not things we have in our programs.

![][f2]

Where values correspond to the entities the previous section, *value types*
correspond to species: a value type associates a species with a set of values.
This association has a number of properties:

- it is partial when only some entities in the species have corresponding
values or total otherwise;

![][f3]

[1]: http://www.amazon.com/dp/032163537X/
[2]: https://en.wikipedia.org/wiki/Haecceity

[f1]: /files/2015/ontology-of-elements-of-programming/entities.png
[f2]: /files/2015/ontology-of-elements-of-programming/values.png
[f3]: /files/2015/ontology-of-elements-of-programming/value-types.png
