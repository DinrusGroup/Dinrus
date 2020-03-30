/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/typeinf.d, _typeinf.d)
 * Documentation:  https://dlang.org/phobos/dmd_typinf.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/typinf.d
 */

module dmd.typinf;

import dmd.declaration;
import dmd.dmodule;
import dmd.dscope;
import dmd.dclass;
import dmd.dstruct;
import dmd.errors;
import dmd.globals;
import dmd.gluelayer;
import dmd.mtype;
import drc.ast.Visitor;
import cidrus;

/****************************************************
 * Generates the `TypeInfo` объект associated with `torig` if it
 * hasn't already been generated
 * Параметры:
 *      место   = the location for reporting line numbers in errors
 *      torig = the тип to generate the `TypeInfo` объект for
 *      sc    = the scope
 */
проц genTypeInfo(Место место, Тип torig, Scope* sc)
{
    // printf("genTypeInfo() %s\n", torig.вТкст0());

    // Even when compiling without `useTypeInfo` (e.g. -betterC) we should
    // still be able to evaluate `TypeInfo` at compile-time, just not at runtime.
    // https://issues.dlang.org/show_bug.cgi?ид=18472
    if (!sc || !(sc.flags & SCOPE.ctfe))
    {
        if (!глоб2.парамы.useTypeInfo)
        {
            .выведиОшибку(место, "`TypeInfo` cannot be используется with -betterC");
            fatal();
        }
    }

    if (!Тип.dtypeinfo)
    {
        .выведиОшибку(место, "`объект.TypeInfo` could not be found, but is implicitly используется");
        fatal();
    }

    Тип t = torig.merge2(); // do this since not all Тип's are merge'd
    if (!t.vtinfo)
    {
        if (t.isShared()) // does both 'shared' and 'shared const'
            t.vtinfo = TypeInfoSharedDeclaration.создай(t);
        else if (t.isConst())
            t.vtinfo = TypeInfoConstDeclaration.создай(t);
        else if (t.isImmutable())
            t.vtinfo = TypeInfoInvariantDeclaration.создай(t);
        else if (t.isWild())
            t.vtinfo = TypeInfoWildDeclaration.создай(t);
        else
            t.vtinfo = getTypeInfoDeclaration(t);
        assert(t.vtinfo);

        /* If this has a custom implementation in std/typeinfo, then
         * do not generate a COMDAT for it.
         */
        if (!builtinTypeInfo(t))
        {
            // Generate COMDAT
            if (sc) // if in semantic() pass
            {
                // Find module that will go all the way to an объект файл
                Module m = sc._module.importedFrom;
                m.члены.сунь(t.vtinfo);
            }
            else // if in obj generation pass
            {
                toObjFile(t.vtinfo, глоб2.парамы.multiobj);
            }
        }
    }
    if (!torig.vtinfo)
        torig.vtinfo = t.vtinfo; // Types aren't merged, but we can share the vtinfo's
    assert(torig.vtinfo);
}

/****************************************************
 * Gets the тип of the `TypeInfo` объект associated with `t`
 * Параметры:
 *      место = the location for reporting line nunbers in errors
 *      t   = the тип to get the тип of the `TypeInfo` объект for
 *      sc  = the scope
 * Возвращает:
 *      The тип of the `TypeInfo` объект associated with `t`
 */
 Тип getTypeInfoType(Место место, Тип t, Scope* sc)
{
    assert(t.ty != Terror);
    genTypeInfo(место, t, sc);
    return t.vtinfo.тип;
}

private TypeInfoDeclaration getTypeInfoDeclaration(Тип t)
{
    //printf("Тип::getTypeInfoDeclaration() %s\n", t.вТкст0());
    switch (t.ty)
    {
    case Tpointer:
        return TypeInfoPointerDeclaration.создай(t);
    case Tarray:
        return TypeInfoArrayDeclaration.создай(t);
    case Tsarray:
        return TypeInfoStaticArrayDeclaration.создай(t);
    case Taarray:
        return TypeInfoAssociativeArrayDeclaration.создай(t);
    case Tstruct:
        return TypeInfoStructDeclaration.создай(t);
    case Tvector:
        return TypeInfoVectorDeclaration.создай(t);
    case Tenum:
        return TypeInfoEnumDeclaration.создай(t);
    case Tfunction:
        return TypeInfoFunctionDeclaration.создай(t);
    case Tdelegate:
        return TypeInfoDelegateDeclaration.создай(t);
    case Ttuple:
        return TypeInfoTupleDeclaration.создай(t);
    case Tclass:
        if ((cast(TypeClass)t).sym.isInterfaceDeclaration())
            return TypeInfoInterfaceDeclaration.создай(t);
        else
            return TypeInfoClassDeclaration.создай(t);

    default:
        return TypeInfoDeclaration.создай(t);
    }
}

/**************************************************
 * Возвращает:
 *      да if any part of тип t is speculative.
 *      if t is null, returns нет.
 */
бул isSpeculativeType(Тип t)
{
    static бул visitVector(TypeVector t)
    {
        return isSpeculativeType(t.basetype);
    }

    static бул visitAArray(TypeAArray t)
    {
        return isSpeculativeType(t.index) ||
               isSpeculativeType(t.следщ);
    }

    static бул visitStruct(TypeStruct t)
    {
        StructDeclaration sd = t.sym;
        if (auto ti = sd.isInstantiated())
        {
            if (!ti.needsCodegen())
            {
                if (ti.minst || sd.requestTypeInfo)
                    return нет;

                /* https://issues.dlang.org/show_bug.cgi?ид=14425
                 * TypeInfo_Struct would refer the члены of
                 * struct (e.g. opEquals via xopEquals field), so if it's instantiated
                 * in speculative context, TypeInfo creation should also be
                 * stopped to avoid 'unresolved symbol' linker errors.
                 */
                /* When -debug/-unittest is specified, all of non-root instances are
                 * automatically changed to speculative, and here is always reached
                 * from those instantiated non-root structs.
                 * Therefore, if the TypeInfo is not auctually requested,
                 * we have to elide its codegen.
                 */
                return да;
            }
        }
        else
        {
            //assert(!sd.inNonRoot() || sd.requestTypeInfo);    // valid?
        }
        return нет;
    }

    static бул visitClass(TypeClass t)
    {
        ClassDeclaration sd = t.sym;
        if (auto ti = sd.isInstantiated())
        {
            if (!ti.needsCodegen() && !ti.minst)
            {
                return да;
            }
        }
        return нет;
    }


    static бул visitTuple(КортежТипов t)
    {
        if (t.arguments)
        {
            foreach (arg; *t.arguments)
            {
                if (isSpeculativeType(arg.тип))
                    return да;
            }
        }
        return нет;
    }

    if (!t)
        return нет;
    Тип tb = t.toBasetype();
    switch (tb.ty)
    {
        case Tvector:   return visitVector(tb.isTypeVector());
        case Taarray:   return visitAArray(tb.isTypeAArray());
        case Tstruct:   return visitStruct(tb.isTypeStruct());
        case Tclass:    return visitClass(tb.isTypeClass());
        case Ttuple:    return visitTuple(tb.isTypeTuple());
        case Tenum:     return нет;
        default:
        return isSpeculativeType(tb.nextOf());

        /* For TypeFunction, TypeInfo_Function doesn't store параметр types,
         * so only the .следщ (the return тип) is checked here.
         */
    }
}

/* ========================================================================= */

/* These decide if there's an instance for them already in std.typeinfo,
 * because then the compiler doesn't need to build one.
 */
private бул builtinTypeInfo(Тип t)
{
    if (t.isTypeBasic() || t.ty == Tclass || t.ty == Tnull)
        return !t.mod;
    if (t.ty == Tarray)
    {
        Тип следщ = t.nextOf();
        // strings are so common, make them builtin
        return !t.mod &&
               (следщ.isTypeBasic() !is null && !следщ.mod ||
                следщ.ty == Tchar && следщ.mod == MODFlags.immutable_ ||
                следщ.ty == Tchar && следщ.mod == MODFlags.const_);
    }
    return нет;
}
