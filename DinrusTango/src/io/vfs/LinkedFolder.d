/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Oct 2007: Initial version

        author:         Kris

*******************************************************************************/

module io.vfs.LinkedFolder;

private import io.vfs.model;

private import exception;

private import io.vfs.VirtualFolder;

/*******************************************************************************
        
        LinkedFolder is производный из_ ВиртуальнаяПапка, и behaves exactly the 
        same in все but one aspect: it treats mounted папки as an ordered 
        список of alternatives в_ look for a файл. This supports the notion of 
        файл 'overrопрes', whereby "customized" файлы can be inserted преобр_в a 
        chain of alternatives.

        (overrопрden папки are not currently supported)

*******************************************************************************/


class LinkedFolder : ВиртуальнаяПапка
{
        private Link* голова;

        /***********************************************************************

                Linked-список of папки

        ***********************************************************************/

        private struct Link
        {
                Link*     следщ;
                ПапкаВфс папка;

                static Link* opCall(ПапкаВфс папка)
                {
                        auto p = new Link;
                        p.папка = папка;
                        return p;
                }
        }

        /***********************************************************************

                все папка must have a имя. No '.' or '/' симвы are 
                permitted

        ***********************************************************************/

        this (ткст имя)
        {
                super (имя);
        }

        /***********************************************************************

                Добавь a ветвь папка. The ветвь cannot 'overlap' with другие
                in the дерево of the same тип. Circular references across a
                дерево of virtual папки are detected и trapped.

                We добавь the new ветвь at the конец of an ordered список, which
                we subsequently traverse when looking up a файл

                The секунда аргумент represents an optional имя that the
                прикрепи should be known as, instead of the имя exposed by 
                the provопрed папка (it is not an alias).

        ***********************************************************************/

        final ХостВфс прикрепи (ПапкаВфс папка, ткст имя=пусто)
        {
                // traverse в_ the конец of the список
                auto link = &голова;
                while (*link)
                        link = &(*link).следщ;

                // hook up the new папка
                *link = Link (папка);

                // и let superclass deal with it 
                return super.прикрепи (папка, имя);
        }

        /***********************************************************************

                TODO: unhook a ветвь папка.

        ***********************************************************************/

        final ХостВфс открепи (ПапкаВфс папка)
        {
                assert (0, "LinkedFolder.открепи не реализован");
        }

        /***********************************************************************

                Return a файл representation of the given путь. If the
                путь-голова does not refer в_ an immediate ветвь папка, 
                и does not сверь a symbolic link, it is consопрered в_
                be неизвестное.

                We скан the установи of mounted папки, in the order mounted,
                looking for a сверь. Where one is найдено, we тест в_ see
                that it really есть_ли before returning the reference

        ***********************************************************************/

        final override ФайлВфс файл (ткст путь)
        {
                auto link = голова;
                while (link)
                      {
                      //Стдвыв.форматнс ("looking in {}", link.папка.вТкст);
                      try {
                          auto файл = link.папка.файл (путь);
                          if (файл.есть_ли)
                              return файл;
                          } catch (ВфсИскл x) {}
                      link = link.следщ;
                      }
                super.ошибка ("файл '"~путь~"' не найден");
                return пусто;
        }
}


debug (LinkedFolder)
{
/*******************************************************************************

*******************************************************************************/

import io.Stdout;
import io.vfs.FileFolder;

проц main()
{
        auto корень = new LinkedFolder ("корень");
        auto подст  = new ВиртуальнаяПапка ("подст");
        подст.прикрепи (new ФайлПапка (r"d:/d/import/temp"));
        подст.карта (подст.файл(r"temp/subtree/тест.txt"), "wumpus");
        
        корень.прикрепи (new ФайлПапка (r"d:/d/import/DinrusTango.lib"))
            .прикрепи (new ФайлПапка (r"c:/"), "windows");
        корень.прикрепи (подст);

        auto файл = корень.файл (r"wumpus");
        Стдвыв.форматнс ("файл = {}", файл);
}
}
