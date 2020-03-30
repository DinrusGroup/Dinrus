/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/declaration.d, _declaration.d)
 * Documentation:  https://dlang.org/phobos/dmd_declaration.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/declaration.d
 */

module dmd.declaration;

import cidrus;
import dmd.aggregate;
import dmd.arraytypes;
import dmd.ctorflow;
import dmd.dclass;
import dmd.delegatize;
import dmd.dscope;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.dtemplate;
import dmd.errors;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.init;
import dmd.initsem;
import dmd.intrange;
import dmd.mtype;
import util.outbuffer;
import drc.ast.Node;
import dmd.target;
import drc.lexer.Tokens;
import dmd.typesem;
import drc.ast.Visitor;

/************************************
 * Check to see the aggregate тип is nested and its context pointer is
 * accessible from the current scope.
 * Возвращает да if error occurs.
 */
бул checkFrameAccess(Место место, Scope* sc, AggregateDeclaration ad, т_мера iStart = 0)
{
    ДСимвол sparent = ad.toParentLocal();
    ДСимвол sparent2 = ad.toParent2();
    ДСимвол s = sc.func;
    if (ad.isNested() && s)
    {
        //printf("ad = %p %s [%s], родитель:%p\n", ad, ad.вТкст0(), ad.место.вТкст0(), ad.родитель);
        //printf("sparent = %p %s [%s], родитель: %s\n", sparent, sparent.вТкст0(), sparent.место.вТкст0(), sparent.родитель,вТкст0());
        //printf("sparent2 = %p %s [%s], родитель: %s\n", sparent2, sparent2.вТкст0(), sparent2.место.вТкст0(), sparent2.родитель,вТкст0());
        if (!ensureStaticLinkTo(s, sparent) || sparent != sparent2 && !ensureStaticLinkTo(s, sparent2))
        {
            выведиОшибку(место, "cannot access frame pointer of `%s`", ad.toPrettyChars());
            return да;
        }
    }

    бул результат = нет;
    for (т_мера i = iStart; i < ad.fields.dim; i++)
    {
        VarDeclaration vd = ad.fields[i];
        Тип tb = vd.тип.baseElemOf();
        if (tb.ty == Tstruct)
        {
            результат |= checkFrameAccess(место, sc, (cast(TypeStruct)tb).sym);
        }
    }
    return результат;
}

/***********************************************
 * Mark variable v as modified if it is inside a constructor that var
 * is a field in.
 */
бул modifyFieldVar(Место место, Scope* sc, VarDeclaration var, Выражение e1)
{
    //printf("modifyFieldVar(var = %s)\n", var.вТкст0());
    ДСимвол s = sc.func;
    while (1)
    {
        FuncDeclaration fd = null;
        if (s)
            fd = s.isFuncDeclaration();
        if (fd &&
            ((fd.isCtorDeclaration() && var.isField()) ||
             (fd.isStaticCtorDeclaration() && !var.isField())) &&
            fd.toParentDecl() == var.toParent2() &&
            (!e1 || e1.op == ТОК2.this_))
        {
            бул результат = да;

            var.ctorinit = да;
            //printf("setting ctorinit\n");

            if (var.isField() && sc.ctorflow.fieldinit.length && !sc.intypeof)
            {
                assert(e1);
                auto mustInit = ((var.класс_хранения & STC.nodefaultctor) != 0 ||
                                 var.тип.needsNested());

                const dim = sc.ctorflow.fieldinit.length;
                auto ad = fd.isMemberDecl();
                assert(ad);
                т_мера i;
                for (i = 0; i < dim; i++) // same as findFieldIndexByName in ctfeexp.c ?
                {
                    if (ad.fields[i] == var)
                        break;
                }
                assert(i < dim);
                auto fieldInit = &sc.ctorflow.fieldinit[i];
                const fi = fieldInit.csx;

                if (fi & CSX.this_ctor)
                {
                    if (var.тип.isMutable() && e1.тип.isMutable())
                        результат = нет;
                    else
                    {
                        ткст0 modStr = !var.тип.isMutable() ? MODtoChars(var.тип.mod) : MODtoChars(e1.тип.mod);
                        .выведиОшибку(место, "%s field `%s` initialized multiple times", modStr, var.вТкст0());
                        .errorSupplemental(fieldInit.место, "Previous initialization is here.");
                    }
                }
                else if (sc.inLoop || (fi & CSX.label))
                {
                    if (!mustInit && var.тип.isMutable() && e1.тип.isMutable())
                        результат = нет;
                    else
                    {
                        ткст0 modStr = !var.тип.isMutable() ? MODtoChars(var.тип.mod) : MODtoChars(e1.тип.mod);
                        .выведиОшибку(место, "%s field `%s` initialization is not allowed in loops or after labels", modStr, var.вТкст0());
                    }
                }

                fieldInit.csx |= CSX.this_ctor;
                fieldInit.место = e1.место;
                if (var.overlapped) // https://issues.dlang.org/show_bug.cgi?ид=15258
                {
                    foreach (j, v; ad.fields)
                    {
                        if (v is var || !var.isOverlappedWith(v))
                            continue;
                        v.ctorinit = да;
                        sc.ctorflow.fieldinit[j].csx = CSX.this_ctor;
                    }
                }
            }
            else if (fd != sc.func)
            {
                if (var.тип.isMutable())
                    результат = нет;
                else if (sc.func.fes)
                {
                    ткст0 p = var.isField() ? "field" : var.вид();
                    .выведиОшибку(место, "%s %s `%s` initialization is not allowed in foreach loop",
                        MODtoChars(var.тип.mod), p, var.вТкст0());
                }
                else
                {
                    ткст0 p = var.isField() ? "field" : var.вид();
                    .выведиОшибку(место, "%s %s `%s` initialization is not allowed in nested function `%s`",
                        MODtoChars(var.тип.mod), p, var.вТкст0(), sc.func.вТкст0());
                }
            }
            return результат;
        }
        else
        {
            if (s)
            {
                s = s.toParentP(var.toParent2());
                continue;
            }
        }
        break;
    }
    return нет;
}

/******************************************
 */
 проц ObjectNotFound(Идентификатор2 ид)
{
    выведиОшибку(Место.initial, "`%s` not found. объект.d may be incorrectly installed or corrupt.", ид.вТкст0());
    fatal();
}

enum STC : long
{
    undefined_          = 0L,
    static_             = (1L << 0),
    extern_             = (1L << 1),
    const_              = (1L << 2),
    final_              = (1L << 3),
    abstract_           = (1L << 4),
    параметр           = (1L << 5),
    field               = (1L << 6),
    override_           = (1L << 7),
    auto_               = (1L << 8),
    synchronized_       = (1L << 9),
    deprecated_         = (1L << 10),
    in_                 = (1L << 11),   // in параметр
    out_                = (1L << 12),   // out параметр
    lazy_               = (1L << 13),   // lazy параметр
    foreach_            = (1L << 14),   // variable for foreach loop
                          //(1L << 15)
    variadic            = (1L << 16),   // the 'variadic' параметр in: T foo(T a, U b, V variadic...)
    ctorinit            = (1L << 17),   // can only be set inside constructor
    шаблонпараметр   = (1L << 18),   // template параметр
    scope_              = (1L << 19),
    immutable_          = (1L << 20),
    ref_                = (1L << 21),
    init                = (1L << 22),   // has explicit инициализатор
    manifest            = (1L << 23),   // manifest constant
    nodtor              = (1L << 24),   // don't run destructor
    nothrow_            = (1L << 25),   // never throws exceptions
    pure_               = (1L << 26),   //  function
    tls                 = (1L << 27),   // thread local
    alias_              = (1L << 28),   // alias параметр
    shared_             = (1L << 29),   // accessible from multiple threads
    gshared             = (1L << 30),   // accessible from multiple threads, but not typed as "shared"
    wild                = (1L << 31),   // for "wild" тип constructor
    property            = (1L << 32),
    safe                = (1L << 33),
    trusted             = (1L << 34),
    system              = (1L << 35),
    ctfe                = (1L << 36),   // can be используется in CTFE, even if it is static
    disable             = (1L << 37),   // for functions that are not callable
    результат              = (1L << 38),   // for результат variables passed to out contracts
    nodefaultctor       = (1L << 39),   // must be set inside constructor
    temp                = (1L << 40),   // temporary variable
    rvalue              = (1L << 41),   // force rvalue for variables
    nogc                = (1L << 42),   // 
    volatile_           = (1L << 43),   // destined for volatile in the back end
    return_             = (1L << 44),   // 'return ref' or 'return scope' for function parameters
    autoref             = (1L << 45),   // Mark for the already deduced 'auto ref' параметр
    inference           = (1L << 46),   // do attribute inference
    exptemp             = (1L << 47),   // temporary variable that has lifetime restricted to an Выражение
    maybescope          = (1L << 48),   // параметр might be 'scope'
    scopeinferred       = (1L << 49),   // 'scope' has been inferred and should not be part of mangling
    future              = (1L << 50),   // introducing new base class function
    local               = (1L << 51),   // do not forward (see dmd.дсимвол.ForwardingScopeDsymbol).
    returninferred      = (1L << 52),   // 'return' has been inferred and should not be part of mangling
    live                = (1L << 53),   // function @live attribute

    // Group члены are mutually exclusive (there can be only one)
    safeGroup = STC.safe | STC.trusted | STC.system,

    TYPECTOR = (STC.const_ | STC.immutable_ | STC.shared_ | STC.wild),
    FUNCATTR = (STC.ref_ | STC.nothrow_ | STC.nogc | STC.pure_ | STC.property | STC.live |
                STC.safeGroup),
}

const STCStorageClass =
    (STC.auto_ | STC.scope_ | STC.static_ | STC.extern_ | STC.const_ | STC.final_ | STC.abstract_ | STC.synchronized_ |
     STC.deprecated_ | STC.future | STC.override_ | STC.lazy_ | STC.alias_ | STC.out_ | STC.in_ | STC.manifest |
     STC.immutable_ | STC.shared_ | STC.wild | STC.nothrow_ | STC.nogc | STC.pure_ | STC.ref_ | STC.return_ | STC.tls | STC.gshared |
     STC.property | STC.safeGroup | STC.disable | STC.local | STC.live);

/* These storage classes "flow through" to the inner scope of a ДСимвол
 */
const STCFlowThruAggregate = STC.safeGroup;    /// for an AggregateDeclaration
const STCFlowThruFunction = ~(STC.auto_ | STC.scope_ | STC.static_ | STC.extern_ | STC.abstract_ | STC.deprecated_ | STC.override_ |
                         STC.TYPECTOR | STC.final_ | STC.tls | STC.gshared | STC.ref_ | STC.return_ | STC.property |
                         STC.nothrow_ | STC.pure_ | STC.safe | STC.trusted | STC.system); /// for a FuncDeclaration

/* Accumulator for successive matches.
 */
struct MatchAccumulator
{
    цел count;              // number of matches found so far
    MATCH last = MATCH.nomatch; // match уровень of lastf
    FuncDeclaration lastf;  // last matching function we found
    FuncDeclaration nextf;  // if ambiguous match, this is the "other" function
}

/***********************************************************
 */
 abstract class Declaration : ДСимвол
{
    Тип тип;
    Тип originalType;  // before semantic analysis
    КлассХранения класс_хранения = STC.undefined_;
    Prot защита;
    LINK компонаж = LINK.default_;
    цел inuse;          // используется to detect cycles

    // overridden symbol with pragma(mangle, "...")
    ткст mangleOverride;

    final this(Идентификатор2 идент)
    {
        super(идент);
        защита = Prot(Prot.Kind.undefined);
    }

    final this(ref Место место, Идентификатор2 идент)
    {
        super(место, идент);
        защита = Prot(Prot.Kind.undefined);
    }

    override ткст0 вид()
    {
        return "declaration";
    }

    override final d_uns64 size(ref Место место)
    {
        assert(тип);
        return тип.size();
    }

    /**
     * Issue an error if an attempt to call a disabled method is made
     *
     * If the declaration is disabled but inside a disabled function,
     * returns `да` but do not issue an error message.
     *
     * Параметры:
     *   место = Location information of the call
     *   sc  = Scope in which the call occurs
     *   isAliasedDeclaration = if `да` searches overload set
     *
     * Возвращает:
     *   `да` if this `Declaration` is `@disable`d, `нет` otherwise.
     */
    final бул checkDisabled(Место место, Scope* sc, бул isAliasedDeclaration = нет)
    {
        if (класс_хранения & STC.disable)
        {
            if (!(sc.func && sc.func.класс_хранения & STC.disable))
            {
                auto p = toParent();
                if (p && isPostBlitDeclaration())
                    p.выведиОшибку(место, "is not copyable because it is annotated with `@disable`");
                else
                {
                    // if the function is @disabled, maybe there
                    // is an overload in the overload set that isn't
                    if (isAliasedDeclaration)
                    {
                        FuncDeclaration fd = isFuncDeclaration();
                        if (fd)
                        {
                            for (FuncDeclaration ovl = fd; ovl; ovl = cast(FuncDeclaration)ovl.overnext)
                                if (!(ovl.класс_хранения & STC.disable))
                                    return нет;
                        }
                    }
                    выведиОшибку(место, "cannot be используется because it is annotated with `@disable`");
                }
            }
            return да;
        }

        return нет;
    }

    /*************************************
     * Check to see if declaration can be modified in this context (sc).
     * Issue error if not.
     * Параметры:
     *  место  = location for error messages
     *  e1   = `null` or `this` Выражение when this declaration is a field
     *  sc   = context
     *  флаг = !=0 means do not issue error message for invalid modification
     * Возвращает:
     *  Modifiable.yes or Modifiable.initialization
     */
    final Modifiable checkModify(Место место, Scope* sc, Выражение e1, цел флаг)
    {
        VarDeclaration v = isVarDeclaration();
        if (v && v.canassign)
            return Modifiable.initialization;

        if (isParameter() || isрезультат())
        {
            for (Scope* scx = sc; scx; scx = scx.enclosing)
            {
                if (scx.func == родитель && (scx.flags & SCOPE.contract))
                {
                    ткст0 s = isParameter() && родитель.идент != Id.ensure ? "параметр" : "результат";
                    if (!флаг)
                        выведиОшибку(место, "cannot modify %s `%s` in contract", s, вТкст0());
                    return Modifiable.initialization; // do not report тип related errors
                }
            }
        }

        if (e1 && e1.op == ТОК2.this_ && isField())
        {
            VarDeclaration vthis = (cast(ThisExp)e1).var;
            for (Scope* scx = sc; scx; scx = scx.enclosing)
            {
                if (scx.func == vthis.родитель && (scx.flags & SCOPE.contract))
                {
                    if (!флаг)
                        выведиОшибку(место, "cannot modify параметр 'this' in contract");
                    return Modifiable.initialization; // do not report тип related errors
                }
            }
        }

        if (v && (isCtorinit() || isField()))
        {
            // It's only modifiable if inside the right constructor
            if ((класс_хранения & (STC.foreach_ | STC.ref_)) == (STC.foreach_ | STC.ref_))
                return Modifiable.initialization;
            return modifyFieldVar(место, sc, v, e1)
                ? Modifiable.initialization : Modifiable.yes;
        }
        return Modifiable.yes;
    }

    override final ДСимвол search(ref Место место, Идентификатор2 идент, цел flags = SearchLocalsOnly)
    {
        ДСимвол s = ДСимвол.search(место, идент, flags);
        if (!s && тип)
        {
            s = тип.toDsymbol(_scope);
            if (s)
                s = s.search(место, идент, flags);
        }
        return s;
    }

    final бул isStatic()  
    {
        return (класс_хранения & STC.static_) != 0;
    }

    бул isDelete()
    {
        return нет;
    }

    бул isDataseg()
    {
        return нет;
    }

    бул isThreadlocal()
    {
        return нет;
    }

    бул isCodeseg() 
    {
        return нет;
    }

    final бул isCtorinit() 
    {
        return (класс_хранения & STC.ctorinit) != 0;
    }

    final бул isFinal() 
    {
        return (класс_хранения & STC.final_) != 0;
    }

    бул isAbstract()
    {
        return (класс_хранения & STC.abstract_) != 0;
    }

    final бул isConst() 
    {
        return (класс_хранения & STC.const_) != 0;
    }

    final бул isImmutable()
    {
        return (класс_хранения & STC.immutable_) != 0;
    }

    final бул isWild()
    {
        return (класс_хранения & STC.wild) != 0;
    }

    final бул isAuto() 
    {
        return (класс_хранения & STC.auto_) != 0;
    }

    final бул isScope()  
    {
        return (класс_хранения & STC.scope_) != 0;
    }

    final бул isSynchronized()
    {
        return (класс_хранения & STC.synchronized_) != 0;
    }

    final бул isParameter()
    {
        return (класс_хранения & STC.параметр) != 0;
    }

    override final бул isDeprecated()
    {
        return (класс_хранения & STC.deprecated_) != 0;
    }

    final бул isDisabled()
    {
        return (класс_хранения & STC.disable) != 0;
    }

    final бул isOverride()
    {
        return (класс_хранения & STC.override_) != 0;
    }

    final бул isрезультат() 
    {
        return (класс_хранения & STC.результат) != 0;
    }

    final бул isField()  
    {
        return (класс_хранения & STC.field) != 0;
    }

    final бул isIn() 
    {
        return (класс_хранения & STC.in_) != 0;
    }

    final бул isOut()
    {
        return (класс_хранения & STC.out_) != 0;
    }

    final бул isRef()
    {
        return (класс_хранения & STC.ref_) != 0;
    }

    final бул isFuture() 
    {
        return (класс_хранения & STC.future) != 0;
    }

    override final Prot prot()
    {
        return защита;
    }

    override final Declaration isDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TupleDeclaration : Declaration
{
    Объекты* objects;
    бул isexp;             // да: Выражение кортеж
    КортежТипов tupletype;    // !=null if this is a тип кортеж

    this(ref Место место, Идентификатор2 идент, Объекты* objects)
    {
        super(место, идент);
        this.objects = objects;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(0);
    }

    override ткст0 вид()
    {
        return "кортеж";
    }

    override Тип getType()
    {
        /* If this кортеж represents a тип, return that тип
         */

        //printf("TupleDeclaration::getType() %s\n", вТкст0());
        if (isexp)
            return null;
        if (!tupletype)
        {
            /* It's only a тип кортеж if all the Object's are types
             */
            for (т_мера i = 0; i < objects.dim; i++)
            {
                КорневойОбъект o = (*objects)[i];
                if (o.динкаст() != ДИНКАСТ.тип)
                {
                    //printf("\tnot[%d], %p, %d\n", i, o, o.динкаст());
                    return null;
                }
            }

            /* We know it's a тип кортеж, so build the КортежТипов
             */
            Types* types = cast(Types*)objects;
            auto args = new Параметры(objects.dim);
            БуфВыв буф;
            цел hasdeco = 1;
            for (т_мера i = 0; i < types.dim; i++)
            {
                Тип t = (*types)[i];
                //printf("тип = %s\n", t.вТкст0());
                version (none)
                {
                    буф.printf("_%s_%d", идент.вТкст0(), i);
                    const len = буф.смещение;
                    const имя = буф.извлекиСрез().ptr;
                    auto ид = Идентификатор2.idPool(имя, len);
                    auto arg = new Параметр2(STC.in_, t, ид, null);
                }
                else
                {
                    auto arg = new Параметр2(0, t, null, null, null);
                }
                (*args)[i] = arg;
                if (!t.deco)
                    hasdeco = 0;
            }

            tupletype = new КортежТипов(args);
            if (hasdeco)
                return tupletype.typeSemantic(Место.initial, null);
        }
        return tupletype;
    }

    override ДСимвол toAlias2()
    {
        //printf("TupleDeclaration::toAlias2() '%s' objects = %s\n", вТкст0(), objects.вТкст0());
        for (т_мера i = 0; i < objects.dim; i++)
        {
            КорневойОбъект o = (*objects)[i];
            if (ДСимвол s = isDsymbol(o))
            {
                s = s.toAlias2();
                (*objects)[i] = s;
            }
        }
        return this;
    }

    override бул needThis()
    {
        //printf("TupleDeclaration::needThis(%s)\n", вТкст0());
        for (т_мера i = 0; i < objects.dim; i++)
        {
            КорневойОбъект o = (*objects)[i];
            if (o.динкаст() == ДИНКАСТ.Выражение)
            {
                Выражение e = cast(Выражение)o;
                if (e.op == ТОК2.dSymbol)
                {
                    DsymbolExp ve = cast(DsymbolExp)e;
                    Declaration d = ve.s.isDeclaration();
                    if (d && d.needThis())
                    {
                        return да;
                    }
                }
            }
        }
        return нет;
    }

    override TupleDeclaration isTupleDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class AliasDeclaration : Declaration
{
    ДСимвол aliassym;
    ДСимвол overnext;   // следщ in overload list
    ДСимвол _import;    // !=null if unresolved internal alias for selective import
    бул wasTemplateParameter; /// indicates wether the alias was created to make a template параметр visible in the scope, i.e as a member.

    this(ref Место место, Идентификатор2 идент, Тип тип)
    {
        super(место, идент);
        //printf("AliasDeclaration(ид = '%s', тип = %p)\n", ид.вТкст0(), тип);
        //printf("тип = '%s'\n", тип.вТкст0());
        this.тип = тип;
        assert(тип);
    }

    this(ref Место место, Идентификатор2 идент, ДСимвол s)
    {
        super(место, идент);
        //printf("AliasDeclaration(ид = '%s', s = %p)\n", ид.вТкст0(), s);
        assert(s != this);
        this.aliassym = s;
        assert(s);
    }

    static AliasDeclaration создай(Место место, Идентификатор2 ид, Тип тип)
    {
        return new AliasDeclaration(место, ид, тип);
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        //printf("AliasDeclaration::syntaxCopy()\n");
        assert(!s);
        AliasDeclaration sa = тип ? new AliasDeclaration(место, идент, тип.syntaxCopy()) : new AliasDeclaration(место, идент, aliassym.syntaxCopy(null));
        sa.коммент = коммент;
        sa.класс_хранения = класс_хранения;
        return sa;
    }

    override бул overloadInsert(ДСимвол s)
    {
        //printf("[%s] AliasDeclaration::overloadInsert('%s') s = %s %s @ [%s]\n",
        //       место.вТкст0(), вТкст0(), s.вид(), s.вТкст0(), s.место.вТкст0());

        /** Aliases aren't overloadable themselves, but if their Aliasee is
         *  overloadable they are converted to an overloadable Alias (either
         *  FuncAliasDeclaration or OverDeclaration).
         *
         *  This is done by moving the Aliasee into such an overloadable alias
         *  which is then используется to replace the existing Aliasee. The original
         *  Alias (_this_) remains a useless shell.
         *
         *  This is a horrible mess. It was probably done to avoid replacing
         *  existing AST nodes and references, but it needs a major
         *  simplification b/c it's too complex to maintain.
         *
         *  A simpler approach might be to merge any colliding symbols into a
         *  simple Overload class (an массив) and then later have that resolve
         *  all collisions.
         */
        if (semanticRun >= PASS.semanticdone)
        {
            /* Semantic analysis is already finished, and the aliased entity
             * is not overloadable.
             */
            if (тип)
                return нет;

            /* When s is added in member scope by static if, mixin("code") or others,
             * aliassym is determined already. See the case in: test/compilable/test61.d
             */
            auto sa = aliassym.toAlias();
            if (auto fd = sa.isFuncDeclaration())
            {
                auto fa = new FuncAliasDeclaration(идент, fd);
                fa.защита = защита;
                fa.родитель = родитель;
                aliassym = fa;
                return aliassym.overloadInsert(s);
            }
            if (auto td = sa.isTemplateDeclaration())
            {
                auto od = new OverDeclaration(идент, td);
                od.защита = защита;
                od.родитель = родитель;
                aliassym = od;
                return aliassym.overloadInsert(s);
            }
            if (auto od = sa.isOverDeclaration())
            {
                if (sa.идент != идент || sa.родитель != родитель)
                {
                    od = new OverDeclaration(идент, od);
                    od.защита = защита;
                    od.родитель = родитель;
                    aliassym = od;
                }
                return od.overloadInsert(s);
            }
            if (auto ос = sa.isOverloadSet())
            {
                if (sa.идент != идент || sa.родитель != родитель)
                {
                    ос = new OverloadSet(идент, ос);
                    // TODO: защита is lost here b/c OverloadSets have no защита attribute
                    // Might no be a practical issue, b/c the code below fails to resolve the overload anyhow.
                    // ----
                    // module os1;
                    // import a, b;
                    // private alias merged = foo; // private alias to overload set of a.foo and b.foo
                    // ----
                    // module os2;
                    // import a, b;
                    // public alias merged = bar; // public alias to overload set of a.bar and b.bar
                    // ----
                    // module bug;
                    // import os1, os2;
                    // проц test() { merged(123); } // should only look at os2.merged
                    //
                    // ос.защита = защита;
                    ос.родитель = родитель;
                    aliassym = ос;
                }
                ос.сунь(s);
                return да;
            }
            return нет;
        }

        /* Don't know yet what the aliased symbol is, so assume it can
         * be overloaded and check later for correctness.
         */
        if (overnext)
            return overnext.overloadInsert(s);
        if (s is this)
            return да;
        overnext = s;
        return да;
    }

    override ткст0 вид()
    {
        return "alias";
    }

    override Тип getType()
    {
        if (тип)
            return тип;
        return toAlias().getType();
    }

    override ДСимвол toAlias()
    {
        //printf("[%s] AliasDeclaration::toAlias('%s', this = %p, aliassym = %p, вид = '%s', inuse = %d)\n",
        //    место.вТкст0(), вТкст0(), this, aliassym, aliassym ? aliassym.вид() : "", inuse);
        assert(this != aliassym);
        //static цел count; if (++count == 10) *(сим*)0=0;
        if (inuse == 1 && тип && _scope)
        {
            inuse = 2;
            бцел olderrors = глоб2.errors;
            ДСимвол s = тип.toDsymbol(_scope);
            //printf("[%s] тип = %s, s = %p, this = %p\n", место.вТкст0(), тип.вТкст0(), s, this);
            if (глоб2.errors != olderrors)
                goto Lerr;
            if (s)
            {
                s = s.toAlias();
                if (глоб2.errors != olderrors)
                    goto Lerr;
                aliassym = s;
                inuse = 0;
            }
            else
            {
                Тип t = тип.typeSemantic(место, _scope);
                if (t.ty == Terror)
                    goto Lerr;
                if (глоб2.errors != olderrors)
                    goto Lerr;
                //printf("t = %s\n", t.вТкст0());
                inuse = 0;
            }
        }
        if (inuse)
        {
            выведиОшибку("recursive alias declaration");

        Lerr:
            // Avoid breaking "recursive alias" state during errors gagged
            if (глоб2.gag)
                return this;
            aliassym = new AliasDeclaration(место, идент, Тип.terror);
            тип = Тип.terror;
            return aliassym;
        }

        if (semanticRun >= PASS.semanticdone)
        {
            // semantic is already done.

            // Do not see aliassym !is null, because of lambda ники.

            // Do not see тип.deco !is null, even so "alias T = const цел;` needs
            // semantic analysis to take the storage class `const` as тип qualifier.
        }
        else
        {
            if (_import && _import._scope)
            {
                /* If this is an internal alias for selective/renamed import,
                 * load the module first.
                 */
                _import.dsymbolSemantic(null);
            }
            if (_scope)
            {
                aliasSemantic(this, _scope);
            }
        }

        inuse = 1;
        ДСимвол s = aliassym ? aliassym.toAlias() : this;
        inuse = 0;
        return s;
    }

    override ДСимвол toAlias2()
    {
        if (inuse)
        {
            выведиОшибку("recursive alias declaration");
            return this;
        }
        inuse = 1;
        ДСимвол s = aliassym ? aliassym.toAlias2() : this;
        inuse = 0;
        return s;
    }

    override бул перегружаем_ли()
    {
        // assume overloadable until alias is resolved
        return semanticRun < PASS.semanticdone ||
            aliassym && aliassym.перегружаем_ли();
    }

    override AliasDeclaration isAliasDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class OverDeclaration : Declaration
{
    ДСимвол overnext;   // следщ in overload list
    ДСимвол aliassym;
    бул hasOverloads;

    this(Идентификатор2 идент, ДСимвол s, бул hasOverloads = да)
    {
        super(идент);
        this.aliassym = s;
        this.hasOverloads = hasOverloads;
        if (hasOverloads)
        {
            if (OverDeclaration od = aliassym.isOverDeclaration())
                this.hasOverloads = od.hasOverloads;
        }
        else
        {
            // for internal use
            assert(!aliassym.isOverDeclaration());
        }
    }

    override ткст0 вид()
    {
        return "overload alias"; // todo
    }

    override бул равен(КорневойОбъект o)
    {
        if (this == o)
            return да;

        auto s = isDsymbol(o);
        if (!s)
            return нет;

        auto od1 = this;
        if (auto od2 = s.isOverDeclaration())
        {
            return od1.aliassym.равен(od2.aliassym) && od1.hasOverloads == od2.hasOverloads;
        }
        if (aliassym == s)
        {
            if (hasOverloads)
                return да;
            if (auto fd = s.isFuncDeclaration())
            {
                return fd.isUnique();
            }
            if (auto td = s.isTemplateDeclaration())
            {
                return td.overnext is null;
            }
        }
        return нет;
    }

    override бул overloadInsert(ДСимвол s)
    {
        //printf("OverDeclaration::overloadInsert('%s') aliassym = %p, overnext = %p\n", s.вТкст0(), aliassym, overnext);
        if (overnext)
            return overnext.overloadInsert(s);
        if (s == this)
            return да;
        overnext = s;
        return да;
    }

    override бул перегружаем_ли()
    {
        return да;
    }

    ДСимвол isUnique()
    {
        if (!hasOverloads)
        {
            if (aliassym.isFuncDeclaration() ||
                aliassym.isTemplateDeclaration())
            {
                return aliassym;
            }
        }

        ДСимвол результат = null;
        overloadApply(aliassym, (ДСимвол s)
        {
            if (результат)
            {
                результат = null;
                return 1; // ambiguous, done
            }
            else
            {
                результат = s;
                return 0;
            }
        });
        return результат;
    }

    override OverDeclaration isOverDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 class VarDeclaration : Declaration
{
    Инициализатор _иниц;
    бцел смещение;
    бцел sequenceNumber;            // order the variables are declared
     бцел nextSequenceNumber;   // the counter for sequenceNumber
    FuncDeclarations nestedrefs;    // referenced by these lexically nested functions
    structalign_t alignment;
    бул isargptr;                  // if параметр that _argptr points to
    бул ctorinit;                  // it has been initialized in a ctor
    бул iscatchvar;                // this is the exception объект variable in catch() clause
    бул isowner;                   // this is an Owner, despite it being `scope`

    // Both these mean the var is not rebindable once assigned,
    // and the destructor gets run when it goes out of scope
    бул onstack;                   // it is a class that was allocated on the stack
    бул mynew;                     // it is a class new'd with custom operator new

    цел canassign;                  // it can be assigned to
    бул overlapped;                // if it is a field and has overlapping
    бул overlapUnsafe;             // if it is an overlapping field and the overlaps are unsafe
    бул doNotInferScope;           // do not infer 'scope' for this variable
    бул doNotInferReturn;          // do not infer 'return' for this variable
    ббайт isdataseg;                // private данные for isDataseg 0 unset, 1 да, 2 нет
    ДСимвол aliassym;               // if redone as alias to another symbol
    VarDeclaration lastVar;         // Linked list of variables for goto-skips-init detection
    бцел endlinnum;                 // line number of end of scope that this var lives in

    // When interpreting, these point to the значение (NULL if значение not determinable)
    // The index of this variable on the CTFE stack, AdrOnStackNone if not allocated
    const AdrOnStackNone = ~0u;
    бцел ctfeAdrOnStack;

    Выражение edtor;               // if !=null, does the destruction of the variable
    IntRange* range;                // if !=null, the variable is known to be within the range

    VarDeclarations* maybes;        // STC.maybescope variables that are assigned to this STC.maybescope variable

    private бул _isAnonymous;

    final this(ref Место место, Тип тип, Идентификатор2 идент, Инициализатор _иниц, КлассХранения класс_хранения = STC.undefined_)
    {
        if (идент is Идентификатор2.анонимный)
        {
            идент = Идентификатор2.генерируйИд("__anonvar");
            _isAnonymous = да;
        }
        //printf("VarDeclaration('%s')\n", идент.вТкст0());
        assert(идент);
        super(место, идент);
        debug
        {
            if (!тип && !_иниц)
            {
                //printf("VarDeclaration('%s')\n", идент.вТкст0());
                //*(сим*)0=0;
            }
        }

        assert(тип || _иниц);
        this.тип = тип;
        this._иниц = _иниц;
        ctfeAdrOnStack = AdrOnStackNone;
        this.класс_хранения = класс_хранения;
        sequenceNumber = ++nextSequenceNumber;
    }

    static VarDeclaration создай(ref Место место, Тип тип, Идентификатор2 идент, Инициализатор _иниц, КлассХранения класс_хранения = STC.undefined_)
    {
        return new VarDeclaration(место, тип, идент, _иниц, класс_хранения);
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        //printf("VarDeclaration::syntaxCopy(%s)\n", вТкст0());
        assert(!s);
        auto v = new VarDeclaration(место, тип ? тип.syntaxCopy() : null, идент, _иниц ? _иниц.syntaxCopy() : null, класс_хранения);
        v.коммент = коммент;
        return v;
    }

    override final проц setFieldOffset(AggregateDeclaration ad, бцел* poffset, бул isunion)
    {
        //printf("VarDeclaration::setFieldOffset(ad = %s) %s\n", ad.вТкст0(), вТкст0());

        if (aliassym)
        {
            // If this variable was really a кортеж, set the offsets for the кортеж fields
            TupleDeclaration v2 = aliassym.isTupleDeclaration();
            assert(v2);
            for (т_мера i = 0; i < v2.objects.dim; i++)
            {
                КорневойОбъект o = (*v2.objects)[i];
                assert(o.динкаст() == ДИНКАСТ.Выражение);
                Выражение e = cast(Выражение)o;
                assert(e.op == ТОК2.dSymbol);
                DsymbolExp se = cast(DsymbolExp)e;
                se.s.setFieldOffset(ad, poffset, isunion);
            }
            return;
        }

        if (!isField())
            return;
        assert(!(класс_хранения & (STC.static_ | STC.extern_ | STC.параметр | STC.tls)));

        //printf("+VarDeclaration::setFieldOffset(ad = %s) %s\n", ad.вТкст0(), вТкст0());

        /* Fields that are tuples appear both as part of TupleDeclarations and
         * as члены. That means ignore them if they are already a field.
         */
        if (смещение)
        {
            // already a field
            *poffset = ad.structsize; // https://issues.dlang.org/show_bug.cgi?ид=13613
            return;
        }
        for (т_мера i = 0; i < ad.fields.dim; i++)
        {
            if (ad.fields[i] == this)
            {
                // already a field
                *poffset = ad.structsize; // https://issues.dlang.org/show_bug.cgi?ид=13613
                return;
            }
        }

        // Check for forward referenced types which will fail the size() call
        Тип t = тип.toBasetype();
        if (класс_хранения & STC.ref_)
        {
            // References are the size of a pointer
            t = Тип.tvoidptr;
        }
        Тип tv = t.baseElemOf();
        if (tv.ty == Tstruct)
        {
            auto ts = cast(TypeStruct)tv;
            assert(ts.sym != ad);   // already checked in ad.determineFields()
            if (!ts.sym.determineSize(место))
            {
                тип = Тип.terror;
                errors = да;
                return;
            }
        }

        // List in ad.fields. Even if the тип is error, it's necessary to avoid
        // pointless error diagnostic "more initializers than fields" on struct literal.
        ad.fields.сунь(this);

        if (t.ty == Terror)
            return;

        const sz = t.size(место);
        assert(sz != SIZE_INVALID && sz < бцел.max);
        бцел memsize = cast(бцел)sz;                // size of member
        бцел memalignsize = target.fieldalign(t);   // size of member for alignment purposes
        смещение = AggregateDeclaration.placeField(
            poffset,
            memsize, memalignsize, alignment,
            &ad.structsize, &ad.alignsize,
            isunion);

        //printf("\t%s: memalignsize = %d\n", вТкст0(), memalignsize);
        //printf(" addField '%s' to '%s' at смещение %d, size = %d\n", вТкст0(), ad.вТкст0(), смещение, memsize);
    }

    override ткст0 вид()
    {
        return "variable";
    }

    override final AggregateDeclaration isThis()
    {
        if (!(класс_хранения & (STC.static_ | STC.extern_ | STC.manifest | STC.шаблонпараметр | STC.tls | STC.gshared | STC.ctfe)))
        {
            /* The casting is necessary because `s = s.родитель` is otherwise rejected
             */
            for (auto s = cast(ДСимвол)this; s; s = s.родитель)
            {
                auto ad = s.isMember();
                if (ad)
                    return ad;
                if (!s.родитель || !s.родитель.isTemplateMixin())
                    break;
            }
        }
        return null;
    }

    override final бул needThis()
    {
        //printf("VarDeclaration::needThis(%s, x%x)\n", вТкст0(), класс_хранения);
        return isField();
    }

    override final бул isAnonymous()
    {
        return _isAnonymous;
    }

    override final бул isExport()
    {
        return защита.вид == Prot.Kind.export_;
    }

    override final бул isImportedSymbol()
    {
        if (защита.вид == Prot.Kind.export_ && !_иниц && (класс_хранения & STC.static_ || родитель.isModule()))
            return да;
        return нет;
    }

    /*******************************
     * Does symbol go into данные segment?
     * Includes extern variables.
     */
    override final бул isDataseg()
    {
        version (none)
        {
            printf("VarDeclaration::isDataseg(%p, '%s')\n", this, вТкст0());
            printf("%llx, isModule: %p, isTemplateInstance: %p, isNspace: %p\n",
                   класс_хранения & (STC.static_ | STC.const_), родитель.isModule(), родитель.isTemplateInstance(), родитель.isNspace());
            printf("родитель = '%s'\n", родитель.вТкст0());
        }

        if (isdataseg == 0) // the значение is not cached
        {
            isdataseg = 2; // The Variables does not go into the datasegment

            if (!canTakeAddressOf())
            {
                return нет;
            }

            ДСимвол родитель = toParent();
            if (!родитель && !(класс_хранения & STC.static_))
            {
                выведиОшибку("forward referenced");
                тип = Тип.terror;
            }
            else if (класс_хранения & (STC.static_ | STC.extern_ | STC.tls | STC.gshared) ||
                родитель.isModule() || родитель.isTemplateInstance() || родитель.isNspace())
            {
                assert(!isParameter() && !isрезультат());
                isdataseg = 1; // It is in the DataSegment
            }
        }

        return (isdataseg == 1);
    }
    /************************************
     * Does symbol go into thread local storage?
     */
    override final бул isThreadlocal()
    {
        //printf("VarDeclaration::isThreadlocal(%p, '%s')\n", this, вТкст0());
        /* Data defaults to being thread-local. It is not thread-local
         * if it is const, const or shared.
         */
        бул i = isDataseg() && !(класс_хранения & (STC.immutable_ | STC.const_ | STC.shared_ | STC.gshared));
        //printf("\treturn %d\n", i);
        return i;
    }

    /********************************************
     * Can variable be читай and written by CTFE?
     */
    final бул isCTFE()
    {
        return (класс_хранения & STC.ctfe) != 0; // || !isDataseg();
    }

    final бул isOverlappedWith(VarDeclaration v)
    {
        const vsz = v.тип.size();
        const tsz = тип.size();
        assert(vsz != SIZE_INVALID && tsz != SIZE_INVALID);
        return    смещение < v.смещение + vsz &&
                v.смещение <   смещение + tsz;
    }

    override final бул hasPointers()
    {
        //printf("VarDeclaration::hasPointers() %s, ty = %d\n", вТкст0(), тип.ty);
        return (!isDataseg() && тип.hasPointers());
    }

    /*************************************
     * Return да if we can take the address of this variable.
     */
    final бул canTakeAddressOf()
    {
        return !(класс_хранения & STC.manifest);
    }

    /******************************************
     * Return да if variable needs to call the destructor.
     */
    final бул needsScopeDtor()
    {
        //printf("VarDeclaration::needsScopeDtor() %s\n", вТкст0());
        return edtor && !(класс_хранения & STC.nodtor);
    }

    /******************************************
     * If a variable has a scope destructor call, return call for it.
     * Otherwise, return NULL.
     */
    extern (D) final Выражение callScopeDtor(Scope* sc)
    {
        //printf("VarDeclaration::callScopeDtor() %s\n", вТкст0());

        // Destruction of STC.field's is handled by buildDtor()
        if (класс_хранения & (STC.nodtor | STC.ref_ | STC.out_ | STC.field))
        {
            return null;
        }

        if (iscatchvar)
            return null;    // destructor is built by `проц semantic(Уловитель c, Scope* sc)`, not here

        Выражение e = null;
        // Destructors for structs and arrays of structs
        Тип tv = тип.baseElemOf();
        if (tv.ty == Tstruct)
        {
            StructDeclaration sd = (cast(TypeStruct)tv).sym;
            if (!sd.dtor || sd.errors)
                return null;

            const sz = тип.size();
            assert(sz != SIZE_INVALID);
            if (!sz)
                return null;

            if (тип.toBasetype().ty == Tstruct)
            {
                // v.__xdtor()
                e = new VarExp(место, this);

                /* This is a hack so we can call destructors on const/const objects.
                 * Need to add things like "const ~this()" and "const ~this()" to
                 * fix properly.
                 */
                e.тип = e.тип.mutableOf();

                // Enable calling destructors on shared objects.
                // The destructor is always a single, non-overloaded function,
                // and must serve both shared and non-shared objects.
                e.тип = e.тип.unSharedOf;

                e = new DotVarExp(место, e, sd.dtor, нет);
                e = new CallExp(место, e);
            }
            else
            {
                // __МассивDtor(v[0 .. n])
                e = new VarExp(место, this);

                const sdsz = sd.тип.size();
                assert(sdsz != SIZE_INVALID && sdsz != 0);
                const n = sz / sdsz;
                e = new SliceExp(место, e, new IntegerExp(место, 0, Тип.tт_мера), new IntegerExp(место, n, Тип.tт_мера));

                // Prevent redundant bounds check
                (cast(SliceExp)e).upperIsInBounds = да;
                (cast(SliceExp)e).lowerIsLessThanUpper = да;

                // This is a hack so we can call destructors on const/const objects.
                e.тип = sd.тип.arrayOf();

                e = new CallExp(место, new IdentifierExp(место, Id.__МассивDtor), e);
            }
            return e;
        }
        // Destructors for classes
        if (класс_хранения & (STC.auto_ | STC.scope_) && !(класс_хранения & STC.параметр))
        {
            for (ClassDeclaration cd = тип.isClassHandle(); cd; cd = cd.baseClass)
            {
                /* We can do better if there's a way with onstack
                 * classes to determine if there's no way the monitor
                 * could be set.
                 */
                //if (cd.isInterfaceDeclaration())
                //    выведиОшибку("interface `%s` cannot be scope", cd.вТкст0());

                // Destroying C++ scope classes crashes currently. Since C++ class dtors are not currently supported, simply do not run dtors for them.
                // See https://issues.dlang.org/show_bug.cgi?ид=13182
                if (cd.classKind == ClassKind.cpp)
                {
                    break;
                }
                if (mynew || onstack) // if any destructors
                {
                    // delete this;
                    Выражение ec;
                    ec = new VarExp(место, this);
                    e = new DeleteExp(место, ec, да);
                    e.тип = Тип.tvoid;
                    break;
                }
            }
        }
        return e;
    }

    /*******************************************
     * If variable has a constant Выражение инициализатор, get it.
     * Otherwise, return null.
     */
    extern (D) final Выражение getConstInitializer(бул needFullType = да)
    {
        assert(тип && _иниц);

        // Ungag errors when not speculative
        бцел oldgag = глоб2.gag;
        if (глоб2.gag)
        {
            ДСимвол sym = toParent().isAggregateDeclaration();
            if (sym && !sym.isSpeculative())
                глоб2.gag = 0;
        }

        if (_scope)
        {
            inuse++;
            _иниц = _иниц.initializerSemantic(_scope, тип, INITinterpret);
            _scope = null;
            inuse--;
        }

        Выражение e = _иниц.инициализаторВВыражение(needFullType ? тип : null);
        глоб2.gag = oldgag;
        return e;
    }

    /*******************************************
     * Helper function for the expansion of manifest constant.
     */
    extern (D) final Выражение expandInitializer(Место место)
    {
        assert((класс_хранения & STC.manifest) && _иниц);

        auto e = getConstInitializer();
        if (!e)
        {
            .выведиОшибку(место, "cannot make Выражение out of инициализатор for `%s`", вТкст0());
            return new ErrorExp();
        }

        e = e.копируй();
        e.место = место;    // for better error message
        return e;
    }

    override final проц checkCtorConstInit()
    {
        version (none)
        {
            /* doesn't work if more than one static ctor */
            if (ctorinit == 0 && isCtorinit() && !isField())
                выведиОшибку("missing инициализатор in static constructor for const variable");
        }
    }

    /************************************
     * Check to see if this variable is actually in an enclosing function
     * rather than the current one.
     * Update nestedrefs[], closureVars[] and outerVars[].
     * Возвращает: да if error occurs.
     */
    extern (D) final бул checkNestedReference(Scope* sc, Место место)
    {
        //printf("VarDeclaration::checkNestedReference() %s\n", вТкст0());
        if (sc.intypeof == 1 || (sc.flags & SCOPE.ctfe))
            return нет;
        if (!родитель || родитель == sc.родитель)
            return нет;
        if (isDataseg() || (класс_хранения & STC.manifest))
            return нет;

        // The current function
        FuncDeclaration fdthis = sc.родитель.isFuncDeclaration();
        if (!fdthis)
            return нет; // out of function scope

        ДСимвол p = toParent2();

        // Function literals from fdthis to p must be delegates
        ensureStaticLinkTo(fdthis, p);

        // The function that this variable is in
        FuncDeclaration fdv = p.isFuncDeclaration();
        if (!fdv || fdv == fdthis)
            return нет;

        // Add fdthis to nestedrefs[] if not already there
        if (!nestedrefs.содержит(fdthis))
            nestedrefs.сунь(fdthis);

        //printf("\tfdv = %s\n", fdv.вТкст0());
        //printf("\tfdthis = %s\n", fdthis.вТкст0());
        if (место.isValid())
        {
            if (fdthis.getLevelAndCheck(место, sc, fdv) == fdthis.LevelError)
                return да;
        }

        // Add this VarDeclaration to fdv.closureVars[] if not already there
        if (!sc.intypeof && !(sc.flags & SCOPE.compile) &&
            // https://issues.dlang.org/show_bug.cgi?ид=17605
            (fdv.flags & FUNCFLAG.compileTimeOnly || !(fdthis.flags & FUNCFLAG.compileTimeOnly))
           )
        {
            if (!fdv.closureVars.содержит(this))
                fdv.closureVars.сунь(this);
        }

        if (!fdthis.outerVars.содержит(this))
            fdthis.outerVars.сунь(this);

        //printf("fdthis is %s\n", fdthis.вТкст0());
        //printf("var %s in function %s is nested ref\n", вТкст0(), fdv.вТкст0());
        // __dollar creates problems because it isn't a real variable
        // https://issues.dlang.org/show_bug.cgi?ид=3326
        if (идент == Id.dollar)
        {
            .выведиОшибку(место, "cannnot use `$` inside a function literal");
            return да;
        }
        if (идент == Id.withSym) // https://issues.dlang.org/show_bug.cgi?ид=1759
        {
            ExpInitializer ez = _иниц.isExpInitializer();
            assert(ez);
            Выражение e = ez.exp;
            if (e.op == ТОК2.construct || e.op == ТОК2.blit)
                e = (cast(AssignExp)e).e2;
            return lambdaCheckForNestedRef(e, sc);
        }

        return нет;
    }

    override final ДСимвол toAlias()
    {
        //printf("VarDeclaration::toAlias('%s', this = %p, aliassym = %p)\n", вТкст0(), this, aliassym);
        if ((!тип || !тип.deco) && _scope)
            dsymbolSemantic(this, _scope);

        assert(this != aliassym);
        ДСимвол s = aliassym ? aliassym.toAlias() : this;
        return s;
    }

    // Eliminate need for dynamic_cast
    override final VarDeclaration isVarDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }

    /**********************************
     * Determine if `this` has a lifetime that lasts past
     * the destruction of `v`
     * Параметры:
     *  v = variable to test against
     * Возвращает:
     *  да if it does
     */
    final бул enclosesLifetimeOf(VarDeclaration v) 
    {
        return sequenceNumber < v.sequenceNumber;
    }

    /***************************************
     * Add variable to maybes[].
     * When a maybescope variable `v` is assigned to a maybescope variable `this`,
     * we cannot determine if `this` is actually scope until the semantic
     * analysis for the function is completed. Thus, we save the данные
     * until then.
     * Параметры:
     *  v = an STC.maybescope variable that was assigned to `this`
     */
    final проц addMaybe(VarDeclaration v)
    {
        //printf("add %s to %s's list of dependencies\n", v.вТкст0(), вТкст0());
        if (!maybes)
            maybes = new VarDeclarations();
        maybes.сунь(v);
    }
}

/***********************************************************
 * This is a shell around a back end symbol
 */
 final class SymbolDeclaration : Declaration
{
    StructDeclaration dsym;

    this(ref Место место, StructDeclaration dsym)
    {
        super(место, dsym.идент);
        this.dsym = dsym;
        класс_хранения |= STC.const_;
    }

    // Eliminate need for dynamic_cast
    override SymbolDeclaration isSymbolDeclaration() 
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 class TypeInfoDeclaration : VarDeclaration
{
    Тип tinfo;

    final this(Тип tinfo)
    {
        super(Место.initial, Тип.dtypeinfo.тип, tinfo.getTypeInfoIdent(), null);
        this.tinfo = tinfo;
        класс_хранения = STC.static_ | STC.gshared;
        защита = Prot(Prot.Kind.public_);
        компонаж = LINK.c;
        alignment = target.ptrsize;
    }

    static TypeInfoDeclaration создай(Тип tinfo)
    {
        return new TypeInfoDeclaration(tinfo);
    }

    override final ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(0); // should never be produced by syntax
    }

    override final ткст0 вТкст0()
    {
        //printf("TypeInfoDeclaration::вТкст0() tinfo = %s\n", tinfo.вТкст0());
        БуфВыв буф;
        буф.пишиСтр("typeid(");
        буф.пишиСтр(tinfo.вТкст0());
        буф.пишиБайт(')');
        return буф.extractChars();
    }

    override final TypeInfoDeclaration isTypeInfoDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeInfoStructDeclaration : TypeInfoDeclaration
{
    this(Тип tinfo)
    {
        super(tinfo);
        if (!Тип.typeinfostruct)
        {
            ObjectNotFound(Id.TypeInfo_Struct);
        }
        тип = Тип.typeinfostruct.тип;
    }

    static TypeInfoStructDeclaration создай(Тип tinfo)
    {
        return new TypeInfoStructDeclaration(tinfo);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeInfoClassDeclaration : TypeInfoDeclaration
{
    this(Тип tinfo)
    {
        super(tinfo);
        if (!Тип.typeinfoclass)
        {
            ObjectNotFound(Id.TypeInfo_Class);
        }
        тип = Тип.typeinfoclass.тип;
    }

    static TypeInfoClassDeclaration создай(Тип tinfo)
    {
        return new TypeInfoClassDeclaration(tinfo);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeInfoInterfaceDeclaration : TypeInfoDeclaration
{
    this(Тип tinfo)
    {
        super(tinfo);
        if (!Тип.typeinfointerface)
        {
            ObjectNotFound(Id.TypeInfo_Interface);
        }
        тип = Тип.typeinfointerface.тип;
    }

    static TypeInfoInterfaceDeclaration создай(Тип tinfo)
    {
        return new TypeInfoInterfaceDeclaration(tinfo);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeInfoPointerDeclaration : TypeInfoDeclaration
{
    this(Тип tinfo)
    {
        super(tinfo);
        if (!Тип.typeinfopointer)
        {
            ObjectNotFound(Id.TypeInfo_Pointer);
        }
        тип = Тип.typeinfopointer.тип;
    }

    static TypeInfoPointerDeclaration создай(Тип tinfo)
    {
        return new TypeInfoPointerDeclaration(tinfo);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeInfoArrayDeclaration : TypeInfoDeclaration
{
    this(Тип tinfo)
    {
        super(tinfo);
        if (!Тип.typeinfoarray)
        {
            ObjectNotFound(Id.TypeInfo_Массив);
        }
        тип = Тип.typeinfoarray.тип;
    }

    static TypeInfoArrayDeclaration создай(Тип tinfo)
    {
        return new TypeInfoArrayDeclaration(tinfo);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeInfoStaticArrayDeclaration : TypeInfoDeclaration
{
    this(Тип tinfo)
    {
        super(tinfo);
        if (!Тип.typeinfostaticarray)
        {
            ObjectNotFound(Id.TypeInfo_StaticArray);
        }
        тип = Тип.typeinfostaticarray.тип;
    }

    static TypeInfoStaticArrayDeclaration создай(Тип tinfo)
    {
        return new TypeInfoStaticArrayDeclaration(tinfo);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeInfoAssociativeArrayDeclaration : TypeInfoDeclaration
{
    this(Тип tinfo)
    {
        super(tinfo);
        if (!Тип.typeinfoassociativearray)
        {
            ObjectNotFound(Id.TypeInfo_AssociativeArray);
        }
        тип = Тип.typeinfoassociativearray.тип;
    }

    static TypeInfoAssociativeArrayDeclaration создай(Тип tinfo)
    {
        return new TypeInfoAssociativeArrayDeclaration(tinfo);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeInfoEnumDeclaration : TypeInfoDeclaration
{
    this(Тип tinfo)
    {
        super(tinfo);
        if (!Тип.typeinfoenum)
        {
            ObjectNotFound(Id.TypeInfo_Enum);
        }
        тип = Тип.typeinfoenum.тип;
    }

    static TypeInfoEnumDeclaration создай(Тип tinfo)
    {
        return new TypeInfoEnumDeclaration(tinfo);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeInfoFunctionDeclaration : TypeInfoDeclaration
{
    this(Тип tinfo)
    {
        super(tinfo);
        if (!Тип.typeinfofunction)
        {
            ObjectNotFound(Id.TypeInfo_Function);
        }
        тип = Тип.typeinfofunction.тип;
    }

    static TypeInfoFunctionDeclaration создай(Тип tinfo)
    {
        return new TypeInfoFunctionDeclaration(tinfo);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeInfoDelegateDeclaration : TypeInfoDeclaration
{
    this(Тип tinfo)
    {
        super(tinfo);
        if (!Тип.typeinfodelegate)
        {
            ObjectNotFound(Id.TypeInfo_Delegate);
        }
        тип = Тип.typeinfodelegate.тип;
    }

    static TypeInfoDelegateDeclaration создай(Тип tinfo)
    {
        return new TypeInfoDelegateDeclaration(tinfo);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeInfoTupleDeclaration : TypeInfoDeclaration
{
    this(Тип tinfo)
    {
        super(tinfo);
        if (!Тип.typeinfotypelist)
        {
            ObjectNotFound(Id.TypeInfo_Tuple);
        }
        тип = Тип.typeinfotypelist.тип;
    }

    static TypeInfoTupleDeclaration создай(Тип tinfo)
    {
        return new TypeInfoTupleDeclaration(tinfo);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeInfoConstDeclaration : TypeInfoDeclaration
{
    this(Тип tinfo)
    {
        super(tinfo);
        if (!Тип.typeinfoconst)
        {
            ObjectNotFound(Id.TypeInfo_Const);
        }
        тип = Тип.typeinfoconst.тип;
    }

    static TypeInfoConstDeclaration создай(Тип tinfo)
    {
        return new TypeInfoConstDeclaration(tinfo);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeInfoInvariantDeclaration : TypeInfoDeclaration
{
    this(Тип tinfo)
    {
        super(tinfo);
        if (!Тип.typeinfoinvariant)
        {
            ObjectNotFound(Id.TypeInfo_Invariant);
        }
        тип = Тип.typeinfoinvariant.тип;
    }

    static TypeInfoInvariantDeclaration создай(Тип tinfo)
    {
        return new TypeInfoInvariantDeclaration(tinfo);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeInfoSharedDeclaration : TypeInfoDeclaration
{
    this(Тип tinfo)
    {
        super(tinfo);
        if (!Тип.typeinfoshared)
        {
            ObjectNotFound(Id.TypeInfo_Shared);
        }
        тип = Тип.typeinfoshared.тип;
    }

    static TypeInfoSharedDeclaration создай(Тип tinfo)
    {
        return new TypeInfoSharedDeclaration(tinfo);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeInfoWildDeclaration : TypeInfoDeclaration
{
    this(Тип tinfo)
    {
        super(tinfo);
        if (!Тип.typeinfowild)
        {
            ObjectNotFound(Id.TypeInfo_Wild);
        }
        тип = Тип.typeinfowild.тип;
    }

    static TypeInfoWildDeclaration создай(Тип tinfo)
    {
        return new TypeInfoWildDeclaration(tinfo);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class TypeInfoVectorDeclaration : TypeInfoDeclaration
{
    this(Тип tinfo)
    {
        super(tinfo);
        if (!Тип.typeinfovector)
        {
            ObjectNotFound(Id.TypeInfo_Vector);
        }
        тип = Тип.typeinfovector.тип;
    }

    static TypeInfoVectorDeclaration создай(Тип tinfo)
    {
        return new TypeInfoVectorDeclaration(tinfo);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * For the "this" параметр to member functions
 */
 final class ThisDeclaration : VarDeclaration
{
    this(ref Место место, Тип t)
    {
        super(место, t, Id.This, null);
        класс_хранения |= STC.nodtor;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(0); // should never be produced by syntax
    }

    override ThisDeclaration isThisDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}
