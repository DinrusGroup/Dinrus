/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/dmodule.d, _dmodule.d)
 * Documentation:  https://dlang.org/phobos/dmd_dmodule.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/dmodule.d
 */

module dmd.dmodule;

import cidrus;

import drc.ast.AstCodegen;

import dmd.semantic2;
import dmd.semantic3;
/*
import dmd.aggregate;
import dmd.arraytypes;
import dmd.compiler;
import dmd.gluelayer;
import dmd.dimport;
import dmd.dmacro;
import drc.doc.Doc2;
import dmd.dscope;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.errors;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import drc.parser.Parser2;
*/
import util.file;
import util.filename;
import util.outbuffer;
import util.port;
import util.rmem;
import drc.ast.Node;
import util.string;
import drc.ast.Visitor;

version (Posix)
import core.sys.posix.unistd : getpid;
else version (Windows)
import win32.winbase : getpid = GetCurrentProcessId;

version(Windows) {
    extern (C) ткст0 getcwd(ткст0 буфер, т_мера maxlen);
} else {
    import core.sys.posix.unistd : getcwd;
}

/* ===========================  ===================== */
/********************************************
 * Look for the source файл if it's different from имяф.
 * Look for .di, .d, directory, and along глоб2.path.
 * Does not open the файл.
 * Input:
 *      имяф        as supplied by the user
 *      глоб2.path
 * Возвращает:
 *      NULL if it's not different from имяф.
 */
private ткст lookForSourceFile(ткст имяф)
{
    /* Search along глоб2.path for .di файл, then .d файл.
     */
    const sdi = ИмяФайла.forceExt(имяф, глоб2.hdr_ext);
    if (ИмяФайла.exists(sdi) == 1)
        return sdi;
    scope(exit) ИмяФайла.free(sdi.ptr);
    const sd = ИмяФайла.forceExt(имяф, глоб2.mars_ext);
    if (ИмяФайла.exists(sd) == 1)
        return sd;
    scope(exit) ИмяФайла.free(sd.ptr);
    if (ИмяФайла.exists(имяф) == 2)
    {
        /* The имяф exists and it's a directory.
         * Therefore, the результат should be: имяф/package.d
         * iff имяф/package.d is a файл
         */
        const ni = ИмяФайла.combine(имяф, "package.di");
        if (ИмяФайла.exists(ni) == 1)
            return ni;
        ИмяФайла.free(ni.ptr);
        const n = ИмяФайла.combine(имяф, "package.d");
        if (ИмяФайла.exists(n) == 1)
            return n;
        ИмяФайла.free(n.ptr);
    }
    if (ИмяФайла.absolute(имяф))
        return null;
    if (!глоб2.path)
        return null;
    for (т_мера i = 0; i < глоб2.path.dim; i++)
    {
        const p = (*глоб2.path)[i].вТкстД();
        ткст n = ИмяФайла.combine(p, sdi);
        if (ИмяФайла.exists(n) == 1) {
            return n;
        }
        ИмяФайла.free(n.ptr);
        n = ИмяФайла.combine(p, sd);
        if (ИмяФайла.exists(n) == 1) {
            return n;
        }
        ИмяФайла.free(n.ptr);
        const b = ИмяФайла.removeExt(имяф);
        n = ИмяФайла.combine(p, b);
        ИмяФайла.free(b.ptr);
        if (ИмяФайла.exists(n) == 2)
        {
            const n2i = ИмяФайла.combine(n, "package.di");
            if (ИмяФайла.exists(n2i) == 1)
                return n2i;
            ИмяФайла.free(n2i.ptr);
            const n2 = ИмяФайла.combine(n, "package.d");
            if (ИмяФайла.exists(n2) == 1) {
                return n2;
            }
            ИмяФайла.free(n2.ptr);
        }
        ИмяФайла.free(n.ptr);
    }
    return null;
}

// function используется to call semantic3 on a module's dependencies
проц semantic3OnDependencies(Module m)
{
    if (!m)
        return;

    if (m.semanticRun > PASS.semantic3)
        return;

    m.semantic3(null);

    foreach (i; new бцел[1 .. m.aimports.dim])
        semantic3OnDependencies(m.aimports[i]);
}

/**
 * Converts a chain of identifiers to the имяф of the module
 *
 * Параметры:
 *  пакеты = the имена of the "родитель" пакеты
 *  идент = the имя of the child package or module
 *
 * Возвращает:
 *  the имяф of the child package or module
 */
private ткст getFilename(Идентификаторы* пакеты, Идентификатор2 идент)
{
    ткст имяф = идент.вТкст();

    if (пакеты == null || пакеты.dim == 0)
        return имяф;

    БуфВыв буф;
    БуфВыв dotmods;
    auto modAliases = &глоб2.парамы.modFileAliasStrings;

    проц checkModFileAlias(ткст p)
    {
        /* Check and replace the contents of буф[] with
        * an alias ткст from глоб2.парамы.modFileAliasStrings[]
        */
        dotmods.пишиСтр(p);
        foreach_reverse ( m; *modAliases)
        {
            const q = strchr(m, '=');
            assert(q);
            if (dotmods.length == q - m && memcmp(dotmods.peekChars(), m, q - m) == 0)
            {
                буф.устРазм(0);
                auto rhs = q[1 .. strlen(q)];
                if (rhs.length > 0 && (rhs[$ - 1] == '/' || rhs[$ - 1] == '\\'))
                    rhs = rhs[0 .. $ - 1]; // удали trailing separator
                буф.пишиСтр(rhs);
                break; // last matching entry in ms[] wins
            }
        }
        dotmods.пишиБайт('.');
    }

    foreach (pid; *пакеты)
    {
        const p = pid.вТкст();
        буф.пишиСтр(p);
        if (modAliases.dim)
            checkModFileAlias(p);
        version (Windows)
            const FileSeparator = '\\';
        else
            const FileSeparator = '/';
        буф.пишиБайт(FileSeparator);
    }
    буф.пишиСтр(имяф);
    if (modAliases.dim)
        checkModFileAlias(имяф);
    буф.пишиБайт(0);
    имяф = буф.извлекиСрез()[0 .. $ - 1];

    return имяф;
}

enum PKG : цел
{
    unknown,     // not yet determined whether it's a package.d or not
    module_,      // already determined that's an actual package.d
    package_,     // already determined that's an actual package
}

/***********************************************************
 */
 class Package : ScopeDsymbol
{
    PKG isPkgMod = PKG.unknown;
    бцел tag;        // auto incremented tag, используется to mask package tree in scopes
    Module mod;     // !=null if isPkgMod == PKG.module_

    final this(ref Место место, Идентификатор2 идент)
    {
        super(место, идент);
         бцел packageTag;
        this.tag = packageTag++;
    }

    override ткст0 вид()
    {
        return "package";
    }

    override бул равен(КорневойОбъект o)
    {
        // custom 'равен' for bug 17441. "package a" and "module a" are not equal
        if (this == o)
            return да;
        auto p = cast(Package)o;
        return p && isModule() == p.isModule() && идент.равен(p.идент);
    }

    /****************************************************
     * Input:
     *      пакеты[]      the pkg1.pkg2 of pkg1.pkg2.mod
     * Возвращает:
     *      the symbol table that mod should be inserted into
     * Output:
     *      *pparent        the rightmost package, i.e. pkg2, or NULL if no пакеты
     *      *ppkg           the leftmost package, i.e. pkg1, or NULL if no пакеты
     */
    extern (D) static DsymbolTable resolve(Идентификаторы* пакеты, ДСимвол* pparent, Package* ppkg)
    {
        DsymbolTable dst = Module.modules;
        ДСимвол родитель = null;
        //printf("Package::resolve()\n");
        if (ppkg)
            *ppkg = null;
        if (пакеты)
        {
            for (т_мера i = 0; i < пакеты.dim; i++)
            {
                Идентификатор2 pid = (*пакеты)[i];
                Package pkg;
                ДСимвол p = dst.lookup(pid);
                if (!p)
                {
                    pkg = new Package(Место.initial, pid);
                    dst.вставь(pkg);
                    pkg.родитель = родитель;
                    pkg.symtab = new DsymbolTable();
                }
                else
                {
                    pkg = p.isPackage();
                    assert(pkg);
                    // It might already be a module, not a package, but that needs
                    // to be checked at a higher уровень, where a nice error message
                    // can be generated.
                    // dot net needs modules and пакеты with same имя
                    // But we still need a symbol table for it
                    if (!pkg.symtab)
                        pkg.symtab = new DsymbolTable();
                }
                родитель = pkg;
                dst = pkg.symtab;
                if (ppkg && !*ppkg)
                    *ppkg = pkg;
                if (pkg.isModule())
                {
                    // Return the module so that a nice error message can be generated
                    if (ppkg)
                        *ppkg = cast(Package)p;
                    break;
                }
            }
        }
        if (pparent)
            *pparent = родитель;
        return dst;
    }

    override final Package isPackage()
    {
        return this;
    }

    /**
     * Checks if pkg is a sub-package of this
     *
     * For example, if this qualifies to 'a1.a2' and pkg - to 'a1.a2.a3',
     * this function returns 'да'. If it is other way around or qualified
     * package paths conflict function returns 'нет'.
     *
     * Параметры:
     *  pkg = possible subpackage
     *
     * Возвращает:
     *  see description
     */
    final бул isAncestorPackageOf(Package pkg)
    {
        if (this == pkg)
            return да;
        if (!pkg || !pkg.родитель)
            return нет;
        return isAncestorPackageOf(pkg.родитель.isPackage());
    }

    override ДСимвол search(ref Место место, Идентификатор2 идент, цел flags = SearchLocalsOnly)
    {
        //printf("%s Package.search('%s', flags = x%x)\n", вТкст0(), идент.вТкст0(), flags);
        flags &= ~SearchLocalsOnly;  // searching an import is always transitive
        if (!isModule() && mod)
        {
            // Prefer full package имя.
            ДСимвол s = symtab ? symtab.lookup(идент) : null;
            if (s)
                return s;
            //printf("[%s] through pkdmod: %s\n", место.вТкст0(), вТкст0());
            return mod.search(место, идент, flags);
        }
        return ScopeDsymbol.search(место, идент, flags);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }

    final Module isPackageMod()
    {
        if (isPkgMod == PKG.module_)
        {
            return mod;
        }
        return null;
    }

    /**
     * Checks for the existence of a package.d to set isPkgMod appropriately
     * if isPkgMod == PKG.unknown
     */
    final проц resolvePKGunknown()
    {
        if (isModule())
            return;
        if (isPkgMod != PKG.unknown)
            return;

        Идентификаторы пакеты;
        for (ДСимвол s = this.родитель; s; s = s.родитель)
            пакеты.вставь(0, s.идент);

        if (lookForSourceFile(getFilename(&пакеты, идент)))
            Module.load(Место(), &пакеты, this.идент);
        else
            isPkgMod = PKG.package_;
    }
}

/***********************************************************
 */
 final class Module : Package
{
      Module rootModule;
      DsymbolTable modules; // symbol table of all modules
      Modules amodules;     // массив of all modules
      Дсимволы deferred;    // deferred ДСимвол's needing semantic() run on them
      Дсимволы deferred2;   // deferred ДСимвол's needing semantic2() run on them
      Дсимволы deferred3;   // deferred ДСимвол's needing semantic3() run on them
      бцел dprogress;       // progress resolving the deferred list

    static проц _иниц()
    {
        modules = new DsymbolTable();
    }

    /**
     * Deinitializes the глоб2 state of the compiler.
     *
     * This can be используется to restore the state set by `_иниц` to its original
     * state.
     */
    static проц deinitialize()
    {
        modules = modules.init;
    }

      AggregateDeclaration moduleinfo;

    ткст arg;           // original argument имя
    ModuleDeclaration* md;      // if !=null, the contents of the ModuleDeclaration declaration
    const ИмяФайла srcfile;     // input source файл
    const ИмяФайла objfile;     // output .obj файл
    const ИмяФайла hdrfile;     // 'header' файл
    ИмяФайла docfile;           // output documentation файл
    ФайлБуфер* srcBuffer;      // set during load(), free'd in parse()
    бцел errors;                // if any errors in файл
    бцел numlines;              // number of строки in source файл
    бул isHdrFile;             // if it is a header (.di) файл
    бул isDocFile;             // if it is a documentation input файл, not D source
    бул isPackageFile;         // if it is a package.d
    Package pkg;                // if isPackageFile is да, the Package that содержит this package.d
    Strings contentImportedFiles; // массив of files whose content was imported
    цел needmoduleinfo;
    цел selfimports;            // 0: don't know, 1: does not, 2: does

    /*************************************
     * Return да if module imports itself.
     */
    бул selfImports()
    {
        //printf("Module::selfImports() %s\n", вТкст0());
        if (selfimports == 0)
        {
            for (т_мера i = 0; i < amodules.dim; i++)
                amodules[i].insearch = 0;
            selfimports = imports(this) + 1;
            for (т_мера i = 0; i < amodules.dim; i++)
                amodules[i].insearch = 0;
        }
        return selfimports == 2;
    }

    цел rootimports;            // 0: don't know, 1: does not, 2: does

    /*************************************
     * Return да if module imports root module.
     */
    бул rootImports()
    {
        //printf("Module::rootImports() %s\n", вТкст0());
        if (rootimports == 0)
        {
            for (т_мера i = 0; i < amodules.dim; i++)
                amodules[i].insearch = 0;
            rootimports = 1;
            for (т_мера i = 0; i < amodules.dim; ++i)
            {
                Module m = amodules[i];
                if (m.isRoot() && imports(m))
                {
                    rootimports = 2;
                    break;
                }
            }
            for (т_мера i = 0; i < amodules.dim; i++)
                amodules[i].insearch = 0;
        }
        return rootimports == 2;
    }

    цел insearch;
    Идентификатор2 searchCacheIdent;
    ДСимвол searchCacheSymbol;  // cached значение of search
    цел searchCacheFlags;       // cached flags

    /**
     * A root module is one that will be compiled all the way to
     * объект code.  This field holds the root module that caused
     * this module to be loaded.  If this module is a root module,
     * then it will be set to `this`.  This is используется to determine
     * ownership of template instantiation.
     */
    Module importedFrom;

    Дсимволы* decldefs;         // top уровень declarations for this Module

    Modules aimports;           // all imported modules

    бцел debuglevel;            // debug уровень
    Идентификаторы* debugids;      // debug identifiers
    Идентификаторы* debugidsNot;   // forward referenced debug identifiers

    бцел versionlevel;          // version уровень
    Идентификаторы* versionids;    // version identifiers
    Идентификаторы* versionidsNot; // forward referenced version identifiers

    MacroTable macrotable;      // document коммент macros
    Escape* escapetable;        // document коммент escapes

    т_мера nameoffset;          // смещение of module имя from start of ModuleInfo
    т_мера namelen;             // length of module имя in characters

    this(ref Место место, ткст имяф, Идентификатор2 идент, цел doDocComment, цел doHdrGen)
    {
        super(место, идент);
        ткст srcfilename;
        //printf("Module::Module(имяф = '%s', идент = '%s')\n", имяф, идент.вТкст0());
        this.arg = имяф;
        srcfilename = ИмяФайла.defaultExt(имяф, глоб2.mars_ext);
        if (глоб2.run_noext && глоб2.парамы.run &&
            !ИмяФайла.ext(имяф) &&
            ИмяФайла.exists(srcfilename) == 0 &&
            ИмяФайла.exists(имяф) == 1)
        {
            ИмяФайла.free(srcfilename.ptr);
            srcfilename = ИмяФайла.removeExt(имяф); // just does a mem.strdup(имяф)
        }
        else if (!ИмяФайла.equalsExt(srcfilename, глоб2.mars_ext) &&
                 !ИмяФайла.equalsExt(srcfilename, глоб2.hdr_ext) &&
                 !ИмяФайла.equalsExt(srcfilename, "dd"))
        {

            выведиОшибку("source файл имя '%.*s' must have .%.*s extension",
                  cast(цел)srcfilename.length, srcfilename.ptr,
                  cast(цел)глоб2.mars_ext.length, глоб2.mars_ext.ptr);
            fatal();
        }

        srcfile = ИмяФайла(srcfilename);
        objfile = setOutfilename(глоб2.парамы.objname, глоб2.парамы.objdir, имяф, глоб2.obj_ext);
        if (doDocComment)
            setDocfile();
        if (doHdrGen)
            hdrfile = setOutfilename(глоб2.парамы.hdrname, глоб2.парамы.hdrdir, arg, глоб2.hdr_ext);
        escapetable = new Escape();
    }

    this(ткст имяф, Идентификатор2 идент, цел doDocComment, цел doHdrGen)
    {
        this(Место.initial, имяф, идент, doDocComment, doHdrGen);
    }

    static Module создай(ткст0 имяф, Идентификатор2 идент, цел doDocComment, цел doHdrGen)
    {
        return создай(имяф.вТкстД, идент, doDocComment, doHdrGen);
    }

    extern (D) static Module создай(ткст имяф, Идентификатор2 идент, цел doDocComment, цел doHdrGen)
    {
        return new Module(Место.initial, имяф, идент, doDocComment, doHdrGen);
    }

    static Module load(Место место, Идентификаторы* пакеты, Идентификатор2 идент)
    {
        //printf("Module::load(идент = '%s')\n", идент.вТкст0());
        // Build module имяф by turning:
        //  foo.bar.baz
        // into:
        //  foo\bar\baz
        ткст имяф = getFilename(пакеты, идент);
        // Look for the source файл
        if(auto результат = lookForSourceFile(имяф))
            имяф = результат; // leaks

        auto m = new Module(место, имяф, идент, 0, 0);

        if (!m.читай(место))
            return null;
        if (глоб2.парамы.verbose)
        {
            БуфВыв буф;
            if (пакеты)
            {
                foreach (pid; *пакеты)
                {
                    буф.пишиСтр(pid.вТкст());
                    буф.пишиБайт('.');
                }
            }
            буф.printf("%s\t(%s)", идент.вТкст0(), m.srcfile.вТкст0());
            message("import    %s", буф.peekChars());
        }
        m = m.parse();

        // Call onImport here because if the module is going to be compiled then we
        // need to determine it early because it affects semantic analysis. This is
        // being done after parsing the module so the full module имя can be taken
        // from whatever was declared in the файл.
        if (!m.isRoot() && Compiler.onImport(m))
        {
            m.importedFrom = m;
            assert(m.isRoot());
        }

        Compiler.loadModule(m);
        return m;
    }

    override ткст0 вид()
    {
        return "module";
    }

    /*********************************************
     * Combines things into output файл имя for .html and .di files.
     * Input:
     *      имя    Command line имя given for the файл, NULL if none
     *      dir     Command line directory given for the файл, NULL if none
     *      arg     Name of the source файл
     *      ext     Файл имя extension to use if 'имя' is NULL
     *      глоб2.парамы.preservePaths     get output path from arg
     *      srcfile Input файл - output файл имя must not match input файл
     */
    extern(D) ИмяФайла setOutfilename(ткст имя, ткст dir, ткст arg, ткст ext)
    {
        ткст docfilename;
        if (имя)
        {
            docfilename = имя;
        }
        else
        {
            ткст argdoc;
            БуфВыв буф;
            if (arg == "__stdin.d")
            {
                буф.printf("__stdin_%d.d", getpid());
                arg = буф[];
            }
            if (глоб2.парамы.preservePaths)
                argdoc = arg;
            else
                argdoc = ИмяФайла.имя(arg);
            // If argdoc doesn't have an absolute path, make it relative to dir
            if (!ИмяФайла.absolute(argdoc))
            {
                //ИмяФайла::ensurePathExists(dir);
                argdoc = ИмяФайла.combine(dir, argdoc);
            }
            docfilename = ИмяФайла.forceExt(argdoc, ext);
        }
        if (ИмяФайла.равен(docfilename, srcfile.вТкст()))
        {
            выведиОшибку("source файл and output файл have same имя '%s'", srcfile.вТкст0());
            fatal();
        }
        return ИмяФайла(docfilename);
    }

    extern (D) проц setDocfile()
    {
        docfile = setOutfilename(глоб2.парамы.docname, глоб2.парамы.docdir, arg, глоб2.doc_ext);
    }

    /**
     * Loads the source буфер from the given читай результат into `this.srcBuffer`.
     *
     * Will take ownership of the буфер located inside `readрезультат`.
     *
     * Параметры:
     *  место = the location
     *  readрезультат = the результат of reading a файл containing the source code
     *
     * Возвращает: `да` if successful
     */
    бул loadSourceBuffer(ref Место место, ref Файл.РезЧтения readрезультат)
    {
        //printf("Module::loadSourceBuffer('%s') файл '%s'\n", вТкст0(), srcfile.вТкст0());
        // take ownership of буфер
        srcBuffer = new ФайлБуфер(readрезультат.извлекиСрез());
        if (readрезультат.успех)
            return да;

        if (ИмяФайла.равен(srcfile.вТкст(), "объект.d"))
        {
            .выведиОшибку(место, "cannot найди source code for runtime library файл 'объект.d'");
            errorSupplemental(место, "dmd might not be correctly installed. Run 'dmd -man' for installation instructions.");
            const dmdConfFile = глоб2.inifilename.length ? ИмяФайла.canonicalName(глоб2.inifilename) : "not found";
            errorSupplemental(место, "config файл: %.*s", cast(цел)dmdConfFile.length, dmdConfFile.ptr);
        }
        else
        {
            // if module is not named 'package' but we're trying to читай 'package.d', we're looking for a package module
            бул isPackageMod = (strcmp(вТкст0(), "package") != 0) && (strcmp(srcfile.имя(), "package.d") == 0 || (strcmp(srcfile.имя(), "package.di") == 0));
            if (isPackageMod)
                .выведиОшибку(место, "importing package '%s' requires a 'package.d' файл which cannot be found in '%s'", вТкст0(), srcfile.вТкст0());
            else
                выведиОшибку(место, "is in файл '%s' which cannot be читай", srcfile.вТкст0());
        }
        if (!глоб2.gag)
        {
            /* Print path
             */
            if (глоб2.path)
            {
                foreach (i, p; *глоб2.path)
                    fprintf(stderr, "import path[%llu] = %s\n", cast(бдол)i, p);
            }
            else
                fprintf(stderr, "Specify path to файл '%s' with -I switch\n", srcfile.вТкст0());
            // fatal();
        }
        return нет;
    }

    /**
     * Reads the файл from `srcfile` and loads the source буфер.
     *
     * Параметры:
     *  место = the location
     *
     * Возвращает: `да` if successful
     * See_Also: loadSourceBuffer
     */
    бул читай(ref Место место)
    {
        if (srcBuffer)
            return да; // already читай

        //printf("Module::читай('%s') файл '%s'\n", вТкст0(), srcfile.вТкст0());
        auto readрезультат = Файл.читай(srcfile.вТкст0());

        return loadSourceBuffer(место, readрезультат);
    }

    /// syntactic parse
    Module parse()
    {
        return parseModule!(ASTCodegen)();
    }

    /// ditto
    extern (D) Module parseModule(AST)()
    {


        enum Endian { little, big}
        enum SourceEncoding { utf16, utf32}

        /*
         * Convert a буфер from UTF32 to UTF8
         * Параметры:
         *    Endian = is the буфер big/little endian
         *    буф = буфер of UTF32 данные
         * Возвращает:
         *    input буфер reencoded as UTF8
         */

        ткст UTF32ToUTF8(Endian endian)(ткст буф)
        {
            static if (endian == Endian.little)
                alias  Port.readlongLE readNext;
            else
                alias  Port.readlongBE readNext;

            if (буф.length & 3)
            {
                выведиОшибку("odd length of UTF-32 сим source %u", буф.length);
                fatal();
            }

            const бцел[] eBuf = cast(бцел[])буф;

            БуфВыв dbuf;
            dbuf.резервируй(eBuf.length);

            foreach (i; new бцел[0 .. eBuf.length])
            {
                const u = readNext(&eBuf[i]);
                if (u & ~0x7F)
                {
                    if (u > 0x10FFFF)
                    {
                        выведиОшибку("UTF-32 значение %08x greater than 0x10FFFF", u);
                        fatal();
                    }
                    dbuf.пишиЮ8(u);
                }
                else
                    dbuf.пишиБайт(u);
            }
            dbuf.пишиБайт(0); //add null terminator
            return dbuf.извлекиСрез();
        }

        /*
         * Convert a буфер from UTF16 to UTF8
         * Параметры:
         *    Endian = is the буфер big/little endian
         *    буф = буфер of UTF16 данные
         * Возвращает:
         *    input буфер reencoded as UTF8
         */

        ткст UTF16ToUTF8(Endian endian)(ткст буф)
        {
            static if (endian == Endian.little)
                alias   Port.readwordLE readNext;
            else
                alias Port.readwordBE readNext;

            if (буф.length & 1)
            {
                выведиОшибку("odd length of UTF-16 сим source %u", буф.length);
                fatal();
            }

            const ushort[] eBuf = cast(ushort[])буф;

            БуфВыв dbuf;
            dbuf.резервируй(eBuf.length);

            //i will be incremented in the loop for high codepoints
            foreach (ref i; new бцел[0 .. eBuf.length])
            {
                бцел u = readNext(&eBuf[i]);
                if (u & ~0x7F)
                {
                    if (0xD800 <= u && u < 0xDC00)
                    {
                        i++;
                        if (i >= eBuf.length)
                        {
                            выведиОшибку("surrogate UTF-16 high значение %04x at end of файл", u);
                            fatal();
                        }
                        const u2 = readNext(&eBuf[i]);
                        if (u2 < 0xDC00 || 0xE000 <= u2)
                        {
                            выведиОшибку("surrogate UTF-16 low значение %04x out of range", u2);
                            fatal();
                        }
                        u = (u - 0xD7C0) << 10;
                        u |= (u2 - 0xDC00);
                    }
                    else if (u >= 0xDC00 && u <= 0xDFFF)
                    {
                        выведиОшибку("unpaired surrogate UTF-16 значение %04x", u);
                        fatal();
                    }
                    else if (u == 0xFFFE || u == 0xFFFF)
                    {
                        выведиОшибку("illegal UTF-16 значение %04x", u);
                        fatal();
                    }
                    dbuf.пишиЮ8(u);
                }
                else
                    dbuf.пишиБайт(u);
            }
            dbuf.пишиБайт(0); //add a terminating null byte
            return dbuf.извлекиСрез();
        }

        ткст0 srcname = srcfile.вТкст0();
        //printf("Module::parse(srcname = '%s')\n", srcname);
        isPackageFile = (strcmp(srcfile.имя(), "package.d") == 0 ||
                         strcmp(srcfile.имя(), "package.di") == 0);
        ткст буф = cast(ткст) srcBuffer.данные;

        бул needsReencoding = да;
        бул hasBOM = да; //assume there's a BOM
        Endian endian;
        SourceEncoding sourceEncoding;

        if (буф.length >= 2)
        {
            /* Convert all non-UTF-8 formats to UTF-8.
             * BOM : http://www.unicode.org/faq/utf_bom.html
             * 00 00 FE FF  UTF-32BE, big-endian
             * FF FE 00 00  UTF-32LE, little-endian
             * FE FF        UTF-16BE, big-endian
             * FF FE        UTF-16LE, little-endian
             * EF BB BF     UTF-8
             */
            if (буф[0] == 0xFF && буф[1] == 0xFE)
            {
                endian = Endian.little;

                sourceEncoding = буф.length >= 4 && буф[2] == 0 && буф[3] == 0
                                 ? SourceEncoding.utf32
                                 : SourceEncoding.utf16;
            }
            else if (буф[0] == 0xFE && буф[1] == 0xFF)
            {
                endian = Endian.big;
                sourceEncoding = SourceEncoding.utf16;
            }
            else if (буф.length >= 4 && буф[0] == 0 && буф[1] == 0 && буф[2] == 0xFE && буф[3] == 0xFF)
            {
                endian = Endian.big;
                sourceEncoding = SourceEncoding.utf32;
            }
            else if (буф.length >= 3 && буф[0] == 0xEF && буф[1] == 0xBB && буф[2] == 0xBF)
            {
                needsReencoding = нет;//utf8 with BOM
            }
            else
            {
                /* There is no BOM. Make use of Arcane Jill's insight that
                 * the first сим of D source must be ASCII to
                 * figure out the encoding.
                 */
                hasBOM = нет;
                if (буф.length >= 4 && буф[1] == 0 && буф[2] == 0 && буф[3] == 0)
                {
                    endian = Endian.little;
                    sourceEncoding = SourceEncoding.utf32;
                }
                else if (буф.length >= 4 && буф[0] == 0 && буф[1] == 0 && буф[2] == 0)
                {
                    endian = Endian.big;
                    sourceEncoding = SourceEncoding.utf32;
                }
                else if (буф.length >= 2 && буф[1] == 0) //try to check for UTF-16
                {
                    endian = Endian.little;
                    sourceEncoding = SourceEncoding.utf16;
                }
                else if (буф[0] == 0)
                {
                    endian = Endian.big;
                    sourceEncoding = SourceEncoding.utf16;
                }
                else {
                    // It's UTF-8
                    needsReencoding = нет;
                    if (буф[0] >= 0x80)
                    {
                        выведиОшибку("source файл must start with BOM or ASCII character, not \\x%02X", буф[0]);
                        fatal();
                    }
                }
            }
            //throw away BOM
            if (hasBOM)
            {
                if (!needsReencoding) буф = буф[3..$];// utf-8 already
                else if (sourceEncoding == SourceEncoding.utf32) буф = буф[4..$];
                else буф = буф[2..$]; //utf 16
            }
        }
        // Assume the буфер is from memory and has not be читай from disk. Assume UTF-8.
        else if (буф.length >= 1 && (буф[0] == '\0' || буф[0] == 0x1A))
            needsReencoding = нет;
         //printf("%s, %d, %d, %d\n", srcfile.имя.вТкст0(), needsReencoding, endian == Endian.little, sourceEncoding == SourceEncoding.utf16);
        if (needsReencoding)
        {
            if (sourceEncoding == SourceEncoding.utf16)
            {
                буф = endian == Endian.little
                      ? UTF16ToUTF8!(Endian.little)(буф)
                      : UTF16ToUTF8!(Endian.big)(буф);
            }
            else
            {
                буф = endian == Endian.little
                      ? UTF32ToUTF8!(Endian.little)(буф)
                      : UTF32ToUTF8!(Endian.big)(буф);
            }
        }

        /* If it starts with the ткст "Ddoc", then it's a documentation
         * source файл.
         */
        if (буф.length>= 4 && буф[0..4] == "Ddoc")
        {
            коммент = буф.ptr + 4;
            isDocFile = да;
            if (!docfile)
                setDocfile();
            return this;
        }
        /* If it has the extension ".dd", it is also a documentation
         * source файл. Documentation source files may begin with "Ddoc"
         * but do not have to if they have the .dd extension.
         * https://issues.dlang.org/show_bug.cgi?ид=15465
         */
        if (ИмяФайла.equalsExt(arg, "dd"))
        {
            коммент = буф.ptr; // the optional Ddoc, if present, is handled above.
            isDocFile = да;
            if (!docfile)
                setDocfile();
            return this;
        }
        /* If it has the extension ".di", it is a "header" файл.
         */
        if (ИмяФайла.equalsExt(arg, "di"))
        {
            isHdrFile = да;
        }
        {
            scope p = new Parser!(AST)(this, буф, cast(бул) docfile);
            p.nextToken();
            члены = p.parseModule();
            md = p.md;
            numlines = p.scanloc.номстр;
        }
        srcBuffer.разрушь();
        srcBuffer = null;
        /* The symbol table into which the module is to be inserted.
         */
        DsymbolTable dst;
        if (md)
        {
            /* A ModuleDeclaration, md, was provided.
             * The ModuleDeclaration sets the пакеты this module appears in, and
             * the имя of this module.
             */
            this.идент = md.ид;
            Package ppack = null;
            dst = Package.resolve(md.пакеты, &this.родитель, &ppack);
            assert(dst);
            Module m = ppack ? ppack.isModule() : null;
            if (m && (strcmp(m.srcfile.имя(), "package.d") != 0 &&
                      strcmp(m.srcfile.имя(), "package.di") != 0))
            {
                .выведиОшибку(md.место, "package имя '%s' conflicts with использование as a module имя in файл %s", ppack.toPrettyChars(), m.srcfile.вТкст0());
            }
        }
        else
        {
            /* The имя of the module is set to the source файл имя.
             * There are no пакеты.
             */
            dst = modules; // and so this module goes into глоб2 module symbol table
            /* Check to see if module имя is a valid идентификатор
             */
            if (!Идентификатор2.isValidIdentifier(this.идент.вТкст0()))
                выведиОшибку("has non-идентификатор characters in имяф, use module declaration instead");
        }
        // Insert module into the symbol table
        ДСимвол s = this;
        if (isPackageFile)
        {
            /* If the source tree is as follows:
             *     pkg/
             *     +- package.d
             *     +- common.d
             * the 'pkg' will be incorporated to the internal package tree in two ways:
             *     import pkg;
             * and:
             *     import pkg.common;
             *
             * If both are используется in one compilation, 'pkg' as a module (== pkg/package.d)
             * and a package имя 'pkg' will conflict each other.
             *
             * To avoid the conflict:
             * 1. If preceding package имя insertion had occurred by Package::resolve,
             *    reuse the previous wrapping 'Package' if it exists
             * 2. Otherwise, 'package.d' wrapped by 'Package' is inserted to the internal tree in here.
             *
             * Then change Package::isPkgMod to PKG.module_ and set Package::mod.
             *
             * Note that the 'wrapping Package' is the Package that содержит package.d and other submodules,
             * the one inserted to the symbol table.
             */
            auto ps = dst.lookup(идент);
            Package p = ps ? ps.isPackage() : null;
            if (p is null)
            {
                p = new Package(Место.initial, идент);
                p.tag = this.tag; // reuse the same package tag
                p.symtab = new DsymbolTable();
            }
            this.tag = p.tag; // reuse the 'older' package tag
            this.pkg = p;
            p.родитель = this.родитель;
            p.isPkgMod = PKG.module_;
            p.mod = this;
            s = p;
        }
        if (!dst.вставь(s))
        {
            /* It conflicts with a имя that is already in the symbol table.
             * Figure out what went wrong, and issue error message.
             */
            ДСимвол prev = dst.lookup(идент);
            assert(prev);
            if (Module mprev = prev.isModule())
            {
                if (!ИмяФайла.равен(srcname, mprev.srcfile.вТкст0()))
                    выведиОшибку(место, "from файл %s conflicts with another module %s from файл %s", srcname, mprev.вТкст0(), mprev.srcfile.вТкст0());
                else if (isRoot() && mprev.isRoot())
                    выведиОшибку(место, "from файл %s is specified twice on the command line", srcname);
                else
                    выведиОшибку(место, "from файл %s must be imported with 'import %s;'", srcname, toPrettyChars());
                // https://issues.dlang.org/show_bug.cgi?ид=14446
                // Return previously parsed module to avoid AST duplication ICE.
                return mprev;
            }
            else if (Package pkg = prev.isPackage())
            {
                // 'package.d' loaded after a previous 'Package' insertion
                if (isPackageFile)
                    amodules.сунь(this); // Add to глоб2 массив of all modules
                else
                    выведиОшибку(md ? md.место : место, "from файл %s conflicts with package имя %s", srcname, pkg.вТкст0());
            }
            else
                assert(глоб2.errors);
        }
        else
        {
            // Add to глоб2 массив of all modules
            amodules.сунь(this);
        }
        return this;
    }

    override проц importAll(Scope* prevsc)
    {
        //printf("+Module::importAll(this = %p, '%s'): родитель = %p\n", this, вТкст0(), родитель);
        if (_scope)
            return; // already done
        if (isDocFile)
        {
            выведиОшибку("is a Ddoc файл, cannot import it");
            return;
        }

        /* Note that modules get their own scope, from scratch.
         * This is so regardless of where in the syntax a module
         * gets imported, it is unaffected by context.
         * Ignore prevsc.
         */
        Scope* sc = Scope.createGlobal(this); // создай root scope

        if (md && md.msg)
            md.msg = semanticString(sc, md.msg, "deprecation message");

        // Add import of "объект", even for the "объект" module.
        // If it isn't there, some compiler rewrites, like
        //    classinst == classinst -> .объект.opEquals(classinst, classinst)
        // would fail inside объект.d.
        if (члены.dim == 0 || (*члены)[0].идент != Id.объект ||
            (*члены)[0].isImport() is null)
        {
            auto im = new Импорт(Место.initial, null, Id.объект, null, 0);
            члены.shift(im);
        }
        if (!symtab)
        {
            // Add all symbols into module's symbol table
            symtab = new DsymbolTable();
            for (т_мера i = 0; i < члены.dim; i++)
            {
                ДСимвол s = (*члены)[i];
                s.addMember(sc, sc.scopesym);
            }
        }
        // anything else should be run after addMember, so version/debug symbols are defined
        /* Set scope for the symbols so that if we forward reference
         * a symbol, it can possibly be resolved on the spot.
         * If this works out well, it can be extended to all modules
         * before any semantic() on any of them.
         */
        setScope(sc); // remember module scope for semantic
        for (т_мера i = 0; i < члены.dim; i++)
        {
            ДСимвол s = (*члены)[i];
            s.setScope(sc);
        }
        for (т_мера i = 0; i < члены.dim; i++)
        {
            ДСимвол s = (*члены)[i];
            s.importAll(sc);
        }
        sc = sc.вынь();
        sc.вынь(); // 2 pops because Scope::createGlobal() created 2
    }

    /**********************************
     * Determine if we need to generate an instance of ModuleInfo
     * for this Module.
     */
    цел needModuleInfo()
    {
        //printf("needModuleInfo() %s, %d, %d\n", вТкст0(), needmoduleinfo, глоб2.парамы.cov);
        return needmoduleinfo || глоб2.парамы.cov;
    }

    /*******************************************
     * Print deprecation warning if we're deprecated, when
     * this module is imported from scope sc.
     *
     * Параметры:
     *  sc = the scope into which we are imported
     *  место = the location of the import инструкция
     */
    проц checkImportDeprecation(ref Место место, Scope* sc)
    {
        if (md && md.isdeprecated && !sc.isDeprecated)
        {
            Выражение msg = md.msg;
            if (StringExp se = msg ? msg.вТкстExp() : null)
            {
                const slice = se.peekString();
                deprecation(место, "is deprecated - %.*s", cast(цел)slice.length, slice.ptr);
            }
            else
                deprecation(место, "is deprecated");
        }
    }

    override ДСимвол search(ref Место место, Идентификатор2 идент, цел flags = SearchLocalsOnly)
    {
        /* Since modules can be circularly referenced,
         * need to stop infinite recursive searches.
         * This is done with the cache.
         */
        //printf("%s Module.search('%s', flags = x%x) insearch = %d\n", вТкст0(), идент.вТкст0(), flags, insearch);
        if (insearch)
            return null;

        /* Qualified module searches always search their imports,
         * even if SearchLocalsOnly
         */
        if (!(flags & SearchUnqualifiedModule))
            flags &= ~(SearchUnqualifiedModule | SearchLocalsOnly);

        if (searchCacheIdent == идент && searchCacheFlags == flags)
        {
            //printf("%s Module::search('%s', flags = %d) insearch = %d searchCacheSymbol = %s\n",
            //        вТкст0(), идент.вТкст0(), flags, insearch, searchCacheSymbol ? searchCacheSymbol.вТкст0() : "null");
            return searchCacheSymbol;
        }

        бцел errors = глоб2.errors;

        insearch = 1;
        ДСимвол s = ScopeDsymbol.search(место, идент, flags);
        insearch = 0;

        if (errors == глоб2.errors)
        {
            // https://issues.dlang.org/show_bug.cgi?ид=10752
            // Can cache the результат only when it does not cause
            // access error so the side-effect should be reproduced in later search.
            searchCacheIdent = идент;
            searchCacheSymbol = s;
            searchCacheFlags = flags;
        }
        return s;
    }

    override бул isPackageAccessible(Package p, Prot защита, цел flags = 0)
    {
        if (insearch) // don't follow import cycles
            return нет;
        insearch = да;
        scope (exit)
            insearch = нет;
        if (flags & IgnorePrivateImports)
            защита = Prot(Prot.Kind.public_); // only consider public imports
        return super.isPackageAccessible(p, защита);
    }

    override ДСимвол symtabInsert(ДСимвол s)
    {
        searchCacheIdent = null; // symbol is inserted, so invalidate cache
        return Package.symtabInsert(s);
    }

    проц deleteObjFile()
    {
        if (глоб2.парамы.obj)
            Файл.удали(objfile.вТкст0());
        if (docfile)
            Файл.удали(docfile.вТкст0());
    }

    /*******************************************
     * Can't run semantic on s now, try again later.
     */
    extern (D) static проц addDeferredSemantic(ДСимвол s)
    {
        //printf("Module::addDeferredSemantic('%s')\n", s.вТкст0());
        deferred.сунь(s);
    }

    extern (D) static проц addDeferredSemantic2(ДСимвол s)
    {
        //printf("Module::addDeferredSemantic2('%s')\n", s.вТкст0());
        deferred2.сунь(s);
    }

    extern (D) static проц addDeferredSemantic3(ДСимвол s)
    {
        //printf("Module::addDeferredSemantic3('%s')\n", s.вТкст0());
        deferred3.сунь(s);
    }

    /******************************************
     * Run semantic() on deferred symbols.
     */
    static проц runDeferredSemantic()
    {
        if (dprogress == 0)
            return;

         цел nested;
        if (nested)
            return;
        //if (deferred.dim) printf("+Module::runDeferredSemantic(), len = %d\n", deferred.dim);
        nested++;

        т_мера len;
        do
        {
            dprogress = 0;
            len = deferred.dim;
            if (!len)
                break;

            ДСимвол* todo;
            ДСимвол* todoalloc = null;
            ДСимвол tmp;
            if (len == 1)
            {
                todo = &tmp;
            }
            else
            {
                todo = cast(ДСимвол*)Пам.check(malloc(len * ДСимвол.sizeof));
                todoalloc = todo;
            }
            memcpy(todo, deferred.tdata(), len * ДСимвол.sizeof);
            deferred.устДим(0);

            for (т_мера i = 0; i < len; i++)
            {
                ДСимвол s = todo[i];
                s.dsymbolSemantic(null);
                //printf("deferred: %s, родитель = %s\n", s.вТкст0(), s.родитель.вТкст0());
            }
            //printf("\tdeferred.dim = %d, len = %d, dprogress = %d\n", deferred.dim, len, dprogress);
            if (todoalloc)
                free(todoalloc);
        }
        while (deferred.dim < len || dprogress); // while making progress
        nested--;
        //printf("-Module::runDeferredSemantic(), len = %d\n", deferred.dim);
    }

    static проц runDeferredSemantic2()
    {
        Module.runDeferredSemantic();

        Дсимволы* a = &Module.deferred2;
        for (т_мера i = 0; i < a.dim; i++)
        {
            ДСимвол s = (*a)[i];
            //printf("[%d] %s semantic2a\n", i, s.toPrettyChars());
            s.semantic2(null);

            if (глоб2.errors)
                break;
        }
        a.устДим(0);
    }

    static проц runDeferredSemantic3()
    {
        Module.runDeferredSemantic2();

        Дсимволы* a = &Module.deferred3;
        for (т_мера i = 0; i < a.dim; i++)
        {
            ДСимвол s = (*a)[i];
            //printf("[%d] %s semantic3a\n", i, s.toPrettyChars());
            s.semantic3(null);

            if (глоб2.errors)
                break;
        }
        a.устДим(0);
    }

    extern (D) static проц clearCache()
    {
        for (т_мера i = 0; i < amodules.dim; i++)
        {
            Module m = amodules[i];
            m.searchCacheIdent = null;
        }
    }

    /************************************
     * Recursively look at every module this module imports,
     * return да if it imports m.
     * Can be используется to detect circular imports.
     */
    цел imports(Module m)
    {
        //printf("%s Module::imports(%s)\n", вТкст0(), m.вТкст0());
        version (none)
        {
            for (т_мера i = 0; i < aimports.dim; i++)
            {
                Module mi = cast(Module)aimports.данные[i];
                printf("\t[%d] %s\n", i, mi.вТкст0());
            }
        }
        for (т_мера i = 0; i < aimports.dim; i++)
        {
            Module mi = aimports[i];
            if (mi == m)
                return да;
            if (!mi.insearch)
            {
                mi.insearch = 1;
                цел r = mi.imports(m);
                if (r)
                    return r;
            }
        }
        return нет;
    }

    бул isRoot()
    {
        return this.importedFrom == this;
    }

    // да if the module source файл is directly
    // listed in command line.
    бул isCoreModule(Идентификатор2 идент)
    {
        return this.идент == идент && родитель && родитель.идент == Id.core && !родитель.родитель;
    }

    // Back end
    цел doppelganger; // sub-module
    Symbol* cov; // private бцел[] __coverage;
    бцел* covb; // bit массив of valid code line numbers
    Symbol* sictor; // module order independent constructor
    Symbol* sctor; // module constructor
    Symbol* sdtor; // module destructor
    Symbol* ssharedctor; // module shared constructor
    Symbol* sshareddtor; // module shared destructor
    Symbol* stest; // module unit test
    Symbol* sfilename; // symbol for имяф

    override Module isModule()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }

    /***********************************************
     * Writes this module's fully-qualified имя to буф
     * Параметры:
     *    буф = The буфер to пиши to
     */
    проц fullyQualifiedName(ref БуфВыв буф)
    {
        буф.пишиСтр(идент.вТкст());

        for (auto package_ = родитель; package_ !is null; package_ = package_.родитель)
        {
            буф.преставьСтр(".");
            буф.преставьСтр(package_.идент.вТкст0());
        }
    }
}

/***********************************************************
 */
 struct ModuleDeclaration
{
    Место место;
    Идентификатор2 ид;
    Идентификаторы* пакеты;  // массив of Идентификатор2's representing пакеты
    бул isdeprecated;      // if it is a deprecated module
    Выражение msg;

    this(ref Место место, Идентификаторы* пакеты, Идентификатор2 ид, Выражение msg, бул isdeprecated)
    {
        this.место = место;
        this.пакеты = пакеты;
        this.ид = ид;
        this.msg = msg;
        this.isdeprecated = isdeprecated;
    }

     ткст0 вТкст0()
    {
        БуфВыв буф;
        if (пакеты && пакеты.dim)
        {
            foreach (pid; *пакеты)
            {
                буф.пишиСтр(pid.вТкст());
                буф.пишиБайт('.');
            }
        }
        буф.пишиСтр(ид.вТкст());
        return буф.extractChars();
    }

    /// Provide a human readable representation
    extern (D) ткст вТкст()
    {
        return this.вТкст0().вТкстД;
    }
}
