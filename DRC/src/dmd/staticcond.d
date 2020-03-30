/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/staticcond.d, _staticcond.d)
 * Documentation:  https://dlang.org/phobos/dmd_staticcond.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/staticcond.d
 */

module dmd.staticcond;

import dmd.arraytypes;
import dmd.dmodule;
import dmd.dscope;
import dmd.дсимвол;
import dmd.errors;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.globals;
import drc.lexer.Identifier;
import dmd.mtype;
import util.array;
import util.outbuffer;
import drc.lexer.Tokens;



/********************************************
 * Semantically analyze and then evaluate a static условие at compile time.
 * This is special because short circuit operators &&, || and ?: at the top
 * уровень are not semantically analyzed if the результат of the Выражение is not
 * necessary.
 * Параметры:
 *      sc  = instantiating scope
 *      original = original Выражение, for error messages
 *      e =  результатing Выражение
 *      errors = set to `да` if errors occurred
 *      negatives = массив to store negative clauses
 * Возвращает:
 *      да if evaluates to да
 */
бул evalStaticCondition(Scope* sc, Выражение original, Выражение e, out бул errors, Выражения* negatives = null)
{
    if (negatives)
        negatives.устДим(0);

    бул impl(Выражение e)
    {
        if (e.op == ТОК2.not)
        {
            NotExp ne = cast(NotExp)e;
            return !impl(ne.e1);
        }

        if (e.op == ТОК2.andAnd || e.op == ТОК2.orOr)
        {
            LogicalExp aae = cast(LogicalExp)e;
            бул результат = impl(aae.e1);
            if (errors)
                return нет;
            if (e.op == ТОК2.andAnd)
            {
                if (!результат)
                    return нет;
            }
            else
            {
                if (результат)
                    return да;
            }
            результат = impl(aae.e2);
            return !errors && результат;
        }

        if (e.op == ТОК2.question)
        {
            CondExp ce = cast(CondExp)e;
            бул результат = impl(ce.econd);
            if (errors)
                return нет;
            Выражение leg = результат ? ce.e1 : ce.e2;
            результат = impl(leg);
            return !errors && результат;
        }

        Выражение before = e;
        const бцел nerrors = глоб2.errors;

        sc = sc.startCTFE();
        sc.flags |= SCOPE.условие;

        e = e.ВыражениеSemantic(sc);
        e = resolveProperties(sc, e);
        e = e.toBoolean(sc);

        sc = sc.endCTFE();
        e = e.optimize(WANTvalue);

        if (nerrors != глоб2.errors ||
            e.op == ТОК2.error ||
            e.тип.toBasetype() == Тип.terror)
        {
            errors = да;
            return нет;
        }

        e = e.ctfeInterpret();

        if (e.isBool(да))
            return да;
        else if (e.isBool(нет))
        {
            if (negatives)
                negatives.сунь(before);
            return нет;
        }

        e.выведиОшибку("Выражение `%s` is not constant", e.вТкст0());
        errors = да;
        return нет;
    }
    return impl(e);
}

/********************************************
 * Format a static условие as a tree-like structure, marking failed and
 * bypassed Выражения.
 * Параметры:
 *      original = original Выражение
 *      instantiated = instantiated Выражение
 *      negatives = массив with negative clauses from `instantiated` Выражение
 *      full = controls whether it shows the full output or only failed parts
 *      itemCount = returns the number of written clauses
 * Возвращает:
 *      formatted ткст or `null` if the Выражения were `null`, or if the
 *      instantiated Выражение is not based on the original one
 */
ткст0 visualizeStaticCondition(Выражение original, Выражение instantiated,
     Выражение[] negatives, бул full, ref бцел itemCount)
{
    if (!original || !instantiated || original.место !is instantiated.место)
        return null;

    БуфВыв буф;

    if (full)
        itemCount = visualizeFull(original, instantiated, negatives, буф);
    else
        itemCount = visualizeShort(original, instantiated, negatives, буф);

    return буф.extractChars();
}

private бцел visualizeFull(Выражение original, Выражение instantiated,
    Выражение[] negatives, ref БуфВыв буф)
{
    // tree-like structure; traverse and format simultaneously
    бцел count;
    бцел отступ;

    static проц printOr(бцел отступ, ref БуфВыв буф)
    {
        буф.резервируй(отступ * 4 + 8);
        foreach (i; new бцел[0 .. отступ])
            буф.пишиСтр("    ");
        буф.пишиСтр("    or:\n");
    }

    // returns да if satisfied
    бул impl(Выражение orig, Выражение e, бул inverted, бул orOperand, бул unreached)
    {
        ТОК2 op = orig.op;

        // lower all 'not' to the bottom
        // !(A && B) -> !A || !B
        // !(A || B) -> !A && !B
        if (inverted)
        {
            if (op == ТОК2.andAnd)
                op = ТОК2.orOr;
            else if (op == ТОК2.orOr)
                op = ТОК2.andAnd;
        }

        if (op == ТОК2.not)
        {
            NotExp no = cast(NotExp)orig;
            NotExp ne = cast(NotExp)e;
            assert(ne);
            return impl(no.e1, ne.e1, !inverted, orOperand, unreached);
        }
        else if (op == ТОК2.andAnd)
        {
            BinExp bo = cast(BinExp)orig;
            BinExp be = cast(BinExp)e;
            assert(be);
            const r1 = impl(bo.e1, be.e1, inverted, нет, unreached);
            const r2 = impl(bo.e2, be.e2, inverted, нет, unreached || !r1);
            return r1 && r2;
        }
        else if (op == ТОК2.orOr)
        {
            if (!orOperand) // do not отступ A || B || C twice
                отступ++;
            BinExp bo = cast(BinExp)orig;
            BinExp be = cast(BinExp)e;
            assert(be);
            const r1 = impl(bo.e1, be.e1, inverted, да, unreached);
            printOr(отступ, буф);
            const r2 = impl(bo.e2, be.e2, inverted, да, unreached);
            if (!orOperand)
                отступ--;
            return r1 || r2;
        }
        else if (op == ТОК2.question)
        {
            CondExp co = cast(CondExp)orig;
            CondExp ce = cast(CondExp)e;
            assert(ce);
            if (!inverted)
            {
                // rewrite (A ? B : C) as (A && B || !A && C)
                if (!orOperand)
                    отступ++;
                const r1 = impl(co.econd, ce.econd, inverted, нет, unreached);
                const r2 = impl(co.e1, ce.e1, inverted, нет, unreached || !r1);
                printOr(отступ, буф);
                const r3 = impl(co.econd, ce.econd, !inverted, нет, unreached);
                const r4 = impl(co.e2, ce.e2, inverted, нет, unreached || !r3);
                if (!orOperand)
                    отступ--;
                return r1 && r2 || r3 && r4;
            }
            else
            {
                // rewrite !(A ? B : C) as (!A || !B) && (A || !C)
                if (!orOperand)
                    отступ++;
                const r1 = impl(co.econd, ce.econd, inverted, нет, unreached);
                printOr(отступ, буф);
                const r2 = impl(co.e1, ce.e1, inverted, нет, unreached);
                const r12 = r1 || r2;
                const r3 = impl(co.econd, ce.econd, !inverted, нет, unreached || !r12);
                printOr(отступ, буф);
                const r4 = impl(co.e2, ce.e2, inverted, нет, unreached || !r12);
                if (!orOperand)
                    отступ--;
                return (r1 || r2) && (r3 || r4);
            }
        }
        else // 'primitive' Выражение
        {
            буф.резервируй(отступ * 4 + 4);
            foreach (i; new бцел[0 .. отступ])
                буф.пишиСтр("    ");

            // найди its значение; it may be not computed, if there was a short circuit,
            // but we handle this case with `unreached` флаг
            бул значение = да;
            if (!unreached)
            {
                foreach (fe; negatives)
                {
                    if (fe is e)
                    {
                        значение = нет;
                        break;
                    }
                }
            }
            // пиши the marks first
            const satisfied = inverted ? !значение : значение;
            if (!satisfied && !unreached)
                буф.пишиСтр("  > ");
            else if (unreached)
                буф.пишиСтр("  - ");
            else
                буф.пишиСтр("    ");
            // then the Выражение itself
            if (inverted)
                буф.пишиБайт('!');
            буф.пишиСтр(orig.вТкст0);
            буф.нс();
            count++;
            return satisfied;
        }
    }

    impl(original, instantiated, нет, да, нет);
    return count;
}

private бцел visualizeShort(Выражение original, Выражение instantiated,
    Выражение[] negatives, ref БуфВыв буф)
{
    // simple list; somewhat similar to long version, so no comments
    // one difference is that it needs to hold items to display in a stack

    struct Item
    {
        Выражение orig;
        бул inverted;
    }

    МассивДРК!(Item) stack;

    бул impl(Выражение orig, Выражение e, бул inverted)
    {
        ТОК2 op = orig.op;

        if (inverted)
        {
            if (op == ТОК2.andAnd)
                op = ТОК2.orOr;
            else if (op == ТОК2.orOr)
                op = ТОК2.andAnd;
        }

        if (op == ТОК2.not)
        {
            NotExp no = cast(NotExp)orig;
            NotExp ne = cast(NotExp)e;
            assert(ne);
            return impl(no.e1, ne.e1, !inverted);
        }
        else if (op == ТОК2.andAnd)
        {
            BinExp bo = cast(BinExp)orig;
            BinExp be = cast(BinExp)e;
            assert(be);
            бул r = impl(bo.e1, be.e1, inverted);
            r = r && impl(bo.e2, be.e2, inverted);
            return r;
        }
        else if (op == ТОК2.orOr)
        {
            BinExp bo = cast(BinExp)orig;
            BinExp be = cast(BinExp)e;
            assert(be);
            const lbefore = stack.length;
            бул r = impl(bo.e1, be.e1, inverted);
            r = r || impl(bo.e2, be.e2, inverted);
            if (r)
                stack.устДим(lbefore); // purge added positive items
            return r;
        }
        else if (op == ТОК2.question)
        {
            CondExp co = cast(CondExp)orig;
            CondExp ce = cast(CondExp)e;
            assert(ce);
            if (!inverted)
            {
                const lbefore = stack.length;
                бул a = impl(co.econd, ce.econd, inverted);
                a = a && impl(co.e1, ce.e1, inverted);
                бул b;
                if (!a)
                {
                    b = impl(co.econd, ce.econd, !inverted);
                    b = b && impl(co.e2, ce.e2, inverted);
                }
                const r = a || b;
                if (r)
                    stack.устДим(lbefore);
                return r;
            }
            else
            {
                бул a;
                {
                    const lbefore = stack.length;
                    a = impl(co.econd, ce.econd, inverted);
                    a = a || impl(co.e1, ce.e1, inverted);
                    if (a)
                        stack.устДим(lbefore);
                }
                бул b;
                if (a)
                {
                    const lbefore = stack.length;
                    b = impl(co.econd, ce.econd, !inverted);
                    b = b || impl(co.e2, ce.e2, inverted);
                    if (b)
                        stack.устДим(lbefore);
                }
                return a && b;
            }
        }
        else // 'primitive' Выражение
        {
            бул значение = да;
            foreach (fe; negatives)
            {
                if (fe is e)
                {
                    значение = нет;
                    break;
                }
            }
            const satisfied = inverted ? !значение : значение;
            if (!satisfied)
                stack.сунь(Item(orig, inverted));
            return satisfied;
        }
    }

    impl(original, instantiated, нет);

    foreach (i; new бцел[0 .. stack.length])
    {
        // пиши the Выражение only
        буф.пишиСтр("       ");
        if (stack[i].inverted)
            буф.пишиБайт('!');
        буф.пишиСтр(stack[i].orig.вТкст0);
        // here with no trailing newline
        if (i + 1 < stack.length)
            буф.нс();
    }
    return cast(бцел)stack.length;
}
