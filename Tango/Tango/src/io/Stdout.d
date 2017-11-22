/*******************************************************************************

        copyright:      Copyright (c) 2005 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Nov 2005: Initial release

        author:         Kris

        Стандартные, глобальные форматёры для консольного вывода.
		Если форматированный вывод или трансляция в Юникод не требуется,
		тогда лучше использовать непосредственно модуль io.Console.
		Если же требуется форматирование, но без вывода в консоль,
		то вместо этого лучше применять text.convert.Format.

        Стдвыв & Стдош используются в следующем стиле:
        ---
        Стдвыв ("hello");                       => hello
        Стдвыв (1);                             => 1
        Стдвыв (3.14);                          => 3.14
        Стдвыв ('b');                           => b
        Стдвыв (1, 2, 3);                       => 1, 2, 3         
        Стдвыв ("abc", 1, 2, 3);                => abc, 1, 2, 3        
        Стдвыв ("abc", 1, 2) ("foo");           => abc, 1, 2foo        
        Стдвыв ("abc") ("def") (3.14);          => abcdef3.14

        Стдвыв.форматируй ("abc {}", 1);            => abc 1
        Стдвыв.форматируй ("abc {}:{}", 1, 2);      => abc 1:2
        Стдвыв.форматируй ("abc {1}:{0}", 1, 2);    => abc 2:1
        Стдвыв.форматируй ("abc ", 1);              => abc
        ---

        Note that the последний example does not throw an исключение. There
        are several use-cases where dropping an аргумент is legitimate,
        so we're currently not enforcing any particular trap mechanism.

        Flushing the вывод is achieved through the слей() метод, or
        via an пустой pair of parens: 
        ---
        Стдвыв ("hello world") ();
        Стдвыв ("hello world").слей;

        Стдвыв.форматируй ("hello {}", "world") ();
        Стдвыв.форматируй ("hello {}", "world").слей;
        ---
        
        Special character sequences, such as "\n", are записано directly в_
        the вывод without any translation (though an вывод-фильтр could
        be inserted в_ perform translation as required). Platform-specific 
        newlines are generated instead via the нс() метод, which also 
        flushes the вывод when configured в_ do so:
        ---
        Стдвыв ("hello ") ("world").нс;
        Стдвыв.форматируй ("hello {}", "world").нс;
        Стдвыв.форматнс ("hello {}", "world");
        ---

        The форматируй() метод of Всё Стдош and Стдвыв support the range
        of formatting options provопрed by text.convert.Layout and
        extensions thereof; включая the full I18N extensions where it
        есть been configured in that manner. To enable a French Стдвыв, 
        do the following:
        ---
        import text.locale.Locale;

        Стдвыв.выкладка = new Локаль (Культура.дайКультуру ("fr-FR"));
        ---
        
        Note that Стдвыв is a shared сущность, so every usage of it will
        be affected by the above example. For applications supporting 
        multИПle regions, создай multИПle Локаль instances instead and 
        cache them in an appropriate manner.

        Стдвыв.выкладка can also be used for formatting without outputting
        в_ the console such as in the following example:
        ---
        ткст ткт = Стдвыв.выкладка.преобразуй("{} and {}", 42, "abc");
        //ткт is "42 and abc"
        ---
        This can be useful if you already have Стдвыв imported.

        Note also that the вывод-поток in use is exposed by these
        global instances ~ this can be leveraged, for экземпляр, в_ копируй a
        файл в_ the стандарт вывод:
        ---
        Стдвыв.копируй (new Файл ("myfile"));
        ---

        Note that Стдвыв is *not* intended в_ be нить-safe. Use either
        util.log.Trace or the стандарт logging facilities in order 
        в_ enable atomic console I/O
        
*******************************************************************************/

module io.Stdout;

private import io.Console;
private import io.stream.Format;
private import text.convert.Layout;

/*******************************************************************************

        Construct Стдвыв & Стдош when this module is загружен

*******************************************************************************/

private alias ФормВывод!(сим) Вывод;

public static Вывод Стдвыв,      /// global стандарт вывод
                     Стдош;      /// global ошибка вывод
public alias Стдвыв  стдвыв;      /// alternative
public alias Стдош  стдош;      /// alternative

static this ()
{
        // note that a static-ctor insопрe Выкладка fails 
        // в_ be invoked before this is executed (bug)
        auto выкладка = Выкладка!(сим).экземпляр;

        Стдвыв = new Вывод (выкладка, Квывод.поток);
        Стдош = new Вывод (выкладка, Кош.поток);
        
        Стдвыв.слей = !Квывод.перенаправленый;
        Стдош.слей = !Кош.перенаправленый;
}


/******************************************************************************

******************************************************************************/

debug (Stdout)
{
        проц main() 
        {
        Стдвыв ("hello").нс;               
        Стдвыв (1).нс;                     
        Стдвыв (3.14).нс;                  
        Стдвыв ('b').нс;                   
        Стдвыв ("abc") ("def") (3.14).нс;  
        Стдвыв ("abc", 1, 2, 3).нс;        
        Стдвыв (1, 2, 3).нс;        
        Стдвыв (1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1).нс;

        Стдвыв ("abc {}{}{}", 1, 2, 3).нс; 
        Стдвыв.форматируй ("abc {}{}{}", 1, 2, 3).нс;
        }
}
