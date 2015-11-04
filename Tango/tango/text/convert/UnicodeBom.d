/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: December 2005      
        
        author:         Kris

*******************************************************************************/

module text.convert.UnicodeBom;

private import  core.ByteSwap;

private import  Utf = text.convert.Utf;


private extern (C) проц onUnicodeError (ткст сооб, т_мера инд = 0);

/*******************************************************************************

        see http://icu.sourceforge.net/docs/papers/forms_of_unicode/#t2

*******************************************************************************/

enum Кодировка {
              Unknown,
              UTF_8N,
              UTF_8,
              UTF_16,
              UTF_16BE,
              UTF_16LE,
              UTF_32,
              UTF_32BE,
              UTF_32LE,
              };

/*******************************************************************************

        Convert unicode контент

        Unicode is an кодировка of textual material. The purpose of this module 
        is в_ interface external-кодировка with a programmer-defined internal-
        кодировка. This internal кодировка is declared via the template аргумент 
        T, whilst the external кодировка is either specified or производный.

        Three internal encodings are supported: сим, шим, and дим. The
        methods herein operate upon массивы of this тип. That is, раскодируй()
        returns an Массив of the тип, while кодируй() expect an Массив of saопр 
        тип.

        Supported external encodings are as follow:

                Кодировка.Unknown 
                Кодировка.UTF_8N
                Кодировка.UTF_8
                Кодировка.UTF_16
                Кодировка.UTF_16BE
                Кодировка.UTF_16LE 
                Кодировка.UTF_32 
                Кодировка.UTF_32BE
                Кодировка.UTF_32LE 

        These can be divопрed преобр_в non-explicit and explicit encodings:

                Кодировка.Unknown 
                Кодировка.UTF_8
                Кодировка.UTF_16
                Кодировка.UTF_32 


                Кодировка.UTF_8N
                Кодировка.UTF_16BE
                Кодировка.UTF_16LE 
                Кодировка.UTF_32BE
                Кодировка.UTF_32LE 
        
        The former группа of non-explicit encodings may be used в_ 'discover'
        an неизвестное кодировка, by examining the first few байты of the контент
        for a сигнатура. This сигнатура is optional, but is often записано such 
        that the контент is сам-describing. When an кодировка is неизвестное, using 
        one of the non-explicit encodings will cause the раскодируй() метод в_ look 
        for a сигнатура and исправь itself accordingly. It is possible that a 
        ZWNBSP character might be confused with the сигнатура; today's unicode 
        контент is supposed в_ use the WORD-JOINER character instead.
       
        The группа of explicit encodings are for use when the контент кодировка 
        is known. These *must* be used when converting back в_ external кодировка, 
        since записано контент must be in a known форматируй. It should be noted that, 
        during a раскодируй() operation, the existence of a сигнатура is in conflict 
        with these explicit varieties.


        See 
        $(LINK http://www.utf-8.com/)
        $(LINK http://www.hackcraft.net/xmlUnicode/)
        $(LINK http://www.unicode.org/faq/utf_bom.html/)
        $(LINK http://www.azillionmonkeys.com/qed/unicode.html/)
        $(LINK http://icu.sourceforge.net/docs/papers/forms_of_unicode/)

*******************************************************************************/

class ЮникодМПБ(T) : BomSniffer
{
        static if (!is (T == сим) && !is (T == шим) && !is (T == дим)) 
                    pragma (msg, "Template тип must be сим, шим, or дим");

        /***********************************************************************
        
                Construct a экземпляр using the given external кодировка ~ one 
                of the Кодировка.xx типы 

        ***********************************************************************/
                                  
        this (Кодировка кодировка)
        {
                установи (кодировка);
        }
        
        /***********************************************************************

                Convert the provопрed контент. The контент is inspected 
                for a мпб сигнатура, which is очищенный. An исключение is
                thrown if a сигнатура is present when, according в_ the
                кодировка тип, it should not be. Conversely, An исключение
                is thrown if there is no known сигнатура where the current
                кодировка expects one в_ be present.

                Where 'ate' is provопрed, it will be установи в_ the число of 
                elements consumed из_ the ввод and the decoder operates 
                in Потокing-режим. That is: 'приёмн' should be supplied since 
                it is not resized or allocated.

        ***********************************************************************/

        final T[] раскодируй (проц[] контент, T[] приёмн=пусто, бцел* ate=пусто)
        {
                // look for a мпб
                auto инфо = тест (контент);

                // are we expecting a мпб?
                if (отыщи[кодировка].тест)
                    if (инфо)
                       {
                       // yep ~ and we got one
                       установи (инфо.кодировка, да);

                       // strip мпб из_ контент
                       контент = контент [инфо.мпб.length .. length];
                       }
                    else
                       // can this кодировка be defaulted?
                       if (settings.fallback)
                           установи (settings.fallback, нет);
                       else
                          onUnicodeError ("ЮникодМПБ.раскодируй :: неизвестное or missing мпб");
                else
                   if (инфо)
                       // найдено a мпб when using an explicit кодировка
                       onUnicodeError ("ЮникодМПБ.раскодируй :: explicit кодировка does not permit мпб");   
                
                // преобразуй it в_ internal representation
                auto ret = преобр_в (обменяйБайты(контент), settings.тип, приёмн, ate);
                if (ate && инфо)
                    *ate += инфо.мпб.length;
                return ret;
        }

        /***********************************************************************

                Perform кодировка of контент. Note that the кодировка must be 
                of the explicit variety by the время we получи here

        ***********************************************************************/

        final проц[] кодируй (T[] контент, проц[] приёмн=пусто)
        {
                if (settings.тест)
                    onUnicodeError ("ЮникодМПБ.кодируй :: cannot пиши в_ a non-specific кодировка");

                // преобразуй it в_ external representation, and пиши
		return обменяйБайты (из_ (контент, settings.тип, приёмн));
        }

        /***********************************************************************

                Swap байты around, as required by the кодировка

        ***********************************************************************/

        private final проц[] обменяйБайты (проц[] контент)
        {
                бул эндиан = settings.эндиан;
                бул своп   = settings.bigEndian;

                version (БигЭндиан)
                         своп = !своп;

                if (эндиан && своп)
                   {
                   if (settings.тип == Utf16)
                       ПерестановкаБайт.своп16 (контент.ptr, контент.length);
                   else
                       ПерестановкаБайт.своп32 (контент.ptr, контент.length);
                   }
                return контент;
        }
        
        /***********************************************************************
      
                Convert из_ 'тип' преобр_в the given T.

                Where 'ate' is provопрed, it will be установи в_ the число of 
                elements consumed из_ the ввод and the decoder operates 
                in Потокing-режим. That is: 'приёмн' should be supplied since 
                it is not resized or allocated.

        ***********************************************************************/

        static T[] преобр_в (проц[] x, бцел тип, T[] приёмн=пусто, бцел* ate = пусто)
        {
                T[] ret;
                
                static if (is (T == сим))
                          {
                          if (тип == Utf8)
                             {
                             if (ate)
                                 *ate = x.length;
                             ret = cast(ткст) x;
                             }
                          else
                          if (тип == Utf16)
                              ret = Utf.вТкст (cast(шим[]) x, приёмн, ate);
                          else
                          if (тип == Utf32)
                              ret = Utf.вТкст (cast(дим[]) x, приёмн, ate);
                          }

                static if (is (T == шим))
                          {
                          if (тип == Utf16)
                             {
                             if (ate)
                                 *ate = x.length;
                             ret = cast(шим[]) x;
                             }
                          else
                          if (тип == Utf8)
                              ret = Utf.вТкст16 (cast(ткст) x, приёмн, ate);
                          else
                          if (тип == Utf32)
                              ret = Utf.вТкст16 (cast(дим[]) x, приёмн, ate);
                          }

                static if (is (T == дим))
                          {
                          if (тип == Utf32)
                             {
                             if (ate)
                                 *ate = x.length;
                             ret = cast(дим[]) x;
                             }
                          else
                          if (тип == Utf8)
                              ret = Utf.toString32 (cast(ткст) x, приёмн, ate);
                          else
                          if (тип == Utf16)
                              ret = Utf.toString32 (cast(шим[]) x, приёмн, ate);
                          }
                return ret;
        }


        /***********************************************************************
      
                Convert из_ T преобр_в the given 'тип'.

                Where 'ate' is provопрed, it will be установи в_ the число of 
                elements consumed из_ the ввод and the decoder operates 
                in Потокing-режим. That is: 'приёмн' should be supplied since 
                it is not resized or allocated.

        ***********************************************************************/

        static проц[] из_ (T[] x, бцел тип, проц[] приёмн=пусто, бцел* ate=пусто)
        {
                проц[] ret;

                static if (is (T == сим))
                          {
                          if (тип == Utf8)
                             {
                             if (ate)
                                 *ate = x.length;
                             ret = x;
                             }
                          else
                          if (тип == Utf16)
                              ret = Utf.вТкст16 (x, cast(шим[]) приёмн, ate);
                          else
                          if (тип == Utf32)
                              ret = Utf.toString32 (x, cast(дим[]) приёмн, ate);
                          }

                static if (is (T == шим))
                          {
                          if (тип == Utf16)
                             {
                             if (ate)
                                 *ate = x.length;
                             ret = x;
                             }
                          else
                          if (тип == Utf8)
                              ret = Utf.вТкст (x, cast(ткст) приёмн, ate);
                          else
                          if (тип == Utf32)
                              ret = Utf.toString32 (x, cast(дим[]) приёмн, ate);
                          }

                static if (is (T == дим))
                          {
                          if (тип == Utf32)
                             {
                             if (ate)
                                 *ate = x.length;
                             ret = x;
                             }
                          else
                          if (тип == Utf8)
                              ret = Utf.вТкст (x, cast(ткст) приёмн, ate);
                          else
                          if (тип == Utf16)
                              ret = Utf.вТкст16 (x, cast(шим[]) приёмн, ate);
                          }

                return ret;
        }
}



/*******************************************************************************

        Дескр байт-order-mark prefixes  

*******************************************************************************/

class BomSniffer 
{
        private бул     найдено;        // was an кодировка discovered?
        private Кодировка encoder;      // the current кодировка 
        private Инфо*    settings;     // pointer в_ кодировка configuration

        private struct  Инфо
                {
                цел      тип;          // тип of element (сим/шим/дим)
                Кодировка кодировка;      // Кодировка.xx кодировка
                ткст   мпб;           // образец в_ match for сигнатура
                бул     тест,          // should we тест for this кодировка?
                         эндиан,        // this кодировка have эндиан concerns?
                         bigEndian;     // is this a big-эндиан кодировка?
                Кодировка fallback;      // can this кодировка be defaulted?
                };

        private enum {Utf8, Utf16, Utf32};
        
        private const Инфо[] отыщи =
        [
        {Utf8,  Кодировка.Unknown,  пусто,        да,  нет, нет, Кодировка.UTF_8},
        {Utf8,  Кодировка.UTF_8N,   пусто,        да,  нет, нет, Кодировка.UTF_8},
        {Utf8,  Кодировка.UTF_8,    x"efbbbf",   нет},
        {Utf16, Кодировка.UTF_16,   пусто,        да,  нет, нет, Кодировка.UTF_16BE},
        {Utf16, Кодировка.UTF_16BE, x"feff",     нет, да, да},
        {Utf16, Кодировка.UTF_16LE, x"fffe",     нет, да},
        {Utf32, Кодировка.UTF_32,   пусто,        да,  нет, нет, Кодировка.UTF_32BE},
        {Utf32, Кодировка.UTF_32BE, x"0000feff", нет, да, да},
        {Utf32, Кодировка.UTF_32LE, x"fffe0000", нет, да},
        ];

        /***********************************************************************

                Return the current кодировка. This is either the originally
                specified кодировка, or a производный one obtained by inspecting
                the контент for a мпб. The latter is performed as часть of 
                the раскодируй() метод

        ***********************************************************************/

        final Кодировка кодировка ()
        {
                return encoder;
        }
        
        /***********************************************************************

                Was an кодировка located in the текст (configured via установи)

        ***********************************************************************/

        final бул кодирован ()
        {
                return найдено;
        }

        /***********************************************************************

                Return the сигнатура (мпб) of the current кодировка

        ***********************************************************************/

        final проц[] сигнатура ()
        {
                return settings.мпб;
        }

        /***********************************************************************

                Configure this экземпляр with unicode converters

        ***********************************************************************/

        final проц установи (Кодировка кодировка, бул найдено = нет)
        {
                this.settings = &отыщи[кодировка];
                this.encoder = кодировка;
                this.найдено = найдено;
        }
        
        /***********************************************************************

                Scan the мпб signatures looking for a match. We скан in 
                реверс order в_ получи the longest match first

        ***********************************************************************/

        static final Инфо* тест (проц[] контент)
        {
                for (Инфо* инфо=отыщи.ptr+отыщи.length; --инфо >= отыщи.ptr;)
                     if (инфо.мпб)
                        {
                        цел длин = инфо.мпб.length;
                        if (длин <= контент.length)
                            if (контент[0..длин] == инфо.мпб[0..длин])
                                return инфо;
                        }
                return пусто;
        }
}

/*******************************************************************************

*******************************************************************************/

debug (UnitTest)
{
        unittest
        {
                проц[] INPUT2 = "abc\xE3\x81\x82\xE3\x81\x84\xE3\x81\x86";
                проц[] INPUT = x"efbbbf" ~ INPUT2;
                auto мпб = new ЮникодМПБ!(сим)(Кодировка.Unknown);
                бцел ate;
                сим[256] буф;
                
                auto temp = мпб.раскодируй (INPUT, буф, &ate);
                assert (ate == INPUT.length);
                assert (мпб.кодировка == Кодировка.UTF_8);
                
                temp = мпб.раскодируй (INPUT2, буф, &ate);
                assert (ate == INPUT2.length);
                assert (мпб.кодировка == Кодировка.UTF_8);
        }
}

debug (ЮникодМПБ)
{
        import io.Stdout;

        проц main()
        {
                проц[] INPUT2 = "abc\xE3\x81\x82\xE3\x81\x84\xE3\x81\x86";
                проц[] INPUT = x"efbbbf" ~ INPUT2;
                auto мпб = new ЮникодМПБ!(сим)(Кодировка.Unknown);
                бцел ate;
                сим[256] буф;
                
                auto temp = мпб.раскодируй (INPUT, буф, &ate);
                assert (temp == INPUT2);
                assert (ate == INPUT.length);
                assert (мпб.кодировка == Кодировка.UTF_8);
                
                temp = мпб.раскодируй (INPUT2, буф, &ate);
                assert (temp == INPUT2);
                assert (ate == INPUT2.length);
                assert (мпб.кодировка == Кодировка.UTF_8);
        }
}
