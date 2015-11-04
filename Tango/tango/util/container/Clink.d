/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Apr 2008: Initial release

        authors:        Kris

        Since:          0.99.7

        Based upon Doug Lea's Java collection package

*******************************************************************************/

module util.container.Clink;

/*******************************************************************************

        Clinks are линки that are always arranged in circular lists.

*******************************************************************************/

struct Clink (V)
{
        alias Clink!(V)    Тип;
        alias Тип         *Ref;

        Ref     prev,           // pointer в_ prev
                следщ;           // pointer в_ следщ
        V       значение;          // element значение

        /***********************************************************************

                 Набор в_ point в_ ourselves
                        
        ***********************************************************************/

        Ref установи (V v)
        {
                return установи (v, this, this);
        }

        /***********************************************************************

                 Набор в_ point в_ n as следщ cell and p as the prior cell

                 param: n, the new следщ cell
                 param: p, the new prior cell
                        
        ***********************************************************************/

        Ref установи (V v, Ref p, Ref n)
        {
                значение = v;
                prev = p;
                следщ = n;
                return this;
        }

        /**
         * Return да if current cell is the only one on the список
        **/

        бул singleton()
        {
                return следщ is this;
        }

        проц linkNext (Ref p)
        {
                if (p)
                   {
                   следщ.prev = p;
                   p.следщ = следщ;
                   p.prev = this;
                   следщ = p;
                   }
        }

        /**
         * Make a cell holding v and link it immediately after current cell
        **/

        проц добавьNext (V v, Ref delegate() alloc)
        {
                auto p = alloc().установи (v, this, следщ);
                следщ.prev = p;
                следщ = p;
        }

        /**
         * сделай a node holding v, link it before the current cell, and return it
        **/

        Ref добавьPrev (V v, Ref delegate() alloc)
        {
                auto p = prev;
                auto c = alloc().установи (v, p, this);
                p.следщ = c;
                prev = c;
                return c;
        }

        /**
         * link p before current cell
        **/

        проц linkPrev (Ref p)
        {
                if (p)
                   {
                   prev.следщ = p;
                   p.prev = prev;
                   p.следщ = this;
                   prev = p;
                   }
        }

        /**
         * return the число of cells in the список
        **/

        цел размер()
        {
                цел c = 0;
                auto p = this;
                do {
                   ++c;
                   p = p.следщ;
                   } while (p !is this);
                return c;
        }

        /**
         * return the first cell holding element найдено in a circular traversal starting
         * at current cell, or пусто if no such
        **/

        Ref найди (V element)
        {
                auto p = this;
                do {
                   if (element == p.значение)
                       return p;
                   p = p.следщ;
                   } while (p !is this);
                return пусто;
        }

        /**
         * return the число of cells holding element найдено in a circular
         * traversal
        **/

        цел счёт (V element)
        {
                цел c = 0;
                auto p = this;
                do {
                   if (element == p.значение)
                       ++c;
                   p = p.следщ;
                   } while (p !is this);
                return c;
        }

        /**
         * return the nth cell traversed из_ here. It may wrap around.
        **/

        Ref nth (цел n)
        {
                auto p = this;
                for (цел i = 0; i < n; ++i)
                     p = p.следщ;
                return p;
        }


        /**
         * Unlink the следщ cell.
         * This есть no effect on the список if isSingleton()
        **/

        проц unlinkNext ()
        {
                auto nn = следщ.следщ;
                nn.prev = this;
                следщ = nn;
        }

        /**
         * Unlink the previous cell.
         * This есть no effect on the список if isSingleton()
        **/

        проц unlinkPrev ()
        {
                auto pp = prev.prev;
                pp.следщ = this;
                prev = pp;
        }


        /**
         * Unlink сам из_ список it is in.
         * Causes it в_ be a singleton
        **/

        проц unlink ()
        {
                auto p = prev;
                auto n = следщ;
                p.следщ = n;
                n.prev = p;
                prev = this;
                следщ = this;
        }

        /**
         * Make a копируй of the список and return new голова. 
        **/

        Ref copyList (Ref delegate() alloc)
        {
                auto hd = this;

                auto newlist = alloc().установи (hd.значение, пусто, пусто);
                auto current = newlist;

                for (auto p = следщ; p !is hd; p = p.следщ)
                     {
                     current.следщ = alloc().установи (p.значение, current, пусто);
                     current = current.следщ;
                     }
                newlist.prev = current;
                current.следщ = newlist;
                return newlist;
        }
}


