// Copyright (C) 1985-1998 by Symantec
// Copyright (C) 2000-2009 by Digital Mars
// All Rights Reserved
// http://www.digitalmars.com
// Written by Walter Bright
/*
 * This source file is made available for personal use
 * only. The license is in /dmd/src/dmd/backendlicense.txt
 * or /dm/src/dmd/backendlicense.txt
 * For any other uses, please contact Digital Mars.
 */

/* Routines to handle elems.                    */

#if !SPP

#include        <stdio.h>
#include        <string.h>
#include        <time.h>
#include        <stdarg.h>

#if DDRT
#include        "paccfp.h"
#endif

#include        "cc.h"
#include        "type.h"
#include        "el.h"
#include        "list.h"
#include        "mem.h"
#include        "oper.h"
#include        "type.h"

#include        "parser.h"
#include        "code.h"

#include        "global.h"
#include        "go.h"
#if TARGET_MAC
#include        "TG.h"
#endif

#if __POWERPC && TARGET_68K
#undef DDRT
#define DDRT 1          // turn ddrt on
#endif

static char __file__[] = __FILE__;      /* for tassert.h                */
#include        "tassert.h"

#ifdef STATS
static int elfreed = 0;                 /* number of freed elems        */
static int eprm_cnt;                    /* max # of allocs at any point */
#endif

#if TARGET_POWERPC
#include "cgobjxcoff.h"
#include "xcoff.h"
#endif

#if TARGET_OSX
extern void slist_add(Symbol *s);
#endif

/*******************************
 * Do our own storage allocation of elems.
 */

static elem *nextfree = NULL;           /* pointer to next free elem    */

static int elcount = 0;                 /* number of allocated elems    */
static int elem_size = sizeof(elem);

#ifdef DEBUG
static int elmax;                       /* max # of allocs at any point */
#endif

/////////////////////////////
// Table to gather redundant strings in.

static struct STAB
{   symbol *sym;        // symbol that refers to the string
    char *p;            // pointer to the string
    int len;            // length of string p
} stable[16];
static int stable_si;

/************************
 * Initialize el package.
 */

void el_init()
{
    if (!configv.addlinenumbers)
        elem_size = sizeof(elem) - sizeof(Srcpos);
}

/*******************************
 * Initialize for another run through.
 */

void el_reset()
{
    stable_si = 0;
    for (int i = 0; i < arraysize(stable); i++)
        mem_free(stable[i].p);
    memset(stable,0,sizeof(stable));
}

#if TX86
/************************
 * Terminate el package.
 */

void el_term()
{
#if TERMCODE
        int i;

        for (i = 0; i < arraysize(stable); i++)
            mem_free(stable[i].p);

#ifdef DEBUG
        dbg_printf("Max # of elems = %d\n",elmax);
#endif
        if (elcount != 0)
            dbg_printf("unfreed elems = %d\n",elcount);
        while (nextfree)
        {   elem *e;

            e = nextfree->E1;
#if TX86
            mem_ffree(nextfree);
#else
            MEM_PH_FREE(nextfree);
#endif
            nextfree = e;
        }
#else
        assert(elcount == 0);
#endif
}
#endif

/***********************
 * Allocate an element.
 */

#if SCPP && __SC__ && __INTSIZE == 4 && TX86 && !_DEBUG_TRACE && !MEM_DEBUG && _WIN32 && !defined(DEBUG)

__declspec(naked) elem *el_calloc()
{
    __asm
    {
        mov     EAX,elcount
        push    EDI

        inc     EAX
        mov     EDI,nextfree

        test    EDI,EDI
        je      L27

        mov     EDX,E1[EDI]
        mov     elcount,EAX

        xor     EAX,EAX
        mov     nextfree,EDX
        jmp     L30

L27:    push    sizeof(elem)
        mov     elcount,EAX
        call    mem_fmalloc
        mov     EDI,EAX
        xor     EAX,EAX

L30:    mov     EDX,EDI
        mov     ECX,(sizeof(elem) + 3) / 4
    #if DOS386
        push    DS
        pop     ES
    #endif
        rep     stosd
        mov     EAX,EDX
        pop     EDI
        ret
    }
}

#else

elem *el_calloc()
{
    elem *e;
    static elem ezero;

    elcount++;
    if (nextfree)
    {   e = nextfree;
        nextfree = e->E1;
    }
    else
#if TX86
        e = (elem *) mem_fmalloc(sizeof(elem));
#else
        e = (elem *) MEM_PH_MALLOC(sizeof(elem));
#endif
#ifdef STATS
    eprm_cnt++;
#endif
    *e = ezero;                         /* clear it             */

#ifdef DEBUG
    e->id = IDelem;
    if (elcount > elmax)
        elmax = elcount;
#endif
    /*dbg_printf("el_calloc() = %p\n",e);*/
    return e;
}

#endif

/***************
 * Free element
 */

void el_free(elem *e)
{
    int op;
    tym_t ty;

L1:
    if (!e) return;
    elem_debug(e);
    //dbg_printf("el_free(%p)\n",e);
    //elem_print(e);
    if (SCPP && PARSER)
    {
        ty = e->ET ? e->ET->Tty : 0;
        type_free(e->ET);
    }
    else if (e->Ecount--)
        return;                         // usage count
    elcount--;
    op = e->Eoper;
    switch (op)
    {
        case OPconst:
#if FLOATS_IN_CODE
            if (!PARSER && FLT_CODESEG_CELEM(e))
                flt_free_elem(e);
#endif
            break;

        case OPvar:
            break;
        case OPrelconst:
#if SCPP
            if (0 && PARSER && tybasic(ty) == TYmemptr)
                el_free(e->EV.sm.ethis);
#endif
            break;
        case OPstring:
        case OPasm:
#if HOST_MPW
            if ( !(e->Eflags&EFsmasm) )
#endif
#if TX86 || HOST_MPW
                // never free; it's alloc'd from temp mem in most (all?) cases
            MEM_PH_FREE(e->EV.ss.Vstring);
#endif
            break;
        default:
            debug_assert(op < OPMAX);
            if (!OTleaf(op))
            {   elem *en;

                if (OTbinary(op))
                    el_free(e->E2);
                en = e->E1;
#ifdef DEBUG
                memset(e,0xFF,elem_size);
#endif
                e->E1 = nextfree;
                nextfree = e;

#ifdef STATS
                elfreed++;
#endif
                e = en;
                goto L1;
            }
            break;
    }
#ifdef DEBUG
  memset(e,0xFF,elem_size);
#endif
  e->E1 = nextfree;
  nextfree = e;

#ifdef STATS
  elfreed++;
#endif
}

#ifdef STATS
/* count number of elems available on free list */
void el_count_free()
    {
    elem *e;
    int count;

    for(e=nextfree;e;e=e->E1)
        count++;
    dbg_printf("Requests for elems %d\n",elcount);
    dbg_printf("Requests to free elems %d\n",elfreed);
    dbg_printf("Number of elems %d\n",eprm_cnt);
    dbg_printf("Number of elems currently on free list %d\n",count);
    }
#endif

/*********************
 * Combine e1 and e2 with a comma-expression.
 * Be careful about either or both being NULL.
 */

elem * el_combine(elem *e1,elem *e2)
{
    if (e1)
    {   if (e2)
            e1 = (SCPP && PARSER) ? el_bint(OPcomma,e2->ET,e1,e2)
                        : el_bin(OPcomma,e2->Ety,e1,e2);
    }
    else
        e1 = e2;
    return e1;
}

/*********************
 * Combine e1 and e2 as parameters to a function.
 * Be careful about either or both being NULL.
 */

elem * el_param(elem *e1,elem *e2)
{
    //printf("el_param(%p, %p)\n", e1, e2);
#if 0
    if (e2 && e2->Eoper != OPstrpar && tybasic(e2->Ety) == TYstruct)
        *(char*)0=0;
#endif
    if (e1)
    {   if (e2)
            e1 = (SCPP && PARSER) ? el_bint(OPparam,tsvoid,e1,e2)
                        : el_bin(OPparam,TYvoid,e1,e2);
    }
    else
        e1 = e2;
    return e1;
}

/*********************************
 * Create parameter list, terminated by a NULL.
 */

elem *el_params(elem *e1, ...)
{
    elem *e;
    va_list ap;

    e = NULL;
    for (va_start(ap, e1); e1; e1 = va_arg(ap, elem *))
    {
        e = el_param(e, e1);
    }
    va_end(ap);
    return e;
}

/*****************************************
 * Do an array of parameters as a balanced
 * binary tree.
 */

elem *el_params(void **args, int length)
{
    if (length == 0)
        return NULL;
    if (length == 1)
        return (elem *)args[0];
    int mid = length >> 1;
    return el_param(el_params(args, mid),
                    el_params(args + mid, length - mid));
}

/*****************************************
 * Do an array of parameters as a balanced
 * binary tree.
 */

elem *el_combines(void **args, int length)
{
    if (length == 0)
        return NULL;
    if (length == 1)
        return (elem *)args[0];
    int mid = length >> 1;
    return el_combine(el_combines(args, mid),
                    el_combines(args + mid, length - mid));
}

/***************************************
 * Return a list of the parameters.
 */

int el_nparams(elem *e)
{
    if (e->Eoper == OPparam)
    {
        return el_nparams(e->E1) + el_nparams(e->E2);
    }
    else
        return 1;
}

/*************************************
 * Create a quad word out of two dwords.
 */

elem *el_pair(tym_t tym, elem *lo, elem *hi)
{
#if 0
    lo = el_una(OPu32_64, TYullong, lo);
    hi = el_una(OPu32_64, TYullong, hi);
    hi = el_bin(OPshl, TYullong, hi, el_long(TYint, 32));
    return el_bin(OPor, tym, lo, hi);
#else
    return el_bin(OPpair, tym, lo, hi);
#endif
}


/*************************
 * Copy an element (not the tree!).
 */

void el_copy(elem *to,elem *from)
{
  assert(to && from);
  elem_debug(from);
  elem_debug(to);
  memcpy(to,from,elem_size);
  elem_debug(to);
}

/***********************************
 * Allocate a temporary, and return temporary elem.
 */

elem * el_alloctmp(tym_t ty)
{
  symbol *s;

  assert(MARS || !PARSER);
  s = symbol_generate(SCtmp,type_fake(ty));
  symbol_add(s);
  s->Sfl = FLtmp;
  s->Sflags = SFLfree | SFLunambig | GTregcand;
  return el_var(s);
}

/********************************
 * Select the e1 child of e.
 */

elem * el_selecte1(elem *e)
{   elem *e1;

    assert(!PARSER);
    elem_debug(e);
    assert(EOP(e));
    e1 = e->E1;
    elem_debug(e1);
    if (e->E2) elem_debug(e->E2);
    e->E1 = NULL;                               // so e1 won't be freed
    if (configv.addlinenumbers)
    {
        if (e->Esrcpos.Slinnum)
            e1->Esrcpos = e->Esrcpos;
    }
    e1->Ety = e->Ety;
//    if (tyaggregate(e1->Ety))
//      e1->Enumbytes = e->Enumbytes;
#if MARS
    if (!e1->Ejty)
        e1->Ejty = e->Ejty;
#endif
    el_free(e);
    return e1;
}

/********************************
 * Select the e2 child of e.
 */

elem * el_selecte2(elem *e)
{   elem *e2;

    //dbg_printf("el_selecte2(%p)\n",e);
    elem_debug(e);
    assert(EBIN(e));
    if (e->E1)
        elem_debug(e->E1);
    e2 = e->E2;
    elem_debug(e2);
    e->E2 = NULL;                       // so e2 won't be freed
    if (configv.addlinenumbers)
    {
        if (e->Esrcpos.Slinnum)
            e2->Esrcpos = e->Esrcpos;
    }
#if !(TARGET_MAC)
    if (PARSER)
        el_settype(e2,e->ET);
    else
    {   e2->Ety = e->Ety;
//      if (tyaggregate(e->Ety))
//          e2->Enumbytes = e->Enumbytes;
    }
#endif
    el_free(e);
    return e2;
}

/*************************
 * Create and return a duplicate of e, including its leaves.
 * No CSEs.
 */

elem * el_copytree(elem *e)
{   elem *d;

    if (!e)
        return e;
    elem_debug(e);
    d = el_calloc();
    el_copy(d,e);
    assert(!e->Ecount);
    if (SCPP && PARSER)
    {
        type_debug(d->ET);
        d->ET->Tcount++;
    }
    if (EOP(e))
    {   d->E1 = el_copytree(e->E1);
        if (EBIN(e))
                d->E2 = el_copytree(e->E2);
    }
    else
    {
        switch (e->Eoper)
        {   case OPstring:
#if 0
                if (OPTIMIZER)
                {
                    /* Convert the string to a static symbol and
                       then just refer to it, because two OPstrings can't
                       refer to the same string.
                     */

                    el_convstring(e);   // convert string to symbol
                    d->Eoper = OPrelconst;
                    d->EV.sp.Vsym = e->EV.sp.Vsym;
                    break;
                }
#endif
#if 0
            case OPrelconst:
                e->EV.sm.ethis = NULL;
                break;
#endif
#if TX86
            case OPasm:
                d->EV.ss.Vstring = (char *) mem_malloc(d->EV.ss.Vstrlen);
                memcpy(d->EV.ss.Vstring,e->EV.ss.Vstring,e->EV.ss.Vstrlen);
                break;
#else
            case OPasm:
                if (e->Eflags&EFsmasm)
                {
                    d->Eflags |= EFsmasm;
                    d->EV.mac.Vasmdat[0] = e->EV.mac.Vasmdat[0];
                    d->EV.mac.Vasmdat[1] = e->EV.mac.Vasmdat[1];
                }
                else
                {
                    debug_assert(PARSER);
                    d->EV.ss.Vstring = (char *)MEM_PH_MALLOC(d->EV.ss.Vstrlen);
                    memcpy(d->EV.ss.Vstring,e->EV.ss.Vstring,e->EV.ss.Vstrlen);
                }
                break;
#endif
        }
    }
    return d;
}

/*************************
 * Similar to el_copytree(e). But if e has any side effects, it's replaced
 * with (tmp = e) and tmp is returned.
 */

elem * el_same(elem **pe)
{   elem *e = *pe;

    if (e && el_sideeffect(e))
    {
        *pe = exp2_copytotemp(e);       /* convert to ((tmp=e),tmp)     */
        e = (*pe)->E2;                  /* point at tmp                 */
    }
    return el_copytree(e);
}

/**************************
 * Replace symbol s1 with s2 in tree.
 */

#if SCPP

void el_replace_sym(elem *e,symbol *s1,symbol *s2)
{
    symbol_debug(s1);
    symbol_debug(s2);
    while (1)
    {   elem_debug(e);
        if (EOP(e))
        {   if (EBIN(e))
                el_replace_sym(e->E2,s1,s2);
            e = e->E1;
        }
        else
        {
            switch (e->Eoper)
            {
                case OPvar:
                case OPrelconst:
                    if (e->EV.sp.Vsym == s1)
                        e->EV.sp.Vsym = s2;
                    break;
            }
            break;
        }
    }
}

#endif

/*************************************
 * Does symbol s appear in tree e?
 * Returns:
 *      1       yes
 *      0       no
 */

#if MARS

int el_appears(elem *e,Symbol *s)
{
    symbol_debug(s);
    while (1)
    {   elem_debug(e);
        if (EOP(e))
        {   if (EBIN(e) && el_appears(e->E2,s))
                return 1;
            e = e->E1;
        }
        else
        {
            switch (e->Eoper)
            {
                case OPvar:
                case OPrelconst:
                    if (e->EV.sp.Vsym == s)
                        return 1;
                    break;
            }
            break;
        }
    }
    return 0;
}

/*****************************************
 * Look for symbol that is a base of addressing mode e.
 * Returns:
 *      s       symbol used as base
 *      NULL    couldn't find a base symbol
 */

#if 0
Symbol *el_basesym(elem *e)
{   Symbol *s;

    s = NULL;
    while (1)
    {   elem_debug(e);
        switch (e->Eoper)
        {
            case OPvar:
                s = e->EV.sp.Vsym;
                break;
            case OPcomma:
                e = e->E2;
                continue;
            case OPind:
                s = el_basesym(e->E1);
                break;
            case OPadd:
                s = el_basesym(e->E1);
                if (!s)
                    s = el_basesym(e->E2);
                break;
        }
        break;
    }
    return s;
}
#endif

/****************************************
 * Does any definition of lvalue ed appear in e?
 * Returns:
 *      1       yes
 *      0       no
 */

int el_anydef(elem *ed, elem *e)
{   int op;
    int edop;
    Symbol *s;
    elem *e1;

    edop = ed->Eoper;
    s = (edop == OPvar) ? ed->EV.sp.Vsym : NULL;
    while (1)
    {
        op = e->Eoper;
        if (!OTleaf(op))
        {
            e1 = e->E1;
            if (OTdef(op))
            {
                if (e1->Eoper == OPvar && e1->EV.sp.Vsym == s)
                    return 1;

                // This doesn't cover all the cases
                if (e1->Eoper == edop && el_match(e1,ed))
                    return 1;
            }
            if (OTbinary(op) && el_anydef(ed,e->E2))
                return 1;
            e = e1;
        }
        else
            break;
    }
    return 0;
}

#endif

/************************
 * Make a binary operator node.
 */

elem * el_bint(unsigned op,type *t,elem *e1,elem *e2)
{   elem *e;

    /* e2 is NULL when OPpostinc is built       */
    assert(op < OPMAX && OTbinary(op) && e1);
    assert(PARSER);
    e = el_calloc();
    if (t)
    {   e->ET = t;
        type_debug(t);
        e->ET->Tcount++;
    }
    e->Eoper = op;
    elem_debug(e1);
    if (e2)
        elem_debug(e2);
    e->E1 = e1;
    e->E2 = e2;
    return e;
}

elem * el_bin(unsigned op,tym_t ty,elem *e1,elem *e2)
{   elem *e;

#ifdef DEBUG
    if (!(op < OPMAX && OTbinary(op) && e1 && e2))
        *(char *)0 = 0;
#endif
    assert(op < OPMAX && OTbinary(op) && e1 && e2);
    assert(MARS || !PARSER);
    elem_debug(e1);
    elem_debug(e2);
    e = el_calloc();
    e->Ety = ty;
    e->Eoper = op;
    e->E1 = e1;
    e->E2 = e2;
    if (op == OPcomma && tyaggregate(ty))
        e->ET = e2->ET;
    return e;
}

/************************
 * Make a unary operator node.
 */

elem * el_unat(unsigned op,type *t,elem *e1)
{   elem *e;

#ifdef DEBUG
    if (!(op < OPMAX && OTunary(op) && e1))
        dbg_printf("op = x%x, e1 = %p\n",op,e1);
#endif
    assert(op < OPMAX && OTunary(op) && e1);
    assert(PARSER);
    elem_debug(e1);
    e = el_calloc();
    e->Eoper = op;
    e->E1 = e1;
    if (t)
    {
        type_debug(t);
        t->Tcount++;
        e->ET = t;
    }
    return e;
}

elem * el_una(unsigned op,tym_t ty,elem *e1)
{   elem *e;

#ifdef DEBUG
    if (!(op < OPMAX && OTunary(op) && e1))
        dbg_printf("op = x%x, e1 = %p\n",op,e1);
#endif
    assert(op < OPMAX && OTunary(op) && e1);
    assert(MARS || !PARSER);
    elem_debug(e1);
    e = el_calloc();
    e->Ety = ty;
    e->Eoper = op;
    e->E1 = e1;
    return e;
}

/*******************
 * Make a constant node out of integral type.
 */

elem * el_longt(type *t,targ_llong val)
{ elem *e;

  assert(PARSER);
  e = el_calloc();
  e->Eoper = OPconst;
  e->ET = t;
  if (e->ET)
  {     type_debug(t);
        e->ET->Tcount++;
  }
  e->EV.Vllong = val;
  return e;
}

elem * el_long(tym_t t,targ_llong val)
{ elem *e;

  assert(MARS || !PARSER);
  e = el_calloc();
  e->Eoper = OPconst;
  e->Ety = t;
  switch (tybasic(t))
  {
        case TYfloat:
        case TYifloat:
            e->EV.Vfloat = val;
            break;
        case TYdouble:
        case TYidouble:
            e->EV.Vdouble = val;
            break;
        case TYldouble:
        case TYildouble:
            e->EV.Vldouble = val;
            break;
        case TYcfloat:
        case TYcdouble:
        case TYcldouble:
            assert(0);
            break;
        default:
            e->EV.Vllong = val;
            break;
  }
  return e;
}

/*******************************
 * If elem is a const that can be converted to an OPconst,
 * do the conversion.
 */

#if SCPP
void el_toconst(elem *e)
{
    elem_debug(e);
    assert(PARSER);
#if TX86
    if (e->Eoper == OPvar && e->EV.sp.Vsym->Sflags & SFLvalue)
#else
    if (e->Eoper == OPvar && e->EV.sp.Vsym->Sflags & SFLvalue &&
        tybasic(e->ET->Tty) != TYstruct)
#endif
    {   elem *es = e->EV.sp.Vsym->Svalue;

        type_debug(e->ET);
        symbol_debug(e->EV.sp.Vsym);
        elem_debug(es);
        e->Eoper = es->Eoper;
        assert(e->Eoper == OPconst);
#if TARGET_MAC
#if !DDRT
        if (tyfloating(tybasic(es->ET->Tty)))
        {
            long double ld;

            switch (tysize[tybasic(es->ET->Tty)])
            {
            case FLOATSIZE:             // TYfloat
                ld = es->EV.Vfloat;
                break;
            case DOUBLESIZE:            // TYdouble
                ld = es->EV.Vdouble;
                break;
            case LNGDBLSIZE:            // TYldouble
#ifdef LNGHDBLSIZE
            case LNGHDBLSIZE:
#endif
#if (TARGET_POWERPC)
                if (config.flags & CFGldblisdbl)
                    ld = es->EV.Vdouble;
                else
#endif
                    ld = es->EV.Vldouble;
                break;
            default:
                assert(0);
            }

            switch(tysize[tybasic(e->ET->Tty)])
            {
            case FLOATSIZE:             // TYfloat
                e->EV.Vfloat = ld;
                break;
            case DOUBLESIZE:            // TYdouble
                e->EV.Vdouble = ld;
                break;
            case LNGDBLSIZE:            // TYldouble
#ifdef LNGHDBLSIZE
            case LNGHDBLSIZE:
#endif
#if (TARGET_POWERPC)
                if (config.flags & CFGldblisdbl)
                    e->EV.Vdouble = ld;
                else
#endif
                    e->EV.Vldouble = ld;
                break;
            default:
                assert(0);
            }
        }
#else /* DDRT */
        if (tyfloating(tybasic(es->ET->Tty)))
        {
            _extended_ ld;

            switch (tysize[tybasic(es->ET->Tty)])
            {
            case FLOATSIZE:             // TYfloat
                ld = Xftox(es->EV.Vfloat);
                break;
            case DOUBLESIZE:            // TYdouble
                ld = Xdtox(es->EV.Vdouble);
                break;
            case LNGDBLSIZE:            // TYldouble
#ifdef LNGHDBLSIZE
            case LNGHDBLSIZE:
#endif
#if TARGET_POWERPC
                if (config.flags & CFGldblisdbl)
                    ld = Xdtox(es->EV.Vdouble);
                else
#endif
                    ld = es->EV.Vldouble;
                break;
            default:
                assert(0);
            }

            switch(tysize[tybasic(e->ET->Tty)])
            {
            case FLOATSIZE:             // TYfloat
                e->EV.Vfloat = Xxtof(ld);
                break;
            case DOUBLESIZE:            // TYdouble
                e->EV.Vdouble = Xxtod(ld);
                break;
            case LNGDBLSIZE:            // TYldouble
#ifdef LNGHDBLSIZE
            case LNGHDBLSIZE:
#endif
#if TARGET_POWERPC
                if (config.flags & CFGldblisdbl)
                    e->EV.Vdouble = Xxtod(ld);
                else
#endif
                    e->EV.Vldouble = ld;
                break;
            default:
                assert(0);
            }
        }
#endif /* DDRT */
        else
#endif
        {
            e->EV = es->EV;
        }
    }
}
#endif

/*******************************
 * Set new type for elem.
 */

elem * el_settype(elem *e,type *t)
{
#if MARS
    assert(0);
#else
    assert(PARSER);
    elem_debug(e);
    type_debug(t);
    type_settype(&e->ET,t);
#endif
    return e;
}

/*******************************
 * Walk tree, replacing symbol s1 with s2.
 */

#if SCPP

void el_replacesym(elem *e,symbol *s1,symbol *s2)
{
    _chkstack();

    assert(PARSER);
    while (e)
    {   elem_debug(e);
        if (EOP(e))
        {   el_replacesym(e->E2,s1,s2);
            e = e->E1;
        }
        else
        {
            if ((e->Eoper == OPvar || e->Eoper == OPrelconst) &&
                e->EV.sp.Vsym == s1)
                e->EV.sp.Vsym = s2;
            break;
        }
    }
}

#endif

/*******************************
 * Create elem that is the size of a type.
 */

elem * el_typesize(type *t)
{
#if MARS
    assert(0);
    return NULL;
#else
    assert(PARSER);
    type_debug(t);
    if (CPP && tybasic(t->Tty) == TYstruct && t->Tflags & TFsizeunknown)
    {   elem *e;

        symbol_debug(t->Ttag);
        e = el_calloc();
        e->Eoper = OPsizeof;
        e->EV.sp.Vsym = t->Ttag;
        e->ET = tssize;
        e->ET->Tcount++;
        type_debug(tssize);
        elem_debug(e);
        return e;
    }
    else if (tybasic(t->Tty) == TYarray && type_isvla(t))
    {
        type *troot = type_arrayroot(t);
        elem *en;

        en = el_nelems(t);
        return el_bint(OPmul, en->ET, en, el_typesize(troot));
    }
    else
        return el_longt(tssize,type_size(t));
#endif
}

/*****************************
 * Return an elem that evaluates to the number of elems in a type
 * (if it is an array). Returns NULL if t is not an array.
 */

#if SCPP
elem * el_nelems(type *t)
{   elem *enelems;

    assert(PARSER);
    type_debug(t);
    if (tybasic(t->Tty) == TYarray)
    {   type *ts = tssize;

        enelems = el_longt(ts, 1);
        do
        {
            if (t->Tflags & TFsizeunknown ||
                (t->Tflags & TFvla && !t->Tel))
            {   synerr(EM_unknown_size,"array");        // size of array is unknown
                t->Tflags &= ~TFsizeunknown;
            }
            else if (t->Tflags & TFvla)
            {
                enelems = el_bint(OPmul, ts, enelems, el_copytree(t->Tel));
            }
            else if (enelems->Eoper == OPconst)
            {   enelems->EV.Vllong *= t->Tdim;
                type_chksize(enelems->EV.Vllong);
            }
            else
                enelems = el_bint(OPmul, enelems->ET, enelems, el_longt(ts, t->Tdim));
            t = t->Tnext;
        } while (tybasic(t->Tty) == TYarray);
    }
    else
        enelems = NULL;
    return enelems;
}
#endif

/************************************
 * Return != 0 if function has any side effects.
 */

#if MARS

int el_funcsideeff(elem *e)
{   Symbol *s;

    if (e->Eoper == OPvar &&
        tyfunc((s = e->EV.sp.Vsym)->Stype->Tty) &&
        ((s->Sfunc && s->Sfunc->Fflags3 & Fnosideeff) || s == funcsym_p)
       )
        return 0;
    return 1;                   // assume it does have side effects
}

#endif

/****************************
 * Return != 0 if elem has any side effects.
 */

int el_sideeffect(elem *e)
{       int op;

        assert(e);
        op = e->Eoper;
        assert(op < OPMAX);
        elem_debug(e);
        return  typemask(e) & mTYvolatile ||
                OTsideff(op) ||
                (OTunary(op) && el_sideeffect(e->E1)) ||
                (OTbinary(op) && (el_sideeffect(e->E1) ||
                                      el_sideeffect(e->E2)));
}

#if TX86
/******************************
 * Input:
 *      ea      lvalue (might be an OPbit)
 * Returns:
 *      0       eb has no dependency on ea
 *      1       eb might have a dependency on ea
 *      2       eb definitely depends on ea
 */

int el_depends(elem *ea,elem *eb)
{
 L1:
    elem_debug(ea);
    elem_debug(eb);
    switch (ea->Eoper)
    {
        case OPbit:
            ea = ea->E1;
            goto L1;
        case OPvar:
        case OPind:
            break;
        default:
            assert(0);
    }
    switch (eb->Eoper)
    {
        case OPconst:
        case OPrelconst:
        case OPstring:
#if SCPP
        case OPsizeof:
#endif
            goto Lnodep;
        case OPvar:
            if (ea->Eoper == OPvar && ea->EV.sp.Vsym != eb->EV.sp.Vsym)
                goto Lnodep;
            break;
        default:
            break;      // this could use improvement
    }
    return 1;

Lnodep:
    return 0;
}
#endif

/**************************
 * Make an elem out of a symbol, PIC style.
 */

#if TARGET_OSX

elem *el_picvar(symbol *s)
{   elem *e;
    int x;

    //printf("el_picvar(s = '%s')\n", s->Sident);
    //printf("  Sclass = "); WRclass((enum SC) s->Sclass); printf("\n");
    //symbol_print(s);
    symbol_debug(s);
    type_debug(s->Stype);
    e = el_calloc();
    e->Eoper = OPvar;
    e->EV.sp.Vsym = s;
    e->Ety = s->ty();

    switch (s->Sclass)
    {
        case SCstatic:
        case SClocstat:
            x = 0;
            goto case_got;

        case SCcomdat:
        case SCcomdef:
        case SCglobal:
        case SCextern:
#if 0
            if (s->Stype->Tty & mTYthread)
                x = 0;
            else
#endif
                x = 1;
        case_got:
        {   if (!localgot)
            {
                //localgot = symbol_generate(SCtmp,type_fake(TYnptr));
                char name[15];
                static int tmpnum;
                sprintf(name, "_LOCALGOT%d", tmpnum++);
                localgot = symbol_name(name, SCtmp, type_fake(TYnptr));
                symbol_add(localgot);
                localgot->Sfl = FLtmp;
                localgot->Sflags = SFLfree | SFLunambig | GTregcand;
            }
            int op = e->Eoper;
            tym_t tym = e->Ety;
            e->Eoper = OPrelconst;
            e->Ety = TYnptr;
            e = el_bin(OPadd, TYnptr, e, el_var(localgot));
#if 1
            if (s->Stype->Tty & mTYthread)
            {
                if (!tls_get_addr_sym)
                {
                    /* void *___tls_get_addr(void *ptr);
                     * Parameter ptr is passed in EAX, matching TYjfunc calling convention.
                     */
                    tls_get_addr_sym = symbol_name("___tls_get_addr",SCglobal,type_fake(TYjfunc));
                    symbol_keep(tls_get_addr_sym);
                    slist_add(tls_get_addr_sym);
                }
                if (x == 1)
                    e = el_una(OPind, TYnptr, e);
                e = el_bin(OPcallns, TYnptr, el_var(tls_get_addr_sym), e);
                if (op == OPvar)
                    e = el_una(OPind, TYnptr, e);
            }
            else
#endif
            {
                switch (op * 2 + x)
                {
                    case OPvar * 2 + 1:
                        e = el_una(OPind, TYnptr, e);
                        e = el_una(OPind, TYnptr, e);
                        break;
                    case OPvar * 2 + 0:
                    case OPrelconst * 2 + 1:
                        e = el_una(OPind, TYnptr, e);
                        break;
                    case OPrelconst * 2 + 0:
                        break;
                    default:
                        assert(0);
                        break;
                }
            }
            e->Ety = tym;
            break;
        }
        default:
            break;
    }
    return e;
}
#endif
#if TARGET_LINUX || TARGET_FREEBSD || TARGET_SOLARIS

elem *el_picvar(symbol *s)
{   elem *e;
    int x;

    //printf("el_picvar(s = '%s')\n", s->Sident);
    symbol_debug(s);
    type_debug(s->Stype);
    e = el_calloc();
    e->Eoper = OPvar;
    e->EV.sp.Vsym = s;
    e->Ety = s->ty();

    /* For 32 bit:
     *      CALL __i686.get_pc_thunk.bx@PC32
     *      ADD  EBX,offset _GLOBAL_OFFSET_TABLE_@GOTPC[2]
     * Generate for var locals:
     *      MOV  reg,s@GOTOFF[014h][EBX]
     * For var globals:
     *      MOV  EAX,s@GOT32[EBX]
     *      MOV  reg,[EAX]
     * For TLS var locals and globals:
     *      MOV  EAX,s@TLS_GD[EBX]
     *      CALL ___tls_get_addr@PLT32
     *      MOV  reg,[EAX]
     *****************************************
     * Generate for var locals:
     *      MOV reg,s@PC32[RIP]
     * For var globals:
     *      MOV RAX,s@GOTPCREL[RIP]
     *      MOV reg,[RAX]
     * For TLS var locals and globals:
     *      0x66
     *      LEA DI,s@TLSGD[RIP]
     *      0x66
     *      0x66
     *      0x48 (REX | REX_W)
     *      CALL __tls_get_addr@PLT32
     *      MOV reg,[RAX]
     */

    if (I64)
    {
        elfobj_refGOTsym();
        switch (s->Sclass)
        {
            case SCstatic:
            case SClocstat:
                x = 0;
                goto case_got64;

            case SCcomdat:
            case SCcomdef:
            case SCglobal:
            case SCextern:
                x = 1;
            case_got64:
            {
                int op = e->Eoper;
                tym_t tym = e->Ety;
                e->Ety = TYnptr;

                if (s->Stype->Tty & mTYthread)
                {
                    /* Add "volatile" to prevent e from being common subexpressioned.
                     * This is so we can preserve the magic sequence of instructions
                     * that the gnu linker patches:
                     *   lea EDI,x@tlsgd[RIP], call __tls_get_addr@plt
                     *      =>
                     *   mov EAX,gs[0], sub EAX,x@tpoff
                     */
                    e->Eoper = OPrelconst;
                    e->Ety |= mTYvolatile;
                    if (!tls_get_addr_sym)
                    {
                        /* void *__tls_get_addr(void *ptr);
                         * Parameter ptr is passed in RDI, matching TYnfunc calling convention.
                         */
                        tls_get_addr_sym = symbol_name("__tls_get_addr",SCglobal,type_fake(TYnfunc));
                        symbol_keep(tls_get_addr_sym);
                    }
                    e = el_bin(OPcall, TYnptr, el_var(tls_get_addr_sym), e);
                }

                switch (op * 2 + x)
                {
                    case OPvar * 2 + 1:
                        e = el_una(OPind, TYnptr, e);
                        break;
                    case OPvar * 2 + 0:
                    case OPrelconst * 2 + 1:
                        break;
                    case OPrelconst * 2 + 0:
                        e = el_una(OPaddr, TYnptr, e);
                        break;
                    default:
                        assert(0);
                        break;
                }
                e->Ety = tym;
                break;
            }
            default:
                break;
        }
    }
    else
    switch (s->Sclass)
    {
        /* local (and thread) symbols get only one level of indirection;
         * all globally known symbols get two.
         */
        case SCstatic:
        case SClocstat:
            x = 0;
            goto case_got;

        case SCcomdat:
        case SCcomdef:
        case SCglobal:
        case SCextern:
            if (s->Stype->Tty & mTYthread)
                x = 0;
            else
                x = 1;
        case_got:
        {   if (!localgot)
            {
                //localgot = symbol_generate(SCtmp,type_fake(TYnptr));
                char name[15];
                static int tmpnum;
                sprintf(name, "_LOCALGOT%d", tmpnum++);
                localgot = symbol_name(name, SCtmp, type_fake(TYnptr));
                symbol_add(localgot);
                localgot->Sfl = FLtmp;
                localgot->Sflags = SFLfree | SFLunambig | GTregcand;
            }
            int op = e->Eoper;
            tym_t tym = e->Ety;
            e->Eoper = OPrelconst;
            e->Ety = TYnptr;
            e = el_bin(OPadd, TYnptr, e, el_var(localgot));

            if (s->Stype->Tty & mTYthread)
            {
                /* Add "volatile" to prevent e from being common subexpressioned.
                 * This is so we can preserve the magic sequence of instructions
                 * that the gnu linker patches:
                 *   lea EAX,x@tlsgd[EBX], call __tls_get_addr@plt
                 *      =>
                 *   mov EAX,gs[0], sub EAX,x@tpoff
                 * elf32-i386.c
                 */
                e->Ety |= mTYvolatile;
                if (!tls_get_addr_sym)
                {
                    /* void *___tls_get_addr(void *ptr);
                     * Parameter ptr is passed in EAX, matching TYjfunc calling convention.
                     */
                    tls_get_addr_sym = symbol_name("___tls_get_addr",SCglobal,type_fake(TYjfunc));
                    symbol_keep(tls_get_addr_sym);
                }
                e = el_bin(OPcall, TYnptr, el_var(tls_get_addr_sym), e);
            }

            switch (op * 2 + x)
            {
                case OPvar * 2 + 1:
                    e = el_una(OPind, TYnptr, e);
                    e = el_una(OPind, TYnptr, e);
                    break;
                case OPvar * 2 + 0:
                case OPrelconst * 2 + 1:
                    e = el_una(OPind, TYnptr, e);
                    break;
                case OPrelconst * 2 + 0:
                    break;
                default:
                    assert(0);
                    break;
            }
            e->Ety = tym;
            break;
        }
        default:
            break;
    }
    return e;
}
#endif

/**************************
 * Make an elem out of a symbol.
 */

#if MARS
elem * el_var(symbol *s)
{   elem *e;

    //printf("el_var(s = '%s')\n", s->Sident);
    //printf("%x\n", s->Stype->Tty);
#if TARGET_LINUX || TARGET_OSX || TARGET_FREEBSD || TARGET_SOLARIS
    // OSX is currently always pic
    if (config.flags3 & CFG3pic &&
#if TARGET_LINUX || TARGET_FREEBSD || TARGET_SOLARIS
        (!(s->Stype->Tty & mTYthread) || I64) &&
#endif
        !tyfunc(s->ty()))
        // Position Independent Code
        return el_picvar(s);
#endif
    symbol_debug(s);
    type_debug(s->Stype);
    e = el_calloc();
    e->Eoper = OPvar;
    e->EV.sp.Vsym = s;
    type_debug(s->Stype);
    e->Ety = s->ty();
    if (s->Stype->Tty & mTYthread)
    {
        //printf("thread local %s\n", s->Sident);
#if TARGET_OSX
        ;
#elif TARGET_LINUX || TARGET_FREEBSD || TARGET_SOLARIS
        /* For 32 bit:
         * Generate for var locals:
         *      MOV reg,GS:[00000000]   // add GS: override in back end
         *      ADD reg, offset s@TLS_LE
         *      e => *(&s + *(GS:0))
         * For var globals:
         *      MOV reg,GS:[00000000]
         *      ADD reg, s@TLS_IE
         *      e => *(s + *(GS:0))
         * note different fixup
         *****************************************
         * For 64 bit:
         * Generate for var locals:
         *      MOV reg,FS:s@TPOFF32
         * For var globals:
         *      MOV RAX,s@GOTTPOFF[RIP]
         *      MOV reg,FS:[RAX]
         *
         * For address of locals:
         *      MOV RAX,FS:[00]
         *      LEA reg,s@TPOFF32[RAX]
         *      e => &s + *(FS:0)
         * For address of globals:
         *      MOV reg,FS:[00]
         *      MOV RAX,s@GOTTPOFF[RIP]
         *      ADD reg,RAX
         *      e => s + *(FS:0)
         * This leaves us with a problem, as the 'var' version cannot simply have
         * its address taken, as what is the address of FS:s ? The (not so efficient)
         * solution is to just use the second address form, and * it.
         * Turns out that is identical to the 32 bit version, except GS => FS and the
         * fixups are different.
         * In the future, we should figure out a way to optimize to the 'var' version.
         */
        if (I64)
            elfobj_refGOTsym();
        elem *e1 = el_calloc();
        e1->EV.sp.Vsym = s;
        if (s->Sclass == SCstatic || s->Sclass == SClocstat)
        {   e1->Eoper = OPrelconst;
            e1->Ety = TYnptr;
        }
        else
        {
            e1->Eoper = OPvar;
            e1->Ety = TYnptr;
        }

        /* Fake GS:[0000] as a load of _tls_array, and then in the back end recognize
         * the fake and rewrite it as GS:[0000] (or FS:[0000] for I64), because there is
         * no way to represent segment overrides in the elem nodes.
         */
        elem *e2 = el_calloc();
        e2->Eoper = OPvar;
        e2->EV.sp.Vsym = rtlsym[RTLSYM_TLS_ARRAY];
        e2->Ety = e2->EV.sp.Vsym->ty();

        e->Eoper = OPind;
        e->E1 = el_bin(OPadd,e1->Ety,e2,e1);
        e->E2 = NULL;
#else
        /*
                mov     EAX,FS:__tls_array
                mov     ECX,__tls_index
                mov     EAX,[ECX*4][EAX]
                inc     dword ptr _t[EAX]

                e => *(&s + *(FS:_tls_array + _tls_index * 4))

                If this is an executable app, not a dll, _tls_index
                can be assumed to be 0.
         */
        elem *e1,*e2,*ea;

        e1 = el_calloc();
        e1->Eoper = OPrelconst;
        e1->EV.sp.Vsym = s;
        e1->Ety = TYnptr;

        if (config.wflags & WFexe)
        {
            // e => *(&s + *(FS:_tls_array))
            e2 = el_var(rtlsym[RTLSYM_TLS_ARRAY]);
        }
        else
        {
            e2 = el_bin(OPmul,TYint,el_var(rtlsym[RTLSYM_TLS_INDEX]),el_long(TYint,4));
            ea = el_var(rtlsym[RTLSYM_TLS_ARRAY]);
            e2 = el_bin(OPadd,ea->Ety,ea,e2);
        }
        e2 = el_una(OPind,TYint,e2);

        e->Eoper = OPind;
        e->E1 = el_bin(OPadd,e1->Ety,e1,e2);
        e->E2 = NULL;
#endif
    }
    return e;
}
#elif SCPP
elem * el_var(symbol *s)
{   elem *e;

    //printf("el_var(s = '%s')\n", s->Sident);
#if TARGET_LINUX || TARGET_OSX || TARGET_FREEBSD || TARGET_SOLARIS
    if (config.flags3 & CFG3pic && !tyfunc(s->ty()))
        return el_picvar(s);
#endif
    symbol_debug(s);
    type_debug(s->Stype);
    e = el_calloc();
    e->Eoper = OPvar;
    e->EV.sp.Vsym = s;
    if (SCPP && PARSER)
#if TX86 && TARGET_WINDOS
    {   type *t = s->Stype;

        type_debug(t);
        e->ET = t;
        t->Tcount++;
        switch (t->Tty & (mTYimport | mTYthread))
        {   case mTYimport:
                obj_import(e);
                break;
            case mTYthread:
        /*
                mov     EAX,FS:__tls_array
                mov     ECX,__tls_index
                mov     EAX,[ECX*4][EAX]
                inc     dword ptr _t[EAX]

                e => *(&s + *(FS:_tls_array + _tls_index * 4))
         */
#if MARS
                assert(0);
#else
            {   elem *e1,*e2,*ea;

                e1 = el_calloc();
                e1->Eoper = OPrelconst;
                e1->EV.sp.Vsym = s;
                e1->ET = newpointer(s->Stype);
                e1->ET->Tcount++;

                e2 = el_bint(OPmul,tsint,el_var(rtlsym[RTLSYM_TLS_INDEX]),el_longt(tsint,4));
                ea = el_var(rtlsym[RTLSYM_TLS_ARRAY]);
                e2 = el_bint(OPadd,ea->ET,ea,e2);
                e2 = el_unat(OPind,tsint,e2);

                e->Eoper = OPind;
                e->E1 = el_bint(OPadd,e1->ET,e1,e2);
                e->E2 = NULL;
            }
#endif
                break;
            case mTYthread | mTYimport:
                assert(SCPP);
#if SCPP
                tx86err(EM_thread_and_dllimport,s->Sident);     // can't be both thread and import
#endif
                break;
        }
    }
#else
    {   type_debug(s->Stype);
        e->ET = s->Stype;
        e->ET->Tcount++;
    }
#endif
    else
        e->Ety = s->ty();
    return e;
}
#endif

/**************************
 * Make a pointer to an elem out of a symbol.
 */

elem * el_ptr(symbol *s)
{
    elem *e;

    //printf("el_ptr(s = '%s')\n", s->Sident);
    //printf("el_ptr\n");
    symbol_debug(s);
    type_debug(s->Stype);
#if TARGET_OSX
    if (config.flags3 & CFG3pic && tyfunc(s->ty()))
    {
        /* Cannot access address of code from code.
         * Instead, create a data variable, put the address of the
         * code in that data variable, and return the elem for
         * that data variable.
         */
        symbol *sd = symboldata(Doffset, TYnptr);
        Doffset += reftoident(DATA, Doffset, s, 0, CFoff);
        e = el_picvar(sd);
        return e;
    }
#endif
#if TARGET_LINUX || TARGET_OSX || TARGET_FREEBSD || TARGET_SOLARIS
    if (config.flags3 & CFG3pic && tyfunc(s->ty()))
        e = el_picvar(s);
    else
#endif
        e = el_var(s);
#if SCPP
    if (PARSER)
    {   type_debug(e->ET);
        e = el_unat(OPaddr,type_ptr(e,e->ET),e);
    }
    else
#endif
    if (e->Eoper == OPvar)
    {
        e->Ety = TYnptr;
        e->Eoper = OPrelconst;
    }
    else
    {   e = el_una(OPaddr, TYnptr, e);
        e = doptelem(e, GOALvalue | GOALflags);
    }
    return e;
}

/**************************
 * Make a pointer to an elem out of a symbol at offset.
 */

#if SCPP

elem * el_ptr_offset(symbol *s,targ_size_t offset)
{   elem *e;
    elem *e1;

    e = el_ptr(s);      /* e is an elem which is a pointer to s */
    e1 = e->E1;
    if (e1->Eoper == OPvar)
        ;
    // The following case happens if symbol s is in thread local storage
    else if (e1->Eoper == OPind &&
             e1->E1->Eoper == OPadd &&
             e1->E1->E1->Eoper == OPrelconst)
        e1 = e1->E1->E1;
    else
        assert(0);
    assert(e1->EV.sp.Vsym == s);
    e1->EV.sp.Voffset = offset;
    return e;
}

#endif

/*************************
 * Returns:
 *      !=0     elem evaluates right-to-left
 *      0       elem evaluates left-to-right
 */

HINT ERTOL(elem *e)
{
    elem_debug(e);
    assert(!PARSER);
#if TX86
    return OTrtol(e->Eoper) &&
        (!OTopeq(e->Eoper) || config.inline8087 || !tyfloating(e->Ety));
#else
    return OTrtol(e->Eoper);
#endif
}

/********************************
 * Return !=0 if expression never returns.
 * Does not detect all cases, errs on the side of saying it returns.
 */

int el_noreturn(elem *e)
{   int result = 0;

    while (1)
    {   elem_debug(e);
        switch (e->Eoper)
        {   case OPcomma:
                if (result |= el_noreturn(e->E1))
                    break;
                e = e->E2;
                continue;

            case OPcall:
            case OPucall:
                e = e->E1;
                if (e->Eoper == OPvar && e->EV.sp.Vsym->Sflags & SFLexit)
                    result = 1;
                break;

            case OPhalt:
                result = 1;
                break;

            default:
                break;
        }
        break;
    }
    return result;
}

/********************************
 * Scan down commas and return the controlling elem.
 */

elem *el_scancommas(elem *e)
{
    while (e->Eoper == OPcomma)
        e = e->E2;
    return e;
}

/***************************
 * Count number of commas in the expression.
 */

int el_countCommas(elem *e)
{   int ncommas = 0;
    while (1)
    {
        if (EBIN(e))
        {
            ncommas += (e->Eoper == OPcomma) + el_countCommas(e->E2);
        }
        else if (EUNA(e))
        {
        }
        else
            break;
        e = e->E1;
    }
    return ncommas;
}

#if (TARGET_POWERPC)
void el_convconst(elem *e)
{

    int i;
    symbol *s;
    long    *   p;
    targ_size_t len;
    struct CONST_VALUE {
#if !DDRT
        long    val[2];                 // Largest floating constant is 8 bytes
#else
        fix!!
#endif
        symbol  *s;                     // Symbol for that floating constant
    } *pcv;

    static list_t value_list;
    list_t pcl;

    tym_t       tym;
    type * T;
//    float cnv_float;  // the compiler stores all constants in double accuracy
                        // hence when the elem is of type TYfloat we have to
                        // implicitly convert it from double to float
    assert(!PARSER);
    elem_debug(e);

    assert(e->Eoper == OPconst);


    tym = tybasic(typemask(e));

    assert(tyfloating(tym));    // it shouldn't get here otherwise....

#if !DDRT
        // all float constants are stored as doubles
        // NOTE at this point double and long double are the same (11/18/93 -udi-)
        if (tym == TYdouble || tym == TYldouble) {
//              tym = TYdouble;
                p = (long *) &e->EV.Vdouble;
        } else {
                p = (long *) &e->EV.Vfloat;

//              cnv_float = e->EV.Vdouble;
//              p = (long *) & cnv_float;
        }

#else
        fix!!
#endif




//
// Look for another floating constant with the identical value
// linear list should be fast enough, How many floating constants are there
// that appear in trees.  Any that appear in data declarations, etc. are already
// taken care of elsewhere
//
        for (pcl = value_list;pcl; pcl = list_next(pcl)) {
            pcv = (CONST_VALUE *) list_ptr( pcl );
            if (tysize[tym] == type_size(pcv->s->Stype) &&
                !memcmp( pcv->val, p, tysize[tym])) {
                s = pcv->s;
                goto returnelem;
            }
        }

    // Replace float with a symbol that refers to a float constant stored
    // in the DATA segment

        tym |= mTYconst;
        T = type_alloc( tym );
        s = symbol_generate( SCstatic, T);
        s->Sfl = FLdatseg;

        pcv = (CONST_VALUE *) MEM_PARC_CALLOC(sizeof(CONST_VALUE));
        memcpy( pcv->val, p, type_size(T));
        pcv->s = s;
        list_append( &value_list, pcv );

        obj_module( s, STYP_DATA, 0 );
        obj_bytes( STYP_DATA, type_size(T), p);


        // NOTE: unlike el_convstring() i'm not implementing any machinery for
        // remembering already defined constant floats. on a rare occasion that
        // may create duplications, however i don't think it warrants the extra
        // effort. should it become necessary, i'll do it. (-udi-  11/7/93)

returnelem:
    // Refer e to the symbol generated
    e->Ety = tym;
    e->Eoper = OPvar;
    e->EV.sp.Vsym = s;
    e->EV.sp.Voffset = 0;       // making sure no remnants of the float constat
                                // appear as some kind of offset into the var
}       // el_convconst
#endif

/************************************
 * Convert floating point constant to a read-only symbol.
 * Needed iff floating point code can't load immediate constants.
 */

elem *el_convfloat(elem *e)
{
    unsigned char buffer[32];

#if TX86
    assert(config.inline8087);

    // Do not convert if the constants can be loaded with the special FPU instructions
    if (tycomplex(e->Ety))
    {
        if (loadconst(e, 0) && loadconst(e, 1))
            return e;
    }
    else if (loadconst(e, 0))
        return e;

    changes++;
    tym_t ty = e->Ety;
    int sz = tysize(ty);
    assert(sz <= sizeof(buffer));
    void *p;
    switch (tybasic(ty))
    {
        case TYfloat:
        case TYifloat:
            p = &e->EV.Vfloat;
            assert(sz == sizeof(e->EV.Vfloat));
            break;

        case TYdouble:
        case TYidouble:
        case TYdouble_alias:
            p = &e->EV.Vdouble;
            assert(sz == sizeof(e->EV.Vdouble));
            break;

        case TYldouble:
        case TYildouble:
            /* The size, alignment, and padding of long doubles may be different
             * from host to target
             */
            p = buffer;
            memset(buffer, 0, sz);                      // ensure padding is 0
            memcpy(buffer, &e->EV.Vldouble, 10);
            break;

        case TYcfloat:
            p = &e->EV.Vcfloat;
            assert(sz == sizeof(e->EV.Vcfloat));
            break;

        case TYcdouble:
            p = &e->EV.Vcdouble;
            assert(sz == sizeof(e->EV.Vcdouble));
            break;

        case TYcldouble:
            p = buffer;
            memset(buffer, 0, sz);
            memcpy(buffer, &e->EV.Vcldouble.re, 10);
            memcpy(buffer + tysize(TYldouble), &e->EV.Vcldouble.im, 10);
            break;

        default:
            assert(0);
    }
#if 0
    printf("%gL+%gLi\n", (double)e->EV.Vcldouble.re, (double)e->EV.Vcldouble.im);
    printf("el_convfloat() %g %g sz=%d\n", e->EV.Vcdouble.re, e->EV.Vcdouble.im, sz);
printf("el_convfloat(): sz = %d\n", sz);
unsigned short *p = (unsigned short *)&e->EV.Vcldouble;
for (int i = 0; i < sz/2; i++) printf("%04x ", p[i]);
printf("\n");
#endif
    symbol *s  = out_readonly_sym(ty, p, sz);
    el_free(e);
    e = el_var(s);
    e->Ety = ty;
    if (e->Eoper == OPvar)
        e->Ety |= mTYconst;
    //printf("s: %s %d:x%x\n", s->Sident, s->Sseg, s->Soffset);
#endif
    return e;
}

/********************************
 * Convert reference to a string to reference to a symbol
 * stored in the static data segment.
 */

elem *el_convstring(elem *e)
{
    //printf("el_convstring()\n");
    int i;
    symbol *s;
    char *p;
    targ_size_t len;

    assert(!PARSER);
    elem_debug(e);
    assert(e->Eoper == OPstring);
    p = e->EV.ss.Vstring;
    e->EV.ss.Vstring = NULL;
    len = e->EV.ss.Vstrlen;

#if TX86
    // Handle strings that go into the code segment
    if (tybasic(e->Ety) == TYcptr ||
        (tyfv(e->Ety) && config.flags3 & CFG3strcod))
    {
        assert(OMFOBJ);         // option not done yet for others
        s = symbol_generate(SCstatic, type_fake(mTYcs | e->Ety));
        s->Sfl = FLcsdata;
        s->Soffset = Coffset;
        s->Sseg = cseg;
        symbol_keep(s);
        if (!eecontext.EEcompile || eecontext.EEin)
        {   obj_bytes(cseg,Coffset,len,p);
            Coffset += len;
        }
        mem_free(p);
        goto L1;
    }
#endif

#if TARGET_68K
    /*
     * When using PC relative strings, strings cannot be saved because this
     * would lead to problems.  We do not know how to emit PC-relative
     * relocations for stuff in other functions.
     */
    if (!(PCrel_option & PC_STRINGS))
#endif

    if (eecontext.EEin)                 // if compiling debugger expression
    {
        s = out_readonly_sym(e->Ety, p, len);
        mem_free(p);
        goto L1;
    }

    // See if e is already in the string table
    for (i = 0; i < arraysize(stable); i++)
    {   if (stable[i].len == len &&
            memcmp(stable[i].p,p,len) == 0)
        {
            // Replace e with that symbol
            MEM_PH_FREE(p);
            s = stable[i].sym;
            goto L1;
        }
    }

    // Replace string with a symbol that refers to that string
    // in the DATA segment

#if TX86
    if (eecontext.EEcompile)
        s = symboldata(Doffset,e->Ety);
    else
        s = out_readonly_sym(e->Ety,p,len);

    // Remember the string for possible reuse later
    //dbg_printf("Adding %d, '%s'\n",stable_si,p);
    mem_free(stable[stable_si].p);
    stable[stable_si].p   = p;
    stable[stable_si].len = len;
    stable[stable_si].sym = s;
    stable_si = (stable_si + 1) & (arraysize(stable) - 1);

#else
#if TARGET_POWERPC
    s = symbol_generate( SCstatic, obj_charstr_type(len));
    s->Sfl = FLdatseg;
    obj_module( s, STYP_DATA, 0 );
    obj_bytes( STYP_DATA, len, p );
#else
    s = symboldata(Doffset,e->Ety);
#if TARGET_68K
    if (PCrel_option & PC_STRINGS)
    {   s = symbol_generate(SCstatic,type_fake(e->Ety));
        s->Sfl = FLoffset;              // relative offset from code
        symbol_keep(s);
        s->Sidnum = obj_PCrel_start();
        for (i=0; i<len; ++i)
            obj_PCrel_byte(p[i]);
    }
    else
#endif
    {   s->Sfl = FLdatseg;              // string in data segment
        s->Sidnum = obj_module(DATA,SClocstat,0);
        obj_bytes(DATA,0,len,p);
    }
#endif

#if TARGET_68K
    /*
     * When using PC relative strings, strings cannot be saved because this
     * would lead to problems.  We do not know how to emit PC-relative
     * relocations for stuff in other functions.
     */
    if (!(PCrel_option & PC_STRINGS))
#endif
    {
        // Remember the string for possible reuse later
        //dbg_printf("Adding %d, '%s'\n",stable_si,p);
        MEM_PH_FREE(stable[stable_si].p);
        stable[stable_si].p   = p;
        stable[stable_si].len = len;
        stable[stable_si].sym = s;
        stable_si = (stable_si + 1) & (arraysize(stable) - 1);
    }
#endif

L1:
    // Refer e to the symbol generated
    elem *ex = el_ptr(s);
    ex->Ety = e->Ety;
    if (e->EV.ss.Voffset)
    {
        if (ex->Eoper == OPrelconst)
             ex->EV.sp.Voffset += e->EV.ss.Voffset;
        else
             ex = el_bin(OPadd, ex->Ety, ex, el_long(TYint, e->EV.ss.Voffset));
    }
    el_free(e);
    return ex;
}

/********************************************
 * If e is a long double constant, and it is perfectly representable as a
 * double constant, convert it to a double constant.
 * Note that this must NOT be done in contexts where there are no further
 * operations, since then it could change the type (eg, in the function call
 * printf("%La", 2.0L); the 2.0 must stay as a long double).
 */
#if 1
void shrinkLongDoubleConstantIfPossible(elem *e)
{
    if (e->Eoper == OPconst && e->Ety == TYldouble)
    {
        /* Check to see if it can be converted into a double (this happens
         * when the low bits are all zero, and the exponent is in the
         * double range).
         * Use 'volatile' to prevent optimizer from folding away the conversions,
         * and thereby missing the truncation in the conversion to double.
         */
        volatile long double v = e->EV.Vldouble;
        volatile double vDouble;
        volatile double z = v;
        *(&vDouble) = v;
        if (v == vDouble)       // This will fail if compiler does NaN incorrectly!
        {
            // Yes, we can do it!
            e->EV.Vdouble = vDouble;
            e->Ety = TYdouble;
        }
    }
}
#endif


/*************************
 * Run through a tree converting it to CODGEN.
 */

elem *el_convert(elem *e)
{   int op;

    //printf("el_convert(%p)\n", e);
    elem_debug(e);
    op = e->Eoper;
    switch (op)
    {
        case OPvar:
            break;

        case OPconst:
#if TX86
            if (tyfloating(e->Ety) && config.inline8087)
                e = el_convfloat(e);
#endif
            break;

        case OPstring:
            changes++;
            e = el_convstring(e);
            break;

        case OPnullptr:
            e = el_long(e->Ety, 0);
            break;

        case OPmul:
            /* special floating-point case: allow x*2 to be x+x
             * in this case, we preserve the constant 2.
             */
            if (tyreal(e->Ety) &&       // don't bother with imaginary or complex
                e->E2->Eoper == OPconst && el_toldouble(e->E2) == 2.0L)
            {
                e->E1 = el_convert(e->E1);
                /* Don't call el_convert(e->E2), we want it to stay as a constant
                 * which will be detected by code gen.
                 */
                break;
            }
#if 1
        case OPdiv:
        case OPadd:
        case OPmin:
            // For a*b,a+b,a-b,a/b, if a long double constant is involved, convert it to a double constant.
            if (tyreal(e->Ety))
                 shrinkLongDoubleConstantIfPossible(e->E1);
            if (tyreal(e->Ety))
                shrinkLongDoubleConstantIfPossible(e->E2);
            // fall through...
#endif
        default:
            if (OTbinary(op))
            {
                e->E1 = el_convert(e->E1);
                e->E2 = el_convert(e->E2);
            }
            else if (OTunary(op))
            {
                e->E1 = el_convert(e->E1);
            }
            break;
    }
    return e;
}


/************************
 * Make a constant elem.
 *      ty      = type of elem
 *      *pconst = union of constant data
 */

elem * el_const(tym_t ty,union eve *pconst)
{   elem *e;

    assert(MARS || !PARSER);
    e = el_calloc();
    e->Eoper = OPconst;
    e->Ety = ty;
    memcpy(&e->EV,pconst,sizeof(e->EV));
    return e;
}

#if SCPP

/**************************
 * Insert constructor information into tree.
 */

elem *el_ctor(elem *ector,elem *e,symbol *sdtor)
{
    //printf("el_ctor(ector = %p, e = %p, sdtor = %p)\n", ector, e, sdtor);
    //printf("stdor = '%s'\n", cpp_prettyident(sdtor));
    //printf("e:\n"); elem_print(e);
    if (ector)
    {
        if (sdtor)
        {
            if (sdtor->Sfunc->Fbody)
            {
                n2_instantiate_memfunc(sdtor);
            }
            // Causes symbols to be written out prematurely when
            // writing precompiled headers.
            // Moved to outelem().
            //nwc_mustwrite(sdtor);
        }
        if (!sdtor || ector->Eoper == OPcall ||
            (ector->Eoper == OPrelconst && !(sytab[ector->EV.sp.Vsym->Sclass] & SCSS))
#if TX86
            // Not ambient memory model
            || (tyfarfunc(sdtor->ty()) ? !LARGECODE : LARGECODE)
#endif
           )
        {
            el_free(ector);
        }
        else
        {
            ector = el_unat(OPctor,ector->ET,ector);
            symbol_debug(sdtor);
            ector->EV.eop.Edtor = sdtor;
            symbol_debug(sdtor);
            if (e)
                e = el_bint(OPinfo,e->ET,ector,e);
            else
                e = ector;
        }
    }
    return e;
}

/**************************
 * Insert destructor information into tree.
 */

elem *el_dtor(elem *edtor,elem *e)
{
    if (edtor)
    {
        edtor = el_unat(OPdtor,edtor->ET,edtor);
        if (e)
            e = el_bint(OPcomma,e->ET,edtor,e);
        else
            e = edtor;
    }
    return e;
}

#endif

/**********************************
 * Create an elem of the constant 0, of the type t.
 */

elem *el_zero(type *t)
{
        elem *e;

        assert(PARSER);

        e = el_calloc();
        e->Eoper = OPconst;
        e->ET = t;
        if (t)
        {
            type_debug(t);
            e->ET->Tcount++;
        }
        return(e);
}

/*******************
 * Find and return pointer to parent of e starting at *pe.
 * Return NULL if can't find it.
 */

elem ** el_parent(elem *e,elem **pe)
{
  assert(e && pe && *pe);
  elem_debug(e);
  elem_debug(*pe);
  if (e == *pe)
        return pe;
  else if (OTunary((*pe)->Eoper))
        return el_parent(e,&((*pe)->E1));
  else if (OTbinary((*pe)->Eoper))
  {     elem **pe2;

        return ((pe2 = el_parent(e,&((*pe)->E1))) != 0) ? pe2
                                                 : el_parent(e,&((*pe)->E2));
  }
  else
        return NULL;
}

/*******************************
 * Return !=0 if trees match.
 */

static int gmatch2;                     // kludge for el_match2()

int el_match(elem *n1,elem *n2)
{   unsigned op;
    tym_t tym,tym2;

L1:
    if (n1 == n2)
        return TRUE;
    if (!n1 || !n2)
        goto nomatch;
    elem_debug(n1);
    elem_debug(n2);

    if ((op = n1->Eoper) != n2->Eoper)
        goto nomatch;

    if ((tym = typemask(n1)) != (tym2 = typemask(n2)))
    {
#if TX86
        if ((tym & ~mTYbasic) != (tym2 & ~mTYbasic))
#else
        if ((tym & ~mTYbasic & ~mTYMAN) != (tym2 & ~mTYbasic & ~mTYMAN))
#endif
        {
            if (!(gmatch2 & 2))
                goto nomatch;
        }
        tym = tybasic(tym);
        tym2 = tybasic(tym2);
        if (tyequiv[tym] != tyequiv[tym2])
            goto nomatch;
    }

  if (OTunary(op))
  {
    L2:
        if (PARSER)
        {
            n1 = n1->E1;
            n2 = n2->E1;
            assert(n1 && n2);
            goto L1;
        }
        else if (OPTIMIZER)
        {
            if (op == OPstrpar || op == OPstrctor)
            {   if (/*n1->Enumbytes != n2->Enumbytes ||*/ n1->ET != n2->ET)
                    goto nomatch;
            }
            n1 = n1->E1;
            n2 = n2->E1;
            assert(n1 && n2);
            goto L1;
        }
        else
        {
            if (n1->E1 == n2->E1)
                goto ismatch;
            n1 = n1->E1;
            n2 = n2->E1;
            assert(n1 && n2);
            goto L1;
        }
  }
  else if (OTbinary(op))
  {
        if (!PARSER)
        {
            if (op == OPstreq)
            {   if (/*n1->Enumbytes != n2->Enumbytes ||*/ n1->ET != n2->ET)
                    goto nomatch;
            }
        }
        if (el_match(n1->E2,n2->E2))
        {
            goto L2;    // check left tree
        }
        goto nomatch;
  }
  else /* leaf elem */
  {     unsigned n;

        switch (op)
        {
            case OPconst:
                if (gmatch2 & 1)
                    break;
            Lagain:
                switch (tybasic(tym))
                {
                    case TYshort:
                    case TYwchar_t:
                    case TYushort:
                    case TYchar16:
                    case_short:
                        if (n1->EV.Vshort != n2->EV.Vshort)
                                goto nomatch;
                        break;
                    case TYlong:
                    case TYulong:
                    case TYdchar:
#if TARGET_MAC
                    case TYfptr:
                    case TYvptr:
#endif
                    case_long:
                        if (n1->EV.Vlong != n2->EV.Vlong)
                                goto nomatch;
                        break;
                    case TYllong:
                    case TYullong:
                    case_llong:
                        if (n1->EV.Vllong != n2->EV.Vllong)
                                goto nomatch;
                        break;
                    case TYcent:
                    case TYucent:
                        if (n1->EV.Vcent.lsw != n2->EV.Vcent.lsw ||
                            n1->EV.Vcent.msw != n2->EV.Vcent.msw)
                                goto nomatch;
                        break;
                    case TYenum:
                        if (PARSER)
                        {   tym = n1->ET->Tnext->Tty;
                            goto Lagain;
                        }
                    case TYint:
                    case TYuint:
                        if (intsize == SHORTSIZE)
                            goto case_short;
                        else
                            goto case_long;

#if TX86
#if JHANDLE
                    case TYjhandle:
#endif
                    case TYnullptr:
                    case TYnptr:
                    case TYsptr:
                    case TYcptr:
                        if (NPTRSIZE == SHORTSIZE)
                            goto case_short;
                        else if (NPTRSIZE == LONGSIZE)
                            goto case_long;
                        else
                        {   assert(NPTRSIZE == LLONGSIZE);
                            goto case_llong;
                        }
#endif

                    case TYbool:
                    case TYchar:
                    case TYuchar:
                    case TYschar:
                        if (n1->EV.Vschar != n2->EV.Vschar)
                                goto nomatch;
                        break;
#if TX86
                    case TYfptr:
                    case TYhptr:
                    case TYvptr:

                        /* Far pointers on the 386 are longer than
                           any integral type...
                         */
                        if (memcmp(&n1->EV,&n2->EV,tysize[tybasic(tym)]))
                            goto nomatch;
                        break;
#endif
#if !DDRT
                        /* Compare bit patterns w/o worrying about
                           exceptions, unordered comparisons, etc.
                         */
                    case TYfloat:
                    case TYifloat:
                        if (memcmp(&n1->EV,&n2->EV,sizeof(n1->EV.Vfloat)))
                            goto nomatch;
                        break;

                    case TYdouble:
                    case TYdouble_alias:
                    case TYidouble:
                        if (memcmp(&n1->EV,&n2->EV,sizeof(n1->EV.Vdouble)))
                            goto nomatch;
                        break;

                    case TYldouble:
                    case TYildouble:
#if LNGDBLSIZE > 10
                        /* sizeof is 12, but actual size is 10 */
                        if (memcmp(&n1->EV,&n2->EV,10))
#else
                        if (memcmp(&n1->EV,&n2->EV,sizeof(n1->EV.Vldouble)))
#endif
                            goto nomatch;
                        break;

                    case TYcfloat:
                        if (memcmp(&n1->EV,&n2->EV,sizeof(n1->EV.Vcfloat)))
                            goto nomatch;
                        break;

                    case TYcdouble:
                        if (memcmp(&n1->EV,&n2->EV,sizeof(n1->EV.Vcdouble)))
                            goto nomatch;
                        break;

                    case TYcldouble:
#if LNGDBLSIZE > 10
                        /* sizeof is 12, but actual size of each part is 10 */
                        if (memcmp(&n1->EV,&n2->EV,10) ||
                            memcmp(&n1->EV.Vldouble + 1, &n2->EV.Vldouble + 1, 10))
#else
                        if (memcmp(&n1->EV,&n2->EV,sizeof(n1->EV.Vcldouble)))
#endif
                            goto nomatch;
                        break;
#else /* DDRT */
                    case TYfloat:
                        if (memcmp(&n1->EV.Vfloat,&n2->EV.Vfloat,FLOATSIZE))
                            goto nomatch;
                        break;
                    case TYdouble:
                        if (memcmp(&n1->EV.Vdouble,&n2->EV.Vdouble,DOUBLESIZE))
                            goto nomatch;
                    case TYldouble:
#if TARGET_POWERPC
                        if (config.flags & CFGldblisdbl)
                        {
                            if (memcmp(&n1->EV.Vdouble,&n2->EV.Vdouble,DOUBLESIZE))
                                goto nomatch;
                        }
                        else
#endif
                        if (memcmp(&n1->EV.Vldouble,&n2->EV.Vldouble,LNGDBLSIZE))
                                goto nomatch;
                        break;
#endif /* DDRT */
                    case TYvoid:
                        break;                  // voids always match
#if SCPP
                    case TYident:
                        assert(errcnt);
                        goto nomatch;
#endif
                    default:
#ifdef DEBUG
                        elem_print(n1);
#endif
                        assert(0);
                }
                break;
            case OPrelconst:
            case OPvar:
#if SCPP
            case OPsizeof:
#endif
                symbol_debug(n1->EV.sp.Vsym);
                symbol_debug(n2->EV.sp.Vsym);
                if (n1->EV.sp.Voffset != n2->EV.sp.Voffset)
                    goto nomatch;
#if SCPP
                if (gmatch2 & 4)
                {
#if 0
                    printf("------- symbols ---------\n");
                    symbol_print(n1->EV.sp.Vsym);
                    symbol_print(n2->EV.sp.Vsym);
                    printf("\n");
#endif
                    if (/*strcmp(n1->EV.sp.Vsym->Sident, n2->EV.sp.Vsym->Sident) &&*/
                        n1->EV.sp.Vsym != n2->EV.sp.Vsym &&
                        (!n1->EV.sp.Vsym->Ssequence || n1->EV.sp.Vsym->Ssequence != n2->EV.sp.Vsym->Ssequence))
                        goto nomatch;
                }
                else
#endif
                {
                    if (n1->EV.sp.Vsym != n2->EV.sp.Vsym)
                        goto nomatch;
                }
                break;
            case OPasm:
#if TARGET_MAC
                if ((n1->Eflags&EFsmasm && !(n2->Eflags&EFsmasm)) ||
                    (n2->Eflags&EFsmasm && !(n1->Eflags&EFsmasm)) ||
                    (n1->EV.mac.Vasmdat[0] != n2->EV.mac.Vasmdat[0]) ||
                   (n1->EV.mac.Vasmdat[1] != n2->EV.mac.Vasmdat[1]) )
                        goto nomatch;
                if (n1->Eflags&EFsmasm)
                        break;          /* flags & data match,otherwise check strings */
#endif
            case OPstring:
            case OPhstring:
                if (n1->EV.ss.Vstrlen != (n = n2->EV.ss.Vstrlen) ||
                    n1->EV.ss.Voffset != n2->EV.ss.Voffset ||
                    memcmp(n1->EV.ss.Vstring,n2->EV.ss.Vstring,n))
                        goto nomatch;   /* check bytes in the string    */
                break;
            case OPstrthis:
            case OPframeptr:
            case OPhalt:
            case OPgot:
                break;
#if SCPP
            case OPmark:
                break;
#endif
            default:
#ifdef DEBUG
                WROP(op);
#endif
                assert(0);
        }
ismatch:
        return TRUE;
  }
  assert(0);
  /* NOTREACHED */

nomatch:
  return FALSE;
}

/*********************************
 * Kludge on el_match(). Same, but ignore differences in OPconst.
 */

int el_match2(elem *n1,elem *n2)
{   int result;

    gmatch2 = 1;
    result = el_match(n1,n2);
    gmatch2 = 0;
    return result;
}

/*********************************
 * Kludge on el_match(). Same, but ignore differences in type modifiers.
 */

int el_match3(elem *n1,elem *n2)
{   int result;

    gmatch2 = 2;
    result = el_match(n1,n2);
    gmatch2 = 0;
    return result;
}

/*********************************
 * Kludge on el_match(). Same, but ignore differences in spelling of var's.
 */

int el_match4(elem *n1,elem *n2)
{   int result;

    gmatch2 = 2|4;
    result = el_match(n1,n2);
    gmatch2 = 0;
    return result;
}

/******************************
 * Extract long value from constant parser elem.
 */

targ_llong el_tolongt(elem *e)
{   targ_llong result;
    char parsersave = PARSER;

    PARSER = 1;
    result = el_tolong(e);
    PARSER = parsersave;
    return result;
}

/******************************
 * Extract long value from constant elem.
 */

targ_llong el_tolong(elem *e)
{   targ_llong result;
    tym_t ty;

    elem_debug(e);
#if SCPP
    if (e->Eoper == OPsizeof)
    {
        e->Eoper = OPconst;
        e->EV.Vllong = type_size(e->EV.sp.Vsym->Stype);
    }
#endif
#ifdef DEBUG
    if (e->Eoper != OPconst)
        elem_print(e);
#endif
    assert(e->Eoper == OPconst);
    ty = tybasic(typemask(e));
L1:
    switch (ty)
    {
        case TYchar:
            if (config.flags & CFGuchar)
                goto Uchar;
            /* FALL-THROUGH */
        case TYschar:
            result = e->EV.Vschar;
            break;
        case TYuchar:
        case TYbool:
        Uchar:
            result = e->EV.Vuchar;
            break;
        case TYshort:
        Ishort:
            result = e->EV.Vshort;
            break;
        case TYushort:
        case TYwchar_t:
        case TYchar16:
        Ushort:
            result = e->EV.Vushort;
            break;
#if SCPP && TX86
        case TYenum:
            assert(PARSER);
            ty = e->ET->Tnext->Tty;
            goto L1;
#endif

#if TX86
#if JHANDLE
        case TYjhandle:
#endif
        case TYnullptr:
        case TYnptr:
        case TYsptr:
        case TYcptr:
            if (NPTRSIZE == SHORTSIZE)
                goto Ushort;
            if (NPTRSIZE == LONGSIZE)
                goto Ulong;
            if (NPTRSIZE == LLONGSIZE)
                goto Ullong;
            assert(0);
#endif

#if TARGET_MAC // DJB
        case TYint:
            if (intsize == SHORTSIZE)
                goto Ishort;
            goto Ulong;
#if SCPP
        case TYenum:
#endif
#endif
        case TYuint:
            if (intsize == SHORTSIZE)
                goto Ushort;
            goto Ulong;

        case TYulong:
        case TYdchar:
        case TYfptr:
#if TX86
        case TYhptr:
#endif
        case TYvptr:
        case TYvoid:                    /* some odd cases               */
        Ulong:
            result = e->EV.Vulong;
            break;

#if TX86
        case TYint:
            if (intsize == SHORTSIZE)
                goto Ishort;
            goto Ilong;

        case TYlong:
        Ilong:
            result = e->EV.Vlong;
            break;
#endif
        case TYllong:
        case TYullong:
        Ullong:
            result = e->EV.Vullong;
            break;
        case TYdouble_alias:
        case TYldouble:
        case TYdouble:
        case TYfloat:
        case TYildouble:
        case TYidouble:
        case TYifloat:
        case TYcldouble:
        case TYcdouble:
        case TYcfloat:
#if !DDRT
            result = (targ_llong)el_toldouble(e);
#else
            result = Xxtoi(el_toldouble(e));
#endif
            break;

#if SCPP
        case TYmemptr:
            ty = tybasic(tym_conv(e->ET));
            goto L1;
#endif

        case TYcent:
        case TYucent:
            goto Ullong; // should do better than this when actually doing arithmetic on cents

        default:
#if SCPP
            // Can happen as result of syntax errors
            assert(errcnt);
#else
#ifdef DEBUG
            elem_print(e);
            *(char*)0=0;
#endif
            assert(0);
#endif
    }
    return result;
}

/***********************************
 * Determine if constant e is all ones or all zeros.
 * Input:
 *      bit 0:  all zeros
 *          1:  1
 *         -1:  all ones
 */

int el_allbits(elem *e,int bit)
{   targ_llong value;

    elem_debug(e);
    assert(e->Eoper == OPconst);
    value = e->EV.Vullong;
    switch (tysize(e->Ety))
    {
        case 1: value = (signed char) value;
                break;
        case 2: value = (short) value;
                break;
        case 4: value = (int) value;
                break;
        case 8: break;
        default:
                assert(0);
    }
    if (bit == -1)
        value++;
    else if (bit == 1)
        value--;
    return value == 0;
}

/********************************************
 * Determine if constant e is a 32 bit or less value, or is a 32 bit value sign extended to 64 bits.
 */

int el_signx32(elem *e)
{
    elem_debug(e);
    assert(e->Eoper == OPconst);
    if (tysize(e->Ety) == 8)
    {
        if (e->EV.Vullong != (int)e->EV.Vullong)
            return FALSE;
    }
    return TRUE;
}

/******************************
 * Extract long double value from constant elem.
 * Silently ignore types which are not floating point values.
 */

targ_ldouble el_toldouble(elem *e)
{   targ_ldouble result;

    elem_debug(e);
    assert(cnst(e));
#if TX86
    switch (tybasic(typemask(e)))
    {
        case TYfloat:
        case TYifloat:
            result = e->EV.Vfloat;
            break;
        case TYdouble:
        case TYidouble:
        case TYdouble_alias:
            result = e->EV.Vdouble;
            break;
        case TYldouble:
        case TYildouble:
            result = e->EV.Vldouble;
            break;
    }
#else
#if !DDRT
    switch (tysize[tybasic(typemask(e))])
    {
    case FLOATSIZE:             // TYfloat
        result = e->EV.Vfloat;
        break;
    case DOUBLESIZE:    // TYdouble
        result = e->EV.Vdouble;
        break;
#if DOUBLESIZE != LNGDBLSIZE
    case LNGDBLSIZE:    // TYldouble
#ifdef LNGHDBLSIZE
    case LNGHDBLSIZE:
#endif
#if (TARGET_POWERPC)
        if (config.flags & CFGldblisdbl)
            result = e->EV.Vdouble;
        else
#endif
            result = e->EV.Vldouble;
        break;
#endif
    }
#else /* DDRT */
    switch (tysize[tybasic(typemask(e))])
    {
        case FLOATSIZE:         // TYfloat
            result = Xftox(e->EV.Vfloat);
            break;
        case DOUBLESIZE:        // TYdouble
            result = Xdtox(e->EV.Vdouble);
            break;
        case LNGDBLSIZE:        // TYldouble
#ifdef LNGHDBLSIZE
        case LNGHDBLSIZE:
#endif
#if TARGET_POWERPC
            if (config.flags & CFGldblisdbl)
                result = Xdtox(e->EV.Vdouble);
            else
#endif
                result = e->EV.Vldouble;
            break;
    }
#endif /* DDRT */
#endif
    return result;
}

/********************************
 * Is elem type-dependent or value-dependent?
 * Return !=0 if so.
 */

int el_isdependent(elem *e)
{
    if (type_isdependent(e->ET))
        return 1;
    while (1)
    {
        if (e->PEFflags & PEFdependent)
            return 1;
        if (OTunary(e->Eoper))
            e = e->E1;
        else if (OTbinary(e->Eoper))
        {   if (el_isdependent(e->E2))
                return 1;
            e = e->E1;
        }
        else
            break;
    }
    return 0;
}

/****************************************
 * Return alignment size of elem.
 */

unsigned el_alignsize(elem *e)
{
    tym_t tym = tybasic(e->Ety);
    unsigned alignsize = tyalignsize(tym);
    if (alignsize == (unsigned)-1)
    {
        assert(e->ET);
        alignsize = type_alignsize(e->ET);
    }
    return alignsize;
}

/*******************************
 * Check for errors in a tree.
 */

#ifdef DEBUG

void el_check(elem *e)
{
    elem_debug(e);
    while (1)
    {
        if (OTunary(e->Eoper))
            e = e->E1;
        else if (OTbinary(e->Eoper))
        {   el_check(e->E2);
            e = e->E1;
        }
        else
            break;
    }
}

#endif

/*******************************
 * Write out expression elem.
 */

#ifdef DEBUG

void elem_print(elem *e)
{ static int nestlevel = 0;
  int i;
  tym_t tym;

  nestlevel++;
  for (i = nestlevel; --i;) dbg_printf(" ");
  dbg_printf("el:%p ",e);
  if (!e)
  {     dbg_printf("\n");
        goto ret;
  }
  elem_debug(e);
  if (configv.addlinenumbers)
  {
#if TX86
#if MARS
        dbg_printf("fil=%p lin=%u ",e->Esrcpos.Sfilename,e->Esrcpos.Slinnum);
#elif SCPP
        dbg_printf("fil=%p lin=%u ",e->Esrcpos.Sfilptr,e->Esrcpos.Slinnum);
#endif
#else
        dbg_printf("fil=%d lin=%u ",((struct ELEMsrcpos *)e)->Esrcpos.Sfilnum,
        ((struct ELEMsrcpos *)e)->Esrcpos.Slinnum);
#endif
#if TARGET_MAC && SOURCE_OFFSETS
        dbg_printf("off %d) ",((struct ELEMsrcpos *)e)->Esrcpos.Sfiloff);
#endif
  }
  if (!PARSER)
  {     dbg_printf("cnt=%d ",e->Ecount);
        if (!OPTIMIZER)
            dbg_printf("cs=%d ",e->Ecomsub);
  }
  WROP(e->Eoper);
  dbg_printf(" ");
  if (SCPP && PARSER)
  {
        if (e->ET)
        {   type_debug(e->ET);
            if (tybasic(e->ET->Tty) == TYstruct
#if !TX86
 && (e->PEFflags & PEFstrsize)
#endif
               )
                dbg_printf("%d ", (int)type_size(e->ET));
            WRTYxx(e->ET->Tty);
        }
  }
  else
  {
        if ((e->Eoper == OPstrpar || e->Eoper == OPstrctor || e->Eoper == OPstreq) ||
            e->Ety == TYstruct)
            if (e->ET)
                dbg_printf("%d ", (int)type_size(e->ET));
        WRTYxx(e->Ety);
  }
  if (OTunary(e->Eoper))
  {
        if (e->E2)
            dbg_printf("%p %p\n",e->E1,e->E2);
        else
            dbg_printf("%p\n",e->E1);
        elem_print(e->E1);
  }
  else if (OTbinary(e->Eoper))
  {
        if (!PARSER && e->Eoper == OPstreq)
                dbg_printf("bytes=%d ", (int)type_size(e->ET));
        dbg_printf("%p %p\n",e->E1,e->E2);
        elem_print(e->E1);
        elem_print(e->E2);
  }
  else
  {
        switch (e->Eoper)
        {
            case OPrelconst:
                dbg_printf(" %lld+&",(unsigned long long)e->Eoffset);
                dbg_printf(" %s",e->EV.sp.Vsym->Sident);
                break;
            case OPvar:
                if (e->Eoffset)
                    dbg_printf(" %lld+",(unsigned long long)e->Eoffset);
                dbg_printf(" %s",e->EV.sp.Vsym->Sident);
                break;
            case OPasm:
            case OPstring:
            case OPhstring:
                dbg_printf(" '%s',%lld\n",e->EV.ss.Vstring,(unsigned long long)e->EV.ss.Voffset);
                break;
            case OPconst:
                tym = tybasic(typemask(e));
            case_tym:
                switch (tym)
                {   case TYbool:
                    case TYchar:
                    case TYschar:
                    case TYuchar:
                        dbg_printf("%d ",e->EV.Vuchar);
                        break;
#if TX86
                    case TYsptr:
#if JHANDLE
                    case TYjhandle:
#endif
                    case TYnullptr:
                    case TYnptr:
                    case TYcptr:
#endif
                        if (NPTRSIZE == LONGSIZE)
                            goto L1;
                        if (NPTRSIZE == SHORTSIZE)
                            goto L3;
                        if (NPTRSIZE == LLONGSIZE)
                            goto L2;
                        assert(0);
                        break;
                    case TYenum:
                        if (PARSER)
                        {   tym = e->ET->Tnext->Tty;
                            goto case_tym;
                        }
                    case TYint:
                    case TYuint:
                    case TYvoid:        /* in case (void)(1)    */
#if TX86
                        if (tysize[TYint] == LONGSIZE)
                            goto L1;
#endif
                    case TYshort:
                    case TYwchar_t:
                    case TYushort:
                    case TYchar16:
                    L3:
#if TX86
                        dbg_printf("%d ",e->EV.Vint);
                        break;
#endif
                    case TYlong:
                    case TYulong:
                    case TYdchar:
                    case TYfptr:
#if TX86
                    case TYvptr:
                    case TYhptr:
#endif
                    L1:
                        dbg_printf("%dL ",e->EV.Vlong);
                        break;

                    case TYllong:
                    L2:
                        dbg_printf("%lldLL ",e->EV.Vllong);
                        break;

                    case TYullong:
                        dbg_printf("%lluLL ",e->EV.Vullong);
                        break;

                    case TYcent:
                    case TYucent:
                        dbg_printf("%lluLL+%lluLL ", e->EV.Vcent.msw, e->EV.Vcent.lsw);
                        break;

                    case TYfloat:
                        dbg_printf("%gf ",(double)e->EV.Vfloat);
                        break;
                    case TYdouble:
                    case TYdouble_alias:
                        dbg_printf("%g ",(double)e->EV.Vdouble);
                        break;
                    case TYldouble:
#if TARGET_MAC
#if (TARGET_POWERPC)
                        if (config.flags & CFGldblisdbl)
                            dbg_printf("%gL ",e->EV.Vdouble);
                        else
#endif
#if !DDRT
                            dbg_printf("%LgL ",e->EV.Vldouble);
#else /* DDRT */
                        {
                            static char buffer[75];
                            __g_fmt(buffer, (DD)e->EV.Vldouble);
                            dbg_printf("%sL", buffer);
                        }
#endif /* DDRT */
                        break;
                    case TYvptr:
                        dbg_printf("%ldL ",e->EV.Vlong);
                        break;
#else
                        dbg_printf("%Lg ", e->EV.Vldouble);
#endif
                        break;

                    case TYifloat:
                        dbg_printf("%gfi ", (double)e->EV.Vfloat);
                        break;

                    case TYidouble:
                        dbg_printf("%gi ", (double)e->EV.Vdouble);
                        break;

                    case TYildouble:
                        dbg_printf("%gLi ", (double)e->EV.Vldouble);
                        break;

                    case TYcfloat:
                        dbg_printf("%gf+%gfi ", (double)e->EV.Vcfloat.re, (double)e->EV.Vcfloat.im);
                        break;

                    case TYcdouble:
                        dbg_printf("%g+%gi ", (double)e->EV.Vcdouble.re, (double)e->EV.Vcdouble.im);
                        break;

                    case TYcldouble:
                        dbg_printf("%gL+%gLi ", (double)e->EV.Vcldouble.re, (double)e->EV.Vcldouble.im);
                        break;

                    case TYident:
                        dbg_printf("'%s' ", e->ET->Tident);
                        break;

                    default:
                        dbg_printf("Invalid type ");
                        WRTYxx(typemask(e));
                        /*assert(0);*/
                }
                break;
            default:
                break;
        }
        dbg_printf("\n");
  }
ret:
  nestlevel--;
}

#endif

/**********************************
 * Hydrate an elem.
 */

#if HYDRATE
void el_hydrate(elem **pe)
{
    elem *e;

    if (!isdehydrated(*pe))
        return;

    assert(PARSER);
    e = (elem *) ph_hydrate(pe);
    elem_debug(e);
#ifdef DEBUG
    if (!(e->Eoper < OPMAX))
        dbg_printf("e = x%lx, e->Eoper = %d\n",e,e->Eoper);
#endif
    debug_assert(e->Eoper < OPMAX);
    type_hydrate(&e->ET);
#if TARGET_MAC
#else
    if (configv.addlinenumbers)
    {   filename_translate(&e->Esrcpos);
        srcpos_hydrate(&e->Esrcpos);
    }
#endif
    if (EOP(e))
    {   el_hydrate(&e->E1);
        if (EBIN(e))
            el_hydrate(&e->E2);
#if SCPP
        else if (e->Eoper == OPctor)
        {   symbol_hydrate(&e->EV.eop.Edtor);
            symbol_debug(e->EV.eop.Edtor);
        }
#endif
    }
    else
    {
        switch (e->Eoper)
        {   case OPstring:
            case OPasm:
                ph_hydrate(&e->EV.ss.Vstring);
                break;

            case OPrelconst:
                //if (tybasic(e->ET->Tty) == TYmemptr)
                    //el_hydrate(&e->EV.sm.ethis);
            case OPvar:
#if TX86
                symbol_hydrate(&e->EV.sp.Vsym);
#else
                ph_hydrate(&e->EV.sp.Vsym);
#endif
                symbol_debug(e->EV.sp.Vsym);
                break;
        }
    }
}
#endif

/**********************************
 * Dehydrate an elem.
 */

#if DEHYDRATE
void el_dehydrate(elem **pe)
{   elem *e;

    if ((e = *pe) == NULL || isdehydrated(e))
        return;

    assert(PARSER);
    elem_debug(e);
#ifdef DEBUG
    if (!(e->Eoper < OPMAX))
        dbg_printf("e = x%lx, e->Eoper = %d\n",e,e->Eoper);
#endif
    debug_assert(e->Eoper < OPMAX);
    ph_dehydrate(pe);
#if DEBUG_XSYMGEN
    if (xsym_gen && ph_in_head(e))
        return;
#endif
    type_dehydrate(&e->ET);
#if TX86
    if (configv.addlinenumbers)
        srcpos_dehydrate(&e->Esrcpos);
#endif
    if (EOP(e))
    {   el_dehydrate(&e->E1);
        if (EBIN(e))
            el_dehydrate(&e->E2);
#if SCPP
        else if (e->Eoper == OPctor)
            symbol_dehydrate(&e->EV.eop.Edtor);
#endif
    }
    else
    {
        switch (e->Eoper)
        {   case OPstring:
            case OPasm:
                ph_dehydrate(&e->EV.ss.Vstring);
                break;
            case OPrelconst:
                //if (tybasic(e->ET->Tty) == TYmemptr)
                    //el_dehydrate(&e->EV.sm.ethis);
            case OPvar:
#if TX86
                symbol_dehydrate(&e->EV.sp.Vsym);
#else
                ph_dehydrate(&e->EV.sp.Vsym);
#endif
                break;
        }
    }
}
#endif

#endif /* !SPP */
