/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/imphint.d, _imphint.d)
 * Documentation:  https://dlang.org/phobos/dmd_imphint.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/imphint.d
 */

module dmd.imphint;

/******************************************
 * Looks for undefined идентификатор s to see
 * if it might be undefined because an import
 * was not specified.
 * Not meant to be a comprehensive list of имена in each module,
 * just the most common ones.
 */
ткст importHint(ткст s)
{
    if (auto entry = s in hints)
        return *entry;
    return null;
}

private const ткст[ткст] hints;
/+
static this()
{
    // in alphabetic order
    hints = [
        "AliasSeq": "std.meta",
        "appender": "std.массив",
        "массив": "std.массив",
        "calloc": "core.stdc.stdlib",
        "chdir": "std.файл",
        "cos": "std.math",
        "dirEntries": "std.файл",
        "drop": "std.range",
        "each": "std.algorithm",
        "empty": "std.range",
        "endsWith": "std.algorithm",
        "enforce": "std.exception",
        "enumerate": "std.range",
        "equal": "std.algorithm",
        "exists": "std.файл",
        "fabs": "std.math",
        "filter": "std.algorithm",
        "format": "std.format",
        "free": "core.stdc.stdlib",
        "front": "std.range",
        "iota": "std.range",
        "isDir": "std.файл",
        "isFile": "std.файл",
        "join": "std.массив",
        "joiner": "std.algorithm",
        "malloc": "core.stdc.stdlib",
        "map": "std.algorithm",
        "max": "std.algorithm",
        "min": "std.algorithm",
        "mkdir": "std.файл",
        "popFront": "std.range",
        "printf": "core.stdc.stdio",
        "realloc": "core.stdc.stdlib",
        "replace": "std.массив",
        "rmdir": "std.файл",
        "sin": "std.math",
        "sort": "std.algorithm",
        "split": "std.массив",
        "sqrt": "std.math",
        "startsWith": "std.algorithm",
        "take": "std.range",
        "text": "std.conv",
        "to": "std.conv",
        "writefln": "std.stdio",
        "writeln": "std.stdio",
        "__va_argsave_t": "core.stdc.stdarg",
        "__va_list_tag": "core.stdc.stdarg",
    ];
}

unittest
{
    assert(importHint("printf") !is null);
    assert(importHint("fabs") !is null);
    assert(importHint("xxxxx") is null);
}
+/