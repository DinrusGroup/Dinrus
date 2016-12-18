﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD:  
                        AFL 3.0: 

        version:        Mar 2004: Initial release
        version:        Feb 2007: Сейчас using mutating пути

        author:         Kris, Chris Sauls (Win95 файл support)

*******************************************************************************/

module io.FileSystem;

private import sys.Common;

private import io.FilePath;

private import exception;

private import io.Path : стандарт, исконный;

/*******************************************************************************

*******************************************************************************/

version (Win32)
        {
        private import Текст = text.Util;
        private extern (Windows) DWORD GetLogicalDriveStringsA (DWORD, LPSTR);
        private import stringz : изТкст16н, изТкст0;

        enum {        
            FILE_DEVICE_DISK = 7,
            IOCTL_DISK_BASE = FILE_DEVICE_DISK,
            METHOD_BUFFERED = 0,
            FILE_READ_ACCESS = 1
        }
        бцел CTL_CODE(бцел t, бцел f, бцел m, бцел a) {
            return (t << 16) | (a << 14) | (f << 2) | m;
        }

        const IOCTL_DISK_GET_LENGTH_INFO = CTL_CODE(IOCTL_DISK_BASE,0x17,METHOD_BUFFERED,FILE_READ_ACCESS);
        }

version (Posix)
        {
        private import cidrus;
        private import rt.core.stdc.posix.unistd,
                       rt.core.stdc.posix.sys.statvfs;

        private import io.device.File;
        private import Целое = text.convert.Integer;
        }

/*******************************************************************************

        Models an OS-specific файл-system. Included here are methods в_
        manИПulate the current working дир, and в_ преобразуй a путь
        в_ its абсолютный form.

*******************************************************************************/


struct ФСистема
{


        /***********************************************************************

                Convert the provопрed путь в_ an абсолютный путь, using the
                current working дир where префикс is not provопрed. 
                If the given путь is already an абсолютный путь, return it 
                intact.

                Returns the provопрed путь, adjusted as necessary

                deprecated: see ФПуть.абсолютный

        ***********************************************************************/

        deprecated static ФПуть вАбсолют (ФПуть мишень, ткст префикс=пусто)
        {
                if (! мишень.абс_ли)
                   {
                   if (префикс is пусто)
                       префикс = дайПапку;

                   мишень.приставь (мишень.псеп_в_конце(префикс));
                   }
                return мишень;
        }

        /***********************************************************************

                Convert the provопрed путь в_ an абсолютный путь, using the
                current working дир where префикс is not provопрed. 
                If the given путь is already an абсолютный путь, return it 
                intact.

                Returns the provопрed путь, adjusted as necessary

                deprecated: see ФПуть.абсолютный

        ***********************************************************************/

        deprecated static ткст вАбсолют (ткст путь, ткст префикс=пусто)
        {
                scope мишень = new ФПуть (путь);
                return вАбсолют (мишень, префикс).вТкст;
        }

        /***********************************************************************

                Compare в_ пути for абсолютный equality. The given префикс
                is prepended в_ the пути where they are not already in
                абсолютный форматируй (старт with a '/'). Where префикс is not
                provопрed, the current working дир will be used

                Returns да if the пути are equivalent, нет otherwise

                deprecated: see ФПуть.равно

        ***********************************************************************/

        deprecated static бул равно (ткст path1, ткст path2, ткст префикс=пусто)
        {
                scope p1 = new ФПуть (path1);
                scope p2 = new ФПуть (path2);
                return (вАбсолют(p1, префикс) == вАбсолют(p2, префикс)) is 0;
        }

        /***********************************************************************

        ***********************************************************************/

        private static проц исключение (ткст сооб)
        {
                throw new ВВИскл (сооб);
        }

        /***********************************************************************
        
                Windows specifics

        ***********************************************************************/

        version (Windows)
        {
                /***************************************************************

                        private helpers

                ***************************************************************/

                version (Win32SansUnicode)
                {
                        private static проц путьВиндовс(ткст путь, ref ткст результат)
                        {
                                результат[0..путь.length] = путь;
                                результат[путь.length] = 0;
                        }
                }
                else
                {
                        private static проц путьВиндовс(ткст путь, ref шим[] результат)
                        {
                                assert (путь.length < результат.length);
                                auto i = MultiByteToWideChar (CP_UTF8, 0, 
                                                              cast(PCHAR)путь.ptr, 
                                                              путь.length, 
                                                              результат.ptr, результат.length);
                                результат[i] = 0;
                        }
                }

                /***************************************************************

                        Набор the current working дир

                        deprecated: see Среда.текрабпап()

                ***************************************************************/

                deprecated static проц установиПапку (ткст путь)
                {
                        version (Win32SansUnicode)
                                {
                                сим[MAX_PATH+1] врем =void;
                                врем[0..путь.length] = путь;
                                врем[путь.length] = 0;

                                if (! SetCurrentDirectoryA (врем.ptr))
                                      исключение ("Не удалось установить текущую папку");
                                }
                             else
                                {
                                // преобразуй преобр_в вывод буфер
                                шим[MAX_PATH+1] врем =void;
                                assert (путь.length < врем.length);
                                auto i = MultiByteToWideChar (CP_UTF8, 0, 
                                                              cast(PCHAR)путь.ptr, путь.length, 
                                                              врем.ptr, врем.length);
                                врем[i] = 0;

                                if (! SetCurrentDirectoryW (врем.ptr))
                                      исключение ("Не удалось установить текущую папку");
                                }
                }

                /***************************************************************

                        Return the current working дир

                        deprecated: see Среда.текрабпап()

                ***************************************************************/

                deprecated static ткст дайПапку ()
                {
                        ткст путь;

                        version (Win32SansUnicode)
                                {
                                цел длин = GetCurrentDirectoryA (0, пусто);
                                auto пап = new сим [длин];
                                GetCurrentDirectoryA (длин, пап.ptr);
                                if (длин)
                                   {
                                   пап[длин-1] = '/';                                   
                                   путь = стандарт (пап);
                                   }
                                else
                                   исключение ("Не удалось получить текущую папку");
                                }
                             else
                                {
                                шим[MAX_PATH+2] врем =void;

                                auto длин = GetCurrentDirectoryW (0, пусто);
                                assert (длин < врем.length);
                                auto пап = new сим [длин * 3];
                                GetCurrentDirectoryW (длин, врем.ptr); 
                                auto i = WideCharToMultiByte (CP_UTF8, 0, врем.ptr, длин, 
                                                              cast(PCHAR)пап.ptr, пап.length, пусто, пусто);
                                if (длин && i)
                                   {
                                   путь = стандарт (пап[0..i]);
                                   путь[$-1] = '/';
                                   }
                                else
                                   исключение ("Не удалось получить текущую папку");
                                }

                        return путь;
                }

                /***************************************************************
                        
                        List the установи of корень devices (C:, D: etc)

                ***************************************************************/

                static ткст[] корни ()
                {
                        цел             длин;
                        ткст          ткт;
                        ткст[]        корни;

                        // acquire drive strings
                        длин = GetLogicalDriveStringsA (0, пусто);
                        if (длин)
                           {
                           ткт = new сим [длин];
                           GetLogicalDriveStringsA (длин, cast(PCHAR)ткт.ptr);

                           // разбей корни преобр_в seperate strings
                           корни = Текст.разграничь (ткт [0 .. $-1], "\0");
                           }
                        return корни;
                }

                private enum {
                    volumePathBufferLen = MAX_PATH + 6
                }
                
                private static TCHAR[] дайПутьТома(ткст папка, WCHAR[] volPath_,
                                                     бул бэкслэшхвост)
                in {
                    assert (volPath_.length > 5);
                } body {
                    version (Win32SansUnicode) {
                        alias GetVolumePathNameA GetVolumePathName;
                        alias изТкст0 fromStringzT;
                    }
                    else {
                        alias GetVolumePathNameW GetVolumePathName;
                        alias изТкст16н fromStringzT;
                    }

                    // преобразовать в (w)stringz
                    TCHAR[MAX_PATH+2] tmp_ =void;
                    TCHAR[] врем = tmp_;
                    путьВиндовс(папка, врем);

                    // we'd like в_ открой a volume
                    volPath_[0..4] = `\\.\`;

                    if (!GetVolumePathName(врем.ptr, volPath_.ptr+4, volPath_.length-4)) 
                        исключение ("Краш функции GetVolumePathName");
                    
                    TCHAR[] volPath;

                    // the путь could have the volume/network префикс already
                    if (volPath_[4..6] != `\\`) {
                        volPath = fromStringzT(volPath_.ptr);
                    } else {
                        volPath = fromStringzT(volPath_[4..$].ptr);
                    }

                    // GetVolumePathName returns a путь with a trailing backslash
                    // some sys.Common functions want that backslash, some don't
                    if ('\\' == volPath[$-1] && !бэкслэшхвост) {
                        volPath[$-1] = '\0';
                    }

                    return volPath;
                }
 
                /***************************************************************
 
                        Request как much free пространство in байты is available on the 
                        disk/mountpoint where папка resопрes.

                        If a quota предел есть_ли for this area, that will be taken 
                        преобр_в account unless superuser is установи в_ да.

                        If a пользователь есть exceeded the quota, a negative число can 
                        be returned.

                        Note that the difference between total available пространство
                        and free пространство will not equal the combined размер of the 
                        contents on the файл system, since the numbers for the
                        functions here are calculated из_ the used blocks,
                        включая those spent on metadata and файл nodes.

                        If actual used пространство is wanted one should use the
                        statistics functionality of io.vfs.

                        See also: всегоМеста()

                        Since: 0.99.9

                ***************************************************************/

                static дол свободноеМесто(ткст папка, бул superuser = нет)
                {
                    scope fp = new ФПуть(папка);

                    const бул wantTrailingBackslash = да;                    
                    TCHAR[volumePathBufferLen] volPathBuf;
                    auto volPath = дайПутьТома(fp.исконный.вТкст, volPathBuf, wantTrailingBackslash);

                    version (Win32SansUnicode) {
                        alias GetDiskFreeSpaceExA GetDiskFreeSpaceEx;
                    } else {
                        alias GetDiskFreeSpaceExW GetDiskFreeSpaceEx;
                    }

                    ULARGE_INTEGER free, totalFree;
                    GetDiskFreeSpaceEx(volPath.ptr, &free, пусто, &totalFree);
                    return cast(дол) (superuser ? totalFree : free).QuadPart;
                }

                /***************************************************************

                        Request как large in байты the
                        disk/mountpoint where папка resопрes is.

                        If a quota предел есть_ли for this area, then
                        that quota can be what will be returned unless superuser
                        is установи в_ да. On Posix systems this distinction is not
                        made though.

                        NOTE Access в_ this information when _superuser is
                        установи в_ да may only be available if the program is
                        run in superuser режим.

                        See also: свободноеМесто()

                        Since: 0.99.9

                ***************************************************************/

                static бдол всегоМеста(ткст папка, бул superuser = нет)
                {
                    version (Win32SansUnicode) {
                        alias GetDiskFreeSpaceExA GetDiskFreeSpaceEx;
                        alias CreateFileA CreateFile;
                    } else {
                        alias GetDiskFreeSpaceExW GetDiskFreeSpaceEx;
                        alias CreateFileW CreateFile;
                    }
                    
                    scope fp = new ФПуть(папка);

                    бул wantTrailingBackslash = (нет == superuser);                    
                    TCHAR[volumePathBufferLen] volPathBuf;
                    auto volPath = дайПутьТома(fp.исконный.вТкст, volPathBuf, wantTrailingBackslash);

                    if (superuser) {
                        struct GET_LENGTH_INFORMATION {
                            LARGE_INTEGER Length;
                        }
                        GET_LENGTH_INFORMATION lenInfo;
                        DWORD numBytes;
                        OVERLAPPED overlap;
                        
                        HANDLE h = CreateFile(
                                volPath.ptr, GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE,
                                пусто, OPEN_EXISTING, 0, пусто
                        );
                        
                        if (h == INVALID_HANDLE_VALUE) {
                            исключение ("Не удалось открыть том для чтения");
                        }
                                               
                        if (0 == DeviceIoControl(
                                h, IOCTL_DISK_GET_LENGTH_INFO, пусто , 0,
                                cast(проц*)&lenInfo, lenInfo.sizeof, &numBytes, &overlap
                            )) {
                            исключение ("IOCTL_DISK_GET_LENGTH_INFO неудачно:" ~ СисОш.последнСооб);
                        }

                        return cast(бдол)lenInfo.Length.QuadPart;
                    }
                    else {
                        ULARGE_INTEGER total;
                        GetDiskFreeSpaceEx(volPath.ptr, пусто, &total, пусто);
                        return cast(бдол)total.QuadPart;
                    }
                }
        }

        /***********************************************************************

        ***********************************************************************/

        version (Posix)
        {
                /***************************************************************

                        Набор the current working дир

                        deprecated: see Среда.текрабпап()

                ***************************************************************/

                deprecated static проц установиПапку (ткст путь)
                {
                        сим[512] врем =void;
                        врем [путь.length] = 0;
                        врем[0..путь.length] = путь;

                        if (rt.core.stdc.posix.unistd.chdir (врем.ptr))
                            исключение ("Не удалось установить текущую папку");
                }

                /***************************************************************

                        Return the current working дир

                        deprecated: see Среда.текрабпап()

                ***************************************************************/

                deprecated static ткст дайПапку ()
                {
                        сим[512] врем =void;

                        сим *s = rt.core.stdc.posix.unistd.getcwd (врем.ptr, врем.length);
                        if (s is пусто)
                            исключение ("Не удалось получить текущую папку");

                        auto путь = s[0 .. strlen(s)+1].dup;
                        путь[$-1] = '/';
                        return путь;
                }

                /***************************************************************

                        List the установи of корень devices.

                 ***************************************************************/

                static ткст[] корни ()
                {
                        version(darwin)
                        {
                            assert(0);
                        }
                        else
                        {
                            ткст путь = "";
                            ткст[] список;
                            цел пробелы;

                            auto fc = new Файл("/etc/mtab");
                            scope (exit)
                                   fc.закрой;
                            
                            auto контент = new сим[cast(цел) fc.length];
                            fc.ввод.читай (контент);
                            
                            for(цел i = 0; i < контент.length; i++)
                            {
                                if(контент[i] == ' ') пробелы++;
                                else if(контент[i] == '\n')
                                {
                                    пробелы = 0;
                                    список ~= путь;
                                    путь = "";
                                }
                                else if(пробелы == 1)
                                {
                                    if(контент[i] == '\\')
                                    {
                                        путь ~= Целое.разбор(контент[++i..i+3], 8u);
                                        i += 2;
                                    }
                                    else путь ~= контент[i];
                                }
                            }
                            
                            return список;
                        }
                }

                /***************************************************************
 
                        Request как much free пространство in байты is available on the 
                        disk/mountpoint where папка resопрes.

                        If a quota предел есть_ли for this area, that will be taken 
                        преобр_в account unless superuser is установи в_ да.

                        If a пользователь есть exceeded the quota, a negative число can 
                        be returned.

                        Note that the difference between total available пространство
                        and free пространство will not equal the combined размер of the 
                        contents on the файл system, since the numbers for the
                        functions here are calculated из_ the used blocks,
                        включая those spent on metadata and файл nodes.

                        If actual used пространство is wanted one should use the
                        statistics functionality of io.vfs.

                        See also: всегоМеста()

                        Since: 0.99.9

                ***************************************************************/

                static дол свободноеМесто(ткст папка, бул superuser = нет)
                {
                    scope fp = new ФПуть(папка);
                    statvfs_t инфо;
                    цел рез = statvfs(fp.исконный.сиТкст.ptr, &инфо);
                    if (рез == -1)
                        исключение ("свободноеМесто->statvfs неудачно:"
                                   ~ СисОш.последнСооб);

                    if (superuser)
                        return cast(дол)инфо.f_bfree *  cast(дол)инфо.f_bsize;
                    else
                        return cast(дол)инфо.f_bavail * cast(дол)инфо.f_bsize;
                }

                /***************************************************************

                        Request как large in байты the
                        disk/mountpoint where папка resопрes is.

                        If a quota предел есть_ли for this area, then
                        that quota can be what will be returned unless superuser
                        is установи в_ да. On Posix systems this distinction is not
                        made though.

                        NOTE Access в_ this information when _superuser is
                        установи в_ да may only be available if the program is
                        run in superuser режим.

                        See also: свободноеМесто()

                        Since: 0.99.9

                ***************************************************************/

                static дол всегоМеста(ткст папка, бул superuser = нет)
                {
                    scope fp = new ФПуть(папка);
                    statvfs_t инфо;
                    цел рез = statvfs(fp.исконный.сиТкст.ptr, &инфо);
                    if (рез == -1)
                        исключение ("всегоМеста->statvfs неудачно:"
                                   ~ СисОш.последнСооб);

                    return cast(дол)инфо.f_blocks *  cast(дол)инфо.f_frsize;
                }
        }
}


/******************************************************************************

******************************************************************************/

debug (FSys)
{
        import io.Stdout;

        static проц foo (ФПуть путь)
        {
        Стдвыв("все: ") (путь).нс;
        Стдвыв("путь: ") (путь.путь).нс;
        Стдвыв("файл: ") (путь.файл).нс;
        Стдвыв("папка: ") (путь.папка).нс;
        Стдвыв("имя: ") (путь.имя).нс;
        Стдвыв("расш: ") (путь.расш).нс;
        Стдвыв("суффикс: ") (путь.суффикс).нс.нс;
        }

        проц main() 
        {
        Стдвыв.форматнс ("Пап: {}", ФСистема.дайПапку);

        auto путь = new ФПуть (".");
        foo (путь);

        путь.установи ("..");
        foo (путь); 

        путь.установи ("...");
        foo (путь); 

        путь.установи (r"/x/y/.файл");
        foo (путь); 

        путь.суффикс = ".foo";
        foo (путь);

        путь.установи ("файл.bar");
        путь.абсолютный("c:/префикс");
        foo(путь);

        путь.установи (r"arf/тест");
        foo(путь);
        путь.абсолютный("c:/префикс");
        foo(путь);

        путь.имя = "foo";
        foo(путь);

        путь.суффикс = ".d";
        путь.имя = путь.суффикс;
        foo(путь);

        }
}
