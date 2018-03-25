/* *************************************************************************

        @файл fdt.d

        Copyright (c) 2005 Derek Parnell

                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


        @version        Initial version, January 2005
        @author         Derek Parnell


**************************************************************************/

/**
 * A Файл Дата-Time тип.

 * This data тип is использован to сравни и фм date-time data associated
 * with files.

 * Authors: Derek Parnell
 * Дата: 08 aug 2006
 * History:
 * Licence:
        This software is provided 'as-is', without any express or implied
        warranty. In no event will the authors be held liable for damages
        of any kind arising from the use of this software.

        Permission is hereby granted to anyone to use this software for any
        purpose, including commercial applications, и to alter it и/or
        redistribute it freely, subject to the following restrictions:

        1. The origin of this software must not be misrepresented; you must
           not claim that you wrote the original software. If you use this
           software in a product, an acknowledgment внутри documentation of
           said product would be оценена достойно, но не является обязательной.

        2. Altered source versions must be plainly marked as such, и must
           not неверно представлены, как оригинальное ПО.

        3. This notice may not be removed or altered from any ни в каком дистрибутиве
           of the source.

        4. Derivative works are permitted, but they must carry this notice
           in full и credit the original source.

**/

module util.fdt;
version(unix)  version = Unix;
version(Unix)  version = Posix;
version(linux)  version = Posix;
version(darwin) version = Posix;

private
{
    version(all)
    {
        static import util.str;
        static import util.booltype;   // definition of Да и Нет
        alias util.booltype.Да Да;
        alias util.booltype.Нет Нет;
        alias util.booltype.Бул Бул;
        import dinrus;
    }
    version(Windows)      static import opsys = winapi;
    else version(linux)   static import opsys = std.c.linux.linux;
    else version(darwin)  static import opsys = std.c.darwin.darwin;
    else version(Unix)    static import opsys = std.c.unix.unix;

    version(Posix)   static import std.string;
}

public
{

    /**
         Defines the capabilities of the datatype
    **/
    version(Windows)
    {
        class ФайлДатаВремя
        {
            private
            {
                opsys.FILETIME mDT;
                Бул mSet;
            }

            /**
               * Constructor
               *
               * Defines a 'not recorded' date time.
               * Examples:
               *  --------------------
               *   ФайлДатаВремя a = new ФайлДатаВремя();  // Uninitialized date-time.
               *  --------------------
            **/
            this()
            {
                mSet = Нет;
                mDT.dwHighDateTime = 0;
                mDT.dwLowDateTime = 0;
            }

            /**
               * Constructor
               *
               * Gets the файл's date time.
               *
               * Params:
               *    pFileName = The путь и имя of the файл whose date-time
               *                you want to дай.
               * Examples:
               *  --------------------
               *   auto a = new ФайлДатаВремя("c:\\temp\\afile.txt");
               *  --------------------
            **/
            this(ткст pFileName)
            {
                GetFileTime( вЮ16(pFileName) );
            }

            /**
               * Constructor
               *
               * Gets the файл's date time.
               *
               * Params:
               *    pFileName = The путь и имя of the файл whose date-time
               *                you want to дай.
               * Examples:
               *  --------------------
               *   auto a = new ФайлДатаВремя("c:\\temp\\afile.txt");
               *  --------------------
            **/
            this(шткст pFileName)
            {
                GetFileTime( pFileName );
            }

            /**
               * Constructor
               *
               * Gets the файл's date time.
               *
               * Params:
               *    pFileName = The путь и имя of the файл whose date-time
               *                you want to дай.
               * Examples:
               *  --------------------
               *   auto a = new ФайлДатаВремя("c:\\temp\\afile.txt");
               *  --------------------
            **/
            this(юткст pFileName)
            {
                GetFileTime( вЮ16(pFileName) );
            }

            /**
               * Equality Operator
               *
               * This is accurate to the секунда. That is, all times inside
               * the same секунда are considered equal. Milliseconds are
               * not considered.
               *
               * Params:
               *  pOther = The ФайлДатаВремя to сравни this one to.
               *
               *
               * Examples:
               *  --------------------
               *   ФайлДатаВремя a = SomeFunc();
               *   if (a == ФайлДатаВремя("/usr2/bin/sample")) { . . . }
               *  --------------------
            **/
            цел opEquals(ФайлДатаВремя pOther) { return сравни(pOther) == 0; }

            /**
               * Comparision Operator
               *
               * This is accurate to the секунда. That is, all times inside
               * the same секунда are considered equal. Milliseconds are
               * not considered.
               *
               * Params:
               *  pOther = The ФайлДатаВремя to сравни this one to.
               *
               *
               * Examples:
               *  --------------------
               *   ФайлДатаВремя a = SomeFunc();
               *   if (a < ФайлДатаВремя("/usr2/bin/sample")) { . . . }
               *  --------------------
            **/
            цел opCmp(ФайлДатаВремя pOther) { return сравни(pOther); }

            /**
               * Comparision Operator
               *
               * This is accurate to the секунда. That is, all times inside
               * the same секунда are considered equal. Milliseconds are
               * not considered.
               *
               * Params:
               *  pOther = The ФайлДатаВремя to сравни this one to.
               *  pExact = Flag to indicate whether or not to сравни
               *           milliseconds as well. The default is to ignore
               *           milliseconds.
               *
               * Returns: An integer that shows the degree of accuracy и
               *          the direction of the comparision.
               *
               * A negative value indicates that the текущ date-time is
               * less than the parameter's value. A positive return means
               * that the текущ date-time is greater than the parameter.
               * Zero means that they are equal in value.
               *
               * The absolute value of the returned integer indicates
               * the level of accuracy.
               * -----------------
               * 1 .. One of the date-time значения is not recorded.
               * 2 .. They are not in the same year.
               * 3 .. They are not in the same month.
               * 4 .. They are not in the same day.
               * 5 .. They are not in the same час.
               * 6 .. They are not in the same минута.
               * 7 .. They are not in the same секунда.
               * 8 .. They are not in the same миллисекунда.
               * -----------------
               *
               *
               * Examples:
               *  --------------------
               *   ФайлДатаВремя a = SomeFunc();
               *   if (a.сравни(ФайлДатаВремя("/usr2/bin/sample"), true)) > 0)
               *   { . . . }
               *  --------------------
            **/
            цел сравни(ФайлДатаВремя pOther, бул pExact = false)
            {
                opsys.SYSTEMTIME lATime;
                opsys.SYSTEMTIME lBTime;
                цел lResult;

                if (mSet == Нет)
                    if (pOther.mSet == Нет)
                        lResult = 0;
                    else
                        lResult = -1;

                else if (pOther.mSet == Нет)
                    lResult = 1;

                else {
                    opsys.FileTimeToSystemTime(&mDT, &lATime);
                    opsys.FileTimeToSystemTime(&pOther.mDT, &lBTime);

                    if (lATime.wYear > lBTime.wYear)
                        lResult = 2;
                    else if (lATime.wYear < lBTime.wYear)
                        lResult = -2;
                    else if (lATime.wMonth > lBTime.wMonth)
                        lResult = 3;
                    else if (lATime.wMonth < lBTime.wMonth)
                        lResult = -3;
                    else if (lATime.wDay > lBTime.wDay)
                        lResult = 4;
                    else if (lATime.wDay < lBTime.wDay)
                        lResult = -4;
                    else if (lATime.wHour > lBTime.wHour)
                        lResult = 5;
                    else if (lATime.wHour < lBTime.wHour)
                        lResult = -5;
                    else if (lATime.wMinute > lBTime.wMinute)
                        lResult = 6;
                    else if (lATime.wMinute < lBTime.wMinute)
                        lResult = -6;
                    else if (lATime.wSecond > lBTime.wSecond)
                        lResult = 7;
                    else if (lATime.wSecond < lBTime.wSecond)
                        lResult = -7;

                    else if (pExact)
                    {
                        if (lATime.wMilliseconds > lBTime.wMilliseconds)
                            lResult = 8;
                        else if (lATime.wMilliseconds < lBTime.wMilliseconds)
                            lResult = -8;
                        else
                            lResult = 0;
                    }
                }
                return lResult;
            }

            /**
               * Созд a displayable фм of the date-time.
               *
               * The display фм is yyyy/mm/dd HH:MM:SS.TTTT
               *
               * Params:
               *  pExact = Display milliseconds or not. Default is to
               *           ignore milliseconds.
               *
               * Examples:
               *  --------------------
               *   ФайлДатаВремя a = SomeFunc();
               *   скажифнс("Time was %s", a);
               *  --------------------
            **/
            ткст вТкст(бул pExact = false)
            {
                opsys.TIME_ZONE_INFORMATION lTimeZone;
                opsys.SYSTEMTIME lSystemTime;
                opsys.SYSTEMTIME lLocalTime;
                opsys.FILETIME lLocalDT;

                if ( mSet == Нет )
                    return "не записано";

                // Convert the файл's time into the user's local timezone.
                if (useWfuncs)
                {
                    opsys.FileTimeToSystemTime(&mDT, &lSystemTime);
                    opsys.GetTimeZoneInformation(&lTimeZone);
                    opsys.SystemTimeToTzSpecificLocalTime(&lTimeZone, &lSystemTime, &lLocalTime);
                }
                else
                {
                    opsys.FileTimeToLocalFileTime(&mDT, &lLocalDT);
                    opsys.FileTimeToSystemTime(&lLocalDT, &lLocalTime);
                }

                // Return a standardized string form of the date-time.
                //    CCYY/MM/DD hh:mm:ss
                if (pExact)
                    return фм("%04d/%02d/%02d %02d:%02d:%02d.%04d"
                         ,lLocalTime.wYear, lLocalTime.wMonth,  lLocalTime.wDay,
                         lLocalTime.wHour, lLocalTime.wMinute, lLocalTime.wSecond
                         ,lLocalTime.wMilliseconds
                         );
                else
                    return фм("%04d/%02d/%02d %02d:%02d:%02d"
                         ,lLocalTime.wYear, lLocalTime.wMonth,  lLocalTime.wDay,
                         lLocalTime.wHour, lLocalTime.wMinute, lLocalTime.wSecond
                        );
            }

            private проц GetFileTime (шткст pFileName)
            {

                opsys.WIN32_FIND_DATAW lFileInfoW;
                opsys.WIN32_FIND_DATA  lFileInfoA;
                opsys.FILETIME lWriteTime;
                ткст lASCII_FileName;

                opsys.HANDLE lFH;


                if (useWfuncs)
                {
                    lFH = opsys.FindFirstFileW (cast(шим *)&(util.str.замениСим(pFileName ~ cast(шим[])"\0", '/', '\\')[0]), &lFileInfoW);
                    if(lFH != opsys.INVALID_HANDLE_VALUE) {
                        lWriteTime = lFileInfoW.ftLastWriteTime;
                    }
                }
                else
                {
                    lASCII_FileName = вЮ8(util.str.замениСим(pFileName ~ cast(шим[])"\0", '/', '\\'));

                    lFH = opsys.FindFirstFileA (lASCII_FileName.ptr, &lFileInfoA);
                    if(lFH != opsys.INVALID_HANDLE_VALUE) {
                        lWriteTime = lFileInfoA.ftLastWriteTime;
                    }

                }

                if(lFH != opsys.INVALID_HANDLE_VALUE)
                {
                    mSet = Да;
                    mDT = lWriteTime;
                    opsys.FindClose(lFH);
                }
                else
                {
                    mDT.dwHighDateTime = 0;
                    mDT.dwLowDateTime = 0;
                    mSet = Нет;
                }
            }

        } // End of class definition.



    }

    version(Posix)
    {
        class ФайлДатаВремя
        {
            private
            {
                ulong mDT;
                Бул mSet;
            }

            this()
            {
                mSet = Нет;
                mDT = 0;
            }

            this(ткст pFileName)
            {
                GetFileTime( pFileName );
            }

            this(шткст pFileName)
            {
                GetFileTime( вЮ8(pFileName) );
            }

            this(юткст pFileName)
            {
                GetFileTime( вЮ8(pFileName) );
            }

            цел opCmp(ФайлДатаВремя pOther)
            {
                if (mSet == Нет)
                    return -1;

                if (pOther.mSet == Нет)
                    return 1;

                if (mDT > pOther.mDT)
                    return 1;
                if (mDT < pOther.mDT)
                    return -1;
                return 0;
            }

            ткст вТкст()
            {
                if ( mSet == Нет )
                    return "not recorded";
                else
                    return фм("%d", mDT);
            }



            private проц GetFileTime(ткст pFileName)
            {

                цел lFileHandle;
                opsys.struct_stat lFileInfo;
                сим *lFileName;

                lFileName = вТкст0(pFileName);
                lFileHandle = opsys.открой(lFileName, opsys.O_RDONLY);
                if (lFileHandle != -1)
                {
                    if(opsys.fstat(lFileHandle, &lFileInfo) == 0 )
                    {
                        mDT  = lFileInfo.st_mtime;
                        mSet = Да;
                    }
                    else
                    {
                        mDT  = 0;
                        mSet = Нет;
                    }

                    opsys.закрой(lFileHandle);
                }
                else
                {
                    mDT  = 0;
                    mSet = Нет;
                }

            }
        } // End of class definition.
    }
}
