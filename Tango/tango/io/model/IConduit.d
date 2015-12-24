﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: March 2004      
                        Outback release: December 2006
        
        author:         Kris

*******************************************************************************/

module io.model;

/*******************************************************************************

        Conduits provопрe virtualized access в_ external контент, and 
        represent things like файлы or Internet connections. Conduits 
        expose a pair of Потокs, are modelled by io.model, 
        and are implemented via classes such as Файл & СокетПровод. 
        
        добавьitional kinds of провод are easy в_ construct: one either 
        subclasses io.device.Conduit, or реализует io.model. 
        A провод typically reads and writes из_/в_ an ИБуфер in large 
        chunks, typically the entire буфер. Alternatively, one can invoke 
        ввод.читай(приёмн[]) and/or вывод.пиши(ист[]) directly.

*******************************************************************************/

interface ИПровод : ИПотокВвода, ИПотокВывода
{
        /***********************************************************************
        
                Return a preferred размер for buffering провод I/O

        ***********************************************************************/

        abstract т_мера размерБуфера (); 
                     
        /***********************************************************************
        
                Return the имя of this провод

        ***********************************************************************/

        abstract ткст вТкст (); 

        /***********************************************************************

                Is the провод alive?

        ***********************************************************************/

        abstract бул жив_ли ();

        /***********************************************************************
                
                Release external resources

        ***********************************************************************/

        abstract проц открепи ();

        /***********************************************************************

                Throw a generic IO исключение with the provопрed сооб

        ***********************************************************************/

        abstract проц ошибка (ткст сооб);

        /***********************************************************************

                все Потокs сейчас support сместись(), so this is used в_ signal
                a seekable провод instead

        ***********************************************************************/

        interface Seek {}

        /***********************************************************************

                Indicates the провод supports resize/truncation

        ***********************************************************************/

        interface Truncate 
        {
                проц обрежь (дол размер);
        }
}


/*******************************************************************************

        Describes как в_ сделай an IO сущность usable with selectors
        
*******************************************************************************/

interface ИВыбираемый
{     
        version (Windows) 
                 alias ук  Дескр;   /// opaque OS файл-укз         
             else
                typedef цел Дескр = -1;        /// opaque OS файл-укз        

        /***********************************************************************

                Models a укз-oriented устройство. 

                TODO: figure out как в_ avoопр exposing this in the general
                case

        ***********************************************************************/

        Дескр ptr ();
}


/*******************************************************************************
        
        The common атрибуты of Потокs

*******************************************************************************/

interface IOПоток 
{
        const Кф = -1;         /// the End-of-Flow опрentifer

        /***********************************************************************
        
                The якорь positions supported by сместись()

        ***********************************************************************/

        enum Якорь {
                    Начало   = 0,
                    Текущий = 1,
                    End     = 2,
                    };

        /***********************************************************************
                
                Move the поток позиция в_ the given смещение из_ the 
                provопрed якорь point, and return adjusted позиция.

                Those conduits which don't support seeking will throw
                an ВВИскл (and don't implement ИПровод.ИШаг)

        ***********************************************************************/

        дол сместись (дол смещение, Якорь якорь = Якорь.Нач);

        /***********************************************************************
        
                Return the хост провод

        ***********************************************************************/

        ИПровод провод ();
                          
        /***********************************************************************
        
                Flush buffered контент. For ИПотокВвода this is equivalent
                в_ clearing buffered контент

        ***********************************************************************/

        IOПоток слей ();               
        
        /***********************************************************************
        
                Close the ввод

        ***********************************************************************/

        проц закрой ();               


        /***********************************************************************
        
                Marks a поток that performs читай/пиши mutation, rather than 
                generic decoration. This is used в_ опрentify those поток that
                should explicitly not совместно an upПоток буфер with downПоток
                siblings.
        
                Many Потокs добавь simple decoration (such as DataПоток) while
                другие are merely template aliases. However, Потокs such as
                EndianПоток mutate контент as it проходки through the читай and
                пиши methods, which must be respected. On one hand we wish
                в_ совместно a single буфер экземпляр, while on the другой we must
                ensure correct данные flow through an arbitrary combinations of  
                Потокs. 

                There are two поток variations: one which operate directly 
                upon память (and thus must have access в_ a буфер) and другой 
                that prefer в_ have buffered ввод (for performance reasons) but 
                can operate without. EndianПоток is an example of the former, 
                while DataПоток represents the latter.
        
                In order в_ сортируй out who gets what, each поток makes a request
                for an upПоток буфер at construction время. The request есть an
                indication of the intended purpose (Массив-based access, or not). 

        ***********************************************************************/

        interface Переключатель {}
}


/*******************************************************************************
        
        The Dinrus ввод поток

*******************************************************************************/

interface ИПотокВвода : IOПоток
{
        /***********************************************************************
        
                Чтен из_ поток преобр_в a мишень Массив. The provопрed приёмн 
                will be populated with контент из_ the поток. 

                Returns the число of байты читай, which may be less than
                requested in приёмн. Кф is returned whenever an конец-of-flow 
                condition arises.

        ***********************************************************************/

        т_мера читай (проц[] приёмн);               
                        
        /***********************************************************************

                Load the биты из_ a поток, and return them все in an
                Массив. The optional max значение indicates the maximum
                число of байты в_ be читай.

                Returns an Массив representing the контент, and throws
                ВВИскл on ошибка
                              
        ***********************************************************************/

        проц[] загрузи (т_мера max = -1);
        
        /***********************************************************************
        
                Return the upПоток источник

        ***********************************************************************/

        ИПотокВвода ввод ();               
}


/*******************************************************************************
        
        The Dinrus вывод поток

*******************************************************************************/

interface ИПотокВывода : IOПоток
{
        /***********************************************************************
        
                Write в_ поток из_ a источник Массив. The provопрed ист
                контент will be записано в_ the поток.

                Returns the число of байты записано из_ ист, which may
                be less than the quantity provопрed. Кф is returned when 
                an конец-of-flow condition arises.

        ***********************************************************************/

        т_мера пиши (проц[] ист);     
        
        /***********************************************************************

                Transfer the контент of другой поток в_ this one. Returns
                a reference в_ this class, and throws ВВИскл on failure.

        ***********************************************************************/

        ИПотокВывода копируй (ИПотокВвода ист, т_мера max = -1);
                          
        /***********************************************************************
        
                Return the upПоток сток

        ***********************************************************************/

        ИПотокВывода вывод ();               
}


/*******************************************************************************
        
        A buffered ввод поток

*******************************************************************************/

interface БуферВвода : ИПотокВвода
{
        проц[] срез ();

        бул следщ (т_мера delegate(проц[]) скан);

        т_мера читатель (т_мера delegate(проц[]) consumer);
}

/*******************************************************************************
        
        A buffered вывод поток

*******************************************************************************/

interface БуферВывода : ИПотокВывода
{
        alias добавь opCall;

        проц[] срез ();
        
        БуферВывода добавь (проц[]);

        т_мера писатель (т_мера delegate(проц[]) producer);
}

