/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/foreachvar.d, _foreachvar.d)
 * Documentation:  https://dlang.org/phobos/dmd_foreachvar.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/foreachvar.d
 */

module dmd.foreachvar;

import cidrus;

import dmd.apply;
import dmd.arraytypes;
import dmd.attrib;
import dmd.dclass;
import dmd.declaration;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.dtemplate;
import dmd.errors;
import drc.ast.Expression;
import dmd.func;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.init;
import dmd.initsem;
import dmd.mtype;
import dmd.printast;
import util.array;
import drc.ast.Node;
import dmd.инструкция;
import drc.lexer.Tokens;
import drc.ast.Visitor;

/*********************************************
 * Visit each Выражение in e, and call dgVar() on each variable declared in it.
 * Параметры:
 *      e = Выражение tree to посети
 *      dgVar = call when a variable is declared
 */
проц foreachVar(Выражение e, проц delegate(VarDeclaration) dgVar)
{
    if (!e)
        return;

     final class VarWalker : StoppableVisitor
    {
        alias  typeof(super).посети посети ;
        extern (D) проц delegate(VarDeclaration) dgVar;

        this(проц delegate(VarDeclaration) dgVar)
        {
            this.dgVar = dgVar;
        }

        override проц посети(Выражение e)
        {
        }

        override проц посети(ErrorExp e)
        {
        }

        override проц посети(DeclarationExp e)
        {
            VarDeclaration v = e.declaration.isVarDeclaration();
            if (!v)
                return;
            if (TupleDeclaration td = v.toAlias().isTupleDeclaration())
            {
                if (!td.objects)
                    return;
                foreach (o; *td.objects)
                {
                    Выражение ex = выражение_ли(o);
                    DsymbolExp s = ex ? ex.isDsymbolExp() : null;
                    assert(s);
                    VarDeclaration v2 = s.s.isVarDeclaration();
                    assert(v2);
                    dgVar(v2);
                }
            }
            else
                dgVar(v);
            ДСимвол s = v.toAlias();
            if (s == v && !v.isStatic() && v._иниц)
            {
                if (auto ie = v._иниц.isExpInitializer())
                    ie.exp.foreachVar(dgVar);
            }
        }

        override проц посети(IndexExp e)
        {
            if (e.lengthVar)
                dgVar(e.lengthVar);
        }

        override проц посети(SliceExp e)
        {
            if (e.lengthVar)
                dgVar(e.lengthVar);
        }
    }

    scope VarWalker v = new VarWalker(dgVar);
    walkPostorder(e, v);
}

/***************
 * Transitively walk Инструкция2 s, pass Выражения to dgExp(), VarDeclarations to dgVar().
 * Параметры:
 *      s = Инструкция2 to traverse
 *      dgExp = delegate to pass found Выражения to
 *      dgVar = delegate to pass found VarDeclarations to
 */
проц foreachExpAndVar(Инструкция2 s,
        проц delegate(Выражение) dgExp,
        проц delegate(VarDeclaration) dgVar)
{
    проц посети(Инструкция2 s)
    {
        проц visitExp(ExpStatement s)
        {
            if (s.exp)
                dgExp(s.exp);
        }

        проц visitDtorExp(DtorExpStatement s)
        {
            if (s.exp)
                dgExp(s.exp);
        }

        проц visitIf(IfStatement s)
        {
            dgExp(s.условие);
            посети(s.ifbody);
            посети(s.elsebody);
        }

        проц visitDo(DoStatement s)
        {
            dgExp(s.условие);
            посети(s._body);
        }

        проц visitFor(ForStatement s)
        {
            посети(s._иниц);
            if (s.условие)
                dgExp(s.условие);
            if (s.increment)
                dgExp(s.increment);
            посети(s._body);
        }

        проц visitSwitch(SwitchStatement s)
        {
            dgExp(s.условие);
            // Note that the body содержит the Case and Default
            // statements, so we only need to compile the Выражения
            foreach (cs; *s.cases)
            {
                dgExp(cs.exp);
            }
            посети(s._body);
        }

        проц visitCase(CaseStatement s)
        {
            посети(s.инструкция);
        }

        проц visitReturn(ReturnStatement s)
        {
            if (s.exp)
                dgExp(s.exp);
        }

        проц visitCompound(CompoundStatement s)
        {
            if (s.statements)
            {
                foreach (s2; *s.statements)
                {
                    посети(s2);
                }
            }
        }

        проц visitCompoundDeclaration(CompoundDeclarationStatement s)
        {
            visitCompound(s);
        }

        проц visitUnrolledLoop(UnrolledLoopStatement s)
        {
            foreach (s2; *s.statements)
            {
                посети(s2);
            }
        }

        проц visitScope(ScopeStatement s)
        {
            посети(s.инструкция);
        }

        проц visitDefault(DefaultStatement s)
        {
            посети(s.инструкция);
        }

        проц visitWith(WithStatement s)
        {
            // If it is with(Enum) {...}, just execute the body.
            if (s.exp.op == ТОК2.scope_ || s.exp.op == ТОК2.тип)
            {
            }
            else
            {
                dgVar(s.wthis);
                dgExp(s.exp);
            }
            посети(s._body);
        }

        проц visitTryCatch(TryCatchStatement s)
        {
            посети(s._body);
            foreach (ca; *s.catches)
            {
                if (ca.var)
                    dgVar(ca.var);
                посети(ca.handler);
            }
        }

        проц visitTryFinally(TryFinallyStatement s)
        {
            посети(s._body);
            посети(s.finalbody);
        }

        проц visitThrow(ThrowStatement s)
        {
            dgExp(s.exp);
        }

        проц visitLabel(LabelStatement s)
        {
            посети(s.инструкция);
        }

        if (!s)
            return;

        switch (s.stmt)
        {
            case STMT.Exp:                 visitExp(s.isExpStatement()); break;
            case STMT.DtorExp:             visitDtorExp(s.isDtorExpStatement()); break;
            case STMT.Compound:            visitCompound(s.isCompoundStatement()); break;
            case STMT.CompoundDeclaration: visitCompoundDeclaration(s.isCompoundDeclarationStatement()); break;
            case STMT.UnrolledLoop:        visitUnrolledLoop(s.isUnrolledLoopStatement()); break;
            case STMT.Scope:               visitScope(s.isScopeStatement()); break;
            case STMT.Do:                  visitDo(s.isDoStatement()); break;
            case STMT.For:                 visitFor(s.isForStatement()); break;
            case STMT.If:                  visitIf(s.isIfStatement()); break;
            case STMT.Switch:              visitSwitch(s.isSwitchStatement()); break;
            case STMT.Case:                visitCase(s.isCaseStatement()); break;
            case STMT.Default:             visitDefault(s.isDefaultStatement()); break;
            case STMT.Return:              visitReturn(s.isReturnStatement()); break;
            case STMT.With:                visitWith(s.isWithStatement()); break;
            case STMT.TryCatch:            visitTryCatch(s.isTryCatchStatement()); break;
            case STMT.TryFinally:          visitTryFinally(s.isTryFinallyStatement()); break;
            case STMT.Throw:               visitThrow(s.isThrowStatement()); break;
            case STMT.Label:               visitLabel(s.isLabelStatement()); break;

            case STMT.CompoundAsm:
            case STMT.Asm:
            case STMT.InlineAsm:
            case STMT.GccAsm:

            case STMT.Break:
            case STMT.Continue:
            case STMT.GotoDefault:
            case STMT.GotoCase:
            case STMT.SwitchError:
            case STMT.Goto:
            case STMT.Pragma:
            case STMT.Импорт:
            case STMT.Error:
                break;          // ignore these

            case STMT.ScopeGuard:
            case STMT.Foreach:
            case STMT.ForeachRange:
            case STMT.Debug:
            case STMT.CaseRange:
            case STMT.StaticForeach:
            case STMT.StaticAssert:
            case STMT.Conditional:
            case STMT.While:
            case STMT.Forwarding:
            case STMT.Compile:
            case STMT.Peel:
            case STMT.Synchronized:
                assert(0);              // should have been rewritten
        }
    }

    посети(s);
}

