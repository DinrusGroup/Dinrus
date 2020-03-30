/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/blockexit.d, _blockexit.d)
 * Documentation:  https://dlang.org/phobos/dmd_blockexit.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/blockexit.d
 */

module dmd.blockexit;

import cidrus;

import dmd.arraytypes;
import dmd.canthrow;
import dmd.dclass;
import dmd.declaration;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.mtype;
import dmd.инструкция;
import drc.lexer.Tokens;
import drc.ast.Visitor;

/**
 * BE stands for BlockExit.
 *
 * It indicates if a инструкция does transfer control to another block.
 * A block is a sequence of statements enclosed in { }
 */
enum BE : цел
{
    none      = 0,
    fallthru  = 1,
    throw_    = 2,
    return_   = 4,
    goto_     = 8,
    halt      = 0x10,
    break_    = 0x20,
    continue_ = 0x40,
    errthrow  = 0x80,
    any       = (fallthru | throw_ | return_ | goto_ | halt),
}


/*********************************************
 * Determine mask of ways that a инструкция can exit.
 *
 * Only valid after semantic analysis.
 * Параметры:
 *   s = инструкция to check for block exit status
 *   func = function that инструкция s is in
 *   mustNotThrow = generate an error if it throws
 * Возвращает:
 *   BE.xxxx
 */
цел blockExit(Инструкция2 s, FuncDeclaration func, бул mustNotThrow)
{
     final class BlockExit : Визитор2
    {
        alias  Визитор2.посети посети;
    public:
        FuncDeclaration func;
        бул mustNotThrow;
        цел результат;

        this(FuncDeclaration func, бул mustNotThrow)
        {
            this.func = func;
            this.mustNotThrow = mustNotThrow;
            результат = BE.none;
        }

        override проц посети(Инструкция2 s)
        {
            printf("Инструкция2::blockExit(%p)\n", s);
            printf("%s\n", s.вТкст0());
            assert(0);
        }

        override проц посети(ErrorStatement s)
        {
            результат = BE.none;
        }

        override проц посети(ExpStatement s)
        {
            результат = BE.fallthru;
            if (s.exp)
            {
                if (s.exp.op == ТОК2.halt)
                {
                    результат = BE.halt;
                    return;
                }
                if (s.exp.op == ТОК2.assert_)
                {
                    AssertExp a = cast(AssertExp)s.exp;
                    if (a.e1.isBool(нет)) // if it's an assert(0)
                    {
                        результат = BE.halt;
                        return;
                    }
                }
                if (canThrow(s.exp, func, mustNotThrow))
                    результат |= BE.throw_;
            }
        }

        override проц посети(CompileStatement s)
        {
            assert(глоб2.errors);
            результат = BE.fallthru;
        }

        override проц посети(CompoundStatement cs)
        {
            //printf("CompoundStatement.blockExit(%p) %d результат = x%X\n", cs, cs.statements.dim, результат);
            результат = BE.fallthru;
            Инструкция2 slast = null;
            foreach (s; *cs.statements)
            {
                if (s)
                {
                    //printf("результат = x%x\n", результат);
                    //printf("s: %s\n", s.вТкст0());
                    if (результат & BE.fallthru && slast)
                    {
                        slast = slast.last();
                        if (slast && (slast.isCaseStatement() || slast.isDefaultStatement()) && (s.isCaseStatement() || s.isDefaultStatement()))
                        {
                            // Allow if last case/default was empty
                            CaseStatement sc = slast.isCaseStatement();
                            DefaultStatement sd = slast.isDefaultStatement();
                            if (sc && (!sc.инструкция.hasCode() || sc.инструкция.isCaseStatement() || sc.инструкция.isErrorStatement()))
                            {
                            }
                            else if (sd && (!sd.инструкция.hasCode() || sd.инструкция.isCaseStatement() || sd.инструкция.isErrorStatement()))
                            {
                            }
                            else
                            {
                                ткст0 gototype = s.isCaseStatement() ? "case" : "default";
                                s.deprecation("switch case fallthrough - use 'goto %s;' if intended", gototype);
                            }
                        }
                    }

                    if (!(результат & BE.fallthru) && !s.comeFrom())
                    {
                        if (blockExit(s, func, mustNotThrow) != BE.halt && s.hasCode())
                            s.warning("инструкция is not reachable");
                    }
                    else
                    {
                        результат &= ~BE.fallthru;
                        результат |= blockExit(s, func, mustNotThrow);
                    }
                    slast = s;
                }
            }
        }

        override проц посети(UnrolledLoopStatement uls)
        {
            результат = BE.fallthru;
            foreach (s; *uls.statements)
            {
                if (s)
                {
                    цел r = blockExit(s, func, mustNotThrow);
                    результат |= r & ~(BE.break_ | BE.continue_ | BE.fallthru);
                    if ((r & (BE.fallthru | BE.continue_ | BE.break_)) == 0)
                        результат &= ~BE.fallthru;
                }
            }
        }

        override проц посети(ScopeStatement s)
        {
            //printf("ScopeStatement::blockExit(%p)\n", s.инструкция);
            результат = blockExit(s.инструкция, func, mustNotThrow);
        }

        override проц посети(WhileStatement s)
        {
            assert(глоб2.errors);
            результат = BE.fallthru;
        }

        override проц посети(DoStatement s)
        {
            if (s._body)
            {
                результат = blockExit(s._body, func, mustNotThrow);
                if (результат == BE.break_)
                {
                    результат = BE.fallthru;
                    return;
                }
                if (результат & BE.continue_)
                    результат |= BE.fallthru;
            }
            else
                результат = BE.fallthru;
            if (результат & BE.fallthru)
            {
                if (canThrow(s.условие, func, mustNotThrow))
                    результат |= BE.throw_;
                if (!(результат & BE.break_) && s.условие.isBool(да))
                    результат &= ~BE.fallthru;
            }
            результат &= ~(BE.break_ | BE.continue_);
        }

        override проц посети(ForStatement s)
        {
            результат = BE.fallthru;
            if (s._иниц)
            {
                результат = blockExit(s._иниц, func, mustNotThrow);
                if (!(результат & BE.fallthru))
                    return;
            }
            if (s.условие)
            {
                if (canThrow(s.условие, func, mustNotThrow))
                    результат |= BE.throw_;
                if (s.условие.isBool(да))
                    результат &= ~BE.fallthru;
                else if (s.условие.isBool(нет))
                    return;
            }
            else
                результат &= ~BE.fallthru; // the body must do the exiting
            if (s._body)
            {
                цел r = blockExit(s._body, func, mustNotThrow);
                if (r & (BE.break_ | BE.goto_))
                    результат |= BE.fallthru;
                результат |= r & ~(BE.fallthru | BE.break_ | BE.continue_);
            }
            if (s.increment && canThrow(s.increment, func, mustNotThrow))
                результат |= BE.throw_;
        }

        override проц посети(ForeachStatement s)
        {
            результат = BE.fallthru;
            if (canThrow(s.aggr, func, mustNotThrow))
                результат |= BE.throw_;
            if (s._body)
                результат |= blockExit(s._body, func, mustNotThrow) & ~(BE.break_ | BE.continue_);
        }

        override проц посети(ForeachRangeStatement s)
        {
            assert(глоб2.errors);
            результат = BE.fallthru;
        }

        override проц посети(IfStatement s)
        {
            //printf("IfStatement::blockExit(%p)\n", s);
            результат = BE.none;
            if (canThrow(s.условие, func, mustNotThrow))
                результат |= BE.throw_;
            if (s.условие.isBool(да))
            {
                результат |= blockExit(s.ifbody, func, mustNotThrow);
            }
            else if (s.условие.isBool(нет))
            {
                результат |= blockExit(s.elsebody, func, mustNotThrow);
            }
            else
            {
                результат |= blockExit(s.ifbody, func, mustNotThrow);
                результат |= blockExit(s.elsebody, func, mustNotThrow);
            }
            //printf("IfStatement::blockExit(%p) = x%x\n", s, результат);
        }

        override проц посети(ConditionalStatement s)
        {
            результат = blockExit(s.ifbody, func, mustNotThrow);
            if (s.elsebody)
                результат |= blockExit(s.elsebody, func, mustNotThrow);
        }

        override проц посети(PragmaStatement s)
        {
            результат = BE.fallthru;
        }

        override проц посети(StaticAssertStatement s)
        {
            результат = BE.fallthru;
        }

        override проц посети(SwitchStatement s)
        {
            результат = BE.none;
            if (canThrow(s.условие, func, mustNotThrow))
                результат |= BE.throw_;
            if (s._body)
            {
                результат |= blockExit(s._body, func, mustNotThrow);
                if (результат & BE.break_)
                {
                    результат |= BE.fallthru;
                    результат &= ~BE.break_;
                }
            }
            else
                результат |= BE.fallthru;
        }

        override проц посети(CaseStatement s)
        {
            результат = blockExit(s.инструкция, func, mustNotThrow);
        }

        override проц посети(DefaultStatement s)
        {
            результат = blockExit(s.инструкция, func, mustNotThrow);
        }

        override проц посети(GotoDefaultStatement s)
        {
            результат = BE.goto_;
        }

        override проц посети(GotoCaseStatement s)
        {
            результат = BE.goto_;
        }

        override проц посети(SwitchErrorStatement s)
        {
            // Switch errors are non-recoverable
            результат = BE.halt;
        }

        override проц посети(ReturnStatement s)
        {
            результат = BE.return_;
            if (s.exp && canThrow(s.exp, func, mustNotThrow))
                результат |= BE.throw_;
        }

        override проц посети(BreakStatement s)
        {
            //printf("BreakStatement::blockExit(%p) = x%x\n", s, s.идент ? BE.goto_ : BE.break_);
            результат = s.идент ? BE.goto_ : BE.break_;
        }

        override проц посети(ContinueStatement s)
        {
            результат = s.идент ? BE.continue_ | BE.goto_ : BE.continue_;
        }

        override проц посети(SynchronizedStatement s)
        {
            результат = blockExit(s._body, func, mustNotThrow);
        }

        override проц посети(WithStatement s)
        {
            результат = BE.none;
            if (canThrow(s.exp, func, mustNotThrow))
                результат = BE.throw_;
            результат |= blockExit(s._body, func, mustNotThrow);
        }

        override проц посети(TryCatchStatement s)
        {
            assert(s._body);
            результат = blockExit(s._body, func, нет);

            цел catchрезультат = 0;
            foreach (c; *s.catches)
            {
                if (c.тип == Тип.terror)
                    continue;

                цел cрезультат = blockExit(c.handler, func, mustNotThrow);

                /* If we're catching Object, then there is no throwing
                 */
                Идентификатор2 ид = c.тип.toBasetype().isClassHandle().идент;
                if (c.internalCatch && (cрезультат & BE.fallthru))
                {
                    // https://issues.dlang.org/show_bug.cgi?ид=11542
                    // leave blockExit flags of the body
                    cрезультат &= ~BE.fallthru;
                }
                else if (ид == Id.Object || ид == Id.Throwable)
                {
                    результат &= ~(BE.throw_ | BE.errthrow);
                }
                else if (ид == Id.Exception)
                {
                    результат &= ~BE.throw_;
                }
                catchрезультат |= cрезультат;
            }
            if (mustNotThrow && (результат & BE.throw_))
            {
                // now explain why this is 
                blockExit(s._body, func, mustNotThrow);
            }
            результат |= catchрезультат;
        }

        override проц посети(TryFinallyStatement s)
        {
            результат = BE.fallthru;
            if (s._body)
                результат = blockExit(s._body, func, нет);

            // check finally body as well, it may throw (bug #4082)
            цел finalрезультат = BE.fallthru;
            if (s.finalbody)
                finalрезультат = blockExit(s.finalbody, func, нет);

            // If either body or finalbody halts
            if (результат == BE.halt)
                finalрезультат = BE.none;
            if (finalрезультат == BE.halt)
                результат = BE.none;

            if (mustNotThrow)
            {
                // now explain why this is 
                if (s._body && (результат & BE.throw_))
                    blockExit(s._body, func, mustNotThrow);
                if (s.finalbody && (finalрезультат & BE.throw_))
                    blockExit(s.finalbody, func, mustNotThrow);
            }

            version (none)
            {
                // https://issues.dlang.org/show_bug.cgi?ид=13201
                // Mask to prevent spurious warnings for
                // destructor call, exit of synchronized инструкция, etc.
                if (результат == BE.halt && finalрезультат != BE.halt && s.finalbody && s.finalbody.hasCode())
                {
                    s.finalbody.warning("инструкция is not reachable");
                }
            }

            if (!(finalрезультат & BE.fallthru))
                результат &= ~BE.fallthru;
            результат |= finalрезультат & ~BE.fallthru;
        }

        override проц посети(ScopeGuardStatement s)
        {
            // At this point, this инструкция is just an empty placeholder
            результат = BE.fallthru;
        }

        override проц посети(ThrowStatement s)
        {
            if (s.internalThrow)
            {
                // https://issues.dlang.org/show_bug.cgi?ид=8675
                // Allow throwing 'Throwable' объект even if mustNotThrow.
                результат = BE.fallthru;
                return;
            }

            Тип t = s.exp.тип.toBasetype();
            ClassDeclaration cd = t.isClassHandle();
            assert(cd);

            if (cd == ClassDeclaration.errorException || ClassDeclaration.errorException.isBaseOf(cd, null))
            {
                результат = BE.errthrow;
                return;
            }
            if (mustNotThrow)
                s.выведиОшибку("`%s` is thrown but not caught", s.exp.тип.вТкст0());

            результат = BE.throw_;
        }

        override проц посети(GotoStatement s)
        {
            //printf("GotoStatement::blockExit(%p)\n", s);
            результат = BE.goto_;
        }

        override проц посети(LabelStatement s)
        {
            //printf("LabelStatement::blockExit(%p)\n", s);
            результат = blockExit(s.инструкция, func, mustNotThrow);
            if (s.breaks)
                результат |= BE.fallthru;
        }

        override проц посети(CompoundAsmStatement s)
        {
            // Assume the worst
            результат = BE.fallthru | BE.return_ | BE.goto_ | BE.halt;
            if (!(s.stc & STC.nothrow_))
            {
                if (mustNotThrow && !(s.stc & STC.nothrow_))
                    s.deprecation("`asm` инструкция is assumed to throw - mark it with `` if it does not");
                else
                    результат |= BE.throw_;
            }
        }

        override проц посети(ImportStatement s)
        {
            результат = BE.fallthru;
        }
    }

    if (!s)
        return BE.fallthru;
    scope BlockExit be = new BlockExit(func, mustNotThrow);
    s.прими(be);
    return be.результат;
}

