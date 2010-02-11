/** @file
 *
 * This code implements wraps and exports the OpenSSL hashing functions to Lua. 
 *
 * To use this code arrange for it to be loaded by your Lua interpreter either
 * by compiling it in or loading a shared library. You'll need to pass various
 * flags to your compiler to get it to use the OpenSSL libraries, etc. I used
 * something like this:
 *
 *   gcc `pkg-config openssl --cflags --libs` -c lhash.c
 * 
 * Once loaded, this library defines a table called hash which, by the magic of
 * meta-tables, give access to any hashing function your OpenSSL. Simply access
 * the functions as members of the table:
 *
 *   print(hash.md5("Foo")) 
 *
 *   t = hash.sha1("Some data", "Some more data")
 *
 *   pw = hash.sha1("salt", io.read())
 *
 * Comments, questions, and suggestions are welcome and should be addressed to 
 *
 *     Thomas Sutton
 *     <me@thomas-sutton.id.au>
 *
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2009 Thomas Sutton
 * 
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * 
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 * 
 * 3. Neither the name of the author nor the names of his contributors may be
 * used to endorse or promote products derived from this software without
 * specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
 * EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */ 

#include <stdlib.h>
#include <openssl/evp.h>

#define lhash_c
#define LUA_LIB

#include "lua.h"

/**
 * Hash all arguments passed to the function using the algorithm named in
 * the closure.
 */
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
	algorithm = (char *)lua_tostring(L, lua_upvalueindex(1));

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
	for ( i = 1; i <= arguments; i++ ) {
		cur = (char *)lua_tolstring(L, i, &msg_len);
		EVP_DigestUpdate(&mdctx, cur, msg_len);
	}

	// Finalise the hash
	EVP_DigestFinal_ex(&mdctx, md_value, &md_len);
	EVP_MD_CTX_cleanup(&mdctx);

	// Convert to a string and push it on the Lua stack
	msg_len = 1 + 2 * md_len;
	cur = digest = (char*)malloc(msg_len);
	for (i=0;i<md_len;i++) {
		snprintf(cur, 3, "%02x", md_value[i]);
		cur = cur + 2;
	}
	cur[0] = '\0';
	// fprintf(stderr, "Hash was: %s\n", digest);
	lua_pushstring(L, digest);
	free(digest);

	return(1);
}

/** 
 * Create a closure of hash_hash() and an algorithm name.
 */
static int hash_index (lua_State *L) {
    char *algorithm = NULL;

    // Get the second argument and push it as a string
    algorithm = (char *)lua_tostring(L, 2);
    lua_pushstring(L, algorithm);

    // Push a closure of that string with hash_hash()
    lua_pushcclosure(L, hash_hash, 1);

    return 1;
}

/**
 * Register the library's tables.
 */
LUALIB_API int luaopen_hash (lua_State *L) {
    // Create the 'hash' table
    lua_createtable(L, 0, 0);

    // Create the meta-table
    lua_createtable(L, 0, 1);

    // Add hash as __index
    lua_pushcfunction(L, hash_index);
    lua_setfield(L, -2, "__index");

    // Set metatable
    lua_setmetatable(L, -2);
    // Set global field "hash"
    lua_setfield(L, LUA_GLOBALSINDEX, "hash");

	return 0;
};
