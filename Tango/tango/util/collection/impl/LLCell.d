/*
 Файл: LLCell.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ util.collection.d  working файл

*/


module util.collection.impl.LLCell;

private import util.collection.impl.Cell;

private import util.collection.model.Comparator;

/**
 *
 *
 * LLCells extend Cells with стандарт linkedlist следщ-fields,
 * and provопрe a стандарт operations on them.
 * <P>
 * LLCells are pure implementation tools. They perform
 * no аргумент checking, no результат screening, and no synchronization.
 * They rely on пользователь-уровень classes (see for example LinkedList) в_ do such things.
 * Still, the class is made `public' so that you can use them в_
 * build другой kinds of collections or whatever, not just the ones
 * currently supported.
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public class LLCell(T) : Cell!(T)
{
        alias Comparator!(T) ComparatorT;


        protected LLCell next_;

        /**
         * Return the следщ cell (or пусто if Неук)
        **/

        public LLCell следщ()
        {
                return next_;
        }

        /**
         * установи в_ point в_ n as следщ cell
         * @param n, the new следщ cell
        **/

        public проц следщ(LLCell n)
        {
                next_ = n;
        }

        public this (T v, LLCell n)
        {
                super(v);
                next_ = n;
        }

        public this (T v)
        {
                this(v, пусто);
        }

        public this ()
        {
                this(T.init, пусто);
        }


        /**
         * Splice in p between current cell and whatever it was previously 
         * pointing в_
         * @param p, the cell в_ splice
        **/

        public final проц linkNext(LLCell p)
        {
                if (p !is пусто)
                    p.next_ = next_;
                next_ = p;
        }

        /**
         * Cause current cell в_ пропусти over the current следщ() one, 
         * effectively removing the следщ element из_ the список
        **/

        public final проц unlinkNext()
        {
                if (next_ !is пусто)
                    next_ = next_.next_;
        }

        /**
         * Linear search down the список looking for element (using T.равно)
         * @param element в_ look for
         * Возвращает: the cell containing element, or пусто if no such
        **/

        public final LLCell найди(T element)
        {
                for (LLCell p = this; p !is пусто; p = p.next_)
                     if (p.element() == element)
                         return p;
                return пусто;
        }

        /**
         * return the число of cells traversed в_ найди first occurrence
         * of a cell with element() element, or -1 if not present
        **/

        public final цел индекс(T element)
        {
                цел i = 0;
                for (LLCell p = this; p !is пусто; p = p.next_)
                    {
                    if (p.element() == element)
                        return i;
                    else
                       ++i;
                    }
                return -1;
        }

        /**
         * Count the число of occurrences of element in список
        **/

        public final цел счёт(T element)
        {
                цел c = 0;
                for (LLCell p = this; p !is пусто; p = p.next_)
                     if (p.element() == element)
                         ++c;
                return c;
        }

        /**
         * return the число of cells in the список
        **/

        public final цел _length()
        {
                цел c = 0;
                for (LLCell p = this; p !is пусто; p = p.next_)
                     ++c;
                return c;
        }

        /**
         * return the cell representing the последний element of the список
         * (i.e., the one whose следщ() is пусто
        **/

        public final LLCell хвост()
        {
                LLCell p = this;
                for ( ; p.next_ !is пусто; p = p.next_)
                    {}
                return p;
        }

        /**
         * return the nth cell of the список, or пусто if no such
        **/

        public final LLCell nth(цел n)
        {
                LLCell p = this;
                for (цел i = 0; i < n; ++i)
                     p = p.next_;
                return p;
        }


        /**
         * сделай a копируй of the список; i.e., a new список containing new cells
         * but включая the same elements in the same order
        **/

        public final LLCell copyList()
        {
                LLCell newlist = пусто;
                newlist = duplicate();
                LLCell current = newlist;

                for (LLCell p = next_; p !is пусто; p = p.next_)
                    {
                    current.next_ = p.duplicate();
                    current = current.next_;
                    }
                current.next_ = пусто;
                return newlist;
        }

        /**
         * Clone is SHALLOW; i.e., just makes a копируй of the current cell
        **/

        private final LLCell duplicate()
        {
                return new LLCell(element(), next_);
        }

        /**
         * Basic linkedlist merge algorithm.
         * Merges the lists голова by fst and snd with respect в_ cmp
         * @param fst голова of the first список
         * @param snd голова of the сукунда список
         * @param cmp a Comparator used в_ compare elements
         * Возвращает: the merged ordered список
        **/

        public final static LLCell merge(LLCell fst, LLCell snd, ComparatorT cmp)
        {
                LLCell a = fst;
                LLCell b = snd;
                LLCell hd = пусто;
                LLCell current = пусто;
                for (;;)
                    {
                    if (a is пусто)
                       {
                       if (hd is пусто)
                           hd = b;
                       else
                          current.следщ(b);
                       return hd;
                       }
                    else
                       if (b is пусто)
                          {
                          if (hd is пусто)
                              hd = a;
                          else
                             current.следщ(a);
                          return hd;
                          }

                    цел diff = cmp (a.element(), b.element());
                    if (diff <= 0)
                       {
                       if (hd is пусто)
                           hd = a;
                       else
                          current.следщ(a);
                       current = a;
                       a = a.следщ();
                       }
                    else
                       {
                       if (hd is пусто)
                           hd = b;
                       else
                          current.следщ(b);
                       current = b;
                       b = b.следщ();
                       }
                    }
                return пусто;
        }

        /**
         * Standard список splitter, used by сортируй.
         * Splits the список in half. Returns the голова of the сукунда half
         * @param s the голова of the список
         * Возвращает: the голова of the сукунда half
        **/

        public final static LLCell разбей(LLCell s)
        {
                LLCell fast = s;
                LLCell slow = s;

                if (fast is пусто || fast.следщ() is пусто)
                    return пусто;

                while (fast !is пусто)
                      {
                      fast = fast.следщ();
                      if (fast !is пусто && fast.следщ() !is пусто)
                         {
                         fast = fast.следщ();
                         slow = slow.следщ();
                         }
                      }

                LLCell r = slow.следщ();
                slow.следщ(пусто);
                return r;

        }

        /**
         * Standard merge сортируй algorithm
         * @param s the список в_ сортируй
         * @param cmp, the comparator в_ use for ordering
         * Возвращает: the голова of the sorted список
        **/

        public final static LLCell mergeSort(LLCell s, ComparatorT cmp)
        {
                if (s is пусто || s.следщ() is пусто)
                    return s;
                else
                   {
                   LLCell right = разбей(s);
                   LLCell left = s;
                   left = mergeSort(left, cmp);
                   right = mergeSort(right, cmp);
                   return merge(left, right, cmp);
                   }
        }

}

