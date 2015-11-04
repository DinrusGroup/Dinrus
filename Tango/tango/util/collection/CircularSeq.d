/*
 Файл: CircularSeq.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ сохрани.d  working файл
 13Oct95  dl                 Changed protection statuses
*/

module util.collection.CircularSeq;

private import  util.collection.model.Iterator,
                util.collection.model.GuardIterator;

private import  util.collection.impl.CLCell,
                util.collection.impl.SeqCollection,
                util.collection.impl.AbstractIterator;


/**
 * Circular linked lists. Publically Implement only those
 * methods defined in interfaces.
 * author: Doug Lea
**/
deprecated public class CircularSeq(T) : SeqCollection!(T)
{
        alias CLCell!(T) CLCellT;

        alias SeqCollection!(T).удали     удали;
        alias SeqCollection!(T).removeAll  removeAll;

        // экземпляр variables

        /**
         * The голова of the список. Пусто if пустой
        **/
        package CLCellT список;

        // constructors

        /**
         * Make an пустой список with no element screener
        **/
        public this ()
        {
                this(пусто, пусто, 0);
        }

        /**
         * Make an пустой список with supplied element screener
        **/
        public this (Predicate screener)
        {
                this(screener, пусто, 0);
        }

        /**
         * Special version of constructor needed by clone()
        **/
        protected this (Predicate s, CLCellT h, цел c)
        {
                super(s);
                список = h;
                счёт = c;
        }

        /**
         * Make an independent копируй of the список. Elements themselves are not cloned
        **/
        public final CircularSeq!(T) duplicate()
        {
                if (список is пусто)
                    return new CircularSeq!(T) (screener, пусто, 0);
                else
                   return new CircularSeq!(T) (screener, список.copyList(), счёт);
        }


        // Collection methods

        /**
         * Implements util.collection.impl.Collection.Collection.содержит
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.содержит
        **/
        public final бул содержит(T element)
        {
                if (!isValопрArg(element) || список is пусто)
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
                if (!isValопрArg(element) || список is пусто)
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


        // Seq methods

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
         * Время complexity: O(1).
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
                if (startingIndex < 0)
                    startingIndex = 0;

                CLCellT p = список;
                if (p is пусто || !isValопрArg(element))
                    return -1;

                for (цел i = 0; да; ++i)
                    {
                    if (i >= startingIndex && p.element() == (element))
                        return i;

                    p = p.следщ();
                    if (p is список)
                        break;
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
                if (!isValопрArg(element) || счёт is 0)
                    return -1;

                if (startingIndex >= размер())
                    startingIndex = размер() - 1;

                if (startingIndex < 0)
                    startingIndex = 0;

                CLCellT p = cellAt(startingIndex);
                цел i = startingIndex;
                for (;;)
                    {
                    if (p.element() == (element))
                        return i;
                    else
                       if (p is список)
                           break;
                       else
                          {
                          p = p.prev();
                          --i;
                          }
                    }
                return -1;
        }

        /**
         * Implements util.collection.model.Seq.Seq.subseq.
         * Время complexity: O(length).
         * See_Also: util.collection.model.Seq.Seq.subseq
        **/
        public final CircularSeq поднабор (цел из_, цел _length)
        {
                if (_length > 0)
                   {
                   checkIndex(из_);
                   CLCellT p = cellAt(из_);
                   CLCellT newlist = new CLCellT(p.element());
                   CLCellT current = newlist;

                   for (цел i = 1; i < _length; ++i)
                       {
                       p = p.следщ();
                       if (p is пусто)
                           checkIndex(из_ + i); // force исключение

                       current.добавьNext(p.element());
                       current = current.следщ();
                       }
                   return new CircularSeq (screener, newlist, _length);
                   }
                else
                   return new CircularSeq ();
        }

        // MutableCollection methods

        /**
         * Implements util.collection.impl.Collection.Collection.сотри.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.Collection.Collection.сотри
        **/
        public final проц сотри()
        {
                список = пусто;
                setCount(0);
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
        public final проц replaceAll (T oldElement, T newElement)
        {
                замени_(oldElement, newElement, да);
        }


        /**
         * Implements util.collection.impl.Collection.Collection.take.
         * Время complexity: O(1).
         * takes the последний element on the список.
         * See_Also: util.collection.impl.Collection.Collection.take
        **/
        public final T take()
        {
                auto v = хвост();
                removeTail();
                return v;
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
                if (список is пусто)
                    список = new CLCellT(element);
                else
                   список = список.добавьPrev(element);
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
                if (firstCell().isSingleton())
                   список = пусто;
                else
                   {
                   auto n = список.следщ();
                   список.unlink();
                   список = n;
                   }
                decCount();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавь.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавь
        **/
        public final проц добавь(T element)
        {
                if (список is пусто)
                    приставь(element);
                else
                   {
                   checkElement(element);
                   список.prev().добавьNext(element);
                   incCount();
                   }
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.замениХвост.
         * Время complexity: O(1).
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
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.removeTail
        **/
        public final проц removeTail()
        {
                auto l = lastCell();
                if (l is список)
                    список = пусто;
                else
                   l.unlink();
                decCount();
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
                   cellAt(индекс - 1).добавьNext(element);
                   incCount();
                   }
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.replaceAt.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.replaceAt
        **/
        public final проц replaceAt(цел индекс, T element)
        {
                checkElement(element);
                cellAt(индекс).element(element);
                incVersion();
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
         * Implements util.collection.impl.SeqCollection.SeqCollection.приставь.
         * Время complexity: O(число of elements in e).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.приставь
        **/
        public final проц приставь(Обходчик!(T) e)
        {
                CLCellT hd = пусто;
                CLCellT current = пусто;
      
                while (e.ещё())
                      {
                      auto element = e.получи();
                      checkElement(element);
                      incCount();

                      if (hd is пусто)
                         {
                         hd = new CLCellT(element);
                         current = hd;
                         }
                      else
                         {
                         current.добавьNext(element);
                         current = current.следщ();
                         }
                      }

                if (список is пусто)
                    список = hd;
                else
                   if (hd !is пусто)
                      {
                      auto tl = список.prev();
                      current.следщ(список);
                      список.prev(current);
                      tl.следщ(hd);
                      hd.prev(tl);
                      список = hd;
                      }
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавь.
         * Время complexity: O(число of elements in e).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавь
        **/
        public final проц добавь(Обходчик!(T) e)
        {
                if (список is пусто)
                    приставь(e);
                else
                   {
                   CLCellT current = список.prev();
                   while (e.ещё())
                         {
                         T element = e.получи();
                         checkElement(element);
                         incCount();
                         current.добавьNext(element);
                         current = current.следщ();
                         }
                   }
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавьAt.
         * Время complexity: O(размер() + число of elements in e).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавьAt
        **/
        public final проц добавьAt(цел индекс, Обходчик!(T) e)
        {
                if (список is пусто || индекс is 0)
                    приставь(e);
                else
                   {
                   CLCellT current = cellAt(индекс - 1);
                   while (e.ещё())
                         {
                         T element = e.получи();
                         checkElement(element);
                         incCount();
                         current.добавьNext(element);
                         current = current.следщ();
                         }
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
                CLCellT p = cellAt(fromIndex);
                CLCellT последний = список.prev();
                for (цел i = fromIndex; i <= toIndex; ++i)
                    {
                    decCount();
                    CLCellT n = p.следщ();
                    p.unlink();
                    if (p is список)
                       {
                       if (p is последний)
                          {
                          список = пусто;
                          return ;
                          }
                       else
                          список = n;
                       }
                    p = n;
                    }
        }


        // helper methods

        /**
         * return the first cell, or throw исключение if пустой
        **/
        private final CLCellT firstCell()
        {
                if (список !is пусто)
                    return список;

                checkIndex(0);
                return пусто; // not reached!
        }

        /**
         * return the последний cell, or throw исключение if пустой
        **/
        private final CLCellT lastCell()
        {
                if (список !is пусто)
                    return список.prev();

                checkIndex(0);
                return пусто; // not reached!
        }

        /**
         * return the индекс'th cell, or throw исключение if bad индекс
        **/
        private final CLCellT cellAt(цел индекс)
        {
                checkIndex(индекс);
                return список.nth(индекс);
        }

        /**
         * helper for удали/exclude
        **/
        private final проц удали_(T element, бул allOccurrences)
        {
                if (!isValопрArg(element) || список is пусто)
                    return;

                CLCellT p = список;
                for (;;)
                    {
                    CLCellT n = p.следщ();
                    if (p.element() == (element))
                       {
                       decCount();
                       p.unlink();
                       if (p is список)
                          {
                          if (p is n)
                             {
                             список = пусто;
                             break;
                             }
                          else
                             список = n;
                          }

                       if (! allOccurrences)
                             break;
                       else
                          p = n;
                       }
                    else
                       if (n is список)
                           break;
                       else
                          p = n;
                    }
        }


        /**
         * helper for замени *
        **/
        private final проц замени_(T oldElement, T newElement, бул allOccurrences)
        {
                if (!isValопрArg(oldElement) || список is пусто)
                    return;

                CLCellT p = список;
                do {
                   if (p.element() == (oldElement))
                      {
                      checkElement(newElement);
                      incVersion();
                      p.element(newElement);
                      if (! allOccurrences)
                            return;
                      }
                   p = p.следщ();
                } while (p !is список);
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

                if (список is пусто)
                    return;

                цел c = 0;
                CLCellT p = список;
                do {
                   assert(p.prev().следщ() is p);
                   assert(p.следщ().prev() is p);
                   assert(allows(p.element()));
                   assert(instances(p.element()) > 0);
                   assert(содержит(p.element()));
                   p = p.следщ();
                   ++c;
                   } while (p !is список);

                assert(c is счёт);
        }


        /***********************************************************************

                opApply() есть migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        static class CellIterator(T) : AbstractIterator!(T)
        {
                private CLCellT cell;

                public this (CircularSeq пследвтн)
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
                auto Массив = new CircularSeq!(ткст);
                Массив.добавь ("foo");
                Массив.добавь ("bar");
                Массив.добавь ("wumpus");

                foreach (значение; Массив.elements) {}

                auto elements = Массив.elements();
                while (elements.ещё)
                       auto v = elements.получи();

                foreach (значение; Массив)
                         Квывод (значение).нс;

                Массив.checkImplementation();
        }
}
