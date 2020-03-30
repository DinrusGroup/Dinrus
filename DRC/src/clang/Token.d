/**
 * Copyright: Copyright (c) 2016 Wojciech Szęszoł. All rights reserved.
 * Authors: Wojciech Szęszoł
 * Version: Initial created: Feb 14, 2016
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module clang.Token;

import std.conv : to;
import std.typecons;
public import std.range.primitives : empty, front, back;

import clang.c.Index;
import clang.SourceLocation;
import clang.SourceRange;
import clang.Type;
import clang.Util;
import clang.Visitor;
import clang.Cursor;

enum TokenKind
{
    punctuation = CXTokenKind.punctuation,
    keyword = CXTokenKind.keyword,
    identifier = CXTokenKind.identifier,
    literal = CXTokenKind.literal,
    коммент = CXTokenKind.коммент,
}

TokenKind toD(CXTokenKind вид)
{
    return cast(TokenKind) вид;
}

struct Token
{
    TokenKind вид;
    ткст spelling;
    SourceRange extent;

    SourceLocation location()
    {
        return extent.start;
    }

    ткст вТкст() const
    {
        import std.format: format;
        return format("Token(вид = %s, spelling = %s)", вид, spelling);
    }
}

SourceRange extent(Token[] tokens)
{
    if (!tokens.empty)
        return SourceRange(
            tokens.front.extent.start,
            tokens.back.extent.end);
    else
        return SourceRange.empty;
}
