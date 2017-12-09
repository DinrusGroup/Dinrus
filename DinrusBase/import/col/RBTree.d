/*********************************************************
   Авторское право: (C) 2008 принадлежит Steven Schveighoffer.
              Все права защищены

   Лицензия: $(LICENSE)

**********************************************************/
module col.RBTree;

private import col.model.Iterator;
private import col.DefaultAllocator;

/+ ИНТЕРФЕЙС:


struct КЧУзел(З)
{

    alias КЧУзел!(З)* Узел;
    З значение;

    enum Цвет : байт
    {
        Красный,
        Чёрный
    }

    Узел лево();
    Узел право();
    Узел родитель();
    Узел лево(Узел новУзел);
    Узел право(Узел новУзел);
    Узел вращайП();
    Узел вращайЛ();
    бул левый_лиУзел();
    проц установиЦвет(Узел конец);
    Узел удали(Узел конец);
    Узел самый_левый();
    Узел самый_правый();
    Узел следщ();
    Узел предш();
    Узел dup(Узел delegate(З з) разм);
    Узел dup();
}

struct КЧДерево(З, alias функСравнить, alias обновлФункц, alias Разместитель=ДефолтныйРазместитель, бул допускатьДубликаты=нет, бул обновлять_ли=да)
{

    alias КЧУзел!(З).Узел Узел;
    alias Разместитель!(КЧУзел!(З)) разместитель;
    разместитель разм;
    бцел счёт;
    Узел конец;

    проц установка();
    бул добавь(З з);
    Узел начало();
    Узел удали(Узел z);
    Узел найди(З з);
    проц очисти();

    version(КЧПроверять)
    {

        проц выведиДерево(Узел n, цел отступ = 0);
        проц проверь();
    }
    
    бцел накладка(Обходчик!(З) поднабор);
    проц копируйВ(ref КЧДерево цель);
    Узел размести();
    Узел размести(З з);
}


template КЧДеревоБезОбнова(З, alias функСравнить, alias Разместитель=ДефолтныйРазместитель)
{
    alias КЧДерево!(З, функСравнить, функСравнить, Разместитель, нет, нет) КЧДеревоБезОбнова;
}

template КЧДеревоДуб(З, alias функСравнить, alias Разместитель=ДефолтныйРазместитель)
{
    alias КЧДерево!(З, функСравнить, функСравнить, Разместитель, да, нет) КЧДеревоДуб;
}

+/

/**
 * Реализация Красно-Чёрного Узла для использования в Красно-Чёрном Дереве (см. ниже)
 *
 * Реализация предполагает наличие Узла-маркера, - родителя корневого Узла.
 * Этот Узел-маркер не есть действительный Узел, а метка конца коллекции.
 * Корень - это левый отпрыск Узла-маркера, поэтому обх всегда является последним
 * в коллекции. Узлу-маркеру передаётся функция установиЦвет,
 * а также Узел, для которого он является родителем, который принимается за
 * корневой Узел.
 *
 * Дерево Красный -Чёрный должно иметь время O(lg(n)) на вставку, удаление и поиск.
 */
struct КЧУзел(З)
{
    /**
     * Алиас для удобства
     */
    alias КЧУзел!(З)* Узел;

    private Узел _лево;
    private Узел _право;
    private Узел _родитель;

    /**
     * Значение, заданное this Узлу
     */
    З значение;

    /**
     * Перечень с определениями цвета Узла.  Предполагаются узлы пусто
     * в качестве чёрных.
     */
    enum Цвет : байт
    {
        Красный,
        Чёрный
    }

    /**
     * Цвет Узла.
     */
    Цвет цвет;

    /**
     * Получить левый отпрыск
     */
    Узел лево()
    {
        return _лево;
    }

    /**
     * Получить правый отпрыск
     */
    Узел право()
    {
        return _право;
    }

    /**
     * Получить родителя
     */
    Узел родитель()
    {
        return _родитель;
    }

    /**
     * Установить левый отпрыск  Также обновляет родительский узел нового отпрыска.  Эта
     * не обновляет предыдущий отпрыск.
     *
     * Возвращает новУзел
     */
    Узел лево(Узел новУзел)
    {
        _лево = новУзел;
        if(новУзел !is пусто)
            новУзел._родитель = this;
        return новУзел;
    }

    /**
     * Установить правый отпрыск.  Также обновляет родительский узел нового отпрыска.  Эта
     * не обновляет предыдущий отпрыск.
     *
     * Возвращает новУзел
     */
    Узел право(Узел новУзел)
    {
        _право = новУзел;
        if(новУзел !is пусто)
            новУзел._родитель = this;
        return новУзел;
    }

    //предполагается, что _лево не пусто
    //
    // выполняет операцию вращения вправо,где this is Т, _право is R, _лево is
    // L, _родитель is P:
    //
    //      P         P
    //      |   ->    |
    //      Т         L
    //     / \       / \
    //    L   R     a   Т
    //   / \           / \ 
    //  a   b         b   R 
    //
    /**
     * Вращать вправо.  Это выполняет следующие операции:
     *  - Левая ветвь (отпрыск) становится родителем этого узла this Узел.
     *  - This Узел становится правый ветвью нового родителя (т.е. правым отпрыском).
     *  - Старый правый отпрыск нового родителя становится левой ветвью this
     *    Узел.
     */
    Узел вращайП()
    in
    {
        assert(_лево !is пусто);
    }
    body
    {
        // также установим _лево._родитель
        if(левый_лиУзел)
            родитель.лево = _лево;
        else
            родитель.право = _лево;
        Узел врм = _лево._право;

        // также установим _родитель
        _лево.право = this;

        // также установим врм._родитель
        лево = врм;

        return this;
    }

    // подразумевается, что _право не есть пусто
    //
    //выполняет операцию вращения влево, где this is Т, _право is R, _лево is
    // L, _родитель is P:
    //
    //      P           P
    //      |    ->     |
    //      Т           R
    //     / \         / \
    //    L   R       Т   b
    //       / \     / \ 
    //      a   b   L   a 
    //
    /**
     * Вращать влево.  Это выполняет следующие операции:
     *  - *  - Правая ветвь (отпрыск) становится родителем этого узла this Узел.
     *  - *  - This Узел становится левой ветвью нового родителя (т.е. левым отпрыском).
     *  - *  - Старый левый отпрыск нового родителя становится правой ветвью this
     *    Узел.
     */
    Узел вращайЛ()
    in
    {
        assert(_право !is пусто);
    }
    body
    {
        // также устанавливаем _право._родитель
        if(левый_лиУзел)
            родитель.лево = _право;
        else
            родитель.право = _право;
        Узел врм = _право._лево;

        // также установим _родитель
        _право.лево = this;

        // также установим врм._родитель
        право = врм;
        return this;
    }


    /**
     * Возвращает да if this Узел is левый отпрыск.
     *
     * Прим.:  это должно всегда возвращать значение, т.к. у корня есть
     * родитель, являющийся узлом-маркером.
     */
    бул левый_лиУзел()
    in
    {
        assert(_родитель !is пусто);
    }
    body
    {
        return _родитель._лево is this;
    }

    /**
     * Установить цвет Узла после вставки итератора.  Это выполняет
     * обновление всего дерева, по возможности вращая узлы, чтобы свойства Красный-Чёрный
     * сохранились корректно.  Это операция O(lg(n)), где n есть
     * число узлов в дереве.
     */
    проц установиЦвет(Узел конец)
    {
        //тест осносительно узла-маркера
        if(_родитель !is конец)
        {
            if(_родитель.цвет == Цвет.Красный)
            {
                Узел тек = this;
                while(да)
                {
                    // тк корень всегда чёрный, _родитель._родитель всегда существует
                    if(тек._родитель.левый_лиУзел)
                    {
                        // родитель это левый узел, y это 'дядя', м.б. пусто
                        Узел y = тек._родитель._родитель._право;
                        if(y !is пусто && y.цвет == Цвет.Красный)
                        {
                            тек._родитель.цвет = Цвет.Чёрный;
                            y.цвет = Цвет.Чёрный;
                            тек = тек._родитель._родитель;
                            if(тек._родитель is конец)
                            {
                                // корневой Узел
                                тек.цвет = Цвет.Чёрный;
                                break;
                            }
                            else
                            {
                                // некорневой Узел
                                тек.цвет = Цвет.Красный;
                                if(тек._родитель.цвет == Цвет.Чёрный)
                                    // удовлетворяет, выход из цикла
                                    break;
                            }
                        }
                        else
                        {
                            if(!тек.левый_лиУзел)
                                тек = тек._родитель.вращайЛ();
                            тек._родитель.цвет = Цвет.Чёрный;
                            тек = тек._родитель._родитель.вращайП();
                            тек.цвет = Цвет.Красный;
                            //дерево д.б. удовлетворяться теперь
                            break;
                        }
                    }
                    else
                    {
                        // родитель is правый Узел, y это 'дядя'
                        Узел y = тек._родитель._родитель._лево;
                        if(y !is пусто && y.цвет == Цвет.Красный)
                        {
                            тек._родитель.цвет = Цвет.Чёрный;
                            y.цвет = Цвет.Чёрный;
                            тек = тек._родитель._родитель;
                            if(тек._родитель is конец)
                            {
                                // корневой Узел
                                тек.цвет = Цвет.Чёрный;
                                break;
                            }
                            else
                            {
                                // некорневой Узел
                                тек.цвет = Цвет.Красный;
                                if(тек._родитель.цвет == Цвет.Чёрный)
                                    // удовлетворяет, выход из цикла
                                    break;
                            }
                        }
                        else
                        {
                            if(тек.левый_лиУзел)
                                тек = тек._родитель.вращайП();
                            тек._родитель.цвет = Цвет.Чёрный;
                            тек = тек._родитель._родитель.вращайЛ();
                            тек.цвет = Цвет.Красный;
                            //дерево д.б. удовлетворяться теперь
                            break;
                        }
                    }
                }

            }
        }
        else
        {
            //
            //это корневой Узел, цвет обх чёрный
            //
            цвет = Цвет.Чёрный;
        }
    }

    /**
     * Удалить узел this из дерева.   'Конечный' Узел используется как маркер
     * который является родителем корня.  Прим.: не м.б. пусто!
     *
     * Возвращает следщ наивысше оценённый Узе в дереве, следущий за этим, или конец
     * если это был высоко-ценный Узел.
     */
    Узел удали(Узел конец)
    {
        //
        // удалить this Узел из дерева, исправив при необходимости цвет.
        //
        Узел x;
        Узел возвр;
        if(_лево is пусто || _право is пусто)
        {
            возвр = следщ;
        }
        else
        {
            //
            //Как правило, можно просто поменять значения this Узла и y'ка, но
            // так как итератор мог бы указывать на y и нет необходимости
            // тревожить обх, вместо этого меняем местами структуру this Узел и y'ка.  Эта
            // может быть также полебным, если значение дерева - это большая
            // структура, на копирование которой уходит много времени.
            //
            Узел yp, yl, yr;
            Узел y = следщ;
            yp = y._родитель;
            yl = y._лево;
            yr = y._право;
            auto yc = y.цвет;
            auto isyleft = y.левый_лиУзел;

            //
            // заменить структуру y'ка на структуру this Узла.
            //
            if(левый_лиУзел)
                _родитель.лево = y;
            else
                _родитель.право = y;
            //
            //нужен особый случай, т.к.  игрек не указывает себе в тыл
            //
            y.лево = _лево;
            if(_право is y)
                y.право = this;
            else
                y.право = _право;
            y.цвет = цвет;

            //
            //заменить структуру this Узел на структуру y.
            //
            лево = yl;
            право = yr;
            if(_родитель !is y)
            {
                if(isyleft)
                    yp.лево = this;
                else
                    yp.право = this;
            }
            цвет = yc;

            //
            // установить возвратное значение
            //
            возвр = y;
        }

        // если у this меньше двух отпрысков, удалить обх
        if(_лево !is пусто)
            x = _лево;
        else
            x = _право;

        // удалить this из дерева по завершению процедуры
        бул удалить_лиЭтот = нет;
        if(x is пусто)
        {
            // допустим, это пустой (null)  Узел, удалить его по окончанию
            x = this;
            удалить_лиЭтот = да;
        }
        else if(левый_лиУзел)
            _родитель.лево = x;
        else
            _родитель.право = x;

        // если его цвет чёрный, то нужно налаживать обходчик
        if(цвет == цвет.Чёрный)
        {
            // требуется перекрасить дерево.
            while(x._родитель !is конец && x.цвет == Узел.Цвет.Чёрный)
            {
                if(x.левый_лиУзел)
                {
                    // левый Узел
                    Узел w = x._родитель._право;
                    if(w.цвет == Узел.Цвет.Красный)
                    {
                        w.цвет = Узел.Цвет.Чёрный;
                        x._родитель.цвет = Узел.Цвет.Красный;
                        x._родитель.вращайЛ();
                        w = x._родитель._право;
                    }
                    Узел wl = w.лево;
                    Узел wr = w.право;
                    if((wl is пусто || wl.цвет == Узел.Цвет.Чёрный) &&
                            (wr is пусто || wr.цвет == Узел.Цвет.Чёрный))
                    {
                        w.цвет = Узел.Цвет.Красный;
                        x = x._родитель;
                    }
                    else
                    {
                        if(wr is пусто || wr.цвет == Узел.Цвет.Чёрный)
                        {
                            // wl не может быть пусто
                            wl.цвет = Узел.Цвет.Чёрный;
                            w.цвет = Узел.Цвет.Красный;
                            w.вращайП();
                            w = x._родитель._право;
                        }

                        w.цвет = x._родитель.цвет;
                        x._родитель.цвет = Узел.Цвет.Чёрный;
                        w._право.цвет = Узел.Цвет.Чёрный;
                        x._родитель.вращайЛ();
                        x = конец.лево; // x = root
                    }
                }
                else
                {
                    // право Узел
                    Узел w = x._родитель._лево;
                    if(w.цвет == Узел.Цвет.Красный)
                    {
                        w.цвет = Узел.Цвет.Чёрный;
                        x._родитель.цвет = Узел.Цвет.Красный;
                        x._родитель.вращайП();
                        w = x._родитель._лево;
                    }
                    Узел wl = w.лево;
                    Узел wr = w.право;
                    if((wl is пусто || wl.цвет == Узел.Цвет.Чёрный) &&
                            (wr is пусто || wr.цвет == Узел.Цвет.Чёрный))
                    {
                        w.цвет = Узел.Цвет.Красный;
                        x = x._родитель;
                    }
                    else
                    {
                        if(wl is пусто || wl.цвет == Узел.Цвет.Чёрный)
                        {
                            // wr не может быть пусто
                            .цвет = Узел.Цвет.Чёрный;
                            w.цвет = Узел.Цвет.Красный;
                            w.вращайЛ();
                            w = x._родитель._лево;
                        }

                        w.цвет = x._родитель.цвет;
                        x._родитель.цвет = Узел.Цвет.Чёрный;
                        w._лево.цвет = Узел.Цвет.Чёрный;
                        x._родитель.вращайП();
                        x = конец.лево; // x = root
                    }
                }
            }
            x.цвет = Узел.Цвет.Чёрный;
        }

        if(удалить_лиЭтот)
        {
            //
            // очистить this Узел от дерева
            //
            if(левый_лиУзел)
                _родитель.лево = пусто;
            else
                _родитель.право = пусто;
        }

        return возвр;
    }

    /**
     * возвращает самый_левый потомок  this Узла.
     */
    Узел самый_левый()
    {
        Узел рез = this;
        while(рез._лево !is пусто)
            рез = рез._лево;
        return рез;
    }

    /**
     * Возвращает самый_правый потомок this Узел
     */
    Узел самый_правый()
    {
        Узел рез = this;
        while(рез._право !is пусто)
            рез = рез._право;
        return рез;
    }

    /**
     * Возвращает the следщ valued Узел in the tree.
     *
     * You should never call this on the marker Узел, as обх is assumed that
     * there is a valid следщ Узел.
     */
    Узел следщ()
    {
        Узел n = this;
        if(n.право is null)
        {
            while(!n.левый_лиУзел)
                n = n._родитель;
            return n._родитель;
        }
        else
            return n.право.самый_левый;
    }

    /**
     * Returns the previous valued Узел in the tree.
     *
     * You should never call this on the самый_левый Узел of the tree as обх is
     * assumed that there is a valid previous Узел.
     */
    Узел предш()
    {
        Узел n = this;
        if(n.лево is null)
        {
            while(n.левый_лиУзел)
                n = n._родитель;
            return n._родитель;
        }
        else
            return n.лево.самый_правый;
    }

    Узел dup(Узел delegate(З з) разм)
    {
        //
        // duplicate this and all child nodes
        //
        // The recursion should be lg(n), so we shouldn'т have to worry about
        // stack size.
        //
        Узел copy = разм(значение);
        copy.цвет = цвет;
        if(_лево !is пусто)
            copy.лево = _лево.dup(разм);
        if(_право !is null)
            copy.право = _право.dup(разм);
        return copy;
    }

    Узел dup()
    {
        Узел _дг(З з)
        {
            auto рез = new КЧУзел!(З);
            рез.значение = з;
            return рез;
        }
        return dup(&_дг);
    }
}

/**
 * Implementation of a red black tree.
 *
 * This uses КЧУзел to implement the tree.
 *
 * Набор допускатьДубликаты to да to allow duplicate values to be inserted.
 */
struct КЧДерево(З, alias функСравнить, alias обновлФункц, alias Разместитель=ДефолтныйРазместитель, бул допускатьДубликаты=нет, бул обновлять_ли=да)
{
    /**
     * Алиас для удобства
     */
    alias КЧУзел!(З).Узел Узел;

    /**
     * alias for the Разместитель
     */
    alias Разместитель!(КЧУзел!(З)) разместитель;

    /**
     * The разместитель
     */
    разместитель разм;

    /**
     * The number of nodes in the tree
     */
    бцел счёт;

    /**
     * The marker Узел.  This is the родитель of the root Узел.
     */
    Узел конец;

    /**
     * Setup this КЧДерево.
     */
    проц установка()
    {
        конец = размести();
    }

    /**
     * Add a Узел to the КЧДерево.  Runs in O(lg(n)) time.
     *
     * Returns да if a new Узел was добавленный, нет if обх was not.
     *
     * This can also be используется to update a значение if обх is already in the tree.
     */
    бул добавь(З з)
    {
        Узел добавленный;
        if(конец.лево is null)
            конец.лево = добавленный = размести(з);
        else
        {
            Узел новРодитель = конец.лево;
            while(да)
            {
                цел значсравн = функСравнить(новРодитель.значение, з);
                if(значсравн == 0)
                {
                    //
                    // found the значение already in the tree.  If duplicates are
                    // allowed, pretend the new значение is greater than this значение.
                    //
                    static if(допускатьДубликаты)
                    {
                        значсравн = -1;
                    }
                    else
                    {
                        static if(обновлять_ли)
                            обновлФункц(новРодитель.значение, з);
                        return нет;
                    }
                }
                if(значсравн < 0)
                {
                    Узел nxt = новРодитель.право;
                    if(nxt is null)
                    {
                        //
                        // добавь to право of new родитель
                        //
                        новРодитель.право = добавленный = размести(з);
                        break;
                    }
                    else
                        новРодитель = nxt;
                }
                else
                {
                    Узел nxt = новРодитель.лево;
                    if(nxt is null)
                    {
                        //
                        // добавь to лево of new родитель
                        //
                        новРодитель.лево = добавленный = размести(з);
                        break;
                    }
                    else
                        новРодитель = nxt;
                }
            }
        }

        //
        // update the tree colors
        //
        добавленный.установиЦвет(конец);

        //
        // did добавь a Узел
        //
        счёт++;
        version(КЧПроверять)
            проверь();
        return да;
    }

    /**
     * Return the lowest-valued Узел in the tree
     */
    Узел начало()
    {
        return конец.самый_левый;
    }

    /**
     * Remove the Узел from the tree.  Returns the следщ Узел in the tree.
     *
     * Do not call this with the marker (конец) Узел.
     */
    Узел удали(Узел z)
    in
    {
        assert(z !is конец);
    }
    body
    {
        счёт--;
        //выведиДерево(конец.лево);
        Узел рез = z.удали(конец);
        static if(разместитель.нужноСвоб)
            разм.освободи(z);
        //выведиДерево(конец.лево);
        version(КЧПроверять)
            проверь();
        return рез;
    }

    /**
     * Find a Узел in the tree with a given значение.  Returns конец if no such
     * Узел exists.
     */
    Узел найди(З з)
    {
        static if(допускатьДубликаты)
        {
            //
            // найди the лево-most з, this allows the pointer to traverse
            // through all the з's.
            //
            Узел тек = конец;
            Узел n = конец.лево;
            while(n !is null)
            {
                цел резсравн = функСравнить(n.значение, з);
                if(резсравн < 0)
                {
                    n = n.право;
                }
                else
                {
                    if(резсравн == 0)
                        тек = n;
                    n = n.лево;
                }
            }
            return тек;
        }
        else
        {
            Узел n = конец.лево;
            цел резсравн;
            while(n !is null && (резсравн = функСравнить(n.значение, з)) != 0)
            {
                if(резсравн < 0)
                    n = n.право;
                else
                    n = n.лево;
            }
            if(n is null)
                return конец;
            return n;
        }
    }

    /**
     * очисти all the nodes from the tree.
     */
    проц очисти()
    {
        static if(разместитель.нужноСвоб)
        {
            разм.освободиВсе();
            конец = размести();
        }
        else
            конец.лево = null;
        счёт = 0;
    }

    version(КЧПроверять)
    {
        /**
         * Print the tree.  This prints a sideways view of the tree in ASCII form,
         * with the number of indentations representing the level of the nodes.
         * It does not print values, only the tree structure and цвет of nodes.
         */
        проц выведиДерево(Узел n, цел отступ = 0)
        {
            if(n !is пусто)
            {
                выведиДерево(n.право, отступ + 2);
                for(цел i = 0; i < отступ; i++)
                    _скажи(".");
                _скажинс(n.цвет == n.цвет.Чёрный ? "Ч" : "К");
                выведиДерево(n.лево, отступ + 2);
            }
            else
            {
                for(цел i = 0; i < отступ; i++)
                    _скажи(".");
                _скажинс("N");
            }
            if(отступ is 0)
                _нс();
        }

        /**
         * Check the tree for validity.  This is called after every добавь or удали.
         * This should only be enabled to debug the implementation of the RB Tree.
         */
        проц проверь()
        {
            //
            // проверь implementation of the tree
            //
            цел recurse(Узел n, char[] путь)
            {
                if(n is null)
                    return 1;
                if(n.родитель.лево !is n && n.родитель.право !is n)
                    throw new Искл("Узел на пути " ~ путь ~ " имеет неконсистентные указатели");
                Узел следщ = n.следщ;
                static if(допускатьДубликаты)
                {
                    if(следщ !is конец && функСравнить(n.значение, следщ.значение) > 0)
                        throw new Искл("неверный порядок на пути " ~ путь);
                }
                else
                {
                    if(следщ !is конец && функСравнить(n.значение, следщ.значение) >= 0)
                        throw new Искл("неверный порядок на пути " ~ путь);
                }
                if(n.цвет == n.цвет.Красный)
                {
                    if((n.лево !is null && n.лево.цвет == n.цвет.Красный) ||
                            (n.право !is null && n.право.цвет == n.цвет.Красный))
                        throw new Искл("Узел на пути " ~ путь ~ " красный с красным отпрыском");
                }

                цел l = recurse(n.лево, путь ~ "Л");
                цел r = recurse(n.право, путь ~ "П");
                if(l != r)
                {
                    _скажнс("Ошибочное дерево на:");
                    выведиДерево(n);
                    throw new Искл("Узел на пути " ~ путь ~ "имеет разное число чёрных узлов по левой и правой тропе");
                }
                return l + (n.цвет == n.цвет.Чёрный ? 1 : 0);
            }

            try
            {
                recurse(конец.лево, "");
            }
            catch(Искл e)
            {
                выведиДерево(конец.лево, 0);
                throw e;
            }
        }
    }

    static if(допускатьДубликаты)
    {
        /**
         * счёт all the times з appears in the collection.
         *
         * Runs in O(m * lg(n)) where m is the number of з экземпляры in the
         * collection, and n is the счёт of the collection.
         */
        бцел считайВсе(З з)
        {
            Узел n = найди(з);
            бцел возврзнач = 0;
            while(n !is конец && функСравнить(n.значение, з) == 0)
            {
                возврзнач++;
                n = n.следщ;
            }
            return возврзнач;
        }

        /**
         * удали all the nodes that match з
         *
         * Runs in O(m * lg(n)) where m is the number of з экземпляры in the
         * collection, and n is the счёт of the collection.
         */
        бцел удалиВсе(З з)
        {
            Узел n = найди(з);
            бцел возврзнач = 0;
            while(n !is конец && функСравнить(n.значение, з) == 0)
            {
                n = удали(n);
                возврзнач++;
            }
            return возврзнач;
        }
    }

    
    бцел накладка(Обходчик!(З) поднабор)
    {
        // build a new КЧДерево, only inserting nodes that we already have.
        КЧУзел!(З) новконец;
        auto исхсчёт = счёт;
        счёт = 0;
        foreach(з; поднабор)
        {
            //
            // найди if the Узел is in the current tree
            //
            auto z = найди(з);
            if(z !is конец)
            {
                //
                // удали the элемент from the tree, but don'т worry about satisfing
                // the Красный-black rules.  we don'т care because this tree is
                // going away.
                //
                if(z.лево is null)
                {
                    //
                    // no лево Узел, so this is a single parentage line,
                    // move the право Узел to be where we are
                    //
                    if(z.левый_лиУзел)
                        z.родитель.лево = z.право;
                    else
                        z.родитель.право = z.право;
                }
                else if(z.право is null)
                {
                    //
                    // no право Узел, single parentage line.
                    //
                    if(z.левый_лиУзел)
                        z.родитель.лево = z.лево;
                    else
                        z.родитель.право = z.лево;
                }
                else
                {
                    //
                    // z has both лево and право nodes, swap обх with the следщ
                    // Узел.  Next Узел's лево is guaranteed to be null
                    // because обх must be a право child of z, and if обх had a
                    // лево Узел, then обх would not be the следщ Узел.
                    //
                    Узел n = z.следщ;
                    if(n.родитель !is z)
                    {
                        //
                        // n is a descendant of z, but not the immediate
                        // child, we need to link n's родитель to n's право
                        // child.  Note that n must be a лево child or else
                        // n's родитель would have been the следщ Узел.
                        //
                        n.родитель.лево = n.право;
                        n.право = z.право;
                    }
                    // else, n is the direct child of z, which means there is
                    // no need to update n's родитель, or n's право Узел (as n
                    // is the право Узел of z).

                    if(z.левый_лиУзел)
                        z.родитель.лево = n;
                    else
                        z.родитель.право = n;
                    n.лево = z.лево;
                }
                //
                // reinitialize z
                //
                z.цвет = z.цвет.init;
                z.лево = z.право = null;

                //
                // put обх into the new tree.
                //
                if(новконец.лево is null)
                    новконец.лево = z;
                else
                {
                    //
                    // got to найди the право place for z
                    //
                    Узел новРодитель = новконец.лево;
                    while(да)
                    {
                        auto значсравн = функСравнить(новРодитель.значение, z.значение);

                        // <= handles all cases, including when
                        // допускатьДубликаты is да.
                        if(значсравн <= 0)
                        {
                            Узел nxt = новРодитель.право;
                            if(nxt is null)
                            {
                                новРодитель.право = z;
                                break;
                            }
                            else
                                новРодитель = nxt;
                        }
                        else
                        {
                            Узел nxt = новРодитель.лево;
                            if(nxt is null)
                            {
                                новРодитель.лево = z;
                                break;
                            }
                            else
                                новРодитель = nxt;
                        }
                    }
                }

                z.установиЦвет(&новконец);
                счёт++;
            }
        }
        static if(разместитель.нужноСвоб)
        {
            //
            // need to освободи all the nodes we are no longer using
            //
            освободиУзел(конец.лево);
        }
        //
        // replace новконец with конец.  If we don'т do this, cursors pointing
        // to конец will be invalidated.
        //
        конец.лево = новконец.лево;
        return исхсчёт - счёт;
    }

    static if(разместитель.нужноСвоб)
    {
        private проц освободиУзел(Узел n)
        {
            if(n !is пусто)
            {
                освободиУзел(n.лево);
                освободиУзел(n.право);
                разм.освободи(n);
            }
        }
    }

    проц копируйВ(ref КЧДерево цель)
    {
        цель = *this;

        // make shallow copy of RBNodes
        цель.конец = конец.dup(&цель.размести);
    }

    Узел размести()
    {
        return разм.размести();
    }

    Узел размести(З з)
    {
        auto рез = размести();
        рез.значение = з;
        return рез;
    }
}

/**
 * используется to define a RB tree that does not require updates.
 */
template КЧДеревоБезОбнова(З, alias функСравнить, alias Разместитель=ДефолтныйРазместитель)
{
    alias КЧДерево!(З, функСравнить, функСравнить, Разместитель, нет, нет) КЧДеревоБезОбнова;
}
/**
 * используется to define a RB tree that takes duplicates
 */
template КЧДеревоДуб(З, alias функСравнить, alias Разместитель=ДефолтныйРазместитель)
{
    alias КЧДерево!(З, функСравнить, функСравнить, Разместитель, да, нет) КЧДеревоДуб;
}
