--- 
wordpress_id: 440
layout: post
title: Extending Lua in C
wordpress_url: http://passingcuriosity.com/?p=440
---
Lua is a small, portable, and fast scripting language designed for embedding in other software. Being designed for embedding, it has a simple but powerful API which makes it easy to communicate both ways: from C into Lua and from Lua into C. In this post, I'll describe the process of writing a small module adding support for OpenSSL's hashing functions to Lua.


Hashing data with OpenSSL
---------------------

Generating hashes of data is an relatively simple problem to address in a library: is has a small, simple interface which can be implemented using any of a large number of hashing libraries. Rather than locate, evaluate and include one of the many open source or public domain hashing libraries, I've decided to wrap the hashing functions from [OpenSSL](http://www.openssl.org/). This provides a number of benefits:

1. It's reasonably well trusted (and I don't have to try to vet it).
2. It's installed pretty much everywhere (so I don't need to include it with my code).
3. It's API is simple, consistent, and flexible.
4. We'll see later that it makes my code powerful and lends it an elegant interface.

Before I can write a Lua wrapper for the OpenSSL functions, I'll need to know how they work. The `man` pages help immeasurably, especially as they contain code demonstrating [how to hash data using OpenSSL](http://www.openssl.org/docs/crypto/EVP_DigestInit.html#EXAMPLE). Following the example in that man page, a first cut of my code will look like this:

{% highlight c %}
unsigned char *digest(char *algorithm, void *data, size_t len) {
    // The hash context
    const EVP_MD *md;
    EVP_MD_CTX mdctx;
    // The hash
    unsigned char  hash_data[EVP_MAX_MD_SIZE];
    unsigned int   hash_len = 0;
    unsigned char *hash_str = NULL;
    // Loop variables
    unsigned char *cur = NULL;
    unsigned int i = 0;

    // Get the hash algorithm the caller requested
    OpenSSL_add_all_digests();
    md = EVP_get_digestbyname(algorithm);
    if (! md ) {
        // The requested algorithm is not available
        // This is an error
    }

    // Initialize the hashing context to use the algorithm named in md
    EVP_MD_CTX_init(&mdctx);
    EVP_DigestInit_ex(&mdctx, md, NULL);

    // Feed the data to the hash function
    EVP_DigestUpdate(&mdctx, data, len);

    // Finalize the hashing context putting the hash into hash_data and
    // it's length into hash_len
    EVP_DigestFinal_ex(&mdctx, hash_data, &hash_len);
    EVP_MD_CTX_cleanup(&mdctx);

    // Translate the data into a string of hexadecimal characters
    cur = hash_str = (unsigned char*)malloc(1 + 2 * hash_len);
    for ( i = 0; i < hash_len; i++ ) {
        snprintf(cur, 3, "%02x", hash_data[i]);
        cur = cur + 2;
    }
    cur[0] = '\0';

    // Return the hex string of the hash
    return hash_str;
}
{% endhighlight %}

Easy! Variable arguments are a pain in the arse in C, so I've omitted them from the code above but it'd be great if the Lua module will accept any number of input values and hash them all. Thanks to the great OpenSSL API, doing so is just a matter of calling `EVP_DigestUpdate()` in a loop over each of the input values. It couldn't be simpler!

Calling C code from Lua
-------------------

Now that I can hash values with the OpenSSL functions, it's time to think about calling that code from Lua. Lua has a fairly simple API for implementing module in C:

* functions take a single argument -- the state of the Lua interpreter
* they can manipulate that state, including pushing or poping values off the argument stack
* and then return an integer -- the number of items they push onto the stack as return values.

As simple example may help illustrate. The following function inspects the stack to see how many parameters it was invoked with, and returns a message state such. Unlike the stacks used in many other systems, the Lua stack is indexed (you can access any item by its index, rather than only the top item) and these indexes start from 1 (instead of the traditional 0). As a consequence, the index of the top of the stack is the number of items on it.

{% highlight c %}
static int example(lua_State *L) {
    unsigned int n = 0;

    // Get the index of the top of the stack
    n = lua_gettop(L);

    // Push a string onto the stack using a printf-like convenience
    // function.
    lua_pushfstring(L, "You passed %d arguments.", n);

    // Return the number of return values pushed onto the stack.
    return 1;
}
{% endhighlight %}

Using just few more functions from the API, I can modify the OpenSSL code above to be called from Lua. All it requires is a change of signature, a call to `lua_tolstring()` to get the algorithm name, a call to `lua_gettop()` to get the number of inputs, a loop calling `lua_tolstring()`  to get each of them in turn and feed them to the hashing code, and a call to `lua_pushstring()` to push the return value onto the stack.

The revised code looks like this:

{% highlight c %}
static int hash_hash (lua_State *L) {
    EVP_MD_CTX mdctx;
    const EVP_MD *md;
    unsigned char md_value[EVP_MAX_MD_SIZE];
    char *algorithm = NULL;
    char *digest = NULL;
    char *cur  = NULL;
    unsigned int md_len = 0;
    unsigned int arguments = 0;
    unsigned int i = 0;
    size_t msg_len = 0;

    // Get the algorithm name from the closure
    algorithm = (char *)lua_tostring(L, 1);

    // Get the number of stack arguments
    arguments = lua_gettop(L);

    // Get the digest
    OpenSSL_add_all_digests();
    md = EVP_get_digestbyname(algorithm);
    if (! md ) {
        lua_pushfstring(L, "No such hash algorithm: %s", algorithm);
        return lua_error(L);
    }

    // Initialise the hash context
    EVP_MD_CTX_init(&mdctx);
    EVP_DigestInit_ex(&mdctx, md, NULL);

    // Add the arguments to the hash.
    for ( i = 2; i <= arguments; i++ ) {
        cur = (char *)lua_tolstring(L, i, &msg_len);
        EVP_DigestUpdate(&mdctx, cur, msg_len);
    }

    // Finalise the hash
    EVP_DigestFinal_ex(&mdctx, md_value, &md_len);
    EVP_MD_CTX_cleanup(&mdctx);

    // Convert the hash to a string
    msg_len = 1 + 2 * md_len;
    cur = digest = (char*)malloc(msg_len);
    for (i=0;i<md_len;i++) {
        snprintf(cur, 3, "%02x", md_value[i]);
        cur = cur + 2;
    }
    cur[0] = '\0';

    // Push the result onto the stack
    lua_pushstring(L, digest);
    free(digest);

    // Return the number of return values
    return(1);
}
{% endhighlight %}


With the function itself written, registering it so that it can be called by Lua code is simple too. Each C module (whether compiled into Lua or loaded as a shared object library) has a `luaopen_*()` function that is responsible for initialising the library and registering the resources it provides. There are utility functions to automatically register entire modules based on arrays of function pointers, but I've only got one function and there's no point cramming it into a table, so I'll go it alone. Again, it's really easy:

{% highlight c %}
LUALIB_API int luaopen_hash(lua_State *L) {
    lua_register(L, "hash", hash_hash);
    return 0;
}
{% endhighlight %}

An elegant API
------------

This is all very well and good, but the API is pretty poor as it stands: a single function which takes a string (denoting the actual function to compute) and a bunch of inputs. It's pretty cool that we can support all these functions with a single piece of code, but it'd be even better if our single piece of code implementing many functions looked like the many functions to the callers. Rather than `hash(&quot;md5&quot;, v1, v2, v3)`, we should be writing `md5(v1,v2,v3)`. Happily, this too is a cinch!

### Tables and meta-tables ###

You may or may not be familiar with *tables* -- Lua's single complex data-structure. Tables are a combination of arrays (sequential, integer indexed, etc.) with dictionaries/hashes (matching arbitrary keys with a value). Lua uses tables for pretty much everything including environments (wherein variables are stored) and modules (like our library).

If that was all there was to tables, then they wouldn't be such a big thing. Thankfully it is not. In addition to their workaday nature as Lua's catch all storage thingy, the semantics of tables can be modified using [*meta-tables*](http://www.lua.org/manual/5.1/manual.html#2.8) full of functions which implement aspects of their table's semantics. Using meta-tables I can override the default behaviour of, say, looking up a value my module table and return a brand new object instead. An object that didn't even exist until you asked for it.

Using this facility along with closures and anonymous functions I can hide my `hash_hash()` function above in a meta-table. It's as simple as modifying `hash_hash()` to take the algorithm name from its closure (rather than the first parameter) and adding a new *wrapper* function to create these closures on request. It is this wrapper function that will go in the meta-table to give us a shiny new API.

### Creating the closure ###

The first task is to create a closure of `hash_hash()` along with the algorithm name. Bearing in mind that this function is going to be called as the **index** operation, it will need to take two parameters: the table and the key. Given that it'll only be called for my module table, I'll just ignore the table argument.

{% highlight c %}
static int hash(lua_State *L) {
    char *algorithm = NULL;

    // Get the name of the algorithm (the key)
    algorithm = lua_tostring(L, 2);
    lua_pushstring(L, algorithm);

    // Push a closure of that value with hash_hash()
    lua_pushcclosure(L, hash_hash, 1);

    return 1;
}
{% endhighlight %}

This code just reads the key from the stack as a string and pushes it back onto the stack (this may not be necessary, I'm not sure). Then it pushes a closure of this one value with `hash_hash()` onto the stack.

Modifying `hash_hash()` to use this closure value is just as ease. I just need to modify the `lua_tostring()` call that gets the algorithm name to get the first value from the closure instead of the first argument on the stack:

{% highlight c %}
algorithm = (char *)lua_tostring(L, lua_upvalueindex(1));
{% endhighlight %}

and modify the `for` loop to start at first argument instead of the second:

{% highlight c %}
for ( i = 1; i <= arguments; i++ ) {
    // ...
{% endhighlight %}

Now I'm ready to build and install the meta-table for my module and my powerful new API will be complete.

### Hiding behind a meta-table ###

Binding this all up as an API is a little involved. As everything needs to pass through the stack, it's easiest to create the various objects in order and avoid having to shuffle them around. In code order:

1. Create the module table;
2. Create the meta-table;
3. Add a reference to `hash_index()` in the meta-table;
4. Join the table and the meta-table; and
5. Assign the table to the global variable "hash".

This isn't much longer in code. The body of `luaopen_hash()` now looks like:

{% highlight c %}
// Create the table
lua_createtable(L,0,0);

// Create the meta-table
lua_createtable(L,0,1);

// Add the __index
lua_pushcfunction(L, hash_index);
lua_setfield(L, -2, "__index");

// Set the meta-table
lua_setmetatable(L, -2);

// Set the global hash
lua_setfield(L, LUA_GLOBALSINDEX, "hash");
{% endhighlight %}

A few notes might help make the above a little clearer. The stack can be
accessed with negative indices which count from the top rather than the bottom
(i.e. `-1` is the top, `-2` is second from the top, etc.) and there are a
number of magical indices that access such things as the globals table (like
`LUA_GLOBALSINDEX`).

With these changes made, my code now has an API that's actually pretty great:
a single table that, by the magic of meta-tables, looks-up the appropriate
function as requested by the caller. It exposes a lot of functionality (six
different functions on my machine) but is implemented which only a fraction of
the code a traditional approach would need (about a sixth of it).

"Where do we go from here?"
---------------------------

The code I've described in this post is very simple but provides a powerful,
elegant interface that belies that simplicity.

The complete code for the module developed in this article is available as [lhash.c](/files/2009/03/01/lhash.c). Note, though, that I make no warranty as to its correctness or its fitness or suitability for any purpose.

Useful though it is, there are many ways it could be improved. Perhaps the
most important is improved error handling. As it stands, my code delays error
detection and handling 'til the latest possible moment: right as it's about to
perform the hashing operation. It's entirely reasonable (given Lua's first
class functions) that a user might get a reference to a hash function and not
call it until much later in the program. It would be nice if, instead of
happily returning a closure, code like

{% highlight lua %}
f = hash.nonsense
{% endhighlight %}

would fail immediately, rather than waiting until the program tries to call
`f`. To make it so, I need only to make to the code is to copy and paste the
algorithm lookup and test and -- for good measure -- move the OpenSSL
initialization call into the library open function. See the revised
[lhash2.c](/files/2009/03/01/lhash2.c) for these changes. To make this even
more useful, I'd like to find out how to set the function name in the call
stack without registering it (and thus allowing the users to call it
directly).

It's also not particularly self-documenting. Tables in Lua are iterable just
like similar structures in other languages. It'd be nice if callers could
iterate over the table and get a list of the valid keys, just as they can with
most other modules.

While generating a new closure every time the user wants one is cheap, it
would be nice to add memoization so that `hash_index()` doesn't need to create
a new closure if it's already created one for the requested algorithm. This
would also ensure that references to the same hash algorithm are identical
which is not currently the case (alas `hash.md5 != hash.md5`).

Finally, allowing the user to hash values other than strings and numbers.
Alas, this would be rather more complex what with having to serialize tables
for hashing (a difficult task without a stable sort and in the possible
presence of arbitrary opaque values from other C extensions).

When that lot's done, it'll be time to move on to the rest of OpenSSL...
