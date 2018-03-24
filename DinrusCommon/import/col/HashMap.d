/*********************************************************
   Авторское право: (C) 2008 принадлежит Steven Schveighoffer.
              Все права защищены

   Лицензия: $(LICENSE)

**********************************************************/
module col.HashMap;

public import col.model.Map;
public import col.Functions;
private import col.Hash;

private import col.Iterators;

/+ ИНТЕРФЕЙС:

class ХэшКарта(К, З, alias ШаблРеализац=Хэш, alias хэшФункц=ДефХэш) : Карта!(К, З)
{

    struct элемент
    {
        К ключ;
        З знач;
        цел opEquals(элемент e);
    }
    struct курсор
    {
        З значение();
        К ключ();
        З значение(З з);
        курсор opPostInc();
        курсор opPostDec();
        курсор opAddAssign(цел прир);
        курсор opSubAssign(цел прир);
        бул opEquals(курсор обх);
    }

    final цел очистить(цел delegate(ref бул чистить_ли, ref З з) дг);
    final цел чисть_ключ(цел delegate(ref бул чистить_ли, ref К к, ref З з) дг);	
    цел opApply(цел delegate(ref К к, ref З з) дг);
    цел opApply(цел delegate(ref З з) дг);
    this();
    ХэшКарта очисти();
    бцел длина();
    курсор начало();
    курсор конец();
    курсор удали(курсор обх);
    курсор найдиЗначение(курсор обх, З з);
    курсор найдиЗначение(З з);
    курсор найди(К к);
    бул содержит(З з);
    ХэшКарта удали(З з);
    ХэшКарта удали(З з, ref бул был_Удалён);
    ХэшКарта удалиПо(К ключ);
    ХэшКарта удалиПо(К ключ, ref бул был_Удалён);
    З opIndex(К ключ);
    З opIndexAssign(З значение, К ключ);
    ХэшКарта установи(К ключ, З значение);
    ХэшКарта установи(К ключ, З значение, ref бул был_добавлен);
    ХэшКарта установи(Ключник!(К, З) исток);
    ХэшКарта установи(Ключник!(К, З) исток, ref бцел чло_добавленных);
    ХэшКарта удали(Обходчик!(К) поднабор);
    ХэшКарта удали(Обходчик!(К) поднабор, ref бцел чло_Удалённых);
    ХэшКарта накладка(Обходчик!(К) поднабор);
    ХэшКарта накладка(Обходчик!(К) поднабор, ref бцел чло_Удалённых);
    бул имеетКлюч(К ключ);
    бцел счёт(З з);
    ХэшКарта удалиВсе(З з);
    ХэшКарта удалиВсе(З з, ref бцел чло_Удалённых);
    Обходчик!(К) ключи();
    ХэшКарта dup();
    цел opEquals(Объект o);
    ХэшКарта установи(З[К] исток);
    ХэшКарта установи(З[К] исток, ref бцел чло_добавленных);
    ХэшКарта удали(К[] поднабор);
    ХэшКарта удали(К[] поднабор, ref бцел чло_Удалённых);
    ХэшКарта накладка(К[] поднабор);
    ХэшКарта накладка(К[] поднабор, ref бцел чло_Удалённых);
}
+///===========================================================

/**
 * Реализация карты, использующая Хэш для ближней вставки O(1),
 * удаления и поиска по времени.
 *
 * Добавка элемента может вывести из строя курсоры, в зависимости от реализации.
 *
 * Удаление элемента выводит из строя лишь те курсоры, которые указывали на
 * данный элемент.
 *
 * Реализацию Хэш можно заменить на адаптированную, этот
 * Хэш должен быть шаблонной структурой, инстанциируемой единственным
 * шаблонным аргументом З, и реализующей следующие члены (члены, не функции,
 * могут быть свойствами дай/установи, если иное не указано):
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
 * позиция -> должна быть структурой/классом со следующими членами:
 *   укз -> должно определять следующий член:
 *     значение -> значение, на которое указывает данная позиция (не может являться
 *  каким-либо свойством)
 *   позиция следщ -> следующая позиция в хэш-карте
 *   позиция предш -> предшествующая позиция в хэш-карте
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
class ХэшКарта(К, З, alias ШаблРеализац=Хэш, alias хэшФункц=ДефХэш) : Карта!(К, З)
{
    /**
     * используется для реализации пары ключ/значение, хранимой реализации  хэша
     */
    struct элемент
    {
        К ключ;
        З знач;

        /**
         * Сравнить 2 элемента на равенство.  Сравнивает только ключи.
         */
        цел opEquals(элемент e)
        {
            return ключ == e.ключ;
        }
    }

    private КлючОбходчик _ключи;

    /**
     * Функция, выдающая хэш элемента
     */
    static бцел _хэшФункция(ref элемент e)
    {
        return хэшФункц(e.ключ);
    }

    /**
     * Функция для обновления элемента, согласно новому элементу.
     */
    static проц _функцияОбнова(ref элемент исх, ref элемент новэлт)
    {
        //
        // копируем только значение, оставляем в покое ключ
        //
        исх.знач = новэлт.знач;
    }

    /**
     * алиас для удобства
     */
    alias ШаблРеализац!(элемент, _хэшФункция, _функцияОбнова) Реализ;

    private Реализ _хэш;

    /**
     * Курсор для хэш-карты.
     */
    struct курсор
    {
        private Реализ.позиция позиция;

        /**
         * Выдаст значение у курсора this
         */
        З значение()
        {
            return позиция.ptr.значение.знач;
        }

        /**
         * Выдаст ключ у this курсора
         */
        К ключ()
        {
            return позиция.ptr.значение.ключ;
        }

        /**
         * Установит значение у курсора this
         */
        З значение(З з)
        {
            позиция.ptr.значение.знач = з;
            return з;
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
            return обх.позиция is позиция;
        }
    }

    /**
     *Итерирует по значения м в ХэшКарта,  сообщая обх, которые из них
     * удалить.
     */
    final цел очистить(цел delegate(ref бул чистить_ли, ref З з) дг)
    {
        цел _дг(ref бул чистить_ли, ref К к, ref З з)
        {
            return дг(чистить_ли, з);
        }
        return _примени(&_дг);
    }

    /**
     * Итерирует по парам ключ/значение ХэшКарты, сообщая обх, которые из них
     * удалить.
     */
    final цел чисть_ключ(цел delegate(ref бул чистить_ли, ref К к, ref З з) дг)
    {
        return _примени(дг);
    }

    private class КлючОбходчик : Обходчик!(К)
    {
        final бцел длина()
        {
            return this.outer.length;
        }

		alias длина length;
		
        final цел opApply(цел delegate(ref К) дг)
        {
            цел _дг(ref бул чистить_ли, ref К к, ref З з)
            {
                return дг(к);
            }
            return _примени(&_дг);
        }
    }

    private цел _примени(цел delegate(ref бул чистить_ли, ref К к, ref З з) дг)
    {
        курсор обх = начало;
        бул чистить_ли;
        цел возврдг = 0;
        курсор _конец = конец; //  ***
        while(!возврдг && обх != _конец)
        {
            //
            // не позволяет пользователю изменить ключ
            //
            К врмключ = обх.ключ;
            чистить_ли = нет;
            if((возврдг = дг(чистить_ли, врмключ, обх.позиция.ptr.значение.знач)) != 0)
                break;
            if(чистить_ли)
                обх = удали(обх);
            else
                обх++;
        }
        return возврдг;
    }

    /**
     * Итерировать по парам ключ/значение коллекции
     */
    цел opApply(цел delegate(ref К к, ref З з) дг)
    {
        цел _дг(ref бул чистить_ли, ref К к, ref З з)
        {
            return дг(к, з);
        }

        return _примени(&_дг);
    }

    /**
     * Итерирует по значениям коллекции
     */
    цел opApply(цел delegate(ref З з) дг)
    {
        цел _дг(ref бул чистить_ли, ref К к, ref З з)
        {
            return дг(з);
        }
        return _примени(&_дг);
    }

    /**
     * Создаёт экземпляр хэш-карты.
     */
    this()
    {
        // Устанавливает любой хэш в необходимый
        _хэш.установка();
        _ключи = new КлючОбходчик;
    }

    //
    // Приватный конструктор для dup
    //
    private this(ref Реализ дубИз)
    {
        дубИз.копируйВ(_хэш);
        _ключи = new КлючОбходчик;
    }

    /**
     *Очистить все элементы коллекции
     */
    ХэшКарта очисти()
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
     * Найти указанное значение в коллекции, начиная с данного курсора.
     * Это полезно для итерации по всем элементам с одинаковыми значениями.
     *
     * Выполняется за O(n) раз.
     */
    курсор найдиЗначение(курсор обх, З з)
    {
        return _найдиЗначение(обх, конец, з);
    }

    /**
     * Найти экземпляр  значения  в коллекции.  Эквивалентно
     * найдиЗначение(начало, з);
     *
     * Выполняется за O(n) раз.
     */
    курсор найдиЗначение(З з)
    {
        return _найдиЗначение(начало, конец, з);
    }

    private курсор _найдиЗначение(курсор обх, курсор последн, З з)
    {
        while(обх != последн && обх.значение != з)
            обх++;
        return обх;
    }

    /**
     * Найти экземпляр  ключа в коллекции.  Возвращает конец, если ключ
     * отсутствует.
     *
     * Выполняется в среднем O(1) раз.
     */
    курсор найди(К к)
    {
        курсор обх;
        элемент врм;
        врм.ключ = к;
        обх.позиция = _хэш.найди(врм);
        return обх;
    }

    /**
     *Возвращает да, если данное значение есть в коллекции.
     *
     * Выполняется за O(n) раз.
     */
    бул содержит(З з)
    {
        return найдиЗначение(з) != конец;
    }

    /**
     *Удаляет первый элемент, у которого значение з.  Возвращает да, если
     * значение имелось и было удалено.
     *
     * Выполняется за O(n) раз.
     */
    ХэшКарта удали(З з)
    {
        бул пропущен;
        return удали(з, пропущен);
    }

    /**
     *Удаляет первый элемент, у которого значение з.  Возвращает да, если
     * значение имелось и было удалено.
     *
     * Выполняется за O(n) раз.
     */
    ХэшКарта удали(З з, ref бул был_Удалён)
    {
        курсор обх = найдиЗначение(з);
        if(обх == конец)
        {
            был_Удалён = нет;
        }
        else
        {
            удали(обх);
            был_Удалён = да;
        }
        return this;
    }

    /**
     * Удаляет элемент, у которого указанный ключ.  Возвращает да, если
     * элемент был, но удалён.
     *
     *Выполняется в среднем за O(1) раз.
     */
    ХэшКарта удалиПо(К ключ)
    {
        бул пропущен;
        return удалиПо(ключ, пропущен);
    }

    /**
     * Удаляет элемент, у которого указанный ключ.  Возвращает да, если
     * элемент был, но удалён.
     *
     *Выполняется в среднем за O(1) раз.
     */
    ХэшКарта удалиПо(К ключ, ref бул был_Удалён)
    {
        курсор обх = найди(ключ);
        if(обх == конец)
        {
            был_Удалён = нет;
        }
        else
        {
            удали(обх);
            был_Удалён = да;
        }
        return this;
    }

    /**
     * Возвращаает значение, которое хранится у элемента, у которого указанный
     * ключ.  Выводит исключение, если ключа в коллекции нет.
     *
     *Выполняется в среднем за O(1) раз.
     */
    З opIndex(К ключ)
    {
        курсор обх = найди(ключ);
        if(обх == конец)
            throw new Искл("Индекс вне диапазона");
        return обх.значение;
    }

    /**
     * Присваивает указанное значение элементу с указанным ключом.  Если ключ
     * не существует, добавляет ключ и значение в коллекцию.
     *
     *Выполняется в среднем за O(1) раз.
     */
    З opIndexAssign(З значение, К ключ)
    {
        установи(ключ, значение);
        return значение;
    }

    /**
     * Набор пар ключ/значение.  Если пара ключ/значение ещё не существует, обх
     * добавляется.
     */
    ХэшКарта установи(К ключ, З значение)
    {
        бул пропущен;
        return установи(ключ, значение, пропущен);
    }

    /**
     * Набор пар ключ/значение.  Если пара ключ/значение ещё не существует, обх
     * добавляется, и параметр был_добавлен устанавливается в да.
     */
    ХэшКарта установи(К ключ, З значение, ref бул был_добавлен)
    {
        элемент элт;
        элт.ключ = ключ;
        элт.знач = значение;
        был_добавлен = _хэш.добавь(элт);
        return this;
    }

    /**
     * Установить все значения в карте из итератора.  Если какие-то элементы
     * ранее не существовали, они  добавляются.
     */
    ХэшКарта установи(Ключник!(К, З) исток)
    {
        бцел пропущен;
        return установи(исток, пропущен);
    }

    /**
     * Установить все значения в карте из итератора.  Если какие-то элементы
     * ранее не существовали, они  добавляются.  чло_добавленных устанавливается в число
     * элементов, которые были добавлены  в этой операции.
     */
    ХэшКарта установи(Ключник!(К, З) исток, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        бул пропущен;
        foreach(к, з; исток)
        {
            установи(к, з, пропущен);
        }
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Удалить все ключи из карты, которые есть в поднаборе.
     */
    ХэшКарта удали(Обходчик!(К) поднабор)
    {
        foreach(к; поднабор)
            удалиПо(к);
        return this;
    }

    /**
     * Удалить все ключи из карты, которые есть в поднаборе.  чло_Удалённых устанавливается в
     * число ключей, действительно удалённых.
     */
    ХэшКарта удали(Обходчик!(К) поднабор, ref бцел чло_Удалённых)
    {
        бцел исхдлина = длина;
        удали(поднабор);
        чло_Удалённых = исхдлина - длина;
        return this;
    }

    ХэшКарта накладка(Обходчик!(К) поднабор)
    {
        бцел пропущен;
        return накладка(поднабор, пропущен);
    }

    /**
     * Эта функция сохраняет только элементы, наблюдаемые в поднаборе.
     */
    ХэшКарта накладка(Обходчик!(К) поднабор, ref бцел чло_Удалённых)
    {
        //
        //это биттрюкер, далее удаляемый.  Нужно найти каждый
        // элемент Хэш, затем переместить обх к новой таблице.  Но у нас нет
        // реализации и не можем предполагать эту
        // реализацию.  Поэтому принимаем пересечение за хэш
        // реализацию.
        //
        // Если не контролировать рантайм. это можно было бы сделать так:
        //
        // удали((new ХэшНабор!(К)).добавь(this.ключи).удали(поднабор));
        //

        //
        // нужно создать обёртку-итератор, для передачи реализации,
        //который обёртывает каждый ключ из поднабора как элемент
        //
        //масштаб (scope) размещается на стеке.
        //
        scope w = new ТрансформОбходчик!(элемент, К)(поднабор, function проц(ref К к, ref элемент e) { e.ключ = к;});

        чло_Удалённых = _хэш.накладка(w);
        return this;
    }

    /**
     * Возвращает да, если указанный ключ есть в коллекции.
     *
     *Выполняется в среднем за O(1) раз.
     */
    бул имеетКлюч(К ключ)
    {
        return найди(ключ) != конец;
    }

    /**
     * Возвращает число элементов, содержащих значение з
     *
     * Выполняется за O(n) раз.
     */
    бцел счёт(З з)
    {
        бцел экземпляры = 0;
        foreach(x; this)
        {
            if(x == з)
                экземпляры++;
        }
        return экземпляры;
    }

    /**
     * Удалить все элементы, содержащие значение з.
     *
     * Выполняется за O(n) раз.
     */
    ХэшКарта удалиВсе(З з)
    {
        бцел пропущен;
        return удалиВсе(з, пропущен);
    }
    /**
     * Удалить все элементы, содержащие значение з.
     *
     * Выполняется за O(n) раз.
     */
    ХэшКарта удалиВсе(З з, ref бцел чло_Удалённых)
    {
        бцел исхдлина = длина;
        foreach(ref b, x; &очистить)
        {
            b = cast(бул)(x == з);
        }
        чло_Удалённых = исхдлина - длина;
        return this;
    }

    /**
     * Вернуть итератор, который можно использовать для чтения всех ключей.
     */
    Обходчик!(К) ключи()
    {
        return _ключи;
    }

    /**
     * Сделать поверхностную копию хэш-карты.
     */
    ХэшКарта dup()
    {
        return new ХэшКарта(_хэш);
    }

    /**
     * Сравнить this ХэшКарта с другой Картой
     *
     * Возвращает 0, если o  ! = объект Карта, = пусто, или ХэшКарта не
     * содержит одинаковых пар ключ/значение, как заданная карта.
     * Возвращает 1, если ровное число пар ключ/значение, имеющихся в данной карте,
     * есть и в  this ХэшКарта.
     */
    цел opEquals(Объект o)
    {
        //
        // пробуем кастинг карты, иначе не сравнивается
        //
        auto m = cast(Карта!(К, З))o;
        if(m !is пусто && m.length == длина)
        {
            auto _конец = конец;
            foreach(К к, З з; m)
            {
                auto cu = найди(к);
                if(cu is _конец || cu.значение != з)
                    return 0;
            }
            return 1;
        }

        return 0;
    }

    /**
     * Установить все элементы из данного ассоциативного массива в карту.  Любой
     * ключ, уже существующий, будет переписан.
     *
     * возвращает this.
     */
    ХэшКарта установи(З[К] исток)
    {
        foreach(К к, З з; исток)
            this[к] = з;
        return this;
    }

    /**
     * Установить все элементы из данного ассоциативного массива в карту.  Любой
     * ключ, уже существующий, будет переписан.
     *
     * Устаавливает чло_добавленных  в число добавленных пар  ключ/значение.
     *
     * возвращает this.
     */
    ХэшКарта установи(З[К] исток, ref бцел чло_добавленных)
    {
        бцел оригДлина = длина;
        установи(исток);
        чло_добавленных = длина - оригДлина;
        return this;
    }

    /**
     * Удалить все заданные ключи из карты.
     *
     * return this.
     */
    ХэшКарта удали(К[] поднабор)
    {
        foreach(к; поднабор)
            удалиПо(к);
        return this;
    }

    /**
     * Удалить все заданные ключи из карты.
     *
     * return this.
     *
     * чло_Удалённых устанавливается в число удалённых элементов.
     */
    ХэшКарта удали(К[] поднабор, ref бцел чло_Удалённых)
    {
        бцел оригДлина = длина;
        удали(поднабор);
        чло_Удалённых = оригДлина - длина;
        return this;
    }

    /**
     * Удалить все ключи, не входящие в данный массив.
     *
     * возвращает this.
     */
    ХэшКарта накладка(К[] поднабор)
    {
        scope обход = new ОбходчикМассива!(К)(поднабор);
        return накладка(обход);
    }

    /**
     * Удалить все ключи, не входящие в данный массив.
     *
     * Устанавливает чло_Удалённых в число удалённых элементов.
     *
     * возвращает this.
     */
    ХэшКарта накладка(К[] поднабор, ref бцел чло_Удалённых)
    {
        scope обход = new ОбходчикМассива!(К)(поднабор);
        return накладка(обход, чло_Удалённых);
    }
}

version(UnitTest)
{
    unittest
    {
        ХэшКарта!(бцел, бцел) хк = new ХэшКарта!(бцел, бцел);
        Карта!(бцел, бцел) m = хк;
        for(цел i = 0; i < 10; i++)
            хк[i * i + 1] = i;
        assert(хк.length == 10);
        foreach(ref бул чистить_ли, бцел к, бцел з; &хк.чисть_ключ)
        {
            чистить_ли = (з % 2 == 1);
        }
        assert(хк.length == 5);
        assert(хк.содержит(6));
        assert(хк.имеетКлюч(6 * 6 + 1));
    }
}
