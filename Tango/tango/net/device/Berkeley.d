module net.device.Berkeley;

private import sys.Common;

private import exception;

import  consts=sys.consts.socket;

private import stringz;

/*******************************************************************************

*******************************************************************************/

private extern(C) цел strlen(сим*);

/*******************************************************************************

*******************************************************************************/

enum {СОКОШИБ = consts.СОКОШИБ}

/*******************************************************************************

*******************************************************************************/

enum ПОпцияСокета
{
        DEBUG        =   consts.Отладка     ,       /* turn on debugging инфо recording */
        BROADCAST    =   consts.Вещание ,       /* permit Отправкаing of broadcast msgs */
        REUSEADDR    =   consts.ПереиспАдр ,       /* allow local адрес reuse */
        заминка       =   consts.Заминка    ,       /* заминка on закрой if данные present */
        DONTзаминка   = ~(consts.Заминка),
        
        СПДINLINE    =   consts.СПДИнлайнинг ,       /* покинь Приёмd СПД данные in строка */
        ACCEPTCONN   =   consts.Прослушивается,       /* сокет есть had слушай() */
        KEEPALIVE    =   consts.ОставатьсяНаСвязи ,       /* keep connections alive */
        НеМаршрутизировать    =   consts.НеМаршрутизировать ,       /* just use interface адресes */
        TYPE         =   consts.Тип      ,       /* получи сокет тип */
    
        /*
         * добавьitional options, not kept in so_options.
         */
        SNDBUF       = consts.ОтправБуф,               /* шли буфер размер */
        RCVBUF       = consts.ПолучБуф,               /* принять буфер размер */
        ERROR        = consts.Ошибка ,               /* получи ошибка статус and сотри */

        // OptionУровень.ИП settings
        MULTICAST_TTL   = consts.ИПВ6МультикастХопс  ,
        MULTICAST_LOOP  = consts.ИПВ6МультикастЦикл ,
        ADD_MEMBERSHИП  = consts.ИПВ6ВГруппу ,
        DROP_MEMBERSHИП = consts.ИПВ6ИзГруппы,
    
        // OptionУровень.ПУТ settings
        ПУТБезЗадержек     = consts.ПУТБезЗадержек ,

        // Windows specifics    
        WIN_UPDATE_ACCEPT_CONTEXT  = 0x700B, 
        WIN_CONNECT_TIME           = 0x700C, 
        WIN_UPDATE_CONNECT_CONTEXT = 0x7010, 
}
    
/*******************************************************************************

*******************************************************************************/

enum ППротокол
{
        СОКЕТ = consts.SOL_СОКЕТ    ,
        ИП     = consts.ИППРОТ_ИП    ,   
        ПУТ    = consts.ИППРОТ_ПУТ   ,   
        ППД    = consts.ИППРОТ_ППД   ,   
}
    
/*******************************************************************************

*******************************************************************************/

enum ПТипСок
{
        Поток    = consts.SOCK_STREAM   , /++ sequential, reliable +/
        ДГрамма     = consts.SOCK_DGRAM    , /++ connectionless unreliable, max length +/
        ППП = consts.SOCK_ППП, /++ sequential, reliable, max length +/
}

/*******************************************************************************

*******************************************************************************/

enum ППротокол
{
        ИП   = consts.ИППРОТ_ИП   ,     /// default internet протокол (probably 4 for compatibility)
        ИПV4 = consts.ИППРОТ_ИП   ,     /// internet протокол version 4
        ИПV6 = consts.ИППРОТ_ИПV6 ,     /// internet протокол version 6
        ИПУС = consts.ИППРОТ_ИПУС ,     /// internet control сообщение протокол
        ИПГУ = consts.ИППРОТ_ИПГУ ,     /// internet группа management протокол
        ПУТ  = consts.ИППРОТ_ПУТ  ,     /// transmission control протокол
        УПП  = consts.ИППРОТ_УПП  ,     /// PARC universal packet протокол
        ППД  = consts.ИППРОТ_ППД  ,     /// пользователь datagram протокол
        КСЕР  = consts.ИППРОТ_КСЕР  ,     /// Xerox NS протокол
}

/*******************************************************************************

*******************************************************************************/

enum ПСемействоАдресов
{
        НЕУК    = consts.AF_UNSPEC   ,
        ЮНИКС      = consts.AF_UNIX     ,
        ИНЕТ      = consts.AF_INET     ,
        АЙПИЭКС       = consts.AF_ИПX      ,
        ЭПЛТОК = consts.AF_APPLETALK,
        INET6     = consts.AF_INET6    ,
}

/*******************************************************************************

*******************************************************************************/

enum ПЭкстрЗакрытиеСокета
{
        принять =  consts.SHUT_RD,
        Отправка =     consts.SHUT_WR,
        Всё =     consts.SHUT_RDWR,
}

/*******************************************************************************

*******************************************************************************/

enum ПФлагиСокета
{
        Неук =           0,
        СПД =            consts.MSG_СПД,        /// out of band
        Просмотр =           consts.MSG_Просмотр,       /// only for receiving
        НеМаршрутизировать =      consts.MSG_НеМаршрутизировать,  /// only for Отправкаing
        NOSIGNAL =       0x4000,                /// inhibit signals
}

enum ПФлагиАИ: цел 
{
        PASSIVE = consts.AI_PASSIVE,            /// получи адрес в_ use свяжи()
        CANONNAME = consts.AI_CANONNAME,        /// заполни ai_canonname
        НумерикХост = consts.AI_NUMERICHOST,    /// prevent хост имя resolution
        НумерикСлужба = consts.AI_NUMERICSERV,    /// prevent служба имя resolution valid 
                                                /// флаги for ИнфОбАдре (not a стандарт def, 
                                                /// apps should not use it)
        все = consts.AI_ALL,                    /// ИПv6 and ИПv4-mapped (with AI_V4MAPPED) 
        ADDRCONFIG = consts.AI_ADDRCONFIG,      /// only if any адрес is assigned
        V4MAPPED = consts.AI_V4MAPPED,          /// прими ИПv4-mapped ИПv6 адрес special 
                                                /// recommended флаги for getИПnodebyname
        маска = consts.AI_MASK,
        DEFAULT = consts.AI_DEFAULT,
}

enum ПОшибкаАИ
{
        ПлохиеФлаги = consts.EAI_BADFLAGS,	        /// Invalid значение for `ai_flags' field.
        НетИмени = consts.EAI_NONAME,	        /// NAME or Служба is неизвестное.
        ПриРазрешенииАдр = consts.EAI_AGAIN,	        /// Temporary failure in имя resolution.
        Неудачно = consts.EAI_FAIL,	                /// Non-recoverable failure in имя рез.
        НетДанных = consts.EAI_NODATA,	        /// No адрес associated with NAME.
        Семейство = consts.EAI_FAMILY,	        /// `ai_family' not supported.
        ТипСокета = consts.EAI_SOCKTYPE,	        /// `ai_socktype' not supported.
        Служба = consts.EAI_SERVICE,	        /// Служба not supported for `ai_socktype'.
        Память = consts.EAI_MEMORY,	        /// Memory allocation failure.
}


enum ПФлагиУИ: цел 
{
        МаксХост = consts.NI_MAXHOST,
        МаксСерв = consts.NI_MAXSERV,
        НумерикХост = consts.NI_NUMERICHOST,    /// Don't try в_ look up имя_хоста.
        НумерикСлужба = consts.NI_NUMERICSERV,    /// Don't преобразуй порт число в_ имя.
        НетПКДН = consts.NI_NOFQDN,              /// Only return nodename portion.
        ЗапрВозврИм = consts.NI_NAMEREQD,          /// Don't return numeric адресes.
        ДГрамма = consts.NI_ДГрамма,                /// Look up ППД служба rather than ПУТ.
}

			 
/*******************************************************************************

        conversions for network байт-order

*******************************************************************************/

version(БигЭндиан)
{
        private бкрат х8сбк (бкрат x)
        {
                return x;
        }

        private бцел х8сбц (бцел x)
        {
                return x;
        }
}
else 
{
        private import core.BitManip;

        private бкрат х8сбк (бкрат x)
        {
                return cast(бкрат) ((x >> 8) | (x << 8));
        }

        private бцел х8сбц (бцел x)
        {
                return bswap(x);
        }
}

/*******************************************************************************


*******************************************************************************/

version (Win32)
{
        pragma (lib, "ws2_32.lib");
        
        private import sys.win32.WsaSock;

        private typedef цел т_сокет = ~0;

        package extern (Windows)
        {
                alias закройсок закрой;
        
                т_сокет сокет(цел af, цел тип, цел протокол);
                цел ввктлсок(т_сокет s, цел cmd, бцел* argp);
                бцел адр_инет(сим* cp);
                цел свяжи(т_сокет s, адрес.адрессок* имя, цел namelen);
                цел подключись(т_сокет s, адрес.адрессок* имя, цел namelen);
                цел слушай(т_сокет s, цел backlog);
                т_сокет прими(т_сокет s, адрес.адрессок* адр, цел* Addrlen);
                цел закройсок(т_сокет s);
                цел глуши(т_сокет s, цел как);
                цел дайимяпира(т_сокет s, адрес.адрессок* имя, цел* namelen);
                цел дайимясок(т_сокет s, адрес.адрессок* имя, цел* namelen);
                цел шли(т_сокет s, ук  буф, цел длин, цел флаги);
                цел шли_на(т_сокет s, ук  буф, цел длин, цел флаги, адрес.адрессок* в_, цел tolen);
                цел прими(т_сокет s, ук  буф, цел длин, цел флаги);
                цел прими_от(т_сокет s, ук  буф, цел длин, цел флаги, адрес.адрессок* из_, цел* fromlen);
                цел выбери(цел nfds, НаборСокетов.fd* readfds, НаборСокетов.fd* writefds, НаборСокетов.fd* errorfds, НаборСокетов.значврем* таймаут);
                цел дайопцсок(т_сокет s, цел уровень, цел optname, ук  optval, цел* optlen);
                цел установиопцсок(т_сокет s, цел уровень, цел optname, ук  optval, цел optlen);
                цел дайимяхоста(ук  namebuffer, цел buflen);
                сим* инетс8а(бцел ina);
                НетХост.хостзап* дайхостпоимени(сим* имя);
                НетХост.хостзап* дайхостпоадресу(ук  адр, цел длин, цел тип);
                /**
                The gai_strerror function translates ошибка codes of getAddrinfo, 
                freeAddrinfo and getnameinfo в_ a human читаемый ткст, suitable 
                for ошибка reporting. (C) MAN
                */
                //сим* gai_strerror(цел errcode);

                /**
                Given node and служба, which опрentify an Internet хост and a служба, 
                getAddrinfo() returns one or ещё ИнфОбАдре structures, each of which 
                содержит an Internet адрес that can be specified in a вызов в_ свяжи 
                or подключись. The getAddrinfo() function combines the functionality 
                provопрed by the getservbyname and getservbyport functions преобр_в a single 
                interface, but unlike the latter functions, getAddrinfo() is reentrant 
                and allows programs в_ eliminate ИПv4-versus-ИПv6 dependencies.(C) MAN
                */
                цел function(сим* node, сим* служба, адрес.ИнфОбАдре* hints, адрес.ИнфОбАдре** рез) getAddrinfo;
        
                /**
                The freeAddrinfo() function frees the память that was allocated for the 
                dynamically allocated linked список рез.  (C) MAN
                */								
                проц function(адрес.ИнфОбАдре *рез) freeAddrinfo; 
								
                /**
                The getnameinfo() function is the inverse of getAddrinfo: it converts 
                a сокет адрес в_ a corresponding хост and служба, in a протокол-
                independent manner. It combines the functionality of дайхостпоадресу and 
                getservbyport, but unlike those functions, getAddrinfo is reentrant and 
                allows programs в_ eliminate ИПv4-versus-ИПv6 dependencies. (C) MAN
                */
                цел function(адрес.адрессок* sa, цел salen, сим* хост, цел hostlen, сим* serv, цел servlen, цел флаги) getnameinfo; 
				
                бул function (т_сокет, бцел, проц*, DWORD, DWORD, DWORD, DWORD*, OVERLAPPED*) AcceptEx;
                бул function (т_сокет, HANDLE, DWORD, DWORD, OVERLAPPED*, проц*, DWORD) TransmitFile;
                бул function (т_сокет, проц*, цел, проц*, DWORD, DWORD*, OVERLAPPED*) ConnectEx;
								
                //сим* inet_ntop(цел af, проц *ист, сим *приёмн, цел длин);
        }

        private HMODULE lib;				

        static this()
        {
                lib = LoadLibraryA ("Ws2_32.dll");
                getnameinfo = cast(typeof(getnameinfo)) GetProcAddress(lib, "getnameinfo");
                if (!getnameinfo) 
                   { 
                   FreeLibrary (lib);
                   lib = LoadLibraryA ("WshИП6.dll");
                   } 
                getnameinfo = cast(typeof(getnameinfo)) GetProcAddress(lib, "getnameinfo"); 
	        getAddrinfo = cast(typeof(getAddrinfo)) GetProcAddress(lib, "getAddrinfo"); 
                freeAddrinfo = cast(typeof(freeAddrinfo)) GetProcAddress(lib, "freeAddrinfo"); 
                if (!getnameinfo) 
                   { 
                   FreeLibrary (lib);
                   lib = пусто;
                   } 

                ВИНСОКДАН wd =void;
                if (WSAStartup (0x0202, &wd))
                    throw new СокетИскл("version of сокет library is too old");

                DWORD результат;
                Guid acceptG   = {0xb5367df1, 0xcbac, 0x11cf, [0x95,0xca,0x00,0x80,0x5f,0x48,0xa1,0x92]};
                Guid connectG  = {0x25a207b9, 0xddf3, 0x4660, [0x8e,0xe9,0x76,0xe5,0x8c,0x74,0x06,0x3e]};
                Guid transmitG = {0xb5367df0, 0xcbac, 0x11cf, [0x95,0xca,0x00,0x80,0x5f,0x48,0xa1,0x92]};

                auto s = cast(HANDLE) сокет (ПСемействоАдресов.ИНЕТ, ПТипСок.Поток, ППротокол.ПУТ);
                assert (s != cast(HANDLE) -1);
								
                WSAIoctl (s, SIO_GET_EXTENSION_FUNCTION_POINTER, 
                          &connectG, connectG.sizeof, &ConnectEx, 
                          ConnectEx.sizeof, &результат, пусто, пусто);

                WSAIoctl (s, SIO_GET_EXTENSION_FUNCTION_POINTER, 
                          &acceptG, acceptG.sizeof, &AcceptEx, 
                          AcceptEx.sizeof, &результат, пусто, пусто);

                WSAIoctl (s, SIO_GET_EXTENSION_FUNCTION_POINTER, 
                          &transmitG, transmitG.sizeof, &TransmitFile, 
                          TransmitFile.sizeof, &результат, пусто, пусто);
                закройсок (cast(т_сокет) s);
        }

        static ~this()
        {
                if (lib)
                    FreeLibrary (lib);
                WSACleanup();
        }
}
else
{
        private import cidrus;

        private typedef цел т_сокет = -1;

        package extern (C)
        {
                т_сокет сокет(цел af, цел тип, цел протокол);
                цел fcntl(т_сокет s, цел f, ...);
                бцел адр_инет(сим* cp);
                цел свяжи(т_сокет s, адрес.адрессок* имя, цел namelen);
                цел подключись(т_сокет s, адрес.адрессок* имя, цел namelen);
                цел слушай(т_сокет s, цел backlog);
                т_сокет прими(т_сокет s, адрес.адрессок* адр, цел* Addrlen);
                цел закрой(т_сокет s);
                цел глуши(т_сокет s, цел как);
                цел дайимяпира(т_сокет s, адрес.адрессок* имя, цел* namelen);
                цел дайимясок(т_сокет s, адрес.адрессок* имя, цел* namelen);
                цел шли(т_сокет s, ук  буф, цел длин, цел флаги);
                цел шли_на(т_сокет s, ук  буф, цел длин, цел флаги, адрес.адрессок* в_, цел tolen);
                цел прими(т_сокет s, ук  буф, цел длин, цел флаги);
                цел прими_от(т_сокет s, ук  буф, цел длин, цел флаги, адрес.адрессок* из_, цел* fromlen);
                цел выбери(цел nfds, НаборСокетов.fd* readfds, НаборСокетов.fd* writefds, НаборСокетов.fd* errorfds, НаборСокетов.значврем* таймаут);
                цел дайопцсок(т_сокет s, цел уровень, цел optname, ук  optval, цел* optlen);
                цел установиопцсок(т_сокет s, цел уровень, цел optname, ук  optval, цел optlen);
                цел дайимяхоста(ук  namebuffer, цел buflen);
                сим* инетс8а(бцел ina);
                НетХост.хостзап* дайхостпоимени(сим* имя);
                НетХост.хостзап* дайхостпоадресу(ук  адр, цел длин, цел тип);
								
                /**
                Given node and служба, which опрentify an Internet хост and a служба, 
                getAddrinfo() returns one or ещё ИнфОбАдре structures, each of which 
                содержит an Internet адрес that can be specified in a вызов в_ свяжи or 
                подключись. The getAddrinfo() function combines the functionality provопрed 
                by the getservbyname and getservbyport functions преобр_в a single interface,
                but unlike the latter functions, getAddrinfo() is reentrant and allows 
                programs в_ eliminate ИПv4-versus-ИПv6 dependencies. (C) MAN
                */
                цел getAddrinfo(сим* node, сим* служба, адрес.ИнфОбАдре* hints, адрес.ИнфОбАдре** рез); 
		        						
                /**
                The freeAddrinfo() function frees the память that was allocated for the 
                dynamically allocated linked список рез.  (C) MAN
                */
                проц freeAddrinfo(адрес.ИнфОбАдре *рез); 
								
                /**
                The getnameinfo() function is the inverse of getAddrinfo: it converts a сокет
                адрес в_ a corresponding хост and служба, in a протокол-independent manner. 
                It combines the functionality of дайхостпоадресу and getservbyport, but unlike 
                those functions, getAddrinfo is reentrant and allows programs в_ eliminate 
                ИПv4-versus-ИПv6 dependencies. (C) MAN
                */
                цел getnameinfo(адрес.адрессок* sa, цел salen, сим* хост, цел hostlen, сим* serv, цел servlen, цел флаги); 
								
                /**
                The gai_strerror function translates ошибка codes of getAddrinfo, freeAddrinfo 
                and getnameinfo в_ a human читаемый ткст, suitable for ошибка reporting. (C) MAN
                */
                сим* gai_strerror(цел errcode); 
								
                сим* inet_ntop(цел af, проц *ист, сим *приёмн, цел длин);
       }
}


/*******************************************************************************

*******************************************************************************/

public struct Беркли
{
        т_сокет        сок;
        ПТипСок      тип;
        ПСемействоАдресов   семейство;
        ППротокол    протокол;
version (Windows)
         бул           синхронно;

        enum : т_сокет 
        {
                НЕВЕРНСОК = т_сокет.init
        }
        
        enum 
        {
                Ошибка = -1
        }

        alias Ошибка        ERROR;               // backward compatibility
        alias безЗаминки      установиБезЗаминки;          // backward compatibility
        alias повторнИспАдреса установиПовторнИспАдреса;     // backward compatibility
        

        /***********************************************************************

                Configure this экземпляр

        ***********************************************************************/

        проц открой (ПСемействоАдресов семейство, ПТипСок тип, ППротокол протокол, бул создай=да)
        {
                this.тип = тип;
                this.семейство = семейство;
                this.протокол = протокол;
                if (создай)
                    переоткрой;
        }

        /***********************************************************************

                Open/переоткрой a исконный сокет for this экземпляр

        ***********************************************************************/

        проц переоткрой (т_сокет сок = сок.init)
        {
                if (this.сок != сок.init)
                    this.открепи;

                if (сок is сок.init)
                   {
                   сок = cast(т_сокет) сокет (семейство, тип, протокол);
                   if (сок is сок.init)
                       исключение ("Unable в_ создай сокет: ");
                   }

                this.сок = сок;
        }

        /***********************************************************************

                calling глуши() before this is recommended for connection-
                oriented СОКЕТs

        ***********************************************************************/

        проц открепи ()
        {
                if (сок != сок.init)
                    .закрой (сок);
                сок = сок.init;
        }

        /***********************************************************************

                Return the underlying OS укз of this Провод

        ***********************************************************************/

        т_сокет укз ()
        {
                return сок;
        }

        /***********************************************************************

                Return сокет ошибка статус

        ***********************************************************************/

        цел ошибка ()
        {
                цел errcode;
                дайОпцию (ППротокол.СОКЕТ, ПОпцияСокета.ERROR, (&errcode)[0..1]);
                return errcode;
        }

        /***********************************************************************

                Return the последний ошибка

        ***********************************************************************/

        static цел последнОшиб ()
        {
                version (Win32)
                         return ВСАДайПоследнююОшибку();
                   else
                      return errno;
        }

        /***********************************************************************

                Is this сокет still alive? A закрыт сокет is consопрered в_
                be dead, but a глуши сокет is still alive.

        ***********************************************************************/

        бул жив_ли ()
        {
                цел тип, разм_типа = тип.sizeof;
                return дайопцсок (сок, ППротокол.СОКЕТ,
                                   ПОпцияСокета.TYPE, cast(сим*) &тип,
                                   &разм_типа) != Ошибка;
        }

        /***********************************************************************

        ***********************************************************************/

        ПСемействоАдресов ПСемействоАдресов ()
        {
                return семейство;
        }

        /***********************************************************************

        ***********************************************************************/

        Беркли* свяжи (адрес адр)
        {
                if(Ошибка == .свяжи (сок, адр.имя, адр.длинаИмени))
                   исключение ("Unable в_ свяжи сокет: ");
                return this;
        }

        /***********************************************************************

        ***********************************************************************/

        Беркли* подключись (адрес в_)
        {
                if (Ошибка == .подключись (сок, в_.имя, в_.длинаИмени))
                   {
                   if (! blocking)
                      {
                      auto err = последнОшиб;
                      version (Windows)
                              {
                              if (err is WSAEWOULDBLOCK)
                                  return this;
                              }
                           else
                              {
                              if (err is EINPROGRESS)
                                  return this;
                              }
                      }
                   исключение ("Unable в_ подключись сокет: ");
                   }
                return this;
        }

        /***********************************************************************

                need в_ свяжи() first

        ***********************************************************************/

        Беркли* слушай (цел backlog)
        {
                if (Ошибка == .слушай (сок, backlog))
                    исключение ("Unable в_ слушай on сокет: ");
                return this;
        }

        /***********************************************************************

                need в_ свяжи() first

        ***********************************************************************/

        проц прими (ref Беркли мишень)
        {
                auto newsock = .прими (сок, пусто, пусто); 
                if (т_сокет.init is newsock)
                    исключение ("Unable в_ прими сокет connection: ");

                мишень.переоткрой (newsock);
                мишень.протокол = протокол;            //same протокол
                мишень.семейство = семейство;                //same семейство
                мишень.тип = тип;                    //same тип
        }

        /***********************************************************************

                The глуши function shuts down the connection of the сокет.
                Depending on the аргумент значение, it will:

                    -   stop receiving данные for this сокет. If further данные
                        arrives, it is rejected.

                    -   stop trying в_ transmit данные из_ this сокет. Also
                        discards any данные waiting в_ be sent. Стоп looking for
                        acknowledgement of данные already sent; don't retransmit
                        if any данные is lost.

        ***********************************************************************/

        Беркли* глуши (ПЭкстрЗакрытиеСокета как)
        {
                .глуши (сок, как);
                return this;
        }

        /***********************************************************************

                установи заминка таймаут

        ***********************************************************************/

        Беркли* заминка (цел период)
        {
                version (Win32)
                         alias бкрат attr;
                   else
                       alias бцел attr;

                union заминка
                {
                        struct {
                               attr вкл;            // опция on/off
                               attr время;           // заминка время
                               };
                        attr[2] Массив;                  // combined
                }

                заминка l;
                l.вкл = 1;                          // опция on/off
                l.время = cast(бкрат) период;       // заминка время

                return установиОпцию (ППротокол.СОКЕТ, ПОпцияСокета.заминка, l.Массив);
        }

        /***********************************************************************

                enable/disable адрес reuse

        ***********************************************************************/

        Беркли* повторнИспАдреса (бул включен)
        {
                цел[1] x = включен;
                return установиОпцию (ППротокол.СОКЕТ, ПОпцияСокета.REUSEADDR, x);
        }

        /***********************************************************************

                enable/disable безЗаминки опция (nagle)

        ***********************************************************************/

        Беркли* безЗаминки (бул включен)
        {
                цел[1] x = включен;
                return установиОпцию (ППротокол.ПУТ, ПОпцияСокета.ПУТБезЗадержек, x);
        }

        /***********************************************************************

                Helper function в_ укз the добавьing and dropping of группа
                membershИП.

        ***********************************************************************/

        проц включиВГруппу (АдресИПв4 адрес, бул onOff)
        {
                assert (адрес, "Сокет.включиВГруппу :: не_годится пусто адрес");

                struct ИП_mreq
                {
                бцел  imr_multiAddr;  /* ИП multicast адрес of группа */
                бцел  imr_interface;  /* local ИП адрес of interface */
                };

                ИП_mreq mrq;

                auto опция = (onOff) ? ПОпцияСокета.ADD_MEMBERSHИП : ПОпцияСокета.DROP_MEMBERSHИП;
                mrq.imr_interface = 0;
                mrq.imr_multiAddr = адрес.син.адрИС;

                if (.установиопцсок(сок, ППротокол.ИП, опция, &mrq, mrq.sizeof) == Ошибка)
                    исключение ("Unable в_ perform multicast объедини: ");
        }

        /***********************************************************************

        ***********************************************************************/

        адрес новОбъектСемейства ()
        {
                if (семейство is ПСемействоАдресов.ИНЕТ)
                   return new АдресИПв4;
                if (семейство is ПСемействоАдресов.INET6)
		    return new АдресИПв6;
                new НеизвестныйАдрес;
        }

        /***********************************************************************

                return the имя_хоста

        ***********************************************************************/

        static ткст имяХоста ()
        {
                сим[64] имя;

                if(Ошибка == .дайимяхоста (имя.ptr, имя.length))
                   исключение ("Unable в_ obtain хост имя: ");
                return имя [0 .. strlen(имя.ptr)].dup;
        }

        /***********************************************************************

                return the default хост адрес (ИПv4)

        ***********************************************************************/

        static бцел адресХоста ()
        {
                auto ih = new НетХост;
                ih.дайХостПоИмени (имяХоста);
                assert (ih.АдрСписок.length);
                return ih.АдрСписок[0];
        }

        /***********************************************************************

                return the remote адрес of the current connection (ИПv4)

        ***********************************************************************/

        адрес удалённыйАдрес ()
        {
                auto адр = новОбъектСемейства;
                auto длинаИмени = адр.длинаИмени;
                if(Ошибка == .дайимяпира (сок, адр.имя, &длинаИмени))
                   исключение ("Unable в_ obtain remote сокет адрес: ");
                assert (адр.ПСемействоАдресов is семейство);
                return адр;
        }

        /***********************************************************************

                return the local адрес of the current connection (ИПv4)

        ***********************************************************************/

        адрес локальныйАдрес ()
        {
                auto адр = новОбъектСемейства;
                auto длинаИмени = адр.длинаИмени;
                if(Ошибка == .дайимясок (сок, адр.имя, &длинаИмени))
                   исключение ("Unable в_ obtain local сокет адрес: ");
                assert (адр.ПСемействоАдресов is семейство);
                return адр;
        }

        /***********************************************************************

                Отправка данные on the connection. Returns the число of байты 
                actually sent, or ERROR on failure. If the сокет is blocking 
                and there is no буфер пространство left, шли waits.

                Returns число of байты actually sent, or -1 on ошибка

        ***********************************************************************/

        цел шли (проц[] буф, ПФлагиСокета флаги=ПФлагиСокета.Неук)
        {       
                if (буф.length is 0)
                    return 0;

                version (Posix)
                        {
                        auto ret = .шли (сок, буф.ptr, буф.length, 
                                          ПФлагиСокета.NOSIGNAL + cast(цел) флаги);
                        if (errno is EPИПE)
                            ret = -1;
                        return ret;
                        }
                     else
                        return .шли (сок, буф.ptr, буф.length, cast(цел) флаги);
        }

        /***********************************************************************

                Отправка данные в_ a specific destination адрес. If the 
                destination адрес is not specified, a connection 
                must have been made and that адрес is used. If the 
                сокет is blocking and there is no буфер пространство left, 
                отправь_на waits.

        ***********************************************************************/

        цел отправь_на (проц[] буф, ПФлагиСокета флаги, адрес в_)
        {
                return отправь_на (буф, cast(цел) флаги, в_.имя, в_.длинаИмени);
        }

        /***********************************************************************

                ditto

        ***********************************************************************/

        цел отправь_на (проц[] буф, адрес в_)
        {
                return отправь_на (буф, ПФлагиСокета.Неук, в_);
        }

        /***********************************************************************

                ditto - assumes you подключись()ed

        ***********************************************************************/

        цел отправь_на (проц[] буф, ПФлагиСокета флаги=ПФлагиСокета.Неук)
        {
                return отправь_на (буф, cast(цел) флаги, пусто, 0);
        }

        /***********************************************************************

                Отправка данные в_ a specific destination адрес. If the 
                destination адрес is not specified, a connection 
                must have been made and that адрес is used. If the 
                сокет is blocking and there is no буфер пространство left, 
                отправь_на waits.

        ***********************************************************************/

        private цел отправь_на (проц[] буф, цел флаги, адрес.адрессок* в_, цел длин)
        {
                if (буф.length is 0)
                    return 0;

                version (Posix)
                        {
                        auto ret = .шли_на (сок, буф.ptr, буф.length, 
                                            флаги | ПФлагиСокета.NOSIGNAL, в_, длин);
                        if (errno is EPИПE)
                            ret = -1;
                        return ret;
                        }
                     else
                        return .шли_на (сок, буф.ptr, буф.length, флаги, в_, длин);
        }

        /***********************************************************************
                принять данные on the connection. Returns the число of 
                байты actually Приёмd, 0 if the remote sопрe есть закрыт 
                the connection, or ERROR on failure. If the сокет is blocking, 
                принять waits until there is данные в_ be Приёмd.
                
                Returns число of байты actually Приёмd, 0 on connection 
                closure, or -1 on ошибка

        ***********************************************************************/

        цел принять (проц[] буф, ПФлагиСокета флаги=ПФлагиСокета.Неук)
        {
                if (!буф.length)
                     плохойАрг ("Сокет.принять :: мишень буфер есть 0 length");

                return .прими(сок, буф.ptr, буф.length, cast(цел)флаги);
        }

        /***********************************************************************

                принять данные and получи the remote endpoint адрес. Returns 
                the число of байты actually Приёмd, 0 if the remote sопрe 
                есть закрыт the connection, or ERROR on failure. If the сокет 
                is blocking, принять_от waits until there is данные в_ be 
                Приёмd.

        ***********************************************************************/

        цел принять_от (проц[] буф, ПФлагиСокета флаги, адрес из_)
        {
                if (!буф.length)
                     плохойАрг ("Сокет.принять_от :: мишень буфер есть 0 length");

                assert(из_.ПСемействоАдресов() == семейство);
                цел длинаИмени = из_.длинаИмени();
                return .прими_от(сок, буф.ptr, буф.length, cast(цел)флаги, из_.имя(), &длинаИмени);
        }

        /***********************************************************************

                ditto

        ***********************************************************************/

        цел принять_от (проц[] буф, адрес из_)
        {
                return принять_от(буф, ПФлагиСокета.Неук, из_);
        }

        /***********************************************************************

                ditto - assumes you подключись()ed

        ***********************************************************************/

        цел принять_от (проц[] буф, ПФлагиСокета флаги = ПФлагиСокета.Неук)
        {
                if (!буф.length)
                     плохойАрг ("Сокет.принять_от :: мишень буфер есть 0 length");

                return .прими_от(сок, буф.ptr, буф.length, cast(цел)флаги, пусто, пусто);
        }

        /***********************************************************************

                returns the length, in байты, of the actual результат - very
                different из_ дайопцсок()

        ***********************************************************************/

        цел дайОпцию (ППротокол уровень, ПОпцияСокета опция, проц[] результат)
        {
                цел длин = результат.length;
                if(Ошибка == .дайопцсок (сок, cast(цел)уровень, cast(цел)опция, результат.ptr, &длин))
                   исключение ("Unable в_ получи сокет опция: ");
                return длин;
        }

        /***********************************************************************

        ***********************************************************************/

        Беркли* установиОпцию (ППротокол уровень, ПОпцияСокета опция, проц[] значение)
        {
                if(Ошибка == .установиопцсок (сок, cast(цел)уровень, cast(цел)опция, значение.ptr, значение.length))
                   исключение ("Unable в_ установи сокет опция: ");
                return this;
        }

        /***********************************************************************

                getter

        ***********************************************************************/

        бул blocking()
        {
                version (Windows)
                         return синхронно;
                else
                   return !(fcntl(сок, F_GETFL, 0) & O_NONBLOCK);
        }

        /***********************************************************************

                setter

        ***********************************************************************/

        проц blocking(бул да)
        {
                version (Windows)
                        {
                        бцел num = !да;
                        if(ввктлсок(сок, consts.ВВФСБВВ, &num) is ERROR)
                           исключение("Unable в_ установи сокет blocking: ");
                        синхронно = да;
                        }
                     else 
                        {
                        цел x = fcntl(сок, F_GETFL, 0);
                        if(да)
                           x &= ~O_NONBLOCK;
                        else
                           x |= O_NONBLOCK;
                        if(fcntl(сок, F_SETFL, x) is ERROR)
                           исключение("Unable в_ установи сокет blocking: ");
                        }
                return; 
        }

        /***********************************************************************

        ***********************************************************************/

        static проц исключение (ткст сооб)
        {
                throw new СокетИскл (сооб ~ СисОш.найди(последнОшиб));
        }

        /***********************************************************************

        ***********************************************************************/

        protected static проц плохойАрг (ткст сооб)
        {
                throw new ИсклНелегальногоАргумента (сооб);
        }
}



/*******************************************************************************


*******************************************************************************/

public abstract class адрес
{
        public struct адрессок
        {
                бкрат   семейство;
                сим[14] данные = 0;
        }

        struct ИнфОбАдре 
        { 
                цел       ai_flags; 
                цел       ai_family; 
                цел       ai_socktype; 
                цел       ai_protocol; 
                бцел      ai_Addrlen; 
                version (freebsd)
                        {
                        сим*     ai_canonname; 
                        адрессок* ai_Addr; 
                        }
                     else
                        {
                        адрессок* ai_Addr; 
                        сим*     ai_canonname; 
                        }
                ИнфОбАдре* ai_next; 
        } 

        abstract адрессок*      имя();
        abstract цел            длинаИмени();

        /***********************************************************************

                Internal usage

        ***********************************************************************/

        private static бкрат с8хбк (бкрат x)
        {
                return х8сбк(x);
        }

        /***********************************************************************

                Internal usage

        ***********************************************************************/

        private static бцел с8хбц (бцел x)
        {
                return х8сбц(x);
        }

        /***********************************************************************

                Internal usage

        ***********************************************************************/

        private static ткст преобразуй2Д (сим* s)
        {
                return s ? s[0 .. strlen(s)] : cast(ткст)пусто;
        }

        /***********************************************************************

                Internal usage

        ***********************************************************************/

        private static сим* преобразуй2Си (ткст ввод, ткст вывод)
        {
                вывод [0 .. ввод.length] = ввод;
                вывод [ввод.length] = 0;
                return вывод.ptr;
        }

        /***********************************************************************

                Internal usage

        ***********************************************************************/

        private static ткст изЦел (ткст врем, цел i)
        {
                цел j = врем.length;
                do {
                   врем[--j] = cast(сим)(i % 10 + '0');
                   } while (i /= 10);
                return врем [j .. $];
        }

        /***********************************************************************

                Internal usage

        ***********************************************************************/

        private static цел вЦел (ткст s)
        {
                бцел значение;

                foreach (c; s)
                         if (c >= '0' && c <= '9')
                             значение = значение * 10 + (c - '0');
                         else
                            break;
                return значение;
        }

        /***********************************************************************

                Dinrus: добавьed this common function

        ***********************************************************************/

        static проц исключение (ткст сооб)
        {
                throw new СокетИскл (сооб);
        }
				
        /***********************************************************************

                адрес factory

        ***********************************************************************/

        static адрес создай (адрессок* sa) 
        { 
                switch  (sa.семейство) 
                        { 
                        case ПСемействоАдресов.ИНЕТ: 
                             return new АдресИПв4(sa); 
                        case ПСемействоАдресов.INET6: 
                             return new АдресИПв6(sa); 
                        default: 
                             return пусто; 
                        } 
        } 
				
        /*********************************************************************** 
  
        ***********************************************************************/ 
         
        static адрес разреши (ткст хост, ткст служба = пусто, 
                                ПСемействоАдресов af = ПСемействоАдресов.НЕУК, 
                                ПФлагиАИ флаги = cast(ПФлагиАИ)0) 
        { 
                return разрешиВсе (хост, служба, af, флаги)[0]; 
        } 
         
        /*********************************************************************** 
  
        ***********************************************************************/ 
         
        static адрес разреши (ткст хост, бкрат порт, 
                                ПСемействоАдресов af = ПСемействоАдресов.НЕУК, 
                                ПФлагиАИ флаги = cast(ПФлагиАИ)0) 
        { 
                return разрешиВсе (хост, порт, af, флаги)[0]; 
        } 
         
        /*********************************************************************** 
  
        ***********************************************************************/ 
         
        static адрес[] разрешиВсе (ткст хост, ткст служба = пусто, 
                                     ПСемействоАдресов af = ПСемействоАдресов.НЕУК, 
                                     ПФлагиАИ флаги = cast(ПФлагиАИ)0) 
        { 
                адрес[] retVal; 
                version (Win32) 
                        { 
                        if (!getAddrinfo) 
                           { // *old* windows, let's fall back в_ НетХост 
                           бцел порт = вЦел(служба); 
                           if (флаги & ПФлагиАИ.PASSIVE && хост is пусто) 
                               return [new АдресИПв4(0, порт)]; 

                           auto nh = new НетХост; 
                           if (!nh.дайХостПоИмени(хост)) 
                                throw new АдрИскл("couldn't разреши " ~ хост); 

                           retVal.length = nh.АдрСписок.length; 
                           foreach (i, адр; nh.АдрСписок)
                                    retVal[i] = new АдресИПв4(адр, порт); 
                           return retVal; 
                           } 
                        } 

                ИнфОбАдре* инфо; 
                ИнфОбАдре hints; 
                hints.ai_flags = флаги; 
                hints.ai_family = (флаги & ПФлагиАИ.PASSIVE && af == ПСемействоАдресов.НЕУК) ? ПСемействоАдресов.INET6 : af; 
                hints.ai_socktype = ПТипСок.Поток; 
                цел ошибка = getAddrinfo(вТкст0(хост), служба.length == 0 ? пусто : вТкст0(служба), &hints, &инфо); 
                if (ошибка != 0)  
                    throw new АдрИскл("couldn't разреши " ~ хост); 

                retVal.length = 16; 
                retVal.length = 0; 
                while (инфо) 
                      { 
                      if (auto адр = создай(инфо.ai_Addr)) 
                          retVal ~= адр; 
                      инфо = инфо.ai_next; 
                      } 
                freeAddrinfo (инфо); 
                return retVal; 
        } 
         
        /*********************************************************************** 
  
        ***********************************************************************/ 
         
        static адрес[] разрешиВсе (сим хост[], бкрат порт, 
                                     ПСемействоАдресов af = ПСемействоАдресов.НЕУК, 
                                     ПФлагиАИ флаги = cast(ПФлагиАИ)0) 
        { 
                сим[16] буф; 
                return разрешиВсе (хост, изЦел(буф, порт), af, флаги); 
        } 
         
        /*********************************************************************** 
  
        ***********************************************************************/ 
         
        static адрес пассивное (ткст служба, 
                                ПСемействоАдресов af = ПСемействоАдресов.НЕУК, 
                                ПФлагиАИ флаги = cast(ПФлагиАИ)0) 
        { 
                return разреши (пусто, служба, af, флаги | ПФлагиАИ.PASSIVE); 
        } 
         
        /*********************************************************************** 
 
         ***********************************************************************/ 
         
        static адрес пассивное (бкрат порт, ПСемействоАдресов af = ПСемействоАдресов.НЕУК, 
                                ПФлагиАИ флаги = cast(ПФлагиАИ)0) 
        { 
                return разреши (пусто, порт, af, флаги | ПФлагиАИ.PASSIVE); 
        } 
         
        /*********************************************************************** 
  
        ***********************************************************************/ 
 
        ткст вТкстАдреса() 
        { 
                сим[1025] хост =void; 
                // Getting имя инфо. Don't look up имя_хоста, returns 
                // numeric имя. (ПФлагиУИ.НумерикХост)
                getnameinfo (имя, длинаИмени, хост.ptr, хост.length, пусто, 0, ПФлагиУИ.НумерикХост); 
                return изТкст0 (хост.ptr); 
        } 
 
        /*********************************************************************** 
 
         ***********************************************************************/ 
 
        ткст вТкстПорта() 
        { 
                сим[32] служба =void; 
                // Getting имя инфо. Returns порт число, not 
                // служба имя. (ПФлагиУИ.НумерикСлужба)
                getnameinfo (имя, длинаИмени, пусто, 0, служба.ptr, служба.length, ПФлагиУИ.НумерикСлужба); 
                foreach (i, c; служба)  
                         if (c == '\0')  
                             return служба[0..i].dup; 
                return пусто;
        } 
          
        /*********************************************************************** 
  
        ***********************************************************************/ 
 
        ткст вТкст() 
        { 
                return вТкстАдреса ~ ":" ~ вТкстПорта; 
        } 
                  
        /*********************************************************************** 
 
         ***********************************************************************/ 
 
        ПСемействоАдресов ПСемействоАдресов() 
        { 
                return cast(ПСемействоАдресов)имя.семейство; 
        } 
}


/*******************************************************************************

*******************************************************************************/

public class НеизвестныйАдрес : адрес
{
        адрессок sa;

        /***********************************************************************

        ***********************************************************************/

        адрессок* имя()
        {
                return &sa;
        }

        /***********************************************************************

        ***********************************************************************/

        цел длинаИмени()
        {
                return sa.sizeof;
        }

        /***********************************************************************

        ***********************************************************************/

        ПСемействоАдресов ПСемействоАдресов()
        {
                return cast(ПСемействоАдресов) sa.семейство;
        }

        /***********************************************************************

        ***********************************************************************/

        ткст вТкст()
        {
                return "Unknown";
        }
}


/*******************************************************************************


*******************************************************************************/

public class АдресИПв4 : адрес
{
        /***********************************************************************

        ***********************************************************************/

        enum 
        {
                АДР_ЛЮБОЙ = 0, 
                АДР_НЕУК = cast(бцел)-1, 
                ПОРТ_ЛЮБОЙ = 0
        }

        /***********************************************************************

        ***********************************************************************/

        struct сокадр_ин
        {
                version (freebsd)
                        {
                        ббайт sin_len;
                        ббайт семействоИС  = ПСемействоАдресов.ИНЕТ;
                        } 
                     else 
                        {
                        бкрат семействоИС = ПСемействоАдресов.ИНЕТ;
                        }
                бкрат портИС;
                бцел адрИС; //in_Addr
                сим[8] зероИС = 0;
        }

        static assert(сокадр_ин.sizeof is 16);

        private сокадр_ин син;

        /***********************************************************************

        ***********************************************************************/

        package this ()
        {
        }

        /***********************************************************************

        ***********************************************************************/

        this (бкрат порт)
        {
                син.адрИС = 0; //any, "0.0.0.0"
                син.портИС = х8сбк(порт);
        }

        /***********************************************************************

        ***********************************************************************/

        this (бцел адр, бкрат порт)
        {
                син.адрИС = х8сбц(адр);
                син.портИС = х8сбк(порт);
        }

        /***********************************************************************

                -порт- can be ПОРТ_ЛЮБОЙ
                -адр- is an ИП адрес or хост имя

        ***********************************************************************/

        this (ткст адр, цел порт = ПОРТ_ЛЮБОЙ)
        {
                бцел uiAddr = разбор(адр);
                if (АДР_НЕУК == uiAddr)
                   {
                   auto ih = new НетХост;
                   if (!ih.дайХостПоИмени(адр))
                      {
                      сим[16] врем =void;
                      исключение ("Unable в_ разреши "~адр~":"~изЦел(врем, порт));
                      }
                   uiAddr = ih.АдрСписок[0];
                   }
                син.адрИС = х8сбц(uiAddr);
                син.портИС = х8сбк(cast(бкрат) порт);
        }

        /***********************************************************************

        ***********************************************************************/

        this (адрессок* адр) 
        { 
                син = *(cast(сокадр_ин*)адр); 
        } 
				
        /***********************************************************************

        ***********************************************************************/
				
        адрессок* имя()
        {
                return cast(адрессок*)&син;
        }

        /***********************************************************************

        ***********************************************************************/

        цел длинаИмени()
        {
                return син.sizeof;
        }

        /***********************************************************************

        ***********************************************************************/

        ПСемействоАдресов ПСемействоАдресов()
        {
                return ПСемействоАдресов.ИНЕТ;
        }

        /***********************************************************************

        ***********************************************************************/

        бкрат порт()
        {
                return с8хбк(син.портИС);
        }

        /***********************************************************************

        ***********************************************************************/

        бцел адр()
        {
                return с8хбц(син.адрИС);
        }

        /***********************************************************************

        ***********************************************************************/

        ткст вТкстАдреса()
        {
                сим[16] buff = 0;
                version (Windows)
                         return преобразуй2Д(инетс8а(син.адрИС)).dup;
                else
                   return преобразуй2Д(inet_ntop(ПСемействоАдресов.ИНЕТ, &син.адрИС, buff.ptr, 16)).dup;
        }

        /***********************************************************************

        ***********************************************************************/

        ткст вТкстПорта()
        {
                сим[8] _port;
                return изЦел (_port, порт()).dup;
        }

        /***********************************************************************

        ***********************************************************************/

        ткст вТкст()
        {
                return вТкстАдреса() ~ ":" ~ вТкстПорта();
        }

        /***********************************************************************

                -адр- is an ИП адрес in the форматируй "a.b.c.d"
                returns АДР_НЕУК on failure

        ***********************************************************************/

        static бцел разбор(ткст адр)
        {
                сим[64] врем;

                synchronized (АдресИПв4.classinfo)
                              return с8хбц(адр_инет(преобразуй2Си (адр, врем)));
        }
}

/*******************************************************************************

*******************************************************************************/

debug(UnitTest)
{
        unittest
        {
        АдресИПв4 ia = new АдресИПв4("63.105.9.61", 80);
        assert(ia.вТкст() == "63.105.9.61:80");
        }
}

/******************************************************************************* 
        
        ИПv6 is the следщ-generation Internet Protocol version
        designated as the successor в_ ИПv4, the first
        implementation used in the Internet that is still in
        dominant use currently.
	        			
        More information: http://ИПv6.com/
				
        ИПv6 supports 128-bit адрес пространство as opposed в_ 32-bit
        адрес пространство of ИПv4.
				
        ИПv6 is записано as 8 blocks of 4 octal digits (16 bit)
        separated by a colon (":"). Zero block can be replaced by "::".
	        			
        For example: 
        ---
        0000:0000:0000:0000:0000:0000:0000:0001
        is equal
        ::0001
        is equal
        ::1
        is analogue ИПv4 127.0.0.1
				
        0000:0000:0000:0000:0000:0000:0000:0000
        is equal
        ::
        is analogue ИПv4 0.0.0.0
				
        2001:cdba:0000:0000:0000:0000:3257:9652 
        is equal
        2001:cdba::3257:9652
				
        ИПv4 адрес can be submitted through ИПv6 as ::ffff:xx.xx.xx.xx,
        where xx.xx.xx.xx 32-bit ИПv4 адресes.
				
        ::ffff:51b0:ec6d
        is equal
        ::ffff:81.176.236.109
        is analogue ИПv4 81.176.236.109
				
        The URL for the ИПv6 адрес will be of the form:
        http://[2001:cdba:0000:0000:0000:0000:3257:9652]/
				
        If needed в_ specify a порт, it will be listed after the
        closing square bracket followed by a colon.
				
        http://[2001:cdba:0000:0000:0000:0000:3257:9652]:8080/
        адрес: "2001:cdba:0000:0000:0000:0000:3257:9652"
        порт: 8080
				
        АдресИПв6 can be used as well as АдресИПв4.
				
        scope адр = new АдресИПв6(8080); 
        адрес: "::"
        порт: 8080
				
        scope Addr_2 = new АдресИПв6("::1", 8081); 
        адрес: "::1"
        порт: 8081
				
        scope Addr_3 = new АдресИПв6("::1"); 
        адрес: "::1"
        порт: ПОРТ_ЛЮБОЙ
				
        Also in the АдресИПв6 constructor can specify the служба имя
        or порт as ткст
				
        scope Addr_3 = new АдресИПв6("::", "ssh"); 
        адрес: "::"
        порт: 22 (ssh служба порт)
				
        scope Addr_4 = new АдресИПв6("::", "8080"); 
        адрес: "::"
        порт: 8080
				
*******************************************************************************/ 
				
class АдресИПв6 : адрес 
{ 
protected:
        /*********************************************************************** 
         
        ***********************************************************************/ 
 
        struct sockAddr_in6 
        { 
                бкрат sin_family; 
                бкрат портИС; 
                 
                бцел sin6_flowinfo; 
                ббайт[16] sin6_Addr; 
                бцел sin6_scope_опр; 
        } 
         
        sockAddr_in6 син; 
 
        /*********************************************************************** 
 
         ***********************************************************************/ 
 
        this () 
        { 
        } 
 
        /***********************************************************************

        ***********************************************************************/

        this (адрессок* sa) 
        { 
                син = *cast(sockAddr_in6*)sa; 
        } 
         
        /*********************************************************************** 
 
        ***********************************************************************/ 
 
        адрессок* имя() 
        { 
                return cast(адрессок*)&син; 
        } 
 
        /*********************************************************************** 
 
        ***********************************************************************/ 
 
        цел длинаИмени() 
        { 
                return син.sizeof; 
        } 
 
 public: 

        /***********************************************************************

        ***********************************************************************/

        ПСемействоАдресов ПСемействоАдресов()
        {
                return ПСемействоАдресов.INET6;
        }

 
        const бкрат ПОРТ_ЛЮБОЙ = 0; 
  
        /*********************************************************************** 
 
         ***********************************************************************/ 
 
        бкрат порт() 
        { 
                return с8хбк(син.портИС); 
        } 
 				
        /*********************************************************************** 
 
                Create АдресИПв6 with zero адрес

        ***********************************************************************/ 
 				
        this (цел порт) 
        { 
          this ("::", порт);
        } 
				
        /*********************************************************************** 
 
                -порт- can be ПОРТ_ЛЮБОЙ 
                -адр- is an ИП адрес or хост имя 
 
        ***********************************************************************/ 
				
        this (ткст адр, цел порт = ПОРТ_ЛЮБОЙ) 
        { 
                version (Win32) 
                        { 
                        if (!getAddrinfo) 
                             исключение ("This platform does not support ИПv6."); 
                        } 
                ИнфОбАдре* инфо; 
                ИнфОбАдре hints; 
                hints.ai_family = ПСемействоАдресов.INET6; 
                цел ошибка = getAddrinfo((адр ~ '\0').ptr, пусто, &hints, &инфо); 
                if (ошибка != 0)  
                    исключение("неудачно в_ создай АдресИПв6: "); 
                 
                син = *cast(sockAddr_in6*)(инфо.ai_Addr); 
                син.портИС = х8сбк(порт); 
        } 
               
        /*********************************************************************** 
 
                -служба- can be a порт число or служба имя 
                -адр- is an ИП адрес or хост имя 
 
        ***********************************************************************/ 
 
        this (ткст адр, ткст служба) 
        { 
                version (Win32) 
                        { 
                        if(! getAddrinfo) 
                             исключение ("This platform does not support ИПv6."); 
                        } 
                ИнфОбАдре* инфо; 
                ИнфОбАдре hints; 
                hints.ai_family = ПСемействоАдресов.INET6; 
                цел ошибка = getAddrinfo((адр ~ '\0').ptr, (служба ~ '\0').ptr, &hints, &инфо); 
                if (ошибка != 0)  
                    исключение ("неудачно в_ создай АдресИПв6: "); 
                син = *cast(sockAddr_in6*)(инфо.ai_Addr); 
        } 
 
        /*********************************************************************** 
  
        ***********************************************************************/ 
 
        ббайт[] адр() 
        { 
                return син.sin6_Addr; 
        } 
 
        /*********************************************************************** 
  
        ***********************************************************************/ 
 
        version (Posix)
        ткст вТкстАдреса()
        {
				
                сим[100] buff = 0;
                return изТкст0(inet_ntop(ПСемействоАдресов.INET6, &син.sin6_Addr, buff.ptr, 100)).dup;
        }

        /***********************************************************************

        ***********************************************************************/

        ткст вТкстПорта()
        {
                сим[8] _port;
                return изЦел (_port, порт()).dup;
        }
 
        /***********************************************************************

        ***********************************************************************/

        ткст вТкст() 
        { 
                return "[" ~ вТкстАдреса ~ "]:" ~ вТкстПорта; 
        } 
} 

/*******************************************************************************

*******************************************************************************/

debug(UnitTest)
{
        unittest
        {
        АдресИПв6 ia = new АдресИПв6("7628:0d18:11a3:09d7:1f34:8a2e:07a0:765d", 8080);
        //assert(ia.вТкст() == "[7628:d18:11a3:9d7:1f34:8a2e:7a0:765d]:8080");
        assert(ia.вТкст() == "[7628:0d18:11a3:09d7:1f34:8a2e:07a0:765d]:8080");
        }
}


/*******************************************************************************


*******************************************************************************/

public class НетХост
{
        ткст          имя;
        ткст[]        aliases;
        бцел[]          АдрСписок;

        /***********************************************************************

        ***********************************************************************/

        struct хостзап
        {
                сим* имя;
                сим** алиасы;
                version (Win32)
                        {
                        крат типадр;
                        крат длина;
                        }
                     else 
                        {
                        цел типадр;
                        цел длина;
                        }
                сим** списадр;

                сим* адр()
                {
                        return списадр[0];
                }
        }

        /***********************************************************************

        ***********************************************************************/

        protected проц проверьХостзап(хостзап* he)
        {
                if (he.типадр != ПСемействоАдресов.ИНЕТ || he.длина != 4)
                    throw new СокетИскл("адрес семейство не_совпадают.");
        }

        /***********************************************************************

        ***********************************************************************/

        проц наполни (хостзап* he)
        {
                цел i;
                сим* p;

                имя = адрес.преобразуй2Д (he.имя);

                for (i = 0;; i++)
                    {
                    p = he.алиасы[i];
                    if(!p)
                        break;
                    }

                if (i)
                   {
                   aliases = new ткст[i];
                   for (i = 0; i != aliases.length; i++)
                        aliases[i] = адрес.преобразуй2Д(he.алиасы[i]);
                   }
                else
                   aliases = пусто;

                for (i = 0;; i++)
                    {
                    p = he.списадр[i];
                    if(!p)
                        break;
                    }

                if (i)
                   {
                   АдрСписок = new бцел[i];
                   for (i = 0; i != АдрСписок.length; i++)
                        АдрСписок[i] = адрес.с8хбц(*(cast(бцел*)he.списадр[i]));
                   }
                else
                   АдрСписок = пусто;
        }

        /***********************************************************************

        ***********************************************************************/

        бул дайХостПоИмени(ткст имя)
        {
                сим[1024] врем;

                synchronized (НетХост.classinfo)
                             {
                             auto he = дайхостпоимени(адрес.преобразуй2Си (имя, врем));
                             if(!he)
                                return нет;
                             проверьХостзап(he);
                             наполни(he);
                             }
                return да;
        }

        /***********************************************************************

        ***********************************************************************/

        бул дайХостПоАдресу(бцел адр)
        {
                бцел x = х8сбц(адр);
                synchronized (НетХост.classinfo)
                             {
                             auto he = дайхостпоадресу(&x, 4, cast(цел)ПСемействоАдресов.ИНЕТ);
                             if(!he)
                                 return нет;
                             проверьХостзап(he);
                             наполни(he);
                             }
                return да;
        }

        /***********************************************************************

        ***********************************************************************/

        //shortcut
        бул дайХостПоАдресу(ткст адр)
        {
                сим[64] врем;

                synchronized (НетХост.classinfo)
                             {
                             бцел x = адр_инет(адрес.преобразуй2Си (адр, врем));
                             auto he = дайхостпоадресу(&x, 4, cast(цел)ПСемействоАдресов.ИНЕТ);
                             if(!he)
                                 return нет;
                             проверьХостзап(he);
                             наполни(he);
                             }
                return да;
        }
}


/*******************************************************************************

*******************************************************************************/

debug (UnitTest)
{
        extern (C) цел printf(сим*, ...);
        unittest
        {
        НетХост ih = new НетХост;
        ih.дайХостПоИмени(Беркли.имяХоста());
        assert(ih.АдрСписок.length > 0);
        АдресИПв4 ia = new АдресИПв4(ih.АдрСписок[0], АдресИПв4.ПОРТ_ЛЮБОЙ);
        printf("ИП адрес = %.*s\nname = %.*s\n", ia.вТкстАдреса(), ih.имя);
        foreach(цел i, ткст s; ih.aliases)
        {
                printf("aliases[%d] = %.*s\n", i, s);
        }

        printf("---\n");

        assert(ih.дайХостПоАдресу(ih.АдрСписок[0]));
        printf("имя = %.*s\n", ih.имя);
        foreach(цел i, ткст s; ih.aliases)
        {
                printf("aliases[%d] = %.*s\n", i, s);
        }
        }
}


/*******************************************************************************

        a установи of СОКЕТs for Беркли.выбери()

*******************************************************************************/

public class НаборСокетов
{
        import rt.core.stdc.config;

        struct значврем
        {
                c_long  сек, микросекунды; 
        }

        private бцел  члоБайт; //Win32: excludes бцел.размер "счёт"
        private байт* буф;

        struct fd {}

        version(Windows)
        {
                бцел счёт()
                {
                        return *(cast(бцел*)буф);
                }

                проц счёт(цел setter)
                {
                        *(cast(бцел*)буф) = setter;
                }


                т_сокет* first()
                {
                        return cast(т_сокет*)(буф + бцел.sizeof);
                }
        }
        else version (Posix)
        {
                import core.BitManip;

                бцел nfdbits;
                т_сокет _maxfd = 0;

                бцел fdelt(т_сокет s)
                {
                        return cast(бцел)s / nfdbits;
                }


                бцел fdmask(т_сокет s)
                {
                        return 1 << cast(бцел)s % nfdbits;
                }


                бцел* first()
                {
                        return cast(бцел*)буф;
                }

                public т_сокет максуд()
                {
                        return _maxfd;
                }
        }


        public:

        this (бцел max)
        {
                version(Win32)
                {
                        члоБайт = max * т_сокет.sizeof;
                        буф = (new байт[члоБайт + бцел.sizeof]).ptr;
                        счёт = 0;
                }
                else version (Posix)
                {
                        if (max <= 32)
                            члоБайт = 32 * бцел.sizeof;
                        else
                           члоБайт = max * бцел.sizeof;

                        буф = (new байт[члоБайт]).ptr;
                        nfdbits = члоБайт * 8;
                        //сотри(); //new initializes в_ 0
                }
                else
                {
                        static assert(0);
                }
        }

        this (НаборСокетов o) 
        {
                члоБайт = o.члоБайт;
                auto размер = члоБайт;
                version (Win32) 
                         размер += бцел.sizeof;

                version (Posix) 
                        {
                        nfdbits = o.nfdbits;
                        _maxfd = o._maxfd;
                        }
                
                auto b = new байт[размер];
                b[] = o.буф[0..размер];
                буф = b.ptr;
        }

        this()
        {
                version(Win32)
                {
                        this(64);
                }
                else version (Posix)
                {
                        this(32);
                }
                else
                {
                        static assert(0);
                }
        }

        НаборСокетов dup() 
        {
                return new НаборСокетов (this);
        }
        
        НаборСокетов сбрось()
        {
                version(Win32)
                {
                        счёт = 0;
                }
                else version (Posix)
                {
                        буф[0 .. члоБайт] = 0;
                        _maxfd = 0;
                }
                else
                {
                        static assert(0);
                }
                return this;
        }

        проц добавь(т_сокет s)
        in
        {
                version(Win32)
                {
                        assert(счёт < max); //добавьed too many СОКЕТs; specify a higher max in the constructor
                }
        }
        body
        {
                version(Win32)
                {
                        бцел c = счёт;
                        first[c] = s;
                        счёт = c + 1;
                }
                else version (Posix)
                {
                        if (s > _maxfd)
                                _maxfd = s;

                        bts(cast(бцел*)&first[fdelt(s)], cast(бцел)s % nfdbits);
                }
                else
                {
                        static assert(0);
                }
        }

        проц добавь(Беркли* s)
        {
                добавь(s.укз);
        }

        проц удали(т_сокет s)
        {
                version(Win32)
                {
                        бцел c = счёт;
                        т_сокет* старт = first;
                        т_сокет* stop = старт + c;

                        for(; старт != stop; старт++)
                        {
                                if(*старт == s)
                                        goto найдено;
                        }
                        return; //не найден

                        найдено:
                        for(++старт; старт != stop; старт++)
                        {
                                *(старт - 1) = *старт;
                        }

                        счёт = c - 1;
                }
                else version (Posix)
                {
                        btr(cast(бцел*)&first[fdelt(s)], cast(бцел)s % nfdbits);

                        // If we're removing the biggest файл descrИПtor we've
                        // entered so far we need в_ recalculate this значение
                        // for the сокет установи.
                        if (s == _maxfd)
                        {
                                while (--_maxfd >= 0)
                                {
                                        if (набор_ли(_maxfd))
                                        {
                                                break;
                                        }
                                }
                        }
                }
                else
                {
                        static assert(0);
                }
        }

        проц удали(Беркли* s)
        {
                удали(s.укз);
        }

        цел набор_ли(т_сокет s)
        {
                version(Win32)
                {
                        т_сокет* старт = first;
                        т_сокет* stop = старт + счёт;

                        for(; старт != stop; старт++)
                        {
                                if(*старт == s)
                                        return да;
                        }
                        return нет;
                }
                else version (Posix)
                {
                        //return bt(cast(бцел*)&first[fdelt(s)], cast(бцел)s % nfdbits);
                        цел индекс = cast(бцел)s % nfdbits;
                        return (cast(бцел*)&first[fdelt(s)])[индекс / (бцел.sizeof*8)] & (1 << (индекс & ((бцел.sizeof*8) - 1)));
                }
                else
                {
                        static assert(0);
                }
        }

        цел набор_ли(Беркли* s)
        {
                return набор_ли(s.укз);
        }

        бцел max()
        {
                return члоБайт / т_сокет.sizeof;
        }

        fd* вНабор_УД()
        {
                return cast(fd*)буф;
        }

        /***********************************************************************

                НаборСокетов's are updated в_ include only those СОКЕТs which an
                событие occured.

                Returns the число of события, 0 on таймаут, or -1 on ошибка

                for a подключись()ing сокет, writeability means подключен
                for a слушай()ing сокет, readability means listening

                Winsock: possibly internally limited в_ 64 СОКЕТs per установи

        ***********************************************************************/

        static цел выбери (НаборСокетов checkRead, НаборСокетов checkWrite, НаборСокетов checkError, значврем* tv)
        {
                fd* fr, fw, fe;

                //сделай sure Неук of the НаборСокетов's are the same объект
                if (checkRead)
                   {
                   assert(checkRead !is checkWrite);
                   assert(checkRead !is checkError);
                   }

                if (checkWrite)
                    assert(checkWrite !is checkError);

                version(Win32)
                {
                        //Windows есть a problem with пустой набор_уд's that aren't пусто
                        fr = (checkRead && checkRead.счёт()) ? checkRead.вНабор_УД() : пусто;
                        fw = (checkWrite && checkWrite.счёт()) ? checkWrite.вНабор_УД() : пусто;
                        fe = (checkError && checkError.счёт()) ? checkError.вНабор_УД() : пусто;
                }
                else
                {
                        fr = checkRead ? checkRead.вНабор_УД() : пусто;
                        fw = checkWrite ? checkWrite.вНабор_УД() : пусто;
                        fe = checkError ? checkError.вНабор_УД() : пусто;
                }

                цел результат;

                version(Win32)
                {
                        while ((результат = .выбери (т_сокет.max - 1, fr, fw, fe, tv)) == -1)
                        {
                                if(ВСАДайПоследнююОшибку() != WSAEINTR)
                                   break;
                        }
                }
                else version (Posix)
                {
                        т_сокет максуд = 0;

                        if (checkRead)
                                максуд = checkRead.максуд;

                        if (checkWrite && checkWrite.максуд > максуд)
                                максуд = checkWrite.максуд;

                        if (checkError && checkError.максуд > максуд)
                                максуд = checkError.максуд;

                        while ((результат = .выбери (максуд + 1, fr, fw, fe, tv)) == -1)
                        {
                                if(дайНомОш() != EINTR)
                                   break;
                        }
                }
                else
                {
                        static assert(0);
                }

                return результат;
        }

        /***********************************************************************

                выбери with specified таймаут

        ***********************************************************************/

        static цел выбери (НаборСокетов checkRead, НаборСокетов checkWrite, НаборСокетов checkError, дол микросекунды)
        {       
                значврем tv = {
                             cast(typeof(значврем.сек)) (микросекунды / 1000000), 
                             cast(typeof(значврем.микросекунды)) (микросекунды % 1000000)
                             };
                return выбери (checkRead, checkWrite, checkError, &tv);
        }

        /***********************************************************************

                выбери with maximum таймаут

        ***********************************************************************/

        static цел выбери (НаборСокетов checkRead, НаборСокетов checkWrite, НаборСокетов checkError)
        {
                return выбери (checkRead, checkWrite, checkError, пусто);
        }
}


