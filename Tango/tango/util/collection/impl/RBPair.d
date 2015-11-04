/*
 Файл: RBPair.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ util.collection.d  working файл
 13Oct95  dl                 Changed protection statuses

*/


module util.collection.impl.RBPair;

private import util.collection.impl.RBCell;

private import util.collection.model.Comparator;


/**
 *
 * RBPairs are RBCells with ключи.
 *
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public class RBPair(K, T) : RBCell!(T) 
{
        alias RBCell!(T).element element;

        // экземпляр переменная

        private K key_;

        /**
         * Make a cell with given ключ and element values, and пусто линки
        **/

        public this (K k, T v)
        {
                super(v);
                key_ = k;
        }

        /**
         * Make a new node with same ключ and element values, but пусто линки
        **/

        protected final RBPair duplicate()
        {
                auto t = new RBPair(key_, element());
                t.color_ = color_;
                return t;
        }

        /**
         * return the ключ
        **/

        public final K ключ()
        {
                return key_;
        }


        /**
         * установи the ключ
        **/

        public final проц ключ(K k)
        {
                key_ = k;
        }

        /**
         * Implements RBCell.найди.
         * Overrопрe RBCell version since we are ordered on ключи, not elements, so
         * element найди есть в_ search whole дерево.
         * comparator аргумент not actually used.
         * See_Also: RBCell.найди
        **/

        public final override RBCell!(T) найди(T element, Comparator!(T) cmp)
        {
                RBCell!(T) t = this;

                while (t !is пусто)
                      {
                      if (t.element() == (element))
                          return t;
                      else
                        if (t.right_ is пусто)
                            t = t.left_;
                        else
                           if (t.left_ is пусто)
                               t = t.right_;
                           else
                              {
                              auto p = t.left_.найди(element, cmp);

                              if (p !is пусто)
                                  return p;
                              else
                                 t = t.right_;
                              }
                      }
                return пусто; // not reached
        }

        /**
         * Implements RBCell.счёт.
         * See_Also: RBCell.счёт
        **/
        public final override цел счёт(T element, Comparator!(T) cmp)
        {
                цел c = 0;
                RBCell!(T) t = this;

                while (t !is пусто)
                      {
                      if (t.element() == (element))
                          ++c;

                      if (t.right_ is пусто)
                          t = t.left_;
                      else
                         if (t.left_ is пусто)
                             t = t.right_;
                         else
                            {
                            c += t.left_.счёт(element, cmp);
                            t = t.right_;
                            }
                      }
                return c;
        }

        /**
         * найди and return a cell holding ключ, or пусто if no such
        **/

        public final RBPair findKey(K ключ, Comparator!(K) cmp)
        {
                auto t = this;

                for (;;)
                    {
                    цел diff = cmp(ключ, t.key_);
                    if (diff is 0)
                        return t;
                    else
                       if (diff < 0)
                           t = cast(RBPair)(t.left_);
                       else
                          t = cast(RBPair)(t.right_);

                    if (t is пусто)
                        break;
                    }
                return пусто;
        }

        /**
         * найди and return a cell holding (ключ, element), or пусто if no such
        **/
        public final RBPair найди(K ключ, T element, Comparator!(K) cmp)
        {
                auto t = this;

                for (;;)
                    {
                    цел diff = cmp(ключ, t.key_);
                    if (diff is 0 && t.element() == (element))
                        return t;
                    else
                       if (diff <= 0)
                           t = cast(RBPair)(t.left_);
                       else
                          t = cast(RBPair)(t.right_);

                    if (t is пусто)
                        break;
                    }
                return пусто;
        }

        /**
         * return число of nodes of subtree holding ключ
        **/
        public final цел учтиКлюч(K ключ, Comparator!(K) cmp)
        {
                цел c = 0;
                auto t = this;

                while (t !is пусто)
                      {
                      цел diff = cmp(ключ, t.key_);
                      // rely on вставь в_ always go left on <=
                      if (diff is 0)
                          ++c;

                      if (diff <= 0)
                          t = cast(RBPair)(t.left_);
                      else
                         t = cast(RBPair)(t.right_);
                      }
                return c;
        }

        /**
         * return число of nodes of subtree holding (ключ, element)
        **/
        public final цел счёт(K ключ, T element, Comparator!(K) cmp)
        {
                цел c = 0;
                auto t = this;
                
                while (t !is пусто)
                      {
                      цел diff = cmp(ключ, t.key_);
                      if (diff is 0)
                         {
                         if (t.element() == (element))
                             ++c;

                         if (t.left_ is пусто)
                             t = cast(RBPair)(t.right_);
                         else
                            if (t.right_ is пусто)
                                t = cast(RBPair)(t.left_);
                            else
                               {
                               c += (cast(RBPair)(t.right_)).счёт(ключ, element, cmp);
                               t = cast(RBPair)(t.left_);
                               }
                         }
                      else
                         if (diff < 0)
                             t = cast(RBPair)(t.left());
                         else
                            t = cast(RBPair)(t.right());
                      }
                return c;
        }
}

