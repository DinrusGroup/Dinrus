/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/semantic3.d, _semantic3.d)
 * Documentation:  https://dlang.org/phobos/dmd_semantic3.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/semantic3.d
 */

module dmd.semantic3;

import cidrus;

import dmd.aggregate;
import dmd.aliasthis;
import dmd.arraytypes;
import drc.ast.AstCodegen;
import dmd.attrib;
import dmd.blockexit;
import dmd.clone;
import dmd.ctorflow;
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
import dmd.ob;
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
import dmd.semantic2;
import dmd.инструкция;
import dmd.target;
import dmd.templateparamsem;
import dmd.typesem;
import drc.ast.Visitor;

const LOG = нет;


/*************************************
 * Does semantic analysis on function bodies.
 */
/*extern(C++)*/ проц semantic3(ДСимвол dsym, Scope* sc)
{
    scope v = new Semantic3Visitor(sc);
    dsym.прими(v);
}

private /*extern(C++)*/ final class Semantic3Visitor : Визитор2
{
    alias Визитор2.посети посети;

    Scope* sc;
    this(Scope* sc)
    {
        this.sc = sc;
    }

    override проц посети(ДСимвол) {}

    override проц посети(TemplateInstance tempinst)
    {
        static if (LOG)
        {
            printf("TemplateInstance.semantic3('%s'), semanticRun = %d\n", tempinst.вТкст0(), tempinst.semanticRun);
        }
        //if (вТкст0()[0] == 'D') *(сим*)0=0;
        if (tempinst.semanticRun >= PASS.semantic3)
            return;
        tempinst.semanticRun = PASS.semantic3;
        if (!tempinst.errors && tempinst.члены)
        {
            TemplateDeclaration tempdecl = tempinst.tempdecl.isTemplateDeclaration();
            assert(tempdecl);

            sc = tempdecl._scope;
            sc = sc.сунь(tempinst.argsym);
            sc = sc.сунь(tempinst);
            sc.tinst = tempinst;
            sc.minst = tempinst.minst;

            цел needGagging = (tempinst.gagged && !глоб2.gag);
            бцел olderrors = глоб2.errors;
            цел oldGaggedErrors = -1; // dead-store to prevent spurious warning
            /* If this is a gagged instantiation, gag errors.
             * Future optimisation: If the результатs are actually needed, errors
             * would already be gagged, so we don't really need to run semantic
             * on the члены.
             */
            if (needGagging)
                oldGaggedErrors = глоб2.startGagging();

            for (т_мера i = 0; i < tempinst.члены.dim; i++)
            {
                ДСимвол s = (*tempinst.члены)[i];
                s.semantic3(sc);
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
    }

    override проц посети(TemplateMixin tmix)
    {
        if (tmix.semanticRun >= PASS.semantic3)
            return;
        tmix.semanticRun = PASS.semantic3;
        static if (LOG)
        {
            printf("TemplateMixin.semantic3('%s')\n", tmix.вТкст0());
        }
        if (tmix.члены)
        {
            sc = sc.сунь(tmix.argsym);
            sc = sc.сунь(tmix);
            for (т_мера i = 0; i < tmix.члены.dim; i++)
            {
                ДСимвол s = (*tmix.члены)[i];
                s.semantic3(sc);
            }
            sc = sc.вынь();
            sc.вынь();
        }
    }

    override проц посети(Module mod)
    {
        //printf("Module::semantic3('%s'): родитель = %p\n", вТкст0(), родитель);
        if (mod.semanticRun != PASS.semantic2done)
            return;
        mod.semanticRun = PASS.semantic3;
        // Note that modules get their own scope, from scratch.
        // This is so regardless of where in the syntax a module
        // gets imported, it is unaffected by context.
        Scope* sc = Scope.createGlobal(mod); // создай root scope
        //printf("Module = %p\n", sc.scopesym);
        // Pass 3 semantic routines: do initializers and function bodies
        for (т_мера i = 0; i < mod.члены.dim; i++)
        {
            ДСимвол s = (*mod.члены)[i];
            //printf("Module %s: %s.semantic3()\n", вТкст0(), s.вТкст0());
            s.semantic3(sc);

            mod.runDeferredSemantic2();
        }
        if (mod.userAttribDecl)
        {
            mod.userAttribDecl.semantic3(sc);
        }
        sc = sc.вынь();
        sc.вынь();
        mod.semanticRun = PASS.semantic3done;
    }

    override проц посети(FuncDeclaration funcdecl)
    {
        /* Determine if function should add `return 0;`
         */
        бул addReturn0()
        {
            TypeFunction f = cast(TypeFunction)funcdecl.тип;

            return f.следщ.ty == Tvoid &&
                (funcdecl.isMain() || глоб2.парамы.betterC && funcdecl.isCMain());
        }

        VarDeclaration _arguments = null;

        if (!funcdecl.родитель)
        {
            if (глоб2.errors)
                return;
            //printf("FuncDeclaration::semantic3(%s '%s', sc = %p)\n", вид(), вТкст0(), sc);
            assert(0);
        }
        if (funcdecl.errors || isError(funcdecl.родитель))
        {
            funcdecl.errors = да;
            return;
        }
        //printf("FuncDeclaration::semantic3('%s.%s', %p, sc = %p, место = %s)\n", funcdecl.родитель.вТкст0(), funcdecl.вТкст0(), funcdecl, sc, funcdecl.место.вТкст0());
        //fflush(stdout);
        //printf("storage class = x%x %x\n", sc.stc, класс_хранения);
        //{ static цел x; if (++x == 2) *(сим*)0=0; }
        //printf("\tlinkage = %d\n", sc.компонаж);

        if (funcdecl.идент == Id.assign && !funcdecl.inuse)
        {
            if (funcdecl.класс_хранения & STC.inference)
            {
                /* https://issues.dlang.org/show_bug.cgi?ид=15044
                 * For generated opAssign function, any errors
                 * from its body need to be gagged.
                 */
                бцел oldErrors = глоб2.startGagging();
                ++funcdecl.inuse;
                funcdecl.semantic3(sc);
                --funcdecl.inuse;
                if (глоб2.endGagging(oldErrors))   // if errors happened
                {
                    // Disable generated opAssign, because some члены forbid identity assignment.
                    funcdecl.класс_хранения |= STC.disable;
                    funcdecl.fbody = null;   // удали fbody which содержит the error
                    funcdecl.semantic3Errors = нет;
                }
                return;
            }
        }

        //printf(" sc.incontract = %d\n", (sc.flags & SCOPE.contract));
        if (funcdecl.semanticRun >= PASS.semantic3)
            return;
        funcdecl.semanticRun = PASS.semantic3;
        funcdecl.semantic3Errors = нет;

        if (!funcdecl.тип || funcdecl.тип.ty != Tfunction)
            return;
        TypeFunction f = cast(TypeFunction)funcdecl.тип;
        if (!funcdecl.inferRetType && f.следщ.ty == Terror)
            return;

        if (!funcdecl.fbody && funcdecl.inferRetType && !f.следщ)
        {
            funcdecl.выведиОшибку("has no function body with return тип inference");
            return;
        }

        бцел oldErrors = глоб2.errors;
        auto fds = FuncDeclSem3(funcdecl,sc);

        fds.checkInContractOverrides();

        // Remember whether we need to generate an 'out' contract.
        const бул needEnsure = FuncDeclaration.needsFensure(funcdecl);

        if (funcdecl.fbody || funcdecl.frequires || needEnsure)
        {
            /* Symbol table into which we place parameters and nested functions,
             * solely to diagnose имя collisions.
             */
            funcdecl.localsymtab = new DsymbolTable();

            // Establish function scope
            auto ss = new ScopeDsymbol(funcdecl.место, null);
            // найди enclosing scope symbol, might skip symbol-less CTFE and/or FuncExp scopes
            for (auto scx = sc; ; scx = scx.enclosing)
            {
                if (scx.scopesym)
                {
                    ss.родитель = scx.scopesym;
                    break;
                }
            }
            ss.endlinnum = funcdecl.endloc.номстр;
            Scope* sc2 = sc.сунь(ss);
            sc2.func = funcdecl;
            sc2.родитель = funcdecl;
            sc2.ctorflow.callSuper = CSX.none;
            sc2.sbreak = null;
            sc2.scontinue = null;
            sc2.sw = null;
            sc2.fes = funcdecl.fes;
            sc2.компонаж = LINK.d;
            sc2.stc &= STCFlowThruFunction;
            sc2.защита = Prot(Prot.Kind.public_);
            sc2.explicitProtection = 0;
            sc2.aligndecl = null;
            if (funcdecl.идент != Id.require && funcdecl.идент != Id.ensure)
                sc2.flags = sc.flags & ~SCOPE.contract;
            sc2.flags &= ~SCOPE.compile;
            sc2.tf = null;
            sc2.ос = null;
            sc2.inLoop = нет;
            sc2.userAttribDecl = null;
            if (sc2.intypeof == 1)
                sc2.intypeof = 2;
            sc2.ctorflow.fieldinit = null;

            /* Note: When a lambda is defined immediately under aggregate member
             * scope, it should be contextless due to prevent interior pointers.
             * e.g.
             *      // dg points 'this' - it's interior pointer
             *      class C { цел x; проц delegate() dg = (){ this.x = 1; }; }
             *
             * However, lambdas could be используется inside typeof, in order to check
             * some Выражения validity at compile time. For such case the lambda
             * body can access aggregate instance члены.
             * e.g.
             *      class C { цел x; static assert(is(typeof({ this.x = 1; }))); }
             *
             * To properly прими it, mark these lambdas as member functions.
             */
            if (auto fld = funcdecl.isFuncLiteralDeclaration())
            {
                if (auto ad = funcdecl.isMember2())
                {
                    if (!sc.intypeof)
                    {
                        if (fld.tok == ТОК2.delegate_)
                            funcdecl.выведиОшибку("cannot be %s члены", ad.вид());
                        else
                            fld.tok = ТОК2.function_;
                    }
                    else
                    {
                        if (fld.tok != ТОК2.function_)
                            fld.tok = ТОК2.delegate_;
                    }
                }
            }

            // Declare 'this'
            auto ad = funcdecl.isThis();
            auto hiddenParams = funcdecl.declareThis(sc2, ad);
            funcdecl.vthis = hiddenParams.vthis;
            funcdecl.isThis2 = hiddenParams.isThis2;
            funcdecl.selectorParameter = hiddenParams.selectorParameter;
            //printf("[%s] ad = %p vthis = %p\n", место.вТкст0(), ad, vthis);
            //if (vthis) printf("\tvthis.тип = %s\n", vthis.тип.вТкст0());

            // Declare hidden variable _arguments[] and _argptr
            if (f.parameterList.varargs == ВарАрг.variadic)
            {
                if (f.компонаж == LINK.d)
                {
                    // Variadic arguments depend on Typeinfo being defined.
                    if (!глоб2.парамы.useTypeInfo || !Тип.dtypeinfo || !Тип.typeinfotypelist)
                    {
                        if (!глоб2.парамы.useTypeInfo)
                            funcdecl.выведиОшибку("D-style variadic functions cannot be используется with -betterC");
                        else if (!Тип.typeinfotypelist)
                            funcdecl.выведиОшибку("`объект.TypeInfo_Tuple` could not be found, but is implicitly используется in D-style variadic functions");
                        else
                            funcdecl.выведиОшибку("`объект.TypeInfo` could not be found, but is implicitly используется in D-style variadic functions");
                        fatal();
                    }

                    // Declare _arguments[]
                    funcdecl.v_arguments = new VarDeclaration(funcdecl.место, Тип.typeinfotypelist.тип, Id._arguments_typeinfo, null);
                    funcdecl.v_arguments.класс_хранения |= STC.temp | STC.параметр;
                    funcdecl.v_arguments.dsymbolSemantic(sc2);
                    sc2.вставь(funcdecl.v_arguments);
                    funcdecl.v_arguments.родитель = funcdecl;

                    //Тип t = Тип.dtypeinfo.тип.constOf().arrayOf();
                    Тип t = Тип.dtypeinfo.тип.arrayOf();
                    _arguments = new VarDeclaration(funcdecl.место, t, Id._arguments, null);
                    _arguments.класс_хранения |= STC.temp;
                    _arguments.dsymbolSemantic(sc2);
                    sc2.вставь(_arguments);
                    _arguments.родитель = funcdecl;
                }
                if (f.компонаж == LINK.d || f.parameterList.length)
                {
                    // Declare _argptr
                    Тип t = Тип.tvalist;
                    // Init is handled in FuncDeclaration_toObjFile
                    funcdecl.v_argptr = new VarDeclaration(funcdecl.место, t, Id._argptr, new VoidInitializer(funcdecl.место));
                    funcdecl.v_argptr.класс_хранения |= STC.temp;
                    funcdecl.v_argptr.dsymbolSemantic(sc2);
                    sc2.вставь(funcdecl.v_argptr);
                    funcdecl.v_argptr.родитель = funcdecl;
                }
            }

            /* Declare all the function parameters as variables
             * and install them in parameters[]
             */
            т_мера nparams = f.parameterList.length;
            if (nparams)
            {
                /* parameters[] has all the tuples removed, as the back end
                 * doesn't know about tuples
                 */
                funcdecl.parameters = new VarDeclarations();
                funcdecl.parameters.резервируй(nparams);
                for (т_мера i = 0; i < nparams; i++)
                {
                    Параметр2 fparam = f.parameterList[i];
                    Идентификатор2 ид = fparam.идент;
                    КлассХранения stc = 0;
                    if (!ид)
                    {
                        /* Generate идентификатор for un-named параметр,
                         * because we need it later on.
                         */
                        fparam.идент = ид = Идентификатор2.генерируйИд("_param_", i);
                        stc |= STC.temp;
                    }
                    Тип vtype = fparam.тип;
                    auto v = new VarDeclaration(funcdecl.место, vtype, ид, null);
                    //printf("declaring параметр %s of тип %s\n", v.вТкст0(), v.тип.вТкст0());
                    stc |= STC.параметр;
                    if (f.parameterList.varargs == ВарАрг.typesafe && i + 1 == nparams)
                    {
                        stc |= STC.variadic;
                        auto vtypeb = vtype.toBasetype();
                        if (vtypeb.ty == Tarray)
                        {
                            /* Since it'll be pointing into the stack for the массив
                             * contents, it needs to be `scope`
                             */
                            stc |= STC.scope_;
                        }
                    }

                    if ((funcdecl.flags & FUNCFLAG.inferScope) && !(fparam.классХранения & STC.scope_))
                        stc |= STC.maybescope;

                    stc |= fparam.классХранения & (STC.in_ | STC.out_ | STC.ref_ | STC.return_ | STC.scope_ | STC.lazy_ | STC.final_ | STC.TYPECTOR | STC.nodtor);
                    v.класс_хранения = stc;
                    v.dsymbolSemantic(sc2);
                    if (!sc2.вставь(v))
                    {
                        funcdecl.выведиОшибку("параметр `%s.%s` is already defined", funcdecl.вТкст0(), v.вТкст0());
                        funcdecl.errors = да;
                    }
                    else
                        funcdecl.parameters.сунь(v);
                    funcdecl.localsymtab.вставь(v);
                    v.родитель = funcdecl;
                    if (fparam.userAttribDecl)
                        v.userAttribDecl = fparam.userAttribDecl;
                }
            }

            // Declare the кортеж symbols and put them in the symbol table,
            // but not in parameters[].
            if (f.parameterList.parameters)
            {
                for (т_мера i = 0; i < f.parameterList.parameters.dim; i++)
                {
                    Параметр2 fparam = (*f.parameterList.parameters)[i];
                    if (!fparam.идент)
                        continue; // never используется, so ignore
                    if (fparam.тип.ty == Ttuple)
                    {
                        КортежТипов t = cast(КортежТипов)fparam.тип;
                        т_мера dim = Параметр2.dim(t.arguments);
                        auto exps = new Объекты(dim);
                        for (т_мера j = 0; j < dim; j++)
                        {
                            Параметр2 narg = Параметр2.getNth(t.arguments, j);
                            assert(narg.идент);
                            VarDeclaration v = sc2.search(Место.initial, narg.идент, null).isVarDeclaration();
                            assert(v);
                            Выражение e = new VarExp(v.место, v);
                            (*exps)[j] = e;
                        }
                        assert(fparam.идент);
                        auto v = new TupleDeclaration(funcdecl.место, fparam.идент, exps);
                        //printf("declaring кортеж %s\n", v.вТкст0());
                        v.isexp = да;
                        if (!sc2.вставь(v))
                            funcdecl.выведиОшибку("параметр `%s.%s` is already defined", funcdecl.вТкст0(), v.вТкст0());
                        funcdecl.localsymtab.вставь(v);
                        v.родитель = funcdecl;
                    }
                }
            }

            // Precondition invariant
            Инструкция2 fpreinv = null;
            if (funcdecl.addPreInvariant())
            {
                Выражение e = addInvariant(funcdecl.место, sc, ad, funcdecl.vthis);
                if (e)
                    fpreinv = new ExpStatement(Место.initial, e);
            }

            // Postcondition invariant
            Инструкция2 fpostinv = null;
            if (funcdecl.addPostInvariant())
            {
                Выражение e = addInvariant(funcdecl.место, sc, ad, funcdecl.vthis);
                if (e)
                    fpostinv = new ExpStatement(Место.initial, e);
            }

            // Pre/Postcondition contract
            if (!funcdecl.fbody)
                funcdecl.buildEnsureRequire();

            Scope* scout = null;
            if (needEnsure || funcdecl.addPostInvariant())
            {
                /* https://issues.dlang.org/show_bug.cgi?ид=3657
                 * Set the correct end line number for fensure scope.
                 */
                бцел fensure_endlin = funcdecl.endloc.номстр;
                if (funcdecl.fensure)
                    if (auto s = funcdecl.fensure.isScopeStatement())
                        fensure_endlin = s.endloc.номстр;

                if ((needEnsure && глоб2.парамы.useOut == CHECKENABLE.on) || fpostinv)
                {
                    funcdecl.returnLabel = funcdecl.searchLabel(Id.returnLabel);
                }

                // scope of out contract (need for vрезультат.semantic)
                auto sym = new ScopeDsymbol(funcdecl.место, null);
                sym.родитель = sc2.scopesym;
                sym.endlinnum = fensure_endlin;
                scout = sc2.сунь(sym);
            }

            if (funcdecl.fbody)
            {
                auto sym = new ScopeDsymbol(funcdecl.место, null);
                sym.родитель = sc2.scopesym;
                sym.endlinnum = funcdecl.endloc.номстр;
                sc2 = sc2.сунь(sym);

                auto ad2 = funcdecl.isMemberLocal();

                /* If this is a class constructor
                 */
                if (ad2 && funcdecl.isCtorDeclaration())
                {
                    sc2.ctorflow.allocFieldinit(ad2.fields.dim);
                    foreach (v; ad2.fields)
                    {
                        v.ctorinit = 0;
                    }
                }

                if (!funcdecl.inferRetType && !target.isReturnOnStack(f, funcdecl.needThis()))
                    funcdecl.nrvo_can = 0;

                бул inferRef = (f.isref && (funcdecl.класс_хранения & STC.auto_));

                funcdecl.fbody = funcdecl.fbody.statementSemantic(sc2);
                if (!funcdecl.fbody)
                    funcdecl.fbody = new CompoundStatement(Место.initial, new Инструкции());

                if (funcdecl.naked)
                {
                    fpreinv = null;         // can't accommodate with no stack frame
                    fpostinv = null;
                }

                assert(funcdecl.тип == f || (funcdecl.тип.ty == Tfunction && f.purity == PURE.impure && (cast(TypeFunction)funcdecl.тип).purity >= PURE.fwdref));
                f = cast(TypeFunction)funcdecl.тип;

                if (funcdecl.inferRetType)
                {
                    // If no return тип inferred yet, then infer a проц
                    if (!f.следщ)
                        f.следщ = Тип.tvoid;
                    if (f.checkRetType(funcdecl.место))
                        funcdecl.fbody = new ErrorStatement();
                }
                if (глоб2.парамы.vcomplex && f.следщ !is null)
                    f.следщ.checkComplexTransition(funcdecl.место, sc);

                if (funcdecl.returns && !funcdecl.fbody.isErrorStatement())
                {
                    for (т_мера i = 0; i < funcdecl.returns.dim;)
                    {
                        Выражение exp = (*funcdecl.returns)[i].exp;
                        if (exp.op == ТОК2.variable && (cast(VarExp)exp).var == funcdecl.vрезультат)
                        {
                            if (addReturn0())
                                exp.тип = Тип.tint32;
                            else
                                exp.тип = f.следщ;
                            // Remove `return vрезультат;` from returns
                            funcdecl.returns.удали(i);
                            continue;
                        }
                        if (inferRef && f.isref && !exp.тип.constConv(f.следщ)) // https://issues.dlang.org/show_bug.cgi?ид=13336
                            f.isref = нет;
                        i++;
                    }
                }
                if (f.isref) // Function returns a reference
                {
                    if (funcdecl.класс_хранения & STC.auto_)
                        funcdecl.класс_хранения &= ~STC.auto_;
                }

                // handle NRVO
                if (!target.isReturnOnStack(f, funcdecl.needThis()) || funcdecl.checkNrvo())
                    funcdecl.nrvo_can = 0;

                if (funcdecl.fbody.isErrorStatement())
                {
                }
                else if (funcdecl.isStaticCtorDeclaration())
                {
                    /* It's a static constructor. Гарант that all
                     * ctor consts were initialized.
                     */
                    ScopeDsymbol pd = funcdecl.toParent().isScopeDsymbol();
                    for (т_мера i = 0; i < pd.члены.dim; i++)
                    {
                        ДСимвол s = (*pd.члены)[i];
                        s.checkCtorConstInit();
                    }
                }
                else if (ad2 && funcdecl.isCtorDeclaration())
                {
                    ClassDeclaration cd = ad2.isClassDeclaration();

                    // Verify that all the ctorinit fields got initialized
                    if (!(sc2.ctorflow.callSuper & CSX.this_ctor))
                    {
                        foreach (i, v; ad2.fields)
                        {
                            if (v.isThisDeclaration())
                                continue;
                            if (v.ctorinit == 0)
                            {
                                /* Current bugs in the flow analysis:
                                 * 1. union члены should not produce error messages even if
                                 *    not assigned to
                                 * 2. structs should recognize delegating opAssign calls as well
                                 *    as delegating calls to other constructors
                                 */
                                if (v.isCtorinit() && !v.тип.isMutable() && cd)
                                    funcdecl.выведиОшибку("missing инициализатор for %s field `%s`", MODtoChars(v.тип.mod), v.вТкст0());
                                else if (v.класс_хранения & STC.nodefaultctor)
                                    выведиОшибку(funcdecl.место, "field `%s` must be initialized in constructor", v.вТкст0());
                                else if (v.тип.needsNested())
                                    выведиОшибку(funcdecl.место, "field `%s` must be initialized in constructor, because it is nested struct", v.вТкст0());
                            }
                            else
                            {
                                бул mustInit = (v.класс_хранения & STC.nodefaultctor || v.тип.needsNested());
                                if (mustInit && !(sc2.ctorflow.fieldinit[i].csx & CSX.this_ctor))
                                {
                                    funcdecl.выведиОшибку("field `%s` must be initialized but skipped", v.вТкст0());
                                }
                            }
                        }
                    }
                    sc2.ctorflow.freeFieldinit();

                    if (cd && !(sc2.ctorflow.callSuper & CSX.any_ctor) && cd.baseClass && cd.baseClass.ctor)
                    {
                        sc2.ctorflow.callSuper = CSX.none;

                        // Insert implicit super() at start of fbody
                        Тип tthis = ad2.тип.addMod(funcdecl.vthis.тип.mod);
                        FuncDeclaration fd = resolveFuncCall(Место.initial, sc2, cd.baseClass.ctor, null, tthis, null, FuncResolveFlag.quiet);
                        if (!fd)
                        {
                            funcdecl.выведиОшибку("no match for implicit `super()` call in constructor");
                        }
                        else if (fd.класс_хранения & STC.disable)
                        {
                            funcdecl.выведиОшибку("cannot call `super()` implicitly because it is annotated with `@disable`");
                        }
                        else
                        {
                            Выражение e1 = new SuperExp(Место.initial);
                            Выражение e = new CallExp(Место.initial, e1);
                            e = e.ВыражениеSemantic(sc2);
                            Инструкция2 s = new ExpStatement(Место.initial, e);
                            funcdecl.fbody = new CompoundStatement(Место.initial, s, funcdecl.fbody);
                        }
                    }
                    //printf("ctorflow.callSuper = x%x\n", sc2.ctorflow.callSuper);
                }

                /* https://issues.dlang.org/show_bug.cgi?ид=17502
                 * Wait until after the return тип has been inferred before
                 * generating the contracts for this function, and merging contracts
                 * from overrides.
                 *
                 * https://issues.dlang.org/show_bug.cgi?ид=17893
                 * However should take care to generate this before inferered
                 * function attributes are applied, such as ''.
                 *
                 * This was originally at the end of the first semantic pass, but
                 * required a fix-up to be done here for the '__результат' variable
                 * тип of __ensure() inside auto functions, but this didn't work
                 * if the out параметр was implicit.
                 */
                funcdecl.buildEnsureRequire();

                // Check for errors related to ''.
                const blockexit = funcdecl.fbody.blockExit(funcdecl, f.isnothrow);
                if (f.isnothrow && blockexit & BE.throw_)
                    выведиОшибку(funcdecl.место, "`` %s `%s` may throw", funcdecl.вид(), funcdecl.toPrettyChars());

                if (!(blockexit & (BE.throw_ | BE.halt) || funcdecl.flags & FUNCFLAG.hasCatches))
                {
                    /* Disable optimization on Win32 due to
                     * https://issues.dlang.org/show_bug.cgi?ид=17997
                     */
//                    if (!глоб2.парамы.isWindows || глоб2.парамы.is64bit)
                        funcdecl.eh_none = да;         // don't generate unwind tables for this function
                }

                if (funcdecl.flags & FUNCFLAG.nothrowInprocess)
                {
                    if (funcdecl.тип == f)
                        f = cast(TypeFunction)f.копируй();
                    f.isnothrow = !(blockexit & BE.throw_);
                }

                if (funcdecl.fbody.isErrorStatement())
                {
                }
                else if (ad2 && funcdecl.isCtorDeclaration())
                {
                    /* Append:
                     *  return this;
                     * to function body
                     */
                    if (blockexit & BE.fallthru)
                    {
                        Инструкция2 s = new ReturnStatement(funcdecl.место, null);
                        s = s.statementSemantic(sc2);
                        funcdecl.fbody = new CompoundStatement(funcdecl.место, funcdecl.fbody, s);
                        funcdecl.hasReturnExp |= (funcdecl.hasReturnExp & 1 ? 16 : 1);
                    }
                }
                else if (funcdecl.fes)
                {
                    // For foreach(){} body, приставь a return 0;
                    if (blockexit & BE.fallthru)
                    {
                        Выражение e = IntegerExp.literal!(0);
                        Инструкция2 s = new ReturnStatement(Место.initial, e);
                        funcdecl.fbody = new CompoundStatement(Место.initial, funcdecl.fbody, s);
                        funcdecl.hasReturnExp |= (funcdecl.hasReturnExp & 1 ? 16 : 1);
                    }
                    assert(!funcdecl.returnLabel);
                }
                else
                {
                    const бул inlineAsm = (funcdecl.hasReturnExp & 8) != 0;
                    if ((blockexit & BE.fallthru) && f.следщ.ty != Tvoid && !inlineAsm)
                    {
                        Выражение e;
                        if (!funcdecl.hasReturnExp)
                            funcdecl.выведиОшибку("has no `return` инструкция, but is expected to return a значение of тип `%s`", f.следщ.вТкст0());
                        else
                            funcdecl.выведиОшибку("no `return exp;` or `assert(0);` at end of function");
                        if (глоб2.парамы.useAssert == CHECKENABLE.on && !глоб2.парамы.useInline)
                        {
                            /* Add an assert(0, msg); where the missing return
                             * should be.
                             */
                            e = new AssertExp(funcdecl.endloc, IntegerExp.literal!(0), new StringExp(funcdecl.место, "missing return Выражение"));
                        }
                        else
                            e = new HaltExp(funcdecl.endloc);
                        e = new CommaExp(Место.initial, e, f.следщ.defaultInit(Место.initial));
                        e = e.ВыражениеSemantic(sc2);
                        Инструкция2 s = new ExpStatement(Место.initial, e);
                        funcdecl.fbody = new CompoundStatement(Место.initial, funcdecl.fbody, s);
                    }
                }

                if (funcdecl.returns)
                {
                    бул implicit0 = addReturn0();
                    Тип tret = implicit0 ? Тип.tint32 : f.следщ;
                    assert(tret.ty != Tvoid);
                    if (funcdecl.vрезультат || funcdecl.returnLabel)
                        funcdecl.buildрезультатVar(scout ? scout : sc2, tret);

                    /* Cannot move this loop into NrvoWalker, because
                     * returns[i] may be in the nested delegate for foreach-body.
                     */
                    for (т_мера i = 0; i < funcdecl.returns.dim; i++)
                    {
                        ReturnStatement rs = (*funcdecl.returns)[i];
                        Выражение exp = rs.exp;
                        if (exp.op == ТОК2.error)
                            continue;
                        if (tret.ty == Terror)
                        {
                            // https://issues.dlang.org/show_bug.cgi?ид=13702
                            exp = checkGC(sc2, exp);
                            continue;
                        }

                        /* If the Выражение in the return инструкция (exp) cannot be implicitly
                         * converted to the return тип (tret) of the function and if the
                         * тип of the Выражение is тип isolated, then it may be possible
                         * that a promotion to `const` or `inout` (through a cast) will
                         * match the return тип.
                         */
                        if (!exp.implicitConvTo(tret) && funcdecl.isTypeIsolated(exp.тип))
                        {
                            /* https://issues.dlang.org/show_bug.cgi?ид=20073
                             *
                             * The problem is that if the тип of the returned Выражение (exp.тип)
                             * is an aggregated declaration with an alias this, the alias this may be
                             * используется for the conversion testing without it being an isolated тип.
                             *
                             * To make sure this does not happen, we can test here the implicit conversion
                             * only for the aggregated declaration тип by using `implicitConvToWithoutAliasThis`.
                             * The implicit conversion with alias this is taken care of later.
                             */
                            AggregateDeclaration aggDecl = isAggregate(exp.тип);
                            TypeStruct tstruct;
                            TypeClass tclass;
                            бул hasAliasThis;
                            if (aggDecl && aggDecl.aliasthis)
                            {
                                hasAliasThis = да;
                                tclass = exp.тип.isTypeClass();
                                if (!tclass)
                                    tstruct = exp.тип.isTypeStruct();
                                assert(tclass || tstruct);
                            }
                            if (hasAliasThis)
                            {
                                if (tclass)
                                {
                                    if ((cast(TypeClass)(exp.тип.immutableOf())).implicitConvToWithoutAliasThis(tret))
                                        exp = exp.castTo(sc2, exp.тип.immutableOf());
                                    else if ((cast(TypeClass)(exp.тип.wildOf())).implicitConvToWithoutAliasThis(tret))
                                        exp = exp.castTo(sc2, exp.тип.wildOf());
                                }
                                else
                                {
                                    if ((cast(TypeStruct)exp.тип.immutableOf()).implicitConvToWithoutAliasThis(tret))
                                        exp = exp.castTo(sc2, exp.тип.immutableOf());
                                    else if ((cast(TypeStruct)exp.тип.immutableOf()).implicitConvToWithoutAliasThis(tret))
                                        exp = exp.castTo(sc2, exp.тип.wildOf());
                                }
                            }
                            else
                            {
                                if (exp.тип.immutableOf().implicitConvTo(tret))
                                    exp = exp.castTo(sc2, exp.тип.immutableOf());
                                else if (exp.тип.wildOf().implicitConvTo(tret))
                                    exp = exp.castTo(sc2, exp.тип.wildOf());
                            }
                        }

                        const hasCopyCtor = exp.тип.ty == Tstruct && (cast(TypeStruct)exp.тип).sym.hasCopyCtor;
                        // if a копируй constructor is present, the return тип conversion will be handled by it
                        if (!(hasCopyCtor && exp.isLvalue()))
                            exp = exp.implicitCastTo(sc2, tret);

                        if (f.isref)
                        {
                            // Function returns a reference
                            exp = exp.toLvalue(sc2, exp);
                            checkReturnEscapeRef(sc2, exp, нет);
                        }
                        else
                        {
                            exp = exp.optimize(WANTvalue);

                            /* https://issues.dlang.org/show_bug.cgi?ид=10789
                             * If NRVO is not possible, all returned lvalues should call their postblits.
                             */
                            if (!funcdecl.nrvo_can)
                                exp = doCopyOrMove(sc2, exp, f.следщ);

                            if (tret.hasPointers())
                                checkReturnEscape(sc2, exp, нет);
                        }

                        exp = checkGC(sc2, exp);

                        if (funcdecl.vрезультат)
                        {
                            // Create: return vрезультат = exp;
                            exp = new BlitExp(rs.место, funcdecl.vрезультат, exp);
                            exp.тип = funcdecl.vрезультат.тип;

                            if (rs.caseDim)
                                exp = Выражение.combine(exp, new IntegerExp(rs.caseDim));
                        }
                        else if (funcdecl.tintro && !tret.равен(funcdecl.tintro.nextOf()))
                        {
                            exp = exp.implicitCastTo(sc2, funcdecl.tintro.nextOf());
                        }
                        rs.exp = exp;
                    }
                }
                if (funcdecl.nrvo_var || funcdecl.returnLabel)
                {
                    scope NrvoWalker nw = new NrvoWalker();
                    nw.fd = funcdecl;
                    nw.sc = sc2;
                    nw.visitStmt(funcdecl.fbody);
                }

                sc2 = sc2.вынь();
            }

            funcdecl.frequire = funcdecl.mergeFrequire(funcdecl.frequire, funcdecl.fdrequireParams);
            funcdecl.fensure = funcdecl.mergeFensure(funcdecl.fensure, Id.результат, funcdecl.fdensureParams);

            Инструкция2 freq = funcdecl.frequire;
            Инструкция2 fens = funcdecl.fensure;

            /* Do the semantic analysis on the [in] preconditions and
             * [out] postconditions.
             */
            if (freq)
            {
                /* frequire is composed of the [in] contracts
                 */
                auto sym = new ScopeDsymbol(funcdecl.место, null);
                sym.родитель = sc2.scopesym;
                sym.endlinnum = funcdecl.endloc.номстр;
                sc2 = sc2.сунь(sym);
                sc2.flags = (sc2.flags & ~SCOPE.contract) | SCOPE.require;

                // BUG: need to error if accessing out parameters
                // BUG: need to disallow returns and throws
                // BUG: verify that all in and ref parameters are читай
                freq = freq.statementSemantic(sc2);
                freq.blockExit(funcdecl, нет);

                funcdecl.eh_none = нет;

                sc2 = sc2.вынь();

                if (глоб2.парамы.useIn == CHECKENABLE.off)
                    freq = null;
            }
            if (fens)
            {
                /* fensure is composed of the [out] contracts
                 */
                if (f.следщ.ty == Tvoid && funcdecl.fensures)
                {
                    foreach (e; *funcdecl.fensures)
                    {
                        if (e.ид)
                        {
                            funcdecl.выведиОшибку(e.ensure.место, "`проц` functions have no результат");
                            //fens = null;
                        }
                    }
                }

                sc2 = scout; //сунь
                sc2.flags = (sc2.flags & ~SCOPE.contract) | SCOPE.ensure;

                // BUG: need to disallow returns and throws

                if (funcdecl.fensure && f.следщ.ty != Tvoid)
                    funcdecl.buildрезультатVar(scout, f.следщ);

                fens = fens.statementSemantic(sc2);
                fens.blockExit(funcdecl, нет);

                funcdecl.eh_none = нет;

                sc2 = sc2.вынь();

                if (глоб2.парамы.useOut == CHECKENABLE.off)
                    fens = null;
            }
            if (funcdecl.fbody && funcdecl.fbody.isErrorStatement())
            {
            }
            else
            {
                auto a = new Инструкции();
                // Merge in initialization of 'out' parameters
                if (funcdecl.parameters)
                {
                    for (т_мера i = 0; i < funcdecl.parameters.dim; i++)
                    {
                        VarDeclaration v = (*funcdecl.parameters)[i];
                        if (v.класс_хранения & STC.out_)
                        {
                            if (!v._иниц)
                            {
                                v.выведиОшибку("Zero-length `out` parameters are not allowed.");
                                return;
                            }
                            ExpInitializer ie = v._иниц.isExpInitializer();
                            assert(ie);
                            if (auto iec = ie.exp.isConstructExp())
                            {
                                // construction occurred in параметр processing
                                auto ec = new AssignExp(iec.место, iec.e1, iec.e2);
                                ec.тип = iec.тип;
                                ie.exp = ec;
                            }
                            a.сунь(new ExpStatement(Место.initial, ie.exp));
                        }
                    }
                }

                if (_arguments)
                {
                    /* Advance to elements[] member of TypeInfo_Tuple with:
                     *  _arguments = v_arguments.elements;
                     */
                    Выражение e = new VarExp(Место.initial, funcdecl.v_arguments);
                    e = new DotIdExp(Место.initial, e, Id.elements);
                    e = new ConstructExp(Место.initial, _arguments, e);
                    e = e.ВыражениеSemantic(sc2);

                    _arguments._иниц = new ExpInitializer(Место.initial, e);
                    auto de = new DeclarationExp(Место.initial, _arguments);
                    a.сунь(new ExpStatement(Место.initial, de));
                }

                // Merge contracts together with body into one compound инструкция

                if (freq || fpreinv)
                {
                    if (!freq)
                        freq = fpreinv;
                    else if (fpreinv)
                        freq = new CompoundStatement(Место.initial, freq, fpreinv);

                    a.сунь(freq);
                }

                if (funcdecl.fbody)
                    a.сунь(funcdecl.fbody);

                if (fens || fpostinv)
                {
                    if (!fens)
                        fens = fpostinv;
                    else if (fpostinv)
                        fens = new CompoundStatement(Место.initial, fpostinv, fens);

                    auto ls = new LabelStatement(Место.initial, Id.returnLabel, fens);
                    funcdecl.returnLabel.инструкция = ls;
                    a.сунь(funcdecl.returnLabel.инструкция);

                    if (f.следщ.ty != Tvoid && funcdecl.vрезультат)
                    {
                        // Create: return vрезультат;
                        Выражение e = new VarExp(Место.initial, funcdecl.vрезультат);
                        if (funcdecl.tintro)
                        {
                            e = e.implicitCastTo(sc, funcdecl.tintro.nextOf());
                            e = e.ВыражениеSemantic(sc);
                        }
                        auto s = new ReturnStatement(Место.initial, e);
                        a.сунь(s);
                    }
                }
                if (addReturn0())
                {
                    // Add a return 0; инструкция
                    Инструкция2 s = new ReturnStatement(Место.initial, IntegerExp.literal!(0));
                    a.сунь(s);
                }

                Инструкция2 sbody = new CompoundStatement(Место.initial, a);

                /* Append destructor calls for parameters as finally blocks.
                 */
                if (funcdecl.parameters)
                {
                    foreach (v; *funcdecl.parameters)
                    {
                        if (v.класс_хранения & (STC.ref_ | STC.out_ | STC.lazy_))
                            continue;
                        if (v.needsScopeDtor())
                        {
                            // same with ExpStatement.scopeCode()
                            Инструкция2 s = new DtorExpStatement(Место.initial, v.edtor, v);
                            v.класс_хранения |= STC.nodtor;

                            s = s.statementSemantic(sc2);

                            бул isnothrow = f.isnothrow & !(funcdecl.flags & FUNCFLAG.nothrowInprocess);
                            const blockexit = s.blockExit(funcdecl, isnothrow);
                            if (blockexit & BE.throw_)
                                funcdecl.eh_none = нет;
                            if (f.isnothrow && isnothrow && blockexit & BE.throw_)
                                выведиОшибку(funcdecl.место, "`` %s `%s` may throw", funcdecl.вид(), funcdecl.toPrettyChars());
                            if (funcdecl.flags & FUNCFLAG.nothrowInprocess && blockexit & BE.throw_)
                                f.isnothrow = нет;

                            if (sbody.blockExit(funcdecl, f.isnothrow) == BE.fallthru)
                                sbody = new CompoundStatement(Место.initial, sbody, s);
                            else
                                sbody = new TryFinallyStatement(Место.initial, sbody, s);
                        }
                    }
                }
                // from this point on all possible 'throwers' are checked
                funcdecl.flags &= ~FUNCFLAG.nothrowInprocess;

                if (funcdecl.isSynchronized())
                {
                    /* Wrap the entire function body in a synchronized инструкция
                     */
                    ClassDeclaration cd = funcdecl.toParentDecl().isClassDeclaration();
                    if (cd)
                    {
                        if (!глоб2.парамы.is64bit && глоб2.парамы.isWindows && !funcdecl.isStatic() && !sbody.usesEH() && !глоб2.парамы.trace)
                        {
                            /* The back end uses the "jmonitor" hack for syncing;
                             * no need to do the sync at this уровень.
                             */
                        }
                        else
                        {
                            Выражение vsync;
                            if (funcdecl.isStatic())
                            {
                                // The monitor is in the ClassInfo
                                vsync = new DotIdExp(funcdecl.место, symbolToExp(cd, funcdecl.место, sc2, нет), Id.classinfo);
                            }
                            else
                            {
                                // 'this' is the monitor
                                vsync = new VarExp(funcdecl.место, funcdecl.vthis);
                                if (funcdecl.isThis2)
                                {
                                    vsync = new PtrExp(funcdecl.место, vsync);
                                    vsync = new IndexExp(funcdecl.место, vsync, IntegerExp.literal!(0));
                                }
                            }
                            sbody = new PeelStatement(sbody); // don't redo semantic()
                            sbody = new SynchronizedStatement(funcdecl.место, vsync, sbody);
                            sbody = sbody.statementSemantic(sc2);
                        }
                    }
                    else
                    {
                        funcdecl.выведиОшибку("synchronized function `%s` must be a member of a class", funcdecl.вТкст0());
                    }
                }

                // If declaration has no body, don't set sbody to prevent incorrect codegen.
                if (funcdecl.fbody || funcdecl.allowsContractWithoutBody())
                    funcdecl.fbody = sbody;
            }

            // Check for undefined labels
            if (funcdecl.labtab)
                foreach (ключЗначение; funcdecl.labtab.tab.asRange)
                {
                    //printf("  KV: %s = %s\n", ключЗначение.ключ.вТкст0(), ключЗначение.значение.вТкст0());
                    LabelDsymbol label = cast(LabelDsymbol)ключЗначение.значение;
                    if (!label.инструкция && (!label.deleted || label.iasm))
                    {
                        funcdecl.выведиОшибку("label `%s` is undefined", label.вТкст0());
                    }
                }

            // Fix up forward-referenced gotos
            if (funcdecl.gotos)
            {
                for (т_мера i = 0; i < funcdecl.gotos.dim; ++i)
                {
                    (*funcdecl.gotos)[i].checkLabel();
                }
            }

            if (funcdecl.naked && (funcdecl.fensures || funcdecl.frequires))
                funcdecl.выведиОшибку("naked assembly functions with contracts are not supported");

            sc2.ctorflow.callSuper = CSX.none;
            sc2.вынь();
        }

        if (funcdecl.checkClosure())
        {
            // We should be setting errors here instead of relying on the глоб2 error count.
            //errors = да;
        }

        /* If function survived being marked as impure, then it is 
         */
        if (funcdecl.flags & FUNCFLAG.purityInprocess)
        {
            funcdecl.flags &= ~FUNCFLAG.purityInprocess;
            if (funcdecl.тип == f)
                f = cast(TypeFunction)f.копируй();
            f.purity = PURE.fwdref;
        }

        if (funcdecl.flags & FUNCFLAG.safetyInprocess)
        {
            funcdecl.flags &= ~FUNCFLAG.safetyInprocess;
            if (funcdecl.тип == f)
                f = cast(TypeFunction)f.копируй();
            f.trust = TRUST.safe;
        }

        if (funcdecl.flags & FUNCFLAG.nogcInprocess)
        {
            funcdecl.flags &= ~FUNCFLAG.nogcInprocess;
            if (funcdecl.тип == f)
                f = cast(TypeFunction)f.копируй();
            f.isnogc = да;
        }

        if (funcdecl.flags & FUNCFLAG.returnInprocess)
        {
            funcdecl.flags &= ~FUNCFLAG.returnInprocess;
            if (funcdecl.класс_хранения & STC.return_)
            {
                if (funcdecl.тип == f)
                    f = cast(TypeFunction)f.копируй();
                f.isreturn = да;
                if (funcdecl.класс_хранения & STC.returninferred)
                    f.isreturninferred = да;
            }
        }

        funcdecl.flags &= ~FUNCFLAG.inferScope;

        // Eliminate maybescope's
        {
            // Create and fill массив[] with maybe candidates from the `this` and the parameters
            VarDeclaration[] массив = проц;

            VarDeclaration[10] tmp = проц;
            т_мера dim = (funcdecl.vthis !is null) + (funcdecl.parameters ? funcdecl.parameters.dim : 0);
            if (dim <= tmp.length)
                массив = tmp[0 .. dim];
            else
            {
                auto ptr = cast(VarDeclaration*)mem.xmalloc(dim * VarDeclaration.sizeof);
                массив = ptr[0 .. dim];
            }
            т_мера n = 0;
            if (funcdecl.vthis)
                массив[n++] = funcdecl.vthis;
            if (funcdecl.parameters)
            {
                foreach (v; *funcdecl.parameters)
                {
                    массив[n++] = v;
                }
            }

            eliminateMaybeScopes(массив[0 .. n]);

            if (dim > tmp.length)
                mem.xfree(массив.ptr);
        }

        // Infer STC.scope_
        if (funcdecl.parameters && !funcdecl.errors)
        {
            т_мера nfparams = f.parameterList.length;
            assert(nfparams == funcdecl.parameters.dim);
            foreach (u, v; *funcdecl.parameters)
            {
                if (v.класс_хранения & STC.maybescope)
                {
                    //printf("Inferring scope for %s\n", v.вТкст0());
                    Параметр2 p = f.parameterList[u];
                    notMaybeScope(v);
                    v.класс_хранения |= STC.scope_ | STC.scopeinferred;
                    p.классХранения |= STC.scope_ | STC.scopeinferred;
                    assert(!(p.классХранения & STC.maybescope));
                }
            }
        }

        if (funcdecl.vthis && funcdecl.vthis.класс_хранения & STC.maybescope)
        {
            notMaybeScope(funcdecl.vthis);
            funcdecl.vthis.класс_хранения |= STC.scope_ | STC.scopeinferred;
            f.isscope = да;
            f.isscopeinferred = да;
        }

        // сбрось deco to apply inference результат to mangled имя
        if (f != funcdecl.тип)
            f.deco = null;

        // Do semantic тип AFTER / inference.
        if (!f.deco && funcdecl.идент != Id.xopEquals && funcdecl.идент != Id.xopCmp)
        {
            sc = sc.сунь();
            if (funcdecl.isCtorDeclaration()) // https://issues.dlang.org/show_bug.cgi?ид=#15665
                sc.flags |= SCOPE.ctor;
            sc.stc = 0;
            sc.компонаж = funcdecl.компонаж; // https://issues.dlang.org/show_bug.cgi?ид=8496
            funcdecl.тип = f.typeSemantic(funcdecl.место, sc);
            sc = sc.вынь();
        }

        // Do live analysis
        if (funcdecl.fbody && funcdecl.тип.ty != Terror && funcdecl.тип.isTypeFunction().islive)
        {
            oblive(funcdecl);
        }

        /* If this function had instantiated with gagging, error reproduction will be
         * done by TemplateInstance::semantic.
         * Otherwise, error gagging should be temporarily ungagged by functionSemantic3.
         */
        funcdecl.semanticRun = PASS.semantic3done;
        funcdecl.semantic3Errors = (глоб2.errors != oldErrors) || (funcdecl.fbody && funcdecl.fbody.isErrorStatement());
        if (funcdecl.тип.ty == Terror)
            funcdecl.errors = да;
        //printf("-FuncDeclaration::semantic3('%s.%s', sc = %p, место = %s)\n", родитель.вТкст0(), вТкст0(), sc, место.вТкст0());
        //fflush(stdout);
    }

    override проц посети(CtorDeclaration ctor)
    {
        //printf("CtorDeclaration()\n%s\n", ctor.fbody.вТкст0());
        if (ctor.semanticRun >= PASS.semantic3)
            return;

        /* If any of the fields of the aggregate have a destructor, add
         *   scope (failure) { this.fieldDtor(); }
         * as the first инструкция. It is not necessary to add it after
         * each initialization of a field, because destruction of .init constructed
         * structs should be benign.
         * https://issues.dlang.org/show_bug.cgi?ид=14246
         */
        AggregateDeclaration ad = ctor.isMemberDecl();
        if (ad && ad.fieldDtor && глоб2.парамы.dtorFields)
        {
            /* Generate:
             *   this.fieldDtor()
             */
            Выражение e = new ThisExp(ctor.место);
            e.тип = ad.тип.mutableOf();
            e = new DotVarExp(ctor.место, e, ad.fieldDtor, нет);
            e = new CallExp(ctor.место, e);
            auto sexp = new ExpStatement(ctor.место, e);
            auto ss = new ScopeStatement(ctor.место, sexp, ctor.место);

            version (all)
            {
                /* Generate:
                 *   try { ctor.fbody; }
                 *   catch (Exception __o)
                 *   { this.fieldDtor(); throw __o; }
                 * This differs from the alternate scope(failure) version in that an Exception
                 * is caught rather than a Throwable. This enables the optimization whereby
                 * the try-catch can be removed if ctor.fbody is . ( only
                 * applies to Exception.)
                 */
                Идентификатор2 ид = Идентификатор2.генерируйИд("__o");
                auto ts = new ThrowStatement(ctor.место, new IdentifierExp(ctor.место, ид));
                auto handler = new CompoundStatement(ctor.место, ss, ts);

                auto catches = new Уловители();
                auto ctch = new Уловитель(ctor.место, getException(), ид, handler);
                catches.сунь(ctch);

                ctor.fbody = new TryCatchStatement(ctor.место, ctor.fbody, catches);
            }
            else
            {
                /* Generate:
                 *   scope (failure) { this.fieldDtor(); }
                 * Hopefully we can use this version someday when scope(failure) catches
                 * Exception instead of Throwable.
                 */
                auto s = new ScopeGuardStatement(ctor.место, ТОК2.onScopeFailure, ss);
                ctor.fbody = new CompoundStatement(ctor.место, s, ctor.fbody);
            }
        }
        посети(cast(FuncDeclaration)ctor);
    }


    override проц посети(Nspace ns)
    {
        if (ns.semanticRun >= PASS.semantic3)
            return;
        ns.semanticRun = PASS.semantic3;
        static if (LOG)
        {
            printf("Nspace::semantic3('%s')\n", ns.вТкст0());
        }
        if (ns.члены)
        {
            sc = sc.сунь(ns);
            sc.компонаж = LINK.cpp;
            foreach (s; *ns.члены)
            {
                s.semantic3(sc);
            }
            sc.вынь();
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
                s.semantic3(sc2);
            }
            if (sc2 != sc)
                sc2.вынь();
        }
    }

    override проц посети(AggregateDeclaration ad)
    {
        //printf("AggregateDeclaration::semantic3(sc=%p, %s) тип = %s, errors = %d\n", sc, вТкст0(), тип.вТкст0(), errors);
        if (!ad.члены)
            return;

        StructDeclaration sd = ad.isStructDeclaration();
        if (!sc) // from runDeferredSemantic3 for TypeInfo generation
        {
            assert(sd);
            sd.semanticTypeInfoMembers();
            return;
        }

        auto sc2 = ad.newScope(sc);

        for (т_мера i = 0; i < ad.члены.dim; i++)
        {
            ДСимвол s = (*ad.члены)[i];
            s.semantic3(sc2);
        }

        sc2.вынь();

        // don't do it for unused deprecated types
        // or error ypes
        if (!ad.getRTInfo && Тип.rtinfo && (!ad.isDeprecated() || глоб2.парамы.useDeprecated != DiagnosticReporting.error) && (ad.тип && ad.тип.ty != Terror))
        {
            // Evaluate: RTinfo!тип
            auto tiargs = new Объекты();
            tiargs.сунь(ad.тип);
            auto ti = new TemplateInstance(ad.место, Тип.rtinfo, tiargs);

            Scope* sc3 = ti.tempdecl._scope.startCTFE();
            sc3.tinst = sc.tinst;
            sc3.minst = sc.minst;
            if (ad.isDeprecated())
                sc3.stc |= STC.deprecated_;

            ti.dsymbolSemantic(sc3);
            ti.semantic2(sc3);
            ti.semantic3(sc3);
            auto e = symbolToExp(ti.toAlias(), Место.initial, sc3, нет);

            sc3.endCTFE();

            e = e.ctfeInterpret();
            ad.getRTInfo = e;
        }
        if (sd)
            sd.semanticTypeInfoMembers();
        ad.semanticRun = PASS.semantic3done;
    }
}

private struct FuncDeclSem3
{
    // The FuncDeclaration subject to Semantic analysis
    FuncDeclaration funcdecl;

    // Scope of analysis
    Scope* sc;
    this(FuncDeclaration fd,Scope* s)
    {
        funcdecl = fd;
        sc = s;
    }

    /* Checks that the overriden functions (if any) have in contracts if
     * funcdecl has an in contract.
     */
    проц checkInContractOverrides()
    {
        if (funcdecl.frequires)
        {
            for (т_мера i = 0; i < funcdecl.foverrides.dim; i++)
            {
                FuncDeclaration fdv = funcdecl.foverrides[i];
                if (fdv.fbody && !fdv.frequires)
                {
                    funcdecl.выведиОшибку("cannot have an in contract when overridden function `%s` does not have an in contract", fdv.toPrettyChars());
                    break;
                }
            }
        }
    }
}
