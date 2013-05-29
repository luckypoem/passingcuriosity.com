---
title: Dave Thomas on VMs
categories: virtual machines, software engineering
tags: java, jvm, 
location: Sydney, New South Wales
excerpt: 
  Dave Thomas gave a talk about virtual machines.
---

[Dave Thomas](http://www.davethomas.com/) is giving the talk at the prompting
at a JVM group.

Real hardware is fast and cheap; real software is bloated and slow. We spend a
lot of time and money slowing down fast hardware. 10-100s of cores with limited
local memory. Toleria.

Virtualised hardware machines (vmware, virtualbox).

Language machines with hardware support for specific programming languages and
platforms (APL machines, lisp machines).

Virtual hardware machines. 

Programming languages
=====================

400+ PLs in 4 minutes.

> If you've not read SICP, please leave the room.

The *Contour Model of Block Structure Processes* models computation
diagramatically.

REPLs (evaluation of bindings) do all the things:

- Environment traversal to find things (method in an object language, ref in a
  lexical closure) is largely the same thing.

- Binding chains in Prolog.

- J - exactly the same as a scheme interpreter but with more powerful operators.

Language Virtual Machines
=========================

Justfied by the difficulty in writing good optimising compilers written for
targets before they become obsolete.

Security.

> We don't show garbage collection people in the picture because they're really
> weird.

VM engineering encompases:

- Architecture: Register vs stack machine.
- Instruction sets: CISC vs RISC. 7+/-4 instructions.
- Bytecode: typed (JVM) / untyped (CLR). vs AST interp.
- Typing: base types; structured.

Features required for lambda:

- Tail-recursion
- Closures
- Delegates
- Invoke-dynamic
- Pattern matching
- Call/CC - very difficult to build efficiently; very very difficult to
  retrofit.
- Reflection

Boxing and tags:

- Boxed languages, native machine types. No polymorphism (w. native types)
  without boxing.

- Polymorphics languages tend to use tag bits. They take up space in every
  value, and have to be checked.

Implementation

- Dog fooding. Reflective tower.

- Reflective tower, metaclasses.

- Like Wirth: wrote compiler, hand compiled.

- Interpreter, compiler, mixed, etc.

- Core libraries: in the language (ready for breaking; lots of pressure on
  JIT), in the VM (get very clever people to build the libraries into the VM).

Dispatch:

- vtables, dynamic lookup, dynamic translation (Transmeta). Inline the "normal"
  dispach case with a test (but the test is often `NO`).

- Polymorphic inline cache. (Use a cache instead of inlining a guess.)

- Runtime type feedback (Self, Strongtalk, then Hotspot). Use type information
  at run time to specialise dispatch in particular cases.

- Profile guided inlining (tracemonkey, PyPy, etc.) uses run-time collected
  information (performace, etc.) to focus optimisation and inlining effort. Can
  generate so much code (through inlining) that you break the cache.

- Whole program compilation and optimisation. Analyse whole VM programs and
  specialise them into inlined machine or C code.

GC:

- Mark/sweep: relatively easy

- Reference counting (only values, no pointers).

- Real time allocator for constrained envs (Buddy algorithm, 1950s). No
  compactions.

- Conservative GC (i.e. doesn't work) or precise GC (yes, this one).

- Generation Scavenging GC. Break memory into multiple spaces and mark/sweep
  each of them individually. Young objects die young. Write barrier to help
  manage pointers from old back into young generations.

Concurrency:

- Native/green threads.

- Context switches, etc.

- Green thread architecture: native thread per CPU, green threads on top of
  them. Fast, commonly used.

- Monitors and actors.

- Data parallelism.

- "Wasteland" between actors and data parallelism.

Benchmarks:

- Measure specific language features, generally provide no guide to application
  performance.
  
- Real performance is dominated by OS/DB, frameworks, GC racing (ORMs creating
  pointless instances) and cache busting by frameworks (dispatch and GC being a
  cache line apart, and evicting each other constantly).

VMs suit environments:

- Embedded or pervasive: constraints on power, memory; instant on, real time
  GC, native code interop.

- Client centric

- Server side: lots of cores and lots of memory.

Java still has a bunch of issues:

- Cloud is very hard when you have so much overhead per instance. Turn
  libraries into DLL/SO, share between instances.

- Scaling: GC of 2TB is much, much harder than 2GB.

- API change and compatability; `become` from lisp and smalltalk make it easier
  to evolve objects from class version to class version.

Challenges:

- Stack based is easy to get started, hard to build good JITs, etc.

- Stack inspection as a security mechanism is pretty much over.

- Discontinuities in hardware environments (many cores, large memory, etc.)

- LVM are always biased towards the L. You can run any language, especially
  mine.

- Is it possible to have a UVM with lets interesting languages run in the same
  model?

- Virtual instruction set machines. AS/400, Transmeta, AMD HAS (a target with
  shared memory CPU/GPU), Google PNaCl.
  
- Abstract machine w/ infinite registers; all instructions are reg to reg; has
  a single assignment model. Support many languages using technique of
  *software fault isolation*. JIT program from abstract machine to actual
  machine.

- Use LLVM

- Delivers safe, sandboxed code with 5-7% overhead on ARM/Intel for C/C++ code.


