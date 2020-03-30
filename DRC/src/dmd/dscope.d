/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/dscope.d, _dscope.d)
 * Documentation:  https://dlang.org/phobos/dmd_dscope.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/dscope.d
 */

module dmd.dscope;

import cidrus;

import dmd.aggregate;
import dmd.arraytypes;
import dmd.attrib;
import dmd.ctorflow;
import dmd.dclass;
import dmd.declaration;
import dmd.dmodule;
import drc.doc.Doc2;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.dtemplate;
import drc.ast.Expression;
import dmd.errors;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import util.outbuffer;
import util.rmem;
import util.speller;
import dmd.инструкция;
import drc.lexer.Tokens;
import dmd.mtype;
//version=LOGSEARCH;


// Flags that would not be inherited beyond scope nesting
enum SCOPE
{
    ctor          = 0x0001,   /// constructor тип
    noaccesscheck = 0x0002,   /// don't do access checks
    условие     = 0x0004,   /// inside static if/assert условие
    debug_        = 0x0008,   /// inside debug conditional
    constraint    = 0x0010,   /// inside template constraint
    invariant_    = 0x0020,   /// inside invariant code
    require       = 0x0040,   /// inside in contract code
    ensure        = 0x0060,   /// inside out contract code
    contract      = 0x0060,   /// [mask] we're inside contract code
    ctfe          = 0x0080,   /// inside a ctfe-only Выражение
    compile       = 0x0100,   /// inside __traits(compile)
    ignoresymbolvisibility    = 0x0200,   /// ignore symbol visibility
                                          /// https://issues.dlang.org/show_bug.cgi?ид=15907
    onlysafeaccess = 0x0400,  /// unsafe access is not allowed for  code
    free          = 0x8000,   /// is on free list

    fullinst      = 0x10000,  /// fully instantiate templates
    alias_        = 0x20000,  /// inside alias declaration.
}

// Flags that are carried along with a scope сунь()
const SCOPEpush = SCOPE.contract | SCOPE.debug_ | SCOPE.ctfe | SCOPE.compile | SCOPE.constraint |
                 SCOPE.noaccesscheck | SCOPE.onlysafeaccess | SCOPE.ignoresymbolvisibility;

struct Scope
{
    Scope* enclosing;               /// enclosing Scope

    Module _module;                 /// Root module
    ScopeDsymbol scopesym;          /// current symbol
    FuncDeclaration func;           /// function we are in
    ДСимвол родитель;                 /// родитель to use
    LabelStatement slabel;          /// enclosing labelled инструкция
    SwitchStatement sw;             /// enclosing switch инструкция
    Инструкция2 tryBody;              /// enclosing _body of TryCatchStatement or TryFinallyStatement
    TryFinallyStatement tf;         /// enclosing try finally инструкция
    ScopeGuardStatement ос;            /// enclosing scope(xxx) инструкция
    Инструкция2 sbreak;               /// enclosing инструкция that supports "break"
    Инструкция2 scontinue;            /// enclosing инструкция that supports "continue"
    ForeachStatement fes;           /// if nested function for ForeachStatement, this is it
    Scope* callsc;                  /// используется for __FUNCTION__, __PRETTY_FUNCTION__ and __MODULE__
    ДСимвол inunion;                /// != null if processing члены of a union
    бул nofree;                    /// да if shouldn't free it
    бул inLoop;                    /// да if inside a loop (where constructor calls aren't allowed)
    цел intypeof;                   /// in typeof(exp)
    VarDeclaration lastVar;         /// Previous symbol используется to prevent goto-skips-init

    /* If  minst && !tinst, it's in definitely non-speculative scope (eg. module member scope).
     * If !minst && !tinst, it's in definitely speculative scope (eg. template constraint).
     * If  minst &&  tinst, it's in instantiated code scope without speculation.
     * If !minst &&  tinst, it's in instantiated code scope with speculation.
     */
    Module minst;                   /// root module where the instantiated templates should belong to
    TemplateInstance tinst;         /// enclosing template instance

    CtorFlow ctorflow;              /// flow analysis for constructors

    /// alignment for struct члены
    AlignDeclaration aligndecl;

    /// C++ namespace this symbol is in
    CPPNamespaceDeclaration namespace;

    /// компонаж for external functions
    LINK компонаж = LINK.d;

    /// mangle тип
    CPPMANGLE cppmangle = CPPMANGLE.def;

    /// inlining strategy for functions
    PINLINE inlining = PINLINE.default_;

    /// защита for class члены
    Prot защита = Prot(Prot.Kind.public_);
    цел explicitProtection;         /// set if in an explicit защита attribute

    КлассХранения stc;               /// storage class

    DeprecatedDeclaration depdecl;  /// customized deprecation message

    бцел flags;

    // user defined attributes
    UserAttributeDeclaration userAttribDecl;

    DocComment* lastdc;        /// documentation коммент for last symbol at this scope
    бцел[ук] anchorCounts;  /// lookup duplicate anchor имя count
    Идентификатор2 prevAnchor;     /// qualified symbol имя of last doc anchor

    extern (D)  Scope* freelist;

    extern (D) static Scope* alloc()
    {
        if (freelist)
        {
            Scope* s = freelist;
            freelist = s.enclosing;
            //printf("freelist %p\n", s);
            assert(s.flags & SCOPE.free);
            s.flags &= ~SCOPE.free;
            return s;
        }
        return new Scope();
    }

    extern (D) static Scope* createGlobal(Module _module)
    {
        Scope* sc = Scope.alloc();
        *sc = Scope.init;
        sc._module = _module;
        sc.minst = _module;
        sc.scopesym = new ScopeDsymbol();
        sc.scopesym.symtab = new DsymbolTable();
        // Add top уровень package as member of this глоб2 scope
        ДСимвол m = _module;
        while (m.родитель)
            m = m.родитель;
        m.addMember(null, sc.scopesym);
        m.родитель = null; // got changed by addMember()
        // Create the module scope underneath the глоб2 scope
        sc = sc.сунь(_module);
        sc.родитель = _module;
        return sc;
    }

     Scope* копируй()
    {
        Scope* sc = Scope.alloc();
        *sc = this;
        /* https://issues.dlang.org/show_bug.cgi?ид=11777
         * The copied scope should not inherit fieldinit.
         */
        sc.ctorflow.fieldinit = null;
        return sc;
    }

     Scope* сунь()
    {
        Scope* s = копируй();
        //printf("Scope::сунь(this = %p) new = %p\n", this, s);
        assert(!(flags & SCOPE.free));
        s.scopesym = null;
        s.enclosing = &this;
        debug
        {
            if (enclosing)
                assert(!(enclosing.flags & SCOPE.free));
            if (s == enclosing)
            {
                printf("this = %p, enclosing = %p, enclosing.enclosing = %p\n", s, &this, enclosing);
            }
            assert(s != enclosing);
        }
        s.slabel = null;
        s.nofree = нет;
        s.ctorflow.fieldinit = ctorflow.fieldinit.arraydup;
        s.flags = (flags & SCOPEpush);
        s.lastdc = null;
        assert(&this != s);
        return s;
    }

     Scope* сунь(ScopeDsymbol ss)
    {
        //printf("Scope::сунь(%s)\n", ss.вТкст0());
        Scope* s = сунь();
        s.scopesym = ss;
        return s;
    }

     Scope* вынь()
    {
        //printf("Scope::вынь() %p nofree = %d\n", this, nofree);
        if (enclosing)
            enclosing.ctorflow.OR(ctorflow);
        ctorflow.freeFieldinit();

        Scope* enc = enclosing;
        if (!nofree)
        {
            if (mem.смИниц_ли)
                this = this.init;
            enclosing = freelist;
            freelist = &this;
            flags |= SCOPE.free;
        }
        return enc;
    }

    /*************************
     * Similar to вынь(), but the результатs in `this` are not folded
     * into `enclosing`.
     */
    extern (D) проц detach()
    {
        ctorflow.freeFieldinit();
        enclosing = null;
        вынь();
    }

     Scope* startCTFE()
    {
        Scope* sc = this.сунь();
        sc.flags = this.flags | SCOPE.ctfe;
        version (none)
        {
            /* TODO: Currently this is not possible, because we need to
             * unspeculative some types and symbols if they are necessary for the
             * final executable. Consider:
             *
             * struct S(T) {
             *   ткст вТкст(){ return "instantiated"; }
             * }
             * enum x = S!цел();
             * проц main() {
             *   // To call x.вТкст in runtime, compiler should unspeculative S!цел.
             *   assert(x.вТкст() == "instantiated");
             * }
             */
            // If a template is instantiated from CT evaluated Выражение,
            // compiler can elide its code generation.
            sc.tinst = null;
            sc.minst = null;
        }
        return sc;
    }

     Scope* endCTFE()
    {
        assert(flags & SCOPE.ctfe);
        return вынь();
    }


    /*******************************
     * Merge результатs of `ctorflow` into `this`.
     * Параметры:
     *   место = for error messages
     *   ctorflow = flow результатs to merge in
     */
    extern (D) проц merge(ref Место место, ref CtorFlow ctorflow)
    {
        if (!mergeCallSuper(this.ctorflow.callSuper, ctorflow.callSuper))
            выведиОшибку(место, "one path skips constructor");

        const fies = ctorflow.fieldinit;
        if (this.ctorflow.fieldinit.length && fies.length)
        {
            FuncDeclaration f = func;
            if (fes)
                f = fes.func;
            auto ad = f.isMemberDecl();
            assert(ad);
            foreach (i, v; ad.fields)
            {
                бул mustInit = (v.класс_хранения & STC.nodefaultctor || v.тип.needsNested());
                auto fieldInit = &this.ctorflow.fieldinit[i];
                const fiesCurrent = fies[i];
                if (fieldInit.место is Место.init)
                    fieldInit.место = fiesCurrent.место;
                if (!mergeFieldInit(this.ctorflow.fieldinit[i].csx, fiesCurrent.csx) && mustInit)
                {
                    выведиОшибку(место, "one path skips field `%s`", v.вТкст0());
                }
            }
        }
    }

     Module instantiatingModule()
    {
        // TODO: in speculative context, returning 'module' is correct?
        return minst ? minst : _module;
    }

    /************************************
     * Perform unqualified имя lookup by following the chain of scopes up
     * until found.
     *
     * Параметры:
     *  место = location to use for error messages
     *  идент = имя to look up
     *  pscopesym = if supplied and имя is found, set to scope that идент was found in
     *  flags = modify search based on flags
     *
     * Возвращает:
     *  symbol if found, null if not
     */
     ДСимвол search(ref Место место, Идентификатор2 идент, ДСимвол* pscopesym, цел flags = IgnoreNone)
    {
        version (LOGSEARCH)
        {
            printf("Scope.search(%p, '%s' flags=x%x)\n", &this, идент.вТкст0(), flags);
            // Print scope chain
            for (Scope* sc = &this; sc; sc = sc.enclosing)
            {
                if (!sc.scopesym)
                    continue;
                printf("\tscope %s\n", sc.scopesym.вТкст0());
            }

            static проц printMsg(ткст txt, ДСимвол s)
            {
                printf("%.*s  %s.%s, вид = '%s'\n", cast(цел)txt.length, txt.ptr,
                    s.родитель ? s.родитель.вТкст0() : "", s.вТкст0(), s.вид());
            }
        }

        // This function is called only for unqualified lookup
        assert(!(flags & (SearchLocalsOnly | SearchImportsOnly)));

        /* If идент is "start at module scope", only look at module scope
         */
        if (идент == Id.empty)
        {
            // Look for module scope
            for (Scope* sc = &this; sc; sc = sc.enclosing)
            {
                assert(sc != sc.enclosing);
                if (!sc.scopesym)
                    continue;
                if (ДСимвол s = sc.scopesym.isModule())
                {
                    //printMsg("\tfound", s);
                    if (pscopesym)
                        *pscopesym = sc.scopesym;
                    return s;
                }
            }
            return null;
        }

        ДСимвол checkAliasThis(AggregateDeclaration ad, Идентификатор2 идент, цел flags, Выражение* exp)
        {
             if (!ad || !ad.aliasthis)
                return null;

            Declaration decl = ad.aliasthis.sym.isDeclaration();
            if (!decl)
                return null;

            Тип t = decl.тип;
            ScopeDsymbol sds;
            TypeClass tc;
            TypeStruct ts;
            switch(t.ty)
            {
                case Tstruct:
                    ts = cast(TypeStruct)t;
                    sds = ts.sym;
                    break;
                case Tclass:
                    tc = cast(TypeClass)t;
                    sds = tc.sym;
                    break;
                case Tinstance:
                    sds = (cast(TypeInstance)t).tempinst;
                    break;
                case Tenum:
                    sds = (cast(TypeEnum)t).sym;
                    break;
                default: break;
            }

            if (!sds)
                return null;

            ДСимвол ret = sds.search(место, идент, flags);
            if (ret)
            {
                *exp = new DotIdExp(место, *exp, ad.aliasthis.идент);
                *exp = new DotIdExp(место, *exp, идент);
                return ret;
            }

            if (!ts && !tc)
                return null;

            ДСимвол s;
            *exp = new DotIdExp(место, *exp, ad.aliasthis.идент);
            if (ts && !(ts.att & AliasThisRec.tracing))
            {
                ts.att = cast(AliasThisRec)(ts.att | AliasThisRec.tracing);
                s = checkAliasThis(sds.isAggregateDeclaration(), идент, flags, exp);
                ts.att = cast(AliasThisRec)(ts.att & ~AliasThisRec.tracing);
            }
            else if(tc && !(tc.att & AliasThisRec.tracing))
            {
                tc.att = cast(AliasThisRec)(tc.att | AliasThisRec.tracing);
                s = checkAliasThis(sds.isAggregateDeclaration(), идент, flags, exp);
                tc.att = cast(AliasThisRec)(tc.att & ~AliasThisRec.tracing);
            }
            return s;
        }

        ДСимвол searchScopes(цел flags)
        {
            for (Scope* sc = &this; sc; sc = sc.enclosing)
            {
                assert(sc != sc.enclosing);
                if (!sc.scopesym)
                    continue;
                //printf("\tlooking in scopesym '%s', вид = '%s', flags = x%x\n", sc.scopesym.вТкст0(), sc.scopesym.вид(), flags);

                if (sc.scopesym.isModule())
                    flags |= SearchUnqualifiedModule;        // tell Module.search() that SearchLocalsOnly is to be obeyed

                if (ДСимвол s = sc.scopesym.search(место, идент, flags))
                {
                    if (!(flags & (SearchImportsOnly | IgnoreErrors)) &&
                        идент == Id.length && sc.scopesym.isArrayScopeSymbol() &&
                        sc.enclosing && sc.enclosing.search(место, идент, null, flags))
                    {
                        warning(s.место, "массив `length` hides other `length` имя in outer scope");
                    }
                    //printMsg("\tfound local", s);
                    if (pscopesym)
                        *pscopesym = sc.scopesym;
                    return s;
                }

                if (глоб2.парамы.fixAliasThis)
                {
                    Выражение exp = new ThisExp(место);
                    ДСимвол aliasSym = checkAliasThis(sc.scopesym.isAggregateDeclaration(), идент, flags, &exp);
                    if (aliasSym)
                    {
                        //printf("found aliassym: %s\n", aliasSym.вТкст0());
                        if (pscopesym)
                            *pscopesym = new ВыражениеDsymbol(exp);
                        return aliasSym;
                    }
                }

                // Stop when we hit a module, but keep going if that is not just under the глоб2 scope
                if (sc.scopesym.isModule() && !(sc.enclosing && !sc.enclosing.enclosing))
                    break;
            }
            return null;
        }

        if (this.flags & SCOPE.ignoresymbolvisibility)
            flags |= IgnoreSymbolVisibility;

        // First look in local scopes
        ДСимвол s = searchScopes(flags | SearchLocalsOnly);
        version (LOGSEARCH) if (s) printMsg("-Scope.search() found local", s);
        if (!s)
        {
            // Second look in imported modules
            s = searchScopes(flags | SearchImportsOnly);
            version (LOGSEARCH) if (s) printMsg("-Scope.search() found import", s);
        }
        return s;
    }

    extern (D) ДСимвол search_correct(Идентификатор2 идент)
    {
        if (глоб2.gag)
            return null; // don't do it for speculative compiles; too time consuming

        /************************************************
         * Given the failed search attempt, try to найди
         * one with a close spelling.
         */
        extern (D) ДСимвол scope_search_fp(ткст seed, ref цел cost)
        {
            //printf("scope_search_fp('%s')\n", seed);
            /* If not in the lexer's ткст table, it certainly isn't in the symbol table.
             * Doing this first is a lot faster.
             */
            if (!seed.length)
                return null;
            Идентификатор2 ид = Идентификатор2.lookup(seed);
            if (!ид)
                return null;
            Scope* sc = &this;
            Module.clearCache();
            ДСимвол scopesym = null;
            ДСимвол s = sc.search(Место.initial, ид, &scopesym, IgnoreErrors);
            if (s)
            {
                for (cost = 0; sc; sc = sc.enclosing, ++cost)
                    if (sc.scopesym == scopesym)
                        break;
                if (scopesym != s.родитель)
                {
                    ++cost; // got to the symbol through an import
                    if (s.prot().вид == Prot.Kind.private_)
                        return null;
                }
            }
            return s;
        }

        ДСимвол scopesym = null;
        // search for exact имя first
        if (auto s = search(Место.initial, идент, &scopesym, IgnoreErrors))
            return s;
        return speller!(scope_search_fp)(идент.вТкст());
    }

    /************************************
     * Maybe `идент` was a C or C++ имя. Check for that,
     * and suggest the D equivalent.
     * Параметры:
     *  идент = unknown идентификатор
     * Возвращает:
     *  D идентификатор ткст if found, null if not
     */
    extern (D) static ткст0 search_correct_C(Идентификатор2 идент)
    {
        ТОК2 tok;
        if (идент == Id.NULL)
            tok = ТОК2.null_;
        else if (идент == Id.TRUE)
            tok = ТОК2.true_;
        else if (идент == Id.FALSE)
            tok = ТОК2.false_;
        else if (идент == Id.unsigned)
            tok = ТОК2.uns32;
        else if (идент == Id.wchar_t)
            tok = глоб2.парамы.isWindows ? ТОК2.wchar_ : ТОК2.dchar_;
        else
            return null;
        return Сема2.вТкст0(tok);
    }

    extern (D) ДСимвол вставь(ДСимвол s)
    {
        if (VarDeclaration vd = s.isVarDeclaration())
        {
            if (lastVar)
                vd.lastVar = lastVar;
            lastVar = vd;
        }
        else if (WithScopeSymbol ss = s.isWithScopeSymbol())
        {
            if (VarDeclaration vd = ss.withstate.wthis)
            {
                if (lastVar)
                    vd.lastVar = lastVar;
                lastVar = vd;
            }
            return null;
        }
        for (Scope* sc = &this; sc; sc = sc.enclosing)
        {
            //printf("\tsc = %p\n", sc);
            if (sc.scopesym)
            {
                //printf("\t\tsc.scopesym = %p\n", sc.scopesym);
                if (!sc.scopesym.symtab)
                    sc.scopesym.symtab = new DsymbolTable();
                return sc.scopesym.symtabInsert(s);
            }
        }
        assert(0);
    }

    /********************************************
     * Search enclosing scopes for ClassDeclaration.
     */
     ClassDeclaration getClassScope()
    {
        for (Scope* sc = &this; sc; sc = sc.enclosing)
        {
            if (!sc.scopesym)
                continue;
            ClassDeclaration cd = sc.scopesym.isClassDeclaration();
            if (cd)
                return cd;
        }
        return null;
    }

    /********************************************
     * Search enclosing scopes for ClassDeclaration.
     */
     AggregateDeclaration getStructClassScope()
    {
        for (Scope* sc = &this; sc; sc = sc.enclosing)
        {
            if (!sc.scopesym)
                continue;
            AggregateDeclaration ad = sc.scopesym.isClassDeclaration();
            if (ad)
                return ad;
            ad = sc.scopesym.isStructDeclaration();
            if (ad)
                return ad;
        }
        return null;
    }

    /*******************************************
     * For TemplateDeclarations, we need to remember the Scope
     * where it was declared. So mark the Scope as not
     * to be free'd.
     */
    extern (D) проц setNoFree()
    {
        //цел i = 0;
        //printf("Scope::setNoFree(this = %p)\n", this);
        for (Scope* sc = &this; sc; sc = sc.enclosing)
        {
            //printf("\tsc = %p\n", sc);
            sc.nofree = да;
            assert(!(flags & SCOPE.free));
            //assert(sc != sc.enclosing);
            //assert(!sc.enclosing || sc != sc.enclosing.enclosing);
            //if (++i == 10)
            //    assert(0);
        }
    }

    this(ref Scope sc)
    {
        this._module = sc._module;
        this.scopesym = sc.scopesym;
        this.enclosing = sc.enclosing;
        this.родитель = sc.родитель;
        this.sw = sc.sw;
        this.tryBody = sc.tryBody;
        this.tf = sc.tf;
        this.ос = sc.ос;
        this.tinst = sc.tinst;
        this.minst = sc.minst;
        this.sbreak = sc.sbreak;
        this.scontinue = sc.scontinue;
        this.fes = sc.fes;
        this.callsc = sc.callsc;
        this.aligndecl = sc.aligndecl;
        this.func = sc.func;
        this.slabel = sc.slabel;
        this.компонаж = sc.компонаж;
        this.cppmangle = sc.cppmangle;
        this.inlining = sc.inlining;
        this.защита = sc.защита;
        this.explicitProtection = sc.explicitProtection;
        this.stc = sc.stc;
        this.depdecl = sc.depdecl;
        this.inunion = sc.inunion;
        this.nofree = sc.nofree;
        this.inLoop = sc.inLoop;
        this.intypeof = sc.intypeof;
        this.lastVar = sc.lastVar;
        this.ctorflow = sc.ctorflow;
        this.flags = sc.flags;
        this.lastdc = sc.lastdc;
        this.anchorCounts = sc.anchorCounts;
        this.prevAnchor = sc.prevAnchor;
        this.userAttribDecl = sc.userAttribDecl;
    }

    structalign_t alignment()
    {
        if (aligndecl)
            return aligndecl.getAlignment(&this);
        else
            return STRUCTALIGN_DEFAULT;
    }

    /**********************************
    * Checks whether the current scope (or any of its parents) is deprecated.
    *
    * Возвращает: `да` if this or any родитель scope is deprecated, `нет` otherwise`
    */
    /*extern(C++)*/ бул isDeprecated()
    {
        for (ДСимвол* sp = &(this.родитель); *sp; sp = &(sp.родитель))
        {
            if (sp.isDeprecated())
                return да;
        }
        for (Scope* sc2 = &this; sc2; sc2 = sc2.enclosing)
        {
            if (sc2.scopesym && sc2.scopesym.isDeprecated())
                return да;

            // If inside a StorageClassDeclaration that is deprecated
            if (sc2.stc & STC.deprecated_)
                return да;
        }
        if (_module.md && _module.md.isdeprecated)
        {
            return да;
        }
        return нет;
    }
}
