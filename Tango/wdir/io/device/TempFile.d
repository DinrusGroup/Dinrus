/******************************************************************************
 *
 * copyright:   Copyright &копируй; 2007 Daniel Keep.  все rights reserved.
 * license:     BSD стиль: $(LICENSE)
 * version:     Dec 2007: Initial release
 *              May 2009: Inherit Файл
 * authors:     Daniel Keep
 * credits:     Thanks в_ John Reimer for helping тест this module under
 *              Linux.
 *
 ******************************************************************************/

module io.device.TempFile;

import Путь = io.Path;
import math.random.Kiss : Kiss;
import io.device.Device : Устройство;
import io.device.File;
import exception, stringz : вТкст0;

/******************************************************************************
 ******************************************************************************/

version( Win32 )
{
    import sys.Common : DWORD, LONG, MAX_PATH, PCHAR, CP_UTF8;

    enum : DWORD { FILE_FLAG_OPEN_REPARSE_POINT = 0x00200000 }

    version( Win32SansUnicode )
    {
        import sys.Common :
            GetVersionExA, OSVERSIONINFO,
            FILE_FLAG_DELETE_ON_CLOSE,
            GetTempPathA;

        ткст GetTempPath()
        {
            auto длин = GetTempPathA(0, пусто);
            if( длин == 0 )
                throw new Исключение("не удалось получить временный путь");

            auto результат = new сим[длин+1];
            длин = GetTempPathA(длин+1, результат.ptr);
            if( длин == 0 )
                throw new Исключение("не удалось получить временный путь");
            return Путь.стандарт(результат[0..длин]);
        }
    }
    else
    {
        import sys.Common :
            WideCharToMultiByte,
            GetVersionExW, OSVERSIONINFO,
            FILE_FLAG_DELETE_ON_CLOSE,
            GetTempPathW;

        ткст GetTempPath()
        {
            auto длин = GetTempPathW(0, пусто);
            if( длин == 0 )
                throw new Исключение("не удалось получить временный путь");

            auto результат = new шим[длин+1];
            длин = GetTempPathW(длин+1, результат.ptr);
            if( длин == 0 )
                throw new Исключение("не удалось получить временный путь");

            auto пап = new сим [длин * 3];
            auto i = WideCharToMultiByte (CP_UTF8, 0, результат.ptr, длин, 
                                          cast(PCHAR) пап.ptr, пап.length, пусто, пусто);
            return Путь.стандарт (пап[0..i]);
        }
    }

    // Determines if reparse points (aka: symlinks) are supported.  Support
    // was introduced in Windows Vista.
    бул reparseSupported()
    {
        OSVERSIONINFO versionInfo =void;
        versionInfo.dwOSVersionInfoSize = versionInfo.sizeof;

        проц e(){throw new Исключение("не удалось определить версию Windows");};

        version( Win32SansUnicode )
        {
            if( !GetVersionExA(&versionInfo) ) e();
        }
        else
        {
            if( !GetVersionExW(&versionInfo) ) e();
        }

        return (versionInfo.dwMajorVersion >= 6);
    }
}

else version( Posix )
{
    import rt.core.stdc.posix.pwd : getpwnam;
    import rt.core.stdc.posix.unistd : доступ, getuопр, lseek, отвяжи, W_OK;
    import rt.core.stdc.posix.sys.типы : off_t;
    import rt.core.stdc.posix.sys.stat : stat, stat_t;
    import sys.consts.fcntl : O_NOFOLLOW;
    import rt.core.stdc.posix.stdlib : getenv;
    import cidrus : strlen;
}

/******************************************************************************
 *
 * The ВремФайл class aims в_ provопрe a safe way of creating and destroying
 * temporary файлы.  The ВремФайл class will automatically закрой temporary
 * файлы when the объект is destroyed, so it is recommended that you сделай
 * appropriate use of scoped destruction.
 *
 * Temporary файлы can be создан with one of several styles, much like нормаль
 * Files.  ВремФайл styles have the following свойства:
 *
 * $(UL
 * $(LI $(B ОпцУдаления): this determines whether the файл should be destroyed
 * as soon as it is закрыт (transient,) or continue в_ persist even after the
 * application есть terminated (permanent.))
 * )
 *
 * Eventually, this will be expanded в_ give you greater control over the
 * temporary файл's свойства.
 *
 * For the typical use-case (creating a файл в_ temporarily сохрани данные too
 * large в_ fit преобр_в память,) the following is sufficient:
 *
 * -----
 *  {
 *      scope temp = new ВремФайл;
 *      
 *      // Use temp as a нормаль провод; it will be automatically закрыт when
 *      // it goes out of scope.
 *  }
 * -----
 *
 * $(B Important):
 * It is recommended that you $(I do not) use файлы создан by this class в_
 * сохрани sensitive information.  There are several known issues with the
 * текущ implementation that could allow an attacker в_ доступ the contents
 * of these temporary файлы.
 *
 * $(B Todo): Detail security свойства and guarantees.
 *
 ******************************************************************************/


class ВремФайл : Файл
{



    /+enum Visibility : ббайт
    {
        /**
         * The temporary файл will have читай and пиши доступ в_ it restricted
         * в_ the текущ пользователь.
         */
        User,
        /**
         * The temporary файл will have читай and пиши доступ available в_ any
         * пользователь on the system.
         */
        World
    }+/

    /**************************************************************************
     * 
     * This enumeration is used в_ control whether the temporary файл should
     * persist after the ВремФайл объект есть been destroyed.
     *
     **************************************************************************/

    enum ОпцУдаления : ббайт
    {
        /**
         * The temporary файл should be destroyed along with the хозяин объект.
         */
        ВКорзину,
        /**
         * The temporary файл should persist after the объект есть been
         * destroyed.
         */
        Навсегда
    }

    /+enum Sensitivity : ббайт
    {
        /**
         * ВКорзину файлы will be truncated в_ zero length immediately
         * before closure в_ prevent casual filesystem inspection в_ recover
         * their contents.
         *
         * No добавьitional action is taken on permanent файлы.
         */
        Нет,
        /**
         * ВКорзину файлы will be zeroed-out before truncation, в_ маска their
         * contents из_ ещё thorough filesystem inspection.
         *
         * This опция is not compatible with permanent файлы.
         */
        Low
        /+
        /**
         * ВКорзину файлы will be overwritten первый with zeroes, then with
         * ones, and then with a random 32- or 64-bit образец (dependant on
         * which is most efficient.)  The файл will then be truncated.
         *
         * This опция is not compatible with permanent файлы.
         */
        Medium
        +/
    }+/

    /**************************************************************************
     * 
     * This structure is used в_ determine как the temporary файлы should be
     * opened and used.
     *
     **************************************************************************/
    align(1) struct СтильВремфл
    {
        //Visibility visibility;      ///
        ОпцУдаления удаление;        ///
        //Sensitivity sensitivity;    ///
        //Общ совместно;                ///
        //Кэш кэш;                ///
        ббайт попытки = 10;          ///
    }

    /**
     * СтильВремфл for creating a transient temporary файл that only the текущ
     * пользователь can доступ.
     */
    static const СтильВремфл ВКорзину = {ОпцУдаления.ВКорзину};
    /**
     * СтильВремфл for creating a permanent temporary файл that only the текущ
     * пользователь can доступ.
     */
    static const СтильВремфл Навсегда = {ОпцУдаления.Навсегда};

    // Путь в_ the temporary файл
    private ткст _path;

    // СтильВремфл we've opened with
    private СтильВремфл _style;

    ///
    this(СтильВремфл стиль = СтильВремфл.init)
    {
        открой (стиль);
    }

    ///
    this(ткст префикс, СтильВремфл стиль = СтильВремфл.init)
    {
        открой (префикс, стиль);
    }

    /**************************************************************************
     *
     * Indicates the стиль that this ВремФайл was создан with.
     *
     **************************************************************************/
    СтильВремфл стильВремфл()
    {
        return _style;
    }

    /*
     * Creates a new temporary файл with the given стиль.
     */
    private проц открой (СтильВремфл стиль)
    {
        открой (времфлПуть, стиль);
    }

    private проц открой (ткст префикс, СтильВремфл стиль)
    {
        for( ббайт i=стиль.попытки; i--; )
        {
            if( окройВремфл(Путь.объедини(префикс, randomName), стиль) )
                return;
        }

        throw new ВВИскл("не удалось создать временный файл");
    }

    version( Win32 )
    {
        private static const DEFAULT_LENGTH = 6;
        private static const DEFAULT_PREFIX = "~t";
        private static const DEFAULT_SUFFIX = ".temp";

        private static const JUNK_CHARS = 
            "abcdefghijklmnopqrstuvwxyz0123456789";

       /**********************************************************************
         * 
         * Returns the путь в_ the дир where temporary файлы will be
         * создан.  The returned путь is safe в_ измени.
         *
         **********************************************************************/
        public static ткст времфлПуть()
        {
            return GetTempPath;
        }

        /*
         * Creates a new temporary файл at the given путь, with the specified
         * стиль.
         */
        private бул окройВремфл(ткст путь, СтильВремфл стиль)
        {
            // TODO: Check permissions directly and throw an исключение;
            // otherwise, we could spin trying в_ сделай a файл when it's
            // actually not possible.

            Стиль filestyle = {Доступ.ЧитЗап, Откр.Нов, 
                               Общ.Нет, Кэш.Нет};

            DWORD атр;

            // Набор up флаги
            атр = reparseSupported ? FILE_FLAG_OPEN_REPARSE_POINT : 0;
            if( стиль.удаление == ОпцУдаления.ВКорзину )
                атр |= FILE_FLAG_DELETE_ON_CLOSE;

            if (!super.открой (путь, filestyle, атр))
                return нет;

            _style = стиль;
            return да;
        }
    }
    else version( Posix )
    {
        private static const DEFAULT_LENGTH = 6;
        private static const DEFAULT_PREFIX = ".temp";

        // Use "~" в_ work around a bug in DMD where it elопрes пустой constants
        private static const DEFAULT_SUFFIX = "~";

        private static const JUNK_CHARS = 
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            "abcdefghijklmnopqrstuvwxyz0123456789";

       /**********************************************************************
         * 
         * Returns the путь в_ the дир where temporary файлы will be
         * создан.  The returned путь is safe в_ измени.
         *
         **********************************************************************/
        public static ткст времфлПуть()
        {
            // Check for TMPDIR; failing that, use /врем
            сим* ptr = getenv ("TMPDIR");
            if (ptr is пусто)
                return "/врем/";
            else 
                return ptr[0 .. strlen (ptr)].dup;
        }

        /*
         * Creates a new temporary файл at the given путь, with the specified
         * стиль.
         */
        private бул окройВремфл(ткст путь, СтильВремфл стиль)
        {
            // Check suitability
            {
                auto parentz = вТкст0(Путь.разбор(путь).путь);

                // Make sure we have пиши доступ
                if( доступ(parentz, W_OK) == -1 )
                    ошибка("нет доступа к временной папке");

                // Get инфо on дир
                stat_t sb;
                if( stat(parentz, &sb) == -1 )
                    ошибка("статистика временной папки недоступна");

                // Get корень's UID
                auto pwe = getpwnam("корень");
                if( pwe is пусто ) ошибка("не удалось получить Уид корня");
                auto root_uопр = pwe.pw_uопр;
                
                // Make sure either we or корень are the хозяин
                if( !(sb.st_uопр == root_uопр || sb.st_uопр == getuопр) )
                    ошибка("временная папка не принадлежит ни root и ни пользователь");

                // Check в_ see if anyone другой than us can пиши в_ the Пап.
                if( (sb.st_mode & 022) != 0 && (sb.st_mode & 01000) == 0 )
                    ошибка("не установлен бит-наклейка (sticky bit) на папку для общей записи");
            }

            // Созд файл
            {
                Стиль filestyle = {Доступ.ЧитЗап, Откр.Нов, 
                                   Общ.Нет, Кэш.Нет};

                auto добфлаги = O_NOFOLLOW;

                if (!super.открой(путь, filestyle, добфлаги, 0600))
                    return нет;

                if( стиль.удаление == ОпцУдаления.ВКорзину )
                {
                    // BUG TODO: check в_ сделай sure the путь still points
                    // в_ the файл we opened.  Pity you can't отвяжи a файл
                    // descrИПtor...

                    // NOTE: This should be an исключение and not simply
                    // returning нет, since this is a violation of our
                    // guarantees.
                    if( отвяжи(вТкст0(путь)) == -1 )
                        ошибка("не удаётся удалить транзитивный файл");
                }

                _style = стиль;

                return да;
            }
        }
    }
    else
    {
        static assert(нет, "Не поддерживаемая платформа");
    }

    /*
     * Generates a new random файл имя, sans дир.
     */
    private ткст randomName(бцел length=DEFAULT_LENGTH,
            ткст префикс=DEFAULT_PREFIX,
            ткст суффикс=DEFAULT_SUFFIX)
    {
        auto junk = new сим[length];
        scope(exit) delete junk;

        foreach( ref c ; junk )
            c = JUNK_CHARS[Kiss.экземпляр.вЦел($)];

        return префикс~junk~суффикс;
    }
    
    override проц открепи()
    {
        static assert( !is(Sensitivity) );
        super.открепи();
    }
}

/+
version( TempFile_SelfTest ):

import io.Console : Кввод;
import io.Stdout : Стдвыв;

проц main()
{
    Стдвыв(r"
Please ensure that the transient file no longer to once the ВремФайл
объект is destroyed, and that the permanent file does.  You should also check
the following on Всё:

 * the файл should be owned by you,
 * the хозяин should have читай and пиши permissions,
 * no другой permissions should be установи on the файл.

For POSIX systems:

 * the temp дир should be owned by either корень or you,
 * if anyone другой than корень or you can пиши в_ it, the sticky bit should be
   установи,
 * if the дир is записываемый by anyone другой than корень or the пользователь, and the
   sticky bit is *not* установи, then creating the temporary файл should краш.

You might want в_ delete the permanent one afterwards, too. :)")
    .нс;

    Стдвыв.форматнс("Creating a transient file:");
    {
        scope времФайл = new ВремФайл(/*ВремФайл.UserPermanent*/);

        Стдвыв.форматнс(" .. путь: {}", времФайл);

        времФайл.пиши("ВКорзину temp файл.");

        ткст буфер = new сим[1023];
        времФайл.сместись(0);
        буфер = буфер[0..времФайл.читай(буфер)];

        Стдвыв.форматнс(" .. contents: \"{}\"", буфер);

        Стдвыв(" .. нажми Enter to destroy ВремФайл объект.").нс;
        Кввод.копируйнс();
    }

    Стдвыв.нс;

    Стдвыв.форматнс("Creating a permanent файл:");
    {
        scope времФайл = new ВремФайл(ВремФайл.Навсегда);

        Стдвыв.форматнс(" .. путь: {}", времФайл);

        времФайл.пиши("Навсегда temp файл.");

        ткст буфер = new сим[1023];
        времФайл.сместись(0);
        буфер = буфер[0..времФайл.читай(буфер)];

        Стдвыв.форматнс(" .. contents: \"{}\"", буфер);

        Стдвыв(" .. нажми Enter в_ destroy ВремФайл объект.").слей;
        Кввод.копируйнс();
    }

    Стдвыв("\nDone.").нс;
}

+/
