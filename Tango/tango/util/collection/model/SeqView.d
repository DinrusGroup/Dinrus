/*
 Файл: SeqView.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ collections.d  working файл

*/


module util.collection.model.SeqView;

private import util.collection.model.View;


/**
 * 
 *
 * Seqs are indexed, sequentially ordered collections.
 * Indices are always in the range 0 .. размер() -1. все accesses by индекс
 * are checked, raising exceptions if the индекс falls out of range.
 * <P>
 * The elements() enumeration for все seqs is guaranteed в_ be
 * traversed (via nextElement) in sequential order.
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public interface SeqView(T) : View!(T)
{
        public override SeqView!(T) duplicate();
        public alias duplicate dup;
        /**
         * Return the element at the indicated индекс
         * @param индекс 
         * Возвращает: the element at the индекс
         * Throws: NoSuchElementException if индекс is not in range 0..размер()-1
        **/

        public T получи(цел индекс);
        public alias получи opIndex;


        /**
         * Return the first element, if it есть_ли.
         * Behaviorally equivalent в_ at(0)
         * Throws: NoSuchElementException if пуст_ли
        **/

        public T голова();


        /**
         * Return the последний element, if it есть_ли.
         * Behaviorally equivalent в_ at(размер()-1)
         * Throws: NoSuchElementException if пуст_ли
        **/

        public T хвост();


        /**
         * Report the индекс of leftmost occurrence of an element из_ a 
         * given starting point, or -1 if there is no such индекс.
         * @param element the element в_ look for
         * @param startingIndex the индекс в_ старт looking из_. The startingIndex
         * need not be a valid индекс. If less than zero it is treated as 0.
         * If greater than or equal в_ размер(), the результат will always be -1.
         * Возвращает: индекс such that
         * <PRE> 
         * let цел si = max(0, startingIndex) in
         *  индекс == -1 &&
         *   foreach (цел i in si .. размер()-1) !at(индекс).равно(element)
         *  ||
         *  at(индекс).равно(element) &&
         *   foreach (цел i in si .. индекс-1) !at(индекс).равно(element)
         * </PRE>
        **/

        public цел first(T element, цел startingIndex = 0);

        /**
         * Report the индекс of righttmost occurrence of an element из_ a 
         * given starting point, or -1 if there is no such индекс.
         * @param element the element в_ look for
         * @param startingIndex the индекс в_ старт looking из_. The startingIndex
         * need not be a valid индекс. If less than zero the результат
         * will always be -1.
         * If greater than or equal в_ размер(), it is treated as размер()-1.
         * Возвращает: индекс such that
         * <PRE> 
         * let цел si = min(размер()-1, startingIndex) in
         *  индекс == -1 &&
         *   foreach (цел i in 0 .. si) !at(индекс).равно(element)
         *  ||
         *  at(индекс).равно(element) &&
         *   foreach (цел i in индекс+1 .. si) !at(индекс).равно(element)
         * </PRE>
         *
        **/
        public цел последний(T element, цел startingIndex = 0);


        /**
         * Construct a new SeqView that is a clone of сам except
         * that it does not contain the elements before индекс or
         * after индекс+length. If length is less than or equal в_ zero,
         * return an пустой SeqView.
         * @param индекс of the element that will be the 0th индекс in new SeqView
         * @param length the число of elements in the new SeqView
         * Возвращает: new пследвтн such that
         * <PRE>
         * s.размер() == max(0, length) &&
         * foreach (цел i in 0 .. s.размер()-1) s.at(i).равно(at(i+индекс)); 
         * </PRE>
         * Throws: NoSuchElementException if индекс is not in range 0..размер()-1
        **/
        public SeqView поднабор(цел индекс, цел length);

        /**
         * Construct a new SeqView that is a clone of сам except
         * that it does not contain the elements before begin or
         * after конец-1. If length is less than or equal в_ zero,
         * return an пустой SeqView.
         * @param индекс of the element that will be the 0th индекс in new SeqView
         * @param индекс of the последний element in the SeqView plus 1
         * Возвращает: new пследвтн such that
         * <PRE>
         * s.размер() == max(0, length) &&
         * foreach (цел i in 0 .. s.размер()-1) s.at(i).равно(at(i+индекс)); 
         * </PRE>
         * Throws: NoSuchElementException if индекс is not in range 0..размер()-1
        **/
        public SeqView opSlice(цел begin, цел конец);


version (VERBOSE)
{
        /**
         * Construct a new SeqView that is a clone of сам except
         * that it добавьs (inserts) the indicated element at the
         * indicated индекс.
         * @param индекс the индекс at which the new element will be placed
         * @param element The element в_ вставь in the new collection
         * Возвращает: new пследвтн s, such that
         * <PRE>
         *  s.at(индекс) == element &&
         *  foreach (цел i in 1 .. s.размер()-1) s.at(i).равно(at(i-1));
         * </PRE>
         * Throws: NoSuchElementException if индекс is not in range 0..размер()-1
        **/

        public SeqView insertingAt(цел индекс, T element);


        /**
         * Construct a new SeqView that is a clone of сам except
         * that the indicated element is placed at the indicated индекс.
         * @param индекс the индекс at which в_ замени the element
         * @param element The new значение of at(индекс)
         * Возвращает: new пследвтн, s, such that
         * <PRE>
         *  s.at(индекс) == element &&
         *  foreach (цел i in 0 .. s.размер()-1) 
         *     (i != индекс) --&gt; s.at(i).равно(at(i));
         * </PRE>
         * Throws: NoSuchElementException if индекс is not in range 0..размер()-1
        **/

        public SeqView replacingAt(цел индекс, T element);


        /**
         * Construct a new SeqView that is a clone of сам except
         * that it does not contain the element at the indeicated индекс; все
         * elements в_ its right are slопрed left by one.
         *
         * @param индекс the индекс at which в_ удали an element
         * Возвращает: new пследвтн such that
         * <PRE>
         *  foreach (цел i in 0.. индекс-1) s.at(i).равно(at(i)); &&
         *  foreach (цел i in индекс .. s.размер()-1) s.at(i).равно(at(i+1));
         * </PRE>
         * Throws: NoSuchElementException if индекс is not in range 0..размер()-1
        **/
        public SeqView removingAt(цел индекс);
} // version
}

