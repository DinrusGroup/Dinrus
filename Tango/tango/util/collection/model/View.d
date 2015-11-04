/*
 Файл: View.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ collections.d  working файл
 14dec95  dl                 Declare as a subinterface of Cloneable
 9Apr97   dl                 made Serializable

*/


module util.collection.model.View;

private import util.collection.model.Dispenser;
private import util.collection.model.GuardIterator;


/**
 * this is the основа interface for most classes in this package.
 *
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/
public interface View(T) 
{
        /**
         * все Views implement duplicate
        **/

        public View!(T) duplicate ();
        public alias duplicate dup;

        /**
         * Report whether the View содержит element.
         * Behaviorally equivalent в_ <CODE>instances(element) &gt;= 0</CODE>.
         * @param element the element в_ look for
         * Возвращает: да iff содержит at least one member that is equal в_ element.
        **/
        public бул содержит (T element);
        public alias содержит opIn;

        /**
         * Report the число of elements in the View.
         * No другой spurious effects.
         * Возвращает: число of elements
        **/
        public бцел размер ();
        public alias размер length;

        /**
         * Report whether this View есть no elements.
         * Behaviorally equivalent в_ <CODE>размер() == 0</CODE>.
         * Возвращает: да if размер() == 0
        **/

        public бул drained ();


        /**
         * все collections maintain a `version число'. The numbering
         * scheme is arbitrary, but is guaranteed в_ change upon every
         * modification that could possibly affect an elements() enumeration traversal.
         * (This is да at least within the точность of the `цел' representation;
         * performing ещё than 2^32 operations will lead в_ reuse of version numbers).
         * Versioning
         * <EM>may</EM> be conservative with respect в_ `replacement' operations.
         * For the sake of versioning replacements may be consопрered as
         * removals followed by добавьitions. Thus version numbers may change 
         * even if the old and new  elements are опрentical.
         * <P>
         * все element() enumerations for Mutable Collections track version
         * numbers, and raise inconsistency exceptions if the enumeration is
         * used (via получи()) on a version другой than the one generated
         * by the elements() метод.
         * <P>
         * You can use versions в_ check if обнови operations actually have any effect
         * on observable состояние.
         * For example, сотри() will cause cause a version change only
         * if the collection was previously non-пустой.
         * Возвращает: the version число
        **/

        public бцел mutation ();
        
        /**
         * Report whether the View COULD contain element,
         * i.e., that it is valid with respect в_ the View's
         * element screener if it есть one.
         * Always returns нет if element == пусто.
         * A constant function: if allows(v) is ever да it is always да.
         * (This property is not in any way enforced however.)
         * No другой spurious effects.
         * Возвращает: да if non-пусто and проходки element screener check
        **/
        public бул allows (T element);


        /**
         * Report the число of occurrences of element in View.
         * Always returns 0 if element == пусто.
         * Otherwise T.равно is used в_ тест for equality.
         * @param element the element в_ look for
         * Возвращает: the число of occurrences (always nonnegative)
        **/
        public бцел instances (T element);

        /**
         * Return an enumeration that may be used в_ traverse through
         * the elements in the View. Standard usage, for some
         * ViewT c, and some operation `use(T об)':
         * <PRE>
         * for (Обходчик e = c.elements(); e.ещё(); )
         *   use(e.значение());
         * </PRE>
         * (The values of получи very often need в_
         * be coerced в_ типы that you know they are.)
         * <P>
         * все Views return instances
         * of ViewIterator, that can report the число of remaining
         * elements, and also perform consistency checks so that
         * for MutableViews, element enumerations may become 
         * invalidated if the View is изменён during such a traversal
         * (which could in turn cause random effects on the ViewT.
         * TO prevent this,  ViewIterators 
         * raise CorruptedIteratorException on попытки в_ access
         * gets of altered Views.)
         * Note: Since все View implementations are synchronizable,
         * you may be able в_ guarantee that element traversals will not be
         * corrupted by using the D <CODE>synchronized</CODE> construct
         * around код blocks that do traversals. (Use with care though,
         * since such constructs can cause deadlock.)
         * <P>
         * Guarantees about the nature of the elements returned by  получи of the
         * returned Обходчик may vary accross sub-interfaces.
         * In все cases, the enumerations provопрed by elements() are guaranteed в_
         * step through (via получи) все elements in the View.
         * Unless guaranteed otherwise (for example in Seq), elements() enumerations
         * need not have any particular получи() ordering so дол as they
         * allow traversal of все of the elements. So, for example, two successive
         * calls в_ element() may произведи enumerations with the same
         * elements but different получи() orderings.
         * Again, sub-interfaces may provопрe stronger guarantees. In
         * particular, Seqs произведи enumerations with gets in
         * индекс order, ElementSortedViews enumerations are in ascending 
         * sorted order, and KeySortedViews are in ascending order of ключи.
         * Возвращает: an enumeration e such that
         * <PRE>
         *   e.remaining() == размер() &&
         *   foreach (v in e) есть(e) 
         * </PRE>
        **/

        public GuardIterator!(T) elements ();

        /**
         traverse the collection контент. This is cheaper than using an
         iterator since there is no creation cost involved.
        **/

        public цел opApply (цел delegate (inout T значение) дг);

        /**
         expose collection контент as an Массив
        **/

        public T[] toArray ();

        /**
         * Report whether другой есть the same element structure as this.
         * That is, whether другой is of the same размер, and есть the same 
         * elements() свойства.
         * This is a useful version of equality testing. But is not named
         * `равно' in часть because it may not be the version you need.
         * <P>
         * The easiest way в_ decribe this operation is just в_
         * explain как it is interpreted in стандарт sub-interfaces:
         * <UL>
         *  <LI> Seq and ElementSortedView: другой.elements() есть the 
         *        same order as this.elements().
         *  <LI> Bag: другой.elements есть the same instances each element as this.
         *  <LI> Набор: другой.elements есть все elements of this
         *  <LI> Map: другой есть все (ключ, element) pairs of this.
         *  <LI> KeySortedView: другой есть все (ключ, element)
         *       pairs as this, and with ключи enumerated in the same order as
         *       this.ключи().
         *</UL>
         * @param другой, a View
         * Возвращает: да if consопрered в_ have the same размер and elements.
        **/

        public бул matches (View другой);
        public alias matches opEquals;


        /**
         * Check the consistency of internal состояние, and raise исключение if
         * not ОК.
         * These should be `best-effort' checks. You cannot always locally
         * determine full consistency, but can usually approximate it,
         * and оцени the most important representation invariants.
         * The most common kinds of checks are cache checks. For example,
         * A linked список that also maintains a separate record of the
         * число of items on the список should проверь that the recorded
         * счёт matches the число of elements in the список.
         * <P>
         * This метод should either return normally or throw:
         * Throws: ImplementationError if check fails
        **/

        public проц checkImplementation();
}

