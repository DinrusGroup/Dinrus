/**
  *
  * Copyright:  Copyright (C) 2008 Chris Wright.  все rights reserved.
  * License:    BSD стиль: $(LICENSE)
  * Версия:    Oct 2008: Initial release
  * Author:     Chris Wright, aka dhasenan
  *
  */

module util.container.more.куча;

private import exception;

бул minHeapCompare(T)(T a, T b) {return a <= b;}
бул maxHeapCompare(T)(T a, T b) {return a >= b;}
проц defaultHeapSwap(T)(T t, бцел индекс) {}

/** A куча is a данные structure where you can вставь items in random order and extract them in sorted order. 
  * Pushing an element преобр_в the куча takes O(lg n) and popping the top of the куча takes O(lg n). Heaps are 
  * thus popular for sorting, among другой things.
  * 
  * No opApply is provопрed, since most people would expect this в_ return the contents in sorted order,
  * not do significant куча allocation, not modify the collection, and complete in linear время. This
  * combination is not possible with a куча. 
  *
  * Note: always пароль by reference when modifying a куча. 
  *
  * The template аргументы в_ the куча are:
  *     T       = the element тип
  *     Compare = a function called when ordering elements. Its сигнатура should be бул(T, T).
  *               see minHeapCompare() and maxHeapCompare() for examples.
  *     Move    = a function called when свопping elements. Its сигнатура should be проц(T, бцел).
  *               The default does nothing, and should suffice for most users. You 
  *               probably want в_ keep this function small; it's called O(лог N) 
  *               times per insertion or removal.
*/

struct куча (T, alias Compare = minHeapCompare!(T), alias Move = defaultHeapSwap!(T))
{
        alias вынь       удали;
        alias push      opCatAssign;

        // The actual данные.
        private T[]     куча;
        
        // The индекс of the cell преобр_в which the следщ element will go.
        private бцел    следщ;

        /** Inserts the given element преобр_в the куча. */
        проц push (T t)
        {
                auto индекс = следщ++;
                while (куча.length <= индекс)
                       куча.length = 2 * куча.length + 32;

                куча [индекс] = t;
                Move (t, индекс);
                fixup (индекс);
        }

        /** Inserts все elements in the given Массив преобр_в the куча. */
        проц push (T[] Массив)
        {
                if (куча.length < следщ + Массив.length)
                        куча.length = следщ + Массив.length + 32;

                foreach (t; Массив) push (t);
        }

        /** Removes the top of this куча and returns it. */
        T вынь ()
        {
                return removeAt (0);
        }

        /** Удали the every экземпляр that matches the given item. */
        проц removeAll (T t)
        {
                // TODO: this is slower than it could be.
                // I am reasonably certain we can do the O(n) скан, but I want в_
                // look at it a bit ещё.
                while (удали (t)) {}
        }

        /** Удали the first экземпляр that matches the given item. 
          * Возвращает: да iff the item was найдено, otherwise нет. */
        бул удали (T t)
        {
                foreach (i, a; куча)
                {
                        if (a is t || a == t)
                        {
                                removeAt (i);
                                return да;
                        }
                }
                return нет;
        }

        /** Удали the element at the given индекс из_ the куча.
          * The индекс is according в_ the куча's internal выкладка; you are 
          * responsible for making sure the индекс is correct.
          * The куча invariant is maintained. */
        T removeAt (бцел индекс)
        {
                if (следщ <= индекс)
                {
                        throw new NoSuchElementException ("куча :: tried в_ удали an"
                                ~ " element with индекс greater than the размер of the куча "
                                ~ "(dопр you вызов вынь() из_ an пустой куча?)");
                }
                следщ--;
                auto t = куча[индекс];
                // if следщ == индекс, then we have nothing valid on the куча
                // so popping does nothing but change the length
                // the другой calls are irrelevant, but we surely don't want в_
                // вызов Move with не_годится данные
                if (следщ > индекс)
                {
                        куча[индекс] = куча[следщ];
                        Move(куча[индекс], индекс);
                        fixdown(индекс);

                        // добавьed via ticket 1885 (kudos в_ wolfwood)
                        if (куча[индекс] is куча[следщ])
                            fixup(индекс);
                }
                return t;
        }

        /** Gets the значение at the top of the куча without removing it. */
        T Просмотр ()
        {
                assert (следщ > 0);
                return куча[0];
        }

        /** Returns the число of elements in this куча. */
        бцел размер ()
        {
                return следщ;
        }

        /** Reset this куча. */
        проц сотри ()
        {
                следщ = 0;
        }

        /** сбрось this куча, and use the provопрed хост for значение elements */
        проц сотри (T[] хост)
        {
                this.куча = хост;
                сотри;
        }

        /** Get the reserved ёмкость of this куча. */
        бцел ёмкость ()
        {
                return куча.length;
        }

        /** Reserve enough пространство in this куча for значение elements. The reserved пространство is truncated or extended as necessary. If the значение is less than the число of elements already in the куча, throw an исключение. */
        бцел ёмкость (бцел значение)
        {
                if (значение < следщ)
                {
                        throw new ИсклНелегальногоАргумента ("куча :: illegal truncation");
                }
                куча.length = значение;
                return значение;
        }

        /** Return a shallow копируй of this куча. */
        куча clone ()
        {
                куча другой;
                другой.куча = this.куча.dup;
                другой.следщ = this.следщ;
                return другой;
        }

        // Get the индекс of the предок for the element at the given индекс.
        private бцел предок (бцел индекс)
        {
                return (индекс - 1) / 2;
        }

        // Having just inserted, restore the куча invariant (that a node's значение is greater than its ветви)
        private проц fixup (бцел индекс)
        {
                if (индекс == 0) return;
                бцел par = предок (индекс);
                if (!Compare(куча[par], куча[индекс]))
                {
                        своп (par, индекс);
                        fixup (par);
                }
        }

        // Having just removed and replaced the top of the куча with the последний inserted element,
        // restore the куча invariant.
        private проц fixdown (бцел индекс)
        {
                бцел left = 2 * индекс + 1;
                бцел down;
                if (left >= следщ)
                {
                        return;
                }

                if (left == следщ - 1)
                {
                        down = left;
                }
                else if (Compare (куча[left], куча[left + 1]))
                {
                        down = left;
                }
                else
                {
                        down = left + 1;
                }

                if (!Compare(куча[индекс], куча[down]))
                {
                        своп (индекс, down);
                        fixdown (down);
                }
        }

        // Swap two elements in the Массив.
        private проц своп (бцел a, бцел b)
        {
                auto t1 = куча[a];
                auto t2 = куча[b];
                куча[a] = t2;
                Move(t2, a);
                куча[b] = t1;
                Move(t1, b);
        }
}


/** A minheap implementation. This will have the smallest item as the top of the куча. 
  *
  * Note: always пароль by reference when modifying a куча. 
  *
*/

template MinHeap(T)
{
        alias куча!(T, minHeapCompare) MinHeap;
}

/** A maxheap implementation. This will have the largest item as the top of the куча. 
  *
  * Note: always пароль by reference when modifying a куча. 
  *
*/

template MaxHeap(T)
{
        alias куча!(T, maxHeapCompare) MaxHeap;
}



debug (UnitTest)
{
unittest
{
        MinHeap!(бцел) h;
        assert (h.размер is 0);
        h ~= 1;
        h ~= 3;
        h ~= 2;
        h ~= 4;
        assert (h.размер is 4);

        assert (h.Просмотр is 1);
        assert (h.Просмотр is 1);
        assert (h.размер is 4);
        h.вынь;
        assert (h.Просмотр is 2);
        assert (h.размер is 3);
}

unittest
{
        MinHeap!(бцел) h;
        assert (h.размер is 0);
        h ~= 1;
        h ~= 3;
        h ~= 2;
        h ~= 4;
        assert (h.размер is 4);

        assert (h.вынь is 1);
        assert (h.размер is 3);
        assert (h.вынь is 2);
        assert (h.размер is 2);
        assert (h.вынь is 3);
        assert (h.размер is 1);
        assert (h.вынь is 4);
        assert (h.размер is 0);
}

unittest
{
        MaxHeap!(бцел) h;
        h ~= 1;
        h ~= 3;
        h ~= 2;
        h ~= 4;

        assert (h.вынь is 4);
        assert (h.вынь is 3);
        assert (h.вынь is 2);
        assert (h.вынь is 1);
}

unittest
{
        MaxHeap!(бцел) h;
        h ~= 1;
        h ~= 3;
        h ~= 2;
        h ~= 4;
        h.удали(3);
        assert (h.вынь is 4);
        assert (h.вынь is 2);
        assert (h.вынь is 1);
        assert (h.размер == 0);
}

дол[] свопped;
бцел[] indices;
проц onMove(дол a, бцел b)
{
        свопped ~= a;
        indices ~= b;
}
unittest
{
        // this tests that onMove is called with fixdown
        свопped = пусто;
        indices = пусто;
        куча!(дол, minHeapCompare, onMove) h;
        // no своп
        h ~= 1;
        // no своп
        h ~= 3;

        // onMove() is called for все insertions
        свопped = пусто;
        indices = пусто;
        // вынь: you замени the top with the последний and
        // percolate down. So you have в_ своп once when
        // popping at a minimum, and that's if you have only two
        // items in the куча.
        assert (h.вынь is 1);
        assert (свопped.length == 1, "" ~ cast(сим)('a' + свопped.length));
        assert (свопped[0] == 3);
        assert (indices[0] == 0);
        assert (h.вынь is 3);
        assert (свопped.length == 1, "" ~ cast(сим)('a' + свопped.length));
}
unittest
{
        // this tests that onMove is called with fixup
        свопped = пусто;
        indices = пусто;
        куча!(дол, minHeapCompare, onMove) h;
        // no своп
        h ~= 1;
        // no своп
        h ~= 3;
        // своп: перемести 0 в_ позиция 0, 1 в_ позиция 2
        h ~= 0;
        цел n=3; // onMove() called for insertions too
        if (свопped[n] == 0)
        {
                assert (свопped[n+1] == 1);
                assert (indices[n+0] == 0);
                assert (indices[n+1] == 2);
        }
        else
        {
                assert (свопped[n+1] == 0);
                assert (свопped[n+0] == 1);
                assert (indices[n+0] == 2);
                assert (indices[n+1] == 0);
        }
}

unittest
{
        MaxHeap!(бцел) h;
        h ~= 1;
        h ~= 3;
        h ~= 2;
        h ~= 4;
        auto другой = h.clone;

        assert (другой.вынь is 4);
        assert (другой.вынь is 3);
        assert (другой.вынь is 2);
        assert (другой.вынь is 1);
        assert (h.размер is 4, "cloned куча shares данные with original куча");
        assert (h.вынь is 4, "cloned куча shares данные with original куча");
        assert (h.вынь is 3, "cloned куча shares данные with original куча");
        assert (h.вынь is 2, "cloned куча shares данные with original куча");
        assert (h.вынь is 1, "cloned куча shares данные with original куча");
}
}
