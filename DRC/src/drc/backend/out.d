/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1984-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/out.d, backend/out.d)
 */


module drc.backend.dout;

version (SPP) { } else
{

import cidrus;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.cgcv;
import drc.backend.code;
import drc.backend.code_x86;
import drc.backend.cv4;
import drc.backend.dt;
import drc.backend.dlist;
import drc.backend.mem;
import drc.backend.el;
import drc.backend.exh;
import drc.backend.глоб2;
import drc.backend.goh;
import drc.backend.obj;
import drc.backend.oper;
import drc.backend.outbuf;
import drc.backend.rtlsym;
import drc.backend.ty;
import drc.backend.тип;

version (SCPP)
{
    import cpp;
    import msgs2;
    import parser;
}
version (HTOD)
{
    import cpp;
    import msgs2;
    import parser;
}

version (Windows)
{
    extern (C)
    {
        цел stricmp(сим*, сим*) ;
        цел memicmp(ук, ук, т_мера) ;
    }
}

/*extern (C++):*/



проц dt_writeToObj(Obj objmod, dt_t *dt, цел seg, ref targ_т_мера смещение);

// Determine if this Symbol is stored in a COMDAT
бул symbol_iscomdat2(Symbol* s)
{
    version (Dinrus)
    {
        return s.Sclass == SCcomdat ||
            config.flags2 & CFG2comdat && s.Sclass == SCinline ||
            config.flags4 & CFG4allcomdat && s.Sclass == SCglobal;
    }
    else
    {
        return s.Sclass == SCcomdat ||
            config.flags2 & CFG2comdat && s.Sclass == SCinline ||
            config.flags4 & CFG4allcomdat && (s.Sclass == SCglobal || s.Sclass == SCstatic);
    }
}

version (SCPP)
{

/**********************************
 * We put out an external definition.
 */
проц out_extdef(Symbol *s)
{
    pstate.STflags |= PFLextdef;
    if (//config.flags2 & CFG2phgen ||
        (config.flags2 & (CFG2phauto | CFG2phautoy) &&
            !(pstate.STflags & (PFLhxwrote | PFLhxdone)))
       )

        synerr(EM_data_in_pch,prettyident(s));          // данные or code in precompiled header
}

/********************************
 * Put out code segment имя record.
 */
проц outcsegname(сим *csegname)
{
    Obj.codeseg(csegname,0);
}

}

version (HTOD)
{
    проц outcsegname(сим *csegname) { }
}

/***********************************
 * Output function thunk.
 */
extern (C) проц outthunk(Symbol *sthunk,Symbol *sfunc,бцел p,tym_t thisty,
        targ_т_мера d,цел i,targ_т_мера d2)
{
version (HTOD) { } else
{
    sthunk.Sseg = cseg;
    cod3_thunk(sthunk,sfunc,p,thisty,cast(бцел)d,i,cast(бцел)d2);
    sthunk.Sfunc.Fflags &= ~Fpending;
    sthunk.Sfunc.Fflags |= Foutput;   /* mark it as having been output */
}
}


/***************************
 * Write out statically allocated данные.
 * Input:
 *      s               symbol to be initialized
 */

проц outdata(Symbol *s)
{
version (HTOD)
{
    return;
}

    цел seg;
    targ_т_мера смещение;
    цел flags;
    const цел codeseg = cseg;

    symbol_debug(s);

    debug
    debugy && printf("outdata('%s')\n",s.Sident.ptr);

    //printf("outdata('%s', ty=x%x)\n",s.Sident.ptr,s.Stype.Tty);
    //symbol_print(s);

    // Data segment variables are always live on exit from a function
    s.Sflags |= SFLlivexit;

    dt_t *dtstart = s.Sdt;
    s.Sdt = null;                      // it will be free'd
    targ_т_мера datasize = 0;
    tym_t ty = s.ty();
version (SCPP)
{
    if (eecontext.EEcompile)
    {   s.Sfl = (s.ty() & mTYfar) ? FLfardata : FLextern;
        s.Sseg = UNKNOWN;
        goto Lret;                      // don't output any данные
    }
}
    if (ty & mTYexport && config.wflags & WFexpdef && s.Sclass != SCstatic)
        objmod.export_symbol(s,0);        // export данные definition
    for (dt_t *dt = dtstart; dt; dt = dt.DTnext)
    {
        //printf("\tdt = %p, dt = %d\n",dt,dt.dt);
        switch (dt.dt)
        {   case DT_abytes:
            {   // Put out the данные for the ткст, and
                // резервируй a spot for a pointer to that ткст
                datasize += size(dt.Dty);      // резервируй spot for pointer to ткст
                if (tybasic(dt.Dty) == TYcptr)
                {   dt.DTseg = codeseg;
                    dt.DTabytes += Offset(codeseg);
                    goto L1;
                }
                else if (tybasic(dt.Dty) == TYfptr &&
                         dt.DTnbytes > config.threshold)
                {
version (SCPP)
{
                    {
                    targ_т_мера foffset;
                    dt.DTseg = objmod.fardata(s.Sident.ptr,dt.DTnbytes,&foffset);
                    dt.DTabytes += foffset;
                    }
}
                L1:
                    objmod.write_bytes(SegData[dt.DTseg],dt.DTnbytes,dt.DTpbytes);
                    break;
                }
                else
                {
                    dt.DTabytes += objmod.data_readonly(cast(сим*)dt.DTpbytes,dt.DTnbytes,&dt.DTseg);
                }
                break;
            }

            case DT_ibytes:
                datasize += dt.DTn;
                break;

            case DT_nbytes:
                //printf("DT_nbytes %d\n", dt.DTnbytes);
                datasize += dt.DTnbytes;
                break;

            case DT_azeros:
                /* A block of zeros
                 */
                //printf("DT_azeros %d\n", dt.DTazeros);
                datasize += dt.DTazeros;
                if (dt == dtstart && !dt.DTnext && s.Sclass != SCcomdat &&
                    (s.Sseg == UNKNOWN || s.Sseg <= UDATA))
                {   /* first and only, so put in BSS segment
                     */
                    switch (ty & mTYLINK)
                    {
version (SCPP)
{
                        case mTYfar:                    // if far данные
                            s.Sseg = objmod.fardata(s.Sident.ptr,datasize,&s.Soffset);
                            s.Sfl = FLfardata;
                            break;
}

                        case mTYcs:
                            s.Sseg = codeseg;
                            Offset(codeseg) = _align(datasize,Offset(codeseg));
                            s.Soffset = Offset(codeseg);
                            Offset(codeseg) += datasize;
                            s.Sfl = FLcsdata;
                            break;

                        case mTYthreadData:
                            assert(config.objfmt == OBJ_MACH && I64);
                            goto case;
                        case mTYthread:
                        {   seg_data *pseg = objmod.tlsseg_bss();
                            s.Sseg = pseg.SDseg;
                            objmod.data_start(s, datasize, pseg.SDseg);
                            if (config.objfmt == OBJ_OMF)
                                pseg.SDoffset += datasize;
                            else
                                objmod.lidata(pseg.SDseg, pseg.SDoffset, datasize);
                            s.Sfl = FLtlsdata;
                            break;
                        }

                        default:
                            s.Sseg = UDATA;
                            objmod.data_start(s,datasize,UDATA);
                            objmod.lidata(s.Sseg,s.Soffset,datasize);
                            s.Sfl = FLudata;           // uninitialized данные
                            break;
                    }
                    assert(s.Sseg && s.Sseg != UNKNOWN);
                    if (s.Sclass == SCglobal || (s.Sclass == SCstatic && config.objfmt != OBJ_OMF)) // if a pubdef to be done
                        objmod.pubdefsize(s.Sseg,s,s.Soffset,datasize);   // do the definition
                    searchfixlist(s);
                    if (config.fulltypes &&
                        !(s.Sclass == SCstatic && funcsym_p)) // not local static
                        cv_outsym(s);
version (SCPP)
{
                    out_extdef(s);
}
                    goto Lret;
                }
                break;

            case DT_common:
                assert(!dt.DTnext);
                outcommon(s,dt.DTazeros);
                goto Lret;

            case DT_xoff:
            {   Symbol *sb = dt.DTsym;

                if (tyfunc(sb.ty()))
                {
version (SCPP)
{
                    nwc_mustwrite(sb);
}
                }
                else if (sb.Sdt)               // if инициализатор for symbol
{ if (!s.Sseg) s.Sseg = DATA;
                    outdata(sb);                // пиши out данные for symbol
}
            }
                goto case;
            case DT_coff:
                datasize += size(dt.Dty);
                break;
            default:
                debug
                printf("dt = %p, dt = %d\n",dt,dt.dt);
                assert(0);
        }
    }

    if (s.Sclass == SCcomdat)          // if initialized common block
    {
        seg = objmod.comdatsize(s, datasize);
        switch (ty & mTYLINK)
        {
            case mTYfar:                // if far данные
                s.Sfl = FLfardata;
                break;

            case mTYcs:
                s.Sfl = FLcsdata;
                break;

            case mTYnear:
            case 0:
                s.Sfl = FLdata;        // initialized данные
                break;

            case mTYthread:
                s.Sfl = FLtlsdata;
                break;

            default:
                assert(0);
        }
    }
    else
    {
      switch (ty & mTYLINK)
      {
version (SCPP)
{
        case mTYfar:                    // if far данные
            seg = objmod.fardata(s.Sident.ptr,datasize,&s.Soffset);
            s.Sfl = FLfardata;
            break;
}

        case mTYcs:
            seg = codeseg;
            Offset(codeseg) = _align(datasize,Offset(codeseg));
            s.Soffset = Offset(codeseg);
            s.Sfl = FLcsdata;
            break;

        case mTYthreadData:
        {
            assert(config.objfmt == OBJ_MACH && I64);

            seg_data *pseg = objmod.tlsseg_data();
            s.Sseg = pseg.SDseg;
            objmod.data_start(s, datasize, s.Sseg);
            seg = pseg.SDseg;
            s.Sfl = FLtlsdata;
            break;
        }
        case mTYthread:
        {
            seg_data *pseg = objmod.tlsseg();
            s.Sseg = pseg.SDseg;
            objmod.data_start(s, datasize, s.Sseg);
            seg = pseg.SDseg;
            s.Sfl = FLtlsdata;
            break;
        }
        case mTYnear:
        case 0:
            if (
                s.Sseg == 0 ||
                s.Sseg == UNKNOWN)
                s.Sseg = DATA;
            seg = objmod.data_start(s,datasize,DATA);
            s.Sfl = FLdata;            // initialized данные
            break;

        default:
            assert(0);
      }
    }
    if (s.Sseg == UNKNOWN && (config.objfmt == OBJ_ELF || config.objfmt == OBJ_MACH))
        s.Sseg = seg;
    else if (config.objfmt == OBJ_OMF)
        s.Sseg = seg;
    else
        seg = s.Sseg;

    if (s.Sclass == SCglobal || (s.Sclass == SCstatic && config.objfmt != OBJ_OMF))
        objmod.pubdefsize(seg,s,s.Soffset,datasize);    /* do the definition            */

    assert(s.Sseg != UNKNOWN);
    if (config.fulltypes &&
        !(s.Sclass == SCstatic && funcsym_p)) // not local static
        cv_outsym(s);
    searchfixlist(s);

    /* Go back through list, now that we know its size, and send out    */
    /* the данные.                                                        */

    смещение = s.Soffset;

    dt_writeToObj(objmod, dtstart, seg, смещение);
    Offset(seg) = смещение;
version (SCPP)
{
    out_extdef(s);
}
Lret:
    dt_free(dtstart);
}


/********************************************
 * Write dt to Object файл.
 * Параметры:
 *      objmod = reference to объект файл
 *      dt = данные to пиши
 *      seg = segment to пиши it to
 *      смещение = starting смещение in segment - will get updated to reflect ending смещение
 */

проц dt_writeToObj(Obj objmod, dt_t *dt, цел seg, ref targ_т_мера смещение)
{
    for (; dt; dt = dt.DTnext)
    {
        switch (dt.dt)
        {
            case DT_abytes:
            {
                цел flags;
                if (tyreg(dt.Dty))
                    flags = CFoff;
                else
                    flags = CFoff | CFseg;
                if (I64)
                    flags |= CFoffset64;
                if (tybasic(dt.Dty) == TYcptr)
                    objmod.reftocodeseg(seg,смещение,dt.DTabytes);
                else
                {
static if (TARGET_LINUX || TARGET_OSX || TARGET_FREEBSD || TARGET_OPENBSD || TARGET_DRAGONFLYBSD || TARGET_SOLARIS)
{
                    objmod.reftodatseg(seg,смещение,dt.DTabytes,dt.DTseg,flags);
}
else
{
                    if (dt.DTseg == DATA)
                        objmod.reftodatseg(seg,смещение,dt.DTabytes,DATA,flags);
                    else
                    {
version (Dinrus)
{
                        if (dt.DTseg == CDATA)
                            objmod.reftodatseg(seg,смещение,dt.DTabytes,CDATA,flags);
                        else
                            objmod.reftofarseg(seg,смещение,dt.DTabytes,dt.DTseg,flags);
}
else
{
                        objmod.reftofarseg(seg,смещение,dt.DTabytes,dt.DTseg,flags);
}
                    }
}
                }
                смещение += size(dt.Dty);
                break;
            }

            case DT_ibytes:
                objmod.bytes(seg,смещение,dt.DTn,dt.DTdata.ptr);
                смещение += dt.DTn;
                break;

            case DT_nbytes:
                objmod.bytes(seg,смещение,dt.DTnbytes,dt.DTpbytes);
                смещение += dt.DTnbytes;
                break;

            case DT_azeros:
                //printf("objmod.lidata(seg = %d, смещение = %d, azeros = %d)\n", seg, смещение, dt.DTazeros);
                SegData[seg].SDoffset = смещение;
                objmod.lidata(seg,смещение,dt.DTazeros);
                смещение = SegData[seg].SDoffset;
                break;

            case DT_xoff:
            {
                Symbol *sb = dt.DTsym;          // get external symbol pointer
                targ_т_мера a = dt.DToffset;    // смещение from it
                цел flags;
                if (tyreg(dt.Dty))
                    flags = CFoff;
                else
                    flags = CFoff | CFseg;
                if (I64 && tysize(dt.Dty) == 8)
                    flags |= CFoffset64;
                смещение += objmod.reftoident(seg,смещение,sb,a,flags);
                break;
            }

            case DT_coff:
                objmod.reftocodeseg(seg,смещение,dt.DToffset);
                смещение += _tysize[TYint];
                break;

            default:
                //printf("dt = %p, dt = %d\n",dt,dt.dt);
                assert(0);
        }
    }
}


/******************************
 * Output n bytes of a common block, n > 0.
 */

проц outcommon(Symbol *s,targ_т_мера n)
{
    //printf("outcommon('%s',%d)\n",s.Sident.ptr,n);
    if (n != 0)
    {
        assert(s.Sclass == SCglobal);
        if (s.ty() & mTYcs) // if store in code segment
        {
            /* COMDEFs not supported in code segment
             * so put them out as initialized 0s
             */
            auto dtb = DtBuilder(0);
            dtb.nzeros(cast(бцел)n);
            s.Sdt = dtb.finish();
            outdata(s);
version (SCPP)
{
            out_extdef(s);
}
        }
        else if (s.ty() & mTYthread) // if store in thread local segment
        {
            if (config.objfmt == OBJ_ELF)
            {
                s.Sclass = SCcomdef;
                objmod.common_block(s, 0, n, 1);
            }
            else
            {
                /* COMDEFs not supported in tls segment
                 * so put them out as COMDATs with initialized 0s
                 */
                s.Sclass = SCcomdat;
                auto dtb = DtBuilder(0);
                dtb.nzeros(cast(бцел)n);
                s.Sdt = dtb.finish();
                outdata(s);
version (SCPP)
{
                if (config.objfmt == OBJ_OMF)
                    out_extdef(s);
}
            }
        }
        else
        {
            s.Sclass = SCcomdef;
            if (config.objfmt == OBJ_OMF)
            {
                s.Sxtrnnum = objmod.common_block(s,(s.ty() & mTYfar) == 0,n,1);
                if (s.ty() & mTYfar)
                    s.Sfl = FLfardata;
                else
                    s.Sfl = FLextern;
                s.Sseg = UNKNOWN;
                pstate.STflags |= PFLcomdef;
version (SCPP)
{
                ph_comdef(s);               // notify PH that a COMDEF went out
}
            }
            else
                objmod.common_block(s, 0, n, 1);
        }
        if (config.fulltypes)
            cv_outsym(s);
    }
}

/*************************************
 * Mark a Symbol as going into a читай-only segment.
 */

проц out_readonly(Symbol *s)
{
    if (config.objfmt == OBJ_ELF || config.objfmt == OBJ_MACH)
    {
        /* Cannot have pointers in CDATA when compiling PIC code, because
         * they require dynamic relocations of the читай-only segment.
         * Instead use the .данные.rel.ro section.
         * https://issues.dlang.org/show_bug.cgi?ид=11171
         */
        if (config.flags3 & CFG3pic && dtpointers(s.Sdt))
            s.Sseg = CDATAREL;
        else
            s.Sseg = CDATA;
    }
    else
    {
        s.Sseg = CDATA;
    }
}

/*************************************
 * Write out a readonly ткст literal in an implementation-defined
 * manner.
 * Параметры:
 *      str = pointer to ткст данные (need not have terminating 0)
 *      len = number of characters in ткст
 *      sz = size of each character (1, 2 or 4)
 * Возвращает: a Symbol pointing to it.
 */
Symbol *out_string_literal(ткст0 str, бцел len, бцел sz)
{
    tym_t ty = TYchar;
    if (sz == 2)
        ty = TYchar16;
    else if (sz == 4)
        ty = TYdchar;
    Symbol *s = symbol_generate(SCstatic,type_static_array(len, tstypes[ty]));
    switch (config.objfmt)
    {
        case OBJ_ELF:
        case OBJ_MACH:
            s.Sseg = objmod.string_literal_segment(sz);
            break;

        case OBJ_MSCOFF:
        case OBJ_OMF:   // goes into COMDATs, handled elsewhere
        default:
            assert(0);
    }

    /* If there are any embedded zeros, this can't go in the special ткст segments
     * which assume that 0 is the end of the ткст.
     */
    switch (sz)
    {
        case 1:
            if (memchr(str, 0, len))
                s.Sseg = CDATA;
            break;

        case 2:
            for (цел i = 0; i < len; ++i)
            {
                ushort* p = cast(ushort*)str;
                if (p[i] == 0)
                {
                    s.Sseg = CDATA;
                    break;
                }
            }
            break;

        case 4:
            for (цел i = 0; i < len; ++i)
            {
                бцел* p = cast(бцел*)str;
                if (p[i] == 0)
                {
                    s.Sseg = CDATA;
                    break;
                }
            }
            break;

        default:
            assert(0);
    }

    auto dtb = DtBuilder(0);
    dtb.члобайт(cast(бцел)(len * sz), str);
    dtb.nzeros(cast(бцел)sz);       // include terminating 0
    s.Sdt = dtb.finish();
    s.Sfl = FLdata;
    s.Salignment = sz;
    outdata(s);
    return s;
}


/******************************
 * Walk Выражение tree, converting it from a PARSER tree to
 * a code generator tree.
 */

/*private*/ проц outelem(elem *e, ref бул addressOfParam)
{
    Symbol *s;
    tym_t tym;
    elem *e1;
version (SCPP)
{
    тип *t;
}

again:
    assert(e);
    elem_debug(e);

debug
{
    if (OTbinary(e.Eoper))
        assert(e.EV.E1 && e.EV.E2);
//    else if (OTunary(e.Eoper))
//      assert(e.EV.E1 && !e.EV.E2);
}

version (SCPP)
{
    t = e.ET;
    assert(t);
    type_debug(t);
    tym = t.Tty;
    switch (tybasic(tym))
    {
        case TYstruct:
            t.Tcount++;
            break;

        case TYarray:
            t.Tcount++;
            break;

        case TYбул:
        case TYwchar_t:
        case TYchar16:
        case TYmemptr:
        case TYvtshape:
        case TYnullptr:
            tym = tym_conv(t);
            e.ET = null;
            break;

        case TYenum:
            tym = tym_conv(t.Tnext);
            e.ET = null;
            break;

        default:
            e.ET = null;
            break;
    }
    e.Nflags = 0;
    e.Ety = tym;
}

    switch (e.Eoper)
    {
    default:
    Lop:
debug
{
        //if (!EOP(e)) printf("e.Eoper = x%x\n",e.Eoper);
}
        if (OTbinary(e.Eoper))
        {   outelem(e.EV.E1, addressOfParam);
            e = e.EV.E2;
        }
        else if (OTunary(e.Eoper))
        {
            e = e.EV.E1;
        }
        else
            break;
version (SCPP)
{
        type_free(t);
}
        goto again;                     /* iterate instead of recurse   */
    case OPaddr:
        e1 = e.EV.E1;
        if (e1.Eoper == OPvar)
        {   // Fold into an OPrelconst
version (SCPP)
{
            el_copy(e,e1);
            e.ET = t;
}
else
{
            tym = e.Ety;
            el_copy(e,e1);
            e.Ety = tym;
}
            e.Eoper = OPrelconst;
            el_free(e1);
            goto again;
        }
        goto Lop;

    case OPrelconst:
    case OPvar:
    L6:
        s = e.EV.Vsym;
        assert(s);
        symbol_debug(s);
        switch (s.Sclass)
        {
            case SCregpar:
            case SCparameter:
            case SCshadowreg:
                if (e.Eoper == OPrelconst)
                {
                    if (I16)
                        addressOfParam = да;   // taking addr of param list
                    else
                        s.Sflags &= ~(SFLunambig | GTregcand);
                }
                break;

            case SCstatic:
            case SClocstat:
            case SCextern:
            case SCglobal:
            case SCcomdat:
            case SCcomdef:
            case SCpseudo:
            case SCinline:
            case SCsinline:
            case SCeinline:
                s.Sflags |= SFLlivexit;
                goto case;
            case SCauto:
            case SCregister:
            case SCfastpar:
            case SCbprel:
                if (e.Eoper == OPrelconst)
                {
                    s.Sflags &= ~(SFLunambig | GTregcand);
                }
                else if (s.ty() & mTYfar)
                    e.Ety |= mTYfar;
                break;
version (SCPP)
{
            case SCmember:
                err_noinstance(s.Sscope,s);
                goto L5;

            case SCstruct:
                cpperr(EM_no_instance,s.Sident.ptr);       // no instance of class
            L5:
                e.Eoper = OPconst;
                e.Ety = TYint;
                return;

            case SCfuncalias:
                e.EV.Vsym = s.Sfunc.Falias;
                goto L6;

            case SCstack:
                break;

            case SCfunctempl:
                cpperr(EM_no_template_instance, s.Sident.ptr);
                break;

            default:
                symbol_print(s);
                WRclass(cast(SC) s.Sclass);
                assert(0);
}
else
{
            default:
                break;
}
        }
version (SCPP)
{
        if (tyfunc(s.ty()))
        {
            nwc_mustwrite(s);           /* must пиши out function      */
        }
        else if (s.Sdt)                /* if инициализатор for symbol    */
            outdata(s);                 // пиши out данные for symbol
        if (config.flags3 & CFG3pic)
        {
            objmod.gotref(s);
        }
}
        break;

    case OPstring:
    case OPconst:
    case OPstrthis:
        break;

    case OPsizeof:
version (SCPP)
{
        e.Eoper = OPconst;
        e.EV.Vlong = type_size(e.EV.Vsym.Stype);
        break;
}
else
{
        assert(0);
}

version (SCPP)
{
    case OPstreq:
    case OPstrpar:
    case OPstrctor:
        type_size(e.EV.E1.ET);
        goto Lop;

    case OPasm:
        break;

    case OPctor:
        nwc_mustwrite(e.EV.Edtor);
        goto case;
    case OPdtor:
        // Don't put 'this' pointers in registers if we need
        // them for EH stack cleanup.
        e1 = e.EV.E1;
        elem_debug(e1);
        if (e1.Eoper == OPadd)
            e1 = e1.EV.E1;
        if (e1.Eoper == OPvar)
            e1.EV.Vsym.Sflags &= ~GTregcand;
        goto Lop;

    case OPmark:
        break;
}
    }
version (SCPP)
{
    type_free(t);
}
}

/*************************************
 * Determine register candidates.
 */

проц out_regcand(symtab_t *psymtab)
{
    //printf("out_regcand()\n");
    const бул ifunc = (tybasic(funcsym_p.ty()) == TYifunc);
    for (SYMIDX si = 0; si < psymtab.top; si++)
    {   Symbol *s = psymtab.tab[si];

        symbol_debug(s);
        //assert(sytab[s.Sclass] & SCSS);      // only stack variables
        s.Ssymnum = si;                        // Ssymnum trashed by cpp_inlineexpand
        if (!(s.ty() & (mTYvolatile | mTYshared)) &&
            !(ifunc && (s.Sclass == SCparameter || s.Sclass == SCregpar)) &&
            s.Sclass != SCstatic)
            s.Sflags |= (GTregcand | SFLunambig);      // assume register candidate
        else
            s.Sflags &= ~(GTregcand | SFLunambig);
    }

    бул addressOfParam = нет;                  // haven't taken addr of param yet
    for (block *b = startblock; b; b = b.Bnext)
    {
        if (b.Belem)
            out_regcand_walk(b.Belem, addressOfParam);

        // Any assembler blocks make everything ambiguous
        if (b.BC == BCasm)
            for (SYMIDX si = 0; si < psymtab.top; si++)
                psymtab.tab[si].Sflags &= ~(SFLunambig | GTregcand);
    }

    // If we took the address of one параметр, assume we took the
    // address of all non-register parameters.
    if (addressOfParam)                      // if took address of a параметр
    {
        for (SYMIDX si = 0; si < psymtab.top; si++)
            if (psymtab.tab[si].Sclass == SCparameter || psymtab.tab[si].Sclass == SCshadowreg)
                psymtab.tab[si].Sflags &= ~(SFLunambig | GTregcand);
    }

}

private проц out_regcand_walk(elem *e, ref бул addressOfParam)
{
    while (1)
    {   elem_debug(e);

        if (OTbinary(e.Eoper))
        {   if (e.Eoper == OPstreq)
            {   if (e.EV.E1.Eoper == OPvar)
                {
                    Symbol *s = e.EV.E1.EV.Vsym;
                    s.Sflags &= ~(SFLunambig | GTregcand);
                }
                if (e.EV.E2.Eoper == OPvar)
                {
                    Symbol *s = e.EV.E2.EV.Vsym;
                    s.Sflags &= ~(SFLunambig | GTregcand);
                }
            }
            out_regcand_walk(e.EV.E1, addressOfParam);
            e = e.EV.E2;
        }
        else if (OTunary(e.Eoper))
        {
            // Don't put 'this' pointers in registers if we need
            // them for EH stack cleanup.
            if (e.Eoper == OPctor)
            {   elem *e1 = e.EV.E1;

                if (e1.Eoper == OPadd)
                    e1 = e1.EV.E1;
                if (e1.Eoper == OPvar)
                    e1.EV.Vsym.Sflags &= ~GTregcand;
            }
            e = e.EV.E1;
        }
        else
        {   if (e.Eoper == OPrelconst)
            {
                Symbol *s = e.EV.Vsym;
                assert(s);
                symbol_debug(s);
                switch (s.Sclass)
                {
                    case SCregpar:
                    case SCparameter:
                    case SCshadowreg:
                        if (I16)
                            addressOfParam = да;       // taking addr of param list
                        else
                            s.Sflags &= ~(SFLunambig | GTregcand);
                        break;

                    case SCauto:
                    case SCregister:
                    case SCfastpar:
                    case SCbprel:
                        s.Sflags &= ~(SFLunambig | GTregcand);
                        break;

                    default:
                        break;
                }
            }
            else if (e.Eoper == OPvar)
            {
                if (e.EV.Voffset)
                {   if (!(e.EV.Voffset == 1 && tybyte(e.Ety)) &&
                        !(e.EV.Voffset == REGSIZE && tysize(e.Ety) == REGSIZE))
                    {
                        e.EV.Vsym.Sflags &= ~GTregcand;
                    }
                }
            }
            break;
        }
    }
}


/**************************
 * Optimize function,
 * generate code for it,
 * and пиши it out.
 */

проц writefunc(Symbol *sfunc)
{
version (HTOD)
{
    return;
}
else version (SCPP)
{
    writefunc2(sfunc);
}
else
{
    cstate.CSpsymtab = &globsym;
    writefunc2(sfunc);
    cstate.CSpsymtab = null;
}
}

private проц writefunc2(Symbol *sfunc)
{
    func_t *f = sfunc.Sfunc;

    //printf("writefunc(%s)\n",sfunc.Sident.ptr);
    debug debugy && printf("writefunc(%s)\n",sfunc.Sident.ptr);
version (SCPP)
{
    if (CPP)
    {

    // If constructor or destructor, make sure it has been fixed.
    if (f.Fflags & (Fctor | Fdtor))
        assert(errcnt || f.Fflags & Ffixed);

    // If this function is the 'trigger' to output the vtbl[], do so
    if (f.Fflags3 & Fvtblgen && !eecontext.EEcompile)
    {
        Classsym *stag = cast(Classsym *) sfunc.Sscope;
        {
            SC scvtbl;

            scvtbl = cast(SC) ((config.flags2 & CFG2comdat) ? SCcomdat : SCglobal);
            n2_genvtbl(stag,scvtbl,1);
            n2_genvbtbl(stag,scvtbl,1);
static if (SYMDEB_CODEVIEW)
{
            if (config.fulltypes == CV4)
                cv4_struct(stag,2);
}
        }
    }
    }
}

    /* Signify that function has been output                    */
    /* (before inline_do() to prevent infinite recursion!)      */
    f.Fflags &= ~Fpending;
    f.Fflags |= Foutput;

version (SCPP)
{
    if (errcnt)
        return;
}

    if (eecontext.EEcompile && eecontext.EEfunc != sfunc)
        return;

    /* Copy local symbol table onto main one, making sure       */
    /* that the symbol numbers are adjusted accordingly */
    //printf("f.Flocsym.top = %d\n",f.Flocsym.top);
    бцел nsymbols = f.Flocsym.top;
    if (nsymbols > globsym.symmax)
    {   /* Reallocate globsym.tab[]     */
        globsym.symmax = nsymbols;
        globsym.tab = symtab_realloc(globsym.tab, globsym.symmax);
    }
    debug debugy && printf("appending symbols to symtab...\n");
    assert(globsym.top == 0);
    memcpy(&globsym.tab[0],&f.Flocsym.tab[0],nsymbols * (Symbol *).sizeof);
    globsym.top = nsymbols;

    assert(startblock == null);
    if (f.Fflags & Finline)            // if keep function around
    {   // Generate копируй of function

        block **pb = &startblock;
        for (block *bf = f.Fstartblock; bf; bf = bf.Bnext)
        {
            block *b = block_calloc();
            *pb = b;
            pb = &b.Bnext;

            *b = *bf;
            assert(b.numSucc() == 0);
            assert(!b.Bpred);
            b.Belem = el_copytree(b.Belem);
        }
    }
    else
    {   startblock = sfunc.Sfunc.Fstartblock;
        sfunc.Sfunc.Fstartblock = null;
    }
    assert(startblock);

    /* Do any in-line expansion of function calls inside sfunc  */
version (SCPP)
{
    inline_do(sfunc);
}

version (SCPP)
{
    /* If function is _STIxxxx, add in the auto destructors             */
    if (cpp_stidtors && memcmp("__SI".ptr,sfunc.Sident.ptr,4) == 0)
    {
        assert(startblock.Bnext == null);
        list_t el = cpp_stidtors;
        do
        {
            startblock.Belem = el_combine(startblock.Belem,list_elem(el));
            el = list_next(el);
        } while (el);
        list_free(&cpp_stidtors,FPNULL);
    }
}
    assert(funcsym_p == null);
    funcsym_p = sfunc;
    tym_t tyf = tybasic(sfunc.ty());

version (SCPP)
{
    out_extdef(sfunc);
}

    // TX86 computes параметр offsets in stackoffsets()
    //printf("globsym.top = %d\n", globsym.top);

version (SCPP)
{
    FuncParamRegs fpr = FuncParamRegs_create(tyf);
}

    for (SYMIDX si = 0; si < globsym.top; si++)
    {   Symbol *s = globsym.tab[si];

        symbol_debug(s);
        //printf("symbol %d '%s'\n",si,s.Sident.ptr);

        type_size(s.Stype);    // do any forward template instantiations

        s.Ssymnum = si;        // Ssymnum trashed by cpp_inlineexpand
        s.Sflags &= ~(SFLunambig | GTregcand);
        switch (s.Sclass)
        {
            case SCbprel:
                s.Sfl = FLbprel;
                goto L3;

            case SCauto:
            case SCregister:
                s.Sfl = FLauto;
                goto L3;

version (SCPP)
{
            case SCfastpar:
            case SCregpar:
            case SCparameter:
                if (si == 0 && FuncParamRegs_alloc(fpr, s.Stype, s.Stype.Tty, &s.Spreg, &s.Spreg2))
                {
                    assert(s.Spreg == ((tyf == TYmfunc) ? CX : AX));
                    assert(s.Spreg2 == NOREG);
                    assert(si == 0);
                    s.Sclass = SCfastpar;
                    s.Sfl = FLfast;
                    goto L3;
                }
                assert(s.Sclass != SCfastpar);
}
else
{
            case SCfastpar:
                s.Sfl = FLfast;
                goto L3;

            case SCregpar:
            case SCparameter:
            case SCshadowreg:
}
                s.Sfl = FLpara;
                if (tyf == TYifunc)
                {   s.Sflags |= SFLlivexit;
                    break;
                }
            L3:
                if (!(s.ty() & (mTYvolatile | mTYshared)))
                    s.Sflags |= GTregcand | SFLunambig; // assume register candidate   */
                break;

            case SCpseudo:
                s.Sfl = FLpseudo;
                break;

            case SCstatic:
                break;                  // already taken care of by datadef()

            case SCstack:
                s.Sfl = FLstack;
                break;

            default:
                symbol_print(s);
                assert(0);
        }
    }

    бул addressOfParam = нет;  // see if any parameters get their address taken
    бул anyasm = нет;
    numblks = 0;
    for (block *b = startblock; b; b = b.Bnext)
    {
        numblks++;                              // redo count
        memset(&b._BLU,0,block.sizeof - block._BLU.offsetof);
        if (b.Belem)
        {   outelem(b.Belem, addressOfParam);
version (SCPP)
{
            if (!el_returns(b.Belem) && !(config.flags3 & CFG3eh))
            {   b.BC = BCexit;
                list_free(&b.Bsucc,FPNULL);
            }
}
version (Dinrus)
{
            if (b.Belem.Eoper == OPhalt)
            {   b.BC = BCexit;
                list_free(&b.Bsucc,FPNULL);
            }
}
        }
        if (b.BC == BCasm)
            anyasm = да;
        if (sfunc.Sflags & SFLexit && (b.BC == BCret || b.BC == BCretexp))
        {   b.BC = BCexit;
            list_free(&b.Bsucc,FPNULL);
        }
        assert(b != b.Bnext);
    }
    PARSER = 0;
    if (eecontext.EEelem)
    {   бцел marksi = globsym.top;

        eecontext.EEin++;
        outelem(eecontext.EEelem, addressOfParam);
        eecontext.EEelem = doptelem(eecontext.EEelem,да);
        eecontext.EEin--;
        eecontext_convs(marksi);
    }
    maxblks = 3 * numblks;              // allow for increase in # of blocks
    // If we took the address of one параметр, assume we took the
    // address of all non-register parameters.
    if (addressOfParam | anyasm)        // if took address of a параметр
    {
        for (SYMIDX si = 0; si < globsym.top; si++)
            if (anyasm || globsym.tab[si].Sclass == SCparameter)
                globsym.tab[si].Sflags &= ~(SFLunambig | GTregcand);
    }

    block_pred();                       // compute predecessors to blocks
    block_compbcount();                 // eliminate unreachable blocks
    if (go.mfoptim)
    {   OPTIMIZER = 1;
        optfunc();                      /* optimize function            */
        OPTIMIZER = 0;
    }
    else
    {
        //printf("blockopt()\n");
        blockopt(0);                    /* optimize                     */
    }

version (SCPP)
{
    if (CPP)
    {
        version (DEBUG_XSYMGEN)
        {
            /* the internal dataview function is allowed to lie about its return значение */
            const noret = compile_state != kDataView;
        }
        else
            const noret = да;

        // Look for any blocks that return nothing.
        // Do it after optimization to eliminate any spurious
        // messages like the implicit return on { while(1) { ... } }
        if (tybasic(funcsym_p.Stype.Tnext.Tty) != TYvoid &&
            !(funcsym_p.Sfunc.Fflags & (Fctor | Fdtor | Finvariant))
            && noret
           )
        {
            сим err = 0;
            for (block *b = startblock; b; b = b.Bnext)
            {   if (b.BC == BCasm)     // no errors if any asm blocks
                    err |= 2;
                else if (b.BC == BCret)
                    err |= 1;
            }
            if (err == 1)
                func_noreturnvalue();
        }
    }
}
    assert(funcsym_p == sfunc);
    const цел CSEGSAVE_DEFAULT = -10000;        // some unlikely number
    цел csegsave = CSEGSAVE_DEFAULT;
    if (eecontext.EEcompile != 1)
    {
        if (symbol_iscomdat2(sfunc))
        {
            csegsave = cseg;
            objmod.comdat(sfunc);
            cseg = sfunc.Sseg;
        }
        else
            if (config.flags & CFGsegs) // if user set switch for this
            {
version (SCPP)
{
                objmod.codeseg(cpp_mangle(funcsym_p),1);
}
else static if (TARGET_WINDOS)
{
                objmod.codeseg(cast(сим*)cpp_mangle(funcsym_p),1);
}
else
{
                objmod.codeseg(funcsym_p.Sident.ptr, 1);
}
                                        // generate new code segment
            }
        cod3_align(cseg);               // align start of function
version (HTOD) { } else
{
        objmod.func_start(sfunc);
}
        searchfixlist(sfunc);           // backpatch any refs to this function
    }

    //printf("codgen()\n");
version (SCPP)
{
    if (!errcnt)
        codgen(sfunc);                  // generate code
}
else
{
    codgen(sfunc);                  // generate code
}
    //printf("after codgen for %s Coffset %x\n",sfunc.Sident.ptr,Offset(cseg));
    blocklist_free(&startblock);
version (SCPP)
{
    PARSER = 1;
}
version (HTOD) { } else
{
    objmod.func_term(sfunc);
}
    if (eecontext.EEcompile == 1)
        goto Ldone;
    if (sfunc.Sclass == SCglobal)
    {
        if ((config.objfmt == OBJ_OMF || config.objfmt == OBJ_MSCOFF) && !(config.flags4 & CFG4allcomdat))
        {
            assert(sfunc.Sseg == cseg);
            objmod.pubdef(sfunc.Sseg,sfunc,sfunc.Soffset);       // make a public definition
        }

version (SCPP)
{
version (Win32)
{
        // Determine which startup code to reference
        if (!CPP || !isclassmember(sfunc))              // if not member function
        {    сим*[6] startup =
            [   "__acrtused","__acrtused_winc","__acrtused_dll",
                "__acrtused_con","__wacrtused","__wacrtused_con",
            ];
            цел i;

            ткст0 ид = sfunc.Sident.ptr;
            switch (ид[0])
            {
                case 'D': if (strcmp(ид,"DllMain"))
                                break;
                          if (config.exe == EX_WIN32)
                          {     i = 2;
                                goto L2;
                          }
                          break;

                case 'm': if (strcmp(ид,"main"))
                                break;
                          if (config.exe == EX_WIN32)
                                i = 3;
                          else if (config.wflags & WFwindows)
                                i = 1;
                          else
                                i = 0;
                          goto L2;

                case 'w': if (strcmp(ид,"wmain") == 0)
                          {
                                if (config.exe == EX_WIN32)
                                {   i = 5;
                                    goto L2;
                                }
                                break;
                          }
                          goto case;
                case 'W': if (stricmp(ид,"WinMain") == 0)
                          {
                                i = 0;
                                goto L2;
                          }
                          if (stricmp(ид,"wWinMain") == 0)
                          {
                                if (config.exe == EX_WIN32)
                                {   i = 4;
                                    goto L2;
                                }
                          }
                          break;

                case 'L':
                case 'l': if (stricmp(ид,"LibMain"))
                                break;
                          if (config.exe != EX_WIN32 && config.wflags & WFwindows)
                          {     i = 2;
                                goto L2;
                          }
                          break;

                L2:     objmod.external_def(startup[i]);          // pull in startup code
                        break;

                default:
                    break;
            }
        }
}
}
    }
    if (config.wflags & WFexpdef &&
        sfunc.Sclass != SCstatic &&
        sfunc.Sclass != SCsinline &&
        !(sfunc.Sclass == SCinline && !(config.flags2 & CFG2comdat)) &&
        sfunc.ty() & mTYexport)
        objmod.export_symbol(sfunc,cast(бцел)Para.смещение);      // export function definition

    if (config.fulltypes && config.fulltypes != CV8)
        cv_func(sfunc);                 // debug info for function

version (Dinrus)
{
    /* This is to make uplevel references to SCfastpar variables
     * from nested functions work.
     */
    for (SYMIDX si = 0; si < globsym.top; si++)
    {
        Symbol *s = globsym.tab[si];

        switch (s.Sclass)
        {   case SCfastpar:
                s.Sclass = SCauto;
                break;

            default:
                break;
        }
    }
    /* After codgen() and writing debug info for the locals,
     * readjust the offsets of all stack variables so they
     * are relative to the frame pointer.
     * Necessary for nested function access to lexically enclosing frames.
     */
     cod3_adjSymOffsets();
}

    if (symbol_iscomdat2(sfunc))         // if generated a COMDAT
    {
        assert(csegsave != CSEGSAVE_DEFAULT);
        objmod.setcodeseg(csegsave);       // сбрось to real code seg
        if (config.objfmt == OBJ_MACH)
            assert(cseg == CODE);
    }

    /* Check if function is a constructor or destructor, by     */
    /* seeing if the function имя starts with _STI or _STD     */
    {
version (LittleEndian)
{
        short *p = cast(short *) sfunc.Sident.ptr;
        if (p[0] == (('S' << 8) | '_') && (p[1] == (('I' << 8) | 'T') || p[1] == (('D' << 8) | 'T')))
            objmod.setModuleCtorDtor(sfunc, sfunc.Sident.ptr[3] == 'I');
}
else
{
        сим *p = sfunc.Sident.ptr;
        if (p[0] == '_' && p[1] == 'S' && p[2] == 'T' &&
            (p[3] == 'I' || p[3] == 'D'))
            objmod.setModuleCtorDtor(sfunc, sfunc.Sident.ptr[3] == 'I');
}
    }

Ldone:
    funcsym_p = null;

version (SCPP)
{
    // Free any added symbols
    freesymtab(globsym.tab,nsymbols,globsym.top);
}
    globsym.top = 0;

    //printf("done with writefunc()\n");
    //dfo.dtor();       // save allocation for следщ time
}

/*************************
 * Align segment смещение.
 * Input:
 *      seg             segment to be aligned
 *      datasize        size in bytes of объект to be aligned
 */

проц alignOffset(цел seg,targ_т_мера datasize)
{
    targ_т_мера alignbytes = _align(datasize,Offset(seg)) - Offset(seg);
    //printf("seg %d datasize = x%x, Offset(seg) = x%x, alignbytes = x%x\n",
      //seg,datasize,Offset(seg),alignbytes);
    if (alignbytes)
        objmod.lidata(seg,Offset(seg),alignbytes);
}

/***************************************
 * Write данные into читай-only данные segment.
 * Return symbol for it.
 */

const ROMAX = 32;
struct Readonly
{
    Symbol *sym;
    т_мера length;
    ббайт[ROMAX] p;
}

const RMAX = 16;
private 
{
    Readonly[RMAX] readonly;
    т_мера readonly_length;
    т_мера readonly_i;
}

проц out_reset()
{
    readonly_length = 0;
    readonly_i = 0;
}

Symbol *out_readonly_sym(tym_t ty, проц *p, цел len)
{
version (HTOD)
{
    return null;
}
else
{
static if (0)
{
    printf("out_readonly_sym(ty = x%x)\n", ty);
    for (цел i = 0; i < len; i++)
        printf(" [%d] = %02x\n", i, (cast(ббайт*)p)[i]);
}
    // Look for previous symbol we can reuse
    for (цел i = 0; i < readonly_length; i++)
    {
        Readonly *r = &readonly[i];
        if (r.length == len && memcmp(p, r.p.ptr, len) == 0)
            return r.sym;
    }

    Symbol *s;

version (Dinrus)
{
    бул cdata = config.objfmt == OBJ_ELF ||
                 config.objfmt == OBJ_OMF ||
                 config.objfmt == OBJ_MSCOFF;
}
else
{
    бул cdata = config.objfmt == OBJ_ELF;
}
    if (cdata)
    {
        /* MACHOBJ can't go here, because the const данные segment goes into
         * the _TEXT segment, and one cannot have a fixup from _TEXT to _TEXT.
         */
        s = objmod.sym_cdata(ty, cast(сим *)p, len);
    }
    else
    {
        бцел sz = tysize(ty);

        alignOffset(DATA, sz);
        s = symboldata(Offset(DATA),ty | mTYconst);
        s.Sseg = DATA;
        objmod.write_bytes(SegData[DATA], len, p);
        //printf("s.Sseg = %d:x%x\n", s.Sseg, s.Soffset);
    }

    if (len <= ROMAX)
    {   Readonly *r;

        if (readonly_length < RMAX)
        {
            r = &readonly[readonly_length];
            readonly_length++;
        }
        else
        {   r = &readonly[readonly_i];
            readonly_i++;
            if (readonly_i >= RMAX)
                readonly_i = 0;
        }
        r.length = len;
        r.sym = s;
        memcpy(r.p.ptr, p, len);
    }
    return s;
}
}

/*************************************
 * Output Symbol as a readonly comdat.
 * Параметры:
 *      s = comdat symbol
 *      p = pointer to the данные to пиши
 *      len = length of that данные
 *      nzeros = number of trailing zeros to приставь
 */
проц out_readonly_comdat(Symbol *s, ук p, бцел len, бцел nzeros)
{
    objmod.readonly_comdat(s);         // создай comdat segment
    objmod.write_bytes(SegData[s.Sseg], len, cast(проц *)p);
    objmod.lidata(s.Sseg, len, nzeros);
}

проц Srcpos_print(ref Srcpos srcpos, ткст0 func)
{
    printf("%s(", func);
version (Dinrus)
{
    printf("Sfilename = %s", srcpos.Sfilename ? srcpos.Sfilename : "null".ptr);
}
else
{
    const sf = srcpos.Sfilptr ? *srcpos.Sfilptr : null;
    printf("Sfilptr = %p (имяф = %s)", sf, sf ? sf.SFname : "null".ptr);
}
    printf(", Slinnum = %u", srcpos.Slinnum);
    printf(")\n");
}


}
