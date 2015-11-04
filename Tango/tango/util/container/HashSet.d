/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Apr 2008: Initial release

        authors:        Kris

        Since:          0.99.7

        Based upon Doug Lea's Java collection package

*******************************************************************************/

module util.container.HashSet;

private import  util.container.Slink;

public  import  util.container.Container;

private import util.container.model.IContainer;

/*******************************************************************************

        Hash table implementation of a Набор

        ---
        Обходчик iterator ()
        цел opApply (цел delegate(ref V значение) дг)

        бул добавь (V element)
        бул содержит (V element)
        бул take (ref V element)
        бул удали (V element)
        т_мера удали (IContainer!(V) e)
        бул замени (V oldElement, V newElement)

        т_мера размер ()
        бул пуст_ли ()
        V[] toArray (V[] приёмн)
        HashSet dup ()
        HashSet сотри ()
        HashSet сбрось ()

        т_мера buckets ()
        проц buckets (т_мера cap)
        плав threshold ()
        проц threshold (плав desired)
        ---

*******************************************************************************/

class HashSet (V, alias Hash = Container.hash, 
                  alias Reap = Container.reap, 
                  alias куча = Container.DefaultCollect) 
                  : IContainer!(V)
{
        // use this тип for Разместитель configuration
        public alias Slink!(V)  Тип;
        
        private alias Тип      *Ref;

        private alias куча!(Тип) Alloc;

        // Each table Запись is a список - пусто if no table allocated
        private Ref             table[];
        
        // число of elements contained
        private т_мера          счёт;

        // the threshold загрузи factor
        private плав           loadFactor;

        // configured куча manager
        private Alloc           куча;
        
        // mutation тэг updates on each change
        private т_мера            mutation;

        /***********************************************************************

                Construct a HashSet экземпляр

        ***********************************************************************/

        this (плав f = Container.defaultLoadFactor)
        {
                loadFactor = f;
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
                i.table = table;
                i.хозяин = this;
                i.cell = пусто;
                i.row = 0;
                return i;
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

                Добавь a new element в_ the установи. Does not добавь if there is an
                equivalent already present. Returns да where an element
                is добавьed, нет where it already есть_ли
                
                Время complexity: O(1) average; O(n) worst.
                
        ***********************************************************************/

        final бул добавь (V element)
        {
                if (table is пусто)
                    resize (Container.defaultInitialBuckets);

                auto h = Hash  (element, table.length);
                auto hd = table[h];

                if (hd && hd.найди (element))
                    return нет;

                table[h] = размести.установи (element, hd);
                инкремент;

                // only check if bin was Неукmpty                    
                if (hd)
                    checkLoad; 
                return да;
        }

        /***********************************************************************

                Does this установи contain the given element?
        
                Время complexity: O(1) average; O(n) worst
                
        ***********************************************************************/

        final бул содержит (V element)
        {
                if (счёт)
                   {
                   auto p = table[Hash (element, table.length)];
                   if (p && p.найди (element))
                       return да;
                   }
                return нет;
        }

        /***********************************************************************

                Make an independent копируй of the container. Does not clone
                elements
                
                Время complexity: O(n)
                
        ***********************************************************************/

        final HashSet dup ()
        {
                auto clone = new HashSet!(V, Hash, Reap, куча) (loadFactor);
                
                if (счёт)
                   {
                   clone.buckets (buckets);

                   foreach (значение; iterator)
                            clone.добавь (значение);
                   }
                return clone;
        }

        /***********************************************************************

                Удали the provопрed element. Returns да if найдено, нет
                otherwise
                
                Время complexity: O(1) average; O(n) worst

        ***********************************************************************/

        final т_мера удали (V element, бул все)
        {
                return удали(element) ? 1 : 0;
        }

        /***********************************************************************

                Удали the provопрed element. Returns да if найдено, нет
                otherwise
                
                Время complexity: O(1) average; O(n) worst

        ***********************************************************************/

        final бул удали (V element)
        {
                if (счёт)
                   {
                   auto h = Hash (element, table.length);
                   auto hd = table[h];
                   auto trail = hd;
                   auto p = hd;

                   while (p)
                         {
                         auto n = p.следщ;
                         if (element == p.значение)
                            {
                            декремент (p);
                            if (p is table[h])
                               {
                               table[h] = n;
                               trail = n;
                               }
                            else
                               trail.следщ = n;
                            return да;
                            } 
                         else
                            {
                            trail = p;
                            p = n;
                            }
                         }
                   }
                return нет;
        }

        /***********************************************************************

                Замени the first экземпляр of oldElement with newElement.
                Returns да if oldElement was найдено and replaced, нет
                otherwise.
                
        ***********************************************************************/

        final т_мера замени (V oldElement, V newElement, бул все)
        {
                return замени (oldElement, newElement) ? 1 : 0;
        }

        /***********************************************************************

                Замени the first экземпляр of oldElement with newElement.
                Returns да if oldElement was найдено and replaced, нет
                otherwise.
                
        ***********************************************************************/

        final бул замени (V oldElement, V newElement)
        {

                if (счёт && oldElement != newElement)
                   if (содержит (oldElement))
                      {
                      удали (oldElement);
                      добавь (newElement);
                      return да;
                      }
                return нет;
        }

        /***********************************************************************

                Удали and expose the first element. Returns нет when no
                ещё elements are contained
        
                Время complexity: O(n)

        ***********************************************************************/

        final бул take (ref V element)
        {
                if (счёт)
                    foreach (ref список; table)
                             if (список)
                                {
                                auto p = список;
                                element = p.значение;
                                список = p.следщ;
                                декремент (p);
                                return да;
                                }
                return нет;
        }

        /***********************************************************************

        ************************************************************************/

        public проц добавь (IContainer!(V) e)
        {
                foreach (значение; e)
                         добавь (значение);
        }

        /***********************************************************************

        ************************************************************************/

        public т_мера удали (IContainer!(V) e)
        {
                т_мера c;
                foreach (значение; e)
                         if (удали (значение))
                             ++c;
                return c;
        }

        /***********************************************************************

                Clears the HashMap contents. Various атрибуты are
                retained, such as the internal table itself. Invoke
                сбрось() в_ drop everything.

                Время complexity: O(n)
                
        ***********************************************************************/

        final HashSet сотри ()
        {
                return сотри (нет);
        }

        /***********************************************************************

                Reset the HashSet contents and optionally конфигурируй a new
                куча manager. This releases ещё память than сотри() does

                Время complexity: O(1)
                
        ***********************************************************************/

        final HashSet сбрось ()
        {
                сотри (да);
                куча.collect (table);
                table = пусто;
                return this;
        }

        /***********************************************************************

                Return the число of buckets

                Время complexity: O(1)

        ***********************************************************************/

        final т_мера buckets ()
        {
                return table ? table.length : 0;
        }

        /***********************************************************************

                Набор the число of buckets and resize as required
                
                Время complexity: O(n)

        ***********************************************************************/

        final HashSet buckets (т_мера cap)
        {
                if (cap < Container.defaultInitialBuckets)
                    cap = Container.defaultInitialBuckets;

                if (cap !is buckets)
                    resize (cap);
                return this;
        }

        /***********************************************************************

                Return the resize threshold
                
                Время complexity: O(1)

        ***********************************************************************/

        final плав threshold ()
        {
                return loadFactor;
        }

        /***********************************************************************

                Набор the resize threshold, and resize as required
                
                Время complexity: O(n)
                
        ***********************************************************************/

        final проц threshold (плав desired)
        {
                assert (desired > 0.0);
                loadFactor = desired;
                if (table)
                    checkLoad;
        }

        /***********************************************************************

                Configure the assigned разместитель with the размер of each
                allocation block (число of nodes allocated at one время)
                and the число of nodes в_ pre-наполни the cache with.
                
                Время complexity: O(n)

        ***********************************************************************/

        final HashSet cache (т_мера chunk, т_мера счёт=0)
        {
                куча.конфиг (chunk, счёт);
                return this;
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

                Sanity check
                 
        ***********************************************************************/

        final HashSet check()
        {
                assert(!(table is пусто && счёт !is 0));
                assert((table is пусто || table.length > 0));
                assert(loadFactor > 0.0f);

                if (table)
                   {
                   т_мера c = 0;
                   for (т_мера i = 0; i < table.length; ++i)
                       {
                       for (auto p = table[i]; p; p = p.следщ)
                           {
                           ++c;
                           assert(содержит(p.значение));
                           assert(Hash (p.значение, table.length) is i);
                           }
                       }
                   assert(c is счёт);
                   }
                return this;
        }

        /***********************************************************************

                Размести a node экземпляр. This is used as the default разместитель
                 
        ***********************************************************************/

        private Ref размести ()
        {
                return куча.размести;
        }
        
        /***********************************************************************

                 Check в_ see if we are past загрузи factor threshold. If so,
                 resize so that we are at half of the desired threshold.
                 
        ***********************************************************************/

        private проц checkLoad ()
        {
                плав fc = счёт;
                плав ft = table.length;
                if (fc / ft > loadFactor)
                    resize (2 * cast(т_мера)(fc / loadFactor) + 1);
        }

        /***********************************************************************

                resize table в_ new ёмкость, rehashing все elements
                
        ***********************************************************************/

        private проц resize (т_мера newCap)
        {
                //Стдвыв.форматнс ("resize {}", newCap);
                auto newtab = куча.размести (newCap);
                mutate;

                foreach (bucket; table)
                         while (bucket)
                               {
                               auto n = bucket.следщ;
                               auto h = Hash (bucket.значение, newCap);
                               bucket.следщ = newtab[h];
                               newtab[h] = bucket;
                               bucket = n;
                               }

                // release the prior table and присвой new one
                куча.collect (table);
                table = newtab;
        }

        /***********************************************************************

                Удали the indicated node. We need в_ traverse buckets
                for this, since we're singly-linked only. Better в_ save
                the per-node память than в_ gain a little on each удали

                Used by iterators only
                 
        ***********************************************************************/

        private бул удали (Ref node, т_мера row)
        {
                auto hd = table[row];
                auto trail = hd;
                auto p = hd;

                while (p)
                      {
                      auto n = p.следщ;
                      if (p is node)
                         {
                         декремент (p);
                         if (p is hd)
                             table[row] = n;
                         else
                            trail.следщ = n;
                         return да;
                         } 
                      else
                         {
                         trail = p;
                         p = n;
                         }
                      }
                return нет;
        }

        /***********************************************************************

                Clears the HashSet contents. Various атрибуты are
                retained, such as the internal table itself. Invoke
                сбрось() в_ drop everything.

                Время complexity: O(n)
                
        ***********************************************************************/

        private HashSet сотри (бул все)
        {
                mutate;

                // collect each node if we can't collect все at once
                if (куча.collect(все) is нет)
                    foreach (ref v; table)
                             while (v)
                                   {
                                   auto n = v.следщ;
                                   декремент (v);
                                   v = n;
                                   }

                // retain table, but удали bucket chains
                foreach (ref v; table)
                         v = пусто;

                счёт = 0;
                return this;
        }

        /***********************************************************************

                new element was добавьed
                
        ***********************************************************************/

        private проц инкремент()
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

        private проц mutate()
        {
                ++mutation;
        }

        /***********************************************************************

                Обходчик with no filtering

        ***********************************************************************/

        private struct Обходчик
        {
                т_мера  row;
                Ref     cell,
                        prior;
                Ref[]   table;
                HashSet хозяин;
                т_мера  mutation;

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
                        while (cell is пусто)
                               if (row < table.length)
                                   cell = table [row++];
                               else
                                  return пусто;
  
                        prior = cell;
                        cell = cell.следщ;
                        return &prior.значение;
                }

                /***************************************************************

                        Foreach support

                ***************************************************************/

                цел opApply (цел delegate(ref V значение) дг)
                {
                        цел результат;

                        auto c = cell;
                        loop: while (да)
                              {
                              while (c is пусто)
                                     if (row < table.length)
                                         c = table [row++];
                                     else
                                        break loop;
  
                              prior = c;
                              c = c.следщ;
                              if ((результат = дг(prior.значение)) != 0)
                                   break loop;
                              }

                        cell = c;
                        return результат;
                }                               

                /***************************************************************

                        Удали значение at the current iterator location

                ***************************************************************/

                бул удали ()
                {
                        if (prior)
                            if (хозяин.удали (prior, row-1))
                               {
                               // ignore this change
                               ++mutation;
                               return да;
                               }

                        prior = пусто;
                        return нет;
                }
        }
}



/*******************************************************************************

*******************************************************************************/

debug (HashSet)
{
        import io.Stdout;
        import thread;
        import time.StopWatch;
       
        проц main()
        {
                // usage examples ...
                auto установи = new HashSet!(ткст);
                установи.добавь ("foo");
                установи.добавь ("bar");
                установи.добавь ("wumpus");

                // implicit generic iteration
                foreach (значение; установи)
                         Стдвыв (значение).нс;

                // explicit generic iteration
                foreach (значение; установи.iterator)
                         Стдвыв (значение).нс;

                // generic iteration with optional удали
                auto s = установи.iterator;
                foreach (значение; s)
                        {} // s.удали;

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
                auto тест = new HashSet!(цел, Container.hash, Container.reap, Container.Chunk);
                тест.cache (1000, 1_000_000);
                тест.buckets = 1_500_000;
                const счёт = 1_000_000;
                Секундомер w;

                // benchmark добавьing
                w.старт;
                for (цел i=счёт; i--;)
                     тест.добавь(i);
                Стдвыв.форматнс ("{} добавьs: {}/s", тест.размер, тест.размер/w.stop);

                // benchmark reading
                w.старт;
                for (цел i=счёт; i--;)
                     тест.содержит(i);
                Стдвыв.форматнс ("{} lookups: {}/s", тест.размер, тест.размер/w.stop);

                // benchmark добавьing without allocation overhead
                тест.сотри;
                w.старт;
                for (цел i=счёт; i--;)
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
