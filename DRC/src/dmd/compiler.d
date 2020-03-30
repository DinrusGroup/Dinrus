/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/compiler.d, _compiler.d)
 * Documentation:  https://dlang.org/phobos/dmd_compiler.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/compiler.d
 */

module dmd.compiler;

import drc.ast.AstCodegen;
import dmd.arraytypes;
import dmd.dmodule;
import dmd.dscope;
import dmd.dsymbolsem;
import dmd.errors;
import drc.ast.Expression;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.mtype;
import drc.parser.Parser2;
import util.array;
import util.ctfloat;
import dmd.semantic2;
import dmd.semantic3;
import drc.lexer.Tokens;

 
    /// Модуль, в котором находится D main
    Module rootHasMain = null;

    бул includeImports = нет;
    // массив из патернов модулей, используемых для включения/исключения импортируемых модулей
    МассивДРК!(сим*) includeModulePatterns;
    Modules compiledImports;



/**
 * Структура данных, описывающая back-end компилятор и реализующая
 * compiler-specific действия.
 */
 struct Compiler
{
    /******************************
     * Encode the given Выражение, which is assumed to be an rvalue literal
     * as another тип for use in CTFE.
     * This corresponds roughly to the idiom *(Тип *)&e.
     */
     static Выражение paintAsType(UnionExp* pue, Выражение e, Тип тип)
    {
        union U
        {
            d_int32 int32value;
            d_int64 int64value;
            float float32value;
            double float64value;
        }
        U u = проц;

        assert(e.тип.size() == тип.size());

        switch (e.тип.ty)
        {
        case Tint32:
        case Tuns32:
            u.int32value = cast(d_int32) e.toInteger();
            break;
        case Tint64:
        case Tuns64:
            u.int64value = cast(d_int64) e.toInteger();
            break;
        case Tfloat32:
            u.float32value = cast(float) e.toReal();
            break;
        case Tfloat64:
            u.float64value = cast(double) e.toReal();
            break;
        case Tfloat80:
            assert(e.тип.size() == 8); // 64-bit target `real`
            goto case Tfloat64;
        default:
            assert(0, "Unsupported source тип");
        }

        real_t r = проц;
        switch (тип.ty)
        {
        case Tint32:
        case Tuns32:
            emplaceExp!(IntegerExp)(pue, e.место, u.int32value, тип);
            break;

        case Tint64:
        case Tuns64:
            emplaceExp!(IntegerExp)(pue, e.место, u.int64value, тип);
            break;

        case Tfloat32:
            r = u.float32value;
            emplaceExp!(RealExp)(pue, e.место, r, тип);
            break;

        case Tfloat64:
            r = u.float64value;
            emplaceExp!(RealExp)(pue, e.место, r, тип);
            break;

        case Tfloat80:
            assert(тип.size() == 8); // 64-bit target `real`
            goto case Tfloat64;

        default:
            assert(0, "Unsupported target тип");
        }
        return pue.exp();
    }

    /******************************
     * For the given module, perform any post parsing analysis.
     * Certain compiler backends (ie: GDC) have special placeholder
     * modules whose source are empty, but code gets injected
     * immediately after loading.
     */
     static проц loadModule(Module m)
    {
    }

    /**
     * A callback function that is called once an imported module is
     * parsed. If the callback returns да, then it tells the
     * frontend that the driver intends on compiling the import.
     */
    /*extern(C++)*/ static бул onImport(Module m)
    {
        if (includeImports)
        {
            Идентификаторы empty;
            if (includeImportedModuleCheck(ModuleComponentRange(
                (m.md && m.md.пакеты) ? m.md.пакеты : &empty, m.идент, m.isPackageFile)))
            {
                if (глоб2.парамы.verbose)
                    message("compileimport (%s)", m.srcfile.вТкст0);
                compiledImports.сунь(m);
                return да; // this import will be compiled
            }
        }
        return нет; // this import will not be compiled
    }
}

/******************************
 * Private helpers for Compiler::onImport.
 */
// A range of component identifiers for a module
private struct ModuleComponentRange
{
    Идентификаторы* пакеты;
    Идентификатор2 имя;
    бул isPackageFile;
    т_мера index;
     т_мера totalLength(){ return пакеты.dim + 1 + (isPackageFile ? 1 : 0); }

     бул empty() { return index >= totalLength(); }
     т_мера front()
    {
        if (index < пакеты.dim)
            return (*пакеты)[index];
        if (index == пакеты.dim)
            return имя;
        else
            return Идентификатор2.idPool("package");
    }
    проц popFront() { index++; }
}

/*
 * Determines if the given module should be included in the compilation.
 * Возвращает:
 *  True if the given module should be included in the compilation.
 */
private бул includeImportedModuleCheck(ModuleComponentRange components)
    in { assert(includeImports); }
body
{
    createMatchNodes();
    т_мера nodeIndex = 0;
    while (nodeIndex < matchNodes.dim)
    {
        //printf("matcher ");printMatcher(nodeIndex);printf("\n");
        auto info = matchNodes[nodeIndex++];
        if (info.depth <= components.totalLength())
        {
            т_мера nodeOffset = 0;
            for (auto range = components;;range.popFront())
            {
                if (range.empty || nodeOffset >= info.depth)
                {
                    // MATCH
                    return !info.isExclude;
                }
                if (!(range.front is matchNodes[nodeIndex + nodeOffset].ид))
                {
                    break;
                }
                nodeOffset++;
            }
        }
        nodeIndex += info.depth;
    }
    assert(nodeIndex == matchNodes.dim, "code bug");
    return includeByDefault;
}

// Matching module имена is done with an массив of matcher nodes.
// The nodes are sorted by "component depth" from largest to smallest
// so that the first match is always the longest (best) match.
private struct MatcherNode
{
    union
    {
        struct
        {
            ushort depth;
            бул isExclude;
        }
        Идентификатор2 ид;
    }
    this(Идентификатор2 ид) { this.ид = ид; }
    this(бул isExclude, ushort depth)
    {
        this.depth = depth;
        this.isExclude = isExclude;
    }
}

/*
 * $(D includeByDefault) determines whether to include/exclude modules when they don't
 * match any pattern. This setting changes depending on if the user provided any "inclusive" module
 * patterns. When a single "inclusive" module pattern is given, it likely means the user only
 * intends to include modules they've "included", however, if no module patterns are given or they
 * are all "exclusive", then it is likely they intend to include everything except modules
 * that have been excluded. i.e.
 * ---
 * -i=-foo // include everything except modules that match "foo*"
 * -i=foo  // only include modules that match "foo*" (exclude everything else)
 * ---
 * Note that this default behavior can be overriden using the '.' module pattern. i.e.
 * ---
 * -i=-foo,-.  // this excludes everything
 * -i=foo,.    // this includes everything except the default exclusions (-std,-core,-etc.-объект)
 * ---
*/
private  бул includeByDefault = да;
private  МассивДРК!(MatcherNode) matchNodes;

/*
 * Creates the глоб2 list of match nodes используется to match module имена
 * given strings provided by the -i commmand line опция.
 */
private проц createMatchNodes()
{
    static т_мера findSortedIndexToAddForDepth(т_мера depth)
    {
        т_мера index = 0;
        while (index < matchNodes.dim)
        {
            auto info = matchNodes[index];
            if (depth > info.depth)
                break;
            index += 1 + info.depth;
        }
        return index;
    }

    if (matchNodes.dim == 0)
    {
        foreach (modulePattern; includeModulePatterns)
        {
            auto depth = parseModulePatternDepth(modulePattern);
            auto entryIndex = findSortedIndexToAddForDepth(depth);
            matchNodes.split(entryIndex, depth + 1);
            parseModulePattern(modulePattern, &matchNodes[entryIndex], depth);
            // if at least 1 "include pattern" is given, then it is assumed the
            // user only wants to include modules that were explicitly given, which
            // changes the default behavior from inclusion to exclusion.
            if (includeByDefault && !matchNodes[entryIndex].isExclude)
            {
                //printf("Matcher: found 'include pattern', switching default behavior to exclusion\n");
                includeByDefault = нет;
            }
        }

        // Add the default 1 depth matchers
        MatcherNode[8] defaultDepth1MatchNodes = [
            MatcherNode(да, 1), MatcherNode(Id.std),
            MatcherNode(да, 1), MatcherNode(Id.core),
            MatcherNode(да, 1), MatcherNode(Id.etc),
            MatcherNode(да, 1), MatcherNode(Id.объект),
        ];
        {
            auto index = findSortedIndexToAddForDepth(1);
            matchNodes.split(index, defaultDepth1MatchNodes.length);
            auto slice = matchNodes[];
            slice[index .. index + defaultDepth1MatchNodes.length] = defaultDepth1MatchNodes[];
        }
    }
}

/*
 * Determines the depth of the given module pattern.
 * Параметры:
 *  modulePattern = The module pattern to determine the depth of.
 * Возвращает:
 *  The component depth of the given module pattern.
 */
private ushort parseModulePatternDepth(ткст0 modulePattern)
{
    if (modulePattern[0] == '-')
        modulePattern++;

    // handle special case
    if (modulePattern[0] == '.' && modulePattern[1] == '\0')
        return 0;

    ushort depth = 1;
    for (;; modulePattern++)
    {
        auto c = *modulePattern;
        if (c == '.')
            depth++;
        if (c == '\0')
            return depth;
    }
}
unittest
{
    assert(".".parseModulePatternDepth == 0);
    assert("-.".parseModulePatternDepth == 0);
    assert("abc".parseModulePatternDepth == 1);
    assert("-abc".parseModulePatternDepth == 1);
    assert("abc.foo".parseModulePatternDepth == 2);
    assert("-abc.foo".parseModulePatternDepth == 2);
}

/*
 * Parses a 'module pattern', which is the "include import" components
 * given on the command line, i.e. "-i=<module_pattern>,<module_pattern>,...".
 * Параметры:
 *  modulePattern = The module pattern to parse.
 *  dst = the данные structure to save the parsed module pattern to.
 *  depth = the depth of the module pattern previously retrieved from $(D parseModulePatternDepth).
 */
private проц parseModulePattern(ткст0 modulePattern, MatcherNode* dst, ushort depth)
{
    бул isExclude = нет;
    if (modulePattern[0] == '-')
    {
        isExclude = да;
        modulePattern++;
    }

    *dst = MatcherNode(isExclude, depth);
    dst++;

    // Create and add identifiers for each component in the modulePattern
    if (depth > 0)
    {
        auto idStart = modulePattern;
        auto lastNode = dst + depth - 1;
        for (; dst < lastNode; dst++)
        {
            for (;; modulePattern++)
            {
                if (*modulePattern == '.')
                {
                    assert(modulePattern > idStart, "empty module pattern");
                    *dst = MatcherNode(Идентификатор2.idPool(idStart, cast(бцел)(modulePattern - idStart)));
                    modulePattern++;
                    idStart = modulePattern;
                    break;
                }
            }
        }
        for (;; modulePattern++)
        {
            if (*modulePattern == '\0')
            {
                assert(modulePattern > idStart, "empty module pattern");
                *lastNode = MatcherNode(Идентификатор2.idPool(idStart, cast(бцел)(modulePattern - idStart)));
                break;
            }
        }
    }
}
