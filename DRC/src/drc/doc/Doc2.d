/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/doc.d, _doc.d)
 * Documentation:  https://dlang.org/phobos/dmd_doc.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/doc.d
 */

module drc.doc.Doc2;

import cidrus;
import dmd.aggregate;
import dmd.arraytypes;
import dmd.attrib;
import dmd.cond;
import dmd.dclass;
import dmd.declaration;
import dmd.denum;
import dmd.dimport;
import dmd.dmacro;
import dmd.dmodule;
import dmd.dscope;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.dtemplate;
import dmd.errors;
import dmd.func;
import dmd.globals;
import dmd.hdrgen;
import drc.lexer.Id;
import drc.lexer.Identifier;
import drc.lexer.Lexer2;
import dmd.mtype;
import util.array;
import util.file;
import util.filename;
import util.outbuffer;
import util.port;
import util.rmem;
import util.string;
import drc.lexer.Tokens;
import util.utf;
import util.utils;
import drc.ast.Visitor;

struct Escape
{
    ткст[сим.max] strings;

    /***************************************
     * Find character ткст to replace c with.
     */
    ткст escapeChar(сим c)
    {
        version (all)
        {
            //printf("escapeChar('%c') => %p, %p\n", c, strings, strings[c].ptr);
            return strings[c];
        }
        else
        {
            ткст s;
            switch (c)
            {
            case '<':
                s = "&lt;";
                break;
            case '>':
                s = "&gt;";
                break;
            case '&':
                s = "&amp;";
                break;
            default:
                s = null;
                break;
            }
            return s;
        }
    }
}

/***********************************************************
 */
private class Section
{
    ткст0 имя;
    т_мера namelen;
    ткст0 _body;
    т_мера bodylen;
    цел nooutput;

    override ткст вТкст()
    {
        assert(0);
    }

    проц пиши(Место место, DocComment* dc, Scope* sc, Дсимволы* a, БуфВыв* буф)
    {
        assert(a.dim);
        if (namelen)
        {
            static const table =
            [
                "AUTHORS",
                "BUGS",
                "COPYRIGHT",
                "DATE",
                "DEPRECATED",
                "EXAMPLES",
                "HISTORY",
                "LICENSE",
                "RETURNS",
                "SEE_ALSO",
                "STANDARDS",
                "THROWS",
                "VERSION",
            ];
            foreach (entry; table)
            {
                if (iequals(entry, имя[0 .. namelen]))
                {
                    буф.printf("$(DDOC_%s ", entry.ptr);
                    goto L1;
                }
            }
            буф.пишиСтр("$(DDOC_SECTION ");
            // Replace _ characters with spaces
            буф.пишиСтр("$(DDOC_SECTION_H ");
            т_мера o = буф.length;
            for (т_мера u = 0; u < namelen; u++)
            {
                сим c = имя[u];
                буф.пишиБайт((c == '_') ? ' ' : c);
            }
            escapeStrayParenthesis(место, буф, o, нет);
            буф.пишиСтр(")");
        }
        else
        {
            буф.пишиСтр("$(DDOC_DESCRIPTION ");
        }
    L1:
        т_мера o = буф.length;
        буф.пиши(_body[0 .. bodylen]);
        escapeStrayParenthesis(место, буф, o, да);
        highlightText(sc, a, место, *буф, o);
        буф.пишиСтр(")");
    }
}

/***********************************************************
 */
private final class ParamSection : Section
{
    override проц пиши(Место место, DocComment* dc, Scope* sc, Дсимволы* a, БуфВыв* буф)
    {
        assert(a.dim);
        ДСимвол s = (*a)[0]; // test
        ткст0 p = _body;
        т_мера len = bodylen;
        ткст0 pend = p + len;
        ткст0 tempstart = null;
        т_мера templen = 0;
        ткст0 namestart = null;
        т_мера namelen = 0; // !=0 if line continuation
        ткст0 textstart = null;
        т_мера textlen = 0;
        т_мера paramcount = 0;
        буф.пишиСтр("$(DDOC_PARAMS ");
        while (p < pend)
        {
            // Skip to start of macro
            while (1)
            {
                switch (*p)
                {
                case ' ':
                case '\t':
                    p++;
                    continue;
                case '\n':
                    p++;
                    goto Lcont;
                default:
                    if (isIdStart(p) || isCVariadicArg(p[0 .. cast(т_мера)(pend - p)]))
                        break;
                    if (namelen)
                        goto Ltext;
                    // continuation of prev macro
                    goto Lskipline;
                }
                break;
            }
            tempstart = p;
            while (isIdTail(p))
                p += utfStride(p);
            if (isCVariadicArg(p[0 .. cast(т_мера)(pend - p)]))
                p += 3;
            templen = p - tempstart;
            while (*p == ' ' || *p == '\t')
                p++;
            if (*p != '=')
            {
                if (namelen)
                    goto Ltext;
                // continuation of prev macro
                goto Lskipline;
            }
            p++;
            if (namelen)
            {
                // Output existing param
            L1:
                //printf("param '%.*s' = '%.*s'\n", cast(цел)namelen, namestart, cast(цел)textlen, textstart);
                ++paramcount;
                HdrGenState hgs;
                буф.пишиСтр("$(DDOC_PARAM_ROW ");
                {
                    буф.пишиСтр("$(DDOC_PARAM_ID ");
                    {
                        т_мера o = буф.length;
                        Параметр2 fparam = isFunctionParameter(a, namestart, namelen);
                        if (!fparam)
                        {
                            // Comments on a template might refer to function parameters within.
                            // Search the parameters of nested eponymous functions (with the same имя.)
                            fparam = isEponymousFunctionParameter(a, namestart, namelen);
                        }
                        бул isCVariadic = isCVariadicParameter(a, namestart[0 .. namelen]);
                        if (isCVariadic)
                        {
                            буф.пишиСтр("...");
                        }
                        else if (fparam && fparam.тип && fparam.идент)
                        {
                            .toCBuffer(fparam.тип, буф, fparam.идент, &hgs);
                        }
                        else
                        {
                            if (isTemplateParameter(a, namestart, namelen))
                            {
                                // 10236: Don't count template parameters for парамы check
                                --paramcount;
                            }
                            else if (!fparam)
                            {
                                warning(s.место, "Ddoc: function declaration has no параметр '%.*s'", cast(цел)namelen, namestart);
                            }
                            буф.пиши(namestart[0 .. namelen]);
                        }
                        escapeStrayParenthesis(место, буф, o, да);
                        highlightCode(sc, a, *буф, o);
                    }
                    буф.пишиСтр(")");
                    буф.пишиСтр("$(DDOC_PARAM_DESC ");
                    {
                        т_мера o = буф.length;
                        буф.пиши(textstart[0 .. textlen]);
                        escapeStrayParenthesis(место, буф, o, да);
                        highlightText(sc, a, место, *буф, o);
                    }
                    буф.пишиСтр(")");
                }
                буф.пишиСтр(")");
                namelen = 0;
                if (p >= pend)
                    break;
            }
            namestart = tempstart;
            namelen = templen;
            while (*p == ' ' || *p == '\t')
                p++;
            textstart = p;
        Ltext:
            while (*p != '\n')
                p++;
            textlen = p - textstart;
            p++;
        Lcont:
            continue;
        Lskipline:
            // Ignore this line
            while (*p++ != '\n')
            {
            }
        }
        if (namelen)
            goto L1;
        // пиши out last one
        буф.пишиСтр(")");
        TypeFunction tf = a.dim == 1 ? isTypeFunction(s) : null;
        if (tf)
        {
            т_мера pcount = (tf.parameterList.parameters ? tf.parameterList.parameters.dim : 0) +
                            cast(цел)(tf.parameterList.varargs == ВарАрг.variadic);
            if (pcount != paramcount)
            {
                warning(s.место, "Ddoc: параметр count mismatch, expected %d, got %d", pcount, paramcount);
                if (paramcount == 0)
                {
                    // Chances are someone messed up the format
                    warningSupplemental(s.место, "Note that the format is `param = description`");
                }
            }
        }
    }
}

/***********************************************************
 */
private final class MacroSection : Section
{
    override проц пиши(Место место, DocComment* dc, Scope* sc, Дсимволы* a, БуфВыв* буф)
    {
        //printf("MacroSection::пиши()\n");
        DocComment.parseMacros(dc.escapetable, *dc.pmacrotable, _body, bodylen);
    }
}

private alias  МассивДРК!(Section) Sections;

// Workaround for missing Параметр2 instance for variadic парамы. (it's unnecessary to instantiate one).
private бул isCVariadicParameter(Дсимволы* a, ткст p)
{
    foreach (member; *a)
    {
        TypeFunction tf = isTypeFunction(member);
        if (tf && tf.parameterList.varargs == ВарАрг.variadic && p == "...")
            return да;
    }
    return нет;
}

private ДСимвол getEponymousMember(TemplateDeclaration td)
{
    if (!td.onemember)
        return null;
    if (AggregateDeclaration ad = td.onemember.isAggregateDeclaration())
        return ad;
    if (FuncDeclaration fd = td.onemember.isFuncDeclaration())
        return fd;
    if (auto em = td.onemember.isEnumMember())
        return null;    // Keep backward compatibility. See compilable/ddoc9.d
    if (VarDeclaration vd = td.onemember.isVarDeclaration())
        return td.constraint ? null : vd;
    return null;
}

private TemplateDeclaration getEponymousParent(ДСимвол s)
{
    if (!s.родитель)
        return null;
    TemplateDeclaration td = s.родитель.isTemplateDeclaration();
    return (td && getEponymousMember(td)) ? td : null;
}

private const ddoc_default = import("default_ddoc_theme.ddoc");
private const ddoc_decl_s = "$(DDOC_DECL ";
private const ddoc_decl_e = ")\n";
private const ddoc_decl_dd_s = "$(DDOC_DECL_DD ";
private const ddoc_decl_dd_e = ")\n";

/****************************************************
 */
/*extern(C++)*/ проц gendocfile(Module m)
{
     БуфВыв mbuf;
     цел mbuf_done;
    БуфВыв буф;
    //printf("Module::gendocfile()\n");
    if (!mbuf_done) // if not already читай the ddoc files
    {
        mbuf_done = 1;
        // Use our internal default
        mbuf.пишиСтр(ddoc_default);
        // Override with DDOCFILE specified in the sc.ini файл
        ткст0 p = getenv("DDOCFILE");
        if (p)
            глоб2.парамы.ddocfiles.shift(p);
        // Override with the ddoc macro files from the command line
        for (т_мера i = 0; i < глоб2.парамы.ddocfiles.dim; i++)
        {
            auto буфер = readFile(m.место, глоб2.парамы.ddocfiles[i]);
            // BUG: convert файл contents to UTF-8 before use
            const данные = буфер.данные;
            //printf("файл: '%.*s'\n", cast(цел)данные.length, данные.ptr);
            mbuf.пиши(данные);
        }
    }
    DocComment.parseMacros(m.escapetable, m.macrotable, mbuf[].ptr, mbuf[].length);
    Scope* sc = Scope.createGlobal(m); // создай root scope
    DocComment* dc = DocComment.parse(m, m.коммент);
    dc.pmacrotable = &m.macrotable;
    dc.escapetable = m.escapetable;
    sc.lastdc = dc;
    // Generate predefined macros
    // Set the title to be the имя of the module
    {
        const p = m.toPrettyChars().вТкстД;
        m.macrotable.define("TITLE", p);
    }
    // Set time macros
    {
        time_t t;
        time(&t);
        ткст0 p = ctime(&t);
        p = mem.xstrdup(p);
        m.macrotable.define("DATETIME", p.вТкстД());
        m.macrotable.define("YEAR", p[20 .. 20 + 4]);
    }
    const srcfilename = m.srcfile.вТкст();
    m.macrotable.define("SRCFILENAME", srcfilename);
    const docfilename = m.docfile.вТкст();
    m.macrotable.define("DOCFILENAME", docfilename);
    if (dc.copyright)
    {
        dc.copyright.nooutput = 1;
        m.macrotable.define("COPYRIGHT", dc.copyright._body[0 .. dc.copyright.bodylen]);
    }
    if (m.isDocFile)
    {
        const ploc = m.md ? &m.md.место : &m.место;
        const место = Место(ploc.имяф ? ploc.имяф : srcfilename.ptr,
                        ploc.номстр,
                        ploc.имяс);

        т_мера commentlen = strlen(cast(сим*)m.коммент);
        Дсимволы a;
        // https://issues.dlang.org/show_bug.cgi?ид=9764
        // Don't сунь m in a, to prevent emphasize ddoc файл имя.
        if (dc.macros)
        {
            commentlen = dc.macros.имя - m.коммент;
            dc.macros.пиши(место, dc, sc, &a, &буф);
        }
        буф.пиши(m.коммент[0 .. commentlen]);
        highlightText(sc, &a, место, буф, 0);
    }
    else
    {
        Дсимволы a;
        a.сунь(m);
        dc.writeSections(sc, &a, &буф);
        emitMemberComments(m, буф, sc);
    }
    //printf("BODY= '%.*s'\n", cast(цел)буф.length, буф.данные);
    m.macrotable.define("BODY", буф[]);
    БуфВыв buf2;
    buf2.пишиСтр("$(DDOC)");
    т_мера end = buf2.length;
    m.macrotable.expand(buf2, 0, end, null);
    version (all)
    {
        /* Remove all the ýñêàïèðóé sequences from buf2,
         * and make CR-LF the newline.
         */
        {
            const slice = buf2[];
            буф.устРазм(0);
            буф.резервируй(slice.length);
            auto p = slice.ptr;
            for (т_мера j = 0; j < slice.length; j++)
            {
                сим c = p[j];
                if (c == 0xFF && j + 1 < slice.length)
                {
                    j++;
                    continue;
                }
                if (c == '\n')
                    буф.пишиБайт('\r');
                else if (c == '\r')
                {
                    буф.пишиСтр("\r\n");
                    if (j + 1 < slice.length && p[j + 1] == '\n')
                    {
                        j++;
                    }
                    continue;
                }
                буф.пишиБайт(c);
            }
        }
        writeFile(m.место, m.docfile.вТкст(), буф[]);
    }
    else
    {
        /* Remove all the ýñêàïèðóé sequences from buf2
         */
        {
            т_мера i = 0;
            ткст0 p = buf2.данные;
            for (т_мера j = 0; j < buf2.length; j++)
            {
                if (p[j] == 0xFF && j + 1 < buf2.length)
                {
                    j++;
                    continue;
                }
                p[i] = p[j];
                i++;
            }
            buf2.устРазм(i);
        }
        writeFile(m.место, m.docfile.вТкст(), buf2[]);
    }
}

/****************************************************
 * Having unmatched parentheses can hose the output of Ddoc,
 * as the macros depend on properly nested parentheses.
 * This function replaces all ( with $(LPAREN) and ) with $(RPAREN)
 * to preserve text literally. This also means macros in the
 * text won't be expanded.
 */
проц escapeDdocString(БуфВыв* буф, т_мера start)
{
    for (т_мера u = start; u < буф.length; u++)
    {
        сим c = (*буф)[u];
        switch (c)
        {
        case '$':
            буф.удали(u, 1);
            буф.вставь(u, "$(DOLLAR)");
            u += 8;
            break;
        case '(':
            буф.удали(u, 1); //удали the (
            буф.вставь(u, "$(LPAREN)"); //вставь this instead
            u += 8; //skip over newly inserted macro
            break;
        case ')':
            буф.удали(u, 1); //удали the )
            буф.вставь(u, "$(RPAREN)"); //вставь this instead
            u += 8; //skip over newly inserted macro
            break;
        default:
            break;
        }
    }
}

/****************************************************
 * Having unmatched parentheses can hose the output of Ddoc,
 * as the macros depend on properly nested parentheses.
 *
 * Fix by replacing unmatched ( with $(LPAREN) and unmatched ) with $(RPAREN).
 *
 * Параметры:
 *  место   = source location of start of text. It is a mutable копируй to allow incrementing its linenum, for printing the correct line number when an error is encountered in a multiline block of ddoc.
 *  буф   = an БуфВыв containing the DDoc
 *  start = the index within буф to start replacing unmatched parentheses
 *  respectBackslashEscapes = if да, always replace parentheses that are
 *    directly preceeded by a backslash with $(LPAREN) or $(RPAREN) instead of
 *    counting them as stray parentheses
 */
private проц escapeStrayParenthesis(Место место, БуфВыв* буф, т_мера start, бул respectBackslashEscapes)
{
    бцел par_open = 0;
    сим inCode = 0;
    бул atLineStart = да;
    for (т_мера u = start; u < буф.length; u++)
    {
        сим c = (*буф)[u];
        switch (c)
        {
        case '(':
            if (!inCode)
                par_open++;
            atLineStart = нет;
            break;
        case ')':
            if (!inCode)
            {
                if (par_open == 0)
                {
                    //stray ')'
                    warning(место, "Ddoc: Stray ')'. This may cause incorrect Ddoc output. Use $(RPAREN) instead for unpaired right parentheses.");
                    буф.удали(u, 1); //удали the )
                    буф.вставь(u, "$(RPAREN)"); //вставь this instead
                    u += 8; //skip over newly inserted macro
                }
                else
                    par_open--;
            }
            atLineStart = нет;
            break;
        case '\n':
            atLineStart = да;
            version (none)
            {
                // For this to work, место must be set to the beginning of the passed
                // text which is currently not possible
                // (место is set to the Место of the ДСимвол)
                место.номстр++;
            }
            break;
        case ' ':
        case '\r':
        case '\t':
            break;
        case '-':
        case '`':
        case '~':
            // Issue 15465: don't try to ýñêàïèðóé unbalanced parens inside code
            // blocks.
            цел numdash = 1;
            for (++u; u < буф.length && (*буф)[u] == c; ++u)
                ++numdash;
            --u;
            if (c == '`' || (atLineStart && numdash >= 3))
            {
                if (inCode == c)
                    inCode = 0;
                else if (!inCode)
                    inCode = c;
            }
            atLineStart = нет;
            break;
        case '\\':
            // replace backslash-escaped parens with their macros
            if (!inCode && respectBackslashEscapes && u+1 < буф.length && глоб2.парамы.markdown)
            {
                if ((*буф)[u+1] == '(' || (*буф)[u+1] == ')')
                {
                    const paren = (*буф)[u+1] == '(' ? "$(LPAREN)" : "$(RPAREN)";
                    буф.удали(u, 2); //удали the \)
                    буф.вставь(u, paren); //вставь this instead
                    u += 8; //skip over newly inserted macro
                }
                else if ((*буф)[u+1] == '\\')
                    ++u;
            }
            break;
        default:
            atLineStart = нет;
            break;
        }
    }
    if (par_open) // if any unmatched lparens
    {
        par_open = 0;
        for (т_мера u = буф.length; u > start;)
        {
            u--;
            сим c = (*буф)[u];
            switch (c)
            {
            case ')':
                par_open++;
                break;
            case '(':
                if (par_open == 0)
                {
                    //stray '('
                    warning(место, "Ddoc: Stray '('. This may cause incorrect Ddoc output. Use $(LPAREN) instead for unpaired left parentheses.");
                    буф.удали(u, 1); //удали the (
                    буф.вставь(u, "$(LPAREN)"); //вставь this instead
                }
                else
                    par_open--;
                break;
            default:
                break;
            }
        }
    }
}

// Basically, this is to skip over things like private{} blocks in a struct or
// class definition that don't add any components to the qualified имя.
private Scope* skipNonQualScopes(Scope* sc)
{
    while (sc && !sc.scopesym)
        sc = sc.enclosing;
    return sc;
}

private бул emitAnchorName(ref БуфВыв буф, ДСимвол s, Scope* sc, бул includeParent)
{
    if (!s || s.isPackage() || s.isModule())
        return нет;
    // Add родитель имена first
    бул dot = нет;
    auto eponymousParent = getEponymousParent(s);
    if (includeParent && s.родитель || eponymousParent)
        dot = emitAnchorName(буф, s.родитель, sc, includeParent);
    else if (includeParent && sc)
        dot = emitAnchorName(буф, sc.scopesym, skipNonQualScopes(sc.enclosing), includeParent);
    // Eponymous template члены can share the родитель anchor имя
    if (eponymousParent)
        return dot;
    if (dot)
        буф.пишиБайт('.');
    // Use "this" not "__ctor"
    TemplateDeclaration td;
    if (s.isCtorDeclaration() || ((td = s.isTemplateDeclaration()) !is null && td.onemember && td.onemember.isCtorDeclaration()))
    {
        буф.пишиСтр("this");
    }
    else
    {
        /* We just want the идентификатор, not overloads like TemplateDeclaration::вТкст0.
         * We don't want the template параметр list and constraints. */
        буф.пишиСтр(s.ДСимвол.вТкст0());
    }
    return да;
}

private проц emitAnchor(ref БуфВыв буф, ДСимвол s, Scope* sc, бул forHeader = нет)
{
    Идентификатор2 идент;
    {
        БуфВыв anc;
        emitAnchorName(anc, s, skipNonQualScopes(sc), да);
        идент = Идентификатор2.idPool(anc[]);
    }

    auto pcount = cast(ук)идент in sc.anchorCounts;
    typeof(*pcount) count;
    if (!forHeader)
    {
        if (pcount)
        {
            // Existing anchor,
            // don't пиши an anchor for matching consecutive ditto symbols
            TemplateDeclaration td = getEponymousParent(s);
            if (sc.prevAnchor == идент && sc.lastdc && (isDitto(s.коммент) || (td && isDitto(td.коммент))))
                return;

            count = ++*pcount;
        }
        else
        {
            sc.anchorCounts[cast(ук)идент] = 1;
            count = 1;
        }
    }

    // cache anchor имя
    sc.prevAnchor = идент;
    auto macroName = forHeader ? "DDOC_HEADER_ANCHOR" : "DDOC_ANCHOR";

    if (auto imp = s.isImport())
    {
        // For example: `public import core.stdc.ткст : memcpy, memcmp;`
        if (imp.ники.dim > 0)
        {
            for(цел i = 0; i < imp.ники.dim; i++)
            {
                // Need to distinguish between
                // `public import core.stdc.ткст : memcpy, memcmp;` and
                // `public import core.stdc.ткст : копируй = memcpy, compare = memcmp;`
                auto a = imp.ники[i];
                auto ид = a ? a : imp.имена[i];
                auto место = Место.init;
                if (auto symFromId = sc.search(место, ид, null))
                {
                    emitAnchor(буф, symFromId, sc, forHeader);
                }
            }
        }
        else
        {
            // For example: `public import str = core.stdc.ткст;`
            if (imp.идНик)
            {
                auto symbolName = imp.идНик.вТкст();

                буф.printf("$(%.*s %.*s", cast(цел) macroName.length, macroName.ptr,
                    cast(цел) symbolName.length, symbolName.ptr);

                if (forHeader)
                {
                    буф.printf(", %.*s", cast(цел) symbolName.length, symbolName.ptr);
                }
            }
            else
            {
                // The general case:  `public import core.stdc.ткст;`

                // fully qualify imports so `core.stdc.ткст` doesn't appear as `core`
                проц printFullyQualifiedImport()
                {
                    if (imp.пакеты && imp.пакеты.dim)
                    {
                        foreach (pid; *imp.пакеты)
                        {
                            буф.printf("%s.", pid.вТкст0());
                        }
                    }
                    буф.пишиСтр(imp.ид.вТкст());
                }

                буф.printf("$(%.*s ", cast(цел) macroName.length, macroName.ptr);
                printFullyQualifiedImport();

                if (forHeader)
                {
                    буф.printf(", ");
                    printFullyQualifiedImport();
                }
            }

            буф.пишиБайт(')');
        }
    }
    else
    {
        auto symbolName = идент.вТкст();
        буф.printf("$(%.*s %.*s", cast(цел) macroName.length, macroName.ptr,
            cast(цел) symbolName.length, symbolName.ptr);

        // only приставь count once there's a duplicate
        if (count > 1)
            буф.printf(".%u", count);

        if (forHeader)
        {
            Идентификатор2 shortIdent;
            {
                БуфВыв anc;
                emitAnchorName(anc, s, skipNonQualScopes(sc), нет);
                shortIdent = Идентификатор2.idPool(anc[]);
            }

            auto shortName = shortIdent.вТкст();
            буф.printf(", %.*s", cast(цел) shortName.length, shortName.ptr);
        }

        буф.пишиБайт(')');
    }
}

/******************************* emitComment **********************************/

/** Get leading indentation from 'src' which represents строки of code. */
private т_мера getCodeIndent(ткст0 src)
{
    while (src && (*src == '\r' || *src == '\n'))
        ++src; // skip until we найди the first non-empty line
    т_мера codeIndent = 0;
    while (src && (*src == ' ' || *src == '\t'))
    {
        codeIndent++;
        src++;
    }
    return codeIndent;
}

/** Recursively expand template mixin member docs into the scope. */
private проц expandTemplateMixinComments(TemplateMixin tm, ref БуфВыв буф, Scope* sc)
{
    if (!tm.semanticRun)
        tm.dsymbolSemantic(sc);
    TemplateDeclaration td = (tm && tm.tempdecl) ? tm.tempdecl.isTemplateDeclaration() : null;
    if (td && td.члены)
    {
        for (т_мера i = 0; i < td.члены.dim; i++)
        {
            ДСимвол sm = (*td.члены)[i];
            TemplateMixin tmc = sm.isTemplateMixin();
            if (tmc && tmc.коммент)
                expandTemplateMixinComments(tmc, буф, sc);
            else
                emitComment(sm, буф, sc);
        }
    }
}

private проц emitMemberComments(ScopeDsymbol sds, ref БуфВыв буф, Scope* sc)
{
    if (!sds.члены)
        return;
    //printf("ScopeDsymbol::emitMemberComments() %s\n", вТкст0());
    ткст m = "$(DDOC_MEMBERS ";
    if (sds.isTemplateDeclaration())
        m = "$(DDOC_TEMPLATE_MEMBERS ";
    else if (sds.isClassDeclaration())
        m = "$(DDOC_CLASS_MEMBERS ";
    else if (sds.isStructDeclaration())
        m = "$(DDOC_STRUCT_MEMBERS ";
    else if (sds.isEnumDeclaration())
        m = "$(DDOC_ENUM_MEMBERS ";
    else if (sds.isModule())
        m = "$(DDOC_MODULE_MEMBERS ";
    т_мера offset1 = буф.length; // save starting смещение
    буф.пишиСтр(m);
    т_мера offset2 = буф.length; // to see if we пиши anything
    sc = sc.сунь(sds);
    for (т_мера i = 0; i < sds.члены.dim; i++)
    {
        ДСимвол s = (*sds.члены)[i];
        //printf("\ts = '%s'\n", s.вТкст0());
        // only expand if родитель is a non-template (semantic won't work)
        if (s.коммент && s.isTemplateMixin() && s.родитель && !s.родитель.isTemplateDeclaration())
            expandTemplateMixinComments(cast(TemplateMixin)s, буф, sc);
        emitComment(s, буф, sc);
    }
    emitComment(null, буф, sc);
    sc.вынь();
    if (буф.length == offset2)
    {
        /* Didn't пиши out any члены, so back out last пиши
         */
        буф.устРазм(offset1);
    }
    else
        буф.пишиСтр(")");
}

private проц emitProtection(ref БуфВыв буф, Импорт i)
{
    // imports are private by default, which is different from other declarations
    // so they should explicitly show their защита
    emitProtection(буф, i.защита);
}

private проц emitProtection(ref БуфВыв буф, Declaration d)
{
    auto prot = d.защита;
    if (prot.вид != Prot.Kind.undefined && prot.вид != Prot.Kind.public_)
    {
        emitProtection(буф, prot);
    }
}

private проц emitProtection(ref БуфВыв буф, Prot prot)
{
    protectionToBuffer(&буф, prot);
    буф.пишиБайт(' ');
}

private проц emitComment(ДСимвол s, ref БуфВыв буф, Scope* sc)
{
     final class EmitComment : Визитор2
    {
        alias Визитор2.посети посети;
    public:
        БуфВыв* буф;
        Scope* sc;

        this(ref БуфВыв буф, Scope* sc)
        {
            this.буф = &буф;
            this.sc = sc;
        }

        override проц посети(ДСимвол)
        {
        }

        override проц посети(InvariantDeclaration)
        {
        }

        override проц посети(UnitTestDeclaration)
        {
        }

        override проц посети(PostBlitDeclaration)
        {
        }

        override проц посети(DtorDeclaration)
        {
        }

        override проц посети(StaticCtorDeclaration)
        {
        }

        override проц посети(StaticDtorDeclaration)
        {
        }

        override проц посети(TypeInfoDeclaration)
        {
        }

        проц emit(Scope* sc, ДСимвол s, ткст0 com)
        {
            if (s && sc.lastdc && isDitto(com))
            {
                sc.lastdc.a.сунь(s);
                return;
            }
            // Put previous doc коммент if exists
            if (DocComment* dc = sc.lastdc)
            {
                assert(dc.a.dim > 0, "Expects at least one declaration for a" ~
                    "documentation коммент");

                auto symbol = dc.a[0];

                буф.пишиСтр("$(DDOC_MEMBER");
                буф.пишиСтр("$(DDOC_MEMBER_HEADER");
                emitAnchor(*буф, symbol, sc, да);
                буф.пишиБайт(')');

                // Put the declaration signatures as the document 'title'
                буф.пишиСтр(ddoc_decl_s);
                for (т_мера i = 0; i < dc.a.dim; i++)
                {
                    ДСимвол sx = dc.a[i];
                    // the added linebreaks in here make looking at multiple
                    // signatures more appealing
                    if (i == 0)
                    {
                        т_мера o = буф.length;
                        toDocBuffer(sx, *буф, sc);
                        highlightCode(sc, sx, *буф, o);
                        буф.пишиСтр("$(DDOC_OVERLOAD_SEPARATOR)");
                        continue;
                    }
                    буф.пишиСтр("$(DDOC_DITTO ");
                    {
                        т_мера o = буф.length;
                        toDocBuffer(sx, *буф, sc);
                        highlightCode(sc, sx, *буф, o);
                    }
                    буф.пишиСтр("$(DDOC_OVERLOAD_SEPARATOR)");
                    буф.пишиБайт(')');
                }
                буф.пишиСтр(ddoc_decl_e);
                // Put the ddoc коммент as the document 'description'
                буф.пишиСтр(ddoc_decl_dd_s);
                {
                    dc.writeSections(sc, &dc.a, буф);
                    if (ScopeDsymbol sds = dc.a[0].isScopeDsymbol())
                        emitMemberComments(sds, *буф, sc);
                }
                буф.пишиСтр(ddoc_decl_dd_e);
                буф.пишиБайт(')');
                //printf("буф.2 = [[%.*s]]\n", cast(цел)(буф.length - o0), буф.данные + o0);
            }
            if (s)
            {
                DocComment* dc = DocComment.parse(s, com);
                dc.pmacrotable = &sc._module.macrotable;
                sc.lastdc = dc;
            }
        }

        override проц посети(Импорт imp)
        {
            if (imp.prot().вид != Prot.Kind.public_ && sc.защита.вид != Prot.Kind.export_)
                return;

            if (imp.коммент)
                emit(sc, imp, imp.коммент);
        }

        override проц посети(Declaration d)
        {
            //printf("Declaration::emitComment(%p '%s'), коммент = '%s'\n", d, d.вТкст0(), d.коммент);
            //printf("тип = %p\n", d.тип);
            ткст0 com = d.коммент;
            if (TemplateDeclaration td = getEponymousParent(d))
            {
                if (isDitto(td.коммент))
                    com = td.коммент;
                else
                    com = Lexer.combineComments(td.коммент.вТкстД(), com.вТкстД(), да);
            }
            else
            {
                if (!d.идент)
                    return;
                if (!d.тип)
                {
                    if (!d.isCtorDeclaration() &&
                        !d.isAliasDeclaration() &&
                        !d.isVarDeclaration())
                    {
                        return;
                    }
                }
                if (d.защита.вид == Prot.Kind.private_ || sc.защита.вид == Prot.Kind.private_)
                    return;
            }
            if (!com)
                return;
            emit(sc, d, com);
        }

        override проц посети(AggregateDeclaration ad)
        {
            //printf("AggregateDeclaration::emitComment() '%s'\n", ad.вТкст0());
            ткст0 com = ad.коммент;
            if (TemplateDeclaration td = getEponymousParent(ad))
            {
                if (isDitto(td.коммент))
                    com = td.коммент;
                else
                    com = Lexer.combineComments(td.коммент.вТкстД(), com.вТкстД(), да);
            }
            else
            {
                if (ad.prot().вид == Prot.Kind.private_ || sc.защита.вид == Prot.Kind.private_)
                    return;
                if (!ad.коммент)
                    return;
            }
            if (!com)
                return;
            emit(sc, ad, com);
        }

        override проц посети(TemplateDeclaration td)
        {
            //printf("TemplateDeclaration::emitComment() '%s', вид = %s\n", td.вТкст0(), td.вид());
            if (td.prot().вид == Prot.Kind.private_ || sc.защита.вид == Prot.Kind.private_)
                return;
            if (!td.коммент)
                return;
            if (ДСимвол ss = getEponymousMember(td))
            {
                ss.прими(this);
                return;
            }
            emit(sc, td, td.коммент);
        }

        override проц посети(EnumDeclaration ed)
        {
            if (ed.prot().вид == Prot.Kind.private_ || sc.защита.вид == Prot.Kind.private_)
                return;
            if (ed.isAnonymous() && ed.члены)
            {
                for (т_мера i = 0; i < ed.члены.dim; i++)
                {
                    ДСимвол s = (*ed.члены)[i];
                    emitComment(s, *буф, sc);
                }
                return;
            }
            if (!ed.коммент)
                return;
            if (ed.isAnonymous())
                return;
            emit(sc, ed, ed.коммент);
        }

        override проц посети(EnumMember em)
        {
            //printf("EnumMember::emitComment(%p '%s'), коммент = '%s'\n", em, em.вТкст0(), em.коммент);
            if (em.prot().вид == Prot.Kind.private_ || sc.защита.вид == Prot.Kind.private_)
                return;
            if (!em.коммент)
                return;
            emit(sc, em, em.коммент);
        }

        override проц посети(AttribDeclaration ad)
        {
            //printf("AttribDeclaration::emitComment(sc = %p)\n", sc);
            /* A general problem with this,
             * illustrated by https://issues.dlang.org/show_bug.cgi?ид=2516
             * is that attributes are not transmitted through to the underlying
             * member declarations for template bodies, because semantic analysis
             * is not done for template declaration bodies
             * (only template instantiations).
             * Hence, Ddoc omits attributes from template члены.
             */
            Дсимволы* d = ad.include(null);
            if (d)
            {
                for (т_мера i = 0; i < d.dim; i++)
                {
                    ДСимвол s = (*d)[i];
                    //printf("AttribDeclaration::emitComment %s\n", s.вТкст0());
                    emitComment(s, *буф, sc);
                }
            }
        }

        override проц посети(ProtDeclaration pd)
        {
            if (pd.decl)
            {
                Scope* scx = sc;
                sc = sc.копируй();
                sc.защита = pd.защита;
                посети(cast(AttribDeclaration)pd);
                scx.lastdc = sc.lastdc;
                sc = sc.вынь();
            }
        }

        override проц посети(ConditionalDeclaration cd)
        {
            //printf("ConditionalDeclaration::emitComment(sc = %p)\n", sc);
            if (cd.условие.inc != Include.notComputed)
            {
                посети(cast(AttribDeclaration)cd);
                return;
            }
            /* If generating doc коммент, be careful because if we're inside
             * a template, then include(null) will fail.
             */
            Дсимволы* d = cd.decl ? cd.decl : cd.elsedecl;
            for (т_мера i = 0; i < d.dim; i++)
            {
                ДСимвол s = (*d)[i];
                emitComment(s, *буф, sc);
            }
        }
    }

    scope EmitComment v = new EmitComment(буф, sc);
    if (!s)
        v.emit(sc, null, null);
    else
        s.прими(v);
}

private проц toDocBuffer(ДСимвол s, ref БуфВыв буф, Scope* sc)
{
     final class ToDocBuffer : Визитор2
    {
        alias Визитор2.посети посети;
    public:
        БуфВыв* буф;
        Scope* sc;

        this(ref БуфВыв буф, Scope* sc)
        {
            this.буф = &буф;
            this.sc = sc;
        }

        override проц посети(ДСимвол s)
        {
            //printf("ДСимвол::toDocbuffer() %s\n", s.вТкст0());
            HdrGenState hgs;
            hgs.ddoc = да;
            .toCBuffer(s, буф, &hgs);
        }

        проц префикс(ДСимвол s)
        {
            if (s.isDeprecated())
                буф.пишиСтр("deprecated ");
            if (Declaration d = s.isDeclaration())
            {
                emitProtection(*буф, d);
                if (d.isStatic())
                    буф.пишиСтр("static ");
                else if (d.isFinal())
                    буф.пишиСтр("final ");
                else if (d.isAbstract())
                    буф.пишиСтр("abstract ");

                if (d.isFuncDeclaration())      // functionToBufferFull handles this
                    return;

                if (d.isImmutable())
                    буф.пишиСтр("const ");
                if (d.класс_хранения & STC.shared_)
                    буф.пишиСтр("shared ");
                if (d.isWild())
                    буф.пишиСтр("inout ");
                if (d.isConst())
                    буф.пишиСтр("const ");

                if (d.isSynchronized())
                    буф.пишиСтр("synchronized ");

                if (d.класс_хранения & STC.manifest)
                    буф.пишиСтр("enum ");

                // Add "auto" for the untyped variable in template члены
                if (!d.тип && d.isVarDeclaration() &&
                    !d.isImmutable() && !(d.класс_хранения & STC.shared_) && !d.isWild() && !d.isConst() &&
                    !d.isSynchronized())
                {
                    буф.пишиСтр("auto ");
                }
            }
        }

        override проц посети(Импорт i)
        {
            HdrGenState hgs;
            hgs.ddoc = да;
            emitProtection(*буф, i);
            .toCBuffer(i, буф, &hgs);
        }

        override проц посети(Declaration d)
        {
            if (!d.идент)
                return;
            TemplateDeclaration td = getEponymousParent(d);
            //printf("Declaration::toDocbuffer() %s, originalType = %s, td = %s\n", d.вТкст0(), d.originalType ? d.originalType.вТкст0() : "--", td ? td.вТкст0() : "--");
            HdrGenState hgs;
            hgs.ddoc = да;
            if (d.isDeprecated())
                буф.пишиСтр("$(DEPRECATED ");
            префикс(d);
            if (d.тип)
            {
                Тип origType = d.originalType ? d.originalType : d.тип;
                if (origType.ty == Tfunction)
                {
                    functionToBufferFull(cast(TypeFunction)origType, буф, d.идент, &hgs, td);
                }
                else
                    .toCBuffer(origType, буф, d.идент, &hgs);
            }
            else
                буф.пишиСтр(d.идент.вТкст());
            if (d.isVarDeclaration() && td)
            {
                буф.пишиБайт('(');
                if (td.origParameters && td.origParameters.dim)
                {
                    for (т_мера i = 0; i < td.origParameters.dim; i++)
                    {
                        if (i)
                            буф.пишиСтр(", ");
                        toCBuffer((*td.origParameters)[i], буф, &hgs);
                    }
                }
                буф.пишиБайт(')');
            }
            // emit constraints if declaration is a templated declaration
            if (td && td.constraint)
            {
                бул noFuncDecl = td.isFuncDeclaration() is null;
                if (noFuncDecl)
                {
                    буф.пишиСтр("$(DDOC_CONSTRAINT ");
                }

                .toCBuffer(td.constraint, буф, &hgs);

                if (noFuncDecl)
                {
                    буф.пишиСтр(")");
                }
            }
            if (d.isDeprecated())
                буф.пишиСтр(")");
            буф.пишиСтр(";\n");
        }

        override проц посети(AliasDeclaration ad)
        {
            //printf("AliasDeclaration::toDocbuffer() %s\n", ad.вТкст0());
            if (!ad.идент)
                return;
            if (ad.isDeprecated())
                буф.пишиСтр("deprecated ");
            emitProtection(*буф, ad);
            буф.printf("alias %s = ", ad.вТкст0());
            if (ДСимвол s = ad.aliassym) // идент alias
            {
                prettyPrintDsymbol(s, ad.родитель);
            }
            else if (Тип тип = ad.getType()) // тип alias
            {
                if (тип.ty == Tclass || тип.ty == Tstruct || тип.ty == Tenum)
                {
                    if (ДСимвол s = тип.toDsymbol(null)) // elaborate тип
                        prettyPrintDsymbol(s, ad.родитель);
                    else
                        буф.пишиСтр(тип.вТкст0());
                }
                else
                {
                    // simple тип
                    буф.пишиСтр(тип.вТкст0());
                }
            }
            буф.пишиСтр(";\n");
        }

        проц parentToBuffer(ДСимвол s)
        {
            if (s && !s.isPackage() && !s.isModule())
            {
                parentToBuffer(s.родитель);
                буф.пишиСтр(s.вТкст0());
                буф.пишиСтр(".");
            }
        }

        static бул inSameModule(ДСимвол s, ДСимвол p)
        {
            for (; s; s = s.родитель)
            {
                if (s.isModule())
                    break;
            }
            for (; p; p = p.родитель)
            {
                if (p.isModule())
                    break;
            }
            return s == p;
        }

        проц prettyPrintDsymbol(ДСимвол s, ДСимвол родитель)
        {
            if (s.родитель && (s.родитель == родитель)) // in current scope -> naked имя
            {
                буф.пишиСтр(s.вТкст0());
            }
            else if (!inSameModule(s, родитель)) // in another module -> full имя
            {
                буф.пишиСтр(s.toPrettyChars());
            }
            else // nested in a тип in this module -> full имя w/o module имя
            {
                // if alias is nested in a user-тип use module-scope lookup
                if (!родитель.isModule() && !родитель.isPackage())
                    буф.пишиСтр(".");
                parentToBuffer(s.родитель);
                буф.пишиСтр(s.вТкст0());
            }
        }

        override проц посети(AggregateDeclaration ad)
        {
            if (!ad.идент)
                return;
            version (none)
            {
                emitProtection(буф, ad);
            }
            буф.printf("%s %s", ad.вид(), ad.вТкст0());
            буф.пишиСтр(";\n");
        }

        override проц посети(StructDeclaration sd)
        {
            //printf("StructDeclaration::toDocbuffer() %s\n", sd.вТкст0());
            if (!sd.идент)
                return;
            version (none)
            {
                emitProtection(буф, sd);
            }
            if (TemplateDeclaration td = getEponymousParent(sd))
            {
                toDocBuffer(td, *буф, sc);
            }
            else
            {
                буф.printf("%s %s", sd.вид(), sd.вТкст0());
            }
            буф.пишиСтр(";\n");
        }

        override проц посети(ClassDeclaration cd)
        {
            //printf("ClassDeclaration::toDocbuffer() %s\n", cd.вТкст0());
            if (!cd.идент)
                return;
            version (none)
            {
                emitProtection(*буф, cd);
            }
            if (TemplateDeclaration td = getEponymousParent(cd))
            {
                toDocBuffer(td, *буф, sc);
            }
            else
            {
                if (!cd.isInterfaceDeclaration() && cd.isAbstract())
                    буф.пишиСтр("abstract ");
                буф.printf("%s %s", cd.вид(), cd.вТкст0());
            }
            цел any = 0;
            for (т_мера i = 0; i < cd.baseclasses.dim; i++)
            {
                КлассОснова2* bc = (*cd.baseclasses)[i];
                if (bc.sym && bc.sym.идент == Id.Object)
                    continue;
                if (any)
                    буф.пишиСтр(", ");
                else
                {
                    буф.пишиСтр(": ");
                    any = 1;
                }

                if (bc.sym)
                {
                    буф.printf("$(DDOC_PSUPER_SYMBOL %s)", bc.sym.toPrettyChars());
                }
                else
                {
                    HdrGenState hgs;
                    .toCBuffer(bc.тип, буф, null, &hgs);
                }
            }
            буф.пишиСтр(";\n");
        }

        override проц посети(EnumDeclaration ed)
        {
            if (!ed.идент)
                return;
            буф.printf("%s %s", ed.вид(), ed.вТкст0());
            if (ed.memtype)
            {
                буф.пишиСтр(": $(DDOC_ENUM_BASETYPE ");
                HdrGenState hgs;
                .toCBuffer(ed.memtype, буф, null, &hgs);
                буф.пишиСтр(")");
            }
            буф.пишиСтр(";\n");
        }

        override проц посети(EnumMember em)
        {
            if (!em.идент)
                return;
            буф.пишиСтр(em.вТкст0());
        }
    }

    scope ToDocBuffer v = new ToDocBuffer(буф, sc);
    s.прими(v);
}

/***********************************************************
 */
struct DocComment
{
    Sections sections;      // Section*[]
    Section summary;
    Section copyright;
    Section macros;
    MacroTable* pmacrotable;
    Escape* escapetable;
    Дсимволы a;

    static DocComment* parse(ДСимвол s, ткст0 коммент)
    {
        //printf("parse(%s): '%s'\n", s.вТкст0(), коммент);
        auto dc = new DocComment();
        dc.a.сунь(s);
        if (!коммент)
            return dc;
        dc.parseSections(коммент);
        for (т_мера i = 0; i < dc.sections.dim; i++)
        {
            Section sec = dc.sections[i];
            if (iequals("copyright", sec.имя[0 .. sec.namelen]))
            {
                dc.copyright = sec;
            }
            if (iequals("macros", sec.имя[0 .. sec.namelen]))
            {
                dc.macros = sec;
            }
        }
        return dc;
    }

    /************************************************
     * Parse macros out of Macros: section.
     * Macros are of the form:
     *      name1 = value1
     *
     *      name2 = value2
     */
    static проц parseMacros(Escape* escapetable, ref MacroTable pmacrotable, ткст0 m, т_мера mlen)
    {
        ткст0 p = m;
        т_мера len = mlen;
        ткст0 pend = p + len;
        ткст0 tempstart = null;
        т_мера templen = 0;
        ткст0 namestart = null;
        т_мера namelen = 0; // !=0 if line continuation
        ткст0 textstart = null;
        т_мера textlen = 0;
        while (p < pend)
        {
            // Skip to start of macro
            while (1)
            {
                if (p >= pend)
                    goto Ldone;
                switch (*p)
                {
                case ' ':
                case '\t':
                    p++;
                    continue;
                case '\r':
                case '\n':
                    p++;
                    goto Lcont;
                default:
                    if (isIdStart(p))
                        break;
                    if (namelen)
                        goto Ltext; // continuation of prev macro
                    goto Lskipline;
                }
                break;
            }
            tempstart = p;
            while (1)
            {
                if (p >= pend)
                    goto Ldone;
                if (!isIdTail(p))
                    break;
                p += utfStride(p);
            }
            templen = p - tempstart;
            while (1)
            {
                if (p >= pend)
                    goto Ldone;
                if (!(*p == ' ' || *p == '\t'))
                    break;
                p++;
            }
            if (*p != '=')
            {
                if (namelen)
                    goto Ltext; // continuation of prev macro
                goto Lskipline;
            }
            p++;
            if (p >= pend)
                goto Ldone;
            if (namelen)
            {
                // Output existing macro
            L1:
                //printf("macro '%.*s' = '%.*s'\n", cast(цел)namelen, namestart, cast(цел)textlen, textstart);
                if (iequals("ESCAPES", namestart[0 .. namelen]))
                    parseEscapes(escapetable, textstart, textlen);
                else
                    pmacrotable.define(namestart[0 .. namelen], textstart[0 .. textlen]);
                namelen = 0;
                if (p >= pend)
                    break;
            }
            namestart = tempstart;
            namelen = templen;
            while (p < pend && (*p == ' ' || *p == '\t'))
                p++;
            textstart = p;
        Ltext:
            while (p < pend && *p != '\r' && *p != '\n')
                p++;
            textlen = p - textstart;
            p++;
            //printf("p = %p, pend = %p\n", p, pend);
        Lcont:
            continue;
        Lskipline:
            // Ignore this line
            while (p < pend && *p != '\r' && *p != '\n')
                p++;
        }
    Ldone:
        if (namelen)
            goto L1; // пиши out last one
    }

    /**************************************
     * Parse escapes of the form:
     *      /c/ткст/
     * where c is a single character.
     * Multiple escapes can be separated
     * by whitespace and/or commas.
     */
    static проц parseEscapes(Escape* escapetable, ткст0 textstart, т_мера textlen)
    {
        if (!escapetable)
        {
            escapetable = new Escape();
            memset(escapetable, 0, Escape.sizeof);
        }
        //printf("parseEscapes('%.*s') pescapetable = %p\n", cast(цел)textlen, textstart, pescapetable);
        ткст0 p = textstart;
        ткст0 pend = p + textlen;
        while (1)
        {
            while (1)
            {
                if (p + 4 >= pend)
                    return;
                if (!(*p == ' ' || *p == '\t' || *p == '\r' || *p == '\n' || *p == ','))
                    break;
                p++;
            }
            if (p[0] != '/' || p[2] != '/')
                return;
            сим c = p[1];
            p += 3;
            ткст0 start = p;
            while (1)
            {
                if (p >= pend)
                    return;
                if (*p == '/')
                    break;
                p++;
            }
            т_мера len = p - start;
            ткст0 s = cast(сим*)memcpy(mem.xmalloc(len + 1), start, len);
            s[len] = 0;
            escapetable.strings[c] = s[0 .. len];
            //printf("\t%c = '%s'\n", c, s);
            p++;
        }
    }

    /*****************************************
     * Parse следщ paragraph out of *pcomment.
     * Update *pcomment to point past paragraph.
     * Возвращает NULL if no more paragraphs.
     * If paragraph ends in 'идентификатор:',
     * then (*pcomment)[0 .. idlen] is the идентификатор.
     */
    проц parseSections(ткст0 коммент)
    {
        ткст0 p;
        ткст0 pstart;
        ткст0 pend;
        ткст0 idstart = null; // dead-store to prevent spurious warning
        т_мера idlen;
        ткст0 имя = null;
        т_мера namelen = 0;
        //printf("parseSections('%s')\n", коммент);
        p = коммент;
        while (*p)
        {
            ткст0 pstart0 = p;
            p = skipwhitespace(p);
            pstart = p;
            pend = p;

            // Undo отступ if starting with a list item
            if ((*p == '-' || *p == '+' || *p == '*') && (*(p+1) == ' ' || *(p+1) == '\t'))
                pstart = pstart0;
            else
            {
                ткст0 pitem = p;
                while (*pitem >= '0' && *pitem <= '9')
                    ++pitem;
                if (pitem > p && *pitem == '.' && (*(pitem+1) == ' ' || *(pitem+1) == '\t'))
                    pstart = pstart0;
            }

            /* Find end of section, which is ended by one of:
             *      'идентификатор:' (but not inside a code section)
             *      '\0'
             */
            idlen = 0;
            цел inCode = 0;
            while (1)
            {
                // Check for start/end of a code section
                if (*p == '-' || *p == '`' || *p == '~')
                {
                    сим c = *p;
                    цел numdash = 0;
                    while (*p == c)
                    {
                        ++numdash;
                        p++;
                    }
                    // BUG: handle UTF PS and LS too
                    if ((!*p || *p == '\r' || *p == '\n' || (!inCode && c != '-')) && numdash >= 3)
                    {
                        inCode = inCode == c ? нет : c;
                        if (inCode)
                        {
                            // restore leading indentation
                            while (pstart0 < pstart && isIndentWS(pstart - 1))
                                --pstart;
                        }
                    }
                    pend = p;
                }
                if (!inCode && isIdStart(p))
                {
                    ткст0 q = p + utfStride(p);
                    while (isIdTail(q))
                        q += utfStride(q);

                    // Detected tag ends it
                    if (*q == ':' && isupper(*p)
                            && (isspace(q[1]) || q[1] == 0))
                    {
                        idlen = q - p;
                        idstart = p;
                        for (pend = p; pend > pstart; pend--)
                        {
                            if (pend[-1] == '\n')
                                break;
                        }
                        p = q + 1;
                        break;
                    }
                }
                while (1)
                {
                    if (!*p)
                        goto L1;
                    if (*p == '\n')
                    {
                        p++;
                        if (*p == '\n' && !summary && !namelen && !inCode)
                        {
                            pend = p;
                            p++;
                            goto L1;
                        }
                        break;
                    }
                    p++;
                    pend = p;
                }
                p = skipwhitespace(p);
            }
        L1:
            if (namelen || pstart < pend)
            {
                Section s;
                if (iequals("Параметры", имя[0 .. namelen]))
                    s = new ParamSection();
                else if (iequals("Macros", имя[0 .. namelen]))
                    s = new MacroSection();
                else
                    s = new Section();
                s.имя = имя;
                s.namelen = namelen;
                s._body = pstart;
                s.bodylen = pend - pstart;
                s.nooutput = 0;
                //printf("Section: '%.*s' = '%.*s'\n", cast(цел)s.namelen, s.имя, cast(цел)s.bodylen, s.body);
                sections.сунь(s);
                if (!summary && !namelen)
                    summary = s;
            }
            if (idlen)
            {
                имя = idstart;
                namelen = idlen;
            }
            else
            {
                имя = null;
                namelen = 0;
                if (!*p)
                    break;
            }
        }
    }

    проц writeSections(Scope* sc, Дсимволы* a, БуфВыв* буф)
    {
        assert(a.dim);
        //printf("DocComment::writeSections()\n");
        Место место = (*a)[0].место;
        if (Module m = (*a)[0].isModule())
        {
            if (m.md)
                место = m.md.место;
        }
        т_мера offset1 = буф.length;
        буф.пишиСтр("$(DDOC_SECTIONS ");
        т_мера offset2 = буф.length;
        for (т_мера i = 0; i < sections.dim; i++)
        {
            Section sec = sections[i];
            if (sec.nooutput)
                continue;
            //printf("Section: '%.*s' = '%.*s'\n", cast(цел)sec.namelen, sec.имя, cast(цел)sec.bodylen, sec.body);
            if (!sec.namelen && i == 0)
            {
                буф.пишиСтр("$(DDOC_SUMMARY ");
                т_мера o = буф.length;
                буф.пиши(sec._body[0 .. sec.bodylen]);
                escapeStrayParenthesis(место, буф, o, да);
                highlightText(sc, a, место, *буф, o);
                буф.пишиСтр(")");
            }
            else
                sec.пиши(место, &this, sc, a, буф);
        }
        for (т_мера i = 0; i < a.dim; i++)
        {
            ДСимвол s = (*a)[i];
            if (ДСимвол td = getEponymousParent(s))
                s = td;
            for (UnitTestDeclaration utd = s.ddocUnittest; utd; utd = utd.ddocUnittest)
            {
                if (utd.защита.вид == Prot.Kind.private_ || !utd.коммент || !utd.fbody)
                    continue;
                // Strip whitespaces to avoid showing empty summary
                ткст0 c = utd.коммент;
                while (*c == ' ' || *c == '\t' || *c == '\n' || *c == '\r')
                    ++c;
                буф.пишиСтр("$(DDOC_EXAMPLES ");
                т_мера o = буф.length;
                буф.пишиСтр(cast(сим*)c);
                if (utd.codedoc)
                {
                    auto codedoc = utd.codedoc.stripLeadingNewlines;
                    т_мера n = getCodeIndent(codedoc);
                    while (n--)
                        буф.пишиБайт(' ');
                    буф.пишиСтр("----\n");
                    буф.пишиСтр(codedoc);
                    буф.пишиСтр("----\n");
                    highlightText(sc, a, место, *буф, o);
                }
                буф.пишиСтр(")");
            }
        }
        if (буф.length == offset2)
        {
            /* Didn't пиши out any sections, so back out last пиши
             */
            буф.устРазм(offset1);
            буф.пишиСтр("\n");
        }
        else
            буф.пишиСтр(")");
    }
}

/*****************************************
 * Return да if коммент consists entirely of "ditto".
 */
private бул isDitto(ткст0 коммент)
{
    if (коммент)
    {
        ткст0 p = skipwhitespace(коммент);
        if (Port.memicmp(p, "ditto", 5) == 0 && *skipwhitespace(p + 5) == 0)
            return да;
    }
    return нет;
}

/**********************************************
 * Skip white space.
 */
private ткст0 skipwhitespace(ткст0 p)
{
    return skipwhitespace(p.вТкстД).ptr;
}

/// Ditto
private ткст skipwhitespace(ткст p)
{
    foreach (idx, сим c; p)
    {
        switch (c)
        {
        case ' ':
        case '\t':
        case '\n':
            continue;
        default:
            return p[idx .. $];
        }
    }
    return p[$ .. $];
}

/************************************************
 * Scan past all instances of the given characters.
 * Параметры:
 *  буф           = an БуфВыв containing the DDoc
 *  i             = the index within `буф` to start scanning from
 *  chars         = the characters to skip; order is unimportant
 * Возвращает: the index after skipping characters.
 */
private т_мера skipChars(ref БуфВыв буф, т_мера i, ткст chars)
{
    Outer:
    foreach (j, c; буф[][i..$])
    {
        foreach (d; chars)
        {
            if (d == c)
                continue Outer;
        }
        return i + j;
    }
    return буф.length;
}

unittest {
    БуфВыв буф;
    ткст данные = "test ---\r\n\r\nend";
    буф.пиши(данные);

    assert(skipChars(буф, 0, "-") == 0);
    assert(skipChars(буф, 4, "-") == 4);
    assert(skipChars(буф, 4, " -") == 8);
    assert(skipChars(буф, 8, "\r\n") == 12);
    assert(skipChars(буф, 12, "dne") == 15);
}

/****************************************************
 * Replace all instances of `c` with `r` in the given ткст
 * Параметры:
 *  s = the ткст to do replacements in
 *  c = the character to look for
 *  r = the ткст to replace `c` with
 * Возвращает: `s` with `c` replaced with `r`
 */
private ткст replaceChar(inout ткст s, сим c, ткст r) 
{
    цел count = 0;
    foreach (сим sc; s)
        if (sc == c)
            ++count;
    if (count == 0)
        return s;

    ткст результат;
    результат.резервируй(s.length - count + (r.length * count));
    т_мера start = 0;
    foreach (i, сим sc; s)
    {
        if (sc == c)
        {
            результат ~= s[start..i];
            результат ~= r;
            start = i+1;
        }
    }
    результат ~= s[start..$];
    return результат;
}

///
unittest
{
    assert("".replaceChar(',', "$(COMMA)") == "");
    assert("ab".replaceChar(',', "$(COMMA)") == "ab");
    assert("a,b".replaceChar(',', "$(COMMA)") == "a$(COMMA)b");
    assert("a,,b".replaceChar(',', "$(COMMA)") == "a$(COMMA)$(COMMA)b");
    assert(",ab".replaceChar(',', "$(COMMA)") == "$(COMMA)ab");
    assert("ab,".replaceChar(',', "$(COMMA)") == "ab$(COMMA)");
}

/**
 * Return a lowercased копируй of a ткст.
 * Параметры:
 *  s = the ткст to lowercase
 * Возвращает: the lowercase version of the ткст or the original if already lowercase
 */
private ткст toLowercase(ткст s) 
{
    ткст lower;
    foreach (т_мера i; new бцел[0..s.length])
    {
        сим c = s[i];
// TODO: maybe unicode lowercase, somehow
        if (c >= 'A' && c <= 'Z')
        {
            if (!lower.length) {
                lower.резервируй(s.length);
            }
            lower ~= s[lower.length..i];
            c += 'a' - 'A';
            lower ~= c;
        }
    }
    if (lower.length)
        lower ~= s[lower.length..$];
    else
        lower = s;
    return lower;
}

///
unittest
{
    assert("".toLowercase == "");
    assert("abc".toLowercase == "abc");
    assert("ABC".toLowercase == "abc");
    assert("aBc".toLowercase == "abc");
}

/************************************************
 * Get the отступ from one index to another, counting tab stops as four spaces wide
 * per the Markdown spec.
 * Параметры:
 *  буф   = an БуфВыв containing the DDoc
 *  from  = the index within `буф` to start counting from, inclusive
 *  to    = the index within `буф` to stop counting at, exclusive
 * Возвращает: the отступ
 */
private цел getMarkdownIndent(ref БуфВыв буф, т_мера from, т_мера to)
{
    const slice = буф[];
    if (to > slice.length)
        to = slice.length;
    цел отступ = 0;
    foreach ( c; slice[from..to])
        отступ += (c == '\t') ? 4 - (отступ % 4) : 1;
    return отступ;
}

/************************************************
 * Scan forward to one of:
 *      start of идентификатор
 *      beginning of следщ line
 *      end of буф
 */
т_мера skiptoident(ref БуфВыв буф, т_мера i)
{
    const slice = буф[];
    while (i < slice.length)
    {
        dchar c;
        т_мера oi = i;
        if (utf_decodeChar(slice, i, c))
        {
            /* Ignore UTF errors, but still consume input
             */
            break;
        }
        if (c >= 0x80)
        {
            if (!isUniAlpha(c))
                continue;
        }
        else if (!(isalpha(c) || c == '_' || c == '\n'))
            continue;
        i = oi;
        break;
    }
    return i;
}

/************************************************
 * Scan forward past end of идентификатор.
 */
private т_мера skippastident(ref БуфВыв буф, т_мера i)
{
    const slice = буф[];
    while (i < slice.length)
    {
        dchar c;
        т_мера oi = i;
        if (utf_decodeChar(slice, i, c))
        {
            /* Ignore UTF errors, but still consume input
             */
            break;
        }
        if (c >= 0x80)
        {
            if (isUniAlpha(c))
                continue;
        }
        else if (isalnum(c) || c == '_')
            continue;
        i = oi;
        break;
    }
    return i;
}

/************************************************
 * Scan forward past end of an идентификатор that might
 * contain dots (e.g. `abc.def`)
 */
private т_мера skipPastIdentWithDots(ref БуфВыв буф, т_мера i)
{
    const slice = буф[];
    бул lastCharWasDot;
    while (i < slice.length)
    {
        dchar c;
        т_мера oi = i;
        if (utf_decodeChar(slice, i, c))
        {
            /* Ignore UTF errors, but still consume input
             */
            break;
        }
        if (c == '.')
        {
            // We need to distinguish between `abc.def`, abc..def`, and `abc.`
            // Only `abc.def` is a valid идентификатор

            if (lastCharWasDot)
            {
                i = oi;
                break;
            }

            lastCharWasDot = да;
            continue;
        }
        else
        {
            if (c >= 0x80)
            {
                if (isUniAlpha(c))
                {
                    lastCharWasDot = нет;
                    continue;
                }
            }
            else if (isalnum(c) || c == '_')
            {
                lastCharWasDot = нет;
                continue;
            }
            i = oi;
            break;
        }
    }

    // if `abc.`
    if (lastCharWasDot)
        return i - 1;

    return i;
}

/************************************************
 * Scan forward past URL starting at i.
 * We don't want to highlight parts of a URL.
 * Возвращает:
 *      i if not a URL
 *      index just past it if it is a URL
 */
private т_мера skippastURL(ref БуфВыв буф, т_мера i)
{
    const slice = буф[][i .. $];
    т_мера j;
    бул sawdot = нет;
    if (slice.length > 7 && Port.memicmp(slice.ptr, "http://", 7) == 0)
    {
        j = 7;
    }
    else if (slice.length > 8 && Port.memicmp(slice.ptr, "https://", 8) == 0)
    {
        j = 8;
    }
    else
        goto Lno;
    for (; j < slice.length; j++)
    {
        const c = slice[j];
        if (isalnum(c))
            continue;
        if (c == '-' || c == '_' || c == '?' || c == '=' || c == '%' ||
            c == '&' || c == '/' || c == '+' || c == '#' || c == '~')
            continue;
        if (c == '.')
        {
            sawdot = да;
            continue;
        }
        break;
    }
    if (sawdot)
        return i + j;
Lno:
    return i;
}

/****************************************************
 * Remove a previously-inserted blank line macro.
 * Параметры:
 *  буф           = an БуфВыв containing the DDoc
 *  iAt           = the index within `буф` of the start of the `$(DDOC_BLANKLINE)`
 *                  macro. Upon function return its значение is set to `0`.
 *  i             = an index within `буф`. If `i` is after `iAt` then it gets
 *                  reduced by the length of the removed macro.
 */
private проц removeBlankLineMacro(ref БуфВыв буф, ref т_мера iAt, ref т_мера i)
{
    if (!iAt)
        return;

    const macroLength = "$(DDOC_BLANKLINE)".length;
    буф.удали(iAt, macroLength);
    if (i > iAt)
        i -= macroLength;
    iAt = 0;
}

/****************************************************
 * Attempt to detect and replace a Markdown thematic break (HR). These are three
 * or more of the same delimiter, optionally with spaces or tabs between any of
 * them, e.g. `\n- - -\n` becomes `\n$(HR)\n`
 * Параметры:
 *  буф         = an БуфВыв containing the DDoc
 *  i           = the index within `буф` of the first character of a potential
 *                thematic break. If the replacement is made `i` changes to
 *                point to the closing parenthesis of the `$(HR)` macro.
 *  iLineStart  = the index within `буф` that the thematic break's line starts at
 *  место         = the current location within the файл
 * Возвращает: whether a thematic break was replaced
 */
private бул replaceMarkdownThematicBreak(ref БуфВыв буф, ref т_мера i, т_мера iLineStart, ref Место место)
{
    if (!глоб2.парамы.markdown)
        return нет;

    const slice = буф[];
    const c = буф[i];
    т_мера j = i + 1;
    цел repeat = 1;
    for (; j < slice.length; j++)
    {
        if (буф[j] == c)
            ++repeat;
        else if (буф[j] != ' ' && буф[j] != '\t')
            break;
    }
    if (repeat >= 3)
    {
        if (j >= буф.length || буф[j] == '\n' || буф[j] == '\r')
        {
            if (глоб2.парамы.vmarkdown)
            {
                const s = буф[][i..j];
                message(место, "Ddoc: converted '%.*s' to a thematic break", cast(цел)s.length, s.ptr);
            }

            буф.удали(iLineStart, j - iLineStart);
            i = буф.вставь(iLineStart, "$(HR)") - 1;
            return да;
        }
    }
    return нет;
}

/****************************************************
 * Detect the уровень of an ATX-style heading, e.g. `## This is a heading` would
 * have a уровень of `2`.
 * Параметры:
 *  буф   = an БуфВыв containing the DDoc
 *  i     = the index within `буф` of the first `#` character
 * Возвращает:
 *          the detected heading уровень from 1 to 6, or
 *          0 if not at an ATX heading
 */
private цел detectAtxHeadingLevel(ref БуфВыв буф, т_мера i)
{
    if (!глоб2.парамы.markdown)
        return 0;

    const iHeadingStart = i;
    const iAfterHashes = skipChars(буф, i, "#");
    const headingLevel = cast(цел) (iAfterHashes - iHeadingStart);
    if (headingLevel > 6)
        return 0;

    const iTextStart = skipChars(буф, iAfterHashes, " \t");
    const emptyHeading = буф[iTextStart] == '\r' || буф[iTextStart] == '\n';

    // require whitespace
    if (!emptyHeading && iTextStart == iAfterHashes)
        return 0;

    return headingLevel;
}

/****************************************************
 * Remove any trailing `##` suffix from an ATX-style heading.
 * Параметры:
 *  буф   = an БуфВыв containing the DDoc
 *  i     = the index within `буф` to start looking for a suffix at
 */
private проц removeAnyAtxHeadingSuffix(ref БуфВыв буф, т_мера i)
{
    т_мера j = i;
    т_мера iSuffixStart = 0;
    т_мера iWhitespaceStart = j;
    const slice = буф[];
    for (; j < slice.length; j++)
    {
        switch (slice[j])
        {
        case '#':
            if (iWhitespaceStart && !iSuffixStart)
                iSuffixStart = j;
            continue;
        case ' ':
        case '\t':
            if (!iWhitespaceStart)
                iWhitespaceStart = j;
            continue;
        case '\r':
        case '\n':
            break;
        default:
            iSuffixStart = 0;
            iWhitespaceStart = 0;
            continue;
        }
        break;
    }
    if (iSuffixStart)
        буф.удали(iWhitespaceStart, j - iWhitespaceStart);
}

/****************************************************
 * Wrap text in a Markdown heading macro, e.g. `$(H2 heading text`).
 * Параметры:
 *  буф           = an БуфВыв containing the DDoc
 *  iStart        = the index within `буф` that the Markdown heading starts at
 *  iEnd          = the index within `буф` of the character after the last
 *                  heading character. Is incremented by the length of the
 *                  inserted heading macro when this function ends.
 *  место           = the location of the Ddoc within the файл
 *  headingLevel  = the уровень (1-6) of heading to end. Is set to `0` when this
 *                  function ends.
 */
private проц endMarkdownHeading(ref БуфВыв буф, т_мера iStart, ref т_мера iEnd, ref Место место, ref цел headingLevel)
{
    if (!глоб2.парамы.markdown)
        return;
    if (глоб2.парамы.vmarkdown)
    {
        const s = буф[][iStart..iEnd];
        message(место, "Ddoc: added heading '%.*s'", cast(цел)s.length, s.ptr);
    }

    сим[5] heading = "$(H0 ";
    heading[3] = cast(сим) ('0' + headingLevel);
    буф.вставь(iStart, heading);
    iEnd += 5;
    т_мера iBeforeNewline = iEnd;
    while (буф[iBeforeNewline-1] == '\r' || буф[iBeforeNewline-1] == '\n')
        --iBeforeNewline;
    буф.вставь(iBeforeNewline, ")");
    headingLevel = 0;
}

/****************************************************
 * End all nested Markdown quotes, if inside any.
 * Параметры:
 *  буф         = an БуфВыв containing the DDoc
 *  i           = the index within `буф` of the character after the quote text.
 *  quoteLevel  = the current quote уровень. Is set to `0` when this function ends.
 * Возвращает: the amount that `i` was moved
 */
private т_мера endAllMarkdownQuotes(ref БуфВыв буф, т_мера i, ref цел quoteLevel)
{
    const length = quoteLevel;
    for (; quoteLevel > 0; --quoteLevel)
        i = буф.вставь(i, ")");
    return length;
}

/****************************************************
 * Convenience function to end all Markdown lists and quotes, if inside any, and
 * set `quoteMacroLevel` to `0`.
 * Параметры:
 *  буф         = an БуфВыв containing the DDoc
 *  i           = the index within `буф` of the character after the list and/or
 *                quote text. Is adjusted when this function ends if any lists
 *                and/or quotes were ended.
 *  nestedLists = a set of nested lists. Upon return it will be empty.
 *  quoteLevel  = the current quote уровень. Is set to `0` when this function ends.
 *  quoteMacroLevel   = the macro уровень that the quote was started at. Is set to
 *                      `0` when this function ends.
 * Возвращает: the amount that `i` was moved
 */
private т_мера endAllListsAndQuotes(ref БуфВыв буф, ref т_мера i, ref MarkdownList[] nestedLists, ref цел quoteLevel, out цел quoteMacroLevel)
{
    quoteMacroLevel = 0;
    const i0 = i;
    i += MarkdownList.endAllNestedLists(буф, i, nestedLists);
    i += endAllMarkdownQuotes(буф, i, quoteLevel);
    return i - i0;
}

/****************************************************
 * Replace Markdown emphasis with the appropriate macro,
 * e.g. `*very* **nice**` becomes `$(EM very) $(STRONG nice)`.
 * Параметры:
 *  буф               = an БуфВыв containing the DDoc
 *  место               = the current location within the файл
 *  inlineDelimiters  = the collection of delimiters found within a paragraph. When this function returns its length will be reduced to `downToLevel`.
 *  downToLevel       = the length within `inlineDelimiters`` to reduce emphasis to
 * Возвращает: the number of characters added to the буфер by the replacements
 */
private т_мера replaceMarkdownEmphasis(ref БуфВыв буф, ref Место место, ref MarkdownDelimiter[] inlineDelimiters, цел downToLevel = 0)
{
    if (!глоб2.парамы.markdown)
        return 0;

    т_мера replaceEmphasisPair(ref MarkdownDelimiter start, ref MarkdownDelimiter end)
    {
        const count = start.count == 1 || end.count == 1 ? 1 : 2;

        т_мера iStart = start.iStart;
        т_мера iEnd = end.iStart;
        end.count -= count;
        start.count -= count;
        iStart += start.count;

        if (!start.count)
            start.тип = 0;
        if (!end.count)
            end.тип = 0;

        if (глоб2.парамы.vmarkdown)
        {
            const s = буф[][iStart + count..iEnd];
            message(место, "Ddoc: emphasized text '%.*s'", cast(цел)s.length, s.ptr);
        }

        буф.удали(iStart, count);
        iEnd -= count;
        буф.удали(iEnd, count);

        ткст macroName = count >= 2 ? "$(STRONG " : "$(EM ";
        буф.вставь(iEnd, ")");
        буф.вставь(iStart, macroName);

        const delta = 1 + macroName.length - (count + count);
        end.iStart += count;
        return delta;
    }

    т_мера delta = 0;
    цел start = (cast(цел) inlineDelimiters.length) - 1;
    while (start >= downToLevel)
    {
        // найди start emphasis
        while (start >= downToLevel &&
            (inlineDelimiters[start].тип != '*' || !inlineDelimiters[start].leftFlanking))
            --start;
        if (start < downToLevel)
            break;

        // найди the nearest end emphasis
        цел end = start + 1;
        while (end < inlineDelimiters.length &&
            (inlineDelimiters[end].тип != inlineDelimiters[start].тип ||
                inlineDelimiters[end].macroLevel != inlineDelimiters[start].macroLevel ||
                !inlineDelimiters[end].rightFlanking))
            ++end;
        if (end == inlineDelimiters.length)
        {
            // the start emphasis has no matching end; if it isn't an end itself then kill it
            if (!inlineDelimiters[start].rightFlanking)
                inlineDelimiters[start].тип = 0;
            --start;
            continue;
        }

        // multiple-of-3 rule
        if (((inlineDelimiters[start].leftFlanking && inlineDelimiters[start].rightFlanking) ||
                (inlineDelimiters[end].leftFlanking && inlineDelimiters[end].rightFlanking)) &&
            (inlineDelimiters[start].count + inlineDelimiters[end].count) % 3 == 0)
        {
            --start;
            continue;
        }

        const delta0 = replaceEmphasisPair(inlineDelimiters[start], inlineDelimiters[end]);

        for (; end < inlineDelimiters.length; ++end)
            inlineDelimiters[end].iStart += delta0;
        delta += delta0;
    }

    inlineDelimiters.length = downToLevel;
    return delta;
}

/****************************************************
 */
private бул isIdentifier(Дсимволы* a, ткст0 p, т_мера len)
{
    foreach (member; *a)
    {
        if (auto imp = member.isImport())
        {
            // For example: `public import str = core.stdc.ткст;`
            // This checks if `p` is equal to `str`
            if (imp.идНик)
            {
                if (p[0 .. len] == imp.идНик.вТкст())
                    return да;
            }
            else
            {
                // The general case:  `public import core.stdc.ткст;`

                // fully qualify imports so `core.stdc.ткст` doesn't appear as `core`
                ткст fullyQualifiedImport;
                if (imp.пакеты && imp.пакеты.dim)
                {
                    foreach (pid; *imp.пакеты)
                    {
                        fullyQualifiedImport ~= pid.вТкст() ~ ".";
                    }
                }
                fullyQualifiedImport ~= imp.ид.вТкст();

                // Check if `p` == `core.stdc.ткст`
                if (p[0 .. len] == fullyQualifiedImport)
                    return да;
            }
        }
        else if (member.идент)
        {
            if (p[0 .. len] == member.идент.вТкст())
                return да;
        }

    }
    return нет;
}

/****************************************************
 */
private бул isKeyword(ткст0 p, т_мера len)
{
    const ткст[3] table = ["да", "нет", "null"];
    foreach (s; table)
    {
        if (p[0 .. len] == s)
            return да;
    }
    return нет;
}

/****************************************************
 */
private TypeFunction isTypeFunction(ДСимвол s)
{
    FuncDeclaration f = s.isFuncDeclaration();
    /* f.тип may be NULL for template члены.
     */
    if (f && f.тип)
    {
        Тип t = f.originalType ? f.originalType : f.тип;
        if (t.ty == Tfunction)
            return cast(TypeFunction)t;
    }
    return null;
}

/****************************************************
 */
private Параметр2 isFunctionParameter(ДСимвол s, ткст0 p, т_мера len)
{
    TypeFunction tf = isTypeFunction(s);
    if (tf && tf.parameterList.parameters)
    {
        foreach (fparam; *tf.parameterList.parameters)
        {
            if (fparam.идент && p[0 .. len] == fparam.идент.вТкст())
            {
                return fparam;
            }
        }
    }
    return null;
}

/****************************************************
 */
private Параметр2 isFunctionParameter(Дсимволы* a, ткст0 p, т_мера len)
{
    for (т_мера i = 0; i < a.dim; i++)
    {
        Параметр2 fparam = isFunctionParameter((*a)[i], p, len);
        if (fparam)
        {
            return fparam;
        }
    }
    return null;
}

/****************************************************
 */
private Параметр2 isEponymousFunctionParameter(Дсимволы *a, сим *p, т_мера len)
{
    for (т_мера i = 0; i < a.dim; i++)
    {
        TemplateDeclaration td = (*a)[i].isTemplateDeclaration();
        if (td && td.onemember)
        {
            /* Case 1: we refer to a template declaration inside the template

               /// ...ddoc...
               template case1(T) {
                 проц case1(R)() {}
               }
             */
            td = td.onemember.isTemplateDeclaration();
        }
        if (!td)
        {
            /* Case 2: we're an alias to a template declaration

               /// ...ddoc...
               alias case2 = case1!цел;
             */
            AliasDeclaration ad = (*a)[i].isAliasDeclaration();
            if (ad && ad.aliassym)
            {
                td = ad.aliassym.isTemplateDeclaration();
            }
        }
        while (td)
        {
            ДСимвол sym = getEponymousMember(td);
            if (sym)
            {
                Параметр2 fparam = isFunctionParameter(sym, p, len);
                if (fparam)
                {
                    return fparam;
                }
            }
            td = td.overnext;
        }
    }
    return null;
}

/****************************************************
 */
private ПараметрШаблона2 isTemplateParameter(Дсимволы* a, ткст0 p, т_мера len)
{
    for (т_мера i = 0; i < a.dim; i++)
    {
        TemplateDeclaration td = (*a)[i].isTemplateDeclaration();
        // Check for the родитель, if the current symbol is not a template declaration.
        if (!td)
            td = getEponymousParent((*a)[i]);
        if (td && td.origParameters)
        {
            foreach (tp; *td.origParameters)
            {
                if (tp.идент && p[0 .. len] == tp.идент.вТкст())
                {
                    return tp;
                }
            }
        }
    }
    return null;
}

/****************************************************
 * Return да if str is a reserved symbol имя
 * that starts with a double underscore.
 */
private бул isReservedName(ткст str)
{
    const ткст[] table =
    [
        "__ctor",
        "__dtor",
        "__postblit",
        "__invariant",
        "__unitTest",
        "__require",
        "__ensure",
        "__dollar",
        "__ctfe",
        "__withSym",
        "__результат",
        "__returnLabel",
        "__vptr",
        "__monitor",
        "__gate",
        "__xopEquals",
        "__xopCmp",
        "__LINE__",
        "__FILE__",
        "__MODULE__",
        "__FUNCTION__",
        "__PRETTY_FUNCTION__",
        "__DATE__",
        "__TIME__",
        "__TIMESTAMP__",
        "__VENDOR__",
        "__VERSION__",
        "__EOF__",
        "__CXXLIB__",
        "__LOCAL_SIZE",
        "__entrypoint",
    ];
    foreach (s; table)
    {
        if (str == s)
            return да;
    }
    return нет;
}

/****************************************************
 * A delimiter for Markdown inline content like emphasis and links.
 */
private struct MarkdownDelimiter
{
    т_мера iStart;  /// the index where this delimiter starts
    цел count;      /// the length of this delimeter's start sequence
    цел macroLevel; /// the count of nested DDoc macros when the delimiter is started
    бул leftFlanking;  /// whether the delimiter is left-flanking, as defined by the CommonMark spec
    бул rightFlanking; /// whether the delimiter is right-flanking, as defined by the CommonMark spec
    бул atParagraphStart;  /// whether the delimiter is at the start of a paragraph
    сим тип;      /// the тип of delimiter, defined by its starting character

    /// whether this describes a valid delimiter
     бул isValid(){ return count != 0; }

    /// флаг this delimiter as invalid
    проц invalidate() { count = 0; }
}

/****************************************************
 * Info about a Markdown list.
 */
private struct MarkdownList
{
    ткст orderedStart;    /// an optional start number--if present then the list starts at this number
    т_мера iStart;          /// the index where the list item starts
    т_мера iContentStart;   /// the index where the content starts after the list delimiter
    цел delimiterIndent;    /// the уровень of отступ the list delimiter starts at
    цел contentIndent;      /// the уровень of отступ the content starts at
    цел macroLevel;         /// the count of nested DDoc macros when the list is started
    сим тип;              /// the тип of list, defined by its starting character

    /// whether this describes a valid list
     бул isValid(){ return тип != тип.init; }

    /****************************************************
     * Try to parse a list item, returning whether successful.
     * Параметры:
     *  буф           = an БуфВыв containing the DDoc
     *  iLineStart    = the index within `буф` of the first character of the line
     *  i             = the index within `буф` of the potential list item
     * Возвращает: the parsed list item. Its `isValid` property describes whether parsing succeeded.
     */
    static MarkdownList parseItem(ref БуфВыв буф, т_мера iLineStart, т_мера i)
    {
        if (!глоб2.парамы.markdown)
            return MarkdownList();

        if (буф[i] == '+' || буф[i] == '-' || буф[i] == '*')
            return parseUnorderedListItem(буф, iLineStart, i);
        else
            return parseOrderedListItem(буф, iLineStart, i);
    }

    /****************************************************
     * Return whether the context is at a list item of the same тип as this list.
     * Параметры:
     *  буф           = an БуфВыв containing the DDoc
     *  iLineStart    = the index within `буф` of the first character of the line
     *  i             = the index within `буф` of the list item
     * Возвращает: whether `i` is at a list item of the same тип as this list
     */
    private бул isAtItemInThisList(ref БуфВыв буф, т_мера iLineStart, т_мера i)
    {
        MarkdownList item = (тип == '.' || тип == ')') ?
            parseOrderedListItem(буф, iLineStart, i) :
            parseUnorderedListItem(буф, iLineStart, i);
        if (item.тип == тип)
            return item.delimiterIndent < contentIndent && item.contentIndent > delimiterIndent;
        return нет;
    }

    /****************************************************
     * Start a Markdown list item by creating/deleting nested lists and starting the item.
     * Параметры:
     *  буф           = an БуфВыв containing the DDoc
     *  iLineStart    = the index within `буф` of the first character of the line. If this function succeeds it will be adjuested to equal `i`.
     *  i             = the index within `буф` of the list item. If this function succeeds `i` will be adjusted to fit the inserted macro.
     *  iPrecedingBlankLine = the index within `буф` of the preceeding blank line. If non-нуль and a new list was started, the preceeding blank line is removed and this значение is set to `0`.
     *  nestedLists   = a set of nested lists. If this function succeeds it may contain a new nested list.
     *  место           = the location of the Ddoc within the файл
     * Возвращает: `да` if a list was created
     */
    бул startItem(ref БуфВыв буф, ref т_мера iLineStart, ref т_мера i, ref т_мера iPrecedingBlankLine, ref MarkdownList[] nestedLists, ref Место место)
    {
        буф.удали(iStart, iContentStart - iStart);

        if (!nestedLists.length ||
            delimiterIndent >= nestedLists[$-1].contentIndent ||
            буф[iLineStart - 4..iLineStart] == "$(LI")
        {
            // start a list macro
            nestedLists ~= this;
            if (тип == '.')
            {
                if (orderedStart.length)
                {
                    iStart = буф.вставь(iStart, "$(OL_START ");
                    iStart = буф.вставь(iStart, orderedStart);
                    iStart = буф.вставь(iStart, ",\n");
                }
                else
                    iStart = буф.вставь(iStart, "$(OL\n");
            }
            else
                iStart = буф.вставь(iStart, "$(UL\n");

            removeBlankLineMacro(буф, iPrecedingBlankLine, iStart);
        }
        else if (nestedLists.length)
        {
            nestedLists[$-1].delimiterIndent = delimiterIndent;
            nestedLists[$-1].contentIndent = contentIndent;
        }

        iStart = буф.вставь(iStart, "$(LI\n");
        i = iStart - 1;
        iLineStart = i;

        if (глоб2.парамы.vmarkdown)
        {
            т_мера iEnd = iStart;
            while (iEnd < буф.length && буф[iEnd] != '\r' && буф[iEnd] != '\n')
                ++iEnd;
            const s = буф[][iStart..iEnd];
            message(место, "Ddoc: starting list item '%.*s'", cast(цел)s.length, s.ptr);
        }

        return да;
    }

    /****************************************************
     * End all nested Markdown lists.
     * Параметры:
     *  буф           = an БуфВыв containing the DDoc
     *  i             = the index within `буф` to end lists at.
     *  nestedLists   = a set of nested lists. Upon return it will be empty.
     * Возвращает: the amount that `i` changed
     */
    static т_мера endAllNestedLists(ref БуфВыв буф, т_мера i, ref MarkdownList[] nestedLists)
    {
        const iStart = i;
        for (; nestedLists.length; --nestedLists.length)
            i = буф.вставь(i, ")\n)");
        return i - iStart;
    }

    /****************************************************
     * Look for a sibling list item or the end of nested list(s).
     * Параметры:
     *  буф               = an БуфВыв containing the DDoc
     *  i                 = the index within `буф` to end lists at. If there was a sibling or ending lists `i` will be adjusted to fit the macro endings.
     *  iParagraphStart   = the index within `буф` to start the следщ paragraph at at. May be adjusted upon return.
     *  nestedLists       = a set of nested lists. Some nested lists may have been removed from it upon return.
     */
    static проц handleSiblingOrEndingList(ref БуфВыв буф, ref т_мера i, ref т_мера iParagraphStart, ref MarkdownList[] nestedLists)
    {
        т_мера iAfterSpaces = skipChars(буф, i + 1, " \t");

        if (nestedLists[$-1].isAtItemInThisList(буф, i + 1, iAfterSpaces))
        {
            // end a sibling list item
            i = буф.вставь(i, ")");
            iParagraphStart = skipChars(буф, i, " \t\r\n");
        }
        else if (iAfterSpaces >= буф.length || (буф[iAfterSpaces] != '\r' && буф[iAfterSpaces] != '\n'))
        {
            // end nested lists that are indented more than this content
            const отступ = getMarkdownIndent(буф, i + 1, iAfterSpaces);
            while (nestedLists.length && nestedLists[$-1].contentIndent > отступ)
            {
                i = буф.вставь(i, ")\n)");
                --nestedLists.length;
                iParagraphStart = skipChars(буф, i, " \t\r\n");

                if (nestedLists.length && nestedLists[$-1].isAtItemInThisList(буф, i + 1, iParagraphStart))
                {
                    i = буф.вставь(i, ")");
                    ++iParagraphStart;
                    break;
                }
            }
        }
    }

    /****************************************************
     * Parse an unordered list item at the current position
     * Параметры:
     *  буф           = an БуфВыв containing the DDoc
     *  iLineStart    = the index within `буф` of the first character of the line
     *  i             = the index within `буф` of the list item
     * Возвращает: the parsed list item, or a list item with тип `.init` if no list item is доступно
     */
    private static MarkdownList parseUnorderedListItem(ref БуфВыв буф, т_мера iLineStart, т_мера i)
    {
        if (i+1 < буф.length &&
                (буф[i] == '-' ||
                буф[i] == '*' ||
                буф[i] == '+') &&
            (буф[i+1] == ' ' ||
                буф[i+1] == '\t' ||
                буф[i+1] == '\r' ||
                буф[i+1] == '\n'))
        {
            const iContentStart = skipChars(буф, i + 1, " \t");
            const delimiterIndent = getMarkdownIndent(буф, iLineStart, i);
            const contentIndent = getMarkdownIndent(буф, iLineStart, iContentStart);
            auto list = MarkdownList(null, iLineStart, iContentStart, delimiterIndent, contentIndent, 0, буф[i]);
            return list;
        }
        return MarkdownList();
    }

    /****************************************************
     * Parse an ordered list item at the current position
     * Параметры:
     *  буф           = an БуфВыв containing the DDoc
     *  iLineStart    = the index within `буф` of the first character of the line
     *  i             = the index within `буф` of the list item
     * Возвращает: the parsed list item, or a list item with тип `.init` if no list item is доступно
     */
    private static MarkdownList parseOrderedListItem(ref БуфВыв буф, т_мера iLineStart, т_мера i)
    {
        т_мера iAfterNumbers = skipChars(буф, i, "0123456789");
        if (iAfterNumbers - i > 0 &&
            iAfterNumbers - i <= 9 &&
            iAfterNumbers + 1 < буф.length &&
            буф[iAfterNumbers] == '.' &&
            (буф[iAfterNumbers+1] == ' ' ||
                буф[iAfterNumbers+1] == '\t' ||
                буф[iAfterNumbers+1] == '\r' ||
                буф[iAfterNumbers+1] == '\n'))
        {
            const iContentStart = skipChars(буф, iAfterNumbers + 1, " \t");
            const delimiterIndent = getMarkdownIndent(буф, iLineStart, i);
            const contentIndent = getMarkdownIndent(буф, iLineStart, iContentStart);
            т_мера iNumberStart = skipChars(буф, i, "0");
            if (iNumberStart == iAfterNumbers)
                --iNumberStart;
            auto orderedStart = буф[][iNumberStart .. iAfterNumbers];
            if (orderedStart == "1")
                orderedStart = null;
            return MarkdownList(orderedStart.idup, iLineStart, iContentStart, delimiterIndent, contentIndent, 0, буф[iAfterNumbers]);
        }
        return MarkdownList();
    }
}

/****************************************************
 * A Markdown link.
 */
private struct MarkdownLink
{
    ткст href;    /// the link destination
    ткст title;   /// an optional title for the link
    ткст label;   /// an optional label for the link
    ДСимвол symbol; /// an optional symbol to link to

    /****************************************************
     * Replace a Markdown link or link definition in the form of:
     * - Inline link: `[foo](url/ 'optional title')`
     * - Reference link: `[foo][bar]`, `[foo][]` or `[foo]`
     * - Link reference definition: `[bar]: url/ 'optional title'`
     * Параметры:
     *  буф               = an БуфВыв containing the DDoc
     *  i                 = the index within `буф` that points to the `]` character of the potential link.
     *                      If this function succeeds it will be adjusted to fit the inserted link macro.
     *  место               = the current location within the файл
     *  inlineDelimiters  = previously parsed Markdown delimiters, including emphasis and link/image starts
     *  delimiterIndex    = the index within `inlineDelimiters` of the nearest link/image starting delimiter
     *  linkReferences    = previously parsed link references. When this function returns it may contain
     *                      additional previously unparsed references.
     * Возвращает: whether a reference link was found and replaced at `i`
     */
    static бул replaceLink(ref БуфВыв буф, ref т_мера i, ref Место место, ref MarkdownDelimiter[] inlineDelimiters, цел delimiterIndex, ref MarkdownLinkReferences linkReferences)
    {
        const delimiter = inlineDelimiters[delimiterIndex];
        MarkdownLink link;

        т_мера iEnd = link.parseReferenceDefinition(буф, i, delimiter);
        if (iEnd > i)
        {
            i = delimiter.iStart;
            link.storeAndReplaceDefinition(буф, i, iEnd, linkReferences, место);
            inlineDelimiters.length = delimiterIndex;
            return да;
        }

        iEnd = link.parseInlineLink(буф, i);
        if (iEnd == i)
        {
            iEnd = link.parseReferenceLink(буф, i, delimiter);
            if (iEnd > i)
            {
                const label = link.label;
                link = linkReferences.lookupReference(label, буф, i, место);
                // check rightFlanking to avoid replacing things like цел[ткст]
                if (!link.href.length && !delimiter.rightFlanking)
                    link = linkReferences.lookupSymbol(label);
                if (!link.href.length)
                    return нет;
            }
        }

        if (iEnd == i)
            return нет;

        const delta = replaceMarkdownEmphasis(буф, место, inlineDelimiters, delimiterIndex);
        iEnd += delta;
        i += delta;

        if (глоб2.парамы.vmarkdown)
        {
            const s = буф[][delimiter.iStart..iEnd];
            message(место, "Ddoc: linking '%.*s' to '%.*s'", cast(цел)s.length, s.ptr, cast(цел)link.href.length, link.href.ptr);
        }

        link.replaceLink(буф, i, iEnd, delimiter);
        return да;
    }

    /****************************************************
     * Replace a Markdown link definition in the form of `[bar]: url/ 'optional title'`
     * Параметры:
     *  буф               = an БуфВыв containing the DDoc
     *  i                 = the index within `буф` that points to the `]` character of the potential link.
     *                      If this function succeeds it will be adjusted to fit the inserted link macro.
     *  inlineDelimiters  = previously parsed Markdown delimiters, including emphasis and link/image starts
     *  delimiterIndex    = the index within `inlineDelimiters` of the nearest link/image starting delimiter
     *  linkReferences    = previously parsed link references. When this function returns it may contain
     *                      additional previously unparsed references.
     *  место               = the current location in the файл
     * Возвращает: whether a reference link was found and replaced at `i`
     */
    static бул replaceReferenceDefinition(ref БуфВыв буф, ref т_мера i, ref MarkdownDelimiter[] inlineDelimiters, цел delimiterIndex, ref MarkdownLinkReferences linkReferences, ref Место место)
    {
        const delimiter = inlineDelimiters[delimiterIndex];
        MarkdownLink link;
        т_мера iEnd = link.parseReferenceDefinition(буф, i, delimiter);
        if (iEnd == i)
            return нет;

        i = delimiter.iStart;
        link.storeAndReplaceDefinition(буф, i, iEnd, linkReferences, место);
        inlineDelimiters.length = delimiterIndex;
        return да;
    }

    /****************************************************
     * Parse a Markdown inline link in the form of `[foo](url/ 'optional title')`
     * Параметры:
     *  буф   = an БуфВыв containing the DDoc
     *  i     = the index within `буф` that points to the `]` character of the inline link.
     * Возвращает: the index at the end of parsing the link, or `i` if parsing failed.
     */
    private т_мера parseInlineLink(ref БуфВыв буф, т_мера i)
    {
        т_мера iEnd = i + 1;
        if (iEnd >= буф.length || буф[iEnd] != '(')
            return i;
        ++iEnd;

        if (!parseHref(буф, iEnd))
            return i;

        iEnd = skipChars(буф, iEnd, " \t\r\n");
        if (буф[iEnd] != ')')
        {
            if (parseTitle(буф, iEnd))
                iEnd = skipChars(буф, iEnd, " \t\r\n");
        }

        if (буф[iEnd] != ')')
            return i;

        return iEnd + 1;
    }

    /****************************************************
     * Parse a Markdown reference link in the form of `[foo][bar]`, `[foo][]` or `[foo]`
     * Параметры:
     *  буф       = an БуфВыв containing the DDoc
     *  i         = the index within `буф` that points to the `]` character of the inline link.
     *  delimiter = the delimiter that starts this link
     * Возвращает: the index at the end of parsing the link, or `i` if parsing failed.
     */
    private т_мера parseReferenceLink(ref БуфВыв буф, т_мера i, MarkdownDelimiter delimiter)
    {
        т_мера iStart = i + 1;
        т_мера iEnd = iStart;
        if (iEnd >= буф.length || буф[iEnd] != '[' || (iEnd+1 < буф.length && буф[iEnd+1] == ']'))
        {
            // collapsed reference [foo][] or shortcut reference [foo]
            iStart = delimiter.iStart + delimiter.count - 1;
            if (буф[iEnd] == '[')
                iEnd += 2;
        }

        parseLabel(буф, iStart);
        if (!label.length)
            return i;

        if (iEnd < iStart)
            iEnd = iStart;
        return iEnd;
    }

    /****************************************************
     * Parse a Markdown reference definition in the form of `[bar]: url/ 'optional title'`
     * Параметры:
     *  буф               = an БуфВыв containing the DDoc
     *  i                 = the index within `буф` that points to the `]` character of the inline link.
     *  delimiter = the delimiter that starts this link
     * Возвращает: the index at the end of parsing the link, or `i` if parsing failed.
     */
    private т_мера parseReferenceDefinition(ref БуфВыв буф, т_мера i, MarkdownDelimiter delimiter)
    {
        if (!delimiter.atParagraphStart || delimiter.тип != '[' ||
            i+1 >= буф.length || буф[i+1] != ':')
            return i;

        т_мера iEnd = delimiter.iStart;
        parseLabel(буф, iEnd);
        if (label.length == 0 || iEnd != i + 1)
            return i;

        ++iEnd;
        iEnd = skipChars(буф, iEnd, " \t");
        skipOneNewline(буф, iEnd);

        if (!parseHref(буф, iEnd) || href.length == 0)
            return i;

        iEnd = skipChars(буф, iEnd, " \t");
        const requireNewline = !skipOneNewline(буф, iEnd);
        const iBeforeTitle = iEnd;

        if (parseTitle(буф, iEnd))
        {
            iEnd = skipChars(буф, iEnd, " \t");
            if (iEnd < буф.length && буф[iEnd] != '\r' && буф[iEnd] != '\n')
            {
                // the title must end with a newline
                title.length = 0;
                iEnd = iBeforeTitle;
            }
        }

        iEnd = skipChars(буф, iEnd, " \t");
        if (requireNewline && iEnd < буф.length-1 && буф[iEnd] != '\r' && буф[iEnd] != '\n')
            return i;

        return iEnd;
    }

    /****************************************************
     * Parse and normalize a Markdown reference label
     * Параметры:
     *  буф   = an БуфВыв containing the DDoc
     *  i     = the index within `буф` that points to the `[` character at the start of the label.
     *          If this function returns a non-empty label then `i` will point just after the ']' at the end of the label.
     * Возвращает: the parsed and normalized label, possibly empty
     */
    private бул parseLabel(ref БуфВыв буф, ref т_мера i)
    {
        if (буф[i] != '[')
            return нет;

        const slice = буф[];
        т_мера j = i + 1;

        // Some labels have already been en-symboled; handle that
        const inSymbol = j+15 < slice.length && slice[j..j+15] == "$(DDOC_PSYMBOL ";
        if (inSymbol)
            j += 15;

        for (; j < slice.length; ++j)
        {
            const c = slice[j];
            switch (c)
            {
            case ' ':
            case '\t':
            case '\r':
            case '\n':
                if (label.length && label[$-1] != ' ')
                    label ~= ' ';
                break;
            case ')':
                if (inSymbol && j+1 < slice.length && slice[j+1] == ']')
                {
                    ++j;
                    goto case ']';
                }
                goto default;
            case '[':
                if (slice[j-1] != '\\')
                {
                    label.length = 0;
                    return нет;
                }
                break;
            case ']':
                if (label.length && label[$-1] == ' ')
                    --label.length;
                if (label.length)
                {
                    i = j + 1;
                    return да;
                }
                return нет;
            default:
                label ~= c;
                break;
            }
        }
        label.length = 0;
        return нет;
    }

    /****************************************************
     * Parse and store a Markdown link URL, optionally enclosed in `<>` brackets
     * Параметры:
     *  буф   = an БуфВыв containing the DDoc
     *  i     = the index within `буф` that points to the first character of the URL.
     *          If this function succeeds `i` will point just after the the end of the URL.
     * Возвращает: whether a URL was found and parsed
     */
    private бул parseHref(ref БуфВыв буф, ref т_мера i)
    {
        т_мера j = skipChars(буф, i, " \t");

        т_мера iHrefStart = j;
        т_мера parenDepth = 1;
        бул inPointy = нет;
        const slice = буф[];
        for (; j < slice.length; j++)
        {
            switch (slice[j])
            {
            case '<':
                if (!inPointy && j == iHrefStart)
                {
                    inPointy = да;
                    ++iHrefStart;
                }
                break;
            case '>':
                if (inPointy && slice[j-1] != '\\')
                    goto LReturnHref;
                break;
            case '(':
                if (!inPointy && slice[j-1] != '\\')
                    ++parenDepth;
                break;
            case ')':
                if (!inPointy && slice[j-1] != '\\')
                {
                    --parenDepth;
                    if (!parenDepth)
                        goto LReturnHref;
                }
                break;
            case ' ':
            case '\t':
            case '\r':
            case '\n':
                if (inPointy)
                {
                    // invalid link
                    return нет;
                }
                goto LReturnHref;
            default:
                break;
            }
        }
        if (inPointy)
            return нет;
    LReturnHref:
        auto href = slice[iHrefStart .. j].dup;
        this.href = cast(ткст) percentEncode(removeEscapeBackslashes(href)).replaceChar(',', "$(COMMA)");
        i = j;
        if (inPointy)
            ++i;
        return да;
    }

    /****************************************************
     * Parse and store a Markdown link title, enclosed in parentheses or `'` or `"` quotes
     * Параметры:
     *  буф   = an БуфВыв containing the DDoc
     *  i     = the index within `буф` that points to the first character of the title.
     *          If this function succeeds `i` will point just after the the end of the title.
     * Возвращает: whether a title was found and parsed
     */
    private бул parseTitle(ref БуфВыв буф, ref т_мера i)
    {
        т_мера j = skipChars(буф, i, " \t");
        if (j >= буф.length)
            return нет;

        сим тип = буф[j];
        if (тип != '"' && тип != '\'' && тип != '(')
            return нет;
        if (тип == '(')
            тип = ')';

        const iTitleStart = j + 1;
        т_мера iNewline = 0;
        const slice = буф[];
        for (j = iTitleStart; j < slice.length; j++)
        {
            const c = slice[j];
            switch (c)
            {
            case ')':
            case '"':
            case '\'':
                if (тип == c && slice[j-1] != '\\')
                    goto LEndTitle;
                iNewline = 0;
                break;
            case ' ':
            case '\t':
            case '\r':
                break;
            case '\n':
                if (iNewline)
                {
                    // no blank строки in titles
                    return нет;
                }
                iNewline = j;
                break;
            default:
                iNewline = 0;
                break;
            }
        }
        return нет;
    LEndTitle:
        auto title = slice[iTitleStart .. j].dup;
        this.title = cast(ткст) removeEscapeBackslashes(title).
            replaceChar(',', "$(COMMA)").
            replaceChar('"', "$(QUOTE)");
        i = j + 1;
        return да;
    }

    /****************************************************
     * Replace a Markdown link or image with the appropriate macro
     * Параметры:
     *  буф       = an БуфВыв containing the DDoc
     *  i         = the index within `буф` that points to the `]` character of the inline link.
     *              When this function returns it will be adjusted to the end of the inserted macro.
     *  iLinkEnd  = the index within `буф` that points just after the last character of the link
     *  delimiter = the Markdown delimiter that started the link or image
     */
    private проц replaceLink(ref БуфВыв буф, ref т_мера i, т_мера iLinkEnd, MarkdownDelimiter delimiter)
    {
        т_мера iAfterLink = i - delimiter.count;
        ткст macroName;
        if (symbol)
        {
            macroName = "$(SYMBOL_LINK ";
        }
        else if (title.length)
        {
            if (delimiter.тип == '[')
                macroName = "$(LINK_TITLE ";
            else
                macroName = "$(IMAGE_TITLE ";
        }
        else
        {
            if (delimiter.тип == '[')
                macroName = "$(LINK2 ";
            else
                macroName = "$(IMAGE ";
        }
        буф.удали(delimiter.iStart, delimiter.count);
        буф.удали(i - delimiter.count, iLinkEnd - i);
        iLinkEnd = буф.вставь(delimiter.iStart, macroName);
        iLinkEnd = буф.вставь(iLinkEnd, href);
        iLinkEnd = буф.вставь(iLinkEnd, ", ");
        iAfterLink += macroName.length + href.length + 2;
        if (title.length)
        {
            iLinkEnd = буф.вставь(iLinkEnd, title);
            iLinkEnd = буф.вставь(iLinkEnd, ", ");
            iAfterLink += title.length + 2;

            // Link macros with titles require escaping commas
            for (т_мера j = iLinkEnd; j < iAfterLink; ++j)
                if (буф[j] == ',')
                {
                    буф.удали(j, 1);
                    j = буф.вставь(j, "$(COMMA)") - 1;
                    iAfterLink += 7;
                }
        }
// TODO: if image, удали internal macros, leaving only text
        буф.вставь(iAfterLink, ")");
        i = iAfterLink;
    }

    /****************************************************
     * Store the Markdown link definition and удали it from `буф`
     * Параметры:
     *  буф               = an БуфВыв containing the DDoc
     *  i                 = the index within `буф` that points to the `[` character at the start of the link definition.
     *                      When this function returns it will be adjusted to exclude the link definition.
     *  iEnd              = the index within `буф` that points just after the end of the definition
     *  linkReferences    = previously parsed link references. When this function returns it may contain
     *                      an additional reference.
     *  место               = the current location in the файл
     */
    private проц storeAndReplaceDefinition(ref БуфВыв буф, ref т_мера i, т_мера iEnd, ref MarkdownLinkReferences linkReferences, ref Место место)
    {
        if (глоб2.парамы.vmarkdown)
            message(место, "Ddoc: found link reference '%.*s' to '%.*s'", cast(цел)label.length, label.ptr, cast(цел)href.length, href.ptr);

        // Remove the definition and trailing whitespace
        iEnd = skipChars(буф, iEnd, " \t\r\n");
        буф.удали(i, iEnd - i);
        i -= 2;

        ткст lowercaseLabel = label.toLowercase();
        if (lowercaseLabel in linkReferences.references){}
           else  linkReferences.references[lowercaseLabel] = this;
    }

    /****************************************************
     * Remove Markdown escaping backslashes from the given ткст
     * Параметры:
     *  s = the ткст to удали escaping backslashes from
     * Возвращает: `s` without escaping backslashes in it
     */
    private static ткст removeEscapeBackslashes(ткст s)
    {
        if (!s.length)
            return s;

        // avoid doing anything if there isn't anything to ýñêàïèðóé
        т_мера i;
        for (i = 0; i < s.length-1; ++i)
            if (s[i] == '\\' && ispunct(s[i+1]))
                break;
        if (i == s.length-1)
            return s;

        // копируй characters backwards, then truncate
        т_мера j = i + 1;
        s[i] = s[j];
        for (++i, ++j; j < s.length; ++i, ++j)
        {
            if (j < s.length-1 && s[j] == '\\' && ispunct(s[j+1]))
                ++j;
            s[i] = s[j];
        }
        s.length -= (j - i);
        return s;
    }

    ///
    unittest
    {
        assert(removeEscapeBackslashes("".dup) == "");
        assert(removeEscapeBackslashes(`\a`.dup) == `\a`);
        assert(removeEscapeBackslashes(`.\`.dup) == `.\`);
        assert(removeEscapeBackslashes(`\.\`.dup) == `.\`);
        assert(removeEscapeBackslashes(`\.`.dup) == `.`);
        assert(removeEscapeBackslashes(`\.\.`.dup) == `..`);
        assert(removeEscapeBackslashes(`a\.b\.c`.dup) == `a.b.c`);
    }

    /****************************************************
     * Percent-encode (AKA URL-encode) the given ткст
     * Параметры:
     *  s = the ткст to percent-encode
     * Возвращает: `s` with special characters percent-encoded
     */
    private static ткст percentEncode(inout ткст s) 
    {
        static бул shouldEncode(сим c)
        {
            return ((c < '0' && c != '!' && c != '#' && c != '$' && c != '%' && c != '&' && c != '\'' && c != '(' &&
                    c != ')' && c != '*' && c != '+' && c != ',' && c != '-' && c != '.' && c != '/')
                || (c > '9' && c < 'A' && c != ':' && c != ';' && c != '=' && c != '?' && c != '@')
                || (c > 'Z' && c < 'a' && c != '[' && c != ']' && c != '_')
                || (c > 'z' && c != '~'));
        }

        for (т_мера i = 0; i < s.length; ++i)
        {
            if (shouldEncode(s[i]))
            {
                const static hexDigits = "0123456789ABCDEF";
                const encoded1 = hexDigits[s[i] >> 4];
                const encoded2 = hexDigits[s[i] & 0x0F];
                s = s[0..i] ~ '%' ~ encoded1 ~ encoded2 ~ s[i+1..$];
                i += 2;
            }
        }
        return s;
    }

    ///
    unittest
    {
        assert(percentEncode("") == "");
        assert(percentEncode("aB12-._~/?") == "aB12-._~/?");
        assert(percentEncode("<\n>") == "%3C%0A%3E");
    }

    /**************************************************
     * Skip a single newline at `i`
     * Параметры:
     *  буф   = an БуфВыв containing the DDoc
     *  i     = the index within `буф` to start looking at.
     *          If this function succeeds `i` will point after the newline.
     * Возвращает: whether a newline was skipped
     */
    private static бул skipOneNewline(ref БуфВыв буф, ref т_мера i) 
    {
        if (i < буф.length && буф[i] == '\r')
            ++i;
        if (i < буф.length && буф[i] == '\n')
        {
            ++i;
            return да;
        }
        return нет;
    }
}

/**************************************************
 * A set of Markdown link references.
 */
private struct MarkdownLinkReferences
{
    MarkdownLink[ткст] references;    // link references keyed by normalized label
    MarkdownLink[ткст] symbols;       // link symbols keyed by имя
    Scope* _scope;      // the current scope
    бул extractedAll;  // the index into the буфер of the last-parsed reference

    /**************************************************
     * Look up a reference by label, searching through the rest of the буфер if needed.
     * Symbols in the current scope are searched for if the DDoc doesn't define the reference.
     * Параметры:
     *  label = the label to найди the reference for
     *  буф   = an БуфВыв containing the DDoc
     *  i     = the index within `буф` to start searching for references at
     *  место   = the current location in the файл
     * Возвращает: a link. If the `href` member has a значение then the reference is valid.
     */
    MarkdownLink lookupReference(ткст label, ref БуфВыв буф, т_мера i, ref Место место)
    {
        const lowercaseLabel = label.toLowercase();
        if (lowercaseLabel in references){}
         else  extractReferences(буф, i, место);

        if (lowercaseLabel in references)
            return references[lowercaseLabel];

        return MarkdownLink();
    }

    /**
     * Look up the link for the D symbol with the given имя.
     * If found, the link is cached in the `symbols` member.
     * Параметры:
     *  имя  = the имя of the symbol
     * Возвращает: the link for the symbol or a link with a `null` href
     */
    MarkdownLink lookupSymbol(ткст имя)
    {
        if (имя in symbols)
            return symbols[имя];

        const ids = split(имя, '.');

        MarkdownLink link;
        auto ид = Идентификатор2.lookup(ids[0].ptr, ids[0].length);
        if (ид)
        {
            auto место = Место();
            auto symbol = _scope.search(место, ид, null, IgnoreErrors);
            for (т_мера i = 1; symbol && i < ids.length; ++i)
            {
                ид = Идентификатор2.lookup(ids[i].ptr, ids[i].length);
                symbol = ид !is null ? symbol.search(место, ид, IgnoreErrors) : null;
            }
            if (symbol)
                link = MarkdownLink(createHref(symbol), null, имя, symbol);
        }

        symbols[имя] = link;
        return link;
    }

    /**************************************************
     * Remove and store all link references from the document, in the form of
     * `[label]: href "optional title"`
     * Параметры:
     *  буф   = an БуфВыв containing the DDoc
     *  i     = the index within `буф` to start looking at
     *  место   = the current location in the файл
     * Возвращает: whether a reference was extracted
     */
    private проц extractReferences(ref БуфВыв буф, т_мера i, ref Место место)
    {
        static бул isFollowedBySpace(ref БуфВыв буф, т_мера i)
        {
            return i+1 < буф.length && (буф[i+1] == ' ' || буф[i+1] == '\t');
        }

        if (extractedAll)
            return;

        бул leadingBlank = нет;
        цел inCode = нет;
        бул newParagraph = да;
        MarkdownDelimiter[] delimiters;
        for (; i < буф.length; ++i)
        {
            const c = буф[i];
            switch (c)
            {
            case ' ':
            case '\t':
                break;
            case '\n':
                if (leadingBlank && !inCode)
                    newParagraph = да;
                leadingBlank = да;
                break;
            case '\\':
                ++i;
                break;
            case '#':
                if (leadingBlank && !inCode)
                    newParagraph = да;
                leadingBlank = нет;
                break;
            case '>':
                if (leadingBlank && !inCode)
                    newParagraph = да;
                break;
            case '+':
                if (leadingBlank && !inCode && isFollowedBySpace(буф, i))
                    newParagraph = да;
                else
                    leadingBlank = нет;
                break;
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                if (leadingBlank && !inCode)
                {
                    i = skipChars(буф, i, "0123456789");
                    if (i < буф.length &&
                        (буф[i] == '.' || буф[i] == ')') &&
                        isFollowedBySpace(буф, i))
                        newParagraph = да;
                    else
                        leadingBlank = нет;
                }
                break;
            case '*':
                if (leadingBlank && !inCode)
                {
                    newParagraph = да;
                    if (!isFollowedBySpace(буф, i))
                        leadingBlank = нет;
                }
                break;
            case '`':
            case '~':
                if (leadingBlank && i+2 < буф.length && буф[i+1] == c && буф[i+2] == c)
                {
                    inCode = inCode == c ? нет : c;
                    i = skipChars(буф, i, [c]) - 1;
                    newParagraph = да;
                }
                leadingBlank = нет;
                break;
            case '-':
                if (leadingBlank && !inCode && isFollowedBySpace(буф, i))
                    goto case '+';
                else
                    goto case '`';
            case '[':
                if (leadingBlank && !inCode && newParagraph)
                    delimiters ~= MarkdownDelimiter(i, 1, 0, нет, нет, да, c);
                break;
            case ']':
                if (delimiters.length && !inCode &&
                    MarkdownLink.replaceReferenceDefinition(буф, i, delimiters, cast(цел) delimiters.length - 1, this, место))
                    --i;
                break;
            default:
                if (leadingBlank)
                    newParagraph = нет;
                leadingBlank = нет;
                break;
            }
        }
        extractedAll = да;
    }

    /**
     * Split a ткст by a delimiter, excluding the delimiter.
     * Параметры:
     *  s         = the ткст to split
     *  delimiter = the character to split by
     * Возвращает: the результатing массив of strings
     */
    private static ткст[] split(ткст s, сим delimiter) 
    {
        ткст[] результат;
        т_мера iStart = 0;
        foreach (т_мера i; new бцел[0..s.length])
            if (s[i] == delimiter)
            {
                результат ~= s[iStart..i];
                iStart = i + 1;
            }
        результат ~= s[iStart..$];
        return результат;
    }

    ///
    unittest
    {
        assert(split("", ',') == [""]);
        assert(split("ab", ',') == ["ab"]);
        assert(split("a,b", ',') == ["a", "b"]);
        assert(split("a,,b", ',') == ["a", "", "b"]);
        assert(split(",ab", ',') == ["", "ab"]);
        assert(split("ab,", ',') == ["ab", ""]);
    }

    /**
     * Create a HREF for the given D symbol.
     * The HREF is relative to the current location if possible.
     * Параметры:
     *  symbol    = the symbol to создай a HREF for.
     * Возвращает: the результатing href
     */
    private ткст createHref(ДСимвол symbol)
    {
        ДСимвол root = symbol;

        ткст lref;
        while (symbol && symbol.идент && !symbol.isModule())
        {
            if (lref.length)
                lref = '.' ~ lref;
            lref = symbol.идент.вТкст() ~ lref;
            symbol = symbol.родитель;
        }

        ткст path;
        if (symbol && symbol.идент && symbol.isModule() != _scope._module)
        {
            do
            {
                root = symbol;

                // If the module has a файл имя, we're done
                if(auto m = symbol.isModule())
                    if (m.docfile)
                    {
                        path = m.docfile.вТкст();
                        break;
                    }

                if (path.length)
                    path = '_' ~ path;
                path = symbol.идент.вТкст() ~ path;
                symbol = symbol.родитель;
            } while (symbol && symbol.идент);

            if (!symbol && path.length)
                path ~= "$(DOC_EXTENSION)";
        }

        // Attempt an absolute URL if not in the same package
        while (root.родитель)
            root = root.родитель;
        ДСимвол scopeRoot = _scope._module;
        while (scopeRoot.родитель)
            scopeRoot = scopeRoot.родитель;
        if (scopeRoot != root)
        {
            path = "$(DOC_ROOT_" ~ root.идент.вТкст() ~ ')' ~ path;
            lref = '.' ~ lref;  // remote URIs like Phobos and Mir use .prefixes
        }

        return cast(ткст) (path ~ '#' ~ lref);
    }
}

private enum TableColumnAlignment
{
    none,
    left,
    center,
    right
}

/****************************************************
 * Parse a Markdown table delimiter row in the form of `| -- | :-- | :--: | --: |`
 * where the example text has four columns with the following alignments:
 * default, left, center, and right. The first and last pipes are optional. If a
 * delimiter row is found it will be removed from `буф`.
 *
 * Параметры:
 *  буф     = an БуфВыв containing the DDoc
 *  iStart  = the index within `буф` that the delimiter row starts at
 *  inQuote   = whether the table is inside a quote
 *  columnAlignments = alignments to populate for each column
 * Возвращает: the index of the end of the parsed delimiter, or `0` if not found
 */
private т_мера parseTableDelimiterRow(ref БуфВыв буф, т_мера iStart, бул inQuote, ref TableColumnAlignment[] columnAlignments)
{
    т_мера i = skipChars(буф, iStart, inQuote ? ">| \t" : "| \t");
    while (i < буф.length && буф[i] != '\r' && буф[i] != '\n')
    {
        const leftColon = буф[i] == ':';
        if (leftColon)
            ++i;

        if (i >= буф.length || буф[i] != '-')
            break;
        i = skipChars(буф, i, "-");

        const rightColon = i < буф.length && буф[i] == ':';
        i = skipChars(буф, i, ": \t");

        if (i >= буф.length || (буф[i] != '|' && буф[i] != '\r' && буф[i] != '\n'))
            break;
        i = skipChars(буф, i, "| \t");

        columnAlignments ~= (leftColon && rightColon) ? TableColumnAlignment.center :
                leftColon ? TableColumnAlignment.left :
                rightColon ? TableColumnAlignment.right :
                TableColumnAlignment.none;
    }

    if (i < буф.length && буф[i] != '\r' && буф[i] != '\n' && буф[i] != ')')
    {
        columnAlignments.length = 0;
        return 0;
    }

    if (i < буф.length && буф[i] == '\r') ++i;
    if (i < буф.length && буф[i] == '\n') ++i;
    return i;
}

/****************************************************
 * Look for a table delimiter row, and if found parse the previous row as a
 * table header row. If both exist with a matching number of columns, start a
 * table.
 *
 * Параметры:
 *  буф       = an БуфВыв containing the DDoc
 *  iStart    = the index within `буф` that the table header row starts at, inclusive
 *  iEnd      = the index within `буф` that the table header row ends at, exclusive
 *  место       = the current location in the файл
 *  inQuote   = whether the table is inside a quote
 *  inlineDelimiters = delimiters containing columns separators and any inline emphasis
 *  columnAlignments = the parsed alignments for each column
 * Возвращает: the number of characters added by starting the table, or `0` if unchanged
 */
private т_мера startTable(ref БуфВыв буф, т_мера iStart, т_мера iEnd, ref Место место, бул inQuote, ref MarkdownDelimiter[] inlineDelimiters, out TableColumnAlignment[] columnAlignments)
{
    const iDelimiterRowEnd = parseTableDelimiterRow(буф, iEnd + 1, inQuote, columnAlignments);
    if (iDelimiterRowEnd)
    {
        const delta = replaceTableRow(буф, iStart, iEnd, место, inlineDelimiters, columnAlignments, да);
        if (delta)
        {
            буф.удали(iEnd + delta, iDelimiterRowEnd - iEnd);
            буф.вставь(iEnd + delta, "$(TBODY ");
            буф.вставь(iStart, "$(TABLE ");
            return delta + 15;
        }
    }

    columnAlignments.length = 0;
    return 0;
}

/****************************************************
 * Replace a Markdown table row in the form of table cells delimited by pipes:
 * `| cell | cell | cell`. The first and last pipes are optional.
 *
 * Параметры:
 *  буф       = an БуфВыв containing the DDoc
 *  iStart    = the index within `буф` that the table row starts at, inclusive
 *  iEnd      = the index within `буф` that the table row ends at, exclusive
 *  место       = the current location in the файл
 *  inlineDelimiters = delimiters containing columns separators and any inline emphasis
 *  columnAlignments = alignments for each column
 *  headerRow = if `да` then the number of columns will be enforced to match
 *              `columnAlignments.length` and the row will be surrounded by a
 *              `THEAD` macro
 * Возвращает: the number of characters added by replacing the row, or `0` if unchanged
 */
private т_мера replaceTableRow(ref БуфВыв буф, т_мера iStart, т_мера iEnd, ref Место место, ref MarkdownDelimiter[] inlineDelimiters, TableColumnAlignment[] columnAlignments, бул headerRow)
{
    if (!columnAlignments.length || iStart == iEnd)
        return 0;

    iStart = skipChars(буф, iStart, " \t");
    цел cellCount = 0;
    foreach (delimiter; inlineDelimiters)
        if (delimiter.тип == '|' && !delimiter.leftFlanking)
            ++cellCount;
    бул ignoreLast = inlineDelimiters.length > 0 && inlineDelimiters[$-1].тип == '|';
    if (ignoreLast)
    {
        const iLast = skipChars(буф, inlineDelimiters[$-1].iStart + inlineDelimiters[$-1].count, " \t");
        ignoreLast = iLast >= iEnd;
    }
    if (!ignoreLast)
        ++cellCount;

    if (headerRow && cellCount != columnAlignments.length)
        return 0;

    if (headerRow && глоб2.парамы.vmarkdown)
    {
        const s = буф[][iStart..iEnd];
        message(место, "Ddoc: formatting table '%.*s'", cast(цел)s.length, s.ptr);
    }

    т_мера delta = 0;

    проц replaceTableCell(т_мера iCellStart, т_мера iCellEnd, цел cellIndex, цел di)
    {
        const eDelta = replaceMarkdownEmphasis(буф, место, inlineDelimiters, di);
        delta += eDelta;
        iCellEnd += eDelta;

        // strip trailing whitespace and delimiter
        т_мера i = iCellEnd - 1;
        while (i > iCellStart && (буф[i] == '|' || буф[i] == ' ' || буф[i] == '\t'))
            --i;
        ++i;
        буф.удали(i, iCellEnd - i);
        delta -= iCellEnd - i;
        iCellEnd = i;

        буф.вставь(iCellEnd, ")");
        ++delta;

        // strip initial whitespace and delimiter
        i = skipChars(буф, iCellStart, "| \t");
        буф.удали(iCellStart, i - iCellStart);
        delta -= i - iCellStart;

        switch (columnAlignments[cellIndex])
        {
        case TableColumnAlignment.none:
            буф.вставь(iCellStart, headerRow ? "$(TH " : "$(TD ");
            delta += 5;
            break;
        case TableColumnAlignment.left:
            буф.вставь(iCellStart, "left, ");
            delta += 6;
            goto default;
        case TableColumnAlignment.center:
            буф.вставь(iCellStart, "center, ");
            delta += 8;
            goto default;
        case TableColumnAlignment.right:
            буф.вставь(iCellStart, "right, ");
            delta += 7;
            goto default;
        default:
            буф.вставь(iCellStart, headerRow ? "$(TH_ALIGN " : "$(TD_ALIGN ");
            delta += 11;
            break;
        }
    }

    цел cellIndex = cellCount - 1;
    т_мера iCellEnd = iEnd;
    foreach_reverse (di, delimiter; inlineDelimiters)
    {
        if (delimiter.тип == '|')
        {
            if (ignoreLast && di == inlineDelimiters.length-1)
            {
                ignoreLast = нет;
                continue;
            }

            if (cellIndex >= columnAlignments.length)
            {
                // kill any extra cells
                буф.удали(delimiter.iStart, iEnd + delta - delimiter.iStart);
                delta -= iEnd + delta - delimiter.iStart;
                iCellEnd = iEnd + delta;
                --cellIndex;
                continue;
            }

            replaceTableCell(delimiter.iStart, iCellEnd, cellIndex, cast(цел) di);
            iCellEnd = delimiter.iStart;
            --cellIndex;
        }
    }

    // if no starting pipe, replace from the start
    if (cellIndex >= 0)
        replaceTableCell(iStart, iCellEnd, cellIndex, 0);

    буф.вставь(iEnd + delta, ")");
    буф.вставь(iStart, "$(TR ");
    delta += 6;

    if (headerRow)
    {
        буф.вставь(iEnd + delta, ")");
        буф.вставь(iStart, "$(THEAD ");
        delta += 9;
    }

    return delta;
}

/****************************************************
 * End a table, if in one.
 *
 * Параметры:
 *  буф = an БуфВыв containing the DDoc
 *  i   = the index within `буф` to end the table at
 *  columnAlignments = alignments for each column; upon return is set to length `0`
 * Возвращает: the number of characters added by ending the table, or `0` if unchanged
 */
private т_мера endTable(ref БуфВыв буф, т_мера i, ref TableColumnAlignment[] columnAlignments)
{
    if (!columnAlignments.length)
        return 0;

    буф.вставь(i, "))");
    columnAlignments.length = 0;
    return 2;
}

/****************************************************
 * End a table row and then the table itself.
 *
 * Параметры:
 *  буф       = an БуфВыв containing the DDoc
 *  iStart    = the index within `буф` that the table row starts at, inclusive
 *  iEnd      = the index within `буф` that the table row ends at, exclusive
 *  место       = the current location in the файл
 *  inlineDelimiters = delimiters containing columns separators and any inline emphasis
 *  columnAlignments = alignments for each column; upon return is set to length `0`
 * Возвращает: the number of characters added by replacing the row, or `0` if unchanged
 */
private т_мера endRowAndTable(ref БуфВыв буф, т_мера iStart, т_мера iEnd, ref Место место, ref MarkdownDelimiter[] inlineDelimiters, ref TableColumnAlignment[] columnAlignments)
{
    т_мера delta = replaceTableRow(буф, iStart, iEnd, место, inlineDelimiters, columnAlignments, нет);
    delta += endTable(буф, iEnd + delta, columnAlignments);
    return delta;
}

/**************************************************
 * Highlight text section.
 *
 * Параметры:
 *  scope = the current parse scope
 *  a     = an массив of D symbols at the current scope
 *  место   = source location of start of text. It is a mutable копируй to allow incrementing its linenum, for printing the correct line number when an error is encountered in a multiline block of ddoc.
 *  буф   = an БуфВыв containing the DDoc
 *  смещение = the index within буф to start highlighting
 */
private проц highlightText(Scope* sc, Дсимволы* a, Место место, ref БуфВыв буф, т_мера смещение)
{
    const incrementLoc = место.номстр == 0 ? 1 : 0;
    место.номстр += incrementLoc;
    место.имяс = 0;
    //printf("highlightText()\n");
    бул leadingBlank = да;
    т_мера iParagraphStart = смещение;
    т_мера iPrecedingBlankLine = 0;
    цел headingLevel = 0;
    цел headingMacroLevel = 0;
    цел quoteLevel = 0;
    бул lineQuoted = нет;
    цел quoteMacroLevel = 0;
    MarkdownList[] nestedLists;
    MarkdownDelimiter[] inlineDelimiters;
    MarkdownLinkReferences linkReferences;
    TableColumnAlignment[] columnAlignments;
    бул tableRowDetected = нет;
    цел inCode = 0;
    цел inBacktick = 0;
    цел macroLevel = 0;
    цел previousMacroLevel = 0;
    цел parenLevel = 0;
    т_мера iCodeStart = 0; // start of code section
    т_мера codeFenceLength = 0;
    т_мера codeIndent = 0;
    ткст codeLanguage;
    т_мера iLineStart = смещение;
    linkReferences._scope = sc;
    for (т_мера i = смещение; i < буф.length; i++)
    {
        сим c = буф[i];
    Lcont:
        switch (c)
        {
        case ' ':
        case '\t':
            break;
        case '\n':
            if (inBacktick)
            {
                // `inline code` is only valid if contained on a single line
                // otherwise, the backticks should be output literally.
                //
                // This lets things like `output from the linker' display
                // unmolested while keeping the feature consistent with GitHub.
                inBacktick = нет;
                inCode = нет; // the backtick also assumes we're in code
                // Nothing else is necessary since the DDOC_BACKQUOTED macro is
                // inserted lazily at the close quote, meaning the rest of the
                // text is already OK.
            }
            if (headingLevel)
            {
                i += replaceMarkdownEmphasis(буф, место, inlineDelimiters);
                endMarkdownHeading(буф, iParagraphStart, i, место, headingLevel);
                removeBlankLineMacro(буф, iPrecedingBlankLine, i);
                ++i;
                iParagraphStart = skipChars(буф, i, " \t\r\n");
            }

            if (tableRowDetected && !columnAlignments.length)
                i += startTable(буф, iLineStart, i, место, lineQuoted, inlineDelimiters, columnAlignments);
            else if (columnAlignments.length)
            {
                const delta = replaceTableRow(буф, iLineStart, i, место, inlineDelimiters, columnAlignments, нет);
                if (delta)
                    i += delta;
                else
                    i += endTable(буф, i, columnAlignments);
            }

            if (!inCode && nestedLists.length && !quoteLevel)
                MarkdownList.handleSiblingOrEndingList(буф, i, iParagraphStart, nestedLists);

            iPrecedingBlankLine = 0;
            if (!inCode && i == iLineStart && i + 1 < буф.length) // if "\n\n"
            {
                i += endTable(буф, i, columnAlignments);
                if (!lineQuoted && quoteLevel)
                    endAllListsAndQuotes(буф, i, nestedLists, quoteLevel, quoteMacroLevel);
                i += replaceMarkdownEmphasis(буф, место, inlineDelimiters);

                // if we don't already know about this paragraph break then
                // вставь a blank line and record the paragraph break
                if (iParagraphStart <= i)
                {
                    iPrecedingBlankLine = i;
                    i = буф.вставь(i, "$(DDOC_BLANKLINE)");
                    iParagraphStart = i + 1;
                }
            }
            else if (inCode &&
                i == iLineStart &&
                i + 1 < буф.length &&
                !lineQuoted &&
                quoteLevel) // if "\n\n" in quoted code
            {
                inCode = нет;
                i = буф.вставь(i, ")");
                i += endAllMarkdownQuotes(буф, i, quoteLevel);
                quoteMacroLevel = 0;
            }
            leadingBlank = да;
            lineQuoted = нет;
            tableRowDetected = нет;
            iLineStart = i + 1;
            место.номстр += incrementLoc;

            // update the paragraph start if we just entered a macro
            if (previousMacroLevel < macroLevel && iParagraphStart < iLineStart)
                iParagraphStart = iLineStart;
            previousMacroLevel = macroLevel;
            break;

        case '<':
            {
                leadingBlank = нет;
                if (inCode)
                    break;
                const slice = буф[];
                auto p = &slice[i];
                const se = sc._module.escapetable.escapeChar('<');
                if (se == "&lt;")
                {
                    // Generating HTML
                    // Skip over comments
                    if (p[1] == '!' && p[2] == '-' && p[3] == '-')
                    {
                        т_мера j = i + 4;
                        p += 4;
                        while (1)
                        {
                            if (j == slice.length)
                                goto L1;
                            if (p[0] == '-' && p[1] == '-' && p[2] == '>')
                            {
                                i = j + 2; // place on closing '>'
                                break;
                            }
                            j++;
                            p++;
                        }
                        break;
                    }
                    // Skip over HTML tag
                    if (isalpha(p[1]) || (p[1] == '/' && isalpha(p[2])))
                    {
                        т_мера j = i + 2;
                        p += 2;
                        while (1)
                        {
                            if (j == slice.length)
                                break;
                            if (p[0] == '>')
                            {
                                i = j; // place on closing '>'
                                break;
                            }
                            j++;
                            p++;
                        }
                        break;
                    }
                }
            L1:
                // Replace '<' with '&lt;' character entity
                if (se.length)
                {
                    буф.удали(i, 1);
                    i = буф.вставь(i, se);
                    i--; // point to ';'
                }
                break;
            }

        case '>':
            {
                if (leadingBlank && (!inCode || quoteLevel) && глоб2.парамы.markdown)
                {
                    if (!quoteLevel && глоб2.парамы.vmarkdown)
                    {
                        т_мера iEnd = i + 1;
                        while (iEnd < буф.length && буф[iEnd] != '\n')
                            ++iEnd;
                        const s = буф[][i .. iEnd];
                        message(место, "Ddoc: starting quote block with '%.*s'", cast(цел)s.length, s.ptr);
                    }

                    lineQuoted = да;
                    цел lineQuoteLevel = 1;
                    т_мера iAfterDelimiters = i + 1;
                    for (; iAfterDelimiters < буф.length; ++iAfterDelimiters)
                    {
                        const c0 = буф[iAfterDelimiters];
                        if (c0 == '>')
                            ++lineQuoteLevel;
                        else if (c0 != ' ' && c0 != '\t')
                            break;
                    }
                    if (!quoteMacroLevel)
                        quoteMacroLevel = macroLevel;
                    буф.удали(i, iAfterDelimiters - i);

                    if (quoteLevel < lineQuoteLevel)
                    {
                        i += endRowAndTable(буф, iLineStart, i, место, inlineDelimiters, columnAlignments);
                        if (nestedLists.length)
                        {
                            const отступ = getMarkdownIndent(буф, iLineStart, i);
                            if (отступ < nestedLists[$-1].contentIndent)
                                i += MarkdownList.endAllNestedLists(буф, i, nestedLists);
                        }

                        for (; quoteLevel < lineQuoteLevel; ++quoteLevel)
                        {
                            i = буф.вставь(i, "$(BLOCKQUOTE\n");
                            iLineStart = iParagraphStart = i;
                        }
                        --i;
                    }
                    else
                    {
                        --i;
                        if (nestedLists.length)
                            MarkdownList.handleSiblingOrEndingList(буф, i, iParagraphStart, nestedLists);
                    }
                    break;
                }

                leadingBlank = нет;
                if (inCode)
                    break;
                // Replace '>' with '&gt;' character entity
                const se = sc._module.escapetable.escapeChar('>');
                if (se.length)
                {
                    буф.удали(i, 1);
                    i = буф.вставь(i, se);
                    i--; // point to ';'
                }
                break;
            }

        case '&':
            {
                leadingBlank = нет;
                if (inCode)
                    break;
                ткст0 p = cast(сим*)&буф[].ptr[i];
                if (p[1] == '#' || isalpha(p[1]))
                    break;
                // already a character entity
                // Replace '&' with '&amp;' character entity
                const se = sc._module.escapetable.escapeChar('&');
                if (se)
                {
                    буф.удали(i, 1);
                    i = буф.вставь(i, se);
                    i--; // point to ';'
                }
                break;
            }

        case '`':
            {
                const iAfterDelimiter = skipChars(буф, i, "`");
                const count = iAfterDelimiter - i;

                if (inBacktick == count)
                {
                    inBacktick = 0;
                    inCode = 0;
                    БуфВыв codebuf;
                    codebuf.пиши(буф[iCodeStart + count .. i]);
                    // ýñêàïèðóé the contents, but do not perform highlighting except for DDOC_PSYMBOL
                    highlightCode(sc, a, codebuf, 0);
                    escapeStrayParenthesis(место, &codebuf, 0, нет);
                    буф.удали(iCodeStart, i - iCodeStart + count); // also trimming off the current `
                    const pre = "$(DDOC_BACKQUOTED ";
                    i = буф.вставь(iCodeStart, pre);
                    i = буф.вставь(i, codebuf[]);
                    i = буф.вставь(i, ")");
                    i--; // point to the ending ) so when the for loop does i++, it will see the следщ character
                    break;
                }

                // Perhaps we're starting or ending a Markdown code block
                if (leadingBlank && глоб2.парамы.markdown && count >= 3)
                {
                    бул moreBackticks = нет;
                    for (т_мера j = iAfterDelimiter; !moreBackticks && j < буф.length; ++j)
                        if (буф[j] == '`')
                            moreBackticks = да;
                        else if (буф[j] == '\r' || буф[j] == '\n')
                            break;
                    if (!moreBackticks)
                        goto case '-';
                }

                if (inCode)
                {
                    if (inBacktick)
                        i = iAfterDelimiter - 1;
                    break;
                }
                inCode = c;
                inBacktick = cast(цел) count;
                codeIndent = 0; // inline code is not indented
                // All we do here is set the code flags and record
                // the location. The macro will be inserted lazily
                // so we can easily cancel the inBacktick if we come
                // across a newline character.
                iCodeStart = i;
                i = iAfterDelimiter - 1;
                break;
            }

        case '#':
        {
            /* A line beginning with # indicates an ATX-style heading. */
            if (leadingBlank && !inCode)
            {
                leadingBlank = нет;

                headingLevel = detectAtxHeadingLevel(буф, i);
                if (!headingLevel)
                    break;

                i += endRowAndTable(буф, iLineStart, i, место, inlineDelimiters, columnAlignments);
                if (!lineQuoted && quoteLevel)
                    i += endAllListsAndQuotes(буф, iLineStart, nestedLists, quoteLevel, quoteMacroLevel);

                // удали the ### префикс, including whitespace
                i = skipChars(буф, i + headingLevel, " \t");
                буф.удали(iLineStart, i - iLineStart);
                i = iParagraphStart = iLineStart;

                removeAnyAtxHeadingSuffix(буф, i);
                --i;

                headingMacroLevel = macroLevel;
            }
            break;
        }

        case '~':
            {
                if (leadingBlank && глоб2.парамы.markdown)
                {
                    // Perhaps we're starting or ending a Markdown code block
                    const iAfterDelimiter = skipChars(буф, i, "~");
                    if (iAfterDelimiter - i >= 3)
                        goto case '-';
                }
                leadingBlank = нет;
                break;
            }

        case '-':
            /* A line beginning with --- delimits a code section.
             * inCode tells us if it is start or end of a code section.
             */
            if (leadingBlank)
            {
                if (!inCode && c == '-')
                {
                    const list = MarkdownList.parseItem(буф, iLineStart, i);
                    if (list.isValid)
                    {
                        if (replaceMarkdownThematicBreak(буф, i, iLineStart, место))
                        {
                            removeBlankLineMacro(буф, iPrecedingBlankLine, i);
                            iParagraphStart = skipChars(буф, i+1, " \t\r\n");
                            break;
                        }
                        else
                            goto case '+';
                    }
                }

                т_мера istart = i;
                т_мера eollen = 0;
                leadingBlank = нет;
                const c0 = c; // if we jumped here from case '`' or case '~'
                т_мера iInfoString = 0;
                if (!inCode)
                    codeLanguage.length = 0;
                while (1)
                {
                    ++i;
                    if (i >= буф.length)
                        break;
                    c = буф[i];
                    if (c == '\n')
                    {
                        eollen = 1;
                        break;
                    }
                    if (c == '\r')
                    {
                        eollen = 1;
                        if (i + 1 >= буф.length)
                            break;
                        if (буф[i + 1] == '\n')
                        {
                            eollen = 2;
                            break;
                        }
                    }
                    // BUG: handle UTF PS and LS too
                    if (c != c0 || iInfoString)
                    {
                        if (глоб2.парамы.markdown && !iInfoString && !inCode && i - istart >= 3)
                        {
                            // Start a Markdown info ткст, like ```ruby
                            codeFenceLength = i - istart;
                            i = iInfoString = skipChars(буф, i, " \t");
                        }
                        else if (iInfoString && c != '`')
                        {
                            if (!codeLanguage.length && (c == ' ' || c == '\t'))
                                codeLanguage = cast(ткст) буф[iInfoString..i].idup;
                        }
                        else
                        {
                            iInfoString = 0;
                            goto Lcont;
                        }
                    }
                }
                if (i - istart < 3 || (inCode && (inCode != c0 || (inCode != '-' && i - istart < codeFenceLength))))
                    goto Lcont;
                if (iInfoString)
                {
                    if (!codeLanguage.length)
                        codeLanguage = cast(ткст) буф[iInfoString..i].idup;
                }
                else
                    codeFenceLength = i - istart;

                // We have the start/end of a code section
                // Remove the entire --- line, including blanks and \n
                буф.удали(iLineStart, i - iLineStart + eollen);
                i = iLineStart;
                if (eollen)
                    leadingBlank = да;
                if (inCode && (i <= iCodeStart))
                {
                    // Empty code section, just удали it completely.
                    inCode = 0;
                    break;
                }
                if (inCode)
                {
                    inCode = 0;
                    // The code section is from iCodeStart to i
                    БуфВыв codebuf;
                    codebuf.пиши(буф[iCodeStart .. i]);
                    codebuf.пишиБайт(0);
                    // Remove leading indentations from all строки
                    бул lineStart = да;
                    ткст0 endp = cast(сим*)codebuf[].ptr + codebuf.length;
                    for (ткст0 p = cast(сим*)codebuf[].ptr; p < endp;)
                    {
                        if (lineStart)
                        {
                            т_мера j = codeIndent;
                            ткст0 q = p;
                            while (j-- > 0 && q < endp && isIndentWS(q))
                                ++q;
                            codebuf.удали(p - cast(сим*)codebuf[].ptr, q - p);
                            assert(cast(сим*)codebuf[].ptr <= p);
                            assert(p < cast(сим*)codebuf[].ptr + codebuf.length);
                            lineStart = нет;
                            endp = cast(сим*)codebuf[].ptr + codebuf.length; // update
                            continue;
                        }
                        if (*p == '\n')
                            lineStart = да;
                        ++p;
                    }
                    if (!codeLanguage.length || codeLanguage == "dlang" || codeLanguage == "d")
                        highlightCode2(sc, a, codebuf, 0);
                    else
                        codebuf.удали(codebuf.length-1, 1);    // удали the trailing 0 byte
                    escapeStrayParenthesis(место, &codebuf, 0, нет);
                    буф.удали(iCodeStart, i - iCodeStart);
                    i = буф.вставь(iCodeStart, codebuf[]);
                    i = буф.вставь(i, ")\n");
                    i -= 2; // in следщ loop, c should be '\n'
                }
                else
                {
                    i += endRowAndTable(буф, iLineStart, i, место, inlineDelimiters, columnAlignments);
                    if (!lineQuoted && quoteLevel)
                    {
                        const delta = endAllListsAndQuotes(буф, iLineStart, nestedLists, quoteLevel, quoteMacroLevel);
                        i += delta;
                        istart += delta;
                    }

                    inCode = c0;
                    codeIndent = istart - iLineStart; // save отступ count
                    if (codeLanguage.length && codeLanguage != "dlang" && codeLanguage != "d")
                    {
                        // backslash-ýñêàïèðóé
                        for (т_мера j; j < codeLanguage.length - 1; ++j)
                            if (codeLanguage[j] == '\\' && ispunct(codeLanguage[j + 1]))
                                codeLanguage = codeLanguage[0..j] ~ codeLanguage[j + 1..$];

                        if (глоб2.парамы.vmarkdown)
                            message(место, "Ddoc: adding code block for language '%.*s'", cast(цел)codeLanguage.length, codeLanguage.ptr);

                        i = буф.вставь(i, "$(OTHER_CODE ");
                        i = буф.вставь(i, codeLanguage);
                        i = буф.вставь(i, ",");
                    }
                    else
                        i = буф.вставь(i, "$(D_CODE ");
                    iCodeStart = i;
                    i--; // place i on >
                    leadingBlank = да;
                }
            }
            break;

        case '_':
        {
            if (leadingBlank && !inCode && replaceMarkdownThematicBreak(буф, i, iLineStart, место))
            {
                i += endRowAndTable(буф, iLineStart, i, место, inlineDelimiters, columnAlignments);
                if (!lineQuoted && quoteLevel)
                    i += endAllListsAndQuotes(буф, iLineStart, nestedLists, quoteLevel, quoteMacroLevel);
                removeBlankLineMacro(буф, iPrecedingBlankLine, i);
                iParagraphStart = skipChars(буф, i+1, " \t\r\n");
                break;
            }
            goto default;
        }

        case '+':
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
        {
            if (leadingBlank && !inCode)
            {
                MarkdownList list = MarkdownList.parseItem(буф, iLineStart, i);
                if (list.isValid)
                {
                    // Avoid starting a numbered list in the middle of a paragraph
                    if (!nestedLists.length && list.orderedStart.length &&
                        iParagraphStart < iLineStart)
                    {
                        i += list.orderedStart.length - 1;
                        break;
                    }

                    i += endRowAndTable(буф, iLineStart, i, место, inlineDelimiters, columnAlignments);
                    if (!lineQuoted && quoteLevel)
                    {
                        const delta = endAllListsAndQuotes(буф, iLineStart, nestedLists, quoteLevel, quoteMacroLevel);
                        i += delta;
                        list.iStart += delta;
                        list.iContentStart += delta;
                    }

                    list.macroLevel = macroLevel;
                    list.startItem(буф, iLineStart, i, iPrecedingBlankLine, nestedLists, место);
                    break;
                }
            }
            leadingBlank = нет;
            break;
        }

        case '*':
        {
            if (inCode || inBacktick || !глоб2.парамы.markdown)
            {
                leadingBlank = нет;
                break;
            }

            if (leadingBlank)
            {
                // Check for a thematic break
                if (replaceMarkdownThematicBreak(буф, i, iLineStart, место))
                {
                    i += endRowAndTable(буф, iLineStart, i, место, inlineDelimiters, columnAlignments);
                    if (!lineQuoted && quoteLevel)
                        i += endAllListsAndQuotes(буф, iLineStart, nestedLists, quoteLevel, quoteMacroLevel);
                    removeBlankLineMacro(буф, iPrecedingBlankLine, i);
                    iParagraphStart = skipChars(буф, i+1, " \t\r\n");
                    break;
                }

                // An initial * indicates a Markdown list item
                const list = MarkdownList.parseItem(буф, iLineStart, i);
                if (list.isValid)
                    goto case '+';
            }

            // Markdown emphasis
            const leftC = i > смещение ? буф[i-1] : '\0';
            т_мера iAfterEmphasis = skipChars(буф, i+1, "*");
            const rightC = iAfterEmphasis < буф.length ? буф[iAfterEmphasis] : '\0';
            цел count = cast(цел) (iAfterEmphasis - i);
            const leftFlanking = (rightC != '\0' && !isspace(rightC)) && (!ispunct(rightC) || leftC == '\0' || isspace(leftC) || ispunct(leftC));
            const rightFlanking = (leftC != '\0' && !isspace(leftC)) && (!ispunct(leftC) || rightC == '\0' || isspace(rightC) || ispunct(rightC));
            auto emphasis = MarkdownDelimiter(i, count, macroLevel, leftFlanking, rightFlanking, нет, c);

            if (!emphasis.leftFlanking && !emphasis.rightFlanking)
            {
                i = iAfterEmphasis - 1;
                break;
            }

            inlineDelimiters ~= emphasis;
            i += emphasis.count;
            --i;
            break;
        }

        case '!':
        {
            leadingBlank = нет;

            if (inCode || !глоб2.парамы.markdown)
                break;

            if (i < буф.length-1 && буф[i+1] == '[')
            {
                const imageStart = MarkdownDelimiter(i, 2, macroLevel, нет, нет, нет, c);
                inlineDelimiters ~= imageStart;
                ++i;
            }
            break;
        }
        case '[':
        {
            if (inCode || !глоб2.парамы.markdown)
            {
                leadingBlank = нет;
                break;
            }

            const leftC = i > смещение ? буф[i-1] : '\0';
            const rightFlanking = leftC != '\0' && !isspace(leftC) && !ispunct(leftC);
            const atParagraphStart = leadingBlank && iParagraphStart >= iLineStart;
            const linkStart = MarkdownDelimiter(i, 1, macroLevel, нет, rightFlanking, atParagraphStart, c);
            inlineDelimiters ~= linkStart;
            leadingBlank = нет;
            break;
        }
        case ']':
        {
            leadingBlank = нет;

            if (inCode || !глоб2.парамы.markdown)
                break;

            for (цел d = cast(цел) inlineDelimiters.length - 1; d >= 0; --d)
            {
                const delimiter = inlineDelimiters[d];
                if (delimiter.тип == '[' || delimiter.тип == '!')
                {
                    if (delimiter.isValid &&
                        MarkdownLink.replaceLink(буф, i, место, inlineDelimiters, d, linkReferences))
                    {
                        // if we removed a reference link then we're at line start
                        if (i <= delimiter.iStart)
                            leadingBlank = да;

                        // don't nest links
                        if (delimiter.тип == '[')
                            for (--d; d >= 0; --d)
                                if (inlineDelimiters[d].тип == '[')
                                    inlineDelimiters[d].invalidate();
                    }
                    else
                    {
                        // nothing found, so kill the delimiter
                        inlineDelimiters = inlineDelimiters[0..d] ~ inlineDelimiters[d+1..$];
                    }
                    break;
                }
            }
            break;
        }

        case '|':
        {
            if (inCode || !глоб2.парамы.markdown)
            {
                leadingBlank = нет;
                break;
            }

            tableRowDetected = да;
            inlineDelimiters ~= MarkdownDelimiter(i, 1, macroLevel, leadingBlank, нет, нет, c);
            leadingBlank = нет;
            break;
        }

        case '\\':
        {
            leadingBlank = нет;
            if (inCode || i+1 >= буф.length || !глоб2.парамы.markdown)
                break;

            /* Escape Markdown special characters */
            сим c1 = буф[i+1];
            if (ispunct(c1))
            {
                if (глоб2.парамы.vmarkdown)
                    message(место, "Ddoc: backslash-escaped %c", c1);

                буф.удали(i, 1);

                auto se = sc._module.escapetable.escapeChar(c1);
                if (!se)
                    se = c1 == '$' ? "$(DOLLAR)" : c1 == ',' ? "$(COMMA)" : null;
                if (se)
                {
                    буф.удали(i, 1);
                    i = буф.вставь(i, se);
                    i--; // point to escaped сим
                }
            }
            break;
        }

        case '$':
        {
            /* Look for the start of a macro, '$(Идентификатор2'
             */
            leadingBlank = нет;
            if (inCode || inBacktick)
                break;
            const slice = буф[];
            auto p = &slice[i];
            if (p[1] == '(' && isIdStart(&p[2]))
                ++macroLevel;
            break;
        }

        case '(':
        {
            if (!inCode && i > смещение && буф[i-1] != '$')
                ++parenLevel;
            break;
        }

        case ')':
        {   /* End of macro
             */
            leadingBlank = нет;
            if (inCode || inBacktick)
                break;
            if (parenLevel > 0)
                --parenLevel;
            else if (macroLevel)
            {
                цел downToLevel = cast(цел) inlineDelimiters.length;
                while (downToLevel > 0 && inlineDelimiters[downToLevel - 1].macroLevel >= macroLevel)
                    --downToLevel;
                if (headingLevel && headingMacroLevel >= macroLevel)
                {
                    endMarkdownHeading(буф, iParagraphStart, i, место, headingLevel);
                    removeBlankLineMacro(буф, iPrecedingBlankLine, i);
                }
                i += endRowAndTable(буф, iLineStart, i, место, inlineDelimiters, columnAlignments);
                while (nestedLists.length && nestedLists[$-1].macroLevel >= macroLevel)
                {
                    i = буф.вставь(i, ")\n)");
                    --nestedLists.length;
                }
                if (quoteLevel && quoteMacroLevel >= macroLevel)
                    i += endAllMarkdownQuotes(буф, i, quoteLevel);
                i += replaceMarkdownEmphasis(буф, место, inlineDelimiters, downToLevel);

                --macroLevel;
                quoteMacroLevel = 0;
            }
            break;
        }

        default:
            leadingBlank = нет;
            if (sc._module.isDocFile || inCode)
                break;
            const start = cast(сим*)буф[].ptr + i;
            if (isIdStart(start))
            {
                т_мера j = skippastident(буф, i);
                if (i < j)
                {
                    т_мера k = skippastURL(буф, i);
                    if (i < k)
                    {
                        /* The URL is буф[i..k]
                         */
                        if (macroLevel)
                            /* Leave alone if already in a macro
                             */
                            i = k - 1;
                        else
                        {
                            /* Replace URL with '$(DDOC_LINK_AUTODETECT URL)'
                             */
                            i = буф.bracket(i, "$(DDOC_LINK_AUTODETECT ", k, ")") - 1;
                        }
                        break;
                    }
                }
                else
                    break;
                т_мера len = j - i;
                // leading '_' means no highlight unless it's a reserved symbol имя
                if (c == '_' && (i == 0 || !isdigit(*(start - 1))) && (i == буф.length - 1 || !isReservedName(start[0 .. len])))
                {
                    буф.удали(i, 1);
                    i = буф.bracket(i, "$(DDOC_AUTO_PSYMBOL_SUPPRESS ", j - 1, ")") - 1;
                    break;
                }
                if (isIdentifier(a, start, len))
                {
                    i = буф.bracket(i, "$(DDOC_AUTO_PSYMBOL ", j, ")") - 1;
                    break;
                }
                if (isKeyword(start, len))
                {
                    i = буф.bracket(i, "$(DDOC_AUTO_KEYWORD ", j, ")") - 1;
                    break;
                }
                if (isFunctionParameter(a, start, len))
                {
                    //printf("highlighting arg '%s', i = %d, j = %d\n", arg.идент.вТкст0(), i, j);
                    i = буф.bracket(i, "$(DDOC_AUTO_PARAM ", j, ")") - 1;
                    break;
                }
                i = j - 1;
            }
            break;
        }
    }

    if (inCode == '-')
        выведиОшибку(место, "unmatched `---` in DDoc коммент");
    else if (inCode)
        буф.вставь(буф.length, ")");

    т_мера i = буф.length;
    if (headingLevel)
    {
        endMarkdownHeading(буф, iParagraphStart, i, место, headingLevel);
        removeBlankLineMacro(буф, iPrecedingBlankLine, i);
    }
    i += endRowAndTable(буф, iLineStart, i, место, inlineDelimiters, columnAlignments);
    i += replaceMarkdownEmphasis(буф, место, inlineDelimiters);
    endAllListsAndQuotes(буф, i, nestedLists, quoteLevel, quoteMacroLevel);
}

/**************************************************
 * Highlight code for DDOC section.
 */
private проц highlightCode(Scope* sc, ДСимвол s, ref БуфВыв буф, т_мера смещение)
{
    auto imp = s.isImport();
    if (imp && imp.ники.dim > 0)
    {
        // For example: `public import core.stdc.ткст : memcpy, memcmp;`
        for(цел i = 0; i < imp.ники.dim; i++)
        {
            // Need to distinguish between
            // `public import core.stdc.ткст : memcpy, memcmp;` and
            // `public import core.stdc.ткст : копируй = memcpy, compare = memcmp;`
            auto a = imp.ники[i];
            auto ид = a ? a : imp.имена[i];
            auto место = Место.init;
            if (auto symFromId = sc.search(место, ид, null))
            {
                highlightCode(sc, symFromId, буф, смещение);
            }
        }
    }
    else
    {
        БуфВыв ancbuf;
        emitAnchor(ancbuf, s, sc);
        буф.вставь(смещение, ancbuf[]);
        смещение += ancbuf.length;

        Дсимволы a;
        a.сунь(s);
        highlightCode(sc, &a, буф, смещение);
    }
}

/****************************************************
 */
private проц highlightCode(Scope* sc, Дсимволы* a, ref БуфВыв буф, т_мера смещение)
{
    //printf("highlightCode(a = '%s')\n", a.вТкст0());
    бул resolvedTemplateParameters = нет;

    for (т_мера i = смещение; i < буф.length; i++)
    {
        сим c = буф[i];
        const se = sc._module.escapetable.escapeChar(c);
        if (se.length)
        {
            буф.удали(i, 1);
            i = буф.вставь(i, se);
            i--; // point to ';'
            continue;
        }
        ткст0 start = cast(сим*)буф[].ptr + i;
        if (isIdStart(start))
        {
            т_мера j = skipPastIdentWithDots(буф, i);
            if (i < j)
            {
                т_мера len = j - i;
                if (isIdentifier(a, start, len))
                {
                    i = буф.bracket(i, "$(DDOC_PSYMBOL ", j, ")") - 1;
                    continue;
                }
            }

            j = skippastident(буф, i);
            if (i < j)
            {
                т_мера len = j - i;
                if (isIdentifier(a, start, len))
                {
                    i = буф.bracket(i, "$(DDOC_PSYMBOL ", j, ")") - 1;
                    continue;
                }
                if (isFunctionParameter(a, start, len))
                {
                    //printf("highlighting arg '%s', i = %d, j = %d\n", arg.идент.вТкст0(), i, j);
                    i = буф.bracket(i, "$(DDOC_PARAM ", j, ")") - 1;
                    continue;
                }
                i = j - 1;
            }
        }
        else if (!resolvedTemplateParameters)
        {
            т_мера previ = i;

            // hunt for template declarations:
            foreach (symi; new бцел[0 .. a.dim])
            {
                FuncDeclaration fd = (*a)[symi].isFuncDeclaration();

                if (!fd || !fd.родитель || !fd.родитель.isTemplateDeclaration())
                {
                    continue;
                }

                TemplateDeclaration td = fd.родитель.isTemplateDeclaration();

                // build the template parameters
                МассивДРК!(т_мера) paramLens;
                paramLens.резервируй(td.parameters.dim);

                БуфВыв parametersBuf;
                HdrGenState hgs;

                parametersBuf.пишиБайт('(');

                foreach (parami; new бцел[0 .. td.parameters.dim])
                {
                    ПараметрШаблона2 tp = (*td.parameters)[parami];

                    if (parami)
                        parametersBuf.пишиСтр(", ");

                    т_мера lastOffset = parametersBuf.length;

                    .toCBuffer(tp, &parametersBuf, &hgs);

                    paramLens[parami] = parametersBuf.length - lastOffset;
                }
                parametersBuf.пишиБайт(')');

                const templateParams = parametersBuf[];

                //printf("templateDecl: %s\ntemplateParams: %s\nstart: %s\n", td.вТкст0(), templateParams, start);
                if (start[0 .. templateParams.length] == templateParams)
                {
                    const templateParamListMacro = "$(DDOC_TEMPLATE_PARAM_LIST ";
                    буф.bracket(i, templateParamListMacro.ptr, i + templateParams.length, ")");

                    // We have the параметр list. While we're here we might
                    // as well wrap the parameters themselves as well

                    // + 1 here to take into account the opening paren of the
                    // template param list
                    i += templateParamListMacro.length + 1;

                    foreach ( len; paramLens)
                    {
                        i = буф.bracket(i, "$(DDOC_TEMPLATE_PARAM ", i + len, ")");
                        // increment two here for space + comma
                        i += 2;
                    }

                    resolvedTemplateParameters = да;
                    // сбрось i to be positioned back before we found the template
                    // param list this assures that anything within the template
                    // param list that needs to be escaped or otherwise altered
                    // has an opportunity for that to happen outside of this context
                    i = previ;

                    continue;
                }
            }
        }
    }
}

/****************************************
 */
private проц highlightCode3(Scope* sc, ref БуфВыв буф, ткст0 p, ткст0 pend)
{
    for (; p < pend; p++)
    {
        const se = sc._module.escapetable.escapeChar(*p);
        if (se.length)
            буф.пишиСтр(se);
        else
            буф.пишиБайт(*p);
    }
}

/**************************************************
 * Highlight code for CODE section.
 */
private проц highlightCode2(Scope* sc, Дсимволы* a, ref БуфВыв буф, т_мера смещение)
{
    бцел errorsave = глоб2.startGagging();

    scope Lexer lex = new Lexer(null, cast(сим*)буф[].ptr, 0, буф.length - 1, 0, 1);
    БуфВыв res;
    ткст0 lastp = cast(сим*)буф[].ptr;
    //printf("highlightCode2('%.*s')\n", cast(цел)(буф.length - 1), буф[].ptr);
    res.резервируй(буф.length);
    while (1)
    {
        Сема2 tok;
        lex.scan(&tok);
        highlightCode3(sc, res, lastp, tok.ptr);
        ткст highlight = null;
        switch (tok.значение)
        {
        case ТОК2.идентификатор:
            {
                if (!sc)
                    break;
                т_мера len = lex.p - tok.ptr;
                if (isIdentifier(a, tok.ptr, len))
                {
                    highlight = "$(D_PSYMBOL ";
                    break;
                }
                if (isFunctionParameter(a, tok.ptr, len))
                {
                    //printf("highlighting arg '%s', i = %d, j = %d\n", arg.идент.вТкст0(), i, j);
                    highlight = "$(D_PARAM ";
                    break;
                }
                break;
            }
        case ТОК2.коммент:
            highlight = "$(D_COMMENT ";
            break;
        case ТОК2.string_:
            highlight = "$(D_STRING ";
            break;
        default:
            if (tok.isKeyword())
                highlight = "$(D_KEYWORD ";
            break;
        }
        if (highlight)
        {
            res.пишиСтр(highlight);
            т_мера o = res.length;
            highlightCode3(sc, res, tok.ptr, lex.p);
            if (tok.значение == ТОК2.коммент || tok.значение == ТОК2.string_)
                /* https://issues.dlang.org/show_bug.cgi?ид=7656
                 * https://issues.dlang.org/show_bug.cgi?ид=7715
                 * https://issues.dlang.org/show_bug.cgi?ид=10519
                 */
                escapeDdocString(&res, o);
            res.пишиБайт(')');
        }
        else
            highlightCode3(sc, res, tok.ptr, lex.p);
        if (tok.значение == ТОК2.endOfFile)
            break;
        lastp = lex.p;
    }
    буф.устРазм(смещение);
    буф.пиши(&res);
    глоб2.endGagging(errorsave);
}

/****************************************
 * Determine if p points to the start of a "..." параметр идентификатор.
 */
private бул isCVariadicArg(ткст p)
{
    return p.length >= 3 && p[0 .. 3] == "...";
}

/****************************************
 * Determine if p points to the start of an идентификатор.
 */
бул isIdStart(ткст0 p)
{
    dchar c = *p;
    if (isalpha(c) || c == '_')
        return да;
    if (c >= 0x80)
    {
        т_мера i = 0;
        if (utf_decodeChar(p[0 .. 4], i, c))
            return нет; // ignore errors
        if (isUniAlpha(c))
            return да;
    }
    return нет;
}

/****************************************
 * Determine if p points to the rest of an идентификатор.
 */
бул isIdTail(ткст0 p)
{
    dchar c = *p;
    if (isalnum(c) || c == '_')
        return да;
    if (c >= 0x80)
    {
        т_мера i = 0;
        if (utf_decodeChar(p[0 .. 4], i, c))
            return нет; // ignore errors
        if (isUniAlpha(c))
            return да;
    }
    return нет;
}

/****************************************
 * Determine if p points to the indentation space.
 */
private бул isIndentWS(ткст0 p)
{
    return (*p == ' ') || (*p == '\t');
}

/*****************************************
 * Return number of bytes in UTF character.
 */
цел utfStride(ткст0 p)
{
    dchar c = *p;
    if (c < 0x80)
        return 1;
    т_мера i = 0;
    utf_decodeChar(p[0 .. 4], i, c); // ignore errors, but still consume input
    return cast(цел)i;
}

private ткст0 stripLeadingNewlines(inout ткст0 s)
{
    while (s && *s == '\n' || *s == '\r')
        s++;

    return s;
}
