/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * This modules defines the help texts for the CLI опции offered by DMD.
 * This файл is not shared with other compilers which use the DMD front-end.
 * However, this файл will be используется to generate the
 * $(LINK2 https://dlang.org/dmd-linux.html, online documentation) and MAN pages.
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/cli.d, _cli.d)
 * Documentation:  https://dlang.org/phobos/dmd_cli.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/cli.d
 */
module dmd.cli;

/// Битовая раскодировка TargetOS
enum TargetOS
{
    all = цел.max,
    linux = 1,
    windows = 2,
    macOS = 4,
    freeBSD = 8,
    solaris = 16,
    dragonFlyBSD = 32,
}

// Определить текущую TargetOS
version (linux)
{
    private const targetOS = TargetOS.linux;
}
else version(Windows)
{
    private const targetOS = TargetOS.windows;
}
else version(OSX)
{
    private const targetOS = TargetOS.macOS;
}
else version(FreeBSD)
{
    private const targetOS = TargetOS.freeBSD;
}
else version(DragonFlyBSD)
{
    private const targetOS = TargetOS.dragonFlyBSD;
}
else version(Solaris)
{
    private const targetOS = TargetOS.solaris;
}
else
{
    private const targetOS = TargetOS.all;
}

/**
* Проверяет, является ли `ос` текущей $(LREF TargetOS).
* Для `TargetOS.all` всегда возвращает да.
*
* Параметры:
*    ос = $(LREF TargetOS) ,  подлежащая проверке
*
*Возвращает: да, если `ос` содержит текущую targetOS.
*/
бул isCurrentTargetOS(TargetOS ос)
{
    return (ос & targetOS) > 0;
}

/**
*Деалет заглавным первый символ ASCII ткст.
*Параметры:
*    w = ASCII i ткст для озаглавления
*Возвращает: озаглавленный ткст
*/
static ткст вЗаг(ткст w)
{
    ткст результат = cast(ткст) w;
    сим c1 = w.length ? w[0] : '\0';

    if (c1 >= 'a' && c1 <= 'z')
    {
        const adjustment = 'A' - 'a';

        результат = new ткст (w.length);
        результат[0] = cast(сим) (c1 + adjustment);
        результат[1 .. $] = w[1 .. $];
    }

    return cast(ткст) результат;
}

/**
* Содержит все доступные CLI $(LREF Использование.Опция)-и.
*
*See_Also: $(LREF Использование.Опция)
*/
struct Использование
{
    /**
    * Представление CLI `Опция`
    *
    * Описание DDoc `ddoxText` доступно только при компиляции с `-version=DdocOptions`.
    */
    class Опция
    {
        ткст флаг; /// Флаг CLI без вводного `-`, напр. `color`
        ткст текстСправки; /// Подробное описание этого флага
        TargetOS ос = TargetOS.all; /// For which `TargetOS` the flags are applicable

        // Needs to be version-ed to prevent the text ending up in the binary
        // See also: https://issues.dlang.org/show_bug.cgi?ид=18238
        version(DdocOptions) ткст ddocText; /// Подробное описание этого флага (in Ddoc)

        /**
        * Параметры:
        *  флаг = CLI флаг без вводного `-`, напр. `color`
        *  текстСправки = подробное описание этого флага
        *  ос = for which `TargetOS` the flags are applicable
        *  ddocText = detailed description of the флаг (in Ddoc)
        */
        this(ткст флаг, ткст текстСправки, TargetOS ос = TargetOS.all)
        {
            this.флаг = флаг;
            this.текстСправки = текстСправки;
            version(DdocOptions) this.ddocText = текстСправки;
            this.ос = ос;
        }

        /// ditto
        this(ткст флаг, ткст текстСправки, ткст ddocText, TargetOS ос = TargetOS.all)
        {
            this.флаг = флаг;
            this.текстСправки = текстСправки;
            version(DdocOptions) this.ddocText = ddocText;
            this.ос = ос;
        }
    }

    /// Возвращает все доступные CLI опции
    static const Опция[] опции = cast(Опция[]) [
        new Опция("allinst",
            "генерировать код для всех шаблонных инстанциаций"
        ),
        new Опция("betterC",
            "omit generating some runtime information and helper functions",
            "Adjusts the compiler to implement D as a $(LINK2 $(ROOT_DIR)spec/betterc.html, better C):
            $(UL
                $(LI Predefines `D_BetterC` $(LINK2 $(ROOT_DIR)spec/version.html#predefined-versions, version).)
                $(LI $(LINK2 $(ROOT_DIR)spec/Выражение.html#AssertВыражение, Assert Выражения), when they fail,
                call the C runtime library assert failure function
                rather than a function in the D runtime.)
                $(LI $(LINK2 $(ROOT_DIR)spec/arrays.html#bounds, МассивДРК overflows)
                call the C runtime library assert failure function
                rather than a function in the D runtime.)
                $(LI $(LINK2 spec/инструкция.html#final-switch-инструкция/, Final switch errors)
                call the C runtime library assert failure function
                rather than a function in the D runtime.)
                $(LI Does not automatically link with phobos runtime library.)
                $(UNIX
                $(LI Does not generate Dwarf `eh_frame` with full unwinding information, i.e. exception tables
                are not inserted into `eh_frame`.)
                )
                $(LI Module constructors and destructors are not generated meaning that
                $(LINK2 $(ROOT_DIR)spec/class.html#StaticConstructor, static) and
                $(LINK2 $(ROOT_DIR)spec/class.html#SharedStaticConstructor, shared static constructors) and
                $(LINK2 $(ROOT_DIR)spec/class.html#StaticDestructor, destructors)
                will not get called.)
                $(LI `ModuleInfo` is not generated.)
                $(LI $(LINK2 $(ROOT_DIR)phobos/объект.html#.TypeInfo, `TypeInfo`)
                instances will not be generated for structs.)
            )"
        ),
        new Опция("boundscheck=[on|safeonly|off]",
            "bounds checks on, in  only, or off",
            `Controls if bounds checking is enabled.
                $(UL
                    $(LI $(I on): Bounds checks are enabled for all code. This is the default.)
                    $(LI $(I safeonly): Bounds checks are enabled only in $(D ) code.
                                        This is the default for $(SWLINK -release) builds.)
                    $(LI $(I off): Bounds checks are disabled completely (even in $(D )
                                   code). This опция should be используется with caution and as a
                                   last resort to improve performance. Confirm turning off
                                   $(D ) bounds checks is worthwhile by benchmarking.)
                )`
        ),
        new Опция("c",
            "compile only, do not link"
        ),
        new Опция("check=[assert|bounds|in|invariant|out|switch][=[on|off]]",
            "enable or disable specific checks",
            `Overrides default, -boundscheck, -release and -unittest опции to enable or disable specific checks.
                $(UL
                    $(LI $(B assert): assertion checking)
                    $(LI $(B bounds): массив bounds)
                    $(LI $(B in): in contracts)
                    $(LI $(B invariant): class/struct invariants)
                    $(LI $(B out): out contracts)
                    $(LI $(B switch): finalswitch failure checking)
                )
                $(UL
                    $(LI $(B on) or not specified: specified check is enabled.)
                    $(LI $(B off): specified check is disabled.)
                )`
        ),
        new Опция("check=[h|help|?]",
            "list information on all доступно checks"
        ),
        new Опция("checkaction=[D|C|halt|context]",
            "behavior on assert/boundscheck/finalswitch failure",
            `Sets behavior when an assert fails, and массив boundscheck fails,
             or a final switch errors.
                $(UL
                    $(LI $(B D): Default behavior, which throws an unrecoverable $(D AssertError).)
                    $(LI $(B C): Calls the C runtime library assert failure function.)
                    $(LI $(B halt): Executes a halt instruction, terminating the program.)
                    $(LI $(B context): Prints the error context as part of the unrecoverable $(D AssertError).)
                )`
        ),
        new Опция("checkaction=[h|help|?]",
            "list information on all доступно check actions"
        ),
        new Опция("color",
            "turn colored console output on"
        ),
        new Опция("color=[on|off|auto]",
            "force colored console output on or off, or only when not redirected (default)",
            `Show colored console output. The default depends on terminal capabilities.
            $(UL
                $(LI $(B auto): use colored output if a tty is detected (default))
                $(LI $(B on): always use colored output.)
                $(LI $(B off): never use colored output.)
            )`
        ),
        new Опция("conf=<имяф>",
            "use config файл at имяф"
        ),
        new Опция("cov",
            "do code coverage analysis"
        ),
        new Опция("cov=<nnn>",
            "require at least nnn% code coverage",
            `Perform $(LINK2 $(ROOT_DIR)code_coverage.html, code coverage analysis) and generate
            $(TT .lst) файл with report.)
---
dmd -cov -unittest myprog.d
---
            `
        ),
        new Опция("D",
            "generate documentation",
            `$(P Generate $(LINK2 $(ROOT_DIR)spec/ddoc.html, documentation) from source.)
            $(P Note: mind the $(LINK2 $(ROOT_DIR)spec/ddoc.html#security, security considerations).)
            `
        ),
        new Опция("Dd<directory>",
            "пиши documentation файл to directory",
            `Write documentation файл to $(I directory) . $(SWLINK -op)
            can be используется if the original package hierarchy should
            be retained`
        ),
        new Опция("Df<имяф>",
            "пиши documentation файл to имяф"
        ),
        new Опция("d",
            "silently allow deprecated features and symbols",
            `Silently allow $(DDLINK deprecate,deprecate,deprecated features) and use of symbols with
            $(DDSUBLINK $(ROOT_DIR)spec/attribute, deprecated, deprecated attributes).`
        ),
        new Опция("de",
            "issue an error when deprecated features or symbols are используется (halt compilation)"
        ),
        new Опция("dw",
            "issue a message when deprecated features or symbols are используется (default)"
        ),
        new Опция("debug",
            "compile in debug code",
            `Compile in $(LINK2 spec/version.html#debug, debug) code`
        ),
        new Опция("debug=<уровень>",
            "compile in debug code <= уровень",
            `Compile in $(LINK2 spec/version.html#debug, debug уровень) &lt;= $(I уровень)`
        ),
        new Опция("debug=<идент>",
            "compile in debug code identified by идент",
            `Compile in $(LINK2 spec/version.html#debug, debug идентификатор) $(I идент)`
        ),
        new Опция("debuglib=<имя>",
            "set symbolic debug library to имя",
            `Link in $(I libname) as the default library when
            compiling for symbolic debugging instead of $(B $(LIB)).
            If $(I libname) is not supplied, then no default library is linked in.`
        ),
        new Опция("defaultlib=<имя>",
            "set default library to имя",
            `Link in $(I libname) as the default library when
            not compiling for symbolic debugging instead of $(B $(LIB)).
            If $(I libname) is not supplied, then no default library is linked in.`
        ),
        new Опция("deps",
            "print module dependencies (imports/файл/version/debug/lib)"
        ),
        new Опция("deps=<имяф>",
            "пиши module dependencies to имяф (only imports)",
            `Without $(I имяф), print module dependencies
            (imports/файл/version/debug/lib).
            With $(I имяф), пиши module dependencies as text to $(I имяф)
            (only imports).`
        ),
        new Опция("extern-std=<standard>",
            "set C++ имя mangling compatibility with <standard>",
            "Standards supported are:
            $(UL
                $(LI $(I c++98) (default): Use C++98 имя mangling,
                    Sets `__traits(getTargetInfo, \"cppStd\")` to `199711`)
                $(LI $(I c++11): Use C++11 имя mangling,
                    Sets `__traits(getTargetInfo, \"cppStd\")` to `201103`)
                $(LI $(I c++14): Use C++14 имя mangling,
                    Sets `__traits(getTargetInfo, \"cppStd\")` to `201402`)
                $(LI $(I c++17): Use C++17 имя mangling,
                    Sets `__traits(getTargetInfo, \"cppStd\")` to `201703`)
            )"
        ),
        new Опция("extern-std=[h|help|?]",
            "list all supported standards"
        ),
        new Опция("fPIC",
            "generate position independent code",
            TargetOS.all & ~(TargetOS.windows | TargetOS.macOS)
        ),
        new Опция("g",
            "add symbolic debug info",
            `$(WINDOWS
                Add CodeView symbolic debug info. See
                $(LINK2 http://dlang.org/windbg.html, Debugging on Windows).
            )
            $(UNIX
                Add symbolic debug info in Dwarf format
                for debuggers such as
                $(D gdb)
            )`
        ),
        new Опция("gf",
            "emit debug info for all referenced types",
            `Symbolic debug info is emitted for all types referenced by the compiled code,
             even if the definition is in an imported файл not currently being compiled.`
        ),
        new Опция("gs",
            "always emit stack frame"
        ),
        new Опция("gx",
            "add stack stomp code",
            `Adds stack stomp code, which overwrites the stack frame memory upon function exit.`
        ),
        new Опция("H",
            "generate 'header' файл",
            `Generate $(RELATIVE_LINK2 $(ROOT_DIR)interface-files, D interface файл)`
        ),
        new Опция("Hd=<directory>",
            "пиши 'header' файл to directory",
            `Write D interface файл to $(I dir) directory. $(SWLINK -op)
            can be используется if the original package hierarchy should
            be retained.`
        ),
        new Опция("Hf=<имяф>",
            "записать файл 'header' в имяф"
        ),
        new Опция("HC",
            "generate C++ 'header' файл"
        ),
        new Опция("HCd=<directory>",
            "пиши C++ 'header' файл to directory"
        ),
        new Опция("HCf=<имяф>",
            "пиши C++ 'header' файл to имяф"
        ),
        new Опция("-help",
            "print help and exit"
        ),
        new Опция("I=<папка>",
            "папка для альтернативного поиска импортов"
        ),
        new Опция("i[=<pattern>]",
            "включить в компиляцию импортируемые модули",
            "$(P Enables 'include imports' mode, where the compiler will include imported
             modules in the compilation, as if they were given on the command line. By default, when
             this опция is enabled, all imported modules are included except those in
             druntime/phobos. This behavior can be overriden by providing patterns via `-i=<pattern>`.
             A pattern of the form `-i=<package>` is an 'inclusive pattern', whereas a pattern
             of the form `-i=-<package>` is an 'exclusive pattern'. Inclusive patterns will include
             all module's whose имена match the pattern, whereas exclusive patterns will exclude them.
             For example. all modules in the package `foo.bar` can be included using `-i=foo.bar` or excluded
             using `-i=-foo.bar`. Note that each component of the fully qualified имя must match the
             pattern completely, so the pattern `foo.bar` would not match a module named `foo.barx`.)

             $(P The default behavior of excluding druntime/phobos is accomplished by internally adding a
             set of standard exclusions, namely, `-i=-std -i=-core -i=-etc -i=-объект`. Note that these
             can be overriden with `-i=std -i=core -i=etc -i=объект`.)

             $(P When a module matches multiple patterns, matches are prioritized by their component length, where
             a match with more components takes priority (i.e. pattern `foo.bar.baz` has priority over `foo.bar`).)

             $(P By default modules that don't match any pattern will be included. However, if at
             least one inclusive pattern is given, then modules not matching any pattern will
             be excluded. This behavior can be overriden by usig `-i=.` to include by default or `-i=-.` to
             exclude by default.)

             $(P Note that multiple `-i=...` опции are allowed, each one adds a pattern.)"
        ),
        new Опция("ignore",
            "игнорировать неподдерживаемые прагмы"
        ),
        new Опция("inline",
            "выполнять инлайнинг функций",
            `Inline functions at the discretion of the compiler.
            This can improve performance, at the expense of making
            it more difficult to use a debugger on it.`
        ),
        new Опция("J=<directory>",
            "look for ткст imports also in directory",
            `Where to look for files for
            $(LINK2 $(ROOT_DIR)spec/Выражение.html#ImportВыражение, $(I ImportВыражение))s.
            This switch is required in order to use $(I ImportВыражение)s.
            $(I path) is a ; separated
            list of paths. Multiple $(B -J)'s can be используется, and the paths
            are searched in the same order.`
        ),
        new Опция("L=<linkerflag>",
            "pass linkerflag to link",
            `Pass $(I linkerflag) to the
            $(WINDOWS linker $(OPTLINK))
            $(UNIX linker), for example, ld`
        ),
        new Опция("lib",
            "generate library rather than объект files",
            `Generate library файл as output instead of объект файл(s).
            All compiled source files, as well as объект files and library
            files specified on the command line, are inserted into
            the output library.
            Compiled source modules may be partitioned into several объект
            modules to improve granularity.
            The имя of the library is taken from the имя of the first
            source module to be compiled. This имя can be overridden with
            the $(SWLINK -of) switch.`
        ),
        new Опция("lowmem",
            "enable garbage collection for the compiler",
            `Enable the garbage collector for the compiler, reducing the
            compiler memory requirements but increasing compile times.`
        ),
        new Опция("m32",
            "generate 32 bit code",
            `$(UNIX Compile a 32 bit executable. This is the default for the 32 bit dmd.)
            $(WINDOWS Compile a 32 bit executable. This is the default.
            The generated объект code is in OMF and is meant to be используется with the
            $(LINK2 http://www.digitalmars.com/download/freecompiler.html, Digital Mars C/C++ compiler)).`,
            (TargetOS.all & ~TargetOS.dragonFlyBSD)  // доступно on all OS'es except DragonFly, which does not support 32-bit binaries
        ),
        new Опция("m32mscoff",
            "generate 32 bit code and пиши MS-COFF объект files",
            TargetOS.windows
        ),
        new Опция("m64",
            "generate 64 bit code",
            `$(UNIX Compile a 64 bit executable. This is the default for the 64 bit dmd.)
            $(WINDOWS The generated объект code is in MS-COFF and is meant to be используется with the
            $(LINK2 https://msdn.microsoft.com/en-us/library/dd831853(v=vs.100).aspx, Microsoft Visual Studio 10)
            or later compiler.`
        ),
        new Опция("main",
            "add default main() (e.g. for unittesting)",
            `Add a default $(D main()) function when compiling. This is useful when
            unittesting a library, as it enables running the unittests
            in a library without having to manually define an entry-point function.`
        ),
        new Опция("man",
            "open web browser on manual page",
            `$(WINDOWS
                Open default browser on this page
            )
            $(LINUX
                Open browser specified by the $(B BROWSER)
                environment variable on this page. If $(B BROWSER) is
                undefined, $(B x-www-browser) is assumed.
            )
            $(FREEBSD
                Open browser specified by the $(B BROWSER)
                environment variable on this page. If $(B BROWSER) is
                undefined, $(B x-www-browser) is assumed.
            )
            $(OSX
                Open browser specified by the $(B BROWSER)
                environment variable on this page. If $(B BROWSER) is
                undefined, $(B Safari) is assumed.
            )`
        ),
        new Опция("map",
            "generate linker .map файл",
            `Generate a $(TT .map) файл`
        ),
        new Опция("mcpu=<ид>",
            "generate instructions for architecture identified by 'ид'",
            `Set the target architecture for code generation,
            where:
            $(DL
            $(DT help)$(DD list alternatives)
            $(DT baseline)$(DD the minimum architecture for the target platform (default))
            $(DT avx)$(DD
            generate $(LINK2 https://en.wikipedia.org/wiki/Advanced_Vector_Extensions, AVX)
            instructions instead of $(LINK2 https://en.wikipedia.org/wiki/Streaming_SIMD_Extensions, SSE)
            instructions for vector and floating point operations.
            Not доступно for 32 bit memory models other than OSX32.
            )
            $(DT native)$(DD use the architecture the compiler is running on)
            )`
        ),
        new Опция("mcpu=[h|help|?]",
            "list all architecture опции"
        ),
        new Опция("mixin=<имяф>",
            "expand and save mixins to файл specified by <имяф>"
        ),
        new Опция("mscrtlib=<libname>",
            "MS C runtime library to reference from main/WinMain/DllMain",
            "If building MS-COFF объект files with -m64 or -m32mscoff, embed a reference to
            the given C runtime library $(I libname) into the объект файл containing `main`,
            `DllMain` or `WinMain` for automatic linking. The default is $(TT libcmt)
            (release version with static компонаж), the other usual alternatives are
            $(TT libcmtd), $(TT msvcrt) and $(TT msvcrtd).
            If no Visual C installation is detected, a wrapper for the redistributable
            VC2010 dynamic runtime library and mingw based platform import libraries will
            be linked instead using the LLD linker provided by the LLVM project.
            The detection can be skipped explicitly if $(TT msvcrt120) is specified as
            $(I libname).
            If $(I libname) is empty, no C runtime library is automatically linked in.",
            TargetOS.windows
        ),
        new Опция("mv=<package.module>=<filespec>",
            "use <filespec> as source файл for <package.module>",
            `Use $(I path/имяф) as the source файл for $(I package.module).
            This is используется when the source файл path and имена are not the same
            as the package and module hierarchy.
            The rightmost components of the  $(I path/имяф) and $(I package.module)
            can be omitted if they are the same.`
        ),
        new Опция("noboundscheck",
            "no массив bounds checking (deprecated, use -boundscheck=off)",
            `Turns off all массив bounds checking, even for safe functions. $(RED Deprecated
            (use $(TT $(SWLINK -boundscheck)=off) instead).)`
        ),
        new Опция("O",
            "optimize",
            `Optimize generated code. For fastest executables, compile
            with the $(TT $(SWLINK -O) $(SWLINK -release) $(SWLINK -inline) $(SWLINK -boundscheck)=off)
            switches together.`
        ),
        new Опция("o-",
            "do not пиши объект файл",
            `Suppress generation of объект файл. Useful in
            conjuction with $(SWLINK -D) or $(SWLINK -H) flags.`
        ),
        new Опция("od=<directory>",
            "пиши объект & library files to directory",
            `Write объект files relative to directory $(I objdir)
            instead of to the current directory. $(SWLINK -op)
            can be используется if the original package hierarchy should
            be retained`
        ),
        new Опция("of=<имяф>",
            "имя output файл to имяф",
            `Set output файл имя to $(I имяф) in the output
            directory. The output файл can be an объект файл,
            executable файл, or library файл depending on the other
            switches.`
        ),
        new Опция("op",
            "preserve source path for output files",
            `Normally the path for $(B .d) source files is stripped
            off when generating an объект, interface, or Ddoc файл
            имя. $(SWLINK -op) will leave it on.`
        ),
        new Опция("preview=<ид>",
            "enable an upcoming language change identified by 'ид'",
            `Preview an upcoming language change identified by $(I ид)`
        ),
        new Опция("preview=[h|help|?]",
            "list all upcoming language changes"
        ),
        new Опция("profile",
            "profile runtime performance of generated code"
        ),
        new Опция("profile=gc",
            "profile runtime allocations",
            `$(LINK2 http://www.digitalmars.com/ctg/trace.html, profile)
            the runtime performance of the generated code.
            $(UL
                $(LI $(B gc): Instrument calls to memory allocation and пиши a report
                to the файл $(TT profilegc.log) upon program termination.)
            )`
        ),
        new Опция("release",
            "compile release version",
            `Compile release version, which means not emitting run-time
            checks for contracts and asserts. МассивДРК bounds checking is not
            done for system and trusted functions, and assertion failures
            are undefined behaviour.`
        ),
        new Опция("revert=<ид>",
            "revert language change identified by 'ид'",
            `Revert language change identified by $(I ид)`
        ),
        new Опция("revert=[h|help|?]",
            "list all revertable language changes"
        ),
        new Опция("run <srcfile>",
            "compile, link, and run the program srcfile",
            `Compile, link, and run the program $(I srcfile) with the
            rest of the
            command line, $(I args...), as the arguments to the program.
            No .$(OBJEXT) or executable файл is left behind.`
        ),
        new Опция("shared",
            "generate shared library (DLL)",
            `$(UNIX Generate shared library)
             $(WINDOWS Generate DLL library)`
        ),
        new Опция("transition=<ид>",
            "help with language change identified by 'ид'",
            `Show additional info about language change identified by $(I ид)`
        ),
        new Опция("transition=[h|help|?]",
            "list all language changes"
        ),
        new Опция("unittest",
            "compile in unit tests",
            `Compile in $(LINK2 spec/unittest.html, unittest) code, turns on asserts, and sets the
             $(D unittest) $(LINK2 spec/version.html#PredefinedVersions, version идентификатор)`
        ),
        new Опция("v",
            "verbose",
            `Enable verbose output for each compiler pass`
        ),
        new Опция("vcolumns",
            "print character (column) numbers in diagnostics"
        ),
        new Опция("verror-style=[digitalmars|gnu]",
            "set the style for файл/line number annotations on compiler messages",
            `Set the style for файл/line number annotations on compiler messages,
            where:
            $(DL
            $(DT digitalmars)$(DD 'файл(line[,column]): message'. This is the default.)
            $(DT gnu)$(DD 'файл:line[:column]: message', conforming to the GNU standard используется by gcc and clang.)
            )`
        ),
        new Опция("verrors=<num>",
            "limit the number of error messages (0 means unlimited)"
        ),
        new Опция("verrors=context",
            "show error messages with the context of the erroring source line"
        ),
        new Опция("verrors=spec",
            "show errors from speculative compiles such as __traits(compiles,...)"
        ),
        new Опция("-version",
            "print compiler version and exit"
        ),
        new Опция("version=<уровень>",
            "compile in version code >= уровень",
            `Compile in $(LINK2 $(ROOT_DIR)spec/version.html#version, version уровень) >= $(I уровень)`
        ),
        new Опция("version=<идент>",
            "compile in version code identified by идент",
            `Compile in $(LINK2 $(ROOT_DIR)spec/version.html#version, version идентификатор) $(I идент)`
        ),
        new Опция("vgc",
            "list all gc allocations including hidden ones"
        ),
        new Опция("vtls",
            "list all variables going into thread local storage"
        ),
        new Опция("w",
            "warnings as errors (compilation will halt)",
            `Enable $(LINK2 $(ROOT_DIR)articles/warnings.html, warnings)`
        ),
        new Опция("wi",
            "warnings as messages (compilation will continue)",
            `Enable $(LINK2 $(ROOT_DIR)articles/warnings.html, informational warnings (i.e. compilation
            still proceeds normally))`
        ),
        new Опция("X",
            "generate JSON файл"
        ),
        new Опция("Xf=<имяф>",
            "пиши JSON файл to имяф"
        ),
        new Опция("Xcc=<driverflag>",
            "pass driverflag to linker driver (cc)",
            "Pass $(I driverflag) to the linker driver (`$CC` or `cc`)",
            TargetOS.all & ~TargetOS.windows
        )
    ];

    /// Representation of a CLI feature
    struct Feature
    {
        ткст имя; /// имя of the feature
        ткст paramName; // internal transition параметр имя
        ткст текстСправки; // detailed description of the feature
        бул documented = да; // whether this опция should be shown in the documentation
        бул deprecated_; /// whether the feature is still in use
    }

    /// Возвращает all доступно transitions
    static const transitions = [
        Feature("field", "vfield",
            "list all non-mutable fields which occupy an объект instance"),
        Feature("checkimports", "check10378",
            "give deprecation messages about 10378 anomalies", да, да),
        Feature("complex", "vcomplex",
            "give deprecation messages about all usages of complex or imaginary types"),
        Feature("tls", "vtls",
            "list all variables going into thread local storage"),
        Feature("vmarkdown", "vmarkdown",
            "list instances of Markdown replacements in Ddoc"),
    ];

    /// Возвращает all доступно reverts
    static const reverts = [
        Feature("dip25", "noDIP25", "revert DIP25 changes https://github.com/dlang/DIPs/blob/master/DIPs/archive/DIP25.md"),
        Feature("import", "bug10378", "revert to single phase имя lookup", да, да),
    ];

    /// Возвращает all доступно previews
    static const previews = [
        Feature("dip25", "useDIP25",
            "implement https://github.com/dlang/DIPs/blob/master/DIPs/archive/DIP25.md (Sealed references)"),
        Feature("dip1000", "vsafe",
            "implement https://github.com/dlang/DIPs/blob/master/DIPs/other/DIP1000.md (Scoped Pointers)"),
        Feature("dip1008", "ehnogc",
            "implement https://github.com/dlang/DIPs/blob/master/DIPs/other/DIP1008.md ( Throwable)"),
        Feature("dip1021", "useDIP1021",
            "implement https://github.com/dlang/DIPs/blob/master/DIPs/accepted/DIP1021.md (Mutable function arguments)"),
        Feature("fieldwise", "fieldwise", "use fieldwise comparisons for struct equality"),
        Feature("markdown", "markdown", "enable Markdown replacements in Ddoc"),
        Feature("fixAliasThis", "fixAliasThis",
            "when a symbol is resolved, check alias this scope before going to upper scopes"),
        Feature("intpromote", "fix16997",
            "fix integral promotions for unary + - ~ operators"),
        Feature("dtorfields", "dtorFields",
            "destruct fields of partially constructed objects"),
        Feature("rvaluerefparam", "rvalueRefParam",
            "enable rvalue arguments to ref parameters"),
        Feature("nosharedaccess", "noSharedAccess",
            "disable access to shared memory objects"),
    ];
}

/**
Formats the `Options` for CLI printing.
*/
struct CLIUsage
{
    /**
    Возвращает a ткст of all доступно CLI опции for the current targetOS.
    Options are separated by newlines.
    */
    static ткст использование()
    {
        const maxFlagLength = 18;
        const s = () {
            ткст буф;
            foreach (опция; Использование.опции)
            {
                if (опция.ос.isCurrentTargetOS)
                {
                    буф ~= "  -" ~ опция.флаг;
                    // создай new строки if the флаг имя is too long
                    if (опция.флаг.length >= 17)
                    {
                            буф ~= "\n                    ";
                    }
                    else if (опция.флаг.length <= maxFlagLength)
                    {
                        const spaces = maxFlagLength - опция.флаг.length - 1;
                        буф.length += spaces;
                        буф[$ - spaces .. $] = ' ';
                    }
                    else
                    {
                            буф ~= "  ";
                    }
                    буф ~= опция.текстСправки;
                    буф ~= "\n";
                }
            }
            return cast(ткст) буф;
        }();
        return s;
    }

    /// CPU architectures supported -mcpu=ид
    const mcpuUsage = "CPU architectures supported by -mcpu=ид:
  =[h|help|?]    list information on all доступно choices
  =baseline      use default architecture as determined by target
  =avx           use AVX 1 instructions
  =avx2          use AVX 2 instructions
  =native        use CPU architecture that this compiler is running on
";

    static ткст generateFeatureUsage(Использование.Feature[] features, ткст flagName, ткст description)
    {
        const maxFlagLength = 20;
        auto буф = description.вЗаг ~ " listed by -"~flagName~"=имя:
";
        auto allTransitions = [Использование.Feature("all", null,
            "list information on all " ~ description)] ~ features;
        foreach (t; allTransitions)
        {
            if (t.deprecated_)
                continue;
            if (!t.documented)
                continue;
            буф ~= "  =";
            буф ~= t.имя;
            auto lineLength = 3 + t.имя.length;
            foreach (i; new uint[lineLength .. maxFlagLength])
                буф ~= " ";
            буф ~= t.текстСправки;
            буф ~= "\n";
        }
        return буф;
    }

    /// Language changes listed by -transition=ид
    const transitionUsage = generateFeatureUsage(Использование.transitions, "transition", "language transitions");

    /// Language changes listed by -revert
    const revertUsage = generateFeatureUsage(Использование.reverts, "revert", "revertable language changes");

    /// Language previews listed by -preview
    const previewUsage = generateFeatureUsage(Использование.previews, "preview", "upcoming language changes");

    /// Options supported by -checkaction=
    const checkActionUsage = "Behavior on assert/boundscheck/finalswitch failure:
  =[h|help|?]    List information on all доступно choices
  =D             Usual D behavior of throwing an AssertError
  =C             Call the C runtime library assert failure function
  =halt          Halt the program execution (very lightweight)
  =context       Use D assert with context information (when доступно)
";

    /// Options supported by -check
    const checkUsage = "Enable or disable specific checks:
  =[h|help|?]           List information on all доступно choices
  =assert[=[on|off]]    Assertion checking
  =bounds[=[on|off]]    МассивДРК bounds checking
  =in[=[on|off]]        Generate In contracts
  =invariant[=[on|off]] Class/struct invariants
  =out[=[on|off]]       Out contracts
  =switch[=[on|off]]    Final switch failure checking
  =on                   Enable all assertion checking
                        (default for non-release builds)
  =off                  Disable all assertion checking
";

    /// Options supported by -extern-std
    const externStdUsage = "Available C++ standards:
  =[h|help|?]           List information on all доступно choices
  =c++98                Sets `__traits(getTargetInfo, \"cppStd\")` to `199711`
  =c++11                Sets `__traits(getTargetInfo, \"cppStd\")` to `201103`
  =c++14                Sets `__traits(getTargetInfo, \"cppStd\")` to `201402`
  =c++17                Sets `__traits(getTargetInfo, \"cppStd\")` to `201703`
";
}
