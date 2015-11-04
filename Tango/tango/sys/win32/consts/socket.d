module sys.win32.consts.socket;

/***************************************************************


***************************************************************/

enum : цел
{
        МАСКА_ВВПАРАМ =  0x7f,
        ВВК_ВХО =        0x80000000,
        ВВФСБВВ =       (ВВК_ВХО | ((цел.sizeof & МАСКА_ВВПАРАМ) << 16) | (102 << 8) | 126),
}

/***************************************************************


***************************************************************/
enum {СОКОШИБ = -1}

enum
{
        //consistent
        Отладка =              0x1,

        //possibly Winsock-only values
        Вещание =          0x20,
        ПереиспАдр =          0x4,
        Заминка =             0x80,
        БезЗаминки =         ~(Заминка),
        СПДИнлайнинг =          0x100,
        ОтправБуф =             0x1001,
        ПолучБуф =             0x1002,
        Ошибка =              0x1007,

        Прослушивается =         0x2, // ?
        ОставатьсяНаСвязи =          0x8, // ?
        НеМаршрутизировать =          0x10, // ?
        Тип =               0x1008, // ?

        // OptionУровень.ИП settings
        ИПВ6МультикастХопс =      10,
        ИПВ6МультикастЦикл =     11,
        ИПВ6ВГруппу =     12,
        ИПВ6ИзГруппы =    13,

        // OptionУровень.ПУТ settings
        ПУТБезЗадержек =           0x0001,
}

/***************************************************************


***************************************************************/

enum
{
        SOL_СОКЕТ =  0xFFFF,
}

/***************************************************************


***************************************************************/

enum
{
        AF_UNSPEC =     0,
        AF_UNIX =       1,
        AF_INET =       2,
        AF_INET6 =      23,
        AF_ИПX =        6,
        AF_APPLETALK =  16,
}

/***********************************************************************

        Protocol

***********************************************************************/

enum
{
        ИППРОТ_ИП =    0,      /// internet протокол version 4
        ИППРОТ_ИПV4 =  4,      /// internet протокол version 4
        ИППРОТ_ИПV6 =  41,     /// internet протокол version 6
        ИППРОТ_ИПУС =  1,      /// internet control сообщение протокол
        ИППРОТ_ИПГУ =  2,      /// internet группа management протокол
        ИППРОТ_ВВП =   3,      /// gateway в_ gateway протокол
        ИППРОТ_ПУТ =   6,      /// transmission control протокол
        ИППРОТ_УПП =   12,     /// PARC universal packet протокол
        ИППРОТ_ППД =   17,     /// пользователь datagram протокол
        ИППРОТ_КСЕР =   22,     /// Xerox NS протокол
}

/***********************************************************************

         Communication semantics

***********************************************************************/

enum
{
        SOCK_STREAM =     1, /// sequenced, reliable, two-way communication-based байт Потокs
        SOCK_DGRAM =      2, /// connectionless, unreliable datagrams with a fixed maximum length; данные may be lost or arrive out of order
        SOCK_Необр =        3, /// необр протокол access
        SOCK_НДС =        4, /// reliably-delivered сообщение datagrams
        SOCK_ППП =  5, /// sequenced, reliable, two-way connection-based datagrams with a fixed maximum length
}
enum : бцел
{
        SCM_RIGHTS = 0x01
}
enum
{
        SOMAXCONN       = 128,
}

enum : бцел
{
        MSG_НеМаршрутизировать   = 0x4,
        MSG_СПД         = 0x1,
        MSG_Просмотр        = 0x2,
}

enum
{
        SHUT_RD = 0,
        SHUT_WR = 1,
        SHUT_RDWR = 2
}

enum: цел
{
         AI_PASSIVE = 0x00000001,               /// Сокет адрес will be used in свяжи() вызов
         AI_CANONNAME = 0x00000002,             /// Return canonical имя in first ai_canonname
         AI_NUMERICHOST = 0x00000004 ,          /// Nodename must be a numeric адрес ткст
         AI_NUMERICSERV = 0x00000008,           /// Servicename must be a numeric порт число
         AI_ALL = 0x00000100,                   /// Query Всё ИП6 and ИП4 with AI_V4MAPPED
         AI_ADDRCONFIG = 0x00000400,            /// Resolution only if global адрес configured
         AI_V4MAPPED = 0x00000800,              /// On v6 failure, запрос v4 and преобразуй в_ V4MAPPED форматируй
         AI_NON_AUTHORITATIVE = 0x00004000,     /// LUP_NON_AUTHORITATIVE
         AI_SECURE = 0x00008000,                /// LUP_SECURE
         AI_RETURN_PREFERRED_NAMES = 0x00010000,/// LUP_RETURN_PREFERRED_NAMES
         AI_FQDN = 0x00020000,                  /// Return the FQDN in ai_canonname
         AI_FILESERVER = 0x00040000,            /// Resolving fileserver имя resolution 
         AI_MASK = (AI_PASSIVE | AI_CANONNAME | AI_NUMERICHOST | AI_NUMERICSERV | AI_ADDRCONFIG),
         AI_DEFAULT = (AI_V4MAPPED | AI_ADDRCONFIG),
}

enum
{
        EAI_BADFLAGS = 10022,                   /// Invalid значение for `ai_flags' field.
        EAI_NONAME = 11001,                     /// NAME or Служба is неизвестное.
        EAI_AGAIN = 11002,                      /// Temporary failure in имя resolution.
        EAI_FAIL = 11003,                       /// Non-recoverable failure in имя рез.
        EAI_NODATA = 11001,                     /// No адрес associated with NAME.
        EAI_FAMILY = 10047,                     /// `ai_family' not supported.
        EAI_SOCKTYPE = 10044,                   /// `ai_socktype' not supported.
        EAI_SERVICE = 10109,                    /// Служба not supported for `ai_socktype'.
        EAI_MEMORY = 8,                         /// Memory allocation failure.
}       

enum
{
        NI_MAXHOST = 1025,
        NI_MAXSERV = 32,
        NI_NUMERICHOST = 0x01,                  /// Don't try в_ look up имя_хоста.
        NI_NUMERICSERV = 0x02,                  /// Don't преобразуй порт число в_ имя.
        NI_NOFQDN = 0x04,                       /// Only return nodename portion.
        NI_NAMEREQD = 0x08,                     /// Don't return numeric адресes.
        NI_ДГрамма = 0x10,                        /// Look up ППД служба rather than ПУТ.
}       

