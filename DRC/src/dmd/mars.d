/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 * Entry point for DMD.
 *
 * This modules defines the entry point (main) for DMD, as well as related
 * utilities needed for arguments parsing, path manipulation, etc...
 * This файл is not shared with other compilers which use the DMD front-end.
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/mars.d, _mars.d)
 * Documentation:  https://dlang.org/phobos/dmd_mars.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/mars.d
 */

module dmd.mars;

version = NoMain;
import cidrus;

import dmd.arraytypes;
import drc.ast.AstCodegen;
import dmd.gluelayer;
import dmd.builtin;
import dmd.cond;
//import dmd.console;
import dmd.compiler;
import dmd.dinifile;
import dmd.dinterpret;
import dmd.dmodule;
import drc.doc.Doc2;
import dmd.дсимвол;
import dmd.dsymbolsem;
import drc.code.dtoh;
import dmd.errors;
import drc.ast.Expression;
import dmd.globals;
import dmd.hdrgen;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.inline;
import dmd.json;
import core.checkedint;
import core.cpuid;

version (NoMain) {} else
{
    import drc.Library;
    import dmd.link;
}
import dmd.mtype;
import dmd.objc;
import util.array;
import util.file;
import util.filename;
import util.man;
import util.outbuffer;
import util.response;
import util.rmem;
import util.string;
import util.stringtable;
import dmd.semantic2;
import dmd.semantic3;
import dmd.target;
import util.utils;
import dmd.cli : CLIUsage;
import util.filecache : ФайлКэш;
import util.longdouble;
import util.ctfloat : CTFloat;
import dmd.hdrgen;
//import core.runtime;
//import core.memory;
/**
 * Print DMD's logo on stdout
 */
private проц logo()
{
    printf("DMD%llu D Compiler %.*s\n%.*s %.*s\n",
        cast(бдол)т_мера.sizeof * 8,
        cast(цел) глоб2._version.length - 1, глоб2._version.ptr,
        cast(цел)глоб2.copyright.length, глоб2.copyright.ptr,
        cast(цел)глоб2.written.length, глоб2.written.ptr
    );
}

/**
Print DMD's logo with more debug information and error-reporting pointers.

Параметры:
    stream = output stream to print the information on
*/
extern(C) проц printInternalFailure(FILE* stream)
{
    fputs(("---\n" ~
    "ERROR: This is a compiler bug.\n" ~
            "Please report it via https://issues.dlang.org/enter_bug.cgi\n" ~
            "with, preferably, a reduced, reproducible example and the information below.\n" ~
    "DustMite (https://github.com/CyberShadow/DustMite/wiki) can help with the reduction.\n" ~
    "---\n").ptr, stream);
    stream.fprintf("DMD %.*s\n", cast(цел) глоб2._version.length - 1, глоб2._version.ptr);
    stream.printPredefinedVersions;
    stream.printGlobalConfigs();
    fputs("---\n".ptr, stream);
}

/**
 * Print DMD's использование message on stdout
 */
private проц использование()
{
    logo();
    auto help = CLIUsage.использование;
    const inifileCanon = ИмяФайла.canonicalName(глоб2.inifilename);
    printf("
Documentation: https://dlang.org/
Config файл: %.*s
Использование:
  dmd [<опция>...] <файл>...
  dmd [<опция>...] -run <файл> [<arg>...]

Where:
  <файл>           D source файл
  <arg>            Argument to pass when running the результатing program

<опция>:
  @<cmdfile>       читай arguments from cmdfile
%.*s", cast(цел)inifileCanon.length, inifileCanon.ptr, cast(цел)help.length, &help[0]);
}

/**
 * Remove generated .di files on error and exit
 */
private проц removeHdrFilesAndFail(ref Param парамы, ref Modules modules)
{
    if (парамы.doHdrGeneration)
    {
        foreach (m; modules)
        {
            if (m.isHdrFile)
                continue;
            Файл.удали(m.hdrfile.вТкст0());
        }
    }

    fatal();
}

/**
 * DMD's real entry point
 *
 * Parses command line arguments and config файл, open and читай all
 * provided source файл and do semantic analysis on them.
 *
 * Параметры:
 *   argc = Number of arguments passed via command line
 *   argv = МассивДРК of ткст arguments passed via command line
 *
 * Возвращает:
 *   Application return code
 */
version (NoMain) {} else
private цел tryMain(т_мера argc, сим** argv, ref Param парамы)
{
    Strings files;
    Strings libmodules;
    глоб2._иниц();
    // Check for malformed input
    if (argc < 1 || !argv)
    {
    Largs:
        выведиОшибку(Место.initial, "missing or null command line arguments");
        fatal();
    }
    // Convert argc/argv into arguments[] for easier handling
    Strings arguments = Strings(argc);
    for (т_мера i = 0; i < argc; i++)
    {
        if (!argv[i])
            goto Largs;
        arguments[i] = argv[i];
    }
    if (!responseExpand(arguments)) // expand response files
        выведиОшибку(Место.initial, "can't open response файл");
    //for (т_мера i = 0; i < arguments.dim; ++i) printf("arguments[%d] = '%s'\n", i, arguments[i]);
    files.резервируй(arguments.dim - 1);
    // Set default values
    парамы.argv0 = arguments[0].вТкстД;

    // Temporary: Use 32 bits OMF as the default on Windows, for config parsing
    static if (TARGET.Windows)
    {
        парамы.is64bit = нет;
        парамы.mscoff = нет;
    }

    глоб2.inifilename = parse_conf_arg(&arguments);
    if (глоб2.inifilename)
    {
        // can be empty as in -conf=
        if (глоб2.inifilename.length && !ИмяФайла.exists(глоб2.inifilename))
            выведиОшибку(Место.initial, "Config файл '%.*s' does not exist.",
                  cast(цел)глоб2.inifilename.length, глоб2.inifilename.ptr);
    }
    else
    {
        version (Windows)
        {
            глоб2.inifilename = findConfFile(парамы.argv0, "sc.ini");
        }
        else version (Posix)
        {
            глоб2.inifilename = findConfFile(парамы.argv0, "dmd.conf");
        }
        else
        {
            static assert(0, "fix this");
        }
    }
    // Read the configuration файл
    const  iniReadрезультат = глоб2.inifilename.toCStringThen!(/*fn =>*/ Файл.читай(fn.ptr));
    const  inifileBuffer = iniReadрезультат.буфер.данные;
    /* Need path of configuration файл, for use in expanding @P macro
     */
    const ткст inifilepath = ИмяФайла.path(глоб2.inifilename);
    Strings sections;
    ТаблицаСтрок!(сим*) environment;
    environment._иниц(7);
    /* Read the [Environment] section, so we can later
     * pick up any DFLAGS settings.
     */
    sections.сунь("Environment");
    parseConfFile(environment, глоб2.inifilename, inifilepath, inifileBuffer, &sections);

    const ткст0 arch = парамы.is64bit ? "64" : "32"; // use default
    arch = parse_arch_arg(&arguments, arch);

    // parse architecture from DFLAGS читай from [Environment] section
    {
        Strings dflags;
        getenv_setargv(readFromEnv(environment, "DFLAGS"), &dflags);
        environment.сбрось(7); // erase cached environment updates
        arch = parse_arch_arg(&dflags, arch);
    }

    бул is64bit = arch[0] == '6';

    version(Windows) // delete LIB entry in [Environment] (necessary for optlink) to allow inheriting environment for MS-COFF
        if (is64bit || strcmp(arch, "32mscoff") == 0)
            environment.update("LIB", 3).значение = null;

    // читай from DFLAGS in [Environment{arch}] section
    сим[80] envsection = проц;
    sprintf(envsection.ptr, "Environment%s", arch);
    sections.сунь(envsection.ptr);
    parseConfFile(environment, глоб2.inifilename, inifilepath, inifileBuffer, &sections);
    getenv_setargv(readFromEnv(environment, "DFLAGS"), &arguments);
    updateRealEnvironment(environment);
    environment.сбрось(1); // don't need environment cache any more

    if (parseCommandLine(arguments, argc, парамы, files))
    {
        Место место;
        errorSupplemental(место, "run `dmd` to print the compiler manual");
        errorSupplemental(место, "run `dmd -man` to open browser on manual");
        return EXIT_FAILURE;
    }

    if (парамы.использование)
    {
        использование();
        return EXIT_SUCCESS;
    }

    if (парамы.logo)
    {
        logo();
        return EXIT_SUCCESS;
    }

    /*
    Prints a supplied использование text to the console and
    returns the exit code for the help использование page.

    Возвращает:
        `EXIT_SUCCESS` if no errors occurred, `EXIT_FAILURE` otherwise
    */
    static цел printHelpUsage(ткст help)
    {
        printf("%.*s", cast(цел)help.length, &help[0]);
        return глоб2.errors ? EXIT_FAILURE : EXIT_SUCCESS;
    }

    /*
    Generates code to check for all `парамы` whether any использование page
    has been requested.
    If so, the generated code will print the help page of the флаг
    and return with an exit code.

    Параметры:
        парамы = parameters with `Использование` suffices in `парамы` for which
        their truthness should be checked.

    Возвращает: generated code for checking the использование pages of the provided `парамы`.
    */
    static ткст generateUsageChecks(ткст[] парамы)
    {
        ткст s;
        foreach (n; парамы)
        {
            /+
            s ~= q{
                if (парамы.}~n~q{Использование)
                    return printHelpUsage(CLIUsage.}~n~q{Использование);
            };
            +/
        }
        return s;
    }

    mixin(generateUsageChecks(["mcpu", "transition", "check", "checkAction",
        "preview", "revert", "externStd"]));

    if (парамы.manual)
    {
        version (Windows)
        {
            browse("http://dlang.org/dmd-windows.html");
        }
        version (linux)
        {
            browse("http://dlang.org/dmd-linux.html");
        }
        version (OSX)
        {
            browse("http://dlang.org/dmd-osx.html");
        }
        version (FreeBSD)
        {
            browse("http://dlang.org/dmd-freebsd.html");
        }
        /*NOTE: No regular builds for openbsd/dragonflybsd (yet) */
        /*
        version (OpenBSD)
        {
            browse("http://dlang.org/dmd-openbsd.html");
        }
        version (DragonFlyBSD)
        {
            browse("http://dlang.org/dmd-dragonflybsd.html");
        }
        */
        return EXIT_SUCCESS;
    }

    if (парамы.color)
        глоб2.console = Console.создай(core.stdc.stdio.stderr);

    setTarget(парамы);           // set target operating system
    setTargetCPU(парамы);
    if (парамы.is64bit != is64bit)
        выведиОшибку(Место.initial, "the architecture must not be changed in the %s section of %.*s",
              envsection.ptr, cast(цел)глоб2.inifilename.length, глоб2.inifilename.ptr);

    if (глоб2.errors)
    {
        fatal();
    }
    if (files.dim == 0)
    {
        if (парамы.jsonFieldFlags)
        {
            generateJson(null);
            return EXIT_SUCCESS;
        }
        использование();
        return EXIT_FAILURE;
    }

    reconcileCommands(парамы, files.dim);

    // Add in command line versions
    if (парамы.versionids)
        foreach (charz; *парамы.versionids)
            VersionCondition.addGlobalIdent(charz.вТкстД());
    if (парамы.debugids)
        foreach (charz; *парамы.debugids)
            DebugCondition.addGlobalIdent(charz.вТкстД());

    setTarget(парамы);

    // Predefined version identifiers
    addDefaultVersionIdentifiers(парамы);

    setDefaultLibrary();

    // Initialization
    Тип._иниц();
    Id.initialize();
    Module._иниц();
    target._иниц(парамы);
    Выражение._иниц();
    Objc._иниц();
    builtin_init();
    ФайлКэш._иниц();

    version(CRuntime_Microsoft)
    {
        
        initFPU();
    }

    CTFloat.initialize();

    if (парамы.verbose)
    {
        stdout.printPredefinedVersions();
        stdout.printGlobalConfigs();
    }
    //printf("%d source files\n",files.dim);

    // Build import search path

    static Strings* buildPath(Strings* imppath)
    {
        Strings* результат = null;
        if (imppath)
        {
            foreach ( path; *imppath)
            {
                Strings* a = ИмяФайла.splitPath(path);
                if (a)
                {
                    if (!результат)
                        результат = new Strings();
                    результат.приставь(a);
                }
            }
        }
        return результат;
    }

    if (парамы.mixinFile)
    {
        парамы.mixinOut = cast(БуфВыв*)Пам.check(calloc(1, БуфВыв.sizeof));
        atexit(&flushMixins); // see коммент for flushMixins
    }
    scope(exit) flushMixins();
    глоб2.path = buildPath(парамы.imppath);
    глоб2.filePath = buildPath(парамы.fileImppath);

    if (парамы.addMain)
        files.сунь("__main.d");
    // Create Modules
    Modules modules = createModules(files, libmodules);
    // Read files
    // Start by "reading" the special files (__main.d, __stdin.d)
    foreach (m; modules)
    {
        if (парамы.addMain && m.srcfile.вТкст() == "__main.d")
        {
            auto данные = arraydup("цел main(){return 0;}\0\0"); // need 2 trailing nulls for sentinel
            m.srcBuffer = new ФайлБуфер(cast(ббайт[]) данные[0 .. $-2]);
        }
        else if (m.srcfile.вТкст() == "__stdin.d")
        {
            auto буфер = readFromStdin();
            m.srcBuffer = new ФайлБуфер(буфер.извлекиСрез());
        }
    }

    foreach (m; modules)
    {
        m.читай(Место.initial);
    }

    // Parse files
    бул anydocfiles = нет;
    т_мера filecount = modules.dim;
    for (т_мера filei = 0, modi = 0; filei < filecount; filei++, modi++)
    {
        Module m = modules[modi];
        if (парамы.verbose)
            message("parse     %s", m.вТкст0());
        if (!Module.rootModule)
            Module.rootModule = m;
        m.importedFrom = m; // m.isRoot() == да
        if (!парамы.oneobj || modi == 0 || m.isDocFile)
            m.deleteObjFile();

        m.parse();
        if (m.isHdrFile)
        {
            // Remove m's объект файл from list of объект files
            for (т_мера j = 0; j < парамы.objfiles.length; j++)
            {
                if (m.objfile.вТкст0() == парамы.objfiles[j])
                {
                    парамы.objfiles.удали(j);
                    break;
                }
            }
            if (парамы.objfiles.length == 0)
                парамы.link = нет;
        }
        if (m.isDocFile)
        {
            anydocfiles = да;
            gendocfile(m);
            // Remove m from list of modules
            modules.удали(modi);
            modi--;
            // Remove m's объект файл from list of объект files
            for (т_мера j = 0; j < парамы.objfiles.length; j++)
            {
                if (m.objfile.вТкст0() == парамы.objfiles[j])
                {
                    парамы.objfiles.удали(j);
                    break;
                }
            }
            if (парамы.objfiles.length == 0)
                парамы.link = нет;
        }
    }

    if (anydocfiles && modules.dim && (парамы.oneobj || парамы.objname))
    {
        выведиОшибку(Место.initial, "conflicting Ddoc and obj generation опции");
        fatal();
    }
    if (глоб2.errors)
        fatal();

    if (парамы.doHdrGeneration)
    {
        /* Generate 'header' import files.
         * Since 'header' import files must be independent of command
         * line switches and what else is imported, they are generated
         * before any semantic analysis.
         */
        foreach (m; modules)
        {
            if (m.isHdrFile)
                continue;
            if (парамы.verbose)
                message("import    %s", m.вТкст0());
            genhdrfile(m);
        }
    }
    if (глоб2.errors)
        removeHdrFilesAndFail(парамы, modules);

    // load all unconditional imports for better symbol resolving
    foreach (m; modules)
    {
        if (парамы.verbose)
            message("importall %s", m.вТкст0());
        m.importAll(null);
    }
    if (глоб2.errors)
        removeHdrFilesAndFail(парамы, modules);

    backend_init();

    // Do semantic analysis
    foreach (m; modules)
    {
        if (парамы.verbose)
            message("semantic  %s", m.вТкст0());
        m.dsymbolSemantic(null);
    }
    //if (глоб2.errors)
    //    fatal();
    Module.dprogress = 1;
    Module.runDeferredSemantic();
    if (Module.deferred.dim)
    {
        for (т_мера i = 0; i < Module.deferred.dim; i++)
        {
            ДСимвол sd = Module.deferred[i];
            sd.выведиОшибку("unable to resolve forward reference in definition");
        }
        //fatal();
    }

    // Do pass 2 semantic analysis
    foreach (m; modules)
    {
        if (парамы.verbose)
            message("semantic2 %s", m.вТкст0());
        m.semantic2(null);
    }
    Module.runDeferredSemantic2();
    if (глоб2.errors)
        removeHdrFilesAndFail(парамы, modules);

    // Do pass 3 semantic analysis
    foreach (m; modules)
    {
        if (парамы.verbose)
            message("semantic3 %s", m.вТкст0());
        m.semantic3(null);
    }
    if (includeImports)
    {
        // Note: DO NOT USE foreach here because Module.amodules.dim can
        //       change on each iteration of the loop
        for (т_мера i = 0; i < compiledImports.dim; i++)
        {
            auto m = compiledImports[i];
            assert(m.isRoot);
            if (парамы.verbose)
                message("semantic3 %s", m.вТкст0());
            m.semantic3(null);
            modules.сунь(m);
        }
    }
    Module.runDeferredSemantic3();
    if (глоб2.errors)
        removeHdrFilesAndFail(парамы, modules);

    // Scan for functions to inline
    if (парамы.useInline)
    {
        foreach (m; modules)
        {
            if (парамы.verbose)
                message("inline scan %s", m.вТкст0());
            inlineScanModule(m);
        }
    }
    // Do not attempt to generate output files if errors or warnings occurred
    if (глоб2.errors || глоб2.warnings)
        removeHdrFilesAndFail(парамы, modules);

    // inlineScan incrementally run semantic3 of each expanded functions.
    // So deps файл generation should be moved after the inlining stage.
    if (БуфВыв* ob = парамы.moduleDeps)
    {
        foreach (i; new бцел[1 .. modules[0].aimports.dim])
            semantic3OnDependencies(modules[0].aimports[i]);

        const данные = (*ob)[];
        if (парамы.moduleDepsFile)
            writeFile(Место.initial, парамы.moduleDepsFile, данные);
        else
            printf("%.*s", cast(цел)данные.length, данные.ptr);
    }

    printCtfePerformanceStats();

    Library library = null;
    if (парамы.lib)
    {
        if (парамы.objfiles.length == 0)
        {
            выведиОшибку(Место.initial, "no input files");
            return EXIT_FAILURE;
        }
        library = Library.factory();
        library.setFilename(парамы.objdir, парамы.libname);
        // Add input объект and input library files to output library
        foreach (p; libmodules)
            library.addObject(p, null);
    }
    // Generate output files
    if (парамы.doJsonGeneration)
    {
        generateJson(&modules);
    }
    if (!глоб2.errors && парамы.doDocComments)
    {
        foreach (m; modules)
        {
            gendocfile(m);
        }
    }
    if (парамы.vcg_ast)
    {

        foreach (mod; modules)
        {
            auto буф = БуфВыв();
            буф.doindent = 1;
            moduleToBuffer(&буф, mod);

            // пиши the output to $(имяф).cg
            auto cgFilename = ИмяФайла.addExt(mod.srcfile.вТкст(), "cg");
            Файл.пиши(cgFilename.ptr, буф[]);
        }
    }

    if (глоб2.парамы.doCxxHdrGeneration)
        genCppHdrFiles(modules);

    if (глоб2.errors)
        fatal();

    if (!парамы.obj)
    {
    }
    else if (парамы.oneobj)
    {
        Module firstm;    // first module we generate code for
        foreach (m; modules)
        {
            if (m.isHdrFile)
                continue;
            if (!firstm)
            {
                firstm = m;
                obj_start(m.srcfile.вТкст0());
            }
            if (парамы.verbose)
                message("code      %s", m.вТкст0());
            genObjFile(m, нет);
        }
        if (!глоб2.errors && firstm)
        {
            obj_end(library, firstm.objfile.вТкст0());
        }
    }
    else
    {
        foreach (m; modules)
        {
            if (m.isHdrFile)
                continue;
            if (парамы.verbose)
                message("code      %s", m.вТкст0());
            obj_start(m.srcfile.вТкст0());
            genObjFile(m, парамы.multiobj);
            obj_end(library, m.objfile.вТкст0());
            obj_write_deferred(library);
            if (глоб2.errors && !парамы.lib)
                m.deleteObjFile();
        }
    }
    if (парамы.lib && !глоб2.errors)
        library.пиши();
    backend_term();
    if (глоб2.errors)
        fatal();
    цел status = EXIT_SUCCESS;
    if (!парамы.objfiles.length)
    {
        if (парамы.link)
            выведиОшибку(Место.initial, "no объект files to link");
    }
    else
    {
        if (парамы.link)
            status = runLINK();
        if (парамы.run)
        {
            if (!status)
            {
                status = runProgram();
                /* Delete .obj files and .exe файл
                 */
                foreach (m; modules)
                {
                    m.deleteObjFile();
                    if (парамы.oneobj)
                        break;
                }
                парамы.exefile.toCStringThen!(/*ef =>*/ Файл.удали(ef.ptr));
            }
        }
    }
    if (глоб2.errors || глоб2.warnings)
        removeHdrFilesAndFail(парамы, modules);

    return status;
}

private ФайлБуфер readFromStdin()
{
    const bufIncrement = 128 * 1024;
    т_мера pos = 0;
    т_мера sz = bufIncrement;

    ббайт* буфер = null;
    for (;;)
    {
        буфер = cast(ббайт*)mem.xrealloc(буфер, sz + 2); // +2 for sentinel

        // Fill up буфер
        do
        {
            assert(sz > pos);
            т_мера rlen = fread(буфер + pos, 1, sz - pos, stdin);
            pos += rlen;
            if (ferror(stdin))
            {
                выведиОшибку(Место.initial, "cannot читай from stdin, errno = %d", errno);
                fatal();
            }
            if (feof(stdin))
            {
                // We're done
                assert(pos < sz + 2);
                буфер[pos] = '\0';
                буфер[pos + 1] = '\0';
                return ФайлБуфер(буфер[0 .. pos]);
            }
        } while (pos < sz);

        // Buffer full, expand
        sz += bufIncrement;
    }

    assert(0);
}

extern (C++) проц generateJson(Modules* modules)
{
    БуфВыв буф;
    json_generate(&буф, modules);

    // Write буф to файл
    const ткст имя = глоб2.парамы.jsonfilename;
    if (имя == "-")
    {
        // Write to stdout; assume it succeeds
        т_мера n = fwrite(буф[].ptr, 1, буф.length, stdout);
        assert(n == буф.length); // keep gcc happy about return values
    }
    else
    {
        /* The имяф generation code here should be harmonized with Module.setOutfilename()
         */
        const ткст jsonfilename;
        if (имя)
        {
            jsonfilename = ИмяФайла.defaultExt(имя, глоб2.json_ext);
        }
        else
        {
            if (глоб2.парамы.objfiles.length == 0)
            {
                выведиОшибку(Место.initial, "cannot determine JSON имяф, use `-Xf=<файл>` or provide a source файл");
                fatal();
            }
            // Generate json файл имя from first obj имя
            const ткст n = глоб2.парамы.objfiles[0].вТкстД;
            n = ИмяФайла.имя(n);
            //if (!ИмяФайла::absolute(имя))
            //    имя = ИмяФайла::combine(dir, имя);
            jsonfilename = ИмяФайла.forceExt(n, глоб2.json_ext);
        }
        writeFile(Место.initial, jsonfilename, буф[]);
    }
}


version (NoMain) {} else
{
    // in druntime:
    alias extern(C) цел function(ткст[] args) MainFunc;
    extern (C) цел _d_run_main(цел argc, сим** argv, MainFunc dMain);

    // When using a C main, host DMD may not link against host druntime by default.
    version (DigitalMars)
    {
        version (Win64)
            pragma(lib, "phobos64");
        version (Win32)
        {
            version (CRuntime_Microsoft)
			{
				pragma(lib, "phobos32mscoff");
			}
            else
                pragma(lib, "phobos");
        }
    }

    extern extern(C) ткст[] rt_options;

    /**
     * DMD's entry point, C main.
     *
     * Without `-lowmem`, we need to switch to the bump-pointer allocation scheme
     * right from the start, before any module ctors are run, so we need this hook
     * before druntime is initialized and `_Dmain` is called.
     *
     * Возвращает:
     *   Return code of the application
     */
    extern (C) цел main(цел argc, сим** argv)
    {
        static if (isGCAvailable)
        {
            бул lowmem = нет;
            foreach (i; new бцел[1 .. argc])
            {
                if (strcmp(argv[i], "-lowmem") == 0)
                {
                    lowmem = да;
                    break;
                }
            }
            if (!lowmem)
            {
                ткст[] disable_options = [ "gcopt=disable:1" ];
                rt_options = disable_options;
                mem.disableGC();
            }
        }

        // initialize druntime and call _Dmain() below
        return _d_run_main(argc, argv, &_Dmain);
    }

    /**
     * Manual D main (for druntime initialization), which forwards to `tryMain`.
     *
     * Возвращает:
     *   Return code of the application
     */
    extern (C) цел _Dmain(ткст[])
    {
        static if (!isGCAvailable)
            GC.disable();

        version(D_Coverage)
        {
            // for now we need to manually set the source path
            ткст dirName(ткст path, сим separator)
            {
                for (т_мера i = path.length - 1; i > 0; i--)
                {
                    if (path[i] == separator)
                        return path[0..i];
                }
                return path;
            }
            version (Windows)
                const sourcePath = dirName(dirName(__FILE_FULL_PATH__, '\\'), '\\');
            else
                const sourcePath = dirName(dirName(__FILE_FULL_PATH__, '/'), '/');

            dmd_coverSourcePath(sourcePath);
            dmd_coverDestPath(sourcePath);
            dmd_coverSetMerge(да);
        }

        scope(failure) stderr.printInternalFailure;

        auto args = Runtime.cArgs();
        return tryMain(args.argc, cast(сим**)args.argv, глоб2.парамы);
    }
} // !NoMain

/**
 * Parses an environment variable containing command-line flags
 * and приставь them to `args`.
 *
 * This function is используется to читай the content of DFLAGS.
 * Flags are separated based on spaces and tabs.
 *
 * Параметры:
 *   envvalue = The content of an environment variable
 *   args     = МассивДРК to приставь the flags to, if any.
 */
проц getenv_setargv(ткст0 envvalue, Strings* args)
{
    if (!envvalue)
        return;

    ткст0 env = mem.xstrdup(envvalue); // создай our own writable копируй
    //printf("env = '%s'\n", env);
    while (1)
    {
        switch (*env)
        {
        case ' ':
        case '\t':
            env++;
            break;

        case 0:
            return;

        default:
        {
            args.сунь(env); // приставь
            auto p = env;
            auto slash = 0;
            бул instring = нет;
            while (1)
            {
                auto c = *env++;
                switch (c)
                {
                case '"':
                    p -= (slash >> 1);
                    if (slash & 1)
                    {
                        p--;
                        goto default;
                    }
                    instring ^= да;
                    slash = 0;
                    continue;

                case ' ':
                case '\t':
                    if (instring)
                        goto default;
                    *p = 0;
                    //if (wildcard)
                    //    wildcardexpand();     // not implemented
                    break;

                case '\\':
                    slash++;
                    *p++ = c;
                    continue;

                case 0:
                    *p = 0;
                    //if (wildcard)
                    //    wildcardexpand();     // not implemented
                    return;

                default:
                    slash = 0;
                    *p++ = c;
                    continue;
                }
                break;
            }
            break;
        }
        }
    }
}

/**
 * Parse command line arguments for the last instance of -m32, -m64 or -m32mscoff
 * to detect the desired architecture.
 *
 * Параметры:
 *   args = Command line arguments
 *   arch = Default значение to use for architecture.
 *          Should be "32" or "64"
 *
 * Возвращает:
 *   "32", "64" or "32mscoff" if the "-m32", "-m64", "-m32mscoff" flags were passed,
 *   respectively. If they weren't, return `arch`.
 */
ткст0 parse_arch_arg(Strings* args, ткст0 arch)
{
    foreach (p; *args)
    {
        if (p[0] == '-')
        {
            if (strcmp(p + 1, "m32") == 0 || strcmp(p + 1, "m32mscoff") == 0 || strcmp(p + 1, "m64") == 0)
                arch = p + 2;
            else if (strcmp(p + 1, "run") == 0)
                break;
        }
    }
    return arch;
}


/**
 * Parse command line arguments for the last instance of -conf=path.
 *
 * Параметры:
 *   args = Command line arguments
 *
 * Возвращает:
 *   The 'path' in -conf=path, which is the path to the config файл to use
 */
ткст parse_conf_arg(Strings* args)
{
    ткст conf;
    foreach ( p; *args)
    {
        ткст arg = p.вТкстД;
        if (arg.length && arg[0] == '-')
        {
            if(arg.length >= 6 && arg[1 .. 6] == "conf="){
                conf = arg[6 .. $];
            }
            else if (arg[1 .. $] == "run")
                break;
        }
    }
    return conf;
}


/**
 * Set the default and debug libraries to link against, if not already set
 *
 * Must be called after argument parsing is done, as it won't
 * override any значение.
 * Note that if `-defaultlib=` or `-debuglib=` was используется,
 * we don't override that either.
 */
private проц setDefaultLibrary()
{
    if (глоб2.парамы.defaultlibname is null)
    {
        static if (TARGET.Windows)
        {
            if (глоб2.парамы.is64bit)
                глоб2.парамы.defaultlibname = "phobos64";
            else if (глоб2.парамы.mscoff)
                глоб2.парамы.defaultlibname = "phobos32mscoff";
            else
                глоб2.парамы.defaultlibname = "phobos";
        }
        else static if (TARGET.Linux || TARGET.FreeBSD || TARGET.OpenBSD || TARGET.Solaris || TARGET.DragonFlyBSD)
        {
            глоб2.парамы.defaultlibname = "libphobos2.a";
        }
        else static if (TARGET.OSX)
        {
            глоб2.парамы.defaultlibname = "phobos2";
        }
        else
        {
            static assert(0, "fix this");
        }
    }
    else if (!глоб2.парамы.defaultlibname.length)  // if `-defaultlib=` (i.e. an empty defaultlib)
        глоб2.парамы.defaultlibname = null;

    if (глоб2.парамы.debuglibname is null)
        глоб2.парамы.debuglibname = глоб2.парамы.defaultlibname;
}

/*************************************
 * Set the `is` target fields of `парамы` according
 * to the TARGET значение.
 * Параметры:
 *      парамы = where the `is` fields are
 */
проц setTarget(ref Param парамы)
{
    static if (TARGET.Windows)
        парамы.isWindows = да;
    else static if (TARGET.Linux)
        парамы.isLinux = да;
    else static if (TARGET.OSX)
        парамы.isOSX = да;
    else static if (TARGET.FreeBSD)
        парамы.isFreeBSD = да;
    else static if (TARGET.OpenBSD)
        парамы.isOpenBSD = да;
    else static if (TARGET.Solaris)
        парамы.isSolaris = да;
    else static if (TARGET.DragonFlyBSD)
        парамы.isDragonFlyBSD = да;
    else
        static assert(0, "unknown TARGET");
}

/**
 * Add default `version` идентификатор for dmd, and set the
 * target platform in `парамы`.
 * https://dlang.org/spec/version.html#predefined-versions
 *
 * Needs to be run after all arguments parsing (command line, DFLAGS environment
 * variable and config файл) in order to add final flags (such as `X86_64` or
 * the `CRuntime` используется).
 *
 * Параметры:
 *      парамы = which target to compile for (set by `setTarget()`)
 */
проц addDefaultVersionIdentifiers(ref Param парамы)
{
    VersionCondition.addPredefinedGlobalIdent("DigitalMars");
    if (парамы.isWindows)
    {
        VersionCondition.addPredefinedGlobalIdent("Windows");
        if (глоб2.парамы.mscoff)
        {
            VersionCondition.addPredefinedGlobalIdent("CRuntime_Microsoft");
            VersionCondition.addPredefinedGlobalIdent("CppRuntime_Microsoft");
        }
        else
        {
            VersionCondition.addPredefinedGlobalIdent("CRuntime_DigitalMars");
            VersionCondition.addPredefinedGlobalIdent("CppRuntime_DigitalMars");
        }
    }
    else if (парамы.isLinux)
    {
        VersionCondition.addPredefinedGlobalIdent("Posix");
        VersionCondition.addPredefinedGlobalIdent("linux");
        VersionCondition.addPredefinedGlobalIdent("ELFv1");
        // Note: This should be done with a target triplet, to support cross compilation.
        // However DMD currently does not support it, so this is a simple
        // fix to make DMD compile on Musl-based systems such as Alpine.
        // See https://github.com/dlang/dmd/pull/8020
        // And https://wiki.osdev.org/Target_Triplet
        version (CRuntime_Musl)
            VersionCondition.addPredefinedGlobalIdent("CRuntime_Musl");
        else
            VersionCondition.addPredefinedGlobalIdent("CRuntime_Glibc");
        VersionCondition.addPredefinedGlobalIdent("CppRuntime_Gcc");
    }
    else if (парамы.isOSX)
    {
        VersionCondition.addPredefinedGlobalIdent("Posix");
        VersionCondition.addPredefinedGlobalIdent("OSX");
        VersionCondition.addPredefinedGlobalIdent("CppRuntime_Clang");
        // For legacy compatibility
        VersionCondition.addPredefinedGlobalIdent("darwin");
    }
    else if (парамы.isFreeBSD)
    {
        VersionCondition.addPredefinedGlobalIdent("Posix");
        VersionCondition.addPredefinedGlobalIdent("FreeBSD");
        VersionCondition.addPredefinedGlobalIdent("ELFv1");
        VersionCondition.addPredefinedGlobalIdent("CppRuntime_Clang");
    }
    else if (парамы.isOpenBSD)
    {
        VersionCondition.addPredefinedGlobalIdent("Posix");
        VersionCondition.addPredefinedGlobalIdent("OpenBSD");
        VersionCondition.addPredefinedGlobalIdent("ELFv1");
        VersionCondition.addPredefinedGlobalIdent("CppRuntime_Gcc");
    }
    else if (парамы.isDragonFlyBSD)
    {
        VersionCondition.addPredefinedGlobalIdent("Posix");
        VersionCondition.addPredefinedGlobalIdent("DragonFlyBSD");
        VersionCondition.addPredefinedGlobalIdent("ELFv1");
        VersionCondition.addPredefinedGlobalIdent("CppRuntime_Gcc");
    }
    else if (парамы.isSolaris)
    {
        VersionCondition.addPredefinedGlobalIdent("Posix");
        VersionCondition.addPredefinedGlobalIdent("Solaris");
        VersionCondition.addPredefinedGlobalIdent("ELFv1");
        VersionCondition.addPredefinedGlobalIdent("CppRuntime_Sun");
    }
    else
    {
        assert(0);
    }
    VersionCondition.addPredefinedGlobalIdent("LittleEndian");
    VersionCondition.addPredefinedGlobalIdent("D_Version2");
    VersionCondition.addPredefinedGlobalIdent("all");

    if (парамы.cpu >= CPU.sse2)
    {
        VersionCondition.addPredefinedGlobalIdent("D_SIMD");
        if (парамы.cpu >= CPU.avx)
            VersionCondition.addPredefinedGlobalIdent("D_AVX");
        if (парамы.cpu >= CPU.avx2)
            VersionCondition.addPredefinedGlobalIdent("D_AVX2");
    }

    if (парамы.is64bit)
    {
        VersionCondition.addPredefinedGlobalIdent("D_InlineAsm_X86_64");
        VersionCondition.addPredefinedGlobalIdent("X86_64");
        if (парамы.isWindows)
        {
            VersionCondition.addPredefinedGlobalIdent("Win64");
        }
    }
    else
    {
        VersionCondition.addPredefinedGlobalIdent("D_InlineAsm"); //legacy
        VersionCondition.addPredefinedGlobalIdent("D_InlineAsm_X86");
        VersionCondition.addPredefinedGlobalIdent("X86");
        if (парамы.isWindows)
        {
            VersionCondition.addPredefinedGlobalIdent("Win32");
        }
    }

    if (парамы.isLP64)
        VersionCondition.addPredefinedGlobalIdent("D_LP64");
    if (парамы.doDocComments)
        VersionCondition.addPredefinedGlobalIdent("D_Ddoc");
    if (парамы.cov)
        VersionCondition.addPredefinedGlobalIdent("D_Coverage");
    if (парамы.pic != PIC.fixed)
        VersionCondition.addPredefinedGlobalIdent(парамы.pic == PIC.pic ? "D_PIC" : "D_PIE");
    if (парамы.useUnitTests)
        VersionCondition.addPredefinedGlobalIdent("unittest");
    if (парамы.useAssert == CHECKENABLE.on)
        VersionCondition.addPredefinedGlobalIdent("assert");
    if (парамы.useArrayBounds == CHECKENABLE.off)
        VersionCondition.addPredefinedGlobalIdent("D_NoBoundsChecks");
    if (парамы.betterC)
    {
        VersionCondition.addPredefinedGlobalIdent("D_BetterC");
    }
    else
    {
        VersionCondition.addPredefinedGlobalIdent("D_ModuleInfo");
        VersionCondition.addPredefinedGlobalIdent("D_Exceptions");
        VersionCondition.addPredefinedGlobalIdent("D_TypeInfo");
    }

    VersionCondition.addPredefinedGlobalIdent("D_HardFloat");
}

private проц printPredefinedVersions(FILE* stream)
{
    if (глоб2.versionids)
    {
        БуфВыв буф;
        foreach (str; *глоб2.versionids)
        {
            буф.пишиБайт(' ');
            буф.пишиСтр(str.вТкст0());
        }
        stream.fprintf("predefs  %s\n", буф.peekChars());
    }
}

extern(C) проц printGlobalConfigs(FILE* stream)
{
    stream.fprintf("binary    %.*s\n", cast(цел)глоб2.парамы.argv0.length, глоб2.парамы.argv0.ptr);
    stream.fprintf("version   %.*s\n", cast(цел) глоб2._version.length - 1, глоб2._version.ptr);
    const iniOutput = глоб2.inifilename ? глоб2.inifilename : "(none)";
    stream.fprintf("config    %.*s\n", cast(цел)iniOutput.length, iniOutput.ptr);
    // Print DFLAGS environment variable
    {
        ТаблицаСтрок!(сим*) environment;
        environment._иниц(0);
        Strings dflags;
        getenv_setargv(readFromEnv(environment, "DFLAGS"), &dflags);
        environment.сбрось(1);
        БуфВыв буф;
        foreach (флаг; dflags[])
        {
            бул needsQuoting;
            foreach (c; флаг.вТкстД())
            {
                if (!(isalnum(c) || c == '_'))
                {
                    needsQuoting = да;
                    break;
                }
            }

            if (флаг.strchr(' '))
                буф.printf("'%s' ", флаг);
            else
                буф.printf("%s ", флаг);
        }

        auto res = буф[] ? буф[][0 .. $ - 1] : "(none)";
        stream.fprintf("DFLAGS    %.*s\n", cast(цел)res.length, res.ptr);
    }
}

/****************************************
 * Determine the instruction set to be используется, i.e. set парамы.cpu
 * by combining the command line setting of
 * парамы.cpu with the target operating system.
 * Параметры:
 *      парамы = parameters set by command line switch
 */

private проц setTargetCPU(ref Param парамы)
{
    if (target.isXmmSupported())
    {
        switch (парамы.cpu)
        {
            case CPU.baseline:
                парамы.cpu = CPU.sse2;
                break;

            case CPU.native:
            {                
                парамы.cpu = core.cpuid.avx2 ? CPU.avx2 :
                             core.cpuid.avx  ? CPU.avx  :
                                               CPU.sse2;
                break;
            }

            default:
                break;
        }
    }
    else
        парамы.cpu = CPU.x87;   // cannot support other instruction sets
}

/**************************************
 * we want to пиши the mixin expansion файл also on error, but there
 * are too many ways to terminate dmd (e.g. fatal() which calls exit(EXIT_FAILURE)),
 * so we can't rely on scope(exit) ... in tryMain() actually being executed
 * so we add atexit(&flushMixins); for those fatal exits (with the GC still valid)
 */
extern(C) проц flushMixins()
{
    if (!глоб2.парамы.mixinOut)
        return;

    assert(глоб2.парамы.mixinFile);
    Файл.пиши(глоб2.парамы.mixinFile, (*глоб2.парамы.mixinOut)[]);

    глоб2.парамы.mixinOut.разрушь();
    глоб2.парамы.mixinOut = null;
}

/****************************************************
 * Parse command line arguments.
 *
 * Prints message(s) if there are errors.
 *
 * Параметры:
 *      arguments = command line arguments
 *      argc = argument count
 *      парамы = set to результат of parsing `arguments`
 *      files = set to files pulled from `arguments`
 * Возвращает:
 *      да if errors in command line
 */

бул parseCommandLine(ref Strings arguments, т_мера argc, ref Param парамы, ref Strings files)
{
    бул errors;

    проц выведиОшибку(ткст0 format, ткст0 arg = null)
    {
        dmd.errors.выведиОшибку(Место.initial, format, arg);
        errors = да;
    }

    /************************************
     * Convert ткст to integer.
     * Параметры:
     *  p = pointer to start of ткст digits, ending with 0
     *  max = max allowable значение (inclusive)
     * Возвращает:
     *  бцел.max on error, otherwise converted integer
     */
    static бцел parseDigits(ткст0p, бцел max)
    {
        бцел значение;
        бул overflow;
        for (бцел d; (d = cast(бцел)(*p) - cast(бцел)('0')) < 10; ++p)
        {
            значение = mulu(значение, 10, overflow);
            значение = addu(значение, d, overflow);
        }
        return (overflow || значение > max || *p) ? бцел.max : значение;
    }

    /********************************
     * Параметры:
     *  p = 0 terminated ткст
     *  s = ткст
     * Возвращает:
     *  да if `p` starts with `s`
     */
    static бул startsWith(ткст0 p, ткст s)
    {
        foreach ( c; s)
        {
            if (c != *p)
                return нет;
            ++p;
        }
        return да;
    }

    /**
     * Print an error messsage about an invalid switch.
     * If an optional supplemental message has been provided,
     * it will be printed too.
     *
     * Параметры:
     *  p = 0 terminated ткст
     *  availableOptions = supplemental help message listing the доступно опции
     */
    проц errorInvalidSwitch(ткст0 p, ткст availableOptions = null)
    {
        выведиОшибку("Switch `%s` is invalid", p);
        if (availableOptions !is null)
            errorSupplemental(Место.initial, "%.*s", cast(цел)availableOptions.length, availableOptions.ptr);
    }

    enum CheckOptions { успех, error, help }

    /*
    Checks whether the CLI опции содержит a valid argument or a help argument.
    If a help argument has been используется, it will set the `usageFlag`.

    Параметры:
        p = 0 terminated ткст
        usageFlag = параметр for the использование help page to set (by `ref`)
        missingMsg = error message to use when no argument has been provided

    Возвращает:
        `успех` if a valid argument has been passed and it's not a help page
        `error` if an error occurred (e.g. `-foobar`)
        `help` if a help page has been request (e.g. `-флаг` or `-флаг=h`)
    */
    CheckOptions checkOptions(ткст0 p, ref бул usageFlag, ткст missingMsg)
    {
        // Checks whether a флаг has no опции (e.g. -foo or -foo=)
        if (*p == 0 || *p == '=' && !p[1])
        {
            .выведиОшибку(Место.initial, "%.*s", cast(цел)missingMsg.length, missingMsg.ptr);
            errors = да;
            usageFlag = да;
            return CheckOptions.help;
        }
        if (*p != '=')
            return CheckOptions.error;
        p++;
        /* Checks whether the опция pointer supplied is a request
           for the help page, e.g. -foo=j */
        if (((*p == 'h' || *p == '?') && !p[1]) || // -флаг=h || -флаг=?
            strcmp(p, "help") == 0)
        {
            usageFlag = да;
            return CheckOptions.help;
        }
        return CheckOptions.успех;
    }

    static ткст checkOptionsMixin(ткст usageFlag, ткст missingMsg)
    {
        return
            "switch (checkOptions(p + len - 1, парамы."~usageFlag~","~
                          `"`~missingMsg~`"`~")"
            ~"{
                case CheckOptions.error:
                    goto Lerror;
                case CheckOptions.help:
                    return нет;
                case CheckOptions.успех:
                    break;
            }
        ";
    }

    
    бул parseCLIOption(ткст имя, Использование.Feature[] features)(ref Param парамы, ткст0 p)
    {
        // Parse:
        //      -<имя>=<feature>
        const ps = p + имя.length + 1;
        if (Идентификатор2.isValidIdentifier(ps + 1))
        {
            ткст generateTransitionsText()
            {
                ткст буф = `case "all":`;
                foreach (t; features)
                {
                    if (t.deprecated_)
                        continue;

                    буф ~= `парамы.`~t.paramName~` = да;`;
                }
                буф ~= "break;\n";

                foreach (t; features)
                {
                    буф ~= `case "`~t.имя~`":`;
                    if (t.deprecated_)
                        буф ~= "deprecation(Место.initial, \"`-"~имя~"="~t.имя~"` no longer has any effect.\"); ";
                    буф ~= `парамы.`~t.paramName~` = да; return да;`;
                }
                return буф;
            }
            const идент = ps + 1;
            switch (идент.вТкстД())
            {
                mixin(generateTransitionsText());
            default:
                return нет;
            }
        }
        return нет;
    }

    version (none)
    {
        for (т_мера i = 0; i < arguments.dim; i++)
        {
            printf("arguments[%d] = '%s'\n", i, arguments[i]);
        }
    }
    for (т_мера i = 1; i < arguments.dim; i++)
    {
        ткст0 p = arguments[i];
        ткст arg = p.вТкстД();
        if (*p != '-')
        {
            static if (TARGET.Windows)
            {
                const ext = ИмяФайла.ext(arg);
                if (ext.length && ИмяФайла.равен(ext, "exe"))
                {
                    парамы.objname = arg;
                    continue;
                }
                if (arg == "/?")
                {
                    парамы.использование = да;
                    return нет;
                }
            }
            files.сунь(p);
            continue;
        }

        if (arg == "-allinst")               // https://dlang.org/dmd.html#switch-allinst
            парамы.allInst = да;
        else if (arg == "-de")               // https://dlang.org/dmd.html#switch-de
            парамы.useDeprecated = DiagnosticReporting.error;
        else if (arg == "-d")                // https://dlang.org/dmd.html#switch-d
            парамы.useDeprecated = DiagnosticReporting.off;
        else if (arg == "-dw")               // https://dlang.org/dmd.html#switch-dw
            парамы.useDeprecated = DiagnosticReporting.inform;
        else if (arg == "-c")                // https://dlang.org/dmd.html#switch-c
            парамы.link = нет;
        else if (startsWith(p + 1, "checkaction")) // https://dlang.org/dmd.html#switch-checkaction
        {
            /* Parse:
             *    -checkaction=D|C|halt|context
             */
            auto len = "-checkaction=".length;
            mixin(checkOptionsMixin("checkActionUsage",
                "`-check=<behavior>` requires a behavior"));
            if (strcmp(p + len, "D") == 0)
                парамы.checkAction = CHECKACTION.D;
            else if (strcmp(p + len, "C") == 0)
                парамы.checkAction = CHECKACTION.C;
            else if (strcmp(p + len, "halt") == 0)
                парамы.checkAction = CHECKACTION.halt;
            else if (strcmp(p + len, "context") == 0)
                парамы.checkAction = CHECKACTION.context;
            else
            {
                errorInvalidSwitch(p);
                парамы.checkActionUsage = да;
                return нет;
            }
        }
        else if (startsWith(p + 1, "check")) // https://dlang.org/dmd.html#switch-check
        {
            auto len = "-check=".length;
            mixin(checkOptionsMixin("checkUsage",
                "`-check=<action>` requires an action"));
            /* Parse:
             *    -check=[assert|bounds|in|invariant|out|switch][=[on|off]]
             */

            // Check for legal опция ткст; return да if so
            static бул check(ткст0 p, ткст имя, ref CHECKENABLE ce)
            {
                p += len;
                if (startsWith(p, имя))
                {
                    p += имя.length;
                    if (*p == 0 ||
                        strcmp(p, "=on") == 0)
                    {
                        ce = CHECKENABLE.on;
                        return да;
                    }
                    else if (strcmp(p, "=off") == 0)
                    {
                        ce = CHECKENABLE.off;
                        return да;
                    }
                }
                return нет;
            }

            if (!(check(p, "assert",    парамы.useAssert     ) ||
                  check(p, "bounds",    парамы.useArrayBounds) ||
                  check(p, "in",        парамы.useIn         ) ||
                  check(p, "invariant", парамы.useInvariants ) ||
                  check(p, "out",       парамы.useOut        ) ||
                  check(p, "switch",    парамы.useSwitchError)))
            {
                errorInvalidSwitch(p);
                парамы.checkUsage = да;
                return нет;
            }
        }
        else if (startsWith(p + 1, "color")) // https://dlang.org/dmd.html#switch-color
        {
            // Parse:
            //      -color
            //      -color=auto|on|off
            if (p[6] == '=')
            {
                if (strcmp(p + 7, "on") == 0)
                    парамы.color = да;
                else if (strcmp(p + 7, "off") == 0)
                    парамы.color = нет;
                else if (strcmp(p + 7, "auto") != 0)
                {
                    errorInvalidSwitch(p, "Available опции for `-color` are `on`, `off` and `auto`");
                    return да;
                }
            }
            else if (p[6])
                goto Lerror;
            else
                парамы.color = да;
        }
        else if (startsWith(p + 1, "conf=")) // https://dlang.org/dmd.html#switch-conf
        {
            // ignore, already handled above
        }
        else if (startsWith(p + 1, "cov")) // https://dlang.org/dmd.html#switch-cov
        {
            парамы.cov = да;
            // Parse:
            //      -cov
            //      -cov=nnn
            if (p[4] == '=')
            {
                if (isdigit(cast(сим)p[5]))
                {
                    const percent = parseDigits(p + 5, 100);
                    if (percent == бцел.max)
                        goto Lerror;
                    парамы.covPercent = cast(ббайт)percent;
                }
                else
                {
                    errorInvalidSwitch(p, "Only a number can be passed to `-cov=<num>`");
                    return да;
                }
            }
            else if (p[4])
                goto Lerror;
        }
        else if (arg == "-shared")
            парамы.dll = да;
        else if (arg == "-fPIC")
        {
            static if (TARGET.Linux || TARGET.OSX || TARGET.FreeBSD || TARGET.OpenBSD || TARGET.Solaris || TARGET.DragonFlyBSD)
            {
                парамы.pic = PIC.pic;
            }
            else
            {
                goto Lerror;
            }
        }
        else if (arg == "-fPIE")
        {
            static if (TARGET.Linux || TARGET.OSX || TARGET.FreeBSD || TARGET.OpenBSD || TARGET.Solaris || TARGET.DragonFlyBSD)
            {
                парамы.pic = PIC.pie;
            }
            else
            {
                goto Lerror;
            }
        }
        else if (arg == "-map") // https://dlang.org/dmd.html#switch-map
            парамы.map = да;
        else if (arg == "-multiobj")
            парамы.multiobj = да;
        else if (startsWith(p + 1, "mixin="))
        {
            auto tmp = p + 6 + 1;
            if (!tmp[0])
                goto Lnoarg;
            парамы.mixinFile = mem.xstrdup(tmp);
        }
        else if (arg == "-g") // https://dlang.org/dmd.html#switch-g
            парамы.symdebug = 1;
        else if (arg == "-gf")
        {
            if (!парамы.symdebug)
                парамы.symdebug = 1;
            парамы.symdebugref = да;
        }
        else if (arg == "-gs")  // https://dlang.org/dmd.html#switch-gs
            парамы.alwaysframe = да;
        else if (arg == "-gx")  // https://dlang.org/dmd.html#switch-gx
            парамы.stackstomp = да;
        else if (arg == "-lowmem") // https://dlang.org/dmd.html#switch-lowmem
        {
            static if (isGCAvailable)
            {
                // ignore, already handled in C main
            }
            else
            {
                выведиОшибку("switch '%s' requires DMD to be built with '-version=GC'", arg.ptr);
                continue;
            }
        }
        else if (arg.length > 6 && arg[0..6] == "--DRT-")
        {
            continue; // skip druntime опции, e.g. используется to configure the GC
        }
        else if (arg == "-m32") // https://dlang.org/dmd.html#switch-m32
        {
            static if (TARGET.DragonFlyBSD) {
                выведиОшибку("-m32 is not supported on DragonFlyBSD, it is 64-bit only");
            } else {
                парамы.is64bit = нет;
                парамы.mscoff = нет;
            }
        }
        else if (arg == "-m64") // https://dlang.org/dmd.html#switch-m64
        {
            парамы.is64bit = да;
            static if (TARGET.Windows)
            {
                парамы.mscoff = да;
            }
        }
        else if (arg == "-m32mscoff") // https://dlang.org/dmd.html#switch-m32mscoff
        {
            static if (TARGET.Windows)
            {
                парамы.is64bit = 0;
                парамы.mscoff = да;
            }
            else
            {
                выведиОшибку("-m32mscoff can only be используется on windows");
            }
        }
        else if (strncmp(p + 1, "mscrtlib=", 9) == 0)
        {
            static if (TARGET.Windows)
            {
                парамы.mscrtlib = (p + 10).вТкстД;
            }
            else
            {
                выведиОшибку("-mscrtlib");
            }
        }
        else if (startsWith(p + 1, "profile")) // https://dlang.org/dmd.html#switch-profile
        {
            // Parse:
            //      -profile
            //      -profile=gc
            if (p[8] == '=')
            {
                if (strcmp(p + 9, "gc") == 0)
                    парамы.tracegc = да;
                else
                {
                    errorInvalidSwitch(p, "Only `gc` is allowed for `-profile`");
                    return да;
                }
            }
            else if (p[8])
                goto Lerror;
            else
                парамы.trace = да;
        }
        else if (arg == "-v") // https://dlang.org/dmd.html#switch-v
            парамы.verbose = да;
        else if (arg == "-vcg-ast")
            парамы.vcg_ast = да;
        else if (arg == "-vtls") // https://dlang.org/dmd.html#switch-vtls
            парамы.vtls = да;
        else if (arg == "-vcolumns") // https://dlang.org/dmd.html#switch-vcolumns
            парамы.showColumns = да;
        else if (arg == "-vgc") // https://dlang.org/dmd.html#switch-vgc
            парамы.vgc = да;
        else if (startsWith(p + 1, "verrors")) // https://dlang.org/dmd.html#switch-verrors
        {
            if (p[8] == '=' && isdigit(cast(сим)p[9]))
            {
                const num = parseDigits(p + 9, цел.max);
                if (num == бцел.max)
                    goto Lerror;
                парамы.errorLimit = num;
            }
            else if (startsWith(p + 9, "spec"))
            {
                парамы.showGaggedErrors = да;
            }
            else if (startsWith(p + 9, "context"))
            {
                парамы.printErrorContext = да;
            }
            else
            {
                errorInvalidSwitch(p, "Only number, `spec`, or `context` are allowed for `-verrors`");
                return да;
            }
        }
        else if (startsWith(p + 1, "verror-style="))
        {
            const style = p + 1 + "verror-style=".length;

            if (strcmp(style, "digitalmars") == 0)
                парамы.messageStyle = MessageStyle.digitalmars;
            else if (strcmp(style, "gnu") == 0)
                парамы.messageStyle = MessageStyle.gnu;
            else
                выведиОшибку("unknown error style '%s', must be 'digitalmars' or 'gnu'", style);
        }
        else if (startsWith(p + 1, "mcpu")) // https://dlang.org/dmd.html#switch-mcpu
        {
            auto len = "-mcpu=".length;
            // Parse:
            //      -mcpu=идентификатор
            mixin(checkOptionsMixin("mcpuUsage",
                "`-mcpu=<architecture>` requires an architecture"));
            if (Идентификатор2.isValidIdentifier(p + len))
            {
                const идент = p + len;
                switch (идент.вТкстД())
                {
                case "baseline":
                    парамы.cpu = CPU.baseline;
                    break;
                case "avx":
                    парамы.cpu = CPU.avx;
                    break;
                case "avx2":
                    парамы.cpu = CPU.avx2;
                    break;
                case "native":
                    парамы.cpu = CPU.native;
                    break;
                default:
                    errorInvalidSwitch(p, "Only `baseline`, `avx`, `avx2` or `native` are allowed for `-mcpu`");
                    парамы.mcpuUsage = да;
                    return нет;
                }
            }
            else
            {
                errorInvalidSwitch(p, "Only `baseline`, `avx`, `avx2` or `native` are allowed for `-mcpu`");
                парамы.mcpuUsage = да;
                return нет;
            }
        }
        else if (startsWith(p + 1, "extern-std")) // https://dlang.org/dmd.html#switch-extern-std
        {
            auto len = "-extern-std=".length;
            // Parse:
            //      -extern-std=идентификатор
            mixin(checkOptionsMixin("externStdUsage",
                "`-extern-std=<standard>` requires a standard"));
            if (strcmp(p + len, "c++98") == 0)
                парамы.cplusplus = CppStdRevision.cpp98;
            else if (strcmp(p + len, "c++11") == 0)
                парамы.cplusplus = CppStdRevision.cpp11;
            else if (strcmp(p + len, "c++14") == 0)
                парамы.cplusplus = CppStdRevision.cpp14;
            else if (strcmp(p + len, "c++17") == 0)
                парамы.cplusplus = CppStdRevision.cpp17;
            else
            {
                выведиОшибку("Switch `%s` is invalid", p);
                парамы.externStdUsage = да;
                return нет;
            }
        }
        else if (startsWith(p + 1, "transition")) // https://dlang.org/dmd.html#switch-transition
        {
            auto len = "-transition=".length;
            // Parse:
            //      -transition=number
            mixin(checkOptionsMixin("transitionUsage",
                "`-transition=<имя>` requires a имя"));
            if (!parseCLIOption!("transition", Использование.transitions)(парамы, p))
            {
                // Legacy -transition flags
                // Before DMD 2.085, DMD `-transition` was используется for all language flags
                // These are kept for backwards compatibility, but no longer documented
                if (isdigit(cast(сим)p[len]))
                {
                    const num = parseDigits(p + len, цел.max);
                    if (num == бцел.max)
                        goto Lerror;

                    // Bugzilla issue number
                    switch (num)
                    {
                        case 3449:
                            парамы.vfield = да;
                            break;
                        case 10378:
                            парамы.bug10378 = да;
                            break;
                        case 14246:
                            парамы.dtorFields = да;
                            break;
                        case 14488:
                            парамы.vcomplex = да;
                            break;
                        case 16997:
                            парамы.fix16997 = да;
                            break;
                        default:
                            выведиОшибку("Transition `%s` is invalid", p);
                            парамы.transitionUsage = да;
                            return нет;
                    }
                }
                else if (Идентификатор2.isValidIdentifier(p + len))
                {
                    const идент = p + len;
                    switch (идент.вТкстД())
                    {
                        case "import":
                            парамы.bug10378 = да;
                            break;
                        case "dtorfields":
                            парамы.dtorFields = да;
                            break;
                        case "intpromote":
                            парамы.fix16997 = да;
                            break;
                        case "markdown":
                            парамы.markdown = да;
                            break;
                        default:
                            выведиОшибку("Transition `%s` is invalid", p);
                            парамы.transitionUsage = да;
                            return нет;
                    }
                }
                errorInvalidSwitch(p);
                парамы.transitionUsage = да;
                return нет;
            }
        }
        else if (startsWith(p + 1, "preview") ) // https://dlang.org/dmd.html#switch-preview
        {
            auto len = "-preview=".length;
            // Parse:
            //      -preview=имя
            mixin(checkOptionsMixin("previewUsage",
                "`-preview=<имя>` requires a имя"));

            if (!parseCLIOption!("preview", Использование.previews)(парамы, p))
            {
                выведиОшибку("Preview `%s` is invalid", p);
                парамы.previewUsage = да;
                return нет;
            }

            if (парамы.useDIP1021)
                парамы.vsafe = да;    // dip1021 implies dip1000

            // копируй previously standalone flags from -transition
            // -preview=dip1000 implies -preview=dip25 too
            if (парамы.vsafe)
                парамы.useDIP25 = да;
        }
        else if (startsWith(p + 1, "revert") ) // https://dlang.org/dmd.html#switch-revert
        {
            auto len = "-revert=".length;
            // Parse:
            //      -revert=имя
            mixin(checkOptionsMixin("revertUsage",
                "`-revert=<имя>` requires a имя"));

            if (!parseCLIOption!("revert", Использование.reverts)(парамы, p))
            {
                выведиОшибку("Revert `%s` is invalid", p);
                парамы.revertUsage = да;
                return нет;
            }

            if (парамы.noDIP25)
                парамы.useDIP25 = нет;
        }
        else if (arg == "-w")   // https://dlang.org/dmd.html#switch-w
            парамы.warnings = DiagnosticReporting.error;
        else if (arg == "-wi")  // https://dlang.org/dmd.html#switch-wi
            парамы.warnings = DiagnosticReporting.inform;
        else if (arg == "-O")   // https://dlang.org/dmd.html#switch-O
            парамы.optimize = да;
        else if (p[1] == 'o')
        {
            ткст0 path;
            switch (p[2])
            {
            case '-':                       // https://dlang.org/dmd.html#switch-o-
                парамы.obj = нет;
                break;
            case 'd':                       // https://dlang.org/dmd.html#switch-od
                if (!p[3])
                    goto Lnoarg;
                path = p + 3 + (p[3] == '=');
                version (Windows)
                {
                    path = toWinPath(path);
                }
                парамы.objdir = path.вТкстД;
                break;
            case 'f':                       // https://dlang.org/dmd.html#switch-of
                if (!p[3])
                    goto Lnoarg;
                path = p + 3 + (p[3] == '=');
                version (Windows)
                {
                    path = toWinPath(path);
                }
                парамы.objname = path.вТкстД;
                break;
            case 'p':                       // https://dlang.org/dmd.html#switch-op
                if (p[3])
                    goto Lerror;
                парамы.preservePaths = да;
                break;
            case 0:
                выведиОшибку("-o no longer supported, use -of or -od");
                break;
            default:
                goto Lerror;
            }
        }
        else if (p[1] == 'D')       // https://dlang.org/dmd.html#switch-D
        {
            парамы.doDocComments = да;
            switch (p[2])
            {
            case 'd':               // https://dlang.org/dmd.html#switch-Dd
                if (!p[3])
                    goto Lnoarg;
                парамы.docdir = (p + 3 + (p[3] == '=')).вТкстД();
                break;
            case 'f':               // https://dlang.org/dmd.html#switch-Df
                if (!p[3])
                    goto Lnoarg;
                парамы.docname = (p + 3 + (p[3] == '=')).вТкстД();
                break;
            case 0:
                break;
            default:
                goto Lerror;
            }
        }
        else if (p[1] == 'H' && p[2] == 'C')  // https://dlang.org/dmd.html#switch-HC
        {
            парамы.doCxxHdrGeneration = да;
            switch (p[3])
            {
            case 'd':               // https://dlang.org/dmd.html#switch-HCd
                if (!p[4])
                    goto Lnoarg;
                парамы.cxxhdrdir = (p + 4 + (p[4] == '=')).вТкстД;
                break;
            case 'f':               // https://dlang.org/dmd.html#switch-HCf
                if (!p[4])
                    goto Lnoarg;
                парамы.cxxhdrname = (p + 4 + (p[4] == '=')).вТкстД;
                break;
            case 0:
                break;
            default:
                goto Lerror;
            }
        }
        else if (p[1] == 'H')       // https://dlang.org/dmd.html#switch-H
        {
            парамы.doHdrGeneration = да;
            switch (p[2])
            {
            case 'd':               // https://dlang.org/dmd.html#switch-Hd
                if (!p[3])
                    goto Lnoarg;
                парамы.hdrdir = (p + 3 + (p[3] == '=')).вТкстД;
                break;
            case 'f':               // https://dlang.org/dmd.html#switch-Hf
                if (!p[3])
                    goto Lnoarg;
                парамы.hdrname = (p + 3 + (p[3] == '=')).вТкстД;
                break;
            case 0:
                break;
            default:
                goto Lerror;
            }
        }
        else if (startsWith(p + 1, "Xcc="))
        {
            // Linking code is guarded by version (Posix):
            static if (TARGET.Linux || TARGET.OSX || TARGET.FreeBSD || TARGET.OpenBSD || TARGET.Solaris || TARGET.DragonFlyBSD)
            {
                парамы.linkswitches.сунь(p + 5);
                парамы.linkswitchIsForCC.сунь(да);
            }
            else
            {
                goto Lerror;
            }
        }
        else if (p[1] == 'X')       // https://dlang.org/dmd.html#switch-X
        {
            парамы.doJsonGeneration = да;
            switch (p[2])
            {
            case 'f':               // https://dlang.org/dmd.html#switch-Xf
                if (!p[3])
                    goto Lnoarg;
                парамы.jsonfilename = (p + 3 + (p[3] == '=')).вТкстД;
                break;
            case 'i':
                if (!p[3])
                    goto Lnoarg;
                if (p[3] != '=')
                    goto Lerror;
                if (!p[4])
                    goto Lnoarg;

                {
                    auto флаг = tryParseJsonField(p + 4);
                    if (!флаг)
                    {
                        выведиОшибку("unknown JSON field `-Xi=%s`, expected one of " ~ jsonFieldNames, p + 4);
                        continue;
                    }
                    глоб2.парамы.jsonFieldFlags |= флаг;
                }
                break;
            case 0:
                break;
            default:
                goto Lerror;
            }
        }
        else if (arg == "-ignore")      // https://dlang.org/dmd.html#switch-ignore
            парамы.ignoreUnsupportedPragmas = да;
        else if (arg == "-inline")      // https://dlang.org/dmd.html#switch-inline
        {
            парамы.useInline = да;
            парамы.hdrStripPlainFunctions = нет;
        }
        else if (arg == "-i")
            includeImports = да;
        else if (startsWith(p + 1, "i="))
        {
            includeImports = да;
            if (!p[3])
            {
                выведиОшибку("invalid опция '%s', module patterns cannot be empty", p);
            }
            else
            {
                // NOTE: we could check that the argument only содержит valid "module-pattern" characters.
                //       Invalid characters doesn't break anything but an error message to the user might
                //       be nice.
                includeModulePatterns.сунь(p + 3);
            }
        }
        else if (arg == "-dip25")       // https://dlang.org/dmd.html#switch-dip25
            парамы.useDIP25 = да;
        else if (arg == "-dip1000")
        {
            парамы.useDIP25 = да;
            парамы.vsafe = да;
        }
        else if (arg == "-dip1008")
        {
            парамы.ehnogc = да;
        }
        else if (arg == "-lib")         // https://dlang.org/dmd.html#switch-lib
            парамы.lib = да;
        else if (arg == "-nofloat")
            парамы.nofloat = да;
        else if (arg == "-quiet")
        {
            // Ignore
        }
        else if (arg == "-release")     // https://dlang.org/dmd.html#switch-release
            парамы.release = да;
        else if (arg == "-betterC")     // https://dlang.org/dmd.html#switch-betterC
            парамы.betterC = да;
        else if (arg == "-noboundscheck") // https://dlang.org/dmd.html#switch-noboundscheck
        {
            парамы.boundscheck = CHECKENABLE.off;
        }
        else if (startsWith(p + 1, "boundscheck")) // https://dlang.org/dmd.html#switch-boundscheck
        {
            // Parse:
            //      -boundscheck=[on|safeonly|off]
            if (p[12] == '=')
            {
                if (strcmp(p + 13, "on") == 0)
                {
                    парамы.boundscheck = CHECKENABLE.on;
                }
                else if (strcmp(p + 13, "safeonly") == 0)
                {
                    парамы.boundscheck = CHECKENABLE.safeonly;
                }
                else if (strcmp(p + 13, "off") == 0)
                {
                    парамы.boundscheck = CHECKENABLE.off;
                }
                else
                    goto Lerror;
            }
            else
                goto Lerror;
        }
        else if (arg == "-unittest")
            парамы.useUnitTests = да;
        else if (p[1] == 'I')              // https://dlang.org/dmd.html#switch-I
        {
            if (!парамы.imppath)
                парамы.imppath = new Strings();
            парамы.imppath.сунь(p + 2 + (p[2] == '='));
        }
        else if (p[1] == 'm' && p[2] == 'v' && p[3] == '=') // https://dlang.org/dmd.html#switch-mv
        {
            if (p[4] && strchr(p + 5, '='))
            {
                парамы.modFileAliasStrings.сунь(p + 4);
            }
            else
                goto Lerror;
        }
        else if (p[1] == 'J')             // https://dlang.org/dmd.html#switch-J
        {
            if (!парамы.fileImppath)
                парамы.fileImppath = new Strings();
            парамы.fileImppath.сунь(p + 2 + (p[2] == '='));
        }
        else if (startsWith(p + 1, "debug") && p[6] != 'l') // https://dlang.org/dmd.html#switch-debug
        {
            // Parse:
            //      -debug
            //      -debug=number
            //      -debug=идентификатор
            if (p[6] == '=')
            {
                if (isdigit(cast(сим)p[7]))
                {
                    const уровень = parseDigits(p + 7, цел.max);
                    if (уровень == бцел.max)
                        goto Lerror;

                    парамы.debuglevel = уровень;
                }
                else if (Идентификатор2.isValidIdentifier(p + 7))
                {
                    if (!парамы.debugids)
                        парамы.debugids = new МассивДРК!(сим*);
                    парамы.debugids.сунь(p + 7);
                }
                else
                    goto Lerror;
            }
            else if (p[6])
                goto Lerror;
            else
                парамы.debuglevel = 1;
        }
        else if (startsWith(p + 1, "version")) // https://dlang.org/dmd.html#switch-version
        {
            // Parse:
            //      -version=number
            //      -version=идентификатор
            if (p[8] == '=')
            {
                if (isdigit(cast(сим)p[9]))
                {
                    const уровень = parseDigits(p + 9, цел.max);
                    if (уровень == бцел.max)
                        goto Lerror;
                    парамы.versionlevel = уровень;
                }
                else if (Идентификатор2.isValidIdentifier(p + 9))
                {
                    if (!парамы.versionids)
                        парамы.versionids = new МассивДРК!(сим*);
                    парамы.versionids.сунь(p + 9);
                }
                else
                    goto Lerror;
            }
            else
                goto Lerror;
        }
        else if (arg == "--b")
            парамы.debugb = да;
        else if (arg == "--c")
            парамы.debugc = да;
        else if (arg == "--f")
            парамы.debugf = да;
        else if (arg == "--help" ||
                 arg == "-h")
        {
            парамы.использование = да;
            return нет;
        }
        else if (arg == "--r")
            парамы.debugr = да;
        else if (arg == "--version")
        {
            парамы.logo = да;
            return нет;
        }
        else if (arg == "--x")
            парамы.debugx = да;
        else if (arg == "--y")
            парамы.debugy = да;
        else if (p[1] == 'L')                        // https://dlang.org/dmd.html#switch-L
        {
            парамы.linkswitches.сунь(p + 2 + (p[2] == '='));
            парамы.linkswitchIsForCC.сунь(нет);
        }
        else if (startsWith(p + 1, "defaultlib="))   // https://dlang.org/dmd.html#switch-defaultlib
        {
            парамы.defaultlibname = (p + 1 + 11).вТкстД;
        }
        else if (startsWith(p + 1, "debuglib="))     // https://dlang.org/dmd.html#switch-debuglib
        {
            парамы.debuglibname = (p + 1 + 9).вТкстД;
        }
        else if (startsWith(p + 1, "deps"))          // https://dlang.org/dmd.html#switch-deps
        {
            if (парамы.moduleDeps)
            {
                выведиОшибку("-deps[=файл] can only be provided once!");
                break;
            }
            if (p[5] == '=')
            {
                парамы.moduleDepsFile = (p + 1 + 5).вТкстД;
                if (!парамы.moduleDepsFile[0])
                    goto Lnoarg;
            }
            else if (p[5] != '\0')
            {
                // Else output to stdout.
                goto Lerror;
            }
            парамы.moduleDeps = new БуфВыв();
        }
        else if (arg == "-main")             // https://dlang.org/dmd.html#switch-main
        {
            парамы.addMain = да;
        }
        else if (startsWith(p + 1, "man"))   // https://dlang.org/dmd.html#switch-man
        {
            парамы.manual = да;
            return нет;
        }
        else if (arg == "-run")              // https://dlang.org/dmd.html#switch-run
        {
            парамы.run = да;
            т_мера length = argc - i - 1;
            if (length)
            {
                ткст0 ext = ИмяФайла.ext(arguments[i + 1]);
                if (ext && ИмяФайла.равен(ext, "d") == 0 && ИмяФайла.равен(ext, "di") == 0)
                {
                    выведиОшибку("-run must be followed by a source файл, not '%s'", arguments[i + 1]);
                    break;
                }
                if (strcmp(arguments[i + 1], "-") == 0)
                    files.сунь("__stdin.d");
                else
                    files.сунь(arguments[i + 1]);
                парамы.runargs.устДим(length - 1);
                for (т_мера j = 0; j < length - 1; ++j)
                {
                    парамы.runargs[j] = arguments[i + 2 + j];
                }
                i += length;
            }
            else
            {
                парамы.run = нет;
                goto Lnoarg;
            }
        }
        else if (p[1] == '\0')
            files.сунь("__stdin.d");
        else
        {
        Lerror:
            выведиОшибку("unrecognized switch '%s'", arguments[i]);
            continue;
        Lnoarg:
            выведиОшибку("argument expected for switch '%s'", arguments[i]);
            continue;
        }
    }
    return errors;
}

/***********************************************
 * Adjust gathered command line switches and reconcile them.
 * Параметры:
 *      парамы = switches gathered from command line,
 *               and update in place
 *      numSrcFiles = number of source files
 */
version (NoMain) {} else
private проц reconcileCommands(ref Param парамы, т_мера numSrcFiles)
{
    static if (TARGET.OSX)
    {
        парамы.pic = PIC.pic;
    }
    static if (TARGET.Linux || TARGET.OSX || TARGET.FreeBSD || TARGET.OpenBSD || TARGET.Solaris || TARGET.DragonFlyBSD)
    {
        if (парамы.lib && парамы.dll)
            выведиОшибку(Место.initial, "cannot mix -lib and -shared");
    }
    static if (TARGET.Windows)
    {
        if (парамы.mscoff && !парамы.mscrtlib)
        {
            VSOptions vsopt;
            vsopt.initialize();
            парамы.mscrtlib = vsopt.defaultRuntimeLibrary(парамы.is64bit).вТкстД;
        }
    }

    // Target uses 64bit pointers.
    парамы.isLP64 = парамы.is64bit;

    if (парамы.boundscheck != CHECKENABLE._default)
    {
        if (парамы.useArrayBounds == CHECKENABLE._default)
            парамы.useArrayBounds = парамы.boundscheck;
    }

    if (парамы.useUnitTests)
    {
        if (парамы.useAssert == CHECKENABLE._default)
            парамы.useAssert = CHECKENABLE.on;
    }

    if (парамы.release)
    {
        if (парамы.useInvariants == CHECKENABLE._default)
            парамы.useInvariants = CHECKENABLE.off;

        if (парамы.useIn == CHECKENABLE._default)
            парамы.useIn = CHECKENABLE.off;

        if (парамы.useOut == CHECKENABLE._default)
            парамы.useOut = CHECKENABLE.off;

        if (парамы.useArrayBounds == CHECKENABLE._default)
            парамы.useArrayBounds = CHECKENABLE.safeonly;

        if (парамы.useAssert == CHECKENABLE._default)
            парамы.useAssert = CHECKENABLE.off;

        if (парамы.useSwitchError == CHECKENABLE._default)
            парамы.useSwitchError = CHECKENABLE.off;
    }
    else
    {
        if (парамы.useInvariants == CHECKENABLE._default)
            парамы.useInvariants = CHECKENABLE.on;

        if (парамы.useIn == CHECKENABLE._default)
            парамы.useIn = CHECKENABLE.on;

        if (парамы.useOut == CHECKENABLE._default)
            парамы.useOut = CHECKENABLE.on;

        if (парамы.useArrayBounds == CHECKENABLE._default)
            парамы.useArrayBounds = CHECKENABLE.on;

        if (парамы.useAssert == CHECKENABLE._default)
            парамы.useAssert = CHECKENABLE.on;

        if (парамы.useSwitchError == CHECKENABLE._default)
            парамы.useSwitchError = CHECKENABLE.on;
    }

    if (парамы.betterC)
    {
        парамы.checkAction = CHECKACTION.C;
        парамы.useModuleInfo = нет;
        парамы.useTypeInfo = нет;
        парамы.useExceptions = нет;
    }


    if (!парамы.obj || парамы.lib)
        парамы.link = нет;
    if (парамы.link)
    {
        парамы.exefile = парамы.objname;
        парамы.oneobj = да;
        if (парамы.objname)
        {
            /* Use this to имя the one объект файл with the same
             * имя as the exe файл.
             */
            парамы.objname = ИмяФайла.forceExt(парамы.objname, глоб2.obj_ext);
            /* If output directory is given, use that path rather than
             * the exe файл path.
             */
            if (парамы.objdir)
            {
                ткст имя = ИмяФайла.имя(парамы.objname);
                парамы.objname = ИмяФайла.combine(парамы.objdir, имя);
            }
        }
    }
    else if (парамы.run)
    {
        выведиОшибку(Место.initial, "flags conflict with -run");
        fatal();
    }
    else if (парамы.lib)
    {
        парамы.libname = парамы.objname;
        парамы.objname = null;
        // Haven't investigated handling these опции with multiobj
        if (!парамы.cov && !парамы.trace)
            парамы.multiobj = да;
    }
    else
    {
        if (парамы.objname && numSrcFiles)
        {
            парамы.oneobj = да;
            //выведиОшибку("multiple source files, but only one .obj имя");
            //fatal();
        }
    }

    if (парамы.noDIP25)
        парамы.useDIP25 = нет;
}

/**
Creates the list of modules based on the files provided

Files are dispatched in the various arrays
(глоб2.парамы.{ddocfiles,dllfiles,jsonfiles,etc...})
according to their extension.
Binary files are added to libmodules.

Параметры:
  files = Файл имена to dispatch
  libmodules = МассивДРК to which binaries (shared/static libs and объект files)
               will be appended

Возвращает:
  An массив of path to D modules
*/
Modules createModules(ref Strings files, ref Strings libmodules)
{
    Modules modules;
    modules.резервируй(files.dim);
    бул firstmodule = да;
    for (т_мера i = 0; i < files.dim; i++)
    {
       ткст имя;
        version (Windows)
        {
            files[i] = toWinPath(files[i]);
        }
        ткст p = files[i].вТкстД();
        p = ИмяФайла.имя(p); // strip path
        ткст ext = ИмяФайла.ext(p);
        if (ext)
        {
            /* Deduce what to do with a файл based on its extension
             */
            if (ИмяФайла.равен(ext, глоб2.obj_ext))
            {
                глоб2.парамы.objfiles.сунь(files[i]);
                libmodules.сунь(files[i]);
                continue;
            }
            if (ИмяФайла.равен(ext, глоб2.lib_ext))
            {
                глоб2.парамы.libfiles.сунь(files[i]);
                libmodules.сунь(files[i]);
                continue;
            }
            static if (TARGET.Linux || TARGET.OSX || TARGET.FreeBSD || TARGET.OpenBSD || TARGET.Solaris || TARGET.DragonFlyBSD)
            {
                if (ИмяФайла.равен(ext, глоб2.dll_ext))
                {
                    глоб2.парамы.dllfiles.сунь(files[i]);
                    libmodules.сунь(files[i]);
                    continue;
                }
            }
            if (ext == глоб2.ddoc_ext)
            {
                глоб2.парамы.ddocfiles.сунь(files[i]);
                continue;
            }
            if (ИмяФайла.равен(ext, глоб2.json_ext))
            {
                глоб2.парамы.doJsonGeneration = да;
                глоб2.парамы.jsonfilename = files[i].вТкстД;
                continue;
            }
            if (ИмяФайла.равен(ext, глоб2.map_ext))
            {
                глоб2.парамы.mapfile = files[i].вТкстД;
                continue;
            }
            static if (TARGET.Windows)
            {
                if (ИмяФайла.равен(ext, "res"))
                {
                    глоб2.парамы.resfile = files[i].вТкстД;
                    continue;
                }
                if (ИмяФайла.равен(ext, "def"))
                {
                    глоб2.парамы.deffile = files[i].вТкстД;
                    continue;
                }
                if (ИмяФайла.равен(ext, "exe"))
                {
                    assert(0); // should have already been handled
                }
            }
            /* Examine extension to see if it is a valid
             * D source файл extension
             */
            if (ИмяФайла.равен(ext, глоб2.mars_ext) || ИмяФайла.равен(ext, глоб2.hdr_ext) || ИмяФайла.равен(ext, "dd"))
            {
                имя = ИмяФайла.removeExt(p);
                if (!имя.length || имя == ".." || имя == ".")
                {
                Linvalid:
                    выведиОшибку(Место.initial, "invalid файл имя '%s'", files[i]);
                    fatal();
                }
            }
            else
            {
                выведиОшибку(Место.initial, "unrecognized файл extension %.*s", cast(цел)ext.length, ext.ptr);
                fatal();
            }
        }
        else
        {
            имя = p;
            if (!имя.length)
                goto Linvalid;
        }
        /* At this point, имя is the D source файл имя stripped of
         * its path and extension.
         */
        auto ид = Идентификатор2.idPool(имя);
        auto m = new Module(files[i].вТкстД, ид, глоб2.парамы.doDocComments, глоб2.парамы.doHdrGeneration);
        modules.сунь(m);
        if (firstmodule)
        {
            глоб2.парамы.objfiles.сунь(m.objfile.вТкст0());
            firstmodule = нет;
        }
    }
    return modules;
}
