/*******************************************************************************

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
        private MappedFile файл;

        /***********************************************************************

                Construct a ФайлМэп upon the given путь. 

                You should use resize() в_ установи the available 
                working пространство.

        ***********************************************************************/

        this (ткст путь, Файл.Стиль стиль = Файл.ReadWriteOpen)
        {
                файл = new MappedFile (путь, стиль);
                super (файл.карта);
        }

        /***********************************************************************

                Resize the файл and return the remapped контент. Usage of
                карта() is not required following this вызов

        ***********************************************************************/

        final ббайт[] resize (дол размер)
        {
                auto ret = файл.resize (размер);
                super.присвой (ret);
                return ret;
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

class MappedFile
{
        private Файл хост;

        /***********************************************************************

                Construct a ФайлМэп upon the given путь. 

                You should use resize() в_ установи the available 
                working пространство.

        ***********************************************************************/

        this (ткст путь, Файл.Стиль стиль = Файл.ReadWriteOpen)
        {
                хост = new Файл (путь, стиль);
        }

        /***********************************************************************

        ***********************************************************************/

        final дол length ()
        {
                return хост.length;
        }

        /***********************************************************************

        ***********************************************************************/

        final ткст путь ()
        {
                return хост.вТкст;
        }

        /***********************************************************************

                Resize the файл and return the remapped контент. Usage of
                карта() is not required following this вызов

        ***********************************************************************/

        final ббайт[] resize (дол размер)
        {
                хост.обрежь (размер);
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

                        // can only do 32bit mapping on 32bit platform
                        auto размер = cast(т_мера) хост.length;
                        auto access = хост.стиль.access;

                        флаги = PAGE_READONLY;
                        if (access & хост.Access.Write)
                            флаги = PAGE_READWRITE;
 
                        auto укз = cast(HANDLE) хост.ptr;
                        mmFile = CreateFileMappingA (укз, пусто, флаги, 0, 0, пусто);
                        if (mmFile is пусто)
                            хост.ошибка;

                        флаги = FILE_MAP_READ;
                        if (access & хост.Access.Write)
                            флаги |= FILE_MAP_WRITE;

                        основа = MapViewOfFile (mmFile, флаги, 0, 0, 0);
                        if (основа is пусто)
                            хост.ошибка;
  
                        return (cast(ббайт*) основа) [0 .. размер];
                }

                /***************************************************************

                        Release this mapping without flushing

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

                MappedFile слей ()
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

                        // can only do 32bit mapping on 32bit platform
                        размер = cast (т_мера) хост.length;

                        // Make sure the mapping атрибуты are consistant with
                        // the Файл атрибуты.
                        цел флаги = MAP_SHARED;
                        цел protection = PROT_READ;
                        auto access = хост.стиль.access;
                        if (access & хост.Access.Write)
                            protection |= PROT_WRITE;
                                
                        основа = mmap (пусто, размер, protection, флаги, хост.ptr, 0);
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

                final MappedFile слей () 
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

debug (ФайлМэп)
{
        import io.Path;

        проц main()
        {
                auto файл = new MappedFile ("foo.карта");
                auto куча = файл.resize (1_000_000);

                auto file1 = new MappedFile ("foo1.карта");
                auto heap1 = file1.resize (1_000_000);

                файл.закрой;
                удали ("foo.карта");

                file1.закрой;
                удали ("foo1.карта");
        }
}
