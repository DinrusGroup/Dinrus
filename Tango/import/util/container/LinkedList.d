﻿/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Apr 2008: Initial release

        authors:        Kris

        Since:          0.99.7

        Based upon Doug Lea's Java collection package

*******************************************************************************/

module util.container.LinkedList;

private import  util.container.Slink;

public  import  util.container.Container;

private import util.container.model.IContainer;

/*******************************************************************************

        Список of singly-linked значения

        ---
	Обходчик обходчик ()
        цел opApply (цел delegate(ref V значение) дг)

        V голова ()
        V хвост ()
        V голова (V значение)
        V хвост (V значение)
        V удалиГолову ()
        V удалиХвост ()

        бул содержит (V значение)
        т_мера первый (V значение, т_мера startingIndex = 0)
        т_мера последний (V значение, т_мера startingIndex = 0)

        LinkedList добавь (V значение)
        LinkedList приставь (V значение)
        т_мера приставь (ИКонтейнер!(V) e)
        LinkedList добавь (V значение)
        т_мера добавь (ИКонтейнер!(V) e)
        LinkedList добавьПо (т_мера индекс, V значение)
        т_мера добавьПо (т_мера индекс, ИКонтейнер!(V) e)

        V получи (т_мера индекс)
        бул возьми (ref V v)
        т_мера удали (V значение, бул все)
        бул удалиПо (т_мера индекс)
        т_мера удалиДиапазон (т_мера отИндекса, т_мера доИндекса)
        т_мера замени (V старЭлемент, V новЭлемент, бул все)
        бул замениПо (т_мера индекс, V значение)

        LinkedList очисть ()
        LinkedList сбрось ()

        LinkedList поднабор (т_мера из_, т_мера length = т_мера.max)
        LinkedList dup ()

        т_мера размер ()
        бул пуст_ли ()
        V[] вМассив (V[] приёмн)
        LinkedList сортируй (Сравни!(V) cmp)
        LinkedList проверь ()
        ---

*******************************************************************************/

class LinkedList (V, alias Извл = Контейнер.извлеки, 
                     alias Куча = Контейнер.ДефСбор) 
                     : ИКонтейнер!(V)
{
        // use this тип for Разместитель configuration
        private alias Slink!(V) Тип;
        
        private alias Тип*     Реф;
        private alias V*        VRef;

        private alias Куча!(Тип) Размест;

        // число of элементы contained
        private т_мера          счёт;

        // configured куча manager
        private Размест           куча;
        
        // мутация тэг updates on each change
        private т_мера          мутация;

        // голова of the список. Пусто if пустой
        private Реф             список;

        /***********************************************************************

                Созд a new пустой список

        ***********************************************************************/

        this ()
        {
                this (пусто, 0);
        }

        /***********************************************************************

                Special version of constructor needed by dup

        ***********************************************************************/

        protected this (Реф l, т_мера c)
        {
                список = l;
                счёт = c;
        }

        /***********************************************************************

                Clean up when deleted

        ***********************************************************************/

        ~this ()
        {
                сбрось;
        }

        /***********************************************************************

                Return a генерный обходчик for contained элементы
                
        ***********************************************************************/

        final Обходчик обходчик ()
        {
                Обходчик i =void;
                i.мутация = мутация;
                i.узел = список ? *(i.hook = &список) : пусто;
                i.приор = пусто;
                i.хозяин = this;
                return i;
        }

        /***********************************************************************

                Configure the назначено разместитель with the размер of each
                allocation блок (число of узелs allocated at one время)
                и the число of узелs в_ pre-наполни the кэш with.
                
                Время complexity: O(n)

        ***********************************************************************/

        final LinkedList кэш (т_мера чанк, т_мера счёт=0)
        {
                куча.конфиг (чанк, счёт);
                return this;
        }

        /***********************************************************************


        ***********************************************************************/

        final цел opApply (цел delegate(ref V значение) дг)
        {
                return обходчик.opApply (дг);
        }

        /***********************************************************************

                Return the число of элементы contained
                
        ***********************************************************************/

        final т_мера размер ()
        {
                return счёт;
        }

        /***********************************************************************

                Build an independent копируй of the список.
                The элементы themselves are not cloned

        ***********************************************************************/

        final LinkedList dup ()
        {
                return new LinkedList!(V, Извл, куча) (список ? список.копируй(&куча.размести) : пусто, счёт);
        }

        /***********************************************************************

                Время complexity: O(n)

        ***********************************************************************/

        final бул содержит (V значение)
        {
                if (счёт is 0)
                    return нет;

                return список.найди(значение) !is пусто;
        }

        /***********************************************************************

                 Время complexity: O(1)

        ***********************************************************************/

        final V голова ()
        {
                return перваяЯчейка.значение;
        }

        /***********************************************************************

                 Время complexity: O(n)

        ***********************************************************************/

        final V хвост ()
        {
                return последняяЯчейка.значение;
        }

        /***********************************************************************

                 Время complexity: O(n)

        ***********************************************************************/

        final V получи (т_мера индекс)
        {
                return ячейкаПо(индекс).значение;
        }

        /***********************************************************************

                 Время complexity: O(n)
                 Returns т_мера.max if no элемент найдено.

        ***********************************************************************/

        final т_мера первый (V значение, т_мера startingIndex = 0)
        {
                if (список is пусто || startingIndex >= счёт)
                    return т_мера.max;

                if (startingIndex < 0)
                    startingIndex = 0;

                auto p = список.н_ый (startingIndex);
                if (p)
                   {
                   auto i = p.индекс (значение);
                   if (i >= 0)
                       return i + startingIndex;
                   }
                return т_мера.max;
        }

        /***********************************************************************

                 Время complexity: O(n)
                 Returns т_мера.max if no элемент найдено.

        ***********************************************************************/

        final т_мера последний (V значение, т_мера startingIndex = 0)
        {
                if (список is пусто)
                    return т_мера.max;

                auto i = 0;
                if (startingIndex >= счёт)
                    startingIndex = счёт - 1;

                auto индекс = т_мера.max;
                auto p = список;
                while (i <= startingIndex && p)
                      {
                      if (p.значение == значение)
                          индекс = i;
                      ++i;
                      p = p.следщ;
                      }
                return индекс;
        }

        /***********************************************************************

                 Время complexity: O(length)

        ***********************************************************************/

        final LinkedList поднабор (т_мера из_, т_мера length = т_мера.max)
        {
                Реф новый_список = пусто;

                if (length > 0)
                   {
                   auto p = ячейкаПо (из_);
                   auto текущ = новый_список = куча.размести.установи (p.значение, пусто);
         
                   for (auto i = 1; i < length; ++i)
                        if ((p = p.следщ) is пусто)
                             length = i;
                        else
                           {
                           текущ.прикрепи (куча.размести.установи (p.значение, пусто));
                           текущ = текущ.следщ;
                           }
                   }

                return new LinkedList (новый_список, length);
        }

        /***********************************************************************

                 Время complexity: O(n)

        ***********************************************************************/

        final LinkedList очисть ()
        {
                return очисть (нет);
        }

        /***********************************************************************

                Reset the ХэшКарта contents и optionally конфигурируй a new
                куча manager. We cannot guarantee в_ clean up reconfigured 
                allocators, so be sure в_ invoke сбрось() before discarding
                this class

                Время complexity: O(n)
                
        ***********************************************************************/

        final LinkedList сбрось ()
        {
                return очисть (да);
        }

        /***********************************************************************
        
                Takes the первый значение on the список

                Время complexity: O(1)

        ***********************************************************************/

        final бул возьми (ref V v)
        {
                if (счёт)
                   {
                   v = голова;
                   удалиГолову;
                   return да;
                   }
                return нет;
        }

        /***********************************************************************

                Uses a merge-сортируй-based algorithm.

                Время complexity: O(n лог n)

        ***********************************************************************/

        final LinkedList сортируй (Сравни!(V) cmp)
        {
                if (список)
                   {
                   список = Реф.сортируй (список, cmp);
                   измени;
                   }
                return this;
        }

        /***********************************************************************

                Время complexity: O(1)

        ***********************************************************************/

        final LinkedList добавь (V значение)
        {
                return приставь (значение);
        }

        /***********************************************************************

                Время complexity: O(1)

        ***********************************************************************/

        final LinkedList приставь (V значение)
        {
                список = куча.размести.установи (значение, список);
                инкремент;
                return this;
        }

        /***********************************************************************

                Время complexity: O(n)

        ***********************************************************************/

        final т_мера удали (V значение, бул все = нет)
        {
                auto c = счёт;
                if (c)
                   {
                   auto p = список;
                   auto trail = p;

                   while (p)
                         {
                         auto n = p.следщ;
                         if (p.значение == значение)
                            {
                            декремент (p);
                            if (p is список)
                               {
                               список = n;
                               trail = n;
                               }
                            else
                               trail.следщ = n;

                            if (!все || счёт is 0)
                                 break;
                            else
                               p = n;
                            }
                         else
                            {
                            trail = p;
                            p = n;
                            }
                         }
                   }
                return c - счёт;
        }

        /***********************************************************************

                Время complexity: O(n)

        ***********************************************************************/

        final т_мера замени (V старЭлемент, V новЭлемент, бул все = нет)
        {
                т_мера c;
                if (счёт && старЭлемент != новЭлемент)
                   {
                   auto p = список.найди (старЭлемент);
                   while (p)
                         {
                         ++c;
                         измени;
                         p.значение = новЭлемент;
                         if (!все)
                              break;
                         p = p.найди (старЭлемент);
                         }
                   }
                return c;
        }

        /***********************************************************************

                 Время complexity: O(1)

        ***********************************************************************/

        final V голова (V значение)
        {
                auto ячейка = перваяЯчейка;
                auto v = ячейка.значение;
                ячейка.значение = значение;
                измени;
                return v;
        }

        /***********************************************************************

                 Время complexity: O(1)

        ***********************************************************************/

        final V удалиГолову ()
        {
                auto p = перваяЯчейка;
                auto v = p.значение;
                список = p.следщ;
                декремент (p);
                return v;
        }

        /***********************************************************************

                 Время complexity: O(n)

        ***********************************************************************/

        final LinkedList добавь (V значение)
        {
                if (список is пусто)
                    приставь (значение);
                else
                   {
                   список.хвост.следщ = куча.размести.установи (значение, пусто);
                   инкремент;
                   }
                return this;
        }

        /***********************************************************************

                 Время complexity: O(n)

        ***********************************************************************/

        final V хвост (V значение)
        {
                auto p = последняяЯчейка;
                auto v = p.значение;
                p.значение = значение;
                измени;
                return v;
        }

        /***********************************************************************

                 Время complexity: O(n)

        ***********************************************************************/

        final V удалиХвост ()
        {
                if (перваяЯчейка.следщ is пусто)
                    return удалиГолову;

                auto trail = список;
                auto p = trail.следщ;

                while (p.следщ)
                      {
                      trail = p;
                      p = p.следщ;
                      }
                trail.следщ = пусто;
                auto v = p.значение;
                декремент (p);
                return v;
        }

        /***********************************************************************

                Время complexity: O(n)

        ***********************************************************************/

        final LinkedList добавьПо (т_мера индекс, V значение)
        {
                if (индекс is 0)
                    приставь (значение);
                else
                   {
                   ячейкаПо(индекс - 1).прикрепи (куча.размести.установи(значение, пусто));
                   инкремент;
                   }
                return this;
        }

        /***********************************************************************

                 Время complexity: O(n)

        ***********************************************************************/

        final LinkedList удалиПо (т_мера индекс)
        {
                if (индекс is 0)
                    удалиГолову;
                else
                   {
                   auto p = ячейкаПо (индекс - 1);
                   auto t = p.следщ;
                   p.отторочьСледщ;
                   декремент (t);
                   }
                return this;
        }

        /***********************************************************************

                 Время complexity: O(n)

        ***********************************************************************/

        final LinkedList замениПо (т_мера индекс, V значение)
        {
                ячейкаПо(индекс).значение = значение;
                измени;
                return this;
        }

        /***********************************************************************

                 Время complexity: O(число of элементы in e)

        ***********************************************************************/

        final т_мера приставь (ИКонтейнер!(V) e)
        {
                auto c = счёт;
                splice_ (e, пусто, список);
                return счёт - c;
        }

        /***********************************************************************

                 Время complexity: O(n + число of элементы in e)

        ***********************************************************************/

        final т_мера добавь (ИКонтейнер!(V) e)
        {
                auto c = счёт;
                if (список is пусто)
                    splice_ (e, пусто, пусто);
                else
                   splice_ (e, список.хвост, пусто);
                return счёт - c;
        }

        /***********************************************************************

                Время complexity: O(n + число of элементы in e)

        ***********************************************************************/

        final т_мера добавьПо (т_мера индекс, ИКонтейнер!(V) e)
        {
                auto c = счёт;
                if (индекс is 0)
                    splice_ (e, пусто, список);
                else
                   {
                   auto p = ячейкаПо (индекс - 1);
                   splice_ (e, p, p.следщ);
                   }
                return счёт - c;
        }

        /***********************************************************************

                Время complexity: O(n)

        ***********************************************************************/

        final т_мера удалиДиапазон (т_мера отИндекса, т_мера доИндекса)
        {
                auto c = счёт;
                if (отИндекса <= доИндекса)
                   {
                   if (отИндекса is 0)
                      {
                      auto p = перваяЯчейка;
                      for (т_мера i = отИндекса; i <= доИндекса; ++i)
                           p = p.следщ;
                      список = p;
                      }
                   else
                      {
                      auto f = ячейкаПо (отИндекса - 1);
                      auto p = f;
                      for (т_мера i = отИндекса; i <= доИндекса; ++i)
                           p = p.следщ;
                      f.следщ = p.следщ;
                      }

                  счёт -= (доИндекса - отИндекса + 1);
                  измени;
                  }
                return c - счёт;
        }

        /***********************************************************************

                Copy и return the contained установи of значения in an Массив, 
                using the optional приёмн as a реципиент (which is resized 
                as necessary).

                Returns a срез of приёмн representing the container значения.
                
                Время complexity: O(n)
                
        ***********************************************************************/

        final V[] вМассив (V[] приёмн = пусто)
        {
                if (приёмн.length < счёт)
                    приёмн.length = счёт;

                т_мера i = 0;
                foreach (v; this)
                         приёмн[i++] = v;
                return приёмн [0 .. счёт];                        
        }

        /***********************************************************************

                Is this container пустой?
                
                Время complexity: O(1)
                
        ***********************************************************************/

        final бул пуст_ли ()
        {
                return счёт is 0;
        }

        /***********************************************************************

        ***********************************************************************/

        final LinkedList проверь ()
        {
                assert(((счёт is 0) is (список is пусто)));
                assert((список is пусто || список.счёт is размер));

                т_мера c = 0;
                for (Реф p = список; p; p = p.следщ)
                    {
                    assert(экземпляры(p.значение) > 0);
                    assert(содержит(p.значение));
                    ++c;
                    }
                assert(c is счёт);
                return this;
        }

        /***********************************************************************

                 Время complexity: O(n)

        ***********************************************************************/

        private т_мера экземпляры (V значение)
        {
                if (счёт is 0)
                    return 0;

                return список.счёт (значение);
        }

        /***********************************************************************

        ***********************************************************************/

        private Реф перваяЯчейка ()
        {
                проверьИндекс (0);
                return список;
        }

        /***********************************************************************

        ***********************************************************************/

        private Реф последняяЯчейка ()
        {
                проверьИндекс (0);
                return список.хвост;
        }

        /***********************************************************************

        ***********************************************************************/

        private Реф ячейкаПо (т_мера индекс)
        {
                проверьИндекс (индекс);
                return список.н_ый (индекс);
        }

        /***********************************************************************

        ***********************************************************************/

        private проц проверьИндекс (т_мера индекс)
        {
                if (индекс >= счёт)
                    throw new Исключение ("out of range");
        }

        /***********************************************************************

                Splice элементы of e between hd и tl. If hd 
                is пусто return new hd

                Returns the счёт of new элементы добавьed

        ***********************************************************************/

        private проц splice_ (ИКонтейнер!(V) e, Реф hd, Реф tl)
        {
                Реф новый_список = пусто;
                Реф текущ = пусто;

                foreach (v; e)
                        {
                        инкремент;

                        auto p = куча.размести.установи (v, пусто);
                        if (новый_список is пусто)
                            новый_список = p;
                        else
                           текущ.следщ = p;
                        текущ = p;
                        }

                if (текущ)
                   {
                   текущ.следщ = tl;

                   if (hd is пусто)
                       список = новый_список;
                   else
                      hd.следщ = новый_список;
                   }
        }

        /***********************************************************************

                 Время complexity: O(n)

        ***********************************************************************/

        private LinkedList очисть (бул все)
        {
                измени;

                // собери each узел if we can't собери все at once
                if (куча.собери(все) is нет && счёт)
                   {
                   auto p = список;
                   while (p)
                         {
                         auto n = p.следщ;
                         декремент (p);
                         p = n;
                         }
                   }
        
                список = пусто;
                счёт = 0;
                return this;
        }

        /***********************************************************************

                new элемент was добавьed
                
        ***********************************************************************/

        private проц инкремент ()
        {
                ++мутация;
                ++счёт;
        }
        
        /***********************************************************************

                элемент was removed
                
        ***********************************************************************/

        private проц декремент (Реф p)
        {
                Извл (p.значение);
                куча.собери (p);
                ++мутация;
                --счёт;
        }
        
        /***********************************************************************

                установи was изменён
                
        ***********************************************************************/

        private проц измени ()
        {
                ++мутация;
        }

        /***********************************************************************

                Список обходчик

        ***********************************************************************/

        private struct Обходчик
        {
                Реф             узел;
                Реф*            hook,
                                приор;
                LinkedList      хозяин;
                т_мера          мутация;

                /***************************************************************

                        Dопр the container change underneath us?

                ***************************************************************/

                бул действителен ()
                {
                        return хозяин.мутация is мутация;
                }               

                /***************************************************************

                        Accesses the следщ значение, и returns нет when
                        there are no further значения в_ traverse

                ***************************************************************/

                бул следщ (ref V v)
                {
                        auto n = следщ;
                        return (n) ? v = *n, да : нет;
                }
                
                /***************************************************************

                        Return a pointer в_ the следщ значение, or пусто when
                        there are no further значения в_ traverse

                ***************************************************************/

                V* следщ ()
                {
                        V* r;
                        if (узел)
                           {
                           приор = hook;
                           r = &узел.значение;
                           узел = *(hook = &узел.следщ);
                           }
                        return r;
                }

                /***************************************************************

                        Insert a new значение before the узел about в_ be
                        iterated (or after the узел that was just iterated).

                ***************************************************************/

                проц вставь(V значение)
                {
                        // вставь a узел previous в_ the узел that we are
                        // about в_ iterate.
                        *hook = хозяин.куча.размести.установи(значение, *hook);
                        узел = *hook;
                        следщ();

                        // обнови the счёт of the хозяин, и ignore this
                        // change in the мутация.
                        хозяин.инкремент;
                        мутация++;
                }

                /***************************************************************

                        Insert a new значение before the значение that was just
                        iterated.

                        Returns да if the приор узел existed и the
                        insertion worked.  Нет otherwise.

                ***************************************************************/

                бул insertPrior(V значение)
                {
                    if(приор)
                    {
                        // вставь a узел previous в_ the узел that we just
                        // iterated.
                        *приор = хозяин.куча.размести.установи(значение, *приор);
                        приор = &(*приор).следщ;

                        // обнови the счёт of the хозяин, и ignore this
                        // change in the мутация.
                        хозяин.инкремент;
                        мутация++;
                        return да;
                    }
                    return нет;
                }

                /***************************************************************

                        Foreach support

                ***************************************************************/

                цел opApply (цел delegate(ref V значение) дг)
                {
                        цел результат;

                        auto n = узел;
                        while (n)
                              {
                              приор = hook;
                              hook = &n.следщ;
                              if ((результат = дг(n.значение)) != 0)
                                   break;
                              n = *hook;
                              }
                        узел = n;
                        return результат;
                }                               

                /***************************************************************

                        Удали значение at the текущ обходчик location

                ***************************************************************/

                бул удали ()
                {
                        if (приор)
                           {
                           auto p = *приор;
                           *приор = p.следщ;
                           хозяин.декремент (p);
                           hook = приор;
                           приор = пусто;

                           // ignore this change
                           ++мутация;
                           return да;
                           }
                        return нет;
                }
        }
}


/*******************************************************************************

*******************************************************************************/

debug (LinkedList)
{
        import io.Stdout;
        import thread;
        import time.StopWatch;

        проц main()
        {
                // usage examples ...
                auto установи = new LinkedList!(ткст);
                установи.добавь ("foo");
                установи.добавь ("bar");
                установи.добавь ("wumpus");

                // implicit генерный iteration
                foreach (значение; установи)
                         Стдвыв (значение).нс;

                // явный генерный iteration   
                foreach (значение; установи.обходчик)
                         Стдвыв.форматнс ("{}", значение);

                // генерный iteration with optional удали и вставь
                auto s = установи.обходчик;
                foreach (значение; s)
                {
                         if (значение == "foo")
                             s.удали;
                         if (значение == "bar")
                             s.insertPrior("bloomper");
                         if (значение == "wumpus")
                             s.вставь("rumple");
                }

                установи.проверь();

                // incremental iteration, with optional удали
                ткст v;
                auto обходчик = установи.обходчик;
                while (обходчик.следщ(v))
                      {} //обходчик.удали;
                
                // incremental iteration, with optional failfast
                auto it = установи.обходчик;
                while (it.действителен && it.следщ(v))
                      {}

                // удали specific элемент
                установи.удали ("wumpus");

                // удали первый элемент ...
                while (установи.возьми(v))
                       Стдвыв.форматнс ("taking {}, {} left", v, установи.размер);
                
                
                // установи for benchmark, with a установи of целыйs. We
                // use a чанк разместитель, и presize the bucket[]
                auto тест = new LinkedList!(цел, Контейнер.извлеки, Контейнер.Чанк);
                тест.кэш (2000, 1_000_000);
                const счёт = 1_000_000;
                Секундомер w;

                // benchmark добавьing
                w.старт;
                for (цел i=счёт; i--;)
                     тест.приставь(i);
                Стдвыв.форматнс ("{} добавьs: {}/s", тест.размер, тест.размер/w.stop);

                // benchmark добавьing without allocation overhead
                тест.очисть;
                w.старт;
                for (цел i=счёт; i--;)
                     тест.приставь(i);
                Стдвыв.форматнс ("{} добавьs (after очисть): {}/s", тест.размер, тест.размер/w.stop);

                // benchmark duplication
                w.старт;
                auto dup = тест.dup;
                Стдвыв.форматнс ("{} элемент dup: {}/s", dup.размер, dup.размер/w.stop);

                // benchmark iteration
                w.старт;
                auto xx = тест.обходчик;
                цел ii;
                while (xx.следщ()) {}
                Стдвыв.форматнс ("{} элемент iteration: {}/s", тест.размер, тест.размер/w.stop);

                // benchmark iteration
                w.старт;
                foreach (v; тест) {}
                Стдвыв.форматнс ("{} foreach iteration: {}/s", тест.размер, тест.размер/w.stop);


                // benchmark iteration
                w.старт;             
                foreach (ref iii; тест) {} 
                Стдвыв.форматнс ("{} pointer iteration: {}/s", тест.размер, тест.размер/w.stop);

                тест.проверь;
        }
}
                
