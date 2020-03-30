/**
 * Compiler implementation of the $(LINK2 http://www.dlang.org, D programming language)
 *
 * Copyright: Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors: Walter Bright, http://www.digitalmars.com
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:    $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/dmangle.d, _dmangle.d)
 * Documentation:  https://dlang.org/phobos/dmd_dmangle.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/dmangle.d
 * References:  https://dlang.org/blog/2017/12/20/ds-newfangled-имя-mangling/
 */

module dmd.dmangle;

import cidrus;

import dmd.aggregate;
import dmd.arraytypes;
import dmd.dclass;
import dmd.declaration;
import dmd.dmodule;
import dmd.дсимвол;
import dmd.dtemplate;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.mtype;
import util.ctfloat;
import util.outbuffer;
import util.aav;
import util.string;
import dmd.target;
import drc.lexer.Tokens;
import util.utf;
import drc.ast.Visitor;

private const сим[TMAX] mangleChar =
[
    Tchar        : 'a',
    Tbool        : 'b',
    Tcomplex80   : 'c',
    Tfloat64     : 'd',
    Tfloat80     : 'e',
    Tfloat32     : 'f',
    Tint8        : 'g',
    Tuns8        : 'h',
    Tint32       : 'i',
    Timaginary80 : 'j',
    Tuns32       : 'k',
    Tint64       : 'l',
    Tuns64       : 'm',
    Tnone        : 'n',
    Tnull        : 'n', // yes, same as TypeNone
    Timaginary32 : 'o',
    Timaginary64 : 'p',
    Tcomplex32   : 'q',
    Tcomplex64   : 'r',
    Tint16       : 's',
    Tuns16       : 't',
    Twchar       : 'u',
    Tvoid        : 'v',
    Tdchar       : 'w',
    //              x   // const
    //              y   // const
    Tint128      : 'z', // zi
    Tuns128      : 'z', // zk

    Tarray       : 'A',
    Ttuple       : 'B',
    Tclass       : 'C',
    Tdelegate    : 'D',
    Tenum        : 'E',
    Tfunction    : 'F', // D function
    Tsarray      : 'G',
    Taarray      : 'H',
    Tident       : 'I',
    //              J   // out
    //              K   // ref
    //              L   // lazy
    //              M   // has this, or scope
    //              N   // Nh:vector Ng:wild
    //              O   // shared
    Tpointer     : 'P',
    //              Q   // Тип/symbol/идентификатор backward reference
    Treference   : 'R',
    Tstruct      : 'S',
    //              T   // Ttypedef
    //              U   // C function
    //              V   // Pascal function
    //              W   // Windows function
    //              X   // variadic T t...)
    //              Y   // variadic T t,...)
    //              Z   // not variadic, end of parameters

    // '@' shouldn't appear anywhere in the deco'd имена
    Tinstance    : '@',
    Terror       : '@',
    Ttypeof      : '@',
    Tslice       : '@',
    Treturn      : '@',
    Tvector      : '@',
    Ttraits      : '@',
    Tmixin       : '@',
];

unittest
{
    foreach (i, mangle; mangleChar)
    {
        if (mangle == сим.init)
        {
            fprintf(stderr, "ty = %u\n", cast(бцел)i);
            assert(0);
        }
    }
}

/***********************
 * Mangle basic тип ty to буф.
 */

private проц tyToDecoBuffer(БуфВыв* буф, цел ty)
{
    const c = mangleChar[ty];
    буф.пишиБайт(c);
    if (c == 'z')
        буф.пишиБайт(ty == Tint128 ? 'i' : 'k');
}

/*********************************
 * Mangling for mod.
 */
private проц MODtoDecoBuffer(БуфВыв* буф, MOD mod)
{
    switch (mod)
    {
    case 0:
        break;
    case MODFlags.const_:
        буф.пишиБайт('x');
        break;
    case MODFlags.immutable_:
        буф.пишиБайт('y');
        break;
    case MODFlags.shared_:
        буф.пишиБайт('O');
        break;
    case MODFlags.shared_ | MODFlags.const_:
        буф.пишиСтр("Ox");
        break;
    case MODFlags.wild:
        буф.пишиСтр("Ng");
        break;
    case MODFlags.wildconst:
        буф.пишиСтр("Ngx");
        break;
    case MODFlags.shared_ | MODFlags.wild:
        буф.пишиСтр("ONg");
        break;
    case MODFlags.shared_ | MODFlags.wildconst:
        буф.пишиСтр("ONgx");
        break;
    default:
        assert(0);
    }
}

private  final class Mangler : Визитор2
{
    alias Визитор2.посети посети;
public:
    static assert(Ключ.sizeof == т_мера.sizeof);
    AssocArray!(Тип, т_мера) types;
    AssocArray!(Идентификатор2, т_мера) idents;
    БуфВыв* буф;

    this(БуфВыв* буф)
    {
        this.буф = буф;
    }

    /**
    * writes a back reference with the relative position encoded with base 26
    *  using upper case letters for all digits but the last digit which uses
    *  a lower case letter.
    * The decoder has to look up the referenced position to determine
    *  whether the back reference is an identifer (starts with a digit)
    *  or a тип (starts with a letter).
    *
    * Параметры:
    *  pos           = relative position to encode
    */
    проц writeBackRef(т_мера pos)
    {
        буф.пишиБайт('Q');
        const base = 26;
        т_мера mul = 1;
        while (pos >= mul * base)
            mul *= base;
        while (mul >= base)
        {
            auto dig = cast(ббайт)(pos / mul);
            буф.пишиБайт('A' + dig);
            pos -= dig * mul;
            mul /= base;
        }
        буф.пишиБайт('a' + cast(ббайт)pos);
    }

    /**
    * Back references a non-basic тип
    *
    * The encoded mangling is
    *       'Q' <relative position of first occurrence of тип>
    *
    * Параметры:
    *  t = the тип to encode via back referencing
    *
    * Возвращает:
    *  да if the тип was found. A back reference has been encoded.
    *  нет if the тип was not found. The current position is saved for later back references.
    */
    бул backrefType(Тип t)
    {
        if (!t.isTypeBasic())
        {
            auto p = types.getLvalue(t);
            if (*p)
            {
                writeBackRef(буф.length - *p);
                return да;
            }
            *p = буф.length;
        }
        return нет;
    }

    /**
    * Back references a single идентификатор
    *
    * The encoded mangling is
    *       'Q' <relative position of first occurrence of тип>
    *
    * Параметры:
    *  ид = the идентификатор to encode via back referencing
    *
    * Возвращает:
    *  да if the идентификатор was found. A back reference has been encoded.
    *  нет if the идентификатор was not found. The current position is saved for later back references.
    */
    бул backrefIdentifier(Идентификатор2 ид)
    {
        auto p = idents.getLvalue(ид);
        if (*p)
        {
            writeBackRef(буф.length - *p);
            return да;
        }
        *p = буф.length;
        return нет;
    }

    проц mangleSymbol(ДСимвол s)
    {
        s.прими(this);
    }

    проц mangleType(Тип t)
    {
        if (!backrefType(t))
            t.прими(this);
    }

    проц mangleIdentifier(Идентификатор2 ид, ДСимвол s)
    {
        if (!backrefIdentifier(ид))
            toBuffer(ид.вТкст(), s);
    }

    ////////////////////////////////////////////////////////////////////////////
    /**************************************************
     * Тип mangling
     */
    проц visitWithMask(Тип t, ббайт modMask)
    {
        if (modMask != t.mod)
        {
            MODtoDecoBuffer(буф, t.mod);
        }
        mangleType(t);
    }

    override проц посети(Тип t)
    {
        tyToDecoBuffer(буф, t.ty);
    }

    override проц посети(TypeNext t)
    {
        посети(cast(Тип)t);
        visitWithMask(t.следщ, t.mod);
    }

    override проц посети(TypeVector t)
    {
        буф.пишиСтр("Nh");
        visitWithMask(t.basetype, t.mod);
    }

    override проц посети(TypeSArray t)
    {
        посети(cast(Тип)t);
        if (t.dim)
            буф.print(t.dim.toInteger());
        if (t.следщ)
            visitWithMask(t.следщ, t.mod);
    }

    override проц посети(TypeDArray t)
    {
        посети(cast(Тип)t);
        if (t.следщ)
            visitWithMask(t.следщ, t.mod);
    }

    override проц посети(TypeAArray t)
    {
        посети(cast(Тип)t);
        visitWithMask(t.index, 0);
        visitWithMask(t.следщ, t.mod);
    }

    override проц посети(TypeFunction t)
    {
        //printf("TypeFunction.toDecoBuffer() t = %p %s\n", t, t.вТкст0());
        //static цел nest; if (++nest == 50) *(сим*)0=0;
        mangleFuncType(t, t, t.mod, t.следщ);
    }

    проц mangleFuncType(TypeFunction t, TypeFunction ta, ббайт modMask, Тип tret)
    {
        //printf("mangleFuncType() %s\n", t.вТкст0());
        if (t.inuse && tret)
        {
            // printf("TypeFunction.mangleFuncType() t = %s inuse\n", t.вТкст0());
            t.inuse = 2; // флаг error to caller
            return;
        }
        t.inuse++;
        if (modMask != t.mod)
            MODtoDecoBuffer(буф, t.mod);

        сим mc;
        switch (t.компонаж)
        {
        case LINK.default_:
        case LINK.system:
        case LINK.d:
            mc = 'F';
            break;
        case LINK.c:
            mc = 'U';
            break;
        case LINK.windows:
            mc = 'W';
            break;
        case LINK.pascal:
            mc = 'V';
            break;
        case LINK.cpp:
            mc = 'R';
            break;
        case LINK.objc:
            mc = 'Y';
            break;
        }
        буф.пишиБайт(mc);

        if (ta.purity)
            буф.пишиСтр("Na");
        if (ta.isnothrow)
            буф.пишиСтр("Nb");
        if (ta.isref)
            буф.пишиСтр("Nc");
        if (ta.isproperty)
            буф.пишиСтр("Nd");
        if (ta.isnogc)
            буф.пишиСтр("Ni");

        if (ta.isreturn && !ta.isreturninferred)
            буф.пишиСтр("Nj");
        else if (ta.isscope && !ta.isscopeinferred)
            буф.пишиСтр("Nl");

        switch (ta.trust)
        {
            case TRUST.trusted:
                буф.пишиСтр("Ne");
                break;
            case TRUST.safe:
                буф.пишиСтр("Nf");
                break;
            default:
                break;
        }

        // Write argument types
        paramsToDecoBuffer(t.parameterList.parameters);
        //if (буф.данные[буф.length - 1] == '@') assert(0);
        буф.пишиБайт('Z' - t.parameterList.varargs); // mark end of arg list
        if (tret !is null)
            visitWithMask(tret, 0);
        t.inuse--;
    }

    override проц посети(TypeIdentifier t)
    {
        посети(cast(Тип)t);
        auto имя = t.идент.вТкст();
        буф.print(cast(цел)имя.length);
        буф.пишиСтр(имя);
    }

    override проц посети(TypeEnum t)
    {
        посети(cast(Тип)t);
        mangleSymbol(t.sym);
    }

    override проц посети(TypeStruct t)
    {
        //printf("TypeStruct.toDecoBuffer('%s') = '%s'\n", t.вТкст0(), имя);
        посети(cast(Тип)t);
        mangleSymbol(t.sym);
    }

    override проц посети(TypeClass t)
    {
        //printf("TypeClass.toDecoBuffer('%s' mod=%x) = '%s'\n", t.вТкст0(), mod, имя);
        посети(cast(Тип)t);
        mangleSymbol(t.sym);
    }

    override проц посети(КортежТипов t)
    {
        //printf("КортежТипов.toDecoBuffer() t = %p, %s\n", t, t.вТкст0());
        посети(cast(Тип)t);
        paramsToDecoBuffer(t.arguments);
        буф.пишиБайт('Z');
    }

    override проц посети(TypeNull t)
    {
        посети(cast(Тип)t);
    }

    ////////////////////////////////////////////////////////////////////////////
    проц mangleDecl(Declaration sthis)
    {
        mangleParent(sthis);
        assert(sthis.идент);
        mangleIdentifier(sthis.идент, sthis);
        if (FuncDeclaration fd = sthis.isFuncDeclaration())
        {
            mangleFunc(fd, нет);
        }
        else if (sthis.тип)
        {
            visitWithMask(sthis.тип, 0);
        }
        else
            assert(0);
    }

    проц mangleParent(ДСимвол s)
    {
        ДСимвол p;
        if (TemplateInstance ti = s.isTemplateInstance())
            p = ti.isTemplateMixin() ? ti.родитель : ti.tempdecl.родитель;
        else
            p = s.родитель;
        if (p)
        {
            mangleParent(p);
            auto ti = p.isTemplateInstance();
            if (ti && !ti.isTemplateMixin())
            {
                mangleTemplateInstance(ti);
            }
            else if (p.getIdent())
            {
                mangleIdentifier(p.идент, s);
                if (FuncDeclaration f = p.isFuncDeclaration())
                    mangleFunc(f, да);
            }
            else
                буф.пишиБайт('0');
        }
    }

    проц mangleFunc(FuncDeclaration fd, бул inParent)
    {
        //printf("deco = '%s'\n", fd.тип.deco ? fd.тип.deco : "null");
        //printf("fd.тип = %s\n", fd.тип.вТкст0());
        if (fd.needThis() || fd.isNested())
            буф.пишиБайт('M');

        if (!fd.тип || fd.тип.ty == Terror)
        {
            // never should have gotten here, but could be the результат of
            // failed speculative compilation
            буф.пишиСтр("9__error__FZ");

            //printf("[%s] %s no тип\n", fd.место.вТкст0(), fd.вТкст0());
            //assert(0); // don't mangle function until semantic3 done.
        }
        else if (inParent)
        {
            TypeFunction tf = fd.тип.isTypeFunction();
            TypeFunction tfo = fd.originalType.isTypeFunction();
            mangleFuncType(tf, tfo, 0, null);
        }
        else
        {
            visitWithMask(fd.тип, 0);
        }
    }

    /************************************************************
     * Write length prefixed ткст to буф.
     */
    extern (D) проц toBuffer(ткст ид, ДСимвол s)
    {
        const len = ид.length;
        if (буф.length + len >= 8 * 1024 * 1024) // 8 megs ought be enough for anyone
            s.выведиОшибку("excessive length %llu for symbol, possible recursive expansion?", cast(бдол)(буф.length + len));
        else
        {
            буф.print(len);
            буф.пишиСтр(ид);
        }
    }

    /************************************************************
     * Try to obtain an externally mangled идентификатор from a declaration.
     * If the declaration is at глоб2 scope or mixed in at глоб2 scope,
     * the user might want to call it externally, so an externally mangled
     * имя is returned. Member functions or nested functions can't be called
     * externally in C, so in that case null is returned. C++ does support
     * namespaces, so extern(C++) always gives a C++ mangled имя.
     *
     * See also: https://issues.dlang.org/show_bug.cgi?ид=20012
     *
     * Параметры:
     *     d = declaration to mangle
     *
     * Возвращает:
     *     an externally mangled имя or null if the declaration cannot be called externally
     */
    extern (D) static ткст externallyMangledIdentifier(Declaration d)
    {
        const par = d.toParent(); //toParent() skips over mixin templates
        if (!par || par.isModule() || d.компонаж == LINK.cpp)
        {
            switch (d.компонаж)
            {
                case LINK.d:
                    break;
                case LINK.c:
                case LINK.windows:
                case LINK.pascal:
                case LINK.objc:
                    return d.идент.вТкст();
                case LINK.cpp:
                {
                    const p = target.cpp.toMangle(d);
                    return p.вТкстД();
                }
                case LINK.default_:
                case LINK.system:
                    d.выведиОшибку("forward declaration");
                    return d.идент.вТкст();
            }
        }
        return null;
    }

    override проц посети(Declaration d)
    {
        //printf("Declaration.mangle(this = %p, '%s', родитель = '%s', компонаж = %d)\n",
        //        d, d.вТкст0(), d.родитель ? d.родитель.вТкст0() : "null", d.компонаж);
        if(auto ид = externallyMangledIdentifier(d))
        {
            буф.пишиСтр(ид);
            return;
        }
        буф.пишиСтр("_D");
        mangleDecl(d);
        debug
        {
            const slice = (*буф)[];
            assert(slice.length);
            for (т_мера pos; pos < slice.length; )
            {
                dchar c;
                auto ppos = pos;
                const s = utf_decodeChar(slice, pos, c);
                assert(s is null, s);
                assert(c.isValidMangling, "The mangled имя '" ~ slice ~ "' " ~
                    "содержит an invalid character: " ~ slice[ppos..pos]);
            }
        }
    }

    /******************************************************************************
     * Normally FuncDeclaration and FuncAliasDeclaration have overloads.
     * If and only if there is no overloads, mangle() could return
     * exact mangled имя.
     *
     *      module test;
     *      проц foo(long) {}           // _D4test3fooFlZv
     *      проц foo(ткст) {}         // _D4test3fooFAyaZv
     *
     *      // from FuncDeclaration.mangle().
     *      pragma(msg, foo.mangleof);  // prints unexact mangled имя "4test3foo"
     *                                  // by calling ДСимвол.mangle()
     *
     *      // from FuncAliasDeclaration.mangle()
     *      pragma(msg, __traits(getOverloads, test, "foo")[0].mangleof);  // "_D4test3fooFlZv"
     *      pragma(msg, __traits(getOverloads, test, "foo")[1].mangleof);  // "_D4test3fooFAyaZv"
     *
     * If a function has no overloads, .mangleof property still returns exact mangled имя.
     *
     *      проц bar() {}
     *      pragma(msg, bar.mangleof);  // still prints "_D4test3barFZv"
     *                                  // by calling FuncDeclaration.mangleExact().
     */
    override проц посети(FuncDeclaration fd)
    {
        if (fd.isUnique())
            mangleExact(fd);
        else
            посети(cast(ДСимвол)fd);
    }

    // ditto
    override проц посети(FuncAliasDeclaration fd)
    {
        FuncDeclaration f = fd.toAliasFunc();
        FuncAliasDeclaration fa = f.isFuncAliasDeclaration();
        if (!fd.hasOverloads && !fa)
        {
            mangleExact(f);
            return;
        }
        if (fa)
        {
            mangleSymbol(fa);
            return;
        }
        посети(cast(ДСимвол)fd);
    }

    override проц посети(OverDeclaration od)
    {
        if (od.overnext)
        {
            посети(cast(ДСимвол)od);
            return;
        }
        if (FuncDeclaration fd = od.aliassym.isFuncDeclaration())
        {
            if (!od.hasOverloads || fd.isUnique())
            {
                mangleExact(fd);
                return;
            }
        }
        if (TemplateDeclaration td = od.aliassym.isTemplateDeclaration())
        {
            if (!od.hasOverloads || td.overnext is null)
            {
                mangleSymbol(td);
                return;
            }
        }
        посети(cast(ДСимвол)od);
    }

    проц mangleExact(FuncDeclaration fd)
    {
        assert(!fd.isFuncAliasDeclaration());
        if (fd.mangleOverride)
        {
            буф.пишиСтр(fd.mangleOverride);
            return;
        }
        if (fd.isMain())
        {
            буф.пишиСтр("_Dmain");
            return;
        }
        if (fd.isWinMain() || fd.isDllMain())
        {
            буф.пишиСтр(fd.идент.вТкст());
            return;
        }
        посети(cast(Declaration)fd);
    }

    override проц посети(VarDeclaration vd)
    {
        if (vd.mangleOverride)
        {
            буф.пишиСтр(vd.mangleOverride);
            return;
        }
        посети(cast(Declaration)vd);
    }

    override проц посети(AggregateDeclaration ad)
    {
        ClassDeclaration cd = ad.isClassDeclaration();
        ДСимвол parentsave = ad.родитель;
        if (cd)
        {
            /* These are reserved to the compiler, so keep simple
             * имена for them.
             */
            if (cd.идент == Id.Exception && cd.родитель.идент == Id.объект || cd.идент == Id.TypeInfo || cd.идент == Id.TypeInfo_Struct || cd.идент == Id.TypeInfo_Class || cd.идент == Id.TypeInfo_Tuple || cd == ClassDeclaration.объект || cd == Тип.typeinfoclass || cd == Module.moduleinfo || strncmp(cd.идент.вТкст0(), "TypeInfo_", 9) == 0)
            {
                // Don't mangle родитель
                ad.родитель = null;
            }
        }
        посети(cast(ДСимвол)ad);
        ad.родитель = parentsave;
    }

    override проц посети(TemplateInstance ti)
    {
        version (none)
        {
            printf("TemplateInstance.mangle() %p %s", ti, ti.вТкст0());
            if (ti.родитель)
                printf("  родитель = %s %s", ti.родитель.вид(), ti.родитель.вТкст0());
            printf("\n");
        }
        if (!ti.tempdecl)
            ti.выведиОшибку("is not defined");
        else
            mangleParent(ti);

        if (ti.isTemplateMixin() && ti.идент)
            mangleIdentifier(ti.идент, ti);
        else
            mangleTemplateInstance(ti);
    }

    проц mangleTemplateInstance(TemplateInstance ti)
    {
        TemplateDeclaration tempdecl = ti.tempdecl.isTemplateDeclaration();
        assert(tempdecl);

        // Use "__U" for the symbols declared inside template constraint.
        const сим T = ti.члены ? 'T' : 'U';
        буф.printf("__%c", T);
        mangleIdentifier(tempdecl.идент, tempdecl);

        auto args = ti.tiargs;
        т_мера nparams = tempdecl.parameters.dim - (tempdecl.isVariadic() ? 1 : 0);
        for (т_мера i = 0; i < args.dim; i++)
        {
            auto o = (*args)[i];
            Тип ta = тип_ли(o);
            Выражение ea = выражение_ли(o);
            ДСимвол sa = isDsymbol(o);
            Tuple va = кортеж_ли(o);
            //printf("\to [%d] %p ta %p ea %p sa %p va %p\n", i, o, ta, ea, sa, va);
            if (i < nparams && (*tempdecl.parameters)[i].specialization())
                буф.пишиБайт('H'); // https://issues.dlang.org/show_bug.cgi?ид=6574
            if (ta)
            {
                буф.пишиБайт('T');
                visitWithMask(ta, 0);
            }
            else if (ea)
            {
                // Don't interpret it yet, it might actually be an alias template параметр.
                // Only constfold manifest constants, not const/const lvalues, see https://issues.dlang.org/show_bug.cgi?ид=17339.
                const keepLvalue = да;
                ea = ea.optimize(WANTvalue, keepLvalue);
                if (auto ev = ea.isVarExp())
                {
                    sa = ev.var;
                    ea = null;
                    goto Lsa;
                }
                if (auto et = ea.isThisExp())
                {
                    sa = et.var;
                    ea = null;
                    goto Lsa;
                }
                if (auto ef = ea.isFuncExp())
                {
                    if (ef.td)
                        sa = ef.td;
                    else
                        sa = ef.fd;
                    ea = null;
                    goto Lsa;
                }
                буф.пишиБайт('V');
                if (ea.op == ТОК2.кортеж)
                {
                    ea.выведиОшибку("кортеж is not a valid template значение argument");
                    continue;
                }
                // Now that we know it is not an alias, we MUST obtain a значение
                бцел olderr = глоб2.errors;
                ea = ea.ctfeInterpret();
                if (ea.op == ТОК2.error || olderr != глоб2.errors)
                    continue;

                /* Use тип mangling that matches what it would be for a function параметр
                */
                visitWithMask(ea.тип, 0);
                ea.прими(this);
            }
            else if (sa)
            {
            Lsa:
                sa = sa.toAlias();
                if (Declaration d = sa.isDeclaration())
                {
                    if (auto fad = d.isFuncAliasDeclaration())
                        d = fad.toAliasFunc();
                    if (d.mangleOverride)
                    {
                        буф.пишиБайт('X');
                        toBuffer(d.mangleOverride, d);
                        continue;
                    }
                    if(auto ид = externallyMangledIdentifier(d))
                    {
                        буф.пишиБайт('X');
                        toBuffer(ид, d);
                        continue;
                    }
                    if (!d.тип || !d.тип.deco)
                    {
                        ti.выведиОшибку("forward reference of %s `%s`", d.вид(), d.вТкст0());
                        continue;
                    }
                }
                буф.пишиБайт('S');
                mangleSymbol(sa);
            }
            else if (va)
            {
                assert(i + 1 == args.dim); // must be last one
                args = &va.objects;
                i = -cast(т_мера)1;
            }
            else
                assert(0);
        }
        буф.пишиБайт('Z');
    }

    override проц посети(ДСимвол s)
    {
        version (none)
        {
            printf("ДСимвол.mangle() '%s'", s.вТкст0());
            if (s.родитель)
                printf("  родитель = %s %s", s.родитель.вид(), s.родитель.вТкст0());
            printf("\n");
        }
        mangleParent(s);
        if (s.идент)
            mangleIdentifier(s.идент, s);
        else
            toBuffer(s.вТкст(), s);
        //printf("ДСимвол.mangle() %s = %s\n", s.вТкст0(), ид);
    }

    ////////////////////////////////////////////////////////////////////////////
    override проц посети(Выражение e)
    {
        e.выведиОшибку("Выражение `%s` is not a valid template значение argument", e.вТкст0());
    }

    override проц посети(IntegerExp e)
    {
        const v = e.toInteger();
        if (cast(sinteger_t)v < 0)
        {
            буф.пишиБайт('N');
            буф.print(-v);
        }
        else
        {
            буф.пишиБайт('i');
            буф.print(v);
        }
    }

    override проц посети(RealExp e)
    {
        буф.пишиБайт('e');
        realToMangleBuffer(e.значение);
    }

    проц realToMangleBuffer(real_t значение)
    {
        /* Rely on %A to get portable mangling.
         * Must munge результат to get only идентификатор characters.
         *
         * Possible values from %A  => mangled результат
         * NAN                      => NAN
         * -INF                     => NINF
         * INF                      => INF
         * -0X1.1BC18BA997B95P+79   => N11BC18BA997B95P79
         * 0X1.9P+2                 => 19P2
         */
        if (CTFloat.isNaN(значение))
        {
            буф.пишиСтр("NAN"); // no -NAN bugs
            return;
        }

        if (значение < CTFloat.нуль)
        {
            буф.пишиБайт('N');
            значение = -значение;
        }

        if (CTFloat.isInfinity(значение))
        {
            буф.пишиСтр("INF");
            return;
        }

        сим[36] буфер = проц;
        // 'A' format yields [-]0xh.hhhhp+-d
        const n = CTFloat.sprint(буфер.ptr, 'A', значение);
        assert(n < буфер.length);
        foreach ( c; буфер[2 .. n])
        {
            switch (c)
            {
                case '-':
                    буф.пишиБайт('N');
                    break;

                case '+':
                case '.':
                    break;

                default:
                    буф.пишиБайт(c);
                    break;
            }
        }
    }

    override проц посети(ComplexExp e)
    {
        буф.пишиБайт('c');
        realToMangleBuffer(e.toReal());
        буф.пишиБайт('c'); // separate the two
        realToMangleBuffer(e.toImaginary());
    }

    override проц посети(NullExp e)
    {
        буф.пишиБайт('n');
    }

    override проц посети(StringExp e)
    {
        сим m;
        БуфВыв tmp;
        ткст q;
        /* Write ткст in UTF-8 format
         */
        switch (e.sz)
        {
        case 1:
            m = 'a';
            q = e.peekString();
            break;
        case 2:
        {
            m = 'w';
            const slice = e.peekWstring();
            for (т_мера u = 0; u < e.len;)
            {
                dchar c;
                if(auto s = utf_decodeWchar(slice, u, c))
                    e.выведиОшибку("%.*s", cast(цел)s.length, s.ptr);
                else
                    tmp.пишиЮ8(c);
            }
            q = tmp[];
            break;
        }
        case 4:
        {
            m = 'd';
            const slice = e.peekDstring();
            foreach (c; slice)
            {
                if (!utf_isValidDchar(c))
                    e.выведиОшибку("invalid UCS-32 сим \\U%08x", c);
                else
                    tmp.пишиЮ8(c);
            }
            q = tmp[];
            break;
        }

        default:
            assert(0);
        }
        буф.резервируй(1 + 11 + 2 * q.length);
        буф.пишиБайт(m);
        буф.print(q.length);
        буф.пишиБайт('_');    // члобайт <= 11
        const len = буф.length;
        auto slice = буф.размести(2 * q.length);
        foreach (i, c; q)
        {
            сим hi = (c >> 4) & 0xF;
            slice[i * 2] = cast(сим)(hi < 10 ? hi + '0' : hi - 10 + 'a');
            сим lo = c & 0xF;
            slice[i * 2 + 1] = cast(сим)(lo < 10 ? lo + '0' : lo - 10 + 'a');
        }
    }

    override проц посети(ArrayLiteralExp e)
    {
        const dim = e.elements ? e.elements.dim : 0;
        буф.пишиБайт('A');
        буф.print(dim);
        foreach (i; new бцел[0 .. dim])
        {
            e[i].прими(this);
        }
    }

    override проц посети(AssocArrayLiteralExp e)
    {
        const dim = e.keys.dim;
        буф.пишиБайт('A');
        буф.print(dim);
        foreach (i; new бцел[0 .. dim])
        {
            (*e.keys)[i].прими(this);
            (*e.values)[i].прими(this);
        }
    }

    override проц посети(StructLiteralExp e)
    {
        const dim = e.elements ? e.elements.dim : 0;
        буф.пишиБайт('S');
        буф.print(dim);
        foreach (i; new бцел[0 .. dim])
        {
            Выражение ex = (*e.elements)[i];
            if (ex)
                ex.прими(this);
            else
                буф.пишиБайт('v'); // 'v' for проц
        }
    }

    ////////////////////////////////////////////////////////////////////////////
    проц paramsToDecoBuffer(Параметры* parameters)
    {
        //printf("Параметр2.paramsToDecoBuffer()\n");

        цел paramsToDecoBufferDg(т_мера n, Параметр2 p)
        {
            p.прими(this);
            return 0;
        }

        Параметр2._foreach(parameters, &paramsToDecoBufferDg);
    }

    override проц посети(Параметр2 p)
    {
        if (p.классХранения & STC.scope_ && !(p.классХранения & STC.scopeinferred))
            буф.пишиБайт('M');

        // 'return inout ref' is the same as 'inout ref'
        if ((p.классХранения & (STC.return_ | STC.wild)) == STC.return_ &&
            !(p.классХранения & STC.returninferred))
            буф.пишиСтр("Nk");
        switch (p.классХранения & (STC.in_ | STC.out_ | STC.ref_ | STC.lazy_))
        {
        case 0:
        case STC.in_:
            break;
        case STC.out_:
            буф.пишиБайт('J');
            break;
        case STC.ref_:
            буф.пишиБайт('K');
            break;
        case STC.lazy_:
            буф.пишиБайт('L');
            break;
        default:
            debug
            {
                printf("классХранения = x%llx\n", p.классХранения & (STC.in_ | STC.out_ | STC.ref_ | STC.lazy_));
            }
            assert(0);
        }
        visitWithMask(p.тип, 0);
    }
}

/// Возвращает: `да` if the given character is a valid mangled character
package бул isValidMangling(dchar c)
{
    return
        c >= 'A' && c <= 'Z' ||
        c >= 'a' && c <= 'z' ||
        c >= '0' && c <= '9' ||
        c != 0 && strchr("$%().:?@[]_", c) ||
        isUniAlpha(c);
}

// valid mangled characters
unittest
{
    assert('a'.isValidMangling);
    assert('B'.isValidMangling);
    assert('2'.isValidMangling);
    assert('@'.isValidMangling);
    assert('_'.isValidMangling);
}

// invalid mangled characters
unittest
{
    assert(!'-'.isValidMangling);
    assert(!`\0`.isValidMangling);
    assert(!'/'.isValidMangling);
    assert(!'\\'.isValidMangling);
}

/******************************************************************************
 * Возвращает exact mangled имя of function.
 */
 ткст0 mangleExact(FuncDeclaration fd)
{
    if (!fd.mangleString)
    {
        БуфВыв буф;
        scope Mangler v = new Mangler(&буф);
        v.mangleExact(fd);
        fd.mangleString = буф.extractChars();
    }
    return fd.mangleString;
}

 проц mangleToBuffer(Тип t, БуфВыв* буф)
{
    if (t.deco)
        буф.пишиСтр(t.deco);
    else
    {
        scope Mangler v = new Mangler(буф);
        v.visitWithMask(t, 0);
    }
}

 проц mangleToBuffer(Выражение e, БуфВыв* буф)
{
    scope Mangler v = new Mangler(буф);
    e.прими(v);
}

 проц mangleToBuffer(ДСимвол s, БуфВыв* буф)
{
    scope Mangler v = new Mangler(буф);
    s.прими(v);
}

 проц mangleToBuffer(TemplateInstance ti, БуфВыв* буф)
{
    scope Mangler v = new Mangler(буф);
    v.mangleTemplateInstance(ti);
}

/******************************************************************************
 * Mangle function signatures ('this' qualifier, and параметр types)
 * to check conflicts in function overloads.
 * It's different from fd.тип.deco. For example, fd.тип.deco would be null
 * if fd is an auto function.
 *
 * Параметры:
 *    буф = `БуфВыв` to пиши the mangled function signature to
*     fd  = `FuncDeclaration` to mangle
 */
проц mangleToFuncSignature(ref БуфВыв буф, FuncDeclaration fd)
{
    auto tf = fd.тип.isTypeFunction();

    scope Mangler v = new Mangler(&буф);

    MODtoDecoBuffer(&буф, tf.mod);
    v.paramsToDecoBuffer(tf.parameterList.parameters);
    буф.пишиБайт('Z' - tf.parameterList.varargs);
}
