/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1994-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/dinifile.d, _dinifile.d)
 * Documentation:  https://dlang.org/phobos/dmd_dinifile.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/dinifile.d
 */

module dmd.dinifile;

import cidrus;
version(Posix)
import core.sys.posix.stdlib;
version(Windows)
{
import win32.winbase;
import win32.windef;
}
import util.env;
import dmd.errors;
import dmd.globals;
import util.rmem;
import util.filename;
import util.outbuffer;
import util.port;
import util.string;
import util.stringtable;

private const LOG = нет;

/*****************************
 * Find the config файл
 * Параметры:
 *      argv0 = program имя (argv[0])
 *      inifile = .ini файл имя
 * Возвращает:
 *      файл path of the config файл or NULL
 *      Note: this is a memory leak
 */
ткст findConfFile(ткст argv0, ткст inifile)
{
    static if (LOG)
    {
        printf("findinifile(argv0 = '%.*s', inifile = '%.*s')\n",
               cast(цел)argv0.length, argv0.ptr, cast(цел)inifile.length, inifile.ptr);
    }
    if (ИмяФайла.absolute(inifile))
        return inifile;
    if (ИмяФайла.exists(inifile))
        return inifile;
    /* Look for inifile in the following sequence of places:
     *      o current directory
     *      o home directory
     *      o exe directory (windows)
     *      o directory off of argv0
     *      o SYSCONFDIR=/etc (non-windows)
     */
    auto имяф = ИмяФайла.combine(getenv("HOME").вТкстД, inifile);
    if (ИмяФайла.exists(имяф))
        return имяф;
    version (Windows)
    {
        // This fix by Tim Matthews
        сим[MAX_PATH + 1] resolved_name;
        const len = GetModuleFileNameA(null, resolved_name.ptr, MAX_PATH + 1);
        if (len && ИмяФайла.exists(resolved_name[0 .. len]))
        {
            имяф = ИмяФайла.replaceName(resolved_name[0 .. len], inifile);
            if (ИмяФайла.exists(имяф))
                return имяф;
        }
    }
    имяф = ИмяФайла.replaceName(argv0, inifile);
    if (ИмяФайла.exists(имяф))
        return имяф;
    version (Posix)
    {
        // Search PATH for argv0
        const p = getenv("PATH");
        static if (LOG)
        {
            printf("\tPATH='%s'\n", p);
        }
        auto abspath = ИмяФайла.searchPath(p, argv0, нет);
        if (abspath)
        {
            auto absname = ИмяФайла.replaceName(abspath, inifile);
            if (ИмяФайла.exists(absname))
                return absname;
        }
        // Resolve symbolic links
        имяф = ИмяФайла.canonicalName(abspath ? abspath : argv0);
        if (имяф)
        {
            имяф = ИмяФайла.replaceName(имяф, inifile);
            if (ИмяФайла.exists(имяф))
                return имяф;
        }
        // Search SYSCONFDIR=/etc for inifile
        имяф = ИмяФайла.combine(import("SYSCONFDIR.imp"), inifile);
    }
    return имяф;
}

/**********************************
 * Read from environment, looking for cached значение first.
 * Параметры:
 *      environment = cached копируй of the environment
 *      имя = имя to look for
 * Возвращает:
 *      environment значение corresponding to имя
 */
ткст0 readFromEnv(ref ТаблицаСтрок!(сим*) environment, ткст0 имя)
{
    const len = strlen(имя);
    const sv = environment.lookup(имя, len);
    if (sv && sv.значение)
        return sv.значение; // get cached значение
    return getenv(имя);
}

/*********************************
 * Write to our копируй of the environment, not the real environment
 */
private бул writeToEnv(ref ТаблицаСтрок!(сим*) environment, ткст0 nameEqValue)
{
    auto p = strchr(nameEqValue, '=');
    if (!p)
        return нет;
    auto sv = environment.update(nameEqValue, p - nameEqValue);
    sv.значение = p + 1;
    return да;
}

/************************************
 * Update real environment with our копируй.
 * Параметры:
 *      environment = our копируй of the environment
 */
проц updateRealEnvironment(ref ТаблицаСтрок!(сим*) environment)
{
    foreach (sv; environment)
    {
        const имя = sv.toDchars();
        const значение = sv.значение;
        if (!значение) // deleted?
            continue;
        if (putenvRestorable(имя.вТкстД, значение.вТкстД))
            assert(0);
    }
}

/*****************************
 * Read and analyze .ini файл.
 * Write the entries into environment as
 * well as any entries in one of the specified section(s).
 *
 * Параметры:
 *      environment = our own cache of the program environment
 *      имяф = имя of the файл being parsed
 *      path = what @P will expand to
 *      буфер = contents of configuration файл
 *      sections = section имена
 */
проц parseConfFile(ref ТаблицаСтрок!(сим*) environment, ткст имяф, ткст path, ббайт[] буфер, Strings* sections)
{
    /********************
     * Skip spaces.
     */
    static ткст0 skipspace(ткст0 p)
    {
        while (isspace(*p))
            p++;
        return p;
    }

    // Parse into строки
    бул envsection = да; // default is to читай
    БуфВыв буф;
    бул eof = нет;
    цел lineNum = 0;
    for (т_мера i = 0; i < буфер.length && !eof; i++)
    {
    Lstart:
        const linestart = i;
        for (; i < буфер.length; i++)
        {
            switch (буфер[i])
            {
            case '\r':
                break;
            case '\n':
                // Skip if it was preceded by '\r'
                if (i && буфер[i - 1] == '\r')
                {
                    i++;
                    goto Lstart;
                }
                break;
            case 0:
            case 0x1A:
                eof = да;
                break;
            default:
                continue;
            }
            break;
        }
        ++lineNum;
        буф.устРазм(0);
        // First, expand the macros.
        // Macros are bracketed by % characters.
    Kloop:
        for (т_мера k = 0; k < i - linestart; ++k)
        {
            // The line is буфер[linestart..i]
            ткст0 line = cast(сим*)&буфер[linestart];
            if (line[k] == '%')
            {
                foreach (т_мера j; new бцел[k + 1 .. i - linestart])
                {
                    if (line[j] != '%')
                        continue;
                    if (j - k == 3 && Port.memicmp(&line[k + 1], "@P", 2) == 0)
                    {
                        // %@P% is special meaning the path to the .ini файл
                        auto p = path;
                        if (!p.length)
                            p = ".";
                        буф.пишиСтр(p);
                    }
                    else
                    {
                        auto len2 = j - k;
                        auto p = cast(сим*)Пам.check(malloc(len2));
                        len2--;
                        memcpy(p, &line[k + 1], len2);
                        p[len2] = 0;
                        Port.strupr(p);
                        const penv = readFromEnv(environment, p);
                        if (penv)
                            буф.пишиСтр(penv);
                        free(p);
                    }
                    k = j;
                    continue Kloop;
                }
            }
            буф.пишиБайт(line[k]);
        }

        // Remove trailing spaces
        const slice = буф[];
        auto slicelen = slice.length;
        while (slicelen && isspace(slice[slicelen - 1]))
            --slicelen;
        буф.устРазм(slicelen);

        auto p = буф.peekChars();
        // The expanded line is in p.
        // Now parse it for meaning.
        p = skipspace(p);
        switch (*p)
        {
        case ';':
            // коммент
        case 0:
            // blank
            break;
        case '[':
            // look for [Environment]
            p = skipspace(p + 1);
            ткст0 pn;
            for (pn = p; isalnum(*pn); pn++)
            {
            }
            if (*skipspace(pn) != ']')
            {
                // malformed [sectionname], so just say we're not in a section
                envsection = нет;
                break;
            }
            /* Search sectionnamev[] for p..pn and set envsection to да if it's there
             */
            for (т_мера j = 0; 1; ++j)
            {
                if (j == sections.dim)
                {
                    // Didn't найди it
                    envsection = нет;
                    break;
                }
                const sectionname = (*sections)[j];
                const len = strlen(sectionname);
                if (pn - p == len && Port.memicmp(p, sectionname, len) == 0)
                {
                    envsection = да;
                    break;
                }
            }
            break;
        default:
            if (envsection)
            {
                auto pn = p;
                // Convert имя to upper case;
                // удали spaces bracketing =
                for (; *p; p++)
                {
                    if (islower(*p))
                        *p &= ~0x20;
                    else if (isspace(*p))
                    {
                        memmove(p, p + 1, strlen(p));
                        p--;
                    }
                    else if (p[0] == '?' && p[1] == '=')
                    {
                        *p = '\0';
                        if (readFromEnv(environment, pn))
                        {
                            pn = null;
                            break;
                        }
                        // удали the '?' and resume parsing starting from
                        // '=' again so the regular variable format is
                        // parsed
                        memmove(p, p + 1, strlen(p + 1) + 1);
                        p--;
                    }
                    else if (*p == '=')
                    {
                        p++;
                        while (isspace(*p))
                            memmove(p, p + 1, strlen(p));
                        break;
                    }
                }
                if (pn)
                {
                    auto pns = cast(сим*)Пам.check(strdup(pn));
                    if (!writeToEnv(environment, pns))
                    {
                        выведиОшибку(Место(имяф.xarraydup.ptr, lineNum, 0), "Use `NAME=значение` syntax, not `%s`", pn);
                        fatal();
                    }
                    static if (LOG)
                    {
                        printf("\tputenv('%s')\n", pn);
                        //printf("getenv(\"TEST\") = '%s'\n",getenv("TEST"));
                    }
                }
            }
            break;
        }
    }
}
