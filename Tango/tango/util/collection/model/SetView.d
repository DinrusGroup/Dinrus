/*
 Файл: SetView.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ collections.d  working файл

*/


module util.collection.model.SetView;

private import util.collection.model.View;

/**
 * Sets provопрe an include operations for добавьing
 * an element only if it is not already present.
 * They also добавь a guarantee:
 * With sets,
 * you can be sure that the число of occurrences of any
 * element is either zero or one.
 *
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

public interface SetView(T) : View!(T)
{
        public override SetView!(T) duplicate ();
        public alias duplicate dup;
version (VERBOSE)
{
        /**
         * Construct a new Collection that is a clone of сам except
         * that it есть indicated element. This can be used
         * в_ создай a series of collections, each differing из_ the
         * другой only in that they contain добавьitional elements.
         *
         * @param element the element в_ include in the new collection
         * Возвращает: a new collection c, with the matches as this, except that
         * c.есть(element)
         * Throws: IllegalElementException if !canInclude(element)
        **/

        public Набор включая (T element);
        public alias включая opCat;
} // version
}

