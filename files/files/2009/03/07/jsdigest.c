/** @file
 * Implement the digest functionality as in Lua.
 */
#include <stdlib.h>

#include "jsapi.h"

/**
 * Implement the digest() function.
 */
JSBool myjs_digest(JSContext *cx, JSObject *obj, uintN argc, jsval *argv,
        jsval *rval) 
{
    
    return JS_NewNumberValue(cx, rand(), rval);
}

static JSFunctionSpec myjs_global_functions[] = {
    {"digest",   myjs_digest,   0, 0, 0},
    {NULL,NULL,0,0,0}
};


extern JSObject *js_InitDigestClass(JSContext *cx, JSObject *obj)
{
    if (! JS_DefineFunctions(cx, obj, myjs_global_functions)) {
        return obj;
    } else {
        return NULL;
    }
}
