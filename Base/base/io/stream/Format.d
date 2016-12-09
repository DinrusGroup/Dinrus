/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: Oct 2007

        author:         Kris

*******************************************************************************/

module io.stream.Format;

private import io.device.Conduit;

private import text.convert.Layout;

/*******************************************************************************

        A brопрge between a Выкладка экземпляр and a поток. This is used for
        the Стдвыв & Стдош globals, but can be used for general purpose
        буфер-formatting as desired. The Template тип 'T' dictates the
        текст arrangement внутри the мишень буфер ~ one of сим, шим or
        дим (utf8, utf16, or utf32). 
        
        ФормВывод exposes this стиль of usage:
        ---
        auto выведи = new ФормВывод!(сим) (...);

        выведи ("hello");                        => hello
        выведи (1);                              => 1
        выведи (3.14);                           => 3.14
        выведи ('b');                            => b
        выведи (1, 2, 3);                        => 1, 2, 3         
        выведи ("abc", 1, 2, 3);                 => abc, 1, 2, 3        
        выведи ("abc", 1, 2) ("foo");            => abc, 1, 2foo        
        выведи ("abc") ("def") (3.14);           => abcdef3.14

        выведи.форматируй ("abc {}", 1);             => abc 1
        выведи.форматируй ("abc {}:{}", 1, 2);       => abc 1:2
        выведи.форматируй ("abc {1}:{0}", 1, 2);     => abc 2:1
        выведи.форматируй ("abc ", 1);               => abc
        ---

        Note that the последний example does not throw an исключение. There
        are several use-cases where dropping an аргумент is legitimate,
        so we're currently not enforcing any particular trap mechanism.

        Flushing the вывод is achieved through the слей() метод, or
        via an пустой pair of parens: 
        ---
        выведи ("hello world") ();
        выведи ("hello world").слей;

        выведи.форматируй ("hello {}", "world") ();
        выведи.форматируй ("hello {}", "world").слей;
        ---
        
        Special character sequences, such as "\n", are записано directly в_
        the вывод without any translation (though an вывод-фильтр could
        be inserted в_ perform translation as требуется). Platform-specific 
        newlines are generated instead via the нс() метод, which also 
        flushes the вывод when configured в_ do so:
        ---
        выведи ("hello ") ("world").нс;
        выведи.форматируй ("hello {}", "world").нс;
        выведи.форматнс ("hello {}", "world");
        ---

        The форматируй() метод supports the range of formatting опции 
        exposed by text.convert.Layout and extensions thereof; 
        включая the full I18N extensions where configured in that 
        manner. To создай a French экземпляр of ФормВывод:
        ---
        import text.locale.Locale;

        auto locale = new Локаль (Культура.дайКультуру ("fr-FR"));
        auto выведи = new ФормВывод!(сим) (locale, ...);
        ---

        Note that ФормВывод is *not* intended в_ be нить-safe
        
*******************************************************************************/
export extern(D):
class ФормВывод(T) : ФильтрВывода
{     

export:  
        public  alias ФильтрВывода.слей слей;

        private T[]             кс;
        private Выкладка!(T)      преобразуй;
        private бул            слитьСтроки;

        public alias выведи      opCall;         /// opCall -> выведи
        public alias нс    nl;             /// nl -> нс

        version (Win32)
                 private const T[] Кс = "\r\n";
             else
                private const T[] Кс = "\n";

        /**********************************************************************

                Construct a ФормВывод экземпляр, tying the provопрed поток
                в_ a выкладка форматёр

        **********************************************************************/

        this (ИПотокВывода вывод, T[] кс = Кс)
        {
                this (Выкладка!(T).экземпляр, вывод, кс);
        }

        /**********************************************************************

                Construct a ФормВывод экземпляр, tying the provопрed поток
                в_ a выкладка форматёр

        **********************************************************************/

        this (Выкладка!(T) преобразуй, ИПотокВывода вывод, T[] кс = Кс)
        {
                assert (преобразуй);
                assert (вывод);

                this.преобразуй = преобразуй;
                this.кс = кс;
                super (вывод);
        }

        /**********************************************************************

                Выкладка using the provопрed formatting specification

        **********************************************************************/

        final ФормВывод форматируй (T[] фмт, ...)
        {
                преобразуй (&излей, _arguments, _argptr, фмт);
                return this;
        }

        /**********************************************************************

                Выкладка using the provопрed formatting specification

        **********************************************************************/

        final ФормВывод форматнс (T[] фмт, ...)
        {
                преобразуй (&излей, _arguments, _argptr, фмт);
                return нс;
        }

        /**********************************************************************

                Unformatted выкладка, with commas inserted between арги. 
                Currently supports a maximum of 24 аргументы

        **********************************************************************/

        final ФормВывод выведи (...)
        {
                static  T[] срез =  "{}, {}, {}, {}, {}, {}, {}, {}, "
                                     "{}, {}, {}, {}, {}, {}, {}, {}, "
                                     "{}, {}, {}, {}, {}, {}, {}, {}, ";

                assert (_arguments.length <= срез.length/4, "ФормВывод :: слишком много аргументов");

                if (_arguments.length is 0)
                    сток.слей;
                else
                   преобразуй (&излей, _arguments, _argptr, срез[0 .. _arguments.length * 4 - 2]);
                         
                return this;
        }

        /***********************************************************************

                Вывод a нс and optionally слей

        ***********************************************************************/

        final ФормВывод нс ()
        {
                сток.пиши (кс);
                if (слитьСтроки)
                    сток.слей;
                return this;
        }

        /**********************************************************************

                Control implicit flushing of нс(), where да enables
                flushing. An явный слей() will always слей the вывод.

        **********************************************************************/

        final ФормВывод слей (бул да)
        {
                слитьСтроки = да;
                return this;
        }

        /**********************************************************************

                Return the associated вывод поток

        **********************************************************************/

        final ИПотокВывода поток ()
        {
                return сток;
        }

        /**********************************************************************

                Набор the associated вывод поток

        **********************************************************************/

        final ФормВывод поток (ИПотокВывода вывод)
        {
                сток = вывод;
                return this;
        }

        /**********************************************************************

                Return the associated Выкладка

        **********************************************************************/

        final Выкладка!(T) выкладка ()
        {
                return преобразуй;
        }

        /**********************************************************************

                Набор the associated Выкладка

        **********************************************************************/

        final ФормВывод выкладка (Выкладка!(T) выкладка)
        {
                преобразуй = выкладка;
                return this;
        }

        /**********************************************************************

                Сток for passing в_ the форматёр

        **********************************************************************/

        private final бцел излей (T[] s)
        {
                auto счёт = сток.пиши (s);
                if (счёт is Кф)
                    провод.ошибка ("ФормВывод :: неожиданный Кф");
                return счёт;
        }
}


/*******************************************************************************
        
*******************************************************************************/
        
debug (Формат)
{
        import io.device.Array;

        проц main()
        {
                auto выведи = new ФормВывод!(сим) (new Массив(1024, 1024));

                for (цел i=0;i < 1000; i++)
                     выведи(i).нс;
        }
}
