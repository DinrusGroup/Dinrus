﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
      
        version:        Initial release: March 2004
        
        author:         Kris

*******************************************************************************/

module io.device.FileMap;

private import sys.Common;

private import io.device.File,
               io.device.Array;

/*******************************************************************************

        External declarations

*******************************************************************************/

version (Win32)
         private extern (Windows) 
                        {
                        BOOL   UnmapViewOfFile    (LPCVOID);
                        BOOL   FlushViewOfFile    (LPCVOID, DWORD);
                        LPVOID MapViewOfFile      (HANDLE, DWORD, DWORD, DWORD, DWORD);
                        HANDLE CreateFileMappingA (HANDLE, LPSECURITY_ATTRIBUTES, DWORD, DWORD, DWORD, LPCTSTR);
                        }

version (Posix)
         private import rt.core.stdc.posix.sys.mman;


/*******************************************************************************

*******************************************************************************/


class ФайлМэп : Массив
{
        private КартированныйФайл файл;

        /***********************************************************************

                Construct a ФайлМэп upon the given путь. 

                You should use перемерь() в_ установи the available 
                working пространство.

        ***********************************************************************/


        this (ткст путь, Файл.Стиль стиль = Файл.ЧитЗапОткр)
        {
                файл = new КартированныйФайл (путь, стиль);
                super (файл.карта);
        }

        /***********************************************************************

                Resize the файл and return the remapped контент. Usage of
                карта() is not требуется following this вызов

        ***********************************************************************/

        final ббайт[] перемерь (дол размер)
        {
                auto возвр = файл.перемерь (размер);
                super.присвой (возвр);
                return возвр;
        }

        /***********************************************************************

                Release external resources

        ***********************************************************************/

        override проц закрой ()
        {
                super.закрой;
                if (файл)
                    файл.закрой;
                файл = пусто;
        }
}


/*******************************************************************************

*******************************************************************************/

class КартированныйФайл
{
        private Файл хост;
		

        /***********************************************************************

                Construct a ФайлМэп upon the given путь. 

                You should use перемерь() в_ установи the available 
                working пространство.

        ***********************************************************************/

        this (ткст путь, Файл.Стиль стиль = Файл.ЧитЗапОткр)
        {
                хост = new Файл (путь, стиль);
        }

        /***********************************************************************

        ***********************************************************************/

        final дол длина ()
        {
                return хост.длина;
        }

        /***********************************************************************

        ***********************************************************************/

        final ткст путь ()
        {
                return хост.вТкст;
        }

        /***********************************************************************

                Resize the файл and return the remapped контент. Usage of
                карта() is not требуется following this вызов

        ***********************************************************************/

        final ббайт[] перемерь (дол размер)
        {
                хост.упрости (размер);
                return карта;
        }

        /***********************************************************************

        ***********************************************************************/

        version (Win32)
        {
                private ук    основа;            // Массив pointer
                private HANDLE  mmFile;          // mapped файл

                /***************************************************************

                        return a срез representing файл контент as a 
                        память-mapped Массив

                ***************************************************************/

                final ббайт[] карта ()
                {
                        DWORD флаги;

                        // be wary of redundant references
                        if (основа)
                            сбрось;

                        // can only do 32bit маппинг on 32bit platform
                        auto размер = cast(т_мера) хост.длина;
                        auto доступ = хост.стиль.доступ;

                        флаги = PAGE_READONLY;
                        if (доступ & хост.Доступ.Зап)
                            флаги = PAGE_READWRITE;
 
                        auto укз = cast(HANDLE) хост.фукз;
                        mmFile = CreateFileMappingA (укз, пусто, флаги, 0, 0, пусто);
                        if (mmFile is пусто)
                            хост.ошибка;

                        флаги = FILE_MAP_READ;
                        if (доступ & хост.Доступ.Зап)
                            флаги |= FILE_MAP_WRITE;

                        основа = MapViewOfFile (mmFile, флаги, 0, 0, 0);
                        if (основа is пусто)
                            хост.ошибка;
  
                        return (cast(ббайт*) основа) [0 .. размер];
                }

                /***************************************************************

                        Release this маппинг without flushing

                ***************************************************************/

                final проц закрой ()
                {
                        сбрось;
                        if (хост)
                            хост.закрой;
                        хост = пусто;
                }

                /***************************************************************

                ***************************************************************/

                private проц сбрось ()
                {
                        if (основа)
                            UnmapViewOfFile (основа);

                        if (mmFile)
                            CloseHandle (mmFile);       

                        mmFile = пусто;
                        основа = пусто;
                }

                /***************************************************************

                        Flush dirty контент out в_ the drive. This
                        fails with ошибка 33 if the файл контент is
                        virgin. Opening a файл for ReadWriteExists
                        followed by a слей() will cause this.

                ***************************************************************/

                КартированныйФайл слей ()
                {
                        // слей все dirty pages
                        if (! FlushViewOfFile (основа, 0))
                              хост.ошибка;
                        return this;
                }
        }

        /***********************************************************************
                
        ***********************************************************************/

        version (Posix)
        {               
                // Linux код: not yet tested on другой POSIX systems.
                private ук    основа;           // Массив pointer
                private т_мера  размер;           // length of файл

                /***************************************************************

                        return a срез representing файл контент as a 
                        память-mapped Массив. Use this в_ remap контент
                        each время the файл размер is изменён

                ***************************************************************/

                final ббайт[] карта ()
                {
                        // be wary of redundant references
                        if (основа)
                            сбрось;

                        // can only do 32bit маппинг on 32bit platform
                        размер = cast (т_мера) хост.length;

                        // Make sure the маппинг атрибуты are consistant with
                        // the Файл атрибуты.
                        цел флаги = MAP_SHARED;
                        цел protection = PROT_READ;
                        auto доступ = хост.стиль.доступ;
                        if (доступ & хост.Доступ.Зап)
                            protection |= PROT_WRITE;
                                
                        основа = mmap (пусто, размер, protection, флаги, хост.фукз, 0);
                        if (основа is MAP_FAILED)
                           {
                           основа = пусто;
                           хост.ошибка;
                           }
                                
                        return (cast(ббайт*) основа) [0 .. размер];
                }    

                /***************************************************************

                        Release this mapped буфер without flushing

                ***************************************************************/

                final проц закрой ()
                {
                        сбрось;
                        if (хост)
                            хост.закрой;
                        хост = пусто;
                }

                /***************************************************************

                ***************************************************************/

                private проц сбрось ()
                {
                        // NOTE: When a process ends, все mmaps belonging в_ that process
                        //       are automatically unmapped by system (Linux).
                        //       On the другой hand, this is NOT the case when the related 
                        //       файл descrИПtor is закрыт.  This function unmaps explicitly.
                        if (основа)
                            if (munmap (основа, размер))
                                хост.ошибка;

                        основа = пусто;    
                }

                /***************************************************************

                        Flush dirty контент out в_ the drive. 

                ***************************************************************/

                final КартированныйФайл слей () 
                {
                        // MS_ASYNC: delayed слей; equivalent в_ "добавь-в_-queue"
                        // MS_SYNC: function flushes файл immediately; no return until слей complete
                        // MS_INVALIDATE: invalidate все mappings of the same файл (shared)

                        if (псинх (основа, размер, MS_SYNC | MS_INVALIDATE))
                            хост.ошибка;
                        return this;
                }
        }
}


/*******************************************************************************

*******************************************************************************/

debug (FileMap)
{
        import io.Path;

        проц main()
        {
                auto файл = new КартированныйФайл ("foo.map");
                auto куча = файл.перемерь (1_000_000);

                auto file1 = new КартированныйФайл ("foo1.map");
                auto heap1 = file1.перемерь (1_000_000);

                файл.закрой;
                удали ("foo.map");

                file1.закрой;
                удали ("foo1.map");
        }
}
