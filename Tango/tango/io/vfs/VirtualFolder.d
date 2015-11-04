﻿/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Oct 2007: Initial version

        author:         Kris

*******************************************************************************/

module io.vfs.VirtualFolder;

private import exception;

private import io.model.IFile;

private import io.vfs.model;

private import io.Path : совпадение;

private import text.Util : голова, locatePrior;

/*******************************************************************************
        
        Virtual папки play хост в_ другой папка типы, включая Всё
        concrete папка instances and subordinate virtual папки. You 
        can build a (singly rooted) дерево из_ a установи of virtual and non-
        virtual папки, and treat them as though they were a combined
        or single сущность. For example, listing the contents of such a
        дерево is no different than listing the contents of a non-virtual
        дерево - there's just potentially ещё nodes в_ traverse.

*******************************************************************************/

class ВиртуальнаяПапка : ХостВфс
{
        private ткст                  name_;
        private ФайлВфс[ткст]         файлы;
        private ПапкаВфс[ткст]       грузы;
        private ЗаписьПапкиВфс[ткст]  папки;
        private ВиртуальнаяПапка           предок;

        /***********************************************************************

                все папка must have a имя. No '.' or '/' chars are 
                permitted

        ***********************************************************************/

        this (ткст имя)
        {
                оцени (this.name_ = имя);
        }

        /***********************************************************************

                Return the (крат) имя of this папка

        ***********************************************************************/

        final ткст имя()
        {
                return name_;
        }

        /***********************************************************************

                Return the (дол) имя of this папка. Virtual папки 
                do not have дол names, since they don't relate directly
                в_ a concrete папка экземпляр

        ***********************************************************************/

        final ткст вТкст()
        {
                return имя;
        }

        /***********************************************************************

                Добавь a ветвь папка. The ветвь cannot 'overlap' with другие
                in the дерево of the same тип. Circular references across a
                дерево of virtual папки are detected and trapped.

                The сукунда аргумент represents an optional имя that the
                прикрепи should be known as, instead of the имя exposed by 
                the provопрed папка (it is not an alias).

        ***********************************************************************/

        ХостВфс прикрепи (ПапкаВфс папка, ткст имя = пусто)
        {
                assert (папка);
                if (имя.length is 0)
                    имя = папка.имя;

                // link virtual ветви в_ us
                auto ветвь = cast(ВиртуальнаяПапка) папка;
                if (ветвь)
                    if (ветвь.предок)
                        ошибка ("папка '"~имя~"' belongs в_ другой хост"); 
                    else
                       ветвь.предок = this;

                // reach up в_ the корень, and initiate дерево смети
                auto корень = this;
                while (корень.предок)
                       if (корень is this)
                           ошибка ("circular reference detected at '"~this.имя~"' while mounting '"~имя~"'");
                       else
                          корень = корень.предок;
                корень.проверь (папка, да);

                // все сотри, so добавь the new папка
                грузы [имя] = папка;
                return this;
        }

        /***********************************************************************

                Добавь a установи of ветвь папки. The ветви cannot 'overlap' 
                with другие in the дерево of the same тип. Circular references 
                are detected and trapped.

        ***********************************************************************/

        ХостВфс прикрепи (ПапкиВфс группа)
        {
                foreach (папка; группа)
                         прикрепи (папка);
                return this;
        }

        /***********************************************************************

                Unhook a ветвь папка 

        ***********************************************************************/

        ХостВфс открепи (ПапкаВфс папка)
        {
                ткст имя = пусто;

                // check this is a ветвь, and locate the mapped имя
                foreach (ключ, значение; грузы)
                         if (папка is значение)
                             имя = ключ; 
                assert (имя.ptr);

                // reach up в_ the корень, and initiate дерево смети
                auto корень = this;
                while (корень.предок)
                       корень = корень.предок;
                корень.проверь (папка, нет);
        
                // все сотри, so удали it
                грузы.удали (имя);
                return this;
        }

        /***********************************************************************

                Добавь a symbolic link в_ другой файл. These are referenced
                by файл() alone, and do not show up in дерево traversals

        ***********************************************************************/

        final ХостВфс карта (ФайлВфс файл, ткст имя)
        {       
                assert (имя);
                файлы[имя] = файл;
                return this;
        }

        /***********************************************************************

                Добавь a symbolic link в_ другой папка. These are referenced
                by папка() alone, and do not show up in дерево traversals

        ***********************************************************************/

        final ХостВфс карта (ЗаписьПапкиВфс папка, ткст имя)
        {       
                assert (имя);
                папки[имя] = папка;
                return this;
        }

        /***********************************************************************

                Iterate over the установи of immediate ветвь папки. This is 
                useful for reflecting the иерархия

        ***********************************************************************/

        final цел opApply (цел delegate(ref ПапкаВфс) дг)
        {
                цел результат;

                foreach (папка; грузы)  
                        {
                        ПапкаВфс x = папка;  
                        if ((результат = дг(x)) != 0)
                             break;
                        }
                return результат;
        }

        /***********************************************************************

                Return a папка representation of the given путь. If the
                путь-голова does not refer в_ an immediate ветвь, and does
                not match a symbolic link, it is consопрered неизвестное.

        ***********************************************************************/

        final ЗаписьПапкиВфс папка (ткст путь)
        {
                ткст хвост;
                auto текст = голова (путь, ФайлКонст.СимПутьРазд, хвост);

                auto ветвь = текст in грузы;
                if (ветвь)
                    return ветвь.папка (хвост);

                auto sym = текст in папки;
                if (sym is пусто)
                    ошибка ("'"~текст~"' is not a recognized member of '"~имя~"'");
                return *sym;
        }

        /***********************************************************************

                Return a файл representation of the given путь. If the
                путь-голова does not refer в_ an immediate ветвь папка, 
                and does not match a symbolic link, it is consопрered неизвестное.

        ***********************************************************************/

        ФайлВфс файл (ткст путь)
        {
                auto хвост = locatePrior (путь, ФайлКонст.СимПутьРазд);
                if (хвост < путь.length)
                    return папка(путь[0..хвост]).открой.файл(путь[хвост..$]);

                auto sym = путь in файлы;
                if (sym is пусто)
                    ошибка ("'"~путь~"' is not a recognized member of '"~имя~"'");
                return *sym;
        }

        /***********************************************************************

                Clear the entire subtree. Use with caution

        ***********************************************************************/

        final ПапкаВфс сотри ()
        {
                foreach (имя, ветвь; грузы)
                         ветвь.сотри;
                return this;
        }

        /***********************************************************************

                Returns да if все of the ветви are записываемый

        ***********************************************************************/

        final бул записываемый ()
        {
                foreach (имя, ветвь; грузы)
                         if (! ветвь.записываемый)
                               return нет;
                return да;
        }

        /***********************************************************************

                Returns a папка установи containing only this one. Statistics 
                are включительно of записи within this папка only, which 
                should be zero since symbolic линки are not included

        ***********************************************************************/

        final ПапкиВфс сам ()
        {
                return new ВиртуальныеПапки (this, нет);
        }

        /***********************************************************************

                Returns a subtree of папки. Statistics are включительно of 
                все файлы and папки throughout the sub-дерево

        ***********************************************************************/

        final ПапкиВфс дерево ()
        {
                return new ВиртуальныеПапки (this, да);
        }

        /***********************************************************************

                Sweep the subtree of mountpoints, testing a new папка
                against все другие. This propogates a папка тест down
                throughout the дерево, where each папка implementation
                should take appropriate action

        ***********************************************************************/

        final проц проверь (ПапкаВфс папка, бул mounting)
        {
                foreach (имя, ветвь; грузы)
                         ветвь.проверь (папка, mounting);
        }

        /***********************************************************************

                Close and/or synchronize changes made в_ this папка. Each
                driver should take advantage of this as appropriate, perhaps
                combining multИПle файлы together, or possibly copying в_ a 
                remote location

        ***********************************************************************/

        ПапкаВфс закрой (бул подай = да)
        {
                foreach (имя, ветвь; грузы)
                         ветвь.закрой (подай);
                return this;
        }

        /***********************************************************************

                Throw an исключение

        ***********************************************************************/

        package final ткст ошибка (ткст сооб)
        {
                throw new ВфсИскл (сооб);
        }

        /***********************************************************************

                Valопрate путь names

        ***********************************************************************/

        private final проц оцени (ткст имя)
        {       
                assert (имя);
                if (locatePrior(имя, '.') != имя.length ||
                    locatePrior(имя, ФайлКонст.СимПутьРазд) != имя.length)
                    ошибка ("'"~имя~"' содержит неверные символы");
        }
}


/*******************************************************************************

        A установи of virtual папки. For a sub-дерево, we compose the results 
        of все our subordinates and delegate subsequent request в_ that
        группа.

*******************************************************************************/

private class ВиртуальныеПапки : ПапкиВфс
{
        private ПапкиВфс[] члены;           // папки in группа

        /***********************************************************************

                Create a поднабор группа

        ***********************************************************************/

        private this () {}

        /***********************************************************************

                Create a папка группа включая the provопрed папка and
                (optionally) все ветвь папки

        ***********************************************************************/

        private this (ВиртуальнаяПапка корень, бул рекурсия)
        {
                if (рекурсия)
                    foreach (имя, папка; корень.грузы)
                             члены ~= папка.дерево;
        }

        /***********************************************************************

                Iterate over the установи of contained ПапкаВфс instances

        ***********************************************************************/

        final цел opApply (цел delegate(ref ПапкаВфс) дг)
        {
                цел ret;

                foreach (группа; члены)  
                         foreach (папка; группа)
                                 { 
                                 auto x = cast(ПапкаВфс) папка;
                                 if ((ret = дг(x)) != 0)
                                      break;
                                 }
                return ret;
        }

        /***********************************************************************

                Return the число of файлы in this группа

        ***********************************************************************/

        final бцел файлы ()
        {
                бцел файлы;
                foreach (группа; члены)
                         файлы += группа.файлы;
                return файлы;
        }

        /***********************************************************************

                Return the total размер of все файлы in this группа

        ***********************************************************************/

        final бдол байты ()
        {
                бдол байты;
                foreach (группа; члены)
                         байты += группа.байты;
                return байты;
        }

        /***********************************************************************

                Return the число of папки in this группа

        ***********************************************************************/

        final бцел папки ()
        {
                бцел счёт;
                foreach (группа; члены)
                         счёт += группа.папки;
                return счёт;
        }

        /***********************************************************************

                Return the total число of записи in this группа

        ***********************************************************************/

        final бцел записи ()
        {
                бцел счёт;
                foreach (группа; члены)
                         счёт += группа.записи;
                return счёт;
        }

        /***********************************************************************

                Return a поднабор of папки matching the given образец

        ***********************************************************************/

        final ПапкиВфс поднабор (ткст образец)
        {  
                auto установи = new ВиртуальныеПапки;

                foreach (группа; члены)    
                         установи.члены ~= группа.поднабор (образец); 
                return установи;
        }

        /***********************************************************************

                Return a установи of файлы matching the given образец

        ***********************************************************************/

        final ФайлыВфс каталог (ткст образец)
        {
                return каталог ((ИнфОВфс инфо){return совпадение (инфо.имя, образец);});
        }

        /***********************************************************************

                Returns a установи of файлы conforming в_ the given фильтр

        ***********************************************************************/

        final ФайлыВфс каталог (ФильтрВфс фильтр = пусто)
        {       
                return new ВиртуальныеФайлы (this, фильтр);
        }
}


/*******************************************************************************

        A установи of virtual файлы, represented by composing the results of
        the given установи of папки. Subsequent calls are delegated в_ the
        results из_ those папки

*******************************************************************************/

private class ВиртуальныеФайлы : ФайлыВфс
{
        private ФайлыВфс[] члены;

        /***********************************************************************

        ***********************************************************************/

        private this (ВиртуальныеПапки хост, ФильтрВфс фильтр)
        {
                foreach (группа; хост.члены)    
                         члены ~= группа.каталог (фильтр); 
        }

        /***********************************************************************

                Iterate over the установи of contained ФайлВфс instances

        ***********************************************************************/

        final цел opApply (цел delegate(ref ФайлВфс) дг)
        {
                цел ret;

                foreach (группа; члены)    
                         foreach (файл; группа)    
                                  if ((ret = дг(файл)) != 0)
                                       break;
                return ret;
        }

        /***********************************************************************

                Return the total число of записи 

        ***********************************************************************/

        final бцел файлы ()
        {
                бцел счёт;
                foreach (группа; члены)    
                         счёт += группа.файлы;
                return счёт;
        }

        /***********************************************************************

                Return the total размер of все файлы 

        ***********************************************************************/

        final бдол байты ()
        {
                бдол счёт;
                foreach (группа; члены)    
                         счёт += группа.байты;
                return счёт;
        }
}


debug (ВиртуальнаяПапка)
{
/*******************************************************************************

*******************************************************************************/

import io.Stdout;
import io.vfs.FileFolder;

проц main()
{
        auto корень = new ВиртуальнаяПапка ("корень");
        auto sub  = new ВиртуальнаяПапка ("sub");
        sub.прикрепи (new ФайлПапка (r"d:/d/import/drTango"));

        корень.прикрепи (sub)
            .прикрепи (new ФайлПапка (r"c:/"), "windows")
            .прикрепи (new ФайлПапка (r"d:/d/import/temp"));

        auto папка = корень.папка (r"temp/bar");
        Стдвыв.форматнс ("папка = {}", папка);

        корень.карта (корень.папка(r"temp/subtree"), "fsym")
            .карта (корень.файл(r"temp/subtree/тест.txt"), "wumpus");
        auto файл = корень.файл (r"wumpus");
        Стдвыв.форматнс ("файл = {}", файл);
        Стдвыв.форматнс ("fsym = {}", корень.папка(r"fsym").открой.файл("тест.txt"));

        foreach (папка; корень.папка(r"temp/subtree").открой)
                 Стдвыв.форматнс ("папка.ветвь '{}'", папка.имя);

        auto установи = корень.сам;
        Стдвыв.форматнс ("сам.файлы = {}", установи.файлы);
        Стдвыв.форматнс ("сам.байты = {}", установи.байты);
        Стдвыв.форматнс ("сам.папки = {}", установи.папки);

        установи = корень.папка("temp").открой.дерево;
        Стдвыв.форматнс ("дерево.файлы = {}", установи.файлы);
        Стдвыв.форматнс ("дерево.байты = {}", установи.байты);
        Стдвыв.форматнс ("дерево.папки = {}", установи.папки);

        foreach (папка; установи)
                 Стдвыв.форматнс ("дерево.папка '{}' есть {} файлы", папка.имя, папка.сам.файлы);

        auto склей = установи.каталог ("*.txt");
        Стдвыв.форматнс ("склей.файлы = {}", склей.файлы);
        Стдвыв.форматнс ("склей.байты = {}", склей.байты);
        foreach (файл; склей)
                 Стдвыв.форматнс ("склей.имя '{}' '{}'", файл.имя, файл.вТкст);
}
}
