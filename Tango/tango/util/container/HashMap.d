/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Apr 2008: Initial release

        authors:        Kris

        Since:          0.99.7

        Based upon Doug Lea's Java collection package

*******************************************************************************/

module util.container.HashMap;

private import util.container.Slink;

public  import util.container.Container;

private import util.container.model.IContainer;

private import exception : NoSuchElementException;

/*******************************************************************************

        Hash table implementation of a Map

        ---
        Обходчик iterator ()
        цел opApply (цел delegate(ref V значение) дг)
        цел opApply (цел delegate(ref K ключ, ref V значение) дг)

        бул получи (K ключ, ref V element)
        бул keyOf (V значение, ref K ключ)
        бул содержит (V element)
        бул containsPair (K ключ, V element)

        бул removeKey (K ключ)
        бул take (ref V element)
        бул take (K ключ, ref V element)
        т_мера удали (V element, бул все)
        т_мера удали (IContainer!(V) e, бул все)
        т_мера замени (V oldElement, V newElement, бул все)
        бул replacePair (K ключ, V oldElement, V newElement)

        бул добавь (K ключ, V element)
        бул opIndexAssign (V element, K ключ)
        V    opIndex (K ключ)
        V*   opIn_r (K ключ)

        т_мера размер ()
        бул пуст_ли ()
        V[] toArray (V[] приёмн)
        HashMap dup ()
        HashMap сотри ()
        HashMap сбрось ()
        т_мера buckets ()
        плав threshold ()
        проц buckets (т_мера cap)
        проц threshold (плав desired)
        ---

*******************************************************************************/

class HashMap (K, V, alias Hash = Container.hash, 
                     alias Reap = Container.reap, 
                     alias куча = Container.DefaultCollect) 
                     : IContainer!(V)
{
        // bucket типы
        version (HashCache)
                 private alias Slink!(V, K, нет, да) Тип;
            else
                private alias Slink!(V, K) Тип;

        private alias Тип         *Ref;

        // разместитель тип
        private alias куча!(Тип)  Alloc;

        // each table Запись is a linked список, or пусто
        private Ref                table[];
        
        // число of elements contained
        private т_мера             счёт;

        // the threshold загрузи factor
        private плав              loadFactor;

        // configured куча manager
        private Alloc              куча;
        
        // mutation тэг updates on each change
        private т_мера             mutation;

        /***********************************************************************

                Construct a HashMap экземпляр

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

        final цел opApply (цел delegate(ref K ключ, ref V значение) дг)
        {
                return iterator.opApply (дг);
        }

        /***********************************************************************


        ***********************************************************************/

        final цел opApply (цел delegate(ref V значение) дг)
        {
                return iterator.opApply ((ref K k, ref V v) {return дг(v);});
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
                is добавьed, нет where it already есть_ли (and was possibly
                updated).
                
                Время complexity: O(1) average; O(n) worst.
                
        ***********************************************************************/

        final бул добавь (K ключ, V element)
        {
                if (table is пусто)
                    resize (Container.defaultInitialBuckets);

                auto hd = &table [Hash (ключ, table.length)];
                auto node = *hd;
                
                if (node is пусто)
                   {
                   *hd = куча.размести.установи (ключ, element, пусто);
                   инкремент;
                   }
                else
                   {
                   auto p = node.findKey (ключ);
                   if (p)
                      {
                      if (element != p.значение)
                         {
                         p.значение = element;
                         mutate;
                         }
                      return нет;
                      }
                   else
                      {
                      *hd = куча.размести.установи (ключ, element, node);
                      инкремент;

                      // we only check загрузи factor on добавь в_ Неукmpty bin
                      checkLoad; 
                      }
                   }
                return да;
        }

        /***********************************************************************

                Добавь a new element в_ the установи. Does not добавь if there is an
                equivalent already present. Returns да where an element
                is добавьed, нет where it already есть_ли (and was possibly
                updated). This variation invokes the given retain function
                when the ключ does not already exist. You would typically
                use that в_ duplicate a ткст, or whatever is required.
                
                Время complexity: O(1) average; O(n) worst.
                
        ***********************************************************************/

        final бул добавь (K ключ, V element, K function(K) retain)
        {
                if (table is пусто)
                    resize (Container.defaultInitialBuckets);

                auto hd = &table [Hash (ключ, table.length)];
                auto node = *hd;
                
                if (node is пусто)
                   {
                   *hd = куча.размести.установи (retain(ключ), element, пусто);
                   инкремент;
                   }
                else
                   {
                   auto p = node.findKey (ключ);
                   if (p)
                      {
                      if (element != p.значение)
                         {
                         p.значение = element;
                         mutate;
                         }
                      return нет;
                      }
                   else
                      {
                      *hd = куча.размести.установи (retain(ключ), element, node);
                      инкремент;

                      // we only check загрузи factor on добавь в_ Неукmpty bin
                      checkLoad; 
                      }
                   }
                return да;
        }

        /***********************************************************************

                Return the element associated with ключ

                param: a ключ
                param: a значение reference (where returned значение will resопрe)
                Возвращает: whether the ключ is contained or not
        
        ************************************************************************/

        final бул получи (K ключ, ref V element)
        {
                if (счёт)
                   {
                   auto p = table [Hash (ключ, table.length)];
                   if (p && (p = p.findKey(ключ)) !is пусто)
                      {
                      element = p.значение;
                      return да;
                      }
                   }
                return нет;
        }

        /***********************************************************************

                Return the element associated with ключ

                param: a ключ
                Возвращает: a pointer в_ the located значение, or пусто if не найден
        
        ************************************************************************/

        final V* opIn_r (K ключ)
        {
                if (счёт)
                   {
                   auto p = table [Hash (ключ, table.length)];
                   if (p && (p = p.findKey(ключ)) !is пусто)
                       return &p.значение;
                   }
                return пусто;
        }

        /***********************************************************************

                Does this установи contain the given element?
        
                Время complexity: O(1) average; O(n) worst
                
        ***********************************************************************/

        final бул содержит (V element)
        {
                return instances (element) > 0;
        }

        /***********************************************************************

                Время complexity: O(n).
        
        ************************************************************************/
        
        final бул keyOf (V значение, ref K ключ)
        {
                if (счёт)
                    foreach (список; table)
                            if (список)
                               {
                               auto p = список.найди (значение);
                               if (p)
                                  {
                                  ключ = p.ключ;
                                  return да;
                                  }
                               }
                return нет;
        }

        /***********************************************************************

                Время complexity: O(1) average; O(n) worst.
                
        ***********************************************************************/
        
        final бул containsKey (K ключ)
        {
                if (счёт)
                   {
                   auto p = table[Hash (ключ, table.length)];
                   if (p && p.findKey(ключ))
                       return да;
                   }
                return нет;
        }

        /***********************************************************************

                Время complexity: O(1) average; O(n) worst.
        
        ***********************************************************************/
        
        final бул containsPair (K ключ, V element)
        {
                if (счёт)
                   {                    
                   auto p = table[Hash (ключ, table.length)];
                   if (p && p.найдиПару (ключ, element))
                       return да;
                   }
                return нет;
        }

        /***********************************************************************

                Make an independent копируй of the container. Does not clone
                elements
                
                Время complexity: O(n)
                
        ***********************************************************************/

        final HashMap dup ()
        {
                auto clone = new HashMap!(K, V, Hash, Reap, куча) (loadFactor);

                if (счёт)
                   {
                   clone.buckets (buckets);

                   foreach (ключ, значение; iterator)
                            clone.добавь (ключ, значение);
                   }
                return clone;
        }

        /***********************************************************************

                Время complexity: O(1) average; O(n) worst.
        
        ***********************************************************************/
        
        final бул removeKey (K ключ)
        {
                V значение;

                return take (ключ, значение);
        }

        /***********************************************************************

                Время complexity: O(1) average; O(n) worst.
        
        ***********************************************************************/
        
        final бул replaceKey (K ключ, K замени)
        {
                if (счёт)
                   {
                   auto h = Hash (ключ, table.length);
                   auto hd = table[h];
                   auto trail = hd;
                   auto p = hd;

                   while (p)
                         {
                         auto n = p.следщ;
                         if (ключ == p.ключ)
                            {
                            if (p is hd)
                                table[h] = n;
                            else
                               trail.отторочьСледщ;
                            
                            // инъекцируй преобр_в new location
                            h = Hash (замени, table.length);
                            table[h] = p.установи (замени, p.значение, table[h]);
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

                Время complexity: O(1) average; O(n) worst.
        
        ***********************************************************************/
        
        final бул replacePair (K ключ, V oldElement, V newElement)
        {
                if (счёт)
                   {
                   auto p = table [Hash (ключ, table.length)];
                   if (p)
                      {
                      auto c = p.найдиПару (ключ, oldElement);
                      if (c)
                         {
                         c.значение = newElement;
                         mutate;
                         return да;
                         }
                      }
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

                Удали and expose the element associated with ключ

                param: a ключ
                param: a значение reference (where returned значение will resопрe)
                Возвращает: whether the ключ is contained or not
        
                Время complexity: O(1) average, O(n) worst

        ***********************************************************************/
        
        final бул take (K ключ, ref V значение)
        {
                if (счёт)
                   {
                   auto p = &table [Hash (ключ, table.length)];
                   auto n = *p;

                   while ((n = *p) !is пусто)
                           if (ключ == n.ключ)
                              {
                              *p = n.следщ;
                              значение = n.значение;
                              декремент (n);
                              return да;
                              } 
                           else
                              p = &n.следщ;
                   }
                return нет;
        }

        /***********************************************************************

                Operator shortcut for assignment

        ***********************************************************************/

        final бул opIndexAssign (V element, K ключ)
        {
                return добавь (ключ, element);
        }

        /***********************************************************************

                Operator retreival function

                Throws NoSuchElementException where ключ is missing

        ***********************************************************************/

        final V opIndex (K ключ)
        {
                auto p = opIn_r (ключ);
                if (p)
                    return *p;
                throw new NoSuchElementException ("missing or не_годится ключ");
        }

        /***********************************************************************

                Удали a установи of values 

        ************************************************************************/

        final т_мера удали (IContainer!(V) e, бул все = нет)
        {
                auto i = счёт;
                foreach (значение; e)
                         удали (значение, все);
                return i - счёт;
        }

        /***********************************************************************

                Removes element instances, and returns the число of elements
                removed
                
                Время complexity: O(1) average; O(n) worst
        
        ************************************************************************/

        final т_мера удали (V element, бул все = нет)
        {
                auto i = счёт;
                
                if (i)
                    foreach (ref node; table)
                            {                         
                            auto p = node;
                            auto trail = node;

                            while (p)
                                  {     
                                  auto n = p.следщ;
                                  if (element == p.значение)
                                     {
                                     декремент (p);
                                     if (p is node)
                                        {
                                        node = n;
                                        trail = n;
                                        }
                                     else
                                        trail.следщ = n;

                                     if (! все)
                                           return i - счёт;
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

                return i - счёт;
        }

        /***********************************************************************

                Замени instances of oldElement with newElement, and returns
                the число of replacements

                Время complexity: O(n).
                
        ************************************************************************/

        final т_мера замени (V oldElement, V newElement, бул все = нет)
        {
                т_мера i;
                
                if (счёт && oldElement != newElement)
                    foreach (node; table)
                             while (node && (node = node.найди(oldElement)) !is пусто)
                                   {
                                   ++i;
                                   mutate;
                                   node.значение = newElement;
                                   if (! все)
                                         return i;
                                   }
                return i;
        }
        
        /***********************************************************************

                Clears the HashMap contents. Various атрибуты are
                retained, such as the internal table itself. Invoke
                сбрось() в_ drop everything.

                Время complexity: O(n)
                
        ***********************************************************************/

        final HashMap сотри ()
        {
                return сотри (нет);
        }

        /***********************************************************************

                Reset the HashMap contents. This releases ещё память 
                than сотри() does

                Время complexity: O(n)
                
        ***********************************************************************/

        final HashMap сбрось ()
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

                Набор the desired число of buckets in the hash table. Any 
                значение greater than or equal в_ one is ОК.

                If different than current buckets, causes a version change
                
                Время complexity: O(n)

        ***********************************************************************/

        final HashMap buckets (т_мера cap)
        {
                if (cap < Container.defaultInitialBuckets)
                    cap = Container.defaultInitialBuckets;

                if (cap !is buckets)
                    resize (cap);
                return this;
        }

        /***********************************************************************

                Набор the число of buckets for the given threshold
                and resize as required
                
                Время complexity: O(n)

        ***********************************************************************/

        final HashMap buckets (т_мера cap, плав threshold)
        {
                loadFactor = threshold;
                return buckets (cast(т_мера)(cap / threshold) + 1);
        }

        /***********************************************************************

                Configure the assigned разместитель with the размер of each
                allocation block (число of nodes allocated at one время)
                and the число of nodes в_ pre-наполни the cache with.
                
                Время complexity: O(n)

        ***********************************************************************/

        final HashMap cache (т_мера chunk, т_мера счёт=0)
        {
                куча.конфиг (chunk, счёт);
                return this;
        }

        /***********************************************************************

                Return the current загрузи factor threshold

                The Hash table occasionally checka against the загрузи factor
                resizes itself if it есть gone past it.

                Время complexity: O(1)

        ***********************************************************************/

        final плав threshold ()
        {
                return loadFactor;
        }

        /***********************************************************************

                Набор the resize threshold, and resize as required
                Набор the current desired загрузи factor. Any значение greater 
                than 0 is ОК. The current загрузи is checked against it, 
                possibly causing a resize.
                
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

                Sanity check

        ***********************************************************************/
                        
        final HashMap check ()
        {
                assert(!(table is пусто && счёт !is 0));
                assert((table is пусто || table.length > 0));
                assert(loadFactor > 0.0f);

                if (table)
                   {
                   т_мера c = 0;
                   for (т_мера i=0; i < table.length; ++i)
                        for (auto p = table[i]; p; p = p.следщ)
                            {
                            ++c;
                            assert(содержит(p.значение));
                            assert(containsKey(p.ключ));
                            assert(instances(p.значение) >= 1);
                            assert(containsPair(p.ключ, p.значение));
                            assert(Hash (p.ключ, table.length) is i);
                            }
                   assert(c is счёт);
                   }
                return this;
        }

        /***********************************************************************

                Count the element instances in the установи (there can only be
                0 or 1 instances in a Набор).
                
                Время complexity: O(n)
                
        ***********************************************************************/

        private т_мера instances (V element)
        {
                т_мера c = 0;
                foreach (node; table)
                         if (node)
                             c += node.счёт (element);
                return c;
        }

        /***********************************************************************

                 Check в_ see if we are past загрузи factor threshold. If so,
                 resize so that we are at half of the desired threshold.
                 
        ***********************************************************************/

        private HashMap checkLoad ()
        {
                плав fc = счёт;
                плав ft = table.length;
                if (fc / ft > loadFactor)
                    resize (2 * cast(т_мера)(fc / loadFactor) + 1);
                return this;
        }

        /***********************************************************************

                resize table в_ new ёмкость, rehashing все elements
                
        ***********************************************************************/

        private проц resize (т_мера newCap)
        {
                // Стдвыв.форматнс ("resize {}", newCap);
                auto newtab = куча.размести (newCap);
                mutate;

                foreach (bucket; table)
                         while (bucket)
                               {
                               auto n = bucket.следщ;
                               version (HashCache)
                                        auto h = n.cache;
                                  else
                                     auto h = Hash (bucket.ключ, newCap);
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

        private бул removeNode (Ref node, Ref* список)
        {
                auto p = список;
                auto n = *p;

                while ((n = *p) !is пусто)
                        if (n is node)
                           {
                           *p = n.следщ;
                           декремент (n);
                           return да;
                           } 
                        else
                           p = &n.следщ;
                return нет;
        }

        /***********************************************************************

                Clears the HashMap contents. Various атрибуты are
                retained, such as the internal table itself. Invoke
                сбрось() в_ drop everything.

                Время complexity: O(n)
                
        ***********************************************************************/

        private final HashMap сотри (бул все)
        {
                mutate;

                // collect each node if we can't collect все at once
                if (куча.collect(все) is нет)
                    foreach (v; table)
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
                Reap (p.ключ, p.значение);
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
                т_мера  row;
                Ref     cell,
                        prior;
                Ref[]   table;
                HashMap хозяин;
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

                бул следщ (ref K k, ref V v)
                {
                        auto n = следщ (k);
                        return (n) ? v = *n, да : нет;
                }
                
                /***************************************************************

                        Return a pointer в_ the следщ значение, or пусто when
                        there are no further values в_ traverse

                ***************************************************************/

                V* следщ (ref K k)
                {
                        while (cell is пусто)
                               if (row < table.length)
                                   cell = table [row++];
                               else
                                  return пусто;
  
                        prior = cell;
                        k = cell.ключ;
                        cell = cell.следщ;
                        return &prior.значение;

                }

                /***************************************************************

                        Foreach support

                ***************************************************************/

                цел opApply (цел delegate(ref K ключ, ref V значение) дг)
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
                              if ((результат = дг(prior.ключ, prior.значение)) != 0)
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
                            if (хозяин.removeNode (prior, &table[row-1]))
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

debug (HashMap)
{
        import io.Stdout;
        import gc;
        import time.StopWatch;

        проц main()
        {
                // usage examples ...
                auto карта = new HashMap!(ткст, цел);
                карта.добавь ("foo", 1);
                карта.добавь ("bar", 2);
                карта.добавь ("wumpus", 3);

                // implicit generic iteration
                foreach (ключ, значение; карта)
                         Стдвыв.форматнс ("{}:{}", ключ, значение);

                // explicit generic iteration
                foreach (ключ, значение; карта.iterator)
                         Стдвыв.форматнс ("{}:{}", ключ, значение);

                // generic iteration with optional удали
                auto s = карта.iterator;
                foreach (ключ, значение; s)
                        {} // s.удали;

                // incremental iteration, with optional удали
                ткст k;
                цел    v;
                auto iterator = карта.iterator;
                while (iterator.следщ(k, v))
                      {} //iterator.удали;
                
                // incremental iteration, with optional failfast
                auto it = карта.iterator;
                while (it.valid && it.следщ(k, v))
                      {}

                // удали specific element
                карта.removeKey ("wumpus");

                // удали first element ...
                while (карта.take(v))
                       Стдвыв.форматнс ("taking {}, {} left", v, карта.размер);
                  
                // установи for benchmark, with a установи of целыйs. We
                // use a chunk разместитель, and presize the bucket[]
                auto тест = new HashMap!(цел, цел);//, Container.hash, Container.reap, Container.ChunkGC);
                тест.buckets(1_500_000);//.cache(8000, 1000000);
                const счёт = 1_000_000;
                Секундомер w;

                СМ.collect;
                тест.check;

                // benchmark добавьing
                w.старт;
                for (цел i=счёт; i--;)
                     тест.добавь(i, i);
                Стдвыв.форматнс ("{} добавьs: {}/s", тест.размер, тест.размер/w.stop);

                // benchmark reading
                w.старт;
                for (цел i=счёт; i--;)
                     тест.получи(i, v);
                Стдвыв.форматнс ("{} lookups: {}/s", тест.размер, тест.размер/w.stop);

                // benchmark добавьing without allocation overhead
                тест.сотри;
                w.старт;
                for (цел i=счёт; i--;)
                     тест.добавь(i, i);
                Стдвыв.форматнс ("{} добавьs (after сотри): {}/s", тест.размер, тест.размер/w.stop);

                // benchmark duplication
                w.старт;
                auto dup = тест.dup;
                Стдвыв.форматнс ("{} element dup: {}/s", dup.размер, dup.размер/w.stop);

                // benchmark iteration
                w.старт;
                foreach (ключ, значение; тест) {}
                Стдвыв.форматнс ("{} element iteration: {}/s", тест.размер, тест.размер/w.stop);

                СМ.collect;
                тест.check;
/+
                auto aa = new HashMap!(дол, цел, Container.hash, Container.reap, Container.Chunk);
                aa.buckets(7_500_000).cache(100000, 5_000_000);
                w.старт;
                for (цел i=5_000_000; i--;)
                     aa.добавь (i, 0);
                Стдвыв.форматнс ("{} тест iteration: {}/s", aa.размер, aa.размер/w.stop);
+/
        }
}
