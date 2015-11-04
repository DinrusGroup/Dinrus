/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
        
        version:        Initial release: April 2008      
        
        author:         Kris

        Since:          0.99.7

*******************************************************************************/

module util.container.more.CacheMap;

private import rt.core.stdc.stdlib;

private import util.container.HashMap;

public  import util.container.Container;

/******************************************************************************

        CacheMap extends the basic hashmap тип by добавьing a предел в_ 
        the число of items contained at any given время. In добавьition, 
        CacheMap sorts the cache записи such that those записи 
        frequently использовался are at the голова of the queue, and those
        least frequently использовался are at the хвост. When the queue 
        becomes full, old записи are dropped из_ the хвост and are 
        reused в_ house new cache записи. 

        In другой words, it retains MRU items while dropping LRU when
        ёмкость is reached.

        This is great for keeping commonly использовался items around, while
        limiting the amount of память used. Typically, the queue размер 
        would be установи in the thousands (via the ctor)

******************************************************************************/

class CacheMap (K, V, alias Hash = Container.hash, 
                      alias Reap = Container.reap, 
                      alias куча = Container.Collect) 
{
        private alias QueuedEntry       Тип;
        private alias Тип              *Ref;
        private alias HashMap!(K, Ref, Hash, reaper, куча) Map;
        private Map                     hash;
        private Тип[]                  линки;

        // extents of queue
        private Ref                     голова,
                                        хвост;
        // дименсия of queue
        private бцел                    ёмкость;

       /**********************************************************************

                Construct a cache with the specified maximum число of 
                записи. добавьitions в_ the cache beyond this число will
                reuse the slot of the least-recently-referenced cache
                Запись. 

        **********************************************************************/

        this (бцел ёмкость)
        {
                hash = new Map;
                this.ёмкость = ёмкость;
                hash.buckets (ёмкость, 0.75);
                линки.length = ёмкость;

                // создай пустой список
                голова = хвост = &линки[0];
                foreach (ref link; линки[1..$])
                        {
                        link.prev = хвост;
                        хвост.следщ = &link;
                        хвост = &link;
                        }
        }

        /***********************************************************************

                Reaping обрвызов for the hashmap, acting as a trampoline

        ***********************************************************************/

        static проц reaper(K, R) (K k, R r) 
        {
                Reap (k, r.значение);
        }

        /***********************************************************************


        ***********************************************************************/

        final бцел размер ()
        {
                return hash.размер;
        }

        /***********************************************************************

                Iterate из_ MRU в_ LRU записи

        ***********************************************************************/

        final цел opApply (цел delegate(ref K ключ, ref V значение) дг)
        {
                        K   ключ;
                        V   значение;
                        цел результат;

                        auto node = голова;
                        auto i = hash.размер;
                        while (i--)
                              {
                              ключ = node.ключ;
                              значение = node.значение;
                              if ((результат = дг(ключ, значение)) != 0)
                                   break;
                              node = node.следщ;
                              }
                        return результат;
        }

        /**********************************************************************

                Get the cache Запись опрentified by the given ключ

        **********************************************************************/

        бул получи (K ключ, ref V значение)
        {
                Ref Запись = пусто;

                // if we найди 'ключ' then перемести it в_ the список голова
                if (hash.получи (ключ, Запись))
                   {
                   значение = Запись.значение;
                   reReference (Запись);
                   return да;
                   }
                return нет;
        }

        /**********************************************************************

                Place an Запись преобр_в the cache and associate it with the
                provопрed ключ. Note that there can be only one Запись for
                any particular ключ. If two записи are добавьed with the 
                same ключ, the сукунда effectively overwrites the first.

                Returns да if we добавьed a new Запись; нет if we just
                replaced an existing one

        **********************************************************************/

        final бул добавь (K ключ, V значение)
        {
                Ref Запись = пусто;

                // already in the список? -- замени Запись
                if (hash.получи (ключ, Запись))
                   {
                   // установи the new item for this ключ and перемести в_ список голова
                   reReference (Запись.установи (ключ, значение));
                   return нет;
                   }

                // создай a new Запись at the список голова 
                добавьEntry (ключ, значение);
                return да;
        }

        /**********************************************************************

                Удали the cache Запись associated with the provопрed ключ. 
                Returns нет if there is no such Запись.

        **********************************************************************/

        final бул take (K ключ)
        {
                V значение;

                return take (ключ, значение);
        }

        /**********************************************************************

                Удали (and return) the cache Запись associated with the 
                provопрed ключ. Returns нет if there is no such Запись.

        **********************************************************************/

        final бул take (K ключ, ref V значение)
        {
                Ref Запись = пусто;
                if (hash.получи (ключ, Запись))
                   {
                   значение = Запись.значение;

                   // don't actually затуши the список Запись -- just place
                   // it at the список 'хвост' ready for subsequent reuse
                   deReference (Запись);

                   // удали the Запись из_ hash
                   hash.removeKey (ключ);
                   return да;
                   }
                return нет;
        }

        /**********************************************************************

                Place a cache Запись at the хвост of the queue. This makes
                it the least-recently referenced.

        **********************************************************************/

        private Ref deReference (Ref Запись)
        {
                if (Запись !is хвост)
                   {
                   // исправь голова
                   if (Запись is голова)
                       голова = Запись.следщ;

                   // перемести в_ хвост
                   Запись.extract;
                   хвост = Запись.добавь (хвост);
                   }
                return Запись;
        }

        /**********************************************************************

                Move a cache Запись в_ the голова of the queue. This makes
                it the most-recently referenced.

        **********************************************************************/

        private Ref reReference (Ref Запись)
        {
                if (Запись !is голова)
                   {
                   // исправь хвост
                   if (Запись is хвост)
                       хвост = Запись.prev;

                   // перемести в_ голова
                   Запись.extract;
                   голова = Запись.приставь (голова);
                   }
                return Запись;
        }

        /**********************************************************************

                Добавь an Запись преобр_в the queue. If the queue is full, the
                least-recently-referenced Запись is reused for the new
                добавьition. 

        **********************************************************************/

        private Ref добавьEntry (K ключ, V значение)
        {
                assert (ёмкость);

                if (hash.размер < ёмкость)
                    hash.добавь (ключ, хвост);
                else
                   {
                   // we're re-using a prior QueuedEntry, so reap and
                   // relocate the existing hash-table Запись first
                   Reap (хвост.ключ, хвост.значение);
                   if (! hash.replaceKey (хвост.ключ, ключ))
                         throw new Исключение ("ключ missing!");
                   }

                // place at голова of список
                return reReference (хвост.установи (ключ, значение));
        }

        /**********************************************************************
        
                A doubly-linked список Запись, used as a wrapper for queued 
                cache записи
        
        **********************************************************************/
        
        private struct QueuedEntry
        {
                private K               ключ;
                private Ref             prev,
                                        следщ;
                private V               значение;
        
                /**************************************************************
        
                        Набор this linked-список Запись with the given аргументы. 

                **************************************************************/
        
                Ref установи (K ключ, V значение)
                {
                        this.значение = значение;
                        this.ключ = ключ;
                        return this;
                }
        
                /**************************************************************
        
                        Insert this Запись преобр_в the linked-список just in 
                        front of the given Запись.
        
                **************************************************************/
        
                Ref приставь (Ref before)
                {
                        if (before)
                           {
                           prev = before.prev;
        
                           // patch 'prev' в_ point at me
                           if (prev)
                               prev.следщ = this;
        
                           //patch 'before' в_ point at me
                           следщ = before;
                           before.prev = this;
                           }
                        return this;
                }
        
                /**************************************************************
                        
                        Добавь this Запись преобр_в the linked-список just after 
                        the given Запись.
        
                **************************************************************/
        
                Ref добавь (Ref after)
                {
                        if (after)
                           {
                           следщ = after.следщ;
        
                           // patch 'следщ' в_ point at me
                           if (следщ)
                               следщ.prev = this;
        
                           //patch 'after' в_ point at me
                           prev = after;
                           after.следщ = this;
                           }
                        return this;
                }
        
                /**************************************************************
        
                        Удали this Запись из_ the linked-список. The 
                        previous and следщ записи are patched together 
                        appropriately.
        
                **************************************************************/
        
                Ref extract ()
                {
                        // сделай 'prev' and 'следщ' записи see each другой
                        if (prev)
                            prev.следщ = следщ;
        
                        if (следщ)
                            следщ.prev = prev;
        
                        // Murphy's law 
                        следщ = prev = пусто;
                        return this;
                }
        }
}


/*******************************************************************************

*******************************************************************************/

debug (CacheMap)
{
        import io.Stdout;
        import gc;
        import time.StopWatch;

        проц main()
        {
                цел v;
                auto карта = new CacheMap!(ткст, цел)(2);
                карта.добавь ("foo", 1);
                карта.добавь ("bar", 2);
                карта.добавь ("wumpus", 3);
                foreach (k, v; карта)
                         Стдвыв.форматнс ("{} {}", k, v);

                Стдвыв.нс;
                карта.получи ("bar", v);
                foreach (k, v; карта)
                         Стдвыв.форматнс ("{} {}", k, v);

                Стдвыв.нс;
                карта.получи ("bar", v);
                foreach (k, v; карта)
                         Стдвыв.форматнс ("{} {}", k, v);

                Стдвыв.нс;
                карта.получи ("foo", v);
                foreach (k, v; карта)
                         Стдвыв.форматнс ("{} {}", k, v);

                Стдвыв.нс;
                карта.получи ("wumpus", v);
                foreach (k, v; карта)
                         Стдвыв.форматнс ("{} {}", k, v);


                // установи for benchmark, with a cache of целыйs
                auto тест = new CacheMap!(цел, цел, Container.hash, Container.reap, Container.Chunk) (1000);
                const счёт = 1_000_000;
                Секундомер w;

                // benchmark добавьing
                w.старт;
                for (цел i=счёт; i--;)
                     тест.добавь (i, i);
                Стдвыв.форматнс ("{} добавьs: {}/s", счёт, счёт/w.stop);

                // benchmark reading
                w.старт;
                for (цел i=счёт; i--;)
                     тест.получи (i, v);
                Стдвыв.форматнс ("{} lookups: {}/s", счёт, счёт/w.stop);

                // benchmark iteration
                w.старт;
                foreach (ключ, значение; тест) {}
                Стдвыв.форматнс ("{} element iteration: {}/s", тест.размер, тест.размер/w.stop);

                тест.hash.check;
        }
}
        
