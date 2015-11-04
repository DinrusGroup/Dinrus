﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mar 2004 : Initial release
        version:        Jan 2005 : RedShodan patch for таймаут запрос
        version:        Dec 2006 : Outback release
        
        author:         Kris

*******************************************************************************/

module net.SocketConduit;

public  import  io.device.Conduit;

private import  net.Socket;

/*******************************************************************************

        A wrapper around the bare Сокет в_ implement the ИПровод abstraction
        and добавь сокет-specific functionality.

        СокетПровод данные-перемести is typically performed in conjunction with
        an ИБуфер, but can happily be handled directly using проц Массив where
        preferred
        
*******************************************************************************/

class СокетПровод : Провод, ИВыбираемый
{
        private значврем                 tv;
        private НаборСокетов               ss;
        package Сокет                  сокет_;
        private бул                    таймаут;

        // freelist support
        private СокетПровод           следщ;   
        private бул                    fromList;
        private static СокетПровод    freelist;

        /***********************************************************************
        
                Create a Потокing Internet Сокет

        ***********************************************************************/

        this ()
        {
                this (ПСемействоАдресов.ИНЕТ, ПТипСок.Поток, ППротокол.ПУТ);
        }

        /***********************************************************************
        
                Create an Internet Сокет with the provопрed characteristics

        ***********************************************************************/

        this (ПСемействоАдресов семейство, ПТипСок тип, ППротокол протокол)
        {
                this (семейство, тип, протокол, да);
        }

        /***********************************************************************
        
                Create an Internet Сокет. See метод размести() below

        ***********************************************************************/

        private this (ПСемействоАдресов семейство, ПТипСок тип, ППротокол протокол, бул создай)
        {
                сокет_ = new Сокет (семейство, тип, протокол, создай);
        }

        /***********************************************************************

                Return the имя of this устройство

        ***********************************************************************/

        override ткст вТкст()
        {
                return сокет.вТкст;
        }

        /***********************************************************************

                Return the сокет wrapper
                
        ***********************************************************************/

        Сокет сокет ()
        {
                return сокет_;
        }

        /***********************************************************************

                Return a preferred размер for buffering провод I/O

        ***********************************************************************/

        override т_мера размерБуфера ()
        {
                return 1024 * 8;
        }

        /***********************************************************************

                Models a укз-oriented устройство.

                TODO: figure out как в_ avoопр exposing this in the general
                case

        ***********************************************************************/

        Дескр ptr ()
        {
                return cast(Дескр) сокет_.ptr;
        }

        /***********************************************************************

                Набор the читай таймаут в_ the specified интервал. Набор a
                значение of zero в_ disable таймаут support.

                The интервал is in units of сек, where 0.500 would
                represent 500 milliseconds. Use ИнтервалВремени.интервал в_
                преобразуй из_ a ИнтервалВремени экземпляр.

        ***********************************************************************/

        СокетПровод установиТаймаут (плав таймаут)
        {
                tv.сек = cast(бцел) таймаут;
                tv.микросек = cast(бцел) ((таймаут - tv.сек) * 1_000_000);
                return this;
        }

        /***********************************************************************

                Dопр the последний operation результат in a таймаут? 

        ***********************************************************************/

        бул былТаймаут ()
        {
                return таймаут;
        }

        /***********************************************************************

                Is this сокет still alive?

        ***********************************************************************/

        override бул жив_ли ()
        {
                return сокет_.жив_ли;
        }

        /***********************************************************************

                Connect в_ the provопрed endpoint
        
        ***********************************************************************/

        СокетПровод подключись (адрес адр)
        {
                сокет_.подключись (адр);
                return this;
        }

        /***********************************************************************

                Bind the сокет. This is typically used в_ конфигурируй a
                listening сокет (such as a сервер or multicast сокет).
                The адрес given should describe a local адаптер, or
                specify the порт alone (АДР_ЛЮБОЙ) в_ have the OS присвой
                a local адаптер адрес.
        
        ***********************************************************************/

        СокетПровод свяжи (адрес адрес)
        {
                сокет_.свяжи (адрес);
                return this;
        }

        /***********************************************************************

                Inform другой конец of a подключен сокет that we're no longer
                available. In general, this should be invoked before закрой()
                is invoked
        
                The глуши function shuts down the connection of the сокет: 

                    -   stops receiving данные for this сокет. If further данные 
                        arrives, it is rejected.

                    -   stops trying в_ transmit данные из_ this сокет. Also
                        discards any данные waiting в_ be sent. Стоп looking for 
                        acknowledgement of данные already sent; don't retransmit 
                        if any данные is lost.

        ***********************************************************************/

        СокетПровод глуши ()
        {
                сокет_.глуши (ПЭкстрЗакрытиеСокета.Всё);
                return this;
        }

        /***********************************************************************

                Release this СокетПровод

                Note that one should always disconnect a СокетПровод 
                under нормаль conditions, and generally invoke глуши 
                on все подключен СОКЕТs beforehand

        ***********************************************************************/

        override проц открепи ()
        {
                сокет_.открепи;

                // deallocate if this came из_ the free-список,
                // otherwise just жди for the СМ в_ укз it
                if (fromList)
                    deallocate (this);
        }

       /***********************************************************************

                Чтен контент из_ the сокет. Note that the operation 
                may таймаут if метод установиТаймаут() есть been invoked with 
                a non-zero значение.

                Returns the число of байты читай из_ the сокет, or
                ИПровод.Кф where there's no ещё контент available.

                If the underlying сокет is a blocking сокет, Кф will 
                only be returned once the сокет есть закрыт.

                Note that a таймаут is equivalent в_ Кф. Isolating
                a таймаут condition can be achieved via былТаймаут()

                Note also that a zero return значение is not legitimate;
                such a значение indicates Кф

        ***********************************************************************/

        override т_мера читай (проц[] приёмн)
        {
                return читай (приёмн, (проц[] приёмн){return cast(т_мера) сокет_.принять(приёмн);});
        }
        
        /***********************************************************************

                Callback routine в_ пиши the provопрed контент в_ the
                сокет. This will stall until the сокет responds in
                some manner. Returns the число of байты sent в_ the
                вывод, or ИПровод.Кф if the сокет cannot пиши.

        ***********************************************************************/

        override т_мера пиши (проц[] ист)
        {
                цел счёт = сокет_.шли (ист);
                if (счёт <= 0)
                    счёт = Кф;
                return счёт;
        }

        /***********************************************************************
 
                Internal routine в_ укз сокет читай under a таймаут.
                Note that this is synchronized, in order в_ serialize
                сокет access

        ***********************************************************************/

        package final synchronized т_мера читай (проц[] приёмн, т_мера delegate(проц[]) дг)
        {
                // сбрось таймаут; we assume there's no нить contention
                таймаут = нет;

                // dопр пользователь disable таймаут checks?
                if (tv.микросек | tv.сек)
                   {
                   // nope: ensure we have a НаборСокетов
                   if (ss is пусто)
                       ss = new НаборСокетов (1);

                   ss.сбрось ();
                   ss.добавь (сокет_);

                   // жди until данные is available, or a таймаут occurs
                   auto копируй = tv;
version (linux)
{
                   // disable blocking в_ deal with potential linux bug
                   auto b = сокет.blocking;
                   if (b)
                       сокет.blocking (нет);
                   цел i = сокет_.выбери (ss, пусто, пусто, &копируй);
                   if (b)
                       сокет.blocking (да);                
}
else
                   цел i = сокет_.выбери (ss, пусто, пусто, &копируй);
                   if (i <= 0)
                      {
                      if (i is 0)
                          таймаут = да;
                      return Кф;
                      }
                   }       

                // invoke the actual читай op
                auto счёт = дг (приёмн);
                if (счёт <= 0)
                    счёт = Кф;
                return счёт;
        }
        
        /***********************************************************************

                Размести a СокетПровод из_ a список rather than creating
                a new one. Note that the сокет itself is not opened; only
                the wrappers. This is because the сокет is often assigned
                directly via прими()

        ***********************************************************************/

        package static synchronized СокетПровод размести ()
        {       
                СокетПровод s;

                if (freelist)
                   {
                   s = freelist;
                   freelist = s.следщ;
                   }
                else
                   {
                   s = new СокетПровод (ПСемействоАдресов.ИНЕТ, ПТипСок.Поток, ППротокол.ПУТ, нет);
                   s.fromList = да;
                   }
                return s;
        }

        /***********************************************************************

                Return this СокетПровод в_ the free-список

        ***********************************************************************/

        private static synchronized проц deallocate (СокетПровод s)
        {
                s.следщ = freelist;
                freelist = s;
        }
}


