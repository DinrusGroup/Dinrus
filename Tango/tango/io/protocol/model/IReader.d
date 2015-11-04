/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Oct 2004: Initial release      
                        Dec 2006: Outback release
        
        author:         Kris
                        Ivan Senji (the "alias получи" опрea)

*******************************************************************************/

module io.protocol.model;

public import io.model.ИБуфер;

private import io.protocol.model;

/*******************************************************************************

        ИЧитатель interface. Each читатель operates upon an ИБуфер, which is
        provопрed at construction время. Читательs are simple converters of данные,
        and have reasonably rigопр rules regarding данные форматируй. For example,
        each request for данные expects the контент в_ be available; an исключение
        is thrown where this is not the case. If the данные is arranged in a ещё
        relaxed fashion, consопрer using ИБуфер directly instead.

        все readers support the full установи of исконный данные типы, plus a full
        selection of Массив типы. The latter can be configured в_ произведи
        either a копируй (.dup) of the буфер контент, or a срез. See classes
        КопияКучи, СрезБуфера and СрезКучи for ещё on this topic. Applications
        can disable память management by configuring a Читатель with one of the
        binary oriented protocols, and ensuring the optional протокол 'префикс'
        is disabled.

        Читательs support Java-esque получи() notation. However, the Dinrus
        стиль is в_ place IO elements within their own parenthesis, like
        so:
        
        ---
        цел счёт;
        ткст verse;
        
        читай (verse) (счёт);
        ---

        Note that each element читай is distict; this стиль is affectionately
        known as "whisper". The код below illustrates basic operation upon a
        память буфер:
        
        ---
        auto буф = new Буфер (256);

        // карта same буфер преобр_в Всё читатель and писатель
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
        expect в_ retrieve the число of Массив elements из_ the источник. For
        example: when reading an Массив из_ a файл, the число of elements 
        is читай из_ the файл also, and the configurable память-manager is
        invoked в_ provопрe the Массив пространство. If контент is not arranged in
        such a manner you may читай Массив контент directly either by creating
        a Читатель with a протокол configured в_ sопрestep Массив-prefixing, or
        by accessing буфер контент directly (via the methods exposed there)
        e.g.

        ---
        проц[10] данные;
                
        читатель.буфер.заполни (данные);
        ---

        Читательs may also be used with any class implementing the ИЧитаемое
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
        
                This is the mechanism used for binding arbitrary classes 
                в_ the IO system. If a class реализует ИЧитаемое, it can
                be used as a мишень for ИЧитатель получи() operations. That is, 
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
                the ПротоколНатив deriviatives and настройка 'префикс' в_ be
                нет. The latter disables internal Массив management.

                Gaining access в_ the разместитель can expose some добавьitional
                controls. For example, some allocators benefit из_ a сбрось
                operation after each данные 'record' есть been processed.

                By default, an ИЧитатель will размести each Массив из_ the 
                куча. You can change that by constructing the Читатель
                with an Разместитель of choice. For экземпляр, there is a
                СрезБуфера which will срез an Массив directly из_
                the буфер where possible. Also available is the record-
                oriented HeaoSlice, which slices память из_ within
                a pre-allocated куча area, and should be сбрось by the клиент
                код after each record есть been читай (в_ avoопр unnecessary
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

