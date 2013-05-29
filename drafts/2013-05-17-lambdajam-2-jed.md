# Connection Management: FP Style

The problem:

- Doing statistical analysis (performance metrics, etc.)
- Doing the heavy lifting in R.
- Manage this external process
- Connect to external process.
- Connection is stateful.

Experimented with traditional approaches, but weren't happy with it.

## First Attempr

Imperative.

- Connection - eval(String) : REXP; close().
- Server

Pretty painful, manage server and connection manually; connection closing is
problematic. Hard to implement pooling and other optimisation techniques.

## Second

Loaner

- Connection - eval
- Server - withConnection(f : connection -> a): a

Still need to manage servers, but quite difficult to compose them.

Still hard to implement pooling, etc.

## Third

Implicits (because, hey, Scala, right?)

Still requires clients the manage connections, often done poorly; this shouldn't
be the client's concern.

# Requirements

Execute code with an externally managed and provided connection.
Compose small programs into larger programs.
Programs should not  have to manage object lifecycles.
Provide centralised management of them.

Built a Reader monad over a connection type. This is the monad of function
application of an environment. Sub-computations can be fed altered envs. The
env is a connection.

# Connections

- Program = Reader[Program]

mean(x) :Program[Double] = native("mean", x) flatMap toDouble
stdDev(x) : Program[Double] = ... native("sd", x) flatMap toDoublw

meanAndDev(x) = for { m <- mean(x)
	sd <- stdDev(m)
	...}

# Compile

	compile(prog) = IO {
		for {
			server <- Server.stat()
			res <-
				try server exec program
				finall server.stop()
	    } yeild result
	}

Can do a pooled version of compile() easily.

# Problems

Still have to deal with error handling. Stack overflows (tail calls, etc.)

## Error Handling

ADT to handle errors. Eitherish thing to represent results (error or result).

## Stack

Use trampolining to turn tail-recursive programs into non-tail-recursive. Use
`scalaz.Free` monad to do this.

## Monads

- Either
- Free
- Reader

As we all know, monads don't compose. (That is, working with multiple monads
don't work.)

Use monad transformers.

- ReaderT[R[+_], -E, +A] = Kleisli[F, E, A]

# The stack

Lift the type:

	type Id[+X] = X

	type ResultT[F[+_], +A]= scalaz.EitherT[F, Invalid, A]

	-- Same as it was:
	type Result[+A] = ResultT[Id, A]

	// Partial applicaiton to reduce type variabls
	type FreeId[+A] = Free[Id, A]
	type Connected[+A] = ReaderT[FreeId, Connection, A]

	type Program[+A] = ResultT[Connected, A]

Now do things:

	def mean(x: Seq[Double]) =
		native("mean", x) flatMap toDouble


blah

	type Program[+A] = EitherT[ReaderT[Free[Id, A], Connection, A], Invalid, A]


# Why?

What was the point? Needed to manage complex state things in a way that was
sane: the programs should do the right thing automagically and it shouldn't need
much thinking about in clients. Yes, it was hard.

Took hours to get it to compile but, when it did, it worked perfectly first
time. MPJ didn't believe it was working (no crashes, no logging spewed, etc.)

# Notes

"+" means "covariant".
"_" means "type constructor".

Scala Machines for I/O; give it monoids to do stuff with. Instead of iteratees.
