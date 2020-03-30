/**
 * Compiler implementation of the D programming language
 * http://dlang.org
 *
 * Copyright: Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:   Walter Bright, http://www.digitalmars.com
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:    $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/root/имяф.d, root/_filename.d)
 * Documentation:  https://dlang.org/phobos/dmd_root_filename.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/root/имяф.d
 */

module util.filename;

import cidrus;
import util.array;
import util.file;
import util.outbuffer;
import util.port;
import util.rmem;
import util.string;

version (Posix)
{
    import core.sys.posix.stdlib;
    import core.sys.posix.sys.stat;
    import core.sys.posix.unistd : getcwd;
}

version (Windows)
{
    import sys.WinConsts;

    extern (Windows) DWORD GetFullPathNameW(LPCWSTR, DWORD, LPWSTR, LPWSTR*) ;
    extern (Windows) проц SetLastError(DWORD) ;
    extern (C) ткст0 getcwd(ткст0 буфер, т_мера maxlen) ;

    // assume filenames encoded in system default Windows ANSI code page
    private const бцел codepage = cast(бцел) ПКодСтр.ОЕМ;
}

version (CRuntime_Glibc)
{
    extern (C) ткст0 canonicalize_file_name(сим*) ;
}

alias  МассивДРК!(сим*) Strings;

/***********************************************************
 * Encapsulate path and файл имена.
 */
struct ИмяФайла
{

    private ткст str;

    ///
    static ИмяФайла opCall(ткст str) 
    {
        this.str = str.xarraydup;
    }

    /// Compare two имя according to the platform's rules (case sensitive or not)
     static бул равен(ткст0 name1, ткст0 name2)  
    {
        return равен(name1.вТкстД, name2.вТкстД);
    }

    /// Ditto
    static бул равен(ткст name1, ткст name2)  
    {
        if (name1.length != name2.length)
            return нет;

        version (Windows)
        {
            return name1.ptr == name2.ptr ||
                   util.port.Port.memicmp(name1.ptr, name2.ptr, name1.length) == 0;
        }
        else
        {
            return name1 == name2;
        }
    }

    /************************************
     * Determine if path is absolute.
     * Параметры:
     *  имя = path
     * Возвращает:
     *  да if absolute path имя.
     */
     static бул absolute(ткст0 имя)  
    {
        return absolute(имя.вТкстД);
    }

    /// Ditto
    extern (D) static бул absolute(ткст имя)  
    {
        if (!имя.length)
            return нет;

        version (Windows)
        {
            return (имя[0] == '\\') || (имя[0] == '/')
                || (имя.length >= 2 && имя[1] == ':');
        }
        else version (Posix)
        {
            return (имя[0] == '/');
        }
        else
        {
            assert(0);
        }
    }

    unittest
    {
        assert(absolute("/"[]) == да);
        assert(absolute(""[]) == нет);
    }

    /**
    Return the given имя as an absolute path

    Параметры:
        имя = path
        base = the absolute base to префикс имя with if it is relative

    Возвращает: имя as an absolute path relative to base
    */
     static ткст0 toAbsolute(ткст0 имя, ткст0 base = null)
    {
        const name_ = имя.вТкстД();
        const base_ = base ? base.вТкстД() : getcwd(null, 0).вТкстД();
        return absolute(name_) ? имя : combine(base_, name_).ptr;
    }

    /********************************
     * Determine файл имя extension as slice of input.
     * Параметры:
     *  str = файл имя
     * Возвращает:
     *  имяф extension (читай-only).
     *  Points past '.' of extension.
     *  If there isn't one, return null.
     */
     static ткст0 ext(ткст0 str)  
    {
        return ext(str.вТкстД).ptr;
    }

    /// Ditto
    extern (D) static ткст ext(ткст str) 
    {
        foreach_reverse (idx, сим e; str)
        {
            switch (e)
            {
            case '.':
                return str[idx + 1 .. $];
            version (Posix)
            {
            case '/':
                return null;
            }
            version (Windows)
            {
            case '\\':
            case ':':
            case '/':
                return null;
            }
            default:
                continue;
            }
        }
        return null;
    }

    unittest
    {
        assert(ext("/foo/bar/dmd.conf"[]) == "conf");
        assert(ext("объект.o"[]) == "o");
        assert(ext("/foo/bar/dmd"[]) == null);
        assert(ext(".objdir.o/объект"[]) == null);
        assert(ext([]) == null);
    }

     ткст0 ext() 
    {
        return ext(str).ptr;
    }

    /********************************
     * Return файл имя without extension.
     *
     * TODO:
     * Once slice are используется everywhere and `\0` is not assumed,
     * this can be turned into a simple slicing.
     *
     * Параметры:
     *  str = файл имя
     *
     * Возвращает:
     *  mem.xmalloc'd имяф with extension removed.
     */
     static ткст0 removeExt(ткст0 str)
    {
        return removeExt(str.вТкстД).ptr;
    }

    /// Ditto
    extern (D) static ткст removeExt(ткст str)
    {
        auto e = ext(str);
        if (e.length)
        {
            const len = (str.length - e.length) - 1; // -1 for the dot
            ткст0 n = cast(сим*)mem.xmalloc(len + 1);
            memcpy(n, str.ptr, len);
            n[len] = 0;
            return n[0 .. len];
        }
        return mem.xstrdup(str.ptr)[0 .. str.length];
    }

    unittest
    {
        assert(removeExt("/foo/bar/объект.d"[]) == "/foo/bar/объект");
        assert(removeExt("/foo/bar/frontend.di"[]) == "/foo/bar/frontend");
    }

    /********************************
     * Return имяф имя excluding path (читай-only).
     */
     static ткст0 имя(ткст0 str)  
    {
        return имя(str.вТкстД).ptr;
    }

    /// Ditto
    extern (D) static ткст имя(ткст str)  
    {
        foreach_reverse (idx, сим e; str)
        {
            switch (e)
            {
                version (Posix)
                {
                case '/':
                    return str[idx + 1 .. $];
                }
                version (Windows)
                {
                case '/':
                case '\\':
                    return str[idx + 1 .. $];
                case ':':
                    /* The ':' is a drive letter only if it is the second
                     * character or the last character,
                     * otherwise it is an ADS (Alternate Data Stream) separator.
                     * Consider ADS separators as part of the файл имя.
                     */
                    if (idx == 1 || idx == str.length - 1)
                        return str[idx + 1 .. $];
                    break;
                }
            default:
                break;
            }
        }
        return str;
    }

     ткст0 имя() 
    {
        return имя(str).ptr;
    }

    unittest
    {
        assert(имя("/foo/bar/объект.d"[]) == "объект.d");
        assert(имя("/foo/bar/frontend.di"[]) == "frontend.di");
    }

    /**************************************
     * Return path portion of str.
     * returned ткст is newly allocated
     * Path does not include trailing path separator.
     */
     static ткст0 path(ткст0 str)
    {
        return path(str.вТкстД).ptr;
    }

    /// Ditto
    extern (D) static ткст path(ткст str)
    {
        const n = имя(str);
        бул hasTrailingSlash;
        if (n.length < str.length)
        {
            version (Posix)
            {
                if (str[$ - n.length - 1] == '/')
                    hasTrailingSlash = да;
            }
            else version (Windows)
            {
                if (str[$ - n.length - 1] == '\\' || str[$ - n.length - 1] == '/')
                    hasTrailingSlash = да;
            }
            else
            {
                assert(0);
            }
        }
        const pathlen = str.length - n.length - (hasTrailingSlash ? 1 : 0);
        ткст0 path = cast(сим*)mem.xmalloc(pathlen + 1);
        memcpy(path, str.ptr, pathlen);
        path[pathlen] = 0;
        return path[0 .. pathlen];
    }

    unittest
    {
        assert(path("/foo/bar"[]) == "/foo");
        assert(path("foo"[]) == "");
    }

    /**************************************
     * Replace имяф portion of path.
     */
    extern (D) static ткст replaceName(ткст path, ткст имя)
    {
        if (absolute(имя))
            return имя;
        auto n = ИмяФайла.имя(path);
        if (n == path)
            return имя;
        return combine(path[0 .. $ - n.length], имя);
    }

    /**
       Combine a `path` and a файл `имя`

       Параметры:
         path = Path to приставь to
         имя = Name to приставь to path

       Возвращает:
         The `\0` terminated ткст which is the combination of `path` and `имя`
         and a valid path.
    */
     static ткст0 combine(ткст0 path, ткст0 имя)
    {
        if (!path)
            return имя;
        return combine(path.вТкстД, имя.вТкстД).ptr;
    }

    /// Ditto
    extern(D) static ткст combine(ткст path, ткст имя)
    {
        if (!path.length)
            return имя;

        ткст0 f = cast(сим*)mem.xmalloc(path.length + 1 + имя.length + 1);
        memcpy(f, path.ptr, path.length);
        бул trailingSlash = нет;
        version (Posix)
        {
            if (path[$ - 1] != '/')
            {
                f[path.length] = '/';
                trailingSlash = да;
            }
        }
        else version (Windows)
        {
            if (path[$ - 1] != '\\' && path[$ - 1] != '/' && path[$ - 1] != ':')
            {
                f[path.length] = '\\';
                trailingSlash = да;
            }
        }
        else
        {
            assert(0);
        }
        const len = path.length + trailingSlash;
        memcpy(f + len, имя.ptr, имя.length);
        // Note: At the moment `сим*` are being transitioned to
        // `ткст`. To avoid bugs crippling in, we `\0` terminate
        // slices, but don't include it in the slice so `.ptr` can be используется.
        f[len + имя.length] = '\0';
        return f[0 .. len + имя.length];
    }

    unittest
    {
        version (Windows)
            assert(combine("foo"[], "bar"[]) == "foo\\bar");
        else
            assert(combine("foo"[], "bar"[]) == "foo/bar");
        assert(combine("foo/"[], "bar"[]) == "foo/bar");
    }

    static ткст0 buildPath(ткст0 path, сим*[] имена...)
    {
        foreach (ткст0 имя; имена)
            path = combine(path, имя);
        return path;
    }

    // Split a path into an МассивДРК of paths
     static Strings* splitPath(ткст0 path)
    {
        auto массив = new Strings();
        цел sink(ткст0 p) 
        {
            массив.сунь(p);
            return 0;
        }
        splitPath(&sink, path);
        return массив;
    }

    /****
     * Split path (such as that returned by `getenv("PATH")`) into pieces, each piece is mem.xmalloc'd
     * Handle double quotes and ~.
     * Pass the pieces to sink()
     * Параметры:
     *  sink = send the path pieces here, end when sink() returns !=0
     *  path = the path to split up.
     */
    static проц splitPath(цел delegate(сим*) sink, ткст0 path)
    {
        if (path)
        {
            auto p = path;
            БуфВыв буф;
            сим c;
            do
            {
                ткст0 home;
                бул instring = нет;
                while (isspace(*p)) // skip leading whitespace
                    ++p;
                буф.резервируй(8); // guess size of piece
                for (;; ++p)
                {
                    c = *p;
                    switch (c)
                    {
                        case '"':
                            instring ^= нет; // toggle inside/outside of ткст
                            continue;

                        version (OSX)
                        {
                        case ',':
                        }
                        version (Windows)
                        {
                        case ';':
                        }
                        version (Posix)
                        {
                        case ':':
                        }
                            p++;    // ; cannot appear as part of a
                            break;  // path, quotes won't protect it

                        case 0x1A:  // ^Z means end of файл
                        case 0:
                            break;

                        case '\r':
                            continue;  // ignore carriage returns

                        version (Posix)
                        {
                        case '~':
                            if (!home)
                                home = getenv("HOME");
                            // Expand ~ only if it is prefixing the rest of the path.
                            if (!буф.length && p[1] == '/' && home)
                                буф.пишиСтр(home);
                            else
                                буф.пишиБайт('~');
                            continue;
                        }

                        version (none)
                        {
                        case ' ':
                        case '\t':         // tabs in filenames?
                            if (!instring) // if not in ткст
                                break;     // treat as end of path
                        }
                        default:
                            буф.пишиБайт(c);
                            continue;
                    }
                    break;
                }
                if (буф.length) // if path is not empty
                {
                    if (sink(буф.extractChars()))
                        break;
                }
            } while (c);
        }
    }

    /**
     * Add the extension `ext` to `имя`, regardless of the content of `имя`
     *
     * Параметры:
     *   имя = Path to приставь the extension to
     *   ext  = Extension to add (should not include '.')
     *
     * Возвращает:
     *   A newly allocated ткст (free with `ИмяФайла.free`)
     */
    extern(D) static ткст addExt(ткст имя, ткст ext) 
    {
        const len = имя.length + ext.length + 2;
        auto s = cast(сим*)mem.xmalloc(len);
        s[0 .. имя.length] = имя[];
        s[имя.length] = '.';
        s[имя.length + 1 .. len - 1] = ext[];
        s[len - 1] = '\0';
        return s[0 .. len - 1];
    }


    /***************************
     * Free returned значение with ИмяФайла::free()
     */
     static ткст0 defaultExt(ткст0 имя, ткст0 ext)
    {
        return defaultExt(имя.вТкстД, ext.вТкстД).ptr;
    }

    /// Ditto
    extern (D) static ткст defaultExt(ткст имя, ткст ext)
    {
        auto e = ИмяФайла.ext(имя);
        if (e.length) // it already has an extension
            return имя.xarraydup;
        return addExt(имя, ext);
    }

    unittest
    {
        assert(defaultExt("/foo/объект.d"[], "d") == "/foo/объект.d");
        assert(defaultExt("/foo/объект"[], "d") == "/foo/объект.d");
        assert(defaultExt("/foo/bar.d"[], "o") == "/foo/bar.d");
    }

    /***************************
     * Free returned значение with ИмяФайла::free()
     */
     static ткст0 forceExt(ткст0 имя, ткст0 ext)
    {
        return forceExt(имя.вТкстД, ext.вТкстД).ptr;
    }

    /// Ditto
    extern (D) static ткст forceExt(ткст имя, ткст ext)
    {
        if (auto e = ИмяФайла.ext(имя))
            return addExt(имя[0 .. $ - e.length - 1], ext);
        return defaultExt(имя, ext); // doesn't have one
    }

    unittest
    {
        assert(forceExt("/foo/объект.d"[], "d") == "/foo/объект.d");
        assert(forceExt("/foo/объект"[], "d") == "/foo/объект.d");
        assert(forceExt("/foo/bar.d"[], "o") == "/foo/bar.o");
    }

    /// Возвращает:
    ///   `да` if `имя`'s extension is `ext`
     static бул equalsExt(ткст0 имя, ткст0 ext)  
    {
        return equalsExt(имя.вТкстД, ext.вТкстД);
    }

    /// Ditto
    extern (D) static бул equalsExt(ткст имя, ткст ext)  
    {
        auto e = ИмяФайла.ext(имя);
        if (!e.length && !ext.length)
            return да;
        if (!e.length || !ext.length)
            return нет;
        return ИмяФайла.равен(e, ext);
    }

    unittest
    {
        assert(!equalsExt("foo.bar"[], "d"));
        assert(equalsExt("foo.bar"[], "bar"));
        assert(equalsExt("объект.d"[], "d"));
        assert(!equalsExt("объект"[], "d"));
    }

    /******************************
     * Return !=0 if extensions match.
     */
     бул equalsExt(ткст0 ext) 
    {
        return equalsExt(str, ext.вТкстД());
    }

    /*************************************
     * Search paths for файл.
     * Параметры:
     *  path = массив of path strings
     *  имя = файл to look for
     *  cwd = да means search current directory before searching path
     * Возвращает:
     *  if found, имяф combined with path, otherwise null
     */
     static ткст0 searchPath(Strings* path, ткст0 имя, бул cwd)
    {
        return searchPath(path, имя.вТкстД, cwd).ptr;
    }

    extern (D) static ткст searchPath(Strings* path, ткст имя, бул cwd)
    {
        if (absolute(имя))
        {
            return exists(имя) ? имя : null;
        }
        if (cwd)
        {
            if (exists(имя))
                return имя;
        }
        if (path)
        {
            foreach (p; *path)
            {
                auto n = combine(p.вТкстД, имя);
                if (exists(n))
                    return n;
                //combine might return имя
                if (n.ptr != имя.ptr)
                {
                    mem.xfree(cast(ук)n.ptr);
                }
            }
        }
        return null;
    }

    extern (D) static ткст searchPath(ткст0 path, ткст имя, бул cwd)
    {
        if (absolute(имя))
        {
            return exists(имя) ? имя : null;
        }
        if (cwd)
        {
            if (exists(имя))
                return имя;
        }
        if (path && *path)
        {
            ткст результат;

            цел sink(ткст0 p) 
            {
                auto n = combine(p.вТкстД, имя);
                mem.xfree(cast(ук)p);
                if (exists(n))
                {
                    результат = n;
                    return 1;   // done with splitPath() call
                }
                return 0;
            }

            splitPath(&sink, path);
            return результат;
        }
        return null;
    }

    /*************************************
     * Search Path for файл in a safe manner.
     *
     * Be wary of CWE-22: Improper Limitation of a Pathname to a Restricted Directory
     * ('Path Traversal') attacks.
     *      http://cwe.mitre.org/данные/definitions/22.html
     * More info:
     *      https://www.securecoding.cert.org/confluence/display/c/FIO02-C.+Canonicalize+path+имена+originating+from+tainted+sources
     * Возвращает:
     *      NULL    файл not found
     *      !=NULL  mem.xmalloc'd файл имя
     */
     static ткст0 safeSearchPath(Strings* path, ткст0 имя)
    {
        version (Windows)
        {
            // don't allow leading / because it might be an absolute
            // path or UNC path or something we'd prefer to just not deal with
            if (*имя == '/')
            {
                return null;
            }
            /* Disallow % \ : and .. in имя characters
             * We allow / for compatibility with subdirectories which is allowed
             * on dmd/posix. With the leading / blocked above and the rest of these
             * conservative restrictions, we should be OK.
             */
            for (ткст0 p = имя; *p; p++)
            {
                сим c = *p;
                if (c == '\\' || c == ':' || c == '%' || (c == '.' && p[1] == '.') || (c == '/' && p[1] == '/'))
                {
                    return null;
                }
            }
            return ИмяФайла.searchPath(path, имя, нет);
        }
        else version (Posix)
        {
            /* Even with realpath(), we must check for // and disallow it
             */
            for (ткст0 p = имя; *p; p++)
            {
                сим c = *p;
                if (c == '/' && p[1] == '/')
                {
                    return null;
                }
            }
            if (path)
            {
                /* Each path is converted to a cannonical имя and then a check is done to see
                 * that the searched имя is really a child one of the the paths searched.
                 */
                for (т_мера i = 0; i < path.dim; i++)
                {
                    ткст0 cname = null;
                    ткст0 cpath = canonicalName((*path)[i]);
                    //printf("ИмяФайла::safeSearchPath(): имя=%s; path=%s; cpath=%s\n",
                    //      имя, (сим *)path.данные[i], cpath);
                    if (cpath is null)
                        goto cont;
                    cname = canonicalName(combine(cpath, имя));
                    //printf("ИмяФайла::safeSearchPath(): cname=%s\n", cname);
                    if (cname is null)
                        goto cont;
                    //printf("ИмяФайла::safeSearchPath(): exists=%i "
                    //      "strncmp(cpath, cname, %i)=%i\n", exists(cname),
                    //      strlen(cpath), strncmp(cpath, cname, strlen(cpath)));
                    // exists and имя is *really* a "child" of path
                    if (exists(cname) && strncmp(cpath, cname, strlen(cpath)) == 0)
                    {
                        mem.xfree(cast(ук)cpath);
                        ткст0 p = mem.xstrdup(cname);
                        mem.xfree(cast(ук)cname);
                        return p;
                    }
                cont:
                    if (cpath)
                        mem.xfree(cast(ук)cpath);
                    if (cname)
                        mem.xfree(cast(ук)cname);
                }
            }
            return null;
        }
        else
        {
            assert(0);
        }
    }

    /**
       Check if the файл the `path` points to exists

       Возвращает:
         0 if it does not exists
         1 if it exists and is not a directory
         2 if it exists and is a directory
     */
     static цел exists(ткст0 имя)
    {
        return exists(имя.вТкстД);
    }

    /// Ditto
    extern (D) static цел exists(ткст имя)
    {
        if (!имя.length)
            return 0;
        version (Posix)
        {
            stat_t st;
            if (имя.toCStringThen!(/*(v) =>*/ stat(v.ptr, &st)) < 0)
                return 0;
            if (S_ISDIR(st.st_mode))
                return 2;
            return 1;
        }
        else version (Windows)
        {
            return имя.toCStringThen!(/*(cstr) =>*/ cstr.toWStringzThen!((wname)
            {
                const dw = GetFileAttributesW(&wname[0]);
                if (dw == -1)
                    return 0;
                else if (dw & FILE_ATTRIBUTE_DIRECTORY)
                    return 2;
                else
                    return 1;
            }));
        }
        else
        {
            assert(0);
        }
    }

    /**
       Гарант that the provided path exists

       Accepts a path to either a файл or a directory.
       In the former case, the basepath (path to the containing directory)
       will be checked for existence, and created if it does not exists.
       In the later case, the directory pointed to will be checked for existence
       and created if needed.

       Параметры:
         path = a path to a файл or a directory

       Возвращает:
         `да` if the directory exists or was successfully created
     */
    extern (D) static бул ensurePathExists(ткст path)
    {
        //printf("ИмяФайла::ensurePathExists(%s)\n", path ? path : "");
        if (!path.length)
            return да;
        if (exists(path))
            return да;

        // We were provided with a файл имя
        // We need to call ourselves recursively to ensure родитель dir exist
        const ткст p = ИмяФайла.path(path);
        if (p.length)
        {
            version (Windows)
            {
                // Note: Windows имяф comparison should be case-insensitive,
                // however p is a subslice of path so we don't need it
                if (path.length == p.length ||
                    (path.length > 2 && path[1] == ':' && path[2 .. $] == p))
                {
                    mem.xfree(cast(ук)p.ptr);
                    return да;
                }
            }
            const r = ensurePathExists(p);
            mem.xfree(cast(ук)p);

            if (!r)
                return r;
        }

        version (Windows)
            const r = _mkdir(path);
        version (Posix)
        {
            errno = 0;
            const r = path.toCStringThen!(/*(pathCS) =>*/ mkdir(pathCS.ptr, (7 << 6) | (7 << 3) | 7));
        }

        if (r == 0)
            return да;

        // Don't error out if another instance of dmd just created
        // this directory
        version (Windows)
        {
           // import win32.winerror : ERROR_ALREADY_EXISTS;
            if (GetLastError() == ERROR_ALREADY_EXISTS)
                return да;
        }
        version (Posix)
        {
            if (errno == EEXIST)
                return да;
        }

        return нет;
    }

    ///ditto
     static бул ensurePathExists(ткст0 path)
    {
        return ensurePathExists(path.вТкстД);
    }

    /******************************************
     * Return canonical version of имя in a malloc'd буфер.
     * This code is high risk.
     */
     static ткст0 canonicalName(ткст0 имя)
    {
        return canonicalName(имя.вТкстД).ptr;
    }

    /// Ditto
    extern (D) static ткст canonicalName(ткст имя)
    {
        version (Posix)
        {
          //  import core.stdc.limits;      // PATH_MAX
          //  import core.sys.posix.unistd; // _PC_PATH_MAX

            // Older versions of druntime don't have PATH_MAX defined.
            // i.e: dmd __VERSION__ < 2085, gdc __VERSION__ < 2076.
          //  static if (!__traits(compiles, PATH_MAX))
          //  {
                version (DragonFlyBSD)
                    const PATH_MAX = 1024;
                else version (FreeBSD)
                    const PATH_MAX = 1024;
                else version (linux)
                    const PATH_MAX = 4096;
                else version (NetBSD)
                    const PATH_MAX = 1024;
                else version (OpenBSD)
                    const PATH_MAX = 1024;
                else version (OSX)
                    const PATH_MAX = 1024;
                else version (Solaris)
                    const PATH_MAX = 1024;
           // }

            // Have realpath(), passing a NULL destination pointer may return an
            // internally malloc'd буфер, however it is implementation defined
            // as to what happens, so cannot rely on it.
            static if (__traits(compiles, PATH_MAX))
            {
                // Have compile time limit on filesystem path, use it with realpath.
                сим[PATH_MAX] буф = проц;
                auto path = имя.toCStringThen!(/*(n) =>*/ realpath(n.ptr, буф.ptr));
                if (path !is null)
                    return mem.xstrdup(path).вТкстД;
            }
            else static if (__traits(compiles, canonicalize_file_name))
            {
                // Have canonicalize_file_name, which malloc's memory.
                auto path = имя.toCStringThen!(/*(n) =>*/ canonicalize_file_name(n.ptr));
                if (path !is null)
                    return path.вТкстД;
            }
            else static if (__traits(compiles, _PC_PATH_MAX))
            {
                // Panic! Query the OS for the буфер limit.
                auto path_max = pathconf("/", _PC_PATH_MAX);
                if (path_max > 0)
                {
                    сим *буф = cast(сим*)mem.xmalloc(path_max);
                    scope(exit) mem.xfree(буф);
                    auto path = имя.toCStringThen!(/*(n) =>*/ realpath(n.ptr, буф));
                    if (path !is null)
                        return mem.xstrdup(path).вТкстД;
                }
            }
            // Give up trying to support this platform, just duplicate the имяф
            // unless there is nothing to копируй from.
            if (!имя.length)
                return null;
            return mem.xstrdup(имя.ptr)[0 .. имя.length];
        }
        else version (Windows)
        {
            // Convert to wstring first since otherwise the Win32 APIs have a character limit
            return имя.toWStringzThen!((wname)
            {
                /* Apparently, there is no good way to do this on Windows.
                 * GetFullPathName isn't it, but use it anyway.
                 */
                // First найди out how long the буфер has to be.
                const fullPathLength = GetFullPathNameW(&wname[0], 0, null, null);
                if (!fullPathLength) return null;
                auto fullPath = new wchar[fullPathLength];

                // Actually get the full path имя
                const fullPathLengthNoTerminator = GetFullPathNameW(
                    &wname[0], fullPathLength, &fullPath[0], null /*filePart*/);
                // Unfortunately, when the буфер is large enough the return значение is the number of characters
                // _not_ counting the null terminator, so fullPathLengthNoTerminator should be smaller
                assert(fullPathLength > fullPathLengthNoTerminator);

                // Find out size of the converted ткст
                const retLength = WideCharToMultiByte(
                    codepage, 0 /*flags*/, &fullPath[0], fullPathLength, null, 0, null, null);
                auto ret = new сим[retLength];

                // Actually convert to сим
                const retLength2 = WideCharToMultiByte(
                    codepage, 0 /*flags*/, &fullPath[0], fullPathLength, &ret[0], retLength, null, null);
                assert(retLength == retLength2);

                return ret;
            });
        }
        else
        {
            assert(0);
        }
    }

    /********************************
     * Free memory allocated by ИмяФайла routines
     */
     static проц free(ткст0 str) 
    {
        if (str)
        {
            assert(str[0] != cast(сим)0xAB);
            memset(cast(ук)str, 0xAB, strlen(str) + 1); // stomp
        }
        mem.xfree(cast(ук)str);
    }

     ткст0 вТкст0() 
    {
        // Since we can return an empty slice (but '\0' terminated),
        // we don't do bounds check (as `&str[0]` does)
        return str.ptr;
    }

    ткст вТкст() 
    {
        return str;
    }

    бул opCast(T)()
	{
        if (is(T == бул))
        {
            return str.ptr !is null;
        }
	}
}

version(Windows)
{
    /****************************************************************
     * The code before используется the POSIX function `mkdir` on Windows. That
     * function is now deprecated and fails with long paths, so instead
     * we use the newer `CreateDirectoryW`.
     *
     * `CreateDirectoryW` is the unicode version of the generic macro
     * `CreateDirectory`.  `CreateDirectoryA` has a файл path
     *  limitation of 248 characters, `mkdir` fails with less and might
     *  fail due to the number of consecutive `..`s in the
     *  path. `CreateDirectoryW` also normally has a 248 character
     * limit, unless the path is absolute and starts with `\\?\`. Note
     * that this is different from starting with the almost identical
     * `\\?`.
     *
     * Параметры:
     *  path = The path to создай.
     *
     * Возвращает:
     *  0 on успех, 1 on failure.
     *
     * References:
     *  https://msdn.microsoft.com/en-us/library/windows/desktop/aa363855(v=vs.85).aspx
     */
    private цел _mkdir(ткст path) 
    {
        const createRet = path.extendedPathThen!(
            /*p =>*/ CreateDirectoryW(&p[0], null /*securityAttributes*/));
        // different conventions for CreateDirectory and mkdir
        return createRet == 0 ? 1 : 0;
    }

    /**************************************
     * Converts a path to one suitable to be passed to Win32 API
     * functions that can deal with paths longer than 248
     * characters then calls the supplied function on it.
     *
     * Параметры:
     *  path = The Path to call F on.
     *
     * Возвращает:
     *  The результат of calling F on path.
     *
     * References:
     *  https://msdn.microsoft.com/en-us/library/windows/desktop/aa365247(v=vs.85).aspx
     */
    package F extendedPathThen(alias F)(ткст path)
    {
        if (!path.length)
            return F((wткст).init);
        return path.toWStringzThen!((wpath)
        {
            // GetFullPathNameW expects a sized буфер to store the результат in. Since we don't
            // know how large it has to be, we pass in null and get the needed буфер length
            // as the return code.
            const pathLength = GetFullPathNameW(&wpath[0],
                                                0 /*length8*/,
                                                null /*output буфер*/,
                                                null /*filePartBuffer*/);
            if (pathLength == 0)
            {
                return F((wткст).init);
            }

            // wpath is the UTF16 version of path, but to be able to use
            // extended paths, we need to префикс with `\\?\` and the absolute
            // path.
            static const префикс = `\\?\`w;

            // префикс only needed for long имена and non-UNC имена
            const needsPrefix = pathLength >= MAX_PATH && (wpath[0] != '\\' || wpath[1] != '\\');
            const prefixLength = needsPrefix ? префикс.length : 0;

            // +1 for the null terminator
            const bufferLength = pathLength + prefixLength + 1;

            wchar[1024] absBuf = проц;
            wткст absPath = bufferLength > absBuf.length
                ? new wchar[bufferLength] : absBuf[0 .. bufferLength];

            absPath[0 .. prefixLength] = префикс[0 .. prefixLength];

            const absPathRet = GetFullPathNameW(&wpath[0],
                cast(бцел)(absPath.length - prefixLength - 1),
                &absPath[prefixLength],
                null /*filePartBuffer*/);

            if (absPathRet == 0 || absPathRet > absPath.length - prefixLength)
            {
                return F((wткст).init);
            }

            absPath[$ - 1] = '\0';
            // Strip null terminator from the slice
            return F(absPath[0 .. $ - 1]);
        });
    }

    /**********************************
     * Converts a slice of UTF-8 characters to an массив of wchar that's null
     * terminated so it can be passed to Win32 APIs then calls the supplied
     * function on it.
     *
     * Параметры:
     *  str = The ткст to convert.
     *
     * Возвращает:
     *  The результат of calling F on the UTF16 version of str.
     */
    private F toWStringzThen(alias F)(ткст str) 
    {
        if (!str.length) return F(""w.ptr);

      //  import core.stdc.stdlib: malloc, free;
        wchar[1024] буф = проц;

        // first найди out how long the буфер must be to store the результат
        const length = MultiByteToWideChar(codepage, 0 /*flags*/, &str[0], cast(цел)str.length, null, 0);
        if (!length) return F(""w);

        wткст ret = length >= буф.length
            ? (cast(wchar*)malloc((length + 1) * wchar.sizeof))[0 .. length + 1]
            : буф[0 .. length + 1];
        scope (exit)
        {
            if (&ret[0] != &буф[0])
                free(&ret[0]);
        }
        // actually do the conversion
        const length2 = MultiByteToWideChar(
            codepage, 0 /*flags*/, &str[0], cast(цел)str.length, &ret[0], length);
        assert(length == length2); // should always be да according to the API
        // Add terminating `\0`
        ret[$ - 1] = '\0';

        return F(ret[0 .. $ - 1]);
    }
}
