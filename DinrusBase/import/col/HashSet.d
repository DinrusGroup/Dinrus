/*********************************************************
   Авторское право: (C) 2008 принадлежит Steven Schveighoffer.
              Все права защищены

   Лицензия: $(LICENSE)

**********************************************************/
module col.HashSet;

public import col.model.Set;
public import col.Functions;
private import col.Hash;

/+ ИНТЕРФЕЙС:

class ХэшНабор(З, alias ШаблРеализац=ХэшБезОбновлений, alias хэшФункц=ДефХэш) : Набор!(З)
{

    alias ШаблРеализац!(З, хэшФункц) Реализ;

    struct курсор
    {
        З значение();
        курсор opPostInc();
        курсор opPostDec();
        курсор opAddAssign(цел прир);
        курсор opSubAssign(цел прир);
        бул opEquals(курсор обх);
    }


    final цел очистить(цел delegate(ref бул чистить_ли, ref З з) дг);
    цел opApply(цел delegate(ref З з) дг);
    this();
    private this(ref Реализ дубИз);
    ХэшНабор очисти();
    бцел длина();
	alias длина length;
    курсор начало();
    курсор конец();
    курсор удали(курсор обх);
    курсор найди(З з);
    бул содержит(З з);
    ХэшНабор удали(З з);
    ХэшНабор удали(З з, ref бул был_Удалён);
    ХэшНабор удали(Обходчик!(З) обх);
    ХэшНабор удали(Обходчик!(З) обх, ref бцел чло_Удалённых);
    ХэшНабор добавь(З з);
    ХэшНабор добавь(З з, ref бул был_добавлен);
    ХэшНабор добавь(Обходчик!(З) обх);
    ХэшНабор добавь(Обходчик!(З) обх, ref бцел чло_добавленных);
    ХэшНабор добавь(З[] массив);
    ХэшНабор добавь(З[] массив, ref бцел чло_добавленных);
    ХэшНабор накладка(Обходчик!(З) поднабор);
    ХэшНабор накладка(Обходчик!(З) поднабор, ref бцел чло_Удалённых);
    ХэшНабор dup();
    цел opEquals(Объект o);
    З дай();
    З изыми();
}

+/

/**
 * Реализация набора, которая использует Хэш, чтобы иметь около O(1) вставок,
 * при удалении и поиске.
 *
 * Добавление элемента может сделать невалидными курсоры, зависимые от реализации.
 *
 *Удаление элемента повреждает только курсоры, которые указывали на этот
 * элемент.
 *
 * Можно заменить реализацию Хэша адаптированной реализацией,
 * Хэш должен быть шаблоном структуры, который инстанциируется единственным аргументом
 * шаблона З, и должен реализовывать следующие члены (члены-нефункции
 * могут быть свойствами, если не указано иное):
 *
 *
 * параметры -> должны быть структорой как минимум со следущими членами
 *   хэшФункц -> используемая хэш-функция (должна быть какой-л. ХэшФунк!(З))
 *   обновлФункц -> используемая функция обновления (должна быть вроде
 *                     ФункцОбновления!(З))
 * 
 * проц установка(параметры p) -> инициализирует хэш с указанными параметрами.
 *
 * бцел счёт -> счёт элементов в хэше
 *
 * позиция -> должна быть структурой со следующим членом:
 *   укз -> должно определять следующий член:
 *     З значение -> значение, на которое указывает данная позиция (не может являться
 *  каким-либо свойством)
 *   позиция следщ -> должно быть следующим значениес в хэше
 *   позиция предш -> должно быть предшествующим значением в хэше
 *
 * бул добавь(З з) -> добавить данное значение в хэш.  * Хэш этого значения
 * будет задан хэшФункц(з).  Если значение уже есть в хэше,
 *это вызовет обновлФункц(з) и не должно увеличивать счётчик.
 *
 * позиция начало -> должна быть позицией, которая указывает на самый первый целостный
 * элемент в хэше, или на конце, если нет никаких элементов.
 *
 * позиция конец -> должна быть позицией, которая указывает сразу после самого последнего
 *валидного элемента.
 *
 * позиция найди(З з) ->возвращает позицию, которая указывает на элемент, который
 * содержит з, или на конец , если его не существует.
 *
 * позиция удали(позиция p) -> удаляет данный элемент из хэша,
 *возвращает следующий валидный элемент или конец, если p был последним в хэше.
 *
 * проц очисти() -> удаляет все элементы из хэша, устанавливает счётчик на 0.
 */
class ХэшНабор(З, alias ШаблРеализац=ХэшБезОбновлений, alias хэшФункц=ДефХэш) : Набор!(З)
{
    /**
     * алиас инстанциации шаблона.
     */
    alias ШаблРеализац!(З, хэшФункц) Реализ;

    private Реализ _хэш;

    /**
     * Курсор для данного хэш-набора.
     */
    struct курсор
    {
        private Реализ.позиция позиция;

        /**
         * даёт значение в данной позиции
         */
        З значение()
        {
            return позиция.ptr.значение;
        }

        /**
         * Увеличивает этот курсор, возвращая то значение, которое было до
         * этого.
         */
        курсор opPostInc()
        {
            курсор врм = *this;
            позиция = позиция.следщ;
            return врм;
        }

        /**
         * Уменьшает этот курсор, возращая значение, которое было до
         * декрементации.
         */
        курсор opPostDec()
        {
            курсор врм = *this;
            позиция = позиция.предш;
            return врм;
        }

        /**
         * Увеличивает курсор на указанное количество.
         *
         * Это операция O(прир)!  * Следует лишь использовать этот оператор в 
         * такой форме:
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
         * Уменьшает курсор на заданное значение.
         *
         * Это операция O(прир)!  * Следует лишь использовать этот оператор в 
         * такой форме:
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
         * Сравнивает два курсора на равенство
         */
        бул opEquals(курсор обх)
        {
            return обх.позиция == позиция;
        }
    }

    /**
     * итерирует по элементам набора, определяет, которые из них удалить.
     *
     * Используйте таким образом:
     *
     * ---------------
     * // удалить все нечётные элементы
     * foreach(ref чистить_ли, з; &hashSet.очистить)
     * {
     *   чистить_ли = ((з & 1) == 1);
     * }
     */
    final цел очистить(цел delegate(ref бул чистить_ли, ref З з) дг)
    {
        return _примени(дг);
    }

    private цел _примени(цел delegate(ref бул чистить_ли, ref З з) дг)
    {
        курсор обх = начало;
        бул чистить_ли;
        цел возврдг = 0;
        курсор _конец = конец; //  ***
        while(!возврдг && обх != _конец)
        {
            //
            // не позволяет пользователю изменить значение
            //
            З врмзначение = обх.значение;
            чистить_ли = нет;
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
     * Итерирует по значениям коллекции
     */
    цел opApply(цел delegate(ref З з) дг)
    {
        цел _дг(ref бул чистить_ли, ref З з)
        {
            return дг(з);
        }
        return _примени(&_дг);
    }

    /**
     *инстанциировать хэш-шабор, используя указанные параметры реализации.
     */
    this()
    {
        _хэш.установка();
    }

    //
    // Приватный конструктор для dup
    //
    private this(ref Реализ дубИз)
    {
        дубИз.копируйВ(_хэш);
    }

    /**
     *Очистить все элементы коллекции
     */
    ХэшНабор очисти()
    {
        _хэш.очисти();
        return this;
    }

    /**
     * Возвращает число элементов в коллекции
     */
    бцел длина()
    {
        return _хэш.счёт;
    }
	alias длина length;

    /**
     * Возвращает курсор на первый элемент в коллекции.
     */
    курсор начало()
    {
        курсор обх;
        обх.позиция = _хэш.начало();
        return обх;
    }

    /**
     * Возвращает курсор, который указывает сразу после последнего элемента
     * коллекции.
     */
    курсор конец()
    {
        курсор обх;
        обх.позиция = _хэш.конец();
        return обх;
    }

    /**
     * Удаляет элемент, на который указывает данный курсор, возвращая
     * курсор, указывающий на следующий элемент в коллекции.
     *
     *Выполняется в среднем за O(1) раз.
     */
    курсор удали(курсор обх)
    {
        обх.позиция = _хэш.удали(обх.позиция);
        return обх;
    }

    /**
     * находит экземпляр значения в коллекции.  Возвращает конец, если
     * значение отсутствует.
     *
     * Выполняется в среднем O(1) раз.
     */
    курсор найди(З з)
    {
        курсор обх;
        обх.позиция = _хэш.найди(з);
        return обх;
    }

    /**
     *Возвращает да, если данное значение есть в коллекции.
     *
     * Выполняется в среднем O(1) раз.
     */
    бул содержит(З з)
    {
        return найди(з) != конец;
    }

    /**
     *Удаляет первый элемент, у которого значение з.  Возвращает да, если
     * значение имелось и было удалено.
     *
     * Выполняется за O(n) раз.
     */
    ХэшНабор удали(З з)
    {
        курсор обх = найди(з);
        if(обх != конец)
            удали(обх);
        return this;
    }

    /**
     *Удаляет первый элемент, у которого значение з.  Возвращает да, если
     * значение имелось и было удалено.
     *
     * Выполняется за O(n) раз.
     */
    ХэшНабор удали(З з, ref бул был_Удалён)
    {
        курсор обх = найди(з);
        if(обх == конец)
        {
            был_Удалён = нет;
        }
        else
        {
            был_Удалён = да;
            удали(обх);
        }
        return this;
    }

    ХэшНабор удали(Обходчик!(З) обх)
    {
        foreach(з; обх)
            удали(з);
        return this;
    }

    /**
     * Удаляет все элементы в итераторе.  * Устанавливает чло_Удалённых
     *на число удалённых элементтов.
     *
     *Возвращает this.
     */
    ХэшНабор удали(Обходчик!(З) обх, ref бцел чло_Удалённых)
    {
        бцел исхдлина = длина;
        удали(обх);
        чло_Удалённых = исхдлина - длина;
        return this;
    }

    /**
     *Добавляет элемент в набор.  * Возвращает да, если элемент ещё не
     * присутствовал.
     *
     *Выполняется в среднем за O(1) раз.
     */
    ХэшНабор добавь(З з)
    {
        _хэш.добавь(з);
        return this;
    }

    /**
     *Добавляет элемент в набор.  * Возвращает да, если элемент ещё не
     * присутствовал.
     *
     *Выполняется в среднем за O(1) раз.
     */
    ХэшНабор добавь(З з, ref бул был_добавлен)
    {
        был_добавлен = _хэш.добавь(з);
        return this;
    }

    /**
     * Добавляет все элементы из итератора в набор.  Возвращает число
     * добавленных элементов.
     *
     * Выполняется в среднем за O(1) + O(m) раз, где m - число элементов
     * в итераторе.
     */
    ХэшНабор добавь(Обходчик!(З) обх)
    {
        foreach(з; обх)
            _хэш.добавь(з);
        return this;
    }

    /**
     * Добавляет все элементы из итератора в набор.  Возвращает число
     * добавленных элементов.
     *
     * Выполняется в среднем за O(1) + O(m) раз, где m - число элементов
     * в итераторе.
     */
    ХэшНабор добавь(Обходчик!(З) обх, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        добавь(обх);
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Добавляет все элементы из массива в набор.  * Возвращает число
     *добавленных элементов.
     *
     * Выполняется в среднем за O(1) + O(m) раз, где m - длина массива.
     */
    ХэшНабор добавь(З[] массив)
    {
        foreach(з; массив)
            _хэш.добавь(з);
        return this;
    }

    /**
     * Добавляет все элементы из массива в набор.  * Возвращает число
     *добавленных элементов.
     *
     * Выполняется в среднем за O(1) + O(m) раз, где m - длина массива.
     */
    ХэшНабор добавь(З[] массив, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        добавь(массив);
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Удалить все значения из набора, которых нет в указанном поднаборе
     *
     * возвращает this.
     */
    ХэшНабор накладка(Обходчик!(З) поднабор)
    {
        //
        //пересечение сложнее удаления, поскольку нам не
        //видны детали реализации.  * Следовательно, пусть
        //реализация выполнит обх.
        //
        _хэш.накладка(поднабор);
        return this;
    }

    /**
     *  Удалить все значения из набора, которых нет в указанном поднаборе.
     * Устанавливает чло_Удалённых на число удалённых элементов.
     *
     * возвращает this.
     */
    ХэшНабор накладка(Обходчик!(З) поднабор, ref бцел чло_Удалённых)
    {
        //
        //пересечение сложнее удаления, поскольку нам не
        //видны детали реализации.  * Следовательно, пусть
        //реализация выполнит обх.
        //
        чло_Удалённых = _хэш.накладка(поднабор);
        return this;
    }

    /**
     * дублировать данный хэш-набор
     */
    ХэшНабор dup()
    {
        return new ХэшНабор(_хэш);
    }

    цел opEquals(Объект o)
    {
        if(o !is пусто)
        {
            auto s = cast(Набор!(З))o;
            if(s !is null && s.length == длина)
            {
                foreach(элт; s)
                {
                    if(!содержит(элт))
                        return 0;
                }

                //
                // равно
                //
                return 1;
            }
        }
        //
        // сравнение невозможно.
        //
        return 0;
    }

    /**
     * Даёт наиболее подходящий элемент из набора.  * Это элемент, который
     *должен итерироваться первым.  Следовательно, вызов удали(дай())
     * гарантировано меньше, чем операция O(n).
     */
    З дай()
    {
        return начало.значение;
    }

    /**
     *Удалить наиболее подходящий элемент из набора, и вернуть его значение.
     * Это равносильно удали(дай()), только лишь один поиск
     * выполняется.
     */
    З изыми()
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
        auto hs = new ХэшНабор!(бцел);
        Набор!(бцел) s = hs;
        s.добавь([0U, 1, 2, 3, 4, 5, 5]);
        assert(s.length == 6);
        foreach(ref чистить_ли, i; &s.очистить)
            чистить_ли = (i % 2 == 1);
        assert(s.length == 3);
        assert(s.содержит(4));
    }
}
