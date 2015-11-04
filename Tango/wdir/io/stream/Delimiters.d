/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: January 2006

        author:         Kris

*******************************************************************************/

module io.stream.Delimiters;

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

        See Строки, Образцы, Кавычки

*******************************************************************************/

class Разграничители(T) : Обходчик!(T)
{
        private T[] разделитель;

        /***********************************************************************
        
                Construct an uninitialized iterator. For example:
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

        this (T[] разделитель, ИПотокВвода поток = пусто)
        {
                this.разделитель = разделитель;
                super (поток);
        }

        /***********************************************************************

        ***********************************************************************/

        protected т_мера скан (проц[] данные)
        {
                auto контент = (cast(T*) данные.ptr) [0 .. данные.length / T.sizeof];

                if (разделитель.length is 1)
                   {
                   foreach (цел i, T c; контент)
                            if (c is разделитель[0])
                                return найдено (установи (контент.ptr, 0, i, i));
                   }
                else
                   foreach (цел i, T c; контент)
                            if (есть (разделитель, c))
                                return найдено (установи (контент.ptr, 0, i, i));

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
                auto p = new Разграничители!(сим) (", ", new Массив("blah"));
        }
}
