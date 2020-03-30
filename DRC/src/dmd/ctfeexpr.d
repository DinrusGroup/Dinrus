/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/ctfeexpr.d, _ctfeexpr.d)
 * Documentation:  https://dlang.org/phobos/dmd_ctfeexpr.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/ctfeexpr.d
 */

module dmd.ctfeexpr;

import cidrus;
import dmd.arraytypes;
import dmd.complex;
import dmd.constfold;
import dmd.compiler;
import dmd.dclass;
import dmd.declaration;
import dmd.dinterpret;
import dmd.dstruct;
import dmd.dtemplate;
import dmd.errors;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import dmd.mtype;
import util.ctfloat;
import util.port;
import util.rmem;
import drc.lexer.Tokens;
import drc.ast.Visitor;


/***********************************************************
 * A reference to a class, or an interface. We need this when we
 * point to a base class (we must record what the тип is).
 */
 final class ClassReferenceExp : Выражение
{
    StructLiteralExp значение;

    this(ref Место место, StructLiteralExp lit, Тип тип)
    {
        super(место, ТОК2.classReference, __traits(classInstanceSize, ClassReferenceExp));
        assert(lit && lit.sd && lit.sd.isClassDeclaration());
        this.значение = lit;
        this.тип = тип;
    }

    ClassDeclaration originalClass()
    {
        return значение.sd.isClassDeclaration();
    }

    // Return index of the field, or -1 if not found
    private цел getFieldIndex(Тип fieldtype, бцел fieldoffset)
    {
        ClassDeclaration cd = originalClass();
        бцел fieldsSoFar = 0;
        for (т_мера j = 0; j < значение.elements.dim; j++)
        {
            while (j - fieldsSoFar >= cd.fields.dim)
            {
                fieldsSoFar += cd.fields.dim;
                cd = cd.baseClass;
            }
            VarDeclaration v2 = cd.fields[j - fieldsSoFar];
            if (fieldoffset == v2.смещение && fieldtype.size() == v2.тип.size())
            {
                return cast(цел)(значение.elements.dim - fieldsSoFar - cd.fields.dim + (j - fieldsSoFar));
            }
        }
        return -1;
    }

    // Return index of the field, or -1 if not found
    // Same as getFieldIndex, but checks for a direct match with the VarDeclaration
    цел findFieldIndexByName(VarDeclaration v)
    {
        ClassDeclaration cd = originalClass();
        т_мера fieldsSoFar = 0;
        for (т_мера j = 0; j < значение.elements.dim; j++)
        {
            while (j - fieldsSoFar >= cd.fields.dim)
            {
                fieldsSoFar += cd.fields.dim;
                cd = cd.baseClass;
            }
            VarDeclaration v2 = cd.fields[j - fieldsSoFar];
            if (v == v2)
            {
                return cast(цел)(значение.elements.dim - fieldsSoFar - cd.fields.dim + (j - fieldsSoFar));
            }
        }
        return -1;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/*************************
 * Same as getFieldIndex, but checks for a direct match with the VarDeclaration
 * Возвращает:
 *    index of the field, or -1 if not found
 */
цел findFieldIndexByName(StructDeclaration sd, VarDeclaration v) 
{
    foreach (i, field; sd.fields)
    {
        if (field == v)
            return cast(цел)i;
    }
    return -1;
}

/***********************************************************
 * Fake class which holds the thrown exception.
 * Used for implementing exception handling.
 */
 final class ThrownExceptionExp : Выражение
{
    ClassReferenceExp thrown;   // the thing being tossed

    this(ref Место место, ClassReferenceExp victim)
    {
        super(место, ТОК2.thrownException, __traits(classInstanceSize, ThrownExceptionExp));
        this.thrown = victim;
        this.тип = victim.тип;
    }

    override ткст0 вТкст0()
    {
        return "CTFE ThrownException";
    }

    // Generate an error message when this exception is not caught
    extern (D) проц generateUncaughtError()
    {
        UnionExp ue = проц;
        Выражение e = resolveSlice((*thrown.значение.elements)[0], &ue);
        StringExp se = e.вТкстExp();
        thrown.выведиОшибку("uncaught CTFE exception `%s(%s)`", thrown.тип.вТкст0(), se ? se.вТкст0() : e.вТкст0());
        /* Also give the line where the throw инструкция was. We won't have it
         * in the case where the ThrowStatement is generated internally
         * (eg, in ScopeStatement)
         */
        if (место.isValid() && !место.равен(thrown.место))
            .errorSupplemental(место, "thrown from here");
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * This тип is only используется by the interpreter.
 */
 final class CTFEExp : Выражение
{
    this(ТОК2 tok)
    {
        super(Место.initial, tok, __traits(classInstanceSize, CTFEExp));
        тип = Тип.tvoid;
    }

    override ткст0 вТкст0()
    {
        switch (op)
        {
        case ТОК2.cantВыражение:
            return "<cant>";
        case ТОК2.voidВыражение:
            return "<проц>";
        case ТОК2.showCtfeContext:
            return "<error>";
        case ТОК2.break_:
            return "<break>";
        case ТОК2.continue_:
            return "<continue>";
        case ТОК2.goto_:
            return "<goto>";
        default:
            assert(0);
        }
    }

    extern (D)  CTFEExp cantexp;
    extern (D)  CTFEExp voidexp;
    extern (D)  CTFEExp breakexp;
    extern (D)  CTFEExp continueexp;
    extern (D)  CTFEExp gotoexp;
    /* Used when additional information is needed regarding
     * a ctfe error.
     */
    extern (D)  CTFEExp showcontext;

    extern (D) static бул isCantExp( Выражение e)
    {
        return e && e.op == ТОК2.cantВыражение;
    }

    extern (D) static бул isGotoExp( Выражение e)
    {
        return e && e.op == ТОК2.goto_;
    }
}

// True if 'e' is CTFEExp::cantexp, or an exception
бул exceptionOrCantInterpret( Выражение e)
{
    return e && (e.op == ТОК2.cantВыражение || e.op == ТОК2.thrownException || e.op == ТОК2.showCtfeContext);
}

/************** Aggregate literals (AA/ткст/массив/struct) ******************/
// Given expr, which evaluates to an массив/AA/ткст literal,
// return да if it needs to be copied
бул needToCopyLiteral( Выражение expr)
{
    Выражение e = expr;///*cast()*/expr;
    for (;;)
    {
        switch (e.op)
        {
        case ТОК2.arrayLiteral:
            return (cast(ArrayLiteralExp)e).ownedByCtfe == OwnedBy.code;
        case ТОК2.assocArrayLiteral:
            return (cast(AssocArrayLiteralExp)e).ownedByCtfe == OwnedBy.code;
        case ТОК2.structLiteral:
            return (cast(StructLiteralExp)e).ownedByCtfe == OwnedBy.code;
        case ТОК2.string_:
        case ТОК2.this_:
        case ТОК2.variable:
            return нет;
        case ТОК2.assign:
            return нет;
        case ТОК2.index:
        case ТОК2.dotVariable:
        case ТОК2.slice:
        case ТОК2.cast_:
            e = (cast(UnaExp)e).e1;
            continue;
        case ТОК2.concatenate:
            return needToCopyLiteral((cast(BinExp)e).e1) || needToCopyLiteral((cast(BinExp)e).e2);
        case ТОК2.concatenateAssign:
        case ТОК2.concatenateElemAssign:
        case ТОК2.concatenateDcharAssign:
            e = (cast(BinExp)e).e2;
            continue;
        default:
            return нет;
        }
    }
}

private Выражения* copyLiteralArray(Выражения* oldelems, Выражение basis = null)
{
    if (!oldelems)
        return oldelems;
    incArrayAllocs();
    auto newelems = new Выражения(oldelems.dim);
    foreach (i, el; *oldelems)
    {
        (*newelems)[i] = copyLiteral(el ? el : basis).копируй();
    }
    return newelems;
}

// Make a копируй of the ArrayLiteral, AALiteral, String, or StructLiteral.
// This значение will be используется for in-place modification.
UnionExp copyLiteral(Выражение e)
{
    UnionExp ue = проц;
    if (auto se = e.isStringExp()) // syntaxCopy doesn't make a копируй for StringExp!
    {
        ткст0 s = cast(сим*)mem.xcalloc(se.len + 1, se.sz);
        const slice = se.peekData();
        memcpy(s, slice.ptr, slice.length);
        emplaceExp!(StringExp)(&ue, se.место, s[0 .. se.len * se.sz], se.len, se.sz);
        StringExp se2 = cast(StringExp)ue.exp();
        se2.committed = se.committed;
        se2.postfix = se.postfix;
        se2.тип = se.тип;
        se2.ownedByCtfe = OwnedBy.ctfe;
        return ue;
    }
    if (auto ale = e.isArrayLiteralExp())
    {
        auto elements = copyLiteralArray(ale.elements, ale.basis);

        emplaceExp!(ArrayLiteralExp)(&ue, e.место, e.тип, elements);

        ArrayLiteralExp r = cast(ArrayLiteralExp)ue.exp();
        r.ownedByCtfe = OwnedBy.ctfe;
        return ue;
    }
    if (auto aae = e.isAssocArrayLiteralExp())
    {
        emplaceExp!(AssocArrayLiteralExp)(&ue, e.место, copyLiteralArray(aae.keys), copyLiteralArray(aae.values));
        AssocArrayLiteralExp r = cast(AssocArrayLiteralExp)ue.exp();
        r.тип = e.тип;
        r.ownedByCtfe = OwnedBy.ctfe;
        return ue;
    }
    if (auto sle = e.isStructLiteralExp())
    {
        /* syntaxCopy doesn't work for struct literals, because of a nasty special
         * case: block assignment is permitted inside struct literals, eg,
         * an цел[4] массив can be initialized with a single цел.
         */
        auto oldelems = sle.elements;
        auto newelems = new Выражения(oldelems.dim);
        foreach (i, ref el; *newelems)
        {
            // We need the struct definition to detect block assignment
            auto v = sle.sd.fields[i];
            auto m = (*oldelems)[i];

            // If it is a проц assignment, use the default инициализатор
            if (!m)
                m = voidInitLiteral(v.тип, v).копируй();

            if (v.тип.ty == Tarray || v.тип.ty == Taarray)
            {
                // Don't have to копируй массив references
            }
            else
            {
                // Buzilla 15681: Copy the source element always.
                m = copyLiteral(m).копируй();

                // Block assignment from inside struct literals
                if (v.тип.ty != m.тип.ty && v.тип.ty == Tsarray)
                {
                    auto tsa = v.тип.isTypeSArray();
                    auto len = cast(т_мера)tsa.dim.toInteger();
                    UnionExp uex = проц;
                    m = createBlockDuplicatedArrayLiteral(&uex, e.место, v.тип, m, len);
                    if (m == uex.exp())
                        m = uex.копируй();
                }
            }
            el = m;
        }
        emplaceExp!(StructLiteralExp)(&ue, e.место, sle.sd, newelems, sle.stype);
        auto r = ue.exp().isStructLiteralExp();
        r.тип = e.тип;
        r.ownedByCtfe = OwnedBy.ctfe;
        r.origin = sle.origin;
        return ue;
    }
    if (e.op == ТОК2.function_ || e.op == ТОК2.delegate_ || e.op == ТОК2.symbolOffset || e.op == ТОК2.null_ || e.op == ТОК2.variable || e.op == ТОК2.dotVariable || e.op == ТОК2.int64 || e.op == ТОК2.float64 || e.op == ТОК2.char_ || e.op == ТОК2.complex80 || e.op == ТОК2.void_ || e.op == ТОК2.vector || e.op == ТОК2.typeid_)
    {
        // Simple значение types
        // Keep e1 for DelegateExp and DotVarExp
        emplaceExp!(UnionExp)(&ue, e);
        Выражение r = ue.exp();
        r.тип = e.тип;
        return ue;
    }
    if (auto se = e.isSliceExp())
    {
        if (se.тип.toBasetype().ty == Tsarray)
        {
            // same with resolveSlice()
            if (se.e1.op == ТОК2.null_)
            {
                emplaceExp!(NullExp)(&ue, se.место, se.тип);
                return ue;
            }
            ue = Slice(se.тип, se.e1, se.lwr, se.upr);
            auto r = ue.exp().isArrayLiteralExp();
            r.elements = copyLiteralArray(r.elements);
            r.ownedByCtfe = OwnedBy.ctfe;
            return ue;
        }
        else
        {
            // МассивДРК slices only do a shallow копируй
            emplaceExp!(SliceExp)(&ue, e.место, se.e1, se.lwr, se.upr);
            Выражение r = ue.exp();
            r.тип = e.тип;
            return ue;
        }
    }
    if (isPointer(e.тип))
    {
        // For pointers, we only do a shallow копируй.
        if (auto ae = e.isAddrExp())
            emplaceExp!(AddrExp)(&ue, e.место, ae.e1);
        else if (auto ie = e.isIndexExp())
            emplaceExp!(IndexExp)(&ue, e.место, ie.e1, ie.e2);
        else if (auto dve = e.isDotVarExp())
        {
            emplaceExp!(DotVarExp)(&ue, e.место, dve.e1, dve.var, dve.hasOverloads);
        }
        else
            assert(0);

        Выражение r = ue.exp();
        r.тип = e.тип;
        return ue;
    }
    if (auto cre = e.isClassReferenceExp())
    {
        emplaceExp!(ClassReferenceExp)(&ue, e.место, cre.значение, e.тип);
        return ue;
    }
    if (e.op == ТОК2.error)
    {
        emplaceExp!(UnionExp)(&ue, e);
        return ue;
    }
    e.выведиОшибку("CTFE internal error: literal `%s`", e.вТкст0());
    assert(0);
}

/* Deal with тип painting.
 * Тип painting is a major nuisance: we can't just set
 * e.тип = тип, because that would change the original literal.
 * But, we can't simply копируй the literal either, because that would change
 * the values of any pointers.
 */
Выражение paintTypeOntoLiteral(Тип тип, Выражение lit)
{
    if (lit.тип.равен(тип))
        return lit;
    return paintTypeOntoLiteralCopy(тип, lit).копируй();
}

Выражение paintTypeOntoLiteral(UnionExp* pue, Тип тип, Выражение lit)
{
    if (lit.тип.равен(тип))
        return lit;
    *pue = paintTypeOntoLiteralCopy(тип, lit);
    return pue.exp();
}

private UnionExp paintTypeOntoLiteralCopy(Тип тип, Выражение lit)
{
    UnionExp ue;
    if (lit.тип.равен(тип))
    {
        emplaceExp!(UnionExp)(&ue, lit);
        return ue;
    }
    // If it is a cast to inout, retain the original тип of the referenced part.
    if (тип.hasWild() && тип.hasPointers())
    {
        emplaceExp!(UnionExp)(&ue, lit);
        ue.exp().тип = тип;
        return ue;
    }
    if (auto se = lit.isSliceExp())
    {
        emplaceExp!(SliceExp)(&ue, lit.место, se.e1, se.lwr, se.upr);
    }
    else if (auto ie = lit.isIndexExp())
    {
        emplaceExp!(IndexExp)(&ue, lit.место, ie.e1, ie.e2);
    }
    else if (lit.op == ТОК2.arrayLiteral)
    {
        emplaceExp!(SliceExp)(&ue, lit.место, lit, ctfeEmplaceExp!(IntegerExp)(Место.initial, 0, Тип.tт_мера), ArrayLength(Тип.tт_мера, lit).копируй());
    }
    else if (lit.op == ТОК2.string_)
    {
        // For strings, we need to introduce another уровень of indirection
        emplaceExp!(SliceExp)(&ue, lit.место, lit, ctfeEmplaceExp!(IntegerExp)(Место.initial, 0, Тип.tт_мера), ArrayLength(Тип.tт_мера, lit).копируй());
    }
    else if (auto aae = lit.isAssocArrayLiteralExp())
    {
        // TODO: we should be creating a reference to this AAExp, not
        // just a ref to the keys and values.
        OwnedBy wasOwned = aae.ownedByCtfe;
        emplaceExp!(AssocArrayLiteralExp)(&ue, lit.место, aae.keys, aae.values);
        aae = cast(AssocArrayLiteralExp)ue.exp();
        aae.ownedByCtfe = wasOwned;
    }
    else
    {
        // Can't тип paint from struct to struct*; this needs another
        // уровень of indirection
        if (lit.op == ТОК2.structLiteral && isPointer(тип))
            lit.выведиОшибку("CTFE internal error: painting `%s`", тип.вТкст0());
        ue = copyLiteral(lit);
    }
    ue.exp().тип = тип;
    return ue;
}

/*************************************
 * If e is a SliceExp, constant fold it.
 * Параметры:
 *      e = Выражение to resolve
 *      pue = if not null, store результатing Выражение here
 * Возвращает:
 *      результатing Выражение
 */
Выражение resolveSlice(Выражение e, UnionExp* pue = null)
{
    SliceExp se = e.isSliceExp();
    if (!se)
        return e;
    if (se.e1.op == ТОК2.null_)
        return se.e1;
    if (pue)
    {
        *pue = Slice(e.тип, se.e1, se.lwr, se.upr);
        return pue.exp();
    }
    else
        return Slice(e.тип, se.e1, se.lwr, se.upr).копируй();
}

/* Determine the массив length, without interpreting it.
 * e must be an массив literal, or a slice
 * It's very wasteful to resolve the slice when we only
 * need the length.
 */
uinteger_t resolveArrayLength( Выражение e)
{
    switch (e.op)
    {
        case ТОК2.vector:
            return e.isVectorExp().dim;

        case ТОК2.null_:
            return 0;

        case ТОК2.slice:
        {
            auto se = cast(SliceExp)e;
            const ilo = se.lwr.toInteger();
            const iup = se.upr.toInteger();
            return iup - ilo;
        }

        case ТОК2.string_:
            return e.isStringExp().len;

        case ТОК2.arrayLiteral:
        {
            const ale = e.isArrayLiteralExp();
            return ale.elements ? ale.elements.dim : 0;
        }

        case ТОК2.assocArrayLiteral:
        {
            return e.isAssocArrayLiteralExp().keys.dim;
        }

        default:
            assert(0);
    }
}

/******************************
 * Helper for NewExp
 * Create an массив literal consisting of 'elem' duplicated 'dim' times.
 * Параметры:
 *      pue = where to store результат
 *      место = source location where the interpretation occurs
 *      тип = target тип of the результат
 *      elem = the source of массив element, it will be owned by the результат
 *      dim = element number of the результат
 * Возвращает:
 *      Constructed ArrayLiteralExp
 */
ArrayLiteralExp createBlockDuplicatedArrayLiteral(UnionExp* pue, ref Место место, Тип тип, Выражение elem, т_мера dim)
{
    if (тип.ty == Tsarray && тип.nextOf().ty == Tsarray && elem.тип.ty != Tsarray)
    {
        // If it is a multidimensional массив literal, do it recursively
        auto tsa = тип.nextOf().isTypeSArray();
        const len = cast(т_мера)tsa.dim.toInteger();
        UnionExp ue = проц;
        elem = createBlockDuplicatedArrayLiteral(&ue, место, тип.nextOf(), elem, len);
        if (elem == ue.exp())
            elem = ue.копируй();
    }

    // Buzilla 15681
    const tb = elem.тип.toBasetype();
    const mustCopy = tb.ty == Tstruct || tb.ty == Tsarray;

    auto elements = new Выражения(dim);
    foreach (i, ref el; *elements)
    {
        el = mustCopy && i ? copyLiteral(elem).копируй() : elem;
    }
    emplaceExp!(ArrayLiteralExp)(pue, место, тип, elements);
    auto ale = pue.exp().isArrayLiteralExp();
    ale.ownedByCtfe = OwnedBy.ctfe;
    return ale;
}

/******************************
 * Helper for NewExp
 * Create a ткст literal consisting of 'значение' duplicated 'dim' times.
 */
StringExp createBlockDuplicatedStringLiteral(UnionExp* pue, ref Место место, Тип тип, dchar значение, т_мера dim, ббайт sz)
{
    auto s = cast(сим*)mem.xcalloc(dim, sz);
    foreach (elemi; new бцел[0 .. dim])
    {
        switch (sz)
        {
        case 1:
            s[elemi] = cast(сим)значение;
            break;
        case 2:
            (cast(wchar*)s)[elemi] = cast(wchar)значение;
            break;
        case 4:
            (cast(dchar*)s)[elemi] = значение;
            break;
        default:
            assert(0);
        }
    }
    emplaceExp!(StringExp)(pue, место, s[0 .. dim * sz], dim, sz);
    auto se = pue.exp().isStringExp();
    se.тип = тип;
    se.committed = да;
    se.ownedByCtfe = OwnedBy.ctfe;
    return se;
}

// Return да if t is an AA
бул isAssocArray(Тип t)
{
    return t.toBasetype().isTypeAArray() !is null;
}

// Given a template AA тип, extract the corresponding built-in AA тип
TypeAArray toBuiltinAAType(Тип t)
{
    return t.toBasetype().isTypeAArray();
}

/************** TypeInfo operations ************************************/
// Return да if тип is TypeInfo_Class
бул isTypeInfo_Class( Тип тип)
{
    auto tc = /*cast()*/тип.isTypeClass();
    return tc && (Тип.dtypeinfo == tc.sym || Тип.dtypeinfo.isBaseOf(tc.sym, null));
}

/************** Pointer operations ************************************/
// Return да if t is a pointer (not a function pointer)
бул isPointer(Тип t)
{
    Тип tb = t.toBasetype();
    return tb.ty == Tpointer && tb.nextOf().ty != Tfunction;
}

// For CTFE only. Возвращает да if 'e' is да or a non-null pointer.
бул isTrueBool(Выражение e)
{
    return e.isBool(да) || ((e.тип.ty == Tpointer || e.тип.ty == Tclass) && e.op != ТОК2.null_);
}

/* Is it safe to convert from srcPointee* to destPointee* ?
 * srcPointee is the genuine тип (never проц).
 * destPointee may be проц.
 */
бул isSafePointerCast(Тип srcPointee, Тип destPointee)
{
    // It's safe to cast S** to D** if it's OK to cast S* to D*
    while (srcPointee.ty == Tpointer && destPointee.ty == Tpointer)
    {
        srcPointee = srcPointee.nextOf();
        destPointee = destPointee.nextOf();
    }
    // It's OK if both are the same (modulo const)
    if (srcPointee.constConv(destPointee))
        return да;
    // It's OK if function pointers differ only in safe//
    if (srcPointee.ty == Tfunction && destPointee.ty == Tfunction)
        return srcPointee.covariant(destPointee) == 1;
    // it's OK to cast to ук
    if (destPointee.ty == Tvoid)
        return да;
    // It's OK to cast from V[K] to ук
    if (srcPointee.ty == Taarray && destPointee == Тип.tvoidptr)
        return да;
    // It's OK if they are the same size (static массив of) integers, eg:
    //     цел*     --> бцел*
    //     цел[5][] --> бцел[5][]
    if (srcPointee.ty == Tsarray && destPointee.ty == Tsarray)
    {
        if (srcPointee.size() != destPointee.size())
            return нет;
        srcPointee = srcPointee.baseElemOf();
        destPointee = destPointee.baseElemOf();
    }
    return srcPointee.isintegral() && destPointee.isintegral() && srcPointee.size() == destPointee.size();
}

Выражение getAggregateFromPointer(Выражение e, dinteger_t* ofs)
{
    *ofs = 0;
    if (auto ae = e.isAddrExp())
        e = ae.e1;
    if (auto soe = e.isSymOffExp())
        *ofs = soe.смещение;
    if (auto dve = e.isDotVarExp())
    {
        const ex = dve.e1;
        const v = dve.var.isVarDeclaration();
        assert(v);
        StructLiteralExp se = (ex.op == ТОК2.classReference)
            ? (cast(ClassReferenceExp)ex).значение
            : cast(StructLiteralExp)ex;

        // We can't use getField, because it makes a копируй
        const i = (ex.op == ТОК2.classReference)
            ? (cast(ClassReferenceExp)ex).getFieldIndex(e.тип, v.смещение)
            : se.getFieldIndex(e.тип, v.смещение);
        e = (*se.elements)[i];
    }
    if (auto ie = e.isIndexExp())
    {
        // Note that each AA element is part of its own memory block
        if ((ie.e1.тип.ty == Tarray || ie.e1.тип.ty == Tsarray || ie.e1.op == ТОК2.string_ || ie.e1.op == ТОК2.arrayLiteral) && ie.e2.op == ТОК2.int64)
        {
            *ofs = ie.e2.toInteger();
            return ie.e1;
        }
    }
    if (auto se = e.isSliceExp())
    {
        if (se && e.тип.toBasetype().ty == Tsarray &&
           (se.e1.тип.ty == Tarray || se.e1.тип.ty == Tsarray || se.e1.op == ТОК2.string_ || se.e1.op == ТОК2.arrayLiteral) && se.lwr.op == ТОК2.int64)
        {
            *ofs = se.lwr.toInteger();
            return se.e1;
        }
    }
    return e;
}

/** Return да if agg1 and agg2 are pointers to the same memory block
 */
бул pointToSameMemoryBlock(Выражение agg1, Выражение agg2)
{
    if (agg1 == agg2)
        return да;
    // For integers cast to pointers, we regard them as non-comparable
    // unless they are identical. (This may be overly strict).
    if (agg1.op == ТОК2.int64 && agg2.op == ТОК2.int64 && agg1.toInteger() == agg2.toInteger())
    {
        return да;
    }
    // Note that тип painting can occur with VarExp, so we
    // must compare the variables being pointed to.
    if (agg1.op == ТОК2.variable && agg2.op == ТОК2.variable && (cast(VarExp)agg1).var == (cast(VarExp)agg2).var)
    {
        return да;
    }
    if (agg1.op == ТОК2.symbolOffset && agg2.op == ТОК2.symbolOffset && (cast(SymOffExp)agg1).var == (cast(SymOffExp)agg2).var)
    {
        return да;
    }
    return нет;
}

// return e1 - e2 as an integer, or error if not possible
UnionExp pointerDifference(ref Место место, Тип тип, Выражение e1, Выражение e2)
{
    UnionExp ue = проц;
    dinteger_t ofs1, ofs2;
    Выражение agg1 = getAggregateFromPointer(e1, &ofs1);
    Выражение agg2 = getAggregateFromPointer(e2, &ofs2);
    if (agg1 == agg2)
    {
        Тип pointee = (cast(TypePointer)agg1.тип).следщ;
        const sz = pointee.size();
        emplaceExp!(IntegerExp)(&ue, место, (ofs1 - ofs2) * sz, тип);
    }
    else if (agg1.op == ТОК2.string_ && agg2.op == ТОК2.string_ &&
             (cast(StringExp)agg1).peekString().ptr == (cast(StringExp)agg2).peekString().ptr)
    {
        Тип pointee = (cast(TypePointer)agg1.тип).следщ;
        const sz = pointee.size();
        emplaceExp!(IntegerExp)(&ue, место, (ofs1 - ofs2) * sz, тип);
    }
    else if (agg1.op == ТОК2.symbolOffset && agg2.op == ТОК2.symbolOffset &&
             (cast(SymOffExp)agg1).var == (cast(SymOffExp)agg2).var)
    {
        emplaceExp!(IntegerExp)(&ue, место, ofs1 - ofs2, тип);
    }
    else
    {
        выведиОшибку(место, "`%s - %s` cannot be interpreted at compile time: cannot subtract pointers to two different memory blocks", e1.вТкст0(), e2.вТкст0());
        emplaceExp!(CTFEExp)(&ue, ТОК2.cantВыражение);
    }
    return ue;
}

// Return eptr op e2, where eptr is a pointer, e2 is an integer,
// and op is ТОК2.add or ТОК2.min
UnionExp pointerArithmetic(ref Место место, ТОК2 op, Тип тип, Выражение eptr, Выражение e2)
{
    UnionExp ue;
    if (eptr.тип.nextOf().ty == Tvoid)
    {
        выведиОшибку(место, "cannot perform arithmetic on `ук` pointers at compile time");
    Lcant:
        emplaceExp!(CTFEExp)(&ue, ТОК2.cantВыражение);
        return ue;
    }
    if (eptr.op == ТОК2.address)
        eptr = (cast(AddrExp)eptr).e1;
    dinteger_t ofs1;
    Выражение agg1 = getAggregateFromPointer(eptr, &ofs1);
    if (agg1.op == ТОК2.symbolOffset)
    {
        if ((cast(SymOffExp)agg1).var.тип.ty != Tsarray)
        {
            выведиОшибку(место, "cannot perform pointer arithmetic on arrays of unknown length at compile time");
            goto Lcant;
        }
    }
    else if (agg1.op != ТОК2.string_ && agg1.op != ТОК2.arrayLiteral)
    {
        выведиОшибку(место, "cannot perform pointer arithmetic on non-arrays at compile time");
        goto Lcant;
    }
    dinteger_t ofs2 = e2.toInteger();
    Тип pointee = (cast(TypeNext)agg1.тип.toBasetype()).следщ;
    dinteger_t sz = pointee.size();
    sinteger_t indx;
    dinteger_t len;
    if (agg1.op == ТОК2.symbolOffset)
    {
        indx = ofs1 / sz;
        len = (cast(TypeSArray)(cast(SymOffExp)agg1).var.тип).dim.toInteger();
    }
    else
    {
        Выражение dollar = ArrayLength(Тип.tт_мера, agg1).копируй();
        assert(!CTFEExp.isCantExp(dollar));
        indx = ofs1;
        len = dollar.toInteger();
    }
    if (op == ТОК2.add || op == ТОК2.addAssign || op == ТОК2.plusPlus)
        indx += ofs2 / sz;
    else if (op == ТОК2.min || op == ТОК2.minAssign || op == ТОК2.minusMinus)
        indx -= ofs2 / sz;
    else
    {
        выведиОшибку(место, "CTFE internal error: bad pointer operation");
        goto Lcant;
    }
    if (indx < 0 || len < indx)
    {
        выведиОшибку(место, "cannot assign pointer to index %lld inside memory block `[0..%lld]`", indx, len);
        goto Lcant;
    }
    if (agg1.op == ТОК2.symbolOffset)
    {
        emplaceExp!(SymOffExp)(&ue, место, (cast(SymOffExp)agg1).var, indx * sz);
        SymOffExp se = cast(SymOffExp)ue.exp();
        se.тип = тип;
        return ue;
    }
    if (agg1.op != ТОК2.arrayLiteral && agg1.op != ТОК2.string_)
    {
        выведиОшибку(место, "CTFE internal error: pointer arithmetic `%s`", agg1.вТкст0());
        goto Lcant;
    }
    if (eptr.тип.toBasetype().ty == Tsarray)
    {
        dinteger_t dim = (cast(TypeSArray)eptr.тип.toBasetype()).dim.toInteger();
        // Create a CTFE pointer &agg1[indx .. indx+dim]
        auto se = ctfeEmplaceExp!(SliceExp)(место, agg1,
                ctfeEmplaceExp!(IntegerExp)(место, indx, Тип.tт_мера),
                ctfeEmplaceExp!(IntegerExp)(место, indx + dim, Тип.tт_мера));
        se.тип = тип.toBasetype().nextOf();
        emplaceExp!(AddrExp)(&ue, место, se);
        ue.exp().тип = тип;
        return ue;
    }
    // Create a CTFE pointer &agg1[indx]
    auto ofs = ctfeEmplaceExp!(IntegerExp)(место, indx, Тип.tт_мера);
    Выражение ie = ctfeEmplaceExp!(IndexExp)(место, agg1, ofs);
    ie.тип = тип.toBasetype().nextOf(); // https://issues.dlang.org/show_bug.cgi?ид=13992
    emplaceExp!(AddrExp)(&ue, место, ie);
    ue.exp().тип = тип;
    return ue;
}

// Return 1 if да, 0 if нет
// -1 if comparison is illegal because they point to non-comparable memory blocks
цел comparePointers(ТОК2 op, Выражение agg1, dinteger_t ofs1, Выражение agg2, dinteger_t ofs2)
{
    if (pointToSameMemoryBlock(agg1, agg2))
    {
        цел n;
        switch (op)
        {
        case ТОК2.lessThan:
            n = (ofs1 < ofs2);
            break;
        case ТОК2.lessOrEqual:
            n = (ofs1 <= ofs2);
            break;
        case ТОК2.greaterThan:
            n = (ofs1 > ofs2);
            break;
        case ТОК2.greaterOrEqual:
            n = (ofs1 >= ofs2);
            break;
        case ТОК2.identity:
        case ТОК2.equal:
            n = (ofs1 == ofs2);
            break;
        case ТОК2.notIdentity:
        case ТОК2.notEqual:
            n = (ofs1 != ofs2);
            break;
        default:
            assert(0);
        }
        return n;
    }
    const null1 = (agg1.op == ТОК2.null_);
    const null2 = (agg2.op == ТОК2.null_);
    цел cmp;
    if (null1 || null2)
    {
        switch (op)
        {
        case ТОК2.lessThan:
            cmp = null1 && !null2;
            break;
        case ТОК2.greaterThan:
            cmp = !null1 && null2;
            break;
        case ТОК2.lessOrEqual:
            cmp = null1;
            break;
        case ТОК2.greaterOrEqual:
            cmp = null2;
            break;
        case ТОК2.identity:
        case ТОК2.equal:
        case ТОК2.notIdentity: // 'cmp' gets inverted below
        case ТОК2.notEqual:
            cmp = (null1 == null2);
            break;
        default:
            assert(0);
        }
    }
    else
    {
        switch (op)
        {
        case ТОК2.identity:
        case ТОК2.equal:
        case ТОК2.notIdentity: // 'cmp' gets inverted below
        case ТОК2.notEqual:
            cmp = 0;
            break;
        default:
            return -1; // memory blocks are different
        }
    }
    if (op == ТОК2.notIdentity || op == ТОК2.notEqual)
        cmp ^= 1;
    return cmp;
}

// True if conversion from тип 'from' to 'to' involves a reinterpret_cast
// floating point -> integer or integer -> floating point
бул isFloatIntPaint(Тип to, Тип from)
{
    return from.size() == to.size() && (from.isintegral() && to.isfloating() || from.isfloating() && to.isintegral());
}

// Reinterpret float/цел значение 'fromVal' as a float/integer of тип 'to'.
Выражение paintFloatInt(UnionExp* pue, Выражение fromVal, Тип to)
{
    if (exceptionOrCantInterpret(fromVal))
        return fromVal;
    assert(to.size() == 4 || to.size() == 8);
    return Compiler.paintAsType(pue, fromVal, to);
}

/******** Constant folding, with support for CTFE ***************************/
/// Return да if non-pointer Выражение e can be compared
/// with >,is, ==, etc, using ctfeCmp, ctfeEqual, ctfeIdentity
бул isCtfeComparable(Выражение e)
{
    if (e.op == ТОК2.slice)
        e = (cast(SliceExp)e).e1;
    if (e.isConst() != 1)
    {
        if (e.op == ТОК2.null_ || e.op == ТОК2.string_ || e.op == ТОК2.function_ || e.op == ТОК2.delegate_ || e.op == ТОК2.arrayLiteral || e.op == ТОК2.structLiteral || e.op == ТОК2.assocArrayLiteral || e.op == ТОК2.classReference)
        {
            return да;
        }
        // https://issues.dlang.org/show_bug.cgi?ид=14123
        // TypeInfo объект is comparable in CTFE
        if (e.op == ТОК2.typeid_)
            return да;
        return нет;
    }
    return да;
}

/// Map ТОК2 comparison ops
private бул numCmp(N)(ТОК2 op, N n1, N n2)
{
    switch (op)
    {
    case ТОК2.lessThan:
        return n1 < n2;
    case ТОК2.lessOrEqual:
        return n1 <= n2;
    case ТОК2.greaterThan:
        return n1 > n2;
    case ТОК2.greaterOrEqual:
        return n1 >= n2;

    default:
        assert(0);
    }
}

/// Возвращает cmp OP 0; where OP is ==, !=, <, >=, etc. результат is 0 or 1
бул specificCmp(ТОК2 op, цел rawCmp)
{
    return numCmp!(цел)(op, rawCmp, 0);
}

/// Возвращает e1 OP e2; where OP is ==, !=, <, >=, etc. результат is 0 or 1
бул intUnsignedCmp(ТОК2 op, dinteger_t n1, dinteger_t n2)
{
    return numCmp!(dinteger_t)(op, n1, n2);
}

/// Возвращает e1 OP e2; where OP is ==, !=, <, >=, etc. результат is 0 or 1
бул intSignedCmp(ТОК2 op, sinteger_t n1, sinteger_t n2)
{
    return numCmp!(sinteger_t)(op, n1, n2);
}

/// Возвращает e1 OP e2; where OP is ==, !=, <, >=, etc. результат is 0 or 1
бул realCmp(ТОК2 op, real_t r1, real_t r2)
{
    // Don't rely on compiler, handle NAN arguments separately
    if (CTFloat.isNaN(r1) || CTFloat.isNaN(r2)) // if unordered
    {
        switch (op)
        {
        case ТОК2.lessThan:
        case ТОК2.lessOrEqual:
        case ТОК2.greaterThan:
        case ТОК2.greaterOrEqual:
            return нет;

        default:
            assert(0);
        }
    }
    else
    {
        return numCmp!(real_t)(op, r1, r2);
    }
}

/* Conceptually the same as memcmp(e1, e2).
 * e1 and e2 may be strings, arrayliterals, or slices.
 * For ткст types, return <0 if e1 < e2, 0 if e1==e2, >0 if e1 > e2.
 * For all other types, return 0 if e1 == e2, !=0 if e1 != e2.
 * Возвращает:
 *      -1,0,1
 */
private цел ctfeCmpArrays(ref Место место, Выражение e1, Выражение e2, uinteger_t len)
{
    // Resolve slices, if necessary
    uinteger_t lo1 = 0;
    uinteger_t lo2 = 0;

    Выражение x1 = e1;
    if (auto sle1 = x1.isSliceExp())
    {
        lo1 = sle1.lwr.toInteger();
        x1 = sle1.e1;
    }
    auto se1 = x1.isStringExp();
    auto ae1 = x1.isArrayLiteralExp();

    Выражение x2 = e2;
    if (auto sle2 = x2.isSliceExp())
    {
        lo2 = sle2.lwr.toInteger();
        x2 = sle2.e1;
    }
    auto se2 = x2.isStringExp();
    auto ae2 = x2.isArrayLiteralExp();

    // Now both must be either ТОК2.arrayLiteral or ТОК2.string_
    if (se1 && se2)
        return sliceCmpStringWithString(se1, se2, cast(т_мера)lo1, cast(т_мера)lo2, cast(т_мера)len);
    if (se1 && ae2)
        return sliceCmpStringWithArray(se1, ae2, cast(т_мера)lo1, cast(т_мера)lo2, cast(т_мера)len);
    if (se2 && ae1)
        return -sliceCmpStringWithArray(se2, ae1, cast(т_мера)lo2, cast(т_мера)lo1, cast(т_мера)len);
    assert(ae1 && ae2);
    // Comparing two массив literals. This case is potentially recursive.
    // If they aren't strings, we just need an equality check rather than
    // a full cmp.
    const бул needCmp = ae1.тип.nextOf().isintegral();
    foreach (т_мера i; new бцел[0 .. cast(т_мера)len])
    {
        Выражение ee1 = (*ae1.elements)[cast(т_мера)(lo1 + i)];
        Выражение ee2 = (*ae2.elements)[cast(т_мера)(lo2 + i)];
        if (needCmp)
        {
            const sinteger_t c = ee1.toInteger() - ee2.toInteger();
            if (c > 0)
                return 1;
            if (c < 0)
                return -1;
        }
        else
        {
            if (ctfeRawCmp(место, ee1, ee2))
                return 1;
        }
    }
    return 0;
}

/* Given a delegate Выражение e, return .funcptr.
 * If e is NullExp, return NULL.
 */
private FuncDeclaration funcptrOf(Выражение e)
{
    assert(e.тип.ty == Tdelegate);
    if (auto de = e.isDelegateExp())
        return de.func;
    if (auto fe = e.isFuncExp())
        return fe.fd;
    assert(e.op == ТОК2.null_);
    return null;
}

private бул isArray(Выражение e)
{
    return e.op == ТОК2.arrayLiteral || e.op == ТОК2.string_ || e.op == ТОК2.slice || e.op == ТОК2.null_;
}

/*****
 * Параметры:
 *      место = source файл location
 *      e1 = left operand
 *      e2 = right operand
 *      identity = да for `is` identity comparisons
 * Возвращает:
 * For strings, return <0 if e1 < e2, 0 if e1==e2, >0 if e1 > e2.
 * For all other types, return 0 if e1 == e2, !=0 if e1 != e2.
 */
private цел ctfeRawCmp(ref Место место, Выражение e1, Выражение e2, бул identity = нет)
{
    if (e1.op == ТОК2.classReference || e2.op == ТОК2.classReference)
    {
        if (e1.op == ТОК2.classReference && e2.op == ТОК2.classReference &&
            (cast(ClassReferenceExp)e1).значение == (cast(ClassReferenceExp)e2).значение)
            return 0;
        return 1;
    }
    if (e1.op == ТОК2.typeid_ && e2.op == ТОК2.typeid_)
    {
        // printf("e1: %s\n", e1.вТкст0());
        // printf("e2: %s\n", e2.вТкст0());
        Тип t1 = тип_ли((cast(TypeidExp)e1).obj);
        Тип t2 = тип_ли((cast(TypeidExp)e2).obj);
        assert(t1);
        assert(t2);
        return t1 != t2;
    }
    // null == null, regardless of тип
    if (e1.op == ТОК2.null_ && e2.op == ТОК2.null_)
        return 0;
    if (e1.тип.ty == Tpointer && e2.тип.ty == Tpointer)
    {
        // Can only be an equality test.
        dinteger_t ofs1, ofs2;
        Выражение agg1 = getAggregateFromPointer(e1, &ofs1);
        Выражение agg2 = getAggregateFromPointer(e2, &ofs2);
        if ((agg1 == agg2) || (agg1.op == ТОК2.variable && agg2.op == ТОК2.variable && (cast(VarExp)agg1).var == (cast(VarExp)agg2).var))
        {
            if (ofs1 == ofs2)
                return 0;
        }
        return 1;
    }
    if (e1.тип.ty == Tdelegate && e2.тип.ty == Tdelegate)
    {
        // If .funcptr isn't the same, they are not equal
        if (funcptrOf(e1) != funcptrOf(e2))
            return 1;
        // If both are delegate literals, assume they have the
        // same closure pointer. TODO: We don't support closures yet!
        if (e1.op == ТОК2.function_ && e2.op == ТОК2.function_)
            return 0;
        assert(e1.op == ТОК2.delegate_ && e2.op == ТОК2.delegate_);
        // Same .funcptr. Do they have the same .ptr?
        Выражение ptr1 = (cast(DelegateExp)e1).e1;
        Выражение ptr2 = (cast(DelegateExp)e2).e1;
        dinteger_t ofs1, ofs2;
        Выражение agg1 = getAggregateFromPointer(ptr1, &ofs1);
        Выражение agg2 = getAggregateFromPointer(ptr2, &ofs2);
        // If they are ТОК2.variable, it means they are FuncDeclarations
        if ((agg1 == agg2 && ofs1 == ofs2) || (agg1.op == ТОК2.variable && agg2.op == ТОК2.variable && (cast(VarExp)agg1).var == (cast(VarExp)agg2).var))
        {
            return 0;
        }
        return 1;
    }
    if (isArray(e1) && isArray(e2))
    {
        const uinteger_t len1 = resolveArrayLength(e1);
        const uinteger_t len2 = resolveArrayLength(e2);
        // workaround for dmc optimizer bug calculating wrong len for
        // uinteger_t len = (len1 < len2 ? len1 : len2);
        // if (len == 0) ...
        if (len1 > 0 && len2 > 0)
        {
            const uinteger_t len = (len1 < len2 ? len1 : len2);
            const цел res = ctfeCmpArrays(место, e1, e2, len);
            if (res != 0)
                return res;
        }
        return cast(цел)(len1 - len2);
    }
    if (e1.тип.isintegral())
    {
        return e1.toInteger() != e2.toInteger();
    }
    if (e1.тип.isreal() || e1.тип.isimaginary())
    {
        real_t r1 = e1.тип.isreal() ? e1.toReal() : e1.toImaginary();
        real_t r2 = e1.тип.isreal() ? e2.toReal() : e2.toImaginary();
        if (identity)
            return !RealIdentical(r1, r2);
        if (CTFloat.isNaN(r1) || CTFloat.isNaN(r2)) // if unordered
        {
            return 1;   // they are not equal
        }
        else
        {
            return (r1 != r2);
        }
    }
    else if (e1.тип.iscomplex())
    {
        auto c1 = e1.toComplex();
        auto c2 = e2.toComplex();
        if (identity)
        {
            return !RealIdentical(c1.re, c2.re) && !RealIdentical(c1.im, c2.im);
        }
        return c1 != c2;
    }
    if (e1.op == ТОК2.structLiteral && e2.op == ТОК2.structLiteral)
    {
        StructLiteralExp es1 = cast(StructLiteralExp)e1;
        StructLiteralExp es2 = cast(StructLiteralExp)e2;
        // For structs, we only need to return 0 or 1 (< and > aren't legal).
        if (es1.sd != es2.sd)
            return 1;
        else if ((!es1.elements || !es1.elements.dim) && (!es2.elements || !es2.elements.dim))
            return 0; // both arrays are empty
        else if (!es1.elements || !es2.elements)
            return 1;
        else if (es1.elements.dim != es2.elements.dim)
            return 1;
        else
        {
            foreach (т_мера i; new бцел[0 .. es1.elements.dim])
            {
                Выражение ee1 = (*es1.elements)[i];
                Выражение ee2 = (*es2.elements)[i];

                // https://issues.dlang.org/show_bug.cgi?ид=16284
                if (ee1.op == ТОК2.void_ && ee2.op == ТОК2.void_) // if both are VoidInitExp
                    continue;

                if (ee1 == ee2)
                    continue;
                if (!ee1 || !ee2)
                    return 1;
                const цел cmp = ctfeRawCmp(место, ee1, ee2, identity);
                if (cmp)
                    return 1;
            }
            return 0; // All elements are equal
        }
    }
    if (e1.op == ТОК2.assocArrayLiteral && e2.op == ТОК2.assocArrayLiteral)
    {
        AssocArrayLiteralExp es1 = cast(AssocArrayLiteralExp)e1;
        AssocArrayLiteralExp es2 = cast(AssocArrayLiteralExp)e2;
        т_мера dim = es1.keys.dim;
        if (es2.keys.dim != dim)
            return 1;
        бул* используется = cast(бул*)mem.xmalloc(бул.sizeof * dim);
        memset(используется, 0, бул.sizeof * dim);
        foreach (т_мера i; new бцел[0 .. dim])
        {
            Выражение k1 = (*es1.keys)[i];
            Выражение v1 = (*es1.values)[i];
            Выражение v2 = null;
            foreach (т_мера j; new бцел[0 .. dim])
            {
                if (используется[j])
                    continue;
                Выражение k2 = (*es2.keys)[j];
                if (ctfeRawCmp(место, k1, k2, identity))
                    continue;
                используется[j] = да;
                v2 = (*es2.values)[j];
                break;
            }
            if (!v2 || ctfeRawCmp(место, v1, v2, identity))
            {
                mem.xfree(используется);
                return 1;
            }
        }
        mem.xfree(используется);
        return 0;
    }
    выведиОшибку(место, "CTFE internal error: bad compare of `%s` and `%s`", e1.вТкст0(), e2.вТкст0());
    assert(0);
}

/// Evaluate ==, !=.  Resolves slices before comparing. Возвращает 0 or 1
бул ctfeEqual(ref Место место, ТОК2 op, Выражение e1, Выражение e2)
{
    return !ctfeRawCmp(место, e1, e2) ^ (op == ТОК2.notEqual);
}

/// Evaluate is, !is.  Resolves slices before comparing. Возвращает 0 or 1
бул ctfeIdentity(ref Место место, ТОК2 op, Выражение e1, Выражение e2)
{
    //printf("ctfeIdentity %s %s\n", e1.вТкст0(), e2.вТкст0());
    //printf("ctfeIdentity op = '%s', e1 = %s %s, e2 = %s %s\n", Сема2::вТкст0(op),
    //    Сема2::вТкст0(e1.op), e1.вТкст0(), Сема2::вТкст0(e2.op), e1.вТкст0());
    бул cmp;
    if (e1.op == ТОК2.null_)
    {
        cmp = (e2.op == ТОК2.null_);
    }
    else if (e2.op == ТОК2.null_)
    {
        cmp = нет;
    }
    else if (e1.op == ТОК2.symbolOffset && e2.op == ТОК2.symbolOffset)
    {
        SymOffExp es1 = cast(SymOffExp)e1;
        SymOffExp es2 = cast(SymOffExp)e2;
        cmp = (es1.var == es2.var && es1.смещение == es2.смещение);
    }
    else if (e1.тип.isreal())
        cmp = RealIdentical(e1.toReal(), e2.toReal());
    else if (e1.тип.isimaginary())
        cmp = RealIdentical(e1.toImaginary(), e2.toImaginary());
    else if (e1.тип.iscomplex())
    {
        complex_t v1 = e1.toComplex();
        complex_t v2 = e2.toComplex();
        cmp = RealIdentical(creall(v1), creall(v2)) && RealIdentical(cimagl(v1), cimagl(v1));
    }
    else
    {
        cmp = !ctfeRawCmp(место, e1, e2, да);
    }
    if (op == ТОК2.notIdentity || op == ТОК2.notEqual)
        cmp ^= да;
    return cmp;
}

/// Evaluate >,<=, etc. Resolves slices before comparing. Возвращает 0 or 1
бул ctfeCmp(ref Место место, ТОК2 op, Выражение e1, Выражение e2)
{
    Тип t1 = e1.тип.toBasetype();
    Тип t2 = e2.тип.toBasetype();

    if (t1.isString() && t2.isString())
        return specificCmp(op, ctfeRawCmp(место, e1, e2));
    else if (t1.isreal())
        return realCmp(op, e1.toReal(), e2.toReal());
    else if (t1.isimaginary())
        return realCmp(op, e1.toImaginary(), e2.toImaginary());
    else if (t1.isunsigned() || t2.isunsigned())
        return intUnsignedCmp(op, e1.toInteger(), e2.toInteger());
    else
        return intSignedCmp(op, e1.toInteger(), e2.toInteger());
}

UnionExp ctfeCat(ref Место место, Тип тип, Выражение e1, Выражение e2)
{
    Тип t1 = e1.тип.toBasetype();
    Тип t2 = e2.тип.toBasetype();
    UnionExp ue;
    if (e2.op == ТОК2.string_ && e1.op == ТОК2.arrayLiteral && t1.nextOf().isintegral())
    {
        // [chars] ~ ткст => ткст (only valid for CTFE)
        StringExp es1 = cast(StringExp)e2;
        ArrayLiteralExp es2 = cast(ArrayLiteralExp)e1;
        const len = es1.len + es2.elements.dim;
        const sz = es1.sz;
        ук s = mem.xmalloc((len + 1) * sz);
        const data1 = es1.peekData();
        memcpy(cast(сим*)s + sz * es2.elements.dim, data1.ptr, data1.length);
        foreach (т_мера i; new бцел[0 .. es2.elements.dim])
        {
            Выражение es2e = (*es2.elements)[i];
            if (es2e.op != ТОК2.int64)
            {
                emplaceExp!(CTFEExp)(&ue, ТОК2.cantВыражение);
                return ue;
            }
            dinteger_t v = es2e.toInteger();
            Port.valcpy(cast(сим*)s + i * sz, v, sz);
        }
        // Add terminating 0
        memset(cast(сим*)s + len * sz, 0, sz);
        emplaceExp!(StringExp)(&ue, место, s[0 .. len * sz], len, sz);
        StringExp es = cast(StringExp)ue.exp();
        es.committed = 0;
        es.тип = тип;
        return ue;
    }
    if (e1.op == ТОК2.string_ && e2.op == ТОК2.arrayLiteral && t2.nextOf().isintegral())
    {
        // ткст ~ [chars] => ткст (only valid for CTFE)
        // Concatenate the strings
        StringExp es1 = cast(StringExp)e1;
        ArrayLiteralExp es2 = cast(ArrayLiteralExp)e2;
        const len = es1.len + es2.elements.dim;
        const sz = es1.sz;
        ук s = mem.xmalloc((len + 1) * sz);
        auto slice = es1.peekData();
        memcpy(s, slice.ptr, slice.length);
        foreach (т_мера i; new бцел[0 .. es2.elements.dim])
        {
            Выражение es2e = (*es2.elements)[i];
            if (es2e.op != ТОК2.int64)
            {
                emplaceExp!(CTFEExp)(&ue, ТОК2.cantВыражение);
                return ue;
            }
            const v = es2e.toInteger();
            Port.valcpy(cast(сим*)s + (es1.len + i) * sz, v, sz);
        }
        // Add terminating 0
        memset(cast(сим*)s + len * sz, 0, sz);
        emplaceExp!(StringExp)(&ue, место, s[0 .. len * sz], len, sz);
        StringExp es = cast(StringExp)ue.exp();
        es.sz = sz;
        es.committed = 0; //es1.committed;
        es.тип = тип;
        return ue;
    }
    if (e1.op == ТОК2.arrayLiteral && e2.op == ТОК2.arrayLiteral && t1.nextOf().равен(t2.nextOf()))
    {
        //  [ e1 ] ~ [ e2 ] ---> [ e1, e2 ]
        ArrayLiteralExp es1 = cast(ArrayLiteralExp)e1;
        ArrayLiteralExp es2 = cast(ArrayLiteralExp)e2;
        emplaceExp!(ArrayLiteralExp)(&ue, es1.место, тип, copyLiteralArray(es1.elements));
        es1 = cast(ArrayLiteralExp)ue.exp();
        es1.elements.вставь(es1.elements.dim, copyLiteralArray(es2.elements));
        return ue;
    }
    if (e1.op == ТОК2.arrayLiteral && e2.op == ТОК2.null_ && t1.nextOf().равен(t2.nextOf()))
    {
        //  [ e1 ] ~ null ----> [ e1 ].dup
        ue = paintTypeOntoLiteralCopy(тип, copyLiteral(e1).копируй());
        return ue;
    }
    if (e1.op == ТОК2.null_ && e2.op == ТОК2.arrayLiteral && t1.nextOf().равен(t2.nextOf()))
    {
        //  null ~ [ e2 ] ----> [ e2 ].dup
        ue = paintTypeOntoLiteralCopy(тип, copyLiteral(e2).копируй());
        return ue;
    }
    ue = Cat(тип, e1, e2);
    return ue;
}

/*  Given an AA literal 'ae', and a ключ 'e2':
 *  Return ae[e2] if present, or NULL if not found.
 */
Выражение findKeyInAA(ref Место место, AssocArrayLiteralExp ae, Выражение e2)
{
    /* Search the keys backwards, in case there are duplicate keys
     */
    for (т_мера i = ae.keys.dim; i;)
    {
        --i;
        Выражение ekey = (*ae.keys)[i];
        const цел eq = ctfeEqual(место, ТОК2.equal, ekey, e2);
        if (eq)
        {
            return (*ae.values)[i];
        }
    }
    return null;
}

/* Same as for constfold.Index, except that it only works for static arrays,
 * dynamic arrays, and strings. We know that e1 is an
 * interpreted CTFE Выражение, so it cannot have side-effects.
 */
Выражение ctfeIndex(UnionExp* pue, ref Место место, Тип тип, Выражение e1, uinteger_t indx)
{
    //printf("ctfeIndex(e1 = %s)\n", e1.вТкст0());
    assert(e1.тип);
    if (auto es1 = e1.isStringExp())
    {
        if (indx >= es1.len)
        {
            выведиОшибку(место, "ткст index %llu is out of bounds `[0 .. %llu]`", indx, cast(бдол)es1.len);
            return CTFEExp.cantexp;
        }
        emplaceExp!(IntegerExp)(pue, место, es1.charAt(indx), тип);
        return pue.exp();
    }

    if (auto ale = e1.isArrayLiteralExp())
    {
        if (indx >= ale.elements.dim)
        {
            выведиОшибку(место, "массив index %llu is out of bounds `%s[0 .. %llu]`", indx, e1.вТкст0(), cast(бдол)ale.elements.dim);
            return CTFEExp.cantexp;
        }
        Выражение e = (*ale.elements)[cast(т_мера)indx];
        return paintTypeOntoLiteral(pue, тип, e);
    }

    assert(0);
}

Выражение ctfeCast(UnionExp* pue, ref Место место, Тип тип, Тип to, Выражение e)
{
    Выражение paint()
    {
        return paintTypeOntoLiteral(pue, to, e);
    }

    if (e.op == ТОК2.null_)
        return paint();

    if (e.op == ТОК2.classReference)
    {
        // Disallow reinterpreting class casts. Do this by ensuring that
        // the original class can implicitly convert to the target class
        ClassDeclaration originalClass = (cast(ClassReferenceExp)e).originalClass();
        if (originalClass.тип.implicitConvTo(to.mutableOf()))
            return paint();
        else
        {
            emplaceExp!(NullExp)(pue, место, to);
            return pue.exp();
        }
    }

    // Allow TypeInfo тип painting
    if (isTypeInfo_Class(e.тип) && e.тип.implicitConvTo(to))
        return paint();

    // Allow casting away const for struct literals
    if (e.op == ТОК2.structLiteral && e.тип.toBasetype().castMod(0) == to.toBasetype().castMod(0))
        return paint();

    Выражение r;
    if (e.тип.равен(тип) && тип.равен(to))
    {
        // necessary not to change e's address for pointer comparisons
        r = e;
    }
    else if (to.toBasetype().ty == Tarray &&
             тип.toBasetype().ty == Tarray &&
             to.toBasetype().nextOf().size() == тип.toBasetype().nextOf().size())
    {
        // https://issues.dlang.org/show_bug.cgi?ид=12495
        // МассивДРК reinterpret casts: eg. ткст to const(ббайт)[]
        return paint();
    }
    else
    {
        *pue = Cast(место, тип, to, e);
        r = pue.exp();
    }

    if (CTFEExp.isCantExp(r))
        выведиОшибку(место, "cannot cast `%s` to `%s` at compile time", e.вТкст0(), to.вТкст0());

    if (auto ae = e.isArrayLiteralExp())
        ae.ownedByCtfe = OwnedBy.ctfe;

    if (auto se = e.isStringExp())
        se.ownedByCtfe = OwnedBy.ctfe;

    return r;
}

/******** Assignment helper functions ***************************/
/* Set dest = src, where both dest and src are container значение literals
 * (ie, struct literals, or static arrays (can be an массив literal or a ткст))
 * Assignment is recursively in-place.
 * Purpose: any reference to a member of 'dest' will remain valid after the
 * assignment.
 */
проц assignInPlace(Выражение dest, Выражение src)
{
    if (!(dest.op == ТОК2.structLiteral || dest.op == ТОК2.arrayLiteral || dest.op == ТОК2.string_))
    {
        printf("invalid op %d %d\n", src.op, dest.op);
        assert(0);
    }
    Выражения* oldelems;
    Выражения* newelems;
    if (dest.op == ТОК2.structLiteral)
    {
        assert(dest.op == src.op);
        oldelems = (cast(StructLiteralExp)dest).elements;
        newelems = (cast(StructLiteralExp)src).elements;
        auto sd = (cast(StructLiteralExp)dest).sd;
        const nfields = sd.nonHiddenFields();
        const nvthis = sd.fields.dim - nfields;
        if (nvthis && oldelems.dim >= nfields && oldelems.dim < newelems.dim)
            foreach (_; new бцел[0 .. newelems.dim - oldelems.dim])
                oldelems.сунь(null);
    }
    else if (dest.op == ТОК2.arrayLiteral && src.op == ТОК2.arrayLiteral)
    {
        oldelems = (cast(ArrayLiteralExp)dest).elements;
        newelems = (cast(ArrayLiteralExp)src).elements;
    }
    else if (dest.op == ТОК2.string_ && src.op == ТОК2.string_)
    {
        sliceAssignStringFromString(cast(StringExp)dest, cast(StringExp)src, 0);
        return;
    }
    else if (dest.op == ТОК2.arrayLiteral && src.op == ТОК2.string_)
    {
        sliceAssignArrayLiteralFromString(cast(ArrayLiteralExp)dest, cast(StringExp)src, 0);
        return;
    }
    else if (src.op == ТОК2.arrayLiteral && dest.op == ТОК2.string_)
    {
        sliceAssignStringFromArrayLiteral(cast(StringExp)dest, cast(ArrayLiteralExp)src, 0);
        return;
    }
    else
    {
        printf("invalid op %d %d\n", src.op, dest.op);
        assert(0);
    }
    assert(oldelems.dim == newelems.dim);
    foreach (т_мера i; new бцел[0 .. oldelems.dim])
    {
        Выражение e = (*newelems)[i];
        Выражение o = (*oldelems)[i];
        if (e.op == ТОК2.structLiteral)
        {
            assert(o.op == e.op);
            assignInPlace(o, e);
        }
        else if (e.тип.ty == Tsarray && e.op != ТОК2.void_ && o.тип.ty == Tsarray)
        {
            assignInPlace(o, e);
        }
        else
        {
            (*oldelems)[i] = (*newelems)[i];
        }
    }
}

// Given an AA literal aae,  set aae[index] = newval and return newval.
Выражение assignAssocArrayElement(ref Место место, AssocArrayLiteralExp aae, Выражение index, Выражение newval)
{
    /* Create new associative массив literal reflecting updated ключ/значение
     */
    Выражения* keysx = aae.keys;
    Выражения* valuesx = aae.values;
    цел updated = 0;
    for (т_мера j = valuesx.dim; j;)
    {
        j--;
        Выражение ekey = (*aae.keys)[j];
        цел eq = ctfeEqual(место, ТОК2.equal, ekey, index);
        if (eq)
        {
            (*valuesx)[j] = newval;
            updated = 1;
        }
    }
    if (!updated)
    {
        // Append index/newval to keysx[]/valuesx[]
        valuesx.сунь(newval);
        keysx.сунь(index);
    }
    return newval;
}

/// Given массив literal oldval of тип ArrayLiteralExp or StringExp, of length
/// oldlen, change its length to newlen. If the newlen is longer than oldlen,
/// all new elements will be set to the default инициализатор for the element тип.
UnionExp changeArrayLiteralLength(ref Место место, TypeArray arrayType, Выражение oldval, т_мера oldlen, т_мера newlen)
{
    UnionExp ue;
    Тип elemType = arrayType.следщ;
    assert(elemType);
    Выражение defaultElem = elemType.defaultInitLiteral(место);
    auto elements = new Выражения(newlen);
    // Resolve slices
    т_мера indxlo = 0;
    if (oldval.op == ТОК2.slice)
    {
        indxlo = cast(т_мера)(cast(SliceExp)oldval).lwr.toInteger();
        oldval = (cast(SliceExp)oldval).e1;
    }
    т_мера copylen = oldlen < newlen ? oldlen : newlen;
    if (oldval.op == ТОК2.string_)
    {
        StringExp oldse = cast(StringExp)oldval;
        ук s = mem.xcalloc(newlen + 1, oldse.sz);
        const данные = oldse.peekData();
        memcpy(s, данные.ptr, copylen * oldse.sz);
        const defaultValue = cast(бцел)defaultElem.toInteger();
        foreach (т_мера elemi; new бцел[copylen .. newlen])
        {
            switch (oldse.sz)
            {
            case 1:
                (cast(сим*)s)[cast(т_мера)(indxlo + elemi)] = cast(сим)defaultValue;
                break;
            case 2:
                (cast(wchar*)s)[cast(т_мера)(indxlo + elemi)] = cast(wchar)defaultValue;
                break;
            case 4:
                (cast(dchar*)s)[cast(т_мера)(indxlo + elemi)] = cast(dchar)defaultValue;
                break;
            default:
                assert(0);
            }
        }
        emplaceExp!(StringExp)(&ue, место, s[0 .. newlen * oldse.sz], newlen, oldse.sz);
        StringExp se = cast(StringExp)ue.exp();
        se.тип = arrayType;
        se.sz = oldse.sz;
        se.committed = oldse.committed;
        se.ownedByCtfe = OwnedBy.ctfe;
    }
    else
    {
        if (oldlen != 0)
        {
            assert(oldval.op == ТОК2.arrayLiteral);
            ArrayLiteralExp ae = cast(ArrayLiteralExp)oldval;
            foreach (т_мера i; new бцел[0 .. copylen])
                (*elements)[i] = (*ae.elements)[indxlo + i];
        }
        if (elemType.ty == Tstruct || elemType.ty == Tsarray)
        {
            /* If it is an aggregate literal representing a значение тип,
             * we need to создай a unique копируй for each element
             */
            foreach (т_мера i; new бцел[copylen .. newlen])
                (*elements)[i] = copyLiteral(defaultElem).копируй();
        }
        else
        {
            foreach (т_мера i; new бцел[copylen .. newlen])
                (*elements)[i] = defaultElem;
        }
        emplaceExp!(ArrayLiteralExp)(&ue, место, arrayType, elements);
        ArrayLiteralExp aae = cast(ArrayLiteralExp)ue.exp();
        aae.ownedByCtfe = OwnedBy.ctfe;
    }
    return ue;
}

/*************************** CTFE Sanity Checks ***************************/

бул isCtfeValueValid(Выражение newval)
{
    Тип tb = newval.тип.toBasetype();
    switch (newval.op)
    {
        case ТОК2.int64:
        case ТОК2.float64:
        case ТОК2.char_:
        case ТОК2.complex80:
            return tb.isscalar();

        case ТОК2.null_:
            return tb.ty == Tnull    ||
                   tb.ty == Tpointer ||
                   tb.ty == Tarray   ||
                   tb.ty == Taarray  ||
                   tb.ty == Tclass   ||
                   tb.ty == Tdelegate;

        case ТОК2.string_:
            return да; // CTFE would directly use the StringExp in AST.

        case ТОК2.arrayLiteral:
            return да; //((ArrayLiteralExp *)newval)->ownedByCtfe;

        case ТОК2.assocArrayLiteral:
            return да; //((AssocArrayLiteralExp *)newval)->ownedByCtfe;

        case ТОК2.structLiteral:
            return да; //((StructLiteralExp *)newval)->ownedByCtfe;

        case ТОК2.classReference:
            return да;

        case ТОК2.тип:
            return да;

        case ТОК2.vector:
            return да; // vector literal

        case ТОК2.function_:
            return да; // function literal or delegate literal

        case ТОК2.delegate_:
        {
            // &struct.func or &clasinst.func
            // &nestedfunc
            Выражение ethis = (cast(DelegateExp)newval).e1;
            return (ethis.op == ТОК2.structLiteral || ethis.op == ТОК2.classReference || ethis.op == ТОК2.variable && (cast(VarExp)ethis).var == (cast(DelegateExp)newval).func);
        }

        case ТОК2.symbolOffset:
        {
            // function pointer, or pointer to static variable
            Declaration d = (cast(SymOffExp)newval).var;
            return d.isFuncDeclaration() || d.isDataseg();
        }

        case ТОК2.typeid_:
        {
            // always valid
            return да;
        }

        case ТОК2.address:
        {
            // e1 should be a CTFE reference
            Выражение e1 = (cast(AddrExp)newval).e1;
            return tb.ty == Tpointer &&
            (
                (e1.op == ТОК2.structLiteral || e1.op == ТОК2.arrayLiteral) && isCtfeValueValid(e1) ||
                 e1.op == ТОК2.variable ||
                 e1.op == ТОК2.dotVariable && isCtfeReferenceValid(e1) ||
                 e1.op == ТОК2.index && isCtfeReferenceValid(e1) ||
                 e1.op == ТОК2.slice && e1.тип.toBasetype().ty == Tsarray
            );
        }

        case ТОК2.slice:
        {
            // e1 should be an массив aggregate
            const SliceExp se = cast(SliceExp)newval;
            assert(se.lwr && se.lwr.op == ТОК2.int64);
            assert(se.upr && se.upr.op == ТОК2.int64);
            return (tb.ty == Tarray || tb.ty == Tsarray) && (se.e1.op == ТОК2.string_ || se.e1.op == ТОК2.arrayLiteral);
        }

        case ТОК2.void_:
            return да; // uninitialized значение

        default:
            newval.выведиОшибку("CTFE internal error: illegal CTFE значение `%s`", newval.вТкст0());
            return нет;
    }
}

бул isCtfeReferenceValid(Выражение newval)
{
    switch (newval.op)
    {
        case ТОК2.this_:
            return да;

        case ТОК2.variable:
        {
            const VarDeclaration v = (cast(VarExp)newval).var.isVarDeclaration();
            assert(v);
            // Must not be a reference to a reference
            return да;
        }

        case ТОК2.index:
        {
            const Выражение eagg = (cast(IndexExp)newval).e1;
            return eagg.op == ТОК2.string_ || eagg.op == ТОК2.arrayLiteral || eagg.op == ТОК2.assocArrayLiteral;
        }

        case ТОК2.dotVariable:
        {
            Выражение eagg = (cast(DotVarExp)newval).e1;
            return (eagg.op == ТОК2.structLiteral || eagg.op == ТОК2.classReference) && isCtfeValueValid(eagg);
        }

        default:
            // Internally a ref variable may directly point a stack memory.
            // e.g. ref цел v = 1;
            return isCtfeValueValid(newval);
    }
}

// Used for debugging only
проц showCtfeExpr(Выражение e, цел уровень = 0)
{
    for (цел i = уровень; i > 0; --i)
        printf(" ");
    Выражения* elements = null;
    // We need the struct definition to detect block assignment
    StructDeclaration sd = null;
    ClassDeclaration cd = null;
    if (e.op == ТОК2.structLiteral)
    {
        elements = (cast(StructLiteralExp)e).elements;
        sd = (cast(StructLiteralExp)e).sd;
        printf("STRUCT тип = %s %p:\n", e.тип.вТкст0(), e);
    }
    else if (e.op == ТОК2.classReference)
    {
        elements = (cast(ClassReferenceExp)e).значение.elements;
        cd = (cast(ClassReferenceExp)e).originalClass();
        printf("CLASS тип = %s %p:\n", e.тип.вТкст0(), (cast(ClassReferenceExp)e).значение);
    }
    else if (e.op == ТОК2.arrayLiteral)
    {
        elements = (cast(ArrayLiteralExp)e).elements;
        printf("ARRAY LITERAL тип=%s %p:\n", e.тип.вТкст0(), e);
    }
    else if (e.op == ТОК2.assocArrayLiteral)
    {
        printf("AA LITERAL тип=%s %p:\n", e.тип.вТкст0(), e);
    }
    else if (e.op == ТОК2.string_)
    {
        printf("STRING %s %p\n", e.вТкст0(), e.isStringExp.peekString.ptr);
    }
    else if (e.op == ТОК2.slice)
    {
        printf("SLICE %p: %s\n", e, e.вТкст0());
        showCtfeExpr((cast(SliceExp)e).e1, уровень + 1);
    }
    else if (e.op == ТОК2.variable)
    {
        printf("VAR %p %s\n", e, e.вТкст0());
        VarDeclaration v = (cast(VarExp)e).var.isVarDeclaration();
        if (v && дайЗначение(v))
            showCtfeExpr(дайЗначение(v), уровень + 1);
    }
    else if (e.op == ТОК2.address)
    {
        // This is potentially recursive. We mustn't try to print the thing we're pointing to.
        printf("POINTER %p to %p: %s\n", e, (cast(AddrExp)e).e1, e.вТкст0());
    }
    else
        printf("VALUE %p: %s\n", e, e.вТкст0());
    if (elements)
    {
        т_мера fieldsSoFar = 0;
        for (т_мера i = 0; i < elements.dim; i++)
        {
            Выражение z = null;
            VarDeclaration v = null;
            if (i > 15)
            {
                printf("...(total %d elements)\n", cast(цел)elements.dim);
                return;
            }
            if (sd)
            {
                v = sd.fields[i];
                z = (*elements)[i];
            }
            else if (cd)
            {
                while (i - fieldsSoFar >= cd.fields.dim)
                {
                    fieldsSoFar += cd.fields.dim;
                    cd = cd.baseClass;
                    for (цел j = уровень; j > 0; --j)
                        printf(" ");
                    printf(" BASE CLASS: %s\n", cd.вТкст0());
                }
                v = cd.fields[i - fieldsSoFar];
                assert((elements.dim + i) >= (fieldsSoFar + cd.fields.dim));
                т_мера indx = (elements.dim - fieldsSoFar) - cd.fields.dim + i;
                assert(indx < elements.dim);
                z = (*elements)[indx];
            }
            if (!z)
            {
                for (цел j = уровень; j > 0; --j)
                    printf(" ");
                printf(" проц\n");
                continue;
            }
            if (v)
            {
                // If it is a проц assignment, use the default инициализатор
                if ((v.тип.ty != z.тип.ty) && v.тип.ty == Tsarray)
                {
                    for (цел j = уровень; --j;)
                        printf(" ");
                    printf(" field: block initialized static массив\n");
                    continue;
                }
            }
            showCtfeExpr(z, уровень + 1);
        }
    }
}

/*************************** Void initialization ***************************/
UnionExp voidInitLiteral(Тип t, VarDeclaration var)
{
    UnionExp ue;
    if (t.ty == Tsarray)
    {
        TypeSArray tsa = cast(TypeSArray)t;
        Выражение elem = voidInitLiteral(tsa.следщ, var).копируй();
        // For aggregate значение types (structs, static arrays) we must
        // создай an a separate копируй for each element.
        const mustCopy = (elem.op == ТОК2.arrayLiteral || elem.op == ТОК2.structLiteral);
        const d = cast(т_мера)tsa.dim.toInteger();
        auto elements = new Выражения(d);
        foreach (i; new бцел[0 .. d])
        {
            if (mustCopy && i > 0)
                elem = copyLiteral(elem).копируй();
            (*elements)[i] = elem;
        }
        emplaceExp!(ArrayLiteralExp)(&ue, var.место, tsa, elements);
        ArrayLiteralExp ae = cast(ArrayLiteralExp)ue.exp();
        ae.ownedByCtfe = OwnedBy.ctfe;
    }
    else if (t.ty == Tstruct)
    {
        TypeStruct ts = cast(TypeStruct)t;
        auto exps = new Выражения(ts.sym.fields.dim);
        foreach (т_мера i;  new бцел[0 .. ts.sym.fields.dim])
        {
            (*exps)[i] = voidInitLiteral(ts.sym.fields[i].тип, ts.sym.fields[i]).копируй();
        }
        emplaceExp!(StructLiteralExp)(&ue, var.место, ts.sym, exps);
        StructLiteralExp se = cast(StructLiteralExp)ue.exp();
        se.тип = ts;
        se.ownedByCtfe = OwnedBy.ctfe;
    }
    else
        emplaceExp!(VoidInitExp)(&ue, var);
    return ue;
}
