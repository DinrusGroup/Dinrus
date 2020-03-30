/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/errors.d, _errors.d)
 * Documentation:  https://dlang.org/phobos/dmd_errors.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/errors.d
 */

module dmd.errors;

import cidrus;
import dmd.globals;
import util.outbuffer;
import util.rmem;
import util.string;
import win;
import util.filecache : ФайлКэш;
import drc.lexer.Lexer2;
import drc.lexer.Tokens;

/**
 * Цвет highlighting to classify messages
 */
enum Classification
{
    error = Цвет.ЯркоКрасный,          /// for errors
    gagged = Цвет.ЯркоСиний,        /// for gagged errors
    warning = Цвет.ЯркоЖёлтый,     /// for warnings
    deprecation = Цвет.ЯркоЦыан,   /// for deprecations
    tip = Цвет.ЯркоЗелёный,          /// for tip messages
}

/**
 * Print an error message, increasing the глоб2 error count.
 * Параметры:
 *      место    = location of error
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
 проц выведиОшибку(ref Место место, ткст0 format, ...)
{
    va_list ap;
    va_start(ap, format);
    verror(место, format, ap);
    va_end(ap);
}

/**
 * Same as above, but allows Место() literals to be passed.
 * Параметры:
 *      место    = location of error
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
extern (D) проц выведиОшибку(Место место, ткст0 format, ...)
{
    va_list ap;
    va_start(ap, format);
    verror(место, format, ap);
    va_end(ap);
}

/**
 * Same as above, but takes a имяф and line information arguments as separate parameters.
 * Параметры:
 *      имяф = source файл of error
 *      номстр   = line in the source файл
 *      имяс  = column number on the line
 *      format   = printf-style format specification
 *      ...      = printf-style variadic arguments
 */
 проц выведиОшибку(ткст0 имяф, бцел номстр, бцел имяс, ткст0 format, ...)
{
    const место = Место(имяф, номстр, имяс);
    va_list ap;
    va_start(ap, format);
    verror(место, format, ap);
    va_end(ap);
}

/**
 * Print additional details about an error message.
 * Doesn't increase the error count or print an additional error префикс.
 * Параметры:
 *      место    = location of error
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
 проц errorSupplemental(ref Место место, ткст0 format, ...)
{
    va_list ap;
    va_start(ap, format);
    verrorSupplemental(место, format, ap);
    va_end(ap);
}

/**
 * Print a warning message, increasing the глоб2 warning count.
 * Параметры:
 *      место    = location of warning
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
 проц warning(ref Место место, ткст0 format, ...)
{
    va_list ap;
    va_start(ap, format);
    vwarning(место, format, ap);
    va_end(ap);
}

/**
 * Print additional details about a warning message.
 * Doesn't increase the warning count or print an additional warning префикс.
 * Параметры:
 *      место    = location of warning
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
 проц warningSupplemental(ref Место место, ткст0 format, ...)
{
    va_list ap;
    va_start(ap, format);
    vwarningSupplemental(место, format, ap);
    va_end(ap);
}

/**
 * Print a deprecation message, may increase the глоб2 warning or error count
 * depending on whether deprecations are ignored.
 * Параметры:
 *      место    = location of deprecation
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
 проц deprecation(ref Место место, ткст0 format, ...)
{
    va_list ap;
    va_start(ap, format);
    vdeprecation(место, format, ap);
    va_end(ap);
}

/**
 * Print additional details about a deprecation message.
 * Doesn't increase the error count, or print an additional deprecation префикс.
 * Параметры:
 *      место    = location of deprecation
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
 проц deprecationSupplemental(ref Место место, ткст0 format, ...)
{
    va_list ap;
    va_start(ap, format);
    vdeprecationSupplemental(место, format, ap);
    va_end(ap);
}

/**
 * Print a verbose message.
 * Doesn't префикс or highlight messages.
 * Параметры:
 *      место    = location of message
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
 проц message(ref Место место, ткст0 format, ...)
{
    va_list ap;
    va_start(ap, format);
    vmessage(место, format, ap);
    va_end(ap);
}

/**
 * Same as above, but doesn't take a location argument.
 * Параметры:
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
 проц message(ткст0 format, ...)
{
    va_list ap;
    va_start(ap, format);
    vmessage(Место.initial, format, ap);
    va_end(ap);
}

/**
 * The тип of the diagnostic handler
 * see verrorPrint for arguments
 * Возвращает: да if error handling is done, нет to continue printing to stderr
 */
alias бул delegate(ref Место location, Цвет headerColor, ткст0 header, ткст0 messageFormat, va_list args, ткст0 prefix1, ткст0 prefix2) DiagnosticHandler;

/**
 * The diagnostic handler.
 * If non-null it will be called for every diagnostic message issued by the compiler.
 * If it returns нет, the message will be printed to stderr as usual.
 */
 DiagnosticHandler diagnosticHandler;

/**
 * Print a tip message with the префикс and highlighting.
 * Параметры:
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
 проц tip(ткст0 format, ...)
{
    va_list ap;
    va_start(ap, format);
    vtip(format, ap);
    va_end(ap);
}

/**
 * Just print to stderr, doesn't care about gagging.
 * (format,ap) text within backticks gets syntax highlighted.
 * Параметры:
 *      место         = location of error
 *      headerColor = цвет to set `header` output to
 *      header      = title of error message
 *      format      = printf-style format specification
 *      ap          = printf-style variadic arguments
 *      p1          = additional message префикс
 *      p2          = additional message префикс
 */
private проц verrorPrint(ref Место место, Цвет headerColor, ткст0 header,
        ткст0 format, va_list ap, ткст0 p1 = null, ткст0 p2 = null)
{
    if (diagnosticHandler && diagnosticHandler(место, headerColor, header, format, ap, p1, p2))
        return;

    if (глоб2.парамы.showGaggedErrors && глоб2.gag)
        fprintf(stderr, "(spec:%d) ", глоб2.gag);
    auto con = глоб2.console;
    const p = место.вТкст0();
    if (con)
        устЯркостьЦветаКонсоли(да);
    if (*p)
    {
        fprintf(stderr, "%s: ", p);
        mem.xfree(cast(ук)p);
    }
    if (con)
        устЦветКонсоли(headerColor);
    fputs(header, stderr);
    if (con)
        сбросьЦветКонсоли();
    БуфВыв tmp;
    if (p1)
    {
        tmp.пишиСтр(p1);
        tmp.пишиСтр(" ");
    }
    if (p2)
    {
        tmp.пишиСтр(p2);
        tmp.пишиСтр(" ");
    }
    tmp.vprintf(format, ap);

    if (con && strchr(tmp.peekChars(), '`'))
    {
        colorSyntaxHighlight(tmp);
        writeHighlights(tmp);
    }
    else
        fputs(tmp.peekChars(), stderr);
    fputc('\n', stderr);

    if (глоб2.парамы.printErrorContext &&
        // ignore invalid files
        место != Место.initial &&
        // ignore mixins for now
        !место.имяф.strstr(".d-mixin-") &&
        !глоб2.парамы.mixinOut)
    {
        auto fllines = ФайлКэш.fileCache.addOrGetFile(место.имяф.вТкстД());

        if (место.номстр - 1 < fllines.строки.length)
        {
            auto line = fllines.строки[место.номстр - 1];
            if (место.имяс < line.length)
            {
                fprintf(stderr, "%.*s\n", cast(цел)line.length, line.ptr);
                foreach (_; new бцел[1 .. место.имяс])
                    fputc(' ', stderr);

                fputc('^', stderr);
                fputc('\n', stderr);
            }
        }
    }
    fflush(stderr);     // ensure it gets written out in case of compiler aborts
}

/**
 * Same as $(D error), but takes a va_list параметр, and optionally additional message prefixes.
 * Параметры:
 *      место    = location of error
 *      format = printf-style format specification
 *      ap     = printf-style variadic arguments
 *      p1     = additional message префикс
 *      p2     = additional message префикс
 *      header = title of error message
 */
 проц verror(ref Место место, ткст0 format, va_list ap, ткст0 p1 = null, ткст0 p2 = null, ткст0 header = "Error: ")
{
    глоб2.errors++;
    if (!глоб2.gag)
    {
        verrorPrint(место, Classification.error, header, format, ap, p1, p2);
        if (глоб2.парамы.errorLimit && глоб2.errors >= глоб2.парамы.errorLimit)
            fatal(); // moderate blizzard of cascading messages
    }
    else
    {
        if (глоб2.парамы.showGaggedErrors)
            verrorPrint(место, Classification.gagged, header, format, ap, p1, p2);
        глоб2.gaggedErrors++;
    }
}

/**
 * Same as $(D errorSupplemental), but takes a va_list параметр.
 * Параметры:
 *      место    = location of error
 *      format = printf-style format specification
 *      ap     = printf-style variadic arguments
 */
 проц verrorSupplemental(ref Место место, ткст0 format, va_list ap)
{
    Цвет цвет;
    if (глоб2.gag)
    {
        if (!глоб2.парамы.showGaggedErrors)
            return;
        цвет = Classification.gagged;
    }
    else
        цвет = Classification.error;
    verrorPrint(место, цвет, "       ", format, ap);
}

/**
 * Same as $(D warning), but takes a va_list параметр.
 * Параметры:
 *      место    = location of warning
 *      format = printf-style format specification
 *      ap     = printf-style variadic arguments
 */
 проц vwarning(ref Место место, ткст0 format, va_list ap)
{
    if (глоб2.парамы.warnings != DiagnosticReporting.off)
    {
        if (!глоб2.gag)
        {
            verrorPrint(место, Classification.warning, "Warning: ", format, ap);
            if (глоб2.парамы.warnings == DiagnosticReporting.error)
                глоб2.warnings++;
        }
        else
        {
            глоб2.gaggedWarnings++;
        }
    }
}

/**
 * Same as $(D warningSupplemental), but takes a va_list параметр.
 * Параметры:
 *      место    = location of warning
 *      format = printf-style format specification
 *      ap     = printf-style variadic arguments
 */
 проц vwarningSupplemental(ref Место место, ткст0 format, va_list ap)
{
    if (глоб2.парамы.warnings != DiagnosticReporting.off && !глоб2.gag)
        verrorPrint(место, Classification.warning, "       ", format, ap);
}

/**
 * Same as $(D deprecation), but takes a va_list параметр, and optionally additional message prefixes.
 * Параметры:
 *      место    = location of deprecation
 *      format = printf-style format specification
 *      ap     = printf-style variadic arguments
 *      p1     = additional message префикс
 *      p2     = additional message префикс
 */
 проц vdeprecation(ref Место место, ткст0 format, va_list ap, ткст0 p1 = null, ткст0 p2 = null)
{
     ткст0 header = "Deprecation: ";
    if (глоб2.парамы.useDeprecated == DiagnosticReporting.error)
        verror(место, format, ap, p1, p2, header);
    else if (глоб2.парамы.useDeprecated == DiagnosticReporting.inform)
    {
        if (!глоб2.gag)
        {
            verrorPrint(место, Classification.deprecation, header, format, ap, p1, p2);
        }
        else
        {
            глоб2.gaggedWarnings++;
        }
    }
}

/**
 * Same as $(D message), but takes a va_list параметр.
 * Параметры:
 *      место       = location of message
 *      format    = printf-style format specification
 *      ap        = printf-style variadic arguments
 */
 проц vmessage(ref Место место, ткст0 format, va_list ap)
{
    const p = место.вТкст0();
    if (*p)
    {
        fprintf(stdout, "%s: ", p);
        mem.xfree(cast(ук)p);
    }
    БуфВыв tmp;
    tmp.vprintf(format, ap);
    fputs(tmp.peekChars(), stdout);
    fputc('\n', stdout);
    fflush(stdout);     // ensure it gets written out in case of compiler aborts
}

/**
 * Same as $(D tip), but takes a va_list параметр.
 * Параметры:
 *      format    = printf-style format specification
 *      ap        = printf-style variadic arguments
 */
 проц vtip(ткст0 format, va_list ap)
{
    if (!глоб2.gag)
    {
        Место место = Место.init;
        verrorPrint(место, Classification.tip, "  Tip: ", format, ap);
    }
}

/**
 * Same as $(D deprecationSupplemental), but takes a va_list параметр.
 * Параметры:
 *      место    = location of deprecation
 *      format = printf-style format specification
 *      ap     = printf-style variadic arguments
 */
 проц vdeprecationSupplemental(ref Место место, ткст0 format, va_list ap)
{
    if (глоб2.парамы.useDeprecated == DiagnosticReporting.error)
        verrorSupplemental(место, format, ap);
    else if (глоб2.парамы.useDeprecated == DiagnosticReporting.inform && !глоб2.gag)
        verrorPrint(место, Classification.deprecation, "       ", format, ap);
}

/**
 * Call this after printing out fatal error messages to clean up and exit
 * the compiler.
 */
 проц fatal()
{
    version (none)
    {
        halt();
    }
    exit(EXIT_FAILURE);
}

/**
 * Try to stop forgetting to удали the breakpoints from
 * release builds.
 */
 проц halt()
{
    assert(0);
}

/**
 * Scan characters in `буф`. Assume text enclosed by `...`
 * is D source code, and цвет syntax highlight it.
 * Modify contents of `буф` with highlighted результат.
 * Many parallels to ddoc.highlightText().
 * Параметры:
 *      буф = text containing `...` code to highlight
 */
private проц colorSyntaxHighlight(ref БуфВыв буф)
{
    //printf("colorSyntaxHighlight('%.*s')\n", cast(цел)буф.length, буф.данные);
    бул inBacktick = нет;
    т_мера iCodeStart = 0;
    т_мера смещение = 0;
    for (т_мера i = смещение; i < буф.length; ++i)
    {
        сим c = буф[i];
        switch (c)
        {
            case '`':
                if (inBacktick)
                {
                    inBacktick = нет;
                    БуфВыв codebuf;
                    codebuf.пиши(буф[iCodeStart + 1 .. i]);
                    codebuf.пишиБайт(0);
                    // ýñêàïèðóé the contents, but do not perform highlighting except for DDOC_PSYMBOL
                    colorHighlightCode(codebuf);
                    буф.удали(iCodeStart, i - iCodeStart + 1); // also trimming off the current `
                    const pre = "";
                    i = буф.вставь(iCodeStart, pre);
                    i = буф.вставь(i, codebuf[]);
                    i--; // point to the ending ) so when the for loop does i++, it will see the следщ character
                    break;
                }
                inBacktick = да;
                iCodeStart = i;
                break;

            default:
                break;
        }
    }
}


/**
 * Embed these highlighting commands in the text stream.
 * HIGHLIGHT.Escape indicates a Цвет follows.
 */
enum HIGHLIGHT : ббайт
{
    Default    = Цвет.Чёрный,           // back to whatever the console is set at
    Escape     = '\xFF',                // highlight Цвет follows
    Идентификатор2 = Цвет.Белый,
    Keyword    = Цвет.Белый,
    Literal    = Цвет.Белый,
    Comment    =Цвет.ТёмноСерый,
    Other      = Цвет.Цыан,           // other tokens
}

/**
 * Highlight code for CODE section.
 * Rewrite the contents of `буф` with embedded highlights.
 * Analogous to doc.highlightCode2()
 */

private проц colorHighlightCode(ref БуфВыв буф)
{
     цел nested;
    if (nested)
    {
        // Should never happen, but don't infinitely recurse if it does
        --nested;
        return;
    }
    ++nested;

    auto gaggedErrorsSave = глоб2.startGagging();
    scope Lexer lex = new Lexer(null, cast(сим*)буф[].ptr, 0, буф.length - 1, 0, 1);
    БуфВыв res;
    ткст0 lastp = cast(сим*)буф[].ptr;
    //printf("colorHighlightCode('%.*s')\n", cast(цел)(буф.length - 1), буф.данные);
    res.резервируй(буф.length);
    res.пишиБайт(HIGHLIGHT.Escape);
    res.пишиБайт(HIGHLIGHT.Other);
    while (1)
    {
        Сема2 tok;
        lex.scan(&tok);
        res.пишиСтр(lastp[0 .. tok.ptr - lastp]);
        HIGHLIGHT highlight;
        switch (tok.значение)
        {
        case ТОК2.идентификатор:
            highlight = HIGHLIGHT.Идентификатор2;
            break;
        case ТОК2.коммент:
            highlight = HIGHLIGHT.Comment;
            break;
        case ТОК2.int32Literal:
           // ..
        case ТОК2.dcharLiteral:
        case ТОК2.string_:
            highlight = HIGHLIGHT.Literal;
            break;
        default:
            if (tok.isKeyword())
                highlight = HIGHLIGHT.Keyword;
            break;
        }
        if (highlight != HIGHLIGHT.Default)
        {
            res.пишиБайт(HIGHLIGHT.Escape);
            res.пишиБайт(highlight);
            res.пишиСтр(tok.ptr[0 .. lex.p - tok.ptr]);
            res.пишиБайт(HIGHLIGHT.Escape);
            res.пишиБайт(HIGHLIGHT.Other);
        }
        else
            res.пишиСтр(tok.ptr[0 .. lex.p - tok.ptr]);
        if (tok.значение == ТОК2.endOfFile)
            break;
        lastp = lex.p;
    }
    res.пишиБайт(HIGHLIGHT.Escape);
    res.пишиБайт(HIGHLIGHT.Default);
    //printf("res = '%.*s'\n", cast(цел)буф.length, буф.данные);
    буф.устРазм(0);
    буф.пиши(&res);
    глоб2.endGagging(gaggedErrorsSave);
    --nested;
}

/**
 * Write the буфер contents with embedded highlights to stderr.
 * Параметры:
 *      буф = highlighted text
 */
private проц writeHighlights( ref БуфВыв буф)
{
    бул цвета;
    scope (exit)
    {
        /* Do not mess up console if highlighting aborts
         */
        if (цвета)
            win.сбросьЦветКонсоли();
    }

    for (т_мера i = 0; i < буф.length; ++i)
    {
        const c = буф[i];
        if (c == HIGHLIGHT.Escape)
        {
            const цвет = буф[++i];
            if (цвет == HIGHLIGHT.Default)
            {
                win.сбросьЦветКонсоли();
                цвета = нет;
            }
            else
            if (цвет == Цвет.Белый)
            {
                win.сбросьЦветКонсоли();
                win.устЯркостьЦветаКонсоли(да);
                цвета = да;
            }
            else
            {
                win.устЦветКонсоли(cast(Цвет)цвет);
                цвета = да;
            }
        }
        else
            fputc(c, win.консВыход());
    }
}
