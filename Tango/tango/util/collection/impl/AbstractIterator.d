/*
 Файл: AbstractIterator.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ util.collection.d  working файл
 13Oct95  dl                 Changed protection statuses
  9Apr97  dl                 made class public
*/


module util.collection.impl.AbstractIterator;

private import  exception;

private import  util.collection.model.View,
                util.collection.model.GuardIterator;
                


/**
 *
 * A convenient основа class for implementations of GuardIterator
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public abstract class AbstractIterator(T) : GuardIterator!(T)
{
        /**
         * The collection being enumerated
        **/

        private View!(T) view;

        /**
         * The version число of the collection we got upon construction
        **/

        private бцел mutation;

        /**
         * The число of elements we think we have left.
         * Initialized в_ view.размер() upon construction
        **/

        private бцел togo;
        

        protected this (View!(T) v)
        {
                view = v;
                togo = v.размер();
                mutation = v.mutation();
        }

        /**
         * Implements util.collection.impl.Collection.CollectionIterator.corrupted.
         * Claim corruption if version numbers differ
         * See_Also: util.collection.impl.Collection.CollectionIterator.corrupted
        **/

        public final бул corrupted()
        {
                return mutation != view.mutation;
        }

        /**
         * Implements util.collection.impl.Collection.CollectionIterator.numberOfRemaingingElements.
         * See_Also: util.collection.impl.Collection.CollectionIterator.remaining
        **/
        public final бцел remaining()
        {
                return togo;
        }

        /**
         * Implements util.collection.model.Iterator.ещё.
         * Return да if remaining > 0 and not corrupted
         * See_Also: util.collection.model.Iterator.ещё
        **/
        public final бул ещё()
        {
                return togo > 0 && mutation is view.mutation;
        }

        /**
         * Subclass utility. 
         * Tries в_ декремент togo, raising exceptions
         * if it is already zero or if corrupted()
         * Always вызов as the first строка of получи.
        **/
        protected final проц decRemaining()
        {
                if (mutation != view.mutation)
                    throw new CorruptedIteratorException ("Collection изменён during iteration");

                if (togo is 0)
                    throw new NoSuchElementException ("exhausted enumeration");

                --togo;
        }
}


public abstract class AbstractMapIterator(K, V) : AbstractIterator!(V), PairIterator!(K, V) 
{
        abstract V получи (inout K ключ);

        protected this (View!(V) c)
        {
                super (c);
        }
}
