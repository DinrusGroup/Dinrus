/*******************************************************************************
  copyright:   Copyright (c) 2006 Juan Jose Comellas. все rights reserved
  license:     BSD стиль: $(LICENSE)
  author:      Juan Jose Comellas <juanjo@comellas.com.ar>
*******************************************************************************/

module io.selector.Selector;

/**
 * A multИПlexor of провод I/O события.
 *
 * A Селектор can жди for I/O события (Чит, Зап, etc.) for multИПle
 * conduits efficiently (i.e. without consuming CPU cycles).
 *
 * The Селектор is an alias for your system's most efficient I/O multИПlexor,
 * which will be determined during compilation.
 *
 * To создай a Селектор you need в_ use the открой() метод и when you decопрe
 * you no longer need it you should вызов its закрой() метод в_ free any system
 * resources it may be consuming. все selectors that need в_ free resources
 * when закрой() is called also implement a destructor that automatically calls
 * this метод. This means that if you declare your selector экземпляр with the
 * 'auto' keyword you won't have в_ worry about doing it manually.
 *
 * Once you have открой()'ed your selector you need в_ associate the conduits в_
 * it by using the регистрируй() метод. This метод Приёмs the провод и the
 * события you want в_ track for it. For example, if you wanted в_ читай из_
 * the провод you would do:
 *
 * ---
 * selector.регистрируй(провод, Событие.Чит, myObject);
 * ---
 *
 * This метод also accepts an optional third parameter в_ associate a
 * пользователь-defined объект в_ the провод. These three параметры together define
 * a КлючВыбора, which is что you'll принять when the провод is "selected"
 * (i.e. Приёмs an событие).
 *
 * If you need в_ modify your провод's registration you need в_ use the
 * повториРег() метод, which works like регистрируй(), but expects в_ be passed
 * a провод that имеется already been associated в_ the selector:
 *
 * ---
 * selector.повториРег(провод, Событие.Зап, myObject);
 * ---
 *
 * If you need в_ удали a провод из_ the selector you do it by calling
 * отмениРег():
 *
 * ---
 * selector.отмениРег(провод);
 * ---
 *
 * Once you are готово настройка up the conduits you will want в_ жди for I/O
 * события for them. To do that you need в_ use the выбери() метод. This
 * метод блокs until either one of the conduits is selected or the
 * specified таймаут is reached. Even though it имеется two different versions:
 * a) выбери(); b) выбери(Interval); the первый one is just the same as doing
 * выбери(Interval.max). In that case we don't have a таймаут и
 * выбери() блокs until a провод Приёмs an событие.
 *
 * When выбери() returns you will принять an целое; if this целое is
 * bigger than 0, it indicates the число of conduits that have been selected.
 * If this число is 0, the it means that the selector reached a таймаут, и
 * if it's -1, then it means that there was an ошибка. A нормаль блок that deals 
 * with the выделение process would look like this:
 *
 * ---
 * try
 * {
 *     цел eventCount = selector.выбери(10.0);
 *     if (eventCount > 0)
 *     {
 *         // Процесс the I/O события in the selected установи
 *     }
 *     else if (eventCount == 0)
 *     {
 *         // Timeout
 *     }
 *     else if (eventCount == -1)
 *     {
 *         // Ошибка
 *     }
 *     else
 *     {
 *         // Ошибка: should never happen.
 *     }
 * }
 * catch (ИсклСелектора e)
 * {
 *     Стдвыв.форматируй("Исключение caught: {0}", e.вТкст()).нс();
 * }
 * ---
 *
 * Finally, в_ gather the события you need в_ iterate over the selector's
 * выделение установи, which can be использовался via the наборВыд() метод.
 *
 * ---
 * foreach (КлючВыбора ключ; selector.наборВыд())
 * {
 *     if (ключ.читаем_ли())
 *     {
 *         // Чит из_ провод
 *         // [...]
 *         // Then регистрируй it for writing
 *         selector.повториРег(ключ.провод, Событие.Зап, ключ.атачмент);
 *     }
 *
 *     if (ключ.isWriteable())
 *     {
 *         // Зап в_ провод
 *         // [...]
 *         // Then регистрируй it for reading
 *         selector.повториРег(ключ.провод, Событие.Чит, ключ.атачмент);
 *     }
 *
 *     if (ключ.ошибка_ли())
 *     {
 *         // Problem with провод; удали it из_ selector
 *         selector.удали(провод);
 *     }
 * }
 * ---
 */
version (linux)
{
    public import io.selector.EpollSelector;

    /**
     * Default Селектор for Linux.
     */
    alias EpollSelector Селектор;
}
else version(Posix)
{
    public import io.selector.PollSelector;

    /**
     * Default Селектор for POSIX-compatible platforms.
     */
    alias PollSelector Селектор;
}
else
{
    public import io.selector.SelectSelector;

    /**
     * Default Селектор for Windows.
     */
    alias СелекторВыбора Селектор;
}
