/*
 Файл: LinkSeq.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 2Oct95  dl@cs.oswego.edu   repack из_ LLSeq.d
 9apr97  dl                 вставь bounds check in first
*/


module util.collection.LinkSeq;

private import  util.collection.model.Iterator,
                util.collection.model.Sortable,
                util.collection.model.Comparator,
                util.collection.model.GuardIterator;

private import  util.collection.impl.LLCell,
                util.collection.impl.SeqCollection,
                util.collection.impl.AbstractIterator;

/**
 *
 * LinkedList implementation.
 * Publically реализует only those methods defined in its interfaces.
 *
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

deprecated public class LinkSeq(T) : SeqCollection!(T), Sortable!(T)
{
        alias LLCell!(T) LLCellT;

        alias SeqCollection!(T).удали     удали;
        alias SeqCollection!(T).removeAll  removeAll;

        // экземпляр variables

        /**
         * The голова of the список. Пусто iff счёт == 0
        **/

        package LLCellT список;

        // constructors

        /**
         * Create a new пустой список
        **/

        public this ()
        {
                this(пусто, пусто, 0);
        }

        /**
         * Create a список with a given element screener
        **/

        public this (Predicate screener)
        {
                this(screener, пусто, 0);
        }

        /**
         * Special version of constructor needed by clone()
        **/

        protected this (Predicate s, LLCellT l, цел c)
        {
                super(s);
                список = l;
                счёт = c;
        }

        /**
         * Build an independent копируй of the список.
         * The elements themselves are not cloned
        **/

        //  protected Объект clone() {
        public LinkSeq!(T) duplicate()
        {
                if (список is пусто)
                    return new LinkSeq!(T)(screener, пусто, 0);
                else
                   return new LinkSeq!(T)(screener, список.copyList(), счёт);
        }


        // Collection methods

        /**
         * Implements util.collection.impl.Collection.Collection.содержит
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.содержит
        **/
        public final бул содержит(T element)
        {
                if (!isValопрArg(element) || счёт is 0)
                      return нет;

                return список.найди(element) !is пусто;
        }

        /**
         * Implements util.collection.impl.Collection.Collection.instances
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.instances
        **/
        public final бцел instances(T element)
        {
                if (!isValопрArg(element) || счёт is 0)
                    return 0;

                return список.счёт(element);
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


        // Seq Methods

        /**
         * Implements util.collection.model.Seq.Seq.голова.
         * Время complexity: O(1).
         * See_Also: util.collection.model.Seq.Seq.голова
        **/
        public final T голова()
        {
                return firstCell().element();
        }

        /**
         * Implements util.collection.model.Seq.Seq.хвост.
         * Время complexity: O(n).
         * See_Also: util.collection.model.Seq.Seq.хвост
        **/
        public final T хвост()
        {
                return lastCell().element();
        }

        /**
         * Implements util.collection.model.Seq.Seq.получи.
         * Время complexity: O(n).
         * See_Also: util.collection.model.Seq.Seq.получи
        **/
        public final T получи(цел индекс)
        {
                return cellAt(индекс).element();
        }

        /**
         * Implements util.collection.model.Seq.Seq.first.
         * Время complexity: O(n).
         * See_Also: util.collection.model.Seq.Seq.first
        **/
        public final цел first(T element, цел startingIndex = 0)
        {
                if (!isValопрArg(element) || список is пусто || startingIndex >= счёт)
                      return -1;

                if (startingIndex < 0)
                    startingIndex = 0;

                LLCellT p = список.nth(startingIndex);
                if (p !is пусто)
                   {
                   цел i = p.индекс(element);
                   if (i >= 0)
                       return i + startingIndex;
                   }
                return -1;
        }

        /**
         * Implements util.collection.model.Seq.Seq.последний.
         * Время complexity: O(n).
         * See_Also: util.collection.model.Seq.Seq.последний
        **/
        public final цел последний(T element, цел startingIndex = 0)
        {
                if (!isValопрArg(element) || список is пусто)
                     return -1;

                цел i = 0;
                if (startingIndex >= размер())
                    startingIndex = размер() - 1;

                цел индекс = -1;
                LLCellT p = список;
                while (i <= startingIndex && p !is пусто)
                      {
                      if (p.element() == (element))
                          индекс = i;
                      ++i;
                      p = p.следщ();
                      }
                return индекс;
        }



        /**
         * Implements util.collection.model.Seq.Seq.subseq.
         * Время complexity: O(length).
         * See_Also: util.collection.model.Seq.Seq.subseq
        **/
        public final LinkSeq поднабор(цел из_, цел _length)
        {
                if (_length > 0)
                   {
                   LLCellT p = cellAt(из_);
                   LLCellT newlist = new LLCellT(p.element(), пусто);
                   LLCellT current = newlist;
         
                   for (цел i = 1; i < _length; ++i)
                       {
                       p = p.следщ();
                       if (p is пусто)
                           checkIndex(из_ + i); // force исключение

                       current.linkNext(new LLCellT(p.element(), пусто));
                       current = current.следщ();
                       }
                   return new LinkSeq!(T)(screener, newlist, _length);
                   }
                else
                   return new LinkSeq!(T)(screener, пусто, 0);
        }


        // MutableCollection methods

        /**
         * Implements util.collection.impl.Collection.Collection.сотри.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.Collection.Collection.сотри
        **/
        public final проц сотри()
        {
                if (список !is пусто)
                   {
                   список = пусто;
                   setCount(0);
                   }
        }

        /**
         * Implements util.collection.impl.Collection.Collection.exclude.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.exclude
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
        public final проц удали (T element)
        {
                удали_(element, нет);
        }

        /**
         * Implements util.collection.impl.Collection.Collection.replaceOneOf
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.replaceOneOf
        **/
        public final проц замени (T oldElement, T newElement)
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
         * takes the first element on the список
         * See_Also: util.collection.impl.Collection.Collection.take
        **/
        public final T take()
        {
                T v = голова();
                removeHead();
                return v;
        }

        // Sortable methods

        /**
         * Implements util.collection.Sortable.сортируй.
         * Время complexity: O(n лог n).
         * Uses a merge-сортируй-based algorithm.
         * See_Also: util.collection.SortableCollection.сортируй
        **/
        public final проц сортируй(Comparator!(T) cmp)
        {
                if (список !is пусто)
                   {
                   список = LLCellT.mergeSort(список, cmp);
                   incVersion();
                   }
        }


        // MutableSeq methods

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.приставь.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.приставь
        **/
        public final проц приставь(T element)
        {
                checkElement(element);
                список = new LLCellT(element, список);
                incCount();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.замениГолову.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.замениГолову
        **/
        public final проц замениГолову(T element)
        {
                checkElement(element);
                firstCell().element(element);
                incVersion();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.removeHead.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.removeHead
        **/
        public final проц removeHead()
        {
                список = firstCell().следщ();
                decCount();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавь.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавь
        **/
        public final проц добавь(T element)
        {
                checkElement(element);
                if (список is пусто)
                    приставь(element);
                else
                   {
                   список.хвост().следщ(new LLCellT(element));
                   incCount();
                   }
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.замениХвост.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.замениХвост
        **/
        public final проц замениХвост(T element)
        {
                checkElement(element);
                lastCell().element(element);
                incVersion();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.removeTail.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.removeTail
        **/
        public final проц removeTail()
        {
                if (firstCell().следщ() is пусто)
                    removeHead();
                else
                   {
                   LLCellT trail = список;
                   LLCellT p = trail.следщ();

                   while (p.следщ() !is пусто)
                         {
                         trail = p;
                         p = p.следщ();
                         }
                   trail.следщ(пусто);
                   decCount();
                   }
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавьAt.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавьAt
        **/
        public final проц добавьAt(цел индекс, T element)
        {
                if (индекс is 0)
                    приставь(element);
                else
                   {
                   checkElement(element);
                   cellAt(индекс - 1).linkNext(new LLCellT(element));
                   incCount();
                   }
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.removeAt.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.removeAt
        **/
        public final проц removeAt(цел индекс)
        {
                if (индекс is 0)
                    removeHead();
                else
                   {
                   cellAt(индекс - 1).unlinkNext();
                   decCount();
                   }
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.replaceAt.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.replaceAt
        **/
        public final проц replaceAt(цел индекс, T element)
        {
                cellAt(индекс).element(element);
                incVersion();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.приставь.
         * Время complexity: O(число of elements in e).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.приставь
        **/
        public final проц приставь(Обходчик!(T) e)
        {
                splice_(e, пусто, список);
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавь.
         * Время complexity: O(n + число of elements in e).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавь
        **/
        public final проц добавь(Обходчик!(T) e)
        {
                if (список is пусто)
                    splice_(e, пусто, пусто);
                else
                   splice_(e, список.хвост(), пусто);
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавьAt.
         * Время complexity: O(n + число of elements in e).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавьAt
        **/
        public final проц добавьAt(цел индекс, Обходчик!(T) e)
        {
                if (индекс is 0)
                    splice_(e, пусто, список);
                else
                   {
                   LLCellT p = cellAt(индекс - 1);
                   splice_(e, p, p.следщ());
                   }
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.removeFromTo.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.removeFromTo
        **/
        public final проц removeRange (цел fromIndex, цел toIndex)
        {
                checkIndex(toIndex);

                if (fromIndex <= toIndex)
                   {
                   if (fromIndex is 0)
                      {
                      LLCellT p = firstCell();
                      for (цел i = fromIndex; i <= toIndex; ++i)
                           p = p.следщ();
                      список = p;
                      }
                   else
                      {
                      LLCellT f = cellAt(fromIndex - 1);
                      LLCellT p = f;
                      for (цел i = fromIndex; i <= toIndex; ++i)
                           p = p.следщ();
                      f.следщ(p.следщ());
                      }
                  добавьToCount( -(toIndex - fromIndex + 1));
                  }
        }



        // helper methods

        private final LLCellT firstCell()
        {
                if (список !is пусто)
                    return список;

                checkIndex(0);
                return пусто; // not reached!
        }

        private final LLCellT lastCell()
        {
                if (список !is пусто)
                    return список.хвост();

                checkIndex(0);
                return пусто; // not reached!
        }

        private final LLCellT cellAt(цел индекс)
        {
                checkIndex(индекс);
                return список.nth(индекс);
        }

        /**
         * Helper метод for removeOneOf()
        **/

        private final проц удали_(T element, бул allOccurrences)
        {
                if (!isValопрArg(element) || счёт is 0)
                     return ;

                LLCellT p = список;
                LLCellT trail = p;

                while (p !is пусто)
                      {
                      LLCellT n = p.следщ();
                      if (p.element() == (element))
                         {
                         decCount();
                         if (p is список)
                            {
                            список = n;
                            trail = n;
                            }
                         else
                            trail.следщ(n);

                         if (!allOccurrences || счёт is 0)
                             return ;
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


        /**
         * Helper for замени
        **/

        private final проц замени_(T oldElement, T newElement, бул allOccurrences)
        {
                if (счёт is 0 || !isValопрArg(oldElement) || oldElement == (newElement))
                    return ;

                LLCellT p = список.найди(oldElement);
                while (p !is пусто)
                      {
                      checkElement(newElement);
                      p.element(newElement);
                      incVersion();
                      if (!allOccurrences)
                           return ;
                      p = p.найди(oldElement);
                      }
        }

        /**
         * Splice elements of e between hd and tl. if hd is пусто return new hd
        **/

        private final проц splice_(Обходчик!(T) e, LLCellT hd, LLCellT tl)
        {
                if (e.ещё())
                   {
                   LLCellT newlist = пусто;
                   LLCellT current = пусто;

                   while (e.ещё())
                        {
                        T v = e.получи();
                        checkElement(v);
                        incCount();

                        LLCellT p = new LLCellT(v, пусто);
                        if (newlist is пусто)
                            newlist = p;
                        else
                           current.следщ(p);
                        current = p;
                        }

                   if (current !is пусто)
                       current.следщ(tl);

                   if (hd is пусто)
                       список = newlist;
                   else
                      hd.следщ(newlist);
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

                assert(((счёт is 0) is (список is пусто)));
                assert((список is пусто || список._length() is счёт));

                цел c = 0;
                for (LLCellT p = список; p !is пусто; p = p.следщ())
                    {
                    assert(allows(p.element()));
                    assert(instances(p.element()) > 0);
                    assert(содержит(p.element()));
                    ++c;
                    }
                assert(c is счёт);

        }


        /***********************************************************************

                opApply() есть migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        private static class CellIterator(T) : AbstractIterator!(T)
        {
                private LLCellT cell;

                public this (LinkSeq пследвтн)
                {
                        super (пследвтн);
                        cell = пследвтн.список;
                }

                public final T получи()
                {
                        decRemaining();
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
                auto пследвтн = new LinkSeq!(ткст);
                пследвтн.добавь ("foo");
                пследвтн.добавь ("wumpus");
                пследвтн.добавь ("bar");

                foreach (значение; пследвтн.elements) {}

                auto elements = пследвтн.elements();
                while (elements.ещё)
                       auto v = elements.получи();

                foreach (значение; пследвтн)
                         Квывод (значение).нс;

                пследвтн.checkImplementation();
        }
}
                
