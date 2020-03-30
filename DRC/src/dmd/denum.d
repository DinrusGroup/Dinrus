/**
 * Handle enums.
 *
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/denum.d, _denum.d)
 * Documentation:  https://dlang.org/phobos/dmd_denum.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/denum.d
 * References:  https://dlang.org/spec/enum.html
 */

module dmd.denum;

import cidrus;

import dmd.attrib;
import dmd.gluelayer;
import dmd.declaration;
import dmd.dscope;
import dmd.дсимвол;
import dmd.dsymbolsem;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.init;
import dmd.mtype;
import drc.lexer.Tokens;
import dmd.typesem;
import drc.ast.Visitor;

/***********************************************************
 * AST узел for `EnumDeclaration`
 * https://dlang.org/spec/enum.html#EnumDeclaration
 */
 final class EnumDeclaration : ScopeDsymbol
{
    /* The separate, and distinct, cases are:
     *  1. enum { ... }
     *  2. enum : memtype { ... }
     *  3. enum ид { ... }
     *  4. enum ид : memtype { ... }
     *  5. enum ид : memtype;
     *  6. enum ид;
     */
    Тип тип;              // the TypeEnum
    Тип memtype;           // тип of the члены

    Prot защита;
    Выражение maxval;
    Выражение minval;
    Выражение defaultval;  // default инициализатор
    бул isdeprecated;
    бул added;
    цел inuse;

    this(ref Место место, Идентификатор2 идент, Тип memtype)
    {
        super(место, идент);
        //printf("EnumDeclaration() %s\n", вТкст0());
        тип = new TypeEnum(this);
        this.memtype = memtype;
        защита = Prot(Prot.Kind.undefined);
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        auto ed = new EnumDeclaration(место, идент, memtype ? memtype.syntaxCopy() : null);
        return ScopeDsymbol.syntaxCopy(ed);
    }

    override проц addMember(Scope* sc, ScopeDsymbol sds)
    {
        version (none)
        {
            printf("EnumDeclaration::addMember() %s\n", вТкст0());
            for (т_мера i = 0; i < члены.dim; i++)
            {
                EnumMember em = (*члены)[i].isEnumMember();
                printf("    member %s\n", em.вТкст0());
            }
        }

        /* Anonymous enum члены get added to enclosing scope.
         */
        ScopeDsymbol scopesym = isAnonymous() ? sds : this;

        if (!isAnonymous())
        {
            ScopeDsymbol.addMember(sc, sds);
            if (!symtab)
                symtab = new DsymbolTable();
        }

        if (члены)
        {
            for (т_мера i = 0; i < члены.dim; i++)
            {
                EnumMember em = (*члены)[i].isEnumMember();
                em.ed = this;
                //printf("add %s to scope %s\n", em.вТкст0(), scopesym.вТкст0());
                em.addMember(sc, isAnonymous() ? scopesym : this);
            }
        }
        added = да;
    }

    override проц setScope(Scope* sc)
    {
        if (semanticRun > PASS.init)
            return;
        ScopeDsymbol.setScope(sc);
    }

    override бул oneMember(ДСимвол* ps, Идентификатор2 идент)
    {
        if (isAnonymous())
            return ДСимвол.oneMembers(члены, ps, идент);
        return ДСимвол.oneMember(ps, идент);
    }

    override Тип getType()
    {
        return тип;
    }

    override ткст0 вид()
    {
        return "enum";
    }

    override ДСимвол search(ref Место место, Идентификатор2 идент, цел flags = SearchLocalsOnly)
    {
        //printf("%s.EnumDeclaration::search('%s')\n", вТкст0(), идент.вТкст0());
        if (_scope)
        {
            // Try one last time to resolve this enum
            dsymbolSemantic(this, _scope);
        }

        if (!члены || !symtab || _scope)
        {
            выведиОшибку("is forward referenced when looking for `%s`", идент.вТкст0());
            //*(сим*)0=0;
            return null;
        }

        ДСимвол s = ScopeDsymbol.search(место, идент, flags);
        return s;
    }

    // is ДСимвол deprecated?
    override бул isDeprecated()
    {
        return isdeprecated;
    }

    override Prot prot()   
    {
        return защита;
    }

    /******************************
     * Get the значение of the .max/.min property as an Выражение.
     * Lazily computes the значение and caches it in maxval/minval.
     * Reports any errors.
     * Параметры:
     *      место = location to use for error messages
     *      ид = Id::max or Id::min
     * Возвращает:
     *      corresponding значение of .max/.min
     */
    Выражение getMaxMinValue(ref Место место, Идентификатор2 ид)
    {
        //printf("EnumDeclaration::getMaxValue()\n");

        static Выражение pvalToрезультат(Выражение e, ref Место место)
        {
            if (e.op != ТОК2.error)
            {
                e = e.копируй();
                e.место = место;
            }
            return e;
        }

        Выражение* pval = (ид == Id.max) ? &maxval : &minval;

        Выражение errorReturn()
        {
            *pval = new ErrorExp();
            return *pval;
        }

        if (inuse)
        {
            выведиОшибку(место, "recursive definition of `.%s` property", ид.вТкст0());
            return errorReturn();
        }
        if (*pval)
            return pvalToрезультат(*pval, место);

        if (_scope)
            dsymbolSemantic(this, _scope);
        if (errors)
            return errorReturn();
        if (semanticRun == PASS.init || !члены)
        {
            if (isSpecial())
            {
                /* Allow these special enums to not need a member list
                 */
                return memtype.getProperty(место, ид, 0);
            }

            выведиОшибку("is forward referenced looking for `.%s`", ид.вТкст0());
            return errorReturn();
        }
        if (!(memtype && memtype.isintegral()))
        {
            выведиОшибку(место, "has no `.%s` property because base тип `%s` is not an integral тип", ид.вТкст0(), memtype ? memtype.вТкст0() : "");
            return errorReturn();
        }

        бул first = да;
        for (т_мера i = 0; i < члены.dim; i++)
        {
            EnumMember em = (*члены)[i].isEnumMember();
            if (!em)
                continue;
            if (em.errors)
            {
                errors = да;
                continue;
            }

            if (first)
            {
                *pval = em.значение;
                first = нет;
            }
            else
            {
                /* In order to work successfully with UDTs,
                 * build Выражения to do the comparisons,
                 * and let the semantic analyzer and constant
                 * folder give us the результат.
                 */

                /* Compute:
                 *   if (e > maxval)
                 *      maxval = e;
                 */
                Выражение e = em.значение;
                Выражение ec = new CmpExp(ид == Id.max ? ТОК2.greaterThan : ТОК2.lessThan, em.место, e, *pval);
                inuse++;
                ec = ec.ВыражениеSemantic(em._scope);
                inuse--;
                ec = ec.ctfeInterpret();
                if (ec.op == ТОК2.error)
                {
                    errors = да;
                    continue;
                }
                if (ec.toInteger())
                    *pval = e;
            }
        }
        return errors ? errorReturn() : pvalToрезультат(*pval, место);
    }

    /****************
     * Determine if enum is a special one.
     * Возвращает:
     *  `да` if special
     */
    бул isSpecial()
    {
        return isSpecialEnumIdent(идент) && memtype;
    }

    Выражение getDefaultValue(ref Место место)
    {
        Выражение handleErrors(){
            defaultval = new ErrorExp();
            return defaultval;
        }
        //printf("EnumDeclaration::getDefaultValue() %p %s\n", this, вТкст0());
        if (defaultval)
            return defaultval;

        if (_scope)
            dsymbolSemantic(this, _scope);
        if (errors)
            return handleErrors();
        if (semanticRun == PASS.init || !члены)
        {
            if (isSpecial())
            {
                /* Allow these special enums to not need a member list
                 */
                return memtype.defaultInit(место);
            }

            выведиОшибку(место, "forward reference of `%s.init`", вТкст0());
            return handleErrors();
        }

        foreach (i; new бцел[0 .. члены.dim])
        {
            EnumMember em = (*члены)[i].isEnumMember();
            if (em)
            {
                defaultval = em.значение;
                return defaultval;
            }
        }
        return handleErrors();
    }

    Тип getMemtype(ref Место место)
    {
        if (_scope)
        {
            /* Enum is forward referenced. We don't need to resolve the whole thing,
             * just the base тип
             */
            if (memtype)
            {
                Место locx = место.isValid() ? место : this.место;
                memtype = memtype.typeSemantic(locx, _scope);
            }
            else
            {
                if (!isAnonymous() && члены)
                    memtype = Тип.tint32;
            }
        }
        if (!memtype)
        {
            if (!isAnonymous() && члены)
                memtype = Тип.tint32;
            else
            {
                Место locx = место.isValid() ? место : this.место;
                выведиОшибку(locx, "is forward referenced looking for base тип");
                return Тип.terror;
            }
        }
        return memtype;
    }

    override EnumDeclaration isEnumDeclaration()
    {
        return this;
    }

    Symbol* sinit;

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * AST узел representing a member of an enum.
 * https://dlang.org/spec/enum.html#EnumMember
 * https://dlang.org/spec/enum.html#AnonymousEnumMember
 */
 final class EnumMember : VarDeclaration
{
    /* Can take the following forms:
     *  1. ид
     *  2. ид = значение
     *  3. тип ид = значение
     */
     Выражение значение() { return (cast(ExpInitializer)_иниц).exp; }

    // A /*cast()*/ is injected to 'значение' after dsymbolSemantic(),
    // but 'origValue' will preserve the original значение,
    // or previous значение + 1 if none was specified.
    Выражение origValue;

    Тип origType;

    EnumDeclaration ed;

    this(ref Место место, Идентификатор2 ид, Выражение значение, Тип origType)
    {
        super(место, null, ид ? ид : Id.empty, new ExpInitializer(место, значение));
        this.origValue = значение;
        this.origType = origType;
    }

    extern(D) this(Место место, Идентификатор2 ид, Выражение значение, Тип memtype,
        КлассХранения stc, UserAttributeDeclaration uad, DeprecatedDeclaration dd)
    {
        this(место, ид, значение, memtype);
        класс_хранения = stc;
        userAttribDecl = uad;
        depdecl = dd;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        return new EnumMember(
            место, идент,
            значение ? значение.syntaxCopy() : null,
            origType ? origType.syntaxCopy() : null,
            класс_хранения,
            userAttribDecl ? cast(UserAttributeDeclaration)userAttribDecl.syntaxCopy(s) : null,
            depdecl ? cast(DeprecatedDeclaration)depdecl.syntaxCopy(s) : null);
    }

    override ткст0 вид()
    {
        return "enum member";
    }

    Выражение getVarExp(ref Место место, Scope* sc)
    {
        dsymbolSemantic(this, sc);
        if (errors)
            return new ErrorExp();
        checkDisabled(место, sc);

        if (depdecl && !depdecl._scope)
            depdecl._scope = sc;
        checkDeprecated(место, sc);

        if (errors)
            return new ErrorExp();
        Выражение e = new VarExp(место, this);
        return e.ВыражениеSemantic(sc);
    }

    override EnumMember isEnumMember()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/******************************************
 * Check for special enum имена.
 *
 * Special enum имена are используется by the C++ имя mangler to represent
 * C++ types that are not basic D types.
 * Параметры:
 *      идент = идентификатор to check for specialness
 * Возвращает:
 *      `да` if it is special
 */
бул isSpecialEnumIdent(Идентификатор2 идент)
{
    return  идент == Id.__c_long ||
            идент == Id.__c_ulong ||
            идент == Id.__c_longlong ||
            идент == Id.__c_ulonglong ||
            идент == Id.__c_long_double ||
            идент == Id.__c_wchar_t;
}


