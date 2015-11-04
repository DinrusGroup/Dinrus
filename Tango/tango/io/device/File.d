/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mar 2004: Initial release     
                        Dec 2006: Outback release
                        Nov 2008: relocated and simplified
                        
        author:         Kris, 
                        John Reimer, 
                        Anders F Bjorklund (Darwin patches),
                        Chris Sauls (Win95 файл support)

*******************************************************************************/

module io.device.File;

private import sys.Common;

private import io.device.Device;

private import stringz;

/*******************************************************************************

        platform-specific functions

*******************************************************************************/

version (Win32)
         private import Utf = text.convert.Utf;
   else
      private import rt.core.stdc.posix.unistd;


/*******************************************************************************

        Implements a means of reading and writing a generic файл. Conduits
        are the primary means of accessing external данные, and Файл
        extends the basic образец by provопрing файл-specific methods в_
        установи the файл размер, сместись в_ a specific файл позиция and so on. 
        
        Serial ввод and вывод is straightforward. In this example we
        копируй a файл directly в_ the console:
        ---
        // открой a файл for reading
        auto из_ = new Файл ("тест.txt");

        // поток directly в_ console
        Стдвыв.копируй (из_);
        ---

        And here we копируй one файл в_ другой:
        ---
        // открой файл for reading
        auto из_ = new Файл ("тест.txt");

        // открой другой for writing
        auto в_ = new Файл ("копируй.txt", Файл.ЗапСозд);

        // копируй файл and закрой
        в_.копируй.закрой;
        из_.закрой;
        ---
        
        You can use ИПотокВвода.загрузи() в_ загрузи a файл directly преобр_в память:
        ---
        auto файл = new Файл ("тест.txt");
        auto контент = файл.загрузи;
        файл.закрой;
        ---

        Or use a convenience static function within Файл:
        ---
        auto контент = Файл.получи ("тест.txt");
        ---

        A ещё explicit version with a similar результат would be:
        ---
        // открой файл for reading
        auto файл = new Файл ("тест.txt");

        // создай an Массив в_ house the entire файл
        auto контент = new сим [файл.length];

        // читай the файл контент. Return значение is the число of байты читай
        auto байты = файл.читай (контент);
        файл.закрой;
        ---

        Conversely, one may пиши directly в_ a Файл like so:
        ---
        // открой файл for writing
        auto в_ = new Файл ("текст.txt", Файл.ЗапСозд);

        // пиши an Массив of контент в_ it
        auto байты = в_.пиши (контент);
        ---

        There are equivalent static functions, Файл.установи() and
        Файл.добавь(), which установи or добавь файл контент respectively

        Файл can happily укз random I/O. Here we use сместись() в_
        relocate the файл pointer:
        ---
        // открой a файл for reading and writing
        auto файл = new Файл ("random.bin", Файл.ЧитЗапСозд);

        // пиши some данные
        файл.пиши ("testing");

        // rewind в_ файл старт
        файл.сместись (0);

        // читай данные back again
        сим[10] врем;
        auto байты = файл.читай (врем);

        файл.закрой;
        ---

        Note that Файл is unbuffered by default - wrap an экземпляр within
        io.stream.Buffered for buffered I/O.

        Compile with -version=Win32SansUnicode в_ enable Win95 & Win32s файл 
        support.
        
*******************************************************************************/
alias Файл ФайлВвод;

alias Файл ФайлВывод;

class Файл : Устройство, Устройство.Seek, Устройство.Truncate
{
        public alias Устройство.читай  читай;
        public alias Устройство.пиши пиши;

        /***********************************************************************
        
                Fits преобр_в 32 биты ...

        ***********************************************************************/

         align(1) struct Стиль
        {
                Access          access;                 /// access rights
                Open            открой;                   /// как в_ открой
                Коммуна           совместно;                  /// как в_ совместно
                Cache           cache;                  /// как в_ cache
        }

        /***********************************************************************

        ***********************************************************************/

        enum Access : ббайт     {
                                Чтен      = 0x01,       /// is читаемый
                                Write     = 0x02,       /// is записываемый
                                ReadWrite = 0x03,       /// Всё
                                }

        /***********************************************************************
        
        ***********************************************************************/

        enum Open : ббайт       {
                                Exists=0,               /// must exist
                                Create,                 /// создай or обрежь
                                Sedate,                 /// создай if necessary
                                Append,                 /// создай if necessary
                                New,                    /// can't exist
                                };

        /***********************************************************************
        
        ***********************************************************************/

        enum Коммуна : ббайт      {
                                Нет=0,                 /// no sharing
                                Чтен,                   /// shared reading
                                ReadWrite,              /// открой for anything
                                };

        /***********************************************************************
        
        ***********************************************************************/

        enum Cache : ббайт      {
                                Нет      = 0x00,       /// don't оптимизируй
                                Случай    = 0x01,       /// оптимизируй for random
                                Поток    = 0x02,       /// оптимизируй for поток
                                WriteThru = 0x04,       /// backing-cache flag
                                };

        /***********************************************************************

            Чтен an existing файл
        
        ***********************************************************************/

        const Стиль ЧитСущ = {Access.Чтен, Open.Exists};

        /***********************************************************************

            Чтен an existing файл
        
        ***********************************************************************/

        const Стиль ReadShared = {Access.Чтен, Open.Exists, Коммуна.Чтен};

        /***********************************************************************
        
                Write on an existing файл. Do not создай

        ***********************************************************************/

        const Стиль WriteExisting = {Access.Write, Open.Exists};

        /***********************************************************************
        
                Write on a clean файл. Create if necessary

        ***********************************************************************/

        const Стиль ЗапСозд = {Access.Write, Open.Create};

        /***********************************************************************
        
                Write at the конец of the файл

        ***********************************************************************/

        const Стиль ЧитДоб = {Access.Write, Open.Append};

        /***********************************************************************
        
                Чтен and пиши an existing файл

        ***********************************************************************/

        const Стиль ReadWriteExisting = {Access.ReadWrite, Open.Exists}; 

        /***********************************************************************
        
                Чтен & пиши on a clean файл. Create if necessary

        ***********************************************************************/

        const Стиль ЧитЗапСозд = {Access.ReadWrite, Open.Create}; 

        /***********************************************************************
        
                Чтен and Write. Use existing файл if present

        ***********************************************************************/

        const Стиль ReadWriteOpen = {Access.ReadWrite, Open.Sedate}; 


        // the файл we're working with 
        private ткст  path_;

        // the стиль we're opened with
        private Стиль   style_;

        /***********************************************************************
        
                Create a Файл for use with открой()

                Note that Файл is unbuffered by default - wrap an экземпляр 
                within io.stream.Buffered for buffered I/O

        ***********************************************************************/

        this ()
        {
        }

        /***********************************************************************
        
                Create a Файл with the provопрed путь and стиль.

                Note that Файл is unbuffered by default - wrap an экземпляр 
                within io.stream.Buffered for buffered I/O

        ***********************************************************************/

        this (ткст путь, Стиль стиль = ЧитСущ)
        {
                открой (путь, стиль);
        }

        /***********************************************************************
        
                Return the Стиль used for this файл.

        ***********************************************************************/

        Стиль стиль ()
        {
                return style_;
        }               

        /***********************************************************************
        
                Return the путь used by this файл.

        ***********************************************************************/

        override ткст вТкст ()
        {
                return path_;
        }               

        /***********************************************************************

                Convenience function в_ return the контент of a файл.
                Returns a срез of the provопрed вывод буфер, where
                that есть sufficient ёмкость, and allocates из_ the
                куча where the файл контент is larger.

                Content размер is determined via the файл-system, per
                Файл.length, although that may be misleading for some
                *nix systems. An alternative is в_ use Файл.загрузи which
                loads контент until an Кф is encountered

        ***********************************************************************/

        static проц[] получи (ткст путь, проц[] приёмн = пусто)
        {
                scope файл = new Файл (путь);  

                // размести enough пространство for the entire файл
                auto длин = cast(т_мера) файл.length;
                if (приёмн.length < длин){
                    if (приёмн is пусто){ // avoопр настройка the noscan attribute, one should maybe change the return тип
                        приёмн=new ббайт[](длин);
                    } else {
                        приёмн.length = длин;
                    }
                }

                //читай the контент
                длин = файл.читай (приёмн);
                if (длин is файл.Кф)
                    файл.ошибка ("Файл.читай :: unexpected eof");

                return приёмн [0 .. длин];
        }

        /***********************************************************************

                Convenience function в_ установи файл контент and length в_ 
                reflect the given Массив

        ***********************************************************************/

        static проц установи (ткст путь, проц[] контент)
        {
                scope файл = new Файл (путь, ЧитЗапСозд);  
                файл.пиши (контент);
        }

        /***********************************************************************

                Convenience function в_ добавь контент в_ a файл

        ***********************************************************************/

        static проц добавь (ткст путь, проц[] контент)
        {
                scope файл = new Файл (путь, ЧитДоб);  
                файл.пиши (контент);
        }

        /***********************************************************************

                Windows-specific код
        
        ***********************************************************************/

        version(Win32)
        {
                /***************************************************************
                  
                    Low уровень открой for sub-classes that need в_ apply specific
                    атрибуты.

                    Return: нет in case of failure

                ***************************************************************/

                protected бул открой (ткст путь, Стиль стиль, DWORD добавьattr)
                {
                        DWORD   attr,
                                совместно,
                                access,
                                создай;

                        alias DWORD[] Flags;

                        static const Flags Access =  
                                        [
                                        0,                      // не_годится
                                        GENERIC_READ,
                                        GENERIC_WRITE,
                                        GENERIC_READ | GENERIC_WRITE,
                                        ];
                                                
                        static const Flags Create =  
                                        [
                                        OPEN_EXISTING,          // must exist
                                        CREATE_ALWAYS,          // обрежь always
                                        OPEN_ALWAYS,            // создай if needed
                                        OPEN_ALWAYS,            // (for appending)
                                        CREATE_NEW              // can't exist
                                        ];
                                                
                        static const Flags Коммуна =   
                                        [
                                        0,
                                        FILE_SHARE_READ,
                                        FILE_SHARE_READ | FILE_SHARE_WRITE,
                                        ];
                                                
                        static const Flags Attr =   
                                        [
                                        0,
                                        FILE_FLAG_RANDOM_ACCESS,
                                        FILE_FLAG_SEQUENTIAL_SCAN,
                                        0,
                                        FILE_FLAG_WRITE_THROUGH,
                                        ];

                        // remember our settings
                        assert(путь);
                        path_ = путь;
                        style_ = стиль;

                        attr   = Attr[стиль.cache] | добавьattr;
                        совместно  = Коммуна[стиль.совместно];
                        создай = Create[стиль.открой];
                        access = Access[стиль.access];

                        if (scheduler)
                            attr |= FILE_FLAG_OVERLAPPED;// + FILE_FLAG_NO_BUFFERING;

                        // zero терминируй the путь
                        сим[512] zero =void;
                        auto имя = stringz.вТкст0(путь, zero);

                        version (Win32SansUnicode)
                                 вв.указатель = CreateFileA (имя, access, совместно, 
                                                          пусто, создай, 
                                                          attr | FILE_ATTRIBUTE_NORMAL,
                                                          пусто);
                             else
                                {
                                // преобразуй в_ utf16
                                шим[512] преобразуй =void;
                                auto wide = Utf.вТкст16 (имя[0..путь.length+1], преобразуй);

                                // открой the файл
                                вв.указатель = CreateFileW (wide.ptr, access, совместно,
                                                         пусто, создай, 
                                                         attr | FILE_ATTRIBUTE_NORMAL,
                                                         пусто);
                                }

                        if (вв.указатель is INVALID_HANDLE_VALUE)
                            return нет;

                        // сбрось extended ошибка 
                        SetLastError (ERROR_SUCCESS);

                        // перемести в_ конец of файл?
                        if (стиль.открой is Open.Append)
                            *(cast(дол*) &вв.асинх.смещение) = -1;
                        else
                           вв.след = да;

                        // monitor this укз for async I/O?
                        if (scheduler)
                            scheduler.открой (вв.указатель, вТкст);
                        return да;
                }

                /***************************************************************

                        Open a файл with the provопрed стиль.

                ***************************************************************/

                проц открой (ткст путь, Стиль стиль = ЧитСущ)
                {
                    if (! открой (путь, стиль, 0))
                          ошибка;
                }

                /***************************************************************

                        Набор the файл размер в_ be that of the current сместись 
                        позиция. The файл must be записываемый for this в_
                        succeed.

                ***************************************************************/

                проц обрежь ()
                {
                        обрежь (позиция);
                }               

                /***************************************************************

                        Набор the файл размер в_ be the specified length. The 
                        файл must be записываемый for this в_ succeed. 

                ***************************************************************/

                override проц обрежь (дол размер)
                {
                        auto s = сместись (размер);
                        assert (s is размер);

                        // must have Generic_Write access
                        if (! SetEndOfFile (вв.указатель))
                              ошибка;                            
                }               

                /***************************************************************

                        Набор the файл сместись позиция в_ the specified смещение
                        из_ the given якорь. 

                ***************************************************************/

                override дол сместись (дол смещение, Якорь якорь = Якорь.Нач)
                {
                        дол новСмещение; 

                        // hack в_ ensure overlapped.Offset and файл location 
                        // are correctly in synch ...
                        if (якорь is Якорь.Тек)
                            SetFilePointerEx (вв.указатель, 
                                              *cast(LARGE_INTEGER*) &вв.асинх.смещение, 
                                              cast(PLARGE_INTEGER) &новСмещение, 0);

                        if (! SetFilePointerEx (вв.указатель, *cast(LARGE_INTEGER*) 
                                                &смещение, cast(PLARGE_INTEGER) 
                                                &новСмещение, якорь)) 
                              ошибка;

                        return (*cast(дол*) &вв.асинх.смещение) = новСмещение;
                } 
                              
                /***************************************************************
                
                        Return the current файл позиция.
                
                ***************************************************************/

                дол позиция ()
                {
                        return *cast(дол*) &вв.асинх.смещение;
                }               

                /***************************************************************
        
                        Return the total length of this файл.

                ***************************************************************/

                дол length ()
                {
                        дол длин;

                        if (! GetFileSizeEx (вв.указатель, cast(PLARGE_INTEGER) &длин))
                              ошибка;
                        return длин;
                }               

	        /***************************************************************

		        Instructs the OS в_ слей it's internal buffers в_ 
                        the disk устройство.

                        NOTE: due в_ OS and hardware design, данные flushed 
                        cannot be guaranteed в_ be actually on disk-platters. 
                        Actual durability of данные depends on пиши-caches, 
                        barriers, presence of battery-backup, filesystem and 
                        OS-support.

                ***************************************************************/

	        проц синх ()
	        {
                         if (! FlushFileBuffers (вв.указатель))
                               ошибка;
                }
        }


        /***********************************************************************

                 Unix-specific код. Note that some methods are 32bit only
        
        ***********************************************************************/

        version (Posix)
        {
                /***************************************************************

                    Low уровень открой for sub-classes that need в_ apply specific
                    атрибуты.

                    Return:
                        нет in case of failure

                ***************************************************************/

                protected бул открой (ткст путь, Стиль стиль,
                                     цел добфлаги, цел access = 0666)
                {
                        alias цел[] Flags;

                        const O_LARGEFILE = 0x8000;

                        static const Flags Access =  
                                        [
                                        0,                      // не_годится
                                        O_RDONLY,
                                        O_WRONLY,
                                        O_RDWR,
                                        ];
                                                
                        static const Flags Create =  
                                        [
                                        0,                      // открой existing
                                        O_CREAT | O_TRUNC,      // обрежь always
                                        O_CREAT,                // создай if needed
                                        O_APPEND | O_CREAT,     // добавь
                                        O_CREAT | O_EXCL,       // can't exist
                                        ];

                        static const крат[] Locks =   
                                        [
                                        F_WRLCK,                // no sharing
                                        F_RDLCK,                // shared читай
                                        ];
                                                
                        // remember our settings
                        assert(путь);
                        path_ = путь;
                        style_ = стиль;

                        // zero терминируй and преобразуй в_ utf16
                        сим[512] zero =void;
                        auto имя = stdc.вТкст0 (путь, zero);
                        auto режим = Access[стиль.access] | Create[стиль.открой];

                        // always открой as a large файл
                        укз = posix.открой (имя, режим | O_LARGEFILE | добфлаги, 
                                             access);
                        if (укз is -1)
                            return нет;

                        return да;
                }

                /***************************************************************

                        Open a файл with the provопрed стиль.

                        Note that файлы default в_ no-sharing. That is, 
                        they are locked exclusively в_ the хост process 
                        unless otherwise stИПulated. We do this in order
                        в_ expose the same default behaviour as Win32

                        NO FILE LOCKING FOR BORKED POSIX

                ***************************************************************/

                проц открой (ткст путь, Стиль стиль = ЧитСущ)
                {
                    if (! открой (путь, стиль, 0))
                          ошибка;
                }

                /***************************************************************

                        Набор the файл размер в_ be that of the current сместись 
                        позиция. The файл must be записываемый for this в_
                        succeed.

                ***************************************************************/

                проц обрежь ()
                {
                        обрежь (позиция);
                }               

                /***************************************************************

                        Набор the файл размер в_ be the specified length. The 
                        файл must be записываемый for this в_ succeed.

                ***************************************************************/

                override проц обрежь (дол размер)
                {
                        // установи filesize в_ be current сместись-позиция
                        if (posix.ftruncate (укз, cast(off_t) размер) is -1)
                            ошибка;
                }               

                /***************************************************************

                        Набор the файл сместись позиция в_ the specified смещение
                        из_ the given якорь. 

                ***************************************************************/

                override дол сместись (дол смещение, Якорь якорь = Якорь.Нач)
                {
                        дол результат = posix.lseek (укз, cast(off_t) смещение, якорь);
                        if (результат is -1)
                            ошибка;
                        return результат;
                }               

                /***************************************************************
                
                        Return the current файл позиция.
                
                ***************************************************************/

                дол позиция ()
                {
                        return сместись (0, Якорь.Тек);
                }               

                /***************************************************************
        
                        Return the total length of this файл. 

                ***************************************************************/

                дол length ()
                {
                        stat_t статс =void;
                        if (posix.fstat (укз, &статс))
                            ошибка;
                        return cast(дол) статс.st_size;
                }               

	        /***************************************************************

		        Instructs the OS в_ слей it's internal buffers в_ 
                        the disk устройство.

                        NOTE: due в_ OS and hardware design, данные flushed 
                        cannot be guaranteed в_ be actually on disk-platters. 
                        Actual durability of данные depends on пиши-caches, 
                        barriers, presence of battery-backup, filesystem and 
                        OS-support.

                ***************************************************************/

	        проц синх ()
	        {
                         if (fsync (укз))
                             ошибка;
                }                            
        }
}


debug (Файл)
{
        import io.Stdout;

        проц main()
        {
                сим[10] ff;

                auto файл = new Файл("файл.d");
                auto контент = cast(ткст) файл.загрузи (файл);
                assert (контент.length is файл.length);
                assert (файл.читай(ff) is файл.Кф);
                assert (файл.позиция is контент.length);
                файл.сместись (0);
                assert (файл.позиция is 0);
                assert (файл.читай(ff) is 10);
                assert (файл.позиция is 10);
                assert (файл.сместись(0, файл.Якорь.Тек) is 10);
                assert (файл.сместись(0, файл.Якорь.Тек) is 10);
        }
}
