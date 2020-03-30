/**
 * Part of the Compiler implementation of the D programming language
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     Stefan Koch
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/asttypename.d, _asttypename.d)
 * Documentation:  https://dlang.org/phobos/dmd_asttypename.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/asttypename.d
 */

module dmd.asttypename;

import dmd.attrib;
import dmd.aliasthis;
import dmd.aggregate;
import dmd.complex;
import dmd.cond;
import dmd.ctfeexpr;
import dmd.dclass;
import dmd.declaration;
import dmd.denum;
import dmd.dimport;
import dmd.declaration;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dtemplate;
import dmd.dversion;
import drc.ast.Expression;
import dmd.func;
import dmd.denum;
import dmd.dimport;
import dmd.dmodule;
import dmd.mtype;
import dmd.typinf;
import drc.lexer.Identifier;
import dmd.init;
import drc.doc.Doc2;
import drc.ast.Node;
import dmd.инструкция;
import dmd.staticassert;
import dmd.nspace;
import drc.ast.Visitor;

/// Возвращает: the typename of the dynamic ast-узел-тип
/// (this is a development tool, do not use in actual code)
ткст astTypeName(КорневойОбъект узел)
{
    switch (узел.динкаст())
    {
        case ДИНКАСТ.объект:
            return "КорневойОбъект";
        case ДИНКАСТ.идентификатор:
            return "Идентификатор2";
        case ДИНКАСТ.шаблонпараметр:
            return "ПараметрШаблона2";

        case ДИНКАСТ.Выражение:
            return astTypeName(cast(Выражение) узел);
        case ДИНКАСТ.дсимвол:
            return astTypeName(cast(ДСимвол) узел);
        case ДИНКАСТ.тип:
            return astTypeName(cast(Тип) узел);
        case ДИНКАСТ.кортеж:
            return astTypeName(cast(Tuple) узел);
        case ДИНКАСТ.параметр:
            return astTypeName(cast(Параметр2) узел);
        case ДИНКАСТ.инструкция:
            return astTypeName(cast(Инструкция2) узел);
        case ДИНКАСТ.условие:
            return astTypeName(cast(Condition) узел);
    }
}

mixin
({
    ткст astTypeNameFunctions;
    ткст visitOverloads;

    foreach (ov; __traits(getOverloads, Визитор2, "посети"))
    {
        static if (is(typeof(ov) P == function))
        {
            static if (is(P[0] S == super) && is(S[0] == КорневойОбъект))
            {
                astTypeNameFunctions ~= `
ткст astTypeName(` ~ P[0].stringof ~ ` узел)
{
    scope tsv = new AstTypeNameVisitor;
    узел.прими(tsv);
    return tsv.typeName;
}
`;
            }

            visitOverloads ~= `
    override проц посети (` ~ P[0].stringof ~ ` _)
    {
        typeName = "` ~ P[0].stringof ~ `";
    }
`;
        }
    }

    return astTypeNameFunctions ~ `
private /*extern(C++)*/ final class AstTypeNameVisitor : Визитор2
{
    alias Визитор2.посети посети;
public :
    ткст typeName;
` ~ visitOverloads ~ "}";
}());

///
unittest
{
//    import dmd.globals : Место;
    Выражение e = new TypeidExp(Место.initial, null);
    assert(e.astTypeName == "TypeidExp");
}
