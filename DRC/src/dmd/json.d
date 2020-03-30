/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/json.d, _json.d)
 * Documentation:  https://dlang.org/phobos/dmd_json.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/json.d
 */

module dmd.json;

import cidrus;
import dmd.aggregate;
import dmd.arraytypes;
import dmd.attrib;
import dmd.cond;
import dmd.dclass;
import dmd.declaration;
import dmd.denum;
import dmd.dimport;
import dmd.dmodule;
import dmd.дсимвол;
import dmd.dtemplate;
import dmd.errors;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import dmd.hdrgen;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.mtype;
import util.outbuffer;
import drc.ast.Node;
import util.string;
import drc.ast.Visitor;

version(Windows) {
    extern (C) ткст0 getcwd(ткст0 буфер, т_мера maxlen);
} else {
    import core.sys.posix.unistd : getcwd;
}

private  final class ToJsonVisitor : Визитор2
{
    alias  Визитор2.посети посети;
public:
    БуфВыв* буф;
    цел indentLevel;
    ткст имяф;

    this(БуфВыв* буф)
    {
        this.буф = буф;
    }


    проц отступ()
    {
        if (буф.length >= 1 && (*буф)[буф.length - 1] == '\n')
            for (цел i = 0; i < indentLevel; i++)
                буф.пишиБайт(' ');
    }

    проц removeComma()
    {
        if (буф.length >= 2 && (*буф)[буф.length - 2] == ',' && ((*буф)[буф.length - 1] == '\n' || (*буф)[буф.length - 1] == ' '))
            буф.устРазм(буф.length - 2);
    }

    проц comma()
    {
        if (indentLevel > 0)
            буф.пишиСтр(",\n");
    }

    проц stringStart()
    {
        буф.пишиБайт('\"');
    }

    проц stringEnd()
    {
        буф.пишиБайт('\"');
    }

    extern(D) проц stringPart(ткст s)
    {
        foreach (сим c; s)
        {
            switch (c)
            {
            case '\n':
                буф.пишиСтр("\\n");
                break;
            case '\r':
                буф.пишиСтр("\\r");
                break;
            case '\t':
                буф.пишиСтр("\\t");
                break;
            case '\"':
                буф.пишиСтр("\\\"");
                break;
            case '\\':
                буф.пишиСтр("\\\\");
                break;
            case '\b':
                буф.пишиСтр("\\b");
                break;
            case '\f':
                буф.пишиСтр("\\f");
                break;
            default:
                if (c < 0x20)
                    буф.printf("\\u%04x", c);
                else
                {
                    // Note that UTF-8 chars pass through here just fine
                    буф.пишиБайт(c);
                }
                break;
            }
        }
    }

    // Json значение functions
    /*********************************
     * Encode ткст into буф, and wrap it in double quotes.
     */
    extern(D) проц значение(ткст s)
    {
        stringStart();
        stringPart(s);
        stringEnd();
    }

    проц значение(цел значение)
    {
        if (значение < 0)
        {
            буф.пишиБайт('-');
            значение = -значение;
        }
        буф.print(значение);
    }

    проц valueBool(бул значение)
    {
        буф.пишиСтр(значение ? "да" : "нет");
    }

    /*********************************
     * Item is an intented значение and a comma, for use in arrays
     */
    extern(D) проц item( ткст s)
    {
        отступ();
        значение(s);
        comma();
    }

    проц item(цел i)
    {
        отступ();
        значение(i);
        comma();
    }

    проц itemBool(бул b)
    {
        отступ();
        valueBool(b);
        comma();
    }

    // Json массив functions
    проц arrayStart()
    {
        отступ();
        буф.пишиСтр("[\n");
        indentLevel++;
    }

    проц arrayEnd()
    {
        indentLevel--;
        removeComma();
        if (буф.length >= 2 && (*буф)[буф.length - 2] == '[' && (*буф)[буф.length - 1] == '\n')
            буф.устРазм(буф.length - 1);
        else if (!(буф.length >= 1 && (*буф)[буф.length - 1] == '['))
        {
            буф.пишиСтр("\n");
            отступ();
        }
        буф.пишиСтр("]");
        comma();
    }

    // Json объект functions
    проц objectStart()
    {
        отступ();
        буф.пишиСтр("{\n");
        indentLevel++;
    }

    проц objectEnd()
    {
        indentLevel--;
        removeComma();
        if (буф.length >= 2 && (*буф)[буф.length - 2] == '{' && (*буф)[буф.length - 1] == '\n')
            буф.устРазм(буф.length - 1);
        else
        {
            буф.пишиСтр("\n");
            отступ();
        }
        буф.пишиСтр("}");
        comma();
    }

    // Json объект property functions
    extern(D) проц propertyStart(ткст имя)
    {
        отступ();
        значение(имя);
        буф.пишиСтр(" : ");
    }

    /**
    Write the given ткст объект property only if `s` is not null.

    Параметры:
     имя = the имя of the объект property
     s = the ткст значение of the объект property
    */
    extern(D) проц property(ткст имя,  ткст s)
    {
        if (s is null)
            return;
        propertyStart(имя);
        значение(s);
        comma();
    }

    /**
    Write the given ткст объект property.

    Параметры:
     имя = the имя of the объект property
     s = the ткст значение of the объект property
    */
    extern(D) проц requiredProperty(ткст имя, ткст s)
    {
        propertyStart(имя);
        if (s is null)
            буф.пишиСтр("null");
        else
            значение(s);
        comma();
    }

    extern(D) проц property(ткст имя, цел i)
    {
        propertyStart(имя);
        значение(i);
        comma();
    }

    extern(D) проц propertyBool(ткст имя,  бул b)
    {
        propertyStart(имя);
        valueBool(b);
        comma();
    }

    extern(D) проц property(ткст имя, TRUST trust)
    {
        switch (trust)
        {
        case TRUST.default_:
            // Should not be printed
            //property(имя, "default");
            break;
        case TRUST.system:  return property(имя, "system");
        case TRUST.trusted: return property(имя, "trusted");
        case TRUST.safe:    return property(имя, "safe");
        }
    }

    extern(D) проц property(ткст имя, PURE purity)
    {
        switch (purity)
        {
        case PURE.impure:
            // Should not be printed
            //property(имя, "impure");
            break;
        case PURE.weak:     return property(имя, "weak");
        case PURE.const_:   return property(имя, "const");
        case PURE.strong:   return property(имя, "strong");
        case PURE.fwdref:   return property(имя, "fwdref");
        }
    }

    extern(D) проц property(ткст имя, LINK компонаж)
    {
        switch (компонаж)
        {
        case LINK.default_:
            // Should not be printed
            //property(имя, "default");
            break;
        case LINK.d:
            // Should not be printed
            //property(имя, "d");
            break;
        case LINK.system:
            // Should not be printed
            //property(имя, "system");
            break;
        case LINK.c:        return property(имя, "c");
        case LINK.cpp:      return property(имя, "cpp");
        case LINK.windows:  return property(имя, "windows");
        case LINK.pascal:   return property(имя, "pascal");
        case LINK.objc:     return property(имя, "objc");
        }
    }

    extern(D) проц propertyStorageClass(ткст имя, КлассХранения stc)
    {
        stc &= STCStorageClass;
        if (stc)
        {
            propertyStart(имя);
            arrayStart();
            while (stc)
            {
                auto p = stcToString(stc);
                assert(p.length);
                item(p);
            }
            arrayEnd();
        }
    }

    extern(D) проц property(ткст linename, ткст charname, ref Место место)
    {
        if (место.isValid())
        {
            if (auto имяф = место.имяф.вТкстД)
            {
                if (имяф != this.имяф)
                {
                    this.имяф = имяф;
                    property("файл", имяф);
                }
            }
            if (место.номстр)
            {
                property(linename, место.номстр);
                if (место.имяс)
                    property(charname, место.имяс);
            }
        }
    }

    extern(D) проц property(ткст имя, Тип тип)
    {
        if (тип)
        {
            property(имя, тип.вТкст());
        }
    }

    extern(D) проц property(ткст имя, ткст deconame, Тип тип)
    {
        if (тип)
        {
            if (тип.deco)
                property(deconame, тип.deco.вТкстД);
            else
                property(имя, тип.вТкст());
        }
    }

    extern(D) проц property(ткст имя, Параметры* parameters)
    {
        if (parameters is null || parameters.dim == 0)
            return;
        propertyStart(имя);
        arrayStart();
        if (parameters)
        {
            for (т_мера i = 0; i < parameters.dim; i++)
            {
                Параметр2 p = (*parameters)[i];
                objectStart();
                if (p.идент)
                    property("имя", p.идент.вТкст());
                property("тип", "deco", p.тип);
                propertyStorageClass("классХранения", p.классХранения);
                if (p.defaultArg)
                    property("default", p.defaultArg.вТкст());
                objectEnd();
            }
        }
        arrayEnd();
    }

    /* ========================================================================== */
    проц jsonProperties(ДСимвол s)
    {
        if (s.isModule())
            return;
        if (!s.isTemplateDeclaration()) // TemplateDeclaration::вид() acts weird sometimes
        {
            property("имя", s.вТкст());
            property("вид", s.вид.вТкстД);
        }
        if (s.prot().вид != Prot.Kind.public_) // TODO: How about package(имена)?
            property("защита", protectionToString(s.prot().вид));
        if (EnumMember em = s.isEnumMember())
        {
            if (em.origValue)
                property("значение", em.origValue.вТкст());
        }
        property("коммент", s.коммент.вТкстД);
        property("line", "сим", s.место);
    }

    проц jsonProperties(Declaration d)
    {
        if (d.класс_хранения & STC.local)
            return;
        jsonProperties(cast(ДСимвол)d);
        propertyStorageClass("классХранения", d.класс_хранения);
        property("компонаж", d.компонаж);
        property("тип", "deco", d.тип);
        // Emit originalType if it differs from тип
        if (d.тип != d.originalType && d.originalType)
        {
            auto ostr = d.originalType.вТкст();
            if (d.тип)
            {
                auto tstr = d.тип.вТкст();
                if (ostr != tstr)
                {
                    //printf("tstr = %s, ostr = %s\n", tstr, ostr);
                    property("originalType", ostr);
                }
            }
            else
                property("originalType", ostr);
        }
    }

    проц jsonProperties(TemplateDeclaration td)
    {
        jsonProperties(cast(ДСимвол)td);
        if (td.onemember && td.onemember.isCtorDeclaration())
            property("имя", "this"); // __ctor -> this
        else
            property("имя", td.идент.вТкст()); // Foo(T) -> Foo
    }

    /* ========================================================================== */
    override проц посети(ДСимвол s)
    {
    }

    override проц посети(Module s)
    {
        objectStart();
        if (s.md)
            property("имя", s.md.вТкст());
        property("вид", s.вид.вТкстД);
        имяф = s.srcfile.вТкст();
        property("файл", имяф);
        property("коммент", s.коммент.вТкстД);
        propertyStart("члены");
        arrayStart();
        for (т_мера i = 0; i < s.члены.dim; i++)
        {
            (*s.члены)[i].прими(this);
        }
        arrayEnd();
        objectEnd();
    }

    override проц посети(Импорт s)
    {
        if (s.ид == Id.объект)
            return;
        objectStart();
        propertyStart("имя");
        stringStart();
        if (s.пакеты && s.пакеты.dim)
        {
            for (т_мера i = 0; i < s.пакеты.dim; i++)
            {
                const pid = (*s.пакеты)[i];
                stringPart(pid.вТкст());
                буф.пишиБайт('.');
            }
        }
        stringPart(s.ид.вТкст());
        stringEnd();
        comma();
        property("вид", s.вид.вТкстД);
        property("коммент", s.коммент.вТкстД);
        property("line", "сим", s.место);
        if (s.prot().вид != Prot.Kind.public_)
            property("защита", protectionToString(s.prot().вид));
        if (s.идНик)
            property("alias", s.идНик.вТкст());
        бул hasRenamed = нет;
        бул hasSelective = нет;
        for (т_мера i = 0; i < s.ники.dim; i++)
        {
            // avoid empty "renamed" and "selective" sections
            if (hasRenamed && hasSelective)
                break;
            else if (s.ники[i])
                hasRenamed = да;
            else
                hasSelective = да;
        }
        if (hasRenamed)
        {
            // import foo : alias1 = target1;
            propertyStart("renamed");
            objectStart();
            for (т_мера i = 0; i < s.ники.dim; i++)
            {
                const имя = s.имена[i];
                const _alias = s.ники[i];
                if (_alias)
                    property(_alias.вТкст(), имя.вТкст());
            }
            objectEnd();
        }
        if (hasSelective)
        {
            // import foo : target1;
            propertyStart("selective");
            arrayStart();
            foreach (i, имя; s.имена)
            {
                if (!s.ники[i])
                    item(имя.вТкст());
            }
            arrayEnd();
        }
        objectEnd();
    }

    override проц посети(AttribDeclaration d)
    {
        Дсимволы* ds = d.include(null);
        if (ds)
        {
            for (т_мера i = 0; i < ds.dim; i++)
            {
                ДСимвол s = (*ds)[i];
                s.прими(this);
            }
        }
    }

    override проц посети(ConditionalDeclaration d)
    {
        if (d.условие.inc != Include.notComputed)
        {
            посети(cast(AttribDeclaration)d);
        }
        Дсимволы* ds = d.decl ? d.decl : d.elsedecl;
        for (т_мера i = 0; i < ds.dim; i++)
        {
            ДСимвол s = (*ds)[i];
            s.прими(this);
        }
    }

    override проц посети(TypeInfoDeclaration d)
    {
    }

    override проц посети(PostBlitDeclaration d)
    {
    }

    override проц посети(Declaration d)
    {
        objectStart();
        //property("unknown", "declaration");
        jsonProperties(d);
        objectEnd();
    }

    override проц посети(AggregateDeclaration d)
    {
        objectStart();
        jsonProperties(d);
        ClassDeclaration cd = d.isClassDeclaration();
        if (cd)
        {
            if (cd.baseClass && cd.baseClass.идент != Id.Object)
            {
                property("base", cd.baseClass.toPrettyChars(да).вТкстД);
            }
            if (cd.interfaces.length)
            {
                propertyStart("interfaces");
                arrayStart();
                foreach (b; cd.interfaces)
                {
                    item(b.sym.toPrettyChars(да).вТкстД);
                }
                arrayEnd();
            }
        }
        if (d.члены)
        {
            propertyStart("члены");
            arrayStart();
            for (т_мера i = 0; i < d.члены.dim; i++)
            {
                ДСимвол s = (*d.члены)[i];
                s.прими(this);
            }
            arrayEnd();
        }
        objectEnd();
    }

    override проц посети(FuncDeclaration d)
    {
        objectStart();
        jsonProperties(d);
        TypeFunction tf = cast(TypeFunction)d.тип;
        if (tf && tf.ty == Tfunction)
            property("parameters", tf.parameterList.parameters);
        property("endline", "endchar", d.endloc);
        if (d.foverrides.dim)
        {
            propertyStart("overrides");
            arrayStart();
            for (т_мера i = 0; i < d.foverrides.dim; i++)
            {
                FuncDeclaration fd = d.foverrides[i];
                item(fd.toPrettyChars().вТкстД);
            }
            arrayEnd();
        }
        if (d.fdrequire)
        {
            propertyStart("in");
            d.fdrequire.прими(this);
        }
        if (d.fdensure)
        {
            propertyStart("out");
            d.fdensure.прими(this);
        }
        objectEnd();
    }

    override проц посети(TemplateDeclaration d)
    {
        objectStart();
        // TemplateDeclaration::вид returns the вид of its Aggregate onemember, if it is one
        property("вид", "template");
        jsonProperties(d);
        propertyStart("parameters");
        arrayStart();
        for (т_мера i = 0; i < d.parameters.dim; i++)
        {
            ПараметрШаблона2 s = (*d.parameters)[i];
            objectStart();
            property("имя", s.идент.вТкст());

            if (auto тип = s.isTemplateTypeParameter())
            {
                if (s.isTemplateThisParameter())
                    property("вид", "this");
                else
                    property("вид", "тип");
                property("тип", "deco", тип.specType);
                property("default", "defaultDeco", тип.defaultType);
            }

            if (auto значение = s.isTemplateValueParameter())
            {
                property("вид", "значение");
                property("тип", "deco", значение.valType);
                if (значение.specValue)
                    property("specValue", значение.specValue.вТкст());
                if (значение.defaultValue)
                    property("defaultValue", значение.defaultValue.вТкст());
            }

            if (auto _alias = s.isTemplateAliasParameter())
            {
                property("вид", "alias");
                property("тип", "deco", _alias.specType);
                if (_alias.specAlias)
                    property("specAlias", _alias.specAlias.вТкст());
                if (_alias.defaultAlias)
                    property("defaultAlias", _alias.defaultAlias.вТкст());
            }

            if (auto кортеж = s.isTemplateTupleParameter())
            {
                property("вид", "кортеж");
            }

            objectEnd();
        }
        arrayEnd();
        Выражение Выражение = d.constraint;
        if (Выражение)
        {
            property("constraint", Выражение.вТкст());
        }
        propertyStart("члены");
        arrayStart();
        for (т_мера i = 0; i < d.члены.dim; i++)
        {
            ДСимвол s = (*d.члены)[i];
            s.прими(this);
        }
        arrayEnd();
        objectEnd();
    }

    override проц посети(EnumDeclaration d)
    {
        if (d.isAnonymous())
        {
            if (d.члены)
            {
                for (т_мера i = 0; i < d.члены.dim; i++)
                {
                    ДСимвол s = (*d.члены)[i];
                    s.прими(this);
                }
            }
            return;
        }
        objectStart();
        jsonProperties(d);
        property("base", "baseDeco", d.memtype);
        if (d.члены)
        {
            propertyStart("члены");
            arrayStart();
            for (т_мера i = 0; i < d.члены.dim; i++)
            {
                ДСимвол s = (*d.члены)[i];
                s.прими(this);
            }
            arrayEnd();
        }
        objectEnd();
    }

    override проц посети(EnumMember s)
    {
        objectStart();
        jsonProperties(cast(ДСимвол)s);
        property("тип", "deco", s.origType);
        objectEnd();
    }

    override проц посети(VarDeclaration d)
    {
        if (d.класс_хранения & STC.local)
            return;
        objectStart();
        jsonProperties(d);
        if (d._иниц)
            property("init", d._иниц.вТкст());
        if (d.isField())
            property("смещение", d.смещение);
        if (d.alignment && d.alignment != STRUCTALIGN_DEFAULT)
            property("align", d.alignment);
        objectEnd();
    }

    override проц посети(TemplateMixin d)
    {
        objectStart();
        jsonProperties(d);
        objectEnd();
    }

    /**
    Generate an массив of module objects that represent the syntax of each
    "root module".

    Параметры:
     modules = массив of the "root modules"
    */
    private проц generateModules(Modules* modules)
    {
        arrayStart();
        if (modules)
        {
            foreach (m; *modules)
            {
                if (глоб2.парамы.verbose)
                    message("json gen %s", m.вТкст0());
                m.прими(this);
            }
        }
        arrayEnd();
    }

    /**
    Generate the "compilerInfo" объект which содержит information about the compiler
    such as the имяф, version, supported features, etc.
    */
    private проц generateCompilerInfo()
    {
        objectStart();
        requiredProperty("vendor", глоб2.vendor);
        requiredProperty("version", глоб2._version);
        property("__VERSION__", глоб2.versionNumber());
        requiredProperty("interface", determineCompilerInterface());
        property("т_мера", т_мера.sizeof);
        propertyStart("platforms");
        arrayStart();
        if (глоб2.парамы.isWindows)
        {
            item("windows");
        }
        else
        {
            item("posix");
            if (глоб2.парамы.isLinux)
                item("linux");
            else if (глоб2.парамы.isOSX)
                item("osx");
            else if (глоб2.парамы.isFreeBSD)
            {
                item("freebsd");
                item("bsd");
            }
            else if (глоб2.парамы.isOpenBSD)
            {
                item("openbsd");
                item("bsd");
            }
            else if (глоб2.парамы.isSolaris)
            {
                item("solaris");
                item("bsd");
            }
        }
        arrayEnd();

        propertyStart("architectures");
        arrayStart();
        if (глоб2.парамы.is64bit)
            item("x86_64");
        else
            version(X86) item("x86");
        arrayEnd();

        propertyStart("predefinedVersions");
        arrayStart();
        if (глоб2.versionids)
        {
            foreach (versionid; *глоб2.versionids)
            {
                item(versionid.вТкст());
            }
        }
        arrayEnd();

        propertyStart("supportedFeatures");
        {
            objectStart();
            scope(exit) objectEnd();
            propertyBool("includeImports", да);
        }
        objectEnd();
    }

    /**
    Generate the "buildInfo" объект which содержит information specific to the
    current build such as CWD, importPaths, configFile, etc.
    */
    private проц generateBuildInfo()
    {
        objectStart();
        requiredProperty("cwd", getcwd(null, 0).вТкстД);
        requiredProperty("argv0", глоб2.парамы.argv0);
        requiredProperty("config", глоб2.inifilename);
        requiredProperty("libName", глоб2.парамы.libname);

        propertyStart("importPaths");
        arrayStart();
        if (глоб2.парамы.imppath)
        {
            foreach (importPath; *глоб2.парамы.imppath)
            {
                item(importPath.вТкстД);
            }
        }
        arrayEnd();

        propertyStart("objectFiles");
        arrayStart();
        foreach (objfile; глоб2.парамы.objfiles)
        {
            item(objfile.вТкстД);
        }
        arrayEnd();

        propertyStart("libraryFiles");
        arrayStart();
        foreach (lib; глоб2.парамы.libfiles)
        {
            item(lib.вТкстД);
        }
        arrayEnd();

        propertyStart("ddocFiles");
        arrayStart();
        foreach (ddocFile; глоб2.парамы.ddocfiles)
        {
            item(ddocFile.вТкстД);
        }
        arrayEnd();

        requiredProperty("mapFile", глоб2.парамы.mapfile);
        requiredProperty("resourceFile", глоб2.парамы.resfile);
        requiredProperty("defFile", глоб2.парамы.deffile);

        objectEnd();
    }

    /**
    Generate the "semantics" объект which содержит a 'modules' field representing
    semantic information about all the modules используется in the compilation such as
    module имя, isRoot, contentImportedFiles, etc.
    */
    private проц generateSemantics()
    {
        objectStart();
        propertyStart("modules");
        arrayStart();
        foreach (m; Module.amodules)
        {
            objectStart();
            requiredProperty("имя", m.md ? m.md.вТкст() : null);
            requiredProperty("файл", m.srcfile.вТкст());
            propertyBool("isRoot", m.isRoot());
            if(m.contentImportedFiles.dim > 0)
            {
                propertyStart("contentImports");
                arrayStart();
                foreach (файл; m.contentImportedFiles)
                {
                    item(файл.вТкстД);
                }
                arrayEnd();
            }
            objectEnd();
        }
        arrayEnd();
        objectEnd();
    }
}

 проц json_generate(БуфВыв* буф, Modules* modules)
{
    scope ToJsonVisitor json = new ToJsonVisitor(буф);
    // пиши trailing newline
    scope(exit) буф.пишиБайт('\n');

    if (глоб2.парамы.jsonFieldFlags == 0)
    {
        // Generate the original format, which is just an массив
        // of modules representing their syntax.
        json.generateModules(modules);
        json.removeComma();
    }
    else
    {
        // Generate the new format which is an объект where each
        // output опция is its own field.

        json.objectStart();
        if (глоб2.парамы.jsonFieldFlags & JsonFieldFlags.compilerInfo)
        {
            json.propertyStart("compilerInfo");
            json.generateCompilerInfo();
        }
        if (глоб2.парамы.jsonFieldFlags & JsonFieldFlags.buildInfo)
        {
            json.propertyStart("buildInfo");
            json.generateBuildInfo();
        }
        if (глоб2.парамы.jsonFieldFlags & JsonFieldFlags.modules)
        {
            json.propertyStart("modules");
            json.generateModules(modules);
        }
        if (глоб2.парамы.jsonFieldFlags & JsonFieldFlags.semantics)
        {
            json.propertyStart("semantics");
            json.generateSemantics();
        }
        json.objectEnd();
    }
}

/**
A ткст listing the имя of each JSON field. Useful for errors messages.
*/
 /+
enum jsonFieldNames = () {
    ткст s;
    ткст префикс = "";
    foreach (idx, enumName; __traits(allMembers, JsonFieldFlags))
    {
        static if (idx > 0)
        {
            s ~= префикс ~ "`" ~ enumName ~ "`";
            префикс = ", ";
        }
    }
    return s;
}();
+/
/**
Parse the given `fieldName` and return its corresponding JsonFieldFlags значение.

Параметры:
 fieldName = the field имя to parse

Возвращает: JsonFieldFlags.none on error, otherwise the JsonFieldFlags значение
         corresponding to the given fieldName.
*/
 JsonFieldFlags tryParseJsonField(ткст0 fieldName)
{
    auto fieldNameString = fieldName.вТкстД();
    foreach (idx, enumName; __traits(allMembers, JsonFieldFlags))
    {
        static if (idx > 0)
        {
            if (fieldNameString == enumName)
                return __traits(getMember, JsonFieldFlags, enumName);
        }
    }
    return JsonFieldFlags.none;
}

/**
Determines and returns the compiler interface which is one of `dmd`, `ldc`,
`gdc` or `sdc`. Возвращает `null` if no interface can be determined.
*/
private extern(D) ткст determineCompilerInterface()
{
    if (глоб2.vendor == "Digital Mars D")
        return "dmd";
    if (глоб2.vendor == "LDC")
        return "ldc";
    if (глоб2.vendor == "GNU D")
        return "gdc";
    if (глоб2.vendor == "SDC")
        return "sdc";
    return null;
}
