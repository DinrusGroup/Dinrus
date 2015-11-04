/*
 Файл: Comparator.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ collections.d  working файл

*/


module util.collection.model.Comparator;


/**
 *
 * Comparator is an interface for any class possessing an element
 * comparison метод.
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

template Comparator(T)
{
        alias цел delegate(T, T) Comparator;
}

/+
public interface Comparator(T)
{
        /**
         * @param fst first аргумент
         * @param snd сукунда аргумент
         * Возвращает: a negative число if fst is less than snd; a
         * positive число if fst is greater than snd; else 0
        **/
        public цел compare(T fst, T snd);
}
+/
