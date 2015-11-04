/*
 Файл: ArraySeq.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 2Oct95  dl@cs.oswego.edu   refactored из_ DASeq.d
 13Oct95  dl                 Changed protection statuses

*/

        
module util.collection.ArraySeq;

private import  util.collection.model.Iterator,
                util.collection.model.Sortable,
                util.collection.model.Comparator,
                util.collection.model.GuardIterator;

private import  util.collection.impl.SeqCollection,
                util.collection.impl.AbstractIterator;


/**
 *
 * Dynamically allocated and resized Arrays.
 * 
 * Beyond implementing its interfaces, добавьs methods
 * в_ исправь capacities. The default heuristics for resizing
 * usually work fine, but you can исправь them manually when
 * you need в_.
 *
 * ArraySeqs are generally like java.util.Vectors. But unlike them,
 * ArraySeqs do not actually размести массивы when they are constructed.
 * Among другой consequences, you can исправь the ёмкость `for free'
 * after construction but before добавьing elements. You can исправь
 * it at другой times as well, but this may lead в_ ещё expensive
 * resizing. Also, unlike Vectors, they release their internal массивы
 * whenever they are пустой.
 *
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

deprecated public class ArraySeq(T) : SeqCollection!(T), Sortable!(T)
{
        alias SeqCollection!(T).удали     удали;
        alias SeqCollection!(T).removeAll  removeAll;

        /**
         * The minimum ёмкость of any non-пустой буфер
        **/

        public static цел minCapacity = 16;


        // экземпляр variables

        /**
         * The elements, or пусто if no буфер yet allocated.
        **/

        package T Массив[];


        // constructors

        /**
         * Make a new пустой ArraySeq. 
        **/

        public this ()
        {
                this (пусто, пусто, 0);
        }

        /**
         * Make an пустой ArraySeq with given element screener
        **/

        public this (Predicate screener)
        {
                this (screener, пусто, 0);
        }

        /**
         * Special version of constructor needed by clone()
        **/
        package this (Predicate s, T[] b, цел c)
        {
                super(s);
                Массив = b;
                счёт = c;
        }

        /**
         * Make an independent копируй. The elements themselves are not cloned
        **/

        public final ArraySeq!(T) duplicate()
        {
                цел cap = счёт;
                if (cap is 0)
                    return new ArraySeq!(T) (screener, пусто, 0);
                else
                   {
                   if (cap < minCapacity)
                       cap = minCapacity;

                   T newArray[] = new T[cap];
                   //System.копируй (Массив[0].sizeof, Массив, 0, newArray, 0, счёт);

                   newArray[0..счёт] = Массив[0..счёт];
                   return new ArraySeq!(T)(screener, newArray, счёт);
                   }
        }

        // methods introduced _in ArraySeq

        /**
         * return the current internal буфер ёмкость (zero if no буфер allocated).
         * Возвращает: ёмкость (always greater than or equal в_ размер())
        **/

        public final цел ёмкость()
        {
                return (Массив is пусто) ? 0 : Массив.length;
        }

        /**
         * Набор the internal буфер ёмкость в_ max(размер(), newCap).
         * That is, if given an аргумент less than the current
         * число of elements, the ёмкость is just установи в_ the
         * current число of elements. Thus, elements are never lost
         * by настройка the ёмкость. 
         * 
         * @param newCap the desired ёмкость.
         * Возвращает: condition: 
         * <PRE>
         * ёмкость() >= размер() &&
         * version() != PREV(this).version() == (ёмкость() != PREV(this).ёмкость())
         * </PRE>
        **/

        public final проц ёмкость(цел newCap)
        {
                if (newCap < счёт)
                    newCap = счёт;

                if (newCap is 0)
                   {
                   сотри();
                   }
                else
                   if (Массив is пусто)
                      {
                      Массив = new T[newCap];
                      incVersion();
                      }
                   else
                      if (newCap !is Массив.length)
                         {
                         //T newArray[] = new T[newCap];
                         //newArray[0..счёт] = Массив[0..счёт];
                         //Массив = newArray;
                         Массив ~= new T[newCap - Массив.length];
                         incVersion();
                         }
        }


        // Collection methods

        /**
         * Implements util.collection.impl.Collection.Collection.содержит
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.содержит
        **/
        public final бул содержит(T element)
        {
                if (! isValопрArg (element))
                      return нет;

                for (цел i = 0; i < счёт; ++i)
                     if (Массив[i] == (element))
                         return да;
                return нет;
        }

        /**
         * Implements util.collection.impl.Collection.Collection.instances
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.instances
        **/
        public final бцел instances(T element)
        {
                if (! isValопрArg(element))
                      return 0;

                бцел c = 0;
                for (бцел i = 0; i < счёт; ++i)
                     if (Массив[i] == (element))
                         ++c;
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


        // Seq methods:

        /**
         * Implements util.collection.model.Seq.Seq.голова.
         * Время complexity: O(1).
         * See_Also: util.collection.model.Seq.Seq.голова
        **/
        public final T голова()
        {
                checkIndex(0);
                return Массив[0];
        }

        /**
         * Implements util.collection.model.Seq.Seq.хвост.
         * Время complexity: O(1).
         * See_Also: util.collection.model.Seq.Seq.хвост
        **/
        public final T хвост()
        {
                checkIndex(счёт -1);
                return Массив[счёт -1];
        }

        /**
         * Implements util.collection.model.Seq.Seq.получи.
         * Время complexity: O(1).
         * See_Also: util.collection.model.Seq.Seq.получи
        **/
        public final T получи(цел индекс)
        in {
           checkIndex(индекс);
           }
        body
        {
                return Массив[индекс];
        }

        /**
         * Implements util.collection.model.Seq.Seq.first.
         * Время complexity: O(n).
         * See_Also: util.collection.model.Seq.Seq.first
        **/
        public final цел first(T element, цел startingIndex = 0)
        {
                if (startingIndex < 0)
                    startingIndex = 0;

                for (цел i = startingIndex; i < счёт; ++i)
                     if (Массив[i] == (element))
                         return i;
                return -1;
        }

        /**
         * Implements util.collection.model.Seq.Seq.последний.
         * Время complexity: O(n).
         * See_Also: util.collection.model.Seq.Seq.последний
        **/
        public final цел последний(T element, цел startingIndex = 0)
        {
                if (startingIndex >= счёт)
                    startingIndex = счёт -1;
 
                for (цел i = startingIndex; i >= 0; --i)
                     if (Массив[i] == (element))
                         return i;
                return -1;
        }


        /**
         * Implements util.collection.model.Seq.Seq.subseq.
         * Время complexity: O(length).
         * See_Also: util.collection.model.Seq.Seq.subseq
        **/
        public final ArraySeq поднабор (цел из_, цел _length)
        {
                if (_length > 0)
                   {
                   checkIndex(из_);
                   checkIndex(из_ + _length - 1);

                   T newArray[] = new T[_length];
                   //System.копируй (Массив[0].sizeof, Массив, из_, newArray, 0, _length);

                   newArray[0.._length] = Массив[из_..из_+_length];
                   return new ArraySeq!(T)(screener, newArray, _length);
                   }
                else
                   return new ArraySeq!(T)(screener);
        }


        // MutableCollection methods

        /**
         * Implements util.collection.impl.Collection.Collection.сотри.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.Collection.Collection.сотри
        **/
        public final проц сотри()
        {
                Массив = пусто;
                setCount(0);
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
         * Время complexity: O(n * число of replacements).
         * See_Also: util.collection.impl.Collection.Collection.replaceAllOf
        **/
        public final проц replaceAll(T oldElement, T newElement)
        {
                замени_(oldElement, newElement, да);
        }

        /**
         * Implements util.collection.impl.Collection.Collection.exclude.
         * Время complexity: O(n * instances(element)).
         * See_Also: util.collection.impl.Collection.Collection.exclude
        **/
        public final проц removeAll(T element)
        {
                удали_(element, да);
        }

        /**
         * Implements util.collection.impl.Collection.Collection.take.
         * Время complexity: O(1).
         * Takes the rightmost element of the Массив.
         * See_Also: util.collection.impl.Collection.Collection.take
        **/
        public final T take()
        {
                T v = хвост();
                removeTail();
                return v;
        }


        // SortableCollection methods:


        /**
         * Implements util.collection.SortableCollection.сортируй.
         * Время complexity: O(n лог n).
         * Uses a быстросорт-based algorithm.
         * See_Also: util.collection.SortableCollection.сортируй
        **/
        public проц сортируй(Comparator!(T) cmp)
        {
                if (счёт > 0)
                   {
                   быстрСорт(Массив, 0, счёт - 1, cmp);
                   incVersion();
                   }
        }


        // MutableSeq methods

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.приставь.
         * Время complexity: O(n)
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.приставь
        **/
        public final проц приставь(T element)
        {
                checkElement(element);
                growBy_(1);
                for (цел i = счёт -1; i > 0; --i)
                     Массив[i] = Массив[i - 1];
                Массив[0] = element;
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.замениГолову.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.замениГолову
        **/
        public final проц замениГолову(T element)
        {
                checkElement(element);
                Массив[0] = element;
                incVersion();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.removeHead.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.removeHead
        **/
        public final проц removeHead()
        {
                removeAt(0);
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавь.
         * Время complexity: normally O(1), but O(n) if размер() == ёмкость().
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавь
        **/
        public final проц добавь(T element)
        in {
           checkElement (element);
           }
        body
        {
                цел последний = счёт;
                growBy_(1);
                Массив[последний] = element;
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.замениХвост.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.замениХвост
        **/
        public final проц замениХвост(T element)
        {
                checkElement(element);
                Массив[счёт -1] = element;
                incVersion();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.removeTail.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.removeTail
        **/
        public final проц removeTail()
        {
                checkIndex(0);
                Массив[счёт -1] = T.init;
                growBy_( -1);
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавьAt.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавьAt
        **/
        public final проц добавьAt(цел индекс, T element)
        {
                if (индекс !is счёт)
                    checkIndex(индекс);

                checkElement(element);
                growBy_(1);
                for (цел i = счёт -1; i > индекс; --i)
                     Массив[i] = Массив[i - 1];
                Массив[индекс] = element;
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.удали.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.removeAt
        **/
        public final проц removeAt(цел индекс)
        {
                checkIndex(индекс);
                for (цел i = индекс + 1; i < счёт; ++i)
                     Массив[i - 1] = Массив[i];
                Массив[счёт -1] = T.init;
                growBy_( -1);
        }


        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.replaceAt.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.replaceAt
        **/
        public final проц replaceAt(цел индекс, T element)
        {
                checkIndex(индекс);
                checkElement(element);
                Массив[индекс] = element;
                incVersion();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.приставь.
         * Время complexity: O(n + число of elements in e) if (e 
         * instanceof CollectionIterator) else O(n * число of elements in e)
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.приставь
        **/
        public final проц приставь(Обходчик!(T) e)
        {
                insert_(0, e);
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавь.
         * Время complexity: O(число of elements in e) 
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавь
        **/
        public final проц добавь(Обходчик!(T) e)
        {
                insert_(счёт, e);
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавьAt.
         * Время complexity: O(n + число of elements in e) if (e 
         * instanceof CollectionIterator) else O(n * число of elements in e)
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавьAt
        **/
        public final проц добавьAt(цел индекс, Обходчик!(T) e)
        {
                if (индекс !is счёт)
                    checkIndex(индекс);
                insert_(индекс, e);
        }


        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.removeFromTo.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.removeFromTo
        **/
        public final проц removeRange (цел fromIndex, цел toIndex)
        {
                checkIndex(fromIndex);
                checkIndex(toIndex);
                if (fromIndex <= toIndex)
                   {
                   цел gap = toIndex - fromIndex + 1;
                   цел j = fromIndex;
                   for (цел i = toIndex + 1; i < счёт; ++i)
                        Массив[j++] = Массив[i];
 
                   for (цел i = 1; i <= gap; ++i)
                        Массив[счёт -i] = T.init;
                   добавьToCount( -gap);
                   }
        }

        /**
         * An implementation of Quicksort using medians of 3 for partitions.
         * Used internally by сортируй.
         * It is public and static so it can be used  в_ сортируй plain
         * массивы as well.
         * @param s, the Массив в_ сортируй
         * @param lo, the least индекс в_ сортируй из_
         * @param hi, the greatest индекс
         * @param cmp, the comparator в_ use for comparing elements
        **/

        public final static проц быстрСорт(T s[], цел lo, цел hi, Comparator!(T) cmp)
        {
                if (lo >= hi)
                    return;

                /*
                   Use median-of-three(lo, mопр, hi) в_ pick a partition. 
                   Also своп them преобр_в relative order while we are at it.
                */

                цел mопр = (lo + hi) / 2;

                if (cmp(s[lo], s[mопр]) > 0)
                   {
                   T врем = s[lo];
                   s[lo] = s[mопр];
                   s[mопр] = врем; // своп
                   }

                if (cmp(s[mопр], s[hi]) > 0)
                   {
                   T врем = s[mопр];
                   s[mопр] = s[hi];
                   s[hi] = врем; // своп

                   if (cmp(s[lo], s[mопр]) > 0)
                      {
                      T tmp2 = s[lo];
                      s[lo] = s[mопр];
                      s[mопр] = tmp2; // своп
                      }
                   }

                цел left = lo + 1;           // старт one past lo since already handled lo
                цел right = hi - 1;          // similarly
                if (left >= right)
                    return;                  // if three or fewer we are готово

                T partition = s[mопр];

                for (;;)
                    {
                    while (cmp(s[right], partition) > 0)
                           --right;

                    while (left < right && cmp(s[left], partition) <= 0)
                           ++left;

                    if (left < right)
                       {
                       T врем = s[left];
                       s[left] = s[right];
                       s[right] = врем; // своп
                       --right;
                       }
                    else
                       break;
                    }

                быстрСорт(s, lo, left, cmp);
                быстрСорт(s, left + 1, hi, cmp);
        }

        /***********************************************************************

                expose collection контент as an Массив

        ************************************************************************/

        override public T[] toArray ()
        {
                return Массив[0..счёт].dup;
        }
        
        // helper methods

        /**
         * Main метод в_ control буфер sizing.
         * The heuristic used for growth is:
         * <PRE>
         * if out of пространство:
         *   if need less than minCapacity, grow в_ minCapacity
         *   else grow by average of requested размер and minCapacity.
         * </PRE>
         * <P>
         * For small buffers, this causes them в_ be about 1/2 full.
         * while for large buffers, it causes them в_ be about 2/3 full.
         * <P>
         * For shrinkage, the only thing we do is unlink the буфер if it is пустой.
         * @param inc, the amount of пространство в_ grow by. Negative values mean shrink.
         * Возвращает: condition: исправь record of счёт, and if any of
         * the above conditions apply, размести and копируй преобр_в a new
         * буфер of the appropriate размер.
        **/

        private final проц growBy_(цел inc)
        {
                цел needed = счёт + inc;
                if (inc > 0)
                   {
                   /* heuristic: */
                   цел current = ёмкость();
                   if (needed > current)
                      {
                      incVersion();
                      цел newCap = needed + (needed + minCapacity) / 2;

                      if (newCap < minCapacity)
                          newCap = minCapacity;

                      if (Массив is пусто)
                         {
                         Массив = new T[newCap];
                         }
                      else
                         {
                         //T newArray[] = new T[newCap];
                         //newArray[0..счёт] = Массив[0..счёт];
                         //Массив = newArray;
                         Массив ~= new T[newCap - Массив.length];
                         }
                      }
                   }
                else
                   if (needed is 0)
                       Массив = пусто;

                setCount(needed);
        }


        /**
         * Utility в_ splice in enumerations
        **/

        private final проц insert_(цел индекс, Обходчик!(T) e)
        {
                if (cast(GuardIterator!(T)) e)
                   { 
                   // we know размер!
                   цел inc = (cast(GuardIterator!(T)) (e)).remaining();
                   цел oldcount = счёт;
                   цел oldversion = vershion;
                   growBy_(inc);

                   for (цел i = oldcount - 1; i >= индекс; --i)
                        Массив[i + inc] = Массив[i];

                   цел j = индекс;
                   while (e.ещё())
                         {
                         T element = e.получи();
                         if (!allows (element))
                            { // Ugh. Can only do full rollback
                            for (цел i = индекс; i < oldcount; ++i)
                                 Массив[i] = Массив[i + inc];

                            vershion = oldversion;
                            счёт = oldcount;
                            checkElement(element); // force throw
                            }
                         Массив[j++] = element;
                         }
                   }
                else
                   if (индекс is счёт)
                      { // следщ best; we can добавь
                      while (e.ещё())
                            {
                            T element = e.получи();
                            checkElement(element);
                            growBy_(1);
                            Массив[счёт -1] = element;
                            }
                      }
                   else
                      { // do it the slow way
                      цел j = индекс;
                      while (e.ещё())
                            {
                            T element = e.получи();
                            checkElement(element);
                            growBy_(1);

                            for (цел i = счёт -1; i > j; --i)
                                 Массив[i] = Массив[i - 1];
                            Массив[j++] = element;
                            }
                      }
        }

        private final проц удали_(T element, бул allOccurrences)
        {
                if (! isValопрArg(element))
                      return;

                for (цел i = 0; i < счёт; ++i)
                    {
                    while (i < счёт && Массив[i] == (element))
                          {
                          for (цел j = i + 1; j < счёт; ++j)
                               Массив[j - 1] = Массив[j];

                          Массив[счёт -1] = T.init;
                          growBy_( -1);

                          if (!allOccurrences || счёт is 0)
                               return ;
                          }
                    }
        }

        private final проц замени_(T oldElement, T newElement, бул allOccurrences)
        {
                if (isValопрArg(oldElement) is нет || счёт is 0)
                    return;

                for (цел i = 0; i < счёт; ++i)
                    {
                    if (Массив[i] == (oldElement))
                       {
                       checkElement(newElement);
                       Массив[i] = newElement;
                       incVersion();

                       if (! allOccurrences)
                             return;
                       }
                    }
        }

        /**
         * Implements util.collection.model.View.View.checkImplementation.
         * See_Also: util.collection.model.View.View.checkImplementation
        **/
        public override проц checkImplementation()
        {
                super.checkImplementation();
                assert(!(Массив is пусто && счёт !is 0));
                assert((Массив is пусто || счёт <= Массив.length));

                for (цел i = 0; i < счёт; ++i)
                    {
                    assert(allows(Массив[i]));
                    assert(instances(Массив[i]) > 0);
                    assert(содержит(Массив[i]));
                    }
        }

        /***********************************************************************

                opApply() есть migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        static class ArrayIterator(T) : AbstractIterator!(T)
        {
                private цел row;
                private T[] Массив;

                public this (ArraySeq пследвтн)
                {
                        super (пследвтн);
                        Массив = пследвтн.Массив;
                }

                public final T получи()
                {
                        decRemaining();
                        return Массив[row++];
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
                auto Массив = new ArraySeq!(ткст);
                Массив.добавь ("foo");
                Массив.добавь ("bar");
                Массив.добавь ("wumpus");

                foreach (значение; Массив.elements) {}

                auto elements = Массив.elements();
                while (elements.ещё)
                       auto v = elements.получи();

                foreach (значение; Массив)
                         Квывод (значение).нс;

                auto a = Массив.toArray;
                a.сортируй;
                foreach (значение; a)
                         Квывод (значение).нс;

                 Массив.checkImplementation();
        }
}
