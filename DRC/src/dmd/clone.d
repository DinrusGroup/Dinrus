/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/clone.d, _clone.d)
 * Documentation:  https://dlang.org/phobos/dmd_clone.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/clone.d
 */

module dmd.clone;

import cidrus;
import dmd.aggregate;
import dmd.arraytypes;
import dmd.dclass;
import dmd.declaration;
import dmd.dscope;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.dtemplate;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.init;
import dmd.mtype;
import dmd.opover;
import dmd.semantic2;
import dmd.инструкция;
import dmd.target;
import dmd.typesem;
import drc.lexer.Tokens;

/*******************************************
 * Merge function attributes , , , , and @disable
 * from f into s1.
 * Параметры:
 *      s1 = storage class to merge into
 *      f = function
 * Возвращает:
 *      merged storage class
 */
КлассХранения mergeFuncAttrs(КлассХранения s1, FuncDeclaration f) 
{
    if (!f)
        return s1;
    КлассХранения s2 = (f.класс_хранения & STC.disable);

    TypeFunction tf = cast(TypeFunction)f.тип;
    if (tf.trust == TRUST.safe)
        s2 |= STC.safe;
    else if (tf.trust == TRUST.system)
        s2 |= STC.system;
    else if (tf.trust == TRUST.trusted)
        s2 |= STC.trusted;

    if (tf.purity != PURE.impure)
        s2 |= STC.pure_;
    if (tf.isnothrow)
        s2 |= STC.nothrow_;
    if (tf.isnogc)
        s2 |= STC.nogc;

    const sa = s1 & s2;
    const so = s1 | s2;

    КлассХранения stc = (sa & (STC.pure_ | STC.nothrow_ | STC.nogc)) | (so & STC.disable);

    if (so & STC.system)
        stc |= STC.system;
    else if (sa & STC.trusted)
        stc |= STC.trusted;
    else if ((so & (STC.trusted | STC.safe)) == (STC.trusted | STC.safe))
        stc |= STC.trusted;
    else if (sa & STC.safe)
        stc |= STC.safe;

    return stc;
}

/*******************************************
 * Check given aggregate actually has an identity opAssign or not.
 * Параметры:
 *      ad = struct or class
 *      sc = current scope
 * Возвращает:
 *      if found, returns FuncDeclaration of opAssign, otherwise null
 */
FuncDeclaration hasIdentityOpAssign(AggregateDeclaration ad, Scope* sc)
{
    ДСимвол assign = search_function(ad, Id.assign);
    if (assign)
    {
        /* check identity opAssign exists
         */
        scope er = new NullExp(ad.место, ad.тип);    // dummy rvalue
        scope el = new IdentifierExp(ad.место, Id.p); // dummy lvalue
        el.тип = ad.тип;
        Выражения a;
        a.устДим(1);
        const errors = глоб2.startGagging(); // Do not report errors, even if the template opAssign fbody makes it.
        sc = sc.сунь();
        sc.tinst = null;
        sc.minst = null;

        a[0] = er;
        auto f = resolveFuncCall(ad.место, sc, assign, null, ad.тип, &a, FuncResolveFlag.quiet);
        if (!f)
        {
            a[0] = el;
            f = resolveFuncCall(ad.место, sc, assign, null, ad.тип, &a, FuncResolveFlag.quiet);
        }

        sc = sc.вынь();
        глоб2.endGagging(errors);
        if (f)
        {
            if (f.errors)
                return null;
            auto fparams = f.getParameterList();
            if (fparams.length)
            {
                auto fparam0 = fparams[0];
                if (fparam0.тип.toDsymbol(null) != ad)
                    f = null;
            }
        }
        // BUGS: This detection mechanism cannot найди some opAssign-s like follows:
        // struct S { проц opAssign(ref const S) const; }
        return f;
    }
    return null;
}

/*******************************************
 * We need an opAssign for the struct if
 * it has a destructor or a postblit.
 * We need to generate one if a user-specified one does not exist.
 */
private бул needOpAssign(StructDeclaration sd)
{
    //printf("StructDeclaration::needOpAssign() %s\n", sd.вТкст0());

    static бул isNeeded()
    {
        //printf("\tneed\n");
        return да;
    }

    if (sd.isUnionDeclaration())
        return !isNeeded();

    if (sd.hasIdentityAssign || // because has identity==elaborate opAssign
        sd.dtor ||
        sd.postblit)
        return isNeeded();

    /* If any of the fields need an opAssign, then we
     * need it too.
     */
    foreach (v; sd.fields)
    {
        if (v.класс_хранения & STC.ref_)
            continue;
        if (v.overlapped)               // if field of a union
            continue;                   // user must handle it themselves
        Тип tv = v.тип.baseElemOf();
        if (tv.ty == Tstruct)
        {
            TypeStruct ts = cast(TypeStruct)tv;
            if (ts.sym.isUnionDeclaration())
                continue;
            if (needOpAssign(ts.sym))
                return isNeeded();
        }
    }
    return !isNeeded();
}

/******************************************
 * Build opAssign for a `struct`.
 *
 * The generated `opAssign` function has the following signature:
 *---
 *ref S opAssign(S s)    // S is the имя of the `struct`
 *---
 *
 * The opAssign function will be built for a struct `S` if the
 * following constraints are met:
 *
 * 1. `S` does not have an identity `opAssign` defined.
 *
 * 2. `S` has at least one of the following члены: a postblit (user-defined or
 * generated for fields that have a defined postblit), a destructor
 * (user-defined or generated for fields that have a defined destructor)
 * or at least one field that has a defined `opAssign`.
 *
 * 3. `S` does not have any non-mutable fields.
 *
 * If `S` has a disabled destructor or at least one field that has a disabled
 * `opAssign`, `S.opAssign` is going to be generated, but marked with `@disable`
 *
 * If `S` defines a destructor, the generated code for `opAssign` is:
 *
 *---
 *S __swap = проц;
 *__swap = this;   // bit копируй
 *this = s;        // bit копируй
 *__swap.dtor();
 *---
 *
 * Otherwise, if `S` defines a postblit, the generated code for `opAssign` is:
 *
 *---
 *this = s;
 *---
 *
 * Note that the параметр to the generated `opAssign` is passed by значение, which means
 * that the postblit is going to be called (if it is defined) in both  of the above
 * situations before entering the body of `opAssign`. The assignments in the above generated
 * function bodies are blit Выражения, so they can be regarded as `memcpy`s
 * (`opAssign` is not called as this will результат in an infinite recursion; the postblit
 * is not called because it has already been called when the параметр was passed by значение).
 *
 * If `S` does not have a postblit or a destructor, but содержит at least one field that defines
 * an `opAssign` function (which is not disabled), then the body will make member-wise
 * assignments:
 *
 *---
 *this.field1 = s.field1;
 *this.field2 = s.field2;
 *...;
 *---
 *
 * In this situation, the assignemnts are actual assign Выражения (`opAssign` is используется
 * if defined).
 *
 * References:
 *      https://dlang.org/spec/struct.html#assign-overload
 * Параметры:
 *      sd = struct to generate opAssign for
 *      sc = context
 * Возвращает:
 *      generated `opAssign` function
 */
FuncDeclaration buildOpAssign(StructDeclaration sd, Scope* sc)
{
    if (FuncDeclaration f = hasIdentityOpAssign(sd, sc))
    {
        sd.hasIdentityAssign = да;
        return f;
    }
    // Even if non-identity opAssign is defined, built-in identity opAssign
    // will be defined.
    if (!needOpAssign(sd))
        return null;

    //printf("StructDeclaration::buildOpAssign() %s\n", sd.вТкст0());
    КлассХранения stc = STC.safe | STC.nothrow_ | STC.pure_ | STC.nogc;
    Место declLoc = sd.место;
    Место место; // internal code should have no место to prevent coverage

    // One of our sub-field might have `@disable opAssign` so we need to
    // check for it.
    // In this event, it will be reflected by having `stc` (opAssign's
    // storage class) include `STC.disabled`.
    foreach (v; sd.fields)
    {
        if (v.класс_хранения & STC.ref_)
            continue;
        if (v.overlapped)
            continue;
        Тип tv = v.тип.baseElemOf();
        if (tv.ty != Tstruct)
            continue;
        StructDeclaration sdv = (cast(TypeStruct)tv).sym;
        stc = mergeFuncAttrs(stc, hasIdentityOpAssign(sdv, sc));
    }

    if (sd.dtor || sd.postblit)
    {
        // if the тип is not assignable, we cannot generate opAssign
        if (!sd.тип.isAssignable()) // https://issues.dlang.org/show_bug.cgi?ид=13044
            return null;
        stc = mergeFuncAttrs(stc, sd.dtor);
        if (stc & STC.safe)
            stc = (stc & ~STC.safe) | STC.trusted;
    }

    auto fparams = new Параметры();
    fparams.сунь(new Параметр2(STC.nodtor, sd.тип, Id.p, null, null));
    auto tf = new TypeFunction(СписокПараметров(fparams), sd.handleType(), LINK.d, stc | STC.ref_);
    auto fop = new FuncDeclaration(declLoc, Место.initial, Id.assign, stc, tf);
    fop.класс_хранения |= STC.inference;
    fop.generated = да;
    Выражение e;
    if (stc & STC.disable)
    {
        e = null;
    }
    /* Do swap this and rhs.
     *    __swap = this; this = s; __swap.dtor();
     */
    else if (sd.dtor)
    {
        //printf("\tswap копируй\n");
        TypeFunction tdtor = cast(TypeFunction)sd.dtor.тип;
        assert(tdtor.ty == Tfunction);

        auto idswap = Идентификатор2.генерируйИд("__swap");
        auto swap = new VarDeclaration(место, sd.тип, idswap, new VoidInitializer(место));
        swap.класс_хранения |= STC.nodtor | STC.temp | STC.ctfe;
        if (tdtor.isscope)
            swap.класс_хранения |= STC.scope_;
        auto e1 = new DeclarationExp(место, swap);

        auto e2 = new BlitExp(место, new VarExp(место, swap), new ThisExp(место));
        auto e3 = new BlitExp(место, new ThisExp(место), new IdentifierExp(место, Id.p));

        /* Instead of running the destructor on s, run it
         * on swap. This avoids needing to копируй swap back in to s.
         */
        auto e4 = new CallExp(место, new DotVarExp(место, new VarExp(место, swap), sd.dtor, нет));

        e = Выражение.combine(e1, e2, e3, e4);
    }
    /* postblit was called when the значение was passed to opAssign, we just need to blit the результат */
    else if (sd.postblit)
        e = new BlitExp(место, new ThisExp(место), new IdentifierExp(место, Id.p));
    else
    {
        /* Do memberwise копируй.
         *
         * If sd is a nested struct, its vthis field assignment is:
         * 1. If it's nested in a class, it's a rebind of class reference.
         * 2. If it's nested in a function or struct, it's an update of ук.
         * In both cases, it will change the родитель context.
         */
        //printf("\tmemberwise копируй\n");
        e = null;
        foreach (v; sd.fields)
        {
            // this.v = s.v;
            auto ec = new AssignExp(место,
                new DotVarExp(место, new ThisExp(место), v),
                new DotVarExp(место, new IdentifierExp(место, Id.p), v));
            e = Выражение.combine(e, ec);
        }
    }
    if (e)
    {
        Инструкция2 s1 = new ExpStatement(место, e);
        /* Add:
         *   return this;
         */
        auto er = new ThisExp(место);
        Инструкция2 s2 = new ReturnStatement(место, er);
        fop.fbody = new CompoundStatement(место, s1, s2);
        tf.isreturn = да;
    }
    sd.члены.сунь(fop);
    fop.addMember(sc, sd);
    sd.hasIdentityAssign = да; // temporary mark identity assignable
    const errors = глоб2.startGagging(); // Do not report errors, even if the template opAssign fbody makes it.
    Scope* sc2 = sc.сунь();
    sc2.stc = 0;
    sc2.компонаж = LINK.d;
    fop.dsymbolSemantic(sc2);
    fop.semantic2(sc2);
    // https://issues.dlang.org/show_bug.cgi?ид=15044
    //semantic3(fop, sc2); // isn't run here for lazy forward reference resolution.

    sc2.вынь();
    if (глоб2.endGagging(errors)) // if errors happened
    {
        // Disable generated opAssign, because some члены forbid identity assignment.
        fop.класс_хранения |= STC.disable;
        fop.fbody = null; // удали fbody which содержит the error
    }

    //printf("-StructDeclaration::buildOpAssign() %s, errors = %d\n", sd.вТкст0(), (fop.класс_хранения & STC.disable) != 0);
    //printf("fop.тип: %s\n", fop.тип.toPrettyChars());
    return fop;
}

/*******************************************
 * We need an opEquals for the struct if
 * any fields has an opEquals.
 * Generate one if a user-specified one does not exist.
 */
бул needOpEquals(StructDeclaration sd)
{
    //printf("StructDeclaration::needOpEquals() %s\n", sd.вТкст0());
    if (sd.isUnionDeclaration())
        goto Ldontneed;
    if (sd.hasIdentityEquals)
        goto Lneed;
    /* If any of the fields has an opEquals, then we
     * need it too.
     */
    for (т_мера i = 0; i < sd.fields.dim; i++)
    {
        VarDeclaration v = sd.fields[i];
        if (v.класс_хранения & STC.ref_)
            continue;
        if (v.overlapped)
            continue;
        Тип tv = v.тип.toBasetype();
        auto tvbase = tv.baseElemOf();
        if (tvbase.ty == Tstruct)
        {
            TypeStruct ts = cast(TypeStruct)tvbase;
            if (ts.sym.isUnionDeclaration())
                continue;
            if (needOpEquals(ts.sym))
                goto Lneed;
            if (ts.sym.aliasthis) // https://issues.dlang.org/show_bug.cgi?ид=14806
                goto Lneed;
        }
        if (tvbase.isfloating())
        {
            // This is necessray for:
            //  1. comparison of +0.0 and -0.0 should be да.
            //  2. comparison of NANs should be нет always.
            goto Lneed;
        }
        if (tvbase.ty == Tarray)
            goto Lneed;
        if (tvbase.ty == Taarray)
            goto Lneed;
        if (tvbase.ty == Tclass)
            goto Lneed;
    }
Ldontneed:
    //printf("\tdontneed\n");
    return нет;
Lneed:
    //printf("\tneed\n");
    return да;
}

/*******************************************
 * Check given aggregate actually has an identity opEquals or not.
 */
private FuncDeclaration hasIdentityOpEquals(AggregateDeclaration ad, Scope* sc)
{
    FuncDeclaration f;
    if (ДСимвол eq = search_function(ad, Id.eq))
    {
        /* check identity opEquals exists
         */
        scope er = new NullExp(ad.место, null); // dummy rvalue
        scope el = new IdentifierExp(ad.место, Id.p); // dummy lvalue
        Выражения a;
        a.устДим(1);

        бул hasIt(Тип tthis)
        {
            const errors = глоб2.startGagging(); // Do not report errors, even if the template opAssign fbody makes it
            sc = sc.сунь();
            sc.tinst = null;
            sc.minst = null;

            FuncDeclaration rfc(Выражение e)
            {
                a[0] = e;
                a[0].тип = tthis;
                return resolveFuncCall(ad.место, sc, eq, null, tthis, &a, FuncResolveFlag.quiet);
            }

            f = rfc(er);
            if (!f)
                f = rfc(el);

            sc = sc.вынь();
            глоб2.endGagging(errors);

            return f !is null;
        }

        if (hasIt(ad.тип)               ||
            hasIt(ad.тип.constOf())     ||
            hasIt(ad.тип.immutableOf()) ||
            hasIt(ad.тип.sharedOf())    ||
            hasIt(ad.тип.sharedConstOf()))
        {
            if (f.errors)
                return null;
        }
    }
    return f;
}

/******************************************
 * Build opEquals for struct.
 *      const бул opEquals(const S s) { ... }
 *
 * By fixing https://issues.dlang.org/show_bug.cgi?ид=3789
 * opEquals is changed to be never implicitly generated.
 * Now, struct objects comparison s1 == s2 is translated to:
 *      s1.tupleof == s2.tupleof
 * to calculate structural equality. See EqualExp.op_overload.
 */
FuncDeclaration buildOpEquals(StructDeclaration sd, Scope* sc)
{
    if (hasIdentityOpEquals(sd, sc))
    {
        sd.hasIdentityEquals = да;
    }
    return null;
}

/******************************************
 * Build __xopEquals for TypeInfo_Struct
 *      static бул __xopEquals(ref const S p, ref const S q)
 *      {
 *          return p == q;
 *      }
 *
 * This is called by TypeInfo.равен(p1, p2). If the struct does not support
 * const objects comparison, it will throw "not implemented" Error in runtime.
 */
FuncDeclaration buildXopEquals(StructDeclaration sd, Scope* sc)
{
    if (!needOpEquals(sd))
        return null; // bitwise comparison would work

    //printf("StructDeclaration::buildXopEquals() %s\n", sd.вТкст0());
    if (ДСимвол eq = search_function(sd, Id.eq))
    {
        if (FuncDeclaration fd = eq.isFuncDeclaration())
        {
            TypeFunction tfeqptr;
            {
                Scope scx;
                /* const бул opEquals(ref const S s);
                 */
                auto parameters = new Параметры();
                parameters.сунь(new Параметр2(STC.ref_ | STC.const_, sd.тип, null, null, null));
                tfeqptr = new TypeFunction(СписокПараметров(parameters), Тип.tбул, LINK.d);
                tfeqptr.mod = MODFlags.const_;
                tfeqptr = cast(TypeFunction)tfeqptr.typeSemantic(Место.initial, &scx);
            }
            fd = fd.overloadExactMatch(tfeqptr);
            if (fd)
                return fd;
        }
    }
    if (!sd.xerreq)
    {
        // объект._xopEquals
        Идентификатор2 ид = Идентификатор2.idPool("_xopEquals");
        Выражение e = new IdentifierExp(sd.место, Id.empty);
        e = new DotIdExp(sd.место, e, Id.объект);
        e = new DotIdExp(sd.место, e, ид);
        e = e.ВыражениеSemantic(sc);
        ДСимвол s = getDsymbol(e);
        assert(s);
        sd.xerreq = s.isFuncDeclaration();
    }
    Место declLoc; // место is unnecessary so __xopEquals is never called directly
    Место место; // место is unnecessary so errors are gagged
    auto parameters = new Параметры();
    parameters.сунь(new Параметр2(STC.ref_ | STC.const_, sd.тип, Id.p, null, null))
              .сунь(new Параметр2(STC.ref_ | STC.const_, sd.тип, Id.q, null, null));
    auto tf = new TypeFunction(СписокПараметров(parameters), Тип.tбул, LINK.d);
    Идентификатор2 ид = Id.xopEquals;
    auto fop = new FuncDeclaration(declLoc, Место.initial, ид, STC.static_, tf);
    fop.generated = да;
    Выражение e1 = new IdentifierExp(место, Id.p);
    Выражение e2 = new IdentifierExp(место, Id.q);
    Выражение e = new EqualExp(ТОК2.equal, место, e1, e2);
    fop.fbody = new ReturnStatement(место, e);
    бцел errors = глоб2.startGagging(); // Do not report errors
    Scope* sc2 = sc.сунь();
    sc2.stc = 0;
    sc2.компонаж = LINK.d;
    fop.dsymbolSemantic(sc2);
    fop.semantic2(sc2);
    sc2.вынь();
    if (глоб2.endGagging(errors)) // if errors happened
        fop = sd.xerreq;
    return fop;
}

/******************************************
 * Build __xopCmp for TypeInfo_Struct
 *      static бул __xopCmp(ref const S p, ref const S q)
 *      {
 *          return p.opCmp(q);
 *      }
 *
 * This is called by TypeInfo.compare(p1, p2). If the struct does not support
 * const objects comparison, it will throw "not implemented" Error in runtime.
 */
FuncDeclaration buildXopCmp(StructDeclaration sd, Scope* sc)
{
    //printf("StructDeclaration::buildXopCmp() %s\n", вТкст0());
    if (ДСимвол cmp = search_function(sd, Id.cmp))
    {
        if (FuncDeclaration fd = cmp.isFuncDeclaration())
        {
            TypeFunction tfcmpptr;
            {
                Scope scx;
                /* const цел opCmp(ref const S s);
                 */
                auto parameters = new Параметры();
                parameters.сунь(new Параметр2(STC.ref_ | STC.const_, sd.тип, null, null, null));
                tfcmpptr = new TypeFunction(СписокПараметров(parameters), Тип.tint32, LINK.d);
                tfcmpptr.mod = MODFlags.const_;
                tfcmpptr = cast(TypeFunction)tfcmpptr.typeSemantic(Место.initial, &scx);
            }
            fd = fd.overloadExactMatch(tfcmpptr);
            if (fd)
                return fd;
        }
    }
    else
    {
        version (none) // FIXME: doesn't work for recursive alias this
        {
            /* Check opCmp member exists.
             * Consider 'alias this', but except opDispatch.
             */
            Выражение e = new DsymbolExp(sd.место, sd);
            e = new DotIdExp(sd.место, e, Id.cmp);
            Scope* sc2 = sc.сунь();
            e = e.trySemantic(sc2);
            sc2.вынь();
            if (e)
            {
                ДСимвол s = null;
                switch (e.op)
                {
                case ТОК2.overloadSet:
                    s = (cast(OverExp)e).vars;
                    break;
                case ТОК2.scope_:
                    s = (cast(ScopeExp)e).sds;
                    break;
                case ТОК2.variable:
                    s = (cast(VarExp)e).var;
                    break;
                default:
                    break;
                }
                if (!s || s.идент != Id.cmp)
                    e = null; // there's no valid member 'opCmp'
            }
            if (!e)
                return null; // bitwise comparison would work
            /* Essentially, a struct which does not define opCmp is not comparable.
             * At this time, typeid(S).compare might be correct that throwing "not implement" Error.
             * But implementing it would break existing code, such as:
             *
             * struct S { цел значение; }  // no opCmp
             * цел[S] aa;   // Currently AA ключ uses bitwise comparison
             *              // (It's default behavior of TypeInfo_Strust.compare).
             *
             * Not sure we should fix this inconsistency, so just keep current behavior.
             */
        }
        else
        {
            return null;
        }
    }
    if (!sd.xerrcmp)
    {
        // объект._xopCmp
        Идентификатор2 ид = Идентификатор2.idPool("_xopCmp");
        Выражение e = new IdentifierExp(sd.место, Id.empty);
        e = new DotIdExp(sd.место, e, Id.объект);
        e = new DotIdExp(sd.место, e, ид);
        e = e.ВыражениеSemantic(sc);
        ДСимвол s = getDsymbol(e);
        assert(s);
        sd.xerrcmp = s.isFuncDeclaration();
    }
    Место declLoc; // место is unnecessary so __xopCmp is never called directly
    Место место; // место is unnecessary so errors are gagged
    auto parameters = new Параметры();
    parameters.сунь(new Параметр2(STC.ref_ | STC.const_, sd.тип, Id.p, null, null));
    parameters.сунь(new Параметр2(STC.ref_ | STC.const_, sd.тип, Id.q, null, null));
    auto tf = new TypeFunction(СписокПараметров(parameters), Тип.tint32, LINK.d);
    Идентификатор2 ид = Id.xopCmp;
    auto fop = new FuncDeclaration(declLoc, Место.initial, ид, STC.static_, tf);
    fop.generated = да;
    Выражение e1 = new IdentifierExp(место, Id.p);
    Выражение e2 = new IdentifierExp(место, Id.q);
    Выражение e = new CallExp(место, new DotIdExp(место, e2, Id.cmp), e1);
    fop.fbody = new ReturnStatement(место, e);
    бцел errors = глоб2.startGagging(); // Do not report errors
    Scope* sc2 = sc.сунь();
    sc2.stc = 0;
    sc2.компонаж = LINK.d;
    fop.dsymbolSemantic(sc2);
    fop.semantic2(sc2);
    sc2.вынь();
    if (глоб2.endGagging(errors)) // if errors happened
        fop = sd.xerrcmp;
    return fop;
}

/*******************************************
 * We need a toHash for the struct if
 * any fields has a toHash.
 * Generate one if a user-specified one does not exist.
 */
private бул needToHash(StructDeclaration sd)
{
    //printf("StructDeclaration::needToHash() %s\n", sd.вТкст0());
    if (sd.isUnionDeclaration())
        goto Ldontneed;
    if (sd.xhash)
        goto Lneed;

    /* If any of the fields has an opEquals, then we
     * need it too.
     */
    for (т_мера i = 0; i < sd.fields.dim; i++)
    {
        VarDeclaration v = sd.fields[i];
        if (v.класс_хранения & STC.ref_)
            continue;
        if (v.overlapped)
            continue;
        Тип tv = v.тип.toBasetype();
        auto tvbase = tv.baseElemOf();
        if (tvbase.ty == Tstruct)
        {
            TypeStruct ts = cast(TypeStruct)tvbase;
            if (ts.sym.isUnionDeclaration())
                continue;
            if (needToHash(ts.sym))
                goto Lneed;
            if (ts.sym.aliasthis) // https://issues.dlang.org/show_bug.cgi?ид=14948
                goto Lneed;
        }
        if (tvbase.isfloating())
        {
            /* This is necessary because comparison of +0.0 and -0.0 should be да,
             * i.e. not a bit compare.
             */
            goto Lneed;
        }
        if (tvbase.ty == Tarray)
            goto Lneed;
        if (tvbase.ty == Taarray)
            goto Lneed;
        if (tvbase.ty == Tclass)
            goto Lneed;
    }
Ldontneed:
    //printf("\tdontneed\n");
    return нет;
Lneed:
    //printf("\tneed\n");
    return да;
}

/******************************************
 * Build __xtoHash for non-bitwise hashing
 *      static hash_t xtoHash(ref const S p) ;
 */
FuncDeclaration buildXtoHash(StructDeclaration sd, Scope* sc)
{
    if (ДСимвол s = search_function(sd, Id.tohash))
    {
         TypeFunction tftohash;
        if (!tftohash)
        {
            tftohash = new TypeFunction(СписокПараметров(), Тип.thash_t, LINK.d);
            tftohash.mod = MODFlags.const_;
            tftohash = cast(TypeFunction)tftohash.merge();
        }
        if (FuncDeclaration fd = s.isFuncDeclaration())
        {
            fd = fd.overloadExactMatch(tftohash);
            if (fd)
                return fd;
        }
    }
    if (!needToHash(sd))
        return null;

    //printf("StructDeclaration::buildXtoHash() %s\n", sd.toPrettyChars());
    Место declLoc; // место is unnecessary so __xtoHash is never called directly
    Место место; // internal code should have no место to prevent coverage
    auto parameters = new Параметры();
    parameters.сунь(new Параметр2(STC.ref_ | STC.const_, sd.тип, Id.p, null, null));
    auto tf = new TypeFunction(СписокПараметров(parameters), Тип.thash_t, LINK.d, STC.nothrow_ | STC.trusted);
    Идентификатор2 ид = Id.xtoHash;
    auto fop = new FuncDeclaration(declLoc, Место.initial, ид, STC.static_, tf);
    fop.generated = да;

    /* Do memberwise hashing.
     *
     * If sd is a nested struct, and if it's nested in a class, the calculated
     * хэш значение will also contain the результат of родитель class's toHash().
     */
    ткст code =
        "т_мера h = 0;" ~
        "foreach (i, T; typeof(p.tupleof))" ~
        // workaround https://issues.dlang.org/show_bug.cgi?ид=17968
        "    static if(is(T* : const(.объект.Object)*)) " ~
        "        h = h * 33 + typeid(const(.объект.Object)).getHash(cast(const ук)&p.tupleof[i]);" ~
        "    else " ~
        "        h = h * 33 + typeid(T).getHash(cast(const ук)&p.tupleof[i]);" ~
        "return h;";
    fop.fbody = new CompileStatement(место, new StringExp(место, code));
    Scope* sc2 = sc.сунь();
    sc2.stc = 0;
    sc2.компонаж = LINK.d;
    fop.dsymbolSemantic(sc2);
    fop.semantic2(sc2);
    sc2.вынь();

    //printf("%s fop = %s %s\n", sd.вТкст0(), fop.вТкст0(), fop.тип.вТкст0());
    return fop;
}

/*****************************************
 * Create inclusive destructor for struct/class by aggregating
 * all the destructors in dtors[] with the destructors for
 * all the члены.
 * Параметры:
 *      ad = struct or class to build destructor for
 *      sc = context
 * Возвращает:
 *      generated function, null if none needed
 * Note:
 * Close similarity with StructDeclaration::buildPostBlit(),
 * and the ordering changes (runs backward instead of forwards).
 */
DtorDeclaration buildDtor(AggregateDeclaration ad, Scope* sc)
{
    //printf("AggregateDeclaration::buildDtor() %s\n", ad.вТкст0());
    if (ad.isUnionDeclaration())
        return null;                    // unions don't have destructors

    КлассХранения stc = STC.safe | STC.nothrow_ | STC.pure_ | STC.nogc;
    Место declLoc = ad.dtors.dim ? ad.dtors[0].место : ad.место;
    Место место; // internal code should have no место to prevent coverage
    FuncDeclaration xdtor_fwd = null;

    // if the dtor is an /*extern(C++)*/ prototype, then we expect it performs a full-destruction; we don't need to build a full-dtor
    const бул dtorIsCppPrototype = ad.dtors.dim == 1 && ad.dtors[0].компонаж == LINK.cpp && !ad.dtors[0].fbody;
    if (!dtorIsCppPrototype)
    {
        Выражение e = null;
        for (т_мера i = 0; i < ad.fields.dim; i++)
        {
            auto v = ad.fields[i];
            if (v.класс_хранения & STC.ref_)
                continue;
            if (v.overlapped)
                continue;
            auto tv = v.тип.baseElemOf();
            if (tv.ty != Tstruct)
                continue;
            auto sdv = (cast(TypeStruct)tv).sym;
            if (!sdv.dtor)
                continue;

            // fix: https://issues.dlang.org/show_bug.cgi?ид=17257
            // braces for shrink wrapping scope of a
            {
                xdtor_fwd = sdv.dtor; // this dtor is temporary it could be anything
                auto a = new AliasDeclaration(Место.initial, Id.__xdtor, xdtor_fwd);
                a.addMember(sc, ad); // temporarily add to symbol table
            }

            sdv.dtor.functionSemantic();

            stc = mergeFuncAttrs(stc, sdv.dtor);
            if (stc & STC.disable)
            {
                e = null;
                break;
            }

            Выражение ex;
            tv = v.тип.toBasetype();
            if (tv.ty == Tstruct)
            {
                // this.v.__xdtor()

                ex = new ThisExp(место);
                ex = new DotVarExp(место, ex, v);

                // This is a hack so we can call destructors on const/const objects.
                // Do it as a тип 'paint'.
                ex = new CastExp(место, ex, v.тип.mutableOf());
                if (stc & STC.safe)
                    stc = (stc & ~STC.safe) | STC.trusted;

                ex = new DotVarExp(место, ex, sdv.dtor, нет);
                ex = new CallExp(место, ex);
            }
            else
            {
                // __МассивDtor((cast(S*)this.v.ptr)[0 .. n])

                const n = tv.numberOfElems(место);
                if (n == 0)
                    continue;

                ex = new ThisExp(место);
                ex = new DotVarExp(место, ex, v);

                // This is a hack so we can call destructors on const/const objects.
                ex = new DotIdExp(место, ex, Id.ptr);
                ex = new CastExp(место, ex, sdv.тип.pointerTo());
                if (stc & STC.safe)
                    stc = (stc & ~STC.safe) | STC.trusted;

                ex = new SliceExp(место, ex, new IntegerExp(место, 0, Тип.tт_мера),
                                           new IntegerExp(место, n, Тип.tт_мера));
                // Prevent redundant bounds check
                (cast(SliceExp)ex).upperIsInBounds = да;
                (cast(SliceExp)ex).lowerIsLessThanUpper = да;

                ex = new CallExp(место, new IdentifierExp(место, Id.__МассивDtor), ex);
            }
            e = Выражение.combine(ex, e); // combine in reverse order
        }

        /* extern(C++) destructors call into super to destruct the full hierarchy
        */
        ClassDeclaration cldec = ad.isClassDeclaration();
        if (cldec && cldec.classKind == ClassKind.cpp && cldec.baseClass && cldec.baseClass.primaryDtor)
        {
            // WAIT BUT: do I need to run `cldec.baseClass.dtor` semantic? would it have been run before?
            cldec.baseClass.dtor.functionSemantic();

            stc = mergeFuncAttrs(stc, cldec.baseClass.primaryDtor);
            if (!(stc & STC.disable))
            {
                // super.__xdtor()

                Выражение ex = new SuperExp(место);

                // This is a hack so we can call destructors on const/const objects.
                // Do it as a тип 'paint'.
                ex = new CastExp(место, ex, cldec.baseClass.тип.mutableOf());
                if (stc & STC.safe)
                    stc = (stc & ~STC.safe) | STC.trusted;

                ex = new DotVarExp(место, ex, cldec.baseClass.primaryDtor, нет);
                ex = new CallExp(место, ex);

                e = Выражение.combine(e, ex); // super dtor last
            }
        }

        /* Build our own "destructor" which executes e
         */
        if (e || (stc & STC.disable))
        {
            //printf("Building __fieldDtor(), %s\n", e.вТкст0());
            auto dd = new DtorDeclaration(declLoc, Место.initial, stc, Id.__fieldDtor);
            dd.generated = да;
            dd.класс_хранения |= STC.inference;
            dd.fbody = new ExpStatement(место, e);
            ad.dtors.shift(dd);
            ad.члены.сунь(dd);
            dd.dsymbolSemantic(sc);
            ad.fieldDtor = dd;
        }
    }

    DtorDeclaration xdtor = null;
    switch (ad.dtors.dim)
    {
    case 0:
        break;

    case 1:
        xdtor = ad.dtors[0];
        break;

    default:
        assert(!dtorIsCppPrototype);
        Выражение e = null;
        e = null;
        stc = STC.safe | STC.nothrow_ | STC.pure_ | STC.nogc;
        for (т_мера i = 0; i < ad.dtors.dim; i++)
        {
            FuncDeclaration fd = ad.dtors[i];
            stc = mergeFuncAttrs(stc, fd);
            if (stc & STC.disable)
            {
                e = null;
                break;
            }
            Выражение ex = new ThisExp(место);
            ex = new DotVarExp(место, ex, fd, нет);
            ex = new CallExp(место, ex);
            e = Выражение.combine(ex, e);
        }
        auto dd = new DtorDeclaration(declLoc, Место.initial, stc, Id.__aggrDtor);
        dd.generated = да;
        dd.класс_хранения |= STC.inference;
        dd.fbody = new ExpStatement(место, e);
        ad.члены.сунь(dd);
        dd.dsymbolSemantic(sc);
        xdtor = dd;
        break;
    }

    ad.primaryDtor = xdtor;

    if (xdtor && xdtor.компонаж == LINK.cpp && !target.cpp.twoDtorInVtable)
        xdtor = buildWindowsCppDtor(ad, xdtor, sc);

    // Add an __xdtor alias to make the inclusive dtor accessible
    if (xdtor)
    {
        auto _alias = new AliasDeclaration(Место.initial, Id.__xdtor, xdtor);
        _alias.dsymbolSemantic(sc);
        ad.члены.сунь(_alias);
        if (xdtor_fwd)
            ad.symtab.update(_alias); // update forward dtor to correct one
        else
            _alias.addMember(sc, ad); // add to symbol table
    }

    return xdtor;
}

/**
 * build a shim function around the compound dtor that accepts an argument
 *  that is используется to implement the deleting C++ destructor
 *
 * Параметры:
 *  ad = the aggregate that содержит the destructor to wrap
 *  dtor = the destructor to wrap
 *  sc = the scope in which to analyze the new function
 *
 * Возвращает:
 *  the shim destructor, semantically analyzed and added to the class as a member
 */
private DtorDeclaration buildWindowsCppDtor(AggregateDeclaration ad, DtorDeclaration dtor, Scope* sc)
{
    auto cldec = ad.isClassDeclaration();
    if (!cldec || cldec.cppDtorVtblIndex == -1) // scalar deleting dtor not built for non-virtual dtors
        return dtor;

    // generate deleting C++ destructor corresponding to:
    // ук C::~C(цел del)
    // {
    //   this->~C();
    //   // TODO: if (del) delete (сим*)this;
    //   return (ук) this;
    // }
    Параметр2 delparam = new Параметр2(STC.undefined_, Тип.tuns32, Идентификатор2.idPool("del"), new IntegerExp(dtor.место, 0, Тип.tuns32), null);
    Параметры* парамы = new Параметры;
    парамы.сунь(delparam);
    auto ftype = new TypeFunction(СписокПараметров(парамы), Тип.tvoidptr, LINK.cpp, dtor.класс_хранения);
    auto func = new DtorDeclaration(dtor.место, dtor.место, dtor.класс_хранения, Id.cppdtor);
    func.тип = ftype;
    if (dtor.fbody)
    {
        const место = dtor.место;
        auto stmts = new Инструкции;
        auto call = new CallExp(место, dtor, null);
        call.directcall = да;
        stmts.сунь(new ExpStatement(место, call));
        stmts.сунь(new ReturnStatement(место, new CastExp(место, new ThisExp(место), Тип.tvoidptr)));
        func.fbody = new CompoundStatement(место, stmts);
        func.generated = да;
    }

    auto sc2 = sc.сунь();
    sc2.stc &= ~STC.static_; // not a static destructor
    sc2.компонаж = LINK.cpp;

    ad.члены.сунь(func);
    func.addMember(sc2, ad);
    func.dsymbolSemantic(sc2);

    sc2.вынь();
    return func;
}

/**
 * build a shim function around the compound dtor that translates
 *  a C++ destructor to a destructor with extern(D) calling convention
 *
 * Параметры:
 *  ad = the aggregate that содержит the destructor to wrap
 *  sc = the scope in which to analyze the new function
 *
 * Возвращает:
 *  the shim destructor, semantically analyzed and added to the class as a member
 */
DtorDeclaration buildExternDDtor(AggregateDeclaration ad, Scope* sc)
{
    auto dtor = ad.primaryDtor;
    if (!dtor)
        return null;

    // ABI incompatible on all (?) x86 32-bit platforms
    if (ad.classKind != ClassKind.cpp || глоб2.парамы.is64bit)
        return dtor;

    // generate member function that adjusts calling convention
    // (EAX используется for 'this' instead of ECX on Windows/stack on others):
    // extern(D) проц __ticppdtor()
    // {
    //     Class.__dtor();
    // }
    auto ftype = new TypeFunction(СписокПараметров(), Тип.tvoid, LINK.d, dtor.класс_хранения);
    auto func = new DtorDeclaration(dtor.место, dtor.место, dtor.класс_хранения, Id.ticppdtor);
    func.тип = ftype;

    auto call = new CallExp(dtor.место, dtor, null);
    call.directcall = да;                   // non-virtual call Class.__dtor();
    func.fbody = new ExpStatement(dtor.место, call);
    func.generated = да;
    func.класс_хранения |= STC.inference;

    auto sc2 = sc.сунь();
    sc2.stc &= ~STC.static_; // not a static destructor
    sc2.компонаж = LINK.d;

    ad.члены.сунь(func);
    func.addMember(sc2, ad);
    func.dsymbolSemantic(sc2);
    func.functionSemantic(); // to infer attributes

    sc2.вынь();
    return func;
}

/******************************************
 * Create inclusive invariant for struct/class by aggregating
 * all the invariants in invs[].
 *      проц __invariant() const [ ]
 *      {
 *          invs[0](), invs[1](), ...;
 *      }
 */
FuncDeclaration buildInv(AggregateDeclaration ad, Scope* sc)
{
    switch (ad.invs.dim)
    {
    case 0:
        return null;

    case 1:
        // Don't return invs[0] so it has uniquely generated имя.
        goto default;

    default:
        Выражение e = null;
        КлассХранения stcx = 0;
        КлассХранения stc = STC.safe | STC.nothrow_ | STC.pure_ | STC.nogc;
        foreach (i, inv; ad.invs)
        {
            stc = mergeFuncAttrs(stc, inv);
            if (stc & STC.disable)
            {
                // What should do?
            }
            const stcy = (inv.класс_хранения & STC.synchronized_) |
                         (inv.тип.mod & MODFlags.shared_ ? STC.shared_ : 0);
            if (i == 0)
                stcx = stcy;
            else if (stcx ^ stcy)
            {
                version (all)
                {
                    // currently rejects
                    ad.выведиОшибку(inv.место, "mixing invariants with different `shared`/`synchronized` qualifiers is not supported");
                    e = null;
                    break;
                }
            }
            e = Выражение.combine(e, new CallExp(Место.initial, new VarExp(Место.initial, inv, нет)));
        }
        auto inv = new InvariantDeclaration(ad.место, Место.initial, stc | stcx,
                Id.classInvariant, new ExpStatement(Место.initial, e));
        ad.члены.сунь(inv);
        inv.dsymbolSemantic(sc);
        return inv;
    }
}
