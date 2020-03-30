/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/tocsym.d, _tocvdebug.d)
 * Documentation:  https://dlang.org/phobos/dmd_tocvdebug.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/tocvdebug.d
 */

module dmd.tocvdebug;

version (Windows)
{

import cidrus;

import util.array;
import util.rmem;

import dmd.aggregate;
import dmd.dclass;
import dmd.declaration;
import dmd.denum;
import dmd.dmodule;
import dmd.дсимвол;
import dmd.dstruct;
import dmd.dtemplate;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import dmd.mtype;
import dmd.target;
import dmd.toctype;
import drc.ast.Visitor;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.cgcv;
import drc.backend.code;
import drc.backend.cv4;
import drc.backend.dlist;
import drc.backend.dt;
import drc.backend.глоб2;
import drc.backend.obj;
import drc.backend.oper;
import drc.backend.ty;
import drc.backend.тип;

/*extern (C++):*/

/* The CV4 debug format is defined in:
 *      "CV4 Symbolic Debug Information Specification"
 *      rev 3.1 March 5, 1993
 *      Languages Business Unit
 *      Microsoft
 */

/******************************
 * CV4 pg. 25
 * Convert D защита attribute to cv attribute.
 */

бцел PROTtoATTR(Prot.Kind prot)    
{
    бцел attribute;

    switch (prot)
    {
        case Prot.Kind.private_:       attribute = 1;  break;
        case Prot.Kind.package_:       attribute = 2;  break;
        case Prot.Kind.protected_:     attribute = 2;  break;
        case Prot.Kind.public_:        attribute = 3;  break;
        case Prot.Kind.export_:        attribute = 3;  break;

        case Prot.Kind.undefined:
        case Prot.Kind.none:
            //printf("prot = %d\n", prot);
            assert(0);
    }
    return attribute;
}

бцел cv4_memfunctypidx(FuncDeclaration fd)
{
    //printf("cv4_memfunctypidx(fd = '%s')\n", fd.вТкст0());

    тип *t = Type_toCtype(fd.тип);
    if (AggregateDeclaration ad = fd.isMemberLocal())
    {
        // It's a member function, which gets a special тип record

        const idx_t thisidx = fd.isStatic()
                    ? dttab4[TYvoid]
                    : (ad.handleType() ? cv4_typidx(Type_toCtype(ad.handleType())) : 0);
        assert(thisidx);

        бцел nparam;
        const idx_t paramidx = cv4_arglist(t,&nparam);

        const ббайт call = cv4_callconv(t);

        switch (config.fulltypes)
        {
            case CV4:
            {
                debtyp_t* d = debtyp_alloc(18);
                ббайт *p = &d.данные[0];
                TOWORD(p,LF_MFUNCTION);
                TOWORD(p + 2,cv4_typidx(t.Tnext));
                TOWORD(p + 4,cv4_typidx(Type_toCtype(ad.тип)));
                TOWORD(p + 6,thisidx);
                p[8] = call;
                p[9] = 0;                               // reserved
                TOWORD(p + 10,nparam);
                TOWORD(p + 12,paramidx);
                TOLONG(p + 14,0);                       // thisadjust
                return cv_debtyp(d);
            }
            case CV8:
            {
                debtyp_t* d = debtyp_alloc(26);
                ббайт *p = &d.данные[0];
                TOWORD(p,0x1009);
                TOLONG(p + 2,cv4_typidx(t.Tnext));
                TOLONG(p + 6,cv4_typidx(Type_toCtype(ad.тип)));
                TOLONG(p + 10,thisidx);
                p[14] = call;
                p[15] = 0;                               // reserved
                TOWORD(p + 16,nparam);
                TOLONG(p + 18,paramidx);
                TOLONG(p + 22,0);                       // thisadjust
                return cv_debtyp(d);
            }
            default:
                assert(0);
        }
    }
    return cv4_typidx(t);
}

const CV4_NAMELENMAX = 0x3b9f;                   // found by trial and error
const CV8_NAMELENMAX = 0xffff;                   // length record is 16-bit only

бцел cv4_Denum(EnumDeclaration e)
{
    //dbg_printf("cv4_Denum(%s)\n", e.вТкст0());
    const бцел property = (!e.члены || !e.memtype || !e.memtype.isintegral())
        ? 0x80               // enum is forward referenced or non-integer
        : 0;

    // Compute the number of fields, and the length of the fieldlist record
    CvFieldList mc = CvFieldList(0, 0);
    if (!property)
    {
        for (т_мера i = 0; i < e.члены.dim; i++)
        {
            if (EnumMember sf = (*e.члены)[i].isEnumMember())
            {
                const значение = sf.значение().toInteger();

                // store only member's simple имя
                бцел len = 4 + cv4_numericbytes(cast(бцел)значение) + cv_stringbytes(sf.вТкст0());

                len = cv_align(null, len);
                mc.count(len);
            }
        }
    }

    const ид = e.toPrettyChars();
    бцел len;
    debtyp_t *d;
    const бцел memtype = e.memtype ? cv4_typidx(Type_toCtype(e.memtype)) : 0;
    switch (config.fulltypes)
    {
        case CV8:
            len = 14;
            d = debtyp_alloc(len + cv_stringbytes(ид));
            TOWORD(d.данные.ptr,LF_ENUM_V3);
            TOLONG(d.данные.ptr + 6,memtype);
            TOWORD(d.данные.ptr + 4,property);
            len += cv_namestring(d.данные.ptr + len,ид);
            break;

        case CV4:
            len = 10;
            d = debtyp_alloc(len + cv_stringbytes(ид));
            TOWORD(d.данные.ptr,LF_ENUM);
            TOWORD(d.данные.ptr + 4,memtype);
            TOWORD(d.данные.ptr + 8,property);
            len += cv_namestring(d.данные.ptr + len,ид);
            break;

        default:
            assert(0);
    }
    const length_save = d.length;
    d.length = 0;                      // so cv_debtyp() will размести new
    const idx_t typidx = cv_debtyp(d);
    d.length = length_save;            // restore length

    TOWORD(d.данные.ptr + 2, mc.nfields);

    бцел fieldlist = 0;
    if (!property)                      // if forward reference, then fieldlist is 0
    {
        // Generate fieldlist тип record
        mc.alloc();

        // And fill it in
        for (т_мера i = 0; i < e.члены.dim; i++)
        {
            if (EnumMember sf = (*e.члены)[i].isEnumMember())
            {
                ббайт* p = mc.writePtr();
                dinteger_t значение = sf.значение().toInteger();
                TOWORD(p, (config.fulltypes == CV8) ? LF_ENUMERATE_V3 : LF_ENUMERATE);
                бцел attribute = 0;
                TOWORD(p + 2, attribute);
                cv4_storenumeric(p + 4,cast(бцел)значение);
                бцел j = 4 + cv4_numericbytes(cast(бцел)значение);
                // store only member's simple имя
                j += cv_namestring(p + j, sf.вТкст0());
                j = cv_align(p + j, j);
                mc.written(j);
                // If enum is not a member of a class, output enum члены as constants
    //          if (!isclassmember(s))
    //          {
    //              cv4_outsym(sf);
    //          }
            }
        }
        fieldlist = mc.debtyp();
    }

    if (config.fulltypes == CV8)
        TOLONG(d.данные.ptr + 10,fieldlist);
    else
        TOWORD(d.данные.ptr + 6,fieldlist);

//    cv4_outsym(s);
    return typidx;
}

/*************************************
 * Align and pad.
 * Возвращает:
 *      aligned count
 */
бцел cv_align(ббайт *p, бцел n)
{
    if (config.fulltypes == CV8)
    {
        if (p)
        {
            бцел npad = -n & 3;
            while (npad)
            {
                *p = cast(ббайт)(0xF0 + npad);
                ++p;
                --npad;
            }
        }
        n = (n + 3) & ~3;
    }
    return n;
}

/*************************************
 * пиши a UDT record to the объект файл
 * Параметры:
 *      ид = имя of user defined тип
 *      typidx = тип index
 */
проц cv_udt(ткст0 ид, бцел typidx)
{
    if (config.fulltypes == CV8)
        cv8_udt(ид, typidx);
    else
    {
        const len = strlen(ид);
        ббайт *debsym = cast(ббайт *) alloca(39 + IDOHD + len);

        // Output a 'user-defined тип' for the tag имя
        TOWORD(debsym + 2,S_UDT);
        TOIDX(debsym + 4,typidx);
        бцел length = 2 + 2 + cgcv.sz_idx;
        length += cv_namestring(debsym + length,ид);
        TOWORD(debsym,length - 2);

        assert(length <= 40 + len);
        objmod.write_bytes(SegData[DEBSYM],length,debsym);
    }
}

/* ==================================================================== */

/****************************
 * Emit symbolic debug info in CV format.
 */

проц toDebug(EnumDeclaration ed)
{
    //printf("EnumDeclaration::toDebug('%s')\n", ed.вТкст0());

    assert(config.fulltypes >= CV4);

    // If it is a member, it is handled by cvMember()
    if (!ed.isMember())
    {
        const ид = ed.toPrettyChars(да);
        const idx_t typidx = cv4_Denum(ed);
        cv_udt(ид, typidx);
    }
}

/****************************
 * Helper struct for field list records LF_FIELDLIST/LF_FIELDLIST_V2
 *
 * if the size exceeds the maximum length of a record, the last entry
 * is an LF_INDEX entry with the тип index pointing to the следщ field list record
 *
 * Processing is done in two phases:
 *
 * Phase 1: computing the size of the field list and distributing it over multiple records
 *  - construct CvFieldList with some precalculated field count/length
 *  - for each field, call count(length of field)
 *
 * Phase 2: пиши the actual данные
 *  - call alloc() to размести debtyp's
 *  - for each field,
 *    - call writePtr() to get a pointer into the current debtyp
 *    - fill memory with field данные
 *    - call written(length of field)
 *  - call debtyp() to создай тип records and return the index of the first one
 */
struct CvFieldList
{
    // one LF_FIELDLIST record
    struct FLChunk
    {
        бцел length;    // accumulated during "count" phase

        debtyp_t *dt;
        бцел writepos;  // пиши position in dt
    }

    бцел nfields;
    бцел writeIndex;
    МассивДРК!(FLChunk) fieldLists;

    const бцел fieldLenMax;
    const бцел fieldIndexLen;

    const бул canSplitList;

    this(бцел fields, бцел len)
    {
        canSplitList = config.fulltypes == CV8; // optlink bails out with LF_INDEX
        fieldIndexLen = canSplitList ? (config.fulltypes == CV8 ? 2 + 2 + 4 : 2 + 2) : 0;
        fieldLenMax = (config.fulltypes == CV8 ? CV8_NAMELENMAX : CV4_NAMELENMAX) - fieldIndexLen;

        assert(len < fieldLenMax);
        nfields = fields;
        fieldLists.сунь(FLChunk(2 + len));
    }

    проц count(бцел n)
    {
        if (n)
        {
            nfields++;
            assert(n < fieldLenMax);
            if (fieldLists[$-1].length + n > fieldLenMax)
                fieldLists.сунь(FLChunk(2 + n));
            else
                fieldLists[$-1].length += n;
        }
    }

    проц alloc()
    {
        foreach (i, ref fld; fieldLists)
        {
            fld.dt = debtyp_alloc(fld.length + (i < fieldLists.length - 1 ? fieldIndexLen : 0));
            TOWORD(fld.dt.данные.ptr, config.fulltypes == CV8 ? LF_FIELDLIST_V2 : LF_FIELDLIST);
            fld.writepos = 2;
        }
    }

    ббайт* writePtr()
    {
        assert(writeIndex < fieldLists.length);
        auto fld = &fieldLists[writeIndex];
        if (fld.writepos >= fld.length)
        {
            assert(fld.writepos == fld.length);
            if (writeIndex < fieldLists.length - 1) // if нет, all further attempts must not actually пиши any данные
            {
                writeIndex++;
                fld++;
            }
        }
        return fld.dt.данные.ptr + fld.writepos;
    }

    проц written(бцел n)
    {
        assert(fieldLists[writeIndex].writepos + n <= fieldLists[writeIndex].length);
        fieldLists[writeIndex].writepos += n;
    }

    idx_t debtyp()
    {
        idx_t typidx;
        auto numCreate = canSplitList ? fieldLists.length : 1;
        for(auto i = numCreate; i > 0; --i)
        {
            auto fld = &fieldLists[i - 1];
            if (typidx)
            {
                ббайт* p = fld.dt.данные.ptr + fld.writepos;
                if (config.fulltypes == CV8)
                {
                    TOWORD (p, LF_INDEX_V2);
                    TOWORD (p + 2, 0); // padding
                    TOLONG (p + 4, typidx);
                }
                else
                {
                    TOWORD (p, LF_INDEX);
                    TOWORD (p + 2, typidx);
                }
            }
            typidx = cv_debtyp(fld.dt);
        }
        return typidx;
    }
}

// Lambda function
цел cv_mem_count(ДСимвол s, проц *param)
{
    CvFieldList *pmc = cast(CvFieldList *)param;

    цел nwritten = cvMember(s, null);
    pmc.count(nwritten);
    return 0;
}

// Lambda function
цел cv_mem_p(ДСимвол s, проц *param)
{
    CvFieldList *pmc = cast(CvFieldList *)param;
    ббайт *p = pmc.writePtr();
    бцел len = cvMember(s, p);
    pmc.written(len);
    return 0;
}


проц toDebug(StructDeclaration sd)
{
    idx_t typidx1 = 0;

    //printf("StructDeclaration::toDebug('%s')\n", sd.вТкст0());

    assert(config.fulltypes >= CV4);
    if (sd.isAnonymous())
        return /*0*/;

    if (typidx1)                 // if reference already generated
        return /*typidx1*/;      // use already existing reference

    targ_т_мера size;
    бцел property = 0;
    if (!sd.члены)
    {
        size = 0;
        property |= 0x80;               // forward reference
    }
    else
        size = sd.structsize;

    if (sd.родитель.isAggregateDeclaration()) // if class is nested
        property |= 8;
//    if (st.Sctor || st.Sdtor)
//      property |= 2;          // class has ctors and/or dtors
//    if (st.Sopoverload)
//      property |= 4;          // class has overloaded operators
//    if (st.Scastoverload)
//      property |= 0x40;               // class has casting methods
//    if (st.Sopeq && !(st.Sopeq.Sfunc.Fflags & Fnodebug))
//      property |= 0x20;               // class has overloaded assignment

    const сим *ид = sd.toPrettyChars(да);

    бцел leaf = sd.isUnionDeclaration() ? LF_UNION : LF_STRUCTURE;
    if (config.fulltypes == CV8)
        leaf = leaf == LF_UNION ? LF_UNION_V3 : LF_STRUCTURE_V3;

    бцел numidx;
    switch (leaf)
    {
        case LF_UNION:        numidx = 8;       break;
        case LF_UNION_V3:     numidx = 10;      break;
        case LF_STRUCTURE:    numidx = 12;      break;
        case LF_STRUCTURE_V3: numidx = 18;      break;
    }

    const len1 = numidx + cv4_numericbytes(cast(бцел)size);
    debtyp_t *d = debtyp_alloc(len1 + cv_stringbytes(ид));
    cv4_storenumeric(d.данные.ptr + numidx, cast(бцел)size);
    cv_namestring(d.данные.ptr + len1, ид);

    if (leaf == LF_STRUCTURE)
    {
        TOWORD(d.данные.ptr + 8,0);          // dList
        TOWORD(d.данные.ptr + 10,0);         // vshape is 0 (no virtual functions)
    }
    else if (leaf == LF_STRUCTURE_V3)
    {
        TOLONG(d.данные.ptr + 10,0);         // dList
        TOLONG(d.данные.ptr + 14,0);         // vshape is 0 (no virtual functions)
    }
    TOWORD(d.данные.ptr,leaf);

    // Assign a number to prevent infinite recursion if a struct member
    // references the same struct.
    const length_save = d.length;
    d.length = 0;                      // so cv_debtyp() will размести new
    const idx_t typidx = cv_debtyp(d);
    d.length = length_save;            // restore length

    if (!sd.члены)                       // if reference only
    {
        if (config.fulltypes == CV8)
        {
            TOWORD(d.данные.ptr + 2,0);          // count: number of fields is 0
            TOLONG(d.данные.ptr + 6,0);          // field list is 0
            TOWORD(d.данные.ptr + 4,property);
        }
        else
        {
            TOWORD(d.данные.ptr + 2,0);          // count: number of fields is 0
            TOWORD(d.данные.ptr + 4,0);          // field list is 0
            TOWORD(d.данные.ptr + 6,property);
        }
        return /*typidx*/;
    }

    // Compute the number of fields and the length of the fieldlist record
    CvFieldList mc = CvFieldList(0, 0);
    for (т_мера i = 0; i < sd.члены.dim; i++)
    {
        ДСимвол s = (*sd.члены)[i];
        s.apply(&cv_mem_count, &mc);
    }
    const бцел nfields = mc.nfields;

    // Generate fieldlist тип record
    mc.alloc();
    if (nfields)
    {
        for (т_мера i = 0; i < sd.члены.dim; i++)
        {
            ДСимвол s = (*sd.члены)[i];
            s.apply(&cv_mem_p, &mc);
        }
    }

    //dbg_printf("fnamelen = %d, p-dt.данные.ptr = %d\n",fnamelen,p-dt.данные.ptr);
    const idx_t fieldlist = mc.debtyp();

    TOWORD(d.данные.ptr + 2, nfields);
    if (config.fulltypes == CV8)
    {
        TOWORD(d.данные.ptr + 4,property);
        TOLONG(d.данные.ptr + 6,fieldlist);
    }
    else
    {
        TOWORD(d.данные.ptr + 4,fieldlist);
        TOWORD(d.данные.ptr + 6,property);
    }

//    cv4_outsym(s);

    cv_udt(ид, typidx);

//    return typidx;
}


проц toDebug(ClassDeclaration cd)
{
    idx_t typidx1 = 0;

    //printf("ClassDeclaration::toDebug('%s')\n", cd.вТкст0());

    assert(config.fulltypes >= CV4);
    if (cd.isAnonymous())
        return /*0*/;

    if (typidx1)                 // if reference already generated
        return /*typidx1*/;      // use already existing reference

    targ_т_мера size;
    бцел property = 0;
    if (!cd.члены)
    {
        size = 0;
        property |= 0x80;               // forward reference
    }
    else
        size = cd.structsize;

    if (cd.родитель.isAggregateDeclaration()) // if class is nested
        property |= 8;
    if (cd.ctor || cd.dtors.dim)
        property |= 2;          // class has ctors and/or dtors
//    if (st.Sopoverload)
//      property |= 4;          // class has overloaded operators
//    if (st.Scastoverload)
//      property |= 0x40;               // class has casting methods
//    if (st.Sopeq && !(st.Sopeq.Sfunc.Fflags & Fnodebug))
//      property |= 0x20;               // class has overloaded assignment

    const ид = cd.isCPPinterface() ? cd.идент.вТкст0() : cd.toPrettyChars(да);
    const бцел leaf = config.fulltypes == CV8 ? LF_CLASS_V3 : LF_CLASS;

    const бцел numidx = (leaf == LF_CLASS_V3) ? 18 : 12;
    const бцел len1 = numidx + cv4_numericbytes(cast(бцел)size);
    debtyp_t *d = debtyp_alloc(len1 + cv_stringbytes(ид));
    cv4_storenumeric(d.данные.ptr + numidx, cast(бцел)size);
    cv_namestring(d.данные.ptr + len1, ид);

    idx_t vshapeidx = 0;
    if (1)
    {
        const т_мера dim = cd.vtbl.dim;              // number of virtual functions
        if (dim)
        {   // 4 bits per descriptor
            debtyp_t *vshape = debtyp_alloc(cast(бцел)(4 + (dim + 1) / 2));
            TOWORD(vshape.данные.ptr,LF_VTSHAPE);
            TOWORD(vshape.данные.ptr + 2, cast(бцел)dim);

            т_мера n = 0;
            ббайт descriptor = 0;
            for (т_мера i = 0; i < cd.vtbl.dim; i++)
            {
                //if (intsize == 4)
                    descriptor |= 5;
                vshape.данные.ptr[4 + n / 2] = descriptor;
                descriptor <<= 4;
                n++;
            }
            vshapeidx = cv_debtyp(vshape);
        }
    }
    if (leaf == LF_CLASS)
    {
        TOWORD(d.данные.ptr + 8,0);          // dList
        TOWORD(d.данные.ptr + 10,vshapeidx);
    }
    else if (leaf == LF_CLASS_V3)
    {
        TOLONG(d.данные.ptr + 10,0);         // dList
        TOLONG(d.данные.ptr + 14,vshapeidx);
    }
    TOWORD(d.данные.ptr,leaf);

    // Assign a number to prevent infinite recursion if a struct member
    // references the same struct.
    const length_save = d.length;
    d.length = 0;                      // so cv_debtyp() will размести new
    const idx_t typidx = cv_debtyp(d);
    d.length = length_save;            // restore length

    if (!cd.члены)                       // if reference only
    {
        if (leaf == LF_CLASS_V3)
        {
            TOWORD(d.данные.ptr + 2,0);          // count: number of fields is 0
            TOLONG(d.данные.ptr + 6,0);          // field list is 0
            TOWORD(d.данные.ptr + 4,property);
        }
        else
        {
            TOWORD(d.данные.ptr + 2,0);          // count: number of fields is 0
            TOWORD(d.данные.ptr + 4,0);          // field list is 0
            TOWORD(d.данные.ptr + 6,property);
        }
        return /*typidx*/;
    }

    // Compute the number of fields and the length of the fieldlist record
    CvFieldList mc = CvFieldList(0, 0);

    /* Adding in the base classes causes VS 2010 debugger to refuse to display any
     * of the fields. I have not been able to determine why.
     * (Could it be because the base class is "forward referenced"?)
     * It does work with VS 2012.
     */
    бул addInBaseClasses = да;
    if (addInBaseClasses)
    {
        // Add in base classes
        for (т_мера i = 0; i < cd.baseclasses.dim; i++)
        {
            const bc = (*cd.baseclasses)[i];
            const бцел elementlen = 4 + cgcv.sz_idx + cv4_numericbytes(bc.смещение);
            mc.count(cv_align(null, elementlen));
        }
    }

    for (т_мера i = 0; i < cd.члены.dim; i++)
    {
        ДСимвол s = (*cd.члены)[i];
        s.apply(&cv_mem_count, &mc);
    }
    const бцел nfields = mc.nfields;

    TOWORD(d.данные.ptr + 2, nfields);

    // Generate fieldlist тип record
    mc.alloc();

    if (nfields)        // if we didn't overflow
    {
        if (addInBaseClasses)
        {
            ббайт* base = mc.writePtr();
            ббайт* p = base;

            // Add in base classes
            for (т_мера i = 0; i < cd.baseclasses.dim; i++)
            {
                КлассОснова2 *bc = (*cd.baseclasses)[i];
                const idx_t typidx2 = cv4_typidx(Type_toCtype(bc.sym.тип).Tnext);
                const бцел attribute = PROTtoATTR(Prot.Kind.public_);

                бцел elementlen;
                switch (config.fulltypes)
                {
                    case CV8:
                        TOWORD(p, LF_BCLASS_V2);
                        TOWORD(p + 2,attribute);
                        TOLONG(p + 4,typidx2);
                        elementlen = 8;
                        break;

                    case CV4:
                        TOWORD(p, LF_BCLASS);
                        TOWORD(p + 2,typidx2);
                        TOWORD(p + 4,attribute);
                        elementlen = 6;
                        break;
                }

                cv4_storenumeric(p + elementlen, bc.смещение);
                elementlen += cv4_numericbytes(bc.смещение);
                p += cv_align(p + elementlen, elementlen);
            }
            mc.written(cast(бцел)(p - base));
        }

        for (т_мера i = 0; i < cd.члены.dim; i++)
        {
            ДСимвол s = (*cd.члены)[i];
            s.apply(&cv_mem_p, &mc);
        }
    }

    const idx_t fieldlist = mc.debtyp();

    if (config.fulltypes == CV8)
    {
        TOWORD(d.данные.ptr + 4,property);
        TOLONG(d.данные.ptr + 6,fieldlist);
    }
    else
    {
        TOWORD(d.данные.ptr + 4,fieldlist);
        TOWORD(d.данные.ptr + 6,property);
    }

//    cv4_outsym(s);

    cv_udt(ид, typidx);

//    return typidx;
}

private бцел writeField(ббайт* p, ткст0 ид, бцел attr, бцел typidx, бцел смещение)
{
    if (config.fulltypes == CV8)
    {
        TOWORD(p,LF_MEMBER_V3);
        TOWORD(p + 2,attr);
        TOLONG(p + 4,typidx);
        cv4_storesignednumeric(p + 8, смещение);
        бцел len = 8 + cv4_signednumericbytes(смещение);
        len += cv_namestring(p + len, ид);
        return cv_align(p + len, len);
    }
    else
    {
        TOWORD(p,LF_MEMBER);
        TOWORD(p + 2,typidx);
        TOWORD(p + 4,attr);
        cv4_storesignednumeric(p + 6, смещение);
        бцел len = 6 + cv4_signednumericbytes(смещение);
        return len + cv_namestring(p + len, ид);
    }
}

проц toDebugClosure(Symbol* closstru)
{
    //printf("toDebugClosure('%s')\n", fd.вТкст0());

    assert(config.fulltypes >= CV4);

    бцел leaf = config.fulltypes == CV8 ? LF_STRUCTURE_V3 : LF_STRUCTURE;
    бцел numidx = leaf == LF_STRUCTURE ? 12 : 18;
    бцел structsize = cast(бцел)(closstru.Sstruct.Sstructsize);
    const ткст0 closname = closstru.Sident.ptr;

    const len1 = numidx + cv4_numericbytes(structsize);
    debtyp_t *d = debtyp_alloc(len1 + cv_stringbytes(closname));
    cv4_storenumeric(d.данные.ptr + numidx, structsize);
    const бцел len = len1 + cv_namestring(d.данные.ptr + len1, closname);

    if (leaf == LF_STRUCTURE)
    {
        TOWORD(d.данные.ptr + 8,0);          // dList
        TOWORD(d.данные.ptr + 10,0);         // vshape is 0 (no virtual functions)
    }
    else // LF_STRUCTURE_V3
    {
        TOLONG(d.данные.ptr + 10,0);         // dList
        TOLONG(d.данные.ptr + 14,0);         // vshape is 0 (no virtual functions)
    }
    TOWORD(d.данные.ptr,leaf);

    // Assign a number to prevent infinite recursion if a struct member
    // references the same struct.
    const length_save = d.length;
    d.length = 0;                      // so cv_debtyp() will размести new
    const idx_t typidx = cv_debtyp(d);
    d.length = length_save;            // restore length

    // Compute the number of fields (nfields), and the length of the fieldlist record (flistlen)
    бцел nfields = 0;
    бцел flistlen = 2;
    for (auto sl = closstru.Sstruct.Sfldlst; sl; sl = list_next(sl))
    {
        Symbol *sf = list_symbol(sl);
        бцел thislen = (config.fulltypes == CV8 ? 8 : 6);
        thislen += cv4_signednumericbytes(cast(бцел)sf.Smemoff);
        thislen += cv_stringbytes(sf.Sident.ptr);
        thislen = cv_align(null, thislen);

        if (config.fulltypes != CV8 && flistlen + thislen > CV4_NAMELENMAX)
            break; // Too long, fail gracefully

        flistlen += thislen;
        nfields++;
    }

    // Generate fieldlist тип record
    debtyp_t *dt = debtyp_alloc(flistlen);
    ббайт *p = dt.данные.ptr;

    // And fill it in
    TOWORD(p, config.fulltypes == CV8 ? LF_FIELDLIST_V2 : LF_FIELDLIST);
    бцел flistoff = 2;
    for (auto sl = closstru.Sstruct.Sfldlst; sl && flistoff < flistlen; sl = list_next(sl))
    {
        Symbol *sf = list_symbol(sl);
        idx_t vtypidx = cv_typidx(sf.Stype);
        flistoff += writeField(p + flistoff, sf.Sident.ptr, 3 /*public*/, vtypidx, cast(бцел)sf.Smemoff);
    }

    //dbg_printf("fnamelen = %d, p-dt.данные.ptr = %d\n",fnamelen,p-dt.данные.ptr);
    assert(flistoff == flistlen);
    const idx_t fieldlist = cv_debtyp(dt);

    бцел property = 0;
    TOWORD(d.данные.ptr + 2, nfields);
    if (config.fulltypes == CV8)
    {
        TOWORD(d.данные.ptr + 4,property);
        TOLONG(d.данные.ptr + 6,fieldlist);
    }
    else
    {
        TOWORD(d.данные.ptr + 4,fieldlist);
        TOWORD(d.данные.ptr + 6,property);
    }

    cv_udt(closname, typidx);
}

/* ===================================================================== */

/*****************************************
 * Insert CV info into *p.
 * Возвращает:
 *      number of bytes written, or that would be written if p==null
 */

цел cvMember(ДСимвол s, ббайт *p)
{
     class CVMember : Визитор2
    {
        ббайт *p;
        цел результат;

        this(ббайт *p)
        {
            this.p = p;
            результат = 0;
        }

        alias Визитор2.посети посети;

        override проц посети(ДСимвол s)
        {
        }

        проц cvMemberCommon(ДСимвол s, ткст0 ид, idx_t typidx)
        {
            if (!p)
                результат = cv_stringbytes(ид);

            switch (config.fulltypes)
            {
                case CV8:
                    if (!p)
                    {
                        результат += 8;
                        результат = cv_align(null, результат);
                    }
                    else
                    {
                        TOWORD(p,LF_NESTTYPE_V3);
                        TOWORD(p + 2,0);
                        TOLONG(p + 4,typidx);
                        результат = 8 + cv_namestring(p + 8, ид);
                        результат = cv_align(p + результат, результат);
                    }
                    break;

                case CV4:
                    if (!p)
                    {
                        результат += 4;
                    }
                    else
                    {
                        TOWORD(p,LF_NESTTYPE);
                        TOWORD(p + 2,typidx);
                        результат = 4 + cv_namestring(p + 4, ид);
                    }
                    break;

                default:
                    assert(0);
            }
            debug
            {
                if (p)
                {
                    цел save = результат;
                    p = null;
                    cvMemberCommon(s, ид, typidx);
                    assert(результат == save);
                }
            }
        }

        override проц посети(EnumDeclaration ed)
        {
            //printf("EnumDeclaration.cvMember() '%s'\n", d.вТкст0());

            cvMemberCommon(ed, ed.вТкст0(), cv4_Denum(ed));
        }

        override проц посети(FuncDeclaration fd)
        {
            //printf("FuncDeclaration.cvMember() '%s'\n", fd.вТкст0());

            if (!fd.тип)               // if not compiled in,
                return;                 // skip it
            if (!fd.тип.nextOf())      // if not fully analyzed (e.g. auto return тип)
                return;                 // skip it

            const ид = fd.вТкст0();

            if (!p)
            {
                результат = 2 + 2 + cgcv.sz_idx + cv_stringbytes(ид);
                результат = cv_align(null, результат);
                return;
            }
            else
            {
                цел count = 0;
                цел mlen = 2;
                {
                    if (fd.introducing)
                        mlen += 4;
                    mlen += cgcv.sz_idx * 2;
                    count++;
                }

                // Allocate and fill it in
                debtyp_t *d = debtyp_alloc(mlen);
                ббайт *q = d.данные.ptr;
                TOWORD(q,config.fulltypes == CV8 ? LF_METHODLIST_V2 : LF_METHODLIST);
                q += 2;
        //      for (s = sf; s; s = s.Sfunc.Foversym)
                {
                    бцел attribute = PROTtoATTR(fd.prot().вид);

                    /* 0*4 vanilla method
                     * 1*4 virtual method
                     * 2*4 static method
                     * 3*4 friend method
                     * 4*4 introducing virtual method
                     * 5*4  virtual method
                     * 6*4  introducing virtual method
                     * 7*4 reserved
                     */

                    if (fd.isStatic())
                        attribute |= 2*4;
                    else if (fd.isVirtual())
                    {
                        if (fd.introducing)
                        {
                            if (fd.isAbstract())
                                attribute |= 6*4;
                            else
                                attribute |= 4*4;
                        }
                        else
                        {
                            if (fd.isAbstract())
                                attribute |= 5*4;
                            else
                                attribute |= 1*4;
                        }
                    }
                    else
                        attribute |= 0*4;

                    TOIDX(q,attribute);
                    q += cgcv.sz_idx;
                    TOIDX(q, cv4_memfunctypidx(fd));
                    q += cgcv.sz_idx;
                    if (fd.introducing)
                    {
                        TOLONG(q, fd.vtblIndex * target.ptrsize);
                        q += 4;
                    }
                }
                assert(q - d.данные.ptr == mlen);

                idx_t typidx = cv_debtyp(d);
                if (typidx)
                {
                    switch (config.fulltypes)
                    {
                        case CV8:
                            TOWORD(p,LF_METHOD_V3);
                            goto Lmethod;
                        case CV4:
                            TOWORD(p,LF_METHOD);
                        Lmethod:
                            TOWORD(p + 2,count);
                            результат = 4;
                            TOIDX(p + результат, typidx);
                            результат += cgcv.sz_idx;
                            результат += cv_namestring(p + результат, ид);
                            break;

                        default:
                            assert(0);
                    }
                }
                результат = cv_align(p + результат, результат);
                debug
                {
                    цел save = результат;
                    результат = 0;
                    p = null;
                    посети(fd);
                    assert(результат == save);
                }
            }
        }

        override проц посети(VarDeclaration vd)
        {
            //printf("VarDeclaration.cvMember(p = %p) '%s'\n", p, vd.вТкст0());

            if (vd.тип.toBasetype().ty == Ttuple)
                return;

            const ид = vd.вТкст0();

            if (!p)
            {
                if (vd.isField())
                {
                    if (config.fulltypes == CV8)
                        результат += 2;
                    результат += 6 + cv_stringbytes(ид);
                    результат += cv4_numericbytes(vd.смещение);
                }
                else if (vd.isStatic())
                {
                    if (config.fulltypes == CV8)
                        результат += 2;
                    результат += 6 + cv_stringbytes(ид);
                }
                результат = cv_align(null, результат);
            }
            else
            {
                idx_t typidx = cv_typidx(Type_toCtype(vd.тип));
                бцел attribute = PROTtoATTR(vd.prot().вид);
                assert((attribute & ~3) == 0);
                switch (config.fulltypes)
                {
                    case CV8:
                        if (vd.isField())
                        {
                            TOWORD(p,LF_MEMBER_V3);
                            TOWORD(p + 2,attribute);
                            TOLONG(p + 4,typidx);
                            cv4_storenumeric(p + 8, vd.смещение);
                            результат = 8 + cv4_numericbytes(vd.смещение);
                            результат += cv_namestring(p + результат, ид);
                        }
                        else if (vd.isStatic())
                        {
                            TOWORD(p,LF_STMEMBER_V3);
                            TOWORD(p + 2,attribute);
                            TOLONG(p + 4,typidx);
                            результат = 8;
                            результат += cv_namestring(p + результат, ид);
                        }
                        break;

                    case CV4:
                        if (vd.isField())
                        {
                            TOWORD(p,LF_MEMBER);
                            TOWORD(p + 2,typidx);
                            TOWORD(p + 4,attribute);
                            cv4_storenumeric(p + 6, vd.смещение);
                            результат = 6 + cv4_numericbytes(vd.смещение);
                            результат += cv_namestring(p + результат, ид);
                        }
                        else if (vd.isStatic())
                        {
                            TOWORD(p,LF_STMEMBER);
                            TOWORD(p + 2,typidx);
                            TOWORD(p + 4,attribute);
                            результат = 6;
                            результат += cv_namestring(p + результат, ид);
                        }
                        break;

                     default:
                        assert(0);
                }

                результат = cv_align(p + результат, результат);
                debug
                {
                    цел save = результат;
                    результат = 0;
                    p = null;
                    посети(vd);
                    assert(результат == save);
                }
            }
        }
    }

    scope v = new CVMember(p);
    s.прими(v);
    return v.результат;
}

}
else
{
    import dmd.denum;
    import dmd.dstruct;
    import dmd.dclass;
    import drc.backend.cc;

    /****************************
     * Stub them out.
     */

     проц toDebug(EnumDeclaration ed)
    {
        //printf("EnumDeclaration::toDebug('%s')\n", ed.вТкст0());
    }

     проц toDebug(StructDeclaration sd)
    {
    }

     проц toDebug(ClassDeclaration cd)
    {
    }

     проц toDebugClosure(Symbol* closstru)
    {
    }
}
