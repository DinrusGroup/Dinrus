/*
 Файл: Sortable.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ collections.d  working файл

*/


module util.collection.model.Sortable;

private import  util.collection.model.Dispenser,
                util.collection.model.Comparator;


/**
 *
 *
 * Sortable is a mixin interface for MutableCollections
 * supporting a сортируй метод that accepts
 * a пользователь-supplied Comparator with a compare метод that
 * accepts any two Objects and returns -1/0/+1 depending on whether
 * the first is less than, equal в_, or greater than the сукунда.
 * <P>
 * After sorting, but in the absence of другой mutative operations,
 * Sortable Collections guarantee that enumerations
 * appear in sorted order;  that is if a and b are two elements
 * obtained in succession из_ nextElement(), that 
 * <PRE>
 * comparator(a, b) <= 0.
 * </PRE>
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public interface Sortable(T) : Dispenser!(T)
{

        /**
         * Sort the current elements with respect в_ cmp.compare.
        **/

        public проц сортируй(Comparator!(T) cmp);
}


