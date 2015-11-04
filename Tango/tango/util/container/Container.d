/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Apr 2008: Initial release
                        Jan 2009: добавьed GCChunk разместитель

        authors:        Kris, schveiguy

        Since:          0.99.7

*******************************************************************************/

module util.container.Container;

private import gc;

private import rt.core.stdc.stdlib;
private import cidrus;

/*******************************************************************************

        Utility functions and constants

*******************************************************************************/

struct Container
{
        /***********************************************************************
        
               default начальное число of buckets of a non-пустой hashmap

        ***********************************************************************/
        
        static т_мера defaultInitialBuckets = 31;

        /***********************************************************************

                default загрузи factor for a non-пустой hashmap. The hash 
                table is resized when the proportion of elements per 
                buckets exceeds this предел
        
        ***********************************************************************/
        
        static плав defaultLoadFactor = 0.75f;

        /***********************************************************************
        
                generic значение reaper, which does nothing

        ***********************************************************************/
        
        static проц reap(V) (V v) {}

        /***********************************************************************
        
                generic ключ/значение reaper, which does nothing

        ***********************************************************************/
        
        static проц reap(K, V) (K k, V v) {}

        /***********************************************************************

                generic hash function, using the default hashing. Thanks
                в_ 'mwarning' for the optimization suggestion

        ***********************************************************************/

        static т_мера hash(K) (K k, т_мера length)
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
        
                СМ Chunk разместитель

                Can save approximately 30% память for small elements (tested 
                with целое elements and a chunk размер of 1000), and is at 
                least twice as fast at добавьing elements when compared в_ the 
                generic разместитель (approximately 50x faster with LinkedList)
        
                Operates safely with СМ managed entities

        ***********************************************************************/
        
        struct ChunkGC(T)
        {
                static assert (T.sizeof >= (T*).sizeof, "The ChunkGC разместитель can only be used for данные sizes of at least " ~ ((T*).sizeof).stringof[0..$-1] ~ " байты!");

                private struct Cache {Cache* следщ;}

                private Cache*  cache;
                private T[][]   lists;
                private т_мера  chunks = 256;

                /***************************************************************
        
                        размести a T-sized память chunk
                        
                ***************************************************************/

                T* размести ()
                {
                        if (cache is пусто)
                            newlist;
                        auto p = cache;
                        cache = p.следщ;
                        return cast(T*) p;
                }
        
                /***************************************************************
        
                        размести an Массив of T* sized память chunks
                        
                ***************************************************************/
        
                T*[] размести (т_мера счёт)
                {
                        auto p = (cast(T**) calloc(счёт, (T*).sizeof)) [0 .. счёт];
                        СМ.добавьRange (cast(проц*) p, счёт * (T*).sizeof);
                        return p;
                }
        
                /***************************************************************
        
                        Invoked when a specific T*[] is discarded
                        
                ***************************************************************/
        
                проц collect (T*[] t)
                {      
                        if (t.ptr)
                           {
                           СМ.removeRange (t.ptr);
                           free (t.ptr);
                           }
                }

                /***************************************************************
        
                        Invoked when a specific T is discarded
                        
                ***************************************************************/
        
                проц collect (T* p)
                {      
                        assert (p);
                        auto d = cast(Cache*) p;
                        //*p = T.init;
                        d.следщ = cache;
                        cache = d;
                }
        
                /***************************************************************
        
                        Invoked when сотри/сбрось is called on the хост. 
                        This is a shortcut в_ сотри everything allocated.
        
                        Should return да if supported, or нет otherwise. 
                        Нет return will cause a series of discrete collect
                        calls
                        
                ***************************************************************/
        
                бул collect (бул все = да)
                {
                        if (все)
                           {
                           foreach (ref список; lists)
                                   {
                                   СМ.removeRange (список.ptr);
                                   free (список.ptr);
                                   список = пусто;
                                   }
                           cache = пусто;
                           lists = пусто;
                           return да;
                           }
                        return нет;
                }
              
                /***************************************************************
        
                        установи the chunk размер and prepopulate with nodes
                        
                ***************************************************************/
        
                проц конфиг (т_мера chunks, цел размести=0)
                {
                        this.chunks = chunks;
                        if (размести)
                            for (цел i=размести/chunks+1; i--;)
                                 newlist;
                }
        
                /***************************************************************
        
                        список manager
                        
                ***************************************************************/
        
                private проц newlist ()
                {
                        lists.length = lists.length + 1;
                        auto p = (cast(T*) calloc (chunks, T.sizeof)) [0 .. chunks];
                        lists[$-1] = p;
                        СМ.добавьRange (p.ptr, T.sizeof * chunks);
                        auto голова = cache;
                        foreach (ref node; p)
                                {
                                auto d = cast(Cache*) &node;
                                d.следщ = голова;
                                голова = d;
                                }
                        cache = голова;
                }
        }        


        /***********************************************************************
        
                Chunk разместитель (non СМ)

                Can save approximately 30% память for small elements (tested 
                with целое elements and a chunk размер of 1000), and is at 
                least twice as fast at добавьing elements when compared в_ the 
                default разместитель (approximately 50x faster with LinkedList)
        
                Note that, due в_ СМ behaviour, you should not конфигурируй
                a custom разместитель for containers holding anything managed
                by the СМ. For example, you cannot use a MallocAllocator
                в_ manage a container of classes or strings where those 
                were allocated by the СМ. Once something is owned by a СМ
                then it's lifetime must be managed by СМ-managed entities
                (otherwise the СМ may think there are no live references
                and prematurely collect container contents).
        
                You can explicity manage the collection of ключи and values
                yourself by provопрing a reaper delegate. For example, if 
                you use a MallocAllocator в_ manage ключ/значение pairs which
                are themselves allocated via malloc, then you should also
                provопрe a reaper delegate в_ collect those as required.

                The primary benefit of this разместитель is в_ avoопр the СМ
                scanning the дата-structures involved. Use ChunkGC where
                that опция is unwarranted, or if you have СМ-managed данные
                instead
              
        ***********************************************************************/
        
        struct Chunk(T)
        {
                static assert (T.sizeof >= (T*).sizeof, "The Chunk разместитель can only be used for данные sizes of at least " ~ ((T*).sizeof).stringof[0..$-1] ~ " байты!");

                private struct Cache {Cache* следщ;}

                private Cache*  cache;
                private T[][]   lists;
                private т_мера  chunks = 256;

                /***************************************************************
        
                        размести a T-sized память chunk
                        
                ***************************************************************/

                T* размести ()
                {
                        if (cache is пусто)
                            newlist;
                        auto p = cache;
                        cache = p.следщ;
                        return cast(T*) p;
                }
        
                /***************************************************************
        
                        размести an Массив of T* sized память chunks
                        
                ***************************************************************/
        
                T*[] размести (т_мера счёт)
                {
                        return (cast(T**) calloc(счёт, (T*).sizeof)) [0 .. счёт];
                }
        
                /***************************************************************
        
                        Invoked when a specific T*[] is discarded
                        
                ***************************************************************/
        
                проц collect (T*[] t)
                {      
                        if (t.ptr)
                            free (t.ptr);
                }

                /***************************************************************
        
                        Invoked when a specific T is discarded
                        
                ***************************************************************/
        
                проц collect (T* p)
                {      
                        assert (p);
                        auto d = cast(Cache*) p;
                        d.следщ = cache;
                        cache = d;
                }
        
                /***************************************************************
        
                        Invoked when сотри/сбрось is called on the хост. 
                        This is a shortcut в_ сотри everything allocated.
        
                        Should return да if supported, or нет otherwise. 
                        Нет return will cause a series of discrete collect
                        calls
                        
                ***************************************************************/
        
                бул collect (бул все = да)
                {
                        if (все)
                           {
                           foreach (ref список; lists)
                                   {
                                   free (список.ptr);
                                   список = пусто;
                                   }
                           cache = пусто;
                           lists = пусто;
                           return да;
                           }
                        return нет;
                }
              
                /***************************************************************
        
                        установи the chunk размер and prepopulate with nodes
                        
                ***************************************************************/
        
                проц конфиг (т_мера chunks, цел размести=0)
                {
                        this.chunks = chunks;
                        if (размести)
                            for (цел i=размести/chunks+1; i--;)
                                 newlist;
                }
        
                /***************************************************************
        
                        список manager
                        
                ***************************************************************/
        
                private проц newlist ()
                {
                        lists.length = lists.length + 1;
                        auto p = (cast(T*) calloc (chunks, T.sizeof)) [0 .. chunks];
                        lists[$-1] = p;
                        auto голова = cache;
                        foreach (ref node; p)
                                {
                                auto d = cast(Cache*) &node;
                                d.следщ = голова;
                                голова = d;
                                }
                        cache = голова;
                }
        }        


        /***********************************************************************
        
                generic СМ allocation manager

                Slow and expensive in память costs
                
        ***********************************************************************/
        
        struct Collect(T)
        {
                /***************************************************************
        
                        размести a T sized память chunk
                        
                ***************************************************************/
        
                T* размести ()
                {       
                        return cast(T*) СМ.calloc (T.sizeof);
                }
        
                /***************************************************************
        
                        размести an Массив of T sized память chunks
                        
                ***************************************************************/
        
                T*[] размести (т_мера счёт)
                {
                        return new T*[счёт];
                }
        
                /***************************************************************
        
                        Invoked when a specific T[] is discarded
                        
                ***************************************************************/
        
                проц collect (T* p)
                {
                        if (p)
                            delete p;
                }
        
                /***************************************************************
        
                        Invoked when a specific T[] is discarded
                        
                ***************************************************************/
        
                проц collect (T*[] t)
                {      
                        if (t)
                            delete t;
                }

                /***************************************************************
        
                        Invoked when сотри/сбрось is called on the хост. 
                        This is a shortcut в_ сотри everything allocated.
        
                        Should return да if supported, or нет otherwise. 
                        Нет return will cause a series of discrete collect
                        calls

                ***************************************************************/
        
                бул collect (бул все = да)
                {
                        return нет;
                }

                /***************************************************************
        
                        установи the chunk размер and prepopulate with nodes
                        
                ***************************************************************/
        
                проц конфиг (т_мера chunks, цел размести=0)
                {
                }
        }        
        
                
        /***********************************************************************
        
                Malloc allocation manager.

                Note that, due в_ СМ behaviour, you should not конфигурируй
                a custom разместитель for containers holding anything managed
                by the СМ. For example, you cannot use a MallocAllocator
                в_ manage a container of classes or strings where those 
                were allocated by the СМ. Once something is owned by a СМ
                then it's lifetime must be managed by СМ-managed entities
                (otherwise the СМ may think there are no live references
                and prematurely collect container contents).
        
                You can explicity manage the collection of ключи and values
                yourself by provопрing a reaper delegate. For example, if 
                you use a MallocAllocator в_ manage ключ/значение pairs which
                are themselves allocated via malloc, then you should also
                provопрe a reaper delegate в_ collect those as required.      
                
        ***********************************************************************/
        
        struct Malloc(T)
        {
                /***************************************************************
        
                        размести an Массив of T sized память chunks
                        
                ***************************************************************/
        
                T* размести ()
                {
                        return cast(T*) calloc (1, T.sizeof);
                }
        
                /***************************************************************
        
                        размести an Массив of T sized память chunks
                        
                ***************************************************************/
        
                T*[] размести (т_мера счёт)
                {
                        return (cast(T**) calloc(счёт, (T*).sizeof)) [0 .. счёт];
                }
        
                /***************************************************************
        
                        Invoked when a specific T[] is discarded
                        
                ***************************************************************/
        
                проц collect (T*[] t)
                {      
                        if (t.length)
                            free (t.ptr);
                }

                /***************************************************************
        
                        Invoked when a specific T[] is discarded
                        
                ***************************************************************/
        
                проц collect (T* p)
                {       
                        if (p)
                            free (p);
                }
        
                /***************************************************************
        
                        Invoked when сотри/сбрось is called on the хост. 
                        This is a shortcut в_ сотри everything allocated.
        
                        Should return да if supported, or нет otherwise. 
                        Нет return will cause a series of discrete collect
                        calls
                        
                ***************************************************************/
        
                бул collect (бул все = да)
                {
                        return нет;
                }

                /***************************************************************
        
                        установи the chunk размер and prepopulate with nodes
                        
                ***************************************************************/
        
                проц конфиг (т_мера chunks, цел размести=0)
                {
                }
        }        
        
        
version (prior_allocator)
{
        /***********************************************************************
        
                GCChunk разместитель

                Like the Chunk разместитель, this allocates elements in chunks,
                but allows you в_ размести elements that can have СМ pointers.

                Tests have shown about a 60% speedup when using the СМ chunk
                разместитель for a Hashmap!(цел, цел).
        
        ***********************************************************************/

        struct GCChunk(T, бцел chunkSize)
        {
            static if(T.sizeof < (проц*).sizeof)
            {
                static assert(нет, "Ошибка, разместитель for " ~ T.stringof ~ " неудачно в_ instantiate");
            }

            /**
             * This is the form used в_ link recyclable elements together.
             */
            struct element
            {
                element *следщ;
            }

            /**
             * A chunk of elements
             */
            struct chunk
            {
                /**
                 * The следщ chunk in the chain
                 */
                chunk *следщ;

                /**
                 * The previous chunk in the chain.  Required for O(1) removal
                 * из_ the chain.
                 */
                chunk *prev;

                /**
                 * The linked список of free elements in the chunk.  This список is
                 * amended each время an element in this chunk is freed.
                 */
                element *freeList;

                /**
                 * The число of free elements in the freeList.  Used в_ determine
                 * whether this chunk can be given back в_ the СМ
                 */
                бцел numFree;

                /**
                 * The elements in the chunk.
                 */
                T[chunkSize] elems;

                /**
                 * Размести a T* из_ the free список.
                 */
                T *allocateFromFree()
                {
                    element *x = freeList;
                    freeList = x.следщ;
                    //
                    // сотри the pointer, this clears the element as if it was
                    // newly allocated
                    //
                    x.следщ = пусто;
                    numFree--;
                    return cast(T*)x;
                }

                /**
                 * deallocate a T*, шли it в_ the free список
                 *
                 * returns да if this chunk no longer есть any used elements.
                 */
                бул deallocate(T *t)
                {
                    //
                    // сотри the element so the СМ does not interpret the element
                    // as pointing в_ anything else.
                    //
                    memset(t, 0, (T).sizeof);
                    element *x = cast(element *)t;
                    x.следщ = freeList;
                    freeList = x;
                    return (++numFree == chunkSize);
                }
            }

            /**
             * The chain of used chunks.  Used chunks have had все their elements
             * allocated at least once.
             */
            chunk *used;

            /**
             * The fresh chunk.  This is only used if no elements are available in
             * the used chain.
             */
            chunk *fresh;

            /**
             * The следщ element in the fresh chunk.  Because we don't worry about
             * the free список in the fresh chunk, we need в_ keep track of the следщ
             * fresh element в_ use.
             */
            бцел nextFresh;

            /**
             * Размести a T*
             */
            T* размести()
            {
                if(used !is пусто && used.numFree > 0)
                {
                    //
                    // размести one element of the used список
                    //
                    T* результат = used.allocateFromFree();
                    if(used.numFree == 0)
                        //
                        // перемести used в_ the конец of the список
                        //
                        used = used.следщ;
                    return результат;
                }

                //
                // no used elements are available, размести out of the fresh
                // elements
                //
                if(fresh is пусто)
                {
                    fresh = new chunk;
                    nextFresh = 0;
                }

                T* результат = &fresh.elems[nextFresh];
                if(++nextFresh == chunkSize)
                {
                    if(used is пусто)
                    {
                        used = fresh;
                        fresh.следщ = fresh;
                        fresh.prev = fresh;
                    }
                    else
                    {
                        //
                        // вставь fresh преобр_в the used chain
                        //
                        fresh.prev = used.prev;
                        fresh.следщ = used;
                        fresh.prev.следщ = fresh;
                        fresh.следщ.prev = fresh;
                        if(fresh.numFree != 0)
                        {
                            //
                            // can recycle elements из_ fresh
                            //
                            used = fresh;
                        }
                    }
                    fresh = пусто;
                }
                return результат;
            }

            T*[] размести(бцел счёт)
            {
                return new T*[счёт];
            }


            /**
             * free a T*
             */
            проц collect(T* t)
            {
                //
                // need в_ figure out which chunk t is in
                //
                chunk *тек = cast(chunk *)СМ.AddrOf(t);

                if(тек !is fresh && тек.numFree == 0)
                {
                    //
                    // перемести тек в_ the front of the used список, it есть free nodes
                    // в_ be used.
                    //
                    if(тек !is used)
                    {
                        if(used.numFree != 0)
                        {
                            //
                            // first, unlink тек из_ its current location
                            //
                            тек.prev.следщ = тек.следщ;
                            тек.следщ.prev = тек.prev;

                            //
                            // сейчас, вставь тек before used.
                            //
                            тек.prev = used.prev;
                            тек.следщ = used;
                            used.prev = тек;
                            тек.prev.следщ = тек;
                        }
                        used = тек;
                    }
                }

                if(тек.deallocate(t))
                {
                    //
                    // тек no longer есть any elements in use, it can be deleted.
                    //
                    if(тек.следщ is тек)
                    {
                        //
                        // only one element, don't free it.
                        //
                    }
                    else
                    {
                        //
                        // удали тек из_ список
                        //
                        if(used is тек)
                        {
                            //
                            // обнови used pointer
                            //
                            used = used.следщ;
                        }
                        тек.следщ.prev = тек.prev;
                        тек.prev.следщ = тек.следщ;
                        delete тек;
                    }
                }
            }

            проц collect(T*[] t)
            {
                if(t)
                    delete t;
            }

            /**
             * Deallocate все chunks used by this разместитель.  Depends on the СМ в_ do
             * the actual collection
             */
            бул collect(бул все = да)
            {
                used = пусто;

                //
                // keep fresh around
                //
                if(fresh !is пусто)
                {
                    nextFresh = 0;
                    fresh.freeList = пусто;
                }

                return да;
            }

            проц конфиг (т_мера chunks, цел размести=0)
            {
            }
        }

        /***********************************************************************

                aliases в_ the correct Default разместитель depending on как big
                the тип is.  It makes less sense в_ use a GCChunk разместитель
                if the тип is going в_ be larger than a страница (currently there
                is no way в_ получи the страница размер из_ the СМ, so we assume 4096
                байты).  If not ещё than one unit can fit преобр_в a страница, then
                we use the default СМ разместитель.

        ***********************************************************************/
        template DefaultCollect(T)
        {
            static if((T).sizeof + ((проц*).sizeof * 3) + бцел.sizeof >= 4095 / 2)
            {
                alias Collect!(T) DefaultCollect;
            }
            else
            {
                alias GCChunk!(T, (4095 - ((проц *).sizeof * 3) - бцел.sizeof) / (T).sizeof) DefaultCollect;
            }
            // TODO: see if we can automatically figure out whether a тип есть
            // any pointers in it, this would allow automatic usage of the
            // Chunk разместитель for добавьed скорость.
        }
}
else
   template DefaultCollect(T) {alias ChunkGC!(T) DefaultCollect;}

}


