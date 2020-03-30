/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/дсимвол.d, _dsymbol.d)
 * Documentation:  https://dlang.org/phobos/dmd_dsymbol.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/дсимвол.d
 */

module dmd.дсимвол;

import cidrus;

import dmd.aggregate;
import dmd.aliasthis;
import dmd.arraytypes;
import dmd.attrib;
import  drc.ast.Node;
import dmd.gluelayer;
import dmd.dclass;
import dmd.declaration;
import dmd.denum;
import dmd.dimport;
import dmd.dmodule;
import dmd.dscope;
import dmd.dstruct;
import dmd.dsymbolsem;
import dmd.dtemplate;
import dmd.errors;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.init;
import drc.lexer.Lexer2;
import dmd.mtype;
import dmd.nspace;
import dmd.opover;
import util.aav;
import util.rmem;
import drc.ast.Node;
import util.speller;
import util.string;
import dmd.инструкция;
import drc.lexer.Tokens;
import drc.ast.Visitor;
import dmd.access : symbolIsVisible;

alias drc.backend.cc.Symbol Symbol;
alias dmd.dclass.ClassDeclaration ClassDeclaration;
/***************************************
 * Вызывает dg(ДСимвол *sym) для каждого ДСимвол.
 * Если dg возвращает !=0, останавливается и возвращает полученное значение, или иначе 0.
 * Параметры:
 *    символы = Дсимволы
 *    dg = делегат, вызываемый для каждого символа ДСимвол
 * Возвращает:
 *    последнее значение, возвращённое dg()
 */
цел foreachDsymbol(Дсимволы* символы, цел delegate(ДСимвол) dg)
{
    assert(dg);
    if (символы)
    {
        /* Do not use foreach, as the size of the массив may expand during iteration
         */
        for (т_мера i = 0; i < символы.dim; ++i)
        {
            ДСимвол s = (*символы)[i];
            const результат = dg(s);
            if (результат)
                return результат;
        }
    }
    return 0;
}

/***************************************
 * Calls dg(ДСимвол *sym) for each ДСимвол.
 * Параметры:
 *    символы = Дсимволы
 *    dg = delegate to call for each ДСимвол
 */
проц foreachDsymbol(Дсимволы* символы, проц delegate(ДСимвол) dg)
{
    assert(dg);
    if (символы)
    {
        /* Do not use foreach, as the size of the массив may expand during iteration
         */
        for (т_мера i = 0; i < символы.dim; ++i)
        {
            ДСимвол s = (*символы)[i];
            dg(s);
        }
    }
}


struct Ungag
{
    бцел oldgag;

    this(бцел old)
    {
        this.oldgag = old;
    }

     ~this()
    {
        глоб2.gag = oldgag;
    }
}

class Prot
{
    ///
    enum Kind : цел
    {
        undefined,
        none,           // no access
        private_,
        package_,
        protected_,
        public_,
        export_,
    }

    Kind вид;
    Package pkg;

    this(Prot.Kind вид)    
    {
        this.вид = вид;
    }

    /*extern (C++):*/

    /**
     * Checks if `this` is superset of `other` restrictions.
     * For example, "protected" is more restrictive than "public".
     */
    бул isMoreRestrictiveThan(Prot other)
    {
        return this.вид < other.вид;
    }

    /**
     * Checks if `this` is absolutely identical защита attribute to `other`
     */
    бул opEquals(ref Prot other)
    {
        if (this.вид == other.вид)
        {
            if (this.вид == Prot.Kind.package_)
                return this.pkg == other.pkg;
            return да;
        }
        return нет;
    }

    /**
     * Checks if родитель defines different access restrictions than this one.
     *
     * Параметры:
     *  родитель = защита attribute for scope that hosts this one
     *
     * Возвращает:
     *  'да' if родитель is already more restrictive than this one and thus
     *  no differentiation is needed.
     */
    бул isSubsetOf(ref Prot родитель)
    {
        if (this.вид != родитель.вид)
            return нет;
        if (this.вид == Prot.Kind.package_)
        {
            if (!this.pkg)
                return да;
            if (!родитель.pkg)
                return нет;
            if (родитель.pkg.isAncestorPackageOf(this.pkg))
                return да;
        }
        return да;
    }
}

enum PASS : цел
{
    init,           // initial state
    semantic,       // semantic() started
    semanticdone,   // semantic() done
    semantic2,      // semantic2() started
    semantic2done,  // semantic2() done
    semantic3,      // semantic3() started
    semantic3done,  // semantic3() done
    inline,         // inline started
    inlinedone,     // inline done
    obj,            // toObjFile() run
}

// Search опции
const цел

    IgnoreNone              = 0x00, // default
    IgnorePrivateImports    = 0x01, // don't search private imports
    IgnoreErrors            = 0x02, // don't give error messages
    IgnoreAmbiguous         = 0x04, // return NULL if ambiguous
    SearchLocalsOnly        = 0x08, // only look at locals (don't search imports)
    SearchImportsOnly       = 0x10, // only look in imports
    SearchUnqualifiedModule = 0x20, // the module scope search is unqualified,
                                    // meaning don't search imports in that scope,
                                    // because qualified module searches search
                                    // their imports
    IgnoreSymbolVisibility  = 0x80; // also найди private and package protected символы


 alias  цел function(ДСимвол, ук) Dsymbol_apply_ft_t;

/***********************************************************
 */
 class ДСимвол : УзелАСД
{
    Идентификатор2 идент;
    ДСимвол родитель;
    /// C++ namespace this symbol belongs to
    CPPNamespaceDeclaration cppnamespace;
    Symbol* csym;           // symbol for code generator
    Symbol* isym;           // import version of csym
    ткст0 коммент;   // documentation коммент for this ДСимвол
    const Место место;          // where defined
    Scope* _scope;          // !=null means context to use for semantic()
    ткст0 prettystring;  // cached значение of toPrettyChars()
    бул errors;            // this symbol failed to pass semantic()
    PASS semanticRun = PASS.init;

    DeprecatedDeclaration depdecl;           // customized deprecation message
    UserAttributeDeclaration userAttribDecl;    // user defined attributes

    // !=null means there's a ddoc unittest associated with this symbol
    // (only use this with ddoc)
    UnitTestDeclaration ddocUnittest;

    final this()
    {
        //printf("ДСимвол::ДСимвол(%p)\n", this);
        место = Место(null, 0, 0);
    }

    final this(Идентификатор2 идент)
    {
        //printf("ДСимвол::ДСимвол(%p, идент)\n", this);
        this.место = Место(null, 0, 0);
        this.идент = идент;
    }

    final this(ref Место место, Идентификатор2 идент)
    {
        //printf("ДСимвол::ДСимвол(%p, идент)\n", this);
        this.место = место;
        this.идент = идент;
    }

    static ДСимвол создай(Идентификатор2 идент)
    {
        return new ДСимвол(идент);
    }

    override ткст0 вТкст0()
    {
        return идент ? идент.вТкст0() : "__anonymous";
    }

    // helper to print fully qualified (template) arguments
    ткст0 toPrettyCharsHelper()
    {
        return вТкст0();
    }

    final Место getLoc()
    {
        if (!место.isValid()) // avoid bug 5861.
            if(auto m = getModule())
                return Место(m.srcfile.вТкст0(), 0, 0);
        return место;
    }

    final ткст0 locToChars()
    {
        return getLoc().вТкст0();
    }

    override бул равен(КорневойОбъект o)
    {
        if (this == o)
            return да;
        if (o.динкаст() != ДИНКАСТ.дсимвол)
            return нет;
        auto s = cast(ДСимвол)o;
        // Overload sets don't have an идент
        if (s && идент && s.идент && идент.равен(s.идент))
            return да;
        return нет;
    }

    бул isAnonymous()
    {
        return идент is null;
    }

    private ткст prettyFormatHelper()
    {
        const cstr = toPrettyChars();
        return '`' ~ cstr.вТкстД() ~ "`\0";
    }

    final проц выведиОшибку(ref Место место, ткст0 format, ...)
    {
        va_list ap;
        va_start(ap, format);
        .verror(место, format, ap, вид(), prettyFormatHelper().ptr);
        va_end(ap);
    }

    final проц выведиОшибку(ткст0 format, ...)
    {
        va_list ap;
        va_start(ap, format);
        const место = getLoc();
        .verror(место, format, ap, вид(), prettyFormatHelper().ptr);
        va_end(ap);
    }

    final проц deprecation(ref Место место, ткст0 format, ...)
    {
        va_list ap;
        va_start(ap, format);
        .vdeprecation(место, format, ap, вид(), prettyFormatHelper().ptr);
        va_end(ap);
    }

    final проц deprecation(ткст0 format, ...)
    {
        va_list ap;
        va_start(ap, format);
        const место = getLoc();
        .vdeprecation(место, format, ap, вид(), prettyFormatHelper().ptr);
        va_end(ap);
    }

    final бул checkDeprecated(ref Место место, Scope* sc)
    {
        if (глоб2.парамы.useDeprecated != DiagnosticReporting.off && isDeprecated())
        {
            // Don't complain if we're inside a deprecated symbol's scope
            if (sc.isDeprecated())
                return нет;

            ткст0 message = null;
            for (ДСимвол p = this; p; p = p.родитель)
            {
                message = p.depdecl ? p.depdecl.getMessage() : null;
                if (message)
                    break;
            }
            if (message)
                deprecation(место, "is deprecated - %s", message);
            else
                deprecation(место, "is deprecated");

            return да;
        }

        return нет;
    }

    /**********************************
     * Determine which Module a ДСимвол is in.
     */
    final Module getModule()
    {
        //printf("ДСимвол::getModule()\n");
        if (TemplateInstance ti = isInstantiated())
            return ti.tempdecl.getModule();
        ДСимвол s = this;
        while (s)
        {
            //printf("\ts = %s '%s'\n", s.вид(), s.toPrettyChars());
            Module m = s.isModule();
            if (m)
                return m;
            s = s.родитель;
        }
        return null;
    }

    /**********************************
     * Determine which Module a ДСимвол is in, as far as access rights go.
     */
    final Module getAccessModule()
    {
        //printf("ДСимвол::getAccessModule()\n");
        if (TemplateInstance ti = isInstantiated())
            return ti.tempdecl.getAccessModule();
        ДСимвол s = this;
        while (s)
        {
            //printf("\ts = %s '%s'\n", s.вид(), s.toPrettyChars());
            Module m = s.isModule();
            if (m)
                return m;
            TemplateInstance ti = s.isTemplateInstance();
            if (ti && ti.enclosing)
            {
                /* Because of local template instantiation, the родитель isn't where the access
                 * rights come from - it's the template declaration
                 */
                s = ti.tempdecl;
            }
            else
                s = s.родитель;
        }
        return null;
    }

    /**
     * `pastMixin` returns the enclosing symbol if this is a template mixin.
     *
     * `pastMixinAndNspace` does likewise, additionally skipping over Nspaces that
     * are mangleOnly.
     *
     * See also `родитель`, `toParent` and `toParent2`.
     */
    final ДСимвол pastMixin() 
    {
        //printf("ДСимвол::pastMixin() %s\n", вТкст0());
        if (!isTemplateMixin() && !isForwardingAttribDeclaration() && !isForwardingScopeDsymbol())
            return this;
        if (!родитель)
            return null;
        return родитель.pastMixin();
    }

    /**********************************
     * `родитель` field returns a lexically enclosing scope symbol this is a member of.
     *
     * `toParent()` returns a logically enclosing scope symbol this is a member of.
     * It skips over TemplateMixin's.
     *
     * `toParent2()` returns an enclosing scope symbol this is living at runtime.
     * It skips over both TemplateInstance's and TemplateMixin's.
     * It's используется when looking for the 'this' pointer of the enclosing function/class.
     *
     * `toParentDecl()` similar to `toParent2()` but always follows the template declaration scope
     * instead of the instantiation scope.
     *
     * `toParentLocal()` similar to `toParentDecl()` but follows the instantiation scope
     * if a template declaration is non-local i.e. глоб2 or static.
     *
     * Examples:
     *  module mod;
     *  template Foo(alias a) { mixin Bar!(); }
     *  mixin template Bar() {
     *    public {  // ProtDeclaration
     *      проц baz() { a = 2; }
     *    }
     *  }
     *  проц test() {
     *    цел v = 1;
     *    alias foo = Foo!(v);
     *    foo.baz();
     *    assert(v == 2);
     *  }
     *
     *  // s == FuncDeclaration('mod.test.Foo!().Bar!().baz()')
     *  // s.родитель == TemplateMixin('mod.test.Foo!().Bar!()')
     *  // s.toParent() == TemplateInstance('mod.test.Foo!()')
     *  // s.toParent2() == FuncDeclaration('mod.test')
     *  // s.toParentDecl() == Module('mod')
     *  // s.toParentLocal() == FuncDeclaration('mod.test')
     */
    final ДСимвол toParent() 
    {
        return родитель ? родитель.pastMixin() : null;
    }

    /// ditto
    final ДСимвол toParent2() 
    {
        if (!родитель || !родитель.isTemplateInstance && !родитель.isForwardingAttribDeclaration() && !родитель.isForwardingScopeDsymbol())
            return родитель;
        return родитель.toParent2;
    }

    /// ditto
    final ДСимвол toParentDecl() 
    {
        return toParentDeclImpl(нет);
    }

    /// ditto
    final ДСимвол toParentLocal() 
    {
        return toParentDeclImpl(да);
    }

    private ДСимвол toParentDeclImpl(бул localOnly) 
    {
        auto p = toParent();
        if (!p || !p.isTemplateInstance())
            return p;
        auto ti = p.isTemplateInstance();
        if (ti.tempdecl && (!localOnly || !(cast(TemplateDeclaration)ti.tempdecl).статичен_ли))
            return ti.tempdecl.toParentDeclImpl(localOnly);
        return родитель.toParentDeclImpl(localOnly);
    }

    /**
     * Возвращает the declaration scope scope of `this` unless any of the символы
     * `p1` or `p2` resides in its enclosing instantiation scope then the
     * latter is returned.
     */
    final ДСимвол toParentP(ДСимвол p1, ДСимвол p2 = null)
    {
        return followInstantiationContext(p1, p2) ? toParent2() : toParentLocal();
    }

    final TemplateInstance isInstantiated() 
    {
        if (!родитель)
            return null;
        auto ti = родитель.isTemplateInstance();
        if (ti && !ti.isTemplateMixin())
            return ti;
        return родитель.isInstantiated();
    }

    /***
     * Возвращает да if any of the символы `p1` or `p2` resides in the enclosing
     * instantiation scope of `this`.
     */
    final бул followInstantiationContext(ДСимвол p1, ДСимвол p2 = null)
    {
        static бул has2This(ДСимвол s)
        {
            if (auto f = s.isFuncDeclaration())
                return f.isThis2;
            if (auto ad = s.isAggregateDeclaration())
                return ad.vthis2 !is null;
            return нет;
        }

        if (has2This(this))
        {
            assert(p1);
            auto outer = toParent();
            while (outer)
            {
                auto ti = outer.isTemplateInstance();
                if (!ti)
                    break;
                foreach (oarg; *ti.tiargs)
                {
                    auto sa = getDsymbol(oarg);
                    if (!sa)
                        continue;
                    sa = sa.toAlias().toParent2();
                    if (!sa)
                        continue;
                    if (sa == p1)
                        return да;
                    else if (p2 && sa == p2)
                        return да;
                }
                outer = ti.tempdecl.toParent();
            }
            return нет;
        }
        return нет;
    }

    // Check if this function is a member of a template which has only been
    // instantiated speculatively, eg from inside is(typeof()).
    // Return the speculative template instance it is part of,
    // or NULL if not speculative.
    final TemplateInstance isSpeculative() 
    {
        if (!родитель)
            return null;
        auto ti = родитель.isTemplateInstance();
        if (ti && ti.gagged)
            return ti;
        if (!родитель.toParent())
            return null;
        return родитель.isSpeculative();
    }

    final Ungag ungagSpeculative()
    {
        бцел oldgag = глоб2.gag;
        if (глоб2.gag && !isSpeculative() && !toParent2().isFuncDeclaration())
            глоб2.gag = 0;
        return Ungag(oldgag);
    }

    // kludge for template.isSymbol()
    override final ДИНКАСТ динкаст()
    {
        return ДИНКАСТ.дсимвол;
    }

    /*************************************
     * Do syntax копируй of an массив of ДСимвол's.
     */
    extern (D) static Дсимволы* arraySyntaxCopy(Дсимволы* a)
    {
        Дсимволы* b = null;
        if (a)
        {
            b = a.копируй();
            for (т_мера i = 0; i < b.dim; i++)
            {
                (*b)[i] = (*b)[i].syntaxCopy(null);
            }
        }
        return b;
    }

    Идентификатор2 getIdent()
    {
        return идент;
    }

    ткст0 toPrettyChars(бул QualifyTypes = нет)
    {
        if (prettystring && !QualifyTypes)
            return prettystring;

        //printf("ДСимвол::toPrettyChars() '%s'\n", вТкст0());
        if (!родитель)
        {
            auto s = вТкст0();
            if (!QualifyTypes)
                prettystring = s;
            return s;
        }

        // Computer number of components
        т_мера complength = 0;
        for (ДСимвол p = this; p; p = p.родитель)
            ++complength;

        // Allocate temporary массив comp[]
        alias ткст T;
        auto compptr = cast(T*)Пам.check(malloc(complength * T.sizeof));
        auto comp = compptr[0 .. complength];

        // Fill in comp[] and compute length of final результат
        т_мера length = 0;
        цел i;
        for (ДСимвол p = this; p; p = p.родитель)
        {
            const s = QualifyTypes ? p.toPrettyCharsHelper() : p.вТкст0();
            const len = strlen(s);
            comp[i] = s[0 .. len];
            ++i;
            length += len + 1;
        }

        auto s = cast(сим*)mem.xmalloc_noscan(length);
        auto q = s + length - 1;
        *q = 0;
        foreach (j; new бцел[0 .. complength])
        {
            const t = comp[j].ptr;
            const len = comp[j].length;
            q -= len;
            memcpy(q, t, len);
            if (q == s)
                break;
            *--q = '.';
        }
        free(comp.ptr);
        if (!QualifyTypes)
            prettystring = s;
        return s;
    }

    ткст0 вид() 
    {
        return "symbol";
    }

    /*********************************
     * If this symbol is really an alias for another,
     * return that other.
     * If needed, semantic() is invoked due to resolve forward reference.
     */
    ДСимвол toAlias()
    {
        return this;
    }

    /*********************************
     * Resolve recursive кортеж expansion in eponymous template.
     */
    ДСимвол toAlias2()
    {
        return toAlias();
    }

    /*********************************
     * Iterate this дсимвол or члены of this scoped дсимвол, then
     * call `fp` with the found symbol and `param`.
     * Параметры:
     *  fp = function pointer to process the iterated symbol.
     *       If it returns nonzero, the iteration will be aborted.
     *  param = a параметр passed to fp.
     * Возвращает:
     *  nonzero if the iteration is aborted by the return значение of fp,
     *  or 0 if it's completed.
     */
    цел apply(Dsymbol_apply_ft_t fp, ук param)
    {
        return (*fp)(this, param);
    }

    проц addMember(Scope* sc, ScopeDsymbol sds)
    {
        //printf("ДСимвол::addMember('%s')\n", вТкст0());
        //printf("ДСимвол::addMember(this = %p, '%s' scopesym = '%s')\n", this, вТкст0(), sds.вТкст0());
        //printf("ДСимвол::addMember(this = %p, '%s' sds = %p, sds.symtab = %p)\n", this, вТкст0(), sds, sds.symtab);
        родитель = sds;
        if (!isAnonymous()) // no имя, so can't add it to symbol table
        {
            if (!sds.symtabInsert(this)) // if имя is already defined
            {
                if (isAliasDeclaration() && !_scope)
                    setScope(sc);
                ДСимвол s2 = sds.symtabLookup(this,идент);
                if (!s2.overloadInsert(this))
                {
                    sds.multiplyDefined(Место.initial, this, s2);
                    errors = да;
                }
            }
            if (sds.isAggregateDeclaration() || sds.isEnumDeclaration())
            {
                if (идент == Id.__sizeof || идент == Id.__xalignof || идент == Id._mangleof)
                {
                    выведиОшибку("`.%s` property cannot be redefined", идент.вТкст0());
                    errors = да;
                }
            }
        }
    }

    /*************************************
     * Set scope for future semantic analysis so we can
     * deal better with forward references.
     */
    проц setScope(Scope* sc)
    {
        //printf("ДСимвол::setScope() %p %s, %p stc = %llx\n", this, вТкст0(), sc, sc.stc);
        if (!sc.nofree)
            sc.setNoFree(); // may need it even after semantic() finishes
        _scope = sc;
        if (sc.depdecl)
            depdecl = sc.depdecl;
        if (!userAttribDecl)
            userAttribDecl = sc.userAttribDecl;
    }

    проц importAll(Scope* sc)
    {
    }

    /*********************************************
     * Search for идент as member of s.
     * Параметры:
     *  место = location to print for error messages
     *  идент = идентификатор to search for
     *  flags = IgnoreXXXX
     * Возвращает:
     *  null if not found
     */
    ДСимвол search(ref Место место, Идентификатор2 идент, цел flags = cast(цел) IgnoreNone)
    {
        //printf("ДСимвол::search(this=%p,%s, идент='%s')\n", this, вТкст0(), идент.вТкст0());
        return null;
    }

    extern (D) final ДСимвол search_correct(Идентификатор2 идент)
    {
        /***************************************************
         * Search for symbol with correct spelling.
         */
        extern (D) ДСимвол symbol_search_fp(ткст seed, ref цел cost)
        {
            /* If not in the lexer's ткст table, it certainly isn't in the symbol table.
             * Doing this first is a lot faster.
             */
            if (!seed.length)
                return null;
            Идентификатор2 ид = Идентификатор2.lookup(seed);
            if (!ид)
                return null;
            cost = 0;
            ДСимвол s = this;
            Module.clearCache();
            return s.search(Место.initial, ид, IgnoreErrors);
        }

        if (глоб2.gag)
            return null; // don't do it for speculative compiles; too time consuming
        // search for exact имя first
        if (auto s = search(Место.initial, идент, IgnoreErrors))
            return s;
        return speller!(symbol_search_fp)(идент.вТкст());
    }

    /***************************************
     * Search for идентификатор ид as a member of `this`.
     * `ид` may be a template instance.
     *
     * Параметры:
     *  место = location to print the error messages
     *  sc = the scope where the symbol is located
     *  ид = the ид of the symbol
     *  flags = the search flags which can be `SearchLocalsOnly` or `IgnorePrivateImports`
     *
     * Возвращает:
     *      symbol found, NULL if not
     */
    extern (D) final ДСимвол searchX(ref Место место, Scope* sc, КорневойОбъект ид, цел flags)
    {
        //printf("ДСимвол::searchX(this=%p,%s, идент='%s')\n", this, вТкст0(), идент.вТкст0());
        ДСимвол s = toAlias();
        ДСимвол sm;
        if (Declaration d = s.isDeclaration())
        {
            if (d.inuse)
            {
                .выведиОшибку(место, "circular reference to `%s`", d.toPrettyChars());
                return null;
            }
        }
        switch (ид.динкаст())
        {
        case ДИНКАСТ.идентификатор:
            sm = s.search(место, cast(Идентификатор2)ид, flags);
            break;
        case ДИНКАСТ.дсимвол:
            {
                // It's a template instance
                //printf("\ttemplate instance ид\n");
                ДСимвол st = cast(ДСимвол)ид;
                TemplateInstance ti = st.isTemplateInstance();
                sm = s.search(место, ti.имя);
                if (!sm)
                {
                    sm = s.search_correct(ti.имя);
                    if (sm)
                        .выведиОшибку(место, "template идентификатор `%s` is not a member of %s `%s`, did you mean %s `%s`?", ti.имя.вТкст0(), s.вид(), s.toPrettyChars(), sm.вид(), sm.вТкст0());
                    else
                        .выведиОшибку(место, "template идентификатор `%s` is not a member of %s `%s`", ti.имя.вТкст0(), s.вид(), s.toPrettyChars());
                    return null;
                }
                sm = sm.toAlias();
                TemplateDeclaration td = sm.isTemplateDeclaration();
                if (!td)
                {
                    .выведиОшибку(место, "`%s.%s` is not a template, it is a %s", s.toPrettyChars(), ti.имя.вТкст0(), sm.вид());
                    return null;
                }
                ti.tempdecl = td;
                if (!ti.semanticRun)
                    ti.dsymbolSemantic(sc);
                sm = ti.toAlias();
                break;
            }
        case ДИНКАСТ.тип:
        case ДИНКАСТ.Выражение:
        default:
            assert(0);
        }
        return sm;
    }

    бул overloadInsert(ДСимвол s)
    {
        //printf("ДСимвол::overloadInsert('%s')\n", s.вТкст0());
        return нет;
    }

    /*********************************
     * Возвращает:
     *  SIZE_INVALID when the size cannot be determined
     */
    d_uns64 size(ref Место место)
    {
        выведиОшибку("ДСимвол `%s` has no size", вТкст0());
        return SIZE_INVALID;
    }

    бул isforwardRef()
    {
        return нет;
    }

    // is a 'this' required to access the member
    AggregateDeclaration isThis() 
    {
        return null;
    }

    // is ДСимвол exported?
    бул isExport()
    {
        return нет;
    }

    // is ДСимвол imported?
    бул isImportedSymbol()
    {
        return нет;
    }

    // is ДСимвол deprecated?
    бул isDeprecated()
    {
        return нет;
    }

    бул перегружаем_ли()
    {
        return нет;
    }

    // is this a LabelDsymbol()?
    LabelDsymbol isLabel()
    {
        return null;
    }

    /// Возвращает an AggregateDeclaration when toParent() is that.
    final AggregateDeclaration isMember() 
    {
        //printf("ДСимвол::isMember() %s\n", вТкст0());
        auto p = toParent();
        //printf("родитель is %s %s\n", p.вид(), p.вТкст0());
        return p ? p.isAggregateDeclaration() : null;
    }

    /// Возвращает an AggregateDeclaration when toParent2() is that.
    final AggregateDeclaration isMember2()
    {
        //printf("ДСимвол::isMember2() '%s'\n", вТкст0());
        auto p = toParent2();
        //printf("родитель is %s %s\n", p.вид(), p.вТкст0());
        return p ? p.isAggregateDeclaration() : null;
    }

    /// Возвращает an AggregateDeclaration when toParentDecl() is that.
    final AggregateDeclaration isMemberDecl() 
    {
        //printf("ДСимвол::isMemberDecl() '%s'\n", вТкст0());
        auto p = toParentDecl();
        //printf("родитель is %s %s\n", p.вид(), p.вТкст0());
        return p ? p.isAggregateDeclaration() : null;
    }

    /// Возвращает an AggregateDeclaration when toParentLocal() is that.
    final AggregateDeclaration isMemberLocal()
    {
        //printf("ДСимвол::isMemberLocal() '%s'\n", вТкст0());
        auto p = toParentLocal();
        //printf("родитель is %s %s\n", p.вид(), p.вТкст0());
        return p ? p.isAggregateDeclaration() : null;
    }

    // is this a member of a ClassDeclaration?
    final ClassDeclaration isClassMember()
    {
        auto ad = isMember();
        return ad ? ad.isClassDeclaration() : null;
    }

    // is this a тип?
    Тип getType()
    {
        return null;
    }

    // need a 'this' pointer?
    бул needThis()
    {
        return нет;
    }

    /*************************************
     */
    Prot prot()  
    {
        return Prot(Prot.Kind.public_);
    }

    /**************************************
     * Copy the syntax.
     * Used for template instantiations.
     * If s is NULL, размести the new объект, otherwise fill it in.
     */
    ДСимвол syntaxCopy(ДСимвол s)
    {
        printf("%s %s\n", вид(), вТкст0());
        assert(0);
    }

    /**************************************
     * Determine if this symbol is only one.
     * Возвращает:
     *      нет, *ps = NULL: There are 2 or more символы
     *      да,  *ps = NULL: There are нуль символы
     *      да,  *ps = symbol: The one and only one symbol
     */
    бул oneMember(ДСимвол* ps, Идентификатор2 идент)
    {
        //printf("ДСимвол::oneMember()\n");
        *ps = this;
        return да;
    }

    /*****************************************
     * Same as ДСимвол::oneMember(), but look at an массив of Дсимволы.
     */
    extern (D) static бул oneMembers(Дсимволы* члены, ДСимвол* ps, Идентификатор2 идент)
    {
        //printf("ДСимвол::oneMembers() %d\n", члены ? члены.dim : 0);
        ДСимвол s = null;
        if (члены)
        {
            for (т_мера i = 0; i < члены.dim; i++)
            {
                ДСимвол sx = (*члены)[i];
                бул x = sx.oneMember(ps, идент);
                //printf("\t[%d] вид %s = %d, s = %p\n", i, sx.вид(), x, *ps);
                if (!x)
                {
                    //printf("\tfalse 1\n");
                    assert(*ps is null);
                    return нет;
                }
                if (*ps)
                {
                    assert(идент);
                    if (!(*ps).идент || !(*ps).идент.равен(идент))
                        continue;
                    if (!s)
                        s = *ps;
                    else if (s.перегружаем_ли() && (*ps).перегружаем_ли())
                    {
                        // keep head of overload set
                        FuncDeclaration f1 = s.isFuncDeclaration();
                        FuncDeclaration f2 = (*ps).isFuncDeclaration();
                        if (f1 && f2)
                        {
                            assert(!f1.isFuncAliasDeclaration());
                            assert(!f2.isFuncAliasDeclaration());
                            for (; f1 != f2; f1 = f1.overnext0)
                            {
                                if (f1.overnext0 is null)
                                {
                                    f1.overnext0 = f2;
                                    break;
                                }
                            }
                        }
                    }
                    else // more than one symbol
                    {
                        *ps = null;
                        //printf("\tfalse 2\n");
                        return нет;
                    }
                }
            }
        }
        *ps = s; // s is the one symbol, null if none
        //printf("\ttrue\n");
        return да;
    }

    проц setFieldOffset(AggregateDeclaration ad, бцел* poffset, бул isunion)
    {
    }

    /*****************************************
     * Is ДСимвол a variable that содержит pointers?
     */
    бул hasPointers()
    {
        //printf("ДСимвол::hasPointers() %s\n", вТкст0());
        return нет;
    }

    бул hasStaticCtorOrDtor()
    {
        //printf("ДСимвол::hasStaticCtorOrDtor() %s\n", вТкст0());
        return нет;
    }

    проц addLocalClass(ClassDeclarations*)
    {
    }

    проц addObjcSymbols(ClassDeclarations* classes, ClassDeclarations* categories)
    {
    }

    проц checkCtorConstInit()
    {
    }

    /****************************************
     * Add documentation коммент to ДСимвол.
     * Ignore NULL comments.
     */
    проц добавьКоммент(ткст0 коммент)
    {
        //if (коммент)
        //    printf("adding коммент '%s' to symbol %p '%s'\n", коммент, this, вТкст0());
        if (!this.коммент)
            this.коммент = коммент;
        else if (коммент && strcmp(cast(сим*)коммент, cast(сим*)this.коммент) != 0)
        {
            // Concatenate the two
            this.коммент = Lexer.combineComments(this.коммент.вТкстД(), коммент.вТкстД(), да);
        }
    }

    /****************************************
     * Возвращает да if this symbol is defined in a non-root module without instantiation.
     */
    final бул inNonRoot()
    {
        ДСимвол s = родитель;
        for (; s; s = s.toParent())
        {
            if (auto ti = s.isTemplateInstance())
            {
                return нет;
            }
            if (auto m = s.isModule())
            {
                if (!m.isRoot())
                    return да;
                break;
            }
        }
        return нет;
    }

    /************
     */
    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }

 
    // Eliminate need for dynamic_cast
    Package                     isPackage()                      { return null; }
    Module                      isModule()                       { return null; }
    EnumMember                  isEnumMember()                   { return null; }
    TemplateDeclaration         isTemplateDeclaration()          { return null; }
    TemplateInstance            isTemplateInstance()             { return null; }
    TemplateMixin               isTemplateMixin()                { return null; }
    ForwardingAttribDeclaration isForwardingAttribDeclaration()  { return null; }
    Nspace                      isNspace()                       { return null; }
    Declaration                 isDeclaration()                  { return null; }
    StorageClassDeclaration     isStorageClassDeclaration()      { return null; }
    ВыражениеDsymbol           isВыражениеDsymbol()            { return null; }
    ThisDeclaration            isThisDeclaration()              { return null; }
    TypeInfoDeclaration         isTypeInfoDeclaration()          { return null; }
    TupleDeclaration            isTupleDeclaration()             { return null; }
    AliasDeclaration           isAliasDeclaration()             { return null; }
    AggregateDeclaration       isAggregateDeclaration()         { return null; }
    FuncDeclaration             isFuncDeclaration()              { return null; }
    FuncAliasDeclaration        isFuncAliasDeclaration()         { return null; }
    OverDeclaration             isOverDeclaration()              { return null; }
    FuncLiteralDeclaration     isFuncLiteralDeclaration()       { return null; }
    CtorDeclaration             isCtorDeclaration()              { return null; }
    PostBlitDeclaration         isPostBlitDeclaration()          { return null; }
    DtorDeclaration             isDtorDeclaration()              { return null; }
    StaticCtorDeclaration       isStaticCtorDeclaration()        { return null; }
    StaticDtorDeclaration       isStaticDtorDeclaration()        { return null; }
    SharedStaticCtorDeclaration isSharedStaticCtorDeclaration()  { return null; }
    SharedStaticDtorDeclaration isSharedStaticDtorDeclaration()  { return null; }
    InvariantDeclaration        isInvariantDeclaration()         { return null; }
    UnitTestDeclaration         isUnitTestDeclaration()          { return null; }
    NewDeclaration              isNewDeclaration()               { return null; }
    VarDeclaration              isVarDeclaration()               { return null; }
    ClassDeclaration            isClassDeclaration()             { return null; }
    StructDeclaration           isStructDeclaration()            { return null; }
    UnionDeclaration            isUnionDeclaration()             { return null; }
    InterfaceDeclaration        isInterfaceDeclaration()         { return null; }
    ScopeDsymbol                isScopeDsymbol()                 { return null; }
    ForwardingScopeDsymbol      isForwardingScopeDsymbol()       { return null; }
    WithScopeSymbol             isWithScopeSymbol()              { return null; }
    ArrayScopeSymbol            isArrayScopeSymbol()             { return null; }
    Импорт                      isImport()                       { return null; }
    EnumDeclaration             isEnumDeclaration()              { return null; }
    SymbolDeclaration           isSymbolDeclaration()            { return null; }
    AttribDeclaration           isAttribDeclaration()            { return null; }
    AnonDeclaration             isAnonDeclaration()              { return null; }
    CPPNamespaceDeclaration     isCPPNamespaceDeclaration()      { return null; }
    ProtDeclaration             isProtDeclaration()              { return null; }
    OverloadSet                isOverloadSet()                  { return null; }
    CompileDeclaration          isCompileDeclaration()           { return null; }
}

/***********************************************************
 * ДСимвол that generates a scope
 */
 class ScopeDsymbol : ДСимвол
{
    Дсимволы* члены;          // all ДСимвол's in this scope
    DsymbolTable symtab;        // члены[] sorted into table
    бцел endlinnum;             // the linnumber of the инструкция after the scope (0 if unknown)

private:
    /// символы whose члены have been imported, i.e. imported modules and template mixins
    Дсимволы* importedScopes;
    Prot.Kind* prots;            // массив of Prot.Kind, one for each import

    import util.bitarray;
    МассивБит accessiblePackages, privateAccessiblePackages;// whitelists of accessible (imported) пакеты

public:
    final this()
    {
    }

    final this(Идентификатор2 идент)
    {
        super(идент);
    }

    final this(ref Место место, Идентификатор2 идент)
    {
        super(место, идент);
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        //printf("ScopeDsymbol::syntaxCopy('%s')\n", вТкст0());
        ScopeDsymbol sds = s ? cast(ScopeDsymbol)s : new ScopeDsymbol(идент);
        sds.коммент = коммент;
        sds.члены = arraySyntaxCopy(члены);
        sds.endlinnum = endlinnum;
        return sds;
    }

    /*****************************************
     * This function is #1 on the list of functions that eat cpu time.
     * Be very, very careful about slowing it down.
     */
    override ДСимвол search(ref Место место, Идентификатор2 идент, цел flags = cast(цел) SearchLocalsOnly)
    {
        //printf("%s.ScopeDsymbol::search(идент='%s', flags=x%x)\n", вТкст0(), идент.вТкст0(), flags);
        //if (strcmp(идент.вТкст0(),"c") == 0) *(сим*)0=0;

        // Look in символы declared in this module
        if (symtab && !(flags & SearchImportsOnly))
        {
            //printf(" look in locals\n");
            auto s1 = symtab.lookup(идент);
            if (s1)
            {
                //printf("\tfound in locals = '%s.%s'\n",вТкст0(),s1.вТкст0());
                return s1;
            }
        }
        //printf(" not found in locals\n");

        // Look in imported scopes
        if (!importedScopes)
            return null;

        //printf(" look in imports\n");
        ДСимвол s = null;
        OverloadSet a = null;
        // Look in imported modules
        for (т_мера i = 0; i < importedScopes.dim; i++)
        {
            // If private import, don't search it
            if ((flags & IgnorePrivateImports) && prots[i] == Prot.Kind.private_)
                continue;
            цел sflags = flags & (IgnoreErrors | IgnoreAmbiguous); // remember these in recursive searches
            ДСимвол ss = (*importedScopes)[i];
            //printf("\tscanning import '%s', prots = %d, isModule = %p, isImport = %p\n", ss.вТкст0(), prots[i], ss.isModule(), ss.isImport());

            if (ss.isModule())
            {
                if (flags & SearchLocalsOnly)
                    continue;
            }
            else // mixin template
            {
                if (flags & SearchImportsOnly)
                    continue;

                sflags |= SearchLocalsOnly;
            }

            /* Don't найди private члены if ss is a module
             */
            ДСимвол s2 = ss.search(место, идент, sflags | (ss.isModule() ? IgnorePrivateImports : IgnoreNone));
              if (!s2 || !(flags & IgnoreSymbolVisibility) && !symbolIsVisible(this, s2))
                continue;
            if (!s)
            {
                s = s2;
                if (s && s.isOverloadSet())
                    a = mergeOverloadSet(идент, a, s);
            }
            else if (s2 && s != s2)
            {
                if (s.toAlias() == s2.toAlias() || s.getType() == s2.getType() && s.getType())
                {
                    /* After following ники, we found the same
                     * symbol, so it's not an ambiguity.  But if one
                     * alias is deprecated or less accessible, prefer
                     * the other.
                     */
                    if (s.isDeprecated() || s.prot().isMoreRestrictiveThan(s2.prot()) && s2.prot().вид != Prot.Kind.none)
                        s = s2;
                }
                else
                {
                    /* Two imports of the same module should be regarded as
                     * the same.
                     */
                    Импорт i1 = s.isImport();
                    Импорт i2 = s2.isImport();
                    if (!(i1 && i2 && (i1.mod == i2.mod || (!i1.родитель.isImport() && !i2.родитель.isImport() && i1.идент.равен(i2.идент)))))
                    {
                        /* https://issues.dlang.org/show_bug.cgi?ид=8668
                         * Public selective import adds AliasDeclaration in module.
                         * To make an overload set, resolve ники in here and
                         * get actual overload roots which accessible via s and s2.
                         */
                        s = s.toAlias();
                        s2 = s2.toAlias();
                        /* If both s2 and s are overloadable (though we only
                         * need to check s once)
                         */

                        auto so2 = s2.isOverloadSet();
                        if ((so2 || s2.перегружаем_ли()) && (a || s.перегружаем_ли()))
                        {
                            if (symbolIsVisible(this, s2))
                            {
                                a = mergeOverloadSet(идент, a, s2);
                            }
                            if (!symbolIsVisible(this, s))
                                s = s2;
                            continue;
                        }

                        /* Two different overflow sets can have the same члены
                         * https://issues.dlang.org/show_bug.cgi?ид=16709
                         */
                        auto so = s.isOverloadSet();
                        if (so && so2)
                        {
                            if (so.a.length == so2.a.length)
                            {
                                foreach (j; new бцел[0 .. so.a.length])
                                {
                                    if (so.a[j] !is so2.a[j])
                                        goto L1;
                                }
                                continue;  // the same
                              L1:
                                {   } // different
                            }
                        }

                        if (flags & IgnoreAmbiguous) // if return NULL on ambiguity
                            return null;
                        if (!(flags & IgnoreErrors))
                            ScopeDsymbol.multiplyDefined(место, s, s2);
                        break;
                    }
                }
            }
        }
        if (s)
        {
            /* Build special symbol if we had multiple finds
             */
            if (a)
            {
                if (!s.isOverloadSet())
                    a = mergeOverloadSet(идент, a, s);
                s = a;
            }
            //printf("\tfound in imports %s.%s\n", вТкст0(), s.вТкст0());
            return s;
        }
        //printf(" not found in imports\n");
        return null;
    }

    private OverloadSet mergeOverloadSet(Идентификатор2 идент, OverloadSet ос, ДСимвол s)
    {
        if (!ос)
        {
            ос = new OverloadSet(идент);
            ос.родитель = this;
        }
        if (OverloadSet os2 = s.isOverloadSet())
        {
            // Merge the cross-module overload set 'os2' into 'ос'
            if (ос.a.dim == 0)
            {
                ос.a.устДим(os2.a.dim);
                memcpy(ос.a.tdata(), os2.a.tdata(), (ос.a[0]).sizeof * os2.a.dim);
            }
            else
            {
                for (т_мера i = 0; i < os2.a.dim; i++)
                {
                    ос = mergeOverloadSet(идент, ос, os2.a[i]);
                }
            }
        }
        else
        {
            assert(s.перегружаем_ли());
            /* Don't add to ос[] if s is alias of previous sym
             */
            for (т_мера j = 0; j < ос.a.dim; j++)
            {
                ДСимвол s2 = ос.a[j];
                if (s.toAlias() == s2.toAlias())
                {
                    if (s2.isDeprecated() || (s2.prot().isMoreRestrictiveThan(s.prot()) && s.prot().вид != Prot.Kind.none))
                    {
                        ос.a[j] = s;
                    }
                    goto Lcontinue;
                }
            }
            ос.сунь(s);

        }
       Lcontinue:
        return ос;
    }

    проц importScope(ДСимвол s, Prot защита)
    {
        //printf("%s.ScopeDsymbol::importScope(%s, %d)\n", вТкст0(), s.вТкст0(), защита);
        // No circular or redundant import's
        if (s != this)
        {
            if (!importedScopes)
                importedScopes = new Дсимволы();
            else
            {
                for (т_мера i = 0; i < importedScopes.dim; i++)
                {
                    ДСимвол ss = (*importedScopes)[i];
                    if (ss == s) // if already imported
                    {
                        if (защита.вид > prots[i])
                            prots[i] = защита.вид; // upgrade access
                        return;
                    }
                }
            }
            importedScopes.сунь(s);
            prots = cast(Prot.Kind*)mem.xrealloc(prots, importedScopes.dim * (prots[0]).sizeof);
            prots[importedScopes.dim - 1] = защита.вид;
        }
    }

    final проц addAccessiblePackage(Package p, Prot защита)
    {
        auto pary = защита.вид == Prot.Kind.private_ ? &privateAccessiblePackages : &accessiblePackages;
        if (pary.length <= p.tag)
            pary.length = p.tag + 1;
        (*pary)[p.tag] = да;
    }

    бул isPackageAccessible(Package p, Prot защита, цел flags = 0)
    {
        if (p.tag < accessiblePackages.length && accessiblePackages[p.tag] ||
            защита.вид == Prot.Kind.private_ && p.tag < privateAccessiblePackages.length && privateAccessiblePackages[p.tag])
            return да;
        foreach (i, ss; importedScopes ? (*importedScopes)[] : null)
        {
            // only search visible scopes && imported modules should ignore private imports
            if (защита.вид <= prots[i] &&
                ss.isScopeDsymbol.isPackageAccessible(p, защита, IgnorePrivateImports))
                return да;
        }
        return нет;
    }

    override final бул isforwardRef()
    {
        return (члены is null);
    }

    static проц multiplyDefined(ref Место место, ДСимвол s1, ДСимвол s2)
    {
        version (none)
        {
            printf("ScopeDsymbol::multiplyDefined()\n");
            printf("s1 = %p, '%s' вид = '%s', родитель = %s\n", s1, s1.вТкст0(), s1.вид(), s1.родитель ? s1.родитель.вТкст0() : "");
            printf("s2 = %p, '%s' вид = '%s', родитель = %s\n", s2, s2.вТкст0(), s2.вид(), s2.родитель ? s2.родитель.вТкст0() : "");
        }
        if (место.isValid())
        {
            .выведиОшибку(место, "%s `%s` at %s conflicts with %s `%s` at %s",
                s1.вид(), s1.toPrettyChars(), s1.locToChars(),
                s2.вид(), s2.toPrettyChars(), s2.locToChars());

            static if (0)
            {
                if (auto so = s1.isOverloadSet())
                {
                    printf("first %p:\n", so);
                    foreach (s; so.a[])
                    {
                        printf("  %p %s `%s` at %s\n", s, s.вид(), s.toPrettyChars(), s.locToChars());
                    }
                }
                if (auto so = s2.isOverloadSet())
                {
                    printf("second %p:\n", so);
                    foreach (s; so.a[])
                    {
                        printf("  %p %s `%s` at %s\n", s, s.вид(), s.toPrettyChars(), s.locToChars());
                    }
                }
            }
        }
        else
        {
            s1.выведиОшибку(s1.место, "conflicts with %s `%s` at %s", s2.вид(), s2.toPrettyChars(), s2.locToChars());
        }
    }

    override ткст0 вид()
    {
        return "ScopeDsymbol";
    }

    /*******************************************
     * Look for member of the form:
     *      const(MemberInfo)[] getMembers(ткст);
     * Возвращает NULL if not found
     */
    final FuncDeclaration findGetMembers()
    {
        ДСимвол s = search_function(this, Id.getmembers);
        FuncDeclaration fdx = s ? s.isFuncDeclaration() : null;
        version (none)
        {
            // Finish
             TypeFunction tfgetmembers;
            if (!tfgetmembers)
            {
                Scope sc;
                auto parameters = new Параметры();
                Параметры* p = new Параметр2(STC.in_, Тип.tchar.constOf().arrayOf(), null, null);
                parameters.сунь(p);
                Тип tret = null;
                tfgetmembers = new TypeFunction(parameters, tret, ВарАрг.none, LINK.d);
                tfgetmembers = cast(TypeFunction)tfgetmembers.dsymbolSemantic(Место.initial, &sc);
            }
            if (fdx)
                fdx = fdx.overloadExactMatch(tfgetmembers);
        }
        if (fdx && fdx.isVirtual())
            fdx = null;
        return fdx;
    }

    ДСимвол symtabInsert(ДСимвол s)
    {
        return symtab.вставь(s);
    }

    /****************************************
     * Look up идентификатор in symbol table.
     */

    ДСимвол symtabLookup(ДСимвол s, Идентификатор2 ид)
    {
        return symtab.lookup(ид);
    }

    /****************************************
     * Return да if any of the члены are static ctors or static dtors, or if
     * any члены have члены that are.
     */
    override бул hasStaticCtorOrDtor()
    {
        if (члены)
        {
            for (т_мера i = 0; i < члены.dim; i++)
            {
                ДСимвол member = (*члены)[i];
                if (member.hasStaticCtorOrDtor())
                    return да;
            }
        }
        return нет;
    }

    extern (D) alias цел delegate(т_мера idx, ДСимвол s) ForeachDg;

    /***************************************
     * Expands attribute declarations in члены in depth first
     * order. Calls dg(т_мера symidx, ДСимвол *sym) for each
     * member.
     * If dg returns !=0, stops and returns that значение else returns 0.
     * Use this function to avoid the O(N + N^2/2) complexity of
     * calculating dim and calling N times getNth.
     * Возвращает:
     *  last значение returned by dg()
     */
    extern (D) static цел _foreach(Scope* sc, Дсимволы* члены, ForeachDg dg, т_мера* pn = null)
    {
        assert(dg);
        if (!члены)
            return 0;
        т_мера n = pn ? *pn : 0; // take over index
        цел результат = 0;
        foreach (т_мера i; new бцел[0 .. члены.dim])
        {
            ДСимвол s = (*члены)[i];
            if (AttribDeclaration a = s.isAttribDeclaration())
                результат = _foreach(sc, a.include(sc), dg, &n);
            else if (TemplateMixin tm = s.isTemplateMixin())
                результат = _foreach(sc, tm.члены, dg, &n);
            else if (s.isTemplateInstance())
            {
            }
            else if (s.isUnitTestDeclaration())
            {
            }
            else
                результат = dg(n++, s);
            if (результат)
                break;
        }
        if (pn)
            *pn = n; // update index
        return результат;
    }

    override final ScopeDsymbol isScopeDsymbol()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * With инструкция scope
 */
 final class WithScopeSymbol : ScopeDsymbol
{
    WithStatement withstate;

    this(WithStatement withstate)
    {
        this.withstate = withstate;
    }

    override ДСимвол search(ref Место место, Идентификатор2 идент, цел flags = SearchLocalsOnly)
    {
        //printf("WithScopeSymbol.search(%s)\n", идент.вТкст0());
        if (flags & SearchImportsOnly)
            return null;
        // Acts as proxy to the with class declaration
        ДСимвол s = null;
        Выражение eold = null;
        for (Выражение e = withstate.exp; e != eold; e = resolveAliasThis(_scope, e))
        {
            if (e.op == ТОК2.scope_)
            {
                s = (cast(ScopeExp)e).sds;
            }
            else if (e.op == ТОК2.тип)
            {
                s = e.тип.toDsymbol(null);
            }
            else
            {
                Тип t = e.тип.toBasetype();
                s = t.toDsymbol(null);
            }
            if (s)
            {
                s = s.search(место, идент, flags);
                if (s)
                    return s;
            }
            eold = e;
        }
        return null;
    }

    override WithScopeSymbol isWithScopeSymbol()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * МассивДРК Index/Slice scope
 */
 final class ArrayScopeSymbol : ScopeDsymbol
{
    Выражение exp;         // IndexExp or SliceExp
    КортежТипов тип;         // for кортеж[length]
    TupleDeclaration td;    // for tuples of objects
    Scope* sc;

    this(Scope* sc, Выражение exp)
    {
        super(exp.место, null);
        assert(exp.op == ТОК2.index || exp.op == ТОК2.slice || exp.op == ТОК2.массив);
        this.exp = exp;
        this.sc = sc;
    }

    this(Scope* sc, КортежТипов тип)
    {
        this.тип = тип;
        this.sc = sc;
    }

    this(Scope* sc, TupleDeclaration td)
    {
        this.td = td;
        this.sc = sc;
    }

    override ДСимвол search(ref Место место, Идентификатор2 идент, цел flags = IgnoreNone)
    {
        //printf("ArrayScopeSymbol::search('%s', flags = %d)\n", идент.вТкст0(), flags);
        if (идент != Id.dollar)
            return null;

        VarDeclaration* pvar;
        Выражение ce;
    L1:
        if (td)
        {
            /* $ gives the number of elements in the кортеж
             */
            auto v = new VarDeclaration(место, Тип.tт_мера, Id.dollar, null);
            Выражение e = new IntegerExp(Место.initial, td.objects.dim, Тип.tт_мера);
            v._иниц = new ExpInitializer(Место.initial, e);
            v.класс_хранения |= STC.temp | STC.static_ | STC.const_;
            v.dsymbolSemantic(sc);
            return v;
        }
        if (тип)
        {
            /* $ gives the number of тип entries in the тип кортеж
             */
            auto v = new VarDeclaration(место, Тип.tт_мера, Id.dollar, null);
            Выражение e = new IntegerExp(Место.initial, тип.arguments.dim, Тип.tт_мера);
            v._иниц = new ExpInitializer(Место.initial, e);
            v.класс_хранения |= STC.temp | STC.static_ | STC.const_;
            v.dsymbolSemantic(sc);
            return v;
        }
        if (exp.op == ТОК2.index)
        {
            /* массив[index] where index is some function of $
             */
            IndexExp ie = cast(IndexExp)exp;
            pvar = &ie.lengthVar;
            ce = ie.e1;
        }
        else if (exp.op == ТОК2.slice)
        {
            /* массив[lwr .. upr] where lwr or upr is some function of $
             */
            SliceExp se = cast(SliceExp)exp;
            pvar = &se.lengthVar;
            ce = se.e1;
        }
        else if (exp.op == ТОК2.массив)
        {
            /* массив[e0, e1, e2, e3] where e0, e1, e2 are some function of $
             * $ is a opDollar!(dim)() where dim is the dimension(0,1,2,...)
             */
            ArrayExp ae = cast(ArrayExp)exp;
            pvar = &ae.lengthVar;
            ce = ae.e1;
        }
        else
        {
            /* Didn't найди $, look in enclosing scope(s).
             */
            return null;
        }
        while (ce.op == ТОК2.comma)
            ce = (cast(CommaExp)ce).e2;
        /* If we are indexing into an массив that is really a тип
         * кортеж, rewrite this as an index into a тип кортеж and
         * try again.
         */
        if (ce.op == ТОК2.тип)
        {
            Тип t = (cast(TypeExp)ce).тип;
            if (t.ty == Ttuple)
            {
                тип = cast(КортежТипов)t;
                goto L1;
            }
        }
        /* *pvar is lazily initialized, so if we refer to $
         * multiple times, it gets set only once.
         */
        if (!*pvar) // if not already initialized
        {
            /* Create variable v and set it to the значение of $
             */
            VarDeclaration v;
            Тип t;
            if (ce.op == ТОК2.кортеж)
            {
                /* It is for an Выражение кортеж, so the
                 * length will be a const.
                 */
                Выражение e = new IntegerExp(Место.initial, (cast(TupleExp)ce).exps.dim, Тип.tт_мера);
                v = new VarDeclaration(место, Тип.tт_мера, Id.dollar, new ExpInitializer(Место.initial, e));
                v.класс_хранения |= STC.temp | STC.static_ | STC.const_;
            }
            else if (ce.тип && (t = ce.тип.toBasetype()) !is null && (t.ty == Tstruct || t.ty == Tclass))
            {
                // Look for opDollar
                assert(exp.op == ТОК2.массив || exp.op == ТОК2.slice);
                AggregateDeclaration ad = isAggregate(t);
                assert(ad);
                ДСимвол s = ad.search(место, Id.opDollar);
                if (!s) // no dollar exists -- search in higher scope
                    return null;
                s = s.toAlias();
                Выражение e = null;
                // Check for multi-dimensional opDollar(dim) template.
                if (TemplateDeclaration td = s.isTemplateDeclaration())
                {
                    dinteger_t dim = 0;
                    if (exp.op == ТОК2.массив)
                    {
                        dim = (cast(ArrayExp)exp).currentDimension;
                    }
                    else if (exp.op == ТОК2.slice)
                    {
                        dim = 0; // slices are currently always one-dimensional
                    }
                    else
                    {
                        assert(0);
                    }
                    auto tiargs = new Объекты();
                    Выражение edim = new IntegerExp(Место.initial, dim, Тип.tт_мера);
                    edim = edim.ВыражениеSemantic(sc);
                    tiargs.сунь(edim);
                    e = new DotTemplateInstanceExp(место, ce, td.идент, tiargs);
                }
                else
                {
                    /* opDollar exists, but it's not a template.
                     * This is acceptable ONLY for single-dimension indexing.
                     * Note that it's impossible to have both template & function opDollar,
                     * because both take no arguments.
                     */
                    if (exp.op == ТОК2.массив && (cast(ArrayExp)exp).arguments.dim != 1)
                    {
                        exp.выведиОшибку("`%s` only defines opDollar for one dimension", ad.вТкст0());
                        return null;
                    }
                    Declaration d = s.isDeclaration();
                    assert(d);
                    e = new DotVarExp(место, ce, d);
                }
                e = e.ВыражениеSemantic(sc);
                if (!e.тип)
                    exp.выведиОшибку("`%s` has no значение", e.вТкст0());
                t = e.тип.toBasetype();
                if (t && t.ty == Tfunction)
                    e = new CallExp(e.место, e);
                v = new VarDeclaration(место, null, Id.dollar, new ExpInitializer(Место.initial, e));
                v.класс_хранения |= STC.temp | STC.ctfe | STC.rvalue;
            }
            else
            {
                /* For arrays, $ will either be a compile-time constant
                 * (in which case its значение in set during constant-folding),
                 * or a variable (in which case an Выражение is created in
                 * toir.c).
                 */
                auto e = new VoidInitializer(Место.initial);
                e.тип = Тип.tт_мера;
                v = new VarDeclaration(место, Тип.tт_мера, Id.dollar, e);
                v.класс_хранения |= STC.temp | STC.ctfe; // it's never a да static variable
            }
            *pvar = v;
        }
        (*pvar).dsymbolSemantic(sc);
        return (*pvar);
    }

    override ArrayScopeSymbol isArrayScopeSymbol()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * Overload Sets
 */
 final class OverloadSet : ДСимвол
{
    Дсимволы a;     // массив of Дсимволы

    this(Идентификатор2 идент, OverloadSet ос = null)
    {
        super(идент);
        if (ос)
        {
            a.суньСрез(ос.a[]);
        }
    }

    проц сунь(ДСимвол s)
    {
        a.сунь(s);
    }

    override OverloadSet isOverloadSet() 
    {
        return this;
    }

    override ткст0 вид()
    {
        return "overloadset";
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * Forwarding ScopeDsymbol.  Used by ForwardingAttribDeclaration and
 * ForwardingScopeDeclaration to forward symbol insertions to another
 * scope.  See `dmd.attrib.ForwardingAttribDeclaration` for more
 * details.
 */
 final class ForwardingScopeDsymbol : ScopeDsymbol
{
    /*************************
     * Symbol to forward insertions to.
     * Can be `null` before being lazily initialized.
     */
    ScopeDsymbol forward;
    this(ScopeDsymbol forward)
    {
        super(null);
        this.forward = forward;
    }
    override ДСимвол symtabInsert(ДСимвол s)
    {
        assert(forward);
        if (auto d = s.isDeclaration())
        {
            if (d.класс_хранения & STC.local)
            {
                // Symbols with storage class STC.local are not
                // forwarded, but stored in the local symbol
                // table. (Those are the `static foreach` variables.)
                if (!symtab)
                {
                    symtab = new DsymbolTable();
                }
                return super.symtabInsert(s); // вставь locally
            }
        }
        if (!forward.symtab)
        {
            forward.symtab = new DsymbolTable();
        }
        // Non-STC.local символы are forwarded to `forward`.
        return forward.symtabInsert(s);
    }

    /************************
     * This override handles the following two cases:
     *     static foreach (i, i; [0]) { ... }
     * and
     *     static foreach (i; [0]) { enum i = 2; }
     */
    override ДСимвол symtabLookup(ДСимвол s, Идентификатор2 ид)
    {
        assert(forward);
        // correctly diagnose clashing foreach loop variables.
        if (auto d = s.isDeclaration())
        {
            if (d.класс_хранения & STC.local)
            {
                if (!symtab)
                {
                    symtab = new DsymbolTable();
                }
                return super.symtabLookup(s,ид);
            }
        }
        // Declarations within `static foreach` do not clash with
        // `static foreach` loop variables.
        if (!forward.symtab)
        {
            forward.symtab = new DsymbolTable();
        }
        return forward.symtabLookup(s,ид);
    }

    override проц importScope(ДСимвол s, Prot защита)
    {
        forward.importScope(s, защита);
    }

    override ткст0 вид(){ return "local scope"; }

    override ForwardingScopeDsymbol isForwardingScopeDsymbol()
    {
        return this;
    }

}

/**
 * Class that holds an Выражение in a ДСимвол wraper.
 * This is not an AST узел, but a class используется to pass
 * an Выражение as a function параметр of тип ДСимвол.
 */
 final class ВыражениеDsymbol : ДСимвол
{
    Выражение exp;
    this(Выражение exp)
    {
        super();
        this.exp = exp;
    }

    override ВыражениеDsymbol isВыражениеDsymbol() 
    {
        return this;
    }
}


/***********************************************************
 * Table of ДСимвол's
 */
 final class DsymbolTable : КорневойОбъект
{
    AssocArray!(Идентификатор2, ДСимвол) tab;

    // Look up Идентификатор2. Return ДСимвол if found, NULL if not.
    ДСимвол lookup(Идентификатор2 идент)
    {
        //printf("DsymbolTable::lookup(%s)\n", идент.вТкст0());
        return tab[идент];
    }

    // Insert ДСимвол in table. Return NULL if already there.
    ДСимвол вставь(ДСимвол s)
    {
        //printf("DsymbolTable::вставь(this = %p, '%s')\n", this, s.идент.вТкст0());
        return вставь(s.идент, s);
    }

    // Look for ДСимвол in table. If there, return it. If not, вставь s and return that.
    ДСимвол update(ДСимвол s)
    {
        const идент = s.идент;
        ДСимвол* ps = tab.getLvalue(идент);
        *ps = s;
        return s;
    }

    // when идент and s are not the same
    ДСимвол вставь(Идентификатор2 идент, ДСимвол s)
    {
        //printf("DsymbolTable::вставь()\n");
        ДСимвол* ps = tab.getLvalue(идент);
        if (*ps)
            return null; // already in table
        *ps = s;
        return s;
    }

    /*****
     * Возвращает:
     *  number of символы in symbol table
     */
    бцел len() 
    {
        return cast(бцел)tab.length;
    }
}
