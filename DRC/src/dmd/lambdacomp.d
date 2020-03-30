/***
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * This modules implements the serialization of a lambda function. The serialization
 * is computed by visiting the abstract syntax subtree of the given lambda function.
 * The serialization is a ткст which содержит the тип of the parameters and the
 * ткст represantation of the lambda Выражение.
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/lamdbacomp.d, _lambdacomp.d)
 * Documentation:  https://dlang.org/phobos/dmd_lambdacomp.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/lambdacomp.d
 */

module dmd.lambdacomp;

import cidrus;

import dmd.declaration;
import dmd.denum;
import dmd.дсимвол;
import dmd.dtemplate;
import drc.ast.Expression;
import dmd.func;
import dmd.dmangle;
import dmd.mtype;
import util.outbuffer;
import util.rmem;
import util.stringtable;
import dmd.dscope;
import dmd.инструкция;
import drc.lexer.Tokens;
import drc.ast.Visitor;

const LOG = нет;

/**
 * The тип of the visited Выражение.
 */
private enum ExpType
{
    None,
    EnumDecl,
    Arg
}

/**
 * Compares 2 lambda functions described by their serialization.
 *
 * Параметры:
 *  l1 = first lambda to be compared
 *  l2 = second lambda to be compared
 *  sc = the scope where the lambdas are compared
 *
 * Возвращает:
 *  `да` if the 2 lambda functions are equal, `нет` otherwise
 */
бул isSameFuncLiteral(FuncLiteralDeclaration l1, FuncLiteralDeclaration l2, Scope* sc)
{
    бул результат;
    if (auto ser1 = getSerialization(l1, sc))
    {
        //printf("l1 serialization: %.*s\n", cast(цел)ser1.length, &ser1[0]);
        if (auto ser2 = getSerialization(l2, sc))
        {
            //printf("l2 serialization: %.*s\n", cast(цел)ser2.length, &ser2[0]);
            if (ser1 == ser2)
                результат = да;
            mem.xfree(cast(ук)ser2.ptr);
        }
        mem.xfree(cast(ук)ser1.ptr);
    }
    return результат;
}

/**
 * Computes the ткст representation of a
 * lambda function described by the subtree starting from a
 * $(REF dmd, func, FuncLiteralDeclaration).
 *
 * Limitations: only IntegerExps, Enums and function
 * arguments are supported in the lambda function body. The
 * arguments may be of any тип (basic types, user defined types),
 * except template instantiations. If a function call, a local
 * variable or a template instance is encountered, the
 * serialization is dropped and the function is considered
 * uncomparable.
 *
 * Параметры:
 *  fld = the starting AST узел for the lambda function
 *  sc = the scope in which the lambda function is located
 *
 * Возвращает:
 *  The serialization of `fld` allocated with mem.
 */
private ткст getSerialization(FuncLiteralDeclaration fld, Scope* sc)
{
    scope serVisitor = new SerializeVisitor(fld.родитель._scope);
    fld.прими(serVisitor);
    const len = serVisitor.буф.length;
    if (len == 0)
        return null;

    return cast(ткст)serVisitor.буф.извлекиСрез();
}

private  class SerializeVisitor : SemanticTimeTransitiveVisitor
{
private:
    ТаблицаСтрок!(ткст) arg_hash;
    Scope* sc;
    ExpType et;
    ДСимвол d;

public:
    БуфВыв буф;
    alias SemanticTimeTransitiveVisitor.посети посети;

    this(Scope* sc)
    {
        this.sc = sc;
    }

    /**
     * Entrypoint of the SerializeVisitor.
     *
     * Параметры:
     *     fld = the lambda function for which the serialization is computed
     */
    override проц посети(FuncLiteralDeclaration fld)
    {
        assert(fld.тип.ty != Terror);
        static if (LOG)
            printf("FuncLiteralDeclaration: %s\n", fld.вТкст0());

        TypeFunction tf = cast(TypeFunction)fld.тип;
        бцел dim = cast(бцел)Параметр2.dim(tf.parameterList.parameters);
        // Start the serialization by printing the number of
        // arguments the lambda has.
        буф.printf("%d:", dim);

        arg_hash._иниц(dim + 1);
        // For each argument
        foreach (i; new бцел[0 .. dim])
        {
            auto fparam = tf.parameterList[i];
            if (fparam.идент !is null)
            {
                // the variable имя is introduced into a hashtable
                // where the ключ is the user defined имя and the
                // значение is the cannonically имя (arg0, arg1 ...)
                auto ключ = fparam.идент.вТкст();
                БуфВыв значение;
                значение.пишиСтр("arg");
                значение.print(i);
                arg_hash.вставь(ключ, значение.извлекиСрез());
                // and the тип of the variable is serialized.
                fparam.прими(this);
            }
        }

        // Now the function body can be serialized.
        ReturnStatement rs = fld.fbody.endsWithReturnStatement();
        if (rs && rs.exp)
        {
            rs.exp.прими(this);
        }
        else
        {
            буф.устРазм(0);
        }
    }

    override проц посети(DotIdExp exp)
    {
        static if (LOG)
            printf("DotIdExp: %s\n", exp.вТкст0());
        if (буф.length == 0)
            return;

        // First we need to see what вид of Выражение e1 is.
        // It might an enum member (enum.значение)  or the field of
        // an argument (argX.значение) if the argument is an aggregate
        // тип. This is reported through the et variable.
        exp.e1.прими(this);
        if (буф.length == 0)
            return;

        if (et == ExpType.EnumDecl)
        {
            ДСимвол s = d.search(exp.место, exp.идент);
            if (s)
            {
                if (auto em = s.isEnumMember())
                {
                    em.значение.прими(this);
                }
                et = ExpType.None;
                d = null;
            }
        }

        else if (et == ExpType.Arg)
        {
            буф.устРазм(буф.length -1);
            буф.пишиБайт('.');
            буф.пишиСтр(exp.идент.вТкст());
            буф.пишиБайт('_');
        }
    }

    бул checkArgument(ткст0 ид)
    {
        // The идентификатор may be an argument
        auto stringtable_value = arg_hash.lookup(ид, strlen(ид));
        if (stringtable_value)
        {
            // In which case we need to update the serialization accordingly
            ткст gen_id = stringtable_value.значение;
            буф.пиши(gen_id);
            буф.пишиБайт('_');
            et = ExpType.Arg;
            return да;
        }
        return нет;
    }

    override проц посети(IdentifierExp exp)
    {
        static if (LOG)
            printf("IdentifierExp: %s\n", exp.вТкст0());

        if (буф.length == 0)
            return;

        auto ид = exp.идент.вТкст0();

        // If it's not an argument
        if (!checkArgument(ид))
        {
            // we must check what the идентификатор Выражение is.
            ДСимвол scopesym;
            ДСимвол s = sc.search(exp.место, exp.идент, &scopesym);
            if (s)
            {
                auto v = s.isVarDeclaration();
                // If it's a VarDeclaration, it must be a manifest constant
                if (v && (v.класс_хранения & STC.manifest))
                {
                    v.getConstInitializer.прими(this);
                }
                else if (auto em = s.isEnumDeclaration())
                {
                    d = em;
                    et = ExpType.EnumDecl;
                }
                else if (auto fd = s.isFuncDeclaration())
                {
                    writeMangledName(fd);
                }
                // For anything else, the function is deemed uncomparable
                else
                {
                    буф.устРазм(0);
                }
            }
            // If it's an unknown symbol, consider the function incomparable
            else
            {
                буф.устРазм(0);
            }
        }
    }

    override проц посети(DotVarExp exp)
    {
        static if (LOG)
            printf("DotVarExp: %s, var: %s, e1: %s\n", exp.вТкст0(),
                    exp.var.вТкст0(), exp.e1.вТкст0());

        exp.e1.прими(this);
        if (буф.length == 0)
            return;

        буф.устРазм(буф.length -1);
        буф.пишиБайт('.');
        буф.пишиСтр(exp.var.вТкст0());
        буф.пишиБайт('_');
    }

    override проц посети(VarExp exp)
    {
        static if (LOG)
            printf("VarExp: %s, var: %s\n", exp.вТкст0(), exp.var.вТкст0());

        if (буф.length == 0)
            return;

        auto ид = exp.var.идент.вТкст0();
        if (!checkArgument(ид))
        {
            буф.устРазм(0);
        }
    }

    // serialize function calls
    override проц посети(CallExp exp)
    {
        static if (LOG)
            printf("CallExp: %s\n", exp.вТкст0());

        if (буф.length == 0)
            return;

        if (!exp.f)
        {
            exp.e1.прими(this);
        }
        else
        {
            writeMangledName(exp.f);
        }

        буф.пишиБайт('(');
        foreach (arg; *(exp.arguments))
        {
            arg.прими(this);
        }
        буф.пишиБайт(')');
    }

    override проц посети(UnaExp exp)
    {
        if (буф.length == 0)
            return;

        буф.пишиБайт('(');
        буф.пишиСтр(Сема2.вТкст(exp.op));
        exp.e1.прими(this);
        if (буф.length != 0)
            буф.пишиСтр(")_");
    }

    override проц посети(IntegerExp exp)
    {
        if (буф.length == 0)
            return;

        буф.print(exp.toInteger());
        буф.пишиБайт('_');
    }

    override проц посети(RealExp exp)
    {
        if (буф.length == 0)
            return;

        буф.пишиСтр(exp.вТкст0());
        буф.пишиБайт('_');
    }

    override проц посети(BinExp exp)
    {
        static if (LOG)
            printf("BinExp: %s\n", exp.вТкст0());

        if (буф.length == 0)
            return;

        буф.пишиБайт('(');
        буф.пишиСтр(Сема2.вТкст0(exp.op));

        exp.e1.прими(this);
        if (буф.length == 0)
            return;

        exp.e2.прими(this);
        if (буф.length == 0)
            return;

        буф.пишиБайт(')');
    }

    override проц посети(TypeBasic t)
    {
        буф.пишиСтр(t.dstring);
        буф.пишиБайт('_');
    }

    проц writeMangledName(ДСимвол s)
    {
        if (s)
        {
            БуфВыв mangledName;
            mangleToBuffer(s, &mangledName);
            буф.пишиСтр(mangledName[]);
            буф.пишиБайт('_');
        }
        else
            буф.устРазм(0);
    }

    private бул checkTemplateInstance(T)(T t)
//        if (is(T == TypeStruct) || is(T == TypeClass))
    {
        if (t.sym.родитель && t.sym.родитель.isTemplateInstance())
        {
            буф.устРазм(0);
            return да;
        }
        return нет;
    }

    override проц посети(TypeStruct t)
    {
        static if (LOG)
            printf("TypeStruct: %s\n", t.вТкст0);

        if (!checkTemplateInstance!(TypeStruct)(t))
            writeMangledName(t.sym);
    }

    override проц посети(TypeClass t)
    {
        static if (LOG)
            printf("TypeClass: %s\n", t.вТкст0());

        if (!checkTemplateInstance!(TypeClass)(t))
            writeMangledName(t.sym);
    }

    override проц посети(Параметр2 p)
    {
        if (p.тип.ty == Tident
            && (cast(TypeIdentifier)p.тип).идент.вТкст().length > 3
            && strncmp((cast(TypeIdentifier)p.тип).идент.вТкст0(), "__T", 3) == 0)
        {
            буф.пишиСтр("none_");
        }
        else
            visitType(p.тип);
    }

    override проц посети(StructLiteralExp e) {
        static if (LOG)
            printf("StructLiteralExp: %s\n", e.вТкст0);

        auto ty = cast(TypeStruct)e.stype;
        if (ty)
        {
            writeMangledName(ty.sym);
            auto dim = e.elements.dim;
            foreach (i; new бцел[0..dim])
            {
                auto elem = (*e.elements)[i];
                if (elem)
                    elem.прими(this);
                else
                    буф.пишиСтр("null_");
            }
        }
        else
            буф.устРазм(0);
    }

    override проц посети(ArrayLiteralExp) { буф.устРазм(0); }
    override проц посети(AssocArrayLiteralExp) { буф.устРазм(0); }
    override проц посети(CompileExp) { буф.устРазм(0); }
    override проц посети(ComplexExp) { буф.устРазм(0); }
    override проц посети(DeclarationExp) { буф.устРазм(0); }
    override проц посети(DefaultInitExp) { буф.устРазм(0); }
    override проц посети(DsymbolExp) { буф.устРазм(0); }
    override проц посети(ErrorExp) { буф.устРазм(0); }
    override проц посети(FuncExp) { буф.устРазм(0); }
    override проц посети(HaltExp) { буф.устРазм(0); }
    override проц посети(IntervalExp) { буф.устРазм(0); }
    override проц посети(IsExp) { буф.устРазм(0); }
    override проц посети(NewAnonClassExp) { буф.устРазм(0); }
    override проц посети(NewExp) { буф.устРазм(0); }
    override проц посети(NullExp) { буф.устРазм(0); }
    override проц посети(ObjcClassReferenceExp) { буф.устРазм(0); }
    override проц посети(OverExp) { буф.устРазм(0); }
    override проц посети(ScopeExp) { буф.устРазм(0); }
    override проц посети(StringExp) { буф.устРазм(0); }
    override проц посети(SymbolExp) { буф.устРазм(0); }
    override проц посети(TemplateExp) { буф.устРазм(0); }
    override проц посети(ThisExp) { буф.устРазм(0); }
    override проц посети(TraitsExp) { буф.устРазм(0); }
    override проц посети(TupleExp) { буф.устРазм(0); }
    override проц посети(TypeExp) { буф.устРазм(0); }
    override проц посети(TypeidExp) { буф.устРазм(0); }
    override проц посети(VoidInitExp) { буф.устРазм(0); }
}
