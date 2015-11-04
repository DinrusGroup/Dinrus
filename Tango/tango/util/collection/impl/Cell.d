/*
Файл: Cell.d

Originally записано by Doug Lea and released преобр_в the public домен. 
Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
Inc, Loral, and everyone contributing, testing, and using this код.

History:
Date     Who                What
24Sep95  dl@cs.oswego.edu   Create из_ util.collection.d  working файл
9Apr97   dl                 made Serializable

*/


module util.collection.impl.Cell;

/**
 *
 *
 * Cell is the основа of a bunch of implementation classes
 * for lists and the like.
 * The основа version just holds an Объект as its element значение
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public class Cell (T)
{
        // экземпляр variables
        private T element_;

        /**
         * Make a cell with element значение v
        **/

        public this (T v)
        {
                element_ = v;
        }

        /**
         * Make A cell with пусто element значение
        **/

        public this ()
        {
//                element_ = пусто;
        }

        /**
         * return the element значение
        **/

        public final T element()
        {
                return element_;
        }

        /**
         * установи the element значение
        **/

        public final проц element (T v)
        {
                element_ = v;
        }

        public final цел elementHash ()
        {
                return typeid(T).дайХэш(&element_);
        }

        protected Cell duplicate()
        {
                return new Cell (element_);
        }
}
