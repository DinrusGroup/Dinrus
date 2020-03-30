/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:    $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/inlinecost.d, _inlinecost.d)
 * Documentation:  https://dlang.org/phobos/dmd_inlinecost.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/inlinecost.d
 */

module dmd.inlinecost;

import cidrus;

import dmd.aggregate;
import dmd.apply;
import dmd.arraytypes;
import dmd.attrib;
import dmd.dclass;
import dmd.declaration;
import dmd.dmodule;
import dmd.dscope;
import dmd.dstruct;
import dmd.дсимвол;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.init;
import dmd.mtype;
import dmd.opover;
import dmd.инструкция;
import drc.lexer.Tokens;
import drc.ast.Visitor;

const COST_MAX = 250;

private const STATEMENT_COST = 0x1000;
private const STATEMENT_COST_MAX = 250 * STATEMENT_COST;

// STATEMENT_COST be power of 2 and greater than COST_MAX
static assert((STATEMENT_COST & (STATEMENT_COST - 1)) == 0);
static assert(STATEMENT_COST > COST_MAX);

/*********************************
 * Determine if too expensive to inline.
 * Параметры:
 *      cost = cost of inlining
 * Возвращает:
 *      да if too costly
 */
бул tooCostly(цел cost)
{
    return ((cost & (STATEMENT_COST - 1)) >= COST_MAX);
}

/*********************************
 * Determine cost of inlining Выражение
 * Параметры:
 *      e = Выражение to determine cost of
 * Возвращает:
 *      cost of inlining e
 */
цел inlineCostВыражение(Выражение e)
{
    scope InlineCostVisitor icv = new InlineCostVisitor(нет, да, да, null);
    icv.ВыражениеInlineCost(e);
    return icv.cost;
}


/*********************************
 * Determine cost of inlining function
 * Параметры:
 *      fd = function to determine cost of
 *      hasthis = if the function call has explicit 'this' Выражение
 *      hdrscan = if generating a header файл
 * Возвращает:
 *      cost of inlining fd
 */
цел inlineCostFunction(FuncDeclaration fd, бул hasthis, бул hdrscan)
{
    scope InlineCostVisitor icv = new InlineCostVisitor(hasthis, hdrscan, нет, fd);
    fd.fbody.прими(icv);
    return icv.cost;
}

/**
 * Indicates if a nested aggregate prevents or not a function to be inlined.
 * It's используется to compute the cost but also to avoid a копируй of the aggregate
 * while the inliner processes.
 *
 * Параметры:
 *      e = the declaration Выражение that may represent an aggregate.
 *
 * Возвращает: `null` if `e` is not an aggregate or if it is an aggregate that
 *      doesn't permit inlining, and the aggregate otherwise.
 */
AggregateDeclaration isInlinableNestedAggregate(DeclarationExp e)
{
    AggregateDeclaration результат;
    if (e.declaration.isAnonymous() && e.declaration.isAttribDeclaration)
    {
        AttribDeclaration ad = e.declaration.isAttribDeclaration;
        if (ad.decl.dim == 1)
        {
            if ((результат = (*ad.decl)[0].isAggregateDeclaration) !is null)
            {
                // classes would have to be destroyed
                if (auto cdecl = результат.isClassDeclaration)
                    return null;
                // if it's a struct: must not have dtor
                StructDeclaration sdecl = результат.isStructDeclaration;
                if (sdecl && (sdecl.fieldDtor || sdecl.dtor))
                    return null;
                // the aggregate must be static
                UnionDeclaration udecl = результат.isUnionDeclaration;
                if ((sdecl || udecl) && !(результат.класс_хранения & STC.static_))
                    return null;

                return результат;
            }
        }
    }
    else if ((результат = e.declaration.isStructDeclaration) !is null)
    {
        return результат;
    }
    else if ((результат = e.declaration.isUnionDeclaration) !is null)
    {
        return результат;
    }
    return null;
}

private:

/***********************************************************
 * Compute cost of inlining.
 *
 * Walk trees to determine if inlining can be done, and if so,
 * if it is too complex to be worth inlining or not.
 */
 final class InlineCostVisitor : Визитор2
{
    alias Визитор2.посети посети;
public:
    цел nested;
    бул hasthis;
    бул hdrscan;       // if inline scan for 'header' content
    бул allowAlloca;
    FuncDeclaration fd;
    цел cost;           // нуль start for subsequent AST

    this()
    {
    }

    this(бул hasthis, бул hdrscan, бул allowAlloca, FuncDeclaration fd)
    {
        this.hasthis = hasthis;
        this.hdrscan = hdrscan;
        this.allowAlloca = allowAlloca;
        this.fd = fd;
    }

    this(InlineCostVisitor icv)
    {
        nested = icv.nested;
        hasthis = icv.hasthis;
        hdrscan = icv.hdrscan;
        allowAlloca = icv.allowAlloca;
        fd = icv.fd;
    }

    override проц посети(Инструкция2 s)
    {
        //printf("Инструкция2.inlineCost = %d\n", COST_MAX);
        //printf("%p\n", s.isScopeStatement());
        //printf("%s\n", s.вТкст0());
        cost += COST_MAX; // default is we can't inline it
    }

    override проц посети(ExpStatement s)
    {
        ВыражениеInlineCost(s.exp);
    }

    override проц посети(CompoundStatement s)
    {
        scope InlineCostVisitor icv = new InlineCostVisitor(this);
        foreach (i; new бцел[0 .. s.statements.dim])
        {
            if (Инструкция2 s2 = (*s.statements)[i])
            {
                /* Specifically allow:
                 *  if (условие)
                 *      return exp1;
                 *  return exp2;
                 */
                IfStatement ifs;
                Инструкция2 s3;
                if ((ifs = s2.isIfStatement()) !is null &&
                    ifs.ifbody &&
                    ifs.ifbody.endsWithReturnStatement() &&
                    !ifs.elsebody &&
                    i + 1 < s.statements.dim &&
                    (s3 = (*s.statements)[i + 1]) !is null &&
                    s3.endsWithReturnStatement()
                   )
                {
                    if (ifs.prm)       // if variables are declared
                    {
                        cost = COST_MAX;
                        return;
                    }
                    ВыражениеInlineCost(ifs.условие);
                    ifs.ifbody.прими(this);
                    s3.прими(this);
                }
                else
                    s2.прими(icv);
                if (tooCostly(icv.cost))
                    break;
            }
        }
        cost += icv.cost;
    }

    override проц посети(UnrolledLoopStatement s)
    {
        scope InlineCostVisitor icv = new InlineCostVisitor(this);
        foreach (s2; *s.statements)
        {
            if (s2)
            {
                s2.прими(icv);
                if (tooCostly(icv.cost))
                    break;
            }
        }
        cost += icv.cost;
    }

    override проц посети(ScopeStatement s)
    {
        cost++;
        if (s.инструкция)
            s.инструкция.прими(this);
    }

    override проц посети(IfStatement s)
    {
        /* Can't declare variables inside ?: Выражения, so
         * we cannot inline if a variable is declared.
         */
        if (s.prm)
        {
            cost = COST_MAX;
            return;
        }
        ВыражениеInlineCost(s.условие);
        /* Specifically allow:
         *  if (условие)
         *      return exp1;
         *  else
         *      return exp2;
         * Otherwise, we can't handle return statements nested in if's.
         */
        if (s.elsebody && s.ifbody && s.ifbody.endsWithReturnStatement() && s.elsebody.endsWithReturnStatement())
        {
            s.ifbody.прими(this);
            s.elsebody.прими(this);
            //printf("cost = %d\n", cost);
        }
        else
        {
            nested += 1;
            if (s.ifbody)
                s.ifbody.прими(this);
            if (s.elsebody)
                s.elsebody.прими(this);
            nested -= 1;
        }
        //printf("IfStatement.inlineCost = %d\n", cost);
    }

    override проц посети(ReturnStatement s)
    {
        // Can't handle return statements nested in if's
        if (nested)
        {
            cost = COST_MAX;
        }
        else
        {
            ВыражениеInlineCost(s.exp);
        }
    }

    override проц посети(ImportStatement s)
    {
    }

    override проц посети(ForStatement s)
    {
        cost += STATEMENT_COST;
        if (s._иниц)
            s._иниц.прими(this);
        if (s.условие)
            s.условие.прими(this);
        if (s.increment)
            s.increment.прими(this);
        if (s._body)
            s._body.прими(this);
        //printf("ForStatement: inlineCost = %d\n", cost);
    }

    override проц посети(ThrowStatement s)
    {
        cost += STATEMENT_COST;
        s.exp.прими(this);
    }

    /* -------------------------- */
    проц ВыражениеInlineCost(Выражение e)
    {
        //printf("ВыражениеInlineCost()\n");
        //e.print();
        if (e)
        {
             final class LambdaInlineCost : StoppableVisitor
            {
                alias  typeof(super).посети посети ;
                InlineCostVisitor icv;

            public:
                this(InlineCostVisitor icv)
                {
                    this.icv = icv;
                }

                override проц посети(Выражение e)
                {
                    e.прими(icv);
                    stop = icv.cost >= COST_MAX;
                }
            }

            scope InlineCostVisitor icv = new InlineCostVisitor(this);
            scope LambdaInlineCost lic = new LambdaInlineCost(icv);
            walkPostorder(e, lic);
            cost += icv.cost;
        }
    }

    override проц посети(Выражение e)
    {
        cost++;
    }

    override проц посети(VarExp e)
    {
        //printf("VarExp.inlineCost3() %s\n", вТкст0());
        Тип tb = e.тип.toBasetype();
        if (auto ts = tb.isTypeStruct())
        {
            StructDeclaration sd = ts.sym;
            if (sd.isNested())
            {
                /* An inner struct will be nested inside another function hierarchy than where
                 * we're inlining into, so don't inline it.
                 * At least not until we figure out how to 'move' the struct to be nested
                 * locally. Example:
                 *   struct S(alias pred) { проц unused_func(); }
                 *   проц abc() { цел w; S!(w) m; }
                 *   проц bar() { abc(); }
                 */
                cost = COST_MAX;
                return;
            }
        }
        FuncDeclaration fd = e.var.isFuncDeclaration();
        if (fd && fd.isNested()) // https://issues.dlang.org/show_bug.cgi?ид=7199 for test case
            cost = COST_MAX;
        else
            cost++;
    }

    override проц посети(ThisExp e)
    {
        //printf("ThisExp.inlineCost3() %s\n", вТкст0());
        if (!fd)
        {
            cost = COST_MAX;
            return;
        }
        if (!hdrscan)
        {
            if (fd.isNested() || !hasthis)
            {
                cost = COST_MAX;
                return;
            }
        }
        cost++;
    }

    override проц посети(StructLiteralExp e)
    {
        //printf("StructLiteralExp.inlineCost3() %s\n", вТкст0());
        if (e.sd.isNested())
            cost = COST_MAX;
        else
            cost++;
    }

    override проц посети(NewExp e)
    {
        //printf("NewExp.inlineCost3() %s\n", e.вТкст0());
        AggregateDeclaration ad = isAggregate(e.newtype);
        if (ad && ad.isNested())
            cost = COST_MAX;
        else
            cost++;
    }

    override проц посети(FuncExp e)
    {
        //printf("FuncExp.inlineCost3()\n");
        // Right now, this makes the function be output to the .obj файл twice.
        cost = COST_MAX;
    }

    override проц посети(DelegateExp e)
    {
        //printf("DelegateExp.inlineCost3()\n");
        cost = COST_MAX;
    }

    override проц посети(DeclarationExp e)
    {
        //printf("DeclarationExp.inlineCost3()\n");
        if (auto vd = e.declaration.isVarDeclaration())
        {
            if (auto td = vd.toAlias().isTupleDeclaration())
            {
                cost = COST_MAX; // finish DeclarationExp.doInlineAs
                return;
            }
            if (!hdrscan && vd.isDataseg())
            {
                cost = COST_MAX;
                return;
            }
            if (vd.edtor)
            {
                // if destructor required
                // needs work to make this work
                cost = COST_MAX;
                return;
            }
            // Scan инициализатор (vd.init)
            if (vd._иниц)
            {
                if (auto ie = vd._иниц.isExpInitializer())
                {
                    ВыражениеInlineCost(ie.exp);
                }
            }
            ++cost;
        }

        // aggregates are accepted under certain circumstances
        if (isInlinableNestedAggregate(e))
        {
            cost++;
            return;
        }

        // These can contain functions, which when copied, get output twice.
        if (e.declaration.isStructDeclaration() ||
            e.declaration.isClassDeclaration()  ||
            e.declaration.isFuncDeclaration()   ||
            e.declaration.isAttribDeclaration() ||
            e.declaration.isTemplateMixin())
        {
            cost = COST_MAX;
            return;
        }
        //printf("DeclarationExp.inlineCost3('%s')\n", вТкст0());
    }

    override проц посети(CallExp e)
    {
        //printf("CallExp.inlineCost3() %s\n", вТкст0());
        // https://issues.dlang.org/show_bug.cgi?ид=3500
        // super.func() calls must be devirtualized, and the inliner
        // can't handle that at present.
        if (e.e1.op == ТОК2.dotVariable && (cast(DotVarExp)e.e1).e1.op == ТОК2.super_)
            cost = COST_MAX;
        else if (e.f && e.f.идент == Id.__alloca && e.f.компонаж == LINK.c && !allowAlloca)
            cost = COST_MAX; // inlining alloca may cause stack overflows
        else
            cost++;
    }
}

