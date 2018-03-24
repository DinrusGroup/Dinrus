/*********************************************************
   Авторское право: (C) 2008 принадлежит Steven Schveighoffer.
              Все права защищены

   Лицензия: $(LICENSE)

**********************************************************/
module col.model.Keyed;

public import col.model.Iterator;

/**
 * Интерфейс, определяющий объект, который получает доступ к объекту по ключу.
 */
interface СКлючом(К, З) : Ключник!(К, З), ЧистящийКлючи!(К, З)
{
    /**
     * Удаляет значение по положению заданного ключа
     *
     *Возвращает this.
     */
    СКлючом!(К, З) удалиПо(К ключ);

    /**
     * Удаляет значение по положению заданного ключа
     *
     *Возвращает this.
     *
     * был_Удалён устанавливается в да if the элемент существовал, но был удалён.
     */
    СКлючом!(К, З) удалиПо(К ключ, ref бул был_Удалён);

    /**
     * Доступ к значению по ключу
     */
    З opIndex(К ключ);

    /**
     * Присвоить значение по ключу
     *
     * Использовать его для вставки пары a ключ/значениев коллекцию.
     *
     * Прим.: некоторые контейнеры не использует пользовательские ключи.  Для таких
     * контейнеров, ключ должен уже существовать до установки.
     */
    З opIndexAssign(З значение, К ключ);

    /**
     * Установить пару ключ/значение.  Это подобно opIndexAssign, но возвращает
     * this, поэтому функция может добавляться в цекпочку.
     */
    СКлючом!(К, З) установи(К ключ, З значение);

    /**
     * То же что установи, но имеет булево значение был_добавлен, чтобы сообщить вызывающему, было ли
     * значение добавлено или нет
     */
    СКлючом!(К, З) установи(К ключ, З значение, ref бул был_добавлен);

    /**
     * Возвращает да, если коллекция содержит ключ
     */
    бул имеетКлюч(К ключ);
}
