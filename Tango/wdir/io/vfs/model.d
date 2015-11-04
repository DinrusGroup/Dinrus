﻿/*******************************************************************************

        copyright:      Copyright (c) 2007 Dinrus. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Jul 2007: Initial version

        author:         Lars Ivar, Kris

*******************************************************************************/

module io.vfs.model;

private import time.Time : Время;

private import io.model;


/*******************************************************************************

        alias ИнфОФайле for filtering

*******************************************************************************/

alias ИнфОФайле ИнфОФильтреВфс;
alias ИнфОФильтреВфс* ИнфОВфс;

// return нет в_ exclude something
alias бул delegate(ИнфОВфс) ФильтрВфс;


/*******************************************************************************

*******************************************************************************/

struct СтатсВфс
{
        бдол   байты;                  // байт счёт of файлы
        бцел    файлы,                  // число of файлы
                папки;                // число of папки
}

/*******************************************************************************

******************************************************************************/

interface ХостВфс : ПапкаВфс
{
        /**********************************************************************

                Добавь a ветвь папка. The ветвь cannot 'overlap' with другие
                in the дерево of the same тип. Circular references across a
                дерево of virtual папки are detected и trapped.

                The секунда аргумент represents an optional имя that the
                прикрепи should be known as, instead of the имя exposed by 
                the provопрed папка (it is not an alias).

        **********************************************************************/

        ХостВфс прикрепи (ПапкаВфс папка, ткст имя=пусто);

        /***********************************************************************

                Добавь a установи of ветвь папки. The ветви cannot 'overlap' 
                with другие in the дерево of the same тип. Circular references 
                are detected и trapped.

        ***********************************************************************/

        ХостВфс прикрепи (ПапкиВфс группа);

        /**********************************************************************

                Unhook a ветвь папка 

        **********************************************************************/

        ХостВфс открепи (ПапкаВфс папка);

        /**********************************************************************

                Добавь a symbolic link в_ другой файл. These are referenced
                by файл() alone, и do not show up in дерево traversals

        **********************************************************************/

        ХостВфс карта (ФайлВфс мишень, ткст имя);

        /***********************************************************************

                Добавь a symbolic link в_ другой папка. These are referenced
                by папка() alone, и do not show up in дерево traversals

        ***********************************************************************/

        ХостВфс карта (ЗаписьПапкиВфс мишень, ткст имя);
}


/*******************************************************************************

        Supports a model a bit like CSS selectors, where a selection
        of operands is made before applying some operation. For example:
        ---
        // счёт of файлы in this папка
        auto счёт = папка.сам.файлы;

        // accumulated файл байт-счёт
        auto байты = папка.сам.байты;

        // a группа of one папка (itself)
        auto папки = папка.сам;
        ---

        The same approach is использован в_ выбери the subtree descending из_
        a папка:
        ---
        // счёт of файлы in this дерево
        auto счёт = папка.дерево.файлы;

        // accumulated файл байт-счёт
        auto байты = папка.дерево.байты;

        // the группа of ветвь папки
        auto папки = папка.дерево;
        ---

        Filtering can be applied в_ the дерево resulting in a подст-группа. 
        Group operations remain applicable. Note that various wildcard 
        characters may be использован in the filtering:
        ---
        // выбери a поднабор of the resultant дерево
        auto папки = папка.дерево.поднабор("install");

        // получи total файл байты for a дерево поднабор, using wildcards
        auto байты = папка.дерево.поднабор("foo*").байты;
        ---

        Files are selected из_ a установи of папки in a similar manner:
        ---
        // файлы called "readme.txt" in this папка
        auto счёт = папка.сам.каталог("readme.txt").файлы;

        // файлы called "читай*.*" in this дерево
        auto счёт = папка.дерево.каталог("читай*.*").файлы;

        // все txt файлы belonging в_ папки starting with "ins"
        auto счёт = папка.дерево.поднабор("ins*").каталог("*.txt").файлы;

        // custom-filtered файлы внутри a subtree
        auto счёт = папка.дерево.каталог(&фильтр).файлы;
        ---

        Sets of папки и файлы support iteration via foreach:
        ---
        foreach (папка; корень.дерево)
                 Стдвыв.форматнс ("папка имя:{}", папка.имя);

        foreach (папка; корень.дерево.поднабор("ins*"))
                 Стдвыв.форматнс ("папка имя:{}", папка.имя);

        foreach (файл; корень.дерево.каталог("*.d"))
                 Стдвыв.форматнс ("файл имя:{}", файл.имя);
        ---

        Creating и opening a подст-папка is supported in a similar
        manner, where the single экземпляр is 'selected' before the
        operation is applied. Открыть differs из_ создай in that the
        папка must exist for the former:
        ---
        корень.папка("myNewFolder").создай;

        корень.папка("myExistingFolder").открой;
        ---
      
        Файл manИПulation is handled in much the same way:
        ---
        корень.файл("myNewFile").создай;

        auto источник = корень.файл("myExistingFile");
        корень.файл("myCopiedFile").копируй(источник);
        ---

        The princИПal benefits of these approaches are twofold: 1) it 
        turns out в_ be notably ещё efficient in terms of traversal, и 
        2) there's no casting требуется, since there is a clean separation 
        between файлы и папки.
        
        See ФайлВфс for ещё information on файл handling

*******************************************************************************/

interface ПапкаВфс
{
        /***********************************************************************

                Return a крат имя

        ***********************************************************************/

        ткст имя ();

        /***********************************************************************

                Return a дол имя

        ***********************************************************************/

        ткст вТкст ();

        /***********************************************************************

                Return a contained файл representation 

        ***********************************************************************/

        ФайлВфс файл (ткст путь);

        /***********************************************************************

                Return a contained папка representation 

        ***********************************************************************/

        ЗаписьПапкиВфс папка (ткст путь);

        /***********************************************************************

                Returns a папка установи containing only this one. Statistics 
                are включительно of записи внутри this папка only

        ***********************************************************************/

        ПапкиВфс сам ();

        /***********************************************************************

                Returns a subtree of папки. Statistics are включительно of 
                файлы внутри this папка и все другие внутри the дерево

        ***********************************************************************/

        ПапкиВфс дерево ();

        /***********************************************************************

                Iterate over the установи of immediate ветвь папки. This is 
                useful for reflecting the иерархия

        ***********************************************************************/

        цел opApply (цел delegate(ref ПапкаВфс) дг);

        /***********************************************************************

                Clear все контент из_ this папка и subordinates

        ***********************************************************************/

        ПапкаВфс очисть ();

        /***********************************************************************

                Is папка записываемый?

        ***********************************************************************/

        бул записываемый ();

        /***********************************************************************

                Close и/or synchronize changes made в_ this папка. Each
                driver should возьми advantage of this as appropriate, perhaps
                combining multИПle файлы together, or possibly copying в_ a 
                remote location

        ***********************************************************************/

        ПапкаВфс закрой (бул подай = да);

        /***********************************************************************

                A папка is being добавьed or removed из_ the иерархия. Use 
                this в_ тест for validity (or whatever) и throw exceptions 
                as necessary

        ***********************************************************************/

        проц проверь (ПапкаВфс папка, бул mounting);

        //ПапкаВфс копируй(ПапкаВфс из_, ткст в_);
        //ПапкаВфс перемести(Запись из_, ПапкаВфс toFolder, ткст toName);
        //ткст absolutePath(ткст путь);
}


/*******************************************************************************

        Operations upon a установи of папки 

*******************************************************************************/

interface ПапкиВфс
{
        /***********************************************************************

                Iterate over the установи of contained ПапкаВфс экземпляры

        ***********************************************************************/

        цел opApply (цел delegate(ref ПапкаВфс) дг);

        /***********************************************************************

                Return the число of файлы 

        ***********************************************************************/

        бцел файлы ();

        /***********************************************************************

                Return the число of папки 

        ***********************************************************************/

        бцел папки ();

        /***********************************************************************

                Return the total число of записи (файлы + папки)

        ***********************************************************************/

        бцел записи ();

        /***********************************************************************

                Return the total размер of contained файлы 

        ***********************************************************************/

        бдол байты ();

        /***********************************************************************

                Return a поднабор of папки совпадают the given образец

        ***********************************************************************/

        ПапкиВфс поднабор (ткст образец);

       /***********************************************************************

                Return a установи of файлы совпадают the given образец

        ***********************************************************************/

        ФайлыВфс каталог (ткст образец);

        /***********************************************************************

                Return a установи of файлы совпадают the given фильтр

        ***********************************************************************/

        ФайлыВфс каталог (ФильтрВфс фильтр = пусто);
}


/*******************************************************************************

        Operations upon a установи of файлы

*******************************************************************************/

interface ФайлыВфс
{
        /***********************************************************************

                Iterate over the установи of contained ФайлВфс экземпляры

        ***********************************************************************/

        цел opApply (цел delegate(ref ФайлВфс) дг);

        /***********************************************************************

                Return the total число of записи 

        ***********************************************************************/

        бцел файлы ();

        /***********************************************************************

                Return the total размер of все файлы 

        ***********************************************************************/

        бдол байты ();
}


/*******************************************************************************

        A specific файл representation 

*******************************************************************************/

interface ФайлВфс 
{
        /***********************************************************************

                Return a крат имя

        ***********************************************************************/

        ткст имя ();

        /***********************************************************************

                Return a дол имя

        ***********************************************************************/

        ткст вТкст ();

        /***********************************************************************

                Does this файл exist?

        ***********************************************************************/

        бул есть_ли ();

        /***********************************************************************

                Return the файл размер

        ***********************************************************************/

        бдол размер ();

        /***********************************************************************

                Созд и копируй the given источник

        ***********************************************************************/

        ФайлВфс копируй (ФайлВфс источник);

        /***********************************************************************

                Созд и копируй the given источник, и удали the источник

        ***********************************************************************/

        ФайлВфс перемести (ФайлВфс источник);

        /***********************************************************************

                Созд a new файл экземпляр

        ***********************************************************************/

        ФайлВфс создай ();

        /***********************************************************************

                Созд a new файл экземпляр и наполни with поток

        ***********************************************************************/

        ФайлВфс создай (ИПотокВвода поток);

        /***********************************************************************

                Удали this файл

        ***********************************************************************/

        ФайлВфс удали ();

        /***********************************************************************

                Return the ввод поток. Don't forget в_ закрой it

        ***********************************************************************/

        ИПотокВвода ввод ();

        /***********************************************************************

                Return the вывод поток. Don't forget в_ закрой it

        ***********************************************************************/

        ИПотокВывода вывод ();

        /***********************************************************************

                Duplicate this Запись

        ***********************************************************************/

        ФайлВфс dup ();
        
        /***********************************************************************
        
                The изменён время of the папка
        
        ***********************************************************************/
        
        Время изменён ();
}


/*******************************************************************************

        Handler for папка operations. Needs some work ...

*******************************************************************************/

interface ЗаписьПапкиВфс 
{
        /***********************************************************************

                Открыть a папка

        ***********************************************************************/

        ПапкаВфс открой ();

        /***********************************************************************

                Созд a new папка

        ***********************************************************************/

        ПапкаВфс создай ();

        /***********************************************************************

                Test в_ see if a папка есть_ли

        ***********************************************************************/

        бул есть_ли ();
}


/*******************************************************************************

    Would be использован for things like zИП файлы, where the
    implementation mantains the contents in память or on disk, и where
    the actual zИП файл isn't/shouldn't be записано until one is завершено
    filling it up (for zИП due в_ inefficient файл форматируй).

*******************************************************************************/

interface СинхВфс
{
        /***********************************************************************

        ***********************************************************************/

        ПапкаВфс синх ();
}

