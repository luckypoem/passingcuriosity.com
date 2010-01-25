Paul Bone

Automatic parallelism based on analysis phase at compile time.

ICFP 2000 Raytracer benchmark. Makes heavy use of GC, 6199 LOC, code altered
to make it less stateful. 

Mandelbrot image generator. Light GC. 280 LoC, written for test. Serial 139,
P=1 135, P=2 68, P=3 45, P=4 34.

Parallelisation will split smaller jobs off into threads. 

When GC stops the world, it uses the first thread to mark leaving the rest of
the thread caches fine. Using Boehm - designed for uncooperative environments.
Uses signals to stop the world.

Trickier cases
--------------

**Divide and conquer**

In quicksort, use conjunction `&` to parallelise sorting the partitioned sets.
This results in a fork on every recursive call graph node (i.e. non-leaf).

On average, this creates O(N) small parallel tasks. Far too many.

It's better to parallelise the first O(lof2P) levels of the tree, so the work
load is suited to the system.

**Specialisation**

If `foo` is expensive, we can parallelise `map` and pass it the closure of
`foo` to speed the job up.

If `bar` is fast and simple, a parallel `map` of the closure of `bar`, then
this will actually be slower.

If you can prove that an operation is commutative and associative, then you
can reorder it arbitrarily. Mercury has annotations to denote commutative and
associative computations. He'd like to use these to automatically parallelise
and, with appropriate locking, let the parallel threads race and the end
result will be correct.

Conclusion
----------

Parallel GC is an active research area. The raytracing example spends half its
time marking, using a parallel GC would likely make things better.

Other options under development.

Automatic parallelisation will make it easier.

Pure declarative languages make parallelisation much easier (and separate from
concurrency).

Questions
---------

Maybe do the profiling and automatic parallelisation a la JIT specialisation.
Profiling is currently per-workload.

The Mercury system uses a similar architecture to GHC: capabilities (called
engines in Mercury) and sparks and work stealing. Is this bette? Maybe do a
combined approach: make largish sparks at the top level, do conditional
sparking in the middle of the call tree (don't bother if you've already got as
many big bits as engines).

Don't currently model communication cost to make parallelisation decisions.
The rational is to avoid parallelisation if the costs of parallelising the
work will overwhelm the performance increase. Work stealing, though, should be
looking for work from nearby components.