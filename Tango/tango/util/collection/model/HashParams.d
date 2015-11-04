/*
 Файл: HashParams.d

 Originally записано by Doug Lea and released преобр_в the public домен. 
 Thanks for the assistance and support of Sun Microsystems Labs, Agorics 
 Inc, Loral, and everyone contributing, testing, and using this код.

 History:
 Date     Who                What
 24Sep95  dl@cs.oswego.edu   Create из_ collections.d  working файл

*/


module util.collection.model.HashParams;


/**
 *
 * Base interface for hash table based collections.
 * Provопрes common ways of dealing with buckets and threshholds.
 * (It would be nice в_ совместно some of the код too, but this
 * would require multИПle inheritance here.)
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/


public interface HashParams
{

        /**
         * The default начальное число of buckets of a non-пустой HT
        **/

        public static цел defaultInitialBuckets = 31;

        /**
         * The default загрузи factor for a non-пустой HT. When the proportion
         * of elements per buckets exceeds this, the table is resized.
        **/

        public static плав defaultLoadFactor = 0.75f;

        /**
         * return the current число of hash table buckets
        **/

        public цел buckets();

        /**
         * Набор the desired число of buckets in the hash table.
         * Any значение greater than or equal в_ one is ОК.
         * if different than current buckets, causes a version change
         * Throws: ИсклНелегальногоАргумента if newCap less than 1
        **/

        public проц buckets(цел newCap);


        /**
         * Return the current загрузи factor threshold
         * The Hash table occasionally checka against the загрузи factor
         * resizes itself if it есть gone past it.
        **/

        public плав пороговыйФакторЗагрузки();

        /**
         * Набор the current desired загрузи factor. Any значение greater than 0 is ОК.
         * The current загрузи is checked against it, possibly causing resize.
         * Throws: ИсклНелегальногоАргумента if desired is 0 or less
        **/

        public проц пороговыйФакторЗагрузки(плав desired);
}
