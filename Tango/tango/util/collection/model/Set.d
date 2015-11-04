/*
 Файл: Набор.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ collections.d  working файл
 22Oct95  dl                 добавь добавьElements

*/


module util.collection.model.Set;

private import  util.collection.model.SetView,
                util.collection.model.Iterator,
                util.collection.model.Dispenser;


/**
 *
 * MutableSets support an include operations в_ добавь
 * an element only if it not present. 
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

public interface Набор(T) : SetView!(T), Dispenser!(T)
{
        public override Набор!(T) duplicate();
        public alias duplicate dup;

        /**
         * Include the indicated element in the collection.
         * No effect if the element is already present.
         * @param element the element в_ добавь
         * Возвращает: condition: 
         * <PRE>
         * есть(element) &&
         * no spurious effects &&
         * Версия change iff !PREV(this).есть(element)
         * </PRE>
         * Throws: IllegalElementException if !canInclude(element)
        **/

        public проц добавь (T element);


        /**
         * Include все elements of the enumeration in the collection.
         * Behaviorally equivalent в_
         * <PRE>
         * while (e.ещё()) include(e.получи());
         * </PRE>
         * @param e the elements в_ include
         * Throws: IllegalElementException if !canInclude(element)
         * Throws: CorruptedIteratorException propagated if thrown
        **/

        public проц добавь (Обходчик!(T) e);
        public alias добавь opCatAssign;
}

