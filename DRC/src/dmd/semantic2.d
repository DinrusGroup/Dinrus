/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/semantic2.d, _semantic2.d)
 * Documentation:  https://dlang.org/phobos/dmd_semantic2.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/semantic2.d
 */

module dmd.semantic2;

import cidrus;

import dmd.aggregate;
import dmd.aliasthis;
import dmd.arraytypes;
import drc.ast.AstCodegen;
import dmd.attrib;
import dmd.blockexit;
import dmd.clone;
import dmd.dcast;
import dmd.dclass;
import dmd.declaration;
import dmd.denum;
import dmd.dimport;
import dmd.dinterpret;
import dmd.dmodule;
import dmd.dscope;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.dtemplate;
import dmd.dversion;
import dmd.errors;
import dmd.escape;
import dmd.staticcond;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.init;
import dmd.initsem;
import dmd.hdrgen;
import dmd.mtype;
import dmd.nogc;
import dmd.nspace;
import dmd.objc;
import dmd.opover;
import drc.parser.Parser2;
import util.filename;
import util.outbuffer;
import util.rmem;
import drc.ast.Node;
import dmd.sideeffect;
import dmd.statementsem;
import dmd.staticassert;
import drc.lexer.Tokens;
import util.utf;
import dmd.инструкция;
import dmd.target;
import dmd.templateparamsem;
import dmd.typesem;
import drc.ast.Visitor;
import dmd.dmangle : mangleToFuncSignature;

const LOG = нет;


/*************************************
 * Does semantic analysis on initializers and члены of aggregates.
 */
/*extern(C++)*/ проц semantic2(ДСимвол dsym, Scope* sc)
{
    scope v = new Semantic2Visitor(sc);
    dsym.прими(v);
}

private /*extern(C++)*/ final class Semantic2Visitor : Визитор2
{
    alias Визитор2.посети посети;
    Scope* sc;
    this(Scope* sc)
    {
        this.sc = sc;
    }

    override проц посети(ДСимвол) {}

    override проц посети(StaticAssert sa)
    {
        //printf("StaticAssert::semantic2() %s\n", sa.вТкст0());
        auto sds = new ScopeDsymbol();
        sc = sc.сунь(sds);
        sc.tinst = null;
        sc.minst = null;

        
        бул errors;
        бул результат = evalStaticCondition(sc, sa.exp, sa.exp, errors);
        sc = sc.вынь();
        if (errors)
        {
            errorSupplemental(sa.место, "while evaluating: `static assert(%s)`", sa.exp.вТкст0());
        }
        else if (!результат)
        {
            if (sa.msg)
            {
                sc = sc.startCTFE();
                sa.msg = sa.msg.ВыражениеSemantic(sc);
                sa.msg = resolveProperties(sc, sa.msg);
                sc = sc.endCTFE();
                sa.msg = sa.msg.ctfeInterpret();
                if (StringExp se = sa.msg.вТкстExp())
                {
                    // same with pragma(msg)
                    const slice = se.toUTF8(sc).peekString();
                    выведиОшибку(sa.место, "static assert:  \"%.*s\"", cast(цел)slice.length, slice.ptr);
                }
                else
                    выведиОшибку(sa.место, "static assert:  %s", sa.msg.вТкст0());
            }
            else
                выведиОшибку(sa.место, "static assert:  `%s` is нет", sa.exp.вТкст0());
            if (sc.tinst)
                sc.tinst.printInstantiationTrace();
            if (!глоб2.gag)
                fatal();
        }
    }

    override проц посети(TemplateInstance tempinst)
    {
        if (tempinst.semanticRun >= PASS.semantic2)
            return;
        tempinst.semanticRun = PASS.semantic2;
        static if (LOG)
        {
            printf("+TemplateInstance.semantic2('%s')\n", tempinst.вТкст0());
        }
        if (!tempinst.errors && tempinst.члены)
        {
            TemplateDeclaration tempdecl = tempinst.tempdecl.isTemplateDeclaration();
            assert(tempdecl);

            sc = tempdecl._scope;
            assert(sc);
            sc = sc.сунь(tempinst.argsym);
            sc = sc.сунь(tempinst);
            sc.tinst = tempinst;
            sc.minst = tempinst.minst;

            цел needGagging = (tempinst.gagged && !глоб2.gag);
            бцел olderrors = глоб2.errors;
            цел oldGaggedErrors = -1; // dead-store to prevent spurious warning
            if (needGagging)
                oldGaggedErrors = глоб2.startGagging();

            for (т_мера i = 0; i < tempinst.члены.dim; i++)
            {
                ДСимвол s = (*tempinst.члены)[i];
                static if (LOG)
                {
                    printf("\tmember '%s', вид = '%s'\n", s.вТкст0(), s.вид());
                }
                s.semantic2(sc);
                if (tempinst.gagged && глоб2.errors != olderrors)
                    break;
            }

            if (глоб2.errors != olderrors)
            {
                if (!tempinst.errors)
                {
                    if (!tempdecl.literal)
                        tempinst.выведиОшибку(tempinst.место, "error instantiating");
                    if (tempinst.tinst)
                        tempinst.tinst.printInstantiationTrace();
                }
                tempinst.errors = да;
            }
            if (needGagging)
                глоб2.endGagging(oldGaggedErrors);

            sc = sc.вынь();
            sc.вынь();
        }
        static if (LOG)
        {
            printf("-TemplateInstance.semantic2('%s')\n", tempinst.вТкст0());
        }
    }

    override проц посети(TemplateMixin tmix)
    {
        if (tmix.semanticRun >= PASS.semantic2)
            return;
        tmix.semanticRun = PASS.semantic2;
        static if (LOG)
        {
            printf("+TemplateMixin.semantic2('%s')\n", tmix.вТкст0());
        }
        if (tmix.члены)
        {
            assert(sc);
            sc = sc.сунь(tmix.argsym);
            sc = sc.сунь(tmix);
            for (т_мера i = 0; i < tmix.члены.dim; i++)
            {
                ДСимвол s = (*tmix.члены)[i];
                static if (LOG)
                {
                    printf("\tmember '%s', вид = '%s'\n", s.вТкст0(), s.вид());
                }
                s.semantic2(sc);
            }
            sc = sc.вынь();
            sc.вынь();
        }
        static if (LOG)
        {
            printf("-TemplateMixin.semantic2('%s')\n", tmix.вТкст0());
        }
    }

    override проц посети(VarDeclaration vd)
    {
        if (vd.semanticRun < PASS.semanticdone && vd.inuse)
            return;

        //printf("VarDeclaration::semantic2('%s')\n", вТкст0());

        if (vd.aliassym)        // if it's a кортеж
        {
            vd.aliassym.прими(this);
            vd.semanticRun = PASS.semantic2done;
            return;
        }

        if (vd._иниц && !vd.toParent().isFuncDeclaration())
        {
            vd.inuse++;

            /* https://issues.dlang.org/show_bug.cgi?ид=20280
             *
             * Template instances may import modules that have not
             * finished semantic1.
             */
            if (!vd.тип)
                vd.dsymbolSemantic(sc);


            // https://issues.dlang.org/show_bug.cgi?ид=14166
            // https://issues.dlang.org/show_bug.cgi?ид=20417
            // Don't run CTFE for the temporary variables inside typeof or __traits(compiles)
            vd._иниц = vd._иниц.initializerSemantic(sc, vd.тип, sc.intypeof == 1 || sc.flags & SCOPE.compile ? INITnointerpret : INITinterpret);
            vd.inuse--;
        }
        if (vd._иниц && vd.класс_хранения & STC.manifest)
        {
            /* Cannot инициализатор enums with CTFE classreferences and addresses of struct literals.
             * Scan инициализатор looking for them. Issue error if found.
             */
            if (ExpInitializer ei = vd._иниц.isExpInitializer())
            {
                static бул hasInvalidEnumInitializer(Выражение e)
                {
                    static бул arrayHasInvalidEnumInitializer(Выражения* elems)
                    {
                        foreach (e; *elems)
                        {
                            if (e && hasInvalidEnumInitializer(e))
                                return да;
                        }
                        return нет;
                    }

                    if (e.op == ТОК2.classReference)
                        return да;
                    if (e.op == ТОК2.address && (cast(AddrExp)e).e1.op == ТОК2.structLiteral)
                        return да;
                    if (e.op == ТОК2.arrayLiteral)
                        return arrayHasInvalidEnumInitializer((cast(ArrayLiteralExp)e).elements);
                    if (e.op == ТОК2.structLiteral)
                        return arrayHasInvalidEnumInitializer((cast(StructLiteralExp)e).elements);
                    if (e.op == ТОК2.assocArrayLiteral)
                    {
                        AssocArrayLiteralExp ae = cast(AssocArrayLiteralExp)e;
                        return arrayHasInvalidEnumInitializer(ae.values) ||
                               arrayHasInvalidEnumInitializer(ae.keys);
                    }
                    return нет;
                }

                if (hasInvalidEnumInitializer(ei.exp))
                    vd.выведиОшибку(": Unable to initialize enum with class or pointer to struct. Use static const variable instead.");
            }
        }
        else if (vd._иниц && vd.isThreadlocal())
        {
            // Cannot initialize a thread-local class or pointer to struct variable with a literal
            // that itself is a thread-local reference and would need dynamic initialization also.
            if ((vd.тип.ty == Tclass) && vd.тип.isMutable() && !vd.тип.isShared())
            {
                ExpInitializer ei = vd._иниц.isExpInitializer();
                if (ei && ei.exp.op == ТОК2.classReference)
                    vd.выведиОшибку("is a thread-local class and cannot have a static инициализатор. Use `static this()` to initialize instead.");
            }
            else if (vd.тип.ty == Tpointer && vd.тип.nextOf().ty == Tstruct && vd.тип.nextOf().isMutable() && !vd.тип.nextOf().isShared())
            {
                ExpInitializer ei = vd._иниц.isExpInitializer();
                if (ei && ei.exp.op == ТОК2.address && (cast(AddrExp)ei.exp).e1.op == ТОК2.structLiteral)
                    vd.выведиОшибку("is a thread-local pointer to struct and cannot have a static инициализатор. Use `static this()` to initialize instead.");
            }
        }
        vd.semanticRun = PASS.semantic2done;
    }

    override проц посети(Module mod)
    {
        //printf("Module::semantic2('%s'): родитель = %p\n", вТкст0(), родитель);
        if (mod.semanticRun != PASS.semanticdone) // semantic() not completed yet - could be recursive call
            return;
        mod.semanticRun = PASS.semantic2;
        // Note that modules get their own scope, from scratch.
        // This is so regardless of where in the syntax a module
        // gets imported, it is unaffected by context.
        Scope* sc = Scope.createGlobal(mod); // создай root scope
        //printf("Module = %p\n", sc.scopesym);
        // Pass 2 semantic routines: do initializers and function bodies
        for (т_мера i = 0; i < mod.члены.dim; i++)
        {
            ДСимвол s = (*mod.члены)[i];
            s.semantic2(sc);
        }
        if (mod.userAttribDecl)
        {
            mod.userAttribDecl.semantic2(sc);
        }
        sc = sc.вынь();
        sc.вынь();
        mod.semanticRun = PASS.semantic2done;
        //printf("-Module::semantic2('%s'): родитель = %p\n", вТкст0(), родитель);
    }

    override проц посети(FuncDeclaration fd)
    {        
        if (fd.semanticRun >= PASS.semantic2done)
            return;
        assert(fd.semanticRun <= PASS.semantic2);
        fd.semanticRun = PASS.semantic2;

        //printf("FuncDeclaration::semantic2 [%s] fd0 = %s %s\n", место.вТкст0(), вТкст0(), тип.вТкст0());

        // https://issues.dlang.org/show_bug.cgi?ид=18385
        // Disable for 2.079, s.t. a deprecation cycle can be started with 2.080
        if (0)
        if (fd.overnext && !fd.errors)
        {
            БуфВыв buf1;
            БуфВыв buf2;

            // Always starts the lookup from 'this', because the conflicts with
            // previous overloads are already reported.
            auto f1 = fd;
            mangleToFuncSignature(buf1, f1);

            overloadApply(f1, (ДСимвол s)
            {
                auto f2 = s.isFuncDeclaration();
                if (!f2 || f1 == f2 || f2.errors)
                    return 0;

                // Don't have to check conflict between declaration and definition.
                if ((f1.fbody !is null) != (f2.fbody !is null))
                    return 0;

                /* Check for overload merging with base class member functions.
                 *
                 *  class B { проц foo() {} }
                 *  class D : B {
                 *    override проц foo() {}    // B.foo appears as f2
                 *    alias foo = B.foo;
                 *  }
                 */
                if (f1.overrides(f2))
                    return 0;

                // extern (C) functions always conflict each other.
                if (f1.идент == f2.идент &&
                    f1.toParent2() == f2.toParent2() &&
                    (f1.компонаж != LINK.d && f1.компонаж != LINK.cpp) &&
                    (f2.компонаж != LINK.d && f2.компонаж != LINK.cpp))
                {
                    /* Allow the hack that is actually используется in druntime,
                     * to ignore function attributes for extern (C) functions.
                     * TODO: Must be reconsidered in the future.
                     *  BUG: https://issues.dlang.org/show_bug.cgi?ид=18206
                     *
                     *  extern(C):
                     *  alias sigfn_t  = проц function(цел);
                     *  alias sigfn_t2 = проц function(цел)  ;
                     *  sigfn_t  bsd_signal(цел sig, sigfn_t  func);
                     *  sigfn_t2 bsd_signal(цел sig, sigfn_t2 func)  ;  // no error
                     */
                    if (f1.fbody is null || f2.fbody is null)
                        return 0;

                    auto tf1 = cast(TypeFunction)f1.тип;
                    auto tf2 = cast(TypeFunction)f2.тип;
                    выведиОшибку(f2.место, "%s `%s%s` cannot be overloaded with %s`extern(%s)` function at %s",
                            f2.вид(),
                            f2.toPrettyChars(),
                            parametersTypeToChars(tf2.parameterList),
                            (f1.компонаж == f2.компонаж ? "another " : "").ptr,
                            компонажВТкст0(f1.компонаж), f1.место.вТкст0());
                    f2.тип = Тип.terror;
                    f2.errors = да;
                    return 0;
                }

                buf2.сбрось();
                mangleToFuncSignature(buf2, f2);

                auto s1 = buf1.peekChars();
                auto s2 = buf2.peekChars();

                //printf("+%s\n\ts1 = %s\n\ts2 = %s @ [%s]\n", вТкст0(), s1, s2, f2.место.вТкст0());
                if (strcmp(s1, s2) == 0)
                {
                    auto tf2 = cast(TypeFunction)f2.тип;
                    выведиОшибку(f2.место, "%s `%s%s` conflicts with previous declaration at %s",
                            f2.вид(),
                            f2.toPrettyChars(),
                            parametersTypeToChars(tf2.parameterList),
                            f1.место.вТкст0());
                    f2.тип = Тип.terror;
                    f2.errors = да;
                }
                return 0;
            });
        }
        if (!fd.тип || fd.тип.ty != Tfunction)
            return;
        TypeFunction f = cast(TypeFunction) fd.тип;

        //semantic for parameters' UDAs
        foreach (i; new бцел[0 .. f.parameterList.length])
        {
            Параметр2 param = f.parameterList[i];
            if (param && param.userAttribDecl)
                param.userAttribDecl.semantic2(sc);
        }
    }

    override проц посети(Импорт i)
    {
        //printf("Импорт::semantic2('%s')\n", вТкст0());
        if (i.mod)
        {
            i.mod.semantic2(null);
            if (i.mod.needmoduleinfo)
            {
                //printf("module5 %s because of %s\n", sc.module.вТкст0(), mod.вТкст0());
                if (sc)
                    sc._module.needmoduleinfo = 1;
            }
        }
    }

    override проц посети(Nspace ns)
    {
        if (ns.semanticRun >= PASS.semantic2)
            return;
        ns.semanticRun = PASS.semantic2;
        static if (LOG)
        {
            printf("+Nspace::semantic2('%s')\n", ns.вТкст0());
        }
        if (ns.члены)
        {
            assert(sc);
            sc = sc.сунь(ns);
            sc.компонаж = LINK.cpp;
            foreach (s; *ns.члены)
            {
                static if (LOG)
                {
                    printf("\tmember '%s', вид = '%s'\n", s.вТкст0(), s.вид());
                }
                s.semantic2(sc);
            }
            sc.вынь();
        }
        static if (LOG)
        {
            printf("-Nspace::semantic2('%s')\n", ns.вТкст0());
        }
    }

    override проц посети(AttribDeclaration ad)
    {
        Дсимволы* d = ad.include(sc);
        if (d)
        {
            Scope* sc2 = ad.newScope(sc);
            for (т_мера i = 0; i < d.dim; i++)
            {
                ДСимвол s = (*d)[i];
                s.semantic2(sc2);
            }
            if (sc2 != sc)
                sc2.вынь();
        }
    }

    /**
     * Run the DeprecatedDeclaration's semantic2 phase then its члены.
     *
     * The message set via a `DeprecatedDeclaration` can be either of:
     * - a ткст literal
     * - an enum
     * - a static const
     * So we need to call ctfe to resolve it.
     * Afterward forwards to the члены' semantic2.
     */
    override проц посети(DeprecatedDeclaration dd)
    {
        getMessage(dd);
        посети(cast(AttribDeclaration)dd);
    }

    override проц посети(AlignDeclaration ad)
    {
        ad.getAlignment(sc);
        посети(cast(AttribDeclaration)ad);
    }

    override проц посети(UserAttributeDeclaration uad)
    {
        if (uad.decl && uad.atts && uad.atts.dim && uad._scope)
        {
            static проц eval(Scope* sc, Выражения* exps)
            {
                foreach (ref Выражение e; *exps)
                {
                    if (e)
                    {
                        e = e.ВыражениеSemantic(sc);
                        if (definitelyValueParameter(e))
                            e = e.ctfeInterpret();
                        if (e.op == ТОК2.кортеж)
                        {
                            TupleExp te = cast(TupleExp)e;
                            eval(sc, te.exps);
                        }
                    }
                }
            }

            uad._scope = null;
            eval(sc, uad.atts);
        }
        посети(cast(AttribDeclaration)uad);
    }

    override проц посети(AggregateDeclaration ad)
    {
        //printf("AggregateDeclaration::semantic2(%s) тип = %s, errors = %d\n", ad.вТкст0(), ad.тип.вТкст0(), ad.errors);
        if (!ad.члены)
            return;

        if (ad._scope)
        {
            ad.выведиОшибку("has forward references");
            return;
        }

        auto sc2 = ad.newScope(sc);

        ad.determineSize(ad.место);

        for (т_мера i = 0; i < ad.члены.dim; i++)
        {
            ДСимвол s = (*ad.члены)[i];
            //printf("\t[%d] %s\n", i, s.вТкст0());
            s.semantic2(sc2);
        }

        sc2.вынь();
    }
}
