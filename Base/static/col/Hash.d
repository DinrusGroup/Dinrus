/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.Hash;

private import col.Link;
private import col.model.Iterator;
private import col.DefaultAllocator;

struct ДефолтыХэш
{
    const плав факторЗагрузки = .75;
    const бцел размерТаблицы = 31;
}

/**
 * Default Хэш implementation.  This is используется in the Хэш* containers by
 * default.
 *
 * The implementation consists of a таблица of linked списки.  The таблица index
 * that an элемент goes in is based on the хэш код.
 */
struct Хэш(V, alias хэшФункц, alias обновлФункц, плав факторЗагрузки=ДефолтыХэш.факторЗагрузки, бцел исходнРазмерТаблицы=ДефолтыХэш.размерТаблицы, alias Разместитель=ДефолтныйРазместитель, бул допускатьДубликаты=false, бул обновить_ли=true)
{
    /**
     * alias for Узел
     */
    alias Связка!(V).Узел узел;

    /**
     * alias for the Разместитель
     */
    alias Разместитель!(Связка!(V)) разместитель;

    /**
     * The Разместитель for the хэш
     */
    разместитель разм;

    /**
     * the таблица of корзины
     */
    узел[] таблица;

    /**
     * счёт of элементы in the таблица
     */
    бцел счёт;

    /**
     * This is like a pointer, используется to point to a given элемент in the хэш.
     */
    struct позиция
    {
        Хэш *владелец;
        узел укз; alias укз ptr;
        цел инд;

        /**
         * Returns the позиция that comes after p.
         */
        позиция следщ()
        {
            позиция p = *this;
            auto таблица = владелец.таблица;

            if(p.ptr !is пусто)
            {
                if(p.ptr.следщ is таблица[p.инд])
                    //
                    // special case, at the конец of a bucket, go to the следщ
                    // bucket.
                    //
                    p.ptr = пусто;
                else
                {
                    //
                    // still in the bucket
                    //
                    p.ptr = p.ptr.следщ;
                    return p;
                }
            }

            //
            // iterated past the bucket, go to the следщ действителен bucket
            //
            while(p.инд < cast(цел)таблица.length && p.ptr is пусто)
            {
                if(++p.инд < таблица.length)
                    p.ptr = таблица[p.инд];
                else
                    p.ptr = пусто;
            }
            return p;
        }

        /**
         * Returns the позиция that comes перед p.
         */
        позиция предш()
        {
            позиция p = *this;
            auto таблица = владелец.таблица;
            if(p.ptr !is пусто)
            {
                if(p.ptr is таблица[p.инд])
                    p.ptr = пусто;
                else
                {
                    p.ptr = p.ptr.предш;
                    return p;
                }
            }

            while(p.инд > 0 && p.ptr is пусто)
                p.ptr = таблица[--p.инд];
            if(p.ptr)
                //
                // go to the конец of the new bucket
                //
                p.ptr = p.ptr.предш;
            return p;
        }
    }

    /**
     * Add a значение to the хэш.  Returns true if the значение was not present,
     * false if обх was updated.
     */
    бул добавь(V v)
    {
        if(таблица is пусто)
            перемерьПод(исходнРазмерТаблицы);

        auto h = хэшФункц(v) % таблица.length;
        узел хвост = таблица[h];
        if(хвост is пусто)
        {
            //
            // no узел yet, добавь the new узел here
            //
            хвост = таблица[h] = размести(v);
            узел.крепи(хвост, хвост);
            счёт++;
            return true;
        }
        else
        {
            static if(!допускатьДубликаты)
            {
                узел элт = findInBucket(хвост, v, хвост);
                if(элт is пусто)
                {
                    счёт++;
                    хвост.приставь(размести(v));
                    // not single элемент, need to проверь загрузи factor
                    проверьФакторЗагрузки();
                    return true;
                }
                else
                {
                    //
                    // found the узел, установи the значение instead
                    //
                    static if(обновить_ли)
                        обновлФункц(элт.значение, v);
                    return false;
                }
            }
            else
            {
                //
                // always добавь, even if the узел already exists.
                //
                счёт++;
                хвост.приставь(размести(v));
                // not single элемент, need to проверь загрузи factor
                проверьФакторЗагрузки();
                return true;
            }
        }
    }

    /**
     * Resize the хэш таблица to the given ёмкость.  Normally only called
     * privately.
     */
    проц перемерьПод(бцел ёмкость)
    {
        if(ёмкость > таблица.length)
        {
            auto новТабл = new узел[ёмкость];

            foreach(голова; таблица)
            {
                if(голова)
                {
                    //
                    // make the последн узел point to пусто, to метка the конец of
                    // the bucket
                    //
                    узел.крепи(голова.предш, пусто);
                    for(узел тек = голова, следщ = голова.следщ; тек !is пусто;
                            тек = следщ)
                    {
                        следщ = тек.следщ;
                        auto h = хэшФункц(тек.значение) % новТабл.length;
                        узел новГолова = новТабл[h];
                        if(новГолова is пусто)
                        {
                            новТабл[h] = тек;
                            узел.крепи(тек, тек);
                        }
                        else
                            новГолова.приставь(тек);
                    }
                }
            }
            delete таблица;
            таблица = новТабл;
        }
    }

    /**
     * Check to see whether the загрузи factor dictates a перемерьПод is in order.
     */
    проц проверьФакторЗагрузки()
    {
        if(таблица !is пусто)
        {
            плав fc = cast(плав) счёт;
            плав ft = таблица.length;

            if(fc / ft > факторЗагрузки)
                перемерьПод(2 * cast(бцел)(fc / факторЗагрузки) + 1);
        }
    }

    /**
     * Returns a позиция that points to the первый элемент in the хэш.
     */
    позиция начало()
    {
        if(счёт == 0)
            return конец;
        позиция рез;
        рез.ptr = пусто;
        рез.владелец = this;
        рез.инд = -1;
        //
        // this finds the первый действителен узел
        //
        return рез.следщ;
    }

    /**
     * Returns a позиция that points past the последн элемент of the хэш.
     */
    позиция конец()
    {
        позиция рез;
        рез.инд = таблица.length;
        рез.владелец = this;
        return рез;
    }

    // private function используется to implement common pieces
    private узел findInBucket(узел bucket, V v, узел начатьС)
    in
    {
        assert(bucket !is пусто);
    }
    body
    {
        if(начатьС.значение == v)
            return начатьС;
        узел n;
        for(n = начатьС.следщ; n !is bucket && n.значение != v; n = n.следщ)
        {
        }
        return (n is bucket ? пусто : n);
    }

    /**
     * Find the первый instance of a значение
     */
    позиция найди(V v)
    {
        if(счёт == 0)
            return конец;
        auto h = хэшФункц(v) % таблица.length;
        // if bucket is empty, or doesn't contain v, return конец
        узел укз;
        if(таблица[h] is пусто || (укз = findInBucket(таблица[h], v, таблица[h])) is пусто)
            return конец;
        позиция p;
        p.владелец = this;
        p.инд = h;
        p.ptr = укз;
        return p;
    }

    /**
     * Remove a given позиция from the хэш.
     */
    позиция удали(позиция поз)
    {
        позиция возврзнач = поз.следщ;
        if(поз.ptr is таблица[поз.инд])
        {
            if(поз.ptr.следщ is поз.ptr)
                таблица[поз.инд] = пусто;
            else
                таблица[поз.инд] = поз.ptr.следщ;
        }
        поз.ptr.открепи;
        static if(разместитель.нужноСвоб)
            разм.освободи(поз.ptr);
        счёт--;
        return возврзнач;
    }

    /**
     * Remove all значения from the хэш
     */
    проц очисти()
    {
        static if(разместитель.нужноСвоб)
            разм.освободиВсе();
        delete таблица;
        таблица = пусто;
        счёт = 0;
    }

    /**
     * keep only элементы that appear in поднабор
     *
     * returns the number of элементы removed
     */
    бцел накладка(Обходчик!(V) поднабор)
    {
        if(счёт == 0)
            return 0;
        //
        // старт out removing all узелs, then filter out ones that are in the
        // установи.
        //
        бцел рез = счёт;
        auto врм = new узел[таблица.length];

        foreach(ref v; поднабор)
        {
            позиция p = найди(v);
            if(p.инд != таблица.length)
            {
                //
                // found the узел in the текущ таблица, добавь обх to the new
                // таблица.
                //
                узел голова = врм[p.инд];

                //
                // need to update the таблица pointer if this is the голова узел in that ячейка
                //
                if(p.ptr is таблица[p.инд])
                {
                    if(p.ptr.следщ is p.ptr)
                        таблица[p.инд] = пусто;
                    else
                        таблица[p.инд] = p.ptr.следщ;
                }

                if(голова is пусто)
                {
                    врм[p.инд] = p.ptr.открепи;
                    узел.крепи(p.ptr, p.ptr);
                }
                else
                    голова.приставь(p.ptr.открепи);
                рез--;
            }
        }

        static if(разместитель.нужноСвоб)
        {
            //
            // now, we must освободи all the неиспользовано узелs
            //
            foreach(голова; таблица)
            {
                if(голова !is пусто)
                {
                    //
                    // since we will освободи голова, метка the конец of the list with
                    // a пусто pointer
                    //
                    узел.крепи(голова.предш, пусто);
                    while(голова !is пусто)
                    {
                        auto newhead = голова.следщ;
                        разм.освободи(голова);
                        голова = newhead;
                    }
                }
            }
        }
        таблица = врм;
        счёт -= рез;
        return рез;
    }

    static if(допускатьДубликаты)
    {
        // private function to do the dirty work of считайВсе и удалиВсе
        private бцел _applyAll(V v, бул удали)
        {
            позиция p = найди(v);
            бцел рез = 0;
            if(p.инд != таблица.length)
            {
                auto bucket = таблица[p.инд];
                do
                {
                    if(p.ptr.значение == v)
                    {
                        рез++;
                        if(удали)
                        {
                            auto исх = p.ptr;
                            p.ptr = p.ptr.следщ;
                            исх.открепи();
                            static if(разместитель.нужноСвоб)
                            {
                                разм.освободи(исх);
                            }
                            continue;
                        }
                    }

                    p.ptr = p.ptr.следщ;
                }
                while(p.ptr !is bucket)
            }
            return рез;
        }

        /**
         * счёт the number of times a given значение appears in the хэш
         */
        бцел считайВсе(V v)
        {
            return _applyAll(v, false);
        }

        /**
         * удали all the экземпляры of v that appear in the хэш
         */
        бцел удалиВсе(V v)
        {
            return _applyAll(v, true);
        }

        /**
         * Find a given значение in the хэш, starting from the given позиция.
         * If the позиция is beyond the последн instance of v (which can be
         * determined if the позиция's bucket is beyond the bucket where v
         * should go).
         */
        позиция найди(V v, позиция начатьС)
        {
            if(счёт == 0)
                return конец;
            auto h = хэшФункц(v) % таблица.length;
            if(начатьС.инд < h)
            {
                // if bucket is empty, return конец
                if(таблица[h] is пусто)
                    return конец;

                // старт from the bucket that the значение would live in
                начатьС.инд = h;
                начатьС.ptr = таблица[h];
            }
            else if(начатьС.инд > h)
                // beyond the bucket, return конец
                return конец;

            if((начатьС.ptr = findInBucket(таблица[h], v, начатьС.ptr)) !is
                    пусто)
                return начатьС;
            return конец;
        }
    }

    /**
     * копируй all the элементы from this хэш to цель.
     */
    проц копируйВ(ref Хэш цель)
    {
        //
        // копируй all local значения
        //
        цель = *this;

        //
        // reset разместитель
        //
        цель.разм = цель.разм.init;

        //
        // reallocate all the узелs in the таблица
        //
        цель.таблица = new узел[таблица.length];
        foreach(i, n; таблица)
        {
            if(n !is пусто)
                цель.таблица[i] = n.dup(&цель.размести);
        }
    }

    узел размести()
    {
        return разм.размести();
    }

    узел размести(V v)
    {
        auto рез = размести();
        рез.значение = v;
        return рез;
    }

    /**
     * Perform any установка necessary (none for this хэш impl)
     */
    проц установка()
    {
    }
}

/**
 * используется to define a Хэш that does not perform updates
 */
template ХэшБезОбновлений(V, alias хэшФункц, плав факторЗагрузки=ДефолтыХэш.факторЗагрузки, бцел исходнРазмерТаблицы=ДефолтыХэш.размерТаблицы, alias Разместитель=ДефолтныйРазместитель)
{
    // note the второй хэшФункц isn't используется because обновлять_ли is false
    alias Хэш!(V, хэшФункц, хэшФункц, факторЗагрузки, исходнРазмерТаблицы, Разместитель, false, false) ХэшБезОбновлений;
}

/**
 * используется to define a Хэш that takes duplicates
 */
template ХэшДуб(V, alias хэшФункц, плав факторЗагрузки=ДефолтыХэш.факторЗагрузки, бцел исходнРазмерТаблицы=ДефолтыХэш.размерТаблицы, alias Разместитель=ДефолтныйРазместитель)
{
    // note the второй хэшФункц isn't используется because обновлять_ли is false
    alias Хэш!(V, хэшФункц, хэшФункц, факторЗагрузки, исходнРазмерТаблицы, Разместитель, true, false) ХэшДуб;
}
