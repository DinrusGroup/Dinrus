/**
 * Text macro processor for Ddoc.
 *
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/dmacro.d, _dmacro.d)
 * Documentation:  https://dlang.org/phobos/dmd_dmacro.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/dmacro.d
 */

module dmd.dmacro;

import cidrus;
import drc.doc.Doc2;
import dmd.errors;
import dmd.globals;
import util.outbuffer;
import util.rmem;

 struct MacroTable
{
    /**********************************
     * Define имя=text macro.
     * If macro `имя` already exists, replace the text for it.
     * Параметры:
     *  имя = имя of macro
     *  text = text of macro
     */
    extern (D) проц define(ткст имя, ткст text)
    {
        //printf("MacroTable::define('%.*s' = '%.*s')\n", cast(цел)имя.length, имя.ptr, text.length, text.ptr);
        Macro* table;
        for (table = mactab; table; table = table.следщ)
        {
            if (table.имя == имя)
            {
                table.text = text;
                return;
            }
        }
        table = new Macro(имя, text);
        table.следщ = mactab;
        mactab = table;
    }

    /*****************************************************
     * Look for macros in буф and expand them in place.
     * Only look at the text in буф from start to pend.
     */
    extern (D) проц expand(ref БуфВыв буф, т_мера start, ref т_мера pend, ткст arg)
    {
        version (none)
        {
            printf("Macro::expand(буф[%d..%d], arg = '%.*s')\n", start, pend, cast(цел)arg.length, arg.ptr);
            printf("Buf is: '%.*s'\n", cast(цел)(pend - start), буф.данные + start);
        }
        // limit recursive expansion
         цел nest;
        if (nest > глоб2.recursionLimit)
        {
            выведиОшибку(Место.initial, "DDoc macro expansion limit exceeded; more than %d expansions.",
                  глоб2.recursionLimit);
            return;
        }
        nest++;
        т_мера end = pend;
        assert(start <= end);
        assert(end <= буф.length);
        /* First pass - replace $0
         */
        arg = memdup(arg);
        for (т_мера u = start; u + 1 < end;)
        {
            ткст0 p = cast(сим*)буф[].ptr; // буф.данные is not loop invariant
            /* Look for $0, but not $$0, and replace it with arg.
             */
            if (p[u] == '$' && (isdigit(p[u + 1]) || p[u + 1] == '+'))
            {
                if (u > start && p[u - 1] == '$')
                {
                    // Don't expand $$0, but replace it with $0
                    буф.удали(u - 1, 1);
                    end--;
                    u += 1; // now u is one past the closing '1'
                    continue;
                }
                сим c = p[u + 1];
                цел n = (c == '+') ? -1 : c - '0';
                ткст marg;
                if (n == 0)
                {
                    marg = arg;
                }
                else
                    extractArgN(arg, marg, n);
                if (marg.length == 0)
                {
                    // Just удали macro invocation
                    //printf("Replacing '$%c' with '%.*s'\n", p[u + 1], cast(цел)marg.length, marg.ptr);
                    буф.удали(u, 2);
                    end -= 2;
                }
                else if (c == '+')
                {
                    // Replace '$+' with 'arg'
                    //printf("Replacing '$%c' with '%.*s'\n", p[u + 1], cast(цел)marg.length, marg.ptr);
                    буф.удали(u, 2);
                    буф.вставь(u, marg);
                    end += marg.length - 2;
                    // Scan replaced text for further expansion
                    т_мера mend = u + marg.length;
                    expand(буф, u, mend, null);
                    end += mend - (u + marg.length);
                    u = mend;
                }
                else
                {
                    // Replace '$1' with '\xFF{arg\xFF}'
                    //printf("Replacing '$%c' with '\xFF{%.*s\xFF}'\n", p[u + 1], cast(цел)marg.length, marg.ptr);
                    ббайт[] slice = cast(ббайт[])буф[];
                    slice[u] = 0xFF;
                    slice[u + 1] = '{';
                    буф.вставь(u + 2, marg);
                    буф.вставь(u + 2 + marg.length, "\xFF}");
                    end += -2 + 2 + marg.length + 2;
                    // Scan replaced text for further expansion
                    т_мера mend = u + 2 + marg.length;
                    expand(буф, u + 2, mend, null);
                    end += mend - (u + 2 + marg.length);
                    u = mend;
                }
                //printf("u = %d, end = %d\n", u, end);
                //printf("#%.*s#\n", cast(цел)end, &буф.данные[0]);
                continue;
            }
            u++;
        }
        /* Second pass - replace other macros
         */
        for (т_мера u = start; u + 4 < end;)
        {
            ткст0 p = cast(сим*)буф[].ptr; // буф.данные is not loop invariant
            /* A valid start of macro expansion is $(c, where c is
             * an ид start character, and not $$(c.
             */
            if (p[u] == '$' && p[u + 1] == '(' && isIdStart(p + u + 2))
            {
                //printf("\tfound macro start '%c'\n", p[u + 2]);
                ткст0 имя = p + u + 2;
                т_мера namelen = 0;
                ткст marg;
                т_мера v;
                /* Scan forward to найди end of macro имя and
                 * beginning of macro argument (marg).
                 */
                for (v = u + 2; v < end; v += utfStride(p + v))
                {
                    if (!isIdTail(p + v))
                    {
                        // We've gone past the end of the macro имя.
                        namelen = v - (u + 2);
                        break;
                    }
                }
                v += extractArgN(p[v .. end], marg, 0);
                assert(v <= end);
                if (v < end)
                {
                    // v is on the closing ')'
                    if (u > start && p[u - 1] == '$')
                    {
                        // Don't expand $$(NAME), but replace it with $(NAME)
                        буф.удали(u - 1, 1);
                        end--;
                        u = v; // now u is one past the closing ')'
                        continue;
                    }
                    Macro* m = search(имя[0 .. namelen]);
                    if (!m)
                    {
                        const undef = "DDOC_UNDEFINED_MACRO";
                        m = search(undef);
                        if (m)
                        {
                            // Macro was not defined, so this is an expansion of
                            //   DDOC_UNDEFINED_MACRO. Prepend macro имя to args.
                            // marg = имя[ ] ~ "," ~ marg[ ];
                            if (marg.length)
                            {
                                ткст0 q = cast(сим*)mem.xmalloc(namelen + 1 + marg.length);
                                assert(q);
                                memcpy(q, имя, namelen);
                                q[namelen] = ',';
                                memcpy(q + namelen + 1, marg.ptr, marg.length);
                                marg = q[0 .. marg.length + namelen + 1];
                            }
                            else
                            {
                                marg = имя[0 .. namelen];
                            }
                        }
                    }
                    if (m)
                    {
                        if (m.inuse && marg.length == 0)
                        {
                            // Remove macro invocation
                            буф.удали(u, v + 1 - u);
                            end -= v + 1 - u;
                        }
                        else if (m.inuse && ((arg.length == marg.length && memcmp(arg.ptr, marg.ptr, arg.length) == 0) ||
                                             (arg.length + 4 == marg.length && marg[0] == 0xFF && marg[1] == '{' && memcmp(arg.ptr, marg.ptr + 2, arg.length) == 0 && marg[marg.length - 2] == 0xFF && marg[marg.length - 1] == '}')))
                        {
                            /* Recursive expansion:
                             *   marg is same as arg (with blue paint added)
                             * Just leave in place.
                             */
                        }
                        else
                        {
                            //printf("\tmacro '%.*s'(%.*s) = '%.*s'\n", cast(цел)m.namelen, m.имя, cast(цел)marg.length, marg.ptr, cast(цел)m.textlen, m.text);
                            marg = memdup(marg);
                            // Insert replacement text
                            буф.spread(v + 1, 2 + m.text.length + 2);
                            ббайт[] slice = cast(ббайт[])буф[];
                            slice[v + 1] = 0xFF;
                            slice[v + 2] = '{';
                            slice[v + 3 .. v + 3 + m.text.length] = cast(ббайт[])m.text[];
                            slice[v + 3 + m.text.length] = 0xFF;
                            slice[v + 3 + m.text.length + 1] = '}';
                            end += 2 + m.text.length + 2;
                            // Scan replaced text for further expansion
                            m.inuse++;
                            т_мера mend = v + 1 + 2 + m.text.length + 2;
                            expand(буф, v + 1, mend, marg);
                            end += mend - (v + 1 + 2 + m.text.length + 2);
                            m.inuse--;
                            буф.удали(u, v + 1 - u);
                            end -= v + 1 - u;
                            u += mend - (v + 1);
                            mem.xfree(cast(сим*)marg.ptr);
                            //printf("u = %d, end = %d\n", u, end);
                            //printf("#%.*s#\n", cast(цел)(end - u), &буф.данные[u]);
                            continue;
                        }
                    }
                    else
                    {
                        // Replace $(NAME) with nothing
                        буф.удали(u, v + 1 - u);
                        end -= (v + 1 - u);
                        continue;
                    }
                }
            }
            u++;
        }
        mem.xfree(cast(сим*)arg);
        pend = end;
        nest--;
    }

  private:

    extern (D) Macro* search(ткст имя)
    {
        Macro* table;
        //printf("Macro::search(%.*s)\n", cast(цел)имя.length, имя.ptr);
        for (table = mactab; table; table = table.следщ)
        {
            if (table.имя == имя)
            {
                //printf("\tfound %d\n", table.textlen);
                break;
            }
        }
        return table;
    }

    Macro* mactab;
}

/* ************************************************************************ */

private:

struct Macro
{
    Macro* следщ;            // следщ in list
    ткст имя;     // macro имя
    ткст text;     // macro replacement text
    цел inuse;              // macro is in use (don't expand)

    this(ткст имя, ткст text)
    {
        this.имя = имя;
        this.text = text;
    }
}

/************************
 * Make mutable копируй of slice p.
 * Параметры:
 *      p = slice
 * Возвращает:
 *      копируй allocated with mem.xmalloc()
 */

ткст memdup(ткст p)
{
    т_мера len = p.length;
    return (cast(сим*)memcpy(mem.xmalloc(len), p.ptr, len))[0 .. len];
}

/**********************************************************
 * Given буфер буф[], extract argument marg[].
 * Параметры:
 *      буф = source ткст
 *      marg = set to slice of буф[]
 *      n =     0:      get entire argument
 *              1..9:   get nth argument
 *              -1:     get 2nd through end
 */
т_мера extractArgN(ткст буф, out ткст marg, цел n)
{
    /* Scan forward for matching right parenthesis.
     * Nest parentheses.
     * Skip over "..." and '...' strings inside HTML tags.
     * Skip over <!-- ... --> comments.
     * Skip over previous macro insertions
     * Set marg.
     */
    бцел parens = 1;
    ббайт instring = 0;
    бцел incomment = 0;
    бцел intag = 0;
    бцел inexp = 0;
    бцел argn = 0;
    т_мера v = 0;
    const p = буф.ptr;
    const end = буф.length;
Largstart:
    // Skip first space, if any, to найди the start of the macro argument
    if (n != 1 && v < end && isspace(p[v]))
        v++;
    т_мера vstart = v;
    for (; v < end; v++)
    {
        сим c = p[v];
        switch (c)
        {
        case ',':
            if (!inexp && !instring && !incomment && parens == 1)
            {
                argn++;
                if (argn == 1 && n == -1)
                {
                    v++;
                    goto Largstart;
                }
                if (argn == n)
                    break;
                if (argn + 1 == n)
                {
                    v++;
                    goto Largstart;
                }
            }
            continue;
        case '(':
            if (!inexp && !instring && !incomment)
                parens++;
            continue;
        case ')':
            if (!inexp && !instring && !incomment && --parens == 0)
            {
                break;
            }
            continue;
        case '"':
        case '\'':
            if (!inexp && !incomment && intag)
            {
                if (c == instring)
                    instring = 0;
                else if (!instring)
                    instring = c;
            }
            continue;
        case '<':
            if (!inexp && !instring && !incomment)
            {
                if (v + 6 < end && p[v + 1] == '!' && p[v + 2] == '-' && p[v + 3] == '-')
                {
                    incomment = 1;
                    v += 3;
                }
                else if (v + 2 < end && isalpha(p[v + 1]))
                    intag = 1;
            }
            continue;
        case '>':
            if (!inexp)
                intag = 0;
            continue;
        case '-':
            if (!inexp && !instring && incomment && v + 2 < end && p[v + 1] == '-' && p[v + 2] == '>')
            {
                incomment = 0;
                v += 2;
            }
            continue;
        case 0xFF:
            if (v + 1 < end)
            {
                if (p[v + 1] == '{')
                    inexp++;
                else if (p[v + 1] == '}')
                    inexp--;
            }
            continue;
        default:
            continue;
        }
        break;
    }
    if (argn == 0 && n == -1)
        marg = p[v .. v];
    else
        marg = p[vstart .. v];
    //printf("extractArg%d('%.*s') = '%.*s'\n", n, cast(цел)end, p, cast(цел)marg.length, marg.ptr);
    return v;
}
