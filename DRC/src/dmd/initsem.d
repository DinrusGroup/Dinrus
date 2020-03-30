/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/initsem.d, _initsem.d)
 * Documentation:  https://dlang.org/phobos/dmd_initsem.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/initsem.d
 */

module dmd.initsem;

import cidrus;
import core.checkedint;

import dmd.aggregate;
import dmd.aliasthis;
import dmd.arraytypes;
import dmd.dcast;
import dmd.declaration;
import dmd.dscope;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dtemplate;
import dmd.errors;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.init;
import dmd.mtype;
import dmd.opover;
import dmd.инструкция;
import dmd.target;
import drc.lexer.Tokens;
import dmd.typesem;

/********************************
 * If possible, convert массив инициализатор to associative массив инициализатор.
 *
 *  Параметры:
 *     ai = массив инициализатор to be converted
 *
 *  Возвращает:
 *     The converted associative массив инициализатор or ErrorExp if `ai`
 *     is not an associative массив инициализатор.
 */
Выражение toAssocArrayLiteral(ArrayInitializer ai)
{
    Выражение e;
    //printf("ArrayInitializer::toAssocArrayInitializer()\n");
    //static int i; if (++i == 2) assert(0);
    const dim = ai.значение.dim;
    auto keys = new Выражения(dim);
    auto values = new Выражения(dim);
    for (size_t i = 0; i < dim; i++)
    {
        e = ai.index[i];
        if (!e)
            goto Lno;
        (*keys)[i] = e;
        Инициализатор iz = ai.значение[i];
        if (!iz)
            goto Lno;
        e = iz.инициализаторВВыражение();
        if (!e)
            goto Lno;
        (*values)[i] = e;
    }
    e = new AssocArrayLiteralExp(ai.место, keys, values);
    return e;
Lno:
    выведиОшибку(ai.место, "not an associative массив инициализатор");
    return new ErrorExp();
}

/******************************************
 * Perform semantic analysis on init.
 * Параметры:
 *      init = Инициализатор AST узел
 *      sc = context
 *      t = тип that the инициализатор needs to become
 *      needInterpret = if CTFE needs to be run on this,
 *                      such as if it is the инициализатор for a const declaration
 * Возвращает:
 *      `Инициализатор` with completed semantic analysis, `ErrorInitializer` if errors
 *      were encountered
 */
extern(C++) Инициализатор initializerSemantic(Инициализатор init, Scope* sc, Тип t, NeedInterpret needInterpret)
{
    Инициализатор visitVoid(VoidInitializer i)
    {
        i.тип = t;
        return i;
    }

    Инициализатор visitError(ErrorInitializer i)
    {
        return i;
    }

    Инициализатор visitStruct(StructInitializer i)
    {
        //printf("StructInitializer::semantic(t = %s) %s\n", t.вТкст0(), вТкст0());
        t = t.toBasetype();
        if (t.ty == Tsarray && t.nextOf().toBasetype().ty == Tstruct)
            t = t.nextOf().toBasetype();
        if (t.ty == Tstruct)
        {
            StructDeclaration sd = (cast(TypeStruct)t).sym;
            if (sd.ctor)
            {
                выведиОшибку(i.место, "%s `%s` has constructors, cannot use `{ initializers }`, use `%s( initializers )` instead", sd.вид(), sd.вТкст0(), sd.вТкст0());
                return new ErrorInitializer();
            }
            sd.size(i.место);
            if (sd.sizeok != Sizeok.done)
            {
                return new ErrorInitializer();
            }
            const nfields = sd.nonHiddenFields();
            //expandTuples for non-identity arguments?
            auto elements = new Выражения(nfields);
            for (size_t j = 0; j < elements.dim; j++)
                (*elements)[j] = null;
            // Run semantic for explicitly given initializers
            // TODO: this part is slightly different from StructLiteralExp::semantic.
            bool errors = false;
            for (size_t fieldi = 0, j = 0; j < i.field.dim; j++)
            {
                if (Идентификатор2 ид = i.field[j])
                {
                    ДСимвол s = sd.search(i.место, ид);
                    if (!s)
                    {
                        s = sd.search_correct(ид);
                        Место initLoc = i.значение[j].место;
                        if (s)
                            выведиОшибку(initLoc, "`%s` is not a member of `%s`, did you mean %s `%s`?", ид.вТкст0(), sd.вТкст0(), s.вид(), s.вТкст0());
                        else
                            выведиОшибку(initLoc, "`%s` is not a member of `%s`", ид.вТкст0(), sd.вТкст0());
                        return new ErrorInitializer();
                    }
                    s = s.toAlias();
                    // Find out which field index it is
                    for (fieldi = 0; 1; fieldi++)
                    {
                        if (fieldi >= nfields)
                        {
                            выведиОшибку(i.место, "`%s.%s` is not a per-instance initializable field", sd.вТкст0(), s.вТкст0());
                            return new ErrorInitializer();
                        }
                        if (s == sd.fields[fieldi])
                            break;
                    }
                }
                else if (fieldi >= nfields)
                {
                    выведиОшибку(i.место, "too many initializers for `%s`", sd.вТкст0());
                    return new ErrorInitializer();
                }
                VarDeclaration vd = sd.fields[fieldi];
                if ((*elements)[fieldi])
                {
                    выведиОшибку(i.место, "duplicate инициализатор for field `%s`", vd.вТкст0());
                    errors = true;
                    continue;
                }
                if (vd.тип.hasPointers)
                {
                    if ((t.alignment() < target.ptrsize ||
                         (vd.смещение & (target.ptrsize - 1))) &&
                        sc.func && sc.func.setUnsafe())
                    {
                        выведиОшибку(i.место, "field `%s.%s` cannot assign to misaligned pointers in `@safe` code",
                            sd.вТкст0(), vd.вТкст0());
                        errors = true;
                    }
                }
                for (size_t k = 0; k < nfields; k++)
                {
                    VarDeclaration v2 = sd.fields[k];
                    if (vd.isOverlappedWith(v2) && (*elements)[k])
                    {
                        выведиОшибку(i.место, "overlapping initialization for field `%s` and `%s`", v2.вТкст0(), vd.вТкст0());
                        errors = true;
                        continue;
                    }
                }
                assert(sc);
                Инициализатор iz = i.значение[j];
                iz = iz.initializerSemantic(sc, vd.тип.addMod(t.mod), needInterpret);
                Выражение ex = iz.инициализаторВВыражение();
                if (ex.op == ТОК2.error)
                {
                    errors = true;
                    continue;
                }
                i.значение[j] = iz;
                (*elements)[fieldi] = doCopyOrMove(sc, ex);
                ++fieldi;
            }
            if (errors)
            {
                return new ErrorInitializer();
            }
            auto sle = new StructLiteralExp(i.место, sd, elements, t);
            if (!sd.fill(i.место, elements, false))
            {
                return new ErrorInitializer();
            }
            sle.тип = t;
            auto ie = new ExpInitializer(i.место, sle);
            return ie.initializerSemantic(sc, t, needInterpret);
        }
        else if ((t.ty == Tdelegate || t.ty == Tpointer && t.nextOf().ty == Tfunction) && i.значение.dim == 0)
        {
            ТОК2 tok = (t.ty == Tdelegate) ? ТОК2.delegate_ : ТОК2.function_;
            /* Rewrite as empty delegate literal { }
             */
            Тип tf = new TypeFunction(СписокПараметров(), null, LINK.d);
            auto fd = new FuncLiteralDeclaration(i.место, Место.initial, tf, tok, null);
            fd.fbody = new CompoundStatement(i.место, new Инструкции());
            fd.endloc = i.место;
            Выражение e = new FuncExp(i.место, fd);
            auto ie = new ExpInitializer(i.место, e);
            return ie.initializerSemantic(sc, t, needInterpret);
        }
        if (t.ty != Terror)
            выведиОшибку(i.место, "a struct is not a valid инициализатор for a `%s`", t.вТкст0());
        return new ErrorInitializer();
    }

    Инициализатор visitArray(ArrayInitializer i)
    {
        бцел length;
        const бцел amax = 0x80000000;
        bool errors = false;
        //printf("ArrayInitializer::semantic(%s)\n", t.вТкст0());
        if (i.sem) // if semantic() already run
        {
            return i;
        }
        i.sem = true;
        t = t.toBasetype();
        switch (t.ty)
        {
        case Tsarray:
        case Tarray:
            break;
        case Tvector:
            t = (cast(TypeVector)t).basetype;
            break;
        case Taarray:
        case Tstruct: // consider implicit constructor call
            {
                Выражение e;
                // note: MyStruct foo = [1:2, 3:4] is correct code if MyStruct has a this(int[int])
                if (t.ty == Taarray || i.isAssociativeArray())
                    e = i.toAssocArrayLiteral();
                else
                    e = i.инициализаторВВыражение();
                // Bugzilla 13987
                if (!e)
                {
                    выведиОшибку(i.место, "cannot use массив to initialize `%s`", t.вТкст0());
                    goto Lerr;
                }
                auto ei = new ExpInitializer(e.место, e);
                return ei.initializerSemantic(sc, t, needInterpret);
            }
        case Tpointer:
            if (t.nextOf().ty != Tfunction)
                break;
            goto default;
        default:
            выведиОшибку(i.место, "cannot use массив to initialize `%s`", t.вТкст0());
            goto Lerr;
        }
        i.тип = t;
        length = 0;
        for (size_t j = 0; j < i.index.dim; j++)
        {
            Выражение idx = i.index[j];
            if (idx)
            {
                sc = sc.startCTFE();
                idx = idx.ВыражениеSemantic(sc);
                sc = sc.endCTFE();
                idx = idx.ctfeInterpret();
                i.index[j] = idx;
                const uinteger_t idxvalue = idx.toInteger();
                if (idxvalue >= amax)
                {
                    выведиОшибку(i.место, "массив index %llu overflow", cast(ulong) idxvalue);
                    errors = true;
                }
                length = cast(бцел)idxvalue;
                if (idx.op == ТОК2.error)
                    errors = true;
            }
            Инициализатор val = i.значение[j];
            ExpInitializer ei = val.isExpInitializer();
            if (ei && !idx)
                ei.expandTuples = true;
            val = val.initializerSemantic(sc, t.nextOf(), needInterpret);
            if (val.isErrorInitializer())
                errors = true;
            ei = val.isExpInitializer();
            // found a кортеж, expand it
            if (ei && ei.exp.op == ТОК2.кортеж)
            {
                TupleExp te = cast(TupleExp)ei.exp;
                i.index.удали(j);
                i.значение.удали(j);
                for (size_t k = 0; k < te.exps.dim; ++k)
                {
                    Выражение e = (*te.exps)[k];
                    i.index.вставь(j + k, cast(Выражение)null);
                    i.значение.вставь(j + k, new ExpInitializer(e.место, e));
                }
                j--;
                continue;
            }
            else
            {
                i.значение[j] = val;
            }
            length++;
            if (length == 0)
            {
                выведиОшибку(i.место, "массив dimension overflow");
                goto Lerr;
            }
            if (length > i.dim)
                i.dim = length;
        }
        if (t.ty == Tsarray)
        {
            uinteger_t edim = (cast(TypeSArray)t).dim.toInteger();
            if (i.dim > edim)
            {
                выведиОшибку(i.место, "массив инициализатор has %u elements, but массив length is %llu", i.dim, edim);
                goto Lerr;
            }
        }
        if (errors)
            goto Lerr;
        {
            const sz = t.nextOf().size();
            bool overflow;
            const max = mulu(i.dim, sz, overflow);
            if (overflow || max >= amax)
            {
                выведиОшибку(i.место, "массив dimension %llu exceeds max of %llu", cast(ulong) i.dim, cast(ulong)(amax / sz));
                goto Lerr;
            }
            return i;
        }
    Lerr:
        return new ErrorInitializer();
    }

    Инициализатор visitExp(ExpInitializer i)
    {
        //printf("ExpInitializer::semantic(%s), тип = %s\n", i.exp.вТкст0(), t.вТкст0());
        if (needInterpret)
            sc = sc.startCTFE();
        i.exp = i.exp.ВыражениеSemantic(sc);
        i.exp = resolveProperties(sc, i.exp);
        if (needInterpret)
            sc = sc.endCTFE();
        if (i.exp.op == ТОК2.error)
        {
            return new ErrorInitializer();
        }
        бцел olderrors = глоб2.errors;
        if (needInterpret)
        {
            // If the результат will be implicitly cast, move the cast into CTFE
            // to avoid premature truncation of polysemous types.
            // eg real [] x = [1.1, 2.2]; should use real precision.
            if (i.exp.implicitConvTo(t))
            {
                i.exp = i.exp.implicitCastTo(sc, t);
            }
            if (!глоб2.gag && olderrors != глоб2.errors)
            {
                return i;
            }
            i.exp = i.exp.ctfeInterpret();
            if (i.exp.op == ТОК2.voidВыражение)
                выведиОшибку(i.место, "variables cannot be initialized with an Выражение of тип `void`. Use `void` initialization instead.");
        }
        else
        {
            i.exp = i.exp.optimize(WANTvalue);
        }
        if (!глоб2.gag && olderrors != глоб2.errors)
        {
            return i; // Failed, suppress duplicate error messages
        }
        if (i.exp.тип.ty == Ttuple && (cast(КортежТипов)i.exp.тип).arguments.dim == 0)
        {
            Тип et = i.exp.тип;
            i.exp = new TupleExp(i.exp.место, new Выражения());
            i.exp.тип = et;
        }
        if (i.exp.op == ТОК2.тип)
        {
            i.exp.выведиОшибку("инициализатор must be an Выражение, not `%s`", i.exp.вТкст0());
            return new ErrorInitializer();
        }
        // Make sure all pointers are constants
        if (needInterpret && hasNonConstPointers(i.exp))
        {
            i.exp.выведиОшибку("cannot use non-constant CTFE pointer in an инициализатор `%s`", i.exp.вТкст0());
            return new ErrorInitializer();
        }
        Тип tb = t.toBasetype();
        Тип ti = i.exp.тип.toBasetype();
        if (i.exp.op == ТОК2.кортеж && i.expandTuples && !i.exp.implicitConvTo(t))
        {
            return new ExpInitializer(i.место, i.exp);
        }
        /* Look for case of initializing a static массив with a too-short
         * string literal, such as:
         *  char[5] foo = "abc";
         * Allow this by doing an explicit cast, which will lengthen the string
         * literal.
         */
        if (i.exp.op == ТОК2.string_ && tb.ty == Tsarray)
        {
            StringExp se = cast(StringExp)i.exp;
            Тип typeb = se.тип.toBasetype();
            TY tynto = tb.nextOf().ty;
            if (!se.committed &&
                (typeb.ty == Tarray || typeb.ty == Tsarray) &&
                (tynto == Tchar || tynto == Twchar || tynto == Tdchar) &&
                se.numberOfCodeUnits(tynto) < (cast(TypeSArray)tb).dim.toInteger())
            {
                i.exp = se.castTo(sc, t);
                goto L1;
            }
        }
        // Look for implicit constructor call
        if (tb.ty == Tstruct && !(ti.ty == Tstruct && tb.toDsymbol(sc) == ti.toDsymbol(sc)) && !i.exp.implicitConvTo(t))
        {
            StructDeclaration sd = (cast(TypeStruct)tb).sym;
            if (sd.ctor)
            {
                // Rewrite as S().ctor(exp)
                Выражение e;
                e = new StructLiteralExp(i.место, sd, null);
                e = new DotIdExp(i.место, e, Id.ctor);
                e = new CallExp(i.место, e, i.exp);
                e = e.ВыражениеSemantic(sc);
                if (needInterpret)
                    i.exp = e.ctfeInterpret();
                else
                    i.exp = e.optimize(WANTvalue);
            }
            else if (search_function(sd, Id.call))
            {
                /* https://issues.dlang.org/show_bug.cgi?ид=1547
                 *
                 * Look for static opCall
                 *
                 * Rewrite as:
                 *  i.exp = typeof(sd).opCall(arguments)
                 */

                Выражение e = typeDotIdExp(i.место, sd.тип, Id.call);
                e = new CallExp(i.место, e, i.exp);
                e = e.ВыражениеSemantic(sc);
                e = resolveProperties(sc, e);
                if (needInterpret)
                    i.exp = e.ctfeInterpret();
                else
                    i.exp = e.optimize(WANTvalue);
            }
        }
        // Look for the case of statically initializing an массив
        // with a single member.
        if (tb.ty == Tsarray && !tb.nextOf().равен(ti.toBasetype().nextOf()) && i.exp.implicitConvTo(tb.nextOf()))
        {
            /* If the variable is not actually используется in compile time, массив creation is
             * redundant. So delay it until invocation of toВыражение() or toDt().
             */
            t = tb.nextOf();
        }
        if (i.exp.implicitConvTo(t))
        {
            i.exp = i.exp.implicitCastTo(sc, t);
        }
        else
        {
            // Look for mismatch of compile-time known length to emit
            // better diagnostic message, as same as AssignExp::semantic.
            if (tb.ty == Tsarray && i.exp.implicitConvTo(tb.nextOf().arrayOf()) > MATCH.nomatch)
            {
                uinteger_t dim1 = (cast(TypeSArray)tb).dim.toInteger();
                uinteger_t dim2 = dim1;
                if (i.exp.op == ТОК2.arrayLiteral)
                {
                    ArrayLiteralExp ale = cast(ArrayLiteralExp)i.exp;
                    dim2 = ale.elements ? ale.elements.dim : 0;
                }
                else if (i.exp.op == ТОК2.slice)
                {
                    Тип tx = toStaticArrayType(cast(SliceExp)i.exp);
                    if (tx)
                        dim2 = (cast(TypeSArray)tx).dim.toInteger();
                }
                if (dim1 != dim2)
                {
                    i.exp.выведиОшибку("mismatched массив lengths, %d and %d", cast(int)dim1, cast(int)dim2);
                    i.exp = new ErrorExp();
                }
            }
            i.exp = i.exp.implicitCastTo(sc, t);
        }
    L1:
        if (i.exp.op == ТОК2.error)
        {
            return i;
        }
        if (needInterpret)
            i.exp = i.exp.ctfeInterpret();
        else
            i.exp = i.exp.optimize(WANTvalue);
        //printf("-ExpInitializer::semantic(): "); i.exp.print();
        return i;
    }

    switch (init.вид)
    {
        case InitKind.void_:   return visitVoid  (cast(  VoidInitializer)init);
        case InitKind.error:   return visitError (cast( ErrorInitializer)init);
        case InitKind.struct_: return visitStruct(cast(StructInitializer)init);
        case InitKind.массив:   return visitArray (cast( ArrayInitializer)init);
        case InitKind.exp:     return visitExp   (cast(   ExpInitializer)init);
    }
}

/***********************
 * Translate init to an `Выражение` in order to infer the тип.
 * Параметры:
 *      init = `Инициализатор` AST узел
 *      sc = context
 * Возвращает:
 *      an equivalent `ExpInitializer` if successful, or `ErrorInitializer` if it cannot be translated
 */
Инициализатор inferType(Инициализатор init, Scope* sc)
{
    Инициализатор visitVoid(VoidInitializer i)
    {
        выведиОшибку(i.место, "cannot infer тип from void инициализатор");
        return new ErrorInitializer();
    }

    Инициализатор visitError(ErrorInitializer i)
    {
        return i;
    }

    Инициализатор visitStruct(StructInitializer i)
    {
        выведиОшибку(i.место, "cannot infer тип from struct инициализатор");
        return new ErrorInitializer();
    }

    Инициализатор visitArray(ArrayInitializer init)
    {
        //printf("ArrayInitializer::inferType() %s\n", вТкст0());
        Выражения* keys = null;
        Выражения* values;
        if (init.isAssociativeArray())
        {
            keys = new Выражения(init.значение.dim);
            values = new Выражения(init.значение.dim);
            for (size_t i = 0; i < init.значение.dim; i++)
            {
                Выражение e = init.index[i];
                if (!e)
                    goto Lno;
                (*keys)[i] = e;
                Инициализатор iz = init.значение[i];
                if (!iz)
                    goto Lno;
                iz = iz.inferType(sc);
                if (iz.isErrorInitializer())
                {
                    return iz;
                }
                assert(iz.isExpInitializer());
                (*values)[i] = (cast(ExpInitializer)iz).exp;
                assert((*values)[i].op != ТОК2.error);
            }
            Выражение e = new AssocArrayLiteralExp(init.место, keys, values);
            auto ei = new ExpInitializer(init.место, e);
            return ei.inferType(sc);
        }
        else
        {
            auto elements = new Выражения(init.значение.dim);
            elements.нуль();
            for (size_t i = 0; i < init.значение.dim; i++)
            {
                assert(!init.index[i]); // already asserted by isAssociativeArray()
                Инициализатор iz = init.значение[i];
                if (!iz)
                    goto Lno;
                iz = iz.inferType(sc);
                if (iz.isErrorInitializer())
                {
                    return iz;
                }
                assert(iz.isExpInitializer());
                (*elements)[i] = (cast(ExpInitializer)iz).exp;
                assert((*elements)[i].op != ТОК2.error);
            }
            Выражение e = new ArrayLiteralExp(init.место, null, elements);
            auto ei = new ExpInitializer(init.место, e);
            return ei.inferType(sc);
        }
    Lno:
        if (keys)
        {
            выведиОшибку(init.место, "not an associative массив инициализатор");
        }
        else
        {
            выведиОшибку(init.место, "cannot infer тип from массив инициализатор");
        }
        return new ErrorInitializer();
    }

    Инициализатор visitExp(ExpInitializer init)
    {
        //printf("ExpInitializer::inferType() %s\n", вТкст0());
        init.exp = init.exp.ВыражениеSemantic(sc);

        // for static alias this: https://issues.dlang.org/show_bug.cgi?ид=17684
        if (init.exp.op == ТОК2.тип)
            init.exp = resolveAliasThis(sc, init.exp);

        init.exp = resolveProperties(sc, init.exp);
        if (init.exp.op == ТОК2.scope_)
        {
            ScopeExp se = cast(ScopeExp)init.exp;
            TemplateInstance ti = se.sds.isTemplateInstance();
            if (ti && ti.semanticRun == PASS.semantic && !ti.aliasdecl)
                se.выведиОшибку("cannot infer тип from %s `%s`, possible circular dependency", se.sds.вид(), se.вТкст0());
            else
                se.выведиОшибку("cannot infer тип from %s `%s`", se.sds.вид(), se.вТкст0());
            return new ErrorInitializer();
        }

        // Give error for overloaded function addresses
        bool hasOverloads;
        if (auto f = isFuncAddress(init.exp, &hasOverloads))
        {
            if (f.checkForwardRef(init.место))
            {
                return new ErrorInitializer();
            }
            if (hasOverloads && !f.isUnique())
            {
                init.exp.выведиОшибку("cannot infer тип from overloaded function symbol `%s`", init.exp.вТкст0());
                return new ErrorInitializer();
            }
        }
        if (init.exp.op == ТОК2.address)
        {
            AddrExp ae = cast(AddrExp)init.exp;
            if (ae.e1.op == ТОК2.overloadSet)
            {
                init.exp.выведиОшибку("cannot infer тип from overloaded function symbol `%s`", init.exp.вТкст0());
                return new ErrorInitializer();
            }
        }
        if (init.exp.op == ТОК2.error)
        {
            return new ErrorInitializer();
        }
        if (!init.exp.тип)
        {
            return new ErrorInitializer();
        }
        return init;
    }

    switch (init.вид)
    {
        case InitKind.void_:   return visitVoid  (cast(  VoidInitializer)init);
        case InitKind.error:   return visitError (cast( ErrorInitializer)init);
        case InitKind.struct_: return visitStruct(cast(StructInitializer)init);
        case InitKind.массив:   return visitArray (cast( ArrayInitializer)init);
        case InitKind.exp:     return visitExp   (cast(   ExpInitializer)init);
    }
}

/***********************
 * Translate init to an `Выражение`.
 * Параметры:
 *      init = `Инициализатор` AST узел
 *      itype = if not `null`, тип to coerce Выражение to
 * Возвращает:
 *      `Выражение` created, `null` if cannot, `ErrorExp` for other errors
 */
extern (C++) Выражение инициализаторВВыражение(Инициализатор init, Тип itype = null)
{
    Выражение visitVoid(VoidInitializer)
    {
        return null;
    }

    Выражение visitError(ErrorInitializer)
    {
        return new ErrorExp();
    }

    /***************************************
     * This works by transforming a struct инициализатор into
     * a struct literal. In the future, the two should be the
     * same thing.
     */
    Выражение visitStruct(StructInitializer)
    {
        // cannot convert to an Выражение without target 'ad'
        return null;
    }

    /********************************
     * If possible, convert массив инициализатор to массив literal.
     * Otherwise return NULL.
     */
    Выражение visitArray(ArrayInitializer init)
    {
        //printf("ArrayInitializer::toВыражение(), dim = %d\n", dim);
        //static int i; if (++i == 2) assert(0);
        Выражения* elements;
        бцел edim;
        const бцел amax = 0x80000000;
        Тип t = null;
        if (init.тип)
        {
            if (init.тип == Тип.terror)
            {
                return new ErrorExp();
            }
            t = init.тип.toBasetype();
            switch (t.ty)
            {
            case Tvector:
                t = (cast(TypeVector)t).basetype;
                goto case Tsarray;

            case Tsarray:
                uinteger_t adim = (cast(TypeSArray)t).dim.toInteger();
                if (adim >= amax)
                    goto Lno;
                edim = cast(бцел)adim;
                break;

            case Tpointer:
            case Tarray:
                edim = init.dim;
                break;

            default:
                assert(0);
            }
        }
        else
        {
            edim = cast(бцел)init.значение.dim;
            for (size_t i = 0, j = 0; i < init.значение.dim; i++, j++)
            {
                if (init.index[i])
                {
                    if (init.index[i].op == ТОК2.int64)
                    {
                        const uinteger_t idxval = init.index[i].toInteger();
                        if (idxval >= amax)
                            goto Lno;
                        j = cast(size_t)idxval;
                    }
                    else
                        goto Lno;
                }
                if (j >= edim)
                    edim = cast(бцел)(j + 1);
            }
        }
        elements = new Выражения(edim);
        elements.нуль();
        for (size_t i = 0, j = 0; i < init.значение.dim; i++, j++)
        {
            if (init.index[i])
                j = cast(size_t)init.index[i].toInteger();
            assert(j < edim);
            Инициализатор iz = init.значение[i];
            if (!iz)
                goto Lno;
            Выражение ex = iz.инициализаторВВыражение();
            if (!ex)
            {
                goto Lno;
            }
            (*elements)[j] = ex;
        }
        {
            /* Fill in any missing elements with the default инициализатор
             */
            Выражение _иниц = null;
            for (size_t i = 0; i < edim; i++)
            {
                if (!(*elements)[i])
                {
                    if (!init.тип)
                        goto Lno;
                    if (!_иниц)
                        _иниц = (cast(TypeNext)t).следщ.defaultInit(Место.initial);
                    (*elements)[i] = _иниц;
                }
            }

            /* Expand any static массив initializers that are a single Выражение
             * into an массив of them
             */
            if (t)
            {
                Тип tn = t.nextOf().toBasetype();
                if (tn.ty == Tsarray)
                {
                    const dim = cast(size_t)(cast(TypeSArray)tn).dim.toInteger();
                    Тип te = tn.nextOf().toBasetype();
                    foreach (ref e; *elements)
                    {
                        if (te.равен(e.тип))
                        {
                            auto elements2 = new Выражения(dim);
                            foreach (ref e2; *elements2)
                                e2 = e;
                            e = new ArrayLiteralExp(e.место, tn, elements2);
                        }
                    }
                }
            }

            /* If any elements are errors, then the whole thing is an error
             */
            for (size_t i = 0; i < edim; i++)
            {
                Выражение e = (*elements)[i];
                if (e.op == ТОК2.error)
                {
                    return e;
                }
            }

            Выражение e = new ArrayLiteralExp(init.место, init.тип, elements);
            return e;
        }
    Lno:
        return null;
    }

    Выражение visitExp(ExpInitializer i)
    {
        if (itype)
        {
            //printf("ExpInitializer::toВыражение(t = %s) exp = %s\n", itype.вТкст0(), i.exp.вТкст0());
            Тип tb = itype.toBasetype();
            Выражение e = (i.exp.op == ТОК2.construct || i.exp.op == ТОК2.blit) ? (cast(AssignExp)i.exp).e2 : i.exp;
            if (tb.ty == Tsarray && e.implicitConvTo(tb.nextOf()))
            {
                TypeSArray tsa = cast(TypeSArray)tb;
                size_t d = cast(size_t)tsa.dim.toInteger();
                auto elements = new Выражения(d);
                for (size_t j = 0; j < d; j++)
                    (*elements)[j] = e;
                auto ae = new ArrayLiteralExp(e.место, itype, elements);
                return ae;
            }
        }
        return i.exp;
    }


    switch (init.вид)
    {
        case InitKind.void_:   return visitVoid  (cast(  VoidInitializer)init);
        case InitKind.error:   return visitError (cast( ErrorInitializer)init);
        case InitKind.struct_: return visitStruct(cast(StructInitializer)init);
        case InitKind.массив:   return visitArray (cast( ArrayInitializer)init);
        case InitKind.exp:     return visitExp   (cast(   ExpInitializer)init);
    }
}
