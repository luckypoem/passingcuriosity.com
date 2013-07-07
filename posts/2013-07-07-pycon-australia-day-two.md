---
layout: post
title: PyCon Australia 2013, Day Two
tags: python, conference
location: Hobart, Tasmania
excerpt: 
  These are my notes from day two of PyCon Australia 2013 in Hobart, Tasmania.
---

I'm attending [PyCon Australia 2013][1] in Hobart, Tasmania. [DjangoCon
Australia 2013][dca] and [day one of PyCon Australia 2013][pca1] were both
fantastic, and I expect today to be just as good. I'll try to update this post
over the course of the day. Not real live blogging, more delayed telecast
blogging.

[1]: http://2013.pycon-au.org/
[dca]: /2013/pyconau-and-djangoconau/
[pca1]: /2013/pycon-australia-day-one/

I'm typing these notes during the sessions, so there may be errors and
omissions. Any such problems are my fault and not that of the speakers.

[Today's programme](http://2013.pycon-au.org/programme/schedule/sunday) is
pretty much jam packed with interesting-looking talks. You'll be able to find
videos of all the talks on [pyvideo.org](http://pyvideo.org/) eventually.

# Tennessee Leeuwenburg on Sharing stuff with Python

My notes on this talk are not as coherent as I'd like. You'll be better off with
the video when it is available.

A recent study at Cambridge found the global cost of debugging software is $312
billion per annum.

## Evolution

> The differences between zebras and donkeys aren't just chrome. There's no way
> to get from zebra to donkey.

Distinction between genotype and phenotype; "wild type" of phenotype persisting
over generations? I should do some reading and clear this part up.

The lines on a phylogenetic tree are "work" in the sense that some effort needs
to happen to make transitions.

The common perception that decisions made at the start of a project are cheap or
free is a myth; we don't have visibility on requirements, etc. that will allow
us to make such decisions.

## Don't believe everything you think

Teams of people working together.

Role as manager is to bring the whole "thing" together, but plagued by the sense
that doing wrong thing.

There's always a reason for things: new to role, Dunning-Kruger effect.

> In order to assess competence, you have to be competent. Not in a general
> sense of being smart, or a good person: specific expertise in the domain at
> hand.

## Film

[Film about motivation at work](http://www.youtube.com/watch?v=u6XAPnuFjJc) by
RSA Animate. MIT study of challenges with 3 levels of rewards. Rewards are
effective for purely mechanical tasks, but larger rewards led to poorer
performance in tasks with more than rudimentary cognitive complexity.

Replicated in rural India with comparitively huge rewards. Has been replicated
over and over again.

Money is not an effective motivation beyond the level required to make it not a
constant focus. Real motivators are:

- Autonomy
- Mastery
- Purpose

How can we give our managers, our managees, our customers the control they all
need?

## A process

1. Information & input is interesting.
2. Synthesis & integration developers.
3. Change & moving on refocuses.

1-2) Reading and consulting
2-3) Acting bubbling producing
3-1) Accepting adapting inspecting

How does this map to some of the organisational psychology models I saw in a
talk at the Perth Agile meetup last year?

Disconnect between team members can arise from the position of each people
within the cycle; their existing background, knowledge, etc.

## Disconnection

- Motivation Disconnect
- Delusion of competence

## The manager disconnect

Two types of managers:

- the technical manager: support technical issues, perhaps with less ability to
  set directions, etc.

- the domain expert manager: perhaps disconnected from technical issues, "it's
  very simple".

Productivity of teams can be promoted:

- Diversity of team members can help to resolve local minima.
- Development of trust between team members, that each will contribute, etc.
- Performing as a group
- Equality of access to information
- Divide thinking and productivity across the team
- Individual productivity and flow

## Transparency of information

Transparency at all costs; giving people knowledge and visibility will develop
trust and let them let you do things.

[PyPy's Speed Center](http://speed.pypy.org/) lets users and community members
see the impact of work, trust that what's happening is important.

Using tools like iPython Notebook to allow people to examine/test/demonstrate
code; it helps to minimise the distance between us and them. Demonstrating
disagreement between data and models, giving evidence which lets them do their
scientist thing: it's not a competition. Making things tangible and concrete
allows diverse team members -- scientists, technologies, managers -- to
communicate effectively.

## Q&A

> You need to know what their charts look like & what their numbers look like.
> How to make them in matplotlib.

# Ed Schofield on Modern scientific computing and big data analytics in Python

Covering "big data" in more details than just as a buzz word; Python tools for
working with big data, etc; some examples on a running iPython Notebook server;
and some crystal-ball gazing.

Ed did a PhD in machine learn, then postdoc in bioinformatics; training and
consulting in using Python for related topics.

Most scientists and engineers are programming for 50%+ of their work time; as
self-taught programmers, many of them are using the wrong tools or in the wrong
way.

## Big Data

The nature of "big data" is somewhat relative but one, very practical,
definition is: data that is too large to fit in main memory.

Exponential decay in cost per GB of storage is driving data. 300m photos
uploaded Facebook per day; 86m CT scans in the US every year; average of 1
minute of driving by UPS drives is an $86m saving.

Predictive analysis is easy with big data, harder with medium data, small data
is hard. Having more data makes learning easier, more effective, etc.

With big data, it's impractical to move the data to the code; we have to send
code to the data.

Trend in clock speeds levelling off.

EC2 instances cost 1/320th the cost per time unit of a human's time. This gap
will continue to grow.

Parallelisation with MapReduce, etc.

MapReduce isn't suitable for iterative algorithms. Other models include Spark
(Erlang, from somewhere in the UCA system).

Noise reduction, signal processing (image super-resolution), prediction,
clustering (unsupervised learning), classification, compression (JPEG). 

## Python 3

Pretty much the entire stack of scientific Python libraries work on Python 3.3
but a few are missing:

- scikit-learn
- PyTables is only alpha
- Numba is difficult
- RPy2
- statsmodels
- boto - needs help
- mrjob - mapreduce (uses boto)
- disco
- matplotlib basemap

## Big CPU

Big data is relatively new, but "big CPU" problems are not. Route finding (as in
Google Maps), circuit layout minimising power consumption, protein layout
prediciton. The field of high-performance computing intersects with that big
data.

Traditional high-performance computing was based on proprietary platforms with
much nicer reliability properties than commodity hardware. HPC has a lot of
issues which traditional platforms don't: synchronisation, communication,
disparity of access to memory, etc.

Using proper tools can ammeliorate some problems: using BLAS libraries avoids
GIL problems (for the BLAS computations, at least).

Parallel iPython.

[Apache Hadoop](http://hadoop.apache.org/) is a big, complex Java system for
distributed computing. Using the `mrjob` library makes interacting easy.

Most of the world's supercomputers spend most of their time running Monte Carlo
simulations; not necessary to use MapReduce framework, but can help.

- UK real-time traffic data.
- DB of 20 million songs.

Running an `mrjob` computation is easy to scale:

	# Single process on local machine
	python word_count.py input.txt

    # Parallelised on local machine
	python word_count.py input.txt -r local

	# Parallelised on EC2
	python word_count.py input.txt -r emr --conf-path=aws-details.yml

## NumPy

- NumPy forms the cornerstone of scientific computing in Python.

- PANDAS provides a high-level interface.

- SciPy fills the "numerical recipes" role.

Other important projects include

- NLTK for natural language processing.

## Examples

- London olympics metal tally
- Landsat satellite imagery

Password: 118490219357

Next verison of iPython will include nbconvert.py which can generate a PDF from
a notebook file. Support for displaying as a slideshow.

iPython Notebook with PANDAS to load olympics medal tally data from CSV, then
filter and plot it.

Parallelisation within iPython starting a cluster and using the `%px` magic.

NumPy using native BLAS libraries will parallelise automatically. Example of
matrix inversion with htop so we see all the cores doing work.

Signal processing with gaussian and other kernels. Image reconstrution, using
FFT to detect and remove periodic noise in an image.

See the videos for the sklearn notebooks.

SciKit Learn examples

	samples = get_some_data_from_somewhere()

	# Separate the labels from the data
    y = samples[:, 0]
	samples = samples[:, 1:]

	# Fit a model
	clf = LinearSVC()
	clf.fit(samples, y)

> [Replaced my thesis with 6 lines of Python.][scipytweet]

[scipytweet]: https://twitter.com/dannipenguin/status/353691225846579201

## Where to now?

If you're at the sprints, why not help port scikit-learn to Python 3?

Kaggle run machine learning competitions and provide real data sets for
research. One example is smart metre data and identifying electrical
appliances. 

1.3 GB of bird audio recordings (also Kaggle).

## Q&A

Is `mrjob` the best of the similar libraries?

> Some of the other libraries offer more powerful 
> 
> It seems to be the easiest to set up and get working with. 

How easy is it to get the parallelisation working out side of iPython Notebook?
How easy is it to use iPython and iPython Notebook to load and explore an
existing code base?

> I don't think there's any need to use the iPython interface, but it should
> all work so long as you have it installed and setup.
>
> You can load and run existing code with the iPython magic commands. Tend to
> use iPython Notebook in the same way as a REPL.

What's the Sydney course like?

> Working with these tools and actually doing exercises, etc.

What packages should we be using to plot and visualise data, etc?

> Almost certainly matplotlib.

Would you use PANDAS for CSV data and NumPy for gridded data (with no sensible
labels)?

> Yes probably easier to use PANDAS to get data in, even if you just want the
> NumPy data.

Tools for processing logs and such?

> scipy.stats and statsmodels

Numeric libraries?

> Intel math kernel library or, on Mac, Apple's veclib.

# Richard Jones on Don't Do This

Poking around in some of Python's strange corners and find some things that you
probably shouldn't do.

## Corner cases of the grammar

Mixin classes: base classes can be an expression:

    class Foo(JSON or Marhsal):
		pass

So can exceptions:

    catch eval('NameError'):
		pass

If you use a generator here, you can catch *some* exceptions (like the webscale
logging in MongoDB).

## Mutability

The `__code__` attibute on a function object contains the code of a function.
It's a mutable attribute so you can change it.

Modules have a `__code__` attribute too (the .pyc files are just mashalled the
`__code__` attribute marshalled).

Parse XML document, generate AST, compile the AST. Add a finder, loader, etc.
and you can now load modules written in `.pyxml` files. Can be used to implement
E/DSLs, macros, etc.

`locals()` and `globals()` give you a handle to a dictionary of the appopriate
scopes. Using `inspect.currentframe().f_back.f_locals.update()` to dump crap
from JSON into a scope.

The `__bases__` is also mutable. Just change your mixin at runtime.

ContextManagers to do namespacing. And do useful things like make every
variable in your scope global.

The [`q`](http://pypi.python.org/pypi/q package will dump an expression and
it's value into `$TMPDIR/q`. Inspects code at locations in the callstack to
tell whether it's being called as a function or decorator.

Type-based overloading a la Java with the `overload` package. Allows you to
overload functions and methods and classes and such. Uses introspection on
things like `__defaults__`, `__code__.co_argcount`, `__code__.co_varnames`,
`__annotations__` (for types), `__code__.co_flags` (for `*args` and `**kwargs`).

Back to `q`:

    import q; q(foo)

But modules aren't callable. Replaces the module in `sys.modules['q']` with a
class; but the module gets garbage collected so `Q` does a lot of stuff to make
things work (imports in class defn, etc.) Instead, make modules callable!

Callability is handled in the C types code. There's a member in a C structure
which points to the "call" function which can run the callable object. Use the
`ctypes` module to get C function points, reach into the type structure.

Do other things to built-in types with `ctypes`. See `forbiddenfruit` which can
add stuff like `days()` to `int` so you can be more rubyish:

    int(12).days().ago()

## Q&A

With great power comes great responsibility.

> A lot of these things have been added to the language over time. They are
> very powerful and, sure, you can do stupid things with them but it's genuinely
> useful too.

# Brianna Laugher on Dynamic visualisation in the IPython Notebook

Slides and material available at [github.com/pfctdayelise/dapbook][blgh]. Using
iPython Notebook with matplotlib plotting, e.g, gridded data and rendering it
on WMS maps.

[blgh]: https://github.com/pfctdayelise/dapbook

iPython Notebook has a rich display system, this is essentially different
versions of `__repr__`: just add a `png()` `@property` method to your classes
which returns an iPython `Image`.

Using Leaflet and OpenLayers to display map. [PyDAP](http://www.pydap.org) to
access data from a DAP server when it's needed. Can input and output a bunch
of formats (including WMS so it can be used as a map layer).

PyDAP only produces WMS output in the EPSG:4326 projection (not the normal
online projection). You need to find a matching baselayer.

Code we need to hook all this up and display it in iPython Notebook. About 30
lines of Python, need to put it in an iframe w/ b64 encoded source (iframe for
JS isolation; b64 or, if external, just URL).

See also: [github.com/nfaggian/leafvis](htts://github.com/nfaggian/leafvis).
