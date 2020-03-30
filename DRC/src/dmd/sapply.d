/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/sparse.d, _sparse.d)
 * Documentation:  https://dlang.org/phobos/dmd_sapply.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/sapply.d
 */

module dmd.sapply;

import dmd.инструкция;
import drc.ast.Visitor;

/**************************************
 * A Инструкция2 tree walker that will посети each Инструкция2 s in the tree,
 * in depth-first evaluation order, and call fp(s,param) on it.
 * fp() signals whether the walking continues with its return значение:
 * Возвращает:
 *      0       continue
 *      1       done
 * It's a bit slower than using virtual functions, but more encapsulated and less brittle.
 * Creating an iterator for this would be much more complex.
 */
 final class PostorderStatementVisitor : StoppableVisitor
{
    alias  typeof(super).посети посети ;
public:
    StoppableVisitor v;

    this(StoppableVisitor v)
    {
        this.v = v;
    }

    бул doCond(Инструкция2 s)
    {
        if (!stop && s)
            s.прими(this);
        return stop;
    }

    бул applyTo(Инструкция2 s)
    {
        s.прими(v);
        stop = v.stop;
        return да;
    }

    override проц посети(Инструкция2 s)
    {
        applyTo(s);
    }

    override проц посети(PeelStatement s)
    {
        doCond(s.s) || applyTo(s);
    }

    override проц посети(CompoundStatement s)
    {
        for (т_мера i = 0; i < s.statements.dim; i++)
            if (doCond((*s.statements)[i]))
                return;
        applyTo(s);
    }

    override проц посети(UnrolledLoopStatement s)
    {
        for (т_мера i = 0; i < s.statements.dim; i++)
            if (doCond((*s.statements)[i]))
                return;
        applyTo(s);
    }

    override проц посети(ScopeStatement s)
    {
        doCond(s.инструкция) || applyTo(s);
    }

    override проц посети(WhileStatement s)
    {
        doCond(s._body) || applyTo(s);
    }

    override проц посети(DoStatement s)
    {
        doCond(s._body) || applyTo(s);
    }

    override проц посети(ForStatement s)
    {
        doCond(s._иниц) || doCond(s._body) || applyTo(s);
    }

    override проц посети(ForeachStatement s)
    {
        doCond(s._body) || applyTo(s);
    }

    override проц посети(ForeachRangeStatement s)
    {
        doCond(s._body) || applyTo(s);
    }

    override проц посети(IfStatement s)
    {
        doCond(s.ifbody) || doCond(s.elsebody) || applyTo(s);
    }

    override проц посети(PragmaStatement s)
    {
        doCond(s._body) || applyTo(s);
    }

    override проц посети(SwitchStatement s)
    {
        doCond(s._body) || applyTo(s);
    }

    override проц посети(CaseStatement s)
    {
        doCond(s.инструкция) || applyTo(s);
    }

    override проц посети(DefaultStatement s)
    {
        doCond(s.инструкция) || applyTo(s);
    }

    override проц посети(SynchronizedStatement s)
    {
        doCond(s._body) || applyTo(s);
    }

    override проц посети(WithStatement s)
    {
        doCond(s._body) || applyTo(s);
    }

    override проц посети(TryCatchStatement s)
    {
        if (doCond(s._body))
            return;
        for (т_мера i = 0; i < s.catches.dim; i++)
            if (doCond((*s.catches)[i].handler))
                return;
        applyTo(s);
    }

    override проц посети(TryFinallyStatement s)
    {
        doCond(s._body) || doCond(s.finalbody) || applyTo(s);
    }

    override проц посети(ScopeGuardStatement s)
    {
        doCond(s.инструкция) || applyTo(s);
    }

    override проц посети(DebugStatement s)
    {
        doCond(s.инструкция) || applyTo(s);
    }

    override проц посети(LabelStatement s)
    {
        doCond(s.инструкция) || applyTo(s);
    }
}

бул walkPostorder(Инструкция2 s, StoppableVisitor v)
{
    scope PostorderStatementVisitor pv = new PostorderStatementVisitor(v);
    s.прими(pv);
    return v.stop;
}
