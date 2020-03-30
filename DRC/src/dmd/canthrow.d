/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/canthrow.d, _canthrow.d)
 * Documentation:  https://dlang.org/phobos/dmd_canthrow.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/canthrow.d
 */

module dmd.canthrow;

import dmd.aggregate;
import dmd.apply;
import dmd.arraytypes;
import dmd.attrib;
import dmd.declaration;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dtemplate;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import dmd.init;
import dmd.mtype;
import drc.ast.Node;
import drc.lexer.Tokens;
import drc.ast.Visitor;

/********************************************
 * Возвращает да if the Выражение may throw exceptions.
 * If 'mustNotThrow' is да, generate an error if it throws
 */
 бул canThrow(Выражение e, FuncDeclaration func, бул mustNotThrow)
{
    //printf("Выражение::canThrow(%d) %s\n", mustNotThrow, вТкст0());
    // stop walking if we determine this Выражение can throw
     final class CanThrow : StoppableVisitor
    {
        alias typeof(super).посети посети;
        FuncDeclaration func;
        бул mustNotThrow;

    public:
        this(FuncDeclaration func, бул mustNotThrow)
        {
            this.func = func;
            this.mustNotThrow = mustNotThrow;
        }

        проц checkFuncThrows(Выражение e, FuncDeclaration f)
        {
            auto tf = f.тип.toBasetype().isTypeFunction();
            if (tf && !tf.isnothrow)
            {
                if (mustNotThrow)
                {
                    e.выведиОшибку("%s `%s` is not ``",
                        f.вид(), f.toPrettyChars());
                }
                stop = да;  // if any function throws, then the whole Выражение throws
            }
        }

        override проц посети(Выражение)
        {
        }

        override проц посети(DeclarationExp de)
        {
            stop = Dsymbol_canThrow(de.declaration, func, mustNotThrow);
        }

        override проц посети(CallExp ce)
        {
            if (глоб2.errors && !ce.e1.тип)
                return; // error recovery
            /* If calling a function or delegate that is typed as ,
             * then this Выражение cannot throw.
             * Note that  functions can throw.
             */
            if (ce.f && ce.f == func)
                return;
            Тип t = ce.e1.тип.toBasetype();
            auto tf = t.isTypeFunction();
            if (tf && tf.isnothrow)
                return;
            else
            {
                auto td = t.isTypeDelegate();
                if (td && td.nextOf().isTypeFunction().isnothrow)
                    return;
            }

            if (ce.f)
                checkFuncThrows(ce, ce.f);
            else if (mustNotThrow)
            {
                auto e1 = ce.e1;
                if (auto pe = e1.isPtrExp())   // print 'fp' if e1 is (*fp)
                    e1 = pe.e1;
                ce.выведиОшибку("`%s` is not ``", e1.вТкст0());
            }
            stop = да;
        }

        override проц посети(NewExp ne)
        {
            if (ne.member)
            {
                if (ne.allocator)
                    // https://issues.dlang.org/show_bug.cgi?ид=14407
                    checkFuncThrows(ne, ne.allocator);

                // See if constructor call can throw
                checkFuncThrows(ne, ne.member);
            }
            // regard storage allocation failures as not recoverable
        }

        override проц посети(DeleteExp de)
        {
            Тип tb = de.e1.тип.toBasetype();
            AggregateDeclaration ad = null;
            switch (tb.ty)
            {
            case Tclass:
                ad = tb.isTypeClass().sym;
                break;

            case Tpointer:
            case Tarray:
                auto ts = tb.nextOf().baseElemOf().isTypeStruct();
                if (!ts)
                    return;
                ad = ts.sym;
                break;

            default:
                assert(0);  // error should have been detected by semantic()
            }

            if (ad.dtor)
                checkFuncThrows(de, ad.dtor);
        }

        override проц посети(AssignExp ae)
        {
            // blit-init cannot throw
            if (ae.op == ТОК2.blit)
                return;
            /* Element-wise assignment could invoke postblits.
             */
            Тип t;
            if (ae.тип.toBasetype().ty == Tsarray)
            {
                if (!ae.e2.isLvalue())
                    return;
                t = ae.тип;
            }
            else if (auto se = ae.e1.isSliceExp())
                t = se.e1.тип;
            else
                return;

            if (auto ts = t.baseElemOf().isTypeStruct())
                if (auto postblit = ts.sym.postblit)
                    checkFuncThrows(ae, postblit);
        }

        override проц посети(NewAnonClassExp)
        {
            assert(0); // should have been lowered by semantic()
        }
    }

    scope CanThrow ct = new CanThrow(func, mustNotThrow);
    return walkPostorder(e, ct);
}

/**************************************
 * Does symbol, when initialized, throw?
 * Mirrors logic in Dsymbol_toElem().
 */
private бул Dsymbol_canThrow(ДСимвол s, FuncDeclaration func, бул mustNotThrow)
{
    цел symbolDg(ДСимвол s)
    {
        return Dsymbol_canThrow(s, func, mustNotThrow);
    }

    //printf("Dsymbol_toElem() %s\n", s.вТкст0());
    if (auto vd = s.isVarDeclaration())
    {
        s = s.toAlias();
        if (s != vd)
            return Dsymbol_canThrow(s, func, mustNotThrow);
        if (vd.класс_хранения & STC.manifest)
        {
        }
        else if (vd.isStatic() || vd.класс_хранения & (STC.extern_ | STC.tls | STC.gshared))
        {
        }
        else
        {
            if (vd._иниц)
            {
                if (auto ie = vd._иниц.isExpInitializer())
                    if (canThrow(ie.exp, func, mustNotThrow))
                        return да;
            }
            if (vd.needsScopeDtor())
                return canThrow(vd.edtor, func, mustNotThrow);
        }
    }
    else if (auto ad = s.isAttribDeclaration())
    {
        return ad.include(null).foreachDsymbol(&symbolDg) != 0;
    }
    else if (auto tm = s.isTemplateMixin())
    {
        return tm.члены.foreachDsymbol(&symbolDg) != 0;
    }
    else if (auto td = s.isTupleDeclaration())
    {
        for (т_мера i = 0; i < td.objects.dim; i++)
        {
            КорневойОбъект o = (*td.objects)[i];
            if (o.динкаст() == ДИНКАСТ.Выражение)
            {
                Выражение eo = cast(Выражение)o;
                if (auto se = eo.isDsymbolExp())
                {
                    if (Dsymbol_canThrow(se.s, func, mustNotThrow))
                        return да;
                }
            }
        }
    }
    return нет;
}
