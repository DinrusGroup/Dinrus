/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Template implementation.
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/templateparamsem.d, _templateparamsem.d)
 * Documentation:  https://dlang.org/phobos/dmd_templateparamsem.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/templateparamsem.d
 */

module dmd.templateparamsem;

import dmd.arraytypes;
import dmd.дсимвол;
import dmd.dscope;
import dmd.dtemplate;
import dmd.globals;
import drc.ast.Expression;
import dmd.expressionsem;
import drc.ast.Node;
import dmd.mtype;
import dmd.typesem;
import drc.ast.Visitor;

/************************************************
 * Performs semantic on ПараметрШаблона2 AST nodes.
 *
 * Параметры:
 *      tp = element of `parameters` to be semantically analyzed
 *      sc = context
 *      parameters = массив of `ПараметрыШаблона` supplied to the `TemplateDeclaration`
 * Возвращает:
 *      `да` if no errors
 */
/*extern(C++)*/ бул tpsemantic(ПараметрШаблона2 tp, Scope* sc, ПараметрыШаблона* parameters)
{
    scope v = new TemplateParameterSemanticVisitor(sc, parameters);
    tp.прими(v);
    return v.результат;
}


private  final class TemplateParameterSemanticVisitor : Визитор2
{
    alias Визитор2.посети посети;

    Scope* sc;
    ПараметрыШаблона* parameters;
    бул результат;

    this(Scope* sc, ПараметрыШаблона* parameters)
    {
        this.sc = sc;
        this.parameters = parameters;
    }

    override проц посети(TemplateTypeParameter ttp)
    {
        //printf("TemplateTypeParameter.semantic('%s')\n", идент.вТкст0());
        if (ttp.specType && !reliesOnTident(ttp.specType, parameters))
        {
            ttp.specType = ttp.specType.typeSemantic(ttp.место, sc);
        }
        version (none)
        {
            // Don't do semantic() until instantiation
            if (ttp.defaultType)
            {
                ttp.defaultType = ttp.defaultType.typeSemantic(ttp.место, sc);
            }
        }
        результат = !(ttp.specType && isError(ttp.specType));
    }

    override проц посети(TemplateValueParameter tvp)
    {
        tvp.valType = tvp.valType.typeSemantic(tvp.место, sc);
        version (none)
        {
            // defer semantic analysis to arg match
            if (tvp.specValue)
            {
                Выражение e = tvp.specValue;
                sc = sc.startCTFE();
                e = e.semantic(sc);
                sc = sc.endCTFE();
                e = e.implicitCastTo(sc, tvp.valType);
                e = e.ctfeInterpret();
                if (e.op == ТОК2.int64 || e.op == ТОК2.float64 ||
                    e.op == ТОК2.complex80 || e.op == ТОК2.null_ || e.op == ТОК2.string_)
                    tvp.specValue = e;
            }

            if (tvp.defaultValue)
            {
                Выражение e = defaultValue;
                sc = sc.startCTFE();
                e = e.semantic(sc);
                sc = sc.endCTFE();
                e = e.implicitCastTo(sc, tvp.valType);
                e = e.ctfeInterpret();
                if (e.op == ТОК2.int64)
                    tvp.defaultValue = e;
            }
        }
        результат = !isError(tvp.valType);
    }

    override проц посети(TemplateAliasParameter tap)
    {
        if (tap.specType && !reliesOnTident(tap.specType, parameters))
        {
            tap.specType = tap.specType.typeSemantic(tap.место, sc);
        }
        tap.specAlias = aliasParameterSemantic(tap.место, sc, tap.specAlias, parameters);
        version (none)
        {
            // Don't do semantic() until instantiation
            if (tap.defaultAlias)
                tap.defaultAlias = tap.defaultAlias.semantic(tap.место, sc);
        }
        результат = !(tap.specType && isError(tap.specType)) && !(tap.specAlias && isError(tap.specAlias));
    }

    override проц посети(TemplateTupleParameter ttp)
    {
        результат = да;
    }
}

/***********************************************
 * Support function for performing semantic analysis on `TemplateAliasParameter`.
 *
 * Параметры:
 *      место = location (for error messages)
 *      sc = context
 *      o = объект to run semantic() on, the `TemplateAliasParameter`s `specAlias` or `defaultAlias`
 *      parameters = массив of `ПараметрыШаблона` supplied to the `TemplateDeclaration`
 * Возвращает:
 *      объект результатing from running `semantic` on `o`
 */
КорневойОбъект aliasParameterSemantic(Место место, Scope* sc, КорневойОбъект o, ПараметрыШаблона* parameters)
{
    if (o)
    {
        Выражение ea = выражение_ли(o);
        Тип ta = тип_ли(o);
        if (ta && (!parameters || !reliesOnTident(ta, parameters)))
        {
            ДСимвол s = ta.toDsymbol(sc);
            if (s)
                o = s;
            else
                o = ta.typeSemantic(место, sc);
        }
        else if (ea)
        {
            sc = sc.startCTFE();
            ea = ea.ВыражениеSemantic(sc);
            sc = sc.endCTFE();
            o = ea.ctfeInterpret();
        }
    }
    return o;
}
