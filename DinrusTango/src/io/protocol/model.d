/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Jan 2007: начальное release
        
        author:         Kris 

*******************************************************************************/

module io.protocol.model;

private import io.model;

/*******************************************************************************
        
*******************************************************************************/

abstract class ИПротокол
{
        enum Тип
        {
                Void = 0,
                Utf8, 
                Bool,
                Byte,
                UByte,
                Utf16,
                Short,
                UShort,
                Utf32,
                Int,
                UInt,
                Float,
                Long,
                ULong,
                Double,
                Real,
                Obj,
                Pointer,
        }
        
        /***********************************************************************

        ***********************************************************************/

        alias проц   delegate (ук ист, бцел байты, Тип тип) Писатель;
        alias проц   delegate (ук ист, бцел байты, Тип тип) ПисательМассива;

        alias проц[] delegate (ук приёмн, бцел байты, Тип тип) Читатель;
        alias проц[] delegate (Читатель читатель, бцел байты, Тип тип) Разместитель;

        alias проц[] delegate (ук приёмн, бцел байты, Тип тип, Разместитель) ЧитательМассива;
        
        /***********************************************************************

        ***********************************************************************/

        abstract ИБуфер буфер ();

        /***********************************************************************

        ***********************************************************************/

        abstract проц[] читай (ук приёмн, бцел байты, Тип тип);

        /***********************************************************************

        ***********************************************************************/

        abstract проц пиши (ук ист, бцел байты, Тип тип);

        /***********************************************************************

        ***********************************************************************/

        abstract проц[] читайМассив (ук приёмн, бцел байты, Тип тип, Разместитель размести);
        
        /***********************************************************************

        ***********************************************************************/

        abstract проц пишиМассив (ук ист, бцел байты, Тип тип);
}


/*******************************************************************************

*******************************************************************************/

abstract class ИРазместитель
{
        /***********************************************************************
        
        ***********************************************************************/

        abstract проц сбрось ();
        
        /***********************************************************************

        ***********************************************************************/

        abstract ИПротокол протокол ();

        /***********************************************************************

        ***********************************************************************/

        abstract проц[] размести (ИПротокол.Читатель, бцел байты, ИПротокол.Тип);
}

/*******************************************************************************

        ИЧитатель interface. Each читатель operates upon an ИБуфер, which is
        provопрed at construction время. Читательs are simple converters of данные,
        и have reasonably rigопр rules regarding данные форматируй. For example,
        each request for данные expects the контент в_ be available; an исключение
        is thrown where this is not the case. If the данные is arranged in a ещё
        relaxed fashion, consider using ИБуфер directly instead.

        все readers support the full установи of исконный данные типы, plus a full
        выделение of Массив типы. The latter can be configured в_ произведи
        either a копируй (.dup) of the буфер контент, or a срез. See classes
        КопияКучи, СрезБуфера и СрезКучи for ещё on this topic. Applications
        can disable память management by configuring a Читатель with one of the
        binary oriented protocols, и ensuring the optional протокол 'префикс'
        is disabled.

        Читательs support Java-esque получи() notation. However, the Dinrus
        стиль is в_ place IO элементы внутри their own parenthesis, like
        so:
        
        ---
        цел счёт;
        ткст verse;
        
        читай (verse) (счёт);
        ---

        Note that each элемент читай is distict; this стиль is affectionately
        known as "whisper". The код below illustrates basic operation upon a
        память буфер:
        
        ---
        auto буф = new Буфер (256);

        // карта same буфер преобр_в Всё читатель и писатель
        auto читай = new Читатель (буф);
        auto пиши = new Писатель (буф);

        цел i = 10;
        дол j = 20;
        дво d = 3.14159;
        ткст c = "fred";

        // пиши данные using whisper syntax
        пиши (c) (i) (j) (d);

        // читай them back again
        читай (c) (i) (j) (d);


        // same thing again, but using помести() syntax instead
        пиши.помести(c).помести(i).помести(j).помести(d);
        читай.получи(c).получи(i).получи(j).получи(d);
        ---

        Note that certain protocols, such as the basic binary implementation, 
        expect в_ retrieve the число of Массив элементы из_ the источник. For
        example: when reading an Массив из_ a файл, the число of элементы 
        is читай из_ the файл also, и the configurable память-manager is
        invoked в_ provопрe the Массив пространство. If контент is not arranged in
        such a manner you may читай Массив контент directly either by creating
        a Читатель with a протокол configured в_ sопрestep Массив-prefixing, or
        by accessing буфер контент directly (via the methods exposed there)
        e.g.

        ---
        проц[10] данные;
                
        читатель.буфер.заполни (данные);
        ---

        Читательs may also be использован with any class implementing the ИЧитаемое
        interface, along with any struct implementing an equivalent метод
        
*******************************************************************************/

abstract class ИЧитатель   // could be an interface, but that causes poor codegen
{
        alias получи opCall;

        /***********************************************************************
        
                These are the basic читатель methods

        ***********************************************************************/

        abstract ИЧитатель получи (inout бул x);
        abstract ИЧитатель получи (inout байт x);            /// ditto
        abstract ИЧитатель получи (inout ббайт x);           /// ditto
        abstract ИЧитатель получи (inout крат x);           /// ditto
        abstract ИЧитатель получи (inout бкрат x);          /// ditto
        abstract ИЧитатель получи (inout цел x);             /// ditto
        abstract ИЧитатель получи (inout бцел x);            /// ditto
        abstract ИЧитатель получи (inout дол x);            /// ditto
        abstract ИЧитатель получи (inout бдол x);           /// ditto
        abstract ИЧитатель получи (inout плав x);           /// ditto
        abstract ИЧитатель получи (inout дво x);          /// ditto
        abstract ИЧитатель получи (inout реал x);            /// ditto
        abstract ИЧитатель получи (inout сим x);            /// ditto
        abstract ИЧитатель получи (inout шим x);           /// ditto
        abstract ИЧитатель получи (inout дим x);           /// ditto

        abstract ИЧитатель получи (inout бул[] x);          /// ditto
        abstract ИЧитатель получи (inout байт[] x);          /// ditto
        abstract ИЧитатель получи (inout крат[] x);         /// ditto
        abstract ИЧитатель получи (inout цел[] x);           /// ditto
        abstract ИЧитатель получи (inout дол[] x);          /// ditto
        abstract ИЧитатель получи (inout ббайт[] x);         /// ditto
        abstract ИЧитатель получи (inout бкрат[] x);        /// ditto
        abstract ИЧитатель получи (inout бцел[] x);          /// ditto
        abstract ИЧитатель получи (inout бдол[] x);         /// ditto
        abstract ИЧитатель получи (inout плав[] x);         /// ditto
        abstract ИЧитатель получи (inout дво[] x);        /// ditto
        abstract ИЧитатель получи (inout реал[] x);          /// ditto
        abstract ИЧитатель получи (inout ткст x);          /// ditto
        abstract ИЧитатель получи (inout шим[] x);         /// ditto
        abstract ИЧитатель получи (inout дим[] x);         /// ditto

        /***********************************************************************
        
                This is the mechanism использован for binding arbitrary classes 
                в_ the IO system. If a class реализует ИЧитаемое, it can
                be использован as a мишень for ИЧитатель получи() operations. That is, 
                implementing ИЧитаемое is intended в_ трансформируй any class 
                преобр_в an ИЧитатель adaptor for the контент held therein.

        ***********************************************************************/

        abstract ИЧитатель получи (ИЧитаемое);

        alias проц delegate (ИЧитатель) Клозура;

        abstract ИЧитатель получи (Клозура);

        /***********************************************************************
        
                Return the буфер associated with this читатель

        ***********************************************************************/

        abstract ИБуфер буфер ();

        /***********************************************************************
        
                Get the разместитель в_ use for Массив management. Arrays are
                generally allocated by the ИЧитатель, via configured managers.
                A число of Разместитель classes are available в_ manage память
                when reading Массив контент. Alternatively, the application
                may obtain responsibility for allocation by selecting one of
                the ПротоколНатив deriviatives и настройка 'префикс' в_ be
                нет. The latter disables internal Массив management.

                Gaining доступ в_ the разместитель can expose some добавьitional
                controls. For example, some allocators benefit из_ a сбрось
                operation after each данные 'record' имеется been processed.

                By default, an ИЧитатель will размести each Массив из_ the 
                куча. You can change that by constructing the Читатель
                with an Разместитель of choice. For экземпляр, there is a
                СрезБуфера which will срез an Массив directly из_
                the буфер where possible. Also available is the record-
                oriented HeaoSlice, which slices память из_ внутри
                a pre-allocated куча area, и should be сбрось by the клиент
                код after each record имеется been читай (в_ avoопр unnecessary
                growth). 

                See module io.protocol.Allocator for ещё information

        ***********************************************************************/

        abstract ИРазместитель разместитель (); 
}

/*******************************************************************************

        Any class implementing ИЧитаемое becomes часть of the Читатель framework
        
*******************************************************************************/

interface ИЧитаемое
{
        проц читай (ИЧитатель ввод);
}

/*******************************************************************************

        ИПисатель interface. Writers provопрe the means в_ добавь formatted 
        данные в_ an ИБуфер, и expose a convenient метод of handling a
        variety of данные типы. In добавьition в_ writing исконный типы such
        as целое и ткст, writers also process any class which имеется
        implemented the ИЗаписываемое interface (one метод).

        все writers support the full установи of исконный данные типы, plus their
        fundamental Массив variants. Operations may be chained back-в_-back.

        Writers support a Java-esque помести() notation. However, the Dinrus стиль
        is в_ place IO элементы внутри their own parenthesis, like so:

        ---
        пиши (счёт) (" green bottles");
        ---

        Note that each записано элемент is distict; this стиль is affectionately
        known as "whisper". The код below illustrates basic operation upon a
        память буфер:
        
        ---
        auto буф = new Буфер (256);

        // карта same буфер преобр_в Всё читатель и писатель
        auto читай = new Читатель (буф);
        auto пиши = new Писатель (буф);

        цел i = 10;
        дол j = 20;
        дво d = 3.14159;
        ткст c = "fred";

        // пиши данные типы out
        пиши (c) (i) (j) (d);

        // читай them back again
        читай (c) (i) (j) (d);


        // same thing again, but using помести() syntax instead
        пиши.помести(c).помести(i).помести(j).помести(d);
        читай.получи(c).получи(i).получи(j).получи(d);

        ---

        Writers may also be использован with any class implementing the ИЗаписываемое
        interface, along with any struct implementing an equivalent function.

*******************************************************************************/

abstract class ИПисатель  // could be an interface, but that causes poor codegen
{
        alias помести opCall;

        /***********************************************************************
        
                These are the basic писатель methods

        ***********************************************************************/

        abstract ИПисатель помести (бул x);
        abstract ИПисатель помести (ббайт x);         ///ditto
        abstract ИПисатель помести (байт x);          ///ditto
        abstract ИПисатель помести (бкрат x);        ///ditto
        abstract ИПисатель помести (крат x);         ///ditto
        abstract ИПисатель помести (бцел x);          ///ditto
        abstract ИПисатель помести (цел x);           ///ditto
        abstract ИПисатель помести (бдол x);         ///ditto
        abstract ИПисатель помести (дол x);          ///ditto
        abstract ИПисатель помести (плав x);         ///ditto
        abstract ИПисатель помести (дво x);        ///ditto
        abstract ИПисатель помести (реал x);          ///ditto
        abstract ИПисатель помести (сим x);          ///ditto
        abstract ИПисатель помести (шим x);         ///ditto
        abstract ИПисатель помести (дим x);         ///ditto

        abstract ИПисатель помести (бул[] x);
        abstract ИПисатель помести (байт[] x);        ///ditto
        abstract ИПисатель помести (крат[] x);       ///ditto
        abstract ИПисатель помести (цел[] x);         ///ditto
        abstract ИПисатель помести (дол[] x);        ///ditto
        abstract ИПисатель помести (ббайт[] x);       ///ditto
        abstract ИПисатель помести (бкрат[] x);      ///ditto
        abstract ИПисатель помести (бцел[] x);        ///ditto
        abstract ИПисатель помести (бдол[] x);       ///ditto
        abstract ИПисатель помести (плав[] x);       ///ditto
        abstract ИПисатель помести (дво[] x);      ///ditto
        abstract ИПисатель помести (реал[] x);        ///ditto
        abstract ИПисатель помести (ткст x);        ///ditto
        abstract ИПисатель помести (шим[] x);       ///ditto
        abstract ИПисатель помести (дим[] x);       ///ditto

        /***********************************************************************
        
                This is the mechanism использован for binding arbitrary classes 
                в_ the IO system. If a class реализует ИЗаписываемое, it can
                be использован as a мишень for ИПисатель помести() operations. That is, 
                implementing ИЗаписываемое is intended в_ трансформируй any class 
                преобр_в an ИПисатель adaptor for the контент held therein

        ***********************************************************************/

        abstract ИПисатель помести (ИЗаписываемое);

        alias проц delegate (ИПисатель) Клозура;

        abstract ИПисатель помести (Клозура);

        /***********************************************************************
        
                Emit a нс
                
        ***********************************************************************/

        abstract ИПисатель нс ();
        
        /***********************************************************************
        
                Flush the вывод of this писатель. Throws an ВВИскл 
                if the operation fails. These are алиасы for each другой

        ***********************************************************************/

        abstract ИПисатель слей ();
        abstract ИПисатель помести ();        ///ditto

        /***********************************************************************
        
                Return the associated буфер

        ***********************************************************************/

        abstract ИБуфер буфер ();
}


/*******************************************************************************

        Interface в_ сделай any class compatible with any ИПисатель

*******************************************************************************/

interface ИЗаписываемое
{
        abstract проц пиши (ИПисатель ввод);
}


