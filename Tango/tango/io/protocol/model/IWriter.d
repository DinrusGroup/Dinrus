/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mar 2004: Initial release      
                        Dec 2006: Outback release
        
        author:         Kris
                        Ivan Senji (the "alias помести" опрea)

*******************************************************************************/

module io.protocol.model;

public import io.model.ИБуфер;

/*******************************************************************************

        ИПисатель interface. Писательs provопрe the means в_ добавь formatted 
        данные в_ an ИБуфер, and expose a convenient метод of handling a
        variety of данные типы. In добавьition в_ writing исконный типы such
        as целое and ткст, writers also process any class which есть
        implemented the ИЗаписываемое interface (one метод).

        все writers support the full установи of исконный данные типы, plus their
        fundamental Массив variants. Operations may be chained back-в_-back.

        Писательs support a Java-esque помести() notation. However, the Dinrus стиль
        is в_ place IO elements within their own parenthesis, like so:

        ---
        пиши (счёт) (" green bottles");
        ---

        Note that each записано element is distict; this стиль is affectionately
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

        // пиши данные типы out
        пиши (c) (i) (j) (d);

        // читай them back again
        читай (c) (i) (j) (d);


        // same thing again, but using помести() syntax instead
        пиши.помести(c).помести(i).помести(j).помести(d);
        читай.получи(c).получи(i).получи(j).получи(d);

        ---

        Писательs may also be used with any class implementing the ИЗаписываемое
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
        
                This is the mechanism used for binding arbitrary classes 
                в_ the IO system. If a class реализует ИЗаписываемое, it can
                be used as a мишень for ИПисатель помести() operations. That is, 
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
                if the operation fails. These are aliases for each другой

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

