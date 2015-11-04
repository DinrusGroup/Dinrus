/*
 Файл: MapView.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ collections.d  working файл

*/


module util.collection.model.MapView;

private import  util.collection.model.View,
                util.collection.model.GuardIterator;


/**
 *
 * Maps maintain keyed elements. Any kind of Объект 
 * may serve as a ключ for an element.
 *
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/


public interface MapView(K, V) : View!(V)
{
        public override MapView!(K,V) duplicate();
        public alias duplicate dup;
        /**
         * Report whether the MapT COULD include k as a ключ
         * Always returns нет if k is пусто
        **/

        public бул allowsKey(K ключ);

        /**
         * Report whether there есть_ли any element with Key ключ.
         * Возвращает: да if there is such an element
        **/

        public бул containsKey(K ключ);

        /**
         * Report whether there есть_ли a (ключ, значение) pair
         * Возвращает: да if there is such an element
        **/

        public бул containsPair(K ключ, V значение);


        /**
         * Return an enumeration that may be used в_ traverse through
         * the ключи (not elements) of the collection. The corresponding
         * elements can be looked at by using at(k) for each ключ k. For example:
         * <PRE>
         * Обходчик ключи = amap.ключи();
         * while (ключи.ещё()) {
         *   K ключ = ключи.получи();
         *   T значение = amap.получи(ключ)
         * // ...
         * }
         * </PRE>
         * Возвращает: the enumeration
        **/

        public PairIterator!(K, V) ключи();

        /**
         traverse the collection контент. This is cheaper than using an
         iterator since there is no creation cost involved.
        **/

        цел opApply (цел delegate (inout K ключ, inout V значение) дг);
        
        /**
         * Return the element associated with Key ключ. 
         * @param ключ a ключ
         * Возвращает: element such that содержит(ключ, element)
         * Throws: NoSuchElementException if !containsKey(ключ)
        **/

        public V получи(K ключ);
        public alias получи opIndex;

        /**
         * Return the element associated with Key ключ. 
         * @param ключ a ключ
         * Возвращает: whether the ключ is contained or not
        **/

        public бул получи(K ключ, inout V element); 


        /**
         * Return a ключ associated with element. There may be any
         * число of ключи associated with any element, but this returns only
         * one of them (any arbitrary one), or нет if no such ключ есть_ли.
         * @param ключ, a place в_ return a located ключ
         * @param element, a значение в_ try в_ найди a ключ for.
         * Возвращает: да where значение is найдено; нет otherwise
        **/

        public бул keyOf(inout K ключ, V значение);
}

