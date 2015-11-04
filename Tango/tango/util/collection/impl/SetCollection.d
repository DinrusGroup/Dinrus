/*
 Файл: SetCollection.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 13Oct95  dl                 Create
 22Oct95  dl                 добавь includeElements
 28jan97  dl                 сделай class public
*/


module util.collection.impl.SetCollection;

private import  util.collection.model.Set,
                util.collection.model.Iterator;

private import  util.collection.impl.Collection;

/**
 *
 * SetCollection extends MutableImpl в_ provопрe
 * default implementations of some Набор operations. 
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

public abstract class SetCollection(T) : Collection!(T), Набор!(T)
{
        alias Набор!(T).добавь               добавь;
        alias Collection!(T).удали     удали;
        alias Collection!(T).removeAll  removeAll;


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
         * Implements util.collection.impl.SetCollection.SetCollection.includeElements
         * See_Also: util.collection.impl.SetCollection.SetCollection.includeElements
        **/

        public проц добавь (Обходчик!(T) e)
        {
                foreach (значение; e)
                         добавь (значение);
        }


        version (VERBOSE)
        {
        // Default implementations of Набор methods

        /**
         * Implements util.collection.Набор.включая
         * See_Also: util.collection.Набор.включая
        **/
        public final Набор включая (T element)
        {
                auto c = cast(MutableSet) duplicate();
                c.include(element);
                return c;
        }
        } // version

        /***********************************************************************

                Implements util.collection.impl.Collection.Collection.removeAll
                See_Also: util.collection.impl.Collection.Collection.removeAll

                Has в_ be here rather than in the superclass в_ satisfy
                D interface опрioms

        ************************************************************************/

        public проц removeAll (Обходчик!(T) e)
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

        public проц удали (Обходчик!(T) e)
        {
                while (e.ещё)
                       удали (e.получи);
        }
}


