---
title : Practical Go Programming
---

Andrew Gerrand from Google talking about some aspects of the Go programming
language. Worked on Go since the initial release.

About Go
========

Open source (BSD) general programming language. 10-20 non-Google contributors.

* Simple
* Lightweight syntax
* Compiled to native 32- and 64-bit Intel and ARM
* Statically typed
* Memory managed
* Concurrent
* Fast (compiled code and compilation itself)
* About a year old

Design tenets
-------------

Simplicity and orthogonality of features - each is understandable in itself,
and doesn't interfere with others.

Readability and usability for programmers - should require little context to
understand a piece of code and few decisions about design and structure before
you begin programming.

Type System and Package System
==============================

Go is OO but doesn't have:

* Classes (no abstract, static method or vars, protected, sub-type
  polymorphism)
* Explicit interfaces
* Constructors
* "this"

Based on built-in types: int, float, complex
bool, string, structs
pointers, arrays, slices, maps
channel, function, interface

Definitions can give names to any of these:

    type Year int
    
    type Person struct {
      Name string
      BirthYear Year
    }
    
    type PersonList []*Person // a slice of pointers to Person

You can declare methods on any named type.

    // func (recv) method() return
    func (y Year) Stardate() int {
      return y * 13
    }
    
    func (p Person) Age() int {
      now := time.Nanoseconds() / 1e9 / (60*60*24*265)
      return int(now) - p.BirthYear
    }
    
    fun (l PersonList) Eldest() Person {
      // ...
      return p;
    }


Interface Types
---------------

Interface types define behaviours by defining an method list. Any type which
implements all the methods can be used anywhere the interface is specified.

    type Abser intertface {
      Abs() float64
    }
    
    type Point struct {
      x, y float64
    }
    
    func (p Point) Abs() float {
      //..
    }
    
    func (a Abser) Blah() float64 {
      a.Point()
    }

Library interfaces like

    type Reader struct {
      Read(p []byte) (n int, err os.Error)
    }

Tar package `NewReader` takes a `Reader` and returns a new `Reader` (also in
the interface).

Packages
========

Largest unit of code is package. Contains varibale, constant, function, type
methods. Within functions also have variables, constants, functions and types.

Everything works the same in either scope (and only the two scope levels).

Packages groups conceptually related things in a single namespace, can be
split in multiple files.

Uppercase initial letters mean "public" everything else is private.

Top-level package is "main", no circular dependancies.

archive/tar consists of three files: 

- `reader.go` - Reader, NewReader, Error values, un-exported implementation
  details.

- `writer.go` - 

- `common.go` - Header type, common code used in both.

Exported/un-exported is completely orthogonal to the kind of object (var,
func, etc.)

Natural and easy to change things after implementation.

Going to "just works" to production ready usually doesn't require major
surgery.
