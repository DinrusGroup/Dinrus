/**
 * Compiler implementation of the $(LINK2 http://www.dlang.org, D programming language)
 *
 * Copyright: Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors: Walter Bright, http://www.digitalmars.com
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:    $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/cppmanglewin.d, _cppmanglewin.d)
 * Documentation:  https://dlang.org/phobos/dmd_cppmanglewin.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/cppmanglewin.d
 */

module dmd.cppmanglewin;

import cidrus;

import dmd.arraytypes;
import dmd.cppmangle : isPrimaryDtor, isCppOperator, CppOperator;
import dmd.declaration;
import dmd.denum : isSpecialEnumIdent;
import dmd.дсимвол;
import dmd.dtemplate;
import dmd.errors;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import dmd.mtype;
import util.outbuffer;
import drc.ast.Node;
import dmd.target;
import drc.lexer.Tokens;
import dmd.typesem;
import drc.ast.Visitor;

/* Do mangling for C++ компонаж for Digital Mars C++ and Microsoft Visual C++
 */

/*extern (C++):*/


ткст0 toCppMangleMSVC(ДСимвол s)
{
    scope VisualCPPMangler v = new VisualCPPMangler(!глоб2.парамы.mscoff);
    return v.mangleOf(s);
}

ткст0 cppTypeInfoMangleMSVC(ДСимвол s)
{
    //printf("cppTypeInfoMangle(%s)\n", s.вТкст0());
    assert(0);
}

/**
 * Issues an ICE and returns да if `тип` is shared or const
 *
 * Параметры:
 *      тип = тип to check
 *
 * Возвращает:
 *      да if тип is shared or const
 *      нет otherwise
 */
private бул checkImmutableShared(Тип тип)
{
    if (тип.isImmutable() || тип.isShared())
    {
        выведиОшибку(Место.initial, "Internal Compiler Error: `shared` or `const` types cannot be mapped to C++ (%s)", тип.вТкст0());
        fatal();
        return да;
    }
    return нет;
}
private final class VisualCPPMangler : Визитор2
{
    const VC_SAVED_TYPE_CNT = 10u;
    const VC_SAVED_IDENT_CNT = 10u;

    alias  Визитор2.посети посети;
    сим*[VC_SAVED_IDENT_CNT] saved_idents;
    Тип[VC_SAVED_TYPE_CNT] saved_types;

    // IS_NOT_TOP_TYPE: when we mangling one argument, we can call посети several times (for base types of arg тип)
    // but we must save only arg тип:
    // For example: if we have an цел** argument, we should save "цел**" but посети will be called for "цел**", "цел*", "цел"
    // This флаг is set up by the посети(NextType, ) function  and should be сбрось when the arg тип output is finished.
    // MANGLE_RETURN_TYPE: return тип shouldn't be saved and substituted in arguments
    // IGNORE_CONST: in some cases we should ignore CV-modifiers.
    // ESCAPE: toplevel const non-pointer types need a '$$C' ýñêàïèðóé in addition to a cv qualifier.

    enum Flags : цел
    {
        IS_NOT_TOP_TYPE = 0x1,
        MANGLE_RETURN_TYPE = 0x2,
        IGNORE_CONST = 0x4,
        IS_DMC = 0x8,
        ESCAPE = 0x10,
    }

    alias  Flags.IS_NOT_TOP_TYPE IS_NOT_TOP_TYPE;
    alias  Flags.MANGLE_RETURN_TYPE MANGLE_RETURN_TYPE;
    alias  Flags.IGNORE_CONST IGNORE_CONST;
    alias  Flags.IS_DMC IS_DMC;
    alias  Flags.ESCAPE ESCAPE;

    цел flags;
    БуфВыв буф;

    this(VisualCPPMangler rvl)
    {
        flags |= (rvl.flags & IS_DMC);
        memcpy(&saved_idents, &rvl.saved_idents, (сим*).sizeof * VC_SAVED_IDENT_CNT);
        memcpy(&saved_types, &rvl.saved_types, Тип.sizeof * VC_SAVED_TYPE_CNT);
    }

public:
    this(бул isdmc)
    {
        if (isdmc)
        {
            flags |= IS_DMC;
        }
        memset(&saved_idents, 0, (сим*).sizeof * VC_SAVED_IDENT_CNT);
        memset(&saved_types, 0, Тип.sizeof * VC_SAVED_TYPE_CNT);
    }

    override проц посети(Тип тип)
    {
        if (checkImmutableShared(тип))
            return;

        выведиОшибку(Место.initial, "Internal Compiler Error: тип `%s` cannot be mapped to C++\n", тип.вТкст0());
        fatal(); //Fatal, because this error should be handled in frontend
    }

    override проц посети(TypeNull тип)
    {
        if (checkImmutableShared(тип))
            return;
        if (checkTypeSaved(тип))
            return;

        буф.пишиСтр("$$T");
        flags &= ~IS_NOT_TOP_TYPE;
        flags &= ~IGNORE_CONST;
    }

    override проц посети(TypeBasic тип)
    {
        //printf("посети(TypeBasic); is_not_top_type = %d\n", (цел)(flags & IS_NOT_TOP_TYPE));
        if (checkImmutableShared(тип))
            return;

        if (тип.isConst() && ((flags & IS_NOT_TOP_TYPE) || (flags & IS_DMC)))
        {
            if (checkTypeSaved(тип))
                return;
        }
        if ((тип.ty == Tbool) && checkTypeSaved(тип)) // try to replace long имя with number
        {
            return;
        }
        if (!(flags & IS_DMC))
        {
            switch (тип.ty)
            {
            case Tint64:
            case Tuns64:
            case Tint128:
            case Tuns128:
            case Tfloat80:
            case Twchar:
                if (checkTypeSaved(тип))
                    return;
                break;

            default:
                break;
            }
        }
        mangleModifier(тип);
        switch (тип.ty)
        {
        case Tvoid:
            буф.пишиБайт('X');
            break;
        case Tint8:
            буф.пишиБайт('C');
            break;
        case Tuns8:
            буф.пишиБайт('E');
            break;
        case Tint16:
            буф.пишиБайт('F');
            break;
        case Tuns16:
            буф.пишиБайт('G');
            break;
        case Tint32:
            буф.пишиБайт('H');
            break;
        case Tuns32:
            буф.пишиБайт('I');
            break;
        case Tfloat32:
            буф.пишиБайт('M');
            break;
        case Tint64:
            буф.пишиСтр("_J");
            break;
        case Tuns64:
            буф.пишиСтр("_K");
            break;
        case Tint128:
            буф.пишиСтр("_L");
            break;
        case Tuns128:
            буф.пишиСтр("_M");
            break;
        case Tfloat64:
            буф.пишиБайт('N');
            break;
        case Tfloat80:
            if (flags & IS_DMC)
                буф.пишиСтр("_Z"); // DigitalMars long double
            else
                буф.пишиСтр("_T"); // Intel long double
            break;
        case Tbool:
            буф.пишиСтр("_N");
            break;
        case Tchar:
            буф.пишиБайт('D');
            break;
        case Twchar:
            буф.пишиСтр("_S"); // Visual C++ char16_t (since C++11)
            break;
        case Tdchar:
            буф.пишиСтр("_U"); // Visual C++ char32_t (since C++11)
            break;
        default:
            посети(cast(Тип)тип);
            return;
        }
        flags &= ~IS_NOT_TOP_TYPE;
        flags &= ~IGNORE_CONST;
    }

    override проц посети(TypeVector тип)
    {
        //printf("посети(TypeVector); is_not_top_type = %d\n", (цел)(flags & IS_NOT_TOP_TYPE));
        if (checkTypeSaved(тип))
            return;
        буф.пишиСтр("T__m128@@"); // may be better as __m128i or __m128d?
        flags &= ~IS_NOT_TOP_TYPE;
        flags &= ~IGNORE_CONST;
    }

    override проц посети(TypeSArray тип)
    {
        // This method can be called only for static variable тип mangling.
        //printf("посети(TypeSArray); is_not_top_type = %d\n", (цел)(flags & IS_NOT_TOP_TYPE));
        if (checkTypeSaved(тип))
            return;
        // first dimension always mangled as const pointer
        if (flags & IS_DMC)
            буф.пишиБайт('Q');
        else
            буф.пишиБайт('P');
        flags |= IS_NOT_TOP_TYPE;
        assert(тип.следщ);
        if (тип.следщ.ty == Tsarray)
        {
            mangleArray(cast(TypeSArray)тип.следщ);
        }
        else
        {
            тип.следщ.прими(this);
        }
    }

    // attention: D цел[1][2]* arr mapped to C++ цел arr[][2][1]; (because it's more typical situation)
    // There is not way to map цел C++ (*arr)[2][1] to D
    override проц посети(TypePointer тип)
    {
        //printf("посети(TypePointer); is_not_top_type = %d\n", (цел)(flags & IS_NOT_TOP_TYPE));
        if (checkImmutableShared(тип))
            return;

        assert(тип.следщ);
        if (тип.следщ.ty == Tfunction)
        {
            ткст0 arg = mangleFunctionType(cast(TypeFunction)тип.следщ); // compute args before checking to save; args should be saved before function тип
            // If we've mangled this function early, previous call is meaningless.
            // However we should do it before checking to save types of function arguments before function тип saving.
            // If this function was already mangled, types of all it arguments are save too, thus previous can't save
            // anything if function is saved.
            if (checkTypeSaved(тип))
                return;
            if (тип.isConst())
                буф.пишиБайт('Q'); // const
            else
                буф.пишиБайт('P'); // mutable
            буф.пишиБайт('6'); // pointer to a function
            буф.пишиСтр(arg);
            flags &= ~IS_NOT_TOP_TYPE;
            flags &= ~IGNORE_CONST;
            return;
        }
        else if (тип.следщ.ty == Tsarray)
        {
            if (checkTypeSaved(тип))
                return;
            mangleModifier(тип);
            if (тип.isConst() || !(flags & IS_DMC))
                буф.пишиБайт('Q'); // const
            else
                буф.пишиБайт('P'); // mutable
            if (глоб2.парамы.is64bit)
                буф.пишиБайт('E');
            flags |= IS_NOT_TOP_TYPE;
            mangleArray(cast(TypeSArray)тип.следщ);
            return;
        }
        else
        {
            if (checkTypeSaved(тип))
                return;
            mangleModifier(тип);
            if (тип.isConst())
            {
                буф.пишиБайт('Q'); // const
            }
            else
            {
                буф.пишиБайт('P'); // mutable
            }
            if (глоб2.парамы.is64bit)
                буф.пишиБайт('E');
            flags |= IS_NOT_TOP_TYPE;
            тип.следщ.прими(this);
        }
    }

    override проц посети(TypeReference тип)
    {
        //printf("посети(TypeReference); тип = %s\n", тип.вТкст0());
        if (checkTypeSaved(тип))
            return;

        if (checkImmutableShared(тип))
            return;

        буф.пишиБайт('A'); // mutable
        if (глоб2.парамы.is64bit)
            буф.пишиБайт('E');
        flags |= IS_NOT_TOP_TYPE;
        assert(тип.следщ);
        if (тип.следщ.ty == Tsarray)
        {
            mangleArray(cast(TypeSArray)тип.следщ);
        }
        else
        {
            тип.следщ.прими(this);
        }
    }

    override проц посети(TypeFunction тип)
    {
        ткст0 arg = mangleFunctionType(тип);
        if ((flags & IS_DMC))
        {
            if (checkTypeSaved(тип))
                return;
        }
        else
        {
            буф.пишиСтр("$$A6");
        }
        буф.пишиСтр(arg);
        flags &= ~(IS_NOT_TOP_TYPE | IGNORE_CONST);
    }

    override проц посети(TypeStruct тип)
    {
        if (checkTypeSaved(тип))
            return;
        //printf("посети(TypeStruct); is_not_top_type = %d\n", (цел)(flags & IS_NOT_TOP_TYPE));
        mangleModifier(тип);
        if (тип.sym.isUnionDeclaration())
            буф.пишиБайт('T');
        else
            буф.пишиБайт(тип.cppmangle == CPPMANGLE.asClass ? 'V' : 'U');
        mangleIdent(тип.sym);
        flags &= ~IS_NOT_TOP_TYPE;
        flags &= ~IGNORE_CONST;
    }

    override проц посети(TypeEnum тип)
    {
        //printf("посети(TypeEnum); is_not_top_type = %d\n", (цел)(flags & IS_NOT_TOP_TYPE));
        const ид = тип.sym.идент;
        ткст c;
        if (ид == Id.__c_long_double)
            c = "O"; // VC++ long double
        else if (ид == Id.__c_long)
            c = "J"; // VC++ long
        else if (ид == Id.__c_ulong)
            c = "K"; // VC++ unsigned long
        else if (ид == Id.__c_longlong)
            c = "_J"; // VC++ long long
        else if (ид == Id.__c_ulonglong)
            c = "_K"; // VC++ unsigned long long
        else if (ид == Id.__c_wchar_t)
        {
            c = (flags & IS_DMC) ? "_Y" : "_W";
        }

        if (c.length)
        {
            if (checkImmutableShared(тип))
                return;

            if (тип.isConst() && ((flags & IS_NOT_TOP_TYPE) || (flags & IS_DMC)))
            {
                if (checkTypeSaved(тип))
                    return;
            }
            mangleModifier(тип);
            буф.пишиСтр(c);
        }
        else
        {
            if (checkTypeSaved(тип))
                return;
            mangleModifier(тип);
            буф.пишиСтр("W4");
            mangleIdent(тип.sym);
        }
        flags &= ~IS_NOT_TOP_TYPE;
        flags &= ~IGNORE_CONST;
    }

    // D class mangled as pointer to C++ class
    // const(Object) mangled as Object const* const
    override проц посети(TypeClass тип)
    {
        //printf("посети(TypeClass); is_not_top_type = %d\n", (цел)(flags & IS_NOT_TOP_TYPE));
        if (checkTypeSaved(тип))
            return;
        if (flags & IS_NOT_TOP_TYPE)
            mangleModifier(тип);
        if (тип.isConst())
            буф.пишиБайт('Q');
        else
            буф.пишиБайт('P');
        if (глоб2.парамы.is64bit)
            буф.пишиБайт('E');
        flags |= IS_NOT_TOP_TYPE;
        mangleModifier(тип);
        буф.пишиБайт(тип.cppmangle == CPPMANGLE.asStruct ? 'U' : 'V');
        mangleIdent(тип.sym);
        flags &= ~IS_NOT_TOP_TYPE;
        flags &= ~IGNORE_CONST;
    }

    ткст0 mangleOf(ДСимвол s)
    {
        VarDeclaration vd = s.isVarDeclaration();
        FuncDeclaration fd = s.isFuncDeclaration();
        if (vd)
        {
            mangleVariable(vd);
        }
        else if (fd)
        {
            mangleFunction(fd);
        }
        else
        {
            assert(0);
        }
        return буф.extractChars();
    }

private:
    проц mangleFunction(FuncDeclaration d)
    {
        // <function mangle> ? <qualified имя> <flags> <return тип> <arg list>
        assert(d);
        буф.пишиБайт('?');
        mangleIdent(d);
        if (d.needThis()) // <flags> ::= <virtual/защита флаг> <const/volatile флаг> <calling convention флаг>
        {
            // Pivate methods always non-virtual in D and it should be mangled as non-virtual in C++
            //printf("%s: isVirtualMethod = %d, isVirtual = %d, vtblIndex = %d, interfaceVirtual = %p\n",
                //d.вТкст0(), d.isVirtualMethod(), d.isVirtual(), cast(цел)d.vtblIndex, d.interfaceVirtual);
            if ((d.isVirtual() && (d.vtblIndex != -1 || d.interfaceVirtual || d.overrideInterface())) || (d.isDtorDeclaration() && d.родитель.isClassDeclaration() && !d.isFinal()))
            {
                switch (d.защита.вид)
                {
                case Prot.Kind.private_:
                    буф.пишиБайт('E');
                    break;
                case Prot.Kind.protected_:
                    буф.пишиБайт('M');
                    break;
                default:
                    буф.пишиБайт('U');
                    break;
                }
            }
            else
            {
                switch (d.защита.вид)
                {
                case Prot.Kind.private_:
                    буф.пишиБайт('A');
                    break;
                case Prot.Kind.protected_:
                    буф.пишиБайт('I');
                    break;
                default:
                    буф.пишиБайт('Q');
                    break;
                }
            }
            if (глоб2.парамы.is64bit)
                буф.пишиБайт('E');
            if (d.тип.isConst())
            {
                буф.пишиБайт('B');
            }
            else
            {
                буф.пишиБайт('A');
            }
        }
        else if (d.isMember2()) // static function
        {
            // <flags> ::= <virtual/защита флаг> <calling convention флаг>
            switch (d.защита.вид)
            {
            case Prot.Kind.private_:
                буф.пишиБайт('C');
                break;
            case Prot.Kind.protected_:
                буф.пишиБайт('K');
                break;
            default:
                буф.пишиБайт('S');
                break;
            }
        }
        else // top-уровень function
        {
            // <flags> ::= Y <calling convention флаг>
            буф.пишиБайт('Y');
        }
        ткст0 args = mangleFunctionType(cast(TypeFunction)d.тип, d.needThis(), d.isCtorDeclaration() || isPrimaryDtor(d));
        буф.пишиСтр(args);
    }

    проц mangleVariable(VarDeclaration d)
    {
        // <static variable mangle> ::= ? <qualified имя> <защита флаг> <const/volatile флаг> <тип>
        assert(d);
        // fake mangling for fields to fix https://issues.dlang.org/show_bug.cgi?ид=16525
        if (!(d.класс_хранения & (STC.extern_ | STC.field | STC.gshared)))
        {
            d.выведиОшибку("Internal Compiler Error: C++ static non- non-extern variables not supported");
            fatal();
        }
        буф.пишиБайт('?');
        mangleIdent(d);
        assert((d.класс_хранения & STC.field) || !d.needThis());
        ДСимвол родитель = d.toParent();
        while (родитель && родитель.isNspace())
        {
            родитель = родитель.toParent();
        }
        if (родитель && родитель.isModule()) // static member
        {
            буф.пишиБайт('3');
        }
        else
        {
            switch (d.защита.вид)
            {
            case Prot.Kind.private_:
                буф.пишиБайт('0');
                break;
            case Prot.Kind.protected_:
                буф.пишиБайт('1');
                break;
            default:
                буф.пишиБайт('2');
                break;
            }
        }
        сим cv_mod = 0;
        Тип t = d.тип;

        if (checkImmutableShared(t))
            return;

        if (t.isConst())
        {
            cv_mod = 'B'; // const
        }
        else
        {
            cv_mod = 'A'; // mutable
        }
        if (t.ty != Tpointer)
            t = t.mutableOf();
        t.прими(this);
        if ((t.ty == Tpointer || t.ty == Treference || t.ty == Tclass) && глоб2.парамы.is64bit)
        {
            буф.пишиБайт('E');
        }
        буф.пишиБайт(cv_mod);
    }

    /**
     * Computes mangling for symbols with special mangling.
     * Параметры:
     *      sym = symbol to mangle
     * Возвращает:
     *      mangling for special symbols,
     *      null if not a special symbol
     */
    extern (D) static ткст mangleSpecialName(ДСимвол sym)
    {
        ткст mangle;
        if (sym.isCtorDeclaration())
            mangle = "?0";
        else if (sym.isPrimaryDtor())
            mangle = "?1";
        else if (!sym.идент)
            return null;
        else if (sym.идент == Id.assign)
            mangle = "?4";
        else if (sym.идент == Id.eq)
            mangle = "?8";
        else if (sym.идент == Id.index)
            mangle = "?A";
        else if (sym.идент == Id.call)
            mangle = "?R";
        else if (sym.идент == Id.cppdtor)
            mangle = "?_G";
        else
            return null;

        return mangle;
    }

    /**
     * Mangles an operator, if any
     *
     * Параметры:
     *      ti                  = associated template instance of the operator
     *      symName             = symbol имя
     *      firstTemplateArg    = index if the first argument of the template (because the corresponding c++ operator is not a template)
     * Возвращает:
     *      да if sym has no further mangling needed
     *      нет otherwise
     */
    бул mangleOperator(TemplateInstance ti, ref ткст0 symName, ref цел firstTemplateArg)
    {
        auto whichOp = isCppOperator(ti.имя);
        switch (whichOp)
        {
        case CppOperator.Unknown:
            return нет;
        case CppOperator.Cast:
            буф.пишиСтр("?B");
            return да;
        case CppOperator.Assign:
            symName = "?4";
            return нет;
        case CppOperator.Eq:
            symName = "?8";
            return нет;
        case CppOperator.Index:
            symName = "?A";
            return нет;
        case CppOperator.Call:
            symName = "?R";
            return нет;

        case CppOperator.Unary:
        case CppOperator.Binary:
        case CppOperator.OpAssign:
            TemplateDeclaration td = ti.tempdecl.isTemplateDeclaration();
            assert(td);
            assert(ti.tiargs.dim >= 1);
            ПараметрШаблона2 tp = (*td.parameters)[0];
            TemplateValueParameter tv = tp.isTemplateValueParameter();
            if (!tv || !tv.valType.isString())
                return нет; // expecting a ткст argument to operators!
            Выражение exp = (*ti.tiargs)[0].выражение_ли();
            StringExp str = exp.вТкстExp();
            switch (whichOp)
            {
            case CppOperator.Unary:
                switch (str.peekString())
                {
                    case "*":   symName = "?D";     goto continue_template;
                    case "++":  symName = "?E";     goto continue_template;
                    case "--":  symName = "?F";     goto continue_template;
                    case "-":   symName = "?G";     goto continue_template;
                    case "+":   symName = "?H";     goto continue_template;
                    case "~":   symName = "?S";     goto continue_template;
                    default:    return нет;
                }
            case CppOperator.Binary:
                switch (str.peekString())
                {
                    case ">>":  symName = "?5";     goto continue_template;
                    case "<<":  symName = "?6";     goto continue_template;
                    case "*":   symName = "?D";     goto continue_template;
                    case "-":   symName = "?G";     goto continue_template;
                    case "+":   symName = "?H";     goto continue_template;
                    case "&":   symName = "?I";     goto continue_template;
                    case "/":   symName = "?K";     goto continue_template;
                    case "%":   symName = "?L";     goto continue_template;
                    case "^":   symName = "?T";     goto continue_template;
                    case "|":   symName = "?U";     goto continue_template;
                    default:    return нет;
                    }
            case CppOperator.OpAssign:
                switch (str.peekString())
                {
                    case "*":   symName = "?X";     goto continue_template;
                    case "+":   symName = "?Y";     goto continue_template;
                    case "-":   symName = "?Z";     goto continue_template;
                    case "/":   symName = "?_0";    goto continue_template;
                    case "%":   symName = "?_1";    goto continue_template;
                    case ">>":  symName = "?_2";    goto continue_template;
                    case "<<":  symName = "?_3";    goto continue_template;
                    case "&":   symName = "?_4";    goto continue_template;
                    case "|":   symName = "?_5";    goto continue_template;
                    case "^":   symName = "?_6";    goto continue_template;
                    default:    return нет;
                }
            default: assert(0);
            }
        }
        continue_template:
        if (ti.tiargs.dim == 1)
        {
            буф.пишиСтр(symName);
            return да;
        }
        firstTemplateArg = 1;
        return нет;
    }

    /**
     * Mangles a template значение
     *
     * Параметры:
     *      o               = Выражение that represents the значение
     *      tv              = template значение
     *      is_dmc_template = use DMC mangling
     */
    проц manlgeTemplateValue(КорневойОбъект o,TemplateValueParameter tv, ДСимвол sym,бул is_dmc_template)
    {
        if (!tv.valType.isintegral())
        {
            sym.выведиОшибку("Internal Compiler Error: C++ %s template значение параметр is not supported", tv.valType.вТкст0());
            fatal();
            return;
        }
        буф.пишиБайт('$');
        буф.пишиБайт('0');
        Выражение e = выражение_ли(o);
        assert(e);
        if (tv.valType.isunsigned())
        {
            mangleNumber(e.toUInteger());
        }
        else if (is_dmc_template)
        {
            // NOTE: DMC mangles everything based on
            // unsigned цел
            mangleNumber(e.toInteger());
        }
        else
        {
            sinteger_t val = e.toInteger();
            if (val < 0)
            {
                val = -val;
                буф.пишиБайт('?');
            }
            mangleNumber(val);
        }
    }

    /**
     * Mangles a template alias параметр
     *
     * Параметры:
     *      o   = the alias значение, a symbol or Выражение
     */
    проц mangleTemplateAlias(КорневойОбъект o, ДСимвол sym)
    {
        ДСимвол d = isDsymbol(o);
        Выражение e = выражение_ли(o);

        if (d && d.isFuncDeclaration())
        {
            буф.пишиБайт('$');
            буф.пишиБайт('1');
            mangleFunction(d.isFuncDeclaration());
        }
        else if (e && e.op == ТОК2.variable && (cast(VarExp)e).var.isVarDeclaration())
        {
            буф.пишиБайт('$');
            if (flags & IS_DMC)
                буф.пишиБайт('1');
            else
                буф.пишиБайт('E');
            mangleVariable((cast(VarExp)e).var.isVarDeclaration());
        }
        else if (d && d.isTemplateDeclaration() && d.isTemplateDeclaration().onemember)
        {
            ДСимвол ds = d.isTemplateDeclaration().onemember;
            if (flags & IS_DMC)
            {
                буф.пишиБайт('V');
            }
            else
            {
                if (ds.isUnionDeclaration())
                {
                    буф.пишиБайт('T');
                }
                else if (ds.isStructDeclaration())
                {
                    буф.пишиБайт('U');
                }
                else if (ds.isClassDeclaration())
                {
                    буф.пишиБайт('V');
                }
                else
                {
                    sym.выведиОшибку("Internal Compiler Error: C++ templates support only integral значение, тип parameters, alias templates and alias function parameters");
                    fatal();
                }
            }
            mangleIdent(d);
        }
        else
        {
            sym.выведиОшибку("Internal Compiler Error: `%s` is unsupported параметр for C++ template", o.вТкст0());
            fatal();
        }
    }

    /**
     * Mangles a template alias параметр
     *
     * Параметры:
     *      o   = тип
     */
    проц mangleTemplateType(КорневойОбъект o)
    {
        flags |= ESCAPE;
        Тип t = тип_ли(o);
        assert(t);
        t.прими(this);
        flags &= ~ESCAPE;
    }

    /**
     * Mangles the имя of a symbol
     *
     * Параметры:
     *      sym   = symbol to mangle
     *      dont_use_back_reference = dont use back referencing
     */
    проц mangleName(ДСимвол sym, бул dont_use_back_reference)
    {
        //printf("mangleName('%s')\n", sym.вТкст0());
        ткст0 имя = null;
        бул is_dmc_template = нет;

        if (ткст s = mangleSpecialName(sym))
        {
            буф.пишиСтр(s);
            return;
        }

        if (TemplateInstance ti = sym.isTemplateInstance())
        {
            auto ид = ti.tempdecl.идент;
            ткст0 symName = ид.вТкст0();

            цел firstTemplateArg = 0;

            // test for special symbols
            if (mangleOperator(ti,symName,firstTemplateArg))
                return;

            scope VisualCPPMangler tmp = new VisualCPPMangler((flags & IS_DMC) ? да : нет);
            tmp.буф.пишиБайт('?');
            tmp.буф.пишиБайт('$');
            tmp.буф.пишиСтр(symName);
            tmp.saved_idents[0] = symName;
            if (symName == ид.вТкст0())
                tmp.буф.пишиБайт('@');
            if (flags & IS_DMC)
            {
                tmp.mangleIdent(sym.родитель, да);
                is_dmc_template = да;
            }
            бул is_var_arg = нет;
            for (т_мера i = firstTemplateArg; i < ti.tiargs.dim; i++)
            {
                КорневойОбъект o = (*ti.tiargs)[i];
                ПараметрШаблона2 tp = null;
                TemplateValueParameter tv = null;
                TemplateTupleParameter tt = null;
                if (!is_var_arg)
                {
                    TemplateDeclaration td = ti.tempdecl.isTemplateDeclaration();
                    assert(td);
                    tp = (*td.parameters)[i];
                    tv = tp.isTemplateValueParameter();
                    tt = tp.isTemplateTupleParameter();
                }
                if (tt)
                {
                    is_var_arg = да;
                    tp = null;
                }
                if (tv)
                {
                    tmp.manlgeTemplateValue(o, tv, sym, is_dmc_template);
                }
                else if (!tp || tp.isTemplateTypeParameter())
                {
                    tmp.mangleTemplateType(o);
                }
                else if (tp.isTemplateAliasParameter())
                {
                    tmp.mangleTemplateAlias(o, sym);
                }
                else
                {
                    sym.выведиОшибку("Internal Compiler Error: C++ templates support only integral значение, тип parameters, alias templates and alias function parameters");
                    fatal();
                }
            }
            имя = tmp.буф.extractChars();
        }
        else
        {
            // Not a template
            имя = sym.идент.вТкст0();
        }
        assert(имя);
        if (is_dmc_template)
        {
            if (checkAndSaveIdent(имя))
                return;
        }
        else
        {
            if (dont_use_back_reference)
            {
                saveIdent(имя);
            }
            else
            {
                if (checkAndSaveIdent(имя))
                    return;
            }
        }
        буф.пишиСтр(имя);
        буф.пишиБайт('@');
    }

    // returns да if имя already saved
    бул checkAndSaveIdent(ткст0 имя)
    {
        foreach (i; new бцел[0 .. VC_SAVED_IDENT_CNT])
        {
            if (!saved_idents[i]) // no saved same имя
            {
                saved_idents[i] = имя;
                break;
            }
            if (!strcmp(saved_idents[i], имя)) // ok, we've found same имя. use index instead of имя
            {
                буф.пишиБайт(i + '0');
                return да;
            }
        }
        return нет;
    }

    проц saveIdent(ткст0 имя)
    {
        foreach (i; new бцел[0 .. VC_SAVED_IDENT_CNT])
        {
            if (!saved_idents[i]) // no saved same имя
            {
                saved_idents[i] = имя;
                break;
            }
            if (!strcmp(saved_idents[i], имя)) // ok, we've found same имя. use index instead of имя
            {
                return;
            }
        }
    }

    проц mangleIdent(ДСимвол sym, бул dont_use_back_reference = нет)
    {
        // <qualified имя> ::= <sub-имя list> @
        // <sub-имя list>  ::= <sub-имя> <имя parts>
        //                  ::= <sub-имя>
        // <sub-имя> ::= <идентификатор> @
        //            ::= ?$ <идентификатор> @ <template args> @
        //            :: <back reference>
        // <back reference> ::= 0-9
        // <template args> ::= <template arg> <template args>
        //                ::= <template arg>
        // <template arg>  ::= <тип>
        //                ::= $0<encoded integral number>
        //printf("mangleIdent('%s')\n", sym.вТкст0());
        ДСимвол p = sym;
        if (p.toParent() && p.toParent().isTemplateInstance())
        {
            p = p.toParent();
        }
        while (p && !p.isModule())
        {
            mangleName(p, dont_use_back_reference);
            // Mangle our ткст namespaces as well
            for (auto ns = p.cppnamespace; ns !is null; ns = ns.cppnamespace)
                mangleName(ns, dont_use_back_reference);
            p = p.toParent();
            if (p.toParent() && p.toParent().isTemplateInstance())
            {
                p = p.toParent();
            }
        }
        if (!dont_use_back_reference)
            буф.пишиБайт('@');
    }

    проц mangleNumber(dinteger_t num)
    {
        if (!num) // 0 encoded as "A@"
        {
            буф.пишиБайт('A');
            буф.пишиБайт('@');
            return;
        }
        if (num <= 10) // 5 encoded as "4"
        {
            буф.пишиБайт(cast(сим)(num - 1 + '0'));
            return;
        }
        сим[17] buff;
        buff[16] = 0;
        т_мера i = 16;
        while (num)
        {
            --i;
            buff[i] = num % 16 + 'A';
            num /= 16;
        }
        буф.пишиСтр(&buff[i]);
        буф.пишиБайт('@');
    }

    бул checkTypeSaved(Тип тип)
    {
        if (flags & IS_NOT_TOP_TYPE)
            return нет;
        if (flags & MANGLE_RETURN_TYPE)
            return нет;
        for (бцел i = 0; i < VC_SAVED_TYPE_CNT; i++)
        {
            if (!saved_types[i]) // no saved same тип
            {
                saved_types[i] = тип;
                return нет;
            }
            if (saved_types[i].равен(тип)) // ok, we've found same тип. use index instead of тип
            {
                буф.пишиБайт(i + '0');
                flags &= ~IS_NOT_TOP_TYPE;
                flags &= ~IGNORE_CONST;
                return да;
            }
        }
        return нет;
    }

    проц mangleModifier(Тип тип)
    {
        if (flags & IGNORE_CONST)
            return;
        if (checkImmutableShared(тип))
            return;

        if (тип.isConst())
        {
            // Template parameters that are not pointers and are const need an $$C ýñêàïèðóé
            // in addition to 'B' (const).
            if ((flags & ESCAPE) && тип.ty != Tpointer)
                буф.пишиСтр("$$CB");
            else if (flags & IS_NOT_TOP_TYPE)
                буф.пишиБайт('B'); // const
            else if ((flags & IS_DMC) && тип.ty != Tpointer)
                буф.пишиСтр("_O");
        }
        else if (flags & IS_NOT_TOP_TYPE)
            буф.пишиБайт('A'); // mutable

        flags &= ~ESCAPE;
    }

    проц mangleArray(TypeSArray тип)
    {
        mangleModifier(тип);
        т_мера i = 0;
        Тип cur = тип;
        while (cur && cur.ty == Tsarray)
        {
            i++;
            cur = cur.nextOf();
        }
        буф.пишиБайт('Y');
        mangleNumber(i); // count of dimensions
        cur = тип;
        while (cur && cur.ty == Tsarray) // sizes of dimensions
        {
            TypeSArray sa = cast(TypeSArray)cur;
            mangleNumber(sa.dim ? sa.dim.toInteger() : 0);
            cur = cur.nextOf();
        }
        flags |= IGNORE_CONST;
        cur.прими(this);
    }

    ткст0 mangleFunctionType(TypeFunction тип, бул needthis = нет, бул noreturn = нет)
    {
        scope VisualCPPMangler tmp = new VisualCPPMangler(this);
        // Calling convention
        if (глоб2.парамы.is64bit) // always Microsoft x64 calling convention
        {
            tmp.буф.пишиБайт('A');
        }
        else
        {
            switch (тип.компонаж)
            {
            case LINK.c:
                tmp.буф.пишиБайт('A');
                break;
            case LINK.cpp:
                if (needthis && тип.parameterList.varargs != ВарАрг.variadic)
                    tmp.буф.пишиБайт('E'); // thiscall
                else
                    tmp.буф.пишиБайт('A'); // cdecl
                break;
            case LINK.windows:
                tmp.буф.пишиБайт('G'); // stdcall
                break;
            case LINK.pascal:
                tmp.буф.пишиБайт('C');
                break;
            case LINK.d:
            case LINK.default_:
            case LINK.system:
            case LINK.objc:
                tmp.посети(cast(Тип)тип);
                break;
            }
        }
        tmp.flags &= ~IS_NOT_TOP_TYPE;
        if (noreturn)
        {
            tmp.буф.пишиБайт('@');
        }
        else
        {
            Тип rettype = тип.следщ;
            if (тип.isref)
                rettype = rettype.referenceTo();
            flags &= ~IGNORE_CONST;
            if (rettype.ty == Tstruct)
            {
                tmp.буф.пишиБайт('?');
                tmp.буф.пишиБайт('A');
            }
            else if (rettype.ty == Tenum)
            {
                const ид = rettype.toDsymbol(null).идент;
                if (!isSpecialEnumIdent(ид))
                {
                    tmp.буф.пишиБайт('?');
                    tmp.буф.пишиБайт('A');
                }
            }
            tmp.flags |= MANGLE_RETURN_TYPE;
            rettype.прими(tmp);
            tmp.flags &= ~MANGLE_RETURN_TYPE;
        }
        if (!тип.parameterList.parameters || !тип.parameterList.parameters.dim)
        {
            if (тип.parameterList.varargs == ВарАрг.variadic)
                tmp.буф.пишиБайт('Z');
            else
                tmp.буф.пишиБайт('X');
        }
        else
        {
            цел mangleParameterDg(т_мера n, Параметр2 p)
            {
                Тип t = p.тип;
                if (p.классХранения & (STC.out_ | STC.ref_))
                {
                    t = t.referenceTo();
                }
                else if (p.классХранения & STC.lazy_)
                {
                    // Mangle as delegate
                    Тип td = new TypeFunction(СписокПараметров(), t, LINK.d);
                    td = new TypeDelegate(td);
                    t = merge(t);
                }
                if (t.ty == Tsarray)
                {
                    выведиОшибку(Место.initial, "Internal Compiler Error: unable to pass static массив to `/*extern(C++)*/` function.");
                    выведиОшибку(Место.initial, "Use pointer instead.");
                    assert(0);
                }
                tmp.flags &= ~IS_NOT_TOP_TYPE;
                tmp.flags &= ~IGNORE_CONST;
                t.прими(tmp);
                return 0;
            }

            Параметр2._foreach(тип.parameterList.parameters, &mangleParameterDg);
            if (тип.parameterList.varargs == ВарАрг.variadic)
            {
                tmp.буф.пишиБайт('Z');
            }
            else
            {
                tmp.буф.пишиБайт('@');
            }
        }
        tmp.буф.пишиБайт('Z');
        ткст0 ret = tmp.буф.extractChars();
        memcpy(&saved_idents, &tmp.saved_idents, (сим*).sizeof * VC_SAVED_IDENT_CNT);
        memcpy(&saved_types, &tmp.saved_types, Тип.sizeof * VC_SAVED_TYPE_CNT);
        return ret;
    }
}
