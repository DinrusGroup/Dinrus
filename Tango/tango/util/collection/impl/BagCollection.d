/*
 Файл: BagCollection.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 13Oct95  dl                 Create
 22Oct95  dl                 добавь добавьElements
 28jan97  dl                 сделай class public
*/


module util.collection.impl.BagCollection;

private import  util.collection.model.Bag,
                util.collection.model.Iterator;

private import  util.collection.impl.Collection;

/**
 *
 * MutableBagImpl extends MutableImpl в_ provопрe
 * default implementations of some Bag operations. 
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

public abstract class BagCollection(V) : Collection!(V), Bag!(V)
{
        alias Bag!(V).добавь               добавь;
        alias Collection!(V).удали     удали;
        alias Collection!(V).removeAll  removeAll;

        
        /**
         * Initialize at version 0, an пустой счёт, and пусто screener
        **/

        protected this ()
        {
                super();
        }

        /**
         * Initialize at version 0, an пустой счёт, and supplied screener
        **/
        protected this (Predicate screener)
        {
                super(screener);
        }

        /**
         * Implements util.collection.MutableBag.добавьElements
         * See_Also: util.collection.MutableBag.добавьElements
        **/

        public final проц добавь(Обходчик!(V) e)
        {
                foreach (значение; e)
                         добавь (значение);
        }


        // Default implementations of Bag methods

version (VERBOSE)
{
        /**
         * Implements util.collection.Bag.добавьingIfAbsent
         * See_Also: util.collection.Bag.добавьingIfAbsent
        **/
        public final Bag добавьingIf(V element)
        {
                Bag c = duplicate();
                c.добавьIf(element);
                return c;
        }


        /**
         * Implements util.collection.Bag.добавьing
         * See_Also: util.collection.Bag.добавьing
        **/

        public final Bag добавьing(V element)
        {
                Bag c = duplicate();
                c.добавь(element);
                return c;
        }
} // version


        /***********************************************************************

                Implements util.collection.impl.Collection.Collection.removeAll
                See_Also: util.collection.impl.Collection.Collection.removeAll

                Has в_ be here rather than in the superclass в_ satisfy
                D interface опрioms

        ************************************************************************/

        public проц removeAll (Обходчик!(V) e)
        {
                while (e.ещё)
                       removeAll (e.получи);
        }

        /***********************************************************************

                Implements util.collection.impl.Collection.Collection.removeElements
                See_Also: util.collection.impl.Collection.Collection.removeElements

                Has в_ be here rather than in the superclass в_ satisfy
                D interface опрioms

        ************************************************************************/

        public проц удали (Обходчик!(V) e)
        {
                while (e.ещё)
                       удали (e.получи);
        }
}

