/*******************************************************************************
  copyright:   Copyright (c) 2006 Juan Jose Comellas. все rights reserved
  license:     BSD стиль: $(LICENSE)
  author:      Juan Jose Comellas <juanjo@comellas.com.ar>
*******************************************************************************/

module io.selector.AbstractSelector;

public import io.model;
public import io.selector.SelectorException;

private import io.selector.model;
private import sys.Common;
private import cidrus: дайНомош;

version (Windows)
{
    public struct значврем
    {
        цел сек;     // сек
        цел микросек;    // микросекунды
    }
}

/**
 * Base class for все selectors.
 *
 * A selector is a multИПlexor for I/O события associated в_ a Провод.
 * все selectors must implement this interface.
 *
 * A selector needs в_ be инициализован by calling the открой() метод в_ пароль
 * it the начальное amount of conduits that it will укз and the maximum
 * amount of события that will be returned per вызов в_ выбери(). In Всё cases,
 * these values are only hints and may not even be used by the specific
 * ИСелектор implementation you choose в_ use, so you cannot сделай any
 * assumptions regarding what results из_ the вызов в_ выбери() (i.e. you
 * may принять ещё or less события per вызов в_ выбери() than what was passed
 * in the 'maxEvents' аргумент. The amount of conduits that the selector can
 * manage will be incremented dynamically if necessary.
 *
 * To добавь or modify провод registrations in the selector, use the регистрируй()
 * метод.  To удали провод registrations из_ the selector, use the
 * отмениРег() метод.
 *
 * To жди for события из_ the conduits you need в_ вызов any of the выбери()
 * methods. The selector cannot be изменён из_ другой нить while
 * blocking on a вызов в_ these methods.
 *
 * Once the selector is no longer used you must вызов the закрой() метод so
 * that the selector can free any resources it may have allocated in the вызов
 * в_ открой().
 *
 * See_Also: ИСелектор
 *
 * Examples:
 * ---
 * import io.selector.model;
 * import net.device.Socket;
 * import io.Stdout;
 *
 * АбстрактныйСелектор selector;
 * СокетПровод conduit1;
 * СокетПровод conduit2;
 * MyClass object1;
 * MyClass object2;
 * бцел eventCount;
 *
 * // Initialize the selector assuming that it will deal with 2 conduits and
 * // will принять 2 события per invocation в_ the выбери() метод.
 * selector.открой(2, 2);
 *
 * selector.регистрируй(провод, Событие.Чтен, object1);
 * selector.регистрируй(провод, Событие.Write, object2);
 *
 * eventCount = selector.выбери();
 *
 * if (eventCount > 0)
 * {
 *     сим[16] буфер;
 *     цел счёт;
 *
 *     foreach (КлючВыбора ключ, selector.наборВыд())
 *     {
 *         if (ключ.читаем_ли())
 *         {
 *             счёт = (cast(СокетПровод) ключ.провод).читай(буфер);
 *             if (счёт != ИПровод.Кф)
 *             {
 *                 Стдвыв.форматируй("Приёмd '{0}' из_ peer\n", буфер[0..счёт]);
 *                 selector.регистрируй(ключ.провод, Событие.Write, ключ.атачмент);
 *             }
 *             else
 *             {
 *                 selector.отмениРег(ключ.провод);
 *                 ключ.провод.закрой();
 *             }
 *         }
 *
 *         if (ключ.записываем_ли())
 *         {
 *             счёт = (cast(СокетПровод) ключ.провод).пиши("MESSAGE");
 *             if (счёт != ИПровод.Кф)
 *             {
 *                 Стдвыв("Sent 'MESSAGE' в_ peer\n");
 *                 selector.регистрируй(ключ.провод, Событие.Чтен, ключ.атачмент);
 *             }
 *             else
 *             {
 *                 selector.отмениРег(ключ.провод);
 *                 ключ.провод.закрой();
 *             }
 *         }
 *
 *         if (ключ.ошибка_ли() || ключ.зависание_ли() || ключ.невернУк_ли())
 *         {
 *             selector.отмениРег(ключ.провод);
 *             ключ.провод.закрой();
 *         }
 *     }
 * }
 *
 * selector.закрой();
 * ---
 */
abstract class АбстрактныйСелектор: ИСелектор
{
    /**
     * Restart interrupted system calls when blocking insопрe a вызов в_ выбери.
     */
    protected бул _restartInterruptedSystemCall = да;

    /**
     * Indicates whether interrupted system calls will be restarted when
     * blocking insопрe a вызов в_ выбери.
     */
    public бул перезапускПрерванногоСистВызова()
    {
        return _restartInterruptedSystemCall;
    }

    /**
     * Sets whether interrupted system calls will be restarted when
     * blocking insопрe a вызов в_ выбери.
     */
    public проц перезапускПрерванногоСистВызова(бул значение)
    {
        _restartInterruptedSystemCall = значение;
    }

    /**
     * Initialize the selector.
     *
     * Параметры:
     * размер         = значение that provопрes a hint for the maximum amount of
     *                conduits that will be registered
     * maxEvents    = значение that provопрes a hint for the maximum amount of
     *                провод события that will be returned in the selection
     *                установи per вызов в_ выбери.
     */
    public abstract проц открой(бцел размер, бцел maxEvents);

    /**
     * Free any operating system resources that may have been allocated in the
     * вызов в_ открой().
     *
     * Remarks:
     * Not все of the selectors need в_ free resources другой than allocated
     * память, but those that do will normally also добавь a вызов в_ закрой() in
     * their destructors.
     */
    public abstract проц закрой();

    /**
     * Associate a провод в_ the selector and track specific I/O события.
     *
     * Параметры:
     * провод      = провод that will be associated в_ the selector
     * события       = bit маска of Событие values that represent the события that
     *                will be tracked for the провод.
     * атачмент   = optional объект with application-specific данные that will
     *                be available when an событие is triggered for the провод
     *
     * Examples:
     * ---
     * АбстрактныйСелектор selector;
     * СокетПровод провод;
     * MyClass объект;
     *
     * selector.регистрируй(провод, Событие.Чтен | Событие.Write, объект);
     * ---
     */
    public abstract проц регистрируй(ИВыбираемый провод, Событие события,
                                  Объект атачмент);

    /**
     * Deprecated, use регистрируй instead
     */
    deprecated public final проц повториРег(ИВыбираемый провод, Событие события,
            Объект атачмент = пусто)
    {
        регистрируй(провод, события, атачмент);
    }

    /**
     * Удали a провод из_ the selector.
     *
     * Параметры:
     * провод      = провод that had been previously associated в_ the
     *                selector; it can be пусто.
     *
     * Remarks:
     * Unregistering a пусто провод is allowed and no исключение is thrown
     * if this happens.
     */
    public abstract проц отмениРег(ИВыбираемый провод);

    /**
     * Wait for I/O события из_ the registered conduits for a specified
     * amount of время.
     *
     * Возвращает:
     * The amount of conduits that have Приёмd события; 0 if no conduits
     * have Приёмd события within the specified таймаут; and -1 if the
     * wakeup() метод есть been called из_ другой нить.
     *
     * Remarks:
     * This метод is the same as calling выбери(ИнтервалВремени.max).
     */
    public цел выбери()
    {
        return выбери(ИнтервалВремени.max);
    }

    /**
     * Wait for I/O события из_ the registered conduits for a specified
     * amount of время.
     *
     * Note: This representation of таймаут is not always accurate, so it is
     * possible that the function will return with a таймаут before the
     * specified период.  For ещё accuracy, use the ИнтервалВремени version.
     *
     * Параметры:
     * таймаут  = the maximum amount of время in сек that the
     *            selector will жди for события из_ the conduits; the
     *            amount of время is relative в_ the current system время
     *            (i.e. just the число of milliseconds that the selector
     *            есть в_ жди for the события).
     *
     * Возвращает:
     * The amount of conduits that have Приёмd события; 0 if no conduits
     * have Приёмd события within the specified таймаут.
     */
    public цел выбери(дво таймаут)
    {
            return выбери(ИнтервалВремени.изИнтервала(таймаут));
    }

    /**
     * Wait for I/O события из_ the registered conduits for a specified
     * amount of время.
     *
     * Параметры:
     * таймаут  = ИнтервалВремени with the maximum amount of время that the
     *            selector will жди for события из_ the conduits; the
     *            amount of время is relative в_ the current system время
     *            (i.e. just the число of milliseconds that the selector
     *            есть в_ жди for the события).
     *
     * Возвращает:
     * The amount of conduits that have Приёмd события; 0 if no conduits
     * have Приёмd события within the specified таймаут; and -1 if the
     * wakeup() метод есть been called из_ другой нить.
     */
    public abstract цел выбери(ИнтервалВремени таймаут);

    /**
     * Causes the first вызов в_ выбери() that есть not yet returned в_ return
     * immediately.
     *
     * If другой нить is currently blocked in an вызов в_ any of the
     * выбери() methods then that вызов will return immediately. If no
     * selection operation is currently in ход then the следщ invocation
     * of one of these methods will return immediately. In any case the значение
     * returned by that invocation may be non-zero. Subsequent invocations of
     * the выбери() methods will block as usual unless this метод is invoked
     * again in the meantime.
     */
    // public abstract проц wakeup();

    /**
     * Return the selection установи resulting из_ the вызов в_ any of the выбери()
     * methods.
     *
     * Remarks:
     * If the вызов в_ выбери() was unsuccessful or it dопр not return any
     * события, the returned значение will be пусто.
     */
    public abstract ИНаборВыделений наборВыд();

    /**
     * Return the selection ключ resulting из_ the registration of a провод
     * в_ the selector.
     *
     * Remarks:
     * If the провод is not registered в_ the selector the returned
     * значение will be пусто. No исключение will be thrown by this метод.
     */
    public abstract КлючВыбора ключ(ИВыбираемый провод);

    /**
     * Return the число of ключи resulting из_ the registration of a провод
     * в_ the selector.
     */
    public abstract т_мера счёт();

    /**
     * Cast the время duration в_ a C значврем struct.
    */
    public значврем* вЗначВрем(значврем* tv, ИнтервалВремени интервал)
    in
    {
        assert(tv !is пусто);
    }
    body
    {
        tv.сек = cast(typeof(tv.сек)) интервал.сек;
        tv.микросек = cast(typeof(tv.микросек)) (интервал.micros % 1_000_000);
        return tv;
    }

    /**
     * Check the 'errno' global переменная из_ the C стандарт library and
     * throw an исключение with the descrИПtion of the ошибка.
     *
     * Параметры:
     * файл     = имя of the источник файл where the check is being made; you
     *            would normally use __FILE__ for this parameter.
     * строка     = строка число of the источник файл where this метод was called;
     *            you would normally use __LINE__ for this parameter.
     *
     * Throws:
     * ИсклРегистрируемогоПровода when the провод should not be registered
     * but it is (EEXIST); ИсклОтменённогоПровода when the провод
     * should be registered but it isn't (ENOENT);
     * ИсклПрерванногоСистВызова when a system вызов есть been interrupted
     * (EINTR); ВнеПамИскл if a память allocation fails (ENOMEM);
     * ИсклСелектора for any of the другой cases in which errno is not 0.
     */
    protected проц checkErrno(ткст файл, т_мера строка)
    {
        цел кодОшибки = дайНомош;
        switch (кодОшибки)
        {
            case EBADF:
                throw new ИсклСелектора("Bad файл descrИПtor", файл, строка);
                // break;
            case EEXIST:
                throw new ИсклРегистрируемогоПровода(файл, строка);
                // break;
            case EINTR:
                throw new ИсклПрерванногоСистВызова(файл, строка);
                // break;
            case EINVAL:
                throw new ИсклСелектора("An не_годится parameter was sent в_ a system вызов", файл, строка);
                // break;
            case ENFILE:
                throw new ИсклСелектора("Maximum число of открой файлы reached", файл, строка);
                // break;
            case ENOENT:
                throw new ИсклОтменённогоПровода(файл, строка);
                // break;
            case ENOMEM:
                throw new ВнеПамИскл(файл, строка);
                // break;
            case EPERM:
                throw new ИсклСелектора("The провод cannot be used with this Селектор", файл, строка);
                // break;
            default:
                throw new ИсклСелектора("Unknown Селектор ошибка: " ~ СисОш.найди(кодОшибки), файл, строка);
                // break;
        }
    }
}
