/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/typesem.d, _typesem.d)
 * Documentation:  https://dlang.org/phobos/dmd_typesem.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/typesem.d
 */

module dmd.typesem;

import cidrus;

import dmd.access;
import dmd.aggregate;
import dmd.aliasthis;
import dmd.arrayop;
import dmd.arraytypes;
import drc.ast.AstCodegen;
import dmd.complex;
import dmd.dcast;
import dmd.dclass;
import dmd.declaration;
import dmd.denum;
import dmd.dimport;
import dmd.dmangle;
import dmd.dmodule : Module;
import dmd.dscope;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.dtemplate;
import dmd.errors;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.func;
import dmd.globals;
import dmd.hdrgen;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.imphint;
import dmd.init;
import dmd.initsem;
import drc.ast.Visitor;
import dmd.mtype;
import dmd.objc;
import dmd.opover;
import drc.parser.Parser2;
import util.ctfloat;
import util.rmem;
import util.outbuffer;
import drc.ast.Node;
import util.string;
import util.stringtable;
import dmd.semantic3;
import dmd.sideeffect;
import dmd.target;
import drc.lexer.Tokens;
import dmd.typesem;
import dmd.traits : semanticTraits;
import dmd.access : mostVisibleOverload;
/**************************
 * This evaluates exp while setting length to be the number
 * of elements in the кортеж t.
 */
private Выражение semanticLength(Scope* sc, Тип t, Выражение exp)
{
    if (auto tt = t.isTypeTuple())
    {
        ScopeDsymbol sym = new ArrayScopeSymbol(sc, tt);
        sym.родитель = sc.scopesym;
        sc = sc.сунь(sym);
        sc = sc.startCTFE();
        exp = exp.ВыражениеSemantic(sc);
        sc = sc.endCTFE();
        sc.вынь();
    }
    else
    {
        sc = sc.startCTFE();
        exp = exp.ВыражениеSemantic(sc);
        sc = sc.endCTFE();
    }
    return exp;
}

private Выражение semanticLength(Scope* sc, TupleDeclaration tup, Выражение exp)
{
    ScopeDsymbol sym = new ArrayScopeSymbol(sc, tup);
    sym.родитель = sc.scopesym;

    sc = sc.сунь(sym);
    sc = sc.startCTFE();
    exp = exp.ВыражениеSemantic(sc);
    sc = sc.endCTFE();
    sc.вынь();

    return exp;
}

/*************************************
 * Resolve a кортеж index.
 */
private проц resolveTupleIndex(ref Место место, Scope* sc, ДСимвол s, Выражение* pe, Тип* pt, ДСимвол* ps, КорневойОбъект oindex)
{
    *pt = null;
    *ps = null;
    *pe = null;

    auto tup = s.isTupleDeclaration();

    auto eindex = выражение_ли(oindex);
    auto tindex = тип_ли(oindex);
    auto sindex = isDsymbol(oindex);

    if (!tup)
    {
        // It's really an index Выражение
        if (tindex)
            eindex = new TypeExp(место, tindex);
        else if (sindex)
            eindex = symbolToExp(sindex, место, sc, нет);
        Выражение e = new IndexExp(место, symbolToExp(s, место, sc, нет), eindex);
        e = e.ВыражениеSemantic(sc);
        resolveExp(e, pt, pe, ps);
        return;
    }

    // Convert oindex to Выражение, then try to resolve to constant.
    if (tindex)
        tindex.resolve(место, sc, &eindex, &tindex, &sindex);
    if (sindex)
        eindex = symbolToExp(sindex, место, sc, нет);
    if (!eindex)
    {
        .выведиОшибку(место, "index `%s` is not an Выражение", oindex.вТкст0());
        *pt = Тип.terror;
        return;
    }

    eindex = semanticLength(sc, tup, eindex);
    eindex = eindex.ctfeInterpret();
    if (eindex.op == ТОК2.error)
    {
        *pt = Тип.terror;
        return;
    }
    const uinteger_t d = eindex.toUInteger();
    if (d >= tup.objects.dim)
    {
        .выведиОшибку(место, "кортеж index `%llu` exceeds length %u", d, tup.objects.dim);
        *pt = Тип.terror;
        return;
    }

    КорневойОбъект o = (*tup.objects)[cast(т_мера)d];
    *pt = тип_ли(o);
    *ps = isDsymbol(o);
    *pe = выражение_ли(o);
    if (*pt)
        *pt = (*pt).typeSemantic(место, sc);
    if (*pe)
        resolveExp(*pe, pt, pe, ps);
}

/*************************************
 * Takes an массив of Идентификаторы and figures out if
 * it represents a Тип, Выражение, or ДСимвол.
 * Параметры:
 *      mt = массив of identifiers
 *      место = location for error messages
 *      sc = context
 *      s = symbol to start search at
 *      scopesym = unused
 *      pe = set if Выражение
 *      pt = set if тип
 *      ps = set if symbol
 *      typeid = set if in TypeidВыражение https://dlang.org/spec/Выражение.html#TypeidВыражение
 */
private проц resolveHelper(TypeQualified mt, ref Место место, Scope* sc, ДСимвол s, ДСимвол scopesym,
    Выражение* pe, Тип* pt, ДСимвол* ps, бул intypeid = нет)
{
    version (none)
    {
        printf("TypeQualified::resolveHelper(sc = %p, idents = '%s')\n", sc, mt.вТкст0());
        if (scopesym)
            printf("\tscopesym = '%s'\n", scopesym.вТкст0());
    }
    *pe = null;
    *pt = null;
    *ps = null;

    if (!s)
    {
        /* Look for what user might have intended
         */
        const p = mt.mutableOf().unSharedOf().вТкст0();
        auto ид = Идентификатор2.idPool(p, cast(бцел)strlen(p));
        if(auto n = importHint(ид.вТкст()))
            выведиОшибку(место, "`%s` is not defined, perhaps `import %.*s;` ?", p, cast(цел)n.length, n.ptr);
        else if (auto s2 = sc.search_correct(ид))
            выведиОшибку(место, "undefined идентификатор `%s`, did you mean %s `%s`?", p, s2.вид(), s2.вТкст0());
        else if(auto q = Scope.search_correct_C(ид))
            выведиОшибку(место, "undefined идентификатор `%s`, did you mean `%s`?", p, q);
        else
            выведиОшибку(место, "undefined идентификатор `%s`", p);

        *pt = Тип.terror;
        return;
    }

    //printf("\t1: s = '%s' %p, вид = '%s'\n",s.вТкст0(), s, s.вид());
    Declaration d = s.isDeclaration();
    if (d && (d.класс_хранения & STC.шаблонпараметр))
        s = s.toAlias();
    else
    {
        // check for deprecated or disabled ники
        s.checkDeprecated(место, sc);
        if (d)
            d.checkDisabled(место, sc, да);
    }
    s = s.toAlias();
    //printf("\t2: s = '%s' %p, вид = '%s'\n",s.вТкст0(), s, s.вид());
    for (т_мера i = 0; i < mt.idents.dim; i++)
    {
        КорневойОбъект ид = mt.idents[i];
        if (ид.динкаст() == ДИНКАСТ.Выражение ||
            ид.динкаст() == ДИНКАСТ.тип)
        {
            Тип tx;
            Выражение ex;
            ДСимвол sx;
            resolveTupleIndex(место, sc, s, &ex, &tx, &sx, ид);
            if (sx)
            {
                s = sx.toAlias();
                continue;
            }
            if (tx)
                ex = new TypeExp(место, tx);
            assert(ex);

            ex = typeToВыражениеHelper(mt, ex, i + 1);
            ex = ex.ВыражениеSemantic(sc);
            resolveExp(ex, pt, pe, ps);
            return;
        }

        Тип t = s.getType(); // тип symbol, тип alias, or тип кортеж?
        бцел errorsave = глоб2.errors;
        цел flags = t is null ? SearchLocalsOnly : IgnorePrivateImports;

        ДСимвол sm = s.searchX(место, sc, ид, flags);
        if (sm && !(sc.flags & SCOPE.ignoresymbolvisibility) && !symbolIsVisible(sc, sm))
        {
            .выведиОшибку(место, "`%s` is not visible from module `%s`", sm.toPrettyChars(), sc._module.вТкст0());
            sm = null;
        }
        if (глоб2.errors != errorsave)
        {
            *pt = Тип.terror;
            return;
        }

        проц helper3()
        {
            Выражение e;
            VarDeclaration v = s.isVarDeclaration();
            FuncDeclaration f = s.isFuncDeclaration();
            if (intypeid || !v && !f)
                e = symbolToExp(s, место, sc, да);
            else
                e = new VarExp(место, s.isDeclaration(), да);

            e = typeToВыражениеHelper(mt, e, i);
            e = e.ВыражениеSemantic(sc);
            resolveExp(e, pt, pe, ps);
        }

        //printf("\t3: s = %p %s %s, sm = %p\n", s, s.вид(), s.вТкст0(), sm);
        if (intypeid && !t && sm && sm.needThis())
            return helper3();

        if (VarDeclaration v = s.isVarDeclaration())
        {
            // https://issues.dlang.org/show_bug.cgi?ид=19913
            // v.тип would be null if it is a forward referenced member.
            if (v.тип is null)
                v.dsymbolSemantic(sc);
            if (v.класс_хранения & (STC.const_ | STC.immutable_ | STC.manifest) ||
                v.тип.isConst() || v.тип.isImmutable())
            {
                // https://issues.dlang.org/show_bug.cgi?ид=13087
                // this.field is not constant always
                if (!v.isThisDeclaration())
                    return helper3();
            }
        }
        if (!sm)
        {
            if (!t)
            {
                if (s.isDeclaration()) // var, func, or кортеж declaration?
                {
                    t = s.isDeclaration().тип;
                    if (!t && s.isTupleDeclaration()) // Выражение кортеж?
                        return helper3();
                }
                else if (s.isTemplateInstance() ||
                         s.isImport() || s.isPackage() || s.isModule())
                {
                    return helper3();
                }
            }
            if (t)
            {
                sm = t.toDsymbol(sc);
                if (sm && ид.динкаст() == ДИНКАСТ.идентификатор)
                {
                    sm = sm.search(место, cast(Идентификатор2)ид, IgnorePrivateImports);
                    if (!sm)
                        return helper3();
                }
                else
                    return helper3();
            }
            else
            {
                if (ид.динкаст() == ДИНКАСТ.дсимвол)
                {
                    // searchX already handles errors for template instances
                    assert(глоб2.errors);
                }
                else
                {
                    assert(ид.динкаст() == ДИНКАСТ.идентификатор);
                    sm = s.search_correct(cast(Идентификатор2)ид);
                    if (sm)
                        выведиОшибку(место, "идентификатор `%s` of `%s` is not defined, did you mean %s `%s`?", ид.вТкст0(), mt.вТкст0(), sm.вид(), sm.вТкст0());
                    else
                        выведиОшибку(место, "идентификатор `%s` of `%s` is not defined", ид.вТкст0(), mt.вТкст0());
                }
                *pe = new ErrorExp();
                return;
            }
        }
        s = sm.toAlias();
    }

    if (auto em = s.isEnumMember())
    {
        // It's not a тип, it's an Выражение
        *pe = em.getVarExp(место, sc);
        return;
    }
    if (auto v = s.isVarDeclaration())
    {
        /* This is mostly same with DsymbolExp::semantic(), but we cannot use it
         * because some variables используется in тип context need to prevent lowering
         * to a literal or contextful Выражение. For example:
         *
         *  enum a = 1; alias b = a;
         *  template X(alias e){ alias v = e; }  alias x = X!(1);
         *  struct S { цел v; alias w = v; }
         *      // TypeIdentifier 'a', 'e', and 'v' should be ТОК2.variable,
         *      // because getDsymbol() need to work in AliasDeclaration::semantic().
         */
        if (!v.тип ||
            !v.тип.deco && v.inuse)
        {
            if (v.inuse) // https://issues.dlang.org/show_bug.cgi?ид=9494
                выведиОшибку(место, "circular reference to %s `%s`", v.вид(), v.toPrettyChars());
            else
                выведиОшибку(место, "forward reference to %s `%s`", v.вид(), v.toPrettyChars());
            *pt = Тип.terror;
            return;
        }
        if (v.тип.ty == Terror)
            *pt = Тип.terror;
        else
            *pe = new VarExp(место, v);
        return;
    }
    if (auto fld = s.isFuncLiteralDeclaration())
    {
        //printf("'%s' is a function literal\n", fld.вТкст0());
        *pe = new FuncExp(место, fld);
        *pe = (*pe).ВыражениеSemantic(sc);
        return;
    }
    version (none)
    {
        if (FuncDeclaration fd = s.isFuncDeclaration())
        {
            *pe = new DsymbolExp(место, fd);
            return;
        }
    }

    Тип t;
    while (1)
    {
        t = s.getType();
        if (t)
            break;
        // If the symbol is an import, try looking inside the import
        if (Импорт si = s.isImport())
        {
            s = si.search(место, s.идент);
            if (s && s != si)
                continue;
            s = si;
        }
        *ps = s;
        return;
    }

    if (auto ti = t.isTypeInstance())
        if (ti != mt && !ti.deco)
        {
            if (!ti.tempinst.errors)
                выведиОшибку(место, "forward reference to `%s`", ti.вТкст0());
            *pt = Тип.terror;
            return;
        }

    if (t.ty == Ttuple)
        *pt = t;
    else
        *pt = t.merge();
}

/************************************
 * Transitively search a тип for all function types.
 * If any function types with parameters are found that have параметр identifiers
 * or default arguments, удали those and создай a new тип stripped of those.
 * This is используется to determine the "canonical" version of a тип which is useful for
 * comparisons.
 * Параметры:
 *      t = тип to scan
 * Возвращает:
 *      `t` if no параметр identifiers or default arguments found, otherwise a new тип that is
 *      the same as t but with no параметр identifiers or default arguments.
 */
private Тип stripDefaultArgs(Тип t)
{
    static Параметры* stripParams(Параметры* parameters)
    {
        static Параметр2 stripParameter(Параметр2 p)
        {
            Тип t = stripDefaultArgs(p.тип);
            return (t != p.тип || p.defaultArg || p.идент || p.userAttribDecl)
                ? new Параметр2(p.классХранения, t, null, null, null)
                : null;
        }

        if (parameters)
        {
            foreach (i, p; *parameters)
            {
                Параметр2 ps = stripParameter(p);
                if (ps)
                {
                    // Replace парамы with a копируй we can modify
                    Параметры* nparams = new Параметры(parameters.dim);

                    foreach (j, ref np; *nparams)
                    {
                        Параметр2 pj = (*parameters)[j];
                        if (j < i)
                            np = pj;
                        else if (j == i)
                            np = ps;
                        else
                        {
                            Параметр2 nps = stripParameter(pj);
                            np = nps ? nps : pj;
                        }
                    }
                    return nparams;
                }
            }
        }
        return parameters;
    }

    if (t is null)
        return t;

    if (auto tf = t.isTypeFunction())
    {
        Тип tret = stripDefaultArgs(tf.следщ);
        Параметры* парамы = stripParams(tf.parameterList.parameters);
        if (tret == tf.следщ && парамы == tf.parameterList.parameters)
            return t;
        TypeFunction tr = cast(TypeFunction)tf.копируй();
        tr.parameterList.parameters = парамы;
        tr.следщ = tret;
        //printf("strip %s\n   <- %s\n", tr.вТкст0(), t.вТкст0());
        return tr;
    }
    else if (auto tt = t.isTypeTuple())
    {
        Параметры* args = stripParams(tt.arguments);
        if (args == tt.arguments)
            return t;
        КортежТипов tr = cast(КортежТипов)t.копируй();
        tr.arguments = args;
        return tr;
    }
    else if (t.ty == Tenum)
    {
        // TypeEnum::nextOf() may be != NULL, but it's not necessary here.
        return t;
    }
    else
    {
        Тип tn = t.nextOf();
        Тип n = stripDefaultArgs(tn);
        if (n == tn)
            return t;
        TypeNext tr = cast(TypeNext)t.копируй();
        tr.следщ = n;
        return tr;
    }
}

/******************************************
 * We've mistakenly parsed `t` as a тип.
 * Redo `t` as an Выражение.
 * Параметры:
 *      t = mistaken тип
 * Возвращает:
 *      t redone as Выражение, null if cannot
 */
Выражение типВВыражение(Тип t)
{
    static Выражение visitSArray(TypeSArray t)
    {
        if (auto e = t.следщ.типВВыражение())
            return new ArrayExp(t.dim.место, e, t.dim);
        return null;
    }

    static Выражение visitAArray(TypeAArray t)
    {
        if (auto e = t.следщ.типВВыражение())
        {
            if (auto ei = t.index.типВВыражение())
                return new ArrayExp(t.место, e, ei);
        }
        return null;
    }

    static Выражение visitIdentifier(TypeIdentifier t)
    {
        return typeToВыражениеHelper(t, new IdentifierExp(t.место, t.идент));
    }

    static Выражение visitInstance(TypeInstance t)
    {
        return typeToВыражениеHelper(t, new ScopeExp(t.место, t.tempinst));
    }

    // easy way to enable 'auto v = new цел[mixin("exp")];' in 2.088+
    static Выражение visitMixin(TypeMixin t)
    {
        return new TypeExp(t.место, t);
    }

    switch (t.ty)
    {
        case Tsarray:   return visitSArray(cast(TypeSArray) t);
        case Taarray:   return visitAArray(cast(TypeAArray) t);
        case Tident:    return visitIdentifier(cast(TypeIdentifier) t);
        case Tinstance: return visitInstance(cast(TypeInstance) t);
        case Tmixin:    return visitMixin(cast(TypeMixin) t);
        default:        return null;
    }
}

/* Helper function for `типВВыражение`. Contains common code
 * for TypeQualified derived classes.
 */
Выражение typeToВыражениеHelper(TypeQualified t, Выражение e, т_мера i = 0)
{
    //printf("toВыражениеHelper(e = %s %s)\n", Сема2.вТкст0(e.op), e.вТкст0());
    foreach (ид; t.idents[i .. t.idents.dim])
    {
        //printf("\t[%d] e: '%s', ид: '%s'\n", i, e.вТкст0(), ид.вТкст0());

        switch (ид.динкаст())
        {
            // ... '. идент'
            case ДИНКАСТ.идентификатор:
                e = new DotIdExp(e.место, e, cast(Идентификатор2)ид);
                break;

            // ... '. имя!(tiargs)'
            case ДИНКАСТ.дсимвол:
                auto ti = (cast(ДСимвол)ид).isTemplateInstance();
                assert(ti);
                e = new DotTemplateInstanceExp(e.место, e, ti.имя, ti.tiargs);
                break;

            // ... '[тип]'
            case ДИНКАСТ.тип:          // https://issues.dlang.org/show_bug.cgi?ид=1215
                e = new ArrayExp(t.место, e, new TypeExp(t.место, cast(Тип)ид));
                break;

            // ... '[expr]'
            case ДИНКАСТ.Выражение:    // https://issues.dlang.org/show_bug.cgi?ид=1215
                e = new ArrayExp(t.место, e, cast(Выражение)ид);
                break;

            case ДИНКАСТ.объект:
            case ДИНКАСТ.кортеж:
            case ДИНКАСТ.параметр:
            case ДИНКАСТ.инструкция:
            case ДИНКАСТ.условие:
            case ДИНКАСТ.шаблонпараметр:
                assert(0);
        }
    }
    return e;
}

/******************************************
 * Perform semantic analysis on a тип.
 * Параметры:
 *      t = Тип AST узел
 *      место = the location of the тип
 *      sc = context
 * Возвращает:
 *      `Тип` with completed semantic analysis, `Terror` if errors
 *      were encountered
 */
/*extern(C++)*/ Тип typeSemantic(Тип t, Место место, Scope* sc)
{
    static Тип выведиОшибку()
    {
        return Тип.terror;
    }

    Тип visitType(Тип t)
    {
        if (t.ty == Tint128 || t.ty == Tuns128)
        {
            .выведиОшибку(место, "`cent` and `ucent` types not implemented");
            return выведиОшибку();
        }

        return t.merge();
    }

    Тип visitVector(TypeVector mtype)
    {
        const errors = глоб2.errors;
        mtype.basetype = mtype.basetype.typeSemantic(место, sc);
        if (errors != глоб2.errors)
            return выведиОшибку();
        mtype.basetype = mtype.basetype.toBasetype().mutableOf();
        if (mtype.basetype.ty != Tsarray)
        {
            .выведиОшибку(место, "T in __vector(T) must be a static массив, not `%s`", mtype.basetype.вТкст0());
            return выведиОшибку();
        }
        TypeSArray t = cast(TypeSArray)mtype.basetype;
        const sz = cast(цел)t.size(место);
        switch (target.isVectorTypeSupported(sz, t.nextOf()))
        {
        case 0:
            // valid
            break;

        case 1:
            // no support at all
            .выведиОшибку(место, "SIMD vector types not supported on this platform");
            return выведиОшибку();

        case 2:
            // invalid base тип
            .выведиОшибку(место, "vector тип `%s` is not supported on this platform", mtype.вТкст0());
            return выведиОшибку();

        case 3:
            // invalid size
            .выведиОшибку(место, "%d byte vector тип `%s` is not supported on this platform", sz, mtype.вТкст0());
            return выведиОшибку();
        }
        return merge(mtype);
    }

    Тип visitSArray(TypeSArray mtype)
    {
        //printf("TypeSArray::semantic() %s\n", вТкст0());
        Тип t;
        Выражение e;
        ДСимвол s;
        mtype.следщ.resolve(место, sc, &e, &t, &s);

        if (auto tup = s ? s.isTupleDeclaration() : null)
        {
            mtype.dim = semanticLength(sc, tup, mtype.dim);
            mtype.dim = mtype.dim.ctfeInterpret();
            if (mtype.dim.op == ТОК2.error)
                return выведиОшибку();

            uinteger_t d = mtype.dim.toUInteger();
            if (d >= tup.objects.dim)
            {
                .выведиОшибку(место, "кортеж index %llu exceeds %llu", cast(бдол)d, cast(бдол)tup.objects.dim);
                return выведиОшибку();
            }

            КорневойОбъект o = (*tup.objects)[cast(т_мера)d];
            if (o.динкаст() != ДИНКАСТ.тип)
            {
                .выведиОшибку(место, "`%s` is not a тип", mtype.вТкст0());
                return выведиОшибку();
            }
            return (cast(Тип)o).addMod(mtype.mod);
        }

        Тип tn = mtype.следщ.typeSemantic(место, sc);
        if (tn.ty == Terror)
            return выведиОшибку();

        Тип tbn = tn.toBasetype();
        if (mtype.dim)
        {
            //https://issues.dlang.org/show_bug.cgi?ид=15478
            if (mtype.dim.isDotVarExp())
            {
                if (Declaration vd = mtype.dim.isDotVarExp().var)
                {
                    FuncDeclaration fd = vd.toAlias().isFuncDeclaration();
                    if (fd)
                        mtype.dim = new CallExp(место, fd, null);
                }
            }

            auto errors = глоб2.errors;
            mtype.dim = semanticLength(sc, tbn, mtype.dim);
            if (errors != глоб2.errors)
                return выведиОшибку();

            mtype.dim = mtype.dim.optimize(WANTvalue);
            mtype.dim = mtype.dim.ctfeInterpret();
            if (mtype.dim.op == ТОК2.error)
                return выведиОшибку();

            errors = глоб2.errors;
            dinteger_t d1 = mtype.dim.toInteger();
            if (errors != глоб2.errors)
                return выведиОшибку();

            mtype.dim = mtype.dim.implicitCastTo(sc, Тип.tт_мера);
            mtype.dim = mtype.dim.optimize(WANTvalue);
            if (mtype.dim.op == ТОК2.error)
                return выведиОшибку();

            errors = глоб2.errors;
            dinteger_t d2 = mtype.dim.toInteger();
            if (errors != глоб2.errors)
                return выведиОшибку();

            if (mtype.dim.op == ТОК2.error)
                return выведиОшибку();

            Тип overflowError()
            {
                .выведиОшибку(место, "`%s` size %llu * %llu exceeds 0x%llx size limit for static массив",
                        mtype.вТкст0(), cast(бдол)tbn.size(место), cast(бдол)d1, target.maxStaticDataSize);
                return выведиОшибку();
            }

            if (d1 != d2)
                return overflowError();

            Тип tbx = tbn.baseElemOf();
            if (tbx.ty == Tstruct && !(cast(TypeStruct)tbx).sym.члены ||
                tbx.ty == Tenum && !(cast(TypeEnum)tbx).sym.члены)
            {
                /* To avoid meaningless error message, skip the total size limit check
                 * when the bottom of element тип is opaque.
                 */
            }
            else if (tbn.isTypeBasic() ||
                     tbn.ty == Tpointer ||
                     tbn.ty == Tarray ||
                     tbn.ty == Tsarray ||
                     tbn.ty == Taarray ||
                     (tbn.ty == Tstruct && ((cast(TypeStruct)tbn).sym.sizeok == Sizeok.done)) ||
                     tbn.ty == Tclass)
            {
                /* Only do this for types that don't need to have semantic()
                 * run on them for the size, since they may be forward referenced.
                 */
                бул overflow = нет;
                if (mulu(tbn.size(место), d2, overflow) >= target.maxStaticDataSize || overflow)
                    return overflowError();
            }
        }
        switch (tbn.ty)
        {
        case Ttuple:
            {
                // Index the кортеж to get the тип
                assert(mtype.dim);
                КортежТипов tt = cast(КортежТипов)tbn;
                uinteger_t d = mtype.dim.toUInteger();
                if (d >= tt.arguments.dim)
                {
                    .выведиОшибку(место, "кортеж index %llu exceeds %llu", cast(бдол)d, cast(бдол)tt.arguments.dim);
                    return выведиОшибку();
                }
                Тип telem = (*tt.arguments)[cast(т_мера)d].тип;
                return telem.addMod(mtype.mod);
            }

        case Tfunction:
        case Tnone:
            .выведиОшибку(место, "cannot have массив of `%s`", tbn.вТкст0());
            return выведиОшибку();

        default:
            break;
        }
        if (tbn.isscope())
        {
            .выведиОшибку(место, "cannot have массив of scope `%s`", tbn.вТкст0());
            return выведиОшибку();
        }

        /* Гарант things like const(const(T)[3]) become const(T[3])
         * and const(T)[3] become const(T[3])
         */
        mtype.следщ = tn;
        mtype.transitive();
        return mtype.addMod(tn.mod).merge();
    }

    Тип visitDArray(TypeDArray mtype)
    {
        Тип tn = mtype.следщ.typeSemantic(место, sc);
        Тип tbn = tn.toBasetype();
        switch (tbn.ty)
        {
        case Ttuple:
            return tbn;

        case Tfunction:
        case Tnone:
            .выведиОшибку(место, "cannot have массив of `%s`", tbn.вТкст0());
            return выведиОшибку();

        case Terror:
            return выведиОшибку();

        default:
            break;
        }
        if (tn.isscope())
        {
            .выведиОшибку(место, "cannot have массив of scope `%s`", tn.вТкст0());
            return выведиОшибку();
        }
        mtype.следщ = tn;
        mtype.transitive();
        return merge(mtype);
    }

    Тип visitAArray(TypeAArray mtype)
    {
        //printf("TypeAArray::semantic() %s index.ty = %d\n", mtype.вТкст0(), mtype.index.ty);
        if (mtype.deco)
        {
            return mtype;
        }

        mtype.место = место;
        mtype.sc = sc;
        if (sc)
            sc.setNoFree();

        // Deal with the case where we thought the index was a тип, but
        // in reality it was an Выражение.
        if (mtype.index.ty == Tident || mtype.index.ty == Tinstance || mtype.index.ty == Tsarray || mtype.index.ty == Ttypeof || mtype.index.ty == Treturn || mtype.index.ty == Tmixin)
        {
            Выражение e;
            Тип t;
            ДСимвол s;
            mtype.index.resolve(место, sc, &e, &t, &s);

            //https://issues.dlang.org/show_bug.cgi?ид=15478
            if (s)
            {
                if (FuncDeclaration fd = s.toAlias().isFuncDeclaration())
                    e = new CallExp(место, fd, null);
            }

            if (e)
            {
                // It was an Выражение -
                // Rewrite as a static массив
                auto tsa = new TypeSArray(mtype.следщ, e);
                return tsa.typeSemantic(место, sc);
            }
            else if (t)
                mtype.index = t.typeSemantic(место, sc);
            else
            {
                .выведиОшибку(место, "index is not a тип or an Выражение");
                return выведиОшибку();
            }
        }
        else
            mtype.index = mtype.index.typeSemantic(место, sc);
        mtype.index = mtype.index.merge2();

        if (mtype.index.nextOf() && !mtype.index.nextOf().isImmutable())
        {
            mtype.index = mtype.index.constOf().mutableOf();
            version (none)
            {
                printf("index is %p %s\n", mtype.index, mtype.index.вТкст0());
                mtype.index.check();
                printf("index.mod = x%x\n", mtype.index.mod);
                printf("index.ito = x%x\n", mtype.index.ito);
                if (mtype.index.ito)
                {
                    printf("index.ito.mod = x%x\n", mtype.index.ito.mod);
                    printf("index.ito.ito = x%x\n", mtype.index.ito.ito);
                }
            }
        }

        switch (mtype.index.toBasetype().ty)
        {
        case Tfunction:
        case Tvoid:
        case Tnone:
        case Ttuple:
            .выведиОшибку(место, "cannot have associative массив ключ of `%s`", mtype.index.toBasetype().вТкст0());
            goto case Terror;
        case Terror:
            return выведиОшибку();

        default:
            break;
        }
        Тип tbase = mtype.index.baseElemOf();
        while (tbase.ty == Tarray)
            tbase = tbase.nextOf().baseElemOf();
        if (auto ts = tbase.isTypeStruct())
        {
            /* AA's need typeid(index).равен() and getHash(). Issue error if not correctly set up.
             */
            StructDeclaration sd = ts.sym;
            if (sd.semanticRun < PASS.semanticdone)
                sd.dsymbolSemantic(null);

            // duplicate a part of StructDeclaration::semanticTypeInfoMembers
            //printf("AA = %s, ключ: xeq = %p, xerreq = %p xhash = %p\n", вТкст0(), sd.xeq, sd.xerreq, sd.xhash);
            if (sd.xeq && sd.xeq._scope && sd.xeq.semanticRun < PASS.semantic3done)
            {
                бцел errors = глоб2.startGagging();
                sd.xeq.semantic3(sd.xeq._scope);
                if (глоб2.endGagging(errors))
                    sd.xeq = sd.xerreq;
            }

            //printf("AA = %s, ключ: xeq = %p, xhash = %p\n", вТкст0(), sd.xeq, sd.xhash);
            ткст0 s = (mtype.index.toBasetype().ty != Tstruct) ? "bottom of " : "";
            if (!sd.xeq)
            {
                // If sd.xhash != NULL:
                //   sd or its fields have user-defined toHash.
                //   AA assumes that its результат is consistent with bitwise equality.
                // else:
                //   bitwise equality & hashing
            }
            else if (sd.xeq == sd.xerreq)
            {
                if (search_function(sd, Id.eq))
                {
                    .выведиОшибку(место, "%sAA ключ тип `%s` does not have `бул opEquals(ref const %s) const`", s, sd.вТкст0(), sd.вТкст0());
                }
                else
                {
                    .выведиОшибку(место, "%sAA ключ тип `%s` does not support const equality", s, sd.вТкст0());
                }
                return выведиОшибку();
            }
            else if (!sd.xhash)
            {
                if (search_function(sd, Id.eq))
                {
                    .выведиОшибку(место, "%sAA ключ тип `%s` should have `extern (D) т_мера toHash() const  ` if `opEquals` defined", s, sd.вТкст0());
                }
                else
                {
                    .выведиОшибку(место, "%sAA ключ тип `%s` supports const equality but doesn't support const hashing", s, sd.вТкст0());
                }
                return выведиОшибку();
            }
            else
            {
                // defined equality & hashing
                assert(sd.xeq && sd.xhash);

                /* xeq and xhash may be implicitly defined by compiler. For example:
                 *   struct S { цел[] arr; }
                 * With 'arr' field equality and hashing, compiler will implicitly
                 * generate functions for xopEquals and xtoHash in TypeInfo_Struct.
                 */
            }
        }
        else if (tbase.ty == Tclass && !(cast(TypeClass)tbase).sym.isInterfaceDeclaration())
        {
            ClassDeclaration cd = (cast(TypeClass)tbase).sym;
            if (cd.semanticRun < PASS.semanticdone)
                cd.dsymbolSemantic(null);

            if (!ClassDeclaration.объект)
            {
                .выведиОшибку(Место.initial, "missing or corrupt объект.d");
                fatal();
            }

             FuncDeclaration feq = null;
             FuncDeclaration fcmp = null;
             FuncDeclaration fhash = null;
            if (!feq)
                feq = search_function(ClassDeclaration.объект, Id.eq).isFuncDeclaration();
            if (!fcmp)
                fcmp = search_function(ClassDeclaration.объект, Id.cmp).isFuncDeclaration();
            if (!fhash)
                fhash = search_function(ClassDeclaration.объект, Id.tohash).isFuncDeclaration();
            assert(fcmp && feq && fhash);

            if (feq.vtblIndex < cd.vtbl.dim && cd.vtbl[feq.vtblIndex] == feq)
            {
                version (all)
                {
                    if (fcmp.vtblIndex < cd.vtbl.dim && cd.vtbl[fcmp.vtblIndex] != fcmp)
                    {
                        ткст0 s = (mtype.index.toBasetype().ty != Tclass) ? "bottom of " : "";
                        .выведиОшибку(место, "%sAA ключ тип `%s` now requires equality rather than comparison", s, cd.вТкст0());
                        errorSupplemental(место, "Please override `Object.opEquals` and `Object.toHash`.");
                    }
                }
            }
        }
        mtype.следщ = mtype.следщ.typeSemantic(место, sc).merge2();
        mtype.transitive();

        switch (mtype.следщ.toBasetype().ty)
        {
        case Tfunction:
        case Tvoid:
        case Tnone:
        case Ttuple:
            .выведиОшибку(место, "cannot have associative массив of `%s`", mtype.следщ.вТкст0());
            goto case Terror;
        case Terror:
            return выведиОшибку();
        default:
            break;
        }
        if (mtype.следщ.isscope())
        {
            .выведиОшибку(место, "cannot have массив of scope `%s`", mtype.следщ.вТкст0());
            return выведиОшибку();
        }
        return merge(mtype);
    }

    Тип visitPointer(TypePointer mtype)
    {
        //printf("TypePointer::semantic() %s\n", вТкст0());
        if (mtype.deco)
        {
            return mtype;
        }
        Тип n = mtype.следщ.typeSemantic(место, sc);
        switch (n.toBasetype().ty)
        {
        case Ttuple:
            .выведиОшибку(место, "cannot have pointer to `%s`", n.вТкст0());
            goto case Terror;
        case Terror:
            return выведиОшибку();
        default:
            break;
        }
        if (n != mtype.следщ)
        {
            mtype.deco = null;
        }
        mtype.следщ = n;
        if (mtype.следщ.ty != Tfunction)
        {
            mtype.transitive();
            return merge(mtype);
        }
        version (none)
        {
            return merge(mtype);
        }
        else
        {
            mtype.deco = merge(mtype).deco;
            /* Don't return merge(), because arg identifiers and default args
             * can be different
             * even though the types match
             */
            return mtype;
        }
    }

    Тип visitReference(TypeReference mtype)
    {
        //printf("TypeReference::semantic()\n");
        Тип n = mtype.следщ.typeSemantic(место, sc);
        if (n != mtype.следщ)
           mtype.deco = null;
        mtype.следщ = n;
        mtype.transitive();
        return merge(mtype);
    }

    Тип visitFunction(TypeFunction mtype)
    {
        if (mtype.deco) // if semantic() already run
        {
            //printf("already done\n");
            return mtype;
        }
        //printf("TypeFunction::semantic() this = %p\n", this);
        //printf("TypeFunction::semantic() %s, sc.stc = %llx, fargs = %p\n", вТкст0(), sc.stc, fargs);

        бул errors = нет;

        if (mtype.inuse > глоб2.recursionLimit)
        {
            mtype.inuse = 0;
            .выведиОшибку(место, "recursive тип");
            return выведиОшибку();
        }

        /* Copy in order to not mess up original.
         * This can produce redundant copies if inferring return тип,
         * as semantic() will get called again on this.
         */
        TypeFunction tf = mtype.копируй().toTypeFunction();
        if (mtype.parameterList.parameters)
        {
            tf.parameterList.parameters = mtype.parameterList.parameters.копируй();
            for (т_мера i = 0; i < mtype.parameterList.parameters.dim; i++)
            {
                Параметр2 p = cast(Параметр2)mem.xmalloc(__traits(classInstanceSize, Параметр2));
                memcpy(cast(ук)p, cast(ук)(*mtype.parameterList.parameters)[i], __traits(classInstanceSize, Параметр2));
                (*tf.parameterList.parameters)[i] = p;
            }
        }

        if (sc.stc & STC.pure_)
            tf.purity = PURE.fwdref;
        if (sc.stc & STC.nothrow_)
            tf.isnothrow = да;
        if (sc.stc & STC.nogc)
            tf.isnogc = да;
        if (sc.stc & STC.ref_)
            tf.isref = да;
        if (sc.stc & STC.return_)
            tf.isreturn = да;
        if (sc.stc & STC.returninferred)
            tf.isreturninferred = да;
        if (sc.stc & STC.scope_)
            tf.isscope = да;
        if (sc.stc & STC.scopeinferred)
            tf.isscopeinferred = да;

//        if (tf.isreturn && !tf.isref)
//            tf.isscope = да;                                  // return by itself means 'return scope'

        if (tf.trust == TRUST.default_)
        {
            if (sc.stc & STC.safe)
                tf.trust = TRUST.safe;
            else if (sc.stc & STC.system)
                tf.trust = TRUST.system;
            else if (sc.stc & STC.trusted)
                tf.trust = TRUST.trusted;
        }

        if (sc.stc & STC.property)
            tf.isproperty = да;

        tf.компонаж = sc.компонаж;
        version (none)
        {
            /* If the родитель is , then this function defaults to safe
             * too.
             * If the родитель's -ty is inferred, then this function's -ty needs
             * to be inferred first.
             */
            if (tf.trust == TRUST.default_)
                for (ДСимвол p = sc.func; p; p = p.toParent2())
                {
                    FuncDeclaration fd = p.isFuncDeclaration();
                    if (fd)
                    {
                        if (fd.isSafeBypassingInference())
                            tf.trust = TRUST.safe; // default to 
                        break;
                    }
                }
        }

        бул wildreturn = нет;
        if (tf.следщ)
        {
            sc = sc.сунь();
            sc.stc &= ~(STC.TYPECTOR | STC.FUNCATTR);
            tf.следщ = tf.следщ.typeSemantic(место, sc);
            sc = sc.вынь();
            errors |= tf.checkRetType(место);
            if (tf.следщ.isscope() && !(sc.flags & SCOPE.ctor))
            {
                .выведиОшибку(место, "functions cannot return `scope %s`", tf.следщ.вТкст0());
                errors = да;
            }
            if (tf.следщ.hasWild())
                wildreturn = да;

            if (tf.isreturn && !tf.isref && !tf.следщ.hasPointers())
            {
                tf.isreturn = нет;
            }
        }

        ббайт wildparams = 0;
        if (tf.parameterList.parameters)
        {
            /* Create a scope for evaluating the default arguments for the parameters
             */
            Scope* argsc = sc.сунь();
            argsc.stc = 0; // don't inherit storage class
            argsc.защита = Prot(Prot.Kind.public_);
            argsc.func = null;

            т_мера dim = tf.parameterList.length;
            for (т_мера i = 0; i < dim; i++)
            {
                Параметр2 fparam = tf.parameterList[i];
                mtype.inuse++;
                fparam.тип = fparam.тип.typeSemantic(место, argsc);
                mtype.inuse--;
                if (fparam.тип.ty == Terror)
                {
                    errors = да;
                    continue;
                }

                fparam.тип = fparam.тип.addStorageClass(fparam.классХранения);

                if (fparam.классХранения & (STC.auto_ | STC.alias_ | STC.static_))
                {
                    if (!fparam.тип)
                        continue;
                }

                Тип t = fparam.тип.toBasetype();

                if (t.ty == Tfunction)
                {
                    .выведиОшибку(место, "cannot have параметр of function тип `%s`", fparam.тип.вТкст0());
                    errors = да;
                }
                else if (!(fparam.классХранения & (STC.ref_ | STC.out_)) &&
                         (t.ty == Tstruct || t.ty == Tsarray || t.ty == Tenum))
                {
                    Тип tb2 = t.baseElemOf();
                    if (tb2.ty == Tstruct && !(cast(TypeStruct)tb2).sym.члены ||
                        tb2.ty == Tenum && !(cast(TypeEnum)tb2).sym.memtype)
                    {
                        .выведиОшибку(место, "cannot have параметр of opaque тип `%s` by значение", fparam.тип.вТкст0());
                        errors = да;
                    }
                }
                else if (!(fparam.классХранения & STC.lazy_) && t.ty == Tvoid)
                {
                    .выведиОшибку(место, "cannot have параметр of тип `%s`", fparam.тип.вТкст0());
                    errors = да;
                }

                if ((fparam.классХранения & (STC.ref_ | STC.wild)) == (STC.ref_ | STC.wild))
                {
                    // 'ref inout' implies 'return'
                    fparam.классХранения |= STC.return_;
                }

                if (fparam.классХранения & STC.return_)
                {
                    if (fparam.классХранения & (STC.ref_ | STC.out_))
                    {
                        // Disabled for the moment awaiting improvement to allow return by ref
                        // to be transformed into return by scope.
                        if (0 && !tf.isref)
                        {
                            auto stc = fparam.классХранения & (STC.ref_ | STC.out_);
                            .выведиОшибку(место, "параметр `%s` is `return %s` but function does not return by `ref`",
                                fparam.идент ? fparam.идент.вТкст0() : "",
                                stcToChars(stc));
                            errors = да;
                        }
                    }
                    else
                    {
                        if (!(fparam.классХранения & STC.scope_))
                            fparam.классХранения |= STC.scope_ | STC.scopeinferred; // 'return' implies 'scope'
                        if (tf.isref)
                        {
                        }
                        else if (tf.следщ && !tf.следщ.hasPointers() && tf.следщ.toBasetype().ty != Tvoid)
                        {
                            fparam.классХранения &= ~STC.return_;   // https://issues.dlang.org/show_bug.cgi?ид=18963
                        }
                    }
                }

                if (fparam.классХранения & (STC.ref_ | STC.lazy_))
                {
                }
                else if (fparam.классХранения & STC.out_)
                {
                    if (ббайт m = fparam.тип.mod & (MODFlags.immutable_ | MODFlags.const_ | MODFlags.wild))
                    {
                        .выведиОшибку(место, "cannot have `%s out` параметр of тип `%s`", MODtoChars(m), t.вТкст0());
                        errors = да;
                    }
                    else
                    {
                        Тип tv = t.baseElemOf();
                        if (tv.ty == Tstruct && (cast(TypeStruct)tv).sym.noDefaultCtor)
                        {
                            .выведиОшибку(место, "cannot have `out` параметр of тип `%s` because the default construction is disabled", fparam.тип.вТкст0());
                            errors = да;
                        }
                    }
                }

                if (fparam.классХранения & STC.scope_ && !fparam.тип.hasPointers() && fparam.тип.ty != Ttuple)
                {
                    /*     X foo(ref return scope X) => Ref-ReturnScope
                     * ref X foo(ref return scope X) => ReturnRef-Scope
                     * But X has no pointers, we don't need the scope part, so:
                     *     X foo(ref return scope X) => Ref
                     * ref X foo(ref return scope X) => ReturnRef
                     * Constructors are treated as if they are being returned through the hidden параметр,
                     * which is by ref, and the ref there is ignored.
                     */
                    fparam.классХранения &= ~STC.scope_;
                    if (!tf.isref || (sc.flags & SCOPE.ctor))
                        fparam.классХранения &= ~STC.return_;
                }

                if (t.hasWild())
                {
                    wildparams |= 1;
                    //if (tf.следщ && !wildreturn)
                    //    выведиОшибку(место, "inout on параметр means inout must be on return тип as well (if from D1 code, replace with `ref`)");
                }

                if (fparam.defaultArg)
                {
                    Выражение e = fparam.defaultArg;
                    const isRefOrOut = fparam.классХранения & (STC.ref_ | STC.out_);
                    const isAuto = fparam.классХранения & (STC.auto_ | STC.autoref);
                    if (isRefOrOut && !isAuto)
                    {
                        e = e.ВыражениеSemantic(argsc);
                        e = resolveProperties(argsc, e);
                    }
                    else
                    {
                        e = inferType(e, fparam.тип);
                        Инициализатор iz = new ExpInitializer(e.место, e);
                        iz = iz.initializerSemantic(argsc, fparam.тип, INITnointerpret);
                        e = iz.инициализаторВВыражение();
                    }
                    if (e.op == ТОК2.function_) // https://issues.dlang.org/show_bug.cgi?ид=4820
                    {
                        FuncExp fe = cast(FuncExp)e;
                        // Replace function literal with a function symbol,
                        // since default arg Выражение must be copied when используется
                        // and copying the literal itself is wrong.
                        e = new VarExp(e.место, fe.fd, нет);
                        e = new AddrExp(e.место, e);
                        e = e.ВыражениеSemantic(argsc);
                    }
                    e = e.implicitCastTo(argsc, fparam.тип);

                    // default arg must be an lvalue
                    if (isRefOrOut && !isAuto)
                        e = e.toLvalue(argsc, e);

                    fparam.defaultArg = e;
                    if (e.op == ТОК2.error)
                        errors = да;
                }

                /* If fparam after semantic() turns out to be a кортеж, the number of parameters may
                 * change.
                 */
                if (auto tt = t.isTypeTuple())
                {
                    /* TypeFunction::параметр also is используется as the storage of
                     * Параметр2 objects for FuncDeclaration. So we should копируй
                     * the elements of КортежТипов::arguments to avoid unintended
                     * sharing of Параметр2 объект among other functions.
                     */
                    if (tt.arguments && tt.arguments.dim)
                    {
                        /* Propagate additional storage class from кортеж parameters to their
                         * element-parameters.
                         * Make a копируй, as original may be referenced elsewhere.
                         */
                        т_мера tdim = tt.arguments.dim;
                        auto newparams = new Параметры(tdim);
                        for (т_мера j = 0; j < tdim; j++)
                        {
                            Параметр2 narg = (*tt.arguments)[j];

                            // https://issues.dlang.org/show_bug.cgi?ид=12744
                            // If the storage classes of narg
                            // conflict with the ones in fparam, it's ignored.
                            КлассХранения stc  = fparam.классХранения | narg.классХранения;
                            КлассХранения stc1 = fparam.классХранения & (STC.ref_ | STC.out_ | STC.lazy_);
                            КлассХранения stc2 =   narg.классХранения & (STC.ref_ | STC.out_ | STC.lazy_);
                            if (stc1 && stc2 && stc1 != stc2)
                            {
                                БуфВыв buf1;  stcToBuffer(&buf1, stc1 | ((stc1 & STC.ref_) ? (fparam.классХранения & STC.auto_) : 0));
                                БуфВыв buf2;  stcToBuffer(&buf2, stc2);

                                .выведиОшибку(место, "incompatible параметр storage classes `%s` and `%s`",
                                    buf1.peekChars(), buf2.peekChars());
                                errors = да;
                                stc = stc1 | (stc & ~(STC.ref_ | STC.out_ | STC.lazy_));
                            }

                            /* https://issues.dlang.org/show_bug.cgi?ид=18572
                             *
                             * If a кортеж параметр has a default argument, when expanding the параметр
                             * кортеж the default argument кортеж must also be expanded.
                             */
                            Выражение paramDefaultArg = narg.defaultArg;
                            TupleExp te = fparam.defaultArg ? fparam.defaultArg.isTupleExp() : null;
                            if (te && te.exps && te.exps.length)
                                paramDefaultArg = (*te.exps)[j];

                            (*newparams)[j] = new Параметр2(
                                stc, narg.тип, narg.идент, paramDefaultArg, narg.userAttribDecl);
                        }
                        fparam.тип = new КортежТипов(newparams);
                    }
                    fparam.классХранения = 0;

                    /* Reset number of parameters, and back up one to do this fparam again,
                     * now that it is a кортеж
                     */
                    dim = tf.parameterList.length;
                    i--;
                    continue;
                }

                /* Resolve "auto ref" storage class to be either ref or значение,
                 * based on the argument matching the параметр
                 */
                if (fparam.классХранения & STC.auto_)
                {
                    Выражение farg = mtype.fargs && i < mtype.fargs.dim ? (*mtype.fargs)[i] : fparam.defaultArg;
                    if (farg && (fparam.классХранения & STC.ref_))
                    {
                        if (farg.isLvalue())
                        {
                            // ref параметр
                        }
                        else
                            fparam.классХранения &= ~STC.ref_; // значение параметр
                        fparam.классХранения &= ~STC.auto_;    // https://issues.dlang.org/show_bug.cgi?ид=14656
                        fparam.классХранения |= STC.autoref;
                    }
                    else if (mtype.incomplete && (fparam.классХранения & STC.ref_))
                    {
                        // the default argument may have been temporarily removed,
                        // see использование of `TypeFunction.incomplete`.
                        // https://issues.dlang.org/show_bug.cgi?ид=19891
                        fparam.классХранения &= ~STC.auto_;
                        fparam.классХранения |= STC.autoref;
                    }
                    else
                    {
                        .выведиОшибку(место, "`auto` can only be используется as part of `auto ref` for template function parameters");
                        errors = да;
                    }
                }

                // Remove redundant storage classes for тип, they are already applied
                fparam.классХранения &= ~(STC.TYPECTOR | STC.in_);
            }
            argsc.вынь();
        }
        if (tf.isWild())
            wildparams |= 2;

        if (wildreturn && !wildparams)
        {
            .выведиОшибку(место, "`inout` on `return` means `inout` must be on a параметр as well for `%s`", mtype.вТкст0());
            errors = да;
        }
        tf.iswild = wildparams;

        if (tf.isproperty && (tf.parameterList.varargs != ВарАрг.none || tf.parameterList.length > 2))
        {
            .выведиОшибку(место, "properties can only have нуль, one, or two параметр");
            errors = да;
        }

        if (tf.parameterList.varargs == ВарАрг.variadic && tf.компонаж != LINK.d && tf.parameterList.length == 0)
        {
            .выведиОшибку(место, "variadic functions with non-D компонаж must have at least one параметр");
            errors = да;
        }

        if (errors)
            return выведиОшибку();

        if (tf.следщ)
            tf.deco = tf.merge().deco;

        /* Don't return merge(), because arg identifiers and default args
         * can be different
         * even though the types match
         */
        return tf;
    }

    Тип visitDelegate(TypeDelegate mtype)
    {
        //printf("TypeDelegate::semantic() %s\n", вТкст0());
        if (mtype.deco) // if semantic() already run
        {
            //printf("already done\n");
            return mtype;
        }
        mtype.следщ = mtype.следщ.typeSemantic(место, sc);
        if (mtype.следщ.ty != Tfunction)
            return выведиОшибку();

        /* In order to deal with https://issues.dlang.org/show_bug.cgi?ид=4028
         * perhaps default arguments should
         * be removed from следщ before the merge.
         */
        version (none)
        {
            return mtype.merge();
        }
        else
        {
            /* Don't return merge(), because arg identifiers and default args
             * can be different
             * even though the types match
             */
            mtype.deco = mtype.merge().deco;
            return mtype;
        }
    }

    Тип visitIdentifier(TypeIdentifier mtype)
    {
        Тип t;
        Выражение e;
        ДСимвол s;
        //printf("TypeIdentifier::semantic(%s)\n", mtype.вТкст0());
        mtype.resolve(место, sc, &e, &t, &s);
        if (t)
        {
            //printf("\tit's a тип %d, %s, %s\n", t.ty, t.вТкст0(), t.deco);
            return t.addMod(mtype.mod);
        }
        else
        {
            if (s)
            {
                auto td = s.isTemplateDeclaration;
                if (td && td.onemember && td.onemember.isAggregateDeclaration)
                    .выведиОшибку(место, "template %s `%s` is используется as a тип without instantiation"
                        ~ "; to instantiate it use `%s!(arguments)`",
                        s.вид, s.toPrettyChars, s.идент.вТкст0);
                else
                    .выведиОшибку(место, "%s `%s` is используется as a тип", s.вид, s.toPrettyChars);
                //assert(0);
            }
            else if (e.op == ТОК2.variable) // special case: variable is используется as a тип
            {
                ДСимвол varDecl = mtype.toDsymbol(sc);
                const Место varDeclLoc = varDecl.getLoc();
                Module varDeclModule = varDecl.getModule();

                .выведиОшибку(место, "variable `%s` is используется as a тип", mtype.вТкст0());

                if (varDeclModule != sc._module) // variable is imported
                {
                    const Место varDeclModuleImportLoc = varDeclModule.getLoc();
                    .errorSupplemental(
                        varDeclModuleImportLoc,
                        "variable `%s` is imported here from: `%s`",
                        varDecl.вТкст0,
                        varDeclModule.toPrettyChars
                    );
                }

                .errorSupplemental(varDeclLoc, "variable `%s` is declared here", varDecl.вТкст0);
            }
            else
                .выведиОшибку(место, "`%s` is используется as a тип", mtype.вТкст0());
            return выведиОшибку();
        }
    }

    Тип visitInstance(TypeInstance mtype)
    {
        Тип t;
        Выражение e;
        ДСимвол s;

        //printf("TypeInstance::semantic(%p, %s)\n", this, вТкст0());
        {
            const errors = глоб2.errors;
            mtype.resolve(место, sc, &e, &t, &s);
            // if we had an error evaluating the symbol, suppress further errors
            if (!t && errors != глоб2.errors)
                return выведиОшибку();
        }

        if (!t)
        {
            if (!e && s && s.errors)
            {
                // if there was an error evaluating the symbol, it might actually
                // be a тип. Avoid misleading error messages.
               .выведиОшибку(место, "`%s` had previous errors", mtype.вТкст0());
            }
            else
               .выведиОшибку(место, "`%s` is используется as a тип", mtype.вТкст0());
            return выведиОшибку();
        }
        return t;
    }

    Тип visitTypeof(TypeTypeof mtype)
    {
        //printf("TypeTypeof::semantic() %s\n", вТкст0());
        Выражение e;
        Тип t;
        ДСимвол s;
        mtype.resolve(место, sc, &e, &t, &s);
        if (s && (t = s.getType()) !is null)
            t = t.addMod(mtype.mod);
        if (!t)
        {
            .выведиОшибку(место, "`%s` is используется as a тип", mtype.вТкст0());
            return выведиОшибку();
        }
        return t;
    }

    Тип visitTraits(TypeTraits mtype)
    {
        if (mtype.ty == Terror)
            return mtype;

        const inAlias = (sc.flags & SCOPE.alias_) != 0;
        if (mtype.exp.идент != Id.allMembers &&
            mtype.exp.идент != Id.derivedMembers &&
            mtype.exp.идент != Id.getMember &&
            mtype.exp.идент != Id.родитель &&
            mtype.exp.идент != Id.getOverloads &&
            mtype.exp.идент != Id.getVirtualFunctions &&
            mtype.exp.идент != Id.getVirtualMethods &&
            mtype.exp.идент != Id.getAttributes &&
            mtype.exp.идент != Id.getUnitTests &&
            mtype.exp.идент != Id.getAliasThis)
        {
            static const сим[2]* ctxt = ["as тип", "in alias"];
            .выведиОшибку(mtype.место, "trait `%s` is either invalid or not supported %s",
                 mtype.exp.идент.вТкст0, ctxt[inAlias]);
            mtype.ty = Terror;
            return mtype;
        }

        
        Тип результат;

        if (Выражение e = semanticTraits(mtype.exp, sc))
        {
            switch (e.op)
            {
            case ТОК2.dotVariable:
                mtype.sym = (cast(DotVarExp)e).var;
                break;
            case ТОК2.variable:
                mtype.sym = (cast(VarExp)e).var;
                break;
            case ТОК2.function_:
                auto fe = cast(FuncExp)e;
                mtype.sym = fe.td ? fe.td : fe.fd;
                break;
            case ТОК2.dotTemplateDeclaration:
                mtype.sym = (cast(DotTemplateExp)e).td;
                break;
            case ТОК2.dSymbol:
                mtype.sym = (cast(DsymbolExp)e).s;
                break;
            case ТОК2.template_:
                mtype.sym = (cast(TemplateExp)e).td;
                break;
            case ТОК2.scope_:
                mtype.sym = (cast(ScopeExp)e).sds;
                break;
            case ТОК2.кортеж:
                TupleExp te = e.toTupleExp();
                Объекты* elems = new Объекты(te.exps.dim);
                foreach (i; new бцел[0 .. elems.dim])
                {
                    auto src = (*te.exps)[i];
                    switch (src.op)
                    {
                    case ТОК2.тип:
                        (*elems)[i] = (cast(TypeExp)src).тип;
                        break;
                    case ТОК2.dotType:
                        (*elems)[i] = (cast(DotTypeExp)src).sym.тип_ли();
                        break;
                    case ТОК2.overloadSet:
                        (*elems)[i] = (cast(OverExp)src).тип;
                        break;
                    default:
                        if (auto sym = isDsymbol(src))
                            (*elems)[i] = sym;
                        else
                            (*elems)[i] = src;
                    }
                }
                TupleDeclaration td = new TupleDeclaration(e.место, Идентификатор2.генерируйИд("__aliastup"), elems);
                mtype.sym = td;
                break;
            case ТОК2.dotType:
                результат = (cast(DotTypeExp)e).sym.тип_ли();
                break;
            case ТОК2.тип:
                результат = (cast(TypeExp)e).тип;
                break;
            case ТОК2.overloadSet:
                результат = (cast(OverExp)e).тип;
                break;
            default:
                break;
            }
        }

        if (результат)
            результат = результат.addMod(mtype.mod);
        if (!inAlias && !результат)
        {
            if (!глоб2.errors)
                .выведиОшибку(mtype.место, "`%s` does not give a valid тип", mtype.вТкст0);
            return выведиОшибку();
        }

        return результат;
    }

    Тип visitReturn(TypeReturn mtype)
    {
        //printf("TypeReturn::semantic() %s\n", вТкст0());
        Выражение e;
        Тип t;
        ДСимвол s;
        mtype.resolve(место, sc, &e, &t, &s);
        if (s && (t = s.getType()) !is null)
            t = t.addMod(mtype.mod);
        if (!t)
        {
            .выведиОшибку(место, "`%s` is используется as a тип", mtype.вТкст0());
            return выведиОшибку();
        }
        return t;
    }

    Тип visitStruct(TypeStruct mtype)
    {
        //printf("TypeStruct::semantic('%s')\n", mtype.вТкст0());
        if (mtype.deco)
        {
            if (sc && sc.cppmangle != CPPMANGLE.def)
            {
                if (mtype.cppmangle == CPPMANGLE.def)
                    mtype.cppmangle = sc.cppmangle;
            }
            return mtype;
        }

        /* Don't semantic for sym because it should be deferred until
         * sizeof needed or its члены accessed.
         */
        // instead, родитель should be set correctly
        assert(mtype.sym.родитель);

        if (mtype.sym.тип.ty == Terror)
            return выведиОшибку();

        if (sc && sc.cppmangle != CPPMANGLE.def)
            mtype.cppmangle = sc.cppmangle;
        else
            mtype.cppmangle = CPPMANGLE.asStruct;

        return merge(mtype);
    }

    Тип visitEnum(TypeEnum mtype)
    {
        //printf("TypeEnum::semantic() %s\n", вТкст0());
        return mtype.deco ? mtype : merge(mtype);
    }

    Тип visitClass(TypeClass mtype)
    {
        //printf("TypeClass::semantic(%s)\n", mtype.вТкст0());
        if (mtype.deco)
        {
            if (sc && sc.cppmangle != CPPMANGLE.def)
            {
                if (mtype.cppmangle == CPPMANGLE.def)
                    mtype.cppmangle = sc.cppmangle;
            }
            return mtype;
        }

        /* Don't semantic for sym because it should be deferred until
         * sizeof needed or its члены accessed.
         */
        // instead, родитель should be set correctly
        assert(mtype.sym.родитель);

        if (mtype.sym.тип.ty == Terror)
            return выведиОшибку();

        if (sc && sc.cppmangle != CPPMANGLE.def)
            mtype.cppmangle = sc.cppmangle;
        else
            mtype.cppmangle = CPPMANGLE.asClass;

        return merge(mtype);
    }

    Тип visitTuple(КортежТипов mtype)
    {
        //printf("КортежТипов::semantic(this = %p)\n", this);
        //printf("КортежТипов::semantic() %p, %s\n", this, вТкст0());
        if (!mtype.deco)
            mtype.deco = merge(mtype).deco;

        /* Don't return merge(), because a кортеж with one тип has the
         * same deco as that тип.
         */
        return mtype;
    }

    Тип visitSlice(TypeSlice mtype)
    {
        //printf("TypeSlice::semantic() %s\n", вТкст0());
        Тип tn = mtype.следщ.typeSemantic(место, sc);
        //printf("следщ: %s\n", tn.вТкст0());

        Тип tbn = tn.toBasetype();
        if (tbn.ty != Ttuple)
        {
            .выведиОшибку(место, "can only slice кортеж types, not `%s`", tbn.вТкст0());
            return выведиОшибку();
        }
        КортежТипов tt = cast(КортежТипов)tbn;

        mtype.lwr = semanticLength(sc, tbn, mtype.lwr);
        mtype.upr = semanticLength(sc, tbn, mtype.upr);
        mtype.lwr = mtype.lwr.ctfeInterpret();
        mtype.upr = mtype.upr.ctfeInterpret();
        if (mtype.lwr.op == ТОК2.error || mtype.upr.op == ТОК2.error)
            return выведиОшибку();

        uinteger_t i1 = mtype.lwr.toUInteger();
        uinteger_t i2 = mtype.upr.toUInteger();
        if (!(i1 <= i2 && i2 <= tt.arguments.dim))
        {
            .выведиОшибку(место, "slice `[%llu..%llu]` is out of range of `[0..%llu]`",
                cast(бдол)i1, cast(бдол)i2, cast(бдол)tt.arguments.dim);
            return выведиОшибку();
        }

        mtype.следщ = tn;
        mtype.transitive();

        auto args = new Параметры();
        args.резервируй(cast(т_мера)(i2 - i1));
        foreach (arg; (*tt.arguments)[cast(т_мера)i1 .. cast(т_мера)i2])
        {
            args.сунь(arg);
        }
        Тип t = new КортежТипов(args);
        return t.typeSemantic(место, sc);
    }

    Тип visitMixin(TypeMixin mtype)
    {
        //printf("TypeMixin::semantic() %s\n", вТкст0());
        auto o = mtype.compileTypeMixin(место, sc);
        if (auto t = o.тип_ли())
        {
            return t.typeSemantic(место, sc);
        }
        else if (auto e = o.выражение_ли())
        {
            e = e.ВыражениеSemantic(sc);
            if (auto et = e.isTypeExp())
                return et.тип;
            else
            {
                if (!глоб2.errors)
                    .выведиОшибку(e.место, "`%s` does not give a valid тип", o.вТкст0);
            }
        }
        return выведиОшибку();
    }

    switch (t.ty)
    {
        default:         return visitType(t);
        case Tvector:    return visitVector(cast(TypeVector)t);
        case Tsarray:    return visitSArray(cast(TypeSArray)t);
        case Tarray:     return visitDArray(cast(TypeDArray)t);
        case Taarray:    return visitAArray(cast(TypeAArray)t);
        case Tpointer:   return visitPointer(cast(TypePointer)t);
        case Treference: return visitReference(cast(TypeReference)t);
        case Tfunction:  return visitFunction(cast(TypeFunction)t);
        case Tdelegate:  return visitDelegate(cast(TypeDelegate)t);
        case Tident:     return visitIdentifier(cast(TypeIdentifier)t);
        case Tinstance:  return visitInstance(cast(TypeInstance)t);
        case Ttypeof:    return visitTypeof(cast(TypeTypeof)t);
        case Ttraits:    return visitTraits(cast(TypeTraits)t);
        case Treturn:    return visitReturn(cast(TypeReturn)t);
        case Tstruct:    return visitStruct(cast(TypeStruct)t);
        case Tenum:      return visitEnum(cast(TypeEnum)t);
        case Tclass:     return visitClass(cast(TypeClass)t);
        case Ttuple:     return visitTuple (cast(КортежТипов)t);
        case Tslice:     return visitSlice(cast(TypeSlice)t);
        case Tmixin:     return visitMixin(cast(TypeMixin)t);
    }
}

/******************************************
 * Compile the MixinType, returning the тип or Выражение AST.
 *
 * Doesn't run semantic() on the returned объект.
 * Параметры:
 *      tm = mixin to compile as a тип or Выражение
 *      место = location for error messages
 *      sc = context
 * Return:
 *      null if error, else КорневойОбъект AST as parsed
 */
КорневойОбъект compileTypeMixin(TypeMixin tm, Место место, Scope* sc)
{
    БуфВыв буф;
    if (выраженияВТкст(буф, sc, tm.exps))
        return null;

    const errors = глоб2.errors;
    const len = буф.length;
    буф.пишиБайт(0);
    const str = буф.извлекиСрез()[0 .. len];
    scope p = new Parser!(ASTCodegen)(место, sc._module, str, нет);
    p.nextToken();
    //printf("p.место.номстр = %d\n", p.место.номстр);

    auto o = p.parseTypeOrAssignExp(ТОК2.endOfFile);
    if (errors != глоб2.errors)
    {
        assert(глоб2.errors != errors); // should have caught all these cases
        return null;
    }
    if (p.token.значение != ТОК2.endOfFile)
    {
        .выведиОшибку(место, "incomplete mixin тип `%s`", str.ptr);
        return null;
    }

    Тип t = o.тип_ли();
    Выражение e = t ? t.типВВыражение() : o.выражение_ли();

    return (!e && t) ? t : e;
}


/************************************
 * If an identical тип to `тип` is in `тип.stringtable`, return
 * the latter one. Otherwise, add it to `тип.stringtable`.
 * Some types don't get merged and are returned as-is.
 * Параметры:
 *      тип = Тип to check against existing types
 * Возвращает:
 *      the тип that was merged
 */
Тип merge(Тип тип)
{
    switch (тип.ty)
    {
        case Terror:
        case Ttypeof:
        case Tident:
        case Tinstance:
        case Tmixin:
            return тип;

        case Tsarray:
            // prevents generating the mangle if the массив dim is not yet known
            if (!(cast(TypeSArray) тип).dim.isIntegerExp())
                return тип;
            goto default;

        case Tenum:
            break;

        case Taarray:
            if (!(cast(TypeAArray)тип).index.merge().deco)
                return тип;
            goto default;

        default:
            if (тип.nextOf() && !тип.nextOf().deco)
                return тип;
            break;
    }

    //printf("merge(%s)\n", вТкст0());
    if (!тип.deco)
    {
        БуфВыв буф;
        буф.резервируй(32);

        mangleToBuffer(тип, &буф);

        auto sv = тип.stringtable.update(буф[]);
        if (sv.значение)
        {
            Тип t = sv.значение;
            debug
            {
                //import core.stdc.stdio;
                if (!t.deco)
                    printf("t = %s\n", t.вТкст0());
            }
            assert(t.deco);
            //printf("old значение, deco = '%s' %p\n", t.deco, t.deco);
            return t;
        }
        else
        {
            Тип t = stripDefaultArgs(тип);
            sv.значение = t;
            тип.deco = t.deco = cast(сим*)sv.toDchars();
            //printf("new значение, deco = '%s' %p\n", t.deco, t.deco);
            return t;
        }
    }
    return тип;
}

/***************************************
 * Calculate built-in properties which just the тип is necessary.
 *
 * Параметры:
 *  t = the тип for which the property is calculated
 *  место = the location where the property is encountered
 *  идент = the идентификатор of the property
 *  флаг = if флаг & 1, don't report "not a property" error and just return NULL.
 * Возвращает:
 *      Выражение representing the property, or null if not a property and (флаг & 1)
 */
Выражение getProperty(Тип t, ref Место место, Идентификатор2 идент, цел флаг)
{
    Выражение visitType(Тип mt)
    {
        Выражение e;
        static if (LOGDOTEXP)
        {
            printf("Тип::getProperty(тип = '%s', идент = '%s')\n", mt.вТкст0(), идент.вТкст0());
        }
        if (идент == Id.__sizeof)
        {
            d_uns64 sz = mt.size(место);
            if (sz == SIZE_INVALID)
                return new ErrorExp();
            e = new IntegerExp(место, sz, Тип.tт_мера);
        }
        else if (идент == Id.__xalignof)
        {
            const explicitAlignment = mt.alignment();
            const naturalAlignment = mt.alignsize();
            const actualAlignment = (explicitAlignment == STRUCTALIGN_DEFAULT ? naturalAlignment : explicitAlignment);
            e = new IntegerExp(место, actualAlignment, Тип.tт_мера);
        }
        else if (идент == Id._иниц)
        {
            Тип tb = mt.toBasetype();
            e = mt.defaultInitLiteral(место);
            if (tb.ty == Tstruct && tb.needsNested())
            {
                e.isStructLiteralExp().useStaticInit = да;
            }
        }
        else if (идент == Id._mangleof)
        {
            if (!mt.deco)
            {
                выведиОшибку(место, "forward reference of тип `%s.mangleof`", mt.вТкст0());
                e = new ErrorExp();
            }
            else
            {
                e = new StringExp(место, mt.deco.вТкстД());
                Scope sc;
                e = e.ВыражениеSemantic(&sc);
            }
        }
        else if (идент == Id.stringof)
        {
            const s = mt.вТкст0();
            e = new StringExp(место, s.вТкстД());
            Scope sc;
            e = e.ВыражениеSemantic(&sc);
        }
        else if (флаг && mt != Тип.terror)
        {
            return null;
        }
        else
        {
            ДСимвол s = null;
            if (mt.ty == Tstruct || mt.ty == Tclass || mt.ty == Tenum)
                s = mt.toDsymbol(null);
            if (s)
                s = s.search_correct(идент);
            if (mt != Тип.terror)
            {
                if (s)
                    выведиОшибку(место, "no property `%s` for тип `%s`, did you mean `%s`?", идент.вТкст0(), mt.вТкст0(), s.toPrettyChars());
                else
                {
                    if (идент == Id.call && mt.ty == Tclass)
                        выведиОшибку(место, "no property `%s` for тип `%s`, did you mean `new %s`?", идент.вТкст0(), mt.вТкст0(), mt.toPrettyChars());
                    else
                    {
                        if(auto n = importHint(идент.вТкст()))
                            выведиОшибку(место, "no property `%s` for тип `%s`, perhaps `import %.*s;` is needed?", идент.вТкст0(), mt.вТкст0(), cast(цел)n.length, n.ptr);
                        else
                            выведиОшибку(место, "no property `%s` for тип `%s`", идент.вТкст0(), mt.toPrettyChars(да));
                    }
                }
            }
            e = new ErrorExp();
        }
        return e;
    }

    Выражение visitError(TypeError)
    {
        return new ErrorExp();
    }

    Выражение visitBasic(TypeBasic mt)
    {
        Выражение integerValue(dinteger_t i)
        {
            return new IntegerExp(место, i, mt);
        }

        Выражение intValue(dinteger_t i)
        {
            return new IntegerExp(место, i, Тип.tint32);
        }

        Выражение floatValue(real_t r)
        {
            if (mt.isreal() || mt.isimaginary())
                return new RealExp(место, r, mt);
            else
            {
                return new ComplexExp(место, complex_t(r, r), mt);
            }
        }

        //printf("TypeBasic::getProperty('%s')\n", идент.вТкст0());
        if (идент == Id.max)
        {
            switch (mt.ty)
            {
            case Tint8:        return integerValue(byte.max);
            case Tuns8:        return integerValue(ббайт.max);
            case Tint16:       return integerValue(short.max);
            case Tuns16:       return integerValue(ushort.max);
            case Tint32:       return integerValue(цел.max);
            case Tuns32:       return integerValue(бцел.max);
            case Tint64:       return integerValue(long.max);
            case Tuns64:       return integerValue(бдол.max);
            case Tbool:        return integerValue(бул.max);
            case Tchar:        return integerValue(сим.max);
            case Twchar:       return integerValue(wchar.max);
            case Tdchar:       return integerValue(dchar.max);
            case Tcomplex32:
            case Timaginary32:
            case Tfloat32:     return floatValue(target.FloatProperties.max);
            case Tcomplex64:
            case Timaginary64:
            case Tfloat64:     return floatValue(target.DoubleProperties.max);
            case Tcomplex80:
            case Timaginary80:
            case Tfloat80:     return floatValue(target.RealProperties.max);
            default:           break;
            }
        }
        else if (идент == Id.min)
        {
            switch (mt.ty)
            {
            case Tint8:        return integerValue(byte.min);
            case Tuns8:
            case Tuns16:
            case Tuns32:
            case Tuns64:
            case Tbool:
            case Tchar:
            case Twchar:
            case Tdchar:       return integerValue(0);
            case Tint16:       return integerValue(short.min);
            case Tint32:       return integerValue(цел.min);
            case Tint64:       return integerValue(long.min);
            default:           break;
            }
        }
        else if (идент == Id.min_normal)
        {
            switch (mt.ty)
            {
            case Tcomplex32:
            case Timaginary32:
            case Tfloat32:     return floatValue(target.FloatProperties.min_normal);
            case Tcomplex64:
            case Timaginary64:
            case Tfloat64:     return floatValue(target.DoubleProperties.min_normal);
            case Tcomplex80:
            case Timaginary80:
            case Tfloat80:     return floatValue(target.RealProperties.min_normal);
            default:           break;
            }
        }
        else if (идент == Id.nan)
        {
            switch (mt.ty)
            {
            case Tcomplex32:
            case Tcomplex64:
            case Tcomplex80:
            case Timaginary32:
            case Timaginary64:
            case Timaginary80:
            case Tfloat32:
            case Tfloat64:
            case Tfloat80:     return floatValue(target.RealProperties.nan);
            default:           break;
            }
        }
        else if (идент == Id.infinity)
        {
            switch (mt.ty)
            {
            case Tcomplex32:
            case Tcomplex64:
            case Tcomplex80:
            case Timaginary32:
            case Timaginary64:
            case Timaginary80:
            case Tfloat32:
            case Tfloat64:
            case Tfloat80:     return floatValue(target.RealProperties.infinity);
            default:           break;
            }
        }
        else if (идент == Id.dig)
        {
            switch (mt.ty)
            {
            case Tcomplex32:
            case Timaginary32:
            case Tfloat32:     return intValue(target.FloatProperties.dig);
            case Tcomplex64:
            case Timaginary64:
            case Tfloat64:     return intValue(target.DoubleProperties.dig);
            case Tcomplex80:
            case Timaginary80:
            case Tfloat80:     return intValue(target.RealProperties.dig);
            default:           break;
            }
        }
        else if (идент == Id.epsilon)
        {
            switch (mt.ty)
            {
            case Tcomplex32:
            case Timaginary32:
            case Tfloat32:     return floatValue(target.FloatProperties.epsilon);
            case Tcomplex64:
            case Timaginary64:
            case Tfloat64:     return floatValue(target.DoubleProperties.epsilon);
            case Tcomplex80:
            case Timaginary80:
            case Tfloat80:     return floatValue(target.RealProperties.epsilon);
            default:           break;
            }
        }
        else if (идент == Id.mant_dig)
        {
            switch (mt.ty)
            {
            case Tcomplex32:
            case Timaginary32:
            case Tfloat32:     return intValue(target.FloatProperties.mant_dig);
            case Tcomplex64:
            case Timaginary64:
            case Tfloat64:     return intValue(target.DoubleProperties.mant_dig);
            case Tcomplex80:
            case Timaginary80:
            case Tfloat80:     return intValue(target.RealProperties.mant_dig);
            default:           break;
            }
        }
        else if (идент == Id.max_10_exp)
        {
            switch (mt.ty)
            {
            case Tcomplex32:
            case Timaginary32:
            case Tfloat32:     return intValue(target.FloatProperties.max_10_exp);
            case Tcomplex64:
            case Timaginary64:
            case Tfloat64:     return intValue(target.DoubleProperties.max_10_exp);
            case Tcomplex80:
            case Timaginary80:
            case Tfloat80:     return intValue(target.RealProperties.max_10_exp);
            default:           break;
            }
        }
        else if (идент == Id.max_exp)
        {
            switch (mt.ty)
            {
            case Tcomplex32:
            case Timaginary32:
            case Tfloat32:     return intValue(target.FloatProperties.max_exp);
            case Tcomplex64:
            case Timaginary64:
            case Tfloat64:     return intValue(target.DoubleProperties.max_exp);
            case Tcomplex80:
            case Timaginary80:
            case Tfloat80:     return intValue(target.RealProperties.max_exp);
            default:           break;
            }
        }
        else if (идент == Id.min_10_exp)
        {
            switch (mt.ty)
            {
            case Tcomplex32:
            case Timaginary32:
            case Tfloat32:     return intValue(target.FloatProperties.min_10_exp);
            case Tcomplex64:
            case Timaginary64:
            case Tfloat64:     return intValue(target.DoubleProperties.min_10_exp);
            case Tcomplex80:
            case Timaginary80:
            case Tfloat80:     return intValue(target.RealProperties.min_10_exp);
            default:           break;
            }
        }
        else if (идент == Id.min_exp)
        {
            switch (mt.ty)
            {
            case Tcomplex32:
            case Timaginary32:
            case Tfloat32:     return intValue(target.FloatProperties.min_exp);
            case Tcomplex64:
            case Timaginary64:
            case Tfloat64:     return intValue(target.DoubleProperties.min_exp);
            case Tcomplex80:
            case Timaginary80:
            case Tfloat80:     return intValue(target.RealProperties.min_exp);
            default:           break;
            }
        }
        return visitType(mt);
    }

    Выражение visitVector(TypeVector mt)
    {
        return visitType(mt);
    }

    Выражение visitEnum(TypeEnum mt)
    {
        Выражение e;
        if (идент == Id.max || идент == Id.min)
        {
            return mt.sym.getMaxMinValue(место, идент);
        }
        else if (идент == Id._иниц)
        {
            e = mt.defaultInitLiteral(место);
        }
        else if (идент == Id.stringof)
        {
            e = new StringExp(место, mt.вТкст());
            Scope sc;
            e = e.ВыражениеSemantic(&sc);
        }
        else if (идент == Id._mangleof)
        {
            e = visitType(mt);
        }
        else
        {
            e = mt.toBasetype().getProperty(место, идент, флаг);
        }
        return e;
    }

    Выражение visitTuple(КортежТипов mt)
    {
        Выражение e;
        static if (LOGDOTEXP)
        {
            printf("КортежТипов::getProperty(тип = '%s', идент = '%s')\n", mt.вТкст0(), идент.вТкст0());
        }
        if (идент == Id.length)
        {
            e = new IntegerExp(место, mt.arguments.dim, Тип.tт_мера);
        }
        else if (идент == Id._иниц)
        {
            e = mt.defaultInitLiteral(место);
        }
        else if (флаг)
        {
            e = null;
        }
        else
        {
            выведиОшибку(место, "no property `%s` for кортеж `%s`", идент.вТкст0(), mt.вТкст0());
            e = new ErrorExp();
        }
        return e;
    }

    switch (t.ty)
    {
        default:        return t.isTypeBasic() ?
                                visitBasic(cast(TypeBasic)t) :
                                visitType(t);

        case Terror:    return visitError (cast(TypeError)t);
        case Tvector:   return visitVector(cast(TypeVector)t);
        case Tenum:     return visitEnum  (cast(TypeEnum)t);
        case Ttuple:    return visitTuple (cast(КортежТипов)t);
    }
}

/***************************************
 * Normalize `e` as the результат of resolve() process.
 */
private проц resolveExp(Выражение e, Тип *pt, Выражение *pe, ДСимвол* ps)
{
    *pt = null;
    *pe = null;
    *ps = null;

    ДСимвол s;
    switch (e.op)
    {
        case ТОК2.error:
            *pt = Тип.terror;
            return;

        case ТОК2.тип:
            *pt = e.тип;
            return;

        case ТОК2.variable:
            s = (cast(VarExp)e).var;
            if (s.isVarDeclaration())
                goto default;
            //if (s.isOverDeclaration())
            //    todo;
            break;

        case ТОК2.template_:
            // TemplateDeclaration
            s = (cast(TemplateExp)e).td;
            break;

        case ТОК2.scope_:
            s = (cast(ScopeExp)e).sds;
            // TemplateDeclaration, TemplateInstance, Импорт, Package, Module
            break;

        case ТОК2.function_:
            s = getDsymbol(e);
            break;

        case ТОК2.dotTemplateDeclaration:
            s = (cast(DotTemplateExp)e).td;
            break;

        //case ТОК2.this_:
        //case ТОК2.super_:

        //case ТОК2.кортеж:

        //case ТОК2.overloadSet:

        //case ТОК2.dotVariable:
        //case ТОК2.dotTemplateInstance:
        //case ТОК2.dotType:
        //case ТОК2.dotIdentifier:

        default:
            *pe = e;
            return;
    }

    *ps = s;
}

/************************************
 * Resolve тип 'mt' to either тип, symbol, or Выражение.
 * If errors happened, resolved to Тип.terror.
 *
 * Параметры:
 *  mt = тип to be resolved
 *  место = the location where the тип is encountered
 *  sc = the scope of the тип
 *  pe = is set if t is an Выражение
 *  pt = is set if t is a тип
 *  ps = is set if t is a symbol
 *  intypeid = да if in тип ид
 */
проц resolve(Тип mt, ref Место место, Scope* sc, Выражение* pe, Тип* pt, ДСимвол* ps, бул intypeid = нет)
{
    проц returnExp(Выражение e)
    {
        *pt = null;
        *pe = e;
        *ps = null;
    }

    проц returnType(Тип t)
    {
        *pt = t;
        *pe = null;
        *ps = null;
    }

    проц returnSymbol(ДСимвол s)
    {
        *pt = null;
        *pe = null;
        *ps = s;
    }

    проц returnError()
    {
        returnType(Тип.terror);
    }

    проц visitType(Тип mt)
    {
        //printf("Тип::resolve() %s, %d\n", mt.вТкст0(), mt.ty);
        Тип t = typeSemantic(mt, место, sc);
        assert(t);
        returnType(t);
    }

    проц visitSArray(TypeSArray mt)
    {
        //printf("TypeSArray::resolve() %s\n", mt.вТкст0());
        mt.следщ.resolve(место, sc, pe, pt, ps, intypeid);
        //printf("s = %p, e = %p, t = %p\n", *ps, *pe, *pt);
        if (*pe)
        {
            // It's really an index Выражение
            if (ДСимвол s = getDsymbol(*pe))
                *pe = new DsymbolExp(место, s);
            returnExp(new ArrayExp(место, *pe, mt.dim));
        }
        else if (*ps)
        {
            ДСимвол s = *ps;
            if (auto tup = s.isTupleDeclaration())
            {
                mt.dim = semanticLength(sc, tup, mt.dim);
                mt.dim = mt.dim.ctfeInterpret();
                if (mt.dim.op == ТОК2.error)
                    return returnError();

                const d = mt.dim.toUInteger();
                if (d >= tup.objects.dim)
                {
                    выведиОшибку(место, "кортеж index `%llu` exceeds length %u", d, tup.objects.dim);
                    return returnError();
                }

                КорневойОбъект o = (*tup.objects)[cast(т_мера)d];
                if (o.динкаст() == ДИНКАСТ.дсимвол)
                {
                    return returnSymbol(cast(ДСимвол)o);
                }
                if (o.динкаст() == ДИНКАСТ.Выражение)
                {
                    Выражение e = cast(Выражение)o;
                    if (e.op == ТОК2.dSymbol)
                        return returnSymbol((cast(DsymbolExp)e).s);
                    else
                        return returnExp(e);
                }
                if (o.динкаст() == ДИНКАСТ.тип)
                {
                    return returnType((cast(Тип)o).addMod(mt.mod));
                }

                /* Create a new TupleDeclaration which
                 * is a slice [d..d+1] out of the old one.
                 * Do it this way because TemplateInstance::semanticTiargs()
                 * can handle unresolved Объекты this way.
                 */
                auto objects = new Объекты(1);
                (*objects)[0] = o;
                return returnSymbol(new TupleDeclaration(место, tup.идент, objects));
            }
            else
                return visitType(mt);
        }
        else
        {
            if ((*pt).ty != Terror)
                mt.следщ = *pt; // prevent re-running semantic() on 'следщ'
            visitType(mt);
        }

    }

    проц visitDArray(TypeDArray mt)
    {
        //printf("TypeDArray::resolve() %s\n", mt.вТкст0());
        mt.следщ.resolve(место, sc, pe, pt, ps, intypeid);
        //printf("s = %p, e = %p, t = %p\n", *ps, *pe, *pt);
        if (*pe)
        {
            // It's really a slice Выражение
            if (ДСимвол s = getDsymbol(*pe))
                *pe = new DsymbolExp(место, s);
            returnExp(new ArrayExp(место, *pe));
        }
        else if (*ps)
        {
            if (auto tup = (*ps).isTupleDeclaration())
            {
                // keep *ps
            }
            else
                visitType(mt);
        }
        else
        {
            if ((*pt).ty != Terror)
                mt.следщ = *pt; // prevent re-running semantic() on 'следщ'
            visitType(mt);
        }
    }

    проц visitAArray(TypeAArray mt)
    {
        //printf("TypeAArray::resolve() %s\n", mt.вТкст0());
        // Deal with the case where we thought the index was a тип, but
        // in reality it was an Выражение.
        if (mt.index.ty == Tident || mt.index.ty == Tinstance || mt.index.ty == Tsarray)
        {
            Выражение e;
            Тип t;
            ДСимвол s;
            mt.index.resolve(место, sc, &e, &t, &s, intypeid);
            if (e)
            {
                // It was an Выражение -
                // Rewrite as a static массив
                auto tsa = new TypeSArray(mt.следщ, e);
                tsa.mod = mt.mod; // just копируй mod field so tsa's semantic is not yet done
                return tsa.resolve(место, sc, pe, pt, ps, intypeid);
            }
            else if (t)
                mt.index = t;
            else
                .выведиОшибку(место, "index is not a тип or an Выражение");
        }
        visitType(mt);
    }

    /*************************************
     * Takes an массив of Идентификаторы and figures out if
     * it represents a Тип or an Выражение.
     * Output:
     *      if Выражение, *pe is set
     *      if тип, *pt is set
     */
    проц visitIdentifier(TypeIdentifier mt)
    {
        //printf("TypeIdentifier::resolve(sc = %p, idents = '%s')\n", sc, mt.вТкст0());
        if ((mt.идент.равен(Id._super) || mt.идент.равен(Id.This)) && !hasThis(sc))
        {
            // @@@DEPRECATED_v2.091@@@.
            // Made an error in 2.086.
            // Eligible for removal in 2.091.
            if (mt.идент.равен(Id._super))
            {
                выведиОшибку(mt.место, "Using `super` as a тип is obsolete. Use `typeof(super)` instead");
            }
             // @@@DEPRECATED_v2.091@@@.
            // Made an error in 2.086.
            // Eligible for removal in 2.091.
            if (mt.идент.равен(Id.This))
            {
                выведиОшибку(mt.место, "Using `this` as a тип is obsolete. Use `typeof(this)` instead");
            }
            if (AggregateDeclaration ad = sc.getStructClassScope())
            {
                if (ClassDeclaration cd = ad.isClassDeclaration())
                {
                    if (mt.идент.равен(Id.This))
                        mt.идент = cd.идент;
                    else if (cd.baseClass && mt.идент.равен(Id._super))
                        mt.идент = cd.baseClass.идент;
                }
                else
                {
                    StructDeclaration sd = ad.isStructDeclaration();
                    if (sd && mt.идент.равен(Id.This))
                        mt.идент = sd.идент;
                }
            }
        }
        if (mt.идент == Id.ctfe)
        {
            выведиОшибку(место, "variable `__ctfe` cannot be читай at compile time");
            return returnError();
        }

        ДСимвол scopesym;
        ДСимвол s = sc.search(место, mt.идент, &scopesym);
        /*
         * https://issues.dlang.org/show_bug.cgi?ид=1170
         * https://issues.dlang.org/show_bug.cgi?ид=10739
         *
         * If a symbol is not found, it might be declared in
         * a mixin-ed ткст or a mixin-ed template, so before
         * issuing an error semantically analyze all ткст/template
         * mixins that are члены of the current ScopeDsymbol.
         */
        if (!s && sc.enclosing)
        {
            ScopeDsymbol sds = sc.enclosing.scopesym;
            if (sds && sds.члены)
            {
                проц semanticOnMixin(ДСимвол member)
                {
                    if (auto compileDecl = member.isCompileDeclaration())
                        compileDecl.dsymbolSemantic(sc);
                    else if (auto mixinTempl = member.isTemplateMixin())
                        mixinTempl.dsymbolSemantic(sc);
                }
                sds.члены.foreachDsymbol( /*s =>*/ semanticOnMixin(s) );
                s = sc.search(место, mt.идент, &scopesym);
            }
        }

        if (s)
        {
            // https://issues.dlang.org/show_bug.cgi?ид=16042
            // If `f` is really a function template, then replace `f`
            // with the function template declaration.
            if (auto f = s.isFuncDeclaration())
            {
                if (auto td = getFuncTemplateDecl(f))
                {
                    // If not at the beginning of the overloaded list of
                    // `TemplateDeclaration`s, then get the beginning
                    if (td.overroot)
                        td = td.overroot;
                    s = td;
                }
            }
        }

        mt.resolveHelper(место, sc, s, scopesym, pe, pt, ps, intypeid);
        if (*pt)
            (*pt) = (*pt).addMod(mt.mod);
    }

    проц visitInstance(TypeInstance mt)
    {
        // Note close similarity to TypeIdentifier::resolve()

        //printf("TypeInstance::resolve(sc = %p, tempinst = '%s')\n", sc, mt.tempinst.вТкст0());
        mt.tempinst.dsymbolSemantic(sc);
        if (!глоб2.gag && mt.tempinst.errors)
            return returnError();

        mt.resolveHelper(место, sc, mt.tempinst, null, pe, pt, ps, intypeid);
        if (*pt)
            *pt = (*pt).addMod(mt.mod);
        //if (*pt) printf("*pt = %d '%s'\n", (*pt).ty, (*pt).вТкст0());
    }

    проц visitTypeof(TypeTypeof mt)
    {
        //printf("TypeTypeof::resolve(this = %p, sc = %p, idents = '%s')\n", mt, sc, mt.вТкст0());
        //static цел nest; if (++nest == 50) *(сим*)0=0;
        if (sc is null)
        {
            выведиОшибку(место, "Invalid scope.");
            return returnError();
        }
        if (mt.inuse)
        {
            mt.inuse = 2;
            выведиОшибку(место, "circular `typeof` definition");
        Lerr:
            mt.inuse--;
            return returnError();
        }
        mt.inuse++;

        /* Currently we cannot evaluate 'exp' in speculative context, because
         * the тип implementation may leak to the final execution. Consider:
         *
         * struct S(T) {
         *   ткст вТкст(){ return "x"; }
         * }
         * проц main() {
         *   alias X = typeof(S!цел());
         *   assert(typeid(X).вТкст() == "x");
         * }
         */
        Scope* sc2 = sc.сунь();
        sc2.intypeof = 1;
        auto exp2 = mt.exp.ВыражениеSemantic(sc2);
        exp2 = resolvePropertiesOnly(sc2, exp2);
        sc2.вынь();

        if (exp2.op == ТОК2.error)
        {
            if (!глоб2.gag)
                mt.exp = exp2;
            goto Lerr;
        }
        mt.exp = exp2;

        if (mt.exp.op == ТОК2.тип ||
            mt.exp.op == ТОК2.scope_)
        {
            if (mt.exp.checkType())
                goto Lerr;

            /* Today, 'typeof(func)' returns проц if func is a
             * function template (TemplateExp), or
             * template lambda (FuncExp).
             * It's actually используется in Phobos as an idiom, to branch code for
             * template functions.
             */
        }
        if (auto f = mt.exp.op == ТОК2.variable    ? (cast(   VarExp)mt.exp).var.isFuncDeclaration()
                   : mt.exp.op == ТОК2.dotVariable ? (cast(DotVarExp)mt.exp).var.isFuncDeclaration() : null)
        {
            if (f.checkForwardRef(место))
                goto Lerr;
        }
        if (auto f = isFuncAddress(mt.exp))
        {
            if (f.checkForwardRef(место))
                goto Lerr;
        }

        Тип t = mt.exp.тип;
        if (!t)
        {
            выведиОшибку(место, "Выражение `%s` has no тип", mt.exp.вТкст0());
            goto Lerr;
        }
        if (t.ty == Ttypeof)
        {
            выведиОшибку(место, "forward reference to `%s`", mt.вТкст0());
            goto Lerr;
        }
        if (mt.idents.dim == 0)
        {
            returnType(t.addMod(mt.mod));
        }
        else
        {
            if (ДСимвол s = t.toDsymbol(sc))
                mt.resolveHelper(место, sc, s, null, pe, pt, ps, intypeid);
            else
            {
                auto e = typeToВыражениеHelper(mt, new TypeExp(место, t));
                e = e.ВыражениеSemantic(sc);
                resolveExp(e, pt, pe, ps);
            }
            if (*pt)
                (*pt) = (*pt).addMod(mt.mod);
        }
        mt.inuse--;
    }

    проц visitReturn(TypeReturn mt)
    {
        //printf("TypeReturn::resolve(sc = %p, idents = '%s')\n", sc, mt.вТкст0());
        Тип t;
        {
            FuncDeclaration func = sc.func;
            if (!func)
            {
                выведиОшибку(место, "`typeof(return)` must be inside function");
                return returnError();
            }
            if (func.fes)
                func = func.fes.func;
            t = func.тип.nextOf();
            if (!t)
            {
                выведиОшибку(место, "cannot use `typeof(return)` inside function `%s` with inferred return тип", sc.func.вТкст0());
                return returnError();
            }
        }
        if (mt.idents.dim == 0)
        {
            return returnType(t.addMod(mt.mod));
        }
        else
        {
            if (ДСимвол s = t.toDsymbol(sc))
                mt.resolveHelper(место, sc, s, null, pe, pt, ps, intypeid);
            else
            {
                auto e = typeToВыражениеHelper(mt, new TypeExp(место, t));
                e = e.ВыражениеSemantic(sc);
                resolveExp(e, pt, pe, ps);
            }
            if (*pt)
                (*pt) = (*pt).addMod(mt.mod);
        }
    }

    проц visitSlice(TypeSlice mt)
    {
        mt.следщ.resolve(место, sc, pe, pt, ps, intypeid);
        if (*pe)
        {
            // It's really a slice Выражение
            if (ДСимвол s = getDsymbol(*pe))
                *pe = new DsymbolExp(место, s);
            return returnExp(new ArrayExp(место, *pe, new IntervalExp(место, mt.lwr, mt.upr)));
        }
        else if (*ps)
        {
            ДСимвол s = *ps;
            TupleDeclaration td = s.isTupleDeclaration();
            if (td)
            {
                /* It's a slice of a TupleDeclaration
                 */
                ScopeDsymbol sym = new ArrayScopeSymbol(sc, td);
                sym.родитель = sc.scopesym;
                sc = sc.сунь(sym);
                sc = sc.startCTFE();
                mt.lwr = mt.lwr.ВыражениеSemantic(sc);
                mt.upr = mt.upr.ВыражениеSemantic(sc);
                sc = sc.endCTFE();
                sc = sc.вынь();

                mt.lwr = mt.lwr.ctfeInterpret();
                mt.upr = mt.upr.ctfeInterpret();
                const i1 = mt.lwr.toUInteger();
                const i2 = mt.upr.toUInteger();
                if (!(i1 <= i2 && i2 <= td.objects.dim))
                {
                    выведиОшибку(место, "slice `[%llu..%llu]` is out of range of [0..%u]", i1, i2, td.objects.dim);
                    return returnError();
                }

                if (i1 == 0 && i2 == td.objects.dim)
                {
                    return returnSymbol(td);
                }

                /* Create a new TupleDeclaration which
                 * is a slice [i1..i2] out of the old one.
                 */
                auto objects = new Объекты(cast(т_мера)(i2 - i1));
                for (т_мера i = 0; i < objects.dim; i++)
                {
                    (*objects)[i] = (*td.objects)[cast(т_мера)i1 + i];
                }

                return returnSymbol(new TupleDeclaration(место, td.идент, objects));
            }
            else
                visitType(mt);
        }
        else
        {
            if ((*pt).ty != Terror)
                mt.следщ = *pt; // prevent re-running semantic() on 'следщ'
            visitType(mt);
        }
    }

    проц visitMixin(TypeMixin mt)
    {
        auto o = mt.compileTypeMixin(место, sc);

        if (auto t = o.тип_ли())
        {
            resolve(t, место, sc, pe, pt, ps, intypeid);
        }
        else if (auto e = o.выражение_ли())
        {
            e = e.ВыражениеSemantic(sc);
            if (auto et = e.isTypeExp())
                return returnType(et.тип);
            else
                returnExp(e);
        }
        else
            returnError();
    }

    проц visitTraits(TypeTraits tt)
    {
        if (Тип t = typeSemantic(tt, место, sc))
            returnType(t);
        else if (tt.sym)
            returnSymbol(tt.sym);
        else
            return returnError();
    }

    switch (mt.ty)
    {
        default:        visitType      (mt);                     break;
        case Tsarray:   visitSArray    (cast(TypeSArray)mt);     break;
        case Tarray:    visitDArray    (cast(TypeDArray)mt);     break;
        case Taarray:   visitAArray    (cast(TypeAArray)mt);     break;
        case Tident:    visitIdentifier(cast(TypeIdentifier)mt); break;
        case Tinstance: visitInstance  (cast(TypeInstance)mt);   break;
        case Ttypeof:   visitTypeof    (cast(TypeTypeof)mt);     break;
        case Treturn:   visitReturn    (cast(TypeReturn)mt);     break;
        case Tslice:    visitSlice     (cast(TypeSlice)mt);      break;
        case Tmixin:    visitMixin     (cast(TypeMixin)mt);      break;
        case Ttraits:   visitTraits    (cast(TypeTraits)mt);     break;
    }
}

/************************
 * Access the члены of the объект e. This тип is same as e.тип.
 * Параметры:
 *  mt = тип for which the dot Выражение is используется
 *  sc = instantiating scope
 *  e = Выражение to convert
 *  идент = идентификатор being используется
 *  флаг = DotExpFlag bit flags
 *
 * Возвращает:
 *  результатing Выражение with e.идент resolved
 */
Выражение dotExp(Тип mt, Scope* sc, Выражение e, Идентификатор2 идент, цел флаг)
{
    Выражение visitType(Тип mt)
    {
        VarDeclaration v = null;
        static if (LOGDOTEXP)
        {
            printf("Тип::dotExp(e = '%s', идент = '%s')\n", e.вТкст0(), идент.вТкст0());
        }
        Выражение ex = e;
        while (ex.op == ТОК2.comma)
            ex = (cast(CommaExp)ex).e2;
        if (ex.op == ТОК2.dotVariable)
        {
            DotVarExp dv = cast(DotVarExp)ex;
            v = dv.var.isVarDeclaration();
        }
        else if (ex.op == ТОК2.variable)
        {
            VarExp ve = cast(VarExp)ex;
            v = ve.var.isVarDeclaration();
        }
        if (v)
        {
            if (идент == Id.offsetof)
            {
                if (v.isField())
                {
                    auto ad = v.toParent().isAggregateDeclaration();
                    objc.checkOffsetof(e, ad);
                    ad.size(e.место);
                    if (ad.sizeok != Sizeok.done)
                        return new ErrorExp();
                    return new IntegerExp(e.место, v.смещение, Тип.tт_мера);
                }
            }
            else if (идент == Id._иниц)
            {
                Тип tb = mt.toBasetype();
                e = mt.defaultInitLiteral(e.место);
                if (tb.ty == Tstruct && tb.needsNested())
                {
                    e.isStructLiteralExp().useStaticInit = да;
                }
                goto Lreturn;
            }
        }
        if (идент == Id.stringof)
        {
            /* https://issues.dlang.org/show_bug.cgi?ид=3796
             * this should demangle e.тип.deco rather than
             * pretty-printing the тип.
             */
            e = new StringExp(e.место, e.вТкст());
        }
        else
            e = mt.getProperty(e.место, идент, флаг & DotExpFlag.gag);

    Lreturn:
        if (e)
            e = e.ВыражениеSemantic(sc);
        return e;
    }

    Выражение visitError(TypeError)
    {
        return new ErrorExp();
    }

    Выражение visitBasic(TypeBasic mt)
    {
        static if (LOGDOTEXP)
        {
            printf("TypeBasic::dotExp(e = '%s', идент = '%s')\n", e.вТкст0(), идент.вТкст0());
        }
        Тип t;
        if (идент == Id.re)
        {
            switch (mt.ty)
            {
            case Tcomplex32:
                t = mt.tfloat32;
                goto L1;

            case Tcomplex64:
                t = mt.tfloat64;
                goto L1;

            case Tcomplex80:
                t = mt.tfloat80;
                goto L1;
            L1:
                e = e.castTo(sc, t);
                break;

            case Tfloat32:
            case Tfloat64:
            case Tfloat80:
                break;

            case Timaginary32:
                t = mt.tfloat32;
                goto L2;

            case Timaginary64:
                t = mt.tfloat64;
                goto L2;

            case Timaginary80:
                t = mt.tfloat80;
                goto L2;
            L2:
                e = new RealExp(e.место, CTFloat.нуль, t);
                break;

            default:
                e = mt.Тип.getProperty(e.место, идент, флаг);
                break;
            }
        }
        else if (идент == Id.im)
        {
            Тип t2;
            switch (mt.ty)
            {
            case Tcomplex32:
                t = mt.timaginary32;
                t2 = mt.tfloat32;
                goto L3;

            case Tcomplex64:
                t = mt.timaginary64;
                t2 = mt.tfloat64;
                goto L3;

            case Tcomplex80:
                t = mt.timaginary80;
                t2 = mt.tfloat80;
                goto L3;
            L3:
                e = e.castTo(sc, t);
                e.тип = t2;
                break;

            case Timaginary32:
                t = mt.tfloat32;
                goto L4;

            case Timaginary64:
                t = mt.tfloat64;
                goto L4;

            case Timaginary80:
                t = mt.tfloat80;
                goto L4;
            L4:
                e = e.копируй();
                e.тип = t;
                break;

            case Tfloat32:
            case Tfloat64:
            case Tfloat80:
                e = new RealExp(e.место, CTFloat.нуль, mt);
                break;

            default:
                e = mt.Тип.getProperty(e.место, идент, флаг);
                break;
            }
        }
        else
        {
            return visitType(mt);
        }
        if (!(флаг & 1) || e)
            e = e.ВыражениеSemantic(sc);
        return e;
    }

    Выражение visitVector(TypeVector mt)
    {
        static if (LOGDOTEXP)
        {
            printf("TypeVector::dotExp(e = '%s', идент = '%s')\n", e.вТкст0(), идент.вТкст0());
        }
        if (идент == Id.ptr && e.op == ТОК2.call)
        {
            /* The trouble with ТОК2.call is the return ABI for float[4] is different from
             * __vector(float[4]), and a тип paint won't do.
             */
            e = new AddrExp(e.место, e);
            e = e.ВыражениеSemantic(sc);
            return e.castTo(sc, mt.basetype.nextOf().pointerTo());
        }
        if (идент == Id.массив)
        {
            //e = e.castTo(sc, basetype);
            // Keep lvalue-ness
            e = new VectorArrayExp(e.место, e);
            e = e.ВыражениеSemantic(sc);
            return e;
        }
        if (идент == Id._иниц || идент == Id.offsetof || идент == Id.stringof || идент == Id.__xalignof)
        {
            // init should return a new VectorExp
            // https://issues.dlang.org/show_bug.cgi?ид=12776
            // offsetof does not work on a cast Выражение, so use e directly
            // stringof should not add a cast to the output
            return visitType(mt);
        }
        return mt.basetype.dotExp(sc, e.castTo(sc, mt.basetype), идент, флаг);
    }

    Выражение visitArray(TypeArray mt)
    {
        static if (LOGDOTEXP)
        {
            printf("TypeArray::dotExp(e = '%s', идент = '%s')\n", e.вТкст0(), идент.вТкст0());
        }

        e = visitType(mt);

        if (!(флаг & 1) || e)
            e = e.ВыражениеSemantic(sc);
        return e;
    }

    Выражение visitSArray(TypeSArray mt)
    {
        static if (LOGDOTEXP)
        {
            printf("TypeSArray::dotExp(e = '%s', идент = '%s')\n", e.вТкст0(), идент.вТкст0());
        }
        if (идент == Id.length)
        {
            Место oldLoc = e.место;
            e = mt.dim.копируй();
            e.место = oldLoc;
        }
        else if (идент == Id.ptr)
        {
            if (e.op == ТОК2.тип)
            {
                e.выведиОшибку("`%s` is not an Выражение", e.вТкст0());
                return new ErrorExp();
            }
            else if (!(флаг & DotExpFlag.noDeref) && sc.func && !sc.intypeof && !(sc.flags & SCOPE.debug_) && sc.func.setUnsafe())
            {
                e.выведиОшибку("`%s.ptr` cannot be используется in `` code, use `&%s[0]` instead", e.вТкст0(), e.вТкст0());
                return new ErrorExp();
            }
            e = e.castTo(sc, e.тип.nextOf().pointerTo());
        }
        else
        {
            e = visitArray(mt);
        }
        if (!(флаг & 1) || e)
            e = e.ВыражениеSemantic(sc);
        return e;
    }

    Выражение visitDArray(TypeDArray mt)
    {
        static if (LOGDOTEXP)
        {
            printf("TypeDArray::dotExp(e = '%s', идент = '%s')\n", e.вТкст0(), идент.вТкст0());
        }
        if (e.op == ТОК2.тип && (идент == Id.length || идент == Id.ptr))
        {
            e.выведиОшибку("`%s` is not an Выражение", e.вТкст0());
            return new ErrorExp();
        }
        if (идент == Id.length)
        {
            if (e.op == ТОК2.string_)
            {
                StringExp se = cast(StringExp)e;
                return new IntegerExp(se.место, se.len, Тип.tт_мера);
            }
            if (e.op == ТОК2.null_)
            {
                return new IntegerExp(e.место, 0, Тип.tт_мера);
            }
            if (checkNonAssignmentArrayOp(e))
            {
                return new ErrorExp();
            }
            e = new ArrayLengthExp(e.место, e);
            e.тип = Тип.tт_мера;
            return e;
        }
        else if (идент == Id.ptr)
        {
            if (!(флаг & DotExpFlag.noDeref) && sc.func && !sc.intypeof && !(sc.flags & SCOPE.debug_) && sc.func.setUnsafe())
            {
                e.выведиОшибку("`%s.ptr` cannot be используется in `` code, use `&%s[0]` instead", e.вТкст0(), e.вТкст0());
                return new ErrorExp();
            }
            return e.castTo(sc, mt.следщ.pointerTo());
        }
        else
        {
            return visitArray(mt);
        }
    }

    Выражение visitAArray(TypeAArray mt)
    {
        static if (LOGDOTEXP)
        {
            printf("TypeAArray::dotExp(e = '%s', идент = '%s')\n", e.вТкст0(), идент.вТкст0());
        }
        if (идент == Id.length)
        {
             FuncDeclaration fd_aaLen = null;
            if (fd_aaLen is null)
            {
                auto fparams = new Параметры();
                fparams.сунь(new Параметр2(STC.in_, mt, null, null, null));
                fd_aaLen = FuncDeclaration.genCfunc(fparams, Тип.tт_мера, Id.aaLen);
                TypeFunction tf = fd_aaLen.тип.toTypeFunction();
                tf.purity = PURE.const_;
                tf.isnothrow = да;
                tf.isnogc = нет;
            }
            Выражение ev = new VarExp(e.место, fd_aaLen, нет);
            e = new CallExp(e.место, ev, e);
            e.тип = fd_aaLen.тип.toTypeFunction().следщ;
            return e;
        }
        else
        {
            return visitType(mt);
        }
    }

    Выражение visitReference(TypeReference mt)
    {
        static if (LOGDOTEXP)
        {
            printf("TypeReference::dotExp(e = '%s', идент = '%s')\n", e.вТкст0(), идент.вТкст0());
        }
        // References just forward things along
        return mt.следщ.dotExp(sc, e, идент, флаг);
    }

    Выражение visitDelegate(TypeDelegate mt)
    {
        static if (LOGDOTEXP)
        {
            printf("TypeDelegate::dotExp(e = '%s', идент = '%s')\n", e.вТкст0(), идент.вТкст0());
        }
        if (идент == Id.ptr)
        {
            e = new DelegatePtrExp(e.место, e);
            e = e.ВыражениеSemantic(sc);
        }
        else if (идент == Id.funcptr)
        {
            if (!(флаг & DotExpFlag.noDeref) && sc.func && !sc.intypeof && !(sc.flags & SCOPE.debug_) && sc.func.setUnsafe())
            {
                e.выведиОшибку("`%s.funcptr` cannot be используется in `` code", e.вТкст0());
                return new ErrorExp();
            }
            e = new DelegateFuncptrExp(e.место, e);
            e = e.ВыражениеSemantic(sc);
        }
        else
        {
            return visitType(mt);
        }
        return e;
    }

    /***************************************
     * Figures out what to do with an undefined member reference
     * for classes and structs.
     *
     * If флаг & 1, don't report "not a property" error and just return NULL.
     */
    Выражение noMember(Тип mt, Scope* sc, Выражение e, Идентификатор2 идент, цел флаг)
    {
        //printf("Тип.noMember(e: %s идент: %s флаг: %d)\n", e.вТкст0(), идент.вТкст0(), флаг);

        бул gagError = флаг & 1;

         цел nest;      // https://issues.dlang.org/show_bug.cgi?ид=17380

        static Выражение returnExp(Выражение e)
        {
            --nest;
            return e;
        }

        if (++nest > глоб2.recursionLimit)
        {
            .выведиОшибку(e.место, "cannot resolve идентификатор `%s`", идент.вТкст0());
            return returnExp(gagError ? null : new ErrorExp());
        }


        assert(mt.ty == Tstruct || mt.ty == Tclass);
        auto sym = mt.toDsymbol(sc).isAggregateDeclaration();
        assert(sym);
        if (идент != Id.__sizeof &&
            идент != Id.__xalignof &&
            идент != Id._иниц &&
            идент != Id._mangleof &&
            идент != Id.stringof &&
            идент != Id.offsetof &&
            // https://issues.dlang.org/show_bug.cgi?ид=15045
            // Don't forward special built-in member functions.
            идент != Id.ctor &&
            идент != Id.dtor &&
            идент != Id.__xdtor &&
            идент != Id.postblit &&
            идент != Id.__xpostblit)
        {
            /* Look for overloaded opDot() to see if we should forward request
             * to it.
             */
            if (auto fd = search_function(sym, Id.opDot))
            {
                /* Rewrite e.идент as:
                 *  e.opDot().идент
                 */
                e = build_overload(e.место, sc, e, null, fd);
                // @@@DEPRECATED_2.087@@@.
                e.deprecation("`opDot` is deprecated. Use `alias this`");
                e = new DotIdExp(e.место, e, идент);
                return returnExp(e.ВыражениеSemantic(sc));
            }

            /* Look for overloaded opDispatch to see if we should forward request
             * to it.
             */
            if (auto fd = search_function(sym, Id.opDispatch))
            {
                /* Rewrite e.идент as:
                 *  e.opDispatch!("идент")
                 */
                TemplateDeclaration td = fd.isTemplateDeclaration();
                if (!td)
                {
                    fd.выведиОшибку("must be a template `opDispatch(ткст s)`, not a %s", fd.вид());
                    return returnExp(new ErrorExp());
                }
                auto se = new StringExp(e.место, идент.вТкст());
                auto tiargs = new Объекты();
                tiargs.сунь(se);
                auto dti = new DotTemplateInstanceExp(e.место, e, Id.opDispatch, tiargs);
                dti.ti.tempdecl = td;
                /* opDispatch, which doesn't need IFTI,  may occur instantiate error.
                 * e.g.
                 *  template opDispatch(имя) if (isValid!имя) { ... }
                 */
                бцел errors = gagError ? глоб2.startGagging() : 0;
                e = dti.semanticY(sc, 0);
                if (gagError && глоб2.endGagging(errors))
                    e = null;
                return returnExp(e);
            }

            /* See if we should forward to the alias this.
             */
            auto alias_e = resolveAliasThis(sc, e, gagError);
            if (alias_e && alias_e != e)
            {
                /* Rewrite e.идент as:
                 *  e.aliasthis.идент
                 */
                auto die = new DotIdExp(e.место, alias_e, идент);

                auto errors = gagError ? 0 : глоб2.startGagging();
                auto exp = die.semanticY(sc, gagError);
                if (!gagError)
                {
                    глоб2.endGagging(errors);
                    if (exp && exp.op == ТОК2.error)
                        exp = null;
                }

                if (exp && gagError)
                    // now that we know that the alias this leads somewhere useful,
                    // go back and print deprecations/warnings that we skipped earlier due to the gag
                    resolveAliasThis(sc, e, нет);

                return returnExp(exp);
            }
        }
        return returnExp(visitType(mt));
    }

    Выражение visitStruct(TypeStruct mt)
    {
        ДСимвол s;
        static if (LOGDOTEXP)
        {
            printf("TypeStruct::dotExp(e = '%s', идент = '%s')\n", e.вТкст0(), идент.вТкст0());
        }
        assert(e.op != ТОК2.dot);

        // https://issues.dlang.org/show_bug.cgi?ид=14010
        if (идент == Id._mangleof)
        {
            return mt.getProperty(e.место, идент, флаг & 1);
        }

        /* If e.tupleof
         */
        if (идент == Id._tupleof)
        {
            /* Create a TupleExp out of the fields of the struct e:
             * (e.field0, e.field1, e.field2, ...)
             */
            e = e.ВыражениеSemantic(sc); // do this before turning on noaccesscheck

            if (!mt.sym.determineFields())
            {
                выведиОшибку(e.место, "unable to determine fields of `%s` because of forward references", mt.вТкст0());
            }

            Выражение e0;
            Выражение ev = e.op == ТОК2.тип ? null : e;
            if (ev)
                ev = extractSideEffect(sc, "__tup", e0, ev);

            auto exps = new Выражения();
            exps.резервируй(mt.sym.fields.dim);
            for (т_мера i = 0; i < mt.sym.fields.dim; i++)
            {
                VarDeclaration v = mt.sym.fields[i];
                Выражение ex;
                if (ev)
                    ex = new DotVarExp(e.место, ev, v);
                else
                {
                    ex = new VarExp(e.место, v);
                    ex.тип = ex.тип.addMod(e.тип.mod);
                }
                exps.сунь(ex);
            }

            e = new TupleExp(e.место, e0, exps);
            Scope* sc2 = sc.сунь();
            sc2.flags |= глоб2.парамы.vsafe ? SCOPE.onlysafeaccess : SCOPE.noaccesscheck;
            e = e.ВыражениеSemantic(sc2);
            sc2.вынь();
            return e;
        }

        const flags = sc.flags & SCOPE.ignoresymbolvisibility ? IgnoreSymbolVisibility : 0;
        s = mt.sym.search(e.место, идент, flags | IgnorePrivateImports);
    L1:
        if (!s)
        {
            return noMember(mt, sc, e, идент, флаг);
        }
        if (!(sc.flags & SCOPE.ignoresymbolvisibility) && !symbolIsVisible(sc, s))
        {
            return noMember(mt, sc, e, идент, флаг);
        }
        if (!s.isFuncDeclaration()) // because of overloading
        {
            s.checkDeprecated(e.место, sc);
            if (auto d = s.isDeclaration())
                d.checkDisabled(e.место, sc);
        }
        s = s.toAlias();

        if (auto em = s.isEnumMember())
        {
            return em.getVarExp(e.место, sc);
        }
        if (auto v = s.isVarDeclaration())
        {
            if (!v.тип ||
                !v.тип.deco && v.inuse)
            {
                if (v.inuse) // https://issues.dlang.org/show_bug.cgi?ид=9494
                    e.выведиОшибку("circular reference to %s `%s`", v.вид(), v.toPrettyChars());
                else
                    e.выведиОшибку("forward reference to %s `%s`", v.вид(), v.toPrettyChars());
                return new ErrorExp();
            }
            if (v.тип.ty == Terror)
            {
                return new ErrorExp();
            }

            if ((v.класс_хранения & STC.manifest) && v._иниц)
            {
                if (v.inuse)
                {
                    e.выведиОшибку("circular initialization of %s `%s`", v.вид(), v.toPrettyChars());
                    return new ErrorExp();
                }
                checkAccess(e.место, sc, null, v);
                Выражение ve = new VarExp(e.место, v);
                if (!isTrivialExp(e))
                {
                    ve = new CommaExp(e.место, e, ve);
                }
                return ve.ВыражениеSemantic(sc);
            }
        }

        if (auto t = s.getType())
        {
            return (new TypeExp(e.место, t)).ВыражениеSemantic(sc);
        }

        TemplateMixin tm = s.isTemplateMixin();
        if (tm)
        {
            Выражение de = new DotExp(e.место, e, new ScopeExp(e.место, tm));
            de.тип = e.тип;
            return de;
        }

        TemplateDeclaration td = s.isTemplateDeclaration();
        if (td)
        {
            if (e.op == ТОК2.тип)
                e = new TemplateExp(e.место, td);
            else
                e = new DotTemplateExp(e.место, e, td);
            return e.ВыражениеSemantic(sc);
        }

        TemplateInstance ti = s.isTemplateInstance();
        if (ti)
        {
            if (!ti.semanticRun)
            {
                ti.dsymbolSemantic(sc);
                if (!ti.inst || ti.errors) // if template failed to expand
                {
                    return new ErrorExp();
                }
            }
            s = ti.inst.toAlias();
            if (!s.isTemplateInstance())
                goto L1;
            if (e.op == ТОК2.тип)
                e = new ScopeExp(e.место, ti);
            else
                e = new DotExp(e.место, e, new ScopeExp(e.место, ti));
            return e.ВыражениеSemantic(sc);
        }

        if (s.isImport() || s.isModule() || s.isPackage())
        {
            return symbolToExp(s, e.место, sc, нет);
        }

        OverloadSet o = s.isOverloadSet();
        if (o)
        {
            auto oe = new OverExp(e.место, o);
            if (e.op == ТОК2.тип)
            {
                return oe;
            }
            return new DotExp(e.место, e, oe);
        }

        Declaration d = s.isDeclaration();
        if (!d)
        {
            e.выведиОшибку("`%s.%s` is not a declaration", e.вТкст0(), идент.вТкст0());
            return new ErrorExp();
        }

        if (e.op == ТОК2.тип)
        {
            /* It's:
             *    Struct.d
             */
            if (TupleDeclaration tup = d.isTupleDeclaration())
            {
                e = new TupleExp(e.место, tup);
                return e.ВыражениеSemantic(sc);
            }
            if (d.needThis() && sc.intypeof != 1)
            {
                /* Rewrite as:
                 *  this.d
                 */
                if (hasThis(sc))
                {
                    e = new DotVarExp(e.место, new ThisExp(e.место), d);
                    return e.ВыражениеSemantic(sc);
                }
            }
            if (d.semanticRun == PASS.init)
                d.dsymbolSemantic(null);
            checkAccess(e.место, sc, e, d);
            auto ve = new VarExp(e.место, d);
            if (d.isVarDeclaration() && d.needThis())
                ve.тип = d.тип.addMod(e.тип.mod);
            return ve;
        }

        бул unreal = e.op == ТОК2.variable && (cast(VarExp)e).var.isField();
        if (d.isDataseg() || unreal && d.isField())
        {
            // (e, d)
            checkAccess(e.место, sc, e, d);
            Выражение ve = new VarExp(e.место, d);
            e = unreal ? ve : new CommaExp(e.место, e, ve);
            return e.ВыражениеSemantic(sc);
        }

        e = new DotVarExp(e.место, e, d);
        return e.ВыражениеSemantic(sc);
    }

    Выражение visitEnum(TypeEnum mt)
    {
        static if (LOGDOTEXP)
        {
            printf("TypeEnum::dotExp(e = '%s', идент = '%s') '%s'\n", e.вТкст0(), идент.вТкст0(), mt.вТкст0());
        }
        // https://issues.dlang.org/show_bug.cgi?ид=14010
        if (идент == Id._mangleof)
        {
            return mt.getProperty(e.место, идент, флаг & 1);
        }

        if (mt.sym.semanticRun < PASS.semanticdone)
            mt.sym.dsymbolSemantic(null);
        if (!mt.sym.члены)
        {
            if (mt.sym.isSpecial())
            {
                /* Special enums forward to the base тип
                 */
                e = mt.sym.memtype.dotExp(sc, e, идент, флаг);
            }
            else if (!(флаг & 1))
            {
                mt.sym.выведиОшибку("is forward referenced when looking for `%s`", идент.вТкст0());
                e = new ErrorExp();
            }
            else
                e = null;
            return e;
        }

        ДСимвол s = mt.sym.search(e.место, идент);
        if (!s)
        {
            if (идент == Id.max || идент == Id.min || идент == Id._иниц)
            {
                return mt.getProperty(e.место, идент, флаг & 1);
            }

            Выражение res = mt.sym.getMemtype(Место.initial).dotExp(sc, e, идент, 1);
            if (!(флаг & 1) && !res)
            {
                if (auto ns = mt.sym.search_correct(идент))
                    e.выведиОшибку("no property `%s` for тип `%s`. Did you mean `%s.%s` ?", идент.вТкст0(), mt.вТкст0(), mt.вТкст0(),
                        ns.вТкст0());
                else
                    e.выведиОшибку("no property `%s` for тип `%s`", идент.вТкст0(),
                        mt.вТкст0());

                return new ErrorExp();
            }
            return res;
        }
        EnumMember m = s.isEnumMember();
        return m.getVarExp(e.место, sc);
    }

    Выражение visitClass(TypeClass mt)
    {
        ДСимвол s;
        static if (LOGDOTEXP)
        {
            printf("TypeClass::dotExp(e = '%s', идент = '%s')\n", e.вТкст0(), идент.вТкст0());
        }
        assert(e.op != ТОК2.dot);

        // https://issues.dlang.org/show_bug.cgi?ид=12543
        if (идент == Id.__sizeof || идент == Id.__xalignof || идент == Id._mangleof)
        {
            return mt.Тип.getProperty(e.место, идент, 0);
        }

        /* If e.tupleof
         */
        if (идент == Id._tupleof)
        {
            objc.checkTupleof(e, mt);

            /* Create a TupleExp
             */
            e = e.ВыражениеSemantic(sc); // do this before turning on noaccesscheck

            mt.sym.size(e.место); // do semantic of тип

            Выражение e0;
            Выражение ev = e.op == ТОК2.тип ? null : e;
            if (ev)
                ev = extractSideEffect(sc, "__tup", e0, ev);

            auto exps = new Выражения();
            exps.резервируй(mt.sym.fields.dim);
            for (т_мера i = 0; i < mt.sym.fields.dim; i++)
            {
                VarDeclaration v = mt.sym.fields[i];
                // Don't include hidden 'this' pointer
                if (v.isThisDeclaration())
                    continue;
                Выражение ex;
                if (ev)
                    ex = new DotVarExp(e.место, ev, v);
                else
                {
                    ex = new VarExp(e.место, v);
                    ex.тип = ex.тип.addMod(e.тип.mod);
                }
                exps.сунь(ex);
            }

            e = new TupleExp(e.место, e0, exps);
            Scope* sc2 = sc.сунь();
            sc2.flags |= глоб2.парамы.vsafe ? SCOPE.onlysafeaccess : SCOPE.noaccesscheck;
            e = e.ВыражениеSemantic(sc2);
            sc2.вынь();
            return e;
        }

        цел flags = sc.flags & SCOPE.ignoresymbolvisibility ? IgnoreSymbolVisibility : 0;
        s = mt.sym.search(e.место, идент, flags | IgnorePrivateImports);

    L1:
        if (!s)
        {
            // See if it's 'this' class or a base class
            if (mt.sym.идент == идент)
            {
                if (e.op == ТОК2.тип)
                {
                    return mt.Тип.getProperty(e.место, идент, 0);
                }
                e = new DotTypeExp(e.место, e, mt.sym);
                e = e.ВыражениеSemantic(sc);
                return e;
            }
            if (auto cbase = mt.sym.searchBase(идент))
            {
                if (e.op == ТОК2.тип)
                {
                    return mt.Тип.getProperty(e.место, идент, 0);
                }
                if (auto ifbase = cbase.isInterfaceDeclaration())
                    e = new CastExp(e.место, e, ifbase.тип);
                else
                    e = new DotTypeExp(e.место, e, cbase);
                e = e.ВыражениеSemantic(sc);
                return e;
            }

            if (идент == Id.classinfo)
            {
                if (!Тип.typeinfoclass)
                {
                    выведиОшибку(e.место, "`объект.TypeInfo_Class` could not be found, but is implicitly используется");
                    return new ErrorExp();
                }

                Тип t = Тип.typeinfoclass.тип;
                if (e.op == ТОК2.тип || e.op == ТОК2.dotType)
                {
                    /* For тип.classinfo, we know the classinfo
                     * at compile time.
                     */
                    if (!mt.sym.vclassinfo)
                        mt.sym.vclassinfo = new TypeInfoClassDeclaration(mt.sym.тип);
                    e = new VarExp(e.место, mt.sym.vclassinfo);
                    e = e.addressOf();
                    e.тип = t; // do this so we don't get redundant dereference
                }
                else
                {
                    /* For class objects, the classinfo reference is the first
                     * entry in the vtbl[]
                     */
                    e = new PtrExp(e.место, e);
                    e.тип = t.pointerTo();
                    if (mt.sym.isInterfaceDeclaration())
                    {
                        if (mt.sym.isCPPinterface())
                        {
                            /* C++ interface vtbl[]s are different in that the
                             * first entry is always pointer to the first virtual
                             * function, not classinfo.
                             * We can't get a .classinfo for it.
                             */
                            выведиОшибку(e.место, "no `.classinfo` for C++ interface objects");
                        }
                        /* For an interface, the first entry in the vtbl[]
                         * is actually a pointer to an instance of struct Interface.
                         * The first member of Interface is the .classinfo,
                         * so add an extra pointer indirection.
                         */
                        e.тип = e.тип.pointerTo();
                        e = new PtrExp(e.место, e);
                        e.тип = t.pointerTo();
                    }
                    e = new PtrExp(e.место, e, t);
                }
                return e;
            }

            if (идент == Id.__vptr)
            {
                /* The pointer to the vtbl[]
                 * *cast(const(ук)**)e
                 */
                e = e.castTo(sc, mt.tvoidptr.immutableOf().pointerTo().pointerTo());
                e = new PtrExp(e.место, e);
                e = e.ВыражениеSemantic(sc);
                return e;
            }

            if (идент == Id.__monitor && mt.sym.hasMonitor())
            {
                /* The handle to the monitor (call it a ук)
                 * *(cast(ук*)e + 1)
                 */
                e = e.castTo(sc, mt.tvoidptr.pointerTo());
                e = new AddExp(e.место, e, IntegerExp.literal!(1));
                e = new PtrExp(e.место, e);
                e = e.ВыражениеSemantic(sc);
                return e;
            }

            if (идент == Id.outer && mt.sym.vthis)
            {
                if (mt.sym.vthis.semanticRun == PASS.init)
                    mt.sym.vthis.dsymbolSemantic(null);

                if (auto cdp = mt.sym.toParentLocal().isClassDeclaration())
                {
                    auto dve = new DotVarExp(e.место, e, mt.sym.vthis);
                    dve.тип = cdp.тип.addMod(e.тип.mod);
                    return dve;
                }

                /* https://issues.dlang.org/show_bug.cgi?ид=15839
                 * Find closest родитель class through nested functions.
                 */
                for (auto p = mt.sym.toParentLocal(); p; p = p.toParentLocal())
                {
                    auto fd = p.isFuncDeclaration();
                    if (!fd)
                        break;
                    auto ad = fd.isThis();
                    if (!ad && fd.isNested())
                        continue;
                    if (!ad)
                        break;
                    if (auto cdp = ad.isClassDeclaration())
                    {
                        auto ve = new ThisExp(e.место);

                        ve.var = fd.vthis;
                        const nestedError = fd.vthis.checkNestedReference(sc, e.место);
                        assert(!nestedError);

                        ve.тип = cdp.тип.addMod(fd.vthis.тип.mod).addMod(e.тип.mod);
                        return ve;
                    }
                    break;
                }

                // Continue to show enclosing function's frame (stack or closure).
                auto dve = new DotVarExp(e.место, e, mt.sym.vthis);
                dve.тип = mt.sym.vthis.тип.addMod(e.тип.mod);
                return dve;
            }

            return noMember(mt, sc, e, идент, флаг & 1);
        }
        if (!(sc.flags & SCOPE.ignoresymbolvisibility) && !symbolIsVisible(sc, s))
        {
            return noMember(mt, sc, e, идент, флаг);
        }
        if (!s.isFuncDeclaration()) // because of overloading
        {
            s.checkDeprecated(e.место, sc);
            if (auto d = s.isDeclaration())
                d.checkDisabled(e.место, sc);
        }
        s = s.toAlias();

        if (auto em = s.isEnumMember())
        {
            return em.getVarExp(e.место, sc);
        }
        if (auto v = s.isVarDeclaration())
        {
            if (!v.тип ||
                !v.тип.deco && v.inuse)
            {
                if (v.inuse) // https://issues.dlang.org/show_bug.cgi?ид=9494
                    e.выведиОшибку("circular reference to %s `%s`", v.вид(), v.toPrettyChars());
                else
                    e.выведиОшибку("forward reference to %s `%s`", v.вид(), v.toPrettyChars());
                return new ErrorExp();
            }
            if (v.тип.ty == Terror)
            {
                return new ErrorExp();
            }

            if ((v.класс_хранения & STC.manifest) && v._иниц)
            {
                if (v.inuse)
                {
                    e.выведиОшибку("circular initialization of %s `%s`", v.вид(), v.toPrettyChars());
                    return new ErrorExp();
                }
                checkAccess(e.место, sc, null, v);
                Выражение ve = new VarExp(e.место, v);
                ve = ve.ВыражениеSemantic(sc);
                return ve;
            }
        }

        if (auto t = s.getType())
        {
            return (new TypeExp(e.место, t)).ВыражениеSemantic(sc);
        }

        TemplateMixin tm = s.isTemplateMixin();
        if (tm)
        {
            Выражение de = new DotExp(e.место, e, new ScopeExp(e.место, tm));
            de.тип = e.тип;
            return de;
        }

        TemplateDeclaration td = s.isTemplateDeclaration();
        if (td)
        {
            if (e.op == ТОК2.тип)
                e = new TemplateExp(e.место, td);
            else
                e = new DotTemplateExp(e.место, e, td);
            e = e.ВыражениеSemantic(sc);
            return e;
        }

        TemplateInstance ti = s.isTemplateInstance();
        if (ti)
        {
            if (!ti.semanticRun)
            {
                ti.dsymbolSemantic(sc);
                if (!ti.inst || ti.errors) // if template failed to expand
                {
                    return new ErrorExp();
                }
            }
            s = ti.inst.toAlias();
            if (!s.isTemplateInstance())
                goto L1;
            if (e.op == ТОК2.тип)
                e = new ScopeExp(e.место, ti);
            else
                e = new DotExp(e.место, e, new ScopeExp(e.место, ti));
            return e.ВыражениеSemantic(sc);
        }

        if (s.isImport() || s.isModule() || s.isPackage())
        {
            e = symbolToExp(s, e.место, sc, нет);
            return e;
        }

        OverloadSet o = s.isOverloadSet();
        if (o)
        {
            auto oe = new OverExp(e.место, o);
            if (e.op == ТОК2.тип)
            {
                return oe;
            }
            return new DotExp(e.место, e, oe);
        }

        Declaration d = s.isDeclaration();
        if (!d)
        {
            e.выведиОшибку("`%s.%s` is not a declaration", e.вТкст0(), идент.вТкст0());
            return new ErrorExp();
        }

        if (e.op == ТОК2.тип)
        {
            /* It's:
             *    Class.d
             */
            if (TupleDeclaration tup = d.isTupleDeclaration())
            {
                e = new TupleExp(e.место, tup);
                e = e.ВыражениеSemantic(sc);
                return e;
            }

            if (mt.sym.classKind == ClassKind.objc
                && d.isFuncDeclaration()
                && d.isFuncDeclaration().isStatic
                && d.isFuncDeclaration().selector)
            {
                auto classRef = new ObjcClassReferenceExp(e.место, mt.sym);
                auto rez = new DotVarExp(e.место, classRef, d);
                return rez.ВыражениеSemantic(sc);
            }
            else if (d.needThis() && sc.intypeof != 1)
            {
                /* Rewrite as:
                 *  this.d
                 */
                AggregateDeclaration ad = d.isMemberLocal();
                if (auto f = hasThis(sc))
                {
                    // This is almost same as getRightThis() in Выражениеsem.d
                    Выражение e1;
                    Тип t;
                    /* returns: да to continue, нет to return */
                    if (f.isThis2)
                    {
                        if (f.followInstantiationContext(ad))
                        {
                            e1 = new VarExp(e.место, f.vthis);
                            e1 = new PtrExp(e1.место, e1);
                            e1 = new IndexExp(e1.место, e1, IntegerExp.literal!(1));
                            auto pd = f.toParent2().isDeclaration();
                            assert(pd);
                            t = pd.тип.toBasetype();
                            e1 = getThisSkipNestedFuncs(e1.место, sc, f.toParent2(), ad, e1, t, d, да);
                            if (!e1)
                            {
                                e = new VarExp(e.место, d);
                                return e;
                            }
                            goto L2;
                        }
                    }
                    e1 = new ThisExp(e.место);
                    e1 = e1.ВыражениеSemantic(sc);
                L2:
                    t = e1.тип.toBasetype();
                    ClassDeclaration cd = e.тип.isClassHandle();
                    ClassDeclaration tcd = t.isClassHandle();
                    if (cd && tcd && (tcd == cd || cd.isBaseOf(tcd, null)))
                    {
                        e = new DotTypeExp(e1.место, e1, cd);
                        e = new DotVarExp(e.место, e, d);
                        e = e.ВыражениеSemantic(sc);
                        return e;
                    }
                    if (tcd && tcd.isNested())
                    {
                        /* e1 is the 'this' pointer for an inner class: tcd.
                         * Rewrite it as the 'this' pointer for the outer class.
                         */
                        auto vthis = tcd.followInstantiationContext(ad) ? tcd.vthis2 : tcd.vthis;
                        e1 = new DotVarExp(e.место, e1, vthis);
                        e1.тип = vthis.тип;
                        e1.тип = e1.тип.addMod(t.mod);
                        // Do not call ensureStaticLinkTo()
                        //e1 = e1.ВыражениеSemantic(sc);

                        // Skip up over nested functions, and get the enclosing
                        // class тип.
                        e1 = getThisSkipNestedFuncs(e1.место, sc, tcd.toParentP(ad), ad, e1, t, d, да);
                        if (!e1)
                        {
                            e = new VarExp(e.место, d);
                            return e;
                        }
                        goto L2;
                    }
                }
            }
            //printf("e = %s, d = %s\n", e.вТкст0(), d.вТкст0());
            if (d.semanticRun == PASS.init)
                d.dsymbolSemantic(null);

            // If static function, get the most visible overload.
            // Later on the call is checked for correctness.
            // https://issues.dlang.org/show_bug.cgi?ид=12511
            if (auto fd = d.isFuncDeclaration())
            {                
                d = cast(Declaration)mostVisibleOverload(fd, sc._module);
            }

            checkAccess(e.место, sc, e, d);
            auto ve = new VarExp(e.место, d);
            if (d.isVarDeclaration() && d.needThis())
                ve.тип = d.тип.addMod(e.тип.mod);
            return ve;
        }

        бул unreal = e.op == ТОК2.variable && (cast(VarExp)e).var.isField();
        if (d.isDataseg() || unreal && d.isField())
        {
            // (e, d)
            checkAccess(e.место, sc, e, d);
            Выражение ve = new VarExp(e.место, d);
            e = unreal ? ve : new CommaExp(e.место, e, ve);
            e = e.ВыражениеSemantic(sc);
            return e;
        }

        e = new DotVarExp(e.место, e, d);
        e = e.ВыражениеSemantic(sc);
        return e;
    }

    switch (mt.ty)
    {
        case Tvector:    return visitVector   (cast(TypeVector)mt);
        case Tsarray:    return visitSArray   (cast(TypeSArray)mt);
        case Tstruct:    return visitStruct   (cast(TypeStruct)mt);
        case Tenum:      return visitEnum     (cast(TypeEnum)mt);
        case Terror:     return visitError    (cast(TypeError)mt);
        case Tarray:     return visitDArray   (cast(TypeDArray)mt);
        case Taarray:    return visitAArray   (cast(TypeAArray)mt);
        case Treference: return visitReference(cast(TypeReference)mt);
        case Tdelegate:  return visitDelegate (cast(TypeDelegate)mt);
        case Tclass:     return visitClass    (cast(TypeClass)mt);

        default:         return mt.isTypeBasic()
                                ? visitBasic(cast(TypeBasic)mt)
                                : visitType(mt);
    }
}


/************************
 * Get the the default initialization Выражение for a тип.
 * Параметры:
 *  mt = the тип for which the init Выражение is returned
 *  место = the location where the Выражение needs to be evaluated
 *
 * Возвращает:
 *  The initialization Выражение for the тип.
 */
Выражение defaultInit(Тип mt, ref Место место)
{
    Выражение visitBasic(TypeBasic mt)
    {
        static if (LOGDEFAULTINIT)
        {
            printf("TypeBasic::defaultInit() '%s'\n", mt.вТкст0());
        }
        dinteger_t значение = 0;

        switch (mt.ty)
        {
        case Tchar:
            значение = 0xFF;
            break;

        case Twchar:
        case Tdchar:
            значение = 0xFFFF;
            break;

        case Timaginary32:
        case Timaginary64:
        case Timaginary80:
        case Tfloat32:
        case Tfloat64:
        case Tfloat80:
            return new RealExp(место, target.RealProperties.nan, mt);

        case Tcomplex32:
        case Tcomplex64:
        case Tcomplex80:
            {
                // Can't use fvalue + I*fvalue (the im part becomes a quiet NaN).
                const cvalue = complex_t(target.RealProperties.nan, target.RealProperties.nan);
                return new ComplexExp(место, cvalue, mt);
            }

        case Tvoid:
            выведиОшибку(место, "`проц` does not have a default инициализатор");
            return new ErrorExp();

        default:
            break;
        }
        return new IntegerExp(место, значение, mt);
    }

    Выражение visitVector(TypeVector mt)
    {
        //printf("TypeVector::defaultInit()\n");
        assert(mt.basetype.ty == Tsarray);
        Выражение e = mt.basetype.defaultInit(место);
        auto ve = new VectorExp(место, e, mt);
        ve.тип = mt;
        ve.dim = cast(цел)(mt.basetype.size(место) / mt.elementType().size(место));
        return ve;
    }

    Выражение visitSArray(TypeSArray mt)
    {
        static if (LOGDEFAULTINIT)
        {
            printf("TypeSArray::defaultInit() '%s'\n", mt.вТкст0());
        }
        if (mt.следщ.ty == Tvoid)
            return mt.tuns8.defaultInit(место);
        else
            return mt.следщ.defaultInit(место);
    }

    Выражение visitFunction(TypeFunction mt)
    {
        выведиОшибку(место, "`function` does not have a default инициализатор");
        return new ErrorExp();
    }

    Выражение visitStruct(TypeStruct mt)
    {
        static if (LOGDEFAULTINIT)
        {
            printf("TypeStruct::defaultInit() '%s'\n", mt.вТкст0());
        }
        Declaration d = new SymbolDeclaration(mt.sym.место, mt.sym);
        assert(d);
        d.тип = mt;
        d.класс_хранения |= STC.rvalue; // https://issues.dlang.org/show_bug.cgi?ид=14398
        return new VarExp(mt.sym.место, d);
    }

    Выражение visitEnum(TypeEnum mt)
    {
        static if (LOGDEFAULTINIT)
        {
            printf("TypeEnum::defaultInit() '%s'\n", mt.вТкст0());
        }
        // Initialize to first member of enum
        Выражение e = mt.sym.getDefaultValue(место);
        e = e.копируй();
        e.место = место;
        e.тип = mt; // to deal with const, const, etc., variants
        return e;
    }

    Выражение visitTuple(КортежТипов mt)
    {
        static if (LOGDEFAULTINIT)
        {
            printf("КортежТипов::defaultInit() '%s'\n", mt.вТкст0());
        }
        auto exps = new Выражения(mt.arguments.dim);
        for (т_мера i = 0; i < mt.arguments.dim; i++)
        {
            Параметр2 p = (*mt.arguments)[i];
            assert(p.тип);
            Выражение e = p.тип.defaultInitLiteral(место);
            if (e.op == ТОК2.error)
            {
                return e;
            }
            (*exps)[i] = e;
        }
        return new TupleExp(место, exps);
    }

    switch (mt.ty)
    {
        case Tvector:   return visitVector  (cast(TypeVector)mt);
        case Tsarray:   return visitSArray  (cast(TypeSArray)mt);
        case Tfunction: return visitFunction(cast(TypeFunction)mt);
        case Tstruct:   return visitStruct  (cast(TypeStruct)mt);
        case Tenum:     return visitEnum    (cast(TypeEnum)mt);
        case Ttuple:    return visitTuple   (cast(КортежТипов)mt);

        case Tnull:     return new NullExp(Место.initial, Тип.tnull);

        case Terror:    return new ErrorExp();

        case Tarray:
        case Taarray:
        case Tpointer:
        case Treference:
        case Tdelegate:
        case Tclass:    return new NullExp(место, mt);

        default:        return mt.isTypeBasic() ?
                                visitBasic(cast(TypeBasic)mt) :
                                null;
    }
}
