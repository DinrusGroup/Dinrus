/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:    $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/inline.d, _inline.d)
 * Documentation:  https://dlang.org/phobos/dmd_inline.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/inline.d
 */

module dmd.inline;

import cidrus;

import dmd.aggregate;
import dmd.apply;
import dmd.arraytypes;
import dmd.attrib;
import dmd.declaration;
import dmd.dmodule;
import dmd.dscope;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dtemplate;
import drc.ast.Expression;
import dmd.errors;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.init;
import dmd.initsem;
import dmd.mtype;
import dmd.opover;
import dmd.инструкция;
import drc.lexer.Tokens;
import drc.ast.Visitor;
import dmd.inlinecost;
import drc.ast.Node;

/***********************************************************
 * Scan function implementations in Module m looking for functions that can be inlined,
 * and inline them in situ.
 *
 * Параметры:
 *    m = module to scan
 */
public проц inlineScanModule(Module m)
{
    if (m.semanticRun != PASS.semantic3done)
        return;
    m.semanticRun = PASS.inline;

    // Note that modules get their own scope, from scratch.
    // This is so regardless of where in the syntax a module
    // gets imported, it is unaffected by context.

    //printf("Module = %p\n", m.sc.scopesym);

    foreach (i; new бцел[0 .. m.члены.dim])
    {
        ДСимвол s = (*m.члены)[i];
        //if (глоб2.парамы.verbose)
        //    message("inline scan symbol %s", s.вТкст0());
        scope InlineScanVisitor v = new InlineScanVisitor();
        s.прими(v);
    }
    m.semanticRun = PASS.inlinedone;
}

/***********************************************************
 * Perform the "inline copying" of a default argument for a function параметр.
 *
 * Todo:
 *  The hack for bugzilla 4820 case is still questionable. Perhaps would have to
 *  handle a delegate Выражение with 'null' context properly in front-end.
 */
public Выражение inlineCopy(Выражение e, Scope* sc)
{
    /* See https://issues.dlang.org/show_bug.cgi?ид=2935
     * for explanation of why just a копируй() is broken
     */
    //return e.копируй();
    if (auto de = e.isDelegateExp())
    {
        if (de.func.isNested())
        {
            /* https://issues.dlang.org/show_bug.cgi?ид=4820
             * Defer checking until later if we actually need the 'this' pointer
             */
            return de.копируй();
        }
    }
    цел cost = inlineCostВыражение(e);
    if (cost >= COST_MAX)
    {
        e.выведиОшибку("cannot inline default argument `%s`", e.вТкст0());
        return new ErrorExp();
    }
    scope ids = new InlineDoState(sc.родитель, null);
    return doInlineAs!(Выражение)(e, ids);
}






private:



const LOG = нет;
const CANINLINE_LOG = нет;
const EXPANDINLINE_LOG = нет;


/***********************************************************
 * Represent a context to inline statements and Выражения.
 *
 * Todo:
 *  It would be better to make foundReturn an instance field of DoInlineAs visitor class,
 *  like as DoInlineAs!(результат).результат field, because it's one another результат of inlining.
 *  The best would be to return a pair of результат Выражение and a бул значение as foundReturn
 *  from doInlineAs function.
 */
private final class InlineDoState
{
    // inline context
    VarDeclaration vthis;
    Дсимволы from;      // old Дсимволы
    Дсимволы to;        // parallel массив of new Дсимволы
    ДСимвол родитель;     // new родитель
    FuncDeclaration fd; // function being inlined (old родитель)
    // inline результат
    бул foundReturn;

    this(ДСимвол родитель, FuncDeclaration fd)
    {
        this.родитель = родитель;
        this.fd = fd;
    }
}

/***********************************************************
 * Perform the inlining from (Инструкция2 or Выражение) to (Инструкция2 or Выражение).
 *
 * Inlining is done by:
 *  - Converting to an Выражение
 *  - Copying the trees of the function to be inlined
 *  - Renaming the variables
 */
private  final class DoInlineAs(результат) : Визитор2
//if (is(результат == Инструкция2) || is(результат == Выражение))
{
    alias Визитор2.посети посети;
public:
    InlineDoState ids;
    результат результат;

    const asStatements = is(результат == Инструкция2);

    this(InlineDoState ids)
    {
        this.ids = ids;
    }

    // Инструкция2 -> (Инструкция2 | Выражение)

    override проц посети(Инструкция2 s)
    {
        printf("Инструкция2.doInlineAs!%s()\n%s\n", результат.stringof.ptr, s.вТкст0());
        fflush(stdout);
        assert(0); // default is we can't inline it
    }

    override проц посети(ExpStatement s)
    {
        static if (LOG)
        {
            if (s.exp)
                printf("ExpStatement.doInlineAs!%s() '%s'\n", результат.stringof.ptr, s.exp.вТкст0());
        }

        auto exp = doInlineAs!(Выражение)(s.exp, ids);
        static if (asStatements)
            результат = new ExpStatement(s.место, exp);
        else
            результат = exp;
    }

    override проц посети(CompoundStatement s)
    {
        //printf("CompoundStatement.doInlineAs!%s() %d\n", результат.stringof.ptr, s.statements.dim);
        static if (asStatements)
        {
            auto as = new Инструкции();
            as.резервируй(s.statements.dim);
        }

        foreach (i, sx; *s.statements)
        {
            if (!sx)
                continue;
            static if (asStatements)
            {
                as.сунь(doInlineAs!(Инструкция2)(sx, ids));
            }
            else
            {
                /* Specifically allow:
                 *  if (условие)
                 *      return exp1;
                 *  return exp2;
                 */
                IfStatement ifs;
                Инструкция2 s3;
                if ((ifs = sx.isIfStatement()) !is null &&
                    ifs.ifbody &&
                    ifs.ifbody.endsWithReturnStatement() &&
                    !ifs.elsebody &&
                    i + 1 < s.statements.dim &&
                    (s3 = (*s.statements)[i + 1]) !is null &&
                    s3.endsWithReturnStatement()
                   )
                {
                    /* Rewrite as ?:
                     */
                    auto econd = doInlineAs!(Выражение)(ifs.условие, ids);
                    assert(econd);
                    auto e1 = doInlineAs!(Выражение)(ifs.ifbody, ids);
                    assert(ids.foundReturn);
                    auto e2 = doInlineAs!(Выражение)(s3, ids);

                    Выражение e = new CondExp(econd.место, econd, e1, e2);
                    e.тип = e1.тип;
                    if (e.тип.ty == Ttuple)
                    {
                        e1.тип = Тип.tvoid;
                        e2.тип = Тип.tvoid;
                        e.тип = Тип.tvoid;
                    }
                    результат = Выражение.combine(результат, e);
                }
                else
                {
                    auto e = doInlineAs!(Выражение)(sx, ids);
                    результат = Выражение.combine(результат, e);
                }
            }

            if (ids.foundReturn)
                break;
        }

        static if (asStatements)
            результат = new CompoundStatement(s.место, as);
    }

    override проц посети(UnrolledLoopStatement s)
    {
        //printf("UnrolledLoopStatement.doInlineAs!%s() %d\n", результат.stringof.ptr, s.statements.dim);
        static if (asStatements)
        {
            auto as = new Инструкции();
            as.резервируй(s.statements.dim);
        }

        foreach (sx; *s.statements)
        {
            if (!sx)
                continue;
            auto r = doInlineAs!(результат)(sx, ids);
            static if (asStatements)
                as.сунь(r);
            else
                результат = Выражение.combine(результат, r);

            if (ids.foundReturn)
                break;
        }

        static if (asStatements)
            результат = new UnrolledLoopStatement(s.место, as);
    }

    override проц посети(ScopeStatement s)
    {
        //printf("ScopeStatement.doInlineAs!%s() %d\n", результат.stringof.ptr, s.инструкция.dim);
        auto r = doInlineAs!(результат)(s.инструкция, ids);
        static if (asStatements)
            результат = new ScopeStatement(s.место, r, s.endloc);
        else
            результат = r;
    }

    override проц посети(IfStatement s)
    {
        assert(!s.prm);
        auto econd = doInlineAs!(Выражение)(s.условие, ids);
        assert(econd);

        auto ifbody = doInlineAs!(результат)(s.ifbody, ids);
        бул bodyReturn = ids.foundReturn;

        ids.foundReturn = нет;
        auto elsebody = doInlineAs!(результат)(s.elsebody, ids);

        static if (asStatements)
        {
            результат = new IfStatement(s.место, s.prm, econd, ifbody, elsebody, s.endloc);
        }
        else
        {
            alias  ifbody e1;
            alias  elsebody e2;
            if (e1 && e2)
            {
                результат = new CondExp(econd.место, econd, e1, e2);
                результат.тип = e1.тип;
                if (результат.тип.ty == Ttuple)
                {
                    e1.тип = Тип.tvoid;
                    e2.тип = Тип.tvoid;
                    результат.тип = Тип.tvoid;
                }
            }
            else if (e1)
            {
                результат = new LogicalExp(econd.место, ТОК2.andAnd, econd, e1);
                результат.тип = Тип.tvoid;
            }
            else if (e2)
            {
                результат = new LogicalExp(econd.место, ТОК2.orOr, econd, e2);
                результат.тип = Тип.tvoid;
            }
            else
            {
                результат = econd;
            }
        }
        ids.foundReturn = ids.foundReturn && bodyReturn;
    }

    override проц посети(ReturnStatement s)
    {
        //printf("ReturnStatement.doInlineAs!%s() '%s'\n", результат.stringof.ptr, s.exp ? s.exp.вТкст0() : "");
        ids.foundReturn = да;

        auto exp = doInlineAs!(Выражение)(s.exp, ids);
        if (!exp) // https://issues.dlang.org/show_bug.cgi?ид=14560
                  // 'return' must not leave in the expand результат
            return;
        static if (asStatements)
        {
            /* Any return инструкция should be the last инструкция in the function being
             * inlined, otherwise things shouldn't have gotten this far. Since the
             * return значение is being ignored (otherwise it wouldn't be inlined as a инструкция)
             * we only need to evaluate `exp` for side effects.
             * Already disallowed this if `exp` produces an объект that needs destruction -
             * an enhancement would be to do the destruction here.
             */
            результат = new ExpStatement(s.место, exp);
        }
        else
            результат = exp;
    }

    override проц посети(ImportStatement s)
    {
    }

    override проц посети(ForStatement s)
    {
        //printf("ForStatement.doInlineAs!%s()\n", результат.stringof.ptr);
        static if (asStatements)
        {
            auto sinit = doInlineAs!(Инструкция2)(s._иниц, ids);
            auto scond = doInlineAs!(Выражение)(s.условие, ids);
            auto sincr = doInlineAs!(Выражение)(s.increment, ids);
            auto sbody = doInlineAs!(Инструкция2)(s._body, ids);
            результат = new ForStatement(s.место, sinit, scond, sincr, sbody, s.endloc);
        }
        else
            результат = null;  // cannot be inlined as an Выражение
    }

    override проц посети(ThrowStatement s)
    {
        //printf("ThrowStatement.doInlineAs!%s() '%s'\n", результат.stringof.ptr, s.exp.вТкст0());
        static if (asStatements)
            результат = new ThrowStatement(s.место, doInlineAs!(Выражение)(s.exp, ids));
        else
            результат = null;  // cannot be inlined as an Выражение
    }

    // Выражение -> (Инструкция2 | Выражение)

    static if (asStatements)
    {
        override проц посети(Выражение e)
        {
            результат = new ExpStatement(e.место, doInlineAs!(Выражение)(e, ids));
        }
    }
    else
    {
        /******************************
         * Perform doInlineAs() on an массив of Выражения.
         */
        Выражения* arrayВыражениеDoInline(Выражения* a)
        {
            if (!a)
                return null;

            auto newa = new Выражения(a.dim);

            foreach (i; new бцел[0 .. a.dim])
            {
                (*newa)[i] = doInlineAs!(Выражение)((*a)[i], ids);
            }
            return newa;
        }

        override проц посети(Выражение e)
        {
            //printf("Выражение.doInlineAs!%s(%s): %s\n", результат.stringof.ptr, Сема2.вТкст0(e.op), e.вТкст0());
            результат = e.копируй();
        }

        override проц посети(SymOffExp e)
        {
            //printf("SymOffExp.doInlineAs!%s(%s)\n", результат.stringof.ptr, e.вТкст0());
            foreach (i; new бцел[0 .. ids.from.dim])
            {
                if (e.var != ids.from[i])
                    continue;
                auto se = e.копируй().isSymOffExp();
                se.var = ids.to[i].isDeclaration();
                результат = se;
                return;
            }
            результат = e;
        }

        override проц посети(VarExp e)
        {
            //printf("VarExp.doInlineAs!%s(%s)\n", результат.stringof.ptr, e.вТкст0());
            foreach (i; new бцел[0 .. ids.from.dim])
            {
                if (e.var != ids.from[i])
                    continue;
                auto ve = e.копируй().isVarExp();
                ve.var = ids.to[i].isDeclaration();
                результат = ve;
                return;
            }
            if (ids.fd && e.var == ids.fd.vthis)
            {
                результат = new VarExp(e.место, ids.vthis);
                if (ids.fd.isThis2)
                    результат = new AddrExp(e.место, результат);
                результат.тип = e.тип;
                return;
            }

            /* Inlining context pointer access for nested referenced variables.
             * For example:
             *      auto fun() {
             *        цел i = 40;
             *        auto foo() {
             *          цел g = 2;
             *          struct результат {
             *            auto bar() { return i + g; }
             *          }
             *          return результат();
             *        }
             *        return foo();
             *      }
             *      auto t = fun();
             * 'i' and 'g' are nested referenced variables in результат.bar(), so:
             *      auto x = t.bar();
             * should be inlined to:
             *      auto x = *(t.vthis.vthis + i.voffset) + *(t.vthis + g.voffset)
             */
            auto v = e.var.isVarDeclaration();
            if (v && v.nestedrefs.dim && ids.vthis)
            {
                ДСимвол s = ids.fd;
                auto fdv = v.toParent().isFuncDeclaration();
                assert(fdv);
                результат = new VarExp(e.место, ids.vthis);
                результат.тип = ids.vthis.тип;
                if (ids.fd.isThis2)
                {
                    // &__this
                    результат = new AddrExp(e.место, результат);
                    результат.тип = ids.vthis.тип.pointerTo();
                }
                while (s != fdv)
                {
                    auto f = s.isFuncDeclaration();
                    AggregateDeclaration ad;
                    if (f && f.isThis2)
                    {
                        if (f.hasNestedFrameRefs())
                        {
                            результат = new DotVarExp(e.место, результат, f.vthis);
                            результат.тип = f.vthis.тип;
                        }
                        // (*__this)[i]
                        бцел i = f.followInstantiationContext(fdv);
                        if (i == 1 && f == ids.fd)
                        {
                            auto ve = e.копируй().isVarExp();
                            ve.originalScope = ids.fd;
                            результат = ve;
                            return;
                        }
                        результат = new PtrExp(e.место, результат);
                        результат.тип = Тип.tvoidptr.sarrayOf(2);
                        auto ie = new IndexExp(e.место, результат, new IntegerExp(i));
                        ie.indexIsInBounds = да; // no runtime bounds checking
                        результат = ie;
                        результат.тип = Тип.tvoidptr;
                        s = f.toParentP(fdv);
                        ad = s.isAggregateDeclaration();
                        if (ad)
                            goto Lad;
                        continue;
                    }
                    else if ((ad = s.isThis()) !is null)
                    {
                Lad:
                        while (ad)
                        {
                            assert(ad.vthis);
                            бул i = ad.followInstantiationContext(fdv);
                            auto vthis = i ? ad.vthis2 : ad.vthis;
                            результат = new DotVarExp(e.место, результат, vthis);
                            результат.тип = vthis.тип;
                            s = ad.toParentP(fdv);
                            ad = s.isAggregateDeclaration();
                        }
                    }
                    else if (f && f.isNested())
                    {
                        assert(f.vthis);
                        if (f.hasNestedFrameRefs())
                        {
                            результат = new DotVarExp(e.место, результат, f.vthis);
                            результат.тип = f.vthis.тип;
                        }
                        s = f.toParent2();
                    }
                    else
                        assert(0);
                    assert(s);
                }
                результат = new DotVarExp(e.место, результат, v);
                результат.тип = v.тип;
                //printf("\t==> результат = %s, тип = %s\n", результат.вТкст0(), результат.тип.вТкст0());
                return;
            }
            else if (v && v.nestedrefs.dim)
            {
                auto ve = e.копируй().isVarExp();
                ve.originalScope = ids.fd;
                результат = ve;
                return;
            }

            результат = e;
        }

        override проц посети(ThisExp e)
        {
            //if (!ids.vthis)
            //    e.выведиОшибку("no `this` when inlining `%s`", ids.родитель.вТкст0());
            if (!ids.vthis)
            {
                результат = e;
                return;
            }
            результат = new VarExp(e.место, ids.vthis);
            if (ids.fd.isThis2)
            {
                // __this[0]
                результат.тип = ids.vthis.тип;
                auto ie = new IndexExp(e.место, результат, IntegerExp.literal!(0));
                ie.indexIsInBounds = да; // no runtime bounds checking
                результат = ie;
                if (e.тип.ty == Tstruct)
                {
                    результат.тип = e.тип.pointerTo();
                    результат = new PtrExp(e.место, результат);
                }
            }
            результат.тип = e.тип;
        }

        override проц посети(SuperExp e)
        {
            assert(ids.vthis);
            результат = new VarExp(e.место, ids.vthis);
            if (ids.fd.isThis2)
            {
                // __this[0]
                результат.тип = ids.vthis.тип;
                auto ie = new IndexExp(e.место, результат, IntegerExp.literal!(0));
                ie.indexIsInBounds = да; // no runtime bounds checking
                результат = ie;
            }
            результат.тип = e.тип;
        }

        override проц посети(DeclarationExp e)
        {
            //printf("DeclarationExp.doInlineAs!%s(%s)\n", результат.stringof.ptr, e.вТкст0());
            if (auto vd = e.declaration.isVarDeclaration())
            {
                version (none)
                {
                    // Need to figure this out before inlining can work for tuples
                    if (auto tup = vd.toAlias().isTupleDeclaration())
                    {
                        foreach (i; new бцел[0 .. tup.objects.dim])
                        {
                            DsymbolExp se = (*tup.objects)[i];
                            assert(se.op == ТОК2.dSymbol);
                            se.s;
                        }
                        результат = st.objects.dim;
                        return;
                    }
                }
                if (vd.isStatic())
                    return;

                if (ids.fd && vd == ids.fd.nrvo_var)
                {
                    foreach (i; new бцел[0 .. ids.from.dim])
                    {
                        if (vd != ids.from[i])
                            continue;
                        if (vd._иниц && !vd._иниц.isVoidInitializer())
                        {
                            результат = vd._иниц.инициализаторВВыражение();
                            assert(результат);
                            результат = doInlineAs!(Выражение)(результат, ids);
                        }
                        else
                            результат = new IntegerExp(vd._иниц.место, 0, Тип.tint32);
                        return;
                    }
                }

                auto vto = new VarDeclaration(vd.место, vd.тип, vd.идент, vd._иниц);
                memcpy(cast(ук)vto, cast(ук)vd, __traits(classInstanceSize, VarDeclaration));
                vto.родитель = ids.родитель;
                vto.csym = null;
                vto.isym = null;

                ids.from.сунь(vd);
                ids.to.сунь(vto);

                if (vd._иниц)
                {
                    if (vd._иниц.isVoidInitializer())
                    {
                        vto._иниц = new VoidInitializer(vd._иниц.место);
                    }
                    else
                    {
                        auto ei = vd._иниц.инициализаторВВыражение();
                        assert(ei);
                        vto._иниц = new ExpInitializer(ei.место, doInlineAs!(Выражение)(ei, ids));
                    }
                }
                if (vd.edtor)
                {
                    vto.edtor = doInlineAs!(Выражение)(vd.edtor, ids);
                }
                auto de = e.копируй().isDeclarationExp();
                de.declaration = vto;
                результат = de;
                return;
            }

            // Prevent the копируй of the aggregates allowed in inlineable funcs
            if (isInlinableNestedAggregate(e))
                return;

            /* This needs work, like DeclarationExp.toElem(), if we are
             * to handle TemplateMixin's. For now, we just don't inline them.
             */
            посети(cast(Выражение)e);
        }

        override проц посети(TypeidExp e)
        {
            //printf("TypeidExp.doInlineAs!%s(): %s\n", результат.stringof.ptr, e.вТкст0());
            auto te = e.копируй().isTypeidExp();
            if (auto ex = выражение_ли(te.obj))
            {
                te.obj = doInlineAs!(Выражение)(ex, ids);
            }
            else
                assert(тип_ли(te.obj));
            результат = te;
        }

        override проц посети(NewExp e)
        {
            //printf("NewExp.doInlineAs!%s(): %s\n", результат.stringof.ptr, e.вТкст0());
            auto ne = e.копируй().isNewExp();
            ne.thisexp = doInlineAs!(Выражение)(e.thisexp, ids);
            ne.argprefix = doInlineAs!(Выражение)(e.argprefix, ids);
            ne.newargs = arrayВыражениеDoInline(e.newargs);
            ne.arguments = arrayВыражениеDoInline(e.arguments);
            результат = ne;

            semanticTypeInfo(null, e.тип);
        }

        override проц посети(DeleteExp e)
        {
            посети(cast(UnaExp)e);

            Тип tb = e.e1.тип.toBasetype();
            if (tb.ty == Tarray)
            {
                Тип tv = tb.nextOf().baseElemOf();
                if (auto ts = tv.isTypeStruct())
                {
                    auto sd = ts.sym;
                    if (sd.dtor)
                        semanticTypeInfo(null, ts);
                }
            }
        }

        override проц посети(UnaExp e)
        {
            auto ue = cast(UnaExp)e.копируй();
            ue.e1 = doInlineAs!(Выражение)(e.e1, ids);
            результат = ue;
        }

        override проц посети(AssertExp e)
        {
            auto ae = e.копируй().isAssertExp();
            ae.e1 = doInlineAs!(Выражение)(e.e1, ids);
            ae.msg = doInlineAs!(Выражение)(e.msg, ids);
            результат = ae;
        }

        override проц посети(BinExp e)
        {
            auto be = cast(BinExp)e.копируй();
            be.e1 = doInlineAs!(Выражение)(e.e1, ids);
            be.e2 = doInlineAs!(Выражение)(e.e2, ids);
            результат = be;
        }

        override проц посети(CallExp e)
        {
            auto ce = e.копируй().isCallExp();
            ce.e1 = doInlineAs!(Выражение)(e.e1, ids);
            ce.arguments = arrayВыражениеDoInline(e.arguments);
            результат = ce;
        }

        override проц посети(AssignExp e)
        {
            посети(cast(BinExp)e);

            if (auto ale = e.e1.isArrayLengthExp())
            {
                Тип tn = ale.e1.тип.toBasetype().nextOf();
                semanticTypeInfo(null, tn);
            }
        }

        override проц посети(EqualExp e)
        {
            посети(cast(BinExp)e);

            Тип t1 = e.e1.тип.toBasetype();
            if (t1.ty == Tarray || t1.ty == Tsarray)
            {
                Тип t = t1.nextOf().toBasetype();
                while (t.toBasetype().nextOf())
                    t = t.nextOf().toBasetype();
                if (t.ty == Tstruct)
                    semanticTypeInfo(null, t);
            }
            else if (t1.ty == Taarray)
            {
                semanticTypeInfo(null, t1);
            }
        }

        override проц посети(IndexExp e)
        {
            auto are = e.копируй().isIndexExp();
            are.e1 = doInlineAs!(Выражение)(e.e1, ids);
            if (e.lengthVar)
            {
                //printf("lengthVar\n");
                auto vd = e.lengthVar;
                auto vto = new VarDeclaration(vd.место, vd.тип, vd.идент, vd._иниц);
                memcpy(cast(ук)vto, cast(ук)vd, __traits(classInstanceSize, VarDeclaration));
                vto.родитель = ids.родитель;
                vto.csym = null;
                vto.isym = null;

                ids.from.сунь(vd);
                ids.to.сунь(vto);

                if (vd._иниц && !vd._иниц.isVoidInitializer())
                {
                    auto ie = vd._иниц.isExpInitializer();
                    assert(ie);
                    vto._иниц = new ExpInitializer(ie.место, doInlineAs!(Выражение)(ie.exp, ids));
                }
                are.lengthVar = vto;
            }
            are.e2 = doInlineAs!(Выражение)(e.e2, ids);
            результат = are;
        }

        override проц посети(SliceExp e)
        {
            auto are = e.копируй().isSliceExp();
            are.e1 = doInlineAs!(Выражение)(e.e1, ids);
            if (e.lengthVar)
            {
                //printf("lengthVar\n");
                auto vd = e.lengthVar;
                auto vto = new VarDeclaration(vd.место, vd.тип, vd.идент, vd._иниц);
                memcpy(cast(ук)vto, cast(ук)vd, __traits(classInstanceSize, VarDeclaration));
                vto.родитель = ids.родитель;
                vto.csym = null;
                vto.isym = null;

                ids.from.сунь(vd);
                ids.to.сунь(vto);

                if (vd._иниц && !vd._иниц.isVoidInitializer())
                {
                    auto ie = vd._иниц.isExpInitializer();
                    assert(ie);
                    vto._иниц = new ExpInitializer(ie.место, doInlineAs!(Выражение)(ie.exp, ids));
                }

                are.lengthVar = vto;
            }
            are.lwr = doInlineAs!(Выражение)(e.lwr, ids);
            are.upr = doInlineAs!(Выражение)(e.upr, ids);
            результат = are;
        }

        override проц посети(TupleExp e)
        {
            auto ce = e.копируй().isTupleExp();
            ce.e0 = doInlineAs!(Выражение)(e.e0, ids);
            ce.exps = arrayВыражениеDoInline(e.exps);
            результат = ce;
        }

        override проц посети(ArrayLiteralExp e)
        {
            auto ce = e.копируй().isArrayLiteralExp();
            ce.basis = doInlineAs!(Выражение)(e.basis, ids);
            ce.elements = arrayВыражениеDoInline(e.elements);
            результат = ce;

            semanticTypeInfo(null, e.тип);
        }

        override проц посети(AssocArrayLiteralExp e)
        {
            auto ce = e.копируй().isAssocArrayLiteralExp();
            ce.keys = arrayВыражениеDoInline(e.keys);
            ce.values = arrayВыражениеDoInline(e.values);
            результат = ce;

            semanticTypeInfo(null, e.тип);
        }

        override проц посети(StructLiteralExp e)
        {
            if (e.inlinecopy)
            {
                результат = e.inlinecopy;
                return;
            }
            auto ce = e.копируй().isStructLiteralExp();
            e.inlinecopy = ce;
            ce.elements = arrayВыражениеDoInline(e.elements);
            e.inlinecopy = null;
            результат = ce;
        }

        override проц посети(ArrayExp e)
        {
            auto ce = e.копируй().isArrayExp();
            ce.e1 = doInlineAs!(Выражение)(e.e1, ids);
            ce.arguments = arrayВыражениеDoInline(e.arguments);
            результат = ce;
        }

        override проц посети(CondExp e)
        {
            auto ce = e.копируй().isCondExp();
            ce.econd = doInlineAs!(Выражение)(e.econd, ids);
            ce.e1 = doInlineAs!(Выражение)(e.e1, ids);
            ce.e2 = doInlineAs!(Выражение)(e.e2, ids);
            результат = ce;
        }
    }
}

/// ditto
private результат doInlineAs(результат)(Инструкция2 s, InlineDoState ids)
{
    if (!s)
        return null;

    scope DoInlineAs!(результат) v = new DoInlineAs!(результат)(ids);
    s.прими(v);
    return v.результат;
}

/// ditto
private результат doInlineAs(результат)(Выражение e, InlineDoState ids)
{
    if (!e)
        return null;

    scope DoInlineAs!(результат) v = new DoInlineAs!(результат)(ids);
    e.прими(v);
    return v.результат;
}

/***********************************************************
 * Walk the trees, looking for functions to inline.
 * Inline any that can be.
 */
private  final class InlineScanVisitor : Визитор2
{
    alias Визитор2.посети посети;
public:
    FuncDeclaration родитель;     // function being scanned
    // As the посети method cannot return a значение, these variables
    // are используется to pass the результат from 'посети' back to 'inlineScan'
    Инструкция2 sрезультат;
    Выражение eрезультат;
    бул again;

    this()
    {
    }

    override проц посети(Инструкция2 s)
    {
    }

    override проц посети(ExpStatement s)
    {
        static if (LOG)
        {
            printf("ExpStatement.inlineScan(%s)\n", s.вТкст0());
        }
        if (!s.exp)
            return;

        Инструкция2 inlineScanExpAsStatement(ref Выражение exp)
        {
            /* If there's a ТОК2.call at the top, then it may fail to inline
             * as an Выражение. Try to inline as a Инструкция2 instead.
             */
            if (auto ce = exp.isCallExp())
            {
                visitCallExp(ce, null, да);
                if (eрезультат)
                    exp = eрезультат;
                auto s = sрезультат;
                sрезультат = null;
                eрезультат = null;
                return s;
            }

            /* If there's a CondExp or CommaExp at the top, then its
             * sub-Выражения may be inlined as statements.
             */
            if (auto e = exp.isCondExp())
            {
                inlineScan(e.econd);
                auto s1 = inlineScanExpAsStatement(e.e1);
                auto s2 = inlineScanExpAsStatement(e.e2);
                if (!s1 && !s2)
                    return null;
                auto ifbody   = !s1 ? new ExpStatement(e.e1.место, e.e1) : s1;
                auto elsebody = !s2 ? new ExpStatement(e.e2.место, e.e2) : s2;
                return new IfStatement(exp.место, null, e.econd, ifbody, elsebody, exp.место);
            }
            if (auto e = exp.isCommaExp())
            {
                auto s1 = inlineScanExpAsStatement(e.e1);
                auto s2 = inlineScanExpAsStatement(e.e2);
                if (!s1 && !s2)
                    return null;
                auto a = new Инструкции();
                a.сунь(!s1 ? new ExpStatement(e.e1.место, e.e1) : s1);
                a.сунь(!s2 ? new ExpStatement(e.e2.место, e.e2) : s2);
                return new CompoundStatement(exp.место, a);
            }

            // inline as an Выражение
            inlineScan(exp);
            return null;
        }

        sрезультат = inlineScanExpAsStatement(s.exp);
    }

    override проц посети(CompoundStatement s)
    {
        foreach (i; new бцел[0 .. s.statements.dim])
        {
            inlineScan((*s.statements)[i]);
        }
    }

    override проц посети(UnrolledLoopStatement s)
    {
        foreach (i; new бцел[0 .. s.statements.dim])
        {
            inlineScan((*s.statements)[i]);
        }
    }

    override проц посети(ScopeStatement s)
    {
        inlineScan(s.инструкция);
    }

    override проц посети(WhileStatement s)
    {
        inlineScan(s.условие);
        inlineScan(s._body);
    }

    override проц посети(DoStatement s)
    {
        inlineScan(s._body);
        inlineScan(s.условие);
    }

    override проц посети(ForStatement s)
    {
        inlineScan(s._иниц);
        inlineScan(s.условие);
        inlineScan(s.increment);
        inlineScan(s._body);
    }

    override проц посети(ForeachStatement s)
    {
        inlineScan(s.aggr);
        inlineScan(s._body);
    }

    override проц посети(ForeachRangeStatement s)
    {
        inlineScan(s.lwr);
        inlineScan(s.upr);
        inlineScan(s._body);
    }

    override проц посети(IfStatement s)
    {
        inlineScan(s.условие);
        inlineScan(s.ifbody);
        inlineScan(s.elsebody);
    }

    override проц посети(SwitchStatement s)
    {
        //printf("SwitchStatement.inlineScan()\n");
        inlineScan(s.условие);
        inlineScan(s._body);
        Инструкция2 sdefault = s.sdefault;
        inlineScan(sdefault);
        s.sdefault = cast(DefaultStatement)sdefault;
        if (s.cases)
        {
            foreach (i; new бцел[0 .. s.cases.dim])
            {
                Инструкция2 scase = (*s.cases)[i];
                inlineScan(scase);
                (*s.cases)[i] = cast(CaseStatement)scase;
            }
        }
    }

    override проц посети(CaseStatement s)
    {
        //printf("CaseStatement.inlineScan()\n");
        inlineScan(s.exp);
        inlineScan(s.инструкция);
    }

    override проц посети(DefaultStatement s)
    {
        inlineScan(s.инструкция);
    }

    override проц посети(ReturnStatement s)
    {
        //printf("ReturnStatement.inlineScan()\n");
        inlineScan(s.exp);
    }

    override проц посети(SynchronizedStatement s)
    {
        inlineScan(s.exp);
        inlineScan(s._body);
    }

    override проц посети(WithStatement s)
    {
        inlineScan(s.exp);
        inlineScan(s._body);
    }

    override проц посети(TryCatchStatement s)
    {
        inlineScan(s._body);
        if (s.catches)
        {
            foreach (c; *s.catches)
            {
                inlineScan(c.handler);
            }
        }
    }

    override проц посети(TryFinallyStatement s)
    {
        inlineScan(s._body);
        inlineScan(s.finalbody);
    }

    override проц посети(ThrowStatement s)
    {
        inlineScan(s.exp);
    }

    override проц посети(LabelStatement s)
    {
        inlineScan(s.инструкция);
    }

    /********************************
     * Scan Инструкция2 s for inlining opportunities,
     * and if found replace s with an inlined one.
     * Параметры:
     *  s = Инструкция2 to be scanned and updated
     */
    проц inlineScan(ref Инструкция2 s)
    {
        if (!s)
            return;
        assert(sрезультат is null);
        s.прими(this);
        if (sрезультат)
        {
            s = sрезультат;
            sрезультат = null;
        }
    }

    /* -------------------------- */
    проц arrayInlineScan(Выражения* arguments)
    {
        if (arguments)
        {
            foreach (i; new бцел[0 .. arguments.dim])
            {
                inlineScan((*arguments)[i]);
            }
        }
    }

    override проц посети(Выражение e)
    {
    }

    проц scanVar(ДСимвол s)
    {
        //printf("scanVar(%s %s)\n", s.вид(), s.toPrettyChars());
        VarDeclaration vd = s.isVarDeclaration();
        if (vd)
        {
            TupleDeclaration td = vd.toAlias().isTupleDeclaration();
            if (td)
            {
                foreach (i; new бцел[0 .. td.objects.dim])
                {
                    DsymbolExp se = cast(DsymbolExp)(*td.objects)[i];
                    assert(se.op == ТОК2.dSymbol);
                    scanVar(se.s); // TODO
                }
            }
            else if (vd._иниц)
            {
                if (ExpInitializer ie = vd._иниц.isExpInitializer())
                {
                    inlineScan(ie.exp);
                }
            }
        }
        else
        {
            s.прими(this);
        }
    }

    override проц посети(DeclarationExp e)
    {
        //printf("DeclarationExp.inlineScan() %s\n", e.вТкст0());
        scanVar(e.declaration);
    }

    override проц посети(UnaExp e)
    {
        inlineScan(e.e1);
    }

    override проц посети(AssertExp e)
    {
        inlineScan(e.e1);
        inlineScan(e.msg);
    }

    override проц посети(BinExp e)
    {
        inlineScan(e.e1);
        inlineScan(e.e2);
    }

    override проц посети(AssignExp e)
    {
        // Look for NRVO, as inlining NRVO function returns require special handling
        if (e.op == ТОК2.construct && e.e2.op == ТОК2.call)
        {
            auto ce = e.e2.isCallExp();
            if (ce.f && ce.f.nrvo_can && ce.f.nrvo_var) // NRVO
            {
                if (auto ve = e.e1.isVarExp())
                {
                    /* Inlining:
                     *   S s = foo();   // initializing by rvalue
                     *   S s = S(1);    // constructor call
                     */
                    Declaration d = ve.var;
                    if (d.класс_хранения & (STC.out_ | STC.ref_)) // refinit
                        goto L1;
                }
                else
                {
                    /* Inlining:
                     *   this.field = foo();   // inside constructor
                     */
                    inlineScan(e.e1);
                }

                visitCallExp(ce, e.e1, нет);
                if (eрезультат)
                {
                    //printf("call with nrvo: %s ==> %s\n", e.вТкст0(), eрезультат.вТкст0());
                    return;
                }
            }
        }
    L1:
        посети(cast(BinExp)e);
    }

    override проц посети(CallExp e)
    {
        //printf("CallExp.inlineScan() %s\n", e.вТкст0());
        visitCallExp(e, null, нет);
    }

    /**************************************
     * Check function call to see if can be inlined,
     * and then inline it if it can.
     * Параметры:
     *  e = the function call
     *  eret = if !null, then this is the lvalue of the nrvo function результат
     *  asStatements = if inline as statements rather than as an Выражение
     * Возвращает:
     *  this.eрезультат if asStatements == нет
     *  this.sрезультат if asStatements == да
     */
    проц visitCallExp(CallExp e, Выражение eret, бул asStatements)
    {
        inlineScan(e.e1);
        arrayInlineScan(e.arguments);

        //printf("visitCallExp() %s\n", e.вТкст0());
        FuncDeclaration fd;

        проц inlineFd()
        {
            if (!fd || fd == родитель)
                return;

            /* If the arguments generate temporaries that need destruction, the destruction
             * must be done after the function body is executed.
             * The easiest way to accomplish that is to do the inlining as an Выражение.
             * https://issues.dlang.org/show_bug.cgi?ид=16652
             */
            бул asStates = asStatements;
            if (asStates)
            {
                if (fd.inlineStatusExp == ILS.yes)
                    asStates = нет;           // inline as Выражения
                                                // so no need to recompute argumentsNeedDtors()
                else if (argumentsNeedDtors(e.arguments))
                    asStates = нет;
            }

            if (canInline(fd, нет, нет, asStates))
            {
                expandInline(e.место, fd, родитель, eret, null, e.arguments, asStates, e.vthis2, eрезультат, sрезультат, again);
                if (asStatements && eрезультат)
                {
                    sрезультат = new ExpStatement(eрезультат.место, eрезультат);
                    eрезультат = null;
                }
            }
        }

        /* Pattern match various ASTs looking for indirect function calls, delegate calls,
         * function literal calls, delegate literal calls, and dot member calls.
         * If so, and that is only assigned its _иниц.
         * If so, do 'копируй propagation' of the _иниц значение and try to inline it.
         */
        if (auto ve = e.e1.isVarExp())
        {
            fd = ve.var.isFuncDeclaration();
            if (fd)
                // delegate call
                inlineFd();
            else
            {
                // delegate literal call
                auto v = ve.var.isVarDeclaration();
                if (v && v._иниц && v.тип.ty == Tdelegate && onlyOneAssign(v, родитель))
                {
                    //printf("init: %s\n", v._иниц.вТкст0());
                    auto ei = v._иниц.isExpInitializer();
                    if (ei && ei.exp.op == ТОК2.blit)
                    {
                        Выражение e2 = (cast(AssignExp)ei.exp).e2;
                        if (auto fe = e2.isFuncExp())
                        {
                            auto fld = fe.fd;
                            assert(fld.tok == ТОК2.delegate_);
                            fd = fld;
                            inlineFd();
                        }
                        else if (auto de = e2.isDelegateExp())
                        {
                            if (auto ve2 = de.e1.isVarExp())
                            {
                                fd = ve2.var.isFuncDeclaration();
                                inlineFd();
                            }
                        }
                    }
                }
            }
        }
        else if (auto dve = e.e1.isDotVarExp())
        {
            fd = dve.var.isFuncDeclaration();
            if (fd && fd != родитель && canInline(fd, да, нет, asStatements))
            {
                if (dve.e1.op == ТОК2.call && dve.e1.тип.toBasetype().ty == Tstruct)
                {
                    /* To создай ethis, we'll need to take the address
                     * of dve.e1, but this won't work if dve.e1 is
                     * a function call.
                     */
                }
                else
                {
                    expandInline(e.место, fd, родитель, eret, dve.e1, e.arguments, asStatements, e.vthis2, eрезультат, sрезультат, again);
                }
            }
        }
        else if (e.e1.op == ТОК2.star &&
                 (cast(PtrExp)e.e1).e1.op == ТОК2.variable)
        {
            auto ve = e.e1.isPtrExp().e1.isVarExp();
            VarDeclaration v = ve.var.isVarDeclaration();
            if (v && v._иниц && onlyOneAssign(v, родитель))
            {
                //printf("init: %s\n", v._иниц.вТкст0());
                auto ei = v._иниц.isExpInitializer();
                if (ei && ei.exp.op == ТОК2.blit)
                {
                    Выражение e2 = (cast(AssignExp)ei.exp).e2;
                    // function pointer call
                    if (auto se = e2.isSymOffExp())
                    {
                        fd = se.var.isFuncDeclaration();
                        inlineFd();
                    }
                    // function literal call
                    else if (auto fe = e2.isFuncExp())
                    {
                        auto fld = fe.fd;
                        assert(fld.tok == ТОК2.function_);
                        fd = fld;
                        inlineFd();
                    }
                }
            }
        }
        else
            return;

        if (глоб2.парамы.verbose && (eрезультат || sрезультат))
            message("inlined   %s =>\n          %s", fd.toPrettyChars(), родитель.toPrettyChars());

        if (eрезультат && e.тип.ty != Tvoid)
        {
            Выражение ex = eрезультат;
            while (ex.op == ТОК2.comma)
            {
                ex.тип = e.тип;
                ex = ex.isCommaExp().e2;
            }
            ex.тип = e.тип;
        }
    }

    override проц посети(SliceExp e)
    {
        inlineScan(e.e1);
        inlineScan(e.lwr);
        inlineScan(e.upr);
    }

    override проц посети(TupleExp e)
    {
        //printf("TupleExp.inlineScan()\n");
        inlineScan(e.e0);
        arrayInlineScan(e.exps);
    }

    override проц посети(ArrayLiteralExp e)
    {
        //printf("ArrayLiteralExp.inlineScan()\n");
        inlineScan(e.basis);
        arrayInlineScan(e.elements);
    }

    override проц посети(AssocArrayLiteralExp e)
    {
        //printf("AssocArrayLiteralExp.inlineScan()\n");
        arrayInlineScan(e.keys);
        arrayInlineScan(e.values);
    }

    override проц посети(StructLiteralExp e)
    {
        //printf("StructLiteralExp.inlineScan()\n");
        if (e.stageflags & stageInlineScan)
            return;
        цел old = e.stageflags;
        e.stageflags |= stageInlineScan;
        arrayInlineScan(e.elements);
        e.stageflags = old;
    }

    override проц посети(ArrayExp e)
    {
        //printf("ArrayExp.inlineScan()\n");
        inlineScan(e.e1);
        arrayInlineScan(e.arguments);
    }

    override проц посети(CondExp e)
    {
        inlineScan(e.econd);
        inlineScan(e.e1);
        inlineScan(e.e2);
    }

    /********************************
     * Scan Выражение e for inlining opportunities,
     * and if found replace e with an inlined one.
     * Параметры:
     *  e = Выражение to be scanned and updated
     */
    проц inlineScan(ref Выражение e)
    {
        if (!e)
            return;
        assert(eрезультат is null);
        e.прими(this);
        if (eрезультат)
        {
            e = eрезультат;
            eрезультат = null;
        }
    }

    /*************************************
     * Look for function inlining possibilities.
     */
    override проц посети(ДСимвол d)
    {
        // Most Дсимволы aren't functions
    }

    override проц посети(FuncDeclaration fd)
    {
        static if (LOG)
        {
            printf("FuncDeclaration.inlineScan('%s')\n", fd.toPrettyChars());
        }
        if (fd.isUnitTestDeclaration() && !глоб2.парамы.useUnitTests ||
            fd.flags & FUNCFLAG.inlineScanned)
            return;
        if (fd.fbody && !fd.naked)
        {
            auto againsave = again;
            auto parentsave = родитель;
            родитель = fd;
            do
            {
                again = нет;
                fd.inlineNest++;
                fd.flags |= FUNCFLAG.inlineScanned;
                inlineScan(fd.fbody);
                fd.inlineNest--;
            }
            while (again);
            again = againsave;
            родитель = parentsave;
        }
    }

    override проц посети(AttribDeclaration d)
    {
        Дсимволы* decls = d.include(null);
        if (decls)
        {
            foreach (i; new бцел[0 .. decls.dim])
            {
                ДСимвол s = (*decls)[i];
                //printf("AttribDeclaration.inlineScan %s\n", s.вТкст0());
                s.прими(this);
            }
        }
    }

    override проц посети(AggregateDeclaration ad)
    {
        //printf("AggregateDeclaration.inlineScan(%s)\n", вТкст0());
        if (ad.члены)
        {
            foreach (i; new бцел[0 .. ad.члены.dim])
            {
                ДСимвол s = (*ad.члены)[i];
                //printf("inline scan aggregate symbol '%s'\n", s.вТкст0());
                s.прими(this);
            }
        }
    }

    override проц посети(TemplateInstance ti)
    {
        static if (LOG)
        {
            printf("TemplateInstance.inlineScan('%s')\n", ti.вТкст0());
        }
        if (!ti.errors && ti.члены)
        {
            foreach (i; new бцел[0 .. ti.члены.dim])
            {
                ДСимвол s = (*ti.члены)[i];
                s.прими(this);
            }
        }
    }
}

/***********************************************************
 * Test that `fd` can be inlined.
 *
 * Параметры:
 *  hasthis = `да` if the function call has explicit 'this' Выражение.
 *  hdrscan = `да` if the inline scan is for 'D header' content.
 *  statementsToo = `да` if the function call is placed on ExpStatement.
 *      It means more code-block dependent statements in fd body - ForStatement,
 *      ThrowStatement, etc. can be inlined.
 *
 * Возвращает:
 *  да if the function body can be expanded.
 *
 * Todo:
 *  - Would be able to eliminate `hasthis` параметр, because semantic analysis
 *    no longer accepts calls of contextful function without valid 'this'.
 *  - Would be able to eliminate `hdrscan` параметр, because it's always нет.
 */
private бул canInline(FuncDeclaration fd, бул hasthis, бул hdrscan, бул statementsToo)
{
    цел cost;

    static if (CANINLINE_LOG)
    {
        printf("FuncDeclaration.canInline(hasthis = %d, statementsToo = %d, '%s')\n",
            hasthis, statementsToo, fd.toPrettyChars());
    }

    if (fd.needThis() && !hasthis)
        return нет;

    if (fd.inlineNest)
    {
        static if (CANINLINE_LOG)
        {
            printf("\t1: no, inlineNest = %d, semanticRun = %d\n", fd.inlineNest, fd.semanticRun);
        }
        return нет;
    }

    if (fd.semanticRun < PASS.semantic3 && !hdrscan)
    {
        if (!fd.fbody)
            return нет;
        if (!fd.functionSemantic3())
            return нет;
        Module.runDeferredSemantic3();
        if (глоб2.errors)
            return нет;
        assert(fd.semanticRun >= PASS.semantic3done);
    }

    switch (statementsToo ? fd.inlineStatusStmt : fd.inlineStatusExp)
    {
    case ILS.yes:
        static if (CANINLINE_LOG)
        {
            printf("\t1: yes %s\n", fd.вТкст0());
        }
        return да;
    case ILS.no:
        static if (CANINLINE_LOG)
        {
            printf("\t1: no %s\n", fd.вТкст0());
        }
        return нет;
    case ILS.uninitialized:
        break;
    }

    switch (fd.inlining)
    {
    case PINLINE.default_:
        break;
    case PINLINE.always:
        break;
    case PINLINE.never:
        return нет;
    }

    if (fd.тип)
    {
        TypeFunction tf = fd.тип.isTypeFunction();

        // no variadic параметр lists
        if (tf.parameterList.varargs == ВарАрг.variadic)
            goto Lno;

        /* No lazy parameters when inlining by инструкция, as the inliner tries to
         * operate on the created delegate itself rather than the return значение.
         * Discussion: https://github.com/dlang/dmd/pull/6815
         */
        if (statementsToo && fd.parameters)
        {
            foreach (param; *fd.parameters)
            {
                if (param.класс_хранения & STC.lazy_)
                    goto Lno;
            }
        }

        static бул hasDtor(Тип t)
        {
            auto tv = t.baseElemOf();
            return tv.ty == Tstruct || tv.ty == Tclass; // for now assume these might have a destructor
        }

        /* Don't inline a function that returns non-проц, but has
         * no or multiple return Выражение.
         * When inlining as a инструкция:
         * 1. don't inline массив operations, because the order the arguments
         *    get evaluated gets reversed. This is the same issue that e2ir.callfunc()
         *    has with them
         * 2. don't inline when the return значение has a destructor, as it doesn't
         *    get handled properly
         */
        if (tf.следщ && tf.следщ.ty != Tvoid &&
            (!(fd.hasReturnExp & 1) ||
             statementsToo && (fd.isArrayOp || hasDtor(tf.следщ))) &&
            !hdrscan)
        {
            static if (CANINLINE_LOG)
            {
                printf("\t3: no %s\n", fd.вТкст0());
            }
            goto Lno;
        }

        /* https://issues.dlang.org/show_bug.cgi?ид=14560
         * If fd returns проц, all explicit `return;`s
         * must not appear in the expanded результат.
         * See also ReturnStatement.doInlineAs!Инструкция2().
         */
    }

    // cannot inline constructor calls because we need to convert:
    //      return;
    // to:
    //      return this;
    // ensure() has magic properties the inliner loses
    // require() has magic properties too
    // see bug 7699
    // no nested references to this frame
    if (!fd.fbody ||
        fd.идент == Id.ensure ||
        (fd.идент == Id.require &&
         fd.toParent().isFuncDeclaration() &&
         fd.toParent().isFuncDeclaration().needThis()) ||
        !hdrscan && (fd.isSynchronized() ||
                     fd.isImportedSymbol() ||
                     fd.hasNestedFrameRefs() ||
                     (fd.isVirtual() && !fd.isFinalFunc())))
    {
        static if (CANINLINE_LOG)
        {
            printf("\t4: no %s\n", fd.вТкст0());
        }
        goto Lno;
    }

    // cannot inline functions as инструкция if they have multiple
    //  return statements
    if ((fd.hasReturnExp & 16) && statementsToo)
    {
        static if (CANINLINE_LOG)
        {
            printf("\t5: no %s\n", fd.вТкст0());
        }
        goto Lno;
    }

    {
        cost = inlineCostFunction(fd, hasthis, hdrscan);
    }
    static if (CANINLINE_LOG)
    {
        printf("\tcost = %d for %s\n", cost, fd.вТкст0());
    }

    if (tooCostly(cost))
        goto Lno;
    if (!statementsToo && cost > COST_MAX)
        goto Lno;

    if (!hdrscan)
    {
        // Don't modify inlineStatus for header content scan
        if (statementsToo)
            fd.inlineStatusStmt = ILS.yes;
        else
            fd.inlineStatusExp = ILS.yes;

        scope InlineScanVisitor v = new InlineScanVisitor();
        fd.прими(v); // Don't scan recursively for header content scan

        if (fd.inlineStatusExp == ILS.uninitialized)
        {
            // Need to redo cost computation, as some statements or Выражения have been inlined
            cost = inlineCostFunction(fd, hasthis, hdrscan);
            static if (CANINLINE_LOG)
            {
                printf("recomputed cost = %d for %s\n", cost, fd.вТкст0());
            }

            if (tooCostly(cost))
                goto Lno;
            if (!statementsToo && cost > COST_MAX)
                goto Lno;

            if (statementsToo)
                fd.inlineStatusStmt = ILS.yes;
            else
                fd.inlineStatusExp = ILS.yes;
        }
    }
    static if (CANINLINE_LOG)
    {
        printf("\t2: yes %s\n", fd.вТкст0());
    }
    return да;

Lno:
    if (fd.inlining == PINLINE.always)
        fd.выведиОшибку("cannot inline function");

    if (!hdrscan) // Don't modify inlineStatus for header content scan
    {
        if (statementsToo)
            fd.inlineStatusStmt = ILS.no;
        else
            fd.inlineStatusExp = ILS.no;
    }
    static if (CANINLINE_LOG)
    {
        printf("\t2: no %s\n", fd.вТкст0());
    }
    return нет;
}

/***********************************************************
 * Expand a function call inline,
 *      ethis.fd(arguments)
 *
 * Параметры:
 *      callLoc = location of CallExp
 *      fd = function to expand
 *      родитель = function that the call to fd is being expanded into
 *      eret = if !null then the lvalue of where the nrvo return значение goes
 *      ethis = 'this' reference
 *      arguments = arguments passed to fd
 *      asStatements = expand to Инструкции rather than Выражения
 *      eрезультат = if expanding to an Выражение, this is where the Выражение is written to
 *      sрезультат = if expanding to a инструкция, this is where the инструкция is written to
 *      again = if да, then fd can be inline scanned again because there may be
 *           more opportunities for inlining
 */
private проц expandInline(Место callLoc, FuncDeclaration fd, FuncDeclaration родитель, Выражение eret,
        Выражение ethis, Выражения* arguments, бул asStatements, VarDeclaration vthis2,
        out Выражение eрезультат, out Инструкция2 sрезультат, out бул again)
{
    auto tf = fd.тип.isTypeFunction();
    static if (LOG || CANINLINE_LOG || EXPANDINLINE_LOG)
        printf("FuncDeclaration.expandInline('%s', %d)\n", fd.вТкст0(), asStatements);
    static if (EXPANDINLINE_LOG)
    {
        if (eret) printf("\teret = %s\n", eret.вТкст0());
        if (ethis) printf("\tethis = %s\n", ethis.вТкст0());
    }
    scope ids = new InlineDoState(родитель, fd);

    if (fd.isNested())
    {
        if (!родитель.inlinedNestedCallees)
            родитель.inlinedNestedCallees = new FuncDeclarations();
        родитель.inlinedNestedCallees.сунь(fd);
    }

    VarDeclaration vret;    // will be set the function call результат
    if (eret)
    {
        if (auto ve = eret.isVarExp())
        {
            vret = ve.var.isVarDeclaration();
            assert(!(vret.класс_хранения & (STC.out_ | STC.ref_)));
            eret = null;
        }
        else
        {
            /* Inlining:
             *   this.field = foo();   // inside constructor
             */
            auto ei = new ExpInitializer(callLoc, null);
            auto tmp = Идентификатор2.генерируйИд("__retvar");
            vret = new VarDeclaration(fd.место, eret.тип, tmp, ei);
            vret.класс_хранения |= STC.temp | STC.ref_;
            vret.компонаж = LINK.d;
            vret.родитель = родитель;

            ei.exp = new ConstructExp(fd.место, vret, eret);
            ei.exp.тип = vret.тип;

            auto de = new DeclarationExp(fd.место, vret);
            de.тип = Тип.tvoid;
            eret = de;
        }

        if (!asStatements && fd.nrvo_var)
        {
            ids.from.сунь(fd.nrvo_var);
            ids.to.сунь(vret);
        }
    }
    else
    {
        if (!asStatements && fd.nrvo_var)
        {
            auto tmp = Идентификатор2.генерируйИд("__retvar");
            vret = new VarDeclaration(fd.место, fd.nrvo_var.тип, tmp, new VoidInitializer(fd.место));
            assert(!tf.isref);
            vret.класс_хранения = STC.temp | STC.rvalue;
            vret.компонаж = tf.компонаж;
            vret.родитель = родитель;

            auto de = new DeclarationExp(fd.место, vret);
            de.тип = Тип.tvoid;
            eret = de;

            ids.from.сунь(fd.nrvo_var);
            ids.to.сунь(vret);
        }
    }

    // Set up vthis
    VarDeclaration vthis;
    if (ethis)
    {
        Выражение e0;
        ethis = Выражение.extractLast(ethis, e0);
        assert(vthis2 || !fd.isThis2);
        if (vthis2)
        {
            // ук[2] __this = [ethis, this]
            if (ethis.тип.ty == Tstruct)
            {
                // &ethis
                Тип t = ethis.тип.pointerTo();
                ethis = new AddrExp(ethis.место, ethis);
                ethis.тип = t;
            }
            auto elements = new Выражения(2);
            (*elements)[0] = ethis;
            (*elements)[1] = new NullExp(Место.initial, Тип.tvoidptr);
            Выражение ae = new ArrayLiteralExp(vthis2.место, vthis2.тип, elements);
            Выражение ce = new ConstructExp(vthis2.место, vthis2, ae);
            ce.тип = vthis2.тип;
            vthis2._иниц = new ExpInitializer(vthis2.место, ce);
            vthis = vthis2;
        }
        else if (auto ve = ethis.isVarExp())
        {
            vthis = ve.var.isVarDeclaration();
        }
        else
        {
            //assert(ethis.тип.ty != Tpointer);
            if (ethis.тип.ty == Tpointer)
            {
                Тип t = ethis.тип.nextOf();
                ethis = new PtrExp(ethis.место, ethis);
                ethis.тип = t;
            }

            auto ei = new ExpInitializer(fd.место, ethis);
            vthis = new VarDeclaration(fd.место, ethis.тип, Id.This, ei);
            if (ethis.тип.ty != Tclass)
                vthis.класс_хранения = STC.ref_;
            else
                vthis.класс_хранения = STC.in_;
            vthis.компонаж = LINK.d;
            vthis.родитель = родитель;

            ei.exp = new ConstructExp(fd.место, vthis, ethis);
            ei.exp.тип = vthis.тип;

            auto de = new DeclarationExp(fd.место, vthis);
            de.тип = Тип.tvoid;
            e0 = Выражение.combine(e0, de);
        }
        ethis = e0;

        ids.vthis = vthis;
    }

    // Set up parameters
    Выражение eparams;
    if (arguments && arguments.dim)
    {
        assert(fd.parameters.dim == arguments.dim);
        foreach (i; new бцел[0 .. arguments.dim])
        {
            auto vfrom = (*fd.parameters)[i];
            auto arg = (*arguments)[i];

            auto ei = new ExpInitializer(vfrom.место, arg);
            auto vto = new VarDeclaration(vfrom.место, vfrom.тип, vfrom.идент, ei);
            vto.класс_хранения |= vfrom.класс_хранения & (STC.temp | STC.in_ | STC.out_ | STC.lazy_ | STC.ref_);
            vto.компонаж = vfrom.компонаж;
            vto.родитель = родитель;
            //printf("vto = '%s', vto.класс_хранения = x%x\n", vto.вТкст0(), vto.класс_хранения);
            //printf("vto.родитель = '%s'\n", родитель.вТкст0());

            // Even if vto is STC.lazy_, `vto = arg` is handled correctly in glue layer.
            ei.exp = new BlitExp(vto.место, vto, arg);
            ei.exp.тип = vto.тип;

            ids.from.сунь(vfrom);
            ids.to.сунь(vto);

            auto de = new DeclarationExp(vto.место, vto);
            de.тип = Тип.tvoid;
            eparams = Выражение.combine(eparams, de);

            /* If function pointer or delegate parameters are present,
             * inline scan again because if they are initialized to a symbol,
             * any calls to the fp or dg can be inlined.
             */
            if (vfrom.тип.ty == Tdelegate ||
                vfrom.тип.ty == Tpointer && vfrom.тип.nextOf().ty == Tfunction)
            {
                if (auto ve = arg.isVarExp())
                {
                    if (ve.var.isFuncDeclaration())
                        again = да;
                }
                else if (auto se = arg.isSymOffExp())
                {
                    if (se.var.isFuncDeclaration())
                        again = да;
                }
                else if (arg.op == ТОК2.function_ || arg.op == ТОК2.delegate_)
                    again = да;
            }
        }
    }

    if (asStatements)
    {
        /* Construct:
         *  { eret; ethis; eparams; fd.fbody; }
         * or:
         *  { eret; ethis; try { eparams; fd.fbody; } finally { vthis.edtor; } }
         */

        auto as = new Инструкции();
        if (eret)
            as.сунь(new ExpStatement(callLoc, eret));
        if (ethis)
            as.сунь(new ExpStatement(callLoc, ethis));

        auto as2 = as;
        if (vthis && !vthis.isDataseg())
        {
            if (vthis.needsScopeDtor())
            {
                // same with ExpStatement.scopeCode()
                as2 = new Инструкции();
                vthis.класс_хранения |= STC.nodtor;
            }
        }

        if (eparams)
            as2.сунь(new ExpStatement(callLoc, eparams));

        fd.inlineNest++;
        Инструкция2 s = doInlineAs!(Инструкция2)(fd.fbody, ids);
        fd.inlineNest--;
        as2.сунь(s);

        if (as2 != as)
        {
            as.сунь(new TryFinallyStatement(callLoc,
                        new CompoundStatement(callLoc, as2),
                        new DtorExpStatement(callLoc, vthis.edtor, vthis)));
        }

        sрезультат = new ScopeStatement(callLoc, new CompoundStatement(callLoc, as), callLoc);

        static if (EXPANDINLINE_LOG)
            printf("\n[%s] %s expandInline sрезультат =\n%s\n",
                callLoc.вТкст0(), fd.toPrettyChars(), sрезультат.вТкст0());
    }
    else
    {
        /* Construct:
         *  (eret, ethis, eparams, fd.fbody)
         */

        fd.inlineNest++;
        auto e = doInlineAs!(Выражение)(fd.fbody, ids);
        fd.inlineNest--;

        // https://issues.dlang.org/show_bug.cgi?ид=11322
        if (tf.isref)
            e = e.toLvalue(null, null);

        /* If the inlined function returns a копируй of a struct,
         * and then the return значение is используется subsequently as an
         * lvalue, as in a struct return that is then используется as a 'this'.
         * Taking the address of the return значение will be taking the address
         * of the original, not the копируй. Fix this by assigning the return значение to
         * a temporary, then returning the temporary. If the temporary is используется as an
         * lvalue, it will work.
         * This only happens with struct returns.
         * See https://issues.dlang.org/show_bug.cgi?ид=2127 for an example.
         *
         * On constructor call making __inlineretval is merely redundant, because
         * the returned reference is exactly same as vthis, and the 'this' variable
         * already exists at the caller side.
         */
        if (tf.следщ.ty == Tstruct && !fd.nrvo_var && !fd.isCtorDeclaration() &&
            !isConstruction(e))
        {
            /* Generate a new variable to hold the результат and initialize it with the
             * inlined body of the function:
             *   tret __inlineretval = e;
             */
            auto ei = new ExpInitializer(callLoc, e);
            auto tmp = Идентификатор2.генерируйИд("__inlineretval");
            auto vd = new VarDeclaration(callLoc, tf.следщ, tmp, ei);
            vd.класс_хранения = STC.temp | (tf.isref ? STC.ref_ : STC.rvalue);
            vd.компонаж = tf.компонаж;
            vd.родитель = родитель;

            ei.exp = new ConstructExp(callLoc, vd, e);
            ei.exp.тип = vd.тип;

            auto de = new DeclarationExp(callLoc, vd);
            de.тип = Тип.tvoid;

            // Chain the two together:
            //   ( typeof(return) __inlineretval = ( inlined body )) , __inlineretval
            e = Выражение.combine(de, new VarExp(callLoc, vd));
        }

        // https://issues.dlang.org/show_bug.cgi?ид=15210
        if (tf.следщ.ty == Tvoid && e && e.тип.ty != Tvoid)
        {
            e = new CastExp(callLoc, e, Тип.tvoid);
            e.тип = Тип.tvoid;
        }

        eрезультат = Выражение.combine(eрезультат, eret, ethis, eparams);
        eрезультат = Выражение.combine(eрезультат, e);

        static if (EXPANDINLINE_LOG)
            printf("\n[%s] %s expandInline eрезультат = %s\n",
                callLoc.вТкст0(), fd.toPrettyChars(), eрезультат.вТкст0());
    }

    // Need to reevaluate whether родитель can now be inlined
    // in Выражения, as we might have inlined statements
    родитель.inlineStatusExp = ILS.uninitialized;
}

/****************************************************
 * Determine if the значение of `e` is the результат of construction.
 *
 * Параметры:
 *      e = Выражение to check
 * Возвращает:
 *      да for значение generated by a constructor or struct literal
 */
private бул isConstruction(Выражение e)
{
    e = lastComma(e);

    if (e.op == ТОК2.structLiteral)
    {
        return да;
    }
    /* Detect:
     *    structliteral.ctor(args)
     */
    else if (e.op == ТОК2.call)
    {
        auto ce = cast(CallExp)e;
        if (ce.e1.op == ТОК2.dotVariable)
        {
            auto dve = cast(DotVarExp)ce.e1;
            auto fd = dve.var.isFuncDeclaration();
            if (fd && fd.isCtorDeclaration())
            {
                if (dve.e1.op == ТОК2.structLiteral)
                {
                    return да;
                }
            }
        }
    }
    return нет;
}


/***********************************************************
 * Determine if v is 'head const', meaning
 * that once it is initialized it is not changed
 * again.
 *
 * This is done using a primitive flow analysis.
 *
 * v is head const if v is const or const.
 * Otherwise, v is assumed to be head const unless one of the
 * following is да:
 *      1. v is a `ref` or `out` variable
 *      2. v is a параметр and fd is a variadic function
 *      3. v is assigned to again
 *      4. the address of v is taken
 *      5. v is referred to by a function nested within fd
 *      6. v is ever assigned to a `ref` or `out` variable
 *      7. v is ever passed to another function as `ref` or `out`
 *
 * Параметры:
 *      v       variable to check
 *      fd      function that v is local to
 * Возвращает:
 *      да if v's инициализатор is the only значение assigned to v
 */
private бул onlyOneAssign(VarDeclaration v, FuncDeclaration fd)
{
    if (!v.тип.isMutable())
        return да;            // currently the only case handled atm
    return нет;
}

/************************************************************
 * See if arguments to a function are creating temporaries that
 * will need destruction after the function is executed.
 * Параметры:
 *      arguments = arguments to function
 * Возвращает:
 *      да if temporaries need destruction
 */

private бул argumentsNeedDtors(Выражения* arguments)
{
    if (arguments)
    {
        foreach (arg; *arguments)
        {
            if (argNeedsDtor(arg))
                return да;
        }
    }
    return нет;
}

/************************************************************
 * See if argument to a function is creating temporaries that
 * will need destruction after the function is executed.
 * Параметры:
 *      arg = argument to function
 * Возвращает:
 *      да if temporaries need destruction
 */

private бул argNeedsDtor(Выражение arg)
{
     final class NeedsDtor : StoppableVisitor
    {
        alias  typeof(super).посети посети ;
        Выражение arg;

    public:
        this(Выражение arg)
        {
            this.arg = arg;
        }

        override проц посети(Выражение)
        {
        }

        override проц посети(DeclarationExp de)
        {
            if (de != arg)
                Dsymbol_needsDtor(de.declaration);
        }

        проц Dsymbol_needsDtor(ДСимвол s)
        {
            /* This mirrors logic of Dsymbol_toElem() in e2ir.d
             * perhaps they can be combined.
             */

            проц symbolDg(ДСимвол s)
            {
                Dsymbol_needsDtor(s);
            }

            if (auto vd = s.isVarDeclaration())
            {
                s = s.toAlias();
                if (s != vd)
                    return Dsymbol_needsDtor(s);
                else if (vd.isStatic() || vd.класс_хранения & (STC.extern_ | STC.tls | STC.gshared | STC.manifest))
                    return;
                if (vd.needsScopeDtor())
                {
                    stop = да;
                }
            }
            else if (auto tm = s.isTemplateMixin())
            {
                tm.члены.foreachDsymbol(&symbolDg);
            }
            else if (auto ad = s.isAttribDeclaration())
            {
                ad.include(null).foreachDsymbol(&symbolDg);
            }
            else if (auto td = s.isTupleDeclaration())
            {
                foreach (o; *td.objects)
                {
                    if (o.динкаст() == ДИНКАСТ.Выражение)
                    {
                        Выражение eo = cast(Выражение)o;
                        if (eo.op == ТОК2.dSymbol)
                        {
                            DsymbolExp se = cast(DsymbolExp)eo;
                            Dsymbol_needsDtor(se.s);
                        }
                    }
                }
            }


        }
    }

    scope NeedsDtor ct = new NeedsDtor(arg);
    return walkPostorder(arg, ct);
}
