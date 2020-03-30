module clang.Diagnostic;

import std.typecons : RefCounted;

import clang.c.Index;
import clang.Util;

struct Diagnostic
{
    mixin CX;

    ткст format (uint options = clang_defaultDiagnosticDisplayOptions)
    {
        return toD(clang_formatDiagnostic(cx, options));
    }

    CXDiagnosticSeverity severity ()
    {
        return clang_getDiagnosticSeverity(cx);
    }

    вТкст()
    {
        return format();
    }
}

struct DiagnosticSet
{
    private struct Container
    {
        CXDiagnosticSet set;

        ~this()
        {
            if (set != пусто)
            {
                clang_disposeDiagnosticSet(set);
            }
        }
    }

    private RefCounted!(Container) container;
    private т_мера begin;
    private т_мера end;

    private static RefCounted!(Container) makeContainer(
        CXDiagnosticSet set)
    {
        RefCounted!(Container) result;
        result.set = set;
        return result;
    }

    private this(
        RefCounted!(Container) container,
        т_мера begin,
        т_мера end)
    {
        this.container = container;
        this.begin = begin;
        this.end = end;
    }

    this(CXDiagnosticSet set)
    {
        container = makeContainer(set);
        begin = 0;
        end = clang_getNumDiagnosticsInSet(container.set);
    }

    бул empty()
    {
        return begin >= end;
    }

    Diagnostic front()
    {
        return Diagnostic(clang_getDiagnosticInSet(container.set, cast(uint) begin));
    }

    Diagnostic back()
    {
        return Diagnostic(clang_getDiagnosticInSet(container.set, cast(uint) (end - 1)));
    }

    проц popFront()
    {
        ++begin;
    }

    проц popBack()
    {
        --end;
    }

    DiagnosticSet save()
    {
        return this;
    }

    т_мера length()
    {
        return end - begin;
    }

    Diagnostic opIndex(т_мера index)
    {
        return Diagnostic(clang_getDiagnosticInSet(container.set, cast(uint) (begin + index)));
    }

    DiagnosticSet opSlice(т_мера begin, т_мера end)
    {
        return DiagnosticSet(container, this.begin + begin, this.begin + end);
    }

    т_мера opDollar()
    {
        return length;
    }
}

CXDiagnosticSeverity severity(DiagnosticSet diagnostics)
{
    import std.algorithm.searching : minPos;
    import std.algorithm.iteration : map;

    alias less = (a, b) => cast(uint) a > cast(uint) b;

    if (diagnostics.empty)
        return CXDiagnosticSeverity.ignored;
    else
        return diagnostics.map!(diagnostic => diagnostic.severity).minPos!less.front;
}

бул hasError(DiagnosticSet diagnostics)
{
    auto severity = diagnostics.severity;

    return severity == CXDiagnosticSeverity.error ||
        severity == CXDiagnosticSeverity.fatal;
}
