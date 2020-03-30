/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/console.d, _console.d)
 * Documentation:  https://dlang.org/phobos/dmd_console.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/console.d
 */

/********************************************
 * Контролирует различные атрибуты текстового режима, такие как цвет, при записи текста
 * в консоль.
 */

module util.console;

import cidrus;
extern (C) цел isatty(цел);


enum Цвет : цел
{
    Чёрный         = 0,
    Красный           = 1,
    Зелёный         = 2,
    Синий          = 4,
    Жёлтый        = Красный | Зелёный,
    Магента       = Красный | Синий,
    Цыан          = Зелёный | Синий,
    СветлоСерый     = Красный | Зелёный | Синий,
    Яркий        = 8,
    ТёмноСерый      = Яркий | Чёрный,
    ЯркоКрасный     = Яркий | Красный,
    ЯркоЗелёный   = Яркий | Зелёный,
    ЯркоСиний    = Яркий | Синий,
    ЯркоЖёлтый  = Яркий | Жёлтый,
    ЯркоМагента = Яркий | Магента,
    ЯркоЦыан    = Яркий | Цыан,
    Белый         = Яркий | СветлоСерый,
}

struct Console
{
  

    version (Windows)
    {
        import win32.winbase;
        import win32.wincon;
        import win32.windef;

      private:
        ИНФОКОНСЭКРБУФ sbi;
        HANDLE handle;
        FILE* _fp;

      public:

         FILE* fp() { return _fp; }

        /**
        * Пытается определить, был ли DMD вызван из терминала.
        * Возвращает: `да`, если обнаружен терминал, `нет` в противном случае.
         */
        static бул detectTerminal()
        {
            auto h = ДайСтдДескр(STD_OUTPUT_HANDLE);
            ИНФОКОНСЭКРБУФ sbi;
            if (GetConsoleScreenBufferInfo(h, &sbi) == 0) // получить начальное состояние консоли
                return нет; // терминал не обнаружен

            version (CRuntime_DigitalMars)
            {
                return isatty(stdout._file) != 0;
            }
            else version (CRuntime_Microsoft)
            {
                return isatty(fileno(stdout)) != 0;
            }
            else
            {
                static assert(0, "Неподдерживаемый рантайм Windows.");
            }
        }

        /*********************************
         * Create an instance of Console connected to stream fp.
         * Params:
         *      fp = io stream
         * Returns:
         *      pointer to created Console
         *      null if failed
         */
        static Console* create(FILE* fp)
        {
            /* Determine if stream fp is a console
             */
            version (CRuntime_DigitalMars)
            {
                if (!isatty(fp._file))
                    return null;
            }
            else version (CRuntime_Microsoft)
            {
                if (!isatty(fileno(fp)))
                    return null;
            }
            else
            {
                return null;
            }

            DWORD nStdHandle;
            if (fp == stdout)
                nStdHandle = STD_OUTPUT_HANDLE;
            else if (fp == stderr)
                nStdHandle = STD_ERROR_HANDLE;
            else
                return null;

            auto h = ДайСтдДескр(nStdHandle);
            ИНФОКОНСЭКРБУФ sbi;
            if (GetConsoleScreenBufferInfo(h, &sbi) == 0) // get initial state of console
                return null;

            auto c = new Console();
            c._fp = fp;
            c.handle = h;
            c.sbi = sbi;
            return c;
        }

        /*******************
         * Turn on/off intensity.
         * Params:
         *      Яркий = turn it on
         */
        проц setColorBright(бул Яркий)
        {
            SetConsoleTextAttribute(handle, sbi.wAttributes | (Яркий ? FOREGROUND_INTENSITY : 0));
        }

        /***************************
         * Set color and intensity.
         * Params:
         *      color = the color
         */
        проц setColor(Цвет color)
        {
            const FOREGROUND_WHITE = FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE;
            WORD attr = sbi.wAttributes;
            attr = (attr & ~(FOREGROUND_WHITE | FOREGROUND_INTENSITY)) |
                   ((color & Цвет.Красный)    ? FOREGROUND_RED   : 0) |
                   ((color & Цвет.Зелёный)  ? FOREGROUND_GREEN : 0) |
                   ((color & Цвет.Синий)   ? FOREGROUND_BLUE  : 0) |
                   ((color & Цвет.Яркий) ? FOREGROUND_INTENSITY : 0);
            SetConsoleTextAttribute(handle, attr);
        }

        /******************
         * Reset console attributes to what they were
         * when create() was called.
         */
        проц resetColor()
        {
            SetConsoleTextAttribute(handle, sbi.wAttributes);
        }
    }
    else version (Posix)
    {
        /* The ANSI ýñêàïèðóé codes are used.
         * https://en.wikipedia.org/wiki/ANSI_escape_code
         * Foreground colors: 30..37
         * Background colors: 40..47
         * Attributes:
         *  0: reset all attributes
         *  1: high intensity
         *  2: low intensity
         *  3: italic
         *  4: single line underscore
         *  5: slow blink
         *  6: fast blink
         *  7: reverse video
         *  8: hidden
         */

        import core.sys.posix.unistd;
        import core.stdc.stdlib : getenv;
        import core.stdc.ткст : strcmp;
      private:
        FILE* _fp;

      public:

         FILE* fp() { return _fp; }
        /**
        * Tries to detect whether DMD has been invoked from a terminal.
        * Returns: `да` if a terminal has been detect, `нет` otherwise
         */

        static бул detectTerminal()
        {
            
            ткст0 term = getenv("TERM");            
            return isatty(STDERR_FILENO) && term && term[0] && strcmp(term, "dumb") != 0;
        }

        static Console* create(FILE* fp)
        {
            auto c = new Console();
            c._fp = fp;
            return c;
        }

        проц setColorBright(бул Яркий)
        {
            fprintf(_fp, "\033[%dm", Яркий);
        }

        проц setColor(Цвет color)
        {
            fprintf(_fp, "\033[%d;%dm", color & Цвет.Яркий ? 1 : 0, 30 + (color & ~Цвет.Яркий));
        }

        проц resetColor()
        {
            fputs("\033[m", _fp);
        }
    }
    else
    {
         FILE* fp() { assert(0); }

        static Console* create(FILE* fp)
        {
            return null;
        }

        проц setColorBright(бул Яркий)
        {
            assert(0);
        }

        проц setColor(Цвет color)
        {
            assert(0);
        }

        проц resetColor()
        {
            assert(0);
        }
    }

}
