/*
 Файл: TreeBag.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ util.collection.d  working файл
 13Oct95  dl                 Changed protection statuses

*/


module util.collection.TreeBag;

private import  util.collection.model.Iterator,
                util.collection.model.Comparator,
                util.collection.model.SortedValues,
                util.collection.model.GuardIterator;

private import  util.collection.impl.RBCell,
                util.collection.impl.BagCollection,
                util.collection.impl.AbstractIterator;

/**
 * RedBlack trees.
 * author: Doug Lea
**/

deprecated public class TreeBag(T) : BagCollection!(T), SortedValues!(T)
{
        alias RBCell!(T)        RBCellT;
        alias Comparator!(T)    ComparatorT;

        alias BagCollection!(T).удали     удали;
        alias BagCollection!(T).removeAll  removeAll;


        // экземпляр variables

        /**
         * The корень of the дерево. Пусто if пустой.
        **/

        package RBCellT дерево;

        /**
         * The comparator в_ use for ordering.
        **/
        protected ComparatorT cmp_;

        // constructors

        /**
         * Make an пустой дерево.
         * Initialize в_ use DefaultComparator for ordering
        **/
        public this ()
        {
                this(пусто, пусто, пусто, 0);
        }

        /**
         * Make an пустой дерево, using the supplied element screener.
         * Initialize в_ use DefaultComparator for ordering
        **/

        public this (Predicate s)
        {
                this(s, пусто, пусто, 0);
        }

        /**
         * Make an пустой дерево, using the supplied element comparator for ordering.
        **/
        public this (ComparatorT c)
        {
                this(пусто, c, пусто, 0);
        }

        /**
         * Make an пустой дерево, using the supplied element screener and comparator
        **/
        public this (Predicate s, ComparatorT c)
        {
                this(s, c, пусто, 0);
        }

        /**
         * Special version of constructor needed by clone()
        **/

        protected this (Predicate s, ComparatorT cmp, RBCellT t, цел n)
        {
                super(s);
                счёт = n;
                дерево = t;
                if (cmp !is пусто)
                    cmp_ = cmp;
                else
                   cmp_ = &compare;
        }

        /**
         * The default comparator
         *
         * @param fst first аргумент
         * @param snd сукунда аргумент
         * Возвращает: a negative число if fst is less than snd; a
         * positive число if fst is greater than snd; else 0
        **/

        private final цел compare(T fst, T snd)
        {
                if (fst is snd)
                    return 0;

                return typeid(T).compare (&fst, &snd);
        }


        /**
         * Make an independent копируй of the дерево. Does not clone elements.
        **/ 

        public TreeBag!(T) duplicate()
        {
                if (счёт is 0)
                    return new TreeBag!(T)(screener, cmp_);
                else
                   return new TreeBag!(T)(screener, cmp_, дерево.copyTree(), счёт);
        }



        // Collection methods

        /**
         * Implements util.collection.impl.Collection.Collection.содержит
         * Время complexity: O(лог n).
         * See_Also: util.collection.impl.Collection.Collection.содержит
        **/
        public final бул содержит(T element)
        {
                if (!isValопрArg(element) || счёт is 0)
                     return нет;

                return дерево.найди(element, cmp_) !is пусто;
        }

        /**
         * Implements util.collection.impl.Collection.Collection.instances
         * Время complexity: O(лог n).
         * See_Also: util.collection.impl.Collection.Collection.instances
        **/
        public final бцел instances(T element)
        {
                if (!isValопрArg(element) || счёт is 0)
                     return 0;

                return дерево.счёт(element, cmp_);
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


        // ElementSortedCollection methods


        /**
         * Implements util.collection.ElementSortedCollection.comparator
         * Время complexity: O(1).
         * See_Also: util.collection.ElementSortedCollection.comparator
        **/
        public final ComparatorT comparator()
        {
                return cmp_;
        }

        /**
         * Reset the comparator. Will cause a reorganization of the дерево.
         * Время complexity: O(n лог n).
        **/
        public final проц comparator(ComparatorT cmp)
        {
                if (cmp !is cmp_)
                   {
                   if (cmp !is пусто)
                       cmp_ = cmp;
                   else
                      cmp_ = &compare;

                   if (счёт !is 0)
                      {       // must rebuild дерево!
                      incVersion();
                      RBCellT t = дерево.leftmost();
                      дерево = пусто;
                      счёт = 0;
                      while (t !is пусто)
                            {
                            добавь_(t.element(), нет);
                            t = t.successor();
                            }
                      }
                   }
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
                дерево = пусто;
        }

        /**
         * Implements util.collection.impl.Collection.Collection.removeAll.
         * Время complexity: O(лог n * instances(element)).
         * See_Also: util.collection.impl.Collection.Collection.removeAll
        **/
        public final проц removeAll(T element)
        {
                удали_(element, да);
        }


        /**
         * Implements util.collection.impl.Collection.Collection.removeOneOf.
         * Время complexity: O(лог n).
         * See_Also: util.collection.impl.Collection.Collection.removeOneOf
        **/
        public final проц удали(T element)
        {
                удали_(element, нет);
        }

        /**
         * Implements util.collection.impl.Collection.Collection.replaceOneOf
         * Время complexity: O(лог n).
         * See_Also: util.collection.impl.Collection.Collection.replaceOneOf
        **/
        public final проц замени(T oldElement, T newElement)
        {
                замени_(oldElement, newElement, нет);
        }

        /**
         * Implements util.collection.impl.Collection.Collection.replaceAllOf.
         * Время complexity: O(лог n * instances(oldElement)).
         * See_Also: util.collection.impl.Collection.Collection.replaceAllOf
        **/
        public final проц replaceAll(T oldElement, T newElement)
        {
                замени_(oldElement, newElement, да);
        }

        /**
         * Implements util.collection.impl.Collection.Collection.take.
         * Время complexity: O(лог n).
         * Takes the least element.
         * See_Also: util.collection.impl.Collection.Collection.take
        **/
        public final T take()
        {
                if (счёт !is 0)
                   {
                   RBCellT p = дерево.leftmost();
                   T v = p.element();
                   дерево = p.удали(дерево);
                   decCount();
                   return v;
                   }

                checkIndex(0);
                return T.init; // not reached
        }


        // MutableBag methods

        /**
         * Implements util.collection.MutableBag.добавьIfAbsent
         * Время complexity: O(лог n).
         * See_Also: util.collection.MutableBag.добавьIfAbsent
        **/
        public final проц добавьIf (T element)
        {
                добавь_(element, да);
        }


        /**
         * Implements util.collection.MutableBag.добавь.
         * Время complexity: O(лог n).
         * See_Also: util.collection.MutableBag.добавь
        **/
        public final проц добавь (T element)
        {
                добавь_(element, нет);
        }


        // helper methods

        private final проц добавь_(T element, бул checkOccurrence)
        {
                checkElement(element);

                if (дерево is пусто)
                   {
                   дерево = new RBCellT(element);
                   incCount();
                   }
                else
                   {
                   RBCellT t = дерево;

                   for (;;)
                       {
                       цел diff = cmp_(element, t.element());
                       if (diff is 0 && checkOccurrence)
                           return ;
                       else
                          if (diff <= 0)
                             {
                             if (t.left() !is пусто)
                                 t = t.left();
                             else
                                {
                                дерево = t.insertLeft(new RBCellT(element), дерево);
                                incCount();
                                return ;
                                }
                             }
                          else
                             {
                             if (t.right() !is пусто)
                                 t = t.right();
                              else
                                 {
                                 дерево = t.insertRight(new RBCellT(element), дерево);
                                 incCount();
                                 return ;
                                 }
                              }
                          }
                   }
        }


        private final проц удали_(T element, бул allOccurrences)
        {
                if (!isValопрArg(element))
                    return ;

                while (счёт > 0)
                      {
                      RBCellT p = дерево.найди(element, cmp_);

                      if (p !is пусто)
                         {
                         дерево = p.удали(дерево);
                         decCount();
                         if (!allOccurrences)
                             return ;
                         }
                      else
                         break;
                      }
        }

        private final проц замени_(T oldElement, T newElement, бул allOccurrences)
        {
                if (!isValопрArg(oldElement) || счёт is 0 || oldElement == newElement)
                    return ;

                while (содержит(oldElement))
                      {
                      удали(oldElement);
                      добавь (newElement);
                      if (!allOccurrences)
                          return ;
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
                assert(cmp_ !is пусто);
                assert(((счёт is 0) is (дерево is пусто)));
                assert((дерево is пусто || дерево.размер() is счёт));

                if (дерево !is пусто)
                   {
                   дерево.checkImplementation();
                   T последний = T.init;
                   RBCellT t = дерево.leftmost();
                   while (t !is пусто)
                         {
                         T v = t.element();
                         if (последний !is T.init)
                             assert(cmp_(последний, v) <= 0);
                         последний = v;
                         t = t.successor();
                         }
                   }
        }


        /***********************************************************************

                opApply() есть migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        private static class CellIterator(T) : AbstractIterator!(T)
        {
                private RBCellT cell;

                public this (TreeBag bag)
                {
                        super(bag);

                        if (bag.дерево)
                            cell = bag.дерево.leftmost;
                }

                public final T получи()
                {
                        decRemaining();
                        auto v = cell.element();
                        cell = cell.successor();
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
                auto bag = new TreeBag!(ткст);
                bag.добавь ("zebra");
                bag.добавь ("bar");
                bag.добавь ("barrel");
                bag.добавь ("foo");
                bag.добавь ("apple");

                foreach (значение; bag.elements) {}

                auto elements = bag.elements();
                while (elements.ещё)
                       auto v = elements.получи();

                foreach (значение; bag.elements)
                         Квывод (значение).нс;
                     
                bag.checkImplementation();
        }
}
