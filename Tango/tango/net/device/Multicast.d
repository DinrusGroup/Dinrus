/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Jun 2004 : Initial release 
        version:        Dec 2006 : South pacific version
        
        author:         Kris

*******************************************************************************/

module net.device.Multicast;

public  import  net.InternetAddress;
public  import  net.device.Datagram;

/******************************************************************************
        
        MulticastConduit Отправкаs and Приёмs данные on a multicast группа, as
        described by a class-D адрес. To шли данные, the реципиент группа
        should be handed в_ the пиши() метод. To принять, the сокет is
        bound в_ an available local адаптер/порт as a listener and must
        объедини() the группа before it becomes eligible for ввод из_ there. 

        While MulticastConduit is a flavour of datagram, it doesn't support
        being подключен в_ a specific endpoint.

        Отправкаing and receiving via a multicast группа:
        ---
        auto группа = new АдресИнтернета ("225.0.0.10", 8080);

        // слушай for datagrams on the группа адрес (via порт 8080)
        auto multi = new MulticastConduit (группа);

        // объедини and broadcast в_ the группа
        multi.объедини.пиши ("hello", группа);

        // we are listening also ...
        сим[8] врем;
        auto байты = multi.читай (врем);
        ---

        Note that this example is expecting в_ принять its own broadcast;
        thus it may be necessary в_ enable лупбэк operation (see below)
        for successful receИПt of the broadcast.

        Note that class D адресes range из_ 225.0.0.0 в_ 239.255.255.255

        see: http://www.kohala.com/старт/mcast.api.txt
                
*******************************************************************************/

class Мультикаст : Датаграмма
{
        private АдресИнтернета группа;

        enum {Хост=0, Подсеть=1, Сайт=32, Регион=64, Континент=128, Неограниченно=255}

        /***********************************************************************
        
                Create a записываемый multicast сокет

        ***********************************************************************/

        this ()
        {
                super ();
        }

        /***********************************************************************
        
                Create a читай/пиши multicast сокет

                This flavour is necessary only for a multicast Приёмr
                (e.g. use this ctor in conjunction with СОКЕТListener).

                You should specify Всё a группа адрес and a порт в_ 
                слушай upon. The resultant сокет will be bound в_ the
                specified порт (locally), and listening on the class-D
                адрес. Икспект this в_ краш without a network адаптер
                present, as свяжи() will not найди anything в_ work with.

                The reuse parameter dictates как в_ behave when the порт
                is already in use. Default behaviour is в_ throw an IO
                исключение, and the alternate is в_ force usage.
                
                To become eligible for incoming группа datagrams, you must
                also invoke the объедини() метод

        ***********************************************************************/

        this (АдресИнтернета группа, бул reuse = нет)
        {
                super ();

                this.группа = группа;
                /* Posix also seems в_ require в_ свяжи в_ the specific группа, while
                 * Windows does not allow binding в_ multicast groups. The most
                 * portable way seems в_ always свяжи for posix, but not for другой
                 * systems.
                 * Reference; http://markmail.org/нить/co53qzbsvqivqxgc
                 */
                version (Posix) {
                    исконный.повторнИспАдреса(reuse).свяжи(группа);
                } else {
                    исконный.повторнИспАдреса(reuse).свяжи(new АдресИнтернета(группа.порт));
                }
        }
        
        /***********************************************************************
                
                Enable/disable the receИПt of multicast packets sent
                из_ the same адаптер. The default состояние is OS specific

        ***********************************************************************/

        Мультикаст лупбэк (бул да = да)
        {
                бцел[1] onoff = да;
                исконный.установиОпцию (ППротокол.ИП, ПОпцияСокета.MULTICAST_LOOP, onoff);
                return this;
        }

        /***********************************************************************
                
                Набор the число of hops (время в_ live) of this сокет. 
                Convenient values are
                ---
                Хост:           packets are restricted в_ the same хост
                Подсеть:         packets are restricted в_ the same subnet
                Сайт:           packets are restricted в_ the same site
                Регион:         packets are restricted в_ the same region
                Континент:      packets are restricted в_ the same continent
                Неограниченно:   packets are unrestricted in scope
                ---

        ***********************************************************************/

        Мультикаст ttl (бцел значение=Подсеть)
        {
                бцел[1] options = значение;
                исконный.установиОпцию (ППротокол.ИП, ПОпцияСокета.MULTICAST_TTL, options);
                return this;
        }

        /***********************************************************************

                Добавь this сокет в_ the listening группа 

        ***********************************************************************/

        Мультикаст объедини ()
        {
                исконный.включиВГруппу (группа, да);
                return this;
        }

        /***********************************************************************
        
                Удали this сокет из_ the listening группа

        ***********************************************************************/

        Мультикаст покинь ()
        {
                исконный.включиВГруппу (группа, нет);
                return this;
        }
}


/******************************************************************************

*******************************************************************************/

debug (Мультикаст)
{
        import io.Console;

        проц main()
        {
                auto группа = new АдресИнтернета ("225.0.0.10", 8080);

                // слушай for datagrams on the группа адрес
                auto multi = new Мультикаст (группа);

                // объедини and broadcast в_ the группа
                multi.объедини.пиши ("hello", группа);

                // we are listening also ...
                сим[8] врем;
                auto байты = multi.читай (врем);
                Квывод (врем[0..байты]).нс;
        }
}
