/*
 Файл: CLCell.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ util.collection.d  working файл
 13Oct95  dl                 Changed protection statuses

*/


module util.collection.impl.CLCell;

private import util.collection.impl.Cell;


/**
 *
 *
 * CLCells are cells that are always arranged in circular lists
 * They are pure implementation tools
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public class CLCell(T) : Cell!(T)
{
        // экземпляр variables

        private CLCell next_;
        private CLCell prev_;

        // constructors

        /**
         * Make a cell with contents v, previous cell p, следщ cell n
        **/

        public this (T v, CLCell p, CLCell n)
        {
                super(v);
                prev_ = p;
                next_ = n;
        }

        /**
         * Make a singular cell
        **/

        public this (T v)
        {
                super(v);
                prev_ = this;
                next_ = this;
        }

        /**
         * Make a singular cell with пусто contents
        **/

        public this ()
        {
                super(T.init);
                prev_ = this;
                next_ = this;
        }

        /**
         * return следщ cell
        **/

        public final CLCell следщ()
        {
                return next_;
        }

        /**
         * Набор следщ cell. You probably don't want в_ вызов this
        **/

        public final проц следщ(CLCell n)
        {
                next_ = n;
        }


        /**
         * return previous cell
        **/
        public final CLCell prev()
        {
                return prev_;
        }

        /**
         * Набор previous cell. You probably don't want в_ вызов this
        **/
        public final проц prev(CLCell n)
        {
                prev_ = n;
        }


        /**
         * Return да if current cell is the only one on the список
        **/

        public final бул isSingleton()
        {
                return next_ is this;
        }

        public final проц linkNext(CLCell p)
        {
                if (p !is пусто)
                   {
                   next_.prev_ = p;
                   p.next_ = next_;
                   p.prev_ = this;
                   next_ = p;
                   }
        }

        /**
         * Make a cell holding v and link it immediately after current cell
        **/

        public final проц добавьNext(T v)
        {
                CLCell p = new CLCell(v, this, next_);
                next_.prev_ = p;
                next_ = p;
        }

        /**
         * сделай a node holding v, link it before the current cell, and return it
        **/

        public final CLCell добавьPrev(T v)
        {
                CLCell p = prev_;
                CLCell c = new CLCell(v, p, this);
                p.next_ = c;
                prev_ = c;
                return c;
        }

        /**
         * link p before current cell
        **/

        public final проц linkPrev(CLCell p)
        {
                if (p !is пусто)
                   {
                   prev_.next_ = p;
                   p.prev_ = prev_;
                   p.next_ = this;
                   prev_ = p;
                   }
        }

        /**
         * return the число of cells in the список
        **/

        public final цел _length()
        {
                цел c = 0;
                CLCell p = this;
                do {
                   ++c;
                   p = p.следщ();
                   } while (p !is this);
                return c;
        }

        /**
         * return the first cell holding element найдено in a circular traversal starting
         * at current cell, or пусто if no such
        **/

        public final CLCell найди(T element)
        {
                CLCell p = this;
                do {
                   if (p.element() == (element))
                       return p;
                   p = p.следщ();
                   } while (p !is this);
                return пусто;
        }

        /**
         * return the число of cells holding element найдено in a circular
         * traversal
        **/

        public final цел счёт(T element)
        {
                цел c = 0;
                CLCell p = this;
                do {
                   if (p.element() == (element))
                       ++c;
                   p = p.следщ();
                   } while (p !is this);
                return c;
        }

        /**
         * return the nth cell traversed из_ here. It may wrap around.
        **/

        public final CLCell nth(цел n)
        {
                CLCell p = this;
                for (цел i = 0; i < n; ++i)
                     p = p.next_;
                return p;
        }


        /**
         * Unlink the следщ cell.
         * This есть no effect on the список if isSingleton()
        **/

        public final проц unlinkNext()
        {
                CLCell nn = next_.next_;
                nn.prev_ = this;
                next_ = nn;
        }

        /**
         * Unlink the previous cell.
         * This есть no effect on the список if isSingleton()
        **/

        public final проц unlinkPrev()
        {
                CLCell pp = prev_.prev_;
                pp.next_ = this;
                prev_ = pp;
        }


        /**
         * Unlink сам из_ список it is in.
         * Causes it в_ be a singleton
        **/

        public final проц unlink()
        {
                CLCell p = prev_;
                CLCell n = next_;
                p.next_ = n;
                n.prev_ = p;
                prev_ = this;
                next_ = this;
        }

        /**
         * Make a копируй of the список and return new голова. 
        **/

        public final CLCell copyList()
        {
                CLCell hd = this;

                CLCell newlist = new CLCell(hd.element(), пусто, пусто);
                CLCell current = newlist;

                for (CLCell p = next_; p !is hd; p = p.next_)
                     {
                     current.next_ = new CLCell(p.element(), current, пусто);
                     current = current.next_;
                     }
                newlist.prev_ = current;
                current.next_ = newlist;
                return newlist;
        }
}

