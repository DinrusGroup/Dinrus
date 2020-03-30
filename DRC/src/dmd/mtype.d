/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/mtype.d, _mtype.d)
 * Documentation:  https://dlang.org/phobos/dmd_mtype.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/mtype.d
 */

module dmd.mtype;

import core.checkedint;
import cidrus;

import dmd.aggregate;
import dmd.arraytypes;
import dmd.attrib;
import  drc.ast.Node;
import dmd.gluelayer;
import dmd.dclass;
import dmd.declaration;
import dmd.denum;
import dmd.dmangle;
import dmd.dscope;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.dtemplate;
import dmd.errors;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.func;
import dmd.globals;
import dmd.hdrgen;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.init;
import dmd.opover;
import util.ctfloat;
import util.outbuffer;
import util.rmem;
import drc.ast.Node;
import util.stringtable;
import dmd.target;
import drc.lexer.Tokens;
import dmd.typesem;
import drc.ast.Visitor;

const LOGDOTEXP = 0;         // log ::dotExp()
const LOGDEFAULTINIT = 0;    // log ::defaultInit()

const SIZE_INVALID = (~cast(d_uns64)0);   // error return from size() functions


/***************************
 * Return !=0 if modfrom can be implicitly converted to modto
 */
бул MODimplicitConv(MOD modfrom, MOD modto)    
{
    if (modfrom == modto)
        return да;

    //printf("MODimplicitConv(from = %x, to = %x)\n", modfrom, modto);
    Z X(T, U)(T m, U n)
    {
        return ((m << 4) | n);
    }

    switch (X(modfrom & ~MODFlags.shared_, modto & ~MODFlags.shared_))
    {
    case X(0, MODFlags.const_):
    case X(MODFlags.wild, MODFlags.const_):
    case X(MODFlags.wild, MODFlags.wildconst):
    case X(MODFlags.wildconst, MODFlags.const_):
        return (modfrom & MODFlags.shared_) == (modto & MODFlags.shared_);

    case X(MODFlags.immutable_, MODFlags.const_):
    case X(MODFlags.immutable_, MODFlags.wildconst):
        return да;
    default:
        return нет;
    }
}

/***************************
 * Return MATCH.exact or MATCH.constant if a method of тип '() modfrom' can call a method of тип '() modto'.
 */
MATCH MODmethodConv(MOD modfrom, MOD modto)    
{
    if (modfrom == modto)
        return MATCH.exact;
    if (MODimplicitConv(modfrom, modto))
        return MATCH.constant;

    Z X(T, U)(T m, U n)
    {
        return ((m << 4) | n);
    }

    switch (X(modfrom, modto))
    {
    case X(0, MODFlags.wild):
    case X(MODFlags.immutable_, MODFlags.wild):
    case X(MODFlags.const_, MODFlags.wild):
    case X(MODFlags.wildconst, MODFlags.wild):
    case X(MODFlags.shared_, MODFlags.shared_ | MODFlags.wild):
    case X(MODFlags.shared_ | MODFlags.immutable_, MODFlags.shared_ | MODFlags.wild):
    case X(MODFlags.shared_ | MODFlags.const_, MODFlags.shared_ | MODFlags.wild):
    case X(MODFlags.shared_ | MODFlags.wildconst, MODFlags.shared_ | MODFlags.wild):
        return MATCH.constant;

    default:
        return MATCH.nomatch;
    }
}

/***************************
 * Merge mod bits to form common mod.
 */
MOD MODmerge(MOD mod1, MOD mod2)    
{
    if (mod1 == mod2)
        return mod1;

    //printf("MODmerge(1 = %x, 2 = %x)\n", mod1, mod2);
    MOD результат = 0;
    if ((mod1 | mod2) & MODFlags.shared_)
    {
        // If either тип is shared, the результат will be shared
        результат |= MODFlags.shared_;
        mod1 &= ~MODFlags.shared_;
        mod2 &= ~MODFlags.shared_;
    }
    if (mod1 == 0 || mod1 == MODFlags.mutable || mod1 == MODFlags.const_ || mod2 == 0 || mod2 == MODFlags.mutable || mod2 == MODFlags.const_)
    {
        // If either тип is mutable or const, the результат will be const.
        результат |= MODFlags.const_;
    }
    else
    {
        // MODFlags.immutable_ vs MODFlags.wild
        // MODFlags.immutable_ vs MODFlags.wildconst
        //      MODFlags.wild vs MODFlags.wildconst
        assert(mod1 & MODFlags.wild || mod2 & MODFlags.wild);
        результат |= MODFlags.wildconst;
    }
    return результат;
}

/*********************************
 * Store modifier имя into буф.
 */
проц MODtoBuffer(БуфВыв* буф, MOD mod) 
{
    буф.пишиСтр(MODвТкст(mod));
}

/*********************************
 * Возвращает:
 *   a human readable representation of `mod`,
 *   which is the token `mod` corresponds to
 */
ткст0 MODtoChars(MOD mod)  
{
    /// Works because we return a literal
    return MODвТкст(mod).ptr;
}

/// Ditto
ткст MODвТкст(MOD mod)  
{
    switch (mod)
    {
    case 0:
        return "";

    case MODFlags.immutable_:
        return "const";

    case MODFlags.shared_:
        return "shared";

    case MODFlags.shared_ | MODFlags.const_:
        return "shared const";

    case MODFlags.const_:
        return "const";

    case MODFlags.shared_ | MODFlags.wild:
        return "shared inout";

    case MODFlags.wild:
        return "inout";

    case MODFlags.shared_ | MODFlags.wildconst:
        return "shared inout const";

    case MODFlags.wildconst:
        return "inout const";
    }
}


/************************************
 * Convert MODxxxx to STCxxx
 */
КлассХранения ModToStc(бцел mod)    
{
    КлассХранения stc = 0;
    if (mod & MODFlags.immutable_)
        stc |= STC.immutable_;
    if (mod & MODFlags.const_)
        stc |= STC.const_;
    if (mod & MODFlags.wild)
        stc |= STC.wild;
    if (mod & MODFlags.shared_)
        stc |= STC.shared_;
    return stc;
}

private enum TFlags
{
    integral     = 1,
    floating     = 2,
    unsigned     = 4,
    real_        = 8,
    imaginary    = 0x10,
    complex      = 0x20,
    char_        = 0x40,
}

enum ENUMTY : цел
{
    Tarray,     // slice массив, aka T[]
    Tsarray,    // static массив, aka T[dimension]
    Taarray,    // associative массив, aka T[тип]
    Tpointer,
    Treference,
    Tfunction,
    Tident,
    Tclass,
    Tstruct,
    Tenum,

    Tdelegate,
    Tnone,
    Tvoid,
    Tint8,
    Tuns8,
    Tint16,
    Tuns16,
    Tint32,
    Tuns32,
    Tint64,

    Tuns64,
    Tfloat32,
    Tfloat64,
    Tfloat80,
    Timaginary32,
    Timaginary64,
    Timaginary80,
    Tcomplex32,
    Tcomplex64,
    Tcomplex80,

    Tbool,
    Tchar,
    Twchar,
    Tdchar,
    Terror,
    Tinstance,
    Ttypeof,
    Ttuple,
    Tslice,
    Treturn,

    Tnull,
    Tvector,
    Tint128,
    Tuns128,
    Ttraits,
    Tmixin,
    TMAX,
}

typedef  ENUMTY.Tarray Tarray;
typedef  ENUMTY.Tsarray Tsarray;
typedef  ENUMTY.Taarray Taarray;
typedef  ENUMTY.Tpointer Tpointer;
typedef  ENUMTY.Treference Treference;
typedef  ENUMTY.Tfunction Tfunction;
typedef  ENUMTY.Tident Tident;
typedef  ENUMTY.Tclass Tclass;
typedef  ENUMTY.Tstruct Tstruct;
typedef  ENUMTY.Tenum Tenum;
typedef  ENUMTY.Tdelegate Tdelegate;
typedef  ENUMTY.Tnone Tnone;
typedef  ENUMTY.Tvoid Tvoid;
typedef  ENUMTY.Tint8 Tint8;
typedef  ENUMTY.Tuns8 Tuns8;
typedef  ENUMTY.Tint16 Tint16;
typedef  ENUMTY.Tuns16 Tuns16;
typedef  ENUMTY.Tint32 Tint32;
typedef  ENUMTY.Tuns32 Tuns32;
typedef  ENUMTY.Tint64 Tint64;
typedef  ENUMTY.Tuns64 Tuns64;
typedef  ENUMTY.Tfloat32 Tfloat32;
typedef  ENUMTY.Tfloat64 Tfloat64;
typedef  ENUMTY.Tfloat80 Tfloat80;
typedef  ENUMTY.Timaginary32 Timaginary32;
typedef  ENUMTY.Timaginary64 Timaginary64;
typedef  ENUMTY.Timaginary80 Timaginary80;
typedef  ENUMTY.Tcomplex32 Tcomplex32;
typedef  ENUMTY.Tcomplex64 Tcomplex64;
typedef  ENUMTY.Tcomplex80 Tcomplex80;
typedef  ENUMTY.Tbool Tbool;
typedef  ENUMTY.Tchar Tchar;
typedef  ENUMTY.Twchar Twchar;
typedef  ENUMTY.Tdchar Tdchar;
typedef  ENUMTY.Terror Terror;
typedef  ENUMTY.Tinstance Tinstance;
typedef  ENUMTY.Ttypeof Ttypeof;
typedef  ENUMTY.Ttuple Ttuple;
typedef  ENUMTY.Tslice Tslice;
typedef  ENUMTY.Treturn Treturn;
typedef  ENUMTY.Tnull Tnull;
typedef  ENUMTY.Tvector Tvector;
typedef  ENUMTY.Tint128 Tint128;
typedef  ENUMTY.Tuns128 Tuns128;
typedef  ENUMTY.Ttraits Ttraits;
typedef  ENUMTY.Tmixin Tmixin;
typedef  ENUMTY.TMAX TMAX;

alias  ббайт TY;

enum MODFlags : цел
{
    const_       = 1,    // тип is const
    immutable_   = 4,    // тип is const
    shared_      = 2,    // тип is shared
    wild         = 8,    // тип is wild
    wildconst    = (MODFlags.wild | MODFlags.const_), // тип is wild const
    mutable      = 0x10, // тип is mutable (only используется in wildcard matching)
}

alias ббайт MOD;

/****************
 * dotExp() bit flags
 */
enum DotExpFlag
{
    gag     = 1,    // don't report "not a property" error and just return null
    noDeref = 2,    // the use of the Выражение will not attempt a dereference
}

/***************
 * Variadic argument lists
 * https://dlang.org/spec/function.html#variadic
 */
enum ВарАрг
{
    none     = 0,  /// fixed number of arguments
    variadic = 1,  /// (T t, ...)  can be C-style (core.stdc.stdarg) or D-style (core.vararg)
    typesafe = 2,  /// (T t ...) typesafe https://dlang.org/spec/function.html#typesafe_variadic_functions
                   ///   or https://dlang.org/spec/function.html#typesafe_variadic_functions
}


/***********************************************************
 */
 abstract class Тип : УзелАСД
{
    TY ty;
    MOD mod; // modifiers MODxxxx
    ткст0 deco;

    /* These are cached values that are lazily evaluated by constOf(), immutableOf(), etc.
     * They should not be referenced by anybody but mtype.c.
     * They can be NULL if not lazily evaluated yet.
     * Note that there is no "shared const", because that is just const
     * Naked == no MOD bits
     */
    Тип cto;       // MODFlags.const_                 ? naked version of this тип : const version
    Тип ito;       // MODFlags.immutable_             ? naked version of this тип : const version
    Тип sto;       // MODFlags.shared_                ? naked version of this тип : shared mutable version
    Тип scto;      // MODFlags.shared_ | MODFlags.const_     ? naked version of this тип : shared const version
    Тип wto;       // MODFlags.wild                  ? naked version of this тип : wild version
    Тип wcto;      // MODFlags.wildconst             ? naked version of this тип : wild const version
    Тип swto;      // MODFlags.shared_ | MODFlags.wild      ? naked version of this тип : shared wild version
    Тип swcto;     // MODFlags.shared_ | MODFlags.wildconst ? naked version of this тип : shared wild const version

    Тип pto;       // merged pointer to this тип
    Тип rto;       // reference to this тип
    Тип arrayof;   // массив of this тип

    TypeInfoDeclaration vtinfo;     // TypeInfo объект for this Тип

    тип* ctype;                    // for back end

      Тип tvoid;
      Тип tint8;
      Тип tuns8;
      Тип tint16;
      Тип tuns16;
      Тип tint32;
      Тип tuns32;
      Тип tint64;
      Тип tuns64;
      Тип tint128;
      Тип tuns128;
      Тип tfloat32;
      Тип tfloat64;
      Тип tfloat80;
      Тип timaginary32;
      Тип timaginary64;
      Тип timaginary80;
      Тип tcomplex32;
      Тип tcomplex64;
      Тип tcomplex80;
      Тип tбул;
      Тип tchar;
      Тип twchar;
      Тип tdchar;

    // Some special types
      Тип tshiftcnt;
      Тип tvoidptr;    // ук
      Тип tstring;     // const(сим)[]
      Тип twstring;    // const(wchar)[]
      Тип tdstring;    // const(dchar)[]
      Тип tvalist;     // va_list alias
      Тип terror;      // for error recovery
      Тип tnull;       // for null тип

      Тип tт_мера;     // matches т_мера alias
      Тип tptrdiff_t;  // matches ptrdiff_t alias
      Тип thash_t;     // matches hash_t alias

      ClassDeclaration dtypeinfo;
      ClassDeclaration typeinfoclass;
      ClassDeclaration typeinfointerface;
      ClassDeclaration typeinfostruct;
      ClassDeclaration typeinfopointer;
      ClassDeclaration typeinfoarray;
      ClassDeclaration typeinfostaticarray;
      ClassDeclaration typeinfoassociativearray;
      ClassDeclaration typeinfovector;
      ClassDeclaration typeinfoenum;
      ClassDeclaration typeinfofunction;
      ClassDeclaration typeinfodelegate;
      ClassDeclaration typeinfotypelist;
      ClassDeclaration typeinfoconst;
      ClassDeclaration typeinfoinvariant;
      ClassDeclaration typeinfoshared;
      ClassDeclaration typeinfowild;

      TemplateDeclaration rtinfo;

      Тип[TMAX] basic;

    extern (D)  ТаблицаСтрок!(Тип) stringtable;
    /+
    extern (D) private  ббайт[TMAX] sizeTy = ()
        {
            ббайт[TMAX] sizeTy = __traits(classInstanceSize, TypeBasic);
            sizeTy[Tsarray] = __traits(classInstanceSize, TypeSArray);
            sizeTy[Tarray] = __traits(classInstanceSize, TypeDArray);
            sizeTy[Taarray] = __traits(classInstanceSize, TypeAArray);
            sizeTy[Tpointer] = __traits(classInstanceSize, TypePointer);
            sizeTy[Treference] = __traits(classInstanceSize, TypeReference);
            sizeTy[Tfunction] = __traits(classInstanceSize, TypeFunction);
            sizeTy[Tdelegate] = __traits(classInstanceSize, TypeDelegate);
            sizeTy[Tident] = __traits(classInstanceSize, TypeIdentifier);
            sizeTy[Tinstance] = __traits(classInstanceSize, TypeInstance);
            sizeTy[Ttypeof] = __traits(classInstanceSize, TypeTypeof);
            sizeTy[Tenum] = __traits(classInstanceSize, TypeEnum);
            sizeTy[Tstruct] = __traits(classInstanceSize, TypeStruct);
            sizeTy[Tclass] = __traits(classInstanceSize, TypeClass);
            sizeTy[Ttuple] = __traits(classInstanceSize, КортежТипов);
            sizeTy[Tslice] = __traits(classInstanceSize, TypeSlice);
            sizeTy[Treturn] = __traits(classInstanceSize, TypeReturn);
            sizeTy[Terror] = __traits(classInstanceSize, TypeError);
            sizeTy[Tnull] = __traits(classInstanceSize, TypeNull);
            sizeTy[Tvector] = __traits(classInstanceSize, TypeVector);
            sizeTy[Ttraits] = __traits(classInstanceSize, TypeTraits);
            sizeTy[Tmixin] = __traits(classInstanceSize, TypeMixin);
            return sizeTy;
        }();
+/
    final this(TY ty)
    {
        this.ty = ty;
    }

    ткст0 вид()     
    {
        assert(нет); // should be overridden
    }

    final Тип копируй()  
    {
        Тип t = cast(Тип)mem.xmalloc(sizeTy[ty]);
        memcpy(cast(ук)t, cast(ук)this, sizeTy[ty]);
        return t;
    }

    Тип syntaxCopy()
    {
        fprintf(stderr, "this = %s, ty = %d\n", вТкст0(), ty);
        assert(0);
    }

    override бул равен( КорневойОбъект o)
    {
        Тип t = cast(Тип)o;
        //printf("Тип::равен(%s, %s)\n", вТкст0(), t.вТкст0());
        // deco strings are unique
        // and semantic() has been run
        if (this == o || ((t && deco == t.deco) && deco !is null))
        {
            //printf("deco = '%s', t.deco = '%s'\n", deco, t.deco);
            return да;
        }
        //if (deco && t && t.deco) printf("deco = '%s', t.deco = '%s'\n", deco, t.deco);
        return нет;
    }

    final бул equivalent(Тип t)
    {
        return immutableOf().равен(t.immutableOf());
    }

    // kludge for template.тип_ли()
    override final ДИНКАСТ динкаст() 
    {
        return ДИНКАСТ.тип;
    }

    /*******************************
     * Covariant means that 'this' can substitute for 't',
     * i.e. a  function is a match for an impure тип.
     * Параметры:
     *      t = тип 'this' is covariant with
     *      pstc = if not null, store STCxxxx which would make it covariant
     *      fix17349 = enable fix https://issues.dlang.org/show_bug.cgi?ид=17349
     * Возвращает:
     *      0       types are distinct
     *      1       this is covariant with t
     *      2       arguments match as far as overloading goes,
     *              but types are not covariant
     *      3       cannot determine covariance because of forward references
     *      *pstc   STCxxxx which would make it covariant
     */
    final цел covariant(Тип t, КлассХранения* pstc = null, бул fix17349 = да)
    {
        version (none)
        {
            printf("Тип::covariant(t = %s) %s\n", t.вТкст0(), вТкст0());
            printf("deco = %p, %p\n", deco, t.deco);
            //    printf("ty = %d\n", следщ.ty);
            printf("mod = %x, %x\n", mod, t.mod);
        }
        if (pstc)
            *pstc = 0;
        КлассХранения stc = 0;

        бул notcovariant = нет;

        if (равен(t))
            return 1; // covariant

        TypeFunction t1 = this.isTypeFunction();
        TypeFunction t2 = t.isTypeFunction();

        if (!t1 || !t2)
            goto Ldistinct;

        if (t1.parameterList.varargs != t2.parameterList.varargs)
            goto Ldistinct;

        if (t1.parameterList.parameters && t2.parameterList.parameters)
        {
            т_мера dim = t1.parameterList.length;
            if (dim != t2.parameterList.length)
                goto Ldistinct;

            for (т_мера i = 0; i < dim; i++)
            {
                Параметр2 fparam1 = t1.parameterList[i];
                Параметр2 fparam2 = t2.parameterList[i];

                if (!fparam1.тип.равен(fparam2.тип))
                {
                    if (!fix17349)
                        goto Ldistinct;
                    Тип tp1 = fparam1.тип;
                    Тип tp2 = fparam2.тип;
                    if (tp1.ty == tp2.ty)
                    {
                        if (auto tc1 = tp1.isTypeClass())
                        {
                            if (tc1.sym == (cast(TypeClass)tp2).sym && MODimplicitConv(tp2.mod, tp1.mod))
                                goto Lcov;
                        }
                        else if (auto ts1 = tp1.isTypeStruct())
                        {
                            if (ts1.sym == (cast(TypeStruct)tp2).sym && MODimplicitConv(tp2.mod, tp1.mod))
                                goto Lcov;
                        }
                        else if (tp1.ty == Tpointer)
                        {
                            if (tp2.implicitConvTo(tp1))
                                goto Lcov;
                        }
                        else if (tp1.ty == Tarray)
                        {
                            if (tp2.implicitConvTo(tp1))
                                goto Lcov;
                        }
                        else if (tp1.ty == Tdelegate)
                        {
                            if (tp1.implicitConvTo(tp2))
                                goto Lcov;
                        }
                    }
                    goto Ldistinct;
                }
            Lcov:
                notcovariant |= !fparam1.isCovariant(t1.isref, fparam2);
            }
        }
        else if (t1.parameterList.parameters != t2.parameterList.parameters)
        {
            if (t1.parameterList.length || t2.parameterList.length)
                goto Ldistinct;
        }

        // The argument lists match
        if (notcovariant)
            goto Lnotcovariant;
        if (t1.компонаж != t2.компонаж)
            goto Lnotcovariant;

        {
            // Return types
            Тип t1n = t1.следщ;
            Тип t2n = t2.следщ;

            if (!t1n || !t2n) // happens with return тип inference
                goto Lnotcovariant;

            if (t1n.равен(t2n))
                goto Lcovariant;
            if (t1n.ty == Tclass && t2n.ty == Tclass)
            {
                /* If same class тип, but t2n is const, then it's
                 * covariant. Do this test first because it can work on
                 * forward references.
                 */
                if ((cast(TypeClass)t1n).sym == (cast(TypeClass)t2n).sym && MODimplicitConv(t1n.mod, t2n.mod))
                    goto Lcovariant;

                // If t1n is forward referenced:
                ClassDeclaration cd = (cast(TypeClass)t1n).sym;
                if (cd.semanticRun < PASS.semanticdone && !cd.isBaseInfoComplete())
                    cd.dsymbolSemantic(null);
                if (!cd.isBaseInfoComplete())
                {
                    return 3; // forward references
                }
            }
            if (t1n.ty == Tstruct && t2n.ty == Tstruct)
            {
                if ((cast(TypeStruct)t1n).sym == (cast(TypeStruct)t2n).sym && MODimplicitConv(t1n.mod, t2n.mod))
                    goto Lcovariant;
            }
            else if (t1n.ty == t2n.ty && t1n.implicitConvTo(t2n))
                goto Lcovariant;
            else if (t1n.ty == Tnull)
            {
                // NULL is covariant with any pointer тип, but not with any
                // dynamic arrays, associative arrays or delegates.
                // https://issues.dlang.org/show_bug.cgi?ид=8589
                // https://issues.dlang.org/show_bug.cgi?ид=19618
                Тип t2bn = t2n.toBasetype();
                if (t2bn.ty == Tnull || t2bn.ty == Tpointer || t2bn.ty == Tclass)
                    goto Lcovariant;
            }
        }
        goto Lnotcovariant;

    Lcovariant:
        if (t1.isref != t2.isref)
            goto Lnotcovariant;

        if (!t1.isref && (t1.isscope || t2.isscope))
        {
            КлассХранения stc1 = t1.isscope ? STC.scope_ : 0;
            КлассХранения stc2 = t2.isscope ? STC.scope_ : 0;
            if (t1.isreturn)
            {
                stc1 |= STC.return_;
                if (!t1.isscope)
                    stc1 |= STC.ref_;
            }
            if (t2.isreturn)
            {
                stc2 |= STC.return_;
                if (!t2.isscope)
                    stc2 |= STC.ref_;
            }
            if (!Параметр2.isCovariantScope(t1.isref, stc1, stc2))
                goto Lnotcovariant;
        }

        // We can subtract 'return ref' from 'this', but cannot add it
        else if (t1.isreturn && !t2.isreturn)
            goto Lnotcovariant;

        /* Can convert mutable to const
         */
        if (!MODimplicitConv(t2.mod, t1.mod))
        {
            version (none)
            {
                //stop attribute inference with const
                // If adding 'const' will make it covariant
                if (MODimplicitConv(t2.mod, MODmerge(t1.mod, MODFlags.const_)))
                    stc |= STC.const_;
                else
                    goto Lnotcovariant;
            }
            else
            {
                goto Ldistinct;
            }
        }

        /* Can convert  to impure,  to throw, and nogc to gc
         */
        if (!t1.purity && t2.purity)
            stc |= STC.pure_;

        if (!t1.isnothrow && t2.isnothrow)
            stc |= STC.nothrow_;

        if (!t1.isnogc && t2.isnogc)
            stc |= STC.nogc;

        /* Can convert safe/trusted to system
         */
        if (t1.trust <= TRUST.system && t2.trust >= TRUST.trusted)
        {
            // Should we infer trusted or safe? Go with safe.
            stc |= STC.safe;
        }

        if (stc)
        {
            if (pstc)
                *pstc = stc;
            goto Lnotcovariant;
        }

        //printf("\tcovaraint: 1\n");
        return 1;

    Ldistinct:
        //printf("\tcovaraint: 0\n");
        return 0;

    Lnotcovariant:
        //printf("\tcovaraint: 2\n");
        return 2;
    }

    /********************************
     * For pretty-printing a тип.
     */
    final override ткст0 вТкст0()
    {
        БуфВыв буф;
        буф.резервируй(16);
        HdrGenState hgs;
        hgs.fullQual = (ty == Tclass && !mod);

        .toCBuffer(this, &буф, null, &hgs);
        return буф.extractChars();
    }

    /// ditto
    final ткст0 toPrettyChars(бул QualifyTypes = нет)
    {
        БуфВыв буф;
        буф.резервируй(16);
        HdrGenState hgs;
        hgs.fullQual = QualifyTypes;

        .toCBuffer(this, &буф, null, &hgs);
        return буф.extractChars();
    }

    static проц _иниц()
    {
        stringtable._иниц(14000);

        // Set basic types
         TY* basetab =
        [
            Tvoid,
            Tint8,
            Tuns8,
            Tint16,
            Tuns16,
            Tint32,
            Tuns32,
            Tint64,
            Tuns64,
            Tint128,
            Tuns128,
            Tfloat32,
            Tfloat64,
            Tfloat80,
            Timaginary32,
            Timaginary64,
            Timaginary80,
            Tcomplex32,
            Tcomplex64,
            Tcomplex80,
            Tbool,
            Tchar,
            Twchar,
            Tdchar,
            Terror
        ];

        for (т_мера i = 0; basetab[i] != Terror; i++)
        {
            Тип t = new TypeBasic(basetab[i]);
            t = t.merge();
            basic[basetab[i]] = t;
        }
        basic[Terror] = new TypeError();

        tvoid = basic[Tvoid];
        tint8 = basic[Tint8];
        tuns8 = basic[Tuns8];
        tint16 = basic[Tint16];
        tuns16 = basic[Tuns16];
        tint32 = basic[Tint32];
        tuns32 = basic[Tuns32];
        tint64 = basic[Tint64];
        tuns64 = basic[Tuns64];
        tint128 = basic[Tint128];
        tuns128 = basic[Tuns128];
        tfloat32 = basic[Tfloat32];
        tfloat64 = basic[Tfloat64];
        tfloat80 = basic[Tfloat80];

        timaginary32 = basic[Timaginary32];
        timaginary64 = basic[Timaginary64];
        timaginary80 = basic[Timaginary80];

        tcomplex32 = basic[Tcomplex32];
        tcomplex64 = basic[Tcomplex64];
        tcomplex80 = basic[Tcomplex80];

        tбул = basic[Tbool];
        tchar = basic[Tchar];
        twchar = basic[Twchar];
        tdchar = basic[Tdchar];

        tshiftcnt = tint32;
        terror = basic[Terror];
        tnull = basic[Tnull];
        tnull = new TypeNull();
        tnull.deco = tnull.merge().deco;

        tvoidptr = tvoid.pointerTo();
        tstring = tchar.immutableOf().arrayOf();
        twstring = twchar.immutableOf().arrayOf();
        tdstring = tdchar.immutableOf().arrayOf();
        tvalist = target.va_listType();

        const isLP64 = глоб2.парамы.isLP64;

        tт_мера    = basic[isLP64 ? Tuns64 : Tuns32];
        tptrdiff_t = basic[isLP64 ? Tint64 : Tint32];
        thash_t = tт_мера;
    }

    /**
     * Deinitializes the глоб2 state of the compiler.
     *
     * This can be используется to restore the state set by `_иниц` to its original
     * state.
     */
    static проц deinitialize()
    {
        stringtable = stringtable.init;
    }

    final d_uns64 size()
    {
        return size(Место.initial);
    }

    d_uns64 size(ref Место место)
    {
        выведиОшибку(место, "нет размера для типа `%s`", вТкст0());
        return SIZE_INVALID;
    }

    бцел alignsize()
    {
        return cast(бцел)size(Место.initial);
    }

    final Тип trySemantic(ref Место место, Scope* sc)
    {
        //printf("+trySemantic(%s) %d\n", вТкст0(), глоб2.errors);

        // Needed to display any deprecations that were gagged
        auto tcopy = this.syntaxCopy();

        const errors = глоб2.startGagging();
        Тип t = typeSemantic(this, место, sc);
        if (глоб2.endGagging(errors) || t.ty == Terror) // if any errors happened
        {
            t = null;
        }
        else
        {
            // If `typeSemantic` succeeded, there may have been deprecations that
            // were gagged due the the `startGagging` above.  Run again to display
            // those deprecations.  https://issues.dlang.org/show_bug.cgi?ид=19107
            if (глоб2.gaggedWarnings > 0)
                typeSemantic(tcopy, место, sc);
        }
        //printf("-trySemantic(%s) %d\n", вТкст0(), глоб2.errors);
        return t;
    }

    /*************************************
     * This version does a merge even if the deco is already computed.
     * Necessary for types that have a deco, but are not merged.
     */
    final Тип merge2()
    {
        //printf("merge2(%s)\n", вТкст0());
        Тип t = this;
        assert(t);
        if (!t.deco)
            return t.merge();

        auto sv = stringtable.lookup(t.deco, strlen(t.deco));
        if (sv && sv.значение)
        {
            t = sv.значение;
            assert(t.deco);
        }
        else
            assert(0);
        return t;
    }

    /*********************************
     * Store this тип's modifier имя into буф.
     */
    final проц modToBuffer(БуфВыв* буф)  
    {
        if (mod)
        {
            буф.пишиБайт(' ');
            MODtoBuffer(буф, mod);
        }
    }

    /*********************************
     * Return this тип's modifier имя.
     */
    final ткст0 modToChars()  
    {
        БуфВыв буф;
        буф.резервируй(16);
        modToBuffer(&буф);
        return буф.extractChars();
    }

    бул isintegral()
    {
        return нет;
    }

    // real, imaginary, or complex
    бул isfloating()
    {
        return нет;
    }

    бул isreal()
    {
        return нет;
    }

    бул isimaginary()
    {
        return нет;
    }

    бул iscomplex()
    {
        return нет;
    }

    бул isscalar()
    {
        return нет;
    }

    бул isunsigned()
    {
        return нет;
    }

    бул ischar()
    {
        return нет;
    }

    бул isscope()
    {
        return нет;
    }

    бул isString()
    {
        return нет;
    }

    /**************************
     * When T is mutable,
     * Given:
     *      T a, b;
     * Can we bitwise assign:
     *      a = b;
     * ?
     */
    бул isAssignable()
    {
        return да;
    }

    /**************************
     * Возвращает да if T can be converted to булean значение.
     */
    бул isBoolean()
    {
        return isscalar();
    }

    /*********************************
     * Check тип to see if it is based on a deprecated symbol.
     */
    проц checkDeprecated(ref Место место, Scope* sc)
    {
        if (ДСимвол s = toDsymbol(sc))
        {
            s.checkDeprecated(место, sc);
        }
    }

    final бул isConst()     
    {
        return (mod & MODFlags.const_) != 0;
    }

    final бул isImmutable()     
    {
        return (mod & MODFlags.immutable_) != 0;
    }

    final бул isMutable()     
    {
        return (mod & (MODFlags.const_ | MODFlags.immutable_ | MODFlags.wild)) == 0;
    }

    final бул isShared()     
    {
        return (mod & MODFlags.shared_) != 0;
    }

    final бул isSharedConst()     
    {
        return (mod & (MODFlags.shared_ | MODFlags.const_)) == (MODFlags.shared_ | MODFlags.const_);
    }

    final бул isWild()     
    {
        return (mod & MODFlags.wild) != 0;
    }

    final бул isWildConst()     
    {
        return (mod & MODFlags.wildconst) == MODFlags.wildconst;
    }

    final бул isSharedWild()     
    {
        return (mod & (MODFlags.shared_ | MODFlags.wild)) == (MODFlags.shared_ | MODFlags.wild);
    }

    final бул isNaked()     
    {
        return mod == 0;
    }

    /********************************
     * Return a копируй of this тип with all attributes null-initialized.
     * Useful for creating a тип with different modifiers.
     */
    final Тип nullAttributes()  
    {
        бцел sz = sizeTy[ty];
        Тип t = cast(Тип)mem.xmalloc(sz);
        memcpy(cast(ук)t, cast(ук)this, sz);
        // t.mod = NULL;  // leave mod unchanged
        t.deco = null;
        t.arrayof = null;
        t.pto = null;
        t.rto = null;
        t.cto = null;
        t.ito = null;
        t.sto = null;
        t.scto = null;
        t.wto = null;
        t.wcto = null;
        t.swto = null;
        t.swcto = null;
        t.vtinfo = null;
        t.ctype = null;
        if (t.ty == Tstruct)
            (cast(TypeStruct)t).att = AliasThisRec.fwdref;
        if (t.ty == Tclass)
            (cast(TypeClass)t).att = AliasThisRec.fwdref;
        return t;
    }

    /********************************
     * Convert to 'const'.
     */
    final Тип constOf()
    {
        //printf("Тип::constOf() %p %s\n", this, вТкст0());
        if (mod == MODFlags.const_)
            return this;
        if (cto)
        {
            assert(cto.mod == MODFlags.const_);
            return cto;
        }
        Тип t = makeConst();
        t = t.merge();
        t.fixTo(this);
        //printf("-Тип::constOf() %p %s\n", t, t.вТкст0());
        return t;
    }

    /********************************
     * Convert to 'const'.
     */
    final Тип immutableOf()
    {
        //printf("Тип::immutableOf() %p %s\n", this, вТкст0());
        if (isImmutable())
            return this;
        if (ito)
        {
            assert(ito.isImmutable());
            return ito;
        }
        Тип t = makeImmutable();
        t = t.merge();
        t.fixTo(this);
        //printf("\t%p\n", t);
        return t;
    }

    /********************************
     * Make тип mutable.
     */
    final Тип mutableOf()
    {
        //printf("Тип::mutableOf() %p, %s\n", this, вТкст0());
        Тип t = this;
        if (isImmutable())
        {
            t = ito; // const => naked
            assert(!t || (t.isMutable() && !t.isShared()));
        }
        else if (isConst())
        {
            if (isShared())
            {
                if (isWild())
                    t = swcto; // shared wild const -> shared
                else
                    t = sto; // shared const => shared
            }
            else
            {
                if (isWild())
                    t = wcto; // wild const -> naked
                else
                    t = cto; // const => naked
            }
            assert(!t || t.isMutable());
        }
        else if (isWild())
        {
            if (isShared())
                t = sto; // shared wild => shared
            else
                t = wto; // wild => naked
            assert(!t || t.isMutable());
        }
        if (!t)
        {
            t = makeMutable();
            t = t.merge();
            t.fixTo(this);
        }
        else
            t = t.merge();
        assert(t.isMutable());
        return t;
    }

    final Тип sharedOf()
    {
        //printf("Тип::sharedOf() %p, %s\n", this, вТкст0());
        if (mod == MODFlags.shared_)
            return this;
        if (sto)
        {
            assert(sto.mod == MODFlags.shared_);
            return sto;
        }
        Тип t = makeShared();
        t = t.merge();
        t.fixTo(this);
        //printf("\t%p\n", t);
        return t;
    }

    final Тип sharedConstOf()
    {
        //printf("Тип::sharedConstOf() %p, %s\n", this, вТкст0());
        if (mod == (MODFlags.shared_ | MODFlags.const_))
            return this;
        if (scto)
        {
            assert(scto.mod == (MODFlags.shared_ | MODFlags.const_));
            return scto;
        }
        Тип t = makeSharedConst();
        t = t.merge();
        t.fixTo(this);
        //printf("\t%p\n", t);
        return t;
    }

    /********************************
     * Make тип unshared.
     *      0            => 0
     *      const        => const
     *      const    => const
     *      shared       => 0
     *      shared const => const
     *      wild         => wild
     *      wild const   => wild const
     *      shared wild  => wild
     *      shared wild const => wild const
     */
    final Тип unSharedOf()
    {
        //printf("Тип::unSharedOf() %p, %s\n", this, вТкст0());
        Тип t = this;

        if (isShared())
        {
            if (isWild())
            {
                if (isConst())
                    t = wcto; // shared wild const => wild const
                else
                    t = wto; // shared wild => wild
            }
            else
            {
                if (isConst())
                    t = cto; // shared const => const
                else
                    t = sto; // shared => naked
            }
            assert(!t || !t.isShared());
        }

        if (!t)
        {
            t = this.nullAttributes();
            t.mod = mod & ~MODFlags.shared_;
            t.ctype = ctype;
            t = t.merge();
            t.fixTo(this);
        }
        else
            t = t.merge();
        assert(!t.isShared());
        return t;
    }

    /********************************
     * Convert to 'wild'.
     */
    final Тип wildOf()
    {
        //printf("Тип::wildOf() %p %s\n", this, вТкст0());
        if (mod == MODFlags.wild)
            return this;
        if (wto)
        {
            assert(wto.mod == MODFlags.wild);
            return wto;
        }
        Тип t = makeWild();
        t = t.merge();
        t.fixTo(this);
        //printf("\t%p %s\n", t, t.вТкст0());
        return t;
    }

    final Тип wildConstOf()
    {
        //printf("Тип::wildConstOf() %p %s\n", this, вТкст0());
        if (mod == MODFlags.wildconst)
            return this;
        if (wcto)
        {
            assert(wcto.mod == MODFlags.wildconst);
            return wcto;
        }
        Тип t = makeWildConst();
        t = t.merge();
        t.fixTo(this);
        //printf("\t%p %s\n", t, t.вТкст0());
        return t;
    }

    final Тип sharedWildOf()
    {
        //printf("Тип::sharedWildOf() %p, %s\n", this, вТкст0());
        if (mod == (MODFlags.shared_ | MODFlags.wild))
            return this;
        if (swto)
        {
            assert(swto.mod == (MODFlags.shared_ | MODFlags.wild));
            return swto;
        }
        Тип t = makeSharedWild();
        t = t.merge();
        t.fixTo(this);
        //printf("\t%p %s\n", t, t.вТкст0());
        return t;
    }

    final Тип sharedWildConstOf()
    {
        //printf("Тип::sharedWildConstOf() %p, %s\n", this, вТкст0());
        if (mod == (MODFlags.shared_ | MODFlags.wildconst))
            return this;
        if (swcto)
        {
            assert(swcto.mod == (MODFlags.shared_ | MODFlags.wildconst));
            return swcto;
        }
        Тип t = makeSharedWildConst();
        t = t.merge();
        t.fixTo(this);
        //printf("\t%p %s\n", t, t.вТкст0());
        return t;
    }

    /**********************************
     * For our new тип 'this', which is тип-constructed from t,
     * fill in the cto, ito, sto, scto, wto shortcuts.
     */
    final проц fixTo(Тип t)
    {
        // If fixing this: const(T*) by t: const(T)*,
        // cache t to this.xto won't break transitivity.
        Тип mto = null;
        Тип tn = nextOf();
        if (!tn || ty != Tsarray && tn.mod == t.nextOf().mod)
        {
            switch (t.mod)
            {
            case 0:
                mto = t;
                break;

            case MODFlags.const_:
                cto = t;
                break;

            case MODFlags.wild:
                wto = t;
                break;

            case MODFlags.wildconst:
                wcto = t;
                break;

            case MODFlags.shared_:
                sto = t;
                break;

            case MODFlags.shared_ | MODFlags.const_:
                scto = t;
                break;

            case MODFlags.shared_ | MODFlags.wild:
                swto = t;
                break;

            case MODFlags.shared_ | MODFlags.wildconst:
                swcto = t;
                break;

            case MODFlags.immutable_:
                ito = t;
                break;

            default:
                break;
            }
        }
        assert(mod != t.mod);

        Z X(T, U)(T m, U n)
        {
            return ((m << 4) | n);
        }

        switch (mod)
        {
        case 0:
            break;

        case MODFlags.const_:
            cto = mto;
            t.cto = this;
            break;

        case MODFlags.wild:
            wto = mto;
            t.wto = this;
            break;

        case MODFlags.wildconst:
            wcto = mto;
            t.wcto = this;
            break;

        case MODFlags.shared_:
            sto = mto;
            t.sto = this;
            break;

        case MODFlags.shared_ | MODFlags.const_:
            scto = mto;
            t.scto = this;
            break;

        case MODFlags.shared_ | MODFlags.wild:
            swto = mto;
            t.swto = this;
            break;

        case MODFlags.shared_ | MODFlags.wildconst:
            swcto = mto;
            t.swcto = this;
            break;

        case MODFlags.immutable_:
            t.ito = this;
            if (t.cto)
                t.cto.ito = this;
            if (t.sto)
                t.sto.ito = this;
            if (t.scto)
                t.scto.ito = this;
            if (t.wto)
                t.wto.ito = this;
            if (t.wcto)
                t.wcto.ito = this;
            if (t.swto)
                t.swto.ito = this;
            if (t.swcto)
                t.swcto.ito = this;
            break;

        default:
            assert(0);
        }

        check();
        t.check();
        //printf("fixTo: %s, %s\n", вТкст0(), t.вТкст0());
    }

    /***************************
     * Look for bugs in constructing types.
     */
    final проц check()
    {
        switch (mod)
        {
        case 0:
            if (cto)
                assert(cto.mod == MODFlags.const_);
            if (ito)
                assert(ito.mod == MODFlags.immutable_);
            if (sto)
                assert(sto.mod == MODFlags.shared_);
            if (scto)
                assert(scto.mod == (MODFlags.shared_ | MODFlags.const_));
            if (wto)
                assert(wto.mod == MODFlags.wild);
            if (wcto)
                assert(wcto.mod == MODFlags.wildconst);
            if (swto)
                assert(swto.mod == (MODFlags.shared_ | MODFlags.wild));
            if (swcto)
                assert(swcto.mod == (MODFlags.shared_ | MODFlags.wildconst));
            break;

        case MODFlags.const_:
            if (cto)
                assert(cto.mod == 0);
            if (ito)
                assert(ito.mod == MODFlags.immutable_);
            if (sto)
                assert(sto.mod == MODFlags.shared_);
            if (scto)
                assert(scto.mod == (MODFlags.shared_ | MODFlags.const_));
            if (wto)
                assert(wto.mod == MODFlags.wild);
            if (wcto)
                assert(wcto.mod == MODFlags.wildconst);
            if (swto)
                assert(swto.mod == (MODFlags.shared_ | MODFlags.wild));
            if (swcto)
                assert(swcto.mod == (MODFlags.shared_ | MODFlags.wildconst));
            break;

        case MODFlags.wild:
            if (cto)
                assert(cto.mod == MODFlags.const_);
            if (ito)
                assert(ito.mod == MODFlags.immutable_);
            if (sto)
                assert(sto.mod == MODFlags.shared_);
            if (scto)
                assert(scto.mod == (MODFlags.shared_ | MODFlags.const_));
            if (wto)
                assert(wto.mod == 0);
            if (wcto)
                assert(wcto.mod == MODFlags.wildconst);
            if (swto)
                assert(swto.mod == (MODFlags.shared_ | MODFlags.wild));
            if (swcto)
                assert(swcto.mod == (MODFlags.shared_ | MODFlags.wildconst));
            break;

        case MODFlags.wildconst:
            assert(!cto || cto.mod == MODFlags.const_);
            assert(!ito || ito.mod == MODFlags.immutable_);
            assert(!sto || sto.mod == MODFlags.shared_);
            assert(!scto || scto.mod == (MODFlags.shared_ | MODFlags.const_));
            assert(!wto || wto.mod == MODFlags.wild);
            assert(!wcto || wcto.mod == 0);
            assert(!swto || swto.mod == (MODFlags.shared_ | MODFlags.wild));
            assert(!swcto || swcto.mod == (MODFlags.shared_ | MODFlags.wildconst));
            break;

        case MODFlags.shared_:
            if (cto)
                assert(cto.mod == MODFlags.const_);
            if (ito)
                assert(ito.mod == MODFlags.immutable_);
            if (sto)
                assert(sto.mod == 0);
            if (scto)
                assert(scto.mod == (MODFlags.shared_ | MODFlags.const_));
            if (wto)
                assert(wto.mod == MODFlags.wild);
            if (wcto)
                assert(wcto.mod == MODFlags.wildconst);
            if (swto)
                assert(swto.mod == (MODFlags.shared_ | MODFlags.wild));
            if (swcto)
                assert(swcto.mod == (MODFlags.shared_ | MODFlags.wildconst));
            break;

        case MODFlags.shared_ | MODFlags.const_:
            if (cto)
                assert(cto.mod == MODFlags.const_);
            if (ito)
                assert(ito.mod == MODFlags.immutable_);
            if (sto)
                assert(sto.mod == MODFlags.shared_);
            if (scto)
                assert(scto.mod == 0);
            if (wto)
                assert(wto.mod == MODFlags.wild);
            if (wcto)
                assert(wcto.mod == MODFlags.wildconst);
            if (swto)
                assert(swto.mod == (MODFlags.shared_ | MODFlags.wild));
            if (swcto)
                assert(swcto.mod == (MODFlags.shared_ | MODFlags.wildconst));
            break;

        case MODFlags.shared_ | MODFlags.wild:
            if (cto)
                assert(cto.mod == MODFlags.const_);
            if (ito)
                assert(ito.mod == MODFlags.immutable_);
            if (sto)
                assert(sto.mod == MODFlags.shared_);
            if (scto)
                assert(scto.mod == (MODFlags.shared_ | MODFlags.const_));
            if (wto)
                assert(wto.mod == MODFlags.wild);
            if (wcto)
                assert(wcto.mod == MODFlags.wildconst);
            if (swto)
                assert(swto.mod == 0);
            if (swcto)
                assert(swcto.mod == (MODFlags.shared_ | MODFlags.wildconst));
            break;

        case MODFlags.shared_ | MODFlags.wildconst:
            assert(!cto || cto.mod == MODFlags.const_);
            assert(!ito || ito.mod == MODFlags.immutable_);
            assert(!sto || sto.mod == MODFlags.shared_);
            assert(!scto || scto.mod == (MODFlags.shared_ | MODFlags.const_));
            assert(!wto || wto.mod == MODFlags.wild);
            assert(!wcto || wcto.mod == MODFlags.wildconst);
            assert(!swto || swto.mod == (MODFlags.shared_ | MODFlags.wild));
            assert(!swcto || swcto.mod == 0);
            break;

        case MODFlags.immutable_:
            if (cto)
                assert(cto.mod == MODFlags.const_);
            if (ito)
                assert(ito.mod == 0);
            if (sto)
                assert(sto.mod == MODFlags.shared_);
            if (scto)
                assert(scto.mod == (MODFlags.shared_ | MODFlags.const_));
            if (wto)
                assert(wto.mod == MODFlags.wild);
            if (wcto)
                assert(wcto.mod == MODFlags.wildconst);
            if (swto)
                assert(swto.mod == (MODFlags.shared_ | MODFlags.wild));
            if (swcto)
                assert(swcto.mod == (MODFlags.shared_ | MODFlags.wildconst));
            break;

        default:
            assert(0);
        }

        Тип tn = nextOf();
        if (tn && ty != Tfunction && tn.ty != Tfunction && ty != Tenum)
        {
            // Verify transitivity
            switch (mod)
            {
            case 0:
            case MODFlags.const_:
            case MODFlags.wild:
            case MODFlags.wildconst:
            case MODFlags.shared_:
            case MODFlags.shared_ | MODFlags.const_:
            case MODFlags.shared_ | MODFlags.wild:
            case MODFlags.shared_ | MODFlags.wildconst:
            case MODFlags.immutable_:
                assert(tn.mod == MODFlags.immutable_ || (tn.mod & mod) == mod);
                break;

            default:
                assert(0);
            }
            tn.check();
        }
    }

    /*************************************
     * Apply STCxxxx bits to existing тип.
     * Use *before* semantic analysis is run.
     */
    final Тип addSTC(КлассХранения stc)
    {
        Тип t = this;
        if (t.isImmutable())
        {
        }
        else if (stc & STC.immutable_)
        {
            t = t.makeImmutable();
        }
        else
        {
            if ((stc & STC.shared_) && !t.isShared())
            {
                if (t.isWild())
                {
                    if (t.isConst())
                        t = t.makeSharedWildConst();
                    else
                        t = t.makeSharedWild();
                }
                else
                {
                    if (t.isConst())
                        t = t.makeSharedConst();
                    else
                        t = t.makeShared();
                }
            }
            if ((stc & STC.const_) && !t.isConst())
            {
                if (t.isShared())
                {
                    if (t.isWild())
                        t = t.makeSharedWildConst();
                    else
                        t = t.makeSharedConst();
                }
                else
                {
                    if (t.isWild())
                        t = t.makeWildConst();
                    else
                        t = t.makeConst();
                }
            }
            if ((stc & STC.wild) && !t.isWild())
            {
                if (t.isShared())
                {
                    if (t.isConst())
                        t = t.makeSharedWildConst();
                    else
                        t = t.makeSharedWild();
                }
                else
                {
                    if (t.isConst())
                        t = t.makeWildConst();
                    else
                        t = t.makeWild();
                }
            }
        }
        return t;
    }

    /************************************
     * Apply MODxxxx bits to existing тип.
     */
    final Тип castMod(MOD mod)
    {
        Тип t;
        switch (mod)
        {
        case 0:
            t = unSharedOf().mutableOf();
            break;

        case MODFlags.const_:
            t = unSharedOf().constOf();
            break;

        case MODFlags.wild:
            t = unSharedOf().wildOf();
            break;

        case MODFlags.wildconst:
            t = unSharedOf().wildConstOf();
            break;

        case MODFlags.shared_:
            t = mutableOf().sharedOf();
            break;

        case MODFlags.shared_ | MODFlags.const_:
            t = sharedConstOf();
            break;

        case MODFlags.shared_ | MODFlags.wild:
            t = sharedWildOf();
            break;

        case MODFlags.shared_ | MODFlags.wildconst:
            t = sharedWildConstOf();
            break;

        case MODFlags.immutable_:
            t = immutableOf();
            break;

        default:
            assert(0);
        }
        return t;
    }

    /************************************
     * Add MODxxxx bits to existing тип.
     * We're adding, not replacing, so adding const to
     * a shared тип => "shared const"
     */
    final Тип addMod(MOD mod)
    {
        /* Add anything to const, and it remains const
         */
        Тип t = this;
        if (!t.isImmutable())
        {
            //printf("addMod(%x) %s\n", mod, вТкст0());
            switch (mod)
            {
            case 0:
                break;

            case MODFlags.const_:
                if (isShared())
                {
                    if (isWild())
                        t = sharedWildConstOf();
                    else
                        t = sharedConstOf();
                }
                else
                {
                    if (isWild())
                        t = wildConstOf();
                    else
                        t = constOf();
                }
                break;

            case MODFlags.wild:
                if (isShared())
                {
                    if (isConst())
                        t = sharedWildConstOf();
                    else
                        t = sharedWildOf();
                }
                else
                {
                    if (isConst())
                        t = wildConstOf();
                    else
                        t = wildOf();
                }
                break;

            case MODFlags.wildconst:
                if (isShared())
                    t = sharedWildConstOf();
                else
                    t = wildConstOf();
                break;

            case MODFlags.shared_:
                if (isWild())
                {
                    if (isConst())
                        t = sharedWildConstOf();
                    else
                        t = sharedWildOf();
                }
                else
                {
                    if (isConst())
                        t = sharedConstOf();
                    else
                        t = sharedOf();
                }
                break;

            case MODFlags.shared_ | MODFlags.const_:
                if (isWild())
                    t = sharedWildConstOf();
                else
                    t = sharedConstOf();
                break;

            case MODFlags.shared_ | MODFlags.wild:
                if (isConst())
                    t = sharedWildConstOf();
                else
                    t = sharedWildOf();
                break;

            case MODFlags.shared_ | MODFlags.wildconst:
                t = sharedWildConstOf();
                break;

            case MODFlags.immutable_:
                t = immutableOf();
                break;

            default:
                assert(0);
            }
        }
        return t;
    }

    /************************************
     * Add storage class modifiers to тип.
     */
    Тип addStorageClass(КлассХранения stc)
    {
        /* Just translate to MOD bits and let addMod() do the work
         */
        MOD mod = 0;
        if (stc & STC.immutable_)
            mod = MODFlags.immutable_;
        else
        {
            if (stc & (STC.const_ | STC.in_))
                mod |= MODFlags.const_;
            if (stc & STC.wild)
                mod |= MODFlags.wild;
            if (stc & STC.shared_)
                mod |= MODFlags.shared_;
        }
        return addMod(mod);
    }

    final Тип pointerTo()
    {
        if (ty == Terror)
            return this;
        if (!pto)
        {
            Тип t = new TypePointer(this);
            if (ty == Tfunction)
            {
                t.deco = t.merge().deco;
                pto = t;
            }
            else
                pto = t.merge();
        }
        return pto;
    }

    final Тип referenceTo()
    {
        if (ty == Terror)
            return this;
        if (!rto)
        {
            Тип t = new TypeReference(this);
            rto = t.merge();
        }
        return rto;
    }

    final Тип arrayOf()
    {
        if (ty == Terror)
            return this;
        if (!arrayof)
        {
            Тип t = new TypeDArray(this);
            arrayof = t.merge();
        }
        return arrayof;
    }

    // Make corresponding static массив тип without semantic
    final Тип sarrayOf(dinteger_t dim)
    {
        assert(deco);
        Тип t = new TypeSArray(this, new IntegerExp(Место.initial, dim, Тип.tт_мера));
        // according to TypeSArray::semantic()
        t = t.addMod(mod);
        t = t.merge();
        return t;
    }

    final Тип aliasthisOf()
    {
        auto ad = isAggregate(this);
        if (!ad || !ad.aliasthis)
            return null;

        auto s = ad.aliasthis.sym;
        if (s.isAliasDeclaration())
            s = s.toAlias();

        if (s.isTupleDeclaration())
            return null;

        if (auto vd = s.isVarDeclaration())
        {
            auto t = vd.тип;
            if (vd.needThis())
                t = t.addMod(this.mod);
            return t;
        }
        if (auto fd = s.isFuncDeclaration())
        {
            fd = resolveFuncCall(Место.initial, null, fd, null, this, null, FuncResolveFlag.quiet);
            if (!fd || fd.errors || !fd.functionSemantic())
                return Тип.terror;

            auto t = fd.тип.nextOf();
            if (!t) // issue 14185
                return Тип.terror;
            t = t.substWildTo(mod == 0 ? MODFlags.mutable : mod);
            return t;
        }
        if (auto d = s.isDeclaration())
        {
            assert(d.тип);
            return d.тип;
        }
        if (auto ed = s.isEnumDeclaration())
        {
            return ed.тип;
        }
        if (auto td = s.isTemplateDeclaration())
        {
            assert(td._scope);
            auto fd = resolveFuncCall(Место.initial, null, td, null, this, null, FuncResolveFlag.quiet);
            if (!fd || fd.errors || !fd.functionSemantic())
                return Тип.terror;

            auto t = fd.тип.nextOf();
            if (!t)
                return Тип.terror;
            t = t.substWildTo(mod == 0 ? MODFlags.mutable : mod);
            return t;
        }

        //printf("%s\n", s.вид());
        return null;
    }

    extern (D) final бул checkAliasThisRec()
    {
        Тип tb = toBasetype();
        AliasThisRec* pflag;
        if (tb.ty == Tstruct)
            pflag = &(cast(TypeStruct)tb).att;
        else if (tb.ty == Tclass)
            pflag = &(cast(TypeClass)tb).att;
        else
            return нет;

        AliasThisRec флаг = cast(AliasThisRec)(*pflag & AliasThisRec.typeMask);
        if (флаг == AliasThisRec.fwdref)
        {
            Тип att = aliasthisOf();
            флаг = att && att.implicitConvTo(this) ? AliasThisRec.yes : AliasThisRec.no;
        }
        *pflag = cast(AliasThisRec)(флаг | (*pflag & ~AliasThisRec.typeMask));
        return флаг == AliasThisRec.yes;
    }

    Тип makeConst()
    {
        //printf("Тип::makeConst() %p, %s\n", this, вТкст0());
        if (cto)
            return cto;
        Тип t = this.nullAttributes();
        t.mod = MODFlags.const_;
        //printf("-Тип::makeConst() %p, %s\n", t, вТкст0());
        return t;
    }

    Тип makeImmutable()
    {
        if (ito)
            return ito;
        Тип t = this.nullAttributes();
        t.mod = MODFlags.immutable_;
        return t;
    }

    Тип makeShared()
    {
        if (sto)
            return sto;
        Тип t = this.nullAttributes();
        t.mod = MODFlags.shared_;
        return t;
    }

    Тип makeSharedConst()
    {
        if (scto)
            return scto;
        Тип t = this.nullAttributes();
        t.mod = MODFlags.shared_ | MODFlags.const_;
        return t;
    }

    Тип makeWild()
    {
        if (wto)
            return wto;
        Тип t = this.nullAttributes();
        t.mod = MODFlags.wild;
        return t;
    }

    Тип makeWildConst()
    {
        if (wcto)
            return wcto;
        Тип t = this.nullAttributes();
        t.mod = MODFlags.wildconst;
        return t;
    }

    Тип makeSharedWild()
    {
        if (swto)
            return swto;
        Тип t = this.nullAttributes();
        t.mod = MODFlags.shared_ | MODFlags.wild;
        return t;
    }

    Тип makeSharedWildConst()
    {
        if (swcto)
            return swcto;
        Тип t = this.nullAttributes();
        t.mod = MODFlags.shared_ | MODFlags.wildconst;
        return t;
    }

    Тип makeMutable()
    {
        Тип t = this.nullAttributes();
        t.mod = mod & MODFlags.shared_;
        return t;
    }

    ДСимвол toDsymbol(Scope* sc)
    {
        return null;
    }

    /*******************************
     * If this is a shell around another тип,
     * get that other тип.
     */
    Тип toBasetype()
    {
        return this;
    }

    бул isBaseOf(Тип t, цел* poffset)
    {
        return 0; // assume not
    }

    /********************************
     * Determine if 'this' can be implicitly converted
     * to тип 'to'.
     * Возвращает:
     *      MATCH.nomatch, MATCH.convert, MATCH.constant, MATCH.exact
     */
    MATCH implicitConvTo(Тип to)
    {
        //printf("Тип::implicitConvTo(this=%p, to=%p)\n", this, to);
        //printf("from: %s\n", вТкст0());
        //printf("to  : %s\n", to.вТкст0());
        if (this.равен(to))
            return MATCH.exact;
        return MATCH.nomatch;
    }

    /*******************************
     * Determine if converting 'this' to 'to' is an identity operation,
     * a conversion to const operation, or the types aren't the same.
     * Возвращает:
     *      MATCH.exact      'this' == 'to'
     *      MATCH.constant      'to' is const
     *      MATCH.nomatch    conversion to mutable or invariant
     */
    MATCH constConv(Тип to)
    {
        //printf("Тип::constConv(this = %s, to = %s)\n", вТкст0(), to.вТкст0());
        if (равен(to))
            return MATCH.exact;
        if (ty == to.ty && MODimplicitConv(mod, to.mod))
            return MATCH.constant;
        return MATCH.nomatch;
    }

    /***************************************
     * Compute MOD bits matching `this` argument тип to wild параметр тип.
     * Параметры:
     *  t = corresponding параметр тип
     *  isRef = параметр is `ref` or `out`
     * Возвращает:
     *  MOD bits
     */
    MOD deduceWild(Тип t, бул isRef)
    {
        //printf("Тип::deduceWild this = '%s', tprm = '%s'\n", вТкст0(), tprm.вТкст0());
        if (t.isWild())
        {
            if (isImmutable())
                return MODFlags.immutable_;
            else if (isWildConst())
            {
                if (t.isWildConst())
                    return MODFlags.wild;
                else
                    return MODFlags.wildconst;
            }
            else if (isWild())
                return MODFlags.wild;
            else if (isConst())
                return MODFlags.const_;
            else if (isMutable())
                return MODFlags.mutable;
            else
                assert(0);
        }
        return 0;
    }

    Тип substWildTo(бцел mod)
    {
        //printf("+Тип::substWildTo this = %s, mod = x%x\n", вТкст0(), mod);
        Тип t;

        if (Тип tn = nextOf())
        {
            // substitution has no effect on function pointer тип.
            if (ty == Tpointer && tn.ty == Tfunction)
            {
                t = this;
                goto L1;
            }

            t = tn.substWildTo(mod);
            if (t == tn)
                t = this;
            else
            {
                if (ty == Tpointer)
                    t = t.pointerTo();
                else if (ty == Tarray)
                    t = t.arrayOf();
                else if (ty == Tsarray)
                    t = new TypeSArray(t, (cast(TypeSArray)this).dim.syntaxCopy());
                else if (ty == Taarray)
                {
                    t = new TypeAArray(t, (cast(TypeAArray)this).index.syntaxCopy());
                    (cast(TypeAArray)t).sc = (cast(TypeAArray)this).sc; // duplicate scope
                }
                else if (ty == Tdelegate)
                {
                    t = new TypeDelegate(t);
                }
                else
                    assert(0);

                t = t.merge();
            }
        }
        else
            t = this;

    L1:
        if (isWild())
        {
            if (mod == MODFlags.immutable_)
            {
                t = t.immutableOf();
            }
            else if (mod == MODFlags.wildconst)
            {
                t = t.wildConstOf();
            }
            else if (mod == MODFlags.wild)
            {
                if (isWildConst())
                    t = t.wildConstOf();
                else
                    t = t.wildOf();
            }
            else if (mod == MODFlags.const_)
            {
                t = t.constOf();
            }
            else
            {
                if (isWildConst())
                    t = t.constOf();
                else
                    t = t.mutableOf();
            }
        }
        if (isConst())
            t = t.addMod(MODFlags.const_);
        if (isShared())
            t = t.addMod(MODFlags.shared_);

        //printf("-Тип::substWildTo t = %s\n", t.вТкст0());
        return t;
    }

    final Тип unqualify(бцел m)
    {
        Тип t = mutableOf().unSharedOf();

        Тип tn = ty == Tenum ? null : nextOf();
        if (tn && tn.ty != Tfunction)
        {
            Тип utn = tn.unqualify(m);
            if (utn != tn)
            {
                if (ty == Tpointer)
                    t = utn.pointerTo();
                else if (ty == Tarray)
                    t = utn.arrayOf();
                else if (ty == Tsarray)
                    t = new TypeSArray(utn, (cast(TypeSArray)this).dim);
                else if (ty == Taarray)
                {
                    t = new TypeAArray(utn, (cast(TypeAArray)this).index);
                    (cast(TypeAArray)t).sc = (cast(TypeAArray)this).sc; // duplicate scope
                }
                else
                    assert(0);

                t = t.merge();
            }
        }
        t = t.addMod(mod & ~m);
        return t;
    }

    /**************************
     * Return тип with the top уровень of it being mutable.
     */
    Тип toHeadMutable() 
    {
        if (!mod)
            return this;
        Тип unqualThis = cast(Тип) this;
        // `mutableOf` needs a mutable `this` only for caching
        return  unqualThis.mutableOf();
    }

    ClassDeclaration isClassHandle()
    {
        return null;
    }

    /************************************
     * Return alignment to use for this тип.
     */
    structalign_t alignment()
    {
        return STRUCTALIGN_DEFAULT;
    }

    /***************************************
     * Use when we prefer the default инициализатор to be a literal,
     * rather than a глоб2 const variable.
     */
    Выражение defaultInitLiteral(ref Место место)
    {
        static if (LOGDEFAULTINIT)
        {
            printf("Тип::defaultInitLiteral() '%s'\n", вТкст0());
        }
        return defaultInit(this, место);
    }

    // if инициализатор is 0
    бул isZeroInit(ref Место место)
    {
        return нет; // assume not
    }

    final Идентификатор2 getTypeInfoIdent()
    {
        // _init_10TypeInfo_%s
        БуфВыв буф;
        буф.резервируй(32);
        mangleToBuffer(this, &буф);

        const slice = буф[];

        // Allocate буфер on stack, fail over to using malloc()
        сим[128] namebuf;
        const namelen = 19 + т_мера.sizeof * 3 + slice.length + 1;
        auto имя = namelen <= namebuf.length ? namebuf.ptr : cast(сим*)Пам.check(malloc(namelen));

        const length = sprintf(имя, "_D%lluTypeInfo_%.*s6__initZ",
                cast(бдол)(9 + slice.length), cast(цел)slice.length, slice.ptr);
        //printf("%p %s, deco = %s, имя = %s\n", this, вТкст0(), deco, имя);
        assert(0 < length && length < namelen); // don't overflow the буфер

        auto ид = Идентификатор2.idPool(имя, length);

        if (имя != namebuf.ptr)
            free(имя);
        return ид;
    }

    /***************************************
     * Return !=0 if the тип or any of its subtypes is wild.
     */
    цел hasWild() 
    {
        return mod & MODFlags.wild;
    }

    /***************************************
     * Return !=0 if тип has pointers that need to
     * be scanned by the СМ during a collection cycle.
     */
    бул hasPointers()
    {
        //printf("Тип::hasPointers() %s, %d\n", вТкст0(), ty);
        return нет;
    }

    /*************************************
     * Detect if тип has pointer fields that are initialized to проц.
     * Local stack variables with such проц fields can remain uninitialized,
     * leading to pointer bugs.
     * Возвращает:
     *  да if so
     */
    бул hasVoidInitPointers()
    {
        return нет;
    }

    /*************************************
     * If this is a тип of something, return that something.
     */
    Тип nextOf()
    {
        return null;
    }

    /*************************************
     * If this is a тип of static массив, return its base element тип.
     */
    final Тип baseElemOf()
    {
        Тип t = toBasetype();
        TypeSArray tsa;
        while ((tsa = t.isTypeSArray()) !is null)
            t = tsa.следщ.toBasetype();
        return t;
    }

    /*******************************************
     * Compute number of elements for a (possibly multidimensional) static массив,
     * or 1 for other types.
     * Параметры:
     *  место = for error message
     * Возвращает:
     *  number of elements, бцел.max on overflow
     */
    final бцел numberOfElems(ref Место место)
    {
        //printf("Тип::numberOfElems()\n");
        uinteger_t n = 1;
        Тип tb = this;
        while ((tb = tb.toBasetype()).ty == Tsarray)
        {
            бул overflow = нет;
            n = mulu(n, (cast(TypeSArray)tb).dim.toUInteger(), overflow);
            if (overflow || n >= бцел.max)
            {
                выведиОшибку(место, "static массив `%s` size overflowed to %llu", вТкст0(), cast(бдол)n);
                return бцел.max;
            }
            tb = (cast(TypeSArray)tb).следщ;
        }
        return cast(бцел)n;
    }

    /****************************************
     * Return the mask that an integral тип will
     * fit into.
     */
    final uinteger_t sizemask()
    {
        uinteger_t m;
        switch (toBasetype().ty)
        {
        case Tbool:
            m = 1;
            break;
        case Tchar:
        case Tint8:
        case Tuns8:
            m = 0xFF;
            break;
        case Twchar:
        case Tint16:
        case Tuns16:
            m = 0xFFFFU;
            break;
        case Tdchar:
        case Tint32:
        case Tuns32:
            m = 0xFFFFFFFFU;
            break;
        case Tint64:
        case Tuns64:
            m = 0xFFFFFFFFFFFFFFFFUL;
            break;
        default:
            assert(0);
        }
        return m;
    }

    /********************************
     * да if when тип goes out of scope, it needs a destructor applied.
     * Only applies to значение types, not ref types.
     */
    бул needsDestruction()
    {
        return нет;
    }

    /*********************************
     *
     */
    бул needsNested()
    {
        return нет;
    }

    /*************************************
     * https://issues.dlang.org/show_bug.cgi?ид=14488
     * Check if the inner most base тип is complex or imaginary.
     * Should only give alerts when set to emit transitional messages.
     * Параметры:
     *  место = The source location.
     *  sc = scope of the тип
     */
    extern (D) final бул checkComplexTransition(ref Место место, Scope* sc)
    {
        if (sc.isDeprecated())
            return нет;

        Тип t = baseElemOf();
        while (t.ty == Tpointer || t.ty == Tarray)
            t = t.nextOf().baseElemOf();

        // Basetype is an opaque enum, nothing to check.
        if (t.ty == Tenum && !(cast(TypeEnum)t).sym.memtype)
            return нет;

        if (t.isimaginary() || t.iscomplex())
        {
            Тип rt;
            switch (t.ty)
            {
            case Tcomplex32:
            case Timaginary32:
                rt = Тип.tfloat32;
                break;

            case Tcomplex64:
            case Timaginary64:
                rt = Тип.tfloat64;
                break;

            case Tcomplex80:
            case Timaginary80:
                rt = Тип.tfloat80;
                break;

            default:
                assert(0);
            }
            if (t.iscomplex())
            {
                deprecation(место, "use of complex тип `%s` is deprecated, use `std.complex.Complex!(%s)` instead",
                    вТкст0(), rt.вТкст0());
                return да;
            }
            else
            {
                deprecation(место, "use of imaginary тип `%s` is deprecated, use `%s` instead",
                    вТкст0(), rt.вТкст0());
                return да;
            }
        }
        return нет;
    }

    // For eliminating dynamic_cast
    TypeBasic isTypeBasic()
    {
        return null;
    }
/+
    final  //inout  
    {
        TypeError      isTypeError()      { return ty == Terror     ? cast(typeof(return))this : null; }
        TypeVector     isTypeVector()     { return ty == Tvector    ? cast(typeof(return))this : null; }
        TypeSArray     isTypeSArray()     { return ty == Tsarray    ? cast(typeof(return))this : null; }
        TypeDArray     isTypeDArray()     { return ty == Tarray     ? cast(typeof(return))this : null; }
        TypeAArray     isTypeAArray()     { return ty == Taarray    ? cast(typeof(return))this : null; }
        TypePointer    isTypePointer()    { return ty == Tpointer   ? cast(typeof(return))this : null; }
        TypeReference  isTypeReference()  { return ty == Treference ? cast(typeof(return))this : null; }
        TypeFunction   isTypeFunction()   { return ty == Tfunction  ? cast(typeof(return))this : null; }
        TypeDelegate   isTypeDelegate()   { return ty == Tdelegate  ? cast(typeof(return))this : null; }
        TypeIdentifier isTypeIdentifier() { return ty == Tident     ? cast(typeof(return))this : null; }
        TypeInstance   isTypeInstance()   { return ty == Tinstance  ? cast(typeof(return))this : null; }
        TypeTypeof     isTypeTypeof()     { return ty == Ttypeof    ? cast(typeof(return))this : null; }
        TypeReturn     isTypeReturn()     { return ty == Treturn    ? cast(typeof(return))this : null; }
        TypeStruct     isTypeStruct()     { return ty == Tstruct    ? cast(typeof(return))this : null; }
        TypeEnum       isTypeEnum()       { return ty == Tenum      ? cast(typeof(return))this : null; }
        TypeClass      isTypeClass()      { return ty == Tclass     ? cast(typeof(return))this : null; }
        КортежТипов      isTypeTuple()      { return ty == Ttuple     ? cast(typeof(return))this : null; }
        TypeSlice      isTypeSlice()      { return ty == Tslice     ? cast(typeof(return))this : null; }
        TypeNull       isTypeNull()       { return ty == Tnull      ? cast(typeof(return))this : null; }
        TypeMixin      isTypeMixin()      { return ty == Tmixin     ? cast(typeof(return))this : null; }
        TypeTraits   isTypeTraits()     { return ty == Ttraits    ? cast(typeof(return))this : null; }
    }
+/
    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }

    final TypeFunction toTypeFunction()
    {
        if (ty != Tfunction)
            assert(0);
        return cast(TypeFunction)this;
    }
}

/***********************************************************
 */
 final class TypeError : Тип
{
    this()
    {
        super(Terror);
    }

    override Тип syntaxCopy()
    {
        // No semantic analysis done, no need to копируй
        return this;
    }

    override d_uns64 size(ref Место место)
    {
        return SIZE_INVALID;
    }

    override Выражение defaultInitLiteral(ref Место место)
    {
        return new ErrorExp();
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 abstract class TypeNext : Тип
{
    Тип следщ;

    final this(TY ty, Тип следщ)
    {
        super(ty);
        this.следщ = следщ;
    }

    override final проц checkDeprecated(ref Место место, Scope* sc)
    {
        Тип.checkDeprecated(место, sc);
        if (следщ) // следщ can be NULL if TypeFunction and auto return тип
            следщ.checkDeprecated(место, sc);
    }

    override final цел hasWild() 
    {
        if (ty == Tfunction)
            return 0;
        if (ty == Tdelegate)
            return Тип.hasWild();
        return mod & MODFlags.wild || (следщ && следщ.hasWild());
    }

    /*******************************
     * For TypeFunction, nextOf() can return NULL if the function return
     * тип is meant to be inferred, and semantic() hasn't yet ben run
     * on the function. After semantic(), it must no longer be NULL.
     */
    override final Тип nextOf()
    {
        return следщ;
    }

    override final Тип makeConst()
    {
        //printf("TypeNext::makeConst() %p, %s\n", this, вТкст0());
        if (cto)
        {
            assert(cto.mod == MODFlags.const_);
            return cto;
        }
        TypeNext t = cast(TypeNext)Тип.makeConst();
        if (ty != Tfunction && следщ.ty != Tfunction && !следщ.isImmutable())
        {
            if (следщ.isShared())
            {
                if (следщ.isWild())
                    t.следщ = следщ.sharedWildConstOf();
                else
                    t.следщ = следщ.sharedConstOf();
            }
            else
            {
                if (следщ.isWild())
                    t.следщ = следщ.wildConstOf();
                else
                    t.следщ = следщ.constOf();
            }
        }
        //printf("TypeNext::makeConst() returns %p, %s\n", t, t.вТкст0());
        return t;
    }

    override final Тип makeImmutable()
    {
        //printf("TypeNext::makeImmutable() %s\n", вТкст0());
        if (ito)
        {
            assert(ito.isImmutable());
            return ito;
        }
        TypeNext t = cast(TypeNext)Тип.makeImmutable();
        if (ty != Tfunction && следщ.ty != Tfunction && !следщ.isImmutable())
        {
            t.следщ = следщ.immutableOf();
        }
        return t;
    }

    override final Тип makeShared()
    {
        //printf("TypeNext::makeShared() %s\n", вТкст0());
        if (sto)
        {
            assert(sto.mod == MODFlags.shared_);
            return sto;
        }
        TypeNext t = cast(TypeNext)Тип.makeShared();
        if (ty != Tfunction && следщ.ty != Tfunction && !следщ.isImmutable())
        {
            if (следщ.isWild())
            {
                if (следщ.isConst())
                    t.следщ = следщ.sharedWildConstOf();
                else
                    t.следщ = следщ.sharedWildOf();
            }
            else
            {
                if (следщ.isConst())
                    t.следщ = следщ.sharedConstOf();
                else
                    t.следщ = следщ.sharedOf();
            }
        }
        //printf("TypeNext::makeShared() returns %p, %s\n", t, t.вТкст0());
        return t;
    }

    override final Тип makeSharedConst()
    {
        //printf("TypeNext::makeSharedConst() %s\n", вТкст0());
        if (scto)
        {
            assert(scto.mod == (MODFlags.shared_ | MODFlags.const_));
            return scto;
        }
        TypeNext t = cast(TypeNext)Тип.makeSharedConst();
        if (ty != Tfunction && следщ.ty != Tfunction && !следщ.isImmutable())
        {
            if (следщ.isWild())
                t.следщ = следщ.sharedWildConstOf();
            else
                t.следщ = следщ.sharedConstOf();
        }
        //printf("TypeNext::makeSharedConst() returns %p, %s\n", t, t.вТкст0());
        return t;
    }

    override final Тип makeWild()
    {
        //printf("TypeNext::makeWild() %s\n", вТкст0());
        if (wto)
        {
            assert(wto.mod == MODFlags.wild);
            return wto;
        }
        TypeNext t = cast(TypeNext)Тип.makeWild();
        if (ty != Tfunction && следщ.ty != Tfunction && !следщ.isImmutable())
        {
            if (следщ.isShared())
            {
                if (следщ.isConst())
                    t.следщ = следщ.sharedWildConstOf();
                else
                    t.следщ = следщ.sharedWildOf();
            }
            else
            {
                if (следщ.isConst())
                    t.следщ = следщ.wildConstOf();
                else
                    t.следщ = следщ.wildOf();
            }
        }
        //printf("TypeNext::makeWild() returns %p, %s\n", t, t.вТкст0());
        return t;
    }

    override final Тип makeWildConst()
    {
        //printf("TypeNext::makeWildConst() %s\n", вТкст0());
        if (wcto)
        {
            assert(wcto.mod == MODFlags.wildconst);
            return wcto;
        }
        TypeNext t = cast(TypeNext)Тип.makeWildConst();
        if (ty != Tfunction && следщ.ty != Tfunction && !следщ.isImmutable())
        {
            if (следщ.isShared())
                t.следщ = следщ.sharedWildConstOf();
            else
                t.следщ = следщ.wildConstOf();
        }
        //printf("TypeNext::makeWildConst() returns %p, %s\n", t, t.вТкст0());
        return t;
    }

    override final Тип makeSharedWild()
    {
        //printf("TypeNext::makeSharedWild() %s\n", вТкст0());
        if (swto)
        {
            assert(swto.isSharedWild());
            return swto;
        }
        TypeNext t = cast(TypeNext)Тип.makeSharedWild();
        if (ty != Tfunction && следщ.ty != Tfunction && !следщ.isImmutable())
        {
            if (следщ.isConst())
                t.следщ = следщ.sharedWildConstOf();
            else
                t.следщ = следщ.sharedWildOf();
        }
        //printf("TypeNext::makeSharedWild() returns %p, %s\n", t, t.вТкст0());
        return t;
    }

    override final Тип makeSharedWildConst()
    {
        //printf("TypeNext::makeSharedWildConst() %s\n", вТкст0());
        if (swcto)
        {
            assert(swcto.mod == (MODFlags.shared_ | MODFlags.wildconst));
            return swcto;
        }
        TypeNext t = cast(TypeNext)Тип.makeSharedWildConst();
        if (ty != Tfunction && следщ.ty != Tfunction && !следщ.isImmutable())
        {
            t.следщ = следщ.sharedWildConstOf();
        }
        //printf("TypeNext::makeSharedWildConst() returns %p, %s\n", t, t.вТкст0());
        return t;
    }

    override final Тип makeMutable()
    {
        //printf("TypeNext::makeMutable() %p, %s\n", this, вТкст0());
        TypeNext t = cast(TypeNext)Тип.makeMutable();
        if (ty == Tsarray)
        {
            t.следщ = следщ.mutableOf();
        }
        //printf("TypeNext::makeMutable() returns %p, %s\n", t, t.вТкст0());
        return t;
    }

    override MATCH constConv(Тип to)
    {
        //printf("TypeNext::constConv from = %s, to = %s\n", вТкст0(), to.вТкст0());
        if (равен(to))
            return MATCH.exact;

        if (!(ty == to.ty && MODimplicitConv(mod, to.mod)))
            return MATCH.nomatch;

        Тип tn = to.nextOf();
        if (!(tn && следщ.ty == tn.ty))
            return MATCH.nomatch;

        MATCH m;
        if (to.isConst()) // whole tail const conversion
        {
            // Recursive shared уровень check
            m = следщ.constConv(tn);
            if (m == MATCH.exact)
                m = MATCH.constant;
        }
        else
        {
            //printf("\tnext => %s, to.следщ => %s\n", следщ.вТкст0(), tn.вТкст0());
            m = следщ.равен(tn) ? MATCH.constant : MATCH.nomatch;
        }
        return m;
    }

    override final MOD deduceWild(Тип t, бул isRef)
    {
        if (ty == Tfunction)
            return 0;

        ббайт wm;

        Тип tn = t.nextOf();
        if (!isRef && (ty == Tarray || ty == Tpointer) && tn)
        {
            wm = следщ.deduceWild(tn, да);
            if (!wm)
                wm = Тип.deduceWild(t, да);
        }
        else
        {
            wm = Тип.deduceWild(t, isRef);
            if (!wm && tn)
                wm = следщ.deduceWild(tn, да);
        }

        return wm;
    }

    final проц transitive()
    {
        /* Invoke transitivity of тип attributes
         */
        следщ = следщ.addMod(mod);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeBasic : Тип
{
    ткст0 dstring;
    бцел flags;

    this(TY ty)
    {
        super(ty);
        ткст0 d;
        бцел flags = 0;
        switch (ty)
        {
        case Tvoid:
            d = Сема2.вТкст0(ТОК2.void_);
            break;

        case Tint8:
            d = Сема2.вТкст0(ТОК2.int8);
            flags |= TFlags.integral;
            break;

        case Tuns8:
            d = Сема2.вТкст0(ТОК2.uns8);
            flags |= TFlags.integral | TFlags.unsigned;
            break;

        case Tint16:
            d = Сема2.вТкст0(ТОК2.int16);
            flags |= TFlags.integral;
            break;

        case Tuns16:
            d = Сема2.вТкст0(ТОК2.uns16);
            flags |= TFlags.integral | TFlags.unsigned;
            break;

        case Tint32:
            d = Сема2.вТкст0(ТОК2.int32);
            flags |= TFlags.integral;
            break;

        case Tuns32:
            d = Сема2.вТкст0(ТОК2.uns32);
            flags |= TFlags.integral | TFlags.unsigned;
            break;

        case Tfloat32:
            d = Сема2.вТкст0(ТОК2.float32);
            flags |= TFlags.floating | TFlags.real_;
            break;

        case Tint64:
            d = Сема2.вТкст0(ТОК2.int64);
            flags |= TFlags.integral;
            break;

        case Tuns64:
            d = Сема2.вТкст0(ТОК2.uns64);
            flags |= TFlags.integral | TFlags.unsigned;
            break;

        case Tint128:
            d = Сема2.вТкст0(ТОК2.int128);
            flags |= TFlags.integral;
            break;

        case Tuns128:
            d = Сема2.вТкст0(ТОК2.uns128);
            flags |= TFlags.integral | TFlags.unsigned;
            break;

        case Tfloat64:
            d = Сема2.вТкст0(ТОК2.float64);
            flags |= TFlags.floating | TFlags.real_;
            break;

        case Tfloat80:
            d = Сема2.вТкст0(ТОК2.float80);
            flags |= TFlags.floating | TFlags.real_;
            break;

        case Timaginary32:
            d = Сема2.вТкст0(ТОК2.imaginary32);
            flags |= TFlags.floating | TFlags.imaginary;
            break;

        case Timaginary64:
            d = Сема2.вТкст0(ТОК2.imaginary64);
            flags |= TFlags.floating | TFlags.imaginary;
            break;

        case Timaginary80:
            d = Сема2.вТкст0(ТОК2.imaginary80);
            flags |= TFlags.floating | TFlags.imaginary;
            break;

        case Tcomplex32:
            d = Сема2.вТкст0(ТОК2.complex32);
            flags |= TFlags.floating | TFlags.complex;
            break;

        case Tcomplex64:
            d = Сема2.вТкст0(ТОК2.complex64);
            flags |= TFlags.floating | TFlags.complex;
            break;

        case Tcomplex80:
            d = Сема2.вТкст0(ТОК2.complex80);
            flags |= TFlags.floating | TFlags.complex;
            break;

        case Tbool:
            d = "бул";
            flags |= TFlags.integral | TFlags.unsigned;
            break;

        case Tchar:
            d = Сема2.вТкст0(ТОК2.char_);
            flags |= TFlags.integral | TFlags.unsigned | TFlags.char_;
            break;

        case Twchar:
            d = Сема2.вТкст0(ТОК2.wchar_);
            flags |= TFlags.integral | TFlags.unsigned | TFlags.char_;
            break;

        case Tdchar:
            d = Сема2.вТкст0(ТОК2.dchar_);
            flags |= TFlags.integral | TFlags.unsigned | TFlags.char_;
            break;

        default:
            assert(0);
        }
        this.dstring = d;
        this.flags = flags;
        merge(this);
    }

    override ткст0 вид() 
    {
        return dstring;
    }

    override Тип syntaxCopy()
    {
        // No semantic analysis done on basic types, no need to копируй
        return this;
    }

    override d_uns64 size(ref Место место)
    {
        бцел size;
        //printf("TypeBasic::size()\n");
        switch (ty)
        {
        case Tint8:
        case Tuns8:
            size = 1;
            break;

        case Tint16:
        case Tuns16:
            size = 2;
            break;

        case Tint32:
        case Tuns32:
        case Tfloat32:
        case Timaginary32:
            size = 4;
            break;

        case Tint64:
        case Tuns64:
        case Tfloat64:
        case Timaginary64:
            size = 8;
            break;

        case Tfloat80:
        case Timaginary80:
            size = target.realsize;
            break;

        case Tcomplex32:
            size = 8;
            break;

        case Tcomplex64:
        case Tint128:
        case Tuns128:
            size = 16;
            break;

        case Tcomplex80:
            size = target.realsize * 2;
            break;

        case Tvoid:
            //size = Тип::size();      // error message
            size = 1;
            break;

        case Tbool:
            size = 1;
            break;

        case Tchar:
            size = 1;
            break;

        case Twchar:
            size = 2;
            break;

        case Tdchar:
            size = 4;
            break;

        default:
            assert(0);
        }
        //printf("TypeBasic::size() = %d\n", size);
        return size;
    }

    override бцел alignsize()
    {
        return target.alignsize(this);
    }

    override бул isintegral()
    {
        //printf("TypeBasic::isintegral('%s') x%x\n", вТкст0(), flags);
        return (flags & TFlags.integral) != 0;
    }

    override бул isfloating() 
    {
        return (flags & TFlags.floating) != 0;
    }

    override бул isreal() 
    {
        return (flags & TFlags.real_) != 0;
    }

    override бул isimaginary() 
    {
        return (flags & TFlags.imaginary) != 0;
    }

    override бул iscomplex() 
    {
        return (flags & TFlags.complex) != 0;
    }

    override бул isscalar() 
    {
        return (flags & (TFlags.integral | TFlags.floating)) != 0;
    }

    override бул isunsigned() 
    {
        return (flags & TFlags.unsigned) != 0;
    }

    override бул ischar() 
    {
        return (flags & TFlags.char_) != 0;
    }

    override MATCH implicitConvTo(Тип to)
    {
        //printf("TypeBasic::implicitConvTo(%s) from %s\n", to.вТкст0(), вТкст0());
        if (this == to)
            return MATCH.exact;

        if (ty == to.ty)
        {
            if (mod == to.mod)
                return MATCH.exact;
            else if (MODimplicitConv(mod, to.mod))
                return MATCH.constant;
            else if (!((mod ^ to.mod) & MODFlags.shared_)) // for wild matching
                return MATCH.constant;
            else
                return MATCH.convert;
        }

        if (ty == Tvoid || to.ty == Tvoid)
            return MATCH.nomatch;
        if (to.ty == Tbool)
            return MATCH.nomatch;

        TypeBasic tob;
        if (to.ty == Tvector && to.deco)
        {
            TypeVector tv = cast(TypeVector)to;
            tob = tv.elementType();
        }
        else if (auto te = to.isTypeEnum())
        {
            EnumDeclaration ed = te.sym;
            if (ed.isSpecial())
            {
                /* Special enums that allow implicit conversions to them
                 * with a MATCH.convert
                 */
                tob = to.toBasetype().isTypeBasic();
            }
            else
                return MATCH.nomatch;
        }
        else
            tob = to.isTypeBasic();
        if (!tob)
            return MATCH.nomatch;

        if (flags & TFlags.integral)
        {
            // Disallow implicit conversion of integers to imaginary or complex
            if (tob.flags & (TFlags.imaginary | TFlags.complex))
                return MATCH.nomatch;

            // If converting from integral to integral
            if (tob.flags & TFlags.integral)
            {
                d_uns64 sz = size(Место.initial);
                d_uns64 tosz = tob.size(Место.initial);

                /* Can't convert to smaller size
                 */
                if (sz > tosz)
                    return MATCH.nomatch;
                /* Can't change sign if same size
                 */
                //if (sz == tosz && (flags ^ tob.flags) & TFlags.unsigned)
                //    return MATCH.nomatch;
            }
        }
        else if (flags & TFlags.floating)
        {
            // Disallow implicit conversion of floating point to integer
            if (tob.flags & TFlags.integral)
                return MATCH.nomatch;

            assert(tob.flags & TFlags.floating || to.ty == Tvector);

            // Disallow implicit conversion from complex to non-complex
            if (flags & TFlags.complex && !(tob.flags & TFlags.complex))
                return MATCH.nomatch;

            // Disallow implicit conversion of real or imaginary to complex
            if (flags & (TFlags.real_ | TFlags.imaginary) && tob.flags & TFlags.complex)
                return MATCH.nomatch;

            // Disallow implicit conversion to-from real and imaginary
            if ((flags & (TFlags.real_ | TFlags.imaginary)) != (tob.flags & (TFlags.real_ | TFlags.imaginary)))
                return MATCH.nomatch;
        }
        return MATCH.convert;
    }

    override бул isZeroInit(ref Место место)
    {
        switch (ty)
        {
        case Tchar:
        case Twchar:
        case Tdchar:
        case Timaginary32:
        case Timaginary64:
        case Timaginary80:
        case Tfloat32:
        case Tfloat64:
        case Tfloat80:
        case Tcomplex32:
        case Tcomplex64:
        case Tcomplex80:
            return нет; // no
        default:
            return да; // yes
        }
    }

    // For eliminating dynamic_cast
    override TypeBasic isTypeBasic()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * The basetype must be one of:
 *   byte[16],ббайт[16],short[8],ushort[8],цел[4],бцел[4],long[2],бдол[2],float[4],double[2]
 * For AVX:
 *   byte[32],ббайт[32],short[16],ushort[16],цел[8],бцел[8],long[4],бдол[4],float[8],double[4]
 */
 final class TypeVector : Тип
{
    Тип basetype;

    this(Тип basetype)
    {
        super(Tvector);
        this.basetype = basetype;
    }

    static TypeVector создай(Тип basetype)
    {
        return new TypeVector(basetype);
    }

    override ткст0 вид() 
    {
        return "vector";
    }

    override Тип syntaxCopy()
    {
        return new TypeVector(basetype.syntaxCopy());
    }

    override d_uns64 size(ref Место место)
    {
        return basetype.size();
    }

    override бцел alignsize()
    {
        return cast(бцел)basetype.size();
    }

    override бул isintegral()
    {
        //printf("TypeVector::isintegral('%s') x%x\n", вТкст0(), flags);
        return basetype.nextOf().isintegral();
    }

    override бул isfloating()
    {
        return basetype.nextOf().isfloating();
    }

    override бул isscalar()
    {
        return basetype.nextOf().isscalar();
    }

    override бул isunsigned()
    {
        return basetype.nextOf().isunsigned();
    }

    override бул isBoolean() 
    {
        return нет;
    }

    override MATCH implicitConvTo(Тип to)
    {
        //printf("TypeVector::implicitConvTo(%s) from %s\n", to.вТкст0(), вТкст0());
        if (this == to)
            return MATCH.exact;
        if (ty == to.ty)
            return MATCH.convert;
        return MATCH.nomatch;
    }

    override Выражение defaultInitLiteral(ref Место место)
    {
        //printf("TypeVector::defaultInitLiteral()\n");
        assert(basetype.ty == Tsarray);
        Выражение e = basetype.defaultInitLiteral(место);
        auto ve = new VectorExp(место, e, this);
        ve.тип = this;
        ve.dim = cast(цел)(basetype.size(место) / elementType().size(место));
        return ve;
    }

    TypeBasic elementType()
    {
        assert(basetype.ty == Tsarray);
        TypeSArray t = cast(TypeSArray)basetype;
        TypeBasic tb = t.nextOf().isTypeBasic();
        assert(tb);
        return tb;
    }

    override бул isZeroInit(ref Место место)
    {
        return basetype.isZeroInit(место);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 abstract class TypeArray : TypeNext
{
    final this(TY ty, Тип следщ)
    {
        super(ty, следщ);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * Static массив, one with a fixed dimension
 */
 final class TypeSArray : TypeArray
{
    Выражение dim;

    this(Тип t, Выражение dim)
    {
        super(Tsarray, t);
        //printf("TypeSArray(%s)\n", dim.вТкст0());
        this.dim = dim;
    }

    override ткст0 вид() 
    {
        return "sarray";
    }

    override Тип syntaxCopy()
    {
        Тип t = следщ.syntaxCopy();
        Выражение e = dim.syntaxCopy();
        t = new TypeSArray(t, e);
        t.mod = mod;
        return t;
    }

    override d_uns64 size(ref Место место)
    {
        //printf("TypeSArray::size()\n");
        const n = numberOfElems(место);
        const elemsize = baseElemOf().size(место);
        бул overflow = нет;
        const sz = mulu(n, elemsize, overflow);
        if (overflow || sz >= бцел.max)
        {
            if (elemsize != SIZE_INVALID && n != бцел.max)
                выведиОшибку(место, "static массив `%s` size overflowed to %lld", вТкст0(), cast(long)sz);
            return SIZE_INVALID;
        }
        return sz;
    }

    override бцел alignsize()
    {
        return следщ.alignsize();
    }

    override бул isString()
    {
        TY nty = следщ.toBasetype().ty;
        return nty == Tchar || nty == Twchar || nty == Tdchar;
    }

    override бул isZeroInit(ref Место место)
    {
        return следщ.isZeroInit(место);
    }

    override structalign_t alignment()
    {
        return следщ.alignment();
    }

    override MATCH constConv(Тип to)
    {
        if (auto tsa = to.isTypeSArray())
        {
            if (!dim.равен(tsa.dim))
                return MATCH.nomatch;
        }
        return TypeNext.constConv(to);
    }

    override MATCH implicitConvTo(Тип to)
    {
        //printf("TypeSArray::implicitConvTo(to = %s) this = %s\n", to.вТкст0(), вТкст0());
        if (auto ta = to.isTypeDArray())
        {
            if (!MODimplicitConv(следщ.mod, ta.следщ.mod))
                return MATCH.nomatch;

            /* Allow conversion to проц[]
             */
            if (ta.следщ.ty == Tvoid)
            {
                return MATCH.convert;
            }

            MATCH m = следщ.constConv(ta.следщ);
            if (m > MATCH.nomatch)
            {
                return MATCH.convert;
            }
            return MATCH.nomatch;
        }
        if (auto tsa = to.isTypeSArray())
        {
            if (this == to)
                return MATCH.exact;

            if (dim.равен(tsa.dim))
            {
                /* Since static arrays are значение types, allow
                 * conversions from const elements to non-const
                 * ones, just like we allow conversion from const цел
                 * to цел.
                 */
                MATCH m = следщ.implicitConvTo(tsa.следщ);
                if (m >= MATCH.constant)
                {
                    if (mod != to.mod)
                        m = MATCH.constant;
                    return m;
                }
            }
        }
        return MATCH.nomatch;
    }

    override Выражение defaultInitLiteral(ref Место место)
    {
        static if (LOGDEFAULTINIT)
        {
            printf("TypeSArray::defaultInitLiteral() '%s'\n", вТкст0());
        }
        т_мера d = cast(т_мера)dim.toInteger();
        Выражение elementinit;
        if (следщ.ty == Tvoid)
            elementinit = tuns8.defaultInitLiteral(место);
        else
            elementinit = следщ.defaultInitLiteral(место);
        auto elements = new Выражения(d);
        foreach (ref e; *elements)
            e = null;
        auto ae = new ArrayLiteralExp(Место.initial, this, elementinit, elements);
        return ae;
    }

    override бул hasPointers()
    {
        /* Don't want to do this, because:
         *    struct S { T* массив[0]; }
         * may be a variable length struct.
         */
        //if (dim.toInteger() == 0)
        //    return нет;

        if (следщ.ty == Tvoid)
        {
            // Arrays of проц contain arbitrary данные, which may include pointers
            return да;
        }
        else
            return следщ.hasPointers();
    }

    override бул needsDestruction()
    {
        return следщ.needsDestruction();
    }

    /*********************************
     *
     */
    override бул needsNested()
    {
        return следщ.needsNested();
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * Dynamic массив, no dimension
 */
 final class TypeDArray : TypeArray
{
    this(Тип t)
    {
        super(Tarray, t);
        //printf("TypeDArray(t = %p)\n", t);
    }

    override ткст0 вид()
    {
        return "darray";
    }

    override Тип syntaxCopy()
    {
        Тип t = следщ.syntaxCopy();
        if (t == следщ)
            t = this;
        else
        {
            t = new TypeDArray(t);
            t.mod = mod;
        }
        return t;
    }

    override d_uns64 size(ref Место место)
    {
        //printf("TypeDArray::size()\n");
        return target.ptrsize * 2;
    }

    override бцел alignsize() 
    {
        // A DArray consists of two ptr-sized values, so align it on pointer size
        // boundary
        return target.ptrsize;
    }

    override бул isString()
    {
        TY nty = следщ.toBasetype().ty;
        return nty == Tchar || nty == Twchar || nty == Tdchar;
    }

    override бул isZeroInit(ref Место место)
    {
        return да;
    }

    override бул isBoolean() 
    {
        return да;
    }

    override MATCH implicitConvTo(Тип to)
    {
        //printf("TypeDArray::implicitConvTo(to = %s) this = %s\n", to.вТкст0(), вТкст0());
        if (равен(to))
            return MATCH.exact;

        if (auto ta = to.isTypeDArray())
        {
            if (!MODimplicitConv(следщ.mod, ta.следщ.mod))
                return MATCH.nomatch; // not const-compatible

            /* Allow conversion to проц[]
             */
            if (следщ.ty != Tvoid && ta.следщ.ty == Tvoid)
            {
                return MATCH.convert;
            }

            MATCH m = следщ.constConv(ta.следщ);
            if (m > MATCH.nomatch)
            {
                if (m == MATCH.exact && mod != to.mod)
                    m = MATCH.constant;
                return m;
            }
        }
        return Тип.implicitConvTo(to);
    }

    override бул hasPointers() 
    {
        return да;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeAArray : TypeArray
{
    Тип index;     // ключ тип
    Место место;
    Scope* sc;

    this(Тип t, Тип index)
    {
        super(Taarray, t);
        this.index = index;
    }

    static TypeAArray создай(Тип t, Тип index)
    {
        return new TypeAArray(t, index);
    }

    override ткст0 вид() 
    {
        return "aarray";
    }

    override Тип syntaxCopy()
    {
        Тип t = следщ.syntaxCopy();
        Тип ti = index.syntaxCopy();
        if (t == следщ && ti == index)
            t = this;
        else
        {
            t = new TypeAArray(t, ti);
            t.mod = mod;
        }
        return t;
    }

    override d_uns64 size(ref Место место)
    {
        return target.ptrsize;
    }

    override бул isZeroInit(ref Место место)
    {
        return да;
    }

    override бул isBoolean() 
    {
        return да;
    }

    override бул hasPointers() 
    {
        return да;
    }

    override MATCH implicitConvTo(Тип to)
    {
        //printf("TypeAArray::implicitConvTo(to = %s) this = %s\n", to.вТкст0(), вТкст0());
        if (равен(to))
            return MATCH.exact;

        if (auto ta = to.isTypeAArray())
        {
            if (!MODimplicitConv(следщ.mod, ta.следщ.mod))
                return MATCH.nomatch; // not const-compatible

            if (!MODimplicitConv(index.mod, ta.index.mod))
                return MATCH.nomatch; // not const-compatible

            MATCH m = следщ.constConv(ta.следщ);
            MATCH mi = index.constConv(ta.index);
            if (m > MATCH.nomatch && mi > MATCH.nomatch)
            {
                return MODimplicitConv(mod, to.mod) ? MATCH.constant : MATCH.nomatch;
            }
        }
        return Тип.implicitConvTo(to);
    }

    override MATCH constConv(Тип to)
    {
        if (auto taa = to.isTypeAArray())
        {
            MATCH mindex = index.constConv(taa.index);
            MATCH mkey = следщ.constConv(taa.следщ);
            // Pick the worst match
            return mkey < mindex ? mkey : mindex;
        }
        return Тип.constConv(to);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypePointer : TypeNext
{
    this(Тип t)
    {
        super(Tpointer, t);
    }

    static TypePointer создай(Тип t)
    {
        return new TypePointer(t);
    }

    override ткст0 вид() 
    {
        return "pointer";
    }

    override Тип syntaxCopy()
    {
        Тип t = следщ.syntaxCopy();
        if (t == следщ)
            t = this;
        else
        {
            t = new TypePointer(t);
            t.mod = mod;
        }
        return t;
    }

    override d_uns64 size(ref Место место)
    {
        return target.ptrsize;
    }

    override MATCH implicitConvTo(Тип to)
    {
        //printf("TypePointer::implicitConvTo(to = %s) %s\n", to.вТкст0(), вТкст0());
        if (равен(to))
            return MATCH.exact;

        if (следщ.ty == Tfunction)
        {
            if (auto tp = to.isTypePointer())
            {
                if (tp.следщ.ty == Tfunction)
                {
                    if (следщ.равен(tp.следщ))
                        return MATCH.constant;

                    if (следщ.covariant(tp.следщ) == 1)
                    {
                        Тип tret = this.следщ.nextOf();
                        Тип toret = tp.следщ.nextOf();
                        if (tret.ty == Tclass && toret.ty == Tclass)
                        {
                            /* https://issues.dlang.org/show_bug.cgi?ид=10219
                             * Check covariant interface return with смещение tweaking.
                             * interface I {}
                             * class C : Object, I {}
                             * I function() dg = function C() {}    // should be error
                             */
                            цел смещение = 0;
                            if (toret.isBaseOf(tret, &смещение) && смещение != 0)
                                return MATCH.nomatch;
                        }
                        return MATCH.convert;
                    }
                }
                else if (tp.следщ.ty == Tvoid)
                {
                    // Allow conversions to ук
                    return MATCH.convert;
                }
            }
            return MATCH.nomatch;
        }
        else if (auto tp = to.isTypePointer())
        {
            assert(tp.следщ);

            if (!MODimplicitConv(следщ.mod, tp.следщ.mod))
                return MATCH.nomatch; // not const-compatible

            /* Alloc conversion to ук
             */
            if (следщ.ty != Tvoid && tp.следщ.ty == Tvoid)
            {
                return MATCH.convert;
            }

            MATCH m = следщ.constConv(tp.следщ);
            if (m > MATCH.nomatch)
            {
                if (m == MATCH.exact && mod != to.mod)
                    m = MATCH.constant;
                return m;
            }
        }
        return MATCH.nomatch;
    }

    override MATCH constConv(Тип to)
    {
        if (следщ.ty == Tfunction)
        {
            if (to.nextOf() && следщ.равен((cast(TypeNext)to).следщ))
                return Тип.constConv(to);
            else
                return MATCH.nomatch;
        }
        return TypeNext.constConv(to);
    }

    override бул isscalar() 
    {
        return да;
    }

    override бул isZeroInit(ref Место место)
    {
        return да;
    }

    override бул hasPointers() 
    {
        return да;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeReference : TypeNext
{
    this(Тип t)
    {
        super(Treference, t);
        // BUG: what about references to static arrays?
    }

    override ткст0 вид() 
    {
        return "reference";
    }

    override Тип syntaxCopy()
    {
        Тип t = следщ.syntaxCopy();
        if (t == следщ)
            t = this;
        else
        {
            t = new TypeReference(t);
            t.mod = mod;
        }
        return t;
    }

    override d_uns64 size(ref Место место)
    {
        return target.ptrsize;
    }

    override бул isZeroInit(ref Место место)
    {
        return да;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

enum RET : цел
{
    regs         = 1,    // returned in registers
    stack        = 2,    // returned on stack
}

enum TRUST : цел
{
    default_   = 0,
    system     = 1,    // @system (same as TRUST.default)
    trusted    = 2,    //
    safe       = 3,    // 
}

enum TRUSTformat : цел
{
    TRUSTformatDefault,     // do not emit @system when trust == TRUST.default_
    TRUSTformatSystem,      // emit @system when trust == TRUST.default_
}

alias  TRUSTformat.TRUSTformatDefault TRUSTformatDefault;
alias  TRUSTformat.TRUSTformatSystem TRUSTformatSystem;

enum PURE : цел
{
    impure      = 0,    // not  at all
    fwdref      = 1,    // it's , but not known which уровень yet
    weak        = 2,    // no mutable globals are читай or written
    const_      = 3,    // parameters are values or const
    strong      = 4,    // parameters are values or const
}

/***********************************************************
 */
 final class TypeFunction : TypeNext
{
    // .следщ is the return тип

    СписокПараметров parameterList;   // function parameters

    бул isnothrow;             // да: 
    бул isnogc;                // да: is 
    бул isproperty;            // can be called without parentheses
    бул isref;                 // да: returns a reference
    бул isreturn;              // да: 'this' is returned by ref
    бул isscope;               // да: 'this' is scope
    бул isreturninferred;      // да: 'this' is return from inference
    бул isscopeinferred;       // да: 'this' is scope from inference
    бул islive;                // is @live
    LINK компонаж;               // calling convention
    TRUST trust;                // уровень of trust
    PURE purity = PURE.impure;
    ббайт iswild;               // bit0: inout on парамы, bit1: inout on qualifier
    Выражения* fargs;         // function arguments
    цел inuse;
    бул incomplete;            // return тип or default arguments removed

    this(СписокПараметров pl, Тип treturn, LINK компонаж, КлассХранения stc = 0)
    {
        super(Tfunction, treturn);
        //if (!treturn) *(сим*)0=0;
        //    assert(treturn);
        assert(ВарАрг.none <= pl.varargs && pl.varargs <= ВарАрг.typesafe);
        this.parameterList = pl;
        this.компонаж = компонаж;

        if (stc & STC.pure_)
            this.purity = PURE.fwdref;
        if (stc & STC.nothrow_)
            this.isnothrow = да;
        if (stc & STC.nogc)
            this.isnogc = да;
        if (stc & STC.property)
            this.isproperty = да;
        if (stc & STC.live)
            this.islive = да;

        if (stc & STC.ref_)
            this.isref = да;
        if (stc & STC.return_)
            this.isreturn = да;
        if (stc & STC.returninferred)
            this.isreturninferred = да;
        if (stc & STC.scope_)
            this.isscope = да;
        if (stc & STC.scopeinferred)
            this.isscopeinferred = да;

        this.trust = TRUST.default_;
        if (stc & STC.safe)
            this.trust = TRUST.safe;
        if (stc & STC.system)
            this.trust = TRUST.system;
        if (stc & STC.trusted)
            this.trust = TRUST.trusted;
    }

    static TypeFunction создай(Параметры* parameters, Тип treturn, ВарАрг varargs, LINK компонаж, КлассХранения stc = 0)
    {
        return new TypeFunction(СписокПараметров(parameters, varargs), treturn, компонаж, stc);
    }

    override ткст0 вид() 
    {
        return "function";
    }

    override Тип syntaxCopy()
    {
        Тип treturn = следщ ? следщ.syntaxCopy() : null;
        Параметры* парамы = Параметр2.arraySyntaxCopy(parameterList.parameters);
        auto t = new TypeFunction(СписокПараметров(парамы, parameterList.varargs), treturn, компонаж);
        t.mod = mod;
        t.isnothrow = isnothrow;
        t.isnogc = isnogc;
        t.purity = purity;
        t.isproperty = isproperty;
        t.isref = isref;
        t.isreturn = isreturn;
        t.isscope = isscope;
        t.isreturninferred = isreturninferred;
        t.isscopeinferred = isscopeinferred;
        t.iswild = iswild;
        t.trust = trust;
        t.fargs = fargs;
        return t;
    }

    /********************************************
     * Set 'purity' field of 'this'.
     * Do this lazily, as the параметр types might be forward referenced.
     */
    проц purityLevel()
    {
        TypeFunction tf = this;
        if (tf.purity != PURE.fwdref)
            return;

        /* Determine purity уровень based on mutability of t
         * and whether it is a 'ref' тип or not.
         */
        static PURE purityOfType(бул isref, Тип t)
        {
            if (isref)
            {
                if (t.mod & MODFlags.immutable_)
                    return PURE.strong;
                if (t.mod & (MODFlags.const_ | MODFlags.wild))
                    return PURE.const_;
                return PURE.weak;
            }

            t = t.baseElemOf();

            if (!t.hasPointers() || t.mod & MODFlags.immutable_)
                return PURE.strong;

            /* Accept const(T)[] and const(T)* as being strongly 
             */
            if (t.ty == Tarray || t.ty == Tpointer)
            {
                Тип tn = t.nextOf().toBasetype();
                if (tn.mod & MODFlags.immutable_)
                    return PURE.strong;
                if (tn.mod & (MODFlags.const_ | MODFlags.wild))
                    return PURE.const_;
            }

            /* The rest of this is too strict; fix later.
             * For example, the only pointer члены of a struct may be const,
             * which would maintain strong purity.
             * (Just like for dynamic arrays and pointers above.)
             */
            if (t.mod & (MODFlags.const_ | MODFlags.wild))
                return PURE.const_;

            /* Should catch delegates and function pointers, and fold in their purity
             */
            return PURE.weak;
        }

        purity = PURE.strong; // assume strong until something weakens it

        /* Evaluate what вид of purity based on the modifiers for the parameters
         */
        const dim = tf.parameterList.length;
    Lloop: foreach (i; new бцел[0 .. dim])
        {
            Параметр2 fparam = tf.parameterList[i];
            Тип t = fparam.тип;
            if (!t)
                continue;

            if (fparam.классХранения & (STC.lazy_ | STC.out_))
            {
                purity = PURE.weak;
                break;
            }
            switch (purityOfType((fparam.классХранения & STC.ref_) != 0, t))
            {
                case PURE.weak:
                    purity = PURE.weak;
                    break Lloop; // since PURE.weak, no need to check further

                case PURE.const_:
                    purity = PURE.const_;
                    continue;

                case PURE.strong:
                    continue;

                default:
                    assert(0);
            }
        }

        if (purity > PURE.weak && tf.nextOf())
        {
            /* Adjust purity based on mutability of return тип.
             * https://issues.dlang.org/show_bug.cgi?ид=15862
             */
            const purity2 = purityOfType(tf.isref, tf.nextOf());
            if (purity2 < purity)
                purity = purity2;
        }
        tf.purity = purity;
    }

    /********************************************
     * Return да if there are lazy parameters.
     */
    бул hasLazyParameters()
    {
        т_мера dim = parameterList.length;
        for (т_мера i = 0; i < dim; i++)
        {
            Параметр2 fparam = parameterList[i];
            if (fparam.классХранения & STC.lazy_)
                return да;
        }
        return нет;
    }

    /*******************************
     * Check for `extern (D) U func(T t, ...)` variadic function тип,
     * which has `_arguments[]` added as the first argument.
     * Возвращает:
     *  да if D-style variadic
     */
    бул isDstyleVariadic()   
    {
        return компонаж == LINK.d && parameterList.varargs == ВарАрг.variadic;
    }

    /***************************
     * Examine function signature for параметр p and see if
     * the значение of p can 'ýñêàïèðóé' the scope of the function.
     * This is useful to minimize the needed annotations for the parameters.
     * Параметры:
     *  tthis = тип of `this` параметр, null if none
     *  p = параметр to this function
     * Возвращает:
     *  да if escapes via assignment to глоб2 or through a параметр
     */
    бул parameterEscapes(Тип tthis, Параметр2 p)
    {
        /* Scope parameters do not ýñêàïèðóé.
         * Allow 'lazy' to imply 'scope' -
         * lazy parameters can be passed along
         * as lazy parameters to the следщ function, but that isn't
         * escaping.
         */
        if (parameterStorageClass(tthis, p) & (STC.scope_ | STC.lazy_))
            return нет;
        return да;
    }

    /************************************
     * Take the specified storage class for p,
     * and use the function signature to infer whether
     * STC.scope_ and STC.return_ should be OR'd in.
     * (This will not affect the имя mangling.)
     * Параметры:
     *  tthis = тип of `this` параметр, null if none
     *  p = параметр to this function
     * Возвращает:
     *  storage class with STC.scope_ or STC.return_ OR'd in
     */
    КлассХранения parameterStorageClass(Тип tthis, Параметр2 p)
    {
        //printf("parameterStorageClass(p: %s)\n", p.вТкст0());
        auto stc = p.классХранения;
        if (!глоб2.парамы.vsafe)
            return stc;

        if (stc & (STC.scope_ | STC.return_ | STC.lazy_) || purity == PURE.impure)
            return stc;

        /* If haven't inferred the return тип yet, can't infer storage classes
         */
        if (!nextOf())
            return stc;

        purityLevel();

        // See if p can ýñêàïèðóé via any of the other parameters
        if (purity == PURE.weak)
        {
            // Check escaping through parameters
            const dim = parameterList.length;
            foreach ( i; new бцел[0 .. dim])
            {
                Параметр2 fparam = parameterList[i];
                if (fparam == p)
                    continue;
                Тип t = fparam.тип;
                if (!t)
                    continue;
                t = t.baseElemOf();
                if (t.isMutable() && t.hasPointers())
                {
                    if (fparam.классХранения & (STC.ref_ | STC.out_))
                    {
                    }
                    else if (t.ty == Tarray || t.ty == Tpointer)
                    {
                        Тип tn = t.nextOf().toBasetype();
                        if (!(tn.isMutable() && tn.hasPointers()))
                            continue;
                    }
                    return stc;
                }
            }

            // Check escaping through `this`
            if (tthis && tthis.isMutable())
            {
                auto tb = tthis.toBasetype();
                AggregateDeclaration ad;
                if (auto tc = tb.isTypeClass())
                    ad = tc.sym;
                else if (auto ts = tb.isTypeStruct())
                    ad = ts.sym;
                else
                    assert(0);
                foreach (VarDeclaration v; ad.fields)
                {
                    if (v.hasPointers())
                        return stc;
                }
            }
        }

        stc |= STC.scope_;

        /* Inferring STC.return_ here has нет positives
         * for  functions, producing spurious error messages
         * about escaping references.
         * Give up on it for now.
         */
        version (none)
        {
            Тип tret = nextOf().toBasetype();
            if (isref || tret.hasPointers())
            {
                /* The результат has references, so p could be escaping
                 * that way.
                 */
                stc |= STC.return_;
            }
        }

        return stc;
    }

    override Тип addStorageClass(КлассХранения stc)
    {
        //printf("addStorageClass(%llx) %d\n", stc, (stc & STC.scope_) != 0);
        TypeFunction t = Тип.addStorageClass(stc).toTypeFunction();
        if ((stc & STC.pure_ && !t.purity) ||
            (stc & STC.nothrow_ && !t.isnothrow) ||
            (stc & STC.nogc && !t.isnogc) ||
            (stc & STC.scope_ && !t.isscope) ||
            (stc & STC.safe && t.trust < TRUST.trusted))
        {
            // Klunky to change these
            auto tf = new TypeFunction(t.parameterList, t.следщ, t.компонаж, 0);
            tf.mod = t.mod;
            tf.fargs = fargs;
            tf.purity = t.purity;
            tf.isnothrow = t.isnothrow;
            tf.isnogc = t.isnogc;
            tf.isproperty = t.isproperty;
            tf.isref = t.isref;
            tf.isreturn = t.isreturn;
            tf.isscope = t.isscope;
            tf.isreturninferred = t.isreturninferred;
            tf.isscopeinferred = t.isscopeinferred;
            tf.trust = t.trust;
            tf.iswild = t.iswild;

            if (stc & STC.pure_)
                tf.purity = PURE.fwdref;
            if (stc & STC.nothrow_)
                tf.isnothrow = да;
            if (stc & STC.nogc)
                tf.isnogc = да;
            if (stc & STC.safe)
                tf.trust = TRUST.safe;
            if (stc & STC.scope_)
            {
                tf.isscope = да;
                if (stc & STC.scopeinferred)
                    tf.isscopeinferred = да;
            }

            tf.deco = tf.merge().deco;
            t = tf;
        }
        return t;
    }

    override Тип substWildTo(бцел)
    {
        if (!iswild && !(mod & MODFlags.wild))
            return this;

        // Substitude inout qualifier of function тип to mutable or const
        // would break тип system. Instead substitude inout to the most weak
        // qualifer - const.
        бцел m = MODFlags.const_;

        assert(следщ);
        Тип tret = следщ.substWildTo(m);
        Параметры* парамы = parameterList.parameters;
        if (mod & MODFlags.wild)
            парамы = parameterList.parameters.копируй();
        for (т_мера i = 0; i < парамы.dim; i++)
        {
            Параметр2 p = (*парамы)[i];
            Тип t = p.тип.substWildTo(m);
            if (t == p.тип)
                continue;
            if (парамы == parameterList.parameters)
                парамы = parameterList.parameters.копируй();
            (*парамы)[i] = new Параметр2(p.классХранения, t, null, null, null);
        }
        if (следщ == tret && парамы == parameterList.parameters)
            return this;

        // Similar to TypeFunction::syntaxCopy;
        auto t = new TypeFunction(СписокПараметров(парамы, parameterList.varargs), tret, компонаж);
        t.mod = ((mod & MODFlags.wild) ? (mod & ~MODFlags.wild) | MODFlags.const_ : mod);
        t.isnothrow = isnothrow;
        t.isnogc = isnogc;
        t.purity = purity;
        t.isproperty = isproperty;
        t.isref = isref;
        t.isreturn = isreturn;
        t.isscope = isscope;
        t.isreturninferred = isreturninferred;
        t.isscopeinferred = isscopeinferred;
        t.iswild = 0;
        t.trust = trust;
        t.fargs = fargs;
        return t.merge();
    }

    // arguments get specially formatted
    private ткст0 getParamError(Выражение arg, Параметр2 par)
    {
        if (глоб2.gag && !глоб2.парамы.showGaggedErrors)
            return null;
        // show qualification when вТкст0() is the same but types are different
        auto at = arg.тип.вТкст0();
        бул qual = !arg.тип.равен(par.тип) && strcmp(at, par.тип.вТкст0()) == 0;
        if (qual)
            at = arg.тип.toPrettyChars(да);
        БуфВыв буф;
        // only mention rvalue if it's relevant
        const rv = !arg.isLvalue() && par.классХранения & (STC.ref_ | STC.out_);
        буф.printf("cannot pass %sargument `%s` of тип `%s` to параметр `%s`",
            rv ? "rvalue ".ptr : "".ptr, arg.вТкст0(), at,
            parameterToChars(par, this, qual));
        return буф.extractChars();
    }

    private extern(D) ткст0 getMatchError(A...)(ткст0 format, A args)
    {
        if (глоб2.gag && !глоб2.парамы.showGaggedErrors)
            return null;
        БуфВыв буф;
        буф.printf(format, args);
        return буф.extractChars();
    }

    /********************************
     * 'args' are being matched to function 'this'
     * Determine match уровень.
     * Параметры:
     *      tthis = тип of `this` pointer, null if not member function
     *      args = массив of function arguments
     *      флаг = 1: performing a partial ordering match
     *      pMessage = address to store error message, or null
     *      sc = context
     * Возвращает:
     *      MATCHxxxx
     */
    extern (D) MATCH callMatch(Тип tthis, Выражение[] args, цел флаг = 0, сим** pMessage = null, Scope* sc = null)
    {
        //printf("TypeFunction::callMatch() %s\n", вТкст0());
        MATCH match = MATCH.exact; // assume exact match
        ббайт wildmatch = 0;

        if (tthis)
        {
            Тип t = tthis;
            if (t.toBasetype().ty == Tpointer)
                t = t.toBasetype().nextOf(); // change struct* to struct
            if (t.mod != mod)
            {
                if (MODimplicitConv(t.mod, mod))
                    match = MATCH.constant;
                else if ((mod & MODFlags.wild) && MODimplicitConv(t.mod, (mod & ~MODFlags.wild) | MODFlags.const_))
                {
                    match = MATCH.constant;
                }
                else
                    return MATCH.nomatch;
            }
            if (isWild())
            {
                if (t.isWild())
                    wildmatch |= MODFlags.wild;
                else if (t.isConst())
                    wildmatch |= MODFlags.const_;
                else if (t.isImmutable())
                    wildmatch |= MODFlags.immutable_;
                else
                    wildmatch |= MODFlags.mutable;
            }
        }

        т_мера nparams = parameterList.length;
        т_мера nargs = args.length;
        if (nargs > nparams)
        {
            if (parameterList.varargs == ВарАрг.none)
            {
                // suppress early exit if an error message is wanted,
                // so we can check any matching args are valid
                if (!pMessage)
                    goto Nomatch;
            }
            // too many args; no match
            match = MATCH.convert; // match ... with a "conversion" match уровень
        }

        for (т_мера u = 0; u < nargs; u++)
        {
            if (u >= nparams)
                break;
            Параметр2 p = parameterList[u];
            Выражение arg = args[u];
            assert(arg);
            Тип tprm = p.тип;
            Тип targ = arg.тип;

            if (!(p.классХранения & STC.lazy_ && tprm.ty == Tvoid && targ.ty != Tvoid))
            {
                бул isRef = (p.классХранения & (STC.ref_ | STC.out_)) != 0;
                wildmatch |= targ.deduceWild(tprm, isRef);
            }
        }
        if (wildmatch)
        {
            /* Calculate wild matching modifier
             */
            if (wildmatch & MODFlags.const_ || wildmatch & (wildmatch - 1))
                wildmatch = MODFlags.const_;
            else if (wildmatch & MODFlags.immutable_)
                wildmatch = MODFlags.immutable_;
            else if (wildmatch & MODFlags.wild)
                wildmatch = MODFlags.wild;
            else
            {
                assert(wildmatch & MODFlags.mutable);
                wildmatch = MODFlags.mutable;
            }
        }

        for (т_мера u = 0; u < nparams; u++)
        {
            MATCH m;

            Параметр2 p = parameterList[u];
            assert(p);
            if (u >= nargs)
            {
                if (p.defaultArg)
                    continue;
                // try typesafe variadics
                goto L1;
            }
            {
                Выражение arg = args[u];
                assert(arg);
                //printf("arg: %s, тип: %s\n", arg.вТкст0(), arg.тип.вТкст0());

                Тип targ = arg.тип;
                Тип tprm = wildmatch ? p.тип.substWildTo(wildmatch) : p.тип;

                if (p.классХранения & STC.lazy_ && tprm.ty == Tvoid && targ.ty != Tvoid)
                    m = MATCH.convert;
                else
                {
                    //printf("%s of тип %s implicitConvTo %s\n", arg.вТкст0(), targ.вТкст0(), tprm.вТкст0());
                    if (флаг)
                    {
                        // for partial ordering, значение is an irrelevant mockup, just look at the тип
                        m = targ.implicitConvTo(tprm);
                    }
                    else
                    {
                        const isRef = (p.классХранения & (STC.ref_ | STC.out_)) != 0;

                        StructDeclaration argStruct, prmStruct;

                        // first look for a копируй constructor
                        if (arg.isLvalue() && !isRef && targ.ty == Tstruct && tprm.ty == Tstruct)
                        {
                            // if the argument and the параметр are of the same unqualified struct тип
                            argStruct = (cast(TypeStruct)targ).sym;
                            prmStruct = (cast(TypeStruct)tprm).sym;
                        }

                        // check if the копируй constructor may be called to копируй the argument
                        if (argStruct && argStruct == prmStruct && argStruct.hasCopyCtor)
                        {
                            /* this is done by seeing if a call to the копируй constructor can be made:
                             *
                             * typeof(tprm) __copytmp;
                             * copytmp.__copyCtor(arg);
                             */
                            auto tmp = new VarDeclaration(arg.место, tprm, Идентификатор2.генерируйИд("__copytmp"), null);
                            tmp.класс_хранения = STC.rvalue | STC.temp | STC.ctfe;
                            tmp.dsymbolSemantic(sc);
                            Выражение ve = new VarExp(arg.место, tmp);
                            Выражение e = new DotIdExp(arg.место, ve, Id.ctor);
                            e = new CallExp(arg.место, e, arg);
                            //printf("e = %s\n", e.вТкст0());
                            if(.trySemantic(e, sc))
                                m = MATCH.exact;
                            else
                            {
                                m = MATCH.nomatch;
                                if (pMessage)
                                {
                                    БуфВыв буф;
                                    буф.printf("`struct %s` does not define a копируй constructor for `%s` to `%s` copies",
                                           argStruct.вТкст0(), targ.вТкст0(), tprm.вТкст0());
                                    *pMessage = буф.extractChars();
                                }
                                goto Nomatch;
                            }
                        }
                        else
                            m = arg.implicitConvTo(tprm);
                    }
                    //printf("match %d\n", m);
                }

                // Non-lvalues do not match ref or out parameters
                if (p.классХранения & (STC.ref_ | STC.out_))
                {
                    // https://issues.dlang.org/show_bug.cgi?ид=13783
                    // Don't use toBasetype() to handle enum types.
                    Тип ta = targ;
                    Тип tp = tprm;
                    //printf("fparam[%d] ta = %s, tp = %s\n", u, ta.вТкст0(), tp.вТкст0());

                    if (m && !arg.isLvalue())
                    {
                        if (p.классХранения & STC.out_)
                        {
                            if (pMessage) *pMessage = getParamError(arg, p);
                            goto Nomatch;
                        }

                        if (arg.op == ТОК2.string_ && tp.ty == Tsarray)
                        {
                            if (ta.ty != Tsarray)
                            {
                                Тип tn = tp.nextOf().castMod(ta.nextOf().mod);
                                dinteger_t dim = (cast(StringExp)arg).len;
                                ta = tn.sarrayOf(dim);
                            }
                        }
                        else if (arg.op == ТОК2.slice && tp.ty == Tsarray)
                        {
                            // Allow conversion from T[lwr .. upr] to ref T[upr-lwr]
                            if (ta.ty != Tsarray)
                            {
                                Тип tn = ta.nextOf();
                                dinteger_t dim = (cast(TypeSArray)tp).dim.toUInteger();
                                ta = tn.sarrayOf(dim);
                            }
                        }
                        else if (!глоб2.парамы.rvalueRefParam ||
                                 p.классХранения & STC.out_ ||
                                 !arg.тип.isCopyable())  // can't копируй to temp for ref параметр
                        {
                            if (pMessage) *pMessage = getParamError(arg, p);
                            goto Nomatch;
                        }
                        else
                        {
                            /* in functionParameters() we'll convert this
                             * rvalue into a temporary
                             */
                            m = MATCH.convert;
                        }
                    }

                    /* Find most derived alias this тип being matched.
                     * https://issues.dlang.org/show_bug.cgi?ид=15674
                     * Allow on both ref and out parameters.
                     */
                    while (1)
                    {
                        Тип tab = ta.toBasetype();
                        Тип tat = tab.aliasthisOf();
                        if (!tat || !tat.implicitConvTo(tprm))
                            break;
                        if (tat == tab)
                            break;
                        ta = tat;
                    }

                    /* A ref variable should work like a head-const reference.
                     * e.g. disallows:
                     *  ref T      <- an lvalue of const(T) argument
                     *  ref T[dim] <- an lvalue of const(T[dim]) argument
                     */
                    if (!ta.constConv(tp))
                    {
                        if (pMessage) *pMessage = getParamError(arg, p);
                        goto Nomatch;
                    }
                }
            }

            /* prefer matching the element тип rather than the массив
             * тип when more arguments are present with T[]...
             */
            if (parameterList.varargs == ВарАрг.typesafe && u + 1 == nparams && nargs > nparams)
                goto L1;

            //printf("\tm = %d\n", m);
            if (m == MATCH.nomatch) // if no match
            {
            L1:
                if (parameterList.varargs == ВарАрг.typesafe && u + 1 == nparams) // if last varargs param
                {
                    Тип tb = p.тип.toBasetype();
                    TypeSArray tsa;
                    dinteger_t sz;

                    switch (tb.ty)
                    {
                    case Tsarray:
                        tsa = cast(TypeSArray)tb;
                        sz = tsa.dim.toInteger();
                        if (sz != nargs - u)
                        {
                            if (pMessage)
                                // Windows (Vista) БуфВыв.vprintf issue? 2nd argument always нуль
                                //*pMessage = getMatchError("expected %d variadic argument(s), not %d", sz, nargs - u);
                            if (!глоб2.gag || глоб2.парамы.showGaggedErrors)
                            {
                                БуфВыв буф;
                                буф.printf("expected %d variadic argument(s)", sz);
                                буф.printf(", not %d", nargs - u);
                                *pMessage = буф.extractChars();
                            }
                            goto Nomatch;
                        }
                        goto case Tarray;
                    case Tarray:
                        {
                            TypeArray ta = cast(TypeArray)tb;
                            foreach (arg; args[u .. nargs])
                            {
                                assert(arg);

                                /* If lazy массив of delegates,
                                 * convert arg(s) to delegate(s)
                                 */
                                Тип tret = p.isLazyArray();
                                if (tret)
                                {
                                    if (ta.следщ.равен(arg.тип))
                                        m = MATCH.exact;
                                    else if (tret.toBasetype().ty == Tvoid)
                                        m = MATCH.convert;
                                    else
                                    {
                                        m = arg.implicitConvTo(tret);
                                        if (m == MATCH.nomatch)
                                            m = arg.implicitConvTo(ta.следщ);
                                    }
                                }
                                else
                                    m = arg.implicitConvTo(ta.следщ);

                                if (m == MATCH.nomatch)
                                {
                                    if (pMessage) *pMessage = getParamError(arg, p);
                                    goto Nomatch;
                                }
                                if (m < match)
                                    match = m;
                            }
                            goto Ldone;
                        }
                    case Tclass:
                        // Should see if there's a constructor match?
                        // Or just leave it ambiguous?
                        goto Ldone;

                    default:
                        break;
                    }
                }
                if (pMessage && u < nargs)
                    *pMessage = getParamError(args[u], p);
                else if (pMessage)
                    *pMessage = getMatchError("missing argument for параметр #%d: `%s`",
                        u + 1, parameterToChars(p, this, нет));
                goto Nomatch;
            }
            if (m < match)
                match = m; // pick worst match
        }

    Ldone:
        if (pMessage && !parameterList.varargs && nargs > nparams)
        {
            // all parameters had a match, but there are surplus args
            *pMessage = getMatchError("expected %d argument(s), not %d", nparams, nargs);
            goto Nomatch;
        }
        //printf("match = %d\n", match);
        return match;

    Nomatch:
        //printf("no match\n");
        return MATCH.nomatch;
    }

    extern (D) бул checkRetType(ref Место место)
    {
        Тип tb = следщ.toBasetype();
        if (tb.ty == Tfunction)
        {
            выведиОшибку(место, "functions cannot return a function");
            следщ = Тип.terror;
        }
        if (tb.ty == Ttuple)
        {
            выведиОшибку(место, "functions cannot return a кортеж");
            следщ = Тип.terror;
        }
        if (!isref && (tb.ty == Tstruct || tb.ty == Tsarray))
        {
            if (auto ts = tb.baseElemOf().isTypeStruct())
            {
                if (!ts.sym.члены)
                {
                    выведиОшибку(место, "functions cannot return opaque тип `%s` by значение", tb.вТкст0());
                    следщ = Тип.terror;
                }
            }
        }
        if (tb.ty == Terror)
            return да;
        return нет;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeDelegate : TypeNext
{
    // .следщ is a TypeFunction

    this(Тип t)
    {
        super(Tfunction, t);
        ty = Tdelegate;
    }

    static TypeDelegate создай(Тип t)
    {
        return new TypeDelegate(t);
    }

    override ткст0 вид() 
    {
        return "delegate";
    }

    override Тип syntaxCopy()
    {
        Тип t = следщ.syntaxCopy();
        if (t == следщ)
            t = this;
        else
        {
            t = new TypeDelegate(t);
            t.mod = mod;
        }
        return t;
    }

    override Тип addStorageClass(КлассХранения stc)
    {
        TypeDelegate t = cast(TypeDelegate)Тип.addStorageClass(stc);
        if (!глоб2.парамы.vsafe)
            return t;

        /* The rest is meant to add 'scope' to a delegate declaration if it is of the form:
         *  alias dg_t = ук delegate();
         *  scope dg_t dg = ...;
         */
        if(stc & STC.scope_)
        {
            auto n = t.следщ.addStorageClass(STC.scope_ | STC.scopeinferred);
            if (n != t.следщ)
            {
                t.следщ = n;
                t.deco = t.merge().deco; // mangling supposed to not be changed due to STC.scope_inferrred
            }
        }
        return t;
    }

    override d_uns64 size(ref Место место)
    {
        return target.ptrsize * 2;
    }

    override бцел alignsize() 
    {
        return target.ptrsize;
    }

    override MATCH implicitConvTo(Тип to)
    {
        //printf("TypeDelegate.implicitConvTo(this=%p, to=%p)\n", this, to);
        //printf("from: %s\n", вТкст0());
        //printf("to  : %s\n", to.вТкст0());
        if (this == to)
            return MATCH.exact;

        version (all)
        {
            // not allowing covariant conversions because it interferes with overriding
            if (to.ty == Tdelegate && this.nextOf().covariant(to.nextOf()) == 1)
            {
                Тип tret = this.следщ.nextOf();
                Тип toret = (cast(TypeDelegate)to).следщ.nextOf();
                if (tret.ty == Tclass && toret.ty == Tclass)
                {
                    /* https://issues.dlang.org/show_bug.cgi?ид=10219
                     * Check covariant interface return with смещение tweaking.
                     * interface I {}
                     * class C : Object, I {}
                     * I delegate() dg = delegate C() {}    // should be error
                     */
                    цел смещение = 0;
                    if (toret.isBaseOf(tret, &смещение) && смещение != 0)
                        return MATCH.nomatch;
                }
                return MATCH.convert;
            }
        }

        return MATCH.nomatch;
    }

    override бул isZeroInit(ref Место место)
    {
        return да;
    }

    override бул isBoolean() 
    {
        return да;
    }

    override бул hasPointers() 
    {
        return да;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/**
 * This is a shell containing a TraitsExp that can be
 * either resolved to a тип or to a symbol.
 *
 * The point is to allow AliasDeclarationY to use `__traits()`, see issue 7804.
 */
 final class TypeTraits : Тип
{
    Место место;
    /// The Выражение to resolve as тип or symbol.
    TraitsExp exp;
    /// After `typeSemantic` the symbol when `exp` doesn't represent a тип.
    ДСимвол sym;

    final this(ref Место место, TraitsExp exp)
    {
        super(Ttraits);
        this.место = место;
        this.exp = exp;
    }

    override Тип syntaxCopy()
    {
        TraitsExp te = cast(TraitsExp) exp.syntaxCopy();
        TypeTraits tt = new TypeTraits(место, te);
        tt.mod = mod;
        return tt;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }

    override d_uns64 size(ref Место место)
    {
        return SIZE_INVALID;
    }
}

/******
 * Implements mixin types.
 *
 * Semantic analysis will convert it to a real тип.
 */
 final class TypeMixin : Тип
{
    Место место;
    Выражения* exps;

    this(ref Место место, Выражения* exps)
    {
        super(Tmixin);
        this.место = место;
        this.exps = exps;
    }

    override ткст0 вид() 
    {
        return "mixin";
    }

    override Тип syntaxCopy()
    {
        return new TypeMixin(место, Выражение.arraySyntaxCopy(exps));
    }

   override ДСимвол toDsymbol(Scope* sc)
    {
        Тип t;
        Выражение e;
        ДСимвол s;
        resolve(this, место, sc, &e, &t, &s);
        if (t)
            s = t.toDsymbol(sc);
        else if (e)
            s = getDsymbol(e);

        return s;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 abstract class TypeQualified : Тип
{
    Место место;

    // массив of Идентификатор2 and TypeInstance,
    // representing идент.идент!tiargs.идент. ... etc.
    Объекты idents;

    final this(TY ty, Место место)
    {
        super(ty);
        this.место = место;
    }

    final проц syntaxCopyHelper(TypeQualified t)
    {
        //printf("TypeQualified::syntaxCopyHelper(%s) %s\n", t.вТкст0(), вТкст0());
        idents.устДим(t.idents.dim);
        for (т_мера i = 0; i < idents.dim; i++)
        {
            КорневойОбъект ид = t.idents[i];
            if (ид.динкаст() == ДИНКАСТ.дсимвол)
            {
                TemplateInstance ti = cast(TemplateInstance)ид;
                ti = cast(TemplateInstance)ti.syntaxCopy(null);
                ид = ti;
            }
            else if (ид.динкаст() == ДИНКАСТ.Выражение)
            {
                Выражение e = cast(Выражение)ид;
                e = e.syntaxCopy();
                ид = e;
            }
            else if (ид.динкаст() == ДИНКАСТ.тип)
            {
                Тип tx = cast(Тип)ид;
                tx = tx.syntaxCopy();
                ид = tx;
            }
            idents[i] = ид;
        }
    }

    final проц addIdent(Идентификатор2 идент)
    {
        idents.сунь(идент);
    }

    final проц addInst(TemplateInstance inst)
    {
        idents.сунь(inst);
    }

    final проц addIndex(КорневойОбъект e)
    {
        idents.сунь(e);
    }

    override d_uns64 size(ref Место место)
    {
        выведиОшибку(this.место, "size of тип `%s` is not known", вТкст0());
        return SIZE_INVALID;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeIdentifier : TypeQualified
{
    Идентификатор2 идент;

    // The symbol representing this идентификатор, before alias resolution
    ДСимвол originalSymbol;

    this(ref Место место, Идентификатор2 идент)
    {
        super(Tident, место);
        this.идент = идент;
    }

    override ткст0 вид() 
    {
        return "идентификатор";
    }

    override Тип syntaxCopy()
    {
        auto t = new TypeIdentifier(место, идент);
        t.syntaxCopyHelper(this);
        t.mod = mod;
        return t;
    }

    /*****************************************
     * See if тип resolves to a symbol, if so,
     * return that symbol.
     */
    override ДСимвол toDsymbol(Scope* sc)
    {
        //printf("TypeIdentifier::toDsymbol('%s')\n", вТкст0());
        if (!sc)
            return null;

        Тип t;
        Выражение e;
        ДСимвол s;
        resolve(this, место, sc, &e, &t, &s);
        if (t && t.ty != Tident)
            s = t.toDsymbol(sc);
        if (e)
            s = getDsymbol(e);

        return s;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * Similar to TypeIdentifier, but with a TemplateInstance as the root
 */
 final class TypeInstance : TypeQualified
{
    TemplateInstance tempinst;

    this(ref Место место, TemplateInstance tempinst)
    {
        super(Tinstance, место);
        this.tempinst = tempinst;
    }

    override ткст0 вид() 
    {
        return "instance";
    }

    override Тип syntaxCopy()
    {
        //printf("TypeInstance::syntaxCopy() %s, %d\n", вТкст0(), idents.dim);
        auto t = new TypeInstance(место, cast(TemplateInstance)tempinst.syntaxCopy(null));
        t.syntaxCopyHelper(this);
        t.mod = mod;
        return t;
    }

    override ДСимвол toDsymbol(Scope* sc)
    {
        Тип t;
        Выражение e;
        ДСимвол s;
        //printf("TypeInstance::semantic(%s)\n", вТкст0());
        resolve(this, место, sc, &e, &t, &s);
        if (t && t.ty != Tinstance)
            s = t.toDsymbol(sc);
        return s;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeTypeof : TypeQualified
{
    Выражение exp;
    цел inuse;

    this(ref Место место, Выражение exp)
    {
        super(Ttypeof, место);
        this.exp = exp;
    }

    override ткст0 вид() 
    {
        return "typeof";
    }

    override Тип syntaxCopy()
    {
        //printf("TypeTypeof::syntaxCopy() %s\n", вТкст0());
        auto t = new TypeTypeof(место, exp.syntaxCopy());
        t.syntaxCopyHelper(this);
        t.mod = mod;
        return t;
    }

    override ДСимвол toDsymbol(Scope* sc)
    {
        //printf("TypeTypeof::toDsymbol('%s')\n", вТкст0());
        Выражение e;
        Тип t;
        ДСимвол s;
        resolve(this, место, sc, &e, &t, &s);
        return s;
    }

    override d_uns64 size(ref Место место)
    {
        if (exp.тип)
            return exp.тип.size(место);
        else
            return TypeQualified.size(место);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeReturn : TypeQualified
{
    this(ref Место место)
    {
        super(Treturn, место);
    }

    override ткст0 вид() 
    {
        return "return";
    }

    override Тип syntaxCopy()
    {
        auto t = new TypeReturn(место);
        t.syntaxCopyHelper(this);
        t.mod = mod;
        return t;
    }

    override ДСимвол toDsymbol(Scope* sc)
    {
        Выражение e;
        Тип t;
        ДСимвол s;
        resolve(this, место, sc, &e, &t, &s);
        return s;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

// Whether alias this dependency is recursive or not.
enum AliasThisRec : цел
{
    no           = 0,    // no alias this recursion
    yes          = 1,    // alias this has recursive dependency
    fwdref       = 2,    // not yet known
    typeMask     = 3,    // mask to читай no/yes/fwdref
    tracing      = 0x4,  // mark in progress of implicitConvTo/deduceWild
    tracingDT    = 0x8,  // mark in progress of deduceType
}

/***********************************************************
 */
 final class TypeStruct : Тип
{
    StructDeclaration sym;
    AliasThisRec att = AliasThisRec.fwdref;
    CPPMANGLE cppmangle = CPPMANGLE.def;

    this(StructDeclaration sym)
    {
        super(Tstruct);
        this.sym = sym;
    }

    static TypeStruct создай(StructDeclaration sym)
    {
        return new TypeStruct(sym);
    }

    override ткст0 вид() 
    {
        return "struct";
    }

    override d_uns64 size(ref Место место)
    {
        return sym.size(место);
    }

    override бцел alignsize()
    {
        sym.size(Место.initial); // give error for forward references
        return sym.alignsize;
    }

    override Тип syntaxCopy()
    {
        return this;
    }

    override ДСимвол toDsymbol(Scope* sc)
    {
        return sym;
    }

    override structalign_t alignment()
    {
        if (sym.alignment == 0)
            sym.size(sym.место);
        return sym.alignment;
    }

    /***************************************
     * Use when we prefer the default инициализатор to be a literal,
     * rather than a глоб2 const variable.
     */
    override Выражение defaultInitLiteral(ref Место место)
    {
        static if (LOGDEFAULTINIT)
        {
            printf("TypeStruct::defaultInitLiteral() '%s'\n", вТкст0());
        }
        sym.size(место);
        if (sym.sizeok != Sizeok.done)
            return new ErrorExp();

        auto structelems = new Выражения(sym.nonHiddenFields());
        бцел смещение = 0;
        foreach (j; new бцел[0 .. structelems.dim])
        {
            VarDeclaration vd = sym.fields[j];
            Выражение e;
            if (vd.inuse)
            {
                выведиОшибку(место, "circular reference to `%s`", vd.toPrettyChars());
                return new ErrorExp();
            }
            if (vd.смещение < смещение || vd.тип.size() == 0)
                e = null;
            else if (vd._иниц)
            {
                if (vd._иниц.isVoidInitializer())
                    e = null;
                else
                    e = vd.getConstInitializer(нет);
            }
            else
                e = vd.тип.defaultInitLiteral(место);
            if (e && e.op == ТОК2.error)
                return e;
            if (e)
                смещение = vd.смещение + cast(бцел)vd.тип.size();
            (*structelems)[j] = e;
        }
        auto structinit = new StructLiteralExp(место, sym, structelems);

        /* Copy from the инициализатор symbol for larger symbols,
         * otherwise the literals expressed as code get excessively large.
         */
        if (size(место) > target.ptrsize * 4 && !needsNested())
            structinit.useStaticInit = да;

        structinit.тип = this;
        return structinit;
    }

    override бул isZeroInit(ref Место место)
    {
        return sym.zeroInit;
    }

    override бул isAssignable()
    {
        бул assignable = да;
        бцел смещение = ~0; // dead-store initialize to prevent spurious warning

        sym.determineSize(sym.место);

        /* If any of the fields are const or const,
         * then one cannot assign this struct.
         */
        for (т_мера i = 0; i < sym.fields.dim; i++)
        {
            VarDeclaration v = sym.fields[i];
            //printf("%s [%d] v = (%s) %s, v.смещение = %d, v.родитель = %s\n", sym.вТкст0(), i, v.вид(), v.вТкст0(), v.смещение, v.родитель.вид());
            if (i == 0)
            {
            }
            else if (v.смещение == смещение)
            {
                /* If any fields of анонимный union are assignable,
                 * then regard union as assignable.
                 * This is to support unsafe things like Rebindable templates.
                 */
                if (assignable)
                    continue;
            }
            else
            {
                if (!assignable)
                    return нет;
            }
            assignable = v.тип.isMutable() && v.тип.isAssignable();
            смещение = v.смещение;
            //printf(" -> assignable = %d\n", assignable);
        }

        return assignable;
    }

    override бул isBoolean() 
    {
        return нет;
    }

    override бул needsDestruction() 
    {
        return sym.dtor !is null;
    }

    override бул needsNested()
    {
        if (sym.isNested())
            return да;

        for (т_мера i = 0; i < sym.fields.dim; i++)
        {
            VarDeclaration v = sym.fields[i];
            if (!v.isDataseg() && v.тип.needsNested())
                return да;
        }
        return нет;
    }

    override бул hasPointers()
    {
        // Probably should cache this information in sym rather than recompute
        StructDeclaration s = sym;

        if (sym.члены && !sym.determineFields() && sym.тип != Тип.terror)
            выведиОшибку(sym.место, "no size because of forward references");

        foreach (VarDeclaration v; s.fields)
        {
            if (v.класс_хранения & STC.ref_ || v.hasPointers())
                return да;
        }
        return нет;
    }

    override бул hasVoidInitPointers()
    {
        // Probably should cache this information in sym rather than recompute
        StructDeclaration s = sym;

        sym.size(Место.initial); // give error for forward references
        foreach (VarDeclaration v; s.fields)
        {
            if (v._иниц && v._иниц.isVoidInitializer() && v.тип.hasPointers())
                return да;
            if (!v._иниц && v.тип.hasVoidInitPointers())
                return да;
        }
        return нет;
    }

    extern (D) MATCH implicitConvToWithoutAliasThis(Тип to)
    {
        MATCH m;

        if (ty == to.ty && sym == (cast(TypeStruct)to).sym)
        {
            m = MATCH.exact; // exact match
            if (mod != to.mod)
            {
                m = MATCH.constant;
                if (MODimplicitConv(mod, to.mod))
                {
                }
                else
                {
                    /* Check all the fields. If they can all be converted,
                     * allow the conversion.
                     */
                    бцел смещение = ~0; // dead-store to prevent spurious warning
                    for (т_мера i = 0; i < sym.fields.dim; i++)
                    {
                        VarDeclaration v = sym.fields[i];
                        if (i == 0)
                        {
                        }
                        else if (v.смещение == смещение)
                        {
                            if (m > MATCH.nomatch)
                                continue;
                        }
                        else
                        {
                            if (m <= MATCH.nomatch)
                                return m;
                        }

                        // 'from' тип
                        Тип tvf = v.тип.addMod(mod);

                        // 'to' тип
                        Тип tv = v.тип.addMod(to.mod);

                        // field match
                        MATCH mf = tvf.implicitConvTo(tv);
                        //printf("\t%s => %s, match = %d\n", v.тип.вТкст0(), tv.вТкст0(), mf);

                        if (mf <= MATCH.nomatch)
                            return mf;
                        if (mf < m) // if field match is worse
                            m = mf;
                        смещение = v.смещение;
                    }
                }
            }
        }
        return m;
    }

    extern (D) MATCH implicitConvToThroughAliasThis(Тип to)
    {
        MATCH m;
        if (!(ty == to.ty && sym == (cast(TypeStruct)to).sym) && sym.aliasthis && !(att & AliasThisRec.tracing))
        {
            if (auto ato = aliasthisOf())
            {
                att = cast(AliasThisRec)(att | AliasThisRec.tracing);
                m = ato.implicitConvTo(to);
                att = cast(AliasThisRec)(att & ~AliasThisRec.tracing);
            }
            else
                m = MATCH.nomatch; // no match
        }
        return m;
    }

    override MATCH implicitConvTo(Тип to)
    {
        //printf("TypeStruct::implicitConvTo(%s => %s)\n", вТкст0(), to.вТкст0());
        MATCH m = implicitConvToWithoutAliasThis(to);
        return m ? m : implicitConvToThroughAliasThis(to);
    }

    override MATCH constConv(Тип to)
    {
        if (равен(to))
            return MATCH.exact;
        if (ty == to.ty && sym == (cast(TypeStruct)to).sym && MODimplicitConv(mod, to.mod))
            return MATCH.constant;
        return MATCH.nomatch;
    }

    override MOD deduceWild(Тип t, бул isRef)
    {
        if (ty == t.ty && sym == (cast(TypeStruct)t).sym)
            return Тип.deduceWild(t, isRef);

        ббайт wm = 0;

        if (t.hasWild() && sym.aliasthis && !(att & AliasThisRec.tracing))
        {
            if (auto ato = aliasthisOf())
            {
                att = cast(AliasThisRec)(att | AliasThisRec.tracing);
                wm = ato.deduceWild(t, isRef);
                att = cast(AliasThisRec)(att & ~AliasThisRec.tracing);
            }
        }

        return wm;
    }

    override Тип toHeadMutable() 
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeEnum : Тип
{
    EnumDeclaration sym;

    this(EnumDeclaration sym)
    {
        super(Tenum);
        this.sym = sym;
    }

    override ткст0 вид() 
    {
        return "enum";
    }

    override Тип syntaxCopy()
    {
        return this;
    }

    override d_uns64 size(ref Место место)
    {
        return sym.getMemtype(место).size(место);
    }

    Тип memType(ref Место место = Место.initial)
    {
        return sym.getMemtype(место);
    }
    override бцел alignsize()
    {
        Тип t = memType();
        if (t.ty == Terror)
            return 4;
        return t.alignsize();
    }

    override ДСимвол toDsymbol(Scope* sc)
    {
        return sym;
    }

    override бул isintegral()
    {
        return memType().isintegral();
    }

    override бул isfloating()
    {
        return memType().isfloating();
    }

    override бул isreal()
    {
        return memType().isreal();
    }

    override бул isimaginary()
    {
        return memType().isimaginary();
    }

    override бул iscomplex()
    {
        return memType().iscomplex();
    }

    override бул isscalar()
    {
        return memType().isscalar();
    }

    override бул isunsigned()
    {
        return memType().isunsigned();
    }

    override бул ischar()
    {
        return memType().ischar();
    }

    override бул isBoolean()
    {
        return memType().isBoolean();
    }

    override бул isString()
    {
        return memType().isString();
    }

    override бул isAssignable()
    {
        return memType().isAssignable();
    }

    override бул needsDestruction()
    {
        return memType().needsDestruction();
    }

    override бул needsNested()
    {
        return memType().needsNested();
    }

    override MATCH implicitConvTo(Тип to)
    {
        MATCH m;
        //printf("TypeEnum::implicitConvTo() %s to %s\n", вТкст0(), to.вТкст0());
        if (ty == to.ty && sym == (cast(TypeEnum)to).sym)
            m = (mod == to.mod) ? MATCH.exact : MATCH.constant;
        else if (sym.getMemtype(Место.initial).implicitConvTo(to))
            m = MATCH.convert; // match with conversions
        else
            m = MATCH.nomatch; // no match
        return m;
    }

    override MATCH constConv(Тип to)
    {
        if (равен(to))
            return MATCH.exact;
        if (ty == to.ty && sym == (cast(TypeEnum)to).sym && MODimplicitConv(mod, to.mod))
            return MATCH.constant;
        return MATCH.nomatch;
    }

    override Тип toBasetype()
    {
        if (!sym.члены && !sym.memtype)
            return this;
        auto tb = sym.getMemtype(Место.initial).toBasetype();
        return tb.castMod(mod);         // retain modifier bits from 'this'
    }

    override бул isZeroInit(ref Место место)
    {
        return sym.getDefaultValue(место).isBool(нет);
    }

    override бул hasPointers()
    {
        return memType().hasPointers();
    }

    override бул hasVoidInitPointers()
    {
        return memType().hasVoidInitPointers();
    }

    override Тип nextOf()
    {
        return memType().nextOf();
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeClass : Тип
{
    ClassDeclaration sym;
    AliasThisRec att = AliasThisRec.fwdref;
    CPPMANGLE cppmangle = CPPMANGLE.def;

    this(ClassDeclaration sym)
    {
        super(Tclass);
        this.sym = sym;
    }

    override ткст0 вид() 
    {
        return "class";
    }

    override d_uns64 size(ref Место место)
    {
        return target.ptrsize;
    }

    override Тип syntaxCopy()
    {
        return this;
    }

    override ДСимвол toDsymbol(Scope* sc)
    {
        return sym;
    }

    override ClassDeclaration isClassHandle() 
    {
        return sym;
    }

    override бул isBaseOf(Тип t, цел* poffset)
    {
        if (t && t.ty == Tclass)
        {
            ClassDeclaration cd = (cast(TypeClass)t).sym;
            if (sym.isBaseOf(cd, poffset))
                return да;
        }
        return нет;
    }

    extern (D) MATCH implicitConvToWithoutAliasThis(Тип to)
    {
        MATCH m = constConv(to);
        if (m > MATCH.nomatch)
            return m;

        ClassDeclaration cdto = to.isClassHandle();
        if (cdto)
        {
            //printf("TypeClass::implicitConvTo(to = '%s') %s, isbase = %d %d\n", to.вТкст0(), вТкст0(), cdto.isBaseInfoComplete(), sym.isBaseInfoComplete());
            if (cdto.semanticRun < PASS.semanticdone && !cdto.isBaseInfoComplete())
                cdto.dsymbolSemantic(null);
            if (sym.semanticRun < PASS.semanticdone && !sym.isBaseInfoComplete())
                sym.dsymbolSemantic(null);
            if (cdto.isBaseOf(sym, null) && MODimplicitConv(mod, to.mod))
            {
                //printf("'to' is base\n");
                return MATCH.convert;
            }
        }
        return MATCH.nomatch;
    }

    extern (D) MATCH implicitConvToThroughAliasThis(Тип to)
    {
        MATCH m;
        if (sym.aliasthis && !(att & AliasThisRec.tracing))
        {
            if (auto ato = aliasthisOf())
            {
                att = cast(AliasThisRec)(att | AliasThisRec.tracing);
                m = ato.implicitConvTo(to);
                att = cast(AliasThisRec)(att & ~AliasThisRec.tracing);
            }
        }
        return m;
    }

    override MATCH implicitConvTo(Тип to)
    {
        //printf("TypeClass::implicitConvTo(to = '%s') %s\n", to.вТкст0(), вТкст0());
        MATCH m = implicitConvToWithoutAliasThis(to);
        return m ? m : implicitConvToThroughAliasThis(to);
    }

    override MATCH constConv(Тип to)
    {
        if (равен(to))
            return MATCH.exact;
        if (ty == to.ty && sym == (cast(TypeClass)to).sym && MODimplicitConv(mod, to.mod))
            return MATCH.constant;

        /* Conversion derived to const(base)
         */
        цел смещение = 0;
        if (to.isBaseOf(this, &смещение) && смещение == 0 && MODimplicitConv(mod, to.mod))
        {
            // Disallow:
            //  derived to base
            //  inout(derived) to inout(base)
            if (!to.isMutable() && !to.isWild())
                return MATCH.convert;
        }

        return MATCH.nomatch;
    }

    override MOD deduceWild(Тип t, бул isRef)
    {
        ClassDeclaration cd = t.isClassHandle();
        if (cd && (sym == cd || cd.isBaseOf(sym, null)))
            return Тип.deduceWild(t, isRef);

        ббайт wm = 0;

        if (t.hasWild() && sym.aliasthis && !(att & AliasThisRec.tracing))
        {
            if (auto ato = aliasthisOf())
            {
                att = cast(AliasThisRec)(att | AliasThisRec.tracing);
                wm = ato.deduceWild(t, isRef);
                att = cast(AliasThisRec)(att & ~AliasThisRec.tracing);
            }
        }

        return wm;
    }

    override Тип toHeadMutable() 
    {
        return this;
    }

    override бул isZeroInit(ref Место место)
    {
        return да;
    }

    override бул isscope() 
    {
        return sym.stack;
    }

    override бул isBoolean() 
    {
        return да;
    }

    override бул hasPointers() 
    {
        return да;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class КортежТипов : Тип
{
    Параметры* arguments;  // types making up the кортеж

    this(Параметры* arguments)
    {
        super(Ttuple);
        //printf("КортежТипов(this = %p)\n", this);
        this.arguments = arguments;
        //printf("КортежТипов() %p, %s\n", this, вТкст0());
        debug
        {
            if (arguments)
            {
                for (т_мера i = 0; i < arguments.dim; i++)
                {
                    Параметр2 arg = (*arguments)[i];
                    assert(arg && arg.тип);
                }
            }
        }
    }

    /****************
     * Form КортежТипов from the types of the Выражения.
     * Assume exps[] is already кортеж expanded.
     */
    this(Выражения* exps)
    {
        super(Ttuple);
        auto arguments = new Параметры();
        if (exps)
        {
            arguments.устДим(exps.dim);
            for (т_мера i = 0; i < exps.dim; i++)
            {
                Выражение e = (*exps)[i];
                if (e.тип.ty == Ttuple)
                    e.выведиОшибку("cannot form кортеж of tuples");
                auto arg = new Параметр2(STC.undefined_, e.тип, null, null, null);
                (*arguments)[i] = arg;
            }
        }
        this.arguments = arguments;
        //printf("КортежТипов() %p, %s\n", this, вТкст0());
    }

    static КортежТипов создай(Параметры* arguments)
    {
        return new КортежТипов(arguments);
    }

    /*******************************************
     * Тип кортеж with 0, 1 or 2 types in it.
     */
    this()
    {
        super(Ttuple);
        arguments = new Параметры();
    }

    this(Тип t1)
    {
        super(Ttuple);
        arguments = new Параметры();
        arguments.сунь(new Параметр2(0, t1, null, null, null));
    }

    this(Тип t1, Тип t2)
    {
        super(Ttuple);
        arguments = new Параметры();
        arguments.сунь(new Параметр2(0, t1, null, null, null));
        arguments.сунь(new Параметр2(0, t2, null, null, null));
    }

    static КортежТипов создай()
    {
        return new КортежТипов();
    }

    static КортежТипов создай(Тип t1)
    {
        return new КортежТипов(t1);
    }

    static КортежТипов создай(Тип t1, Тип t2)
    {
        return new КортежТипов(t1, t2);
    }

    override ткст0 вид() 
    {
        return "кортеж";
    }

    override Тип syntaxCopy()
    {
        Параметры* args = Параметр2.arraySyntaxCopy(arguments);
        Тип t = new КортежТипов(args);
        t.mod = mod;
        return t;
    }

    override бул равен( КорневойОбъект o)
    {
        Тип t = cast(Тип)o;
        //printf("КортежТипов::равен(%s, %s)\n", вТкст0(), t.вТкст0());
        if (this == t)
            return да;
        if (auto tt = t.isTypeTuple())
        {
            if (arguments.dim == tt.arguments.dim)
            {
                for (т_мера i = 0; i < tt.arguments.dim; i++)
                {
                    const Параметр2 arg1 = (*arguments)[i];
                    Параметр2 arg2 = (*tt.arguments)[i];
                    if (!arg1.тип.равен(arg2.тип))
                        return нет;
                }
                return да;
            }
        }
        return нет;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * This is so we can slice a КортежТипов
 */
 final class TypeSlice : TypeNext
{
    Выражение lwr;
    Выражение upr;

    this(Тип следщ, Выражение lwr, Выражение upr)
    {
        super(Tslice, следщ);
        //printf("TypeSlice[%s .. %s]\n", lwr.вТкст0(), upr.вТкст0());
        this.lwr = lwr;
        this.upr = upr;
    }

    override ткст0 вид() 
    {
        return "slice";
    }

    override Тип syntaxCopy()
    {
        Тип t = new TypeSlice(следщ.syntaxCopy(), lwr.syntaxCopy(), upr.syntaxCopy());
        t.mod = mod;
        return t;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeNull : Тип
{
    this()
    {
        //printf("TypeNull %p\n", this);
        super(Tnull);
    }

    override ткст0 вид() 
    {
        return "null";
    }

    override Тип syntaxCopy()
    {
        // No semantic analysis done, no need to копируй
        return this;
    }

    override MATCH implicitConvTo(Тип to)
    {
        //printf("TypeNull::implicitConvTo(this=%p, to=%p)\n", this, to);
        //printf("from: %s\n", вТкст0());
        //printf("to  : %s\n", to.вТкст0());
        MATCH m = Тип.implicitConvTo(to);
        if (m != MATCH.nomatch)
            return m;

        // NULL implicitly converts to any pointer тип or dynamic массив
        //if (тип.ty == Tpointer && тип.nextOf().ty == Tvoid)
        {
            Тип tb = to.toBasetype();
            if (tb.ty == Tnull || tb.ty == Tpointer || tb.ty == Tarray || tb.ty == Taarray || tb.ty == Tclass || tb.ty == Tdelegate)
                return MATCH.constant;
        }

        return MATCH.nomatch;
    }

    override бул hasPointers()
    {
        /* Although null isn't dereferencable, treat it as a pointer тип for
         * attribute inference, generic code, etc.
         */
        return да;
    }

    override бул isBoolean() 
    {
        return да;
    }

    override d_uns64 size(ref Место место)
    {
        return tvoidptr.size(место);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * Encapsulate Параметры* so .length and [i] can be используется on it.
 * https://dlang.org/spec/function.html#СписокПараметров
 */
 struct СписокПараметров
{
    Параметры* parameters;
    ВарАрг varargs = ВарАрг.none;

    т_мера length()
    {
        return Параметр2.dim(parameters);
    }

    Параметр2 opIndex(т_мера i)
    {
        return Параметр2.getNth(parameters, i);
    }

    //alias parameters this;
    static СписокПараметров opCall(Параметры* парамы){parameters = парамы;}
}


/***********************************************************
 */
 final class Параметр2 : УзелАСД
{
    import dmd.attrib : UserAttributeDeclaration;

    КлассХранения классХранения;
    Тип тип;
    Идентификатор2 идент;
    Выражение defaultArg;
    UserAttributeDeclaration userAttribDecl; // user defined attributes

    this(КлассХранения классХранения, Тип тип, Идентификатор2 идент, Выражение defaultArg, UserAttributeDeclaration userAttribDecl)
    {
        this.тип = тип;
        this.идент = идент;
        this.классХранения = классХранения;
        this.defaultArg = defaultArg;
        this.userAttribDecl = userAttribDecl;
    }

    static Параметр2 создай(КлассХранения классХранения, Тип тип, Идентификатор2 идент, Выражение defaultArg, UserAttributeDeclaration userAttribDecl)
    {
        return new Параметр2(классХранения, тип, идент, defaultArg, userAttribDecl);
    }

    Параметр2 syntaxCopy()
    {
        return new Параметр2(классХранения, тип ? тип.syntaxCopy() : null, идент, defaultArg ? defaultArg.syntaxCopy() : null, userAttribDecl ? cast(UserAttributeDeclaration) userAttribDecl.syntaxCopy(null) : null);
    }

    /****************************************************
     * Determine if параметр is a lazy массив of delegates.
     * If so, return the return тип of those delegates.
     * If not, return NULL.
     *
     * Возвращает T if the тип is one of the following forms:
     *      T delegate()[]
     *      T delegate()[dim]
     */
    Тип isLazyArray()
    {
        Тип tb = тип.toBasetype();
        if (tb.ty == Tsarray || tb.ty == Tarray)
        {
            Тип tel = (cast(TypeArray)tb).следщ.toBasetype();
            if (auto td = tel.isTypeDelegate())
            {
                TypeFunction tf = td.следщ.toTypeFunction();
                if (tf.parameterList.varargs == ВарАрг.none && tf.parameterList.length == 0)
                {
                    return tf.следщ; // return тип of delegate
                }
            }
        }
        return null;
    }

    // kludge for template.тип_ли()
    override ДИНКАСТ динкаст() 
    {
        return ДИНКАСТ.параметр;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }

    extern (D) static Параметры* arraySyntaxCopy(Параметры* parameters)
    {
        Параметры* парамы = null;
        if (parameters)
        {
            парамы = new Параметры(parameters.dim);
            for (т_мера i = 0; i < парамы.dim; i++)
                (*парамы)[i] = (*parameters)[i].syntaxCopy();
        }
        return парамы;
    }

    /***************************************
     * Determine number of arguments, folding in tuples.
     */
    static т_мера dim(Параметры* parameters)
    {
        т_мера nargs = 0;

        цел dimDg(т_мера n, Параметр2 p)
        {
            ++nargs;
            return 0;
        }

        _foreach(parameters, &dimDg);
        return nargs;
    }

    /***************************************
     * Get nth Параметр2, folding in tuples.
     * Возвращает:
     *      Параметр2*      nth Параметр2
     *      NULL            not found, *pn gets incremented by the number
     *                      of Параметры
     */
    static Параметр2 getNth(Параметры* parameters, т_мера nth, т_мера* pn = null)
    {
        Параметр2 param;

        цел getNthParamDg(т_мера n, Параметр2 p)
        {
            if (n == nth)
            {
                param = p;
                return 1;
            }
            return 0;
        }

        цел res = _foreach(parameters, &getNthParamDg);
        return res ? param : null;
    }

    alias extern (D) цел delegate(т_мера paramidx, Параметр2 param) ForeachDg;

    /***************************************
     * Expands tuples in args in depth first order. Calls
     * dg(проц *ctx, т_мера argidx, Параметр2 *arg) for each Параметр2.
     * If dg returns !=0, stops and returns that значение else returns 0.
     * Use this function to avoid the O(N + N^2/2) complexity of
     * calculating dim and calling N times getNth.
     */
    extern (D) static цел _foreach(Параметры* parameters, ForeachDg dg, т_мера* pn = null)
    {
        assert(dg);
        if (!parameters)
            return 0;

        т_мера n = pn ? *pn : 0; // take over index
        цел результат = 0;
        foreach (i; new бцел[0 .. parameters.dim])
        {
            Параметр2 p = (*parameters)[i];
            Тип t = p.тип.toBasetype();

            if (auto tu = t.isTypeTuple())
            {
                результат = _foreach(tu.arguments, dg, &n);
            }
            else
                результат = dg(n++, p);

            if (результат)
                break;
        }

        if (pn)
            *pn = n; // update index
        return результат;
    }

    override ткст0 вТкст0() 
    {
        return идент ? идент.вТкст0() : "__anonymous_param";
    }

    /*********************************
     * Compute covariance of parameters `this` and `p`
     * as determined by the storage classes of both.
     * Параметры:
     *  returnByRef = да if the function returns by ref
     *  p = Параметр2 to compare with
     * Возвращает:
     *  да = `this` can be используется in place of `p`
     *  нет = nope
     */
    бул isCovariant(бул returnByRef,  Параметр2 p)    
    {
        const stc = STC.ref_ | STC.in_ | STC.out_ | STC.lazy_;
        if ((this.классХранения & stc) != (p.классХранения & stc))
            return нет;
        return isCovariantScope(returnByRef, this.классХранения, p.классХранения);
    }

    extern (D) private static бул isCovariantScope(бул returnByRef, КлассХранения from, КлассХранения to)    
    {
        if (from == to)
            return да;

        /* Shrinking the representation is necessary because КлассХранения is so wide
         * Параметры:
         *   returnByRef = да if the function returns by ref
         *   stc = storage class of параметр
         */
        static бцел buildSR(бул returnByRef, КлассХранения stc)    
        {
            бцел результат;
            switch (stc & (STC.ref_ | STC.scope_ | STC.return_))
            {
                case 0:                    результат = SR.None;        break;
                case STC.ref_:               результат = SR.Ref;         break;
                case STC.scope_:             результат = SR.Scope;       break;
                case STC.return_ | STC.ref_:   результат = SR.ReturnRef;   break;
                case STC.return_ | STC.scope_: результат = SR.ReturnScope; break;
                case STC.ref_    | STC.scope_: результат = SR.RefScope;    break;
                case STC.return_ | STC.ref_ | STC.scope_:
                    результат = returnByRef ? SR.ReturnRef_Scope : SR.Ref_ReturnScope;
                    break;
            }
            return результат;
        }

        /* результат is да if the 'from' can be используется as a 'to'
         */

        if ((from ^ to) & STC.ref_)               // differing in 'ref' means no covariance
            return нет;

        return covariant[buildSR(returnByRef, from)][buildSR(returnByRef, to)];
    }

    /* Classification of 'scope-return-ref' possibilities
     */
    private enum SR
    {
        None,
        Scope,
        ReturnScope,
        Ref,
        ReturnRef,
        RefScope,
        ReturnRef_Scope,
        Ref_ReturnScope,
    }

    extern (D) private static бул[SR.max + 1][SR.max + 1] covariantInit()    
    {
        /* Initialize covariant[][] with this:

             From\To           n   rs  s
             None              X
             ReturnScope       X   X
             Scope             X   X   X

             From\To           r   rr  rs  rr-s r-rs
             Ref               X   X
             ReturnRef             X
             RefScope          X   X   X   X    X
             ReturnRef-Scope       X       X
             Ref-ReturnScope   X   X            X
        */
        бул[SR.max + 1][SR.max + 1] covariant;

        foreach (i; new бцел[0 .. SR.max + 1])
        {
            covariant[i][i] = да;
            covariant[SR.RefScope][i] = да;
        }
        covariant[SR.ReturnScope][SR.None]        = да;
        covariant[SR.Scope      ][SR.None]        = да;
        covariant[SR.Scope      ][SR.ReturnScope] = да;

        covariant[SR.Ref            ][SR.ReturnRef] = да;
        covariant[SR.ReturnRef_Scope][SR.ReturnRef] = да;
        covariant[SR.Ref_ReturnScope][SR.Ref      ] = да;
        covariant[SR.Ref_ReturnScope][SR.ReturnRef] = да;

        return covariant;
    }

    extern (D) private static  бул[SR.max + 1][SR.max + 1] covariant = covariantInit();
}

/*************************************************************
 * For printing two types with qualification when necessary.
 * Параметры:
 *    t1 = The first тип to receive the тип имя for
 *    t2 = The second тип to receive the тип имя for
 * Возвращает:
 *    The fully-qualified имена of both types if the two тип имена are not the same,
 *    or the unqualified имена of both types if the two тип имена are the same.
 */
сим*[2] toAutoQualChars(Тип t1, Тип t2)
{
    auto s1 = t1.вТкст0();
    auto s2 = t2.вТкст0();
    // show qualification only if it's different
    if (!t1.равен(t2) && strcmp(s1, s2) == 0)
    {
        s1 = t1.toPrettyChars(да);
        s2 = t2.toPrettyChars(да);
    }
    return [s1, s2];
}


/**
 * For each active modifier (MODFlags.const_, MODFlags.immutable_, etc) call `fp` with a
 * ук for the work param and a ткст representation of the attribute.
 */
проц modifiersApply( TypeFunction tf, проц delegate(ткст) dg)
{
    const ббайт[4] modsArr = [MODFlags.const_, MODFlags.immutable_, MODFlags.wild, MODFlags.shared_];

    foreach (modsarr; modsArr)
    {
        if (tf.mod & modsarr)
        {
            dg(MODвТкст(modsarr));
        }
    }
}

/**
 * For each active attribute (ref/const/nogc/etc) call `fp` with a ук for the
 * work param and a ткст representation of the attribute.
 */
проц attributesApply( TypeFunction tf, проц delegate(ткст) dg, TRUSTformat trustFormat = TRUSTformatDefault)
{
    if (tf.purity)
        dg("");
    if (tf.isnothrow)
        dg("");
    if (tf.isnogc)
        dg("");
    if (tf.isproperty)
        dg("");
    if (tf.isref)
        dg("ref");
    if (tf.isreturn && !tf.isreturninferred)
        dg("return");
    if (tf.isscope && !tf.isscopeinferred)
        dg("scope");

    TRUST trustAttrib = tf.trust;

    if (trustAttrib == TRUST.default_)
    {
        if (trustFormat == TRUSTformatSystem)
            trustAttrib = TRUST.system;
        else
            return; // avoid calling with an empty ткст
    }

    dg(trustToString(trustAttrib));
}

/**
 * If the тип is a class or struct, returns the symbol for it,
 * else null.
 */
 AggregateDeclaration isAggregate(Тип t)
{
    t = t.toBasetype();
    if (t.ty == Tclass)
        return (cast(TypeClass)t).sym;
    if (t.ty == Tstruct)
        return (cast(TypeStruct)t).sym;
    return null;
}

/***************************************************
 * Determine if тип t can be indexed or sliced given that it is not an
 * aggregate with operator overloads.
 * Параметры:
 *      t = тип to check
 * Возвращает:
 *      да if an Выражение of тип t can be e1 in an массив Выражение
 */
бул isIndexableNonAggregate(Тип t)
{
    t = t.toBasetype();
    return (t.ty == Tpointer || t.ty == Tsarray || t.ty == Tarray || t.ty == Taarray ||
            t.ty == Ttuple || t.ty == Tvector);
}

/***************************************************
 * Determine if тип t is copyable.
 * Параметры:
 *      t = тип to check
 * Возвращает:
 *      да if we can копируй it
 */
бул isCopyable( Тип t)   
{
    //printf("isCopyable() %s\n", t.вТкст0());
    if (auto ts = t.isTypeStruct())
    {
        if (ts.sym.postblit &&
            ts.sym.postblit.класс_хранения & STC.disable)
            return нет;
    }
    return да;
}
