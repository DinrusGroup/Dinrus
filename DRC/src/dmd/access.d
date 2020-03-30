/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/access.d, _access.d)
 * Documentation:  https://dlang.org/phobos/dmd_access.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/access.d
 */

module dmd.access;

import dmd.aggregate;
import dmd.dclass;
import dmd.declaration;
import dmd.dmodule;
import dmd.dscope;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.errors;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import dmd.mtype;
import drc.lexer.Tokens;

private const LOG = нет;

static if(LOG){ import common;}

/*******************************
 * Выполнить проверку доступа для члена данного класса, при этом класс должен быть
 * типом указателя 'this', используемого для доступа к smember.
 * Возвращает да, если член недоступен.
 */
бул checkAccess(AggregateDeclaration ad, Место место, Scope* sc, ДСимвол smember)
{
    static if (LOG)
    {
        Стдвыв.форматируй("AggregateDeclaration::checkAccess() для {}.{} в функции {}() в масштабе {}\n", ad.вТкст0(), smember.вТкст0(), f ? f.вТкст0() : null, cdscope ? cdscope.вТкст0() : null);
    }

    auto p = smember.toParent();
    if (p && p.isTemplateInstance())
    {
        return нет; // для обратной совместимости
    }

    if (!symbolIsVisible(sc, smember) && (!(sc.flags & SCOPE.onlysafeaccess) || sc.func.setUnsafe()))
    {
        ad.выведиОшибку(место, "член `%s` недоступен %s", smember.вТкст0(), (sc.flags & SCOPE.onlysafeaccess) ? " из `` code".ptr : "".ptr);
        //Стдвыв.форматируй("smember = %s %s, prot = %d, semanticRun = %d\n",
        //        smember.вид(), smember.toPrettyChars(), smember.prot(), smember.semanticRun);
        return да;
    }
    return нет;
}

/****************************************
 * Определить, имеет ли масштаб sc доступ пакетного уровня к s.
 */
private бул hasPackageAccess(Scope* sc, ДСимвол s)
{
    return hasPackageAccess(sc._module, s);
}

private бул hasPackageAccess(Module mod, ДСимвол s)
{
    static if (LOG)
    {
        Стдвыв.форматируй("hasPackageAccess(s = '{}', mod = '{}', s.защита.pkg = '{}')\n", s.вТкст0(), mod.вТкст0(), s.prot().pkg ? s.prot().pkg.вТкст0() : "NULL");
    }
    Package pkg = null;
    if (s.prot().pkg)
        pkg = s.prot().pkg;
    else
    {
        // no explicit package for защита, inferring most qualified one
        for (; s; s = s.родитель)
        {
            if (auto m = s.isModule())
            {
                DsymbolTable dst = Package.resolve(m.md ? m.md.пакеты : null, null, null);
                assert(dst);
                ДСимвол s2 = dst.lookup(m.идент);
                assert(s2);
                Package p = s2.isPackage();
                if (p && p.isPackageMod())
                {
                    pkg = p;
                    break;
                }
            }
            else if ((pkg = s.isPackage()) !is null)
                break;
        }
    }
    static if (LOG)
    {
        if (pkg)
            Стдвыв.форматируй("\tсимвольный доступ привязывается к пакету '{}'\n", pkg.вТкст0());
    }
    if (pkg)
    {
        if (pkg == mod.родитель)
        {
            static if (LOG)
            {
                выдай("\tsc в доступном пакете для s\n");
            }
            return да;
        }
        if (pkg.isPackageMod() == mod)
        {
            static if (LOG)
            {
                выдай("\ts находится в том же модуле package.d, что и sc\n");
            }
            return да;
        }
        ДСимвол ancestor = mod.родитель;
        for (; ancestor; ancestor = ancestor.родитель)
        {
            if (ancestor == pkg)
            {
                static if (LOG)
                {
                    выдай("\tsc находится в доступном пакете-предке для s\n");
                }
                return да;
            }
        }
    }
    static if (LOG)
    {
        выдай("\tнет пакетного доступа\n");
    }
    return нет;
}

/****************************************
 * Определить, имеет ли масштаб sc доступ защищенного уровня  к cd.
 */
private бул hasProtectedAccess(Scope *sc, ДСимвол s)
{
    if (auto cd = s.isClassMember()) // also includes interfaces
    {
        for (auto scx = sc; scx; scx = scx.enclosing)
        {
            if (!scx.scopesym)
                continue;
            auto cd2 = scx.scopesym.isClassDeclaration();
            if (cd2 && cd.isBaseOf(cd2, null))
                return да;
        }
    }
    return sc._module == s.getAccessModule();
}

/****************************************
 * Check access to d for Выражение e.d
 * Возвращает да if the declaration is not accessible.
 */
бул checkAccess(Место место, Scope* sc, Выражение e, Declaration d)
{
    if (sc.flags & SCOPE.noaccesscheck)
        return нет;
    static if (LOG)
    {
        if (e)
        {
            Стдвыв.форматируй("checkAccess({} . {})\n", e.вТкст0(), d.вТкст0());
            Стдвыв.форматируй("\te.тип = {}\n", e.тип.вТкст0());
        }
        else
        {
            Стдвыв.форматируй("checkAccess({})\n", d.toPrettyChars());
        }
    }
    if (d.isUnitTestDeclaration())
    {
        // Unittests are always accessible.
        return нет;
    }

    if (!e)
        return нет;

    if (e.тип.ty == Tclass)
    {
        // Do access check
        ClassDeclaration cd = (cast(TypeClass)e.тип).sym;
        if (e.op == ТОК2.super_)
        {
            if (ClassDeclaration cd2 = sc.func.toParent().isClassDeclaration())
                cd = cd2;
        }
        return checkAccess(cd, место, sc, d);
    }
    else if (e.тип.ty == Tstruct)
    {
        // Do access check
        StructDeclaration cd = (cast(TypeStruct)e.тип).sym;
        return checkAccess(cd, место, sc, d);
    }
    return нет;
}

/****************************************
 * Check access to package/module `p` from scope `sc`.
 *
 * Параметры:
 *   sc = scope from which to access to a fully qualified package имя
 *   p = the package/module to check access for
 * Возвращает: да if the package is not accessible.
 *
 * Because a глоб2 symbol table tree is используется for imported пакеты/modules,
 * access to them needs to be checked based on the imports in the scope chain
 * (see https://issues.dlang.org/show_bug.cgi?ид=313).
 *
 */
бул checkAccess(Scope* sc, Package p)
{
    if (sc._module == p)
        return нет;
    for (; sc; sc = sc.enclosing)
    {
        if (sc.scopesym && sc.scopesym.isPackageAccessible(p, Prot(Prot.Kind.private_)))
            return нет;
    }

    return да;
}

/**
 * Check whether symbols `s` is visible in `mod`.
 *
 * Параметры:
 *  mod = lookup origin
 *  s = symbol to check for visibility
 * Возвращает: да if s is visible in mod
 */
бул symbolIsVisible(Module mod, ДСимвол s)
{
    // should sort overloads by ascending защита instead of iterating here
    s = mostVisibleOverload(s);
    switch (s.prot().вид)
    {
    case Prot.Kind.undefined: return да;
    case Prot.Kind.none: return нет; // no access
    case Prot.Kind.private_: return s.getAccessModule() == mod;
    case Prot.Kind.package_: return s.getAccessModule() == mod || hasPackageAccess(mod, s);
    case Prot.Kind.protected_: return s.getAccessModule() == mod;
    case Prot.Kind.public_, Prot.Kind.export_: return да;
    }
}

/**
 * Same as above, but determines the lookup module from symbols `origin`.
 */
бул symbolIsVisible(ДСимвол origin, ДСимвол s)
{
    return symbolIsVisible(origin.getAccessModule(), s);
}

/**
 * Same as above but also checks for protected symbols visible from scope `sc`.
 * Used for qualified имя lookup.
 *
 * Параметры:
 *  sc = lookup scope
 *  s = symbol to check for visibility
 * Возвращает: да if s is visible by origin
 */
бул symbolIsVisible(Scope *sc, ДСимвол s)
{
    s = mostVisibleOverload(s);
    return checkSymbolAccess(sc, s);
}

/**
 * Check if a symbol is visible from a given scope without taking
 * into account the most visible overload.
 *
 * Параметры:
 *  sc = lookup scope
 *  s = symbol to check for visibility
 * Возвращает: да if s is visible by origin
 */
бул checkSymbolAccess(Scope *sc, ДСимвол s)
{
    switch (s.prot().вид)
    {
    case Prot.Kind.undefined: return да;
    case Prot.Kind.none: return нет; // no access
    case Prot.Kind.private_: return sc._module == s.getAccessModule();
    case Prot.Kind.package_: return sc._module == s.getAccessModule() || hasPackageAccess(sc._module, s);
    case Prot.Kind.protected_: return hasProtectedAccess(sc, s);
    case Prot.Kind.public_, Prot.Kind.export_: return да;
    }
}

/**
 * Use the most visible overload to check visibility. Later perform an access
 * check on the resolved overload.  This function is similar to overloadApply,
 * but doesn't recurse nor resolve ники because защита/visibility is an
 * attribute of the alias not the aliasee.
 */
public ДСимвол mostVisibleOverload(ДСимвол s, Module mod = null)
{
    if (!s.перегружаем_ли())
        return s;

    ДСимвол следщ, fstart = s, mostVisible = s;
    for (; s; s = следщ)
    {
        // проц func() {}
        // private проц func(цел) {}
        if (auto fd = s.isFuncDeclaration())
            следщ = fd.overnext;
        // template temp(T) {}
        // private template temp(T:цел) {}
        else if (auto td = s.isTemplateDeclaration())
            следщ = td.overnext;
        // alias common = mod1.func1;
        // alias common = mod2.func2;
        else if (auto fa = s.isFuncAliasDeclaration())
            следщ = fa.overnext;
        // alias common = mod1.templ1;
        // alias common = mod2.templ2;
        else if (auto od = s.isOverDeclaration())
            следщ = od.overnext;
        // alias имя = sym;
        // private проц имя(цел) {}
        else if (auto ad = s.isAliasDeclaration())
        {
            assert(ad.перегружаем_ли || ad.тип && ad.тип.ty == Terror,
                "Non overloadable Aliasee in overload list");
            // Yet unresolved ники store overloads in overnext.
            if (ad.semanticRun < PASS.semanticdone)
                следщ = ad.overnext;
            else
            {
                /* This is a bit messy due to the complicated implementation of
                 * alias.  Aliases aren't overloadable themselves, but if their
                 * Aliasee is overloadable they can be converted to an overloadable
                 * alias.
                 *
                 * This is done by replacing the Aliasee w/ FuncAliasDeclaration
                 * (for functions) or OverDeclaration (for templates) which are
                 * simply overloadable ники w/ weird имена.
                 *
                 * Usually ники should not be resolved for visibility checking
                 * b/c public ники to private symbols are public. But for the
                 * overloadable alias situation, the Alias (_ad_) has been moved
                 * into it's own Aliasee, leaving a shell that we peel away here.
                 */
                auto aliasee = ad.toAlias();
                if (aliasee.isFuncAliasDeclaration || aliasee.isOverDeclaration)
                    следщ = aliasee;
                else
                {
                    /* A simple alias can be at the end of a function or template overload chain.
                     * It can't have further overloads b/c it would have been
                     * converted to an overloadable alias.
                     */
                    assert(ad.overnext is null, "Unresolved overload of alias");
                    break;
                }
            }
            // handled by dmd.func.overloadApply for unknown reason
            assert(следщ !is ad); // should not alias itself
            assert(следщ !is fstart); // should not alias the overload list itself
        }
        else
            break;

        /**
        * Return the "effective" защита attribute of a symbol when accessed in a module.
        * The effective защита attribute is the same as the regular защита attribute,
        * except package() is "private" if the module is outside the package;
        * otherwise, "public".
        */
        static Prot protectionSeenFromModule(ДСимвол d, Module mod = null)
        {
            Prot prot = d.prot();
            if (mod && prot.вид == Prot.Kind.package_)
            {
                return hasPackageAccess(mod, d) ? Prot(Prot.Kind.public_) : Prot(Prot.Kind.private_);
            }
            return prot;
        }

        if (следщ &&
            protectionSeenFromModule(mostVisible, mod).isMoreRestrictiveThan(protectionSeenFromModule(следщ, mod)))
            mostVisible = следщ;
    }
    return mostVisible;
}
