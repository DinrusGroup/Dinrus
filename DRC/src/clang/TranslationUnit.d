/**
 * Copyright: Copyright (c) 2011 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: Oct 1, 2011
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module clang.TranslationUnit;

import stdrus;


import clang.c.Index;
import clang.Cursor;
import clang.Diagnostic;
import clang.File;
import clang.Index;
import clang.SourceLocation;
import clang.SourceRange;
import clang.Token;
import clang.Util;
import clang.Visitor;

struct TranslationUnit
{
    mixin CX;

    ткст sourceString = пусто;

    static TranslationUnit parse (
        Index index,
        ткст sourceFilename,
        const ткст[] commandLineArgs = ["-Wno-missing-declarations"],
        CXUnsavedFile[] unsavedFiles = пусто,
        uint options = CXTranslationUnit_Flags.detailedPreprocessingRecord)
    {
        ткст[] arguments = commandLineArgs.dup;

        auto version_ = clangVersion();

        if (version_.major == 3 && version_.minor == 7)
            arguments ~= "-D__int64=long long";

        return TranslationUnit(
            clang_parseTranslationUnit(
                index.cx,
                sourceFilename.вТкстz,
                strToCМассив(arguments),
                cast(цел) arguments.length,
                toCМассив!(CXUnsavedFile)(unsavedFiles),
                cast(uint) unsavedFiles.length,
                options));
    }

    static TranslationUnit parseString (
        Index index,
        ткст source,
        ткст[] commandLineArgs = ["-Wno-missing-declarations"],
        CXUnsavedFile[] unsavedFiles = пусто,
        uint options = CXTranslationUnit_Flags.detailedPreprocessingRecord)
    {
        import std.file;

        auto file = namedTempFile("dstep", ".h");
        auto name = file.name();
        file.write(source);
        file.flush();
        file.detach();

        auto translationUnit = TranslationUnit.parse(
            index,
            name,
            commandLineArgs,
            unsavedFiles,
            options);

        remove(name);

        translationUnit.sourceString = source;

        return translationUnit;
    }

    package this (CXTranslationUnit cx)
    {
        this.cx = cx;
    }

    DiagnosticVisitor diagnostics ()
    {
        return DiagnosticVisitor(cx);
    }

    DiagnosticSet diagnosticSet ()
    {
        return DiagnosticSet(clang_getDiagnosticSetFromTU(cx));
    }

    т_мера numDiagnostics ()
    {
        return clang_getNumDiagnostics(cx);
    }

    бул isCompiled()
    {
        import std.algorithm;

        alias predicate =
            x => x.severity != CXDiagnosticSeverity.error &&
                x.severity != CXDiagnosticSeverity.fatal;

        return diagnosticSet.all!predicate();
    }

    DeclarationVisitor declarations ()
    {
        return DeclarationVisitor(clang_getTranslationUnitCursor(cx));
    }

    File file (ткст filename)
    {
        return File(clang_getFile(cx, filename.вТкстz));
    }

    File file ()
    {
        return file(spelling);
    }

    ткст spelling ()
    {
        return toD(clang_getTranslationUnitSpelling(cx));
    }

    ткст source ()
    {
        import std.file : readText;
        return sourceString ? sourceString : readText(spelling);
    }

    Cursor cursor ()
    {
        auto r = clang_getTranslationUnitCursor(cx);
        return Cursor(r);
    }

    SourceLocation location (uint offset)
    {
        CXFile file = clang_getFile(cx, spelling.вТкстz);
        return SourceLocation(clang_getLocationForOffset(cx, file, offset));
    }

    SourceLocation location (ткст path, uint offset)
    {
        CXFile file = clang_getFile(cx, path.вТкстz);
        return SourceLocation(clang_getLocationForOffset(cx, file, offset));
    }

    SourceRange extent (uint startOffset, uint endOffset)
    {
        CXFile file = clang_getFile(cx, spelling.вТкстz);
        auto start = clang_getLocationForOffset(cx, file, startOffset);
        auto end = clang_getLocationForOffset(cx, file, endOffset);
        return SourceRange(clang_getRange(start, end));
    }

    package SourceLocation[] includeLocationsImpl(Range)(Range cursors)
    {
        // `cursors` range should at least contain all глоб2
        // preprocessor cursors, although it can contain more.

        Set!ткст stacked;
        Set!ткст included;
        SourceLocation[] locationStack;
        SourceLocation[] locations = [ location("", 0), location(file.name, 0) ];

        foreach (cursor; cursors)
        {
            if (cursor.вид == CXCursorKind.inclusionDirective)
            {
                auto ptr = cursor.path in stacked;

                if (stacked.contains(cursor.path))
                {
                    while (locationStack[$ - 1].path != cursor.path)
                    {
                        stacked.remove(locationStack[$ - 1].path);
                        locations ~= locationStack[$ - 1];
                        locationStack = locationStack[0 .. $ - 1];
                    }

                    stacked.remove(cursor.path);
                    locations ~= locationStack[$ - 1];
                    locationStack = locationStack[0 .. $ - 1];
                }

                if ((cursor.includedPath in included) is пусто)
                {
                    locationStack ~= cursor.extent.end;
                    stacked.add(cursor.path);
                    locations ~= location(cursor.includedPath, 0);
                    included.add(cursor.includedPath);
                }
            }
        }

        while (locationStack.length != 0)
        {
            locations ~= locationStack[$ - 1];
            locationStack = locationStack[0 .. $ - 1];
        }

        return locations;
    }

    SourceLocation[] includeLocations()
    {
        return includeLocationsImpl(cursor.all);
    }

    package бдол delegate (SourceLocation)
        relativeLocationAccessorImpl(Range)(Range cursors)
    {
        // `cursors` range should at least contain all глоб2
        // preprocessor cursors, although it can contain more.

        SourceLocation[] locations = includeLocationsImpl(cursors);

        struct Entry
        {
            т_мера index;
            SourceLocation location;

            цел opCmp(ref const Entry s) const
            {
                return location.offset < s.location.offset ? -1 : 1;
            }

            цел opCmp(ref const SourceLocation s) const
            {
                return location.offset < s.offset + 1 ? -1 : 1;
            }
        }

        Entry[][ткст] map;

        foreach (index, location; locations)
            map[location.path] ~= Entry(index, location);

        т_мера findIndex(SourceLocation a)
        {
            auto entries = map[a.path];

            import std.range;

            auto lower = assumeSorted(entries).lowerBound(a);

            return lower.empty ? 0 : lower.back.index;
        }

        бдол accessor(SourceLocation location)
        {
            return ((cast(бдол) findIndex(location)) << 32) |
                (cast(бдол) location.offset);
        }

        return &accessor;
    }

    бдол delegate (SourceLocation)
        relativeLocationAccessor()
    {
        return relativeLocationAccessorImpl(cursor.all);
    }

    бул delegate (SourceLocation, SourceLocation)
        relativeLocationLessOp()
    {
        auto accessor = relativeLocationAccessor();

        бул lessOp(SourceLocation a, SourceLocation b)
        {
            if (a.file == b.file)
                return a.offset < b.offset;
            else
                return accessor(a) < accessor(b);
        }

        return &lessOp;
    }

    бул delegate (Cursor, Cursor)
        relativeCursorLocationLessOp()
    {
        auto accessor = relativeLocationAccessor();

        бул lessOp(Cursor a, Cursor b)
        {
            if (a.file == b.file)
                return a.location.offset < b.location.offset;
            else
                return accessor(a.location) < accessor(b.location);
        }

        return &lessOp;
    }

    private struct TokenRange
    {
        CXTranslationUnit cx;
        CXToken* tokens;
        uint numTokens;
        uint currentToken;

        Token makeToken(CXToken token)
        {
            return Token(
                clang_getTokenKind(token).toD,
                clang_getTokenSpelling(cx, token).toD,
                SourceRange(clang_getTokenExtent(cx, token)));
        }

        Token front()
        {
            return makeToken(tokens[currentToken]);
        }

        бул empty()
        {
            return numTokens == 0 || numTokens == currentToken;
        }

        проц popFront()
        {
            currentToken++;
        }

        проц dispose()
        {
            clang_disposeTokens(cx, tokens, numTokens);
        }
    }

    private static TokenRange tokenizeImpl(CXTranslationUnit cx, SourceRange extent)
    {
        auto range = TokenRange(cx);
        clang_tokenize(cx, extent.cx, &range.tokens, &range.numTokens);
        return range;
    }

    package static Token[] tokenize(CXTranslationUnit cx, SourceRange extent)
    {
        import std.array : array;
        import std.algorithm : stripRight;

        auto range = tokenizeImpl(cx, extent);
        auto tokens = range.array;
        range.dispose();

        // For some reason libclang returns some tokens out of cursors extent.cursor
        return tokens.stripRight!(token => !intersects(extent, token.extent));
    }

    package static Token[] tokenizeNoComments(CXTranslationUnit cx, SourceRange extent)
    {
        import std.array : array;
        import std.algorithm : filter, stripRight;

        auto range = tokenizeImpl(cx, extent);
        auto tokens = range.filter!(e => e.вид != TokenKind.коммент).array;
        range.dispose();

        // For some reason libclang returns some tokens out of cursors extent.cursor
        return tokens.stripRight!(token => !intersects(extent, token.extent));
    }

    Token[] tokenize(SourceRange extent)
    {
        return tokenize(cx, extent);
    }

    Token[] tokenizeNoComments(SourceRange extent)
    {
        return tokenizeNoComments(cx, extent);
    }

    Token[] tokens()
    {
        return tokenize(extent(0, cast(uint) source.length));
    }

    Token[] tokensNoComments()
    {
        return tokenizeNoComments(extent(0, cast(uint) source.length));
    }

    бул isFileMultipleIncludeGuarded(ткст path)
    {
        auto file = clang_getFile(cx, path.вТкстz);
        return clang_isFileMultipleIncludeGuarded(cx, file) != 0;
    }

    бул isMultipleIncludeGuarded()
    {
        return isFileMultipleIncludeGuarded(spelling);
    }

    ткст dumpAST(бул skipIncluded = да)
    {
        import std.array : appender;

        auto result = appender!ткст();

        if (skipIncluded)
        {
            File file = this.file;
            cursor.dumpAST(result, 0, &file);
        }
        else
        {
            cursor.dumpAST(result, 0);
        }

        return result.data;
    }
}

struct DiagnosticVisitor
{
    private CXTranslationUnit translatoinUnit;

    this (CXTranslationUnit translatoinUnit)
    {
        this.translatoinUnit = translatoinUnit;
    }

    т_мера length ()
    {
        return clang_getNumDiagnostics(translatoinUnit);
    }

    цел opApply (цел delegate (ref Diagnostic) dg)
    {
        цел result;

        foreach (i ; 0 .. length)
        {
            auto diag = clang_getDiagnostic(translatoinUnit, cast(uint) i);
            auto dDiag = Diagnostic(diag);
            result = dg(dDiag);

            if (result)
                break;
        }

        return result;
    }
}

Token[] tokenize(ткст source)
{
    Index index = Index(нет, нет);
    auto translUnit = TranslationUnit.parseString(index, source);
    return translUnit.tokenize(translUnit.extent(0, cast(uint) source.length));
}

Token[] tokenizeNoComments(ткст source)
{
    Index index = Index(нет, нет);
    auto translUnit = TranslationUnit.parseString(index, source);
    return translUnit.tokenizeNoComments(
        translUnit.extent(0, cast(uint) source.length));
}
