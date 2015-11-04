/*
 Файл: TreeMap.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ util.collection.d  working файл
 13Oct95  dl                 Changed protection statuses

*/


module util.collection.TreeMap;

private import  exception;

private import  util.collection.model.Comparator,
                util.collection.model.SortedKeys,
                util.collection.model.GuardIterator;

private import  util.collection.impl.RBPair,
                util.collection.impl.RBCell,
                util.collection.impl.MapCollection,
                util.collection.impl.AbstractIterator;


/**
 *
 *
 * RedBlack Trees of (ключ, element) pairs
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/


deprecated public class TreeMap(K, T) : MapCollection!(K, T), SortedKeys!(K, T)
{
        alias RBCell!(T)                RBCellT;
        alias RBPair!(K, T)             RBPairT;
        alias Comparator!(K)            ComparatorT;
        alias GuardIterator!(T)         GuardIteratorT;

        alias MapCollection!(K, T).удали     удали;
        alias MapCollection!(K, T).removeAll  removeAll;


        // экземпляр variables

        /**
         * The корень of the дерево. Пусто if пустой.
        **/

        package RBPairT дерево;

        /**
         * The Comparator в_ use for ordering
        **/

        protected ComparatorT           cmp;
        protected Comparator!(T)        cmpElem;

        /**
         * Make an пустой дерево, using DefaultComparator for ordering
        **/

        public this ()
        {
                this (пусто, пусто, пусто, 0);
        }


        /**
         * Make an пустой дерево, using given screener for screening elements (not ключи)
        **/
        public this (Predicate screener)
        {
                this(screener, пусто, пусто, 0);
        }

        /**
         * Make an пустой дерево, using given Comparator for ordering
        **/
        public this (ComparatorT c)
        {
                this(пусто, c, пусто, 0);
        }

        /**
         * Make an пустой дерево, using given screener and Comparator.
        **/
        public this (Predicate s, ComparatorT c)
        {
                this(s, c, пусто, 0);
        }

        /**
         * Special version of constructor needed by clone()
        **/

        protected this (Predicate s, ComparatorT c, RBPairT t, цел n)
        {
                super(s);
                счёт = n;
                дерево = t;
                cmp = (c is пусто) ? &compareKey : c;
                cmpElem = &compareElem;
        }

        /**
         * The default ключ comparator
         *
         * @param fst first аргумент
         * @param snd сукунда аргумент
         * Возвращает: a negative число if fst is less than snd; a
         * positive число if fst is greater than snd; else 0
        **/

        private final цел compareKey(K fst, K snd)
        {
                if (fst is snd)
                    return 0;

                return typeid(K).compare (&fst, &snd);
        }


        /**
         * The default element comparator
         *
         * @param fst first аргумент
         * @param snd сукунда аргумент
         * Возвращает: a negative число if fst is less than snd; a
         * positive число if fst is greater than snd; else 0
        **/

        private final цел compareElem(T fst, T snd)
        {
                if (fst is snd)
                    return 0;

                return typeid(T).compare (&fst, &snd);
        }


        /**
         * Create an independent копируй. Does not clone elements.
        **/

        public TreeMap!(K, T) duplicate()
        {
                if (счёт is 0)
                    return new TreeMap!(K, T)(screener, cmp);
                else
                   return new TreeMap!(K, T)(screener, cmp, cast(RBPairT)(дерево.copyTree()), счёт);
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
                return дерево.найди(element, cmpElem) !is пусто;
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
                return дерево.счёт(element, cmpElem);
        }

        /**
         * Implements util.collection.impl.Collection.Collection.elements
         * Время complexity: O(1).
         * See_Also: util.collection.impl.Collection.Collection.elements
        **/
        public final GuardIterator!(T) elements()
        {
                return ключи();
        }

        /***********************************************************************

                Implements util.collection.model.View.View.opApply
                Время complexity: O(n)
                
                See_Also: util.collection.model.View.View.opApply
        
        ************************************************************************/
        
        цел opApply (цел delegate (inout T значение) дг)
        {
                auto scope iterator = new MapIterator!(K, T)(this);
                return iterator.opApply (дг);
        }


        /***********************************************************************

                Implements util.collection.MapView.opApply
                Время complexity: O(n)
                
                See_Also: util.collection.MapView.opApply
        
        ************************************************************************/
        
        цел opApply (цел delegate (inout K ключ, inout T значение) дг)
        {
                auto scope iterator = new MapIterator!(K, T)(this);
                return iterator.opApply (дг);
        }

        // KeySortedCollection methods

        /**
         * Implements util.collection.KeySortedCollection.comparator
         * Время complexity: O(1).
         * See_Also: util.collection.KeySortedCollection.comparator
        **/
        public final ComparatorT comparator()
        {
                return cmp;
        }

        /**
         * Use a new Comparator. Causes a reorganization
        **/

        public final проц comparator (ComparatorT c)
        {
                if (cmp !is c)
                   {
                   cmp = (c is пусто) ? &compareKey : c;

                   if (счёт !is 0)
                      {       
                      // must rebuild дерево!
                      incVersion();
                      auto t = cast(RBPairT) (дерево.leftmost());
                      дерево = пусто;
                      счёт = 0;
                      
                      while (t !is пусто)
                            {
                            добавь_(t.ключ(), t.element(), нет);
                            t = cast(RBPairT)(t.successor());
                            }
                      }
                   }
        }

        // Map methods

        /**
         * Implements util.collection.Map.containsKey.
         * Время complexity: O(лог n).
         * See_Also: util.collection.Map.containsKey
        **/
        public final бул containsKey(K ключ)
        {
                if (!isValопрKey(ключ) || счёт is 0)
                    return нет;
                return дерево.findKey(ключ, cmp) !is пусто;
        }

        /**
         * Implements util.collection.Map.containsPair.
         * Время complexity: O(n).
         * See_Also: util.collection.Map.containsPair
        **/
        public final бул containsPair(K ключ, T element)
        {
                if (счёт is 0 || !isValопрKey(ключ) || !isValопрArg(element))
                    return нет;
                return дерево.найди(ключ, element, cmp) !is пусто;
        }

        /**
         * Implements util.collection.Map.ключи.
         * Время complexity: O(1).
         * See_Also: util.collection.Map.ключи
        **/
        public final PairIterator!(K, T) ключи()
        {
                return new MapIterator!(K, T)(this);
        }

        /**
         * Implements util.collection.Map.получи.
         * Время complexity: O(лог n).
         * See_Also: util.collection.Map.получи
        **/
        public final T получи(K ключ)
        {
                if (счёт !is 0)
                   {
                   RBPairT p = дерево.findKey(ключ, cmp);
                   if (p !is пусто)
                       return p.element();
                   }
                throw new NoSuchElementException("no matching Key ");
        }

        /**
         * Return the element associated with Key ключ. 
         * @param ключ a ключ
         * Возвращает: whether the ключ is contained or not
        **/

        public final бул получи(K ключ, inout T значение)
        {
                if (счёт !is 0)
                   {
                   RBPairT p = дерево.findKey(ключ, cmp);
                   if (p !is пусто)
                      {
                      значение = p.element();
                      return да;
                      }
                   }
                return нет;
        }



        /**
         * Implements util.collection.Map.keyOf.
         * Время complexity: O(n).
         * See_Also: util.collection.Map.keyOf
        **/
        public final бул keyOf(inout K ключ, T значение)
        {
                if (!isValопрArg(значение) || счёт is 0)
                     return нет;

                auto p = (cast(RBPairT)( дерево.найди(значение, cmpElem)));
                if (p is пусто)
                    return нет;

                ключ = p.ключ();
                return да;
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
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.removeAll
        **/
        public final проц removeAll(T element)
        {
                if (!isValопрArg(element) || счёт is 0)
                      return ;

                RBPairT p = cast(RBPairT)(дерево.найди(element, cmpElem));
                while (p !is пусто)
                      {
                      дерево = cast(RBPairT)(p.удали(дерево));
                      decCount();
                      if (счёт is 0)
                          return ;
                      p = cast(RBPairT)(дерево.найди(element, cmpElem));
                      }
        }

        /**
         * Implements util.collection.impl.Collection.Collection.removeOneOf.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.removeOneOf
        **/
        public final проц удали (T element)
        {
                if (!isValопрArg(element) || счёт is 0)
                      return ;

                RBPairT p = cast(RBPairT)(дерево.найди(element, cmpElem));
                if (p !is пусто)
                   {
                   дерево = cast(RBPairT)(p.удали(дерево));
                   decCount();
                   }
        }


        /**
         * Implements util.collection.impl.Collection.Collection.replaceOneOf.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.replaceOneOf
        **/
        public final проц замени(T oldElement, T newElement)
        {
                if (счёт is 0 || !isValопрArg(oldElement) || !isValопрArg(oldElement))
                    return ;

                RBPairT p = cast(RBPairT)(дерево.найди(oldElement, cmpElem));
                if (p !is пусто)
                   {
                   checkElement(newElement);
                   incVersion();
                   p.element(newElement);
                   }
        }

        /**
         * Implements util.collection.impl.Collection.Collection.replaceAllOf.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.replaceAllOf
        **/
        public final проц replaceAll(T oldElement, T newElement)
        {
                RBPairT p = cast(RBPairT)(дерево.найди(oldElement, cmpElem));
                while (p !is пусто)
                      {
                      checkElement(newElement);
                      incVersion();
                      p.element(newElement);
                      p = cast(RBPairT)(дерево.найди(oldElement, cmpElem));
                      }
        }

        /**
         * Implements util.collection.impl.Collection.Collection.take.
         * Время complexity: O(лог n).
         * Takes the element associated with the least ключ.
         * See_Also: util.collection.impl.Collection.Collection.take
        **/
        public final T take()
        {
                if (счёт !is 0)
                   {
                   RBPairT p = cast(RBPairT)(дерево.leftmost());
                   T v = p.element();
                   дерево = cast(RBPairT)(p.удали(дерево));
                   decCount();
                   return v;
                   }

                checkIndex(0);
                return T.init; // not reached
        }


        // MutableMap methods

        /**
         * Implements util.collection.impl.MapCollection.MapCollection.добавь.
         * Время complexity: O(лог n).
         * See_Also: util.collection.impl.MapCollection.MapCollection.добавь
        **/
        public final проц добавь(K ключ, T element)
        {
                добавь_(ключ, element, да);
        }


        /**
         * Implements util.collection.impl.MapCollection.MapCollection.удали.
         * Время complexity: O(лог n).
         * See_Also: util.collection.impl.MapCollection.MapCollection.удали
        **/
        public final проц removeKey (K ключ)
        {
                if (!isValопрKey(ключ) || счёт is 0)
                      return ;

                RBCellT p = дерево.findKey(ключ, cmp);
                if (p !is пусто)
                   {
                   дерево = cast(RBPairT)(p.удали(дерево));
                   decCount();
                   }
        }


        /**
         * Implements util.collection.impl.MapCollection.MapCollection.replaceElement.
         * Время complexity: O(лог n).
         * See_Also: util.collection.impl.MapCollection.MapCollection.replaceElement
        **/
        public final проц replacePair (K ключ, T oldElement,
                                              T newElement)
        {
                if (!isValопрKey(ключ) || !isValопрArg(oldElement) || счёт is 0)
                    return ;

                RBPairT p = дерево.найди(ключ, oldElement, cmp);
                if (p !is пусто)
                   {
                   checkElement(newElement);
                   p.element(newElement);
                   incVersion();
                   }
        }


        // helper methods


        private final проц добавь_(K ключ, T element, бул checkOccurrence)
        {
                проверьКлюч(ключ);
                checkElement(element);

                if (дерево is пусто)
                   {
                   дерево = new RBPairT(ключ, element);
                   incCount();
                   }
                else
                   {
                   RBPairT t = дерево;
                   for (;;)
                       {
                       цел diff = cmp(ключ, t.ключ());
                       if (diff is 0 && checkOccurrence)
                          {
                          if (t.element() != element)
                             {
                             t.element(element);
                             incVersion();
                             }
                          return ;
                          }
                       else
                          if (diff <= 0)
                             {
                             if (t.left() !is пусто)
                                 t = cast(RBPairT)(t.left());
                             else
                                {
                                дерево = cast(RBPairT)(t.insertLeft(new RBPairT(ключ, element), дерево));
                                incCount();
                                return ;
                                }
                             }
                          else
                             {
                             if (t.right() !is пусто)
                                 t = cast(RBPairT)(t.right());
                             else
                                {
                                дерево = cast(RBPairT)(t.insertRight(new RBPairT(ключ, element), дерево));
                                incCount();
                                return ;
                                }
                             }
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
                assert(cmp !is пусто);
                assert(((счёт is 0) is (дерево is пусто)));
                assert((дерево is пусто || дерево.размер() is счёт));

                if (дерево !is пусто)
                   {
                   дерево.checkImplementation();
                   K последний = K.init;
                   RBPairT t = cast(RBPairT)(дерево.leftmost());

                   while (t !is пусто)
                         {
                         K v = t.ключ();
                         assert((последний is K.init || cmp(последний, v) <= 0));
                         последний = v;
                         t = cast(RBPairT)(t.successor());
                         }
                   }
        }


        /***********************************************************************

                opApply() есть migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        private static class MapIterator(K, V) : AbstractMapIterator!(K, V)
        {
                private RBPairT pair;

                public this (TreeMap карта)
                {
                        super (карта);

                        if (карта.дерево)
                            pair = cast(RBPairT) карта.дерево.leftmost;
                }

                public final V получи(inout K ключ)
                {
                        if (pair)
                            ключ = pair.ключ;
                        return получи();
                }

                public final V получи()
                {
                        decRemaining();
                        auto v = pair.element();
                        pair = cast(RBPairT) pair.successor();
                        return v;
                }

                цел opApply (цел delegate (inout V значение) дг)
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

                цел opApply (цел delegate (inout K ключ, inout V значение) дг)
                {
                        K   ключ;
                        цел результат;

                        for (auto i=remaining(); i--;)
                            {
                            auto значение = получи(ключ);
                            if ((результат = дг(ключ, значение)) != 0)
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
                auto карта = new TreeMap!(ткст, дво);
                карта.добавь ("foo", 1);
                карта.добавь ("baz", 1);
                карта.добавь ("bar", 2);
                карта.добавь ("wumpus", 3);

                foreach (ключ, значение; карта.ключи) {typeof(ключ) x; x = ключ;}

                foreach (значение; карта.ключи) {}

                foreach (значение; карта.elements) {}

                auto ключи = карта.ключи();
                while (ключи.ещё)
                       auto v = ключи.получи();

                foreach (значение; карта) {}

                foreach (ключ, значение; карта)
                         Квывод (ключ).нс;
                
                карта.checkImplementation();
        }
}
