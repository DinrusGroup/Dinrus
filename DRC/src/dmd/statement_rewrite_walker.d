/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/statement_rewrite_walker.d, _statement_rewrite_walker.d)
 * Documentation:  https://dlang.org/phobos/dmd_statement_rewrite_walker.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/statement_rewrite_walker.d
 */

module dmd.statement_rewrite_walker;

import cidrus;

import dmd.инструкция;
import drc.ast.Visitor;


/** A visitor to walk entire statements and provides ability to replace any sub-statements.
 */
 class StatementRewriteWalker : SemanticTimePermissiveVisitor
{
    alias SemanticTimePermissiveVisitor.посети посети;

    /* Point the currently visited инструкция.
     * By using replaceCurrent() method, you can replace AST during walking.
     */
    Инструкция2* ps;

public:
    final проц visitStmt(ref Инструкция2 s)
    {
        ps = &s;
        s.прими(this);
    }

    final проц replaceCurrent(Инструкция2 s)
    {
        *ps = s;
    }

    override проц посети(PeelStatement s)
    {
        if (s.s)
            visitStmt(s.s);
    }

    override проц посети(CompoundStatement s)
    {
        if (s.statements && s.statements.dim)
        {
            for (т_мера i = 0; i < s.statements.dim; i++)
            {
                if ((*s.statements)[i])
                    visitStmt((*s.statements)[i]);
            }
        }
    }

    override проц посети(CompoundDeclarationStatement s)
    {
        посети(cast(CompoundStatement)s);
    }

    override проц посети(UnrolledLoopStatement s)
    {
        if (s.statements && s.statements.dim)
        {
            for (т_мера i = 0; i < s.statements.dim; i++)
            {
                if ((*s.statements)[i])
                    visitStmt((*s.statements)[i]);
            }
        }
    }

    override проц посети(ScopeStatement s)
    {
        if (s.инструкция)
            visitStmt(s.инструкция);
    }

    override проц посети(WhileStatement s)
    {
        if (s._body)
            visitStmt(s._body);
    }

    override проц посети(DoStatement s)
    {
        if (s._body)
            visitStmt(s._body);
    }

    override проц посети(ForStatement s)
    {
        if (s._иниц)
            visitStmt(s._иниц);
        if (s._body)
            visitStmt(s._body);
    }

    override проц посети(ForeachStatement s)
    {
        if (s._body)
            visitStmt(s._body);
    }

    override проц посети(ForeachRangeStatement s)
    {
        if (s._body)
            visitStmt(s._body);
    }

    override проц посети(IfStatement s)
    {
        if (s.ifbody)
            visitStmt(s.ifbody);
        if (s.elsebody)
            visitStmt(s.elsebody);
    }

    override проц посети(SwitchStatement s)
    {
        if (s._body)
            visitStmt(s._body);
    }

    override проц посети(CaseStatement s)
    {
        if (s.инструкция)
            visitStmt(s.инструкция);
    }

    override проц посети(CaseRangeStatement s)
    {
        if (s.инструкция)
            visitStmt(s.инструкция);
    }

    override проц посети(DefaultStatement s)
    {
        if (s.инструкция)
            visitStmt(s.инструкция);
    }

    override проц посети(SynchronizedStatement s)
    {
        if (s._body)
            visitStmt(s._body);
    }

    override проц посети(WithStatement s)
    {
        if (s._body)
            visitStmt(s._body);
    }

    override проц посети(TryCatchStatement s)
    {
        if (s._body)
            visitStmt(s._body);
        if (s.catches && s.catches.dim)
        {
            for (т_мера i = 0; i < s.catches.dim; i++)
            {
                Уловитель c = (*s.catches)[i];
                if (c && c.handler)
                    visitStmt(c.handler);
            }
        }
    }

    override проц посети(TryFinallyStatement s)
    {
        if (s._body)
            visitStmt(s._body);
        if (s.finalbody)
            visitStmt(s.finalbody);
    }

    override проц посети(DebugStatement s)
    {
        if (s.инструкция)
            visitStmt(s.инструкция);
    }

    override проц посети(LabelStatement s)
    {
        if (s.инструкция)
            visitStmt(s.инструкция);
    }
}
