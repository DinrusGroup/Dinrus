/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/filecache.d, filecache.d)
 * Documentation:  https://dlang.org/phobos/dmd_filecache.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/filecache.d
 */

module util.filecache;

import util.stringtable;
import util.array;
import util.file;
import util.filename;

import cidrus;

/**
A line-by-line representation of a $(REF Файл, dmd,root,файл).
*/
class ФайлИСтроки
{
    ИмяФайла* файл;
    ФайлБуфер* буфер;
    const ткст[] строки;

  

    /**
    Файл для чтения и разбиения на строки.
    */
    this(ткст имяф)
    {
        файл = new ИмяФайла(имяф);
        прочтиИРазбей();
    }

    // Read a файл and split the файл буфер linewise
    private проц прочтиИРазбей()
    {
        auto readрезультат = Файл.читай(файл.вТкст0());
        // FIXME: check успех
        // take ownership of буфер
        буфер = new ФайлБуфер(readрезультат.извлекиСрез());
        ббайт* буф = буфер.данные.ptr;
        // slice into строки
        while (*буф)
        {
            auto prevBuf = буф;
            for (; *буф != '\n' && *буф != '\r'; буф++)
            {
                if (!*буф)
                    break;
            }
            // handle Windows line endings
            if (*буф == '\r' && *(буф + 1) == '\n')
                буф++;
            строки ~= cast(ткст) prevBuf[0 .. буф - prevBuf];
            буф++;
        }
    }

    проц разрушь()
    {
        if (файл)
        {
            файл.разрушь();
            файл = null;
            буфер.разрушь();
            буфер = null;
            строки.разрушь();
            строки = null;
        }
    }

    ~this()
    {
        разрушь();
    }
}

/**
A simple файл cache that can be используется to avoid reading the same файл multiple times.
It stores its cached files as $(LREF ФайлИСтроки)
*/
struct ФайлКэш
{
    private ТаблицаСтрок!(ФайлИСтроки) files;

  

    /**
    Add or get a файл from the файл cache.
    If the файл isn't part of the cache, it will be читай from the filesystem.
    If the файл has been читай before, the cached файл объект will be returned

    Параметры:
        файл = файл to load in (or get from) the cache

    Возвращает: a $(LREF ФайлИСтроки) объект containing a line-by-line representation of the requested файл
    */
    ФайлИСтроки addOrGetFile(ткст файл)
    {
        if (auto payload = files.lookup(файл))
        {
            if (payload !is null)
                return payload.значение;
        }

        auto строки = new ФайлИСтроки(файл);
        files.вставь(файл, строки);
        return строки;
    }

     auto fileCache = ФайлКэш();

    // Initializes the глоб2 ФайлКэш singleton
    static  проц _иниц()
    {
        fileCache.initialize();
    }

    проц initialize()
    {
        files._иниц();
    }

    проц deinitialize()
    {
        foreach (sv; files)
            sv.разрушь();
        files.сбрось();
    }
}
