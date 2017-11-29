/*******************************************************************************
  copyright:   Copyright (c) 2006 Juan Jose Comellas. все rights reserved
  license:     BSD стиль: $(LICENSE)
  author:      Juan Jose Comellas <juanjo@comellas.com.ar>
*******************************************************************************/

module io.selector.EpollSelector;


version (linux)
{
    public import io.model;
    public import io.selector.model;

    private import io.selector.AbstractSelector;
    private import sys.Common;
    private import sys.linux.linux;
    private import cidrus;

    debug (selector)
        private import io.Stdout;


    /**
     * Селектор that uses the Linux epoll* семейство of system calls.
     *
     * This selector is the best опция when dealing with large amounts of
     * conduits under Linux. It will шкала much better than any of the другой
     * опции (PollSelector, СелекторВыбора). For small amounts of conduits
     * (n < 20) the PollSelector will probably be ещё performant.
     *
     * See_Also: ИСелектор, АбстрактныйСелектор
     *
     * Examples:
     * ---
     * import io.selector.EpollSelector;
     * import net.device.Socket;
     * import io.Stdout;
     *
     * СокетПровод conduit1;
     * СокетПровод conduit2;
     * EpollSelector selector = new EpollSelector();
     * MyClass object1 = new MyClass();
     * MyClass object2 = new MyClass();
     * бцел eventCount;
     *
     * // Initialize the selector assuming that it will deal with 10 conduits и
     * // will принять 3 события per invocation в_ the выбери() метод.
     * selector.открой(10, 3);
     *
     * selector.регистрируй(conduit1, Событие.Чит, object1);
     * selector.регистрируй(conduit2, Событие.Зап, object2);
     *
     * eventCount = selector.выбери();
     *
     * if (eventCount > 0)
     * {
     *     сим[16] буфер;
     *     цел счёт;
     *
     *     foreach (КлючВыбора ключ; selector.наборВыд())
     *     {
     *         if (ключ.читаем_ли())
     *         {
     *             счёт = (cast(СокетПровод) ключ.провод).читай(буфер);
     *             if (счёт != ИПровод.Кф)
     *             {
     *                 Стдвыв.форматируй("Приёмd '{0}' из_ peer\n", буфер[0..счёт]);
     *                 selector.регистрируй(ключ.провод, Событие.Зап, ключ.атачмент);
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
     *                 Стдвыв("Sent 'MESSAGE' в_ peer");
     *                 selector.регистрируй(ключ.провод, Событие.Чит, ключ.атачмент);
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
	  
    public class EpollSelector: АбстрактныйСелектор
    {
	 
        /**
         * Alias for the выбери() метод as we're not reimplementing it in 
         * this class.
         */
        alias АбстрактныйСелектор.выбери выбери;

        /**
         * Default число of КлючВыбора's that will be handled by the
         * EpollSelector.
         */
        public const бцел ДефРазмер = 64;
        /**
         * Default maximum число of события that will be Приёмd per
         * invocation в_ выбери().
         */
        public const бцел DefaultMaxEvents = 16;


        /** Карта в_ associate the провод handles with their выделение ключи */
        private КлючВыбора[ИВыбираемый.фукз] _keys;
        /** Файл descrИПtor returned by the epoll_create() system вызов. */
        private цел _epfd = -1;
        /**
         * Массив of события that is filled by epoll_wait() insопрe the вызов
         * в_ выбери().
         */
        private epoll_event[] _events;
        /**
         * Persistent ИНаборВыделений-impl.
         */
        private ИНаборВыделений _selectionSetIface;
        /** Число of события resulting из_ the вызов в_ выбери() */
        private цел _eventCount = 0;


        /**
         * Destructor
         */
        ~this()
        {
            // Make sure that we release the epoll файл descrИПtor once this
            // объект is garbage собериed.
            закрой();
        }

        /**
         * Открыть the epoll selector, makes a вызов в_ epoll_create()
         *
         * Параметры:
         * размер         = maximum amount of conduits that will be registered;
         *                it will grow dynamically if needed.
         * maxEvents    = maximum amount of провод события that will be
         *                returned in the выделение установи per вызов в_ выбери();
         *                this предел is enforced by this selector.
         *
         * Throws:
         * ИсклСелектора if there are not enough resources в_ открой the
         * selector (e.g. not enough файл handles or память available).
         */
        public проц открой(бцел размер = ДефРазмер, бцел maxEvents = DefaultMaxEvents)
        in
        {
            assert(размер > 0);
            assert(maxEvents > 0);
        }
        body
        {
            _events = new epoll_event[maxEvents];
            _selectionSetIface = new EpollSelectionSet;

            _epfd = epoll_create(cast(цел) размер);
            if (_epfd < 0)
            {
                проверьНомОш(__FILE__, __LINE__);
            }
        }

        /**
         * Close the selector, releasing the файл descrИПtor that had been
         * создан in the previous вызов в_ открой().
         *
         * Remarks:
         * It can be called multИПle times without harmful sопрe-effects.
         */
        public проц закрой()
        {
            if (_epfd >= 0)
            {
                .закрой(_epfd);
                _epfd = -1;
            }
            _events = пусто;
            _eventCount = 0;
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
         * Associate a провод в_ the selector и track specific I/O события.
         * If a провод is already associated, changes the события и
         * атачмент.
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
         * registered в_ the selector; ИсклСелектора if there are not
         * enough resources в_ добавь the провод в_ the selector.
         *
         * Examples:
         * ---
         * selector.регистрируй(провод, Событие.Чит | Событие.Зап, объект);
         * ---
         */
        public проц регистрируй(ИВыбираемый провод, Событие события, Объект атачмент = пусто)
        in
        {
            assert(провод !is пусто && провод.фукз() >= 0);
        }
        body
        {
            auto ключ = провод.фукз() in _keys;

            if (ключ !is пусто)
            {
                epoll_event событие;

                ключ.события = события;
                ключ.атачмент = атачмент;

                событие.события = события;
                событие.данные.фукз = cast(ук) ключ;

                if (epoll_ctl(_epfd, EPOLL_CTL_MOD, провод.фукз(), &событие) != 0)
                {
                    проверьНомОш(__FILE__, __LINE__);
                }
            }
            else
            {
                epoll_event     событие;
                КлючВыбора    newkey = КлючВыбора(провод, события, атачмент);

                событие.события = события;

                // We associate the выделение ключ в_ the epoll_event в_ be
                // able в_ retrieve it efficiently when we получи события for
                // this укз.
                // We keep the ключи in a карта в_ сделай sure that the ключ is not
                // garbage собериed while there is still a reference в_ it in
                // an epoll_event. This also allows в_ в_ efficiently найди the
                // ключ corresponding в_ a укз in methods where this
                // association is not provопрed automatically.
                _keys[провод.фукз()] = newkey;
                auto x = провод.фукз in _keys;
                событие.данные.фукз = cast(ук) x;
                if (epoll_ctl(_epfd, EPOLL_CTL_добавь, провод.фукз(), &событие) != 0)
                {
                    // неудачно, удали the файл descrИПtor из_ the ключи Массив,
                    // и throw an ошибка.
                    _keys.удали(провод.фукз);
                    проверьНомОш(__FILE__, __LINE__);
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
         * registered в_ the selector; ИсклСелектора if there are not
         * enough resources в_ удали the провод registration.
         */
        public проц отмениРег(ИВыбираемый провод)
        {
            if (провод !is пусто)
            {
                if (epoll_ctl(_epfd, EPOLL_CTL_DEL, провод.фукз(), пусто) == 0)
                {
                    _keys.удали(провод.фукз());
                }
                else
                {
                    проверьНомОш(__FILE__, __LINE__);
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
            цел в_ = (таймаут != ИнтервалВремени.max ? cast(цел) таймаут.миллисек : -1);

            while (да)
            {
                // FIXME: добавь support for the wakeup() вызов.
                _eventCount = epoll_wait(_epfd, _events.ptr, _events.length, в_);
                if (_eventCount >= 0)
                {
                    break;
                }
                else
                {
                    if (errno != EINTR || !_restartInterruptedSystemCall)
                    {
                        проверьНомОш(__FILE__, __LINE__);
                    }
                    debug (selector)
                        Стдвыв("--- Restarting epoll_wait() after being interrupted by a signal\n");
                }
            }
            return _eventCount;
        }

        /**
        * Class использован в_ hold the список of Conduits that have Приёмd события.
        * See_Also: ИНаборВыделений
        */
        protected class EpollSelectionSet: ИНаборВыделений
        {
            public бцел length()
            {
                return _events.length;
            }

            /**
            * Iterate over все the Conduits that have Приёмd события.
            */
            public цел opApply(цел delegate(ref КлючВыбора) дг)
            {
                цел rc = 0;
                КлючВыбора ключ;

                debug (selector)
                    Стдвыв.форматируй("--- EpollSelectionSet.opApply() ({0} события)\n", _events.length);

                foreach (epoll_event событие; _events[0.._eventCount])
                {
                    // Only invoke the delegate if there is an событие for the провод.
                    if (событие.события != 0)
                    {
                        ключ = *(cast(КлючВыбора *)событие.данные.ptr);
                        ключ.события = cast(Событие) событие.события;

                        debug (selector)
                            Стдвыв.форматируй("---   Событие 0x{0:x} for укз {1}\n",
                                        cast(бцел) событие.события, cast(цел) ключ.провод.фукз());

                        rc = дг(ключ);
                        if (rc != 0)
                        {
                            break;
                        }
                    }
                }
                return rc;
            }
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
            return (_eventCount > 0 ? _selectionSetIface : пусто);
        }

        /**
         * Return the выделение ключ resulting из_ the registration of a провод
         * в_ the selector.
         *
         * Remarks:
         * If the провод is not registered в_ the selector the returned
         * значение will КлючВыбора.init. No исключение will be thrown by this
         * метод.
         */
        public КлючВыбора ключ(ИВыбираемый провод)
        {
            if(провод !is пусто)
            {
                if(auto k = провод.фукз in _keys)
                {
                    return *k;
                }
            }
            return КлючВыбора.init;
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

        unittest
        {
        }
    }
}

