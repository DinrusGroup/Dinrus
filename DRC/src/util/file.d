/**
 * Compiler implementation of the D programming language
 * http://dlang.org
 *
 * Copyright: Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:   Walter Bright, http://www.digitalmars.com
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:    $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/root/файл.d, root/_file.d)
 * Documentation:  https://dlang.org/phobos/dmd_root_file.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/root/файл.d
 */

module util.file;

import cidrus;

version(POSIX)
{
import core.sys.posix.fcntl;
import core.sys.posix.unistd;
}
else
{
import winapi;
}

import util.filename;
import util.rmem;
import util.string;

/// Owns a (rmem-managed) файл буфер.
class ФайлБуфер
{
    ббайт[] данные;

    this(){}

    ~this()  
    {
        mem.xfree(данные.ptr);
    }

    /// Transfers ownership of the буфер to the caller.
    ббайт[] извлекиСрез() 
    {
        auto результат = данные;
        данные = null;
        return результат;
    }

     static ФайлБуфер* создай()
    {
        return new ФайлБуфер();
    }
}

///
struct Файл
{
    ///
    struct РезЧтения
    {
        бул успех;
        ФайлБуфер буфер;

        /// Transfers ownership of the буфер to the caller.
        ббайт[] извлекиСрез()  
        {
            return буфер.извлекиСрез();
        }

        /// ditto
        /// Include the null-terminator at the end of the буфер in the returned массив.
        ббайт[] extractDataZ() 
        {
            auto результат = буфер.извлекиСрез();
            return результат.ptr[0 .. результат.length + 1];
        }
    }


    /// Read the full content of a файл.
     static РезЧтения читай(ткст0 имя)
    {
        РезЧтения результат;

        version (Posix)
        {
            т_мера size;
            stat_t буф;
            sт_мера numread;
            //printf("Файл::читай('%s')\n",имя);
            цел fd = open(имя, O_RDONLY);
            if (fd == -1)
            {
                //printf("\topen error, errno = %d\n",errno);
                return результат;
            }
            //printf("\tfile opened\n");
            if (fstat(fd, &буф))
            {
                printf("\tfstat error, errno = %d\n", errno);
                close(fd);
                return результат;
            }
            size = cast(т_мера)буф.st_size;
            ббайт* буфер = cast(ббайт*)mem.xmalloc_noscan(size + 2);
            if (!буфер)
                goto err2;
            numread = .читай(fd, буфер, size);
            if (numread != size)
            {
                printf("\tread error, errno = %d\n", errno);
                goto err2;
            }
            if (close(fd) == -1)
            {
                printf("\tclose error, errno = %d\n", errno);
                goto err;
            }
            // Always store a wchar ^Z past end of буфер so scanner has a sentinel
            буфер[size] = 0; // ^Z is obsolete, use 0
            буфер[size + 1] = 0;
            результат.успех = да;
            результат.буфер.данные = буфер[0 .. size];
            return результат;
        err2:
            close(fd);
        err:
            mem.xfree(буфер);
            return результат;
        }
        else version (Windows)
        {
            DWORD size;
            DWORD numread;

            // work around Windows файл path length limitation
            // (see documentation for extendedPathThen).
            HANDLE h = имя.вТкстД.extendedPathThen!
                (/*p =>*/CreateFileW(p.ptr,
                                  GENERIC_READ,
                                  FILE_SHARE_READ,
                                  null,
                                  OPEN_EXISTING,
                                  FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,
                                  null));
            if (h == INVALID_HANDLE_VALUE)
                return результат;
            size = GetFileSize(h, null);
            ббайт* буфер = cast(ббайт*)mem.xmalloc_noscan(size + 2);
            if (!буфер)
                goto err2;
            if (ReadFile(h, буфер, size, &numread, null) != TRUE)
                goto err2;
            if (numread != size)
                goto err2;
            if (!CloseHandle(h))
                goto err;
            // Always store a wchar ^Z past end of буфер so scanner has a sentinel
            буфер[size] = 0; // ^Z is obsolete, use 0
            буфер[size + 1] = 0;
            результат.успех = да;
            результат.буфер.данные = буфер[0 .. size];
            return результат;
        err2:
            CloseHandle(h);
        err:
            mem.xfree(буфер);
            return результат;
        }
        else
        {
            assert(0);
        }
    }

    /// Write a файл, returning `да` on успех.
    extern (D) static бул пиши(ткст0 имя, проц[] данные)
    {
        version (Posix)
        {
            sт_мера numwritten;
            цел fd = open(имя, O_CREAT | O_WRONLY | O_TRUNC, (6 << 6) | (4 << 3) | 4);
            if (fd == -1)
                goto err;
            numwritten = .пиши(fd, данные.ptr, данные.length);
            if (numwritten != данные.length)
                goto err2;
            if (close(fd) == -1)
                goto err;
            return да;
        err2:
            close(fd);
            .удали(имя);
        err:
            return нет;
        }
        else version (Windows)
        {
            DWORD numwritten; // here because of the gotos
            const nameStr = имя.вТкстД;
            // work around Windows файл path length limitation
            // (see documentation for extendedPathThen).
            HANDLE h = nameStr.extendedPathThen!
                (/*p =>*/ CreateFileW(p.ptr,
                                  GENERIC_WRITE,
                                  0,
                                  null,
                                  CREATE_ALWAYS,
                                  FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,
                                  null));
            if (h == INVALID_HANDLE_VALUE)
                goto err;

            if (WriteFile(h, данные.ptr, cast(DWORD)данные.length, &numwritten, null) != TRUE)
                goto err2;
            if (numwritten != данные.length)
                goto err2;
            if (!CloseHandle(h))
                goto err;
            return да;
        err2:
            CloseHandle(h);
            nameStr.extendedPathThen!(/*p =>*/ DeleteFileW(p.ptr));
        err:
            return нет;
        }
        else
        {
            assert(0);
        }
    }

    ///ditto
    extern(D) static бул пиши(ткст имя,  проц[] данные)
    {
        return имя.toCStringThen!(/*(fname) =>*/ пиши(fname.ptr, данные));
    }

    /// ditto
     static бул пиши(ткст0 имя, ук данные, т_мера size)
    {
        return пиши(имя, данные[0 .. size]);
    }

    /// Delete a файл.
     static проц удали(ткст0 имя)
    {
        version (Posix)
        {
            .удали(имя);
        }
        else version (Windows)
        {
            имя.вТкстД.extendedPathThen!(/*p =>*/ DeleteFileW(p.ptr));
        }
        else
        {
            assert(0);
        }
    }
}
