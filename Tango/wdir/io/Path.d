/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved
        copyright:      Normalization & Образцы copyright (c) 2006-2009 
                        Max Samukha, Thomas Kühne, Grzegorz Adam Hankiewicz

        license:        BSD стиль: $(LICENSE)

        version:        Mar 2008: Initial version
                        Oct 2009: добавьed PathUtil код

        A ещё direct route в_ the файл-system than ФПуть. Use this 
        if you don't need путь editing features. For example, if все you 
        want is в_ check some путь есть_ли, using this module would likely 
        be ещё convenient than ФПуть:
        ---
        if (есть_ли ("some/файл/путь")) 
            ...
        ---

        These functions may be less efficient than ФПуть because they 
        generally прикрепи a пусто в_ the имяф for each underlying O/S
        вызов. Use Путь when you need pedestrian access в_ the файл-system, 
        and are not manИПulating the путь components. Use ФПуть where
        путь-editing or mutation is desired.

        We encourage the use of "named import" with this module, such as
        ---
        import Путь = io.Path;

        if (Путь.есть_ли ("some/файл/путь")) 
            ...
        ---

        Also resопрing here is a lightweight путь-парсер, which splits a 
        фпуть преобр_в constituent components. ФПуть is based upon the
        same ПутеПарсер:
        ---
        auto p = Путь.разбор ("some/файл/путь");
        auto путь = p.путь;
        auto имя = p.имя;
        auto суффикс = p.суффикс;
        ...
        ---

        Путь normalization and образец-совпадают is also hosted here via
        the нормализуй() and образец() functions. See the doc towards the
        конец of this module.

        Compile with -version=Win32SansUnicode в_ enable Win95 & Win32s 
        файл support.

*******************************************************************************/

module io.Path;

private import  sys.Common;

public  import  time.Time : Время, ИнтервалВремени;

private import  io.model : ФайлКонст, ИнфОФайле;

public  import  exception : ВВИскл, ИсклНелегальногоАргумента, СисОш;

private import cidrus : memmove;


/*******************************************************************************

        Various imports

*******************************************************************************/

version (Win32)
        {
        version (Win32SansUnicode)
                {
                private extern (C) цел strlen (сим *s);
                private alias WIN32_FIND_DATA FIND_DATA;
                }
             else
                {
                private extern (C) цел wcslen (шим *s);
                private alias WIN32_FIND_DATAW FIND_DATA;
                }
        }

version (Posix)
        {
        private import rt.core.stdc.stdio;
        private import cidrus;
        private import rt.core.stdc.posix.utime;
        private import rt.core.stdc.posix.dirent;
        }


/*******************************************************************************

        Wraps the O/S specific calls with a D API. Note that these прими
        пусто-terminated strings only, which is why it's not public. We need 
        this declared first в_ avoопр forward-reference issues

*******************************************************************************/

package struct ФС
{
        /***********************************************************************

                TimeStamp information. Accurate в_ whatever the F/S supports

        ***********************************************************************/

        struct Штампы
        {
                Время    создан,        /// время создан
                        использовался,       /// последний время использовался
                        изменён;       /// последний время изменён
        }

        /***********************************************************************

                Some fruct glue for дир listings

        ***********************************************************************/

        struct Листинг
        {
                ткст папка;
                бул   всеФайлы;
                
                цел opApply (цел delegate(ref ИнфОФайле) дг)
                {
                        сим[256] врем =void;
                        auto путь = ткт0 (папка, врем);

                        // sanity check on Win32 ...
                        version (Win32)
                                {
                                бул kosher(){foreach (c; путь) if (c is '\\') return нет; return да;};
                                assert (kosher, "попытка использовать нестандартный '\\' в пути при листинге папки");
                                }

                        return список (путь, дг, всеФайлы);
                }
        }

        /***********************************************************************

                Throw an исключение using the последний known ошибка

        ***********************************************************************/

        static проц исключение (ткст имяф)
        {
                исключение (имяф[0..$-1] ~ ": ", СисОш.последнСооб);
        }

        /***********************************************************************

                Throw an IO исключение 

        ***********************************************************************/

        static проц исключение (ткст префикс, ткст ошибка)
        {
                throw new ВВИскл (префикс ~ ошибка);
        }

        /***********************************************************************

                Return an adjusted путь such that non-пустой instances always
                have a trailing разделитель.

                Note: allocates память where путь is not already terminated

        ***********************************************************************/

        static ткст псеп_в_конце (ткст путь, сим c = '/')
        {
                if (путь.length && путь[$-1] != c)
                    путь = путь ~ c;
                return путь;
        }

        /***********************************************************************

                Return an adjusted путь such that non-пустой instances do not
                have a trailing разделитель

        ***********************************************************************/

        static ткст очищенный (ткст путь, сим c = '/')
        {
                if (путь.length && путь[$-1] is c)
                    путь = путь [0 .. $-1];
                return путь;
        }

        /***********************************************************************

                Join a установи of путь specs together. A путь разделитель is
                potentially inserted between each of the segments.

                Note: allocates память

        ***********************************************************************/

        static ткст объедини (ткст[] пути...)
        {
                ткст результат;

                foreach (путь; пути)
                         результат ~= псеп_в_конце (путь);

                return результат.length ? результат [0 .. $-1] : "";
        }

        /***********************************************************************

                Append a terminating пусто onto a ткст, cheaply where 
                feasible

                Note: allocates память where the приёмн is too small

        ***********************************************************************/

        static ткст ткт0 (ткст ист, ткст приёмн)
        {
                auto i = ист.length + 1;
                if (приёмн.length < i)
                    приёмн.length = i;
                приёмн [0 .. i-1] = ист;
                приёмн[i-1] = 0;
                return приёмн [0 .. i];
        }

        /***********************************************************************

                Win32 API код

        ***********************************************************************/

        version (Win32)
        {
                /***************************************************************

                        return a шим[] экземпляр of the путь

                ***************************************************************/

                private static шим[] вТкст16 (шим[] врем, ткст путь)
                {
                        auto i = MultiByteToWideChar (CP_UTF8, 0,
                                                      cast(PCHAR)путь.ptr, путь.length,
                                                      врем.ptr, врем.length);
                        return врем [0..i];
                }

                /***************************************************************

                        return a ткст экземпляр of the путь

                ***************************************************************/

                private static ткст вТкст (ткст врем, шим[] путь)
                {
                        auto i = WideCharToMultiByte (CP_UTF8, 0, путь.ptr, путь.length,
                                                      cast(PCHAR)врем.ptr, врем.length, пусто, пусто);
                        return врем [0..i];
                }

                /***************************************************************

                        Get инфо about this путь

                ***************************************************************/

                private static бул инфОФайле (ткст имя, ref WIN32_FILE_ATTRIBUTE_DATA инфо)
                {
                        version (Win32SansUnicode)
                                {
                                if (! GetFileAttributesExA (имя.ptr, GetFileInfoLevelStandard, &инфо))
                                      return нет;
                                }
                             else
                                {
                                шим[MAX_PATH] врем =void;
                                if (! GetFileAttributesExW (вТкст16(врем, имя).ptr, GetFileInfoLevelStandard, &инфо))
                                      return нет;
                                }

                        return да;
                }

                /***************************************************************

                        Get инфо about this путь

                ***************************************************************/

                private static DWORD дайИнф (ткст имя, ref WIN32_FILE_ATTRIBUTE_DATA инфо)
                {
                        if (! инфОФайле (имя, инфо))
                              исключение (имя);
                        return инфо.dwFileAttributes;
                }

                /***************************************************************

                        Get флаги for this путь

                ***************************************************************/

                private static DWORD дайФлаги (ткст имя)
                {
                        WIN32_FILE_ATTRIBUTE_DATA инфо =void;

                        return дайИнф (имя, инфо);
                }

                /***************************************************************

                        Return whether the файл or путь есть_ли

                ***************************************************************/

                static бул есть_ли (ткст имя)
                {
                        WIN32_FILE_ATTRIBUTE_DATA инфо =void;

                        return инфОФайле (имя, инфо);
                }

                /***************************************************************

                        Return the файл length (in байты)

                ***************************************************************/

                static бдол размерФайла (ткст имя)
                {
                        WIN32_FILE_ATTRIBUTE_DATA инфо =void;

                        дайИнф (имя, инфо);
                        return (cast(бдол) инфо.nFileSizeHigh << 32) +
                                            инфо.nFileSizeLow;
                }

                /***************************************************************

                        Is this файл записываемый?

                ***************************************************************/

                static бул записываем_ли (ткст имя)
                {
                        return (дайФлаги(имя) & FILE_ATTRIBUTE_READONLY) is 0;
                }

                /***************************************************************

                        Is this файл actually a папка/дир?

                ***************************************************************/

                static бул папка_ли (ткст имя)
                {
                        return (дайФлаги(имя) & FILE_ATTRIBUTE_DIRECTORY) != 0;
                }

                /***************************************************************

                        Is this a нормаль файл?

                ***************************************************************/

                static бул файл_ли (ткст имя)
                {
                        return (дайФлаги(имя) & FILE_ATTRIBUTE_DIRECTORY) == 0;
                }

                /***************************************************************

                        Return timestamp information

                        Timestamps are returns in a форматируй dictated by the 
                        файл-system. For example NTFS keeps UTC время, 
                        while FAT timestamps are based on the local время

                ***************************************************************/

                static Штампы штампыВремени (ткст имя)
                {
                        static Время преобразуй (FILETIME время)
                        {
                                return Время (ИнтервалВремени.Эпоха1601 + *cast(дол*) &время);
                        }

                        WIN32_FILE_ATTRIBUTE_DATA инфо =void;
                        Штампы                    время =void;

                        дайИнф (имя, инфо);
                        время.изменён = преобразуй (инфо.ftLastWriteTime);
                        время.использовался = преобразуй (инфо.ftLastAccessTime);
                        время.создан  = преобразуй (инфо.ftCreationTime);
                        return время;
                }

                /***************************************************************

                        Набор the использовался and изменён timestamps of the
                        specified файл

                ***************************************************************/

                static проц штампыВремени (ткст имя, Время использовался, Время изменён)
                {
                        проц установи (HANDLE h)
                        {
                                FILETIME m1, a1;
                                auto m = изменён - Время.эпоха1601;
                                auto a = использовался - Время.эпоха1601;
                                *cast(дол*) &a1.dwLowDateTime = m.тики;
                                *cast(дол*) &m1.dwLowDateTime = m.тики;
                                if (SetFileTime (h, пусто, &a1, &m1) is 0)
                                    исключение (имя);
                        }
                                                
                        создайФайл (имя, &установи);
                }

                /***************************************************************

                        Transfer the контент of другой файл в_ this one. 
                        Throws an ВВИскл upon failure.

                ***************************************************************/

                static проц копируй (ткст ист, ткст приёмн)
                {
                        version (Win32SansUnicode)
                                {
                                if (! CopyFileA (ист.ptr, приёмн.ptr, нет))
                                      исключение (ист);
                                }
                             else
                                {
                                шим[MAX_PATH+1] tmp1 =void;
                                шим[MAX_PATH+1] tmp2 =void;

                                if (! CopyFileW (вТкст16(tmp1, ист).ptr, вТкст16(tmp2, приёмн).ptr, нет))
                                      исключение (ист);
                                }
                }

                /***************************************************************

                        Удали the файл/дир из_ the файл-system.
                        Returns да on success - нет otherwise

                ***************************************************************/

                static бул удали (ткст имя)
                {
                        if (папка_ли(имя))
                           {
                           version (Win32SansUnicode)
                                    return RemoveDirectoryA (имя.ptr) != 0;
                                else
                                   {
                                   шим[MAX_PATH] врем =void;
                                   return RemoveDirectoryW (вТкст16(врем, имя).ptr) != 0;
                                   }
                           }
                        else
                           version (Win32SansUnicode)
                                    return DeleteFileA (имя.ptr) != 0;
                                else
                                   {
                                   шим[MAX_PATH] врем =void;
                                   return DeleteFileW (вТкст16(врем, имя).ptr) != 0;
                                   }
                }

                /***************************************************************

                       Change the имя or location of a файл/дир

                ***************************************************************/

                static проц переименуй (ткст ист, ткст приёмн)
                {
                        const цел Typical = MOVEFILE_REPLACE_EXISTING +
                                            MOVEFILE_COPY_ALLOWED     +
                                            MOVEFILE_WRITE_THROUGH;

                        цел результат;
                        version (Win32SansUnicode)
                                 результат = MoveFileExA (ист.ptr, приёмн.ptr, Typical);
                             else
                                {
                                шим[MAX_PATH] tmp1 =void;
                                шим[MAX_PATH] tmp2 =void;
                                результат = MoveFileExW (вТкст16(tmp1, ист).ptr, вТкст16(tmp2, приёмн).ptr, Typical);
                                }

                        if (! результат)
                              исключение (ист);
                }

                /***************************************************************

                        Create a new файл

                ***************************************************************/

                static проц создайФайл (ткст имя)
                {
                        создайФайл (имя, пусто);
                }

                /***************************************************************

                        Create a new дир

                ***************************************************************/

                static проц создайПапку (ткст имя)
                {
                        version (Win32SansUnicode)
                                {
                                if (! CreateDirectoryA (имя.ptr, пусто))
                                      исключение (имя);
                                }
                             else
                                {
                                шим[MAX_PATH] врем =void;
                                if (! CreateDirectoryW (вТкст16(врем, имя).ptr, пусто))
                                      исключение (имя);
                                }
                }

                /***************************************************************

                        List the установи of filenames within this папка.

                        Each путь and имяф is passed в_ the provопрed
                        delegate, along with the путь префикс and whether
                        the Запись is a папка or not.

                        Note: allocates a small память буфер

                ***************************************************************/

                static цел список (ткст папка, цел delegate(ref ИнфОФайле) дг, бул все=нет)
                {
                        HANDLE                  h;
                        цел                     возвр;
                        ткст                  префикс;
                        сим[MAX_PATH+1]        врем =void;
                        FIND_DATA               fileinfo =void;
                        
                        version (Win32SansUnicode)
                                 alias сим T;
                              else
                                 alias шим T;

                        цел следщ()
                        {
                                version (Win32SansUnicode)
                                         return FindNextFileA (h, &fileinfo);
                                   else
                                      return FindNextFileW (h, &fileinfo);
                        }

                        static T[] псеп_в_конце (T[] s, T[] расш)
                        {
                                if (s.length && s[$-1] is '/')
                                    return s ~ расш;
                                return s ~ "/" ~ расш;
                        }

                        version (Win32SansUnicode)
                                 h = FindFirstFileA (псеп_в_конце(папка[0..$-1], "*\0").ptr, &fileinfo);
                             else
                                {
                                шим[MAX_PATH] хост =void;
                                h = FindFirstFileW (псеп_в_конце(вТкст16(хост, папка[0..$-1]), "*\0").ptr, &fileinfo);
                                }

                        if (h is INVALID_HANDLE_VALUE)
                            return возвр; 

                        scope (exit)
                               FindClose (h);

                        префикс = ФС.псеп_в_конце (папка[0..$-1]);
                        do {
                           version (Win32SansUnicode)
                                   {
                                   auto длин = strlen (fileinfo.cFileName.ptr);
                                   auto ткт = fileinfo.cFileName.ptr [0 .. длин];
                                   }
                                else
                                   {
                                   auto длин = wcslen (fileinfo.cFileName.ptr);
                                   auto ткт = вТкст (врем, fileinfo.cFileName [0 .. длин]);
                                   }

                           // пропусти скрытый/system файлы
                           if (все || (fileinfo.dwFileAttributes & (FILE_ATTRIBUTE_SYSTEM | FILE_ATTRIBUTE_HIDDEN)) is 0)
                              {
                              ИнфОФайле инфо =void;
                              инфо.имя   = ткт;
                              инфо.путь   = префикс;
                              инфо.байты  = (cast(бдол) fileinfo.nFileSizeHigh << 32) + fileinfo.nFileSizeLow;
                              инфо.папка = (fileinfo.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) != 0;
                              инфо.скрытый = (fileinfo.dwFileAttributes & FILE_ATTRIBUTE_HIDDEN) != 0;
                              инфо.системный = (fileinfo.dwFileAttributes & FILE_ATTRIBUTE_SYSTEM) != 0;

                              // пропусти "..." names
                              if (ткт.length > 3 || ткт != "..."[0 .. ткт.length])
                                  if ((возвр = дг(инфо)) != 0)
                                       break;
                              }
                           } while (следщ);

                        return возвр;
                }

                /***************************************************************

                        Create a new файл

                ***************************************************************/

                private static проц создайФайл (ткст имя, проц delegate(HANDLE) дг)
                {
                        HANDLE h;

                        auto флаги = дг.ptr ? OPEN_EXISTING : CREATE_ALWAYS;
                        version (Win32SansUnicode)
                                 h = CreateFileA (имя.ptr, GENERIC_WRITE,
                                                  0, пусто, флаги, FILE_ATTRIBUTE_NORMAL, 
                                                  cast(HANDLE) 0);
                             else
                                {
                                шим[MAX_PATH] врем =void;
                                h = CreateFileW (вТкст16(врем, имя).ptr, GENERIC_WRITE,
                                                 0, пусто, флаги, FILE_ATTRIBUTE_NORMAL, 
                                                 cast(HANDLE) 0);
                                }

                        if (h is INVALID_HANDLE_VALUE)
                            исключение (имя);

                        if (дг.ptr)
                            дг(h);

                        if (! CloseHandle (h))
                              исключение (имя);
                }
        }

        /***********************************************************************

                Posix-specific код

        ***********************************************************************/

        version (Posix)
        {
                /***************************************************************

                        Get инфо about this путь

                ***************************************************************/

                private static бцел дайИнф (ткст имя, ref stat_t статс)
                {
                        if (posix.stat (имя.ptr, &статс))
                            исключение (имя);

                        return статс.st_mode;
                }

                /***************************************************************

                        Return whether the файл or путь есть_ли

                ***************************************************************/

                static бул есть_ли (ткст имя)
                {
                        stat_t статс =void;
                        return posix.stat (имя.ptr, &статс) is 0;
                }

                /***************************************************************

                        Return the файл length (in байты)

                ***************************************************************/

                static бдол размерФайла (ткст имя)
                {
                        stat_t статс =void;

                        дайИнф (имя, статс);
                        return cast(бдол) статс.st_size;
                }

                /***************************************************************

                        Is this файл записываемый?

                ***************************************************************/

                static бул записываем_ли (ткст имя)
                {
                        stat_t статс =void;

                        return (дайИнф(имя, статс) & O_RDONLY) is 0;
                }

                /***************************************************************

                        Is this файл actually a папка/дир?

                ***************************************************************/

                static бул папка_ли (ткст имя)
                {
                        stat_t статс =void;

                        return (дайИнф(имя, статс) & S_IFMT) is S_IFDIR;
                }

                /***************************************************************

                        Is this a нормаль файл?

                ***************************************************************/

                static бул файл_ли (ткст имя)
                {
                        stat_t статс =void;

                        return (дайИнф(имя, статс) & S_IFMT) is S_IFREG;
                }

                /***************************************************************

                        Return timestamp information

                        Timestamps are returns in a форматируй dictated by the 
                        файл-system. For example NTFS keeps UTC время, 
                        while FAT timestamps are based on the local время

                ***************************************************************/

                static Штампы штампыВремени (ткст имя)
                {
                        static Время преобразуй (typeof(stat_t.st_mtime) секунды)
                        {
                                return Время.epoch1970 +
                                       ИнтервалВремени.изСек(секунды);
                        }

                        stat_t статс =void;
                        Штампы время  =void;

                        дайИнф (имя, статс);

                        время.изменён = преобразуй (статс.st_mtime);
                        время.использовался = преобразуй (статс.st_atime);
                        время.создан  = преобразуй (статс.st_ctime);
                        return время;
                }

                /***************************************************************

                        Набор the использовался and изменён timestamps of the
                        specified файл

                ***************************************************************/

                static проц штампыВремени (ткст имя, Время использовался, Время изменён)
                {
                        utimbuf время =void;
                        время.actime = (использовался - Время.epoch1970).сек;
                        время.modtime = (изменён - Время.epoch1970).сек;
                        if (utime (имя.ptr, &время) is -1)
                            исключение (имя);
                }

                /***********************************************************************

                        Transfer the контент of другой файл в_ this one. Returns a
                        reference в_ this class on success, or throws an ВВИскл
                        upon failure.

                        Note: allocates a память буфер

                ***********************************************************************/

                static проц копируй (ткст источник, ткст приёмник)
                {
                        auto ист = posix.открой (источник.ptr, O_RDONLY, 0640);
                        scope (exit)
                               if (ист != -1)
                                   posix.закрой (ист);

                        auto приёмн = posix.открой (приёмник.ptr, O_CREAT | O_RDWR, 0660);
                        scope (exit)
                               if (приёмн != -1)
                                   posix.закрой (приёмн);

                        if (ист is -1 || приёмн is -1)
                            исключение (источник);

                        // копируй контент
                        ббайт[] буф = new ббайт [16 * 1024];
                        цел читай = posix.читай (ист, буф.ptr, буф.length);
                        while (читай > 0)
                              {
                              auto p = буф.ptr;
                              do {
                                 цел записано = posix.пиши (приёмн, p, читай);
                                 p += записано;
                                 читай -= записано;
                                 if (записано is -1)
                                     исключение (приёмник);
                                 } while (читай > 0);
                              читай = posix.читай (ист, буф.ptr, буф.length);
                              }
                        if (читай is -1)
                            исключение (источник);

                        // копируй timestamps
                        stat_t статс;
                        if (posix.stat (источник.ptr, &статс))
                            исключение (источник);

                        utimbuf utim;
                        utim.actime = статс.st_atime;
                        utim.modtime = статс.st_mtime;
                        if (utime (приёмник.ptr, &utim) is -1)
                            исключение (приёмник);
                }

                /***************************************************************

                        Удали the файл/дир из_ the файл-system. 
                        Returns да on success - нет otherwise.

                ***************************************************************/

                static бул удали (ткст имя)
                {
                        return rt.core.stdc.stdio.удали(имя.ptr) != -1;
                }

                /***************************************************************

                       change the имя or location of a файл/дир

                ***************************************************************/

                static проц переименуй (ткст ист, ткст приёмн)
                {
                        if (rt.core.stdc.stdio.переименуй (ист.ptr, приёмн.ptr) is -1)
                            исключение (ист);
                }

                /***************************************************************

                        Create a new файл

                ***************************************************************/

                static проц создайФайл (ткст имя)
                {
                        цел fd;

                        fd = posix.открой (имя.ptr, O_CREAT | O_WRONLY | O_TRUNC, 0660);
                        if (fd is -1)
                            исключение (имя);

                        if (posix.закрой(fd) is -1)
                            исключение (имя);
                }

                /***************************************************************

                        Create a new дир

                ***************************************************************/

                static проц создайПапку (ткст имя)
                {
                        if (posix.mkdir (имя.ptr, 0777))
                            исключение (имя);
                }

                /***************************************************************

                        List the установи of filenames within this папка.

                        Each путь and имяф is passed в_ the provопрed
                        delegate, along with the путь префикс and whether
                        the Запись is a папка or not.

                        Note: allocates and reuses a small память буфер

                ***************************************************************/

                static цел список (ткст папка, цел delegate(ref ИнфОФайле) дг, бул все=нет)
                {
                        цел             возвр;
                        Пап*            пап;
                        dirent          Запись;
                        dirent*         pentry;
                        stat_t          sbuf;
                        ткст          префикс;
                        ткст          sfnbuf;

                        пап = rt.core.stdc.posix.dirent.opendir (папка.ptr);
                        if (! пап)
                              return возвр;

                        scope (exit)
                               rt.core.stdc.posix.dirent.closedir (пап);

                        // ensure a trailing '/' is present
                        префикс = ФС.псеп_в_конце (папка[0..$-1]);

                        // prepare our имяф буфер
                        sfnbuf = префикс.dup;
                        
                        while (да)
                              {
                              // pentry is пусто at конец of listing, or on an ошибка 
                              reдобавьir_r (пап, &Запись, &pentry);
                              if (pentry is пусто)
                                  break;

                              auto длин = cidrus.strlen (Запись.d_name.ptr);
                              auto ткт = Запись.d_name.ptr [0 .. длин];
                              ++длин;  // include the пусто

                              // resize the буфер as necessary ...
                              if (sfnbuf.length < префикс.length + длин)
                                  sfnbuf.length = префикс.length + длин;

                              sfnbuf [префикс.length .. префикс.length + длин]
                                      = Запись.d_name.ptr [0 .. длин];

                              // пропусти "..." names
                              if (ткт.length > 3 || ткт != "..."[0 .. ткт.length])
                                 {
                                 ИнфОФайле инфо =void;
                                 инфо.байты  = 0;
                                 инфо.имя   = ткт;
                                 инфо.путь   = префикс;
                                 инфо.скрытый = ткт[0] is '.';
                                 инфо.папка = инфо.системный = нет;
                                 
                                 if (! stat (sfnbuf.ptr, &sbuf))
                                    {
                                    инфо.папка = (sbuf.st_mode & S_IFDIR) != 0;
                                    if (инфо.папка is нет)
                                        if ((sbuf.st_mode & S_IFREG) is 0)
                                             инфо.системный = да;
                                        else
                                           инфо.байты = cast(бдол) sbuf.st_size;
                                    }
                                 if (все || (инфо.скрытый | инфо.системный) is нет)
                                     if ((возвр = дг(инфо)) != 0)
                                          break;
                                 }
                              }
                        return возвр;
                }
        }
}


/*******************************************************************************

        Parse a файл путь

        Файл пути containing non-ansi characters should be UTF-8 кодирован.
        Supporting Unicode in this manner was deemed в_ be ещё suitable
        than provопрing a шим version of ПутеПарсер, and is Всё consistent
        & compatible with the approach taken with the Уир class.

        Note that образцы of adjacent '.' разделители are treated specially
        in that they will be assigned в_ the имя where there is no distinct
        суффикс. In добавьition, a '.' at the старт of a имя signifies it does 
        not belong в_ the суффикс i.e. ".файл" is a имя rather than a суффикс.
        Образцы of intermediate '.' characters will otherwise be assigned
        в_ the суффикс, such that "файл....суффикс" включает the dots within
        the суффикс itself. See метод расш() for a суффикс without dots.

        Note also that normalization of путь-разделители does *not* occur by 
        default. This means that usage of '\' characters should be explicitly
        преобразованый beforehand преобр_в '/' instead (an исключение is thrown in those
        cases where '\' is present). On-the-fly conversion is avoопрed because
        (a) the provопрed путь is consопрered immutable and (b) we avoопр taking
        a копируй of the original путь. Module ФПуть есть_ли at a higher уровень, 
        without such contraints.

*******************************************************************************/

struct ПутеПарсер
{       
        package ткст  fp;                     // фпуть with trailing
        package цел     end_,                   // before any trailing 0
                        ext_,                   // after rightmost '.'
                        name_,                  // файл/Пап имя
                        folder_,                // путь before имя
                        suffix_;                // включая leftmost '.'

        /***********************************************************************

                Parse the путь spec

        ***********************************************************************/

        ПутеПарсер разбор (ткст путь)
        {
                return разбор (путь, путь.length);
        }

        /***********************************************************************

                Duplicate this путь

                Note: allocates память for the путь контент

        ***********************************************************************/

        ПутеПарсер dup ()
        {
                auto возвр = *this;
                возвр.fp = fp.dup;
                return возвр;
        }

        /***********************************************************************

                Return the complete текст of this фпуть

        ***********************************************************************/

        ткст вТкст ()
        {
                return fp [0 .. end_];
        }

        /***********************************************************************

                Return the корень of this путь. Roots are constructs such as
                "c:"

        ***********************************************************************/

        ткст корень ()
        {
                return fp [0 .. folder_];
        }

        /***********************************************************************

                Return the файл путь. Paths may старт and конец with a "/".
                The корень путь is "/" and an unspecified путь is returned as
                an пустой ткст. Directory пути may be разбей such that the
                дир имя is placed преобр_в the 'имя' member; дир
                пути are treated no differently than файл пути

        ***********************************************************************/

        ткст папка ()
        {
                return fp [folder_ .. name_];
        }

        /***********************************************************************

                Returns a путь representing the предок of this one. This
                will typically return the current путь component, though
                with a special case where the имя component is пустой. In 
                such cases, the путь is scanned for a prior segment:
                ---
                нормаль:  /x/y/z => /x/y
                special: /x/y/  => /x
                нормаль:  /x     => /
                нормаль:  /      => [пустой]
                ---

                Note that this returns a путь suitable for splitting преобр_в
                путь and имя components (there's no trailing разделитель).

        ***********************************************************************/

        ткст предок ()
        {
                auto p = путь;
                if (имя.length is 0)
                    for (цел i=p.length-1; --i > 0;)
                         if (p[i] is ФайлКонст.СимПутьРазд)
                            {
                            p = p[0 .. i];
                            break;
                            }
                return ФС.очищенный (p);
        }

        /***********************************************************************

                Pop the rightmost element off this путь, strИПping off a
                trailing '/' as appropriate:
                ---
                /x/y/z => /x/y
                /x/y/  => /x/y  (note trailing '/' in the original)
                /x/y   => /x
                /x     => /
                /      => [пустой]
                ---

                Note that this returns a путь suitable for splitting преобр_в
                путь and имя components (there's no trailing разделитель).

        ***********************************************************************/

        ткст вынь ()
        {
                return ФС.очищенный (путь);
        }

        /***********************************************************************

                Return the имя of this файл, or дир.

        ***********************************************************************/

        ткст имя ()
        {
                return fp [name_ .. suffix_];
        }

        /***********************************************************************

                Ext is the хвост of the имяф, rightward of the rightmost
                '.' разделитель e.g. путь "foo.bar" есть расш "bar". Note that
                образцы of adjacent разделители are treated specially - for
                example, ".." will wind up with no расш at все

        ***********************************************************************/

        ткст расш ()
        {
                auto x = суффикс;
                if (x.length)
                   {
                   if (ext_ is 0)
                       foreach (c; x)
                                if (c is '.')
                                    ++ext_;
                                else
                                   break;
                   x = x [ext_ .. $];
                   }
                return x;
        }

        /***********************************************************************

                Suffix is like расш, but включает the разделитель e.g. путь
                "foo.bar" есть суффикс ".bar"

        ***********************************************************************/

        ткст суффикс ()
        {
                return fp [suffix_ .. end_];
        }

        /***********************************************************************

                return the корень + папка combination

        ***********************************************************************/

        ткст путь ()
        {
                return fp [0 .. name_];
        }

        /***********************************************************************

                return the имя + суффикс combination

        ***********************************************************************/

        ткст файл ()
        {
                return fp [name_ .. end_];
        }

        /***********************************************************************

                Returns да if this путь is *not* relative в_ the
                current working дир

        ***********************************************************************/

        бул абс_ли ()
        {
                return (folder_ > 0) ||
                       (folder_ < end_ && fp[folder_] is ФайлКонст.СимПутьРазд);
        }

        /***********************************************************************

                Returns да if this ФПуть is пустой

        ***********************************************************************/

        бул пуст_ли ()
        {
                return end_ is 0;
        }

        /***********************************************************************

                Returns да if this путь есть a предок. Note that a
                предок is defined by the presence of a путь-разделитель in
                the путь. This means 'foo' within "/foo" is consопрered a
                ветвь of the корень

        ***********************************************************************/

        бул ветвь_ли ()
        {
                return папка.length > 0;
        }

        /***********************************************************************

                Does this путь equate в_ the given текст? We ignore trailing
                путь-разделители when testing equivalence

        ***********************************************************************/

        цел opEquals (ткст s)
        {       
                return ФС.очищенный(s) == ФС.очищенный(вТкст);
        }

        /***********************************************************************

                Parse the путь spec with explicit конец точка. A '\' is 
                consопрered illegal in the путь and should be normalized
                out before this is invoked (the контент managed here is
                consопрered immutable, and thus cannot be изменён by this
                function)

        ***********************************************************************/

        package ПутеПарсер разбор (ткст путь, т_мера конец)
        {
                end_ = конец;
                fp = путь;
                folder_ = 0;
                name_ = suffix_ = -1;

                for (цел i=end_; --i >= 0;)
                     switch (fp[i])
                            {
                            case ФайлКонст.СимФайлРазд:
                                 if (name_ < 0)
                                     if (suffix_ < 0 && i && fp[i-1] != '.')
                                         suffix_ = i;
                                 break;

                            case ФайлКонст.СимПутьРазд:
                                 if (name_ < 0)
                                     name_ = i + 1;
                                 break;

                            // Windows файл разделители are illegal. Use
                            // стандарт() or equivalent в_ преобразуй first
                            case '\\':
                                 ФС.исключение ("неожиданный '\\' символ в пути: ", путь[0..конец]);

                            version (Win32)
                            {
                            case ':':
                                 folder_ = i + 1;
                                 break;
                            }

                            default:
                                 break;
                            }

                if (name_ < 0)
                    name_ = folder_;

                if (suffix_ < 0 || suffix_ is name_)
                    suffix_ = end_;

                return *this;
        }
}


/*******************************************************************************

        Does this путь currently exist?

*******************************************************************************/

бул есть_ли (ткст имя)
{
        сим[512] врем =void;
        return ФС.есть_ли (ФС.ткт0(имя, врем));
}

/*******************************************************************************

        Returns the время of the последний modification. Accurate
        в_ whatever the F/S supports, and in a форматируй dictated
        by the файл-system. For example NTFS keeps UTC время, 
        while FAT timestamps are based on the local время. 

*******************************************************************************/

Время изменён (ткст имя)
{       
        return штампыВремени(имя).изменён;
}

/*******************************************************************************

        Returns the время of the последний access. Accurate в_
        whatever the F/S supports, and in a форматируй dictated
        by the файл-system. For example NTFS keeps UTC время, 
        while FAT timestamps are based on the local время.

*******************************************************************************/

Время использовался (ткст имя)
{
        return штампыВремени(имя).использовался;
}

/*******************************************************************************

        Returns the время of файл creation. Accurate в_
        whatever the F/S supports, and in a форматируй dictated
        by the файл-system. For example NTFS keeps UTC время,  
        while FAT timestamps are based on the local время.

*******************************************************************************/

Время создан (ткст имя)
{
        return штампыВремени(имя).создан;
}

/*******************************************************************************

        Return the файл length (in байты)

*******************************************************************************/

бдол размерФайла (ткст имя)
{
        сим[512] врем =void;
        return ФС.размерФайла (ФС.ткт0(имя, врем));
}

/*******************************************************************************

        Is this файл записываемый?

*******************************************************************************/

бул записываем_ли (ткст имя)
{
        сим[512] врем =void;
        return ФС.записываем_ли (ФС.ткт0(имя, врем));
}

/*******************************************************************************

        Is this файл actually a папка/дир?

*******************************************************************************/

бул папка_ли (ткст имя)
{
        сим[512] врем =void;
        return ФС.папка_ли (ФС.ткт0(имя, врем));
}

/*******************************************************************************

        Is this файл actually a нормаль файл?
        Not a дир or (on unix) a устройство файл or link.

*******************************************************************************/

бул файл_ли (ткст имя)
{
        сим[512] врем =void;
        return ФС.файл_ли (ФС.ткт0(имя, врем));
}

/*******************************************************************************

        Return timestamp information

        Timestamps are returns in a форматируй dictated by the 
        файл-system. For example NTFS keeps UTC время, 
        while FAT timestamps are based on the local время

*******************************************************************************/

ФС.Штампы штампыВремени (ткст имя)
{
        сим[512] врем =void;
        return ФС.штампыВремени (ФС.ткт0(имя, врем));
}

/*******************************************************************************

        Набор the использовался and изменён timestamps of the specified файл

        Since 0.99.9

*******************************************************************************/

проц штампыВремени (ткст имя, Время использовался, Время изменён)
{
        сим[512] врем =void;
        ФС.штампыВремени (ФС.ткт0(имя, врем), использовался, изменён);
}

/*******************************************************************************

        Удали the файл/дир из_ the файл-system. Returns да if
        successful, нет otherwise

*******************************************************************************/

бул удали (ткст имя)
{      
        сим[512] врем =void;
        return ФС.удали (ФС.ткт0(имя, врем));
}

/*******************************************************************************

        Удали the файлы and папки listed in the provопрed пути. Where
        папки are listed, they should be preceded by their contained
        файлы in order в_ be successfully removed. Returns a установи of пути
        that неудачно в_ be removed (where .length is zero upon success).

        The коллируй() function can be used в_ provопрe the ввод пути:
        ---
        удали (коллируй (".", "*.d", да));
        ---

        Use with great caution

        Note: may размести память

        Since: 0.99.9

*******************************************************************************/

ткст[] удали (ткст[] пути)
{     
        ткст[] неудачно;
        foreach (путь; пути)
                 if (! удали (путь))
                       неудачно ~= путь;
        return неудачно;
}

/*******************************************************************************

        Create a new файл

*******************************************************************************/

проц создайФайл (ткст имя)
{
        сим[512] врем =void;
        ФС.создайФайл (ФС.ткт0(имя, врем));
}

/*******************************************************************************

        Create a new дир

*******************************************************************************/

проц создайПапку (ткст имя)
{
        сим[512] врем =void;
        ФС.создайПапку (ФС.ткт0(имя, врем));
}

/*******************************************************************************

        Create an entire путь consisting of this папка along with
        все предок папки. The путь should not contain '.' or '..'
        segments, which can be removed via the нормализуй() function.

        Note that each segment is создан as a папка, включая the
        trailing segment.

        Throws: ВВИскл upon system ошибки

        Throws: ИсклНелегальногоАргумента if a segment есть_ли but as a 
        файл instead of a папка

*******************************************************************************/

проц создайПуть (ткст путь)
{
        проц тест (ткст segment)
        {
                if (segment.length)
                    if (! есть_ли (segment))
                          создайПапку (segment);
                    else
                       if (! папка_ли (segment))
                             throw new ИсклНелегальногоАргумента ("Путь.создайПуть :: файл/папка конфликтуют: " ~ segment);
        }

        foreach (i, сим c; путь)
                 if (c is '/')
                     тест (путь [0 .. i]);
        тест (путь);
}

/*******************************************************************************

       change the имя or location of a файл/дир

*******************************************************************************/

проц переименуй (ткст ист, ткст приёмн)
{
        сим[512] tmp1 =void;
        сим[512] tmp2 =void;
        ФС.переименуй (ФС.ткт0(ист, tmp1), ФС.ткт0(приёмн, tmp2));
}

/*******************************************************************************

        Transfer the контент of one файл в_ другой. Throws 
        an ВВИскл upon failure.

*******************************************************************************/

проц копируй (ткст ист, ткст приёмн)
{
        сим[512] tmp1 =void;
        сим[512] tmp2 =void;
        ФС.копируй (ФС.ткт0(ист, tmp1), ФС.ткт0(приёмн, tmp2));
}

/*******************************************************************************

        Provопрes foreach support via a fruct, as in
        ---
        foreach (инфо; ветви("myfolder"))
                 ...
        ---

        Each путь and имяф is passed в_ the foreach
        delegate, along with the путь префикс and whether
        the Запись is a папка or not. The инфо construct
        exposes the following атрибуты:
        ---
        ткст  путь
        ткст  имя
        бдол   байты
        бул    папка
        ---

        Аргумент 'все' controls whether скрытый and system 
        файлы are included - these are ignored by default

*******************************************************************************/

ФС.Листинг ветви (ткст путь, бул все=нет)
{
        return ФС.Листинг (путь, все);
}

/*******************************************************************************

        коллируй все файлы and папки из_ the given путь whose имя matches
        the given образец. Folders will be traversed where рекурсия is включен, 
        and a установи of совпадают names is returned as filepaths (включая those 
        папки which match the образец)

        Note: allocates память for returned пути

        Since: 0.99.9

*******************************************************************************/

ткст[] коллируй (ткст путь, ткст образец, бул рекурсия=нет)
{      
        ткст[] список;

        foreach (инфо; ветви (путь))
                {
                if (инфо.папка && рекурсия)
                    список ~= коллируй (объедини(инфо.путь, инфо.имя), образец, да);

                if (совпадение (инфо.имя, образец))
                    список ~= объедини (инфо.путь, инфо.имя);
                }
        return список;
}

/*******************************************************************************

        Join a установи of путь specs together. A путь разделитель is
        potentially inserted between each of the segments.

        Note: may размести память

*******************************************************************************/

ткст объедини (ткст[] пути...)
{
        return ФС.объедини (пути);
}

/*******************************************************************************

        Convert путь разделители в_ a стандарт форматируй, using '/' as
        the путь разделитель. This is compatible with Уир and все of 
        the contemporary O/S which Dinrus supports. Known exceptions
        include the Windows команда-строка процессор, which consопрers
        '/' characters в_ be switches instead. Use the исконный()
        метод в_ support that.

        Note: mutates the provопрed путь.

*******************************************************************************/

ткст стандарт (ткст путь)
{
        return замени (путь, '\\', '/');
}

/*******************************************************************************

        Convert в_ исконный O/S путь разделители where that is required,
        such as when dealing with the Windows команда-строка. 
        
        Note: mutates the provопрed путь. Use this образец в_ obtain a 
        копируй instead: исконный(путь.dup);

*******************************************************************************/

ткст исконный (ткст путь)
{
        version (Win32)
                 замени (путь, '/', '\\');
        return путь;
}

/*******************************************************************************

        Returns a путь representing the предок of this one, with a special 
        case concerning a trailing '/':
        ---
        нормаль:  /x/y/z => /x/y
        нормаль:  /x/y/  => /x/y
        special: /x/y/  => /x
        нормаль:  /x     => /
        нормаль:  /      => пустой
        ---

        The результат can be разбей via разбор()

*******************************************************************************/

ткст предок (ткст путь)
{
        return вынь (ФС.очищенный (путь));
}

/*******************************************************************************

        Returns a путь representing the предок of this one:
        ---
        нормаль:  /x/y/z => /x/y
        нормаль:  /x/y/  => /x/y
        нормаль:  /x     => /
        нормаль:  /      => пустой
        ---

        The результат can be разбей via разбор()

*******************************************************************************/

ткст вынь (ткст путь)
{
        цел i = путь.length;
        while (i && путь[--i] != '/') {}
        return путь [0..i];
}

/*******************************************************************************

        Break a путь преобр_в "голова" and "хвост" components. For example: 
        ---
        "/a/b/c" -> "/a","b/c" 
        "a/b/c" -> "a","b/c" 
        ---

*******************************************************************************/

ткст разбей (ткст путь, out ткст голова, out ткст хвост)
{
        голова = путь;
        if (путь.length > 1)
            foreach (i, сим c; путь[1..$])
                     if (c is '/')
                        {
                        голова = путь [0 .. i+1];
                        хвост = путь [i+2 .. $];
                        break;
                        }
        return путь;
}

/*******************************************************************************

        Замени все путь 'из_' instances with 'в_', in place (overwrites
        the provопрed путь)

*******************************************************************************/

ткст замени (ткст путь, сим из_, сим в_)
{
        foreach (ref сим c; путь)
                 if (c is из_)
                     c = в_;
        return путь;
}

/*******************************************************************************

        Parse a путь преобр_в its constituent components. 
        
        Note that the provопрed путь is sliced, not duplicated

*******************************************************************************/

ПутеПарсер разбор (ткст путь)
{
        ПутеПарсер p;
        
        p.разбор (путь);
        return p;
}

/*******************************************************************************

*******************************************************************************/

debug(UnitTest)
{
        unittest
        {
                auto p = разбор ("/foo/bar/файл.расш");
                assert (p == "/foo/bar/файл.расш");
                assert (p.папка == "/foo/bar/");
                assert (p.путь == "/foo/bar/");
                assert (p.файл == "файл.расш");
                assert (p.имя == "файл");
                assert (p.суффикс == ".расш");
                assert (p.расш == "расш");
                assert (p.ветвь_ли == да);
                assert (p.пуст_ли == нет);
                assert (p.абс_ли == да);
        }
}


/******************************************************************************

        Matches a образец against a имяф.

        Some characters of образец have special a meaning (they are
        <i>meta-characters</i>) and <b>can't</b> be escaped. These are:
        <p><table>
        <tr><td><b>*</b></td>
        <td>Matches 0 or ещё instances of any character.</td></tr>
        <tr><td><b>?</b></td>
        <td>Matches exactly one instances of any character.</td></tr>
        <tr><td><b>[</b><i>симвы</i><b>]</b></td>
        <td>Matches one экземпляр of any character that appears
        between the brackets.</td></tr>
        <tr><td><b>[!</b><i>симвы</i><b>]</b></td>
        <td>Matches one экземпляр of any character that does not appear
        between the brackets after the exclamation метка.</td></tr>
        </table><p>
        Internally indivопрual character comparisons are готово calling
        charMatch(), so its rules apply here too. Note that путь
        разделители and dots don't stop a meta-character из_ совпадают
        further portions of the имяф.

        Возвращает: да if образец matches имяф, нет otherwise.

        Throws: Nothing.
        -----
        version (Win32)
                {
                совпадение("foo.bar", "*") // => да
                совпадение(r"foo/foo\bar", "f*b*r") // => да
                совпадение("foo.bar", "f?bar") // => нет
                совпадение("Goo.bar", "[fg]???bar") // => да
                совпадение(r"d:\foo\bar", "d*foo?bar") // => да
                }
        version (Posix)
                {
                совпадение("Go*.bar", "[fg]???bar") // => нет
                совпадение("/foo*home/bar", "?foo*bar") // => да
                совпадение("fСПДar", "foo?bar") // => да
                }
        -----
    
******************************************************************************/

бул совпадение (ткст имяф, ткст образец)
in
{
        // Verify that образец[] is valid
        бул inbracket = нет;
        for (auto i=0; i < образец.length; i++)
            {
            switch (образец[i])
                   {
                   case '[':
                        assert(!inbracket);
                        inbracket = да;
                        break;
                   case ']':
                        assert(inbracket);
                        inbracket = нет;
                        break;
                   default:
                        break;
                   }
            }
}
body
{
        цел pi;
        цел ni;
        сим pc;
        сим nc;
        цел j;
        цел not;
        цел anymatch;

        бул charMatch (сим c1, сим c2)
        {
        version (Win32)
                {
                if (c1 != c2)
				if(bool рез =((c1 >= 'a' && c1 <= 'z') ? c1 - ('a' - 'A') : c1) ==
                           ((c2 >= 'a' && c2 <= 'z') ? c2 - ('a' - 'A') : c2)) return рез;
						else return ((c1 >= 'а' && c1 <= 'я') ? c1 - ('а' - 'А') : c1) ==
                           ((c2 >= 'а' && c2 <= 'я') ? c2 - ('а' - 'А') : c2);
                return да;
                }
        version (Posix)
                 return c1 == c2;
        }

        ni = 0;
        for (pi = 0; pi < образец.length; pi++)
            {
            pc = образец [pi];
            switch (pc)
                   {
                   case '*':
                        if (pi + 1 == образец.length)
                            goto match;
                        for (j = ni; j < имяф.length; j++)
                            {
                            if (совпадение(имяф[j .. имяф.length],
                                образец[pi + 1 .. образец.length]))
                               goto match;
                            }
                        goto nomatch;

                   case '?':
                        if (ni == имяф.length)
                            goto nomatch;
                        ni++;
                        break;

                   case '[':
                        if (ni == имяф.length)
                            goto nomatch;
                        nc = имяф[ni];
                        ni++;
                        not = 0;
                        pi++;
                        if (образец[pi] == '!')
                           {
                           not = 1;
                           pi++;
                           }
                        anymatch = 0;
                        while (1)
                              {
                              pc = образец[pi];
                              if (pc == ']')
                                  break;
                              if (!anymatch && charMatch(nc, pc))
                                   anymatch = 1;
                              pi++;
                              }
                        if (!(anymatch ^ not))
                              goto nomatch;
                        break;

                   default:
                        if (ni == имяф.length)
                            goto nomatch;
                        nc = имяф[ni];
                        if (!charMatch(pc, nc))
                             goto nomatch;
                        ni++;
                        break;
                   }
            }
        if (ni < имяф.length)
            goto nomatch;

        match:
            return да;

        nomatch:
            return нет;
}

/*******************************************************************************

*******************************************************************************/

debug (UnitTest)
{
        unittest
        {
        version (Win32)
        assert(совпадение("foo", "Foo"));
        version (Posix)
        assert(!совпадение("foo", "Foo"));
        
        assert(совпадение("foo", "*"));
        assert(совпадение("foo.bar", "*"));
        assert(совпадение("foo.bar", "*.*"));
        assert(совпадение("foo.bar", "foo*"));
        assert(совпадение("foo.bar", "f*bar"));
        assert(совпадение("foo.bar", "f*b*r"));
        assert(совпадение("foo.bar", "f???bar"));
        assert(совпадение("foo.bar", "[fg]???bar"));
        assert(совпадение("foo.bar", "[!gh]*bar"));
        
        assert(!совпадение("foo", "bar"));
        assert(!совпадение("foo", "*.*"));
        assert(!совпадение("foo.bar", "f*baz"));
        assert(!совпадение("foo.bar", "f*b*x"));
        assert(!совпадение("foo.bar", "[gh]???bar"));
        assert(!совпадение("foo.bar", "[!fg]*bar"));
        assert(!совпадение("foo.bar", "[fg]???baz"));
        }
}


/*******************************************************************************

        Normalizes a путь component
        ---
        . segments are removed
        <segment>/.. are removed
        ---

        MultИПle consecutive forward slashes are replaced with a single 
        forward slash. On Windows, \ will be преобразованый в_ / prior в_ any
        normalization.

        Note that any число of .. segments at the front is ignored,
        unless it is an абсолютный путь, in which case they are removed.

        The ввод путь is copied преобр_в either the provопрed буфер, or a куча
        allocated Массив if no буфер was provопрed. Normalization modifies
        this копируй before returning the relevant срез.
        -----
        нормализуй("/home/foo/./bar/../../john/doe"); // => "/home/john/doe"
        -----

        Note: allocates память

*******************************************************************************/

ткст нормализуй (ткст путь, ткст буф = пусто)
{
        т_мера  инд;            // Текущий позиция
        т_мера  moveTo;         // Position в_ перемести
        бул    абс_ли;     // Whether the путь is абсолютный
        enum    {NodeStackLength = 64}

        // Starting positions of regular путь segments are pushed 
        // on this stack в_ avoопр backward scanning when .. segments 
        // are encountered
        т_мера[NodeStackLength] nodeStack;
        т_мера nodeStackTop;

        // Moves the путь хвост starting at the current позиция в_ 
        // moveTo. Then sets the current позиция в_ moveTo.
        проц перемести ()
        {
                auto длин = путь.length - инд;
                memmove (путь.ptr + moveTo, путь.ptr + инд, длин);
                путь = путь[0..moveTo + длин];
                инд = moveTo;
        }

        // Checks if the character at the current позиция is a 
        // разделитель. If да, normalizes the разделитель в_ '/' on 
        // Windows and advances the current позиция в_ the следщ 
        // character.
        бул isSep (ref т_мера i)
        {
                сим c = путь[i];
                version (Windows)
                        {
                        if (c == '\\')
                                путь[i] = '/';
                        else if (c != '/')
                                return нет;
                        }
                     else
                        {
                        if (c != '/')
                                return нет;
                        }
                i++;
                return да;
        }

        if (буф is пусто)
            путь = путь.dup;
        else
           путь = буф[0..путь.length] = путь;

        version (Windows)
        {
                // SkИП Windows drive specifiers
                if (путь.length >= 2 && путь[1] == ':')
                   {
                   auto c = путь[0];

                   if (c >= 'a' && c <= 'z')
                      {
                      путь[0] = c - 32;
                      инд = 2;
                      }
                   else 
                      if (c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z')
                          инд = 2;
                   }
        }

        if (инд == путь.length)
            return путь;

        moveTo = инд;
        if (isSep(инд))
           {
           moveTo++; // preserve корень разделитель.
           абс_ли = да;
           }

        while (инд < путь.length)
              {
              // SkИП duplicate разделители
              if (isSep(инд))
                  continue;

              if (путь[инд] == '.')
                 {
                 // покинь the current позиция at the старт of 
                 // the segment
                 auto i = инд + 1;
                 if (i < путь.length && путь[i] == '.')
                    {
                    i++;
                    if (i == путь.length || isSep(i))
                       {
                       // It is a '..' segment. If the stack is not 
                       // пустой, установи moveTo and the current позиция
                       // в_ the старт позиция of the последний найдено 
                       // regular segment
                       if (nodeStackTop > 0)
                           moveTo = nodeStack[--nodeStackTop];

                       // If no regular segment старт positions on the 
                       // stack, drop the .. segment if it is абсолютный 
                       // путь or, otherwise, advance moveTo and the 
                       // current позиция в_ the character after the 
                       // '..' segment
                       else 
                          if (!абс_ли)
                             {
                             if (moveTo != инд)
                                {
                                i -= инд - moveTo;
                                перемести();
                                }
                             moveTo = i;
                             }
        
                       инд = i;
                       continue;
                       }
                    }
        
                 // If it is '.' segment, пропусти it.
                 if (i == путь.length || isSep(i))
                    {
                    инд = i;
                    continue;
                    }
                 }

              // Удали excessive '/', '.' and/or '..' preceeding the 
              // segment
              if (moveTo != инд)
                  перемести();

              // Push the старт позиция of the regular segment on the 
              // stack
              assert (nodeStackTop < NodeStackLength);
              nodeStack[nodeStackTop++] = инд;

              // SkИП the regular segment and установи moveTo в_ the позиция 
              // after the segment (включая the trailing '/' if present)
              for (; инд < путь.length && !isSep(инд); инд++) 
                  {}
              moveTo = инд;
              }

        if (moveTo != инд)
            перемести();
        return путь;
}

/*******************************************************************************

*******************************************************************************/

debug (UnitTest)
{
        unittest
        {
        assert (нормализуй ("") == "");
        assert (нормализуй ("/home/../john/../.DinrusTango.lib/.htaccess") == "/.DinrusTango.lib/.htaccess");
        assert (нормализуй ("/home/../john/../.DinrusTango.lib/foo.conf") == "/.DinrusTango.lib/foo.conf");
        assert (нормализуй ("/home/john/.DinrusTango.lib/foo.conf") == "/home/john/.DinrusTango.lib/foo.conf");
        assert (нормализуй ("/foo/bar/.htaccess") == "/foo/bar/.htaccess");
        assert (нормализуй ("foo/bar/././.") == "foo/bar/");
        assert (нормализуй ("././foo/././././bar") == "foo/bar");
        assert (нормализуй ("/foo/../john") == "/john");
        assert (нормализуй ("foo/../john") == "john");
        assert (нормализуй ("foo/bar/..") == "foo/");
        assert (нормализуй ("foo/bar/../john") == "foo/john");
        assert (нормализуй ("foo/bar/doe/../../john") == "foo/john");
        assert (нормализуй ("foo/bar/doe/../../john/../bar") == "foo/bar");
        assert (нормализуй ("./foo/bar/doe") == "foo/bar/doe");
        assert (нормализуй ("./foo/bar/doe/../../john/../bar") == "foo/bar");
        assert (нормализуй ("./foo/bar/../../john/../bar") == "bar");
        assert (нормализуй ("foo/bar/./doe/../../john") == "foo/john");
        assert (нормализуй ("../../foo/bar") == "../../foo/bar");
        assert (нормализуй ("../../../foo/bar") == "../../../foo/bar");
        assert (нормализуй ("d/") == "d/");
        assert (нормализуй ("/home/john/./foo/bar.txt") == "/home/john/foo/bar.txt");
        assert (нормализуй ("/home//john") == "/home/john");

        assert (нормализуй("/../../bar/") == "/bar/");
        assert (нормализуй("/../../bar/../baz/./") == "/baz/");
        assert (нормализуй("/../../bar/boo/../baz/.bar/.") == "/bar/baz/.bar/");
        assert (нормализуй("../..///.///bar/..//..//baz/.//boo/..") == "../../../baz/");
        assert (нормализуй("./bar/./..boo/./..bar././/") == "bar/..boo/..bar./");
        assert (нормализуй("/bar/..") == "/");
        assert (нормализуй("bar/") == "bar/");
        assert (нормализуй(".../") == ".../");
        assert (нормализуй("///../foo") == "/foo");
        assert (нормализуй("./foo") == "foo");
        auto буф = new сим[100];
        auto возвр = нормализуй("foo/bar/./baz", буф);
        assert (возвр.ptr == буф.ptr);
        assert (возвр == "foo/bar/baz");

        version (Windows) 
                {
                assert (нормализуй ("\\foo\\..\\john") == "/john");
                assert (нормализуй ("foo\\..\\john") == "john");
                assert (нормализуй ("foo\\bar\\..") == "foo/");
                assert (нормализуй ("foo\\bar\\..\\john") == "foo/john");
                assert (нормализуй ("foo\\bar\\doe\\..\\..\\john") == "foo/john");
                assert (нормализуй ("foo\\bar\\doe\\..\\..\\john\\..\\bar") == "foo/bar");
                assert (нормализуй (".\\foo\\bar\\doe") == "foo/bar/doe");
                assert (нормализуй (".\\foo\\bar\\doe\\..\\..\\john\\..\\bar") == "foo/bar");
                assert (нормализуй (".\\foo\\bar\\..\\..\\john\\..\\bar") == "bar");
                assert (нормализуй ("foo\\bar\\.\\doe\\..\\..\\john") == "foo/john");
                assert (нормализуй ("..\\..\\foo\\bar") == "../../foo/bar");
                assert (нормализуй ("..\\..\\..\\foo\\bar") == "../../../foo/bar");
                assert (нормализуй(r"C:") == "C:");
                assert (нормализуй(r"C") == "C");
                assert (нормализуй(r"c:\") == "C:/");
                assert (нормализуй(r"C:\..\.\..\..\") == "C:/");
                assert (нормализуй(r"c:..\.\boo\") == "C:../boo/");
                assert (нормализуй(r"C:..\..\boo\foo\..\.\..\..\bar") == "C:../../../bar");
                assert (нормализуй(r"C:boo\..") == "C:");
                }
        }
}


/*******************************************************************************

*******************************************************************************/

debug (Путь)
{
        import io.Stdout;

        проц main()
        { 
                foreach (файл; коллируй (".", "*.d", да))
                         Стдвыв (файл).нс;      
        }
}
