/*
 Файл: Seq.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ collections.d  working файл

*/


module util.collection.model.Seq;

private import  util.collection.model.SeqView,
                util.collection.model.Iterator,
                util.collection.model.Dispenser;

/**
 *
 * Seqs are Seqs possessing стандарт modification methods
 *
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/


public interface Seq(T) : SeqView!(T), Dispenser!(T)
{
        public override Seq!(T) duplicate();
        public alias duplicate dup;
        /**
         * Insert все elements of enumeration e at a given индекс, preserving 
         * their order. The индекс can range из_
         * 0..размер() (i.e., one past the current последний индекс). If the индекс is
         * equal в_ размер(), the elements are appended.
         * 
         * @param индекс the индекс в_ старт добавьing at
         * @param e the elements в_ добавь
         * Возвращает: condition:
         * <PRE>
         * foreach (цел i in 0 .. индекс-1) at(i).равно(PREV(this)at(i)); &&
         * все existing elements at indices at or greater than индекс have their
         *  indices incremented by the число of elements 
         *  traversable via e.получи() &&
         * The new elements are at indices индекс + their order in
         *   the enumeration's получи traversal.
         * !(e.ещё()) &&
         * (version() != PREV(this).version()) == PREV(e).ещё() 
         * </PRE>
         * Throws: IllegalElementException if !canInclude some element of e;
         * this may or may not nullify the effect of insertions of другой elements.
         * Throws: NoSuchElementException if индекс is not in range 0..размер()
         * Throws: CorruptedIteratorException is propagated if raised; this
         * may or may not nullify the effects of insertions of другой elements.
        **/
        
        public проц добавьAt (цел индекс, Обходчик!(T) e);


        /**
         * Insert element at indicated индекс. The индекс can range из_
         * 0..размер() (i.e., one past the current последний индекс). If the индекс is
         * equal в_ размер(), the element is appended as the new последний element.
         * @param индекс the индекс в_ добавь at
         * @param element the element в_ добавь
         * Возвращает: condition:
         * <PRE>
         * размер() == PREV(this).размер()+1 &&
         * at(индекс).равно(element) &&
         * foreach (цел i in 0 .. индекс-1)      получи(i).равно(PREV(this).получи(i))
         * foreach (цел i in индекс+1..размер()-1) получи(i).равно(PREV(this).получи(i-1))
         * Версия change: always
         * </PRE>
         * Throws: NoSuchElementException if индекс is not in range 0..размер()
         * Throws: IllegalElementException if !canInclude(element)
        **/

        public проц добавьAt (цел индекс, T element);

        /**
         * замени element at indicated индекс with new значение
         * @param индекс the индекс at which в_ замени значение
         * @param element the new значение
         * Возвращает: condition:
         * <PRE>
         * размер() == PREV(this).размер() &&
         * at(индекс).равно(element) &&
         * no spurious effects
         * Версия change <-- !element.равно(PREV(this).получи(индекс)
         *                    (but MAY change even if equal).
         * </PRE>
         * Throws: NoSuchElementException if индекс is not in range 0..размер()-1
         * Throws: IllegalElementException if !canInclude(element)
        **/

        public проц replaceAt (цел индекс, T element);

        /**
         * замени element at indicated индекс with new значение
         * @param element the new значение
         * @param индекс the индекс at which в_ замени значение
         * Возвращает: condition:
         * <PRE>
         * размер() == PREV(this).размер() &&
         * at(индекс).равно(element) &&
         * no spurious effects
         * Версия change <-- !element.равно(PREV(this).получи(индекс)
         *                    (but MAY change even if equal).
         * </PRE>
         * Throws: NoSuchElementException if индекс is not in range 0..размер()-1
         * Throws: IllegalElementException if !canInclude(element)
        **/
        public проц opIndexAssign (T element, цел индекс);


        /**
         * Удали element at indicated индекс. все elements в_ the right
         * have their indices decremented by one.
         * @param индекс the индекс of the element в_ удали
         * Возвращает: condition:
         * <PRE>
         * размер() = PREV(this).размер()-1 &&
         * foreach (цел i in 0..индекс-1)      получи(i).равно(PREV(this).получи(i)); &&
         * foreach (цел i in индекс..размер()-1) получи(i).равно(PREV(this).получи(i+1));
         * Версия change: always
         * </PRE>
         * Throws: NoSuchElementException if индекс is not in range 0..размер()-1
        **/
        public проц removeAt (цел индекс);


        /**
         * Insert element at front of the sequence.
         * Behaviorally equivalent в_ вставь(0, element)
         * @param element the element в_ добавь
         * Throws: IllegalElementException if !canInclude(element)
        **/

        public проц приставь(T element);


        /**
         * замени element at front of the sequence with new значение.
         * Behaviorally equivalent в_ замени(0, element);
        **/
        public проц замениГолову(T element);

        /**
         * Удали the leftmost element. 
         * Behaviorally equivalent в_ удали(0);
        **/

        public проц removeHead();


        /**
         * вставь element at конец of the sequence
         * Behaviorally equivalent в_ вставь(размер(), element)
         * @param element the element в_ добавь
         * Throws: IllegalElementException if !canInclude(element)
        **/

        public проц добавь(T element);
        public alias добавь opCatAssign;

        /**
         * замени element at конец of the sequence with new значение
         * Behaviorally equivalent в_ замени(размер()-1, element);
        **/

        public проц замениХвост(T element);



        /**
         * Удали the rightmost element. 
         * Behaviorally equivalent в_ удали(размер()-1);
         * Throws: NoSuchElementException if пуст_ли
        **/
        public проц removeTail();


        /**
         * Удали the elements из_ fromIndex в_ toIndex, включительно.
         * No effect if fromIndex > toIndex.
         * Behaviorally equivalent в_
         * <PRE>
         * for (цел i = fromIndex; i &lt;= toIndex; ++i) удали(fromIndex);
         * </PRE>
         * @param индекс the индекс of the first element в_ удали
         * @param индекс the индекс of the последний element в_ удали
         * Возвращает: condition:
         * <PRE>
         * let n = max(0, toIndex - fromIndex + 1 in
         *  размер() == PREV(this).размер() - 1 &&
         *  for (цел i in 0 .. fromIndex - 1)     получи(i).равно(PREV(this).получи(i)) && 
         *  for (цел i in fromIndex .. размер()- 1) получи(i).равно(PREV(this).получи(i+n) 
         *  Версия change iff n > 0 
         * </PRE>
         * Throws: NoSuchElementException if fromIndex or toIndex is not in 
         * range 0..размер()-1
        **/

        public проц removeRange(цел fromIndex, цел toIndex);


        /**
         * Prepend все elements of enumeration e, preserving their order.
         * Behaviorally equivalent в_ добавьElementsAt(0, e)
         * @param e the elements в_ добавь
        **/

        public проц приставь(Обходчик!(T) e);


        /**
         * Append все elements of enumeration e, preserving their order.
         * Behaviorally equivalent в_ добавьElementsAt(размер(), e)
         * @param e the elements в_ добавь
        **/
        public проц добавь(Обходчик!(T) e);
}


