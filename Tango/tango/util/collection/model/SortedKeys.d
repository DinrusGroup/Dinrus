/*
 Файл: SortedKeys.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ collections.d  working файл

*/


module util.collection.model.SortedKeys;

private import  util.collection.model.View,
                util.collection.model.Comparator;


/**
 *
 *
 * KeySorted is a mixin interface for Collections that
 * are always in sorted order with respect в_ a Comparator
 * held by the Collection.
 * <P>
 * KeySorted Collections guarantee that enumerations
 * appear in sorted order;  that is if a and b are two Keys
 * obtained in succession из_ ключи().nextElement(), that 
 * <PRE>
 * comparator(a, b) <= 0.
 * </PRE>
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public interface SortedKeys(K, V) : View!(V)
{

        /**
         * Report the Comparator used for ordering
        **/

        public Comparator!(K) comparator();
}
