/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.TreeMultiset;

public import col.model.Multiset;
public import col.Functions;

private import col.RBTree;

/**
 * Implementation of the Мультинабор interface using Красный-Чёрный trees.  this
 * allows for O(lg(n)) insertion, removal, и lookup times.  It also creates
 * a sorted установи of элементы.  V must be comparable.
 *
 * Adding an элемент does not invalidate any cursors.
 *
 * Removing an элемент only invalidates the cursors that were pointing at
 * that элемент.
 *
 * You can replace the Tree implementation with a custom implementation, the
 * implementation must be a struct template which can be instantiated with a
 * single template аргумент V, и must implement the following members
 * (non-function members can be properties unless otherwise specified):
 *
 * parameters -> must be a struct with at least the following members:
 *   функцСравнения -> the сравни function to use (should be a
 *                      ФункцСравнения!(V))
 * 
 * проц установка(parameters p) -> initializes the tree with the given parameters.
 *
 * бцел счёт -> счёт of the элементы in the tree
 *
 * Узел -> must be a struct/class with the following members:
 *   V значение -> the значение which is pointed to by this позиция (cannot be a
 *                property)
 *   Узел следщ -> the следщ Узел in the tree as defined by the сравни
 *                function, or конец if no other узелs exist.
 *   Узел предш -> the previous Узел in the tree as defined by the сравни
 *                function.
 *
 * бул добавь(V v) -> добавь the given значение to the tree according to the order
 * defined by the сравни function.  If the элемент already exists in the
 * tree, the function should добавь обх after all equivalent элементы.
 *
 * Узел начало -> must be a Узел that points to the very первый действителен
 * элемент in the tree, or конец if no элементы exist.
 *
 * Узел конец -> must be a Узел that points to just past the very последн
 * действителен элемент.
 *
 * Узел найди(V v) -> returns a Узел that points to the первый элемент in the
 * tree that содержит v, or конец if the элемент doesn't exist.
 *
 * Узел удали(Узел p) -> removes the given элемент from the tree,
 * returns the следщ действителен элемент or конец if p was последн in the tree.
 *
 * проц очисти() -> removes all элементы from the tree, sets счёт to 0.
 *
 * бцел считайВсе(V v) -> returns the number of элементы with the given значение.
 *
 * Узел удалиВсе(V v) -> removes all the given значения from the tree.
 */
class ДеревоМультинабор(V, alias ШаблРеализац = КЧДеревоДуб, alias функцСравнения=ДефСравнить) : Мультинабор!(V)
{
    /**
     * convenience alias
     */
    alias ШаблРеализац!(V, функцСравнения) Реализ;

    private Реализ _дерево;

    /**
     * курсор for the tree multiset
     */
    struct курсор
    {
        private Реализ.Узел укз; alias укз ptr;

        /**
         * дай the значение in this элемент
         */
        V значение()
        {
            return укз.значение;
        }

        /**
         * increment this курсор, returns что the курсор was перед
         * incrementing.
         */
        курсор opPostInc()
        {
            курсор врм = *this;
            укз = укз.следщ;
            return врм;
        }

        /**
         * decrement this курсор, returns что the курсор was перед
         * decrementing.
         */
        курсор opPostDec()
        {
            курсор врм = *this;
            укз = укз.предш;
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
                укз = укз.следщ;
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
                укз = укз.предш;
            return *this;
        }

        /**
         * сравни two cursors for equality
         */
        бул opEquals(курсор обх)
        {
            return обх.ptr is укз;
        }
    }

    /**
     * Iterate through the элементы of the collection, specifying which ones
     * should be removed.
     *
     * Use like this:
     * -------------
     * // удали all odd элементы
     * foreach(ref чистить_ли, v; &treeMultiset.очистить)
     * {
     *   чистить_ли = ((v % 1) == 1);
     * }
     * -------------
     */
    final цел очистить(цел delegate(ref бул чистить_ли, ref V v) дг)
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
                обх = удали(обх);
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
     * Instantiate the tree multiset
     */
    this()
    {
        _дерево.установка();
    }

    //
    // for dup
    //
    private this(ref Реализ дубИз)
    {
        дубИз.копируйВ(_дерево);
    }

    /**
     * Clear the collection of all элементы
     */
    ДеревоМультинабор очисти()
    {
        _дерево.очисти();
        return this;
    }

    /**
     * returns number of элементы in the collection
     */
    бцел длина()
    {
        return _дерево.счёт;
    }
	alias длина length;

    /**
     * returns a курсор to the первый элемент in the collection.
     */
    курсор начало()
    {
        курсор обх;
        обх.ptr = _дерево.начало;
        return обх;
    }

    /**
     * returns a курсор that points just past the последн элемент in the
     * collection.
     */
    курсор конец()
    {
        курсор обх;
        обх.ptr = _дерево.конец;
        return обх;
    }

    /**
     * удали the элемент pointed at by the given курсор, returning an
     * курсор that points to the следщ элемент in the collection.
     *
     * Runs in O(lg(n)) time.
     */
    курсор удали(курсор обх)
    {
        обх.ptr = _дерево.удали(обх.ptr);
        return обх;
    }

    /**
     * найди the первый instance of a given значение in the collection.  Returns
     * конец if the значение is not present.
     *
     * Runs in O(lg(n)) time.
     */
    курсор найди(V v)
    {
        курсор обх;
        обх.ptr = _дерево.найди(v);
        return обх;
    }

    /**
     * Returns true if the given значение exists in the collection.
     *
     * Runs in O(lg(n)) time.
     */
    бул содержит(V v)
    {
        return найди(v) != конец;
    }

    /**
     * Removes the первый элемент that имеется the значение v.  Returns true if the
     * значение was present и was removed.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоМультинабор удали(V v)
    {
        курсор обх = найди(v);
        if(обх != конец)
            удали(обх);
        return this;
    }

    /**
     * Removes the первый элемент that имеется the значение v.  Returns true if the
     * значение was present и was removed.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоМультинабор удали(V v, ref бул был_Удалён)
    {
        курсор обх = найди(v);
        if(обх == конец)
        {
            был_Удалён = false;
        }
        else
        {
            удали(обх);
            был_Удалён = true;
        }
        return this;
    }

    /**
     * Adds a значение to the collection.
     * Returns this.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоМультинабор добавь(V v)
    {
        _дерево.добавь(v);
        return this;
    }

    /**
     * Adds a значение to the collection. Sets был_добавлен to true if the значение was
     * добавленный.
     *
     * Returns this.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоМультинабор добавь(V v, ref бул был_добавлен)
    {
        был_добавлен = _дерево.добавь(v);
        return this;
    }

    /**
     * Adds all the значения from the обходчик to the collection.
     *
     * Runs in O(m lg(n)) time, where m is the number of элементы in
     * the обходчик.
     */
    ДеревоМультинабор добавь(Обходчик!(V) обх)
    {
        foreach(v; обх)
            _дерево.добавь(v);
        return this;
    }

    /**
     * Adds all the значения from the обходчик to the collection. Sets чло_добавленных
     * to the number of значения добавленный from the обходчик.
     *
     * Runs in O(m lg(n)) time, where m is the number of элементы in
     * the обходчик.
     */
    ДеревоМультинабор добавь(Обходчик!(V) обх, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        добавь(обх);
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Adds all the значения from массив to the collection.
     *
     * Runs in O(m lg(n)) time, where m is the number of элементы in
     * массив.
     */
    ДеревоМультинабор добавь(V[] массив)
    {
        foreach(v; массив)
            _дерево.добавь(v);
        return this;
    }

    /**
     * Adds all the значения from массив to the collection.  Sets чло_добавленных to the
     * number of элементы добавленный from the массив.
     *
     * Runs in O(m lg(n)) time, where m is the number of элементы in
     * массив.
     */
    ДеревоМультинабор добавь(V[] массив, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        добавь(массив);
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Returns the number of элементы in the collection that are equal to v.
     *
     * Runs in O(m lg(n)) time, where m is the number of элементы that are v.
     */
    бцел счёт(V v)
    {
        return _дерево.считайВсе(v);
    }

    /**
     * Removes all the элементы that are equal to v.
     *
     * Runs in O(m lg(n)) time, where m is the number of элементы that are v.
     */
    ДеревоМультинабор удалиВсе(V v)
    {
        _дерево.удалиВсе(v);
        return this;
    }
    
    /**
     * Removes all the элементы that are equal to v.  Sets чло_Удалённых to the
     * number of элементы removed from the multiset.
     *
     * Runs in O(m lg(n)) time, where m is the number of элементы that are v.
     */
    ДеревоМультинабор удалиВсе(V v, ref бцел чло_Удалённых)
    {
        чло_Удалённых = _дерево.удалиВсе(v);
        return this;
    }

    /**
     * дубликат this tree multiset
     */
    ДеревоМультинабор dup()
    {
        return new ДеревоМультинабор(_дерево);
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
        auto tms = new ДеревоМультинабор!(бцел);
        Мультинабор!(бцел) ms = tms;
        ms.добавь([0U, 1, 2, 3, 4, 5, 5]);
        assert(ms.length == 7);
        assert(ms.счёт(5U) == 2);
        foreach(ref чистить_ли, i; &ms.очистить)
            чистить_ли = (i % 2 == 1);
        assert(ms.счёт(5U) == 0);
        assert(ms.length == 3);
    }
}
