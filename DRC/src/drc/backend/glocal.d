/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1993-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/glocal.d, backend/glocal.d)
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/backend/glocal.d
 */

module drc.backend.glocal;

version (SCPP)
    version = COMPILE;
version (Dinrus)
    version = COMPILE;

version (COMPILE)
{

import cidrus;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.code_x86;
import drc.backend.oper;
import drc.backend.глоб2;
import drc.backend.goh;
import drc.backend.el;
import drc.backend.ty;
import drc.backend.тип;

import drc.backend.barray;
import drc.backend.dlist;
import drc.backend.dvec;

/*extern (C++):*/



цел REGSIZE();


enum
{
    LFvolatile     = 1,       // содержит volatile or shared refs or defs
    LFambigref     = 2,       // references ambiguous данные
    LFambigdef     = 4,       // defines ambiguous данные
    LFsymref       = 8,       // reference to symbol s
    LFsymdef       = 0x10,    // definition of symbol s
    LFunambigref   = 0x20,    // references unambiguous данные other than s
    LFunambigdef   = 0x40,    // defines unambiguous данные other than s
    LFinp          = 0x80,    // input from I/O port
    LFoutp         = 0x100,   // output to I/O port
    LFfloat        = 0x200,   // sets float flags and/or depends on
                              // floating point settings
}

struct loc_t
{
    elem *e;
    цел flags;  // LFxxxxx
}


///////////////////////////////
// This optimization attempts to replace sequences like:
//      x = func();
//      y = 3;
//      z = x + 5;
// with:
//      y = 3;
//      z = (x = func()) + 5;
// In other words, we attempt to localize Выражения by moving them
// as near as we can to where they are используется. This should minimize
// temporary generation and register использование.

проц localize()
{
    if (debugc) printf("localize()\n");

     Barray!(loc_t) loctab;       // cache the массив so it usually won't need reallocating

    // Table should not get any larger than the symbol table
    loctab.setLength(globsym.symmax);

    foreach (b; BlockRange(startblock))       // for each block
    {
        loctab.setLength(0);                     // start over for each block
        if (b.Belem &&
            /* Overly broad way to account for the case:
             * try
             * { i++;
             *   foo(); // throws exception
             *   i++;   // shouldn't combine previous i++ with this one
             * }
             */
            !b.Btry)
        {
            local_exp(loctab,b.Belem,0);
        }
    }
}

//////////////////////////////////////
// Input:
//      goal    !=0 if we want the результат of the Выражение
//

private проц local_exp(ref Barray!(loc_t) lt, elem *e, цел goal)
{
    Symbol *s;
    elem *e1;
    OPER op1;

Loop:
    elem_debug(e);
    const op = e.Eoper;
    switch (op)
    {
        case OPcomma:
            local_exp(lt,e.EV.E1,0);
            e = e.EV.E2;
            goto Loop;

        case OPandand:
        case OPoror:
            local_exp(lt,e.EV.E1,1);
            lt.setLength(0);         // we can do better than this, fix later
            break;

        case OPcolon:
        case OPcolon2:
            lt.setLength(0);         // we can do better than this, fix later
            break;

        case OPinfo:
            if (e.EV.E1.Eoper == OPmark)
            {   lt.setLength(0);
                e = e.EV.E2;
                goto Loop;
            }
            goto case_bin;

        case OPdtor:
        case OPctor:
        case OPdctor:
            lt.setLength(0);         // don't move Выражения across ctor/dtor
            break;              // boundaries, it would goof up EH cleanup

        case OPddtor:
            lt.setLength(0);         // don't move Выражения across ctor/dtor
                                // boundaries, it would goof up EH cleanup
            local_exp(lt,e.EV.E1,0);
            lt.setLength(0);
            break;

        case OPeq:
        case OPstreq:
            e1 = e.EV.E1;
            local_exp(lt,e.EV.E2,1);
            if (e1.Eoper == OPvar)
            {   s = e1.EV.Vsym;
                if (s.Sflags & SFLunambig)
                {   local_symdef(lt, s);
                    if (!goal)
                        local_ins(lt, e);
                }
                else
                    local_ambigdef(lt);
            }
            else
            {
                assert(!OTleaf(e1.Eoper));
                local_exp(lt,e1.EV.E1,1);
                if (OTbinary(e1.Eoper))
                    local_exp(lt,e1.EV.E2,1);
                local_ambigdef(lt);
            }
            break;

        case OPpostinc:
        case OPpostdec:
        case OPaddass:
        case OPminass:
        case OPmulass:
        case OPdivass:
        case OPmodass:
        case OPashrass:
        case OPshrass:
        case OPshlass:
        case OPandass:
        case OPxorass:
        case OPorass:
        case OPcmpxchg:
            if (ERTOL(e))
            {   local_exp(lt,e.EV.E2,1);
        case OPnegass:
                e1 = e.EV.E1;
                op1 = e1.Eoper;
                if (op1 != OPvar)
                {
                    local_exp(lt,e1.EV.E1,1);
                    if (OTbinary(op1))
                        local_exp(lt,e1.EV.E2,1);
                }
                else if (lt.length && (op == OPaddass || op == OPxorass))
                {
                    s = e1.EV.Vsym;
                    for (бцел u = 0; u < lt.length; u++)
                    {   elem *em;

                        em = lt[u].e;
                        if (em.Eoper == op &&
                            em.EV.E1.EV.Vsym == s &&
                            tysize(em.Ety) == tysize(e1.Ety) &&
                            !tyfloating(em.Ety) &&
                            em.EV.E1.EV.Voffset == e1.EV.Voffset &&
                            !el_sideeffect(em.EV.E2)
                           )
                        {   // Change (x += a),(x += b) to
                            // (x + a),(x += a + b)
                            go.changes++;
                            e.EV.E2 = el_bin(opeqtoop(op),e.EV.E2.Ety,em.EV.E2,e.EV.E2);
                            em.Eoper = cast(ббайт)opeqtoop(op);
                            em.EV.E2 = el_copytree(em.EV.E2);
                            local_rem(lt, u);

                            debug if (debugc)
                            {   printf("Combined equation ");
                                WReqn(e);
                                printf(";\n");
                                e = doptelem(e,GOALvalue);
                            }

                            break;
                        }
                    }
                }
            }
            else
            {
                e1 = e.EV.E1;
                op1 = e1.Eoper;
                if (op1 != OPvar)
                {
                    local_exp(lt,e1.EV.E1,1);
                    if (OTbinary(op1))
                        local_exp(lt,e1.EV.E2,1);
                }
                if (lt.length)
                {   if (op1 == OPvar &&
                        ((s = e1.EV.Vsym).Sflags & SFLunambig))
                        local_symref(lt, s);
                    else
                        local_ambigref(lt);
                }
                local_exp(lt,e.EV.E2,1);
            }
            if (op1 == OPvar &&
                ((s = e1.EV.Vsym).Sflags & SFLunambig))
            {   local_symref(lt, s);
                local_symdef(lt, s);
                if (op == OPaddass || op == OPxorass)
                    local_ins(lt, e);
            }
            else if (lt.length)
            {
                local_remove(lt, LFambigdef | LFambigref);
            }
            break;

        case OPstrlen:
        case OPind:
            local_exp(lt,e.EV.E1,1);
            local_ambigref(lt);
            break;

        case OPstrcmp:
        case OPmemcmp:
        case OPbt:
            local_exp(lt,e.EV.E1,1);
            local_exp(lt,e.EV.E2,1);
            local_ambigref(lt);
            break;

        case OPstrcpy:
        case OPmemcpy:
        case OPstrcat:
        case OPcall:
        case OPcallns:
            local_exp(lt,e.EV.E2,1);
            local_exp(lt,e.EV.E1,1);
            goto Lrd;

        case OPstrctor:
        case OPucall:
        case OPucallns:
            local_exp(lt,e.EV.E1,1);
            goto Lrd;

        case OPbtc:
        case OPbtr:
        case OPbts:
            local_exp(lt,e.EV.E1,1);
            local_exp(lt,e.EV.E2,1);
            goto Lrd;

        case OPasm:
        Lrd:
            local_remove(lt, LFfloat | LFambigref | LFambigdef);
            break;

        case OPmemset:
            local_exp(lt,e.EV.E2,1);
            if (e.EV.E1.Eoper == OPvar)
            {
                /* Don't want to rearrange (p = get(); p memset 0;)
                 * as elemxxx() will rearrange it back.
                 */
                s = e.EV.E1.EV.Vsym;
                if (s.Sflags & SFLunambig)
                    local_symref(lt, s);
                else
                    local_ambigref(lt);     // ambiguous reference
            }
            else
                local_exp(lt,e.EV.E1,1);
            local_ambigdef(lt);
            break;

        case OPvar:
            s = e.EV.Vsym;
            if (lt.length)
            {
                // If potential candidate for replacement
                if (s.Sflags & SFLunambig)
                {
                    foreach ( u; new бцел[0 .. lt.length])
                    {
                        auto em = lt[u].e;
                        if (em.EV.E1.EV.Vsym == s &&
                            (em.Eoper == OPeq || em.Eoper == OPstreq))
                        {
                            if (tysize(em.Ety) == tysize(e.Ety) &&
                                em.EV.E1.EV.Voffset == e.EV.Voffset &&
                                ((tyfloating(em.Ety) != 0) == (tyfloating(e.Ety) != 0) ||
                                 /** Hack to fix https://issues.dlang.org/show_bug.cgi?ид=10226
                                  * Recognize assignments of float vectors to void16, as используется by
                                  * core.simd intrinsics. The backend тип for void16 is Tschar16!
                                  */
                                 (tyvector(em.Ety) != 0) == (tyvector(e.Ety) != 0) && tybasic(e.Ety) == TYschar16) &&
                                /* Changing the Ety to a OPvecfill узел means we're potentially generating
                                 * wrong code.
                                 * Ref: https://issues.dlang.org/show_bug.cgi?ид=18034
                                 */
                                (em.EV.E2.Eoper != OPvecfill || tybasic(e.Ety) == tybasic(em.Ety)) &&
                                !local_preserveAssignmentTo(em.EV.E1.Ety))
                            {

                                debug if (debugc)
                                {   printf("Moved equation ");
                                    WReqn(em);
                                    printf(";\n");
                                }

                                go.changes++;
                                em.Ety = e.Ety;
                                el_copy(e,em);
                                em.EV.E1 = em.EV.E2 = null;
                                em.Eoper = OPconst;
                            }
                            local_rem(lt, u);
                            break;
                        }
                    }
                    local_symref(lt, s);
                }
                else
                    local_ambigref(lt);     // ambiguous reference
            }
            break;

        case OPremquo:
            if (e.EV.E1.Eoper != OPvar)
                goto case_bin;
            s = e.EV.E1.EV.Vsym;
            if (lt.length)
            {
                if (s.Sflags & SFLunambig)
                    local_symref(lt, s);
                else
                    local_ambigref(lt);     // ambiguous reference
            }
            goal = 1;
            e = e.EV.E2;
            goto Loop;

        default:
            if (OTcommut(e.Eoper))
            {   // Since commutative operators may get their leaves
                // swapped, we eliminate any that may be affected by that.

                for (бцел u = 0; u < lt.length;)
                {
                    const f = lt[u].flags;
                    elem* eu = lt[u].e;
                    s = eu.EV.E1.EV.Vsym;
                    const f1 = local_getflags(e.EV.E1,s);
                    const f2 = local_getflags(e.EV.E2,s);
                    if (f1 & f2 & LFsymref ||   // if both reference or
                        (f1 | f2) & LFsymdef || // either define
                        f & LFambigref && (f1 | f2) & LFambigdef ||
                        f & LFambigdef && (f1 | f2) & (LFambigref | LFambigdef)
                       )
                        local_rem(lt, u);
                    else if (f & LFunambigdef && local_chkrem(e,eu.EV.E2))
                        local_rem(lt, u);
                    else
                        u++;
                }
            }
            if (OTunary(e.Eoper))
            {   goal = 1;
                e = e.EV.E1;
                goto Loop;
            }
        case_bin:
            if (OTbinary(e.Eoper))
            {   local_exp(lt,e.EV.E1,1);
                goal = 1;
                e = e.EV.E2;
                goto Loop;
            }
            break;
    }   // end of switch (e.Eoper)
}

///////////////////////////////////
// Examine Выражение tree eu to see if it defines any variables
// that e refs or defs.
// Note that e is a binary operator.
// Возвращает:
//      да if it does

private бул local_chkrem(elem *e,elem *eu)
{
    while (1)
    {
        elem_debug(eu);
        const op = eu.Eoper;
        if (OTassign(op) && eu.EV.E1.Eoper == OPvar)
        {
            auto s = eu.EV.E1.EV.Vsym;
            const f1 = local_getflags(e.EV.E1,s);
            const f2 = local_getflags(e.EV.E2,s);
            if ((f1 | f2) & (LFsymref | LFsymdef))      // if either reference or define
                return да;
        }
        if (OTbinary(op))
        {
            if (local_chkrem(e,eu.EV.E2))
                return да;
        }
        else if (!OTunary(op))
            break;                      // leaf узел
        eu = eu.EV.E1;
    }
    return нет;
}

//////////////////////////////////////
// Add entry e to lt[]

private проц local_ins(ref Barray!(loc_t) lt, elem *e)
{
    elem_debug(e);
    if (e.EV.E1.Eoper == OPvar)
    {
        auto s = e.EV.E1.EV.Vsym;
        symbol_debug(s);
        if (s.Sflags & SFLunambig)     // if can only be referenced directly
        {
            const flags = local_getflags(e.EV.E2,null);
            if (!(flags & (LFvolatile | LFinp | LFoutp)) &&
                !(e.EV.E1.Ety & (mTYvolatile | mTYshared)))
            {
                // Add e to the candidate массив
                //printf("local_ins('%s'), loctop = %d\n",s.Sident.ptr,lt.length);
                lt.сунь(loc_t(e, flags));
            }
        }
    }
}

//////////////////////////////////////
// Remove entry i from lt[], and then compress the table.
//

private проц local_rem(ref Barray!(loc_t) lt, т_мера u)
{
    //printf("local_rem(%u)\n",u);
    lt.удали(u);
}

//////////////////////////////////////
// Analyze and gather LFxxxx flags about Выражение e and symbol s.

private цел local_getflags(elem *e,Symbol *s)
{
    elem_debug(e);
    if (s)
        symbol_debug(s);
    цел flags = 0;
    while (1)
    {
        if (e.Ety & (mTYvolatile | mTYshared))
            flags |= LFvolatile;
        switch (e.Eoper)
        {
            case OPeq:
            case OPstreq:
                if (e.EV.E1.Eoper == OPvar)
                {
                    auto s1 = e.EV.E1.EV.Vsym;
                    if (s1.Sflags & SFLunambig)
                        flags |= (s1 == s) ? LFsymdef : LFunambigdef;
                    else
                        flags |= LFambigdef;
                }
                else
                    flags |= LFambigdef;
                goto L1;

            case OPpostinc:
            case OPpostdec:
            case OPaddass:
            case OPminass:
            case OPmulass:
            case OPdivass:
            case OPmodass:
            case OPashrass:
            case OPshrass:
            case OPshlass:
            case OPandass:
            case OPxorass:
            case OPorass:
            case OPcmpxchg:
                if (e.EV.E1.Eoper == OPvar)
                {
                    auto s1 = e.EV.E1.EV.Vsym;
                    if (s1.Sflags & SFLunambig)
                        flags |= (s1 == s) ? LFsymdef | LFsymref
                                           : LFunambigdef | LFunambigref;
                    else
                        flags |= LFambigdef | LFambigref;
                }
                else
                    flags |= LFambigdef | LFambigref;
            L1:
                flags |= local_getflags(e.EV.E2,s);
                e = e.EV.E1;
                break;

            case OPucall:
            case OPucallns:
            case OPcall:
            case OPcallns:
            case OPstrcat:
            case OPstrcpy:
            case OPmemcpy:
            case OPbtc:
            case OPbtr:
            case OPbts:
            case OPstrctor:
                flags |= LFambigref | LFambigdef;
                break;

            case OPmemset:
                flags |= LFambigdef;
                break;

            case OPvar:
                if (e.EV.Vsym == s)
                    flags |= LFsymref;
                else if (!(e.EV.Vsym.Sflags & SFLunambig))
                    flags |= LFambigref;
                break;

            case OPind:
            case OPstrlen:
            case OPstrcmp:
            case OPmemcmp:
            case OPbt:
                flags |= LFambigref;
                break;

            case OPinp:
                flags |= LFinp;
                break;

            case OPoutp:
                flags |= LFoutp;
                break;

            default:
                break;
        }
        if (OTunary(e.Eoper))
        {
            if (tyfloating(e.Ety))
                flags |= LFfloat;
            e = e.EV.E1;
        }
        else if (OTbinary(e.Eoper))
        {
            if (tyfloating(e.Ety))
                flags |= LFfloat;
            flags |= local_getflags(e.EV.E2,s);
            e = e.EV.E1;
        }
        else
            break;
    }
    return flags;
}

//////////////////////////////////////
// Remove all entries with flags set.
//

private проц local_remove(ref Barray!(loc_t) lt, цел flags)
{
    for (бцел u = 0; u < lt.length;)
    {
        if (lt[u].flags & flags)
            local_rem(lt, u);
        else
            ++u;
    }
}

//////////////////////////////////////
// Ambiguous reference. Remove all with ambiguous defs
//

private проц local_ambigref(ref Barray!(loc_t) lt)
{
    local_remove(lt, LFambigdef);
}

//////////////////////////////////////
// Ambiguous definition. Remove all with ambiguous refs.
//

private проц local_ambigdef(ref Barray!(loc_t) lt)
{
    local_remove(lt, LFambigref | LFambigdef);
}

//////////////////////////////////////
// Reference to symbol.
// Remove any that define that symbol.

private проц local_symref(ref Barray!(loc_t) lt, Symbol *s)
{
    symbol_debug(s);
    for (бцел u = 0; u < lt.length;)
    {
        if (local_getflags(lt[u].e,s) & LFsymdef)
            local_rem(lt, u);
        else
            ++u;
    }
}

//////////////////////////////////////
// Definition of symbol.
// Remove any that reference that symbol.

private проц local_symdef(ref Barray!(loc_t) lt, Symbol *s)
{
    symbol_debug(s);
    for (бцел u = 0; u < lt.length;)
    {
        if (local_getflags(lt[u].e,s) & (LFsymref | LFsymdef))
            local_rem(lt, u);
        else
            ++u;
    }
}

/***************************************************
 * See if we should preserve assignment to Symbol of тип ty.
 * Возвращает:
 *      да if preserve assignment
 * References:
 *      https://issues.dlang.org/show_bug.cgi?ид=13474
 */
private бул local_preserveAssignmentTo(tym_t ty)
{
    /* Need to preserve assignment if generating code using
     * the x87, as that is the only way to get the x87 to
     * convert to float/double precision.
     */
    if (config.inline8087 && !config.fpxmmregs)
    {
        switch (tybasic(ty))
        {
            case TYfloat:
            case TYifloat:
            case TYcfloat:
            case TYdouble:
            case TYidouble:
            case TYdouble_alias:
            case TYcdouble:
                return да;

            default:
                break;
        }
    }
    return нет;
}

}
