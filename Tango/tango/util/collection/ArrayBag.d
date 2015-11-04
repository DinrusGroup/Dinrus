/*
 Файл: ArrayBag.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ сохрани.d  working файл
 13Oct95  dl                 Changed protection statuses

*/


module util.collection.ArrayBag;

private import  exception;

private import  util.collection.model.GuardIterator;

private import  util.collection.impl.CLCell,
                util.collection.impl.BagCollection,
                util.collection.impl.AbstractIterator;



/**
 *
 * Linked Буфер implementation of Bags. The Bag consists of
 * any число of buffers holding elements, arranged in a список.
 * Each буфер holds an Массив of elements. The размер of each
 * буфер is the значение of chunkSize that was current during the
 * operation that caused the Bag в_ grow. The chunkSize() may
 * be adjusted at any время. (It is not consопрered a version change.)
 * 
 * <P>
 * все but the final буфер is always kept full.
 * When a буфер есть no elements, it is released (so is
 * available for garbage collection).
 * <P>
 * ArrayBags are good choices for collections in which
 * you merely помести a lot of things in, and then look at
 * them via enumerations, but don't often look for
 * particular elements.
 * 
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

deprecated public class ArrayBag(T) : BagCollection!(T)
{
        alias CLCell!(T[]) CLCellT;

        alias BagCollection!(T).удали     удали;
        alias BagCollection!(T).removeAll  removeAll;

        /**
         * The default chunk размер в_ use for buffers
        **/

        public static цел defaultChunkSize = 32;

        // экземпляр variables

        /**
         * The последний node of the circular список of chunks. Пусто if пустой.
        **/

        package CLCellT хвост;

        /**
         * The число of elements of the хвост node actually used. (все другие
         * are kept full).
        **/
        protected цел lastCount;

        /**
         * The chunk размер в_ use for making следщ буфер
        **/

        protected цел chunkSize_;

        // constructors

        /**
         * Make an пустой буфер.
        **/
        public this ()
        {
                this (пусто, 0, пусто, 0, defaultChunkSize);
        }

        /**
         * Make an пустой буфер, using the supplied element screener.
        **/

        public this (Predicate s)
        {
                this (s, 0, пусто, 0, defaultChunkSize);
        }

        /**
         * Special version of constructor needed by clone()
        **/
        protected this (Predicate s, цел n, CLCellT t, цел lc, цел cs)
        {
                super (s);
                счёт = n;
                хвост = t;
                lastCount = lc;
                chunkSize_ = cs;
        }

        /**
         * Make an independent копируй. Does not clone elements.
        **/ 

        public final ArrayBag!(T) duplicate ()
        {
                if (счёт is 0)
                    return new ArrayBag!(T) (screener);
                else
                   {
                   CLCellT h = хвост.copyList();
                   CLCellT p = h;

                   do {
                      T[] obuff = p.element();
                      T[] nbuff = new T[obuff.length];

                      for (цел i = 0; i < obuff.length; ++i)
                           nbuff[i] = obuff[i];

                      p.element(nbuff);
                      p = p.следщ();
                      } while (p !is h);

                   return new ArrayBag!(T) (screener, счёт, h, lastCount, chunkSize_);
                   }
        }


        /**
         * Report the chunk размер used when добавьing new buffers в_ the список
        **/

        public final цел chunkSize()
        {
                return chunkSize_;
        }

        /**
         * Набор the chunk размер в_ be used when добавьing new buffers в_ the 
         * список during future добавь() operations.
         * Any значение greater than 0 is ОК. (A значение of 1 makes this a
         * преобр_в very slow simulation of a linked список!)
        **/

        public final проц chunkSize (цел newChunkSize)
        {
                if (newChunkSize > 0)
                    chunkSize_ = newChunkSize;
                else
                   throw new ИсклНелегальногоАргумента("Attempt в_ установи negative chunk размер значение");
        }

        // Collection methods

        /*
          This код is pretty repetitive, but I don't know a nice way в_
          separate traversal logic из_ actions
        */

        /**
         * Implements util.collection.impl.Collection.Collection.содержит
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.содержит
        **/
        public final бул содержит(T element)
        {
                if (!isValопрArg(element) || счёт is 0)
                     return нет;

                CLCellT p = хвост.следщ();

                for (;;)
                    {
                    T[] buff = p.element();
                    бул isLast = p is хвост;

                    цел n;
                    if (isLast)
                        n = lastCount;
                    else
                       n = buff.length;

                    for (цел i = 0; i < n; ++i)
                        {
                        if (buff[i] == (element))
                        return да;
                        }

                    if (isLast)
                        break;
                    else
                       p = p.следщ();
                    }
                return нет;
        }

        /**
         * Implements util.collection.impl.Collection.Collection.instances
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.instances
        **/
        public final бцел instances(T element)
        {
                if (!isValопрArg(element) || счёт is 0)
                    return 0;

                бцел c = 0;
                CLCellT p = хвост.следщ();

                for (;;)
                    {
                    T[] buff = p.element();
                    бул isLast = p is хвост;

                    цел n;
                    if (isLast)
                        n = lastCount;
                    else
                       n = buff.length;

                    for (цел i = 0; i < n; ++i)
                       {
                       if (buff[i] == (element))
                           ++c;
                       }

                    if (isLast)
                        break;
                    else
                       p = p.следщ();
                    }
                return c;
        }

        /**
         * Implements util.collection.impl.Collection.Collection.elements
         * Время complexity: O(1).
         * See_Also: util.collection.impl.Collection.Collection.elements
        **/
        public final GuardIterator!(T) elements()
        {
                return new ArrayIterator!(T)(this);
        }

        /**
         * Implements util.collection.model.View.View.opApply
         * Время complexity: O(n).
         * See_Also: util.collection.model.View.View.opApply
        **/
        цел opApply (цел delegate (inout T значение) дг)
        {
                auto scope iterator = new ArrayIterator!(T)(this);
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
                хвост = пусто;
                lastCount = 0;
        }

        /**
         * Implements util.collection.impl.Collection.Collection.removeAll.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.removeAll
        **/
        public final проц removeAll (T element)
        {
                удали_(element, да);
        }


        /**
         * Implements util.collection.impl.Collection.Collection.removeOneOf.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.removeOneOf
        **/
        public final проц удали(T element)
        {
                удали_(element, нет);
        }

        /**
         * Implements util.collection.impl.Collection.Collection.replaceOneOf
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.replaceOneOf
        **/
        public final проц замени(T oldElement, T newElement)
        {
                замени_(oldElement, newElement, нет);
        }

        /**
         * Implements util.collection.impl.Collection.Collection.replaceAllOf.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.replaceAllOf
        **/
        public final проц replaceAll(T oldElement, T newElement)
        {
                замени_(oldElement, newElement, да);
        }

        /**
         * Implements util.collection.impl.Collection.Collection.take.
         * Время complexity: O(1).
         * Takes the least element.
         * See_Also: util.collection.impl.Collection.Collection.take
        **/
        public final T take()
        {
                if (счёт !is 0)
                   {
                   T[] buff = хвост.element();
                   T v = buff[lastCount -1];
                   buff[lastCount -1] = T.init;
                   shrink_();
                   return v;
                   }
                checkIndex(0);
                return T.init; // not reached
        }



        // MutableBag methods

        /**
         * Implements util.collection.MutableBag.добавьIfAbsent.
         * Время complexity: O(n).
         * See_Also: util.collection.MutableBag.добавьIfAbsent
        **/
        public final проц добавьIf(T element)
        {
                if (!содержит(element))
                     добавь (element);
        }


        /**
         * Implements util.collection.MutableBag.добавь.
         * Время complexity: O(1).
         * See_Also: util.collection.MutableBag.добавь
        **/
        public final проц добавь (T element)
        {
                checkElement(element);

                incCount();
                if (хвост is пусто)
                   {
                   хвост = new CLCellT(new T[chunkSize_]);
                   lastCount = 0;
                   }

                T[] buff = хвост.element();
                if (lastCount is buff.length)
                   {
                   buff = new T[chunkSize_];
                   хвост.добавьNext(buff);
                   хвост = хвост.следщ();
                   lastCount = 0;
                   }

                buff[lastCount++] = element;
        }

        /**
         * helper for удали/exclude
        **/

        private final проц удали_(T element, бул allOccurrences)
        {
                if (!isValопрArg(element) || счёт is 0)
                     return ;

                CLCellT p = хвост;

                for (;;)
                    {
                    T[] buff = p.element();
                    цел i = (p is хвост) ? lastCount - 1 : buff.length - 1;
                    
                    while (i >= 0)
                          {
                          if (buff[i] == (element))
                             {
                             T[] lastBuff = хвост.element();
                             buff[i] = lastBuff[lastCount -1];
                             lastBuff[lastCount -1] = T.init;
                             shrink_();
        
                             if (!allOccurrences || счёт is 0)
                                  return ;
        
                             if (p is хвост && i >= lastCount)
                                 i = lastCount -1;
                             }
                          else
                             --i;
                          }

                    if (p is хвост.следщ())
                        break;
                    else
                       p = p.prev();
                }
        }

        private final проц замени_(T oldElement, T newElement, бул allOccurrences)
        {
                if (!isValопрArg(oldElement) || счёт is 0 || oldElement == (newElement))
                     return ;

                CLCellT p = хвост.следщ();

                for (;;)
                    {
                    T[] buff = p.element();
                    бул isLast = p is хвост;

                    цел n;
                    if (isLast)
                        n = lastCount;
                    else
                       n = buff.length;

                    for (цел i = 0; i < n; ++i)
                        {
                        if (buff[i] == (oldElement))
                           {
                           checkElement(newElement);
                           incVersion();
                           buff[i] = newElement;
                           if (!allOccurrences)
                           return ;
                           }
                        }

                    if (isLast)
                        break;
                    else
                       p = p.следщ();
                    }
        }

        private final проц shrink_()
        {
                decCount();
                lastCount--;
                if (lastCount is 0)
                   {
                   if (счёт is 0)
                       сотри();
                   else
                      {
                      CLCellT врем = хвост;
                      хвост = хвост.prev();
                      врем.unlink();
                      T[] buff = хвост.element();
                      lastCount = buff.length;
                      }
                   }
        }

        // ImplementationCheckable methods

        /**
         * Implements util.collection.model.View.View.checkImplementation.
         * See_Also: util.collection.model.View.View.checkImplementation
        **/
        public override проц checkImplementation()
        {

                super.checkImplementation();
                assert(chunkSize_ >= 0);
                assert(lastCount >= 0);
                assert(((счёт is 0) is (хвост is пусто)));

                if (хвост is пусто)
                    return ;

                цел c = 0;
                CLCellT p = хвост.следщ();

                for (;;)
                    {
                    T[] buff = p.element();
                    бул isLast = p is хвост;

                    цел n;
                    if (isLast)
                        n = lastCount;
                    else
                       n = buff.length;
   
                    c += n;
                    for (цел i = 0; i < n; ++i)
                        {
                        auto v = buff[i];
                        assert(allows(v) && содержит(v));
                        }
   
                    if (isLast)
                        break;
                    else
                       p = p.следщ();
                    }

                assert(c is счёт);

        }



        /***********************************************************************

                opApply() есть migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        static class ArrayIterator(T) : AbstractIterator!(T)
        {
                private CLCellT cell;
                private T[]     buff;
                private цел     индекс;

                public this (ArrayBag bag)
                {
                        super(bag);
                        cell = bag.хвост;
                        
                        if (cell)
                            buff = cell.element();  
                }

                public final T получи()
                {
                        decRemaining();
                        if (индекс >= buff.length)
                           {
                           cell = cell.следщ();
                           buff = cell.element();
                           индекс = 0;
                           }
                        return buff[индекс++];
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
                auto bag = new ArrayBag!(ткст);
                bag.добавь ("foo");
                bag.добавь ("bar");
                bag.добавь ("wumpus");

                foreach (значение; bag.elements) {}

                auto elements = bag.elements();
                while (elements.ещё)
                       auto v = elements.получи();

                foreach (значение; bag)
                         Квывод (значение).нс;

                bag.checkImplementation();

                Квывод (bag).нс;
        }
}
