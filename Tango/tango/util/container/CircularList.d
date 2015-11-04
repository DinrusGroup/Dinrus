/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Apr 2008: Initial release

        authors:        Kris

        Since:          0.99.7

        Based upon Doug Lea's Java collection package

*******************************************************************************/

module util.container.CircularList;

private import util.container.Clink;

public  import  util.container.Container;

private import util.container.model.IContainer;

/*******************************************************************************

        Circular linked список

        ---
        Обходчик iterator ()
        цел opApply (цел delegate(ref V значение) дг)

        CircularList добавь (V element)
        CircularList добавьAt (т_мера индекс, V element)
        CircularList добавь (V element)
        CircularList приставь (V element)
        т_мера добавьAt (т_мера индекс, IContainer!(V) e)
        т_мера добавь (IContainer!(V) e)
        т_мера приставь (IContainer!(V) e)

        бул take (ref V v)
        бул содержит (V element)
        V получи (т_мера индекс)
        т_мера first (V element, т_мера startingIndex = 0)
        т_мера последний (V element, т_мера startingIndex = 0)

        V голова ()
        V хвост ()
        V голова (V element)
        V хвост (V element)
        V removeHead ()
        V removeTail ()

        бул removeAt (т_мера индекс)
        т_мера удали (V element, бул все)
        т_мера removeRange (т_мера fromIndex, т_мера toIndex)

        т_мера замени (V oldElement, V newElement, бул все)
        бул replaceAt (т_мера индекс, V element)

        т_мера размер ()
        бул пуст_ли ()
        V[] toArray (V[] приёмн)
        CircularList dup ()
        CircularList поднабор (т_мера из_, т_мера length)
        CircularList сотри ()
        CircularList сбрось ()
        CircularList check ()
        ---

*******************************************************************************/

class CircularList (V, alias Reap = Container.reap, 
                       alias куча = Container.DefaultCollect) 
                       : IContainer!(V)
{
        // use this тип for Разместитель configuration
        public alias Clink!(V)  Тип;
        
        private alias Тип      *Ref;

        private alias куча!(Тип) Alloc;

        // число of elements contained
        private т_мера          счёт;

        // configured куча manager
        private Alloc           куча;
        
        // mutation тэг updates on each change
        private т_мера          mutation;

        // голова of the список. Пусто if пустой
        private Ref             список;


        /***********************************************************************

                Make an пустой список

        ***********************************************************************/

        this ()
        {
                this (пусто, 0);
        }

        /***********************************************************************

                Make an configured список

        ***********************************************************************/

        protected this (Ref h, т_мера c)
        {
                список = h;
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

                Return a generic iterator for contained elements
                
        ***********************************************************************/

        final Обходчик iterator ()
        {
                // used в_ be Обходчик i =void, but that doesn't инициализуй
                // fields that are not инициализован here.
                Обходчик i;
                i.хозяин = this;
                i.mutation = mutation;
                i.cell = i.голова = список;
                i.счёт = счёт;
                i.индекс = 0;
                return i;
        }

        /***********************************************************************

                Configure the assigned разместитель with the размер of each
                allocation block (число of nodes allocated at one время)
                and the число of nodes в_ pre-наполни the cache with.
                
                Время complexity: O(n)

        ***********************************************************************/

        final CircularList cache (т_мера chunk, т_мера счёт=0)
        {
                куча.конфиг (chunk, счёт);
                return this;
        }

        /***********************************************************************


        ***********************************************************************/

        final цел opApply (цел delegate(ref V значение) дг)
        {
                return iterator.opApply (дг);
        }

        /***********************************************************************

                Return the число of elements contained
                
        ***********************************************************************/

        final т_мера размер ()
        {
                return счёт;
        }
        
        /***********************************************************************

                Make an independent копируй of the список. Elements themselves 
                are not cloned

        ***********************************************************************/

        final CircularList dup ()
        {
                return new CircularList!(V, Reap, куча) (список ? список.copyList(&куча.размести) : пусто, счёт);
        }

        /***********************************************************************

                Время complexity: O(n)

        ***********************************************************************/

        final бул содержит (V element)
        {
                if (список)
                    return список.найди (element) !is пусто;
                return нет;
        }

        /***********************************************************************

                Время complexity: O(1)

        ***********************************************************************/

        final V голова ()
        {
                return firstCell.значение;
        }

        /***********************************************************************

                Время complexity: O(1)

        ***********************************************************************/

        final V хвост ()
        {
                return lastCell.значение;
        }

        /***********************************************************************

                Время complexity: O(n)

        ***********************************************************************/

        final V получи (т_мера индекс)
        {
                return cellAt(индекс).значение;
        }

        /***********************************************************************

                Время complexity: O(n)
                Returns т_мера.max if no element найдено.

        ***********************************************************************/

        final т_мера first (V element, т_мера startingIndex = 0)
        {
                if (startingIndex < 0)
                    startingIndex = 0;

                auto p = список;
                if (p is пусто)
                    return т_мера.max;

                for (т_мера i = 0; да; ++i)
                    {
                    if (i >= startingIndex && element == p.значение)
                        return i;

                    p = p.следщ;
                    if (p is список)
                        break;
                    }
                return т_мера.max;
        }

        /***********************************************************************
                
                Время complexity: O(n)
                Returns т_мера.max if no element найдено.

        ***********************************************************************/

        final т_мера последний (V element, т_мера startingIndex = 0)
        {
                if (счёт is 0)
                    return т_мера.max;

                if (startingIndex >= счёт)
                    startingIndex = счёт - 1;

                if (startingIndex < 0)
                    startingIndex = 0;

                auto p = cellAt (startingIndex);
                т_мера i = startingIndex;
                for (;;)
                    {
                    if (element == p.значение)
                        return i;
                    else
                       if (p is список)
                           break;
                       else
                          {
                          p = p.prev;
                          --i;
                          }
                    }
                return т_мера.max;
        }

        /***********************************************************************

                Время complexity: O(length)

        ***********************************************************************/

        final CircularList поднабор (т_мера из_, т_мера length)
        {
                Ref newlist = пусто;

                if (length > 0)
                   {
                   checkIndex (из_);
                   auto p = cellAt (из_);
                   auto current = newlist = куча.размести.установи (p.значение);

                   for (т_мера i = 1; i < length; ++i)
                       {
                       p = p.следщ;
                       if (p is пусто)
                           length = i;
                       else
                          {
                          current.добавьNext (p.значение, &куча.размести);
                          current = current.следщ;
                          }
                       }
                   }

                return new CircularList (newlist, length);
        }

        /***********************************************************************

                 Время complexity: O(1)

        ***********************************************************************/

        final CircularList сотри ()
        {
                return сотри (нет);
        }

        /***********************************************************************

                Reset the HashMap contents and optionally конфигурируй a new
                куча manager. This releases ещё память than сотри() does

                Время complexity: O(n)
                
        ***********************************************************************/

        final CircularList сбрось ()
        {
                return сотри (да);
        }

        /***********************************************************************

                Время complexity: O(n)

                Takes the последний element on the список

        ***********************************************************************/

        final бул take (ref V v)
        {
                if (счёт)
                   {
                   v = хвост;
                   removeTail ();
                   return да;
                   }
                return нет;
        }

        /***********************************************************************

                Время complexity: O(1)

        ***********************************************************************/

        final CircularList приставь (V element)
        {
                if (список is пусто)
                    список = куча.размести.установи (element);
                else
                   список = список.добавьPrev (element, &куча.размести);
                инкремент;
                return this;
        }

        /***********************************************************************

                Время complexity: O(1)

        ***********************************************************************/

        final V голова (V element)
        {
                auto p = firstCell;
                auto v = p.значение;
                p.значение = element;
                mutate;
                return v;
        }

        /***********************************************************************

                Время complexity: O(1)

        ***********************************************************************/

        final V removeHead ()
        {
                auto p = firstCell;
                if (p.singleton)
                   список = пусто;
                else
                   {
                   auto n = p.следщ;
                   p.unlink;
                   список = n;
                   }

                auto v = p.значение;
                декремент (p);
                return v;
        }

       /***********************************************************************

                Время complexity: O(1)

        ***********************************************************************/

        final CircularList добавь (V element)
        {
                return добавь (element);
        }

       /***********************************************************************

                Время complexity: O(1)

        ***********************************************************************/

        final CircularList добавь (V element)
        {
                if (список is пусто)
                    приставь (element);
                else
                   {
                   список.prev.добавьNext (element, &куча.размести);
                   инкремент;
                   }
                return this;
        }

        /***********************************************************************

                Время complexity: O(1)

        ***********************************************************************/

        final V хвост (V element)
        {
                auto p = lastCell;
                auto v = p.значение;
                p.значение = element;
                mutate;
                return v;
        }

        /***********************************************************************

                Время complexity: O(1)

        ***********************************************************************/

        final V removeTail ()
        {
                auto p = lastCell;
                if (p is список)
                    список = пусто;
                else
                   p.unlink;

                auto v = p.значение;
                декремент (p);
                return v;
        }

        /***********************************************************************
                
                Время complexity: O(n)

        ***********************************************************************/

        final CircularList добавьAt (т_мера индекс, V element)
        {
                if (индекс is 0)
                    приставь (element);
                else
                   {
                   cellAt(индекс - 1).добавьNext(element, &куча.размести);
                   инкремент;
                   }
                return this;
        }

        /***********************************************************************
                
                Время complexity: O(n)

        ***********************************************************************/

        final CircularList replaceAt (т_мера индекс, V element)
        {
                cellAt(индекс).значение = element;
                mutate;
                return this;
        }

        /***********************************************************************

                Время complexity: O(n)

        ***********************************************************************/

        final CircularList removeAt (т_мера индекс)
        {
                if (индекс is 0)
                    removeHead;
                else
                   {
                   auto p = cellAt(индекс);
                   p.unlink;
                   декремент (p);
                   }
                return this;
        }

        /***********************************************************************

                Время complexity: O(n)

        ***********************************************************************/

        final т_мера удали (V element, бул все)
        {
                auto c = счёт;
                if (список)
                   {
                   auto p = список;
                   for (;;)
                       {
                       auto n = p.следщ;
                       if (element == p.значение)
                          {
                          p.unlink;
                          декремент (p);
                          if (p is список)
                             {
                             if (p is n)
                                {
                                список = пусто;
                                break;
                                }
                             else
                                список = n;
                             }
   
                          if (! все)
                                break;
                          else
                             p = n;
                          }
                       else
                          if (n is список)
                              break;
                          else
                             p = n;
                       }
                   }
                return c - счёт;
        }

        /***********************************************************************

                Время complexity: O(n)

        ***********************************************************************/

        final т_мера замени (V oldElement, V newElement, бул все)
        {
                т_мера c;
                if (список)
                   {
                   auto p = список;
                   do {
                      if (oldElement == p.значение)
                         {
                         ++c;
                         mutate;
                         p.значение = newElement;
                         if (! все)
                               break;
                         }
                      p = p.следщ;
                      } while (p !is список);
                   }
                return c;
        }

        /***********************************************************************

                Время complexity: O(число of elements in e)

        ***********************************************************************/

        final т_мера приставь (IContainer!(V) e)
        {
                Ref hd = пусто;
                Ref current = пусто;
                auto c = счёт;

                foreach (element; e)
                        {
                        инкремент;

                        if (hd is пусто)
                           {
                           hd = куча.размести.установи(element);
                           current = hd;
                           }
                        else
                           {
                           current.добавьNext (element, &куча.размести);
                           current = current.следщ;
                           }
                      }

                if (список is пусто)
                    список = hd;
                else
                   if (hd)
                      {
                      auto tl = список.prev;
                      current.следщ = список;
                      список.prev = current;
                      tl.следщ = hd;
                      hd.prev = tl;
                      список = hd;
                      }
                return счёт - c;
        }

        /***********************************************************************
                
                Время complexity: O(число of elements in e)

        ***********************************************************************/

        final т_мера добавь (IContainer!(V) e)
        {
                auto c = счёт;
                if (список is пусто)
                    приставь (e);
                else
                   {
                   auto current = список.prev;
                   foreach (element; e)
                           {
                           инкремент;
                           current.добавьNext (element, &куча.размести);
                           current = current.следщ;
                           }
                   }
                return счёт - c;
        }

        /***********************************************************************

                Время complexity: O(размер() + число of elements in e)

        ***********************************************************************/

        final т_мера добавьAt (т_мера индекс, IContainer!(V) e)
        {
                auto c = счёт;
                if (список is пусто || индекс is 0)
                    приставь (e);
                else
                   {
                   auto current = cellAt (индекс - 1);
                   foreach (element; e)
                           {
                           инкремент;
                           current.добавьNext (element, &куча.размести);
                           current = current.следщ;
                           }
                   }
                return счёт - c;
        }

        /***********************************************************************

                Время complexity: O(n)

        ***********************************************************************/

        final т_мера removeRange (т_мера fromIndex, т_мера toIndex)
        {
                auto p = cellAt (fromIndex);
                auto последний = список.prev;
                auto c = счёт;
                for (т_мера i = fromIndex; i <= toIndex; ++i)
                    {
                    auto n = p.следщ;
                    p.unlink;
                    декремент (p);
                    if (p is список)
                       {
                       if (p is последний)
                          {
                          список = пусто;
                          break;
                          }
                       else
                          список = n;
                       }
                    p = n;
                    }
                return c - счёт;
        }

        /***********************************************************************

                Copy and return the contained установи of values in an Массив, 
                using the optional приёмн as a реципиент (which is resized 
                as necessary).

                Returns a срез of приёмн representing the container values.
                
                Время complexity: O(n)
                
        ***********************************************************************/

        final V[] toArray (V[] приёмн = пусто)
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

        final CircularList check()
        {
                assert(((счёт is 0) is (список is пусто)));
                assert((список is пусто || список.размер is счёт));

                if (список)
                   {
                   т_мера c = 0;
                   auto p = список;
                   do {
                      assert(p.prev.следщ is p);
                      assert(p.следщ.prev is p);
                      assert(instances(p.значение) > 0);
                      assert(содержит(p.значение));
                      p = p.следщ;
                      ++c;
                      } while (p !is список);
                   assert(c is размер);
                   }
                return this;
        }

        /***********************************************************************

                Время complexity: O(n)

        ***********************************************************************/

        private т_мера instances (V element)
        {
                if (список)
                    return список.счёт (element);
                return 0;
        }

        /***********************************************************************


        ***********************************************************************/

        private проц checkIndex (т_мера i)
        {
                if (i >= счёт)
                    throw new Исключение ("out of range");
        }

        /***********************************************************************

                return the first cell, or throw исключение if пустой

        ***********************************************************************/

        private Ref firstCell ()
        {
                checkIndex (0);
                return список;
        }

        /***********************************************************************

                return the последний cell, or throw исключение if пустой

        ***********************************************************************/

        private Ref lastCell ()
        {
                checkIndex (0);
                return список.prev;
        }

        /***********************************************************************

                 return the индекс'th cell, or throw исключение if bad индекс

        ***********************************************************************/

        private Ref cellAt (т_мера индекс)
        {
                checkIndex (индекс);
                return список.nth (индекс);
        }

        /***********************************************************************

                 Время complexity: O(1)

        ***********************************************************************/

        private CircularList сотри (бул все)
        {
                mutate;

                // collect each node if we can't collect все at once
                if (куча.collect(все) is нет && счёт)
                   {
                   auto p = список;
                   do {
                      auto n = p.следщ;
                      декремент (p);
                      p = n;
                      } while (p != список);
                   }
        
                список = пусто;
                счёт = 0;
                return this;
        }

        /***********************************************************************

                new element was добавьed
                
        ***********************************************************************/

        private проц инкремент ()
        {
                ++mutation;
                ++счёт;
        }
        
        /***********************************************************************

                element was removed
                
        ***********************************************************************/

        private проц декремент (Ref p)
        {
                Reap (p.значение);
                куча.collect (p);
                ++mutation;
                --счёт;
        }
        
        /***********************************************************************

                установи was изменён
                
        ***********************************************************************/

        private проц mutate ()
        {
                ++mutation;
        }

        /***********************************************************************

                Обходчик with no filtering

        ***********************************************************************/

        private struct Обходчик
        {
                бул              rev;
                Ref               cell,
                                  голова,
                                  prior;
                CircularList      хозяин;
                т_мера            индекс,
                                  счёт;
                т_мера            mutation;

                /***************************************************************

                        Dопр the container change underneath us?

                ***************************************************************/

                бул valid ()
                {
                        return хозяин.mutation is mutation;
                }               

                /***************************************************************

                        Accesses the следщ значение, and returns нет when
                        there are no further values в_ traverse

                ***************************************************************/

                бул следщ (ref V v)
                {
                        auto n = следщ;
                        return (n) ? v = *n, да : нет;
                }
                
                /***************************************************************

                        Return a pointer в_ the следщ значение, or пусто when
                        there are no further values в_ traverse

                ***************************************************************/

                V* следщ ()
                {
                        V* r;

                        if (индекс < счёт)
                           {
                           ++индекс;
                           prior = cell;
                           r = &cell.значение;
                           cell = (rev ? cell.prev : cell.следщ);
                           }
                        else
                           cell = пусто;
                        return r;
                }

                /***************************************************************

                        Foreach support

                ***************************************************************/

                цел opApply (цел delegate(ref V значение) дг)
                {
                        цел результат;
                        auto c = cell;

                        while (индекс < счёт)
                              {
                              ++индекс;
                              prior = c;
                              c = (rev ? c.prev : c.следщ);
                              if ((результат = дг(prior.значение)) != 0)
                                   break;
                              }
                        cell = пусто;
                        return результат;
                }                               

                /***************************************************************

                        Удали значение that was just iterated.

                ***************************************************************/

                бул удали ()
                {
                        if (prior)
                           {
                           auto следщ = (rev ? prior.prev : prior.следщ);
                           if (prior is голова)
                              {
                              if (prior is следщ)
                                  хозяин.список = пусто;
                              else
                                 голова = хозяин.список = следщ;
                              }

                           prior.unlink;
                           хозяин.декремент (prior);
                           prior = пусто;

                           --счёт;
                           // ignore this change
                           ++mutation;
                           return да;
                           }
                        return нет;
                }

                /***************************************************************

                        Insert a new значение before the node about в_ be
                        iterated (or after the node that was just iterated).

                        Возвращает: a копируй of this iterator for chaining.

                ***************************************************************/

                Обходчик вставь (V значение)
                {
                    // Note: this needs some attention, not sure как
                    // в_ укз when iterator is in реверс.
                    if (cell is пусто)
                        prior.добавьNext (значение, &хозяин.куча.размести);
                    else
                       cell.добавьPrev (значение, &хозяин.куча.размести);
                    хозяин.инкремент;

                    ++счёт;
                    // ignore this change
                    ++mutation;
                    return *this;
                }

                /***************************************************************
        
                        FlИП the direction of следщ() and opApply(), and 
                        сбрось the termination point such that we can do
                        другой full traversal.

                ***************************************************************/

                Обходчик реверс ()
                {
                        rev ^= да;
                        следщ;
                        индекс = 0;
                        return *this;
                }
        }
}

/*******************************************************************************

*******************************************************************************/

debug (UnitTest)
{
    unittest
    {
        auto список = new CircularList!(цел);
        список.добавь(1);
        список.добавь(2);
        список.добавь(3);

        цел i = 1;
        foreach(v; список)
        {
            assert(v == i);
            i++;
        }

        auto итер = список.iterator;
        итер.следщ();
        итер.удали();                          // delete the first item

        i = 2;
        foreach(v; список)
        {
            assert(v == i);
            i++;
        }

        // тест вставь functionality
        итер = список.iterator;
        итер.следщ;
        итер.вставь(4);

        цел[] compareto = [2, 4, 3];
        i = 0;
        foreach(v; список)
        {
            assert(v == compareto[i++]);
        }
    }
}

/*******************************************************************************

*******************************************************************************/

debug (CircularList)
{
        import io.Stdout;
        import thread;
        import time.StopWatch;

        проц main()
        {
                // usage examples ...
                auto список = new CircularList!(ткст);
                foreach (значение; список)
                         Стдвыв (значение).нс;

                список.добавь ("foo");
                список.добавь ("bar");
                список.добавь ("wumpus");

                // implicit generic iteration
                foreach (значение; список)
                         Стдвыв (значение).нс;

                // explicit generic iteration   
                foreach (значение; список.iterator.реверс)
                         Стдвыв.форматнс ("> {}", значение);

                // generic iteration with optional удали
                auto s = список.iterator;
                foreach (значение; s)
                         {} //s.удали;

                // incremental iteration, with optional удали
                ткст v;
                auto iterator = список.iterator;
                while (iterator.следщ(v))
                       {}//iterator.удали;
                
                // incremental iteration, with optional failfast
                auto it = список.iterator;
                while (it.valid && it.следщ(v))
                      {}

                // удали specific element
                список.удали ("wumpus", нет);

                // удали first element ...
                while (список.take(v))
                       Стдвыв.форматнс ("taking {}, {} left", v, список.размер);
                
                
                // установи for benchmark, with a установи of целыйs. We
                // use a chunk разместитель, and presize the bucket[]
                auto тест = new CircularList!(бцел, Container.reap, Container.Chunk);
                тест.cache (1000, 1_000_000);
                const счёт = 1_000_000;
                Секундомер w;

                // benchmark добавьing
                w.старт;
                for (бцел i=счёт; i--;)
                     тест.добавь(i);
                Стдвыв.форматнс ("{} добавьs: {}/s", тест.размер, тест.размер/w.stop);

                // benchmark добавьing without allocation overhead
                тест.сотри;
                w.старт;
                for (бцел i=счёт; i--;)
                     тест.добавь(i);
                Стдвыв.форматнс ("{} добавьs (after сотри): {}/s", тест.размер, тест.размер/w.stop);

                // benchmark duplication
                w.старт;
                auto dup = тест.dup;
                Стдвыв.форматнс ("{} element dup: {}/s", dup.размер, dup.размер/w.stop);

                // benchmark iteration
                w.старт;
                foreach (значение; тест) {}
                Стдвыв.форматнс ("{} element iteration: {}/s", тест.размер, тест.размер/w.stop);

                тест.check;
        }
}
