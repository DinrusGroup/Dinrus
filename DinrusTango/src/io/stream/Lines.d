/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: January 2006      
        
        author:         Kris

*******************************************************************************/

module io.stream.Lines;

private import io.stream.Iterator;

/*******************************************************************************

        Iterate across a установи of текст образцы.

        Each образец is exposed в_ the клиент as a срез of the original
        контент, where the срез is transient. If you need в_ retain the
        exposed контент, then you should .dup it appropriately. 

        The контент exposed via an iterator is supposed в_ be entirely
        читай-only. все current iterators abопрe by this правило, but it is
        possible a пользователь could mutate the контент through a получи() срез.
        To enforce the desired читай-only aspect, the код would have в_ 
        introduce redundant copying or the compiler would have в_ support 
        читай-only массивы.

        See Разграничители, Образцы, Кавычки

*******************************************************************************/

class Строки(T) : Обходчик!(T)
{
        /***********************************************************************
        
                Конструирует uninitialized iterator. For example:
                ---
                auto lines = new Строки!(сим);

                проц somefunc (ИПотокВвода поток)
                {
                        foreach (строка; lines.установи(поток))
                                 Квывод (строка).нс;
                }
                ---

                Construct a Потокing iterator upon a поток:
                ---
                проц somefunc (ИПотокВвода поток)
                {
                        foreach (строка; new Строки!(сим) (поток))
                                 Квывод (строка).нс;
                }
                ---
                
                Construct a Потокing iterator upon a провод:
                ---
                foreach (строка; new Строки!(сим) (new Файл ("myfile")))
                         Квывод (строка).нс;
                ---

        ***********************************************************************/

        this (ИПотокВвода поток = пусто)
        {
                super (поток);
        }

        /***********************************************************************

                Чтен a строка of текст, and return нет when there's no
                further контент available.

        ***********************************************************************/

        final бул читайнс (ref T[] контент)
        {
                контент = super.следщ;
                return контент.ptr !is пусто;
        }

        /***********************************************************************
        
                Scanner implementation for this iterator. Find a '\n',
                and съешь any immediately preceeding '\r'
                
        ***********************************************************************/

        protected т_мера скан (проц[] данные)
        {
                auto контент = (cast(T*) данные.ptr) [0 .. данные.length / T.sizeof];

                foreach (цел i, T c; контент)
                         if (c is '\n')
                            {
                            цел срез = i;
                            if (i && контент[i-1] is '\r')
                                --срез;
                            установи (контент.ptr, 0, срез, i);
                            return найдено (i);
                            }

                return неНайдено;
        }
}



/*******************************************************************************

*******************************************************************************/

debug(UnitTest)
{
        private import io.device.Array;

        unittest 
        {
                auto p = new Строки!(сим) (new Массив("blah"));
        }
}


/*******************************************************************************

*******************************************************************************/

debug (Строки)
{
        import io.Console;
        import io.device.Array;

        проц main()
        {
                auto lines = new Строки!(сим)(new Массив("one\ntwo\r\nthree"));
                foreach (i, строка, разделитель; lines)
                         Квывод (строка) (разделитель);
        }
}
