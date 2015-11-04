/*
 Файл: SeqCollection.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 13Oct95  dl                 Create
 28jab97  dl                 сделай class public
*/


module util.collection.impl.SeqCollection;

private import  util.collection.model.Seq,
                util.collection.model.Iterator;

private import  util.collection.impl.Collection;



/**
 *
 * SeqCollection extends MutableImpl в_ provопрe
 * default implementations of some Seq operations. 
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

public abstract class SeqCollection(T) : Collection!(T), Seq!(T)
{
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


        // Default implementations of Seq methods

version (VERBOSE)
{
        /**
         * Implements util.collection.model.Seq.Seq.insertingAt.
         * See_Also: util.collection.model.Seq.Seq.insertingAt
        **/
        public final Seq insertingAt(цел индекс, T element)
        {
                MutableSeq c = пусто;
                //      c = (cast(MutableSeq)clone());
                c = (cast(MutableSeq)duplicate());
                c.вставь(индекс, element);
                return c;
        }

        /**
         * Implements util.collection.model.Seq.Seq.removingAt.
         * See_Also: util.collection.model.Seq.Seq.removingAt
        **/
        public final Seq removingAt(цел индекс)
        {
                MutableSeq c = пусто;
                //      c = (cast(MutableSeq)clone());
                c = (cast(MutableSeq)duplicate());
                c.удали(индекс);
                return c;
        }


        /**
         * Implements util.collection.model.Seq.Seq.replacingAt
         * See_Also: util.collection.model.Seq.Seq.replacingAt
        **/
        public final Seq replacingAt(цел индекс, T element)
        {
                MutableSeq c = пусто;
                //      c = (cast(MutableSeq)clone());
                c = (cast(MutableSeq)duplicate());
                c.замени(индекс, element);
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

        /***********************************************************************

                Implements util.collection.model.Seq.opIndexAssign
                See_Also: util.collection.model.Seq.replaceAt

                Calls replaceAt(индекс, element);

        ************************************************************************/
        public final проц opIndexAssign (T element, цел индекс)
        {
                replaceAt(индекс, element);
        }

        /***********************************************************************

                Implements util.collection.model.SeqView.opSlice
                See_Also: util.collection.model.SeqView.поднабор

                Calls поднабор(begin, (конец - begin));

        ************************************************************************/
        public SeqCollection opSlice(цел begin, цел конец)
        {
                return поднабор(begin, (конец - begin));
        }

}

