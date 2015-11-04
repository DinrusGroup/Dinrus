﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Jun 2004: Initial release
        version:        Dec 2006: Pacific release

        author:         Kris

*******************************************************************************/

module io.FileScan;

public  import io.FilePath;

private import exception;

/*******************************************************************************

        Recursively скан файлы and directories, добавьing filtered файлы в_
        an вывод structure as we go. This can be used в_ произведи a список
        of subdirectories and the файлы contained therein. The following
        example lists все файлы with суффикс ".d" located via the current
        дир, along with the папки containing them:
        ---
        auto скан = new СканФайл;

        скан (".", ".d");

        Стдвыв.форматнс ("{} Folders", скан.папки.length);
        foreach (папка; скан.папки)
                 Стдвыв.форматнс ("{}", папка);

        Стдвыв.форматнс ("\n{} Files", скан.файлы.length);
        foreach (файл; скан.файлы)
                 Стдвыв.форматнс ("{}", файл);
        ---

        This is unlikely the most efficient метод в_ скан a vast число of
        файлы, but operates in a convenient manner
        
*******************************************************************************/

class СканФайл
{       
        alias смети     opCall;

        ФПуть[]      наборФайлов;
        ткст[]        наборОшибок;
        ФПуть[]      наборПапок;
        
        /***********************************************************************

            Alias for Фильтр delegate. Accepts a ФПуть & a бул as 
            аргументы and returns a бул.

            The ФПуть аргумент represents a файл найдено by the скан, 
            and the бул whether the ФПуть represents a папка.

            The фильтр should return да, if matched by the фильтр. Note
            that returning нет where the путь is a папка will результат 
            in все файлы contained being ignored. To always рекурсия папки, 
            do something like this:
            ---
            return (папка_ли || match (fp.имя));
            ---

        ***********************************************************************/

        alias ФПуть.Фильтр Фильтр;

       /***********************************************************************

                Return все the ошибки найдено in the последний скан

        ***********************************************************************/

        public ткст[] ошибки ()
        {
                return наборОшибок;
        }

        /***********************************************************************

                Return все the файлы найдено in the последний скан

        ***********************************************************************/

        public ФПуть[] файлы ()
        {
                return наборФайлов;
        }

        /***********************************************************************
        
                Return все directories найдено in the последний скан

        ***********************************************************************/

        public ФПуть[] папки ()
        {
                return наборПапок;
        }

        /***********************************************************************

                Sweep a установи of файлы and directories из_ the given предок
                путь, with no filtering applied
        
        ***********************************************************************/
        
        СканФайл смети (ткст путь, бул рекурсия=да)
        {
                return смети (путь, cast(Фильтр) пусто, рекурсия);
        }

        /***********************************************************************

                Sweep a установи of файлы and directories из_ the given предок
                путь, where the файлы are filtered by the given суффикс
        
        ***********************************************************************/
        
        СканФайл смети (ткст путь, ткст match, бул рекурсия=да)
        {
                return смети (путь, (ФПуть fp, бул папка_ли)
                             {return папка_ли || fp.суффикс == match;}, рекурсия);
        }

        /***********************************************************************

                Sweep a установи of файлы and directories из_ the given предок
                путь, where the файлы are filtered by the provопрed delegate

        ***********************************************************************/
        
        СканФайл смети (ткст путь, Фильтр фильтр, бул рекурсия=да)
        {
                наборОшибок = пусто, наборФайлов = наборПапок = пусто;
                return скан (new ФПуть(путь), фильтр, рекурсия);
        }

        /***********************************************************************

                Internal routine в_ locate файлы and sub-directories. We
                пропусти записи with names composed only of '.' characters. 

        ***********************************************************************/

        private СканФайл скан (ФПуть папка, Фильтр фильтр, бул рекурсия) 
        {
                try {
                    auto пути = папка.вСписок (фильтр);
                
                    auto счёт = наборФайлов.length;
                    foreach (путь; пути)
                             if (! путь.папка_ли)
                                   наборФайлов ~= путь;
                             else
                                if (рекурсия)
                                    скан (путь, фильтр, рекурсия);
                
                    // добавь packages only if there's something in them
                    if (наборФайлов.length > счёт)
                        наборПапок ~= папка;

                    } catch (ВВИскл e)
                             наборОшибок ~= e.вТкст;
                return this;
        }
}


/*******************************************************************************

*******************************************************************************/

debug (СканФайл)
{
        import io.Stdout;

        проц main()
        {
                auto скан = new СканФайл;

                скан (".");

                Стдвыв.форматнс ("{} Folders", скан.папки.length);
                foreach (папка; скан.папки)
                         Стдвыв (папка).нс;

                Стдвыв.форматнс ("\n{} Files", скан.файлы.length);
                foreach (файл; скан.файлы)
                         Стдвыв (файл).нс;

                Стдвыв.форматнс ("\n{} Errors", скан.ошибки.length);
                foreach (ошибка; скан.ошибки)
                         Стдвыв (ошибка).нс;
        }
}
