/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/globals.d, _globals.d)
 * Documentation:  https://dlang.org/phobos/dmd_globals.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/globals.d
 */

module dmd.globals;

import cidrus;
import util.array;
import util.filename;
import util.outbuffer;
import drc.lexer.Identifier;
import util.string : вТкстД;
//import dmd.console : Console;


template xversion(ткст s)
{
    const xversion = mixin(`{ version (` ~ s ~ `) return да; else return нет; }`)();
}

enum TARGET : бул
{
    Linux        = xversion!(`linux`),
    OSX          = xversion!(`OSX`),
    FreeBSD      = xversion!(`FreeBSD`),
    OpenBSD      = xversion!(`OpenBSD`),
    Solaris      = xversion!(`Solaris`),
    Windows      = xversion!(`Windows`),
    DragonFlyBSD = xversion!(`DragonFlyBSD`),
}

enum DiagnosticReporting : ббайт
{
    error,        // генерировать ошибку
    inform,       // генерировать предупреждениеg
    off,          // отключить диагностику
}

enum MessageStyle : ббайт
{
    digitalmars,  // имяф.d(строка): сообщение
    gnu,          // имяф.d:строка: сообщение, см. https://www.gnu.org/prep/standards/html_node/Errors.html
}

enum CHECKENABLE : ббайт
{
    _default,     // начальное значение
    off,          // никогда не проверять
    on,           // всегда проверять
    safeonly,     // проверять только в функциях
}

enum CHECKACTION : ббайт
{
    D,            // вызывать при неудаче D assert
    C,            // вызывать при неудаче C assert
    halt,         // вызывать задержку программы при неудаче
    context,      // вызывать при неудаче D assert с контекстом ошибки
}

enum CPU
{
    x87,
    mmx,
    sse,
    sse2,
    sse3,
    ssse3,
    sse4_1,
    sse4_2,
    avx,                // набор инструкций AVX1
    avx2,               // набор инструкций AVX2
    avx512,             // набор инструкций AVX-512

    // Особые значение, которые пропадают после обработки командной строки
    baseline,           // (дефолт) минимальная ёмкость ЦПБ(CPU)
    native              // машина, на которой выполняется компилятор
}

enum PIC : ббайт
{
    fixed,              /// расположено по специфичному адресу
    pic,                /// Position Independent Code (ПНК)
    pie,                /// Position Independent Executable (ПНВ)
}

/**
* Каждый флаг представляет поле, которое может быть включено в вывод JSON.
*
* ПРИМЕЧАНИЕ: установите тип в бцел, чтобы его размер совпал с беззначным типом C++.
*/
enum JsonFieldFlags : бцел
{
    none         = 0,
    compilerInfo = (1 << 0),
    buildInfo    = (1 << 1),
    modules      = (1 << 2),
    semantics    = (1 << 3),
}

enum CppStdRevision : бцел
{
    cpp98 = 199711,
    cpp11 = 201103,
    cpp14 = 201402,
    cpp17 = 201703
}

// Сюда помещаются переключатели командной строки.
 struct Param
{
    бул obj = да;        // записать объектный файл
    бул link = да;       // выполнить компоновку
    бул dll;               // генерировать разделяемую динамическую библиотеку
    бул lib;               // записать библиотечный файл вместто объектного файла(-ов)
    бул multiobj;          // разбить один объектный файл на несколько частей
    бул oneobj;            // записать один объектный файл вместо нескольких
    бул trace;             // вставить хуки профилирования
    бул tracegc;           // instrument calls to 'new'
    бул verbose;           // многословная компиляция
    бул vcg_ast;           // пиши-out codegen-ast
    бул showColumns;       // print character (column) numbers in diagnostics
    бул vtls;              // identify thread local variables
    бул vgc;               // identify gc использование
    бул vfield;            // identify non-mutable field variables
    бул vcomplex;          // identify complex/imaginary тип использование
    ббайт symdebug;         // вставь debug symbolic information
    бул symdebugref;       // вставь debug information for all referenced types, too
    бул alwaysframe;       // всегда выдавать стандартный кадр стэка
    бул optimize;          // выполнить оптимизатор
    бул map;               // генерировать файл .map конпоновщика
    бул is64bit = (т_мера.sizeof == 8);  // generate 64 bit code; да by default for 64 bit dmd
    бул isLP64;            // генерировать код для LP64
    бул isLinux;           // генерировать код для linux
    бул isOSX;             // генерировать код для Mac OSX
    бул isWindows;         // генерировать код для Windows
    бул isFreeBSD;         // генерировать код для FreeBSD
    бул isOpenBSD;         // генерировать код для OpenBSD
    бул isDragonFlyBSD;    // генерировать код для DragonFlyBSD
    бул isSolaris;         // генерировать код для Solaris
    бул hasObjectiveC;     // target supports Objective-C
    бул mscoff = нет;    // for Win32: пиши MsCoff объект files instead of OMF
    DiagnosticReporting useDeprecated = DiagnosticReporting.inform;  // how use of deprecated features are handled
    бул stackstomp;            // add stack stomping code
    бул useUnitTests;          // generate unittest code
    бул useInline = нет;     // inline expand functions
    бул useDIP25;          // implement http://wiki.dlang.org/DIP25
    бул noDIP25;           // revert to pre-DIP25 behavior
    бул useDIP1021;        // implement https://github.com/dlang/DIPs/blob/master/DIPs/DIP1021.md
    бул release;           // build release version
    бул preservePaths;     // да means don't strip path from source файл
    DiagnosticReporting warnings = DiagnosticReporting.off;  // how compiler warnings are handled
    PIC pic = PIC.fixed;    // generate fixed, pic or pie code
    бул color;             // use ANSI colors in console output
    бул cov;               // generate code coverage данные
    ббайт covPercent;       // 0..100 code coverage percentage required
    бул nofloat;           // code should not pull in floating point support
    бул ignoreUnsupportedPragmas;  // rather than error on them
    бул useModuleInfo = да;   // generate runtime module information
    бул useTypeInfo = да;     // generate runtime тип information
    бул useExceptions = да;   // support exception handling
    бул noSharedAccess;         // читай/пиши access to shared memory objects
    бул betterC;           // be a "better C" compiler; no dependency on D runtime
    бул addMain;           // add a default main() function
    бул allInst;           // генерировать код для all template instantiations
    бул check10378;        // check for issues transitioning to 10738 @@@DEPRECATED@@@ Remove in 2020-05 or later
    бул bug10378;          // use pre- https://issues.dlang.org/show_bug.cgi?ид=10378 search strategy  @@@DEPRECATED@@@ Remove in 2020-05 or later
    бул fix16997;          // fix integral promotions for unary + - ~ operators
                            // https://issues.dlang.org/show_bug.cgi?ид=16997
    бул fixAliasThis;      // if the current scope has an alias this, check it before searching upper scopes
    /** The --transition=safe switch should only be используется to show code with
     * silent semantics changes related to  improvements.  It should not be
     * используется to hide a feature that will have to go through deprecate-then-error
     * before becoming default.
     */
    бул vsafe;             // use enhanced  checking
    бул ehnogc;            // use  exception handling
    бул dtorFields;        // destruct fields of partially constructed objects
                            // https://issues.dlang.org/show_bug.cgi?ид=14246
    бул fieldwise;         // do struct equality testing field-wise rather than by memcmp()
    бул rvalueRefParam;    // allow rvalues to be arguments to ref parameters
                            // http://dconf.org/2019/talks/alexandrescu.html
                            // https://gist.github.com/andralex/e5405a5d773f07f73196c05f8339435a
                            // https://digitalmars.com/d/archives/digitalmars/D/Binding_rvalues_to_ref_parameters_redux_325087.html
                            // Implementation: https://github.com/dlang/dmd/pull/9817

    CppStdRevision cplusplus = CppStdRevision.cpp98;    // version of C++ standard to support

    бул markdown;          // enable Markdown replacements in Ddoc
    бул vmarkdown;         // list instances of Markdown replacements in Ddoc

    бул showGaggedErrors;  // print gagged errors anyway
    бул printErrorContext;  // print errors with the error context (the error line in the source файл)
    бул manual;            // открыть браузер на руководстве к компилятору
    бул использование;             // вывести использование и выйти
    бул mcpuUsage;         // выводить справку при переключателе -mcpu 
    бул transitionUsage;   // выводить справку при переключателе -transition 
    бул checkUsage;        // выводить справку при переключателе -check 
    бул checkActionUsage;  // выводить справку при переключателе -checkaction 
    бул revertUsage;       // выводить справку при переключателе -revert 
    бул previewUsage;      // выводить справку при переключателе -preview 
    бул externStdUsage;    // выводить справку при переключателе -extern-std 
    бул logo;              // print compiler logo

    CPU cpu = CPU.baseline; // CPU instruction set to target

    CHECKENABLE useInvariants  = CHECKENABLE._default;  // generate class invariant checks
    CHECKENABLE useIn          = CHECKENABLE._default;  // generate precondition checks
    CHECKENABLE useOut         = CHECKENABLE._default;  // generate postcondition checks
    CHECKENABLE useArrayBounds = CHECKENABLE._default;  // when to генерировать код для массив bounds checks
    CHECKENABLE useAssert      = CHECKENABLE._default;  // when to генерировать код для assert()'s
    CHECKENABLE useSwitchError = CHECKENABLE._default;  // check for switches without a default
    CHECKENABLE boundscheck    = CHECKENABLE._default;  // state of -boundscheck switch

    CHECKACTION checkAction = CHECKACTION.D; // action to take when bounds, asserts or switch defaults are violated

    бцел errorLimit = 20;

    ткст argv0;                // program имя
    МассивДРК!(сим*) modFileAliasStrings; // массив of сим*'s of -I module имяф alias strings
    МассивДРК!(сим*)* imppath;      // массив из сим*, в котором нужно найти import modules
    МассивДРК!(сим*)* fileImppath;  // массив из сим*, в котором нужно найти файл import modules
    ткст objdir;                // .obj/.lib папка вывода файла
    ткст objname;               // .obj имя выходного файла
    ткст libname;               // .lib имя выходного файла

    бул doDocComments;                 // process embedded documentation comments
    ткст docdir;               // записать файл документации в docdir directory
    ткст docname;              // записать файл документации в docname
    МассивДРК!(сим*) ddocfiles;     // macro include files for Ddoc

    бул doHdrGeneration;               // process embedded documentation comments
    ткст hdrdir;                // записать файл 'header' в docdir directory
    ткст hdrname;               // записать файл 'header' в docname
    бул hdrStripPlainFunctions = да; // strip the bodies of plain (non-template) functions

    бул doCxxHdrGeneration;            // пиши 'Cxx header' файл
    ткст cxxhdrdir;            // записать файл 'header' в docdir directory
    ткст cxxhdrname;           // записать файл 'header' в docname

    бул doJsonGeneration;              // пиши JSON файл
    ткст jsonfilename;          // пиши JSON файл to jsonfilename
    JsonFieldFlags jsonFieldFlags;      // JSON field flags to include

    БуфВыв* mixinOut;                // пиши expanded mixins for debugging
    ткст0 mixinFile;             // .mixin имя выходного файла
    цел mixinLines;                     // Number of строки in writeMixins

    бцел debuglevel;                    // debug уровень
    МассивДРК!(сим*)* debugids;     // debug identifiers

    бцел versionlevel;                  // version уровень
    МассивДРК!(сим*)* versionids;   // version identifiers

    ткст defaultlibname;        // default library for non-debug builds
    ткст debuglibname;          // default library for debug builds
    ткст mscrtlib;              // MS C runtime library

    ткст moduleDepsFile;        // имяф for deps output
    БуфВыв* moduleDeps;              // contents to be written to deps файл
    MessageStyle messageStyle = MessageStyle.digitalmars; // style of файл/line annotations on messages

    // Hidden debug switches
    бул debugb;
    бул debugc;
    бул debugf;
    бул debugr;
    бул debugx;
    бул debugy;

    бул run; // run результатing executable
    Strings runargs; // arguments for executable

    // Linker stuff
    МассивДРК!(сим*) objfiles;
    МассивДРК!(сим*) linkswitches;
    МассивДРК!(бул) linkswitchIsForCC;
    МассивДРК!(сим*) libfiles;
    МассивДРК!(сим*) dllfiles;
    ткст deffile;
    ткст resfile;
    ткст exefile;
    ткст mapfile;
}

alias бцел structalign_t;

// magic значение means "match whatever the underlying C compiler does"
// other values are all powers of 2
const STRUCTALIGN_DEFAULT = (cast(structalign_t)~0);

 struct Global
{
    ткст inifilename;
    ткст mars_ext = "d";
    ткст obj_ext;
    ткст lib_ext;
    ткст dll_ext;
    ткст doc_ext = "html";      // for Ddoc generated files
    ткст ddoc_ext = "ddoc";     // for Ddoc macro include files
    ткст hdr_ext = "di";        // for D 'header' import files
    ткст cxxhdr_ext = "h";      // for C/C++ 'header' files
    ткст json_ext = "json";     // for JSON files
    ткст map_ext = "map";       // for .map files
    бул run_noext;                     // allow -run sources without extensions.

    ткст copyright = "Copyright (C) 1999-2020 by The Dinrus Language Foundation, All Rights Reserved";
    ткст written = "written by Walter Bright, Aziz Köksal, Vitaly Kulich";

    МассивДРК!(сим*)* path;         // МассивДРК of сим*'s which form the import lookup path
    МассивДРК!(сим*)* filePath;     // МассивДРК of сим*'s which form the файл import lookup path

    ткст _version;
    ткст vendor;    // Compiler backend имя

    Param парамы;
    бцел errors;            // number of errors reported so far
    бцел warnings;          // number of warnings reported so far
    бцел gag;               // !=0 means gag reporting of errors & warnings
    бцел gaggedErrors;      // number of errors reported while gagged
    бцел gaggedWarnings;    // number of warnings reported while gagged

    ук console;         // opaque pointer to console for controlling text attributes

    МассивДРК!(Идентификатор2)* versionids;    // command line versions and predefined versions
    МассивДРК!(Идентификатор2)* debugids;      // command line debug versions and predefined versions

    const recursionLimit = 500; // number of recursive template expansions before abort

  

    /* Start gagging. Return the current number of gagged errors
     */
     бцел startGagging()
    {
        ++gag;
        gaggedWarnings = 0;
        return gaggedErrors;
    }

    /* End gagging, restoring the old gagged state.
     * Return да if errors occurred while gagged.
     */
     бул endGagging(бцел oldGagged)
    {
        бул anyErrs = (gaggedErrors != oldGagged);
        --gag;
        // Restore the original state of gagged errors; set total errors
        // to be original errors + new ungagged errors.
        errors -= (gaggedErrors - oldGagged);
        gaggedErrors = oldGagged;
        return anyErrs;
    }

    /*  Increment the error count to record that an error
     *  has occurred in the current context. An error message
     *  may or may not have been printed.
     */
     проц increaseErrorCount()
    {
        if (gag)
            ++gaggedErrors;
        ++errors;
    }

     проц _иниц()
    {
        _version = import("VERSION") ~ '\0';

        version (Dinrus)
        {
            vendor = "Dinrus Group D";
            static if (TARGET.Windows)
            {
                obj_ext = "obj";
            }
            else static if (TARGET.Linux || TARGET.OSX || TARGET.FreeBSD || TARGET.OpenBSD || TARGET.Solaris || TARGET.DragonFlyBSD)
            {
                obj_ext = "o";
            }
            else
            {
                static assert(0, "требуется исправление");
            }
            static if (TARGET.Windows)
            {
                lib_ext = "lib";
            }
            else static if (TARGET.Linux || TARGET.OSX || TARGET.FreeBSD || TARGET.OpenBSD || TARGET.Solaris || TARGET.DragonFlyBSD)
            {
                lib_ext = "a";
            }
            else
            {
                static assert(0, "требуется исправление");
            }
            static if (TARGET.Windows)
            {
                dll_ext = "dll";
            }
            else static if (TARGET.Linux || TARGET.FreeBSD || TARGET.OpenBSD || TARGET.Solaris || TARGET.DragonFlyBSD)
            {
                dll_ext = "so";
            }
            else static if (TARGET.OSX)
            {
                dll_ext = "dylib";
            }
            else
            {
                static assert(0, "требуется исправление");
            }
            static if (TARGET.Windows)
            {
                run_noext = нет;
            }
            else static if (TARGET.Linux || TARGET.OSX || TARGET.FreeBSD || TARGET.OpenBSD || TARGET.Solaris || TARGET.DragonFlyBSD)
            {
                // Allow 'script' D source files to have no extension.
                run_noext = да;
            }
            else
            {
                static assert(0, "требуется исправление");
            }
            static if (TARGET.Windows)
            {
                парамы.mscoff = парамы.is64bit;
            }

            // -color=auto is the default значение
            парамы.color = Console.detectTerminal();
        }
        else version (IN_GCC)
        {
            vendor = "GNU D";
            obj_ext = "o";
            lib_ext = "a";
            dll_ext = "so";
            run_noext = да;
        }
    }

    /**
     * Deinitializes the глоб2 state of the compiler.
     *
     * This can be используется to restore the state set by `_иниц` to its original
     * state.
     */
    проц deinitialize()
    {
        this = this.init;
    }

    /**
    * Возвращает: the version as the number that would be returned for __VERSION__
    */
    бцел versionNumber()
    {
        бцел cached = 0;
        if (cached == 0)
        {
            //
            // parse _version
            //
            бцел major = 0;
            бцел minor = 0;
            бул point = нет;
            for (ткст0 p = _version.ptr + 1;; p++)
            {
                const c = *p;
                if (isdigit(cast(сим)c))
                {
                    minor = minor * 10 + c - '0';
                }
                else if (c == '.')
                {
                    if (point)
                        break; // ignore everything after second '.'
                    point = да;
                    major = minor;
                    minor = 0;
                }
                else
                    break;
            }
            cached = major * 1000 + minor;
        }
        return cached;
    }

    /**
    * Возвращает: the final defaultlibname based on the command-line parameters
    */
    ткст finalDefaultlibname()
    {
        return парамы.betterC ? null :
            парамы.symdebug ? парамы.debuglibname : парамы.defaultlibname;
    }
}

 Global глоб2;

// Because int64_t and friends may be any integral тип of the
// correct size, we have to explicitly ask for the correct
// integer тип to get the correct mangling with dmd

// Be careful not to care about sign when using dinteger_t
// use this instead of integer_t to
// avoid conflicts with system #include's
alias  бдол dinteger_t;
// Signed and unsigned variants
alias  long sinteger_t;
alias  бдол uinteger_t;

alias  int8_t d_int8;
alias  uint8_t d_uns8;
alias  int16_t d_int16;
alias  uint16_t d_uns16;
alias  int32_t d_int32;
alias  uint32_t d_uns32;
alias  int64_t d_int64;
alias  uint64_t d_uns64;

// Положение в файле
struct Место
{
    ткст0 имяф; // either absolute or relative to cwd
    бцел номстр;
    бцел имяс;

    static const Место initial;       /// use for default initialization of ref Место's


    static Место opCall(ткст0 имяф, бцел номстр, бцел имяс) 
    {
        this.номстр = номстр;
        this.имяс = имяс;
        this.имяф = имяф;
    }

     ткст0 вТкст0(
        бул showColumns = глоб2.парамы.showColumns,
        ббайт messageStyle = глоб2.парамы.messageStyle)
    {
        БуфВыв буф;
        if (имяф)
        {
            буф.пишиСтр(имяф);
        }
        if (номстр)
        {
            switch (messageStyle)
            {
                case MessageStyle.digitalmars:
                    буф.пишиБайт('(');
                    буф.print(номстр);
                    if (showColumns && имяс)
                    {
                        буф.пишиБайт(',');
                        буф.print(имяс);
                    }
                    буф.пишиБайт(')');
                    break;
                case MessageStyle.gnu: // https://www.gnu.org/prep/standards/html_node/Errors.html
                    буф.пишиБайт(':');
                    буф.print(номстр);
                    if (showColumns && имяс)
                    {
                        буф.пишиБайт(':');
                        буф.print(имяс);
                    }
                    break;
            }
        }
        return буф.extractChars();
    }

    /* Checks for equivalence,
     * a) comparing the имяф contents (not the pointer), case-
     *    insensitively on Windows, and
     * b) ignoring имяс if `глоб2.парамы.showColumns` is нет.
     */
     бул равен(ref Место место)
    {
        return (!глоб2.парамы.showColumns || имяс == место.имяс) &&
               номстр == место.номстр &&
               ИмяФайла.равен(имяф, место.имяф);
    }

    /* opEquals() / toHash() for AA ключ использование:
     *
     * Compare имяф contents (case-sensitively on Windows too), not
     * the pointer - a static foreach loop repeatedly mixing in a mixin
     * may lead to multiple equivalent filenames (`foo.d-mixin-<line>`),
     * e.g., for test/runnable/test18880.d.
     */
    extern (D) бул opEquals(ref Место место)
    {
          return имяс == место.имяс &&
               номстр == место.номстр &&
               (имяф == место.имяф ||
                (имяф && место.имяф && strcmp(имяф, место.имяф) == 0));
    }

    extern (D) т_мера toHash()
    {
         auto хэш = hashOf(номстр);
        хэш = hashOf(имяс, хэш);
        хэш = hashOf(имяф.вТкстД, хэш);
        return хэш;
    }

    /******************
     * Возвращает:
     *   да if Место has been set to other than the default initialization
     */
    бул isValid() 
    {
        return имяф !is null;
    }
}

enum LINK : цел
{
    default_,
    d,
    c,
    cpp,
    windows,
    pascal,
    objc,
    system,
}

enum CPPMANGLE : цел
{
    def,
    asStruct,
    asClass,
}

enum MATCH : цел
{
    nomatch,   // no match
    convert,   // match with conversions
    constant,  // match with conversion to const
    exact,     // exact match
}

enum PINLINE : цел
{
    default_,     // as specified on the command line
    never,   // never inline
    always,  // always inline
}

alias uinteger_t КлассХранения; 
