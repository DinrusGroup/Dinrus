/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/cond.d, _cond.d)
 * Documentation:  https://dlang.org/phobos/dmd_cond.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/cond.d
 */

module dmd.cond;

import cidrus;
import dmd.arraytypes;
import  drc.ast.Node;
import dmd.dmodule;
import dmd.dscope;
import dmd.дсимвол;
import dmd.errors;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.globals;
import drc.lexer.Identifier;
import dmd.mtype;
import util.outbuffer;
import drc.ast.Node;
import util.string;
import drc.lexer.Tokens;
import util.utils;
import drc.ast.Visitor;
import drc.lexer.Id;
import dmd.инструкция;
import dmd.declaration;
import dmd.dstruct;
import dmd.func;

/***********************************************************
 */

enum Include
{
    notComputed,        /// not computed yet
    yes,                /// include the conditional code
    no,                 /// do not include the conditional code
}

 abstract class Condition : УзелАСД
{
    Место место;

    Include inc;

    override final ДИНКАСТ динкаст()
    {
        return ДИНКАСТ.условие;
    }

    this(ref Место место)
    {
        this.место = место;
    }

    abstract Condition syntaxCopy();

    abstract цел include(Scope* sc);

    DebugCondition isDebugCondition() 
    {
        return null;
    }

    VersionCondition isVersionCondition()
    {
        return null;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * Implements common functionality for StaticForeachDeclaration and
 * StaticForeachStatement This performs the necessary lowerings before
 * dmd.statementsem.makeTupleForeach can be используется to expand the
 * corresponding `static foreach` declaration or инструкция.
 */

 final class StaticForeach : КорневойОбъект
{
    static const tupleFieldName = "кортеж"; // используется in lowering

    Место место;

    /***************
     * Not `null` iff the `static foreach` is over an aggregate. In
     * this case, it содержит the corresponding ForeachStatement. For
     * StaticForeachDeclaration, the body is `null`.
    */
    ForeachStatement aggrfe;
    /***************
     * Not `null` iff the `static foreach` is over a range. Exactly
     * one of the `aggrefe` and `rangefe` fields is not null. See
     * `aggrfe` field for more details.
     */
    ForeachRangeStatement rangefe;

    /***************
     * да if it is necessary to expand a кортеж into multiple
     * variables (see lowerNonArrayAggregate).
     */
    бул needExpansion = нет;

    this(ref Место место,ForeachStatement aggrfe,ForeachRangeStatement rangefe)
    {
        assert(!!aggrfe ^ !!rangefe);

        this.место = место;
        this.aggrfe = aggrfe;
        this.rangefe = rangefe;
    }

    StaticForeach syntaxCopy()
    {
        return new StaticForeach(
            место,
            aggrfe ? cast(ForeachStatement)aggrfe.syntaxCopy() : null,
            rangefe ? cast(ForeachRangeStatement)rangefe.syntaxCopy() : null
        );
    }

    /*****************************************
     * Turn an aggregate which is an массив into an Выражение кортеж
     * of its elements. I.e., lower
     *     static foreach (x; [1, 2, 3, 4]) { ... }
     * to
     *     static foreach (x; AliasSeq!(1, 2, 3, 4)) { ... }
     */
    private проц lowerArrayAggregate(Scope* sc)
    {
        auto aggr = aggrfe.aggr;
        Выражение el = new ArrayLengthExp(aggr.место, aggr);
        sc = sc.startCTFE();
        el = el.ВыражениеSemantic(sc);
        sc = sc.endCTFE();
        el = el.optimize(WANTvalue);
        el = el.ctfeInterpret();
        if (el.op == ТОК2.int64)
        {
            dinteger_t length = el.toInteger();
            auto es = new Выражения();
            foreach (i; new бцел[0 .. length])
            {
                auto index = new IntegerExp(место, i, Тип.tт_мера);
                auto значение = new IndexExp(aggr.место, aggr, index);
                es.сунь(значение);
            }
            aggrfe.aggr = new TupleExp(aggr.место, es);
            aggrfe.aggr = aggrfe.aggr.ВыражениеSemantic(sc);
            aggrfe.aggr = aggrfe.aggr.optimize(WANTvalue);
        }
        else
        {
            aggrfe.aggr = new ErrorExp();
        }
    }

    /*****************************************
     * Wrap a инструкция into a function literal and call it.
     *
     * Параметры:
     *     место = The source location.
     *     s  = The инструкция.
     * Возвращает:
     *     AST of the Выражение `(){ s; }()` with location место.
     */
    private Выражение wrapAndCall(ref Место место, Инструкция2 s)
    {
        auto tf = new TypeFunction(СписокПараметров(), null, LINK.default_, 0);
        auto fd = new FuncLiteralDeclaration(место, место, tf, ТОК2.reserved, null);
        fd.fbody = s;
        auto fe = new FuncExp(место, fd);
        auto ce = new CallExp(место, fe, new Выражения());
        return ce;
    }

    /*****************************************
     * Create a `foreach` инструкция from `aggrefe/rangefe` with given
     * `foreach` variables and body `s`.
     *
     * Параметры:
     *     место = The source location.
     *     parameters = The foreach variables.
     *     s = The `foreach` body.
     * Возвращает:
     *     `foreach (parameters; aggregate) s;` or
     *     `foreach (parameters; lower .. upper) s;`
     *     Where aggregate/lower, upper are as for the current StaticForeach.
     */
    private Инструкция2 createForeach(ref Место место, Параметры* parameters, Инструкция2 s)
    {
        if (aggrfe)
        {
            return new ForeachStatement(место, aggrfe.op, parameters, aggrfe.aggr.syntaxCopy(), s, место);
        }
        else
        {
            assert(rangefe && parameters.dim == 1);
            return new ForeachRangeStatement(место, rangefe.op, (*parameters)[0], rangefe.lwr.syntaxCopy(), rangefe.upr.syntaxCopy(), s, место);
        }
    }

    /*****************************************
     * For a `static foreach` with multiple loop variables, the
     * aggregate is lowered to an массив of tuples. As D does not have
     * built-in tuples, we need a suitable кортеж тип. This generates
     * a `struct` that serves as the кортеж тип. This тип is only
     * используется during CTFE and hence its typeinfo will not go to the
     * объект файл.
     *
     * Параметры:
     *     место = The source location.
     *     e = The Выражения we wish to store in the кортеж.
     *     sc  = The current scope.
     * Возвращает:
     *     A struct тип of the form
     *         struct Tuple
     *         {
     *             typeof(AliasSeq!(e)) кортеж;
     *         }
     */

    private TypeStruct createTupleType(ref Место место, Выражения* e, Scope* sc)
    {   // TODO: move to druntime?
        auto sid = Идентификатор2.генерируйИд("Tuple");
        auto sdecl = new StructDeclaration(место, sid, нет);
        sdecl.класс_хранения |= STC.static_;
        sdecl.члены = new Дсимволы();
        auto fid = Идентификатор2.idPool(tupleFieldName.ptr, tupleFieldName.length);
        auto ty = new TypeTypeof(место, new TupleExp(место, e));
        sdecl.члены.сунь(new VarDeclaration(место, ty, fid, null, 0));
        auto r = cast(TypeStruct)sdecl.тип;
        r.vtinfo = TypeInfoStructDeclaration.создай(r); // prevent typeinfo from going to объект файл
        return r;
    }

    /*****************************************
     * Create the AST for an instantiation of a suitable кортеж тип.
     *
     * Параметры:
     *     место = The source location.
     *     тип = A Tuple тип, created with createTupleType.
     *     e = The Выражения we wish to store in the кортеж.
     * Возвращает:
     *     An AST for the Выражение `Tuple(e)`.
     */

    private Выражение createTuple(ref Место место, TypeStruct тип, Выражения* e)
    {   // TODO: move to druntime?
        return new CallExp(место, new TypeExp(место, тип), e);
    }


    /*****************************************
     * Lower any aggregate that is not an массив to an массив using a
     * regular foreach loop within CTFE.  If there are multiple
     * `static foreach` loop variables, an массив of tuples is
     * generated. In thise case, the field `needExpansion` is set to
     * да to indicate that the static foreach loop expansion will
     * need to expand the tuples into multiple variables.
     *
     * For example, `static foreach (x; range) { ... }` is lowered to:
     *
     *     static foreach (x; {
     *         typeof({
     *             foreach (x; range) return x;
     *         }())[] __res;
     *         foreach (x; range) __res ~= x;
     *         return __res;
     *     }()) { ... }
     *
     * Finally, call `lowerArrayAggregate` to turn the produced
     * массив into an Выражение кортеж.
     *
     * Параметры:
     *     sc = The current scope.
     */

    private проц lowerNonArrayAggregate(Scope* sc)
    {
        auto nvars = aggrfe ? aggrfe.parameters.dim : 1;
        auto aloc = aggrfe ? aggrfe.aggr.место : rangefe.lwr.место;
        // We need three sets of foreach loop variables because the
        // lowering содержит three foreach loops.
        Параметры*[3] pparams = [new Параметры(), new Параметры(), new Параметры()];
        foreach (i; new бцел[0 .. nvars])
        {
            foreach (парамы; pparams)
            {
                auto p = aggrfe ? (*aggrfe.parameters)[i] : rangefe.prm;
                парамы.сунь(new Параметр2(p.классХранения, p.тип, p.идент, null, null));
            }
        }
        Выражение[2] res;
        TypeStruct tplty = null;
        if (nvars == 1) // only one `static foreach` variable, generate identifiers.
        {
            foreach (i; new бцел[0 .. 2])
            {
                res[i] = new IdentifierExp(aloc, (*pparams[i])[0].идент);
            }
        }
        else // multiple `static foreach` variables, generate tuples.
        {
            foreach (i; new бцел[0 .. 2])
            {
                auto e = new Выражения(pparams[0].dim);
                foreach (j, ref elem; *e)
                {
                    auto p = (*pparams[i])[j];
                    elem = new IdentifierExp(aloc, p.идент);
                }
                if (!tplty)
                {
                    tplty = createTupleType(aloc, e, sc);
                }
                res[i] = createTuple(aloc, tplty, e);
            }
            needExpansion = да; // need to expand the tuples later
        }
        // generate remaining code for the new aggregate which is an
        // массив (see documentation коммент).
        if (rangefe)
        {
            sc = sc.startCTFE();
            rangefe.lwr = rangefe.lwr.ВыражениеSemantic(sc);
            rangefe.lwr = resolveProperties(sc, rangefe.lwr);
            rangefe.upr = rangefe.upr.ВыражениеSemantic(sc);
            rangefe.upr = resolveProperties(sc, rangefe.upr);
            sc = sc.endCTFE();
            rangefe.lwr = rangefe.lwr.optimize(WANTvalue);
            rangefe.lwr = rangefe.lwr.ctfeInterpret();
            rangefe.upr = rangefe.upr.optimize(WANTvalue);
            rangefe.upr = rangefe.upr.ctfeInterpret();
        }
        auto s1 = new Инструкции();
        auto sfe = new Инструкции();
        if (tplty) sfe.сунь(new ExpStatement(место, tplty.sym));
        sfe.сунь(new ReturnStatement(aloc, res[0]));
        s1.сунь(createForeach(aloc, pparams[0], new CompoundStatement(aloc, sfe)));
        s1.сунь(new ExpStatement(aloc, new AssertExp(aloc, new IntegerExp(aloc, 0, Тип.tint32))));
        auto ety = new TypeTypeof(aloc, wrapAndCall(aloc, new CompoundStatement(aloc, s1)));
        auto aty = ety.arrayOf();
        auto idres = Идентификатор2.генерируйИд("__res");
        auto vard = new VarDeclaration(aloc, aty, idres, null);
        auto s2 = new Инструкции();
        s2.сунь(new ExpStatement(aloc, vard));
        auto catass = new CatAssignExp(aloc, new IdentifierExp(aloc, idres), res[1]);
        s2.сунь(createForeach(aloc, pparams[1], new ExpStatement(aloc, catass)));
        s2.сунь(new ReturnStatement(aloc, new IdentifierExp(aloc, idres)));
        auto aggr = wrapAndCall(aloc, new CompoundStatement(aloc, s2));
        sc = sc.startCTFE();
        aggr = aggr.ВыражениеSemantic(sc);
        aggr = resolveProperties(sc, aggr);
        sc = sc.endCTFE();
        aggr = aggr.optimize(WANTvalue);
        aggr = aggr.ctfeInterpret();

        assert(!!aggrfe ^ !!rangefe);
        aggrfe = new ForeachStatement(место, ТОК2.foreach_, pparams[2], aggr,
                                      aggrfe ? aggrfe._body : rangefe._body,
                                      aggrfe ? aggrfe.endloc : rangefe.endloc);
        rangefe = null;
        lowerArrayAggregate(sc); // finally, turn generated массив into Выражение кортеж
    }

    /*****************************************
     * Perform `static foreach` lowerings that are necessary in order
     * to finally expand the `static foreach` using
     * `dmd.statementsem.makeTupleForeach`.
     */
    проц prepare(Scope* sc)
    {
        assert(sc);

        if (aggrfe)
        {
            sc = sc.startCTFE();
            aggrfe.aggr = aggrfe.aggr.ВыражениеSemantic(sc);
            sc = sc.endCTFE();
            aggrfe.aggr = aggrfe.aggr.optimize(WANTvalue);
            auto tab = aggrfe.aggr.тип.toBasetype();
            if (tab.ty != Ttuple)
            {
                aggrfe.aggr = aggrfe.aggr.ctfeInterpret();
            }
        }

        if (aggrfe && aggrfe.aggr.тип.toBasetype().ty == Terror)
        {
            return;
        }

        if (!ready())
        {
            if (aggrfe && aggrfe.aggr.тип.toBasetype().ty == Tarray)
            {
                lowerArrayAggregate(sc);
            }
            else
            {
                lowerNonArrayAggregate(sc);
            }
        }
    }

    /*****************************************
     * Возвращает:
     *     `да` iff ready to call `dmd.statementsem.makeTupleForeach`.
     */
    бул ready()
    {
        return aggrfe && aggrfe.aggr && aggrfe.aggr.тип && aggrfe.aggr.тип.toBasetype().ty == Ttuple;
    }
}

/***********************************************************
 */
 class DVCondition : Condition
{
    бцел уровень;
    Идентификатор2 идент;
    Module mod;

    this(Module mod, бцел уровень, Идентификатор2 идент)
    {
        super(Место.initial);
        this.mod = mod;
        this.уровень = уровень;
        this.идент = идент;
    }

    override final Condition syntaxCopy()
    {
        return this; // don't need to копируй
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class DebugCondition : DVCondition
{
    /**
     * Add an user-supplied идентификатор to the list of глоб2 debug identifiers
     *
     * Can be called from either the driver or a `debug = Ident;` инструкция.
     * Unlike version идентификатор, there isn't any reserved debug идентификатор
     * so no validation takes place.
     *
     * Параметры:
     *   идент = идентификатор to add
     */
    deprecated//("Kept for C++ compat - Use the ткст overload instead")
    static проц addGlobalIdent(ткст0 идент)
    {
        addGlobalIdent(идент[0 .. идент.strlen]);
    }

    /// Ditto
    static проц addGlobalIdent(ткст идент)
    {
        // Overload necessary for ткст literals
        addGlobalIdent(cast(ткст)идент);
    }


    /// Ditto
    static проц addGlobalIdent(ткст идент)
    {
        if (!глоб2.debugids)
            глоб2.debugids = new Идентификаторы();
        глоб2.debugids.сунь(Идентификатор2.idPool(идент));
    }


    /**
     * Instantiate a new `DebugCondition`
     *
     * Параметры:
     *   mod = Module this узел belongs to
     *   уровень = Minimum глоб2 уровень this условие needs to pass.
     *           Only используется if `идент` is `null`.
     *   идент = Идентификатор2 required for this условие to pass.
     *           If `null`, this conditiion will use an integer уровень.
     */
    this(Module mod, бцел уровень, Идентификатор2 идент)
    {
        super(mod, уровень, идент);
    }

    override цел include(Scope* sc)
    {
        //printf("DebugCondition::include() уровень = %d, debuglevel = %d\n", уровень, глоб2.парамы.debuglevel);
        if (inc == Include.notComputed)
        {
            inc = Include.no;
            бул definedInModule = нет;
            if (идент)
            {
                if (findCondition(mod.debugids, идент))
                {
                    inc = Include.yes;
                    definedInModule = да;
                }
                else if (findCondition(глоб2.debugids, идент))
                    inc = Include.yes;
                else
                {
                    if (!mod.debugidsNot)
                        mod.debugidsNot = new Идентификаторы();
                    mod.debugidsNot.сунь(идент);
                }
            }
            else if (уровень <= глоб2.парамы.debuglevel || уровень <= mod.debuglevel)
                inc = Include.yes;
            if (!definedInModule)
                printDepsConditional(sc, this, "depsDebug ");
        }
        return (inc == Include.yes);
    }

    override DebugCondition isDebugCondition()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }

    override ткст0 вТкст0()
    {
        return идент ? идент.вТкст0() : "debug".ptr;
    }
}

/**
 * Node to represent a version условие
 *
 * A version условие is of the form:
 * ---
 * version (Идентификатор2)
 * ---
 * In user code.
 * This class also provides means to add version идентификатор
 * to the list of глоб2 (cross module) identifiers.
 */
 final class VersionCondition : DVCondition
{
    /**
     * Check if a given version идентификатор is reserved.
     *
     * Параметры:
     *   идент = идентификатор being checked
     *
     * Возвращает:
     *   `да` if it is reserved, `нет` otherwise
     */
    private static бул isReserved(ткст идент)
    {
        // This list doesn't include "D_*" versions, see the last return
        switch (идент)
        {
            case "DigitalMars":
            case "GNU":
            case "LDC":
            case "SDC":
            case "Windows":
            case "Win32":
            case "Win64":
            case "linux":
            case "OSX":
            case "iOS":
            case "TVOS":
            case "WatchOS":
            case "FreeBSD":
            case "OpenBSD":
            case "NetBSD":
            case "DragonFlyBSD":
            case "BSD":
            case "Solaris":
            case "Posix":
            case "AIX":
            case "Haiku":
            case "SkyOS":
            case "SysV3":
            case "SysV4":
            case "Hurd":
            case "Android":
            case "Emscripten":
            case "PlayStation":
            case "PlayStation4":
            case "Cygwin":
            case "MinGW":
            case "FreeStanding":
            case "X86":
            case "X86_64":
            case "ARM":
            case "ARM_Thumb":
            case "ARM_SoftFloat":
            case "ARM_SoftFP":
            case "ARM_HardFloat":
            case "AArch64":
            case "AsmJS":
            case "Epiphany":
            case "PPC":
            case "PPC_SoftFloat":
            case "PPC_HardFloat":
            case "PPC64":
            case "IA64":
            case "MIPS32":
            case "MIPS64":
            case "MIPS_O32":
            case "MIPS_N32":
            case "MIPS_O64":
            case "MIPS_N64":
            case "MIPS_EABI":
            case "MIPS_SoftFloat":
            case "MIPS_HardFloat":
            case "MSP430":
            case "NVPTX":
            case "NVPTX64":
            case "RISCV32":
            case "RISCV64":
            case "SPARC":
            case "SPARC_V8Plus":
            case "SPARC_SoftFloat":
            case "SPARC_HardFloat":
            case "SPARC64":
            case "S390":
            case "S390X":
            case "SystemZ":
            case "HPPA":
            case "HPPA64":
            case "SH":
            case "WebAssembly":
            case "WASI":
            case "Alpha":
            case "Alpha_SoftFloat":
            case "Alpha_HardFloat":
            case "LittleEndian":
            case "BigEndian":
            case "ELFv1":
            case "ELFv2":
            case "CRuntime_Bionic":
            case "CRuntime_DigitalMars":
            case "CRuntime_Glibc":
            case "CRuntime_Microsoft":
            case "CRuntime_Musl":
            case "CRuntime_UClibc":
            case "CRuntime_WASI":
            case "CppRuntime_Clang":
            case "CppRuntime_DigitalMars":
            case "CppRuntime_Gcc":
            case "CppRuntime_Microsoft":
            case "CppRuntime_Sun":
            case "unittest":
            case "assert":
            case "all":
            case "none":
                return да;

            default:
                // Anything that starts with "D_" is reserved
                return (идент.length >= 2 && идент[0 .. 2] == "D_");
        }
    }

    /**
     * Raises an error if a version идентификатор is reserved.
     *
     * Called when setting a version идентификатор, e.g. `-version=идентификатор`
     * параметр to the compiler or `version = Foo` in user code.
     *
     * Параметры:
     *   место = Where the идентификатор is set
     *   идент = идентификатор being checked (идент[$] must be '\0')
     */
    static проц checkReserved(ref Место место, ткст идент)
    {
        if (isReserved(идент))
            выведиОшибку(место, "version идентификатор `%s` is reserved and cannot be set",
                  идент.ptr);
    }

    /**
     * Add an user-supplied глоб2 идентификатор to the list
     *
     * Only called from the driver for `-version=Ident` parameters.
     * Will raise an error if the идентификатор is reserved.
     *
     * Параметры:
     *   идент = идентификатор to add
     */
    deprecated//("Kept for C++ compat - Use the ткст overload instead")
    static проц addGlobalIdent(ткст0 идент)
    {
        addGlobalIdent(идент[0 .. идент.strlen]);
    }

    /// Ditto
    static проц addGlobalIdent(ткст идент)
    {
        // Overload necessary for ткст literals
        addGlobalIdent(cast(ткст)идент);
    }


    /// Ditto
    static проц addGlobalIdent(ткст идент)
    {
        checkReserved(Место.initial, идент);
        addPredefinedGlobalIdent(идент);
    }

    /**
     * Add any глоб2 идентификатор to the list, without checking
     * if it's predefined
     *
     * Only called from the driver after platform detection,
     * and internally.
     *
     * Параметры:
     *   идент = идентификатор to add (идент[$] must be '\0')
     */
    deprecated//("Kept for C++ compat - Use the ткст overload instead")
    static проц addPredefinedGlobalIdent(ткст0 идент)
    {
        addPredefinedGlobalIdent(идент.вТкстД());
    }

    /// Ditto
    static проц addPredefinedGlobalIdent(ткст идент)
    {
        // Forward: Overload necessary for ткст literal
        addPredefinedGlobalIdent(cast(ткст)идент);
    }


    /// Ditto
    static проц addPredefinedGlobalIdent(ткст идент)
    {
        if (!глоб2.versionids)
            глоб2.versionids = new Идентификаторы();
        глоб2.versionids.сунь(Идентификатор2.idPool(идент));
    }

    /**
     * Instantiate a new `VersionCondition`
     *
     * Параметры:
     *   mod = Module this узел belongs to
     *   уровень = Minimum глоб2 уровень this условие needs to pass.
     *           Only используется if `идент` is `null`.
     *   идент = Идентификатор2 required for this условие to pass.
     *           If `null`, this conditiion will use an integer уровень.
     */
    this(Module mod, бцел уровень, Идентификатор2 идент)
    {
        super(mod, уровень, идент);
    }

    override цел include(Scope* sc)
    {
        //printf("VersionCondition::include() уровень = %d, versionlevel = %d\n", уровень, глоб2.парамы.versionlevel);
        //if (идент) printf("\tident = '%s'\n", идент.вТкст0());
        if (inc == Include.notComputed)
        {
            inc = Include.no;
            бул definedInModule = нет;
            if (идент)
            {
                if (findCondition(mod.versionids, идент))
                {
                    inc = Include.yes;
                    definedInModule = да;
                }
                else if (findCondition(глоб2.versionids, идент))
                    inc = Include.yes;
                else
                {
                    if (!mod.versionidsNot)
                        mod.versionidsNot = new Идентификаторы();
                    mod.versionidsNot.сунь(идент);
                }
            }
            else if (уровень <= глоб2.парамы.versionlevel || уровень <= mod.versionlevel)
                inc = Include.yes;
            if (!definedInModule &&
                (!идент || (!isReserved(идент.вТкст()) && идент != Id._unittest && идент != Id._assert)))
            {
                printDepsConditional(sc, this, "depsVersion ");
            }
        }
        return (inc == Include.yes);
    }

    override VersionCondition isVersionCondition()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }

    override ткст0 вТкст0()
    {
        return идент ? идент.вТкст0() : "version".ptr;
    }
}

/***********************************************************
 */
 import dmd.staticcond;
 final class StaticIfCondition : Condition
{
    Выражение exp;

    this(ref Место место, Выражение exp)
    {
        super(место);
        this.exp = exp;
    }

    override Condition syntaxCopy()
    {
        return new StaticIfCondition(место, exp.syntaxCopy());
    }

    override цел include(Scope* sc)
    {
        // printf("StaticIfCondition::include(sc = %p) this=%p inc = %d\n", sc, this, inc);

        цел errorReturn()
        {
            if (!глоб2.gag)
                inc = Include.no; // so we don't see the error message again
            return 0;
        }

        if (inc == Include.notComputed)
        {
            if (!sc)
            {
                выведиОшибку(место, "`static if` conditional cannot be at глоб2 scope");
                inc = Include.no;
                return 0;
            }

            бул errors;
            бул результат = evalStaticCondition(sc, exp, exp, errors);

            // Prevent repeated условие evaluation.
            // See: fail_compilation/fail7815.d
            if (inc != Include.notComputed)
                return (inc == Include.yes);
            if (errors)
                return errorReturn();
            if (результат)
                inc = Include.yes;
            else
                inc = Include.no;
        }
        return (inc == Include.yes);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }

    override ткст0 вТкст0()
    {
        return exp ? exp.вТкст0() : "static if".ptr;
    }
}


/****************************************
 * Find `идент` in an массив of identifiers.
 * Параметры:
 *      ids = массив of identifiers
 *      идент = идентификатор to search for
 * Возвращает:
 *      да if found
 */
бул findCondition(Идентификаторы* ids, Идентификатор2 идент)
{
    if (ids)
    {
        foreach (ид; *ids)
        {
            if (ид == идент)
                return да;
        }
    }
    return нет;
}

// Helper for printing dependency information
private проц printDepsConditional(Scope* sc, DVCondition условие, ткст depType)
{
    if (!глоб2.парамы.moduleDeps || глоб2.парамы.moduleDepsFile)
        return;
    БуфВыв* ob = глоб2.парамы.moduleDeps;
    Module imod = sc ? sc.instantiatingModule() : условие.mod;
    if (!imod)
        return;
    ob.пишиСтр(depType);
    ob.пишиСтр(imod.toPrettyChars());
    ob.пишиСтр(" (");
    escapePath(ob, imod.srcfile.вТкст0());
    ob.пишиСтр(") : ");
    if (условие.идент)
        ob.пишиСтр(условие.идент.вТкст());
    else
        ob.print(условие.уровень);
    ob.пишиБайт('\n');
}
