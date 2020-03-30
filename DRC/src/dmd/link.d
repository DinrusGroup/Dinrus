/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/link.d, _link.d)
 * Documentation:  https://dlang.org/phobos/dmd_link.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/link.d
 */

module dmd.link;

import cidrus;
version(Posix)
{
import core.sys.posix.stdio;
import core.sys.posix.stdlib;
import core.sys.posix.unistd;
}
else version(Windows)
{
//import win32.winbase;
//import win32.windef;
//import win32.winreg;
}
import util.env;
import dmd.errors;
import dmd.globals;
import util.file;
import util.filename;
import util.outbuffer;
import util.rmem;
import util.string;
import util.utils;

version (Posix) extern (C) цел pipe(цел*);
version (Windows) extern (C) цел spawnlp(цел,  сим*,  сим*,  сим*,  сим*);
version (Windows) extern (C) цел spawnl(цел,  сим*,  сим*,  сим*,  сим*);
version (Windows) extern (C) цел spawnv(цел,  сим*,  сим**);
version (CRuntime_Microsoft)
{
  // until the new windows bindings are доступно when building dmd.
  static if(!is(STARTUPINFOA))
  {
    alias STARTUPINFO STARTUPINFOA;

    // dwCreationFlags for CreateProcess() and CreateProcessAsUser()
    enum : DWORD {
      DEBUG_PROCESS               = 0x00000001,
      DEBUG_ONLY_THIS_PROCESS     = 0x00000002,
      CREATE_SUSPENDED            = 0x00000004,
      DETACHED_PROCESS            = 0x00000008,
      CREATE_NEW_CONSOLE          = 0x00000010,
      NORMAL_PRIORITY_CLASS       = 0x00000020,
      IDLE_PRIORITY_CLASS         = 0x00000040,
      HIGH_PRIORITY_CLASS         = 0x00000080,
      REALTIME_PRIORITY_CLASS     = 0x00000100,
      CREATE_NEW_PROCESS_GROUP    = 0x00000200,
      CREATE_UNICODE_ENVIRONMENT  = 0x00000400,
      CREATE_SEPARATE_WOW_VDM     = 0x00000800,
      CREATE_SHARED_WOW_VDM       = 0x00001000,
      CREATE_FORCEDOS             = 0x00002000,
      BELOW_NORMAL_PRIORITY_CLASS = 0x00004000,
      ABOVE_NORMAL_PRIORITY_CLASS = 0x00008000,
      CREATE_BREAKAWAY_FROM_JOB   = 0x01000000,
      CREATE_WITH_USERPROFILE     = 0x02000000,
      CREATE_DEFAULT_ERROR_MODE   = 0x04000000,
      CREATE_NO_WINDOW            = 0x08000000,
      PROFILE_USER                = 0x10000000,
      PROFILE_KERNEL              = 0x20000000,
      PROFILE_SERVER              = 0x40000000
    }
  }
}

/****************************************
 * Write имяф to cmdbuf, quoting if necessary.
 */
private проц writeFilename(БуфВыв* буф, ткст имяф)
{
    /* Loop and see if we need to quote
     */
    foreach ( сим c; имяф)
    {
        if (isalnum(c) || c == '_')
            continue;
        /* Need to quote
         */
        буф.пишиБайт('"');
        буф.пишиСтр(имяф);
        буф.пишиБайт('"');
        return;
    }
    /* No quoting necessary
     */
    буф.пишиСтр(имяф);
}

private проц writeFilename(БуфВыв* буф, ткст0 имяф)
{
    writeFilename(буф, имяф.вТкстД());
}

version (Posix)
{
    /*****************************
     * As it forwards the linker error message to stderr, checks for the presence
     * of an error indicating lack of a main function (NME_ERR_MSG).
     *
     * Возвращает:
     *      1 if there is a no main error
     *     -1 if there is an IO error
     *      0 otherwise
     */
    private цел findNoMainError(цел fd)
    {
        version (OSX)
        {
            static ткст0 nmeErrorMessage = "`__Dmain`, referenced from:";
        }
        else
        {
            static ткст0 nmeErrorMessage = "undefined reference to `_Dmain`";
        }
        FILE* stream = fdopen(fd, "r");
        if (stream is null)
            return -1;
        т_мера len = 64 * 1024 - 1;
        сим[len + 1] буфер; // + '\0'
        т_мера beg = 0, end = len;
        бул nmeFound = нет;
        for (;;)
        {
            // читай linker output
            т_мера n = fread(&буфер[beg], 1, len - beg, stream);
            if (beg + n < len && ferror(stream))
                return -1;
            буфер[(end = beg + n)] = '\0';
            // search error message, stop at last complete line
            ткст0 lastSep = strrchr(буфер.ptr, '\n');
            if (lastSep)
                буфер[(end = lastSep - &буфер[0])] = '\0';
            if (strstr(&буфер[0], nmeErrorMessage))
                nmeFound = да;
            if (lastSep)
                буфер[end++] = '\n';
            if (fwrite(&буфер[0], 1, end, stderr) < end)
                return -1;
            if (beg + n < len && feof(stream))
                break;
            // копируй over truncated last line
            memcpy(&буфер[0], &буфер[end], (beg = len - end));
        }
        return nmeFound ? 1 : 0;
    }
}

version (Windows)
{
    private проц writeQuotedArgIfNeeded(ref БуфВыв буфер, ткст0 arg)
    {
        бул quote = нет;
        for (т_мера i = 0; arg[i]; ++i)
        {
            if (arg[i] == '"')
            {
                quote = нет;
                break;
            }

            if (arg[i] == ' ')
                quote = да;
        }

        if (quote)
            буфер.пишиБайт('"');
        буфер.пишиСтр(arg);
        if (quote)
            буфер.пишиБайт('"');
    }

    unittest
    {
        БуфВыв буфер;

        ткст test(ткст arg)
        {
            буфер.сбрось();
            буфер.writeQuotedArgIfNeeded(arg.ptr);
            return буфер[];
        }

        assert(test("arg") == `arg`);
        assert(test("arg with spaces") == `"arg with spaces"`);
        assert(test(`"/LIBPATH:dir with spaces"`) == `"/LIBPATH:dir with spaces"`);
        assert(test(`/LIBPATH:"dir with spaces"`) == `/LIBPATH:"dir with spaces"`);
    }
}

/*****************************
 * Run the linker.  Return status of execution.
 */
public цел runLINK()
{
    const phobosLibname = глоб2.finalDefaultlibname();

    проц setExeFile()
    {
        /* Generate exe файл имя from first obj имя.
         * No need to add it to cmdbuf because the linker will default to it.
         */
        const ткст n = ИмяФайла.имя(глоб2.парамы.objfiles[0].вТкстД);
        глоб2.парамы.exefile = ИмяФайла.forceExt(n, "exe");
    }

    ткст getMapFilename()
    {
        ткст fn = ИмяФайла.forceExt(глоб2.парамы.exefile, "map");
        ткст path = ИмяФайла.path(глоб2.парамы.exefile);
        return path.length ? fn : ИмяФайла.combine(глоб2.парамы.objdir, fn);
    }

    version (Windows)
    {
        if (phobosLibname)
            глоб2.парамы.libfiles.сунь(phobosLibname.xarraydup.ptr);

        if (глоб2.парамы.mscoff)
        {
            БуфВыв cmdbuf;
            cmdbuf.пишиСтр("/NOLOGO");
            for (т_мера i = 0; i < глоб2.парамы.objfiles.length; i++)
            {
                cmdbuf.пишиБайт(' ');
                ткст0 p = глоб2.парамы.objfiles[i];
                writeFilename(&cmdbuf, p);
            }
            if (глоб2.парамы.resfile)
            {
                cmdbuf.пишиБайт(' ');
                writeFilename(&cmdbuf, глоб2.парамы.resfile);
            }
            cmdbuf.пишиБайт(' ');
            if (глоб2.парамы.exefile)
            {
                cmdbuf.пишиСтр("/OUT:");
                writeFilename(&cmdbuf, глоб2.парамы.exefile);
            }
            else
            {
                setExeFile();
            }
            // Make sure path to exe файл exists
            ensurePathToNameExists(Место.initial, глоб2.парамы.exefile);
            cmdbuf.пишиБайт(' ');
            if (глоб2.парамы.mapfile)
            {
                cmdbuf.пишиСтр("/MAP:");
                writeFilename(&cmdbuf, глоб2.парамы.mapfile);
            }
            else if (глоб2.парамы.map)
            {
                cmdbuf.пишиСтр("/MAP:");
                writeFilename(&cmdbuf, getMapFilename());
            }
            for (т_мера i = 0; i < глоб2.парамы.libfiles.length; i++)
            {
                cmdbuf.пишиБайт(' ');
                cmdbuf.пишиСтр("/DEFAULTLIB:");
                writeFilename(&cmdbuf, глоб2.парамы.libfiles[i]);
            }
            if (глоб2.парамы.deffile)
            {
                cmdbuf.пишиБайт(' ');
                cmdbuf.пишиСтр("/DEF:");
                writeFilename(&cmdbuf, глоб2.парамы.deffile);
            }
            if (глоб2.парамы.symdebug)
            {
                cmdbuf.пишиБайт(' ');
                cmdbuf.пишиСтр("/DEBUG");
                // in release mode we need to reactivate /OPT:REF after /DEBUG
                if (глоб2.парамы.release)
                    cmdbuf.пишиСтр(" /OPT:REF");
            }
            if (глоб2.парамы.dll)
            {
                cmdbuf.пишиБайт(' ');
                cmdbuf.пишиСтр("/DLL");
            }
            for (т_мера i = 0; i < глоб2.парамы.linkswitches.length; i++)
            {
                cmdbuf.пишиБайт(' ');
                cmdbuf.writeQuotedArgIfNeeded(глоб2.парамы.linkswitches[i]);
            }

            VSOptions vsopt;
            // if a runtime library (msvcrtNNN.lib) from the mingw folder is selected explicitly, do not detect VS and use lld
            if (глоб2.парамы.mscrtlib.length <= 6 ||
                глоб2.парамы.mscrtlib[0..6] != "msvcrt" || !isdigit(глоб2.парамы.mscrtlib[6]))
                vsopt.initialize();

            ткст0 lflags = vsopt.linkOptions(глоб2.парамы.is64bit);
            if (lflags)
            {
                cmdbuf.пишиБайт(' ');
                cmdbuf.пишиСтр(lflags);
            }

            ткст0 linkcmd = getenv(глоб2.парамы.is64bit ? "LINKCMD64" : "LINKCMD");
            if (!linkcmd)
                linkcmd = getenv("LINKCMD"); // backward compatible
            if (!linkcmd)
                linkcmd = vsopt.linkerPath(глоб2.парамы.is64bit);

            // объект files not SAFESEH compliant, but LLD is more picky than MS link
            if (!глоб2.парамы.is64bit)
                if (ИмяФайла.равен(ИмяФайла.имя(linkcmd), "lld-link.exe"))
                    cmdbuf.пишиСтр(" /SAFESEH:NO");

            cmdbuf.пишиБайт(0); // null terminate the буфер
            ткст p = cmdbuf.извлекиСрез()[0 .. $-1];
            ткст lnkfilename;
            if (p.length > 7000)
            {
                lnkfilename = ИмяФайла.forceExt(глоб2.парамы.exefile, "lnk");
                writeFile(Место.initial, lnkfilename, p);
                if (lnkfilename.length < p.length)
                {
                    p[0] = '@';
                    p[1 ..  lnkfilename.length +1] = lnkfilename;
                    p[lnkfilename.length +1] = 0;
                }
            }

            const цел status = executecmd(linkcmd, p.ptr);
            if (lnkfilename)
            {
                lnkfilename.toCStringThen!(/*lf =>*/ удали(lf.ptr));
                ИмяФайла.free(lnkfilename.ptr);
            }
            return status;
        }
        else
        {
            БуфВыв cmdbuf;
            глоб2.парамы.libfiles.сунь("user32");
            глоб2.парамы.libfiles.сунь("kernel32");
            for (т_мера i = 0; i < глоб2.парамы.objfiles.length; i++)
            {
                if (i)
                    cmdbuf.пишиБайт('+');
                ткст0 p = глоб2.парамы.objfiles[i];
                ткст0 basename = ИмяФайла.removeExt(ИмяФайла.имя(p));
                ткст0 ext = ИмяФайла.ext(p);
                if (ext && !strchr(basename, '.'))
                {
                    // Write имя sans extension (but not if a double extension)
                    writeFilename(&cmdbuf, p[0 .. ext - p - 1]);
                }
                else
                    writeFilename(&cmdbuf, p);
                ИмяФайла.free(basename);
            }
            cmdbuf.пишиБайт(',');
            if (глоб2.парамы.exefile)
                writeFilename(&cmdbuf, глоб2.парамы.exefile);
            else
            {
                setExeFile();
            }
            // Make sure path to exe файл exists
            ensurePathToNameExists(Место.initial, глоб2.парамы.exefile);
            cmdbuf.пишиБайт(',');
            if (глоб2.парамы.mapfile)
                writeFilename(&cmdbuf, глоб2.парамы.mapfile);
            else if (глоб2.парамы.map)
            {
                writeFilename(&cmdbuf, getMapFilename());
            }
            else
                cmdbuf.пишиСтр("nul");
            cmdbuf.пишиБайт(',');
            for (т_мера i = 0; i < глоб2.парамы.libfiles.length; i++)
            {
                if (i)
                    cmdbuf.пишиБайт('+');
                writeFilename(&cmdbuf, глоб2.парамы.libfiles[i]);
            }
            if (глоб2.парамы.deffile)
            {
                cmdbuf.пишиБайт(',');
                writeFilename(&cmdbuf, глоб2.парамы.deffile);
            }
            /* Eliminate unnecessary trailing commas    */
            while (1)
            {
                const т_мера i = cmdbuf.length;
                if (!i || cmdbuf[i - 1] != ',')
                    break;
                cmdbuf.устРазм(cmdbuf.length - 1);
            }
            if (глоб2.парамы.resfile)
            {
                cmdbuf.пишиСтр("/RC:");
                writeFilename(&cmdbuf, глоб2.парамы.resfile);
            }
            if (глоб2.парамы.map || глоб2.парамы.mapfile)
                cmdbuf.пишиСтр("/m");
            version (none)
            {
                if (debuginfo)
                    cmdbuf.пишиСтр("/li");
                if (codeview)
                {
                    cmdbuf.пишиСтр("/co");
                    if (codeview3)
                        cmdbuf.пишиСтр(":3");
                }
            }
            else
            {
                if (глоб2.парамы.symdebug)
                    cmdbuf.пишиСтр("/co");
            }
            cmdbuf.пишиСтр("/noi");
            for (т_мера i = 0; i < глоб2.парамы.linkswitches.length; i++)
            {
                cmdbuf.пишиСтр(глоб2.парамы.linkswitches[i]);
            }
            cmdbuf.пишиБайт(';');
            cmdbuf.пишиБайт(0); //null terminate the буфер
            ткст p = cmdbuf.извлекиСрез()[0 .. $-1];
            ткст lnkfilename;
            if (p.length > 7000)
            {
                lnkfilename = ИмяФайла.forceExt(глоб2.парамы.exefile, "lnk");
                writeFile(Место.initial, lnkfilename, p);
                if (lnkfilename.length < p.length)
                {
                    p[0] = '@';
                    p[1 .. lnkfilename.length +1] = lnkfilename;
                    p[lnkfilename.length +1] = 0;
                }
            }
            ткст0 linkcmd = getenv("LINKCMD");
            if (!linkcmd)
                linkcmd = "optlink";
            const цел status = executecmd(linkcmd, p.ptr);
            if (lnkfilename)
            {
                lnkfilename.toCStringThen!(/*lf =>*/ удали(lf.ptr));
                ИмяФайла.free(lnkfilename.ptr);
            }
            return status;
        }
    }
    else version (Posix)
    {
        pid_t childpid;
        цел status;
        // Build argv[]
        Strings argv;
        ткст0 cc = getenv("CC");
        if (!cc)
        {
            argv.сунь("cc");
        }
        else
        {
            // Split CC command to support link driver arguments such as -fpie or -flto.
            ткст0 arg = cast(сим*)Пам.check(strdup(cc));
            ткст0 tok = strtok(arg, " ");
            while (tok)
            {
                argv.сунь(mem.xstrdup(tok));
                tok = strtok(null, " ");
            }
            free(arg);
        }
        argv.приставь(&глоб2.парамы.objfiles);
        version (OSX)
        {
            // If we are on Mac OS X and linking a dynamic library,
            // add the "-dynamiclib" флаг
            if (глоб2.парамы.dll)
                argv.сунь("-dynamiclib");
        }
        else version (Posix)
        {
            if (глоб2.парамы.dll)
                argv.сунь("-shared");
        }
        // None of that a.out stuff. Use explicit exe файл имя, or
        // generate one from имя of first source файл.
        argv.сунь("-o");
        if (глоб2.парамы.exefile)
        {
            argv.сунь(глоб2.парамы.exefile.xarraydup.ptr);
        }
        else if (глоб2.парамы.run)
        {
            version (all)
            {
                сим[L_tmpnam + 14 + 1] имя;
                strcpy(имя.ptr, P_tmpdir);
                strcat(имя.ptr, "/dmd_runXXXXXX");
                цел fd = mkstemp(имя.ptr);
                if (fd == -1)
                {
                    выведиОшибку(Место.initial, "error creating temporary файл");
                    return 1;
                }
                else
                    close(fd);
                глоб2.парамы.exefile = имя.arraydup;
                argv.сунь(глоб2.парамы.exefile.xarraydup.ptr);
            }
            else
            {
                /* The use of tmpnam raises the issue of "is this a security hole"?
                 * The hole is that after tmpnam and before the файл is opened,
                 * the attacker modifies the файл system to get control of the
                 * файл with that имя. I do not know if this is an issue in
                 * this context.
                 * We cannot just replace it with mkstemp, because this имя is
                 * passed to the linker that actually opens the файл and writes to it.
                 */
                сим[L_tmpnam + 1] s;
                ткст0 n = tmpnam(s.ptr);
                глоб2.парамы.exefile = mem.xstrdup(n);
                argv.сунь(глоб2.парамы.exefile);
            }
        }
        else
        {
            // Generate exe файл имя from first obj имя
            ткст n = глоб2.парамы.objfiles[0].вТкстД();
            ткст ex;
            n = ИмяФайла.имя(n);
            if (auto e = ИмяФайла.ext(n))
            {
                if (глоб2.парамы.dll)
                    ex = ИмяФайла.forceExt(ex, глоб2.dll_ext);
                else
                    ex = ИмяФайла.removeExt(n);
            }
            else
                ex = "a.out"; // no extension, so give up
            argv.сунь(ex.ptr);
            глоб2.парамы.exefile = ex;
        }
        // Make sure path to exe файл exists
        ensurePathToNameExists(Место.initial, глоб2.парамы.exefile);
        if (глоб2.парамы.symdebug)
            argv.сунь("-g");
        if (глоб2.парамы.is64bit)
            argv.сунь("-m64");
        else
            argv.сунь("-m32");
        version (OSX)
        {
            /* Without this switch, ld generates messages of the form:
             * ld: warning: could not создай compact unwind for __Dmain: смещение of saved registers too far to encode
             * meaning they are further than 255 bytes from the frame register.
             * ld reverts to the old method instead.
             * See: https://ghc.haskell.org/trac/ghc/ticket/5019
             * which gives this tidbit:
             * "When a C++ (or x86_64 Objective-C) exception is thrown, the runtime must unwind the
             *  stack looking for some function to catch the exception.  Traditionally, the unwind
             *  information is stored in the __TEXT/__eh_frame section of each executable as Dwarf
             *  CFI (call frame information).  Beginning in Mac OS X 10.6, the unwind information is
             *  also encoded in the __TEXT/__unwind_info section using a two-уровень lookup table of
             *  compact unwind encodings.
             *  The unwinddump tool displays the content of the __TEXT/__unwind_info section."
             *
             * A better fix would be to save the registers следщ to the frame pointer.
             */
            argv.сунь("-Xlinker");
            argv.сунь("-no_compact_unwind");
        }
        if (глоб2.парамы.map || глоб2.парамы.mapfile.length)
        {
            argv.сунь("-Xlinker");
            version (OSX)
            {
                argv.сунь("-map");
            }
            else
            {
                argv.сунь("-Map");
            }
            if (!глоб2.парамы.mapfile.length)
            {
                ткст fn = ИмяФайла.forceExt(глоб2.парамы.exefile, "map");
                ткст path = ИмяФайла.path(глоб2.парамы.exefile);
                глоб2.парамы.mapfile = path.length ? fn : ИмяФайла.combine(глоб2.парамы.objdir, fn);
            }
            argv.сунь("-Xlinker");
            argv.сунь(глоб2.парамы.mapfile.xarraydup.ptr);
        }
        if (0 && глоб2.парамы.exefile)
        {
            /* This switch enables what is known as 'smart linking'
             * in the Windows world, where unreferenced sections
             * are removed from the executable. It eliminates unreferenced
             * functions, essentially making a 'library' out of a module.
             * Although it is documented to work with ld version 2.13,
             * in practice it does not, but just seems to be ignored.
             * Thomas Kuehne has verified that it works with ld 2.16.1.
             * BUG: disabled because it causes exception handling to fail
             * because EH sections are "unreferenced" and elided
             */
            argv.сунь("-Xlinker");
            argv.сунь("--gc-sections");
        }

        /**
        Checks if C ткст `p` starts with `needle`.
        Параметры:
            p = the C ткст to check
            needle = the ткст to look for
        Возвращает
            `да` if `p` starts with `needle`
        */
        static бул startsWith(ткст0 p, ткст needle)
        {
            const f = p.вТкстД();
            return f.length >= needle.length && f[0 .. needle.length] == needle;
        }

        // return да if flagp should be ordered in with the library flags
        static бул flagIsLibraryRelated(ткст0 p)
        {
            const флаг = p.вТкстД();

            return startsWith(p, "-l") || startsWith(p, "-L")
                || флаг == "-(" || флаг == "-)"
                || флаг == "--start-group" || флаг == "--end-group"
                || ИмяФайла.equalsExt(p, "a")
            ;
        }

        /* Add libraries. The order of libraries passed is:
         *  1. link switches without a -L префикс,
               e.g. --whole-archive "lib.a" --no-whole-archive     (глоб2.парамы.linkswitches)
         *  2. static libraries ending with *.a     (глоб2.парамы.libfiles)
         *  3. link switches with a -L префикс  (глоб2.парамы.linkswitches)
         *  4. libraries specified by pragma(lib), which were appended
         *     to глоб2.парамы.libfiles. These are prefixed with "-l"
         *  5. dynamic libraries passed to the command line (глоб2.парамы.dllfiles)
         *  6. standard libraries.
         */

        // STEP 1
        foreach (pi, p; глоб2.парамы.linkswitches)
        {
            if (p && p[0] && !flagIsLibraryRelated(p))
            {
                if (!глоб2.парамы.linkswitchIsForCC[pi])
                    argv.сунь("-Xlinker");
                argv.сунь(p);
            }
        }

        // STEP 2
        foreach (p; глоб2.парамы.libfiles)
        {
            if (ИмяФайла.equalsExt(p, "a"))
                argv.сунь(p);
        }

        // STEP 3
        foreach (pi, p; глоб2.парамы.linkswitches)
        {
            if (p && p[0] && flagIsLibraryRelated(p))
            {
                if (!startsWith(p, "-l") && !startsWith(p, "-L") && !глоб2.парамы.linkswitchIsForCC[pi])
                {
                    // Don't need -Xlinker if switch starts with -l or -L.
                    // Eliding -Xlinker is significant for -L since it allows our paths
                    // to take precedence over gcc defaults.
                    // All other link switches were already added in step 1.
                    argv.сунь("-Xlinker");
                }
                argv.сунь(p);
            }
        }

        // STEP 4
        foreach (p; глоб2.парамы.libfiles)
        {
            if (!ИмяФайла.equalsExt(p, "a"))
            {
                const plen = strlen(p);
                ткст0 s = cast(сим*)mem.xmalloc(plen + 3);
                s[0] = '-';
                s[1] = 'l';
                memcpy(s + 2, p, plen + 1);
                argv.сунь(s);
            }
        }

        // STEP 5
        foreach (p; глоб2.парамы.dllfiles)
        {
            argv.сунь(p);
        }

        // STEP 6
        /* D runtime libraries must go after user specified libraries
         * passed with -l.
         */
        const libname = phobosLibname;
        if (libname.length)
        {
            const bufsize = 2 + libname.length + 1;
            auto буф = (cast(сим*) malloc(bufsize))[0 .. bufsize];
            if (!буф)
                Пам.выведиОшибку();
            буф[0 .. 2] = "-l";

            ткст0 getbuf(ткст suffix)
            {
                буф[2 .. 2 + suffix.length] = suffix[];
                буф[2 + suffix.length] = 0;
                return буф.ptr;
            }

            if (libname.length > 3 + 2 && libname[0 .. 3] == "lib")
            {
                if (libname[$-2 .. $] == ".a")
                {
                    argv.сунь("-Xlinker");
                    argv.сунь("-Bstatic");
                    argv.сунь(getbuf(libname[3 .. $-2]));
                    argv.сунь("-Xlinker");
                    argv.сунь("-Bdynamic");
                }
                else if (libname[$-3 .. $] == ".so")
                    argv.сунь(getbuf(libname[3 .. $-3]));
                else
                    argv.сунь(getbuf(libname));
            }
            else
            {
                argv.сунь(getbuf(libname));
            }
        }
        //argv.сунь("-ldruntime");
        argv.сунь("-lpthread");
        argv.сунь("-lm");
        version (linux)
        {
            // Changes in ld for Ubuntu 11.10 require this to appear after phobos2
            argv.сунь("-lrt");
            // Link against libdl for phobos использование of dlopen
            argv.сунь("-ldl");
        }
        if (глоб2.парамы.verbose)
        {
            // Print it
            БуфВыв буф;
            for (т_мера i = 0; i < argv.dim; i++)
            {
                буф.пишиСтр(argv[i]);
                буф.пишиБайт(' ');
            }
            message(буф.peekChars());
        }
        argv.сунь(null);
        // set up pipes
        цел[2] fds;
        if (pipe(fds.ptr) == -1)
        {
            perror("unable to создай pipe to linker");
            return -1;
        }
        childpid = fork();
        if (childpid == 0)
        {
            // pipe linker stderr to fds[0]
            dup2(fds[1], STDERR_FILENO);
            close(fds[0]);
            execvp(argv[0], argv.tdata());
            perror(argv[0]); // failed to execute
            return -1;
        }
        else if (childpid == -1)
        {
            perror("unable to fork");
            return -1;
        }
        close(fds[1]);
        цел nme = findNoMainError(fds[0]);
        waitpid(childpid, &status, 0);
        if (WIFEXITED(status))
        {
            status = WEXITSTATUS(status);
            if (status)
            {
                if (nme == -1)
                {
                    perror("error with the linker pipe");
                    return -1;
                }
                else
                {
                    выведиОшибку(Место.initial, "linker exited with status %d", status);
                    if (nme == 1)
                        выведиОшибку(Место.initial, "no main function specified");
                }
            }
        }
        else if (WIFSIGNALED(status))
        {
            выведиОшибку(Место.initial, "linker killed by signal %d", WTERMSIG(status));
            status = 1;
        }
        return status;
    }
    else
    {
        выведиОшибку(Место.initial, "linking is not yet supported for this version of DMD.");
        return -1;
    }
}


/******************************
 * Execute a rule.  Return the status.
 *      cmd     program to run
 *      args    arguments to cmd, as a ткст
 */
version (Windows)
{
    private цел executecmd(ткст0 cmd, ткст0 args)
    {
        цел status;
        т_мера len;
        if (глоб2.парамы.verbose)
            message("%s %s", cmd, args);
        if (!глоб2.парамы.mscoff)
        {
            if ((len = strlen(args)) > 255)
            {
                status = putenvRestorable("_CMDLINE", args[0 .. len]);
                if (status == 0)
                    args = "@_CMDLINE";
                else
                    выведиОшибку(Место.initial, "command line length of %d is too long", len);
            }
        }
        // Normalize executable path separators
        // https://issues.dlang.org/show_bug.cgi?ид=9330
        cmd = toWinPath(cmd);
        version (CRuntime_Microsoft)
        {
            // Open scope so dmd doesn't complain about alloca + exception handling
            {
                // Use process spawning through the WinAPI to avoid issues with executearg0 and spawnlp
                БуфВыв cmdbuf;
                cmdbuf.пишиСтр("\"");
                cmdbuf.пишиСтр(cmd);
                cmdbuf.пишиСтр("\" ");
                cmdbuf.пишиСтр(args);

                STARTUPINFOA startInf;
                startInf.dwFlags = STARTF_USESTDHANDLES;
                startInf.hStdInput = GetStdHandle(STD_INPUT_HANDLE);
                startInf.hStdOutput = GetStdHandle(STD_OUTPUT_HANDLE);
                startInf.hStdError = GetStdHandle(STD_ERROR_HANDLE);
                PROCESS_INFORMATION procInf;

                BOOL b = CreateProcessA(null, cmdbuf.peekChars(), null, null, 1, NORMAL_PRIORITY_CLASS, null, null, &startInf, &procInf);
                if (b)
                {
                    WaitForSingleObject(procInf.hProcess, INFINITE);
                    DWORD returnCode;
                    GetExitCodeProcess(procInf.hProcess, &returnCode);
                    status = returnCode;
                    CloseHandle(procInf.hProcess);
                }
                else
                {
                    status = -1;
                }
            }
        }
        else
        {
            status = executearg0(cmd, args);
            if (status == -1)
            {
                status = spawnlp(0, cmd, cmd, args, null);
            }
        }
        if (status)
        {
            if (status == -1)
                выведиОшибку(Место.initial, "can't run '%s', check PATH", cmd);
            else
                выведиОшибку(Место.initial, "linker exited with status %d", status);
        }
        return status;
    }
}

/**************************************
 * Attempt to найди command to execute by first looking in the directory
 * where DMD was run from.
 * Возвращает:
 *      -1      did not найди command there
 *      !=-1    exit status from command
 */
version (Windows)
{
    private цел executearg0(ткст0 cmd, ткст0 args)
    {
        const argv0 = глоб2.парамы.argv0;
        //printf("argv0='%s', cmd='%s', args='%s'\n",argv0,cmd,args);
        // If cmd is fully qualified, we don't do this
        if (ИмяФайла.absolute(cmd))
            return -1;
        const файл = ИмяФайла.replaceName(argv0, cmd.вТкстД);
        //printf("spawning '%s'\n",файл);
        // spawnlp returns intptr_t in some systems, not цел
        return spawnl(0, файл.ptr, файл.ptr, args, null);
    }
}

/***************************************
 * Run the compiled program.
 * Return exit status.
 */
public цел runProgram()
{
    //printf("runProgram()\n");
    if (глоб2.парамы.verbose)
    {
        БуфВыв буф;
        буф.пишиСтр(глоб2.парамы.exefile);
        for (т_мера i = 0; i < глоб2.парамы.runargs.dim; ++i)
        {
            буф.пишиБайт(' ');
            буф.пишиСтр(глоб2.парамы.runargs[i]);
        }
        message(буф.peekChars());
    }
    // Build argv[]
    Strings argv;
    argv.сунь(глоб2.парамы.exefile.xarraydup.ptr);
    for (т_мера i = 0; i < глоб2.парамы.runargs.dim; ++i)
    {
        ткст0 a = глоб2.парамы.runargs[i];
        version (Windows)
        {
            // BUG: what about " appearing in the ткст?
            if (strchr(a, ' '))
            {
                ткст0 b = cast(сим*)mem.xmalloc(3 + strlen(a));
                sprintf(b, "\"%s\"", a);
                a = b;
            }
        }
        argv.сунь(a);
    }
    argv.сунь(null);
    restoreEnvVars();
    version (Windows)
    {
        ткст ex = ИмяФайла.имя(глоб2.парамы.exefile);
        if (ex == глоб2.парамы.exefile)
            ex = ИмяФайла.combine(".", ex);
        else
            ex = глоб2.парамы.exefile;
        // spawnlp returns intptr_t in some systems, not цел
        return spawnv(0, ex.xarraydup.ptr, argv.tdata());
    }
    else version (Posix)
    {
        pid_t childpid;
        цел status;
        childpid = fork();
        if (childpid == 0)
        {
            ткст0 fn = argv[0];
            if (!ИмяФайла.absolute(fn))
            {
                // Make it "./fn"
                fn = ИмяФайла.combine(".", fn);
            }
            execv(fn, argv.tdata());
            perror(fn); // failed to execute
            return -1;
        }
        waitpid(childpid, &status, 0);
        if (WIFEXITED(status))
        {
            status = WEXITSTATUS(status);
            //printf("--- errorlevel %d\n", status);
        }
        else if (WIFSIGNALED(status))
        {
            выведиОшибку(Место.initial, "program killed by signal %d", WTERMSIG(status));
            status = 1;
        }
        return status;
    }
    else
    {
        assert(0);
    }
}

version (Windows)
{
    struct VSOptions
    {
        // evaluated once at startup, reflecting the результат of vcvarsall.bat
        //  from the current environment or the latest Visual Studio installation
        ткст0 WindowsSdkDir;
        ткст0 WindowsSdkVersion;
        ткст0 UCRTSdkDir;
        ткст0 UCRTVersion;
        ткст0 VSInstallDir;
        ткст0 VCInstallDir;
        ткст0 VCToolsInstallDir; // используется by VS 2017+

        /**
         * fill member variables from environment or registry
         */
        проц initialize()
        {
            detectWindowsSDK();
            detectUCRT();
            detectVSInstallDir();
            detectVCInstallDir();
            detectVCToolsInstallDir();
        }

        /**
         * retrieve the имя of the default C runtime library
         * Параметры:
         *   x64 = target architecture (x86 if нет)
         * Возвращает:
         *   имя of the default C runtime library
         */
        ткст0 defaultRuntimeLibrary(бул x64)
        {
            if (VCInstallDir is null)
            {
                detectVCInstallDir();
                detectVCToolsInstallDir();
            }
            if (getVCLibDir(x64))
                return "libcmt";
            else
                return "msvcrt120"; // mingw replacement
        }

        /**
         * retrieve опции to be passed to the Microsoft linker
         * Параметры:
         *   x64 = target architecture (x86 if нет)
         * Возвращает:
         *   allocated ткст of опции to add to the linker command line
         */
        ткст0 linkOptions(бул x64)
        {
            БуфВыв cmdbuf;
            if (auto vclibdir = getVCLibDir(x64))
            {
                cmdbuf.пишиСтр(" /LIBPATH:\"");
                cmdbuf.пишиСтр(vclibdir);
                cmdbuf.пишиБайт('\"');

                if (ИмяФайла.exists(ИмяФайла.combine(vclibdir, "legacy_stdio_definitions.lib")))
                {
                    // VS2015 or later use UCRT
                    cmdbuf.пишиСтр(" legacy_stdio_definitions.lib");
                    if (auto p = getUCRTLibPath(x64))
                    {
                        cmdbuf.пишиСтр(" /LIBPATH:\"");
                        cmdbuf.пишиСтр(p);
                        cmdbuf.пишиБайт('\"');
                    }
                }
            }
            if (auto p = getSDKLibPath(x64))
            {
                cmdbuf.пишиСтр(" /LIBPATH:\"");
                cmdbuf.пишиСтр(p);
                cmdbuf.пишиБайт('\"');
            }
            if (auto p = getenv("DXSDK_DIR"))
            {
                // support for old DX SDK installations
                cmdbuf.пишиСтр(" /LIBPATH:\"");
                cmdbuf.пишиСтр(p);
                cmdbuf.пишиСтр(x64 ? `\Lib\x64"` : `\Lib\x86"`);
            }
            return cmdbuf.extractChars();
        }

        /**
         * retrieve path to the Microsoft linker executable
         * also modifies PATH environment variable if necessary to найди conditionally loaded DLLs
         * Параметры:
         *   x64 = target architecture (x86 if нет)
         * Возвращает:
         *   absolute path to link.exe, just "link.exe" if not found
         */
        ткст0 linkerPath(бул x64)
        {
            ткст0 addpath;
            if (auto p = getVCBinDir(x64, addpath))
            {
                БуфВыв cmdbuf;
                cmdbuf.пишиСтр(p);
                cmdbuf.пишиСтр(r"\link.exe");
                if (addpath)
                {
                    // debug info needs DLLs from $(VSInstallDir)\Common7\IDE for most linker versions
                    //  so prepend it too the PATH environment variable
                    const path = getenv("PATH");
                    const pathlen = strlen(path);
                    const addpathlen = strlen(addpath);

                    const length = addpathlen + 1 + pathlen;
                    ткст0 npath = cast(сим*)mem.xmalloc(length);
                    memcpy(npath, addpath, addpathlen);
                    npath[addpathlen] = ';';
                    memcpy(npath + addpathlen + 1, path, pathlen);
                    if (putenvRestorable("PATH", npath[0 .. length]))
                        assert(0);
                    mem.xfree(npath);
                }
                return cmdbuf.extractChars();
            }

            // try lld-link.exe alongside dmd.exe
            сим[MAX_PATH + 1] dmdpath = проц;
            const len = GetModuleFileNameA(null, dmdpath.ptr, dmdpath.length);
            if (len <= MAX_PATH)
            {
                auto lldpath = ИмяФайла.replaceName(dmdpath[0 .. len], "lld-link.exe");
                if (ИмяФайла.exists(lldpath))
                    return lldpath.ptr;
            }

            // search PATH to avoid createProcess preferring "link.exe" from the dmd folder
            if (auto p = ИмяФайла.searchPath(getenv("PATH"), "link.exe"[], нет))
                return p.ptr;
            return "link.exe";
        }

    private:
        /**
         * detect WindowsSdkDir and WindowsSDKVersion from environment or registry
         */
        проц detectWindowsSDK()
        {
            if (WindowsSdkDir is null)
                WindowsSdkDir = getenv("WindowsSdkDir");

            if (WindowsSdkDir is null)
            {
                WindowsSdkDir = GetRegistryString(r"Microsoft\Windows Kits\Installed Roots", "KitsRoot10");
                if (WindowsSdkDir && !findLatestSDKDir(ИмяФайла.combine(WindowsSdkDir, "Include"), r"um\windows.h"))
                    WindowsSdkDir = null;
            }
            if (WindowsSdkDir is null)
            {
                WindowsSdkDir = GetRegistryString(r"Microsoft\Microsoft SDKs\Windows\v8.1", "InstallationFolder");
                if (WindowsSdkDir && !ИмяФайла.exists(ИмяФайла.combine(WindowsSdkDir, "Lib")))
                    WindowsSdkDir = null;
            }
            if (WindowsSdkDir is null)
            {
                WindowsSdkDir = GetRegistryString(r"Microsoft\Microsoft SDKs\Windows\v8.0", "InstallationFolder");
                if (WindowsSdkDir && !ИмяФайла.exists(ИмяФайла.combine(WindowsSdkDir, "Lib")))
                    WindowsSdkDir = null;
            }
            if (WindowsSdkDir is null)
            {
                WindowsSdkDir = GetRegistryString(r"Microsoft\Microsoft SDKs\Windows", "CurrentInstallationFolder");
                if (WindowsSdkDir && !ИмяФайла.exists(ИмяФайла.combine(WindowsSdkDir, "Lib")))
                    WindowsSdkDir = null;
            }

            if (WindowsSdkVersion is null)
                WindowsSdkVersion = getenv("WindowsSdkVersion");

            if (WindowsSdkVersion is null && WindowsSdkDir !is null)
            {
                ткст0 rootsDir = ИмяФайла.combine(WindowsSdkDir, "Include");
                WindowsSdkVersion = findLatestSDKDir(rootsDir, r"um\windows.h");
            }
        }

        /**
         * detect UCRTSdkDir and UCRTVersion from environment or registry
         */
        проц detectUCRT()
        {
            if (UCRTSdkDir is null)
                UCRTSdkDir = getenv("UniversalCRTSdkDir");

            if (UCRTSdkDir is null)
                UCRTSdkDir = GetRegistryString(r"Microsoft\Windows Kits\Installed Roots", "KitsRoot10");

            if (UCRTVersion is null)
                UCRTVersion = getenv("UCRTVersion");

            if (UCRTVersion is null && UCRTSdkDir !is null)
            {
                ткст0 rootsDir = ИмяФайла.combine(UCRTSdkDir, "Lib");
                UCRTVersion = findLatestSDKDir(rootsDir, r"ucrt\x86\libucrt.lib");
            }
        }

        /**
         * detect VSInstallDir from environment or registry
         */
        проц detectVSInstallDir()
        {
            if (VSInstallDir is null)
                VSInstallDir = getenv("VSINSTALLDIR");

            if (VSInstallDir is null)
                VSInstallDir = detectVSInstallDirViaCOM();

            if (VSInstallDir is null)
                VSInstallDir = GetRegistryString(r"Microsoft\VisualStudio\SxS\VS7", "15.0"); // VS2017

            if (VSInstallDir is null)
                foreach (ткст0 ver; ["14.0".ptr, "12.0", "11.0", "10.0", "9.0"])
                {
                    VSInstallDir = GetRegistryString(ИмяФайла.combine(r"Microsoft\VisualStudio", ver), "InstallDir");
                    if (VSInstallDir)
                        break;
                }
        }

        /**
         * detect VCInstallDir from environment or registry
         */
        проц detectVCInstallDir()
        {
            if (VCInstallDir is null)
                VCInstallDir = getenv("VCINSTALLDIR");

            if (VCInstallDir is null)
                if (VSInstallDir && ИмяФайла.exists(ИмяФайла.combine(VSInstallDir, "VC")))
                    VCInstallDir = ИмяФайла.combine(VSInstallDir, "VC");

            // detect from registry (build tools?)
            if (VCInstallDir is null)
                foreach (ткст0 ver; ["14.0".ptr, "12.0", "11.0", "10.0", "9.0"])
                {
                    auto regPath = ИмяФайла.buildPath(r"Microsoft\VisualStudio", ver, r"Setup\VC");
                    VCInstallDir = GetRegistryString(regPath, "ProductDir");
                    if (VCInstallDir)
                        break;
                }
        }

        /**
         * detect VCToolsInstallDir from environment or registry (only используется by VC 2017)
         */
        проц detectVCToolsInstallDir()
        {
            if (VCToolsInstallDir is null)
                VCToolsInstallDir = getenv("VCTOOLSINSTALLDIR");

            if (VCToolsInstallDir is null && VCInstallDir)
            {
                ткст0 defverFile = ИмяФайла.combine(VCInstallDir, r"Auxiliary\Build\Microsoft.VCToolsVersion.default.txt");
                if (!ИмяФайла.exists(defverFile)) // файл renamed with VS2019 Preview 2
                    defverFile = ИмяФайла.combine(VCInstallDir, r"Auxiliary\Build\Microsoft.VCToolsVersion.v142.default.txt");
                if (ИмяФайла.exists(defverFile))
                {
                    // VS 2017
                    auto readрезультат = Файл.читай(defverFile); // adds sentinel 0 at end of файл
                    if (readрезультат.успех)
                    {
                        auto ver = cast(сим*)readрезультат.буфер.данные.ptr;
                        // trim version number
                        while (*ver && isspace(*ver))
                            ver++;
                        auto p = ver;
                        while (*p == '.' || (*p >= '0' && *p <= '9'))
                            p++;
                        *p = 0;

                        if (ver && *ver)
                            VCToolsInstallDir = ИмяФайла.buildPath(VCInstallDir, r"Tools\MSVC", ver);
                    }
                }
            }
        }

        /**
         * get Visual C bin folder
         * Параметры:
         *   x64 = target architecture (x86 if нет)
         *   addpath = [out] path that needs to be added to the PATH environment variable
         * Возвращает:
         *   folder containing the VC executables
         *
         * Selects the binary path according to the host and target OS, but verifies
         * that link.exe exists in that folder and falls back to 32-bit host/target if
         * missing
         * Note: differences for the linker binaries are small, they all
         * allow cross compilation
         */
        ткст0 getVCBinDir(бул x64, out ткст0 addpath)
        {
            static ткст0 linkExists(ткст0 p)
            {
                auto lp = ИмяФайла.combine(p, "link.exe");
                return ИмяФайла.exists(lp) ? p : null;
            }

            const бул isHost64 = isWin64Host();
            if (VCToolsInstallDir !is null)
            {
                if (isHost64)
                {
                    if (x64)
                    {
                        if (auto p = linkExists(ИмяФайла.combine(VCToolsInstallDir, r"bin\HostX64\x64")))
                            return p;
                        // in case of missing linker, prefer other host binaries over other target architecture
                    }
                    else
                    {
                        if (auto p = linkExists(ИмяФайла.combine(VCToolsInstallDir, r"bin\HostX64\x86")))
                        {
                            addpath = ИмяФайла.combine(VCToolsInstallDir, r"bin\HostX64\x64");
                            return p;
                        }
                    }
                }
                if (x64)
                {
                    if (auto p = linkExists(ИмяФайла.combine(VCToolsInstallDir, r"bin\HostX86\x64")))
                    {
                        addpath = ИмяФайла.combine(VCToolsInstallDir, r"bin\HostX86\x86");
                        return p;
                    }
                }
                if (auto p = linkExists(ИмяФайла.combine(VCToolsInstallDir, r"bin\HostX86\x86")))
                    return p;
            }
            if (VCInstallDir !is null)
            {
                if (isHost64)
                {
                    if (x64)
                    {
                        if (auto p = linkExists(ИмяФайла.combine(VCInstallDir, r"bin\amd64")))
                            return p;
                        // in case of missing linker, prefer other host binaries over other target architecture
                    }
                    else
                    {
                        if (auto p = linkExists(ИмяФайла.combine(VCInstallDir, r"bin\amd64_x86")))
                        {
                            addpath = ИмяФайла.combine(VCInstallDir, r"bin\amd64");
                            return p;
                        }
                    }
                }

                if (VSInstallDir)
                    addpath = ИмяФайла.combine(VSInstallDir, r"Common7\IDE");
                else
                    addpath = ИмяФайла.combine(VCInstallDir, r"bin");

                if (x64)
                    if (auto p = linkExists(ИмяФайла.combine(VCInstallDir, r"x86_amd64")))
                        return p;

                if (auto p = linkExists(ИмяФайла.combine(VCInstallDir, r"bin\HostX86\x86")))
                    return p;
            }
            return null;
        }

        /**
        * get Visual C Library folder
        * Параметры:
        *   x64 = target architecture (x86 if нет)
        * Возвращает:
        *   folder containing the the VC runtime libraries
        */
        ткст0 getVCLibDir(бул x64)
        {
            if (VCToolsInstallDir !is null)
                return ИмяФайла.combine(VCToolsInstallDir, x64 ? r"lib\x64" : r"lib\x86");
            if (VCInstallDir !is null)
                return ИмяФайла.combine(VCInstallDir, x64 ? r"lib\amd64" : "lib");
            return null;
        }

        /**
         * get the path to the universal CRT libraries
         * Параметры:
         *   x64 = target architecture (x86 if нет)
         * Возвращает:
         *   folder containing the universal CRT libraries
         */
        ткст0 getUCRTLibPath(бул x64)
        {
            if (UCRTSdkDir && UCRTVersion)
               return ИмяФайла.buildPath(UCRTSdkDir, "Lib", UCRTVersion, x64 ? r"ucrt\x64" : r"ucrt\x86");
            return null;
        }

        /**
         * get the path to the Windows SDK CRT libraries
         * Параметры:
         *   x64 = target architecture (x86 if нет)
         * Возвращает:
         *   folder containing the Windows SDK libraries
         */
        ткст0 getSDKLibPath(бул x64)
        {
            if (WindowsSdkDir)
            {
                ткст0 arch = x64 ? "x64" : "x86";
                auto sdk = ИмяФайла.combine(WindowsSdkDir, "lib");
                if (WindowsSdkVersion &&
                    ИмяФайла.exists(ИмяФайла.buildPath(sdk, WindowsSdkVersion, "um", arch, "kernel32.lib"))) // SDK 10.0
                    return ИмяФайла.buildPath(sdk, WindowsSdkVersion, "um", arch);
                else if (ИмяФайла.exists(ИмяФайла.buildPath(sdk, r"win8\um", arch, "kernel32.lib"))) // SDK 8.0
                    return ИмяФайла.buildPath(sdk, r"win8\um", arch);
                else if (ИмяФайла.exists(ИмяФайла.buildPath(sdk, r"winv6.3\um", arch, "kernel32.lib"))) // SDK 8.1
                    return ИмяФайла.buildPath(sdk, r"winv6.3\um", arch);
                else if (x64 && ИмяФайла.exists(ИмяФайла.buildPath(sdk, arch, "kernel32.lib"))) // SDK 7.1 or earlier
                    return ИмяФайла.buildPath(sdk, arch);
                else if (!x64 && ИмяФайла.exists(ИмяФайла.buildPath(sdk, "kernel32.lib"))) // SDK 7.1 or earlier
                    return sdk;
            }

            // try mingw fallback relative to phobos library folder that's part of LIB
            if (auto p = ИмяФайла.searchPath(getenv("LIB"), r"mingw\kernel32.lib"[], нет))
                return ИмяФайла.path(p).ptr;

            return null;
        }

        // iterate through subdirectories named by SDK version in baseDir and return the
        //  one with the largest version that also содержит the test файл
        static ткст0 findLatestSDKDir(ткст0 baseDir, ткст0 testfile)
        {
            auto allfiles = ИмяФайла.combine(baseDir, "*");
            WIN32_FIND_DATAA fileinfo;
            HANDLE h = FindFirstFileA(allfiles, &fileinfo);
            if (h == INVALID_HANDLE_VALUE)
                return null;

            ткст0 res = null;
            do
            {
                if (fileinfo.cFileName[0] >= '1' && fileinfo.cFileName[0] <= '9')
                    if (res is null || strcmp(res, fileinfo.cFileName.ptr) < 0)
                        if (ИмяФайла.exists(ИмяФайла.buildPath(baseDir, fileinfo.cFileName.ptr, testfile)))
                        {
                            const len = strlen(fileinfo.cFileName.ptr) + 1;
                            res = cast(сим*) memcpy(mem.xrealloc(res, len), fileinfo.cFileName.ptr, len);
                        }
            }
            while(FindNextFileA(h, &fileinfo));

            if (!FindClose(h))
                res = null;
            return res;
        }

        pragma(lib, "advapi32.lib");

        /**
         * читай a ткст from the 32-bit registry
         * Параметры:
         *  softwareKeyPath = path below HKLM\SOFTWARE
         *  valueName       = имя of the значение to читай
         * Возвращает:
         *  the registry значение if it exists and has ткст тип
         */
        ткст0 GetRegistryString(ткст0 softwareKeyPath, ткст0 valueName)
        {
            const x64hive = нет; // VS registry entries always in 32-bit hive

            version(Win64)
                const префикс = x64hive ? r"SOFTWARE\" : r"SOFTWARE\WOW6432Node\";
            else
                const префикс = r"SOFTWARE\";

            сим[260] regPath = проц;
            const len = strlen(softwareKeyPath);
            assert(len + префикс.length < regPath.length);

            memcpy(regPath.ptr, префикс.ptr, префикс.length);
            memcpy(regPath.ptr + префикс.length, softwareKeyPath, len + 1);

            const KEY_WOW64_64KEY = 0x000100; // not defined in win32.winnt due to restrictive version
            const KEY_WOW64_32KEY = 0x000200;
            HKEY ключ;
            LONG lRes = RegOpenKeyExA(HKEY_LOCAL_MACHINE, regPath.ptr, (x64hive ? KEY_WOW64_64KEY : KEY_WOW64_32KEY), KEY_READ, &ключ);
            if (FAILED(lRes))
                return null;
            scope(exit) RegCloseKey(ключ);

            сим[260] буф = проц;
            DWORD cnt = буф.length * сим.sizeof;
            DWORD тип;
            цел hr = RegQueryValueExA(ключ, valueName, null, &тип, cast(ббайт*) буф.ptr, &cnt);
            if (hr == 0 && cnt > 0)
                return буф.dup.ptr;
            if (hr != ERROR_MORE_DATA || тип != REG_SZ)
                return null;

            scope ткст pbuf = new сим[cnt + 1];
            RegQueryValueExA(ключ, valueName, null, &тип, cast(ббайт*) pbuf.ptr, &cnt);
            return pbuf.ptr;
        }

        /***
         * get architecture of host OS
         */
        static бул isWin64Host()
        {
            version (Win64)
            {
                return да;
            }
            else
            {
                // running as a 32-bit process on a 64-bit host?
                alias extern(Windows) BOOL function(HANDLE, PBOOL) fnIsWow64Process;
                 fnIsWow64Process pIsWow64Process;

                if (!pIsWow64Process)
                {
                    //IsWow64Process is not доступно on all supported versions of Windows.
                    pIsWow64Process = cast(fnIsWow64Process) GetProcAddress(GetModuleHandleA("kernel32"), "IsWow64Process");
                    if (!pIsWow64Process)
                        return нет;
                }
                BOOL bIsWow64 = FALSE;
                if (!pIsWow64Process(GetCurrentProcess(), &bIsWow64))
                    return нет;

                return bIsWow64 != 0;
            }
        }
    }

    ///////////////////////////////////////////////////////////////////////
    // COM interfaces to найди VS2017+ installations
//    import win32.com;
  //  import win32.wtypes : BSTR;
   // import win32.winnls : WideCharToMultiByte, CP_UTF8;
   // import win32.oleauto : SysFreeString;
    import win, winapi;

    //pragma(lib, "ole32.lib");
    //pragma(lib, "oleaut32.lib");

    interface ISetupInstance : IUnknown
    {
        // static const GUID iid = uuid("B41463C3-8866-43B5-BC33-2B0676F7F42E");
        static const GUID iid = { 0xB41463C3, 0x8866, 0x43B5, [ 0xBC, 0x33, 0x2B, 0x06, 0x76, 0xF7, 0xF4, 0x2E ] };

        цел GetInstanceId(BSTR* pbstrInstanceId);
        цел GetInstallDate(LPFILETIME pInstallDate);
        цел GetInstallationName(BSTR* pbstrInstallationName);
        цел GetInstallationPath(BSTR* pbstrInstallationPath);
        цел GetInstallationVersion(BSTR* pbstrInstallationVersion);
        цел GetDisplayName(LCID lcid, BSTR* pbstrDisplayName);
        цел GetDescription(LCID lcid, BSTR* pbstrDescription);
        цел ResolvePath(LPCOLESTR pwszRelativePath, BSTR* pbstrAbsolutePath);
    }

    interface IEnumSetupInstances : IUnknown
    {
        // static const GUID iid = uuid("6380BCFF-41D3-4B2E-8B2E-BF8A6810C848");

        цел Next(ULONG celt, ISetupInstance* rgelt, ULONG* pceltFetched);
        цел Skip(ULONG celt);
        цел Reset();
        цел Clone(IEnumSetupInstances* ppenum);
    }

    interface ISetupConfiguration : IUnknown
    {
        // static const GUID iid = uuid("42843719-DB4C-46C2-8E7C-64F1816EFD5B");
        static const GUID iid = { 0x42843719, 0xDB4C, 0x46C2, [ 0x8E, 0x7C, 0x64, 0xF1, 0x81, 0x6E, 0xFD, 0x5B ] };

        цел EnumInstances(IEnumSetupInstances* ppEnumInstances) ;
        цел GetInstanceForCurrentProcess(ISetupInstance* ppInstance);
        цел GetInstanceForPath(LPCWSTR wzPath, ISetupInstance* ppInstance);
    }

    const GUID iid_SetupConfiguration = { 0x177F0C4A, 0x1CD3, 0x4DE7, [ 0xA3, 0x2C, 0x71, 0xDB, 0xBB, 0x9F, 0xA3, 0x6D ] };

    ткст0 detectVSInstallDirViaCOM()
    {
        CoInitialize(null);
        scope(exit) CoUninitialize();

        ISetupConfiguration setup;
        IEnumSetupInstances instances;
        ISetupInstance instance;
        DWORD fetched;

        Hрезультат hr = CoCreateInstance(&iid_SetupConfiguration, null, CLSCTX_ALL, &ISetupConfiguration.iid, cast(ук*) &setup);
        if (hr != S_OK || !setup)
            return null;
        scope(exit) setup.Release();

        if (setup.EnumInstances(&instances) != S_OK)
            return null;
        scope(exit) instances.Release();

        while (instances.Next(1, &instance, &fetched) == S_OK && fetched)
        {
            BSTR bstrInstallDir;
            if (instance.GetInstallationPath(&bstrInstallDir) != S_OK)
                continue;

            сим[260] path;
            цел len = WideCharToMultiByte(CP_UTF8, 0, bstrInstallDir, -1, path.ptr, 260, null, null);
            SysFreeString(bstrInstallDir);

            if (len > 0)
                return path[0..len].idup.ptr;
        }
        return null;
    }
}
