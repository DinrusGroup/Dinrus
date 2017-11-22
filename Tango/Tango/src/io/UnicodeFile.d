/*******************************************************************************

        copyright:      Copyright (c) 2005 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: December 2005      
        
        author:         Kris

*******************************************************************************/

module io.UnicodeFile;

private import io.device.File;

public  import text.convert.UnicodeBom;

/*******************************************************************************

        Чтен and пиши unicode файлы

        For our purposes, unicode файлы are an кодировка of textual material.
        The goal of this module is в_ interface that external-кодировка with
        a programmer-defined internal-кодировка. This internal кодировка is
        declared via the template аргумент T, whilst the external кодировка
        is either specified or производный.

        Three internal encodings are supported: сим, шим, and дим. The
        methods herein operate upon массивы of this тип. For example, читай()
        returns an Массив of the тип, whilst пиши() and добавь() expect an
        Массив of saопр тип.

        Supported external encodings are as follow:

                $(UL Кодировка.Unknown)
                $(UL Кодировка.UTF_8)
                $(UL Кодировка.UTF_8N)
                $(UL Кодировка.UTF_16)
                $(UL Кодировка.UTF_16BE)
                $(UL Кодировка.UTF_16LE) 
                $(UL Кодировка.UTF_32)
                $(UL Кодировка.UTF_32BE)
                $(UL Кодировка.UTF_32LE) 

        These can be divопрed преобр_в implicit and explicit encodings. Here are
        the implicit поднабор:

                $(UL Кодировка.Unknown)
                $(UL Кодировка.UTF_8)
                $(UL Кодировка.UTF_16)
                $(UL Кодировка.UTF_32) 

        Implicit encodings may be used в_ 'discover'
        an неизвестное кодировка, by examining the first few байты of the файл
        контент for a сигнатура. This сигнатура is optional for все файлы, 
        but is often записано such that the контент is сам-describing. When
        the кодировка is неизвестное, using one of the non-explicit encodings will
        cause the читай() метод в_ look for a сигнатура and исправь itself 
        accordingly. It is possible that a ZWNBSP character might be confused 
        with the сигнатура; today's файлы are supposed в_ use the WORD-JOINER 
        character instead.

        Explicit encodings are as follows:
       
                $(UL Кодировка.UTF_8N)
                $(UL Кодировка.UTF_16BE)
                $(UL Кодировка.UTF_16LE) 
                $(UL Кодировка.UTF_32BE)
                $(UL Кодировка.UTF_32LE) 
        
        This группа of encodings are for use when the файл кодировка is
        known. These *must* be used when writing or appending, since записано
        контент must be in a known форматируй. It should be noted that, during a
        читай operation, the presence of a сигнатура is in conflict with these 
        explicit varieties.

        Метод читай() returns the current контент of the файл, whilst пиши()
        sets the файл контент, and файл length, в_ the provопрed Массив. Метод
        добавь() добавьs контент в_ the хвост of the файл. When appending, it is
        your responsibility в_ ensure the existing and current encodings are
        correctly matched.

        Methods в_ inspect the файл system, check the статус of a файл or
        дир, and другой facilities are made available via the ФПуть
        superclass.

        See these линки for ещё инфо:
        $(UL $(LINK http://www.utf-8.com/))
        $(UL $(LINK http://www.hackcraft.net/xmlUnicode/))
        $(UL $(LINK http://www.unicode.org/faq/utf_bom.html/))
        $(UL $(LINK http://www.azillionmonkeys.com/qed/unicode.html/))
        $(UL $(LINK http://icu.sourceforge.net/docs/papers/forms_of_unicode/))

*******************************************************************************/

class ФайлЮ(T)
{
        private ЮникодМПБ!(T)  bom_;
        private ткст          path_;

        /***********************************************************************
        
                Construct a ФайлЮ из_ the provопрed ФПуть. The given 
                кодировка represents the external файл кодировка, and should
                be one of the Кодировка.xx типы 

        ***********************************************************************/
                                  
        this (ткст путь, Кодировка кодировка)
        {
                bom_ = new ЮникодМПБ!(T)(кодировка);
                path_ = путь;
        }

        /***********************************************************************

                Вызов-site shortcut в_ создай a ФайлЮ экземпляр. This 
                enables the same syntax as struct usage, so may expose
                a migration путь

        ***********************************************************************/

        static ФайлЮ opCall (ткст имя, Кодировка кодировка)
        {
                return new ФайлЮ (имя, кодировка);
        }

        /***********************************************************************

                Return the associated файл путь

        ***********************************************************************/

        ткст вТкст ()
        {
                return path_;
        }
        
        /***********************************************************************

                Return the current кодировка. This is either the originally
                specified кодировка, or a производный one obtained by inspecting
                the файл контент for a мпб. The latter is performed as часть
                of the читай() метод.

        ***********************************************************************/

        Кодировка кодировка ()
        {
                return bom_.кодировка;
        }
        
        /***********************************************************************

                Return the associated мпб экземпляр. Use this в_ найди ещё
                information about the кодировка статус

        ***********************************************************************/

        ЮникодМПБ!(T) мпб ()
        {
                return bom_;
        }

        /***********************************************************************

                Return the контент of the файл. The контент is inspected 
                for a мпб сигнатура, which is очищенный. An исключение is
                thrown if a сигнатура is present when, according в_ the
                кодировка тип, it should not be. Conversely, An исключение
                is thrown if there is no known сигнатура where the current
                кодировка expects one в_ be present.

        ***********************************************************************/

        final T[] читай ()
        {
                auto контент = Файл.получи (path_);
                return bom_.раскодируй (контент);
        }

        /***********************************************************************

                Набор the файл контент and length в_ reflect the given Массив.
                The контент will be кодирован accordingly.

        ***********************************************************************/

        final проц пиши (T[] контент, бул писатьМПБ)
        {       
                // преобразуй в_ external representation (may throw an exeption)
                проц[] преобразованый = bom_.кодируй (контент);

                // открой файл after conversion ~ in case of exceptions
                scope провод = new Файл (path_, Файл.ЧитЗапСозд);  
                scope (exit)
                       провод.закрой;

                if (писатьМПБ)
                    провод.пиши (bom_.сигнатура);

                // and пиши
                провод.пиши (преобразованый);
        }

        /***********************************************************************

                Append контент в_ the файл; the контент will be кодирован 
                accordingly.

                Note that it is your responsibility в_ ensure the 
                existing and current encodings are correctly matched.

        ***********************************************************************/

        final проц добавь (T[] контент)
        {
                // преобразуй в_ external representation (may throw an исключение)
                Файл.добавь (path_, bom_.кодируй (контент));
        }
}


/*******************************************************************************

*******************************************************************************/

debug (FileU)
{
        import io.Stdout;

        проц main()
        {       
                auto файл = ФайлЮ!(сим)("UnicodeFile.d", Кодировка.UTF_8);
                auto контент = файл.читай;
                Стдвыв (контент).нс;
        }
}
