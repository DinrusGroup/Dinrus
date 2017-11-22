/*******************************************************************************

        copyright:      Copyright (c) 2007 Dinrus. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Feb 2007: Initial release

        author:         Deewiant, Maxter, Gregor, Kris

*******************************************************************************/

module sys.Environment;

private import  sys.Common;

private import  io.Path,
                io.FilePath;

private import  exception;

private import  io.model;

private import  Текст = text.Util;

/*******************************************************************************

        Platform decls

*******************************************************************************/

version (Windows)
{
        private import text.convert.Utf;

        pragma (lib, "import.lib");

        extern (Windows)
        {
                private ук  GetEnvironmentStringsW();
                private бул FreeEnvironmentStringsW(шим**);
        }
        extern (Windows)
        {
                private цел SetEnvironmentVariableW(шим*, шим*);
                private бцел GetEnvironmentVariableW(шим*, шим*, бцел);
                private const цел ERROR_ENVVAR_NOT_FOUND = 203;
        }
}
else
{
    version (darwin)
    {
        extern (C) сим*** _NSGetEnviron();
        private сим** environ;
        
        static this ()
        {
            environ = *_NSGetEnviron();
        }
    }
    
    else
        private extern (C) extern сим** environ;

    import rt.core.stdc.posix.stdlib;
    import cidrus;
}


/*******************************************************************************

        Exposes the system Среда settings, along with some handy
        utilities

*******************************************************************************/

struct Среда
{
        public alias текрабпап дир;
                    
        /***********************************************************************

                Throw an исключение

        ***********************************************************************/

        private static проц исключение (ткст сооб)
        {
                throw new PlatformException (сооб);
        }
        
        /***********************************************************************

            Returns an абсолютный version of the provопрed путь, where текрабпап is used
            as the префикс.

            The provопрed путь is returned as is if already абсолютный.

        ***********************************************************************/


        static ткст вАбсолют(ткст путь)
        {
            scope fp = new ФПуть(путь);
            if (fp.абс_ли)
                return путь;

            fp.абсолютный(текрабпап);
            return fp.вТкст;
        }

        /***********************************************************************

                Returns the full путь location of the provопрed executable
                файл, rifling through the PATH as necessary.

                Returns пусто if the provопрed имяф was не найден

        ***********************************************************************/

        static ФПуть путьКЭкзэ (ткст файл)
        {
                auto bin = new ФПуть (файл);

                // on Windows, this is a .exe
                version (Windows)
                         if (bin.расш.length is 0)
                             bin.суффикс = "exe";

                // is this a дир? Potentially сделай it абсолютный
                if (bin.ветвь_ли && !bin.абс_ли)
                    return bin.абсолютный (текрабпап);

                // is it in текрабпап?
                version (Windows)
                         if (bin.путь(текрабпап).есть_ли)
                             return bin;
/+ вынужден убрать в коммент из-за шаблона
                // rifle through the путь (after converting в_ стандарт форматируй)
                foreach (pe; Текст.образцы (стандарт(получи("PATH")), ФайлКонст.СимСистПуть))
                         if (bin.путь(pe).есть_ли)
                             version (Windows)
                                      return bin;
                                  else
                                     {
                                     stat_t статс;
                                     stat(bin.сиТкст.ptr, &статс);
                                     if (статс.st_mode & 0100)
                                         return bin;
                                     }+/
                return пусто;
        }

        /***********************************************************************

                Windows implementation

        ***********************************************************************/

        version (Windows)
        {
                /**************************************************************

                        Returns the provопрed 'def' значение if the переменная 
                        does not exist

                **************************************************************/

                static ткст получи (ткст переменная, ткст def = пусто)
                {
                        шим[] var = вТкст16(переменная) ~ "\0";

                        бцел размер = GetEnvironmentVariableW(var.ptr, cast(шим*)пусто, 0);
                        if (размер is 0)
                           {
                           if (СисОш.последнКод is ERROR_ENVVAR_NOT_FOUND)
                               return def;
                           else
                              исключение (СисОш.последнСооб);
                           }

                        auto буфер = new шим[размер];
                        размер = GetEnvironmentVariableW(var.ptr, буфер.ptr, размер);
                        if (размер is 0)
                            исключение (СисОш.последнСооб);

                        return вТкст (буфер[0 .. размер]);
                }

                /**************************************************************

                        clears the переменная if значение is пусто or пустой

                **************************************************************/

                static проц установи (ткст переменная, ткст значение = пусто)
                {
                        шим * var, знач;

                        var = (вТкст16 (переменная) ~ "\0").ptr;

                        if (значение.length > 0)
                            знач = (вТкст16 (значение) ~ "\0").ptr;

                        if (! SetEnvironmentVariableW(var, знач))
                              исключение (СисОш.последнСооб);
                }

                /**************************************************************

                        Get все установи environment variables as an associative
                        Массив.

                **************************************************************/

                static ткст[ткст] получи ()
                {
                        ткст[ткст] масс;

                        шим[] ключ = new шим[20],
                                значение = new шим[40];

                        шим** среда = cast(шим**) GetEnvironmentStringsW();
                        scope (exit)
                               FreeEnvironmentStringsW (среда);

                        for (шим* ткт = cast(шим*) среда; *ткт; ++ткт)
                            {
                            т_мера k = 0, v = 0;

                            while (*ткт != '=')
                                  {
                                  ключ[k++] = *ткт++;

                                  if (k is ключ.length)
                                      ключ.length = 2 * ключ.length;
                                  }

                            ++ткт;

                            while (*ткт)
                                  {
                                  значение [v++] = *ткт++;

                                  if (v is значение.length)
                                      значение.length = 2 * значение.length;
                                  }

                            масс [вТкст(ключ[0 .. k])] = вТкст(значение[0 .. v]);
                            }

                        return масс;
                }

                /**************************************************************

                        Набор the current working дир

                **************************************************************/

                static проц текрабпап (ткст путь)
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

                /**************************************************************

                        Get the current working дир

                **************************************************************/

                static ткст текрабпап ()
                {
                        ткст путь;

                        version (Win32SansUnicode)
                                {
                                цел длин = GetCurrentDirectoryA (0, пусто);
                                auto Пап = new сим [длин];
                                GetCurrentDirectoryA (длин, Пап.ptr);
                                if (длин)
                                   {
                                   if (Пап[длин-2] is '/')
                                       Пап.length = длин-1;
                                   else
                                       Пап[длин-1] = '/'; 
                                   путь = стандарт (Пап);
                                   }
                                else
                                   исключение ("Не удалось получить текущую папку");
                                }
                             else
                                {
                                шим[MAX_PATH+2] врем =void;

                                auto длин = GetCurrentDirectoryW (0, пусто);
                                assert (длин < врем.length);
                                auto Пап = new сим [длин * 3];
                                GetCurrentDirectoryW (длин, врем.ptr); 
                                auto i = WideCharToMultiByte (CP_UTF8, 0, врем.ptr, длин, 
                                                              cast(PCHAR)Пап.ptr, Пап.length, пусто, пусто);
                                if (длин && i)
                                   {
                                   путь = стандарт (Пап[0..i]);
                                   if (путь[$-2] is '/')
                                       путь.length = путь.length-1;
                                   else
                                       путь[$-1] = '/';
                                   }
                                else
                                   исключение ("Не удалось получить текущую папку");
                                }

                        return путь;
                }

        }

        /***********************************************************************

                Posix implementation

        ***********************************************************************/

        version (Posix)
        {
                /**************************************************************

                        Returns the provопрed 'def' значение if the переменная 
                        does not exist

                **************************************************************/

                static ткст получи (ткст переменная, ткст def = пусто)
                {
                        сим* ptr = getenv ((переменная ~ '\0').ptr);

                        if (ptr is пусто)
                            return def;

                        return ptr[0 .. strlen(ptr)].dup;
                }

                /**************************************************************

                        clears the переменная, if значение is пусто or пустой
        
                **************************************************************/

                static проц установи (ткст переменная, ткст значение = пусто)
                {
                        цел результат;

                        if (значение.length is 0)
                            unsetenv ((переменная ~ '\0').ptr);
                        else
                           результат = setenv ((переменная ~ '\0').ptr, (значение ~ '\0').ptr, 1);

                        if (результат != 0)
                            исключение (СисОш.последнСооб);
                }

                /**************************************************************

                        Get все установи environment variables as an associative
                        Массив.

                **************************************************************/

                static ткст[ткст] получи ()
                {
                        ткст[ткст] масс;

                        for (сим** p = environ; *p; ++p)
                            {
                            т_мера k = 0;
                            сим* ткт = *p;

                            while (*ткт++ != '=')
                                   ++k;
                            ткст ключ = (*p)[0..k];

                            k = 0;
                            сим* знач = ткт;
                            while (*ткт++)
                                   ++k;
                            масс[ключ] = знач[0 .. k];
                            }

                        return масс;
                }

                /**************************************************************

                        Набор the current working дир

                **************************************************************/

                static проц текрабпап (ткст путь)
                {
                        сим[512] врем =void;
                        врем [путь.length] = 0;
                        врем[0..путь.length] = путь;

                        if (rt.core.stdc.posix.unistd.chdir (врем.ptr))
                            исключение ("Не удалось установить текущую папку");
                }

                /**************************************************************

                        Get the current working дир

                **************************************************************/

                static ткст текрабпап ()
                {
                        сим[512] врем =void;

                        сим *s = rt.core.stdc.posix.unistd.getcwd (врем.ptr, врем.length);
                        if (s is пусто)
                            исключение ("Не удалось получить текущую папку");

                        auto путь = s[0 .. strlen(s)+1].dup;
                        if (путь[$-2] is '/') // корень путь есть the slash
                            путь.length = путь.length-1;
                        else
                            путь[$-1] = '/';
                        return путь;
                }
        }
}

                
/*******************************************************************************


*******************************************************************************/

debug (Среда)
{
        import io.Console;


        проц main(ткст[] арги)
        {
        const ткст VAR = "TESTENVVAR";
        const ткст VAL1 = "VAL1";
        const ткст VAL2 = "VAL2";

        assert(Среда.получи(VAR) is пусто);

        Среда.установи(VAR, VAL1);
        assert(Среда.получи(VAR) == VAL1);

        Среда.установи(VAR, VAL2);
        assert(Среда.получи(VAR) == VAL2);

        Среда.установи(VAR, пусто);
        assert(Среда.получи(VAR) is пусто);

        Среда.установи(VAR, VAL1);
        Среда.установи(VAR, "");

        assert(Среда.получи(VAR) is пусто);

        foreach (ключ, значение; Среда.получи)
                 Квывод (ключ) ("=") (значение).нс;

        if (арги.length > 0)
           {
           auto p = Среда.путьКЭкзэ (арги[0]);
           Квывод (p).нс;
           }

        if (арги.length > 1)
           {
           if (auto p = Среда.путьКЭкзэ (арги[1]))
               Квывод (p).нс;
           }
        }
}

