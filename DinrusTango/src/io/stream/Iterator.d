/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: December 2005

        author:         Kris

*******************************************************************************/

module io.stream.Iterator;

private import io.stream.Buffered;

protected import io.device.Conduit : ФильтрВвода, БуферВвода, ИПотокВвода;

/*******************************************************************************

        The основа class for a установи of поток iterators. These operate
        upon a buffered ввод поток, and are designed в_ deal with
        partial контент. That is, поток iterators go в_ work the
        moment any данные becomes available in the буфер. Contrast
        this behaviour with the text.Util iterators, which
        operate upon the протяженность of an Массив.

        There are two типы of iterators supported; исключительно and
        включительно. The former are the ещё common kind, where a сема
        is delimited by elements that are consопрered foreign. Examples
        include пространство, comma, and конец-of-строка delineation. Inclusive
        семы are just the opposite: they look for образцы in the
        текст that should be часть of the сема itself - everything else
        is consопрered foreign. Currently io.Поток включает the
        исключительно variety only.

        Each образец is exposed в_ the клиент as a срез of the original
        контент, where the срез is transient. If you need в_ retain the
        exposed контент, then you should .dup it appropriately. 

        The контент provопрed в_ these iterators is intended в_ be fully
        читай-only. все current tokenizers abопрe by this правило, but it is
        possible a пользователь could mutate the контент through a сема срез.
        To enforce the desired читай-only aspect, the код would have в_
        introduce redundant copying or the compiler would have в_ support
        читай-only массивы (сейчас in D2).

        See Разграничители, Строки, Образцы, Кавычки

*******************************************************************************/

class Обходчик(T) : ФильтрВвода 
{
        private БуферВвода     источник;
        protected T[]           срез,
                                разделитель;

        /***********************************************************************

                The образец scanner, implemented via subclasses

        ***********************************************************************/

        abstract protected т_мера скан (проц[] данные);

        /***********************************************************************

                Instantiate with a буфер

        ***********************************************************************/

        this (ИПотокВвода поток = пусто)
        {       
                super (поток);
                if (поток)
                    установи (поток);
        }

        /***********************************************************************

                Набор the provопрed поток as the scanning источник

        ***********************************************************************/

        Обходчик установи (ИПотокВвода поток)
        {
                assert (поток);
                источник = Бввод.создай (поток);
                super.источник = источник;
                return this;
        }

        /***********************************************************************

                Return the current сема as a срез of the контент

        ***********************************************************************/

        final T[] получи ()
        {
                return срез;
        }

        /**********************************************************************

                Iterate over the установи of семы. This should really
                provопрe читай-only access в_ the семы, but D does
                not support that at this время

        **********************************************************************/

        цел opApply (цел delegate(ref T[]) дг)
        {
                бул ещё;
                цел  результат;

                do {
                   ещё = используй;
                   результат = дг (срез);
                   } while (ещё && !результат);
                return результат;
        }

        /**********************************************************************

                Iterate over a установи of семы, exposing a сема счёт 
                starting at zero

        **********************************************************************/

        цел opApply (цел delegate(ref цел, ref T[]) дг)
        {
                бул ещё;
                цел  результат,
                     семы;

                do {
                   ещё = используй;
                   результат = дг (семы, срез);
                   ++семы;
                   } while (ещё && !результат);
                return результат;
        }

        /**********************************************************************

                Iterate over a установи of семы and delimiters, exposing a 
                сема счёт starting at zero

        **********************************************************************/

        цел opApply (цел delegate(ref цел, ref T[], ref T[]) дг)
        {
                бул ещё;
                цел  результат,
                     семы;

                do {
                   разделитель = пусто;
                   ещё = используй;
                   результат = дг (семы, срез, разделитель);
                   ++семы;
                   } while (ещё && !результат);
                return результат;
        }

        /***********************************************************************

                Locate the следщ сема. Returns the сема if найдено, пусто
                otherwise. Пусто indicates an конец of поток condition. To
                смети a провод for lines using метод следщ():
                ---
                auto lines = new Строки!(сим) (new Файл("myfile"));
                while (lines.следщ)
                       Квывод (lines.получи).нс;
                ---

                Alternatively, we can extract one строка из_ a провод:
                ---
                auto строка = (new Строки!(сим) (new Файл("myfile"))).следщ;
                ---

                The difference between следщ() and foreach() is that the
                latter processes все семы in one go, whereas the former
                processes in a piecemeal fashion. To wit:
                ---
                foreach (строка; new Строки!(сим) (new Файл("myfile")))
                         Квывод(строка).нс;
                ---
                
        ***********************************************************************/

        final T[] следщ ()
        {
                if (используй() || срез.length)
                    return срез;
                return пусто;
        }

        /***********************************************************************

                Набор the контент of the current срез в_ the provопрed 
                старт and конец points

        ***********************************************************************/

        protected final т_мера установи (T* контент, т_мера старт, т_мера конец)
        {
                срез = контент [старт .. конец];
                return конец;
        }

        /***********************************************************************

                Набор the контент of the current срез в_ the provопрed 
                старт and конец points, and delimiter в_ the segment
                between конец & следщ (включительно)

        ***********************************************************************/

        protected final т_мера установи (T* контент, т_мера старт, т_мера конец, т_мера следщ)
        {
                срез = контент [старт .. конец];
                разделитель = контент [конец .. следщ+1];
                return конец;
        }

        /***********************************************************************

                Called when a scanner fails в_ найди a совпадают образец.
                This may cause ещё контент в_ be загружен, and a rescan
                initiated

        ***********************************************************************/

        protected final т_мера неНайдено ()
        {
                return Кф;
        }

        /***********************************************************************

                Invoked when a scanner matches a образец. The provопрed
                значение should be the индекс of the последний element of the
                совпадают образец, which is преобразованый back в_ a проц[]
                индекс.

        ***********************************************************************/

        protected final т_мера найдено (т_мера i)
        {
                return (i + 1) * T.sizeof;
        }

        /***********************************************************************

                See if установи of characters holds a particular экземпляр

        ***********************************************************************/

        protected final бул есть (T[] установи, T match)
        {
                foreach (T c; установи)
                         if (match is c)
                             return да;
                return нет;
        }

        /***********************************************************************

                Consume the следщ сема and place it in 'срез'. Returns 
                да when there are potentially ещё семы

        ***********************************************************************/

        private бул используй ()
        {
                if (источник.следщ (&скан))
                    return да;

                // используй trailing сема
                источник.читатель ((проц[] масс) 
                              { 
                              срез = (cast(T*) масс.ptr) [0 .. масс.length/T.sizeof];
                              return cast(т_мера)масс.length; 
                              });
                return нет;
        }
}


