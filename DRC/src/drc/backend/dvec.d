/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Simple bit vector implementation.
 *
 * Copyright:   Copyright (C) 2013-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/dvec.d, backend/dvec.d)
 */

module drc.backend.dvec;

import cidrus;

//import core.bitop;

extern (C):


/*:*/

alias  т_мера vec_base_t;                     // base тип of vector
alias vec_base_t* vec_t;

const VECBITS = vec_base_t.sizeof * 8;        // # of bits per entry
const VECMASK = VECBITS - 1;                  // mask for bit position
const VECSHIFT = (VECBITS == 16) ? 4 : (VECBITS == 32 ? 5 : 6);   // # of bits in VECMASK

static assert(vec_base_t.sizeof == 2 && VECSHIFT == 4 ||
              vec_base_t.sizeof == 4 && VECSHIFT == 5 ||
              vec_base_t.sizeof == 8 && VECSHIFT == 6);

struct VecGlobal
{
    цел count;           // # of vectors allocated
    цел initcount;       // # of times package is initialized
    vec_t[30] freelist;  // free lists indexed by dim

  
  /*:*/

    проц initialize()
    {
        if (initcount++ == 0)
            count = 0;
    }

    проц terminate()
    {
        if (--initcount == 0)
        {
            debug
            {
                if (count != 0)
                {
                    printf("vecGlobal.count = %d\n", count);
                    assert(0);
                }
            }
            else
                assert(count == 0);

            foreach (т_мера i; new бцел[0 .. freelist.length])
            {
                проц **vn;
                for (ук* v = cast(проц **)freelist[i]; v; v = vn)
                {
                    vn = cast(проц **)(*v);
                    //mem_free(v);
                    .free(v);
                }
                freelist[i] = null;
            }
        }
    }

    vec_t размести(т_мера numbits)
    {
        if (numbits == 0)
            return cast(vec_t) null;
        const dim = (numbits + (VECBITS - 1)) >> VECSHIFT;
        vec_t v;
        if (dim < freelist.length && (v = freelist[dim]) != null)
        {
            freelist[dim] = *cast(vec_t *)v;
            v += 2;
            switch (dim)
            {
                case 5:     v[4] = 0;  goto case 4;
                case 4:     v[3] = 0;  goto case 3;
                case 3:     v[2] = 0;  goto case 2;
                case 2:     v[1] = 0;  goto case 1;
                case 1:     v[0] = 0;
                            break;
                default:    memset(v,0,dim * vec_base_t.sizeof);
                            break;
            }
            goto L1;
        }
        else
        {
            v = cast(vec_t) calloc(dim + 2, vec_base_t.sizeof);
            assert(v);
        }
        if (v)
        {
            v += 2;
        L1:
            vec_dim(v) = dim;
            vec_numbits(v) = numbits;
            /*printf("vec_calloc(%d): v = %p vec_numbits = %d vec_dim = %d\n",
                numbits,v,vec_numbits(v),vec_dim(v));*/
            count++;
        }
        return v;
    }

    vec_t dup(vec_t v)
    {
        if (!v)
            return null;

        const dim = vec_dim(v);
        const члобайт = (dim + 2) * vec_base_t.sizeof;
        vec_t vc;
        vec_t результат;
        if (dim < freelist.length && (vc = freelist[dim]) != null)
        {
            freelist[dim] = *cast(vec_t *)vc;
            goto L1;
        }
        else
        {
            vc = cast(vec_t) calloc(члобайт, 1);
            assert(vc);
        }
        if (vc)
        {
          L1:
            memcpy(vc,v - 2,члобайт);
            count++;
            результат = vc + 2;
        }
        else
            результат = null;
        return результат;
    }

    проц free(vec_t v)
    {
        /*printf("vec_free(%p)\n",v);*/
        if (v)
        {
            const dim = vec_dim(v);
            v -= 2;
            if (dim < freelist.length)
            {
                *cast(vec_t *)v = freelist[dim];
                freelist[dim] = v;
            }
            else
                .free(v);
            count--;
        }
    }

}

 VecGlobal vecGlobal;

private  vec_base_t MASK(бцел b) { return cast(vec_base_t)1 << (b & VECMASK); }

 vec_base_t vec_numbits(inout vec_t v) { return v[-1]; }
 vec_base_t vec_dim(inout vec_t v) { return v[-2]; }

/**************************
 * Initialize package.
 */

проц vec_init()
{
    vecGlobal.initialize();
}


/**************************
 * Terminate package.
 */

проц vec_term()
{
    vecGlobal.terminate();
}

/********************************
 * Allocate a vector given # of bits in it.
 * Clear the vector.
 */

vec_t vec_calloc(т_мера numbits)
{
    return vecGlobal.размести(numbits);
}

/********************************
 * Allocate копируй of existing vector.
 */

vec_t vec_clone(vec_t v)
{
    return vecGlobal.dup(v);
}

/**************************
 * Free a vector.
 */

проц vec_free(vec_t v)
{
    /*printf("vec_free(%p)\n",v);*/
    return vecGlobal.free(v);
}

/**************************
 * Realloc a vector to have numbits bits in it.
 * Extra bits are set to 0.
 */

vec_t vec_realloc(vec_t v, т_мера numbits)
{
    /*printf("vec_realloc(%p,%d)\n",v,numbits);*/
    if (!v)
        return vec_calloc(numbits);
    if (!numbits)
    {   vec_free(v);
        return null;
    }
    const vbits = vec_numbits(v);
    if (numbits == vbits)
        return v;
    vec_t newv = vec_calloc(numbits);
    if (newv)
    {
        const члобайт = (vec_dim(v) < vec_dim(newv)) ? vec_dim(v) : vec_dim(newv);
        memcpy(newv,v,члобайт * vec_base_t.sizeof);
        vec_clearextrabits(newv);
    }
    vec_free(v);
    return newv;
}

/**************************
 * Set bit b in vector v.
 */


проц vec_setbit(т_мера b, vec_t v)
{
    debug
    {
        if (!(v && b < vec_numbits(v)))
            printf("vec_setbit(v = %p,b = %d): numbits = %d dim = %d\n",
                v,b,v ? vec_numbits(v) : 0, v ? vec_dim(v) : 0);
    }
    assert(v && b < vec_numbits(v));
    core.bitop.bts(v, b);
}

/**************************
 * Clear bit b in vector v.
 */


проц vec_clearbit(т_мера b, vec_t v)
{
    assert(v && b < vec_numbits(v));
    core.bitop.btr(v, b);
}

/**************************
 * Test bit b in vector v.
 */


т_мера vec_testbit(т_мера b, vec_t v)
{
    if (!v)
        return 0;
    debug
    {
        if (!(v && b < vec_numbits(v)))
            printf("vec_setbit(v = %p,b = %d): numbits = %d dim = %d\n",
                v,b,v ? vec_numbits(v) : 0, v ? vec_dim(v) : 0);
    }
    assert(v && b < vec_numbits(v));
    return core.bitop.bt(v, b);
}

/********************************
 * Find first set bit starting from b in vector v.
 * If no bit is found, return vec_numbits(v).
 */


т_мера vec_index(т_мера b, vec_t vec)
{
    if (!vec)
        return 0;
    vec_base_t* v = vec;
    if (b < vec_numbits(v))
    {
        const vtop = &vec[vec_dim(v)];
        const bit = b & VECMASK;
        if (bit != b)                   // if not starting in first word
            v += b >> VECSHIFT;
        т_мера starv = *v >> bit;
        while (1)
        {
            while (starv)
            {
                if (starv & 1)
                    return b;
                b++;
                starv >>= 1;
            }
            b = (b + VECBITS) & ~VECMASK;   // round up to следщ word
            if (++v >= vtop)
                break;
            starv = *v;
        }
    }
    return vec_numbits(vec);
}

/********************************
 * Compute v1 &= v2.
 */


проц vec_andass(vec_t v1, vec_base_t* v2)
{
    if (v1)
    {
        assert(v2);
        assert(vec_numbits(v1)==vec_numbits(v2));
        const vtop = &v1[vec_dim(v1)];
        for (; v1 < vtop; v1++,v2++)
            *v1 &= *v2;
    }
    else
        assert(!v2);
}

/********************************
 * Compute v1 = v2 & v3.
 */


проц vec_and(vec_t v1, vec_base_t* v2, vec_base_t* v3)
{
    if (v1)
    {
        assert(v2 && v3);
        assert(vec_numbits(v1)==vec_numbits(v2) && vec_numbits(v1)==vec_numbits(v3));
        const vtop = &v1[vec_dim(v1)];
        for (; v1 < vtop; v1++,v2++,v3++)
            *v1 = *v2 & *v3;
    }
    else
        assert(!v2 && !v3);
}

/********************************
 * Compute v1 ^= v2.
 */


проц vec_xorass(vec_t v1, vec_base_t* v2)
{
    if (v1)
    {
        assert(v2);
        assert(vec_numbits(v1)==vec_numbits(v2));
        const vtop = &v1[vec_dim(v1)];
        for (; v1 < vtop; v1++,v2++)
            *v1 ^= *v2;
    }
    else
        assert(!v2);
}

/********************************
 * Compute v1 = v2 ^ v3.
 */


проц vec_xor(vec_t v1, vec_base_t* v2, vec_base_t* v3)
{
    if (v1)
    {
        assert(v2 && v3);
        assert(vec_numbits(v1)==vec_numbits(v2) && vec_numbits(v1)==vec_numbits(v3));
        const vtop = &v1[vec_dim(v1)];
        for (; v1 < vtop; v1++,v2++,v3++)
            *v1 = *v2 ^ *v3;
    }
    else
        assert(!v2 && !v3);
}

/********************************
 * Compute v1 |= v2.
 */


проц vec_orass(vec_t v1, vec_base_t* v2)
{
    if (v1)
    {
        debug assert(v2);
        debug assert(vec_numbits(v1)==vec_numbits(v2));
        const vtop = &v1[vec_dim(v1)];
        for (; v1 < vtop; v1++,v2++)
            *v1 |= *v2;
    }
    else
        assert(!v2);
}

/********************************
 * Compute v1 = v2 | v3.
 */


проц vec_or(vec_t v1, vec_base_t* v2, vec_base_t* v3)
{
    if (v1)
    {
        assert(v2 && v3);
        assert(vec_numbits(v1)==vec_numbits(v2) && vec_numbits(v1)==vec_numbits(v3));
        const vtop = &v1[vec_dim(v1)];
        for (; v1 < vtop; v1++,v2++,v3++)
                *v1 = *v2 | *v3;
    }
    else
        assert(!v2 && !v3);
}

/********************************
 * Compute v1 -= v2.
 */


проц vec_subass(vec_t v1, vec_base_t* v2)
{
    if (v1)
    {
        assert(v2);
        assert(vec_numbits(v1)==vec_numbits(v2));
        const vtop = &v1[vec_dim(v1)];
        for (; v1 < vtop; v1++,v2++)
            *v1 &= ~*v2;
    }
    else
        assert(!v2);
}

/********************************
 * Compute v1 = v2 - v3.
 */


проц vec_sub(vec_t v1, vec_base_t* v2, vec_base_t* v3)
{
    if (v1)
    {
        assert(v2 && v3);
        assert(vec_numbits(v1)==vec_numbits(v2) && vec_numbits(v1)==vec_numbits(v3));
        const vtop = &v1[vec_dim(v1)];
        for (; v1 < vtop; v1++,v2++,v3++)
            *v1 = *v2 & ~*v3;
    }
    else
        assert(!v2 && !v3);
}

/****************
 * Clear vector.
 */


проц vec_clear(vec_t v)
{
    if (v)
        memset(v, 0, v[0].sizeof * vec_dim(v));
}

/****************
 * Set vector.
 */


проц vec_set(vec_t v)
{
    if (v)
    {
        memset(v, ~0, v[0].sizeof * vec_dim(v));
        vec_clearextrabits(v);
    }
}

/***************
 * Copy vector.
 */


проц vec_copy(vec_t to, vec_t from)
{
    if (to != from)
    {
        debug
        {
            if (!(to && from && vec_numbits(to) == vec_numbits(from)))
                printf("to = x%lx, from = x%lx, numbits(to) = %d, numbits(from) = %d\n",
                    cast(цел)to,cast(цел)from,to ? vec_numbits(to) : 0, from ? vec_numbits(from): 0);
        }
        assert(to && from && vec_numbits(to) == vec_numbits(from));
        memcpy(to, from, to[0].sizeof * vec_dim(to));
    }
}

/****************
 * Return 1 if vectors are equal.
 */


цел vec_equal( vec_t v1,  vec_t v2)
{
    if (v1 == v2)
        return 1;
    assert(v1 && v2 && vec_numbits(v1) == vec_numbits(v2));
    return !memcmp(v1, v2, v1[0].sizeof * vec_dim(v1));
}

/********************************
 * Return 1 if (v1 & v2) == 0
 */


цел vec_disjoint(vec_base_t* v1, vec_base_t* v2)
{
    assert(v1 && v2);
    assert(vec_numbits(v1) == vec_numbits(v2));
    const vtop = &v1[vec_dim(v1)];
    for (; v1 < vtop; v1++,v2++)
        if (*v1 & *v2)
            return 0;
    return 1;
}

/*********************
 * Clear any extra bits in vector.
 */


проц vec_clearextrabits(vec_t v)
{
    assert(v);
    const n = vec_numbits(v);
    if (n & VECMASK)
        v[vec_dim(v) - 1] &= MASK(cast(бцел)n) - 1;
}

/******************
 * Write out vector.
 */


проц vec_println( vec_t v)
{
    debug
    {
        vec_print(v);
        fputc('\n',stdout);
    }
}


проц vec_print( vec_t v)
{
    debug
    {
        printf(" Vec %p, numbits %d dim %d",v,vec_numbits(v),vec_dim(v));
        if (v)
        {
            fputc('\t',stdout);
            for (т_мера i = 0; i < vec_numbits(v); i++)
                fputc((vec_testbit(i,v)) ? '1' : '0',stdout);
        }
    }
}


