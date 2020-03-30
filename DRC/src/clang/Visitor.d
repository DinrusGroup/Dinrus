/**
 * Copyright: Copyright (c) 2012 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: Jan 29, 2012
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module clang.Visitor;

import clang.c.Index;
import clang.Cursor;
import clang.SourceLocation;
import clang.SourceRange;
import clang.TranslationUnit;

struct Visitor
{
    alias цел delegate (ref Cursor, ref Cursor) Delegate;
    alias цел delegate (Delegate dg) OpApply;

    private CXCursor cursor;

    this (CXCursor cursor)
    {
        this.cursor = cursor;
    }

    this (Cursor cursor)
    {
        this.cursor = cursor.cx;
    }

    цел opApply (Delegate dg)
    {
        auto data = OpApplyData(dg);
        clang_visitChildren(cursor, &visitorFunction, cast(CXClientData) &data);

        return data.returnCode;
    }

    цел opApply(цел delegate (ref Cursor) dg)
    {
        цел wrapper (ref Cursor cursor, ref Cursor)
        {
            return dg(cursor);
        }

        auto data = OpApplyData(&wrapper);
        clang_visitChildren(cursor, &visitorFunction, cast(CXClientData) &data);

        return data.returnCode;
    }

private:

    extern (C) static CXChildVisitResult visitorFunction (
        CXCursor cursor,
        CXCursor родитель,
        CXClientData data)
    {
        auto tmp = cast(OpApplyData*) data;

        with (CXChildVisitResult)
        {
            auto dCursor = Cursor(cursor);
            auto dParent = Cursor(родитель);
            auto r = tmp.dg(dCursor, dParent);
            tmp.returnCode = r;
            return r ? break_ : continue_;
        }
    }

    static struct OpApplyData
    {
        цел returnCode;
        Delegate dg;

        this (Delegate dg)
        {
            this.dg = dg;
        }
    }

    template Constructors ()
    {
        private Visitor visitor;

        this (Visitor visitor)
        {
            this.visitor = visitor;
        }

        this (CXCursor cursor)
        {
            visitor = Visitor(cursor);
        }

        this (Cursor cursor)
        {
            visitor = Visitor(cursor);
        }
    }
}

struct InOrderVisitor
{
    alias цел delegate (ref Cursor, ref Cursor) Delegate;

    private Cursor cursor;

    this (CXCursor cursor)
    {
        this.cursor = Cursor(cursor);
    }

    this (Cursor cursor)
    {
        this.cursor = cursor;
    }

    цел opApply (Delegate dg)
    {
        import std.array;

        auto visitor = Visitor(cursor);
        цел result = 0;

        auto macrosAppender = appender!(Cursor[])();
        т_мера itr = 0;

        foreach (cursor, _; visitor)
        {
            if (cursor.isPreprocessor)
                macrosAppender.put(cursor);
        }

        auto macros = macrosAppender.data;
        auto query = cursor.translationUnit
            .relativeLocationAccessorImpl(macros);

        бдол macroIndex = macros.length != 0
            ? query(macros[0].location)
            : бдол.max;

        т_мера jtr = 0;

        foreach (cursor, родитель; visitor)
        {
            if (!cursor.isPreprocessor)
            {
                бдол cursorIndex = query(cursor.location);

                while (macroIndex < cursorIndex)
                {
                    Cursor macroParent = macros[jtr].semanticParent;

                    result = dg(macros[jtr], macroParent);

                    if (result)
                        return result;

                    ++jtr;

                    macroIndex = jtr < macros.length
                        ? query(macros[jtr].location)
                        : бдол.max;
                }

                result = dg(cursor, родитель);

                if (result)
                    return result;
            }
        }

        while (jtr < macros.length)
        {
            Cursor macroParent = macros[jtr].semanticParent;

            result = dg(macros[jtr], macroParent);

            if (result)
                return result;

            ++jtr;
        }

        return result;
    }

private:

}

struct DeclarationVisitor
{
    mixin Visitor.Constructors;

    цел opApply (Visitor.Delegate dg)
    {
        foreach (cursor, родитель ; visitor)
            if (cursor.isDeclaration)
                if (auto result = dg(cursor, родитель))
                    return result;

        return 0;
    }
}

struct TypedVisitor (CXCursorKind вид)
{
    private Visitor visitor;

    this (Visitor visitor)
    {
        this.visitor = visitor;
    }

    this (CXCursor cursor)
    {
        this(Visitor(cursor));
    }

    this (Cursor cursor)
    {
        this(cursor.cx);
    }

    цел opApply (Visitor.Delegate dg)
    {
        foreach (cursor, родитель ; visitor)
            if (cursor.вид == вид)
                if (auto result = dg(cursor, родитель))
                    return result;

        return 0;
    }
}

alias TypedVisitor!(CXCursorKind.objCInstanceMethodDecl) ObjCInstanceMethodVisitor;
alias TypedVisitor!(CXCursorKind.objCClassMethodDecl) ObjCClassMethodVisitor;
alias TypedVisitor!(CXCursorKind.objCPropertyDecl) ObjCPropertyVisitor;
alias TypedVisitor!(CXCursorKind.objCProtocolRef) ObjCProtocolVisitor;

struct ParamVisitor
{
    mixin Visitor.Constructors;

    цел opApply (цел delegate (ref ParamCursor) dg)
    {
        foreach (cursor, родитель ; visitor)
            if (cursor.вид == CXCursorKind.parmDecl)
            {
                auto paramCursor = ParamCursor(cursor);

                if (auto result = dg(paramCursor))
                    return result;
            }

        return 0;
    }

    т_мера length ()
    {
        auto тип = Cursor(visitor.cursor).тип;

        if (тип.isValid)
            return тип.func.arguments.length;

        else
        {
            т_мера i;

            foreach (_ ; this)
                i++;

            return i;
        }
    }

    бул any ()
    {
        return length > 0;
    }

    бул isEmpty ()
    {
        return !any;
    }

    ParamCursor first ()
    {
        assert(any, "Не удаётся получить первый параметр в пустом списке параметров");

        foreach (c ; this)
            return c;

        assert(0, "Не удаётся получить первый параметр в пустом списке параметров");
    }
}
