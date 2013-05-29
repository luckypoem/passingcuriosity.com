# Data, Visibility, and Abstraction - Development Using Clojure

QBASIC - distinction between subroutines (no return value) and functions
(return value). Invoking a subroutine is a statement, invoking a function is an
expression. Separation of effects and computations. Yay!

"Teach Yourself C++ in 21 Days" Turns out you can't abstrusegoose.com/249.

Perl, the QBASIC of Linux (on Linux automatically). Great documentation (no
need for Teach Yourself X in 21 Days. Universal set of data structures:
scalars, hashes, arrays.

Homoiconicity

Perl's ties make a datastructure as an interface to something else (Tie::File
for an array of lines in a file).

XML - really just a way of representing data; by itself it didn't do anything.
Write an XML document describing what to do, then a perl program to interpret
the script. First inklings of the lisp-ish way. But perl isn't very XML-ish,
so XSLT.

XSLT is homoiconic - XML programs to process XML. A bit functional:

* No arbitrary assignment to variables (SSA).

* Representing a program as data transformation.

Couldn't (figure out how to) get XSLT to call itself; hence shell scripts
invoking multiple XSLTs.

Common Lisp. The Quagmire of Convenience - many, many libraries which each
define a few macros; every open source library written in a slightly different
language.

No common idea of universal data structures (other than lists); no literal data
structures (other than lists); lists are *only* lists, no using the list
interface for other data structures. Clearly the world needed bridge for
perl/common-lisp (so he wrote one, literate style). This was too much heresey
for the Common List community.

After college: 'programming', therefore making websites, therefore RoR and
Ruby. Found that the language was *too* flexible; in Perl anything that was
code looked like a function. Tendency for libraries to extend the language for
their purposes (EDSL - more of a pidgin than a "language"). Hpricot using `/`
for "search in a document.

Clojure - lisp with the data structure functionality missed from perl. Also
richer: map as function from keys to values; universal sequence API (map over
almost anything) - a single language for working with everything.

But found himself mixing computation with effects (launching missiles and
erasing hard drives). Seperating computation and effecting; somethings a little
longer: pipeline of computation building up knowledge leading to an effectful
finale.

	(defn complex-process [inital-state]
		(-> initial-state
			gather-information
			make-decision
			take-action))

This is a great structure for web apps, but what's the best way to structure
these programs?

Interceptors reify the layering of a web-app architecture. It's a pair of
functions which process the request going in and the response coming out of the
application (middleware). Lets you do asynchonous by saving these data
structures (not just a pair of functions then).

http://pedestal.io/

Reify the model and *changes* to the model. This can be pumped through to
clients which, at the end, side-effect the DOM in the browser. Data-flow
engine is portable; develop and test on JVM, deploy into browser.

Ports and adaptors ("hexagonal architcture") with pure application in the middle
surrounded by adaptors hooking it up to databases, GUIs, web services, etc.

Reifying processes: [Hystrix](http://github.com/Netflix/Hystrix) to isolate code
to prevent interference between components of the system.

How to deal with processes (components with state, etc.) more generally. Many
libraries have some sort of imperative `init!` function to "rally the troops",
initialise global state. Leads to tedium in the REPL when having to restart the
JVM to clean up these libraries.

Reify the state of the system? Define a record which contains the various bits
of state (or, at least, routines to manage the state) and protocols to operate
the system. Or make something that looks more like a function?

1. Design programs to manipulate data

2. Separate ?

3. Reify
