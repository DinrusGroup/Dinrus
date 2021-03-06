﻿/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Apr 2008: Initial release
                        Jan 2009: добавьed СМЧанк разместитель

        authors:        Kris, schveiguy

        Since:          0.99.7

*******************************************************************************/

module util.container.Container;

private import cidrus;


/*******************************************************************************

        Utility functions и constants

*******************************************************************************/

struct Контейнер
{
    /***********************************************************************

           default начальное число of корзины of a non-пустой hashmap

    ***********************************************************************/

    static т_мера дефНачКорзины = 31;

    /***********************************************************************

            default загрузи factor for a non-пустой hashmap. The хэш
            таблица is resized when the proportion of элементы per
            корзины exceeds this предел

    ***********************************************************************/

    static плав дефФакторЗагрузки = 0.75f;

    /***********************************************************************

            генерный значение рипер, which does nothing

    ***********************************************************************/

    static проц извлеки(V) (V v) {}

    /***********************************************************************

            генерный ключ/значение рипер, which does nothing

    ***********************************************************************/

    static проц извлеки(K, V) (K k, V v) {}

    /***********************************************************************

            генерный хэш function, using the default hashing. Thanks
            в_ 'mwarning' for the optimization suggestion

    ***********************************************************************/

    static т_мера хэш(K) (K k, т_мера length)
    {
        static if (is(K : цел)   || is(K : бцел)   ||
                   is(K : дол)  || is(K : бдол)  ||
                   is(K : крат) || is(K : бкрат) ||
                   is(K : байт)  || is(K : ббайт)  ||
                   is(K : сим)  || is(K : шим)  || is (K : дим))
            return cast(т_мера) (k % length);
        else
            return (typeid(K).дайХэш(&k) & 0x7FFFFFFF) % length;
    }


    /***********************************************************************

            Разместитель чанков СМ

            Может сохранячть около 30% памяти для мелких элементов (проверялось
    		с целочисленными элементами и чанком размером 1000), и как минимум
            дважды быстрее при добавке элементов в сравнении с генерным
            аллокатором (примерно в 50x быстрее с LinkedList)

            Безопасно оперирует с управляемыми сущностями СМ

    ***********************************************************************/

    struct ЧанкСМ(T)
    {
        static assert (T.sizeof >= (T*).sizeof, "ЧанкСМ аллокатор может использоваться только для данных размером не менее " ~ ((T*).sizeof).stringof[0..$-1] ~ " байт!");

        private struct Кэш
        {
            Кэш* следщ;
        }

        private Кэш*  кэш;
        private T[][]   списки;
        private т_мера  чанки = 256;

        /***************************************************************

                размести a T-sized память чанк

        ***************************************************************/

        T* размести ()
        {
            if (кэш is пусто)
                новый_список;
            auto p = кэш;
            кэш = p.следщ;
            return cast(T*) p;
        }

        /***************************************************************

                размести an Массив of T* sized память чанки

        ***************************************************************/

        T*[] размести (т_мера счёт)
        {
            auto p = (cast(T**) кразмести(счёт, (T*).sizeof)) [0 .. счёт];
            смДобавьПространство (cast(ук) p, счёт * (T*).sizeof);
            return p;
        }

        /***************************************************************

                Invoked when a specific T*[] is discarded

        ***************************************************************/

        проц собери (T*[] t)
        {
            if (t.ptr)
            {
                смУдалиПространство (t.ptr);
                освободи (t.ptr);
            }
        }

        /***************************************************************

                Invoked when a specific T is discarded

        ***************************************************************/

        проц собери (T* p)
        {
            assert (p);
            auto d = cast(Кэш*) p;
            //*p = T.init;
            d.следщ = кэш;
            кэш = d;
        }

        /***************************************************************

                Invoked when очисть/сбрось is called on the хост.
                This is a shortcut в_ очисть everything allocated.

                Should return да if supported, or нет otherwise.
                Нет return will cause a series of discrete собери
                calls

        ***************************************************************/

        бул собери (бул все = да)
        {
            if (все)
            {
                foreach (ref список; списки)
                {
                    смУдалиПространство (список.ptr);
                    освободи (список.ptr);
                    список = пусто;
                }
                кэш = пусто;
                списки = пусто;
                return да;
            }
            return нет;
        }

        /***************************************************************

                установи the чанк размер и prepopulate with узелs

        ***************************************************************/

        проц конфиг (т_мера чанки, цел размести=0)
        {
            this.чанки = чанки;
            if (размести)
                for (цел i=размести/чанки+1; i--;)
                    новый_список;
        }

        /***************************************************************

                список manager

        ***************************************************************/

        private проц новый_список ()
        {
            списки.length = списки.length + 1;
            auto p = (cast(T*) кразмести (чанки, T.sizeof)) [0 .. чанки];
            списки[$-1] = p;
            смДобавьПространство (p.ptr, T.sizeof * чанки);
            auto голова = кэш;
            foreach (ref узел; p)
            {
                auto d = cast(Кэш*) &узел;
                d.следщ = голова;
                голова = d;
            }
            кэш = голова;
        }
    }


    /***********************************************************************

            Чанк разместитель (non СМ)

            Can save approximately 30% память for small элементы (tested
            with целое элементы и a чанк размер of 1000), и is at
            least twice as fast at добавим элементы when compared в_ the
            default разместитель (approximately 50x faster with LinkedList)

            Note that, due в_ СМ behaviour, you should not конфигурируй
            a custom разместитель for containers holding anything managed
            by the СМ. For example, you cannot use a MallocAllocator
            в_ manage a container of classes or strings where those
            were allocated by the СМ. Once something is owned by a СМ
            then it's lifetime must be managed by СМ-managed entities
            (otherwise the СМ may think there are no live references
            и prematurely собери container contents).

            You can explicity manage the collection of ключи и значения
            yourself by provопрing a рипер delegate. For example, if
            you use a MallocAllocator в_ manage ключ/значение pairs which
            are themselves allocated via malloc, then you should also
            provопрe a рипер delegate в_ собери those as требуется.

            The primary benefit of this разместитель is в_ avoопр the СМ
            scanning the дата-structures involved. Use ЧанкСМ where
            that опция is unwarranted, or if you have СМ-managed данные
            instead

    ***********************************************************************/

    struct Чанк(T)
    {
        static assert (T.sizeof >= (T*).sizeof, "Чанк аллокатор может использоваться только для данных размером не менее " ~ ((T*).sizeof).stringof[0..$-1] ~ " байт!");

        private struct Кэш
        {
            Кэш* следщ;
        }

        private Кэш*  кэш;
        private T[][]   списки;
        private т_мера  чанки = 256;

        /***************************************************************

                размести a T-sized память чанк

        ***************************************************************/

        T* размести ()
        {
            if (кэш is пусто)
                новый_список;
            auto p = кэш;
            кэш = p.следщ;
            return cast(T*) p;
        }

        /***************************************************************

                размести an Массив of T* sized память чанки

        ***************************************************************/

        T*[] размести (т_мера счёт)
        {
            return (cast(T**) кразмести(счёт, (T*).sizeof)) [0 .. счёт];
        }

        /***************************************************************

                Invoked when a specific T*[] is discarded

        ***************************************************************/

        проц собери (T*[] t)
        {
            if (t.ptr)
                освободи (t.ptr);
        }

        /***************************************************************

                Invoked when a specific T is discarded

        ***************************************************************/

        проц собери (T* p)
        {
            assert (p);
            auto d = cast(Кэш*) p;
            d.следщ = кэш;
            кэш = d;
        }

        /***************************************************************

                Invoked when очисть/сбрось is called on the хост.
                This is a shortcut в_ очисть everything allocated.

                Should return да if supported, or нет otherwise.
                Нет return will cause a series of discrete собери
                calls

        ***************************************************************/

        бул собери (бул все = да)
        {
            if (все)
            {
                foreach (ref список; списки)
                {
                    освободи (список.ptr);
                    список = пусто;
                }
                кэш = пусто;
                списки = пусто;
                return да;
            }
            return нет;
        }

        /***************************************************************

                установи the чанк размер и prepopulate with узелs

        ***************************************************************/

        проц конфиг (т_мера чанки, цел размести=0)
        {
            this.чанки = чанки;
            if (размести)
                for (цел i=размести/чанки+1; i--;)
                    новый_список;
        }

        /***************************************************************

                список manager

        ***************************************************************/

        private проц новый_список ()
        {
            списки.length = списки.length + 1;
            auto p = (cast(T*) кразмести (чанки, T.sizeof)) [0 .. чанки];
            списки[$-1] = p;
            auto голова = кэш;
            foreach (ref узел; p)
            {
                auto d = cast(Кэш*) &узел;
                d.следщ = голова;
                голова = d;
            }
            кэш = голова;
        }
    }


    /***********************************************************************

            генерный СМ allocation manager

            Slow и expensive in память costs

    ***********************************************************************/

    struct Сбор(T)
    {
        /***************************************************************

                размести a T sized память чанк

        ***************************************************************/

        T* размести ()
        {
            return cast(T*) смКразмести (T.sizeof);
        }

        /***************************************************************

                размести an Массив of T sized память чанки

        ***************************************************************/

        T*[] размести (т_мера счёт)
        {
            return new T*[счёт];
        }

        /***************************************************************

                Invoked when a specific T[] is discarded

        ***************************************************************/

        проц собери (T* p)
        {
            if (p)
                delete p;
        }

        /***************************************************************

                Invoked when a specific T[] is discarded

        ***************************************************************/

        проц собери (T*[] t)
        {
            if (t)
                delete t;
        }

        /***************************************************************

                Invoked when очисть/сбрось is called on the хост.
                This is a shortcut в_ очисть everything allocated.

                Should return да if supported, or нет otherwise.
                Нет return will cause a series of discrete собери
                calls

        ***************************************************************/

        бул собери (бул все = да)
        {
            return нет;
        }

        /***************************************************************

                установи the чанк размер и prepopulate with узелs

        ***************************************************************/

        проц конфиг (т_мера чанки, цел размести=0)
        {
        }
    }


    /***********************************************************************

            Празмест allocation manager.

            Note that, due в_ СМ behaviour, you should not конфигурируй
            a custom разместитель for containers holding anything managed
            by the СМ. For example, you cannot use a MallocAllocator
            в_ manage a container of classes or strings where those
            were allocated by the СМ. Once something is owned by a СМ
            then it's lifetime must be managed by СМ-managed entities
            (otherwise the СМ may think there are no live references
            и prematurely собери container contents).

            You can explicity manage the collection of ключи и значения
            yourself by provопрing a рипер delegate. For example, if
            you use a MallocAllocator в_ manage ключ/значение pairs which
            are themselves allocated via malloc, then you should also
            provопрe a рипер delegate в_ собери those as требуется.

    ***********************************************************************/

    struct Празмест(T)
    {
        /***************************************************************

                размести an Массив of T sized память чанки

        ***************************************************************/

        T* размести ()
        {
            return cast(T*) кразмести (1, T.sizeof);
        }

        /***************************************************************

                размести an Массив of T sized память чанки

        ***************************************************************/

        T*[] размести (т_мера счёт)
        {
            return (cast(T**) кразмести(счёт, (T*).sizeof)) [0 .. счёт];
        }

        /***************************************************************

                Invoked when a specific T[] is discarded

        ***************************************************************/

        проц собери (T*[] t)
        {
            if (t.length)
                освободи (t.ptr);
        }

        /***************************************************************

                Invoked when a specific T[] is discarded

        ***************************************************************/

        проц собери (T* p)
        {
            if (p)
                освободи (p);
        }

        /***************************************************************

                Invoked when очисть/сбрось is called on the хост.
                This is a shortcut в_ очисть everything allocated.

                Should return да if supported, or нет otherwise.
                Нет return will cause a series of discrete собери
                calls

        ***************************************************************/

        бул собери (бул все = да)
        {
            return нет;
        }

        /***************************************************************

                установи the чанк размер и prepopulate with узелs

        ***************************************************************/

        проц конфиг (т_мера чанки, цел размести=0)
        {
        }
    }


    version (prior_allocator)
    {
        /***********************************************************************

                СМЧанк разместитель

                Like the Чанк разместитель, this allocates элементы in чанки,
                but allows you в_ размести элементы that can have СМ pointers.

                Tests have shown about a 60% speedup when using the СМ чанк
                разместитель for a Хэшmap!(цел, цел).

        ***********************************************************************/

        struct СМЧанк(T, бцел размЧанка)
        {
            static if(T.sizeof < (ук).sizeof)
            {
                static assert(нет, "Ошибка, аллокатор для " ~ T.stringof ~ " не удалось инстанциировать");
            }

            /**
             * This is the form использован в_ link recyclable элементы together.
             */
            struct элемент
            {
                элемент *следщ;
            }

            /**
             * A чанк of элементы
             */
            struct чанк
            {
                /**
                 * The следщ чанк in the chain
                 */
                чанк *следщ;

                /**
                 * The previous чанк in the chain.  Требуется for O(1) removal
                 * из_ the chain.
                 */
                чанк *предш;

                /**
                 * The linked список of освободи элементы in the чанк.  This список is
                 * amended each время an элемент in this чанк is освободиd.
                 */
                элемент *списокОсвобождений;

                /**
                 * The число of освободи элементы in the списокОсвобождений.  Used в_ determine
                 * whether this чанк can be given back в_ the СМ
                 */
                бцел члоОсвобождений;

                /**
                 * The элементы in the чанк.
                 */
                T[размЧанка] элемы;

                /**
                 * Размести a T* из_ the освободи список.
                 */
                T *разместиИзОсвобСписка()
                {
                    элемент *x = списокОсвобождений;
                    списокОсвобождений = x.следщ;
                    //
                    // очисть the pointer, this clears the элемент as if it was
                    // newly allocated
                    //
                    x.следщ = пусто;
                    члоОсвобождений--;
                    return cast(T*)x;
                }

                /**
                 * вымести a T*, шли it в_ the освободи список
                 *
                 * returns да if this чанк no longer имеется any использован элементы.
                 */
                бул вымести(T *t)
                {
                    //
                    // очисть the элемент so the СМ does not interpret the элемент
                    // as pointing в_ anything else.
                    //
                    устбуф(t, 0, (T).sizeof);
                    элемент *x = cast(элемент *)t;
                    x.следщ = списокОсвобождений;
                    списокОсвобождений = x;
                    return (++члоОсвобождений == размЧанка);
                }
            }

            /**
             * The chain of использован чанки.  Used чанки have had все their элементы
             * allocated at least once.
             */
            чанк *использован;

            /**
             * The свежий чанк.  This is only использован if no элементы are available in
             * the использован chain.
             */
            чанк *свежий;

            /**
             * The следщ элемент in the свежий чанк.  Because we don't worry about
             * the освободи список in the свежий чанк, we need в_ keep track of the следщ
             * свежий элемент в_ use.
             */
            бцел свежийСледщ;

            /**
             * Размести a T*
             */
            T* размести()
            {
                if(использован !is пусто && использован.члоОсвобождений > 0)
                {
                    //
                    // размести one элемент of the использован список
                    //
                    T* результат = использован.разместиИзОсвобСписка();
                    if(использован.члоОсвобождений == 0)
                        //
                        // перемести использован в_ the конец of the список
                        //
                        использован = использован.следщ;
                    return результат;
                }

                //
                // no использован элементы are available, размести out of the свежий
                // элементы
                //
                if(свежий is пусто)
                {
                    свежий = new чанк;
                    свежийСледщ = 0;
                }

                T* результат = &свежий.элемы[свежийСледщ];
                if(++свежийСледщ == размЧанка)
                {
                    if(использован is пусто)
                    {
                        использован = свежий;
                        свежий.следщ = свежий;
                        свежий.предш = свежий;
                    }
                    else
                    {
                        //
                        // вставь свежий преобр_в the использован chain
                        //
                        свежий.предш = использован.предш;
                        свежий.следщ = использован;
                        свежий.предш.следщ = свежий;
                        свежий.следщ.предш = свежий;
                        if(свежий.члоОсвобождений != 0)
                        {
                            //
                            // can recycle элементы из_ свежий
                            //
                            использован = свежий;
                        }
                    }
                    свежий = пусто;
                }
                return результат;
            }

            T*[] размести(бцел счёт)
            {
                return new T*[счёт];
            }


            /**
             * освободи a T*
             */
            проц собери(T* t)
            {
                //
                // need в_ figure out which чанк t is in
                //
                чанк *тек = cast(чанк *)смАдрес(t);

                if(тек !is свежий && тек.члоОсвобождений == 0)
                {
                    //
                    // перемести тек в_ the front of the использован список, it имеется освободи узелs
                    // в_ be использован.
                    //
                    if(тек !is использован)
                    {
                        if(использован.члоОсвобождений != 0)
                        {
                            //
                            // первый, отвяжи тек из_ its текущ location
                            //
                            тек.предш.следщ = тек.следщ;
                            тек.следщ.предш = тек.предш;

                            //
                            // сейчас, вставь тек before использован.
                            //
                            тек.предш = использован.предш;
                            тек.следщ = использован;
                            использован.предш = тек;
                            тек.предш.следщ = тек;
                        }
                        использован = тек;
                    }
                }

                if(тек.вымести(t))
                {
                    //
                    // тек no longer имеется any элементы in use, it can be deleted.
                    //
                    if(тек.следщ is тек)
                    {
                        //
                        // only one элемент, don't освободи it.
                        //
                    }
                    else
                    {
                        //
                        // удали тек из_ список
                        //
                        if(использован is тек)
                        {
                            //
                            // обнови использован pointer
                            //
                            использован = использован.следщ;
                        }
                        тек.следщ.предш = тек.предш;
                        тек.предш.следщ = тек.следщ;
                        delete тек;
                    }
                }
            }

            проц собери(T*[] t)
            {
                if(t)
                    delete t;
            }

            /**
             * Deallocate все чанки использован by this разместитель.  Depends on the СМ в_ do
             * the actual collection
             */
            бул собери(бул все = да)
            {
                использован = пусто;

                //
                // keep свежий around
                //
                if(свежий !is пусто)
                {
                    свежийСледщ = 0;
                    свежий.списокОсвобождений = пусто;
                }

                return да;
            }

            проц конфиг (т_мера чанки, цел размести=0)
            {
            }
        }

        /***********************************************************************

                алиасы в_ the correct Default разместитель depending on как big
                the тип is.  It makes less sense в_ use a СМЧанк разместитель
                if the тип is going в_ be larger than a страница (currently there
                is no way в_ получи the страница размер из_ the СМ, so we assume 4096
                байты).  If not ещё than one unit can fit преобр_в a страница, then
                we use the default СМ разместитель.

        ***********************************************************************/
        template ДефСбор(T)
        {
            static if((T).sizeof + ((ук).sizeof * 3) + бцел.sizeof >= 4095 / 2)
            {
                alias Сбор!(T) ДефСбор;
            }
            else
            {
                alias СМЧанк!(T, (4095 - ((проц *).sizeof * 3) - бцел.sizeof) / (T).sizeof) ДефСбор;
            }
            // TODO: see if we can automatically figure out whether a тип имеется
            // any pointers in it, this would allow automatic usage of the
            // Чанк разместитель for добавьed скорость.
        }
    }
    else
        template ДефСбор(T)
    {
        alias ЧанкСМ!(T) ДефСбор;
    }

}


