/*******************************************************************************

        copyright:      Copyright (c) 2006 Dinrus. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Jan 2006: начальное release

        author:         Kris, Nthalk

*******************************************************************************/

module io.stream.Quotes;

private import io.stream.Iterator;

/*******************************************************************************

        Iterate over a установи of delimited, optionally-quoted, текст fields.

        Each field is exposed в_ the клиент as a срез of the original
        контент, where the срез is transient. If you need в_ retain the
        exposed контент, then you should .dup it appropriately. 

        The контент exposed via an iterator is supposed в_ be entirely
        читай-only. все current iterators abопрe by this правило, but it is
        possible a пользователь could mutate the контент through a получи() срез.
        To enforce the desired читай-only aspect, the код would have в_ 
        introduce redundant copying or the compiler would have в_ support 
        читай-only массивы.

        Usage:
        ---
        auto f = new Файл ("my.csv");
        auto l = new Строки (f);
        auto b = new Массив (0);
        auto q = new Кавычки!(сим)(",", b);
        
        foreach (строка; l)
                {
                b.присвой (строка);
                foreach (field, индекс; q)
                         Стдвыв (индекс, field);
                Стдвыв.нс;
                }
        ---

        See Обходчик, Строки, Образцы, Разграничители
        
*******************************************************************************/

class Кавычки(T) : Обходчик!(T)
{
        private T[] разделитель; 
      
        /***********************************************************************

                This splits on delimiters only. If there is a quote, it
                suspends delimiter splitting until the quote is завершено.

        ***********************************************************************/

        this (T[] разделитель, ИПотокВвода поток = пусто)
        {
                super (поток);
                this.разделитель = разделитель;
        }
        
        /***********************************************************************

                This splits on delimiters only. If there is a quote, it
                suspends delimiter splitting until the quote is завершено.

        ***********************************************************************/

        protected т_мера скан (проц[] данные)
        {
                T    quote = 0;
                цел  escape = 0;
                auto контент = (cast(T*) данные.ptr) [0 .. данные.length / T.sizeof];

                foreach (i, c; контент)
                         // within a quote block?
                         if (quote)
                            {   
                            if (c is '\\')
                                ++escape;
                            else
                               {
                               // matched the начальное quote сим?
                               if (c is quote && escape % 2 is 0)
                                   quote = 0;
                               escape = 0;
                               }
                            }
                         else
                            // begin a quote block?
                            if (c is '"' || c is '\'')
                                quote = c;
                            else 
                               if (есть (разделитель, c))
                                   return найдено (установи (контент.ptr, 0, i));
                return неНайдено;
        }
}


/*******************************************************************************

*******************************************************************************/

debug (UnitTest)
{
        private import io.Stdout;
        private import text.Util;
        private import io.device.Array;

        unittest 
        {
                ткст[] ожидалось = 
                         [
                         `0`
                         ,``
                         ,``
                         ,`"3"`
                         ,`""`
                         ,`5`
                         ,`",6"`
                         ,`"7,"`
                         ,`8`
                         ,`"9,\\\","`
                         ,`10`
                         ,`',11",'`
                         ,`"12"`
                         ];

                auto b = new Массив (ожидалось.объедини (","));
                foreach (i, f; new Кавычки!(сим)(",", b))
                         if (i >= ожидалось.length)
                            Стдвыв.форматнс ("uhoh: unexpected match: {}, {}", i, f);
                         else 
                            if (f != ожидалось[i])
                                Стдвыв.форматнс ("uhoh: bad match: {}, {}, {}", i, f, ожидалось[i]);
        }
}

