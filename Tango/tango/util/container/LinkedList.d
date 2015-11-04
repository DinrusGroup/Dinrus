/*******************************************************************************

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

        List of singly-linked values

        ---
	Обходчик iterator ()
        цел opApply (цел delegate(ref V значение) дг)

        V голова ()
        V хвост ()
        V голова (V значение)
        V хвост (V значение)
        V removeHead ()
        V removeTail ()

        бул содержит (V значение)
        т_мера first (V значение, т_мера startingIndex = 0)
        т_мера последний (V значение, т_мера startingIndex = 0)

        LinkedList добавь (V значение)
        LinkedList приставь (V значение)
        т_мера приставь (IContainer!(V) e)
        LinkedList добавь (V значение)
        т_мера добавь (IContainer!(V) e)
        LinkedList добавьAt (т_мера индекс, V значение)
        т_мера добавьAt (т_мера индекс, IContainer!(V) e)

        V получи (т_мера индекс)
        бул take (ref V v)
        т_мера удали (V значение, бул все)
        бул removeAt (т_мера индекс)
        т_мера removeRange (т_мера fromIndex, т_мера toIndex)
        т_мера замени (V oldElement, V newElement, бул все)
        бул replaceAt (т_мера индекс, V значение)

        LinkedList сотри ()
        LinkedList сбрось ()

        LinkedList поднабор (т_мера из_, т_мера length = т_мера.max)
        LinkedList dup ()

        т_мера размер ()
        бул пуст_ли ()
        V[] toArray (V[] приёмн)
        LinkedList сортируй (Compare!(V) cmp)
        LinkedList check ()
        ---

*******************************************************************************/

class LinkedList (V, alias Reap = Container.reap, 
                     alias куча = Container.DefaultCollect) 
                     : IContainer!(V)
{
        // use this тип for Разместитель configuration
        private alias Slink!(V) Тип;
        
        private alias Тип*     Ref;
        private alias V*        VRef;

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

                Create a new пустой список

        ***********************************************************************/

        this ()
        {
                this (пусто, 0);
        }

        /***********************************************************************

                Special version of constructor needed by dup

        ***********************************************************************/

        protected this (Ref l, т_мера c)
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

                Return a generic iterator for contained elements
                
        ***********************************************************************/

        final Обходчик iterator ()
        {
                Обходчик i =void;
                i.mutation = mutation;
                i.node = список ? *(i.hook = &список) : пусто;
                i.prior = пусто;
                i.хозяин = this;
                return i;
        }

        /***********************************************************************

                Configure the assigned разместитель with the размер of each
                allocation block (число of nodes allocated at one время)
                and the число of nodes в_ pre-наполни the cache with.
                
                Время complexity: O(n)

        ***********************************************************************/

        final LinkedList cache (т_мера chunk, т_мера счёт=0)
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

                Build an independent копируй of the список.
                The elements themselves are not cloned

        ***********************************************************************/

        final LinkedList dup ()
        {
                return new LinkedList!(V, Reap, куча) (список ? список.копируй(&куча.размести) : пусто, счёт);
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
                return firstCell.значение;
        }

        /***********************************************************************

                 Время complexity: O(n)

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

        final т_мера first (V значение, т_мера startingIndex = 0)
        {
                if (список is пусто || startingIndex >= счёт)
                    return т_мера.max;

                if (startingIndex < 0)
                    startingIndex = 0;

                auto p = список.nth (startingIndex);
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
                 Returns т_мера.max if no element найдено.

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
                Ref newlist = пусто;

                if (length > 0)
                   {
                   auto p = cellAt (из_);
                   auto current = newlist = куча.размести.установи (p.значение, пусто);
         
                   for (auto i = 1; i < length; ++i)
                        if ((p = p.следщ) is пусто)
                             length = i;
                        else
                           {
                           current.прикрепи (куча.размести.установи (p.значение, пусто));
                           current = current.следщ;
                           }
                   }

                return new LinkedList (newlist, length);
        }

        /***********************************************************************

                 Время complexity: O(n)

        ***********************************************************************/

        final LinkedList сотри ()
        {
                return сотри (нет);
        }

        /***********************************************************************

                Reset the HashMap contents and optionally конфигурируй a new
                куча manager. We cannot guarantee в_ clean up reconfigured 
                allocators, so be sure в_ invoke сбрось() before discarding
                this class

                Время complexity: O(n)
                
        ***********************************************************************/

        final LinkedList сбрось ()
        {
                return сотри (да);
        }

        /***********************************************************************
        
                Takes the first значение on the список

                Время complexity: O(1)

        ***********************************************************************/

        final бул take (ref V v)
        {
                if (счёт)
                   {
                   v = голова;
                   removeHead;
                   return да;
                   }
                return нет;
        }

        /***********************************************************************

                Uses a merge-сортируй-based algorithm.

                Время complexity: O(n лог n)

        ***********************************************************************/

        final LinkedList сортируй (Compare!(V) cmp)
        {
                if (список)
                   {
                   список = Ref.сортируй (список, cmp);
                   mutate;
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

        final т_мера замени (V oldElement, V newElement, бул все = нет)
        {
                т_мера c;
                if (счёт && oldElement != newElement)
                   {
                   auto p = список.найди (oldElement);
                   while (p)
                         {
                         ++c;
                         mutate;
                         p.значение = newElement;
                         if (!все)
                              break;
                         p = p.найди (oldElement);
                         }
                   }
                return c;
        }

        /***********************************************************************

                 Время complexity: O(1)

        ***********************************************************************/

        final V голова (V значение)
        {
                auto cell = firstCell;
                auto v = cell.значение;
                cell.значение = значение;
                mutate;
                return v;
        }

        /***********************************************************************

                 Время complexity: O(1)

        ***********************************************************************/

        final V removeHead ()
        {
                auto p = firstCell;
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
                auto p = lastCell;
                auto v = p.значение;
                p.значение = значение;
                mutate;
                return v;
        }

        /***********************************************************************

                 Время complexity: O(n)

        ***********************************************************************/

        final V removeTail ()
        {
                if (firstCell.следщ is пусто)
                    return removeHead;

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

        final LinkedList добавьAt (т_мера индекс, V значение)
        {
                if (индекс is 0)
                    приставь (значение);
                else
                   {
                   cellAt(индекс - 1).прикрепи (куча.размести.установи(значение, пусто));
                   инкремент;
                   }
                return this;
        }

        /***********************************************************************

                 Время complexity: O(n)

        ***********************************************************************/

        final LinkedList removeAt (т_мера индекс)
        {
                if (индекс is 0)
                    removeHead;
                else
                   {
                   auto p = cellAt (индекс - 1);
                   auto t = p.следщ;
                   p.отторочьСледщ;
                   декремент (t);
                   }
                return this;
        }

        /***********************************************************************

                 Время complexity: O(n)

        ***********************************************************************/

        final LinkedList replaceAt (т_мера индекс, V значение)
        {
                cellAt(индекс).значение = значение;
                mutate;
                return this;
        }

        /***********************************************************************

                 Время complexity: O(число of elements in e)

        ***********************************************************************/

        final т_мера приставь (IContainer!(V) e)
        {
                auto c = счёт;
                splice_ (e, пусто, список);
                return счёт - c;
        }

        /***********************************************************************

                 Время complexity: O(n + число of elements in e)

        ***********************************************************************/

        final т_мера добавь (IContainer!(V) e)
        {
                auto c = счёт;
                if (список is пусто)
                    splice_ (e, пусто, пусто);
                else
                   splice_ (e, список.хвост, пусто);
                return счёт - c;
        }

        /***********************************************************************

                Время complexity: O(n + число of elements in e)

        ***********************************************************************/

        final т_мера добавьAt (т_мера индекс, IContainer!(V) e)
        {
                auto c = счёт;
                if (индекс is 0)
                    splice_ (e, пусто, список);
                else
                   {
                   auto p = cellAt (индекс - 1);
                   splice_ (e, p, p.следщ);
                   }
                return счёт - c;
        }

        /***********************************************************************

                Время complexity: O(n)

        ***********************************************************************/

        final т_мера removeRange (т_мера fromIndex, т_мера toIndex)
        {
                auto c = счёт;
                if (fromIndex <= toIndex)
                   {
                   if (fromIndex is 0)
                      {
                      auto p = firstCell;
                      for (т_мера i = fromIndex; i <= toIndex; ++i)
                           p = p.следщ;
                      список = p;
                      }
                   else
                      {
                      auto f = cellAt (fromIndex - 1);
                      auto p = f;
                      for (т_мера i = fromIndex; i <= toIndex; ++i)
                           p = p.следщ;
                      f.следщ = p.следщ;
                      }

                  счёт -= (toIndex - fromIndex + 1);
                  mutate;
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

        final LinkedList check ()
        {
                assert(((счёт is 0) is (список is пусто)));
                assert((список is пусто || список.счёт is размер));

                т_мера c = 0;
                for (Ref p = список; p; p = p.следщ)
                    {
                    assert(instances(p.значение) > 0);
                    assert(содержит(p.значение));
                    ++c;
                    }
                assert(c is счёт);
                return this;
        }

        /***********************************************************************

                 Время complexity: O(n)

        ***********************************************************************/

        private т_мера instances (V значение)
        {
                if (счёт is 0)
                    return 0;

                return список.счёт (значение);
        }

        /***********************************************************************

        ***********************************************************************/

        private Ref firstCell ()
        {
                checkIndex (0);
                return список;
        }

        /***********************************************************************

        ***********************************************************************/

        private Ref lastCell ()
        {
                checkIndex (0);
                return список.хвост;
        }

        /***********************************************************************

        ***********************************************************************/

        private Ref cellAt (т_мера индекс)
        {
                checkIndex (индекс);
                return список.nth (индекс);
        }

        /***********************************************************************

        ***********************************************************************/

        private проц checkIndex (т_мера индекс)
        {
                if (индекс >= счёт)
                    throw new Исключение ("out of range");
        }

        /***********************************************************************

                Splice elements of e between hd and tl. If hd 
                is пусто return new hd

                Returns the счёт of new elements добавьed

        ***********************************************************************/

        private проц splice_ (IContainer!(V) e, Ref hd, Ref tl)
        {
                Ref newlist = пусто;
                Ref current = пусто;

                foreach (v; e)
                        {
                        инкремент;

                        auto p = куча.размести.установи (v, пусто);
                        if (newlist is пусто)
                            newlist = p;
                        else
                           current.следщ = p;
                        current = p;
                        }

                if (current)
                   {
                   current.следщ = tl;

                   if (hd is пусто)
                       список = newlist;
                   else
                      hd.следщ = newlist;
                   }
        }

        /***********************************************************************

                 Время complexity: O(n)

        ***********************************************************************/

        private LinkedList сотри (бул все)
        {
                mutate;

                // collect each node if we can't collect все at once
                if (куча.collect(все) is нет && счёт)
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

                List iterator

        ***********************************************************************/

        private struct Обходчик
        {
                Ref             node;
                Ref*            hook,
                                prior;
                LinkedList      хозяин;
                т_мера          mutation;

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
                        if (node)
                           {
                           prior = hook;
                           r = &node.значение;
                           node = *(hook = &node.следщ);
                           }
                        return r;
                }

                /***************************************************************

                        Insert a new значение before the node about в_ be
                        iterated (or after the node that was just iterated).

                ***************************************************************/

                проц вставь(V значение)
                {
                        // вставь a node previous в_ the node that we are
                        // about в_ iterate.
                        *hook = хозяин.куча.размести.установи(значение, *hook);
                        node = *hook;
                        следщ();

                        // обнови the счёт of the хозяин, and ignore this
                        // change in the mutation.
                        хозяин.инкремент;
                        mutation++;
                }

                /***************************************************************

                        Insert a new значение before the значение that was just
                        iterated.

                        Returns да if the prior node existed and the
                        insertion worked.  Нет otherwise.

                ***************************************************************/

                бул insertPrior(V значение)
                {
                    if(prior)
                    {
                        // вставь a node previous в_ the node that we just
                        // iterated.
                        *prior = хозяин.куча.размести.установи(значение, *prior);
                        prior = &(*prior).следщ;

                        // обнови the счёт of the хозяин, and ignore this
                        // change in the mutation.
                        хозяин.инкремент;
                        mutation++;
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

                        auto n = node;
                        while (n)
                              {
                              prior = hook;
                              hook = &n.следщ;
                              if ((результат = дг(n.значение)) != 0)
                                   break;
                              n = *hook;
                              }
                        node = n;
                        return результат;
                }                               

                /***************************************************************

                        Удали значение at the current iterator location

                ***************************************************************/

                бул удали ()
                {
                        if (prior)
                           {
                           auto p = *prior;
                           *prior = p.следщ;
                           хозяин.декремент (p);
                           hook = prior;
                           prior = пусто;

                           // ignore this change
                           ++mutation;
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

                // implicit generic iteration
                foreach (значение; установи)
                         Стдвыв (значение).нс;

                // explicit generic iteration   
                foreach (значение; установи.iterator)
                         Стдвыв.форматнс ("{}", значение);

                // generic iteration with optional удали and вставь
                auto s = установи.iterator;
                foreach (значение; s)
                {
                         if (значение == "foo")
                             s.удали;
                         if (значение == "bar")
                             s.insertPrior("bloomper");
                         if (значение == "wumpus")
                             s.вставь("rumple");
                }

                установи.check();

                // incremental iteration, with optional удали
                ткст v;
                auto iterator = установи.iterator;
                while (iterator.следщ(v))
                      {} //iterator.удали;
                
                // incremental iteration, with optional failfast
                auto it = установи.iterator;
                while (it.valid && it.следщ(v))
                      {}

                // удали specific element
                установи.удали ("wumpus");

                // удали first element ...
                while (установи.take(v))
                       Стдвыв.форматнс ("taking {}, {} left", v, установи.размер);
                
                
                // установи for benchmark, with a установи of целыйs. We
                // use a chunk разместитель, and presize the bucket[]
                auto тест = new LinkedList!(цел, Container.reap, Container.Chunk);
                тест.cache (2000, 1_000_000);
                const счёт = 1_000_000;
                Секундомер w;

                // benchmark добавьing
                w.старт;
                for (цел i=счёт; i--;)
                     тест.приставь(i);
                Стдвыв.форматнс ("{} добавьs: {}/s", тест.размер, тест.размер/w.stop);

                // benchmark добавьing without allocation overhead
                тест.сотри;
                w.старт;
                for (цел i=счёт; i--;)
                     тест.приставь(i);
                Стдвыв.форматнс ("{} добавьs (after сотри): {}/s", тест.размер, тест.размер/w.stop);

                // benchmark duplication
                w.старт;
                auto dup = тест.dup;
                Стдвыв.форматнс ("{} element dup: {}/s", dup.размер, dup.размер/w.stop);

                // benchmark iteration
                w.старт;
                auto xx = тест.iterator;
                цел ii;
                while (xx.следщ()) {}
                Стдвыв.форматнс ("{} element iteration: {}/s", тест.размер, тест.размер/w.stop);

                // benchmark iteration
                w.старт;
                foreach (v; тест) {}
                Стдвыв.форматнс ("{} foreach iteration: {}/s", тест.размер, тест.размер/w.stop);


                // benchmark iteration
                w.старт;             
                foreach (ref iii; тест) {} 
                Стдвыв.форматнс ("{} pointer iteration: {}/s", тест.размер, тест.размер/w.stop);

                тест.check;
        }
}
                
