As the first step on my journey into web-development with Haskell, I'm looking
at interfacing with SQL databases. While there are a number of options
available, only a few of them are currently maintained and none are usable (as
I write this) out of the box using the current stable release of GHC. Given
that it's a little bit of work to get going, that it's raised with some
regularity on the Haskell mailing lists, and that if I don't write it down,
I'm liable to forget, this post will describe accessing SQL databases
using the `HSQL` package and one or more of its driver packages.

This post is literate Haskell (you can find download the original `.lhs` file
in the links at the end) and was tested with GHC 6.10.1.

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

> import Database.HSQL as Hsql
> import Database.HSQL.SQLite3 as SQLite
> import Database.HSQL.MySQL as MySQL
> import Database.HSQL.PostgreSQL as PgSQL

along with a few more for utility functions:

> import IO (try, IOMode(..))
> import System.Environment (getArgs)
> import Data.List (elemIndex)
> import Control.Monad (mapM_, liftM, guard)
> import Network.URI (parseURI, uriScheme, uriPath, uriAuthority, 
> 	uriUserInfo, uriRegName)

and you can connect to the databases. Each of the different database driver
packages implements it's own `connect` function. The SQLite3 `connect` is
simple: just pass it the name of the database file and the mode to open it:

> connectSQLite3 name = do
> 	tryconn <- try $ SQLite.connect name ReadWriteMode
> 	either (\err  -> fail "Could not connect to database")
> 		(\conn -> return conn)
> 		tryconn

Connecting to server-based databases is a little more complex, but essentially
identical for both MySQL and PostgreSQL:

> -- | Connect to a MySQL database
> connectMySQL host db user pass = do
> 	tryconn <- try $ MySQL.connect host db user pass
> 	either (\err  -> fail "Could not connect")
> 		(\conn -> return conn)
> 		tryconn

> -- | Connect to a PostgreSQL database
> connectPgSQL host db user pass = do
> 	tryconn <- try $ PgSQL.connect host db user pass
> 	either (\err  -> fail "Could not connect")
> 		(\conn -> return conn)
> 		tryconn

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

> parseConnString cs = do
> 	uri <- parseURI cs
> 	db <- return $ init $ uriScheme uri
> 	path <- return $ uriPath uri
> 	(user, pass, host) <- parseAuthString db $ uriAuthority uri
> 	return (db, user, pass, host, path)

> parseAuthString "sqlite" _ = return ("", "", "")
> parseAuthString _ as =  do 
> 	as <- as
> 	i <- elemIndex ':' $ uriUserInfo as
> 	let (user, pass) = splitAt i $ uriUserInfo as
> 	let host = uriRegName as
> 	return (user, init $ tail pass, host)

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

> -- | Connect to any supported database
> connectToDB cs = do 
> 	(scheme,user,pass,host,db) <- maybe 
> 		(fail $ "Invalid connection string: "++cs) 
> 		(return) 
> 		(parseConnString cs)
> 	case scheme of 
> 		"sqlite" -> connectSQLite3 db
> 		"mysql"  -> connectMySQL host (tail db) user pass
> 		"pgsql"  -> connectPgSQL host (tail db) user pass
> 		s        -> fail $ "Unknown database: " ++ s

Now we've got a single function which takes a URI specifying the database to
open and returns a HSQL `Connection` value and we can leave the choice of
database system up to the users of our program. As an example, this program
will connect to the database specified in its first argument, drop the table
`foo` if it exists, and then create it again with a single `INT` column: 

> main = do
> 	db <- (liftM head) getArgs
> 	putStrLn $ "Connecting to "++db
> 	conn <- connectToDB db		-- Connect
> 	putStrLn $ "Connected to "++db
> 	s <- Hsql.query conn "DROP TABLE IF EXISTS foo;"
> 	Hsql.closeStatement s
> 	s <- Hsql.query conn "CREATE TABLE foo ( col1 int );" 
> 	Hsql.closeStatement s
> 	putStrLn $ "Closed connection to "++db
> 	Hsql.disconnect conn

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

* My post [Installing hsql and HDBC on GHC 6.10.1][pc-installing]
* [CRUD operations with haskell hsql and hsql-sqlite3][bb-CRUD]
* [SQLite documentation][sqlite-docs]
* [HSQL documentation][hsql-docs] and [Hackage page][hsql-hack] and those for
  [hsql-sqlite3][hsqlite3-hack], [hsql-mysql][], and [hsql-postgresql][] as
  well.
* [Network.URI][network-uri] documentation.


[pc-installing]: http://passingcuriosity.com/index.php/2008-12/installing-hsql-hdbc-ghc-6-10-1/
[bb-CRUD]:  http://berlinbrowndev.blogspot.com/2008/02/haskell-snippet-crud-operations-with.html
[sqlite-docs]: http://www.sqlite.org/docs.html
[hsql-docs]: http://hackage.haskell.org/packages/archive/hsql/1.7/doc/html/Database-HSQL.html "HSQL documentation on Hackage"
[hsql-hack]: http://hackage.haskell.org/cgi-bin/hackage-scripts/package/hsql "HSQL package of Hackage"
[hsql-mysql]: http://hackage.haskell.org/cgi-bin/hackage-scripts/package/hsql-mysql
[hsql-postgresql]: http://hackage.haskell.org/cgi-bin/hackage-scripts/package/hsql-postgresql
[hsqlite3-hack]: http://hackage.haskell.org/cgi-bin/hackage-scripts/package/hsql-sqlite3 "HSQL-SQLite3 package on Hackage"
[network-uri]: http://www.haskell.org/ghc/docs/latest/html/libraries/network/Network-URI.html
