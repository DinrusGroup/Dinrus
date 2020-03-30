/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1985-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/mem.d, backend/mem.d)
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/backend/mem.d
 */


module drc.backend.mem;

version(Dinrus) import cidrus;
else
{
import core.stdc.stdlib : malloc, calloc, realloc, free;
import core.stdc.ткст : strdup;
}

extern (C):


/*:*/

ткст0 mem_strdup(ткст0 p) { return strdup(p); }
ук mem_malloc(т_мера u) { return malloc(u); }
ук mem_fmalloc(т_мера u) { return malloc(u); }
ук mem_calloc(т_мера u) { return calloc(u, 1); }
ук mem_realloc(ук p, т_мера u) { return realloc(p, u); }
проц mem_free(ук p) { free(p); }

extern (C++)
{
    проц mem_free_cpp(проц *);
    alias mem_free_cpp mem_freefp;
}

version (MEM_DEBUG)
{
    alias   mem_strdup mem_fstrdup;
    alias   mem_calloc mem_fcalloc;
    alias   mem_malloc mem_fmalloc;
    alias     mem_free mem_ffree;
}
else
{
    сим *mem_fstrdup(сим *);
    проц *mem_fcalloc(т_мера);
    проц *mem_fmalloc(т_мера);
    проц mem_ffree(проц *) { }
}

