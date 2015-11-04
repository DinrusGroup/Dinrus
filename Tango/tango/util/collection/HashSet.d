/*
 Файл: HashSet.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ util.collection.d  working файл
 13Oct95  dl                 Changed protection statuses

*/


module util.collection.HashSet;

private import  exception;

private import  util.collection.model.Iterator,
                util.collection.model.HashParams,
                util.collection.model.GuardIterator;

private import  util.collection.impl.LLCell,
                util.collection.impl.SetCollection,
                util.collection.impl.AbstractIterator;


/**
 *
 * Hash table implementation of установи
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

deprecated public class HashSet(T) : SetCollection!(T), HashParams
{
        private alias LLCell!(T) LLCellT;

        alias SetCollection!(T).удали     удали;
        alias SetCollection!(T).removeAll  removeAll;


        // экземпляр variables

        /**
         * The table. Each Запись is a список. Пусто if no table allocated
        **/
        private LLCellT table[];
        /**
         * The threshold загрузи factor
        **/
        private плав loadFactor;


        // constructors

        /**
         * Make an пустой HashedSet.
        **/

        public this ()
        {
                this(пусто, defaultLoadFactor);
        }

        /**
         * Make an пустой HashedSet using given element screener
        **/

        public this (Predicate screener)
        {
                this(screener, defaultLoadFactor);
        }

        /**
         * Special version of constructor needed by clone()
        **/

        protected this (Predicate s, плав f)
        {
                super(s);
                table = пусто;
                loadFactor = f;
        }

        /**
         * Make an independent копируй of the table. Does not clone elements.
        **/

        public final HashSet!(T) duplicate()
        {
                auto c = new HashSet!(T) (screener, loadFactor);

                if (счёт !is 0)
                   {
                   цел cap = 2 * cast(цел)(счёт / loadFactor) + 1;
                   if (cap < defaultInitialBuckets)
                       cap = defaultInitialBuckets;

                   c.buckets(cap);
                   for (цел i = 0; i < table.length; ++i)
                        for (LLCellT p = table[i]; p !is пусто; p = p.следщ())
                             c.добавь(p.element());
                   }
                return c;
        }


        // HashTableParams methods

        /**
         * Implements util.collection.HashTableParams.buckets.
         * Время complexity: O(1).
         * See_Also: util.collection.HashTableParams.buckets.
        **/

        public final цел buckets()
        {
                return (table is пусто) ? 0 : table.length;
        }

        /**
         * Implements util.collection.HashTableParams.buckets.
         * Время complexity: O(n).
         * See_Also: util.collection.HashTableParams.buckets.
        **/

        public final проц buckets(цел newCap)
        {
                if (newCap is buckets())
                    return ;
                else
                   if (newCap >= 1)
                       resize(newCap);
                   else
                      {
                      сим[16] врем;
                      throw new ИсклНелегальногоАргумента("Impossible Hash table размер:" ~ itoa(врем, newCap));
                      }
        }

        /**
         * Implements util.collection.HashTableParams.thresholdLoadfactor
         * Время complexity: O(1).
         * See_Also: util.collection.HashTableParams.thresholdLoadfactor
        **/

        public final плав пороговыйФакторЗагрузки()
        {
                return loadFactor;
        }

        /**
         * Implements util.collection.HashTableParams.thresholdLoadfactor
         * Время complexity: O(n).
         * See_Also: util.collection.HashTableParams.thresholdLoadfactor
        **/

        public final проц пороговыйФакторЗагрузки(плав desired)
        {
                if (desired > 0.0)
                   {
                   loadFactor = desired;
                   checkLoadFactor();
                   }
                else
                   throw new ИсклНелегальногоАргумента("Invalid Hash table загрузи factor");
        }





        // Collection methods

        /**
         * Implements util.collection.impl.Collection.Collection.содержит
         * Время complexity: O(1) average; O(n) worst.
         * See_Also: util.collection.impl.Collection.Collection.содержит
        **/
        public final бул содержит(T element)
        {
                if (!isValопрArg(element) || счёт is 0)
                     return нет;

                LLCellT p = table[hashOf(element)];
                if (p !is пусто)
                    return p.найди(element) !is пусто;
                else
                   return нет;
        }

        /**
         * Implements util.collection.impl.Collection.Collection.instances
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.instances
        **/
        public final бцел instances(T element)
        {
                if (содержит(element))
                    return 1;
                else
                   return 0;
        }

        /**
         * Implements util.collection.impl.Collection.Collection.elements
         * Время complexity: O(1).
         * See_Also: util.collection.impl.Collection.Collection.elements
        **/
        public final GuardIterator!(T) elements()
        {
                return new CellIterator!(T)(this);
        }

        /**
         * Implements util.collection.model.View.View.opApply
         * Время complexity: O(n).
         * See_Also: util.collection.model.View.View.opApply
        **/
        цел opApply (цел delegate (inout T значение) дг)
        {
                auto scope iterator = new CellIterator!(T)(this);
                return iterator.opApply (дг);
        }

        // MutableCollection methods

        /**
         * Implements util.collection.impl.Collection.Collection.сотри.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.Collection.Collection.сотри
        **/
        public final проц сотри()
        {
                setCount(0);
                table = пусто;
        }

        /**
         * Implements util.collection.impl.Collection.Collection.exclude.
         * Время complexity: O(1) average; O(n) worst.
         * See_Also: util.collection.impl.Collection.Collection.exclude
        **/
        public final проц removeAll(T element)
        {
                удали(element);
        }

        public final проц удали(T element)
        {
                if (!isValопрArg(element) || счёт is 0)
                    return ;

                цел h = hashOf(element);
                LLCellT hd = table[h];
                LLCellT p = hd;
                LLCellT trail = p;

                while (p !is пусто)
                      {
                      LLCellT n = p.следщ();
                      if (p.element() == (element))
                         {
                         decCount();
                         if (p is table[h])
                            {
                            table[h] = n;
                            trail = n;
                            }
                         else
                            trail.следщ(n);
                         return ;
                         } 
                      else
                         {
                         trail = p;
                         p = n;
                         }
                      }
        }

        public final проц замени(T oldElement, T newElement)
        {

                if (счёт is 0 || !isValопрArg(oldElement) || oldElement == (newElement))
                    return ;

                if (содержит(oldElement))
                   {
                   checkElement(newElement);
                   удали(oldElement);
                   добавь(newElement);
                   }
        }

        public final проц replaceAll(T oldElement, T newElement)
        {
                замени(oldElement, newElement);
        }

        /**
         * Implements util.collection.impl.Collection.Collection.take.
         * Время complexity: O(число of buckets).
         * See_Also: util.collection.impl.Collection.Collection.take
        **/
        public final T take()
        {
                if (счёт !is 0)
                   {
                   for (цел i = 0; i < table.length; ++i)
                       {
                       if (table[i] !is пусто)
                          {
                          decCount();
                          auto v = table[i].element();
                          table[i] = table[i].следщ();
                          return v;
                          }
                       }
                   }

                checkIndex(0);
                return T.init; // not reached
        }


        // MutableSet methods

        /**
         * Implements util.collection.impl.SetCollection.SetCollection.добавь.
         * Время complexity: O(1) average; O(n) worst.
         * See_Also: util.collection.impl.SetCollection.SetCollection.добавь
        **/
        public final проц добавь(T element)
        {
                checkElement(element);

                if (table is пусто)
                    resize(defaultInitialBuckets);

                цел h = hashOf(element);
                LLCellT hd = table[h];
                if (hd !is пусто && hd.найди(element) !is пусто)
                    return ;

                LLCellT n = new LLCellT(element, hd);
                table[h] = n;
                incCount();

                if (hd !is пусто)
                    checkLoadFactor(); // only check if bin was Неукmpty
        }



        // Helper methods

        /**
         * Check в_ see if we are past загрузи factor threshold. If so, resize
         * so that we are at half of the desired threshold.
         * Also while at it, check в_ see if we are пустой so can just
         * unlink table.
        **/
        protected final проц checkLoadFactor()
        {
                if (table is пусто)
                   {
                   if (счёт !is 0)
                       resize(defaultInitialBuckets);
                   }
                else
                   {
                   плав fc = cast(плав) (счёт);
                   плав ft = table.length;
                   if (fc / ft > loadFactor)
                      {
                      цел newCap = 2 * cast(цел)(fc / loadFactor) + 1;
                      resize(newCap);
                      }
                   }
        }

        /**
         * маска off and remainder the hashCode for element
         * so it can be used as table индекс
        **/

        protected final цел hashOf(T element)
        {
                return (typeid(T).дайХэш(&element) & 0x7FFFFFFF) % table.length;
        }


        /**
         * resize table в_ new ёмкость, rehashing все elements
        **/
        protected final проц resize(цел newCap)
        {
                LLCellT newtab[] = new LLCellT[newCap];

                if (table !is пусто)
                   {
                   for (цел i = 0; i < table.length; ++i)
                       {
                       LLCellT p = table[i];
                       while (p !is пусто)
                             {
                             LLCellT n = p.следщ();
                             цел h = (p.elementHash() & 0x7FFFFFFF) % newCap;
                             p.следщ(newtab[h]);
                             newtab[h] = p;
                             p = n;
                             }
                       }
                   }

                table = newtab;
                incVersion();
        }

        /+
        private final проц readObject(java.io.ObjectInputПоток поток)

        {
                цел длин = поток.readInt();

                if (длин > 0)
                    table = new LLCellT[длин];
                else
                   table = пусто;

                loadFactor = поток.readFloat();
                цел счёт = поток.readInt();

                while (счёт-- > 0)
                      {
                      T element = поток.readObject();
                      цел h = hashOf(element);
                      LLCellT hd = table[h];
                      LLCellT n = new LLCellT(element, hd);
                      table[h] = n;
                      }
        }

        private final проц writeObject(java.io.ObjectOutputПоток поток)
        {
                цел длин;

                if (table !is пусто)
                    длин = table.length;
                else
                   длин = 0;

                поток.writeInt(длин);
                поток.writeFloat(loadFactor);
                поток.writeInt(счёт);

                if (длин > 0)
                   {
                   Обходчик e = elements();
                   while (e.ещё())
                          поток.writeObject(e.значение());
                   }
        }

        +/

        // ImplementationCheckable methods

        /**
         * Implements util.collection.model.View.View.checkImplementation.
         * See_Also: util.collection.model.View.View.checkImplementation
        **/
        public override проц checkImplementation()
        {
                super.checkImplementation();

                assert(!(table is пусто && счёт !is 0));
                assert((table is пусто || table.length > 0));
                assert(loadFactor > 0.0f);

                if (table !is пусто)
                   {
                   цел c = 0;
                   for (цел i = 0; i < table.length; ++i)
                       {
                       for (LLCellT p = table[i]; p !is пусто; p = p.следщ())
                           {
                           ++c;
                           assert(allows(p.element()));
                           assert(содержит(p.element()));
                           assert(instances(p.element()) is 1);
                           assert(hashOf(p.element()) is i);
                           }
                       }
                   assert(c is счёт);
                   }
        }



        /***********************************************************************

                opApply() есть migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        private static class CellIterator(T) : AbstractIterator!(T)
        {
                private цел             row;
                private LLCellT         cell;
                private LLCellT[]       table;

                public this (HashSet установи)
                {
                        super (установи);
                        table = установи.table;
                }

                public final T получи()
                {
                        decRemaining();

                        while (cell is пусто)
                               cell = table [row++];

                        auto v = cell.element();
                        cell = cell.следщ();
                        return v;
                }

                цел opApply (цел delegate (inout T значение) дг)
                {
                        цел результат;

                        for (auto i=remaining(); i--;)
                            {
                            auto значение = получи();
                            if ((результат = дг(значение)) != 0)
                                 break;
                            }
                        return результат;
                }
        }
}



debug (Test)
{
        import io.Console;
        
        проц main()
        {
                auto установи = new HashSet!(ткст);
                установи.добавь ("foo");
                установи.добавь ("bar");
                установи.добавь ("wumpus");

                foreach (значение; установи.elements) {}

                auto elements = установи.elements();
                while (elements.ещё)
                       auto v = elements.получи();

                установи.checkImplementation();

                foreach (значение; установи)
                         Квывод (значение).нс;
        }
}



debug (HashSet)
{
        import io.Stdout;
        import thread;
        import time.StopWatch;
        
        проц main()
        {
                // установи for benchmark, with a установи of целыйs. We
                // use a chunk разместитель, and presize the bucket[]
                auto тест = new HashSet!(цел);
                тест.buckets = 700_000;
                const счёт = 500_000;
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
                auto dup = тест.duplicate;
                Стдвыв.форматнс ("{} element dup: {}/s", dup.размер, dup.размер/w.stop);

                // benchmark iteration
                w.старт;
                foreach (значение; тест) {}
                Стдвыв.форматнс ("{} element iteration: {}/s", тест.размер, тест.размер/w.stop);
                Нить.сон (3);
        }
}
