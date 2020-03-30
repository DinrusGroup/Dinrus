/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * This module содержит the implementation of the C++ header generation доступно through
 * the command line switch -Hc.
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/dtohd, _dtoh.d)
 * Documentation:  https://dlang.org/phobos/dmd_dtoh.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/dtoh.d
 */
module drc.code.dtoh;

import cidrus;

import drc.ast.AstCodegen;
import dmd.arraytypes;
import dmd.globals;
import drc.lexer.Identifier;
import util.filename;
import drc.ast.Visitor;
import drc.lexer.Tokens;

import util.outbuffer;
import util.utils;
import AST = dmd.mtype;
import util.string : вТкстД;

//debug = Debug_DtoH;
const isBuildingCompiler = нет;

private struct DMDType
{
     Идентификатор2 c_long;
     Идентификатор2 c_ulong;
     Идентификатор2 c_longlong;
     Идентификатор2 c_ulonglong;
     Идентификатор2 c_long_double;
     Идентификатор2 c_wchar_t;
     Идентификатор2 AssocArray;
     Идентификатор2 МассивДРК;

    static проц _иниц()
    {
        c_long          = Идентификатор2.idPool("__c_long");
        c_ulong         = Идентификатор2.idPool("__c_ulong");
        c_longlong      = Идентификатор2.idPool("__c_longlong");
        c_ulonglong     = Идентификатор2.idPool("__c_ulonglong");
        c_long_double   = Идентификатор2.idPool("__c_long_double");
        c_wchar_t       = Идентификатор2.idPool("__c_wchar_t");

        if (isBuildingCompiler)
        {
            AssocArray      = Идентификатор2.idPool("AssocArray");
            МассивДРК           = Идентификатор2.idPool("МассивДРК");
        }

    }
}

private struct DMDModule
{
     Идентификатор2 идентификатор;
     Идентификатор2 root;
     Идентификатор2 visitor;
     Идентификатор2 parsetimevisitor;
     Идентификатор2 permissivevisitor;
     Идентификатор2 strictvisitor;
     Идентификатор2 transitivevisitor;
     Идентификатор2 dmd;
    static проц _иниц()
    {
        идентификатор          = Идентификатор2.idPool("идентификатор");
        root                = Идентификатор2.idPool("root");
        visitor             = Идентификатор2.idPool("visitor");
        parsetimevisitor    = Идентификатор2.idPool("parsetimevisitor");
        permissivevisitor   = Идентификатор2.idPool("permissivevisitor");
        strictvisitor       = Идентификатор2.idPool("strictvisitor");
        transitivevisitor   = Идентификатор2.idPool("transitivevisitor");
        dmd                 = Идентификатор2.idPool("dmd");
    }
}

private struct DMDClass
{
     Идентификатор2 ID; ////Идентификатор2
     Идентификатор2 Визитор2;
     Идентификатор2 ВизиторВремениРазбора;
    static проц _иниц()
    {
        ID                  = Идентификатор2.idPool("Идентификатор2");
        Визитор2             = Идентификатор2.idPool("Визитор2");
        ВизиторВремениРазбора    = Идентификатор2.idPool("ВизиторВремениРазбора");
    }

}

private бул isIdentifierClass(ASTCodegen.ClassDeclaration cd)
{
    return (cd.идент == DMDClass.ID &&
            cd.родитель !is null &&
            cd.родитель.идент == DMDModule.идентификатор &&
            cd.родитель.родитель && cd.родитель.родитель.идент == DMDModule.dmd &&
            !cd.родитель.родитель.родитель);
}

private бул isVisitorClass(ASTCodegen.ClassDeclaration cd)
{
    for (auto cdb = cd; cdb; cdb = cdb.baseClass)
    {
        if (cdb.идент == DMDClass.Визитор2 ||
            cdb.идент == DMDClass.ВизиторВремениРазбора)
        return да;
    }
    return нет;
}

private бул isIgnoredModule(ASTCodegen.Module m)
{
    if (!m)
        return да;

    // Ignore dmd.root
    if (m.родитель && m.родитель.идент == DMDModule.root &&
        m.родитель.родитель && m.родитель.родитель.идент == DMDModule.dmd &&
        !m.родитель.родитель.родитель)
    {
        return да;
    }

    // Ignore dmd.visitor and derivatives
    if ((m.идент == DMDModule.visitor ||
            m.идент == DMDModule.parsetimevisitor ||
            m.идент == DMDModule.permissivevisitor ||
            m.идент == DMDModule.strictvisitor ||
            m.идент == DMDModule.transitivevisitor) &&
            m.родитель && m.родитель.идент == DMDModule.dmd &&
            !m.родитель.родитель)
    {
        return да;
    }
    return нет;
}

private бул isFrontendModule(ASTCodegen.Module m)
{
    if (!m || !m.родитель)
        return нет;

    // Ignore dmd.root
    if (m.родитель.идент == DMDModule.root &&
        m.родитель.родитель && m.родитель.родитель.идент == DMDModule.dmd &&
        !m.родитель.родитель.родитель)
    {
        return нет;
    }

    // Ignore dmd.visitor and derivatives
    if ((m.идент == DMDModule.visitor ||
            m.идент == DMDModule.parsetimevisitor ||
            m.идент == DMDModule.permissivevisitor ||
            m.идент == DMDModule.strictvisitor ||
            m.идент == DMDModule.transitivevisitor) &&
            m.родитель && m.родитель.идент == DMDModule.dmd &&
            !m.родитель.родитель)
    {
        return нет;
    }
    return ((m.родитель.идент == DMDModule.dmd && !m.родитель.родитель) ||
            (m.родитель.родитель.идент == DMDModule.dmd && !m.родитель.родитель.родитель));
}

private ткст translateBasicType(ббайт ty)
{

    switch (ty)
    {
        case AST.Tvoid:     return "проц";
        case AST.Tbool:     return "бул";
        case AST.Tchar:     return "сим";
        case AST.Twchar:    return "char16_t";
        case AST.Tdchar:    return "char32_t";
        case AST.Tint8:     return "int8_t";
        case AST.Tuns8:     return "uint8_t";
        case AST.Tint16:    return "int16_t";
        case AST.Tuns16:    return "uint16_t";
        case AST.Tint32:    return "int32_t";
        case AST.Tuns32:    return "uint32_t";
        case AST.Tint64:    return "int64_t";
        case AST.Tuns64:    return "uint64_t";
        case AST.Tfloat32:  return "float";
        case AST.Tfloat64:  return "double";
        case AST.Tfloat80:  return "_d_real";
        default:
            //t.print();
            assert(0);
    }
}

private проц initialize()
{
     бул initialized;

    if (!initialized)
    {
        initialized = да;

        DMDType._иниц();
        if (isBuildingCompiler)
        {
            DMDModule._иниц();
            DMDClass._иниц();
        }
    }
}

/*extern(C++)*/ проц genCppHdrFiles(ref Modules ms)
{
    initialize();

    БуфВыв буф;
    буф.printf("// Automatically generated by %s Compiler v%d\n", глоб2.vendor.ptr, глоб2.versionNumber());
    буф.пишиБайт('\n');
    буф.пишиСтр("#pragma once\n");
    буф.пишиБайт('\n');
    буф.пишиСтр("#include <assert.h>\n");
    буф.пишиСтр("#include <stddef.h>\n");
    буф.пишиСтр("#include <stdint.h>\n");
    буф.пишиСтр("#include <stdio.h>\n");
    буф.пишиСтр("#include <ткст.h>\n");
    буф.пишиБайт('\n');
    буф.пишиСтр("#if !defined(_d_real)\n");
    буф.пишиСтр("# define _d_real long double\n");
    буф.пишиСтр("#endif\n");
    буф.пишиСтр("\n\n");

    БуфВыв check;
    БуфВыв done;
    БуфВыв decl;
    scope v = new ToCppBuffer!(ASTCodegen)(&check, &буф, &done, &decl);
    foreach (m; ms)
    {
        //printf("// Parsing module %s\n", m.toPrettyChars());
        буф.printf("// Parsing module %s\n", m.toPrettyChars());
        m.прими(v);
    }
    буф.пиши(&done);
    буф.пиши(&decl);
    //printf("%s\n", decl.peekSlice().ptr);


    debug (Debug_DtoH)
    {
        буф.пишиСтр(`
#if OFFSETS
    template <class T>
    т_мера getSlotNumber(цел dummy, ...)
    {
        T c;
        va_list ap;
        va_start(ap, dummy);
        проц *f = va_arg(ap, ук);
        for (т_мера i = 0; ; i++)
        {
            if ( (*(ук**)&c)[i] == f)
            return i;
        }
        va_end(ap);
    }

    проц testOffsets()
    {
`);
        буф.пиши(&check);
        буф.пишиСтр(`
    }
#endif
`);
    }

    if (глоб2.парамы.cxxhdrname is null)
    {
        // Write to stdout; assume it succeeds
        т_мера n = fwrite(буф[].ptr, 1, буф.length, stdout);
        assert(n == буф.length); // keep gcc happy about return values
    }
    else
    {
        ткст имя = ИмяФайла.combine(глоб2.парамы.cxxhdrdir, глоб2.парамы.cxxhdrname);
        writeFile(Место.initial, имя, буф[]);
    }
}

/****************************************************
 */
/*extern(C++)*/ final class ToCppBuffer(AST) : Визитор2
{
    alias Визитор2.посети посети;
public:
    бул[ук] visited;
    бул[ук] forwarded;
    БуфВыв* fwdbuf;
    БуфВыв* checkbuf;
    БуфВыв* donebuf;
    БуфВыв* буф;
    AST.AggregateDeclaration adparent;
    AST.ClassDeclaration cdparent;
    AST.TemplateDeclaration tdparent;
    Идентификатор2 идент;
    LINK компонаж = LINK.d;
    бул forwardedAA;

    this(БуфВыв* checkbuf, БуфВыв* fwdbuf, БуфВыв* donebuf, БуфВыв* буф)
    {
        this.checkbuf = checkbuf;
        this.fwdbuf = fwdbuf;
        this.donebuf = donebuf;
        this.буф = буф;
    }

    private проц отступ()
    {
        if (adparent)
            буф.пишиСтр("    ");
    }

    override проц посети(AST.ДСимвол s)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.ДСимвол enter] %s\n", s.вТкст0());
            scope(exit) printf("[AST.ДСимвол exit] %s\n", s.вТкст0());
        }

        if (isBuildingCompiler && s.getModule() && s.getModule().isFrontendModule())
        {
            отступ();
            буф.printf("// ignored %s %s\n", s.вид(), s.toPrettyChars());
        }
    }

    override проц посети(AST.Импорт i)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.Импорт enter] %s\n", i.вТкст0());
            scope(exit) printf("[AST.Импорт exit] %s\n", i.вТкст0());
        }
    }

    override проц посети(AST.AttribDeclaration pd)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.AttribDeclaration enter] %s\n", pd.вТкст0());
            scope(exit) printf("[AST.AttribDeclaration exit] %s\n", pd.вТкст0());
        }
        Дсимволы* decl = pd.include(null);
        if (!decl)
            return;

        foreach (s; *decl)
        {
            if (adparent || s.prot().вид >= AST.Prot.Kind.public_)
                s.прими(this);
        }
    }

    override проц посети(AST.LinkDeclaration ld)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.LinkDeclaration enter] %s\n", ld.вТкст0());
            scope(exit) printf("[AST.LinkDeclaration exit] %s\n", ld.вТкст0());
        }
        auto save = компонаж;
        компонаж = ld.компонаж;
        if (ld.компонаж != LINK.c && ld.компонаж != LINK.cpp)
        {
            отступ();
            буф.printf("// ignoring %s block because of компонаж\n", ld.toPrettyChars());
        }
        else
        {
            посети(cast(AST.AttribDeclaration)ld);
        }
        компонаж = save;
    }

    override проц посети(AST.Module m)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.Module enter] %s\n", m.вТкст0());
            scope(exit) printf("[AST.Module exit] %s\n", m.вТкст0());
        }
        foreach (s; *m.члены)
        {
            if (s.prot().вид < AST.Prot.Kind.public_)
                continue;
            s.прими(this);
        }
    }

    override проц посети(AST.FuncDeclaration fd)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.FuncDeclaration enter] %s\n", fd.вТкст0());
            scope(exit) printf("[AST.FuncDeclaration exit] %s\n", fd.вТкст0());
        }
        if (cast(ук)fd in visited)
            return;
        if (isBuildingCompiler && fd.getModule() && fd.getModule().isIgnoredModule())
            return;

        // printf("FuncDeclaration %s %s\n", fd.toPrettyChars(), fd.тип.вТкст0());
        visited[cast(ук)fd] = да;

        auto tf = cast(AST.TypeFunction)fd.тип;
        отступ();
        if (!tf || !tf.deco)
        {
            буф.printf("// ignoring function %s because semantic hasn't been run\n", fd.toPrettyChars());
            return;
        }
        if (tf.компонаж != LINK.c && tf.компонаж != LINK.cpp)
        {
            буф.printf("// ignoring function %s because of компонаж\n", fd.toPrettyChars());
            return;
        }
        if (!adparent && !fd.fbody)
        {
            буф.printf("// ignoring function %s because it's extern\n", fd.toPrettyChars());
            return;
        }

        if (tf.компонаж == LINK.c)
            буф.пишиСтр("extern \"C\" ");
        else if (!adparent)
            буф.пишиСтр("extern ");
        if (adparent && fd.isStatic())
            буф.пишиСтр("static ");
        if (adparent && fd.vtblIndex != -1)
        {
            if (!fd.isOverride())
                буф.пишиСтр("virtual ");

            auto s = adparent.search(Место.initial, fd.идент);
            if (!(adparent.класс_хранения & AST.STC.abstract_) &&
                !(cast(AST.ClassDeclaration)adparent).isAbstract() &&
                s is fd && !fd.overnext)
            {
                auto save = буф;
                буф = checkbuf;
                буф.пишиСтр("    assert(getSlotNumber<");
                буф.пишиСтр(adparent.идент.вТкст0());
                буф.пишиСтр(">(0, &");
                буф.пишиСтр(adparent.идент.вТкст0());
                буф.пишиСтр("::");
                буф.пишиСтр(fd.идент.вТкст0());
                буф.printf(") == %d);\n", fd.vtblIndex);
                буф = save;
            }
        }

        if (adparent && fd.isDisabled && глоб2.парамы.cplusplus < CppStdRevision.cpp11)
            буф.printf("private: ");
        funcToBuffer(tf, fd);
        if (adparent && tf.isConst())
        {
            бул fdOverridesAreConst = да;
            foreach (fdv; fd.foverrides)
            {
                auto tfv = cast(AST.TypeFunction)fdv.тип;
                if (!tfv.isConst())
                {
                    fdOverridesAreConst = нет;
                    break;
                }
            }

            буф.пишиСтр(fdOverridesAreConst ? " const" : " /* const */");
        }
        if (adparent && fd.isAbstract())
            буф.пишиСтр(" = 0");
        if (adparent && fd.isDisabled && глоб2.парамы.cplusplus >= CppStdRevision.cpp11)
            буф.printf(" = delete");
        буф.printf(";\n");
        if (adparent && fd.isDisabled && глоб2.парамы.cplusplus < CppStdRevision.cpp11)
            буф.printf("public:\n");
        if (!adparent)
            буф.printf("\n");
    }

    override проц посети(AST.UnitTestDeclaration utd)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.UnitTestDeclaration enter] %s\n", utd.вТкст0());
            scope(exit) printf("[AST.UnitTestDeclaration exit] %s\n", utd.вТкст0());
        }
    }

    override проц посети(AST.VarDeclaration vd)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.VarDeclaration enter] %s\n", vd.вТкст0());
            scope(exit) printf("[AST.VarDeclaration exit] %s\n", vd.вТкст0());
        }
        if (cast(ук)vd in visited)
            return;
        if (isBuildingCompiler && vd.getModule() && vd.getModule().isIgnoredModule())
            return;

        visited[cast(ук)vd] = да;

        if (vd.alignment != бцел.max)
        {
            отступ();
            буф.printf("// Ignoring var %s alignment %u\n", vd.вТкст0(), vd.alignment);
        }

        if (vd.класс_хранения & AST.STC.manifest &&
            vd.тип.isintegral() &&
            vd._иниц && vd._иниц.isExpInitializer())
        {
            отступ();
            буф.пишиСтр("#define ");
            буф.пишиСтр(vd.идент.вТкст0());
            буф.пишиСтр(" ");
            auto e = AST.инициализаторВВыражение(vd._иниц);
            if (e.тип.ty == AST.Tbool)
                буф.printf("%d", e.toInteger());
            else
                AST.инициализаторВВыражение(vd._иниц).прими(this);
            буф.пишиСтр("\n");
            if (!adparent)
                буф.printf("\n");
            return;
        }

        if (tdparent && vd.тип && !vd.тип.deco)
        {
            отступ();
            if (компонаж != LINK.c && компонаж != LINK.cpp)
            {
                буф.printf("// ignoring variable %s because of компонаж\n", vd.toPrettyChars());
                return;
            }
            typeToBuffer(vd.тип, vd.идент);
            буф.пишиСтр(";\n");
            return;
        }

        if (vd.класс_хранения & (AST.STC.static_ | AST.STC.extern_ | AST.STC.tls | AST.STC.gshared) ||
        vd.родитель && vd.родитель.isModule())
        {
            отступ();
            if (vd.компонаж != LINK.c && vd.компонаж != LINK.cpp)
            {
                буф.printf("// ignoring variable %s because of компонаж\n", vd.toPrettyChars());
                return;
            }
            if (vd.класс_хранения & AST.STC.tls)
            {
                буф.printf("// ignoring variable %s because of thread-local storage\n", vd.toPrettyChars());
                return;
            }
            if (vd.компонаж == LINK.c)
                буф.пишиСтр("extern \"C\" ");
            else if (!adparent)
                буф.пишиСтр("extern ");
            if (adparent)
                буф.пишиСтр("static ");
            typeToBuffer(vd.тип, vd.идент);
            буф.пишиСтр(";\n");
            if (!adparent)
                буф.printf("\n");
            return;
        }

        if (adparent && vd.тип && vd.тип.deco)
        {
            отступ();
            auto save = cdparent;
            cdparent = vd.isField() ? adparent.isClassDeclaration() : null;
            typeToBuffer(vd.тип, vd.идент);
            cdparent = save;
            буф.пишиСтр(";\n");

            if (auto t = vd.тип.isTypeStruct())
                includeSymbol(t.sym);

            auto savex = буф;
            буф = checkbuf;
            буф.пишиСтр("    assert(offsetof(");
            буф.пишиСтр(adparent.идент.вТкст0());
            буф.пишиСтр(", ");
            буф.пишиСтр(vd.идент.вТкст0());
            буф.printf(") == %d);\n", vd.смещение);
            буф = savex;
            return;
        }
        посети(cast(AST.ДСимвол)vd);
    }

    override проц посети(AST.TypeInfoDeclaration tid)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.TypeInfoDeclaration enter] %s\n", tid.вТкст0());
            scope(exit) printf("[AST.TypeInfoDeclaration exit] %s\n", tid.вТкст0());
        }
    }

    override проц посети(AST.AliasDeclaration ad)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.AliasDeclaration enter] %s\n", ad.вТкст0());
            scope(exit) printf("[AST.AliasDeclaration exit] %s\n", ad.вТкст0());
        }
        if (isBuildingCompiler && ad.getModule() && ad.getModule().isIgnoredModule())
            return;

        if (auto t = ad.тип)
        {
            if (t.ty == AST.Tdelegate)
            {
                посети(cast(AST.ДСимвол)ad);
                return;
            }
            буф.пишиСтр("typedef ");
            typeToBuffer(t, ad.идент);
            буф.пишиСтр(";\n");
            if (!adparent)
                буф.printf("\n");
            return;
        }
        if (!ad.aliassym)
        {
            assert(0);
        }
        if (auto ti = ad.aliassym.isTemplateInstance())
        {
            visitTi(ti);
            return;
        }
        if (auto sd = ad.aliassym.isStructDeclaration())
        {
            буф.пишиСтр("typedef ");
            sd.тип.прими(this);
            буф.пишиСтр(" ");
            буф.пишиСтр(ad.идент.вТкст0());
            буф.пишиСтр(";\n");
            if (!adparent)
                буф.printf("\n");
            return;
        }
        if (ad.aliassym.isDtorDeclaration())
        {
            // Ignore. It's taken care of while visiting FuncDeclaration
            return;
        }
        отступ();
        буф.printf("// ignored %s %s\n", ad.aliassym.вид(), ad.aliassym.toPrettyChars());
    }

    override проц посети(AST.AnonDeclaration ad)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.AnonDeclaration enter] %s\n", ad.вТкст0());
            scope(exit) printf("[AST.AnonDeclaration exit] %s\n", ad.вТкст0());
        }
        отступ();
        буф.пишиСтр(ad.isunion ? "union\n" : "struct\n");
        отступ();
        буф.пишиСтр("{\n");
        foreach (s; *ad.decl)
        {
            отступ();
            s.прими(this);
        }
        отступ();
        буф.пишиСтр("};\n");
    }

    private бул memberField(AST.VarDeclaration vd)
    {
        if (!vd.тип || !vd.тип.deco || !vd.идент)
            return нет;
        if (!vd.isField())
            return нет;
        if (vd.тип.ty == AST.Tfunction)
            return нет;
        if (vd.тип.ty == AST.Tsarray)
            return нет;
        return да;
    }

    override проц посети(AST.StructDeclaration sd)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.StructDeclaration enter] %s\n", sd.вТкст0());
            scope(exit) printf("[AST.StructDeclaration exit] %s\n", sd.вТкст0());
        }
        if (sd.isInstantiated())
            return;
        if (cast(ук)sd in visited)
            return;
        if (!sd.тип || !sd.тип.deco)
            return;
        if (isBuildingCompiler && sd.getModule() && sd.getModule().isIgnoredModule())
            return;

        visited[cast(ук)sd] = да;
        if (компонаж != LINK.c && компонаж != LINK.cpp)
        {
            буф.printf("// ignoring non-cpp struct %s because of компонаж\n", sd.вТкст0());
            return;
        }

        буф.пишиСтр(sd.isUnionDeclaration() ? "union" : "struct");
        pushAlignToBuffer(sd.alignment);
        буф.пишиСтр(sd.идент.вТкст0());
        if (!sd.члены)
        {
            буф.пишиСтр(";\n\n");
            return;
        }

        буф.пишиСтр("\n{\n");
        auto save = adparent;
        adparent = sd;
        foreach (m; *sd.члены)
        {
            m.прими(this);
        }
        adparent = save;
        // Generate default ctor
        if (!sd.noDefaultCtor)
        {
            буф.printf("    %s()", sd.идент.вТкст0());
            т_мера varCount;
            бул first = да;
            foreach (m; *sd.члены)
            {
                if (auto vd = m.isVarDeclaration())
                {
                    if (!memberField(vd))
                        continue;
                    varCount++;

                    if (!vd._иниц && !vd.тип.isTypeBasic() && !vd.тип.isTypePointer && !vd.тип.isTypeStruct &&
                        !vd.тип.isTypeClass && !vd.тип.isTypeDArray && !vd.тип.isTypeSArray)
                    {
                        continue;
                    }
                    if (vd._иниц && vd._иниц.isVoidInitializer())
                        continue;

                    if (first)
                    {
                        буф.printf(" : ");
                        first = нет;
                    }
                    else
                    {
                        буф.printf(", ");
                    }
                    буф.printf("%s(", vd.идент.вТкст0());

                    if (vd._иниц)
                    {
                        AST.инициализаторВВыражение(vd._иниц).прими(this);
                    }
                    буф.printf(")");
                }
            }
            буф.printf(" {}\n");
        }

        version (none)
        {
            if (varCount)
            {
                буф.printf("    %s(", sd.идент.вТкст0());
                бул first = да;
                foreach (m; *sd.члены)
                {
                    if (auto vd = m.isVarDeclaration())
                    {
                        if (!memberField(vd))
                            continue;
                        if (first)
                            first = нет;
                        else
                            буф.пишиСтр(", ");
                        assert(vd.тип);
                        assert(vd.идент);
                        typeToBuffer(vd.тип, vd.идент);
                    }
                }
                буф.printf(") {");
                foreach (m; *sd.члены)
                {
                    if (auto vd = m.isVarDeclaration())
                    {
                        if (!memberField(vd))
                            continue;
                        буф.printf(" this->%s = %s;", vd.идент.вТкст0(), vd.идент.вТкст0());
                    }
                }
                буф.printf(" }\n");
            }
        }
        буф.пишиСтр("};\n");

        popAlignToBuffer(sd.alignment);
        буф.пишиСтр("\n");

        auto savex = буф;
        буф = checkbuf;
        буф.пишиСтр("    assert(sizeof(");
        буф.пишиСтр(sd.идент.вТкст0());
        буф.printf(") == %d);\n", sd.size(Место.initial));
        буф = savex;
    }

    private проц pushAlignToBuffer(бцел alignment)
    {
        // DMD ensures alignment is a power of two
        //assert(alignment > 0 && ((alignment & (alignment - 1)) == 0),
        //       "Invalid alignment size");

        // When no alignment is specified, `бцел.max` is the default
        if (alignment == бцел.max)
        {
            буф.пишиБайт(' ');
            return;
        }

        буф.пишиСтр("\n#if defined(__GNUC__) || defined(__clang__)\n");
        // The equivalent of `#pragma pack(сунь, n)` is `__attribute__((packed, aligned(n)))`
        // NOTE: removing the packed attribute will might change the результатing size
        буф.printf("    __attribute__((packed, aligned(%d)))\n", alignment);
        буф.пишиСтр("#elif defined(_MSC_VER)\n");
        буф.printf("    __declspec(align(%d))\n", alignment);
        буф.пишиСтр("#elif defined(__DMC__)\n");
        буф.printf("    #pragma pack(сунь, %d)\n", alignment);
        //буф.printf("#pragma pack(%d)\n", alignment);
        буф.пишиСтр("#endif\n");
    }

    private проц popAlignToBuffer(бцел alignment)
    {
        if (alignment == бцел.max)
            return;

        буф.пишиСтр("#if defined(__DMC__)\n");
        буф.пишиСтр("    #pragma pack(вынь)\n");
        //буф.пишиСтр("#pragma pack()\n");
        буф.пишиСтр("#endif\n");
    }

    private проц includeSymbol(AST.ДСимвол ds)
    {
        debug (Debug_DtoH)
        {
            printf("[includeSymbol(AST.ДСимвол) enter] %s\n", ds.вТкст0());
            scope(exit) printf("[includeSymbol(AST.ДСимвол) exit] %s\n", ds.вТкст0());
        }
        if (cast(ук) ds in visited)
            return;

        БуфВыв decl;
        auto save = буф;
        буф = &decl;
        ds.прими(this);
        буф = save;
        donebuf.пишиСтр(decl.peekChars());
    }

    override проц посети(AST.ClassDeclaration cd)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.ClassDeclaration enter] %s\n", cd.вТкст0());
            scope(exit) printf("[AST.ClassDeclaration exit] %s\n", cd.вТкст0());
        }
        if (cast(ук)cd in visited)
            return;
        if (isBuildingCompiler)
        {
            if (cd.getModule() && cd.getModule().isIgnoredModule())
                return;
            if (cd.isVisitorClass())
                return;
        }

        visited[cast(ук)cd] = да;
        if (!cd.isCPPclass())
        {
            буф.printf("// ignoring non-cpp class %s\n", cd.вТкст0());
            return;
        }

        буф.пишиСтр("class ");
        буф.пишиСтр(cd.идент.вТкст0());
        if (cd.baseClass)
        {
            буф.пишиСтр(" : public ");
            буф.пишиСтр(cd.baseClass.идент.вТкст0());

            includeSymbol(cd.baseClass);
        }
        if (!cd.члены)
        {
            буф.пишиСтр(";\n\n");
            return;
        }

        буф.пишиСтр("\n{\npublic:\n");
        auto save = adparent;
        adparent = cd;
        foreach (m; *cd.члены)
        {
            m.прими(this);
        }
        adparent = save;

        // Generate special static inline function.
        if (isBuildingCompiler && cd.isIdentifierClass())
        {
            буф.пишиСтр("    static inline Идентификатор2 *idPool(const сим *s) { return idPool(s, strlen(s)); }\n");
        }

        буф.пишиСтр("};\n\n");
    }

    override проц посети(AST.EnumDeclaration ed)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.EnumDeclaration enter] %s\n", ed.вТкст0());
            scope(exit) printf("[AST.EnumDeclaration exit] %s\n", ed.вТкст0());
        }
        if (cast(ук)ed in visited)
            return;

        if (isBuildingCompiler && ed.getModule() && ed.getModule().isIgnoredModule())
            return;

        visited[cast(ук)ed] = да;

        //if (компонаж != LINK.c && компонаж != LINK.cpp)
        //{
            //буф.printf("// ignoring non-cpp enum %s because of компонаж\n", ed.вТкст0());
            //return;
        //}

        бул hasBaseType = нет;

        switch (ed.memtype.ty)
        {
            case AST.Tbool, AST.Tvoid:
            case AST.Tchar, AST.Twchar, AST.Tdchar:
            case AST.Tint8, AST.Tuns8:
            case AST.Tint16, AST.Tuns16:
            case AST.Tint64, AST.Tuns64:
            case AST.Tfloat32, AST.Tfloat64, AST.Tfloat80:
                hasBaseType = да;
                break;
            case AST.Tint32, AST.Tuns32, AST.Tenum: // by default, the base is an цел
                break;
            default:
                printf ("%s\n", ed.идент.вТкст0());
                assert(0, ed.memtype.вид.вТкстД);
        }

        if (ed.isSpecial())
            return;
        ткст0 идент = null;
        if (ed.идент)
            идент = ed.идент.вТкст0();
        if (!идент)
        {
            буф.пишиСтр("enum");
        }
        else if (hasBaseType)
        {
            //printf("typedef _d_%s %s;\n", ed.memtype.вид, идент);
            if (глоб2.парамы.cplusplus >= CppStdRevision.cpp11)
            {
                //printf("Using cpp 11 and beyond\n");
                буф.printf("enum %s : %s", идент, ed.memtype.вид);
            }
            else
            {
                //printf("Using cpp 98\n");
                буф.пишиСтр("typedef ");
                буф.пишиСтр(translateBasicType(ed.memtype.ty));
                буф.пишиБайт(' ');
                буф.пишиСтр(идент);
                буф.пишиСтр(";\n");
                буф.пишиСтр("enum");
            }
        }
        else
        {
            буф.пишиСтр("enum ");
            буф.пишиСтр(идент);
        }

        if (!ed.члены)
        {
            буф.пишиСтр(";\n\n");
            return;
        }

        буф.пишиСтр("\n{\n");
        foreach (i, m; *ed.члены)
        {
            if (i)
                буф.пишиСтр(",\n");
            буф.пишиСтр("    ");
            if (идент && глоб2.парамы.cplusplus == CppStdRevision.cpp98)
            {
                foreach (c; идент[0 .. strlen(идент)])
                    буф.пишиБайт(toupper(c));
            }
            m.прими(this);
        }
        буф.пишиСтр("\n};\n\n");

        //printf("Enum %s min %d max %d\n", идент, ed.minval.toInteger(), ed.maxval.toInteger());
    }

    override проц посети(AST.EnumMember em)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.EnumMember enter] %s\n", em.вТкст0());
            scope(exit) printf("[AST.EnumMember exit] %s\n", em.вТкст0());
        }
        буф.пишиСтр(em.идент.вТкст0());
        буф.пишиСтр(" = ");
        //if (cast(AST.StringExp)em.значение)
        //{
            //em.значение.выведиОшибку("cannot convert ткст enum");
            //return ;
        //}
        auto ie = cast(AST.IntegerExp)em.значение;
        visitInteger(ie.toInteger(), em.ed.memtype);
    }

    private проц typeToBuffer(AST.Тип t, Идентификатор2 идент)
    {
        debug (Debug_DtoH)
        {
            printf("[typeToBuffer(AST.Тип) enter] %s идент %s\n", t.вТкст0(), идент.вТкст0());
            scope(exit) printf("[typeToBuffer(AST.Тип) exit] %s идент %s\n", t.вТкст0(), идент.вТкст0());
        }
        this.идент = идент;
        t.прими(this);
        if (this.идент)
        {
            буф.пишиБайт(' ');
            буф.пишиСтр(идент.вТкст0());
        }
        this.идент = null;
        if (auto tsa = t.isTypeSArray())
        {
            буф.пишиБайт('[');
            tsa.dim.прими(this);
            буф.пишиБайт(']');
        }
    }

    override проц посети(AST.Тип t)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.Тип enter] %s\n", t.вТкст0());
            scope(exit) printf("[AST.Тип exit] %s\n", t.вТкст0());
        }
        printf("Invalid тип: %s\n", t.toPrettyChars());
        assert(0);
    }

    override проц посети(AST.TypeIdentifier t)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.TypeIdentifier enter] %s\n", t.вТкст0());
            scope(exit) printf("[AST.TypeIdentifier exit] %s\n", t.вТкст0());
        }
        буф.пишиСтр(t.идент.вТкст0());
    }

    override проц посети(AST.TypeBasic t)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.TypeBasic enter] %s\n", t.вТкст0());
            scope(exit) printf("[AST.TypeBasic exit] %s\n", t.вТкст0());
        }
        if (!cdparent && t.isConst())
            буф.пишиСтр("const ");
        буф.пишиСтр(translateBasicType(t.ty));
    }

    override проц посети(AST.TypePointer t)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.TypePointer enter] %s\n", t.вТкст0());
            scope(exit) printf("[AST.TypePointer exit] %s\n", t.вТкст0());
        }
        auto ts = t.следщ.isTypeStruct();
        if (ts && !strcmp(ts.sym.идент.вТкст0(), "__va_list_tag"))
        {
            буф.пишиСтр("va_list");
            return;
        }
        t.следщ.прими(this);
        if (t.следщ.ty != AST.Tfunction)
            буф.пишиБайт('*');
        if (!cdparent && t.isConst())
            буф.пишиСтр(" const");
    }

    override проц посети(AST.TypeSArray t)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.TypeSArray enter] %s\n", t.вТкст0());
            scope(exit) printf("[AST.TypeSArray exit] %s\n", t.вТкст0());
        }
        t.следщ.прими(this);
    }

    override проц посети(AST.TypeAArray t)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.TypeAArray enter] %s\n", t.вТкст0());
            scope(exit) printf("[AST.TypeAArray exit] %s\n", t.вТкст0());
        }
        AST.Тип.tvoidptr.прими(this);
    }

    override проц посети(AST.TypeFunction tf)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.TypeFunction enter] %s\n", tf.вТкст0());
            scope(exit) printf("[AST.TypeFunction exit] %s\n", tf.вТкст0());
        }
        tf.следщ.прими(this);
        буф.пишиБайт('(');
        буф.пишиБайт('*');
        if (идент)
            буф.пишиСтр(идент.вТкст0());
        идент = null;
        буф.пишиБайт(')');
        буф.пишиБайт('(');
        foreach (i; new бцел[0 .. AST.Параметр2.dim(tf.parameterList.parameters)])
        {
            if (i)
                буф.пишиСтр(", ");
            auto fparam = AST.Параметр2.getNth(tf.parameterList.parameters, i);
            fparam.прими(this);
        }
        if (tf.parameterList.varargs)
        {
            if (tf.parameterList.parameters.dim && tf.parameterList.varargs == 1)
                буф.пишиСтр(", ");
            буф.пишиСтр("...");
        }
        буф.пишиБайт(')');
    }

    private проц enumToBuffer(AST.EnumDeclaration ed)
    {
        debug (Debug_DtoH)
        {
            printf("[enumToBuffer(AST.EnumDeclaration) enter] %s\n", ed.вТкст0());
            scope(exit) printf("[enumToBuffer(AST.EnumDeclaration) exit] %s\n", ed.вТкст0());
        }
        if (ed.isSpecial())
        {
            if (ed.идент == DMDType.c_long)
                буф.пишиСтр("long");
            else if (ed.идент == DMDType.c_ulong)
                буф.пишиСтр("unsigned long");
            else if (ed.идент == DMDType.c_longlong)
                буф.пишиСтр("long long");
            else if (ed.идент == DMDType.c_ulonglong)
                буф.пишиСтр("unsigned long long");
            else if (ed.идент == DMDType.c_long_double)
                буф.пишиСтр("long double");
            else if (ed.идент == DMDType.c_wchar_t)
                буф.пишиСтр("wchar_t");
            else
            {
                //ed.print();
                assert(0);
            }
            return;
        }

        буф.пишиСтр(ed.вТкст0());
    }

    override проц посети(AST.TypeEnum t)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.TypeEnum enter] %s\n", t.вТкст0());
            scope(exit) printf("[AST.TypeEnum exit] %s\n", t.вТкст0());
        }
        if (cast(ук)t.sym in forwarded){}
        else
        {
            forwarded[cast(ук)t.sym] = да;
            auto save = буф;
            буф = fwdbuf;
            //printf("Visiting enum %s from module %s %s\n", t.sym.toPrettyChars(), t.вТкст0(), t.sym.место.вТкст0());
            t.sym.прими(this);
            буф = save;
        }
        if (!cdparent && t.isConst())
            буф.пишиСтр("const ");
        enumToBuffer(t.sym);
    }

    override проц посети(AST.TypeStruct t)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.TypeStruct enter] %s\n", t.вТкст0());
            scope(exit) printf("[AST.TypeStruct exit] %s\n", t.вТкст0());
        }
        if (cast(ук)t.sym in forwarded && !t.sym.родитель.isTemplateInstance()){}
        else
        {
            forwarded[cast(ук)t.sym] = да;
            fwdbuf.пишиСтр(t.sym.isUnionDeclaration() ? "union " : "struct ");
            fwdbuf.пишиСтр(t.sym.вТкст0());
            fwdbuf.пишиСтр(";\n");
        }

        if (!cdparent && t.isConst())
            буф.пишиСтр("const ");
        if (auto ti = t.sym.родитель.isTemplateInstance())
        {
            visitTi(ti);
            return;
        }
        буф.пишиСтр(t.sym.вТкст0());
    }

    override проц посети(AST.TypeDArray t)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.TypeDArray enter] %s\n", t.вТкст0());
            scope(exit) printf("[AST.TypeDArray exit] %s\n", t.вТкст0());
        }
        if (!cdparent && t.isConst())
            буф.пишиСтр("const ");
        буф.пишиСтр("DArray< ");
        t.следщ.прими(this);
        буф.пишиСтр(" >");
    }

    private проц visitTi(AST.TemplateInstance ti)
    {
        debug (Debug_DtoH)
        {
            printf("[visitTi(AST.TemplateInstance) enter] %s\n", ti.вТкст0());
            scope(exit) printf("[visitTi(AST.TemplateInstance) exit] %s\n", ti.вТкст0());
        }

        // FIXME: Restricting this to DMD seems wrong ...
        if (isBuildingCompiler)
        {
            if (ti.tempdecl.идент == DMDType.AssocArray)
            {
                if (!forwardedAA)
                {
                    forwardedAA = да;
                    fwdbuf.пишиСтр("struct AA;\n");
                }
                буф.пишиСтр("AA*");
                return;
            }
            if (ti.tempdecl.идент == DMDType.МассивДРК)
            {
                буф.пишиСтр("МассивДРК");
            }
            else
                goto LprintTypes;
        }
        else
        {
            LprintTypes:
            foreach (o; *ti.tiargs)
            {
                if (!AST.тип_ли(o))
                    return;
            }
            буф.пишиСтр(ti.tempdecl.идент.вТкст0());
        }
        буф.пишиБайт('<');
        foreach (i, o; *ti.tiargs)
        {
            if (i)
                буф.пишиСтр(", ");
            if (auto tt = AST.тип_ли(o))
            {
                tt.прими(this);
            }
            else
            {
                //ti.print();
                //o.print();
                assert(0);
            }
        }
        буф.пишиБайт('>');
    }

    override проц посети(AST.TemplateDeclaration td)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.TemplateDeclaration enter] %s\n", td.вТкст0());
            scope(exit) printf("[AST.TemplateDeclaration exit] %s\n", td.вТкст0());
        }
        if (cast(ук)td in visited)
            return;
        visited[cast(ук)td] = да;

        if (isBuildingCompiler && td.getModule() && td.getModule().isIgnoredModule())
            return;

        if (!td.parameters || !td.onemember || !td.onemember.isStructDeclaration())
        {
            посети(cast(AST.ДСимвол)td);
            return;
        }

        // Explicitly disallow templates with non-тип parameters or specialization.
        foreach (p; *td.parameters)
        {
            if (!p.isTemplateTypeParameter() || p.specialization())
            {
                посети(cast(AST.ДСимвол)td);
                return;
            }
        }

        if (компонаж != LINK.c && компонаж != LINK.cpp)
        {
            буф.printf("// ignoring template %s because of компонаж\n", td.toPrettyChars());
            return;
        }

        auto sd = td.onemember.isStructDeclaration();
        auto save = tdparent;
        tdparent = td;
        отступ();
        буф.пишиСтр("template <");
        бул first = да;
        foreach (p; *td.parameters)
        {
            if (first)
                first = нет;
            else
                буф.пишиСтр(", ");
            буф.пишиСтр("typename ");
            буф.пишиСтр(p.идент.вТкст0());
        }
        буф.пишиСтр(">\n");
        буф.пишиСтр(sd.isUnionDeclaration() ? "union " : "struct ");
        буф.пишиСтр(sd.идент.вТкст0());
        if (sd.члены)
        {
            буф.пишиСтр("\n{\n");
            auto savex = adparent;
            adparent = sd;
            foreach (m; *sd.члены)
            {
                m.прими(this);
            }
            adparent = savex;
            буф.пишиСтр("};\n\n");
        }
        else
        {
            буф.пишиСтр(";\n\n");
        }
        tdparent = save;
    }

    override проц посети(AST.TypeClass t)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.TypeClass enter] %s\n", t.вТкст0());
            scope(exit) printf("[AST.TypeClass exit] %s\n", t.вТкст0());
        }
        if (cast(ук)t.sym in forwarded){}
        else
        {
            forwarded[cast(ук)t.sym] = да;
            fwdbuf.пишиСтр("class ");
            fwdbuf.пишиСтр(t.sym.вТкст0());
            fwdbuf.пишиСтр(";\n");
        }

        if (!cdparent && t.isConst())
            буф.пишиСтр("const ");
        буф.пишиСтр(t.sym.вТкст0());
        буф.пишиБайт('*');
        if (!cdparent && t.isConst())
            буф.пишиСтр(" const");
    }

    private проц funcToBuffer(AST.TypeFunction tf, AST.FuncDeclaration fd)
    {
        debug (Debug_DtoH)
        {
            printf("[funcToBuffer(AST.TypeFunction) enter] %s\n", tf.вТкст0());
            scope(exit) printf("[funcToBuffer(AST.TypeFunction) exit] %s\n", tf.вТкст0());
        }

        Идентификатор2 идент = fd.идент;

        assert(tf.следщ);
        if (fd.isCtorDeclaration() || fd.isDtorDeclaration())
        {
            if (fd.isDtorDeclaration())
            {
                буф.пишиБайт('~');
            }
            буф.пишиСтр(adparent.вТкст0());
        }
        else
        {
            tf.следщ.прими(this);
            if (tf.isref)
                буф.пишиБайт('&');
            буф.пишиБайт(' ');
            буф.пишиСтр(идент.вТкст0());
        }

        буф.пишиБайт('(');
        foreach (i; new бцел[0 .. AST.Параметр2.dim(tf.parameterList.parameters)])
        {
            if (i)
                буф.пишиСтр(", ");
            auto fparam = AST.Параметр2.getNth(tf.parameterList.parameters, i);
            fparam.прими(this);
        }
        if (tf.parameterList.varargs)
        {
            if (tf.parameterList.parameters.dim && tf.parameterList.varargs == 1)
                буф.пишиСтр(", ");
            буф.пишиСтр("...");
        }
        буф.пишиБайт(')');
    }

    override проц посети(AST.Параметр2 p)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.Параметр2 enter] %s\n", p.вТкст0());
            scope(exit) printf("[AST.Параметр2 exit] %s\n", p.вТкст0());
        }
        идент = p.идент;
        p.тип.прими(this);
        assert(!(p.классХранения & ~(AST.STC.ref_)));
        if (p.классХранения & AST.STC.ref_)
            буф.пишиБайт('&');
        буф.пишиБайт(' ');
        if (идент)
            буф.пишиСтр(идент.вТкст0());
        идент = null;
        version (all)
        {
            if (p.defaultArg && p.defaultArg.op >= ТОК2.int32Literal && p.defaultArg.op < ТОК2.struct_)
            {
                //printf("%s %d\n", p.defaultArg.вТкст0, p.defaultArg.op);
                буф.пишиСтр(" = ");
                буф.пишиСтр(p.defaultArg.вТкст0());
            }
        }
        else
        {
            if (p.defaultArg)
            {
                //printf("%s %d\n", p.defaultArg.вТкст0, p.defaultArg.op);
                //return;
                буф.пишиСтр("/*");
                буф.пишиСтр(" = ");
                буф.пишиСтр(p.defaultArg.вТкст0());
                //p.defaultArg.прими(this);
                буф.пишиСтр("*/");
            }
        }
    }

    override проц посети(AST.Выражение e)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.Выражение enter] %s\n", e.вТкст0());
            scope(exit) printf("[AST.Выражение exit] %s\n", e.вТкст0());
        }
        assert(0);
    }

    override проц посети(AST.NullExp e)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.NullExp enter] %s\n", e.вТкст0());
            scope(exit) printf("[AST.NullExp exit] %s\n", e.вТкст0());
        }
        буф.пишиСтр("nullptr");
    }

    override проц посети(AST.ArrayLiteralExp e)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.ArrayLiteralExp enter] %s\n", e.вТкст0());
            scope(exit) printf("[AST.ArrayLiteralExp exit] %s\n", e.вТкст0());
        }
        буф.пишиСтр("arrayliteral");
    }

    override проц посети(AST.StringExp e)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.StringExp enter] %s\n", e.вТкст0());
            scope(exit) printf("[AST.StringExp exit] %s\n", e.вТкст0());
        }
        assert(e.sz == 1 || e.sz == 2);
        if (e.sz == 2)
            буф.пишиБайт('L');
        буф.пишиБайт('"');

        for (т_мера i = 0; i < e.len; i++)
        {
            бцел c = e.charAt(i);
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
                    {
                        буф.printf("\\x%02x\\x%02x", c & 0xFF, c >> 8);
                    }
                    else
                    {
                        буф.printf("\\x%02x\\x%02x\\x%02x\\x%02x",
                                   c & 0xFF, (c >> 8) & 0xFF, (c >> 16) & 0xFF, c >> 24);
                    }
                    break;
            }
        }
        буф.пишиБайт('"');
    }

    override проц посети(AST.RealExp e)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.RealExp enter] %s\n", e.вТкст0());
            scope(exit) printf("[AST.RealExp exit] %s\n", e.вТкст0());
        }

        // TODO: Needs to implemented, используется e.g. for struct member initializers
        буф.пишиСтр("0");
    }

    override проц посети(AST.IntegerExp e)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.IntegerExp enter] %s\n", e.вТкст0());
            scope(exit) printf("[AST.IntegerExp exit] %s\n", e.вТкст0());
        }
        visitInteger(e.toInteger, e.тип);
    }

    private проц visitInteger(dinteger_t v, AST.Тип t)
    {
        debug (Debug_DtoH)
        {
            printf("[visitInteger(AST.Тип) enter] %s\n", t.вТкст0());
            scope(exit) printf("[visitInteger(AST.Тип) exit] %s\n", t.вТкст0());
        }
        switch (t.ty)
        {
            case AST.Tenum:
                auto te = cast(AST.TypeEnum)t;
                буф.пишиСтр("(");
                enumToBuffer(te.sym);
                буф.пишиСтр(")");
                visitInteger(v, te.sym.memtype);
                break;
            case AST.Tbool:
                буф.пишиСтр(v ? "да" : "нет");
                break;
            case AST.Tint8:
                буф.printf("%d", cast(byte)v);
                break;
            case AST.Tuns8:
            case AST.Tchar:
                буф.printf("%uu", cast(ббайт)v);
                break;
            case AST.Tint16:
                буф.printf("%d", cast(short)v);
                break;
            case AST.Tuns16:
                буф.printf("%uu", cast(ushort)v);
                break;
            case AST.Tint32:
                буф.printf("%d", cast(цел)v);
                break;
            case AST.Tuns32:
                буф.printf("%uu", cast(бцел)v);
                break;
            case AST.Tint64:
                буф.printf("%lldLL", v);
                break;
            case AST.Tuns64:
                буф.printf("%lluLLU", v);
                break;
            default:
                //t.print();
                assert(0);
        }
    }

    override проц посети(AST.StructLiteralExp sle)
    {
        debug (Debug_DtoH)
        {
            printf("[AST.StructLiteralExp enter] %s\n", sle.вТкст0());
            scope(exit) printf("[AST.StructLiteralExp exit] %s\n", sle.вТкст0());
        }
        буф.пишиСтр(sle.sd.идент.вТкст0());
        буф.пишиБайт('(');
        foreach(i, e; *sle.elements)
        {
            if (i)
                буф.пишиСтр(", ");
            e.прими(this);
        }
        буф.пишиБайт(')');
    }
}
