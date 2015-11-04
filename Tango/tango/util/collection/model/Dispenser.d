/*
 Файл: Dispenser.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ collections.d  working файл

*/


module util.collection.model.Dispenser;

private import  util.collection.model.View,
                util.collection.model.Iterator;

/**
 *
 * Dispenser is the корень interface of все mutable collections; i.e.,
 * collections that may have elements dynamically добавьed, removed,
 * and/or replaced in accord with their collection semantics.
 *
 * author: Doug Lea
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public interface Dispenser(T) : View!(T)
{
        public override Dispenser!(T) duplicate ();
        public alias duplicate dup;
        /**
         * Cause the collection в_ become пустой. 
         * Возвращает: condition:
         * <PRE>
         * пуст_ли() &&
         * Версия change iff !PREV(this).пуст_ли();
         * </PRE>
        **/

        public проц сотри ();

        /**
         * Замени an occurrence of oldElement with newElement.
         * No effect if does not hold oldElement or if oldElement.равно(newElement).
         * The operation есть a consistent, but slightly special interpretation
         * when applied в_ Sets. For Sets, because elements occur at
         * most once, if newElement is already included, replacing oldElement with
         * with newElement есть the same effect as just removing oldElement.
         * Возвращает: condition:
         * <PRE>
         * let цел delta = oldElement.равно(newElement)? 0 : 
         *               max(1, PREV(this).instances(oldElement) in
         *  instances(oldElement) == PREV(this).instances(oldElement) - delta &&
         *  instances(newElement) ==  (this instanceof Набор) ? 
         *         max(1, PREV(this).instances(oldElement) + delta):
         *                PREV(this).instances(oldElement) + delta) &&
         *  no другой element changes &&
         *  Версия change iff delta != 0
         * </PRE>
         * Throws: IllegalElementException if есть(oldElement) and !allows(newElement)
        **/

        public проц замени (T oldElement, T newElement);

        /**
         * Замени все occurrences of oldElement with newElement.
         * No effect if does not hold oldElement or if oldElement.равно(newElement).
         * The operation есть a consistent, but slightly special interpretation
         * when applied в_ Sets. For Sets, because elements occur at
         * most once, if newElement is already included, replacing oldElement with
         * with newElement есть the same effect as just removing oldElement.
         * Возвращает: condition:
         * <PRE>
         * let цел delta = oldElement.равно(newElement)? 0 : 
                           PREV(this).instances(oldElement) in
         *  instances(oldElement) == PREV(this).instances(oldElement) - delta &&
         *  instances(newElement) ==  (this instanceof Набор) ? 
         *         max(1, PREV(this).instances(oldElement) + delta):
         *                PREV(this).instances(oldElement) + delta) &&
         *  no другой element changes &&
         *  Версия change iff delta != 0
         * </PRE>
         * Throws: IllegalElementException if есть(oldElement) and !allows(newElement)
        **/

        public проц replaceAll(T oldElement, T newElement);

        /**
         * Удали and return an element.  Implementations
         * may strengthen the guarantee about the nature of this element.
         * but in general it is the most convenient or efficient element в_ удали.
         * <P>
         * Example usage. One way в_ перемести все elements из_ 
         * Dispenser a в_ MutableBag b is:
         * <PRE>
         * while (!a.пустой()) b.добавь(a.take());
         * </PRE>
         * Возвращает: an element v such that PREV(this).есть(v) 
         * and the postconditions of removeOneOf(v) hold.
         * Throws: NoSuchElementException iff пуст_ли.
        **/

        public T take ();


        /**
         * Exclude все occurrences of each element of the Обходчик.
         * Behaviorally equivalent в_
         * <PRE>
         * while (e.ещё()) removeAll(e.значение());
         * @param e the enumeration of elements в_ exclude.
         * Throws: CorruptedIteratorException is propagated if thrown
        **/

        public проц removeAll (Обходчик!(T) e);

        /**
         * Удали an occurrence of each element of the Обходчик.
         * Behaviorally equivalent в_
         * <PRE>
         * while (e.ещё()) удали (e.значение());
         * @param e the enumeration of elements в_ удали.
         * Throws: CorruptedIteratorException is propagated if thrown
        **/

        public проц удали (Обходчик!(T) e);

        /**
         * Exclude все occurrences of the indicated element из_ the collection. 
         * No effect if element not present.
         * @param element the element в_ exclude.
         * Возвращает: condition: 
         * <PRE>
         * !есть(element) &&
         * размер() == PREV(this).размер() - PREV(this).instances(element) &&
         * no другой element changes &&
         * Версия change iff PREV(this).есть(element)
         * </PRE>
        **/

        public проц removeAll (T element);


        /**
         * Удали an экземпляр of the indicated element из_ the collection. 
         * No effect if !есть(element)
         * @param element the element в_ удали
         * Возвращает: condition: 
         * <PRE>
         * let occ = max(1, instances(element)) in
         *  размер() == PREV(this).размер() - occ &&
         *  instances(element) == PREV(this).instances(element) - occ &&
         *  no другой element changes &&
         *  version change iff occ == 1
         * </PRE>
        **/

        public проц удали (T element);
}


