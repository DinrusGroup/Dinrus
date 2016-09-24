﻿/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: Oct 2007

        author:         Kris

*******************************************************************************/

module io.stream.Snoop;

private import  io.Console,
                io.device.Conduit;

private import  text.convert.Format;

private alias проц delegate(ткст) Снуп;

/*******************************************************************************

        Поток в_ expose вызов behaviour. By default, activity след is
        sent в_ Кош

*******************************************************************************/

class СнупВвод : ИПотокВвода
{
        private ИПотокВвода     хост;
        private Снуп           snoop;

        /***********************************************************************

                Attach в_ the provопрed поток

        ***********************************************************************/

        this (ИПотокВвода хост, Снуп snoop = пусто)
        {
                assert (хост);
                this.хост = хост;
                this.snoop = snoop ? snoop : &снупер;
        }

        /***********************************************************************

                Return the upПоток хост of this фильтр
                        
        ***********************************************************************/

        ИПотокВвода ввод ()
        {
                return хост;
        }            

        /***********************************************************************

                Return the hosting провод

        ***********************************************************************/

        final ИПровод провод ()
        {
                return хост.провод;
        }

        /***********************************************************************

                Чтен из_ провод преобр_в a мишень Массив. The provопрed приёмн 
                will be populated with контент из_ the провод. 

                Returns the число of байты читай, which may be less than
                requested in приёмн

        ***********************************************************************/

        final т_мера читай (проц[] приёмн)
        {
                auto x = хост.читай (приёмн);
                след ("{}: считано {} байтов", хост.провод, x is -1 ? 0 : x);
                return x;
        }

        /***********************************************************************

                Load the биты из_ a поток, and return them все in an
                Массив. The приёмн Массив can be provопрed as an опция, which
                will be expanded as necessary в_ используй the ввод.

                Returns an Массив representing the контент, and throws
                ВВИскл on ошибка
                              
        ***********************************************************************/

        проц[] загрузи (т_мера max=-1)
        {
                auto x = хост.загрузи (max);
                след ("{}: загружено {} байт", x.length);
                return x;
        }

        /***********************************************************************

                Clear any buffered контент

        ***********************************************************************/

        final ИПотокВвода слей ()
        {
                хост.слей;
                след ("{}: слит/очищен", хост.провод);
                return this;
        }

        /***********************************************************************

                Close the ввод

        ***********************************************************************/

        final проц закрой ()
        {
                хост.закрой;
                след ("{}: закрыт", хост.провод);
        }

        /***********************************************************************
        
                Seek on this поток. Target conduits that don't support
                seeking will throw an ВВИскл

        ***********************************************************************/

        final дол сместись (дол смещение, Якорь якорь = Якорь.Нач)
        {
                auto s = хост.сместись (смещение, якорь);
                след ("{}: смещение на смещение {} от якоря {}", хост.провод, смещение, якорь);
                return s;
        }

        /***********************************************************************

                Internal след handler

        ***********************************************************************/

        private проц снупер (ткст x)
        {
                Кош(x).нс;
        }

        /***********************************************************************

                Internal след handler

        ***********************************************************************/

        private проц след (ткст форматируй, ...)
        {
                сим[256] врем =void;
                snoop (Формат.vprint (врем, форматируй, _arguments, _argptr));
        }
}


/*******************************************************************************

        Поток в_ expose вызов behaviour. By default, activity след is
        sent в_ Кош

*******************************************************************************/

class СнупВывод : ИПотокВывода
{
        private ИПотокВывода    хост;
        private Снуп           snoop;

        /***********************************************************************

                Attach в_ the provопрed поток

        ***********************************************************************/

        this (ИПотокВывода хост, Снуп snoop = пусто)
        {
                assert (хост);
                this.хост = хост;
                this.snoop = snoop ? snoop : &снупер;
        }

        /***********************************************************************
        
                Return the upПоток хост of this фильтр
                        
        ***********************************************************************/

        ИПотокВывода вывод ()
        {
                return хост;
        }              

        /***********************************************************************

                Write в_ провод из_ a источник Массив. The provопрed ист
                контент will be записано в_ the провод.

                Returns the число of байты записано из_ ист, which may
                be less than the quantity provопрed

        ***********************************************************************/

        final т_мера пиши (проц[] ист)
        {
                auto x = хост.пиши (ист);
                след ("{}: записано {} байтов", хост.провод, x is -1 ? 0 : x);
                return x;
        }

        /***********************************************************************

                Return the hosting провод

        ***********************************************************************/

        final ИПровод провод ()
        {
                return хост.провод;
        }

        /***********************************************************************

                Emit/purge buffered контент

        ***********************************************************************/

        final ИПотокВывода слей ()
        {
                хост.слей;
                след ("{}: слито", хост.провод);
                return this;
        }

        /***********************************************************************

                Close the вывод

        ***********************************************************************/

        final проц закрой ()
        {
                хост.закрой;
                след ("{}: закрыт", хост.провод);
        }

        /***********************************************************************

                Transfer the контент of другой провод в_ this one. Returns
                a reference в_ this class, or throws ВВИскл on failure.

        ***********************************************************************/

        final ИПотокВывода копируй (ИПотокВвода ист, т_мера max=-1)
        {
                хост.копируй (ист, max);
                след("{}: скопировано из {}", хост.провод, ист.провод);
                return this;
        }

        /***********************************************************************
        
                Seek on this поток. Target conduits that don't support
                seeking will throw an ВВИскл

        ***********************************************************************/

        final дол сместись (дол смещение, Якорь якорь = Якорь.Нач)
        {
                auto s = хост.сместись (смещение, якорь);
                след ("{}: смещение на смещение {} от якоря {}", хост.провод, смещение, якорь);
                return s;
        }

        /***********************************************************************

                Internal след handler

        ***********************************************************************/

        private проц снупер (ткст x)
        {
                Кош(x).нс;
        }

        /***********************************************************************

                Internal след handler

        ***********************************************************************/

        private проц след (ткст форматируй, ...)
        {
                сим[256] врем =void;
                snoop (Формат.vprint (врем, форматируй, _arguments, _argptr));
        }
}



debug (Снуп)
{
        проц main()
        {
                auto s = new СнупВвод (пусто);
                auto o = new СнупВывод (пусто);
        }
}
