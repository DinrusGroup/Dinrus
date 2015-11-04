/*
 Файл: Bag.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ collections.d  working файл

*/


module util.collection.model.Bag;

private import  util.collection.model.BagView,
                util.collection.model.Iterator,
                util.collection.model.Dispenser;

/**
 * Bags are collections supporting multИПle occurrences of elements.
 * author: Doug Lea
**/

public interface Bag(V) : BagView!(V), Dispenser!(V)
{
        public override Bag!(V) duplicate();
        public alias duplicate dup;

        public alias добавь opCatAssign;

        проц добавь (V);

        проц добавьIf (V);

        проц добавь (Обходчик!(V));
}


