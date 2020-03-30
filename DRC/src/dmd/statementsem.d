/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/statementsem.d, _statementsem.d)
 * Documentation:  https://dlang.org/phobos/dmd_statementsem.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/statementsem.d
 */

module dmd.statementsem;

import cidrus;

import dmd.aggregate;
import dmd.aliasthis;
import dmd.arrayop;
import dmd.arraytypes;
import dmd.blockexit;
import dmd.clone;
import dmd.cond;
import dmd.ctorflow;
import dmd.dcast;
import dmd.dclass;
import dmd.declaration;
import dmd.denum;
import dmd.dimport;
import dmd.dinterpret;
import dmd.dmodule;
import dmd.dscope;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.dtemplate;
import dmd.errors;
import dmd.escape;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.func;
import dmd.globals;
import dmd.gluelayer;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.init;
import dmd.intrange;
import dmd.mtype;
import dmd.nogc;
import dmd.opover;
import util.outbuffer;
import util.string;
import dmd.semantic2;
import dmd.sideeffect;
import dmd.инструкция;
import dmd.target;
import drc.lexer.Tokens;
import dmd.typesem;
import drc.ast.Visitor;
import dmd.cond: StaticForeach;
import dmd.attrib: ForwardingAttribDeclaration;
import cidrus : qsort, _compare_fp_t;
/*****************************************
 * CTFE requires FuncDeclaration::labtab for the interpretation.
 * So fixing the label имя inside in/out contracts is necessary
 * for the uniqueness in labtab.
 * Параметры:
 *      sc = context
 *      идент = инструкция label имя to be adjusted
 * Возвращает:
 *      adjusted label имя
 */
private Идентификатор2 fixupLabelName(Scope* sc, Идентификатор2 идент)
{
    бцел flags = (sc.flags & SCOPE.contract);
    const ид = идент.вТкст();
    if (flags && flags != SCOPE.invariant_ &&
        !(ид.length >= 2 && ид[0] == '_' && ид[1] == '_'))  // does not start with "__"
    {
        БуфВыв буф;
        буф.пишиСтр(flags == SCOPE.require ? "__in_" : "__out_");
        буф.пишиСтр(идент.вТкст());

        идент = Идентификатор2.idPool(буф[]);
    }
    return идент;
}

/*******************************************
 * Check to see if инструкция is the innermost labeled инструкция.
 * Параметры:
 *      sc = context
 *      инструкция = Инструкция2 to check
 * Возвращает:
 *      if `да`, then the `LabelStatement`, otherwise `null`
 */
private LabelStatement checkLabeledLoop(Scope* sc, Инструкция2 инструкция)
{
    if (sc.slabel && sc.slabel.инструкция == инструкция)
    {
        return sc.slabel;
    }
    return null;
}

/***********************************************************
 * Check an assignment is используется as a условие.
 * Intended to be use before the `semantic` call on `e`.
 * Параметры:
 *  e = условие Выражение which is not yet run semantic analysis.
 * Возвращает:
 *  `e` or ErrorExp.
 */
private Выражение checkAssignmentAsCondition(Выражение e)
{
    auto ec = lastComma(e);
    if (ec.op == ТОК2.assign)
    {
        ec.выведиОшибку("assignment cannot be используется as a условие, perhaps `==` was meant?");
        return new ErrorExp();
    }
    return e;
}

// Performs semantic analysis in Инструкция2 AST nodes
/*extern(C++)*/ Инструкция2 statementSemantic(Инструкция2 s, Scope* sc)
{
    scope v = new StatementSemanticVisitor(sc);
    s.прими(v);
    return v.результат;
}

private  final class StatementSemanticVisitor : Визитор2
{
    alias Визитор2.посети посети;

    Инструкция2 результат;
    Scope* sc;

    this(Scope* sc)
    {
        this.sc = sc;
    }

    private проц setError()
    {
        результат = new ErrorStatement();
    }

    override проц посети(Инструкция2 s)
    {
        результат = s;
    }

    override проц посети(ErrorStatement s)
    {
        результат = s;
    }

    override проц посети(PeelStatement s)
    {
        /* "peel" off this wrapper, and don't run semantic()
         * on the результат.
         */
        результат = s.s;
    }

    override проц посети(ExpStatement s)
    {
        /* https://dlang.org/spec/инструкция.html#Выражение-инструкция
         */

        if (s.exp)
        {
            //printf("ExpStatement::semantic() %s\n", exp.вТкст0());

            // Allow CommaExp in ExpStatement because return isn't используется
            CommaExp.allow(s.exp);

            s.exp = s.exp.ВыражениеSemantic(sc);
            s.exp = resolveProperties(sc, s.exp);
            s.exp = s.exp.addDtorHook(sc);
            if (checkNonAssignmentArrayOp(s.exp))
                s.exp = new ErrorExp();
            if (auto f = isFuncAddress(s.exp))
            {
                if (f.checkForwardRef(s.exp.место))
                    s.exp = new ErrorExp();
            }
            if (discardValue(s.exp))
                s.exp = new ErrorExp();

            s.exp = s.exp.optimize(WANTvalue);
            s.exp = checkGC(sc, s.exp);
            if (s.exp.op == ТОК2.error)
                return setError();
        }
        результат = s;
    }

    override проц посети(CompileStatement cs)
    {
        /* https://dlang.org/spec/инструкция.html#mixin-инструкция
         */

        //printf("CompileStatement::semantic() %s\n", exp.вТкст0());
        Инструкции* a = cs.flatten(sc);
        if (!a)
            return;
        Инструкция2 s = new CompoundStatement(cs.место, a);
        результат = s.statementSemantic(sc);
    }

    override проц посети(CompoundStatement cs)
    {
        //printf("CompoundStatement::semantic(this = %p, sc = %p)\n", cs, sc);
        version (none)
        {
            foreach (i, s; cs.statements)
            {
                if (s)
                    printf("[%d]: %s", i, s.вТкст0());
            }
        }

        for (т_мера i = 0; i < cs.statements.dim;)
        {
            Инструкция2 s = (*cs.statements)[i];
            if (s)
            {
                Инструкции* flt = s.flatten(sc);
                if (flt)
                {
                    cs.statements.удали(i);
                    cs.statements.вставь(i, flt);
                    continue;
                }
                s = s.statementSemantic(sc);
                (*cs.statements)[i] = s;
                if (s)
                {
                    Инструкция2 sentry;
                    Инструкция2 sexception;
                    Инструкция2 sfinally;

                    (*cs.statements)[i] = s.scopeCode(sc, &sentry, &sexception, &sfinally);
                    if (sentry)
                    {
                        sentry = sentry.statementSemantic(sc);
                        cs.statements.вставь(i, sentry);
                        i++;
                    }
                    if (sexception)
                        sexception = sexception.statementSemantic(sc);
                    if (sexception)
                    {
                        /* Возвращает: да if statements[] are empty statements
                         */
                        static бул isEmpty( Инструкция2[] statements)
                        {
                            foreach (s; statements)
                            {
                                if(auto cs = s.isCompoundStatement())
                                {
                                    if (!isEmpty((*cs.statements)[]))
                                        return нет;
                                }
                                else
                                    return нет;
                            }
                            return да;
                        }

                        if (!sfinally && isEmpty((*cs.statements)[i + 1 .. cs.statements.dim]))
                        {
                        }
                        else
                        {
                            /* Rewrite:
                             *      s; s1; s2;
                             * As:
                             *      s;
                             *      try { s1; s2; }
                             *      catch (Throwable __o)
                             *      { sexception; throw __o; }
                             */
                            auto a = new Инструкции();
                            a.суньСрез((*cs.statements)[i + 1 .. cs.statements.length]);
                            cs.statements.устДим(i + 1);

                            Инструкция2 _body = new CompoundStatement(Место.initial, a);
                            _body = new ScopeStatement(Место.initial, _body, Место.initial);

                            Идентификатор2 ид = Идентификатор2.генерируйИд("__o");

                            Инструкция2 handler = new PeelStatement(sexception);
                            if (sexception.blockExit(sc.func, нет) & BE.fallthru)
                            {
                                auto ts = new ThrowStatement(Место.initial, new IdentifierExp(Место.initial, ид));
                                ts.internalThrow = да;
                                handler = new CompoundStatement(Место.initial, handler, ts);
                            }

                            auto catches = new Уловители();
                            auto ctch = new Уловитель(Место.initial, getThrowable(), ид, handler);
                            ctch.internalCatch = да;
                            catches.сунь(ctch);

                            Инструкция2 st = new TryCatchStatement(Место.initial, _body, catches);
                            if (sfinally)
                                st = new TryFinallyStatement(Место.initial, st, sfinally);
                            st = st.statementSemantic(sc);

                            cs.statements.сунь(st);
                            break;
                        }
                    }
                    else if (sfinally)
                    {
                        if (0 && i + 1 == cs.statements.dim)
                        {
                            cs.statements.сунь(sfinally);
                        }
                        else
                        {
                            /* Rewrite:
                             *      s; s1; s2;
                             * As:
                             *      s; try { s1; s2; } finally { sfinally; }
                             */
                            auto a = new Инструкции();
                            a.суньСрез((*cs.statements)[i + 1 .. cs.statements.length]);
                            cs.statements.устДим(i + 1);

                            auto _body = new CompoundStatement(Место.initial, a);
                            Инструкция2 stf = new TryFinallyStatement(Место.initial, _body, sfinally);
                            stf = stf.statementSemantic(sc);
                            cs.statements.сунь(stf);
                            break;
                        }
                    }
                }
                else
                {
                    /* Remove NULL statements from the list.
                     */
                    cs.statements.удали(i);
                    continue;
                }
            }
            i++;
        }

        /* Flatten them in place
         */
        проц flatten(Инструкции* statements)
        {
            for (т_мера i = 0; i < statements.length;)
            {
                Инструкция2 s = (*statements)[i];
                if (s)
                {
                    if (auto flt = s.flatten(sc))
                    {
                        statements.удали(i);
                        statements.вставь(i, flt);
                        continue;
                    }
                }
                ++i;
            }
        }

        /* https://issues.dlang.org/show_bug.cgi?ид=11653
         * 'semantic' may return another CompoundStatement
         * (eg. CaseRangeStatement), so flatten it here.
         */
        flatten(cs.statements);

        foreach (s; *cs.statements)
        {
            if (!s)
                continue;

            if (auto se = s.isErrorStatement())
            {
                результат = se;
                return;
            }
        }

        if (cs.statements.length == 1)
        {
            результат = (*cs.statements)[0];
            return;
        }
        результат = cs;
    }

    override проц посети(UnrolledLoopStatement uls)
    {
        //printf("UnrolledLoopStatement::semantic(this = %p, sc = %p)\n", uls, sc);
        Scope* scd = sc.сунь();
        scd.sbreak = uls;
        scd.scontinue = uls;

        Инструкция2 serror = null;
        foreach (i, ref s; *uls.statements)
        {
            if (s)
            {
                //printf("[%d]: %s\n", i, s.вТкст0());
                s = s.statementSemantic(scd);
                if (s && !serror)
                    serror = s.isErrorStatement();
            }
        }

        scd.вынь();
        результат = serror ? serror : uls;
    }

    override проц посети(ScopeStatement ss)
    {
        //printf("ScopeStatement::semantic(sc = %p)\n", sc);
        if (ss.инструкция)
        {
            ScopeDsymbol sym = new ScopeDsymbol();
            sym.родитель = sc.scopesym;
            sym.endlinnum = ss.endloc.номстр;
            sc = sc.сунь(sym);

            Инструкции* a = ss.инструкция.flatten(sc);
            if (a)
            {
                ss.инструкция = new CompoundStatement(ss.место, a);
            }

            ss.инструкция = ss.инструкция.statementSemantic(sc);
            if (ss.инструкция)
            {
                if (ss.инструкция.isErrorStatement())
                {
                    sc.вынь();
                    результат = ss.инструкция;
                    return;
                }

                Инструкция2 sentry;
                Инструкция2 sexception;
                Инструкция2 sfinally;
                ss.инструкция = ss.инструкция.scopeCode(sc, &sentry, &sexception, &sfinally);
                assert(!sentry);
                assert(!sexception);
                if (sfinally)
                {
                    //printf("adding sfinally\n");
                    sfinally = sfinally.statementSemantic(sc);
                    ss.инструкция = new CompoundStatement(ss.место, ss.инструкция, sfinally);
                }
            }

            sc.вынь();
        }
        результат = ss;
    }

    override проц посети(ForwardingStatement ss)
    {
        assert(ss.sym);
        for (Scope* csc = sc; !ss.sym.forward; csc = csc.enclosing)
        {
            assert(csc);
            ss.sym.forward = csc.scopesym;
        }
        sc = sc.сунь(ss.sym);
        sc.sbreak = ss;
        sc.scontinue = ss;
        ss.инструкция = ss.инструкция.statementSemantic(sc);
        sc = sc.вынь();
        результат = ss.инструкция;
    }

    override проц посети(WhileStatement ws)
    {
        /* Rewrite as a for(;условие;) loop
         * https://dlang.org/spec/инструкция.html#while-инструкция
         */
        Инструкция2 s = new ForStatement(ws.место, null, ws.условие, null, ws._body, ws.endloc);
        s = s.statementSemantic(sc);
        результат = s;
    }

    override проц посети(DoStatement ds)
    {
        /* https://dlang.org/spec/инструкция.html#do-инструкция
         */
        const inLoopSave = sc.inLoop;
        sc.inLoop = да;
        if (ds._body)
            ds._body = ds._body.semanticScope(sc, ds, ds);
        sc.inLoop = inLoopSave;

        if (ds.условие.op == ТОК2.dotIdentifier)
            (cast(DotIdExp)ds.условие).noderef = да;

        // check in syntax уровень
        ds.условие = checkAssignmentAsCondition(ds.условие);

        ds.условие = ds.условие.ВыражениеSemantic(sc);
        ds.условие = resolveProperties(sc, ds.условие);
        if (checkNonAssignmentArrayOp(ds.условие))
            ds.условие = new ErrorExp();
        ds.условие = ds.условие.optimize(WANTvalue);
        ds.условие = checkGC(sc, ds.условие);

        ds.условие = ds.условие.toBoolean(sc);

        if (ds.условие.op == ТОК2.error)
            return setError();
        if (ds._body && ds._body.isErrorStatement())
        {
            результат = ds._body;
            return;
        }

        результат = ds;
    }

    override проц посети(ForStatement fs)
    {
        /* https://dlang.org/spec/инструкция.html#for-инструкция
         */
        //printf("ForStatement::semantic %s\n", fs.вТкст0());

        if (fs._иниц)
        {
            /* Rewrite:
             *  for (auto v1 = i1, v2 = i2; условие; increment) { ... }
             * to:
             *  { auto v1 = i1, v2 = i2; for (; условие; increment) { ... } }
             * then lowered to:
             *  auto v1 = i1;
             *  try {
             *    auto v2 = i2;
             *    try {
             *      for (; условие; increment) { ... }
             *    } finally { v2.~this(); }
             *  } finally { v1.~this(); }
             */
            auto ainit = new Инструкции();
            ainit.сунь(fs._иниц);
            fs._иниц = null;
            ainit.сунь(fs);
            Инструкция2 s = new CompoundStatement(fs.место, ainit);
            s = new ScopeStatement(fs.место, s, fs.endloc);
            s = s.statementSemantic(sc);
            if (!s.isErrorStatement())
            {
                if (LabelStatement ls = checkLabeledLoop(sc, fs))
                    ls.gotoTarget = fs;
                fs.relatedLabeled = s;
            }
            результат = s;
            return;
        }
        assert(fs._иниц is null);

        auto sym = new ScopeDsymbol();
        sym.родитель = sc.scopesym;
        sym.endlinnum = fs.endloc.номстр;
        sc = sc.сунь(sym);
        sc.inLoop = да;

        if (fs.условие)
        {
            if (fs.условие.op == ТОК2.dotIdentifier)
                (cast(DotIdExp)fs.условие).noderef = да;

            // check in syntax уровень
            fs.условие = checkAssignmentAsCondition(fs.условие);

            fs.условие = fs.условие.ВыражениеSemantic(sc);
            fs.условие = resolveProperties(sc, fs.условие);
            if (checkNonAssignmentArrayOp(fs.условие))
                fs.условие = new ErrorExp();
            fs.условие = fs.условие.optimize(WANTvalue);
            fs.условие = checkGC(sc, fs.условие);

            fs.условие = fs.условие.toBoolean(sc);
        }
        if (fs.increment)
        {
            CommaExp.allow(fs.increment);
            fs.increment = fs.increment.ВыражениеSemantic(sc);
            fs.increment = resolveProperties(sc, fs.increment);
            if (checkNonAssignmentArrayOp(fs.increment))
                fs.increment = new ErrorExp();
            fs.increment = fs.increment.optimize(WANTvalue);
            fs.increment = checkGC(sc, fs.increment);
        }

        sc.sbreak = fs;
        sc.scontinue = fs;
        if (fs._body)
            fs._body = fs._body.semanticNoScope(sc);

        sc.вынь();

        if (fs.условие && fs.условие.op == ТОК2.error ||
            fs.increment && fs.increment.op == ТОК2.error ||
            fs._body && fs._body.isErrorStatement())
            return setError();
        результат = fs;
    }

    /*******************
     * Determines the return тип of makeTupleForeach.
     */
    private static template MakeTupleForeachRet(бул isDecl)
    {
        static if(isDecl)
        {
            alias   Дсимволы* MakeTupleForeachRet;
        }
        else
        {
            alias  проц MakeTupleForeachRet;
        }
    }

    /*******************
     * Тип check and unroll `foreach` over an Выражение кортеж as well
     * as `static foreach` statements and `static foreach`
     * declarations. For `static foreach` statements and `static
     * foreach` declarations, the visitor interface is используется (and the
     * результат is written into the `результат` field.) For `static
     * foreach` declarations, the результатing Дсимволы* are returned
     * directly.
     *
     * The unrolled body is wrapped into a
     *  - UnrolledLoopStatement, for `foreach` over an Выражение кортеж.
     *  - ForwardingStatement, for `static foreach` statements.
     *  - ForwardingAttribDeclaration, for `static foreach` declarations.
     *
     * `static foreach` variables are declared as `STC.local`, such
     * that they are inserted into the local symbol tables of the
     * forwarding constructs instead of forwarded. For `static
     * foreach` with multiple foreach loop variables whose aggregate
     * has been lowered into a sequence of tuples, this function
     * expands the tuples into multiple `STC.local` `static foreach`
     * variables.
     */
    MakeTupleForeachRet!(isDecl) makeTupleForeach(бул isStatic, бул isDecl)(ForeachStatement fs, TupleForeachArgs!(isStatic, isDecl) args)
    {
        X returnEarly()
        {
            static if (isDecl)
            {
                return null;
            }
            else
            {
                результат = new ErrorStatement();
                return;
            }
        }
        static if(isDecl)
        {
            static assert(isStatic);
            auto dbody = args[0];
        }
        static if(isStatic)
        {
            auto needExpansion = args[$-1];
            assert(sc);
        }

        auto место = fs.место;
        т_мера dim = fs.parameters.dim;
        static if(isStatic) бул skipCheck = needExpansion;
        else const skipCheck = нет;
        if (!skipCheck && (dim < 1 || dim > 2))
        {
            fs.выведиОшибку("only one (значение) or two (ключ,значение) arguments for кортеж `foreach`");
            setError();
            return returnEarly();
        }

        Тип paramtype = (*fs.parameters)[dim - 1].тип;
        if (paramtype)
        {
            paramtype = paramtype.typeSemantic(место, sc);
            if (paramtype.ty == Terror)
            {
                setError();
                return returnEarly();
            }
        }

        Тип tab = fs.aggr.тип.toBasetype();
        КортежТипов кортеж = cast(КортежТипов)tab;
        static if(!isDecl)
        {
            auto statements = new Инструкции();
        }
        else
        {
            auto declarations = new Дсимволы();
        }
        //printf("aggr: op = %d, %s\n", fs.aggr.op, fs.aggr.вТкст0());
        т_мера n;
        TupleExp te = null;
        if (fs.aggr.op == ТОК2.кортеж) // Выражение кортеж
        {
            te = cast(TupleExp)fs.aggr;
            n = te.exps.dim;
        }
        else if (fs.aggr.op == ТОК2.тип) // тип кортеж
        {
            n = Параметр2.dim(кортеж.arguments);
        }
        else
            assert(0);
        foreach (j; new бцел[0 .. n])
        {
            т_мера k = (fs.op == ТОК2.foreach_) ? j : n - 1 - j;
            Выражение e = null;
            Тип t = null;
            if (te)
                e = (*te.exps)[k];
            else
                t = Параметр2.getNth(кортеж.arguments, k).тип;
            Параметр2 p = (*fs.parameters)[0];
            static if(!isDecl)
            {
                auto st = new Инструкции();
            }
            else
            {
                auto st = new Дсимволы();
            }

            static if(isStatic) бул skip = needExpansion;
            else const skip = нет;
            if (!skip && dim == 2)
            {
                // Declare ключ
                if (p.классХранения & (STC.out_ | STC.ref_ | STC.lazy_))
                {
                    fs.выведиОшибку("no storage class for ключ `%s`", p.идент.вТкст0());
                    setError();
                    return returnEarly();
                }
                static if(isStatic)
                {
                    if(!p.тип)
                    {
                        p.тип = Тип.tт_мера;
                    }
                }
                p.тип = p.тип.typeSemantic(место, sc);
                TY keyty = p.тип.ty;
                if (keyty != Tint32 && keyty != Tuns32)
                {
                    if (глоб2.парамы.isLP64)
                    {
                        if (keyty != Tint64 && keyty != Tuns64)
                        {
                            fs.выведиОшибку("`foreach`: ключ тип must be `цел` or `бцел`, `long` or `бдол`, not `%s`", p.тип.вТкст0());
                            setError();
                            return returnEarly();
                        }
                    }
                    else
                    {
                        fs.выведиОшибку("`foreach`: ключ тип must be `цел` or `бцел`, not `%s`", p.тип.вТкст0());
                        setError();
                        return returnEarly();
                    }
                }
                Инициализатор ie = new ExpInitializer(Место.initial, new IntegerExp(k));
                auto var = new VarDeclaration(место, p.тип, p.идент, ie);
                var.класс_хранения |= STC.manifest;
                static if(isStatic) var.класс_хранения |= STC.local;
                static if(!isDecl)
                {
                    st.сунь(new ExpStatement(место, var));
                }
                else
                {
                    st.сунь(var);
                }
                p = (*fs.parameters)[1]; // значение
            }
            /***********************
             * Declares a unrolled `foreach` loop variable or a `static foreach` variable.
             *
             * Параметры:
             *     классХранения = The storage class of the variable.
             *     тип = The declared тип of the variable.
             *     идент = The имя of the variable.
             *     e = The инициализатор of the variable (i.e. the current element of the looped over aggregate).
             *     t = The тип of the инициализатор.
             * Возвращает:
             *     `да` iff the declaration was successful.
             */
            бул declareVariable(КлассХранения классХранения, Тип тип, Идентификатор2 идент, Выражение e, Тип t)
            {
                if (классХранения & (STC.out_ | STC.lazy_) ||
                    классХранения & STC.ref_ && !te)
                {
                    fs.выведиОшибку("no storage class for значение `%s`", идент.вТкст0());
                    setError();
                    return нет;
                }
                Declaration var;
                if (e)
                {
                    Тип tb = e.тип.toBasetype();
                    ДСимвол ds = null;
                    if (!(классХранения & STC.manifest))
                    {
                        if ((isStatic || tb.ty == Tfunction || tb.ty == Tsarray || классХранения&STC.alias_) && e.op == ТОК2.variable)
                            ds = (cast(VarExp)e).var;
                        else if (e.op == ТОК2.template_)
                            ds = (cast(TemplateExp)e).td;
                        else if (e.op == ТОК2.scope_)
                            ds = (cast(ScopeExp)e).sds;
                        else if (e.op == ТОК2.function_)
                        {
                            auto fe = cast(FuncExp)e;
                            ds = fe.td ? cast(ДСимвол)fe.td : fe.fd;
                        }
                        else if (e.op == ТОК2.overloadSet)
                            ds = (cast(OverExp)e).vars;
                    }
                    else if (классХранения & STC.alias_)
                    {
                        fs.выведиОшибку("`foreach` loop variable cannot be both `enum` and `alias`");
                        setError();
                        return нет;
                    }

                    if (ds)
                    {
                        var = new AliasDeclaration(место, идент, ds);
                        if (классХранения & STC.ref_)
                        {
                            fs.выведиОшибку("symbol `%s` cannot be `ref`", ds.вТкст0());
                            setError();
                            return нет;
                        }
                        if (paramtype)
                        {
                            fs.выведиОшибку("cannot specify element тип for symbol `%s`", ds.вТкст0());
                            setError();
                            return нет;
                        }
                    }
                    else if (e.op == ТОК2.тип)
                    {
                        var = new AliasDeclaration(место, идент, e.тип);
                        if (paramtype)
                        {
                            fs.выведиОшибку("cannot specify element тип for тип `%s`", e.тип.вТкст0());
                            setError();
                            return нет;
                        }
                    }
                    else
                    {
                        e = resolveProperties(sc, e);
                        тип = e.тип;
                        if (paramtype)
                            тип = paramtype;
                        Инициализатор ie = new ExpInitializer(Место.initial, e);
                        auto v = new VarDeclaration(место, тип, идент, ie);
                        if (классХранения & STC.ref_)
                            v.класс_хранения |= STC.ref_ | STC.foreach_;
                        if (isStatic || классХранения&STC.manifest || e.isConst() ||
                            e.op == ТОК2.string_ ||
                            e.op == ТОК2.structLiteral ||
                            e.op == ТОК2.arrayLiteral)
                        {
                            if (v.класс_хранения & STC.ref_)
                            {
                                static if (!isStatic)
                                {
                                    fs.выведиОшибку("constant значение `%s` cannot be `ref`", ie.вТкст0());
                                }
                                else
                                {
                                    if (!needExpansion)
                                    {
                                        fs.выведиОшибку("constant значение `%s` cannot be `ref`", ie.вТкст0());
                                    }
                                    else
                                    {
                                        fs.выведиОшибку("constant значение `%s` cannot be `ref`", идент.вТкст0());
                                    }
                                }
                                setError();
                                return нет;
                            }
                            else
                                v.класс_хранения |= STC.manifest;
                        }
                        var = v;
                    }
                }
                else
                {
                    var = new AliasDeclaration(место, идент, t);
                    if (paramtype)
                    {
                        fs.выведиОшибку("cannot specify element тип for symbol `%s`", fs.вТкст0());
                        setError();
                        return нет;
                    }
                }
                static if (isStatic)
                {
                    var.класс_хранения |= STC.local;
                }
                static if (!isDecl)
                {
                    st.сунь(new ExpStatement(место, var));
                }
                else
                {
                    st.сунь(var);
                }
                return да;
            }
            static if (!isStatic)
            {
                // Declare значение
                if (!declareVariable(p.классХранения, p.тип, p.идент, e, t))
                {
                    return returnEarly();
                }
            }
            else
            {
                if (!needExpansion)
                {
                    // Declare значение
                    if (!declareVariable(p.классХранения, p.тип, p.идент, e, t))
                    {
                        return returnEarly();
                    }
                }
                else
                { // expand tuples into multiple `static foreach` variables.
                    assert(e && !t);
                    auto идент = Идентификатор2.генерируйИд("__value");
                    declareVariable(0, e.тип, идент, e, null);
                    
                    auto field = Идентификатор2.idPool(StaticForeach.tupleFieldName.ptr,StaticForeach.tupleFieldName.length);
                    Выражение access = new DotIdExp(место, e, field);
                    access = ВыражениеSemantic(access, sc);
                    if (!кортеж) return returnEarly();
                    //printf("%s\n",кортеж.вТкст0());
                    foreach (l; new бцел[0 .. dim])
                    {
                        auto cp = (*fs.parameters)[l];
                        Выражение init_ = new IndexExp(место, access, new IntegerExp(место, l, Тип.tт_мера));
                        init_ = init_.ВыражениеSemantic(sc);
                        assert(init_.тип);
                        declareVariable(p.классХранения, init_.тип, cp.идент, init_, null);
                    }
                }
            }

            static if (!isDecl)
            {
                if (fs._body) // https://issues.dlang.org/show_bug.cgi?ид=17646
                    st.сунь(fs._body.syntaxCopy());
                Инструкция2 res = new CompoundStatement(место, st);
            }
            else
            {
                st.приставь(ДСимвол.arraySyntaxCopy(dbody));
            }
            static if (!isStatic)
            {
                res = new ScopeStatement(место, res, fs.endloc);
            }
            else static if (!isDecl)
            {
                auto fwd = new ForwardingStatement(место, res);
                res = fwd;
            }
            else
            {
               
                auto res = new ForwardingAttribDeclaration(st);
            }
            static if (!isDecl)
            {
                statements.сунь(res);
            }
            else
            {
                declarations.сунь(res);
            }
        }

        static if (!isStatic)
        {
            Инструкция2 res = new UnrolledLoopStatement(место, statements);
            if (LabelStatement ls = checkLabeledLoop(sc, fs))
                ls.gotoTarget = res;
            if (te && te.e0)
                res = new CompoundStatement(место, new ExpStatement(te.e0.место, te.e0), res);
        }
        else static if (!isDecl)
        {
            Инструкция2 res = new CompoundStatement(место, statements);
        }
        else
        {
            auto res = declarations;
        }
        static if (!isDecl)
        {
            результат = res;
        }
        else
        {
            return res;
        }
    }

    override проц посети(ForeachStatement fs)
    {
        /* https://dlang.org/spec/инструкция.html#foreach-инструкция
         */

        //printf("ForeachStatement::semantic() %p\n", fs);

        /******
         * Issue error if any of the ForeachTypes were not supplied and could not be inferred.
         * Возвращает:
         *      да if error issued
         */
        static бул checkForArgTypes(ForeachStatement fs)
        {
            бул результат = нет;
            foreach (p; *fs.parameters)
            {
                if (!p.тип)
                {
                    fs.выведиОшибку("cannot infer тип for `foreach` variable `%s`, perhaps set it explicitly", p.идент.вТкст0());
                    p.тип = Тип.terror;
                    результат = да;
                }
            }
            return результат;
        }

        const место = fs.место;
        const dim = fs.parameters.dim;
        TypeAArray taa = null;

        Тип tn = null;
        Тип tnv = null;

        fs.func = sc.func;
        if (fs.func.fes)
            fs.func = fs.func.fes.func;

        VarDeclaration vinit = null;
        fs.aggr = fs.aggr.ВыражениеSemantic(sc);
        fs.aggr = resolveProperties(sc, fs.aggr);
        fs.aggr = fs.aggr.optimize(WANTvalue);
        if (fs.aggr.op == ТОК2.error)
            return setError();
        Выражение oaggr = fs.aggr;
        if (fs.aggr.тип && fs.aggr.тип.toBasetype().ty == Tstruct &&
            (cast(TypeStruct)(fs.aggr.тип.toBasetype())).sym.dtor &&
            fs.aggr.op != ТОК2.тип && !fs.aggr.isLvalue())
        {
            // https://issues.dlang.org/show_bug.cgi?ид=14653
            // Extend the life of rvalue aggregate till the end of foreach.
            vinit = copyToTemp(STC.rvalue, "__aggr", fs.aggr);
            vinit.endlinnum = fs.endloc.номстр;
            vinit.dsymbolSemantic(sc);
            fs.aggr = new VarExp(fs.aggr.место, vinit);
        }

        ДСимвол sapply = null;                  // the inferred opApply() or front() function
        if (!inferForeachAggregate(sc, fs.op == ТОК2.foreach_, fs.aggr, sapply))
        {
            ткст0 msg = "";
            if (fs.aggr.тип && isAggregate(fs.aggr.тип))
            {
                msg = ", define `opApply()`, range primitives, or use `.tupleof`";
            }
            fs.выведиОшибку("invalid `foreach` aggregate `%s`%s", oaggr.вТкст0(), msg);
            return setError();
        }

        ДСимвол sapplyOld = sapply; // 'sapply' will be NULL if and after 'inferApplyArgTypes' errors

        /* Check for inference errors
         */
        if (!inferApplyArgTypes(fs, sc, sapply))
        {
            /**
             Try and extract the параметр count of the opApply callback function, e.g.:
             цел opApply(цел delegate(цел, float)) => 2 args
             */
            бул foundMismatch = нет;
            т_мера foreachParamCount = 0;
            if (sapplyOld)
            {
                if (FuncDeclaration fd = sapplyOld.isFuncDeclaration())
                {
                    auto fparameters = fd.getParameterList();

                    if (fparameters.length == 1)
                    {
                        // first param should be the callback function
                        Параметр2 fparam = fparameters[0];
                        if ((fparam.тип.ty == Tpointer ||
                             fparam.тип.ty == Tdelegate) &&
                            fparam.тип.nextOf().ty == Tfunction)
                        {
                            TypeFunction tf = cast(TypeFunction)fparam.тип.nextOf();
                            foreachParamCount = tf.parameterList.length;
                            foundMismatch = да;
                        }
                    }
                }
            }

            //printf("dim = %d, parameters.dim = %d\n", dim, parameters.dim);
            if (foundMismatch && dim != foreachParamCount)
            {
                ткст0 plural = foreachParamCount > 1 ? "s" : "";
                fs.выведиОшибку("cannot infer argument types, expected %d argument%s, not %d",
                    foreachParamCount, plural, dim);
            }
            else
                fs.выведиОшибку("cannot uniquely infer `foreach` argument types");

            return setError();
        }

        Тип tab = fs.aggr.тип.toBasetype();

        if (tab.ty == Ttuple) // don't generate new scope for кортеж loops
        {
            makeTupleForeach!(нет,нет)(fs);
            if (vinit)
                результат = new CompoundStatement(место, new ExpStatement(место, vinit), результат);
            результат = результат.statementSemantic(sc);
            return;
        }

        auto sym = new ScopeDsymbol();
        sym.родитель = sc.scopesym;
        sym.endlinnum = fs.endloc.номстр;
        auto sc2 = sc.сунь(sym);
        sc2.inLoop = да;

        foreach (Параметр2 p; *fs.parameters)
        {
            if (p.классХранения & STC.manifest)
            {
                fs.выведиОшибку("cannot declare `enum` loop variables for non-unrolled foreach");
            }
            if (p.классХранения & STC.alias_)
            {
                fs.выведиОшибку("cannot declare `alias` loop variables for non-unrolled foreach");
            }
        }

        Инструкция2 s;
        switch (tab.ty)
        {
        case Tarray:
        case Tsarray:
            {
                if (checkForArgTypes(fs))
                    goto case Terror;

                if (dim < 1 || dim > 2)
                {
                    fs.выведиОшибку("only one or two arguments for массив `foreach`");
                    goto case Terror;
                }

                // Finish semantic on all foreach параметр types.
                foreach (i; new бцел[0 .. dim])
                {
                    Параметр2 p = (*fs.parameters)[i];
                    p.тип = p.тип.typeSemantic(место, sc2);
                    p.тип = p.тип.addStorageClass(p.классХранения);
                }

                tn = tab.nextOf().toBasetype();

                if (dim == 2)
                {
                    Тип tindex = (*fs.parameters)[0].тип;
                    if (!tindex.isintegral())
                    {
                        fs.выведиОшибку("foreach: ключ cannot be of non-integral тип `%s`", tindex.вТкст0());
                        goto case Terror;
                    }
                    /* What cases to deprecate implicit conversions for:
                     *  1. foreach aggregate is a dynamic массив
                     *  2. foreach body is lowered to _aApply (see special case below).
                     */
                    Тип tv = (*fs.parameters)[1].тип.toBasetype();
                    if ((tab.ty == Tarray ||
                         (tn.ty != tv.ty &&
                          (tn.ty == Tchar || tn.ty == Twchar || tn.ty == Tdchar) &&
                          (tv.ty == Tchar || tv.ty == Twchar || tv.ty == Tdchar))) &&
                        !Тип.tт_мера.implicitConvTo(tindex))
                    {
                        fs.deprecation("foreach: loop index implicitly converted from `т_мера` to `%s`",
                                       tindex.вТкст0());
                    }
                }

                /* Look for special case of parsing сим types out of сим тип
                 * массив.
                 */
                if (tn.ty == Tchar || tn.ty == Twchar || tn.ty == Tdchar)
                {
                    цел i = (dim == 1) ? 0 : 1; // index of значение
                    Параметр2 p = (*fs.parameters)[i];
                    tnv = p.тип.toBasetype();
                    if (tnv.ty != tn.ty &&
                        (tnv.ty == Tchar || tnv.ty == Twchar || tnv.ty == Tdchar))
                    {
                        if (p.классХранения & STC.ref_)
                        {
                            fs.выведиОшибку("`foreach`: значение of UTF conversion cannot be `ref`");
                            goto case Terror;
                        }
                        if (dim == 2)
                        {
                            p = (*fs.parameters)[0];
                            if (p.классХранения & STC.ref_)
                            {
                                fs.выведиОшибку("`foreach`: ключ cannot be `ref`");
                                goto case Terror;
                            }
                        }
                        goto Lapply;
                    }
                }

                foreach (i; new бцел[0 .. dim])
                {
                    // Declare parameters
                    Параметр2 p = (*fs.parameters)[i];
                    VarDeclaration var;

                    if (dim == 2 && i == 0)
                    {
                        var = new VarDeclaration(место, p.тип.mutableOf(), Идентификатор2.генерируйИд("__key"), null);
                        var.класс_хранения |= STC.temp | STC.foreach_;
                        if (var.класс_хранения & (STC.ref_ | STC.out_))
                            var.класс_хранения |= STC.nodtor;

                        fs.ключ = var;
                        if (p.классХранения & STC.ref_)
                        {
                            if (var.тип.constConv(p.тип) <= MATCH.nomatch)
                            {
                                fs.выведиОшибку("ключ тип mismatch, `%s` to `ref %s`",
                                    var.тип.вТкст0(), p.тип.вТкст0());
                                goto case Terror;
                            }
                        }
                        if (tab.ty == Tsarray)
                        {
                            TypeSArray ta = cast(TypeSArray)tab;
                            IntRange dimrange = getIntRange(ta.dim);
                            if (!IntRange.fromType(var.тип).содержит(dimrange))
                            {
                                fs.выведиОшибку("index тип `%s` cannot cover index range 0..%llu",
                                    p.тип.вТкст0(), ta.dim.toInteger());
                                goto case Terror;
                            }
                            fs.ключ.range = new IntRange(SignExtendedNumber(0), dimrange.imax);
                        }
                    }
                    else
                    {
                        var = new VarDeclaration(место, p.тип, p.идент, null);
                        var.класс_хранения |= STC.foreach_;
                        var.класс_хранения |= p.классХранения & (STC.in_ | STC.out_ | STC.ref_ | STC.TYPECTOR);
                        if (var.класс_хранения & (STC.ref_ | STC.out_))
                            var.класс_хранения |= STC.nodtor;

                        fs.значение = var;
                        if (var.класс_хранения & STC.ref_)
                        {
                            if (fs.aggr.checkModifiable(sc2, 1) == Modifiable.initialization)
                                var.класс_хранения |= STC.ctorinit;

                            Тип t = tab.nextOf();
                            if (t.constConv(p.тип) <= MATCH.nomatch)
                            {
                                fs.выведиОшибку("argument тип mismatch, `%s` to `ref %s`",
                                    t.вТкст0(), p.тип.вТкст0());
                                goto case Terror;
                            }
                        }
                    }
                }

                /* Convert to a ForStatement
                 *   foreach (ключ, значение; a) body =>
                 *   for (T[] tmp = a[], т_мера ключ; ключ < tmp.length; ++ключ)
                 *   { T значение = tmp[k]; body }
                 *
                 *   foreach_reverse (ключ, значение; a) body =>
                 *   for (T[] tmp = a[], т_мера ключ = tmp.length; ключ--; )
                 *   { T значение = tmp[k]; body }
                 */
                auto ид = Идентификатор2.генерируйИд("__r");
                auto ie = new ExpInitializer(место, new SliceExp(место, fs.aggr, null, null));
                VarDeclaration tmp;
                if (fs.aggr.op == ТОК2.arrayLiteral &&
                    !((*fs.parameters)[dim - 1].классХранения & STC.ref_))
                {
                    auto ale = cast(ArrayLiteralExp)fs.aggr;
                    т_мера edim = ale.elements ? ale.elements.dim : 0;
                    auto telem = (*fs.parameters)[dim - 1].тип;

                    // https://issues.dlang.org/show_bug.cgi?ид=12936
                    // if telem has been specified explicitly,
                    // converting массив literal elements to telem might make it .
                    fs.aggr = fs.aggr.implicitCastTo(sc, telem.sarrayOf(edim));
                    if (fs.aggr.op == ТОК2.error)
                        goto case Terror;

                    // for (T[edim] tmp = a, ...)
                    tmp = new VarDeclaration(место, fs.aggr.тип, ид, ie);
                }
                else
                    tmp = new VarDeclaration(место, tab.nextOf().arrayOf(), ид, ie);
                tmp.класс_хранения |= STC.temp;

                Выражение tmp_length = new DotIdExp(место, new VarExp(место, tmp), Id.length);

                if (!fs.ключ)
                {
                    Идентификатор2 idkey = Идентификатор2.генерируйИд("__key");
                    fs.ключ = new VarDeclaration(место, Тип.tт_мера, idkey, null);
                    fs.ключ.класс_хранения |= STC.temp;
                }
                else if (fs.ключ.тип.ty != Тип.tт_мера.ty)
                {
                    tmp_length = new CastExp(место, tmp_length, fs.ключ.тип);
                }
                if (fs.op == ТОК2.foreach_reverse_)
                    fs.ключ._иниц = new ExpInitializer(место, tmp_length);
                else
                    fs.ключ._иниц = new ExpInitializer(место, new IntegerExp(место, 0, fs.ключ.тип));

                auto cs = new Инструкции();
                if (vinit)
                    cs.сунь(new ExpStatement(место, vinit));
                cs.сунь(new ExpStatement(место, tmp));
                cs.сунь(new ExpStatement(место, fs.ключ));
                Инструкция2 forinit = new CompoundDeclarationStatement(место, cs);

                Выражение cond;
                if (fs.op == ТОК2.foreach_reverse_)
                {
                    // ключ--
                    cond = new PostExp(ТОК2.minusMinus, место, new VarExp(место, fs.ключ));
                }
                else
                {
                    // ключ < tmp.length
                    cond = new CmpExp(ТОК2.lessThan, место, new VarExp(место, fs.ключ), tmp_length);
                }

                Выражение increment = null;
                if (fs.op == ТОК2.foreach_)
                {
                    // ключ += 1
                    increment = new AddAssignExp(место, new VarExp(место, fs.ключ), new IntegerExp(место, 1, fs.ключ.тип));
                }

                // T значение = tmp[ключ];
                IndexExp indexExp = new IndexExp(место, new VarExp(место, tmp), new VarExp(место, fs.ключ));
                indexExp.indexIsInBounds = да; // disabling bounds checking in foreach statements.
                fs.значение._иниц = new ExpInitializer(место, indexExp);
                Инструкция2 ds = new ExpStatement(место, fs.значение);

                if (dim == 2)
                {
                    Параметр2 p = (*fs.parameters)[0];
                    if ((p.классХранения & STC.ref_) && p.тип.равен(fs.ключ.тип))
                    {
                        fs.ключ.range = null;
                        auto v = new AliasDeclaration(место, p.идент, fs.ключ);
                        fs._body = new CompoundStatement(место, new ExpStatement(место, v), fs._body);
                    }
                    else
                    {
                        auto ei = new ExpInitializer(место, new IdentifierExp(место, fs.ключ.идент));
                        auto v = new VarDeclaration(место, p.тип, p.идент, ei);
                        v.класс_хранения |= STC.foreach_ | (p.классХранения & STC.ref_);
                        fs._body = new CompoundStatement(место, new ExpStatement(место, v), fs._body);
                        if (fs.ключ.range && !p.тип.isMutable())
                        {
                            /* Limit the range of the ключ to the specified range
                             */
                            v.range = new IntRange(fs.ключ.range.imin, fs.ключ.range.imax - SignExtendedNumber(1));
                        }
                    }
                }
                fs._body = new CompoundStatement(место, ds, fs._body);

                s = new ForStatement(место, forinit, cond, increment, fs._body, fs.endloc);
                if (auto ls = checkLabeledLoop(sc, fs))   // https://issues.dlang.org/show_bug.cgi?ид=15450
                                                          // don't use sc2
                    ls.gotoTarget = s;
                s = s.statementSemantic(sc2);
                break;
            }
        case Taarray:
            if (fs.op == ТОК2.foreach_reverse_)
                fs.warning("cannot use `foreach_reverse` with an associative массив");
            if (checkForArgTypes(fs))
                goto case Terror;

            taa = cast(TypeAArray)tab;
            if (dim < 1 || dim > 2)
            {
                fs.выведиОшибку("only one or two arguments for associative массив `foreach`");
                goto case Terror;
            }
            goto Lapply;

        case Tclass:
        case Tstruct:
            /* Prefer using opApply, if it exists
             */
            if (sapply)
                goto Lapply;
            {
                /* Look for range iteration, i.e. the properties
                 * .empty, .popFront, .popBack, .front and .back
                 *    foreach (e; aggr) { ... }
                 * translates to:
                 *    for (auto __r = aggr[]; !__r.empty; __r.popFront()) {
                 *        auto e = __r.front;
                 *        ...
                 *    }
                 */
                auto ad = (tab.ty == Tclass) ?
                    cast(AggregateDeclaration)(cast(TypeClass)tab).sym :
                    cast(AggregateDeclaration)(cast(TypeStruct)tab).sym;
                Идентификатор2 idfront;
                Идентификатор2 idpopFront;
                if (fs.op == ТОК2.foreach_)
                {
                    idfront = Id.Ffront;
                    idpopFront = Id.FpopFront;
                }
                else
                {
                    idfront = Id.Fback;
                    idpopFront = Id.FpopBack;
                }
                auto sfront = ad.search(Место.initial, idfront);
                if (!sfront)
                    goto Lapply;

                /* Generate a temporary __r and initialize it with the aggregate.
                 */
                VarDeclaration r;
                Инструкция2 _иниц;
                if (vinit && fs.aggr.op == ТОК2.variable && (cast(VarExp)fs.aggr).var == vinit)
                {
                    r = vinit;
                    _иниц = new ExpStatement(место, vinit);
                }
                else
                {
                    r = copyToTemp(0, "__r", fs.aggr);
                    r.dsymbolSemantic(sc);
                    _иниц = new ExpStatement(место, r);
                    if (vinit)
                        _иниц = new CompoundStatement(место, new ExpStatement(место, vinit), _иниц);
                }

                // !__r.empty
                Выражение e = new VarExp(место, r);
                e = new DotIdExp(место, e, Id.Fempty);
                Выражение условие = new NotExp(место, e);

                // __r.idpopFront()
                e = new VarExp(место, r);
                Выражение increment = new CallExp(место, new DotIdExp(место, e, idpopFront));

                /* Declaration инструкция for e:
                 *    auto e = __r.idfront;
                 */
                e = new VarExp(место, r);
                Выражение einit = new DotIdExp(место, e, idfront);
                Инструкция2 makeargs, forbody;
                бул ignoreRef = нет; // If a range returns a non-ref front we ignore ref on foreach

                Тип tfront;
                if (auto fd = sfront.isFuncDeclaration())
                {
                    if (!fd.functionSemantic())
                        goto Lrangeerr;
                    tfront = fd.тип;
                }
                else if (auto td = sfront.isTemplateDeclaration())
                {
                    Выражения a;
                    if (auto f = resolveFuncCall(место, sc, td, null, tab, &a, FuncResolveFlag.quiet))
                        tfront = f.тип;
                }
                else if (auto d = sfront.toAlias().isDeclaration())
                {
                    tfront = d.тип;
                }
                if (!tfront || tfront.ty == Terror)
                    goto Lrangeerr;
                if (tfront.toBasetype().ty == Tfunction)
                {
                    auto ftt = cast(TypeFunction)tfront.toBasetype();
                    tfront = tfront.toBasetype().nextOf();
                    if (!ftt.isref)
                    {
                        // .front() does not return a ref. We ignore ref on foreach arg.
                        // see https://issues.dlang.org/show_bug.cgi?ид=11934
                        if (tfront.needsDestruction()) ignoreRef = да;
                    }
                }
                if (tfront.ty == Tvoid)
                {
                    fs.выведиОшибку("`%s.front` is `проц` and has no значение", oaggr.вТкст0());
                    goto case Terror;
                }

                if (dim == 1)
                {
                    auto p = (*fs.parameters)[0];
                    auto ve = new VarDeclaration(место, p.тип, p.идент, new ExpInitializer(место, einit));
                    ve.класс_хранения |= STC.foreach_;
                    ve.класс_хранения |= p.классХранения & (STC.in_ | STC.out_ | STC.ref_ | STC.TYPECTOR);

                    if (ignoreRef)
                        ve.класс_хранения &= ~STC.ref_;

                    makeargs = new ExpStatement(место, ve);
                }
                else
                {
                    auto vd = copyToTemp(STC.ref_, "__front", einit);
                    vd.dsymbolSemantic(sc);
                    makeargs = new ExpStatement(место, vd);

                    // Resolve inout qualifier of front тип
                    tfront = tfront.substWildTo(tab.mod);

                    Выражение ve = new VarExp(место, vd);
                    ve.тип = tfront;

                    auto exps = new Выражения();
                    exps.сунь(ve);
                    цел pos = 0;
                    while (exps.dim < dim)
                    {
                        pos = expandAliasThisTuples(exps, pos);
                        if (pos == -1)
                            break;
                    }
                    if (exps.dim != dim)
                    {
                        ткст0 plural = exps.dim > 1 ? "s" : "";
                        fs.выведиОшибку("cannot infer argument types, expected %d argument%s, not %d",
                            exps.dim, plural, dim);
                        goto case Terror;
                    }

                    foreach (i; new бцел[0 .. dim])
                    {
                        auto p = (*fs.parameters)[i];
                        auto exp = (*exps)[i];
                        version (none)
                        {
                            printf("[%d] p = %s %s, exp = %s %s\n", i,
                                p.тип ? p.тип.вТкст0() : "?", p.идент.вТкст0(),
                                exp.тип.вТкст0(), exp.вТкст0());
                        }
                        if (!p.тип)
                            p.тип = exp.тип;

                        auto sc = p.классХранения;
                        if (ignoreRef) sc &= ~STC.ref_;
                        p.тип = p.тип.addStorageClass(sc).typeSemantic(место, sc2);
                        if (!exp.implicitConvTo(p.тип))
                            goto Lrangeerr;

                        auto var = new VarDeclaration(место, p.тип, p.идент, new ExpInitializer(место, exp));
                        var.класс_хранения |= STC.ctfe | STC.ref_ | STC.foreach_;
                        makeargs = new CompoundStatement(место, makeargs, new ExpStatement(место, var));
                    }
                }

                forbody = new CompoundStatement(место, makeargs, fs._body);

                s = new ForStatement(место, _иниц, условие, increment, forbody, fs.endloc);
                if (auto ls = checkLabeledLoop(sc, fs))
                    ls.gotoTarget = s;

                version (none)
                {
                    printf("init: %s\n", _иниц.вТкст0());
                    printf("условие: %s\n", условие.вТкст0());
                    printf("increment: %s\n", increment.вТкст0());
                    printf("body: %s\n", forbody.вТкст0());
                }
                s = s.statementSemantic(sc2);
                break;

            Lrangeerr:
                fs.выведиОшибку("cannot infer argument types");
                goto case Terror;
            }
        case Tdelegate:
            if (fs.op == ТОК2.foreach_reverse_)
                fs.deprecation("cannot use `foreach_reverse` with a delegate");
        Lapply:
            {
                if (checkForArgTypes(fs))
                    goto case Terror;

                TypeFunction tfld = null;
                if (sapply)
                {
                    FuncDeclaration fdapply = sapply.isFuncDeclaration();
                    if (fdapply)
                    {
                        assert(fdapply.тип && fdapply.тип.ty == Tfunction);
                        tfld = cast(TypeFunction)fdapply.тип.typeSemantic(место, sc2);
                        goto Lget;
                    }
                    else if (tab.ty == Tdelegate)
                    {
                        tfld = cast(TypeFunction)tab.nextOf();
                    Lget:
                        //printf("tfld = %s\n", tfld.вТкст0());
                        if (tfld.parameterList.parameters.dim == 1)
                        {
                            Параметр2 p = tfld.parameterList[0];
                            if (p.тип && p.тип.ty == Tdelegate)
                            {
                                auto t = p.тип.typeSemantic(место, sc2);
                                assert(t.ty == Tdelegate);
                                tfld = cast(TypeFunction)t.nextOf();
                            }
                            //printf("tfld = %s\n", tfld.вТкст0());
                        }
                    }
                }

                FuncExp flde = foreachBodyToFunction(sc2, fs, tfld);
                if (!flde)
                    goto case Terror;

                // Resolve any forward referenced goto's
                foreach (ScopeStatement ss; *fs.gotos)
                {
                    GotoStatement gs = ss.инструкция.isGotoStatement();
                    if (!gs.label.инструкция)
                    {
                        // 'Promote' it to this scope, and replace with a return
                        fs.cases.сунь(gs);
                        ss.инструкция = new ReturnStatement(Место.initial, new IntegerExp(fs.cases.dim + 1));
                    }
                }

                Выражение e = null;
                Выражение ec;
                if (vinit)
                {
                    e = new DeclarationExp(место, vinit);
                    e = e.ВыражениеSemantic(sc2);
                    if (e.op == ТОК2.error)
                        goto case Terror;
                }

                if (taa)
                {
                    // Check types
                    Параметр2 p = (*fs.parameters)[0];
                    бул isRef = (p.классХранения & STC.ref_) != 0;
                    Тип ta = p.тип;
                    if (dim == 2)
                    {
                        Тип ti = (isRef ? taa.index.addMod(MODFlags.const_) : taa.index);
                        if (isRef ? !ti.constConv(ta) : !ti.implicitConvTo(ta))
                        {
                            fs.выведиОшибку("`foreach`: index must be тип `%s`, not `%s`",
                                ti.вТкст0(), ta.вТкст0());
                            goto case Terror;
                        }
                        p = (*fs.parameters)[1];
                        isRef = (p.классХранения & STC.ref_) != 0;
                        ta = p.тип;
                    }
                    Тип taav = taa.nextOf();
                    if (isRef ? !taav.constConv(ta) : !taav.implicitConvTo(ta))
                    {
                        fs.выведиОшибку("`foreach`: значение must be тип `%s`, not `%s`",
                            taav.вТкст0(), ta.вТкст0());
                        goto case Terror;
                    }

                    /* Call:
                     *  extern(C) цел _aaApply(ук, in т_мера, цел delegate(ук))
                     *      _aaApply(aggr, keysize, flde)
                     *
                     *  extern(C) цел _aaApply2(ук, in т_мера, цел delegate(ук, ук))
                     *      _aaApply2(aggr, keysize, flde)
                     */
                     FuncDeclaration* fdapply = [null, null];
                     TypeDelegate* fldeTy = [null, null];

                    ббайт i = (dim == 2 ? 1 : 0);
                    if (!fdapply[i])
                    {
                        auto парамы = new Параметры();
                        парамы.сунь(new Параметр2(0, Тип.tvoid.pointerTo(), null, null, null));
                        парамы.сунь(new Параметр2(STC.in_, Тип.tт_мера, null, null, null));
                        auto dgparams = new Параметры();
                        dgparams.сунь(new Параметр2(0, Тип.tvoidptr, null, null, null));
                        if (dim == 2)
                            dgparams.сунь(new Параметр2(0, Тип.tvoidptr, null, null, null));
                        fldeTy[i] = new TypeDelegate(new TypeFunction(СписокПараметров(dgparams), Тип.tint32, LINK.d));
                        парамы.сунь(new Параметр2(0, fldeTy[i], null, null, null));
                        fdapply[i] = FuncDeclaration.genCfunc(парамы, Тип.tint32, i ? Id._aaApply2 : Id._aaApply);
                    }

                    auto exps = new Выражения();
                    exps.сунь(fs.aggr);
                    auto keysize = taa.index.size();
                    if (keysize == SIZE_INVALID)
                        goto case Terror;
                    assert(keysize < keysize.max - target.ptrsize);
                    keysize = (keysize + (target.ptrsize - 1)) & ~(target.ptrsize - 1);
                    // paint delegate argument to the тип runtime expects
                    Выражение fexp = flde;
                    if (!fldeTy[i].равен(flde.тип))
                    {
                        fexp = new CastExp(место, flde, flde.тип);
                        fexp.тип = fldeTy[i];
                    }
                    exps.сунь(new IntegerExp(Место.initial, keysize, Тип.tт_мера));
                    exps.сунь(fexp);
                    ec = new VarExp(Место.initial, fdapply[i], нет);
                    ec = new CallExp(место, ec, exps);
                    ec.тип = Тип.tint32; // don't run semantic() on ec
                }
                else if (tab.ty == Tarray || tab.ty == Tsarray)
                {
                    /* Call:
                     *      _aApply(aggr, flde)
                     */
                     сим** fntab =
                    [
                        "cc", "cw", "cd",
                        "wc", "cc", "wd",
                        "dc", "dw", "dd"
                    ];

                    const т_мера BUFFER_LEN = 7 + 1 + 2 + dim.sizeof * 3 + 1;
                    сим[BUFFER_LEN] fdname;
                    цел флаг;

                    switch (tn.ty)
                    {
                    case Tchar:     флаг = 0;   break;
                    case Twchar:    флаг = 3;   break;
                    case Tdchar:    флаг = 6;   break;
                    default:
                        assert(0);
                    }
                    switch (tnv.ty)
                    {
                    case Tchar:     флаг += 0;  break;
                    case Twchar:    флаг += 1;  break;
                    case Tdchar:    флаг += 2;  break;
                    default:
                        assert(0);
                    }
                    ткст0 r = (fs.op == ТОК2.foreach_reverse_) ? "R" : "";
                    цел j = sprintf(fdname.ptr, "_aApply%s%.*s%llu", r, 2, fntab[флаг], cast(бдол)dim);
                    assert(j < BUFFER_LEN);

                    FuncDeclaration fdapply;
                    TypeDelegate dgty;
                    auto парамы = new Параметры();
                    парамы.сунь(new Параметр2(STC.in_, tn.arrayOf(), null, null, null));
                    auto dgparams = new Параметры();
                    dgparams.сунь(new Параметр2(0, Тип.tvoidptr, null, null, null));
                    if (dim == 2)
                        dgparams.сунь(new Параметр2(0, Тип.tvoidptr, null, null, null));
                    dgty = new TypeDelegate(new TypeFunction(СписокПараметров(dgparams), Тип.tint32, LINK.d));
                    парамы.сунь(new Параметр2(0, dgty, null, null, null));
                    fdapply = FuncDeclaration.genCfunc(парамы, Тип.tint32, fdname.ptr);

                    if (tab.ty == Tsarray)
                        fs.aggr = fs.aggr.castTo(sc2, tn.arrayOf());
                    // paint delegate argument to the тип runtime expects
                    Выражение fexp = flde;
                    if (!dgty.равен(flde.тип))
                    {
                        fexp = new CastExp(место, flde, flde.тип);
                        fexp.тип = dgty;
                    }
                    ec = new VarExp(Место.initial, fdapply, нет);
                    ec = new CallExp(место, ec, fs.aggr, fexp);
                    ec.тип = Тип.tint32; // don't run semantic() on ec
                }
                else if (tab.ty == Tdelegate)
                {
                    /* Call:
                     *      aggr(flde)
                     */
                    if (fs.aggr.op == ТОК2.delegate_ && (cast(DelegateExp)fs.aggr).func.isNested() && !(cast(DelegateExp)fs.aggr).func.needThis())
                    {
                        // https://issues.dlang.org/show_bug.cgi?ид=3560
                        fs.aggr = (cast(DelegateExp)fs.aggr).e1;
                    }
                    ec = new CallExp(место, fs.aggr, flde);
                    ec = ec.ВыражениеSemantic(sc2);
                    if (ec.op == ТОК2.error)
                        goto case Terror;
                    if (ec.тип != Тип.tint32)
                    {
                        fs.выведиОшибку("`opApply()` function for `%s` must return an `цел`", tab.вТкст0());
                        goto case Terror;
                    }
                }
                else
                {
version (none)
{
                    if (глоб2.парамы.vsafe)
                    {
                        message(место, "To enforce ``, the compiler allocates a closure unless `opApply()` uses `scope`");
                    }
                    flde.fd.tookAddressOf = 1;
}
else
{
                    if (глоб2.парамы.vsafe)
                        ++flde.fd.tookAddressOf;  // размести a closure unless the opApply() uses 'scope'
}
                    assert(tab.ty == Tstruct || tab.ty == Tclass);
                    assert(sapply);
                    /* Call:
                     *  aggr.apply(flde)
                     */
                    ec = new DotIdExp(место, fs.aggr, sapply.идент);
                    ec = new CallExp(место, ec, flde);
                    ec = ec.ВыражениеSemantic(sc2);
                    if (ec.op == ТОК2.error)
                        goto case Terror;
                    if (ec.тип != Тип.tint32)
                    {
                        fs.выведиОшибку("`opApply()` function for `%s` must return an `цел`", tab.вТкст0());
                        goto case Terror;
                    }
                }
                e = Выражение.combine(e, ec);

                if (!fs.cases.dim)
                {
                    // Easy case, a clean exit from the loop
                    e = new CastExp(место, e, Тип.tvoid); // https://issues.dlang.org/show_bug.cgi?ид=13899
                    s = new ExpStatement(место, e);
                }
                else
                {
                    // Construct a switch инструкция around the return значение
                    // of the apply function.
                    auto a = new Инструкции();

                    // default: break; takes care of cases 0 and 1
                    s = new BreakStatement(Место.initial, null);
                    s = new DefaultStatement(Место.initial, s);
                    a.сунь(s);

                    // cases 2...
                    foreach (i, c; *fs.cases)
                    {
                        s = new CaseStatement(Место.initial, new IntegerExp(i + 2), c);
                        a.сунь(s);
                    }

                    s = new CompoundStatement(место, a);
                    s = new SwitchStatement(место, e, s, нет);
                }
                s = s.statementSemantic(sc2);
                break;
            }
            assert(0);

        case Terror:
            s = new ErrorStatement();
            break;

        default:
            fs.выведиОшибку("`foreach`: `%s` is not an aggregate тип", fs.aggr.тип.вТкст0());
            goto case Terror;
        }
        sc2.вынь();
        результат = s;
    }

    /*************************************
     * Turn foreach body into the function literal:
     *  цел delegate(ref T param) { body }
     * Параметры:
     *  sc = context
     *  fs = ForeachStatement
     *  tfld = тип of function literal to be created, can be null
     * Возвращает:
     *  Function literal created, as an Выражение
     *  null if error.
     */
    static FuncExp foreachBodyToFunction(Scope* sc, ForeachStatement fs, TypeFunction tfld)
    {
        auto парамы = new Параметры();
        foreach (i; new бцел[0 .. fs.parameters.dim])
        {
            Параметр2 p = (*fs.parameters)[i];
            КлассХранения stc = STC.ref_;
            Идентификатор2 ид;

            p.тип = p.тип.typeSemantic(fs.место, sc);
            p.тип = p.тип.addStorageClass(p.классХранения);
            if (tfld)
            {
                Параметр2 prm = tfld.parameterList[i];
                //printf("\tprm = %s%s\n", (prm.классХранения&STC.ref_?"ref ":"").ptr, prm.идент.вТкст0());
                stc = prm.классХранения & STC.ref_;
                ид = p.идент; // argument копируй is not need.
                if ((p.классХранения & STC.ref_) != stc)
                {
                    if (!stc)
                    {
                        fs.выведиОшибку("`foreach`: cannot make `%s` `ref`", p.идент.вТкст0());
                        return null;
                    }
                    goto LcopyArg;
                }
            }
            else if (p.классХранения & STC.ref_)
            {
                // default delegate parameters are marked as ref, then
                // argument копируй is not need.
                ид = p.идент;
            }
            else
            {
                // Make a копируй of the ref argument so it isn't
                // a reference.
            LcopyArg:
                ид = Идентификатор2.генерируйИд("__applyArg", cast(цел)i);

                Инициализатор ie = new ExpInitializer(fs.место, new IdentifierExp(fs.место, ид));
                auto v = new VarDeclaration(fs.место, p.тип, p.идент, ie);
                v.класс_хранения |= STC.temp;
                Инструкция2 s = new ExpStatement(fs.место, v);
                fs._body = new CompoundStatement(fs.место, s, fs._body);
            }
            парамы.сунь(new Параметр2(stc, p.тип, ид, null, null));
        }
        // https://issues.dlang.org/show_bug.cgi?ид=13840
        // Throwable nested function inside  function is acceptable.
        КлассХранения stc = mergeFuncAttrs(STC.safe | STC.pure_ | STC.nogc, fs.func);
        auto tf = new TypeFunction(СписокПараметров(парамы), Тип.tint32, LINK.d, stc);
        fs.cases = new Инструкции();
        fs.gotos = new ScopeStatements();
        auto fld = new FuncLiteralDeclaration(fs.место, fs.endloc, tf, ТОК2.delegate_, fs);
        fld.fbody = fs._body;
        Выражение flde = new FuncExp(fs.место, fld);
        flde = flde.ВыражениеSemantic(sc);
        fld.tookAddressOf = 0;
        if (flde.op == ТОК2.error)
            return null;
        return cast(FuncExp)flde;
    }

    override проц посети(ForeachRangeStatement fs)
    {
        /* https://dlang.org/spec/инструкция.html#foreach-range-инструкция
         */

        //printf("ForeachRangeStatement::semantic() %p\n", fs);
        auto место = fs.место;
        fs.lwr = fs.lwr.ВыражениеSemantic(sc);
        fs.lwr = resolveProperties(sc, fs.lwr);
        fs.lwr = fs.lwr.optimize(WANTvalue);
        if (!fs.lwr.тип)
        {
            fs.выведиОшибку("invalid range lower bound `%s`", fs.lwr.вТкст0());
            return setError();
        }

        fs.upr = fs.upr.ВыражениеSemantic(sc);
        fs.upr = resolveProperties(sc, fs.upr);
        fs.upr = fs.upr.optimize(WANTvalue);
        if (!fs.upr.тип)
        {
            fs.выведиОшибку("invalid range upper bound `%s`", fs.upr.вТкст0());
            return setError();
        }

        if (fs.prm.тип)
        {
            fs.prm.тип = fs.prm.тип.typeSemantic(место, sc);
            fs.prm.тип = fs.prm.тип.addStorageClass(fs.prm.классХранения);
            fs.lwr = fs.lwr.implicitCastTo(sc, fs.prm.тип);

            if (fs.upr.implicitConvTo(fs.prm.тип) || (fs.prm.классХранения & STC.ref_))
            {
                fs.upr = fs.upr.implicitCastTo(sc, fs.prm.тип);
            }
            else
            {
                // See if upr-1 fits in prm.тип
                Выражение limit = new MinExp(место, fs.upr, IntegerExp.literal!(1));
                limit = limit.ВыражениеSemantic(sc);
                limit = limit.optimize(WANTvalue);
                if (!limit.implicitConvTo(fs.prm.тип))
                {
                    fs.upr = fs.upr.implicitCastTo(sc, fs.prm.тип);
                }
            }
        }
        else
        {
            /* Must infer types from lwr and upr
             */
            Тип tlwr = fs.lwr.тип.toBasetype();
            if (tlwr.ty == Tstruct || tlwr.ty == Tclass)
            {
                /* Just picking the first really isn't good enough.
                 */
                fs.prm.тип = fs.lwr.тип;
            }
            else if (fs.lwr.тип == fs.upr.тип)
            {
                /* Same logic as CondExp ?lwr:upr
                 */
                fs.prm.тип = fs.lwr.тип;
            }
            else
            {
                scope AddExp ea = new AddExp(место, fs.lwr, fs.upr);
                if (typeCombine(ea, sc))
                    return setError();
                fs.prm.тип = ea.тип;
                fs.lwr = ea.e1;
                fs.upr = ea.e2;
            }
            fs.prm.тип = fs.prm.тип.addStorageClass(fs.prm.классХранения);
        }
        if (fs.prm.тип.ty == Terror || fs.lwr.op == ТОК2.error || fs.upr.op == ТОК2.error)
        {
            return setError();
        }

        /* Convert to a for loop:
         *  foreach (ключ; lwr .. upr) =>
         *  for (auto ключ = lwr, auto tmp = upr; ключ < tmp; ++ключ)
         *
         *  foreach_reverse (ключ; lwr .. upr) =>
         *  for (auto tmp = lwr, auto ключ = upr; ключ-- > tmp;)
         */
        auto ie = new ExpInitializer(место, (fs.op == ТОК2.foreach_) ? fs.lwr : fs.upr);
        fs.ключ = new VarDeclaration(место, fs.upr.тип.mutableOf(), Идентификатор2.генерируйИд("__key"), ie);
        fs.ключ.класс_хранения |= STC.temp;
        SignExtendedNumber lower = getIntRange(fs.lwr).imin;
        SignExtendedNumber upper = getIntRange(fs.upr).imax;
        if (lower <= upper)
        {
            fs.ключ.range = new IntRange(lower, upper);
        }

        Идентификатор2 ид = Идентификатор2.генерируйИд("__limit");
        ie = new ExpInitializer(место, (fs.op == ТОК2.foreach_) ? fs.upr : fs.lwr);
        auto tmp = new VarDeclaration(место, fs.upr.тип, ид, ie);
        tmp.класс_хранения |= STC.temp;

        auto cs = new Инструкции();
        // Keep order of evaluation as lwr, then upr
        if (fs.op == ТОК2.foreach_)
        {
            cs.сунь(new ExpStatement(место, fs.ключ));
            cs.сунь(new ExpStatement(место, tmp));
        }
        else
        {
            cs.сунь(new ExpStatement(место, tmp));
            cs.сунь(new ExpStatement(место, fs.ключ));
        }
        Инструкция2 forinit = new CompoundDeclarationStatement(место, cs);

        Выражение cond;
        if (fs.op == ТОК2.foreach_reverse_)
        {
            cond = new PostExp(ТОК2.minusMinus, место, new VarExp(место, fs.ключ));
            if (fs.prm.тип.isscalar())
            {
                // ключ-- > tmp
                cond = new CmpExp(ТОК2.greaterThan, место, cond, new VarExp(место, tmp));
            }
            else
            {
                // ключ-- != tmp
                cond = new EqualExp(ТОК2.notEqual, место, cond, new VarExp(место, tmp));
            }
        }
        else
        {
            if (fs.prm.тип.isscalar())
            {
                // ключ < tmp
                cond = new CmpExp(ТОК2.lessThan, место, new VarExp(место, fs.ключ), new VarExp(место, tmp));
            }
            else
            {
                // ключ != tmp
                cond = new EqualExp(ТОК2.notEqual, место, new VarExp(место, fs.ключ), new VarExp(место, tmp));
            }
        }

        Выражение increment = null;
        if (fs.op == ТОК2.foreach_)
        {
            // ключ += 1
            //increment = new AddAssignExp(место, new VarExp(место, fs.ключ), IntegerExp.literal!(1));
            increment = new PreExp(ТОК2.prePlusPlus, место, new VarExp(место, fs.ключ));
        }
        if ((fs.prm.классХранения & STC.ref_) && fs.prm.тип.равен(fs.ключ.тип))
        {
            fs.ключ.range = null;
            auto v = new AliasDeclaration(место, fs.prm.идент, fs.ключ);
            fs._body = new CompoundStatement(место, new ExpStatement(место, v), fs._body);
        }
        else
        {
            ie = new ExpInitializer(место, new CastExp(место, new VarExp(место, fs.ключ), fs.prm.тип));
            auto v = new VarDeclaration(место, fs.prm.тип, fs.prm.идент, ie);
            v.класс_хранения |= STC.temp | STC.foreach_ | (fs.prm.классХранения & STC.ref_);
            fs._body = new CompoundStatement(место, new ExpStatement(место, v), fs._body);
            if (fs.ключ.range && !fs.prm.тип.isMutable())
            {
                /* Limit the range of the ключ to the specified range
                 */
                v.range = new IntRange(fs.ключ.range.imin, fs.ключ.range.imax - SignExtendedNumber(1));
            }
        }
        if (fs.prm.классХранения & STC.ref_)
        {
            if (fs.ключ.тип.constConv(fs.prm.тип) <= MATCH.nomatch)
            {
                fs.выведиОшибку("argument тип mismatch, `%s` to `ref %s`", fs.ключ.тип.вТкст0(), fs.prm.тип.вТкст0());
                return setError();
            }
        }

        auto s = new ForStatement(место, forinit, cond, increment, fs._body, fs.endloc);
        if (LabelStatement ls = checkLabeledLoop(sc, fs))
            ls.gotoTarget = s;
        результат = s.statementSemantic(sc);
    }

    override проц посети(IfStatement ifs)
    {
        /* https://dlang.org/spec/инструкция.html#IfStatement
         */

        // check in syntax уровень
        ifs.условие = checkAssignmentAsCondition(ifs.условие);

        auto sym = new ScopeDsymbol();
        sym.родитель = sc.scopesym;
        sym.endlinnum = ifs.endloc.номстр;
        Scope* scd = sc.сунь(sym);
        if (ifs.prm)
        {
            /* Declare prm, which we will set to be the
             * результат of условие.
             */
            auto ei = new ExpInitializer(ifs.место, ifs.условие);
            ifs.match = new VarDeclaration(ifs.место, ifs.prm.тип, ifs.prm.идент, ei);
            ifs.match.родитель = scd.func;
            ifs.match.класс_хранения |= ifs.prm.классХранения;
            ifs.match.dsymbolSemantic(scd);

            auto de = new DeclarationExp(ifs.место, ifs.match);
            auto ve = new VarExp(ifs.место, ifs.match);
            ifs.условие = new CommaExp(ifs.место, de, ve);
            ifs.условие = ifs.условие.ВыражениеSemantic(scd);

            if (ifs.match.edtor)
            {
                Инструкция2 sdtor = new DtorExpStatement(ifs.место, ifs.match.edtor, ifs.match);
                sdtor = new ScopeGuardStatement(ifs.место, ТОК2.onScopeExit, sdtor);
                ifs.ifbody = new CompoundStatement(ifs.место, sdtor, ifs.ifbody);
                ifs.match.класс_хранения |= STC.nodtor;

                // the destructor is always called
                // whether the 'ifbody' is executed or not
                Инструкция2 sdtor2 = new DtorExpStatement(ifs.место, ifs.match.edtor, ifs.match);
                if (ifs.elsebody)
                    ifs.elsebody = new CompoundStatement(ifs.место, sdtor2, ifs.elsebody);
                else
                    ifs.elsebody = sdtor2;
            }
        }
        else
        {
            if (ifs.условие.op == ТОК2.dotIdentifier)
                (cast(DotIdExp)ifs.условие).noderef = да;

            ifs.условие = ifs.условие.ВыражениеSemantic(scd);
            ifs.условие = resolveProperties(scd, ifs.условие);
            ifs.условие = ifs.условие.addDtorHook(scd);
        }
        if (checkNonAssignmentArrayOp(ifs.условие))
            ifs.условие = new ErrorExp();
        ifs.условие = checkGC(scd, ifs.условие);

        // Convert to булean after declaring prm so this works:
        //  if (S prm = S()) {}
        // where S is a struct that defines opCast!бул.
        ifs.условие = ifs.условие.toBoolean(scd);

        // If we can short-circuit evaluate the if инструкция, don't do the
        // semantic analysis of the skipped code.
        // This feature allows a limited form of conditional compilation.
        ifs.условие = ifs.условие.optimize(WANTvalue);

        // Save 'root' of two branches (then and else) at the point where it forks
        CtorFlow ctorflow_root = scd.ctorflow.clone();

        ifs.ifbody = ifs.ifbody.semanticNoScope(scd);
        scd.вынь();

        CtorFlow ctorflow_then = sc.ctorflow;   // move flow результатs
        sc.ctorflow = ctorflow_root;            // сбрось flow analysis back to root
        if (ifs.elsebody)
            ifs.elsebody = ifs.elsebody.semanticScope(sc, null, null);

        // Merge 'then' результатs into 'else' результатs
        sc.merge(ifs.место, ctorflow_then);

        ctorflow_then.freeFieldinit();          // free extra копируй of the данные

        if (ifs.условие.op == ТОК2.error ||
            (ifs.ifbody && ifs.ifbody.isErrorStatement()) ||
            (ifs.elsebody && ifs.elsebody.isErrorStatement()))
        {
            return setError();
        }
        результат = ifs;
    }

    override проц посети(ConditionalStatement cs)
    {
        //printf("ConditionalStatement::semantic()\n");

        // If we can short-circuit evaluate the if инструкция, don't do the
        // semantic analysis of the skipped code.
        // This feature allows a limited form of conditional compilation.
        if (cs.условие.include(sc))
        {
            DebugCondition dc = cs.условие.isDebugCondition();
            if (dc)
            {
                sc = sc.сунь();
                sc.flags |= SCOPE.debug_;
                cs.ifbody = cs.ifbody.statementSemantic(sc);
                sc.вынь();
            }
            else
                cs.ifbody = cs.ifbody.statementSemantic(sc);
            результат = cs.ifbody;
        }
        else
        {
            if (cs.elsebody)
                cs.elsebody = cs.elsebody.statementSemantic(sc);
            результат = cs.elsebody;
        }
    }

    override проц посети(PragmaStatement ps)
    {
        /* https://dlang.org/spec/инструкция.html#pragma-инструкция
         */
        // Should be merged with PragmaDeclaration

        //printf("PragmaStatement::semantic() %s\n", ps.вТкст0());
        //printf("body = %p\n", ps._body);
        if (ps.идент == Id.msg)
        {
            if (ps.args)
            {
                foreach (arg; *ps.args)
                {
                    sc = sc.startCTFE();
                    auto e = arg.ВыражениеSemantic(sc);
                    e = resolveProperties(sc, e);
                    sc = sc.endCTFE();

                    // pragma(msg) is allowed to contain types as well as Выражения
                    e = ctfeInterpretForPragmaMsg(e);
                    if (e.op == ТОК2.error)
                    {
                        errorSupplemental(ps.место, "while evaluating `pragma(msg, %s)`", arg.вТкст0());
                        return setError();
                    }
                    if (auto se = e.вТкстExp())
                    {
                        const slice = se.toUTF8(sc).peekString();
                        fprintf(stderr, "%.*s", cast(цел)slice.length, slice.ptr);
                    }
                    else
                        fprintf(stderr, "%s", e.вТкст0());
                }
                fprintf(stderr, "\n");
            }
        }
        else if (ps.идент == Id.lib)
        {
            version (all)
            {
                /* Should this be allowed?
                 */
                ps.выведиОшибку("`pragma(lib)` not allowed as инструкция");
                return setError();
            }
            else
            {
                if (!ps.args || ps.args.dim != 1)
                {
                    ps.выведиОшибку("`ткст` expected for library имя");
                    return setError();
                }
                else
                {
                    auto se = semanticString(sc, (*ps.args)[0], "library имя");
                    if (!se)
                        return setError();

                    if (глоб2.парамы.verbose)
                    {
                        message("library   %.*s", cast(цел)se.len, se.ткст);
                    }
                }
            }
        }
        else if (ps.идент == Id.linkerDirective)
        {
            /* Should this be allowed?
             */
            ps.выведиОшибку("`pragma(linkerDirective)` not allowed as инструкция");
            return setError();
        }
        else if (ps.идент == Id.startaddress)
        {
            if (!ps.args || ps.args.dim != 1)
                ps.выведиОшибку("function имя expected for start address");
            else
            {
                Выражение e = (*ps.args)[0];
                sc = sc.startCTFE();
                e = e.ВыражениеSemantic(sc);
                e = resolveProperties(sc, e);
                sc = sc.endCTFE();

                e = e.ctfeInterpret();
                (*ps.args)[0] = e;
                ДСимвол sa = getDsymbol(e);
                if (!sa || !sa.isFuncDeclaration())
                {
                    ps.выведиОшибку("function имя expected for start address, not `%s`", e.вТкст0());
                    return setError();
                }
                if (ps._body)
                {
                    ps._body = ps._body.statementSemantic(sc);
                    if (ps._body.isErrorStatement())
                    {
                        результат = ps._body;
                        return;
                    }
                }
                результат = ps;
                return;
            }
        }
        else if (ps.идент == Id.Pinline)
        {
            PINLINE inlining = PINLINE.default_;
            if (!ps.args || ps.args.dim == 0)
                inlining = PINLINE.default_;
            else if (!ps.args || ps.args.dim != 1)
            {
                ps.выведиОшибку("булean Выражение expected for `pragma(inline)`");
                return setError();
            }
            else
            {
                Выражение e = (*ps.args)[0];
                if (e.op != ТОК2.int64 || !e.тип.равен(Тип.tбул))
                {
                    ps.выведиОшибку("pragma(inline, да or нет) expected, not `%s`", e.вТкст0());
                    return setError();
                }

                if (e.isBool(да))
                    inlining = PINLINE.always;
                else if (e.isBool(нет))
                    inlining = PINLINE.never;

                    FuncDeclaration fd = sc.func;
                if (!fd)
                {
                    ps.выведиОшибку("`pragma(inline)` is not inside a function");
                    return setError();
                }
                fd.inlining = inlining;
            }
        }
        else if (!глоб2.парамы.ignoreUnsupportedPragmas)
        {
            ps.выведиОшибку("unrecognized `pragma(%s)`", ps.идент.вТкст0());
            return setError();
        }

        if (ps._body)
        {
            if (ps.идент == Id.msg || ps.идент == Id.startaddress)
            {
                ps.выведиОшибку("`pragma(%s)` is missing a terminating `;`", ps.идент.вТкст0());
                return setError();
            }
            ps._body = ps._body.statementSemantic(sc);
        }
        результат = ps._body;
    }

    override проц посети(StaticAssertStatement s)
    {
        s.sa.semantic2(sc);
    }

    override проц посети(SwitchStatement ss)
    {
        /* https://dlang.org/spec/инструкция.html#switch-инструкция
         */

        //printf("SwitchStatement::semantic(%p)\n", ss);
        ss.tryBody = sc.tryBody;
        ss.tf = sc.tf;
        if (ss.cases)
        {
            результат = ss; // already run
            return;
        }

        бул conditionError = нет;
        ss.условие = ss.условие.ВыражениеSemantic(sc);
        ss.условие = resolveProperties(sc, ss.условие);

        Тип att = null;
        TypeEnum te = null;
        while (ss.условие.op != ТОК2.error)
        {
            // preserve enum тип for final switches
            if (ss.условие.тип.ty == Tenum)
                te = cast(TypeEnum)ss.условие.тип;
            if (ss.условие.тип.isString())
            {
                // If it's not an массив, cast it to one
                if (ss.условие.тип.ty != Tarray)
                {
                    ss.условие = ss.условие.implicitCastTo(sc, ss.условие.тип.nextOf().arrayOf());
                }
                ss.условие.тип = ss.условие.тип.constOf();
                break;
            }
            ss.условие = integralPromotions(ss.условие, sc);
            if (ss.условие.op != ТОК2.error && ss.условие.тип.isintegral())
                break;

            auto ad = isAggregate(ss.условие.тип);
            if (ad && ad.aliasthis && ss.условие.тип != att)
            {
                if (!att && ss.условие.тип.checkAliasThisRec())
                    att = ss.условие.тип;
                if (auto e = resolveAliasThis(sc, ss.условие, да))
                {
                    ss.условие = e;
                    continue;
                }
            }

            if (ss.условие.op != ТОК2.error)
            {
                ss.выведиОшибку("`%s` must be of integral or ткст тип, it is a `%s`",
                    ss.условие.вТкст0(), ss.условие.тип.вТкст0());
                conditionError = да;
                break;
            }
        }
        if (checkNonAssignmentArrayOp(ss.условие))
            ss.условие = new ErrorExp();
        ss.условие = ss.условие.optimize(WANTvalue);
        ss.условие = checkGC(sc, ss.условие);
        if (ss.условие.op == ТОК2.error)
            conditionError = да;

        бул needswitcherror = нет;

        ss.lastVar = sc.lastVar;

        sc = sc.сунь();
        sc.sbreak = ss;
        sc.sw = ss;

        ss.cases = new CaseStatements();
        const inLoopSave = sc.inLoop;
        sc.inLoop = да;        // BUG: should use Scope::mergeCallSuper() for each case instead
        ss._body = ss._body.statementSemantic(sc);
        sc.inLoop = inLoopSave;

        if (conditionError || (ss._body && ss._body.isErrorStatement()))
        {
            sc.вынь();
            return setError();
        }

        // Resolve any goto case's with exp
      Lgotocase:
        foreach (gcs; ss.gotoCases)
        {
            if (!gcs.exp)
            {
                gcs.выведиОшибку("no `case` инструкция following `goto case;`");
                sc.вынь();
                return setError();
            }

            for (Scope* scx = sc; scx; scx = scx.enclosing)
            {
                if (!scx.sw)
                    continue;
                foreach (cs; *scx.sw.cases)
                {
                    if (cs.exp.равен(gcs.exp))
                    {
                        gcs.cs = cs;
                        continue Lgotocase;
                    }
                }
            }
            gcs.выведиОшибку("`case %s` not found", gcs.exp.вТкст0());
            sc.вынь();
            return setError();
        }

        if (ss.isFinal)
        {
            Тип t = ss.условие.тип;
            ДСимвол ds;
            EnumDeclaration ed = null;
            if (t && ((ds = t.toDsymbol(sc)) !is null))
                ed = ds.isEnumDeclaration(); // typedef'ed enum
            if (!ed && te && ((ds = te.toDsymbol(sc)) !is null))
                ed = ds.isEnumDeclaration();
            if (ed)
            {
              Lmembers:
                foreach (es; *ed.члены)
                {
                    EnumMember em = es.isEnumMember();
                    if (em)
                    {
                        foreach (cs; *ss.cases)
                        {
                            if (cs.exp.равен(em.значение) || (!cs.exp.тип.isString() && !em.значение.тип.isString() && cs.exp.toInteger() == em.значение.toInteger()))
                                continue Lmembers;
                        }
                        ss.выведиОшибку("`enum` member `%s` not represented in `switch`", em.вТкст0());
                        sc.вынь();
                        return setError();
                    }
                }
            }
            else
                needswitcherror = да;
        }

        if (!sc.sw.sdefault && (!ss.isFinal || needswitcherror || глоб2.парамы.useAssert == CHECKENABLE.on))
        {
            ss.hasNoDefault = 1;

            if (!ss.isFinal && (!ss._body || !ss._body.isErrorStatement()))
                ss.выведиОшибку("`switch` инструкция without a `default`; use `switch` or add `default: assert(0);` or add `default: break;`");

            // Generate runtime error if the default is hit
            auto a = new Инструкции();
            CompoundStatement cs;
            Инструкция2 s;

            if (глоб2.парамы.useSwitchError == CHECKENABLE.on &&
                глоб2.парамы.checkAction != CHECKACTION.halt)
            {
                if (глоб2.парамы.checkAction == CHECKACTION.C)
                {
                    /* Rewrite as an assert(0) and let e2ir generate
                     * the call to the C assert failure function
                     */
                    s = new ExpStatement(ss.место, new AssertExp(ss.место, new IntegerExp(ss.место, 0, Тип.tint32)));
                }
                else
                {
                    if (!verifyHookExist(ss.место, *sc, Id.__switch_error, "generating assert messages"))
                        return setError();

                    Выражение sl = new IdentifierExp(ss.место, Id.empty);
                    sl = new DotIdExp(ss.место, sl, Id.объект);
                    sl = new DotIdExp(ss.место, sl, Id.__switch_error);

                    Выражения* args = new Выражения(2);
                    (*args)[0] = new StringExp(ss.место, ss.место.имяф.вТкстД());
                    (*args)[1] = new IntegerExp(ss.место.номстр);

                    sl = new CallExp(ss.место, sl, args);
                    sl.ВыражениеSemantic(sc);

                    s = new SwitchErrorStatement(ss.место, sl);
                }
            }
            else
                s = new ExpStatement(ss.место, new HaltExp(ss.место));

            a.резервируй(2);
            sc.sw.sdefault = new DefaultStatement(ss.место, s);
            a.сунь(ss._body);
            if (ss._body.blockExit(sc.func, нет) & BE.fallthru)
                a.сунь(new BreakStatement(Место.initial, null));
            a.сунь(sc.sw.sdefault);
            cs = new CompoundStatement(ss.место, a);
            ss._body = cs;
        }

        if (ss.checkLabel())
        {
            sc.вынь();
            return setError();
        }


        if (ss.условие.тип.isString())
        {
            // Transform a switch with ткст labels into a switch with integer labels.

            // The integer значение of each case corresponds to the index of each label
            // ткст in the sorted массив of label strings.

            // The значение of the integer условие is obtained by calling the druntime template
            // switch(объект.__switch(cond, опции...)) {0: {...}, 1: {...}, ...}

            // We sort a копируй of the массив of labels because we want to do a binary search in объект.__switch,
            // without modifying the order of the case blocks here in the compiler.

            if (!verifyHookExist(ss.место, *sc, Id.__switch, "switch cases on strings"))
                return setError();

            т_мера numcases = 0;
            if (ss.cases)
                numcases = ss.cases.dim;

            for (т_мера i = 0; i < numcases; i++)
            {
                CaseStatement cs = (*ss.cases)[i];
                cs.index = cast(цел)i;
            }

            // Make a копируй of all the cases so that qsort doesn't scramble the actual
            // данные we pass to codegen (the order of the cases in the switch).
            CaseStatements *csCopy = (*ss.cases).копируй();

            if (numcases)
            {
                extern (C) static цел sort_compare(ук x, ук y)
                {
                    CaseStatement ox = *cast(CaseStatement *)x;
                    CaseStatement oy = *cast(CaseStatement*)y;

                    auto se1 = ox.exp.isStringExp();
                    auto se2 = oy.exp.isStringExp();
                    return (se1 && se2) ? se1.compare(se2) : 0;
                }

                // Sort cases for efficient lookup
                
                qsort((*csCopy)[].ptr, numcases, CaseStatement.sizeof, cast(_compare_fp_t)&sort_compare);
            }

            // The actual lowering
            auto arguments = new Выражения();
            arguments.сунь(ss.условие);

            auto compileTimeArgs = new Объекты();

            // The тип & label no.
            compileTimeArgs.сунь(new TypeExp(ss.место, ss.условие.тип.nextOf()));

            // The switch labels
            foreach (caseString; *csCopy)
            {
                compileTimeArgs.сунь(caseString.exp);
            }

            Выражение sl = new IdentifierExp(ss.место, Id.empty);
            sl = new DotIdExp(ss.место, sl, Id.объект);
            sl = new DotTemplateInstanceExp(ss.место, sl, Id.__switch, compileTimeArgs);

            sl = new CallExp(ss.место, sl, arguments);
            sl.ВыражениеSemantic(sc);
            ss.условие = sl;

            auto i = 0;
            foreach (c; *csCopy)
            {
                (*ss.cases)[c.index].exp = new IntegerExp(i++);
            }

            //printf("%s\n", ss._body.вТкст0());
            ss.statementSemantic(sc);
        }

        sc.вынь();
        результат = ss;
    }

    override проц посети(CaseStatement cs)
    {
        SwitchStatement sw = sc.sw;
        бул errors = нет;

        //printf("CaseStatement::semantic() %s\n", вТкст0());
        sc = sc.startCTFE();
        cs.exp = cs.exp.ВыражениеSemantic(sc);
        cs.exp = resolveProperties(sc, cs.exp);
        sc = sc.endCTFE();

        if (sw)
        {
            cs.exp = cs.exp.implicitCastTo(sc, sw.условие.тип);
            cs.exp = cs.exp.optimize(WANTvalue | WANTexpand);

            Выражение e = cs.exp;
            // Remove all the casts the user and/or implicitCastTo may introduce
            // otherwise we'd sometimes fail the check below.
            while (e.op == ТОК2.cast_)
                e = (cast(CastExp)e).e1;

            /* This is where variables are allowed as case Выражения.
             */
            if (e.op == ТОК2.variable)
            {
                VarExp ve = cast(VarExp)e;
                VarDeclaration v = ve.var.isVarDeclaration();
                Тип t = cs.exp.тип.toBasetype();
                if (v && (t.isintegral() || t.ty == Tclass))
                {
                    /* Flag that we need to do special code generation
                     * for this, i.e. generate a sequence of if-then-else
                     */
                    sw.hasVars = 1;

                    /* TODO check if v can be uninitialized at that point.
                     */
                    if (!v.isConst() && !v.isImmutable())
                    {
                        cs.deprecation("`case` variables have to be `const` or `const`");
                    }

                    if (sw.isFinal)
                    {
                        cs.выведиОшибку("`case` variables not allowed in `switch` statements");
                        errors = да;
                    }

                    /* Find the outermost scope `scx` that set `sw`.
                     * Then search scope `scx` for a declaration of `v`.
                     */
                    for (Scope* scx = sc; scx; scx = scx.enclosing)
                    {
                        if (scx.enclosing && scx.enclosing.sw == sw)
                            continue;
                        assert(scx.sw == sw);

                        if (!scx.search(cs.exp.место, v.идент, null))
                        {
                            cs.выведиОшибку("`case` variable `%s` declared at %s cannot be declared in `switch` body",
                                v.вТкст0(), v.место.вТкст0());
                            errors = да;
                        }
                        break;
                    }
                    goto L1;
                }
            }
            else
                cs.exp = cs.exp.ctfeInterpret();

            if (StringExp se = cs.exp.вТкстExp())
                cs.exp = se;
            else if (cs.exp.op != ТОК2.int64 && cs.exp.op != ТОК2.error)
            {
                cs.выведиОшибку("`case` must be a `ткст` or an integral constant, not `%s`", cs.exp.вТкст0());
                errors = да;
            }

        L1:
            foreach (cs2; *sw.cases)
            {
                //printf("comparing '%s' with '%s'\n", exp.вТкст0(), cs.exp.вТкст0());
                if (cs2.exp.равен(cs.exp))
                {
                    cs.выведиОшибку("duplicate `case %s` in `switch` инструкция", cs.exp.вТкст0());
                    errors = да;
                    break;
                }
            }

            sw.cases.сунь(cs);

            // Resolve any goto case's with no exp to this case инструкция
            for (т_мера i = 0; i < sw.gotoCases.dim;)
            {
                GotoCaseStatement gcs = sw.gotoCases[i];
                if (!gcs.exp)
                {
                    gcs.cs = cs;
                    sw.gotoCases.удали(i); // удали from массив
                    continue;
                }
                i++;
            }

            if (sc.sw.tf != sc.tf)
            {
                cs.выведиОшибку("`switch` and `case` are in different `finally` blocks");
                errors = да;
            }
            if (sc.sw.tryBody != sc.tryBody)
            {
                cs.выведиОшибку("case cannot be in different `try` block уровень from `switch`");
                errors = да;
            }
        }
        else
        {
            cs.выведиОшибку("`case` not in `switch` инструкция");
            errors = да;
        }

        sc.ctorflow.orCSX(CSX.label);
        cs.инструкция = cs.инструкция.statementSemantic(sc);
        if (cs.инструкция.isErrorStatement())
        {
            результат = cs.инструкция;
            return;
        }
        if (errors || cs.exp.op == ТОК2.error)
            return setError();

        cs.lastVar = sc.lastVar;
        результат = cs;
    }

    override проц посети(CaseRangeStatement crs)
    {
        SwitchStatement sw = sc.sw;
        if (sw is null)
        {
            crs.выведиОшибку("case range not in `switch` инструкция");
            return setError();
        }

        //printf("CaseRangeStatement::semantic() %s\n", вТкст0());
        бул errors = нет;
        if (sw.isFinal)
        {
            crs.выведиОшибку("case ranges not allowed in `switch`");
            errors = да;
        }

        sc = sc.startCTFE();
        crs.first = crs.first.ВыражениеSemantic(sc);
        crs.first = resolveProperties(sc, crs.first);
        sc = sc.endCTFE();
        crs.first = crs.first.implicitCastTo(sc, sw.условие.тип);
        crs.first = crs.first.ctfeInterpret();

        sc = sc.startCTFE();
        crs.last = crs.last.ВыражениеSemantic(sc);
        crs.last = resolveProperties(sc, crs.last);
        sc = sc.endCTFE();
        crs.last = crs.last.implicitCastTo(sc, sw.условие.тип);
        crs.last = crs.last.ctfeInterpret();

        if (crs.first.op == ТОК2.error || crs.last.op == ТОК2.error || errors)
        {
            if (crs.инструкция)
                crs.инструкция.statementSemantic(sc);
            return setError();
        }

        uinteger_t fval = crs.first.toInteger();
        uinteger_t lval = crs.last.toInteger();
        if ((crs.first.тип.isunsigned() && fval > lval) || (!crs.first.тип.isunsigned() && cast(sinteger_t)fval > cast(sinteger_t)lval))
        {
            crs.выведиОшибку("first `case %s` is greater than last `case %s`", crs.first.вТкст0(), crs.last.вТкст0());
            errors = да;
            lval = fval;
        }

        if (lval - fval > 256)
        {
            crs.выведиОшибку("had %llu cases which is more than 256 cases in case range", lval - fval);
            errors = да;
            lval = fval + 256;
        }

        if (errors)
            return setError();

        /* This works by replacing the CaseRange with an массив of Case's.
         *
         * case a: .. case b: s;
         *    =>
         * case a:
         *   [...]
         * case b:
         *   s;
         */

        auto statements = new Инструкции();
        for (uinteger_t i = fval; i != lval + 1; i++)
        {
            Инструкция2 s = crs.инструкция;
            if (i != lval) // if not last case
                s = new ExpStatement(crs.место, cast(Выражение)null);
            Выражение e = new IntegerExp(crs.место, i, crs.first.тип);
            Инструкция2 cs = new CaseStatement(crs.место, e, s);
            statements.сунь(cs);
        }
        Инструкция2 s = new CompoundStatement(crs.место, statements);
        sc.ctorflow.orCSX(CSX.label);
        s = s.statementSemantic(sc);
        результат = s;
    }

    override проц посети(DefaultStatement ds)
    {
        //printf("DefaultStatement::semantic()\n");
        бул errors = нет;
        if (sc.sw)
        {
            if (sc.sw.sdefault)
            {
                ds.выведиОшибку("`switch` инструкция already has a default");
                errors = да;
            }
            sc.sw.sdefault = ds;

            if (sc.sw.tf != sc.tf)
            {
                ds.выведиОшибку("`switch` and `default` are in different `finally` blocks");
                errors = да;
            }
            if (sc.sw.tryBody != sc.tryBody)
            {
                ds.выведиОшибку("default cannot be in different `try` block уровень from `switch`");
                errors = да;
            }
            if (sc.sw.isFinal)
            {
                ds.выведиОшибку("`default` инструкция not allowed in `switch` инструкция");
                errors = да;
            }
        }
        else
        {
            ds.выведиОшибку("`default` not in `switch` инструкция");
            errors = да;
        }

        sc.ctorflow.orCSX(CSX.label);
        ds.инструкция = ds.инструкция.statementSemantic(sc);
        if (errors || ds.инструкция.isErrorStatement())
            return setError();

        ds.lastVar = sc.lastVar;
        результат = ds;
    }

    override проц посети(GotoDefaultStatement gds)
    {
        /* https://dlang.org/spec/инструкция.html#goto-инструкция
         */

        gds.sw = sc.sw;
        if (!gds.sw)
        {
            gds.выведиОшибку("`goto default` not in `switch` инструкция");
            return setError();
        }
        if (gds.sw.isFinal)
        {
            gds.выведиОшибку("`goto default` not allowed in `switch` инструкция");
            return setError();
        }
        результат = gds;
    }

    override проц посети(GotoCaseStatement gcs)
    {
        /* https://dlang.org/spec/инструкция.html#goto-инструкция
         */

        if (!sc.sw)
        {
            gcs.выведиОшибку("`goto case` not in `switch` инструкция");
            return setError();
        }

        if (gcs.exp)
        {
            gcs.exp = gcs.exp.ВыражениеSemantic(sc);
            gcs.exp = gcs.exp.implicitCastTo(sc, sc.sw.условие.тип);
            gcs.exp = gcs.exp.optimize(WANTvalue);
            if (gcs.exp.op == ТОК2.error)
                return setError();
        }

        sc.sw.gotoCases.сунь(gcs);
        результат = gcs;
    }

    override проц посети(ReturnStatement rs)
    {
        /* https://dlang.org/spec/инструкция.html#return-инструкция
         */

        //printf("ReturnStatement.dsymbolSemantic() %p, %s\n", rs, rs.вТкст0());

        FuncDeclaration fd = sc.родитель.isFuncDeclaration();
        if (fd.fes)
            fd = fd.fes.func; // fd is now function enclosing foreach

            TypeFunction tf = cast(TypeFunction)fd.тип;
        assert(tf.ty == Tfunction);

        if (rs.exp && rs.exp.op == ТОК2.variable && (cast(VarExp)rs.exp).var == fd.vрезультат)
        {
            // return vрезультат;
            if (sc.fes)
            {
                assert(rs.caseDim == 0);
                sc.fes.cases.сунь(rs);
                результат = new ReturnStatement(Место.initial, new IntegerExp(sc.fes.cases.dim + 1));
                return;
            }
            if (fd.returnLabel)
            {
                auto gs = new GotoStatement(rs.место, Id.returnLabel);
                gs.label = fd.returnLabel;
                результат = gs;
                return;
            }

            if (!fd.returns)
                fd.returns = new ReturnStatements();
            fd.returns.сунь(rs);
            результат = rs;
            return;
        }

        Тип tret = tf.следщ;
        Тип tbret = tret ? tret.toBasetype() : null;

        бул inferRef = (tf.isref && (fd.класс_хранения & STC.auto_));
        Выражение e0 = null;

        бул errors = нет;
        if (sc.flags & SCOPE.contract)
        {
            rs.выведиОшибку("`return` statements cannot be in contracts");
            errors = да;
        }
        if (sc.ос && sc.ос.tok != ТОК2.onScopeFailure)
        {
            rs.выведиОшибку("`return` statements cannot be in `%s` bodies", Сема2.вТкст0(sc.ос.tok));
            errors = да;
        }
        if (sc.tf)
        {
            rs.выведиОшибку("`return` statements cannot be in `finally` bodies");
            errors = да;
        }

        if (fd.isCtorDeclaration())
        {
            if (rs.exp)
            {
                rs.выведиОшибку("cannot return Выражение from constructor");
                errors = да;
            }

            // Constructors implicitly do:
            //      return this;
            rs.exp = new ThisExp(Место.initial);
            rs.exp.тип = tret;
        }
        else if (rs.exp)
        {
            fd.hasReturnExp |= (fd.hasReturnExp & 1 ? 16 : 1);

            FuncLiteralDeclaration fld = fd.isFuncLiteralDeclaration();
            if (tret)
                rs.exp = inferType(rs.exp, tret);
            else if (fld && fld.treq)
                rs.exp = inferType(rs.exp, fld.treq.nextOf().nextOf());

            rs.exp = rs.exp.ВыражениеSemantic(sc);
            rs.exp.checkSharedAccess(sc);

            // for static alias this: https://issues.dlang.org/show_bug.cgi?ид=17684
            if (rs.exp.op == ТОК2.тип)
                rs.exp = resolveAliasThis(sc, rs.exp);

            rs.exp = resolveProperties(sc, rs.exp);
            if (rs.exp.checkType())
                rs.exp = new ErrorExp();
            if (auto f = isFuncAddress(rs.exp))
            {
                if (fd.inferRetType && f.checkForwardRef(rs.exp.место))
                    rs.exp = new ErrorExp();
            }
            if (checkNonAssignmentArrayOp(rs.exp))
                rs.exp = new ErrorExp();

            // Extract side-effect part
            rs.exp = Выражение.extractLast(rs.exp, e0);
            if (rs.exp.op == ТОК2.call)
                rs.exp = valueNoDtor(rs.exp);

            if (e0)
                e0 = e0.optimize(WANTvalue);

            /* Void-return function can have проц typed Выражение
             * on return инструкция.
             */
            if (tbret && tbret.ty == Tvoid || rs.exp.тип.ty == Tvoid)
            {
                if (rs.exp.тип.ty != Tvoid)
                {
                    rs.выведиОшибку("cannot return non-проц from `проц` function");
                    errors = да;
                    rs.exp = new CastExp(rs.место, rs.exp, Тип.tvoid);
                    rs.exp = rs.exp.ВыражениеSemantic(sc);
                }

                /* Replace:
                 *      return exp;
                 * with:
                 *      exp; return;
                 */
                e0 = Выражение.combine(e0, rs.exp);
                rs.exp = null;
            }
            if (e0)
                e0 = checkGC(sc, e0);
        }

        if (rs.exp)
        {
            if (fd.inferRetType) // infer return тип
            {
                if (!tret)
                {
                    tf.следщ = rs.exp.тип;
                }
                else if (tret.ty != Terror && !rs.exp.тип.равен(tret))
                {
                    цел m1 = rs.exp.тип.implicitConvTo(tret);
                    цел m2 = tret.implicitConvTo(rs.exp.тип);
                    //printf("exp.тип = %s m2<-->m1 tret %s\n", exp.тип.вТкст0(), tret.вТкст0());
                    //printf("m1 = %d, m2 = %d\n", m1, m2);

                    if (m1 && m2)
                    {
                    }
                    else if (!m1 && m2)
                        tf.следщ = rs.exp.тип;
                    else if (m1 && !m2)
                    {
                    }
                    else if (rs.exp.op != ТОК2.error)
                    {
                        rs.выведиОшибку("Expected return тип of `%s`, not `%s`:",
                                 tret.вТкст0(),
                                 rs.exp.тип.вТкст0());
                        errorSupplemental((fd.returns) ? (*fd.returns)[0].место : fd.место,
                                          "Return тип of `%s` inferred here.",
                                          tret.вТкст0());

                        errors = да;
                        tf.следщ = Тип.terror;
                    }
                }

                tret = tf.следщ;
                tbret = tret.toBasetype();
            }

            if (inferRef) // deduce 'auto ref'
            {
                /* Determine "refness" of function return:
                 * if it's an lvalue, return by ref, else return by значение
                 * https://dlang.org/spec/function.html#auto-ref-functions
                 */

                проц turnOffRef()
                {
                    tf.isref = нет;    // return by значение
                    tf.isreturn = нет; // ignore 'return' attribute, whether explicit or inferred
                    fd.класс_хранения &= ~STC.return_;
                }

                if (rs.exp.isLvalue())
                {
                    /* May return by ref
                     */
                    if (checkReturnEscapeRef(sc, rs.exp, да))
                        turnOffRef();
                    else if (!rs.exp.тип.constConv(tf.следщ))
                        turnOffRef();
                }
                else
                    turnOffRef();

                /* The "refness" is determined by all of return statements.
                 * This means:
                 *    return 3; return x;  // ok, x can be a значение
                 *    return x; return 3;  // ok, x can be a значение
                 */
            }
        }
        else
        {
            // infer return тип
            if (fd.inferRetType)
            {
                if (tf.следщ && tf.следщ.ty != Tvoid)
                {
                    if (tf.следщ.ty != Terror)
                    {
                        rs.выведиОшибку("mismatched function return тип inference of `проц` and `%s`", tf.следщ.вТкст0());
                    }
                    errors = да;
                    tf.следщ = Тип.terror;
                }
                else
                    tf.следщ = Тип.tvoid;

                    tret = tf.следщ;
                tbret = tret.toBasetype();
            }

            if (inferRef) // deduce 'auto ref'
                tf.isref = нет;

            if (tbret.ty != Tvoid) // if non-проц return
            {
                if (tbret.ty != Terror)
                    rs.выведиОшибку("`return` Выражение expected");
                errors = да;
            }
            else if (fd.isMain())
            {
                // main() returns 0, even if it returns проц
                rs.exp = IntegerExp.literal!(0);
            }
        }

        // If any branches have called a ctor, but this branch hasn't, it's an error
        if (sc.ctorflow.callSuper & CSX.any_ctor && !(sc.ctorflow.callSuper & (CSX.this_ctor | CSX.super_ctor)))
        {
            rs.выведиОшибку("`return` without calling constructor");
            errors = да;
        }

        if (sc.ctorflow.fieldinit.length)       // if aggregate fields are being constructed
        {
            auto ad = fd.isMemberLocal();
            assert(ad);
            foreach (i, v; ad.fields)
            {
                бул mustInit = (v.класс_хранения & STC.nodefaultctor || v.тип.needsNested());
                if (mustInit && !(sc.ctorflow.fieldinit[i].csx & CSX.this_ctor))
                {
                    rs.выведиОшибку("an earlier `return` инструкция skips field `%s` initialization", v.вТкст0());
                    errors = да;
                }
            }
        }
        sc.ctorflow.orCSX(CSX.return_);

        if (errors)
            return setError();

        if (sc.fes)
        {
            if (!rs.exp)
            {
                // Send out "case receiver" инструкция to the foreach.
                //  return exp;
                Инструкция2 s = new ReturnStatement(Место.initial, rs.exp);
                sc.fes.cases.сунь(s);

                // Immediately rewrite "this" return инструкция as:
                //  return cases.dim+1;
                rs.exp = new IntegerExp(sc.fes.cases.dim + 1);
                if (e0)
                {
                    результат = new CompoundStatement(rs.место, new ExpStatement(rs.место, e0), rs);
                    return;
                }
                результат = rs;
                return;
            }
            else
            {
                fd.buildрезультатVar(null, rs.exp.тип);
                бул r = fd.vрезультат.checkNestedReference(sc, Место.initial);
                assert(!r); // vрезультат should be always accessible

                // Send out "case receiver" инструкция to the foreach.
                //  return vрезультат;
                Инструкция2 s = new ReturnStatement(Место.initial, new VarExp(Место.initial, fd.vрезультат));
                sc.fes.cases.сунь(s);

                // Save receiver index for the later rewriting from:
                //  return exp;
                // to:
                //  vрезультат = exp; retrun caseDim;
                rs.caseDim = sc.fes.cases.dim + 1;
            }
        }
        if (rs.exp)
        {
            if (!fd.returns)
                fd.returns = new ReturnStatements();
            fd.returns.сунь(rs);
        }
        if (e0)
        {
            if (e0.op == ТОК2.declaration || e0.op == ТОК2.comma)
            {
                rs.exp = Выражение.combine(e0, rs.exp);
            }
            else
            {
                результат = new CompoundStatement(rs.место, new ExpStatement(rs.место, e0), rs);
                return;
            }
        }
        результат = rs;
    }

    override проц посети(BreakStatement bs)
    {
        /* https://dlang.org/spec/инструкция.html#break-инструкция
         */

        //printf("BreakStatement::semantic()\n");

        // If:
        //  break Идентификатор2;
        if (bs.идент)
        {
            bs.идент = fixupLabelName(sc, bs.идент);

            FuncDeclaration thisfunc = sc.func;

            for (Scope* scx = sc; scx; scx = scx.enclosing)
            {
                if (scx.func != thisfunc) // if in enclosing function
                {
                    if (sc.fes) // if this is the body of a foreach
                    {
                        /* Post this инструкция to the fes, and replace
                         * it with a return значение that caller will put into
                         * a switch. Caller will figure out where the break
                         * label actually is.
                         * Case numbers start with 2, not 0, as 0 is continue
                         * and 1 is break.
                         */
                        sc.fes.cases.сунь(bs);
                        результат = new ReturnStatement(Место.initial, new IntegerExp(sc.fes.cases.dim + 1));
                        return;
                    }
                    break; // can't break to it
                }

                LabelStatement ls = scx.slabel;
                if (ls && ls.идент == bs.идент)
                {
                    Инструкция2 s = ls.инструкция;
                    if (!s || !s.hasBreak())
                        bs.выведиОшибку("label `%s` has no `break`", bs.идент.вТкст0());
                    else if (ls.tf != sc.tf)
                        bs.выведиОшибку("cannot break out of `finally` block");
                    else
                    {
                        ls.breaks = да;
                        результат = bs;
                        return;
                    }
                    return setError();
                }
            }
            bs.выведиОшибку("enclosing label `%s` for `break` not found", bs.идент.вТкст0());
            return setError();
        }
        else if (!sc.sbreak)
        {
            if (sc.ос && sc.ос.tok != ТОК2.onScopeFailure)
            {
                bs.выведиОшибку("`break` is not inside `%s` bodies", Сема2.вТкст0(sc.ос.tok));
            }
            else if (sc.fes)
            {
                // Replace break; with return 1;
                результат = new ReturnStatement(Место.initial, IntegerExp.literal!(1));
                return;
            }
            else
                bs.выведиОшибку("`break` is not inside a loop or `switch`");
            return setError();
        }
        else if (sc.sbreak.isForwardingStatement())
        {
            bs.выведиОшибку("must use labeled `break` within `static foreach`");
        }
        результат = bs;
    }

    override проц посети(ContinueStatement cs)
    {
        /* https://dlang.org/spec/инструкция.html#continue-инструкция
         */

        //printf("ContinueStatement::semantic() %p\n", cs);
        if (cs.идент)
        {
            cs.идент = fixupLabelName(sc, cs.идент);

            Scope* scx;
            FuncDeclaration thisfunc = sc.func;

            for (scx = sc; scx; scx = scx.enclosing)
            {
                LabelStatement ls;
                if (scx.func != thisfunc) // if in enclosing function
                {
                    if (sc.fes) // if this is the body of a foreach
                    {
                        for (; scx; scx = scx.enclosing)
                        {
                            ls = scx.slabel;
                            if (ls && ls.идент == cs.идент && ls.инструкция == sc.fes)
                            {
                                // Replace continue идент; with return 0;
                                результат = new ReturnStatement(Место.initial, IntegerExp.literal!(0));
                                return;
                            }
                        }

                        /* Post this инструкция to the fes, and replace
                         * it with a return значение that caller will put into
                         * a switch. Caller will figure out where the break
                         * label actually is.
                         * Case numbers start with 2, not 0, as 0 is continue
                         * and 1 is break.
                         */
                        sc.fes.cases.сунь(cs);
                        результат = new ReturnStatement(Место.initial, new IntegerExp(sc.fes.cases.dim + 1));
                        return;
                    }
                    break; // can't continue to it
                }

                ls = scx.slabel;
                if (ls && ls.идент == cs.идент)
                {
                    Инструкция2 s = ls.инструкция;
                    if (!s || !s.hasContinue())
                        cs.выведиОшибку("label `%s` has no `continue`", cs.идент.вТкст0());
                    else if (ls.tf != sc.tf)
                        cs.выведиОшибку("cannot continue out of `finally` block");
                    else
                    {
                        результат = cs;
                        return;
                    }
                    return setError();
                }
            }
            cs.выведиОшибку("enclosing label `%s` for `continue` not found", cs.идент.вТкст0());
            return setError();
        }
        else if (!sc.scontinue)
        {
            if (sc.ос && sc.ос.tok != ТОК2.onScopeFailure)
            {
                cs.выведиОшибку("`continue` is not inside `%s` bodies", Сема2.вТкст0(sc.ос.tok));
            }
            else if (sc.fes)
            {
                // Replace continue; with return 0;
                результат = new ReturnStatement(Место.initial, IntegerExp.literal!(0));
                return;
            }
            else
                cs.выведиОшибку("`continue` is not inside a loop");
            return setError();
        }
        else if (sc.scontinue.isForwardingStatement())
        {
            cs.выведиОшибку("must use labeled `continue` within `static foreach`");
        }
        результат = cs;
    }

    override проц посети(SynchronizedStatement ss)
    {
        /* https://dlang.org/spec/инструкция.html#synchronized-инструкция
         */

        if (ss.exp)
        {
            ss.exp = ss.exp.ВыражениеSemantic(sc);
            ss.exp = resolveProperties(sc, ss.exp);
            ss.exp = ss.exp.optimize(WANTvalue);
            ss.exp = checkGC(sc, ss.exp);
            if (ss.exp.op == ТОК2.error)
            {
                if (ss._body)
                    ss._body = ss._body.statementSemantic(sc);
                return setError();
            }

            ClassDeclaration cd = ss.exp.тип.isClassHandle();
            if (!cd)
            {
                ss.выведиОшибку("can only `synchronize` on class objects, not `%s`", ss.exp.тип.вТкст0());
                return setError();
            }
            else if (cd.isInterfaceDeclaration())
            {
                /* Cast the interface to an объект, as the объект has the monitor,
                 * not the interface.
                 */
                if (!ClassDeclaration.объект)
                {
                    ss.выведиОшибку("missing or corrupt объект.d");
                    fatal();
                }

                Тип t = ClassDeclaration.объект.тип;
                t = t.typeSemantic(Место.initial, sc).toBasetype();
                assert(t.ty == Tclass);

                ss.exp = new CastExp(ss.место, ss.exp, t);
                ss.exp = ss.exp.ВыражениеSemantic(sc);
            }
            version (all)
            {
                /* Rewrite as:
                 *  auto tmp = exp;
                 *  _d_monitorenter(tmp);
                 *  try { body } finally { _d_monitorexit(tmp); }
                 */
                auto tmp = copyToTemp(0, "__sync", ss.exp);
                tmp.dsymbolSemantic(sc);

                auto cs = new Инструкции();
                cs.сунь(new ExpStatement(ss.место, tmp));

                auto args = new Параметры();
                args.сунь(new Параметр2(0, ClassDeclaration.объект.тип, null, null, null));

                FuncDeclaration fdenter = FuncDeclaration.genCfunc(args, Тип.tvoid, Id.monitorenter);
                Выражение e = new CallExp(ss.место, fdenter, new VarExp(ss.место, tmp));
                e.тип = Тип.tvoid; // do not run semantic on e

                cs.сунь(new ExpStatement(ss.место, e));
                FuncDeclaration fdexit = FuncDeclaration.genCfunc(args, Тип.tvoid, Id.monitorexit);
                e = new CallExp(ss.место, fdexit, new VarExp(ss.место, tmp));
                e.тип = Тип.tvoid; // do not run semantic on e
                Инструкция2 s = new ExpStatement(ss.место, e);
                s = new TryFinallyStatement(ss.место, ss._body, s);
                cs.сунь(s);

                s = new CompoundStatement(ss.место, cs);
                результат = s.statementSemantic(sc);
            }
        }
        else
        {
            /* Generate our own critical section, then rewrite as:
             *  static shared align(D_CRITICAL_SECTION.alignof) byte[D_CRITICAL_SECTION.sizeof] __critsec;
             *  _d_criticalenter(&__critsec[0]);
             *  try { body } finally { _d_criticalexit(&__critsec[0]); }
             */
            auto ид = Идентификатор2.генерируйИд("__critsec");
            auto t = Тип.tint8.sarrayOf(target.ptrsize + target.critsecsize());
            auto tmp = new VarDeclaration(ss.место, t, ид, null);
            tmp.класс_хранения |= STC.temp | STC.shared_ | STC.static_;
            Выражение tmpExp = new VarExp(ss.место, tmp);

            auto cs = new Инструкции();
            cs.сунь(new ExpStatement(ss.место, tmp));

            /* This is just a dummy variable for "goto skips declaration" error.
             * Backend optimizer could удали this unused variable.
             */
            auto v = new VarDeclaration(ss.место, Тип.tvoidptr, Идентификатор2.генерируйИд("__sync"), null);
            v.dsymbolSemantic(sc);
            cs.сунь(new ExpStatement(ss.место, v));

            auto args = new Параметры();
            args.сунь(new Параметр2(0, t.pointerTo(), null, null, null));

            FuncDeclaration fdenter = FuncDeclaration.genCfunc(args, Тип.tvoid, Id.criticalenter, STC.nothrow_);
            Выражение int0 = new IntegerExp(ss.место, dinteger_t(0), Тип.tint8);
            Выражение e = new AddrExp(ss.место, new IndexExp(ss.место, tmpExp, int0));
            e = e.ВыражениеSemantic(sc);
            e = new CallExp(ss.место, fdenter, e);
            e.тип = Тип.tvoid; // do not run semantic on e
            cs.сунь(new ExpStatement(ss.место, e));

            FuncDeclaration fdexit = FuncDeclaration.genCfunc(args, Тип.tvoid, Id.criticalexit, STC.nothrow_);
            e = new AddrExp(ss.место, new IndexExp(ss.место, tmpExp, int0));
            e = e.ВыражениеSemantic(sc);
            e = new CallExp(ss.место, fdexit, e);
            e.тип = Тип.tvoid; // do not run semantic on e
            Инструкция2 s = new ExpStatement(ss.место, e);
            s = new TryFinallyStatement(ss.место, ss._body, s);
            cs.сунь(s);

            s = new CompoundStatement(ss.место, cs);
            результат = s.statementSemantic(sc);

            // set the explicit __critsec alignment after semantic()
            tmp.alignment = target.ptrsize;
        }
    }

    override проц посети(WithStatement ws)
    {
        /* https://dlang.org/spec/инструкция.html#with-инструкция
         */

        ScopeDsymbol sym;
        Инициализатор _иниц;

        //printf("WithStatement::semantic()\n");
        ws.exp = ws.exp.ВыражениеSemantic(sc);
        ws.exp = resolveProperties(sc, ws.exp);
        ws.exp = ws.exp.optimize(WANTvalue);
        ws.exp = checkGC(sc, ws.exp);
        if (ws.exp.op == ТОК2.error)
            return setError();
        if (ws.exp.op == ТОК2.scope_)
        {
            sym = new WithScopeSymbol(ws);
            sym.родитель = sc.scopesym;
            sym.endlinnum = ws.endloc.номстр;
        }
        else if (ws.exp.op == ТОК2.тип)
        {
            ДСимвол s = (cast(TypeExp)ws.exp).тип.toDsymbol(sc);
            if (!s || !s.isScopeDsymbol())
            {
                ws.выведиОшибку("`with` тип `%s` has no члены", ws.exp.вТкст0());
                return setError();
            }
            sym = new WithScopeSymbol(ws);
            sym.родитель = sc.scopesym;
            sym.endlinnum = ws.endloc.номстр;
        }
        else
        {
            Тип t = ws.exp.тип.toBasetype();

            Выражение olde = ws.exp;
            if (t.ty == Tpointer)
            {
                ws.exp = new PtrExp(ws.место, ws.exp);
                ws.exp = ws.exp.ВыражениеSemantic(sc);
                t = ws.exp.тип.toBasetype();
            }

            assert(t);
            t = t.toBasetype();
            if (t.isClassHandle())
            {
                _иниц = new ExpInitializer(ws.место, ws.exp);
                ws.wthis = new VarDeclaration(ws.место, ws.exp.тип, Id.withSym, _иниц);
                ws.wthis.dsymbolSemantic(sc);

                sym = new WithScopeSymbol(ws);
                sym.родитель = sc.scopesym;
                sym.endlinnum = ws.endloc.номстр;
            }
            else if (t.ty == Tstruct)
            {
                if (!ws.exp.isLvalue())
                {
                    /* Re-пиши to
                     * {
                     *   auto __withtmp = exp
                     *   with(__withtmp)
                     *   {
                     *     ...
                     *   }
                     * }
                     */
                    auto tmp = copyToTemp(0, "__withtmp", ws.exp);
                    tmp.dsymbolSemantic(sc);
                    auto es = new ExpStatement(ws.место, tmp);
                    ws.exp = new VarExp(ws.место, tmp);
                    Инструкция2 ss = new ScopeStatement(ws.место, new CompoundStatement(ws.место, es, ws), ws.endloc);
                    результат = ss.statementSemantic(sc);
                    return;
                }
                Выражение e = ws.exp.addressOf();
                _иниц = new ExpInitializer(ws.место, e);
                ws.wthis = new VarDeclaration(ws.место, e.тип, Id.withSym, _иниц);
                ws.wthis.dsymbolSemantic(sc);
                sym = new WithScopeSymbol(ws);
                // Need to set the scope to make use of resolveAliasThis
                sym.setScope(sc);
                sym.родитель = sc.scopesym;
                sym.endlinnum = ws.endloc.номстр;
            }
            else
            {
                ws.выведиОшибку("`with` Выражения must be aggregate types or pointers to them, not `%s`", olde.тип.вТкст0());
                return setError();
            }
        }

        if (ws._body)
        {
            sym._scope = sc;
            sc = sc.сунь(sym);
            sc.вставь(sym);
            ws._body = ws._body.statementSemantic(sc);
            sc.вынь();
            if (ws._body && ws._body.isErrorStatement())
            {
                результат = ws._body;
                return;
            }
        }

        результат = ws;
    }

    // https://dlang.org/spec/инструкция.html#TryStatement
    override проц посети(TryCatchStatement tcs)
    {
        //printf("TryCatchStatement.semantic()\n");

        if (!глоб2.парамы.useExceptions)
        {
            tcs.выведиОшибку("Cannot use try-catch statements with -betterC");
            return setError();
        }

        if (!ClassDeclaration.throwable)
        {
            tcs.выведиОшибку("Cannot use try-catch statements because `объект.Throwable` was not declared");
            return setError();
        }

        бцел flags;
        const FLAGcpp = 1;
        const FLAGd = 2;

        tcs.tryBody = sc.tryBody;

        scope sc2 = sc.сунь();
        sc2.tryBody = tcs;
        tcs._body = tcs._body.semanticScope(sc, null, null);
        assert(tcs._body);
        sc2.вынь();

        /* Even if body is empty, still do semantic analysis on catches
         */
        бул catchErrors = нет;
        foreach (i, c; *tcs.catches)
        {
            c.catchSemantic(sc);
            if (c.errors)
            {
                catchErrors = да;
                continue;
            }
            auto cd = c.тип.toBasetype().isClassHandle();
            flags |= cd.isCPPclass() ? FLAGcpp : FLAGd;

            // Determine if current catch 'hides' any previous catches
            foreach (j; new бцел[0 .. i])
            {
                Уловитель cj = (*tcs.catches)[j];
                const si = c.место.вТкст0();
                const sj = cj.место.вТкст0();
                if (c.тип.toBasetype().implicitConvTo(cj.тип.toBasetype()))
                {
                    tcs.выведиОшибку("`catch` at %s hides `catch` at %s", sj, si);
                    catchErrors = да;
                }
            }
        }

        if (sc.func)
        {
            sc.func.flags |= FUNCFLAG.hasCatches;
            if (flags == (FLAGcpp | FLAGd))
            {
                tcs.выведиОшибку("cannot mix catching D and C++ exceptions in the same try-catch");
                catchErrors = да;
            }
        }

        if (catchErrors)
            return setError();

        if (tcs._body.isErrorStatement())
        {
            результат = tcs._body;
            return;
        }

        /* If the try body never throws, we can eliminate any catches
         * of recoverable exceptions.
         */
        if (!(tcs._body.blockExit(sc.func, нет) & BE.throw_) && ClassDeclaration.exception)
        {
            foreach_reverse (i; new бцел[0 .. tcs.catches.dim])
            {
                Уловитель c = (*tcs.catches)[i];

                /* If catch exception тип is derived from Exception
                 */
                if (c.тип.toBasetype().implicitConvTo(ClassDeclaration.exception.тип) &&
                    (!c.handler || !c.handler.comeFrom()))
                {
                    // Remove c from the массив of catches
                    tcs.catches.удали(i);
                }
            }
        }

        if (tcs.catches.dim == 0)
        {
            результат = tcs._body.hasCode() ? tcs._body : null;
            return;
        }

        результат = tcs;
    }

    override проц посети(TryFinallyStatement tfs)
    {
        //printf("TryFinallyStatement::semantic()\n");
        tfs.tryBody = sc.tryBody;

        auto sc2 = sc.сунь();
        sc.tryBody = tfs;
        tfs._body = tfs._body.statementSemantic(sc);
        sc2.вынь();

        sc = sc.сунь();
        sc.tf = tfs;
        sc.sbreak = null;
        sc.scontinue = null; // no break or continue out of finally block
        tfs.finalbody = tfs.finalbody.semanticNoScope(sc);
        sc.вынь();

        if (!tfs._body)
        {
            результат = tfs.finalbody;
            return;
        }
        if (!tfs.finalbody)
        {
            результат = tfs._body;
            return;
        }

        auto blockexit = tfs._body.blockExit(sc.func, нет);

        // if not worrying about exceptions
        if (!(глоб2.парамы.useExceptions && ClassDeclaration.throwable))
            blockexit &= ~BE.throw_;            // don't worry about paths that otherwise may throw

        // Don't care about paths that halt, either
        if ((blockexit & ~BE.halt) == BE.fallthru)
        {
            результат = new CompoundStatement(tfs.место, tfs._body, tfs.finalbody);
            return;
        }
        tfs.bodyFallsThru = (blockexit & BE.fallthru) != 0;
        результат = tfs;
    }

    override проц посети(ScopeGuardStatement oss)
    {
        /* https://dlang.org/spec/инструкция.html#scope-guard-инструкция
         */

        if (oss.tok != ТОК2.onScopeExit)
        {
            // scope(успех) and scope(failure) are rewritten to try-catch(-finally) инструкция,
            // so the generated catch block cannot be placed in finally block.
            // See also Уловитель::semantic.
            if (sc.ос && sc.ос.tok != ТОК2.onScopeFailure)
            {
                // If enclosing is scope(успех) or scope(exit), this will be placed in finally block.
                oss.выведиОшибку("cannot put `%s` инструкция inside `%s`", Сема2.вТкст0(oss.tok), Сема2.вТкст0(sc.ос.tok));
                return setError();
            }
            if (sc.tf)
            {
                oss.выведиОшибку("cannot put `%s` инструкция inside `finally` block", Сема2.вТкст0(oss.tok));
                return setError();
            }
        }

        sc = sc.сунь();
        sc.tf = null;
        sc.ос = oss;
        if (oss.tok != ТОК2.onScopeFailure)
        {
            // Jump out from scope(failure) block is allowed.
            sc.sbreak = null;
            sc.scontinue = null;
        }
        oss.инструкция = oss.инструкция.semanticNoScope(sc);
        sc.вынь();

        if (!oss.инструкция || oss.инструкция.isErrorStatement())
        {
            результат = oss.инструкция;
            return;
        }
        результат = oss;
    }

    override проц посети(ThrowStatement ts)
    {
        /* https://dlang.org/spec/инструкция.html#throw-инструкция
         */

        //printf("ThrowStatement::semantic()\n");

        if (!глоб2.парамы.useExceptions)
        {
            ts.выведиОшибку("Cannot use `throw` statements with -betterC");
            return setError();
        }

        if (!ClassDeclaration.throwable)
        {
            ts.выведиОшибку("Cannot use `throw` statements because `объект.Throwable` was not declared");
            return setError();
        }

        FuncDeclaration fd = sc.родитель.isFuncDeclaration();
        fd.hasReturnExp |= 2;

        if (ts.exp.op == ТОК2.new_)
        {
            NewExp ne = cast(NewExp)ts.exp;
            ne.thrownew = да;
        }

        ts.exp = ts.exp.ВыражениеSemantic(sc);
        ts.exp = resolveProperties(sc, ts.exp);
        ts.exp = checkGC(sc, ts.exp);
        if (ts.exp.op == ТОК2.error)
            return setError();

        checkThrowEscape(sc, ts.exp, нет);

        ClassDeclaration cd = ts.exp.тип.toBasetype().isClassHandle();
        if (!cd || ((cd != ClassDeclaration.throwable) && !ClassDeclaration.throwable.isBaseOf(cd, null)))
        {
            ts.выведиОшибку("can only throw class objects derived from `Throwable`, not тип `%s`", ts.exp.тип.вТкст0());
            return setError();
        }

        результат = ts;
    }

    override проц посети(DebugStatement ds)
    {
        if (ds.инструкция)
        {
            sc = sc.сунь();
            sc.flags |= SCOPE.debug_;
            ds.инструкция = ds.инструкция.statementSemantic(sc);
            sc.вынь();
        }
        результат = ds.инструкция;
    }

    override проц посети(GotoStatement gs)
    {
        /* https://dlang.org/spec/инструкция.html#goto-инструкция
         */

        //printf("GotoStatement::semantic()\n");
        FuncDeclaration fd = sc.func;

        gs.идент = fixupLabelName(sc, gs.идент);
        gs.label = fd.searchLabel(gs.идент);
        gs.tryBody = sc.tryBody;
        gs.tf = sc.tf;
        gs.ос = sc.ос;
        gs.lastVar = sc.lastVar;

        if (!gs.label.инструкция && sc.fes)
        {
            /* Either the goto label is forward referenced or it
             * is in the function that the enclosing foreach is in.
             * Can't know yet, so wrap the goto in a scope инструкция
             * so we can patch it later, and add it to a 'look at this later'
             * list.
             */
            gs.label.deleted = да;
            auto ss = new ScopeStatement(gs.место, gs, gs.место);
            sc.fes.gotos.сунь(ss); // 'look at this later' list
            результат = ss;
            return;
        }

        // Add to fwdref list to check later
        if (!gs.label.инструкция)
        {
            if (!fd.gotos)
                fd.gotos = new GotoStatements();
            fd.gotos.сунь(gs);
        }
        else if (gs.checkLabel())
            return setError();

        результат = gs;
    }

    override проц посети(LabelStatement ls)
    {
        //printf("LabelStatement::semantic()\n");
        FuncDeclaration fd = sc.родитель.isFuncDeclaration();

        ls.идент = fixupLabelName(sc, ls.идент);
        ls.tryBody = sc.tryBody;
        ls.tf = sc.tf;
        ls.ос = sc.ос;
        ls.lastVar = sc.lastVar;

        LabelDsymbol ls2 = fd.searchLabel(ls.идент);
        if (ls2.инструкция)
        {
            ls.выведиОшибку("label `%s` already defined", ls2.вТкст0());
            return setError();
        }
        else
            ls2.инструкция = ls;

        sc = sc.сунь();
        sc.scopesym = sc.enclosing.scopesym;

        sc.ctorflow.orCSX(CSX.label);

        sc.slabel = ls;
        if (ls.инструкция)
            ls.инструкция = ls.инструкция.statementSemantic(sc);
        sc.вынь();

        результат = ls;
    }

    override проц посети(AsmStatement s)
    {
        /* https://dlang.org/spec/инструкция.html#asm
         */

        результат = asmSemantic(s, sc);
    }

    override проц посети(CompoundAsmStatement cas)
    {
        // Apply postfix attributes of the asm block to each инструкция.
        sc = sc.сунь();
        sc.stc |= cas.stc;
        foreach (ref s; *cas.statements)
        {
            s = s ? s.statementSemantic(sc) : null;
        }

        assert(sc.func);
        // use setImpure/setGC when the deprecation cycle is over
        PURE purity;
        if (!(cas.stc & STC.pure_) && (purity = sc.func.isPureBypassingInference()) != PURE.impure && purity != PURE.fwdref)
            cas.deprecation("`asm` инструкция is assumed to be impure - mark it with `` if it is not");
        if (!(cas.stc & STC.nogc) && sc.func.isNogcBypassingInference())
            cas.deprecation("`asm` инструкция is assumed to use the СМ - mark it with `` if it does not");
        if (!(cas.stc & (STC.trusted | STC.safe)) && sc.func.setUnsafe())
            cas.выведиОшибку("`asm` инструкция is assumed to be `@system` - mark it with `@trusted` if it is not");

        sc.вынь();
        результат = cas;
    }

    override проц посети(ImportStatement imps)
    {
        /* https://dlang.org/spec/module.html#ImportDeclaration
         */

        foreach (i; new бцел[0 .. imps.imports.dim])
        {
            Импорт s = (*imps.imports)[i].isImport();
            assert(!s.aliasdecls.dim);
            foreach (j, имя; s.имена)
            {
                Идентификатор2 _alias = s.ники[j];
                if (!_alias)
                    _alias = имя;

                auto tname = new TypeIdentifier(s.место, имя);
                auto ad = new AliasDeclaration(s.место, _alias, tname);
                ad._import = s;
                s.aliasdecls.сунь(ad);
            }

            s.dsymbolSemantic(sc);

            // https://issues.dlang.org/show_bug.cgi?ид=19942
            // If the module that's being imported doesn't exist, don't add it to the symbol table
            // for the current scope.
            if (s.mod !is null)
            {
                Module.addDeferredSemantic2(s);     // https://issues.dlang.org/show_bug.cgi?ид=14666
                sc.вставь(s);

                foreach (aliasdecl; s.aliasdecls)
                {
                    sc.вставь(aliasdecl);
                }
            }
        }
        результат = imps;
    }
}

проц catchSemantic(Уловитель c, Scope* sc)
{
    //printf("Уловитель::semantic(%s)\n", идент.вТкст0());

    if (sc.ос && sc.ос.tok != ТОК2.onScopeFailure)
    {
        // If enclosing is scope(успех) or scope(exit), this will be placed in finally block.
        выведиОшибку(c.место, "cannot put `catch` инструкция inside `%s`", Сема2.вТкст0(sc.ос.tok));
        c.errors = да;
    }
    if (sc.tf)
    {
        /* This is because the _d_local_unwind() gets the stack munged
         * up on this. The workaround is to place any try-catches into
         * a separate function, and call that.
         * To fix, have the compiler automatically convert the finally
         * body into a nested function.
         */
        выведиОшибку(c.место, "cannot put `catch` инструкция inside `finally` block");
        c.errors = да;
    }

    auto sym = new ScopeDsymbol();
    sym.родитель = sc.scopesym;
    sc = sc.сунь(sym);

    if (!c.тип)
    {
        выведиОшибку(c.место, "`catch` инструкция without an exception specification is deprecated");
        errorSupplemental(c.место, "use `catch(Throwable)` for old behavior");
        c.errors = да;

        // reference .объект.Throwable
        c.тип = getThrowable();
    }
    c.тип = c.тип.typeSemantic(c.место, sc);
    if (c.тип == Тип.terror)
        c.errors = да;
    else
    {
        КлассХранения stc;
        auto cd = c.тип.toBasetype().isClassHandle();
        if (!cd)
        {
            выведиОшибку(c.место, "can only catch class objects, not `%s`", c.тип.вТкст0());
            c.errors = да;
        }
        else if (cd.isCPPclass())
        {
            if (!target.cpp.exceptions)
            {
                выведиОшибку(c.место, "catching C++ class objects not supported for this target");
                c.errors = да;
            }
            if (sc.func && !sc.intypeof && !c.internalCatch && sc.func.setUnsafe())
            {
                выведиОшибку(c.место, "cannot catch C++ class objects in `` code");
                c.errors = да;
            }
        }
        else if (cd != ClassDeclaration.throwable && !ClassDeclaration.throwable.isBaseOf(cd, null))
        {
            выведиОшибку(c.место, "can only catch class objects derived from `Throwable`, not `%s`", c.тип.вТкст0());
            c.errors = да;
        }
        else if (sc.func && !sc.intypeof && !c.internalCatch && ClassDeclaration.exception &&
                 cd != ClassDeclaration.exception && !ClassDeclaration.exception.isBaseOf(cd, null) &&
                 sc.func.setUnsafe())
        {
            выведиОшибку(c.место, "can only catch class objects derived from `Exception` in `` code, not `%s`", c.тип.вТкст0());
            c.errors = да;
        }
        else if (глоб2.парамы.ehnogc)
        {
            stc |= STC.scope_;
        }

        // DIP1008 requires destruction of the Throwable, even if the user didn't specify an идентификатор
        auto идент = c.идент;
        if (!идент && глоб2.парамы.ehnogc)
            идент = Идентификатор2.анонимный();

        if (идент)
        {
            c.var = new VarDeclaration(c.место, c.тип, идент, null, stc);
            c.var.iscatchvar = да;
            c.var.dsymbolSemantic(sc);
            sc.вставь(c.var);

            if (глоб2.парамы.ehnogc && stc & STC.scope_)
            {
                /* Add a destructor for c.var
                 * try { handler } finally { if (!__ctfe) _d_delThrowable(var); }
                 */
                assert(!c.var.edtor);           // ensure we didn't создай one in callScopeDtor()

                Место место = c.место;
                Выражение e = new VarExp(место, c.var);
                e = new CallExp(место, new IdentifierExp(место, Id._d_delThrowable), e);

                Выражение ec = new IdentifierExp(место, Id.ctfe);
                ec = new NotExp(место, ec);
                Инструкция2 s = new IfStatement(место, null, ec, new ExpStatement(место, e), null, место);
                c.handler = new TryFinallyStatement(место, c.handler, s);
            }

        }
        c.handler = c.handler.statementSemantic(sc);
        if (c.handler && c.handler.isErrorStatement())
            c.errors = да;
    }

    sc.вынь();
}

Инструкция2 semanticNoScope(Инструкция2 s, Scope* sc)
{
    //printf("Инструкция2::semanticNoScope() %s\n", вТкст0());
    if (!s.isCompoundStatement() && !s.isScopeStatement())
    {
        s = new CompoundStatement(s.место, s); // so scopeCode() gets called
    }
    s = s.statementSemantic(sc);
    return s;
}

// Same as semanticNoScope(), but do создай a new scope
Инструкция2 semanticScope(Инструкция2 s, Scope* sc, Инструкция2 sbreak, Инструкция2 scontinue)
{
    auto sym = new ScopeDsymbol();
    sym.родитель = sc.scopesym;
    Scope* scd = sc.сунь(sym);
    if (sbreak)
        scd.sbreak = sbreak;
    if (scontinue)
        scd.scontinue = scontinue;
    s = s.semanticNoScope(scd);
    scd.вынь();
    return s;
}


/*******************
 * Determines additional argument types for makeTupleForeach.
 */
static template TupleForeachArgs(бул isStatic, бул isDecl)
{
    alias T Seq(T...);
    static if(isStatic) alias Seq!(бул) T;
    else alias Seq!() T;
    static if(!isDecl) alias T TupleForeachArgs;
    else alias Seq!(Дсимволы*,T) TupleForeachArgs;
}

/*******************
 * Determines the return тип of makeTupleForeach.
 */
static template TupleForeachRet(бул isStatic, бул isDecl)
{
    alias T Seq(T...);
    static if(!isDecl) alias Инструкция2 TupleForeachRet;
    else alias Дсимволы* TupleForeachRet;
}


/*******************
 * See StatementSemanticVisitor.makeTupleForeach.  This is a simple
 * wrapper that returns the generated statements/declarations.
 */
TupleForeachRet!(isStatic, isDecl) makeTupleForeach(бул isStatic, бул isDecl)(Scope* sc, ForeachStatement fs, TupleForeachArgs!(isStatic, isDecl) args)
{
    scope v = new StatementSemanticVisitor(sc);
    static if(!isDecl)
    {
        v.makeTupleForeach!(isStatic, isDecl)(fs, args);
        return v.результат;
    }
    else
    {
        return v.makeTupleForeach!(isStatic, isDecl)(fs, args);
    }
}
