/*******************************************************************************
  copyright:   Copyright (c) 2006 Juan Jose Comellas. все rights reserved
  license:     BSD стиль: $(LICENSE)
  author:      Juan Jose Comellas <juanjo@comellas.com.ar>
*******************************************************************************/

module io.selector.SelectSelector;

public import io.model;
public import io.selector.model;

private import io.selector.AbstractSelector;
private import io.selector.SelectorException;
private import sys.Common;

private import cidrus;

debug (selector)
{
    private import io.Stdout;
    private import text.convert.Integer;
}


version (Windows)
{
    private import thread;

    private
    {
        // Opaque struct
        struct набор_уд
        {
        }

        extern (C) цел выбери(цел nfds, набор_уд* readfds, набор_уд* writefds,
                                    набор_уд* errorfds, значврем* таймаут);
    }
}

version (Posix)
{
    private import core.BitArray;
}


/**
 * Селектор that uses the выбери() system вызов в_ принять I/O события for
 * the registered conduits. To use this class you would normally do
 * something like this:
 *
 * Examples:
 * ---
 * import io.selector.SelectSelector;
 *
 * Сокет сокет;
 * ИСелектор selector = new СелекторВыбора();
 *
 * selector.открой(100, 10);
 *
 * // Register в_ читай из_ сокет
 * selector.регистрируй(сокет, Событие.Чит);
 *
 * цел eventCount = selector.выбери(0.1); // 0.1 сек
 * if (eventCount > 0)
 * {
 *     // We can сейчас читай из_ the сокет
 *     сокет.читай();
 * }
 * else if (eventCount == 0)
 * {
 *     // Timeout
 * }
 * else if (eventCount == -1)
 * {
 *     // другой нить called the wakeup() метод.
 * }
 * else
 * {
 *     // Ошибка: should never happen.
 * }
 *
 * selector.закрой();
 * ---
 */
 
 
  
public class СелекторВыбора: АбстрактныйСелектор
{

 
    /**
     * Alias for the выбери() метод as we're not reimplementing it in
     * this class.
     */
    alias АбстрактныйСелектор.выбери выбери;

    бцел _size;
    private КлючВыбора[ИВыбираемый.Дескр] _keys;
    private НаборДескр _readSet;
    private НаборДескр _writeSet;
    private НаборДескр _exceptionSet;
    private НаборДескр _selectedReadSet;
    private НаборДескр _selectedWriteSet;
    private НаборДескр _selectedExceptionSet;
    цел _eventCount;
    version (Posix)
    {
        private ИВыбираемый.Дескр _maxfd = cast(ИВыбираемый.Дескр) -1;

        /**
         * Default число of КлючВыбора's that will be handled by the
         * СелекторВыбора.
         */
        public const бцел ДефРазмер = 1024;
    }
    else
    {
        /**
         * Default число of КлючВыбора's that will be handled by the
         * СелекторВыбора.
         */
        public const бцел ДефРазмер = 63;
    }

    /**
     * Открыть the выбери()-based selector.
     *
     * Параметры:
     * размер         = maximum amount of conduits that will be registered;
     *                it will grow dynamically if needed.
     * maxEvents    = maximum amount of провод события that will be
     *                returned in the выделение установи per вызов в_ выбери();
     *                this значение is currently not использован by this selector.
     */
    public проц открой(бцел размер = ДефРазмер, бцел maxEvents = ДефРазмер)
    in
    {
        assert(размер > 0);
    }
    body
    {
        _size = размер;
    }

    /**
     * Close the selector.
     *
     * Remarks:
     * It can be called multИПle times without harmful sопрe-effects.
     */
    public проц закрой()
    {
        _size = 0;
        _keys = пусто;
        _readSet = НаборДескр.init;
        _writeSet = НаборДескр.init;
        _exceptionSet = НаборДескр.init;
        _selectedReadSet = НаборДескр.init;
        _selectedWriteSet = НаборДескр.init;
        _selectedExceptionSet = НаборДескр.init;
    }

    private НаборДескр *разместиНабор(ref НаборДескр набор, ref НаборДескр наборВыд)
    {
        if(!набор.инициализован)
        {
            набор.установи(_size);
            наборВыд.установи(_size);
        }
        return &набор;
    }

    /**
     * Associate a провод в_ the selector и track specific I/O события.
     * If a провод is already associated with the selector, the события и
     * атачмент are upated.
     *
     * Параметры:
     * провод      = провод that will be associated в_ the selector;
     *                must be a действителен провод (i.e. not пусто и открой).
     * события       = bit маска of Событие значения that represent the события
     *                that will be tracked for the провод.
     * атачмент   = optional объект with application-specific данные that
     *                will be available when an событие is triggered for the
     *                провод
     *
     * Throws:
     * ИсклРегистрируемогоПровода if the провод had already been
     * registered в_ the selector.
     *
     * Examples:
     * ---
     * selector.регистрируй(провод, Событие.Чит | Событие.Зап, объект);
     * ---
     */
    public проц регистрируй(ИВыбираемый провод, Событие события, Объект атачмент = пусто)
    in
    {
        assert(провод !is пусто && провод.фукз());
    }
    body
    {
        ИВыбираемый.Дескр укз = провод.фукз();

        debug (selector)
            Стдвыв.форматируй("--- СелекторВыбора.регистрируй(укз={0}, события=0x{1:x})\n",
                          cast(цел) укз, cast(бцел) события);

        КлючВыбора *ключ = (укз in _keys);
        if (ключ !is пусто)
        {
            if ((события & Событие.Чит) || (события & Событие.Зависание))
            {
                разместиНабор(_readSet, _selectedReadSet).установи(укз);
            }
            else if (_readSet.инициализован)
            {
                _readSet.очисть(укз);
            }

            if ((события & Событие.Зап))
            {
                разместиНабор(_writeSet, _selectedWriteSet).установи(укз);
            }
            else if (_writeSet.инициализован)
            {
                _writeSet.очисть(укз);
            }

            if (события & Событие.Ошибка)
            {
                разместиНабор(_exceptionSet, _selectedExceptionSet).установи(укз);
            }
            else if (_exceptionSet.инициализован)
            {
                _exceptionSet.очисть(укз);
            }

            version (Posix)
            {
                if (укз > _maxfd)
                    _maxfd = укз;
            }

            ключ.события = события;
            ключ.атачмент = атачмент;
        }
        else
        {
            // Keep record of the Conduits for whom we're tracking события.
            _keys[укз] = КлючВыбора(провод, события, атачмент);

            if ((события & Событие.Чит) || (события & Событие.Зависание))
            {
                разместиНабор(_readSet, _selectedReadSet).установи(укз);
            }

            if (события & Событие.Зап)
            {
                разместиНабор(_writeSet, _selectedWriteSet).установи(укз);
            }

            if (события & Событие.Ошибка)
            {
                разместиНабор(_exceptionSet, _selectedExceptionSet).установи(укз);
            }

            version (Posix)
            {
                if (укз > _maxfd)
                    _maxfd = укз;
            }
        }
    }

    /**
     * Удали a провод из_ the selector.
     *
     * Параметры:
     * провод      = провод that had been previously associated в_ the
     *                selector; it can be пусто.
     *
     * Remarks:
     * Unregistering a пусто провод is allowed и no исключение is thrown
     * if this happens.
     *
     * Throws:
     * ИсклОтменённогоПровода if the провод had not been previously
     * registered в_ the selector.
     */
    public проц отмениРег(ИВыбираемый провод)
    {
        if (провод !is пусто)
        {
            ИВыбираемый.Дескр укз = провод.фукз();

            debug (selector)
                Стдвыв.форматируй("--- СелекторВыбора.отмениРег(укз={0})\n",
                              cast(цел) укз);

            КлючВыбора* removed = (укз in _keys);

            if (removed !is пусто)
            {
                if (removed.события & Событие.Ошибка)
                {
                    _exceptionSet.очисть(укз);
                }
                if (removed.события & Событие.Зап)
                {
                    _writeSet.очисть(укз);
                }
                if ((removed.события & Событие.Чит) || (removed.события & Событие.Зависание))
                {
                    _readSet.очисть(укз);
                }
                _keys.remove(укз);

                version (Posix)
                {
                    // If we're removing the biggest укз we've entered so far
                    // we need в_ recalculate this значение for the установи.
                    if (укз == _maxfd)
                    {
                        while (--_maxfd >= 0)
                        {
                            if (_readSet.набор_ли(_maxfd) ||
                                _writeSet.набор_ли(_maxfd) ||
                                _exceptionSet.набор_ли(_maxfd))
                            {
                                break;
                            }
                        }
                    }
                }
            }
            else
            {
                debug (selector)
                    Стдвыв.форматируй("--- СелекторВыбора.отмениРег(укз={0}): провод was не найден\n",
                                  cast(цел) провод.фукз());
                throw new ИсклОтменённогоПровода(__FILE__, __LINE__);
            }
        }
    }

    /**
     * Wait for I/O события из_ the registered conduits for a specified
     * amount of время.
     *
     * Параметры:
     * таймаут  = ИнтервалВремени with the maximum amount of время that the
     *            selector will жди for события из_ the conduits; the
     *            amount of время is relative в_ the текущ system время
     *            (i.e. just the число of milliseconds that the selector
     *            имеется в_ жди for the события).
     *
     * Возвращает:
     * The amount of conduits that have Приёмd события; 0 if no conduits
     * have Приёмd события внутри the specified таймаут; и -1 if the
     * wakeup() метод имеется been called из_ другой нить.
     *
     * Throws:
     * ИсклПрерванногоСистВызова if the underlying system вызов was
     * interrupted by a signal и the 'перезапускПрерванногоСистВызова'
     * property was установи в_ нет; ИсклСелектора if there were no
     * resources available в_ жди for события из_ the conduits.
     */
    public цел выбери(ИнтервалВремени таймаут)
    {
        набор_уд *readfds;
        набор_уд *writefds;
        набор_уд *exceptfds;
        значврем tv;
        version (Windows)
            бул handlesAvailable = нет;

        debug (selector)
            Стдвыв.форматируй("--- СелекторВыбора.выбери(таймаут={0} msec)\n", таймаут.миллисек);

        if (_readSet.инициализован)
        {
            debug (selector)
                _readSet.dump("_readSet");

            version (Windows)
                handlesAvailable = handlesAvailable || (_readSet.length > 0);

            readfds = cast(набор_уд*) _selectedReadSet.копируй(_readSet);
        }
        if (_writeSet.инициализован)
        {
            debug (selector)
                _writeSet.dump("_writeSet");

            version (Windows)
                handlesAvailable = handlesAvailable || (_writeSet.length > 0);

            writefds = cast(набор_уд*) _selectedWriteSet.копируй(_writeSet);
        }
        if (_exceptionSet.инициализован)
        {
            debug (selector)
                _exceptionSet.dump("_exceptionSet");

            version (Windows)
                handlesAvailable = handlesAvailable || (_exceptionSet.length > 0);

            exceptfds = cast(набор_уд*) _selectedExceptionSet.копируй(_exceptionSet);
        }

        version (Posix)
        {
            while (да)
            {
                вЗначВрем(&tv, таймаут);

                // FIXME: добавь support for the wakeup() вызов.
                _eventCount = .выбери(_maxfd + 1, readfds, writefds, exceptfds, таймаут is ИнтервалВремени.max ? пусто : &tv);

                debug (selector)
                    Стдвыв.форматируй("---   .выбери() returned {0} (максуд={1})\n",
                                  _eventCount, cast(цел) _maxfd);
                if (_eventCount >= 0)
                {
                    break;
                }
                else
                {
                    if (errno != EINTR || !_restartInterruptedSystemCall)
                    {
                        // проверьНомОш() always throws an исключение
                        проверьНомОш(__FILE__, __LINE__);
                    }
                    debug (selector)
                        Стдвыв.выведи("--- Restarting выбери() after being interrupted\n");
                }
            }
        }
        else
        {
            // Windows returns an ошибка when выбери() is called with все three
            // укз sets пустой, so we emulate the POSIX behavior by calling
            // Нить.сон().
            if (handlesAvailable)
            {
                вЗначВрем(&tv, таймаут);
			ИнтервалВремени инт;
                // FIXME: Can a system вызов be interrupted on Windows?
                _eventCount = .выбери(бцел.max, readfds, writefds, exceptfds, таймаут is инт.макс ? пусто : &tv);

                debug (selector)
                    Стдвыв.форматируй("---   .выбери() returned {0}\n", _eventCount);
            }
            else
            {
                Нить.спи(таймаут.интервал());
                _eventCount = 0;
            }
        }
        return _eventCount;
    }

    /**
     * Return the выделение установи resulting из_ the вызов в_ any of the
     * выбери() methods.
     *
     * Remarks:
     * If the вызов в_ выбери() was unsuccessful or it dопр not return any
     * события, the returned значение will be пусто.
     */
    public ИНаборВыделений наборВыд()
    {
        return (_eventCount > 0 ? new SelectSelectionSet(_keys, cast(бцел) _eventCount, _selectedReadSet,
                                                         _selectedWriteSet, _selectedExceptionSet) : пусто);
    }

    /**
     * Return the выделение ключ resulting из_ the registration of a
     * провод в_ the selector.
     *
     * Remarks:
     * If the провод is not registered в_ the selector the returned
     * значение will be пусто. No исключение will be thrown by this метод.
     */
    public КлючВыбора ключ(ИВыбираемый провод)
    {
        if(провод !is пусто)
        {
            if(auto k = провод.фукз() in _keys)
            {
                return *k;
            }
        }
        return КлючВыбора.init;
    }
    
    /**
     * Return the число of ключи resulting из_ the registration of a провод
     * в_ the selector.
     */
    public т_мера счёт()
    {
        return _keys.length;
    }
        
    /**
     * Iterate through the currently registered выделение ключи.  Note that
     * you should not erase or добавь any items из_ the selector while
     * iterating, although you can регистрируй existing conduits again.
     */
    цел opApply(цел delegate(ref КлючВыбора) дг)
    {
        цел результат = 0;
        foreach(v; _keys)
        {
            if((результат = дг(v)) != 0)
                break;
        }
        return результат;
    }
}

/**
 * SelectionSet for the выбери()-based Селектор.
 */
private class SelectSelectionSet: ИНаборВыделений
{
 
 
    КлючВыбора[ИВыбираемый.Дескр] _keys;
    бцел _eventCount;
    НаборДескр _readSet;
    НаборДескр _writeSet;
    НаборДескр _exceptionSet;

    this(КлючВыбора[ИВыбираемый.Дескр] ключи, бцел eventCount,
                   НаборДескр readSet, НаборДескр writeSet, НаборДескр exceptionSet)
    {
        _keys = ключи;
        _eventCount = eventCount;
        _readSet = readSet;
        _writeSet = writeSet;
        _exceptionSet = exceptionSet;
    }

    бцел длина()
    {
        return _eventCount;
    }

    цел opApply(цел delegate(ref КлючВыбора) дг)
    {
        цел rc = 0;
        ИВыбираемый.Дескр укз;
        Событие события;

        debug (selector)
            Стдвыв.форматируй("--- SelectSelectionSet.opApply() ({0} элементы)\n", _eventCount);

        foreach (КлючВыбора текущ; _keys)
        {
            укз = текущ.провод.фукз();

            if (_readSet.набор_ли(укз))
                события = Событие.Чит;
            else
                события = Событие.Нет;

            if (_writeSet.набор_ли(укз))
                события |= Событие.Зап;

            if (_exceptionSet.набор_ли(укз))
                события |= Событие.Ошибка;

            // Only invoke the delegate if there is an событие for the провод.
            if (события != Событие.Нет)
            {
                текущ.события = события;

                debug (selector)
                    Стдвыв.форматируй("---   Calling foreach delegate with выделение ключ ({0}, 0x{1:x})\n",
                                  cast(цел) укз, cast(бцел) события);

                if ((rc = дг(текущ)) != 0)
                {
                    break;
                }
            }
            else
            {
                debug (selector)
                    Стдвыв.форматируй("---   Дескр {0} doesn't have pending события\n",
                                  cast(цел) укз);
            }
        }
        return rc;
    }
}


version (Windows)
{
    /**
     * Helper class использован by the выбери()-based Селектор в_ сохрани handles.
     * On Windows the handles are kept in an Массив of бцелs и the первый
     * элемент of the Массив stores the Массив "length" (i.e. число of handles
     * in the Массив). Everything is stored so that the исконный выбери() API
     * can use the НаборДескр without добавьitional conversions by just casting it
     * в_ a набор_уд*.
     */
    private struct НаборДескр
    {
	 
        /** Default число of handles that will be held in the НаборДескр. */
        const бцел ДефРазмер = 63;

        бцел[] _buffer;

        /**
         * Constructor. Sets the начальное число of handles that will be held
         * in the НаборДескр.
         */
        проц установи(бцел размер = ДефРазмер)
        {
            _buffer = new бцел[1 + размер];
            _buffer[0] = 0;
        }

        /**
         *  return да if this укз установи имеется been инициализован.
         */
        бул инициализован()
        {
            return _buffer.length > 0;
        }

        /**
         * Return the число of handles present in the НаборДескр.
         */
        бцел length()
        {
            return _buffer[0];
        }

        /**
         * Добавь the укз в_ the установи.
         */
        проц установи(ИВыбираемый.Дескр укз)
        in
        {
            assert(укз);
        }
        body
        {
            if (!набор_ли(укз))
            {
                // If we добавьed too many СОКЕТs we инкремент the размер of the буфер
                if (++_buffer[0] >= _buffer.length)
                {
                    _buffer.length = _buffer[0] + 1;
                }
                _buffer[_buffer[0]] = cast(бцел) укз;
            }
        }

        /**
         * Удали the укз из_ the установи.
         */
        проц очисть(ИВыбираемый.Дескр укз)
        {
            for (бцел i = 1; i <= _buffer[0]; ++i)
            {
                if (_buffer[i] == cast(бцел) укз)
                {
                    // We don't need в_ keep the handles in the order in which
                    // they were inserted, so we оптимизируй the removal by
                    // copying the последний элемент в_ the позиция of the removed
                    // элемент.
                    if (i != _buffer[0])
                    {
                        _buffer[i] = _buffer[_buffer[0]];
                    }
                    _buffer[0]--;
                    return;
                }
            }
        }

        /**
         * Copy the contents of the НаборДескр преобр_в this экземпляр.
         */
        НаборДескр копируй(НаборДескр handleSet)
        {
            if(handleSet._buffer.length > _buffer.length)
            {
                _buffer.length = handleSet._buffer[0] + 1;
            }


            _buffer[] = handleSet._buffer[0.._buffer.length];
            return *this;
        }

        /**
         * Check whether the укз имеется been установи.
         */
        public бул набор_ли(ИВыбираемый.Дескр укз)
        {
            if(_buffer.length == 0)
                return нет;

            бцел* старт;
            бцел* stop;

            for (старт = _buffer.ptr + 1, stop = старт + _buffer[0]; старт != stop; старт++)
            {
                if (*старт == cast(бцел) укз)
                    return да;
            }
            return нет;
        }

        /**
         * Cast the текущ объект в_ a pointer в_ an набор_уд, в_ be использован with the
         * выбери() system вызов.
         */
        public набор_уд* opCast()
        {
            return cast(набор_уд*) _buffer.ptr;
        }


        debug (selector)
        {
            /**
             * Dump the contents of a НаборДескр преобр_в стдвыв.
             */
            проц dump(ткст имя = пусто)
            {
                if (_buffer !is пусто && _buffer.length > 0 && _buffer[0] > 0)
                {
                    ткст handleStr = new сим[16];
                    ткст handleListStr;
                    бул isFirst = да;

                    if (имя is пусто)
                    {
                        имя = "НаборДескр";
                    }

                    for (бцел i = 1; i < _buffer[0]; ++i)
                    {
                        if (!isFirst)
                        {
                            handleListStr ~= ", ";
                        }
                        else
                        {
                            isFirst = нет;
                        }

                        handleListStr ~= itoa(handleStr, _buffer[i]);
                    }

                    Стдвыв.форматнс("--- {0}[{1}]: {2}", имя, _buffer[0], handleListStr);
                }
            }
        }
    }
}
else version (Posix)
{
    private import core.BitManip;
	

    /**
     * Helper class использован by the выбери()-based Селектор в_ сохрани handles.
     * On POSIX-compatible platforms the handles are kept in an Массив of биты.
     * Everything is stored so that the исконный выбери() API can use the
     * НаборДескр without добавьitional conversions by casting it в_ a набор_уд*.
     */
    private struct НаборДескр
    {
	 
        /** Default число of handles that will be held in the НаборДескр. */
        const бцел ДефРазмер     = 1024;

        МассивБит _buffer;

        /**
         * Constructor. Sets the начальное число of handles that will be held
         * in the НаборДескр.
         */
        проц установи(бцел размер = ДефРазмер)
        {
            if (размер < 1024)
                размер = 1024;

            _buffer.length = размер;
        }

        /**
         * Return да if the handleset имеется been инициализован
         */
        бул инициализован()
        {
            return _buffer.length > 0;
        }

        /**
         * Добавь a укз в_ the установи.
         */
        public проц установи(ИВыбираемый.Дескр укз)
        {
            // If we добавьed too many СОКЕТs we инкремент the размер of the буфер
            бцел fd = cast(бцел)укз;
            if(fd >= _buffer.length)
                _buffer.length = fd + 1;
            _buffer[fd] = да;
        }

        /**
         * Удали a укз из_ the установи.
         */
        public проц очисть(ИВыбираемый.Дескр укз)
        {
            auto fd = cast(бцел)укз;
            if(fd < _buffer.length)
                _buffer[fd] = нет;
        }

        /**
         * Copy the contents of the НаборДескр преобр_в this экземпляр.
         */
        НаборДескр копируй(НаборДескр handleSet)
        {
            //
            // исправь the length if necessary
            //
            if(handleSet._buffer.length != _buffer.length)
                _buffer.length = handleSet._buffer.length;
            
            _buffer[] = handleSet._buffer;
            return *this;
        }

        /**
         * Check whether the укз имеется been установи.
         */
        бул набор_ли(ИВыбираемый.Дескр укз)
        {
            auto fd = cast(бцел)укз;
            if(fd < _buffer.length)
                return _buffer[fd];
            return нет;
        }

        /**
         * Cast the текущ объект в_ a pointer в_ an набор_уд, в_ be использован with the
         * выбери() system вызов.
         */
        набор_уд* opCast()
        {
            return cast(набор_уд*) _buffer.ptr;
        }

        debug (selector)
        {
            /**
             * Dump the contents of a НаборДескр преобр_в стдвыв.
             */
            проц dump(ткст имя = пусто)
            {
                if (_buffer !is пусто && _buffer.length > 0)
                {
                    ткст handleStr = new сим[16];
                    ткст handleListStr;
                    бул isFirst = да;

                    if (имя is пусто)
                    {
                        имя = "НаборДескр";
                    }

                    for (бцел i = 0; i < _buffer.length * _buffer[0].sizeof; ++i)
                    {
                        if (набор_ли(cast(ИВыбираемый.Дескр) i))
                        {
                            if (!isFirst)
                            {
                                handleListStr ~= ", ";
                            }
                            else
                            {
                                isFirst = нет;
                            }
                            handleListStr ~= itoa(handleStr, i);
                        }
                    }
                    Стдвыв.форматнс("--- {0}: {1}", имя, handleListStr);
                }
            }
        }
    }
}
