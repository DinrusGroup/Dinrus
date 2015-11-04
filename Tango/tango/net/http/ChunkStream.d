/*******************************************************************************

        copyright:      Copyright (c) Nov 2007 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Nov 2007: Initial release

        author:         Kris

        Support for HTTP chunked I/O. 
        
        See http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html

*******************************************************************************/

module net.http.ChunkПоток;

private import  io.stream.Lines;

private import  io.device.Conduit,
                io.stream.Buffered;
                
private import  Целое = text.convert.Integer;

/*******************************************************************************

        Prefix each block of данные with its length (in hex digits) and добавь
        appropriate \r\n sequences. To подай the поток you'll need в_ use
        the терминируй() function and optionally provопрe it with a обрвызов 
        for writing trailing заголовки

*******************************************************************************/

class ChunkOutput : ФильтрВывода
{
        private БуферВывода вывод;

        /***********************************************************************

                Use a буфер belonging в_ our sibling, if one is available

        ***********************************************************************/

        this (ИПотокВывода поток)
        {
                super (вывод = Бвыв.создай(поток));
        }

        /***********************************************************************

                Write a chunk в_ the вывод, псеп_в_начале and postfixed in a 
                manner consistent with the HTTP chunked перемести coding

        ***********************************************************************/

        final override т_мера пиши (проц[] ист)
        {
                сим[8] врем =void;
                
                вывод.добавь (Целое.форматируй (врем, ист.length, "x"))
                      .добавь ("\r\n")
                      .добавь (ист)
                      .добавь ("\r\n");
                return ист.length;
        }

        /***********************************************************************

                Write a zero length chunk, trailing заголовки and a terminating 
                blank строка

        ***********************************************************************/

        final проц терминируй (проц delegate(БуферВывода) заголовки = пусто)
        {
                вывод.добавь ("0\r\n");
                if (заголовки)
                    заголовки (вывод);
                вывод.добавь ("\r\n");
        }
}


/*******************************************************************************

        Parse hex digits, and use the resultant размер в_ modulate requests 
        for incoming данные. A chunk размер of 0 terminates the поток, so в_
        читай any trailing заголовки you'll need в_ provопрe a delegate handler
        for receiving those

*******************************************************************************/

class ChunkInput : Строки!(сим)
{
        private alias проц delegate(ткст строка) Заголовки;

        private Заголовки         заголовки;
        private бцел            available;

        /***********************************************************************

                Prime the available chunk размер by reading and parsing the
                first available строка

        ***********************************************************************/

        this (ИПотокВвода поток, Заголовки заголовки = пусто)
        {
                установи (поток);
                this.заголовки = заголовки;
        }

        /***********************************************************************

                Reset ChunkInput в_ a new ИПотокВвода

        ***********************************************************************/

        override ChunkInput установи (ИПотокВвода поток)
        {
                super.установи (поток);
                available = nextChunk;
                return this;
        }

        /***********************************************************************

                Чтен контент based on a previously разобрано chunk размер

        ***********************************************************************/

        final override т_мера читай (проц[] приёмн)
        {
                if (available is 0)
                   {
                   // terminated 0 - читай заголовки and пустой строка, per rfc2616
                   ткст строка;
                   while ((строка = super.следщ).length)
                           if (заголовки)
                               заголовки (строка);
                   return ИПровод.Кф;
                   }
                        
                auto размер = приёмн.length > available ? available : приёмн.length;
                auto читай = super.читай (приёмн [0 .. размер]);
                
                // check for следщ chunk заголовок
                if (читай != ИПровод.Кф && (available -= читай) is 0)
                   {
                   // используй trailing \r\n
                   super.ввод.сместись (2);
                   available = nextChunk ();
                   }
                
                return читай;
        }

        /***********************************************************************

                Чтен and разбор другой chunk размер

        ***********************************************************************/

        private final бцел nextChunk ()
        {
                ткст врем;

                if ((врем = super.следщ).ptr)
                     return cast(бцел) Целое.разбор (врем, 16);
                return 0;
        }
}


/*******************************************************************************

*******************************************************************************/

debug (ChunkПоток)
{
        import io.Console;
        import io.device.Array;

        проц main()
        {
                auto буф = new Массив(40);
                auto chunk = new ChunkOutput (буф);
                chunk.пиши ("hello world");
                chunk.терминируй;
                auto ввод = new ChunkInput (буф);
                Квывод.поток.копируй (ввод);
        }
}
