/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * This module содержит high-уровень interfaces for interacting
  with DMD as a library.
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/ид.d, _id.d)
 * Documentation:  https://dlang.org/phobos/dmd_frontend.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/frontend.d
 */
module dmd.frontend;

import drc.ast.AstCodegen : ASTCodegen;
import dmd.dmodule : Module;
import dmd.globals : CHECKENABLE, Место, DiagnosticReporting;
import dmd.errors : DiagnosticHandler, diagnosticHandler, Classification;

//import std.range.primitives : isInputRange, ElementType;
//import std.traits : isNarrowString;
//import std.typecons : Tuple;
import cidrus;

//import std.algorithm : each;

import util.ctfloat : CTFloat;

version (CRuntime_Microsoft)
import util.longdouble : initFPU;

import dmd.builtin : builtin_init;
import dmd.cond : VersionCondition;
import dmd.dmodule : Module;
import drc.ast.Expression : Выражение;
import util.filecache : ФайлКэш;
import dmd.globals : CHECKENABLE, глоб2;
import drc.lexer.Id : Id;
import drc.lexer.Identifier : Идентификатор2;
import dmd.mars : setTarget, addDefaultVersionIdentifiers;
import dmd.mtype : Тип;
import dmd.objc : Objc;
import dmd.target : target;

import dmd.builtin : builtinDeinitialize;
import dmd.dmodule : Module;
import drc.ast.Expression : Выражение;
import dmd.globals : глоб2;
import drc.lexer.Id : Id;
import dmd.mtype : Тип;
import dmd.objc : Objc;
import dmd.target : target;
import dmd.arraytypes : Strings;
import stdrus : вТкст0;
import dmd.dinifile : findConfFile;
//import std.file : getcwd;
//import std.path : buildPath, dirName;
//import std.algorithm.iteration : filter;
//import std.file : exists;
import dmd.dsymbolsem : dsymbolSemantic;
import dmd.semantic2 : semantic2;
import dmd.semantic3 : semantic3;
//import std.algorithm.searching : endsWith;
//import std.fule : exists;
//import std.path : dirName;
import util.file : Файл, ФайлБуфер;

import dmd.globals : Место, глоб2;
import drc.parser.Parser2 : Parser;
import drc.lexer.Identifier : Идентификатор2;
import drc.lexer.Tokens : ТОК2;

//import std.path : baseName, stripExtension;
//import std.ткст : вТкст0;
//import std.typecons : кортеж;

//import std.ткст : replace, fromStringz;
//import std.exception : assumeUnique;
import util.outbuffer: БуфВыв;
import dmd.hdrgen : HdrGenState, moduleToBuffer2;

//import std.algorithm.iteration : filter, joiner, map, splitter;
//import std.файл : exists;
//import std.path : buildPath;
//import std.process : environment;
//import std.range : front, empty, transposed;

//import std.algorithm, std.range, std.regex;
//import std.stdio : Файл;
//import std.path : buildNormalizedPath;

import win : Color = Цвет;

version (Windows) private const sep = ";", exe = ".exe";
version (Posix) private const sep = ":", exe = "";

/// Contains aggregated diagnostics information.
struct Diagnostics
{
    /// Number of errors diagnosed
    бцел errors;

    /// Number of warnings diagnosed
    бцел warnings;

    /// Возвращает: `да` if errors have been diagnosed
    бул hasErrors()
    {
        return errors > 0;
    }

    /// Возвращает: `да` if warnings have been diagnosed
    бул hasWarnings()
    {
        return warnings > 0;
    }
}

/// Indicates the checking state of various contracts.
enum ContractChecking : CHECKENABLE
{
    /// Initial значение
    default_ = CHECKENABLE._default,

    /// Never do checking
    disabled = CHECKENABLE.off,

    /// Always do checking
    enabled = CHECKENABLE.on,

    /// Only do checking in `` functions
    enabledInSafe = CHECKENABLE.safeonly
}

unittest
{
    static assert(
        __traits(allMembers, ContractChecking).length ==
        __traits(allMembers, CHECKENABLE).length
    );
}

/// Indicates which contracts should be checked or not.
struct ContractChecks
{
    /// Precondition checks (in contract).
    ContractChecking precondition = ContractChecking.enabled;

    /// Invariant checks.
    ContractChecking invariant_ = ContractChecking.enabled;

    /// Postcondition checks (out contract).
    ContractChecking postcondition = ContractChecking.enabled;

    /// МассивДРК bound checks.
    ContractChecking arrayBounds = ContractChecking.enabled;

    /// Assert checks.
    ContractChecking assert_ = ContractChecking.enabled;

    /// Switch error checks.
    ContractChecking switchError = ContractChecking.enabled;
}

/*
Initializes the глоб2 variables of the DMD compiler.
This needs to be done $(I before) calling any function.

Параметры:
    handler = a delegate to configure what to do with diagnostics (other than printing to console or stderr).
    contractChecks = indicates which contracts should be enabled or not
    versionIdentifiers = a list of version identifiers that should be enabled
*/
проц initDMD(
    DiagnosticHandler handler = null,
    ткст[] versionIdentifiers = [],
    ContractChecks contractChecks = ContractChecks()
){
    diagnosticHandler = handler;

    глоб2._иниц();

    with (глоб2.парамы)
    {
        useIn = contractChecks.precondition;
        useInvariants = contractChecks.invariant_;
        useOut = contractChecks.postcondition;
        useArrayBounds = contractChecks.arrayBounds;
        useAssert = contractChecks.assert_;
        useSwitchError = contractChecks.switchError;
    }

    versionIdentifiers.each!(VersionCondition.addGlobalIdent);
    setTarget(глоб2.парамы);
    addDefaultVersionIdentifiers(глоб2.парамы);

    Тип._иниц();
    Id.initialize();
    Module._иниц();
    target._иниц(глоб2.парамы);
    Выражение._иниц();
    Objc._иниц();
    builtin_init();
    ФайлКэш._иниц();

    version (CRuntime_Microsoft)
        initFPU();

    CTFloat.initialize();
}

/**
Deinitializes the глоб2 variables of the DMD compiler.

This can be используется to restore the state set by `initDMD` to its original state.
Useful if there's a need for multiple sessions of the DMD compiler in the same
application.
*/
проц deinitializeDMD()
{
    diagnosticHandler = null;

    глоб2.deinitialize();

    Тип.deinitialize();
    Id.deinitialize();
    Module.deinitialize();
    target.deinitialize();
    Выражение.deinitialize();
    Objc.deinitialize();
    builtinDeinitialize();
}

/**
Add import path to the `глоб2.path`.
Параметры:
    path = import to add
*/
проц addImport(ткст path)
{

    if (глоб2.path is null)
        глоб2.path = new Strings();

    глоб2.path.сунь(path.вТкст0);
}

/**
Add ткст import path to `глоб2.filePath`.
Параметры:
    path = ткст import to add
*/
проц addStringImport(ткст path)
{
    if (глоб2.filePath is null)
        глоб2.filePath = new Strings();

    глоб2.filePath.сунь(path.вТкст0);
}

/**
Searches for a `dmd.conf`.

Параметры:
    dmdFilePath = path to the current DMD executable

Возвращает: full path to the found `dmd.conf`, `null` otherwise.
*/
ткст findDMDConfig(ткст dmdFilePath)
{
        version (Windows)
        const configFile = "sc.ini";
    else
        const configFile = "dmd.conf";

    return findConfFile(dmdFilePath, configFile).idup;
}

/**
Searches for a `ldc2.conf`.

Параметры:
    ldcFilePath = path to the current LDC executable

Возвращает: full path to the found `ldc2.conf`, `null` otherwise.
*/
/+
ткст findLDCConfig(ткст ldcFilePath)
{
    auto execDir = ldcFilePath.dirName;

    const ldcConfig = "ldc2.conf";
    // https://wiki.dlang.org/Using_LDC
    auto ldcConfigs = [
        getcwd.buildPath(ldcConfig),
        execDir.buildPath(ldcConfig),
        execDir.dirName.buildPath("etc", ldcConfig),
        "~/.ldc".buildPath(ldcConfig),
        execDir.buildPath("etc", ldcConfig),
        execDir.buildPath("etc", "ldc", ldcConfig),
        "/etc".buildPath(ldcConfig),
        "/etc/ldc".buildPath(ldcConfig),
    ].filter!(exists);
    if (ldcConfigs.empty)
        return null;

    return ldcConfigs.front;
}
+/
/**
Detect the currently active compiler.
Возвращает: full path to the executable of the found compiler, `null` otherwise.
*/
/+
ткст determineDefaultCompiler()
{
    // adapted from DUB: https://github.com/dlang/dub/blob/350a0315c38fab9d3d0c4c9d30ff6bb90efb54d6/source/dub/dub.d#L1183

    auto compilers = ["dmd", "gdc", "gdmd", "ldc2", "ldmd2"];

    // Search the user's PATH for the compiler binary
    if ("DMD" in environment)
        compilers = environment.get("DMD") ~ compilers;
    auto paths = environment.get("PATH", "").splitter(sep);
    auto res = compilers.map!(/*c =>*/ paths.map!(p => p.buildPath(c~exe))).joiner.filter!(exists);
    return !res.empty ? res.front : null;
}
+/
/**
Parses a `dmd.conf` or `ldc2.conf` config файл and returns defined import paths.

Параметры:
    iniFile = iniFile to parse imports from
    execDir = directory of the compiler binary

Возвращает: forward range of import paths found in `iniFile`
*/
/+
auto parseImportPathsFromConfig(ткст iniFile, ткст execDir)
{
    alias expandConfigVariables = a => a.drop(2) // -I
                                // "set" common config variables
                                .replace("%@P%", execDir)
                                .replace("%%ldcbinarypath%%", execDir);

    // search for all -I imports in this файл
    alias searchForImports = l => l.matchAll(`-I[^ "]+`.regex).joiner.map!expandConfigVariables;

    return Файл(iniFile, "r")
        .byLineCopy
        .map!(searchForImports)
		.joiner
        // удали duplicated imports paths
        .массив
        .sort
        .uniq
        .map!(buildNormalizedPath);
}
+/
/**
Finds a `dmd.conf` and parses it for import paths.
This depends on the `$DMD` environment variable.
If `$DMD` is set to `ldmd`, it will try to detect and parse a `ldc2.conf` instead.

Возвращает:
    A forward range of normalized import paths.

See_Also: $(LREF determineDefaultCompiler), $(LREF parseImportPathsFromConfig)
*/
/+
auto findImportPaths()
{
    ткст execFilePath = determineDefaultCompiler();
    assert(execFilePath !is null, "No D compiler found. `Use parseImportsFromConfig` manually.");

    const execDir = execFilePath.dirName;

    ткст iniFile;
    if (execFilePath.endsWith("ldc"~exe, "ldc2"~exe, "ldmd"~exe, "ldmd2"~exe))
        iniFile = findLDCConfig(execFilePath);
    else
        iniFile = findDMDConfig(execFilePath);

    assert(iniFile !is null && iniFile.exists, "No valid config found.");
    return iniFile.parseImportPathsFromConfig(execDir);
}
+/
/**
Parse a module from a ткст.

Параметры:
    fileName = файл to parse
    code = text to use instead of opening the файл

Возвращает: the parsed module объект
*/
/+
Tuple!(Module, "module_", Diagnostics, "diagnostics") parseModule(AST = ASTCodegen)(
    ткст fileName,
    ткст code = null)
{
    auto ид = Идентификатор2.idPool(fileName.baseName.stripExtension);
    auto m = new Module(fileName, ид, 0, 0);

    if (code is null)
        m.читай(Место.initial);
    else
    {
        Файл.РезЧтения readрезультат = {
            успех: да,
            буфер: ФайлБуфер(cast(ббайт[]) code.dup ~ '\0')
        };

        m.loadSourceBuffer(Место.initial, readрезультат);
    }

    m.parseModule!(AST)();

    Diagnostics diagnostics = {
        errors: глоб2.errors,
        warnings: глоб2.warnings
    };

    return typeof(return)(m, diagnostics);
}
+/

/**
Run full semantic analysis on a module.
*/
проц fullSemantic(Module m)
{
    m.importedFrom = m;
    m.importAll(null);

    m.dsymbolSemantic(null);
    Module.dprogress = 1;
    Module.runDeferredSemantic();

    m.semantic2(null);
    Module.runDeferredSemantic2();

    m.semantic3(null);
    Module.runDeferredSemantic3();
}

/**
Pretty print a module.

Возвращает:
    Pretty printed module as ткст.
*/
ткст prettyPrint(Module m)
{
    БуфВыв буф = { doindent: 1 };
    HdrGenState hgs = { fullDump: 1 };
    moduleToBuffer2(m, &буф, &hgs);

    auto generated = буф.извлекиСрез.replace("\t", "    ");
    return generated.assumeUnique;
}

/// Interface for diagnostic reporting.
abstract class DiagnosticReporter
{
    DiagnosticHandler prevHandler;

    this()
    {
        prevHandler = diagnosticHandler;
        diagnosticHandler = &diagHandler;
    }

    ~this()
    {
        // assumed to be используется scoped
        diagnosticHandler = prevHandler;
    }

    бул diagHandler(ref Место место, Color headerColor, ткст0 header,
                     ткст0 format, va_list ap, ткст0 p1, ткст0 p2)
    {
        // recover тип from header and color
        if (strncmp (header, "Error:", 6) == 0)
            return выведиОшибку(место, format, ap, p1, p2);
        if (strncmp (header, "Warning:", 8) == 0)
            return warning(место, format, ap, p1, p2);
        if (strncmp (header, "Deprecation:", 12) == 0)
            return deprecation(место, format, ap, p1, p2);

        if (cast(Classification)headerColor == Classification.warning)
            return warningSupplemental(место, format, ap, p1, p2);
        if (cast(Classification)headerColor == Classification.deprecation)
            return deprecationSupplemental(место, format, ap, p1, p2);

        return errorSupplemental(место, format, ap, p1, p2);
    }

    /// Возвращает: the number of errors that occurred during lexing or parsing.
    abstract цел errorCount();

    /// Возвращает: the number of warnings that occurred during lexing or parsing.
    abstract цел warningCount();

    /// Возвращает: the number of deprecations that occurred during lexing or parsing.
    abstract цел deprecationCount();

    /**
    Reports an error message.

    Параметры:
        место = Location of error
        format = format ткст for error
        args = printf-style variadic arguments
        p1 = additional message префикс
        p2 = additional message префикс

    Возвращает: нет if the message should also be printed to stderr, да otherwise
    */
    abstract бул выведиОшибку(ref Место место, ткст0 format, va_list args, ткст0 p1, ткст0 p2);

    /**
    Reports additional details about an error message.

    Параметры:
        место = Location of error
        format = format ткст for supplemental message
        args = printf-style variadic arguments
        p1 = additional message префикс
        p2 = additional message префикс

    Возвращает: нет if the message should also be printed to stderr, да otherwise
    */
    abstract бул errorSupplemental(ref Место место, ткст0 format, va_list args, ткст0 p1, ткст0 p2);

    /**
    Reports a warning message.

    Параметры:
        место = Location of warning
        format = format ткст for warning
        args = printf-style variadic arguments
        p1 = additional message префикс
        p2 = additional message префикс

    Возвращает: нет if the message should also be printed to stderr, да otherwise
    */
    abstract бул warning(ref Место место, ткст0 format, va_list args, ткст0 p1, ткст0 p2);

    /**
    Reports additional details about a warning message.

    Параметры:
        место = Location of warning
        format = format ткст for supplemental message
        args = printf-style variadic arguments
        p1 = additional message префикс
        p2 = additional message префикс

    Возвращает: нет if the message should also be printed to stderr, да otherwise
    */
    abstract бул warningSupplemental(ref Место место, ткст0 format, va_list args, ткст0 p1, ткст0 p2);

    /**
    Reports a deprecation message.

    Параметры:
        место = Location of the deprecation
        format = format ткст for the deprecation
        args = printf-style variadic arguments
        p1 = additional message префикс
        p2 = additional message префикс

    Возвращает: нет if the message should also be printed to stderr, да otherwise
    */
    abstract бул deprecation(ref Место место, ткст0 format, va_list args, ткст0 p1, ткст0 p2);

    /**
    Reports additional details about a deprecation message.

    Параметры:
        место = Location of deprecation
        format = format ткст for supplemental message
        args = printf-style variadic arguments
        p1 = additional message префикс
        p2 = additional message префикс

    Возвращает: нет if the message should also be printed to stderr, да otherwise
    */
    abstract бул deprecationSupplemental(ref Место место, ткст0 format, va_list args, ткст0 p1, ткст0 p2);
}

/**
Diagnostic reporter which prints the diagnostic messages to stderr.

This is usually the default diagnostic reporter.
*/
final class StderrDiagnosticReporter : DiagnosticReporter
{
    private const DiagnosticReporting useDeprecated;

    private цел errorCount_;
    private цел warningCount_;
    private цел deprecationCount_;

    /**
    Initializes this объект.

    Параметры:
        useDeprecated = indicates how deprecation diagnostics should be
                        handled
    */
    this(DiagnosticReporting useDeprecated)
    {
        this.useDeprecated = useDeprecated;
    }

    override цел errorCount()
    {
        return errorCount_;
    }

    override цел warningCount()
    {
        return warningCount_;
    }

    override цел deprecationCount()
    {
        return deprecationCount_;
    }

    override бул выведиОшибку(ref Место место, ткст0 format, va_list args, ткст0 p1, ткст0 p2)
    {
        errorCount_++;
        return нет;
    }

    override бул errorSupplemental(ref Место место, ткст0 format, va_list args, ткст0 p1, ткст0 p2)
    {
        return нет;
    }

    override бул warning(ref Место место, ткст0 format, va_list args, ткст0 p1, ткст0 p2)
    {
        warningCount_++;
        return нет;
    }

    override бул warningSupplemental(ref Место место, ткст0 format, va_list args, ткст0 p1, ткст0 p2)
    {
        return нет;
    }

    override бул deprecation(ref Место место, ткст0 format, va_list args, ткст0 p1, ткст0 p2)
    {
        if (useDeprecated == DiagnosticReporting.error)
            errorCount_++;
        else
            deprecationCount_++;
        return нет;
    }

    override бул deprecationSupplemental(ref Место место, ткст0 format, va_list args, ткст0 p1, ткст0 p2)
    {
        return нет;
    }
}

