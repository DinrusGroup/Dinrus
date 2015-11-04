/*******************************************************************************

        Файл: Collection.d

        Originally записано by Doug Lea and released преобр_в the public домен. 
        Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
        Inc, Loral, and everyone contributing, testing, and using this код.

        History:
        Date     Who                What
        24Sep95  dl@cs.oswego.edu   Create из_ util.collection.d  working файл
        13Oct95  dl                 Добавь assert
        22Oct95  dl                 Добавь excludeElements, removeElements
        28jan97  dl                 сделай class public; isolate version changes
        14Dec06  kb                 Adapted for Dinrus usage
        
********************************************************************************/

module util.collection.impl.Collection;

private import  exception;

private import  util.collection.model.View,
                util.collection.model.Iterator,
                util.collection.model.Dispenser;

/*******************************************************************************

        Collection serves as a convenient основа class for most implementations
        of mutable containers. It maintains a version число and element счёт.
        It also provопрes default implementations of many collection operations. 

        Authors: Doug Lea

********************************************************************************/

public abstract class Collection(T) : Dispenser!(T)
{
        alias View!(T)          ViewT;

        alias бул delegate(T)  Predicate;


        // экземпляр variables

        /***********************************************************************

                version represents the current version число

        ************************************************************************/

        protected бцел vershion;

        /***********************************************************************

                screener hold the supplied element screener

        ************************************************************************/

        protected Predicate screener;

        /***********************************************************************

                счёт holds the число of elements.

        ************************************************************************/

        protected бцел счёт;

        // constructors

        /***********************************************************************

                Initialize at version 0, an пустой счёт, and supplied screener

        ************************************************************************/

        protected this (Predicate screener = пусто)
        {
                this.screener = screener;
        }


        /***********************************************************************

        ************************************************************************/

        protected final static бул isValопрArg (T element)
        {
                static if (is (T : Объект))
                          {
                          if (element is пусто)
                              return нет;
                          }
                return да;
        }

        // Default implementations of Collection methods

        /***********************************************************************

                expose collection контент as an Массив

        ************************************************************************/

        public T[] toArray ()
        {
                auto результат = new T[this.размер];
        
                цел i = 0;
                foreach (e; this)
                         результат[i++] = e;

                return результат;
        }

        /***********************************************************************

                Время complexity: O(1).
                See_Also: util.collection.impl.Collection.Collection.drained

        ************************************************************************/

        public final бул drained()
        {
                return счёт is 0;
        }

        /***********************************************************************

                Время complexity: O(1).
                Возвращает: the счёт of elements currently in the collection
                See_Also: util.collection.impl.Collection.Collection.размер

        ************************************************************************/

        public final бцел размер()
        {
                return счёт;
        }

        /***********************************************************************

                Checks if element is an allowed element for this collection.
                This will not throw an исключение, but any другой attemp в_ добавь an
                не_годится element will do.

                Время complexity: O(1) + время of screener, if present

                See_Also: util.collection.impl.Collection.Collection.allows

        ************************************************************************/

        public final бул allows (T element)
        {
                return isValопрArg(element) &&
                                 (screener is пусто || screener(element));
        }


        /***********************************************************************

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

        public бул matches(ViewT другой)
        {
/+
                if (другой is пусто)
                    return нет;
                else
                   if (другой is this)
                       return да;
                   else
                      if (cast(SortedKeys) this)
                         {
                         if (!(cast(Map) другой))
                               return нет;
                         else
                            return sameOrderedPairs(cast(Map)this, cast(Map)другой);
                         }
                      else
                         if (cast(Map) this)
                            {
                            if (!(cast(Map) другой))
                                  return нет;
                            else
                               return samePairs(cast(Map)(this), cast(Map)(другой));
                            }
                         else
                            if ((cast(Seq) this) || (cast(SortedValues) this))
                                 return sameOrderedElements(this, другой);
                            else
                               if (cast(Bag) this)
                                   return sameOccurrences(this, другой);
                               else
                                  if (cast(Набор) this)
                                      return sameInclusions(this, cast(View)(другой));
                                  else
                                     return нет;
+/
                   return нет;
        }

        // Default implementations of MutableCollection methods

        /***********************************************************************

                Время complexity: O(1).
                See_Also: util.collection.impl.Collection.Collection.version

        ************************************************************************/

        public final бцел mutation()
        {
                return vershion;
        }

        // Объект methods

        /***********************************************************************

                Default implementation of вТкст for Collections. Not
                very pretty, but parenthesizing each element means that
                for most kinds of elements, it's conceivable that the
                strings could be разобрано and used в_ build другой util.collection.

                Not a very pretty implementation either. Casts are used
                в_ получи at elements/ключи

        ************************************************************************/

        public override ткст вТкст()
        {
                сим[16] врем;
                
                return "<" ~ this.classinfo.имя ~ ", размер:" ~ itoa(врем, размер()) ~ ">";
        }


        /***********************************************************************

        ************************************************************************/

        protected final ткст itoa(ткст буф, бцел i)
        {
                auto j = буф.length;
                
                do {
                   буф[--j] = cast(сим) (i % 10 + '0');
                   } while (i /= 10);
                return буф [j..$];
        }
        
        // protected operations on version and счёт

        /***********************************************************************

                change the version число

        ************************************************************************/

        protected final проц incVersion()
        {
                ++vershion;
        }


        /***********************************************************************

                Increment the element счёт and обнови version

        ************************************************************************/

        protected final проц incCount()
        {
                счёт++;
                incVersion();
        }

        /***********************************************************************

                Decrement the element счёт and обнови version

        ************************************************************************/

        protected final проц decCount()
        {
                счёт--;
                incVersion();
        }


        /***********************************************************************

                добавь в_ the element счёт and обнови version if изменён

        ************************************************************************/

        protected final проц добавьToCount(бцел c)
        {
                if (c !is 0)
                   {
                   счёт += c;
                   incVersion();
                   }
        }
        

        /***********************************************************************

                установи the element счёт and обнови version if изменён

        ************************************************************************/

        protected final проц setCount(бцел c)
        {
                if (c !is счёт)
                   {
                   счёт = c;
                   incVersion();
                   }
        }


        /***********************************************************************

                Helper метод left public since it might be useful

        ************************************************************************/

        public final static бул sameInclusions(ViewT s, ViewT t)
        {
                if (s.размер !is t.размер)
                    return нет;

                try { // установи up в_ return нет on collection exceptions
                    auto ts = t.elements();
                    while (ts.ещё)
                          {
                          if (!s.содержит(ts.получи))
                              return нет;
                          }
                    return да;
                    } catch (NoSuchElementException ex)
                            {
                            return нет;
                            }
        }

        /***********************************************************************

                Helper метод left public since it might be useful

        ************************************************************************/

        public final static бул sameOccurrences(ViewT s, ViewT t)
        {
                if (s.размер !is t.размер)
                    return нет;

                auto ts = t.elements();
                T последний = T.init; // minor optimization -- пропусти two successive if same

                try { // установи up в_ return нет on collection exceptions
                    while (ts.ещё)
                          {
                          T m = ts.получи;
                          if (m !is последний)
                             {
                             if (s.instances(m) !is t.instances(m))
                                 return нет;
                             }
                          последний = m;
                          }
                    return да;
                    } catch (NoSuchElementException ex)
                            {
                            return нет;
                            }
        }
        

        /***********************************************************************

                Helper метод left public since it might be useful

        ************************************************************************/

        public final static бул sameOrderedElements(ViewT s, ViewT t)
        {
                if (s.размер !is t.размер)
                    return нет;

                auto ts = t.elements();
                auto ss = s.elements();

                try { // установи up в_ return нет on collection exceptions
                    while (ts.ещё)
                          {
                          T m = ts.получи;
                          T o = ss.получи;
                          if (m != o)
                              return нет;
                          }
                    return да;
                    } catch (NoSuchElementException ex)
                            {       
                            return нет;
                            }
        }

        // misc common helper methods

        /***********************************************************************

                PrincИПal метод в_ throw a NoSuchElementException.
                Besопрes индекс checks in Seqs, you can use it в_ check for
                operations on пустой collections via checkIndex(0)

        ************************************************************************/

        protected final проц checkIndex(цел индекс)
        {
                if (индекс < 0 || индекс >= счёт)
                   {
                   ткст сооб;

                   if (счёт is 0)
                       сооб = "Element access on пустой collection";
                   else
                      {
                      сим[16] инд, cnt;
                      сооб = "Index " ~ itoa (инд, индекс) ~ " out of range for collection of размер " ~ itoa (cnt, счёт);
                      }
                   throw new NoSuchElementException(сооб);
                   }
        }

        
        /***********************************************************************

                PrincИПal метод в_ throw a IllegalElementException

        ************************************************************************/

        protected final проц checkElement(T element)
        {
                if (! allows(element))
                   {
                   throw new IllegalElementException("Attempt в_ include не_годится element _in Collection");
                   }
        }

        /***********************************************************************

                See_Also: util.collection.model.View.View.checkImplementation

        ************************************************************************/

        public проц checkImplementation()
        {
                assert(счёт >= 0);
        }
        //public override проц checkImplementation() //Doesn't компилируй with the override attribute

        /***********************************************************************

                Cause the collection в_ become пустой. 

        ************************************************************************/

        abstract проц сотри();

        /***********************************************************************

                Exclude все occurrences of the indicated element из_ the collection. 
                No effect if element not present.
                Параметры:
                    element = the element в_ exclude.
                ---
                !есть(element) &&
                размер() == PREV(this).размер() - PREV(this).instances(element) &&
                no другой element changes &&
                Версия change iff PREV(this).есть(element)
                ---

        ************************************************************************/

        abstract проц removeAll(T element);

        /***********************************************************************

                Удали an экземпляр of the indicated element из_ the collection. 
                No effect if !есть(element)
                Параметры:
                    element = the element в_ удали
                ---
                let occ = max(1, instances(element)) in
                 размер() == PREV(this).размер() - occ &&
                 instances(element) == PREV(this).instances(element) - occ &&
                 no другой element changes &&
                 version change iff occ == 1
                ---

        ************************************************************************/

        abstract проц удали (T element);
        
        /***********************************************************************

                Замени an occurrence of oldElement with newElement.
                No effect if does not hold oldElement or if oldElement.равно(newElement).
                The operation есть a consistent, but slightly special interpretation
                when applied в_ Sets. For Sets, because elements occur at
                most once, if newElement is already included, replacing oldElement with
                with newElement есть the same effect as just removing oldElement.
                ---
                let цел delta = oldElement.равно(newElement)? 0 : 
                              max(1, PREV(this).instances(oldElement) in
                 instances(oldElement) == PREV(this).instances(oldElement) - delta &&
                 instances(newElement) ==  (this instanceof Набор) ? 
                        max(1, PREV(this).instances(oldElement) + delta):
                               PREV(this).instances(oldElement) + delta) &&
                 no другой element changes &&
                 Версия change iff delta != 0
                ---
                Throws: IllegalElementException if есть(oldElement) and !allows(newElement)

        ************************************************************************/

        abstract проц замени (T oldElement, T newElement);

        /***********************************************************************

                Замени все occurrences of oldElement with newElement.
                No effect if does not hold oldElement or if oldElement.равно(newElement).
                The operation есть a consistent, but slightly special interpretation
                when applied в_ Sets. For Sets, because elements occur at
                most once, if newElement is already included, replacing oldElement with
                with newElement есть the same effect as just removing oldElement.
                ---
                let цел delta = oldElement.равно(newElement)? 0 : 
                           PREV(this).instances(oldElement) in
                 instances(oldElement) == PREV(this).instances(oldElement) - delta &&
                 instances(newElement) ==  (this instanceof Набор) ? 
                        max(1, PREV(this).instances(oldElement) + delta):
                               PREV(this).instances(oldElement) + delta) &&
                 no другой element changes &&
                 Версия change iff delta != 0
                ---
                Throws: IllegalElementException if есть(oldElement) and !allows(newElement)

        ************************************************************************/

        abstract проц replaceAll(T oldElement, T newElement);

        /***********************************************************************

                Exclude все occurrences of each element of the Обходчик.
                Behaviorally equivalent в_
                ---
                while (e.ещё())
                  removeAll(e.получи());
                ---
                Param :
                    e = the enumeration of elements в_ exclude.

                Throws: CorruptedIteratorException is propagated if thrown

                See_Also: util.collection.impl.Collection.Collection.removeAll

        ************************************************************************/

        abstract проц removeAll (Обходчик!(T) e);

        /***********************************************************************

                 Удали an occurrence of each element of the Обходчик.
                 Behaviorally equivalent в_

                 ---
                 while (e.ещё())
                    удали (e.получи());
                 ---

                 Param:
                    e = the enumeration of elements в_ удали.

                 Throws: CorruptedIteratorException is propagated if thrown

        ************************************************************************/

        abstract проц удали (Обходчик!(T) e);

        /***********************************************************************

                Удали and return an element.  Implementations
                may strengthen the guarantee about the nature of this element.
                but in general it is the most convenient or efficient element в_ удали.

                Examples:
                One way в_ перемести все elements из_ 
                MutableCollection a в_ MutableBag b is:
                ---
                while (!a.пустой())
                    b.добавь(a.take());
                ---

                Возвращает:
                    an element v such that PREV(this).есть(v) 
                    and the postconditions of removeOneOf(v) hold.

                Throws: NoSuchElementException iff drained.

        ************************************************************************/

        abstract T take();
}


