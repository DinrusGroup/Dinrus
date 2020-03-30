/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/Выражениеsem.d, _Выражениеsem.d)
 * Documentation:  https://dlang.org/phobos/dmd_Выражениеsem.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/Выражениеsem.d
 */

module dmd.expressionsem;

import cidrus;

import dmd.access;
import dmd.aggregate;
import dmd.aliasthis;
import dmd.arrayop;
import dmd.arraytypes;
import dmd.attrib;
import drc.ast.AstCodegen;
import dmd.canthrow;
import dmd.ctorflow;
import dmd.dscope;
import dmd.дсимвол;
import dmd.declaration;
import dmd.dclass;
import dmd.dcast;
import dmd.delegatize;
import dmd.denum;
import dmd.dimport;
import dmd.dinterpret;
import dmd.dmangle;
import dmd.dmodule;
import dmd.dstruct;
import dmd.dsymbolsem;
import dmd.dtemplate;
import dmd.errors;
import dmd.escape;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import dmd.hdrgen;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.imphint;
import dmd.init;
import dmd.initsem;
import dmd.inline;
import dmd.intrange;
import dmd.mtype;
import dmd.nspace;
import dmd.opover;
import dmd.optimize;
import drc.parser.Parser2;
import util.ctfloat;
import util.file;
import util.filename;
import util.outbuffer;
import drc.ast.Node;
import util.string;
import dmd.semantic2;
import dmd.semantic3;
import dmd.sideeffect;
import dmd.safe;
import dmd.target;
import drc.lexer.Tokens;
import dmd.traits;
import dmd.typesem;
import dmd.typinf;
import util.utf;
import util.utils;
import drc.ast.Visitor;
import core.checkedint : mulu;

const LOGSEMANTIC = нет;

/********************************************************
 * Perform semantic analysis and CTFE on Выражения to produce
 * a ткст.
 * Параметры:
 *      буф = приставь generated ткст to буфер
 *      sc = context
 *      exps = массив of Выражения
 * Возвращает:
 *      да on error
 */
бул выраженияВТкст(ref БуфВыв буф, Scope* sc, Выражения* exps)
{
    if (!exps)
        return нет;

    foreach (ex; *exps)
    {
        if (!ex)
            continue;
        auto sc2 = sc.startCTFE();
        auto e2 = ex.ВыражениеSemantic(sc2);
        auto e3 = resolveProperties(sc2, e2);
        sc2.endCTFE();

        // allowed to contain types as well as Выражения
        auto e4 = ctfeInterpretForPragmaMsg(e3);
        if (!e4 || e4.op == ТОК2.error)
            return да;

        // expand кортеж
        if (auto te = e4.isTupleExp())
        {
            if (выраженияВТкст(буф, sc, te.exps))
                return да;
            continue;
        }
        // сим literals exp `.вТкстExp` return `null` but we cant override it
        // because in most contexts we don't want the conversion to succeed.
        IntegerExp ie = e4.isIntegerExp();
        const ty = (ie && ie.тип) ? ie.тип.ty : Terror;
        if (ty == Tchar || ty == Twchar || ty == Tdchar)
        {
            auto tsa = new TypeSArray(ie.тип, new IntegerExp(1));
            e4 = new ArrayLiteralExp(ex.место, tsa, ie);
        }

        if (StringExp se = e4.вТкстExp())
            буф.пишиСтр(se.toUTF8(sc).peekString());
        else
            буф.пишиСтр(e4.вТкст());
    }
    return нет;
}


/***********************************************************
 * Resolve `exp` as a compile-time known ткст.
 * Параметры:
 *  sc  = scope
 *  exp = Выражение which expected as a ткст
 *  s   = What the ткст is expected for, will be используется in error diagnostic.
 * Возвращает:
 *  String literal, or `null` if error happens.
 */
StringExp semanticString(Scope *sc, Выражение exp, ткст0 s)
{
    sc = sc.startCTFE();
    exp = exp.ВыражениеSemantic(sc);
    exp = resolveProperties(sc, exp);
    sc = sc.endCTFE();

    if (exp.op == ТОК2.error)
        return null;

    auto e = exp;
    if (exp.тип.isString())
    {
        e = e.ctfeInterpret();
        if (e.op == ТОК2.error)
            return null;
    }

    auto se = e.вТкстExp();
    if (!se)
    {
        exp.выведиОшибку("`ткст` expected for %s, not `(%s)` of тип `%s`",
            s, exp.вТкст0(), exp.тип.вТкст0());
        return null;
    }
    return se;
}

private Выражение extractOpDollarSideEffect(Scope* sc, UnaExp ue)
{
    Выражение e0;
    Выражение e1 = Выражение.extractLast(ue.e1, e0);
    // https://issues.dlang.org/show_bug.cgi?ид=12585
    // Extract the side effect part if ue.e1 is comma.

    if ((sc.flags & SCOPE.ctfe) ? hasSideEffect(e1) : !isTrivialExp(e1)) // match logic in extractSideEffect()
    {
        /* Even if opDollar is needed, 'e1' should be evaluate only once. So
         * Rewrite:
         *      e1.opIndex( ... use of $ ... )
         *      e1.opSlice( ... use of $ ... )
         * as:
         *      (ref __dop = e1, __dop).opIndex( ... __dop.opDollar ...)
         *      (ref __dop = e1, __dop).opSlice( ... __dop.opDollar ...)
         */
        e1 = extractSideEffect(sc, "__dop", e0, e1, нет);
        assert(e1.op == ТОК2.variable);
        VarExp ve = cast(VarExp)e1;
        ve.var.класс_хранения |= STC.exptemp;     // lifetime limited to Выражение
    }
    ue.e1 = e1;
    return e0;
}

/**************************************
 * Runs semantic on ae.arguments. Declares temporary variables
 * if '$' was используется.
 */
Выражение resolveOpDollar(Scope* sc, ArrayExp ae, Выражение* pe0)
{
    assert(!ae.lengthVar);
    *pe0 = null;
    AggregateDeclaration ad = isAggregate(ae.e1.тип);
    ДСимвол slice = search_function(ad, Id.slice);
    //printf("slice = %s %s\n", slice.вид(), slice.вТкст0());
    foreach (i, e; *ae.arguments)
    {
        if (i == 0)
            *pe0 = extractOpDollarSideEffect(sc, ae);

        if (e.op == ТОК2.interval && !(slice && slice.isTemplateDeclaration()))
        {
        Lfallback:
            if (ae.arguments.dim == 1)
                return null;
            ae.выведиОшибку("multi-dimensional slicing requires template `opSlice`");
            return new ErrorExp();
        }
        //printf("[%d] e = %s\n", i, e.вТкст0());

        // Create scope for '$' variable for this dimension
        auto sym = new ArrayScopeSymbol(sc, ae);
        sym.родитель = sc.scopesym;
        sc = sc.сунь(sym);
        ae.lengthVar = null; // Create it only if required
        ae.currentDimension = i; // Dimension for $, if required

        e = e.ВыражениеSemantic(sc);
        e = resolveProperties(sc, e);

        if (ae.lengthVar && sc.func)
        {
            // If $ was используется, declare it now
            Выражение de = new DeclarationExp(ae.место, ae.lengthVar);
            de = de.ВыражениеSemantic(sc);
            *pe0 = Выражение.combine(*pe0, de);
        }
        sc = sc.вынь();

        if (e.op == ТОК2.interval)
        {
            IntervalExp ie = cast(IntervalExp)e;

            auto tiargs = new Объекты();
            Выражение edim = new IntegerExp(ae.место, i, Тип.tт_мера);
            edim = edim.ВыражениеSemantic(sc);
            tiargs.сунь(edim);

            auto fargs = new Выражения(2);
            (*fargs)[0] = ie.lwr;
            (*fargs)[1] = ie.upr;

            бцел xerrors = глоб2.startGagging();
            sc = sc.сунь();
            FuncDeclaration fslice = resolveFuncCall(ae.место, sc, slice, tiargs, ae.e1.тип, fargs, FuncResolveFlag.quiet);
            sc = sc.вынь();
            глоб2.endGagging(xerrors);
            if (!fslice)
                goto Lfallback;

            e = new DotTemplateInstanceExp(ae.место, ae.e1, slice.идент, tiargs);
            e = new CallExp(ae.место, e, fargs);
            e = e.ВыражениеSemantic(sc);
        }

        if (!e.тип)
        {
            ae.выведиОшибку("`%s` has no значение", e.вТкст0());
            e = new ErrorExp();
        }
        if (e.op == ТОК2.error)
            return e;

        (*ae.arguments)[i] = e;
    }
    return ae;
}

/**************************************
 * Runs semantic on se.lwr and se.upr. Declares a temporary variable
 * if '$' was используется.
 * Возвращает:
 *      ae, or ErrorExp if errors occurred
 */
Выражение resolveOpDollar(Scope* sc, ArrayExp ae, IntervalExp ie, Выражение* pe0)
{
    //assert(!ae.lengthVar);
    if (!ie)
        return ae;

    VarDeclaration lengthVar = ae.lengthVar;
    бул errors = нет;

    // создай scope for '$'
    auto sym = new ArrayScopeSymbol(sc, ae);
    sym.родитель = sc.scopesym;
    sc = sc.сунь(sym);

    Выражение sem(Выражение e)
    {
        e = e.ВыражениеSemantic(sc);
        e = resolveProperties(sc, e);
        if (!e.тип)
        {
            ae.выведиОшибку("`%s` has no значение", e.вТкст0());
            errors = да;
        }
        return e;
    }

    ie.lwr = sem(ie.lwr);
    ie.upr = sem(ie.upr);

    if (lengthVar != ae.lengthVar && sc.func)
    {
        // If $ was используется, declare it now
        Выражение de = new DeclarationExp(ae.место, ae.lengthVar);
        de = de.ВыражениеSemantic(sc);
        *pe0 = Выражение.combine(*pe0, de);
    }

    sc = sc.вынь();

    return errors ? new ErrorExp() : ae;
}

/******************************
 * Perform semantic() on an массив of Выражения.
 */
бул arrayВыражениеSemantic(Выражения* exps, Scope* sc, бул preserveErrors = нет)
{
    бул err = нет;
    if (exps)
    {
        foreach (ref e; *exps)
        {
            if (e)
            {
                auto e2 = e.ВыражениеSemantic(sc);
                if (e2.op == ТОК2.error)
                    err = да;
                if (preserveErrors || e2.op != ТОК2.error)
                    e = e2;
            }
        }
    }
    return err;
}

/******************************
 * Check the tail CallExp is really property function call.
 * Bugs:
 * This doesn't appear to do anything.
 */
private бул checkPropertyCall(Выражение e)
{
    e = lastComma(e);

    if (e.op == ТОК2.call)
    {
        CallExp ce = cast(CallExp)e;
        TypeFunction tf;
        if (ce.f)
        {
            tf = cast(TypeFunction)ce.f.тип;
            /* If a forward reference to ce.f, try to resolve it
             */
            if (!tf.deco && ce.f.semanticRun < PASS.semanticdone)
            {
                ce.f.dsymbolSemantic(null);
                tf = cast(TypeFunction)ce.f.тип;
            }
        }
        else if (ce.e1.тип.ty == Tfunction)
            tf = cast(TypeFunction)ce.e1.тип;
        else if (ce.e1.тип.ty == Tdelegate)
            tf = cast(TypeFunction)ce.e1.тип.nextOf();
        else if (ce.e1.тип.ty == Tpointer && ce.e1.тип.nextOf().ty == Tfunction)
            tf = cast(TypeFunction)ce.e1.тип.nextOf();
        else
            assert(0);
    }
    return нет;
}

/******************************
 * Find symbol in accordance with the UFCS имя look up rule
 */
private Выражение searchUFCS(Scope* sc, UnaExp ue, Идентификатор2 идент)
{
    //printf("searchUFCS(идент = %s)\n", идент.вТкст0());
    Место место = ue.место;

    // TODO: merge with Scope.search.searchScopes()
    ДСимвол searchScopes(цел flags)
    {
        ДСимвол s = null;
        for (Scope* scx = sc; scx; scx = scx.enclosing)
        {
            if (!scx.scopesym)
                continue;
            if (scx.scopesym.isModule())
                flags |= SearchUnqualifiedModule;    // tell Module.search() that SearchLocalsOnly is to be obeyed
            s = scx.scopesym.search(место, идент, flags);
            if (s)
            {
                // overload set содержит only module scope symbols.
                if (s.isOverloadSet())
                    break;
                // selective/renamed imports also be picked up
                if (AliasDeclaration ad = s.isAliasDeclaration())
                {
                    if (ad._import)
                        break;
                }
                // See only module scope symbols for UFCS target.
                ДСимвол p = s.toParent2();
                if (p && p.isModule())
                    break;
            }
            s = null;

            // Stop when we hit a module, but keep going if that is not just under the глоб2 scope
            if (scx.scopesym.isModule() && !(scx.enclosing && !scx.enclosing.enclosing))
                break;
        }
        return s;
    }

    цел flags = 0;
    ДСимвол s;

    if (sc.flags & SCOPE.ignoresymbolvisibility)
        flags |= IgnoreSymbolVisibility;

    // First look in local scopes
    s = searchScopes(flags | SearchLocalsOnly);
    if (!s)
    {
        // Second look in imported modules
        s = searchScopes(flags | SearchImportsOnly);
    }

    if (!s)
        return ue.e1.тип.Тип.getProperty(место, идент, 0);

    FuncDeclaration f = s.isFuncDeclaration();
    if (f)
    {
        TemplateDeclaration td = getFuncTemplateDecl(f);
        if (td)
        {
            if (td.overroot)
                td = td.overroot;
            s = td;
        }
    }

    if (ue.op == ТОК2.dotTemplateInstance)
    {
        DotTemplateInstanceExp dti = cast(DotTemplateInstanceExp)ue;
        auto ti = new TemplateInstance(место, s.идент, dti.ti.tiargs);
        if (!ti.updateTempDecl(sc, s))
            return new ErrorExp();
        return new ScopeExp(место, ti);
    }
    else
    {
        //printf("-searchUFCS() %s\n", s.вТкст0());
        return new DsymbolExp(место, s);
    }
}

/******************************
 * Pull out callable entity with UFCS.
 */
private Выражение resolveUFCS(Scope* sc, CallExp ce)
{
    Место место = ce.место;
    Выражение eleft;
    Выражение e;

    if (ce.e1.op == ТОК2.dotIdentifier)
    {
        DotIdExp die = cast(DotIdExp)ce.e1;
        Идентификатор2 идент = die.идент;

        Выражение ex = die.semanticX(sc);
        if (ex != die)
        {
            ce.e1 = ex;
            return null;
        }
        eleft = die.e1;

        Тип t = eleft.тип.toBasetype();
        if (t.ty == Tarray || t.ty == Tsarray || t.ty == Tnull || (t.isTypeBasic() && t.ty != Tvoid))
        {
            /* Built-in types and arrays have no callable properties, so do shortcut.
             * It is necessary in: e.init()
             */
        }
        else if (t.ty == Taarray)
        {
            if (идент == Id.удали)
            {
                /* Transform:
                 *  aa.удали(arg) into delete aa[arg]
                 */
                if (!ce.arguments || ce.arguments.dim != 1)
                {
                    ce.выведиОшибку("expected ключ as argument to `aa.удали()`");
                    return new ErrorExp();
                }
                if (!eleft.тип.isMutable())
                {
                    ce.выведиОшибку("cannot удали ключ from `%s` associative массив `%s`", MODtoChars(t.mod), eleft.вТкст0());
                    return new ErrorExp();
                }
                Выражение ключ = (*ce.arguments)[0];
                ключ = ключ.ВыражениеSemantic(sc);
                ключ = resolveProperties(sc, ключ);

                TypeAArray taa = cast(TypeAArray)t;
                ключ = ключ.implicitCastTo(sc, taa.index);

                if (ключ.checkValue() || ключ.checkSharedAccess(sc))
                    return new ErrorExp();

                semanticTypeInfo(sc, taa.index);

                return new RemoveExp(место, eleft, ключ);
            }
        }
        else
        {
            if (Выражение ey = die.semanticY(sc, 1))
            {
                if (ey.op == ТОК2.error)
                    return ey;
                ce.e1 = ey;
                if (isDotOpDispatch(ey))
                {
                    бцел errors = глоб2.startGagging();
                    e = ce.syntaxCopy().ВыражениеSemantic(sc);
                    if (!глоб2.endGagging(errors))
                        return e;

                    // even opDispatch and UFCS must have valid arguments,
                    // so now that we've seen indication of a problem,
                    // check them for issues.
                    Выражения* originalArguments = Выражение.arraySyntaxCopy(ce.arguments);

                    if (arrayВыражениеSemantic(originalArguments, sc))
                        return new ErrorExp();

                    /* fall down to UFCS */
                }
                else
                    return null;
            }
        }

        /* https://issues.dlang.org/show_bug.cgi?ид=13953
         *
         * If a struct has an alias this to an associative массив
         * and удали is используется on a struct instance, we have to
         * check first if there is a удали function that can be called
         * on the struct. If not we must check the alias this.
         *
         * struct A
         * {
         *      ткст[ткст] a;
         *      alias a this;
         * }
         *
         * проц fun()
         * {
         *      A s;
         *      s.удали("foo");
         * }
         */
        const errors = глоб2.startGagging();
        e = searchUFCS(sc, die, идент);
        // if there were any errors and the идентификатор was удали
        if (глоб2.endGagging(errors))
        {
            if (идент == Id.удали)
            {
                // check alias this
                Выражение alias_e = resolveAliasThis(sc, die.e1, 1);
                if (alias_e && alias_e != die.e1)
                {
                    die.e1 = alias_e;
                    CallExp ce2 = cast(CallExp)ce.syntaxCopy();
                    ce2.e1 = die;
                    e = cast(CallExp)ce2.trySemantic(sc);
                    if (e)
                        return e;
                }
            }
            // if alias this did not work out, print the initial errors
            searchUFCS(sc, die, идент);
        }
    }
    else if (ce.e1.op == ТОК2.dotTemplateInstance)
    {
        DotTemplateInstanceExp dti = cast(DotTemplateInstanceExp)ce.e1;
        if (Выражение ey = dti.semanticY(sc, 1))
        {
            ce.e1 = ey;
            return null;
        }
        eleft = dti.e1;
        e = searchUFCS(sc, dti, dti.ti.имя);
    }
    else
        return null;

    // Rewrite
    ce.e1 = e;
    if (!ce.arguments)
        ce.arguments = new Выражения();
    ce.arguments.shift(eleft);

    return null;
}

/******************************
 * Pull out property with UFCS.
 */
private Выражение resolveUFCSProperties(Scope* sc, Выражение e1, Выражение e2 = null)
{
    Место место = e1.место;
    Выражение eleft;
    Выражение e;

    if (e1.op == ТОК2.dotIdentifier)
    {
        DotIdExp die = cast(DotIdExp)e1;
        eleft = die.e1;
        e = searchUFCS(sc, die, die.идент);
    }
    else if (e1.op == ТОК2.dotTemplateInstance)
    {
        DotTemplateInstanceExp dti;
        dti = cast(DotTemplateInstanceExp)e1;
        eleft = dti.e1;
        e = searchUFCS(sc, dti, dti.ti.имя);
    }
    else
        return null;

    if (e is null)
        return null;

    // Rewrite
    if (e2)
    {
        // run semantic without gagging
        e2 = e2.ВыражениеSemantic(sc);

        /* f(e1) = e2
         */
        Выражение ex = e.копируй();
        auto a1 = new Выражения(1);
        (*a1)[0] = eleft;
        ex = new CallExp(место, ex, a1);
        auto e1PassSemantic = ex.trySemantic(sc);

        /* f(e1, e2)
         */
        auto a2 = new Выражения(2);
        (*a2)[0] = eleft;
        (*a2)[1] = e2;
        e = new CallExp(место, e, a2);
        e = e.trySemantic(sc);
        if (!e1PassSemantic && !e)
        {
            /* https://issues.dlang.org/show_bug.cgi?ид=20448
             *
             * If both versions have failed to pass semantic,
             * f(e1) = e2 gets priority in error printing
             * because f might be a templated function that
             * failed to instantiate and we have to print
             * the instantiation errors.
             */
            return e1.ВыражениеSemantic(sc);
        }
        else if (ex && !e)
        {
            checkPropertyCall(ex);
            ex = new AssignExp(место, ex, e2);
            return ex.ВыражениеSemantic(sc);
        }
        else
        {
            // strict setter prints errors if fails
            e = e.ВыражениеSemantic(sc);
        }
        checkPropertyCall(e);
        return e;
    }
    else
    {
        /* f(e1)
         */
        auto arguments = new Выражения(1);
        (*arguments)[0] = eleft;
        e = new CallExp(место, e, arguments);
        e = e.ВыражениеSemantic(sc);
        checkPropertyCall(e);
        return e.ВыражениеSemantic(sc);
    }
}

/******************************
 * If e1 is a property function (template), resolve it.
 */
Выражение resolvePropertiesOnly(Scope* sc, Выражение e1)
{
    //printf("e1 = %s %s\n", Сема2::вТкст0(e1.op), e1.вТкст0());

    Выражение handleOverloadSet(OverloadSet ос)
    {
        assert(ос);
        foreach (s; ос.a)
        {
            auto fd = s.isFuncDeclaration();
            auto td = s.isTemplateDeclaration();
            if (fd)
            {
                if ((cast(TypeFunction)fd.тип).isproperty)
                    return resolveProperties(sc, e1);
            }
            else if (td && td.onemember && (fd = td.onemember.isFuncDeclaration()) !is null)
            {
                if ((cast(TypeFunction)fd.тип).isproperty ||
                    (fd.storage_class2 & STC.property) ||
                    (td._scope.stc & STC.property))
                    return resolveProperties(sc, e1);
            }
        }
        return e1;
    }

    Выражение handleTemplateDecl(TemplateDeclaration td)
    {
        assert(td);
        if (td.onemember)
        {
            if (auto fd = td.onemember.isFuncDeclaration())
            {
                if ((cast(TypeFunction)fd.тип).isproperty ||
                    (fd.storage_class2 & STC.property) ||
                    (td._scope.stc & STC.property))
                    return resolveProperties(sc, e1);
            }
        }
        return e1;
    }

    Выражение handleFuncDecl(FuncDeclaration fd)
    {
        assert(fd);
        if ((cast(TypeFunction)fd.тип).isproperty)
            return resolveProperties(sc, e1);
        return e1;
    }

    if (auto de = e1.isDotExp())
    {
        if (auto ос = de.e2.isOverExp())
            return handleOverloadSet(ос.vars);
    }
    else if (auto oe = e1.isOverExp())
        return handleOverloadSet(oe.vars);
    else if (auto dti = e1.isDotTemplateInstanceExp())
    {
        if (dti.ti.tempdecl)
            if (auto td = dti.ti.tempdecl.isTemplateDeclaration())
                return handleTemplateDecl(td);
    }
    else if (auto dte = e1.isDotTemplateExp())
        return handleTemplateDecl(dte.td);
    else if (e1.op == ТОК2.scope_)
    {
        ДСимвол s = (cast(ScopeExp)e1).sds;
        TemplateInstance ti = s.isTemplateInstance();
        if (ti && !ti.semanticRun && ti.tempdecl)
            if (auto td = ti.tempdecl.isTemplateDeclaration())
                return handleTemplateDecl(td);
    }
    else if (e1.op == ТОК2.template_)
        return handleTemplateDecl((cast(TemplateExp)e1).td);
    else if (e1.op == ТОК2.dotVariable && e1.тип.ty == Tfunction)
    {
        DotVarExp dve = cast(DotVarExp)e1;
        return handleFuncDecl(dve.var.isFuncDeclaration());
    }
    else if (e1.op == ТОК2.variable && e1.тип && e1.тип.ty == Tfunction && (sc.intypeof || !(cast(VarExp)e1).var.needThis()))
        return handleFuncDecl((cast(VarExp)e1).var.isFuncDeclaration());
    return e1;
}

/****************************************
 * Turn symbol `s` into the Выражение it represents.
 *
 * Параметры:
 *      s = symbol to resolve
 *      место = location of use of `s`
 *      sc = context
 *      hasOverloads = applies if `s` represents a function.
 *          да means it's overloaded and will be resolved later,
 *          нет means it's the exact function symbol.
 * Возвращает:
 *      `s` turned into an Выражение, `ErrorExp` if an error occurred
 */
Выражение symbolToExp(ДСимвол s, ref Место место, Scope *sc, бул hasOverloads)
{
    static if (LOGSEMANTIC)
    {
        printf("DsymbolExp::resolve(%s %s)\n", s.вид(), s.вТкст0());
    }

Lagain:
    Выражение e;

    //printf("DsymbolExp:: %p '%s' is a symbol\n", this, вТкст0());
    //printf("s = '%s', s.вид = '%s'\n", s.вТкст0(), s.вид());
    ДСимвол olds = s;
    Declaration d = s.isDeclaration();
    if (d && (d.класс_хранения & STC.шаблонпараметр))
    {
        s = s.toAlias();
    }
    else
    {
        if (!s.isFuncDeclaration()) // functions are checked after overloading
        {
            s.checkDeprecated(место, sc);
            if (d)
                d.checkDisabled(место, sc);
        }

        // https://issues.dlang.org/show_bug.cgi?ид=12023
        // if 's' is a кортеж variable, the кортеж is returned.
        s = s.toAlias();

        //printf("s = '%s', s.вид = '%s', s.needThis() = %p\n", s.вТкст0(), s.вид(), s.needThis());
        if (s != olds && !s.isFuncDeclaration())
        {
            s.checkDeprecated(место, sc);
            if (d)
                d.checkDisabled(место, sc);
        }
    }

    if (auto em = s.isEnumMember())
    {
        return em.getVarExp(место, sc);
    }
    if (auto v = s.isVarDeclaration())
    {
        //printf("Идентификатор2 '%s' is a variable, тип '%s'\n", s.вТкст0(), v.тип.вТкст0());
        if (sc.intypeof == 1 && !v.inuse)
            v.dsymbolSemantic(sc);
        if (!v.тип ||                  // during variable тип inference
            !v.тип.deco && v.inuse)    // during variable тип semantic
        {
            if (v.inuse)    // variable тип depends on the variable itself
                выведиОшибку(место, "circular reference to %s `%s`", v.вид(), v.toPrettyChars());
            else            // variable тип cannot be determined
                выведиОшибку(место, "forward reference to %s `%s`", v.вид(), v.toPrettyChars());
            return new ErrorExp();
        }
        if (v.тип.ty == Terror)
            return new ErrorExp();

        if ((v.класс_хранения & STC.manifest) && v._иниц)
        {
            if (v.inuse)
            {
                выведиОшибку(место, "circular initialization of %s `%s`", v.вид(), v.toPrettyChars());
                return new ErrorExp();
            }
            e = v.expandInitializer(место);
            v.inuse++;
            e = e.ВыражениеSemantic(sc);
            v.inuse--;
            return e;
        }

        // Change the ancestor lambdas to delegate before hasThis(sc) call.
        if (v.checkNestedReference(sc, место))
            return new ErrorExp();

        if (v.needThis() && hasThis(sc))
            e = new DotVarExp(место, new ThisExp(место), v);
        else
            e = new VarExp(место, v);
        e = e.ВыражениеSemantic(sc);
        return e;
    }
    if (auto fld = s.isFuncLiteralDeclaration())
    {
        //printf("'%s' is a function literal\n", fld.вТкст0());
        e = new FuncExp(место, fld);
        return e.ВыражениеSemantic(sc);
    }
    if (auto f = s.isFuncDeclaration())
    {
        f = f.toAliasFunc();
        if (!f.functionSemantic())
            return new ErrorExp();

        if (!hasOverloads && f.checkForwardRef(место))
            return new ErrorExp();

        auto fd = s.isFuncDeclaration();
        fd.тип = f.тип;
        return new VarExp(место, fd, hasOverloads);
    }
    if (OverDeclaration od = s.isOverDeclaration())
    {
        e = new VarExp(место, od, да);
        e.тип = Тип.tvoid;
        return e;
    }
    if (OverloadSet o = s.isOverloadSet())
    {
        //printf("'%s' is an overload set\n", o.вТкст0());
        return new OverExp(место, o);
    }

    if (Импорт imp = s.isImport())
    {
        if (!imp.pkg)
        {
            .выведиОшибку(место, "forward reference of import `%s`", imp.вТкст0());
            return new ErrorExp();
        }
        auto ie = new ScopeExp(место, imp.pkg);
        return ie.ВыражениеSemantic(sc);
    }
    if (Package pkg = s.isPackage())
    {
        auto ie = new ScopeExp(место, pkg);
        return ie.ВыражениеSemantic(sc);
    }
    if (Module mod = s.isModule())
    {
        auto ie = new ScopeExp(место, mod);
        return ie.ВыражениеSemantic(sc);
    }
    if (Nspace ns = s.isNspace())
    {
        auto ie = new ScopeExp(место, ns);
        return ie.ВыражениеSemantic(sc);
    }

    if (Тип t = s.getType())
    {
        return (new TypeExp(место, t)).ВыражениеSemantic(sc);
    }

    if (TupleDeclaration tup = s.isTupleDeclaration())
    {
        if (tup.needThis() && hasThis(sc))
            e = new DotVarExp(место, new ThisExp(место), tup);
        else
            e = new TupleExp(место, tup);
        e = e.ВыражениеSemantic(sc);
        return e;
    }

    if (TemplateInstance ti = s.isTemplateInstance())
    {
        ti.dsymbolSemantic(sc);
        if (!ti.inst || ti.errors)
            return new ErrorExp();
        s = ti.toAlias();
        if (!s.isTemplateInstance())
            goto Lagain;
        e = new ScopeExp(место, ti);
        e = e.ВыражениеSemantic(sc);
        return e;
    }
    if (TemplateDeclaration td = s.isTemplateDeclaration())
    {
        ДСимвол p = td.toParentLocal();
        FuncDeclaration fdthis = hasThis(sc);
        AggregateDeclaration ad = p ? p.isAggregateDeclaration() : null;
        if (fdthis && ad && fdthis.isMemberLocal() == ad && (td._scope.stc & STC.static_) == 0)
        {
            e = new DotTemplateExp(место, new ThisExp(место), td);
        }
        else
            e = new TemplateExp(место, td);
        e = e.ВыражениеSemantic(sc);
        return e;
    }

    .выведиОшибку(место, "%s `%s` is not a variable", s.вид(), s.вТкст0());
    return new ErrorExp();
}

/*************************************************************
 * Given var, get the
 * right `this` pointer if var is in an outer class, but our
 * existing `this` pointer is in an inner class.
 * Параметры:
 *      место = location to use for error messages
 *      sc = context
 *      ad = struct or class we need the correct `this` for
 *      e1 = existing `this`
 *      var = the specific member of ad we're accessing
 *      флаг = if да, return `null` instead of throwing an error
 * Возвращает:
 *      Выражение representing the `this` for the var
 */
private Выражение getRightThis(ref Место место, Scope* sc, AggregateDeclaration ad, Выражение e1, ДСимвол var, цел флаг = 0)
{
    //printf("\ngetRightThis(e1 = %s, ad = %s, var = %s)\n", e1.вТкст0(), ad.вТкст0(), var.вТкст0());
L1:
    Тип t = e1.тип.toBasetype();
    //printf("e1.тип = %s, var.тип = %s\n", e1.тип.вТкст0(), var.тип.вТкст0());

    if (e1.op == ТОК2.objcClassReference)
    {
        // We already have an Objective-C class reference, just use that as 'this'.
        return e1;
    }
    else if (ad && ad.isClassDeclaration && ad.isClassDeclaration.classKind == ClassKind.objc &&
             var.isFuncDeclaration && var.isFuncDeclaration.isStatic &&
             var.isFuncDeclaration.selector)
    {
        return new ObjcClassReferenceExp(e1.место, cast(ClassDeclaration) ad);
    }

    /* Access of a member which is a template параметр in dual-scope scenario
     * class A { inc(alias m)() { ++m; } } // `m` needs `this` of `B`
     * class B {цел m; inc() { new A().inc!m(); } }
     */
    if (e1.op == ТОК2.this_)
    {
        FuncDeclaration f = hasThis(sc);
        if (f && f.isThis2)
        {
            if (f.followInstantiationContext(ad))
            {
                e1 = new VarExp(место, f.vthis);
                e1 = new PtrExp(место, e1);
                e1 = new IndexExp(место, e1, IntegerExp.literal!(1));
                e1 = getThisSkipNestedFuncs(место, sc, f.toParent2(), ad, e1, t, var);
                if (e1.op == ТОК2.error)
                    return e1;
                goto L1;
            }
        }
    }

    /* If e1 is not the 'this' pointer for ad
     */
    if (ad &&
        !(t.ty == Tpointer && t.nextOf().ty == Tstruct && (cast(TypeStruct)t.nextOf()).sym == ad) &&
        !(t.ty == Tstruct && (cast(TypeStruct)t).sym == ad))
    {
        ClassDeclaration cd = ad.isClassDeclaration();
        ClassDeclaration tcd = t.isClassHandle();

        /* e1 is the right this if ad is a base class of e1
         */
        if (!cd || !tcd || !(tcd == cd || cd.isBaseOf(tcd, null)))
        {
            /* Only classes can be inner classes with an 'outer'
             * member pointing to the enclosing class instance
             */
            if (tcd && tcd.isNested())
            {
                /* e1 is the 'this' pointer for an inner class: tcd.
                 * Rewrite it as the 'this' pointer for the outer class.
                 */
                auto vthis = tcd.followInstantiationContext(ad) ? tcd.vthis2 : tcd.vthis;
                e1 = new DotVarExp(место, e1, vthis);
                e1.тип = vthis.тип;
                e1.тип = e1.тип.addMod(t.mod);
                // Do not call ensureStaticLinkTo()
                //e1 = e1.semantic(sc);

                // Skip up over nested functions, and get the enclosing
                // class тип.
                e1 = getThisSkipNestedFuncs(место, sc, tcd.toParentP(ad), ad, e1, t, var);
                if (e1.op == ТОК2.error)
                    return e1;
                goto L1;
            }

            /* Can't найди a path from e1 to ad
             */
            if (флаг)
                return null;
            e1.выведиОшибку("`this` for `%s` needs to be тип `%s` not тип `%s`", var.вТкст0(), ad.вТкст0(), t.вТкст0());
            return new ErrorExp();
        }
    }
    return e1;
}

/***************************************
 * Pull out any properties.
 */
private Выражение resolvePropertiesX(Scope* sc, Выражение e1, Выражение e2 = null)
{
    //printf("resolvePropertiesX, e1 = %s %s, e2 = %s\n", Сема2.вТкст0(e1.op), e1.вТкст0(), e2 ? e2.вТкст0() : null);
    Место место = e1.место;

    OverloadSet ос;
    ДСимвол s;
    Объекты* tiargs;
    Тип tthis;
    if (e1.op == ТОК2.dot)
    {
        DotExp de = cast(DotExp)e1;
        if (de.e2.op == ТОК2.overloadSet)
        {
            tiargs = null;
            tthis = de.e1.тип;
            ос = (cast(OverExp)de.e2).vars;
            goto Los;
        }
    }
    else if (e1.op == ТОК2.overloadSet)
    {
        tiargs = null;
        tthis = null;
        ос = (cast(OverExp)e1).vars;
    Los:
        assert(ос);
        FuncDeclaration fd = null;
        if (e2)
        {
            e2 = e2.ВыражениеSemantic(sc);
            if (e2.op == ТОК2.error)
                return new ErrorExp();
            e2 = resolveProperties(sc, e2);

            Выражения a;
            a.сунь(e2);

            for (т_мера i = 0; i < ос.a.dim; i++)
            {
                if (FuncDeclaration f = resolveFuncCall(место, sc, ос.a[i], tiargs, tthis, &a, FuncResolveFlag.quiet))
                {
                    if (f.errors)
                        return new ErrorExp();
                    fd = f;
                    assert(fd.тип.ty == Tfunction);
                }
            }
            if (fd)
            {
                Выражение e = new CallExp(место, e1, e2);
                return e.ВыражениеSemantic(sc);
            }
        }
        {
            for (т_мера i = 0; i < ос.a.dim; i++)
            {
                if (FuncDeclaration f = resolveFuncCall(место, sc, ос.a[i], tiargs, tthis, null, FuncResolveFlag.quiet))
                {
                    if (f.errors)
                        return new ErrorExp();
                    fd = f;
                    assert(fd.тип.ty == Tfunction);
                    TypeFunction tf = cast(TypeFunction)fd.тип;
                    if (!tf.isref && e2)
                    {
                        выведиОшибку(место, "%s is not an lvalue", e1.вТкст0());
                        return new ErrorExp();
                    }
                }
            }
            if (fd)
            {
                Выражение e = new CallExp(место, e1);
                if (e2)
                    e = new AssignExp(место, e, e2);
                return e.ВыражениеSemantic(sc);
            }
        }
        if (e2)
            goto Leprop;
    }
    else if (e1.op == ТОК2.dotTemplateInstance)
    {
        DotTemplateInstanceExp dti = cast(DotTemplateInstanceExp)e1;
        if (!dti.findTempDecl(sc))
            goto Leprop;
        if (!dti.ti.semanticTiargs(sc))
            goto Leprop;
        tiargs = dti.ti.tiargs;
        tthis = dti.e1.тип;
        if ((ос = dti.ti.tempdecl.isOverloadSet()) !is null)
            goto Los;
        if ((s = dti.ti.tempdecl) !is null)
            goto Lfd;
    }
    else if (e1.op == ТОК2.dotTemplateDeclaration)
    {
        DotTemplateExp dte = cast(DotTemplateExp)e1;
        s = dte.td;
        tiargs = null;
        tthis = dte.e1.тип;
        goto Lfd;
    }
    else if (e1.op == ТОК2.scope_)
    {
        s = (cast(ScopeExp)e1).sds;
        TemplateInstance ti = s.isTemplateInstance();
        if (ti && !ti.semanticRun && ti.tempdecl)
        {
            //assert(ti.needsTypeInference(sc));
            if (!ti.semanticTiargs(sc))
                goto Leprop;
            tiargs = ti.tiargs;
            tthis = null;
            if ((ос = ti.tempdecl.isOverloadSet()) !is null)
                goto Los;
            if ((s = ti.tempdecl) !is null)
                goto Lfd;
        }
    }
    else if (e1.op == ТОК2.template_)
    {
        s = (cast(TemplateExp)e1).td;
        tiargs = null;
        tthis = null;
        goto Lfd;
    }
    else if (e1.op == ТОК2.dotVariable && e1.тип && e1.тип.toBasetype().ty == Tfunction)
    {
        DotVarExp dve = cast(DotVarExp)e1;
        s = dve.var.isFuncDeclaration();
        tiargs = null;
        tthis = dve.e1.тип;
        goto Lfd;
    }
    else if (e1.op == ТОК2.variable && e1.тип && e1.тип.toBasetype().ty == Tfunction)
    {
        s = (cast(VarExp)e1).var.isFuncDeclaration();
        tiargs = null;
        tthis = null;
    Lfd:
        assert(s);
        if (e2)
        {
            e2 = e2.ВыражениеSemantic(sc);
            if (e2.op == ТОК2.error)
                return new ErrorExp();
            e2 = resolveProperties(sc, e2);

            Выражения a;
            a.сунь(e2);

            FuncDeclaration fd = resolveFuncCall(место, sc, s, tiargs, tthis, &a, FuncResolveFlag.quiet);
            if (fd && fd.тип)
            {
                if (fd.errors)
                    return new ErrorExp();
                assert(fd.тип.ty == Tfunction);
                Выражение e = new CallExp(место, e1, e2);
                return e.ВыражениеSemantic(sc);
            }
        }
        {
            FuncDeclaration fd = resolveFuncCall(место, sc, s, tiargs, tthis, null, FuncResolveFlag.quiet);
            if (fd && fd.тип)
            {
                if (fd.errors)
                    return new ErrorExp();
                assert(fd.тип.ty == Tfunction);
                TypeFunction tf = cast(TypeFunction)fd.тип;
                if (!e2 || tf.isref)
                {
                    Выражение e = new CallExp(место, e1);
                    if (e2)
                        e = new AssignExp(место, e, e2);
                    return e.ВыражениеSemantic(sc);
                }
            }
        }
        if (FuncDeclaration fd = s.isFuncDeclaration())
        {
            // Keep better diagnostic message for invalid property использование of functions
            assert(fd.тип.ty == Tfunction);
            Выражение e = new CallExp(место, e1, e2);
            return e.ВыражениеSemantic(sc);
        }
        if (e2)
            goto Leprop;
    }
    if (e1.op == ТОК2.variable)
    {
        VarExp ve = cast(VarExp)e1;
        VarDeclaration v = ve.var.isVarDeclaration();
        if (v && ve.checkPurity(sc, v))
            return new ErrorExp();
    }
    if (e2)
        return null;

    if (e1.тип && e1.op != ТОК2.тип) // function тип is not a property
    {
        /* Look for e1 being a lazy параметр; rewrite as delegate call
         * only if the symbol wasn't already treated as a delegate
         */
        auto ve = e1.isVarExp();
        if (ve && ve.var.класс_хранения & STC.lazy_ && !ve.delegateWasExtracted)
        {
                Выражение e = new CallExp(место, e1);
                return e.ВыражениеSemantic(sc);
        }
        else if (e1.op == ТОК2.dotVariable)
        {
            // Check for reading overlapped pointer field in  code.
            if (checkUnsafeAccess(sc, e1, да, да))
                return new ErrorExp();
        }
        else if (e1.op == ТОК2.dot)
        {
            e1.выведиОшибку("Выражение has no значение");
            return new ErrorExp();
        }
        else if (e1.op == ТОК2.call)
        {
            CallExp ce = cast(CallExp)e1;
            // Check for reading overlapped pointer field in  code.
            if (checkUnsafeAccess(sc, ce.e1, да, да))
                return new ErrorExp();
        }
    }

    if (!e1.тип)
    {
        выведиОшибку(место, "cannot resolve тип for %s", e1.вТкст0());
        e1 = new ErrorExp();
    }
    return e1;

Leprop:
    выведиОшибку(место, "not a property %s", e1.вТкст0());
    return new ErrorExp();
}

 Выражение resolveProperties(Scope* sc, Выражение e)
{
    //printf("resolveProperties(%s)\n", e.вТкст0());
    e = resolvePropertiesX(sc, e);
    if (e.checkRightThis(sc))
        return new ErrorExp();
    return e;
}

/****************************************
 * The common тип is determined by applying ?: to each pair.
 * Output:
 *      exps[]  properties resolved, implicitly cast to common тип, rewritten in place
 *      *pt     if pt is not NULL, set to the common тип
 * Возвращает:
 *      да    a semantic error was detected
 */
private бул arrayВыражениеToCommonType(Scope* sc, Выражения* exps, Тип* pt)
{
    /* Still have a problem with:
     *  ббайт[][] = [ cast(ббайт[])"hello", [1]];
     * which works if the массив literal is initialized top down with the ббайт[][]
     * тип, but fails with this function doing bottom up typing.
     */

    //printf("arrayВыражениеToCommonType()\n");
    scope IntegerExp integerexp = IntegerExp.literal!(0);
    scope CondExp condexp = new CondExp(Место.initial, integerexp, null, null);

    Тип t0 = null;
    Выражение e0 = null;
    т_мера j0 = ~0;
    бул foundType;

    for (т_мера i = 0; i < exps.dim; i++)
    {
        Выражение e = (*exps)[i];
        if (!e)
            continue;

        e = resolveProperties(sc, e);
        if (!e.тип)
        {
            e.выведиОшибку("`%s` has no значение", e.вТкст0());
            t0 = Тип.terror;
            continue;
        }
        if (e.op == ТОК2.тип)
        {
            foundType = да; // do not break immediately, there might be more errors
            e.checkValue(); // report an error "тип T has no значение"
            t0 = Тип.terror;
            continue;
        }
        if (e.тип.ty == Tvoid)
        {
            // проц Выражения do not concur to the determination of the common
            // тип.
            continue;
        }
        if (checkNonAssignmentArrayOp(e))
        {
            t0 = Тип.terror;
            continue;
        }

        e = doCopyOrMove(sc, e);

        if (!foundType && t0 && !t0.равен(e.тип))
        {
            /* This applies ?: to merge the types. It's backwards;
             * ?: should call this function to merge types.
             */
            condexp.тип = null;
            condexp.e1 = e0;
            condexp.e2 = e;
            condexp.место = e.место;
            Выражение ex = condexp.ВыражениеSemantic(sc);
            if (ex.op == ТОК2.error)
                e = ex;
            else
            {
                (*exps)[j0] = condexp.e1;
                e = condexp.e2;
            }
        }
        j0 = i;
        e0 = e;
        t0 = e.тип;
        if (e.op != ТОК2.error)
            (*exps)[i] = e;
    }

    if (!t0)
        t0 = Тип.tvoid; // [] is typed as проц[]
    else if (t0.ty != Terror)
    {
        for (т_мера i = 0; i < exps.dim; i++)
        {
            Выражение e = (*exps)[i];
            if (!e)
                continue;

            e = e.implicitCastTo(sc, t0);
            //assert(e.op != ТОК2.error);
            if (e.op == ТОК2.error)
            {
                /* https://issues.dlang.org/show_bug.cgi?ид=13024
                 * a workaround for the bug in typeMerge -
                 * it should paint e1 and e2 by deduced common тип,
                 * but doesn't in this particular case.
                 */
                t0 = Тип.terror;
                break;
            }
            (*exps)[i] = e;
        }
    }
    if (pt)
        *pt = t0;

    return (t0 == Тип.terror);
}

private Выражение opAssignToOp(ref Место место, ТОК2 op, Выражение e1, Выражение e2)
{
    Выражение e;
    switch (op)
    {
    case ТОК2.addAssign:
        e = new AddExp(место, e1, e2);
        break;

    case ТОК2.minAssign:
        e = new MinExp(место, e1, e2);
        break;

    case ТОК2.mulAssign:
        e = new MulExp(место, e1, e2);
        break;

    case ТОК2.divAssign:
        e = new DivExp(место, e1, e2);
        break;

    case ТОК2.modAssign:
        e = new ModExp(место, e1, e2);
        break;

    case ТОК2.andAssign:
        e = new AndExp(место, e1, e2);
        break;

    case ТОК2.orAssign:
        e = new OrExp(место, e1, e2);
        break;

    case ТОК2.xorAssign:
        e = new XorExp(место, e1, e2);
        break;

    case ТОК2.leftShiftAssign:
        e = new ShlExp(место, e1, e2);
        break;

    case ТОК2.rightShiftAssign:
        e = new ShrExp(место, e1, e2);
        break;

    case ТОК2.unsignedRightShiftAssign:
        e = new UshrExp(место, e1, e2);
        break;

    default:
        assert(0);
    }
    return e;
}

/*********************
 * Rewrite:
 *    массив.length op= e2
 * as:
 *    массив.length = массив.length op e2
 * or:
 *    auto tmp = &массив;
 *    (*tmp).length = (*tmp).length op e2
 */
private Выражение rewriteOpAssign(BinExp exp)
{
    Выражение e;

    assert(exp.e1.op == ТОК2.arrayLength);
    ArrayLengthExp ale = cast(ArrayLengthExp)exp.e1;
    if (ale.e1.op == ТОК2.variable)
    {
        e = opAssignToOp(exp.место, exp.op, ale, exp.e2);
        e = new AssignExp(exp.место, ale.syntaxCopy(), e);
    }
    else
    {
        /*    auto tmp = &массив;
         *    (*tmp).length = (*tmp).length op e2
         */
        auto tmp = copyToTemp(0, "__arraylength", new AddrExp(ale.место, ale.e1));

        Выражение e1 = new ArrayLengthExp(ale.место, new PtrExp(ale.место, new VarExp(ale.место, tmp)));
        Выражение elvalue = e1.syntaxCopy();
        e = opAssignToOp(exp.место, exp.op, e1, exp.e2);
        e = new AssignExp(exp.место, elvalue, e);
        e = new CommaExp(exp.место, new DeclarationExp(ale.место, tmp), e);
    }
    return e;
}

/****************************************
 * Preprocess arguments to function.
 * Input:
 *      reportErrors    whether or not to report errors here.  Some callers are not
 *                      checking actual function парамы, so they'll do their own error reporting
 * Output:
 *      exps[]  tuples expanded, properties resolved, rewritten in place
 * Возвращает:
 *      да    a semantic error occurred
 */
private бул preFunctionParameters(Scope* sc, Выражения* exps, бул reportErrors = да)
{
    бул err = нет;
    if (exps)
    {
        expandTuples(exps);

        for (т_мера i = 0; i < exps.dim; i++)
        {
            Выражение arg = (*exps)[i];
            arg = resolveProperties(sc, arg);
            if (arg.op == ТОК2.тип)
            {
                // for static alias this: https://issues.dlang.org/show_bug.cgi?ид=17684
                arg = resolveAliasThis(sc, arg);

                if (arg.op == ТОК2.тип)
                {
                    if (reportErrors)
                    {
                        arg.выведиОшибку("cannot pass тип `%s` as a function argument", arg.вТкст0());
                        arg = new ErrorExp();
                    }
                    err = да;
                }
            }
            else if (arg.тип.toBasetype().ty == Tfunction)
            {
                if (reportErrors)
                {
                    arg.выведиОшибку("cannot pass function `%s` as a function argument", arg.вТкст0());
                    arg = new ErrorExp();
                }
                err = да;
            }
            else if (checkNonAssignmentArrayOp(arg))
            {
                arg = new ErrorExp();
                err = да;
            }
            (*exps)[i] = arg;
        }
    }
    return err;
}

/********************************************
 * Issue an error if default construction is disabled for тип t.
 * Default construction is required for arrays and 'out' parameters.
 * Возвращает:
 *      да    an error was issued
 */
private бул checkDefCtor(Место место, Тип t)
{
    t = t.baseElemOf();
    if (t.ty == Tstruct)
    {
        StructDeclaration sd = (cast(TypeStruct)t).sym;
        if (sd.noDefaultCtor)
        {
            sd.выведиОшибку(место, "default construction is disabled");
            return да;
        }
    }
    return нет;
}

/****************************************
 * Now that we know the exact тип of the function we're calling,
 * the arguments[] need to be adjusted:
 *      1. implicitly convert argument to the corresponding параметр тип
 *      2. add default arguments for any missing arguments
 *      3. do default promotions on arguments corresponding to ...
 *      4. add hidden _arguments[] argument
 *      5. call копируй constructor for struct значение arguments
 * Параметры:
 *      место       = location of function call
 *      sc        = context
 *      tf        = тип of the function
 *      ethis     = `this` argument, `null` if none or not known
 *      tthis     = тип of `this` argument, `null` if no `this` argument
 *      arguments = массив of actual arguments to function call
 *      fd        = the function being called, `null` if called indirectly
 *      prettype  = set to return тип of function
 *      peprefix  = set to Выражение to execute before `arguments[]` are evaluated, `null` if none
 * Возвращает:
 *      да    errors happened
 */
private бул functionParameters(ref Место место, Scope* sc,
    TypeFunction tf, Выражение ethis, Тип tthis, Выражения* arguments, FuncDeclaration fd,
    Тип* prettype, Выражение* peprefix)
{
    //printf("functionParameters() %s\n", fd ? fd.вТкст0() : "");
    assert(arguments);
    assert(fd || tf.следщ);
    т_мера nargs = arguments ? arguments.dim : 0;
    const т_мера nparams = tf.parameterList.length;
    const olderrors = глоб2.errors;
    бул err = нет;
    *prettype = Тип.terror;
    Выражение eprefix = null;
    *peprefix = null;

    if (nargs > nparams && tf.parameterList.varargs == ВарАрг.none)
    {
        выведиОшибку(место, "expected %llu arguments, not %llu for non-variadic function тип `%s`", cast(бдол)nparams, cast(бдол)nargs, tf.вТкст0());
        return да;
    }

    // If inferring return тип, and semantic3() needs to be run if not already run
    if (!tf.следщ && fd.inferRetType)
    {
        fd.functionSemantic();
    }
    else if (fd && fd.родитель)
    {
        TemplateInstance ti = fd.родитель.isTemplateInstance();
        if (ti && ti.tempdecl)
        {
            fd.functionSemantic3();
        }
    }
    const isCtorCall = fd && fd.needThis() && fd.isCtorDeclaration();

    const т_мера n = (nargs > nparams) ? nargs : nparams; // n = max(nargs, nparams)

    /* If the function return тип has wildcards in it, we'll need to figure out the actual тип
     * based on the actual argument types.
     * Start with the `this` argument, later on merge into wildmatch the mod bits of the rest
     * of the arguments.
     */
    MOD wildmatch = (tthis && !isCtorCall) ? tthis.Тип.deduceWild(tf, нет) : 0;

    бул done = нет;
    foreach ( i; new бцел[0 .. n])
    {
        Выражение arg = (i < nargs) ? (*arguments)[i] : null;

        if (i < nparams)
        {
            бул errorArgs()
            {
                выведиОшибку(место, "expected %llu function arguments, not %llu", cast(бдол)nparams, cast(бдол)nargs);
                return да;
            }

            Параметр2 p = tf.parameterList[i];
            const бул isRef = (p.классХранения & (STC.ref_ | STC.out_)) != 0;

            if (!arg)
            {
                if (!p.defaultArg)
                {
                    if (tf.parameterList.varargs == ВарАрг.typesafe && i + 1 == nparams)
                        goto L2;
                    return errorArgs();
                }
                arg = p.defaultArg;
                arg = inlineCopy(arg, sc);
                // __FILE__, __LINE__, __MODULE__, __FUNCTION__, and __PRETTY_FUNCTION__
                arg = arg.resolveLoc(место, sc);
                arguments.сунь(arg);
                nargs++;
            }
            else
            {
                if (arg.op == ТОК2.default_)
                {
                    arg = arg.resolveLoc(место, sc);
                    (*arguments)[i] = arg;
                }
            }


            if (isRef && !p.тип.isConst && !p.тип.isImmutable
                && (p.классХранения & STC.const_) != STC.const_
                && (p.классХранения & STC.immutable_) != STC.immutable_
                && checkIfIsStructLiteralDotExpr(arg))
                    break;

            if (tf.parameterList.varargs == ВарАрг.typesafe && i + 1 == nparams) // https://dlang.org/spec/function.html#variadic
            {
                //printf("\t\tvarargs == 2, p.тип = '%s'\n", p.тип.вТкст0());
                {
                    MATCH m;
                    if ((m = arg.implicitConvTo(p.тип)) > MATCH.nomatch)
                    {
                        if (p.тип.nextOf() && arg.implicitConvTo(p.тип.nextOf()) >= m)
                            goto L2;
                        else if (nargs != nparams)
                            return errorArgs();
                        goto L1;
                    }
                }
            L2:
                Тип tb = p.тип.toBasetype();
                switch (tb.ty)
                {
                case Tsarray:
                case Tarray:
                    {
                        /* Create a static массив variable v of тип arg.тип:
                         *  T[dim] __arrayArg = [ arguments[i], ..., arguments[nargs-1] ];
                         *
                         * The массив literal in the инициализатор of the hidden variable
                         * is now optimized.
                         * https://issues.dlang.org/show_bug.cgi?ид=2356
                         */
                        Тип tbn = (cast(TypeArray)tb).следщ;    // массив element тип
                        Тип tret = p.isLazyArray();

                        auto elements = new Выражения(nargs - i);
                        foreach (u; new бцел[0 .. elements.dim])
                        {
                            Выражение a = (*arguments)[i + u];
                            if (tret && a.implicitConvTo(tret))
                            {
                                // p is a lazy массив of delegates, tret is return тип of the delegates
                                a = a.implicitCastTo(sc, tret)
                                     .optimize(WANTvalue)
                                     .toDelegate(tret, sc);
                            }
                            else
                                a = a.implicitCastTo(sc, tbn);
                            a = a.addDtorHook(sc);
                            (*elements)[u] = a;
                        }
                        // https://issues.dlang.org/show_bug.cgi?ид=14395
                        // Convert to a static массив literal, or its slice.
                        arg = new ArrayLiteralExp(место, tbn.sarrayOf(nargs - i), elements);
                        if (tb.ty == Tarray)
                        {
                            arg = new SliceExp(место, arg, null, null);
                            arg.тип = p.тип;
                        }
                        break;
                    }
                case Tclass:
                    {
                        /* Set arg to be:
                         *      new Tclass(arg0, arg1, ..., argn)
                         */
                        auto args = new Выражения(nargs - i);
                        foreach (u; new бцел[i .. nargs])
                            (*args)[u - i] = (*arguments)[u];
                        arg = new NewExp(место, null, null, p.тип, args);
                        break;
                    }
                default:
                    if (!arg)
                    {
                        выведиОшибку(место, "not enough arguments");
                        return да;
                    }
                    break;
                }
                arg = arg.ВыражениеSemantic(sc);
                //printf("\targ = '%s'\n", arg.вТкст0());
                arguments.устДим(i + 1);
                (*arguments)[i] = arg;
                nargs = i + 1;
                done = да;
            }

        L1:
            if (!(p.классХранения & STC.lazy_ && p.тип.ty == Tvoid))
            {

                if (ббайт wm = arg.тип.deduceWild(p.тип, isRef))
                {
                    wildmatch = wildmatch ? MODmerge(wildmatch, wm) : wm;
                    //printf("[%d] p = %s, a = %s, wm = %d, wildmatch = %d\n", i, p.тип.вТкст0(), arg.тип.вТкст0(), wm, wildmatch);
                }
            }
        }
        if (done)
            break;
    }
    if ((wildmatch == MODFlags.mutable || wildmatch == MODFlags.immutable_) &&
        tf.следщ && tf.следщ.hasWild() &&
        (tf.isref || !tf.следщ.implicitConvTo(tf.следщ.immutableOf())))
    {
        бул errorInout(MOD wildmatch)
        {
            ткст0 s = wildmatch == MODFlags.mutable ? "mutable" : MODtoChars(wildmatch);
            выведиОшибку(место, "modify `inout` to `%s` is not allowed inside `inout` function", s);
            return да;
        }

        if (fd)
        {
            /* If the called function may return the reference to
             * outer inout данные, it should be rejected.
             *
             * проц foo(ref inout(цел) x) {
             *   ref inout(цел) bar(inout(цел)) { return x; }
             *   struct S {
             *      ref inout(цел) bar() inout { return x; }
             *      ref inout(цел) baz(alias a)() inout { return x; }
             *   }
             *   bar(цел.init) = 1;  // bad!
             *   S().bar() = 1;      // bad!
             * }
             * проц test() {
             *   цел a;
             *   auto s = foo(a);
             *   s.baz!a() = 1;      // bad!
             * }
             *
             */
            бул checkEnclosingWild(ДСимвол s)
            {
                бул checkWild(ДСимвол s)
                {
                    if (!s)
                        return нет;
                    if (auto ad = s.isAggregateDeclaration())
                    {
                        if (ad.isNested())
                            return checkEnclosingWild(s);
                    }
                    else if (auto ff = s.isFuncDeclaration())
                    {
                        if ((cast(TypeFunction)ff.тип).iswild)
                            return errorInout(wildmatch);

                        if (ff.isNested() || ff.isThis())
                            return checkEnclosingWild(s);
                    }
                    return нет;
                }

                ДСимвол ctx0 = s.toParent2();
                ДСимвол ctx1 = s.toParentLocal();
                if (checkWild(ctx0))
                    return да;
                if (ctx0 != ctx1)
                    return checkWild(ctx1);
                return нет;
            }
            if ((fd.isThis() || fd.isNested()) && checkEnclosingWild(fd))
                return да;
        }
        else if (tf.isWild())
            return errorInout(wildmatch);
    }

    Выражение firstArg = ((tf.следщ && tf.следщ.ty == Tvoid || isCtorCall) &&
                           tthis &&
                           tthis.isMutable() && tthis.toBasetype().ty == Tstruct &&
                           tthis.hasPointers())
                          ? ethis : null;

    assert(nargs >= nparams);
    foreach ( i, arg; (*arguments)[0 .. nargs])
    {
        assert(arg);
        if (i < nparams)
        {
            Параметр2 p = tf.parameterList[i];
            Тип targ = arg.тип;               // keep original тип for isCopyable() because alias this
                                                // resolution may hide an uncopyable тип

            if (!(p.классХранения & STC.lazy_ && p.тип.ty == Tvoid))
            {
                Тип tprm = p.тип.hasWild()
                    ? p.тип.substWildTo(wildmatch)
                    : p.тип;

                const hasCopyCtor = (arg.тип.ty == Tstruct) && (cast(TypeStruct)arg.тип).sym.hasCopyCtor;
                const typesMatch = arg.тип.mutableOf().unSharedOf().равен(tprm.mutableOf().unSharedOf());
                if (!((hasCopyCtor && typesMatch) || tprm.равен(arg.тип)))
                {
                    //printf("arg.тип = %s, p.тип = %s\n", arg.тип.вТкст0(), p.тип.вТкст0());
                    arg = arg.implicitCastTo(sc, tprm);
                    arg = arg.optimize(WANTvalue, (p.классХранения & (STC.ref_ | STC.out_)) != 0);
                }
            }
            if (p.классХранения & STC.ref_)
            {
                if (глоб2.парамы.rvalueRefParam &&
                    !arg.isLvalue() &&
                    targ.isCopyable())
                {   /* allow rvalues to be passed to ref parameters by copying
                     * them to a temp, then pass the temp as the argument
                     */
                    auto v = copyToTemp(0, "__rvalue", arg);
                    Выражение ev = new DeclarationExp(arg.место, v);
                    ev = new CommaExp(arg.место, ev, new VarExp(arg.место, v));
                    arg = ev.ВыражениеSemantic(sc);
                }
                arg = arg.toLvalue(sc, arg);

                // Look for mutable misaligned pointer, etc., in  mode
                err |= checkUnsafeAccess(sc, arg, нет, да);
            }
            else if (p.классХранения & STC.out_)
            {
                Тип t = arg.тип;
                if (!t.isMutable() || !t.isAssignable()) // check blit assignable
                {
                    arg.выведиОшибку("cannot modify struct `%s` with const члены", arg.вТкст0());
                    err = да;
                }
                else
                {
                    // Look for misaligned pointer, etc., in  mode
                    err |= checkUnsafeAccess(sc, arg, нет, да);
                    err |= checkDefCtor(arg.место, t); // t must be default constructible
                }
                arg = arg.toLvalue(sc, arg);
            }
            else if (p.классХранения & STC.lazy_)
            {
                // Convert lazy argument to a delegate
                auto t = (p.тип.ty == Tvoid) ? p.тип : arg.тип;
                arg = toDelegate(arg, t, sc);
            }
            //printf("arg: %s\n", arg.вТкст0());
            //printf("тип: %s\n", arg.тип.вТкст0());
            //printf("param: %s\n", p.вТкст0());

            if (firstArg && p.классХранения & STC.return_)
            {
                /* Argument значение can be assigned to firstArg.
                 * Check arg to see if it matters.
                 */
                if (глоб2.парамы.vsafe)
                    err |= checkParamArgumentReturn(sc, firstArg, arg, нет);
            }
            else if (tf.parameterEscapes(tthis, p))
            {
                /* Argument значение can ýñêàïèðóé from the called function.
                 * Check arg to see if it matters.
                 */
                if (глоб2.парамы.vsafe)
                    err |= checkParamArgumentEscape(sc, fd, p, arg, нет);
            }
            else
            {
                /* Argument значение cannot ýñêàïèðóé from the called function.
                 */
                Выражение a = arg;
                if (a.op == ТОК2.cast_)
                    a = (cast(CastExp)a).e1;
                if (a.op == ТОК2.function_)
                {
                    /* Function literals can only appear once, so if this
                     * appearance was scoped, there cannot be any others.
                     */
                    FuncExp fe = cast(FuncExp)a;
                    fe.fd.tookAddressOf = 0;
                }
                else if (a.op == ТОК2.delegate_)
                {
                    /* For passing a delegate to a scoped параметр,
                     * this doesn't count as taking the address of it.
                     * We only worry about 'escaping' references to the function.
                     */
                    DelegateExp de = cast(DelegateExp)a;
                    if (de.e1.op == ТОК2.variable)
                    {
                        VarExp ve = cast(VarExp)de.e1;
                        FuncDeclaration f = ve.var.isFuncDeclaration();
                        if (f)
                        {
                            f.tookAddressOf--;
                            //printf("--tookAddressOf = %d\n", f.tookAddressOf);
                        }
                    }
                }
            }
            if (!(p.классХранения & (STC.ref_ | STC.out_)))
                err |= arg.checkSharedAccess(sc);

            arg = arg.optimize(WANTvalue, (p.классХранения & (STC.ref_ | STC.out_)) != 0);

            /* Determine if this параметр is the "first reference" параметр through which
             * later "return" arguments can be stored.
             */
            if (i == 0 && !tthis && p.классХранения & (STC.ref_ | STC.out_) && p.тип &&
                (tf.следщ && tf.следщ.ty == Tvoid || isCtorCall))
            {
                Тип tb = p.тип.baseElemOf();
                if (tb.isMutable() && tb.hasPointers())
                {
                    firstArg = arg;
                }
            }
        }
        else
        {
            // These will be the trailing ... arguments
            // If not D компонаж, do promotions
            if (tf.компонаж != LINK.d)
            {
                // Promote bytes, words, etc., to ints
                arg = integralPromotions(arg, sc);

                // Promote floats to doubles
                switch (arg.тип.ty)
                {
                case Tfloat32:
                    arg = arg.castTo(sc, Тип.tfloat64);
                    break;

                case Timaginary32:
                    arg = arg.castTo(sc, Тип.timaginary64);
                    break;

                default:
                    break;
                }
                if (tf.parameterList.varargs == ВарАрг.variadic)
                {
                    ткст0 p = tf.компонаж == LINK.c ? "extern(C)" : "/*extern(C++)*/";
                    if (arg.тип.ty == Tarray)
                    {
                        arg.выведиОшибку("cannot pass dynamic arrays to `%s` vararg functions", p);
                        err = да;
                    }
                    if (arg.тип.ty == Tsarray)
                    {
                        arg.выведиОшибку("cannot pass static arrays to `%s` vararg functions", p);
                        err = да;
                    }
                }
            }

            // Do not allow types that need destructors
            if (arg.тип.needsDestruction())
            {
                arg.выведиОшибку("cannot pass types that need destruction as variadic arguments");
                err = да;
            }

            // Convert static arrays to dynamic arrays
            // BUG: I don't think this is right for D2
            Тип tb = arg.тип.toBasetype();
            if (tb.ty == Tsarray)
            {
                TypeSArray ts = cast(TypeSArray)tb;
                Тип ta = ts.следщ.arrayOf();
                if (ts.size(arg.место) == 0)
                    arg = new NullExp(arg.место, ta);
                else
                    arg = arg.castTo(sc, ta);
            }
            if (tb.ty == Tstruct)
            {
                //arg = callCpCtor(sc, arg);
            }
            // Give error for overloaded function addresses
            if (arg.op == ТОК2.symbolOffset)
            {
                SymOffExp se = cast(SymOffExp)arg;
                if (se.hasOverloads && !se.var.isFuncDeclaration().isUnique())
                {
                    arg.выведиОшибку("function `%s` is overloaded", arg.вТкст0());
                    err = да;
                }
            }
            err |= arg.checkValue();
            err |= arg.checkSharedAccess(sc);
            arg = arg.optimize(WANTvalue);
        }
        (*arguments)[i] = arg;
    }

    /* Remaining problems:
     * 1. order of evaluation - some function сунь L-to-R, others R-to-L. Until we resolve what массив assignment does (which is
     *    implemented by calling a function) we'll defer this for now.
     * 2. значение structs (or static arrays of them) that need to be копируй constructed
     * 3. значение structs (or static arrays of them) that have destructors, and subsequent arguments that may throw before the
     *    function gets called (functions normally разрушь their parameters)
     * 2 and 3 are handled by doing the argument construction in 'eprefix' so that if a later argument throws, they are cleaned
     * up properly. Pushing arguments on the stack then cannot fail.
     */
    {
        /* TODO: tackle problem 1)
         */
        const бул leftToRight = да; // TODO: something like !fd.isArrayOp
        if (!leftToRight)
            assert(nargs == nparams); // no variadics for RTL order, as they would probably be evaluated LTR and so add complexity

        const ptrdiff_t start = (leftToRight ? 0 : cast(ptrdiff_t)nargs - 1);
        const ptrdiff_t end = (leftToRight ? cast(ptrdiff_t)nargs : -1);
        const ptrdiff_t step = (leftToRight ? 1 : -1);

        /* Compute indices of last throwing argument and first arg needing destruction.
         * Used to not set up destructors unless an arg needs destruction on a throw
         * in a later argument.
         */
        ptrdiff_t lastthrow = -1;
        ptrdiff_t firstdtor = -1;
        for (ptrdiff_t i = start; i != end; i += step)
        {
            Выражение arg = (*arguments)[i];
            if (canThrow(arg, sc.func, нет))
                lastthrow = i;
            if (firstdtor == -1 && arg.тип.needsDestruction())
            {
                Параметр2 p = (i >= nparams ? null : tf.parameterList[i]);
                if (!(p && (p.классХранения & (STC.lazy_ | STC.ref_ | STC.out_))))
                    firstdtor = i;
            }
        }

        /* Does problem 3) apply to this call?
         */
        const бул needsPrefix = (firstdtor >= 0 && lastthrow >= 0
            && (lastthrow - firstdtor) * step > 0);

        /* If so, initialize 'eprefix' by declaring the gate
         */
        VarDeclaration gate = null;
        if (needsPrefix)
        {
            // eprefix => бул __gate [= нет]
            Идентификатор2 idtmp = Идентификатор2.генерируйИд("__gate");
            gate = new VarDeclaration(место, Тип.tбул, idtmp, null);
            gate.класс_хранения |= STC.temp | STC.ctfe | STC.volatile_;
            gate.dsymbolSemantic(sc);

            auto ae = new DeclarationExp(место, gate);
            eprefix = ae.ВыражениеSemantic(sc);
        }

        for (ptrdiff_t i = start; i != end; i += step)
        {
            Выражение arg = (*arguments)[i];

            Параметр2 параметр = (i >= nparams ? null : tf.parameterList[i]);
            const бул isRef = (параметр && (параметр.классХранения & (STC.ref_ | STC.out_)));
            const бул isLazy = (параметр && (параметр.классХранения & STC.lazy_));

            /* Skip lazy parameters
             */
            if (isLazy)
                continue;

            /* Do we have a gate? Then we have a префикс and we're not yet past the last throwing arg.
             * Declare a temporary variable for this arg and приставь that declaration to 'eprefix',
             * which will implicitly take care of potential problem 2) for this arg.
             * 'eprefix' will therefore finally contain all args up to and including the last
             * potentially throwing arg, excluding all lazy parameters.
             */
            if (gate)
            {
                const бул needsDtor = (!isRef && arg.тип.needsDestruction() && i != lastthrow);

                /* Declare temporary 'auto __pfx = arg' (needsDtor) or 'auto __pfy = arg' (!needsDtor)
                 */
                auto tmp = copyToTemp(0,
                    needsDtor ? "__pfx" : "__pfy",
                    !isRef ? arg : arg.addressOf());
                tmp.dsymbolSemantic(sc);

                /* Modify the destructor so it only runs if gate==нет, i.e.,
                 * only if there was a throw while constructing the args
                 */
                if (!needsDtor)
                {
                    if (tmp.edtor)
                    {
                        assert(i == lastthrow);
                        tmp.edtor = null;
                    }
                }
                else
                {
                    // edtor => (__gate || edtor)
                    assert(tmp.edtor);
                    Выражение e = tmp.edtor;
                    e = new LogicalExp(e.место, ТОК2.orOr, new VarExp(e.место, gate), e);
                    tmp.edtor = e.ВыражениеSemantic(sc);
                    //printf("edtor: %s\n", tmp.edtor.вТкст0());
                }

                // eprefix => (eprefix, auto __pfx/y = arg)
                auto ae = new DeclarationExp(место, tmp);
                eprefix = Выражение.combine(eprefix, ae.ВыражениеSemantic(sc));

                // arg => __pfx/y
                arg = new VarExp(место, tmp);
                arg = arg.ВыражениеSemantic(sc);
                if (isRef)
                {
                    arg = new PtrExp(место, arg);
                    arg = arg.ВыражениеSemantic(sc);
                }

                /* Last throwing arg? Then finalize eprefix => (eprefix, gate = да),
                 * i.e., disable the dtors right after constructing the last throwing arg.
                 * From now on, the callee will take care of destructing the args because
                 * the args are implicitly moved into function parameters.
                 *
                 * Set gate to null to let the следщ iterations know they don't need to
                 * приставь to eprefix anymore.
                 */
                if (i == lastthrow)
                {
                    auto e = new AssignExp(gate.место, new VarExp(gate.место, gate), IntegerExp.createBool(да));
                    eprefix = Выражение.combine(eprefix, e.ВыражениеSemantic(sc));
                    gate = null;
                }
            }
            else
            {
                /* No gate, no префикс to приставь to.
                 * Handle problem 2) by calling the копируй constructor for значение structs
                 * (or static arrays of them) if appropriate.
                 */
                Тип tv = arg.тип.baseElemOf();
                if (!isRef && tv.ty == Tstruct)
                    arg = doCopyOrMove(sc, arg, параметр ? параметр.тип : null);
            }

            (*arguments)[i] = arg;
        }
    }
    //if (eprefix) printf("eprefix: %s\n", eprefix.вТкст0());

    /* Test compliance with DIP1021
     */
    if (глоб2.парамы.useDIP1021 &&
        tf.trust != TRUST.system && tf.trust != TRUST.trusted)
        err |= checkMutableArguments(sc, fd, tf, ethis, arguments, нет);

    // If D компонаж and variadic, add _arguments[] as first argument
    if (tf.isDstyleVariadic())
    {
        assert(arguments.dim >= nparams);

        auto args = new Параметры(arguments.dim - nparams);
        for (т_мера i = 0; i < arguments.dim - nparams; i++)
        {
            auto arg = new Параметр2(STC.in_, (*arguments)[nparams + i].тип, null, null, null);
            (*args)[i] = arg;
        }
        auto tup = new КортежТипов(args);
        Выражение e = (new TypeidExp(место, tup)).ВыражениеSemantic(sc);
        arguments.вставь(0, e);
    }

    /* Determine function return тип: tret
     */
    Тип tret = tf.следщ;
    if (isCtorCall)
    {
        //printf("[%s] fd = %s %s, %d %d %d\n", место.вТкст0(), fd.вТкст0(), fd.тип.вТкст0(),
        //    wildmatch, tf.isWild(), fd.isReturnIsolated());
        if (!tthis)
        {
            assert(sc.intypeof || глоб2.errors);
            tthis = fd.isThis().тип.addMod(fd.тип.mod);
        }
        if (tf.isWild() && !fd.isReturnIsolated())
        {
            if (wildmatch)
                tret = tret.substWildTo(wildmatch);
            цел смещение;
            if (!tret.implicitConvTo(tthis) && !(MODimplicitConv(tret.mod, tthis.mod) && tret.isBaseOf(tthis, &смещение) && смещение == 0))
            {
                ткст0 s1 = tret.isNaked() ? " mutable" : tret.modToChars();
                ткст0 s2 = tthis.isNaked() ? " mutable" : tthis.modToChars();
                .выведиОшибку(место, "`inout` constructor `%s` creates%s объект, not%s", fd.toPrettyChars(), s1, s2);
                err = да;
            }
        }
        tret = tthis;
    }
    else if (wildmatch && tret)
    {
        /* Adjust function return тип based on wildmatch
         */
        //printf("wildmatch = x%x, tret = %s\n", wildmatch, tret.вТкст0());
        tret = tret.substWildTo(wildmatch);
    }

    *prettype = tret;
    *peprefix = eprefix;
    return (err || olderrors != глоб2.errors);
}

/**
 * Determines whether a symbol represents a module or package
 * (Used as a helper for is(тип == module) and is(тип == package))
 *
 * Параметры:
 *  sym = the symbol to be checked
 *
 * Возвращает:
 *  the symbol which `sym` represents (or `null` if it doesn't represent a `Package`)
 */
Package resolveIsPackage(ДСимвол sym)
{
    Package pkg;
    if (Импорт imp = sym.isImport())
    {
        if (imp.pkg is null)
        {
            .выведиОшибку(sym.место, "Internal Compiler Error: unable to process forward-referenced import `%s`",
                    imp.вТкст0());
            assert(0);
        }
        pkg = imp.pkg;
    }
    else if (auto mod = sym.isModule())
        pkg = mod.isPackageFile ? mod.pkg : sym.isPackage();
    else
        pkg = sym.isPackage();
    if (pkg)
        pkg.resolvePKGunknown();
    return pkg;
}

private Module loadStdMath()
{
     Импорт impStdMath = null;
    if (!impStdMath)
    {
        auto a = new Идентификаторы();
        a.сунь(Id.std);
        auto s = new Импорт(Место.initial, a, Id.math, null, нет);
        // Module.load will call fatal() if there's no std.math доступно.
        // Gag the error here, pushing the error handling to the caller.
        бцел errors = глоб2.startGagging();
        s.load(null);
        if (s.mod)
        {
            s.mod.importAll(null);
            s.mod.dsymbolSemantic(null);
        }
        глоб2.endGagging(errors);
        impStdMath = s;
    }
    return impStdMath.mod;
}

private  final class ВыражениеSemanticVisitor : Визитор2
{
    alias Визитор2.посети посети;

    Scope* sc;
    Выражение результат;

    this(Scope* sc)
    {
        this.sc = sc;
    }

    private проц setError()
    {
        результат = new ErrorExp();
    }

    /**************************
     * Semantically analyze Выражение.
     * Determine types, fold constants, etc.
     */
    override проц посети(Выражение e)
    {
        static if (LOGSEMANTIC)
        {
            printf("Выражение::semantic() %s\n", e.вТкст0());
        }
        if (e.тип)
            e.тип = e.тип.typeSemantic(e.место, sc);
        else
            e.тип = Тип.tvoid;
        результат = e;
    }

    override проц посети(IntegerExp e)
    {
        assert(e.тип);
        if (e.тип.ty == Terror)
            return setError();

        assert(e.тип.deco);
        e.setInteger(e.getInteger());
        результат = e;
    }

    override проц посети(RealExp e)
    {
        if (!e.тип)
            e.тип = Тип.tfloat64;
        else
            e.тип = e.тип.typeSemantic(e.место, sc);
        результат = e;
    }

    override проц посети(ComplexExp e)
    {
        if (!e.тип)
            e.тип = Тип.tcomplex80;
        else
            e.тип = e.тип.typeSemantic(e.место, sc);
        результат = e;
    }

    override проц посети(IdentifierExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("IdentifierExp::semantic('%s')\n", exp.идент.вТкст0());
        }
        if (exp.тип) // This is используется as the dummy Выражение
        {
            результат = exp;
            return;
        }

        ДСимвол scopesym;
        ДСимвол s = sc.search(exp.место, exp.идент, &scopesym);
        if (s)
        {
            if (s.errors)
                return setError();

            Выражение e;

            /* See if the symbol was a member of an enclosing 'with'
             */
            WithScopeSymbol withsym = scopesym.isWithScopeSymbol();
            if (withsym && withsym.withstate.wthis)
            {
                /* Disallow shadowing
                 */
                // First найди the scope of the with
                Scope* scwith = sc;
                while (scwith.scopesym != scopesym)
                {
                    scwith = scwith.enclosing;
                    assert(scwith);
                }
                // Look at enclosing scopes for symbols with the same имя,
                // in the same function
                for (Scope* scx = scwith; scx && scx.func == scwith.func; scx = scx.enclosing)
                {
                    ДСимвол s2;
                    if (scx.scopesym && scx.scopesym.symtab && (s2 = scx.scopesym.symtab.lookup(s.идент)) !is null && s != s2)
                    {
                        exp.выведиОшибку("with symbol `%s` is shadowing local symbol `%s`", s.toPrettyChars(), s2.toPrettyChars());
                        return setError();
                    }
                }
                s = s.toAlias();

                // Same as wthis.идент
                //  TODO: DotIdExp.semantic will найди 'идент' from 'wthis' again.
                //  The redudancy should be removed.
                e = new VarExp(exp.место, withsym.withstate.wthis);
                e = new DotIdExp(exp.место, e, exp.идент);
                e = e.ВыражениеSemantic(sc);
            }
            else
            {
                if (withsym)
                {
                    if (auto t = withsym.withstate.exp.isTypeExp())
                    {
                        e = new TypeExp(exp.место, t.тип);
                        e = new DotIdExp(exp.место, e, exp.идент);
                        результат = e.ВыражениеSemantic(sc);
                        return;
                    }
                }

                /* If f is really a function template,
                 * then replace f with the function template declaration.
                 */
                FuncDeclaration f = s.isFuncDeclaration();
                if (f)
                {
                    TemplateDeclaration td = getFuncTemplateDecl(f);
                    if (td)
                    {
                        if (td.overroot) // if not start of overloaded list of TemplateDeclaration's
                            td = td.overroot; // then get the start
                        e = new TemplateExp(exp.место, td, f);
                        e = e.ВыражениеSemantic(sc);
                        результат = e;
                        return;
                    }
                }

                if (глоб2.парамы.fixAliasThis)
                {
                    ВыражениеDsymbol expDsym = scopesym.isВыражениеDsymbol();
                    if (expDsym)
                    {
                        //printf("expDsym = %s\n", expDsym.exp.вТкст0());
                        результат = expDsym.exp.ВыражениеSemantic(sc);
                        return;
                    }
                }
                // Haven't done overload resolution yet, so pass 1
                e = symbolToExp(s, exp.место, sc, да);
            }
            результат = e;
            return;
        }

        if (!глоб2.парамы.fixAliasThis && hasThis(sc))
        {
            for (AggregateDeclaration ad = sc.getStructClassScope(); ad;)
            {
                if (ad.aliasthis)
                {
                    Выражение e;
                    e = new ThisExp(exp.место);
                    e = new DotIdExp(exp.место, e, ad.aliasthis.идент);
                    e = new DotIdExp(exp.место, e, exp.идент);
                    e = e.trySemantic(sc);
                    if (e)
                    {
                        результат = e;
                        return;
                    }
                }

                auto cd = ad.isClassDeclaration();
                if (cd && cd.baseClass && cd.baseClass != ClassDeclaration.объект)
                {
                    ad = cd.baseClass;
                    continue;
                }
                break;
            }
        }

        if (exp.идент == Id.ctfe)
        {
            if (sc.flags & SCOPE.ctfe)
            {
                exp.выведиОшибку("variable `__ctfe` cannot be читай at compile time");
                return setError();
            }

            // Create the magic __ctfe бул variable
            auto vd = new VarDeclaration(exp.место, Тип.tбул, Id.ctfe, null);
            vd.класс_хранения |= STC.temp;
            vd.semanticRun = PASS.semanticdone;
            Выражение e = new VarExp(exp.место, vd);
            e = e.ВыражениеSemantic(sc);
            результат = e;
            return;
        }

        // If we've reached this point and are inside a with() scope then we may
        // try one last attempt by checking whether the 'wthis' объект supports
        // dynamic dispatching via opDispatch.
        // This is done by rewriting this Выражение as wthis.идент.
        // The innermost with() scope of the hierarchy to satisfy the условие
        // above wins.
        // https://issues.dlang.org/show_bug.cgi?ид=6400
        for (Scope* sc2 = sc; sc2; sc2 = sc2.enclosing)
        {
            if (!sc2.scopesym)
                continue;

            if (auto ss = sc2.scopesym.isWithScopeSymbol())
            {
                if (ss.withstate.wthis)
                {
                    Выражение e;
                    e = new VarExp(exp.место, ss.withstate.wthis);
                    e = new DotIdExp(exp.место, e, exp.идент);
                    e = e.trySemantic(sc);
                    if (e)
                    {
                        результат = e;
                        return;
                    }
                }
                // Try Тип.opDispatch (so the static version)
                else if (ss.withstate.exp && ss.withstate.exp.op == ТОК2.тип)
                {
                    if (Тип t = ss.withstate.exp.isTypeExp().тип)
                    {
                        Выражение e;
                        e = new TypeExp(exp.место, t);
                        e = new DotIdExp(exp.место, e, exp.идент);
                        e = e.trySemantic(sc);
                        if (e)
                        {
                            результат = e;
                            return;
                        }
                    }
                }
            }
        }

        /* Look for what user might have meant
         */
        if(auto n = importHint(exp.идент.вТкст()))
            exp.выведиОшибку("`%s` is not defined, perhaps `import %.*s;` is needed?", exp.идент.вТкст0(), cast(цел)n.length, n.ptr);
        else if (auto s2 = sc.search_correct(exp.идент))
            exp.выведиОшибку("undefined идентификатор `%s`, did you mean %s `%s`?", exp.идент.вТкст0(), s2.вид(), s2.вТкст0());
        else if(auto p = Scope.search_correct_C(exp.идент))
            exp.выведиОшибку("undefined идентификатор `%s`, did you mean `%s`?", exp.идент.вТкст0(), p);
        else
            exp.выведиОшибку("undefined идентификатор `%s`", exp.идент.вТкст0());

        результат = new ErrorExp();
    }

    override проц посети(DsymbolExp e)
    {
        результат = symbolToExp(e.s, e.место, sc, e.hasOverloads);
    }

    override проц посети(ThisExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("ThisExp::semantic()\n");
        }
        if (e.тип)
        {
            результат = e;
            return;
        }

        FuncDeclaration fd = hasThis(sc); // fd is the uplevel function with the 'this' variable
        AggregateDeclaration ad;

        /* Special case for typeof(this) and typeof(super) since both
         * should work even if they are not inside a non-static member function
         */
        if (!fd && sc.intypeof == 1)
        {
            // Find enclosing struct or class
            for (ДСимвол s = sc.getStructClassScope(); 1; s = s.родитель)
            {
                if (!s)
                {
                    e.выведиОшибку("`%s` is not in a class or struct scope", e.вТкст0());
                    goto Lerr;
                }
                ClassDeclaration cd = s.isClassDeclaration();
                if (cd)
                {
                    e.тип = cd.тип;
                    результат = e;
                    return;
                }
                StructDeclaration sd = s.isStructDeclaration();
                if (sd)
                {
                    e.тип = sd.тип;
                    результат = e;
                    return;
                }
            }
        }
        if (!fd)
            goto Lerr;

        assert(fd.vthis);
        e.var = fd.vthis;
        assert(e.var.родитель);
        ad = fd.isMemberLocal();
        if (!ad)
            ad = fd.isMember2();
        assert(ad);
        e.тип = ad.тип.addMod(e.var.тип.mod);

        if (e.var.checkNestedReference(sc, e.место))
            return setError();

        результат = e;
        return;

    Lerr:
        e.выведиОшибку("`this` is only defined in non-static member functions, not `%s`", sc.родитель.вТкст0());
        результат = new ErrorExp();
    }

    override проц посети(SuperExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("SuperExp::semantic('%s')\n", e.вТкст0());
        }
        if (e.тип)
        {
            результат = e;
            return;
        }

        FuncDeclaration fd = hasThis(sc);
        ClassDeclaration cd;
        ДСимвол s;

        /* Special case for typeof(this) and typeof(super) since both
         * should work even if they are not inside a non-static member function
         */
        if (!fd && sc.intypeof == 1)
        {
            // Find enclosing class
            for (s = sc.getStructClassScope(); 1; s = s.родитель)
            {
                if (!s)
                {
                    e.выведиОшибку("`%s` is not in a class scope", e.вТкст0());
                    goto Lerr;
                }
                cd = s.isClassDeclaration();
                if (cd)
                {
                    cd = cd.baseClass;
                    if (!cd)
                    {
                        e.выведиОшибку("class `%s` has no `super`", s.вТкст0());
                        goto Lerr;
                    }
                    e.тип = cd.тип;
                    результат = e;
                    return;
                }
            }
        }
        if (!fd)
            goto Lerr;

        e.var = fd.vthis;
        assert(e.var && e.var.родитель);

        s = fd.toParentDecl();
        if (s.isTemplateDeclaration()) // allow inside template constraint
            s = s.toParent();
        assert(s);
        cd = s.isClassDeclaration();
        //printf("родитель is %s %s\n", fd.toParent().вид(), fd.toParent().вТкст0());
        if (!cd)
            goto Lerr;
        if (!cd.baseClass)
        {
            e.выведиОшибку("no base class for `%s`", cd.вТкст0());
            e.тип = cd.тип.addMod(e.var.тип.mod);
        }
        else
        {
            e.тип = cd.baseClass.тип;
            e.тип = e.тип.castMod(e.var.тип.mod);
        }

        if (e.var.checkNestedReference(sc, e.место))
            return setError();

        результат = e;
        return;

    Lerr:
        e.выведиОшибку("`super` is only allowed in non-static class member functions");
        результат = new ErrorExp();
    }

    override проц посети(NullExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("NullExp::semantic('%s')\n", e.вТкст0());
        }
        // NULL is the same as (проц *)0
        if (e.тип)
        {
            результат = e;
            return;
        }
        e.тип = Тип.tnull;
        результат = e;
    }

    override проц посети(StringExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("StringExp::semantic() %s\n", e.вТкст0());
        }
        if (e.тип)
        {
            результат = e;
            return;
        }

        БуфВыв буфер;
        т_мера newlen = 0;
        т_мера u;
        dchar c;

        switch (e.postfix)
        {
        case 'd':
            for (u = 0; u < e.len;)
            {
                if(auto p = utf_decodeChar(e.peekString(), u, c))
                {
                    e.выведиОшибку("%.*s", cast(цел)p.length, p.ptr);
                    return setError();
                }
                else
                {
                    буфер.пиши4(c);
                    newlen++;
                }
            }
            буфер.пиши4(0);
            e.setData(буфер.извлекиДанные(), newlen, 4);
            e.тип = new TypeDArray(Тип.tdchar.immutableOf());
            e.committed = 1;
            break;

        case 'w':
            for (u = 0; u < e.len;)
            {
                if(auto p = utf_decodeChar(e.peekString(), u, c))
                {
                    e.выведиОшибку("%.*s", cast(цел)p.length, p.ptr);
                    return setError();
                }
                else
                {
                    буфер.пишиЮ16(c);
                    newlen++;
                    if (c >= 0x10000)
                        newlen++;
                }
            }
            буфер.пишиЮ16(0);
            e.setData(буфер.извлекиДанные(), newlen, 2);
            e.тип = new TypeDArray(Тип.twchar.immutableOf());
            e.committed = 1;
            break;

        case 'c':
            e.committed = 1;
            goto default;

        default:
            e.тип = new TypeDArray(Тип.tchar.immutableOf());
            break;
        }
        e.тип = e.тип.typeSemantic(e.место, sc);
        //тип = тип.immutableOf();
        //printf("тип = %s\n", тип.вТкст0());

        результат = e;
    }

    override проц посети(TupleExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("+TupleExp::semantic(%s)\n", exp.вТкст0());
        }
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (exp.e0)
            exp.e0 = exp.e0.ВыражениеSemantic(sc);

        // Run semantic() on each argument
        бул err = нет;
        for (т_мера i = 0; i < exp.exps.dim; i++)
        {
            Выражение e = (*exp.exps)[i];
            e = e.ВыражениеSemantic(sc);
            if (!e.тип)
            {
                exp.выведиОшибку("`%s` has no значение", e.вТкст0());
                err = да;
            }
            else if (e.op == ТОК2.error)
                err = да;
            else
                (*exp.exps)[i] = e;
        }
        if (err)
            return setError();

        expandTuples(exp.exps);

        exp.тип = new КортежТипов(exp.exps);
        exp.тип = exp.тип.typeSemantic(exp.место, sc);
        //printf("-TupleExp::semantic(%s)\n", вТкст0());
        результат = exp;
    }

    override проц посети(ArrayLiteralExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("ArrayLiteralExp::semantic('%s')\n", e.вТкст0());
        }
        if (e.тип)
        {
            результат = e;
            return;
        }

        /* Perhaps an empty массив literal [ ] should be rewritten as null?
         */

        if (e.basis)
            e.basis = e.basis.ВыражениеSemantic(sc);
        if (arrayВыражениеSemantic(e.elements, sc) || (e.basis && e.basis.op == ТОК2.error))
            return setError();

        expandTuples(e.elements);

        Тип t0;
        if (e.basis)
            e.elements.сунь(e.basis);
        бул err = arrayВыражениеToCommonType(sc, e.elements, &t0);
        if (e.basis)
            e.basis = e.elements.вынь();
        if (err)
            return setError();

        e.тип = t0.arrayOf();
        e.тип = e.тип.typeSemantic(e.место, sc);

        /* Disallow массив literals of тип проц being используется.
         */
        if (e.elements.dim > 0 && t0.ty == Tvoid)
        {
            e.выведиОшибку("`%s` of тип `%s` has no значение", e.вТкст0(), e.тип.вТкст0());
            return setError();
        }

        if (глоб2.парамы.useTypeInfo && Тип.dtypeinfo)
            semanticTypeInfo(sc, e.тип);

        результат = e;
    }

    override проц посети(AssocArrayLiteralExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("AssocArrayLiteralExp::semantic('%s')\n", e.вТкст0());
        }
        if (e.тип)
        {
            результат = e;
            return;
        }

        // Run semantic() on each element
        бул err_keys = arrayВыражениеSemantic(e.keys, sc);
        бул err_vals = arrayВыражениеSemantic(e.values, sc);
        if (err_keys || err_vals)
            return setError();

        expandTuples(e.keys);
        expandTuples(e.values);
        if (e.keys.dim != e.values.dim)
        {
            e.выведиОшибку("number of keys is %u, must match number of values %u", e.keys.dim, e.values.dim);
            return setError();
        }

        Тип tkey = null;
        Тип tvalue = null;
        err_keys = arrayВыражениеToCommonType(sc, e.keys, &tkey);
        err_vals = arrayВыражениеToCommonType(sc, e.values, &tvalue);
        if (err_keys || err_vals)
            return setError();

        if (tkey == Тип.terror || tvalue == Тип.terror)
            return setError();

        e.тип = new TypeAArray(tvalue, tkey);
        e.тип = e.тип.typeSemantic(e.место, sc);

        semanticTypeInfo(sc, e.тип);

        if (глоб2.парамы.vsafe)
        {
            if (checkAssocArrayLiteralEscape(sc, e, нет))
                return setError();
        }

        результат = e;
    }

    override проц посети(StructLiteralExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("StructLiteralExp::semantic('%s')\n", e.вТкст0());
        }
        if (e.тип)
        {
            результат = e;
            return;
        }

        e.sd.size(e.место);
        if (e.sd.sizeok != Sizeok.done)
            return setError();

        // run semantic() on each element
        if (arrayВыражениеSemantic(e.elements, sc))
            return setError();

        expandTuples(e.elements);

        /* Fit elements[] to the corresponding тип of field[].
         */
        if (!e.sd.fit(e.место, sc, e.elements, e.stype))
            return setError();

        /* Fill out remainder of elements[] with default initializers for fields[]
         */
        if (!e.sd.fill(e.место, e.elements, нет))
        {
            /* An error in the инициализатор needs to be recorded as an error
             * in the enclosing function or template, since the инициализатор
             * will be part of the stuct declaration.
             */
            глоб2.increaseErrorCount();
            return setError();
        }

        if (checkFrameAccess(e.место, sc, e.sd, e.elements.dim))
            return setError();

        e.тип = e.stype ? e.stype : e.sd.тип;
        результат = e;
    }

    override проц посети(TypeExp exp)
    {
        if (exp.тип.ty == Terror)
            return setError();

        //printf("TypeExp::semantic(%s)\n", тип.вТкст0());
        Выражение e;
        Тип t;
        ДСимвол s;

        dmd.typesem.resolve(exp.тип, exp.место, sc, &e, &t, &s, да);
        if (e)
        {
            // `(Тип)` is actually `(var)` so if `(var)` is a member requiring `this`
            // then rewrite as `(this.var)` in case it would be followed by a DotVar
            // to fix https://issues.dlang.org/show_bug.cgi?ид=9490
            VarExp ve = e.isVarExp();
            if (ve && ve.var && exp.parens && !ve.var.isStatic() && !(sc.stc & STC.static_) &&
                sc.func && sc.func.needThis && ve.var.toParent2().isAggregateDeclaration())
            {
                // printf("apply fix for issue 9490: add `this.` to `%s`...\n", e.вТкст0());
                e = new DotVarExp(exp.место, new ThisExp(exp.место), ve.var, нет);
            }
            //printf("e = %s %s\n", Сема2::вТкст0(e.op), e.вТкст0());
            e = e.ВыражениеSemantic(sc);
        }
        else if (t)
        {
            //printf("t = %d %s\n", t.ty, t.вТкст0());
            exp.тип = t.typeSemantic(exp.место, sc);
            e = exp;
        }
        else if (s)
        {
            //printf("s = %s %s\n", s.вид(), s.вТкст0());
            e = symbolToExp(s, exp.место, sc, да);
        }
        else
            assert(0);

        if (глоб2.парамы.vcomplex)
            exp.тип.checkComplexTransition(exp.место, sc);

        результат = e;
    }

    override проц посети(ScopeExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("+ScopeExp::semantic(%p '%s')\n", exp, exp.вТкст0());
        }
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        ScopeDsymbol sds2 = exp.sds;
        TemplateInstance ti = sds2.isTemplateInstance();
        while (ti)
        {
            WithScopeSymbol withsym;
            if (!ti.findTempDecl(sc, &withsym) || !ti.semanticTiargs(sc))
                return setError();
            if (withsym && withsym.withstate.wthis)
            {
                Выражение e = new VarExp(exp.место, withsym.withstate.wthis);
                e = new DotTemplateInstanceExp(exp.место, e, ti);
                результат = e.ВыражениеSemantic(sc);
                return;
            }
            if (ti.needsTypeInference(sc))
            {
                if (TemplateDeclaration td = ti.tempdecl.isTemplateDeclaration())
                {
                    ДСимвол p = td.toParentLocal();
                    FuncDeclaration fdthis = hasThis(sc);
                    AggregateDeclaration ad = p ? p.isAggregateDeclaration() : null;
                    if (fdthis && ad && fdthis.isMemberLocal() == ad && (td._scope.stc & STC.static_) == 0)
                    {
                        Выражение e = new DotTemplateInstanceExp(exp.место, new ThisExp(exp.место), ti.имя, ti.tiargs);
                        результат = e.ВыражениеSemantic(sc);
                        return;
                    }
                }
                else if (OverloadSet ос = ti.tempdecl.isOverloadSet())
                {
                    FuncDeclaration fdthis = hasThis(sc);
                    AggregateDeclaration ad = ос.родитель.isAggregateDeclaration();
                    if (fdthis && ad && fdthis.isMemberLocal() == ad)
                    {
                        Выражение e = new DotTemplateInstanceExp(exp.место, new ThisExp(exp.место), ti.имя, ti.tiargs);
                        результат = e.ВыражениеSemantic(sc);
                        return;
                    }
                }
                // ti is an instance which requires IFTI.
                exp.sds = ti;
                exp.тип = Тип.tvoid;
                результат = exp;
                return;
            }
            ti.dsymbolSemantic(sc);
            if (!ti.inst || ti.errors)
                return setError();

            ДСимвол s = ti.toAlias();
            if (s == ti)
            {
                exp.sds = ti;
                exp.тип = Тип.tvoid;
                результат = exp;
                return;
            }
            sds2 = s.isScopeDsymbol();
            if (sds2)
            {
                ti = sds2.isTemplateInstance();
                //printf("+ sds2 = %s, '%s'\n", sds2.вид(), sds2.вТкст0());
                continue;
            }

            if (auto v = s.isVarDeclaration())
            {
                if (!v.тип)
                {
                    exp.выведиОшибку("forward reference of %s `%s`", v.вид(), v.вТкст0());
                    return setError();
                }
                if ((v.класс_хранения & STC.manifest) && v._иниц)
                {
                    /* When an instance that will be converted to a constant exists,
                     * the instance representation "foo!tiargs" is treated like a
                     * variable имя, and its recursive appearance check (note that
                     * it's equivalent with a recursive instantiation of foo) is done
                     * separately from the circular initialization check for the
                     * eponymous enum variable declaration.
                     *
                     *  template foo(T) {
                     *    enum бул foo = foo;    // recursive definition check (v.inuse)
                     *  }
                     *  template bar(T) {
                     *    enum бул bar = bar!T;  // recursive instantiation check (ti.inuse)
                     *  }
                     */
                    if (ti.inuse)
                    {
                        exp.выведиОшибку("recursive expansion of %s `%s`", ti.вид(), ti.toPrettyChars());
                        return setError();
                    }
                    v.checkDeprecated(exp.место, sc);
                    auto e = v.expandInitializer(exp.место);
                    ti.inuse++;
                    e = e.ВыражениеSemantic(sc);
                    ti.inuse--;
                    результат = e;
                    return;
                }
            }

            //printf("s = %s, '%s'\n", s.вид(), s.вТкст0());
            auto e = symbolToExp(s, exp.место, sc, да);
            //printf("-1ScopeExp::semantic()\n");
            результат = e;
            return;
        }

        //printf("sds2 = %s, '%s'\n", sds2.вид(), sds2.вТкст0());
        //printf("\tparent = '%s'\n", sds2.родитель.вТкст0());
        sds2.dsymbolSemantic(sc);

        // (Aggregate|Enum)Declaration
        if (auto t = sds2.getType())
        {
            результат = (new TypeExp(exp.место, t)).ВыражениеSemantic(sc);
            return;
        }

        if (auto td = sds2.isTemplateDeclaration())
        {
            результат = (new TemplateExp(exp.место, td)).ВыражениеSemantic(sc);
            return;
        }

        exp.sds = sds2;
        exp.тип = Тип.tvoid;
        //printf("-2ScopeExp::semantic() %s\n", вТкст0());
        результат = exp;
    }

    override проц посети(NewExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("NewExp::semantic() %s\n", exp.вТкст0());
            if (exp.thisexp)
                printf("\tthisexp = %s\n", exp.thisexp.вТкст0());
            printf("\tnewtype: %s\n", exp.newtype.вТкст0());
        }
        if (exp.тип) // if semantic() already run
        {
            результат = exp;
            return;
        }

        //for error messages if the argument in [] is not convertible to т_мера
        const originalNewtype = exp.newtype;

        // https://issues.dlang.org/show_bug.cgi?ид=11581
        // With the syntax `new T[edim]` or `thisexp.new T[edim]`,
        // T should be analyzed first and edim should go into arguments iff it's
        // not a кортеж.
        Выражение edim = null;
        if (!exp.arguments && exp.newtype.ty == Tsarray)
        {
            edim = (cast(TypeSArray)exp.newtype).dim;
            exp.newtype = (cast(TypeNext)exp.newtype).следщ;
        }

        ClassDeclaration cdthis = null;
        if (exp.thisexp)
        {
            exp.thisexp = exp.thisexp.ВыражениеSemantic(sc);
            if (exp.thisexp.op == ТОК2.error)
                return setError();

            cdthis = exp.thisexp.тип.isClassHandle();
            if (!cdthis)
            {
                exp.выведиОшибку("`this` for nested class must be a class тип, not `%s`", exp.thisexp.тип.вТкст0());
                return setError();
            }

            sc = sc.сунь(cdthis);
            exp.тип = exp.newtype.typeSemantic(exp.место, sc);
            sc = sc.вынь();
        }
        else
        {
            exp.тип = exp.newtype.typeSemantic(exp.место, sc);
        }
        if (exp.тип.ty == Terror)
            return setError();

        if (edim)
        {
            if (exp.тип.toBasetype().ty == Ttuple)
            {
                // --> new T[edim]
                exp.тип = new TypeSArray(exp.тип, edim);
                exp.тип = exp.тип.typeSemantic(exp.место, sc);
                if (exp.тип.ty == Terror)
                    return setError();
            }
            else
            {
                // --> new T[](edim)
                exp.arguments = new Выражения();
                exp.arguments.сунь(edim);
                exp.тип = exp.тип.arrayOf();
            }
        }

        exp.newtype = exp.тип; // in case тип gets cast to something else
        Тип tb = exp.тип.toBasetype();
        //printf("tb: %s, deco = %s\n", tb.вТкст0(), tb.deco);
        if (arrayВыражениеSemantic(exp.newargs, sc) ||
            preFunctionParameters(sc, exp.newargs))
        {
            return setError();
        }
        if (arrayВыражениеSemantic(exp.arguments, sc))
        {
            return setError();
        }
        //https://issues.dlang.org/show_bug.cgi?ид=20547
        //exp.arguments are the "parameters" to [], not to a real function
        //so the errors that come from preFunctionParameters are misleading
        if (originalNewtype.ty == Tsarray)
        {
            if (preFunctionParameters(sc, exp.arguments, нет))
            {
                exp.выведиОшибку("cannot создай a `%s` with `new`", originalNewtype.вТкст0());
                return setError();
            }
        }
        else if (preFunctionParameters(sc, exp.arguments))
        {
            return setError();
        }

        if (exp.thisexp && tb.ty != Tclass)
        {
            exp.выведиОшибку("`.new` is only for allocating nested classes, not `%s`", tb.вТкст0());
            return setError();
        }

        const т_мера nargs = exp.arguments ? exp.arguments.dim : 0;
        Выражение newprefix = null;

        if (tb.ty == Tclass)
        {
            auto cd = (cast(TypeClass)tb).sym;
            cd.size(exp.место);
            if (cd.sizeok != Sizeok.done)
                return setError();
            if (!cd.ctor)
                cd.ctor = cd.searchCtor();
            if (cd.noDefaultCtor && !nargs && !cd.defaultCtor)
            {
                exp.выведиОшибку("default construction is disabled for тип `%s`", cd.тип.вТкст0());
                return setError();
            }

            if (cd.isInterfaceDeclaration())
            {
                exp.выведиОшибку("cannot создай instance of interface `%s`", cd.вТкст0());
                return setError();
            }

            if (cd.isAbstract())
            {
                exp.выведиОшибку("cannot создай instance of abstract class `%s`", cd.вТкст0());
                for (т_мера i = 0; i < cd.vtbl.dim; i++)
                {
                    FuncDeclaration fd = cd.vtbl[i].isFuncDeclaration();
                    if (fd && fd.isAbstract())
                    {
                        errorSupplemental(exp.место, "function `%s` is not implemented",
                            fd.toFullSignature());
                    }
                }
                return setError();
            }
            // checkDeprecated() is already done in newtype.typeSemantic().

            if (cd.isNested())
            {
                /* We need a 'this' pointer for the nested class.
                 * Гарант we have the right one.
                 */
                ДСимвол s = cd.toParentLocal();

                //printf("cd isNested, родитель = %s '%s'\n", s.вид(), s.toPrettyChars());
                if (auto cdn = s.isClassDeclaration())
                {
                    if (!cdthis)
                    {
                        // Supply an implicit 'this' and try again
                        exp.thisexp = new ThisExp(exp.место);
                        for (ДСимвол sp = sc.родитель; 1; sp = sp.toParentLocal())
                        {
                            if (!sp)
                            {
                                exp.выведиОшибку("outer class `%s` `this` needed to `new` nested class `%s`",
                                    cdn.вТкст0(), cd.вТкст0());
                                return setError();
                            }
                            ClassDeclaration cdp = sp.isClassDeclaration();
                            if (!cdp)
                                continue;
                            if (cdp == cdn || cdn.isBaseOf(cdp, null))
                                break;
                            // Add a '.outer' and try again
                            exp.thisexp = new DotIdExp(exp.место, exp.thisexp, Id.outer);
                        }

                        exp.thisexp = exp.thisexp.ВыражениеSemantic(sc);
                        if (exp.thisexp.op == ТОК2.error)
                            return setError();
                        cdthis = exp.thisexp.тип.isClassHandle();
                    }
                    if (cdthis != cdn && !cdn.isBaseOf(cdthis, null))
                    {
                        //printf("cdthis = %s\n", cdthis.вТкст0());
                        exp.выведиОшибку("`this` for nested class must be of тип `%s`, not `%s`",
                            cdn.вТкст0(), exp.thisexp.тип.вТкст0());
                        return setError();
                    }
                    if (!MODimplicitConv(exp.thisexp.тип.mod, exp.newtype.mod))
                    {
                        exp.выведиОшибку("nested тип `%s` should have the same or weaker constancy as enclosing тип `%s`",
                            exp.newtype.вТкст0(), exp.thisexp.тип.вТкст0());
                        return setError();
                    }
                }
                else if (exp.thisexp)
                {
                    exp.выведиОшибку("`.new` is only for allocating nested classes");
                    return setError();
                }
                else if (auto fdn = s.isFuncDeclaration())
                {
                    // make sure the родитель context fdn of cd is reachable from sc
                    if (!ensureStaticLinkTo(sc.родитель, fdn))
                    {
                        exp.выведиОшибку("outer function context of `%s` is needed to `new` nested class `%s`",
                            fdn.toPrettyChars(), cd.toPrettyChars());
                        return setError();
                    }
                }
                else
                    assert(0);
            }
            else if (exp.thisexp)
            {
                exp.выведиОшибку("`.new` is only for allocating nested classes");
                return setError();
            }

            if (cd.vthis2)
            {
                if (AggregateDeclaration ad2 = cd.isMember2())
                {
                    auto rez = new ThisExp(exp.место);
                    Выражение te = rez.ВыражениеSemantic(sc);
                    if (te.op != ТОК2.error)
                        te = getRightThis(exp.место, sc, ad2, te, cd);
                    if (te.op == ТОК2.error)
                    {
                        exp.выведиОшибку("need `this` of тип `%s` needed to `new` nested class `%s`", ad2.вТкст0(), cd.вТкст0());
                        return setError();
                    }
                }
            }

            if (cd.aggNew)
            {
                // Prepend the size argument to newargs[]
                Выражение e = new IntegerExp(exp.место, cd.size(exp.место), Тип.tт_мера);
                if (!exp.newargs)
                    exp.newargs = new Выражения();
                exp.newargs.shift(e);

                FuncDeclaration f = resolveFuncCall(exp.место, sc, cd.aggNew, null, tb, exp.newargs, FuncResolveFlag.standard);
                if (!f || f.errors)
                    return setError();

                checkFunctionAttributes(exp, sc, f);
                checkAccess(cd, exp.место, sc, f);

                TypeFunction tf = cast(TypeFunction)f.тип;
                Тип rettype;
                if (functionParameters(exp.место, sc, tf, null, null, exp.newargs, f, &rettype, &newprefix))
                    return setError();

                exp.allocator = f.isNewDeclaration();
                assert(exp.allocator);
            }
            else
            {
                if (exp.newargs && exp.newargs.dim)
                {
                    exp.выведиОшибку("no allocator for `%s`", cd.вТкст0());
                    return setError();
                }
            }

            if (cd.ctor)
            {
                FuncDeclaration f = resolveFuncCall(exp.место, sc, cd.ctor, null, tb, exp.arguments, FuncResolveFlag.standard);
                if (!f || f.errors)
                    return setError();

                checkFunctionAttributes(exp, sc, f);
                checkAccess(cd, exp.место, sc, f);

                TypeFunction tf = cast(TypeFunction)f.тип;
                if (!exp.arguments)
                    exp.arguments = new Выражения();
                if (functionParameters(exp.место, sc, tf, null, exp.тип, exp.arguments, f, &exp.тип, &exp.argprefix))
                    return setError();

                exp.member = f.isCtorDeclaration();
                assert(exp.member);
            }
            else
            {
                if (nargs)
                {
                    exp.выведиОшибку("no constructor for `%s`", cd.вТкст0());
                    return setError();
                }

                // https://issues.dlang.org/show_bug.cgi?ид=19941
                // Run semantic on all field initializers to resolve any forward
                // references. This is the same as done for structs in sd.fill().
                for (ClassDeclaration c = cd; c; c = c.baseClass)
                {
                    foreach (v; c.fields)
                    {
                        if (v.inuse || v._scope is null || v._иниц is null ||
                            v._иниц.isVoidInitializer())
                            continue;
                        v.inuse++;
                        v._иниц = v._иниц.initializerSemantic(v._scope, v.тип, INITinterpret);
                        v.inuse--;
                    }
                }
            }
        }
        else if (tb.ty == Tstruct)
        {
            auto sd = (cast(TypeStruct)tb).sym;
            sd.size(exp.место);
            if (sd.sizeok != Sizeok.done)
                return setError();
            if (!sd.ctor)
                sd.ctor = sd.searchCtor();
            if (sd.noDefaultCtor && !nargs)
            {
                exp.выведиОшибку("default construction is disabled for тип `%s`", sd.тип.вТкст0());
                return setError();
            }
            // checkDeprecated() is already done in newtype.typeSemantic().

            if (sd.aggNew)
            {
                // Prepend the бцел size argument to newargs[]
                Выражение e = new IntegerExp(exp.место, sd.size(exp.место), Тип.tт_мера);
                if (!exp.newargs)
                    exp.newargs = new Выражения();
                exp.newargs.shift(e);

                FuncDeclaration f = resolveFuncCall(exp.место, sc, sd.aggNew, null, tb, exp.newargs, FuncResolveFlag.standard);
                if (!f || f.errors)
                    return setError();

                checkFunctionAttributes(exp, sc, f);
                checkAccess(sd, exp.место, sc, f);

                TypeFunction tf = cast(TypeFunction)f.тип;
                Тип rettype;
                if (functionParameters(exp.место, sc, tf, null, null, exp.newargs, f, &rettype, &newprefix))
                    return setError();

                exp.allocator = f.isNewDeclaration();
                assert(exp.allocator);
            }
            else
            {
                if (exp.newargs && exp.newargs.dim)
                {
                    exp.выведиОшибку("no allocator for `%s`", sd.вТкст0());
                    return setError();
                }
            }

            if (sd.ctor && nargs)
            {
                FuncDeclaration f = resolveFuncCall(exp.место, sc, sd.ctor, null, tb, exp.arguments, FuncResolveFlag.standard);
                if (!f || f.errors)
                    return setError();

                checkFunctionAttributes(exp, sc, f);
                checkAccess(sd, exp.место, sc, f);

                TypeFunction tf = cast(TypeFunction)f.тип;
                if (!exp.arguments)
                    exp.arguments = new Выражения();
                if (functionParameters(exp.место, sc, tf, null, exp.тип, exp.arguments, f, &exp.тип, &exp.argprefix))
                    return setError();

                exp.member = f.isCtorDeclaration();
                assert(exp.member);

                if (checkFrameAccess(exp.место, sc, sd, sd.fields.dim))
                    return setError();
            }
            else
            {
                if (!exp.arguments)
                    exp.arguments = new Выражения();

                if (!sd.fit(exp.место, sc, exp.arguments, tb))
                    return setError();

                if (!sd.fill(exp.место, exp.arguments, нет))
                    return setError();

                if (checkFrameAccess(exp.место, sc, sd, exp.arguments ? exp.arguments.dim : 0))
                    return setError();

                /* Since a `new` allocation may ýñêàïèðóé, check each of the arguments for escaping
                 */
                if (глоб2.парамы.vsafe)
                {
                    foreach (arg; *exp.arguments)
                    {
                        if (arg && checkNewEscape(sc, arg, нет))
                            return setError();
                    }
                }
            }

            exp.тип = exp.тип.pointerTo();
        }
        else if (tb.ty == Tarray && nargs)
        {
            Тип tn = tb.nextOf().baseElemOf();
            ДСимвол s = tn.toDsymbol(sc);
            AggregateDeclaration ad = s ? s.isAggregateDeclaration() : null;
            if (ad && ad.noDefaultCtor)
            {
                exp.выведиОшибку("default construction is disabled for тип `%s`", tb.nextOf().вТкст0());
                return setError();
            }
            for (т_мера i = 0; i < nargs; i++)
            {
                if (tb.ty != Tarray)
                {
                    exp.выведиОшибку("too many arguments for массив");
                    return setError();
                }

                Выражение arg = (*exp.arguments)[i];
                arg = resolveProperties(sc, arg);
                arg = arg.implicitCastTo(sc, Тип.tт_мера);
                if (arg.op == ТОК2.error)
                    return setError();
                arg = arg.optimize(WANTvalue);
                if (arg.op == ТОК2.int64 && cast(sinteger_t)arg.toInteger() < 0)
                {
                    exp.выведиОшибку("negative массив index `%s`", arg.вТкст0());
                    return setError();
                }
                (*exp.arguments)[i] = arg;
                tb = (cast(TypeDArray)tb).следщ.toBasetype();
            }
        }
        else if (tb.isscalar())
        {
            if (!nargs)
            {
            }
            else if (nargs == 1)
            {
                Выражение e = (*exp.arguments)[0];
                e = e.implicitCastTo(sc, tb);
                (*exp.arguments)[0] = e;
            }
            else
            {
                exp.выведиОшибку("more than one argument for construction of `%s`", exp.тип.вТкст0());
                return setError();
            }

            exp.тип = exp.тип.pointerTo();
        }
        else
        {
            exp.выведиОшибку("cannot создай a `%s` with `new`", exp.тип.вТкст0());
            return setError();
        }

        //printf("NewExp: '%s'\n", вТкст0());
        //printf("NewExp:тип '%s'\n", тип.вТкст0());
        semanticTypeInfo(sc, exp.тип);

        if (newprefix)
        {
            результат = Выражение.combine(newprefix, exp);
            return;
        }
        результат = exp;
    }

    override проц посети(NewAnonClassExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("NewAnonClassExp::semantic() %s\n", e.вТкст0());
            //printf("thisexp = %p\n", thisexp);
            //printf("тип: %s\n", тип.вТкст0());
        }

        Выражение d = new DeclarationExp(e.место, e.cd);
        sc = sc.сунь(); // just создай new scope
        sc.flags &= ~SCOPE.ctfe; // temporary stop CTFE
        d = d.ВыражениеSemantic(sc);
        sc = sc.вынь();

        if (!e.cd.errors && sc.intypeof && !sc.родитель.inNonRoot())
        {
            ScopeDsymbol sds = sc.tinst ? cast(ScopeDsymbol)sc.tinst : sc._module;
            if (!sds.члены)
                sds.члены = new Дсимволы();
            sds.члены.сунь(e.cd);
        }

        Выражение n = new NewExp(e.место, e.thisexp, e.newargs, e.cd.тип, e.arguments);

        Выражение c = new CommaExp(e.место, d, n);
        результат = c.ВыражениеSemantic(sc);
    }

    override проц посети(SymOffExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("SymOffExp::semantic('%s')\n", e.вТкст0());
        }
        //var.dsymbolSemantic(sc);
        if (!e.тип)
            e.тип = e.var.тип.pointerTo();

        if (auto v = e.var.isVarDeclaration())
        {
            if (v.checkNestedReference(sc, e.место))
                return setError();
        }
        else if (auto f = e.var.isFuncDeclaration())
        {
            if (f.checkNestedReference(sc, e.место))
                return setError();
        }

        результат = e;
    }

    override проц посети(VarExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("VarExp::semantic(%s)\n", e.вТкст0());
        }

        auto vd = e.var.isVarDeclaration();
        auto fd = e.var.isFuncDeclaration();

        if (fd)
        {
            //printf("L%d fd = %s\n", __LINE__, f.вТкст0());
            if (!fd.functionSemantic())
                return setError();
        }

        if (!e.тип)
            e.тип = e.var.тип;
        if (e.тип && !e.тип.deco)
        {
            auto decl = e.var.isDeclaration();
            if (decl)
                decl.inuse++;
            e.тип = e.тип.typeSemantic(e.место, sc);
            if (decl)
                decl.inuse--;
        }

        /* Fix for 1161 doesn't work because it causes защита
         * problems when instantiating imported templates passing private
         * variables as alias template parameters.
         */
        //checkAccess(место, sc, NULL, var);

        if (vd)
        {
            if (vd.checkNestedReference(sc, e.место))
                return setError();

            // https://issues.dlang.org/show_bug.cgi?ид=12025
            // If the variable is not actually используется in runtime code,
            // the purity violation error is redundant.
            //checkPurity(sc, vd);
        }
        else if (fd)
        {
            // TODO: If fd isn't yet resolved its overload, the checkNestedReference
            // call would cause incorrect validation.
            // Maybe here should be moved in CallExp, or AddrExp for functions.
            if (fd.checkNestedReference(sc, e.место))
                return setError();
        }
        else if (auto od = e.var.isOverDeclaration())
        {
            e.тип = Тип.tvoid; // ambiguous тип?
        }

        результат = e;
    }

    override проц посети(FuncExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("FuncExp::semantic(%s)\n", exp.вТкст0());
            if (exp.fd.treq)
                printf("  treq = %s\n", exp.fd.treq.вТкст0());
        }

        if (exp.тип)
        {
            результат = exp;
            return;
        }

        Выражение e = exp;
        бцел olderrors;

        sc = sc.сунь(); // just создай new scope
        sc.flags &= ~SCOPE.ctfe; // temporary stop CTFE
        sc.защита = Prot(Prot.Kind.public_); // https://issues.dlang.org/show_bug.cgi?ид=12506

        /* fd.treq might be incomplete тип,
            * so should not semantic it.
            * проц foo(T)(T delegate(цел) dg){}
            * foo(a=>a); // in IFTI, treq == T delegate(цел)
            */
        //if (fd.treq)
        //    fd.treq = fd.treq.dsymbolSemantic(место, sc);

        exp.genIdent(sc);

        // Set target of return тип inference
        if (exp.fd.treq && !exp.fd.тип.nextOf())
        {
            TypeFunction tfv = null;
            if (exp.fd.treq.ty == Tdelegate || (exp.fd.treq.ty == Tpointer && exp.fd.treq.nextOf().ty == Tfunction))
                tfv = cast(TypeFunction)exp.fd.treq.nextOf();
            if (tfv)
            {
                TypeFunction tfl = cast(TypeFunction)exp.fd.тип;
                tfl.следщ = tfv.nextOf();
            }
        }

        //printf("td = %p, treq = %p\n", td, fd.treq);
        if (exp.td)
        {
            assert(exp.td.parameters && exp.td.parameters.dim);
            exp.td.dsymbolSemantic(sc);
            exp.тип = Тип.tvoid; // temporary тип

            if (exp.fd.treq) // defer тип determination
            {
                FuncExp fe;
                if (exp.matchType(exp.fd.treq, sc, &fe) > MATCH.nomatch)
                    e = fe;
                else
                    e = new ErrorExp();
            }
            goto Ldone;
        }

        olderrors = глоб2.errors;
        exp.fd.dsymbolSemantic(sc);
        if (olderrors == глоб2.errors)
        {
            exp.fd.semantic2(sc);
            if (olderrors == глоб2.errors)
                exp.fd.semantic3(sc);
        }
        if (olderrors != глоб2.errors)
        {
            if (exp.fd.тип && exp.fd.тип.ty == Tfunction && !exp.fd.тип.nextOf())
                (cast(TypeFunction)exp.fd.тип).следщ = Тип.terror;
            e = new ErrorExp();
            goto Ldone;
        }

        // Тип is a "delegate to" or "pointer to" the function literal
        if ((exp.fd.isNested() && exp.fd.tok == ТОК2.delegate_) || (exp.tok == ТОК2.reserved && exp.fd.treq && exp.fd.treq.ty == Tdelegate))
        {
            exp.тип = new TypeDelegate(exp.fd.тип);
            exp.тип = exp.тип.typeSemantic(exp.место, sc);

            exp.fd.tok = ТОК2.delegate_;
        }
        else
        {
            exp.тип = new TypePointer(exp.fd.тип);
            exp.тип = exp.тип.typeSemantic(exp.место, sc);
            //тип = fd.тип.pointerTo();

            /* A lambda Выражение deduced to function pointer might become
                * to a delegate literal implicitly.
                *
                *   auto foo(проц function() fp) { return 1; }
                *   assert(foo({}) == 1);
                *
                * So, should keep fd.tok == TOKreserve if fd.treq == NULL.
                */
            if (exp.fd.treq && exp.fd.treq.ty == Tpointer)
            {
                // change to non-nested
                exp.fd.tok = ТОК2.function_;
                exp.fd.vthis = null;
            }
        }
        exp.fd.tookAddressOf++;

    Ldone:
        sc = sc.вынь();
        результат = e;
    }

    // используется from CallExp::semantic()
    Выражение callExpSemantic(FuncExp exp, Scope* sc, Выражения* arguments)
    {
        if ((!exp.тип || exp.тип == Тип.tvoid) && exp.td && arguments && arguments.dim)
        {
            for (т_мера k = 0; k < arguments.dim; k++)
            {
                Выражение checkarg = (*arguments)[k];
                if (checkarg.op == ТОК2.error)
                    return checkarg;
            }

            exp.genIdent(sc);

            assert(exp.td.parameters && exp.td.parameters.dim);
            exp.td.dsymbolSemantic(sc);

            TypeFunction tfl = cast(TypeFunction)exp.fd.тип;
            т_мера dim = tfl.parameterList.length;
            if (arguments.dim < dim)
            {
                // Default arguments are always typed, so they don't need inference.
                Параметр2 p = tfl.parameterList[arguments.dim];
                if (p.defaultArg)
                    dim = arguments.dim;
            }

            if ((tfl.parameterList.varargs == ВарАрг.none && arguments.dim == dim) ||
                (tfl.parameterList.varargs != ВарАрг.none && arguments.dim >= dim))
            {
                auto tiargs = new Объекты();
                tiargs.резервируй(exp.td.parameters.dim);

                for (т_мера i = 0; i < exp.td.parameters.dim; i++)
                {
                    ПараметрШаблона2 tp = (*exp.td.parameters)[i];
                    for (т_мера u = 0; u < dim; u++)
                    {
                        Параметр2 p = tfl.parameterList[u];
                        if (p.тип.ty == Tident && (cast(TypeIdentifier)p.тип).идент == tp.идент)
                        {
                            Выражение e = (*arguments)[u];
                            tiargs.сунь(e.тип);
                            u = dim; // break inner loop
                        }
                    }
                }

                auto ti = new TemplateInstance(exp.место, exp.td, tiargs);
                return (new ScopeExp(exp.место, ti)).ВыражениеSemantic(sc);
            }
            exp.выведиОшибку("cannot infer function literal тип");
            return new ErrorExp();
        }
        return exp.ВыражениеSemantic(sc);
    }

    override проц посети(CallExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("CallExp::semantic() %s\n", exp.вТкст0());
        }
        if (exp.тип)
        {
            результат = exp;
            return; // semantic() already run
        }

        Тип t1;
        Объекты* tiargs = null; // initial list of template arguments
        Выражение ethis = null;
        Тип tthis = null;
        Выражение e1org = exp.e1;

        if (exp.e1.op == ТОК2.comma)
        {
            /* Rewrite (a,b)(args) as (a,(b(args)))
             */
            auto ce = cast(CommaExp)exp.e1;
            exp.e1 = ce.e2;
            ce.e2 = exp;
            результат = ce.ВыражениеSemantic(sc);
            return;
        }
        if (exp.e1.op == ТОК2.delegate_)
        {
            DelegateExp de = cast(DelegateExp)exp.e1;
            exp.e1 = new DotVarExp(de.место, de.e1, de.func, de.hasOverloads);
            посети(exp);
            return;
        }
        if (exp.e1.op == ТОК2.function_)
        {
            if (arrayВыражениеSemantic(exp.arguments, sc) || preFunctionParameters(sc, exp.arguments))
                return setError();

            // Run e1 semantic even if arguments have any errors
            FuncExp fe = cast(FuncExp)exp.e1;
            exp.e1 = callExpSemantic(fe, sc, exp.arguments);
            if (exp.e1.op == ТОК2.error)
            {
                результат = exp.e1;
                return;
            }
        }

        if (Выражение ex = resolveUFCS(sc, exp))
        {
            результат = ex;
            return;
        }

        /* This recognizes:
         *  foo!(tiargs)(funcargs)
         */
        if (exp.e1.op == ТОК2.scope_)
        {
            ScopeExp se = cast(ScopeExp)exp.e1;
            TemplateInstance ti = se.sds.isTemplateInstance();
            if (ti)
            {
                /* Attempt to instantiate ti. If that works, go with it.
                 * If not, go with partial explicit specialization.
                 */
                WithScopeSymbol withsym;
                if (!ti.findTempDecl(sc, &withsym) || !ti.semanticTiargs(sc))
                    return setError();
                if (withsym && withsym.withstate.wthis)
                {
                    exp.e1 = new VarExp(exp.e1.место, withsym.withstate.wthis);
                    exp.e1 = new DotTemplateInstanceExp(exp.e1.место, exp.e1, ti);
                    goto Ldotti;
                }
                if (ti.needsTypeInference(sc, 1))
                {
                    /* Go with partial explicit specialization
                     */
                    tiargs = ti.tiargs;
                    assert(ti.tempdecl);
                    if (TemplateDeclaration td = ti.tempdecl.isTemplateDeclaration())
                        exp.e1 = new TemplateExp(exp.место, td);
                    else if (OverDeclaration od = ti.tempdecl.isOverDeclaration())
                        exp.e1 = new VarExp(exp.место, od);
                    else
                        exp.e1 = new OverExp(exp.место, ti.tempdecl.isOverloadSet());
                }
                else
                {
                    Выражение e1x = exp.e1.ВыражениеSemantic(sc);
                    if (e1x.op == ТОК2.error)
                    {
                        результат = e1x;
                        return;
                    }
                    exp.e1 = e1x;
                }
            }
        }

        /* This recognizes:
         *  expr.foo!(tiargs)(funcargs)
         */
    Ldotti:
        if (exp.e1.op == ТОК2.dotTemplateInstance && !exp.e1.тип)
        {
            DotTemplateInstanceExp se = cast(DotTemplateInstanceExp)exp.e1;
            TemplateInstance ti = se.ti;
            {
                /* Attempt to instantiate ti. If that works, go with it.
                 * If not, go with partial explicit specialization.
                 */
                if (!se.findTempDecl(sc) || !ti.semanticTiargs(sc))
                    return setError();
                if (ti.needsTypeInference(sc, 1))
                {
                    /* Go with partial explicit specialization
                     */
                    tiargs = ti.tiargs;
                    assert(ti.tempdecl);
                    if (TemplateDeclaration td = ti.tempdecl.isTemplateDeclaration())
                        exp.e1 = new DotTemplateExp(exp.место, se.e1, td);
                    else if (OverDeclaration od = ti.tempdecl.isOverDeclaration())
                    {
                        exp.e1 = new DotVarExp(exp.место, se.e1, od, да);
                    }
                    else
                        exp.e1 = new DotExp(exp.место, se.e1, new OverExp(exp.место, ti.tempdecl.isOverloadSet()));
                }
                else
                {
                    Выражение e1x = exp.e1.ВыражениеSemantic(sc);
                    if (e1x.op == ТОК2.error)
                    {
                        результат = e1x;
                        return;
                    }
                    exp.e1 = e1x;
                }
            }
        }

    Lagain:
        //printf("Lagain: %s\n", вТкст0());
        exp.f = null;
        if (exp.e1.op == ТОК2.this_ || exp.e1.op == ТОК2.super_)
        {
            // semantic() run later for these
        }
        else
        {
            if (exp.e1.op == ТОК2.dotIdentifier)
            {
                DotIdExp die = cast(DotIdExp)exp.e1;
                exp.e1 = die.ВыражениеSemantic(sc);
                /* Look for e1 having been rewritten to expr.opDispatch!(ткст)
                 * We handle such earlier, so go back.
                 * Note that in the rewrite, we carefully did not run semantic() on e1
                 */
                if (exp.e1.op == ТОК2.dotTemplateInstance && !exp.e1.тип)
                {
                    goto Ldotti;
                }
            }
            else
            {
                 цел nest;
                if (++nest > глоб2.recursionLimit)
                {
                    exp.выведиОшибку("recursive evaluation of `%s`", exp.вТкст0());
                    --nest;
                    return setError();
                }
                Выражение ex = unaSemantic(exp, sc);
                --nest;
                if (ex)
                {
                    результат = ex;
                    return;
                }
            }

            /* Look for e1 being a lazy параметр
             */
            if (exp.e1.op == ТОК2.variable)
            {
                VarExp ve = cast(VarExp)exp.e1;
                if (ve.var.класс_хранения & STC.lazy_)
                {
                    // lazy parameters can be called without violating purity and safety
                    Тип tw = ve.var.тип;
                    Тип tc = ve.var.тип.substWildTo(MODFlags.const_);
                    auto tf = new TypeFunction(СписокПараметров(), tc, LINK.d, STC.safe | STC.pure_);
                    (tf = cast(TypeFunction)tf.typeSemantic(exp.место, sc)).следщ = tw; // hack for bug7757
                    auto t = new TypeDelegate(tf);
                    ve.тип = t.typeSemantic(exp.место, sc);
                }
                VarDeclaration v = ve.var.isVarDeclaration();
                if (v && ve.checkPurity(sc, v))
                    return setError();
            }

            if (exp.e1.op == ТОК2.symbolOffset && (cast(SymOffExp)exp.e1).hasOverloads)
            {
                SymOffExp se = cast(SymOffExp)exp.e1;
                exp.e1 = new VarExp(se.место, se.var, да);
                exp.e1 = exp.e1.ВыражениеSemantic(sc);
            }
            else if (exp.e1.op == ТОК2.dot)
            {
                DotExp de = cast(DotExp)exp.e1;

                if (de.e2.op == ТОК2.overloadSet)
                {
                    ethis = de.e1;
                    tthis = de.e1.тип;
                    exp.e1 = de.e2;
                }
            }
            else if (exp.e1.op == ТОК2.star && exp.e1.тип.ty == Tfunction)
            {
                // Rewrite (*fp)(arguments) to fp(arguments)
                exp.e1 = (cast(PtrExp)exp.e1).e1;
            }
        }

        t1 = exp.e1.тип ? exp.e1.тип.toBasetype() : null;

        if (exp.e1.op == ТОК2.error)
        {
            результат = exp.e1;
            return;
        }
        if (arrayВыражениеSemantic(exp.arguments, sc) || preFunctionParameters(sc, exp.arguments))
            return setError();

        // Check for call operator overload
        if (t1)
        {
            if (t1.ty == Tstruct)
            {
                auto sd = (cast(TypeStruct)t1).sym;
                sd.size(exp.место); // Resolve forward references to construct объект
                if (sd.sizeok != Sizeok.done)
                    return setError();
                if (!sd.ctor)
                    sd.ctor = sd.searchCtor();
                /* If `sd.ctor` is a generated копируй constructor, this means that it
                   is the single constructor that this struct has. In order to not
                   disable default construction, the ctor is nullified. The side effect
                   of this is that the generated копируй constructor cannot be called
                   explicitly, but that is ok, because when calling a constructor the
                   default constructor should have priority over the generated копируй
                   constructor.
                */
                if (sd.ctor)
                {
                    auto ctor = sd.ctor.isCtorDeclaration();
                    if (ctor && ctor.isCpCtor && ctor.generated)
                        sd.ctor = null;
                }

                // First look for constructor
                if (exp.e1.op == ТОК2.тип && sd.ctor)
                {
                    if (!sd.noDefaultCtor && !(exp.arguments && exp.arguments.dim))
                        goto Lx;

                    auto sle = new StructLiteralExp(exp.место, sd, null, exp.e1.тип);
                    if (!sd.fill(exp.место, sle.elements, да))
                        return setError();
                    if (checkFrameAccess(exp.место, sc, sd, sle.elements.dim))
                        return setError();

                    // https://issues.dlang.org/show_bug.cgi?ид=14556
                    // Set concrete тип to avoid further redundant semantic().
                    sle.тип = exp.e1.тип;

                    /* Constructor takes a mutable объект, so don't use
                     * the const инициализатор symbol.
                     */
                    sle.useStaticInit = нет;

                    Выражение e = sle;
                    if (auto cf = sd.ctor.isCtorDeclaration())
                    {
                        e = new DotVarExp(exp.место, e, cf, да);
                    }
                    else if (auto td = sd.ctor.isTemplateDeclaration())
                    {
                        e = new DotIdExp(exp.место, e, td.идент);
                    }
                    else if (auto ос = sd.ctor.isOverloadSet())
                    {
                        e = new DotExp(exp.место, e, new OverExp(exp.место, ос));
                    }
                    else
                        assert(0);
                    e = new CallExp(exp.место, e, exp.arguments);
                    e = e.ВыражениеSemantic(sc);
                    результат = e;
                    return;
                }
                // No constructor, look for overload of opCall
                if (search_function(sd, Id.call))
                    goto L1;
                // overload of opCall, therefore it's a call
                if (exp.e1.op != ТОК2.тип)
                {
                    if (sd.aliasthis && exp.e1.тип != exp.att1)
                    {
                        if (!exp.att1 && exp.e1.тип.checkAliasThisRec())
                            exp.att1 = exp.e1.тип;
                        exp.e1 = resolveAliasThis(sc, exp.e1);
                        goto Lagain;
                    }
                    exp.выведиОшибку("%s `%s` does not overload ()", sd.вид(), sd.вТкст0());
                    return setError();
                }

                /* It's a struct literal
                 */
            Lx:
                Выражение e = new StructLiteralExp(exp.место, sd, exp.arguments, exp.e1.тип);
                e = e.ВыражениеSemantic(sc);
                результат = e;
                return;
            }
            else if (t1.ty == Tclass)
            {
            L1:
                // Rewrite as e1.call(arguments)
                Выражение e = new DotIdExp(exp.место, exp.e1, Id.call);
                e = new CallExp(exp.место, e, exp.arguments);
                e = e.ВыражениеSemantic(sc);
                результат = e;
                return;
            }
            else if (exp.e1.op == ТОК2.тип && t1.isscalar())
            {
                Выражение e;

                // Make sure to use the the enum тип itself rather than its
                // base тип
                // https://issues.dlang.org/show_bug.cgi?ид=16346
                if (exp.e1.тип.ty == Tenum)
                {
                    t1 = exp.e1.тип;
                }

                if (!exp.arguments || exp.arguments.dim == 0)
                {
                    e = t1.defaultInitLiteral(exp.место);
                }
                else if (exp.arguments.dim == 1)
                {
                    e = (*exp.arguments)[0];
                    e = e.implicitCastTo(sc, t1);
                    e = new CastExp(exp.место, e, t1);
                }
                else
                {
                    exp.выведиОшибку("more than one argument for construction of `%s`", t1.вТкст0());
                    return setError();
                }
                e = e.ВыражениеSemantic(sc);
                результат = e;
                return;
            }
        }

        static FuncDeclaration resolveOverloadSet(Место место, Scope* sc,
            OverloadSet ос, Объекты* tiargs, Тип tthis, Выражения* arguments)
        {
            FuncDeclaration f = null;
            foreach (s; ос.a)
            {
                if (tiargs && s.isFuncDeclaration())
                    continue;
                if (auto f2 = resolveFuncCall(место, sc, s, tiargs, tthis, arguments, FuncResolveFlag.quiet))
                {
                    if (f2.errors)
                        return null;
                    if (f)
                    {
                        /* Error if match in more than one overload set,
                         * even if one is a 'better' match than the other.
                         */
                        ScopeDsymbol.multiplyDefined(место, f, f2);
                    }
                    else
                        f = f2;
                }
            }
            if (!f)
                .выведиОшибку(место, "no overload matches for `%s`", ос.вТкст0());
            else if (f.errors)
                f = null;
            return f;
        }

        бул isSuper = нет;
        if (exp.e1.op == ТОК2.dotVariable && t1.ty == Tfunction || exp.e1.op == ТОК2.dotTemplateDeclaration)
        {
            UnaExp ue = cast(UnaExp)exp.e1;

            Выражение ue1 = ue.e1;
            Выражение ue1old = ue1; // need for 'right this' check
            VarDeclaration v;
            if (ue1.op == ТОК2.variable && (v = (cast(VarExp)ue1).var.isVarDeclaration()) !is null && v.needThis())
            {
                ue.e1 = new TypeExp(ue1.место, ue1.тип);
                ue1 = null;
            }

            DotVarExp dve;
            DotTemplateExp dte;
            ДСимвол s;
            if (exp.e1.op == ТОК2.dotVariable)
            {
                dve = cast(DotVarExp)exp.e1;
                dte = null;
                s = dve.var;
                tiargs = null;
            }
            else
            {
                dve = null;
                dte = cast(DotTemplateExp)exp.e1;
                s = dte.td;
            }

            // Do overload resolution
            exp.f = resolveFuncCall(exp.место, sc, s, tiargs, ue1 ? ue1.тип : null, exp.arguments, FuncResolveFlag.standard);
            if (!exp.f || exp.f.errors || exp.f.тип.ty == Terror)
                return setError();

            if (exp.f.interfaceVirtual)
            {
                /* Cast 'this' to the тип of the interface, and replace f with the interface's equivalent
                 */
                auto b = exp.f.interfaceVirtual;
                auto ad2 = b.sym;
                ue.e1 = ue.e1.castTo(sc, ad2.тип.addMod(ue.e1.тип.mod));
                ue.e1 = ue.e1.ВыражениеSemantic(sc);
                ue1 = ue.e1;
                auto vi = exp.f.findVtblIndex(&ad2.vtbl, cast(цел)ad2.vtbl.dim);
                assert(vi >= 0);
                exp.f = ad2.vtbl[vi].isFuncDeclaration();
                assert(exp.f);
            }
            if (exp.f.needThis())
            {
                AggregateDeclaration ad = exp.f.toParentLocal().isAggregateDeclaration();
                ue.e1 = getRightThis(exp.место, sc, ad, ue.e1, exp.f);
                if (ue.e1.op == ТОК2.error)
                {
                    результат = ue.e1;
                    return;
                }
                ethis = ue.e1;
                tthis = ue.e1.тип;
                if (!(exp.f.тип.ty == Tfunction && (cast(TypeFunction)exp.f.тип).isscope))
                {
                    if (глоб2.парамы.vsafe && checkParamArgumentEscape(sc, exp.f, null, ethis, нет))
                        return setError();
                }
            }

            /* Cannot call public functions from inside invariant
             * (because then the invariant would have infinite recursion)
             */
            if (sc.func && sc.func.isInvariantDeclaration() && ue.e1.op == ТОК2.this_ && exp.f.addPostInvariant())
            {
                exp.выведиОшибку("cannot call `public`/`export` function `%s` from invariant", exp.f.вТкст0());
                return setError();
            }

            checkFunctionAttributes(exp, sc, exp.f);
            checkAccess(exp.место, sc, ue.e1, exp.f);
            if (!exp.f.needThis())
            {
                exp.e1 = Выражение.combine(ue.e1, new VarExp(exp.место, exp.f, нет));
            }
            else
            {
                if (ue1old.checkRightThis(sc))
                    return setError();
                if (exp.e1.op == ТОК2.dotVariable)
                {
                    dve.var = exp.f;
                    exp.e1.тип = exp.f.тип;
                }
                else
                {
                    exp.e1 = new DotVarExp(exp.место, dte.e1, exp.f, нет);
                    exp.e1 = exp.e1.ВыражениеSemantic(sc);
                    if (exp.e1.op == ТОК2.error)
                        return setError();
                    ue = cast(UnaExp)exp.e1;
                }
                version (none)
                {
                    printf("ue.e1 = %s\n", ue.e1.вТкст0());
                    printf("f = %s\n", exp.f.вТкст0());
                    printf("t = %s\n", t.вТкст0());
                    printf("e1 = %s\n", exp.e1.вТкст0());
                    printf("e1.тип = %s\n", exp.e1.тип.вТкст0());
                }

                // See if we need to adjust the 'this' pointer
                AggregateDeclaration ad = exp.f.isThis();
                ClassDeclaration cd = ue.e1.тип.isClassHandle();
                if (ad && cd && ad.isClassDeclaration())
                {
                    if (ue.e1.op == ТОК2.dotType)
                    {
                        ue.e1 = (cast(DotTypeExp)ue.e1).e1;
                        exp.directcall = да;
                    }
                    else if (ue.e1.op == ТОК2.super_)
                        exp.directcall = да;
                    else if ((cd.класс_хранения & STC.final_) != 0) // https://issues.dlang.org/show_bug.cgi?ид=14211
                        exp.directcall = да;

                    if (ad != cd)
                    {
                        ue.e1 = ue.e1.castTo(sc, ad.тип.addMod(ue.e1.тип.mod));
                        ue.e1 = ue.e1.ВыражениеSemantic(sc);
                    }
                }
            }
            // If we've got a pointer to a function then deference it
            // https://issues.dlang.org/show_bug.cgi?ид=16483
            if (exp.e1.тип.ty == Tpointer && exp.e1.тип.nextOf().ty == Tfunction)
            {
                Выражение e = new PtrExp(exp.место, exp.e1);
                e.тип = exp.e1.тип.nextOf();
                exp.e1 = e;
            }
            t1 = exp.e1.тип;
        }
        else if (exp.e1.op == ТОК2.super_ || exp.e1.op == ТОК2.this_)
        {
            auto ad = sc.func ? sc.func.isThis() : null;
            auto cd = ad ? ad.isClassDeclaration() : null;

            isSuper = exp.e1.op == ТОК2.super_;
            if (isSuper)
            {
                // Base class constructor call
                if (!cd || !cd.baseClass || !sc.func.isCtorDeclaration())
                {
                    exp.выведиОшибку("super class constructor call must be in a constructor");
                    return setError();
                }
                if (!cd.baseClass.ctor)
                {
                    exp.выведиОшибку("no super class constructor for `%s`", cd.baseClass.вТкст0());
                    return setError();
                }
            }
            else
            {
                // `this` call Выражение must be inside a
                // constructor
                if (!ad || !sc.func.isCtorDeclaration())
                {
                    exp.выведиОшибку("constructor call must be in a constructor");
                    return setError();
                }

                // https://issues.dlang.org/show_bug.cgi?ид=18719
                // If `exp` is a call Выражение to another constructor
                // then it means that all struct/class fields will be
                // initialized after this call.
                foreach (ref field; sc.ctorflow.fieldinit)
                {
                    field.csx |= CSX.this_ctor;
                }
            }

            if (!sc.intypeof && !(sc.ctorflow.callSuper & CSX.halt))
            {
                if (sc.inLoop || sc.ctorflow.callSuper & CSX.label)
                    exp.выведиОшибку("constructor calls not allowed in loops or after labels");
                if (sc.ctorflow.callSuper & (CSX.super_ctor | CSX.this_ctor))
                    exp.выведиОшибку("multiple constructor calls");
                if ((sc.ctorflow.callSuper & CSX.return_) && !(sc.ctorflow.callSuper & CSX.any_ctor))
                    exp.выведиОшибку("an earlier `return` инструкция skips constructor");
                sc.ctorflow.callSuper |= CSX.any_ctor | (isSuper ? CSX.super_ctor : CSX.this_ctor);
            }

            tthis = ad.тип.addMod(sc.func.тип.mod);
            auto ctor = isSuper ? cd.baseClass.ctor : ad.ctor;
            if (auto ос = ctor.isOverloadSet())
                exp.f = resolveOverloadSet(exp.место, sc, ос, null, tthis, exp.arguments);
            else
                exp.f = resolveFuncCall(exp.место, sc, ctor, null, tthis, exp.arguments, FuncResolveFlag.standard);

            if (!exp.f || exp.f.errors)
                return setError();

            checkFunctionAttributes(exp, sc, exp.f);
            checkAccess(exp.место, sc, null, exp.f);

            exp.e1 = new DotVarExp(exp.e1.место, exp.e1, exp.f, нет);
            exp.e1 = exp.e1.ВыражениеSemantic(sc);
            t1 = exp.e1.тип;

            // BUG: this should really be done by checking the static
            // call graph
            if (exp.f == sc.func)
            {
                exp.выведиОшибку("cyclic constructor call");
                return setError();
            }
        }
        else if (exp.e1.op == ТОК2.overloadSet)
        {
            auto ос = (cast(OverExp)exp.e1).vars;
            exp.f = resolveOverloadSet(exp.место, sc, ос, tiargs, tthis, exp.arguments);
            if (!exp.f)
                return setError();
            if (ethis)
                exp.e1 = new DotVarExp(exp.место, ethis, exp.f, нет);
            else
                exp.e1 = new VarExp(exp.место, exp.f, нет);
            goto Lagain;
        }
        else if (!t1)
        {
            exp.выведиОшибку("function expected before `()`, not `%s`", exp.e1.вТкст0());
            return setError();
        }
        else if (t1.ty == Terror)
        {
            return setError();
        }
        else if (t1.ty != Tfunction)
        {
            TypeFunction tf;
            ткст0 p;
            ДСимвол s;
            exp.f = null;
            if (exp.e1.op == ТОК2.function_)
            {
                // function literal that direct called is always inferred.
                assert((cast(FuncExp)exp.e1).fd);
                exp.f = (cast(FuncExp)exp.e1).fd;
                tf = cast(TypeFunction)exp.f.тип;
                p = "function literal";
            }
            else if (t1.ty == Tdelegate)
            {
                TypeDelegate td = cast(TypeDelegate)t1;
                assert(td.следщ.ty == Tfunction);
                tf = cast(TypeFunction)td.следщ;
                p = "delegate";
            }
            else if (t1.ty == Tpointer && (cast(TypePointer)t1).следщ.ty == Tfunction)
            {
                tf = cast(TypeFunction)(cast(TypePointer)t1).следщ;
                p = "function pointer";
            }
            else if (exp.e1.op == ТОК2.dotVariable && (cast(DotVarExp)exp.e1).var.isOverDeclaration())
            {
                DotVarExp dve = cast(DotVarExp)exp.e1;
                exp.f = resolveFuncCall(exp.место, sc, dve.var, tiargs, dve.e1.тип, exp.arguments, FuncResolveFlag.overloadOnly);
                if (!exp.f)
                    return setError();
                if (exp.f.needThis())
                {
                    dve.var = exp.f;
                    dve.тип = exp.f.тип;
                    dve.hasOverloads = нет;
                    goto Lagain;
                }
                exp.e1 = new VarExp(dve.место, exp.f, нет);
                Выражение e = new CommaExp(exp.место, dve.e1, exp);
                результат = e.ВыражениеSemantic(sc);
                return;
            }
            else if (exp.e1.op == ТОК2.variable && (cast(VarExp)exp.e1).var.isOverDeclaration())
            {
                s = (cast(VarExp)exp.e1).var;
                goto L2;
            }
            else if (exp.e1.op == ТОК2.template_)
            {
                s = (cast(TemplateExp)exp.e1).td;
            L2:
                exp.f = resolveFuncCall(exp.место, sc, s, tiargs, null, exp.arguments, FuncResolveFlag.standard);
                if (!exp.f || exp.f.errors)
                    return setError();
                if (exp.f.needThis())
                {
                    if (hasThis(sc))
                    {
                        // Supply an implicit 'this', as in
                        //    this.идент
                        exp.e1 = new DotVarExp(exp.место, (new ThisExp(exp.место)).ВыражениеSemantic(sc), exp.f, нет);
                        goto Lagain;
                    }
                    else if (isNeedThisScope(sc, exp.f))
                    {
                        exp.выведиОшибку("need `this` for `%s` of тип `%s`", exp.f.вТкст0(), exp.f.тип.вТкст0());
                        return setError();
                    }
                }
                exp.e1 = new VarExp(exp.e1.место, exp.f, нет);
                goto Lagain;
            }
            else
            {
                exp.выведиОшибку("function expected before `()`, not `%s` of тип `%s`", exp.e1.вТкст0(), exp.e1.тип.вТкст0());
                return setError();
            }

            ткст0 failMessage;
            Выражение[] fargs = exp.arguments ? (*exp.arguments)[] : null;
            if (!tf.callMatch(null, fargs, 0, &failMessage, sc))
            {
                БуфВыв буф;
                буф.пишиБайт('(');
                argExpTypesToCBuffer(&буф, exp.arguments);
                буф.пишиБайт(')');
                if (tthis)
                    tthis.modToBuffer(&буф);

                //printf("tf = %s, args = %s\n", tf.deco, (*arguments)[0].тип.deco);
                .выведиОшибку(exp.место, "%s `%s%s` is not callable using argument types `%s`",
                    p, exp.e1.вТкст0(), parametersTypeToChars(tf.parameterList), буф.peekChars());
                if (failMessage)
                    errorSupplemental(exp.место, "%s", failMessage);
                return setError();
            }
            // Purity and safety check should run after testing arguments matching
            if (exp.f)
            {
                exp.checkPurity(sc, exp.f);
                exp.checkSafety(sc, exp.f);
                exp.checkNogc(sc, exp.f);
                if (exp.f.checkNestedReference(sc, exp.место))
                    return setError();
            }
            else if (sc.func && sc.intypeof != 1 && !(sc.flags & (SCOPE.ctfe | SCOPE.debug_)))
            {
                бул err = нет;
                if (!tf.purity && sc.func.setImpure())
                {
                    exp.выведиОшибку("`` %s `%s` cannot call impure %s `%s`",
                        sc.func.вид(), sc.func.toPrettyChars(), p, exp.e1.вТкст0());
                    err = да;
                }
                if (!tf.isnogc && sc.func.setGC())
                {
                    exp.выведиОшибку("`` %s `%s` cannot call non- %s `%s`",
                        sc.func.вид(), sc.func.toPrettyChars(), p, exp.e1.вТкст0());
                    err = да;
                }
                if (tf.trust <= TRUST.system && sc.func.setUnsafe())
                {
                    exp.выведиОшибку("`` %s `%s` cannot call `@system` %s `%s`",
                        sc.func.вид(), sc.func.toPrettyChars(), p, exp.e1.вТкст0());
                    err = да;
                }
                if (err)
                    return setError();
            }

            if (t1.ty == Tpointer)
            {
                Выражение e = new PtrExp(exp.место, exp.e1);
                e.тип = tf;
                exp.e1 = e;
            }
            t1 = tf;
        }
        else if (exp.e1.op == ТОК2.variable)
        {
            // Do overload resolution
            VarExp ve = cast(VarExp)exp.e1;

            exp.f = ve.var.isFuncDeclaration();
            assert(exp.f);
            tiargs = null;

            if (exp.f.overnext)
                exp.f = resolveFuncCall(exp.место, sc, exp.f, tiargs, null, exp.arguments, FuncResolveFlag.overloadOnly);
            else
            {
                exp.f = exp.f.toAliasFunc();
                TypeFunction tf = cast(TypeFunction)exp.f.тип;
                ткст0 failMessage;
                Выражение[] fargs = exp.arguments ? (*exp.arguments)[] : null;
                if (!tf.callMatch(null, fargs, 0, &failMessage, sc))
                {
                    БуфВыв буф;
                    буф.пишиБайт('(');
                    argExpTypesToCBuffer(&буф, exp.arguments);
                    буф.пишиБайт(')');

                    //printf("tf = %s, args = %s\n", tf.deco, (*arguments)[0].тип.deco);
                    .выведиОшибку(exp.место, "%s `%s%s` is not callable using argument types `%s`",
                        exp.f.вид(), exp.f.toPrettyChars(), parametersTypeToChars(tf.parameterList), буф.peekChars());
                    if (failMessage)
                        errorSupplemental(exp.место, "%s", failMessage);
                    exp.f = null;
                }
            }
            if (!exp.f || exp.f.errors)
                return setError();

            if (exp.f.needThis())
            {
                // Change the ancestor lambdas to delegate before hasThis(sc) call.
                if (exp.f.checkNestedReference(sc, exp.место))
                    return setError();

                if (hasThis(sc))
                {
                    // Supply an implicit 'this', as in
                    //    this.идент
                    exp.e1 = new DotVarExp(exp.место, (new ThisExp(exp.место)).ВыражениеSemantic(sc), ve.var);
                    // Note: we cannot use f directly, because further overload resolution
                    // through the supplied 'this' may cause different результат.
                    goto Lagain;
                }
                else if (isNeedThisScope(sc, exp.f))
                {
                    exp.выведиОшибку("need `this` for `%s` of тип `%s`", exp.f.вТкст0(), exp.f.тип.вТкст0());
                    return setError();
                }
            }

            checkFunctionAttributes(exp, sc, exp.f);
            checkAccess(exp.место, sc, null, exp.f);
            if (exp.f.checkNestedReference(sc, exp.место))
                return setError();

            ethis = null;
            tthis = null;

            if (ve.hasOverloads)
            {
                exp.e1 = new VarExp(ve.место, exp.f, нет);
                exp.e1.тип = exp.f.тип;
            }
            t1 = exp.f.тип;
        }
        assert(t1.ty == Tfunction);

        Выражение argprefix;
        if (!exp.arguments)
            exp.arguments = new Выражения();
        if (functionParameters(exp.место, sc, cast(TypeFunction)t1, ethis, tthis, exp.arguments, exp.f, &exp.тип, &argprefix))
            return setError();

        if (!exp.тип)
        {
            exp.e1 = e1org; // https://issues.dlang.org/show_bug.cgi?ид=10922
                        // avoid recursive Выражение printing
            exp.выведиОшибку("forward reference to inferred return тип of function call `%s`", exp.вТкст0());
            return setError();
        }

        if (exp.f && exp.f.tintro)
        {
            Тип t = exp.тип;
            цел смещение = 0;
            TypeFunction tf = cast(TypeFunction)exp.f.tintro;
            if (tf.следщ.isBaseOf(t, &смещение) && смещение)
            {
                exp.тип = tf.следщ;
                результат = Выражение.combine(argprefix, exp.castTo(sc, t));
                return;
            }
        }

        // Handle the case of a direct lambda call
        if (exp.f && exp.f.isFuncLiteralDeclaration() && sc.func && !sc.intypeof)
        {
            exp.f.tookAddressOf = 0;
        }

        результат = Выражение.combine(argprefix, exp);

        if (isSuper)
        {
            auto ad = sc.func ? sc.func.isThis() : null;
            auto cd = ad ? ad.isClassDeclaration() : null;
            if (cd && cd.classKind == ClassKind.cpp && exp.f && !exp.f.fbody)
            {
                // if super is defined in C++, it sets the vtable pointer to the base class
                // so we have to restore it, but still return 'this' from super() call:
                // (auto __vptrTmp = this.__vptr, auto __superTmp = super()), (this.__vptr = __vptrTmp, __superTmp)
                Место место = exp.место;

                auto vptr = new DotIdExp(место, new ThisExp(место), Id.__vptr);
                auto vptrTmpDecl = copyToTemp(0, "__vptrTmp", vptr);
                auto declareVptrTmp = new DeclarationExp(место, vptrTmpDecl);

                auto superTmpDecl = copyToTemp(0, "__superTmp", результат);
                auto declareSuperTmp = new DeclarationExp(место, superTmpDecl);

                auto declareTmps = new CommaExp(место, declareVptrTmp, declareSuperTmp);

                auto restoreVptr = new AssignExp(место, vptr.syntaxCopy(), new VarExp(место, vptrTmpDecl));

                Выражение e = new CommaExp(место, declareTmps, new CommaExp(место, restoreVptr, new VarExp(место, superTmpDecl)));
                результат = e.ВыражениеSemantic(sc);
            }
        }

        // declare dual-context container
        if (exp.f && exp.f.isThis2 && !sc.intypeof && sc.func)
        {
            // check access to second `this`
            if (AggregateDeclaration ad2 = exp.f.isMember2())
            {
                auto rez = new ThisExp(exp.место);
                Выражение te = rez.ВыражениеSemantic(sc);
                if (te.op != ТОК2.error)
                    te = getRightThis(exp.место, sc, ad2, te, exp.f);
                if (te.op == ТОК2.error)
                {
                    exp.выведиОшибку("need `this` of тип `%s` to call function `%s`", ad2.вТкст0(), exp.f.вТкст0());
                    return setError();
                }
            }
            VarDeclaration vthis2 = makeThis2Argument(exp.место, sc, exp.f);            exp.vthis2 = vthis2;
            Выражение de = new DeclarationExp(exp.место, vthis2);
            результат = Выражение.combine(de, результат);
            результат = результат.ВыражениеSemantic(sc);
        }
    }

    override проц посети(DeclarationExp e)
    {
        if (e.тип)
        {
            результат = e;
            return;
        }
        static if (LOGSEMANTIC)
        {
            printf("DeclarationExp::semantic() %s\n", e.вТкст0());
        }

        бцел olderrors = глоб2.errors;

        /* This is here to support extern(компонаж) declaration,
         * where the extern(компонаж) winds up being an AttribDeclaration
         * wrapper.
         */
        ДСимвол s = e.declaration;

        while (1)
        {
            AttribDeclaration ad = s.isAttribDeclaration();
            if (ad)
            {
                if (ad.decl && ad.decl.dim == 1)
                {
                    s = (*ad.decl)[0];
                    continue;
                }
            }
            break;
        }

        VarDeclaration v = s.isVarDeclaration();
        if (v)
        {
            // Do semantic() on инициализатор first, so:
            //      цел a = a;
            // will be illegal.
            e.declaration.dsymbolSemantic(sc);
            s.родитель = sc.родитель;
        }

        //printf("inserting '%s' %p into sc = %p\n", s.вТкст0(), s, sc);
        // Insert into both local scope and function scope.
        // Must be unique in both.
        if (s.идент)
        {
            if (!sc.вставь(s))
            {
                e.выведиОшибку("declaration `%s` is already defined", s.toPrettyChars());
                return setError();
            }
            else if (sc.func)
            {
                // https://issues.dlang.org/show_bug.cgi?ид=11720
                // include Dataseg variables
                if ((s.isFuncDeclaration() ||
                     s.isAggregateDeclaration() ||
                     s.isEnumDeclaration() ||
                     v && v.isDataseg()) && !sc.func.localsymtab.вставь(s))
                {
                    // https://issues.dlang.org/show_bug.cgi?ид=18266
                    // set родитель so that тип semantic does not assert
                    s.родитель = sc.родитель;
                    ДСимвол originalSymbol = sc.func.localsymtab.lookup(s.идент);
                    assert(originalSymbol);
                    e.выведиОшибку("declaration `%s` is already defined in another scope in `%s` at line `%d`", s.toPrettyChars(), sc.func.вТкст0(), originalSymbol.место.номстр);
                    return setError();
                }
                else
                {
                    // Disallow shadowing
                    for (Scope* scx = sc.enclosing; scx && (scx.func == sc.func || (scx.func && sc.func.fes)); scx = scx.enclosing)
                    {
                        ДСимвол s2;
                        if (scx.scopesym && scx.scopesym.symtab && (s2 = scx.scopesym.symtab.lookup(s.идент)) !is null && s != s2)
                        {
                            // allow STC.local symbols to be shadowed
                            // TODO: not really an optimal design
                            auto decl = s2.isDeclaration();
                            if (!decl || !(decl.класс_хранения & STC.local))
                            {
                                if (sc.func.fes)
                                {
                                    e.deprecation("%s `%s` is shadowing %s `%s`. Rename the `foreach` variable.", s.вид(), s.идент.вТкст0(), s2.вид(), s2.toPrettyChars());
                                }
                                else
                                {
                                    e.выведиОшибку("%s `%s` is shadowing %s `%s`", s.вид(), s.идент.вТкст0(), s2.вид(), s2.toPrettyChars());
                                    return setError();
                                }
                            }
                        }
                    }
                }
            }
        }
        if (!s.isVarDeclaration())
        {
            Scope* sc2 = sc;
            if (sc2.stc & (STC.pure_ | STC.nothrow_ | STC.nogc))
                sc2 = sc.сунь();
            sc2.stc &= ~(STC.pure_ | STC.nothrow_ | STC.nogc);
            e.declaration.dsymbolSemantic(sc2);
            if (sc2 != sc)
                sc2.вынь();
            s.родитель = sc.родитель;
        }
        if (глоб2.errors == olderrors)
        {
            e.declaration.semantic2(sc);
            if (глоб2.errors == olderrors)
            {
                e.declaration.semantic3(sc);
            }
        }
        // todo: error in declaration should be propagated.

        e.тип = Тип.tvoid;
        результат = e;
    }

    override проц посети(TypeidExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("TypeidExp::semantic() %s\n", exp.вТкст0());
        }
        Тип ta = тип_ли(exp.obj);
        Выражение ea = выражение_ли(exp.obj);
        ДСимвол sa = isDsymbol(exp.obj);
        //printf("ta %p ea %p sa %p\n", ta, ea, sa);

        if (ta)
        {
            dmd.typesem.resolve(ta, exp.место, sc, &ea, &ta, &sa, да);
        }

        if (ea)
        {
            if (auto sym = getDsymbol(ea))
                ea = symbolToExp(sym, exp.место, sc, нет);
            else
                ea = ea.ВыражениеSemantic(sc);
            ea = resolveProperties(sc, ea);
            ta = ea.тип;
            if (ea.op == ТОК2.тип)
                ea = null;
        }

        if (!ta)
        {
            //printf("ta %p ea %p sa %p\n", ta, ea, sa);
            exp.выведиОшибку("no тип for `typeid(%s)`", ea ? ea.вТкст0() : (sa ? sa.вТкст0() : ""));
            return setError();
        }

        if (глоб2.парамы.vcomplex)
            ta.checkComplexTransition(exp.место, sc);

        Выражение e;
        auto tb = ta.toBasetype();
        if (ea && tb.ty == Tclass)
        {
            if (tb.toDsymbol(sc).isClassDeclaration().classKind == ClassKind.cpp)
            {
                выведиОшибку(exp.место, "Runtime тип information is not supported for `/*extern(C++)*/` classes");
                e = new ErrorExp();
            }
            else if (!Тип.typeinfoclass)
            {
                выведиОшибку(exp.место, "`объект.TypeInfo_Class` could not be found, but is implicitly используется");
                e = new ErrorExp();
            }
            else
            {
                /* Get the dynamic тип, which is .classinfo
                */
                ea = ea.ВыражениеSemantic(sc);
                e = new TypeidExp(ea.место, ea);
                e.тип = Тип.typeinfoclass.тип;
            }
        }
        else if (ta.ty == Terror)
        {
            e = new ErrorExp();
        }
        else
        {
            // Handle this in the glue layer
            e = new TypeidExp(exp.место, ta);
            e.тип = getTypeInfoType(exp.место, ta, sc);

            semanticTypeInfo(sc, ta);

            if (ea)
            {
                e = new CommaExp(exp.место, ea, e); // execute ea
                e = e.ВыражениеSemantic(sc);
            }
        }
        результат = e;
    }

    override проц посети(TraitsExp e)
    {
        результат = semanticTraits(e, sc);
    }

    override проц посети(HaltExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("HaltExp::semantic()\n");
        }
        e.тип = Тип.tvoid;
        результат = e;
    }

    override проц посети(IsExp e)
    {
        /* is(targ ид tok tspec)
         * is(targ ид :  tok2)
         * is(targ ид == tok2)
         */

        //printf("IsExp::semantic(%s)\n", вТкст0());
        if (e.ид && !(sc.flags & SCOPE.условие))
        {
            e.выведиОшибку("can only declare тип ники within `static if` conditionals or `static assert`s");
            return setError();
        }

        Тип tded = null;
        if (e.tok2 == ТОК2.package_ || e.tok2 == ТОК2.module_) // These is() Выражения are special because they can work on modules, not just types.
        {
            const oldErrors = глоб2.startGagging();
            ДСимвол sym = e.targ.toDsymbol(sc);
            глоб2.endGagging(oldErrors);

            if (sym is null)
                goto Lno;
            Package p = resolveIsPackage(sym);
            if (p is null)
                goto Lno;
            if (e.tok2 == ТОК2.package_ && p.isModule()) // Note that isModule() will return null for package modules because they're not actually instances of Module.
                goto Lno;
            else if(e.tok2 == ТОК2.module_ && !(p.isModule() || p.isPackageMod()))
                goto Lno;
            tded = e.targ;
            goto Lyes;
        }

        {
            Scope* sc2 = sc.копируй(); // keep sc.flags
            sc2.tinst = null;
            sc2.minst = null;
            sc2.flags |= SCOPE.fullinst;
            Тип t = e.targ.trySemantic(e.место, sc2);
            sc2.вынь();
            if (!t) // errors, so условие is нет
                goto Lno;
            e.targ = t;
        }

        if (e.tok2 != ТОК2.reserved)
        {
            switch (e.tok2)
            {
            case ТОК2.struct_:
                if (e.targ.ty != Tstruct)
                    goto Lno;
                if ((cast(TypeStruct)e.targ).sym.isUnionDeclaration())
                    goto Lno;
                tded = e.targ;
                break;

            case ТОК2.union_:
                if (e.targ.ty != Tstruct)
                    goto Lno;
                if (!(cast(TypeStruct)e.targ).sym.isUnionDeclaration())
                    goto Lno;
                tded = e.targ;
                break;

            case ТОК2.class_:
                if (e.targ.ty != Tclass)
                    goto Lno;
                if ((cast(TypeClass)e.targ).sym.isInterfaceDeclaration())
                    goto Lno;
                tded = e.targ;
                break;

            case ТОК2.interface_:
                if (e.targ.ty != Tclass)
                    goto Lno;
                if (!(cast(TypeClass)e.targ).sym.isInterfaceDeclaration())
                    goto Lno;
                tded = e.targ;
                break;

            case ТОК2.const_:
                if (!e.targ.isConst())
                    goto Lno;
                tded = e.targ;
                break;

            case ТОК2.immutable_:
                if (!e.targ.isImmutable())
                    goto Lno;
                tded = e.targ;
                break;

            case ТОК2.shared_:
                if (!e.targ.isShared())
                    goto Lno;
                tded = e.targ;
                break;

            case ТОК2.inout_:
                if (!e.targ.isWild())
                    goto Lno;
                tded = e.targ;
                break;

            case ТОК2.super_:
                // If class or interface, get the base class and interfaces
                if (e.targ.ty != Tclass)
                    goto Lno;
                else
                {
                    ClassDeclaration cd = (cast(TypeClass)e.targ).sym;
                    auto args = new Параметры();
                    args.резервируй(cd.baseclasses.dim);
                    if (cd.semanticRun < PASS.semanticdone)
                        cd.dsymbolSemantic(null);
                    for (т_мера i = 0; i < cd.baseclasses.dim; i++)
                    {
                        КлассОснова2* b = (*cd.baseclasses)[i];
                        args.сунь(new Параметр2(STC.in_, b.тип, null, null, null));
                    }
                    tded = new КортежТипов(args);
                }
                break;

            case ТОК2.enum_:
                if (e.targ.ty != Tenum)
                    goto Lno;
                if (e.ид)
                    tded = (cast(TypeEnum)e.targ).sym.getMemtype(e.место);
                else
                    tded = e.targ;

                if (tded.ty == Terror)
                    return setError();
                break;

            case ТОК2.delegate_:
                if (e.targ.ty != Tdelegate)
                    goto Lno;
                tded = (cast(TypeDelegate)e.targ).следщ; // the underlying function тип
                break;

            case ТОК2.function_:
            case ТОК2.parameters:
                {
                    if (e.targ.ty != Tfunction)
                        goto Lno;
                    tded = e.targ;

                    /* Generate кортеж from function параметр types.
                     */
                    assert(tded.ty == Tfunction);
                    auto tdedf = tded.isTypeFunction();
                    т_мера dim = tdedf.parameterList.length;
                    auto args = new Параметры();
                    args.резервируй(dim);
                    for (т_мера i = 0; i < dim; i++)
                    {
                        Параметр2 arg = tdedf.parameterList[i];
                        assert(arg && arg.тип);
                        /* If one of the default arguments was an error,
                           don't return an invalid кортеж
                         */
                        if (e.tok2 == ТОК2.parameters && arg.defaultArg && arg.defaultArg.op == ТОК2.error)
                            return setError();
                        args.сунь(new Параметр2(arg.классХранения, arg.тип, (e.tok2 == ТОК2.parameters) ? arg.идент : null, (e.tok2 == ТОК2.parameters) ? arg.defaultArg : null, arg.userAttribDecl));
                    }
                    tded = new КортежТипов(args);
                    break;
                }
            case ТОК2.return_:
                /* Get the 'return тип' for the function,
                 * delegate, or pointer to function.
                 */
                if (e.targ.ty == Tfunction)
                    tded = (cast(TypeFunction)e.targ).следщ;
                else if (e.targ.ty == Tdelegate)
                {
                    tded = (cast(TypeDelegate)e.targ).следщ;
                    tded = (cast(TypeFunction)tded).следщ;
                }
                else if (e.targ.ty == Tpointer && (cast(TypePointer)e.targ).следщ.ty == Tfunction)
                {
                    tded = (cast(TypePointer)e.targ).следщ;
                    tded = (cast(TypeFunction)tded).следщ;
                }
                else
                    goto Lno;
                break;

            case ТОК2.argumentTypes:
                /* Generate a тип кортеж of the equivalent types используется to determine if a
                 * function argument of this тип can be passed in registers.
                 * The результатs of this are highly platform dependent, and intended
                 * primarly for use in implementing va_arg().
                 */
                tded = target.toArgTypes(e.targ);
                if (!tded)
                    goto Lno;
                // not valid for a параметр
                break;

            case ТОК2.vector:
                if (e.targ.ty != Tvector)
                    goto Lno;
                tded = (cast(TypeVector)e.targ).basetype;
                break;

            default:
                assert(0);
            }

            // https://issues.dlang.org/show_bug.cgi?ид=18753
            if (tded)
                goto Lyes;
            goto Lno;
        }
        else if (e.tspec && !e.ид && !(e.parameters && e.parameters.dim))
        {
            /* Evaluate to да if targ matches tspec
             * is(targ == tspec)
             * is(targ : tspec)
             */
            e.tspec = e.tspec.typeSemantic(e.место, sc);
            //printf("targ  = %s, %s\n", targ.вТкст0(), targ.deco);
            //printf("tspec = %s, %s\n", tspec.вТкст0(), tspec.deco);

            if (e.tok == ТОК2.colon)
            {
                if (e.targ.implicitConvTo(e.tspec))
                    goto Lyes;
                else
                    goto Lno;
            }
            else /* == */
            {
                if (e.targ.равен(e.tspec))
                    goto Lyes;
                else
                    goto Lno;
            }
        }
        else if (e.tspec)
        {
            /* Evaluate to да if targ matches tspec.
             * If да, declare ид as an alias for the specialized тип.
             * is(targ == tspec, tpl)
             * is(targ : tspec, tpl)
             * is(targ ид == tspec)
             * is(targ ид : tspec)
             * is(targ ид == tspec, tpl)
             * is(targ ид : tspec, tpl)
             */
            Идентификатор2 tid = e.ид ? e.ид : Идентификатор2.генерируйИд("__isexp_id");
            e.parameters.вставь(0, new TemplateTypeParameter(e.место, tid, null, null));

            Объекты dedtypes = Объекты(e.parameters.dim);
            dedtypes.нуль();

            MATCH m = deduceType(e.targ, sc, e.tspec, e.parameters, &dedtypes, null, 0, e.tok == ТОК2.equal);
            //printf("targ: %s\n", targ.вТкст0());
            //printf("tspec: %s\n", tspec.вТкст0());
            if (m <= MATCH.nomatch || (m != MATCH.exact && e.tok == ТОК2.equal))
            {
                goto Lno;
            }
            else
            {
                tded = cast(Тип)dedtypes[0];
                if (!tded)
                    tded = e.targ;
                Объекты tiargs = Объекты(1);
                tiargs[0] = e.targ;

                /* Declare trailing parameters
                 */
                for (т_мера i = 1; i < e.parameters.dim; i++)
                {
                    ПараметрШаблона2 tp = (*e.parameters)[i];
                    Declaration s = null;

                    m = tp.matchArg(e.место, sc, &tiargs, i, e.parameters, &dedtypes, &s);
                    if (m <= MATCH.nomatch)
                        goto Lno;
                    s.dsymbolSemantic(sc);
                    if (!sc.вставь(s))
                        e.выведиОшибку("declaration `%s` is already defined", s.вТкст0());

                    unSpeculative(sc, s);
                }
                goto Lyes;
            }
        }
        else if (e.ид)
        {
            /* Declare ид as an alias for тип targ. Evaluate to да
             * is(targ ид)
             */
            tded = e.targ;
            goto Lyes;
        }

    Lyes:
        if (e.ид)
        {
            ДСимвол s;
            Tuple tup = кортеж_ли(tded);
            if (tup)
                s = new TupleDeclaration(e.место, e.ид, &tup.objects);
            else
                s = new AliasDeclaration(e.место, e.ид, tded);
            s.dsymbolSemantic(sc);

            /* The reason for the !tup is unclear. It fails Phobos unittests if it is not there.
             * More investigation is needed.
             */
            if (!tup && !sc.вставь(s))
                e.выведиОшибку("declaration `%s` is already defined", s.вТкст0());

            unSpeculative(sc, s);
        }
        //printf("Lyes\n");
        результат = IntegerExp.createBool(да);
        return;

    Lno:
        //printf("Lno\n");
        результат = IntegerExp.createBool(нет);
    }

    override проц посети(BinAssignExp exp)
    {
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        if (checkIfIsStructLiteralDotExpr(exp.e1))
            return setError();
        if (exp.e1.op == ТОК2.arrayLength)
        {
            // arr.length op= e2;
            e = rewriteOpAssign(exp);
            e = e.ВыражениеSemantic(sc);
            результат = e;
            return;
        }
        if (exp.e1.op == ТОК2.slice || exp.e1.тип.ty == Tarray || exp.e1.тип.ty == Tsarray)
        {
            if (checkNonAssignmentArrayOp(exp.e1))
                return setError();

            if (exp.e1.op == ТОК2.slice)
                (cast(SliceExp)exp.e1).arrayop = да;

            // T[] op= ...
            if (exp.e2.implicitConvTo(exp.e1.тип.nextOf()))
            {
                // T[] op= T
                exp.e2 = exp.e2.castTo(sc, exp.e1.тип.nextOf());
            }
            else if (Выражение ex = typeCombine(exp, sc))
            {
                результат = ex;
                return;
            }
            exp.тип = exp.e1.тип;
            результат = arrayOp(exp, sc);
            return;
        }

        exp.e1 = exp.e1.ВыражениеSemantic(sc);
        exp.e1 = exp.e1.optimize(WANTvalue);
        exp.e1 = exp.e1.modifiableLvalue(sc, exp.e1);
        exp.тип = exp.e1.тип;

        if (auto ad = isAggregate(exp.e1.тип))
        {
            if(auto s = search_function(ad, Id.opOpAssign))
            {
                выведиОшибку(exp.место, "none of the `opOpAssign` overloads of `%s` are callable for `%s` of тип `%s`", ad.вТкст0(), exp.e1.вТкст0(), exp.e1.тип.вТкст0());
                return setError();
            }
        }
        if (exp.e1.checkScalar() ||
            exp.e1.checkReadModifyWrite(exp.op, exp.e2) ||
            exp.e1.checkSharedAccess(sc))
            return setError();

        цел arith = (exp.op == ТОК2.addAssign || exp.op == ТОК2.minAssign || exp.op == ТОК2.mulAssign || exp.op == ТОК2.divAssign || exp.op == ТОК2.modAssign || exp.op == ТОК2.powAssign);
        цел bitwise = (exp.op == ТОК2.andAssign || exp.op == ТОК2.orAssign || exp.op == ТОК2.xorAssign);
        цел shift = (exp.op == ТОК2.leftShiftAssign || exp.op == ТОК2.rightShiftAssign || exp.op == ТОК2.unsignedRightShiftAssign);

        if (bitwise && exp.тип.toBasetype().ty == Tbool)
            exp.e2 = exp.e2.implicitCastTo(sc, exp.тип);
        else if (exp.checkNoBool())
            return setError();

        if ((exp.op == ТОК2.addAssign || exp.op == ТОК2.minAssign) && exp.e1.тип.toBasetype().ty == Tpointer && exp.e2.тип.toBasetype().isintegral())
        {
            результат = scaleFactor(exp, sc);
            return;
        }

        if (Выражение ex = typeCombine(exp, sc))
        {
            результат = ex;
            return;
        }

        if (arith && (exp.checkArithmeticBin() || exp.checkSharedAccessBin(sc)))
            return setError();
        if ((bitwise || shift) && (exp.checkIntegralBin() || exp.checkSharedAccessBin(sc)))
            return setError();

        if (shift)
        {
            if (exp.e2.тип.toBasetype().ty != Tvector)
                exp.e2 = exp.e2.castTo(sc, Тип.tshiftcnt);
        }

        if (!target.isVectorOpSupported(exp.тип.toBasetype(), exp.op, exp.e2.тип.toBasetype()))
        {
            результат = exp.incompatibleTypes();
            return;
        }

        if (exp.e1.op == ТОК2.error || exp.e2.op == ТОК2.error)
            return setError();

        e = exp.checkOpAssignTypes(sc);
        if (e.op == ТОК2.error)
        {
            результат = e;
            return;
        }

        assert(e.op == ТОК2.assign || e == exp);
        результат = (cast(BinExp)e).reorderSettingAAElem(sc);
    }

    private Выражение compileIt(CompileExp exp)
    {
        БуфВыв буф;
        if (выраженияВТкст(буф, sc, exp.exps))
            return null;

        бцел errors = глоб2.errors;
        const len = буф.length;
        const str = буф.extractChars()[0 .. len];
        scope p = new Parser!(ASTCodegen)(exp.место, sc._module, str, нет);
        p.nextToken();
        //printf("p.место.номстр = %d\n", p.место.номстр);

        Выражение e = p.parseВыражение();
        if (глоб2.errors != errors)
            return null;

        if (p.token.значение != ТОК2.endOfFile)
        {
            exp.выведиОшибку("incomplete mixin Выражение `%s`", str.ptr);
            return null;
        }
        return e;
    }

    override проц посети(CompileExp exp)
    {
        /* https://dlang.org/spec/Выражение.html#mixin_Выражениеs
         */

        static if (LOGSEMANTIC)
        {
            printf("CompileExp::semantic('%s')\n", exp.вТкст0());
        }

        auto e = compileIt(exp);
        if (!e)
            return setError();
        результат = e.ВыражениеSemantic(sc);
    }

    override проц посети(ImportExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("ImportExp::semantic('%s')\n", e.вТкст0());
        }

        auto se = semanticString(sc, e.e1, "файл имя argument");
        if (!se)
            return setError();
        se = se.toUTF8(sc);

        auto namez = se.вТкст0().ptr;
        if (!глоб2.filePath)
        {
            e.выведиОшибку("need `-J` switch to import text файл `%s`", namez);
            return setError();
        }

        /* Be wary of CWE-22: Improper Limitation of a Pathname to a Restricted Directory
         * ('Path Traversal') attacks.
         * http://cwe.mitre.org/данные/definitions/22.html
         */

        auto имя = ИмяФайла.safeSearchPath(глоб2.filePath, namez);
        if (!имя)
        {
            e.выведиОшибку("файл `%s` cannot be found or not in a path specified with `-J`", se.вТкст0());
            return setError();
        }

        sc._module.contentImportedFiles.сунь(имя);
        if (глоб2.парамы.verbose)
        {
            const slice = se.peekString();
            message("файл      %.*s\t(%s)", cast(цел)slice.length, slice.ptr, имя);
        }
        if (глоб2.парамы.moduleDeps !is null)
        {
            БуфВыв* ob = глоб2.парамы.moduleDeps;
            Module imod = sc.instantiatingModule();

            if (!глоб2.парамы.moduleDepsFile)
                ob.пишиСтр("depsFile ");
            ob.пишиСтр(imod.toPrettyChars());
            ob.пишиСтр(" (");
            escapePath(ob, imod.srcfile.вТкст0());
            ob.пишиСтр(") : ");
            if (глоб2.парамы.moduleDepsFile)
                ob.пишиСтр("ткст : ");
            ob.пиши(se.peekString());
            ob.пишиСтр(" (");
            escapePath(ob, имя);
            ob.пишиСтр(")");
            ob.нс();
        }

        {
            auto readрезультат = Файл.читай(имя);
            if (!readрезультат.успех)
            {
                e.выведиОшибку("cannot читай файл `%s`", имя);
                return setError();
            }
            else
            {
                // take ownership of буфер (probably leaking)
                auto данные = readрезультат.извлекиСрез();
                se = new StringExp(e.место, данные);
            }
        }
        результат = se.ВыражениеSemantic(sc);
    }

    override проц посети(AssertExp exp)
    {
        // https://dlang.org/spec/Выражение.html#assert_Выражениеs
        static if (LOGSEMANTIC)
        {
            printf("AssertExp::semantic('%s')\n", exp.вТкст0());
        }

        // save Выражение as a ткст before any semantic expansion
        // if -checkaction=context is enabled an no message exists
        const generateMsg = !exp.msg && глоб2.парамы.checkAction == CHECKACTION.context;
        auto assertExpMsg = generateMsg ? exp.вТкст0() : null;

        if (Выражение ex = unaSemantic(exp, sc))
        {
            результат = ex;
            return;
        }
        exp.e1 = resolveProperties(sc, exp.e1);
        // BUG: see if we can do compile time elimination of the Assert
        exp.e1 = exp.e1.optimize(WANTvalue);
        exp.e1 = exp.e1.toBoolean(sc);

        if (generateMsg)
        // no message - use assert Выражение as msg
        {
            /*
            {
              auto a = e1, b = e2;
              assert(a == b, _d_assert_fail!"=="(a, b));
            }()
            */

            /*
            Stores the результат of an operand Выражение into a temporary
            if necessary, e.g. if it is an impure fuction call containing side
            effects as in https://issues.dlang.org/show_bug.cgi?ид=20114

            Параметры:
                op = an Выражение which may require a temporary and will be
                     replaced by `(auto tmp = op, tmp)` if necessary

            Возвращает: `op` or `tmp` for subsequent access to the possibly promoted operand
            */
            Выражение maybePromoteToTmp(ref Выражение op)
            {
                if (op.hasSideEffect)
                {
                    const stc = STC.exptemp | (op.isLvalue() ? STC.ref_ : STC.rvalue);
                    auto tmp = copyToTemp(stc, "__assertOp", op);
                    tmp.dsymbolSemantic(sc);

                    auto decl = new DeclarationExp(op.место, tmp);
                    auto var = new VarExp(op.место, tmp);
                    auto comb = Выражение.combine(decl, var);
                    op = comb.ВыражениеSemantic(sc);

                    return var;
                }
                return op;
            }

            const tok = exp.e1.op;
            бул isEqualsCallВыражение;
            if (tok == ТОК2.call)
            {
                const callExp = cast(CallExp) exp.e1;

                // https://issues.dlang.org/show_bug.cgi?ид=20331
                // callExp.f may be null if the assert содержит a call to
                // a function pointer or literal
                if(auto callExpFunc = callExp.f)
                {
                    const callExpIdent = callExpFunc.идент;
                    isEqualsCallВыражение = callExpIdent == Id.__equals ||
                                             callExpIdent == Id.eq;
                }
            }
            if (tok == ТОК2.equal || tok == ТОК2.notEqual ||
                tok == ТОК2.lessThan || tok == ТОК2.greaterThan ||
                tok == ТОК2.lessOrEqual || tok == ТОК2.greaterOrEqual ||
                tok == ТОК2.identity || tok == ТОК2.notIdentity ||
                tok == ТОК2.in_ ||
                isEqualsCallВыражение)
            {
                if (!verifyHookExist(exp.место, *sc, Id._d_assert_fail, "generating assert messages"))
                    return setError();

                auto es = new Выражения(2);
                auto tiargs = new Объекты(3);
                Место место = exp.e1.место;

                if (isEqualsCallВыражение)
                {
                    auto callExp = cast(CallExp) exp.e1;
                    auto args = callExp.arguments;

                    // template args
                    static const compMsg = "==";
                    Выражение comp = new StringExp(место, compMsg);
                    comp = comp.ВыражениеSemantic(sc);
                    (*tiargs)[0] = comp;

                    // structs with opEquals get rewritten to a DotVarExp:
                    // a.opEquals(b)
                    // https://issues.dlang.org/show_bug.cgi?ид=20100
                    if (args.length == 1)
                    {
                        auto dv = callExp.e1.isDotVarExp();
                        assert(dv);
                        (*tiargs)[1] = dv.e1.тип;
                        (*tiargs)[2] = (*args)[0].тип;

                        // runtime args
                        (*es)[0] = maybePromoteToTmp(dv.e1);
                        (*es)[1] = maybePromoteToTmp((*args)[0]);
                    }
                    else
                    {
                        (*tiargs)[1] = (*args)[0].тип;
                        (*tiargs)[2] = (*args)[1].тип;

                        // runtime args
                        (*es)[0] = maybePromoteToTmp((*args)[0]);
                        (*es)[1] = maybePromoteToTmp((*args)[1]);
                    }
                }
                else
                {
                    auto binExp = cast(EqualExp) exp.e1;

                    // template args
                    Выражение comp = new StringExp(место, Сема2.вТкст(exp.e1.op));
                    comp = comp.ВыражениеSemantic(sc);
                    (*tiargs)[0] = comp;
                    (*tiargs)[1] = binExp.e1.тип;
                    (*tiargs)[2] = binExp.e2.тип;

                    // runtime args
                    (*es)[0] = maybePromoteToTmp(binExp.e1);
                    (*es)[1] = maybePromoteToTmp(binExp.e2);
                }

                Выражение __assertFail = new IdentifierExp(exp.место, Id.empty);
                auto assertFail = new DotIdExp(место, __assertFail, Id.объект);

                auto dt = new DotTemplateInstanceExp(место, assertFail, Id._d_assert_fail, tiargs);
                auto ec = CallExp.создай(Место.initial, dt, es);
                exp.msg = ec;
            }
            else
            {
                БуфВыв буф;
                буф.printf("%s failed", assertExpMsg);
                exp.msg = new StringExp(Место.initial, буф.извлекиСрез());
            }
        }
        if (exp.msg)
        {
            exp.msg = ВыражениеSemantic(exp.msg, sc);
            exp.msg = resolveProperties(sc, exp.msg);
            exp.msg = exp.msg.implicitCastTo(sc, Тип.tchar.constOf().arrayOf());
            exp.msg = exp.msg.optimize(WANTvalue);
        }

        if (exp.e1.op == ТОК2.error)
        {
            результат = exp.e1;
            return;
        }
        if (exp.msg && exp.msg.op == ТОК2.error)
        {
            результат = exp.msg;
            return;
        }

        auto f1 = checkNonAssignmentArrayOp(exp.e1);
        auto f2 = exp.msg && checkNonAssignmentArrayOp(exp.msg);
        if (f1 || f2)
            return setError();

        if (exp.e1.isBool(нет))
        {
            /* This is an `assert(0)` which means halt program execution
             */
            FuncDeclaration fd = sc.родитель.isFuncDeclaration();
            if (fd)
                fd.hasReturnExp |= 4;
            sc.ctorflow.orCSX(CSX.halt);

            if (глоб2.парамы.useAssert == CHECKENABLE.off)
            {
                Выражение e = new HaltExp(exp.место);
                e = e.ВыражениеSemantic(sc);
                результат = e;
                return;
            }
        }
        exp.тип = Тип.tvoid;
        результат = exp;
    }

    override проц посети(DotIdExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("DotIdExp::semantic(this = %p, '%s')\n", exp, exp.вТкст0());
            //printf("e1.op = %d, '%s'\n", e1.op, Сема2::вТкст0(e1.op));
        }
        Выражение e = exp.semanticY(sc, 1);
        if (e && isDotOpDispatch(e))
        {
            бцел errors = глоб2.startGagging();
            e = resolvePropertiesX(sc, e);
            if (глоб2.endGagging(errors))
                e = null; /* fall down to UFCS */
            else
            {
                результат = e;
                return;
            }
        }
        if (!e) // if failed to найди the property
        {
            /* If идент is not a valid property, rewrite:
             *   e1.идент
             * as:
             *   .идент(e1)
             */
            e = resolveUFCSProperties(sc, exp);
        }
        результат = e;
    }

    override проц посети(DotTemplateExp e)
    {
        if (Выражение ex = unaSemantic(e, sc))
        {
            результат = ex;
            return;
        }
        результат = e;
    }

    override проц посети(DotVarExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("DotVarExp::semantic('%s')\n", exp.вТкст0());
        }
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        exp.var = exp.var.toAlias().isDeclaration();

        exp.e1 = exp.e1.ВыражениеSemantic(sc);

        if (auto tup = exp.var.isTupleDeclaration())
        {
            /* Replace:
             *  e1.кортеж(a, b, c)
             * with:
             *  кортеж(e1.a, e1.b, e1.c)
             */
            Выражение e0;
            Выражение ev = sc.func ? extractSideEffect(sc, "__tup", e0, exp.e1) : exp.e1;

            auto exps = new Выражения();
            exps.резервируй(tup.objects.dim);
            for (т_мера i = 0; i < tup.objects.dim; i++)
            {
                КорневойОбъект o = (*tup.objects)[i];
                Выражение e;
                if (o.динкаст() == ДИНКАСТ.Выражение)
                {
                    e = cast(Выражение)o;
                    if (e.op == ТОК2.dSymbol)
                    {
                        ДСимвол s = (cast(DsymbolExp)e).s;
                        e = new DotVarExp(exp.место, ev, s.isDeclaration());
                    }
                }
                else if (o.динкаст() == ДИНКАСТ.дсимвол)
                {
                    e = new DsymbolExp(exp.место, cast(ДСимвол)o);
                }
                else if (o.динкаст() == ДИНКАСТ.тип)
                {
                    e = new TypeExp(exp.место, cast(Тип)o);
                }
                else
                {
                    exp.выведиОшибку("`%s` is not an Выражение", o.вТкст0());
                    return setError();
                }
                exps.сунь(e);
            }

            Выражение e = new TupleExp(exp.место, e0, exps);
            e = e.ВыражениеSemantic(sc);
            результат = e;
            return;
        }

        exp.e1 = exp.e1.addDtorHook(sc);

        Тип t1 = exp.e1.тип;

        if (FuncDeclaration fd = exp.var.isFuncDeclaration())
        {
            // for functions, do checks after overload resolution
            if (!fd.functionSemantic())
                return setError();

            /* https://issues.dlang.org/show_bug.cgi?ид=13843
             * If fd obviously has no overloads, we should
             * normalize AST, and it will give a chance to wrap fd with FuncExp.
             */
            if ((fd.isNested() && !fd.isThis()) || fd.isFuncLiteralDeclaration())
            {
                // (e1, fd)
                auto e = symbolToExp(fd, exp.место, sc, нет);
                результат = Выражение.combine(exp.e1, e);
                return;
            }

            exp.тип = fd.тип;
            assert(exp.тип);
        }
        else if (OverDeclaration od = exp.var.isOverDeclaration())
        {
            exp.тип = Тип.tvoid; // ambiguous тип?
        }
        else
        {
            exp.тип = exp.var.тип;
            if (!exp.тип && глоб2.errors) // var is goofed up, just return error.
                return setError();
            assert(exp.тип);

            if (t1.ty == Tpointer)
                t1 = t1.nextOf();

            exp.тип = exp.тип.addMod(t1.mod);

            ДСимвол vparent = exp.var.toParent();
            AggregateDeclaration ad = vparent ? vparent.isAggregateDeclaration() : null;
            if (Выражение e1x = getRightThis(exp.место, sc, ad, exp.e1, exp.var, 1))
                exp.e1 = e1x;
            else
            {
                /* Later checkRightThis will report correct error for invalid field variable access.
                 */
                Выражение e = new VarExp(exp.место, exp.var);
                e = e.ВыражениеSemantic(sc);
                результат = e;
                return;
            }
            checkAccess(exp.место, sc, exp.e1, exp.var);

            VarDeclaration v = exp.var.isVarDeclaration();
            if (v && (v.isDataseg() || (v.класс_хранения & STC.manifest)))
            {
                Выражение e = expandVar(WANTvalue, v);
                if (e)
                {
                    результат = e;
                    return;
                }
            }

            if (v && (v.isDataseg() || // fix https://issues.dlang.org/show_bug.cgi?ид=8238
                      (!v.needThis() && v.semanticRun > PASS.init)))  // fix https://issues.dlang.org/show_bug.cgi?ид=17258
            {
                // (e1, v)
                checkAccess(exp.место, sc, exp.e1, v);
                Выражение e = new VarExp(exp.место, v);
                e = new CommaExp(exp.место, exp.e1, e);
                e = e.ВыражениеSemantic(sc);
                результат = e;
                return;
            }
        }
        //printf("-DotVarExp::semantic('%s')\n", вТкст0());
        результат = exp;
    }

    override проц посети(DotTemplateInstanceExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("DotTemplateInstanceExp::semantic('%s')\n", exp.вТкст0());
        }
        // Indicate we need to resolve by UFCS.
        Выражение e = exp.semanticY(sc, 1);
        if (!e)
            e = resolveUFCSProperties(sc, exp);
        результат = e;
    }

    override проц посети(DelegateExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("DelegateExp::semantic('%s')\n", e.вТкст0());
        }
        if (e.тип)
        {
            результат = e;
            return;
        }

        e.e1 = e.e1.ВыражениеSemantic(sc);

        e.тип = new TypeDelegate(e.func.тип);
        e.тип = e.тип.typeSemantic(e.место, sc);

        FuncDeclaration f = e.func.toAliasFunc();
        AggregateDeclaration ad = f.toParentLocal().isAggregateDeclaration();
        if (f.needThis())
            e.e1 = getRightThis(e.место, sc, ad, e.e1, f);
        if (e.e1.op == ТОК2.error)
            return setError();

        /* A delegate takes the address of e.e1 in order to set the .ptr field
         * https://issues.dlang.org/show_bug.cgi?ид=18575
         */
        if (глоб2.парамы.vsafe && e.e1.тип.toBasetype().ty == Tstruct)
        {
            if (auto v = expToVariable(e.e1))
            {
                if (!checkAddressVar(sc, e, v))
                    return setError();
            }
        }

        if (f.тип.ty == Tfunction)
        {
            TypeFunction tf = cast(TypeFunction)f.тип;
            if (!MODmethodConv(e.e1.тип.mod, f.тип.mod))
            {
                БуфВыв thisBuf, funcBuf;
                MODMatchToBuffer(&thisBuf, e.e1.тип.mod, tf.mod);
                MODMatchToBuffer(&funcBuf, tf.mod, e.e1.тип.mod);
                e.выведиОшибку("%smethod `%s` is not callable using a %s`%s`",
                    funcBuf.peekChars(), f.toPrettyChars(), thisBuf.peekChars(), e.e1.вТкст0());
                return setError();
            }
        }
        if (ad && ad.isClassDeclaration() && ad.тип != e.e1.тип)
        {
            // A downcast is required for interfaces
            // https://issues.dlang.org/show_bug.cgi?ид=3706
            e.e1 = new CastExp(e.место, e.e1, ad.тип);
            e.e1 = e.e1.ВыражениеSemantic(sc);
        }
        результат = e;
        // declare dual-context container
        if (f.isThis2 && !sc.intypeof && sc.func)
        {
            // check access to second `this`
            if (AggregateDeclaration ad2 = f.isMember2())
            {
                auto rez = new ThisExp(e.место);
                Выражение te = rez.ВыражениеSemantic(sc);
                if (te.op != ТОК2.error)
                    te = getRightThis(e.место, sc, ad2, te, f);
                if (te.op == ТОК2.error)
                {
                    e.выведиОшибку("need `this` of тип `%s` to make delegate from function `%s`", ad2.вТкст0(), f.вТкст0());
                    return setError();
                }
            }
            VarDeclaration vthis2 = makeThis2Argument(e.место, sc, f);
            e.vthis2 = vthis2;
            Выражение de = new DeclarationExp(e.место, vthis2);
            результат = Выражение.combine(de, результат);
            результат = результат.ВыражениеSemantic(sc);
        }
    }

    override проц посети(DotTypeExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("DotTypeExp::semantic('%s')\n", exp.вТкст0());
        }
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (auto e = unaSemantic(exp, sc))
        {
            результат = e;
            return;
        }

        exp.тип = exp.sym.getType().addMod(exp.e1.тип.mod);
        результат = exp;
    }

    override проц посети(AddrExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("AddrExp::semantic('%s')\n", exp.вТкст0());
        }
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (Выражение ex = unaSemantic(exp, sc))
        {
            результат = ex;
            return;
        }

        цел wasCond = exp.e1.op == ТОК2.question;

        if (exp.e1.op == ТОК2.dotTemplateInstance)
        {
            DotTemplateInstanceExp dti = cast(DotTemplateInstanceExp)exp.e1;
            TemplateInstance ti = dti.ti;
            {
                //assert(ti.needsTypeInference(sc));
                ti.dsymbolSemantic(sc);
                if (!ti.inst || ti.errors) // if template failed to expand
                    return setError();

                ДСимвол s = ti.toAlias();
                FuncDeclaration f = s.isFuncDeclaration();
                if (f)
                {
                    exp.e1 = new DotVarExp(exp.e1.место, dti.e1, f);
                    exp.e1 = exp.e1.ВыражениеSemantic(sc);
                }
            }
        }
        else if (exp.e1.op == ТОК2.scope_)
        {
            TemplateInstance ti = (cast(ScopeExp)exp.e1).sds.isTemplateInstance();
            if (ti)
            {
                //assert(ti.needsTypeInference(sc));
                ti.dsymbolSemantic(sc);
                if (!ti.inst || ti.errors) // if template failed to expand
                    return setError();

                ДСимвол s = ti.toAlias();
                FuncDeclaration f = s.isFuncDeclaration();
                if (f)
                {
                    exp.e1 = new VarExp(exp.e1.место, f);
                    exp.e1 = exp.e1.ВыражениеSemantic(sc);
                }
            }
        }
        /* https://issues.dlang.org/show_bug.cgi?ид=809
         *
         * If the address of a lazy variable is taken,
         * the Выражение is rewritten so that the тип
         * of it is the delegate тип. This means that
         * the symbol is not going to represent a call
         * to the delegate anymore, but rather, the
         * actual symbol.
         */
        if (auto ve = exp.e1.isVarExp())
        {
            if (ve.var.класс_хранения & STC.lazy_)
            {
                exp.e1 = exp.e1.ВыражениеSemantic(sc);
                exp.e1 = resolveProperties(sc, exp.e1);
                if (auto callExp = exp.e1.isCallExp())
                {
                    if (callExp.e1.тип.toBasetype().ty == Tdelegate)
                    {
                        /* https://issues.dlang.org/show_bug.cgi?ид=20551
                         *
                         * Cannot take address of lazy параметр in  code
                         * because it might end up being a pointer to undefined
                         * memory.
                         */
                        if (sc.func && !sc.intypeof && !(sc.flags & SCOPE.debug_) && sc.func.setUnsafe())
                        {
                            exp.выведиОшибку("cannot take address of lazy параметр `%s` in `` function `%s`",
                                     ve.вТкст0(), sc.func.вТкст0());
                            setError();
                        }
                        else
                        {
                            VarExp ve2 = callExp.e1.isVarExp();
                            ve2.delegateWasExtracted = да;
                            ve2.var.класс_хранения |= STC.scope_;
                            результат = ve2;
                        }
                        return;
                    }
                }
            }
        }

        exp.e1 = exp.e1.toLvalue(sc, null);
        if (exp.e1.op == ТОК2.error)
        {
            результат = exp.e1;
            return;
        }
        if (checkNonAssignmentArrayOp(exp.e1))
            return setError();

        if (!exp.e1.тип)
        {
            exp.выведиОшибку("cannot take address of `%s`", exp.e1.вТкст0());
            return setError();
        }

        бул hasOverloads;
        if (auto f = isFuncAddress(exp, &hasOverloads))
        {
            if (!hasOverloads && f.checkForwardRef(exp.место))
                return setError();
        }
        else if (!exp.e1.тип.deco)
        {
            if (exp.e1.op == ТОК2.variable)
            {
                VarExp ve = cast(VarExp)exp.e1;
                Declaration d = ve.var;
                exp.выведиОшибку("forward reference to %s `%s`", d.вид(), d.вТкст0());
            }
            else
                exp.выведиОшибку("forward reference to `%s`", exp.e1.вТкст0());
            return setError();
        }

        exp.тип = exp.e1.тип.pointerTo();

        // See if this should really be a delegate
        if (exp.e1.op == ТОК2.dotVariable)
        {
            DotVarExp dve = cast(DotVarExp)exp.e1;
            FuncDeclaration f = dve.var.isFuncDeclaration();
            if (f)
            {
                f = f.toAliasFunc(); // FIXME, should see overloads
                                     // https://issues.dlang.org/show_bug.cgi?ид=1983
                if (!dve.hasOverloads)
                    f.tookAddressOf++;

                Выражение e;
                if (f.needThis())
                    e = new DelegateExp(exp.место, dve.e1, f, dve.hasOverloads);
                else // It is a function pointer. Convert &v.f() --> (v, &V.f())
                    e = new CommaExp(exp.место, dve.e1, new AddrExp(exp.место, new VarExp(exp.место, f, dve.hasOverloads)));
                e = e.ВыражениеSemantic(sc);
                результат = e;
                return;
            }

            // Look for misaligned pointer in  mode
            if (checkUnsafeAccess(sc, dve, !exp.тип.isMutable(), да))
                return setError();

            if (глоб2.парамы.vsafe)
            {
                if (VarDeclaration v = expToVariable(dve.e1))
                {
                    if (!checkAddressVar(sc, exp, v))
                        return setError();
                }
            }
        }
        else if (exp.e1.op == ТОК2.variable)
        {
            VarExp ve = cast(VarExp)exp.e1;
            VarDeclaration v = ve.var.isVarDeclaration();
            if (v)
            {
                if (!checkAddressVar(sc, exp, v))
                    return setError();

                ve.checkPurity(sc, v);
            }
            FuncDeclaration f = ve.var.isFuncDeclaration();
            if (f)
            {
                /* Because nested functions cannot be overloaded,
                 * mark here that we took its address because castTo()
                 * may not be called with an exact match.
                 */
                if (!ve.hasOverloads || (f.isNested() && !f.needThis()))
                    f.tookAddressOf++;
                if (f.isNested() && !f.needThis())
                {
                    if (f.isFuncLiteralDeclaration())
                    {
                        if (!f.FuncDeclaration.isNested())
                        {
                            /* Supply a 'null' for a this pointer if no this is доступно
                             */
                            Выражение e = new DelegateExp(exp.место, new NullExp(exp.место, Тип.tnull), f, ve.hasOverloads);
                            e = e.ВыражениеSemantic(sc);
                            результат = e;
                            return;
                        }
                    }
                    Выражение e = new DelegateExp(exp.место, exp.e1, f, ve.hasOverloads);
                    e = e.ВыражениеSemantic(sc);
                    результат = e;
                    return;
                }
                if (f.needThis())
                {
                    if (hasThis(sc))
                    {
                        /* Should probably supply 'this' after overload resolution,
                         * not before.
                         */
                        Выражение ethis = new ThisExp(exp.место);
                        Выражение e = new DelegateExp(exp.место, ethis, f, ve.hasOverloads);
                        e = e.ВыражениеSemantic(sc);
                        результат = e;
                        return;
                    }
                    if (sc.func && !sc.intypeof)
                    {
                        if (!(sc.flags & SCOPE.debug_) && sc.func.setUnsafe())
                        {
                            exp.выведиОшибку("`this` reference necessary to take address of member `%s` in `` function `%s`", f.вТкст0(), sc.func.вТкст0());
                        }
                    }
                }
            }
        }
        else if ((exp.e1.op == ТОК2.this_ || exp.e1.op == ТОК2.super_) && глоб2.парамы.vsafe)
        {
            if (VarDeclaration v = expToVariable(exp.e1))
            {
                if (!checkAddressVar(sc, exp, v))
                    return setError();
            }
        }
        else if (exp.e1.op == ТОК2.call)
        {
            CallExp ce = cast(CallExp)exp.e1;
            if (ce.e1.тип.ty == Tfunction)
            {
                TypeFunction tf = cast(TypeFunction)ce.e1.тип;
                if (tf.isref && sc.func && !sc.intypeof && !(sc.flags & SCOPE.debug_) && sc.func.setUnsafe())
                {
                    exp.выведиОшибку("cannot take address of `ref return` of `%s()` in `` function `%s`",
                        ce.e1.вТкст0(), sc.func.вТкст0());
                }
            }
        }
        else if (exp.e1.op == ТОК2.index)
        {
            /* For:
             *   цел[3] a;
             *   &a[i]
             * check 'a' the same as for a regular variable
             */
            if (VarDeclaration v = expToVariable(exp.e1))
            {
                if (глоб2.парамы.vsafe && !checkAddressVar(sc, exp, v))
                    return setError();

                exp.e1.checkPurity(sc, v);
            }
        }
        else if (wasCond)
        {
            /* a ? b : c was transformed to *(a ? &b : &c), but we still
             * need to do safety checks
             */
            assert(exp.e1.op == ТОК2.star);
            PtrExp pe = cast(PtrExp)exp.e1;
            assert(pe.e1.op == ТОК2.question);
            CondExp ce = cast(CondExp)pe.e1;
            assert(ce.e1.op == ТОК2.address);
            assert(ce.e2.op == ТОК2.address);

            // Re-run semantic on the address Выражения only
            ce.e1.тип = null;
            ce.e1 = ce.e1.ВыражениеSemantic(sc);
            ce.e2.тип = null;
            ce.e2 = ce.e2.ВыражениеSemantic(sc);
        }
        результат = exp.optimize(WANTvalue);
    }

    override проц посети(PtrExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("PtrExp::semantic('%s')\n", exp.вТкст0());
        }
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        Тип tb = exp.e1.тип.toBasetype();
        switch (tb.ty)
        {
        case Tpointer:
            exp.тип = (cast(TypePointer)tb).следщ;
            break;

        case Tsarray:
        case Tarray:
            if (isNonAssignmentArrayOp(exp.e1))
                goto default;
            exp.выведиОшибку("using `*` on an массив is no longer supported; use `*(%s).ptr` instead", exp.e1.вТкст0());
            exp.тип = (cast(TypeArray)tb).следщ;
            exp.e1 = exp.e1.castTo(sc, exp.тип.pointerTo());
            break;

        case Terror:
            return setError();

        default:
            exp.выведиОшибку("can only `*` a pointer, not a `%s`", exp.e1.тип.вТкст0());
            goto case Terror;
        }

        if (exp.checkValue() || exp.checkSharedAccess(sc))
            return setError();

        результат = exp;
    }

    override проц посети(NegExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("NegExp::semantic('%s')\n", exp.вТкст0());
        }
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        fix16997(sc, exp);
        exp.тип = exp.e1.тип;
        Тип tb = exp.тип.toBasetype();
        if (tb.ty == Tarray || tb.ty == Tsarray)
        {
            if (!isArrayOpValid(exp.e1))
            {
                результат = arrayOpInvalidError(exp);
                return;
            }
            результат = exp;
            return;
        }
        if (!target.isVectorOpSupported(tb, exp.op))
        {
            результат = exp.incompatibleTypes();
            return;
        }
        if (exp.e1.checkNoBool())
            return setError();
        if (exp.e1.checkArithmetic() ||
            exp.e1.checkSharedAccess(sc))
            return setError();

        результат = exp;
    }

    override проц посети(UAddExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("UAddExp::semantic('%s')\n", exp.вТкст0());
        }
        assert(!exp.тип);

        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        fix16997(sc, exp);
        if (!target.isVectorOpSupported(exp.e1.тип.toBasetype(), exp.op))
        {
            результат = exp.incompatibleTypes();
            return;
        }
        if (exp.e1.checkNoBool())
            return setError();
        if (exp.e1.checkArithmetic())
            return setError();
        if (exp.e1.checkSharedAccess(sc))
            return setError();

        результат = exp.e1;
    }

    override проц посети(ComExp exp)
    {
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        fix16997(sc, exp);
        exp.тип = exp.e1.тип;
        Тип tb = exp.тип.toBasetype();
        if (tb.ty == Tarray || tb.ty == Tsarray)
        {
            if (!isArrayOpValid(exp.e1))
            {
                результат = arrayOpInvalidError(exp);
                return;
            }
            результат = exp;
            return;
        }
        if (!target.isVectorOpSupported(tb, exp.op))
        {
            результат = exp.incompatibleTypes();
            return;
        }
        if (exp.e1.checkNoBool())
            return setError();
        if (exp.e1.checkIntegral() ||
            exp.e1.checkSharedAccess(sc))
            return setError();

        результат = exp;
    }

    override проц посети(NotExp e)
    {
        if (e.тип)
        {
            результат = e;
            return;
        }

        e.setNoderefOperand();

        // Note there is no operator overload
        if (Выражение ex = unaSemantic(e, sc))
        {
            результат = ex;
            return;
        }

        // for static alias this: https://issues.dlang.org/show_bug.cgi?ид=17684
        if (e.e1.op == ТОК2.тип)
            e.e1 = resolveAliasThis(sc, e.e1);

        e.e1 = resolveProperties(sc, e.e1);
        e.e1 = e.e1.toBoolean(sc);
        if (e.e1.тип == Тип.terror)
        {
            результат = e.e1;
            return;
        }

        if (!target.isVectorOpSupported(e.e1.тип.toBasetype(), e.op))
        {
            результат = e.incompatibleTypes();
        }
        // https://issues.dlang.org/show_bug.cgi?ид=13910
        // Today NotExp can take an массив as its operand.
        if (checkNonAssignmentArrayOp(e.e1))
            return setError();

        e.тип = Тип.tбул;
        результат = e;
    }

    override проц посети(DeleteExp exp)
    {
        if (!sc.isDeprecated)
        {
            // @@@DEPRECATED_2019-02@@@
            // 1. Deprecation for 1 year
            // 2. Error for 1 year
            // 3. Removal of keyword, "delete" can be используется for other identities
            if (!exp.isRAII)
                deprecation(exp.место, "The `delete` keyword has been deprecated.  Use `объект.разрушь()` (and `core.memory.СМ.free()` if applicable) instead.");
        }

        if (Выражение ex = unaSemantic(exp, sc))
        {
            результат = ex;
            return;
        }
        exp.e1 = resolveProperties(sc, exp.e1);
        exp.e1 = exp.e1.modifiableLvalue(sc, null);
        if (exp.e1.op == ТОК2.error)
        {
            результат = exp.e1;
            return;
        }
        exp.тип = Тип.tvoid;

        AggregateDeclaration ad = null;
        Тип tb = exp.e1.тип.toBasetype();
        switch (tb.ty)
        {
        case Tclass:
            {
                auto cd = (cast(TypeClass)tb).sym;
                if (cd.isCOMinterface())
                {
                    /* Because COM classes are deleted by IUnknown.Release()
                     */
                    exp.выведиОшибку("cannot `delete` instance of COM interface `%s`", cd.вТкст0());
                    return setError();
                }
                ad = cd;
                break;
            }
        case Tpointer:
            tb = (cast(TypePointer)tb).следщ.toBasetype();
            if (tb.ty == Tstruct)
            {
                ad = (cast(TypeStruct)tb).sym;
                semanticTypeInfo(sc, tb);
            }
            break;

        case Tarray:
            {
                Тип tv = tb.nextOf().baseElemOf();
                if (tv.ty == Tstruct)
                {
                    ad = (cast(TypeStruct)tv).sym;
                    if (ad.dtor)
                        semanticTypeInfo(sc, ad.тип);
                }
                break;
            }
        default:
            exp.выведиОшибку("cannot delete тип `%s`", exp.e1.тип.вТкст0());
            return setError();
        }

        бул err = нет;
        if (ad)
        {
            if (ad.dtor)
            {
                err |= exp.checkPurity(sc, ad.dtor);
                err |= exp.checkSafety(sc, ad.dtor);
                err |= exp.checkNogc(sc, ad.dtor);
            }
            if (err)
                return setError();
        }

        if (!sc.intypeof && sc.func &&
            !exp.isRAII &&
            !(sc.flags & SCOPE.debug_) &&
            sc.func.setUnsafe())
        {
            exp.выведиОшибку("`%s` is not `` but is используется in `` function `%s`", exp.вТкст0(), sc.func.вТкст0());
            err = да;
        }
        if (err)
            return setError();

        результат = exp;
    }

    override проц посети(CastExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("CastExp::semantic('%s')\n", exp.вТкст0());
        }
        //static цел x; assert(++x < 10);
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (exp.to)
        {
            exp.to = exp.to.typeSemantic(exp.место, sc);
            if (exp.to == Тип.terror)
                return setError();

            if (!exp.to.hasPointers())
                exp.setNoderefOperand();

            // When e1 is a template lambda, this cast may instantiate it with
            // the тип 'to'.
            exp.e1 = inferType(exp.e1, exp.to);
        }

        if (auto e = unaSemantic(exp, sc))
        {
            результат = e;
            return;
        }

        // for static alias this: https://issues.dlang.org/show_bug.cgi?ид=17684
        if (exp.e1.op == ТОК2.тип)
            exp.e1 = resolveAliasThis(sc, exp.e1);

        auto e1x = resolveProperties(sc, exp.e1);
        if (e1x.op == ТОК2.error)
        {
            результат = e1x;
            return;
        }
        if (e1x.checkType())
            return setError();
        exp.e1 = e1x;

        if (!exp.e1.тип)
        {
            exp.выведиОшибку("cannot cast `%s`", exp.e1.вТкст0());
            return setError();
        }

        // https://issues.dlang.org/show_bug.cgi?ид=19954
        if (exp.e1.тип.ty == Ttuple)
        {
            TupleExp te = exp.e1.isTupleExp();
            if (te.exps.dim == 1)
                exp.e1 = (*te.exps)[0];
        }

        // only allow S(x) rewrite if cast specified S explicitly.
        // See https://issues.dlang.org/show_bug.cgi?ид=18545
        const бул allowImplicitConstruction = exp.to !is null;

        if (!exp.to) // Handle cast(const) and cast(const), etc.
        {
            exp.to = exp.e1.тип.castMod(exp.mod);
            exp.to = exp.to.typeSemantic(exp.место, sc);

            if (exp.to == Тип.terror)
                return setError();
        }

        if (exp.to.ty == Ttuple)
        {
            exp.выведиОшибку("cannot cast `%s` to кортеж тип `%s`", exp.e1.вТкст0(), exp.to.вТкст0());
            return setError();
        }

        // cast(проц) is используется to mark e1 as unused, so it is safe
        if (exp.to.ty == Tvoid)
        {
            exp.тип = exp.to;
            результат = exp;
            return;
        }

        if (!exp.to.равен(exp.e1.тип) && exp.mod == cast(ббайт)~0)
        {
            if (Выражение e = exp.op_overload(sc))
            {
                результат = e.implicitCastTo(sc, exp.to);
                return;
            }
        }

        Тип t1b = exp.e1.тип.toBasetype();
        Тип tob = exp.to.toBasetype();

        if (allowImplicitConstruction && tob.ty == Tstruct && !tob.равен(t1b))
        {
            /* Look to replace:
             *  cast(S)t
             * with:
             *  S(t)
             */

            // Rewrite as to.call(e1)
            Выражение e = new TypeExp(exp.место, exp.to);
            e = new CallExp(exp.место, e, exp.e1);
            e = e.trySemantic(sc);
            if (e)
            {
                результат = e;
                return;
            }
        }

        if (!t1b.равен(tob) && (t1b.ty == Tarray || t1b.ty == Tsarray))
        {
            if (checkNonAssignmentArrayOp(exp.e1))
                return setError();
        }

        // Look for casting to a vector тип
        if (tob.ty == Tvector && t1b.ty != Tvector)
        {
            результат = new VectorExp(exp.место, exp.e1, exp.to);
            результат = результат.ВыражениеSemantic(sc);
            return;
        }

        Выражение ex = exp.e1.castTo(sc, exp.to);
        if (ex.op == ТОК2.error)
        {
            результат = ex;
            return;
        }

        // Check for unsafe casts
        if (!sc.intypeof &&
            !(sc.flags & SCOPE.debug_) &&
            !isSafeCast(ex, t1b, tob) &&
            (!sc.func && sc.stc & STC.safe || sc.func && sc.func.setUnsafe()))
        {
            exp.выведиОшибку("cast from `%s` to `%s` not allowed in safe code", exp.e1.тип.вТкст0(), exp.to.вТкст0());
            return setError();
        }

        // `объект.__МассивCast` is a rewrite of an old runtime hook `_d_arraycast`. `_d_arraycast` was not built
        // to handle certain casts.  Those casts which `объект.__МассивCast` does not support are filtered out.
        // See `e2ir.toElemCast` for other types of casts.  If `объект.__МассивCast` is improved to support more
        // casts these conditions and potentially some logic in `e2ir.toElemCast` can be removed.
        if (tob.ty == Tarray)
        {
            // https://issues.dlang.org/show_bug.cgi?ид=19840
            if (auto ad = isAggregate(t1b))
            {
                if (ad.aliasthis)
                {
                    Выражение e = resolveAliasThis(sc, exp.e1);
                    e = new CastExp(exp.место, e, exp.to);
                    результат = e.ВыражениеSemantic(sc);
                    return;
                }
            }

            if(t1b.ty == Tarray && exp.e1.op != ТОК2.arrayLiteral && (sc.flags & SCOPE.ctfe) == 0)
            {
                auto tFrom = t1b.nextOf();
                auto tTo = tob.nextOf();

                // https://issues.dlang.org/show_bug.cgi?ид=19954
                if (exp.e1.op != ТОК2.string_ || tTo.ty == Tarray)
                {
                    const бцел fromSize = cast(бцел)tFrom.size();
                    const бцел toSize = cast(бцел)tTo.size();

                    // If массив element sizes do not match, we must adjust the dimensions
                    if (fromSize != toSize)
                    {
                        if (!verifyHookExist(exp.место, *sc, Id.__МассивCast, "casting массив of structs"))
                            return setError();

                        // A runtime check is needed in case arrays don't line up.  That check should
                        // be done in the implementation of `объект.__МассивCast`
                        if (toSize == 0 || (fromSize % toSize) != 0)
                        {
                            // lower to `объект.__МассивCast!(TFrom, TTo)(from)`

                            // fully qualify as `объект.__МассивCast`
                            Выражение ид = new IdentifierExp(exp.место, Id.empty);
                            auto dotid = new DotIdExp(exp.место, ид, Id.объект);

                            auto tiargs = new Объекты();
                            tiargs.сунь(tFrom);
                            tiargs.сунь(tTo);
                            auto dt = new DotTemplateInstanceExp(exp.место, dotid, Id.__МассивCast, tiargs);

                            auto arguments = new Выражения();
                            arguments.сунь(exp.e1);
                            Выражение ce = new CallExp(exp.место, dt, arguments);

                            результат = ВыражениеSemantic(ce, sc);
                            return;
                        }
                    }
                }
            }
        }

        результат = ex;
    }

    override проц посети(VectorExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("VectorExp::semantic('%s')\n", exp.вТкст0());
        }
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        exp.e1 = exp.e1.ВыражениеSemantic(sc);
        exp.тип = exp.to.typeSemantic(exp.место, sc);
        if (exp.e1.op == ТОК2.error || exp.тип.ty == Terror)
        {
            результат = exp.e1;
            return;
        }

        Тип tb = exp.тип.toBasetype();
        assert(tb.ty == Tvector);
        TypeVector tv = cast(TypeVector)tb;
        Тип te = tv.elementType();
        exp.dim = cast(цел)(tv.size(exp.место) / te.size(exp.место));

        бул checkElem(Выражение elem)
        {
            if (elem.isConst() == 1)
                return нет;

             exp.выведиОшибку("constant Выражение expected, not `%s`", elem.вТкст0());
             return да;
        }

        exp.e1 = exp.e1.optimize(WANTvalue);
        бул res;
        if (exp.e1.op == ТОК2.arrayLiteral)
        {
            foreach (i; new бцел[0 .. exp.dim])
            {
                // Do not stop on first error - check all AST nodes even if error found
                res |= checkElem(exp.e1.isArrayLiteralExp()[i]);
            }
        }
        else if (exp.e1.тип.ty == Tvoid)
            checkElem(exp.e1);

        результат = res ? new ErrorExp() : exp;
    }

    override проц посети(VectorArrayExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("VectorArrayExp::semantic('%s')\n", e.вТкст0());
        }
        if (!e.тип)
        {
            unaSemantic(e, sc);
            e.e1 = resolveProperties(sc, e.e1);

            if (e.e1.op == ТОК2.error)
            {
                результат = e.e1;
                return;
            }
            assert(e.e1.тип.ty == Tvector);
            e.тип = e.e1.тип.isTypeVector().basetype;
        }
        результат = e;
    }

    override проц посети(SliceExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("SliceExp::semantic('%s')\n", exp.вТкст0());
        }
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        // operator overloading should be handled in ArrayExp already.
        if (Выражение ex = unaSemantic(exp, sc))
        {
            результат = ex;
            return;
        }
        exp.e1 = resolveProperties(sc, exp.e1);
        if (exp.e1.op == ТОК2.тип && exp.e1.тип.ty != Ttuple)
        {
            if (exp.lwr || exp.upr)
            {
                exp.выведиОшибку("cannot slice тип `%s`", exp.e1.вТкст0());
                return setError();
            }
            Выражение e = new TypeExp(exp.место, exp.e1.тип.arrayOf());
            результат = e.ВыражениеSemantic(sc);
            return;
        }
        if (!exp.lwr && !exp.upr)
        {
            if (exp.e1.op == ТОК2.arrayLiteral)
            {
                // Convert [a,b,c][] to [a,b,c]
                Тип t1b = exp.e1.тип.toBasetype();
                Выражение e = exp.e1;
                if (t1b.ty == Tsarray)
                {
                    e = e.копируй();
                    e.тип = t1b.nextOf().arrayOf();
                }
                результат = e;
                return;
            }
            if (exp.e1.op == ТОК2.slice)
            {
                // Convert e[][] to e[]
                SliceExp se = cast(SliceExp)exp.e1;
                if (!se.lwr && !se.upr)
                {
                    результат = se;
                    return;
                }
            }
            if (isArrayOpOperand(exp.e1))
            {
                // Convert (a[]+b[])[] to a[]+b[]
                результат = exp.e1;
                return;
            }
        }
        if (exp.e1.op == ТОК2.error)
        {
            результат = exp.e1;
            return;
        }
        if (exp.e1.тип.ty == Terror)
            return setError();

        Тип t1b = exp.e1.тип.toBasetype();
        if (t1b.ty == Tpointer)
        {
            if ((cast(TypePointer)t1b).следщ.ty == Tfunction)
            {
                exp.выведиОшибку("cannot slice function pointer `%s`", exp.e1.вТкст0());
                return setError();
            }
            if (!exp.lwr || !exp.upr)
            {
                exp.выведиОшибку("need upper and lower bound to slice pointer");
                return setError();
            }
            if (sc.func && !sc.intypeof && !(sc.flags & SCOPE.debug_) && sc.func.setUnsafe())
            {
                exp.выведиОшибку("pointer slicing not allowed in safe functions");
                return setError();
            }
        }
        else if (t1b.ty == Tarray)
        {
        }
        else if (t1b.ty == Tsarray)
        {
            if (!exp.arrayop && глоб2.парамы.vsafe)
            {
                /* Slicing a static массив is like taking the address of it.
                 * Perform checks as if e[] was &e
                 */
                if (VarDeclaration v = expToVariable(exp.e1))
                {
                    if (exp.e1.op == ТОК2.dotVariable)
                    {
                        DotVarExp dve = cast(DotVarExp)exp.e1;
                        if ((dve.e1.op == ТОК2.this_ || dve.e1.op == ТОК2.super_) &&
                            !(v.класс_хранения & STC.ref_))
                        {
                            // because it's a class
                            v = null;
                        }
                    }

                    if (v && !checkAddressVar(sc, exp, v))
                        return setError();
                }
            }
        }
        else if (t1b.ty == Ttuple)
        {
            if (!exp.lwr && !exp.upr)
            {
                результат = exp.e1;
                return;
            }
            if (!exp.lwr || !exp.upr)
            {
                exp.выведиОшибку("need upper and lower bound to slice кортеж");
                return setError();
            }
        }
        else if (t1b.ty == Tvector)
        {
            // Convert e1 to corresponding static массив
            TypeVector tv1 = cast(TypeVector)t1b;
            t1b = tv1.basetype;
            t1b = t1b.castMod(tv1.mod);
            exp.e1.тип = t1b;
        }
        else
        {
            exp.выведиОшибку("`%s` cannot be sliced with `[]`", t1b.ty == Tvoid ? exp.e1.вТкст0() : t1b.вТкст0());
            return setError();
        }

        /* Run semantic on lwr and upr.
         */
        Scope* scx = sc;
        if (t1b.ty == Tsarray || t1b.ty == Tarray || t1b.ty == Ttuple)
        {
            // Create scope for 'length' variable
            ScopeDsymbol sym = new ArrayScopeSymbol(sc, exp);
            sym.родитель = sc.scopesym;
            sc = sc.сунь(sym);
        }
        if (exp.lwr)
        {
            if (t1b.ty == Ttuple)
                sc = sc.startCTFE();
            exp.lwr = exp.lwr.ВыражениеSemantic(sc);
            exp.lwr = resolveProperties(sc, exp.lwr);
            if (t1b.ty == Ttuple)
                sc = sc.endCTFE();
            exp.lwr = exp.lwr.implicitCastTo(sc, Тип.tт_мера);
        }
        if (exp.upr)
        {
            if (t1b.ty == Ttuple)
                sc = sc.startCTFE();
            exp.upr = exp.upr.ВыражениеSemantic(sc);
            exp.upr = resolveProperties(sc, exp.upr);
            if (t1b.ty == Ttuple)
                sc = sc.endCTFE();
            exp.upr = exp.upr.implicitCastTo(sc, Тип.tт_мера);
        }
        if (sc != scx)
            sc = sc.вынь();
        if (exp.lwr && exp.lwr.тип == Тип.terror || exp.upr && exp.upr.тип == Тип.terror)
            return setError();

        if (t1b.ty == Ttuple)
        {
            exp.lwr = exp.lwr.ctfeInterpret();
            exp.upr = exp.upr.ctfeInterpret();
            uinteger_t i1 = exp.lwr.toUInteger();
            uinteger_t i2 = exp.upr.toUInteger();

            TupleExp te;
            КортежТипов tup;
            т_мера length;
            if (exp.e1.op == ТОК2.кортеж) // slicing an Выражение кортеж
            {
                te = cast(TupleExp)exp.e1;
                tup = null;
                length = te.exps.dim;
            }
            else if (exp.e1.op == ТОК2.тип) // slicing a тип кортеж
            {
                te = null;
                tup = cast(КортежТипов)t1b;
                length = Параметр2.dim(tup.arguments);
            }
            else
                assert(0);

            if (i2 < i1 || length < i2)
            {
                exp.выведиОшибку("ткст slice `[%llu .. %llu]` is out of bounds", i1, i2);
                return setError();
            }

            т_мера j1 = cast(т_мера)i1;
            т_мера j2 = cast(т_мера)i2;
            Выражение e;
            if (exp.e1.op == ТОК2.кортеж)
            {
                auto exps = new Выражения(j2 - j1);
                for (т_мера i = 0; i < j2 - j1; i++)
                {
                    (*exps)[i] = (*te.exps)[j1 + i];
                }
                e = new TupleExp(exp.место, te.e0, exps);
            }
            else
            {
                auto args = new Параметры();
                args.резервируй(j2 - j1);
                for (т_мера i = j1; i < j2; i++)
                {
                    Параметр2 arg = Параметр2.getNth(tup.arguments, i);
                    args.сунь(arg);
                }
                e = new TypeExp(exp.e1.место, new КортежТипов(args));
            }
            e = e.ВыражениеSemantic(sc);
            результат = e;
            return;
        }

        exp.тип = t1b.nextOf().arrayOf();
        // Allow typedef[] -> typedef[]
        if (exp.тип.равен(t1b))
            exp.тип = exp.e1.тип;

        // We might know $ now
        setLengthVarIfKnown(exp.lengthVar, t1b);

        if (exp.lwr && exp.upr)
        {
            exp.lwr = exp.lwr.optimize(WANTvalue);
            exp.upr = exp.upr.optimize(WANTvalue);

            IntRange lwrRange = getIntRange(exp.lwr);
            IntRange uprRange = getIntRange(exp.upr);

            if (t1b.ty == Tsarray || t1b.ty == Tarray)
            {
                Выражение el = new ArrayLengthExp(exp.место, exp.e1);
                el = el.ВыражениеSemantic(sc);
                el = el.optimize(WANTvalue);
                if (el.op == ТОК2.int64)
                {
                    // МассивДРК length is known at compile-time. Upper is in bounds if it fits length.
                    dinteger_t length = el.toInteger();
                    auto bounds = IntRange(SignExtendedNumber(0), SignExtendedNumber(length));
                    exp.upperIsInBounds = bounds.содержит(uprRange);
                }
                else if (exp.upr.op == ТОК2.int64 && exp.upr.toInteger() == 0)
                {
                    // Upper slice Выражение is '0'. Значение is always in bounds.
                    exp.upperIsInBounds = да;
                }
                else if (exp.upr.op == ТОК2.variable && (cast(VarExp)exp.upr).var.идент == Id.dollar)
                {
                    // Upper slice Выражение is '$'. Значение is always in bounds.
                    exp.upperIsInBounds = да;
                }
            }
            else if (t1b.ty == Tpointer)
            {
                exp.upperIsInBounds = да;
            }
            else
                assert(0);

            exp.lowerIsLessThanUpper = (lwrRange.imax <= uprRange.imin);

            //printf("upperIsInBounds = %d lowerIsLessThanUpper = %d\n", exp.upperIsInBounds, exp.lowerIsLessThanUpper);
        }

        результат = exp;
    }

    override проц посети(ArrayLengthExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("ArrayLengthExp::semantic('%s')\n", e.вТкст0());
        }
        if (e.тип)
        {
            результат = e;
            return;
        }

        if (Выражение ex = unaSemantic(e, sc))
        {
            результат = ex;
            return;
        }
        e.e1 = resolveProperties(sc, e.e1);

        e.тип = Тип.tт_мера;
        результат = e;
    }

    override проц посети(ArrayExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("ArrayExp::semantic('%s')\n", exp.вТкст0());
        }
        assert(!exp.тип);
        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        if (isAggregate(exp.e1.тип))
            exp.выведиОшибку("no `[]` operator overload for тип `%s`", exp.e1.тип.вТкст0());
        else if (exp.e1.op == ТОК2.тип && exp.e1.тип.ty != Ttuple)
            exp.выведиОшибку("static массив of `%s` with multiple lengths not allowed", exp.e1.тип.вТкст0());
        else if (isIndexableNonAggregate(exp.e1.тип))
            exp.выведиОшибку("only one index allowed to index `%s`", exp.e1.тип.вТкст0());
        else
            exp.выведиОшибку("cannot use `[]` operator on Выражение of тип `%s`", exp.e1.тип.вТкст0());

        результат = new ErrorExp();
    }

    override проц посети(DotExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("DotExp::semantic('%s')\n", exp.вТкст0());
            if (exp.тип)
                printf("\ttype = %s\n", exp.тип.вТкст0());
        }
        exp.e1 = exp.e1.ВыражениеSemantic(sc);
        exp.e2 = exp.e2.ВыражениеSemantic(sc);

        if (exp.e1.op == ТОК2.тип)
        {
            результат = exp.e2;
            return;
        }
        if (exp.e2.op == ТОК2.тип)
        {
            результат = exp.e2;
            return;
        }
        if (exp.e2.op == ТОК2.template_)
        {
            auto td = (cast(TemplateExp)exp.e2).td;
            Выражение e = new DotTemplateExp(exp.место, exp.e1, td);
            результат = e.ВыражениеSemantic(sc);
            return;
        }
        if (!exp.тип || exp.e1.op == ТОК2.this_)
            exp.тип = exp.e2.тип;
        результат = exp;
    }

    override проц посети(CommaExp e)
    {
        if (e.тип)
        {
            результат = e;
            return;
        }

        // Allow `((a,b),(x,y))`
        if (e.allowCommaExp)
        {
            CommaExp.allow(e.e1);
            CommaExp.allow(e.e2);
        }

        if (Выражение ex = binSemanticProp(e, sc))
        {
            результат = ex;
            return;
        }
        e.e1 = e.e1.addDtorHook(sc);

        if (checkNonAssignmentArrayOp(e.e1))
            return setError();

        e.тип = e.e2.тип;
        if (e.тип !is Тип.tvoid && !e.allowCommaExp && !e.isGenerated)
            e.выведиОшибку("Using the результат of a comma Выражение is not allowed");
        результат = e;
    }

    override проц посети(IntervalExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("IntervalExp::semantic('%s')\n", e.вТкст0());
        }
        if (e.тип)
        {
            результат = e;
            return;
        }

        Выражение le = e.lwr;
        le = le.ВыражениеSemantic(sc);
        le = resolveProperties(sc, le);

        Выражение ue = e.upr;
        ue = ue.ВыражениеSemantic(sc);
        ue = resolveProperties(sc, ue);

        if (le.op == ТОК2.error)
        {
            результат = le;
            return;
        }
        if (ue.op == ТОК2.error)
        {
            результат = ue;
            return;
        }

        e.lwr = le;
        e.upr = ue;

        e.тип = Тип.tvoid;
        результат = e;
    }

    override проц посети(DelegatePtrExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("DelegatePtrExp::semantic('%s')\n", e.вТкст0());
        }
        if (!e.тип)
        {
            unaSemantic(e, sc);
            e.e1 = resolveProperties(sc, e.e1);

            if (e.e1.op == ТОК2.error)
            {
                результат = e.e1;
                return;
            }
            e.тип = Тип.tvoidptr;
        }
        результат = e;
    }

    override проц посети(DelegateFuncptrExp e)
    {
        static if (LOGSEMANTIC)
        {
            printf("DelegateFuncptrExp::semantic('%s')\n", e.вТкст0());
        }
        if (!e.тип)
        {
            unaSemantic(e, sc);
            e.e1 = resolveProperties(sc, e.e1);
            if (e.e1.op == ТОК2.error)
            {
                результат = e.e1;
                return;
            }
            e.тип = e.e1.тип.nextOf().pointerTo();
        }
        результат = e;
    }

    override проц посети(IndexExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("IndexExp::semantic('%s')\n", exp.вТкст0());
        }
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        // operator overloading should be handled in ArrayExp already.
        if (!exp.e1.тип)
            exp.e1 = exp.e1.ВыражениеSemantic(sc);
        assert(exp.e1.тип); // semantic() should already be run on it
        if (exp.e1.op == ТОК2.тип && exp.e1.тип.ty != Ttuple)
        {
            exp.e2 = exp.e2.ВыражениеSemantic(sc);
            exp.e2 = resolveProperties(sc, exp.e2);
            Тип nt;
            if (exp.e2.op == ТОК2.тип)
                nt = new TypeAArray(exp.e1.тип, exp.e2.тип);
            else
                nt = new TypeSArray(exp.e1.тип, exp.e2);
            Выражение e = new TypeExp(exp.место, nt);
            результат = e.ВыражениеSemantic(sc);
            return;
        }
        if (exp.e1.op == ТОК2.error)
        {
            результат = exp.e1;
            return;
        }
        if (exp.e1.тип.ty == Terror)
            return setError();

        // Note that unlike C we do not implement the цел[ptr]

        Тип t1b = exp.e1.тип.toBasetype();

        if (t1b.ty == Tvector)
        {
            // Convert e1 to corresponding static массив
            TypeVector tv1 = cast(TypeVector)t1b;
            t1b = tv1.basetype;
            t1b = t1b.castMod(tv1.mod);
            exp.e1.тип = t1b;
        }

        /* Run semantic on e2
         */
        Scope* scx = sc;
        if (t1b.ty == Tsarray || t1b.ty == Tarray || t1b.ty == Ttuple)
        {
            // Create scope for 'length' variable
            ScopeDsymbol sym = new ArrayScopeSymbol(sc, exp);
            sym.родитель = sc.scopesym;
            sc = sc.сунь(sym);
        }
        if (t1b.ty == Ttuple)
            sc = sc.startCTFE();
        exp.e2 = exp.e2.ВыражениеSemantic(sc);
        exp.e2 = resolveProperties(sc, exp.e2);
        if (t1b.ty == Ttuple)
            sc = sc.endCTFE();
        if (exp.e2.op == ТОК2.кортеж)
        {
            TupleExp te = cast(TupleExp)exp.e2;
            if (te.exps && te.exps.dim == 1)
                exp.e2 = Выражение.combine(te.e0, (*te.exps)[0]); // bug 4444 fix
        }
        if (sc != scx)
            sc = sc.вынь();
        if (exp.e2.тип == Тип.terror)
            return setError();

        if (checkNonAssignmentArrayOp(exp.e1))
            return setError();

        switch (t1b.ty)
        {
        case Tpointer:
            if ((cast(TypePointer)t1b).следщ.ty == Tfunction)
            {
                exp.выведиОшибку("cannot index function pointer `%s`", exp.e1.вТкст0());
                return setError();
            }
            exp.e2 = exp.e2.implicitCastTo(sc, Тип.tт_мера);
            if (exp.e2.тип == Тип.terror)
                return setError();
            exp.e2 = exp.e2.optimize(WANTvalue);
            if (exp.e2.op == ТОК2.int64 && exp.e2.toInteger() == 0)
            {
            }
            else if (sc.func && !(sc.flags & SCOPE.debug_) && sc.func.setUnsafe())
            {
                exp.выведиОшибку("safe function `%s` cannot index pointer `%s`", sc.func.toPrettyChars(), exp.e1.вТкст0());
                return setError();
            }
            exp.тип = (cast(TypeNext)t1b).следщ;
            break;

        case Tarray:
            exp.e2 = exp.e2.implicitCastTo(sc, Тип.tт_мера);
            if (exp.e2.тип == Тип.terror)
                return setError();
            exp.тип = (cast(TypeNext)t1b).следщ;
            break;

        case Tsarray:
            {
                exp.e2 = exp.e2.implicitCastTo(sc, Тип.tт_мера);
                if (exp.e2.тип == Тип.terror)
                    return setError();
                exp.тип = t1b.nextOf();
                break;
            }
        case Taarray:
            {
                TypeAArray taa = cast(TypeAArray)t1b;
                /* We can skip the implicit conversion if they differ only by
                 * constness
                 * https://issues.dlang.org/show_bug.cgi?ид=2684
                 * see also bug https://issues.dlang.org/show_bug.cgi?ид=2954 b
                 */
                if (!arrayTypeCompatibleWithoutCasting(exp.e2.тип, taa.index))
                {
                    exp.e2 = exp.e2.implicitCastTo(sc, taa.index); // тип checking
                    if (exp.e2.тип == Тип.terror)
                        return setError();
                }

                semanticTypeInfo(sc, taa);

                exp.тип = taa.следщ;
                break;
            }
        case Ttuple:
            {
                exp.e2 = exp.e2.implicitCastTo(sc, Тип.tт_мера);
                if (exp.e2.тип == Тип.terror)
                    return setError();

                exp.e2 = exp.e2.ctfeInterpret();
                uinteger_t index = exp.e2.toUInteger();

                TupleExp te;
                КортежТипов tup;
                т_мера length;
                if (exp.e1.op == ТОК2.кортеж)
                {
                    te = cast(TupleExp)exp.e1;
                    tup = null;
                    length = te.exps.dim;
                }
                else if (exp.e1.op == ТОК2.тип)
                {
                    te = null;
                    tup = cast(КортежТипов)t1b;
                    length = Параметр2.dim(tup.arguments);
                }
                else
                    assert(0);

                if (length <= index)
                {
                    exp.выведиОшибку("массив index `[%llu]` is outside массив bounds `[0 .. %llu]`", index, cast(бдол)length);
                    return setError();
                }
                Выражение e;
                if (exp.e1.op == ТОК2.кортеж)
                {
                    e = (*te.exps)[cast(т_мера)index];
                    e = Выражение.combine(te.e0, e);
                }
                else
                    e = new TypeExp(exp.e1.место, Параметр2.getNth(tup.arguments, cast(т_мера)index).тип);
                результат = e;
                return;
            }
        default:
            exp.выведиОшибку("`%s` must be an массив or pointer тип, not `%s`", exp.e1.вТкст0(), exp.e1.тип.вТкст0());
            return setError();
        }

        // We might know $ now
        setLengthVarIfKnown(exp.lengthVar, t1b);

        if (t1b.ty == Tsarray || t1b.ty == Tarray)
        {
            Выражение el = new ArrayLengthExp(exp.место, exp.e1);
            el = el.ВыражениеSemantic(sc);
            el = el.optimize(WANTvalue);
            if (el.op == ТОК2.int64)
            {
                exp.e2 = exp.e2.optimize(WANTvalue);
                dinteger_t length = el.toInteger();
                if (length)
                {
                    auto bounds = IntRange(SignExtendedNumber(0), SignExtendedNumber(length - 1));
                    exp.indexIsInBounds = bounds.содержит(getIntRange(exp.e2));
                }
            }
        }

        результат = exp;
    }

    override проц посети(PostExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("PostExp::semantic('%s')\n", exp.вТкст0());
        }
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (Выражение ex = binSemantic(exp, sc))
        {
            результат = ex;
            return;
        }
        Выражение e1x = resolveProperties(sc, exp.e1);
        if (e1x.op == ТОК2.error)
        {
            результат = e1x;
            return;
        }
        exp.e1 = e1x;

        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        if (exp.e1.checkReadModifyWrite(exp.op))
            return setError();

        if (exp.e1.op == ТОК2.slice)
        {
            ткст0 s = exp.op == ТОК2.plusPlus ? "increment" : "decrement";
            exp.выведиОшибку("cannot post-%s массив slice `%s`, use pre-%s instead", s, exp.e1.вТкст0(), s);
            return setError();
        }

        exp.e1 = exp.e1.optimize(WANTvalue);

        Тип t1 = exp.e1.тип.toBasetype();
        if (t1.ty == Tclass || t1.ty == Tstruct || exp.e1.op == ТОК2.arrayLength)
        {
            /* Check for operator overloading,
             * but rewrite in terms of ++e instead of e++
             */

            /* If e1 is not trivial, take a reference to it
             */
            Выражение de = null;
            if (exp.e1.op != ТОК2.variable && exp.e1.op != ТОК2.arrayLength)
            {
                // ref v = e1;
                auto v = copyToTemp(STC.ref_, "__postref", exp.e1);
                de = new DeclarationExp(exp.место, v);
                exp.e1 = new VarExp(exp.e1.место, v);
            }

            /* Rewrite as:
             * auto tmp = e1; ++e1; tmp
             */
            auto tmp = copyToTemp(0, "__pitmp", exp.e1);
            Выражение ea = new DeclarationExp(exp.место, tmp);

            Выражение eb = exp.e1.syntaxCopy();
            eb = new PreExp(exp.op == ТОК2.plusPlus ? ТОК2.prePlusPlus : ТОК2.preMinusMinus, exp.место, eb);

            Выражение ec = new VarExp(exp.место, tmp);

            // Combine de,ea,eb,ec
            if (de)
                ea = new CommaExp(exp.место, de, ea);
            e = new CommaExp(exp.место, ea, eb);
            e = new CommaExp(exp.место, e, ec);
            e = e.ВыражениеSemantic(sc);
            результат = e;
            return;
        }

        exp.e1 = exp.e1.modifiableLvalue(sc, exp.e1);

        e = exp;
        if (exp.e1.checkScalar() ||
            exp.e1.checkSharedAccess(sc))
            return setError();
        if (exp.e1.checkNoBool())
            return setError();

        if (exp.e1.тип.ty == Tpointer)
            e = scaleFactor(exp, sc);
        else
            exp.e2 = exp.e2.castTo(sc, exp.e1.тип);
        e.тип = exp.e1.тип;
        результат = e;
    }

    override проц посети(PreExp exp)
    {
        Выражение e = exp.op_overload(sc);
        // printf("PreExp::semantic('%s')\n", вТкст0());
        if (e)
        {
            результат = e;
            return;
        }

        // Rewrite as e1+=1 or e1-=1
        if (exp.op == ТОК2.prePlusPlus)
            e = new AddAssignExp(exp.место, exp.e1, new IntegerExp(exp.место, 1, Тип.tint32));
        else
            e = new MinAssignExp(exp.место, exp.e1, new IntegerExp(exp.место, 1, Тип.tint32));
        результат = e.ВыражениеSemantic(sc);
    }

    /*
     * Get the Выражение инициализатор for a specific struct
     *
     * Параметры:
     *  sd = the struct for which the Выражение инициализатор is needed
     *  место = the location of the инициализатор
     *  sc = the scope where the Выражение is located
     *  t = the тип of the Выражение
     *
     * Возвращает:
     *  The Выражение инициализатор or error Выражение if any errors occured
     */
    private Выражение getInitExp(StructDeclaration sd, Место место, Scope* sc, Тип t)
    {
        if (sd.zeroInit && !sd.isNested())
        {
            // https://issues.dlang.org/show_bug.cgi?ид=14606
            // Always use BlitExp for the special Выражение: (struct = 0)
            return new IntegerExp(место, 0, Тип.tint32);
        }

        if (sd.isNested())
        {
            auto sle = new StructLiteralExp(место, sd, null, t);
            if (!sd.fill(место, sle.elements, да))
                return new ErrorExp();
            if (checkFrameAccess(место, sc, sd, sle.elements.dim))
                return new ErrorExp();

            sle.тип = t;
            return sle;
        }

        return t.defaultInit(место);
    }

    override проц посети(AssignExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("AssignExp::semantic('%s')\n", exp.вТкст0());
        }
        //printf("exp.e1.op = %d, '%s'\n", exp.e1.op, Сема2.вТкст0(exp.e1.op));
        //printf("exp.e2.op = %d, '%s'\n", exp.e2.op, Сема2.вТкст0(exp.e2.op));

        проц setрезультат(Выражение e, цел line = __LINE__)
        {
            //printf("line %d\n", line);
            результат = e;
        }

        if (exp.тип)
        {
            return setрезультат(exp);
        }

        Выражение e1old = exp.e1;

        if (auto e2comma = exp.e2.isCommaExp())
        {
            if (!e2comma.isGenerated)
                exp.выведиОшибку("Using the результат of a comma Выражение is not allowed");

            /* Rewrite to get rid of the comma from rvalue
             *   e1=(e0,e2) => e0,(e1=e2)
             */
            Выражение e0;
            exp.e2 = Выражение.extractLast(e2comma, e0);
            Выражение e = Выражение.combine(e0, exp);
            return setрезультат(e.ВыражениеSemantic(sc));
        }

        /* Look for operator overloading of a[arguments] = e2.
         * Do it before e1.ВыражениеSemantic() otherwise the ArrayExp will have been
         * converted to unary operator overloading already.
         */
        if (auto ae = exp.e1.isArrayExp())
        {
            Выражение res;

            ae.e1 = ae.e1.ВыражениеSemantic(sc);
            ae.e1 = resolveProperties(sc, ae.e1);
            Выражение ae1old = ae.e1;

            const бул maybeSlice =
                (ae.arguments.dim == 0 ||
                 ae.arguments.dim == 1 && (*ae.arguments)[0].op == ТОК2.interval);

            IntervalExp ie = null;
            if (maybeSlice && ae.arguments.dim)
            {
                assert((*ae.arguments)[0].op == ТОК2.interval);
                ie = cast(IntervalExp)(*ae.arguments)[0];
            }
            while (да)
            {
                if (ae.e1.op == ТОК2.error)
                    return setрезультат(ae.e1);

                Выражение e0 = null;
                Выражение ae1save = ae.e1;
                ae.lengthVar = null;

                Тип t1b = ae.e1.тип.toBasetype();
                AggregateDeclaration ad = isAggregate(t1b);
                if (!ad)
                    break;
                if (search_function(ad, Id.indexass))
                {
                    // Deal with $
                    res = resolveOpDollar(sc, ae, &e0);
                    if (!res) // a[i..j] = e2 might be: a.opSliceAssign(e2, i, j)
                        goto Lfallback;
                    if (res.op == ТОК2.error)
                        return setрезультат(res);

                    res = exp.e2.ВыражениеSemantic(sc);
                    if (res.op == ТОК2.error)
                        return setрезультат(res);
                    exp.e2 = res;

                    /* Rewrite (a[arguments] = e2) as:
                     *      a.opIndexAssign(e2, arguments)
                     */
                    Выражения* a = ae.arguments.копируй();
                    a.вставь(0, exp.e2);
                    res = new DotIdExp(exp.место, ae.e1, Id.indexass);
                    res = new CallExp(exp.место, res, a);
                    if (maybeSlice) // a[] = e2 might be: a.opSliceAssign(e2)
                        res = res.trySemantic(sc);
                    else
                        res = res.ВыражениеSemantic(sc);
                    if (res)
                        return setрезультат(Выражение.combine(e0, res));
                }

            Lfallback:
                if (maybeSlice && search_function(ad, Id.sliceass))
                {
                    // Deal with $
                    res = resolveOpDollar(sc, ae, ie, &e0);
                    if (res.op == ТОК2.error)
                        return setрезультат(res);

                    res = exp.e2.ВыражениеSemantic(sc);
                    if (res.op == ТОК2.error)
                        return setрезультат(res);

                    exp.e2 = res;

                    /* Rewrite (a[i..j] = e2) as:
                     *      a.opSliceAssign(e2, i, j)
                     */
                    auto a = new Выражения();
                    a.сунь(exp.e2);
                    if (ie)
                    {
                        a.сунь(ie.lwr);
                        a.сунь(ie.upr);
                    }
                    res = new DotIdExp(exp.место, ae.e1, Id.sliceass);
                    res = new CallExp(exp.место, res, a);
                    res = res.ВыражениеSemantic(sc);
                    return setрезультат(Выражение.combine(e0, res));
                }

                // No operator overloading member function found yet, but
                // there might be an alias this to try.
                if (ad.aliasthis && t1b != ae.att1)
                {
                    if (!ae.att1 && t1b.checkAliasThisRec())
                        ae.att1 = t1b;

                    /* Rewrite (a[arguments] op e2) as:
                     *      a.aliasthis[arguments] op e2
                     */
                    ae.e1 = resolveAliasThis(sc, ae1save, да);
                    if (ae.e1)
                        continue;
                }
                break;
            }
            ae.e1 = ae1old; // recovery
            ae.lengthVar = null;
        }

        /* Run this.e1 semantic.
         */
        {
            Выражение e1x = exp.e1;

            /* With UFCS, e.f = значение
             * Could mean:
             *      .f(e, значение)
             * or:
             *      .f(e) = значение
             */
            if (auto dti = e1x.isDotTemplateInstanceExp())
            {
                Выражение e = dti.semanticY(sc, 1);
                if (!e)
                {
                    return setрезультат(resolveUFCSProperties(sc, e1x, exp.e2));
                }

                e1x = e;
            }
            else if (auto die = e1x.isDotIdExp())
            {
                Выражение e = die.semanticY(sc, 1);
                if (e && isDotOpDispatch(e))
                {
                    /* https://issues.dlang.org/show_bug.cgi?ид=19687
                     *
                     * On this branch, e2 is semantically analyzed in resolvePropertiesX,
                     * but that call is done with gagged errors. That is the only time when
                     * semantic gets ran on e2, that is why the error never gets to be printed.
                     * In order to make sure that UFCS is tried with correct parameters, e2
                     * needs to have semantic ran on it.
                     */
                    exp.e2 = exp.e2.ВыражениеSemantic(sc);
                    бцел errors = глоб2.startGagging();
                    e = resolvePropertiesX(sc, e, exp.e2);
                    if (глоб2.endGagging(errors))
                        e = null; /* fall down to UFCS */
                    else
                        return setрезультат(e);
                }
                if (!e)
                    return setрезультат(resolveUFCSProperties(sc, e1x, exp.e2));
                e1x = e;
            }
            else
            {
                if (auto se = e1x.isSliceExp())
                    se.arrayop = да;

                e1x = e1x.ВыражениеSemantic(sc);
            }

            /* We have f = значение.
             * Could mean:
             *      f(значение)
             * or:
             *      f() = значение
             */
            if (Выражение e = resolvePropertiesX(sc, e1x, exp.e2))
                return setрезультат(e);

            if (e1x.checkRightThis(sc))
            {
                return setError();
            }
            exp.e1 = e1x;
            assert(exp.e1.тип);
        }
        Тип t1 = exp.e1.тип.toBasetype();

        /* Run this.e2 semantic.
         * Different from other binary Выражения, the analysis of e2
         * depends on the результат of e1 in assignments.
         */
        {
            Выражение e2x = inferType(exp.e2, t1.baseElemOf());
            e2x = e2x.ВыражениеSemantic(sc);
            e2x = resolveProperties(sc, e2x);
            if (e2x.op == ТОК2.тип)
                e2x = resolveAliasThis(sc, e2x); //https://issues.dlang.org/show_bug.cgi?ид=17684
            if (e2x.op == ТОК2.error)
                return setрезультат(e2x);
            if (e2x.checkValue() || e2x.checkSharedAccess(sc))
                return setError();
            exp.e2 = e2x;
        }

        /* Rewrite кортеж assignment as a кортеж of assignments.
         */
        {
            Выражение e2x = exp.e2;

        Ltupleassign:
            if (exp.e1.op == ТОК2.кортеж && e2x.op == ТОК2.кортеж)
            {
                TupleExp tup1 = cast(TupleExp)exp.e1;
                TupleExp tup2 = cast(TupleExp)e2x;
                т_мера dim = tup1.exps.dim;
                Выражение e = null;
                if (dim != tup2.exps.dim)
                {
                    exp.выведиОшибку("mismatched кортеж lengths, %d and %d", cast(цел)dim, cast(цел)tup2.exps.dim);
                    return setError();
                }
                if (dim == 0)
                {
                    e = new IntegerExp(exp.место, 0, Тип.tint32);
                    e = new CastExp(exp.место, e, Тип.tvoid); // avoid "has no effect" error
                    e = Выражение.combine(tup1.e0, tup2.e0, e);
                }
                else
                {
                    auto exps = new Выражения(dim);
                    for (т_мера i = 0; i < dim; i++)
                    {
                        Выражение ex1 = (*tup1.exps)[i];
                        Выражение ex2 = (*tup2.exps)[i];
                        (*exps)[i] = new AssignExp(exp.место, ex1, ex2);
                    }
                    e = new TupleExp(exp.место, Выражение.combine(tup1.e0, tup2.e0), exps);
                }
                return setрезультат(e.ВыражениеSemantic(sc));
            }

            /* Look for form: e1 = e2.aliasthis.
             */
            if (exp.e1.op == ТОК2.кортеж)
            {
                TupleDeclaration td = isAliasThisTuple(e2x);
                if (!td)
                    goto Lnomatch;

                assert(exp.e1.тип.ty == Ttuple);
                КортежТипов tt = cast(КортежТипов)exp.e1.тип;

                Выражение e0;
                Выражение ev = extractSideEffect(sc, "__tup", e0, e2x);

                auto iexps = new Выражения();
                iexps.сунь(ev);
                for (т_мера u = 0; u < iexps.dim; u++)
                {
                Lexpand:
                    Выражение e = (*iexps)[u];

                    Параметр2 arg = Параметр2.getNth(tt.arguments, u);
                    //printf("[%d] iexps.dim = %d, ", u, iexps.dim);
                    //printf("e = (%s %s, %s), ", Сема2::tochars[e.op], e.вТкст0(), e.тип.вТкст0());
                    //printf("arg = (%s, %s)\n", arg.вТкст0(), arg.тип.вТкст0());

                    if (!arg || !e.тип.implicitConvTo(arg.тип))
                    {
                        // expand инициализатор to кортеж
                        if (expandAliasThisTuples(iexps, u) != -1)
                        {
                            if (iexps.dim <= u)
                                break;
                            goto Lexpand;
                        }
                        goto Lnomatch;
                    }
                }
                e2x = new TupleExp(e2x.место, e0, iexps);
                e2x = e2x.ВыражениеSemantic(sc);
                if (e2x.op == ТОК2.error)
                {
                    результат = e2x;
                    return;
                }
                // Do not need to overwrite this.e2
                goto Ltupleassign;
            } 
        }
       Lnomatch:
        exp.e1.checkSharedAccess(sc);

        /* Inside constructor, if this is the first assignment of объект field,
         * rewrite this to initializing the field.
         */
        if (exp.op == ТОК2.assign
            && exp.e1.checkModifiable(sc) == Modifiable.initialization)
        {
            //printf("[%s] change to init - %s\n", exp.место.вТкст0(), exp.вТкст0());
            auto t = exp.тип;
            exp = new ConstructExp(exp.место, exp.e1, exp.e2);
            exp.тип = t;

            // @@@DEPRECATED_2020-06@@@
            // When removing, alter `checkModifiable` to return the correct значение.
            if (sc.func.isStaticCtorDeclaration() && !sc.func.isSharedStaticCtorDeclaration() &&
                exp.e1.тип.isImmutable())
            {
                deprecation(exp.место, "initialization of `const` variable from `static this` is deprecated.");
                deprecationSupplemental(exp.место, "Use `shared static this` instead.");
            }

            // https://issues.dlang.org/show_bug.cgi?ид=13515
            // set Index::modifiable флаг for complex AA element initialization
            if (auto ie1 = exp.e1.isIndexExp())
            {
                Выражение e1x = ie1.markSettingAAElem();
                if (e1x.op == ТОК2.error)
                {
                    результат = e1x;
                    return;
                }
            }
        }
        else if (exp.op == ТОК2.construct && exp.e1.op == ТОК2.variable &&
                 (cast(VarExp)exp.e1).var.класс_хранения & (STC.out_ | STC.ref_))
        {
            exp.memset |= MemorySet.referenceInit;
        }

        /* If it is an assignment from a 'foreign' тип,
         * check for operator overloading.
         */
        if (exp.memset & MemorySet.referenceInit)
        {
            // If this is an initialization of a reference,
            // do nothing
        }
        else if (t1.ty == Tstruct)
        {
            auto e1x = exp.e1;
            auto e2x = exp.e2;
            auto sd = (cast(TypeStruct)t1).sym;

            if (exp.op == ТОК2.construct)
            {
                Тип t2 = e2x.тип.toBasetype();
                if (t2.ty == Tstruct && sd == (cast(TypeStruct)t2).sym)
                {
                    sd.size(exp.место);
                    if (sd.sizeok != Sizeok.done)
                        return setError();
                    if (!sd.ctor)
                        sd.ctor = sd.searchCtor();

                    // https://issues.dlang.org/show_bug.cgi?ид=15661
                    // Look for the form from last of comma chain.
                    auto e2y = lastComma(e2x);

                    CallExp ce = (e2y.op == ТОК2.call) ? cast(CallExp)e2y : null;
                    DotVarExp dve = (ce && ce.e1.op == ТОК2.dotVariable)
                        ? cast(DotVarExp)ce.e1 : null;
                    if (sd.ctor && ce && dve && dve.var.isCtorDeclaration() &&
                        // https://issues.dlang.org/show_bug.cgi?ид=19389
                        dve.e1.op != ТОК2.dotVariable &&
                        e2y.тип.implicitConvTo(t1))
                    {
                        /* Look for form of constructor call which is:
                         *    __ctmp.ctor(arguments...)
                         */

                        /* Before calling the constructor, initialize
                         * variable with a bit копируй of the default
                         * инициализатор
                         */
                        Выражение einit = getInitExp(sd, exp.место, sc, t1);
                        if (einit.op == ТОК2.error)
                        {
                            результат = einit;
                            return;
                        }

                        auto ae = new BlitExp(exp.место, exp.e1, einit);
                        ae.тип = e1x.тип;

                        /* Replace __ctmp being constructed with e1.
                         * We need to копируй constructor call Выражение,
                         * because it may be используется in other place.
                         */
                        auto dvx = cast(DotVarExp)dve.копируй();
                        dvx.e1 = e1x;
                        auto cx = cast(CallExp)ce.копируй();
                        cx.e1 = dvx;
                        if (глоб2.парамы.vsafe && checkConstructorEscape(sc, cx, нет))
                            return setError();

                        Выражение e0;
                        Выражение.extractLast(e2x, e0);

                        auto e = Выражение.combine(e0, ae, cx);
                        e = e.ВыражениеSemantic(sc);
                        результат = e;
                        return;
                    }
                    if (sd.postblit || sd.hasCopyCtor)
                    {
                        /* We have a копируй constructor for this
                         */
                        if (e2x.op == ТОК2.question)
                        {
                            /* Rewrite as:
                             *  a ? e1 = b : e1 = c;
                             */
                            CondExp econd = cast(CondExp)e2x;
                            Выражение ea1 = new ConstructExp(econd.e1.место, e1x, econd.e1);
                            Выражение ea2 = new ConstructExp(econd.e1.место, e1x, econd.e2);
                            Выражение e = new CondExp(exp.место, econd.econd, ea1, ea2);
                            результат = e.ВыражениеSemantic(sc);
                            return;
                        }

                        if (e2x.isLvalue())
                        {
                            if (sd.hasCopyCtor)
                            {
                                /* Rewrite as:
                                 * e1 = init, e1.copyCtor(e2);
                                 */
                                Выражение einit = new BlitExp(exp.место, exp.e1, getInitExp(sd, exp.место, sc, t1));
                                einit.тип = e1x.тип;

                                Выражение e;
                                e = new DotIdExp(exp.место, e1x, Id.ctor);
                                e = new CallExp(exp.место, e, e2x);
                                e = new CommaExp(exp.место, einit, e);

                                //printf("e: %s\n", e.вТкст0());

                                результат = e.ВыражениеSemantic(sc);
                                return;
                            }
                            else
                            {
                                if (!e2x.тип.implicitConvTo(e1x.тип))
                                {
                                    exp.выведиОшибку("conversion error from `%s` to `%s`",
                                        e2x.тип.вТкст0(), e1x.тип.вТкст0());
                                    return setError();
                                }

                                /* Rewrite as:
                                 *  (e1 = e2).postblit();
                                 *
                                 * Blit assignment e1 = e2 returns a reference to the original e1,
                                 * then call the postblit on it.
                                 */
                                Выражение e = e1x.копируй();
                                e.тип = e.тип.mutableOf();
                                if (e.тип.isShared && !sd.тип.isShared)
                                    e.тип = e.тип.unSharedOf();
                                e = new BlitExp(exp.место, e, e2x);
                                e = new DotVarExp(exp.место, e, sd.postblit, нет);
                                e = new CallExp(exp.место, e);
                                результат = e.ВыражениеSemantic(sc);
                                return;
                            }
                        }
                        else
                        {
                            /* The struct значение returned from the function is transferred
                             * so should not call the destructor on it.
                             */
                            e2x = valueNoDtor(e2x);
                        }
                    }

                    // https://issues.dlang.org/show_bug.cgi?ид=19251
                    // if e2 cannot be converted to e1.тип, maybe there is an alias this
                    if (!e2x.implicitConvTo(t1))
                    {
                        AggregateDeclaration ad2 = isAggregate(e2x.тип);
                        if (ad2 && ad2.aliasthis && !(exp.att2 && e2x.тип == exp.att2))
                        {
                            if (!exp.att2 && exp.e2.тип.checkAliasThisRec())
                            exp.att2 = exp.e2.тип;
                            /* Rewrite (e1 op e2) as:
                             *      (e1 op e2.aliasthis)
                             */
                            exp.e2 = new DotIdExp(exp.e2.место, exp.e2, ad2.aliasthis.идент);
                            результат = exp.ВыражениеSemantic(sc);
                            return;
                        }
                    }
                }
                else if (!e2x.implicitConvTo(t1))
                {
                    sd.size(exp.место);
                    if (sd.sizeok != Sizeok.done)
                        return setError();
                    if (!sd.ctor)
                        sd.ctor = sd.searchCtor();

                    if (sd.ctor)
                    {
                        /* Look for implicit constructor call
                         * Rewrite as:
                         *  e1 = init, e1.ctor(e2)
                         */

                        /* Fix Issue 5153 : https://issues.dlang.org/show_bug.cgi?ид=5153
                         * Using `new` to initialize a struct объект is a common mistake, but
                         * the error message from the compiler is not very helpful in that
                         * case. If exp.e2 is a NewExp and the тип of new is the same as
                         * the тип as exp.e1 (struct in this case), then we know for sure
                         * that the user wants to instantiate a struct. This is done to avoid
                         * issuing an error when the user actually wants to call a constructor
                         * which receives a class объект.
                         *
                         * Foo f = new Foo2(0); is a valid Выражение if Foo has a constructor
                         * which receives an instance of a Foo2 class
                         */
                        if (exp.e2.op == ТОК2.new_)
                        {
                            auto newExp = cast(NewExp)(exp.e2);
                            if (newExp.newtype && newExp.newtype == t1)
                            {
                                выведиОшибку(exp.место, "cannot implicitly convert Выражение `%s` of тип `%s` to `%s`",
                                      newExp.вТкст0(), newExp.тип.вТкст0(), t1.вТкст0());
                                errorSupplemental(exp.место, "Perhaps удали the `new` keyword?");
                                return setError();
                            }
                        }

                        Выражение einit = new BlitExp(exp.место, e1x, getInitExp(sd, exp.место, sc, t1));
                        einit.тип = e1x.тип;

                        Выражение e;
                        e = new DotIdExp(exp.место, e1x, Id.ctor);
                        e = new CallExp(exp.место, e, e2x);
                        e = new CommaExp(exp.место, einit, e);
                        e = e.ВыражениеSemantic(sc);
                        результат = e;
                        return;
                    }
                    if (search_function(sd, Id.call))
                    {
                        /* Look for static opCall
                         * https://issues.dlang.org/show_bug.cgi?ид=2702
                         * Rewrite as:
                         *  e1 = typeof(e1).opCall(arguments)
                         */
                        e2x = typeDotIdExp(e2x.место, e1x.тип, Id.call);
                        e2x = new CallExp(exp.место, e2x, exp.e2);

                        e2x = e2x.ВыражениеSemantic(sc);
                        e2x = resolveProperties(sc, e2x);
                        if (e2x.op == ТОК2.error)
                        {
                            результат = e2x;
                            return;
                        }
                        if (e2x.checkValue() || e2x.checkSharedAccess(sc))
                            return setError();
                    }
                }
                else // https://issues.dlang.org/show_bug.cgi?ид=11355
                {
                    AggregateDeclaration ad2 = isAggregate(e2x.тип);
                    if (ad2 && ad2.aliasthis && !(exp.att2 && e2x.тип == exp.att2))
                    {
                        if (!exp.att2 && exp.e2.тип.checkAliasThisRec())
                            exp.att2 = exp.e2.тип;
                        /* Rewrite (e1 op e2) as:
                         *      (e1 op e2.aliasthis)
                         */
                        exp.e2 = new DotIdExp(exp.e2.место, exp.e2, ad2.aliasthis.идент);
                        результат = exp.ВыражениеSemantic(sc);
                        return;
                    }
                }
            }
            else if (exp.op == ТОК2.assign)
            {
                if (e1x.op == ТОК2.index && (cast(IndexExp)e1x).e1.тип.toBasetype().ty == Taarray)
                {
                    /*
                     * Rewrite:
                     *      aa[ключ] = e2;
                     * as:
                     *      ref __aatmp = aa;
                     *      ref __aakey = ключ;
                     *      ref __aaval = e2;
                     *      (__aakey in __aatmp
                     *          ? __aatmp[__aakey].opAssign(__aaval)
                     *          : ConstructExp(__aatmp[__aakey], __aaval));
                     */
                    // ensure we keep the expr modifiable
                    Выражение esetting = (cast(IndexExp)e1x).markSettingAAElem();
                    if (esetting.op == ТОК2.error)
                    {
                        результат = esetting;
                        return;
                    }
                    assert(esetting.op == ТОК2.index);
                    IndexExp ie = cast(IndexExp) esetting;
                    Тип t2 = e2x.тип.toBasetype();

                    Выражение e0 = null;
                    Выражение ea = extractSideEffect(sc, "__aatmp", e0, ie.e1);
                    Выражение ek = extractSideEffect(sc, "__aakey", e0, ie.e2);
                    Выражение ev = extractSideEffect(sc, "__aaval", e0, e2x);

                    AssignExp ae = cast(AssignExp)exp.копируй();
                    ae.e1 = new IndexExp(exp.место, ea, ek);
                    ae.e1 = ae.e1.ВыражениеSemantic(sc);
                    ae.e1 = ae.e1.optimize(WANTvalue);
                    ae.e2 = ev;
                    Выражение e = ae.op_overload(sc);
                    if (e)
                    {
                        Выражение ey = null;
                        if (t2.ty == Tstruct && sd == t2.toDsymbol(sc))
                        {
                            ey = ev;
                        }
                        else if (!ev.implicitConvTo(ie.тип) && sd.ctor)
                        {
                            // Look for implicit constructor call
                            // Rewrite as S().ctor(e2)
                            ey = new StructLiteralExp(exp.место, sd, null);
                            ey = new DotIdExp(exp.место, ey, Id.ctor);
                            ey = new CallExp(exp.место, ey, ev);
                            ey = ey.trySemantic(sc);
                        }
                        if (ey)
                        {
                            Выражение ex;
                            ex = new IndexExp(exp.место, ea, ek);
                            ex = ex.ВыражениеSemantic(sc);
                            ex = ex.optimize(WANTvalue);
                            ex = ex.modifiableLvalue(sc, ex); // размести new slot

                            ey = new ConstructExp(exp.место, ex, ey);
                            ey = ey.ВыражениеSemantic(sc);
                            if (ey.op == ТОК2.error)
                            {
                                результат = ey;
                                return;
                            }
                            ex = e;

                            // https://issues.dlang.org/show_bug.cgi?ид=14144
                            // The whole Выражение should have the common тип
                            // of opAssign() return and assigned AA entry.
                            // Even if there's no common тип, Выражение should be typed as проц.
                            Тип t = null;
                            if (!typeMerge(sc, ТОК2.question, &t, &ex, &ey))
                            {
                                ex = new CastExp(ex.место, ex, Тип.tvoid);
                                ey = new CastExp(ey.место, ey, Тип.tvoid);
                            }
                            e = new CondExp(exp.место, new InExp(exp.место, ek, ea), ex, ey);
                        }
                        e = Выражение.combine(e0, e);
                        e = e.ВыражениеSemantic(sc);
                        результат = e;
                        return;
                    }
                }
                else
                {
                    Выражение e = exp.op_overload(sc);
                    if (e)
                    {
                        результат = e;
                        return;
                    }
                }
            }
            else
                assert(exp.op == ТОК2.blit);

            exp.e1 = e1x;
            exp.e2 = e2x;
        }
        else if (t1.ty == Tclass)
        {
            // Disallow assignment operator overloads for same тип
            if (exp.op == ТОК2.assign && !exp.e2.implicitConvTo(exp.e1.тип))
            {
                Выражение e = exp.op_overload(sc);
                if (e)
                {
                    результат = e;
                    return;
                }
            }
        }
        else if (t1.ty == Tsarray)
        {
            // SliceExp cannot have static массив тип without context inference.
            assert(exp.e1.op != ТОК2.slice);
            Выражение e1x = exp.e1;
            Выражение e2x = exp.e2;

            if (e2x.implicitConvTo(e1x.тип))
            {
                if (exp.op != ТОК2.blit && (e2x.op == ТОК2.slice && (cast(UnaExp)e2x).e1.isLvalue() || e2x.op == ТОК2.cast_ && (cast(UnaExp)e2x).e1.isLvalue() || e2x.op != ТОК2.slice && e2x.isLvalue()))
                {
                    if (e1x.checkPostblit(sc, t1))
                        return setError();
                }

                // e2 matches to t1 because of the implicit length match, so
                if (isUnaArrayOp(e2x.op) || isBinArrayOp(e2x.op))
                {
                    // convert e1 to e1[]
                    // e.g. e1[] = a[] + b[];
                    auto sle = new SliceExp(e1x.место, e1x, null, null);
                    sle.arrayop = да;
                    e1x = sle.ВыражениеSemantic(sc);
                }
                else
                {
                    // convert e2 to t1 later
                    // e.g. e1 = [1, 2, 3];
                }
            }
            else
            {
                if (e2x.implicitConvTo(t1.nextOf().arrayOf()) > MATCH.nomatch)
                {
                    uinteger_t dim1 = (cast(TypeSArray)t1).dim.toInteger();
                    uinteger_t dim2 = dim1;
                    if (auto ale = e2x.isArrayLiteralExp())
                    {
                        dim2 = ale.elements ? ale.elements.dim : 0;
                    }
                    else if (auto se = e2x.isSliceExp())
                    {
                        Тип tx = toStaticArrayType(se);
                        if (tx)
                            dim2 = (cast(TypeSArray)tx).dim.toInteger();
                    }
                    if (dim1 != dim2)
                    {
                        exp.выведиОшибку("mismatched массив lengths, %d and %d", cast(цел)dim1, cast(цел)dim2);
                        return setError();
                    }
                }

                // May be block or element-wise assignment, so
                // convert e1 to e1[]
                if (exp.op != ТОК2.assign)
                {
                    // If multidimensional static массив, treat as one large массив
                    //
                    // Find the appropriate массив тип depending on the assignment, e.g.
                    // цел[3] = цел => цел[3]
                    // цел[3][2] = цел => цел[6]
                    // цел[3][2] = цел[] => цел[3][2]
                    // цел[3][2][4] + цел => цел[24]
                    // цел[3][2][4] + цел[] => цел[3][8]
                    бдол dim = t1.isTypeSArray().dim.toUInteger();
                    auto тип = t1.nextOf();

                    for (TypeSArray tsa; (tsa = тип.isTypeSArray()) !is null; )
                    {
                         // Accumulate skipped dimensions
                        бул overflow = нет;
                        dim = mulu(dim, tsa.dim.toUInteger(), overflow);
                        if (overflow || dim >= бцел.max)
                        {
                            // dym exceeds maximum массив size
                            exp.выведиОшибку("static массив `%s` size overflowed to %llu",
                                        e1x.тип.вТкст0(), cast(бдол) dim);
                            return setError();
                        }

                        // Move to the element тип
                        тип = tsa.nextOf().toBasetype();

                        // Rewrite ex1 as a static массив if a matching тип was found
                        if (e2x.implicitConvTo(тип) > MATCH.nomatch)
                        {
                            e1x.тип = тип.sarrayOf(dim);
                            break;
                        }
                    }
                }
                auto sle = new SliceExp(e1x.место, e1x, null, null);
                sle.arrayop = да;
                e1x = sle.ВыражениеSemantic(sc);
            }
            if (e1x.op == ТОК2.error)
                return setрезультат(e1x);
            if (e2x.op == ТОК2.error)
                return setрезультат(e2x);

            exp.e1 = e1x;
            exp.e2 = e2x;
            t1 = e1x.тип.toBasetype();
        }
        /* Check the mutability of e1.
         */
        if (auto ale = exp.e1.isArrayLengthExp())
        {
            // e1 is not an lvalue, but we let code generator handle it

            auto ale1x = ale.e1.modifiableLvalue(sc, exp.e1);
            if (ale1x.op == ТОК2.error)
                return setрезультат(ale1x);
            ale.e1 = ale1x;

            Тип tn = ale.e1.тип.toBasetype().nextOf();
            checkDefCtor(ale.место, tn);

            Идентификатор2 hook = глоб2.парамы.tracegc ? Id._d_arraysetlengthTTrace : Id._d_arraysetlengthT;
            if (!verifyHookExist(exp.место, *sc, Id._d_arraysetlengthTImpl, "resizing arrays"))
                return setError();

            // Lower to объект._d_arraysetlengthTImpl!(typeof(e1))._d_arraysetlengthT{,Trace}(e1, e2)
            Выражение ид = new IdentifierExp(ale.место, Id.empty);
            ид = new DotIdExp(ale.место, ид, Id.объект);
            auto tiargs = new Объекты();
            tiargs.сунь(ale.e1.тип);
            ид = new DotTemplateInstanceExp(ale.место, ид, Id._d_arraysetlengthTImpl, tiargs);
            ид = new DotIdExp(ale.место, ид, hook);
            ид = ид.ВыражениеSemantic(sc);

            auto arguments = new Выражения();
            arguments.резервируй(5);
            if (глоб2.парамы.tracegc)
            {
                auto funcname = (sc.callsc && sc.callsc.func) ? sc.callsc.func.toPrettyChars() : sc.func.toPrettyChars();
                arguments.сунь(new StringExp(exp.место, exp.место.имяф.вТкстД()));
                arguments.сунь(new IntegerExp(exp.место, exp.место.номстр, Тип.tint32));
                arguments.сунь(new StringExp(exp.место, funcname.вТкстД()));
            }
            arguments.сунь(ale.e1);
            arguments.сунь(exp.e2);

            Выражение ce = new CallExp(ale.место, ид, arguments);
            auto res = ce.ВыражениеSemantic(sc);
            // if (глоб2.парамы.verbose)
            //     message("lowered   %s =>\n          %s", exp.вТкст0(), res.вТкст0());
            return setрезультат(res);
        }
        else if (auto se = exp.e1.isSliceExp())
        {
            Тип tn = se.тип.nextOf();
            const fun = sc.func;
            if (exp.op == ТОК2.assign && !tn.isMutable() &&
                // allow modifiation in module ctor, see
                // https://issues.dlang.org/show_bug.cgi?ид=9884
                (!fun || (fun && !fun.isStaticCtorDeclaration())))
            {
                exp.выведиОшибку("slice `%s` is not mutable", se.вТкст0());
                return setError();
            }

            if (exp.op == ТОК2.assign && !tn.baseElemOf().isAssignable())
            {
                exp.выведиОшибку("slice `%s` is not mutable, struct `%s` has const члены",
                    exp.e1.вТкст0(), tn.baseElemOf().вТкст0());
                результат = new ErrorExp();
                return;
            }

            // For conditional operator, both branches need conversion.
            while (se.e1.op == ТОК2.slice)
                se = cast(SliceExp)se.e1;
            if (se.e1.op == ТОК2.question && se.e1.тип.toBasetype().ty == Tsarray)
            {
                se.e1 = se.e1.modifiableLvalue(sc, exp.e1);
                if (se.e1.op == ТОК2.error)
                    return setрезультат(se.e1);
            }
        }
        else
        {
            if (t1.ty == Tsarray && exp.op == ТОК2.assign)
            {
                Тип tn = exp.e1.тип.nextOf();
                if (tn && !tn.baseElemOf().isAssignable())
                {
                    exp.выведиОшибку("массив `%s` is not mutable, struct `%s` has const члены",
                        exp.e1.вТкст0(), tn.baseElemOf().вТкст0());
                    результат = new ErrorExp();
                    return;
                }
            }

            Выражение e1x = exp.e1;

            // Try to do a decent error message with the Выражение
            // before it got constant folded

            if (e1x.op != ТОК2.variable)
                e1x = e1x.optimize(WANTvalue);

            if (exp.op == ТОК2.assign)
                e1x = e1x.modifiableLvalue(sc, e1old);

            if (checkIfIsStructLiteralDotExpr(e1x))
                return setError();

            if (e1x.op == ТОК2.error)
            {
                результат = e1x;
                return;
            }
            exp.e1 = e1x;
        }

        /* Tweak e2 based on the тип of e1.
         */
        Выражение e2x = exp.e2;
        Тип t2 = e2x.тип.toBasetype();

        // If it is a массив, get the element тип. Note that it may be
        // multi-dimensional.
        Тип telem = t1;
        while (telem.ty == Tarray)
            telem = telem.nextOf();

        if (exp.e1.op == ТОК2.slice && t1.nextOf() &&
            (telem.ty != Tvoid || e2x.op == ТОК2.null_) &&
            e2x.implicitConvTo(t1.nextOf()))
        {
            // Check for block assignment. If it is of тип проц[], проц[][], etc,
            // '= null' is the only allowable block assignment (Bug 7493)
            exp.memset |= MemorySet.blockAssign;    // make it easy for back end to tell what this is
            e2x = e2x.implicitCastTo(sc, t1.nextOf());
            if (exp.op != ТОК2.blit && e2x.isLvalue() && exp.e1.checkPostblit(sc, t1.nextOf()))
                return setError();
        }
        else if (exp.e1.op == ТОК2.slice &&
                 (t2.ty == Tarray || t2.ty == Tsarray) &&
                 t2.nextOf().implicitConvTo(t1.nextOf()))
        {
            // Check element-wise assignment.

            /* If assigned elements number is known at compile time,
             * check the mismatch.
             */
            SliceExp se1 = cast(SliceExp)exp.e1;
            TypeSArray tsa1 = cast(TypeSArray)toStaticArrayType(se1);
            TypeSArray tsa2 = null;
            if (auto ale = e2x.isArrayLiteralExp())
                tsa2 = cast(TypeSArray)t2.nextOf().sarrayOf(ale.elements.dim);
            else if (auto se = e2x.isSliceExp())
                tsa2 = cast(TypeSArray)toStaticArrayType(se);
            else
                tsa2 = t2.isTypeSArray();
            if (tsa1 && tsa2)
            {
                uinteger_t dim1 = tsa1.dim.toInteger();
                uinteger_t dim2 = tsa2.dim.toInteger();
                if (dim1 != dim2)
                {
                    exp.выведиОшибку("mismatched массив lengths, %d and %d", cast(цел)dim1, cast(цел)dim2);
                    return setError();
                }
            }

            if (exp.op != ТОК2.blit &&
                (e2x.op == ТОК2.slice && (cast(UnaExp)e2x).e1.isLvalue() ||
                 e2x.op == ТОК2.cast_ && (cast(UnaExp)e2x).e1.isLvalue() ||
                 e2x.op != ТОК2.slice && e2x.isLvalue()))
            {
                if (exp.e1.checkPostblit(sc, t1.nextOf()))
                    return setError();
            }

            if (0 && глоб2.парамы.warnings != DiagnosticReporting.off && !глоб2.gag && exp.op == ТОК2.assign &&
                e2x.op != ТОК2.slice && e2x.op != ТОК2.assign &&
                e2x.op != ТОК2.arrayLiteral && e2x.op != ТОК2.string_ &&
                !(e2x.op == ТОК2.add || e2x.op == ТОК2.min ||
                  e2x.op == ТОК2.mul || e2x.op == ТОК2.div ||
                  e2x.op == ТОК2.mod || e2x.op == ТОК2.xor ||
                  e2x.op == ТОК2.and || e2x.op == ТОК2.or ||
                  e2x.op == ТОК2.pow ||
                  e2x.op == ТОК2.tilde || e2x.op == ТОК2.negate))
            {
                ткст0 e1str = exp.e1.вТкст0();
                ткст0 e2str = e2x.вТкст0();
                exp.warning("explicit element-wise assignment `%s = (%s)[]` is better than `%s = %s`", e1str, e2str, e1str, e2str);
            }

            Тип t2n = t2.nextOf();
            Тип t1n = t1.nextOf();
            цел смещение;
            if (t2n.equivalent(t1n) ||
                t1n.isBaseOf(t2n, &смещение) && смещение == 0)
            {
                /* Allow копируй of distinct qualifier elements.
                 * eg.
                 *  ткст dst;  ткст src;
                 *  dst[] = src;
                 *
                 *  class C {}   class D : C {}
                 *  C[2] ca;  D[] da;
                 *  ca[] = da;
                 */
                if (isArrayOpValid(e2x))
                {
                    // Don't add CastExp to keep AST for массив operations
                    e2x = e2x.копируй();
                    e2x.тип = exp.e1.тип.constOf();
                }
                else
                    e2x = e2x.castTo(sc, exp.e1.тип.constOf());
            }
            else
            {
                /* https://issues.dlang.org/show_bug.cgi?ид=15778
                 * A ткст literal has an массив тип of const
                 * elements by default, and normally it cannot be convertible to
                 * массив тип of mutable elements. But for element-wise assignment,
                 * elements need to be const at best. So we should give a chance
                 * to change code unit size for polysemous ткст literal.
                 */
                if (e2x.op == ТОК2.string_)
                    e2x = e2x.implicitCastTo(sc, exp.e1.тип.constOf());
                else
                    e2x = e2x.implicitCastTo(sc, exp.e1.тип);
            }
            if (t1n.toBasetype.ty == Tvoid && t2n.toBasetype.ty == Tvoid)
            {
                if (!sc.intypeof && sc.func && !(sc.flags & SCOPE.debug_) && sc.func.setUnsafe())
                {
                    exp.выведиОшибку("cannot копируй `проц[]` to `проц[]` in `` code");
                    return setError();
                }
            }
        }
        else
        {
            if (0 && глоб2.парамы.warnings != DiagnosticReporting.off && !глоб2.gag && exp.op == ТОК2.assign &&
                t1.ty == Tarray && t2.ty == Tsarray &&
                e2x.op != ТОК2.slice &&
                t2.implicitConvTo(t1))
            {
                // Disallow ar[] = sa (Converted to ar[] = sa[])
                // Disallow da   = sa (Converted to da   = sa[])
                ткст0 e1str = exp.e1.вТкст0();
                ткст0 e2str = e2x.вТкст0();
                ткст0 atypestr = exp.e1.op == ТОК2.slice ? "element-wise" : "slice";
                exp.warning("explicit %s assignment `%s = (%s)[]` is better than `%s = %s`", atypestr, e1str, e2str, e1str, e2str);
            }
            if (exp.op == ТОК2.blit)
                e2x = e2x.castTo(sc, exp.e1.тип);
            else
            {
                e2x = e2x.implicitCastTo(sc, exp.e1.тип);

                // Fix Issue 13435: https://issues.dlang.org/show_bug.cgi?ид=13435

                // If the implicit cast has failed and the assign Выражение is
                // the initialization of a struct member field
                if (e2x.op == ТОК2.error && exp.op == ТОК2.construct && t1.ty == Tstruct)
                {
                    scope sd = (cast(TypeStruct)t1).sym;
                    ДСимвол opAssign = search_function(sd, Id.assign);

                    // and the struct defines an opAssign
                    if (opAssign)
                    {
                        // offer more information about the cause of the problem
                        errorSupplemental(exp.место,
                                          "`%s` is the first assignment of `%s` therefore it represents its initialization",
                                          exp.вТкст0(), exp.e1.вТкст0());
                        errorSupplemental(exp.место,
                                          "`opAssign` methods are not используется for initialization, but for subsequent assignments");
                    }
                }
            }
        }
        if (e2x.op == ТОК2.error)
        {
            результат = e2x;
            return;
        }
        exp.e2 = e2x;
        t2 = exp.e2.тип.toBasetype();

        /* Look for массив operations
         */
        if ((t2.ty == Tarray || t2.ty == Tsarray) && isArrayOpValid(exp.e2))
        {
            // Look for valid массив operations
            if (!(exp.memset & MemorySet.blockAssign) &&
                exp.e1.op == ТОК2.slice &&
                (isUnaArrayOp(exp.e2.op) || isBinArrayOp(exp.e2.op)))
            {
                exp.тип = exp.e1.тип;
                if (exp.op == ТОК2.construct) // https://issues.dlang.org/show_bug.cgi?ид=10282
                                        // tweak mutability of e1 element
                    exp.e1.тип = exp.e1.тип.nextOf().mutableOf().arrayOf();
                результат = arrayOp(exp, sc);
                return;
            }

            // Drop invalid массив operations in e2
            //  d = a[] + b[], d = (a[] + b[])[0..2], etc
            if (checkNonAssignmentArrayOp(exp.e2, !(exp.memset & MemorySet.blockAssign) && exp.op == ТОК2.assign))
                return setError();

            // Remains valid массив assignments
            //  d = d[], d = [1,2,3], etc
        }

        /* Don't allow assignment to classes that were allocated on the stack with:
         *      scope Class c = new Class();
         */
        if (exp.e1.op == ТОК2.variable && exp.op == ТОК2.assign)
        {
            VarExp ve = cast(VarExp)exp.e1;
            VarDeclaration vd = ve.var.isVarDeclaration();
            if (vd && (vd.onstack || vd.mynew))
            {
                assert(t1.ty == Tclass);
                exp.выведиОшибку("cannot rebind scope variables");
            }
        }

        if (exp.e1.op == ТОК2.variable && (cast(VarExp)exp.e1).var.идент == Id.ctfe)
        {
            exp.выведиОшибку("cannot modify compiler-generated variable `__ctfe`");
        }

        exp.тип = exp.e1.тип;
        assert(exp.тип);
        auto res = exp.op == ТОК2.assign ? exp.reorderSettingAAElem(sc) : exp;
        checkAssignEscape(sc, res, нет);
        return setрезультат(res);
    }

    override проц посети(PowAssignExp exp)
    {
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        if (exp.e1.checkReadModifyWrite(exp.op, exp.e2))
            return setError();

        assert(exp.e1.тип && exp.e2.тип);
        if (exp.e1.op == ТОК2.slice || exp.e1.тип.ty == Tarray || exp.e1.тип.ty == Tsarray)
        {
            if (checkNonAssignmentArrayOp(exp.e1))
                return setError();

            // T[] ^^= ...
            if (exp.e2.implicitConvTo(exp.e1.тип.nextOf()))
            {
                // T[] ^^= T
                exp.e2 = exp.e2.castTo(sc, exp.e1.тип.nextOf());
            }
            else if (Выражение ex = typeCombine(exp, sc))
            {
                результат = ex;
                return;
            }

            // Check element types are arithmetic
            Тип tb1 = exp.e1.тип.nextOf().toBasetype();
            Тип tb2 = exp.e2.тип.toBasetype();
            if (tb2.ty == Tarray || tb2.ty == Tsarray)
                tb2 = tb2.nextOf().toBasetype();
            if ((tb1.isintegral() || tb1.isfloating()) && (tb2.isintegral() || tb2.isfloating()))
            {
                exp.тип = exp.e1.тип;
                результат = arrayOp(exp, sc);
                return;
            }
        }
        else
        {
            exp.e1 = exp.e1.modifiableLvalue(sc, exp.e1);
        }

        if ((exp.e1.тип.isintegral() || exp.e1.тип.isfloating()) && (exp.e2.тип.isintegral() || exp.e2.тип.isfloating()))
        {
            Выражение e0 = null;
            e = exp.reorderSettingAAElem(sc);
            e = Выражение.extractLast(e, e0);
            assert(e == exp);

            if (exp.e1.op == ТОК2.variable)
            {
                // Rewrite: e1 = e1 ^^ e2
                e = new PowExp(exp.место, exp.e1.syntaxCopy(), exp.e2);
                e = new AssignExp(exp.место, exp.e1, e);
            }
            else
            {
                // Rewrite: ref tmp = e1; tmp = tmp ^^ e2
                auto v = copyToTemp(STC.ref_, "__powtmp", exp.e1);
                auto de = new DeclarationExp(exp.e1.место, v);
                auto ve = new VarExp(exp.e1.место, v);
                e = new PowExp(exp.место, ve, exp.e2);
                e = new AssignExp(exp.место, new VarExp(exp.e1.место, v), e);
                e = new CommaExp(exp.место, de, e);
            }
            e = Выражение.combine(e0, e);
            e = e.ВыражениеSemantic(sc);
            результат = e;
            return;
        }
        результат = exp.incompatibleTypes();
    }

    override проц посети(CatAssignExp exp)
    {
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        //printf("CatAssignExp::semantic() %s\n", exp.вТкст0());
        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        if (exp.e1.op == ТОК2.slice)
        {
            SliceExp se = cast(SliceExp)exp.e1;
            if (se.e1.тип.toBasetype().ty == Tsarray)
            {
                exp.выведиОшибку("cannot приставь to static массив `%s`", se.e1.тип.вТкст0());
                return setError();
            }
        }

        if (checkIfIsStructLiteralDotExpr(exp.e1))
            return setError();

        exp.e1 = exp.e1.modifiableLvalue(sc, exp.e1);
        if (exp.e1.op == ТОК2.error)
        {
            результат = exp.e1;
            return;
        }
        if (exp.e2.op == ТОК2.error)
        {
            результат = exp.e2;
            return;
        }

        if (checkNonAssignmentArrayOp(exp.e2))
            return setError();

        Тип tb1 = exp.e1.тип.toBasetype();
        Тип tb1next = tb1.nextOf();
        Тип tb2 = exp.e2.тип.toBasetype();

        /* Possibilities:
         * ТОК2.concatenateAssign: appending T[] to T[]
         * ТОК2.concatenateElemAssign: appending T to T[]
         * ТОК2.concatenateDcharAssign: appending dchar to T[]
         */
        if ((tb1.ty == Tarray) &&
            (tb2.ty == Tarray || tb2.ty == Tsarray) &&
            (exp.e2.implicitConvTo(exp.e1.тип) ||
             (tb2.nextOf().implicitConvTo(tb1next) &&
              (tb2.nextOf().size(Место.initial) == tb1next.size(Место.initial)))))
        {
            // ТОК2.concatenateAssign
            assert(exp.op == ТОК2.concatenateAssign);
            if (exp.e1.checkPostblit(sc, tb1next))
                return setError();

            exp.e2 = exp.e2.castTo(sc, exp.e1.тип);
        }
        else if ((tb1.ty == Tarray) && exp.e2.implicitConvTo(tb1next))
        {
            /* https://issues.dlang.org/show_bug.cgi?ид=19782
             *
             * If e2 is implicitly convertible to tb1next, the conversion
             * might be done through alias this, in which case, e2 needs to
             * be modified accordingly (e2 => e2.aliasthis).
             */
            if (tb2.ty == Tstruct && (cast(TypeStruct)tb2).implicitConvToThroughAliasThis(tb1next))
                goto Laliasthis;
            if (tb2.ty == Tclass && (cast(TypeClass)tb2).implicitConvToThroughAliasThis(tb1next))
                goto Laliasthis;
            // Append element
            if (exp.e2.checkPostblit(sc, tb2))
                return setError();

            if (checkNewEscape(sc, exp.e2, нет))
                return setError();

            exp = new CatElemAssignExp(exp.место, exp.тип, exp.e1, exp.e2.castTo(sc, tb1next));
            exp.e2 = doCopyOrMove(sc, exp.e2);
        }
        else if (tb1.ty == Tarray &&
                 (tb1next.ty == Tchar || tb1next.ty == Twchar) &&
                 exp.e2.тип.ty != tb1next.ty &&
                 exp.e2.implicitConvTo(Тип.tdchar))
        {
            // Append dchar to ткст or wткст
            exp = new CatDcharAssignExp(exp.место, exp.тип, exp.e1, exp.e2.castTo(sc, Тип.tdchar));

            /* Do not allow appending wchar to ткст because if wchar happens
             * to be a surrogate pair, nothing good can результат.
             */
        }
        else
        {
            // Try alias this on first operand
            static Выражение tryAliasThisForLhs(BinAssignExp exp, Scope* sc)
            {
                AggregateDeclaration ad1 = isAggregate(exp.e1.тип);
                if (!ad1 || !ad1.aliasthis)
                    return null;

                /* Rewrite (e1 op e2) as:
                 *      (e1.aliasthis op e2)
                 */
                if (exp.att1 && exp.e1.тип == exp.att1)
                    return null;
                //printf("att %s e1 = %s\n", Сема2::вТкст0(e.op), e.e1.тип.вТкст0());
                Выражение e1 = new DotIdExp(exp.место, exp.e1, ad1.aliasthis.идент);
                BinExp be = cast(BinExp)exp.копируй();
                if (!be.att1 && exp.e1.тип.checkAliasThisRec())
                    be.att1 = exp.e1.тип;
                be.e1 = e1;
                return be.trySemantic(sc);
            }

            // Try alias this on second operand
            static Выражение tryAliasThisForRhs(BinAssignExp exp, Scope* sc)
            {
                AggregateDeclaration ad2 = isAggregate(exp.e2.тип);
                if (!ad2 || !ad2.aliasthis)
                    return null;
                /* Rewrite (e1 op e2) as:
                 *      (e1 op e2.aliasthis)
                 */
                if (exp.att2 && exp.e2.тип == exp.att2)
                    return null;
                //printf("att %s e2 = %s\n", Сема2::вТкст0(e.op), e.e2.тип.вТкст0());
                Выражение e2 = new DotIdExp(exp.место, exp.e2, ad2.aliasthis.идент);
                BinExp be = cast(BinExp)exp.копируй();
                if (!be.att2 && exp.e2.тип.checkAliasThisRec())
                    be.att2 = exp.e2.тип;
                be.e2 = e2;
                return be.trySemantic(sc);
            }

    Laliasthis:
            результат = tryAliasThisForLhs(exp, sc);
            if (результат)
                return;

            результат = tryAliasThisForRhs(exp, sc);
            if (результат)
                return;

            exp.выведиОшибку("cannot приставь тип `%s` to тип `%s`", tb2.вТкст0(), tb1.вТкст0());
            return setError();
        }

        if (exp.e2.checkValue() || exp.e2.checkSharedAccess(sc))
            return setError();

        exp.тип = exp.e1.тип;
        auto res = exp.reorderSettingAAElem(sc);
        if ((exp.op == ТОК2.concatenateElemAssign || exp.op == ТОК2.concatenateDcharAssign) && глоб2.парамы.vsafe)
            checkAssignEscape(sc, res, нет);
        результат = res;
    }

    override проц посети(AddExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("AddExp::semantic('%s')\n", exp.вТкст0());
        }
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (Выражение ex = binSemanticProp(exp, sc))
        {
            результат = ex;
            return;
        }
        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        Тип tb1 = exp.e1.тип.toBasetype();
        Тип tb2 = exp.e2.тип.toBasetype();

        бул err = нет;
        if (tb1.ty == Tdelegate || tb1.ty == Tpointer && tb1.nextOf().ty == Tfunction)
        {
            err |= exp.e1.checkArithmetic() || exp.e1.checkSharedAccess(sc);
        }
        if (tb2.ty == Tdelegate || tb2.ty == Tpointer && tb2.nextOf().ty == Tfunction)
        {
            err |= exp.e2.checkArithmetic() || exp.e2.checkSharedAccess(sc);
        }
        if (err)
            return setError();

        if (tb1.ty == Tpointer && exp.e2.тип.isintegral() || tb2.ty == Tpointer && exp.e1.тип.isintegral())
        {
            результат = scaleFactor(exp, sc);
            return;
        }

        if (tb1.ty == Tpointer && tb2.ty == Tpointer)
        {
            результат = exp.incompatibleTypes();
            return;
        }

        if (Выражение ex = typeCombine(exp, sc))
        {
            результат = ex;
            return;
        }

        Тип tb = exp.тип.toBasetype();
        if (tb.ty == Tarray || tb.ty == Tsarray)
        {
            if (!isArrayOpValid(exp))
            {
                результат = arrayOpInvalidError(exp);
                return;
            }
            результат = exp;
            return;
        }

        tb1 = exp.e1.тип.toBasetype();
        if (!target.isVectorOpSupported(tb1, exp.op, tb2))
        {
            результат = exp.incompatibleTypes();
            return;
        }
        if ((tb1.isreal() && exp.e2.тип.isimaginary()) || (tb1.isimaginary() && exp.e2.тип.isreal()))
        {
            switch (exp.тип.toBasetype().ty)
            {
            case Tfloat32:
            case Timaginary32:
                exp.тип = Тип.tcomplex32;
                break;

            case Tfloat64:
            case Timaginary64:
                exp.тип = Тип.tcomplex64;
                break;

            case Tfloat80:
            case Timaginary80:
                exp.тип = Тип.tcomplex80;
                break;

            default:
                assert(0);
            }
        }
        результат = exp;
    }

    override проц посети(MinExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("MinExp::semantic('%s')\n", exp.вТкст0());
        }
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (Выражение ex = binSemanticProp(exp, sc))
        {
            результат = ex;
            return;
        }
        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        Тип t1 = exp.e1.тип.toBasetype();
        Тип t2 = exp.e2.тип.toBasetype();

        бул err = нет;
        if (t1.ty == Tdelegate || t1.ty == Tpointer && t1.nextOf().ty == Tfunction)
        {
            err |= exp.e1.checkArithmetic() || exp.e1.checkSharedAccess(sc);
        }
        if (t2.ty == Tdelegate || t2.ty == Tpointer && t2.nextOf().ty == Tfunction)
        {
            err |= exp.e2.checkArithmetic() || exp.e2.checkSharedAccess(sc);
        }
        if (err)
            return setError();

        if (t1.ty == Tpointer)
        {
            if (t2.ty == Tpointer)
            {
                // https://dlang.org/spec/Выражение.html#add_Выражениеs
                // "If both operands are pointers, and the operator is -, the pointers are
                // subtracted and the результат is divided by the size of the тип pointed to
                // by the operands. It is an error if the pointers point to different types."
                Тип p1 = t1.nextOf();
                Тип p2 = t2.nextOf();

                if (!p1.equivalent(p2))
                {
                    // Deprecation to remain for at least a year, after which this should be
                    // changed to an error
                    // See https://github.com/dlang/dmd/pull/7332
                    deprecation(exp.место,
                        "cannot subtract pointers to different types: `%s` and `%s`.",
                        t1.вТкст0(), t2.вТкст0());
                }

                // Need to divide the результат by the stride
                // Replace (ptr - ptr) with (ptr - ptr) / stride
                d_int64 stride;

                // make sure pointer types are compatible
                if (Выражение ex = typeCombine(exp, sc))
                {
                    результат = ex;
                    return;
                }

                exp.тип = Тип.tptrdiff_t;
                stride = t2.nextOf().size();
                if (stride == 0)
                {
                    e = new IntegerExp(exp.место, 0, Тип.tptrdiff_t);
                }
                else
                {
                    e = new DivExp(exp.место, exp, new IntegerExp(Место.initial, stride, Тип.tptrdiff_t));
                    e.тип = Тип.tptrdiff_t;
                }
            }
            else if (t2.isintegral())
                e = scaleFactor(exp, sc);
            else
            {
                exp.выведиОшибку("can't subtract `%s` from pointer", t2.вТкст0());
                e = new ErrorExp();
            }
            результат = e;
            return;
        }
        if (t2.ty == Tpointer)
        {
            exp.тип = exp.e2.тип;
            exp.выведиОшибку("can't subtract pointer from `%s`", exp.e1.тип.вТкст0());
            return setError();
        }

        if (Выражение ex = typeCombine(exp, sc))
        {
            результат = ex;
            return;
        }

        Тип tb = exp.тип.toBasetype();
        if (tb.ty == Tarray || tb.ty == Tsarray)
        {
            if (!isArrayOpValid(exp))
            {
                результат = arrayOpInvalidError(exp);
                return;
            }
            результат = exp;
            return;
        }

        t1 = exp.e1.тип.toBasetype();
        t2 = exp.e2.тип.toBasetype();
        if (!target.isVectorOpSupported(t1, exp.op, t2))
        {
            результат = exp.incompatibleTypes();
            return;
        }
        if ((t1.isreal() && t2.isimaginary()) || (t1.isimaginary() && t2.isreal()))
        {
            switch (exp.тип.ty)
            {
            case Tfloat32:
            case Timaginary32:
                exp.тип = Тип.tcomplex32;
                break;

            case Tfloat64:
            case Timaginary64:
                exp.тип = Тип.tcomplex64;
                break;

            case Tfloat80:
            case Timaginary80:
                exp.тип = Тип.tcomplex80;
                break;

            default:
                assert(0);
            }
        }
        результат = exp;
        return;
    }

    override проц посети(CatExp exp)
    {
        // https://dlang.org/spec/Выражение.html#cat_Выражениеs
        //printf("CatExp.semantic() %s\n", вТкст0());
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (Выражение ex = binSemanticProp(exp, sc))
        {
            результат = ex;
            return;
        }
        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        Тип tb1 = exp.e1.тип.toBasetype();
        Тип tb2 = exp.e2.тип.toBasetype();

        auto f1 = checkNonAssignmentArrayOp(exp.e1);
        auto f2 = checkNonAssignmentArrayOp(exp.e2);
        if (f1 || f2)
            return setError();

        /* BUG: Should handle things like:
         *      сим c;
         *      c ~ ' '
         *      ' ' ~ c;
         */

        Тип tb1next = tb1.nextOf();
        Тип tb2next = tb2.nextOf();

        // Check for: массив ~ массив
        if (tb1next && tb2next && (tb1next.implicitConvTo(tb2next) >= MATCH.constant || tb2next.implicitConvTo(tb1next) >= MATCH.constant || exp.e1.op == ТОК2.arrayLiteral && exp.e1.implicitConvTo(tb2) || exp.e2.op == ТОК2.arrayLiteral && exp.e2.implicitConvTo(tb1)))
        {
            /* https://issues.dlang.org/show_bug.cgi?ид=9248
             * Here to avoid the case of:
             *    ук[] a = [cast(ук)1];
             *    ук[] b = [cast(ук)2];
             *    a ~ b;
             * becoming:
             *    a ~ [cast(ук)b];
             */

            /* https://issues.dlang.org/show_bug.cgi?ид=14682
             * Also to avoid the case of:
             *    цел[][] a;
             *    a ~ [];
             * becoming:
             *    a ~ cast(цел[])[];
             */
            goto Lpeer;
        }

        // Check for: массив ~ element
        if ((tb1.ty == Tsarray || tb1.ty == Tarray) && tb2.ty != Tvoid)
        {
            if (exp.e1.op == ТОК2.arrayLiteral)
            {
                exp.e2 = doCopyOrMove(sc, exp.e2);
                // https://issues.dlang.org/show_bug.cgi?ид=14686
                // Postblit call appears in AST, and this is
                // finally translated  to an ArrayLiteralExp in below optimize().
            }
            else if (exp.e1.op == ТОК2.string_)
            {
                // No postblit call exists on character (integer) значение.
            }
            else
            {
                if (exp.e2.checkPostblit(sc, tb2))
                    return setError();
                // Postblit call will be done in runtime helper function
            }

            if (exp.e1.op == ТОК2.arrayLiteral && exp.e1.implicitConvTo(tb2.arrayOf()))
            {
                exp.e1 = exp.e1.implicitCastTo(sc, tb2.arrayOf());
                exp.тип = tb2.arrayOf();
                goto L2elem;
            }
            if (exp.e2.implicitConvTo(tb1next) >= MATCH.convert)
            {
                exp.e2 = exp.e2.implicitCastTo(sc, tb1next);
                exp.тип = tb1next.arrayOf();
            L2elem:
                if (tb2.ty == Tarray || tb2.ty == Tsarray)
                {
                    // Make e2 into [e2]
                    exp.e2 = new ArrayLiteralExp(exp.e2.место, exp.тип, exp.e2);
                }
                else if (checkNewEscape(sc, exp.e2, нет))
                    return setError();
                результат = exp.optimize(WANTvalue);
                return;
            }
        }
        // Check for: element ~ массив
        if ((tb2.ty == Tsarray || tb2.ty == Tarray) && tb1.ty != Tvoid)
        {
            if (exp.e2.op == ТОК2.arrayLiteral)
            {
                exp.e1 = doCopyOrMove(sc, exp.e1);
            }
            else if (exp.e2.op == ТОК2.string_)
            {
            }
            else
            {
                if (exp.e1.checkPostblit(sc, tb1))
                    return setError();
            }

            if (exp.e2.op == ТОК2.arrayLiteral && exp.e2.implicitConvTo(tb1.arrayOf()))
            {
                exp.e2 = exp.e2.implicitCastTo(sc, tb1.arrayOf());
                exp.тип = tb1.arrayOf();
                goto L1elem;
            }
            if (exp.e1.implicitConvTo(tb2next) >= MATCH.convert)
            {
                exp.e1 = exp.e1.implicitCastTo(sc, tb2next);
                exp.тип = tb2next.arrayOf();
            L1elem:
                if (tb1.ty == Tarray || tb1.ty == Tsarray)
                {
                    // Make e1 into [e1]
                    exp.e1 = new ArrayLiteralExp(exp.e1.место, exp.тип, exp.e1);
                }
                else if (checkNewEscape(sc, exp.e1, нет))
                    return setError();
                результат = exp.optimize(WANTvalue);
                return;
            }
        }

    Lpeer:
        if ((tb1.ty == Tsarray || tb1.ty == Tarray) && (tb2.ty == Tsarray || tb2.ty == Tarray) && (tb1next.mod || tb2next.mod) && (tb1next.mod != tb2next.mod))
        {
            Тип t1 = tb1next.mutableOf().constOf().arrayOf();
            Тип t2 = tb2next.mutableOf().constOf().arrayOf();
            if (exp.e1.op == ТОК2.string_ && !(cast(StringExp)exp.e1).committed)
                exp.e1.тип = t1;
            else
                exp.e1 = exp.e1.castTo(sc, t1);
            if (exp.e2.op == ТОК2.string_ && !(cast(StringExp)exp.e2).committed)
                exp.e2.тип = t2;
            else
                exp.e2 = exp.e2.castTo(sc, t2);
        }

        if (Выражение ex = typeCombine(exp, sc))
        {
            результат = ex;
            return;
        }
        exp.тип = exp.тип.toHeadMutable();

        Тип tb = exp.тип.toBasetype();
        if (tb.ty == Tsarray)
            exp.тип = tb.nextOf().arrayOf();
        if (exp.тип.ty == Tarray && tb1next && tb2next && tb1next.mod != tb2next.mod)
        {
            exp.тип = exp.тип.nextOf().toHeadMutable().arrayOf();
        }
        if (Тип tbn = tb.nextOf())
        {
            if (exp.checkPostblit(sc, tbn))
                return setError();
        }
        Тип t1 = exp.e1.тип.toBasetype();
        Тип t2 = exp.e2.тип.toBasetype();
        if ((t1.ty == Tarray || t1.ty == Tsarray) &&
            (t2.ty == Tarray || t2.ty == Tsarray))
        {
            // Normalize to ArrayLiteralExp or StringExp as far as possible
            e = exp.optimize(WANTvalue);
        }
        else
        {
            //printf("(%s) ~ (%s)\n", e1.вТкст0(), e2.вТкст0());
            результат = exp.incompatibleTypes();
            return;
        }

        результат = e;
    }

    override проц посети(MulExp exp)
    {
        version (none)
        {
            printf("MulExp::semantic() %s\n", exp.вТкст0());
        }
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (Выражение ex = binSemanticProp(exp, sc))
        {
            результат = ex;
            return;
        }
        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        if (Выражение ex = typeCombine(exp, sc))
        {
            результат = ex;
            return;
        }

        Тип tb = exp.тип.toBasetype();
        if (tb.ty == Tarray || tb.ty == Tsarray)
        {
            if (!isArrayOpValid(exp))
            {
                результат = arrayOpInvalidError(exp);
                return;
            }
            результат = exp;
            return;
        }

        if (exp.checkArithmeticBin() || exp.checkSharedAccessBin(sc))
            return setError();

        if (exp.тип.isfloating())
        {
            Тип t1 = exp.e1.тип;
            Тип t2 = exp.e2.тип;

            if (t1.isreal())
            {
                exp.тип = t2;
            }
            else if (t2.isreal())
            {
                exp.тип = t1;
            }
            else if (t1.isimaginary())
            {
                if (t2.isimaginary())
                {
                    switch (t1.toBasetype().ty)
                    {
                    case Timaginary32:
                        exp.тип = Тип.tfloat32;
                        break;

                    case Timaginary64:
                        exp.тип = Тип.tfloat64;
                        break;

                    case Timaginary80:
                        exp.тип = Тип.tfloat80;
                        break;

                    default:
                        assert(0);
                    }

                    // iy * iv = -yv
                    exp.e1.тип = exp.тип;
                    exp.e2.тип = exp.тип;
                    e = new NegExp(exp.место, exp);
                    e = e.ВыражениеSemantic(sc);
                    результат = e;
                    return;
                }
                else
                    exp.тип = t2; // t2 is complex
            }
            else if (t2.isimaginary())
            {
                exp.тип = t1; // t1 is complex
            }
        }
        else if (!target.isVectorOpSupported(tb, exp.op, exp.e2.тип.toBasetype()))
        {
            результат = exp.incompatibleTypes();
            return;
        }
        результат = exp;
    }

    override проц посети(DivExp exp)
    {
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (Выражение ex = binSemanticProp(exp, sc))
        {
            результат = ex;
            return;
        }
        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        if (Выражение ex = typeCombine(exp, sc))
        {
            результат = ex;
            return;
        }

        Тип tb = exp.тип.toBasetype();
        if (tb.ty == Tarray || tb.ty == Tsarray)
        {
            if (!isArrayOpValid(exp))
            {
                результат = arrayOpInvalidError(exp);
                return;
            }
            результат = exp;
            return;
        }

        if (exp.checkArithmeticBin() || exp.checkSharedAccessBin(sc))
            return setError();

        if (exp.тип.isfloating())
        {
            Тип t1 = exp.e1.тип;
            Тип t2 = exp.e2.тип;

            if (t1.isreal())
            {
                exp.тип = t2;
                if (t2.isimaginary())
                {
                    // x/iv = i(-x/v)
                    exp.e2.тип = t1;
                    e = new NegExp(exp.место, exp);
                    e = e.ВыражениеSemantic(sc);
                    результат = e;
                    return;
                }
            }
            else if (t2.isreal())
            {
                exp.тип = t1;
            }
            else if (t1.isimaginary())
            {
                if (t2.isimaginary())
                {
                    switch (t1.toBasetype().ty)
                    {
                    case Timaginary32:
                        exp.тип = Тип.tfloat32;
                        break;

                    case Timaginary64:
                        exp.тип = Тип.tfloat64;
                        break;

                    case Timaginary80:
                        exp.тип = Тип.tfloat80;
                        break;

                    default:
                        assert(0);
                    }
                }
                else
                    exp.тип = t2; // t2 is complex
            }
            else if (t2.isimaginary())
            {
                exp.тип = t1; // t1 is complex
            }
        }
        else if (!target.isVectorOpSupported(tb, exp.op, exp.e2.тип.toBasetype()))
        {
            результат = exp.incompatibleTypes();
            return;
        }
        результат = exp;
    }

    override проц посети(ModExp exp)
    {
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (Выражение ex = binSemanticProp(exp, sc))
        {
            результат = ex;
            return;
        }
        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        if (Выражение ex = typeCombine(exp, sc))
        {
            результат = ex;
            return;
        }

        Тип tb = exp.тип.toBasetype();
        if (tb.ty == Tarray || tb.ty == Tsarray)
        {
            if (!isArrayOpValid(exp))
            {
                результат = arrayOpInvalidError(exp);
                return;
            }
            результат = exp;
            return;
        }
        if (!target.isVectorOpSupported(tb, exp.op, exp.e2.тип.toBasetype()))
        {
            результат = exp.incompatibleTypes();
            return;
        }

        if (exp.checkArithmeticBin() || exp.checkSharedAccessBin(sc))
            return setError();

        if (exp.тип.isfloating())
        {
            exp.тип = exp.e1.тип;
            if (exp.e2.тип.iscomplex())
            {
                exp.выведиОшибку("cannot perform modulo complex arithmetic");
                return setError();
            }
        }
        результат = exp;
    }

    override проц посети(PowExp exp)
    {
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        //printf("PowExp::semantic() %s\n", вТкст0());
        if (Выражение ex = binSemanticProp(exp, sc))
        {
            результат = ex;
            return;
        }
        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        if (Выражение ex = typeCombine(exp, sc))
        {
            результат = ex;
            return;
        }

        Тип tb = exp.тип.toBasetype();
        if (tb.ty == Tarray || tb.ty == Tsarray)
        {
            if (!isArrayOpValid(exp))
            {
                результат = arrayOpInvalidError(exp);
                return;
            }
            результат = exp;
            return;
        }

        if (exp.checkArithmeticBin() || exp.checkSharedAccessBin(sc))
            return setError();

        if (!target.isVectorOpSupported(tb, exp.op, exp.e2.тип.toBasetype()))
        {
            результат = exp.incompatibleTypes();
            return;
        }

        // First, attempt to fold the Выражение.
        e = exp.optimize(WANTvalue);
        if (e.op != ТОК2.pow)
        {
            e = e.ВыражениеSemantic(sc);
            результат = e;
            return;
        }

        Module mmath = loadStdMath();
        if (!mmath)
        {
            e.выведиОшибку("`%s` requires `std.math` for `^^` operators", e.вТкст0());
            return setError();
        }
        e = new ScopeExp(exp.место, mmath);

        if (exp.e2.op == ТОК2.float64 && exp.e2.toReal() == CTFloat.half)
        {
            // Replace e1 ^^ 0.5 with .std.math.sqrt(e1)
            e = new CallExp(exp.место, new DotIdExp(exp.место, e, Id._sqrt), exp.e1);
        }
        else
        {
            // Replace e1 ^^ e2 with .std.math.pow(e1, e2)
            e = new CallExp(exp.место, new DotIdExp(exp.место, e, Id._pow), exp.e1, exp.e2);
        }
        e = e.ВыражениеSemantic(sc);
        результат = e;
        return;
    }

    override проц посети(ShlExp exp)
    {
        //printf("ShlExp::semantic(), тип = %p\n", тип);
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (Выражение ex = binSemanticProp(exp, sc))
        {
            результат = ex;
            return;
        }
        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        if (exp.checkIntegralBin() || exp.checkSharedAccessBin(sc))
            return setError();

        if (!target.isVectorOpSupported(exp.e1.тип.toBasetype(), exp.op, exp.e2.тип.toBasetype()))
        {
            результат = exp.incompatibleTypes();
            return;
        }
        exp.e1 = integralPromotions(exp.e1, sc);
        if (exp.e2.тип.toBasetype().ty != Tvector)
            exp.e2 = exp.e2.castTo(sc, Тип.tshiftcnt);

        exp.тип = exp.e1.тип;
        результат = exp;
    }

    override проц посети(ShrExp exp)
    {
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (Выражение ex = binSemanticProp(exp, sc))
        {
            результат = ex;
            return;
        }
        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        if (exp.checkIntegralBin() || exp.checkSharedAccessBin(sc))
            return setError();

        if (!target.isVectorOpSupported(exp.e1.тип.toBasetype(), exp.op, exp.e2.тип.toBasetype()))
        {
            результат = exp.incompatibleTypes();
            return;
        }
        exp.e1 = integralPromotions(exp.e1, sc);
        if (exp.e2.тип.toBasetype().ty != Tvector)
            exp.e2 = exp.e2.castTo(sc, Тип.tshiftcnt);

        exp.тип = exp.e1.тип;
        результат = exp;
    }

    override проц посети(UshrExp exp)
    {
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (Выражение ex = binSemanticProp(exp, sc))
        {
            результат = ex;
            return;
        }
        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        if (exp.checkIntegralBin() || exp.checkSharedAccessBin(sc))
            return setError();

        if (!target.isVectorOpSupported(exp.e1.тип.toBasetype(), exp.op, exp.e2.тип.toBasetype()))
        {
            результат = exp.incompatibleTypes();
            return;
        }
        exp.e1 = integralPromotions(exp.e1, sc);
        if (exp.e2.тип.toBasetype().ty != Tvector)
            exp.e2 = exp.e2.castTo(sc, Тип.tshiftcnt);

        exp.тип = exp.e1.тип;
        результат = exp;
    }

    override проц посети(AndExp exp)
    {
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (Выражение ex = binSemanticProp(exp, sc))
        {
            результат = ex;
            return;
        }
        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        if (exp.e1.тип.toBasetype().ty == Tbool && exp.e2.тип.toBasetype().ty == Tbool)
        {
            exp.тип = exp.e1.тип;
            результат = exp;
            return;
        }

        if (Выражение ex = typeCombine(exp, sc))
        {
            результат = ex;
            return;
        }

        Тип tb = exp.тип.toBasetype();
        if (tb.ty == Tarray || tb.ty == Tsarray)
        {
            if (!isArrayOpValid(exp))
            {
                результат = arrayOpInvalidError(exp);
                return;
            }
            результат = exp;
            return;
        }
        if (!target.isVectorOpSupported(tb, exp.op, exp.e2.тип.toBasetype()))
        {
            результат = exp.incompatibleTypes();
            return;
        }
        if (exp.checkIntegralBin() || exp.checkSharedAccessBin(sc))
            return setError();

        результат = exp;
    }

    override проц посети(OrExp exp)
    {
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (Выражение ex = binSemanticProp(exp, sc))
        {
            результат = ex;
            return;
        }
        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        if (exp.e1.тип.toBasetype().ty == Tbool && exp.e2.тип.toBasetype().ty == Tbool)
        {
            exp.тип = exp.e1.тип;
            результат = exp;
            return;
        }

        if (Выражение ex = typeCombine(exp, sc))
        {
            результат = ex;
            return;
        }

        Тип tb = exp.тип.toBasetype();
        if (tb.ty == Tarray || tb.ty == Tsarray)
        {
            if (!isArrayOpValid(exp))
            {
                результат = arrayOpInvalidError(exp);
                return;
            }
            результат = exp;
            return;
        }
        if (!target.isVectorOpSupported(tb, exp.op, exp.e2.тип.toBasetype()))
        {
            результат = exp.incompatibleTypes();
            return;
        }
        if (exp.checkIntegralBin() || exp.checkSharedAccessBin(sc))
            return setError();

        результат = exp;
    }

    override проц посети(XorExp exp)
    {
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (Выражение ex = binSemanticProp(exp, sc))
        {
            результат = ex;
            return;
        }
        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        if (exp.e1.тип.toBasetype().ty == Tbool && exp.e2.тип.toBasetype().ty == Tbool)
        {
            exp.тип = exp.e1.тип;
            результат = exp;
            return;
        }

        if (Выражение ex = typeCombine(exp, sc))
        {
            результат = ex;
            return;
        }

        Тип tb = exp.тип.toBasetype();
        if (tb.ty == Tarray || tb.ty == Tsarray)
        {
            if (!isArrayOpValid(exp))
            {
                результат = arrayOpInvalidError(exp);
                return;
            }
            результат = exp;
            return;
        }
        if (!target.isVectorOpSupported(tb, exp.op, exp.e2.тип.toBasetype()))
        {
            результат = exp.incompatibleTypes();
            return;
        }
        if (exp.checkIntegralBin() || exp.checkSharedAccessBin(sc))
            return setError();

        результат = exp;
    }

    override проц посети(LogicalExp exp)
    {
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        exp.setNoderefOperands();

        Выражение e1x = exp.e1.ВыражениеSemantic(sc);

        // for static alias this: https://issues.dlang.org/show_bug.cgi?ид=17684
        if (e1x.op == ТОК2.тип)
            e1x = resolveAliasThis(sc, e1x);

        e1x = resolveProperties(sc, e1x);
        e1x = e1x.toBoolean(sc);

        if (sc.flags & SCOPE.условие)
        {
            /* If in static if, don't evaluate e2 if we don't have to.
             */
            e1x = e1x.optimize(WANTvalue);
            if (e1x.isBool(exp.op == ТОК2.orOr))
            {
                результат = IntegerExp.createBool(exp.op == ТОК2.orOr);
                return;
            }
        }

        CtorFlow ctorflow = sc.ctorflow.clone();
        Выражение e2x = exp.e2.ВыражениеSemantic(sc);
        sc.merge(exp.место, ctorflow);
        ctorflow.freeFieldinit();

        // for static alias this: https://issues.dlang.org/show_bug.cgi?ид=17684
        if (e2x.op == ТОК2.тип)
            e2x = resolveAliasThis(sc, e2x);

        e2x = resolveProperties(sc, e2x);

        auto f1 = checkNonAssignmentArrayOp(e1x);
        auto f2 = checkNonAssignmentArrayOp(e2x);
        if (f1 || f2)
            return setError();

        // Unless the right operand is 'проц', the Выражение is converted to 'бул'.
        if (e2x.тип.ty != Tvoid)
            e2x = e2x.toBoolean(sc);

        if (e2x.op == ТОК2.тип || e2x.op == ТОК2.scope_)
        {
            exp.выведиОшибку("`%s` is not an Выражение", exp.e2.вТкст0());
            return setError();
        }
        if (e1x.op == ТОК2.error)
        {
            результат = e1x;
            return;
        }
        if (e2x.op == ТОК2.error)
        {
            результат = e2x;
            return;
        }

        // The результат тип is 'бул', unless the right operand has тип 'проц'.
        if (e2x.тип.ty == Tvoid)
            exp.тип = Тип.tvoid;
        else
            exp.тип = Тип.tбул;

        exp.e1 = e1x;
        exp.e2 = e2x;
        результат = exp;
    }


    override проц посети(CmpExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("CmpExp::semantic('%s')\n", exp.вТкст0());
        }
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        exp.setNoderefOperands();

        if (Выражение ex = binSemanticProp(exp, sc))
        {
            результат = ex;
            return;
        }
        Тип t1 = exp.e1.тип.toBasetype();
        Тип t2 = exp.e2.тип.toBasetype();
        if (t1.ty == Tclass && exp.e2.op == ТОК2.null_ || t2.ty == Tclass && exp.e1.op == ТОК2.null_)
        {
            exp.выведиОшибку("do not use `null` when comparing class types");
            return setError();
        }

        ТОК2 cmpop;
        if (auto e = exp.op_overload(sc, &cmpop))
        {
            if (!e.тип.isscalar() && e.тип.равен(exp.e1.тип))
            {
                exp.выведиОшибку("recursive `opCmp` expansion");
                return setError();
            }
            if (e.op == ТОК2.call)
            {
                e = new CmpExp(cmpop, exp.место, e, new IntegerExp(exp.место, 0, Тип.tint32));
                e = e.ВыражениеSemantic(sc);
            }
            результат = e;
            return;
        }

        if (Выражение ex = typeCombine(exp, sc))
        {
            результат = ex;
            return;
        }

        auto f1 = checkNonAssignmentArrayOp(exp.e1);
        auto f2 = checkNonAssignmentArrayOp(exp.e2);
        if (f1 || f2)
            return setError();

        exp.тип = Тип.tбул;

        // Special handling for массив comparisons
        Выражение arrayLowering = null;
        t1 = exp.e1.тип.toBasetype();
        t2 = exp.e2.тип.toBasetype();
        if ((t1.ty == Tarray || t1.ty == Tsarray || t1.ty == Tpointer) && (t2.ty == Tarray || t2.ty == Tsarray || t2.ty == Tpointer))
        {
            Тип t1next = t1.nextOf();
            Тип t2next = t2.nextOf();
            if (t1next.implicitConvTo(t2next) < MATCH.constant && t2next.implicitConvTo(t1next) < MATCH.constant && (t1next.ty != Tvoid && t2next.ty != Tvoid))
            {
                exp.выведиОшибку("массив comparison тип mismatch, `%s` vs `%s`", t1next.вТкст0(), t2next.вТкст0());
                return setError();
            }
            if ((t1.ty == Tarray || t1.ty == Tsarray) && (t2.ty == Tarray || t2.ty == Tsarray))
            {
                if (!verifyHookExist(exp.место, *sc, Id.__cmp, "comparing arrays"))
                    return setError();

                // Lower to объект.__cmp(e1, e2)
                Выражение al = new IdentifierExp(exp.место, Id.empty);
                al = new DotIdExp(exp.место, al, Id.объект);
                al = new DotIdExp(exp.место, al, Id.__cmp);
                al = al.ВыражениеSemantic(sc);

                auto arguments = new Выражения(2);
                (*arguments)[0] = exp.e1;
                (*arguments)[1] = exp.e2;

                al = new CallExp(exp.место, al, arguments);
                al = new CmpExp(exp.op, exp.место, al, IntegerExp.literal!(0));

                arrayLowering = al;
            }
        }
        else if (t1.ty == Tstruct || t2.ty == Tstruct || (t1.ty == Tclass && t2.ty == Tclass))
        {
            if (t2.ty == Tstruct)
                exp.выведиОшибку("need member function `opCmp()` for %s `%s` to compare", t2.toDsymbol(sc).вид(), t2.вТкст0());
            else
                exp.выведиОшибку("need member function `opCmp()` for %s `%s` to compare", t1.toDsymbol(sc).вид(), t1.вТкст0());
            return setError();
        }
        else if (t1.iscomplex() || t2.iscomplex())
        {
            exp.выведиОшибку("compare not defined for complex operands");
            return setError();
        }
        else if (t1.ty == Taarray || t2.ty == Taarray)
        {
            exp.выведиОшибку("`%s` is not defined for associative arrays", Сема2.вТкст0(exp.op));
            return setError();
        }
        else if (!target.isVectorOpSupported(t1, exp.op, t2))
        {
            результат = exp.incompatibleTypes();
            return;
        }
        else
        {
            бул r1 = exp.e1.checkValue() || exp.e1.checkSharedAccess(sc);
            бул r2 = exp.e2.checkValue() || exp.e2.checkSharedAccess(sc);
            if (r1 || r2)
                return setError();
        }

        //printf("CmpExp: %s, тип = %s\n", e.вТкст0(), e.тип.вТкст0());
        if (arrayLowering)
        {
            arrayLowering = arrayLowering.ВыражениеSemantic(sc);
            результат = arrayLowering;
            return;
        }
        результат = exp;
        return;
    }

    override проц посети(InExp exp)
    {
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (Выражение ex = binSemanticProp(exp, sc))
        {
            результат = ex;
            return;
        }
        Выражение e = exp.op_overload(sc);
        if (e)
        {
            результат = e;
            return;
        }

        Тип t2b = exp.e2.тип.toBasetype();
        switch (t2b.ty)
        {
        case Taarray:
            {
                TypeAArray ta = cast(TypeAArray)t2b;

                // Special handling for массив keys
                if (!arrayTypeCompatibleWithoutCasting(exp.e1.тип, ta.index))
                {
                    // Convert ключ to тип of ключ
                    exp.e1 = exp.e1.implicitCastTo(sc, ta.index);
                }

                semanticTypeInfo(sc, ta.index);

                // Return тип is pointer to значение
                exp.тип = ta.nextOf().pointerTo();
                break;
            }

        case Terror:
            return setError();

        default:
            результат = exp.incompatibleTypes();
            return;
        }
        результат = exp;
    }

    override проц посети(RemoveExp e)
    {
        if (Выражение ex = binSemantic(e, sc))
        {
            результат = ex;
            return;
        }
        результат = e;
    }

    override проц посети(EqualExp exp)
    {
        //printf("EqualExp::semantic('%s')\n", exp.вТкст0());
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        exp.setNoderefOperands();

        if (auto e = binSemanticProp(exp, sc))
        {
            результат = e;
            return;
        }
        if (exp.e1.op == ТОК2.тип || exp.e2.op == ТОК2.тип)
        {
            результат = exp.incompatibleTypes();
            return;
        }

        {
            auto t1 = exp.e1.тип;
            auto t2 = exp.e2.тип;
            if (t1.ty == Tenum && t2.ty == Tenum && !t1.equivalent(t2))
                exp.выведиОшибку("Comparison between different enumeration types `%s` and `%s`; If this behavior is intended consider using `std.conv.asOriginalType`",
                    t1.вТкст0(), t2.вТкст0());
        }

        /* Before checking for operator overloading, check to see if we're
         * comparing the addresses of two statics. If so, we can just see
         * if they are the same symbol.
         */
        if (exp.e1.op == ТОК2.address && exp.e2.op == ТОК2.address)
        {
            AddrExp ae1 = cast(AddrExp)exp.e1;
            AddrExp ae2 = cast(AddrExp)exp.e2;
            if (ae1.e1.op == ТОК2.variable && ae2.e1.op == ТОК2.variable)
            {
                VarExp ve1 = cast(VarExp)ae1.e1;
                VarExp ve2 = cast(VarExp)ae2.e1;
                if (ve1.var == ve2.var)
                {
                    // They are the same, результат is 'да' for ==, 'нет' for !=
                    результат = IntegerExp.createBool(exp.op == ТОК2.equal);
                    return;
                }
            }
        }

        Тип t1 = exp.e1.тип.toBasetype();
        Тип t2 = exp.e2.тип.toBasetype();

        бул needsDirectEq(Тип t1, Тип t2)
        {
            Тип t1n = t1.nextOf().toBasetype();
            Тип t2n = t2.nextOf().toBasetype();
            if (((t1n.ty == Tchar || t1n.ty == Twchar || t1n.ty == Tdchar) &&
                 (t2n.ty == Tchar || t2n.ty == Twchar || t2n.ty == Tdchar)) ||
                (t1n.ty == Tvoid || t2n.ty == Tvoid))
            {
                return нет;
            }
            if (t1n.constOf() != t2n.constOf())
                return да;

            Тип t = t1n;
            while (t.toBasetype().nextOf())
                t = t.nextOf().toBasetype();
            if (t.ty != Tstruct)
                return нет;

            if (глоб2.парамы.useTypeInfo && Тип.dtypeinfo)
                semanticTypeInfo(sc, t);

            return (cast(TypeStruct)t).sym.hasIdentityEquals;
        }

        if (auto e = exp.op_overload(sc))
        {
            результат = e;
            return;
        }


        if (!(t1.ty == Tarray && t2.ty == Tarray && needsDirectEq(t1, t2)))
        {
            if (auto e = typeCombine(exp, sc))
            {
                результат = e;
                return;
            }
        }

        auto f1 = checkNonAssignmentArrayOp(exp.e1);
        auto f2 = checkNonAssignmentArrayOp(exp.e2);
        if (f1 || f2)
            return setError();

        exp.тип = Тип.tбул;

        // Special handling for массив comparisons
        if (!(t1.ty == Tarray && t2.ty == Tarray && needsDirectEq(t1, t2)))
        {
            if (!arrayTypeCompatible(exp.место, exp.e1.тип, exp.e2.тип))
            {
                if (exp.e1.тип != exp.e2.тип && exp.e1.тип.isfloating() && exp.e2.тип.isfloating())
                {
                    // Cast both to complex
                    exp.e1 = exp.e1.castTo(sc, Тип.tcomplex80);
                    exp.e2 = exp.e2.castTo(sc, Тип.tcomplex80);
                }
            }
        }

        if (t1.ty == Tarray && t2.ty == Tarray)
        {
            //printf("Lowering to __equals %s %s\n", e1.вТкст0(), e2.вТкст0());

            // For e1 and e2 of struct тип, lowers e1 == e2 to объект.__equals(e1, e2)
            // and e1 != e2 to !(объект.__equals(e1, e2)).

            if (!verifyHookExist(exp.место, *sc, Id.__equals, "equal checks on arrays"))
                return setError();

            Выражение __equals = new IdentifierExp(exp.место, Id.empty);
            Идентификатор2 ид = Идентификатор2.idPool("__equals");
            __equals = new DotIdExp(exp.место, __equals, Id.объект);
            __equals = new DotIdExp(exp.место, __equals, ид);

            auto arguments = new Выражения(2);
            (*arguments)[0] = exp.e1;
            (*arguments)[1] = exp.e2;

            __equals = new CallExp(exp.место, __equals, arguments);
            if (exp.op == ТОК2.notEqual)
            {
                __equals = new NotExp(exp.место, __equals);
            }
            __equals = __equals.ВыражениеSemantic(sc);

            результат = __equals;
            return;
        }

        if (exp.e1.тип.toBasetype().ty == Taarray)
            semanticTypeInfo(sc, exp.e1.тип.toBasetype());


        if (!target.isVectorOpSupported(t1, exp.op, t2))
        {
            результат = exp.incompatibleTypes();
            return;
        }

        результат = exp;
    }

    override проц посети(IdentityExp exp)
    {
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        exp.setNoderefOperands();

        if (auto e = binSemanticProp(exp, sc))
        {
            результат = e;
            return;
        }

        if (auto e = typeCombine(exp, sc))
        {
            результат = e;
            return;
        }

        auto f1 = checkNonAssignmentArrayOp(exp.e1);
        auto f2 = checkNonAssignmentArrayOp(exp.e2);
        if (f1 || f2)
            return setError();

        if (exp.e1.op == ТОК2.тип || exp.e2.op == ТОК2.тип)
        {
            результат = exp.incompatibleTypes();
            return;
        }

        exp.тип = Тип.tбул;

        if (exp.e1.тип != exp.e2.тип && exp.e1.тип.isfloating() && exp.e2.тип.isfloating())
        {
            // Cast both to complex
            exp.e1 = exp.e1.castTo(sc, Тип.tcomplex80);
            exp.e2 = exp.e2.castTo(sc, Тип.tcomplex80);
        }

        auto tb1 = exp.e1.тип.toBasetype();
        auto tb2 = exp.e2.тип.toBasetype();
        if (!target.isVectorOpSupported(tb1, exp.op, tb2))
        {
            результат = exp.incompatibleTypes();
            return;
        }

        if (exp.e1.op == ТОК2.call)
            exp.e1 = (cast(CallExp)exp.e1).addDtorHook(sc);
        if (exp.e2.op == ТОК2.call)
            exp.e2 = (cast(CallExp)exp.e2).addDtorHook(sc);

        if (exp.e1.тип.toBasetype().ty == Tsarray ||
            exp.e2.тип.toBasetype().ty == Tsarray)
            exp.deprecation("identity comparison of static arrays "
                ~ "implicitly coerces them to slices, "
                ~ "which are compared by reference");

        результат = exp;
    }

    override проц посети(CondExp exp)
    {
        static if (LOGSEMANTIC)
        {
            printf("CondExp::semantic('%s')\n", exp.вТкст0());
        }
        if (exp.тип)
        {
            результат = exp;
            return;
        }

        if (exp.econd.op == ТОК2.dotIdentifier)
            (cast(DotIdExp)exp.econd).noderef = да;

        Выражение ec = exp.econd.ВыражениеSemantic(sc);
        ec = resolveProperties(sc, ec);
        ec = ec.toBoolean(sc);

        CtorFlow ctorflow_root = sc.ctorflow.clone();
        Выражение e1x = exp.e1.ВыражениеSemantic(sc);
        e1x = resolveProperties(sc, e1x);

        CtorFlow ctorflow1 = sc.ctorflow;
        sc.ctorflow = ctorflow_root;
        Выражение e2x = exp.e2.ВыражениеSemantic(sc);
        e2x = resolveProperties(sc, e2x);

        sc.merge(exp.место, ctorflow1);
        ctorflow1.freeFieldinit();

        if (ec.op == ТОК2.error)
        {
            результат = ec;
            return;
        }
        if (ec.тип == Тип.terror)
            return setError();
        exp.econd = ec;

        if (e1x.op == ТОК2.error)
        {
            результат = e1x;
            return;
        }
        if (e1x.тип == Тип.terror)
            return setError();
        exp.e1 = e1x;

        if (e2x.op == ТОК2.error)
        {
            результат = e2x;
            return;
        }
        if (e2x.тип == Тип.terror)
            return setError();
        exp.e2 = e2x;

        auto f0 = checkNonAssignmentArrayOp(exp.econd);
        auto f1 = checkNonAssignmentArrayOp(exp.e1);
        auto f2 = checkNonAssignmentArrayOp(exp.e2);
        if (f0 || f1 || f2)
            return setError();

        Тип t1 = exp.e1.тип;
        Тип t2 = exp.e2.тип;
        // If either operand is проц the результат is проц, we have to cast both
        // the Выражение to проц so that we explicitly discard the Выражение
        // значение if any
        // https://issues.dlang.org/show_bug.cgi?ид=16598
        if (t1.ty == Tvoid || t2.ty == Tvoid)
        {
            exp.тип = Тип.tvoid;
            exp.e1 = exp.e1.castTo(sc, exp.тип);
            exp.e2 = exp.e2.castTo(sc, exp.тип);
        }
        else if (t1 == t2)
            exp.тип = t1;
        else
        {
            if (Выражение ex = typeCombine(exp, sc))
            {
                результат = ex;
                return;
            }

            switch (exp.e1.тип.toBasetype().ty)
            {
            case Tcomplex32:
            case Tcomplex64:
            case Tcomplex80:
                exp.e2 = exp.e2.castTo(sc, exp.e1.тип);
                break;
            default:
                break;
            }
            switch (exp.e2.тип.toBasetype().ty)
            {
            case Tcomplex32:
            case Tcomplex64:
            case Tcomplex80:
                exp.e1 = exp.e1.castTo(sc, exp.e2.тип);
                break;
            default:
                break;
            }
            if (exp.тип.toBasetype().ty == Tarray)
            {
                exp.e1 = exp.e1.castTo(sc, exp.тип);
                exp.e2 = exp.e2.castTo(sc, exp.тип);
            }
        }
        exp.тип = exp.тип.merge2();
        version (none)
        {
            printf("res: %s\n", exp.тип.вТкст0());
            printf("e1 : %s\n", exp.e1.тип.вТкст0());
            printf("e2 : %s\n", exp.e2.тип.вТкст0());
        }

        /* https://issues.dlang.org/show_bug.cgi?ид=14696
         * If either e1 or e2 contain temporaries which need dtor,
         * make them conditional.
         * Rewrite:
         *      cond ? (__tmp1 = ..., __tmp1) : (__tmp2 = ..., __tmp2)
         * to:
         *      (auto __cond = cond) ? (... __tmp1) : (... __tmp2)
         * and replace edtors of __tmp1 and __tmp2 with:
         *      __tmp1.edtor --> __cond && __tmp1.dtor()
         *      __tmp2.edtor --> __cond || __tmp2.dtor()
         */
        exp.hookDtors(sc);

        результат = exp;
    }

    override проц посети(FileInitExp e)
    {
        //printf("FileInitExp::semantic()\n");
        e.тип = Тип.tstring;
        результат = e;
    }

    override проц посети(LineInitExp e)
    {
        e.тип = Тип.tint32;
        результат = e;
    }

    override проц посети(ModuleInitExp e)
    {
        //printf("ModuleInitExp::semantic()\n");
        e.тип = Тип.tstring;
        результат = e;
    }

    override проц посети(FuncInitExp e)
    {
        //printf("FuncInitExp::semantic()\n");
        e.тип = Тип.tstring;
        if (sc.func)
        {
            результат = e.resolveLoc(Место.initial, sc);
            return;
        }
        результат = e;
    }

    override проц посети(PrettyFuncInitExp e)
    {
        //printf("PrettyFuncInitExp::semantic()\n");
        e.тип = Тип.tstring;
        if (sc.func)
        {
            результат = e.resolveLoc(Место.initial, sc);
            return;
        }

        результат = e;
    }
}

/**********************************
 * Try to run semantic routines.
 * If they fail, return NULL.
 */
Выражение trySemantic(Выражение exp, Scope* sc)
{
    //printf("+trySemantic(%s)\n", exp.вТкст0());
    бцел errors = глоб2.startGagging();
    Выражение e = ВыражениеSemantic(exp, sc);
    if (глоб2.endGagging(errors))
    {
        e = null;
    }
    //printf("-trySemantic(%s)\n", exp.вТкст0());
    return e;
}

/**************************
 * Helper function for easy error propagation.
 * If error occurs, returns ErrorExp. Otherwise returns NULL.
 */
Выражение unaSemantic(UnaExp e, Scope* sc)
{
    static if (LOGSEMANTIC)
    {
        printf("UnaExp::semantic('%s')\n", e.вТкст0());
    }
    Выражение e1x = e.e1.ВыражениеSemantic(sc);
    if (e1x.op == ТОК2.error)
        return e1x;
    e.e1 = e1x;
    return null;
}

/**************************
 * Helper function for easy error propagation.
 * If error occurs, returns ErrorExp. Otherwise returns NULL.
 */
Выражение binSemantic(BinExp e, Scope* sc)
{
    static if (LOGSEMANTIC)
    {
        printf("BinExp::semantic('%s')\n", e.вТкст0());
    }
    Выражение e1x = e.e1.ВыражениеSemantic(sc);
    Выражение e2x = e.e2.ВыражениеSemantic(sc);

    // for static alias this: https://issues.dlang.org/show_bug.cgi?ид=17684
    if (e1x.op == ТОК2.тип)
        e1x = resolveAliasThis(sc, e1x);
    if (e2x.op == ТОК2.тип)
        e2x = resolveAliasThis(sc, e2x);

    if (e1x.op == ТОК2.error)
        return e1x;
    if (e2x.op == ТОК2.error)
        return e2x;
    e.e1 = e1x;
    e.e2 = e2x;
    return null;
}

Выражение binSemanticProp(BinExp e, Scope* sc)
{
    if (Выражение ex = binSemantic(e, sc))
        return ex;
    Выражение e1x = resolveProperties(sc, e.e1);
    Выражение e2x = resolveProperties(sc, e.e2);
    if (e1x.op == ТОК2.error)
        return e1x;
    if (e2x.op == ТОК2.error)
        return e2x;
    e.e1 = e1x;
    e.e2 = e2x;
    return null;
}

// entrypoint for semantic ВыражениеSemanticVisitor
 Выражение ВыражениеSemantic(Выражение e, Scope* sc)
{
    scope v = new ВыражениеSemanticVisitor(sc);
    e.прими(v);
    return v.результат;
}

Выражение semanticX(DotIdExp exp, Scope* sc)
{
    //printf("DotIdExp::semanticX(this = %p, '%s')\n", this, вТкст0());
    if (Выражение ex = unaSemantic(exp, sc))
        return ex;

    if (exp.идент == Id._mangleof)
    {
        // symbol.mangleof
        ДСимвол ds;
        switch (exp.e1.op)
        {
        case ТОК2.scope_:
            ds = (cast(ScopeExp)exp.e1).sds;
            goto L1;
        case ТОК2.variable:
            ds = (cast(VarExp)exp.e1).var;
            goto L1;
        case ТОК2.dotVariable:
            ds = (cast(DotVarExp)exp.e1).var;
            goto L1;
        case ТОК2.overloadSet:
            ds = (cast(OverExp)exp.e1).vars;
            goto L1;
        case ТОК2.template_:
            {
                TemplateExp te = cast(TemplateExp)exp.e1;
                ds = te.fd ? cast(ДСимвол)te.fd : te.td;
            }
        L1:
            {
                assert(ds);
                if (auto f = ds.isFuncDeclaration())
                {
                    if (f.checkForwardRef(exp.место))
                    {
                        return new ErrorExp();
                    }
                }
                БуфВыв буф;
                mangleToBuffer(ds, &буф);
                Выражение e = new StringExp(exp.место, буф.извлекиСрез());
                e = e.ВыражениеSemantic(sc);
                return e;
            }
        default:
            break;
        }
    }

    if (exp.e1.op == ТОК2.variable && exp.e1.тип.toBasetype().ty == Tsarray && exp.идент == Id.length)
    {
        // bypass checkPurity
        return exp.e1.тип.dotExp(sc, exp.e1, exp.идент, exp.noderef ? DotExpFlag.noDeref : 0);
    }

    if (exp.e1.op == ТОК2.dot)
    {
    }
    else
    {
        exp.e1 = resolvePropertiesX(sc, exp.e1);
    }
    if (exp.e1.op == ТОК2.кортеж && exp.идент == Id.offsetof)
    {
        /* 'distribute' the .offsetof to each of the кортеж elements.
         */
        TupleExp te = cast(TupleExp)exp.e1;
        auto exps = new Выражения(te.exps.dim);
        for (т_мера i = 0; i < exps.dim; i++)
        {
            Выражение e = (*te.exps)[i];
            e = e.ВыражениеSemantic(sc);
            e = new DotIdExp(e.место, e, Id.offsetof);
            (*exps)[i] = e;
        }
        // Don't evaluate te.e0 in runtime
        Выражение e = new TupleExp(exp.место, null, exps);
        e = e.ВыражениеSemantic(sc);
        return e;
    }
    if (exp.e1.op == ТОК2.кортеж && exp.идент == Id.length)
    {
        TupleExp te = cast(TupleExp)exp.e1;
        // Don't evaluate te.e0 in runtime
        Выражение e = new IntegerExp(exp.место, te.exps.dim, Тип.tт_мера);
        return e;
    }

    // https://issues.dlang.org/show_bug.cgi?ид=14416
    // Template has no built-in properties except for 'stringof'.
    if ((exp.e1.op == ТОК2.dotTemplateDeclaration || exp.e1.op == ТОК2.template_) && exp.идент != Id.stringof)
    {
        exp.выведиОшибку("template `%s` does not have property `%s`", exp.e1.вТкст0(), exp.идент.вТкст0());
        return new ErrorExp();
    }
    if (!exp.e1.тип)
    {
        exp.выведиОшибку("Выражение `%s` does not have property `%s`", exp.e1.вТкст0(), exp.идент.вТкст0());
        return new ErrorExp();
    }

    return exp;
}

// Resolve e1.идент without seeing UFCS.
// If флаг == 1, stop "not a property" error and return NULL.
Выражение semanticY(DotIdExp exp, Scope* sc, цел флаг)
{
    //printf("DotIdExp::semanticY(this = %p, '%s')\n", exp, exp.вТкст0());

    //{ static цел z; fflush(stdout); if (++z == 10) *(сим*)0=0; }

    /* Special case: rewrite this.ид and super.ид
     * to be classtype.ид and baseclasstype.ид
     * if we have no this pointer.
     */
    if ((exp.e1.op == ТОК2.this_ || exp.e1.op == ТОК2.super_) && !hasThis(sc))
    {
        if (AggregateDeclaration ad = sc.getStructClassScope())
        {
            if (exp.e1.op == ТОК2.this_)
            {
                exp.e1 = new TypeExp(exp.e1.место, ad.тип);
            }
            else
            {
                ClassDeclaration cd = ad.isClassDeclaration();
                if (cd && cd.baseClass)
                    exp.e1 = new TypeExp(exp.e1.место, cd.baseClass.тип);
            }
        }
    }

    Выражение e = semanticX(exp, sc);
    if (e != exp)
        return e;

    Выражение eleft;
    Выражение eright;
    if (exp.e1.op == ТОК2.dot)
    {
        DotExp de = cast(DotExp)exp.e1;
        eleft = de.e1;
        eright = de.e2;
    }
    else
    {
        eleft = null;
        eright = exp.e1;
    }

    Тип t1b = exp.e1.тип.toBasetype();

    if (eright.op == ТОК2.scope_) // also используется for template alias's
    {
        ScopeExp ie = cast(ScopeExp)eright;

        цел flags = SearchLocalsOnly;
        /* Disable access to another module's private imports.
         * The check for 'is sds our current module' is because
         * the current module should have access to its own imports.
         */
        if (ie.sds.isModule() && ie.sds != sc._module)
            flags |= IgnorePrivateImports;
        if (sc.flags & SCOPE.ignoresymbolvisibility)
            flags |= IgnoreSymbolVisibility;
        ДСимвол s = ie.sds.search(exp.место, exp.идент, flags);
        /* Check for visibility before resolving ники because public
         * ники to private symbols are public.
         */
        if (s && !(sc.flags & SCOPE.ignoresymbolvisibility) && !symbolIsVisible(sc._module, s))
        {
            s = null;
        }
        if (s)
        {
            auto p = s.isPackage();
            if (p && checkAccess(sc, p))
            {
                s = null;
            }
        }
        if (s)
        {
            // if 's' is a кортеж variable, the кортеж is returned.
            s = s.toAlias();

            exp.checkDeprecated(sc, s);
            exp.checkDisabled(sc, s);

            EnumMember em = s.isEnumMember();
            if (em)
            {
                return em.getVarExp(exp.место, sc);
            }
            VarDeclaration v = s.isVarDeclaration();
            if (v)
            {
                //printf("DotIdExp:: Идентификатор2 '%s' is a variable, тип '%s'\n", вТкст0(), v.тип.вТкст0());
                if (!v.тип ||
                    !v.тип.deco && v.inuse)
                {
                    if (v.inuse)
                        exp.выведиОшибку("circular reference to %s `%s`", v.вид(), v.toPrettyChars());
                    else
                        exp.выведиОшибку("forward reference to %s `%s`", v.вид(), v.toPrettyChars());
                    return new ErrorExp();
                }
                if (v.тип.ty == Terror)
                    return new ErrorExp();

                if ((v.класс_хранения & STC.manifest) && v._иниц && !exp.wantsym)
                {
                    /* Normally, the replacement of a symbol with its инициализатор is supposed to be in semantic2().
                     * Introduced by https://github.com/dlang/dmd/pull/5588 which should probably
                     * be reverted. `wantsym` is the hack to work around the problem.
                     */
                    if (v.inuse)
                    {
                        выведиОшибку(exp.место, "circular initialization of %s `%s`", v.вид(), v.toPrettyChars());
                        return new ErrorExp();
                    }
                    e = v.expandInitializer(exp.место);
                    v.inuse++;
                    e = e.ВыражениеSemantic(sc);
                    v.inuse--;
                    return e;
                }

                if (v.needThis())
                {
                    if (!eleft)
                        eleft = new ThisExp(exp.место);
                    e = new DotVarExp(exp.место, eleft, v);
                    e = e.ВыражениеSemantic(sc);
                }
                else
                {
                    e = new VarExp(exp.место, v);
                    if (eleft)
                    {
                        e = new CommaExp(exp.место, eleft, e);
                        e.тип = v.тип;
                    }
                }
                e = e.deref();
                return e.ВыражениеSemantic(sc);
            }

            FuncDeclaration f = s.isFuncDeclaration();
            if (f)
            {
                //printf("it's a function\n");
                if (!f.functionSemantic())
                    return new ErrorExp();
                if (f.needThis())
                {
                    if (!eleft)
                        eleft = new ThisExp(exp.место);
                    e = new DotVarExp(exp.место, eleft, f, да);
                    e = e.ВыражениеSemantic(sc);
                }
                else
                {
                    e = new VarExp(exp.место, f, да);
                    if (eleft)
                    {
                        e = new CommaExp(exp.место, eleft, e);
                        e.тип = f.тип;
                    }
                }
                return e;
            }
            if (auto td = s.isTemplateDeclaration())
            {
                if (eleft)
                    e = new DotTemplateExp(exp.место, eleft, td);
                else
                    e = new TemplateExp(exp.место, td);
                e = e.ВыражениеSemantic(sc);
                return e;
            }
            if (OverDeclaration od = s.isOverDeclaration())
            {
                e = new VarExp(exp.место, od, да);
                if (eleft)
                {
                    e = new CommaExp(exp.место, eleft, e);
                    e.тип = Тип.tvoid; // ambiguous тип?
                }
                return e;
            }
            OverloadSet o = s.isOverloadSet();
            if (o)
            {
                //printf("'%s' is an overload set\n", o.вТкст0());
                return new OverExp(exp.место, o);
            }

            if (auto t = s.getType())
            {
                return (new TypeExp(exp.место, t)).ВыражениеSemantic(sc);
            }

            TupleDeclaration tup = s.isTupleDeclaration();
            if (tup)
            {
                if (eleft)
                {
                    e = new DotVarExp(exp.место, eleft, tup);
                    e = e.ВыражениеSemantic(sc);
                    return e;
                }
                e = new TupleExp(exp.место, tup);
                e = e.ВыражениеSemantic(sc);
                return e;
            }

            ScopeDsymbol sds = s.isScopeDsymbol();
            if (sds)
            {
                //printf("it's a ScopeDsymbol %s\n", идент.вТкст0());
                e = new ScopeExp(exp.место, sds);
                e = e.ВыражениеSemantic(sc);
                if (eleft)
                    e = new DotExp(exp.место, eleft, e);
                return e;
            }

            Импорт imp = s.isImport();
            if (imp)
            {
                ie = new ScopeExp(exp.место, imp.pkg);
                return ie.ВыражениеSemantic(sc);
            }
            // BUG: handle other cases like in IdentifierExp::semantic()
            debug
            {
                printf("s = '%s', вид = '%s'\n", s.вТкст0(), s.вид());
            }
            assert(0);
        }
        else if (exp.идент == Id.stringof)
        {
            e = new StringExp(exp.место, ie.вТкст());
            e = e.ВыражениеSemantic(sc);
            return e;
        }
        if (ie.sds.isPackage() || ie.sds.isImport() || ie.sds.isModule())
        {
            флаг = 0;
        }
        if (флаг)
            return null;
        s = ie.sds.search_correct(exp.идент);
        if (s)
        {
            if (s.isPackage())
                exp.выведиОшибку("undefined идентификатор `%s` in %s `%s`, perhaps add `static import %s;`", exp.идент.вТкст0(), ie.sds.вид(), ie.sds.toPrettyChars(), s.toPrettyChars());
            else
                exp.выведиОшибку("undefined идентификатор `%s` in %s `%s`, did you mean %s `%s`?", exp.идент.вТкст0(), ie.sds.вид(), ie.sds.toPrettyChars(), s.вид(), s.вТкст0());
        }
        else
            exp.выведиОшибку("undefined идентификатор `%s` in %s `%s`", exp.идент.вТкст0(), ie.sds.вид(), ie.sds.toPrettyChars());
        return new ErrorExp();
    }
    else if (t1b.ty == Tpointer && exp.e1.тип.ty != Tenum && exp.идент != Id._иниц && exp.идент != Id.__sizeof && exp.идент != Id.__xalignof && exp.идент != Id.offsetof && exp.идент != Id._mangleof && exp.идент != Id.stringof)
    {
        Тип t1bn = t1b.nextOf();
        if (флаг)
        {
            AggregateDeclaration ad = isAggregate(t1bn);
            if (ad && !ad.члены) // https://issues.dlang.org/show_bug.cgi?ид=11312
                return null;
        }

        /* Rewrite:
         *   p.идент
         * as:
         *   (*p).идент
         */
        if (флаг && t1bn.ty == Tvoid)
            return null;
        e = new PtrExp(exp.место, exp.e1);
        e = e.ВыражениеSemantic(sc);
        return e.тип.dotExp(sc, e, exp.идент, флаг | (exp.noderef ? DotExpFlag.noDeref : 0));
    }
    else
    {
        if (exp.e1.op == ТОК2.тип || exp.e1.op == ТОК2.template_)
            флаг = 0;
        e = exp.e1.тип.dotExp(sc, exp.e1, exp.идент, флаг | (exp.noderef ? DotExpFlag.noDeref : 0));
        if (e)
            e = e.ВыражениеSemantic(sc);
        return e;
    }
}

// Resolve e1.идент!tiargs without seeing UFCS.
// If флаг == 1, stop "not a property" error and return NULL.
Выражение semanticY(DotTemplateInstanceExp exp, Scope* sc, цел флаг)
{
    static if (LOGSEMANTIC)
    {
        printf("DotTemplateInstanceExpY::semantic('%s')\n", exp.вТкст0());
    }

    static Выражение errorExp()
    {
        return new ErrorExp();
    }

    auto die = new DotIdExp(exp.место, exp.e1, exp.ti.имя);

    Выражение e = die.semanticX(sc);
    if (e == die)
    {
        exp.e1 = die.e1; // take back
        Тип t1b = exp.e1.тип.toBasetype();
        if (t1b.ty == Tarray || t1b.ty == Tsarray || t1b.ty == Taarray || t1b.ty == Tnull || (t1b.isTypeBasic() && t1b.ty != Tvoid))
        {
            /* No built-in тип has templatized properties, so do shortcut.
             * It is necessary in: 1024.max!"a < b"
             */
            if (флаг)
                return null;
        }
        e = die.semanticY(sc, флаг);
        if (флаг)
        {
            if (!e ||
                isDotOpDispatch(e))
            {
                /* opDispatch!tiargs would be a function template that needs IFTI,
                 * so it's not a template
                 */
                return null;
            }
        }
    }
    assert(e);

    if (e.op == ТОК2.error)
        return e;
    if (e.op == ТОК2.dotVariable)
    {
        DotVarExp dve = cast(DotVarExp)e;
        if (FuncDeclaration fd = dve.var.isFuncDeclaration())
        {
            if (TemplateDeclaration td = fd.findTemplateDeclRoot())
            {
                e = new DotTemplateExp(dve.место, dve.e1, td);
                e = e.ВыражениеSemantic(sc);
            }
        }
        else if (OverDeclaration od = dve.var.isOverDeclaration())
        {
            exp.e1 = dve.e1; // pull semantic() результат

            if (!exp.findTempDecl(sc))
                goto Lerr;
            if (exp.ti.needsTypeInference(sc))
                return exp;
            exp.ti.dsymbolSemantic(sc);
            if (!exp.ti.inst || exp.ti.errors) // if template failed to expand
                return errorExp();

            if (Declaration v = exp.ti.toAlias().isDeclaration())
            {
                if (v.тип && !v.тип.deco)
                    v.тип = v.тип.typeSemantic(v.место, sc);
                    auto rez = new DotVarExp(exp.место, exp.e1, v);
                return rez.ВыражениеSemantic(sc);
            }
            auto rez = new DotExp(exp.место, exp.e1, new ScopeExp(exp.место, exp.ti));
            return rez.ВыражениеSemantic(sc);
        }
    }
    else if (e.op == ТОК2.variable)
    {
        VarExp ve = cast(VarExp)e;
        if (FuncDeclaration fd = ve.var.isFuncDeclaration())
        {
            if (TemplateDeclaration td = fd.findTemplateDeclRoot())
            {
                auto rez = new TemplateExp(ve.место, td);
                e = rez.ВыражениеSemantic(sc);
            }
        }
        else if (OverDeclaration od = ve.var.isOverDeclaration())
        {
            exp.ti.tempdecl = od;
            auto rez = new ScopeExp(exp.место, exp.ti);
            return rez.ВыражениеSemantic(sc);
        }
    }

    if (e.op == ТОК2.dotTemplateDeclaration)
    {
        DotTemplateExp dte = cast(DotTemplateExp)e;
        exp.e1 = dte.e1; // pull semantic() результат

        exp.ti.tempdecl = dte.td;
        if (!exp.ti.semanticTiargs(sc))
            return errorExp();
        if (exp.ti.needsTypeInference(sc))
            return exp;
        exp.ti.dsymbolSemantic(sc);
        if (!exp.ti.inst || exp.ti.errors) // if template failed to expand
            return errorExp();

        if (Declaration v = exp.ti.toAlias().isDeclaration())
        {
            if (v.isFuncDeclaration() || v.isVarDeclaration())
            {
                auto rez = new DotVarExp(exp.место, exp.e1, v);
                return rez.ВыражениеSemantic(sc);
            }
        }
        auto rez = new DotExp(exp.место, exp.e1, new ScopeExp(exp.место, exp.ti));
        return rez.ВыражениеSemantic(sc);
    }
    else if (e.op == ТОК2.template_)
    {
        exp.ti.tempdecl = (cast(TemplateExp)e).td;
        auto rez = new ScopeExp(exp.место, exp.ti);
        return rez.ВыражениеSemantic(sc);
    }
    else if (e.op == ТОК2.dot)
    {
        DotExp de = cast(DotExp)e;

        if (de.e2.op == ТОК2.overloadSet)
        {
            if (!exp.findTempDecl(sc) || !exp.ti.semanticTiargs(sc))
            {
                return errorExp();
            }
            if (exp.ti.needsTypeInference(sc))
                return exp;
            exp.ti.dsymbolSemantic(sc);
            if (!exp.ti.inst || exp.ti.errors) // if template failed to expand
                return errorExp();

            if (Declaration v = exp.ti.toAlias().isDeclaration())
            {
                if (v.тип && !v.тип.deco)
                    v.тип = v.тип.typeSemantic(v.место, sc);
                    auto rez = new DotVarExp(exp.место, exp.e1, v);
                return rez.ВыражениеSemantic(sc);
            }
            auto rez = new DotExp(exp.место, exp.e1, new ScopeExp(exp.место, exp.ti));
            return rez.ВыражениеSemantic(sc);
        }
    }
    else if (e.op == ТОК2.overloadSet)
    {
        OverExp oe = cast(OverExp)e;
        exp.ti.tempdecl = oe.vars;
        auto rez = new ScopeExp(exp.место, exp.ti);
        return rez.ВыражениеSemantic(sc);
    }

Lerr:
    exp.выведиОшибку("`%s` isn't a template", e.вТкст0());
    return errorExp();
}

/***************************************
 * If Выражение is shared, check that we can access it.
 * Give error message if not.
 * Параметры:
 *      e = Выражение to check
 *      sc = context
 * Возвращает:
 *      да on error
 */
бул checkSharedAccess(Выражение e, Scope* sc)
{
    if (!глоб2.парамы.noSharedAccess ||
        sc.intypeof ||
        sc.flags & SCOPE.ctfe)
    {
        return нет;
    }

    //printf("checkSharedAccess() %s\n", e.вТкст0());

    static бул check(Выражение e)
    {
        static бул sharedError(Выражение e)
        {
            // https://dlang.org/phobos/core_atomic.html
            e.выведиОшибку("direct access to shared `%s` is not allowed, see `core.atomic`", e.вТкст0());
            return да;
        }

        бул visitVar(VarExp ve)
        {
            return ve.var.тип.isShared() ? sharedError(ve) : нет;
        }

        бул visitPtr(PtrExp pe)
        {
            return pe.e1.тип.nextOf().isShared() ? sharedError(pe) : нет;
        }

        бул visitDotVar(DotVarExp dve)
        {
            return dve.var.тип.isShared() || check(dve.e1) ? sharedError(dve) : нет;
        }

        бул visitIndex(IndexExp ie)
        {
            return ie.e1.тип.nextOf().isShared() ? sharedError(ie) : нет;
        }

        бул visitComma(CommaExp ce)
        {
            return check(ce.e2);
        }

        switch (e.op)
        {
            case ТОК2.variable:    return visitVar(e.isVarExp());
            case ТОК2.star:        return visitPtr(e.isPtrExp());
            case ТОК2.dotVariable: return visitDotVar(e.isDotVarExp());
            case ТОК2.index:       return visitIndex(e.isIndexExp());
            case ТОК2.comma:       return visitComma(e.isCommaExp());
            default:
                return нет;
        }
    }

    return check(e);
}



/****************************************************
 * Determine if `exp`, which takes the address of `v`, can do so safely.
 * Параметры:
 *      sc = context
 *      exp = Выражение that takes the address of `v`
 *      v = the variable getting its address taken
 * Возвращает:
 *      `да` if ok, `нет` for error
 */
private бул checkAddressVar(Scope* sc, UnaExp exp, VarDeclaration v)
{
    //printf("checkAddressVar(exp: %s, v: %s)\n", exp.вТкст0(), v.вТкст0());
    if (v)
    {
        if (!v.canTakeAddressOf())
        {
            exp.выведиОшибку("cannot take address of `%s`", exp.e1.вТкст0());
            return нет;
        }
        if (sc.func && !sc.intypeof && !v.isDataseg())
        {
            ткст0 p = v.isParameter() ? "параметр" : "local";
            if (глоб2.парамы.vsafe)
            {
                // Taking the address of v means it cannot be set to 'scope' later
                v.класс_хранения &= ~STC.maybescope;
                v.doNotInferScope = да;
                if (exp.e1.тип.hasPointers() && v.класс_хранения & STC.scope_ &&
                    !(sc.flags & SCOPE.debug_) && sc.func.setUnsafe())
                {
                    exp.выведиОшибку("cannot take address of `scope` %s `%s` in `` function `%s`", p, v.вТкст0(), sc.func.вТкст0());
                    return нет;
                }
            }
            else if (!(sc.flags & SCOPE.debug_) && sc.func.setUnsafe())
            {
                exp.выведиОшибку("cannot take address of %s `%s` in `` function `%s`", p, v.вТкст0(), sc.func.вТкст0());
                return нет;
            }
        }
    }
    return да;
}

/*******************************
 * Checks the attributes of a function.
 * Purity (``), safety (``), no СМ allocations(``)
 * and использование of `deprecated` and `@disabled`-ed symbols are checked.
 *
 * Параметры:
 *  exp = Выражение to check attributes for
 *  sc  = scope of the function
 *  f   = function to be checked
 * Возвращает: `да` if error occur.
 */
private бул checkFunctionAttributes(Выражение exp, Scope* sc, FuncDeclaration f)
{
    with(exp)
    {
        бул error = checkDisabled(sc, f);
        error |= checkDeprecated(sc, f);
        error |= checkPurity(sc, f);
        error |= checkSafety(sc, f);
        error |= checkNogc(sc, f);
        return error;
    }
}

/*******************************
 * Helper function for `getRightThis()`.
 * Gets `this` of the следщ outer aggregate.
 * Параметры:
 *      место = location to use for error messages
 *      sc = context
 *      s = the родитель symbol of the existing `this`
 *      ad = struct or class we need the correct `this` for
 *      e1 = existing `this`
 *      t = тип of the existing `this`
 *      var = the specific member of ad we're accessing
 *      флаг = if да, return `null` instead of throwing an error
 * Возвращает:
 *      Выражение representing the `this` for the var
 */
Выражение getThisSkipNestedFuncs(ref Место место, Scope* sc, ДСимвол s, AggregateDeclaration ad, Выражение e1, Тип t, ДСимвол var, бул флаг = нет)
{
    цел n = 0;
    while (s && s.isFuncDeclaration())
    {
        FuncDeclaration f = s.isFuncDeclaration();
        if (f.vthis)
        {
            n++;
            e1 = new VarExp(место, f.vthis);
            if (f.isThis2)
            {
                // (*__this)[i]
                if (n > 1)
                    e1 = e1.ВыражениеSemantic(sc);
                e1 = new PtrExp(место, e1);
                бцел i = f.followInstantiationContext(ad);
                e1 = new IndexExp(место, e1, new IntegerExp(i));
                s = f.toParentP(ad);
                continue;
            }
        }
        else
        {
            if (флаг)
                return null;
            e1.выведиОшибку("need `this` of тип `%s` to access member `%s` from static function `%s`", ad.вТкст0(), var.вТкст0(), f.вТкст0());
            e1 = new ErrorExp();
            return e1;
        }
        s = s.toParent2();
    }
    if (n > 1 || e1.op == ТОК2.index)
        e1 = e1.ВыражениеSemantic(sc);
    if (s && e1.тип.equivalent(Тип.tvoidptr))
    {
        if (auto sad = s.isAggregateDeclaration())
        {
            Тип ta = sad.handleType();
            if (ta.ty == Tstruct)
                ta = ta.pointerTo();
            e1.тип = ta;
        }
    }
    e1.тип = e1.тип.addMod(t.mod);
    return e1;
}

/*******************************
 * Make a dual-context container for use as a `this` argument.
 * Параметры:
 *      место = location to use for error messages
 *      sc = current scope
 *      fd = target function that will take the `this` argument
 * Возвращает:
 *      Temporary closure variable.
 * Note:
 *      The function `fd` is added to the nested references of the
 *      newly created variable such that a closure is made for the variable when
 *      the address of `fd` is taken.
 */
VarDeclaration makeThis2Argument(ref Место место, Scope* sc, FuncDeclaration fd)
{
    Тип tthis2 = Тип.tvoidptr.sarrayOf(2);
    VarDeclaration vthis2 = new VarDeclaration(место, tthis2, Идентификатор2.генерируйИд("__this"), null);
    vthis2.класс_хранения |= STC.temp;
    vthis2.dsymbolSemantic(sc);
    vthis2.родитель = sc.родитель;
    // make it a closure var
    assert(sc.func);
    sc.func.closureVars.сунь(vthis2);
    // add `fd` to the nested refs
    vthis2.nestedrefs.сунь(fd);
    return vthis2;
}

/*******************************
 * Make sure that the runtime hook `ид` exists.
 * Параметры:
 *      место = location to use for error messages
 *      sc = current scope
 *      ид = the hook идентификатор
 *      description = what the hook does
 *      module_ = what module the hook is located in
 * Возвращает:
 *      a `бул` indicating if the hook is present.
 */
бул verifyHookExist(ref Место место, ref Scope sc, Идентификатор2 ид, ткст description, Идентификатор2 module_ = Id.объект)
{
    auto rootSymbol = sc.search(место, Id.empty, null);
    if (auto moduleSymbol = rootSymbol.search(место, module_))
        if (moduleSymbol.search(место, ид))
          return да;
    выведиОшибку(место, "`%s.%s` not found. The current runtime does not support %.*s, or the runtime is corrupt.", module_.вТкст0(), ид.вТкст0(), cast(цел)description.length, description.ptr);
    return нет;
}

/**
 * Check if an Выражение is an access to a struct member with the struct
 * defined from a literal.
 *
 * This happens with manifest constants since the инициализатор is reused as is,
 * each time the declaration is part of an Выражение, which means that the
 * literal используется as инициализатор can become a Lvalue. This Lvalue must not be modifiable.
 *
 * Параметры:
 *      exp = An Выражение that's attempted to be written.
 *            Must be the LHS of an `AssignExp`, `BinAssignExp`, `CatAssignExp`,
 *            or the Выражение passed to a modifiable function параметр.
 * Возвращает:
 *      `да` if `expr` is a dot var or a dot идентификатор touching to a struct literal,
 *      in which case an error message is issued, and `нет` otherwise.
 */
private бул checkIfIsStructLiteralDotExpr(Выражение exp)
{
    // e1.var = ...
    // e1.идент = ...
    Выражение e1;
    if (exp.op == ТОК2.dotVariable)
        e1 = exp.isDotVarExp().e1;
    else if (exp.op == ТОК2.dotIdentifier)
        e1 = exp.isDotIdExp().e1;
    else
        return нет;

    // enum SomeStruct ss = { ... }
    // also да for access from a .init: SomeStruct.init.member = ...
    if (e1.op != ТОК2.structLiteral)
        return нет;

    выведиОшибку(exp.место, "cannot modify constant Выражение `%s`", exp.вТкст0());
    return да;
}
