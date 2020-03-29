/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: January 2006      
        
        author:         Kris

*******************************************************************************/

module io.stream.Patterns;

private import text.Regex;
    
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

        See Разграничители, Строки, Кавычки

*******************************************************************************/

class Образцы : Обходчик!(сим)
{
        private Regex regex;
        private alias сим T;
        
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

        this (T[] образец, ИПотокВвода поток = пусто)
        {
                regex = new Regex (образец, "");
                super (поток);
        }

        /***********************************************************************
                
        ***********************************************************************/

        protected т_мера скан (проц[] данные)
        {
                auto контент = (cast(T*) данные.ptr) [0 .. данные.length / T.sizeof];

                if (regex.тест (контент))
                   {
                   цел старт = regex.registers_[0];
                   цел финиш = regex.registers_[1];
                   установи (контент.ptr, 0, старт);
                   return найдено (финиш-1);        
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
                auto p = new Образцы ("b.*", new Массив("blah"));
        }
}
