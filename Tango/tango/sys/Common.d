/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: November 2005

        author:         Kris

*******************************************************************************/

module sys.Common;

version (Win32)
        {
        public import sys.win32.UserGdi;
		//public import os.windows;
		//pragma(lib,"drTango");
        }

version (linux)
        {
        public import sys.linux.linux;
        alias sys.linux.linux posix;
        }

version (darwin)
        {
        public import sys.darwin.darwin;
        alias sys.darwin.darwin posix;
        }
version (freebsd)
        {
        public import sys.freebsd.freebsd;
        alias sys.freebsd.freebsd posix;
        }
version (solaris)
        {
        public import sys.solaris.solaris;
        alias sys.solaris.solaris posix;
        }

/*******************************************************************************

        Stuff for sysErrorMsg(), kindly provопрed by Regan Heath.

*******************************************************************************/

version (Win32)
        {
        private const FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x00000100;
        private const FORMAT_MESSAGE_IGNORE_INSERTS  = 0x00000200;
        private const FORMAT_MESSAGE_FROM_STRING     = 0x00000400;
        private const FORMAT_MESSAGE_FROM_HMODULE    = 0x00000800;
        private const FORMAT_MESSAGE_FROM_SYSTEM     = 0x00001000;
        private const FORMAT_MESSAGE_ARGUMENT_ARRAY  = 0x00002000;
        private const FORMAT_MESSAGE_MAX_WIDTH_MASK  = 0x000000FF;

        private DWORD MAKELANGID(WORD p, WORD s)  { return (((cast(WORD)s) << 10) | cast(WORD)p); }

        private alias HGLOBAL HLOCAL;

        private const LANG_NEUTRAL = 0x00;
        private const SUBLANG_DEFAULT = 0x01;

        private extern (Windows)
                       {
                       DWORD FormatMessageW (DWORD dwFlags,
                                             LPCVOID lpSource,
                                             DWORD dwMessageId,
                                             DWORD dwLanguageId,
                                             LPWSTR lpBuffer,
                                             DWORD nSize,
                                             LPCVOID арги
                                             );

                       HLOCAL LocalFree(HLOCAL hMem);
                       }
        }
else
version (Posix)
        {
        private import cidrus;
        private import cidrus;
        }
else
   {
   pragma (msg, "Unsupported environment; neither Win32 or Posix is declared");
   static assert(0);
   }

   
/*******************************************************************************

*******************************************************************************/

struct СисОш
{   
        /***********************************************************************

        ***********************************************************************/

        static бцел последнКод ()
        {
                version (Win32)
                         return GetLastError;
                     else
                         return errno;
        }

        /***********************************************************************

        ***********************************************************************/

        static ткст последнСооб ()
        {
                return отыщи (последнКод);
        }

        /***********************************************************************

        ***********************************************************************/

        static ткст отыщи (бцел errcode)
        {
                ткст текст;

                version (Win32)
                        {
                        DWORD  i;
                        LPWSTR lpMsgBuf;

                        i = FormatMessageW (
                                FORMAT_MESSAGE_ALLOCATE_BUFFER |
                                FORMAT_MESSAGE_FROM_SYSTEM |
                                FORMAT_MESSAGE_IGNORE_INSERTS,
                                пусто,
                                errcode,
                                MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
                                cast(LPWSTR)&lpMsgBuf,
                                0,
                                пусто);

                        /* Удали \r\n из_ ошибка ткст */
                        if (i >= 2) i -= 2;
                        текст = new сим[i * 3];
                        i = WideCharToMultiByte (CP_UTF8, 0, lpMsgBuf, i, 
                                                 cast(PCHAR)текст.ptr, текст.length, пусто, пусто);
                        текст = текст [0 .. i];
                        LocalFree (cast(HLOCAL) lpMsgBuf);
                        }
                     else
                        {
                        бцел  r;
                        сим* pemsg;

                        pemsg = strerror(errcode);
                        r = strlen(pemsg);

                        /* Удали \r\n из_ ошибка ткст */
                        if (pemsg[r-1] == '\n') r--;
                        if (pemsg[r-1] == '\r') r--;
                        текст = pemsg[0..r].dup;
                        }

                return текст;
        }
}
