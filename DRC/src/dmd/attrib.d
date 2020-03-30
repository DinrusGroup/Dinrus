/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/attrib.d, _attrib.d)
 * Documentation:  https://dlang.org/phobos/dmd_attrib.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/attrib.d
 */

module dmd.attrib;

import dmd.aggregate;
import dmd.arraytypes;
import dmd.cond;
import dmd.declaration;
import dmd.dmodule;
import dmd.dscope;
import dmd.дсимвол;
import dmd.dsymbolsem : dsymbolSemantic;
import drc.ast.Expression;
import dmd.expressionsem : arrayВыражениеSemantic;
import dmd.func;
import dmd.globals;
import dmd.hdrgen : protectionToBuffer;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.mtype;
import dmd.objc; // for objc.addSymbols
import util.outbuffer;
import dmd.target; // for target.systemLinkage
import drc.lexer.Tokens;
import drc.ast.Visitor;

/***********************************************************
 */
 abstract class AttribDeclaration : ДСимвол
{
    Дсимволы* decl;     // массив of ДСимвол's

    this(Дсимволы* decl)
    {
        this.decl = decl;
    }

    this(ref Место место, Идентификатор2 идент, Дсимволы* decl)
    {
        super(место, идент);
        this.decl = decl;
    }

    Дсимволы* include(Scope* sc)
    {
        if (errors)
            return null;

        return decl;
    }

    override final цел apply(Dsymbol_apply_ft_t fp, ук param)
    {
        return include(_scope).foreachDsymbol( (s) { return s && s.apply(fp, param); } );
    }

    /****************************************
     * Create a new scope if one or more given attributes
     * are different from the sc's.
     * If the returned scope != sc, the caller should вынь
     * the scope after it используется.
     */
    extern (D) static Scope* createNewScope(Scope* sc, КлассХранения stc, LINK компонаж,
        CPPMANGLE cppmangle, Prot защита, цел explicitProtection,
        AlignDeclaration aligndecl, PINLINE inlining)
    {
        Scope* sc2 = sc;
        if (stc != sc.stc ||
            компонаж != sc.компонаж ||
            cppmangle != sc.cppmangle ||
            !защита.isSubsetOf(sc.защита) ||
            explicitProtection != sc.explicitProtection ||
            aligndecl !is sc.aligndecl ||
            inlining != sc.inlining)
        {
            // создай new one for changes
            sc2 = sc.копируй();
            sc2.stc = stc;
            sc2.компонаж = компонаж;
            sc2.cppmangle = cppmangle;
            sc2.защита = защита;
            sc2.explicitProtection = explicitProtection;
            sc2.aligndecl = aligndecl;
            sc2.inlining = inlining;
        }
        return sc2;
    }

    /****************************************
     * A hook point to supply scope for члены.
     * addMember, setScope, importAll, semantic, semantic2 and semantic3 will use this.
     */
    Scope* newScope(Scope* sc)
    {
        return sc;
    }

    override проц addMember(Scope* sc, ScopeDsymbol sds)
    {
        Дсимволы* d = include(sc);
        if (d)
        {
            Scope* sc2 = newScope(sc);
            d.foreachDsymbol(/* s => */s.addMember(sc2, sds) );
            if (sc2 != sc)
                sc2.вынь();
        }
    }

    override проц setScope(Scope* sc)
    {
        Дсимволы* d = include(sc);
        //printf("\tAttribDeclaration::setScope '%s', d = %p\n",вТкст0(), d);
        if (d)
        {
            Scope* sc2 = newScope(sc);
            d.foreachDsymbol( /* s => */s.setScope(sc2) );
            if (sc2 != sc)
                sc2.вынь();
        }
    }

    override проц importAll(Scope* sc)
    {
        Дсимволы* d = include(sc);
        //printf("\tAttribDeclaration::importAll '%s', d = %p\n", вТкст0(), d);
        if (d)
        {
            Scope* sc2 = newScope(sc);
            d.foreachDsymbol( /* s => */s.importAll(sc2) );
            if (sc2 != sc)
                sc2.вынь();
        }
    }

    override проц добавьКоммент(ткст0 коммент)
    {
        //printf("AttribDeclaration::добавьКоммент %s\n", коммент);
        if (коммент)
        {
            include(null).foreachDsymbol( /* s => */ s.добавьКоммент(коммент) );
        }
    }

    override ткст0 вид()
    {
        return "attribute";
    }

    override бул oneMember(ДСимвол* ps, Идентификатор2 идент)
    {
        Дсимволы* d = include(null);
        return ДСимвол.oneMembers(d, ps, идент);
    }

    override проц setFieldOffset(AggregateDeclaration ad, бцел* poffset, бул isunion)
    {
        include(null).foreachDsymbol(/* s => */ s.setFieldOffset(ad, poffset, isunion) );
    }

    override final бул hasPointers()
    {
        return include(null).foreachDsymbol( (s) { return s.hasPointers(); } ) != 0;
    }

    override final бул hasStaticCtorOrDtor()
    {
        return include(null).foreachDsymbol( (s) { return s.hasStaticCtorOrDtor(); } ) != 0;
    }

    override final проц checkCtorConstInit()
    {
        include(null).foreachDsymbol( /* s => */ s.checkCtorConstInit() );
    }

    /****************************************
     */
    override final проц addLocalClass(ClassDeclarations* aclasses)
    {
        include(null).foreachDsymbol( /* s => */ s.addLocalClass(aclasses) );
    }

    override final проц addObjcSymbols(ClassDeclarations* classes, ClassDeclarations* categories)
    {
        objc.addSymbols(this, classes, categories);
    }

    override final AttribDeclaration isAttribDeclaration()
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
 class StorageClassDeclaration : AttribDeclaration
{
    КлассХранения stc;

    this(КлассХранения stc, Дсимволы* decl)
    {
        super(decl);
        this.stc = stc;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        return new StorageClassDeclaration(stc, ДСимвол.arraySyntaxCopy(decl));
    }

    override Scope* newScope(Scope* sc)
    {
        КлассХранения scstc = sc.stc;
        /* These sets of storage classes are mutually exclusive,
         * so choose the innermost or most recent one.
         */
        if (stc & (STC.auto_ | STC.scope_ | STC.static_ | STC.extern_ | STC.manifest))
            scstc &= ~(STC.auto_ | STC.scope_ | STC.static_ | STC.extern_ | STC.manifest);
        if (stc & (STC.auto_ | STC.scope_ | STC.static_ | STC.tls | STC.manifest | STC.gshared))
            scstc &= ~(STC.auto_ | STC.scope_ | STC.static_ | STC.tls | STC.manifest | STC.gshared);
        if (stc & (STC.const_ | STC.immutable_ | STC.manifest))
            scstc &= ~(STC.const_ | STC.immutable_ | STC.manifest);
        if (stc & (STC.gshared | STC.shared_ | STC.tls))
            scstc &= ~(STC.gshared | STC.shared_ | STC.tls);
        if (stc & (STC.safe | STC.trusted | STC.system))
            scstc &= ~(STC.safe | STC.trusted | STC.system);
        scstc |= stc;
        //printf("scstc = x%llx\n", scstc);
        return createNewScope(sc, scstc, sc.компонаж, sc.cppmangle,
            sc.защита, sc.explicitProtection, sc.aligndecl, sc.inlining);
    }

    override final бул oneMember(ДСимвол* ps, Идентификатор2 идент)
    {
        бул t = ДСимвол.oneMembers(decl, ps, идент);
        if (t && *ps)
        {
            /* This is to deal with the following case:
             * struct Tick {
             *   template to(T) { const T to() { ... } }
             * }
             * For eponymous function templates, the 'const' needs to get attached to 'to'
             * before the semantic analysis of 'to', so that template overloading based on the
             * 'this' pointer can be successful.
             */
            FuncDeclaration fd = (*ps).isFuncDeclaration();
            if (fd)
            {
                /* Use storage_class2 instead of класс_хранения otherwise when we do .di generation
                 * we'll wind up with 'const const' rather than 'const'.
                 */
                /* Don't think we need to worry about mutually exclusive storage classes here
                 */
                fd.storage_class2 |= stc;
            }
        }
        return t;
    }

    override проц addMember(Scope* sc, ScopeDsymbol sds)
    {
        Дсимволы* d = include(sc);
        if (d)
        {
            Scope* sc2 = newScope(sc);

            d.foreachDsymbol( (s)
            {
                //printf("\taddMember %s to %s\n", s.вТкст0(), sds.вТкст0());
                // STC.local needs to be attached before the member is added to the scope (because it influences the родитель symbol)
                if (auto decl = s.isDeclaration())
                {
                    decl.класс_хранения |= stc & STC.local;
                    if (auto sdecl = s.isStorageClassDeclaration()) // TODO: why is this not enough to deal with the nested case?
                    {
                        sdecl.stc |= stc & STC.local;
                    }
                }
                s.addMember(sc2, sds);
            });

            if (sc2 != sc)
                sc2.вынь();
        }

    }

    override StorageClassDeclaration isStorageClassDeclaration()
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
 final class DeprecatedDeclaration : StorageClassDeclaration
{
    Выражение msg;
    ткст0 msgstr;

    this(Выражение msg, Дсимволы* decl)
    {
        super(STC.deprecated_, decl);
        this.msg = msg;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        return new DeprecatedDeclaration(msg.syntaxCopy(), ДСимвол.arraySyntaxCopy(decl));
    }

    /**
     * Provides a new scope with `STC.deprecated_` and `Scope.depdecl` set
     *
     * Calls `StorageClassDeclaration.newScope` (as it must be called or copied
     * in any function overriding `newScope`), then set the `Scope`'s depdecl.
     *
     * Возвращает:
     *   Always a new scope, to use for this `DeprecatedDeclaration`'s члены.
     */
    override Scope* newScope(Scope* sc)
    {
        auto scx = super.newScope(sc);
        // The enclosing scope is deprecated as well
        if (scx == sc)
            scx = sc.сунь();
        scx.depdecl = this;
        return scx;
    }

    override проц setScope(Scope* sc)
    {
        //printf("DeprecatedDeclaration::setScope() %p\n", this);
        if (decl)
            ДСимвол.setScope(sc); // for forward reference
        return AttribDeclaration.setScope(sc);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class LinkDeclaration : AttribDeclaration
{
    LINK компонаж;

    this(LINK компонаж, Дсимволы* decl)
    {
        super(decl);
        //printf("LinkDeclaration(компонаж = %d, decl = %p)\n", компонаж, decl);
        this.компонаж = (компонаж == LINK.system) ? target.systemLinkage() : компонаж;
    }

    static LinkDeclaration создай(LINK p, Дсимволы* decl)
    {
        return new LinkDeclaration(p, decl);
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        return new LinkDeclaration(компонаж, ДСимвол.arraySyntaxCopy(decl));
    }

    override Scope* newScope(Scope* sc)
    {
        return createNewScope(sc, sc.stc, this.компонаж, sc.cppmangle, sc.защита, sc.explicitProtection,
            sc.aligndecl, sc.inlining);
    }

    override ткст0 вТкст0()
    {
        return вТкст().ptr;
    }

    extern(D) override ткст вТкст()
    {
        return "extern ()";
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class CPPMangleDeclaration : AttribDeclaration
{
    CPPMANGLE cppmangle;

    this(CPPMANGLE cppmangle, Дсимволы* decl)
    {
        super(decl);
        //printf("CPPMangleDeclaration(cppmangle = %d, decl = %p)\n", cppmangle, decl);
        this.cppmangle = cppmangle;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        return new CPPMangleDeclaration(cppmangle, ДСимвол.arraySyntaxCopy(decl));
    }

    override Scope* newScope(Scope* sc)
    {
        return createNewScope(sc, sc.stc, LINK.cpp, cppmangle, sc.защита, sc.explicitProtection,
            sc.aligndecl, sc.inlining);
    }

    override ткст0 вТкст0()
    {
        return вТкст().ptr;
    }

    extern(D) override ткст вТкст()
    {
        return "extern ()";
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/**
 * A узел to represent an `extern(C++)` namespace attribute
 *
 * There are two ways to declarate a symbol as member of a namespace:
 * `Nspace` and `CPPNamespaceDeclaration`.
 * The former creates a scope for the symbol, and inject them in the
 * родитель scope at the same time.
 * The later, this class, has no semantic implications and is only
 * используется for mangling.
 * Additionally, this class allows one to use reserved identifiers
 * (D keywords) in the namespace.
 *
 * A `CPPNamespaceDeclaration` can be created from an `Идентификатор2`
 * (already resolved) or from an `Выражение`, which is CTFE-ed
 * and can be either a `TupleExp`, in which can additional
 * `CPPNamespaceDeclaration` nodes are created, or a `StringExp`.
 *
 * Note that this class, like `Nspace`, matches only one идентификатор
 * part of a namespace. For the namespace `"foo::bar"`,
 * the will be a `CPPNamespaceDeclaration` with its `идент`
 * set to `"bar"`, and its `namespace` field pointing to another
 * `CPPNamespaceDeclaration` with its `идент` set to `"foo"`.
 */
 final class CPPNamespaceDeclaration : AttribDeclaration
{
    /// CTFE-able Выражение, resolving to `TupleExp` or `StringExp`
    Выражение exp;

    this(Идентификатор2 идент, Дсимволы* decl)
    {
        super(decl);
        this.идент = идент;
    }

    this(Выражение exp, Дсимволы* decl)
    {
        super(decl);
        this.exp = exp;
    }

    this(Идентификатор2 идент, Выражение exp, Дсимволы* decl,
                    CPPNamespaceDeclaration родитель)
    {
        super(decl);
        this.идент = идент;
        this.exp = exp;
        this.cppnamespace = родитель;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        return new CPPNamespaceDeclaration(
            this.идент, this.exp, ДСимвол.arraySyntaxCopy(this.decl), this.cppnamespace);
    }

    /**
     * Возвращает:
     *   A копируй of the родитель scope, with `this` as `namespace` and C++ компонаж
     */
    override Scope* newScope(Scope* sc)
    {
        auto scx = sc.копируй();
        scx.компонаж = LINK.cpp;
        scx.namespace = this;
        return scx;
    }

    override ткст0 вТкст0()
    {
        return вТкст().ptr;
    }

    extern(D) override ткст вТкст()
    {
        return "extern (C++, `namespace`)";
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }

    override CPPNamespaceDeclaration isCPPNamespaceDeclaration(){ return this; }
}

/***********************************************************
 */
 final class ProtDeclaration : AttribDeclaration
{
    Prot защита;
    Идентификаторы* pkg_identifiers;

    /**
     * Параметры:
     *  место = source location of attribute token
     *  защита = защита attribute данные
     *  decl = declarations which are affected by this защита attribute
     */
    this(ref Место место, Prot защита, Дсимволы* decl)
    {
        super(место, null, decl);
        this.защита = защита;
        //printf("decl = %p\n", decl);
    }

    /**
     * Параметры:
     *  место = source location of attribute token
     *  pkg_identifiers = list of identifiers for a qualified package имя
     *  decl = declarations which are affected by this защита attribute
     */
    this(ref Место место, Идентификаторы* pkg_identifiers, Дсимволы* decl)
    {
        super(место, null, decl);
        this.защита.вид = Prot.Kind.package_;
        this.pkg_identifiers = pkg_identifiers;
        if (pkg_identifiers !is null && pkg_identifiers.dim > 0)
        {
            ДСимвол tmp;
            Package.resolve(pkg_identifiers, &tmp, null);
            защита.pkg = tmp ? tmp.isPackage() : null;
        }
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        if (защита.вид == Prot.Kind.package_)
            return new ProtDeclaration(this.место, pkg_identifiers, ДСимвол.arraySyntaxCopy(decl));
        else
            return new ProtDeclaration(this.место, защита, ДСимвол.arraySyntaxCopy(decl));
    }

    override Scope* newScope(Scope* sc)
    {
        if (pkg_identifiers)
            dsymbolSemantic(this, sc);
        return createNewScope(sc, sc.stc, sc.компонаж, sc.cppmangle, this.защита, 1, sc.aligndecl, sc.inlining);
    }

    override проц addMember(Scope* sc, ScopeDsymbol sds)
    {
        if (pkg_identifiers)
        {
            ДСимвол tmp;
            Package.resolve(pkg_identifiers, &tmp, null);
            защита.pkg = tmp ? tmp.isPackage() : null;
            pkg_identifiers = null;
        }
        if (защита.вид == Prot.Kind.package_ && защита.pkg && sc._module)
        {
            Module m = sc._module;
            Package pkg = m.родитель ? m.родитель.isPackage() : null;
            if (!pkg || !защита.pkg.isAncestorPackageOf(pkg))
                выведиОшибку("does not bind to one of ancestor пакеты of module `%s`", m.toPrettyChars(да));
        }
        return AttribDeclaration.addMember(sc, sds);
    }

    override ткст0 вид()
    {
        return "защита attribute";
    }

    override ткст0 toPrettyChars(бул)
    {
        assert(защита.вид > Prot.Kind.undefined);
        БуфВыв буф;
        protectionToBuffer(&буф, защита);
        return буф.extractChars();
    }

    override ProtDeclaration isProtDeclaration()
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
 final class AlignDeclaration : AttribDeclaration
{
    Выражение ealign;
    const structalign_t UNKNOWN = 0;
    static assert(STRUCTALIGN_DEFAULT != UNKNOWN);
    structalign_t salign = UNKNOWN;

    this(ref Место место, Выражение ealign, Дсимволы* decl)
    {
        super(место, null, decl);
        this.ealign = ealign;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        return new AlignDeclaration(место,
            ealign ? ealign.syntaxCopy() : null,
            ДСимвол.arraySyntaxCopy(decl));
    }

    override Scope* newScope(Scope* sc)
    {
        return createNewScope(sc, sc.stc, sc.компонаж, sc.cppmangle, sc.защита, sc.explicitProtection, this, sc.inlining);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class AnonDeclaration : AttribDeclaration
{
    бул isunion;
    цел sem;                // 1 if successful semantic()
    бцел anonoffset;        // смещение of анонимный struct
    бцел anonstructsize;    // size of анонимный struct
    бцел anonalignsize;     // size of анонимный struct for alignment purposes

    this(ref Место место, бул isunion, Дсимволы* decl)
    {
        super(место, null, decl);
        this.isunion = isunion;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        return new AnonDeclaration(место, isunion, ДСимвол.arraySyntaxCopy(decl));
    }

    override проц setScope(Scope* sc)
    {
        if (decl)
            ДСимвол.setScope(sc);
        return AttribDeclaration.setScope(sc);
    }

    override проц setFieldOffset(AggregateDeclaration ad, бцел* poffset, бул isunion)
    {
        //printf("\tAnonDeclaration::setFieldOffset %s %p\n", isunion ? "union" : "struct", this);
        if (decl)
        {
            /* This works by treating an AnonDeclaration as an aggregate 'member',
             * so in order to place that member we need to compute the member's
             * size and alignment.
             */
            т_мера fieldstart = ad.fields.dim;

            /* Hackishly hijack ad's structsize and alignsize fields
             * for use in our fake anon aggregate member.
             */
            бцел savestructsize = ad.structsize;
            бцел savealignsize = ad.alignsize;
            ad.structsize = 0;
            ad.alignsize = 0;

            бцел смещение = 0;
            decl.foreachDsymbol( (s)
            {
                s.setFieldOffset(ad, &смещение, this.isunion);
                if (this.isunion)
                    смещение = 0;
            });

            /* https://issues.dlang.org/show_bug.cgi?ид=13613
             * If the fields in this.члены had been already
             * added in ad.fields, just update *poffset for the subsequent
             * field смещение calculation.
             */
            if (fieldstart == ad.fields.dim)
            {
                ad.structsize = savestructsize;
                ad.alignsize = savealignsize;
                *poffset = ad.structsize;
                return;
            }

            anonstructsize = ad.structsize;
            anonalignsize = ad.alignsize;
            ad.structsize = savestructsize;
            ad.alignsize = savealignsize;

            // 0 sized structs are set to 1 byte
            if (anonstructsize == 0)
            {
                anonstructsize = 1;
                anonalignsize = 1;
            }

            assert(_scope);
            auto alignment = _scope.alignment();

            /* Given the anon 'member's size and alignment,
             * go ahead and place it.
             */
            anonoffset = AggregateDeclaration.placeField(
                poffset,
                anonstructsize, anonalignsize, alignment,
                &ad.structsize, &ad.alignsize,
                isunion);

            // Add to the anon fields the base смещение of this анонимный aggregate
            //printf("anon fields, anonoffset = %d\n", anonoffset);
            foreach ( i; new бцел[fieldstart .. ad.fields.dim])
            {
                VarDeclaration v = ad.fields[i];
                //printf("\t[%d] %s %d\n", i, v.вТкст0(), v.смещение);
                v.смещение += anonoffset;
            }
        }
    }

    override ткст0 вид()
    {
        return (isunion ? "анонимный union" : "анонимный struct");
    }

    override AnonDeclaration isAnonDeclaration()
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
 final class PragmaDeclaration : AttribDeclaration
{
    Выражения* args;      // массив of Выражение's

    this(ref Место место, Идентификатор2 идент, Выражения* args, Дсимволы* decl)
    {
        super(место, идент, decl);
        this.args = args;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        //printf("PragmaDeclaration::syntaxCopy(%s)\n", вТкст0());
        assert(!s);
        return new PragmaDeclaration(место, идент, Выражение.arraySyntaxCopy(args), ДСимвол.arraySyntaxCopy(decl));
    }

    override Scope* newScope(Scope* sc)
    {
        if (идент == Id.Pinline)
        {
            PINLINE inlining = PINLINE.default_;
            if (!args || args.dim == 0)
                inlining = PINLINE.default_;
            else if (args.dim != 1)
            {
                выведиОшибку("one булean Выражение expected for `pragma(inline)`, not %d", args.dim);
                args.устДим(1);
                (*args)[0] = new ErrorExp();
            }
            else
            {
                Выражение e = (*args)[0];
                if (e.op != ТОК2.int64 || !e.тип.равен(Тип.tбул))
                {
                    if (e.op != ТОК2.error)
                    {
                        выведиОшибку("pragma(`inline`, `да` or `нет`) expected, not `%s`", e.вТкст0());
                        (*args)[0] = new ErrorExp();
                    }
                }
                else if (e.isBool(да))
                    inlining = PINLINE.always;
                else if (e.isBool(нет))
                    inlining = PINLINE.never;
            }
            return createNewScope(sc, sc.stc, sc.компонаж, sc.cppmangle, sc.защита, sc.explicitProtection, sc.aligndecl, inlining);
        }
        return sc;
    }

    override ткст0 вид()
    {
        return "pragma";
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 class ConditionalDeclaration : AttribDeclaration
{
    Condition условие;
    Дсимволы* elsedecl;     // массив of ДСимвол's for else block

    this(Condition условие, Дсимволы* decl, Дсимволы* elsedecl)
    {
        super(decl);
        //printf("ConditionalDeclaration::ConditionalDeclaration()\n");
        this.условие = условие;
        this.elsedecl = elsedecl;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        return new ConditionalDeclaration(условие.syntaxCopy(), ДСимвол.arraySyntaxCopy(decl), ДСимвол.arraySyntaxCopy(elsedecl));
    }

    override final бул oneMember(ДСимвол* ps, Идентификатор2 идент)
    {
        //printf("ConditionalDeclaration::oneMember(), inc = %d\n", условие.inc);
        if (условие.inc != Include.notComputed)
        {
            Дсимволы* d = условие.include(null) ? decl : elsedecl;
            return ДСимвол.oneMembers(d, ps, идент);
        }
        else
        {
            бул res = (ДСимвол.oneMembers(decl, ps, идент) && *ps is null && ДСимвол.oneMembers(elsedecl, ps, идент) && *ps is null);
            *ps = null;
            return res;
        }
    }

    // Decide if 'then' or 'else' code should be included
    override Дсимволы* include(Scope* sc)
    {
        //printf("ConditionalDeclaration::include(sc = %p) scope = %p\n", sc, scope);

        if (errors)
            return null;

        assert(условие);
        return условие.include(_scope ? _scope : sc) ? decl : elsedecl;
    }

    override final проц добавьКоммент(ткст0 коммент)
    {
        /* Because добавьКоммент is called by the parser, if we called
         * include() it would define a version before it was используется.
         * But it's no problem to drill down to both decl and elsedecl,
         * so that's the workaround.
         */
        if (коммент)
        {
            decl    .foreachDsymbol(/* s =>*/ s.добавьКоммент(коммент) );
            elsedecl.foreachDsymbol( /* s =>*/ s.добавьКоммент(коммент) );
        }
    }

    override проц setScope(Scope* sc)
    {
        include(sc).foreachDsymbol(/* s =>*/s.setScope(sc) );
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class StaticIfDeclaration : ConditionalDeclaration
{
    ScopeDsymbol scopesym;
    private бул addisdone = нет; // да if члены have been added to scope
    private бул onStack = нет;   // да if a call to `include` is currently active

    this(Condition условие, Дсимволы* decl, Дсимволы* elsedecl)
    {
        super(условие, decl, elsedecl);
        //printf("StaticIfDeclaration::StaticIfDeclaration()\n");
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        return new StaticIfDeclaration(условие.syntaxCopy(), ДСимвол.arraySyntaxCopy(decl), ДСимвол.arraySyntaxCopy(elsedecl));
    }

    /****************************************
     * Different from other AttribDeclaration subclasses, include() call requires
     * the completion of addMember and setScope phases.
     */
    override Дсимволы* include(Scope* sc)
    {
        //printf("StaticIfDeclaration::include(sc = %p) scope = %p\n", sc, scope);

        if (errors || onStack)
            return null;
        onStack = да;
        scope(exit) onStack = нет;

        if (sc && условие.inc == Include.notComputed)
        {
            assert(scopesym); // addMember is already done
            assert(_scope); // setScope is already done
            Дсимволы* d = ConditionalDeclaration.include(_scope);
            if (d && !addisdone)
            {
                // Add члены lazily.
                d.foreachDsymbol( /* s =>*/ s.addMember(_scope, scopesym) );

                // Set the member scopes lazily.
                d.foreachDsymbol( /* s =>*/s.setScope(_scope) );

                addisdone = да;
            }
            return d;
        }
        else
        {
            return ConditionalDeclaration.include(sc);
        }
    }

    override проц addMember(Scope* sc, ScopeDsymbol sds)
    {
        //printf("StaticIfDeclaration::addMember() '%s'\n", вТкст0());
        /* This is deferred until the условие evaluated later (by the include() call),
         * so that Выражения in the условие can refer to declarations
         * in the same scope, such as:
         *
         * template Foo(цел i)
         * {
         *     const цел j = i + 1;
         *     static if (j == 3)
         *         const цел k;
         * }
         */
        this.scopesym = sds;
    }

    override проц setScope(Scope* sc)
    {
        // do not evaluate условие before semantic pass
        // But do set the scope, in case we need it for forward referencing
        ДСимвол.setScope(sc);
    }

    override проц importAll(Scope* sc)
    {
        // do not evaluate условие before semantic pass
    }

    override ткст0 вид()
    {
        return "static if";
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * Static foreach at declaration scope, like:
 *     static foreach (i; [0, 1, 2]){ }
 */
import dmd.statementsem: makeTupleForeach;
 final class StaticForeachDeclaration : AttribDeclaration
{
    StaticForeach sfe; /// содержит `static foreach` expansion logic

    ScopeDsymbol scopesym; /// cached enclosing scope (mimics `static if` declaration)

    /++
     `include` can be called multiple times, but a `static foreach`
     should be expanded at most once.  Achieved by caching the результат
     of the first call.  We need both `cached` and `cache`, because
     `null` is a valid значение for `cache`.
     +/
    бул onStack = нет;
    бул cached = нет;
    Дсимволы* cache = null;

    this(StaticForeach sfe, Дсимволы* decl)
    {
        super(decl);
        this.sfe = sfe;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        return new StaticForeachDeclaration(
            sfe.syntaxCopy(),
            ДСимвол.arraySyntaxCopy(decl));
    }

    override бул oneMember(ДСимвол* ps, Идентификатор2 идент)
    {
        // Required to support IFTI on a template that содержит a
        // `static foreach` declaration.  `super.oneMember` calls
        // include with a `null` scope.  As `static foreach` requires
        // the scope for expansion, `oneMember` can only return a
        // precise результат once `static foreach` has been expanded.
        if (cached)
        {
            return super.oneMember(ps, идент);
        }
        *ps = null; // a `static foreach` declaration may in general expand to multiple symbols
        return нет;
    }

    override Дсимволы* include(Scope* sc)
    {
        if (errors || onStack)
            return null;
        if (cached)
        {
            assert(!onStack);
            return cache;
        }
        onStack = да;
        scope(exit) onStack = нет;

        if (_scope)
        {
            sfe.prepare(_scope); // lower static foreach aggregate
        }
        if (!sfe.ready())
        {
            return null; // TODO: ok?
        }

        // expand static foreach
        
        Дсимволы* d = makeTupleForeach!(да,да)(_scope, sfe.aggrfe, decl, sfe.needExpansion);
        if (d) // process generated declarations
        {
            // Add члены lazily.
            d.foreachDsymbol( /* s =>*/s.addMember(_scope, scopesym) );

            // Set the member scopes lazily.
            d.foreachDsymbol(/* s =>*/s.setScope(_scope) );
        }
        cached = да;
        cache = d;
        return d;
    }

    override проц addMember(Scope* sc, ScopeDsymbol sds)
    {
        // используется only for caching the enclosing symbol
        this.scopesym = sds;
    }

    override проц добавьКоммент(ткст0 коммент)
    {
        // do nothing
        // change this to give semantics to documentation comments on static foreach declarations
    }

    override проц setScope(Scope* sc)
    {
        // do not evaluate условие before semantic pass
        // But do set the scope, in case we need it for forward referencing
        ДСимвол.setScope(sc);
    }

    override проц importAll(Scope* sc)
    {
        // do not evaluate aggregate before semantic pass
    }

    override ткст0 вид()
    {
        return "static foreach";
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * Collection of declarations that stores foreach index variables in a
 * local symbol table.  Other symbols declared within are forwarded to
 * another scope, like:
 *
 *      static foreach (i; 0 .. 10) // loop variables for different indices do not conflict.
 *      { // this body is expanded into 10 ForwardingAttribDeclarations, where `i` has storage class STC.local
 *          mixin("enum x" ~ to!ткст(i) ~ " = i"); // ok, can access current loop variable
 *      }
 *
 *      static foreach (i; 0.. 10)
 *      {
 *          pragma(msg, mixin("x" ~ to!ткст(i))); // ok, all 10 symbols are visible as they were forwarded to the глоб2 scope
 *      }
 *
 *      static assert (!is(typeof(i))); // loop index variable is not visible outside of the static foreach loop
 *
 * A StaticForeachDeclaration generates one
 * ForwardingAttribDeclaration for each expansion of its body.  The
 * AST of the ForwardingAttribDeclaration содержит both the `static
 * foreach` variables and the respective копируй of the `static foreach`
 * body.  The functionality is achieved by using a
 * ForwardingScopeDsymbol as the родитель symbol for the generated
 * declarations.
 */

/*extern(C++)*/ final class ForwardingAttribDeclaration: AttribDeclaration
{
    ForwardingScopeDsymbol sym = null;

    this(Дсимволы* decl)
    {
        super(decl);
        sym = new ForwardingScopeDsymbol(null);
        sym.symtab = new DsymbolTable();
    }

    /**************************************
     * Use the ForwardingScopeDsymbol as the родитель symbol for члены.
     */
    override Scope* newScope(Scope* sc)
    {
        return sc.сунь(sym);
    }

    /***************************************
     * Lazily initializes the scope to forward to.
     */
    override проц addMember(Scope* sc, ScopeDsymbol sds)
    {
        родитель = sym.родитель = sym.forward = sds;
        return super.addMember(sc, sym);
    }

    override ForwardingAttribDeclaration isForwardingAttribDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}


/***********************************************************
 * Mixin declarations, like:
 *      mixin("цел x");
 * https://dlang.org/spec/module.html#mixin-declaration
 */
 final class CompileDeclaration : AttribDeclaration
{
    Выражения* exps;
    ScopeDsymbol scopesym;
    бул compiled;

    this(ref Место место, Выражения* exps)
    {
        super(место, null, null);
        //printf("CompileDeclaration(место = %d)\n", место.номстр);
        this.exps = exps;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        //printf("CompileDeclaration::syntaxCopy('%s')\n", вТкст0());
        return new CompileDeclaration(место, Выражение.arraySyntaxCopy(exps));
    }

    override проц addMember(Scope* sc, ScopeDsymbol sds)
    {
        //printf("CompileDeclaration::addMember(sc = %p, sds = %p, memnum = %d)\n", sc, sds, memnum);
        this.scopesym = sds;
    }

    override проц setScope(Scope* sc)
    {
        ДСимвол.setScope(sc);
    }

    override ткст0 вид()
    {
        return "mixin";
    }

    override CompileDeclaration isCompileDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * User defined attributes look like:
 *      @foo(args, ...)
 *      @(args, ...)
 */
 final class UserAttributeDeclaration : AttribDeclaration
{
    Выражения* atts;

    this(Выражения* atts, Дсимволы* decl)
    {
        super(decl);
        //printf("UserAttributeDeclaration()\n");
        this.atts = atts;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        //printf("UserAttributeDeclaration::syntaxCopy('%s')\n", вТкст0());
        assert(!s);
        return new UserAttributeDeclaration(Выражение.arraySyntaxCopy(this.atts), ДСимвол.arraySyntaxCopy(decl));
    }

    override Scope* newScope(Scope* sc)
    {
        Scope* sc2 = sc;
        if (atts && atts.dim)
        {
            // создай new one for changes
            sc2 = sc.копируй();
            sc2.userAttribDecl = this;
        }
        return sc2;
    }

    override проц setScope(Scope* sc)
    {
        //printf("UserAttributeDeclaration::setScope() %p\n", this);
        if (decl)
            ДСимвол.setScope(sc); // for forward reference of UDAs
        return AttribDeclaration.setScope(sc);
    }

    extern (D) static Выражения* concat(Выражения* udas1, Выражения* udas2)
    {
        Выражения* udas;
        if (!udas1 || udas1.dim == 0)
            udas = udas2;
        else if (!udas2 || udas2.dim == 0)
            udas = udas1;
        else
        {
            /* Create a new кортеж that combines them
             * (do not приставь to left operand, as this is a копируй-on-пиши operation)
             */
            udas = new Выражения(2);
            (*udas)[0] = new TupleExp(Место.initial, udas1);
            (*udas)[1] = new TupleExp(Место.initial, udas2);
        }
        return udas;
    }

    Выражения* getAttributes()
    {
        if (auto sc = _scope)
        {
            _scope = null;
            arrayВыражениеSemantic(atts, sc);
        }
        auto exps = new Выражения();
        if (userAttribDecl)
            exps.сунь(new TupleExp(Место.initial, userAttribDecl.getAttributes()));
        if (atts && atts.dim)
            exps.сунь(new TupleExp(Место.initial, atts));
        return exps;
    }

    override ткст0 вид()
    {
        return "UserAttribute";
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}
