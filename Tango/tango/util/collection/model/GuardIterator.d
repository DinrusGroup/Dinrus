/*
 Файл: GuardIterator.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ collections.d  working файл

*/


module util.collection.model.GuardIterator;

private import util.collection.model.Iterator;

/**
 *
 * CollectionIterator extends the стандарт
 * util.collection.model.Iterator interface with two добавьitional methods.
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

public interface GuardIterator(V) : Обходчик!(V)
{
        /**
         * Return да if the collection that constructed this enumeration
         * есть been detectably изменён since construction of this enumeration.
         * Ability and точность of detection of this condition can vary
         * across collection class implementations.
         * ещё() is нет whenever corrupted is да.
         *
         * Возвращает: да if detectably corrupted.
        **/

        public бул corrupted();

        /**
         * Return the число of elements in the enumeration that have
         * not yet been traversed. When corrupted() is да, this 
         * число may (or may not) be greater than zero even if ещё() 
         * is нет. Исключение recovery mechanics may be able в_
         * use this as an indication that recovery of some сортируй is
         * warranted. However, it is not necessarily a foolproof indication.
         * <P>
         * You can also use it в_ pack enumerations преобр_в массивы. For example:
         * <PRE>
         * Объект масс[] = new Объект[e.numberOfRemainingElement()]
         * цел i = 0;
         * while (e.ещё()) масс[i++] = e.значение();
         * </PRE>
         * <P>
         * For the converse case, 
         * See_Also: util.collection.iterator.ArrayIterator.ArrayIterator
         * Возвращает: the число of untraversed elements
        **/

        public бцел remaining();
}


public interface PairIterator(K, V) : GuardIterator!(V)
{
        alias GuardIterator!(V).получи     получи;
        alias GuardIterator!(V).opApply opApply;
        
        public V получи (inout K ключ);

        цел opApply (цел delegate (inout K ключ, inout V значение) дг);        
}

