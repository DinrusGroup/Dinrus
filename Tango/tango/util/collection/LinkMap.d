/*
 Файл: LinkMap.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ util.collection.d  working файл
 13Oct95  dl                 Changed protection statuses
 21Oct95  dl                 Fixed ошибка in удали

*/


module util.collection.LinkMap;

private import exception;

private import  io.protocol.model,
                io.protocol.model;

private import  util.collection.model.View,
                util.collection.model.GuardIterator;

private import  util.collection.impl.LLCell,
                util.collection.impl.LLPair,
                util.collection.impl.MapCollection,
                util.collection.impl.AbstractIterator;

/**
 * Linked lists of (ключ, element) pairs
 * author: Doug Lea
**/
deprecated public class LinkMap(K, T) : MapCollection!(K, T) // , ИЧитаемое, ИЗаписываемое
{
        alias LLCell!(T)               LLCellT;
        alias LLPair!(K, T)            LLPairT;

        alias MapCollection!(K, T).удали     удали;
        alias MapCollection!(K, T) .removeAll  removeAll;

        // экземпляр variables

        /**
         * The голова of the список. Пусто if пустой
        **/

        package LLPairT список;

        // constructors

        /**
         * Make an пустой список
        **/

        public this ()
        {
                this(пусто, пусто, 0);
        }

        /**
         * Make an пустой список with the supplied element screener
        **/

        public this (Predicate screener)
        {
                this(screener, пусто, 0);
        }

        /**
         * Special version of constructor needed by clone()
        **/
        protected this (Predicate s, LLPairT l, цел c)
        {
                super(s);
                список = l;
                счёт = c;
        }

        /**
         * Make an independent копируй of the список. Does not clone elements
        **/

        public LinkMap!(K, T) duplicate()
        {
                if (список is пусто)
                    return new LinkMap!(K, T) (screener, пусто, 0);
                else
                   return new LinkMap!(K, T) (screener, cast(LLPairT)(список.copyList()), счёт);
        }


        // Collection methods

        /**
         * Implements util.collection.impl.Collection.Collection.содержит.
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
         * Implements util.collection.impl.Collection.Collection.instances.
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
         * Implements util.collection.impl.Collection.Collection.elements.
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


        // Map methods


        /**
         * Implements util.collection.Map.containsKey.
         * Время complexity: O(n).
         * See_Also: util.collection.Map.containsKey
        **/
        public final бул containsKey(K ключ)
        {
                if (!isValопрKey(ключ) || список is пусто)
                     return нет;

                return список.findKey(ключ) !is пусто;
        }

        /**
         * Implements util.collection.Map.containsPair
         * Время complexity: O(n).
         * See_Also: util.collection.Map.containsPair
        **/
        public final бул containsPair(K ключ, T element)
        {
                if (!isValопрKey(ключ) || !isValопрArg(element) || список is пусто)
                    return нет;
                return список.найди(ключ, element) !is пусто;
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
         * Время complexity: O(n).
         * See_Also: util.collection.Map.получи
        **/
        public final T получи(K ключ)
        {
                проверьКлюч(ключ);
                if (список !is пусто)
                   {
                   auto p = список.findKey(ключ);
                   if (p !is пусто)
                       return p.element();
                   }
                throw new NoSuchElementException("no matching Key");
        }

        /**
         * Return the element associated with Key ключ. 
         * Параметры:
         *   ключ = a ключ
         * Возвращает: whether the ключ is contained or not
        **/

        public final бул получи(K ключ, inout T element)
        {
                проверьКлюч(ключ);
                if (список !is пусто)
                   {
                   auto p = список.findKey(ключ);
                   if (p !is пусто)
                      {
                      element = p.element();
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

                auto p = (cast(LLPairT)(список.найди(значение)));
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
                список = пусто;
                setCount(0);
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
         * Implements util.collection.impl.Collection.Collection.removeAll.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Collection.removeAll
        **/
        public final проц removeAll(T element)
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
         * Implements util.collection.impl.Collection.Collection.take.
         * Время complexity: O(1).
         * takes the first element on the список
         * See_Also: util.collection.impl.Collection.Collection.take
        **/
        public final T take()
        {
                if (список !is пусто)
                   {
                   auto v = список.element();
                   список = cast(LLPairT)(список.следщ());
                   decCount();
                   return v;
                   }
                checkIndex(0);
                return T.init; // not reached
        }


        // MutableMap methods

        /**
         * Implements util.collection.impl.MapCollection.MapCollection.добавь.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.MapCollection.MapCollection.добавь
        **/
        public final проц добавь (K ключ, T element)
        {
                проверьКлюч(ключ);
                checkElement(element);

                if (список !is пусто)
                   {
                   auto p = список.findKey(ключ);
                   if (p !is пусто)
                      {
                      if (p.element() != (element))
                         {
                         p.element(element);
                         incVersion();
                         }
                      return ;
                      }
                   }
                список = new LLPairT(ключ, element, список);
                incCount();
        }


        /**
         * Implements util.collection.impl.MapCollection.MapCollection.удали.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.MapCollection.MapCollection.удали
        **/
        public final проц removeKey (K ключ)
        {
                if (!isValопрKey(ключ) || список is пусто)
                    return ;

                auto p = список;
                auto trail = p;

                while (p !is пусто)
                      {
                      auto n = cast(LLPairT)(p.следщ());
                      if (p.ключ() == (ключ))
                         {
                         decCount();
                         if (p is список)
                             список = n;
                         else
                            trail.unlinkNext();
                         return ;
                         }
                      else
                         {
                         trail = p;
                         p = n;
                         }
                      }
        }

        /**
         * Implements util.collection.impl.MapCollection.MapCollection.replaceElement.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.MapCollection.MapCollection.replaceElement
        **/
        public final проц replacePair (K ключ, T oldElement, T newElement)
        {
                if (!isValопрKey(ключ) || !isValопрArg(oldElement) || список is пусто)
                     return ;

                auto p = список.найди(ключ, oldElement);
                if (p !is пусто)
                   {
                   checkElement(newElement);
                   p.element(newElement);
                   incVersion();
                   }
        }

        private final проц удали_(T element, бул allOccurrences)
        {
                if (!isValопрArg(element) || счёт is 0)
                     return ;

                auto p = список;
                auto trail = p;

                while (p !is пусто)
                      {
                      auto n = cast(LLPairT)(p.следщ());
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
                if (список is пусто || !isValопрArg(oldElement) || oldElement == (newElement))
                    return ;

                auto p = список.найди(oldElement);
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

                for (auto p = список; p !is пусто; p = cast(LLPairT)(p.следщ()))
                    {
                    assert(allows(p.element()));
                    assert(allowsKey(p.ключ()));
                    assert(containsKey(p.ключ()));
                    assert(содержит(p.element()));
                    assert(instances(p.element()) >= 1);
                    assert(containsPair(p.ключ(), p.element()));
                    }
        }


        /***********************************************************************

                opApply() есть migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        private static class MapIterator(K, V) : AbstractMapIterator!(K, V)
        {
                private LLPairT pair;
                
                public this (LinkMap карта)
                {
                        super (карта);
                        pair = карта.список;
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
                        pair = cast(LLPairT) pair.следщ();
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


         
debug(Test)
{
        проц main()
        {
                auto карта = new LinkMap!(Объект, дво);

                foreach (ключ, значение; карта.ключи) {typeof(ключ) x; x = ключ;}

                foreach (значение; карта.ключи) {}

                foreach (значение; карта.elements) {}

                auto ключи = карта.ключи();
                while (ключи.ещё)
                       auto v = ключи.получи();

                foreach (значение; карта) {}
                foreach (ключ, значение; карта) {}

                карта.checkImplementation();
        }
}
