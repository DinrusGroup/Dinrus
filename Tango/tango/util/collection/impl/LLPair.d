/*
 Файл: LLPair.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ util.collection.d  working файл

*/


module util.collection.impl.LLPair;

private import util.collection.impl.LLCell;

private import util.collection.model.Iterator;


/**
 *
 *
 * LLPairs are LLCells with ключи, and operations that deal with them.
 * As with LLCells, the are pure implementation tools.
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public class LLPair(K, T) : LLCell!(T) 
{
        alias LLCell!(T).найди найди;
        alias LLCell!(T).счёт счёт;
        alias LLCell!(T).element element;


        // экземпляр variables

        private K key_;

        /**
         * Make a cell with given ключ, elment, and следщ link
        **/

        public this (K k, T v, LLPair n)
        {
                super(v, n);
                key_ = k;
        }

        /**
         * Make a pair with given ключ and element, and пусто следщ link
        **/

        public this (K k, T v)
        {
                super(v, пусто);
                key_ = k;
        }

        /**
         * Make a pair with пусто ключ, elment, and следщ link
        **/

        public this ()
        {
                super(T.init, пусто);
                key_ = K.init;
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
         * установи the ключ
        **/

        public final цел keyHash()
        {
                return typeid(K).дайХэш(&key_);
        }


        /**
         * return a cell with ключ() ключ or пусто if no such
        **/

        public final LLPair findKey(K ключ)
        {
                for (auto p=this; p; p = cast(LLPair)cast(проц*) p.next_)
                     if (p.ключ() == ключ)
                         return p;
                return пусто;
        }

        /**
         * return a cell holding the indicated pair or пусто if no such
        **/

        public final LLPair найди(K ключ, T element)
        {
                for (auto p=this; p; p = cast(LLPair)cast(проц*) p.next_)
                     if (p.ключ() == ключ && p.element() == element)
                         return p;
                return пусто;
        }

        /**
         * Return the число of cells traversed в_ найди a cell with ключ() ключ,
         * or -1 if not present
        **/

        public final цел индексируйКлюч(K ключ)
        {
                цел i = 0;
                for (auto p=this; p; p = cast(LLPair)cast(проц*) p.next_)
                    {
                    if (p.ключ() == ключ)
                        return i;
                    else
                       ++i;
                    }
                return -1;
        }

        /**
         * Return the число of cells traversed в_ найди a cell with indicated pair
         * or -1 if not present
        **/
        public final цел индекс(K ключ, T element)
        {
                цел i = 0;
                for (auto p=this; p; p = cast(LLPair)cast(проц*) p.next_)
                    {
                    if (p.ключ() == ключ && p.element() == element)
                        return i;
                    else
                       ++i;
                    }
                return -1;
        }

        /**
         * Return the число of cells with ключ() ключ.
        **/
        public final цел учтиКлюч(K ключ)
        {
                цел c = 0;
                for (auto p=this; p; p = cast(LLPair)cast(проц*) p.next_)
                     if (p.ключ() == ключ)
                         ++c;
                return c;
        }

        /**
         * Return the число of cells with indicated pair
        **/
        public final цел счёт(K ключ, T element)
        {
                цел c = 0;
                for (auto p=this; p; p = cast(LLPair)cast(проц*) p.next_)
                     if (p.ключ() == ключ && p.element() == element)
                         ++c;
                return c;
        }

        protected final LLPair duplicate()
        {
                return new LLPair(ключ(), element(), cast(LLPair)cast(проц*)(следщ()));
        }
}
