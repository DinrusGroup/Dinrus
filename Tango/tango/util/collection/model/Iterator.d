/*
 Файл: Обходчик.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ collections.d  working файл

*/


module util.collection.model.Iterator;


/**
 *
 **/

public interface Обходчик(V)
{
        public бул ещё();

        public V получи();

        цел opApply (цел delegate (inout V значение) дг);        
}
