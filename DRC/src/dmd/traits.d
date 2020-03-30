/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/traits.d, _traits.d)
 * Documentation:  https://dlang.org/phobos/dmd_traits.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/traits.d
 */

module dmd.traits;

import cidrus;

import dmd.aggregate;
import dmd.arraytypes;
import drc.ast.AstCodegen;
import dmd.attrib;
import dmd.canthrow;
import dmd.dclass;
import dmd.declaration;
import dmd.denum;
import dmd.dimport;
import dmd.dmodule;
import dmd.dscope;
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
import dmd.mtype;
import dmd.nogc;
import drc.parser.Parser2;
import util.array;
import util.speller;
import util.stringtable;
import dmd.target;
import drc.lexer.Tokens;
import dmd.typesem;
import drc.ast.Visitor;
import drc.ast.Node;
import util.outbuffer;
import util.string;
import dmd.lambdacomp : isSameFuncLiteral;

const LOGSEMANTIC = нет;

/************************ TraitsExp ************************************/

/**************************************
 * Convert `Выражение` or `Тип` to corresponding `ДСимвол`, additionally
 * stripping off Выражение contexts.
 *
 * Some symbol related `__traits` ignore arguments Выражение contexts.
 * For example:
 * ----
 *  struct S { проц f() {} }
 *  S s;
 *  pragma(msg, __traits(isNested, s.f));
 *  // s.f is `DotVarExp`, but `__traits(isNested)`` needs a `FuncDeclaration`.
 * ----
 *
 * This is используется for that common `__traits` behavior.
 *
 * Input:
 *      oarg     объект to get the symbol for
 * Возвращает:
 *      ДСимвол  the corresponding symbol for oarg
 */
private ДСимвол getDsymbolWithoutExpCtx(КорневойОбъект oarg)
{
    if (auto e = выражение_ли(oarg))
    {
        if (e.op == ТОК2.dotVariable)
            return (cast(DotVarExp)e).var;
        if (e.op == ТОК2.dotTemplateDeclaration)
            return (cast(DotTemplateExp)e).td;
    }
    return getDsymbol(oarg);
}

private const ТаблицаСтрок!(бул) traitsStringTable;

static this()
{
    static const ткст[] имена =
    [
        "isAbstractClass",
        "isArithmetic",
        "isAssociativeArray",
        "isDisabled",
        "isDeprecated",
        "isFuture",
        "isFinalClass",
        "isPOD",
        "isNested",
        "isFloating",
        "isIntegral",
        "isScalar",
        "isStaticArray",
        "isUnsigned",
        "isVirtualFunction",
        "isVirtualMethod",
        "isAbstractFunction",
        "isFinalFunction",
        "isOverrideFunction",
        "isStaticFunction",
        "isModule",
        "isPackage",
        "isRef",
        "isOut",
        "isLazy",
        "isReturnOnStack",
        "hasMember",
        "идентификатор",
        "getProtection",
        "родитель",
        "getLinkage",
        "getMember",
        "getOverloads",
        "getVirtualFunctions",
        "getVirtualMethods",
        "classInstanceSize",
        "allMembers",
        "derivedMembers",
        "isSame",
        "compiles",
        "parameters",
        "getAliasThis",
        "getAttributes",
        "getFunctionAttributes",
        "getFunctionVariadicStyle",
        "getParameterStorageClasses",
        "getUnitTests",
        "getVirtualIndex",
        "getPointerBitmap",
        "isZeroInit",
        "getTargetInfo",
        "getLocation",
        "hasPostblit",
        "hasCopyConstructor",
    ];

    ТаблицаСтрок!(бул)* stringTable = cast(ТаблицаСтрок!(бул)*) &traitsStringTable;
    stringTable._иниц(имена.length);

    foreach (s; имена)
    {
        auto sv = stringTable.вставь(s, да);
        assert(sv);
    }
}

/**
 * get an массив of т_мера values that indicate possible pointer words in memory
 *  if interpreted as the тип given as argument
 * Возвращает: the size of the тип in bytes, d_uns64.max on error
 */
d_uns64 getTypePointerBitmap(Место место, Тип t, МассивДРК!(d_uns64)* данные)
{
    d_uns64 sz;
    if (t.ty == Tclass && !(cast(TypeClass)t).sym.isInterfaceDeclaration())
        sz = (cast(TypeClass)t).sym.AggregateDeclaration.size(место);
    else
        sz = t.size(место);
    if (sz == SIZE_INVALID)
        return d_uns64.max;

    const sz_т_мера = Тип.tт_мера.size(место);
    if (sz > sz.max - sz_т_мера)
    {
        выведиОшибку(место, "size overflow for тип `%s`", t.вТкст0());
        return d_uns64.max;
    }

    d_uns64 bitsPerWord = sz_т_мера * 8;
    d_uns64 cntptr = (sz + sz_т_мера - 1) / sz_т_мера;
    d_uns64 cntdata = (cntptr + bitsPerWord - 1) / bitsPerWord;

    данные.устДим(cast(т_мера)cntdata);
    данные.нуль();

     final class PointerBitmapVisitor : Визитор2
    {
        alias Визитор2.посети посети;
    public:
        this(МассивДРК!(d_uns64)* _data, d_uns64 _sz_т_мера)
        {
            this.данные = _data;
            this.sz_т_мера = _sz_т_мера;
        }

        проц setpointer(d_uns64 off)
        {
            d_uns64 ptroff = off / sz_т_мера;
            (*данные)[cast(т_мера)(ptroff / (8 * sz_т_мера))] |= 1L << (ptroff % (8 * sz_т_мера));
        }

        override проц посети(Тип t)
        {
            Тип tb = t.toBasetype();
            if (tb != t)
                tb.прими(this);
        }

        override проц посети(TypeError t)
        {
            посети(cast(Тип)t);
        }

        override проц посети(TypeNext t)
        {
            assert(0);
        }

        override проц посети(TypeBasic t)
        {
            if (t.ty == Tvoid)
                setpointer(смещение);
        }

        override проц посети(TypeVector t)
        {
        }

        override проц посети(TypeArray t)
        {
            assert(0);
        }

        override проц посети(TypeSArray t)
        {
            d_uns64 arrayoff = смещение;
            d_uns64 nextsize = t.следщ.size();
            if (nextsize == SIZE_INVALID)
                error = да;
            d_uns64 dim = t.dim.toInteger();
            for (d_uns64 i = 0; i < dim; i++)
            {
                смещение = arrayoff + i * nextsize;
                t.следщ.прими(this);
            }
            смещение = arrayoff;
        }

        override проц посети(TypeDArray t)
        {
            setpointer(смещение + sz_т_мера);
        }

        // dynamic массив is {length,ptr}
        override проц посети(TypeAArray t)
        {
            setpointer(смещение);
        }

        override проц посети(TypePointer t)
        {
            if (t.nextOf().ty != Tfunction) // don't mark function pointers
                setpointer(смещение);
        }

        override проц посети(TypeReference t)
        {
            setpointer(смещение);
        }

        override проц посети(TypeClass t)
        {
            setpointer(смещение);
        }

        override проц посети(TypeFunction t)
        {
        }

        override проц посети(TypeDelegate t)
        {
            setpointer(смещение);
        }

        // delegate is {context, function}
        override проц посети(TypeQualified t)
        {
            assert(0);
        }

        // assume resolved
        override проц посети(TypeIdentifier t)
        {
            assert(0);
        }

        override проц посети(TypeInstance t)
        {
            assert(0);
        }

        override проц посети(TypeTypeof t)
        {
            assert(0);
        }

        override проц посети(TypeReturn t)
        {
            assert(0);
        }

        override проц посети(TypeEnum t)
        {
            посети(cast(Тип)t);
        }

        override проц посети(КортежТипов t)
        {
            посети(cast(Тип)t);
        }

        override проц посети(TypeSlice t)
        {
            assert(0);
        }

        override проц посети(TypeNull t)
        {
            // always a null pointer
        }

        override проц посети(TypeStruct t)
        {
            d_uns64 structoff = смещение;
            foreach (v; t.sym.fields)
            {
                смещение = structoff + v.смещение;
                if (v.тип.ty == Tclass)
                    setpointer(смещение);
                else
                    v.тип.прими(this);
            }
            смещение = structoff;
        }

        // a "toplevel" class is treated as an instance, while TypeClass fields are treated as references
        проц visitClass(TypeClass t)
        {
            d_uns64 classoff = смещение;
            // skip vtable-ptr and monitor
            if (t.sym.baseClass)
                visitClass(cast(TypeClass)t.sym.baseClass.тип);
            foreach (v; t.sym.fields)
            {
                смещение = classoff + v.смещение;
                v.тип.прими(this);
            }
            смещение = classoff;
        }

        МассивДРК!(d_uns64)* данные;
        d_uns64 смещение;
        d_uns64 sz_т_мера;
        бул error;
    }

    scope PointerBitmapVisitor pbv = new PointerBitmapVisitor(данные, sz_т_мера);
    if (t.ty == Tclass)
        pbv.visitClass(cast(TypeClass)t);
    else
        t.прими(pbv);
    return pbv.error ? d_uns64.max : sz;
}

/**
 * get an массив of т_мера values that indicate possible pointer words in memory
 *  if interpreted as the тип given as argument
 * the first массив element is the size of the тип for independent interpretation
 *  of the массив
 * following elements bits represent one word (4/8 bytes depending on the target
 *  architecture). If set the corresponding memory might contain a pointer/reference.
 *
 *  Возвращает: [T.sizeof, pointerbit0-31/63, pointerbit32/64-63/128, ...]
 */
private Выражение pointerBitmap(TraitsExp e)
{
    if (!e.args || e.args.dim != 1)
    {
        выведиОшибку(e.место, "a single тип expected for trait pointerBitmap");
        return new ErrorExp();
    }

    Тип t = getType((*e.args)[0]);
    if (!t)
    {
        выведиОшибку(e.место, "`%s` is not a тип", (*e.args)[0].вТкст0());
        return new ErrorExp();
    }

    МассивДРК!(d_uns64) данные;
    d_uns64 sz = getTypePointerBitmap(e.место, t, &данные);
    if (sz == d_uns64.max)
        return new ErrorExp();

    auto exps = new Выражения(данные.dim + 1);
    (*exps)[0] = new IntegerExp(e.место, sz, Тип.tт_мера);
    foreach (т_мера i; new бцел[1 .. exps.dim])
        (*exps)[i] = new IntegerExp(e.место, данные[cast(т_мера) (i - 1)], Тип.tт_мера);

    auto ale = new ArrayLiteralExp(e.место, Тип.tт_мера.sarrayOf(данные.dim + 1), exps);
    return ale;
}

Выражение semanticTraits(TraitsExp e, Scope* sc)
{
    static if (LOGSEMANTIC)
    {
        printf("TraitsExp::semantic() %s\n", e.вТкст0());
    }

    if (e.идент != Id.compiles &&
        e.идент != Id.isSame &&
        e.идент != Id.идентификатор &&
        e.идент != Id.getProtection &&
        e.идент != Id.getAttributes)
    {
        // Pretend we're in a deprecated scope so that deprecation messages
        // aren't triggered when checking if a symbol is deprecated
        const save = sc.stc;
        if (e.идент == Id.isDeprecated)
            sc.stc |= STC.deprecated_;
        if (!TemplateInstance.semanticTiargs(e.место, sc, e.args, 1))
        {
            sc.stc = save;
            return new ErrorExp();
        }
        sc.stc = save;
    }
    т_мера dim = e.args ? e.args.dim : 0;

    Выражение dimError(цел expected)
    {
        e.выведиОшибку("expected %d arguments for `%s` but had %d", expected, e.идент.вТкст0(), cast(цел)dim);
        return new ErrorExp();
    }

    static IntegerExp True()
    {
        return IntegerExp.createBool(да);
    }

    static IntegerExp False()
    {
        return IntegerExp.createBool(нет);
    }

    /********
     * Gets the function тип from a given AST узел
     * if the узел is a function of some sort.
     * Параметры:
     *   o = an AST узел to check for a `TypeFunction`
     *   fdp = if `o` is a FuncDeclaration then fdp is set to that, otherwise `null`
     * Возвращает:
     *   a тип узел if `o` is a declaration of
     *   a delegate, function, function-pointer or a variable of the former.
     *   Otherwise, `null`.
     */
    static TypeFunction toTypeFunction(КорневойОбъект o, out FuncDeclaration fdp)
    {
        Тип t;
        if (auto s = getDsymbolWithoutExpCtx(o))
        {
            if (auto fd = s.isFuncDeclaration())
            {
                t = fd.тип;
                fdp = fd;
            }
            else if (auto vd = s.isVarDeclaration())
                t = vd.тип;
            else
                t = тип_ли(o);
        }
        else
            t = тип_ли(o);

        if (t)
        {
            if (t.ty == Tfunction)
                return cast(TypeFunction)t;
            else if (t.ty == Tdelegate)
                return cast(TypeFunction)t.nextOf();
            else if (t.ty == Tpointer && t.nextOf().ty == Tfunction)
                return cast(TypeFunction)t.nextOf();
        }

        return null;
    }

    IntegerExp isX(T)(бул delegate(T) fp)
    {
        if (!dim)
            return False();
        foreach (o; *e.args)
        {
            static if (is(T == Тип))
                auto y = getType(o);

            static if (is(T : ДСимвол))
            {
                auto s = getDsymbolWithoutExpCtx(o);
                if (!s)
                    return False();
            }
            static if (is(T == ДСимвол))
                alias s y;
            static if (is(T == Declaration))
                auto y = s.isDeclaration();
            static if (is(T == FuncDeclaration))
                auto y = s.isFuncDeclaration();
            static if (is(T == EnumMember))
                auto y = s.isEnumMember();

            if (!y || !fp(y))
                return False();
        }
        return True();
    }

    alias  isX!(Тип) isTypeX;
    alias  isX!(ДСимвол) isDsymX;
    alias  isX!(Declaration) isDeclX;
    alias  isX!(FuncDeclaration) isFuncX;
    alias  isX!(EnumMember) isEnumMemX;

    Выражение isPkgX(бул function(Package) fp)
    {
        return isDsymX((ДСимвол sym) {
            Package p = resolveIsPackage(sym);
            return (p !is null) && fp(p);
        });
    }

    if (e.идент == Id.isArithmetic)
    {
        return isTypeX(/*t =>*/ t.isintegral() || t.isfloating());
    }
    if (e.идент == Id.isFloating)
    {
        return isTypeX(/*t =>*/ t.isfloating());
    }
    if (e.идент == Id.isIntegral)
    {
        return isTypeX(/*t =>*/ t.isintegral());
    }
    if (e.идент == Id.isScalar)
    {
        return isTypeX(/*t =>*/ t.isscalar());
    }
    if (e.идент == Id.isUnsigned)
    {
        return isTypeX(/*t =>*/ t.isunsigned());
    }
    if (e.идент == Id.isAssociativeArray)
    {
        return isTypeX(/*t =>*/ t.toBasetype().ty == Taarray);
    }
    if (e.идент == Id.isDeprecated)
    {
        if (глоб2.парамы.vcomplex)
        {
            if (isTypeX(/*t =>*/ t.iscomplex() || t.isimaginary()).isBool(да))
                return True();
        }
        return isDsymX(/*t =>*/ t.isDeprecated());
    }
    if (e.идент == Id.isFuture)
    {
       return isDeclX(/*t =>*/ t.isFuture());
    }
    if (e.идент == Id.isStaticArray)
    {
        return isTypeX(/*t =>*/ t.toBasetype().ty == Tsarray);
    }
    if (e.идент == Id.isAbstractClass)
    {
        return isTypeX(/*t =>*/ t.toBasetype().ty == Tclass &&
                            (cast(TypeClass)t.toBasetype()).sym.isAbstract());
    }
    if (e.идент == Id.isFinalClass)
    {
        return isTypeX(/*t =>*/ t.toBasetype().ty == Tclass &&
                            ((cast(TypeClass)t.toBasetype()).sym.класс_хранения & STC.final_) != 0);
    }
    if (e.идент == Id.isTemplate)
    {
        if (dim != 1)
            return dimError(1);

        return isDsymX((s)
        {
            if (!s.toAlias().перегружаем_ли())
                return нет;
            return overloadApply(s,
                /*sm =>*/ sm.isTemplateDeclaration() !is null) != 0;
        });
    }
    if (e.идент == Id.isPOD)
    {
        if (dim != 1)
            return dimError(1);

        auto o = (*e.args)[0];
        auto t = тип_ли(o);
        if (!t)
        {
            e.выведиОшибку("тип expected as second argument of __traits `%s` instead of `%s`",
                e.идент.вТкст0(), o.вТкст0());
            return new ErrorExp();
        }

        Тип tb = t.baseElemOf();
        if (auto sd = tb.ty == Tstruct ? (cast(TypeStruct)tb).sym : null)
        {
            return sd.isPOD() ? True() : False();
        }
        return True();
    }
    if (e.идент == Id.hasCopyConstructor || e.идент == Id.hasPostblit)
    {
        if (dim != 1)
            return dimError(1);

        auto o = (*e.args)[0];
        auto t = тип_ли(o);
        if (!t)
        {
            e.выведиОшибку("тип expected as second argument of __traits `%s` instead of `%s`",
                e.идент.вТкст0(), o.вТкст0());
            return new ErrorExp();
        }

        Тип tb = t.baseElemOf();
        if (auto sd = tb.ty == Tstruct ? (cast(TypeStruct)tb).sym : null)
        {
            return (e.идент == Id.hasPostblit) ? (sd.postblit ? True() : False())
                 : (sd.hasCopyCtor ? True() : False());
        }
        return False();
    }

    if (e.идент == Id.isNested)
    {
        if (dim != 1)
            return dimError(1);

        auto o = (*e.args)[0];
        auto s = getDsymbolWithoutExpCtx(o);
        if (!s)
        {
        }
        else if (auto ad = s.isAggregateDeclaration())
        {
            return ad.isNested() ? True() : False();
        }
        else if (auto fd = s.isFuncDeclaration())
        {
            return fd.isNested() ? True() : False();
        }

        e.выведиОшибку("aggregate or function expected instead of `%s`", o.вТкст0());
        return new ErrorExp();
    }
    if (e.идент == Id.isDisabled)
    {
        if (dim != 1)
            return dimError(1);

        return isDeclX(/*f =>*/ f.isDisabled());
    }
    if (e.идент == Id.isAbstractFunction)
    {
        if (dim != 1)
            return dimError(1);

        return isFuncX(/*f =>*/ f.isAbstract());
    }
    if (e.идент == Id.isVirtualFunction)
    {
        if (dim != 1)
            return dimError(1);

        return isFuncX(/*f =>*/ f.isVirtual());
    }
    if (e.идент == Id.isVirtualMethod)
    {
        if (dim != 1)
            return dimError(1);

        return isFuncX(/*f =>*/ f.isVirtualMethod());
    }
    if (e.идент == Id.isFinalFunction)
    {
        if (dim != 1)
            return dimError(1);

        return isFuncX(/*f =>*/ f.isFinalFunc());
    }
    if (e.идент == Id.isOverrideFunction)
    {
        if (dim != 1)
            return dimError(1);

        return isFuncX(/*f =>*/ f.isOverride());
    }
    if (e.идент == Id.isStaticFunction)
    {
        if (dim != 1)
            return dimError(1);

        return isFuncX(/*f =>*/ !f.needThis() && !f.isNested());
    }
    if (e.идент == Id.isModule)
    {
        if (dim != 1)
            return dimError(1);

        return isPkgX(/*p =>*/ p.isModule() || p.isPackageMod());
    }
    if (e.идент == Id.isPackage)
    {
        if (dim != 1)
            return dimError(1);

        return isPkgX(/*p =>*/ p.isModule() is null);
    }
    if (e.идент == Id.isRef)
    {
        if (dim != 1)
            return dimError(1);

        return isDeclX(/*d =>*/ d.isRef());
    }
    if (e.идент == Id.isOut)
    {
        if (dim != 1)
            return dimError(1);

        return isDeclX(/*d =>*/ d.isOut());
    }
    if (e.идент == Id.isLazy)
    {
        if (dim != 1)
            return dimError(1);

        return isDeclX(/*d =>*/ (d.класс_хранения & STC.lazy_) != 0);
    }
    if (e.идент == Id.идентификатор)
    {
        // Get идентификатор for symbol as a ткст literal
        /* Specify 0 for bit 0 of the flags argument to semanticTiargs() so that
         * a symbol should not be folded to a constant.
         * Bit 1 means don't convert Параметр2 to Тип if Параметр2 has an идентификатор
         */
        if (!TemplateInstance.semanticTiargs(e.место, sc, e.args, 2))
            return new ErrorExp();
        if (dim != 1)
            return dimError(1);

        auto o = (*e.args)[0];
        Идентификатор2 ид;
        if (auto po = isParameter(o))
        {
            if (!po.идент)
            {
                e.выведиОшибку("argument `%s` has no идентификатор", po.тип.вТкст0());
                return new ErrorExp();
            }
            ид = po.идент;
        }
        else
        {
            ДСимвол s = getDsymbolWithoutExpCtx(o);
            if (!s || !s.идент)
            {
                e.выведиОшибку("argument `%s` has no идентификатор", o.вТкст0());
                return new ErrorExp();
            }
            ид = s.идент;
        }

        auto se = new StringExp(e.место, ид.вТкст());
        return se.ВыражениеSemantic(sc);
    }
    if (e.идент == Id.getProtection)
    {
        if (dim != 1)
            return dimError(1);

        Scope* sc2 = sc.сунь();
        sc2.flags = sc.flags | SCOPE.noaccesscheck | SCOPE.ignoresymbolvisibility;
        бул ok = TemplateInstance.semanticTiargs(e.место, sc2, e.args, 1);
        sc2.вынь();
        if (!ok)
            return new ErrorExp();

        auto o = (*e.args)[0];
        auto s = getDsymbolWithoutExpCtx(o);
        if (!s)
        {
            if (!isError(o))
                e.выведиОшибку("argument `%s` has no защита", o.вТкст0());
            return new ErrorExp();
        }
        if (s.semanticRun == PASS.init)
            s.dsymbolSemantic(null);

        auto protName = protectionToString(s.prot().вид); // TODO: How about package(имена)
        assert(protName);
        auto se = new StringExp(e.место, protName);
        return se.ВыражениеSemantic(sc);
    }
    if (e.идент == Id.родитель)
    {
        if (dim != 1)
            return dimError(1);

        auto o = (*e.args)[0];
        auto s = getDsymbolWithoutExpCtx(o);
        if (s)
        {
            // https://issues.dlang.org/show_bug.cgi?ид=12496
            // Consider:
            // class T1
            // {
            //     class C(бцел значение) { }
            // }
            // __traits(родитель, T1.C!2)
            if (auto ad = s.isAggregateDeclaration())  // `s` is `C`
            {
                if (ad.isNested())                     // `C` is nested
                {
                    if (auto p = s.toParent())         // `C`'s родитель is `C!2`, believe it or not
                    {
                        if (p.isTemplateInstance())    // `C!2` is a template instance
                        {
                            s = p;                     // `C!2`'s родитель is `T1`
                            auto td = (cast(TemplateInstance)p).tempdecl;
                            if (td)
                                s = td;                // get the declaration context just in case there's two contexts
                        }
                    }
                }
            }

            if (auto fd = s.isFuncDeclaration()) // https://issues.dlang.org/show_bug.cgi?ид=8943
                s = fd.toAliasFunc();
            if (!s.isImport()) // https://issues.dlang.org/show_bug.cgi?ид=8922
                s = s.toParent();
        }
        if (!s || s.isImport())
        {
            e.выведиОшибку("argument `%s` has no родитель", o.вТкст0());
            return new ErrorExp();
        }

        if (auto f = s.isFuncDeclaration())
        {
            if (auto td = getFuncTemplateDecl(f))
            {
                if (td.overroot) // if not start of overloaded list of TemplateDeclaration's
                    td = td.overroot; // then get the start
                Выражение ex = new TemplateExp(e.место, td, f);
                ex = ex.ВыражениеSemantic(sc);
                return ex;
            }
            if (auto fld = f.isFuncLiteralDeclaration())
            {
                // Directly translate to VarExp instead of FuncExp
                Выражение ex = new VarExp(e.место, fld, да);
                return ex.ВыражениеSemantic(sc);
            }
        }
        return symbolToExp(s, e.место, sc, нет);
    }
    if (e.идент == Id.hasMember ||
        e.идент == Id.getMember ||
        e.идент == Id.getOverloads ||
        e.идент == Id.getVirtualMethods ||
        e.идент == Id.getVirtualFunctions)
    {
        if (dim != 2 && !(dim == 3 && e.идент == Id.getOverloads))
            return dimError(2);

        auto o = (*e.args)[0];
        auto ex = выражение_ли((*e.args)[1]);
        if (!ex)
        {
            e.выведиОшибку("Выражение expected as second argument of __traits `%s`", e.идент.вТкст0());
            return new ErrorExp();
        }
        ex = ex.ctfeInterpret();

        бул includeTemplates = нет;
        if (dim == 3 && e.идент == Id.getOverloads)
        {
            auto b = выражение_ли((*e.args)[2]);
            b = b.ctfeInterpret();
            if (!b.тип.равен(Тип.tбул))
            {
                e.выведиОшибку("`бул` expected as third argument of `__traits(getOverloads)`, not `%s` of тип `%s`", b.вТкст0(), b.тип.вТкст0());
                return new ErrorExp();
            }
            includeTemplates = b.isBool(да);
        }

        StringExp se = ex.вТкстExp();
        if (!se || se.len == 0)
        {
            e.выведиОшибку("ткст expected as second argument of __traits `%s` instead of `%s`", e.идент.вТкст0(), ex.вТкст0());
            return new ErrorExp();
        }
        se = se.toUTF8(sc);

        if (se.sz != 1)
        {
            e.выведиОшибку("ткст must be chars");
            return new ErrorExp();
        }
        auto ид = Идентификатор2.idPool(se.peekString());

        /* Prefer дсимвол, because it might need some runtime contexts.
         */
        ДСимвол sym = getDsymbol(o);
        if (sym)
        {
            if (e.идент == Id.hasMember)
            {
                if (auto sm = sym.search(e.место, ид))
                    return True();
            }
            ex = new DsymbolExp(e.место, sym);
            ex = new DotIdExp(e.место, ex, ид);
        }
        else if (auto t = тип_ли(o))
            ex = typeDotIdExp(e.место, t, ид);
        else if (auto ex2 = выражение_ли(o))
            ex = new DotIdExp(e.место, ex2, ид);
        else
        {
            e.выведиОшибку("invalid first argument");
            return new ErrorExp();
        }

        // ignore symbol visibility and disable access checks for these traits
        Scope* scx = sc.сунь();
        scx.flags |= SCOPE.ignoresymbolvisibility | SCOPE.noaccesscheck;
        scope (exit) scx.вынь();

        if (e.идент == Id.hasMember)
        {
            /* Take any errors as meaning it wasn't found
             */
            ex = ex.trySemantic(scx);
            return ex ? True() : False();
        }
        else if (e.идент == Id.getMember)
        {
            if (ex.op == ТОК2.dotIdentifier)
                // Prevent semantic() from replacing Symbol with its инициализатор
                (cast(DotIdExp)ex).wantsym = да;
            ex = ex.ВыражениеSemantic(scx);
            return ex;
        }
        else if (e.идент == Id.getVirtualFunctions ||
                 e.идент == Id.getVirtualMethods ||
                 e.идент == Id.getOverloads)
        {
            бцел errors = глоб2.errors;
            Выражение eorig = ex;
            ex = ex.ВыражениеSemantic(scx);
            if (errors < глоб2.errors)
                e.выведиОшибку("`%s` cannot be resolved", eorig.вТкст0());

            /* Create кортеж of functions of ex
             */
            auto exps = new Выражения();
            ДСимвол f;
            if (ex.op == ТОК2.variable)
            {
                VarExp ve = cast(VarExp)ex;
                f = ve.var.isFuncDeclaration();
                ex = null;
            }
            else if (ex.op == ТОК2.dotVariable)
            {
                DotVarExp dve = cast(DotVarExp)ex;
                f = dve.var.isFuncDeclaration();
                if (dve.e1.op == ТОК2.dotType || dve.e1.op == ТОК2.this_)
                    ex = null;
                else
                    ex = dve.e1;
            }
            else if (ex.op == ТОК2.template_)
            {
                VarExp ve = cast(VarExp)ex;
                auto td = ve.var.isTemplateDeclaration();
                f = td;
                if (td && td.funcroot)
                    f = td.funcroot;
                ex = null;
            }

            бул[ткст] funcTypeHash;

            /* Compute the function signature and вставь it in the
             * hashtable, if not present. This is needed so that
             * traits(getOverlods, F3, "посети") does not count `цел посети(цел)`
             * twice in the following example:
             *
             * =============================================
             * interface F1 { цел посети(цел);}
             * interface F2 { цел посети(цел); проц посети(); }
             * interface F3 : F2, F1 {}
             *==============================================
             */
            проц insertInterfaceInheritedFunction(FuncDeclaration fd, Выражение e)
            {
                auto signature = fd.тип.вТкст();
                //printf("%s - %s\n", fd.вТкст0, signature);
                if (signature in funcTypeHash){}
                else
                {
                    funcTypeHash[signature] = да;
                    exps.сунь(e);
                }
            }

            цел dg(ДСимвол s)
            {
                if (includeTemplates)
                {
                    exps.сунь(new DsymbolExp(Место.initial, s, нет));
                    return 0;
                }
                auto fd = s.isFuncDeclaration();
                if (!fd)
                    return 0;
                if (e.идент == Id.getVirtualFunctions && !fd.isVirtual())
                    return 0;
                if (e.идент == Id.getVirtualMethods && !fd.isVirtualMethod())
                    return 0;

                auto fa = new FuncAliasDeclaration(fd.идент, fd, нет);
                fa.защита = fd.защита;

                auto e = ex ? new DotVarExp(Место.initial, ex, fa, нет)
                            : new DsymbolExp(Место.initial, fa, нет);

                // if the родитель is an interface declaration
                // we must check for functions with the same signature
                // in different inherited interfaces
                if (sym && sym.isInterfaceDeclaration())
                    insertInterfaceInheritedFunction(fd, e);
                else
                    exps.сунь(e);
                return 0;
            }

            InterfaceDeclaration ifd = null;
            if (sym)
                ifd = sym.isInterfaceDeclaration();
            // If the symbol passed as a параметр is an
            // interface that inherits other interfaces
            overloadApply(f, &dg);
            if (ifd && ifd.interfaces && f)
            {
                // check the overloads of each inherited interface individually
                foreach (bc; ifd.interfaces)
                {
                    if (auto fd = bc.sym.search(e.место, f.идент))
                        overloadApply(fd, &dg);
                }
            }

            auto tup = new TupleExp(e.место, exps);
            return tup.ВыражениеSemantic(scx);
        }
        else
            assert(0);
    }
    if (e.идент == Id.classInstanceSize)
    {
        if (dim != 1)
            return dimError(1);

        auto o = (*e.args)[0];
        auto s = getDsymbol(o);
        auto cd = s ? s.isClassDeclaration() : null;
        if (!cd)
        {
            e.выведиОшибку("first argument is not a class");
            return new ErrorExp();
        }
        if (cd.sizeok != Sizeok.done)
        {
            cd.size(e.место);
        }
        if (cd.sizeok != Sizeok.done)
        {
            e.выведиОшибку("%s `%s` is forward referenced", cd.вид(), cd.вТкст0());
            return new ErrorExp();
        }

        return new IntegerExp(e.место, cd.structsize, Тип.tт_мера);
    }
    if (e.идент == Id.getAliasThis)
    {
        if (dim != 1)
            return dimError(1);

        auto o = (*e.args)[0];
        auto s = getDsymbol(o);
        auto ad = s ? s.isAggregateDeclaration() : null;

        auto exps = new Выражения();
        if (ad && ad.aliasthis)
            exps.сунь(new StringExp(e.место, ad.aliasthis.идент.вТкст()));
        Выражение ex = new TupleExp(e.место, exps);
        ex = ex.ВыражениеSemantic(sc);
        return ex;
    }
    if (e.идент == Id.getAttributes)
    {
        /* Specify 0 for bit 0 of the flags argument to semanticTiargs() so that
         * a symbol should not be folded to a constant.
         * Bit 1 means don't convert Параметр2 to Тип if Параметр2 has an идентификатор
         */
        if (!TemplateInstance.semanticTiargs(e.место, sc, e.args, 3))
            return new ErrorExp();

        if (dim != 1)
            return dimError(1);

        auto o = (*e.args)[0];
        auto po = isParameter(o);
        auto s = getDsymbolWithoutExpCtx(o);
        UserAttributeDeclaration udad = null;
        if (po)
        {
            udad = po.userAttribDecl;
        }
        else if (s)
        {
            if (s.isImport())
            {
                s = s.isImport().mod;
            }
            //printf("getAttributes %s, attrs = %p, scope = %p\n", s.вТкст0(), s.userAttribDecl, s.scope);
            udad = s.userAttribDecl;
        }
        else
        {
            version (none)
            {
                Выражение x = выражение_ли(o);
                Тип t = тип_ли(o);
                if (x)
                    printf("e = %s %s\n", Сема2.вТкст0(x.op), x.вТкст0());
                if (t)
                    printf("t = %d %s\n", t.ty, t.вТкст0());
            }
            e.выведиОшибку("first argument is not a symbol");
            return new ErrorExp();
        }

        auto exps = udad ? udad.getAttributes() : new Выражения();
        auto tup = new TupleExp(e.место, exps);
        return tup.ВыражениеSemantic(sc);
    }
    if (e.идент == Id.getFunctionAttributes)
    {
        /* Extract all function attributes as a кортеж (const/shared/inout///etc) except UDAs.
         * https://dlang.org/spec/traits.html#getFunctionAttributes
         */
        if (dim != 1)
            return dimError(1);

        FuncDeclaration fd;
        TypeFunction tf = toTypeFunction((*e.args)[0], fd);

        if (!tf)
        {
            e.выведиОшибку("first argument is not a function");
            return new ErrorExp();
        }

        auto mods = new Выражения();

        проц addToMods(ткст str)
        {
            mods.сунь(new StringExp(Место.initial, str));
        }
        tf.modifiersApply(&addToMods);
        tf.attributesApply(&addToMods, TRUSTformatSystem);

        auto tup = new TupleExp(e.место, mods);
        return tup.ВыражениеSemantic(sc);
    }
    if (e.идент == Id.isReturnOnStack)
    {
        /* Extract as a булean if function return значение is on the stack
         * https://dlang.org/spec/traits.html#isReturnOnStack
         */
        if (dim != 1)
            return dimError(1);

        КорневойОбъект o = (*e.args)[0];
        FuncDeclaration fd;
        TypeFunction tf = toTypeFunction(o, fd);

        if (!tf)
        {
            e.выведиОшибку("argument to `__traits(isReturnOnStack, %s)` is not a function", o.вТкст0());
            return new ErrorExp();
        }

        бул значение = target.isReturnOnStack(tf, fd && fd.needThis());
        return IntegerExp.createBool(значение);
    }
    if (e.идент == Id.getFunctionVariadicStyle)
    {
        /* Accept a symbol or a тип. Возвращает one of the following:
         *  "none"      not a variadic function
         *  "argptr"    extern(D) проц dstyle(...), use `__argptr` and `__arguments`
         *  "stdarg"    extern(C) проц cstyle(цел, ...), use core.stdc.stdarg
         *  "typesafe"  проц typesafe(T[] ...)
         */
        // get symbol компонаж as a ткст
        if (dim != 1)
            return dimError(1);

        LINK link;
        ВарАрг varargs;
        auto o = (*e.args)[0];

        FuncDeclaration fd;
        TypeFunction tf = toTypeFunction(o, fd);

        if (tf)
        {
            link = tf.компонаж;
            varargs = tf.parameterList.varargs;
        }
        else
        {
            if (!fd)
            {
                e.выведиОшибку("argument to `__traits(getFunctionVariadicStyle, %s)` is not a function", o.вТкст0());
                return new ErrorExp();
            }
            link = fd.компонаж;
            varargs = fd.getParameterList().varargs;
        }
        ткст style;
        switch (varargs)
        {
            case ВарАрг.none:     style = "none";           break;
            case ВарАрг.variadic: style = (link == LINK.d)
                                             ? "argptr"
                                             : "stdarg";    break;
            case ВарАрг.typesafe: style = "typesafe";       break;
        }
        auto se = new StringExp(e.место, style);
        return se.ВыражениеSemantic(sc);
    }
    if (e.идент == Id.getParameterStorageClasses)
    {
        /* Accept a function symbol or a тип, followed by a параметр index.
         * Возвращает a кортеж of strings of the параметр's storage classes.
         */
        // get symbol компонаж as a ткст
        if (dim != 2)
            return dimError(2);

        auto o = (*e.args)[0];
        auto o1 = (*e.args)[1];

        FuncDeclaration fd;
        TypeFunction tf = toTypeFunction(o, fd);

        СписокПараметров fparams;
        if (tf)
            fparams = tf.parameterList;
        else if (fd)
            fparams = fd.getParameterList();
        else
        {
            e.выведиОшибку("first argument to `__traits(getParameterStorageClasses, %s, %s)` is not a function",
                o.вТкст0(), o1.вТкст0());
            return new ErrorExp();
        }

        КлассХранения stc;

        // Set stc to storage class of the ith параметр
        auto ex = выражение_ли((*e.args)[1]);
        if (!ex)
        {
            e.выведиОшибку("Выражение expected as second argument of `__traits(getParameterStorageClasses, %s, %s)`",
                o.вТкст0(), o1.вТкст0());
            return new ErrorExp();
        }
        ex = ex.ctfeInterpret();
        auto ii = ex.toUInteger();
        if (ii >= fparams.length)
        {
            e.выведиОшибку("параметр index must be in range 0..%u not %s", cast(бцел)fparams.length, ex.вТкст0());
            return new ErrorExp();
        }

        бцел n = cast(бцел)ii;
        Параметр2 p = fparams[n];
        stc = p.классХранения;

        // This mirrors hdrgen.посети(Параметр2 p)
        if (p.тип && p.тип.mod & MODFlags.shared_)
            stc &= ~STC.shared_;

        auto exps = new Выражения;

        проц сунь(ткст s)
        {
            exps.сунь(new StringExp(e.место, s));
        }

        if (stc & STC.auto_)
            сунь("auto");
        if (stc & STC.return_)
            сунь("return");

        if (stc & STC.out_)
            сунь("out");
        else if (stc & STC.ref_)
            сунь("ref");
        else if (stc & STC.in_)
            сунь("in");
        else if (stc & STC.lazy_)
            сунь("lazy");
        else if (stc & STC.alias_)
            сунь("alias");

        if (stc & STC.const_)
            сунь("const");
        if (stc & STC.immutable_)
            сунь("const");
        if (stc & STC.wild)
            сунь("inout");
        if (stc & STC.shared_)
            сунь("shared");
        if (stc & STC.scope_ && !(stc & STC.scopeinferred))
            сунь("scope");

        auto tup = new TupleExp(e.место, exps);
        return tup.ВыражениеSemantic(sc);
    }
    if (e.идент == Id.getLinkage)
    {
        // get symbol компонаж as a ткст
        if (dim != 1)
            return dimError(1);

        LINK link;
        auto o = (*e.args)[0];

        FuncDeclaration fd;
        TypeFunction tf = toTypeFunction(o, fd);

        if (tf)
            link = tf.компонаж;
        else
        {
            auto s = getDsymbol(o);
            Declaration d;
            AggregateDeclaration agg;
            if (!s || ((d = s.isDeclaration()) is null && (agg = s.isAggregateDeclaration()) is null))
            {
                e.выведиОшибку("argument to `__traits(getLinkage, %s)` is not a declaration", o.вТкст0());
                return new ErrorExp();
            }
            if (d !is null)
                link = d.компонаж;
            else switch (agg.classKind)
            {
                case ClassKind.d:
                    link = LINK.d;
                    break;
                case ClassKind.cpp:
                    link = LINK.cpp;
                    break;
                case ClassKind.objc:
                    link = LINK.objc;
                    break;
            }
        }
        auto компонаж = компонажВТкст0(link);
        auto se = new StringExp(e.место, компонаж.вТкстД());
        return se.ВыражениеSemantic(sc);
    }
    if (e.идент == Id.allMembers ||
        e.идент == Id.derivedMembers)
    {
        if (dim != 1)
            return dimError(1);

        auto o = (*e.args)[0];
        auto s = getDsymbol(o);
        if (!s)
        {
            e.выведиОшибку("argument has no члены");
            return new ErrorExp();
        }
        if (auto imp = s.isImport())
        {
            // https://issues.dlang.org/show_bug.cgi?ид=9692
            s = imp.mod;
        }

        auto sds = s.isScopeDsymbol();
        if (!sds || sds.isTemplateDeclaration())
        {
            e.выведиОшибку("%s `%s` has no члены", s.вид(), s.вТкст0());
            return new ErrorExp();
        }

        auto idents = new Идентификаторы();

        цел pushIdentsDg(т_мера n, ДСимвол sm)
        {
            if (!sm)
                return 1;

            // skip local symbols, such as static foreach loop variables
            if (auto decl = sm.isDeclaration())
            {
                if (decl.класс_хранения & STC.local)
                {
                    return 0;
                }
            }

            //printf("\t[%i] %s %s\n", i, sm.вид(), sm.вТкст0());
            if (sm.идент)
            {
                // https://issues.dlang.org/show_bug.cgi?ид=10096
                // https://issues.dlang.org/show_bug.cgi?ид=10100
                // Skip over internal члены in __traits(allMembers)
                if ((sm.isCtorDeclaration() && sm.идент != Id.ctor) ||
                    (sm.isDtorDeclaration() && sm.идент != Id.dtor) ||
                    (sm.isPostBlitDeclaration() && sm.идент != Id.postblit) ||
                    sm.isInvariantDeclaration() ||
                    sm.isUnitTestDeclaration())

                {
                    return 0;
                }
                if (sm.идент == Id.empty)
                {
                    return 0;
                }
                if (sm.isTypeInfoDeclaration()) // https://issues.dlang.org/show_bug.cgi?ид=15177
                    return 0;
                if (!sds.isModule() && sm.isImport()) // https://issues.dlang.org/show_bug.cgi?ид=17057
                    return 0;

                //printf("\t%s\n", sm.идент.вТкст0());

                /* Skip if already present in idents[]
                 */
                foreach (ид; *idents)
                {
                    if (ид == sm.идент)
                        return 0;

                    // Avoid using strcmp in the first place due to the performance impact in an O(N^2) loop.
                    debug
                    {
                       // import core.stdc.ткст : strcmp;
                        assert(strcmp(ид.вТкст0(), sm.идент.вТкст0()) != 0);
                    }
                }
                idents.сунь(sm.идент);
            }
            else if (auto ed = sm.isEnumDeclaration())
            {
                ScopeDsymbol._foreach(null, ed.члены, &pushIdentsDg);
            }
            return 0;
        }

        ScopeDsymbol._foreach(sc, sds.члены, &pushIdentsDg);
        auto cd = sds.isClassDeclaration();
        if (cd && e.идент == Id.allMembers)
        {
            if (cd.semanticRun < PASS.semanticdone)
                cd.dsymbolSemantic(null); // https://issues.dlang.org/show_bug.cgi?ид=13668
                                   // Try to resolve forward reference

            проц pushBaseMembersDg(ClassDeclaration cd)
            {
                for (т_мера i = 0; i < cd.baseclasses.dim; i++)
                {
                    auto cb = (*cd.baseclasses)[i].sym;
                    assert(cb);
                    ScopeDsymbol._foreach(null, cb.члены, &pushIdentsDg);
                    if (cb.baseclasses.dim)
                        pushBaseMembersDg(cb);
                }
            }

            pushBaseMembersDg(cd);
        }

        // Turn Идентификаторы into StringExps reusing the allocated массив
        assert(Выражения.sizeof == Идентификаторы.sizeof);
        auto exps = cast(Выражения*)idents;
        foreach (i, ид; *idents)
        {
            auto se = new StringExp(e.место, ид.вТкст());
            (*exps)[i] = se;
        }

        /* Making this a кортеж is more flexible, as it can be statically unrolled.
         * To make an массив literal, enclose __traits in [ ]:
         *   [ __traits(allMembers, ...) ]
         */
        Выражение ex = new TupleExp(e.место, exps);
        ex = ex.ВыражениеSemantic(sc);
        return ex;
    }
    if (e.идент == Id.compiles)
    {
        /* Determine if all the objects - types, Выражения, or symbols -
         * compile without error
         */
        if (!dim)
            return False();

        foreach (o; *e.args)
        {
            бцел errors = глоб2.startGagging();
            Scope* sc2 = sc.сунь();
            sc2.tinst = null;
            sc2.minst = null;
            sc2.flags = (sc.flags & ~(SCOPE.ctfe | SCOPE.условие)) | SCOPE.compile | SCOPE.fullinst;

            бул err = нет;

            auto t = тип_ли(o);
            while (t)
            {
                if (auto tm = t.isTypeMixin())
                {
                    /* The mixin ткст could be a тип or an Выражение.
                     * Have to try compiling it to see.
                     */
                    БуфВыв буф;
                    if (выраженияВТкст(буф, sc, tm.exps))
                    {
                        err = да;
                        break;
                    }
                    const len = буф.length;
                    буф.пишиБайт(0);
                    const str = буф.извлекиСрез()[0 .. len];
                    scope p = new Parser!(ASTCodegen)(e.место, sc._module, str, нет);
                    p.nextToken();
                    //printf("p.место.номстр = %d\n", p.место.номстр);

                    o = p.parseTypeOrAssignExp(ТОК2.endOfFile);
                    if (errors != глоб2.errors || p.token.значение != ТОК2.endOfFile)
                    {
                        err = да;
                        break;
                    }
                    t = o.тип_ли();
                }
                else
                    break;
            }

            if (!err)
            {
                auto ex = t ? t.типВВыражение() : выражение_ли(o);
                if (!ex && t)
                {
                    ДСимвол s;
                    t.resolve(e.место, sc2, &ex, &t, &s);
                    if (t)
                    {
                        t.typeSemantic(e.место, sc2);
                        if (t.ty == Terror)
                            err = да;
                    }
                    else if (s && s.errors)
                        err = да;
                }
                if (ex)
                {
                    ex = ex.ВыражениеSemantic(sc2);
                    ex = resolvePropertiesOnly(sc2, ex);
                    ex = ex.optimize(WANTvalue);
                    if (sc2.func && sc2.func.тип.ty == Tfunction)
                    {
                        const tf = cast(TypeFunction)sc2.func.тип;
                        err |= tf.isnothrow && canThrow(ex, sc2.func, нет);
                    }
                    ex = checkGC(sc2, ex);
                    if (ex.op == ТОК2.error)
                        err = да;
                }
            }

            // Carefully detach the scope from the родитель and throw it away as
            // we only need it to evaluate the Выражение
            // https://issues.dlang.org/show_bug.cgi?ид=15428
            sc2.detach();

            if (глоб2.endGagging(errors) || err)
            {
                return False();
            }
        }
        return True();
    }
    if (e.идент == Id.isSame)
    {
        /* Determine if two symbols are the same
         */
        if (dim != 2)
            return dimError(2);

        if (!TemplateInstance.semanticTiargs(e.место, sc, e.args, 0))
            return new ErrorExp();


        auto o1 = (*e.args)[0];
        auto o2 = (*e.args)[1];

        static FuncLiteralDeclaration isLambda(КорневойОбъект oarg)
        {
            if (auto t = isDsymbol(oarg))
            {
                if (auto td = t.isTemplateDeclaration())
                {
                    if (td.члены && td.члены.dim == 1)
                    {
                        if (auto fd = (*td.члены)[0].isFuncLiteralDeclaration())
                            return fd;
                    }
                }
            }
            else if (auto ea = выражение_ли(oarg))
            {
                if (ea.op == ТОК2.function_)
                {
                    if (auto fe = cast(FuncExp)ea)
                        return fe.fd;
                }
            }

            return null;
        }

        auto l1 = isLambda(o1);
        auto l2 = isLambda(o2);

        if (l1 && l2)
        {
            
            if (isSameFuncLiteral(l1, l2, sc))
                return True();
        }

        // issue 12001, allow isSame, <BasicType>, <BasicType>
        Тип t1 = тип_ли(o1);
        Тип t2 = тип_ли(o2);
        if (t1 && t2 && t1.равен(t2))
            return True();

        auto s1 = getDsymbol(o1);
        auto s2 = getDsymbol(o2);
        //printf("isSame: %s, %s\n", o1.вТкст0(), o2.вТкст0());
        version (none)
        {
            printf("o1: %p\n", o1);
            printf("o2: %p\n", o2);
            if (!s1)
            {
                if (auto ea = выражение_ли(o1))
                    printf("%s\n", ea.вТкст0());
                if (auto ta = тип_ли(o1))
                    printf("%s\n", ta.вТкст0());
                return False();
            }
            else
                printf("%s %s\n", s1.вид(), s1.вТкст0());
        }
        if (!s1 && !s2)
        {
            auto ea1 = выражение_ли(o1);
            auto ea2 = выражение_ли(o2);
            if (ea1 && ea2)
            {
                if (ea1.равен(ea2))
                    return True();
            }
        }
        if (!s1 || !s2)
            return False();

        s1 = s1.toAlias();
        s2 = s2.toAlias();

        if (auto fa1 = s1.isFuncAliasDeclaration())
            s1 = fa1.toAliasFunc();
        if (auto fa2 = s2.isFuncAliasDeclaration())
            s2 = fa2.toAliasFunc();

        // https://issues.dlang.org/show_bug.cgi?ид=11259
        // compare import symbol to a package symbol
        static бул cmp(ДСимвол s1, ДСимвол s2)
        {
            auto imp = s1.isImport();
            return imp && imp.pkg && imp.pkg == s2.isPackage();
        }

        if (cmp(s1,s2) || cmp(s2,s1))
            return True();

        if (s1 == s2)
            return True();

        // https://issues.dlang.org/show_bug.cgi?ид=18771
        // OverloadSets are equal if they contain the same functions
        auto overSet1 = s1.isOverloadSet();
        if (!overSet1)
            return False();

        auto overSet2 = s2.isOverloadSet();
        if (!overSet2)
            return False();

        if (overSet1.a.dim != overSet2.a.dim)
            return False();

        // OverloadSets contain массив of Дсимволы => O(n*n)
        // to compare for equality as the order of overloads
        // might not be the same
Lnext:
        foreach(overload1; overSet1.a)
        {
            foreach(overload2; overSet2.a)
            {
                if (overload1 == overload2)
                    continue Lnext;
            }
            return False();
        }
        return True();
    }
    if (e.идент == Id.getUnitTests)
    {
        if (dim != 1)
            return dimError(1);

        auto o = (*e.args)[0];
        auto s = getDsymbolWithoutExpCtx(o);
        if (!s)
        {
            e.выведиОшибку("argument `%s` to __traits(getUnitTests) must be a module or aggregate",
                o.вТкст0());
            return new ErrorExp();
        }
        if (auto imp = s.isImport()) // https://issues.dlang.org/show_bug.cgi?ид=10990
            s = imp.mod;

        auto sds = s.isScopeDsymbol();
        if (!sds)
        {
            e.выведиОшибку("argument `%s` to __traits(getUnitTests) must be a module or aggregate, not a %s",
                s.вТкст0(), s.вид());
            return new ErrorExp();
        }

        auto exps = new Выражения();
        if (глоб2.парамы.useUnitTests)
        {
            бул[ук] uniqueUnitTests;

            проц symbolDg(ДСимвол s)
            {
                if (auto ad = s.isAttribDeclaration())
                {
                    ad.include(null).foreachDsymbol(&symbolDg);
                }
                else if (auto ud = s.isUnitTestDeclaration())
                {
                    if (cast(ук)ud in uniqueUnitTests)
                        return;

                    uniqueUnitTests[cast(ук)ud] = да;

                    auto ad = new FuncAliasDeclaration(ud.идент, ud, нет);
                    ad.защита = ud.защита;

                    auto e = new DsymbolExp(Место.initial, ad, нет);
                    exps.сунь(e);
                }
            }

            sds.члены.foreachDsymbol(&symbolDg);
        }
        auto te = new TupleExp(e.место, exps);
        return te.ВыражениеSemantic(sc);
    }
    if (e.идент == Id.getVirtualIndex)
    {
        if (dim != 1)
            return dimError(1);

        auto o = (*e.args)[0];
        auto s = getDsymbolWithoutExpCtx(o);

        auto fd = s ? s.isFuncDeclaration() : null;
        if (!fd)
        {
            e.выведиОшибку("first argument to __traits(getVirtualIndex) must be a function");
            return new ErrorExp();
        }

        fd = fd.toAliasFunc(); // Necessary to support multiple overloads.
        return new IntegerExp(e.место, fd.vtblIndex, Тип.tptrdiff_t);
    }
    if (e.идент == Id.getPointerBitmap)
    {
        return pointerBitmap(e);
    }
    if (e.идент == Id.isZeroInit)
    {
        if (dim != 1)
            return dimError(1);

        auto o = (*e.args)[0];
        Тип t = тип_ли(o);
        if (!t)
        {
            e.выведиОшибку("тип expected as second argument of __traits `%s` instead of `%s`",
                e.идент.вТкст0(), o.вТкст0());
            return new ErrorExp();
        }

        Тип tb = t.baseElemOf();
        return tb.isZeroInit(e.место) ? True() : False();
    }
    if (e.идент == Id.getTargetInfo)
    {
        if (dim != 1)
            return dimError(1);

        auto ex = выражение_ли((*e.args)[0]);
        StringExp se = ex ? ex.ctfeInterpret().вТкстExp() : null;
        if (!ex || !se || se.len == 0)
        {
            e.выведиОшибку("ткст expected as argument of __traits `%s` instead of `%s`", e.идент.вТкст0(), ex.вТкст0());
            return new ErrorExp();
        }
        se = se.toUTF8(sc);

        const slice = se.peekString();
        Выражение r = target.getTargetInfo(slice.ptr, e.место); // BUG: reliance on terminating 0
        if (!r)
        {
            e.выведиОшибку("`getTargetInfo` ключ `\"%.*s\"` not supported by this implementation",
                cast(цел)slice.length, slice.ptr);
            return new ErrorExp();
        }
        return r.ВыражениеSemantic(sc);
    }
    if (e.идент == Id.getLocation)
    {
        if (dim != 1)
            return dimError(1);
        auto arg0 = (*e.args)[0];
        ДСимвол s = getDsymbolWithoutExpCtx(arg0);
        if (!s || !s.место.isValid())
        {
            e.выведиОшибку("can only get the location of a symbol, not `%s`", arg0.вТкст0());
            return new ErrorExp();
        }

        const fd = s.isFuncDeclaration();
        // FIXME:td.overnext is always set, even when using an index on it
        //const td = s.isTemplateDeclaration();
        if ((fd && fd.overnext) /*|| (td && td.overnext)*/)
        {
            e.выведиОшибку("cannot get location of an overload set, " ~
                    "use `__traits(getOverloads, ..., \"%s\"%s)[N]` " ~
                    "to get the Nth overload",
                    arg0.вТкст0(), /*td ? ", да".ptr :*/ "".ptr);
            return new ErrorExp();
        }

        auto exps = new Выражения(3);
        (*exps)[0] = new StringExp(e.место, s.место.имяф.вТкстД());
        (*exps)[1] = new IntegerExp(e.место, s.место.номстр,Тип.tint32);
        (*exps)[2] = new IntegerExp(e.место, s.место.имяс,Тип.tint32);
        auto tup = new TupleExp(e.место, exps);
        return tup.ВыражениеSemantic(sc);
    }

    static ткст trait_search_fp(ткст seed, ref цел cost)
    {
        //printf("trait_search_fp('%s')\n", seed);
        if (!seed.length)
            return null;
        cost = 0;
        const sv = traitsStringTable.lookup(seed);
        return sv ? sv.вТкст() : null;
    }

    if (auto sub = speller!(trait_search_fp)(e.идент.вТкст()))
        e.выведиОшибку("unrecognized trait `%s`, did you mean `%.*s`?", e.идент.вТкст0(), sub.length, sub.ptr);
    else
        e.выведиОшибку("unrecognized trait `%s`", e.идент.вТкст0());
    return new ErrorExp();
}
