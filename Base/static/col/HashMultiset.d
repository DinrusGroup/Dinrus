/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.HashMultiset;

public import col.model.Multiset;
public import col.Functions;
private import col.Hash;

/**
 * Реализация мультинабора, использующая Хэш для ближней вставкиr O(1),
 * deletion и lookup time.
 *
 * Adding an элемент might invalidate cursors depending on the implementation.
 *
 * Removing an элемент only invalidates cursors that were pointing at that
 * элемент.
 *
 * (non-function members can be properties unless otherwise specified):
 *
 *
 * You can replace the Хэш implementation with a custom implementation, the
 * Хэш must be a struct template which can be instantiated with a single
 * template аргумент V, и must implement the following members (non-function
 * members can be дай/установи properties unless otherwise specified):
 *
 *
 * parameters -> must be a struct with at least the following members:
 *   хэшФункц -> the хэш function to use (should be a ХэшФунк!(V))
 * 
 * проц установка(parameters p) -> initializes the хэш with the given parameters.
 *
 * бцел счёт -> счёт of the элементы in the хэш
 *
 * позиция -> must be a struct/class with the following member:
 *   укз -> must define the following member:
 *     значение -> the значение which is pointed to by this позиция (cannot be a
 *                property)
 *   позиция следщ -> следщ позиция in the хэш map
 *   позиция предш -> previous позиция in the хэш map
 *
 * бул добавь(V v) -> добавь the given значение to the хэш.  The хэш of the значение
 * will be given by хэшФункц(v).  If the значение already exists in the хэш,
 * this should call обновлФункц(v) и should not increment счёт.
 *
 * позиция начало -> must be a позиция that points to the very первый действителен
 * элемент in the хэш, or конец if no элементы exist.
 *
 * позиция конец -> must be a позиция that points to just past the very последн
 * действителен элемент.
 *
 * позиция найди(V v) -> returns a позиция that points to the элемент that
 * содержит v, or конец if the элемент doesn't exist.
 *
 * позиция удали(позиция p) -> removes the given элемент from the хэш,
 * returns the следщ действителен элемент or конец if p was последн in the хэш.
 *
 * проц очисти() -> removes all элементы from the хэш, sets счёт to 0.
 *
 * бцел удалиВсе(V v) -> удали all экземпляры of the given значение, returning
 * how many were removed.
 *
 * бцел считайВсе(V v) -> returns the number of экземпляры of the given значение in
 * the хэш.
 *
 * проц копируйВ(ref Хэш h) -> make a дубликат копируй of this хэш into the
 * цель h.
 */
class ХэшМультинабор(V, alias ШаблРеализац=ХэшДуб, alias хэшФункц=ДефХэш) : Мультинабор!(V)
{
    /**
     * an alias the the implementation template instantiation.
     */
    alias ШаблРеализац!(V, хэшФункц) Реализ;

    private Реализ _хэш;

    /**
     * A курсор for the хэш multiset.
     */
    struct курсор
    {
        private Реализ.позиция позиция;

        /**
         * дай the значение at this позиция
         */
        V значение()
        {
            return позиция.ptr.значение;
        }

        /**
         * increment this курсор, returns что the курсор was перед
         * incrementing.
         */
        курсор opPostInc()
        {
            курсор врм = *this;
            позиция = позиция.следщ;
            return врм;
        }

        /**
         * decrement this курсор, returns что the курсор was перед
         * decrementing.
         */
        курсор opPostDec()
        {
            курсор врм = *this;
            позиция = позиция.предш;
            return врм;
        }

        /**
         * increment the курсор by the given amount.
         *
         * This is an O(прир) operation!  You should only use this operator in
         * the form:
         *
         * ++i;
         */
        курсор opAddAssign(цел прир)
        {
            if(прир < 0)
                return opSubAssign(-прир);
            while(прир--)
                позиция = позиция.следщ;
            return *this;
        }

        /**
         * decrement the курсор by the given amount.
         *
         * This is an O(прир) operation!  You should only use this operator in
         * the form:
         *
         * --i;
         */
        курсор opSubAssign(цел прир)
        {
            if(прир < 0)
                return opAddAssign(-прир);
            while(прир--)
                позиция = позиция.предш;
            return *this;
        }

        /**
         * сравни two cursors for equality
         */
        бул opEquals(курсор обх)
        {
            return обх.позиция == позиция;
        }
    }

    /**
     * Iterate through all the элементы of the multiset, indicating which
     * элементы should be removed
     *
     *
     * Use like this:
     * ----------
     * // удали all odd элементы
     * foreach(ref чистить_ли, v; &hashMultiset.очистить)
     * {
     *   чистить_ли = ((v & 1) == 1);
     * }
     */
    цел очистить(цел delegate(ref бул чистить_ли, ref V v) дг)
    {
        return _примени(дг);
    }

    private цел _примени(цел delegate(ref бул чистить_ли, ref V v) дг)
    {
        курсор обх = начало;
        бул чистить_ли;
        цел возврдг = 0;
        курсор _конец = конец; // кэш конец so обх isn't always being generated
        while(!возврдг && обх != _конец)
        {
            //
            // don't allow user to change значение
            //
            V врмзначение = обх.значение;
            чистить_ли = false;
            if((возврдг = дг(чистить_ли, врмзначение)) != 0)
                break;
            if(чистить_ли)
                удали(обх++);
            else
                обх++;
        }
        return возврдг;
    }

    /**
     * iterate over the collection's значения
     */
    цел opApply(цел delegate(ref V v) дг)
    {
        цел _дг(ref бул чистить_ли, ref V v)
        {
            return дг(v);
        }
        return _примени(&_дг);
    }

    /**
     * Instantiate the хэш map using the default implementation parameters.
     */
    this()
    {
        _хэш.установка();
    }

    private this(ref Реализ дубИз)
    {
        дубИз.копируйВ(_хэш);
    }

    /**
     * Clear the collection of all элементы
     */
    ХэшМультинабор очисти()
    {
        _хэш.очисти();
        return this;
    }

    /**
     * returns number of элементы in the collection
     */
    бцел длина()
    {
        return _хэш.счёт;
    }
	alias длина length;
    /**
     * returns a курсор to the первый элемент in the collection.
     */
    курсор начало()
    {
        курсор обх;
        обх.позиция = _хэш.начало();
        return обх;
    }

    /**
     * returns a курсор that points just past the последн элемент in the
     * collection.
     */
    курсор конец()
    {
        курсор обх;
        обх.позиция = _хэш.конец();
        return обх;
    }

    /**
     * удали the элемент pointed at by the given курсор, returning an
     * курсор that points to the следщ элемент in the collection.
     *
     * Runs on average in O(1) time.
     */
    курсор удали(курсор обх)
    {
        обх.позиция = _хэш.удали(обх.позиция);
        return обх;
    }

    /**
     * найди the первый instance of a значение in the collection.  Returns конец if
     * the значение is not present.
     *
     * Runs in average O(1) time.
     */
    курсор найди(V v)
    {
        курсор обх;
        обх.позиция = _хэш.найди(v);
        return обх;
    }

    /**
     * найди the следщ курсор that points to a V значение.
     *
     * Returns конец if no more экземпляры of v exist in the collection.
     */
    курсор найди(курсор обх, V v)
    {
        обх.позиция = _хэш.найди(v, обх.позиция);
        return обх;
    }

    /**
     * Returns true if the given значение exists in the collection.
     *
     * Runs in average O(1) time.
     */
    бул содержит(V v)
    {
        return найди(v) != конец;
    }

    /**
     * Removes the первый элемент that имеется the значение v.  Returns true if the
     * значение was present и was removed.
     *
     * Runs in O(n) time.
     */
    ХэшМультинабор удали(V v)
    {
        бул пропущен;
        return удали(v, пропущен);
    }

    /**
     * Removes the первый элемент that имеется the значение v.  Returns true if the
     * значение was present и was removed.
     *
     * Runs in O(n) time.
     */
    ХэшМультинабор удали(V v, ref бул был_Удалён)
    {
        курсор обх = найди(v);
        if(обх == конец)
        {
            был_Удалён = false;
        }
        else
        {
            был_Удалён = true;
            удали(обх);
        }
        return this;
    }

    /**
     * Adds an элемент to the установи.  Returns true if the элемент was not
     * already present.
     *
     * Runs on average in O(1) time.
     */
    ХэшМультинабор добавь(V v)
    {
        _хэш.добавь(v);
        return this;
    }

    /**
     * Adds an элемент to the установи.  Returns true if the элемент was not
     * already present.
     *
     * Runs on average in O(1) time.
     */
    ХэшМультинабор добавь(V v, ref бул был_добавлен)
    {
        был_добавлен = _хэш.добавь(v);
        return this;
    }

    /**
     * Adds all the элементы from обх to the установи.  Returns the number
     * of элементы добавленный.
     *
     * Runs on average in O(1) + O(m) time, where m is the number of элементы
     * in the обходчик.
     */
    ХэшМультинабор добавь(Обходчик!(V) обх)
    {
        foreach(v; обх)
            _хэш.добавь(v);
        return this;
    }

    /**
     * Adds all the элементы from обх to the установи.  Returns the number
     * of элементы добавленный.
     *
     * Runs on average in O(1) + O(m) time, where m is the number of элементы
     * in the обходчик.
     */
    ХэшМультинабор добавь(Обходчик!(V) обх, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        добавь(обх);
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Adds all the элементы from the массив to the установи.  Returns the number of
     * элементы добавленный.
     *
     * Runs on average in O(1) * O(m) time, where m is the массив длина.
     */
    ХэшМультинабор добавь(V[] массив)
    {
        бцел пропущен;
        return добавь(массив, пропущен);
    }

    /**
     * Adds all the элементы from the массив to the установи.  Returns the number of
     * элементы добавленный.
     *
     * Runs on average in O(1) * O(m) time, where m is the массив длина.
     */
    ХэшМультинабор добавь(V[] массив, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        foreach(v; массив)
            _хэш.добавь(v);
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Returns the number of элементы in the collection that are equal to v.
     *
     * Runs on average in O(m * 1) time, where m is the number of элементы
     * that are v.
     */
    бцел счёт(V v)
    {
        return _хэш.считайВсе(v);
    }

    /**
     * Removes all the элементы that are equal to v.
     *
     * Runs on average in O(m * 1) time, where m is the number of элементы
     * that are v.
     */
    ХэшМультинабор удалиВсе(V v)
    {
        _хэш.удалиВсе(v);
        return this;
    }

    /**
     * Removes all the элементы that are equal to v.
     *
     * Runs on average in O(m * 1) time, where m is the number of элементы
     * that are v.
     */
    ХэшМультинабор удалиВсе(V v, ref бцел чло_Удалённых)
    {
        чло_Удалённых = _хэш.удалиВсе(v);
        return this;
    }

    /**
     * make a shallow копируй of this хэш mulitiset.
     */
    ХэшМультинабор dup()
    {
        return new ХэшМультинабор(_хэш);
    }

    /**
     * дай the most convenient элемент in the установи.  This is the элемент that
     * would be iterated первый.  Therefore, calling удали(дай()) is
     * guaranteed to be less than an O(n) operation.
     */
    V дай()
    {
        return начало.значение;
    }

    /**
     * Remove the most convenient элемент from the установи, и return its значение.
     * This is equivalent to удали(дай()), except that only one lookup is
     * performed.
     */
    V изыми()
    {
        auto c = начало;
        auto возврзнач = c.значение;
        удали(c);
        return возврзнач;
    }
}

version(UnitTest)
{
    unittest
    {
        auto hms = new ХэшМультинабор!(бцел);
        Мультинабор!(бцел) ms = hms;
        hms.добавь([0U, 1, 2, 3, 4, 5, 5]);
        assert(hms.length == 7);
        assert(ms.счёт(5U) == 2);
        foreach(ref чистить_ли, i; &ms.очистить)
        {
            чистить_ли = (i % 2 == 1);
        }
        assert(ms.счёт(5U) == 0);
        assert(ms.length == 3);
    }
}
