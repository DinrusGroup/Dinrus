/*******************************************************************************
  copyright:   Copyright (c) 2006 Juan Jose Comellas. все rights reserved
  license:     BSD стиль: $(LICENSE)
  author:      Juan Jose Comellas <juanjo@comellas.com.ar>
*******************************************************************************/

module sys.Process;

private import io.model;
private import io.Console;
private import sys.Common;
private import sys.Pipe;
private import exception;
private import text.Util;
private import Целое = text.convert.Integer;

private import cidrus;
private import stringz;

version (Posix)
{
    private import cidrus;
    private import rt.core.stdc.posix.fcntl;
    private import rt.core.stdc.posix.unistd;
    private import rt.core.stdc.posix.sys.wait;

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
}

version (Windows)
{
  version (Win32SansUnicode)
  {
  }
  else
  {
    private import text.convert.Utf : вТкст16;
  }
}

debug (Процесс)
{
    private import io.Stdout;
}


/**
 * ПРедирект флаги for processes.  Defined outsопрe process class в_ cut down on
 * verbosity.
 */
enum ПРедирект
{
    /**
     * ПРедирект Неук of the стандарт handles
     */
    Нет = 0,

    /**
     * ПРедирект the стдвыв укз в_ a pipe.
     */
    Вывод = 1,

    /**
     * ПРедирект the стдош укз в_ a pipe.
     */
    Ошибка = 2,

    /**
     * ПРедирект the стдвхо укз в_ a pipe.
     */
    Ввод = 4,

    /**
     * ПРедирект все three handles в_ pИПes (default).
     */
    все = Вывод | Ошибка | Ввод,

    /**
     * Отправка стдош в_ стдвыв's укз.  Note that the стдош Трубопровод will
     * be пусто.
     */
    ОшНаВывод = 0x10,

    /**
     * Отправка стдвыв в_ стдош's укз.  Note that the стдвыв Трубопровод will
     * be пусто.
     */
    ВыводНаОш = 0x20,
}

/**
 * The Процесс class is used в_ старт external programs and communicate with
 * them via their стандарт ввод, вывод and ошибка Потокs.
 *
 * You can пароль either the команда строка or an Массив of аргументы в_ выполни,
 * either in the constructor or в_ the арги property. The environment
 * variables can be установи in a similar way using the среда property and you can
 * установи the program's working дир via the рабДир property.
 *
 * To actually старт a process you need в_ use the выполни() метод. Once the
 * program is running you will be able в_ пиши в_ its стандарт ввод via the
 * стдвхо ИПотокВывода and you will be able в_ читай из_ its стандарт вывод and
 * ошибка through the стдвыв and стдош ИПотокВвода respectively.
 *
 * You can check whether the process is running or not with the выполняется_ли()
 * метод and you can получи its process ID via the пид property.
 *
 * After you are готово with the process, or if you just want в_ жди for it в_
 * конец, you need в_ вызов the жди() метод which will return once the process
 * is no longer running.
 *
 * To stop a running process you must use затуши() метод. If you do this you
 * cannot вызов the жди() метод. Once the затуши() метод returns the process
 * will be already dead.
 * 
 * After calling either жди() or затуши(), and no ещё данные is ожидалось on the
 * pИПes, you should вызов закрой() as this will clean the pИПes. Not doing this
 * may lead в_ a depletion of the available файл descrИПtors for the main
 * process if many processes are создан.
 *
 * Examples:
 * ---
 * try
 * {
 *     auto p = new Процесс ("ls -al", пусто);
 *     p.выполни;
 *
 *     Стдвыв.форматнс ("Вывод из_ {}:", p.имяПрограммы);
 *     Стдвыв.копируй (p.стдвыв).слей;
 *     auto результат = p.жди;
 *
 *     Стдвыв.форматнс ("Процесс '{}' ({}) exited with резон {}, статус {}",
 *                      p.имяПрограммы, p.пид, cast(цел) результат.резон, результат.статус);
 * }
 * catch (ProcessException e)
 *        Стдвыв.форматнс ("Процесс execution неудачно: {}", e);
 * ---
 */
 
 
 
class Процесс
{



    /**
     * Результат returned by жди().
     */
    public struct Результат
    {
        /**
         * Reasons returned by жди() indicating why the process is no
         * longer running.
         */
        public enum
        {
            Выход,
            Сигнал,
            Стоп,
            Продолжение,
            Ошибка
        }

        public цел резон;
        public цел статус;

        /**
         * Returns a ткст with a descrИПtion of the process execution результат.
         */
        public ткст вТкст()
        {
            ткст ткт;

            switch (резон)
            {
                case Выход:
                    ткт = форматируй("Процесс завершился нормально с кодом возврата", статус);
                    break;

                case Сигнал:
                    ткт = форматируй("Процесс удушен с сигналом ", статус);
                    break;

                case Стоп:
                    ткт = форматируй("Процесс остановлен с сигналом ", статус);
                    break;

                case Продолжение:
                    ткт = форматируй("Процесс возобновлён с сигналом ", статус);
                    break;

                case Ошибка:
                    ткт = форматируй("Процесс рухнул с кодом ошибки ", резон) ~
                                 " : " ~ СисОш.найди(статус);
                    break;

                default:
                    ткт = форматируй("Результат процесса неизвестен ", резон);
                    break;
            }
            return ткт;
        }
    }

    static const бцел ДефРазмБуфераСтдвхо    = 512;
    static const бцел ДефРазмБуфераСтдвых   = 8192;
    static const бцел ДефРазмБуфераСтдош   = 512;
    static const ПРедирект ДефПеренаправФлаги  = ПРедирект.все;

    private ткст[]        _args;
    private ткст[ткст]  _env;
    private ткст          _workDir;
    private Трубопровод     _stdin;
    private Трубопровод     _stdout;
    private Трубопровод     _stderr;
    private бул            _running = нет;
    private бул            _copyEnv = нет;
    private ПРедирект        _redirect = ДефПеренаправФлаги;

    version (Windows)
    {
        private sys.win32.Types.PROCESS_INFORMATION *_info = пусто;
        private бул                 _gui = нет;
    }
    else
    {
        private pid_t _pid = cast(pid_t) -1;
    }

    /**
     * Constructor (variadic version).  Note that by default, the environment
     * will not be copied.
     *
     * Параметры:
     * арги     = Массив of ткстs with the process' аргументы.  If there is
     *            exactly one аргумент, it is consопрered в_ contain the entire
     *            команда строка включая параметры.  If you пароль only one
     *            аргумент, пробелы that are not intended в_ separate
     *            параметры should be embedded in кавычки.  The аргументы can
     *            also be пустой.
     *
     * Examples:
     * ---
     * auto p = new Процесс("myprogram", "first аргумент", "сукунда", "third");
     * auto p = new Процесс("myprogram \"first аргумент\" сукунда third");
     * ---
     */
    public this(ткст[] арги ...)
    {
        if(арги.length == 1)
            _args = разделиАрги(арги[0]);
        else
            _args = арги;
    }

    /**
     * Constructor (variadic version, with environment копируй).
     *
     * Параметры:
     * копирСред  = if да, the environment is copied из_ the current process.
     * арги     = Массив of ткстs with the process' аргументы.  If there is
     *            exactly one аргумент, it is consопрered в_ contain the entire
     *            команда строка включая параметры.  If you пароль only one
     *            аргумент, пробелы that are not intended в_ separate
     *            параметры should be embedded in кавычки.  The аргументы can
     *            also be пустой.
     *
     * Examples:
     * ---
     * auto p = new Процесс(да, "myprogram", "first аргумент", "сукунда", "third");
     * auto p = new Процесс(да, "myprogram \"first аргумент\" сукунда third");
     * ---
     */
    public this(бул копирСред, ткст[] арги ...)
    {
        _copyEnv = копирСред;
        this(арги);
    }

    /**
     * Constructor.
     *
     * Параметры:
     * команда  = ткст with the process' команда строка; аргументы that have
     *            embedded пробел must be enclosed in insопрe дво-кавычки (").
     * среда      = associative Массив of ткстs with the process' environment
     *            variables; the переменная имя must be the ключ of each Запись.
     *
     * Examples:
     * ---
     * ткст команда = "myprogram \"first аргумент\" сукунда third";
     * ткст[ткст] среда;
     *
     * // Среда variables
     * среда["MYVAR1"] = "first";
     * среда["MYVAR2"] = "сукунда";
     *
     * auto p = new Процесс(команда, среда)
     * ---
     */
    public this(ткст команда, ткст[ткст] среда)
    in
    {
        assert(команда.length > 0);
    }
    body
    {
        _args = разделиАрги(команда);
        _env = среда;
    }

    /**
     * Constructor.
     *
     * Параметры:
     * арги     = Массив of ткстs with the process' аргументы; the first
     *            аргумент must be the process' имя; the аргументы can be
     *            пустой.
     * среда      = associative Массив of ткстs with the process' environment
     *            variables; the переменная имя must be the ключ of each Запись.
     *
     * Examples:
     * ---
     * ткст[] арги;
     * ткст[ткст] среда;
     *
     * // Процесс имя
     * арги ~= "myprogram";
     * // Процесс аргументы
     * арги ~= "first аргумент";
     * арги ~= "сукунда";
     * арги ~= "third";
     *
     * // Среда variables
     * среда["MYVAR1"] = "first";
     * среда["MYVAR2"] = "сукунда";
     *
     * auto p = new Процесс(арги, среда)
     * ---
     */
    public this(ткст[] арги, ткст[ткст] среда)
    in
    {
        assert(арги.length > 0);
        assert(арги[0].length > 0);
    }
    body
    {
        _args = арги;
        _env = среда;
    }

    /**
     * Indicate whether the process is running or not.
     */
    public бул выполняется_ли()
    {
        return _running;
    }

    /**
     * Return the running process' ID.
     *
     * Возвращает: an цел with the process ID if the process is running;
     *          -1 if not.
     */
    public цел пид()
    {
        version (Windows)
        {
            return (_info !is пусто ? cast(цел) _info.dwProcessId : -1);
        }
        else // version (Posix)
        {
            return cast(цел) _pid;
        }
    }

    /**
     * Return the process' executable имяф.
     */
    public ткст имяПрограммы()
    {
        return (_args !is пусто ? _args[0] : пусто);
    }

    /**
     * Набор the process' executable имяф.
     */
    public ткст имяПрограммы(ткст имя)
    {
        if (_args.length == 0)
        {
            _args.length = 1;
        }
        return _args[0] = имя;
    }

    /**
     * Набор the process' executable имяф, return 'this' for chaining
     */
    public Процесс установиИмяПрограммы(ткст имя)
    {
        имяПрограммы = имя;
        return this;
    }

    /**
     * Return an Массив with the process' аргументы.
     */
    public ткст[] арги()
    {
        return _args;
    }

    /**
     * Набор the process' аргументы из_ the аргументы Приёмd by the метод.
     *
     * Remarks:
     * The first element of the Массив must be the имя of the process'
     * executable.
     *
     * Возвращает: the arugments that were установи.
     *
     * Examples:
     * ---
     * p.арги("myprogram", "first", "сукунда аргумент", "third");
     * ---
     */
    public ткст[] арги(ткст имяпроги, ткст[] арги ...)
    {
        return _args = имяпроги ~ арги;
    }

    /**
     * Набор the process' аргументы из_ the аргументы Приёмd by the метод.
     *
     * Remarks:
     * The first element of the Массив must be the имя of the process'
     * executable.
     *
     * Возвращает: a reference в_ this for chaining
     *
     * Examples:
     * ---
     * p.установиАрги("myprogram", "first", "сукунда аргумент", "third").выполни();
     * ---
     */
    public Процесс установиАрги(ткст имяпроги, ткст[] арги ...)
    {
        this.арги(имяпроги, арги);
        return this;
    }

    /**
     * If да, the environment из_ the current process will be copied в_ the
     * ветвь process.
     */
    public бул копирСред()
    {
        return _copyEnv;
    }

    /**
     * Набор the копирСред flag.  If установи в_ да, then the environment will be
     * copied из_ the current process.  If установи в_ нет, then the environment
     * is установи из_ the среда field.
     */
    public бул копирСред(бул b)
    {
        return _copyEnv = b;
    }

    /**
     * Набор the копирСред flag.  If установи в_ да, then the environment will be
     * copied из_ the current process.  If установи в_ нет, then the environment
     * is установи из_ the среда field.
     *
     * Возвращает:
     *   A reference в_ this for chaining
     */
    public Процесс установиКопирСред(бул b)
    {
        _copyEnv = b;
        return this;
    }

    /**
     * Return an associative Массив with the process' environment variables.
     *
     * Note that if копирСред is установи в_ да, this значение is ignored.
     */
    public ткст[ткст] среда()
    {
        return _env;
    }

    /**
     * Набор the process' environment variables из_ the associative Массив
     * Приёмd by the метод.
     *
     * This also clears the копирСред flag.
     *
     * Параметры:
     * среда  = associative Массив of ткстs containing the environment
     *        variables for the process. The переменная имя should be the ключ
     *        used for each Запись.
     *
     * Возвращает: the среда установи.
     * Examples:
     * ---
     * ткст[ткст] среда;
     *
     * среда["MYVAR1"] = "first";
     * среда["MYVAR2"] = "сукунда";
     *
     * p.среда = среда;
     * ---
     */
    public ткст[ткст] среда(ткст[ткст] среда)
    {
        _copyEnv = нет;
        return _env = среда;
    }

    /**
     * Набор the process' environment variables из_ the associative Массив
     * Приёмd by the метод.  Returns a 'this' reference for chaining.
     *
     * This also clears the копирСред flag.
     *
     * Параметры:
     * среда  = associative Массив of ткстs containing the environment
     *        variables for the process. The переменная имя should be the ключ
     *        used for each Запись.
     *
     * Возвращает: A reference в_ this process объект
     * Examples:
     * ---
     * ткст[ткст] среда;
     *
     * среда["MYVAR1"] = "first";
     * среда["MYVAR2"] = "сукунда";
     *
     * p.установиСреду(среда).выполни();
     * ---
     */
    public Процесс установиСреду(ткст[ткст] среда)
    {
        _copyEnv = нет;
        _env = среда;
        return this;
    }

    /**
     * Return an UTF-8 ткст with the process' команда строка.
     */
    public ткст вТкст()
    {
        ткст команда;

        for (бцел i = 0; i < _args.length; ++i)
        {
            if (i > 0)
            {
                команда ~= ' ';
            }
            if (содержит(_args[i], ' ') || _args[i].length == 0)
            {
                команда ~= '"';
                команда ~= _args[i].подставь("\\", "\\\\").подставь(`"`, `\"`);
                команда ~= '"';
            }
            else
            {
                команда ~= _args[i].подставь("\\", "\\\\").подставь(`"`, `\"`);
            }
        }
        return команда;
    }

    /**
     * Return the working дир for the process.
     *
     * Возвращает: a ткст with the working дир; пусто if the working
     *          дир is the current дир.
     */
    public ткст рабДир()
    {
        return _workDir;
    }

    /**
     * Набор the working дир for the process.
     *
     * Параметры:
     * Пап  = a ткст with the working дир; пусто if the working
     *         дир is the current дир.
     *
     * Возвращает: the дир установи.
     */
    public ткст рабДир(ткст Пап)
    {
        return _workDir = Пап;
    }

    /**
     * Набор the working дир for the process.  Returns a 'this' reference
     * for chaining
     *
     * Параметры:
     * Пап  = a ткст with the working дир; пусто if the working
     *         дир is the current дир.
     *
     * Возвращает: a reference в_ this process.
     */
    public Процесс установиРабДир(ткст пап)
    {
        _workDir = пап;
        return this;
    }

    /**
     * Get the перенаправ флаги for the process.
     *
     * The перенаправ флаги are used в_ determine whether стдвыв, стдош, or
     * стдвхо are перенаправленый.  The флаги are an or'd combination of which
     * стандарт handles в_ перенаправ.  A перенаправленый укз creates a pipe,
     * whereas a non-перенаправленый укз simply points в_ the same укз this
     * process is pointing в_.
     *
     * You can also перенаправ стдвыв or стдош в_ each другой.  The флаги в_
     * перенаправ a укз в_ a pipe and в_ перенаправ it в_ другой укз are
     * mutually исключительно.  In the case Всё are specified, the перенаправ в_
     * the другой укз takes precedent.  It is illegal в_ specify Всё
     * redirection из_ стдвыв в_ стдош and из_ стдош в_ стдвыв.  If Всё
     * of these are specified, an исключение is thrown.
     * 
     * If перенаправленый в_ a pipe, once the process is executed successfully, its
     * ввод and вывод can be manИПulated through the стдвхо, стдвыв and
     * стдош member Трубопровод's.  Note that if you перенаправ for example
     * стдош в_ стдвыв, and you перенаправ стдвыв в_ a pipe, only стдвыв will
     * be non-пусто.
     */
    public ПРедирект перенаправ()
    {
        return _redirect;
    }

    /**
     * Набор the перенаправ флаги for the process.
     */
    public ПРедирект перенаправ(ПРедирект флаги)
    {
        return _redirect = флаги;
    }

    /**
     * Набор the перенаправ флаги for the process.  Return a reference в_ this
     * process for chaining.
     */
    public Процесс установиПеренаправ(ПРедирект флаги)
    {
        _redirect = флаги;
        return this;
    }

    /**
     * Get the GUI flag.
     *
     * This flag indicates on Windows systems that the CREATE_NO_WINDOW flag
     * should be установи on CreateProcess.  Although this is a specific windows
     * flag, it is present on posix systems as a noop for compatibility.
     *
     * Without this flag, a console window will be allocated if it doesn't
     * already exist.
     */
    public бул гип()
    {
        version(Windows)
            return _gui;
        else
            return нет;
    }

    /**
     * Набор the GUI flag.
     *
     * This flag indicates on Windows systems that the CREATE_NO_WINDOW flag
     * should be установи on CreateProcess.  Although this is a specific windows
     * flag, it is present on posix systems as a noop for compatibility.
     *
     * Without this flag, a console window will be allocated if it doesn't
     * already exist.
     */
    public бул гип(бул значение)
    {
        version(Windows)
            return _gui = значение;
        else
            return нет;
    }

    /**
     * Набор the GUI flag.  Returns a reference в_ this process for chaining.
     *
     * This flag indicates on Windows systems that the CREATE_NO_WINDOW flag
     * should be установи on CreateProcess.  Although this is a specific windows
     * flag, it is present on posix systems as a noop for compatibility.
     *
     * Without this flag, a console window will be allocated if it doesn't
     * already exist.
     */
    public Процесс установиГип(бул значение)
    {
        version(Windows)
        {
            _gui = значение;
        }
        return this;
    }

    /**
     * Return the running process' стандарт ввод pipe.
     *
     * Возвращает: a пиши-only Трубопровод подключен в_ the ветвь
     *          process' стдвхо.
     *
     * Remarks:
     * The поток will be пусто if no ветвь process есть been executed, or the
     * стандарт ввод поток was not перенаправленый.
     */
    public Трубопровод стдвхо()
    {
        return _stdin;
    }

    /**
     * Return the running process' стандарт вывод pipe.
     *
     * Возвращает: a читай-only Трубопровод подключен в_ the ветвь
     *          process' стдвыв.
     *
     * Remarks:
     * The поток will be пусто if no ветвь process есть been executed, or the
     * стандарт вывод поток was not перенаправленый.
     */
    public Трубопровод стдвыв()
    {
        return _stdout;
    }

    /**
     * Return the running process' стандарт ошибка pipe.
     *
     * Возвращает: a читай-only Трубопровод подключен в_ the ветвь
     *          process' стдош.
     *
     * Remarks:
     * The поток will be пусто if no ветвь process есть been executed, or the
     * стандарт ошибка поток was not перенаправленый.
     */
    public Трубопровод стдош()
    {
        return _stderr;
    }

    /**
     * Execute a process using the аргументы as параметры в_ this метод.
     *
     * Once the process is executed successfully, its ввод and вывод can be
     * manИПulated through the стдвхо, стдвыв and
     * стдош member Трубопровод's.
     *
     * Throws:
     * ИсклСозданияПроцесса if the process could not be создан
     * successfully; ИсклВетвленияПроцесса if the вызов в_ the fork()
     * system вызов неудачно (on POSIX-compatible platforms).
     *
     * Remarks:
     * The process must not be running and the provопрed список of аргументы must
     * not be пустой. If there was any аргумент already present in the арги
     * member, they will be replaced by the аргументы supplied в_ the метод.
     *
     * Deprecated: Use constructor or свойства в_ установи up process for
     * execution.
     */
    deprecated public проц выполни(ткст arg1, ткст[] арги ...)
    in
    {
        assert(!_running);
    }
    body
    {
        this._args = arg1 ~ арги;
        выполни();
    }

    /**
     * Execute a process using the команда строка аргументы as параметры в_
     * this метод.
     *
     * Once the process is executed successfully, its ввод and вывод can be
     * manИПulated through the стдвхо, стдвыв and
     * стдош member Трубопровод's.
     *
     * This also clears the копирСред flag
     *
     * Параметры:
     * команда  = ткст with the process' команда строка; аргументы that have
     *            embedded пробел must be enclosed in insопрe дво-кавычки (").
     * среда      = associative Массив of ткстs with the process' environment
     *            variables; the переменная имя must be the ключ of each Запись.
     *
     * Throws:
     * ИсклСозданияПроцесса if the process could not be создан
     * successfully; ИсклВетвленияПроцесса if the вызов в_ the fork()
     * system вызов неудачно (on POSIX-compatible platforms).
     *
     * Remarks:
     * The process must not be running and the provопрed список of аргументы must
     * not be пустой. If there was any аргумент already present in the арги
     * member, they will be replaced by the аргументы supplied в_ the метод.
     *
     * Deprecated: use свойства or the constructor в_ установи these параметры
     * instead.
     */
    deprecated public проц выполни(ткст команда, ткст[ткст] среда)
    in
    {
        assert(!_running);
        assert(команда.length > 0);
    }
    body
    {
        _args = разделиАрги(команда);
        _copyEnv = нет;
        _env = среда;
        выполни();
    }

    /**
     * Execute a process using the команда строка аргументы as параметры в_
     * this метод.
     *
     * Once the process is executed successfully, its ввод and вывод can be
     * manИПulated through the стдвхо, стдвыв and
     * стдош member Трубопровод's.
     *
     * This also clears the копирСред flag
     *
     * Параметры:
     * арги     = Массив of ткстs with the process' аргументы; the first
     *            аргумент must be the process' имя; the аргументы can be
     *            пустой.
     * среда      = associative Массив of ткстs with the process' environment
     *            variables; the переменная имя must be the ключ of each Запись.
     *
     * Throws:
     * ИсклСозданияПроцесса if the process could not be создан
     * successfully; ИсклВетвленияПроцесса if the вызов в_ the fork()
     * system вызов неудачно (on POSIX-compatible platforms).
     *
     * Remarks:
     * The process must not be running and the provопрed список of аргументы must
     * not be пустой. If there was any аргумент already present in the арги
     * member, they will be replaced by the аргументы supplied в_ the метод.
     *
     * Deprecated:
     * Use свойства or the constructor в_ установи these параметры instead.
     *
     * Examples:
     * ---
     * auto p = new Процесс();
     * ткст[] арги;
     *
     * арги ~= "ls";
     * арги ~= "-l";
     *
     * p.выполни(арги, пусто);
     * ---
     */
    deprecated public проц выполни(ткст[] арги, ткст[ткст] среда)
    in
    {
        assert(!_running);
        assert(арги.length > 0);
    }
    body
    {
        _args = арги;
        _env = среда;
        _copyEnv = нет;

        выполни();
    }

    /**
     * Execute a process using the аргументы that were supplied в_ the
     * constructor or в_ the арги property.
     *
     * Once the process is executed successfully, its ввод and вывод can be
     * manИПulated through the стдвхо, стдвыв and
     * стдош member Трубопровод's.
     *
     * Возвращает:
     * A reference в_ this process объект for chaining.
     *
     * Throws:
     * ИсклСозданияПроцесса if the process could not be создан
     * successfully; ИсклВетвленияПроцесса if the вызов в_ the fork()
     * system вызов неудачно (on POSIX-compatible platforms).
     *
     * Remarks:
     * The process must not be running and the список of аргументы must
     * not be пустой before calling this метод.
     */
    public Процесс выполни()
    in
    {
        assert(!_running);
        assert(_args.length > 0 && _args[0] !is пусто);
    }
    body
    {
        version (Windows)
        {
            SECURITY_ATTRIBUTES sa;
            sys.win32.Types.STARTUPINFO         startup;

            // We закрой and delete the pИПes that could have been left открой
            // из_ a previous execution.
            удалиПайпы();

            // Набор up the security атрибуты struct.
            sa.nLength = SECURITY_ATTRIBUTES.sizeof;
            sa.lpSecurityDescriptor = пусто;
            sa.bInheritHandle = да;

            // Набор up члены of the STARTUPINFO structure.
            memset(&startup, '\0', sys.win32.Types.STARTUPINFO.sizeof);
            startup.cb = sys.win32.Types.STARTUPINFO.sizeof;

            Пайп pin, pout, perr;
            if(_redirect != ПРедирект.Нет)
            {
                if((_redirect & (ПРедирект.ВыводНаОш | ПРедирект.ОшНаВывод)) == (ПРедирект.ВыводНаОш | ПРедирект.ОшНаВывод))
                    throw new ИсклСозданияПроцесса(_args[0], "Нелегальные флаги перенаправления", __FILE__, __LINE__);
                //
                // some redirection is specified, установи the flag that indicates
                startup.dwFlags |= STARTF_USESTDHANDLES;

                // Create the pИПes used в_ communicate with the ветвь process.
                if(_redirect & ПРедирект.Ввод)
                {
                    pin = new Пайп(ДефРазмБуфераСтдвхо, &sa);
                    // Замени стдвхо with the "читай" pipe
                    _stdin = pin.сток;
                    startup.hStdInput = cast(HANDLE) pin.источник.фукз();
                    // Ensure the пиши укз в_ the pipe for STDIN is not inherited.
                    SetHandleInformation(cast(HANDLE) pin.сток.фукз(), HANDLE_FLAG_INHERIT, 0);
                }
                else
                {
                    // need в_ получи the local process стдвхо укз
                    startup.hStdInput = GetStdHandle(STD_INPUT_HANDLE);
                }

                if((_redirect & (ПРедирект.Вывод | ПРедирект.ВыводНаОш)) == ПРедирект.Вывод)
                {
                    pout = new Пайп(ДефРазмБуфераСтдвых, &sa);
                    // Замени стдвыв with the "пиши" pipe
                    _stdout = pout.источник;
                    startup.hStdOutput = cast(HANDLE) pout.сток.фукз();
                    // Ensure the читай укз в_ the pipe for STDOUT is not inherited.
                    SetHandleInformation(cast(HANDLE) pout.источник.фукз(), HANDLE_FLAG_INHERIT, 0);
                }
                else
                {
                    // need в_ получи the local process стдвыв укз
                    startup.hStdOutput = GetStdHandle(STD_OUTPUT_HANDLE);
                }

                if((_redirect & (ПРедирект.Ошибка | ПРедирект.ОшНаВывод)) == ПРедирект.Ошибка)
                {
                    perr = new Пайп(ДефРазмБуфераСтдош, &sa);
                    // Замени стдош with the "пиши" pipe
                    _stderr = perr.источник;
                    startup.hStdError = cast(HANDLE) perr.сток.фукз();
                    // Ensure the читай укз в_ the pipe for STDOUT is not inherited.
                    SetHandleInformation(cast(HANDLE) perr.источник.фукз(), HANDLE_FLAG_INHERIT, 0);
                }
                else
                {
                    // need в_ получи the local process стдош укз
                    startup.hStdError = GetStdHandle(STD_ERROR_HANDLE);
                }

                // do redirection из_ one укз в_ другой
                if(_redirect & ПРедирект.ОшНаВывод)
                {
                    startup.hStdError = startup.hStdOutput;
                }

                if(_redirect & ПРедирект.ВыводНаОш)
                {
                    startup.hStdOutput = startup.hStdError;
                }
            }
            
            // закрой the unused конец of the pИПes on scope exit
            scope(exit)
            {
                if(pin !is пусто)
                    pin.источник.закрой();
                if(pout !is пусто)
                    pout.сток.закрой();
                if(perr !is пусто)
                    perr.сток.закрой();
            }

            _info = new PROCESS_INFORMATION;
            // Набор up члены of the PROCESS_INFORMATION structure.
            memset(_info, '\0', PROCESS_INFORMATION.sizeof);

           /* 
            * кавычки and backslashes in the команда строка are handled very
            * strangely by Windows.  Through trial and ошибка, I believe that
            * these are the rules:
            *
            * insопрe or outsопрe quote режим:
            * 1. if 2 or ещё backslashes are followed by a quote, the first
            *    2 backslashes are reduced в_ 1 backslash which does not
            *    affect anything after it.
            * 2. one backslash followed by a quote is interpreted as a
            *    literal quote, which cannot be used в_ закрой quote режим, and
            *    does not affect anything after it.
            *
            * outsопрe quote режим:
            * 3. a quote enters quote режим
            * 4. пробел delineates an аргумент
            *
            * insопрe quote режим:
            * 5. 2 кавычки sequentially are interpreted as a literal quote and
            *    an exit из_ quote режим.
            * 6. a quote at the конец of the ткст, or one that is followed by
            *    anything другой than a quote exits quote режим, but does not
            *    affect the character after the quote.
            * 7. конец of строка exits quote режим
            *
            * In our 'реверс' routine, we will only utilize the first 2 rules
            * for escapes.
            */
            ткст команда;
            foreach(a; _args)
            {
              ткст nextarg = a.подставь(`"`, `\"`);
              //
              // найди все instances where \\" occurs, and дво все the
              // backslashes.  Otherwise, it will fall under правило 1, and those
              // backslashes will be halved.
              //
              бцел поз = 0;
              while((поз = nextarg.местоположениеОбразца(`\\"`, поз)) < nextarg.length)
              {
                //
                // перемести back until we have все the backslashes
                //
                бцел afterback = поз+1;
                while(поз > 0 && nextarg[поз - 1] == '\\')
                  поз--;

                //
                // дво the число of backslashes that do not escape the
                // quote
                //
                nextarg = nextarg[0..afterback] ~ nextarg[поз..$];
                поз = afterback + afterback - поз + 2;
              }

              //
              // check в_ see if we need в_ surround the арг with кавычки.
              //
              if(nextarg.length == 0)
              {
                nextarg = `""`;
              }
              else if(nextarg.содержит(' '))
              {
                //
                // surround with кавычки, but if the арг заканчивается in backslashes,
                // we must дво все the backslashes, or they will fall under
                // правило 1 and be halved.
                //
                
                if(nextarg[$-1] == '\\')
                {
                  //
                  // заканчивается in a backslash.  счёт все the \'s at the конец of the
                  // ткст, and repeat them
                  //
                  поз = nextarg.length - 1;
                  while(поз > 0 && nextarg[поз-1] == '\\')
                    поз--;
                  nextarg ~= nextarg[поз..$];
                }

                // surround the аргумент with кавычки
                nextarg = '"' ~ nextarg ~ '"';
              }

              команда ~= ' ';
              команда ~= nextarg;
            }

            команда ~= '\0';
            команда = команда[1..$];

            // old way
            //ткст команда = вТкст();
            //команда ~= '\0';

            version(Win32SansUnicode)
            {
              //
              // ASCII version of CreateProcess
              //

              // Convert the working дир в_ a пусто-ended ткст if
              // necessary.
              //
              // Note, this used в_ contain DETACHED_PROCESS, but
              // this causes problems with redirection if the program being
              // пущен decопрes в_ размести a console (i.e. if you run a batch
              // файл)
              if (CreateProcessA(пусто, команда.ptr, пусто, пусто, да,
                    _gui ? CREATE_NO_WINDOW : 0,
                    (_copyEnv ? пусто : toNullEndedBuffer(_env).ptr),
                    вТкст0(_workDir), &startup, _info))
              {
                CloseHandle(_info.hThread);
                _running = да;
              }
              else
              {
                throw new ИсклСозданияПроцесса(_args[0], __FILE__, __LINE__);
              }
            }
            else
            {
              // Convert the working дир в_ a пусто-ended ткст if
              // necessary.
              //
              // Note, this used в_ contain DETACHED_PROCESS, but
              // this causes problems with redirection if the program being
              // пущен decопрes в_ размести a console (i.e. if you run a batch
              // файл)
              if (CreateProcessW(пусто, вТкст16(команда).ptr, пусто, пусто, да,
                    _gui ? CREATE_NO_WINDOW : 0,
                    (_copyEnv ? пусто : toNullEndedBuffer(_env).ptr),
                    stringz.вТкст16н(cast(шткст)_workDir), &startup, _info))
              {
                CloseHandle(_info.hThread);
                _running = да;
              }
              else
              {
                throw new ИсклСозданияПроцесса(_args[0], __FILE__, __LINE__);
              }
            }
        }
        else version (Posix)
        {
            // We закрой and delete the pИПes that could have been left открой
            // из_ a previous execution.
            удалиПайпы();

            // оцени the redirection флаги
            if((_redirect & (ПРедирект.ВыводНаОш | ПРедирект.ОшНаВывод)) == (ПРедирект.ВыводНаОш | ПРедирект.ОшНаВывод))
                throw new ИсклСозданияПроцесса(_args[0], "Нелегальные флаги перенаправления", __FILE__, __LINE__);


            Пайп pin, pout, perr;
            if(_redirect & ПРедирект.Ввод)
                pin = new Пайп(ДефРазмБуфераСтдвхо);
            if((_redirect & (ПРедирект.Вывод | ПРедирект.ВыводНаОш)) == ПРедирект.Вывод)
                pout = new Пайп(ДефРазмБуфераСтдвых);

            if((_redirect & (ПРедирект.Ошибка | ПРедирект.ОшНаВывод)) == ПРедирект.Ошибка)
                perr = new Пайп(ДефРазмБуфераСтдош);

            // This pipe is used в_ распространить the результат of the вызов в_
            // execv*() из_ the ветвь process в_ the предок process.
            Пайп pexec = new Пайп(8);
            цел статус = 0;

            _pid = fork();
            if (_pid >= 0)
            {
                if (_pid != 0)
                {
                    // Parent process
                    if(pin !is пусто)
                    {
                        _stdin = pin.сток;
                        pin.источник.закрой();
                    }

                    if(pout !is пусто)
                    {
                        _stdout = pout.источник;
                        pout.сток.закрой();
                    }

                    if(perr !is пусто)
                    {
                        _stderr = perr.источник;
                        perr.сток.закрой();
                    }

                    pexec.сток.закрой();
                    scope(exit)
                        pexec.источник.закрой();

                    try
                    {
                        pexec.источник.ввод.читай((cast(байт*) &статус)[0 .. статус.sizeof]);
                    }
                    catch (Исключение e)
                    {
                        // Everything's ОК, the pipe was закрыт after the вызов в_ execv*()
                    }

                    if (статус == 0)
                    {
                        _running = да;
                    }
                    else
                    {
                        // We установи errno в_ the значение that was sent through
                        // the pipe из_ the ветвь process
                        errno = статус;
                        _running = нет;

                        throw new ИсклСозданияПроцесса(_args[0], __FILE__, __LINE__);
                    }
                }
                else
                {
                    // Child process
                    цел rc;
                    сим*[] argptr;
                    сим*[] envptr;

                    // Note that for все the pИПes, we can закрой Всё заканчивается
                    // because dup2 opens a duplicate файл descrИПtor в_ the
                    // same resource.

                    // Замени стдвхо with the "читай" pipe
                    if(pin !is пусто)
                    {
                        dup2(pin.источник.фукз(), STDIN_FILENO);
                        pin.сток().закрой();
                        pin.источник.закрой();
                    }

                    // Замени стдвыв with the "пиши" pipe
                    if(pout !is пусто)
                    {
                        dup2(pout.сток.фукз(), STDOUT_FILENO);
                        pout.источник.закрой();
                        pout.сток.закрой();
                    }

                    // Замени стдош with the "пиши" pipe
                    if(perr !is пусто)
                    {
                        dup2(perr.сток.фукз(), STDERR_FILENO);
                        perr.источник.закрой();
                        perr.сток.закрой();
                    }

                    // Check for redirection из_ стдвыв в_ стдош or vice
                    // versa
                    if(_redirect & ПРедирект.ВыводНаОш)
                    {
                        dup2(STDERR_FILENO, STDOUT_FILENO);
                    }

                    if(_redirect & ПРедирект.ОшНаВывод)
                    {
                        dup2(STDOUT_FILENO, STDERR_FILENO);
                    }

                    // We закрой the unneeded часть of the execv*() notification pipe
                    pexec.источник.закрой();

                    // Набор the "пиши" pipe so that it closes upon a successful
                    // вызов в_ execv*()
                    if (fcntl(cast(цел) pexec.сток.фукз(), F_SETFD, FD_CLOEXEC) == 0)
                    {
                        // Convert the аргументы and the environment variables в_
                        // the форматируй ожидалось by the execv() семейство of functions.
                        argptr = toNullEndedArray(_args);
                        envptr = (_copyEnv ? пусто : toNullEndedArray(_env));

                        // Switch в_ the working дир if it есть been установи.
                        if (_workDir.length > 0)
                        {
                            chdir(вТкст0(_workDir));
                        }

                        // Замени the ветвь fork with a new process. We always use the
                        // system PATH в_ look for executables that don't specify
                        // directories in their names.
                        rc = execvpe(_args[0], argptr, envptr);
                        if (rc == -1)
                        {
                            Кош("Не удалось выполнить ")(_args[0])(": ")(СисОш.последнСооб).нс;

                            try
                            {
                                статус = errno;

                                // Propagate the ветвь process' errno значение в_
                                // the предок process.
                                pexec.сток.вывод.пиши((cast(байт*) &статус)[0 .. статус.sizeof]);
                            }
                            catch (Исключение e)
                            {
                            }
                            exit(errno);
                        }
                    }
                    else
                    {
                        Кош("Не удалось установить тонель уведомления для закрытия по выполнению для ")
                            (_args[0])(": ")(СисОш.последнСооб).нс;
                        exit(errno);
                    }
                }
            }
            else
            {
                throw new ИсклВетвленияПроцесса(_pid, __FILE__, __LINE__);
            }
        }
        else
        {
            assert(нет, "sys.Process: Неподдерживаемая платформа");
        }
        return this;
    }


    /**
     * Unconditionally жди for a process в_ конец and return the резон and
     * статус код why the process ended.
     *
     * Возвращает:
     * The return значение is a Результат struct, which есть two члены:
     * резон and статус. The резон can take the
     * following values:
     *
     * Процесс.Результат.Выход: the ветвь process exited normally;
     *                      статус есть the process' return
     *                      код.
     *
     * Процесс.Результат.Сигнал: the ветвь process was killed by a signal;
     *                        статус есть the signal число
     *                        that killed the process.
     *
     * Процесс.Результат.Стоп: the process was stopped; статус
     *                      есть the signal число that was used в_ stop
     *                      the process.
     *
     * Процесс.Результат.Продолжение: the process had been previously stopped
     *                          and есть сейчас been restarted;
     *                          статус есть the signal число
     *                          that was used в_ continue the process.
     *
     * Процесс.Результат.Ошибка: We could not properly жди on the ветвь
     *                       process; статус есть the
     *                       errno значение if the process was
     *                       running and -1 if not.
     *
     * Remarks:
     * You can only вызов жди() on a running process once. The Сигнал, Стоп
     * and Продолжение reasons will only be returned on POSIX-compatible
     * platforms.
     * Calling жди() will not clean the pИПes as the предок process may still
     * want the remaining вывод. It is however recommended в_ вызов закрой()
     * when no ещё контент is ожидалось, as this will закрой the pИПes.
     */
    public Результат жди()
    {
        version (Windows)
        {
            Результат результат;

            if (_running)
            {
                DWORD rc;
                DWORD exitCode;

                assert(_info !is пусто);

                // We clean up the process related данные and установи the _running
                // flag в_ нет once we're готово waiting for the process в_
                // финиш.
                //
                // IMPORTANT: we don't delete the открой pИПes so that the предок
                //            process can получи whatever the ветвь process left on
                //            these pИПes before dying.
                scope(exit)
                {
                    CloseHandle(_info.hProcess);
                    _running = нет;
                }

                rc = WaitForSingleObject(_info.hProcess, INFINITE);
                if (rc == WAIT_OBJECT_0)
                {
                    GetExitCodeProcess(_info.hProcess, &exitCode);

                    результат.резон = Результат.Выход;
                    результат.статус = cast(typeof(результат.статус)) exitCode;

                    debug (Процесс)
                        Стдвыв.форматнс("Child process '{0}' ({1}) returned with код {2}\n",
                                        _args[0], пид, результат.статус);
                }
                else if (rc == WAIT_FAILED)
                {
                    результат.резон = Результат.Ошибка;
                    результат.статус = cast(крат) GetLastError();

                    debug (Процесс)
                        Стдвыв.форматнс("Child process '{0}' ({1}) неудачно "
                                        "with неизвестное exit статус {2}\n",
                                        _args[0], пид, результат.статус);
                }
            }
            else
            {
                результат.резон = Результат.Ошибка;
                результат.статус = -1;

                debug (Процесс)
                    Стдвыв.форматнс("Child process '{0}' is not running", _args[0]);
            }
            return результат;
        }
        else version (Posix)
        {
            Результат результат;

            if (_running)
            {
                цел rc;

                // We clean up the process related данные and установи the _running
                // flag в_ нет once we're готово waiting for the process в_
                // финиш.
                //
                // IMPORTANT: we don't delete the открой pИПes so that the предок
                //            process can получи whatever the ветвь process left on
                //            these pИПes before dying.
                scope(exit)
                {
                    _running = нет;
                }

                // Wait for ветвь process в_ конец.
                if (waitpопр(_pid, &rc, 0) != -1)
                {
                    if (WIFEXITED(rc))
                    {
                        результат.резон = Результат.Выход;
                        результат.статус = WEXITSTATUS(rc);
                        if (результат.статус != 0)
                        {
                            debug (Процесс)
                                Стдвыв.форматнс("Child process '{0}' ({1}) returned with код {2}\n",
                                                _args[0], _pid, результат.статус);
                        }
                    }
                    else
                    {
                        if (WIFSIGNALED(rc))
                        {
                            результат.резон = Результат.Сигнал;
                            результат.статус = WTERMSIG(rc);

                            debug (Процесс)
                                Стдвыв.форматнс("Child process '{0}' ({1}) was killed prematurely "
                                                "with signal {2}",
                                                _args[0], _pid, результат.статус);
                        }
                        else if (WIFSTOPPED(rc))
                        {
                            результат.резон = Результат.Стоп;
                            результат.статус = WSTOPSIG(rc);

                            debug (Процесс)
                                Стдвыв.форматнс("Child process '{0}' ({1}) was stopped "
                                                "with signal {2}",
                                                _args[0], _pid, результат.статус);
                        }
                        else if (WIFCONTINUED(rc))
                        {
                            результат.резон = Результат.Стоп;
                            результат.статус = WSTOPSIG(rc);

                            debug (Процесс)
                                Стдвыв.форматнс("Child process '{0}' ({1}) was continued "
                                                "with signal {2}",
                                                _args[0], _pid, результат.статус);
                        }
                        else
                        {
                            результат.резон = Результат.Ошибка;
                            результат.статус = rc;

                            debug (Процесс)
                                Стдвыв.форматнс("Child process '{0}' ({1}) неудачно "
                                                "with неизвестное exit статус {2}\n",
                                                _args[0], _pid, результат.статус);
                        }
                    }
                }
                else
                {
                    результат.резон = Результат.Ошибка;
                    результат.статус = errno;

                    debug (Процесс)
                        Стдвыв.форматнс("Could not жди on ветвь process '{0}' ({1}): ({2}) {3}",
                                        _args[0], _pid, результат.статус, СисОш.последнСооб);
                }
            }
            else
            {
                результат.резон = Результат.Ошибка;
                результат.статус = -1;

                debug (Процесс)
                    Стдвыв.форматнс("Child process '{0}' is not running", _args[0]);
            }
            return результат;
        }
        else
        {
            assert(нет, "sys.Process: Unsupported platform");
        }
    }

    /**
     * Kill a running process. This метод will not return until the process
     * есть been killed.
     *
     * Throws:
     * ИсклТушенияПроцесса if the process could not be killed;
     * ИсклОжиданияПроцесса if we could not жди on the process after
     * killing it.
     *
     * Remarks:
     * After calling this метод you will not be able в_ вызов жди() on the
     * process.
     * Killing the process does not clean the attached pИПes as the предок
     * process may still want/need the remaining контент. However, it is
     * recommended в_ вызов закрой() on the process when it is no longer needed
     * as this will clean the pИПes. 
     */
    public проц затуши()
    {
        version (Windows)
        {
            if (_running)
            {
                assert(_info !is пусто);

                if (TerminateProcess(_info.hProcess, cast(UINT) -1))
                {
                    assert(_info !is пусто);

                    // We clean up the process related данные and установи the _running
                    // flag в_ нет once we're готово waiting for the process в_
                    // финиш.
                    //
                    // IMPORTANT: we don't delete the открой pИПes so that the предок
                    //            process can получи whatever the ветвь process left on
                    //            these pИПes before dying.
                    scope(exit)
                    {
                        CloseHandle(_info.hProcess);
                        _running = нет;
                    }

                    // FIXME: We should probably use a таймаут here
                    if (WaitForSingleObject(_info.hProcess, INFINITE) == WAIT_FAILED)
                    {
                        throw new ИсклОжиданияПроцесса(cast(цел) _info.dwProcessId,
                                                       __FILE__, __LINE__);
                    }
                }
                else
                {
                    throw new ИсклТушенияПроцесса(cast(цел) _info.dwProcessId,
                                                   __FILE__, __LINE__);
                }
            }
            else
            {
                debug (Процесс)
                    Стдвыв.выведи("Tried в_ затуши an не_годится process");
            }
        }
        else version (Posix)
        {
            if (_running)
            {
                цел rc;

                assert(_pid > 0);

                if (.затуши(_pid, SIGTERM) != -1)
                {
                    // We clean up the process related данные and установи the _running
                    // flag в_ нет once we're готово waiting for the process в_
                    // финиш.
                    //
                    // IMPORTANT: we don't delete the открой pИПes so that the предок
                    //            process can получи whatever the ветвь process left on
                    //            these pИПes before dying.
                    scope(exit)
                    {
                        _running = нет;
                    }

                    // FIXME: is this loop really needed?
                    for (бцел i = 0; i < 100; i++)
                    {
                        rc = waitpопр(пид, пусто, WNOHANG | WUNTRACED);
                        if (rc == _pid)
                        {
                            break;
                        }
                        else if (rc == -1)
                        {
                            throw new ИсклОжиданияПроцесса(cast(цел) _pid, __FILE__, __LINE__);
                        }
                        usleep(50000);
                    }
                }
                else
                {
                    throw new ИсклТушенияПроцесса(_pid, __FILE__, __LINE__);
                }
            }
            else
            {
                debug (Процесс)
                    Стдвыв.выведи("Tried в_ затуши an не_годится process");
            }
        }
        else
        {
            assert(нет, "sys.Process: Unsupported platform");
        }
    }

    /**
     * разбей a ткст containing the команда строка used в_ invoke a program
     * and return and Массив with the разобрано аргументы. The дво-кавычки (")
     * character can be used в_ specify аргументы with embedded пробелы.
     * e.g. first "сукунда param" third
     */
    protected static ткст[] разделиАрги(ref ткст команда, ткст delims = " \t\r\n")
    in
    {
        assert(!содержит(delims, '"'),
               "The аргумент delimiter ткст cannot contain a дво кавычки ('\"') character");
    }
    body
    {
        enum Состояние
        {
            Start,
            FindDelimiter,
            InsопрeQuotes
        }

        ткст[]    арги = пусто;
        ткст[]    chunks = пусто;
        цел         старт = -1;
        сим        c;
        цел         i;
        Состояние       состояние = Состояние.Start;

        // Append an аргумент в_ the 'арги' Массив using the 'chunks' Массив
        // and the current позиция in the 'команда' ткст as the источник.
        проц appendChunksAsArg()
        {
            бцел argPos;

            if (chunks.length > 0)
            {
                // Create the Массив element corresponding в_ the аргумент by
                // appending the first chunk.
                арги   ~= chunks[0];
                argPos  = арги.length - 1;

                for (бцел chunkPos = 1; chunkPos < chunks.length; ++chunkPos)
                {
                    арги[argPos] ~= chunks[chunkPos];
                }

                if (старт != -1)
                {
                    арги[argPos] ~= команда[старт .. i];
                }
                chunks.length = 0;
            }
            else
            {
                if (старт != -1)
                {
                    арги ~= команда[старт .. i];
                }
            }
            старт = -1;
        }

        for (i = 0; i < команда.length; i++)
        {
            c = команда[i];

            switch (состояние)
            {
                // Start looking for an аргумент.
                case Состояние.Start:
                    if (c == '"')
                    {
                        состояние = Состояние.InsопрeQuotes;
                    }
                    else if (!содержит(delims, c))
                    {
                        старт = i;
                        состояние = Состояние.FindDelimiter;
                    }
                    else
                    {
                        appendChunksAsArg();
                    }
                    break;

                // Find the ending delimiter for an аргумент.
                case Состояние.FindDelimiter:
                    if (c == '"')
                    {
                        // If we найди a кавычки character this means that we've
                        // найдено a quoted section of an аргумент. (e.g.
                        // abc"def"ghi). The quoted section will be appended
                        // в_ the preceding часть of the аргумент. This is also
                        // what Unix shells do (i.e. a"b"c becomes abc).
                        if (старт != -1)
                        {
                            chunks ~= команда[старт .. i];
                            старт = -1;
                        }
                        состояние = Состояние.InsопрeQuotes;
                    }
                    else if (содержит(delims, c))
                    {
                        appendChunksAsArg();
                        состояние = Состояние.Start;
                    }
                    break;

                // Insопрe a quoted аргумент or section of an аргумент.
                case Состояние.InsопрeQuotes:
                    if (старт == -1)
                    {
                        старт = i;
                    }

                    if (c == '"')
                    {
                        chunks ~= команда[старт .. i];
                        старт = -1;
                        состояние = Состояние.Start;
                    }
                    break;

                default:
                    assert(нет, "Неверный состояние in Процесс.разделиАрги");
            }
        }

        // Добавь the последний аргумент (if there is one)
        appendChunksAsArg();

        return арги;
    }

    /**
     * Close and delete any pipe that may have been left открой in a previous
     * execution of a ветвь process.
     */
    protected проц удалиПайпы()
    {
        delete _stdin;
        delete _stdout;
        delete _stderr;
    }

    /**
     * Explicitly закрой any resources held by this process объект. It is recommended
     * в_ always вызов this when you are готово with the process.
     */
    public проц закрой()
    {
        this.удалиПайпы;
    }

    version (Windows)
    {
        /**
         * Convert an associative Массив of ткстs в_ a буфер containing a
         * concatenation of "<имя>=<значение>" ткстs separated by a пусто
         * character and with an добавьitional пусто character at the конец of it.
         * This is the форматируй ожидалось by the CreateProcess() Windows API for
         * the environment variables.
         */
        protected static ткст toNullEndedBuffer(ткст[ткст] ист)
        {
            ткст приёмник;

            foreach (ключ, значение; ист)
            {
                приёмник ~= ключ ~ '=' ~ значение ~ '\0';
            }

            приёмник ~= "\0\0";
            return приёмник;
        }
    }
    else version (Posix)
    {
        /**
         * Convert an Массив of ткстs в_ an Массив of pointers в_ сим with
         * a terminating пусто character (C ткстs). The resulting Массив
         * есть a пусто pointer at the конец. This is the форматируй ожидалось by
         * the execv*() семейство of POSIX functions.
         */
        protected static сим*[] toNullEndedArray(ткст[] ист)
        {
            if (ист !is пусто)
            {
                сим*[] приёмник = new сим*[ист.length + 1];
                цел     i = ист.length;

                // Добавь terminating пусто pointer в_ the Массив
                приёмник[i] = пусто;

                while (--i >= 0)
                {
                    // Добавь a terminating пусто character в_ each ткст
                    приёмник[i] = вТкст0(ист[i]);
                }
                return приёмник;
            }
            else
            {
                return пусто;
            }
        }

        /**
         * Convert an associative Массив of ткстs в_ an Массив of pointers в_
         * сим with a terminating пусто character (C ткстs). The resulting
         * Массив есть a пусто pointer at the конец. This is the форматируй ожидалось by
         * the execv*() семейство of POSIX functions for environment variables.
         */
        protected static сим*[] toNullEndedArray(ткст[ткст] ист)
        {
            сим*[] приёмник;

            foreach (ключ, значение; ист)
            {
                приёмник ~= (ключ ~ '=' ~ значение ~ '\0').ptr;
            }

            приёмник ~= пусто;
            return приёмник;
        }

        /**
         * Execute a process by looking up a файл in the system путь, passing
         * the Массив of аргументы and the the environment variables. This
         * метод is a combination of the execve() and execvp() POSIX system
         * calls.
         */
        protected static цел execvpe(ткст имяф, сим*[] argv, сим*[] envp)
        in
        {
            assert(имяф.length > 0);
        }
        body
        {
            цел rc = -1;
            сим* ткт;

            if (!содержит(имяф, ФайлКонст.СимПутьРазд) &&
                (ткт = getenv("PATH")) !is пусто)
            {
                ткст[] pathList = delimit(ткт[0 .. strlen(ткт)], ":");

                foreach (путь; pathList)
                {
                    if (путь[путь.length - 1] != ФайлКонст.СимПутьРазд)
                    {
                        путь ~= ФайлКонст.СимПутьРазд;
                    }

                    debug (Процесс)
                        Стдвыв.форматнс("Trying execution of '{0}' in дир '{1}'",
                                        имяф, путь);

                    путь ~= имяф;
                    путь ~= '\0';

                    rc = execve(путь.ptr, argv.ptr, (envp.length == 0 ? environ : envp.ptr));
                    // If the process execution неудачно because of an ошибка
                    // другой than ENOENT (No such файл or дир) we
                    // abort the loop.
                    if (rc == -1 && errno != ENOENT)
                    {
                        break;
                    }
                }
            }
            else
            {
                debug (Процесс)
                    Стдвыв.форматнс("Calling execve('{0}', argv[{1}], {2})",
                                    (argv[0])[0 .. strlen(argv[0])],
                                    argv.length, (envp.length > 0 ? "envp" : "пусто"));

                rc = execve(argv[0], argv.ptr, (envp.length == 0 ? environ : envp.ptr));
            }
            return rc;
        }
    }
}


/**
 * Исключение thrown when the process cannot be создан.
 */
class ИсклСозданияПроцесса: ProcessException
{



    public this(ткст команда, ткст файл, бцел строка)
    {
        this(команда, СисОш.последнСооб, файл, строка);
    }

    public this(ткст команда, ткст сообщение, ткст файл, бцел строка)
    {
        super("Не удалось создание процесса для " ~ команда ~ " : " ~ сообщение);
    }
}

/**
 * Исключение thrown when the предок process cannot be forked.
 *
 * This исключение will only be thrown on POSIX-compatible platforms.
 */
class ИсклВетвленияПроцесса: ProcessException
{


    public this(цел пид, ткст файл, бцел строка)
    {
        super(форматируй("Не удалось разветвление процесса ", пид) ~ " : " ~ СисОш.последнСооб);
    }
}

/**
 * Исключение thrown when the process cannot be killed.
 */
class ИсклТушенияПроцесса: ProcessException
{


    public this(цел пид, ткст файл, бцел строка)
    {
        super(форматируй("Не удалось терминировать процесс ", пид) ~ " : " ~ СисОш.последнСооб);
    }
}

/**
 * Исключение thrown when the предок process tries в_ жди on the ветвь
 * process and fails.
 */
class ИсклОжиданияПроцесса: ProcessException
{


    public this(цел пид, ткст файл, бцел строка)
    {
        super(форматируй("Неудача при ожидании процесса  ", пид) ~ " : " ~ СисОш.последнСооб);
    }
}




/**
 *  добавь an цел аргумент в_ a сообщение
*/
private ткст форматируй (ткст сооб, цел значение)
{
    сим[10] врем;

    return сооб ~ Целое.форматируй (врем, значение);
}


debug (UnitTest)
{
    unittest
    {
        ткст сообщение = "hello world";
        version(Windows)
        {
            ткст команда = "cmd.exe /c echo " ~ сообщение;
        }
        else
            ткст команда = "echo " ~ сообщение;


        try
        {
            auto p = new Процесс(команда);

            p.выполни();
            сим[1024] буфер;
            auto nread = p.стдвыв.читай(буфер);
            assert(nread != p.стдвыв.Кф);
            version(Windows)
                assert(буфер[0..nread] == сообщение ~ "\r\n");
            else
                assert(буфер[0..nread] == сообщение ~ "\n");
            nread = p.стдвыв.читай(буфер);
            assert(nread == p.стдвыв.Кф);

            auto результат = p.жди();

            assert(результат.резон == Процесс.Результат.Выход && результат.статус == 0);
        }
        catch (ProcessException e)
        {
            Кош("Выполнение программы невозможно: ")(e.вТкст()).нс();
        }
    }
}

