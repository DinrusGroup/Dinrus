/**
 * Most of the logic to implement scoped pointers and scoped references is here.
 *
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/ýñêàïèðóé.d, _escape.d)
 * Documentation:  https://dlang.org/phobos/dmd_escape.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/ýñêàïèðóé.d
 */

module dmd.escape;

import cidrus;

import util.rmem;

import dmd.aggregate;
import dmd.declaration;
import dmd.dscope;
import dmd.дсимвол;
import dmd.errors;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import drc.lexer.Identifier;
import dmd.init;
import dmd.mtype;
import dmd.printast;
import drc.ast.Node;
import drc.lexer.Tokens;
import drc.ast.Visitor;
import dmd.arraytypes;

/******************************************************
 * Checks memory objects passed to a function.
 * Checks that if a memory объект is passed by ref or by pointer,
 * all of the refs or pointers are const, or there is only one mutable
 * ref or pointer to it.
 * References:
 *      DIP 1021
 * Параметры:
 *      sc = используется to determine current function and module
 *      fd = function being called
 *      tf = fd's тип
 *      ethis = if not null, the `this` pointer
 *      arguments = actual arguments to function
 *      gag = do not print error messages
 * Возвращает:
 *      `да` if error
 */
бул checkMutableArguments(Scope* sc, FuncDeclaration fd, TypeFunction tf,
    Выражение ethis, Выражения* arguments, бул gag)
{
    const log = нет;
    if (log) printf("[%s] checkMutableArguments, fd: `%s`\n", fd.место.вТкст0(), fd.вТкст0());
    if (log && ethis) printf("ethis: `%s`\n", ethis.вТкст0());
    бул errors = нет;

    /* Outer variable references are treated as if they are extra arguments
     * passed by ref to the function (which they essentially are via the static link).
     */
    VarDeclaration[] outerVars = fd ? fd.outerVars[] : null;

    const len = arguments.length + (ethis !is null) + outerVars.length;
    if (len <= 1)
        return errors;

    struct EscapeBy
    {
        EscapeByрезультатs er;
        Параметр2 param;        // null if no Параметр2 for this argument
        бул isMutable;         // да if reference to mutable
    }

    /* Store escapeBy as static данные escapeByStorage so we can keep reusing the same
     * arrays rather than reallocating them.
     */
     EscapeBy[] escapeByStorage;
    auto escapeBy = escapeByStorage;
    if (escapeBy.length < len)
    {
        auto newPtr = cast(EscapeBy*)mem.xrealloc(escapeBy.ptr, len * EscapeBy.sizeof);
        // Clear the new section
        memset(newPtr + escapeBy.length, 0, (len - escapeBy.length) * EscapeBy.sizeof);
        escapeBy = newPtr[0 .. len];
        escapeByStorage = escapeBy;
    }

    const paramLength = tf.parameterList.length;

    // Fill in escapeBy[] with arguments[], ethis, and outerVars[]
    foreach (i, eb; escapeBy)
    {
        бул refs;
        Выражение arg;
        if (i < arguments.length)
        {
            arg = (*arguments)[i];
            if (i < paramLength)
            {
                eb.param = tf.parameterList[i];
                refs = (eb.param.классХранения & (STC.out_ | STC.ref_)) != 0;
                eb.isMutable = eb.param.isReferenceToMutable(arg.тип);
            }
            else
            {
                eb.param = null;
                refs = нет;
                eb.isMutable = arg.тип.isReferenceToMutable();
            }
        }
        else if (ethis)
        {
            /* ethis is passed by значение if a class reference,
             * by ref if a struct значение
             */
            eb.param = null;
            arg = ethis;
            auto ad = fd.isThis();
            assert(ad);
            assert(ethis);
            if (ad.isClassDeclaration())
            {
                refs = нет;
                eb.isMutable = arg.тип.isReferenceToMutable();
            }
            else
            {
                assert(ad.isStructDeclaration());
                refs = да;
                eb.isMutable = arg.тип.isMutable();
            }
        }
        else
        {
            // outer variables are passed by ref
            eb.param = null;
            refs = да;
            auto var = outerVars[i - (len - outerVars.length)];
            eb.isMutable = var.тип.isMutable();
            eb.er.byref.сунь(var);
            continue;
        }

        if (refs)
            escapeByRef(arg, &eb.er);
        else
            escapeByValue(arg, &eb.er);
    }

    foreach ( i,  eb; escapeBy[0 .. $ - 1])
    {
        foreach (VarDeclaration v; eb.er.byvalue)
        {
            if (log) printf("byvalue `%s`\n", v.вТкст0());
            if (!v.тип.hasPointers())
                continue;
            foreach (ref eb2; escapeBy[i + 1 .. $])
            {
                foreach (VarDeclaration v2; eb2.er.byvalue)
                {
                    if (log) printf("v2: `%s`\n", v2.вТкст0());
                    if (v2 != v)
                        continue;
                    if (eb.isMutable || eb2.isMutable)
                    {
                        if (глоб2.парамы.vsafe && sc.func.setUnsafe())
                        {
                            if (!gag)
                            {
                                ткст0 msg = eb.isMutable && eb2.isMutable
                                    ? "more than one mutable reference of `%s` in arguments to `%s()`"
                                    : "mutable and const references of `%s` in arguments to `%s()`";
                                выведиОшибку((*arguments)[i].место, msg,
                                    v.вТкст0(),
                                    fd ? fd.toPrettyChars() : "indirectly");
                            }
                            errors = да;
                        }
                    }
                }
            }
        }

        foreach (VarDeclaration v; eb.er.byref)
        {
            if (log) printf("byref `%s`\n", v.вТкст0());
            foreach (ref eb2; escapeBy[i + 1 .. $])
            {
                foreach (VarDeclaration v2; eb2.er.byref)
                {
                    if (log) printf("v2: `%s`\n", v2.вТкст0());
                    if (v2 != v)
                        continue;
                    //printf("v %d v2 %d\n", eb.isMutable, eb2.isMutable);
                    if (eb.isMutable || eb2.isMutable)
                    {
                        if (глоб2.парамы.vsafe && sc.func.setUnsafe())
                        {
                            if (!gag)
                            {
                                ткст0 msg = eb.isMutable && eb2.isMutable
                                    ? "more than one mutable reference to `%s` in arguments to `%s()`"
                                    : "mutable and const references to `%s` in arguments to `%s()`";
                                выведиОшибку((*arguments)[i].место, msg,
                                    v.вТкст0(),
                                    fd ? fd.toPrettyChars() : "indirectly");
                            }
                            errors = да;
                        }
                    }
                }
            }
        }
    }

    /* Reset the arrays in escapeBy[] so we can reuse them следщ time through
     */
    foreach (ref eb; escapeBy)
    {
        eb.er.сбрось();
    }

    return errors;
}

/******************************************
 * МассивДРК literal is going to be allocated on the СМ heap.
 * Check its elements to see if any would ýñêàïèðóé by going on the heap.
 * Параметры:
 *      sc = используется to determine current function and module
 *      ae = массив literal Выражение
 *      gag = do not print error messages
 * Возвращает:
 *      `да` if any elements escaped
 */
бул checkArrayLiteralEscape(Scope *sc, ArrayLiteralExp ae, бул gag)
{
    бул errors;
    if (ae.basis)
        errors = checkNewEscape(sc, ae.basis, gag);
    foreach (ex; *ae.elements)
    {
        if (ex)
            errors |= checkNewEscape(sc, ex, gag);
    }
    return errors;
}

/******************************************
 * Associative массив literal is going to be allocated on the СМ heap.
 * Check its elements to see if any would ýñêàïèðóé by going on the heap.
 * Параметры:
 *      sc = используется to determine current function and module
 *      ae = associative массив literal Выражение
 *      gag = do not print error messages
 * Возвращает:
 *      `да` if any elements escaped
 */
бул checkAssocArrayLiteralEscape(Scope *sc, AssocArrayLiteralExp ae, бул gag)
{
    бул errors;
    foreach (ex; *ae.keys)
    {
        if (ex)
            errors |= checkNewEscape(sc, ex, gag);
    }
    foreach (ex; *ae.values)
    {
        if (ex)
            errors |= checkNewEscape(sc, ex, gag);
    }
    return errors;
}

/****************************************
 * Function параметр `par` is being initialized to `arg`,
 * and `par` may ýñêàïèðóé.
 * Detect if scoped values can ýñêàïèðóé this way.
 * Print error messages when these are detected.
 * Параметры:
 *      sc = используется to determine current function and module
 *      fdc = function being called, `null` if called indirectly
 *      par = function параметр (`this` if null)
 *      arg = инициализатор for param
 *      gag = do not print error messages
 * Возвращает:
 *      `да` if pointers to the stack can ýñêàïèðóé via assignment
 */
бул checkParamArgumentEscape(Scope* sc, FuncDeclaration fdc, Параметр2 par, Выражение arg, бул gag)
{
    const log = нет;
    if (log) printf("checkParamArgumentEscape(arg: %s par: %s)\n",
        arg ? arg.вТкст0() : "null",
        par ? par.вТкст0() : "this");
    //printf("тип = %s, %d\n", arg.тип.вТкст0(), arg.тип.hasPointers());

    if (!arg.тип.hasPointers())
        return нет;

    EscapeByрезультатs er;

    escapeByValue(arg, &er);

    if (!er.byref.dim && !er.byvalue.dim && !er.byfunc.dim && !er.byexp.dim)
        return нет;

    бул результат = нет;

    /* 'v' is assigned unsafely to 'par'
     */
    проц unsafeAssign(VarDeclaration v, ткст0 desc)
    {
        if (глоб2.парамы.vsafe && sc.func.setUnsafe())
        {
            if (!gag)
                выведиОшибку(arg.место, "%s `%s` assigned to non-scope параметр `%s` calling %s",
                    desc, v.вТкст0(),
                    par ? par.вТкст0() : "this",
                    fdc ? fdc.toPrettyChars() : "indirectly");
            результат = да;
        }
    }

    foreach (VarDeclaration v; er.byvalue)
    {
        if (log) printf("byvalue %s\n", v.вТкст0());
        if (v.isDataseg())
            continue;

        ДСимвол p = v.toParent2();

        notMaybeScope(v);

        if (v.isScope())
        {
            unsafeAssign(v, "scope variable");
        }
        else if (v.класс_хранения & STC.variadic && p == sc.func)
        {
            Тип tb = v.тип.toBasetype();
            if (tb.ty == Tarray || tb.ty == Tsarray)
            {
                unsafeAssign(v, "variadic variable");
            }
        }
        else
        {
            /* v is not 'scope', and is assigned to a параметр that may ýñêàïèðóé.
             * Therefore, v can never be 'scope'.
             */
            if (log) printf("no infer for %s in %s место %s, fdc %s, %d\n",
                v.вТкст0(), sc.func.идент.вТкст0(), sc.func.место.вТкст0(), fdc.идент.вТкст0(),  __LINE__);
            v.doNotInferScope = да;
        }
    }

    foreach (VarDeclaration v; er.byref)
    {
        if (log) printf("byref %s\n", v.вТкст0());
        if (v.isDataseg())
            continue;

        ДСимвол p = v.toParent2();

        notMaybeScope(v);

        if ((v.класс_хранения & (STC.ref_ | STC.out_)) == 0 && p == sc.func)
        {
            if (par && (par.классХранения & (STC.scope_ | STC.return_)) == STC.scope_)
                continue;

            unsafeAssign(v, "reference to local variable");
            continue;
        }
    }

    foreach (FuncDeclaration fd; er.byfunc)
    {
        //printf("fd = %s, %d\n", fd.вТкст0(), fd.tookAddressOf);
        VarDeclarations vars;
        findAllOuterAccessedVariables(fd, &vars);

        foreach (v; vars)
        {
            //printf("v = %s\n", v.вТкст0());
            assert(!v.isDataseg());     // these are not put in the closureVars[]

            ДСимвол p = v.toParent2();

            notMaybeScope(v);

            if ((v.класс_хранения & (STC.ref_ | STC.out_ | STC.scope_)) && p == sc.func)
            {
                unsafeAssign(v, "reference to local");
                continue;
            }
        }
    }

    foreach (Выражение ee; er.byexp)
    {
        if (sc.func.setUnsafe())
        {
            if (!gag)
                выведиОшибку(ee.место, "reference to stack allocated значение returned by `%s` assigned to non-scope параметр `%s`",
                    ee.вТкст0(),
                    par ? par.вТкст0() : "this");
            результат = да;
        }
    }

    return результат;
}

/*****************************************************
 * Function argument initializes a `return` параметр,
 * and that параметр gets assigned to `firstArg`.
 * Essentially, treat as `firstArg = arg;`
 * Параметры:
 *      sc = используется to determine current function and module
 *      firstArg = `ref` argument through which `arg` may be assigned
 *      arg = инициализатор for параметр
 *      gag = do not print error messages
 * Возвращает:
 *      `да` if assignment to `firstArg` would cause an error
 */
бул checkParamArgumentReturn(Scope* sc, Выражение firstArg, Выражение arg, бул gag)
{
    const log = нет;
    if (log) printf("checkParamArgumentReturn(firstArg: %s arg: %s)\n",
        firstArg.вТкст0(), arg.вТкст0());
    //printf("тип = %s, %d\n", arg.тип.вТкст0(), arg.тип.hasPointers());

    if (!arg.тип.hasPointers())
        return нет;

    scope e = new AssignExp(arg.место, firstArg, arg);
    return checkAssignEscape(sc, e, gag);
}

/*****************************************************
 * Check struct constructor of the form `s.this(args)`, by
 * checking each `return` параметр to see if it gets
 * assigned to `s`.
 * Параметры:
 *      sc = используется to determine current function and module
 *      ce = constructor call of the form `s.this(args)`
 *      gag = do not print error messages
 * Возвращает:
 *      `да` if construction would cause an escaping reference error
 */
бул checkConstructorEscape(Scope* sc, CallExp ce, бул gag)
{
    const log = нет;
    if (log) printf("checkConstructorEscape(%s, %s)\n", ce.вТкст0(), ce.тип.вТкст0());
    Тип tthis = ce.тип.toBasetype();
    assert(tthis.ty == Tstruct);
    if (!tthis.hasPointers())
        return нет;

    if (!ce.arguments && ce.arguments.dim)
        return нет;

    assert(ce.e1.op == ТОК2.dotVariable);
    DotVarExp dve = cast(DotVarExp)ce.e1;
    CtorDeclaration ctor = dve.var.isCtorDeclaration();
    assert(ctor);
    assert(ctor.тип.ty == Tfunction);
    TypeFunction tf = cast(TypeFunction)ctor.тип;

    const nparams = tf.parameterList.length;
    const n = ce.arguments.dim;

    // j=1 if _arguments[] is first argument
    const j = tf.isDstyleVariadic();

    /* Attempt to assign each `return` arg to the `this` reference
     */
    foreach (i; new бцел[0 .. n])
    {
        Выражение arg = (*ce.arguments)[i];
        if (!arg.тип.hasPointers())
            return нет;

        //printf("\targ[%d]: %s\n", i, arg.вТкст0());

        if (i - j < nparams && i >= j)
        {
            Параметр2 p = tf.parameterList[i - j];

            if (p.классХранения & STC.return_)
            {
                /* Fake `dve.e1 = arg;` and look for scope violations
                 */
                scope e = new AssignExp(arg.место, dve.e1, arg);
                if (checkAssignEscape(sc, e, gag))
                    return да;
            }
        }
    }

    return нет;
}

/****************************************
 * Given an `AssignExp`, determine if the lvalue will cause
 * the contents of the rvalue to ýñêàïèðóé.
 * Print error messages when these are detected.
 * Infer `scope` attribute for the lvalue where possible, in order
 * to eliminate the error.
 * Параметры:
 *      sc = используется to determine current function and module
 *      e = `AssignExp` or `CatAssignExp` to check for any pointers to the stack
 *      gag = do not print error messages
 * Возвращает:
 *      `да` if pointers to the stack can ýñêàïèðóé via assignment
 */
бул checkAssignEscape(Scope* sc, Выражение e, бул gag)
{
    const log = нет;
    if (log) printf("checkAssignEscape(e: %s)\n", e.вТкст0());
    if (e.op != ТОК2.assign && e.op != ТОК2.blit && e.op != ТОК2.construct &&
        e.op != ТОК2.concatenateAssign && e.op != ТОК2.concatenateElemAssign && e.op != ТОК2.concatenateDcharAssign)
        return нет;
    auto ae = cast(BinExp)e;
    Выражение e1 = ae.e1;
    Выражение e2 = ae.e2;
    //printf("тип = %s, %d\n", e1.тип.вТкст0(), e1.тип.hasPointers());

    if (!e1.тип.hasPointers())
        return нет;

    if (e1.op == ТОК2.slice)
        return нет;

    /* The struct literal case can arise from the S(e2) constructor call:
     *    return S(e2);
     * and appears in this function as:
     *    structLiteral = e2;
     * Such an assignment does not necessarily удали scope-ness.
     */
    if (e1.op == ТОК2.structLiteral)
        return нет;

    EscapeByрезультатs er;

    escapeByValue(e2, &er);

    if (!er.byref.dim && !er.byvalue.dim && !er.byfunc.dim && !er.byexp.dim)
        return нет;

    VarDeclaration va = expToVariable(e1);

    if (va && e.op == ТОК2.concatenateElemAssign)
    {
        /* https://issues.dlang.org/show_bug.cgi?ид=17842
         * Draw an equivalence between:
         *   *q = p;
         * and:
         *   va ~= e;
         * since we are not assigning to va, but are assigning indirectly through va.
         */
        va = null;
    }

    if (va && e1.op == ТОК2.dotVariable && va.тип.toBasetype().ty == Tclass)
    {
        /* https://issues.dlang.org/show_bug.cgi?ид=17949
         * Draw an equivalence between:
         *   *q = p;
         * and:
         *   va.field = e2;
         * since we are not assigning to va, but are assigning indirectly through class reference va.
         */
        va = null;
    }

    if (log && va) printf("va: %s\n", va.вТкст0());

    // Try to infer 'scope' for va if in a function not marked @system
    бул inferScope = нет;
    if (va && sc.func && sc.func.тип && sc.func.тип.ty == Tfunction)
        inferScope = (cast(TypeFunction)sc.func.тип).trust != TRUST.system;
    //printf("inferScope = %d, %d\n", inferScope, (va.класс_хранения & STCmaybescope) != 0);

    // Determine if va is a параметр that is an indirect reference
    const бул vaIsRef = va && va.класс_хранения & STC.параметр &&
        (va.класс_хранения & (STC.ref_ | STC.out_) || va.тип.toBasetype().ty == Tclass);
    if (log && vaIsRef) printf("va is ref `%s`\n", va.вТкст0());

    /* Determine if va is the first параметр, through which other 'return' parameters
     * can be assigned.
     */
    бул isFirstRef()
    {
        if (!vaIsRef)
            return нет;
        ДСимвол p = va.toParent2();
        FuncDeclaration fd = sc.func;
        if (p == fd && fd.тип && fd.тип.ty == Tfunction)
        {
            TypeFunction tf = cast(TypeFunction)fd.тип;
            if (!tf.nextOf() || (tf.nextOf().ty != Tvoid && !fd.isCtorDeclaration()))
                return нет;
            if (va == fd.vthis)
                return да;
            if (fd.parameters && fd.parameters.dim && (*fd.parameters)[0] == va)
                return да;
        }
        return нет;
    }
    const бул vaIsFirstRef = isFirstRef();
    if (log && vaIsFirstRef) printf("va is first ref `%s`\n", va.вТкст0());

    бул результат = нет;
    foreach (VarDeclaration v; er.byvalue)
    {
        if (log) printf("byvalue: %s\n", v.вТкст0());
        if (v.isDataseg())
            continue;

        if (v == va)
            continue;

        ДСимвол p = v.toParent2();

        if (va && !vaIsRef && !va.isScope() && !v.isScope() &&
            (va.класс_хранения & v.класс_хранения & (STC.maybescope | STC.variadic)) == STC.maybescope &&
            p == sc.func)
        {
            /* Add v to va's list of dependencies
             */
            va.addMaybe(v);
            continue;
        }

        if (vaIsFirstRef &&
            (v.isScope() || (v.класс_хранения & STC.maybescope)) &&
            !(v.класс_хранения & STC.return_) &&
            v.isParameter() &&
            sc.func.flags & FUNCFLAG.returnInprocess &&
            p == sc.func)
        {
            if (log) printf("inferring 'return' for параметр %s in function %s\n", v.вТкст0(), sc.func.вТкст0());
            inferReturn(sc.func, v);        // infer addition of 'return'
        }

        if (!(va && va.isScope()) || vaIsRef)
            notMaybeScope(v);

        if (v.isScope())
        {
            if (vaIsFirstRef && v.isParameter() && v.класс_хранения & STC.return_)
            {
                if (va.isScope())
                    continue;

                if (inferScope && !va.doNotInferScope)
                {
                    if (log) printf("inferring scope for lvalue %s\n", va.вТкст0());
                    va.класс_хранения |= STC.scope_ | STC.scopeinferred;
                    continue;
                }
            }

            if (va && va.isScope() && va.класс_хранения & STC.return_ && !(v.класс_хранения & STC.return_) &&
                sc.func.setUnsafe())
            {
                if (!gag)
                    выведиОшибку(ae.место, "scope variable `%s` assigned to return scope `%s`", v.вТкст0(), va.вТкст0());
                результат = да;
                continue;
            }

            // If va's lifetime encloses v's, then error
            if (va &&
                (va.enclosesLifetimeOf(v) && !(v.класс_хранения & (STC.параметр | STC.temp)) ||
                 // va is class reference
                 ae.e1.op == ТОК2.dotVariable && va.тип.toBasetype().ty == Tclass && (va.enclosesLifetimeOf(v) || !va.isScope()) ||
                 vaIsRef ||
                 va.класс_хранения & (STC.ref_ | STC.out_) && !(v.класс_хранения & (STC.параметр | STC.temp))) &&
                sc.func.setUnsafe())
            {
                if (!gag)
                    выведиОшибку(ae.место, "scope variable `%s` assigned to `%s` with longer lifetime", v.вТкст0(), va.вТкст0());
                результат = да;
                continue;
            }

            if (va && !va.isDataseg() && !va.doNotInferScope)
            {
                if (!va.isScope() && inferScope)
                {   //printf("inferring scope for %s\n", va.вТкст0());
                    va.класс_хранения |= STC.scope_ | STC.scopeinferred;
                    if (v.класс_хранения & STC.return_ &&
                        !(va.класс_хранения & STC.return_))
                    {
                        va.класс_хранения |= STC.return_ | STC.returninferred;
                    }
                }
                continue;
            }
            if (sc.func.setUnsafe())
            {
                if (!gag)
                    выведиОшибку(ae.место, "scope variable `%s` assigned to non-scope `%s`", v.вТкст0(), e1.вТкст0());
                результат = да;
            }
        }
        else if (v.класс_хранения & STC.variadic && p == sc.func)
        {
            Тип tb = v.тип.toBasetype();
            if (tb.ty == Tarray || tb.ty == Tsarray)
            {
                if (va && !va.isDataseg() && !va.doNotInferScope)
                {
                    if (!va.isScope() && inferScope)
                    {   //printf("inferring scope for %s\n", va.вТкст0());
                        va.класс_хранения |= STC.scope_ | STC.scopeinferred;
                    }
                    continue;
                }
                if (sc.func.setUnsafe())
                {
                    if (!gag)
                        выведиОшибку(ae.место, "variadic variable `%s` assigned to non-scope `%s`", v.вТкст0(), e1.вТкст0());
                    результат = да;
                }
            }
        }
        else
        {
            /* v is not 'scope', and we didn't check the scope of where we assigned it to.
             * It may ýñêàïèðóé via that assignment, therefore, v can never be 'scope'.
             */
            //printf("no infer for %s in %s, %d\n", v.вТкст0(), sc.func.идент.вТкст0(), __LINE__);
            v.doNotInferScope = да;
        }
    }

ByRef:
    foreach (VarDeclaration v; er.byref)
    {
        if (log) printf("byref: %s\n", v.вТкст0());
        if (v.isDataseg())
            continue;

        if (глоб2.парамы.vsafe)
        {
            if (va && va.isScope() && (v.класс_хранения & (STC.ref_ | STC.out_)) == 0)
            {
                if (!(va.класс_хранения & STC.return_))
                {
                    va.doNotInferReturn = да;
                }
                else if (sc.func.setUnsafe())
                {
                    if (!gag)
                        выведиОшибку(ae.место, "address of local variable `%s` assigned to return scope `%s`", v.вТкст0(), va.вТкст0());
                    результат = да;
                    continue;
                }
            }
        }

        ДСимвол p = v.toParent2();

        // If va's lifetime encloses v's, then error
        if (va &&
            (va.enclosesLifetimeOf(v) && !(v.класс_хранения & STC.параметр) ||
             va.класс_хранения & STC.ref_ ||
             va.isDataseg()) &&
            sc.func.setUnsafe())
        {
            if (!gag)
                выведиОшибку(ae.место, "address of variable `%s` assigned to `%s` with longer lifetime", v.вТкст0(), va.вТкст0());
            результат = да;
            continue;
        }

        if (va && v.класс_хранения & (STC.ref_ | STC.out_))
        {
            ДСимвол pva = va.toParent2();
            for (ДСимвол pv = p; pv; )
            {
                pv = pv.toParent2();
                if (pva == pv)  // if v is nested inside pva
                {
                    if (sc.func.setUnsafe())
                    {
                        if (!gag)
                            выведиОшибку(ae.место, "reference `%s` assigned to `%s` with longer lifetime", v.вТкст0(), va.вТкст0());
                        результат = да;
                        continue ByRef;
                    }
                    break;
                }
            }
        }

        if (!(va && va.isScope()))
            notMaybeScope(v);

        if ((v.класс_хранения & (STC.ref_ | STC.out_)) == 0 && p == sc.func)
        {
            if (va && !va.isDataseg() && !va.doNotInferScope)
            {
                if (!va.isScope() && inferScope)
                {   //printf("inferring scope for %s\n", va.вТкст0());
                    va.класс_хранения |= STC.scope_ | STC.scopeinferred;
                }
                continue;
            }
            if (e1.op == ТОК2.structLiteral)
                continue;
            if (sc.func.setUnsafe())
            {
                if (!gag)
                    выведиОшибку(ae.место, "reference to local variable `%s` assigned to non-scope `%s`", v.вТкст0(), e1.вТкст0());
                результат = да;
            }
            continue;
        }
    }

    foreach (FuncDeclaration fd; er.byfunc)
    {
        if (log) printf("byfunc: %s, %d\n", fd.вТкст0(), fd.tookAddressOf);
        VarDeclarations vars;
        findAllOuterAccessedVariables(fd, &vars);

        /* https://issues.dlang.org/show_bug.cgi?ид=16037
         * If assigning the address of a delegate to a scope variable,
         * then uncount that address of. This is so it won't cause a
         * closure to be allocated.
         */
        if (va && va.isScope() && fd.tookAddressOf && глоб2.парамы.vsafe)
            --fd.tookAddressOf;

        foreach (v; vars)
        {
            //printf("v = %s\n", v.вТкст0());
            assert(!v.isDataseg());     // these are not put in the closureVars[]

            ДСимвол p = v.toParent2();

            if (!(va && va.isScope()))
                notMaybeScope(v);

            if ((v.класс_хранения & (STC.ref_ | STC.out_ | STC.scope_)) && p == sc.func)
            {
                if (va && !va.isDataseg() && !va.doNotInferScope)
                {
                    /* Don't infer STC.scope_ for va, because then a closure
                     * won't be generated for sc.func.
                     */
                    //if (!va.isScope() && inferScope)
                        //va.класс_хранения |= STC.scope_ | STC.scopeinferred;
                    continue;
                }
                if (sc.func.setUnsafe())
                {
                    if (!gag)
                        выведиОшибку(ae.место, "reference to local `%s` assigned to non-scope `%s` in  code", v.вТкст0(), e1.вТкст0());
                    результат = да;
                }
                continue;
            }
        }
    }

    foreach (Выражение ee; er.byexp)
    {
        if (log) printf("byexp: %s\n", ee.вТкст0());

        /* Do not allow slicing of a static массив returned by a function
         */
        if (va && ee.op == ТОК2.call && ee.тип.toBasetype().ty == Tsarray && va.тип.toBasetype().ty == Tarray &&
            !(va.класс_хранения & STC.temp))
        {
            if (!gag)
                deprecation(ee.место, "slice of static массив temporary returned by `%s` assigned to longer lived variable `%s`",
                    ee.вТкст0(), va.вТкст0());
            //результат = да;
            continue;
        }

        if (va && !va.isDataseg() && !va.doNotInferScope)
        {
            if (!va.isScope() && inferScope)
            {   //printf("inferring scope for %s\n", va.вТкст0());
                va.класс_хранения |= STC.scope_ | STC.scopeinferred;
            }
            continue;
        }

        if (sc.func.setUnsafe())
        {
            if (!gag)
                выведиОшибку(ee.место, "reference to stack allocated значение returned by `%s` assigned to non-scope `%s`",
                    ee.вТкст0(), e1.вТкст0());
            результат = да;
        }
    }

    return результат;
}

/************************************
 * Detect cases where pointers to the stack can ýñêàïèðóé the
 * lifetime of the stack frame when throwing `e`.
 * Print error messages when these are detected.
 * Параметры:
 *      sc = используется to determine current function and module
 *      e = Выражение to check for any pointers to the stack
 *      gag = do not print error messages
 * Возвращает:
 *      `да` if pointers to the stack can ýñêàïèðóé
 */
бул checkThrowEscape(Scope* sc, Выражение e, бул gag)
{
    //printf("[%s] checkThrowEscape, e = %s\n", e.место.вТкст0(), e.вТкст0());
    EscapeByрезультатs er;

    escapeByValue(e, &er);

    if (!er.byref.dim && !er.byvalue.dim && !er.byexp.dim)
        return нет;

    бул результат = нет;
    foreach (VarDeclaration v; er.byvalue)
    {
        //printf("byvalue %s\n", v.вТкст0());
        if (v.isDataseg())
            continue;

        if (v.isScope() && !v.iscatchvar)       // special case: allow catch var to be rethrown
                                                // despite being `scope`
        {
            if (sc._module && sc._module.isRoot())
            {
                // Only look for errors if in module listed on command line
                if (глоб2.парамы.vsafe) // https://issues.dlang.org/show_bug.cgi?ид=17029
                {
                    if (!gag)
                        выведиОшибку(e.место, "scope variable `%s` may not be thrown", v.вТкст0());
                    результат = да;
                }
                continue;
            }
        }
        else
        {
            //printf("no infer for %s in %s, %d\n", v.вТкст0(), sc.func.идент.вТкст0(), __LINE__);
            v.doNotInferScope = да;
        }
    }
    return результат;
}

/************************************
 * Detect cases where pointers to the stack can ýñêàïèðóé the
 * lifetime of the stack frame by being placed into a СМ allocated объект.
 * Print error messages when these are detected.
 * Параметры:
 *      sc = используется to determine current function and module
 *      e = Выражение to check for any pointers to the stack
 *      gag = do not print error messages
 * Возвращает:
 *      `да` if pointers to the stack can ýñêàïèðóé
 */
бул checkNewEscape(Scope* sc, Выражение e, бул gag)
{
    //printf("[%s] checkNewEscape, e = %s\n", e.место.вТкст0(), e.вТкст0());
    const log = нет;
    if (log) printf("[%s] checkNewEscape, e: `%s`\n", e.место.вТкст0(), e.вТкст0());
    EscapeByрезультатs er;

    escapeByValue(e, &er);

    if (!er.byref.dim && !er.byvalue.dim && !er.byexp.dim)
        return нет;

    бул результат = нет;
    foreach (VarDeclaration v; er.byvalue)
    {
        if (log) printf("byvalue `%s`\n", v.вТкст0());
        if (v.isDataseg())
            continue;

        ДСимвол p = v.toParent2();

        if (v.isScope())
        {
            if (sc._module && sc._module.isRoot() &&
                /* This case comes up when the ReturnStatement of a __foreachbody is
                 * checked for escapes by the caller of __foreachbody. Skip it.
                 *
                 * struct S { static цел opApply(цел delegate(S*) dg); }
                 * S* foo() {
                 *    foreach (S* s; S) // создай __foreachbody for body of foreach
                 *        return s;     // s is inferred as 'scope' but incorrectly tested in foo()
                 *    return null; }
                 */
                !(p.родитель == sc.func))
            {
                // Only look for errors if in module listed on command line
                if (глоб2.парамы.vsafe) // https://issues.dlang.org/show_bug.cgi?ид=17029
                {
                    if (!gag)
                        выведиОшибку(e.место, "scope variable `%s` may not be copied into allocated memory", v.вТкст0());
                    результат = да;
                }
                continue;
            }
        }
        else if (v.класс_хранения & STC.variadic && p == sc.func)
        {
            Тип tb = v.тип.toBasetype();
            if (tb.ty == Tarray || tb.ty == Tsarray)
            {
                if (!gag)
                    выведиОшибку(e.место, "copying `%s` into allocated memory escapes a reference to variadic параметр `%s`", e.вТкст0(), v.вТкст0());
                результат = нет;
            }
        }
        else
        {
            //printf("no infer for %s in %s, %d\n", v.вТкст0(), sc.func.идент.вТкст0(), __LINE__);
            v.doNotInferScope = да;
        }
    }

    foreach (VarDeclaration v; er.byref)
    {
        if (log) printf("byref `%s`\n", v.вТкст0());

        проц escapingRef(VarDeclaration v)
        {
            if (!gag)
            {
                ткст0 вид = (v.класс_хранения & STC.параметр) ? "параметр" : "local";
                выведиОшибку(e.место, "copying `%s` into allocated memory escapes a reference to %s variable `%s`",
                    e.вТкст0(), вид, v.вТкст0());
            }
            результат = да;
        }

        if (v.isDataseg())
            continue;

        ДСимвол p = v.toParent2();

        if ((v.класс_хранения & (STC.ref_ | STC.out_)) == 0)
        {
            if (p == sc.func)
            {
                escapingRef(v);
                continue;
            }
        }

        /* Check for returning a ref variable by 'ref', but should be 'return ref'
         * Infer the addition of 'return', or set результат to be the offending Выражение.
         */
        if (v.класс_хранения & (STC.ref_ | STC.out_))
        {
            if (глоб2.парамы.useDIP25 &&
                     sc._module && sc._module.isRoot())
            {
                // https://dlang.org/spec/function.html#return-ref-parameters
                // Only look for errors if in module listed on command line

                if (p == sc.func)
                {
                    //printf("escaping reference to local ref variable %s\n", v.вТкст0());
                    //printf("storage class = x%llx\n", v.класс_хранения);
                    escapingRef(v);
                    continue;
                }
                // Don't need to be concerned if v's родитель does not return a ref
                FuncDeclaration fd = p.isFuncDeclaration();
                if (fd && fd.тип && fd.тип.ty == Tfunction)
                {
                    TypeFunction tf = cast(TypeFunction)fd.тип;
                    if (tf.isref)
                    {
                        if (!gag)
                            выведиОшибку(e.место, "storing reference to outer local variable `%s` into allocated memory causes it to ýñêàïèðóé",
                                  v.вТкст0());
                        результат = да;
                        continue;
                    }
                }

            }
        }
    }

    foreach (Выражение ee; er.byexp)
    {
        if (log) printf("byexp %s\n", ee.вТкст0());
        if (!gag)
            выведиОшибку(ee.место, "storing reference to stack allocated значение returned by `%s` into allocated memory causes it to ýñêàïèðóé",
                  ee.вТкст0());
        результат = да;
    }

    return результат;
}


/************************************
 * Detect cases where pointers to the stack can ýñêàïèðóé the
 * lifetime of the stack frame by returning `e` by значение.
 * Print error messages when these are detected.
 * Параметры:
 *      sc = используется to determine current function and module
 *      e = Выражение to check for any pointers to the stack
 *      gag = do not print error messages
 * Возвращает:
 *      `да` if pointers to the stack can ýñêàïèðóé
 */
бул checkReturnEscape(Scope* sc, Выражение e, бул gag)
{
    //printf("[%s] checkReturnEscape, e: %s\n", e.место.вТкст0(), e.вТкст0());
    return checkReturnEscapeImpl(sc, e, нет, gag);
}

/************************************
 * Detect cases where returning `e` by `ref` can результат in a reference to the stack
 * being returned.
 * Print error messages when these are detected.
 * Параметры:
 *      sc = используется to determine current function and module
 *      e = Выражение to check
 *      gag = do not print error messages
 * Возвращает:
 *      `да` if references to the stack can ýñêàïèðóé
 */
бул checkReturnEscapeRef(Scope* sc, Выражение e, бул gag)
{
    version (none)
    {
        printf("[%s] checkReturnEscapeRef, e = %s\n", e.место.вТкст0(), e.вТкст0());
        printf("current function %s\n", sc.func.вТкст0());
        printf("parent2 function %s\n", sc.func.toParent2().вТкст0());
    }

    return checkReturnEscapeImpl(sc, e, да, gag);
}

/***************************************
 * Implementation of checking for escapes in return Выражения.
 * Параметры:
 *      sc = используется to determine current function and module
 *      e = Выражение to check
 *      refs = `да`: ýñêàïèðóé by значение, `нет`: ýñêàïèðóé by `ref`
 *      gag = do not print error messages
 * Возвращает:
 *      `да` if references to the stack can ýñêàïèðóé
 */
private бул checkReturnEscapeImpl(Scope* sc, Выражение e, бул refs, бул gag)
{
    const log = нет;
    if (log) printf("[%s] checkReturnEscapeImpl, refs: %d e: `%s`\n", e.место.вТкст0(), refs, e.вТкст0());
    EscapeByрезультатs er;

    if (refs)
        escapeByRef(e, &er);
    else
        escapeByValue(e, &er);

    if (!er.byref.dim && !er.byvalue.dim && !er.byexp.dim)
        return нет;

    бул результат = нет;
    foreach (VarDeclaration v; er.byvalue)
    {
        if (log) printf("byvalue `%s`\n", v.вТкст0());
        if (v.isDataseg())
            continue;

        ДСимвол p = v.toParent2();

        if ((v.isScope() || (v.класс_хранения & STC.maybescope)) &&
            !(v.класс_хранения & STC.return_) &&
            v.isParameter() &&
            !v.doNotInferReturn &&
            sc.func.flags & FUNCFLAG.returnInprocess &&
            p == sc.func)
        {
            inferReturn(sc.func, v);        // infer addition of 'return'
            continue;
        }

        if (v.isScope())
        {
            if (v.класс_хранения & STC.return_)
                continue;

            if (sc._module && sc._module.isRoot() &&
                /* This case comes up when the ReturnStatement of a __foreachbody is
                 * checked for escapes by the caller of __foreachbody. Skip it.
                 *
                 * struct S { static цел opApply(цел delegate(S*) dg); }
                 * S* foo() {
                 *    foreach (S* s; S) // создай __foreachbody for body of foreach
                 *        return s;     // s is inferred as 'scope' but incorrectly tested in foo()
                 *    return null; }
                 */
                !(!refs && p.родитель == sc.func && p.isFuncDeclaration() && p.isFuncDeclaration().fes) &&
                /*
                 *  auto p(scope ткст s) {
                 *      ткст scfunc() { return s; }
                 *  }
                 */
                !(!refs && p.isFuncDeclaration() && sc.func.isFuncDeclaration().getLevel(p.isFuncDeclaration(), sc.intypeof) > 0)
               )
            {
                // Only look for errors if in module listed on command line
                if (глоб2.парамы.vsafe) // https://issues.dlang.org/show_bug.cgi?ид=17029
                {
                    if (!gag)
                        выведиОшибку(e.место, "scope variable `%s` may not be returned", v.вТкст0());
                    результат = да;
                }
                continue;
            }
        }
        else if (v.класс_хранения & STC.variadic && p == sc.func)
        {
            Тип tb = v.тип.toBasetype();
            if (tb.ty == Tarray || tb.ty == Tsarray)
            {
                if (!gag)
                    выведиОшибку(e.место, "returning `%s` escapes a reference to variadic параметр `%s`", e.вТкст0(), v.вТкст0());
                результат = нет;
            }
        }
        else
        {
            //printf("no infer for %s in %s, %d\n", v.вТкст0(), sc.func.идент.вТкст0(), __LINE__);
            v.doNotInferScope = да;
        }
    }

    foreach (VarDeclaration v; er.byref)
    {
        if (log) printf("byref `%s`\n", v.вТкст0());

        проц escapingRef(VarDeclaration v)
        {
            if (!gag)
            {
                ткст0 msg;
                if (v.класс_хранения & STC.параметр)
                    msg = "returning `%s` escapes a reference to параметр `%s`, perhaps annotate with `return`";
                else
                    msg = "returning `%s` escapes a reference to local variable `%s`";
                выведиОшибку(e.место, msg, e.вТкст0(), v.вТкст0());
            }
            результат = да;
        }

        if (v.isDataseg())
            continue;

        ДСимвол p = v.toParent2();

        // https://issues.dlang.org/show_bug.cgi?ид=19965
        if (!refs && sc.func.vthis == v)
            notMaybeScope(v);

        if ((v.класс_хранения & (STC.ref_ | STC.out_)) == 0)
        {
            if (p == sc.func)
            {
                escapingRef(v);
                continue;
            }
            FuncDeclaration fd = p.isFuncDeclaration();
            if (fd && sc.func.flags & FUNCFLAG.returnInprocess)
            {
                /* Code like:
                 *   цел x;
                 *   auto dg = () { return &x; }
                 * Making it:
                 *   auto dg = () return { return &x; }
                 * Because dg.ptr points to x, this is returning dt.ptr+смещение
                 */
                if (глоб2.парамы.vsafe)
                {
                    sc.func.класс_хранения |= STC.return_ | STC.returninferred;
                }
            }

        }

        /* Check for returning a ref variable by 'ref', but should be 'return ref'
         * Infer the addition of 'return', or set результат to be the offending Выражение.
         */
        if ( (v.класс_хранения & (STC.ref_ | STC.out_)) &&
            !(v.класс_хранения & (STC.return_ | STC.foreach_)))
        {
            if (sc.func.flags & FUNCFLAG.returnInprocess && p == sc.func)
            {
                inferReturn(sc.func, v);        // infer addition of 'return'
            }
            else if (глоб2.парамы.useDIP25 &&
                     sc._module && sc._module.isRoot())
            {
                // https://dlang.org/spec/function.html#return-ref-parameters
                // Only look for errors if in module listed on command line

                if (p == sc.func)
                {
                    //printf("escaping reference to local ref variable %s\n", v.вТкст0());
                    //printf("storage class = x%llx\n", v.класс_хранения);
                    escapingRef(v);
                    continue;
                }
                // Don't need to be concerned if v's родитель does not return a ref
                FuncDeclaration fd = p.isFuncDeclaration();
                if (fd && fd.тип && fd.тип.ty == Tfunction)
                {
                    TypeFunction tf = cast(TypeFunction)fd.тип;
                    if (tf.isref)
                    {
                        if (!gag)
                            выведиОшибку(e.место, "escaping reference to outer local variable `%s`", v.вТкст0());
                        результат = да;
                        continue;
                    }
                }

            }
        }
    }

    foreach (Выражение ee; er.byexp)
    {
        if (log) printf("byexp %s\n", ee.вТкст0());
        if (!gag)
            выведиОшибку(ee.место, "escaping reference to stack allocated значение returned by `%s`", ee.вТкст0());
        результат = да;
    }

    return результат;
}


/*************************************
 * Variable v needs to have 'return' inferred for it.
 * Параметры:
 *      fd = function that v is a параметр to
 *      v = параметр that needs to be STC.return_
 */

private проц inferReturn(FuncDeclaration fd, VarDeclaration v)
{
    // v is a local in the current function

    //printf("for function '%s' inferring 'return' for variable '%s'\n", fd.вТкст0(), v.вТкст0());
    v.класс_хранения |= STC.return_ | STC.returninferred;

    TypeFunction tf = cast(TypeFunction)fd.тип;
    if (v == fd.vthis)
    {
        /* v is the 'this' reference, so mark the function
         */
        fd.класс_хранения |= STC.return_ | STC.returninferred;
        if (tf.ty == Tfunction)
        {
            //printf("'this' too %p %s\n", tf, sc.func.вТкст0());
            tf.isreturn = да;
            tf.isreturninferred = да;
        }
    }
    else
    {
        // Perform 'return' inference on параметр
        if (tf.ty == Tfunction)
        {
            const dim = tf.parameterList.length;
            foreach ( i; new бцел[0 .. dim])
            {
                Параметр2 p = tf.parameterList[i];
                if (p.идент == v.идент)
                {
                    p.классХранения |= STC.return_ | STC.returninferred;
                    break;              // there can be only one
                }
            }
        }
    }
}


/****************************************
 * e is an Выражение to be returned by значение, and that значение содержит pointers.
 * Walk e to determine which variables are possibly being
 * returned by значение, such as:
 *      цел* function(цел* p) { return p; }
 * If e is a form of &p, determine which variables have content
 * which is being returned as ref, such as:
 *      цел* function(цел i) { return &i; }
 * Multiple variables can be inserted, because of Выражения like this:
 *      цел function(бул b, цел i, цел* p) { return b ? &i : p; }
 *
 * No side effects.
 *
 * Параметры:
 *      e = Выражение to be returned by значение
 *      er = where to place collected данные
 *      live = if @live semantics apply, i.e. Выражения `p`, `*p`, `**p`, etc., all return `p`.
 */
проц escapeByValue(Выражение e, EscapeByрезультатs* er, бул live = нет)
{
    //printf("[%s] escapeByValue, e: %s\n", e.место.вТкст0(), e.вТкст0());
     final class EscapeVisitor : Визитор2
    {
        alias Визитор2.посети посети;
    public:
        EscapeByрезультатs* er;
        бул live;

        this(EscapeByрезультатs* er, бул live)
        {
            this.er = er;
            this.live = live;
        }

        override проц посети(Выражение e)
        {
        }

        override проц посети(AddrExp e)
        {
            /* Taking the address of struct literal is normally not
             * allowed, but CTFE can generate one out of a new Выражение,
             * but it'll be placed in static данные so no need to check it.
             */
            if (e.e1.op != ТОК2.structLiteral)
                escapeByRef(e.e1, er, live);
        }

        override проц посети(SymOffExp e)
        {
            VarDeclaration v = e.var.isVarDeclaration();
            if (v)
                er.byref.сунь(v);
        }

        override проц посети(VarExp e)
        {
            VarDeclaration v = e.var.isVarDeclaration();
            if (v)
                er.byvalue.сунь(v);
        }

        override проц посети(ThisExp e)
        {
            if (e.var)
                er.byvalue.сунь(e.var);
        }

        override проц посети(PtrExp e)
        {
            if (live && e.тип.hasPointers())
                e.e1.прими(this);
        }

        override проц посети(DotVarExp e)
        {
            auto t = e.e1.тип.toBasetype();
            if (!live && t.ty == Tstruct ||
                live && e.тип.hasPointers())
            {
                e.e1.прими(this);
            }
        }

        override проц посети(DelegateExp e)
        {
            Тип t = e.e1.тип.toBasetype();
            if (t.ty == Tclass || t.ty == Tpointer)
                escapeByValue(e.e1, er, live);
            else
                escapeByRef(e.e1, er, live);
            er.byfunc.сунь(e.func);
        }

        override проц посети(FuncExp e)
        {
            if (e.fd.tok == ТОК2.delegate_)
                er.byfunc.сунь(e.fd);
        }

        override проц посети(TupleExp e)
        {
            assert(0); // should have been lowered by now
        }

        override проц посети(ArrayLiteralExp e)
        {
            Тип tb = e.тип.toBasetype();
            if (tb.ty == Tsarray || tb.ty == Tarray)
            {
                if (e.basis)
                    e.basis.прими(this);
                foreach (el; *e.elements)
                {
                    if (el)
                        el.прими(this);
                }
            }
        }

        override проц посети(StructLiteralExp e)
        {
            if (e.elements)
            {
                foreach (ex; *e.elements)
                {
                    if (ex)
                        ex.прими(this);
                }
            }
        }

        override проц посети(NewExp e)
        {
            Тип tb = e.newtype.toBasetype();
            if (tb.ty == Tstruct && !e.member && e.arguments)
            {
                foreach (ex; *e.arguments)
                {
                    if (ex)
                        ex.прими(this);
                }
            }
        }

        override проц посети(CastExp e)
        {
            Тип tb = e.тип.toBasetype();
            if (tb.ty == Tarray && e.e1.тип.toBasetype().ty == Tsarray)
            {
                escapeByRef(e.e1, er, live);
            }
            else
                e.e1.прими(this);
        }

        override проц посети(SliceExp e)
        {
            if (e.e1.op == ТОК2.variable)
            {
                VarDeclaration v = (cast(VarExp)e.e1).var.isVarDeclaration();
                Тип tb = e.тип.toBasetype();
                if (v)
                {
                    if (tb.ty == Tsarray)
                        return;
                    if (v.класс_хранения & STC.variadic)
                    {
                        er.byvalue.сунь(v);
                        return;
                    }
                }
            }
            Тип t1b = e.e1.тип.toBasetype();
            if (t1b.ty == Tsarray)
            {
                Тип tb = e.тип.toBasetype();
                if (tb.ty != Tsarray)
                    escapeByRef(e.e1, er, live);
            }
            else
                e.e1.прими(this);
        }

        override проц посети(IndexExp e)
        {
            if (e.e1.тип.toBasetype().ty == Tsarray ||
                live && e.тип.hasPointers())
            {
                e.e1.прими(this);
            }
        }

        override проц посети(BinExp e)
        {
            Тип tb = e.тип.toBasetype();
            if (tb.ty == Tpointer)
            {
                e.e1.прими(this);
                e.e2.прими(this);
            }
        }

        override проц посети(BinAssignExp e)
        {
            e.e1.прими(this);
        }

        override проц посети(AssignExp e)
        {
            e.e1.прими(this);
        }

        override проц посети(CommaExp e)
        {
            e.e2.прими(this);
        }

        override проц посети(CondExp e)
        {
            e.e1.прими(this);
            e.e2.прими(this);
        }

        override проц посети(CallExp e)
        {
            //printf("CallExp(): %s\n", e.вТкст0());
            /* Check each argument that is
             * passed as 'return scope'.
             */
            Тип t1 = e.e1.тип.toBasetype();
            TypeFunction tf;
            TypeDelegate dg;
            if (t1.ty == Tdelegate)
            {
                dg = cast(TypeDelegate)t1;
                tf = cast(TypeFunction)(cast(TypeDelegate)t1).следщ;
            }
            else if (t1.ty == Tfunction)
                tf = cast(TypeFunction)t1;
            else
                return;

            if (e.arguments && e.arguments.dim)
            {
                /* j=1 if _arguments[] is first argument,
                 * skip it because it is not passed by ref
                 */
                цел j = tf.isDstyleVariadic();
                for (т_мера i = j; i < e.arguments.dim; ++i)
                {
                    Выражение arg = (*e.arguments)[i];
                    т_мера nparams = tf.parameterList.length;
                    if (i - j < nparams && i >= j)
                    {
                        Параметр2 p = tf.parameterList[i - j];
                        const stc = tf.parameterStorageClass(null, p);
                        if ((stc & (STC.scope_)) && (stc & STC.return_))
                            arg.прими(this);
                        else if ((stc & (STC.ref_)) && (stc & STC.return_))
                        {
                            if (tf.isref)
                            {
                                /* Treat:
                                 *   ref P foo(return ref P p)
                                 * as:
                                 *   p;
                                 */
                                arg.прими(this);
                            }
                            else
                                escapeByRef(arg, er, live);
                        }
                    }
                }
            }
            // If 'this' is returned, check it too
            if (e.e1.op == ТОК2.dotVariable && t1.ty == Tfunction)
            {
                DotVarExp dve = cast(DotVarExp)e.e1;
                FuncDeclaration fd = dve.var.isFuncDeclaration();
                AggregateDeclaration ad;
                if (глоб2.парамы.vsafe && tf.isreturn && fd && (ad = fd.isThis()) !is null)
                {
                    if (ad.isClassDeclaration() || tf.isscope)       // this is 'return scope'
                        dve.e1.прими(this);
                    else if (ad.isStructDeclaration()) // this is 'return ref'
                    {
                        if (tf.isref)
                        {
                            /* Treat calling:
                             *   struct S { ref S foo() return; }
                             * as:
                             *   this;
                             */
                            dve.e1.прими(this);
                        }
                        else
                            escapeByRef(dve.e1, er, live);
                    }
                }
                else if (dve.var.класс_хранения & STC.return_ || tf.isreturn)
                {
                    if (dve.var.класс_хранения & STC.scope_)
                        dve.e1.прими(this);
                    else if (dve.var.класс_хранения & STC.ref_)
                        escapeByRef(dve.e1, er, live);
                }
                // If it's also a nested function that is 'return scope'
                if (fd && fd.isNested())
                {
                    if (tf.isreturn && tf.isscope)
                        er.byexp.сунь(e);
                }
            }

            /* If returning the результат of a delegate call, the .ptr
             * field of the delegate must be checked.
             */
            if (dg)
            {
                if (tf.isreturn)
                    e.e1.прими(this);
            }

            /* If it's a nested function that is 'return scope'
             */
            if (e.e1.op == ТОК2.variable)
            {
                VarExp ve = cast(VarExp)e.e1;
                FuncDeclaration fd = ve.var.isFuncDeclaration();
                if (fd && fd.isNested())
                {
                    if (tf.isreturn && tf.isscope)
                        er.byexp.сунь(e);
                }
            }
        }
    }

    scope EscapeVisitor v = new EscapeVisitor(er, live);
    e.прими(v);
}


/****************************************
 * e is an Выражение to be returned by 'ref'.
 * Walk e to determine which variables are possibly being
 * returned by ref, such as:
 *      ref цел function(цел i) { return i; }
 * If e is a form of *p, determine which variables have content
 * which is being returned as ref, such as:
 *      ref цел function(цел* p) { return *p; }
 * Multiple variables can be inserted, because of Выражения like this:
 *      ref цел function(бул b, цел i, цел* p) { return b ? i : *p; }
 *
 * No side effects.
 *
 * Параметры:
 *      e = Выражение to be returned by 'ref'
 *      er = where to place collected данные
 *      live = if @live semantics apply, i.e. Выражения `p`, `*p`, `**p`, etc., all return `p`.
 */
проц escapeByRef(Выражение e, EscapeByрезультатs* er, бул live = нет)
{
    //printf("[%s] escapeByRef, e: %s\n", e.место.вТкст0(), e.вТкст0());
     final class EscapeRefVisitor : Визитор2
    {
        alias Визитор2.посети посети;
    public:
        EscapeByрезультатs* er;
        бул live;

        this(EscapeByрезультатs* er, бул live)
        {
            this.er = er;
            this.live = live;
        }

        override проц посети(Выражение e)
        {
        }

        override проц посети(VarExp e)
        {
            auto v = e.var.isVarDeclaration();
            if (v)
            {
                if (v.класс_хранения & STC.ref_ && v.класс_хранения & (STC.foreach_ | STC.temp) && v._иниц)
                {
                    /* If compiler generated ref temporary
                     *   (ref v = ex; ex)
                     * look at the инициализатор instead
                     */
                    if (ExpInitializer ez = v._иниц.isExpInitializer())
                    {
                        assert(ez.exp && ez.exp.op == ТОК2.construct);
                        Выражение ex = (cast(ConstructExp)ez.exp).e2;
                        ex.прими(this);
                    }
                }
                else
                    er.byref.сунь(v);
            }
        }

        override проц посети(ThisExp e)
        {
            if (e.var && e.var.toParent2().isFuncDeclaration().isThis2)
                escapeByValue(e, er, live);
            else if (e.var)
                er.byref.сунь(e.var);
        }

        override проц посети(PtrExp e)
        {
            escapeByValue(e.e1, er, live);
        }

        override проц посети(IndexExp e)
        {
            Тип tb = e.e1.тип.toBasetype();
            if (e.e1.op == ТОК2.variable)
            {
                VarDeclaration v = (cast(VarExp)e.e1).var.isVarDeclaration();
                if (tb.ty == Tarray || tb.ty == Tsarray)
                {
                    if (v && v.класс_хранения & STC.variadic)
                    {
                        er.byref.сунь(v);
                        return;
                    }
                }
            }
            if (tb.ty == Tsarray)
            {
                e.e1.прими(this);
            }
            else if (tb.ty == Tarray)
            {
                escapeByValue(e.e1, er, live);
            }
        }

        override проц посети(StructLiteralExp e)
        {
            if (e.elements)
            {
                foreach (ex; *e.elements)
                {
                    if (ex)
                        ex.прими(this);
                }
            }
            er.byexp.сунь(e);
        }

        override проц посети(DotVarExp e)
        {
            Тип t1b = e.e1.тип.toBasetype();
            if (t1b.ty == Tclass)
                escapeByValue(e.e1, er, live);
            else
                e.e1.прими(this);
        }

        override проц посети(BinAssignExp e)
        {
            e.e1.прими(this);
        }

        override проц посети(AssignExp e)
        {
            e.e1.прими(this);
        }

        override проц посети(CommaExp e)
        {
            e.e2.прими(this);
        }

        override проц посети(CondExp e)
        {
            e.e1.прими(this);
            e.e2.прими(this);
        }

        override проц посети(CallExp e)
        {
            /* If the function returns by ref, check each argument that is
             * passed as 'return ref'.
             */
            Тип t1 = e.e1.тип.toBasetype();
            TypeFunction tf;
            if (t1.ty == Tdelegate)
                tf = cast(TypeFunction)(cast(TypeDelegate)t1).следщ;
            else if (t1.ty == Tfunction)
                tf = cast(TypeFunction)t1;
            else
                return;
            if (tf.isref)
            {
                if (e.arguments && e.arguments.dim)
                {
                    /* j=1 if _arguments[] is first argument,
                     * skip it because it is not passed by ref
                     */
                    цел j = tf.isDstyleVariadic();
                    for (т_мера i = j; i < e.arguments.dim; ++i)
                    {
                        Выражение arg = (*e.arguments)[i];
                        т_мера nparams = tf.parameterList.length;
                        if (i - j < nparams && i >= j)
                        {
                            Параметр2 p = tf.parameterList[i - j];
                            const stc = tf.parameterStorageClass(null, p);
                            if ((stc & (STC.out_ | STC.ref_)) && (stc & STC.return_))
                                arg.прими(this);
                            else if ((stc & STC.scope_) && (stc & STC.return_))
                            {
                                if (arg.op == ТОК2.delegate_)
                                {
                                    DelegateExp de = cast(DelegateExp)arg;
                                    if (de.func.isNested())
                                        er.byexp.сунь(de);
                                }
                                else
                                    escapeByValue(arg, er, live);
                            }
                        }
                    }
                }
                // If 'this' is returned by ref, check it too
                if (e.e1.op == ТОК2.dotVariable && t1.ty == Tfunction)
                {
                    DotVarExp dve = cast(DotVarExp)e.e1;

                    // https://issues.dlang.org/show_bug.cgi?ид=20149#c10
                    if (dve.var.isCtorDeclaration())
                    {
                        er.byexp.сунь(e);
                        return;
                    }

                    if (dve.var.класс_хранения & STC.return_ || tf.isreturn)
                    {
                        if (dve.var.класс_хранения & STC.scope_ || tf.isscope)
                            escapeByValue(dve.e1, er, live);
                        else if (dve.var.класс_хранения & STC.ref_ || tf.isref)
                            dve.e1.прими(this);
                    }
                    // If it's also a nested function that is 'return ref'
                    FuncDeclaration fd = dve.var.isFuncDeclaration();
                    if (fd && fd.isNested())
                    {
                        if (tf.isreturn)
                            er.byexp.сунь(e);
                    }
                }
                // If it's a delegate, check it too
                if (e.e1.op == ТОК2.variable && t1.ty == Tdelegate)
                {
                    escapeByValue(e.e1, er, live);
                }

                /* If it's a nested function that is 'return ref'
                 */
                if (e.e1.op == ТОК2.variable)
                {
                    VarExp ve = cast(VarExp)e.e1;
                    FuncDeclaration fd = ve.var.isFuncDeclaration();
                    if (fd && fd.isNested())
                    {
                        if (tf.isreturn)
                            er.byexp.сунь(e);
                    }
                }
            }
            else
                er.byexp.сунь(e);
        }
    }

    scope EscapeRefVisitor v = new EscapeRefVisitor(er, live);
    e.прими(v);
}


/************************************
 * Aggregate the данные collected by the escapeBy??() functions.
 */
struct EscapeByрезультатs
{
    VarDeclarations byref;      // массив into which variables being returned by ref are inserted
    VarDeclarations byvalue;    // массив into which variables with values containing pointers are inserted
    FuncDeclarations byfunc;    // nested functions that are turned into delegates
    Выражения byexp;          // массив into which temporaries being returned by ref are inserted

    /** Reset arrays so the storage can be используется again
     */
    проц сбрось()
    {
        byref.устДим(0);
        byvalue.устДим(0);
        byfunc.устДим(0);
        byexp.устДим(0);
    }
}

/*************************
 * Find all variables accessed by this delegate that are
 * in functions enclosing it.
 * Параметры:
 *      fd = function
 *      vars = массив to приставь found variables to
 */
public проц findAllOuterAccessedVariables(FuncDeclaration fd, VarDeclarations* vars)
{
    //printf("findAllOuterAccessedVariables(fd: %s)\n", fd.вТкст0());
    for (auto p = fd.родитель; p; p = p.родитель)
    {
        auto fdp = p.isFuncDeclaration();
        if (fdp)
        {
            foreach (v; fdp.closureVars)
            {
                foreach ( fdv; v.nestedrefs)
                {
                    if (fdv == fd)
                    {
                        //printf("accessed: %s, тип %s\n", v.вТкст0(), v.тип.вТкст0());
                        vars.сунь(v);
                    }
                }
            }
        }
    }
}

/***********************************
 * Turn off `STC.maybescope` for variable `v`.
 *
 * This exists in order to найди where `STC.maybescope` is getting turned off.
 * Параметры:
 *      v = variable
 */
version (none)
{
    public проц notMaybeScope(ткст файл = __FILE__, цел line = __LINE__)(VarDeclaration v)
    {
        printf("%.*s(%d): notMaybeScope('%s')\n", cast(цел)файл.length, файл.ptr, line, v.вТкст0());
        v.класс_хранения &= ~STC.maybescope;
    }
}
else
{
    public проц notMaybeScope(VarDeclaration v)
    {
        v.класс_хранения &= ~STC.maybescope;
    }
}


/**********************************************
 * Have some variables that are maybescopes that were
 * assigned values from other maybescope variables.
 * Now that semantic analysis of the function is
 * complete, we can finalize this by turning off
 * maybescope for массив elements that cannot be scope.
 *
 * $(TABLE2 Scope Table,
 * $(THEAD `va`, `v`,    =>,  `va` ,  `v`  )
 * $(TROW maybe, maybe,  =>,  scope,  scope)
 * $(TROW scope, scope,  =>,  scope,  scope)
 * $(TROW scope, maybe,  =>,  scope,  scope)
 * $(TROW maybe, scope,  =>,  scope,  scope)
 * $(TROW -    , -    ,  =>,  -    ,  -    )
 * $(TROW -    , maybe,  =>,  -    ,  -    )
 * $(TROW -    , scope,  =>,  error,  error)
 * $(TROW maybe, -    ,  =>,  scope,  -    )
 * $(TROW scope, -    ,  =>,  scope,  -    )
 * )
 * Параметры:
 *      массив = массив of variables that were assigned to from maybescope variables
 */
public проц eliminateMaybeScopes(VarDeclaration[] массив)
{
    const log = нет;
    if (log) printf("eliminateMaybeScopes()\n");
    бул changes;
    do
    {
        changes = нет;
        foreach (va; массив)
        {
            if (log) printf("  va = %s\n", va.вТкст0());
            if (!(va.класс_хранения & (STC.maybescope | STC.scope_)))
            {
                if (va.maybes)
                {
                    foreach (v; *va.maybes)
                    {
                        if (log) printf("    v = %s\n", v.вТкст0());
                        if (v.класс_хранения & STC.maybescope)
                        {
                            // v cannot be scope since it is assigned to a non-scope va
                            notMaybeScope(v);
                            if (!(v.класс_хранения & (STC.ref_ | STC.out_)))
                                v.класс_хранения &= ~(STC.return_ | STC.returninferred);
                            changes = да;
                        }
                    }
                }
            }
        }
    } while (changes);
}

/************************************************
 * Is тип a reference to a mutable значение?
 *
 * This is используется to determine if an argument that does not have a corresponding
 * Параметр2, i.e. a variadic argument, is a pointer to mutable данные.
 * Параметры:
 *      t = тип of the argument
 * Возвращает:
 *      да if it's a pointer (or reference) to mutable данные
 */
бул isReferenceToMutable(Тип t)
{
    t = t.baseElemOf();

    if (!t.isMutable() ||
        !t.hasPointers())
        return нет;

    switch (t.ty)
    {
        case Tpointer:
            if (t.nextOf().isTypeFunction())
                break;
            goto case;

        case Tarray:
        case Taarray:
        case Tdelegate:
            if (t.nextOf().isMutable())
                return да;
            break;

        case Tclass:
            return да;        // even if the class fields are not mutable

        case Tstruct:
            // Have to look at each field
            foreach (VarDeclaration v; t.isTypeStruct().sym.fields)
            {
                if (v.класс_хранения & STC.ref_)
                {
                    if (v.тип.isMutable())
                        return да;
                }
                else if (v.тип.isReferenceToMutable())
                    return да;
            }
            break;

        default:
            assert(0);
    }
    return нет;
}

/****************************************
 * Is параметр a reference to a mutable значение?
 *
 * This is используется if an argument has a corresponding Параметр2.
 * The argument тип is necessary if the Параметр2 is inout.
 * Параметры:
 *      p = Параметр2 to check
 *      t = тип of corresponding argument
 * Возвращает:
 *      да if it's a pointer (or reference) to mutable данные
 */
бул isReferenceToMutable(Параметр2 p, Тип t)
{
    if (p.классХранения & (STC.ref_ | STC.out_))
    {
        if (p.тип.isConst() || p.тип.isImmutable())
            return нет;
        if (p.тип.isWild())
        {
            return t.isMutable();
        }
        return p.тип.isMutable();
    }
    return isReferenceToMutable(p.тип);
}
