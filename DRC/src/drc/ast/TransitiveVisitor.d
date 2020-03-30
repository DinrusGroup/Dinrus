/**
 * Documentation:  https://dlang.org/phobos/dmd_transitivevisitor.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/transitivevisitor.d
 */

module drc.ast.TransitiveVisitor;

import drc.ast.PermissiveVisitor;
import drc.lexer.Tokens;
import drc.ast.Node;

import cidrus;

/** Визитор2 that implements the AST traversal logic. The nodes just прими their children.
  */
class ParseTimeTransitiveVisitor(AST) : PermissiveVisitor!(AST)
{
    alias PermissiveVisitor!(AST).посети посети;
    mixin ParseVisitMethods!(AST);
}

/* This mixin implements the AST traversal logic for parse time AST nodes. The same code
 * is используется for semantic time AST узел traversal, so in order to not duplicate the code,
 * the template mixin is используется.
 */
//package mixin
template ParseVisitMethods(AST)
{

//   Инструкция2 Nodes
//===========================================================
    override проц посети(AST.ExpStatement s)
    {
        //printf("Visiting ExpStatement\n");
        if (s.exp && s.exp.op == ТОК2.declaration)
        {
            (cast(AST.DeclarationExp)s.exp).declaration.прими(this);
            return;
        }
        if (s.exp)
            s.exp.прими(this);
    }

    override проц посети(AST.CompileStatement s)
    {
        //printf("Visiting CompileStatement\n");
        visitArgs(s.exps);
    }

    override проц посети(AST.CompoundStatement s)
    {
        //printf("Visiting CompoundStatement\n");
        foreach (sx; *s.statements)
        {
            if (sx)
                sx.прими(this);
        }
    }

    проц visitVarDecl(AST.VarDeclaration v)
    {
        //printf("Visiting VarDeclaration\n");
        if (v.тип)
            visitType(v.тип);
        if (v._иниц)
        {
            auto ie = v._иниц.isExpInitializer();
            if (ie && (ie.exp.op == ТОК2.construct || ie.exp.op == ТОК2.blit))
                (cast(AST.AssignExp)ie.exp).e2.прими(this);
            else
                v._иниц.прими(this);
        }
    }

    override проц посети(AST.CompoundDeclarationStatement s)
    {
        //printf("Visiting CompoundDeclarationStatement\n");
        foreach (sx; *s.statements)
        {
            auto ds = sx ? sx.isExpStatement() : null;
            if (ds && ds.exp.op == ТОК2.declaration)
            {
                auto d = (cast(AST.DeclarationExp)ds.exp).declaration;
                assert(d.isDeclaration());
                if (auto v = d.isVarDeclaration())
                    visitVarDecl(v);
                else
                    d.прими(this);
            }
        }
    }

    override проц посети(AST.ScopeStatement s)
    {
        //printf("Visiting ScopeStatement\n");
        if (s.инструкция)
            s.инструкция.прими(this);
    }

    override проц посети(AST.WhileStatement s)
    {
        //printf("Visiting WhileStatement\n");
        s.условие.прими(this);
        if (s._body)
            s._body.прими(this);
    }

    override проц посети(AST.DoStatement s)
    {
        //printf("Visiting DoStatement\n");
        if (s._body)
            s._body.прими(this);
        s.условие.прими(this);
    }

    override проц посети(AST.ForStatement s)
    {
        //printf("Visiting ForStatement\n");
        if (s._иниц)
            s._иниц.прими(this);
        if (s.условие)
            s.условие.прими(this);
        if (s.increment)
            s.increment.прими(this);
        if (s._body)
            s._body.прими(this);
    }

    override проц посети(AST.ForeachStatement s)
    {
        //printf("Visiting ForeachStatement\n");
        foreach (p; *s.parameters)
            if (p.тип)
                visitType(p.тип);
        s.aggr.прими(this);
        if (s._body)
            s._body.прими(this);
    }

    override проц посети(AST.ForeachRangeStatement s)
    {
        //printf("Visiting ForeachRangeStatement\n");
        if (s.prm.тип)
            visitType(s.prm.тип);
        s.lwr.прими(this);
        s.upr.прими(this);
        if (s._body)
            s._body.прими(this);
    }

    override проц посети(AST.IfStatement s)
    {
        //printf("Visiting IfStatement\n");
        if (s.prm && s.prm.тип)
            visitType(s.prm.тип);
        s.условие.прими(this);
        s.ifbody.прими(this);
        if (s.elsebody)
            s.elsebody.прими(this);
    }

    override проц посети(AST.ConditionalStatement s)
    {
        //printf("Visiting ConditionalStatement\n");
        s.условие.прими(this);
        if (s.ifbody)
            s.ifbody.прими(this);
        if (s.elsebody)
            s.elsebody.прими(this);
    }

    проц visitArgs(AST.Выражения* Выражения, AST.Выражение basis = null)
    {
        if (!Выражения || !Выражения.dim)
            return;
        foreach (el; *Выражения)
        {
            if (!el)
                el = basis;
            if (el)
                el.прими(this);
        }
    }

    override проц посети(AST.PragmaStatement s)
    {
        //printf("Visiting PragmaStatement\n");
        if (s.args && s.args.dim)
            visitArgs(s.args);
        if (s._body)
            s._body.прими(this);
    }

    override проц посети(AST.StaticAssertStatement s)
    {
        //printf("Visiting StaticAssertStatement\n");
        s.sa.прими(this);
    }

    override проц посети(AST.SwitchStatement s)
    {
        //printf("Visiting SwitchStatement\n");
        s.условие.прими(this);
        if (s._body)
            s._body.прими(this);
    }

    override проц посети(AST.CaseStatement s)
    {
        //printf("Visiting CaseStatement\n");
        s.exp.прими(this);
        s.инструкция.прими(this);
    }

    override проц посети(AST.CaseRangeStatement s)
    {
        //printf("Visiting CaseRangeStatement\n");
        s.first.прими(this);
        s.last.прими(this);
        s.инструкция.прими(this);
    }

    override проц посети(AST.DefaultStatement s)
    {
        //printf("Visiting DefaultStatement\n");
        s.инструкция.прими(this);
    }

    override проц посети(AST.GotoCaseStatement s)
    {
        //printf("Visiting GotoCaseStatement\n");
        if (s.exp)
            s.exp.прими(this);
    }

    override проц посети(AST.ReturnStatement s)
    {
        //printf("Visiting ReturnStatement\n");
        if (s.exp)
            s.exp.прими(this);
    }

    override проц посети(AST.SynchronizedStatement s)
    {
        //printf("Visiting SynchronizedStatement\n");
        if (s.exp)
            s.exp.прими(this);
        if (s._body)
            s._body.прими(this);
    }

    override проц посети(AST.WithStatement s)
    {
        //printf("Visiting WithStatement\n");
        s.exp.прими(this);
        if (s._body)
            s._body.прими(this);
    }

    override проц посети(AST.TryCatchStatement s)
    {
        //printf("Visiting TryCatchStatement\n");
        if (s._body)
            s._body.прими(this);
        foreach (c; *s.catches)
            посети(c);
    }

    override проц посети(AST.TryFinallyStatement s)
    {
        //printf("Visiting TryFinallyStatement\n");
        s._body.прими(this);
        s.finalbody.прими(this);
    }

    override проц посети(AST.ScopeGuardStatement s)
    {
        //printf("Visiting ScopeGuardStatement\n");
        s.инструкция.прими(this);
    }

    override проц посети(AST.ThrowStatement s)
    {
        //printf("Visiting ThrowStatement\n");
        s.exp.прими(this);
    }

    override проц посети(AST.LabelStatement s)
    {
        //printf("Visiting LabelStatement\n");
        if (s.инструкция)
            s.инструкция.прими(this);
    }

    override проц посети(AST.ImportStatement s)
    {
        //printf("Visiting ImportStatement\n");
        foreach (imp; *s.imports)
            imp.прими(this);
    }

    проц посети(AST.Уловитель c)
    {
        //printf("Visiting Уловитель\n");
        if (c.тип)
            visitType(c.тип);
        if (c.handler)
            c.handler.прими(this);
    }

//   Тип Nodes
//============================================================

    проц visitType(AST.Тип t)
    {
        //printf("Visiting Тип\n");
        if (!t)
            return;
        if (t.ty == AST.Tfunction)
        {
            visitFunctionType(cast(AST.TypeFunction)t, null);
            return;
        }
        else
            t.прими(this);
    }

    проц visitFunctionType(AST.TypeFunction t, AST.TemplateDeclaration td)
    {
        if (t.следщ)
            visitType(t.следщ);
        if (td)
        {
            foreach (p; *td.origParameters)
                p.прими(this);
        }
        visitParameters(t.parameterList.parameters);
    }

    проц visitParameters(AST.Параметры* parameters)
    {
        if (parameters)
        {
            т_мера dim = AST.Параметр2.dim(parameters);
            foreach(i; new бцел[0..dim])
            {
                AST.Параметр2 fparam = AST.Параметр2.getNth(parameters, i);
                fparam.прими(this);
            }
        }
    }

    override проц посети(AST.TypeVector t)
    {
        //printf("Visiting TypeVector\n");
        if (!t.basetype)
            return;
        t.basetype.прими(this);
    }

    override проц посети(AST.TypeSArray t)
    {
        //printf("Visiting TypeSArray\n");
        t.следщ.прими(this);
    }

    override проц посети(AST.TypeDArray t)
    {
        //printf("Visiting TypeDArray\n");
        t.следщ.прими(this);
    }

    override проц посети(AST.TypeAArray t)
    {
        //printf("Visiting TypeAArray\n");
        t.следщ.прими(this);
        t.index.прими(this);
    }

    override проц посети(AST.TypePointer t)
    {
        //printf("Visiting TypePointer\n");
        if (t.следщ.ty == AST.Tfunction)
        {
            visitFunctionType(cast(AST.TypeFunction)t.следщ, null);
        }
        else
            t.следщ.прими(this);
    }

    override проц посети(AST.TypeReference t)
    {
        //printf("Visiting TypeReference\n");
        t.следщ.прими(this);
    }

    override проц посети(AST.TypeFunction t)
    {
        //printf("Visiting TypeFunction\n");
        visitFunctionType(t, null);
    }

    override проц посети(AST.TypeDelegate t)
    {
        //printf("Visiting TypeDelegate\n");
        visitFunctionType(cast(AST.TypeFunction)t.следщ, null);
    }

    проц visitTypeQualified(AST.TypeQualified t)
    {
        //printf("Visiting TypeQualified\n");
        foreach (ид; t.idents)
        {
            if (ид.динкаст() == ДИНКАСТ.дсимвол)
                (cast(AST.TemplateInstance)ид).прими(this);
            else if (ид.динкаст() == ДИНКАСТ.Выражение)
                (cast(AST.Выражение)ид).прими(this);
            else if (ид.динкаст() == ДИНКАСТ.тип)
                (cast(AST.Тип)ид).прими(this);
        }
    }

    override проц посети(AST.TypeIdentifier t)
    {
        //printf("Visiting TypeIdentifier\n");
        visitTypeQualified(t);
    }

    override проц посети(AST.TypeInstance t)
    {
        //printf("Visiting TypeInstance\n");
        t.tempinst.прими(this);
        visitTypeQualified(t);
    }

    override проц посети(AST.TypeTypeof t)
    {
        //printf("Visiting TypeTypeof\n");
        t.exp.прими(this);
        visitTypeQualified(t);
    }

    override проц посети(AST.TypeReturn t)
    {
        //printf("Visiting TypeReturn\n");
        visitTypeQualified(t);
    }

    override проц посети(AST.КортежТипов t)
    {
        //printf("Visiting КортежТипов\n");
        visitParameters(t.arguments);
    }

    override проц посети(AST.TypeSlice t)
    {
        //printf("Visiting TypeSlice\n");
        t.следщ.прими(this);
        t.lwr.прими(this);
        t.upr.прими(this);
    }

    override проц посети(AST.TypeTraits t)
    {
        t.exp.прими(this);
    }

//      Miscellaneous
//========================================================

    override проц посети(AST.StaticAssert s)
    {
        //printf("Visiting StaticAssert\n");
        s.exp.прими(this);
        if (s.msg)
            s.msg.прими(this);
    }

    override проц посети(AST.EnumMember em)
    {
        //printf("Visiting EnumMember\n");
        if (em.тип)
            visitType(em.тип);
        if (em.значение)
            em.значение.прими(this);
    }

//      Declarations
//=========================================================
    проц visitAttribDeclaration(AST.AttribDeclaration d)
    {
        if (d.decl)
            foreach (de; *d.decl)
                de.прими(this);
    }

    override проц посети(AST.AttribDeclaration d)
    {
        //printf("Visiting AttribDeclaration\n");
        visitAttribDeclaration(d);
    }

    override проц посети(AST.StorageClassDeclaration d)
    {
        //printf("Visiting StorageClassDeclaration\n");
        visitAttribDeclaration(cast(AST.AttribDeclaration)d);
    }

    override проц посети(AST.DeprecatedDeclaration d)
    {
        //printf("Visiting DeprecatedDeclaration\n");
        d.msg.прими(this);
        visitAttribDeclaration(cast(AST.AttribDeclaration)d);
    }

    override проц посети(AST.LinkDeclaration d)
    {
        //printf("Visiting LinkDeclaration\n");
        visitAttribDeclaration(cast(AST.AttribDeclaration)d);
    }

    override проц посети(AST.CPPMangleDeclaration d)
    {
        //printf("Visiting CPPMangleDeclaration\n");
        visitAttribDeclaration(cast(AST.AttribDeclaration)d);
    }

    override проц посети(AST.ProtDeclaration d)
    {
        //printf("Visiting ProtDeclaration\n");
        visitAttribDeclaration(cast(AST.AttribDeclaration)d);
    }

    override проц посети(AST.AlignDeclaration d)
    {
        //printf("Visiting AlignDeclaration\n");
        visitAttribDeclaration(cast(AST.AttribDeclaration)d);
    }

    override проц посети(AST.AnonDeclaration d)
    {
        //printf("Visiting AnonDeclaration\n");
        visitAttribDeclaration(cast(AST.AttribDeclaration)d);
    }

    override проц посети(AST.PragmaDeclaration d)
    {
        //printf("Visiting PragmaDeclaration\n");
        if (d.args && d.args.dim)
            visitArgs(d.args);
        visitAttribDeclaration(cast(AST.AttribDeclaration)d);
    }

    override проц посети(AST.ConditionalDeclaration d)
    {
        //printf("Visiting ConditionalDeclaration\n");
        d.условие.прими(this);
        if (d.decl)
            foreach (de; *d.decl)
                de.прими(this);
        if (d.elsedecl)
            foreach (de; *d.elsedecl)
                de.прими(this);
    }

    override проц посети(AST.CompileDeclaration d)
    {
        //printf("Visiting compileDeclaration\n");
        visitArgs(d.exps);
    }

    override проц посети(AST.UserAttributeDeclaration d)
    {
        //printf("Visiting UserAttributeDeclaration\n");
        visitArgs(d.atts);
        visitAttribDeclaration(cast(AST.AttribDeclaration)d);
    }

    проц visitFuncBody(AST.FuncDeclaration f)
    {
        //printf("Visiting funcBody\n");
        if (f.frequires)
        {
            foreach (frequire; *f.frequires)
            {
                frequire.прими(this);
            }
        }
        if (f.fensures)
        {
            foreach (fensure; *f.fensures)
            {
                fensure.ensure.прими(this);
            }
        }
        if (f.fbody)
        {
            f.fbody.прими(this);
        }
    }

    проц visitBaseClasses(AST.ClassDeclaration d)
    {
        //printf("Visiting ClassDeclaration\n");
        if (!d || !d.baseclasses.dim)
            return;
        foreach (b; *d.baseclasses)
            visitType(b.тип);
    }

    бул visitEponymousMember(AST.TemplateDeclaration d)
    {
        //printf("Visiting EponymousMember\n");
        if (!d.члены || d.члены.dim != 1)
            return нет;
        AST.ДСимвол onemember = (*d.члены)[0];
        if (onemember.идент != d.идент)
            return нет;

        if (AST.FuncDeclaration fd = onemember.isFuncDeclaration())
        {
            assert(fd.тип);
            visitFunctionType(cast(AST.TypeFunction)fd.тип, d);
            if (d.constraint)
                d.constraint.прими(this);
            visitFuncBody(fd);

            return да;
        }

        if (AST.AggregateDeclaration ad = onemember.isAggregateDeclaration())
        {
            visitTemplateParameters(d.parameters);
            if (d.constraint)
                d.constraint.прими(this);
            visitBaseClasses(ad.isClassDeclaration());

            if (ad.члены)
                foreach (s; *ad.члены)
                    s.прими(this);

            return да;
        }

        if (AST.VarDeclaration vd = onemember.isVarDeclaration())
        {
            if (d.constraint)
                return нет;
            if (vd.тип)
                visitType(vd.тип);
            visitTemplateParameters(d.parameters);
            if (vd._иниц)
            {
                AST.ExpInitializer ie = vd._иниц.isExpInitializer();
                if (ie && (ie.exp.op == ТОК2.construct || ie.exp.op == ТОК2.blit))
                    (cast(AST.AssignExp)ie.exp).e2.прими(this);
                else
                    vd._иниц.прими(this);

                return да;
            }
        }

        return нет;
    }

    проц visitTemplateParameters(AST.ПараметрыШаблона* parameters)
    {
        if (!parameters || !parameters.dim)
            return;
        foreach (p; *parameters)
            p.прими(this);
    }

    override проц посети(AST.TemplateDeclaration d)
    {
        //printf("Visiting TemplateDeclaration\n");
        if (visitEponymousMember(d))
            return;

        visitTemplateParameters(d.parameters);
        if (d.constraint)
            d.constraint.прими(this);

        foreach (s; *d.члены)
            s.прими(this);
    }

    проц visitObject(КорневойОбъект oarg)
    {
        if (auto t = AST.тип_ли(oarg))
        {
            visitType(t);
        }
        else if (auto e = AST.выражение_ли(oarg))
        {
            e.прими(this);
        }
        else if (auto v = AST.кортеж_ли(oarg))
        {
            auto args = &v.objects;
            foreach (arg; *args)
                visitObject(arg);
        }
    }

    проц visitTiargs(AST.TemplateInstance ti)
    {
        //printf("Visiting tiargs\n");
        if (!ti.tiargs)
            return;
        foreach (arg; *ti.tiargs)
        {
            visitObject(arg);
        }
    }

    override проц посети(AST.TemplateInstance ti)
    {
        //printf("Visiting TemplateInstance\n");
        visitTiargs(ti);
    }

    override проц посети(AST.TemplateMixin tm)
    {
        //printf("Visiting TemplateMixin\n");
        visitType(tm.tqual);
        visitTiargs(tm);
    }

    override проц посети(AST.EnumDeclaration d)
    {
        //printf("Visiting EnumDeclaration\n");
        if (d.memtype)
            visitType(d.memtype);
        if (!d.члены)
            return;
        foreach (em; *d.члены)
        {
            if (!em)
                continue;
            em.прими(this);
        }
    }

    override проц посети(AST.Nspace d)
    {
        //printf("Visiting Nspace\n");
        foreach(s; *d.члены)
            s.прими(this);
    }

    override проц посети(AST.StructDeclaration d)
    {
        //printf("Visiting StructDeclaration\n");
        if (!d.члены)
            return;
        foreach (s; *d.члены)
            s.прими(this);
    }

    override проц посети(AST.ClassDeclaration d)
    {
        //printf("Visiting ClassDeclaration\n");
        visitBaseClasses(d);
        if (d.члены)
            foreach (s; *d.члены)
                s.прими(this);
    }

    override проц посети(AST.AliasDeclaration d)
    {
        //printf("Visting AliasDeclaration\n");
        if (d.aliassym)
            d.aliassym.прими(this);
        else
            visitType(d.тип);
    }

    override проц посети(AST.VarDeclaration d)
    {
        //printf("Visiting VarDeclaration\n");
        visitVarDecl(d);
    }

    override проц посети(AST.FuncDeclaration f)
    {
        //printf("Visiting FuncDeclaration\n");
        auto tf = cast(AST.TypeFunction)f.тип;
        visitType(tf);
        visitFuncBody(f);
    }

    override проц посети(AST.FuncLiteralDeclaration f)
    {
        //printf("Visiting FuncLiteralDeclaration\n");
        if (f.тип.ty == AST.Terror)
            return;
        AST.TypeFunction tf = cast(AST.TypeFunction)f.тип;
        if (!f.inferRetType && tf.следщ)
            visitType(tf.следщ);
        visitParameters(tf.parameterList.parameters);
        AST.CompoundStatement cs = f.fbody.isCompoundStatement();
        AST.Инструкция2 s = !cs ? f.fbody : null;
        AST.ReturnStatement rs = s ? s.isReturnStatement() : null;
        if (rs && rs.exp)
            rs.exp.прими(this);
        else
            visitFuncBody(f);
    }

    override проц посети(AST.PostBlitDeclaration d)
    {
        //printf("Visiting PostBlitDeclaration\n");
        visitFuncBody(d);
    }

    override проц посети(AST.DtorDeclaration d)
    {
        //printf("Visiting DtorDeclaration\n");
        visitFuncBody(d);
    }

    override проц посети(AST.StaticCtorDeclaration d)
    {
        //printf("Visiting StaticCtorDeclaration\n");
        visitFuncBody(d);
    }

    override проц посети(AST.StaticDtorDeclaration d)
    {
        //printf("Visiting StaticDtorDeclaration\n");
        visitFuncBody(d);
    }

    override проц посети(AST.InvariantDeclaration d)
    {
        //printf("Visiting InvariantDeclaration\n");
        visitFuncBody(d);
    }

    override проц посети(AST.UnitTestDeclaration d)
    {
        //printf("Visiting UnitTestDeclaration\n");
        visitFuncBody(d);
    }

    override проц посети(AST.NewDeclaration d)
    {
        //printf("Visiting NewDeclaration\n");
        visitParameters(d.parameters);
        visitFuncBody(d);
    }

//   Инициализаторы
//============================================================

    override проц посети(AST.StructInitializer si)
    {
        //printf("Visiting StructInitializer\n");
        foreach (i, ид; si.field)
            if (auto iz = si.значение[i])
                iz.прими(this);
    }

    override проц посети(AST.ArrayInitializer ai)
    {
        //printf("Visiting ArrayInitializer\n");
        foreach (i, ex; ai.index)
        {
            if (ex)
                ex.прими(this);
            if (auto iz = ai.значение[i])
                iz.прими(this);
        }
    }

    override проц посети(AST.ExpInitializer ei)
    {
        //printf("Visiting ExpInitializer\n");
        ei.exp.прими(this);
    }

//      Выражения
//===================================================

    override проц посети(AST.ArrayLiteralExp e)
    {
        //printf("Visiting ArrayLiteralExp\n");
        visitArgs(e.elements, e.basis);
    }

    override проц посети(AST.AssocArrayLiteralExp e)
    {
        //printf("Visiting AssocArrayLiteralExp\n");
        foreach (i, ключ; *e.keys)
        {
            ключ.прими(this);
            ((*e.values)[i]).прими(this);
        }
    }

    override проц посети(AST.TypeExp e)
    {
        //printf("Visiting TypeExp\n");
        visitType(e.тип);
    }

    override проц посети(AST.ScopeExp e)
    {
        //printf("Visiting ScopeExp\n");
        if (e.sds.isTemplateInstance())
            e.sds.прими(this);
    }

    override проц посети(AST.NewExp e)
    {
        //printf("Visiting NewExp\n");
        if (e.thisexp)
            e.thisexp.прими(this);
        if (e.newargs && e.newargs.dim)
            visitArgs(e.newargs);
        visitType(e.newtype);
        if (e.arguments && e.arguments.dim)
            visitArgs(e.arguments);
    }

    override проц посети(AST.NewAnonClassExp e)
    {
        //printf("Visiting NewAnonClassExp\n");
        if (e.thisexp)
            e.thisexp.прими(this);
        if (e.newargs && e.newargs.dim)
            visitArgs(e.newargs);
        if (e.arguments && e.arguments.dim)
            visitArgs(e.arguments);
        if (e.cd)
            e.cd.прими(this);
    }

    override проц посети(AST.TupleExp e)
    {
        //printf("Visiting TupleExp\n");
        if (e.e0)
            e.e0.прими(this);
        visitArgs(e.exps);
    }

    override проц посети(AST.FuncExp e)
    {
        //printf("Visiting FuncExp\n");
        e.fd.прими(this);
    }

    override проц посети(AST.DeclarationExp e)
    {
        //printf("Visiting DeclarationExp\n");
        if (auto v = e.declaration.isVarDeclaration())
            visitVarDecl(v);
        else
            e.declaration.прими(this);
    }

    override проц посети(AST.TypeidExp e)
    {
        //printf("Visiting TypeidExp\n");
        visitObject(e.obj);
    }

    override проц посети(AST.TraitsExp e)
    {
        //printf("Visiting TraitExp\n");
        if (e.args)
            foreach (arg; *e.args)
                visitObject(arg);
    }

    override проц посети(AST.IsExp e)
    {
        //printf("Visiting IsExp\n");
        visitType(e.targ);
        if (e.tspec)
            visitType(e.tspec);
        if (e.parameters && e.parameters.dim)
            visitTemplateParameters(e.parameters);
    }

    override проц посети(AST.UnaExp e)
    {
        //printf("Visiting UnaExp\n");
        e.e1.прими(this);
    }

    override проц посети(AST.BinExp e)
    {
        //printf("Visiting BinExp\n");
        e.e1.прими(this);
        e.e2.прими(this);
    }

    override проц посети(AST.CompileExp e)
    {
        //printf("Visiting CompileExp\n");
        visitArgs(e.exps);
    }

    override проц посети(AST.ImportExp e)
    {
        //printf("Visiting ImportExp\n");
        e.e1.прими(this);
    }

    override проц посети(AST.AssertExp e)
    {
        //printf("Visiting AssertExp\n");
        e.e1.прими(this);
        if (e.msg)
            e.msg.прими(this);
    }

    override проц посети(AST.DotIdExp e)
    {
        //printf("Visiting DotIdExp\n");
        e.e1.прими(this);
    }

    override проц посети(AST.DotTemplateInstanceExp e)
    {
        //printf("Visiting DotTemplateInstanceExp\n");
        e.e1.прими(this);
        e.ti.прими(this);
    }

    override проц посети(AST.CallExp e)
    {
        //printf("Visiting CallExp\n");
        e.e1.прими(this);
        visitArgs(e.arguments);
    }

    override проц посети(AST.PtrExp e)
    {
        //printf("Visiting PtrExp\n");
        e.e1.прими(this);
    }

    override проц посети(AST.DeleteExp e)
    {
        //printf("Visiting DeleteExp\n");
        e.e1.прими(this);
    }

    override проц посети(AST.CastExp e)
    {
        //printf("Visiting CastExp\n");
        if (e.to)
            visitType(e.to);
        e.e1.прими(this);
    }

    override проц посети(AST.IntervalExp e)
    {
        //printf("Visiting IntervalExp\n");
        e.lwr.прими(this);
        e.upr.прими(this);
    }

    override проц посети(AST.ArrayExp e)
    {
        //printf("Visiting ArrayExp\n");
        e.e1.прими(this);
        visitArgs(e.arguments);
    }

    override проц посети(AST.PostExp e)
    {
        //printf("Visiting PostExp\n");
        e.e1.прими(this);
    }

    override проц посети(AST.CondExp e)
    {
        //printf("Visiting CondExp\n");
        e.econd.прими(this);
        e.e1.прими(this);
        e.e2.прими(this);
    }

// Template Параметр2
//===========================================================

    override проц посети(AST.TemplateTypeParameter tp)
    {
        //printf("Visiting TemplateTypeParameter\n");
        if (tp.specType)
            visitType(tp.specType);
        if (tp.defaultType)
            visitType(tp.defaultType);
    }

    override проц посети(AST.TemplateThisParameter tp)
    {
        //printf("Visiting TemplateThisParameter\n");
        посети(cast(AST.TemplateTypeParameter)tp);
    }

    override проц посети(AST.TemplateAliasParameter tp)
    {
        //printf("Visiting TemplateAliasParameter\n");
        if (tp.specType)
            visitType(tp.specType);
        if (tp.specAlias)
            visitObject(tp.specAlias);
        if (tp.defaultAlias)
            visitObject(tp.defaultAlias);
    }

    override проц посети(AST.TemplateValueParameter tp)
    {
        //printf("Visiting TemplateValueParameter\n");
        visitType(tp.valType);
        if (tp.specValue)
            tp.specValue.прими(this);
        if (tp.defaultValue)
            tp.defaultValue.прими(this);
    }

//===========================================================

    override проц посети(AST.StaticIfCondition c)
    {
        //printf("Visiting StaticIfCondition\n");
        c.exp.прими(this);
    }

    override проц посети(AST.Параметр2 p)
    {
        //printf("Visiting Параметр2\n");
        visitType(p.тип);
        if (p.defaultArg)
            p.defaultArg.прими(this);
    }

    override проц посети(AST.Module m)
    {
        //printf("Visiting Module\n");
        foreach (s; *m.члены)
        {
           s.прими(this);
        }
    }
}
