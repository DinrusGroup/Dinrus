/*
 Файл: BagView.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ collections.d  working файл

*/


module util.collection.model.BagView;

private import util.collection.model.View;


/**
 *
 * Bags are collections supporting multИПle occurrences of elements.
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

public interface BagView(V) : View!(V)
{
        public override BagView!(V) duplicate();
        public alias duplicate dup;

version (VERBOSE)
{
        public alias добавьing opCat;

        /**
         * Construct a new Bag that is a clone of сам except
         * that it включает indicated element. This can be used
         * в_ создай a series of Bag, each differing из_ the
         * другой only in that they contain добавьitional elements.
         *
         * @param the element в_ добавь в_ the new Bag
         * Возвращает: the new Bag c, with the matches as this except that
         * c.occurrencesOf(element) == occurrencesOf(element)+1 
         * Throws: IllegalElementException if !canInclude(element)
        **/

        public Bag добавьing(V element);

        /**
         * Construct a new Collection that is a clone of сам except
         * that it добавьs the indicated element if not already present. This can be used
         * в_ создай a series of collections, each differing из_ the
         * другой only in that they contain добавьitional elements.
         *
         * @param element the element в_ include in the new collection
         * Возвращает: a new collection c, with the matches as this, except that
         * c.occurrencesOf(element) = min(1, occurrencesOfElement)
         * Throws: IllegalElementException if !canInclude(element)
        **/

        public Bag добавьingIfAbsent(V element);
} // version

}
