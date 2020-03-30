/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/dimport.d, _dimport.d)
 * Documentation:  https://dlang.org/phobos/dmd_dimport.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/dimport.d
 */

module dmd.dimport;

import dmd.arraytypes;
import dmd.declaration;
import dmd.dmodule;
import dmd.dscope;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.errors;
import drc.ast.Expression;
import dmd.globals;
import drc.lexer.Identifier;
import dmd.mtype;
import drc.ast.Visitor;

/***********************************************************
 */
 final class Импорт : ДСимвол
{
    /* static import идНик = pkg1.pkg2.ид : alias1 = name1, alias2 = name2;
     */
    Идентификаторы* пакеты;  // массив of Идентификатор2's representing пакеты
    Идентификатор2 ид;          // module Идентификатор2
    Идентификатор2 идНик;
    цел статичен_ли;           // !=0 if static import
    Prot защита;

    // Pairs of alias=имя to bind into current namespace
    Идентификаторы имена;
    Идентификаторы ники;

    Module mod;
    Package pkg;            // leftmost package/module

    // corresponding AliasDeclarations for alias=имя pairs
    AliasDeclarations aliasdecls;

    this(ref Место место, Идентификаторы* пакеты, Идентификатор2 ид, Идентификатор2 идНик, цел статичен_ли)
    {
        Идентификатор2 selectIdent()
        {
            // select ДСимвол идентификатор (bracketed)
            if (идНик)
            {
                // import [идНик] = std.stdio;
                return идНик;
            }
            else if (пакеты && пакеты.dim)
            {
                // import [std].stdio;
                return (*пакеты)[0];
            }
            else
            {
                // import [ид];
                return ид;
            }
        }

        super(место, selectIdent());

        assert(ид);
        version (none)
        {
            printf("Импорт::Импорт(");
            if (пакеты && пакеты.dim)
            {
                for (т_мера i = 0; i < пакеты.dim; i++)
                {
                    Идентификатор2 ид = (*пакеты)[i];
                    printf("%s.", ид.вТкст0());
                }
            }
            printf("%s)\n", ид.вТкст0());
        }
        this.пакеты = пакеты;
        this.ид = ид;
        this.идНик = идНик;
        this.статичен_ли = статичен_ли;
        this.защита = Prot.Kind.private_; // default to private
    }

    extern (D) проц добавьНик(Идентификатор2 имя, Идентификатор2 _alias)
    {
        if (статичен_ли)
            выведиОшибку("cannot have an import bind list");
        if (!идНик)
            this.идент = null; // make it an анонимный import
        имена.сунь(имя);
        ники.сунь(_alias);
    }

    override ткст0 вид()
    {
        return статичен_ли ? "static import" : "import";
    }

    override Prot prot()   
    {
        return защита;
    }

    // копируй only syntax trees
    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        auto si = new Импорт(место, пакеты, ид, идНик, статичен_ли);
        si.коммент = коммент;
        for (т_мера i = 0; i < имена.dim; i++)
        {
            si.добавьНик(имена[i], ники[i]);
        }
        return si;
    }

    /*******************************
     * Load this module.
     * Возвращает:
     *  да for errors, нет for успех
     */
    бул load(Scope* sc)
    {
        //printf("Импорт::load('%s') %p\n", toPrettyChars(), this);
        // See if existing module
        const errors = глоб2.errors;
        DsymbolTable dst = Package.resolve(пакеты, null, &pkg);
        version (none)
        {
            if (pkg && pkg.isModule())
            {
                .выведиОшибку(место, "can only import from a module, not from a member of module `%s`. Did you mean `import %s : %s`?", pkg.вТкст0(), pkg.toPrettyChars(), ид.вТкст0());
                mod = pkg.isModule(); // Error recovery - treat as import of that module
                return да;
            }
        }
        ДСимвол s = dst.lookup(ид);
        if (s)
        {
            if (s.isModule())
                mod = cast(Module)s;
            else
            {
                if (s.isAliasDeclaration())
                {
                    .выведиОшибку(место, "%s `%s` conflicts with `%s`", s.вид(), s.toPrettyChars(), ид.вТкст0());
                }
                else if (Package p = s.isPackage())
                {
                    if (p.isPkgMod == PKG.unknown)
                    {
                        бцел preverrors = глоб2.errors;
                        mod = Module.load(место, пакеты, ид);
                        if (!mod)
                            p.isPkgMod = PKG.package_;
                        else
                        {
                            // mod is a package.d, or a normal module which conflicts with the package имя.
                            if (mod.isPackageFile)
                                mod.tag = p.tag; // reuse the same package tag
                            else
                            {
                                // show error if Module.load does not
                                if (preverrors == глоб2.errors)
                                    .выведиОшибку(место, "%s `%s` from файл %s conflicts with %s `%s`", mod.вид(), mod.toPrettyChars(), mod.srcfile.вТкст0, p.вид(), p.toPrettyChars());
                                return да;
                            }
                        }
                    }
                    else
                    {
                        mod = p.isPackageMod();
                    }
                    if (!mod)
                    {
                        .выведиОшибку(место, "can only import from a module, not from package `%s.%s`", p.toPrettyChars(), ид.вТкст0());
                    }
                }
                else if (pkg)
                {
                    .выведиОшибку(место, "can only import from a module, not from package `%s.%s`", pkg.toPrettyChars(), ид.вТкст0());
                }
                else
                {
                    .выведиОшибку(место, "can only import from a module, not from package `%s`", ид.вТкст0());
                }
            }
        }
        if (!mod)
        {
            // Load module
            mod = Module.load(место, пакеты, ид);
            if (mod)
            {
                // ид may be different from mod.идент, if so then вставь alias
                dst.вставь(ид, mod);
            }
        }
        if (mod && !mod.importedFrom)
            mod.importedFrom = sc ? sc._module.importedFrom : Module.rootModule;
        if (!pkg)
        {
            if (mod && mod.isPackageFile)
            {
                // one уровень depth package.d файл (import pkg; ./pkg/package.d)
                // it's necessary to use the wrapping Package already created
                pkg = mod.pkg;
            }
            else
                pkg = mod;
        }
        //printf("-Импорт::load('%s'), pkg = %p\n", вТкст0(), pkg);
        return глоб2.errors != errors;
    }

    override проц importAll(Scope* sc)
    {
        if (mod) return; // Already done
        load(sc);
        if (!mod) return; // Failed

        if (sc.stc & STC.static_)
            статичен_ли = да;
        mod.importAll(null);
        mod.checkImportDeprecation(место, sc);
        if (sc.explicitProtection)
            защита = sc.защита;
        if (!статичен_ли && !идНик && !имена.dim)
            sc.scopesym.importScope(mod, защита);
    }

    override ДСимвол toAlias()
    {
        if (идНик)
            return mod;
        return this;
    }

    /*****************************
     * Add import to sd's symbol table.
     */
    override проц addMember(Scope* sc, ScopeDsymbol sd)
    {
        //printf("Импорт.addMember(this=%s, sd=%s, sc=%p)\n", вТкст0(), sd.вТкст0(), sc);
        if (имена.dim == 0)
            return ДСимвол.addMember(sc, sd);
        if (идНик)
            ДСимвол.addMember(sc, sd);
        /* Instead of adding the import to sd's symbol table,
         * add each of the alias=имя pairs
         */
        for (т_мера i = 0; i < имена.dim; i++)
        {
            Идентификатор2 имя = имена[i];
            Идентификатор2 _alias = ники[i];
            if (!_alias)
                _alias = имя;
            auto tname = new TypeIdentifier(место, имя);
            auto ad = new AliasDeclaration(место, _alias, tname);
            ad._import = this;
            ad.addMember(sc, sd);
            aliasdecls.сунь(ad);
        }
    }

    override проц setScope(Scope* sc)
    {
        ДСимвол.setScope(sc);
        if (aliasdecls.dim)
        {
            if (!mod)
                importAll(sc);

            sc = sc.сунь(mod);
            sc.защита = защита;
            foreach (ad; aliasdecls)
                ad.setScope(sc);
            sc = sc.вынь();
        }
    }

    override ДСимвол search(ref Место место, Идентификатор2 идент, цел flags = cast(цел) SearchLocalsOnly)
    {
        //printf("%s.Импорт.search(идент = '%s', flags = x%x)\n", вТкст0(), идент.вТкст0(), flags);
        if (!pkg)
        {
            load(null);
            mod.importAll(null);
            mod.dsymbolSemantic(null);
        }
        // Forward it to the package/module
        return pkg.search(место, идент, flags);
    }

    override бул overloadInsert(ДСимвол s)
    {
        /* Allow multiple imports with the same package base, but disallow
         * alias collisions
         * https://issues.dlang.org/show_bug.cgi?ид=5412
         */
        assert(идент && идент == s.идент);
        Импорт imp;
        if (!идНик && (imp = s.isImport()) !is null && !imp.идНик)
            return да;
        else
            return нет;
    }

    override Импорт isImport()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}
