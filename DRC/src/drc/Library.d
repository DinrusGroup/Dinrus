/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/lib.d, _lib.d)
 * Documentation:  https://dlang.org/phobos/dmd_lib.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/lib.d
 */

module drc.Library;

import cidrus;

import dmd.globals;
import dmd.errors;
import util.utils;

import util.outbuffer;
import util.file;
import util.filename;
import util.string;

static if (TARGET.Windows)
{
    import drc.lib.Omf;
    import drc.lib.Mscoff;
}
else static if (TARGET.Linux || TARGET.FreeBSD || TARGET.OpenBSD || TARGET.Solaris || TARGET.DragonFlyBSD)
{
    import drc.lib.Elf;
}
else static if (TARGET.OSX)
{
    import drc.lib.Mach;
}
else
{
    static assert(0, "unsupported system");
}

private const LOG = нет;

class Library
{
    static Library factory()
    {
        static if (TARGET.Windows)
        {
            return (глоб2.парамы.mscoff || глоб2.парамы.is64bit) ? LibMSCoff_factory() : LibOMF_factory();
        }
        else static if (TARGET.Linux || TARGET.FreeBSD || TARGET.OpenBSD || TARGET.Solaris || TARGET.DragonFlyBSD)
        {
            return LibElf_factory();
        }
        else static if (TARGET.OSX)
        {
            return LibMach_factory();
        }
    }

    abstract проц addObject(ткст0 module_name, ббайт[] буф);

    protected abstract проц WriteLibToBuffer(БуфВыв* libbuf);


    /***********************************
     * Set the library файл имя based on the output directory
     * and the имяф.
     * Add default library файл имя extension.
     * Параметры:
     *  dir = path to файл
     *  имяф = имя of файл relative to `dir`
     */
    final проц setFilename(ткст dir, ткст имяф)
    {
        static if (LOG)
        {
            printf("LibElf::setFilename(dir = '%.*s', имяф = '%.*s')\n",
                   cast(цел)dir.length, dir.ptr, cast(цел)имяф.length, имяф.ptr);
        }
        ткст arg = имяф;
        if (!arg.length)
        {
            // Generate lib файл имя from first obj имя
            ткст n = глоб2.парамы.objfiles[0].вТкстД;
            n = ИмяФайла.имя(n);
            arg = ИмяФайла.forceExt(n, глоб2.lib_ext);
        }
        if (!ИмяФайла.absolute(arg))
            arg = ИмяФайла.combine(dir, arg);

        место = Место(ИмяФайла.defaultExt(arg, глоб2.lib_ext).ptr, 0, 0);
    }

    final проц пиши()
    {
        if (глоб2.парамы.verbose)
            message("library   %s", место.имяф);

        БуфВыв libbuf;
        WriteLibToBuffer(&libbuf);

        writeFile(Место.initial, место.имяф.вТкстД, libbuf[]);
    }

    final проц выведиОшибку(ткст0 format, ...)
    {
        va_list ap;
        va_start(ap, format);
        .verror(место, format, ap);
        va_end(ap);
    }

  protected:
    Место место;                  // the имяф of the library
}
