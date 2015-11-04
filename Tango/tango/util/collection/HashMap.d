/*******************************************************************************

        Файл: HashMap.d

        Originally записано by Doug Lea and released преобр_в the public домен. 
        Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
        Inc, Loral, and everyone contributing, testing, and using this код.

        History:
        Date     Who                What
        24Sep95  dl@cs.oswego.edu   Create из_ collection.d  working файл
        13Oct95  dl                 Changed protection statuses
        21Oct95  dl                 fixed ошибка in removeAt
        9Apr97   dl                 made Serializable
        14Dec06  kb                 Converted, templated & reshaped for Dinrus
        
********************************************************************************/

module util.collection.HashMap;

private import  exception;

/+
private import  io.protocol.model,
                io.protocol.model;
+/
private import  util.collection.model.HashParams,
                util.collection.model.GuardIterator;

private import  util.collection.impl.LLCell,
                util.collection.impl.LLPair,
                util.collection.impl.MapCollection,
                util.collection.impl.AbstractIterator;

/*******************************************************************************

         Hash table implementation of Map
                
         author: Doug Lea
                @version 0.94

         <P> For an introduction в_ this package see <A HREF="индекс.html"
         > Overview </A>.

********************************************************************************/


deprecated public class HashMap(K, V) : MapCollection!(K, V), HashParams
{
        alias LLCell!(V)                LLCellT;
        alias LLPair!(K, V)             LLPairT;

        alias MapCollection!(K, V).удали     удали;
        alias MapCollection!(K, V).removeAll  removeAll;

        // экземпляр variables

        /***********************************************************************

                The table. Each Запись is a список. Пусто if no table allocated

        ************************************************************************/
  
        private LLPairT table[];

        /***********************************************************************

                The threshold загрузи factor

        ************************************************************************/

        private плав loadFactor;


        // constructors

        /***********************************************************************

                Make a new пустой карта в_ use given element screener.
        
        ************************************************************************/

        public this (Predicate screener = пусто)
        {
                this(screener, defaultLoadFactor);
        }

        /***********************************************************************

                Special version of constructor needed by clone()
        
        ************************************************************************/

        protected this (Predicate s, плав f)
        {
                super(s);
                table = пусто;
                loadFactor = f;
        }

        /***********************************************************************

                Make an independent копируй of the table. Elements themselves
                are not cloned.
        
        ************************************************************************/

        public final HashMap!(K, V) duplicate()
        {
                auto c = new HashMap!(K, V) (screener, loadFactor);

                if (счёт !is 0)
                   {
                   цел cap = 2 * cast(цел)((счёт / loadFactor)) + 1;
                   if (cap < defaultInitialBuckets)
                       cap = defaultInitialBuckets;

                   c.buckets(cap);

                   for (цел i = 0; i < table.length; ++i)
                        for (LLPairT p = table[i]; p !is пусто; p = cast(LLPairT)(p.следщ()))
                             c.добавь (p.ключ(), p.element());
                   }
                return c;
        }


        // HashParams methods

        /***********************************************************************

                Implements util.collection.HashParams.buckets.
                Время complexity: O(1).
                
                See_Also: util.collection.HashParams.buckets.
        
        ************************************************************************/

        public final цел buckets()
        {
                return (table is пусто) ? 0 : table.length;
        }

        /***********************************************************************

                Implements util.collection.HashParams.buckets.
                Время complexity: O(n).
                
                See_Also: util.collection.HashParams.buckets.
        
        ************************************************************************/

        public final проц buckets(цел newCap)
        {
                if (newCap is buckets())
                    return ;
                else
                   if (newCap >= 1)
                       resize(newCap);
                   else
                      throw new ИсклНелегальногоАргумента("Invalid Hash table размер");
        }

        /***********************************************************************

                Implements util.collection.HashParams.thresholdLoadfactor
                Время complexity: O(1).
                
                See_Also: util.collection.HashParams.thresholdLoadfactor
        
        ************************************************************************/

        public final плав пороговыйФакторЗагрузки()
        {
                return loadFactor;
        }

        /***********************************************************************

                Implements util.collection.HashParams.thresholdLoadfactor
                Время complexity: O(n).
                
                See_Also: util.collection.HashParams.thresholdLoadfactor
        
        ************************************************************************/

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



        // View methods

        /***********************************************************************

                Implements util.collection.model.View.View.содержит.
                Время complexity: O(1) average; O(n) worst.
                
                See_Also: util.collection.model.View.View.содержит
        
        ************************************************************************/
        
        public final бул содержит(V element)
        {
                if (!isValопрArg(element) || счёт is 0)
                    return нет;

                for (цел i = 0; i < table.length; ++i)
                    {
                    LLPairT hd = table[i];
                    if (hd !is пусто && hd.найди(element) !is пусто)
                        return да;
                    }
                return нет;
        }

        /***********************************************************************

                Implements util.collection.model.View.View.instances.
                Время complexity: O(n).
                
                See_Also: util.collection.model.View.View.instances
        
        ************************************************************************/
        
        public final бцел instances(V element)
        {
                if (!isValопрArg(element) || счёт is 0)
                    return 0;
    
                бцел c = 0;
                for (бцел i = 0; i < table.length; ++i)
                    {
                    LLPairT hd = table[i];
                    if (hd !is пусто)
                        c += hd.счёт(element);
                    }
                return c;
        }

        /***********************************************************************

                Implements util.collection.model.View.View.elements.
                Время complexity: O(1).
                
                See_Also: util.collection.model.View.View.elements
        
        ************************************************************************/
        
        public final GuardIterator!(V) elements()
        {
                return ключи();
        }

        /***********************************************************************

                Implements util.collection.model.View.View.opApply
                Время complexity: O(n)
                
                See_Also: util.collection.model.View.View.opApply
        
        ************************************************************************/
        
        цел opApply (цел delegate (inout V значение) дг)
        {
                auto scope iterator = new MapIterator!(K, V)(this);
                return iterator.opApply (дг);
        }


        /***********************************************************************

                Implements util.collection.MapView.opApply
                Время complexity: O(n)
                
                See_Also: util.collection.MapView.opApply
        
        ************************************************************************/
        
        цел opApply (цел delegate (inout K ключ, inout V значение) дг)
        {
                auto scope iterator = new MapIterator!(K, V)(this);
                return iterator.opApply (дг);
        }


        // Map methods

        /***********************************************************************

                Implements util.collection.Map.containsKey.
                Время complexity: O(1) average; O(n) worst.
                
                See_Also: util.collection.Map.containsKey
        
        ************************************************************************/
        
        public final бул containsKey(K ключ)
        {
                if (!isValопрKey(ключ) || счёт is 0)
                    return нет;

                LLPairT p = table[hashOf(ключ)];
                if (p !is пусто)
                    return p.findKey(ключ) !is пусто;
                else
                   return нет;
        }

        /***********************************************************************

                Implements util.collection.Map.containsPair
                Время complexity: O(1) average; O(n) worst.
                
                See_Also: util.collection.Map.containsPair
        
        ************************************************************************/
        
        public final бул containsPair(K ключ, V element)
        {
                if (!isValопрKey(ключ) || !isValопрArg(element) || счёт is 0)
                    return нет;

                LLPairT p = table[hashOf(ключ)];
                if (p !is пусто)
                    return p.найди(ключ, element) !is пусто;
                else
                   return нет;
        }

        /***********************************************************************

                Implements util.collection.Map.ключи.
                Время complexity: O(1).
                
                See_Also: util.collection.Map.ключи
        
        ************************************************************************/
        
        public final PairIterator!(K, V) ключи()
        {
                return new MapIterator!(K, V)(this);
        }

        /***********************************************************************

                Implements util.collection.Map.получи.
                Время complexity: O(1) average; O(n) worst.
                
                See_Also: util.collection.Map.at
        
        ************************************************************************/
        
        public final V получи(K ключ)
        {
                проверьКлюч(ключ);
                if (счёт !is 0)
                   {
                   LLPairT p = table[hashOf(ключ)];
                   if (p !is пусто)
                      {
                      LLPairT c = p.findKey(ключ);
                      if (c !is пусто)
                          return c.element();
                      }
                   }
                throw new NoSuchElementException("no matching ключ");
        }


        /***********************************************************************

                Return the element associated with Key ключ. 
                @param ключ a ключ
                Возвращает: whether the ключ is contained or not
        
        ************************************************************************/

        public бул получи(K ключ, inout V element)
        {
                проверьКлюч(ключ);
                if (счёт !is 0)
                   {
                   LLPairT p = table[hashOf(ключ)];
                   if (p !is пусто)
                      {
                      LLPairT c = p.findKey(ключ);
                      if (c !is пусто)
                         {
                         element = c.element();
                         return да;
                         }
                      }
                   }
                return нет;
        }



        /***********************************************************************

                Implements util.collection.Map.keyOf.
                Время complexity: O(n).
                
                See_Also: util.collection.Map.akyOf
        
        ************************************************************************/
        
        public final бул keyOf(inout K ключ, V значение)
        {
                if (!isValопрArg(значение) || счёт is 0)
                    return нет;

                for (цел i = 0; i < table.length; ++i)
                    { 
                    LLPairT hd = table[i];
                    if (hd !is пусто)
                       {
                       auto p = (cast(LLPairT)(hd.найди(значение)));
                       if (p !is пусто)
                          {
                          ключ = p.ключ();
                          return да;
                          }
                       }
                    }
                return нет;
        }


        // Collection methods

        /***********************************************************************

                Implements util.collection.impl.Collection.Collection.сотри.
                Время complexity: O(1).
                
                See_Also: util.collection.impl.Collection.Collection.сотри
        
        ************************************************************************/
        
        public final проц сотри()
        {
                setCount(0);
                table = пусто;
        }

        /***********************************************************************

                Implements util.collection.impl.Collection.Collection.removeAll.
                Время complexity: O(n).
                
                See_Also: util.collection.impl.Collection.Collection.removeAll
        
        ************************************************************************/
        
        public final проц removeAll (V element)
        {
                удали_(element, да);
        }


        /***********************************************************************

                Implements util.collection.impl.Collection.Collection.removeOneOf.
                Время complexity: O(n).
                
                See_Also: util.collection.impl.Collection.Collection.removeOneOf
        
        ************************************************************************/
        
        public final проц удали (V element)
        {
                удали_(element, нет);
        }


        /***********************************************************************

                Implements util.collection.impl.Collection.Collection.replaceOneOf.
                Время complexity: O(n).
                
                See_Also: util.collection.impl.Collection.Collection.replaceOneOf
        
        ************************************************************************/

        public final проц замени (V oldElement, V newElement)
        {
                замени_(oldElement, newElement, нет);
        }

        /***********************************************************************

                Implements util.collection.impl.Collection.Collection.replaceOneOf.
                Время complexity: O(n).
                
                See_Also: util.collection.impl.Collection.Collection.replaceOneOf
        
        ************************************************************************/

        public final проц replaceAll (V oldElement, V newElement)
        {
                замени_(oldElement, newElement, да);
        }

        /***********************************************************************

                Implements util.collection.impl.Collection.Collection.take.
                Время complexity: O(число of buckets).
                
                See_Also: util.collection.impl.Collection.Collection.take
        
        ************************************************************************/
        
        public final V take()
        {
                if (счёт !is 0)
                   {
                   for (цел i = 0; i < table.length; ++i)
                       {
                       if (table[i] !is пусто)
                          {
                          decCount();
                          auto v = table[i].element();
                          table[i] = cast(LLPairT)(table[i].следщ());
                          return v;
                          }
                       }
                   }
                checkIndex(0);
                return V.init; // not reached
        }

        // Map methods

        /***********************************************************************

                Implements util.collection.Map.добавь.
                Время complexity: O(1) average; O(n) worst.
                
                See_Also: util.collection.Map.добавь
        
        ************************************************************************/
        
        public final проц добавь (K ключ, V element)
        {
                проверьКлюч(ключ);
                checkElement(element);

                if (table is пусто)
                    resize (defaultInitialBuckets);

                цел h = hashOf(ключ);
                LLPairT hd = table[h];
                if (hd is пусто)
                   {
                   table[h] = new LLPairT(ключ, element, hd);
                   incCount();
                   return;
                   }
                else
                   {
                   LLPairT p = hd.findKey(ключ);
                   if (p !is пусто)
                      {
                      if (p.element() != (element))
                         {
                         p.element(element);
                         incVersion();
                         }
                      }
                   else
                      {
                      table[h] = new LLPairT(ключ, element, hd);
                      incCount();
                      checkLoadFactor(); // we only check загрузи factor on добавь в_ Неукmpty bin
                      }
                   }
        }


        /***********************************************************************

                Implements util.collection.Map.удали.
                Время complexity: O(1) average; O(n) worst.
                
                See_Also: util.collection.Map.удали
        
        ************************************************************************/
        
        public final проц removeKey (K ключ)
        {
                if (!isValопрKey(ключ) || счёт is 0)
                    return;

                цел h = hashOf(ключ);
                LLPairT hd = table[h];
                LLPairT p = hd;
                LLPairT trail = p;

                while (p !is пусто)
                      {
                      LLPairT n = cast(LLPairT)(p.следщ());
                      if (p.ключ() == (ключ))
                         {
                         decCount();
                         if (p is hd)
                             table[h] = n;
                         else
                            trail.unlinkNext();
                         return;
                         }
                      else
                         {
                         trail = p;
                         p = n;
                         }
                      }
        }

        /***********************************************************************

                Implements util.collection.Map.replaceElement.
                Время complexity: O(1) average; O(n) worst.
                
                See_Also: util.collection.Map.replaceElement
        
        ************************************************************************/
        
        public final проц replacePair (K ключ, V oldElement, V newElement)
        {
                if (!isValопрKey(ключ) || !isValопрArg(oldElement) || счёт is 0)
                    return;

                LLPairT p = table[hashOf(ключ)];
                if (p !is пусто)
                   {
                   LLPairT c = p.найди(ключ, oldElement);
                   if (c !is пусто)
                      {
                      checkElement(newElement);
                      c.element(newElement);
                      incVersion();
                      }
                   }
        }

        // Helper methods

        /***********************************************************************

                Check в_ see if we are past загрузи factor threshold. If so,
                resize so that we are at half of the desired threshold.
                Also while at it, check в_ see if we are пустой so can just
                unlink table.
        
        ************************************************************************/
        
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

        /***********************************************************************

                маска off and remainder the hashCode for element
                so it can be used as table индекс
        
        ************************************************************************/

        protected final цел hashOf(K ключ)
        {
                return (typeid(K).дайХэш(&ключ) & 0x7FFFFFFF) % table.length;
        }


        /***********************************************************************

        ************************************************************************/

        protected final проц resize(цел newCap)
        {
                LLPairT newtab[] = new LLPairT[newCap];

                if (table !is пусто)
                   {
                   for (цел i = 0; i < table.length; ++i)
                       {
                       LLPairT p = table[i];
                       while (p !is пусто)
                             {
                             LLPairT n = cast(LLPairT)(p.следщ());
                             цел h = (p.keyHash() & 0x7FFFFFFF) % newCap;
                             p.следщ(newtab[h]);
                             newtab[h] = p;
                             p = n;
                             }
                       }
                   }
                table = newtab;
                incVersion();
        }

        // helpers

        /***********************************************************************

        ************************************************************************/

        private final проц удали_(V element, бул allOccurrences)
        {
                if (!isValопрArg(element) || счёт is 0)
                    return;

                for (цел h = 0; h < table.length; ++h)
                    {
                    LLCellT hd = table[h];
                    LLCellT p = hd;
                    LLCellT trail = p;
                    while (p !is пусто)
                          {
                          LLPairT n = cast(LLPairT)(p.следщ());
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
                             if (! allOccurrences)
                                   return;
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
        }

        /***********************************************************************

        ************************************************************************/

        private final проц замени_(V oldElement, V newElement, бул allOccurrences)
        {
                if (счёт is 0 || !isValопрArg(oldElement) || oldElement == (newElement))
                    return;

                for (цел h = 0; h < table.length; ++h)
                    {
                    LLCellT hd = table[h];
                    LLCellT p = hd;
                    LLCellT trail = p;
                    while (p !is пусто)
                          {
                          LLPairT n = cast(LLPairT)(p.следщ());
                          if (p.element() == (oldElement))
                             {
                             checkElement(newElement);
                             incVersion();
                             p.element(newElement);
                             if (! allOccurrences)
                                   return ;
                             }
                          trail = p;
                          p = n;
                          }
                    }
        }

/+
        // ИЧитатель & ИПисатель methods

        /***********************************************************************

        ************************************************************************/

        public override проц читай (ИЧитатель ввод)
        {
                цел     длин;
                K       ключ;
                V       element;
                
                ввод (длин) (loadFactor) (счёт);
                table = (длин > 0) ? new LLPairT[длин] : пусто;

                for (длин=счёт; длин-- > 0;)
                    {
                    ввод (ключ) (element);
                    
                    цел h = hashOf (ключ);
                    table[h] = new LLPairT (ключ, element, table[h]);
                    }
        }
                        
        /***********************************************************************

        ************************************************************************/

        public override проц пиши (ИПисатель вывод)
        {
                вывод (table.length) (loadFactor) (счёт);

                if (table.length > 0)
                    foreach (ключ, значение; ключи)
                             вывод (ключ) (значение);
        }
        
+/
        // ImplementationCheckable methods

        /***********************************************************************

                Implements util.collection.model.View.View.checkImplementation.
                
                See_Also: util.collection.model.View.View.checkImplementation
        
        ************************************************************************/
                        
        public override проц checkImplementation()
        {
                super.checkImplementation();

                assert(!(table is пусто && счёт !is 0));
                assert((table is пусто || table.length > 0));
                assert(loadFactor > 0.0f);

                if (table is пусто)
                    return;

                цел c = 0;
                for (цел i = 0; i < table.length; ++i)
                    {
                    for (LLPairT p = table[i]; p !is пусто; p = cast(LLPairT)(p.следщ()))
                        {
                        ++c;
                        assert(allows(p.element()));
                        assert(allowsKey(p.ключ()));
                        assert(containsKey(p.ключ()));
                        assert(содержит(p.element()));
                        assert(instances(p.element()) >= 1);
                        assert(containsPair(p.ключ(), p.element()));
                        assert(hashOf(p.ключ()) is i);
                        }
                    }
                assert(c is счёт);


        }


        /***********************************************************************

                opApply() есть migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        private static class MapIterator(K, V) : AbstractMapIterator!(K, V)
        {
                private цел             row;
                private LLPairT         pair;
                private LLPairT[]       table;

                public this (HashMap карта)
                {
                        super (карта);
                        table = карта.table;
                }

                public final V получи(inout K ключ)
                {
                        auto v = получи();
                        ключ = pair.ключ;
                        return v;
                }

                public final V получи()
                {
                        decRemaining();

                        if (pair)
                            pair = cast(LLPairT) pair.следщ();

                        while (pair is пусто)
                               pair = table [row++];

                        return pair.element();
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
        import io.Console;
                        
        проц main()
        {
                auto карта = new HashMap!(ткст, дво);
                карта.добавь ("foo", 3.14);
                карта.добавь ("bar", 6.28);

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

                Квывод (карта).нс;
        }
}
