﻿/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Feb 2007: Initial release

        author:         Kris

        This is the Dinrus I18N gateway, which extends the basic Выкладка
        module with support for cuture- and region-specific formatting
        of numerics, дата, время, and currency.

        Use as a standalone форматёр in the same manner as Выкладка, or
        combine with другой entities such as Стдвыв. To enable a French
        Стдвыв, do the following:
        ---
        Стдвыв.выкладка = new Locale (Культура.дайКультуру ("fr-FR"));
        ---
        
        Note that Стдвыв is a shared сущность, so every usage of it will
        be affected by the above example. For applications supporting 
        multИПle regions создай multИПle Locale instances instead, and 
        cache them in an appropriate manner.

        In добавьition в_ region-specific currency, дата and время, Locale
        добавьs ещё sophisticated formatting опция than Выкладка provопрes: 
        numeric цифра placement using '#' formatting, for example, is 
        supported by Locale - along with placement of '$', '-', and '.'
        regional-specifics.

        Locale is currently utf8 only. Support for Всё Utf16 and utf32 
        may be включен at a later время

******************************************************************************/

module text.locale.Locale;

private import text.locale.Core,
               text.locale.Convert;

private import time.Time;

private import text.convert.Layout;

public  import text.locale.Core : Культура;

/*******************************************************************************

        Locale-включен wrapper around text.convert.Layout

*******************************************************************************/

public class Locale : Выкладка!(сим)
{
        private ФорматДатыВремени  dateFormat;
        private ФорматЧисла    форматЧисла;

        /**********************************************************************

        **********************************************************************/

        this (ИСлужбаФормата службаФормата = пусто)
        {
                форматЧисла = ФорматЧисла.дайЭкземпляр (службаФормата);
                dateFormat = ФорматДатыВремени.дайЭкземпляр (службаФормата);
        }

        /***********************************************************************

        ***********************************************************************/

        protected override ткст неизвестное (ткст вывод, ткст форматируй, ИнфОТипе тип, Арг p)
        {
                switch (тип.classinfo.имя[9])
                       {
                            // Special case for Время.
                       case КодТипа.STRUCT:
                            if (тип is typeid(Время))
                                return форматируйДатуВремя (вывод, *cast(Время*) p, форматируй, dateFormat);

                       return тип.вТкст;

                       default:
                            break;
                       }

                return "{необрабатываемый тип аргумента: " ~ тип.вТкст ~ '}';
        }

        /**********************************************************************

        **********************************************************************/

        protected override ткст целое (ткст вывод, дол v, ткст alt, бдол маска=бдол.max, ткст форматируй=пусто)
        {
                return форматируйЦелое (вывод, v, alt, форматЧисла);
        }

        /**********************************************************************

        **********************************************************************/

        protected override ткст плавающее (ткст вывод, реал v, ткст форматируй)
        {
                return форматируйДво (вывод, v, форматируй, форматЧисла);
        }
}


/*******************************************************************************

*******************************************************************************/

debug (Locale)
{
        import io.Console;
        import time.WallClock;

        проц main ()
        {
                auto выкладка = new Locale (Культура.дайКультуру ("fr-FR"));

                Квывод (выкладка ("{:D}", Куранты.сейчас)) ();
        }
}
