/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/dsymbolsem.d, _dsymbolsem.d)
 * Documentation:  https://dlang.org/phobos/dmd_dsymbolsem.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/dsymbolsem.d
 */

module dmd.dsymbolsem;

import cidrus;

import dmd.aggregate;
import dmd.aliasthis;
import dmd.arraytypes;
import drc.ast.AstCodegen;
import dmd.attrib;
import dmd.blockexit;
import dmd.clone;
import dmd.compiler;
import dmd.dcast;
import dmd.dclass;
import dmd.declaration;
import dmd.denum;
import dmd.dimport;
import dmd.dinterpret;
import dmd.dmangle;
import dmd.dmodule;
import dmd.dscope;
import dmd.dstruct;
import dmd.дсимвол;
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
import dmd.objc;
import dmd.opover;
import drc.parser.Parser2;
import util.filename;
import util.outbuffer;
import util.rmem;
import drc.ast.Node;
import dmd.semantic2;
import dmd.semantic3;
import dmd.sideeffect;
import dmd.statementsem;
import dmd.staticassert;
import drc.lexer.Tokens;
import util.utf;
import util.utils;
import dmd.инструкция;
import dmd.target;
import dmd.templateparamsem;
import dmd.typesem;
import drc.ast.Visitor;
import dmd.access : symbolIsVisible;

const LOG = нет;

/*****************************************
 * Create inclusive postblit for struct by aggregating
 * all the postblits in postblits[] with the postblits for
 * all the члены.
 * Note the close similarity with AggregateDeclaration::buildDtor(),
 * and the ordering changes (runs forward instead of backwards).
 */
private FuncDeclaration buildPostBlit(StructDeclaration sd, Scope* sc)
{
    //printf("StructDeclaration::buildPostBlit() %s\n", sd.вТкст0());
    if (sd.isUnionDeclaration())
        return null;

    // by default, the storage class of the created postblit
    КлассХранения stc = STC.safe | STC.nothrow_ | STC.pure_ | STC.nogc;
    Место declLoc = sd.postblits.dim ? sd.postblits[0].место : sd.место;
    Место место; // internal code should have no место to prevent coverage

    // if any of the postblits are disabled, then the generated postblit
    // will be disabled
    for (т_мера i = 0; i < sd.postblits.dim; i++)
    {
        stc |= sd.postblits[i].класс_хранения & STC.disable;
    }

    VarDeclaration[] fieldsToDestroy;
    auto postblitCalls = new Инструкции();
    // iterate through all the struct fields that are not disabled
    for (т_мера i = 0; i < sd.fields.dim && !(stc & STC.disable); i++)
    {
        auto structField = sd.fields[i];
        if (structField.класс_хранения & STC.ref_)
            continue;
        if (structField.overlapped)
            continue;
        // if it's a struct declaration or an массив of structs
        Тип tv = structField.тип.baseElemOf();
        if (tv.ty != Tstruct)
            continue;
        auto sdv = (cast(TypeStruct)tv).sym;
        // which has a postblit declaration
        if (!sdv.postblit)
            continue;
        assert(!sdv.isUnionDeclaration());

        // if this field's postblit is not ``, add a `scope(failure)`
        // block to разрушь any prior successfully postblitted fields should
        // this field's postblit fail
        if (fieldsToDestroy.length > 0 && !(cast(TypeFunction)sdv.postblit.тип).isnothrow)
        {
             // создай a list of destructors that need to be called
            Выражение[] dtorCalls;
            foreach(sf; fieldsToDestroy)
            {
                Выражение ex;
                tv = sf.тип.toBasetype();
                if (tv.ty == Tstruct)
                {
                    // this.v.__xdtor()

                    ex = new ThisExp(место);
                    ex = new DotVarExp(место, ex, sf);

                    // This is a hack so we can call destructors on const/const objects.
                    ex = new AddrExp(место, ex);
                    ex = new CastExp(место, ex, sf.тип.mutableOf().pointerTo());
                    ex = new PtrExp(место, ex);
                    if (stc & STC.safe)
                        stc = (stc & ~STC.safe) | STC.trusted;

                    auto sfv = (cast(TypeStruct)sf.тип.baseElemOf()).sym;

                    ex = new DotVarExp(место, ex, sfv.dtor, нет);
                    ex = new CallExp(место, ex);

                    dtorCalls ~= ex;
                }
                else
                {
                    // _МассивDtor((cast(S*)this.v.ptr)[0 .. n])

                    const length = tv.numberOfElems(место);

                    ex = new ThisExp(место);
                    ex = new DotVarExp(место, ex, sf);

                    // This is a hack so we can call destructors on const/const objects.
                    ex = new DotIdExp(место, ex, Id.ptr);
                    ex = new CastExp(место, ex, sdv.тип.pointerTo());
                    if (stc & STC.safe)
                        stc = (stc & ~STC.safe) | STC.trusted;

                    auto se = new SliceExp(место, ex, new IntegerExp(место, 0, Тип.tт_мера),
                                                    new IntegerExp(место, length, Тип.tт_мера));
                    // Prevent redundant bounds check
                    se.upperIsInBounds = да;
                    se.lowerIsLessThanUpper = да;

                    ex = new CallExp(место, new IdentifierExp(место, Id.__МассивDtor), se);

                    dtorCalls ~= ex;
                }
            }
            fieldsToDestroy = [];

            // aggregate the destructor calls
            auto dtors = new Инструкции();
            foreach_reverse(dc; dtorCalls)
            {
                dtors.сунь(new ExpStatement(место, dc));
            }

            // put destructor calls in a `scope(failure)` block
            postblitCalls.сунь(new ScopeGuardStatement(место, ТОК2.onScopeFailure, new CompoundStatement(место, dtors)));
        }

        // perform semantic on the member postblit in order to
        // be able to aggregate it later on with the rest of the
        // postblits
        sdv.postblit.functionSemantic();

        stc = mergeFuncAttrs(stc, sdv.postblit);
        stc = mergeFuncAttrs(stc, sdv.dtor);

        // if any of the struct member fields has disabled
        // its postblit, then `sd` is not copyable, so no
        // postblit is generated
        if (stc & STC.disable)
        {
            postblitCalls.устДим(0);
            break;
        }

        Выражение ex;
        tv = structField.тип.toBasetype();
        if (tv.ty == Tstruct)
        {
            // this.v.__xpostblit()

            ex = new ThisExp(место);
            ex = new DotVarExp(место, ex, structField);

            // This is a hack so we can call postblits on const/const objects.
            ex = new AddrExp(место, ex);
            ex = new CastExp(место, ex, structField.тип.mutableOf().pointerTo());
            ex = new PtrExp(место, ex);
            if (stc & STC.safe)
                stc = (stc & ~STC.safe) | STC.trusted;

            ex = new DotVarExp(место, ex, sdv.postblit, нет);
            ex = new CallExp(место, ex);
        }
        else
        {
            // _МассивPostblit((cast(S*)this.v.ptr)[0 .. n])

            const length = tv.numberOfElems(место);
            if (length == 0)
                continue;

            ex = new ThisExp(место);
            ex = new DotVarExp(место, ex, structField);

            // This is a hack so we can call postblits on const/const objects.
            ex = new DotIdExp(место, ex, Id.ptr);
            ex = new CastExp(место, ex, sdv.тип.pointerTo());
            if (stc & STC.safe)
                stc = (stc & ~STC.safe) | STC.trusted;

            auto se = new SliceExp(место, ex, new IntegerExp(место, 0, Тип.tт_мера),
                                            new IntegerExp(место, length, Тип.tт_мера));
            // Prevent redundant bounds check
            se.upperIsInBounds = да;
            se.lowerIsLessThanUpper = да;
            ex = new CallExp(место, new IdentifierExp(место, Id.__МассивPostblit), se);
        }
        postblitCalls.сунь(new ExpStatement(место, ex)); // combine in forward order

        /* https://issues.dlang.org/show_bug.cgi?ид=10972
         * When subsequent field postblit calls fail,
         * this field should be destructed for Exception Safety.
         */
        if (sdv.dtor)
        {
            sdv.dtor.functionSemantic();

            // keep a list of fields that need to be destroyed in case
            // of a future postblit failure
            fieldsToDestroy ~= structField;
        }
    }

    проц checkShared()
    {
        if (sd.тип.isShared())
            stc |= STC.shared_;
    }

    // Build our own "postblit" which executes a, but only if needed.
    if (postblitCalls.dim || (stc & STC.disable))
    {
        //printf("Building __fieldPostBlit()\n");
        checkShared();
        auto dd = new PostBlitDeclaration(declLoc, Место.initial, stc, Id.__fieldPostblit);
        dd.generated = да;
        dd.класс_хранения |= STC.inference;
        dd.fbody = (stc & STC.disable) ? null : new CompoundStatement(место, postblitCalls);
        sd.postblits.shift(dd);
        sd.члены.сунь(dd);
        dd.dsymbolSemantic(sc);
    }

    // создай __xpostblit, which is the generated postblit
    FuncDeclaration xpostblit = null;
    switch (sd.postblits.dim)
    {
    case 0:
        break;

    case 1:
        xpostblit = sd.postblits[0];
        break;

    default:
        Выражение e = null;
        stc = STC.safe | STC.nothrow_ | STC.pure_ | STC.nogc;
        for (т_мера i = 0; i < sd.postblits.dim; i++)
        {
            auto fd = sd.postblits[i];
            stc = mergeFuncAttrs(stc, fd);
            if (stc & STC.disable)
            {
                e = null;
                break;
            }
            Выражение ex = new ThisExp(место);
            ex = new DotVarExp(место, ex, fd, нет);
            ex = new CallExp(место, ex);
            e = Выражение.combine(e, ex);
        }

        checkShared();
        auto dd = new PostBlitDeclaration(declLoc, Место.initial, stc, Id.__aggrPostblit);
        dd.generated = да;
        dd.класс_хранения |= STC.inference;
        dd.fbody = new ExpStatement(место, e);
        sd.члены.сунь(dd);
        dd.dsymbolSemantic(sc);
        xpostblit = dd;
        break;
    }

    // Add an __xpostblit alias to make the inclusive postblit accessible
    if (xpostblit)
    {
        auto _alias = new AliasDeclaration(Место.initial, Id.__xpostblit, xpostblit);
        _alias.dsymbolSemantic(sc);
        sd.члены.сунь(_alias);
        _alias.addMember(sc, sd); // add to symbol table
    }
    return xpostblit;
}

/**
 * Generates a копируй constructor declaration with the specified storage
 * class for the параметр and the function.
 *
 * Параметры:
 *  sd = the `struct` that содержит the копируй constructor
 *  paramStc = the storage class of the копируй constructor параметр
 *  funcStc = the storage class for the копируй constructor declaration
 *
 * Возвращает:
 *  The копируй constructor declaration for struct `sd`.
 */
private CtorDeclaration generateCopyCtorDeclaration(StructDeclaration sd, КлассХранения paramStc, КлассХранения funcStc)
{
    auto fparams = new Параметры();
    auto structType = sd.тип;
    fparams.сунь(new Параметр2(paramStc | STC.ref_ | STC.return_ | STC.scope_, structType, Id.p, null, null));
    СписокПараметров pList = СписокПараметров(fparams);
    auto tf = new TypeFunction(pList, structType, LINK.d, STC.ref_);
    auto ccd = new CtorDeclaration(sd.место, Место.initial, STC.ref_, tf, да);
    ccd.класс_хранения |= funcStc;
    ccd.класс_хранения |= STC.inference;
    ccd.generated = да;
    return ccd;
}

/**
 * Generates a trivial копируй constructor body that simply does memberwise
 * initialization:
 *
 *    this.field1 = rhs.field1;
 *    this.field2 = rhs.field2;
 *    ...
 *
 * Параметры:
 *  sd = the `struct` declaration that содержит the копируй constructor
 *
 * Возвращает:
 *  A `CompoundStatement` containing the body of the копируй constructor.
 */
private Инструкция2 generateCopyCtorBody(StructDeclaration sd)
{
    Место место;
    Выражение e;
    foreach (v; sd.fields)
    {
        auto ec = new AssignExp(место,
            new DotVarExp(место, new ThisExp(место), v),
            new DotVarExp(место, new IdentifierExp(место, Id.p), v));
        e = Выражение.combine(e, ec);
        //printf("e.вТкст0 = %s\n", e.вТкст0());
    }
    Инструкция2 s1 = new ExpStatement(место, e);
    return new CompoundStatement(место, s1);
}

/**
 * Generates a копируй constructor for a specified `struct` sd if
 * the following conditions are met:
 *
 * 1. sd does not define a копируй constructor
 * 2. at least one field of sd defines a копируй constructor
 *
 * If the above conditions are met, the following копируй constructor
 * is generated:
 *
 * this(ref return scope inout(S) rhs) inout
 * {
 *    this.field1 = rhs.field1;
 *    this.field2 = rhs.field2;
 *    ...
 * }
 *
 * Параметры:
 *  sd = the `struct` for which the копируй constructor is generated
 *  sc = the scope where the копируй constructor is generated
 *
 * Возвращает:
 *  `да` if `struct` sd defines a копируй constructor (explicitly or generated),
 *  `нет` otherwise.
 */
private бул buildCopyCtor(StructDeclaration sd, Scope* sc)
{
    if (глоб2.errors)
        return нет;

    бул hasPostblit;
    if (sd.postblit && !sd.postblit.isDisabled())
        hasPostblit = да;

    auto ctor = sd.search(sd.место, Id.ctor);
    CtorDeclaration cpCtor;
    CtorDeclaration rvalueCtor;
    if (ctor)
    {
        if (ctor.isOverloadSet())
            return нет;
        if (auto td = ctor.isTemplateDeclaration())
            ctor = td.funcroot;
    }

    if (!ctor)
        goto LcheckFields;

    overloadApply(ctor, (ДСимвол s)
    {
        if (s.isTemplateDeclaration())
            return 0;
        auto ctorDecl = s.isCtorDeclaration();
        assert(ctorDecl);
        if (ctorDecl.isCpCtor)
        {
            if (!cpCtor)
                cpCtor = ctorDecl;
            return 0;
        }

        auto tf = ctorDecl.тип.toTypeFunction();
        auto dim = Параметр2.dim(tf.parameterList);
        if (dim == 1)
        {
            auto param = Параметр2.getNth(tf.parameterList, 0);
            if (param.тип.mutableOf().unSharedOf() == sd.тип.mutableOf().unSharedOf())
            {
                rvalueCtor = ctorDecl;
            }
        }
        return 0;
    });

    if (cpCtor && rvalueCtor)
    {
        .выведиОшибку(sd.место, "`struct %s` may not define both a rvalue constructor and a копируй constructor", sd.вТкст0());
        errorSupplemental(rvalueCtor.место,"rvalue constructor defined here");
        errorSupplemental(cpCtor.место, "копируй constructor defined here");
        return да;
    }
    else if (cpCtor)
    {
        return !hasPostblit;
    }

LcheckFields:
    VarDeclaration fieldWithCpCtor;
    // see if any struct члены define a копируй constructor
    foreach (v; sd.fields)
    {
        if (v.класс_хранения & STC.ref_)
            continue;
        if (v.overlapped)
            continue;

        auto ts = v.тип.baseElemOf().isTypeStruct();
        if (!ts)
            continue;
        if (ts.sym.hasCopyCtor)
        {
            fieldWithCpCtor = v;
            break;
        }
    }

    if (fieldWithCpCtor && rvalueCtor)
    {
        .выведиОшибку(sd.место, "`struct %s` may not define a rvalue constructor and have fields with копируй constructors", sd.вТкст0());
        errorSupplemental(rvalueCtor.место,"rvalue constructor defined here");
        errorSupplemental(fieldWithCpCtor.место, "field with копируй constructor defined here");
        return нет;
    }
    else if (!fieldWithCpCtor)
        return нет;

    if (hasPostblit)
        return нет;

    //printf("generating копируй constructor for %s\n", sd.вТкст0());
    const MOD paramMod = MODFlags.wild;
    const MOD funcMod = MODFlags.wild;
    auto ccd = generateCopyCtorDeclaration(sd, ModToStc(paramMod), ModToStc(funcMod));
    auto copyCtorBody = generateCopyCtorBody(sd);
    ccd.fbody = copyCtorBody;
    sd.члены.сунь(ccd);
    ccd.addMember(sc, sd);
    const errors = глоб2.startGagging();
    Scope* sc2 = sc.сунь();
    sc2.stc = 0;
    sc2.компонаж = LINK.d;
    ccd.dsymbolSemantic(sc2);
    ccd.semantic2(sc2);
    ccd.semantic3(sc2);
    //printf("ccd semantic: %s\n", ccd.тип.вТкст0());
    sc2.вынь();
    if (глоб2.endGagging(errors))
    {
        ccd.класс_хранения |= STC.disable;
        ccd.fbody = null;
    }
    return да;
}

private бцел setMangleOverride(ДСимвол s, ткст sym)
{
    if (s.isFuncDeclaration() || s.isVarDeclaration())
    {
        s.isDeclaration().mangleOverride = sym;
        return 1;
    }

    if (auto ad = s.isAttribDeclaration())
    {
        бцел nestedCount = 0;

        ad.include(null).foreachDsymbol( (s) { nestedCount += setMangleOverride(s, sym); } );

        return nestedCount;
    }
    return 0;
}

/*************************************
 * Does semantic analysis on the public face of declarations.
 */
/*extern(C++)*/ проц dsymbolSemantic(ДСимвол dsym, Scope* sc)
{
    scope v = new DsymbolSemanticVisitor(sc);
    dsym.прими(v);
}

structalign_t getAlignment(AlignDeclaration ad, Scope* sc)
{
    if (ad.salign != ad.UNKNOWN)
        return ad.salign;

    if (!ad.ealign)
        return ad.salign = STRUCTALIGN_DEFAULT;

    sc = sc.startCTFE();
    ad.ealign = ad.ealign.ВыражениеSemantic(sc);
    ad.ealign = resolveProperties(sc, ad.ealign);
    sc = sc.endCTFE();
    ad.ealign = ad.ealign.ctfeInterpret();

    if (ad.ealign.op == ТОК2.error)
        return ad.salign = STRUCTALIGN_DEFAULT;

    Тип tb = ad.ealign.тип.toBasetype();
    auto n = ad.ealign.toInteger();

    if (n < 1 || n & (n - 1) || structalign_t.max < n || !tb.isintegral())
    {
        выведиОшибку(ad.место, "alignment must be an integer positive power of 2, not %s", ad.ealign.вТкст0());
        return ad.salign = STRUCTALIGN_DEFAULT;
    }

    return ad.salign = cast(structalign_t)n;
}

ткст0 getMessage(DeprecatedDeclaration dd)
{
    if (auto sc = dd._scope)
    {
        dd._scope = null;

        sc = sc.startCTFE();
        dd.msg = dd.msg.ВыражениеSemantic(sc);
        dd.msg = resolveProperties(sc, dd.msg);
        sc = sc.endCTFE();
        dd.msg = dd.msg.ctfeInterpret();

        if (auto se = dd.msg.вТкстExp())
            dd.msgstr = se.вТкст0().ptr;
        else
            dd.msg.выведиОшибку("compile time constant expected, not `%s`", dd.msg.вТкст0());
    }
    return dd.msgstr;
}


// Возвращает да if a contract can appear without a function body.
package бул allowsContractWithoutBody(FuncDeclaration funcdecl)
{
    assert(!funcdecl.fbody);

    /* Contracts can only appear without a body when they are virtual
     * interface functions or abstract.
     */
    ДСимвол родитель = funcdecl.toParent();
    InterfaceDeclaration ид = родитель.isInterfaceDeclaration();

    if (!funcdecl.isAbstract() &&
        (funcdecl.fensures || funcdecl.frequires) &&
        !(ид && funcdecl.isVirtual()))
    {
        auto cd = родитель.isClassDeclaration();
        if (!(cd && cd.isAbstract()))
            return нет;
    }
    return да;
}

private /*extern(C++)*/ final class DsymbolSemanticVisitor : Визитор2
{
    alias Визитор2.посети посети;

    Scope* sc;
    this(Scope* sc)
    {
        this.sc = sc;
    }

    override проц посети(ДСимвол dsym)
    {
        dsym.выведиОшибку("%p has no semantic routine", dsym);
    }

    override проц посети(ScopeDsymbol) { }
    override проц посети(Declaration) { }

    override проц посети(AliasThis dsym)
    {
        if (dsym.semanticRun != PASS.init)
            return;

        if (dsym._scope)
        {
            sc = dsym._scope;
            dsym._scope = null;
        }

        if (!sc)
            return;

        dsym.semanticRun = PASS.semantic;
        dsym.isDeprecated_ = !!(sc.stc & STC.deprecated_);

        ДСимвол p = sc.родитель.pastMixin();
        AggregateDeclaration ad = p.isAggregateDeclaration();
        if (!ad)
        {
            выведиОшибку(dsym.место, "alias this can only be a member of aggregate, not %s `%s`", p.вид(), p.вТкст0());
            return;
        }

        assert(ad.члены);
        ДСимвол s = ad.search(dsym.место, dsym.идент);
        if (!s)
        {
            s = sc.search(dsym.место, dsym.идент, null);
            if (s)
                выведиОшибку(dsym.место, "`%s` is not a member of `%s`", s.вТкст0(), ad.вТкст0());
            else
                выведиОшибку(dsym.место, "undefined идентификатор `%s`", dsym.идент.вТкст0());
            return;
        }
        if (ad.aliasthis && s != ad.aliasthis)
        {
            выведиОшибку(dsym.место, "there can be only one alias this");
            return;
        }

        /* disable the alias this conversion so the implicit conversion check
         * doesn't use it.
         */
        ad.aliasthis = null;

        ДСимвол sx = s;
        if (sx.isAliasDeclaration())
            sx = sx.toAlias();
        Declaration d = sx.isDeclaration();
        if (d && !d.isTupleDeclaration())
        {
            /* https://issues.dlang.org/show_bug.cgi?ид=18429
             *
             * If the идентификатор in the AliasThis declaration
             * is defined later and is a voldemort тип, we must
             * perform semantic on the declaration to deduce the тип.
             */
            if (!d.тип)
                d.dsymbolSemantic(sc);

            Тип t = d.тип;
            assert(t);
            if (ad.тип.implicitConvTo(t) > MATCH.nomatch)
            {
                выведиОшибку(dsym.место, "alias this is not reachable as `%s` already converts to `%s`", ad.вТкст0(), t.вТкст0());
            }
        }

        dsym.sym = s;
        // Restore alias this
        ad.aliasthis = dsym;
        dsym.semanticRun = PASS.semanticdone;
    }

    override проц посети(AliasDeclaration dsym)
    {
        if (dsym.semanticRun >= PASS.semanticdone)
            return;
        assert(dsym.semanticRun <= PASS.semantic);

        dsym.класс_хранения |= sc.stc & STC.deprecated_;
        dsym.защита = sc.защита;
        dsym.userAttribDecl = sc.userAttribDecl;

        if (!sc.func && dsym.inNonRoot())
            return;

        aliasSemantic(dsym, sc);
    }

    override проц посети(VarDeclaration dsym)
    {
        version (none)
        {
            printf("VarDeclaration::semantic('%s', родитель = '%s') sem = %d\n", вТкст0(), sc.родитель ? sc.родитель.вТкст0() : null, sem);
            printf(" тип = %s\n", тип ? тип.вТкст0() : "null");
            printf(" stc = x%x\n", sc.stc);
            printf(" класс_хранения = x%llx\n", класс_хранения);
            printf("компонаж = %d\n", sc.компонаж);
            //if (strcmp(вТкст0(), "mul") == 0) assert(0);
        }
        //if (semanticRun > PASS.init)
        //    return;
        //semanticRun = PSSsemantic;

        if (dsym.semanticRun >= PASS.semanticdone)
            return;

        if (sc && sc.inunion && sc.inunion.isAnonDeclaration())
            dsym.overlapped = да;

        Scope* scx = null;
        if (dsym._scope)
        {
            sc = dsym._scope;
            scx = sc;
            dsym._scope = null;
        }

        if (!sc)
            return;

        dsym.semanticRun = PASS.semantic;

        /* Pick up storage classes from context, but except synchronized,
         * override, abstract, and final.
         */
        dsym.класс_хранения |= (sc.stc & ~(STC.synchronized_ | STC.override_ | STC.abstract_ | STC.final_));
        if (dsym.класс_хранения & STC.extern_ && dsym._иниц)
            dsym.выведиОшибку("extern symbols cannot have initializers");

        dsym.userAttribDecl = sc.userAttribDecl;
        dsym.cppnamespace = sc.namespace;

        AggregateDeclaration ad = dsym.isThis();
        if (ad)
            dsym.класс_хранения |= ad.класс_хранения & STC.TYPECTOR;

        /* If auto тип inference, do the inference
         */
        цел inferred = 0;
        if (!dsym.тип)
        {
            dsym.inuse++;

            // Infering the тип requires running semantic,
            // so mark the scope as ctfe if required
            бул needctfe = (dsym.класс_хранения & (STC.manifest | STC.static_)) != 0;
            if (needctfe)
                sc = sc.startCTFE();

            //printf("inferring тип for %s with init %s\n", вТкст0(), _иниц.вТкст0());
            dsym._иниц = dsym._иниц.inferType(sc);
            dsym.тип = dsym._иниц.инициализаторВВыражение().тип;
            if (needctfe)
                sc = sc.endCTFE();

            dsym.inuse--;
            inferred = 1;

            /* This is a kludge to support the existing syntax for RAII
             * declarations.
             */
            dsym.класс_хранения &= ~STC.auto_;
            dsym.originalType = dsym.тип.syntaxCopy();
        }
        else
        {
            if (!dsym.originalType)
                dsym.originalType = dsym.тип.syntaxCopy();

            /* Prefix function attributes of variable declaration can affect
             * its тип:
             *        проц function() fp;
             *      static assert(is(typeof(fp) == проц function()  ));
             */
            Scope* sc2 = sc.сунь();
            sc2.stc |= (dsym.класс_хранения & STC.FUNCATTR);
            dsym.inuse++;
            dsym.тип = dsym.тип.typeSemantic(dsym.место, sc2);
            dsym.inuse--;
            sc2.вынь();
        }
        //printf(" semantic тип = %s\n", dsym.тип ? dsym.тип.вТкст0() : "null");
        if (dsym.тип.ty == Terror)
            dsym.errors = да;

        dsym.тип.checkDeprecated(dsym.место, sc);
        dsym.компонаж = sc.компонаж;
        dsym.родитель = sc.родитель;
        //printf("this = %p, родитель = %p, '%s'\n", this, родитель, родитель.вТкст0());
        dsym.защита = sc.защита;

        /* If scope's alignment is the default, use the тип's alignment,
         * otherwise the scope overrrides.
         */
        dsym.alignment = sc.alignment();
        if (dsym.alignment == STRUCTALIGN_DEFAULT)
            dsym.alignment = dsym.тип.alignment(); // use тип's alignment

        //printf("sc.stc = %x\n", sc.stc);
        //printf("класс_хранения = x%x\n", класс_хранения);

        if (глоб2.парамы.vcomplex)
            dsym.тип.checkComplexTransition(dsym.место, sc);

        // Calculate тип size + safety checks
        if (sc.func && !sc.intypeof)
        {
            if (dsym.класс_хранения & STC.gshared && !dsym.isMember())
            {
                if (sc.func.setUnsafe())
                    dsym.выведиОшибку(" not allowed in safe functions; use shared");
            }
        }

        ДСимвол родитель = dsym.toParent();

        Тип tb = dsym.тип.toBasetype();
        Тип tbn = tb.baseElemOf();
        if (tb.ty == Tvoid && !(dsym.класс_хранения & STC.lazy_))
        {
            if (inferred)
            {
                dsym.выведиОшибку("тип `%s` is inferred from инициализатор `%s`, and variables cannot be of тип `проц`", dsym.тип.вТкст0(), dsym._иниц.вТкст0());
            }
            else
                dsym.выведиОшибку("variables cannot be of тип `проц`");
            dsym.тип = Тип.terror;
            tb = dsym.тип;
        }
        if (tb.ty == Tfunction)
        {
            dsym.выведиОшибку("cannot be declared to be a function");
            dsym.тип = Тип.terror;
            tb = dsym.тип;
        }
        if (auto ts = tb.isTypeStruct())
        {
            if (!ts.sym.члены)
            {
                dsym.выведиОшибку("no definition of struct `%s`", ts.вТкст0());
            }
        }
        if ((dsym.класс_хранения & STC.auto_) && !inferred)
            dsym.выведиОшибку("storage class `auto` has no effect if тип is not inferred, did you mean `scope`?");

        if (auto tt = tb.isTypeTuple())
        {
            /* Instead, declare variables for each of the кортеж elements
             * and add those.
             */
            т_мера nelems = Параметр2.dim(tt.arguments);
            Выражение ie = (dsym._иниц && !dsym._иниц.isVoidInitializer()) ? dsym._иниц.инициализаторВВыражение() : null;
            if (ie)
                ie = ie.ВыражениеSemantic(sc);
            if (nelems > 0 && ie)
            {
                auto iexps = new Выражения();
                iexps.сунь(ie);
                auto exps = new Выражения();
                for (т_мера pos = 0; pos < iexps.dim; pos++)
                {
                Lexpand1:
                    Выражение e = (*iexps)[pos];
                    Параметр2 arg = Параметр2.getNth(tt.arguments, pos);
                    arg.тип = arg.тип.typeSemantic(dsym.место, sc);
                    //printf("[%d] iexps.dim = %d, ", pos, iexps.dim);
                    //printf("e = (%s %s, %s), ", Сема2::tochars[e.op], e.вТкст0(), e.тип.вТкст0());
                    //printf("arg = (%s, %s)\n", arg.вТкст0(), arg.тип.вТкст0());

                    if (e != ie)
                    {
                        if (iexps.dim > nelems)
                            goto Lnomatch;
                        if (e.тип.implicitConvTo(arg.тип))
                            continue;
                    }

                    if (e.op == ТОК2.кортеж)
                    {
                        TupleExp te = cast(TupleExp)e;
                        if (iexps.dim - 1 + te.exps.dim > nelems)
                            goto Lnomatch;

                        iexps.удали(pos);
                        iexps.вставь(pos, te.exps);
                        (*iexps)[pos] = Выражение.combine(te.e0, (*iexps)[pos]);
                        goto Lexpand1;
                    }
                    else if (isAliasThisTuple(e))
                    {
                        auto v = copyToTemp(0, "__tup", e);
                        v.dsymbolSemantic(sc);
                        auto ve = new VarExp(dsym.место, v);
                        ve.тип = e.тип;

                        exps.устДим(1);
                        (*exps)[0] = ve;
                        expandAliasThisTuples(exps, 0);

                        for (т_мера u = 0; u < exps.dim; u++)
                        {
                        Lexpand2:
                            Выражение ee = (*exps)[u];
                            arg = Параметр2.getNth(tt.arguments, pos + u);
                            arg.тип = arg.тип.typeSemantic(dsym.место, sc);
                            //printf("[%d+%d] exps.dim = %d, ", pos, u, exps.dim);
                            //printf("ee = (%s %s, %s), ", Сема2::tochars[ee.op], ee.вТкст0(), ee.тип.вТкст0());
                            //printf("arg = (%s, %s)\n", arg.вТкст0(), arg.тип.вТкст0());

                            т_мера iexps_dim = iexps.dim - 1 + exps.dim;
                            if (iexps_dim > nelems)
                                goto Lnomatch;
                            if (ee.тип.implicitConvTo(arg.тип))
                                continue;

                            if (expandAliasThisTuples(exps, u) != -1)
                                goto Lexpand2;
                        }

                        if ((*exps)[0] != ve)
                        {
                            Выражение e0 = (*exps)[0];
                            (*exps)[0] = new CommaExp(dsym.место, new DeclarationExp(dsym.место, v), e0);
                            (*exps)[0].тип = e0.тип;

                            iexps.удали(pos);
                            iexps.вставь(pos, exps);
                            goto Lexpand1;
                        }
                    }
                }
                if (iexps.dim < nelems)
                    goto Lnomatch;

                ie = new TupleExp(dsym._иниц.место, iexps);
            }
        Lnomatch:

            if (ie && ie.op == ТОК2.кортеж)
            {
                TupleExp te = cast(TupleExp)ie;
                т_мера tedim = te.exps.dim;
                if (tedim != nelems)
                {
                    выведиОшибку(dsym.место, "кортеж of %d elements cannot be assigned to кортеж of %d elements", cast(цел)tedim, cast(цел)nelems);
                    for (т_мера u = tedim; u < nelems; u++) // fill dummy Выражение
                        te.exps.сунь(new ErrorExp());
                }
            }

            auto exps = new Объекты(nelems);
            for (т_мера i = 0; i < nelems; i++)
            {
                Параметр2 arg = Параметр2.getNth(tt.arguments, i);

                БуфВыв буф;
                буф.printf("__%s_field_%llu", dsym.идент.вТкст0(), cast(бдол)i);
                auto ид = Идентификатор2.idPool(буф[]);

                Инициализатор ti;
                if (ie)
                {
                    Выражение einit = ie;
                    if (ie.op == ТОК2.кортеж)
                    {
                        TupleExp te = cast(TupleExp)ie;
                        einit = (*te.exps)[i];
                        if (i == 0)
                            einit = Выражение.combine(te.e0, einit);
                    }
                    ti = new ExpInitializer(einit.место, einit);
                }
                else
                    ti = dsym._иниц ? dsym._иниц.syntaxCopy() : null;

                КлассХранения класс_хранения = STC.temp | dsym.класс_хранения;
                if (arg.классХранения & STC.параметр)
                    класс_хранения |= arg.классХранения;
                auto v = new VarDeclaration(dsym.место, arg.тип, ид, ti, класс_хранения);
                //printf("declaring field %s of тип %s\n", v.вТкст0(), v.тип.вТкст0());
                v.dsymbolSemantic(sc);

                if (sc.scopesym)
                {
                    //printf("adding %s to %s\n", v.вТкст0(), sc.scopesym.вТкст0());
                    if (sc.scopesym.члены)
                        // Note this prevents using foreach() over члены, because the limits can change
                        sc.scopesym.члены.сунь(v);
                }

                Выражение e = new DsymbolExp(dsym.место, v);
                (*exps)[i] = e;
            }
            auto v2 = new TupleDeclaration(dsym.место, dsym.идент, exps);
            v2.родитель = dsym.родитель;
            v2.isexp = да;
            dsym.aliassym = v2;
            dsym.semanticRun = PASS.semanticdone;
            return;
        }

        /* Storage class can modify the тип
         */
        dsym.тип = dsym.тип.addStorageClass(dsym.класс_хранения);

        /* Adjust storage class to reflect тип
         */
        if (dsym.тип.isConst())
        {
            dsym.класс_хранения |= STC.const_;
            if (dsym.тип.isShared())
                dsym.класс_хранения |= STC.shared_;
        }
        else if (dsym.тип.isImmutable())
            dsym.класс_хранения |= STC.immutable_;
        else if (dsym.тип.isShared())
            dsym.класс_хранения |= STC.shared_;
        else if (dsym.тип.isWild())
            dsym.класс_хранения |= STC.wild;

        if (КлассХранения stc = dsym.класс_хранения & (STC.synchronized_ | STC.override_ | STC.abstract_ | STC.final_))
        {
            if (stc == STC.final_)
                dsym.выведиОшибку("cannot be `final`, perhaps you meant `const`?");
            else
            {
                БуфВыв буф;
                stcToBuffer(&буф, stc);
                dsym.выведиОшибку("cannot be `%s`", буф.peekChars());
            }
            dsym.класс_хранения &= ~stc; // strip off
        }

        if (dsym.класс_хранения & STC.scope_)
        {
            КлассХранения stc = dsym.класс_хранения & (STC.static_ | STC.extern_ | STC.manifest | STC.tls | STC.gshared);
            if (stc)
            {
                БуфВыв буф;
                stcToBuffer(&буф, stc);
                dsym.выведиОшибку("cannot be `scope` and `%s`", буф.peekChars());
            }
            else if (dsym.isMember())
            {
                dsym.выведиОшибку("field cannot be `scope`");
            }
            else if (!dsym.тип.hasPointers())
            {
                dsym.класс_хранения &= ~STC.scope_;     // silently ignore; may occur in generic code
            }
        }

        if (dsym.класс_хранения & (STC.static_ | STC.extern_ | STC.manifest | STC.шаблонпараметр | STC.tls | STC.gshared | STC.ctfe))
        {
        }
        else
        {
            AggregateDeclaration aad = родитель.isAggregateDeclaration();
            if (aad)
            {
                if (глоб2.парамы.vfield && dsym.класс_хранения & (STC.const_ | STC.immutable_) && dsym._иниц && !dsym._иниц.isVoidInitializer())
                {
                    ткст0 s = (dsym.класс_хранения & STC.immutable_) ? "const" : "const";
                    message(dsym.место, "`%s.%s` is `%s` field", ad.toPrettyChars(), dsym.вТкст0(), s);
                }
                dsym.класс_хранения |= STC.field;
                if (auto ts = tbn.isTypeStruct())
                    if (ts.sym.noDefaultCtor)
                    {
                        if (!dsym.isThisDeclaration() && !dsym._иниц)
                            aad.noDefaultCtor = да;
                    }
            }

            InterfaceDeclaration ид = родитель.isInterfaceDeclaration();
            if (ид)
            {
                dsym.выведиОшибку("field not allowed in interface");
            }
            else if (aad && aad.sizeok == Sizeok.done)
            {
                dsym.выведиОшибку("cannot be further field because it will change the determined %s size", aad.вТкст0());
            }

            /* Templates cannot add fields to aggregates
             */
            TemplateInstance ti = родитель.isTemplateInstance();
            if (ti)
            {
                // Take care of nested templates
                while (1)
                {
                    TemplateInstance ti2 = ti.tempdecl.родитель.isTemplateInstance();
                    if (!ti2)
                        break;
                    ti = ti2;
                }
                // If it's a member template
                AggregateDeclaration ad2 = ti.tempdecl.isMember();
                if (ad2 && dsym.класс_хранения != STC.undefined_)
                {
                    dsym.выведиОшибку("cannot use template to add field to aggregate `%s`", ad2.вТкст0());
                }
            }
        }

        if ((dsym.класс_хранения & (STC.ref_ | STC.параметр | STC.foreach_ | STC.temp | STC.результат)) == STC.ref_ && dsym.идент != Id.This)
        {
            dsym.выведиОшибку("only parameters or `foreach` declarations can be `ref`");
        }

        if (dsym.тип.hasWild())
        {
            if (dsym.класс_хранения & (STC.static_ | STC.extern_ | STC.tls | STC.gshared | STC.manifest | STC.field) || dsym.isDataseg())
            {
                dsym.выведиОшибку("only parameters or stack based variables can be `inout`");
            }
            FuncDeclaration func = sc.func;
            if (func)
            {
                if (func.fes)
                    func = func.fes.func;
                бул isWild = нет;
                for (FuncDeclaration fd = func; fd; fd = fd.toParentDecl().isFuncDeclaration())
                {
                    if ((cast(TypeFunction)fd.тип).iswild)
                    {
                        isWild = да;
                        break;
                    }
                }
                if (!isWild)
                {
                    dsym.выведиОшибку("`inout` variables can only be declared inside `inout` functions");
                }
            }
        }

        if (!(dsym.класс_хранения & (STC.ctfe | STC.ref_ | STC.результат)) &&
            tbn.ty == Tstruct && (cast(TypeStruct)tbn).sym.noDefaultCtor)
        {
            if (!dsym._иниц)
            {
                if (dsym.isField())
                {
                    /* For fields, we'll check the constructor later to make sure it is initialized
                     */
                    dsym.класс_хранения |= STC.nodefaultctor;
                }
                else if (dsym.класс_хранения & STC.параметр)
                {
                }
                else
                    dsym.выведиОшибку("default construction is disabled for тип `%s`", dsym.тип.вТкст0());
            }
        }

        FuncDeclaration fd = родитель.isFuncDeclaration();
        if (dsym.тип.isscope() && !(dsym.класс_хранения & STC.nodtor))
        {
            if (dsym.класс_хранения & (STC.field | STC.out_ | STC.ref_ | STC.static_ | STC.manifest | STC.tls | STC.gshared) || !fd)
            {
                dsym.выведиОшибку("globals, statics, fields, manifest constants, ref and out parameters cannot be `scope`");
            }

            // @@@DEPRECATED@@@  https://dlang.org/deprecate.html#scope%20as%20a%20type%20constraint
            // Deprecated in 2.087
            // Remove this when the feature is removed from the language
            if (0 &&          // deprecation disabled for now to accommodate existing extensive use
               !(dsym.класс_хранения & STC.scope_))
            {
                if (!(dsym.класс_хранения & STC.параметр) && dsym.идент != Id.withSym)
                    dsym.выведиОшибку("reference to `scope class` must be `scope`");
            }
        }

        // Calculate тип size + safety checks
        if (sc.func && !sc.intypeof)
        {
            if (dsym._иниц && dsym._иниц.isVoidInitializer() && dsym.тип.hasPointers()) // get тип size
            {
                if (sc.func.setUnsafe())
                    dsym.выведиОшибку("`проц` initializers for pointers not allowed in safe functions");
            }
            else if (!dsym._иниц &&
                     !(dsym.класс_хранения & (STC.static_ | STC.extern_ | STC.tls | STC.gshared | STC.manifest | STC.field | STC.параметр)) &&
                     dsym.тип.hasVoidInitPointers())
            {
                if (sc.func.setUnsafe())
                    dsym.выведиОшибку("`проц` initializers for pointers not allowed in safe functions");
            }
        }

        if ((!dsym._иниц || dsym._иниц.isVoidInitializer) && !fd)
        {
            // If not mutable, initializable by constructor only
            dsym.класс_хранения |= STC.ctorinit;
        }

        if (dsym._иниц)
            dsym.класс_хранения |= STC.init; // remember we had an explicit инициализатор
        else if (dsym.класс_хранения & STC.manifest)
            dsym.выведиОшибку("manifest constants must have initializers");

        бул isBlit = нет;
        d_uns64 sz;
        if (!dsym._иниц &&
            !(dsym.класс_хранения & (STC.static_ | STC.gshared | STC.extern_)) &&
            fd &&
            (!(dsym.класс_хранения & (STC.field | STC.in_ | STC.foreach_ | STC.параметр | STC.результат)) ||
             (dsym.класс_хранения & STC.out_)) &&
            (sz = dsym.тип.size()) != 0)
        {
            // Provide a default инициализатор

            //printf("Providing default инициализатор for '%s'\n", вТкст0());
            if (sz == SIZE_INVALID && dsym.тип.ty != Terror)
                dsym.выведиОшибку("size of тип `%s` is invalid", dsym.тип.вТкст0());

            Тип tv = dsym.тип;
            while (tv.ty == Tsarray)    // Don't skip Tenum
                tv = tv.nextOf();
            if (tv.needsNested())
            {
                /* Nested struct requires valid enclosing frame pointer.
                 * In StructLiteralExp::toElem(), it's calculated.
                 */
                assert(tbn.ty == Tstruct);
                checkFrameAccess(dsym.место, sc, tbn.isTypeStruct().sym);

                Выражение e = tv.defaultInitLiteral(dsym.место);
                e = new BlitExp(dsym.место, new VarExp(dsym.место, dsym), e);
                e = e.ВыражениеSemantic(sc);
                dsym._иниц = new ExpInitializer(dsym.место, e);
                goto Ldtor;
            }
            if (tv.ty == Tstruct && (cast(TypeStruct)tv).sym.zeroInit)
            {
                /* If a struct is all zeros, as a special case
                 * set it's инициализатор to the integer 0.
                 * In AssignExp::toElem(), we check for this and issue
                 * a memset() to initialize the struct.
                 * Must do same check in interpreter.
                 */
                Выражение e = new IntegerExp(dsym.место, 0, Тип.tint32);
                e = new BlitExp(dsym.место, new VarExp(dsym.место, dsym), e);
                e.тип = dsym.тип;      // don't тип check this, it would fail
                dsym._иниц = new ExpInitializer(dsym.место, e);
                goto Ldtor;
            }
            if (dsym.тип.baseElemOf().ty == Tvoid)
            {
                dsym.выведиОшибку("`%s` does not have a default инициализатор", dsym.тип.вТкст0());
            }
            else if (auto e = dsym.тип.defaultInit(dsym.место))
            {
                dsym._иниц = new ExpInitializer(dsym.место, e);
            }

            // Default инициализатор is always a blit
            isBlit = да;
        }
        if (dsym._иниц)
        {
            sc = sc.сунь();
            sc.stc &= ~(STC.TYPECTOR | STC.pure_ | STC.nothrow_ | STC.nogc | STC.ref_ | STC.disable);

            ExpInitializer ei = dsym._иниц.isExpInitializer();
            if (ei) // https://issues.dlang.org/show_bug.cgi?ид=13424
                    // Preset the required тип to fail in FuncLiteralDeclaration::semantic3
                ei.exp = inferType(ei.exp, dsym.тип);

            // If inside function, there is no semantic3() call
            if (sc.func || sc.intypeof == 1)
            {
                // If local variable, use AssignExp to handle all the various
                // possibilities.
                if (fd && !(dsym.класс_хранения & (STC.manifest | STC.static_ | STC.tls | STC.gshared | STC.extern_)) && !dsym._иниц.isVoidInitializer())
                {
                    //printf("fd = '%s', var = '%s'\n", fd.вТкст0(), вТкст0());
                    if (!ei)
                    {
                        ArrayInitializer ai = dsym._иниц.isArrayInitializer();
                        Выражение e;
                        if (ai && tb.ty == Taarray)
                            e = ai.toAssocArrayLiteral();
                        else
                            e = dsym._иниц.инициализаторВВыражение();
                        if (!e)
                        {
                            // Run semantic, but don't need to interpret
                            dsym._иниц = dsym._иниц.initializerSemantic(sc, dsym.тип, INITnointerpret);
                            e = dsym._иниц.инициализаторВВыражение();
                            if (!e)
                            {
                                dsym.выведиОшибку("is not a static and cannot have static инициализатор");
                                e = new ErrorExp();
                            }
                        }
                        ei = new ExpInitializer(dsym._иниц.место, e);
                        dsym._иниц = ei;
                    }

                    Выражение exp = ei.exp;
                    Выражение e1 = new VarExp(dsym.место, dsym);
                    if (isBlit)
                        exp = new BlitExp(dsym.место, e1, exp);
                    else
                        exp = new ConstructExp(dsym.место, e1, exp);
                    dsym.canassign++;
                    exp = exp.ВыражениеSemantic(sc);
                    dsym.canassign--;
                    exp = exp.optimize(WANTvalue);
                    if (exp.op == ТОК2.error)
                    {
                        dsym._иниц = new ErrorInitializer();
                        ei = null;
                    }
                    else
                        ei.exp = exp;

                    if (ei && dsym.isScope())
                    {
                        Выражение ex = ei.exp;
                        while (ex.op == ТОК2.comma)
                            ex = (cast(CommaExp)ex).e2;
                        if (ex.op == ТОК2.blit || ex.op == ТОК2.construct)
                            ex = (cast(AssignExp)ex).e2;
                        if (ex.op == ТОК2.new_)
                        {
                            // See if инициализатор is a NewExp that can be allocated on the stack
                            NewExp ne = cast(NewExp)ex;
                            if (dsym.тип.toBasetype().ty == Tclass)
                            {
                                if (ne.newargs && ne.newargs.dim > 1)
                                {
                                    dsym.mynew = да;
                                }
                                else
                                {
                                    ne.onstack = 1;
                                    dsym.onstack = да;
                                }
                            }
                        }
                        else if (ex.op == ТОК2.function_)
                        {
                            // or a delegate that doesn't ýñêàïèðóé a reference to the function
                            FuncDeclaration f = (cast(FuncExp)ex).fd;
                            f.tookAddressOf--;
                        }
                    }
                }
                else
                {
                    // https://issues.dlang.org/show_bug.cgi?ид=14166
                    // Don't run CTFE for the temporary variables inside typeof
                    dsym._иниц = dsym._иниц.initializerSemantic(sc, dsym.тип, sc.intypeof == 1 ? INITnointerpret : INITinterpret);
                    const init_err = dsym._иниц.isExpInitializer();
                    if (init_err && init_err.exp.op == ТОК2.showCtfeContext)
                    {
                         errorSupplemental(dsym.место, "compile time context created here");
                    }
                }
            }
            else if (родитель.isAggregateDeclaration())
            {
                dsym._scope = scx ? scx : sc.копируй();
                dsym._scope.setNoFree();
            }
            else if (dsym.класс_хранения & (STC.const_ | STC.immutable_ | STC.manifest) || dsym.тип.isConst() || dsym.тип.isImmutable())
            {
                /* Because we may need the результатs of a const declaration in a
                 * subsequent тип, such as an массив dimension, before semantic2()
                 * gets ordinarily run, try to run semantic2() now.
                 * Ignore failure.
                 */
                if (!inferred)
                {
                    бцел errors = глоб2.errors;
                    dsym.inuse++;
                    // Bug 20549. Don't try this on modules or пакеты, syntaxCopy
                    // could crash (inf. recursion) on a mod/pkg referencing itself
                    if (ei && (ei.exp.op != ТОК2.scope_ ? да : !(cast(ScopeExp)ei.exp).sds.isPackage()))
                    {
                        Выражение exp = ei.exp.syntaxCopy();

                        бул needctfe = dsym.isDataseg() || (dsym.класс_хранения & STC.manifest);
                        if (needctfe)
                            sc = sc.startCTFE();
                        exp = exp.ВыражениеSemantic(sc);
                        exp = resolveProperties(sc, exp);
                        if (needctfe)
                            sc = sc.endCTFE();

                        Тип tb2 = dsym.тип.toBasetype();
                        Тип ti = exp.тип.toBasetype();

                        /* The problem is the following code:
                         *  struct CopyTest {
                         *     double x;
                         *     this(double a) { x = a * 10.0;}
                         *     this(this) { x += 2.0; }
                         *  }
                         *  const CopyTest z = CopyTest(5.3);  // ok
                         *  const CopyTest w = z;              // not ok, postblit not run
                         *  static assert(w.x == 55.0);
                         * because the postblit doesn't get run on the initialization of w.
                         */
                        if (auto ts = ti.isTypeStruct())
                        {
                            StructDeclaration sd = ts.sym;
                            /* Look to see if инициализатор involves a копируй constructor
                             * (which implies a postblit)
                             */
                            // there is a копируй constructor
                            // and exp is the same struct
                            if (sd.postblit && tb2.toDsymbol(null) == sd)
                            {
                                // The only allowable инициализатор is a (non-копируй) constructor
                                if (exp.isLvalue())
                                    dsym.выведиОшибку("of тип struct `%s` uses `this(this)`, which is not allowed in static initialization", tb2.вТкст0());
                            }
                        }
                        ei.exp = exp;
                    }
                    dsym._иниц = dsym._иниц.initializerSemantic(sc, dsym.тип, INITinterpret);
                    dsym.inuse--;
                    if (глоб2.errors > errors)
                    {
                        dsym._иниц = new ErrorInitializer();
                        dsym.тип = Тип.terror;
                    }
                }
                else
                {
                    dsym._scope = scx ? scx : sc.копируй();
                    dsym._scope.setNoFree();
                }
            }
            sc = sc.вынь();
        }

    Ldtor:
        /* Build code to execute destruction, if necessary
         */
        dsym.edtor = dsym.callScopeDtor(sc);
        if (dsym.edtor)
        {
            /* If dsym is a local variable, who's тип is a struct with a scope destructor,
             * then make dsym scope, too.
             */
            if (глоб2.парамы.vsafe &&
                !(dsym.класс_хранения & (STC.параметр | STC.temp | STC.field | STC.in_ | STC.foreach_ | STC.результат | STC.manifest)) &&
                !dsym.isDataseg() &&
                !dsym.doNotInferScope &&
                dsym.тип.hasPointers())
            {
                auto tv = dsym.тип.baseElemOf();
                if (tv.ty == Tstruct &&
                    (cast(TypeStruct)tv).sym.dtor.класс_хранения & STC.scope_)
                {
                    dsym.класс_хранения |= STC.scope_;
                }
            }

            if (sc.func && dsym.класс_хранения & (STC.static_ | STC.gshared))
                dsym.edtor = dsym.edtor.ВыражениеSemantic(sc._module._scope);
            else
                dsym.edtor = dsym.edtor.ВыражениеSemantic(sc);

            version (none)
            {
                // currently disabled because of std.stdio.stdin, stdout and stderr
                if (dsym.isDataseg() && !(dsym.класс_хранения & STC.extern_))
                    dsym.выведиОшибку("static storage variables cannot have destructors");
            }
        }

        dsym.semanticRun = PASS.semanticdone;

        if (dsym.тип.toBasetype().ty == Terror)
            dsym.errors = да;

        if(sc.scopesym && !sc.scopesym.isAggregateDeclaration())
        {
            for (ScopeDsymbol sym = sc.scopesym; sym && dsym.endlinnum == 0;
                 sym = sym.родитель ? sym.родитель.isScopeDsymbol() : null)
                dsym.endlinnum = sym.endlinnum;
        }
    }

    override проц посети(TypeInfoDeclaration dsym)
    {
        assert(dsym.компонаж == LINK.c);
    }

    override проц посети(Импорт imp)
    {
        //printf("Импорт::semantic('%s') %s\n", toPrettyChars(), ид.вТкст0());
        if (imp.semanticRun > PASS.init)
            return;

        if (imp._scope)
        {
            sc = imp._scope;
            imp._scope = null;
        }
        if (!sc)
            return;

        imp.semanticRun = PASS.semantic;

        // Load if not already done so
        бул loadErrored = нет;
        if (!imp.mod)
        {
            loadErrored = imp.load(sc);
            if (imp.mod)
            {
                imp.mod.importAll(null);
                imp.mod.checkImportDeprecation(imp.место, sc);
            }
        }
        if (imp.mod)
        {
            // Modules need a list of each imported module

            // if inside a template instantiation, the instantianting
            // module gets the import.
            // https://issues.dlang.org/show_bug.cgi?ид=17181
            if (sc.minst && sc.tinst)
            {
                //printf("%s imports %s\n", sc.minst.вТкст0(), imp.mod.вТкст0());
                if (!sc.tinst.importedModules.содержит(imp.mod))
                    sc.tinst.importedModules.сунь(imp.mod);
                if (!sc.minst.aimports.содержит(imp.mod))
                    sc.minst.aimports.сунь(imp.mod);
            }
            else
            {
                //printf("%s imports %s\n", sc._module.вТкст0(), imp.mod.вТкст0());
                if (!sc._module.aimports.содержит(imp.mod))
                    sc._module.aimports.сунь(imp.mod);
            }

            if (sc.explicitProtection)
                imp.защита = sc.защита;

            if (!imp.идНик && !imp.имена.dim) // neither a selective nor a renamed import
            {
                ScopeDsymbol scopesym;
                for (Scope* scd = sc; scd; scd = scd.enclosing)
                {
                    if (!scd.scopesym)
                        continue;
                    scopesym = scd.scopesym;
                    break;
                }

                if (!imp.статичен_ли)
                {
                    scopesym.importScope(imp.mod, imp.защита);
                }

                // Mark the imported пакеты as accessible from the current
                // scope. This access check is necessary when using FQN b/c
                // we're using a single глоб2 package tree.
                // https://issues.dlang.org/show_bug.cgi?ид=313
                if (imp.пакеты)
                {
                    // import a.b.c.d;
                    auto p = imp.pkg; // a
                    scopesym.addAccessiblePackage(p, imp.защита);
                    foreach (ид; (*imp.пакеты)[1 .. imp.пакеты.dim]) // [b, c]
                    {
                        p = cast(Package) p.symtab.lookup(ид);
                        // https://issues.dlang.org/show_bug.cgi?ид=17991
                        // An import of truly empty файл/package can happen
                        // https://issues.dlang.org/show_bug.cgi?ид=20151
                        // Package in the path conflicts with a module имя
                        if (p is null)
                            break;
                        scopesym.addAccessiblePackage(p, imp.защита);
                    }
                }
                scopesym.addAccessiblePackage(imp.mod, imp.защита); // d
            }

            if (!loadErrored)
            {
                imp.mod.dsymbolSemantic(null);
            }

            if (imp.mod.needmoduleinfo)
            {
                //printf("module4 %s because of %s\n", sc.module.вТкст0(), mod.вТкст0());
                sc._module.needmoduleinfo = 1;
            }

            sc = sc.сунь(imp.mod);
            sc.защита = imp.защита;
            for (т_мера i = 0; i < imp.aliasdecls.dim; i++)
            {
                AliasDeclaration ad = imp.aliasdecls[i];
                //printf("\tImport %s alias %s = %s, scope = %p\n", toPrettyChars(), ники[i].вТкст0(), имена[i].вТкст0(), ad._scope);
                ДСимвол sym = imp.mod.search(imp.место, imp.имена[i], IgnorePrivateImports);
                if (sym)
                {
                      if (!symbolIsVisible(sc, sym))
                        imp.mod.выведиОшибку(imp.место, "member `%s` is not visible from module `%s`",
                            imp.имена[i].вТкст0(), sc._module.вТкст0());
                    ad.dsymbolSemantic(sc);
                    // If the import declaration is in non-root module,
                    // analysis of the aliased symbol is deferred.
                    // Therefore, don't see the ad.aliassym or ad.тип here.
                }
                else
                {
                    ДСимвол s = imp.mod.search_correct(imp.имена[i]);
                    if (s)
                        imp.mod.выведиОшибку(imp.место, "import `%s` not found, did you mean %s `%s`?", imp.имена[i].вТкст0(), s.вид(), s.toPrettyChars());
                    else
                        imp.mod.выведиОшибку(imp.место, "import `%s` not found", imp.имена[i].вТкст0());
                    ad.тип = Тип.terror;
                }
            }
            sc = sc.вынь();
        }

        imp.semanticRun = PASS.semanticdone;

        // объект self-imports itself, so skip that
        // https://issues.dlang.org/show_bug.cgi?ид=7547
        // don't list pseudo modules __entrypoint.d, __main.d
        // https://issues.dlang.org/show_bug.cgi?ид=11117
        // https://issues.dlang.org/show_bug.cgi?ид=11164
        if (глоб2.парамы.moduleDeps !is null && !(imp.ид == Id.объект && sc._module.идент == Id.объект) &&
            strcmp(sc._module.идент.вТкст0(), "__main") != 0)
        {
            /* The grammar of the файл is:
             *      ImportDeclaration
             *          ::= BasicImportDeclaration [ " : " ImportBindList ] [ " -> "
             *      ModuleAliasIdentifier ] "\n"
             *
             *      BasicImportDeclaration
             *          ::= ModuleFullyQualifiedName " (" FilePath ") : " Protection|"ткст"
             *              " [ " static" ] : " ModuleFullyQualifiedName " (" FilePath ")"
             *
             *      FilePath
             *          - any ткст with '(', ')' and '\' escaped with the '\' character
             */
            БуфВыв* ob = глоб2.парамы.moduleDeps;
            Module imod = sc.instantiatingModule();
            if (!глоб2.парамы.moduleDepsFile)
                ob.пишиСтр("depsImport ");
            ob.пишиСтр(imod.toPrettyChars());
            ob.пишиСтр(" (");
            escapePath(ob, imod.srcfile.вТкст0());
            ob.пишиСтр(") : ");
            // use защита instead of sc.защита because it couldn't be
            // resolved yet, see the коммент above
            protectionToBuffer(ob, imp.защита);
            ob.пишиБайт(' ');
            if (imp.статичен_ли)
            {
                stcToBuffer(ob, STC.static_);
                ob.пишиБайт(' ');
            }
            ob.пишиСтр(": ");
            if (imp.пакеты)
            {
                for (т_мера i = 0; i < imp.пакеты.dim; i++)
                {
                    Идентификатор2 pid = (*imp.пакеты)[i];
                    ob.printf("%s.", pid.вТкст0());
                }
            }
            ob.пишиСтр(imp.ид.вТкст());
            ob.пишиСтр(" (");
            if (imp.mod)
                escapePath(ob, imp.mod.srcfile.вТкст0());
            else
                ob.пишиСтр("???");
            ob.пишиБайт(')');
            foreach (i, имя; imp.имена)
            {
                if (i == 0)
                    ob.пишиБайт(':');
                else
                    ob.пишиБайт(',');
                Идентификатор2 _alias = imp.ники[i];
                if (!_alias)
                {
                    ob.printf("%s", имя.вТкст0());
                    _alias = имя;
                }
                else
                    ob.printf("%s=%s", _alias.вТкст0(), имя.вТкст0());
            }
            if (imp.идНик)
                ob.printf(" -> %s", imp.идНик.вТкст0());
            ob.нс();
        }
        //printf("-Импорт::semantic('%s'), pkg = %p\n", вТкст0(), pkg);
    }

    проц attribSemantic(AttribDeclaration ad)
    {
        if (ad.semanticRun != PASS.init)
            return;
        ad.semanticRun = PASS.semantic;
        Дсимволы* d = ad.include(sc);
        //printf("\tAttribDeclaration::semantic '%s', d = %p\n",вТкст0(), d);
        if (d)
        {
            Scope* sc2 = ad.newScope(sc);
            бул errors;
            for (т_мера i = 0; i < d.dim; i++)
            {
                ДСимвол s = (*d)[i];
                s.dsymbolSemantic(sc2);
                errors |= s.errors;
            }
            ad.errors |= errors;
            if (sc2 != sc)
                sc2.вынь();
        }
        ad.semanticRun = PASS.semanticdone;
    }

    override проц посети(AttribDeclaration atd)
    {
        attribSemantic(atd);
    }

    override проц посети(AnonDeclaration scd)
    {
        //printf("\tAnonDeclaration::semantic %s %p\n", isunion ? "union" : "struct", this);
        assert(sc.родитель);
        auto p = sc.родитель.pastMixin();
        auto ad = p.isAggregateDeclaration();
        if (!ad)
        {
            выведиОшибку(scd.место, "%s can only be a part of an aggregate, not %s `%s`", scd.вид(), p.вид(), p.вТкст0());
            scd.errors = да;
            return;
        }

        if (scd.decl)
        {
            sc = sc.сунь();
            sc.stc &= ~(STC.auto_ | STC.scope_ | STC.static_ | STC.tls | STC.gshared);
            sc.inunion = scd.isunion ? scd : null;
            sc.flags = 0;
            for (т_мера i = 0; i < scd.decl.dim; i++)
            {
                ДСимвол s = (*scd.decl)[i];
                s.dsymbolSemantic(sc);
            }
            sc = sc.вынь();
        }
    }

    override проц посети(PragmaDeclaration pd)
    {
        // Should be merged with PragmaStatement
        //printf("\tPragmaDeclaration::semantic '%s'\n", pd.вТкст0());
        if (глоб2.парамы.mscoff)
        {
            if (pd.идент == Id.linkerDirective)
            {
                if (!pd.args || pd.args.dim != 1)
                    pd.выведиОшибку("one ткст argument expected for pragma(linkerDirective)");
                else
                {
                    auto se = semanticString(sc, (*pd.args)[0], "linker directive");
                    if (!se)
                        goto Lnodecl;
                    (*pd.args)[0] = se;
                    if (глоб2.парамы.verbose)
                        message("linkopt   %.*s", cast(цел)se.len, se.peekString().ptr);
                }
                goto Lnodecl;
            }
        }
        if (pd.идент == Id.msg)
        {
            if (pd.args)
            {
                for (т_мера i = 0; i < pd.args.dim; i++)
                {
                    Выражение e = (*pd.args)[i];
                    sc = sc.startCTFE();
                    e = e.ВыражениеSemantic(sc);
                    e = resolveProperties(sc, e);
                    sc = sc.endCTFE();
                    // pragma(msg) is allowed to contain types as well as Выражения
                    if (e.тип && e.тип.ty == Tvoid)
                    {
                        выведиОшибку(pd.место, "Cannot pass argument `%s` to `pragma msg` because it is `проц`", e.вТкст0());
                        return;
                    }
                    e = ctfeInterpretForPragmaMsg(e);
                    if (e.op == ТОК2.error)
                    {
                        errorSupplemental(pd.место, "while evaluating `pragma(msg, %s)`", (*pd.args)[i].вТкст0());
                        return;
                    }
                    StringExp se = e.вТкстExp();
                    if (se)
                    {
                        se = se.toUTF8(sc);
                        fprintf(stderr, "%.*s", cast(цел)se.len, se.peekString().ptr);
                    }
                    else
                        fprintf(stderr, "%s", e.вТкст0());
                }
                fprintf(stderr, "\n");
            }
            goto Lnodecl;
        }
        else if (pd.идент == Id.lib)
        {
            if (!pd.args || pd.args.dim != 1)
                pd.выведиОшибку("ткст expected for library имя");
            else
            {
                auto se = semanticString(sc, (*pd.args)[0], "library имя");
                if (!se)
                    goto Lnodecl;
                (*pd.args)[0] = se;

                auto имя = se.peekString().xarraydup;
                if (глоб2.парамы.verbose)
                    message("library   %s", имя.ptr);
                if (глоб2.парамы.moduleDeps && !глоб2.парамы.moduleDepsFile)
                {
                    БуфВыв* ob = глоб2.парамы.moduleDeps;
                    Module imod = sc.instantiatingModule();
                    ob.пишиСтр("depsLib ");
                    ob.пишиСтр(imod.toPrettyChars());
                    ob.пишиСтр(" (");
                    escapePath(ob, imod.srcfile.вТкст0());
                    ob.пишиСтр(") : ");
                    ob.пишиСтр(имя);
                    ob.нс();
                }
                mem.xfree(имя.ptr);
            }
            goto Lnodecl;
        }
        else if (pd.идент == Id.startaddress)
        {
            if (!pd.args || pd.args.dim != 1)
                pd.выведиОшибку("function имя expected for start address");
            else
            {
                /* https://issues.dlang.org/show_bug.cgi?ид=11980
                 * resolveProperties and ctfeInterpret call are not necessary.
                 */
                Выражение e = (*pd.args)[0];
                sc = sc.startCTFE();
                e = e.ВыражениеSemantic(sc);
                sc = sc.endCTFE();
                (*pd.args)[0] = e;
                ДСимвол sa = getDsymbol(e);
                if (!sa || !sa.isFuncDeclaration())
                    pd.выведиОшибку("function имя expected for start address, not `%s`", e.вТкст0());
            }
            goto Lnodecl;
        }
        else if (pd.идент == Id.Pinline)
        {
            goto Ldecl;
        }
        else if (pd.идент == Id.mangle)
        {
            if (!pd.args)
                pd.args = new Выражения();
            if (pd.args.dim != 1)
            {
                pd.выведиОшибку("ткст expected for mangled имя");
                pd.args.устДим(1);
                (*pd.args)[0] = new ErrorExp(); // error recovery
                goto Ldecl;
            }

            auto se = semanticString(sc, (*pd.args)[0], "mangled имя");
            if (!se)
                goto Ldecl;
            (*pd.args)[0] = se; // Will be используется later

            if (!se.len)
            {
                pd.выведиОшибку("нуль-length ткст not allowed for mangled имя");
                goto Ldecl;
            }
            if (se.sz != 1)
            {
                pd.выведиОшибку("mangled имя characters can only be of тип `сим`");
                goto Ldecl;
            }
            version (all)
            {
                /* Note: D language specification should not have any assumption about backend
                 * implementation. Ideally pragma(mangle) can прими a ткст of any content.
                 *
                 * Therefore, this validation is compiler implementation specific.
                 */
                auto slice = se.peekString();
                for (т_мера i = 0; i < se.len;)
                {
                    dchar c = slice[i];
                    if (c < 0x80)
                    {
                        if (c.isValidMangling)
                        {
                            ++i;
                            continue;
                        }
                        else
                        {
                            pd.выведиОшибку("сим 0x%02x not allowed in mangled имя", c);
                            break;
                        }
                    }
                    if(auto msg = utf_decodeChar(slice, i, c))
                    {
                        pd.выведиОшибку("%.*s", cast(цел)msg.length, msg.ptr);
                        break;
                    }
                    if (!isUniAlpha(c))
                    {
                        pd.выведиОшибку("сим `0x%04x` not allowed in mangled имя", c);
                        break;
                    }
                }
            }
        }
        else if (pd.идент == Id.crt_constructor || pd.идент == Id.crt_destructor)
        {
            if (pd.args && pd.args.dim != 0)
                pd.выведиОшибку("takes no argument");
            goto Ldecl;
        }
        else if (глоб2.парамы.ignoreUnsupportedPragmas)
        {
            if (глоб2.парамы.verbose)
            {
                /* Print unrecognized pragmas
                 */
                БуфВыв буф;
                буф.пишиСтр(pd.идент.вТкст());
                if (pd.args)
                {
                    const errors_save = глоб2.startGagging();
                    for (т_мера i = 0; i < pd.args.dim; i++)
                    {
                        Выражение e = (*pd.args)[i];
                        sc = sc.startCTFE();
                        e = e.ВыражениеSemantic(sc);
                        e = resolveProperties(sc, e);
                        sc = sc.endCTFE();
                        e = e.ctfeInterpret();
                        if (i == 0)
                            буф.пишиСтр(" (");
                        else
                            буф.пишиБайт(',');
                        буф.пишиСтр(e.вТкст0());
                    }
                    if (pd.args.dim)
                        буф.пишиБайт(')');
                    глоб2.endGagging(errors_save);
                }
                message("pragma    %s", буф.peekChars());
            }
        }
        else
            выведиОшибку(pd.место, "unrecognized `pragma(%s)`", pd.идент.вТкст0());
    Ldecl:
        if (pd.decl)
        {
            Scope* sc2 = pd.newScope(sc);
            for (т_мера i = 0; i < pd.decl.dim; i++)
            {
                ДСимвол s = (*pd.decl)[i];
                s.dsymbolSemantic(sc2);
                if (pd.идент == Id.mangle)
                {
                    assert(pd.args && pd.args.dim == 1);
                    if (auto se = (*pd.args)[0].вТкстExp())
                    {
                        const имя = (cast(ткст)se.peekData()).xarraydup;
                        бцел cnt = setMangleOverride(s, имя);
                        if (cnt > 1)
                            pd.выведиОшибку("can only apply to a single declaration");
                    }
                }
            }
            if (sc2 != sc)
                sc2.вынь();
        }
        return;
    Lnodecl:
        if (pd.decl)
        {
            pd.выведиОшибку("is missing a terminating `;`");
            goto Ldecl;
            // do them anyway, to avoid segfaults.
        }
    }

    override проц посети(StaticIfDeclaration sid)
    {
        attribSemantic(sid);
    }

    override проц посети(StaticForeachDeclaration sfd)
    {
        attribSemantic(sfd);
    }

    private Дсимволы* compileIt(CompileDeclaration cd)
    {
        //printf("CompileDeclaration::compileIt(место = %d) %s\n", cd.место.номстр, cd.exp.вТкст0());
        БуфВыв буф;
        if (выраженияВТкст(буф, sc, cd.exps))
            return null;

        const errors = глоб2.errors;
        const len = буф.length;
        буф.пишиБайт(0);
        const str = буф.извлекиСрез()[0 .. len];
        scope p = new Parser!(ASTCodegen)(cd.место, sc._module, str, нет);
        p.nextToken();

        auto d = p.parseDeclDefs(0);
        if (глоб2.errors != errors)
            return null;

        if (p.token.значение != ТОК2.endOfFile)
        {
            cd.выведиОшибку("incomplete mixin declaration `%s`", str.ptr);
            return null;
        }
        return d;
    }

    /***********************************************************
     * https://dlang.org/spec/module.html#mixin-declaration
     */
    override проц посети(CompileDeclaration cd)
    {
        //printf("CompileDeclaration::semantic()\n");
        if (!cd.compiled)
        {
            cd.decl = compileIt(cd);
            cd.AttribDeclaration.addMember(sc, cd.scopesym);
            cd.compiled = да;

            if (cd._scope && cd.decl)
            {
                for (т_мера i = 0; i < cd.decl.dim; i++)
                {
                    ДСимвол s = (*cd.decl)[i];
                    s.setScope(cd._scope);
                }
            }
        }
        attribSemantic(cd);
    }

    override проц посети(CPPNamespaceDeclaration ns)
    {
        Идентификатор2 identFromSE (StringExp se)
        {
            const sident = se.вТкст0();
            if (!sident.length || !Идентификатор2.isValidIdentifier(sident))
            {
                ns.exp.выведиОшибку("expected valid identifer for C++ namespace but got `%.*s`",
                             cast(цел)sident.length, sident.ptr);
                return null;
            }
            else
                return Идентификатор2.idPool(sident);
        }

        if (ns.идент is null)
        {
            ns.cppnamespace = sc.namespace;
            sc = sc.startCTFE();
            ns.exp = ns.exp.ВыражениеSemantic(sc);
            ns.exp = resolveProperties(sc, ns.exp);
            sc = sc.endCTFE();
            ns.exp = ns.exp.ctfeInterpret();
            // Can be either a кортеж of strings or a ткст itself
            if (auto te = ns.exp.isTupleExp())
            {
                expandTuples(te.exps);
                CPPNamespaceDeclaration current = ns.cppnamespace;
                for (т_мера d = 0; d < te.exps.dim; ++d)
                {
                    auto exp = (*te.exps)[d];
                    auto prev = d ? current : ns.cppnamespace;
                    current = (d + 1) != te.exps.dim
                        ? new CPPNamespaceDeclaration(exp, null)
                        : ns;
                    current.exp = exp;
                    current.cppnamespace = prev;
                    if (auto se = exp.вТкстExp())
                    {
                        current.идент = identFromSE(se);
                        if (current.идент is null)
                            return; // An error happened in `identFromSE`
                    }
                    else
                        ns.exp.выведиОшибку("`%s`: index %d is not a ткст constant, it is a `%s`",
                                     ns.exp.вТкст0(), d, ns.exp.тип.вТкст0());
                }
            }
            else if (auto se = ns.exp.вТкстExp())
                ns.идент = identFromSE(se);
            else
                ns.exp.выведиОшибку("compile time ткст constant (or кортеж) expected, not `%s`",
                             ns.exp.вТкст0());
        }
        if (ns.идент)
            attribSemantic(ns);
    }

    override проц посети(UserAttributeDeclaration uad)
    {
        //printf("UserAttributeDeclaration::semantic() %p\n", this);
        if (uad.decl && !uad._scope)
            uad.ДСимвол.setScope(sc); // for function local symbols
        return attribSemantic(uad);
    }

    override проц посети(StaticAssert sa)
    {
        if (sa.semanticRun < PASS.semanticdone)
            sa.semanticRun = PASS.semanticdone;
    }

    override проц посети(DebugSymbol ds)
    {
        //printf("DebugSymbol::semantic() %s\n", вТкст0());
        if (ds.semanticRun < PASS.semanticdone)
            ds.semanticRun = PASS.semanticdone;
    }

    override проц посети(VersionSymbol vs)
    {
        if (vs.semanticRun < PASS.semanticdone)
            vs.semanticRun = PASS.semanticdone;
    }

    override проц посети(Package pkg)
    {
        if (pkg.semanticRun < PASS.semanticdone)
            pkg.semanticRun = PASS.semanticdone;
    }

    override проц посети(Module m)
    {
        if (m.semanticRun != PASS.init)
            return;
        //printf("+Module::semantic(this = %p, '%s'): родитель = %p\n", this, вТкст0(), родитель);
        m.semanticRun = PASS.semantic;
        // Note that modules get their own scope, from scratch.
        // This is so regardless of where in the syntax a module
        // gets imported, it is unaffected by context.
        Scope* sc = m._scope; // see if already got one from importAll()
        if (!sc)
        {
            Scope.createGlobal(m); // создай root scope
        }

        //printf("Module = %p, компонаж = %d\n", sc.scopesym, sc.компонаж);
        // Pass 1 semantic routines: do public side of the definition
        m.члены.foreachDsymbol( (s)
        {
            //printf("\tModule('%s'): '%s'.dsymbolSemantic()\n", вТкст0(), s.вТкст0());
            s.dsymbolSemantic(sc);
            m.runDeferredSemantic();
        });

        if (m.userAttribDecl)
        {
            m.userAttribDecl.dsymbolSemantic(sc);
        }
        if (!m._scope)
        {
            sc = sc.вынь();
            sc.вынь(); // 2 pops because Scope::createGlobal() created 2
        }
        m.semanticRun = PASS.semanticdone;
        //printf("-Module::semantic(this = %p, '%s'): родитель = %p\n", this, вТкст0(), родитель);
    }

    override проц посети(EnumDeclaration ed)
    {
        //printf("EnumDeclaration::semantic(sd = %p, '%s') %s\n", sc.scopesym, sc.scopesym.вТкст0(), вТкст0());
        //printf("EnumDeclaration::semantic() %p %s\n", this, вТкст0());
        if (ed.semanticRun >= PASS.semanticdone)
            return; // semantic() already completed
        if (ed.semanticRun == PASS.semantic)
        {
            assert(ed.memtype);
            выведиОшибку(ed.место, "circular reference to enum base тип `%s`", ed.memtype.вТкст0());
            ed.errors = да;
            ed.semanticRun = PASS.semanticdone;
            return;
        }
        бцел dprogress_save = Module.dprogress;

        Scope* scx = null;
        if (ed._scope)
        {
            sc = ed._scope;
            scx = ed._scope; // save so we don't make redundant copies
            ed._scope = null;
        }

        if (!sc)
            return;

        ed.родитель = sc.родитель;
        ed.тип = ed.тип.typeSemantic(ed.место, sc);

        ed.защита = sc.защита;
        if (sc.stc & STC.deprecated_)
            ed.isdeprecated = да;
        ed.userAttribDecl = sc.userAttribDecl;
        ed.cppnamespace = sc.namespace;

        ed.semanticRun = PASS.semantic;

        if (!ed.члены && !ed.memtype) // enum идент;
        {
            ed.semanticRun = PASS.semanticdone;
            return;
        }

        if (!ed.symtab)
            ed.symtab = new DsymbolTable();

        /* The separate, and distinct, cases are:
         *  1. enum { ... }
         *  2. enum : memtype { ... }
         *  3. enum идент { ... }
         *  4. enum идент : memtype { ... }
         *  5. enum идент : memtype;
         *  6. enum идент;
         */

        if (ed.memtype)
        {
            ed.memtype = ed.memtype.typeSemantic(ed.место, sc);

            /* Check to see if memtype is forward referenced
             */
            if (auto te = ed.memtype.isTypeEnum())
            {
                EnumDeclaration sym = cast(EnumDeclaration)te.toDsymbol(sc);
                if (!sym.memtype || !sym.члены || !sym.symtab || sym._scope)
                {
                    // memtype is forward referenced, so try again later
                    ed._scope = scx ? scx : sc.копируй();
                    ed._scope.setNoFree();
                    ed._scope._module.addDeferredSemantic(ed);
                    Module.dprogress = dprogress_save;
                    //printf("\tdeferring %s\n", вТкст0());
                    ed.semanticRun = PASS.init;
                    return;
                }
            }
            if (ed.memtype.ty == Tvoid)
            {
                ed.выведиОшибку("base тип must not be `проц`");
                ed.memtype = Тип.terror;
            }
            if (ed.memtype.ty == Terror)
            {
                ed.errors = да;
                // poison all the члены
                ed.члены.foreachDsymbol( (s) { s.errors = да; } );
                ed.semanticRun = PASS.semanticdone;
                return;
            }
        }

        ed.semanticRun = PASS.semanticdone;

        if (!ed.члены) // enum идент : memtype;
            return;

        if (ed.члены.dim == 0)
        {
            ed.выведиОшибку("enum `%s` must have at least one member", ed.вТкст0());
            ed.errors = да;
            return;
        }

        Module.dprogress++;

        Scope* sce;
        if (ed.isAnonymous())
            sce = sc;
        else
        {
            sce = sc.сунь(ed);
            sce.родитель = ed;
        }
        sce = sce.startCTFE();
        sce.setNoFree(); // needed for getMaxMinValue()

        /* Each enum member gets the sce scope
         */
        ed.члены.foreachDsymbol( (s)
        {
            EnumMember em = s.isEnumMember();
            if (em)
                em._scope = sce;
        });

        if (!ed.added)
        {
            /* addMember() is not called when the EnumDeclaration appears as a function инструкция,
             * so we have to do what addMember() does and install the enum члены in the right symbol
             * table
             */
            ScopeDsymbol scopesym = null;
            if (ed.isAnonymous())
            {
                /* Anonymous enum члены get added to enclosing scope.
                 */
                for (Scope* sct = sce; 1; sct = sct.enclosing)
                {
                    assert(sct);
                    if (sct.scopesym)
                    {
                        scopesym = sct.scopesym;
                        if (!sct.scopesym.symtab)
                            sct.scopesym.symtab = new DsymbolTable();
                        break;
                    }
                }
            }
            else
            {
                // Otherwise enum члены are in the EnumDeclaration's symbol table
                scopesym = ed;
            }

            ed.члены.foreachDsymbol( (s)
            {
                EnumMember em = s.isEnumMember();
                if (em)
                {
                    em.ed = ed;
                    em.addMember(sc, scopesym);
                }
            });
        }

        ed.члены.foreachDsymbol( (s)
        {
            EnumMember em = s.isEnumMember();
            if (em)
                em.dsymbolSemantic(em._scope);
        });
        //printf("defaultval = %lld\n", defaultval);

        //if (defaultval) printf("defaultval: %s %s\n", defaultval.вТкст0(), defaultval.тип.вТкст0());
        //printf("члены = %s\n", члены.вТкст0());
    }

    override проц посети(EnumMember em)
    {
        //printf("EnumMember::semantic() %s\n", вТкст0());

        проц errorReturn()
        {
            em.errors = да;
            em.semanticRun = PASS.semanticdone;
        }

        if (em.errors || em.semanticRun >= PASS.semanticdone)
            return;
        if (em.semanticRun == PASS.semantic)
        {
            em.выведиОшибку("circular reference to `enum` member");
            return errorReturn();
        }
        assert(em.ed);

        em.ed.dsymbolSemantic(sc);
        if (em.ed.errors)
            return errorReturn();
        if (em.errors || em.semanticRun >= PASS.semanticdone)
            return;

        if (em._scope)
            sc = em._scope;
        if (!sc)
            return;

        em.semanticRun = PASS.semantic;

        em.защита = em.ed.isAnonymous() ? em.ed.защита : Prot(Prot.Kind.public_);
        em.компонаж = LINK.d;
        em.класс_хранения |= STC.manifest;

        // https://issues.dlang.org/show_bug.cgi?ид=9701
        if (em.ed.isAnonymous())
        {
            if (em.userAttribDecl)
                em.userAttribDecl.userAttribDecl = em.ed.userAttribDecl;
            else
                em.userAttribDecl = em.ed.userAttribDecl;
        }

        // The first enum member is special
        бул first = (em == (*em.ed.члены)[0]);

        if (em.origType)
        {
            em.origType = em.origType.typeSemantic(em.место, sc);
            em.тип = em.origType;
            assert(em.значение); // "тип ид;" is not a valid enum member declaration
        }

        if (em.значение)
        {
            Выражение e = em.значение;
            assert(e.динкаст() == ДИНКАСТ.Выражение);
            e = e.ВыражениеSemantic(sc);
            e = resolveProperties(sc, e);
            e = e.ctfeInterpret();
            if (e.op == ТОК2.error)
                return errorReturn();
            if (first && !em.ed.memtype && !em.ed.isAnonymous())
            {
                em.ed.memtype = e.тип;
                if (em.ed.memtype.ty == Terror)
                {
                    em.ed.errors = да;
                    return errorReturn();
                }
                if (em.ed.memtype.ty != Terror)
                {
                    /* https://issues.dlang.org/show_bug.cgi?ид=11746
                     * All of named enum члены should have same тип
                     * with the first member. If the following члены were referenced
                     * during the first member semantic, their types should be unified.
                     */
                    em.ed.члены.foreachDsymbol( (s)
                    {
                        EnumMember enm = s.isEnumMember();
                        if (!enm || enm == em || enm.semanticRun < PASS.semanticdone || enm.origType)
                            return;

                        //printf("[%d] em = %s, em.semanticRun = %d\n", i, вТкст0(), em.semanticRun);
                        Выражение ev = enm.значение;
                        ev = ev.implicitCastTo(sc, em.ed.memtype);
                        ev = ev.ctfeInterpret();
                        ev = ev.castTo(sc, em.ed.тип);
                        if (ev.op == ТОК2.error)
                            em.ed.errors = да;
                        enm.значение = ev;
                    });

                    if (em.ed.errors)
                    {
                        em.ed.memtype = Тип.terror;
                        return errorReturn();
                    }
                }
            }

            if (em.ed.memtype && !em.origType)
            {
                e = e.implicitCastTo(sc, em.ed.memtype);
                e = e.ctfeInterpret();

                // save origValue for better json output
                em.origValue = e;

                if (!em.ed.isAnonymous())
                {
                    e = e.castTo(sc, em.ed.тип.addMod(e.тип.mod)); // https://issues.dlang.org/show_bug.cgi?ид=12385
                    e = e.ctfeInterpret();
                }
            }
            else if (em.origType)
            {
                e = e.implicitCastTo(sc, em.origType);
                e = e.ctfeInterpret();
                assert(em.ed.isAnonymous());

                // save origValue for better json output
                em.origValue = e;
            }
            em.значение = e;
        }
        else if (first)
        {
            Тип t;
            if (em.ed.memtype)
                t = em.ed.memtype;
            else
            {
                t = Тип.tint32;
                if (!em.ed.isAnonymous())
                    em.ed.memtype = t;
            }
            Выражение e = new IntegerExp(em.место, 0, t);
            e = e.ctfeInterpret();

            // save origValue for better json output
            em.origValue = e;

            if (!em.ed.isAnonymous())
            {
                e = e.castTo(sc, em.ed.тип);
                e = e.ctfeInterpret();
            }
            em.значение = e;
        }
        else
        {
            /* Find the previous enum member,
             * and set this to be the previous значение + 1
             */
            EnumMember emprev = null;
            em.ed.члены.foreachDsymbol( (s)
            {
                if (auto enm = s.isEnumMember())
                {
                    if (enm == em)
                        return 1;       // found
                    emprev = enm;
                }
                return 0;       // continue
            });

            assert(emprev);
            if (emprev.semanticRun < PASS.semanticdone) // if forward reference
                emprev.dsymbolSemantic(emprev._scope); // resolve it
            if (emprev.errors)
                return errorReturn();

            Выражение eprev = emprev.значение;
            // .toHeadMutable() due to https://issues.dlang.org/show_bug.cgi?ид=18645
            Тип tprev = eprev.тип.toHeadMutable().равен(em.ed.тип.toHeadMutable())
                ? em.ed.memtype
                : eprev.тип;

            Выражение emax = tprev.getProperty(em.ed.место, Id.max, 0);
            emax = emax.ВыражениеSemantic(sc);
            emax = emax.ctfeInterpret();

            // Set значение to (eprev + 1).
            // But first check that (eprev != emax)
            assert(eprev);
            Выражение e = new EqualExp(ТОК2.equal, em.место, eprev, emax);
            e = e.ВыражениеSemantic(sc);
            e = e.ctfeInterpret();
            if (e.toInteger())
            {
                em.выведиОшибку("initialization with `%s.%s+1` causes overflow for тип `%s`",
                    emprev.ed.вТкст0(), emprev.вТкст0(), em.ed.memtype.вТкст0());
                return errorReturn();
            }

            // Now set e to (eprev + 1)
            e = new AddExp(em.место, eprev, new IntegerExp(em.место, 1, Тип.tint32));
            e = e.ВыражениеSemantic(sc);
            e = e.castTo(sc, eprev.тип);
            e = e.ctfeInterpret();

            // save origValue (without cast) for better json output
            if (e.op != ТОК2.error) // avoid duplicate diagnostics
            {
                assert(emprev.origValue);
                em.origValue = new AddExp(em.место, emprev.origValue, new IntegerExp(em.место, 1, Тип.tint32));
                em.origValue = em.origValue.ВыражениеSemantic(sc);
                em.origValue = em.origValue.ctfeInterpret();
            }

            if (e.op == ТОК2.error)
                return errorReturn();
            if (e.тип.isfloating())
            {
                // Check that e != eprev (not always да for floats)
                Выражение etest = new EqualExp(ТОК2.equal, em.место, e, eprev);
                etest = etest.ВыражениеSemantic(sc);
                etest = etest.ctfeInterpret();
                if (etest.toInteger())
                {
                    em.выведиОшибку("has inexact значение due to loss of precision");
                    return errorReturn();
                }
            }
            em.значение = e;
        }
        if (!em.origType)
            em.тип = em.значение.тип;

        assert(em.origValue);
        em.semanticRun = PASS.semanticdone;
    }

    override проц посети(TemplateDeclaration tempdecl)
    {
        static if (LOG)
        {
            printf("TemplateDeclaration.dsymbolSemantic(this = %p, ид = '%s')\n", this, tempdecl.идент.вТкст0());
            printf("sc.stc = %llx\n", sc.stc);
            printf("sc.module = %s\n", sc._module.вТкст0());
        }
        if (tempdecl.semanticRun != PASS.init)
            return; // semantic() already run

        if (tempdecl._scope)
        {
            sc = tempdecl._scope;
            tempdecl._scope = null;
        }
        if (!sc)
            return;

        // Remember templates defined in module объект that we need to know about
        if (sc._module && sc._module.идент == Id.объект)
        {
            if (tempdecl.идент == Id.RTInfo)
                Тип.rtinfo = tempdecl;
        }

        /* Remember Scope for later instantiations, but make
         * a копируй since attributes can change.
         */
        if (!tempdecl._scope)
        {
            tempdecl._scope = sc.копируй();
            tempdecl._scope.setNoFree();
        }

        tempdecl.semanticRun = PASS.semantic;

        tempdecl.родитель = sc.родитель;
        tempdecl.защита = sc.защита;
        tempdecl.cppnamespace = sc.namespace;
        tempdecl.статичен_ли = tempdecl.toParent().isModule() || (tempdecl._scope.stc & STC.static_);

        if (!tempdecl.статичен_ли)
        {
            if (auto ad = tempdecl.родитель.pastMixin().isAggregateDeclaration())
                ad.makeNested();
        }

        // Set up scope for parameters
        auto paramsym = new ScopeDsymbol();
        paramsym.родитель = tempdecl.родитель;
        Scope* paramscope = sc.сунь(paramsym);
        paramscope.stc = 0;

        if (глоб2.парамы.doDocComments)
        {
            tempdecl.origParameters = new ПараметрыШаблона(tempdecl.parameters.dim);
            for (т_мера i = 0; i < tempdecl.parameters.dim; i++)
            {
                ПараметрШаблона2 tp = (*tempdecl.parameters)[i];
                (*tempdecl.origParameters)[i] = tp.syntaxCopy();
            }
        }

        for (т_мера i = 0; i < tempdecl.parameters.dim; i++)
        {
            ПараметрШаблона2 tp = (*tempdecl.parameters)[i];
            if (!tp.declareParameter(paramscope))
            {
                выведиОшибку(tp.место, "параметр `%s` multiply defined", tp.идент.вТкст0());
                tempdecl.errors = да;
            }
            if (!tp.tpsemantic(paramscope, tempdecl.parameters))
            {
                tempdecl.errors = да;
            }
            if (i + 1 != tempdecl.parameters.dim && tp.isTemplateTupleParameter())
            {
                tempdecl.выведиОшибку("template кортеж параметр must be last one");
                tempdecl.errors = да;
            }
        }

        /* Calculate ПараметрШаблона2.dependent
         */
        ПараметрыШаблона tparams = ПараметрыШаблона(1);
        for (т_мера i = 0; i < tempdecl.parameters.dim; i++)
        {
            ПараметрШаблона2 tp = (*tempdecl.parameters)[i];
            tparams[0] = tp;

            for (т_мера j = 0; j < tempdecl.parameters.dim; j++)
            {
                // Skip cases like: X(T : T)
                if (i == j)
                    continue;

                if (TemplateTypeParameter ttp = (*tempdecl.parameters)[j].isTemplateTypeParameter())
                {
                    if (reliesOnTident(ttp.specType, &tparams))
                        tp.dependent = да;
                }
                else if (TemplateAliasParameter tap = (*tempdecl.parameters)[j].isTemplateAliasParameter())
                {
                    if (reliesOnTident(tap.specType, &tparams) ||
                        reliesOnTident(тип_ли(tap.specAlias), &tparams))
                    {
                        tp.dependent = да;
                    }
                }
            }
        }

        paramscope.вынь();

        // Compute again
        tempdecl.onemember = null;
        if (tempdecl.члены)
        {
            ДСимвол s;
            if (ДСимвол.oneMembers(tempdecl.члены, &s, tempdecl.идент) && s)
            {
                tempdecl.onemember = s;
                s.родитель = tempdecl;
            }
        }

        /* BUG: should check:
         *  1. template functions must not introduce virtual functions, as they
         *     cannot be accomodated in the vtbl[]
         *  2. templates cannot introduce non-static данные члены (i.e. fields)
         *     as they would change the instance size of the aggregate.
         */

        tempdecl.semanticRun = PASS.semanticdone;
    }

    override проц посети(TemplateInstance ti)
    {
        templateInstanceSemantic(ti, sc, null);
    }

    override проц посети(TemplateMixin tm)
    {
        static if (LOG)
        {
            printf("+TemplateMixin.dsymbolSemantic('%s', this=%p)\n", tm.вТкст0(), tm);
            fflush(stdout);
        }
        if (tm.semanticRun != PASS.init)
        {
            // When a class/struct содержит mixin члены, and is done over
            // because of forward references, never reach here so semanticRun
            // has been сбрось to PASS.init.
            static if (LOG)
            {
                printf("\tsemantic done\n");
            }
            return;
        }
        tm.semanticRun = PASS.semantic;
        static if (LOG)
        {
            printf("\tdo semantic\n");
        }

        Scope* scx = null;
        if (tm._scope)
        {
            sc = tm._scope;
            scx = tm._scope; // save so we don't make redundant copies
            tm._scope = null;
        }

        /* Run semantic on each argument, place результатs in tiargs[],
         * then найди best match template with tiargs
         */
        if (!tm.findTempDecl(sc) || !tm.semanticTiargs(sc) || !tm.findBestMatch(sc, null))
        {
            if (tm.semanticRun == PASS.init) // forward reference had occurred
            {
                //printf("forward reference - deferring\n");
                tm._scope = scx ? scx : sc.копируй();
                tm._scope.setNoFree();
                tm._scope._module.addDeferredSemantic(tm);
                return;
            }

            tm.inst = tm;
            tm.errors = да;
            return; // error recovery
        }

        auto tempdecl = tm.tempdecl.isTemplateDeclaration();
        assert(tempdecl);

        if (!tm.идент)
        {
            /* Assign scope local unique идентификатор, as same as lambdas.
             */
            ткст s = "__mixin";

            if (FuncDeclaration func = sc.родитель.isFuncDeclaration())
            {
                tm.symtab = func.localsymtab;
                if (tm.symtab)
                {
                    // Inside template constraint, symtab is not set yet.
                    goto L1;
                }
            }
            else
            {
                tm.symtab = sc.родитель.isScopeDsymbol().symtab;
            L1:
                assert(tm.symtab);
                tm.идент = Идентификатор2.генерируйИд(s, tm.symtab.len + 1);
                tm.symtab.вставь(tm);
            }
        }

        tm.inst = tm;
        tm.родитель = sc.родитель;

        /* Detect recursive mixin instantiations.
         */
        for (ДСимвол s = tm.родитель; s; s = s.родитель)
        {
            //printf("\ts = '%s'\n", s.вТкст0());
            TemplateMixin tmix = s.isTemplateMixin();
            if (!tmix || tempdecl != tmix.tempdecl)
                continue;

            /* Different argument list lengths happen with variadic args
             */
            if (tm.tiargs.dim != tmix.tiargs.dim)
                continue;

            for (т_мера i = 0; i < tm.tiargs.dim; i++)
            {
                КорневойОбъект o = (*tm.tiargs)[i];
                Тип ta = тип_ли(o);
                Выражение ea = выражение_ли(o);
                ДСимвол sa = isDsymbol(o);
                КорневойОбъект tmo = (*tmix.tiargs)[i];
                if (ta)
                {
                    Тип tmta = тип_ли(tmo);
                    if (!tmta)
                        goto Lcontinue;
                    if (!ta.равен(tmta))
                        goto Lcontinue;
                }
                else if (ea)
                {
                    Выражение tme = выражение_ли(tmo);
                    if (!tme || !ea.равен(tme))
                        goto Lcontinue;
                }
                else if (sa)
                {
                    ДСимвол tmsa = isDsymbol(tmo);
                    if (sa != tmsa)
                        goto Lcontinue;
                }
                else
                    assert(0);
            }
            tm.выведиОшибку("recursive mixin instantiation");
            return;

        Lcontinue:
            continue;
        }

        // Copy the syntax trees from the TemplateDeclaration
        tm.члены = ДСимвол.arraySyntaxCopy(tempdecl.члены);
        if (!tm.члены)
            return;

        tm.symtab = new DsymbolTable();

        for (Scope* sce = sc; 1; sce = sce.enclosing)
        {
            ScopeDsymbol sds = sce.scopesym;
            if (sds)
            {
                sds.importScope(tm, Prot(Prot.Kind.public_));
                break;
            }
        }

        static if (LOG)
        {
            printf("\tcreate scope for template parameters '%s'\n", tm.вТкст0());
        }
        Scope* scy = sc.сунь(tm);
        scy.родитель = tm;

        /* https://issues.dlang.org/show_bug.cgi?ид=930
         *
         * If the template that is to be mixed in is in the scope of a template
         * instance, we have to also declare the тип ники in the new mixin scope.
         */
        auto parentInstance = tempdecl.родитель ? tempdecl.родитель.isTemplateInstance() : null;
        if (parentInstance)
            parentInstance.declareParameters(scy);

        tm.argsym = new ScopeDsymbol();
        tm.argsym.родитель = scy.родитель;
        Scope* argscope = scy.сунь(tm.argsym);

        бцел errorsave = глоб2.errors;

        // Declare each template параметр as an alias for the argument тип
        tm.declareParameters(argscope);

        // Add члены to enclosing scope, as well as this scope
        tm.члены.foreachDsymbol(/*s =>*/ s.addMember(argscope, tm));

        // Do semantic() analysis on template instance члены
        static if (LOG)
        {
            printf("\tdo semantic() on template instance члены '%s'\n", tm.вТкст0());
        }
        Scope* sc2 = argscope.сунь(tm);
        //т_мера deferred_dim = Module.deferred.dim;

         цел nest;
        //printf("%d\n", nest);
        if (++nest > глоб2.recursionLimit)
        {
            глоб2.gag = 0; // ensure error message gets printed
            tm.выведиОшибку("recursive expansion");
            fatal();
        }

        tm.члены.foreachDsymbol(/* s => */s.setScope(sc2) );

        tm.члены.foreachDsymbol(/* s => */s.importAll(sc2) );

        tm.члены.foreachDsymbol(/* s => */s.dsymbolSemantic(sc2) );

        nest--;

        /* In DeclDefs scope, TemplateMixin does not have to handle deferred symbols.
         * Because the члены would already call Module.addDeferredSemantic() for themselves.
         * See Struct, Class, Interface, and EnumDeclaration.dsymbolSemantic().
         */
        //if (!sc.func && Module.deferred.dim > deferred_dim) {}

        AggregateDeclaration ad = tm.toParent().isAggregateDeclaration();
        if (sc.func && !ad)
        {
            tm.semantic2(sc2);
            tm.semantic3(sc2);
        }

        // Give additional context info if error occurred during instantiation
        if (глоб2.errors != errorsave)
        {
            tm.выведиОшибку("error instantiating");
            tm.errors = да;
        }

        sc2.вынь();
        argscope.вынь();
        scy.вынь();

        static if (LOG)
        {
            printf("-TemplateMixin.dsymbolSemantic('%s', this=%p)\n", tm.вТкст0(), tm);
        }
    }

    override проц посети(Nspace ns)
    {
        if (ns.semanticRun != PASS.init)
            return;
        static if (LOG)
        {
            printf("+Nspace::semantic('%s')\n", ns.вТкст0());
        }
        if (ns._scope)
        {
            sc = ns._scope;
            ns._scope = null;
        }
        if (!sc)
            return;

        бул repopulateMembers = нет;
        if (ns.identExp)
        {
            // resolve the namespace идентификатор
            sc = sc.startCTFE();
            Выражение resolved = ns.identExp.ВыражениеSemantic(sc);
            resolved = resolveProperties(sc, resolved);
            sc = sc.endCTFE();
            resolved = resolved.ctfeInterpret();
            StringExp имя = resolved.вТкстExp();
            TupleExp tup = имя ? null : resolved.toTupleExp();
            if (!tup && !имя)
            {
                выведиОшибку(ns.место, "expected ткст Выражение for namespace имя, got `%s`", ns.identExp.вТкст0());
                return;
            }
            ns.identExp = resolved; // we don't need to keep the old AST around
            if (имя)
            {
                ткст идент = имя.вТкст0();
                if (идент.length == 0 || !Идентификатор2.isValidIdentifier(идент))
                {
                    выведиОшибку(ns.место, "expected valid identifer for C++ namespace but got `%.*s`", cast(цел)идент.length, идент.ptr);
                    return;
                }
                ns.идент = Идентификатор2.idPool(идент);
            }
            else
            {
                // создай namespace stack from the кортеж
                Nspace parentns = ns;
                foreach (i, exp; *tup.exps)
                {
                    имя = exp.вТкстExp();
                    if (!имя)
                    {
                        выведиОшибку(ns.место, "expected ткст Выражение for namespace имя, got `%s`", exp.вТкст0());
                        return;
                    }
                    ткст идент = имя.вТкст0();
                    if (идент.length == 0 || !Идентификатор2.isValidIdentifier(идент))
                    {
                        выведиОшибку(ns.место, "expected valid identifer for C++ namespace but got `%.*s`", cast(цел)идент.length, идент.ptr);
                        return;
                    }
                    if (i == 0)
                    {
                        ns.идент = Идентификатор2.idPool(идент);
                    }
                    else
                    {
                        // вставь the new namespace
                        Nspace childns = new Nspace(ns.место, Идентификатор2.idPool(идент), null, parentns.члены);
                        parentns.члены = new Дсимволы;
                        parentns.члены.сунь(childns);
                        parentns = childns;
                        repopulateMembers = да;
                    }
                }
            }
        }

        ns.semanticRun = PASS.semantic;
        ns.родитель = sc.родитель;
        if (ns.члены)
        {
            assert(sc);
            sc = sc.сунь(ns);
            sc.компонаж = LINK.cpp; // note that namespaces imply C++ компонаж
            sc.родитель = ns;
            foreach (s; *ns.члены)
            {
                if (repopulateMembers)
                {
                    s.addMember(sc, sc.scopesym);
                    s.setScope(sc);
                }
                s.importAll(sc);
            }
            foreach (s; *ns.члены)
            {
                static if (LOG)
                {
                    printf("\tmember '%s', вид = '%s'\n", s.вТкст0(), s.вид());
                }
                s.dsymbolSemantic(sc);
            }
            sc.вынь();
        }
        ns.semanticRun = PASS.semanticdone;
        static if (LOG)
        {
            printf("-Nspace::semantic('%s')\n", ns.вТкст0());
        }
    }

    проц funcDeclarationSemantic(FuncDeclaration funcdecl)
    {
        TypeFunction f;
        AggregateDeclaration ad;
        InterfaceDeclaration ид;

        version (none)
        {
            printf("FuncDeclaration::semantic(sc = %p, this = %p, '%s', компонаж = %d)\n", sc, funcdecl, funcdecl.toPrettyChars(), sc.компонаж);
            if (funcdecl.isFuncLiteralDeclaration())
                printf("\tFuncLiteralDeclaration()\n");
            printf("sc.родитель = %s, родитель = %s\n", sc.родитель.вТкст0(), funcdecl.родитель ? funcdecl.родитель.вТкст0() : "");
            printf("тип: %p, %s\n", funcdecl.тип, funcdecl.тип.вТкст0());
        }

        if (funcdecl.semanticRun != PASS.init && funcdecl.isFuncLiteralDeclaration())
        {
            /* Member functions that have return types that are
             * forward references can have semantic() run more than
             * once on them.
             * See test\interface2.d, test20
             */
            return;
        }

        if (funcdecl.semanticRun >= PASS.semanticdone)
            return;
        assert(funcdecl.semanticRun <= PASS.semantic);
        funcdecl.semanticRun = PASS.semantic;

        if (funcdecl._scope)
        {
            sc = funcdecl._scope;
            funcdecl._scope = null;
        }

        if (!sc || funcdecl.errors)
            return;

        funcdecl.cppnamespace = sc.namespace;
        funcdecl.родитель = sc.родитель;
        ДСимвол родитель = funcdecl.toParent();

        funcdecl.foverrides.устДим(0); // сбрось in case semantic() is being retried for this function

        funcdecl.класс_хранения |= sc.stc & ~STC.ref_;
        ad = funcdecl.isThis();
        // Don't nest structs b/c of generated methods which should not access the outer scopes.
        // https://issues.dlang.org/show_bug.cgi?ид=16627
        if (ad && !funcdecl.generated)
        {
            funcdecl.класс_хранения |= ad.класс_хранения & (STC.TYPECTOR | STC.synchronized_);
            ad.makeNested();
        }
        if (sc.func)
            funcdecl.класс_хранения |= sc.func.класс_хранения & STC.disable;
        // Remove префикс storage classes silently.
        if ((funcdecl.класс_хранения & STC.TYPECTOR) && !(ad || funcdecl.isNested()))
            funcdecl.класс_хранения &= ~STC.TYPECTOR;

        //printf("function класс_хранения = x%llx, sc.stc = x%llx, %x\n", класс_хранения, sc.stc, Declaration::isFinal());

        if (sc.flags & SCOPE.compile)
            funcdecl.flags |= FUNCFLAG.compileTimeOnly; // don't emit code for this function

        FuncLiteralDeclaration fld = funcdecl.isFuncLiteralDeclaration();
        if (fld && fld.treq)
        {
            Тип treq = fld.treq;
            assert(treq.nextOf().ty == Tfunction);
            if (treq.ty == Tdelegate)
                fld.tok = ТОК2.delegate_;
            else if (treq.ty == Tpointer && treq.nextOf().ty == Tfunction)
                fld.tok = ТОК2.function_;
            else
                assert(0);
            funcdecl.компонаж = treq.nextOf().toTypeFunction().компонаж;
        }
        else
            funcdecl.компонаж = sc.компонаж;
        funcdecl.inlining = sc.inlining;
        funcdecl.защита = sc.защита;
        funcdecl.userAttribDecl = sc.userAttribDecl;

        if (!funcdecl.originalType)
            funcdecl.originalType = funcdecl.тип.syntaxCopy();
        if (funcdecl.тип.ty != Tfunction)
        {
            if (funcdecl.тип.ty != Terror)
            {
                funcdecl.выведиОшибку("`%s` must be a function instead of `%s`", funcdecl.вТкст0(), funcdecl.тип.вТкст0());
                funcdecl.тип = Тип.terror;
            }
            funcdecl.errors = да;
            return;
        }
        if (!funcdecl.тип.deco)
        {
            sc = sc.сунь();
            sc.stc |= funcdecl.класс_хранения & (STC.disable | STC.deprecated_); // forward to function тип

            TypeFunction tf = funcdecl.тип.toTypeFunction();
            if (sc.func)
            {
                /* If the nesting родитель is  without inference,
                 * then this function defaults to  too.
                 *
                 *  auto foo()  {
                 *    auto bar() {}     // become a weak purity function
                 *    class C {         // nested class
                 *      auto baz() {}   // become a weak purity function
                 *    }
                 *
                 *    static auto boo() {}   // typed as impure
                 *    // Even though, boo cannot call any impure functions.
                 *    // See also Выражение::checkPurity().
                 *  }
                 */
                if (tf.purity == PURE.impure && (funcdecl.isNested() || funcdecl.isThis()))
                {
                    FuncDeclaration fd = null;
                    for (ДСимвол p = funcdecl.toParent2(); p; p = p.toParent2())
                    {
                        if (AggregateDeclaration adx = p.isAggregateDeclaration())
                        {
                            if (adx.isNested())
                                continue;
                            break;
                        }
                        if ((fd = p.isFuncDeclaration()) !is null)
                            break;
                    }

                    /* If the родитель's purity is inferred, then this function's purity needs
                     * to be inferred first.
                     */
                    if (fd && fd.isPureBypassingInference() >= PURE.weak && !funcdecl.isInstantiated())
                    {
                        tf.purity = PURE.fwdref; // default to 
                    }
                }
            }

            if (tf.isref)
                sc.stc |= STC.ref_;
            if (tf.isscope)
                sc.stc |= STC.scope_;
            if (tf.isnothrow)
                sc.stc |= STC.nothrow_;
            if (tf.isnogc)
                sc.stc |= STC.nogc;
            if (tf.isproperty)
                sc.stc |= STC.property;
            if (tf.purity == PURE.fwdref)
                sc.stc |= STC.pure_;
            if (tf.trust != TRUST.default_)
                sc.stc &= ~STC.safeGroup;
            if (tf.trust == TRUST.safe)
                sc.stc |= STC.safe;
            if (tf.trust == TRUST.system)
                sc.stc |= STC.system;
            if (tf.trust == TRUST.trusted)
                sc.stc |= STC.trusted;

            if (funcdecl.isCtorDeclaration())
            {
                sc.flags |= SCOPE.ctor;
                Тип tret = ad.handleType();
                assert(tret);
                tret = tret.addStorageClass(funcdecl.класс_хранения | sc.stc);
                tret = tret.addMod(funcdecl.тип.mod);
                tf.следщ = tret;
                if (ad.isStructDeclaration())
                    sc.stc |= STC.ref_;
            }

            // 'return' on a non-static class member function implies 'scope' as well
            if (ad && ad.isClassDeclaration() && (tf.isreturn || sc.stc & STC.return_) && !(sc.stc & STC.static_))
                sc.stc |= STC.scope_;

            // If 'this' has no pointers, удали 'scope' as it has no meaning
            if (sc.stc & STC.scope_ && ad && ad.isStructDeclaration() && !ad.тип.hasPointers())
            {
                sc.stc &= ~STC.scope_;
                tf.isscope = нет;
            }

            sc.компонаж = funcdecl.компонаж;

            if (!tf.isNaked() && !(funcdecl.isThis() || funcdecl.isNested()))
            {
                БуфВыв буф;
                MODtoBuffer(&буф, tf.mod);
                funcdecl.выведиОшибку("without `this` cannot be `%s`", буф.peekChars());
                tf.mod = 0; // удали qualifiers
            }

            /* Apply const, const, wild and shared storage class
             * to the function тип. Do this before тип semantic.
             */
            auto stc = funcdecl.класс_хранения;
            if (funcdecl.тип.isImmutable())
                stc |= STC.immutable_;
            if (funcdecl.тип.isConst())
                stc |= STC.const_;
            if (funcdecl.тип.isShared() || funcdecl.класс_хранения & STC.synchronized_)
                stc |= STC.shared_;
            if (funcdecl.тип.isWild())
                stc |= STC.wild;
            funcdecl.тип = funcdecl.тип.addSTC(stc);

            funcdecl.тип = funcdecl.тип.typeSemantic(funcdecl.место, sc);
            sc = sc.вынь();
        }
        if (funcdecl.тип.ty != Tfunction)
        {
            if (funcdecl.тип.ty != Terror)
            {
                funcdecl.выведиОшибку("`%s` must be a function instead of `%s`", funcdecl.вТкст0(), funcdecl.тип.вТкст0());
                funcdecl.тип = Тип.terror;
            }
            funcdecl.errors = да;
            return;
        }
        else
        {
            // Merge back function attributes into 'originalType'.
            // It's используется for mangling, ddoc, and json output.
            TypeFunction tfo = funcdecl.originalType.toTypeFunction();
            TypeFunction tfx = funcdecl.тип.toTypeFunction();
            tfo.mod = tfx.mod;
            tfo.isscope = tfx.isscope;
            tfo.isreturninferred = tfx.isreturninferred;
            tfo.isscopeinferred = tfx.isscopeinferred;
            tfo.isref = tfx.isref;
            tfo.isnothrow = tfx.isnothrow;
            tfo.isnogc = tfx.isnogc;
            tfo.isproperty = tfx.isproperty;
            tfo.purity = tfx.purity;
            tfo.trust = tfx.trust;

            funcdecl.класс_хранения &= ~(STC.TYPECTOR | STC.FUNCATTR);
        }

        f = cast(TypeFunction)funcdecl.тип;

        if ((funcdecl.класс_хранения & STC.auto_) && !f.isref && !funcdecl.inferRetType)
            funcdecl.выведиОшибку("storage class `auto` has no effect if return тип is not inferred");

        /* Functions can only be 'scope' if they have a 'this'
         */
        if (f.isscope && !funcdecl.isNested() && !ad)
        {
            funcdecl.выведиОшибку("functions cannot be `scope`");
        }

        if (f.isreturn && !funcdecl.needThis() && !funcdecl.isNested())
        {
            /* Non-static nested functions have a hidden 'this' pointer to which
             * the 'return' applies
             */
            if (sc.scopesym && sc.scopesym.isAggregateDeclaration())
                funcdecl.выведиОшибку("`static` member has no `this` to which `return` can apply");
            else
                выведиОшибку(funcdecl.место, "Top-уровень function `%s` has no `this` to which `return` can apply", funcdecl.вТкст0());
        }

        if (funcdecl.isAbstract() && !funcdecl.isVirtual())
        {
            ткст0 sfunc;
            if (funcdecl.isStatic())
                sfunc = "static";
            else if (funcdecl.защита.вид == Prot.Kind.private_ || funcdecl.защита.вид == Prot.Kind.package_)
                sfunc = защитуВТкст0(funcdecl.защита.вид);
            else
                sfunc = "final";
            funcdecl.выведиОшибку("`%s` functions cannot be `abstract`", sfunc);
        }

        if (funcdecl.isOverride() && !funcdecl.isVirtual() && !funcdecl.isFuncLiteralDeclaration())
        {
            Prot.Kind вид = funcdecl.prot().вид;
            if ((вид == Prot.Kind.private_ || вид == Prot.Kind.package_) && funcdecl.isMember())
                funcdecl.выведиОшибку("`%s` method is not virtual and cannot override", защитуВТкст0(вид));
            else
                funcdecl.выведиОшибку("cannot override a non-virtual function");
        }

        if (funcdecl.isAbstract() && funcdecl.isFinalFunc())
            funcdecl.выведиОшибку("cannot be both `final` and `abstract`");
        version (none)
        {
            if (funcdecl.isAbstract() && funcdecl.fbody)
                funcdecl.выведиОшибку("`abstract` functions cannot have bodies");
        }

        version (none)
        {
            if (funcdecl.isStaticConstructor() || funcdecl.isStaticDestructor())
            {
                if (!funcdecl.isStatic() || funcdecl.тип.nextOf().ty != Tvoid)
                    funcdecl.выведиОшибку("static constructors / destructors must be `static проц`");
                if (f.arguments && f.arguments.dim)
                    funcdecl.выведиОшибку("static constructors / destructors must have empty параметр list");
                // BUG: check for invalid storage classes
            }
        }

        ид = родитель.isInterfaceDeclaration();
        if (ид)
        {
            funcdecl.класс_хранения |= STC.abstract_;
            if (funcdecl.isCtorDeclaration() || funcdecl.isPostBlitDeclaration() || funcdecl.isDtorDeclaration() || funcdecl.isInvariantDeclaration() || funcdecl.isNewDeclaration() || funcdecl.isDelete())
                funcdecl.выведиОшибку("constructors, destructors, postblits, invariants, new and delete functions are not allowed in interface `%s`", ид.вТкст0());
            if (funcdecl.fbody && funcdecl.isVirtual())
                funcdecl.выведиОшибку("function body only allowed in `final` functions in interface `%s`", ид.вТкст0());
        }
        if (UnionDeclaration ud = родитель.isUnionDeclaration())
        {
            if (funcdecl.isPostBlitDeclaration() || funcdecl.isDtorDeclaration() || funcdecl.isInvariantDeclaration())
                funcdecl.выведиОшибку("destructors, postblits and invariants are not allowed in union `%s`", ud.вТкст0());
        }

        if (StructDeclaration sd = родитель.isStructDeclaration())
        {
            if (funcdecl.isCtorDeclaration())
            {
                goto Ldone;
            }
        }

        if (ClassDeclaration cd = родитель.isClassDeclaration())
        {
            родитель = cd = objc.getParent(funcdecl, cd);

            if (funcdecl.isCtorDeclaration())
            {
                goto Ldone;
            }

            if (funcdecl.класс_хранения & STC.abstract_)
                cd.isabstract = Abstract.yes;

            // if static function, do not put in vtbl[]
            if (!funcdecl.isVirtual())
            {
                //printf("\tnot virtual\n");
                goto Ldone;
            }
            // Suppress further errors if the return тип is an error
            if (funcdecl.тип.nextOf() == Тип.terror)
                goto Ldone;

            бул may_override = нет;
            for (т_мера i = 0; i < cd.baseclasses.dim; i++)
            {
                КлассОснова2* b = (*cd.baseclasses)[i];
                ClassDeclaration cbd = b.тип.toBasetype().isClassHandle();
                if (!cbd)
                    continue;
                for (т_мера j = 0; j < cbd.vtbl.dim; j++)
                {
                    FuncDeclaration f2 = cbd.vtbl[j].isFuncDeclaration();
                    if (!f2 || f2.идент != funcdecl.идент)
                        continue;
                    if (cbd.родитель && cbd.родитель.isTemplateInstance())
                    {
                        if (!f2.functionSemantic())
                            goto Ldone;
                    }
                    may_override = да;
                }
            }
            if (may_override && funcdecl.тип.nextOf() is null)
            {
                /* If same имя function exists in base class but 'this' is auto return,
                 * cannot найди index of base class's vtbl[] to override.
                 */
                funcdecl.выведиОшибку("return тип inference is not supported if may override base class function");
            }

            /* Find index of existing function in base class's vtbl[] to override
             * (the index will be the same as in cd's current vtbl[])
             */
            цел vi = cd.baseClass ? funcdecl.findVtblIndex(&cd.baseClass.vtbl, cast(цел)cd.baseClass.vtbl.dim) : -1;

            бул doesoverride = нет;
            switch (vi)
            {
            case -1:
            Lintro:
                /* Didn't найди one, so
                 * This is an 'introducing' function which gets a new
                 * slot in the vtbl[].
                 */

                // Verify this doesn't override previous final function
                if (cd.baseClass)
                {
                    ДСимвол s = cd.baseClass.search(funcdecl.место, funcdecl.идент);
                    if (s)
                    {
                        FuncDeclaration f2 = s.isFuncDeclaration();
                        if (f2)
                        {
                            f2 = f2.overloadExactMatch(funcdecl.тип);
                            if (f2 && f2.isFinalFunc() && f2.prot().вид != Prot.Kind.private_)
                                funcdecl.выведиОшибку("cannot override `final` function `%s`", f2.toPrettyChars());
                        }
                    }
                }

                /* These quirky conditions mimic what VC++ appears to do
                 */
                if (глоб2.парамы.mscoff && cd.classKind == ClassKind.cpp &&
                    cd.baseClass && cd.baseClass.vtbl.dim)
                {
                    /* if overriding an interface function, then this is not
                     * introducing and don't put it in the class vtbl[]
                     */
                    funcdecl.interfaceVirtual = funcdecl.overrideInterface();
                    if (funcdecl.interfaceVirtual)
                    {
                        //printf("\tinterface function %s\n", вТкст0());
                        cd.vtblFinal.сунь(funcdecl);
                        goto Linterfaces;
                    }
                }

                if (funcdecl.isFinalFunc())
                {
                    // Don't check here, as it may override an interface function
                    //if (isOverride())
                    //    выведиОшибку("is marked as override, but does not override any function");
                    cd.vtblFinal.сунь(funcdecl);
                }
                else
                {
                    //printf("\tintroducing function %s\n", funcdecl.вТкст0());
                    funcdecl.introducing = 1;
                    if (cd.classKind == ClassKind.cpp && target.cpp.reverseOverloads)
                    {
                        /* Overloaded functions with same имя are grouped and in reverse order.
                         * Search for first function of overload group, and вставь
                         * funcdecl into vtbl[] immediately before it.
                         */
                        funcdecl.vtblIndex = cast(цел)cd.vtbl.dim;
                        бул found;
                        foreach (i, s; cd.vtbl)
                        {
                            if (found)
                                // the rest get shifted forward
                                ++s.isFuncDeclaration().vtblIndex;
                            else if (s.идент == funcdecl.идент && s.родитель == родитель)
                            {
                                // found first function of overload group
                                funcdecl.vtblIndex = cast(цел)i;
                                found = да;
                                ++s.isFuncDeclaration().vtblIndex;
                            }
                        }
                        cd.vtbl.вставь(funcdecl.vtblIndex, funcdecl);

                        debug foreach (i, s; cd.vtbl)
                        {
                            // a C++ dtor gets its vtblIndex later (and might even be added twice to the vtbl),
                            // e.g. when compiling druntime with a debug compiler, namely with core.stdcpp.exception.
                            if (auto fd = s.isFuncDeclaration())
                                assert(fd.vtblIndex == i ||
                                       (cd.classKind == ClassKind.cpp && fd.isDtorDeclaration) ||
                                       funcdecl.родитель.isInterfaceDeclaration); // interface functions can be in multiple vtbls
                        }
                    }
                    else
                    {
                        // Append to end of vtbl[]
                        vi = cast(цел)cd.vtbl.dim;
                        cd.vtbl.сунь(funcdecl);
                        funcdecl.vtblIndex = vi;
                    }
                }
                break;

            case -2:
                // can't determine because of forward references
                funcdecl.errors = да;
                return;

            default:
                {
                    FuncDeclaration fdv = cd.baseClass.vtbl[vi].isFuncDeclaration();
                    FuncDeclaration fdc = cd.vtbl[vi].isFuncDeclaration();
                    // This function is covariant with fdv

                    if (fdc == funcdecl)
                    {
                        doesoverride = да;
                        break;
                    }

                    if (fdc.toParent() == родитель)
                    {
                        //printf("vi = %d,\tthis = %p %s %s @ [%s]\n\tfdc  = %p %s %s @ [%s]\n\tfdv  = %p %s %s @ [%s]\n",
                        //        vi, this, this.вТкст0(), this.тип.вТкст0(), this.место.вТкст0(),
                        //            fdc,  fdc .вТкст0(), fdc .тип.вТкст0(), fdc .место.вТкст0(),
                        //            fdv,  fdv .вТкст0(), fdv .тип.вТкст0(), fdv .место.вТкст0());

                        // fdc overrides fdv exactly, then this introduces new function.
                        if (fdc.тип.mod == fdv.тип.mod && funcdecl.тип.mod != fdv.тип.mod)
                            goto Lintro;
                    }

                    if (fdv.isDeprecated)
                        deprecation(funcdecl.место, "`%s` is overriding the deprecated method `%s`",
                                    funcdecl.toPrettyChars, fdv.toPrettyChars);

                    // This function overrides fdv
                    if (fdv.isFinalFunc())
                        funcdecl.выведиОшибку("cannot override `final` function `%s`", fdv.toPrettyChars());

                    if (!funcdecl.isOverride())
                    {
                        if (fdv.isFuture())
                        {
                            deprecation(funcdecl.место, "`@__future` base class method `%s` is being overridden by `%s`; rename the latter", fdv.toPrettyChars(), funcdecl.toPrettyChars());
                            // Treat 'this' as an introducing function, giving it a separate hierarchy in the vtbl[]
                            goto Lintro;
                        }
                        else
                        {
                            цел vi2 = funcdecl.findVtblIndex(&cd.baseClass.vtbl, cast(цел)cd.baseClass.vtbl.dim, нет);
                            if (vi2 < 0)
                                // https://issues.dlang.org/show_bug.cgi?ид=17349
                                deprecation(funcdecl.место, "cannot implicitly override base class method `%s` with `%s`; add `override` attribute", fdv.toPrettyChars(), funcdecl.toPrettyChars());
                            else
                                выведиОшибку(funcdecl.место, "cannot implicitly override base class method `%s` with `%s`; add `override` attribute", fdv.toPrettyChars(), funcdecl.toPrettyChars());
                        }
                    }
                    doesoverride = да;
                    if (fdc.toParent() == родитель)
                    {
                        // If both are mixins, or both are not, then error.
                        // If either is not, the one that is not overrides the other.
                        бул thismixin = funcdecl.родитель.isClassDeclaration() !is null;
                        бул fdcmixin = fdc.родитель.isClassDeclaration() !is null;
                        if (thismixin == fdcmixin)
                        {
                            funcdecl.выведиОшибку("multiple overrides of same function");
                        }
                        /*
                         * https://issues.dlang.org/show_bug.cgi?ид=711
                         *
                         * If an overriding method is introduced through a mixin,
                         * we need to update the vtbl so that both methods are
                         * present.
                         */
                        else if (thismixin)
                        {
                            /* if the mixin introduced the overriding method, then reintroduce it
                             * in the vtbl. The initial entry for the mixined method
                             * will be updated at the end of the enclosing `if` block
                             * to point to the current (non-mixined) function.
                             */
                            auto vitmp = cast(цел)cd.vtbl.dim;
                            cd.vtbl.сунь(fdc);
                            fdc.vtblIndex = vitmp;
                        }
                        else if (fdcmixin)
                        {
                            /* if the current overriding function is coming from a
                             * mixined block, then сунь the current function in the
                             * vtbl, but keep the previous (non-mixined) function as
                             * the overriding one.
                             */
                            auto vitmp = cast(цел)cd.vtbl.dim;
                            cd.vtbl.сунь(funcdecl);
                            funcdecl.vtblIndex = vitmp;
                            break;
                        }
                        else // fdc overrides fdv
                        {
                            // this doesn't override any function
                            break;
                        }
                    }
                    cd.vtbl[vi] = funcdecl;
                    funcdecl.vtblIndex = vi;

                    /* Remember which functions this overrides
                     */
                    funcdecl.foverrides.сунь(fdv);

                    /* This works by whenever this function is called,
                     * it actually returns tintro, which gets dynamically
                     * cast to тип. But we know that tintro is a base
                     * of тип, so we could optimize it by not doing a
                     * dynamic cast, but just subtracting the isBaseOf()
                     * смещение if the значение is != null.
                     */

                    if (fdv.tintro)
                        funcdecl.tintro = fdv.tintro;
                    else if (!funcdecl.тип.равен(fdv.тип))
                    {
                        /* Only need to have a tintro if the vptr
                         * offsets differ
                         */
                        цел смещение;
                        if (fdv.тип.nextOf().isBaseOf(funcdecl.тип.nextOf(), &смещение))
                        {
                            funcdecl.tintro = fdv.тип;
                        }
                    }
                    break;
                }
            }

            /* Go through all the interface bases.
             * If this function is covariant with any члены of those interface
             * functions, set the tintro.
             */
        Linterfaces:
            бул foundVtblMatch = нет;

            foreach (b; cd.interfaces)
            {
                vi = funcdecl.findVtblIndex(&b.sym.vtbl, cast(цел)b.sym.vtbl.dim);
                switch (vi)
                {
                case -1:
                    break;

                case -2:
                    // can't determine because of forward references
                    funcdecl.errors = да;
                    return;

                default:
                    {
                        auto fdv = cast(FuncDeclaration)b.sym.vtbl[vi];
                        Тип ti = null;

                        foundVtblMatch = да;

                        /* Remember which functions this overrides
                         */
                        funcdecl.foverrides.сунь(fdv);

                        /* Should we really require 'override' when implementing
                         * an interface function?
                         */
                        //if (!isOverride())
                        //    warning(место, "overrides base class function %s, but is not marked with 'override'", fdv.toPrettyChars());

                        if (fdv.tintro)
                            ti = fdv.tintro;
                        else if (!funcdecl.тип.равен(fdv.тип))
                        {
                            /* Only need to have a tintro if the vptr
                             * offsets differ
                             */
                            цел смещение;
                            if (fdv.тип.nextOf().isBaseOf(funcdecl.тип.nextOf(), &смещение))
                            {
                                ti = fdv.тип;
                            }
                        }
                        if (ti)
                        {
                            if (funcdecl.tintro)
                            {
                                if (!funcdecl.tintro.nextOf().равен(ti.nextOf()) && !funcdecl.tintro.nextOf().isBaseOf(ti.nextOf(), null) && !ti.nextOf().isBaseOf(funcdecl.tintro.nextOf(), null))
                                {
                                    funcdecl.выведиОшибку("incompatible covariant types `%s` and `%s`", funcdecl.tintro.вТкст0(), ti.вТкст0());
                                }
                            }
                            else
                            {
                                funcdecl.tintro = ti;
                            }
                        }
                    }
                }
            }
            if (foundVtblMatch)
            {
                goto L2;
            }

            if (!doesoverride && funcdecl.isOverride() && (funcdecl.тип.nextOf() || !may_override))
            {
                КлассОснова2* bc = null;
                ДСимвол s = null;
                for (т_мера i = 0; i < cd.baseclasses.dim; i++)
                {
                    bc = (*cd.baseclasses)[i];
                    s = bc.sym.search_correct(funcdecl.идент);
                    if (s)
                        break;
                }

                if (s)
                {
                    HdrGenState hgs;
                    БуфВыв буф;

                    auto fd = s.isFuncDeclaration();
                    functionToBufferFull(cast(TypeFunction)(funcdecl.тип), &буф,
                        new Идентификатор2(funcdecl.toPrettyChars()), &hgs, null);
                    ткст0 funcdeclToChars = буф.peekChars();

                    if (fd)
                    {
                        БуфВыв buf1;

                        functionToBufferFull(cast(TypeFunction)(fd.тип), &buf1,
                            new Идентификатор2(fd.toPrettyChars()), &hgs, null);

                        выведиОшибку(funcdecl.место, "function `%s` does not override any function, did you mean to override `%s`?",
                            funcdeclToChars, buf1.peekChars());
                    }
                    else
                    {
                        выведиОшибку(funcdecl.место, "function `%s` does not override any function, did you mean to override %s `%s`?",
                            funcdeclToChars, s.вид, s.toPrettyChars());
                        errorSupplemental(funcdecl.место, "Functions are the only declarations that may be overriden");
                    }
                }
                else
                    funcdecl.выведиОшибку("does not override any function");
            }

        L2:
            objc.setSelector(funcdecl, sc);
            objc.checkLinkage(funcdecl);
            objc.addToClassMethodList(funcdecl, cd);

            /* Go through all the interface bases.
             * Disallow overriding any final functions in the interface(s).
             */
            foreach (b; cd.interfaces)
            {
                if (b.sym)
                {
                    ДСимвол s = search_function(b.sym, funcdecl.идент);
                    if (s)
                    {
                        FuncDeclaration f2 = s.isFuncDeclaration();
                        if (f2)
                        {
                            f2 = f2.overloadExactMatch(funcdecl.тип);
                            if (f2 && f2.isFinalFunc() && f2.prot().вид != Prot.Kind.private_)
                                funcdecl.выведиОшибку("cannot override `final` function `%s.%s`", b.sym.вТкст0(), f2.toPrettyChars());
                        }
                    }
                }
            }

            if (funcdecl.isOverride)
            {
                if (funcdecl.класс_хранения & STC.disable)
                    deprecation(funcdecl.место,
                                "`%s` cannot be annotated with `@disable` because it is overriding a function in the base class",
                                funcdecl.toPrettyChars);
                if (funcdecl.isDeprecated)
                    deprecation(funcdecl.место,
                                "`%s` cannot be marked as `deprecated` because it is overriding a function in the base class",
                                funcdecl.toPrettyChars);
            }

        }
        else if (funcdecl.isOverride() && !родитель.isTemplateInstance())
            funcdecl.выведиОшибку("`override` only applies to class member functions");

        if (auto ti = родитель.isTemplateInstance)
            objc.setSelector(funcdecl, sc);

        objc.validateSelector(funcdecl);
        // Reflect this.тип to f because it could be changed by findVtblIndex
        f = funcdecl.тип.toTypeFunction();

    Ldone:
        if (!funcdecl.fbody && !funcdecl.allowsContractWithoutBody())
            funcdecl.выведиОшибку("`in` and `out` contracts can only appear without a body when they are virtual interface functions or abstract");

        /* Do not allow template instances to add virtual functions
         * to a class.
         */
        if (funcdecl.isVirtual())
        {
            TemplateInstance ti = родитель.isTemplateInstance();
            if (ti)
            {
                // Take care of nested templates
                while (1)
                {
                    TemplateInstance ti2 = ti.tempdecl.родитель.isTemplateInstance();
                    if (!ti2)
                        break;
                    ti = ti2;
                }

                // If it's a member template
                ClassDeclaration cd = ti.tempdecl.isClassMember();
                if (cd)
                {
                    funcdecl.выведиОшибку("cannot use template to add virtual function to class `%s`", cd.вТкст0());
                }
            }
        }

        if (funcdecl.isMain())
            funcdecl.checkDmain();       // Check main() parameters and return тип

        /* Purity and safety can be inferred for some functions by examining
         * the function body.
         */
        if (funcdecl.canInferAttributes(sc))
            funcdecl.initInferAttributes();

        Module.dprogress++;
        funcdecl.semanticRun = PASS.semanticdone;

        /* Save scope for possible later use (if we need the
         * function internals)
         */
        funcdecl._scope = sc.копируй();
        funcdecl._scope.setNoFree();

         бул printedMain = нет; // semantic might run more than once
        if (глоб2.парамы.verbose && !printedMain)
        {
            ткст0 тип = funcdecl.isMain() ? "main" : funcdecl.isWinMain() ? "winmain" : funcdecl.isDllMain() ? "dllmain" : cast(сим*)null;
            Module mod = sc._module;

            if (тип && mod)
            {
                printedMain = да;
                ткст0 имя = ИмяФайла.searchPath(глоб2.path, mod.srcfile.вТкст0(), да);
                message("entry     %-10s\t%s", тип, имя);
            }
        }

        if (funcdecl.fbody && funcdecl.isMain() && sc._module.isRoot())
        {
            // check if `_d_cmain` is defined
            бул cmainTemplateExists()
            {
                auto rootSymbol = sc.search(funcdecl.место, Id.empty, null);
                if (auto moduleSymbol = rootSymbol.search(funcdecl.место, Id.объект))
                    if (moduleSymbol.search(funcdecl.место, Id.CMain))
                        return да;

                return нет;
            }

            // Only mixin `_d_cmain` if it is defined
            if (cmainTemplateExists())
            {
                // add `mixin _d_cmain!();` to the declaring module
                auto tqual = new TypeIdentifier(funcdecl.место, Id.CMain);
                auto tm = new TemplateMixin(funcdecl.место, null, tqual, null);
                sc._module.члены.сунь(tm);
            }

            rootHasMain = sc._module;
        }

        assert(funcdecl.тип.ty != Terror || funcdecl.errors);

        // semantic for parameters' UDAs
        foreach (i; new бцел[0 .. f.parameterList.length])
        {
            Параметр2 param = f.parameterList[i];
            if (param && param.userAttribDecl)
                param.userAttribDecl.dsymbolSemantic(sc);
        }
    }

     /// Do the semantic analysis on the external interface to the function.
    override проц посети(FuncDeclaration funcdecl)
    {
        funcDeclarationSemantic(funcdecl);
    }

    override проц посети(CtorDeclaration ctd)
    {
        //printf("CtorDeclaration::semantic() %s\n", вТкст0());
        if (ctd.semanticRun >= PASS.semanticdone)
            return;
        if (ctd._scope)
        {
            sc = ctd._scope;
            ctd._scope = null;
        }

        ctd.родитель = sc.родитель;
        ДСимвол p = ctd.toParentDecl();
        AggregateDeclaration ad = p.isAggregateDeclaration();
        if (!ad)
        {
            выведиОшибку(ctd.место, "constructor can only be a member of aggregate, not %s `%s`", p.вид(), p.вТкст0());
            ctd.тип = Тип.terror;
            ctd.errors = да;
            return;
        }

        sc = sc.сунь();

        if (sc.stc & STC.static_)
        {
            if (sc.stc & STC.shared_)
                выведиОшибку(ctd.место, "`shared static` has no effect on a constructor inside a `shared static` block. Use `shared static this()`");
            else
                выведиОшибку(ctd.место, "`static` has no effect on a constructor inside a `static` block. Use `static this()`");
        }

        sc.stc &= ~STC.static_; // not a static constructor
        sc.flags |= SCOPE.ctor;

        funcDeclarationSemantic(ctd);

        sc.вынь();

        if (ctd.errors)
            return;

        TypeFunction tf = ctd.тип.toTypeFunction();

        /* See if it's the default constructor
         * But, template constructor should not become a default constructor.
         */
        if (ad && (!ctd.родитель.isTemplateInstance() || ctd.родитель.isTemplateMixin()))
        {
            const dim = tf.parameterList.length;

            if (auto sd = ad.isStructDeclaration())
            {
                if (dim == 0 && tf.parameterList.varargs == ВарАрг.none) // empty default ctor w/o any varargs
                {
                    if (ctd.fbody || !(ctd.класс_хранения & STC.disable))
                    {
                        ctd.выведиОшибку("default constructor for structs only allowed " ~
                            "with `@disable`, no body, and no parameters");
                        ctd.класс_хранения |= STC.disable;
                        ctd.fbody = null;
                    }
                    sd.noDefaultCtor = да;
                }
                else if (dim == 0 && tf.parameterList.varargs != ВарАрг.none) // allow varargs only ctor
                {
                }
                else if (dim && tf.parameterList[0].defaultArg)
                {
                    // if the first параметр has a default argument, then the rest does as well
                    if (ctd.класс_хранения & STC.disable)
                    {
                        ctd.выведиОшибку("is marked `@disable`, so it cannot have default "~
                                  "arguments for all parameters.");
                        errorSupplemental(ctd.место, "Use `@disable this();` if you want to disable default initialization.");
                    }
                    else
                        ctd.выведиОшибку("all parameters have default arguments, "~
                                  "but structs cannot have default constructors.");
                }
                else if ((dim == 1 || (dim > 1 && tf.parameterList[1].defaultArg)))
                {
                    //printf("tf: %s\n", tf.вТкст0());
                    auto param = Параметр2.getNth(tf.parameterList, 0);
                    if (param.классХранения & STC.ref_ && param.тип.mutableOf().unSharedOf() == sd.тип.mutableOf().unSharedOf())
                    {
                        //printf("копируй constructor\n");
                        ctd.isCpCtor = да;
                    }
                }
            }
            else if (dim == 0 && tf.parameterList.varargs == ВарАрг.none)
            {
                ad.defaultCtor = ctd;
            }
        }
    }

    override проц посети(PostBlitDeclaration pbd)
    {
        //printf("PostBlitDeclaration::semantic() %s\n", вТкст0());
        //printf("идент: %s, %s, %p, %p\n", идент.вТкст0(), Id::dtor.вТкст0(), идент, Id::dtor);
        //printf("stc = x%llx\n", sc.stc);
        if (pbd.semanticRun >= PASS.semanticdone)
            return;
        if (pbd._scope)
        {
            sc = pbd._scope;
            pbd._scope = null;
        }

        pbd.родитель = sc.родитель;
        ДСимвол p = pbd.toParent2();
        StructDeclaration ad = p.isStructDeclaration();
        if (!ad)
        {
            выведиОшибку(pbd.место, "postblit can only be a member of struct, not %s `%s`", p.вид(), p.вТкст0());
            pbd.тип = Тип.terror;
            pbd.errors = да;
            return;
        }
        if (pbd.идент == Id.postblit && pbd.semanticRun < PASS.semantic)
            ad.postblits.сунь(pbd);
        if (!pbd.тип)
            pbd.тип = new TypeFunction(СписокПараметров(), Тип.tvoid, LINK.d, pbd.класс_хранения);

        sc = sc.сунь();
        sc.stc &= ~STC.static_; // not static
        sc.компонаж = LINK.d;

        funcDeclarationSemantic(pbd);

        sc.вынь();
    }

    override проц посети(DtorDeclaration dd)
    {
        //printf("DtorDeclaration::semantic() %s\n", вТкст0());
        //printf("идент: %s, %s, %p, %p\n", идент.вТкст0(), Id::dtor.вТкст0(), идент, Id::dtor);
        if (dd.semanticRun >= PASS.semanticdone)
            return;
        if (dd._scope)
        {
            sc = dd._scope;
            dd._scope = null;
        }

        dd.родитель = sc.родитель;
        ДСимвол p = dd.toParent2();
        AggregateDeclaration ad = p.isAggregateDeclaration();
        if (!ad)
        {
            выведиОшибку(dd.место, "destructor can only be a member of aggregate, not %s `%s`", p.вид(), p.вТкст0());
            dd.тип = Тип.terror;
            dd.errors = да;
            return;
        }
        if (dd.идент == Id.dtor && dd.semanticRun < PASS.semantic)
            ad.dtors.сунь(dd);
        if (!dd.тип)
        {
            dd.тип = new TypeFunction(СписокПараметров(), Тип.tvoid, LINK.d, dd.класс_хранения);
            if (ad.classKind == ClassKind.cpp && dd.идент == Id.dtor)
            {
                if (auto cldec = ad.isClassDeclaration())
                {
                    assert (cldec.cppDtorVtblIndex == -1); // double-call check already by dd.тип
                    if (cldec.baseClass && cldec.baseClass.cppDtorVtblIndex != -1)
                    {
                        // override the base virtual
                        cldec.cppDtorVtblIndex = cldec.baseClass.cppDtorVtblIndex;
                    }
                    else if (!dd.isFinal())
                    {
                        // резервируй the dtor slot for the destructor (which we'll создай later)
                        cldec.cppDtorVtblIndex = cast(цел)cldec.vtbl.dim;
                        cldec.vtbl.сунь(dd);
                        if (target.cpp.twoDtorInVtable)
                            cldec.vtbl.сунь(dd); // deleting destructor uses a second slot
                    }
                }
            }
        }

        sc = sc.сунь();
        sc.stc &= ~STC.static_; // not a static destructor
        if (sc.компонаж != LINK.cpp)
            sc.компонаж = LINK.d;

        funcDeclarationSemantic(dd);

        sc.вынь();
    }

    override проц посети(StaticCtorDeclaration scd)
    {
        //printf("StaticCtorDeclaration::semantic()\n");
        if (scd.semanticRun >= PASS.semanticdone)
            return;
        if (scd._scope)
        {
            sc = scd._scope;
            scd._scope = null;
        }

        scd.родитель = sc.родитель;
        ДСимвол p = scd.родитель.pastMixin();
        if (!p.isScopeDsymbol())
        {
            ткст0 s = (scd.isSharedStaticCtorDeclaration() ? "shared " : "");
            выведиОшибку(scd.место, "`%sstatic` constructor can only be member of module/aggregate/template, not %s `%s`", s, p.вид(), p.вТкст0());
            scd.тип = Тип.terror;
            scd.errors = да;
            return;
        }
        if (!scd.тип)
            scd.тип = new TypeFunction(СписокПараметров(), Тип.tvoid, LINK.d, scd.класс_хранения);

        /* If the static ctor appears within a template instantiation,
         * it could get called multiple times by the module constructors
         * for different modules. Thus, protect it with a gate.
         */
        if (scd.isInstantiated() && scd.semanticRun < PASS.semantic)
        {
            /* Add this префикс to the function:
             *      static цел gate;
             *      if (++gate != 1) return;
             * Note that this is not thread safe; should not have threads
             * during static construction.
             */
            auto v = new VarDeclaration(Место.initial, Тип.tint32, Id.gate, null);
            v.класс_хранения = STC.temp | (scd.isSharedStaticCtorDeclaration() ? STC.static_ : STC.tls);

            auto sa = new Инструкции();
            Инструкция2 s = new ExpStatement(Место.initial, v);
            sa.сунь(s);

            Выражение e = new IdentifierExp(Место.initial, v.идент);
            e = new AddAssignExp(Место.initial, e, IntegerExp.literal!(1));
            e = new EqualExp(ТОК2.notEqual, Место.initial, e, IntegerExp.literal!(1));
            s = new IfStatement(Место.initial, null, e, new ReturnStatement(Место.initial, null), null, Место.initial);

            sa.сунь(s);
            if (scd.fbody)
                sa.сунь(scd.fbody);

            scd.fbody = new CompoundStatement(Место.initial, sa);
        }

        funcDeclarationSemantic(scd);

        // We're going to need ModuleInfo
        Module m = scd.getModule();
        if (!m)
            m = sc._module;
        if (m)
        {
            m.needmoduleinfo = 1;
            //printf("module1 %s needs moduleinfo\n", m.вТкст0());
        }
    }

    override проц посети(StaticDtorDeclaration sdd)
    {
        if (sdd.semanticRun >= PASS.semanticdone)
            return;
        if (sdd._scope)
        {
            sc = sdd._scope;
            sdd._scope = null;
        }

        sdd.родитель = sc.родитель;
        ДСимвол p = sdd.родитель.pastMixin();
        if (!p.isScopeDsymbol())
        {
            ткст0 s = (sdd.isSharedStaticDtorDeclaration() ? "shared " : "");
            выведиОшибку(sdd.место, "`%sstatic` destructor can only be member of module/aggregate/template, not %s `%s`", s, p.вид(), p.вТкст0());
            sdd.тип = Тип.terror;
            sdd.errors = да;
            return;
        }
        if (!sdd.тип)
            sdd.тип = new TypeFunction(СписокПараметров(), Тип.tvoid, LINK.d, sdd.класс_хранения);

        /* If the static ctor appears within a template instantiation,
         * it could get called multiple times by the module constructors
         * for different modules. Thus, protect it with a gate.
         */
        if (sdd.isInstantiated() && sdd.semanticRun < PASS.semantic)
        {
            /* Add this префикс to the function:
             *      static цел gate;
             *      if (--gate != 0) return;
             * Increment gate during constructor execution.
             * Note that this is not thread safe; should not have threads
             * during static destruction.
             */
            auto v = new VarDeclaration(Место.initial, Тип.tint32, Id.gate, null);
            v.класс_хранения = STC.temp | (sdd.isSharedStaticDtorDeclaration() ? STC.static_ : STC.tls);

            auto sa = new Инструкции();
            Инструкция2 s = new ExpStatement(Место.initial, v);
            sa.сунь(s);

            Выражение e = new IdentifierExp(Место.initial, v.идент);
            e = new AddAssignExp(Место.initial, e, IntegerExp.literal!(-1));
            e = new EqualExp(ТОК2.notEqual, Место.initial, e, IntegerExp.literal!(0));
            s = new IfStatement(Место.initial, null, e, new ReturnStatement(Место.initial, null), null, Место.initial);

            sa.сунь(s);
            if (sdd.fbody)
                sa.сунь(sdd.fbody);

            sdd.fbody = new CompoundStatement(Место.initial, sa);

            sdd.vgate = v;
        }

        funcDeclarationSemantic(sdd);

        // We're going to need ModuleInfo
        Module m = sdd.getModule();
        if (!m)
            m = sc._module;
        if (m)
        {
            m.needmoduleinfo = 1;
            //printf("module2 %s needs moduleinfo\n", m.вТкст0());
        }
    }

    override проц посети(InvariantDeclaration invd)
    {
        if (invd.semanticRun >= PASS.semanticdone)
            return;
        if (invd._scope)
        {
            sc = invd._scope;
            invd._scope = null;
        }

        invd.родитель = sc.родитель;
        ДСимвол p = invd.родитель.pastMixin();
        AggregateDeclaration ad = p.isAggregateDeclaration();
        if (!ad)
        {
            выведиОшибку(invd.место, "`invariant` can only be a member of aggregate, not %s `%s`", p.вид(), p.вТкст0());
            invd.тип = Тип.terror;
            invd.errors = да;
            return;
        }
        if (invd.идент != Id.classInvariant &&
             invd.semanticRun < PASS.semantic &&
             !ad.isUnionDeclaration()           // users are on their own with union fields
           )
            ad.invs.сунь(invd);
        if (!invd.тип)
            invd.тип = new TypeFunction(СписокПараметров(), Тип.tvoid, LINK.d, invd.класс_хранения);

        sc = sc.сунь();
        sc.stc &= ~STC.static_; // not a static invariant
        sc.stc |= STC.const_; // invariant() is always const
        sc.flags = (sc.flags & ~SCOPE.contract) | SCOPE.invariant_;
        sc.компонаж = LINK.d;

        funcDeclarationSemantic(invd);

        sc.вынь();
    }

    override проц посети(UnitTestDeclaration utd)
    {
        if (utd.semanticRun >= PASS.semanticdone)
            return;
        if (utd._scope)
        {
            sc = utd._scope;
            utd._scope = null;
        }

        utd.защита = sc.защита;

        utd.родитель = sc.родитель;
        ДСимвол p = utd.родитель.pastMixin();
        if (!p.isScopeDsymbol())
        {
            выведиОшибку(utd.место, "`unittest` can only be a member of module/aggregate/template, not %s `%s`", p.вид(), p.вТкст0());
            utd.тип = Тип.terror;
            utd.errors = да;
            return;
        }

        if (глоб2.парамы.useUnitTests)
        {
            if (!utd.тип)
                utd.тип = new TypeFunction(СписокПараметров(), Тип.tvoid, LINK.d, utd.класс_хранения);
            Scope* sc2 = sc.сунь();
            sc2.компонаж = LINK.d;
            funcDeclarationSemantic(utd);
            sc2.вынь();
        }

        version (none)
        {
            // We're going to need ModuleInfo even if the unit tests are not
            // compiled in, because other modules may import this module and refer
            // to this ModuleInfo.
            // (This doesn't make sense to me?)
            Module m = utd.getModule();
            if (!m)
                m = sc._module;
            if (m)
            {
                //printf("module3 %s needs moduleinfo\n", m.вТкст0());
                m.needmoduleinfo = 1;
            }
        }
    }

    override проц посети(NewDeclaration nd)
    {
        //printf("NewDeclaration::semantic()\n");

        // `@disable new();` should not be deprecated
        if (!nd.isDisabled())
        {
            // @@@DEPRECATED_2.091@@@
            // Made an error in 2.087.
            // Should be removed in 2.091
            выведиОшибку(nd.место, "class allocators are obsolete, consider moving the allocation strategy outside of the class");
        }

        if (nd.semanticRun >= PASS.semanticdone)
            return;
        if (nd._scope)
        {
            sc = nd._scope;
            nd._scope = null;
        }

        nd.родитель = sc.родитель;
        ДСимвол p = nd.родитель.pastMixin();
        if (!p.isAggregateDeclaration())
        {
            выведиОшибку(nd.место, "allocator can only be a member of aggregate, not %s `%s`", p.вид(), p.вТкст0());
            nd.тип = Тип.terror;
            nd.errors = да;
            return;
        }
        Тип tret = Тип.tvoid.pointerTo();
        if (!nd.тип)
            nd.тип = new TypeFunction(СписокПараметров(nd.parameters, nd.varargs), tret, LINK.d, nd.класс_хранения);

        nd.тип = nd.тип.typeSemantic(nd.место, sc);

        // allow for `@disable new();` to force users of a тип to use an external allocation strategy
        if (!nd.isDisabled())
        {
            // Check that there is at least one argument of тип т_мера
            TypeFunction tf = nd.тип.toTypeFunction();
            if (tf.parameterList.length < 1)
            {
                nd.выведиОшибку("at least one argument of тип `т_мера` expected");
            }
            else
            {
                Параметр2 fparam = tf.parameterList[0];
                if (!fparam.тип.равен(Тип.tт_мера))
                    nd.выведиОшибку("first argument must be тип `т_мера`, not `%s`", fparam.тип.вТкст0());
            }
        }

        funcDeclarationSemantic(nd);
    }

    /* https://issues.dlang.org/show_bug.cgi?ид=19731
     *
     * Some aggregate member functions might have had
     * semantic 3 ran on them despite being in semantic1
     * (e.g. auto functions); if that is the case, then
     * invariants will not be taken into account for them
     * because at the time of the analysis it would appear
     * as if the struct declaration does not have any
     * invariants. To solve this issue, we need to redo
     * semantic3 on the function declaration.
     */
    private проц reinforceInvariant(AggregateDeclaration ad, Scope* sc)
    {
        // for each member
        for(цел i = 0; i < ad.члены.dim; i++)
        {
            if (!(*ad.члены)[i])
                continue;
            auto fd = (*ad.члены)[i].isFuncDeclaration();
            if (!fd || fd.generated || fd.semanticRun != PASS.semantic3done)
                continue;

            /* if it's a user defined function declaration and semantic3
             * was already performed on it, создай a syntax копируй and
             * redo the first semantic step.
             */
            auto fd_temp = fd.syntaxCopy(null).isFuncDeclaration();
            fd_temp.класс_хранения &= ~STC.auto_; // тип has already been inferred
            if (auto cd = ad.isClassDeclaration())
                cd.vtbl.удали(fd.vtblIndex);
            fd_temp.dsymbolSemantic(sc);
            (*ad.члены)[i] = fd_temp;
        }
    }

    override проц посети(StructDeclaration sd)
    {
        //printf("StructDeclaration::semantic(this=%p, '%s', sizeok = %d)\n", sd, sd.toPrettyChars(), sd.sizeok);

        //static цел count; if (++count == 20) assert(0);

        if (sd.semanticRun >= PASS.semanticdone)
            return;
        цел errors = глоб2.errors;

        //printf("+StructDeclaration::semantic(this=%p, '%s', sizeok = %d)\n", this, toPrettyChars(), sizeok);
        Scope* scx = null;
        if (sd._scope)
        {
            sc = sd._scope;
            scx = sd._scope; // save so we don't make redundant copies
            sd._scope = null;
        }

        if (!sd.родитель)
        {
            assert(sc.родитель && sc.func);
            sd.родитель = sc.родитель;
        }
        assert(sd.родитель && !sd.isAnonymous());

        if (sd.errors)
            sd.тип = Тип.terror;
        if (sd.semanticRun == PASS.init)
            sd.тип = sd.тип.addSTC(sc.stc | sd.класс_хранения);
        sd.тип = sd.тип.typeSemantic(sd.место, sc);
        if (auto ts = sd.тип.isTypeStruct())
            if (ts.sym != sd)
            {
                auto ti = ts.sym.isInstantiated();
                if (ti && isError(ti))
                    ts.sym = sd;
            }

        // Ungag errors when not speculative
        Ungag ungag = sd.ungagSpeculative();

        if (sd.semanticRun == PASS.init)
        {
            sd.защита = sc.защита;

            sd.alignment = sc.alignment();

            sd.класс_хранения |= sc.stc;
            if (sd.класс_хранения & STC.abstract_)
                sd.выведиОшибку("structs, unions cannot be `abstract`");

            sd.userAttribDecl = sc.userAttribDecl;

            if (sc.компонаж == LINK.cpp)
                sd.classKind = ClassKind.cpp;
            sd.cppnamespace = sc.namespace;
        }
        else if (sd.symtab && !scx)
            return;

        sd.semanticRun = PASS.semantic;

        if (!sd.члены) // if opaque declaration
        {
            sd.semanticRun = PASS.semanticdone;
            return;
        }
        if (!sd.symtab)
        {
            sd.symtab = new DsymbolTable();

            sd.члены.foreachDsymbol(/* s => */s.addMember(sc, sd) );
        }

        auto sc2 = sd.newScope(sc);

        /* Set scope so if there are forward references, we still might be able to
         * resolve individual члены like enums.
         */
        sd.члены.foreachDsymbol(/* s => */s.setScope(sc2) );
        sd.члены.foreachDsymbol(/* s => */s.importAll(sc2) );
        sd.члены.foreachDsymbol( (s) { s.dsymbolSemantic(sc2); sd.errors |= s.errors; } );

        if (sd.errors)
            sd.тип = Тип.terror;

        if (!sd.determineFields())
        {
            if (sd.тип.ty != Terror)
            {
                sd.выведиОшибку(sd.место, "circular or forward reference");
                sd.errors = да;
                sd.тип = Тип.terror;
            }

            sc2.вынь();
            sd.semanticRun = PASS.semanticdone;
            return;
        }
        /* Following special member functions creation needs semantic analysis
         * completion of sub-structs in each field types. For example, buildDtor
         * needs to check existence of elaborate dtor in тип of each fields.
         * See the case in compilable/test14838.d
         */
        foreach (v; sd.fields)
        {
            Тип tb = v.тип.baseElemOf();
            if (tb.ty != Tstruct)
                continue;
            auto sdec = (cast(TypeStruct)tb).sym;
            if (sdec.semanticRun >= PASS.semanticdone)
                continue;

            sc2.вынь();

            sd._scope = scx ? scx : sc.копируй();
            sd._scope.setNoFree();
            sd._scope._module.addDeferredSemantic(sd);
            //printf("\tdeferring %s\n", вТкст0());
            return;
        }

        /* Look for special member functions.
         */
        sd.aggNew = cast(NewDeclaration)sd.search(Место.initial, Id.classNew);

        // Look for the constructor
        sd.ctor = sd.searchCtor();

        sd.dtor = buildDtor(sd, sc2);
        sd.tidtor = buildExternDDtor(sd, sc2);
        sd.postblit = buildPostBlit(sd, sc2);
        sd.hasCopyCtor = buildCopyCtor(sd, sc2);

        buildOpAssign(sd, sc2);
        buildOpEquals(sd, sc2);

        if (глоб2.парамы.useTypeInfo && Тип.dtypeinfo)  // these functions are используется for TypeInfo
        {
            sd.xeq = buildXopEquals(sd, sc2);
            sd.xcmp = buildXopCmp(sd, sc2);
            sd.xhash = buildXtoHash(sd, sc2);
        }

        sd.inv = buildInv(sd, sc2);
        if (sd.inv)
            reinforceInvariant(sd, sc2);

        Module.dprogress++;
        sd.semanticRun = PASS.semanticdone;
        //printf("-StructDeclaration::semantic(this=%p, '%s')\n", sd, sd.вТкст0());

        sc2.вынь();

        if (sd.ctor)
        {
            ДСимвол scall = sd.search(Место.initial, Id.call);
            if (scall)
            {
                бцел xerrors = глоб2.startGagging();
                sc = sc.сунь();
                sc.tinst = null;
                sc.minst = null;
                auto fcall = resolveFuncCall(sd.место, sc, scall, null, null, null, FuncResolveFlag.quiet);
                sc = sc.вынь();
                глоб2.endGagging(xerrors);

                if (fcall && fcall.isStatic())
                {
                    sd.выведиОшибку(fcall.место, "`static opCall` is hidden by constructors and can never be called");
                    errorSupplemental(fcall.место, "Please use a factory method instead, or replace all constructors with `static opCall`.");
                }
            }
        }

        if (sd.тип.ty == Tstruct && (cast(TypeStruct)sd.тип).sym != sd)
        {
            // https://issues.dlang.org/show_bug.cgi?ид=19024
            StructDeclaration sym = (cast(TypeStruct)sd.тип).sym;
            version (none)
            {
                printf("this = %p %s\n", sd, sd.вТкст0());
                printf("тип = %d sym = %p, %s\n", sd.тип.ty, sym, sym.toPrettyChars());
            }
            sd.выведиОшибку("already exists at %s. Perhaps in another function with the same имя?", sym.место.вТкст0());
        }

        if (глоб2.errors != errors)
        {
            // The тип is no good.
            sd.тип = Тип.terror;
            sd.errors = да;
            if (sd.deferred)
                sd.deferred.errors = да;
        }

        if (sd.deferred && !глоб2.gag)
        {
            sd.deferred.semantic2(sc);
            sd.deferred.semantic3(sc);
        }
    }

    проц interfaceSemantic(ClassDeclaration cd)
    {
        cd.vtblInterfaces = new КлассыОсновы();
        cd.vtblInterfaces.резервируй(cd.interfaces.length);
        foreach (b; cd.interfaces)
        {
            cd.vtblInterfaces.сунь(b);
            b.copyBaseInterfaces(cd.vtblInterfaces);
        }
    }

    override проц посети(ClassDeclaration cldec)
    {
        //printf("ClassDeclaration.dsymbolSemantic(%s), тип = %p, sizeok = %d, this = %p\n", cldec.вТкст0(), cldec.тип, cldec.sizeok, this);
        //printf("\tparent = %p, '%s'\n", sc.родитель, sc.родитель ? sc.родитель.вТкст0() : "");
        //printf("sc.stc = %x\n", sc.stc);

        //{ static цел n;  if (++n == 20) *(сим*)0=0; }

        if (cldec.semanticRun >= PASS.semanticdone)
            return;
        цел errors = глоб2.errors;

        //printf("+ClassDeclaration.dsymbolSemantic(%s), тип = %p, sizeok = %d, this = %p\n", вТкст0(), тип, sizeok, this);

        Scope* scx = null;
        if (cldec._scope)
        {
            sc = cldec._scope;
            scx = cldec._scope; // save so we don't make redundant copies
            cldec._scope = null;
        }

        if (!cldec.родитель)
        {
            assert(sc.родитель);
            cldec.родитель = sc.родитель;
        }

        if (cldec.errors)
            cldec.тип = Тип.terror;
        cldec.тип = cldec.тип.typeSemantic(cldec.место, sc);
        if (auto tc = cldec.тип.isTypeClass())
            if (tc.sym != cldec)
            {
                auto ti = tc.sym.isInstantiated();
                if (ti && isError(ti))
                    tc.sym = cldec;
            }

        // Ungag errors when not speculative
        Ungag ungag = cldec.ungagSpeculative();

        if (cldec.semanticRun == PASS.init)
        {
            cldec.защита = sc.защита;

            cldec.класс_хранения |= sc.stc;
            if (cldec.класс_хранения & STC.auto_)
                cldec.выведиОшибку("storage class `auto` is invalid when declaring a class, did you mean to use `scope`?");
            if (cldec.класс_хранения & STC.scope_)
                cldec.stack = да;
            if (cldec.класс_хранения & STC.abstract_)
                cldec.isabstract = Abstract.yes;

            cldec.userAttribDecl = sc.userAttribDecl;

            if (sc.компонаж == LINK.cpp)
                cldec.classKind = ClassKind.cpp;
            cldec.cppnamespace = sc.namespace;
            if (sc.компонаж == LINK.objc)
                objc.setObjc(cldec);
        }
        else if (cldec.symtab && !scx)
        {
            return;
        }
        cldec.semanticRun = PASS.semantic;

        if (cldec.baseok < Baseok.done)
        {
            /* https://issues.dlang.org/show_bug.cgi?ид=12078
             * https://issues.dlang.org/show_bug.cgi?ид=12143
             * https://issues.dlang.org/show_bug.cgi?ид=15733
             * While resolving base classes and interfaces, a base may refer
             * the member of this derived class. In that time, if all bases of
             * this class can  be determined, we can go forward the semantc process
             * beyond the Lancestorsdone. To do the recursive semantic analysis,
             * temporarily set and unset `_scope` around exp().
             */
            T resolveBase(T)(lazy T exp)
            {
                if (!scx)
                {
                    scx = sc.копируй();
                    scx.setNoFree();
                }
                static if (!is(T == проц))
                {
                    cldec._scope = scx;
                    auto r = exp();
                    cldec._scope = null;
                    return r;
                }
                else
                {
                    cldec._scope = scx;
                    exp();
                    cldec._scope = null;
                }
            }

            cldec.baseok = Baseok.start;

            // Expand any tuples in baseclasses[]
            for (т_мера i = 0; i < cldec.baseclasses.dim;)
            {
                auto b = (*cldec.baseclasses)[i];
                b.тип = resolveBase(b.тип.typeSemantic(cldec.место, sc));

                Тип tb = b.тип.toBasetype();
                if (auto tup = tb.isTypeTuple())
                {
                    cldec.baseclasses.удали(i);
                    т_мера dim = Параметр2.dim(tup.arguments);
                    for (т_мера j = 0; j < dim; j++)
                    {
                        Параметр2 arg = Параметр2.getNth(tup.arguments, j);
                        b = new КлассОснова2(arg.тип);
                        cldec.baseclasses.вставь(i + j, b);
                    }
                }
                else
                    i++;
            }

            if (cldec.baseok >= Baseok.done)
            {
                //printf("%s already semantic analyzed, semanticRun = %d\n", вТкст0(), semanticRun);
                if (cldec.semanticRun >= PASS.semanticdone)
                    return;
                goto Lancestorsdone;
            }

            // See if there's a base class as first in baseclasses[]
            if (cldec.baseclasses.dim)
            {
                КлассОснова2* b = (*cldec.baseclasses)[0];
                Тип tb = b.тип.toBasetype();
                TypeClass tc = tb.isTypeClass();
                if (!tc)
                {
                    if (b.тип != Тип.terror)
                        cldec.выведиОшибку("base тип must be `class` or `interface`, not `%s`", b.тип.вТкст0());
                    cldec.baseclasses.удали(0);
                    goto L7;
                }
                if (tc.sym.isDeprecated())
                {
                    if (!cldec.isDeprecated())
                    {
                        // Deriving from deprecated class makes this one deprecated too
                        cldec.setDeprecated();
                        tc.checkDeprecated(cldec.место, sc);
                    }
                }
                if (tc.sym.isInterfaceDeclaration())
                    goto L7;

                for (ClassDeclaration cdb = tc.sym; cdb; cdb = cdb.baseClass)
                {
                    if (cdb == cldec)
                    {
                        cldec.выведиОшибку("circular inheritance");
                        cldec.baseclasses.удали(0);
                        goto L7;
                    }
                }

                /* https://issues.dlang.org/show_bug.cgi?ид=11034
                 * Class inheritance hierarchy
                 * and instance size of each classes are orthogonal information.
                 * Therefore, even if tc.sym.sizeof == Sizeok.none,
                 * we need to set baseClass field for class covariance check.
                 */
                cldec.baseClass = tc.sym;
                b.sym = cldec.baseClass;

                if (tc.sym.baseok < Baseok.done)
                    resolveBase(tc.sym.dsymbolSemantic(null)); // Try to resolve forward reference
                if (tc.sym.baseok < Baseok.done)
                {
                    //printf("\ttry later, forward reference of base class %s\n", tc.sym.вТкст0());
                    if (tc.sym._scope)
                        tc.sym._scope._module.addDeferredSemantic(tc.sym);
                    cldec.baseok = Baseok.none;
                }
            }
            L7:
            // Treat the remaining entries in baseclasses as interfaces
            // Check for errors, handle forward references
            бул multiClassError = нет;

            for (т_мера i = (cldec.baseClass ? 1 : 0); i < cldec.baseclasses.dim;)
            {
                КлассОснова2* b = (*cldec.baseclasses)[i];
                Тип tb = b.тип.toBasetype();
                TypeClass tc = tb.isTypeClass();
                if (!tc || !tc.sym.isInterfaceDeclaration())
                {
                    // It's a class
                    if (tc)
                    {
                        if (!multiClassError)
                        {
                            выведиОшибку(cldec.место,"`%s`: multiple class inheritance is not supported." ~
                                  " Use multiple interface inheritance and/or composition.", cldec.toPrettyChars());
                            multiClassError = да;
                        }

                        if (tc.sym.fields.dim)
                            errorSupplemental(cldec.место,"`%s` has fields, consider making it a member of `%s`",
                                              b.тип.вТкст0(), cldec.тип.вТкст0());
                        else
                            errorSupplemental(cldec.место,"`%s` has no fields, consider making it an `interface`",
                                              b.тип.вТкст0());
                    }
                    // It's something else: e.g. `цел` in `class Foo : Bar, цел { ... }`
                    else if (b.тип != Тип.terror)
                    {
                        выведиОшибку(cldec.место,"`%s`: base тип must be `interface`, not `%s`",
                              cldec.toPrettyChars(), b.тип.вТкст0());
                    }
                    cldec.baseclasses.удали(i);
                    continue;
                }

                // Check for duplicate interfaces
                for (т_мера j = (cldec.baseClass ? 1 : 0); j < i; j++)
                {
                    КлассОснова2* b2 = (*cldec.baseclasses)[j];
                    if (b2.sym == tc.sym)
                    {
                        cldec.выведиОшибку("inherits from duplicate interface `%s`", b2.sym.вТкст0());
                        cldec.baseclasses.удали(i);
                        continue;
                    }
                }
                if (tc.sym.isDeprecated())
                {
                    if (!cldec.isDeprecated())
                    {
                        // Deriving from deprecated class makes this one deprecated too
                        cldec.setDeprecated();
                        tc.checkDeprecated(cldec.место, sc);
                    }
                }

                b.sym = tc.sym;

                if (tc.sym.baseok < Baseok.done)
                    resolveBase(tc.sym.dsymbolSemantic(null)); // Try to resolve forward reference
                if (tc.sym.baseok < Baseok.done)
                {
                    //printf("\ttry later, forward reference of base %s\n", tc.sym.вТкст0());
                    if (tc.sym._scope)
                        tc.sym._scope._module.addDeferredSemantic(tc.sym);
                    cldec.baseok = Baseok.none;
                }
                i++;
            }
            if (cldec.baseok == Baseok.none)
            {
                // Forward referencee of one or more bases, try again later
                cldec._scope = scx ? scx : sc.копируй();
                cldec._scope.setNoFree();
                cldec._scope._module.addDeferredSemantic(cldec);
                //printf("\tL%d semantic('%s') failed due to forward references\n", __LINE__, вТкст0());
                return;
            }
            cldec.baseok = Baseok.done;

            if (cldec.classKind == ClassKind.objc || (cldec.baseClass && cldec.baseClass.classKind == ClassKind.objc))
                cldec.classKind = ClassKind.objc; // Objective-C classes do not inherit from Object

            // If no base class, and this is not an Object, use Object as base class
            if (!cldec.baseClass && cldec.идент != Id.Object && cldec.объект && cldec.classKind == ClassKind.d)
            {
                проц badObjectDotD()
                {
                    cldec.выведиОшибку("missing or corrupt объект.d");
                    fatal();
                }

                if (!cldec.объект || cldec.объект.errors)
                    badObjectDotD();

                Тип t = cldec.объект.тип;
                t = t.typeSemantic(cldec.место, sc).toBasetype();
                if (t.ty == Terror)
                    badObjectDotD();
                TypeClass tc = t.isTypeClass();
                assert(tc);

                auto b = new КлассОснова2(tc);
                cldec.baseclasses.shift(b);

                cldec.baseClass = tc.sym;
                assert(!cldec.baseClass.isInterfaceDeclaration());
                b.sym = cldec.baseClass;
            }
            if (cldec.baseClass)
            {
                if (cldec.baseClass.класс_хранения & STC.final_)
                    cldec.выведиОшибку("cannot inherit from class `%s` because it is `final`", cldec.baseClass.вТкст0());

                // Inherit properties from base class
                if (cldec.baseClass.isCOMclass())
                    cldec.com = да;
                if (cldec.baseClass.isCPPclass())
                    cldec.classKind = ClassKind.cpp;
                if (cldec.baseClass.stack)
                    cldec.stack = да;
                cldec.enclosing = cldec.baseClass.enclosing;
                cldec.класс_хранения |= cldec.baseClass.класс_хранения & STC.TYPECTOR;
            }

            cldec.interfaces = cldec.baseclasses.tdata()[(cldec.baseClass ? 1 : 0) .. cldec.baseclasses.dim];
            foreach (b; cldec.interfaces)
            {
                // If this is an interface, and it derives from a COM interface,
                // then this is a COM interface too.
                if (b.sym.isCOMinterface())
                    cldec.com = да;
                if (cldec.classKind == ClassKind.cpp && !b.sym.isCPPinterface())
                {
                    выведиОшибку(cldec.место, "C++ class `%s` cannot implement D interface `%s`",
                        cldec.toPrettyChars(), b.sym.toPrettyChars());
                }
            }
            interfaceSemantic(cldec);
        }
    Lancestorsdone:
        //printf("\tClassDeclaration.dsymbolSemantic(%s) baseok = %d\n", вТкст0(), baseok);

        if (!cldec.члены) // if opaque declaration
        {
            cldec.semanticRun = PASS.semanticdone;
            return;
        }
        if (!cldec.symtab)
        {
            cldec.symtab = new DsymbolTable();

            /* https://issues.dlang.org/show_bug.cgi?ид=12152
             * The semantic analysis of base classes should be finished
             * before the члены semantic analysis of this class, in order to determine
             * vtbl in this class. However if a base class refers the member of this class,
             * it can be resolved as a normal forward reference.
             * Call addMember() and setScope() to make this class члены visible from the base classes.
             */
            cldec.члены.foreachDsymbol(/* s => */s.addMember(sc, cldec) );

            auto sc2 = cldec.newScope(sc);

            /* Set scope so if there are forward references, we still might be able to
             * resolve individual члены like enums.
             */
            cldec.члены.foreachDsymbol(/* s => */s.setScope(sc2) );

            sc2.вынь();
        }

        for (т_мера i = 0; i < cldec.baseclasses.dim; i++)
        {
            КлассОснова2* b = (*cldec.baseclasses)[i];
            Тип tb = b.тип.toBasetype();
            TypeClass tc = tb.isTypeClass();
            if (tc.sym.semanticRun < PASS.semanticdone)
            {
                // Forward referencee of one or more bases, try again later
                cldec._scope = scx ? scx : sc.копируй();
                cldec._scope.setNoFree();
                if (tc.sym._scope)
                    tc.sym._scope._module.addDeferredSemantic(tc.sym);
                cldec._scope._module.addDeferredSemantic(cldec);
                //printf("\tL%d semantic('%s') failed due to forward references\n", __LINE__, вТкст0());
                return;
            }
        }

        if (cldec.baseok == Baseok.done)
        {
            cldec.baseok = Baseok.semanticdone;
            objc.setMetaclass(cldec, sc);

            // initialize vtbl
            if (cldec.baseClass)
            {
                if (cldec.classKind == ClassKind.cpp && cldec.baseClass.vtbl.dim == 0)
                {
                    cldec.выведиОшибку("C++ base class `%s` needs at least one virtual function", cldec.baseClass.вТкст0());
                }

                // Copy vtbl[] from base class
                cldec.vtbl.устДим(cldec.baseClass.vtbl.dim);
                memcpy(cldec.vtbl.tdata(), cldec.baseClass.vtbl.tdata(), (ук).sizeof * cldec.vtbl.dim);

                cldec.vthis = cldec.baseClass.vthis;
                cldec.vthis2 = cldec.baseClass.vthis2;
            }
            else
            {
                // No base class, so this is the root of the class hierarchy
                cldec.vtbl.устДим(0);
                if (cldec.vtblOffset())
                    cldec.vtbl.сунь(cldec); // leave room for classinfo as first member
            }

            /* If this is a nested class, add the hidden 'this'
             * member which is a pointer to the enclosing scope.
             */
            if (cldec.vthis) // if inheriting from nested class
            {
                // Use the base class's 'this' member
                if (cldec.класс_хранения & STC.static_)
                    cldec.выведиОшибку("static class cannot inherit from nested class `%s`", cldec.baseClass.вТкст0());
                if (cldec.toParentLocal() != cldec.baseClass.toParentLocal() &&
                    (!cldec.toParentLocal() ||
                     !cldec.baseClass.toParentLocal().getType() ||
                     !cldec.baseClass.toParentLocal().getType().isBaseOf(cldec.toParentLocal().getType(), null)))
                {
                    if (cldec.toParentLocal())
                    {
                        cldec.выведиОшибку("is nested within `%s`, but super class `%s` is nested within `%s`",
                            cldec.toParentLocal().вТкст0(),
                            cldec.baseClass.вТкст0(),
                            cldec.baseClass.toParentLocal().вТкст0());
                    }
                    else
                    {
                        cldec.выведиОшибку("is not nested, but super class `%s` is nested within `%s`",
                            cldec.baseClass.вТкст0(),
                            cldec.baseClass.toParentLocal().вТкст0());
                    }
                    cldec.enclosing = null;
                }
                if (cldec.vthis2)
                {
                    if (cldec.toParent2() != cldec.baseClass.toParent2() &&
                        (!cldec.toParent2() ||
                         !cldec.baseClass.toParent2().getType() ||
                         !cldec.baseClass.toParent2().getType().isBaseOf(cldec.toParent2().getType(), null)))
                    {
                        if (cldec.toParent2() && cldec.toParent2() != cldec.toParentLocal())
                        {
                            cldec.выведиОшибку("needs the frame pointer of `%s`, but super class `%s` needs the frame pointer of `%s`",
                                cldec.toParent2().вТкст0(),
                                cldec.baseClass.вТкст0(),
                                cldec.baseClass.toParent2().вТкст0());
                        }
                        else
                        {
                            cldec.выведиОшибку("doesn't need a frame pointer, but super class `%s` needs the frame pointer of `%s`",
                                cldec.baseClass.вТкст0(),
                                cldec.baseClass.toParent2().вТкст0());
                        }
                    }
                }
                else
                    cldec.makeNested2();
            }
            else
                cldec.makeNested();
        }

        auto sc2 = cldec.newScope(sc);

        cldec.члены.foreachDsymbol(/* s => */s.importAll(sc2) );

        // Note that члены.dim can grow due to кортеж expansion during semantic()
        cldec.члены.foreachDsymbol(/* s => */s.dsymbolSemantic(sc2) );

        if (!cldec.determineFields())
        {
            assert(cldec.тип == Тип.terror);
            sc2.вынь();
            return;
        }
        /* Following special member functions creation needs semantic analysis
         * completion of sub-structs in each field types.
         */
        foreach (v; cldec.fields)
        {
            Тип tb = v.тип.baseElemOf();
            if (tb.ty != Tstruct)
                continue;
            auto sd = (cast(TypeStruct)tb).sym;
            if (sd.semanticRun >= PASS.semanticdone)
                continue;

            sc2.вынь();

            cldec._scope = scx ? scx : sc.копируй();
            cldec._scope.setNoFree();
            cldec._scope._module.addDeferredSemantic(cldec);
            //printf("\tdeferring %s\n", вТкст0());
            return;
        }

        /* Look for special member functions.
         * They must be in this class, not in a base class.
         */
        // Can be in base class
        cldec.aggNew = cast(NewDeclaration)cldec.search(Место.initial, Id.classNew);

        // Look for the constructor
        cldec.ctor = cldec.searchCtor();

        if (!cldec.ctor && cldec.noDefaultCtor)
        {
            // A class объект is always created by constructor, so this check is legitimate.
            foreach (v; cldec.fields)
            {
                if (v.класс_хранения & STC.nodefaultctor)
                    выведиОшибку(v.место, "field `%s` must be initialized in constructor", v.вТкст0());
            }
        }

        // If this class has no constructor, but base class has a default
        // ctor, создай a constructor:
        //    this() { }
        if (!cldec.ctor && cldec.baseClass && cldec.baseClass.ctor)
        {
            auto fd = resolveFuncCall(cldec.место, sc2, cldec.baseClass.ctor, null, cldec.тип, null, FuncResolveFlag.quiet);
            if (!fd) // try shared base ctor instead
                fd = resolveFuncCall(cldec.место, sc2, cldec.baseClass.ctor, null, cldec.тип.sharedOf, null, FuncResolveFlag.quiet);
            if (fd && !fd.errors)
            {
                //printf("Creating default this(){} for class %s\n", вТкст0());
                auto btf = fd.тип.toTypeFunction();
                auto tf = new TypeFunction(СписокПараметров(), null, LINK.d, fd.класс_хранения);
                tf.mod       = btf.mod;
                tf.purity    = btf.purity;
                tf.isnothrow = btf.isnothrow;
                tf.isnogc    = btf.isnogc;
                tf.trust     = btf.trust;

                auto ctor = new CtorDeclaration(cldec.место, Место.initial, 0, tf);
                ctor.fbody = new CompoundStatement(Место.initial, new Инструкции());

                cldec.члены.сунь(ctor);
                ctor.addMember(sc, cldec);
                ctor.dsymbolSemantic(sc2);

                cldec.ctor = ctor;
                cldec.defaultCtor = ctor;
            }
            else
            {
                cldec.выведиОшибку("cannot implicitly generate a default constructor when base class `%s` is missing a default constructor",
                    cldec.baseClass.toPrettyChars());
            }
        }

        cldec.dtor = buildDtor(cldec, sc2);
        cldec.tidtor = buildExternDDtor(cldec, sc2);

        if (cldec.classKind == ClassKind.cpp && cldec.cppDtorVtblIndex != -1)
        {
            // now we've built the aggregate destructor, we'll make it virtual and assign it to the reserved vtable slot
            cldec.dtor.vtblIndex = cldec.cppDtorVtblIndex;
            cldec.vtbl[cldec.cppDtorVtblIndex] = cldec.dtor;

            if (target.cpp.twoDtorInVtable)
            {
                // TODO: создай a C++ compatible deleting destructor (call out to `operator delete`)
                //       for the moment, we'll call the non-deleting destructor and leak
                cldec.vtbl[cldec.cppDtorVtblIndex + 1] = cldec.dtor;
            }
        }

        if (auto f = hasIdentityOpAssign(cldec, sc2))
        {
            if (!(f.класс_хранения & STC.disable))
                cldec.выведиОшибку(f.место, "identity assignment operator overload is illegal");
        }

        cldec.inv = buildInv(cldec, sc2);
        if (cldec.inv)
            reinforceInvariant(cldec, sc2);

        Module.dprogress++;
        cldec.semanticRun = PASS.semanticdone;
        //printf("-ClassDeclaration.dsymbolSemantic(%s), тип = %p\n", вТкст0(), тип);

        sc2.вынь();

        /* isAbstract() is undecidable in some cases because of circular dependencies.
         * Now that semantic is finished, get a definitive результат, and error if it is not the same.
         */
        if (cldec.isabstract != Abstract.fwdref)    // if evaluated it before completion
        {
            const isabstractsave = cldec.isabstract;
            cldec.isabstract = Abstract.fwdref;
            cldec.isAbstract();               // recalculate
            if (cldec.isabstract != isabstractsave)
            {
                cldec.выведиОшибку("cannot infer `abstract` attribute due to circular dependencies");
            }
        }

        if (cldec.тип.ty == Tclass && (cast(TypeClass)cldec.тип).sym != cldec)
        {
            // https://issues.dlang.org/show_bug.cgi?ид=17492
            ClassDeclaration cd = (cast(TypeClass)cldec.тип).sym;
            version (none)
            {
                printf("this = %p %s\n", cldec, cldec.toPrettyChars());
                printf("тип = %d sym = %p, %s\n", cldec.тип.ty, cd, cd.toPrettyChars());
            }
            cldec.выведиОшибку("already exists at %s. Perhaps in another function with the same имя?", cd.место.вТкст0());
        }

        if (глоб2.errors != errors)
        {
            // The тип is no good.
            cldec.тип = Тип.terror;
            cldec.errors = да;
            if (cldec.deferred)
                cldec.deferred.errors = да;
        }

        // Verify fields of a synchronized class are not public
        if (cldec.класс_хранения & STC.synchronized_)
        {
            foreach (vd; cldec.fields)
            {
                if (!vd.isThisDeclaration() &&
                    !vd.prot().isMoreRestrictiveThan(Prot(Prot.Kind.public_)))
                {
                    vd.выведиОшибку("Field члены of a `synchronized` class cannot be `%s`",
                        защитуВТкст0(vd.prot().вид));
                }
            }
        }

        if (cldec.deferred && !глоб2.gag)
        {
            cldec.deferred.semantic2(sc);
            cldec.deferred.semantic3(sc);
        }
        //printf("-ClassDeclaration.dsymbolSemantic(%s), тип = %p, sizeok = %d, this = %p\n", вТкст0(), тип, sizeok, this);

        // @@@DEPRECATED@@@ https://dlang.org/deprecate.html#scope%20as%20a%20type%20constraint
        // Deprecated in 2.087
        // Make an error in 2.091
        // Don't forget to удали code at https://github.com/dlang/dmd/blob/b2f8274ba76358607fc3297a1e9f361480f9bcf9/src/dmd/dsymbolsem.d#L1032-L1036
        if (0 &&          // deprecation disabled for now to accommodate existing extensive use
            cldec.класс_хранения & STC.scope_)
            deprecation(cldec.место, "`scope` as a тип constraint is deprecated.  Use `scope` at the использование site.");
    }

    override проц посети(InterfaceDeclaration idec)
    {
        /// Возвращает: `да` is this is an анонимный Objective-C metaclass
        static бул isAnonymousMetaclass(InterfaceDeclaration idec)
        {
            return idec.classKind == ClassKind.objc &&
                idec.objc.isMeta &&
                idec.isAnonymous;
        }

        //printf("InterfaceDeclaration.dsymbolSemantic(%s), тип = %p\n", вТкст0(), тип);
        if (idec.semanticRun >= PASS.semanticdone)
            return;
        цел errors = глоб2.errors;

        //printf("+InterfaceDeclaration.dsymbolSemantic(%s), тип = %p\n", вТкст0(), тип);

        Scope* scx = null;
        if (idec._scope)
        {
            sc = idec._scope;
            scx = idec._scope; // save so we don't make redundant copies
            idec._scope = null;
        }

        if (!idec.родитель)
        {
            assert(sc.родитель && sc.func);
            idec.родитель = sc.родитель;
        }
        // Objective-C metaclasses are анонимный
        assert(idec.родитель && !idec.isAnonymous || isAnonymousMetaclass(idec));

        if (idec.errors)
            idec.тип = Тип.terror;
        idec.тип = idec.тип.typeSemantic(idec.место, sc);
        if (idec.тип.ty == Tclass && (cast(TypeClass)idec.тип).sym != idec)
        {
            auto ti = (cast(TypeClass)idec.тип).sym.isInstantiated();
            if (ti && isError(ti))
                (cast(TypeClass)idec.тип).sym = idec;
        }

        // Ungag errors when not speculative
        Ungag ungag = idec.ungagSpeculative();

        if (idec.semanticRun == PASS.init)
        {
            idec.защита = sc.защита;

            idec.класс_хранения |= sc.stc;
            idec.userAttribDecl = sc.userAttribDecl;
        }
        else if (idec.symtab)
        {
            if (idec.sizeok == Sizeok.done || !scx)
            {
                idec.semanticRun = PASS.semanticdone;
                return;
            }
        }
        idec.semanticRun = PASS.semantic;

        if (idec.baseok < Baseok.done)
        {
            T resolveBase(T)(lazy T exp)
            {
                if (!scx)
                {
                    scx = sc.копируй();
                    scx.setNoFree();
                }
                static if (!is(T == проц))
                {
                    idec._scope = scx;
                    auto r = exp();
                    idec._scope = null;
                    return r;
                }
                else
                {
                    idec._scope = scx;
                    exp();
                    idec._scope = null;
                }
            }

            idec.baseok = Baseok.start;

            // Expand any tuples in baseclasses[]
            for (т_мера i = 0; i < idec.baseclasses.dim;)
            {
                auto b = (*idec.baseclasses)[i];
                b.тип = resolveBase(b.тип.typeSemantic(idec.место, sc));

                Тип tb = b.тип.toBasetype();
                if (auto tup = tb.isTypeTuple())
                {
                    idec.baseclasses.удали(i);
                    т_мера dim = Параметр2.dim(tup.arguments);
                    for (т_мера j = 0; j < dim; j++)
                    {
                        Параметр2 arg = Параметр2.getNth(tup.arguments, j);
                        b = new КлассОснова2(arg.тип);
                        idec.baseclasses.вставь(i + j, b);
                    }
                }
                else
                    i++;
            }

            if (idec.baseok >= Baseok.done)
            {
                //printf("%s already semantic analyzed, semanticRun = %d\n", вТкст0(), semanticRun);
                if (idec.semanticRun >= PASS.semanticdone)
                    return;
                goto Lancestorsdone;
            }

            if (!idec.baseclasses.dim && sc.компонаж == LINK.cpp)
                idec.classKind = ClassKind.cpp;
            idec.cppnamespace = sc.namespace;

            if (sc.компонаж == LINK.objc)
            {
                objc.setObjc(idec);
                objc.deprecate(idec);
            }

            // Check for errors, handle forward references
            for (т_мера i = 0; i < idec.baseclasses.dim;)
            {
                КлассОснова2* b = (*idec.baseclasses)[i];
                Тип tb = b.тип.toBasetype();
                TypeClass tc = (tb.ty == Tclass) ? cast(TypeClass)tb : null;
                if (!tc || !tc.sym.isInterfaceDeclaration())
                {
                    if (b.тип != Тип.terror)
                        idec.выведиОшибку("base тип must be `interface`, not `%s`", b.тип.вТкст0());
                    idec.baseclasses.удали(i);
                    continue;
                }

                // Check for duplicate interfaces
                for (т_мера j = 0; j < i; j++)
                {
                    КлассОснова2* b2 = (*idec.baseclasses)[j];
                    if (b2.sym == tc.sym)
                    {
                        idec.выведиОшибку("inherits from duplicate interface `%s`", b2.sym.вТкст0());
                        idec.baseclasses.удали(i);
                        continue;
                    }
                }
                if (tc.sym == idec || idec.isBaseOf2(tc.sym))
                {
                    idec.выведиОшибку("circular inheritance of interface");
                    idec.baseclasses.удали(i);
                    continue;
                }
                if (tc.sym.isDeprecated())
                {
                    if (!idec.isDeprecated())
                    {
                        // Deriving from deprecated interface makes this one deprecated too
                        idec.setDeprecated();
                        tc.checkDeprecated(idec.место, sc);
                    }
                }

                b.sym = tc.sym;

                if (tc.sym.baseok < Baseok.done)
                    resolveBase(tc.sym.dsymbolSemantic(null)); // Try to resolve forward reference
                if (tc.sym.baseok < Baseok.done)
                {
                    //printf("\ttry later, forward reference of base %s\n", tc.sym.вТкст0());
                    if (tc.sym._scope)
                        tc.sym._scope._module.addDeferredSemantic(tc.sym);
                    idec.baseok = Baseok.none;
                }
                i++;
            }
            if (idec.baseok == Baseok.none)
            {
                // Forward referencee of one or more bases, try again later
                idec._scope = scx ? scx : sc.копируй();
                idec._scope.setNoFree();
                idec._scope._module.addDeferredSemantic(idec);
                return;
            }
            idec.baseok = Baseok.done;

            idec.interfaces = idec.baseclasses.tdata()[0 .. idec.baseclasses.dim];
            foreach (b; idec.interfaces)
            {
                // If this is an interface, and it derives from a COM interface,
                // then this is a COM interface too.
                if (b.sym.isCOMinterface())
                    idec.com = да;
                if (b.sym.isCPPinterface())
                    idec.classKind = ClassKind.cpp;
            }

            interfaceSemantic(idec);
        }
    Lancestorsdone:

        if (!idec.члены) // if opaque declaration
        {
            idec.semanticRun = PASS.semanticdone;
            return;
        }
        if (!idec.symtab)
            idec.symtab = new DsymbolTable();

        for (т_мера i = 0; i < idec.baseclasses.dim; i++)
        {
            КлассОснова2* b = (*idec.baseclasses)[i];
            Тип tb = b.тип.toBasetype();
            TypeClass tc = tb.isTypeClass();
            if (tc.sym.semanticRun < PASS.semanticdone)
            {
                // Forward referencee of one or more bases, try again later
                idec._scope = scx ? scx : sc.копируй();
                idec._scope.setNoFree();
                if (tc.sym._scope)
                    tc.sym._scope._module.addDeferredSemantic(tc.sym);
                idec._scope._module.addDeferredSemantic(idec);
                return;
            }
        }

        if (idec.baseok == Baseok.done)
        {
            idec.baseok = Baseok.semanticdone;
            objc.setMetaclass(idec, sc);

            // initialize vtbl
            if (idec.vtblOffset())
                idec.vtbl.сунь(idec); // leave room at vtbl[0] for classinfo

            // Cat together the vtbl[]'s from base interfaces
            foreach (i, b; idec.interfaces)
            {
                // Skip if b has already appeared
                for (т_мера k = 0; k < i; k++)
                {
                    if (b == idec.interfaces[k])
                        goto Lcontinue;
                }

                // Copy vtbl[] from base class
                if (b.sym.vtblOffset())
                {
                    т_мера d = b.sym.vtbl.dim;
                    if (d > 1)
                    {
                        idec.vtbl.суньСрез(b.sym.vtbl[1 .. d]);
                    }
                }
                else
                {
                    idec.vtbl.приставь(&b.sym.vtbl);
                }
            }
        }
      Lcontinue:
        idec.члены.foreachDsymbol(/* s => */s.addMember(sc, idec) );

        auto sc2 = idec.newScope(sc);

        /* Set scope so if there are forward references, we still might be able to
         * resolve individual члены like enums.
         */
        idec.члены.foreachDsymbol(/* s => */s.setScope(sc2) );

        idec.члены.foreachDsymbol(/* s => */s.importAll(sc2) );

        idec.члены.foreachDsymbol(/* s => */s.dsymbolSemantic(sc2) );

        Module.dprogress++;
        idec.semanticRun = PASS.semanticdone;
        //printf("-InterfaceDeclaration.dsymbolSemantic(%s), тип = %p\n", вТкст0(), тип);

        sc2.вынь();

        if (глоб2.errors != errors)
        {
            // The тип is no good.
            idec.тип = Тип.terror;
        }

        version (none)
        {
            if (тип.ty == Tclass && (cast(TypeClass)idec.тип).sym != idec)
            {
                printf("this = %p %s\n", idec, idec.вТкст0());
                printf("тип = %d sym = %p\n", idec.тип.ty, (cast(TypeClass)idec.тип).sym);
            }
        }
        assert(idec.тип.ty != Tclass || (cast(TypeClass)idec.тип).sym == idec);

        // @@@DEPRECATED@@@https://dlang.org/deprecate.html#scope%20as%20a%20type%20constraint
        // Deprecated in 2.087
        // Remove in 2.091
        // Don't forget to удали code at https://github.com/dlang/dmd/blob/b2f8274ba76358607fc3297a1e9f361480f9bcf9/src/dmd/dsymbolsem.d#L1032-L1036
        if (idec.класс_хранения & STC.scope_)
            deprecation(idec.место, "`scope` as a тип constraint is deprecated.  Use `scope` at the использование site.");
    }
}

проц templateInstanceSemantic(TemplateInstance tempinst, Scope* sc, Выражения* fargs)
{
    //printf("[%s] TemplateInstance.dsymbolSemantic('%s', this=%p, gag = %d, sc = %p)\n", tempinst.место.вТкст0(), tempinst.вТкст0(), tempinst, глоб2.gag, sc);
    version (none)
    {
        for (ДСимвол s = tempinst; s; s = s.родитель)
        {
            printf("\t%s\n", s.вТкст0());
        }
        printf("Scope\n");
        for (Scope* scx = sc; scx; scx = scx.enclosing)
        {
            printf("\t%s родитель %s\n", scx._module ? scx._module.вТкст0() : "null", scx.родитель ? scx.родитель.вТкст0() : "null");
        }
    }

    static if (LOG)
    {
        printf("\n+TemplateInstance.dsymbolSemantic('%s', this=%p)\n", tempinst.вТкст0(), tempinst);
    }
    if (tempinst.inst) // if semantic() was already run
    {
        static if (LOG)
        {
            printf("-TemplateInstance.dsymbolSemantic('%s', this=%p) already run\n", inst.вТкст0(), tempinst.inst);
        }
        return;
    }
    if (tempinst.semanticRun != PASS.init)
    {
        static if (LOG)
        {
            printf("Recursive template expansion\n");
        }
        auto ungag = Ungag(глоб2.gag);
        if (!tempinst.gagged)
            глоб2.gag = 0;
        tempinst.выведиОшибку(tempinst.место, "recursive template expansion");
        if (tempinst.gagged)
            tempinst.semanticRun = PASS.init;
        else
            tempinst.inst = tempinst;
        tempinst.errors = да;
        return;
    }

    // Get the enclosing template instance from the scope tinst
    tempinst.tinst = sc.tinst;

    // Get the instantiating module from the scope minst
    tempinst.minst = sc.minst;
    // https://issues.dlang.org/show_bug.cgi?ид=10920
    // If the enclosing function is non-root symbol,
    // this instance should be speculative.
    if (!tempinst.tinst && sc.func && sc.func.inNonRoot())
    {
        tempinst.minst = null;
    }

    tempinst.gagged = (глоб2.gag > 0);

    tempinst.semanticRun = PASS.semantic;

    static if (LOG)
    {
        printf("\tdo semantic\n");
    }
    /* Find template declaration first,
     * then run semantic on each argument (place результатs in tiargs[]),
     * last найди most specialized template from overload list/set.
     */
    if (!tempinst.findTempDecl(sc, null) || !tempinst.semanticTiargs(sc) || !tempinst.findBestMatch(sc, fargs))
    {
    Lerror:
        if (tempinst.gagged)
        {
            // https://issues.dlang.org/show_bug.cgi?ид=13220
            // Roll back status for later semantic re-running
            tempinst.semanticRun = PASS.init;
        }
        else
            tempinst.inst = tempinst;
        tempinst.errors = да;
        return;
    }
    TemplateDeclaration tempdecl = tempinst.tempdecl.isTemplateDeclaration();
    assert(tempdecl);

    // If tempdecl is a mixin, disallow it
    if (tempdecl.ismixin)
    {
        tempinst.выведиОшибку("mixin templates are not regular templates");
        goto Lerror;
    }

    tempinst.hasNestedArgs(tempinst.tiargs, tempdecl.статичен_ли);
    if (tempinst.errors)
        goto Lerror;

    // Copy the tempdecl namespace (not the scope one)
    tempinst.cppnamespace = tempdecl.cppnamespace;
    if (tempinst.cppnamespace)
        tempinst.cppnamespace.dsymbolSemantic(sc);

    /* See if there is an existing TemplateInstantiation that already
     * implements the typeargs. If so, just refer to that one instead.
     */
    tempinst.inst = tempdecl.findExistingInstance(tempinst, fargs);
    TemplateInstance errinst = null;
    if (!tempinst.inst)
    {
        // So, we need to implement 'this' instance.
    }
    else if (tempinst.inst.gagged && !tempinst.gagged && tempinst.inst.errors)
    {
        // If the first instantiation had failed, re-run semantic,
        // so that error messages are shown.
        errinst = tempinst.inst;
    }
    else
    {
        // It's a match
        tempinst.родитель = tempinst.inst.родитель;
        tempinst.errors = tempinst.inst.errors;

        // If both this and the previous instantiation were gagged,
        // use the number of errors that happened last time.
        глоб2.errors += tempinst.errors;
        глоб2.gaggedErrors += tempinst.errors;

        // If the first instantiation was gagged, but this is not:
        if (tempinst.inst.gagged)
        {
            // It had succeeded, mark it is a non-gagged instantiation,
            // and reuse it.
            tempinst.inst.gagged = tempinst.gagged;
        }

        tempinst.tnext = tempinst.inst.tnext;
        tempinst.inst.tnext = tempinst;

        /* A module can have explicit template instance and its alias
         * in module scope (e,g, `alias Base64 = Base64Impl!('+', '/');`).
         * If the first instantiation 'inst' had happened in non-root module,
         * compiler can assume that its instantiated code would be included
         * in the separately compiled obj/lib файл (e.g. phobos.lib).
         *
         * However, if 'this' second instantiation happened in root module,
         * compiler might need to invoke its codegen
         * (https://issues.dlang.org/show_bug.cgi?ид=2500 & https://issues.dlang.org/show_bug.cgi?ид=2644).
         * But whole import graph is not determined until all semantic pass finished,
         * so 'inst' should conservatively finish the semantic3 pass for the codegen.
         */
        if (tempinst.minst && tempinst.minst.isRoot() && !(tempinst.inst.minst && tempinst.inst.minst.isRoot()))
        {
            /* Swap the position of 'inst' and 'this' in the instantiation graph.
             * Then, the primary instance `inst` will be changed to a root instance.
             *
             * Before:
             *  non-root -> A!() -> B!()[inst] -> C!()
             *                      |
             *  root     -> D!() -> B!()[this]
             *
             * After:
             *  non-root -> A!() -> B!()[this]
             *                      |
             *  root     -> D!() -> B!()[inst] -> C!()
             */
            Module mi = tempinst.minst;
            TemplateInstance ti = tempinst.tinst;
            tempinst.minst = tempinst.inst.minst;
            tempinst.tinst = tempinst.inst.tinst;
            tempinst.inst.minst = mi;
            tempinst.inst.tinst = ti;

            if (tempinst.minst) // if inst was not speculative
            {
                /* Add 'inst' once again to the root module члены[], then the
                 * instance члены will get codegen chances.
                 */
                tempinst.inst.appendToModuleMember();
            }
        }

        // modules imported by an existing instance should be added to the module
        // that instantiates the instance.
        if (tempinst.minst)
            foreach(imp; tempinst.inst.importedModules)
                if (!tempinst.minst.aimports.содержит(imp))
                    tempinst.minst.aimports.сунь(imp);

        static if (LOG)
        {
            printf("\tit's a match with instance %p, %d\n", tempinst.inst, tempinst.inst.semanticRun);
        }
        return;
    }
    static if (LOG)
    {
        printf("\timplement template instance %s '%s'\n", tempdecl.родитель.вТкст0(), tempinst.вТкст0());
        printf("\ttempdecl %s\n", tempdecl.вТкст0());
    }
    бцел errorsave = глоб2.errors;

    tempinst.inst = tempinst;
    tempinst.родитель = tempinst.enclosing ? tempinst.enclosing : tempdecl.родитель;
    //printf("родитель = '%s'\n", родитель.вид());

    TemplateInstance tempdecl_instance_idx = tempdecl.addInstance(tempinst);

    //getIdent();

    // Store the place we added it to in target_symbol_list(_idx) so we can
    // удали it later if we encounter an error.
    Дсимволы* target_symbol_list = tempinst.appendToModuleMember();
    т_мера target_symbol_list_idx = target_symbol_list ? target_symbol_list.dim - 1 : 0;

    // Copy the syntax trees from the TemplateDeclaration
    tempinst.члены = ДСимвол.arraySyntaxCopy(tempdecl.члены);

    // resolve TemplateThisParameter
    for (т_мера i = 0; i < tempdecl.parameters.dim; i++)
    {
        if ((*tempdecl.parameters)[i].isTemplateThisParameter() is null)
            continue;
        Тип t = тип_ли((*tempinst.tiargs)[i]);
        assert(t);
        if (КлассХранения stc = ModToStc(t.mod))
        {
            //printf("t = %s, stc = x%llx\n", t.вТкст0(), stc);
            auto s = new Дсимволы();
            s.сунь(new StorageClassDeclaration(stc, tempinst.члены));
            tempinst.члены = s;
        }
        break;
    }

    // Create our own scope for the template parameters
    Scope* _scope = tempdecl._scope;
    if (tempdecl.semanticRun == PASS.init)
    {
        tempinst.выведиОшибку("template instantiation `%s` forward references template declaration `%s`", tempinst.вТкст0(), tempdecl.вТкст0());
        return;
    }

    static if (LOG)
    {
        printf("\tcreate scope for template parameters '%s'\n", tempinst.вТкст0());
    }
    tempinst.argsym = new ScopeDsymbol();
    tempinst.argsym.родитель = _scope.родитель;
    _scope = _scope.сунь(tempinst.argsym);
    _scope.tinst = tempinst;
    _scope.minst = tempinst.minst;
    //scope.stc = 0;

    // Declare each template параметр as an alias for the argument тип
    Scope* paramscope = _scope.сунь();
    paramscope.stc = 0;
    paramscope.защита = Prot(Prot.Kind.public_); // https://issues.dlang.org/show_bug.cgi?ид=14169
                                              // template parameters should be public
    tempinst.declareParameters(paramscope);
    paramscope.вынь();

    // Add члены of template instance to template instance symbol table
    //родитель = scope.scopesym;
    tempinst.symtab = new DsymbolTable();

    tempinst.члены.foreachDsymbol( (s)
    {
        static if (LOG)
        {
            printf("\t adding member '%s' %p вид %s to '%s'\n", s.вТкст0(), s, s.вид(), tempinst.вТкст0());
        }
        s.addMember(_scope, tempinst);
    });

    static if (LOG)
    {
        printf("adding члены done\n");
    }

    /* See if there is only one member of template instance, and that
     * member has the same имя as the template instance.
     * If so, this template instance becomes an alias for that member.
     */
    //printf("члены.dim = %d\n", члены.dim);
    if (tempinst.члены.dim)
    {
        ДСимвол s;
        if (ДСимвол.oneMembers(tempinst.члены, &s, tempdecl.идент) && s)
        {
            //printf("tempdecl.идент = %s, s = '%s'\n", tempdecl.идент.вТкст0(), s.вид(), s.toPrettyChars());
            //printf("setting aliasdecl\n");
            tempinst.aliasdecl = s;
        }
    }

    /* If function template declaration
     */
    if (fargs && tempinst.aliasdecl)
    {
        if (auto fd = tempinst.aliasdecl.isFuncDeclaration())
        {
            /* Transmit fargs to тип so that TypeFunction.dsymbolSemantic() can
             * resolve any "auto ref" storage classes.
             */
            if (fd.тип)
                if (auto tf = fd.тип.isTypeFunction())
                    tf.fargs = fargs;
        }
    }

    // Do semantic() analysis on template instance члены
    static if (LOG)
    {
        printf("\tdo semantic() on template instance члены '%s'\n", tempinst.вТкст0());
    }
    Scope* sc2;
    sc2 = _scope.сунь(tempinst);
    //printf("enclosing = %d, sc.родитель = %s\n", tempinst.enclosing, sc.родитель.вТкст0());
    sc2.родитель = tempinst;
    sc2.tinst = tempinst;
    sc2.minst = tempinst.minst;
    tempinst.tryExpandMembers(sc2);

    tempinst.semanticRun = PASS.semanticdone;

    /* ConditionalDeclaration may introduce eponymous declaration,
     * so we should найди it once again after semantic.
     */
    if (tempinst.члены.dim)
    {
        ДСимвол s;
        if (ДСимвол.oneMembers(tempinst.члены, &s, tempdecl.идент) && s)
        {
            if (!tempinst.aliasdecl || tempinst.aliasdecl != s)
            {
                //printf("tempdecl.идент = %s, s = '%s'\n", tempdecl.идент.вТкст0(), s.вид(), s.toPrettyChars());
                //printf("setting aliasdecl 2\n");
                tempinst.aliasdecl = s;
            }
        }
    }

    if (глоб2.errors != errorsave)
        goto Laftersemantic;

    /* If any of the instantiation члены didn't get semantic() run
     * on them due to forward references, we cannot run semantic2()
     * or semantic3() yet.
     */
    {
        бул found_deferred_ad = нет;
        for (т_мера i = 0; i < Module.deferred.dim; i++)
        {
            ДСимвол sd = Module.deferred[i];
            AggregateDeclaration ad = sd.isAggregateDeclaration();
            if (ad && ad.родитель && ad.родитель.isTemplateInstance())
            {
                //printf("deferred template aggregate: %s %s\n",
                //        sd.родитель.вТкст0(), sd.вТкст0());
                found_deferred_ad = да;
                if (ad.родитель == tempinst)
                {
                    ad.deferred = tempinst;
                    break;
                }
            }
        }
        if (found_deferred_ad || Module.deferred.dim)
            goto Laftersemantic;
    }

    /* The problem is when to parse the инициализатор for a variable.
     * Perhaps VarDeclaration.dsymbolSemantic() should do it like it does
     * for initializers inside a function.
     */
    //if (sc.родитель.isFuncDeclaration())
    {
        /* https://issues.dlang.org/show_bug.cgi?ид=782
         * this has problems if the classes this depends on
         * are forward referenced. Find a way to defer semantic()
         * on this template.
         */
        tempinst.semantic2(sc2);
    }
    if (глоб2.errors != errorsave)
        goto Laftersemantic;

    if ((sc.func || (sc.flags & SCOPE.fullinst)) && !tempinst.tinst)
    {
        /* If a template is instantiated inside function, the whole instantiation
         * should be done at that position. But, immediate running semantic3 of
         * dependent templates may cause unresolved forward reference.
         * https://issues.dlang.org/show_bug.cgi?ид=9050
         * To avoid the issue, don't run semantic3 until semantic and semantic2 done.
         */
        TemplateInstances deferred;
        tempinst.deferred = &deferred;

        //printf("Run semantic3 on %s\n", вТкст0());
        tempinst.trySemantic3(sc2);

        for (т_мера i = 0; i < deferred.dim; i++)
        {
            //printf("+ run deferred semantic3 on %s\n", deferred[i].вТкст0());
            deferred[i].semantic3(null);
        }

        tempinst.deferred = null;
    }
    else if (tempinst.tinst)
    {
        бул doSemantic3 = нет;
        FuncDeclaration fd;
        if (tempinst.aliasdecl)
            fd = tempinst.aliasdecl.toAlias2().isFuncDeclaration();

        if (fd)
        {
            /* Template function instantiation should run semantic3 immediately
             * for attribute inference.
             */
            scope fld = fd.isFuncLiteralDeclaration();
            if (fld && fld.tok == ТОК2.reserved)
                doSemantic3 = да;
            else if (sc.func)
                doSemantic3 = да;
        }
        else if (sc.func)
        {
            /* A lambda function in template arguments might capture the
             * instantiated scope context. For the correct context inference,
             * all instantiated functions should run the semantic3 immediately.
             * See also compilable/test14973.d
             */
            foreach (oarg; tempinst.tdtypes)
            {
                auto s = getDsymbol(oarg);
                if (!s)
                    continue;

                if (auto td = s.isTemplateDeclaration())
                {
                    if (!td.literal)
                        continue;
                    assert(td.члены && td.члены.dim == 1);
                    s = (*td.члены)[0];
                }
                if (auto fld = s.isFuncLiteralDeclaration())
                {
                    if (fld.tok == ТОК2.reserved)
                    {
                        doSemantic3 = да;
                        break;
                    }
                }
            }
            //printf("[%s] %s doSemantic3 = %d\n", место.вТкст0(), вТкст0(), doSemantic3);
        }
        if (doSemantic3)
            tempinst.trySemantic3(sc2);

        TemplateInstance ti = tempinst.tinst;
        цел nest = 0;
        while (ti && !ti.deferred && ti.tinst)
        {
            ti = ti.tinst;
            if (++nest > глоб2.recursionLimit)
            {
                глоб2.gag = 0; // ensure error message gets printed
                tempinst.выведиОшибку("recursive expansion");
                fatal();
            }
        }
        if (ti && ti.deferred)
        {
            //printf("deferred semantic3 of %p %s, ti = %s, ti.deferred = %p\n", this, вТкст0(), ti.вТкст0());
            for (т_мера i = 0;; i++)
            {
                if (i == ti.deferred.dim)
                {
                    ti.deferred.сунь(tempinst);
                    break;
                }
                if ((*ti.deferred)[i] == tempinst)
                    break;
            }
        }
    }

    if (tempinst.aliasdecl)
    {
        /* https://issues.dlang.org/show_bug.cgi?ид=13816
         * AliasDeclaration tries to resolve forward reference
         * twice (See inuse check in AliasDeclaration.toAlias()). It's
         * necessary to resolve mutual references of instantiated symbols, but
         * it will left a да recursive alias in кортеж declaration - an
         * AliasDeclaration A refers TupleDeclaration B, and B содержит A
         * in its elements.  To correctly make it an error, we strictly need to
         * resolve the alias of eponymous member.
         */
        tempinst.aliasdecl = tempinst.aliasdecl.toAlias2();
    }

Laftersemantic:
    sc2.вынь();
    _scope.вынь();

    // Give additional context info if error occurred during instantiation
    if (глоб2.errors != errorsave)
    {
        if (!tempinst.errors)
        {
            if (!tempdecl.literal)
                tempinst.выведиОшибку(tempinst.место, "error instantiating");
            if (tempinst.tinst)
                tempinst.tinst.printInstantiationTrace();
        }
        tempinst.errors = да;
        if (tempinst.gagged)
        {
            // Errors are gagged, so удали the template instance from the
            // instance/symbol lists we added it to and сбрось our state to
            // finish clean and so we can try to instantiate it again later
            // (see https://issues.dlang.org/show_bug.cgi?ид=4302 and https://issues.dlang.org/show_bug.cgi?ид=6602).
            tempdecl.removeInstance(tempdecl_instance_idx);
            if (target_symbol_list)
            {
                // Because we added 'this' in the last position above, we
                // should be able to удали it without messing other indices up.
                assert((*target_symbol_list)[target_symbol_list_idx] == tempinst);
                target_symbol_list.удали(target_symbol_list_idx);
                tempinst.memberOf = null;                    // no longer a member
            }
            tempinst.semanticRun = PASS.init;
            tempinst.inst = null;
            tempinst.symtab = null;
        }
    }
    else if (errinst)
    {
        /* https://issues.dlang.org/show_bug.cgi?ид=14541
         * If the previous gagged instance had failed by
         * circular references, currrent "error reproduction instantiation"
         * might succeed, because of the difference of instantiated context.
         * On such case, the cached error instance needs to be overridden by the
         * succeeded instance.
         */
        //printf("replaceInstance()\n");
        assert(errinst.errors);
        auto ti1 = TemplateInstanceBox(errinst);
        tempdecl.instances.удали(ti1);

        auto ti2 = TemplateInstanceBox(tempinst);
        tempdecl.instances[ti2] = tempinst;
    }

    static if (LOG)
    {
        printf("-TemplateInstance.dsymbolSemantic('%s', this=%p)\n", вТкст0(), this);
    }
}

// function используется to perform semantic on AliasDeclaration
проц aliasSemantic(AliasDeclaration ds, Scope* sc)
{
    //printf("AliasDeclaration::semantic() %s\n", ds.вТкст0());

    // TypeTraits needs to know if it's located in an AliasDeclaration
    sc.flags |= SCOPE.alias_;
    scope(exit)
        sc.flags &= ~SCOPE.alias_;

    if (ds.aliassym)
    {
        auto fd = ds.aliassym.isFuncLiteralDeclaration();
        auto td = ds.aliassym.isTemplateDeclaration();
        if (fd || td && td.literal)
        {
            if (fd && fd.semanticRun >= PASS.semanticdone)
                return;

            Выражение e = new FuncExp(ds.место, ds.aliassym);
            e = e.ВыражениеSemantic(sc);
            if (e.op == ТОК2.function_)
            {
                FuncExp fe = cast(FuncExp)e;
                ds.aliassym = fe.td ? cast(ДСимвол)fe.td : fe.fd;
            }
            else
            {
                ds.aliassym = null;
                ds.тип = Тип.terror;
            }
            return;
        }

        if (ds.aliassym.isTemplateInstance())
            ds.aliassym.dsymbolSemantic(sc);
        return;
    }
    ds.inuse = 1;

    // Given:
    //  alias foo.bar.abc def;
    // it is not knowable from the syntax whether this is an alias
    // for a тип or an alias for a symbol. It is up to the semantic()
    // pass to distinguish.
    // If it is a тип, then тип is set and getType() will return that
    // тип. If it is a symbol, then aliassym is set and тип is NULL -
    // toAlias() will return aliasssym.

    бцел errors = глоб2.errors;
    Тип oldtype = ds.тип;

    // Ungag errors when not instantiated DeclDefs scope alias
    auto ungag = Ungag(глоб2.gag);
    //printf("%s родитель = %s, gag = %d, instantiated = %d\n", вТкст0(), родитель, глоб2.gag, isInstantiated());
    if (ds.родитель && глоб2.gag && !ds.isInstantiated() && !ds.toParent2().isFuncDeclaration())
    {
        //printf("%s тип = %s\n", toPrettyChars(), тип.вТкст0());
        глоб2.gag = 0;
    }

    // https://issues.dlang.org/show_bug.cgi?ид=18480
    // Detect `alias sym = sym;` to prevent creating loops in overload overnext lists.
    // Selective imports are allowed to alias to the same имя `import mod : sym=sym`.
    if (ds.тип.ty == Tident && !ds._import)
    {
        auto tident = cast(TypeIdentifier)ds.тип;
        if (tident.идент is ds.идент && !tident.idents.dim)
        {
            выведиОшибку(ds.место, "`alias %s = %s;` cannot alias itself, use a qualified имя to создай an overload set",
                ds.идент.вТкст0(), tident.идент.вТкст0());
            ds.тип = Тип.terror;
        }
    }
    /* This section is needed because Тип.resolve() will:
     *   const x = 3;
     *   alias y = x;
     * try to convert идентификатор x to 3.
     */
    auto s = ds.тип.toDsymbol(sc);
    if (errors != глоб2.errors)
    {
        s = null;
        ds.тип = Тип.terror;
    }
    if (s && s == ds)
    {
        ds.выведиОшибку("cannot resolve");
        s = null;
        ds.тип = Тип.terror;
    }
    if (!s || !s.isEnumMember())
    {
        Тип t;
        Выражение e;
        Scope* sc2 = sc;
        if (ds.класс_хранения & (STC.ref_ | STC.nothrow_ | STC.nogc | STC.pure_ | STC.disable))
        {
            // For 'ref' to be attached to function types, and picked
            // up by Тип.resolve(), it has to go into sc.
            sc2 = sc.сунь();
            sc2.stc |= ds.класс_хранения & (STC.ref_ | STC.nothrow_ | STC.nogc | STC.pure_ | STC.shared_ | STC.disable);
        }
        ds.тип = ds.тип.addSTC(ds.класс_хранения);
        ds.тип.resolve(ds.место, sc2, &e, &t, &s);
        if (sc2 != sc)
            sc2.вынь();

        if (e)  // Try to convert Выражение to ДСимвол
        {
            s = getDsymbol(e);
            if (!s)
            {
                if (e.op != ТОК2.error)
                    ds.выведиОшибку("cannot alias an Выражение `%s`", e.вТкст0());
                t = Тип.terror;
            }
        }
        ds.тип = t;
    }
    if (s == ds)
    {
        assert(глоб2.errors);
        ds.тип = Тип.terror;
        s = null;
    }
    if (!s) // it's a тип alias
    {
        //printf("alias %s resolved to тип %s\n", вТкст0(), тип.вТкст0());
        ds.тип = ds.тип.typeSemantic(ds.место, sc);
        ds.aliassym = null;
    }
    else    // it's a symbolic alias
    {
        //printf("alias %s resolved to %s %s\n", вТкст0(), s.вид(), s.вТкст0());
        ds.тип = null;
        ds.aliassym = s;
    }
    if (глоб2.gag && errors != глоб2.errors)
    {
        ds.тип = Тип.terror;
        ds.aliassym = null;
    }
    ds.inuse = 0;
    ds.semanticRun = PASS.semanticdone;

    if (auto sx = ds.overnext)
    {
        ds.overnext = null;
        if (!ds.overloadInsert(sx))
            ScopeDsymbol.multiplyDefined(Место.initial, sx, ds);
    }
}
