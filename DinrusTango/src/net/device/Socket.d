﻿
module net.device.Socket;

public import io.device.Conduit, net.device.Berkeley;

/*******************************************************************************

        Обёртка Беркли API, реализующая абстракцию ИПровод 
        и добавляющая потокоспецифичную функциональность.

*******************************************************************************/

class Сокет : Провод, ИВыбираемый
{
        public alias исконный сокет;             // обратная совместимость

        private НаборСокетов pending;              // синхронно timeouts   
        private Беркли  беркли;             // wrap a беркли сокет


        /// see super.таймаут(цел)
        deprecated проц установиТаймаут (дво t) 
        {
                таймаут = cast(бцел) (t * 1000);
        }

        deprecated бул былТаймаут ()
        {
                return нет;
        }

        /***********************************************************************
        
                Созд a Потокing Internet сокет

        ***********************************************************************/

        this ()
        {
                this (ПСемействоАдресов.ИНЕТ, ПТипСок.Поток, ППротокол.ПУТ);
        }

		
		/***********************************************************************
        
                Созд an Internet сокет

        ***********************************************************************/

        this (ПСемействоАдресов семейство, ПТипСок тип, ППротокол протокол)
        {
                беркли.открой (семейство, тип, протокол);
                version (Windows)
                         if (планировщик)
                             планировщик.открой (фукз, вТкст);
        }
		
        /***********************************************************************
        
                Созд an Internet Сокет with the предоставленный characteristics

        ***********************************************************************/

        this (Адрес адр) 
        { 
                this (адр.семействоАдресов, ПТипСок.Поток, ППротокол.ПУТ); 
        }
                                


        /***********************************************************************

                Return the имя of this устройство

        ***********************************************************************/

        override ткст вТкст()
        {
                return "<сокет>";
        }

        /***********************************************************************

                Models a укз-oriented устройство. 

                TODO: figure out как в_ avoопр exposing this in the general
                case

        ***********************************************************************/

        Дескр фукз ()
        {
                return cast(Дескр) беркли.сок;
        }

        /***********************************************************************

                Return the сокет wrapper
                
        ***********************************************************************/

        Беркли* исконный ()
        {
                return &беркли;
        }

        /***********************************************************************

                Return a preferred размер for buffering провод I/O

        ***********************************************************************/

        override т_мера размерБуфера ()
        {
                return 1024 * 8;
        }

        /***********************************************************************

                Connect в_ the предоставленный endpoint
        
        ***********************************************************************/

        Сокет подключись (ткст адрес, бцел порт)
        {
                scope адр = new АдресИПв4 (адрес, порт);
                return подключись (адр);
        }

        /***********************************************************************

                Connect в_ the предоставленный endpoint
        
        ***********************************************************************/

        Сокет подключись (Адрес адр)
        {
                if (планировщик)
                    асинхСвязь (адр);
                else
                   исконный.подключись (адр);
                return this;
        }

        /***********************************************************************

                Bind this сокет. This is typically использован в_ конфигурируй a
                listening сокет (such as a сервер or multicast сокет).
                The адрес given should describe a local адаптер, or
                specify the порт alone (АДР_ЛЮБОЙ) в_ have the OS присвой
                a local адаптер адрес.
        
        ***********************************************************************/

        Сокет вяжи (Адрес адрес)
        {
                беркли.вяжи (адрес);
                return this;
        }

        /***********************************************************************

                Inform другой конец of a подключен сокет that we're no longer
                available. In general, this should be invoked before закрой()
        
                The глуши function shuts down the connection of the сокет: 

                    -   stops receiving данные for this сокет. If further данные 
                        arrives, it is rejected.

                    -   stops trying в_ transmit данные из_ this сокет. Also
                        discards any данные waiting в_ be sent. Стоп looking for 
                        acknowledgement of данные already sent; don't retransmit 
                        if any данные is lost.

        ***********************************************************************/

        Сокет глуши ()
        {
                беркли.глуши (ПЭкстрЗакрытиеСокета.Всё);
                return this;
        }

        /***********************************************************************

                Release this Сокет

                Note that one should always disconnect a Сокет under 
                нормаль conditions, и generally invoke глуши on все 
                подключен СОКЕТs beforehand

        ***********************************************************************/

        override проц открепи ()
        {
                беркли.открепи;
        }
        
       /***********************************************************************

                Чит контент из_ the сокет. Note that the operation 
                may таймаут if метод установиТаймаут() имеется been invoked with 
                a non-zero значение.

                Returns the число of байты читай из_ the сокет, or
                ИПровод.Кф where there's no ещё контент available.

        ***********************************************************************/

        override т_мера читай (проц[] приёмн)
        {
                if (планировщик)
                    return асинхЧтение (приёмн);

                auto x = Кф;
                if (жди (да))
                   {
                   x = исконный.принять (приёмн);
                   if (x <= 0)
                       x = Кф;
                   }
                return x;                        
        }
        
        /***********************************************************************

        ***********************************************************************/

        override т_мера пиши (проц[] ист)
        {
                if (планировщик)
                    return асинхЗапись (ист);

                auto x = Кф;
                if (жди (нет))
                   {
                   x = исконный.шли (ист);
                   if (x < 0)
                       x = Кф;
                   }
                return x;                        
        }

        /***********************************************************************

                Transfer the контент of другой провод в_ this one. Returns
                the приёмн ИПотокВывода, or throws ВВИскл on failure.

                Does optimized transfers 

        ***********************************************************************/

        override ИПотокВывода копируй (ИПотокВвода ист, т_мера max = -1)
        {
                auto x = cast(ИВыбираемый) ист;

                if (планировщик && x)
                    асинхКопия (x.фукз);
                else
                   super.копируй (ист, max);
                return this;
        }

        /***********************************************************************
 
                Manage сокет IO under a таймаут

        ***********************************************************************/

        package final бул жди (бул reading)
        {
                // dопр пользователь активируй таймаут проверьs?
                if (таймаут != -1)
                   {
                   НаборСокетов читай, пиши;

                   // да, ensure we have a НаборСокетов
                   if (pending is пусто)
                       pending = new НаборСокетов (1);
                   pending.сбрось.добавь (исконный.сок);

                   // жди until IO is available, or a таймаут occurs
                   if (reading)
                       читай = pending;
                   else
                      пиши = pending;
                   цел i = pending.выбери (читай, пиши, пусто, таймаут * 1000);
                   if (i <= 0)
                      {
                      if (i is 0)
                          super.ошибка ("Сокет :: запрос таймаута");
                      return нет;
                      }
                   }       
                return да;
        }

        /***********************************************************************

                Throw an ВВИскл noting the последний ошибка
        
        ***********************************************************************/

        final проц ошибка ()
        {
                super.ошибка (this.вТкст ~ " :: " ~ СисОш.последнСооб);
        }

        /***********************************************************************
 
        ***********************************************************************/

        version (Win32)
        {
                private АСИНХРОН overlapped;
        
                /***************************************************************
        
                        Подключиться к предоставленной конечной точке
                
                ***************************************************************/
        
                private проц асинхСвязь (Адрес адр)
                {
                        АдресИПв4.сокадр_ин local;
        
                        auto укз = беркли.сок;
                        net.device.Berkeley.свяжисок(cast(СОКЕТ) укз, cast(адрессок*)&local, local.sizeof);
        
                        ConnectEx (укз, адр.имя, адр.длинаИмени, пусто, 0, пусто, &overlapped);
                        жди (планировщик.Тип.Подключение);
                        патч (укз, SO_UPDATE_CONNECT_CONTEXT);
                }
        
                /***************************************************************
        
                ***************************************************************/
        
                private проц асинхКопия (Дескр укз)
                {
                        TransmitFile (беркли.сок, cast(HANDLE) укз, 
                                      0, 0, &overlapped, пусто, 0);
                        if (жди (планировщик.Тип.Трансфер) is Кф)
                            беркли.исключение ("Сокет.копируй :: ");
                }

                /***************************************************************

                        Чит a чанк of байты из_ the файл преобр_в the предоставленный
                        Массив. Returns the число of байты читай, or Кф where 
                        there is no further данные.

                        Operates asynchronously where the hosting нить is
                        configured in that manner.

                ***************************************************************/

                private т_мера асинхЧтение (проц[] приёмн)
                {
                        DWORD флаги;
                        DWORD байты;
                        WSABUF буф = {приёмн.length, приёмн.ptr};

                        WSARecv (cast(HANDLE) беркли.сок, &буф, 1, &байты, &флаги, &overlapped, пусто);
                        if ((байты = жди (планировщик.Тип.Чтение, байты)) is Кф)
                             return Кф;

                        // читай of zero means Кф
                        if (байты is 0 && приёмн.length > 0)
                            return Кф;
                        return байты;
                }

                /***************************************************************

                        Зап a чанк of байты в_ the файл из_ the предоставленный
                        Массив. Returns the число of байты записано, or Кф if 
                        the вывод is no longer available.

                        Operates asynchronously where the hosting нить is
                        configured in that manner.

                ***************************************************************/

                private т_мера асинхЗапись (проц[] ист)
                {
                        DWORD байты;
                        WSABUF буф = {ист.length, ист.ptr};

                        WSASend (cast(HANDLE) беркли.сок, &буф, 1, &байты, 0, &overlapped, пусто);
                        if ((байты = жди (планировщик.Тип.Запись, байты)) is Кф)
                             return Кф;
                        return байты;
                }

                /***************************************************************

                ***************************************************************/

                private т_мера жди (планировщик.Тип тип, бцел байты=0)
                {
                        while (да)
                              {
                              auto код = ВСАДайПоследнююОшибку;
                              if (код is ERROR_HANDLE_EOF ||
                                  код is ERROR_BROKEN_PIPE)
                                  return Кф;

                              if (планировщик)
                                 {
                                 if (код is ERROR_SUCCESS || 
                                     код is ERROR_IO_PENDING || 
                                     код is ERROR_IO_INCOMPLETE)
                                    {
                                    DWORD флаги;

                                    if (код is ERROR_IO_INCOMPLETE)
                                        super.ошибка ("таймаут"); 

                                    auto укз = фукз;
                                    планировщик.ожидай (укз, тип, таймаут);
                                    if (WSAGetOverlappedResult (укз, &overlapped, &байты, нет, &флаги))
                                        return байты;
                                    }
                                 else
                                    ошибка;
                                 }
                              else
                                 if (код is ERROR_SUCCESS)
                                     return байты;
                                 else
                                    ошибка;
                              }
                        // should never получи here
                        assert (нет);
                }
        
                /***************************************************************
        
                ***************************************************************/
        
                private static проц патч (т_сокет приёмн, бцел как, т_сокет* ист=пусто)
                {
                        auto длин = ист ? ист.sizeof : 0;
                        if (установиопцсок (приёмн, ППротокол.СОКЕТ, как, ист, длин))
                            беркли.исключение ("патч :: ");
                }
        }


        /***********************************************************************
 
        ***********************************************************************/

        version (Posix)
        {
                /***************************************************************
        
                        Connect в_ the предоставленный endpoint
                
                ***************************************************************/
        
                private проц асинхСвязь (Адрес адр)
                {
                        assert (нет);
                }
        
                /***************************************************************
        
                ***************************************************************/
        
                Сокет асинхКопия (Дескр файл)
                {
                        assert (нет);
                }

                /***************************************************************

                        Чит a чанк of байты из_ the файл преобр_в the предоставленный
                        Массив. Returns the число of байты читай, or Кф where 
                        there is no further данные.

                        Operates asynchronously where the hosting нить is
                        configured in that manner.

                ***************************************************************/

                private т_мера асинхЧтение (проц[] приёмн)
                {
                        assert (нет);
                }

                /***************************************************************

                        Зап a чанк of байты в_ the файл из_ the предоставленный
                        Массив. Returns the число of байты записано, or Кф if 
                        the вывод is no longer available.

                        Operates asynchronously where the hosting нить is
                        configured in that manner.

                ***************************************************************/

                private т_мера асинхЗапись (проц[] ист)
                {
                        assert (нет);
                }
        }
}



/*******************************************************************************


*******************************************************************************/

class СерверСокет : Сокет
{      
        /***********************************************************************

        ***********************************************************************/

        this (бцел порт, цел backlog=32, бул reuse=нет)
        {
                scope адр = new АдресИПв4 (cast(бкрат) порт);
                this (адр, backlog, reuse);
        }

        /***********************************************************************

        ***********************************************************************/

        this (Адрес адр, цел backlog=32, бул reuse=нет)
        {
                super (адр);
                беркли.повторнИспАдреса(reuse).вяжи(адр).слушай(backlog);
        }

        /***********************************************************************

                Return the имя of this устройство

        ***********************************************************************/

        override ткст вТкст()
        {
                return "<прими>";
        }

        /***********************************************************************

        ***********************************************************************/

        Сокет прими (Сокет реципиент = пусто)
        {
                if (реципиент is пусто)
                    реципиент = new Сокет;

                if (планировщик)
                    asyncAccept (реципиент);
                else              
                   беркли.прими (реципиент.беркли);
                
                реципиент.таймаут = таймаут;
                return реципиент;
        }

        /***********************************************************************

        ***********************************************************************/

        version (Windows)
        {
                /***************************************************************

                ***************************************************************/

                private проц asyncAccept (Сокет реципиент)
                {
                        байт[128]      врем;
                        DWORD          байты;
                        DWORD          флаги;

                        auto мишень = реципиент.беркли.сок;
                        AcceptEx (беркли.сок, мишень, врем.ptr, 0, 64, 64, &байты, &overlapped);
                        жди (планировщик.Тип.Приём);
                        патч (мишень, SO_UPDATE_ACCEPT_CONTEXT, &беркли.сок);
                }
        }

        /***********************************************************************

        ***********************************************************************/

        version (Posix)
        {
                /***************************************************************

                ***************************************************************/

                private проц asyncAccept (Сокет реципиент)
                {
                        assert (нет);
                }
        }
}

