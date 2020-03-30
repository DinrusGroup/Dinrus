/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/hdrgen.d, _hdrgen.d)
 * Documentation:  https://dlang.org/phobos/dmd_hdrgen.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/hdrgen.d
 */

module dmd.hdrgen;

import cidrus;
import dmd.aggregate;
import dmd.aliasthis;
import dmd.arraytypes;
import dmd.attrib;
import dmd.complex;
import dmd.cond;
import dmd.ctfeexpr;
import dmd.dclass;
import dmd.declaration;
import dmd.denum;
import dmd.dimport;
import dmd.dmodule;
import drc.doc.Doc2;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dtemplate;
import dmd.dversion;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.init;
import dmd.mtype;
import dmd.nspace;
import drc.parser.Parser2;
import util.ctfloat;
import util.outbuffer;
import drc.ast.Node;
import util.string;
import dmd.инструкция;
import dmd.staticassert;
import dmd.target;
import drc.lexer.Tokens;
import util.utils;
import drc.ast.Visitor;

struct HdrGenState
{
    бул hdrgen;        /// да if generating header файл
    бул ddoc;          /// да if generating Ddoc файл
    бул fullDump;      /// да if generating a full AST dump файл

    бул fullQual;      /// fully qualify types when printing
    цел tpltMember;
    цел autoMember;
    цел forStmtInit;

    бул declstring; // set while declaring alias for ткст,wstring or dstring
    EnumDeclaration inEnumDecl;
}

const TEST_EMIT_ALL = 0;

 проц genhdrfile(Module m)
{
    БуфВыв буф;
    буф.doindent = 1;
    буф.printf("// D import файл generated from '%s'", m.srcfile.вТкст0());
    буф.нс();
    HdrGenState hgs;
    hgs.hdrgen = да;
    toCBuffer(m, &буф, &hgs);
    writeFile(m.место, m.hdrfile.вТкст(), буф[]);
}

/**
 * Dumps the full contents of module `m` to `буф`.
 * Параметры:
 *   буф = буфер to пиши to.
 *   m = module to посети all члены of.
 */
 проц moduleToBuffer(БуфВыв* буф, Module m)
{
    HdrGenState hgs;
    hgs.fullDump = да;
    toCBuffer(m, буф, &hgs);
}

проц moduleToBuffer2(Module m, БуфВыв* буф, HdrGenState* hgs)
{
    if (m.md)
    {
        if (m.userAttribDecl)
        {
            буф.пишиСтр("@(");
            argsToBuffer(m.userAttribDecl.atts, буф, hgs);
            буф.пишиБайт(')');
            буф.нс();
        }
        if (m.md.isdeprecated)
        {
            if (m.md.msg)
            {
                буф.пишиСтр("deprecated(");
                m.md.msg.ВыражениеToBuffer(буф, hgs);
                буф.пишиСтр(") ");
            }
            else
                буф.пишиСтр("deprecated ");
        }
        буф.пишиСтр("module ");
        буф.пишиСтр(m.md.вТкст0());
        буф.пишиБайт(';');
        буф.нс();
    }

    foreach (s; *m.члены)
    {
        s.dsymbolToBuffer(буф, hgs);
    }
}

private проц statementToBuffer(Инструкция2 s, БуфВыв* буф, HdrGenState* hgs)
{
    scope v = new StatementPrettyPrintVisitor(буф, hgs);
    s.прими(v);
}

private  final class StatementPrettyPrintVisitor : Визитор2
{
    alias Визитор2.посети посети;
public:
    БуфВыв* буф;
    HdrGenState* hgs;

    this(БуфВыв* буф, HdrGenState* hgs)
    {
        this.буф = буф;
        this.hgs = hgs;
    }

    override проц посети(Инструкция2 s)
    {
        буф.пишиСтр("Инструкция2::toCBuffer()");
        буф.нс();
        assert(0);
    }

    override проц посети(ErrorStatement s)
    {
        буф.пишиСтр("__error__");
        буф.нс();
    }

    override проц посети(ExpStatement s)
    {
        if (s.exp && s.exp.op == ТОК2.declaration &&
            (cast(DeclarationExp)s.exp).declaration)
        {
            // bypass посети(DeclarationExp)
            (cast(DeclarationExp)s.exp).declaration.dsymbolToBuffer(буф, hgs);
            return;
        }
        if (s.exp)
            s.exp.ВыражениеToBuffer(буф, hgs);
        буф.пишиБайт(';');
        if (!hgs.forStmtInit)
            буф.нс();
    }

    override проц посети(CompileStatement s)
    {
        буф.пишиСтр("mixin(");
        argsToBuffer(s.exps, буф, hgs, null);
        буф.пишиСтр(");");
        if (!hgs.forStmtInit)
            буф.нс();
    }

    override проц посети(CompoundStatement s)
    {
        foreach (sx; *s.statements)
        {
            if (sx)
                sx.прими(this);
        }
    }

    override проц посети(CompoundDeclarationStatement s)
    {
        бул anywritten = нет;
        foreach (sx; *s.statements)
        {
            auto ds = sx ? sx.isExpStatement() : null;
            if (ds && ds.exp.op == ТОК2.declaration)
            {
                auto d = (cast(DeclarationExp)ds.exp).declaration;
                assert(d.isDeclaration());
                if (auto v = d.isVarDeclaration())
                {
                    scope ppv = new DsymbolPrettyPrintVisitor(буф, hgs);
                    ppv.visitVarDecl(v, anywritten);
                }
                else
                    d.dsymbolToBuffer(буф, hgs);
                anywritten = да;
            }
        }
        буф.пишиБайт(';');
        if (!hgs.forStmtInit)
            буф.нс();
    }

    override проц посети(UnrolledLoopStatement s)
    {
        буф.пишиСтр("/*unrolled*/ {");
        буф.нс();
        буф.уровень++;
        foreach (sx; *s.statements)
        {
            if (sx)
                sx.прими(this);
        }
        буф.уровень--;
        буф.пишиБайт('}');
        буф.нс();
    }

    override проц посети(ScopeStatement s)
    {
        буф.пишиБайт('{');
        буф.нс();
        буф.уровень++;
        if (s.инструкция)
            s.инструкция.прими(this);
        буф.уровень--;
        буф.пишиБайт('}');
        буф.нс();
    }

    override проц посети(WhileStatement s)
    {
        буф.пишиСтр("while (");
        s.условие.ВыражениеToBuffer(буф, hgs);
        буф.пишиБайт(')');
        буф.нс();
        if (s._body)
            s._body.прими(this);
    }

    override проц посети(DoStatement s)
    {
        буф.пишиСтр("do");
        буф.нс();
        if (s._body)
            s._body.прими(this);
        буф.пишиСтр("while (");
        s.условие.ВыражениеToBuffer(буф, hgs);
        буф.пишиСтр(");");
        буф.нс();
    }

    override проц посети(ForStatement s)
    {
        буф.пишиСтр("for (");
        if (s._иниц)
        {
            hgs.forStmtInit++;
            s._иниц.прими(this);
            hgs.forStmtInit--;
        }
        else
            буф.пишиБайт(';');
        if (s.условие)
        {
            буф.пишиБайт(' ');
            s.условие.ВыражениеToBuffer(буф, hgs);
        }
        буф.пишиБайт(';');
        if (s.increment)
        {
            буф.пишиБайт(' ');
            s.increment.ВыражениеToBuffer(буф, hgs);
        }
        буф.пишиБайт(')');
        буф.нс();
        буф.пишиБайт('{');
        буф.нс();
        буф.уровень++;
        if (s._body)
            s._body.прими(this);
        буф.уровень--;
        буф.пишиБайт('}');
        буф.нс();
    }

    private проц foreachWithoutBody(ForeachStatement s)
    {
        буф.пишиСтр(Сема2.вТкст(s.op));
        буф.пишиСтр(" (");
        foreach (i, p; *s.parameters)
        {
            if (i)
                буф.пишиСтр(", ");
            if (stcToBuffer(буф, p.классХранения))
                буф.пишиБайт(' ');
            if (p.тип)
                typeToBuffer(p.тип, p.идент, буф, hgs);
            else
                буф.пишиСтр(p.идент.вТкст());
        }
        буф.пишиСтр("; ");
        s.aggr.ВыражениеToBuffer(буф, hgs);
        буф.пишиБайт(')');
        буф.нс();
    }

    override проц посети(ForeachStatement s)
    {
        foreachWithoutBody(s);
        буф.пишиБайт('{');
        буф.нс();
        буф.уровень++;
        if (s._body)
            s._body.прими(this);
        буф.уровень--;
        буф.пишиБайт('}');
        буф.нс();
    }

    private проц foreachRangeWithoutBody(ForeachRangeStatement s)
    {
        буф.пишиСтр(Сема2.вТкст(s.op));
        буф.пишиСтр(" (");
        if (s.prm.тип)
            typeToBuffer(s.prm.тип, s.prm.идент, буф, hgs);
        else
            буф.пишиСтр(s.prm.идент.вТкст());
        буф.пишиСтр("; ");
        s.lwr.ВыражениеToBuffer(буф, hgs);
        буф.пишиСтр(" .. ");
        s.upr.ВыражениеToBuffer(буф, hgs);
        буф.пишиБайт(')');
        буф.нс();
    }

    override проц посети(ForeachRangeStatement s)
    {
        foreachRangeWithoutBody(s);
        буф.пишиБайт('{');
        буф.нс();
        буф.уровень++;
        if (s._body)
            s._body.прими(this);
        буф.уровень--;
        буф.пишиБайт('}');
        буф.нс();
    }

    override проц посети(StaticForeachStatement s)
    {
        буф.пишиСтр("static ");
        if (s.sfe.aggrfe)
        {
            посети(s.sfe.aggrfe);
        }
        else
        {
            assert(s.sfe.rangefe);
            посети(s.sfe.rangefe);
        }
    }

    override проц посети(ForwardingStatement s)
    {
        s.инструкция.прими(this);
    }

    override проц посети(IfStatement s)
    {
        буф.пишиСтр("if (");
        if (Параметр2 p = s.prm)
        {
            КлассХранения stc = p.классХранения;
            if (!p.тип && !stc)
                stc = STC.auto_;
            if (stcToBuffer(буф, stc))
                буф.пишиБайт(' ');
            if (p.тип)
                typeToBuffer(p.тип, p.идент, буф, hgs);
            else
                буф.пишиСтр(p.идент.вТкст());
            буф.пишиСтр(" = ");
        }
        s.условие.ВыражениеToBuffer(буф, hgs);
        буф.пишиБайт(')');
        буф.нс();
        if (s.ifbody.isScopeStatement())
        {
            s.ifbody.прими(this);
        }
        else
        {
            буф.уровень++;
            s.ifbody.прими(this);
            буф.уровень--;
        }
        if (s.elsebody)
        {
            буф.пишиСтр("else");
            if (!s.elsebody.isIfStatement())
            {
                буф.нс();
            }
            else
            {
                буф.пишиБайт(' ');
            }
            if (s.elsebody.isScopeStatement() || s.elsebody.isIfStatement())
            {
                s.elsebody.прими(this);
            }
            else
            {
                буф.уровень++;
                s.elsebody.прими(this);
                буф.уровень--;
            }
        }
    }

    override проц посети(ConditionalStatement s)
    {
        s.условие.conditionToBuffer(буф, hgs);
        буф.нс();
        буф.пишиБайт('{');
        буф.нс();
        буф.уровень++;
        if (s.ifbody)
            s.ifbody.прими(this);
        буф.уровень--;
        буф.пишиБайт('}');
        буф.нс();
        if (s.elsebody)
        {
            буф.пишиСтр("else");
            буф.нс();
            буф.пишиБайт('{');
            буф.уровень++;
            буф.нс();
            s.elsebody.прими(this);
            буф.уровень--;
            буф.пишиБайт('}');
        }
        буф.нс();
    }

    override проц посети(PragmaStatement s)
    {
        буф.пишиСтр("pragma (");
        буф.пишиСтр(s.идент.вТкст());
        if (s.args && s.args.dim)
        {
            буф.пишиСтр(", ");
            argsToBuffer(s.args, буф, hgs);
        }
        буф.пишиБайт(')');
        if (s._body)
        {
            буф.нс();
            буф.пишиБайт('{');
            буф.нс();
            буф.уровень++;
            s._body.прими(this);
            буф.уровень--;
            буф.пишиБайт('}');
            буф.нс();
        }
        else
        {
            буф.пишиБайт(';');
            буф.нс();
        }
    }

    override проц посети(StaticAssertStatement s)
    {
        s.sa.dsymbolToBuffer(буф, hgs);
    }

    override проц посети(SwitchStatement s)
    {
        буф.пишиСтр(s.isFinal ? "switch (" : "switch (");
        s.условие.ВыражениеToBuffer(буф, hgs);
        буф.пишиБайт(')');
        буф.нс();
        if (s._body)
        {
            if (!s._body.isScopeStatement())
            {
                буф.пишиБайт('{');
                буф.нс();
                буф.уровень++;
                s._body.прими(this);
                буф.уровень--;
                буф.пишиБайт('}');
                буф.нс();
            }
            else
            {
                s._body.прими(this);
            }
        }
    }

    override проц посети(CaseStatement s)
    {
        буф.пишиСтр("case ");
        s.exp.ВыражениеToBuffer(буф, hgs);
        буф.пишиБайт(':');
        буф.нс();
        s.инструкция.прими(this);
    }

    override проц посети(CaseRangeStatement s)
    {
        буф.пишиСтр("case ");
        s.first.ВыражениеToBuffer(буф, hgs);
        буф.пишиСтр(": .. case ");
        s.last.ВыражениеToBuffer(буф, hgs);
        буф.пишиБайт(':');
        буф.нс();
        s.инструкция.прими(this);
    }

    override проц посети(DefaultStatement s)
    {
        буф.пишиСтр("default:");
        буф.нс();
        s.инструкция.прими(this);
    }

    override проц посети(GotoDefaultStatement s)
    {
        буф.пишиСтр("goto default;");
        буф.нс();
    }

    override проц посети(GotoCaseStatement s)
    {
        буф.пишиСтр("goto case");
        if (s.exp)
        {
            буф.пишиБайт(' ');
            s.exp.ВыражениеToBuffer(буф, hgs);
        }
        буф.пишиБайт(';');
        буф.нс();
    }

    override проц посети(SwitchErrorStatement s)
    {
        буф.пишиСтр("SwitchErrorStatement::toCBuffer()");
        буф.нс();
    }

    override проц посети(ReturnStatement s)
    {
        буф.пишиСтр("return ");
        if (s.exp)
            s.exp.ВыражениеToBuffer(буф, hgs);
        буф.пишиБайт(';');
        буф.нс();
    }

    override проц посети(BreakStatement s)
    {
        буф.пишиСтр("break");
        if (s.идент)
        {
            буф.пишиБайт(' ');
            буф.пишиСтр(s.идент.вТкст());
        }
        буф.пишиБайт(';');
        буф.нс();
    }

    override проц посети(ContinueStatement s)
    {
        буф.пишиСтр("continue");
        if (s.идент)
        {
            буф.пишиБайт(' ');
            буф.пишиСтр(s.идент.вТкст());
        }
        буф.пишиБайт(';');
        буф.нс();
    }

    override проц посети(SynchronizedStatement s)
    {
        буф.пишиСтр("synchronized");
        if (s.exp)
        {
            буф.пишиБайт('(');
            s.exp.ВыражениеToBuffer(буф, hgs);
            буф.пишиБайт(')');
        }
        if (s._body)
        {
            буф.пишиБайт(' ');
            s._body.прими(this);
        }
    }

    override проц посети(WithStatement s)
    {
        буф.пишиСтр("with (");
        s.exp.ВыражениеToBuffer(буф, hgs);
        буф.пишиСтр(")");
        буф.нс();
        if (s._body)
            s._body.прими(this);
    }

    override проц посети(TryCatchStatement s)
    {
        буф.пишиСтр("try");
        буф.нс();
        if (s._body)
        {
            if (s._body.isScopeStatement())
            {
                s._body.прими(this);
            }
            else
            {
                буф.уровень++;
                s._body.прими(this);
                буф.уровень--;
            }
        }
        foreach (c; *s.catches)
        {
            посети(c);
        }
    }

    override проц посети(TryFinallyStatement s)
    {
        буф.пишиСтр("try");
        буф.нс();
        буф.пишиБайт('{');
        буф.нс();
        буф.уровень++;
        s._body.прими(this);
        буф.уровень--;
        буф.пишиБайт('}');
        буф.нс();
        буф.пишиСтр("finally");
        буф.нс();
        if (s.finalbody.isScopeStatement())
        {
            s.finalbody.прими(this);
        }
        else
        {
            буф.уровень++;
            s.finalbody.прими(this);
            буф.уровень--;
        }
    }

    override проц посети(ScopeGuardStatement s)
    {
        буф.пишиСтр(Сема2.вТкст(s.tok));
        буф.пишиБайт(' ');
        if (s.инструкция)
            s.инструкция.прими(this);
    }

    override проц посети(ThrowStatement s)
    {
        буф.пишиСтр("throw ");
        s.exp.ВыражениеToBuffer(буф, hgs);
        буф.пишиБайт(';');
        буф.нс();
    }

    override проц посети(DebugStatement s)
    {
        if (s.инструкция)
        {
            s.инструкция.прими(this);
        }
    }

    override проц посети(GotoStatement s)
    {
        буф.пишиСтр("goto ");
        буф.пишиСтр(s.идент.вТкст());
        буф.пишиБайт(';');
        буф.нс();
    }

    override проц посети(LabelStatement s)
    {
        буф.пишиСтр(s.идент.вТкст());
        буф.пишиБайт(':');
        буф.нс();
        if (s.инструкция)
            s.инструкция.прими(this);
    }

    override проц посети(AsmStatement s)
    {
        буф.пишиСтр("asm { ");
        Сема2* t = s.tokens;
        буф.уровень++;
        while (t)
        {
            буф.пишиСтр(t.вТкст0());
            if (t.следщ &&
                t.значение != ТОК2.min      &&
                t.значение != ТОК2.comma    && t.следщ.значение != ТОК2.comma    &&
                t.значение != ТОК2.leftBracket && t.следщ.значение != ТОК2.leftBracket &&
                                          t.следщ.значение != ТОК2.rightBracket &&
                t.значение != ТОК2.leftParentheses   && t.следщ.значение != ТОК2.leftParentheses   &&
                                          t.следщ.значение != ТОК2.rightParentheses   &&
                t.значение != ТОК2.dot      && t.следщ.значение != ТОК2.dot)
            {
                буф.пишиБайт(' ');
            }
            t = t.следщ;
        }
        буф.уровень--;
        буф.пишиСтр("; }");
        буф.нс();
    }

    override проц посети(ImportStatement s)
    {
        foreach (imp; *s.imports)
        {
            imp.dsymbolToBuffer(буф, hgs);
        }
    }

    проц посети(Уловитель c)
    {
        буф.пишиСтр("catch");
        if (c.тип)
        {
            буф.пишиБайт('(');
            typeToBuffer(c.тип, c.идент, буф, hgs);
            буф.пишиБайт(')');
        }
        буф.нс();
        буф.пишиБайт('{');
        буф.нс();
        буф.уровень++;
        if (c.handler)
            c.handler.прими(this);
        буф.уровень--;
        буф.пишиБайт('}');
        буф.нс();
    }
}

private проц dsymbolToBuffer(ДСимвол s, БуфВыв* буф, HdrGenState* hgs)
{
    scope v = new DsymbolPrettyPrintVisitor(буф, hgs);
    s.прими(v);
}

private  final class DsymbolPrettyPrintVisitor : Визитор2
{
    alias Визитор2.посети посети;
public:
    БуфВыв* буф;
    HdrGenState* hgs;

    this(БуфВыв* буф, HdrGenState* hgs)
    {
        this.буф = буф;
        this.hgs = hgs;
    }

    ////////////////////////////////////////////////////////////////////////////

    override проц посети(ДСимвол s)
    {
        буф.пишиСтр(s.вТкст0());
    }

    override проц посети(StaticAssert s)
    {
        буф.пишиСтр(s.вид());
        буф.пишиБайт('(');
        s.exp.ВыражениеToBuffer(буф, hgs);
        if (s.msg)
        {
            буф.пишиСтр(", ");
            s.msg.ВыражениеToBuffer(буф, hgs);
        }
        буф.пишиСтр(");");
        буф.нс();
    }

    override проц посети(DebugSymbol s)
    {
        буф.пишиСтр("debug = ");
        if (s.идент)
            буф.пишиСтр(s.идент.вТкст());
        else
            буф.print(s.уровень);
        буф.пишиБайт(';');
        буф.нс();
    }

    override проц посети(VersionSymbol s)
    {
        буф.пишиСтр("version = ");
        if (s.идент)
            буф.пишиСтр(s.идент.вТкст());
        else
            буф.print(s.уровень);
        буф.пишиБайт(';');
        буф.нс();
    }

    override проц посети(EnumMember em)
    {
        if (em.тип)
            typeToBuffer(em.тип, em.идент, буф, hgs);
        else
            буф.пишиСтр(em.идент.вТкст());
        if (em.значение)
        {
            буф.пишиСтр(" = ");
            em.значение.ВыражениеToBuffer(буф, hgs);
        }
    }

    override проц посети(Импорт imp)
    {
        if (hgs.hdrgen && imp.ид == Id.объект)
            return; // объект is imported by default
        if (imp.статичен_ли)
            буф.пишиСтр("static ");
        буф.пишиСтр("import ");
        if (imp.идНик)
        {
            буф.printf("%s = ", imp.идНик.вТкст0());
        }
        if (imp.пакеты && imp.пакеты.dim)
        {
            foreach ( pid; *imp.пакеты)
            {
                буф.printf("%s.", pid.вТкст0());
            }
        }
        буф.пишиСтр(imp.ид.вТкст());
        if (imp.имена.dim)
        {
            буф.пишиСтр(" : ");
            foreach ( i,  имя; imp.имена)
            {
                if (i)
                    буф.пишиСтр(", ");
                const _alias = imp.ники[i];
                if (_alias)
                    буф.printf("%s = %s", _alias.вТкст0(), имя.вТкст0());
                else
                    буф.пишиСтр(имя.вТкст0());
            }
        }
        буф.пишиБайт(';');
        буф.нс();
    }

    override проц посети(AliasThis d)
    {
        буф.пишиСтр("alias ");
        буф.пишиСтр(d.идент.вТкст());
        буф.пишиСтр(" this;\n");
    }

    override проц посети(AttribDeclaration d)
    {
        if (!d.decl)
        {
            буф.пишиБайт(';');
            буф.нс();
            return;
        }
        if (d.decl.dim == 0)
            буф.пишиСтр("{}");
        else if (hgs.hdrgen && d.decl.dim == 1 && (*d.decl)[0].isUnitTestDeclaration())
        {
            // hack for bugzilla 8081
            буф.пишиСтр("{}");
        }
        else if (d.decl.dim == 1)
        {
            (*d.decl)[0].прими(this);
            return;
        }
        else
        {
            буф.нс();
            буф.пишиБайт('{');
            буф.нс();
            буф.уровень++;
            foreach (de; *d.decl)
                de.прими(this);
            буф.уровень--;
            буф.пишиБайт('}');
        }
        буф.нс();
    }

    override проц посети(StorageClassDeclaration d)
    {
        if (stcToBuffer(буф, d.stc))
            буф.пишиБайт(' ');
        посети(cast(AttribDeclaration)d);
    }

    override проц посети(DeprecatedDeclaration d)
    {
        буф.пишиСтр("deprecated(");
        d.msg.ВыражениеToBuffer(буф, hgs);
        буф.пишиСтр(") ");
        посети(cast(AttribDeclaration)d);
    }

    override проц посети(LinkDeclaration d)
    {
        буф.пишиСтр("extern (");
        буф.пишиСтр(linkageToString(d.компонаж));
        буф.пишиСтр(") ");
        посети(cast(AttribDeclaration)d);
    }

    override проц посети(CPPMangleDeclaration d)
    {
        ткст s;
        switch (d.cppmangle)
        {
        case CPPMANGLE.asClass:
            s = "class";
            break;
        case CPPMANGLE.asStruct:
            s = "struct";
            break;
        case CPPMANGLE.def:
            break;
        }
        буф.пишиСтр("extern (C++, ");
        буф.пишиСтр(s);
        буф.пишиСтр(") ");
        посети(cast(AttribDeclaration)d);
    }

    override проц посети(ProtDeclaration d)
    {
        protectionToBuffer(буф, d.защита);
        буф.пишиБайт(' ');
        AttribDeclaration ad = cast(AttribDeclaration)d;
        if (ad.decl.dim == 1 && (*ad.decl)[0].isProtDeclaration)
            посети(cast(AttribDeclaration)(*ad.decl)[0]);
        else
            посети(cast(AttribDeclaration)d);
    }

    override проц посети(AlignDeclaration d)
    {
        буф.пишиСтр("align ");
        if (d.ealign)
            буф.printf("(%s) ", d.ealign.вТкст0());
        посети(cast(AttribDeclaration)d);
    }

    override проц посети(AnonDeclaration d)
    {
        буф.пишиСтр(d.isunion ? "union" : "struct");
        буф.нс();
        буф.пишиСтр("{");
        буф.нс();
        буф.уровень++;
        if (d.decl)
        {
            foreach (de; *d.decl)
                de.прими(this);
        }
        буф.уровень--;
        буф.пишиСтр("}");
        буф.нс();
    }

    override проц посети(PragmaDeclaration d)
    {
        буф.пишиСтр("pragma (");
        буф.пишиСтр(d.идент.вТкст());
        if (d.args && d.args.dim)
        {
            буф.пишиСтр(", ");
            argsToBuffer(d.args, буф, hgs);
        }
        буф.пишиБайт(')');
        посети(cast(AttribDeclaration)d);
    }

    override проц посети(ConditionalDeclaration d)
    {
        d.условие.conditionToBuffer(буф, hgs);
        if (d.decl || d.elsedecl)
        {
            буф.нс();
            буф.пишиБайт('{');
            буф.нс();
            буф.уровень++;
            if (d.decl)
            {
                foreach (de; *d.decl)
                    de.прими(this);
            }
            буф.уровень--;
            буф.пишиБайт('}');
            if (d.elsedecl)
            {
                буф.нс();
                буф.пишиСтр("else");
                буф.нс();
                буф.пишиБайт('{');
                буф.нс();
                буф.уровень++;
                foreach (de; *d.elsedecl)
                    de.прими(this);
                буф.уровень--;
                буф.пишиБайт('}');
            }
        }
        else
            буф.пишиБайт(':');
        буф.нс();
    }

    override проц посети(StaticForeachDeclaration s)
    {
        проц foreachWithoutBody(ForeachStatement s)
        {
            буф.пишиСтр(Сема2.вТкст(s.op));
            буф.пишиСтр(" (");
            foreach (i, p; *s.parameters)
            {
                if (i)
                    буф.пишиСтр(", ");
                if (stcToBuffer(буф, p.классХранения))
                    буф.пишиБайт(' ');
                if (p.тип)
                    typeToBuffer(p.тип, p.идент, буф, hgs);
                else
                    буф.пишиСтр(p.идент.вТкст());
            }
            буф.пишиСтр("; ");
            s.aggr.ВыражениеToBuffer(буф, hgs);
            буф.пишиБайт(')');
            буф.нс();
        }

        проц foreachRangeWithoutBody(ForeachRangeStatement s)
        {
            /* s.op ( prm ; lwr .. upr )
             */
            буф.пишиСтр(Сема2.вТкст(s.op));
            буф.пишиСтр(" (");
            if (s.prm.тип)
                typeToBuffer(s.prm.тип, s.prm.идент, буф, hgs);
            else
                буф.пишиСтр(s.prm.идент.вТкст());
            буф.пишиСтр("; ");
            s.lwr.ВыражениеToBuffer(буф, hgs);
            буф.пишиСтр(" .. ");
            s.upr.ВыражениеToBuffer(буф, hgs);
            буф.пишиБайт(')');
            буф.нс();
        }

        буф.пишиСтр("static ");
        if (s.sfe.aggrfe)
        {
            foreachWithoutBody(s.sfe.aggrfe);
        }
        else
        {
            assert(s.sfe.rangefe);
            foreachRangeWithoutBody(s.sfe.rangefe);
        }
        буф.пишиБайт('{');
        буф.нс();
        буф.уровень++;
        посети(cast(AttribDeclaration)s);
        буф.уровень--;
        буф.пишиБайт('}');
        буф.нс();

    }

    override проц посети(CompileDeclaration d)
    {
        буф.пишиСтр("mixin(");
        argsToBuffer(d.exps, буф, hgs, null);
        буф.пишиСтр(");");
        буф.нс();
    }

    override проц посети(UserAttributeDeclaration d)
    {
        буф.пишиСтр("@(");
        argsToBuffer(d.atts, буф, hgs);
        буф.пишиБайт(')');
        посети(cast(AttribDeclaration)d);
    }

    override проц посети(TemplateDeclaration d)
    {
        version (none)
        {
            // Should handle template functions for doc generation
            if (onemember && onemember.isFuncDeclaration())
                буф.пишиСтр("foo ");
        }
        if ((hgs.hdrgen || hgs.fullDump) && visitEponymousMember(d))
            return;
        if (hgs.ddoc)
            буф.пишиСтр(d.вид());
        else
            буф.пишиСтр("template");
        буф.пишиБайт(' ');
        буф.пишиСтр(d.идент.вТкст());
        буф.пишиБайт('(');
        visitTemplateParameters(hgs.ddoc ? d.origParameters : d.parameters);
        буф.пишиБайт(')');
        visitTemplateConstraint(d.constraint);
        if (hgs.hdrgen || hgs.fullDump)
        {
            hgs.tpltMember++;
            буф.нс();
            буф.пишиБайт('{');
            буф.нс();
            буф.уровень++;
            foreach (s; *d.члены)
                s.прими(this);
            буф.уровень--;
            буф.пишиБайт('}');
            буф.нс();
            hgs.tpltMember--;
        }
    }

    бул visitEponymousMember(TemplateDeclaration d)
    {
        if (!d.члены || d.члены.dim != 1)
            return нет;
        ДСимвол onemember = (*d.члены)[0];
        if (onemember.идент != d.идент)
            return нет;
        if (FuncDeclaration fd = onemember.isFuncDeclaration())
        {
            assert(fd.тип);
            if (stcToBuffer(буф, fd.класс_хранения))
                буф.пишиБайт(' ');
            functionToBufferFull(cast(TypeFunction)fd.тип, буф, d.идент, hgs, d);
            visitTemplateConstraint(d.constraint);
            hgs.tpltMember++;
            bodyToBuffer(fd);
            hgs.tpltMember--;
            return да;
        }
        if (AggregateDeclaration ad = onemember.isAggregateDeclaration())
        {
            буф.пишиСтр(ad.вид());
            буф.пишиБайт(' ');
            буф.пишиСтр(ad.идент.вТкст());
            буф.пишиБайт('(');
            visitTemplateParameters(hgs.ddoc ? d.origParameters : d.parameters);
            буф.пишиБайт(')');
            visitTemplateConstraint(d.constraint);
            visitBaseClasses(ad.isClassDeclaration());
            hgs.tpltMember++;
            if (ad.члены)
            {
                буф.нс();
                буф.пишиБайт('{');
                буф.нс();
                буф.уровень++;
                foreach (s; *ad.члены)
                    s.прими(this);
                буф.уровень--;
                буф.пишиБайт('}');
            }
            else
                буф.пишиБайт(';');
            буф.нс();
            hgs.tpltMember--;
            return да;
        }
        if (VarDeclaration vd = onemember.isVarDeclaration())
        {
            if (d.constraint)
                return нет;
            if (stcToBuffer(буф, vd.класс_хранения))
                буф.пишиБайт(' ');
            if (vd.тип)
                typeToBuffer(vd.тип, vd.идент, буф, hgs);
            else
                буф.пишиСтр(vd.идент.вТкст());
            буф.пишиБайт('(');
            visitTemplateParameters(hgs.ddoc ? d.origParameters : d.parameters);
            буф.пишиБайт(')');
            if (vd._иниц)
            {
                буф.пишиСтр(" = ");
                ExpInitializer ie = vd._иниц.isExpInitializer();
                if (ie && (ie.exp.op == ТОК2.construct || ie.exp.op == ТОК2.blit))
                    (cast(AssignExp)ie.exp).e2.ВыражениеToBuffer(буф, hgs);
                else
                    vd._иниц.initializerToBuffer(буф, hgs);
            }
            буф.пишиБайт(';');
            буф.нс();
            return да;
        }
        return нет;
    }

    проц visitTemplateParameters(ПараметрыШаблона* parameters)
    {
        if (!parameters || !parameters.dim)
            return;
        foreach (i, p; *parameters)
        {
            if (i)
                буф.пишиСтр(", ");
            p.templateParameterToBuffer(буф, hgs);
        }
    }

    проц visitTemplateConstraint(Выражение constraint)
    {
        if (!constraint)
            return;
        буф.пишиСтр(" if (");
        constraint.ВыражениеToBuffer(буф, hgs);
        буф.пишиБайт(')');
    }

    override проц посети(TemplateInstance ti)
    {
        буф.пишиСтр(ti.имя.вТкст0());
        tiargsToBuffer(ti, буф, hgs);

        if (hgs.fullDump)
        {
            буф.нс();
            dumpTemplateInstance(ti, буф, hgs);
        }
    }

    override проц посети(TemplateMixin tm)
    {
        буф.пишиСтр("mixin ");
        typeToBuffer(tm.tqual, null, буф, hgs);
        tiargsToBuffer(tm, буф, hgs);
        if (tm.идент && memcmp(tm.идент.вТкст0(), cast(сим*)"__mixin", 7) != 0)
        {
            буф.пишиБайт(' ');
            буф.пишиСтр(tm.идент.вТкст());
        }
        буф.пишиБайт(';');
        буф.нс();
        if (hgs.fullDump)
            dumpTemplateInstance(tm, буф, hgs);
    }

    override проц посети(EnumDeclaration d)
    {
        auto oldInEnumDecl = hgs.inEnumDecl;
        scope(exit) hgs.inEnumDecl = oldInEnumDecl;
        hgs.inEnumDecl = d;
        буф.пишиСтр("enum ");
        if (d.идент)
        {
            буф.пишиСтр(d.идент.вТкст());
            буф.пишиБайт(' ');
        }
        if (d.memtype)
        {
            буф.пишиСтр(": ");
            typeToBuffer(d.memtype, null, буф, hgs);
        }
        if (!d.члены)
        {
            буф.пишиБайт(';');
            буф.нс();
            return;
        }
        буф.нс();
        буф.пишиБайт('{');
        буф.нс();
        буф.уровень++;
        foreach (em; *d.члены)
        {
            if (!em)
                continue;
            em.прими(this);
            буф.пишиБайт(',');
            буф.нс();
        }
        буф.уровень--;
        буф.пишиБайт('}');
        буф.нс();
    }

    override проц посети(Nspace d)
    {
        буф.пишиСтр("extern (C++, ");
        буф.пишиСтр(d.идент.вТкст());
        буф.пишиБайт(')');
        буф.нс();
        буф.пишиБайт('{');
        буф.нс();
        буф.уровень++;
        foreach (s; *d.члены)
            s.прими(this);
        буф.уровень--;
        буф.пишиБайт('}');
        буф.нс();
    }

    override проц посети(StructDeclaration d)
    {
        буф.пишиСтр(d.вид());
        буф.пишиБайт(' ');
        if (!d.isAnonymous())
            буф.пишиСтр(d.вТкст0());
        if (!d.члены)
        {
            буф.пишиБайт(';');
            буф.нс();
            return;
        }
        буф.нс();
        буф.пишиБайт('{');
        буф.нс();
        буф.уровень++;
        foreach (s; *d.члены)
            s.прими(this);
        буф.уровень--;
        буф.пишиБайт('}');
        буф.нс();
    }

    override проц посети(ClassDeclaration d)
    {
        if (!d.isAnonymous())
        {
            буф.пишиСтр(d.вид());
            буф.пишиБайт(' ');
            буф.пишиСтр(d.идент.вТкст());
        }
        visitBaseClasses(d);
        if (d.члены)
        {
            буф.нс();
            буф.пишиБайт('{');
            буф.нс();
            буф.уровень++;
            foreach (s; *d.члены)
                s.прими(this);
            буф.уровень--;
            буф.пишиБайт('}');
        }
        else
            буф.пишиБайт(';');
        буф.нс();
    }

    проц visitBaseClasses(ClassDeclaration d)
    {
        if (!d || !d.baseclasses.dim)
            return;
        if (!d.isAnonymous())
            буф.пишиСтр(" : ");
        foreach (i, b; *d.baseclasses)
        {
            if (i)
                буф.пишиСтр(", ");
            typeToBuffer(b.тип, null, буф, hgs);
        }
    }

    override проц посети(AliasDeclaration d)
    {
        if (d.класс_хранения & STC.local)
            return;
        буф.пишиСтр("alias ");
        if (d.aliassym)
        {
            буф.пишиСтр(d.идент.вТкст());
            буф.пишиСтр(" = ");
            if (stcToBuffer(буф, d.класс_хранения))
                буф.пишиБайт(' ');
            d.aliassym.прими(this);
        }
        else if (d.тип.ty == Tfunction)
        {
            if (stcToBuffer(буф, d.класс_хранения))
                буф.пишиБайт(' ');
            typeToBuffer(d.тип, d.идент, буф, hgs);
        }
        else if (d.идент)
        {
            hgs.declstring = (d.идент == Id.ткст || d.идент == Id.wstring || d.идент == Id.dstring);
            буф.пишиСтр(d.идент.вТкст());
            буф.пишиСтр(" = ");
            if (stcToBuffer(буф, d.класс_хранения))
                буф.пишиБайт(' ');
            typeToBuffer(d.тип, null, буф, hgs);
            hgs.declstring = нет;
        }
        буф.пишиБайт(';');
        буф.нс();
    }

    override проц посети(VarDeclaration d)
    {
        if (d.класс_хранения & STC.local)
            return;
        visitVarDecl(d, нет);
        буф.пишиБайт(';');
        буф.нс();
    }

    проц visitVarDecl(VarDeclaration v, бул anywritten)
    {
        if (anywritten)
        {
            буф.пишиСтр(", ");
            буф.пишиСтр(v.идент.вТкст());
        }
        else
        {
            if (stcToBuffer(буф, v.класс_хранения))
                буф.пишиБайт(' ');
            if (v.тип)
                typeToBuffer(v.тип, v.идент, буф, hgs);
            else
                буф.пишиСтр(v.идент.вТкст());
        }
        if (v._иниц)
        {
            буф.пишиСтр(" = ");
            auto ie = v._иниц.isExpInitializer();
            if (ie && (ie.exp.op == ТОК2.construct || ie.exp.op == ТОК2.blit))
                (cast(AssignExp)ie.exp).e2.ВыражениеToBuffer(буф, hgs);
            else
                v._иниц.initializerToBuffer(буф, hgs);
        }
    }

    override проц посети(FuncDeclaration f)
    {
        //printf("FuncDeclaration::toCBuffer() '%s'\n", f.вТкст0());
        if (stcToBuffer(буф, f.класс_хранения))
            буф.пишиБайт(' ');
        auto tf = cast(TypeFunction)f.тип;
        typeToBuffer(tf, f.идент, буф, hgs);

        if (hgs.hdrgen)
        {
            // if the return тип is missing (e.g. ref functions or auto)
            if (!tf.следщ || f.класс_хранения & STC.auto_)
            {
                hgs.autoMember++;
                bodyToBuffer(f);
                hgs.autoMember--;
            }
            else if (hgs.tpltMember == 0 && глоб2.парамы.hdrStripPlainFunctions)
            {
                буф.пишиБайт(';');
                буф.нс();
            }
            else
                bodyToBuffer(f);
        }
        else
            bodyToBuffer(f);
    }

    проц bodyToBuffer(FuncDeclaration f)
    {
        if (!f.fbody || (hgs.hdrgen && глоб2.парамы.hdrStripPlainFunctions && !hgs.autoMember && !hgs.tpltMember))
        {
            буф.пишиБайт(';');
            буф.нс();
            return;
        }
        const savetlpt = hgs.tpltMember;
        const saveauto = hgs.autoMember;
        hgs.tpltMember = 0;
        hgs.autoMember = 0;
        буф.нс();
        бул requireDo = нет;
        // in{}
        if (f.frequires)
        {
            foreach (frequire; *f.frequires)
            {
                буф.пишиСтр("in");
                if (auto es = frequire.isExpStatement())
                {
                    assert(es.exp && es.exp.op == ТОК2.assert_);
                    буф.пишиСтр(" (");
                    (cast(AssertExp)es.exp).e1.ВыражениеToBuffer(буф, hgs);
                    буф.пишиБайт(')');
                    буф.нс();
                    requireDo = нет;
                }
                else
                {
                    буф.нс();
                    frequire.statementToBuffer(буф, hgs);
                    requireDo = да;
                }
            }
        }
        // out{}
        if (f.fensures)
        {
            foreach (fensure; *f.fensures)
            {
                буф.пишиСтр("out");
                if (auto es = fensure.ensure.isExpStatement())
                {
                    assert(es.exp && es.exp.op == ТОК2.assert_);
                    буф.пишиСтр(" (");
                    if (fensure.ид)
                    {
                        буф.пишиСтр(fensure.ид.вТкст());
                    }
                    буф.пишиСтр("; ");
                    (cast(AssertExp)es.exp).e1.ВыражениеToBuffer(буф, hgs);
                    буф.пишиБайт(')');
                    буф.нс();
                    requireDo = нет;
                }
                else
                {
                    if (fensure.ид)
                    {
                        буф.пишиБайт('(');
                        буф.пишиСтр(fensure.ид.вТкст());
                        буф.пишиБайт(')');
                    }
                    буф.нс();
                    fensure.ensure.statementToBuffer(буф, hgs);
                    requireDo = да;
                }
            }
        }
        if (requireDo)
        {
            буф.пишиСтр("do");
            буф.нс();
        }
        буф.пишиБайт('{');
        буф.нс();
        буф.уровень++;
        f.fbody.statementToBuffer(буф, hgs);
        буф.уровень--;
        буф.пишиБайт('}');
        буф.нс();
        hgs.tpltMember = savetlpt;
        hgs.autoMember = saveauto;
    }

    override проц посети(FuncLiteralDeclaration f)
    {
        if (f.тип.ty == Terror)
        {
            буф.пишиСтр("__error");
            return;
        }
        if (f.tok != ТОК2.reserved)
        {
            буф.пишиСтр(f.вид());
            буф.пишиБайт(' ');
        }
        TypeFunction tf = cast(TypeFunction)f.тип;

        if (!f.inferRetType && tf.следщ)
            typeToBuffer(tf.следщ, null, буф, hgs);
        parametersToBuffer(tf.parameterList, буф, hgs);

        // https://issues.dlang.org/show_bug.cgi?ид=20074
        проц printAttribute(ткст str)
        {
            буф.пишиБайт(' ');
            буф.пишиСтр(str);
        }
        tf.attributesApply(&printAttribute);


        CompoundStatement cs = f.fbody.isCompoundStatement();
        Инструкция2 s1;
        if (f.semanticRun >= PASS.semantic3done && cs)
        {
            s1 = (*cs.statements)[cs.statements.dim - 1];
        }
        else
            s1 = !cs ? f.fbody : null;
        ReturnStatement rs = s1 ? s1.endsWithReturnStatement() : null;
        if (rs && rs.exp)
        {
            буф.пишиСтр(" => ");
            rs.exp.ВыражениеToBuffer(буф, hgs);
        }
        else
        {
            hgs.tpltMember++;
            bodyToBuffer(f);
            hgs.tpltMember--;
        }
    }

    override проц посети(PostBlitDeclaration d)
    {
        if (stcToBuffer(буф, d.класс_хранения))
            буф.пишиБайт(' ');
        буф.пишиСтр("this(this)");
        bodyToBuffer(d);
    }

    override проц посети(DtorDeclaration d)
    {
        if (d.класс_хранения & STC.trusted)
            буф.пишиСтр("@trusted ");
        if (d.класс_хранения & STC.safe)
            буф.пишиСтр(" ");
        if (d.класс_хранения & STC.nogc)
            буф.пишиСтр(" ");
        if (d.класс_хранения & STC.disable)
            буф.пишиСтр("@disable ");

        буф.пишиСтр("~this()");
        bodyToBuffer(d);
    }

    override проц посети(StaticCtorDeclaration d)
    {
        if (stcToBuffer(буф, d.класс_хранения & ~STC.static_))
            буф.пишиБайт(' ');
        if (d.isSharedStaticCtorDeclaration())
            буф.пишиСтр("shared ");
        буф.пишиСтр("static this()");
        if (hgs.hdrgen && !hgs.tpltMember)
        {
            буф.пишиБайт(';');
            буф.нс();
        }
        else
            bodyToBuffer(d);
    }

    override проц посети(StaticDtorDeclaration d)
    {
        if (stcToBuffer(буф, d.класс_хранения & ~STC.static_))
            буф.пишиБайт(' ');
        if (d.isSharedStaticDtorDeclaration())
            буф.пишиСтр("shared ");
        буф.пишиСтр("static ~this()");
        if (hgs.hdrgen && !hgs.tpltMember)
        {
            буф.пишиБайт(';');
            буф.нс();
        }
        else
            bodyToBuffer(d);
    }

    override проц посети(InvariantDeclaration d)
    {
        if (hgs.hdrgen)
            return;
        if (stcToBuffer(буф, d.класс_хранения))
            буф.пишиБайт(' ');
        буф.пишиСтр("invariant");
        if(auto es = d.fbody.isExpStatement())
        {
            assert(es.exp && es.exp.op == ТОК2.assert_);
            буф.пишиСтр(" (");
            (cast(AssertExp)es.exp).e1.ВыражениеToBuffer(буф, hgs);
            буф.пишиСтр(");");
            буф.нс();
        }
        else
        {
            bodyToBuffer(d);
        }
    }

    override проц посети(UnitTestDeclaration d)
    {
        if (hgs.hdrgen)
            return;
        if (stcToBuffer(буф, d.класс_хранения))
            буф.пишиБайт(' ');
        буф.пишиСтр("unittest");
        bodyToBuffer(d);
    }

    override проц посети(NewDeclaration d)
    {
        if (stcToBuffer(буф, d.класс_хранения & ~STC.static_))
            буф.пишиБайт(' ');
        буф.пишиСтр("new");
        parametersToBuffer(СписокПараметров(d.parameters, d.varargs), буф, hgs);
        bodyToBuffer(d);
    }

    override проц посети(Module m)
    {
        moduleToBuffer2(m, буф, hgs);
    }
}

private  final class ВыражениеPrettyPrintVisitor : Визитор2
{
    alias Визитор2.посети посети;
public:
    БуфВыв* буф;
    HdrGenState* hgs;

    this(БуфВыв* буф, HdrGenState* hgs)
    {
        this.буф = буф;
        this.hgs = hgs;
    }

    ////////////////////////////////////////////////////////////////////////////
    override проц посети(Выражение e)
    {
        буф.пишиСтр(Сема2.вТкст(e.op));
    }

    override проц посети(IntegerExp e)
    {
        const dinteger_t v = e.toInteger();
        if (e.тип)
        {
            Тип t = e.тип;
        L1:
            switch (t.ty)
            {
            case Tenum:
                {
                    TypeEnum te = cast(TypeEnum)t;
                    if (hgs.fullDump)
                    {
                        auto sym = te.sym;
                        if (hgs.inEnumDecl && sym && hgs.inEnumDecl != sym)  foreach(i; new бцел[0 .. sym.члены.dim])
                        {
                            EnumMember em = cast(EnumMember) (*sym.члены)[i];
                            if (em.значение.toInteger == v)
                            {
                                буф.printf("%s.%s", sym.вТкст0(), em.идент.вТкст0());
                                return ;
                            }
                        }
                        //assert(0, "We could not найди the EmumMember");// for some reason it won't приставь ткст0 ~ e.вТкст0() ~ " in " ~ sym.вТкст0() );
                    }

                    буф.printf("cast(%s)", te.sym.вТкст0());
                    t = te.sym.memtype;
                    goto L1;
                }
            case Twchar:
                // BUG: need to cast(wchar)
            case Tdchar:
                // BUG: need to cast(dchar)
                if (cast(uinteger_t)v > 0xFF)
                {
                    буф.printf("'\\U%08llx'", cast(long)v);
                    break;
                }
                goto case;
            case Tchar:
                {
                    т_мера o = буф.length;
                    if (v == '\'')
                        буф.пишиСтр("'\\''");
                    else if (isprint(cast(цел)v) && v != '\\')
                        буф.printf("'%c'", cast(цел)v);
                    else
                        буф.printf("'\\x%02x'", cast(цел)v);
                    if (hgs.ddoc)
                        escapeDdocString(буф, o);
                    break;
                }
            case Tint8:
                буф.пишиСтр("cast(byte)");
                goto L2;
            case Tint16:
                буф.пишиСтр("cast(short)");
                goto L2;
            case Tint32:
            L2:
                буф.printf("%d", cast(цел)v);
                break;
            case Tuns8:
                буф.пишиСтр("cast(ббайт)");
                goto case Tuns32;
            case Tuns16:
                буф.пишиСтр("cast(ushort)");
                goto case Tuns32;
            case Tuns32:
                буф.printf("%uu", cast(бцел)v);
                break;
            case Tint64:
                буф.printf("%lldL", v);
                break;
            case Tuns64:
                буф.printf("%lluLU", v);
                break;
            case Tbool:
                буф.пишиСтр(v ? "да" : "нет");
                break;
            case Tpointer:
                буф.пишиСтр("cast(");
                буф.пишиСтр(t.вТкст0());
                буф.пишиБайт(')');
                if (target.ptrsize == 8)
                    goto case Tuns64;
                else
                    goto case Tuns32;
            default:
                /* This can happen if errors, such as
                 * the тип is painted on like in fromConstInitializer().
                 */
                if (!глоб2.errors)
                {
                    assert(0);
                }
                break;
            }
        }
        else if (v & 0x8000000000000000L)
            буф.printf("0x%llx", v);
        else
            буф.print(v);
    }

    override проц посети(ErrorExp e)
    {
        буф.пишиСтр("__error");
    }

    override проц посети(VoidInitExp e)
    {
        буф.пишиСтр("__void");
    }

    проц floatToBuffer(Тип тип, real_t значение)
    {
        /** sizeof(значение)*3 is because each byte of mantissa is max
         of 256 (3 characters). The ткст will be "-M.MMMMe-4932".
         (ie, 8 chars more than mantissa). Plus one for trailing \0.
         Plus one for rounding. */
        const т_мера BUFFER_LEN = значение.sizeof * 3 + 8 + 1 + 1;
        сим[BUFFER_LEN] буфер;
        CTFloat.sprint(буфер.ptr, 'g', значение);
        assert(strlen(буфер.ptr) < BUFFER_LEN);
        if (hgs.hdrgen)
        {
            real_t r = CTFloat.parse(буфер.ptr);
            if (r != значение) // if exact duplication
                CTFloat.sprint(буфер.ptr, 'a', значение);
        }
        буф.пишиСтр(буфер.ptr);
        if (буфер.ptr[strlen(буфер.ptr) - 1] == '.')
            буф.удали(буф.length() - 1, 1);

        if (тип)
        {
            Тип t = тип.toBasetype();
            switch (t.ty)
            {
            case Tfloat32:
            case Timaginary32:
            case Tcomplex32:
                буф.пишиБайт('F');
                break;
            case Tfloat80:
            case Timaginary80:
            case Tcomplex80:
                буф.пишиБайт('L');
                break;
            default:
                break;
            }
            if (t.isimaginary())
                буф.пишиБайт('i');
        }
    }

    override проц посети(RealExp e)
    {
        floatToBuffer(e.тип, e.значение);
    }

    override проц посети(ComplexExp e)
    {
        /* Print as:
         *  (re+imi)
         */
        буф.пишиБайт('(');
        floatToBuffer(e.тип, creall(e.значение));
        буф.пишиБайт('+');
        floatToBuffer(e.тип, cimagl(e.значение));
        буф.пишиСтр("i)");
    }

    override проц посети(IdentifierExp e)
    {
        if (hgs.hdrgen || hgs.ddoc)
            буф.пишиСтр(e.идент.toHChars2());
        else
            буф.пишиСтр(e.идент.вТкст());
    }

    override проц посети(DsymbolExp e)
    {
        буф.пишиСтр(e.s.вТкст0());
    }

    override проц посети(ThisExp e)
    {
        буф.пишиСтр("this");
    }

    override проц посети(SuperExp e)
    {
        буф.пишиСтр("super");
    }

    override проц посети(NullExp e)
    {
        буф.пишиСтр("null");
    }

    override проц посети(StringExp e)
    {
        буф.пишиБайт('"');
        const o = буф.length;
        for (т_мера i = 0; i < e.len; i++)
        {
            const c = e.charAt(i);
            switch (c)
            {
            case '"':
            case '\\':
                буф.пишиБайт('\\');
                goto default;
            default:
                if (c <= 0xFF)
                {
                    if (c <= 0x7F && isprint(c))
                        буф.пишиБайт(c);
                    else
                        буф.printf("\\x%02x", c);
                }
                else if (c <= 0xFFFF)
                    буф.printf("\\x%02x\\x%02x", c & 0xFF, c >> 8);
                else
                    буф.printf("\\x%02x\\x%02x\\x%02x\\x%02x", c & 0xFF, (c >> 8) & 0xFF, (c >> 16) & 0xFF, c >> 24);
                break;
            }
        }
        if (hgs.ddoc)
            escapeDdocString(буф, o);
        буф.пишиБайт('"');
        if (e.postfix)
            буф.пишиБайт(e.postfix);
    }

    override проц посети(ArrayLiteralExp e)
    {
        буф.пишиБайт('[');
        argsToBuffer(e.elements, буф, hgs, e.basis);
        буф.пишиБайт(']');
    }

    override проц посети(AssocArrayLiteralExp e)
    {
        буф.пишиБайт('[');
        foreach (i, ключ; *e.keys)
        {
            if (i)
                буф.пишиСтр(", ");
            expToBuffer(ключ, PREC.assign, буф, hgs);
            буф.пишиБайт(':');
            auto значение = (*e.values)[i];
            expToBuffer(значение, PREC.assign, буф, hgs);
        }
        буф.пишиБайт(']');
    }

    override проц посети(StructLiteralExp e)
    {
        буф.пишиСтр(e.sd.вТкст0());
        буф.пишиБайт('(');
        // CTFE can generate struct literals that contain an AddrExp pointing
        // to themselves, need to avoid infinite recursion:
        // struct S { this(цел){ this.s = &this; } S* s; }
        // const foo = new S(0);
        if (e.stageflags & stageToCBuffer)
            буф.пишиСтр("<recursion>");
        else
        {
            const old = e.stageflags;
            e.stageflags |= stageToCBuffer;
            argsToBuffer(e.elements, буф, hgs);
            e.stageflags = old;
        }
        буф.пишиБайт(')');
    }

    override проц посети(TypeExp e)
    {
        typeToBuffer(e.тип, null, буф, hgs);
    }

    override проц посети(ScopeExp e)
    {
        if (e.sds.isTemplateInstance())
        {
            e.sds.dsymbolToBuffer(буф, hgs);
        }
        else if (hgs !is null && hgs.ddoc)
        {
            // fixes bug 6491
            if (auto m = e.sds.isModule())
                буф.пишиСтр(m.md.вТкст0());
            else
                буф.пишиСтр(e.sds.вТкст0());
        }
        else
        {
            буф.пишиСтр(e.sds.вид());
            буф.пишиБайт(' ');
            буф.пишиСтр(e.sds.вТкст0());
        }
    }

    override проц посети(TemplateExp e)
    {
        буф.пишиСтр(e.td.вТкст0());
    }

    override проц посети(NewExp e)
    {
        if (e.thisexp)
        {
            expToBuffer(e.thisexp, PREC.primary, буф, hgs);
            буф.пишиБайт('.');
        }
        буф.пишиСтр("new ");
        if (e.newargs && e.newargs.dim)
        {
            буф.пишиБайт('(');
            argsToBuffer(e.newargs, буф, hgs);
            буф.пишиБайт(')');
        }
        typeToBuffer(e.newtype, null, буф, hgs);
        if (e.arguments && e.arguments.dim)
        {
            буф.пишиБайт('(');
            argsToBuffer(e.arguments, буф, hgs);
            буф.пишиБайт(')');
        }
    }

    override проц посети(NewAnonClassExp e)
    {
        if (e.thisexp)
        {
            expToBuffer(e.thisexp, PREC.primary, буф, hgs);
            буф.пишиБайт('.');
        }
        буф.пишиСтр("new");
        if (e.newargs && e.newargs.dim)
        {
            буф.пишиБайт('(');
            argsToBuffer(e.newargs, буф, hgs);
            буф.пишиБайт(')');
        }
        буф.пишиСтр(" class ");
        if (e.arguments && e.arguments.dim)
        {
            буф.пишиБайт('(');
            argsToBuffer(e.arguments, буф, hgs);
            буф.пишиБайт(')');
        }
        if (e.cd)
            e.cd.dsymbolToBuffer(буф, hgs);
    }

    override проц посети(SymOffExp e)
    {
        if (e.смещение)
            буф.printf("(& %s%+lld)", e.var.вТкст0(), e.смещение);
        else if (e.var.isTypeInfoDeclaration())
            буф.пишиСтр(e.var.вТкст0());
        else
            буф.printf("& %s", e.var.вТкст0());
    }

    override проц посети(VarExp e)
    {
        буф.пишиСтр(e.var.вТкст0());
    }

    override проц посети(OverExp e)
    {
        буф.пишиСтр(e.vars.идент.вТкст());
    }

    override проц посети(TupleExp e)
    {
        if (e.e0)
        {
            буф.пишиБайт('(');
            e.e0.прими(this);
            буф.пишиСтр(", кортеж(");
            argsToBuffer(e.exps, буф, hgs);
            буф.пишиСтр("))");
        }
        else
        {
            буф.пишиСтр("кортеж(");
            argsToBuffer(e.exps, буф, hgs);
            буф.пишиБайт(')');
        }
    }

    override проц посети(FuncExp e)
    {
        e.fd.dsymbolToBuffer(буф, hgs);
        //буф.пишиСтр(e.fd.вТкст0());
    }

    override проц посети(DeclarationExp e)
    {
        /* Normal dmd execution won't reach here - regular variable declarations
         * are handled in посети(ExpStatement), so here would be используется only when
         * we'll directly call Выражение.вТкст0() for debugging.
         */
        if (e.declaration)
        {
            if (auto var = e.declaration.isVarDeclaration())
            {
            // For debugging use:
            // - Avoid printing newline.
            // - Intentionally use the format (Тип var;)
            //   which isn't correct as regular D code.
                буф.пишиБайт('(');

                scope v = new DsymbolPrettyPrintVisitor(буф, hgs);
                v.visitVarDecl(var, нет);

                буф.пишиБайт(';');
                буф.пишиБайт(')');
            }
            else e.declaration.dsymbolToBuffer(буф, hgs);
        }
    }

    override проц посети(TypeidExp e)
    {
        буф.пишиСтр("typeid(");
        objectToBuffer(e.obj, буф, hgs);
        буф.пишиБайт(')');
    }

    override проц посети(TraitsExp e)
    {
        буф.пишиСтр("__traits(");
        if (e.идент)
            буф.пишиСтр(e.идент.вТкст());
        if (e.args)
        {
            foreach (arg; *e.args)
            {
                буф.пишиСтр(", ");
                objectToBuffer(arg, буф, hgs);
            }
        }
        буф.пишиБайт(')');
    }

    override проц посети(HaltExp e)
    {
        буф.пишиСтр("halt");
    }

    override проц посети(IsExp e)
    {
        буф.пишиСтр("is(");
        typeToBuffer(e.targ, e.ид, буф, hgs);
        if (e.tok2 != ТОК2.reserved)
        {
            буф.printf(" %s %s", Сема2.вТкст0(e.tok), Сема2.вТкст0(e.tok2));
        }
        else if (e.tspec)
        {
            if (e.tok == ТОК2.colon)
                буф.пишиСтр(" : ");
            else
                буф.пишиСтр(" == ");
            typeToBuffer(e.tspec, null, буф, hgs);
        }
        if (e.parameters && e.parameters.dim)
        {
            буф.пишиСтр(", ");
            scope v = new DsymbolPrettyPrintVisitor(буф, hgs);
            v.visitTemplateParameters(e.parameters);
        }
        буф.пишиБайт(')');
    }

    override проц посети(UnaExp e)
    {
        буф.пишиСтр(Сема2.вТкст(e.op));
        expToBuffer(e.e1, precedence[e.op], буф, hgs);
    }

    override проц посети(BinExp e)
    {
        expToBuffer(e.e1, precedence[e.op], буф, hgs);
        буф.пишиБайт(' ');
        буф.пишиСтр(Сема2.вТкст(e.op));
        буф.пишиБайт(' ');
        expToBuffer(e.e2, cast(PREC)(precedence[e.op] + 1), буф, hgs);
    }

    override проц посети(CompileExp e)
    {
        буф.пишиСтр("mixin(");
        argsToBuffer(e.exps, буф, hgs, null);
        буф.пишиБайт(')');
    }

    override проц посети(ImportExp e)
    {
        буф.пишиСтр("import(");
        expToBuffer(e.e1, PREC.assign, буф, hgs);
        буф.пишиБайт(')');
    }

    override проц посети(AssertExp e)
    {
        буф.пишиСтр("assert(");
        expToBuffer(e.e1, PREC.assign, буф, hgs);
        if (e.msg)
        {
            буф.пишиСтр(", ");
            expToBuffer(e.msg, PREC.assign, буф, hgs);
        }
        буф.пишиБайт(')');
    }

    override проц посети(DotIdExp e)
    {
        expToBuffer(e.e1, PREC.primary, буф, hgs);
        буф.пишиБайт('.');
        буф.пишиСтр(e.идент.вТкст());
    }

    override проц посети(DotTemplateExp e)
    {
        expToBuffer(e.e1, PREC.primary, буф, hgs);
        буф.пишиБайт('.');
        буф.пишиСтр(e.td.вТкст0());
    }

    override проц посети(DotVarExp e)
    {
        expToBuffer(e.e1, PREC.primary, буф, hgs);
        буф.пишиБайт('.');
        буф.пишиСтр(e.var.вТкст0());
    }

    override проц посети(DotTemplateInstanceExp e)
    {
        expToBuffer(e.e1, PREC.primary, буф, hgs);
        буф.пишиБайт('.');
        e.ti.dsymbolToBuffer(буф, hgs);
    }

    override проц посети(DelegateExp e)
    {
        буф.пишиБайт('&');
        if (!e.func.isNested() || e.func.needThis())
        {
            expToBuffer(e.e1, PREC.primary, буф, hgs);
            буф.пишиБайт('.');
        }
        буф.пишиСтр(e.func.вТкст0());
    }

    override проц посети(DotTypeExp e)
    {
        expToBuffer(e.e1, PREC.primary, буф, hgs);
        буф.пишиБайт('.');
        буф.пишиСтр(e.sym.вТкст0());
    }

    override проц посети(CallExp e)
    {
        if (e.e1.op == ТОК2.тип)
        {
            /* Avoid parens around тип to prevent forbidden cast syntax:
             *   (sometype)(arg1)
             * This is ok since types in constructor calls
             * can never depend on parens anyway
             */
            e.e1.прими(this);
        }
        else
            expToBuffer(e.e1, precedence[e.op], буф, hgs);
        буф.пишиБайт('(');
        argsToBuffer(e.arguments, буф, hgs);
        буф.пишиБайт(')');
    }

    override проц посети(PtrExp e)
    {
        буф.пишиБайт('*');
        expToBuffer(e.e1, precedence[e.op], буф, hgs);
    }

    override проц посети(DeleteExp e)
    {
        буф.пишиСтр("delete ");
        expToBuffer(e.e1, precedence[e.op], буф, hgs);
    }

    override проц посети(CastExp e)
    {
        буф.пишиСтр("cast(");
        if (e.to)
            typeToBuffer(e.to, null, буф, hgs);
        else
        {
            MODtoBuffer(буф, e.mod);
        }
        буф.пишиБайт(')');
        expToBuffer(e.e1, precedence[e.op], буф, hgs);
    }

    override проц посети(VectorExp e)
    {
        буф.пишиСтр("cast(");
        typeToBuffer(e.to, null, буф, hgs);
        буф.пишиБайт(')');
        expToBuffer(e.e1, precedence[e.op], буф, hgs);
    }

    override проц посети(VectorArrayExp e)
    {
        expToBuffer(e.e1, PREC.primary, буф, hgs);
        буф.пишиСтр(".массив");
    }

    override проц посети(SliceExp e)
    {
        expToBuffer(e.e1, precedence[e.op], буф, hgs);
        буф.пишиБайт('[');
        if (e.upr || e.lwr)
        {
            if (e.lwr)
                sizeToBuffer(e.lwr, буф, hgs);
            else
                буф.пишиБайт('0');
            буф.пишиСтр("..");
            if (e.upr)
                sizeToBuffer(e.upr, буф, hgs);
            else
                буф.пишиБайт('$');
        }
        буф.пишиБайт(']');
    }

    override проц посети(ArrayLengthExp e)
    {
        expToBuffer(e.e1, PREC.primary, буф, hgs);
        буф.пишиСтр(".length");
    }

    override проц посети(IntervalExp e)
    {
        expToBuffer(e.lwr, PREC.assign, буф, hgs);
        буф.пишиСтр("..");
        expToBuffer(e.upr, PREC.assign, буф, hgs);
    }

    override проц посети(DelegatePtrExp e)
    {
        expToBuffer(e.e1, PREC.primary, буф, hgs);
        буф.пишиСтр(".ptr");
    }

    override проц посети(DelegateFuncptrExp e)
    {
        expToBuffer(e.e1, PREC.primary, буф, hgs);
        буф.пишиСтр(".funcptr");
    }

    override проц посети(ArrayExp e)
    {
        expToBuffer(e.e1, PREC.primary, буф, hgs);
        буф.пишиБайт('[');
        argsToBuffer(e.arguments, буф, hgs);
        буф.пишиБайт(']');
    }

    override проц посети(DotExp e)
    {
        expToBuffer(e.e1, PREC.primary, буф, hgs);
        буф.пишиБайт('.');
        expToBuffer(e.e2, PREC.primary, буф, hgs);
    }

    override проц посети(IndexExp e)
    {
        expToBuffer(e.e1, PREC.primary, буф, hgs);
        буф.пишиБайт('[');
        sizeToBuffer(e.e2, буф, hgs);
        буф.пишиБайт(']');
    }

    override проц посети(PostExp e)
    {
        expToBuffer(e.e1, precedence[e.op], буф, hgs);
        буф.пишиСтр(Сема2.вТкст(e.op));
    }

    override проц посети(PreExp e)
    {
        буф.пишиСтр(Сема2.вТкст(e.op));
        expToBuffer(e.e1, precedence[e.op], буф, hgs);
    }

    override проц посети(RemoveExp e)
    {
        expToBuffer(e.e1, PREC.primary, буф, hgs);
        буф.пишиСтр(".удали(");
        expToBuffer(e.e2, PREC.assign, буф, hgs);
        буф.пишиБайт(')');
    }

    override проц посети(CondExp e)
    {
        expToBuffer(e.econd, PREC.oror, буф, hgs);
        буф.пишиСтр(" ? ");
        expToBuffer(e.e1, PREC.expr, буф, hgs);
        буф.пишиСтр(" : ");
        expToBuffer(e.e2, PREC.cond, буф, hgs);
    }

    override проц посети(DefaultInitExp e)
    {
        буф.пишиСтр(Сема2.вТкст(e.subop));
    }

    override проц посети(ClassReferenceExp e)
    {
        буф.пишиСтр(e.значение.вТкст0());
    }
}


private проц templateParameterToBuffer(ПараметрШаблона2 tp, БуфВыв* буф, HdrGenState* hgs)
{
    scope v = new TemplateParameterPrettyPrintVisitor(буф, hgs);
    tp.прими(v);
}

private  final class TemplateParameterPrettyPrintVisitor : Визитор2
{
    alias Визитор2.посети посети;
public:
    БуфВыв* буф;
    HdrGenState* hgs;

    this(БуфВыв* буф, HdrGenState* hgs)
    {
        this.буф = буф;
        this.hgs = hgs;
    }

    override проц посети(TemplateTypeParameter tp)
    {
        буф.пишиСтр(tp.идент.вТкст());
        if (tp.specType)
        {
            буф.пишиСтр(" : ");
            typeToBuffer(tp.specType, null, буф, hgs);
        }
        if (tp.defaultType)
        {
            буф.пишиСтр(" = ");
            typeToBuffer(tp.defaultType, null, буф, hgs);
        }
    }

    override проц посети(TemplateThisParameter tp)
    {
        буф.пишиСтр("this ");
        посети(cast(TemplateTypeParameter)tp);
    }

    override проц посети(TemplateAliasParameter tp)
    {
        буф.пишиСтр("alias ");
        if (tp.specType)
            typeToBuffer(tp.specType, tp.идент, буф, hgs);
        else
            буф.пишиСтр(tp.идент.вТкст());
        if (tp.specAlias)
        {
            буф.пишиСтр(" : ");
            objectToBuffer(tp.specAlias, буф, hgs);
        }
        if (tp.defaultAlias)
        {
            буф.пишиСтр(" = ");
            objectToBuffer(tp.defaultAlias, буф, hgs);
        }
    }

    override проц посети(TemplateValueParameter tp)
    {
        typeToBuffer(tp.valType, tp.идент, буф, hgs);
        if (tp.specValue)
        {
            буф.пишиСтр(" : ");
            tp.specValue.ВыражениеToBuffer(буф, hgs);
        }
        if (tp.defaultValue)
        {
            буф.пишиСтр(" = ");
            tp.defaultValue.ВыражениеToBuffer(буф, hgs);
        }
    }

    override проц посети(TemplateTupleParameter tp)
    {
        буф.пишиСтр(tp.идент.вТкст());
        буф.пишиСтр("...");
    }
}

private проц conditionToBuffer(Condition c, БуфВыв* буф, HdrGenState* hgs)
{
    scope v = new ConditionPrettyPrintVisitor(буф, hgs);
    c.прими(v);
}

private  final class ConditionPrettyPrintVisitor : Визитор2
{
    alias Визитор2.посети посети;
public:
    БуфВыв* буф;
    HdrGenState* hgs;

    this(БуфВыв* буф, HdrGenState* hgs)
    {
        this.буф = буф;
        this.hgs = hgs;
    }

    override проц посети(DebugCondition c)
    {
        буф.пишиСтр("debug (");
        if (c.идент)
            буф.пишиСтр(c.идент.вТкст());
        else
            буф.print(c.уровень);
        буф.пишиБайт(')');
    }

    override проц посети(VersionCondition c)
    {
        буф.пишиСтр("version (");
        if (c.идент)
            буф.пишиСтр(c.идент.вТкст());
        else
            буф.print(c.уровень);
        буф.пишиБайт(')');
    }

    override проц посети(StaticIfCondition c)
    {
        буф.пишиСтр("static if (");
        c.exp.ВыражениеToBuffer(буф, hgs);
        буф.пишиБайт(')');
    }
}

проц toCBuffer(Инструкция2 s, БуфВыв* буф, HdrGenState* hgs)
{
    scope v = new StatementPrettyPrintVisitor(буф, hgs);
    /*(/*cast()*/ s.прими(v);
}

проц toCBuffer(Тип t, БуфВыв* буф, Идентификатор2 идент, HdrGenState* hgs)
{
    typeToBuffer(/*cast()*/ t, идент, буф, hgs);
}

проц toCBuffer(ДСимвол s, БуфВыв* буф, HdrGenState* hgs)
{
    scope v = new DsymbolPrettyPrintVisitor(буф, hgs);
    s.прими(v);
}

// используется from TemplateInstance::вТкст0() and TemplateMixin::вТкст0()
проц toCBufferInstance(TemplateInstance ti, БуфВыв* буф, бул qualifyTypes = нет)
{
    HdrGenState hgs;
    hgs.fullQual = qualifyTypes;
    scope v = new DsymbolPrettyPrintVisitor(буф, &hgs);
    v.посети(/*cast()*/ ti);
}

проц toCBuffer(Инициализатор iz, БуфВыв* буф, HdrGenState* hgs)
{
    initializerToBuffer(/*cast()*/ iz, буф, hgs);
}

бул stcToBuffer(БуфВыв* буф, КлассХранения stc)
{
    бул результат = нет;
    if ((stc & (STC.return_ | STC.scope_)) == (STC.return_ | STC.scope_))
        stc &= ~STC.scope_;
    if (stc & STC.scopeinferred)
        stc &= ~(STC.scope_ | STC.scopeinferred);
    while (stc)
    {
        const s = stcToString(stc);
        if (!s.length)
            break;
        if (результат)
            буф.пишиБайт(' ');
        результат = да;
        буф.пишиСтр(s);
    }
    return результат;
}

/*************************************************
 * Pick off one of the storage classes from stc,
 * and return a ткст representation of it.
 * stc is reduced by the one picked.
 */
ткст stcToString(ref КлассХранения stc)
{
    struct SCstring
    {
        КлассХранения stc;
        ТОК2 tok;
        ткст ид;
    }

     SCstring* table =
    [
        SCstring(STC.auto_, ТОК2.auto_),
        SCstring(STC.scope_, ТОК2.scope_),
        SCstring(STC.static_, ТОК2.static_),
        SCstring(STC.extern_, ТОК2.extern_),
        SCstring(STC.const_, ТОК2.const_),
        SCstring(STC.final_, ТОК2.final_),
        SCstring(STC.abstract_, ТОК2.abstract_),
        SCstring(STC.synchronized_, ТОК2.synchronized_),
        SCstring(STC.deprecated_, ТОК2.deprecated_),
        SCstring(STC.override_, ТОК2.override_),
        SCstring(STC.lazy_, ТОК2.lazy_),
        SCstring(STC.alias_, ТОК2.alias_),
        SCstring(STC.out_, ТОК2.out_),
        SCstring(STC.in_, ТОК2.in_),
        SCstring(STC.manifest, ТОК2.enum_),
        SCstring(STC.immutable_, ТОК2.immutable_),
        SCstring(STC.shared_, ТОК2.shared_),
        SCstring(STC._, ТОК2._),
        SCstring(STC.wild, ТОК2.inout_),
        SCstring(STC.pure_, ТОК2.pure_),
        SCstring(STC.ref_, ТОК2.ref_),
        SCstring(STC.return_, ТОК2.return_),
        SCstring(STC.tls),
        SCstring(STC.gshared, ТОК2.gshared),
        SCstring(STC.nogc, ТОК2.at, ""),
        SCstring(STC.property, ТОК2.at, ""),
        SCstring(STC.safe, ТОК2.at, ""),
        SCstring(STC.trusted, ТОК2.at, "@trusted"),
        SCstring(STC.system, ТОК2.at, "@system"),
        SCstring(STC.disable, ТОК2.at, "@disable"),
        SCstring(STC.future, ТОК2.at, "@__future"),
        SCstring(STC.local, ТОК2.at, "__local"),
        SCstring(0, ТОК2.reserved)
    ];
    for (цел i = 0; table[i].stc; i++)
    {
        КлассХранения tbl = table[i].stc;
        assert(tbl & STCStorageClass);
        if (stc & tbl)
        {
            stc &= ~tbl;
            if (tbl == STC.tls) // TOKtls was removed
                return "__thread";
            ТОК2 tok = table[i].tok;
            if (tok != ТОК2.at && !table[i].ид.length)
                table[i].ид = Сема2.вТкст(tok); // lazilly initialize table
            return table[i].ид;
        }
    }
    //printf("stc = %llx\n", stc);
    return null;
}

ткст0 stcToChars(ref КлассХранения stc)
{
    const s = stcToString(stc);
    return &s[0];  // assume 0 terminated
}


/// Ditto
extern (D) ткст trustToString(TRUST trust)
{
    switch (trust)
    {
    case TRUST.default_:
        return null;
    case TRUST.system:
        return "@system";
    case TRUST.trusted:
        return "@trusted";
    case TRUST.safe:
        return "";
    }
}

private проц linkageToBuffer(БуфВыв* буф, LINK компонаж)
{
    const s = linkageToString(компонаж);
    if (s.length)
    {
        буф.пишиСтр("extern (");
        буф.пишиСтр(s);
        буф.пишиБайт(')');
    }
}

ткст0 компонажВТкст0(LINK компонаж)
{
    /// Works because we return a literal
    return linkageToString(компонаж).ptr;
}

ткст linkageToString(LINK компонаж)
{
    switch (компонаж)
    {
    case LINK.default_:
        return null;
    case LINK.d:
        return "D";
    case LINK.c:
        return "C";
    case LINK.cpp:
        return "C++";
    case LINK.windows:
        return "Windows";
    case LINK.pascal:
        return "Pascal";
    case LINK.objc:
        return "Objective-C";
    case LINK.system:
        return "System";
    }
}

проц protectionToBuffer(БуфВыв* буф, Prot prot)
{
    буф.пишиСтр(protectionToString(prot.вид));
    if (prot.вид == Prot.Kind.package_ && prot.pkg)
    {
        буф.пишиБайт('(');
        буф.пишиСтр(prot.pkg.toPrettyChars(да));
        буф.пишиБайт(')');
    }
}

/**
 * Возвращает:
 *   a human readable representation of `вид`
 */
ткст0 защитуВТкст0(Prot.Kind вид)
{
    // Null terminated because we return a literal
    return protectionToString(вид).ptr;
}

/// Ditto
extern (D) ткст protectionToString(Prot.Kind вид)  
{
    switch (вид)
    {
    case Prot.Kind.undefined:
        return null;
    case Prot.Kind.none:
        return "none";
    case Prot.Kind.private_:
        return "private";
    case Prot.Kind.package_:
        return "package";
    case Prot.Kind.protected_:
        return "protected";
    case Prot.Kind.public_:
        return "public";
    case Prot.Kind.export_:
        return "export";
    }
}

// Print the full function signature with correct идент, attributes and template args
проц functionToBufferFull(TypeFunction tf, БуфВыв* буф, Идентификатор2 идент, HdrGenState* hgs, TemplateDeclaration td)
{
    //printf("TypeFunction::toCBuffer() this = %p\n", this);
    visitFuncIdentWithPrefix(tf, идент, td, буф, hgs);
}

// идент is inserted before the argument list and will be "function" or "delegate" for a тип
проц functionToBufferWithIdent(TypeFunction tf, БуфВыв* буф, ткст0 идент)
{
    HdrGenState hgs;
    visitFuncIdentWithPostfix(tf, идент.вТкстД(), буф, &hgs);
}

проц toCBuffer(Выражение e, БуфВыв* буф, HdrGenState* hgs)
{
    scope v = new ВыражениеPrettyPrintVisitor(буф, hgs);
    (/*cast()*/ e).прими(v);
}

/**************************************************
 * Write out argument types to буф.
 */
проц argExpTypesToCBuffer(БуфВыв* буф, Выражения* arguments)
{
    if (!arguments || !arguments.dim)
        return;
    HdrGenState hgs;
    foreach (i, arg; *arguments)
    {
        if (i)
            буф.пишиСтр(", ");
        typeToBuffer(arg.тип, null, буф, &hgs);
    }
}

проц toCBuffer(ПараметрШаблона2 tp, БуфВыв* буф, HdrGenState* hgs)
{
    scope v = new TemplateParameterPrettyPrintVisitor(буф, hgs);
    (/*cast()*/ tp).прими(v);
}

проц arrayObjectsToBuffer(БуфВыв* буф, Объекты* objects)
{
    if (!objects || !objects.dim)
        return;
    HdrGenState hgs;
    foreach (i, o; *objects)
    {
        if (i)
            буф.пишиСтр(", ");
        objectToBuffer(o, буф, &hgs);
    }
}

/*************************************************************
 * Pretty print function parameters.
 * Параметры:
 *  pl = параметр list to print
 * Возвращает: Null-terminated ткст representing parameters.
 */
 ткст0 parametersTypeToChars(СписокПараметров pl)
{
    БуфВыв буф;
    HdrGenState hgs;
    parametersToBuffer(pl, &буф, &hgs);
    return буф.extractChars();
}

/*************************************************************
 * Pretty print function параметр.
 * Параметры:
 *  параметр = параметр to print.
 *  tf = TypeFunction which holds параметр.
 *  fullQual = whether to fully qualify types.
 * Возвращает: Null-terminated ткст representing parameters.
 */
ткст0 parameterToChars(Параметр2 параметр, TypeFunction tf, бул fullQual)
{
    БуфВыв буф;
    HdrGenState hgs;
    hgs.fullQual = fullQual;

    parameterToBuffer(параметр, &буф, &hgs);

    if (tf.parameterList.varargs == ВарАрг.typesafe && параметр == tf.parameterList[tf.parameterList.parameters.dim - 1])
    {
        буф.пишиСтр("...");
    }
    return буф.extractChars();
}


/*************************************************
 * Write СписокПараметров to буфер.
 * Параметры:
 *      pl = параметр list to serialize
 *      буф = буфер to пиши it to
 *      hgs = context
 */

private проц parametersToBuffer(СписокПараметров pl, БуфВыв* буф, HdrGenState* hgs)
{
    буф.пишиБайт('(');
    foreach (i; new бцел[0 .. pl.length])
    {
        if (i)
            буф.пишиСтр(", ");
        pl[i].parameterToBuffer(буф, hgs);
    }
    switch (pl.varargs)
    {
        case ВарАрг.none:
            break;

        case ВарАрг.variadic:
            if (pl.length == 0)
                goto case ВарАрг.typesafe;
            буф.пишиСтр(", ...");
            break;

        case ВарАрг.typesafe:
            буф.пишиСтр("...");
            break;
    }
    буф.пишиБайт(')');
}


/***********************************************************
 * Write параметр `p` to буфер `буф`.
 * Параметры:
 *      p = параметр to serialize
 *      буф = буфер to пиши it to
 *      hgs = context
 */
private проц parameterToBuffer(Параметр2 p, БуфВыв* буф, HdrGenState* hgs)
{
    if (p.userAttribDecl)
    {
        буф.пишиБайт('@');

        бул isAnonymous = p.userAttribDecl.atts.dim > 0 && (*p.userAttribDecl.atts)[0].op != ТОК2.call;
        if (isAnonymous)
            буф.пишиБайт('(');

        argsToBuffer(p.userAttribDecl.atts, буф, hgs);

        if (isAnonymous)
            буф.пишиБайт(')');
        буф.пишиБайт(' ');
    }
    if (p.классХранения & STC.auto_)
        буф.пишиСтр("auto ");
    if (p.классХранения & STC.return_)
        буф.пишиСтр("return ");

    if (p.классХранения & STC.out_)
        буф.пишиСтр("out ");
    else if (p.классХранения & STC.ref_)
        буф.пишиСтр("ref ");
    else if (p.классХранения & STC.in_)
        буф.пишиСтр("in ");
    else if (p.классХранения & STC.lazy_)
        буф.пишиСтр("lazy ");
    else if (p.классХранения & STC.alias_)
        буф.пишиСтр("alias ");

    КлассХранения stc = p.классХранения;
    if (p.тип && p.тип.mod & MODFlags.shared_)
        stc &= ~STC.shared_;

    if (stcToBuffer(буф, stc & (STC.const_ | STC.immutable_ | STC.wild | STC.shared_ | STC.scope_ | STC.scopeinferred)))
        буф.пишиБайт(' ');

    if (p.классХранения & STC.alias_)
    {
        if (p.идент)
            буф.пишиСтр(p.идент.вТкст());
    }
    else if (p.тип.ty == Tident &&
             (cast(TypeIdentifier)p.тип).идент.вТкст().length > 3 &&
             strncmp((cast(TypeIdentifier)p.тип).идент.вТкст0(), "__T", 3) == 0)
    {
        // print параметр имя, instead of undetermined тип параметр
        буф.пишиСтр(p.идент.вТкст());
    }
    else
    {
        typeToBuffer(p.тип, p.идент, буф, hgs);
    }

    if (p.defaultArg)
    {
        буф.пишиСтр(" = ");
        p.defaultArg.expToBuffer(PREC.assign, буф, hgs);
    }
}


/**************************************************
 * Write out argument list to буф.
 */
private проц argsToBuffer(Выражения* Выражения, БуфВыв* буф, HdrGenState* hgs, Выражение basis = null)
{
    if (!Выражения || !Выражения.dim)
        return;
    version (all)
    {
        foreach (i, el; *Выражения)
        {
            if (i)
                буф.пишиСтр(", ");
            if (!el)
                el = basis;
            if (el)
                expToBuffer(el, PREC.assign, буф, hgs);
        }
    }
    else
    {
        // Sparse style formatting, for debug use only
        //      [0..dim: basis, 1: e1, 5: e5]
        if (basis)
        {
            буф.пишиСтр("0..");
            буф.print(Выражения.dim);
            буф.пишиСтр(": ");
            expToBuffer(basis, PREC.assign, буф, hgs);
        }
        foreach (i, el; *Выражения)
        {
            if (el)
            {
                if (basis)
                {
                    буф.пишиСтр(", ");
                    буф.print(i);
                    буф.пишиСтр(": ");
                }
                else if (i)
                    буф.пишиСтр(", ");
                expToBuffer(el, PREC.assign, буф, hgs);
            }
        }
    }
}

private проц sizeToBuffer(Выражение e, БуфВыв* буф, HdrGenState* hgs)
{
    if (e.тип == Тип.tт_мера)
    {
        Выражение ex = (e.op == ТОК2.cast_ ? (cast(CastExp)e).e1 : e);
        ex = ex.optimize(WANTvalue);
        const dinteger_t uval = ex.op == ТОК2.int64 ? ex.toInteger() : cast(dinteger_t)-1;
        if (cast(sinteger_t)uval >= 0)
        {
            dinteger_t sizemax = проц;
            if (target.ptrsize == 8)
                sizemax = 0xFFFFFFFFFFFFFFFFUL;
            else if (target.ptrsize == 4)
                sizemax = 0xFFFFFFFFU;
            else if (target.ptrsize == 2)
                sizemax = 0xFFFFU;
            else
                assert(0);
            if (uval <= sizemax && uval <= 0x7FFFFFFFFFFFFFFFUL)
            {
                буф.print(uval);
                return;
            }
        }
    }
    expToBuffer(e, PREC.assign, буф, hgs);
}

private проц ВыражениеToBuffer(Выражение e, БуфВыв* буф, HdrGenState* hgs)
{
    scope v = new ВыражениеPrettyPrintVisitor(буф, hgs);
    e.прими(v);
}

/**************************************************
 * Write Выражение out to буф, but wrap it
 * in ( ) if its precedence is less than pr.
 */
private проц expToBuffer(Выражение e, PREC pr, БуфВыв* буф, HdrGenState* hgs)
{
    debug
    {
        if (precedence[e.op] == PREC.нуль)
            printf("precedence not defined for token '%s'\n", Сема2.вТкст0(e.op));
    }
    if (e.op == 0xFF)
    {
        буф.пишиСтр("<FF>");
        return;
    }
    assert(precedence[e.op] != PREC.нуль);
    assert(pr != PREC.нуль);
    /* Despite precedence, we don't allow a<b<c Выражения.
     * They must be parenthesized.
     */
    if (precedence[e.op] < pr || (pr == PREC.rel && precedence[e.op] == pr)
        || (pr >= PREC.or && pr <= PREC.and && precedence[e.op] == PREC.rel))
    {
        буф.пишиБайт('(');
        e.ВыражениеToBuffer(буф, hgs);
        буф.пишиБайт(')');
    }
    else
    {
        e.ВыражениеToBuffer(буф, hgs);
    }
}


/**************************************************
 * An entry point to pretty-print тип.
 */
private проц typeToBuffer(Тип t, Идентификатор2 идент, БуфВыв* буф, HdrGenState* hgs)
{
    if (auto tf = t.isTypeFunction())
    {
        visitFuncIdentWithPrefix(tf, идент, null, буф, hgs);
        return;
    }
    visitWithMask(t, 0, буф, hgs);
    if (идент)
    {
        буф.пишиБайт(' ');
        буф.пишиСтр(идент.вТкст());
    }
}

private проц visitWithMask(Тип t, ббайт modMask, БуфВыв* буф, HdrGenState* hgs)
{
    // Tuples and functions don't use the тип constructor syntax
    if (modMask == t.mod || t.ty == Tfunction || t.ty == Ttuple)
    {
        typeToBufferx(t, буф, hgs);
    }
    else
    {
        ббайт m = t.mod & ~(t.mod & modMask);
        if (m & MODFlags.shared_)
        {
            MODtoBuffer(буф, MODFlags.shared_);
            буф.пишиБайт('(');
        }
        if (m & MODFlags.wild)
        {
            MODtoBuffer(буф, MODFlags.wild);
            буф.пишиБайт('(');
        }
        if (m & (MODFlags.const_ | MODFlags.immutable_))
        {
            MODtoBuffer(буф, m & (MODFlags.const_ | MODFlags.immutable_));
            буф.пишиБайт('(');
        }
        typeToBufferx(t, буф, hgs);
        if (m & (MODFlags.const_ | MODFlags.immutable_))
            буф.пишиБайт(')');
        if (m & MODFlags.wild)
            буф.пишиБайт(')');
        if (m & MODFlags.shared_)
            буф.пишиБайт(')');
    }
}


private проц dumpTemplateInstance(TemplateInstance ti, БуфВыв* буф, HdrGenState* hgs)
{
    буф.пишиБайт('{');
    буф.нс();
    буф.уровень++;

    if (ti.aliasdecl)
    {
        ti.aliasdecl.dsymbolToBuffer(буф, hgs);
        буф.нс();
    }
    else if (ti.члены)
    {
        foreach(m;*ti.члены)
            m.dsymbolToBuffer(буф, hgs);
    }

    буф.уровень--;
    буф.пишиБайт('}');
    буф.нс();

}

private проц tiargsToBuffer(TemplateInstance ti, БуфВыв* буф, HdrGenState* hgs)
{
    буф.пишиБайт('!');
    if (ti.nest)
    {
        буф.пишиСтр("(...)");
        return;
    }
    if (!ti.tiargs)
    {
        буф.пишиСтр("()");
        return;
    }
    if (ti.tiargs.dim == 1)
    {
        КорневойОбъект oarg = (*ti.tiargs)[0];
        if (Тип t = тип_ли(oarg))
        {
            if (t.равен(Тип.tstring) || t.равен(Тип.twstring) || t.равен(Тип.tdstring) || t.mod == 0 && (t.isTypeBasic() || t.ty == Tident && (cast(TypeIdentifier)t).idents.dim == 0))
            {
                буф.пишиСтр(t.вТкст0());
                return;
            }
        }
        else if (Выражение e = выражение_ли(oarg))
        {
            if (e.op == ТОК2.int64 || e.op == ТОК2.float64 || e.op == ТОК2.null_ || e.op == ТОК2.string_ || e.op == ТОК2.this_)
            {
                буф.пишиСтр(e.вТкст0());
                return;
            }
        }
    }
    буф.пишиБайт('(');
    ti.nest++;
    foreach (i, arg; *ti.tiargs)
    {
        if (i)
            буф.пишиСтр(", ");
        objectToBuffer(arg, буф, hgs);
    }
    ti.nest--;
    буф.пишиБайт(')');
}

/****************************************
 * This makes a 'pretty' version of the template arguments.
 * It's analogous to genIdent() which makes a mangled version.
 */
private проц objectToBuffer(КорневойОбъект oarg, БуфВыв* буф, HdrGenState* hgs)
{
    //printf("objectToBuffer()\n");
    /* The logic of this should match what genIdent() does. The _dynamic_cast()
     * function relies on all the pretty strings to be unique for different classes
     * See https://issues.dlang.org/show_bug.cgi?ид=7375
     * Perhaps it would be better to demangle what genIdent() does.
     */
    if (auto t = тип_ли(oarg))
    {
        //printf("\tt: %s ty = %d\n", t.вТкст0(), t.ty);
        typeToBuffer(t, null, буф, hgs);
    }
    else if (auto e = выражение_ли(oarg))
    {
        if (e.op == ТОК2.variable)
            e = e.optimize(WANTvalue); // added to fix https://issues.dlang.org/show_bug.cgi?ид=7375
        expToBuffer(e, PREC.assign, буф, hgs);
    }
    else if (ДСимвол s = isDsymbol(oarg))
    {
        const p = s.идент ? s.идент.вТкст0() : s.вТкст0();
        буф.пишиСтр(p);
    }
    else if (auto v = кортеж_ли(oarg))
    {
        auto args = &v.objects;
        foreach (i, arg; *args)
        {
            if (i)
                буф.пишиСтр(", ");
            objectToBuffer(arg, буф, hgs);
        }
    }
    else if (!oarg)
    {
        буф.пишиСтр("NULL");
    }
    else
    {
        debug
        {
            printf("bad Object = %p\n", oarg);
        }
        assert(0);
    }
}


private проц visitFuncIdentWithPostfix(TypeFunction t, ткст идент, БуфВыв* буф, HdrGenState* hgs)
{
    if (t.inuse)
    {
        t.inuse = 2; // флаг error to caller
        return;
    }
    t.inuse++;
    if (t.компонаж > LINK.d && hgs.ddoc != 1 && !hgs.hdrgen)
    {
        linkageToBuffer(буф, t.компонаж);
        буф.пишиБайт(' ');
    }
    if (t.следщ)
    {
        typeToBuffer(t.следщ, null, буф, hgs);
        if (идент)
            буф.пишиБайт(' ');
    }
    else if (hgs.ddoc)
        буф.пишиСтр("auto ");
    if (идент)
        буф.пишиСтр(идент);
    parametersToBuffer(t.parameterList, буф, hgs);
    /* Use postfix style for attributes
     */
    if (t.mod)
    {
        буф.пишиБайт(' ');
        MODtoBuffer(буф, t.mod);
    }

    проц dg(ткст str)
    {
        буф.пишиБайт(' ');
        буф.пишиСтр(str);
    }
    t.attributesApply(&dg);

    t.inuse--;
}

private проц visitFuncIdentWithPrefix(TypeFunction t, Идентификатор2 идент, TemplateDeclaration td,
    БуфВыв* буф, HdrGenState* hgs)
{
    if (t.inuse)
    {
        t.inuse = 2; // флаг error to caller
        return;
    }
    t.inuse++;

    /* Use 'storage class' (префикс) style for attributes
     */
    if (t.mod)
    {
        MODtoBuffer(буф, t.mod);
        буф.пишиБайт(' ');
    }

    проц ignoreReturn(ткст str)
    {
        if (str != "return")
        {
            // don't пиши 'ref' for ctors
            if ((идент == Id.ctor) && str == "ref")
                return;
            буф.пишиСтр(str);
            буф.пишиБайт(' ');
        }
    }
    t.attributesApply(&ignoreReturn);

    if (t.компонаж > LINK.d && hgs.ddoc != 1 && !hgs.hdrgen)
    {
        linkageToBuffer(буф, t.компонаж);
        буф.пишиБайт(' ');
    }
    if (идент && идент.toHChars2() != идент.вТкст0())
    {
        // Don't print return тип for ctor, dtor, unittest, etc
    }
    else if (t.следщ)
    {
        typeToBuffer(t.следщ, null, буф, hgs);
        if (идент)
            буф.пишиБайт(' ');
    }
    else if (hgs.ddoc)
        буф.пишиСтр("auto ");
    if (идент)
        буф.пишиСтр(идент.toHChars2());
    if (td)
    {
        буф.пишиБайт('(');
        foreach (i, p; *td.origParameters)
        {
            if (i)
                буф.пишиСтр(", ");
            p.templateParameterToBuffer(буф, hgs);
        }
        буф.пишиБайт(')');
    }
    parametersToBuffer(t.parameterList, буф, hgs);
    if (t.isreturn)
    {
        буф.пишиСтр(" return");
    }
    t.inuse--;
}


private проц initializerToBuffer(Инициализатор inx, БуфВыв* буф, HdrGenState* hgs)
{
    проц visitError(ErrorInitializer iz)
    {
        буф.пишиСтр("__error__");
    }

    проц visitVoid(VoidInitializer iz)
    {
        буф.пишиСтр("проц");
    }

    проц visitStruct(StructInitializer si)
    {
        //printf("StructInitializer::toCBuffer()\n");
        буф.пишиБайт('{');
        foreach (i, ид; si.field)
        {
            if (i)
                буф.пишиСтр(", ");
            if (ид)
            {
                буф.пишиСтр(ид.вТкст());
                буф.пишиБайт(':');
            }
            if (auto iz = si.значение[i])
                initializerToBuffer(iz, буф, hgs);
        }
        буф.пишиБайт('}');
    }

    проц visitArray(ArrayInitializer ai)
    {
        буф.пишиБайт('[');
        foreach (i, ex; ai.index)
        {
            if (i)
                буф.пишиСтр(", ");
            if (ex)
            {
                ex.ВыражениеToBuffer(буф, hgs);
                буф.пишиБайт(':');
            }
            if (auto iz = ai.значение[i])
                initializerToBuffer(iz, буф, hgs);
        }
        буф.пишиБайт(']');
    }

    проц visitExp(ExpInitializer ei)
    {
        ei.exp.ВыражениеToBuffer(буф, hgs);
    }

    switch (inx.вид)
    {
        case InitKind.error:   return visitError (inx.isErrorInitializer ());
        case InitKind.void_:   return visitVoid  (inx.isVoidInitializer  ());
        case InitKind.struct_: return visitStruct(inx.isStructInitializer());
        case InitKind.массив:   return visitArray (inx.isArrayInitializer ());
        case InitKind.exp:     return visitExp   (inx.isExpInitializer   ());
    }
}


private проц typeToBufferx(Тип t, БуфВыв* буф, HdrGenState* hgs)
{
    проц visitType(Тип t)
    {
        printf("t = %p, ty = %d\n", t, t.ty);
        assert(0);
    }

    проц visitError(TypeError t)
    {
        буф.пишиСтр("_error_");
    }

    проц visitBasic(TypeBasic t)
    {
        //printf("TypeBasic::toCBuffer2(t.mod = %d)\n", t.mod);
        буф.пишиСтр(t.dstring);
    }

    проц visitTraits(TypeTraits t)
    {
        //printf("TypeBasic::toCBuffer2(t.mod = %d)\n", t.mod);
        t.exp.ВыражениеToBuffer(буф, hgs);
    }

    проц visitVector(TypeVector t)
    {
        //printf("TypeVector::toCBuffer2(t.mod = %d)\n", t.mod);
        буф.пишиСтр("__vector(");
        visitWithMask(t.basetype, t.mod, буф, hgs);
        буф.пишиСтр(")");
    }

    проц visitSArray(TypeSArray t)
    {
        visitWithMask(t.следщ, t.mod, буф, hgs);
        буф.пишиБайт('[');
        sizeToBuffer(t.dim, буф, hgs);
        буф.пишиБайт(']');
    }

    проц visitDArray(TypeDArray t)
    {
        Тип ut = t.castMod(0);
        if (hgs.declstring)
            goto L1;
        if (ut.равен(Тип.tstring))
            буф.пишиСтр("ткст");
        else if (ut.равен(Тип.twstring))
            буф.пишиСтр("wstring");
        else if (ut.равен(Тип.tdstring))
            буф.пишиСтр("dstring");
        else
        {
        L1:
            visitWithMask(t.следщ, t.mod, буф, hgs);
            буф.пишиСтр("[]");
        }
    }

    проц visitAArray(TypeAArray t)
    {
        visitWithMask(t.следщ, t.mod, буф, hgs);
        буф.пишиБайт('[');
        visitWithMask(t.index, 0, буф, hgs);
        буф.пишиБайт(']');
    }

    проц visitPointer(TypePointer t)
    {
        //printf("TypePointer::toCBuffer2() следщ = %d\n", t.следщ.ty);
        if (t.следщ.ty == Tfunction)
            visitFuncIdentWithPostfix(cast(TypeFunction)t.следщ, "function", буф, hgs);
        else
        {
            visitWithMask(t.следщ, t.mod, буф, hgs);
            буф.пишиБайт('*');
        }
    }

    проц visitReference(TypeReference t)
    {
        visitWithMask(t.следщ, t.mod, буф, hgs);
        буф.пишиБайт('&');
    }

    проц visitFunction(TypeFunction t)
    {
        //printf("TypeFunction::toCBuffer2() t = %p, ref = %d\n", t, t.isref);
        visitFuncIdentWithPostfix(t, null, буф, hgs);
    }

    проц visitDelegate(TypeDelegate t)
    {
        visitFuncIdentWithPostfix(cast(TypeFunction)t.следщ, "delegate", буф, hgs);
    }

    проц visitTypeQualifiedHelper(TypeQualified t)
    {
        foreach (ид; t.idents)
        {
            if (ид.динкаст() == ДИНКАСТ.дсимвол)
            {
                буф.пишиБайт('.');
                TemplateInstance ti = cast(TemplateInstance)ид;
                ti.dsymbolToBuffer(буф, hgs);
            }
            else if (ид.динкаст() == ДИНКАСТ.Выражение)
            {
                буф.пишиБайт('[');
                (cast(Выражение)ид).ВыражениеToBuffer(буф, hgs);
                буф.пишиБайт(']');
            }
            else if (ид.динкаст() == ДИНКАСТ.тип)
            {
                буф.пишиБайт('[');
                typeToBufferx(cast(Тип)ид, буф, hgs);
                буф.пишиБайт(']');
            }
            else
            {
                буф.пишиБайт('.');
                буф.пишиСтр(ид.вТкст());
            }
        }
    }

    проц visitIdentifier(TypeIdentifier t)
    {
        буф.пишиСтр(t.идент.вТкст());
        visitTypeQualifiedHelper(t);
    }

    проц visitInstance(TypeInstance t)
    {
        t.tempinst.dsymbolToBuffer(буф, hgs);
        visitTypeQualifiedHelper(t);
    }

    проц visitTypeof(TypeTypeof t)
    {
        буф.пишиСтр("typeof(");
        t.exp.ВыражениеToBuffer(буф, hgs);
        буф.пишиБайт(')');
        visitTypeQualifiedHelper(t);
    }

    проц visitReturn(TypeReturn t)
    {
        буф.пишиСтр("typeof(return)");
        visitTypeQualifiedHelper(t);
    }

    проц visitEnum(TypeEnum t)
    {
        буф.пишиСтр(hgs.fullQual ? t.sym.toPrettyChars() : t.sym.вТкст0());
    }

    проц visitStruct(TypeStruct t)
    {
        // https://issues.dlang.org/show_bug.cgi?ид=13776
        // Don't use ti.toAlias() to avoid forward reference error
        // while printing messages.
        TemplateInstance ti = t.sym.родитель ? t.sym.родитель.isTemplateInstance() : null;
        if (ti && ti.aliasdecl == t.sym)
            буф.пишиСтр(hgs.fullQual ? ti.toPrettyChars() : ti.вТкст0());
        else
            буф.пишиСтр(hgs.fullQual ? t.sym.toPrettyChars() : t.sym.вТкст0());
    }

    проц visitClass(TypeClass t)
    {
        // https://issues.dlang.org/show_bug.cgi?ид=13776
        // Don't use ti.toAlias() to avoid forward reference error
        // while printing messages.
        TemplateInstance ti = t.sym.родитель.isTemplateInstance();
        if (ti && ti.aliasdecl == t.sym)
            буф.пишиСтр(hgs.fullQual ? ti.toPrettyChars() : ti.вТкст0());
        else
            буф.пишиСтр(hgs.fullQual ? t.sym.toPrettyChars() : t.sym.вТкст0());
    }

    проц visitTuple(КортежТипов t)
    {
        parametersToBuffer(СписокПараметров(t.arguments, ВарАрг.none), буф, hgs);
    }

    проц visitSlice(TypeSlice t)
    {
        visitWithMask(t.следщ, t.mod, буф, hgs);
        буф.пишиБайт('[');
        sizeToBuffer(t.lwr, буф, hgs);
        буф.пишиСтр(" .. ");
        sizeToBuffer(t.upr, буф, hgs);
        буф.пишиБайт(']');
    }

    проц visitNull(TypeNull t)
    {
        буф.пишиСтр("typeof(null)");
    }

    проц visitMixin(TypeMixin t)
    {
        буф.пишиСтр("mixin(");
        argsToBuffer(t.exps, буф, hgs, null);
        буф.пишиБайт(')');
    }

    switch (t.ty)
    {
        default:        return t.isTypeBasic() ?
                                visitBasic(cast(TypeBasic)t) :
                                visitType(t);

        case Terror:     return visitError(cast(TypeError)t);
        case Ttraits:    return visitTraits(cast(TypeTraits)t);
        case Tvector:    return visitVector(cast(TypeVector)t);
        case Tsarray:    return visitSArray(cast(TypeSArray)t);
        case Tarray:     return visitDArray(cast(TypeDArray)t);
        case Taarray:    return visitAArray(cast(TypeAArray)t);
        case Tpointer:   return visitPointer(cast(TypePointer)t);
        case Treference: return visitReference(cast(TypeReference)t);
        case Tfunction:  return visitFunction(cast(TypeFunction)t);
        case Tdelegate:  return visitDelegate(cast(TypeDelegate)t);
        case Tident:     return visitIdentifier(cast(TypeIdentifier)t);
        case Tinstance:  return visitInstance(cast(TypeInstance)t);
        case Ttypeof:    return visitTypeof(cast(TypeTypeof)t);
        case Treturn:    return visitReturn(cast(TypeReturn)t);
        case Tenum:      return visitEnum(cast(TypeEnum)t);
        case Tstruct:    return visitStruct(cast(TypeStruct)t);
        case Tclass:     return visitClass(cast(TypeClass)t);
        case Ttuple:     return visitTuple (cast(КортежТипов)t);
        case Tslice:     return visitSlice(cast(TypeSlice)t);
        case Tnull:      return visitNull(cast(TypeNull)t);
        case Tmixin:     return visitMixin(cast(TypeMixin)t);
    }
}
