/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Compute common subВыражения for non-optimized builds.
 *
 * Copyright:   Copyright (C) 1985-1995 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      https://github.com/dlang/dmd/blob/master/src/dmd/backend/cgcs.d
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/backend/cgcs.d
 */

module drc.backend.cgcs;

version (SPP)
{
}
else
{

import cidrus;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.code;
import drc.backend.el;
import drc.backend.глоб2;
import drc.backend.oper;
import drc.backend.ty;
import drc.backend.тип;

import drc.backend.barray;
import drc.backend.dlist;
import drc.backend.dvec;




/*******************************
 * Eliminate common subВыражения across extended basic blocks.
 * String together as many blocks as we can.
 */

public  проц comsubs()
{
    //static цел xx;
    //printf("comsubs() %d\n", ++xx);
    //debugx = (xx == 37);

    debug if (debugx) printf("comsubs(%p)\n",startblock);

    // No longer do we just compute Bcount. We now eliminate unreachable
    // blocks.
    block_compbcount();                   // eliminate unreachable blocks

    version (SCPP)
    {
        if (errcnt)
            return;
    }

    if (!csvec)
    {
        csvec = vec_calloc(CSVECDIM);
    }

    block* bln;
    for (block* bl = startblock; bl; bl = bln)
    {
        bln = bl.Bnext;
        if (!bl.Belem)
            continue;                   /* if no Выражение or no parents       */

        // Count up n, the number of blocks in this extended basic block (EBB)
        цел n = 1;                      // always at least one block in EBB
        auto blc = bl;
        while (bln && list_nitems(bln.Bpred) == 1 &&
               ((blc.BC == BCiftrue &&
                 blc.nthSucc(1) == bln) ||
                (blc.BC == BCgoto && blc.nthSucc(0) == bln)
               ) &&
               bln.BC != BCasm         // no CSE's extending across ASM blocks
              )
        {
            n++;                    // add block to EBB
            blc = bln;
            bln = blc.Bnext;
        }
        vec_clear(csvec);
        hcstab.setLength(0);
        hcsarray.touchstari = 0;
        hcsarray.touchfunci[0] = 0;
        hcsarray.touchfunci[1] = 0;
        bln = bl;
        while (n--)                     // while more blocks in EBB
        {
            debug if (debugx)
                printf("cses for block %p\n",bln);

            if (bln.Belem)
                ecom(&bln.Belem);  // do the tree
            bln = bln.Bnext;
        }
    }

    debug if (debugx)
        printf("done with comsubs()\n");
}

/*******************************
 */

public  проц cgcs_term()
{
    vec_free(csvec);
    csvec = null;
    debug debugw && printf("freeing hcstab\n");
    //hcstab.dtor();  // cache allocation for следщ iteration
}


/***********************************************************************/

private:

alias бцел hash_t;    // for хэш values

/*********************************
 * Struct for each elem:
 *      Helem   pointer to elem
 *      Hhash   хэш значение for the elem
 */

struct HCS
{
    elem* Helem;
    hash_t Hhash;
}

struct HCSArray
{
    бцел touchstari;
    бцел[2] touchfunci;
}


//{
    Barray!(HCS) hcstab;           // массив of hcs's
    HCSArray hcsarray;

    // Use a bit vector for quick check if Выражение is possibly in hcstab[].
    // This результатs in much faster compiles when hcstab[] gets big.
    vec_t csvec;                 // vector of используется entries
    const CSVECDIM = 16001; //8009 //3001     // dimension of csvec (should be prime)
//}


/*************************
 * Eliminate common subВыражения for an element.
 */

проц ecom(elem **pe)
{
    auto e = *pe;
    assert(e);
    elem_debug(e);
    debug assert(e.Ecount == 0);
    //assert(e.Ecomsub == 0);
    const tym = tybasic(e.Ety);
    const op = e.Eoper;
    switch (op)
    {
        case OPconst:
        case OPrelconst:
            break;

        case OPvar:
            if (e.EV.Vsym.ty() & mTYshared)
                return;         // don't cache shared variables
            break;

        case OPstreq:
        case OPpostinc:
        case OPpostdec:
        case OPeq:
        case OPaddass:
        case OPminass:
        case OPmulass:
        case OPdivass:
        case OPmodass:
        case OPshrass:
        case OPashrass:
        case OPshlass:
        case OPandass:
        case OPxorass:
        case OPorass:
        case OPvecsto:
            /* Reverse order of evaluation for double op=. This is so that  */
            /* the pushing of the address of the second operand is easier.  */
            /* However, with the 8087 we don't need the kludge.             */
            if (op != OPeq && tym == TYdouble && !config.inline8087)
            {
                if (!OTleaf(e.EV.E1.Eoper))
                    ecom(&e.EV.E1.EV.E1);
                ecom(&e.EV.E2);
            }
            else
            {
                /* Don't mark the increment of an i++ or i-- as a CSE, if it */
                /* can be done with an INC or DEC instruction.               */
                if (!(OTpost(op) && elemisone(e.EV.E2)))
                    ecom(&e.EV.E2);           /* evaluate 2nd operand first   */
        case OPnegass:
                if (!OTleaf(e.EV.E1.Eoper))             /* if lvalue is an operator     */
                {
                    if (e.EV.E1.Eoper != OPind)
                        elem_print(e);
                    assert(e.EV.E1.Eoper == OPind);
                    ecom(&(e.EV.E1.EV.E1));
                }
            }
            touchlvalue(e.EV.E1);
            if (!OTpost(op))                /* lvalue of i++ or i-- is not a cse*/
            {
                const хэш = cs_comphash(e.EV.E1);
                vec_setbit(хэш % CSVECDIM,csvec);
                addhcstab(e.EV.E1,хэш);              // add lvalue to hcstab[]
            }
            return;

        case OPbtc:
        case OPbts:
        case OPbtr:
        case OPcmpxchg:
            ecom(&e.EV.E1);
            ecom(&e.EV.E2);
            touchfunc(0);                   // indirect assignment
            return;

        case OPandand:
        case OPoror:
        {
            ecom(&e.EV.E1);
            const lengthSave = hcstab.length;
            auto hcsarraySave = hcsarray;
            ecom(&e.EV.E2);
            hcsarray = hcsarraySave;        // no common subs by E2
            hcstab.setLength(lengthSave);
            return;                         /* if comsub then logexp() will */
        }

        case OPcond:
        {
            ecom(&e.EV.E1);
            const lengthSave = hcstab.length;
            auto hcsarraySave = hcsarray;
            ecom(&e.EV.E2.EV.E1);               // left условие
            hcsarray = hcsarraySave;        // no common subs by E2
            hcstab.setLength(lengthSave);
            ecom(&e.EV.E2.EV.E2);               // right условие
            hcsarray = hcsarraySave;        // no common subs by E2
            hcstab.setLength(lengthSave);
            return;                         // can't be a common sub
        }

        case OPcall:
        case OPcallns:
            ecom(&e.EV.E2);                   /* eval right first             */
            goto case OPucall;

        case OPucall:
        case OPucallns:
            ecom(&e.EV.E1);
            touchfunc(1);
            return;

        case OPstrpar:                      /* so we don't break logexp()   */
        case OPinp:                 /* never CSE the I/O instruction itself */
        case OPprefetch:            // don't CSE E2 or the instruction
            ecom(&e.EV.E1);
            goto case OPasm;

        case OPasm:
        case OPstrthis:             // don't CSE these
        case OPframeptr:
        case OPgot:
        case OPctor:
        case OPdtor:
        case OPdctor:
        case OPmark:
            return;

        case OPddtor:
            touchall();
            ecom(&e.EV.E1);
            touchall();
            return;

        case OPparam:
        case OPoutp:
            ecom(&e.EV.E1);
            goto case OPinfo;

        case OPinfo:
            ecom(&e.EV.E2);
            return;

        case OPcomma:
            ecom(&e.EV.E1);
            ecom(&e.EV.E2);
            return;

        case OPremquo:
            ecom(&e.EV.E1);
            ecom(&e.EV.E2);
            break;

        case OPvp_fp:
        case OPcvp_fp:
            ecom(&e.EV.E1);
            touchaccess(hcstab, e);
            break;

        case OPind:
            ecom(&e.EV.E1);
            /* Generally, CSEing a *(double *) результатs in worse code        */
            if (tyfloating(tym))
                return;
            if (tybasic(e.EV.E1.Ety) == TYsharePtr)
                return;
            break;

        case OPstrcpy:
        case OPstrcat:
        case OPmemcpy:
        case OPmemset:
            ecom(&e.EV.E2);
            goto case OPsetjmp;

        case OPsetjmp:
            ecom(&e.EV.E1);
            touchfunc(0);
            return;

        default:                            /* other operators */
            if (!OTbinary(e.Eoper))
               WROP(e.Eoper);
            assert(OTbinary(e.Eoper));
            goto case OPadd;

        case OPadd:
        case OPmin:
        case OPmul:
        case OPdiv:
        case OPor:
        case OPxor:
        case OPand:
        case OPeqeq:
        case OPne:
        case OPscale:
        case OPyl2x:
        case OPyl2xp1:
            ecom(&e.EV.E1);
            ecom(&e.EV.E2);
            break;

        case OPstring:
        case OPaddr:
        case OPbit:
            WROP(e.Eoper);
            elem_print(e);
            assert(0);              /* optelem() should have removed these  */
            /* NOTREACHED */

        // Explicitly list all the unary ops for speed
        case OPnot: case OPcom: case OPneg: case OPuadd:
        case OPabs: case OPrndtol: case OPrint:
        case OPpreinc: case OPpredec:
        case OPбул: case OPstrlen: case OPs16_32: case OPu16_32:
        case OPs32_d: case OPu32_d: case OPd_s16: case OPs16_d: case OP32_16:
        case OPf_d:
        case OPld_d:
        case OPc_r: case OPc_i:
        case OPu8_16: case OPs8_16: case OP16_8:
        case OPu32_64: case OPs32_64: case OP64_32: case OPmsw:
        case OPu64_128: case OPs64_128: case OP128_64:
        case OPs64_d: case OPd_u64: case OPu64_d:
        case OPstrctor: case OPu16_d: case OPd_u16:
        case OParrow:
        case OPvoid:
        case OPbsf: case OPbsr: case OPbswap: case OPpopcnt: case OPvector:
        case OPld_u64:
        case OPsqrt: case OPsin: case OPcos:
        case OPoffset: case OPnp_fp: case OPnp_f16p: case OPf16p_np:
        case OPvecfill:
            ecom(&e.EV.E1);
            break;

        case OPd_ld:
            return;

        case OPd_f:
        {
            const op1 = e.EV.E1.Eoper;
            if (config.fpxmmregs &&
                (op1 == OPs32_d ||
                 I64 && (op1 == OPs64_d || op1 == OPu32_d))
               )
                ecom(&e.EV.E1.EV.E1);   // e and e1 ops are fused (see xmmcnvt())
            else
                ecom(&e.EV.E1);
            break;
        }

        case OPd_s32:
        case OPd_u32:
        case OPd_s64:
            if (e.EV.E1.Eoper == OPf_d && config.fpxmmregs)
                ecom(&e.EV.E1.EV.E1);   // e and e1 ops are fused (see xmmcnvt());
            else
                ecom(&e.EV.E1);
            break;

        case OPhalt:
            return;
    }

    /* don't CSE structures or unions or volatile stuff   */
    if (tym == TYstruct ||
        tym == TYvoid ||
        e.Ety & mTYvolatile)
        return;
    if (tyfloating(tym) && config.inline8087)
    {
        /* can CSE XMM code, but not x87
         */
        if (!(config.fpxmmregs && tyxmmreg(tym)))
            return;
    }

    const хэш = cs_comphash(e);                /* must be AFTER leaves are done */

    /* Search for a match in hcstab[].
     * Search backwards, as most likely matches will be towards the end
     * of the list.
     */

    debug if (debugx) printf("elem: %p хэш: %6d\n",e,хэш);
    цел csveci = хэш % CSVECDIM;
    if (vec_testbit(csveci,csvec))
    {
        foreach_reverse (i, ref hcs; hcstab[])
        {
            debug if (debugx)
                printf("i: %2d Hhash: %6d Helem: %p\n",
                       i,hcs.Hhash,hcs.Helem);

            elem* ehash;
            if (хэш == hcs.Hhash && (ehash = hcs.Helem) != null)
            {
                /* if elems are the same and we still have room for more    */
                if (el_match(e,ehash) && ehash.Ecount < 0xFF)
                {
                    /* Make sure leaves are also common subВыражения
                     * to avoid нет matches.
                     */
                    if (!OTleaf(op))
                    {
                        if (!e.EV.E1.Ecount)
                            continue;
                        if (OTbinary(op) && !e.EV.E2.Ecount)
                            continue;
                    }
                    ehash.Ecount++;
                    *pe = ehash;

                    debug if (debugx)
                        printf("**MATCH** %p with %p\n",e,*pe);

                    el_free(e);
                    return;
                }
            }
        }
    }
    else
        vec_setbit(csveci,csvec);
    addhcstab(e,хэш);                    // add this elem to hcstab[]
}

/**************************
 * Compute хэш function for elem e.
 */

hash_t cs_comphash(elem *e)
{
    elem_debug(e);
    const op = e.Eoper;
    hash_t хэш = (e.Ety & (mTYbasic | mTYconst | mTYvolatile)) + (op << 8);
    if (!OTleaf(op))
    {
        хэш += cast(т_мера) e.EV.E1;
        if (OTbinary(op))
            хэш += cast(т_мера) e.EV.E2;
    }
    else
    {
        хэш += e.EV.Vint;
        if (op == OPvar || op == OPrelconst)
            хэш += cast(т_мера) e.EV.Vsym;
    }
    return хэш;
}

/****************************
 * Add an elem to the common subВыражение table.
 */

проц addhcstab(elem *e, hash_t хэш)
{
    hcstab.сунь(HCS(e, хэш));
}

/***************************
 * "touch" the elem.
 * If it is a pointer, "touch" all the suspects
 * who could be pointed to.
 * Eliminate common subs that are indirect loads.
 */

проц touchlvalue(elem *e)
{
    if (e.Eoper == OPind)                /* if indirect store            */
    {
        /* NOTE: Some types of массив assignments do not need
         * to touch all variables. (Like a[5], where a is an
         * массив instead of a pointer.)
         */

        touchfunc(0);
        return;
    }

    foreach_reverse (ref hcs; hcstab[])
    {
        if (hcs.Helem &&
            hcs.Helem.EV.Vsym == e.EV.Vsym)
            hcs.Helem = null;
    }

    if (!(e.Eoper == OPvar || e.Eoper == OPrelconst))
        elem_print(e);
    assert(e.Eoper == OPvar || e.Eoper == OPrelconst);
    switch (e.EV.Vsym.Sclass)
    {
        case SCregpar:
        case SCregister:
        case SCpseudo:
            break;

        case SCauto:
        case SCparameter:
        case SCfastpar:
        case SCshadowreg:
        case SCbprel:
            if (e.EV.Vsym.Sflags & SFLunambig)
                break;
            goto case SCstatic;

        case SCstatic:
        case SCextern:
        case SCglobal:
        case SClocstat:
        case SCcomdat:
        case SCinline:
        case SCsinline:
        case SCeinline:
        case SCcomdef:
            touchstar();
            break;

        default:
            elem_print(e);
            symbol_print(e.EV.Vsym);
            assert(0);
    }
}

/**************************
 * "touch" variables that could be changed by a function call or
 * an indirect assignment.
 * Eliminate any subВыражения that are "starred" (they need to
 * be recomputed).
 * Параметры:
 *      флаг =  If 1, then this is a function call.
 *              If 0, then this is an indirect assignment.
 */

проц touchfunc(цел флаг)
{

    //printf("touchfunc(%d)\n", флаг);
    HCS *petop = hcstab.ptr + hcstab.length;
    //pe = &hcstab[0]; printf("pe = %p, petop = %p\n",pe,petop);
    assert(hcsarray.touchfunci[флаг] <= hcstab.length);
    for (HCS *pe = hcstab.ptr + hcsarray.touchfunci[флаг]; pe < petop; pe++)
    {
        elem *he = pe.Helem;
        if (!he)
            continue;
        switch (he.Eoper)
        {
            case OPvar:
                if (Symbol_isAffected(*he.EV.Vsym))
                {
                    pe.Helem = null;
                    continue;
                }
                break;

            case OPind:
                if (tybasic(he.EV.E1.Ety) == TYimmutPtr)
                    break;
                goto Ltouch;

            case OPstrlen:
            case OPstrcmp:
            case OPmemcmp:
            case OPbt:
                goto Ltouch;

            case OPvp_fp:
            case OPcvp_fp:
                if (флаг == 0)          /* function calls разрушь vptrfptr's, */
                    break;              /* not indirect assignments     */
            Ltouch:
                pe.Helem = null;
                break;

            default:
                break;
        }
    }
    hcsarray.touchfunci[флаг] = cast(бцел)hcstab.length;
}


/*******************************
 * Eliminate all common subВыражения that
 * do any indirection ("starred" elems).
 */

проц touchstar()
{
    foreach (ref hcs; hcstab[hcsarray.touchstari .. $])
    {
        const e = hcs.Helem;
        if (e &&
               (e.Eoper == OPind && tybasic(e.EV.E1.Ety) != TYimmutPtr ||
                e.Eoper == OPbt) )
            hcs.Helem = null;
    }
    hcsarray.touchstari = cast(бцел)hcstab.length;
}

/*******************************
 * Eliminate all common subВыражения.
 */

проц touchall()
{
    foreach (ref hcs; hcstab[])
    {
        hcs.Helem = null;
    }
    hcsarray.touchstari    = cast(бцел)hcstab.length;
    hcsarray.touchfunci[0] = cast(бцел)hcstab.length;
    hcsarray.touchfunci[1] = cast(бцел)hcstab.length;
}

/*****************************************
 * Eliminate any common subВыражения that could be modified
 * if a handle pointer access occurs.
 */

проц touchaccess(ref Barray!(HCS) hcstab, elem *ev) /*pure */
{
    const ev1 = ev.EV.E1;
    foreach (ref hcs; hcstab[])
    {
        const e = hcs.Helem;
        /* Invalidate any previous handle pointer accesses that */
        /* are not accesses of ev.                              */
        if (e && (e.Eoper == OPvp_fp || e.Eoper == OPcvp_fp) && e.EV.E1 != ev1)
            hcs.Helem = null;
    }
}

}
