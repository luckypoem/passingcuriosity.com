---
wordpressid: 389
layout: post
title: Accessing SQL databases with Haskell -- HSQL
wordpressurl: http://passingcuriosity.com/?p=389
---
(Or "Connecting to SQL databases with Haskell" as per DoeL's suggestion, it was getting a bit long)

As the first step on my journey into web-development with Haskell, I'm looking
at interfacing with SQL databases. While there are a number of options
available, only a few of them are currently maintained and none are usable (as
I write this) out of the box using the current stable release of GHC. Given
that it's a little bit of work to get going, that it's raised with some
regularity on the Haskell mailing lists, and that if I don't write it down,
I'm liable to forget, this post will describe accessing SQL databases
using the `HSQL` package and one or more of its driver packages.

This post is literate Haskell ([download the original](/files/2008/12/using-hsql.lhs)) and was tested with GHC 6.10.1.

<!--more-->

First, I'd like to note that there are plenty of other tutorials and
explanations and snippets out there in Intertubes land and there's nothing
really special about this one. If you have any suggestions for improvements or
"better" ways, please comment or track-back away. With that said, lets get down
to accessing some data.

After you've managed to get HSQL and the driver package for your database
installed (if you run into trouble, see the links at the end of this post), 
everything else is reasonably straight-forward. You simply import the HSQL
package and whichever drivers you need (I've used SQLite3, MySQL, and
PostgreSQL):

<pre><span class='varop'>&gt;</span> <span class='keyword'>import</span> <span class='conid'>Database</span><span class='varop'>.</span><span class='conid'>HSQL</span> <span class='keyword'>as</span> <span class='conid'>Hsql</span>
<span class='varop'>&gt;</span> <span class='keyword'>import</span> <span class='conid'>Database</span><span class='varop'>.</span><span class='conid'>HSQL</span><span class='varop'>.</span><span class='conid'>SQLite3</span> <span class='keyword'>as</span> <span class='conid'>SQLite</span>
<span class='varop'>&gt;</span> <span class='keyword'>import</span> <span class='conid'>Database</span><span class='varop'>.</span><span class='conid'>HSQL</span><span class='varop'>.</span><span class='conid'>MySQL</span> <span class='keyword'>as</span> <span class='conid'>MySQL</span>
<span class='varop'>&gt;</span> <span class='keyword'>import</span> <span class='conid'>Database</span><span class='varop'>.</span><span class='conid'>HSQL</span><span class='varop'>.</span><span class='conid'>PostgreSQL</span> <span class='keyword'>as</span> <span class='conid'>PgSQL</span>
</pre>
along with a few more for utility functions:

<pre><span class='varop'>&gt;</span> <span class='keyword'>import</span> <span class='conid'>IO</span> <span class='layout'>(</span><span class='varid'>try</span><span class='layout'>,</span> <span class='conid'>IOMode</span><span class='layout'>(</span><span class='keyglyph'>..</span><span class='layout'>)</span><span class='layout'>)</span>
<span class='varop'>&gt;</span> <span class='keyword'>import</span> <span class='conid'>System</span><span class='varop'>.</span><span class='conid'>Environment</span> <span class='layout'>(</span><span class='varid'>getArgs</span><span class='layout'>)</span>
<span class='varop'>&gt;</span> <span class='keyword'>import</span> <span class='conid'>Data</span><span class='varop'>.</span><span class='conid'>List</span> <span class='layout'>(</span><span class='varid'>elemIndex</span><span class='layout'>)</span>
<span class='varop'>&gt;</span> <span class='keyword'>import</span> <span class='conid'>Control</span><span class='varop'>.</span><span class='conid'>Monad</span> <span class='layout'>(</span><span class='varid'>mapM_</span><span class='layout'>,</span> <span class='varid'>liftM</span><span class='layout'>,</span> <span class='varid'>guard</span><span class='layout'>)</span>
<span class='varop'>&gt;</span> <span class='keyword'>import</span> <span class='conid'>Network</span><span class='varop'>.</span><span class='conid'>URI</span> <span class='layout'>(</span><span class='varid'>parseURI</span><span class='layout'>,</span> <span class='varid'>uriScheme</span><span class='layout'>,</span> <span class='varid'>uriPath</span><span class='layout'>,</span> <span class='varid'>uriAuthority</span><span class='layout'>,</span> 
<span class='varop'>&gt;</span> 	<span class='varid'>uriUserInfo</span><span class='layout'>,</span> <span class='varid'>uriRegName</span><span class='layout'>)</span>
</pre>
and you can connect to the databases. Each of the different database driver
packages implements it's own `connect` function. The SQLite3 `connect` is
simple: just pass it the name of the database file and the mode to open it:

<pre><span class='varop'>&gt;</span> <span class='varid'>connectSQLite3</span> <span class='varid'>name</span> <span class='keyglyph'>=</span> <span class='keyword'>do</span>
<span class='varop'>&gt;</span> 	<span class='varid'>tryconn</span> <span class='keyglyph'>&lt;-</span> <span class='varid'>try</span> <span class='varop'>$</span> <span class='conid'>SQLite</span><span class='varop'>.</span><span class='varid'>connect</span> <span class='varid'>name</span> <span class='conid'>ReadWriteMode</span>
<span class='varop'>&gt;</span> 	<span class='varid'>either</span> <span class='layout'>(</span><span class='keyglyph'>\</span><span class='varid'>err</span>  <span class='keyglyph'>-&gt;</span> <span class='varid'>fail</span> <span class='str'>"Could not connect to database"</span><span class='layout'>)</span>
<span class='varop'>&gt;</span> 		<span class='layout'>(</span><span class='keyglyph'>\</span><span class='varid'>conn</span> <span class='keyglyph'>-&gt;</span> <span class='varid'>return</span> <span class='varid'>conn</span><span class='layout'>)</span>
<span class='varop'>&gt;</span> 		<span class='varid'>tryconn</span>
</pre>
Connecting to server-based databases is a little more complex, but essentially
identical for both MySQL and PostgreSQL:

<pre><span class='varop'>&gt;</span> <span class='comment'>-- | Connect to a MySQL database</span>
<span class='varop'>&gt;</span> <span class='varid'>connectMySQL</span> <span class='varid'>host</span> <span class='varid'>db</span> <span class='varid'>user</span> <span class='varid'>pass</span> <span class='keyglyph'>=</span> <span class='keyword'>do</span>
<span class='varop'>&gt;</span> 	<span class='varid'>tryconn</span> <span class='keyglyph'>&lt;-</span> <span class='varid'>try</span> <span class='varop'>$</span> <span class='conid'>MySQL</span><span class='varop'>.</span><span class='varid'>connect</span> <span class='varid'>host</span> <span class='varid'>db</span> <span class='varid'>user</span> <span class='varid'>pass</span>
<span class='varop'>&gt;</span> 	<span class='varid'>either</span> <span class='layout'>(</span><span class='keyglyph'>\</span><span class='varid'>err</span>  <span class='keyglyph'>-&gt;</span> <span class='varid'>fail</span> <span class='str'>"Could not connect"</span><span class='layout'>)</span>
<span class='varop'>&gt;</span> 		<span class='layout'>(</span><span class='keyglyph'>\</span><span class='varid'>conn</span> <span class='keyglyph'>-&gt;</span> <span class='varid'>return</span> <span class='varid'>conn</span><span class='layout'>)</span>
<span class='varop'>&gt;</span> 		<span class='varid'>tryconn</span>
</pre>
<pre><span class='varop'>&gt;</span> <span class='comment'>-- | Connect to a PostgreSQL database</span>
<span class='varop'>&gt;</span> <span class='varid'>connectPgSQL</span> <span class='varid'>host</span> <span class='varid'>db</span> <span class='varid'>user</span> <span class='varid'>pass</span> <span class='keyglyph'>=</span> <span class='keyword'>do</span>
<span class='varop'>&gt;</span> 	<span class='varid'>tryconn</span> <span class='keyglyph'>&lt;-</span> <span class='varid'>try</span> <span class='varop'>$</span> <span class='conid'>PgSQL</span><span class='varop'>.</span><span class='varid'>connect</span> <span class='varid'>host</span> <span class='varid'>db</span> <span class='varid'>user</span> <span class='varid'>pass</span>
<span class='varop'>&gt;</span> 	<span class='varid'>either</span> <span class='layout'>(</span><span class='keyglyph'>\</span><span class='varid'>err</span>  <span class='keyglyph'>-&gt;</span> <span class='varid'>fail</span> <span class='str'>"Could not connect"</span><span class='layout'>)</span>
<span class='varop'>&gt;</span> 		<span class='layout'>(</span><span class='keyglyph'>\</span><span class='varid'>conn</span> <span class='keyglyph'>-&gt;</span> <span class='varid'>return</span> <span class='varid'>conn</span><span class='layout'>)</span>
<span class='varop'>&gt;</span> 		<span class='varid'>tryconn</span>
</pre>
To make your programs generic, you can create a simple wrapper around the
connection functions to that you can use URI-style connection string like some
of the popular Java and PHP-based solutions. First, the strings should look
fairly similar to HTTP URIs:

* `mysql://username:password@hostname/database`
* `pgsql://username:password@hostname/database`
* `sqlite:///path/to/file`

Such strings are usually URIs, so I'll make use of the
[Network.URI][network-uri] module that comes in the standard library. The
following function parses the database type out of the connection string
and then calls the next function to extract the username, password and host if
they are necessary (this code requires that the string contain all three).

<pre><span class='varop'>&gt;</span> <span class='varid'>parseConnString</span> <span class='varid'>cs</span> <span class='keyglyph'>=</span> <span class='keyword'>do</span>
<span class='varop'>&gt;</span> 	<span class='varid'>uri</span> <span class='keyglyph'>&lt;-</span> <span class='varid'>parseURI</span> <span class='varid'>cs</span>
<span class='varop'>&gt;</span> 	<span class='varid'>db</span> <span class='keyglyph'>&lt;-</span> <span class='varid'>return</span> <span class='varop'>$</span> <span class='varid'>init</span> <span class='varop'>$</span> <span class='varid'>uriScheme</span> <span class='varid'>uri</span>
<span class='varop'>&gt;</span> 	<span class='varid'>path</span> <span class='keyglyph'>&lt;-</span> <span class='varid'>return</span> <span class='varop'>$</span> <span class='varid'>uriPath</span> <span class='varid'>uri</span>
<span class='varop'>&gt;</span> 	<span class='layout'>(</span><span class='varid'>user</span><span class='layout'>,</span> <span class='varid'>pass</span><span class='layout'>,</span> <span class='varid'>host</span><span class='layout'>)</span> <span class='keyglyph'>&lt;-</span> <span class='varid'>parseAuthString</span> <span class='varid'>db</span> <span class='varop'>$</span> <span class='varid'>uriAuthority</span> <span class='varid'>uri</span>
<span class='varop'>&gt;</span> 	<span class='varid'>return</span> <span class='layout'>(</span><span class='varid'>db</span><span class='layout'>,</span> <span class='varid'>user</span><span class='layout'>,</span> <span class='varid'>pass</span><span class='layout'>,</span> <span class='varid'>host</span><span class='layout'>,</span> <span class='varid'>path</span><span class='layout'>)</span>
</pre>
<pre><span class='varop'>&gt;</span> <span class='varid'>parseAuthString</span> <span class='str'>"sqlite"</span> <span class='keyword'>_</span> <span class='keyglyph'>=</span> <span class='varid'>return</span> <span class='layout'>(</span><span class='str'>""</span><span class='layout'>,</span> <span class='str'>""</span><span class='layout'>,</span> <span class='str'>""</span><span class='layout'>)</span>
<span class='varop'>&gt;</span> <span class='varid'>parseAuthString</span> <span class='keyword'>_</span> <span class='keyword'>as</span> <span class='keyglyph'>=</span>  <span class='keyword'>do</span> 
<span class='varop'>&gt;</span> 	<span class='keyword'>as</span> <span class='keyglyph'>&lt;-</span> <span class='keyword'>as</span>
<span class='varop'>&gt;</span> 	<span class='varid'>i</span> <span class='keyglyph'>&lt;-</span> <span class='varid'>elemIndex</span> <span class='chr'>':'</span> <span class='varop'>$</span> <span class='varid'>uriUserInfo</span> <span class='keyword'>as</span>
<span class='varop'>&gt;</span> 	<span class='keyword'>let</span> <span class='layout'>(</span><span class='varid'>user</span><span class='layout'>,</span> <span class='varid'>pass</span><span class='layout'>)</span> <span class='keyglyph'>=</span> <span class='varid'>splitAt</span> <span class='varid'>i</span> <span class='varop'>$</span> <span class='varid'>uriUserInfo</span> <span class='keyword'>as</span>
<span class='varop'>&gt;</span> 	<span class='keyword'>let</span> <span class='varid'>host</span> <span class='keyglyph'>=</span> <span class='varid'>uriRegName</span> <span class='keyword'>as</span>
<span class='varop'>&gt;</span> 	<span class='varid'>return</span> <span class='layout'>(</span><span class='varid'>user</span><span class='layout'>,</span> <span class='varid'>init</span> <span class='varop'>$</span> <span class='varid'>tail</span> <span class='varid'>pass</span><span class='layout'>,</span> <span class='varid'>host</span><span class='layout'>)</span>
</pre>
Calling these functions works just as you'd expect them to, 

    *Main> parseConnString "blahblahblah"
    Nothing

    *Main> parseConnString "sqlite:///path/to/db"
    Just ("sqlite","","","","/path/to/db")

    parseConnString "mysql://user:pass@host/database"
    Just ("mysql","user","pass","host","/database")

Now that we can parse connection strings, it's easy to write a generic
database connection function. First call the parsing function, then call the 
appropriate connection function depending on the result:

<pre><span class='varop'>&gt;</span> <span class='comment'>-- | Connect to any supported database</span>
<span class='varop'>&gt;</span> <span class='varid'>connectToDB</span> <span class='varid'>cs</span> <span class='keyglyph'>=</span> <span class='keyword'>do</span> 
<span class='varop'>&gt;</span> 	<span class='layout'>(</span><span class='varid'>scheme</span><span class='layout'>,</span><span class='varid'>user</span><span class='layout'>,</span><span class='varid'>pass</span><span class='layout'>,</span><span class='varid'>host</span><span class='layout'>,</span><span class='varid'>db</span><span class='layout'>)</span> <span class='keyglyph'>&lt;-</span> <span class='varid'>maybe</span> 
<span class='varop'>&gt;</span> 		<span class='layout'>(</span><span class='varid'>fail</span> <span class='varop'>$</span> <span class='str'>"Invalid connection string: "</span><span class='varop'>++</span><span class='varid'>cs</span><span class='layout'>)</span> 
<span class='varop'>&gt;</span> 		<span class='layout'>(</span><span class='varid'>return</span><span class='layout'>)</span> 
<span class='varop'>&gt;</span> 		<span class='layout'>(</span><span class='varid'>parseConnString</span> <span class='varid'>cs</span><span class='layout'>)</span>
<span class='varop'>&gt;</span> 	<span class='keyword'>case</span> <span class='varid'>scheme</span> <span class='keyword'>of</span> 
<span class='varop'>&gt;</span> 		<span class='str'>"sqlite"</span> <span class='keyglyph'>-&gt;</span> <span class='varid'>connectSQLite3</span> <span class='varid'>db</span>
<span class='varop'>&gt;</span> 		<span class='str'>"mysql"</span>  <span class='keyglyph'>-&gt;</span> <span class='varid'>connectMySQL</span> <span class='varid'>host</span> <span class='layout'>(</span><span class='varid'>tail</span> <span class='varid'>db</span><span class='layout'>)</span> <span class='varid'>user</span> <span class='varid'>pass</span>
<span class='varop'>&gt;</span> 		<span class='str'>"pgsql"</span>  <span class='keyglyph'>-&gt;</span> <span class='varid'>connectPgSQL</span> <span class='varid'>host</span> <span class='layout'>(</span><span class='varid'>tail</span> <span class='varid'>db</span><span class='layout'>)</span> <span class='varid'>user</span> <span class='varid'>pass</span>
<span class='varop'>&gt;</span> 		<span class='varid'>s</span>        <span class='keyglyph'>-&gt;</span> <span class='varid'>fail</span> <span class='varop'>$</span> <span class='str'>"Unknown database: "</span> <span class='varop'>++</span> <span class='varid'>s</span>
</pre>
Now we've got a single function which takes a URI specifying the database to
open and returns a HSQL `Connection` value and we can leave the choice of
database system up to the users of our program. As an example, this program
will connect to the database specified in its first argument, drop the table
`foo` if it exists, and then create it again with a single `INT` column: 

<pre><span class='varop'>&gt;</span> <span class='varid'>main</span> <span class='keyglyph'>=</span> <span class='keyword'>do</span>
<span class='varop'>&gt;</span> 	<span class='varid'>db</span> <span class='keyglyph'>&lt;-</span> <span class='layout'>(</span><span class='varid'>liftM</span> <span class='varid'>head</span><span class='layout'>)</span> <span class='varid'>getArgs</span>
<span class='varop'>&gt;</span> 	<span class='varid'>putStrLn</span> <span class='varop'>$</span> <span class='str'>"Connecting to "</span><span class='varop'>++</span><span class='varid'>db</span>
<span class='varop'>&gt;</span> 	<span class='varid'>conn</span> <span class='keyglyph'>&lt;-</span> <span class='varid'>connectToDB</span> <span class='varid'>db</span>		<span class='comment'>-- Connect</span>
<span class='varop'>&gt;</span> 	<span class='varid'>putStrLn</span> <span class='varop'>$</span> <span class='str'>"Connected to "</span><span class='varop'>++</span><span class='varid'>db</span>
<span class='varop'>&gt;</span> 	<span class='varid'>s</span> <span class='keyglyph'>&lt;-</span> <span class='conid'>Hsql</span><span class='varop'>.</span><span class='varid'>query</span> <span class='varid'>conn</span> <span class='str'>"DROP TABLE IF EXISTS foo;"</span>
<span class='varop'>&gt;</span> 	<span class='conid'>Hsql</span><span class='varop'>.</span><span class='varid'>closeStatement</span> <span class='varid'>s</span>
<span class='varop'>&gt;</span> 	<span class='varid'>s</span> <span class='keyglyph'>&lt;-</span> <span class='conid'>Hsql</span><span class='varop'>.</span><span class='varid'>query</span> <span class='varid'>conn</span> <span class='str'>"CREATE TABLE foo ( col1 INT );"</span> 
<span class='varop'>&gt;</span> 	<span class='conid'>Hsql</span><span class='varop'>.</span><span class='varid'>closeStatement</span> <span class='varid'>s</span>
<span class='varop'>&gt;</span> 	<span class='varid'>putStrLn</span> <span class='varop'>$</span> <span class='str'>"Closed connection to "</span><span class='varop'>++</span><span class='varid'>db</span>
<span class='varop'>&gt;</span> 	<span class='conid'>Hsql</span><span class='varop'>.</span><span class='varid'>disconnect</span> <span class='varid'>conn</span>
</pre>
I run it like this:

    $ ghc --make -L/opt/local/lib/mysql5/mysql/ post.lhs
    [1 of 1] Compiling Main             ( post.lhs, post.o )
    Linking post ...

    $ ./post "pgsql://foo:@localhost/foo"
    Connecting to pgsql://foo:@localhost/foo
    Connected to pgsql://foo:@localhost/foo
    Closed connection to pgsql://foo:@localhost/foo

    $ ./post "mysql://foo:foo@localhost/foo"
    Connecting to mysql://foo:foo@localhost/foo
    Connected to mysql://foo:foo@localhost/foo
    Closed connection to mysql://foo:foo@localhost/foo

    $ ./post "sqlite:///tmp/test.sql"
    Connecting to sqlite:///tmp/test.sql
    Connected to sqlite:///tmp/test.sql
    Closed connection to sqlite:///tmp/test.sql

Of course, just because you can connect to SQLite3, MySQL, and PostgreSQL
databases, it doesn't mean they'll all work -- like all SQL databases, each
accepts quite different sub-/super-sets of SQL -- but *that* is an issue for
some blog.

If you found this post useful or have any feedback or questions, please leave
a comment or a trackback from your own blog.

Useful links
------------

If you run into trouble getting this to work, try the following links, or leave a comment (but if you do, please be ready for me to ask [what have you tried?](http://whathaveyoutried.com/))

* My post [Installing hsql and HDBC on GHC 6.10.1][pc-installing]
* [CRUD operations with haskell hsql and hsql-sqlite3][bb-CRUD]
* [SQLite documentation][sqlite-docs]
* [HSQL documentation][hsql-docs] and [Hackage page][hsql-hack] and those for
  [hsql-sqlite3][hsqlite3-hack], [hsql-mysql][], and [hsql-postgresql][] as
  well.
* [Network.URI][network-uri] documentation.
* [Real World Haskell chapter on databases](http://book.realworldhaskell.org/read/using-databases.html) (suggested by alexeyr on [reddit](http://www.reddit.com/r/haskell/comments/7imga/accessing_sql_databases_with_haskell/))


[pc-installing]: /2008/installing-hsql-hdbc-ghc-6-10-1/
[bb-CRUD]:  http://berlinbrowndev.blogspot.com/2008/02/haskell-snippet-crud-operations-with.html
[sqlite-docs]: http://www.sqlite.org/docs.html
[hsql-docs]: http://hackage.haskell.org/packages/archive/hsql/1.7/doc/html/Database-HSQL.html "HSQL documentation on Hackage"
[hsql-hack]: http://hackage.haskell.org/cgi-bin/hackage-scripts/package/hsql "HSQL package of Hackage"
[hsql-mysql]: http://hackage.haskell.org/cgi-bin/hackage-scripts/package/hsql-mysql
[hsql-postgresql]: http://hackage.haskell.org/cgi-bin/hackage-scripts/package/hsql-postgresql
[hsqlite3-hack]: http://hackage.haskell.org/cgi-bin/hackage-scripts/package/hsql-sqlite3 "HSQL-SQLite3 package on Hackage"
[network-uri]: http://www.haskell.org/ghc/docs/latest/html/libraries/network/Network-URI.html
