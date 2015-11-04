/*
 Файл: SortedValues.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ collections.d  working файл
 13Oct95  dl                 Changed protection statuses

*/


module util.collection.model.SortedValues;

private import  util.collection.model.View,
                util.collection.model.Comparator;


/**
 *
 *
 * ElementSorted is a mixin interface for Collections that
 * are always in sorted order with respect в_ a Comparator
 * held by the Collection.
 * <P>
 * ElementSorted Collections guarantee that enumerations
 * appear in sorted order;  that is if a and b are two Elements
 * obtained in succession из_ elements().nextElement(), that 
 * <PRE>
 * comparator(a, b) <= 0.
 * </PRE>
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public interface SortedValues(T) : View!(T)
{

        /**
         * Report the Comparator used for ordering
        **/

        public Comparator!(T) comparator();
}

