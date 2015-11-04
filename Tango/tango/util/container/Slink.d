/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Apr 2008: Initial release

        authors:        Kris

        Since:          0.99.7

        Based upon Doug Lea's Java collection package

*******************************************************************************/

module util.container.Slink;

private import util.container.model.IContainer;

/*******************************************************************************

        Slink instances provопрe стандарт linked список следщ-fields, and
        support стандарт operations upon them. Slink structures are pure
        implementation tools, and perform no аргумент checking, no результат
        screening, and no synchronization. They rely on пользователь-уровень classes
        (see HashSet, for example) в_ do such things.

        Still, Slink is made `public' so that you can use it в_ build другой
        kinds of containers
        
        Note that when K is specified, support for ключи are включен. When
        Идентичность is stИПulated as 'да', those ключи are compared using an
        опрentity-comparison instead of equality (using 'is'). Similarly, if
        HashCache is установи да, an добавьitional attribute is создай in order в_
        retain the hash of K

*******************************************************************************/

private typedef цел KeyDummy;

struct Slink (V, K=KeyDummy, бул Идентичность = нет, бул HashCache = нет)
{
        alias Slink!(V, K, Идентичность, HashCache) Тип;
        alias Тип                              *Ref;
        alias Compare!(V)                       Comparator;

        Ref             следщ;           // pointer в_ следщ
        V               значение;          // element значение

        static if (HashCache == да)
        {
        т_хэш       cache;             // retain hash значение?
        }
                
        /***********************************************************************

                добавь support for ключи also?
                
        ***********************************************************************/

        static if (!is(typeof(K) == KeyDummy))
        {
                K ключ;

                final Ref установи (K k, V v, Ref n)
                {
                        ключ = k;
                        return установи (v, n);
                }

                final цел hash()
                {
                        return typeid(K).дайХэш(&ключ);
                }

                final Ref findKey (K ключ)
                {
                        static if (Идентичность == да)
                        {
                           for (auto p=this; p; p = p.следщ)
                                if (ключ is p.ключ)
                                    return p;
                        }
                        else
                        {
                           for (auto p=this; p; p = p.следщ)
                                if (ключ == p.ключ)
                                    return p;
                        }
                        return пусто;
                }

                final Ref найдиПару (K ключ, V значение)
                {
                        static if (Идентичность == да)
                        {
                           for (auto p=this; p; p = p.следщ)
                                if (ключ is p.ключ && значение == p.значение)
                                    return p;
                        }
                        else
                        {
                           for (auto p=this; p; p = p.следщ)
                                if (ключ == p.ключ && значение == p.значение)
                                    return p;
                        }
                        return пусто;
                }

                final цел индексируйКлюч (K ключ)
                {
                        цел i = 0;
                        static if (Идентичность == да)
                        {
                           for (auto p=this; p; p = p.следщ, ++i)
                                if (ключ is p.ключ)
                                    return i;
                        }
                        else
                        {
                           for (auto p=this; p; p = p.следщ, ++i)
                                if (ключ == p.ключ)
                                    return i;
                        }
                        return -1;
                }

                final цел индексируйПару (K ключ, V значение)
                {
                        цел i = 0;
                        static if (Идентичность == да)
                        {
                           for (auto p=this; p; p = p.следщ, ++i)
                                if (ключ is p.ключ && значение == p.значение)
                                    return i;
                        }
                        else
                        {
                           for (auto p=this; p; p = p.следщ, ++i)
                                if (ключ == p.ключ && значение == p.значение)
                                    return i;
                        }
                        return -1;
                }

                final цел учтиКлюч (K ключ)
                {
                        цел c = 0;
                        static if (Идентичность == да)
                        {
                           for (auto p=this; p; p = p.следщ)
                                if (ключ is p.ключ)
                                    ++c;
                        }
                        else
                        {
                           for (auto p=this; p; p = p.следщ)
                                if (ключ == p.ключ)
                                    ++c;
                        }
                        return c;
                }

                final цел учтиПару (K ключ, V значение)
                {
                        цел c = 0;
                        static if (Идентичность == да)
                        {
                           for (auto p=this; p; p = p.следщ)
                                if (ключ is p.ключ && значение == p.значение)
                                    ++c;
                        }
                        else
                        {
                           for (auto p=this; p; p = p.следщ)
                                if (ключ == p.ключ && значение == p.значение)
                                    ++c;
                        }
                        return c;
                }
        }
        
        /***********************************************************************

                 Набор в_ point в_ n as следщ cell

                 param: n, the new следщ cell
                        
        ***********************************************************************/

        final Ref установи (V v, Ref n)
        {
                следщ = n;
                значение = v;
                return this;
        }

        /***********************************************************************

                 Splice in p between current cell and whatever it was
                 previously pointing в_

                 param: p, the cell в_ splice
                        
        ***********************************************************************/

        final проц прикрепи (Ref p)
        {
                if (p)
                    p.следщ = следщ;
                следщ = p;
        }

        /***********************************************************************

                Cause current cell в_ пропусти over the current следщ() one, 
                effectively removing the следщ element из_ the список
                        
        ***********************************************************************/

        final проц отторочьСледщ()
        {
                if (следщ)
                    следщ = следщ.следщ;
        }

        /***********************************************************************

                 Linear search down the список looking for element
                 
                 param: element в_ look for
                 Возвращает: the cell containing element, or пусто if no such
                 
        ***********************************************************************/

        final Ref найди (V element)
        {
                for (auto p = this; p; p = p.следщ)
                     if (element == p.значение)
                         return p;
                return пусто;
        }

        /***********************************************************************

                Return the число of cells traversed в_ найди first occurrence
                of a cell with element() element, or -1 if not present
                        
        ***********************************************************************/

        final цел индекс (V element)
        {
                цел i;
                for (auto p = this; p; p = p.следщ, ++i)
                     if (element == p.значение)
                         return i;

                return -1;
        }

        /***********************************************************************

                Count the число of occurrences of element in список
                        
        ***********************************************************************/

        final цел счёт (V element)
        {
                цел c;
                for (auto p = this; p; p = p.следщ)
                     if (element == p.значение)
                         ++c;
                return c;
        }

        /***********************************************************************

                 Return the число of cells in the список
                        
        ***********************************************************************/

        final цел счёт ()
        {
                цел c;
                for (auto p = this; p; p = p.следщ)
                     ++c;
                return c;
        }

        /***********************************************************************

                Return the cell representing the последний element of the список
                (i.e., the one whose следщ() is пусто
                        
        ***********************************************************************/

        final Ref хвост ()
        {
                auto p = this;
                while (p.следщ)
                       p = p.следщ;
                return p;
        }

        /***********************************************************************

                Return the nth cell of the список, or пусто if no such
                        
        ***********************************************************************/

        final Ref nth (цел n)
        {
                auto p = this;
                for (цел i; i < n; ++i)
                     p = p.следщ;
                return p;
        }

        /***********************************************************************

                Make a копируй of the список; i.e., a new список containing new cells
                but включая the same elements in the same order
                        
        ***********************************************************************/

        final Ref копируй (Ref delegate() alloc)
        {
                auto newlist = dup (alloc);
                auto current = newlist;

                for (auto p = следщ; p; p = p.следщ)
                    {
                    current.следщ = p.dup (alloc);
                    current = current.следщ;
                    }
                current.следщ = пусто;
                return newlist;
        }

        /***********************************************************************

                dup is shallow; i.e., just makes a копируй of the current cell
                        
        ***********************************************************************/

        private Ref dup (Ref delegate() alloc)
        {
                auto ret = alloc();
                static if (is(typeof(K) == KeyDummy))
                           ret.установи (значение, следщ);
                       else
                          ret.установи (ключ, значение, следщ);
                return ret;
        }

        /***********************************************************************

                Basic linkedlist merge algorithm.
                Merges the lists голова by fst and snd with respect в_ cmp
         
                param: fst голова of the first список
                param: snd голова of the сукунда список
                param: cmp a Comparator used в_ compare elements
                Возвращает: the merged ordered список
                        
        ***********************************************************************/

        static Ref merge (Ref fst, Ref snd, Comparator cmp)
        {
                auto a = fst;
                auto b = snd;
                Ref hd = пусто;
                Ref current = пусто;

                for (;;)
                    {
                    if (a is пусто)
                       {
                       if (hd is пусто)
                           hd = b;
                       else
                          current.следщ = b;
                       return hd;
                       }
                    else
                       if (b is пусто)
                          {
                          if (hd is пусто)
                              hd = a;
                          else
                             current.следщ = a;
                          return hd;
                          }

                    цел diff = cmp (a.значение, b.значение);
                    if (diff <= 0)
                       {
                       if (hd is пусто)
                           hd = a;
                       else
                          current.следщ = a;
                       current = a;
                       a = a.следщ;
                       }
                    else
                       {
                       if (hd is пусто)
                           hd = b;
                       else
                          current.следщ = b;
                       current = b;
                       b = b.следщ;
                       }
                    }
        }

        /***********************************************************************

                Standard список splitter, used by сортируй.
                Splits the список in half. Returns the голова of the сукунда half

                param: s the голова of the список
                Возвращает: the голова of the сукунда half

        ***********************************************************************/

        static Ref разбей (Ref s)
        {
                auto fast = s;
                auto slow = s;

                if (fast is пусто || fast.следщ is пусто)
                    return пусто;

                while (fast)
                      {
                      fast = fast.следщ;
                      if (fast && fast.следщ)
                         {
                         fast = fast.следщ;
                         slow = slow.следщ;
                         }
                      }

                auto r = slow.следщ;
                slow.следщ = пусто;
                return r;

        }

        /***********************************************************************

                 Standard merge сортируй algorithm
                 
                 param: s the список в_ сортируй
                 param: cmp, the comparator в_ use for ordering
                 Возвращает: the голова of the sorted список
                        
        ***********************************************************************/

        static Ref сортируй (Ref s, Comparator cmp)
        {
                if (s is пусто || s.следщ is пусто)
                    return s;
                else
                   {
                   auto right = разбей (s);
                   auto left = s;
                   left = сортируй (left, cmp);
                   right = сортируй (right, cmp);
                   return merge (left, right, cmp);
                   }
        }

}

