/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/delegatize.d, _delegatize.d)
 * Documentation:  https://dlang.org/phobos/dmd_delegatize.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/delegatize.d
 */

module dmd.delegatize;

import cidrus;
import dmd.apply;
import dmd.declaration;
import dmd.dscope;
import dmd.дсимвол;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.func;
import dmd.globals;
import dmd.init;
import dmd.initsem;
import dmd.mtype;
import dmd.инструкция;
import drc.lexer.Tokens;
import drc.ast.Visitor;


/*********************************
 * Convert Выражение into a delegate.
 *
 * Used to convert the argument to a lazy параметр.
 *
 * Параметры:
 *  e = argument to convert to a delegate
 *  t = the тип to be returned by the delegate
 *  sc = context
 * Возвращает:
 *  A delegate literal
 */
Выражение toDelegate(Выражение e, Тип t, Scope* sc)
{
    //printf("Выражение::toDelegate(t = %s) %s\n", t.вТкст0(), e.вТкст0());
    Место место = e.место;
    auto tf = new TypeFunction(СписокПараметров(), t, LINK.d);
    if (t.hasWild())
        tf.mod = MODFlags.wild;
    auto fld = new FuncLiteralDeclaration(место, место, tf, ТОК2.delegate_, null);
    lambdaSetParent(e, fld);

    sc = sc.сунь();
    sc.родитель = fld; // set current function to be the delegate
    бул r = lambdaCheckForNestedRef(e, sc);
    sc = sc.вынь();
    if (r)
        return new ErrorExp();

    Инструкция2 s;
    if (t.ty == Tvoid)
        s = new ExpStatement(место, e);
    else
        s = new ReturnStatement(место, e);
    fld.fbody = s;
    e = new FuncExp(место, fld);
    e = e.ВыражениеSemantic(sc);
    return e;
}

/******************************************
 * Patch the родитель of declarations to be the new function literal.
 *
 * Since the Выражение is going to be moved into a function literal,
 * the родитель for declarations in the Выражение needs to be
 * сбрось to that function literal.
 * Параметры:
 *   e = Выражение to check
 *   fd = function literal symbol (the new родитель)
 */
private проц lambdaSetParent(Выражение e, FuncDeclaration fd)
{
     final class LambdaSetParent : StoppableVisitor
    {
        alias typeof(super).посети посети;
        FuncDeclaration fd;

        private проц setParent(ДСимвол s)
        {
            VarDeclaration vd = s.isVarDeclaration();
            FuncDeclaration pfd = s.родитель ? s.родитель.isFuncDeclaration() : null;
            s.родитель = fd;
            if (!vd || !pfd)
                return;
            // move to fd's closure when applicable
            foreach (i; new бцел[0 .. pfd.closureVars.dim])
            {
                if (vd == pfd.closureVars[i])
                {
                    pfd.closureVars.удали(i);
                    fd.closureVars.сунь(vd);
                    break;
                }
            }
        }

    public:
        this(FuncDeclaration fd)
        {
            this.fd = fd;
        }

        override проц посети(Выражение)
        {
        }

        override проц посети(DeclarationExp e)
        {
            setParent(e.declaration);
            e.declaration.прими(this);
        }

        override проц посети(IndexExp e)
        {
            if (e.lengthVar)
            {
                //printf("lengthVar\n");
                setParent(e.lengthVar);
                e.lengthVar.прими(this);
            }
        }

        override проц посети(SliceExp e)
        {
            if (e.lengthVar)
            {
                //printf("lengthVar\n");
                setParent(e.lengthVar);
                e.lengthVar.прими(this);
            }
        }

        override проц посети(ДСимвол)
        {
        }

        override проц посети(VarDeclaration v)
        {
            if (v._иниц)
                v._иниц.прими(this);
        }

        override проц посети(Инициализатор)
        {
        }

        override проц посети(ExpInitializer ei)
        {
            walkPostorder(ei.exp ,this);
        }

        override проц посети(StructInitializer si)
        {
            foreach (i, ид; si.field)
                if (Инициализатор iz = si.значение[i])
                    iz.прими(this);
        }

        override проц посети(ArrayInitializer ai)
        {
            foreach (i, ex; ai.index)
            {
                if (ex)
                    walkPostorder(ex, this);
                if (Инициализатор iz = ai.значение[i])
                    iz.прими(this);
            }
        }
    }

    scope LambdaSetParent lsp = new LambdaSetParent(fd);
    walkPostorder(e, lsp);
}

/*******************************************
 * Look for references to variables in a scope enclosing the new function literal.
 *
 * Essentially just calls `checkNestedReference() for each variable reference in `e`.
 * Параметры:
 *      sc = context
 *      e = Выражение to check
 * Возвращает:
 *      да if error occurs.
 */
бул lambdaCheckForNestedRef(Выражение e, Scope* sc)
{
     final class LambdaCheckForNestedRef : StoppableVisitor
    {
        alias  typeof(super).посети посети ;
    public:
        Scope* sc;
        бул результат;

        this(Scope* sc)
        {
            this.sc = sc;
        }

        override проц посети(Выражение)
        {
        }

        override проц посети(SymOffExp e)
        {
            VarDeclaration v = e.var.isVarDeclaration();
            if (v)
                результат = v.checkNestedReference(sc, Место.initial);
        }

        override проц посети(VarExp e)
        {
            VarDeclaration v = e.var.isVarDeclaration();
            if (v)
                результат = v.checkNestedReference(sc, Место.initial);
        }

        override проц посети(ThisExp e)
        {
            if (e.var)
                результат = e.var.checkNestedReference(sc, Место.initial);
        }

        override проц посети(DeclarationExp e)
        {
            VarDeclaration v = e.declaration.isVarDeclaration();
            if (v)
            {
                результат = v.checkNestedReference(sc, Место.initial);
                if (результат)
                    return;
                /* Some Выражения cause the frontend to создай a temporary.
                 * For example, structs with cpctors replace the original
                 * Выражение e with:
                 *  __cpcttmp = __cpcttmp.cpctor(e);
                 *
                 * In this instance, we need to ensure that the original
                 * Выражение e does not have any nested references by
                 * checking the declaration инициализатор too.
                 */
                if (v._иниц && v._иниц.isExpInitializer())
                {
                    Выражение ie = v._иниц.инициализаторВВыражение();
                    результат = lambdaCheckForNestedRef(ie, sc);
                }
            }
        }
    }

    scope LambdaCheckForNestedRef v = new LambdaCheckForNestedRef(sc);
    walkPostorder(e, v);
    return v.результат;
}

/*****************************************
 * See if context `s` is nested within context `p`, meaning
 * it `p` is reachable at runtime by walking the static links.
 * If any of the intervening contexts are function literals,
 * make sure they are delegates.
 * Параметры:
 *      s = inner context
 *      p = outer context
 * Возвращает:
 *      да means it is accessible by walking the context pointers at runtime
 * References:
 *      for static links see https://en.wikipedia.org/wiki/Call_stack#Functions_of_the_call_stack
 */
бул ensureStaticLinkTo(ДСимвол s, ДСимвол p)
{
    while (s)
    {
        if (s == p) // hit!
            return да;

        if (auto fd = s.isFuncDeclaration())
        {
            if (!fd.isThis() && !fd.isNested())
                break;

            // https://issues.dlang.org/show_bug.cgi?ид=15332
            // change to delegate if fd is actually nested.
            if (auto fld = fd.isFuncLiteralDeclaration())
                fld.tok = ТОК2.delegate_;
        }
        if (auto ad = s.isAggregateDeclaration())
        {
            if (ad.класс_хранения & STC.static_)
                break;
        }
        s = s.toParentP(p);
    }
    return нет;
}
