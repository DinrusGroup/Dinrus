﻿/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Oct 2007: Initial version

        author:         Kris

*******************************************************************************/

module io.vfs.FileFolder;

private import io.device.File;

private import Путь = io.Path;

private import exception;

public import io.vfs.model;

private import io.model;

private import time.Time : Время;

/*******************************************************************************

        Represents a physical папка in a файл system. Use one of these
        в_ адрес specific пути (sub-trees) within the файл system.

*******************************************************************************/

class ФайлПапка : ПапкаВфс
{
        private ткст          путь;
        private СтатсВфс        статс;

        /***********************************************************************

                Create a файл папка with the given путь. 

                Option 'создай' will создай the путь when установи да, 
                or reference an existing путь otherwise

        ***********************************************************************/

        this (ткст путь, бул создай=нет)
        {
                this.путь = открой (Путь.стандарт(путь.dup), создай);
        }

        /***********************************************************************

                создай a ФайлПапка as a Group member

        ***********************************************************************/

        private this (ткст путь, ткст имя)
        {
                this.путь = Путь.объедини (путь, имя);
        }

        /***********************************************************************

                explicitly создай() or открой() a named папка

        ***********************************************************************/

        private this (ФайлПапка предок, ткст имя, бул создай=нет)
        {
                assert (предок);
                this.путь = открой (Путь.объедини(предок.путь, имя), создай);
        }

        /***********************************************************************

                Return a крат имя

        ***********************************************************************/

        final ткст имя ()
        {
                return Путь.разбор(путь).имя;
        }

        /***********************************************************************

                Return a дол имя

        ***********************************************************************/

        final ткст вТкст ()
        {
                return путь;
        }

        /***********************************************************************

                A папка is being добавьed or removed из_ the иерархия. Use 
                this в_ тест for validity (or whatever) and throw exceptions 
                as necessary

                Here we тест for папка overlap, and bail-out when найдено.

        ***********************************************************************/

        final проц проверь (ПапкаВфс папка, бул mounting)
        {       
                if (mounting && cast(ФайлПапка) папка)
                   {
                   auto ист = Путь.ФС.псеп_в_конце (this.вТкст);
                   auto приёмн = Путь.ФС.псеп_в_конце (папка.вТкст);

                   auto длин = ист.length;
                   if (длин > приёмн.length)
                       длин = приёмн.length;

                   if (ист[0..длин] == приёмн[0..длин])
                       ошибка ("папки '"~приёмн~"' and '"~ист~"' overlap");
                   }
        }

        /***********************************************************************

                Return a contained файл representation 

        ***********************************************************************/

        final ФайлВфс файл (ткст имя)
        {
                return new ХостФайла (Путь.объедини (путь, имя));
        }

        /***********************************************************************

                Return a contained папка representation 

        ***********************************************************************/

        final ЗаписьПапкиВфс папка (ткст путь)
        {
                return new ХостПапки (this, путь);
        }

        /***********************************************************************

                Удали the папка subtree. Use with care!

        ***********************************************************************/

        final ПапкаВфс сотри ()
        {
                Путь.удали (Путь.коллируй(путь, "*", да));
                return this;
        }

        /***********************************************************************

                Is папка записываемый?

        ***********************************************************************/

        final бул записываемый ()
        {
                return Путь.записываем_ли (путь);
        }

        /***********************************************************************

                Returns контент information about this папка

        ***********************************************************************/

        final ПапкиВфс сам ()
        {
                return new ГруппаПапок (this, нет);
        }

        /***********************************************************************

                Returns a subtree of папки matching the given имя

        ***********************************************************************/

        final ПапкиВфс дерево ()
        {
                return new ГруппаПапок (this, да);
        }

        /***********************************************************************

                Iterate over the установи of immediate ветвь папки. This is 
                useful for reflecting the иерархия

        ***********************************************************************/

        final цел opApply (цел delegate(ref ПапкаВфс) дг)
        {
                цел результат;

                foreach (папка; папки(да))  
                        {
                        ПапкаВфс x = папка;  
                        if ((результат = дг(x)) != 0)
                             break;
                        }
                return результат;
        }

        /***********************************************************************

                Close and/or synchronize changes made в_ this папка. Each
                driver should take advantage of this as appropriate, perhaps
                combining multИПle файлы together, or possibly copying в_ a 
                remote location

        ***********************************************************************/

        ПапкаВфс закрой (бул подай = да)
        {
                return this;
        }

        /***********************************************************************
        
                Sweep owned папки 

        ***********************************************************************/

        private ФайлПапка[] папки (бул collect)
        {
                ФайлПапка[] папки;

                статс = статс.init;
                foreach (инфо; Путь.ветви (путь))
                         if (инфо.папка)
                            {
                            if (collect)
                                папки ~= new ФайлПапка (инфо.путь, инфо.имя);
                            ++статс.папки;
                            }
                         else
                            {
                            статс.байты += инфо.байты; 
                           ++статс.файлы;
                            }

                return папки;         
        }

        /***********************************************************************

                Sweep owned файлы

        ***********************************************************************/

        private ткст[] файлы (ref СтатсВфс статс, ФильтрВфс фильтр = пусто)
        {
                ткст[] файлы;

                foreach (инфо; Путь.ветви (путь))
                         if (инфо.папка is нет)
                             if (фильтр is пусто || фильтр(&инфо))
                                {
                                файлы ~= Путь.объедини (инфо.путь, инфо.имя);
                                статс.байты += инфо.байты; 
                                ++статс.файлы;
                                }

                return файлы;         
        }

        /***********************************************************************

                Throw an исключение

        ***********************************************************************/

        private ткст ошибка (ткст сооб)
        {
                throw new ВфсИскл (сооб);
        }

        /***********************************************************************

                Create or открой the given путь, and detect путь ошибки

        ***********************************************************************/

        private ткст открой (ткст путь, бул создай)
        {
                if (Путь.есть_ли (путь))
                   {
                   if (! Путь.папка_ли (путь))
                       ошибка ("ФайлПапка.открой :: путь существует, но из_ не папка: "~путь);
                   }
                else
                   if (создай)
                       Путь.создайПуть (путь);
                   else
                      ошибка ("ФайлПапка.открой :: путь не существует: "~путь);
                return путь;
        }
}


/*******************************************************************************

        Represents a группа of файлы (need this declared here в_ avoопр
        a bunch of bizarre compiler warnings)

*******************************************************************************/

class ГруппаФайлов : ФайлыВфс
{
        private ткст[]        группа;          // установи of filtered filenames
        private ткст[]        хосты;          // установи of containing папки
        private СтатсВфс        статс;          // статс for contained файлы

        /***********************************************************************

        ***********************************************************************/

        this (ГруппаПапок хост, ФильтрВфс фильтр)
        {
                foreach (папка; хост.члены)
                        {
                        auto файлы = папка.файлы (статс, фильтр);
                        if (файлы.length)
                           {
                           группа ~= файлы;
                           //хосты ~= папка.вТкст;
                           }
                        }
        }

        /***********************************************************************

                Iterate over the установи of contained ФайлВфс instances

        ***********************************************************************/

        final цел opApply (цел delegate(ref ФайлВфс) дг)
        {
                цел  результат;
                auto хост = new ХостФайла;

                foreach (файл; группа)    
                        {    
                        ФайлВфс x = хост;
                        хост.путь.разбор (файл);
                        if ((результат = дг(x)) != 0)
                             break;
                        } 
                return результат;
        }

        /***********************************************************************

                Return the total число of записи 

        ***********************************************************************/

        final бцел файлы ()
        {
                return группа.length;
        }

        /***********************************************************************

                Return the total размер of все файлы 

        ***********************************************************************/

        final бдол байты ()
        {
                return статс.байты;
        }
}


/*******************************************************************************

        A установи of папки representing a selection. This is where файл 
        selection is made, and образец-matched папка subsets can be
        extracted. You need one of these в_ expose statistics (such as
        файл or папка счёт) of a selected папка группа 

*******************************************************************************/

private class ГруппаПапок : ПапкиВфс
{
        private ФайлПапка[] члены;           // папки in группа

        /***********************************************************************

                Create a поднабор группа

        ***********************************************************************/

        private this () {}

        /***********************************************************************

                Create a папка группа включая the provопрed папка and
                (optionally) все ветвь папки

        ***********************************************************************/

        private this (ФайлПапка корень, бул рекурсия)
        {
                члены = корень ~ скан (корень, рекурсия);   
        }

        /***********************************************************************

                Iterate over the установи of contained ПапкаВфс instances

        ***********************************************************************/

        final цел opApply (цел delegate(ref ПапкаВфс) дг)
        {
                цел  результат;

                foreach (папка; члены)  
                        {
                        ПапкаВфс x = папка;  
                        if ((результат = дг(x)) != 0)
                             break;
                        }
                return результат;
        }

        /***********************************************************************

                Return the число of файлы in this группа

        ***********************************************************************/

        final бцел файлы ()
        {
                бцел файлы;
                foreach (папка; члены)
                         файлы += папка.статс.файлы;
                return файлы;
        }

        /***********************************************************************

                Return the total размер of все файлы in this группа

        ***********************************************************************/

        final бдол байты ()
        {
                бдол байты;

                foreach (папка; члены)
                         байты += папка.статс.байты;
                return байты;
        }

        /***********************************************************************

                Return the число of папки in this группа

        ***********************************************************************/

        final бцел папки ()
        {
                if (члены.length is 1)
                    return члены[0].статс.папки;
                return члены.length;
        }

        /***********************************************************************

                Return the total число of записи in this группа

        ***********************************************************************/

        final бцел записи ()
        {
                return файлы + папки;
        }

        /***********************************************************************

                Return a поднабор of папки matching the given образец

        ***********************************************************************/

        final ПапкиВфс поднабор (ткст образец)
        {  
                Путь.ПутеПарсер парсер;
                auto установи = new ГруппаПапок;

                foreach (папка; члены)    
                         if (Путь.совпадение (парсер.разбор(папка.путь).имя, образец))
                             установи.члены ~= папка; 
                return установи;
        }

        /***********************************************************************

                Return a установи of файлы matching the given образец

        ***********************************************************************/

        final ГруппаФайлов каталог (ткст образец)
        {
                бул foo (ИнфОВфс инфо)
                {
                        return Путь.совпадение (инфо.имя, образец);
                }

                return каталог (&foo);
        }

        /***********************************************************************

                Returns a установи of файлы conforming в_ the given фильтр

        ***********************************************************************/

        final ГруппаФайлов каталог (ФильтрВфс фильтр = пусто)
        {       
                return new ГруппаФайлов (this, фильтр);
        }

        /***********************************************************************

                Internal routine в_ traverse the папка дерево

        ***********************************************************************/

        private final ФайлПапка[] скан (ФайлПапка корень, бул рекурсия) 
        {
                auto папки = корень.папки (рекурсия);
                if (рекурсия)
                    foreach (ветвь; папки)
                             папки ~= скан (ветвь, рекурсия);
                return папки;
        }
}


/*******************************************************************************

        A хост for папки, currently used в_ harbor создай() and открой() 
        methods only

*******************************************************************************/

private class ХостПапки : ЗаписьПапкиВфс
{       
        private ткст          путь;
        private ФайлПапка      предок;

        /***********************************************************************

        ***********************************************************************/

        private this (ФайлПапка предок, ткст путь)
        {
                this.путь = путь;
                this.предок = предок;
        }

        /***********************************************************************

        ***********************************************************************/

        final ПапкаВфс создай ()
        {
                return new ФайлПапка (предок, путь, да);
        }

        /***********************************************************************

        ***********************************************************************/

        final ПапкаВфс открой ()
        {
                return new ФайлПапка (предок, путь, нет);
        }

        /***********************************************************************

                Test в_ see if a папка есть_ли

        ***********************************************************************/

        бул есть_ли ()
        {
                try {
                    открой();
                    return да;
                    } catch (ВВИскл x) {}
                return нет;
        }
}


/*******************************************************************************

        Represents things you can do with a файл 

*******************************************************************************/

private class ХостФайла : ФайлВфс
{
        private Путь.ПутеПарсер путь;

        /***********************************************************************

        ***********************************************************************/

        this (ткст путь = пусто)
        {
                this.путь.разбор (путь);
        }

        /***********************************************************************

                Return a крат имя

        ***********************************************************************/

        final ткст имя()
        {
                return путь.файл;
        }

        /***********************************************************************

                Return a дол имя

        ***********************************************************************/

        final ткст вТкст ()
        {
                return путь.вТкст;
        }

        /***********************************************************************

                Does this файл exist?

        ***********************************************************************/

        final бул есть_ли()
        {
                return Путь.есть_ли (путь.вТкст);
        }

        /***********************************************************************

                Return the файл размер

        ***********************************************************************/

        final бдол размер()
        {
                return Путь.размерФайла(путь.вТкст);
        }

        /***********************************************************************

                Create a new файл экземпляр

        ***********************************************************************/

        final ФайлВфс создай ()
        {
                Путь.создайФайл(путь.вТкст);
                return this;
        }

        /***********************************************************************

                Create a new файл экземпляр and наполни with поток

        ***********************************************************************/

        final ФайлВфс создай (ИПотокВвода ввод)
        {
                создай.вывод.копируй(ввод).закрой;
                return this;
        }

        /***********************************************************************

                Create and копируй the given источник

        ***********************************************************************/

        ФайлВфс копируй (ФайлВфс источник)
        {
                auto ввод = источник.ввод;
                scope (exit) ввод.закрой;
                return создай (ввод);
        }

        /***********************************************************************

                Create and копируй the given источник, and удали the источник

        ***********************************************************************/

        final ФайлВфс перемести (ФайлВфс источник)
        {
                копируй (источник);
                источник.удали;
                return this;
        }

        /***********************************************************************

                Return the ввод поток. Don't forget в_ закрой it

        ***********************************************************************/

        final ИПотокВвода ввод ()
        {
                return new Файл (путь.вТкст);
        }

        /***********************************************************************

                Return the вывод поток. Don't forget в_ закрой it

        ***********************************************************************/

        final ИПотокВывода вывод ()
        {
                return new Файл (путь.вТкст, Файл.WriteExisting);
        }

        /***********************************************************************

                Удали this файл

        ***********************************************************************/

        final ФайлВфс удали ()
        {
                Путь.удали (путь.вТкст);
                return this;
        }

        /***********************************************************************

                Duplicate this Запись

        ***********************************************************************/

        final ФайлВфс dup()
        {
                auto ret = new ХостФайла;
                ret.путь = путь.dup;
                return ret;
        }
        
        /***********************************************************************

                Modified время of the файл

        ***********************************************************************/

        final Время изменён ()
        {
                return Путь.штампыВремени(путь.вТкст).изменён;
        }
}


debug (ФайлПапка)
{

/*******************************************************************************

*******************************************************************************/

import io.Stdout;
import io.device.Array;

проц main()
{
        auto корень = new ФайлПапка ("d:/d/import/temp", да);
        корень.папка("тест").создай;
        корень.файл("тест.txt").создай(new Массив("hello"));
        Стдвыв.форматнс ("тест.txt.length = {}", корень.файл("тест.txt").размер);

        корень = new ФайлПапка ("c:/");
        auto установи = корень.сам;

        Стдвыв.форматнс ("сам.файлы = {}", установи.файлы);
        Стдвыв.форматнс ("сам.байты = {}", установи.байты);
        Стдвыв.форматнс ("сам.папки = {}", установи.папки);
        Стдвыв.форматнс ("сам.записи = {}", установи.записи);
/+
        установи = корень.дерево;
        Стдвыв.форматнс ("дерево.файлы = {}", установи.файлы);
        Стдвыв.форматнс ("дерево.байты = {}", установи.байты);
        Стдвыв.форматнс ("дерево.папки = {}", установи.папки);
        Стдвыв.форматнс ("дерево.записи = {}", установи.записи);

        //foreach (папка; установи)
        //Стдвыв.форматнс ("дерево.папка '{}' есть {} файлы", папка.имя, папка.сам.файлы);

        auto склей = установи.каталог ("s*");
        Стдвыв.форматнс ("склей.файлы = {}", склей.файлы);
        Стдвыв.форматнс ("склей.байты = {}", склей.байты);
+/
        //foreach (файл; склей)
        //         Стдвыв.форматнс ("склей.имя '{}' '{}'", файл.имя, файл.вТкст);
}
}
