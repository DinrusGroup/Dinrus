/*******************************************************************************

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

private import exception : NoSuchElementException;

/*******************************************************************************

        RedBlack trees of (ключ, значение) pairs

        ---
        Обходчик iterator (бул forward)
        Обходчик iterator (K ключ, бул forward)
        цел opApply (цел delegate (ref V значение) дг)
        цел opApply (цел delegate (ref K ключ, ref V значение) дг)

        бул содержит (V значение)
        бул containsKey (K ключ)
        бул containsPair (K ключ, V значение)
        бул keyOf (V значение, ref K ключ)
        бул получи (K ключ, ref V значение)

        бул take (ref V v)
        бул take (K ключ, ref V v)
        бул removeKey (K ключ)
        т_мера удали (V значение, бул все)
        т_мера удали (IContainer!(V) e, бул все)

        бул добавь (K ключ, V значение)
        т_мера замени (V oldElement, V newElement, бул все)
        бул replacePair (K ключ, V oldElement, V newElement)
        бул opIndexAssign (V element, K ключ)
        K    nearbyKey (K ключ, бул greater)
        V    opIndex (K ключ)
        V*   opIn_r (K ключ)

        т_мера размер ()
        бул пуст_ли ()
        V[] toArray (V[] приёмн)
        SortedMap dup ()
        SortedMap сотри ()
        SortedMap сбрось ()
        SortedMap comparator (Comparator c)
        ---

*******************************************************************************/

class SortedMap (K, V, alias Reap = Container.reap, 
                       alias куча = Container.DefaultCollect) 
                       : IContainer!(V)
{
        // use this тип for Разместитель configuration
        public alias RedBlack!(K, V)    Тип;
        private alias Тип              *Ref;

        private alias куча!(Тип)       Alloc;
        private alias Compare!(K)       Comparator;

        // корень of the дерево. Пусто if пустой.
        package Ref                     дерево;

        // configured куча manager
        private Alloc                   куча;

        // Comparators used for ordering
        private Comparator              cmp;
        private Compare!(V)             cmpElem;

        private т_мера                  счёт,
                                        mutation;


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

                Return a generic iterator for contained elements
                
        ***********************************************************************/

        final Обходчик iterator (бул forward = да)
        {
                Обходчик i =void;
                i.node = счёт ? (forward ? дерево.leftmost : дерево.rightmost) : пусто;
                i.bump = forward ? &Обходчик.fore : &Обходчик.back;
                i.mutation = mutation;
                i.хозяин = this;
                i.prior = пусто;
                return i;
        }
      
        /***********************************************************************

                Return an iterator which return все elements matching 
                or greater/lesser than the ключ in аргумент. The сукунда
                аргумент dictates traversal direction.

                Return a generic iterator for contained elements
                
        ***********************************************************************/

        final Обходчик iterator (K ключ, бул forward)
        {
                Обходчик i = iterator (forward);
                i.node = счёт ? дерево.findFirst(ключ, cmp, forward) : пусто;
                return i;
        }

        /***********************************************************************

                Configure the assigned разместитель with the размер of each
                allocation block (число of nodes allocated at one время)
                and the число of nodes в_ pre-наполни the cache with.
                
                Время complexity: O(n)

        ***********************************************************************/

        final SortedMap cache (т_мера chunk, т_мера счёт=0)
        {
                куча.конфиг (chunk, счёт);
                return this;
        }

        /***********************************************************************

                Return the число of elements contained
                
        ***********************************************************************/

        final т_мера размер ()
        {
                return счёт;
        }
        
        /***********************************************************************

                Create an independent копируй. Does not clone elements
                 
        ***********************************************************************/

        final SortedMap dup ()
        {
                auto clone = new SortedMap!(K, V, Reap, куча) (cmp, счёт);
                if (счёт)
                    clone.дерево = дерево.copyTree (&clone.куча.размести);

                return clone;
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
                return iterator.opApply ((ref K k, ref V v) {return дг(v);});
        }


        /***********************************************************************
        
        ***********************************************************************/
        
        final цел opApply (цел delegate (ref K ключ, ref V значение) дг)
        {
                return iterator.opApply (дг);
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
                      mutate;
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

        final бул containsKey (K ключ)
        {
                if (счёт is 0)
                    return нет;

                return дерево.найди (ключ, cmp) !is пусто;
        }

        /***********************************************************************

                Время complexity: O(n)
                 
        ***********************************************************************/

        final бул containsPair (K ключ, V значение)
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

                Return the значение of the ключ exactly matching the provопрed
                ключ or, if Неук, the ключ just after/before it based on the
                настройка of the сукунда аргумент
    
                param: ключ a ключ
                param: after indicates whether в_ look beyond or before
                       the given ключ, where there is no exact match
                throws: NoSuchElementException if Неук найдено
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
        
                Return the first ключ of the карта

                throws: NoSuchElementException where the карта is пустой
                     
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

                throws: NoSuchElementException where the карта is пустой
                     
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

        final бул keyOf (V значение, ref K ключ)
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

        final SortedMap сотри ()
        {
                return сотри (нет);
        }

        /***********************************************************************

                Reset the SortedMap contents. This releases ещё память 
                than сотри() does

                Время complexity: O(n)
                
        ***********************************************************************/

        final SortedMap сбрось ()
        {
                return сотри (да);
        }

        /***********************************************************************

        ************************************************************************/

        final т_мера удали (IContainer!(V) e, бул все)
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

        final т_мера замени (V oldElement, V newElement, бул все = нет)
        {
                т_мера c;

                if (счёт)
                   {
                   auto p = дерево.findAttribute (oldElement, cmpElem);
                   while (p)
                         {
                         ++c;
                         mutate;
                         p.attribute = newElement;
                         if (!все)
                              break;
                         p = дерево.findAttribute (oldElement, cmpElem);
                         }
                   }
                return c;
        }

        /***********************************************************************

                Время complexity: O(лог n)

                Takes the значение associated with the least ключ.
                 
        ***********************************************************************/

        final бул take (ref V v)
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

        final бул take (K ключ, ref V значение)
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
                есть_ли and was updated instead
                 
        ***********************************************************************/

        final бул добавь (K ключ, V значение)
        {
                return добавь_ (ключ, значение, да);
        }

        /***********************************************************************

                Время complexity: O(лог n)

                Returns да if inserted, нет where an existing ключ 
                есть_ли and was updated instead
                 
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

                noSuchElement ("missing or не_годится ключ");
                assert (0);
        }

        /***********************************************************************

                Время complexity: O(лог n)
                        
        ***********************************************************************/

        final бул removeKey (K ключ)
        {
                V значение;
                
                return take (ключ, значение);
        }

        /***********************************************************************

                Время complexity: O(лог n)
                 
        ***********************************************************************/

        final бул replacePair (K ключ, V oldElement, V newElement)
        {
                if (счёт)
                   {
                   auto p = дерево.найди (ключ, oldElement, cmp);
                   if (p)
                      {
                      p.attribute = newElement;
                      mutate;
                      return да;
                      }
                   }
                return нет;
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

                 
        ***********************************************************************/

        final SortedMap check ()
        {
                assert(cmp !is пусто);
                assert(((счёт is 0) is (дерево is пусто)));
                assert((дерево is пусто || дерево.размер() is счёт));

                if (дерево)
                   {
                   дерево.checkImplementation;
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
                throw new NoSuchElementException (сооб);
        }

        /***********************************************************************

                Время complexity: O(лог n)
                 
        ***********************************************************************/

        private т_мера instances (V значение)
        {
                if (счёт is 0)
                     return 0;
                return дерево.countAttribute (значение, cmpElem);
        }

        /***********************************************************************

                Returns да where an element is добавьed, нет where an 
                existing ключ is найдено
                 
        ***********************************************************************/

        private final бул добавь_ (K ключ, V значение, бул checkOccurrence)
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
                       if (diff is 0 && checkOccurrence)
                          {
                          if (t.attribute != значение)
                             {
                             t.attribute = значение;
                             mutate;
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

        private SortedMap сотри (бул все)
        {
                mutate;

                // collect each node if we can't collect все at once
                if (куча.collect(все) is нет & счёт)                 
                   {
                   auto node = дерево.leftmost;
                   while (node)
                         {
                         auto следщ = node.successor;
                         декремент (node);
                         node = следщ;
                         }
                   }

                счёт = 0;
                дерево = пусто;
                return this;
        }

        /***********************************************************************

                Время complexity: O(лог n)
                        
        ***********************************************************************/

        private проц удали (Ref node)
        {
                дерево = node.удали (дерево);
                декремент (node);
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
                Reap (p.значение, p.attribute);
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

                The default ключ comparator

                @param fst first аргумент
                @param snd сукунда аргумент

                Возвращает: a negative число if fst is less than snd; a
                positive число if fst is greater than snd; else 0
                 
        ***********************************************************************/

        private static цел compareKey (ref K fst, ref K snd)
        {
                if (fst is snd)
                    return 0;

                return typeid(K).compare (&fst, &snd);
        }


        /***********************************************************************

                The default значение comparator

                @param fst first аргумент
                @param snd сукунда аргумент

                Возвращает: a negative число if fst is less than snd; a
                positive число if fst is greater than snd; else 0
                 
        ***********************************************************************/

        private static цел compareElem(ref V fst, ref V snd)
        {
                if (fst is snd)
                    return 0;

                return typeid(V).compare (&fst, &snd);
        }

        /***********************************************************************

                Обходчик with no filtering

        ***********************************************************************/

        private struct Обходчик
        {
                Ref function(Ref) bump;
                Ref               node,
                                  prior;
                SortedMap         хозяин;
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
                        V* r;

                        if (node)
                           {
                           prior = node;
                           k = node.значение;
                           r = &node.attribute;
                           node = bump (node);
                           }
                        return r;
                }

                /***************************************************************

                        Foreach support

                ***************************************************************/

                цел opApply (цел delegate(ref K ключ, ref V значение) дг)
                {
                        цел результат;

                        auto n = node;
                        while (n)
                              {
                              prior = n;
                              auto следщ = bump (n);
                              if ((результат = дг(n.значение, n.attribute)) != 0)
                                   break;
                              n = следщ;
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
                           хозяин.удали (prior);

                           // ignore this change
                           ++mutation;
                           return да;
                           }

                        prior = пусто;
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

                private static Ref fore (Ref p)
                {
                        return p.successor;
                }

                /***************************************************************

                ***************************************************************/

                private static Ref back (Ref p)
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

                // implicit generic iteration
                foreach (ключ, значение; карта)
                         Стдвыв.форматнс ("{}:{}", ключ, значение);

                // explicit iteration
                foreach (ключ, значение; карта.iterator("foo", нет))
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
                auto тест = new SortedMap!(цел, цел, Container.reap, Container.Chunk);
                тест.cache (1000, 500_000);
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
                тест.сотри;
                w.старт;
                for (цел i=счёт; i--;)
                     тест.добавь(ключи[i], i);
                Стдвыв.форматнс ("{} добавьs (after сотри): {}/s", тест.размер, тест.размер/w.stop);

                // benchmark duplication
                w.старт;
                auto dup = тест.dup;
                Стдвыв.форматнс ("{} element dup: {}/s", dup.размер, dup.размер/w.stop);

                // benchmark iteration
                w.старт;
                foreach (ключ, значение; тест) {}
                Стдвыв.форматнс ("{} element iteration: {}/s", тест.размер, тест.размер/w.stop);

                тест.check;
        }
}
