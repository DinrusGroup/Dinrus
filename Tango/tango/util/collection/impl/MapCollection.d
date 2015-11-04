/*******************************************************************************

        Файл: MapCollection.d

        Originally записано by Doug Lea and released преобр_в the public домен. 
        Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
        Inc, Loral, and everyone contributing, testing, and using this код.

        History:
        Date     Who                What
        13Oct95  dl                 Create
        28jan97  dl                 сделай class public
        14Dec06  kb                 adapted for Dinrus usage

********************************************************************************/

module util.collection.impl.MapCollection;

private import  exception;

private import  util.collection.impl.Collection;

private import  util.collection.model.Map,
                util.collection.model.View,
                util.collection.model.MapView,
                util.collection.model.Iterator,
                util.collection.model.SortedKeys;


/*******************************************************************************

        MapCollection extends Collection в_ provопрe default implementations of
        some Map operations. 
                
        author: Doug Lea
                @version 0.93

        <P> For an introduction в_ this package see <A HREF="индекс.html"
        > Overview </A>.

 ********************************************************************************/

public abstract class MapCollection(K, T) : Collection!(T), Map!(K, T)
{
        alias MapView!(K, T)            MapViewT;
        alias Collection!(T).удали     удали;
        alias Collection!(T).removeAll  removeAll;


        /***********************************************************************

                Initialize at version 0, an пустой счёт, and пусто screener

        ************************************************************************/

        protected this ()
        {
                super();
        }

        /***********************************************************************

                Initialize at version 0, an пустой счёт, and supplied screener

        ************************************************************************/

        protected this (Predicate screener)
        {
                super(screener);
        }

        /***********************************************************************

                Implements util.collection.Map.allowsKey.
                Default ключ-screen. Just checks for пусто.
                
                See_Also: util.collection.Map.allowsKey

        ************************************************************************/

        public final бул allowsKey(K ключ)
        {
                return (ключ !is K.init);
        }

        protected final бул isValопрKey(K ключ)
        {
                static if (is (K /*: Объект*/))
                          {
                          if (ключ is пусто)
                              return нет;
                          }
                return да;
        }

        /***********************************************************************

                PrincИПal метод в_ throw a IllegalElementException for ключи

        ************************************************************************/

        protected final проц проверьКлюч(K ключ)
        {
                if (!isValопрKey(ключ))
                   {
                   throw new IllegalElementException("Attempt в_ include не_годится ключ _in Collection");
                   }
        }

        /***********************************************************************

                Implements util.collection.impl.MapCollection.MapCollection.opIndexAssign
                Just calls добавь(ключ, element).

                See_Also: util.collection.impl.MapCollection.MapCollection.добавь

        ************************************************************************/

        public final проц opIndexAssign (T element, K ключ)
        {
                добавь (ключ, element);
        }

        /***********************************************************************

                Implements util.collection.impl.Collection.Collection.matches
                Время complexity: O(n).
                Default implementation. Fairly sleazy approach.
                (Defensible only when you remember that it is just a default impl.)
                It tries в_ cast в_ one of the known collection interface типы
                and then applies the corresponding comparison rules.
                This suffices for все currently supported collection типы,
                but must be overrопрden if you define new Collection subinterfaces
                and/or implementations.
                
                See_Also: util.collection.impl.Collection.Collection.matches

        ************************************************************************/

        public override бул matches(View!(T) другой)
        {
                if (другой is пусто)
                   {}
                else
                   if (другой is this)
                       return да;
                   else
                      {
                      auto врем = cast (MapViewT) другой;
                      if (врем)
                          if (cast(SortedKeys!(K, T)) this)
                              return sameOrderedPairs(this, врем);
                          else
                             return samePairs(this, врем);
                      }
                return нет;
        }


        public final static бул samePairs(MapViewT s, MapViewT t)
        {
                if (s.размер !is t.размер)
                    return нет;

                try { // установи up в_ return нет on collection exceptions
                    foreach (ключ, значение; t.ключи)
                             if (! s.containsPair (ключ, значение))
                                   return нет;
                    } catch (NoSuchElementException ex)
                            {
                            return нет;
                            }
                return да;
        }

        public final static бул sameOrderedPairs(MapViewT s, MapViewT t)
        {
                if (s.размер !is t.размер)
                    return нет;

                auto ss = s.ключи();
                try { // установи up в_ return нет on collection exceptions
                    foreach (ключ, значение; t.ключи)
                            {
                            K sk;
                            auto sv = ss.получи (sk);
                            if (sk != ключ || sv != значение)
                                return нет;
                            }
                    } catch (NoSuchElementException ex)
                            {
                            return нет;
                            }
                return да;
        }


        // Объект methods

        /***********************************************************************

                Implements util.collection.impl.Collection.Collection.removeAll
                See_Also: util.collection.impl.Collection.Collection.removeAll

                Has в_ be here rather than in the superclass в_ satisfy
                D interface опрioms

        ************************************************************************/

        public проц removeAll (Обходчик!(T) e)
        {
                while (e.ещё)
                       removeAll (e.получи);
        }

        /***********************************************************************

                Implements util.collection.impl.Collection.Collection.removeElements
                See_Also: util.collection.impl.Collection.Collection.removeElements

                Has в_ be here rather than in the superclass в_ satisfy
                D interface опрioms

        ************************************************************************/

        public проц удали (Обходчик!(T) e)
        {
                while (e.ещё)
                       удали (e.получи);
        }
}

