﻿/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Apr 2008: Initial release

        authors:        Kris

        Since:          0.99.7

        Based upon Doug Lea's Java collection package

*******************************************************************************/

module util.container.SortedMap;

public  import  util.container.Container;

private import  util.container.RedBlack;

private import  util.container.model.IContainer;

private import exception : НетЭлементаИскл;

/*******************************************************************************

        RedBlack trees of (ключ, значение) pairs

        ---
        Обходчик обходчик (бул вперёд)
        Обходчик обходчик (K ключ, бул вперёд)
        цел opApply (цел delegate (ref V значение) дг)
        цел opApply (цел delegate (ref K ключ, ref V значение) дг)

        бул содержит (V значение)
        бул содержитКлюч (K ключ)
        бул содержитПару (K ключ, V значение)
        бул ключК (V значение, ref K ключ)
        бул получи (K ключ, ref V значение)

        бул возьми (ref V v)
        бул возьми (K ключ, ref V v)
        бул удалиКлюч (K ключ)
        т_мера удали (V значение, бул все)
        т_мера удали (ИКонтейнер!(V) e, бул все)

        бул добавь (K ключ, V значение)
        т_мера замени (V старЭлемент, V новЭлемент, бул все)
        бул замениПару (K ключ, V старЭлемент, V новЭлемент)
        бул opIndexAssign (V элемент, K ключ)
        K    nearbyKey (K ключ, бул greater)
        V    opIndex (K ключ)
        V*   opIn_r (K ключ)

        т_мера размер ()
        бул пуст_ли ()
        V[] вМассив (V[] приёмн)
        SortedMap dup ()
        SortedMap очисть ()
        SortedMap сбрось ()
        SortedMap comparator (Comparator c)
        ---

*******************************************************************************/

class SortedMap (K, V, alias Извл = Контейнер.извлеки, 
                       alias Куча = Контейнер.ДефСбор) 
                       : ИКонтейнер!(V)
{
        // use this тип for Разместитель configuration
        public alias RedBlack!(K, V)    Тип;
        private alias Тип              *Реф;

        private alias Куча!(Тип)       Размест;
        private alias Сравни!(K)       Comparator;

        // корень of the дерево. Пусто if пустой.
        package Реф                     дерево;

        // configured куча manager
        private Размест                   куча;

        // Comparators использован for ordering
        private Comparator              cmp;
        private Сравни!(V)             cmpElem;

        private т_мера                  счёт,
                                        мутация;


        /***********************************************************************

                Make an пустой дерево, using given Comparator for ordering
                 
        ***********************************************************************/

        public this (Comparator c = пусто)
        {
                this (c, 0);
        }

        /***********************************************************************

                Special version of constructor needed by dup()
                 
        ***********************************************************************/

        private this (Comparator c, т_мера n)
        {       
                счёт = n;
                cmpElem = &compareElem;
                cmp = (c is пусто) ? &compareKey : c;
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

        final Обходчик обходчик (бул вперёд = да)
        {
                Обходчик i =void;
                i.узел = счёт ? (вперёд ? дерево.leftmost : дерево.rightmost) : пусто;
                i.bump = вперёд ? &Обходчик.fore : &Обходчик.back;
                i.мутация = мутация;
                i.хозяин = this;
                i.приор = пусто;
                return i;
        }
      
        /***********************************************************************

                Return an обходчик which return все элементы совпадают 
                or greater/lesser than the ключ in аргумент. The секунда
                аргумент dictates traversal direction.

                Return a генерный обходчик for contained элементы
                
        ***********************************************************************/

        final Обходчик обходчик (K ключ, бул вперёд)
        {
                Обходчик i = обходчик (вперёд);
                i.узел = счёт ? дерево.findFirst(ключ, cmp, вперёд) : пусто;
                return i;
        }

        /***********************************************************************

                Configure the назначено разместитель with the размер of each
                allocation блок (число of узелs allocated at one время)
                и the число of узелs в_ pre-наполни the кэш with.
                
                Время complexity: O(n)

        ***********************************************************************/

        final SortedMap кэш (т_мера чанк, т_мера счёт=0)
        {
                куча.конфиг (чанк, счёт);
                return this;
        }

        /***********************************************************************

                Return the число of элементы contained
                
        ***********************************************************************/

        final т_мера размер ()
        {
                return счёт;
        }
        
        /***********************************************************************

                Созд an independent копируй. Does not клонируй элементы
                 
        ***********************************************************************/

        final SortedMap dup ()
        {
                auto клонируй = new SortedMap!(K, V, Извл, куча) (cmp, счёт);
                if (счёт)
                    клонируй.дерево = дерево.copyTree (&клонируй.куча.размести);

                return клонируй;
        }

        /***********************************************************************

                Время complexity: O(лог n)
                        
        ***********************************************************************/

        final бул содержит (V значение)
        {
                if (счёт is 0)
                    return нет;
                return дерево.findAttribute (значение, cmpElem) !is пусто;
        }

        /***********************************************************************
        
        ***********************************************************************/
        
        final цел opApply (цел delegate (ref V значение) дг)
        {
                return обходчик.opApply ((ref K k, ref V v) {return дг(v);});
        }


        /***********************************************************************
        
        ***********************************************************************/
        
        final цел opApply (цел delegate (ref K ключ, ref V значение) дг)
        {
                return обходчик.opApply (дг);
        }

        /***********************************************************************

                Use a new Comparator. Causes a reorganization
                 
        ***********************************************************************/

        final SortedMap comparator (Comparator c)
        {
                if (cmp !is c)
                   {
                   cmp = (c is пусто) ? &compareKey : c;

                   if (счёт !is 0)
                      {       
                      // must rebuild дерево!
                      измени;
                      auto t = дерево.leftmost;
                      дерево = пусто;
                      счёт = 0;
                      
                      while (t)
                            {
                            добавь_ (t.значение, t.attribute, нет);
                            t = t.successor;
                            }
                      }
                   }
                return this;
        }

        /***********************************************************************

                Время complexity: O(лог n)
                 
        ***********************************************************************/

        final бул содержитКлюч (K ключ)
        {
                if (счёт is 0)
                    return нет;

                return дерево.найди (ключ, cmp) !is пусто;
        }

        /***********************************************************************

                Время complexity: O(n)
                 
        ***********************************************************************/

        final бул содержитПару (K ключ, V значение)
        {
                if (счёт is 0)
                    return нет;

                return дерево.найди (ключ, значение, cmp) !is пусто;
        }

        /***********************************************************************

                Return the значение associated with Key ключ. 

                param: ключ a ключ
                Возвращает: whether the ключ is contained or not
                 
        ***********************************************************************/

        final бул получи (K ключ, ref V значение)
        {
                if (счёт)
                   {
                   auto p = дерево.найди (ключ, cmp);
                   if (p)
                      {
                      значение = p.attribute;
                      return да;
                      }
                   }
                return нет;
        }

        /***********************************************************************

                Return the значение of the ключ exactly совпадают the provопрed
                ключ or, if Неук, the ключ just after/before it based on the
                настройка of the секунда аргумент
    
                param: ключ a ключ
                param: after indicates whether в_ look beyond or before
                       the given ключ, where there is no exact сверь
                throws: НетЭлементаИскл if Неук найдено
                returns: a pointer в_ the значение, or пусто if not present
             
        ***********************************************************************/

        K nearbyKey (K ключ, бул after)
        {
                if (счёт)
                   {
                   auto p = дерево.findFirst (ключ, cmp, after);
                   if (p)
                       return p.значение;
                   }

                noSuchElement ("no such ключ");
                assert (0);
        }

        /***********************************************************************
        
                Return the первый ключ of the карта

                throws: НетЭлементаИскл where the карта is пустой
                     
        ***********************************************************************/

        K firstKey ()
        {
                if (счёт)
                    return дерево.leftmost.значение;

                noSuchElement ("no such ключ");
                assert (0);
        }

        /***********************************************************************
        
                Return the последний ключ of the карта

                throws: НетЭлементаИскл where the карта is пустой
                     
        ***********************************************************************/

        K lastKey ()
        {
                if (счёт)
                    return дерево.rightmost.значение;

                noSuchElement ("no such ключ");
                assert (0);
        }

        /***********************************************************************

                Return the значение associated with Key ключ. 

                param: ключ a ключ
                Возвращает: a pointer в_ the значение, or пусто if not present
                 
        ***********************************************************************/

        final V* opIn_r (K ключ)
        {
                if (счёт)
                   {
                   auto p = дерево.найди (ключ, cmp);
                   if (p)
                       return &p.attribute;
                   }
                return пусто;
        }

        /***********************************************************************

                Время complexity: O(n)
                 
        ***********************************************************************/

        final бул ключК (V значение, ref K ключ)
        {
                if (счёт is 0)
                    return нет;

                auto p = дерево.findAttribute (значение, cmpElem);
                if (p is пусто)
                    return нет;

                ключ = p.значение;
                return да;
        }

        /***********************************************************************

                Время complexity: O(n)
                 
        ***********************************************************************/

        final SortedMap очисть ()
        {
                return очисть (нет);
        }

        /***********************************************************************

                Reset the SortedMap contents. This releases ещё память 
                than очисть() does

                Время complexity: O(n)
                
        ***********************************************************************/

        final SortedMap сбрось ()
        {
                return очисть (да);
        }

        /***********************************************************************

        ************************************************************************/

        final т_мера удали (ИКонтейнер!(V) e, бул все)
        {
                auto c = счёт;
                foreach (v; e)
                         удали (v, все);
                return c - счёт;
        }

        /***********************************************************************

                Время complexity: O(n
                 
        ***********************************************************************/

        final т_мера удали (V значение, бул все = нет)
        {       
                т_мера i = счёт;
                if (счёт)
                   {
                   auto p = дерево.findAttribute (значение, cmpElem);
                   while (p)
                         {
                         дерево = p.удали (дерево);
                         декремент (p);
                         if (!все || счёт is 0)
                             break;
                         p = дерево.findAttribute (значение, cmpElem);
                         }
                   }
                return i - счёт;
        }

        /***********************************************************************

                Время complexity: O(n)
                 
        ***********************************************************************/

        final т_мера замени (V старЭлемент, V новЭлемент, бул все = нет)
        {
                т_мера c;

                if (счёт)
                   {
                   auto p = дерево.findAttribute (старЭлемент, cmpElem);
                   while (p)
                         {
                         ++c;
                         измени;
                         p.attribute = новЭлемент;
                         if (!все)
                              break;
                         p = дерево.findAttribute (старЭлемент, cmpElem);
                         }
                   }
                return c;
        }

        /***********************************************************************

                Время complexity: O(лог n)

                Takes the значение associated with the least ключ.
                 
        ***********************************************************************/

        final бул возьми (ref V v)
        {
                if (счёт)
                   {
                   auto p = дерево.leftmost;
                   v = p.attribute;
                   дерево = p.удали (дерево);
                   декремент (p);
                   return да;
                   }
                return нет;
        }

        /***********************************************************************

                Время complexity: O(лог n)
                        
        ***********************************************************************/

        final бул возьми (K ключ, ref V значение)
        {
                if (счёт)
                   {
                   auto p = дерево.найди (ключ, cmp);
                   if (p)
                      {
                      значение = p.attribute;
                      дерево = p.удали (дерево);
                      декремент (p);
                      return да;
                      }
                   }
                return нет;
        }

        /***********************************************************************

                Время complexity: O(лог n)

                Returns да if inserted, нет where an existing ключ 
                есть_ли и was updated instead
                 
        ***********************************************************************/

        final бул добавь (K ключ, V значение)
        {
                return добавь_ (ключ, значение, да);
        }

        /***********************************************************************

                Время complexity: O(лог n)

                Returns да if inserted, нет where an existing ключ 
                есть_ли и was updated instead
                 
        ***********************************************************************/

        final бул opIndexAssign (V элемент, K ключ)
        {
                return добавь (ключ, элемент);
        }

        /***********************************************************************

                Operator retreival function

                Throws НетЭлементаИскл where ключ is missing

        ***********************************************************************/

        final V opIndex (K ключ)
        {
                auto p = opIn_r (ключ);
                if (p)
                    return *p;

                noSuchElement ("missing or не_годится ключ");
                assert (0);
        }

        /***********************************************************************

                Время complexity: O(лог n)
                        
        ***********************************************************************/

        final бул удалиКлюч (K ключ)
        {
                V значение;
                
                return возьми (ключ, значение);
        }

        /***********************************************************************

                Время complexity: O(лог n)
                 
        ***********************************************************************/

        final бул замениПару (K ключ, V старЭлемент, V новЭлемент)
        {
                if (счёт)
                   {
                   auto p = дерево.найди (ключ, старЭлемент, cmp);
                   if (p)
                      {
                      p.attribute = новЭлемент;
                      измени;
                      return да;
                      }
                   }
                return нет;
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
                foreach (k, v; this)
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

        final SortedMap проверь ()
        {
                assert(cmp !is пусто);
                assert(((счёт is 0) is (дерево is пусто)));
                assert((дерево is пусто || дерево.размер() is счёт));

                if (дерево)
                   {
                   дерево.проверьРеализацию;
                   auto t = дерево.leftmost;
                   K последний = K.init;

                   while (t)
                         {
                         auto v = t.значение;
                         assert((последний is K.init || cmp(последний, v) <= 0));
                         последний = v;
                         t = t.successor;
                         }
                   }
                return this;
        }

            
        /***********************************************************************

                 
        ***********************************************************************/

        private проц noSuchElement (ткст сооб)
        {
                throw new НетЭлементаИскл (сооб);
        }

        /***********************************************************************

                Время complexity: O(лог n)
                 
        ***********************************************************************/

        private т_мера экземпляры (V значение)
        {
                if (счёт is 0)
                     return 0;
                return дерево.countAttribute (значение, cmpElem);
        }

        /***********************************************************************

                Returns да where an элемент is добавьed, нет where an 
                existing ключ is найдено
                 
        ***********************************************************************/

        private final бул добавь_ (K ключ, V значение, бул проверьOccurrence)
        {
                if (дерево is пусто)
                   {
                   дерево = куча.размести.установи (ключ, значение);
                   инкремент;
                   }
                else
                   {
                   auto t = дерево;
                   for (;;)
                       {
                       цел diff = cmp (ключ, t.значение);
                       if (diff is 0 && проверьOccurrence)
                          {
                          if (t.attribute != значение)
                             {
                             t.attribute = значение;
                             измени;
                             }
                          return нет;
                          }
                       else
                          if (diff <= 0)
                             {
                             if (t.left)
                                 t = t.left;
                             else
                                {
                                дерево = t.insertLeft (куча.размести.установи(ключ, значение), дерево);
                                инкремент;
                                break;
                                }
                             }
                          else
                             {
                             if (t.right)
                                 t = t.right;
                             else
                                {
                                дерево = t.insertRight (куча.размести.установи(ключ, значение), дерево);
                                инкремент;
                                break;
                                }
                             }
                       }
                   }

                return да;
        }

        /***********************************************************************

                Время complexity: O(n)
                 
        ***********************************************************************/

        private SortedMap очисть (бул все)
        {
                измени;

                // собери each узел if we can't собери все at once
                if (куча.собери(все) is нет & счёт)                 
                   {
                   auto узел = дерево.leftmost;
                   while (узел)
                         {
                         auto следщ = узел.successor;
                         декремент (узел);
                         узел = следщ;
                         }
                   }

                счёт = 0;
                дерево = пусто;
                return this;
        }

        /***********************************************************************

                Время complexity: O(лог n)
                        
        ***********************************************************************/

        private проц удали (Реф узел)
        {
                дерево = узел.удали (дерево);
                декремент (узел);
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
                Извл (p.значение, p.attribute);
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

                The default ключ comparator

                @param fst первый аргумент
                @param snd секунда аргумент

                Возвращает: a negative число if fst is less than snd; a
                positive число if fst is greater than snd; else 0
                 
        ***********************************************************************/

        private static цел compareKey (ref K fst, ref K snd)
        {
                if (fst is snd)
                    return 0;

                return typeid(K).сравни (&fst, &snd);
        }


        /***********************************************************************

                The default значение comparator

                @param fst первый аргумент
                @param snd секунда аргумент

                Возвращает: a negative число if fst is less than snd; a
                positive число if fst is greater than snd; else 0
                 
        ***********************************************************************/

        private static цел compareElem(ref V fst, ref V snd)
        {
                if (fst is snd)
                    return 0;

                return typeid(V).сравни (&fst, &snd);
        }

        /***********************************************************************

                Обходчик with no filtering

        ***********************************************************************/

        private struct Обходчик
        {
                Реф function(Реф) bump;
                Реф               узел,
                                  приор;
                SortedMap         хозяин;
                т_мера            мутация;

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

                бул следщ (ref K k, ref V v)
                {
                        auto n = следщ (k);
                        return (n) ? v = *n, да : нет;
                }
                
                /***************************************************************

                        Return a pointer в_ the следщ значение, or пусто when
                        there are no further значения в_ traverse

                ***************************************************************/

                V* следщ (ref K k)
                {
                        V* r;

                        if (узел)
                           {
                           приор = узел;
                           k = узел.значение;
                           r = &узел.attribute;
                           узел = bump (узел);
                           }
                        return r;
                }

                /***************************************************************

                        Foreach support

                ***************************************************************/

                цел opApply (цел delegate(ref K ключ, ref V значение) дг)
                {
                        цел результат;

                        auto n = узел;
                        while (n)
                              {
                              приор = n;
                              auto следщ = bump (n);
                              if ((результат = дг(n.значение, n.attribute)) != 0)
                                   break;
                              n = следщ;
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
                           хозяин.удали (приор);

                           // ignore this change
                           ++мутация;
                           return да;
                           }

                        приор = пусто;
                        return нет;
                }

                /***************************************************************

                ***************************************************************/

                Обходчик реверс ()
                {
                        if (bump is &fore)
                            bump = &back;
                        else
                           bump = &fore;
                        return *this;
                }

                /***************************************************************

                ***************************************************************/

                private static Реф fore (Реф p)
                {
                        return p.successor;
                }

                /***************************************************************

                ***************************************************************/

                private static Реф back (Реф p)
                {
                        return p.predecessor;
                }
        }
}



/*******************************************************************************

*******************************************************************************/

debug (SortedMap)
{
        import io.Stdout;
        import thread;
        import time.StopWatch;
        import math.random.Kiss;

        проц main()
        {
                // usage examples ...
                auto карта = new SortedMap!(ткст, цел);
                карта.добавь ("foo", 1);
                карта.добавь ("bar", 2);
                карта.добавь ("wumpus", 3);

                // implicit генерный iteration
                foreach (ключ, значение; карта)
                         Стдвыв.форматнс ("{}:{}", ключ, значение);

                // явный iteration
                foreach (ключ, значение; карта.обходчик("foo", нет))
                         Стдвыв.форматнс ("{}:{}", ключ, значение);

                // генерный iteration with optional удали
                auto s = карта.обходчик;
                foreach (ключ, значение; s)
                        {} // s.удали;

                // incremental iteration, with optional удали
                ткст k;
                цел    v;
                auto обходчик = карта.обходчик;
                while (обходчик.следщ(k, v))
                      {} //обходчик.удали;
                
                // incremental iteration, with optional failfast
                auto it = карта.обходчик;
                while (it.действителен && it.следщ(k, v))
                      {}

                // удали specific элемент
                карта.удалиКлюч ("wumpus");

                // удали первый элемент ...
                while (карта.возьми(v))
                       Стдвыв.форматнс ("taking {}, {} left", v, карта.размер);
                
                
                // установи for benchmark, with a установи of целыйs. We
                // use a чанк разместитель, и presize the bucket[]
                auto тест = new SortedMap!(цел, цел, Контейнер.извлеки, Контейнер.Чанк);
                тест.кэш (1000, 500_000);
                const счёт = 500_000;
                Секундомер w;
                
                auto ключи = new цел[счёт];
                foreach (ref vv; ключи)
                         vv = Kiss.экземпляр.вЦел(цел.max);

                // benchmark добавьing
                w.старт;
                for (цел i=счёт; i--;)
                     тест.добавь(ключи[i], i);
                Стдвыв.форматнс ("{} добавьs: {}/s", тест.размер, тест.размер/w.stop);

                // benchmark reading
                w.старт;
                for (цел i=счёт; i--;)
                     тест.получи(ключи[i], v);
                Стдвыв.форматнс ("{} lookups: {}/s", тест.размер, тест.размер/w.stop);

                // benchmark добавьing without allocation overhead
                тест.очисть;
                w.старт;
                for (цел i=счёт; i--;)
                     тест.добавь(ключи[i], i);
                Стдвыв.форматнс ("{} добавьs (after очисть): {}/s", тест.размер, тест.размер/w.stop);

                // benchmark duplication
                w.старт;
                auto dup = тест.dup;
                Стдвыв.форматнс ("{} элемент dup: {}/s", dup.размер, dup.размер/w.stop);

                // benchmark iteration
                w.старт;
                foreach (ключ, значение; тест) {}
                Стдвыв.форматнс ("{} элемент iteration: {}/s", тест.размер, тест.размер/w.stop);

                тест.проверь;
        }
}
