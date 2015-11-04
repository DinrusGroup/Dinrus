/*
 Файл: Map.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ collections.d  working файл

*/


module util.collection.model.Map;

private import  util.collection.model.MapView,
                util.collection.model.Dispenser;


/**
 *
 *
 * MutableMap supports стандарт обнови operations on maps.
 *
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/


public interface Map(K, T) : MapView!(K, T), Dispenser!(T)
{
        public override Map!(K,T) duplicate();
        public alias duplicate dup;
        /**
         * Include the indicated pair in the Map
         * If a different pair
         * with the same ключ was previously held, it is replaced by the
         * new pair.
         *
         * @param ключ the ключ for element в_ include
         * @param element the element в_ include
         * Возвращает: condition: 
         * <PRE>
         * есть(ключ, element) &&
         * no spurious effects &&
         * Версия change iff !PREV(this).содержит(ключ, element))
         * </PRE>
        **/

        public проц добавь (K ключ, T element);

        /**
         * Include the indicated pair in the Map
         * If a different pair
         * with the same ключ was previously held, it is replaced by the
         * new pair.
         *
         * @param element the element в_ include
         * @param ключ the ключ for element в_ include
         * Возвращает: condition: 
         * <PRE>
         * есть(ключ, element) &&
         * no spurious effects &&
         * Версия change iff !PREV(this).содержит(ключ, element))
         * </PRE>
        **/

        public проц opIndexAssign (T element, K ключ);


        /**
         * Удали the pair with the given ключ
         * @param  ключ the ключ
         * Возвращает: condition: 
         * <PRE>
         * !containsKey(ключ)
         * foreach (k in ключи()) at(k).равно(PREV(this).at(k)) &&
         * foreach (k in PREV(this).ключи()) (!k.равно(ключ)) --> at(k).равно(PREV(this).at(k)) 
         * (version() != PREV(this).version()) == 
         * containsKey(ключ) !=  PREV(this).containsKey(ключ))
         * </PRE>
        **/

        public проц removeKey (K ключ);


        /**
         * Замени old pair with new pair with same ключ.
         * No effect if pair not held. (This есть the case of
         * having no effect if the ключ есть_ли but is bound в_ a different значение.)
         * @param ключ the ключ for the pair в_ удали
         * @param oldElement the existing element
         * @param newElement the значение в_ замени it with
         * Возвращает: condition: 
         * <PRE>
         * !содержит(ключ, oldElement) || содержит(ключ, newElement);
         * no spurious effects &&
         * Версия change iff PREV(this).содержит(ключ, oldElement))
         * </PRE>
        **/

        public проц replacePair (K ключ, T oldElement, T newElement);
}

