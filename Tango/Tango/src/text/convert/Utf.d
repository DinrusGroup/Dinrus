/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: Oct 2004

        authors:        Kris

        Быстрый Unicode transcoders. These are particularly sensitive в_
        minor changes on 32bit x86 devices, because the регистрируй установи of
        those devices is so small. Beware of subtle changes which might
        extend the execution-период by as much as 200%. Because of this,
        three of the six transcoders might читай past the конец of ввод by
        one, two, or three байты before arresting themselves. Note that
        support for Потокing добавьs a 15% overhead в_ the дим => сим
        conversion, but имеется little effect on the другие.

        These routines were tuned on an Intel P4; другой devices may work
        ещё efficiently with a slightly different approach, though this
        is likely в_ be reasonably optimal on AMD x86 CPUs also. These
        algorithms would benefit significantly из_ those extra AMD64
        registers. On a 3GHz P4, the дим/сим conversions возьми around
        2500ns в_ process an Массив of 1000 ASCII элементы. Invoking the
        память manager doubles that период, и quadruples the время for
        массивы of 100 элементы. Memory allocation can slow down notably
        in a multi-threaded environment, so avoопр that where possible.

        Surrogate-pairs are dealt with in a non-optimal fashion when
        transcoding between utf16 и utf8. Such cases are consопрered
        в_ be boundary-conditions for this module.

        There are three common cases where the ввод may be incomplete,
        включая each 'wопрening' case of utf8 => utf16, utf8 => utf32,
        и utf16 => utf32. An edge-case is utf16 => utf8, if surrogate
        pairs are present. Such cases will throw an исключение, unless
        Потокing-режим is включен ~ in the latter режим, an добавьitional
        целое is returned indicating как many элементы of the ввод
        have been consumed. In все cases, a correct срез of the вывод
        is returned.

        For details on Unicode processing see:
        $(UL $(LINK http://www.utf-8.com/))
        $(UL $(LINK http://www.hackcraft.net/xmlUnicode/))
        $(UL $(LINK http://www.azillionmonkeys.com/qed/unicode.html/))
        $(UL $(LINK http://icu.sourceforge.net/docs/papers/forms_of_unicode/))

*******************************************************************************/

module text.convert.Utf;

public extern (C) проц onUnicodeError (ткст сооб, т_мера индкс = 0);

/*******************************************************************************

        Symmetric calls for equivalent типы; these return the provопрed
        ввод with no conversion

*******************************************************************************/

ткст  вТкст (ткст ист, ткст приёмн, бцел* ate=пусто) {return ист;}
шим[] вТкст (шим[] ист, шим[] приёмн, бцел* ate=пусто) {return ист;}
дим[] вТкст (дим[] ист, дим[] приёмн, бцел* ate=пусто) {return ист;}

/*******************************************************************************

        Encode Utf8 up в_ a maximum of 4 байты дол (five & six байт
        variations are not supported).

        If the вывод is provопрed off the стэк, it should be large
        enough в_ encompass the entire transcoding; failing в_ do
        so will cause the вывод в_ be moved onto the куча instead.

        Returns a срез of the вывод буфер, corresponding в_ the
        преобразованый characters. For optimum performance, the returned
        буфер should be specified as 'вывод' on subsequent calls.
        For example:

        ---
        ткст вывод;

        ткст результат = вТкст (ввод, вывод);

        // сбрось вывод after a realloc
        if (результат.length > вывод.length)
            вывод = результат;
        ---

        Where 'ate' is provопрed, it will be установи в_ the число of 
        элементы consumed из_ the ввод, и the вывод буфер 
        will not be resized (or allocated). This represents a
        Потокing режим, where slices of the ввод are processed
        in sequence rather than все at one время (should use 'ate'
        as an индекс for slicing преобр_в unconsumed ввод).

*******************************************************************************/

ткст вТкст (шим[] ввод, ткст вывод=пусто, бцел* ate=пусто)
{
        if (ate)
            *ate = ввод.length;
        else
           {
           // potentially reallocate вывод
           цел estimate = ввод.length * 2 + 3;
           if (вывод.length < estimate)
               вывод.length = estimate;
           }

        сим* pOut = вывод.ptr;
        сим* pMax = pOut + вывод.length - 3;

        foreach (цел eaten, шим b; ввод)
                {
                // about в_ перебор the вывод?
                if (pOut > pMax)
                   {
                   // if Потокing, just return the неиспользовано ввод
                   if (ate)
                      {
                      *ate = eaten;
                      break;
                      }

                   // reallocate the вывод буфер
                   цел длин = pOut - вывод.ptr;
                   вывод.length = длин + длин / 2;
                   pOut = вывод.ptr + длин;
                   pMax = вывод.ptr + вывод.length - 3;
                   }

                if (b < 0x80)
                    *pOut++ = b;
                else
                   if (b < 0x0800)
                      {
                      pOut[0] = cast(шим)(0xc0 | ((b >> 6) & 0x3f));
                      pOut[1] = cast(шим)(0x80 | (b & 0x3f));
                      pOut += 2;
                      }
                   else
                      if (b < 0xd800 || b > 0xdfff)
                         {
                         pOut[0] = cast(шим)(0xe0 | ((b >> 12) & 0x3f));
                         pOut[1] = cast(шим)(0x80 | ((b >> 6)  & 0x3f));
                         pOut[2] = cast(шим)(0x80 | (b & 0x3f));
                         pOut += 3;
                         }
                      else
                         // deal with surrogate-pairs
                         return вТкст (вТкст32(ввод, пусто, ate), вывод);
                }

        // return the produced вывод
        return вывод [0..(pOut - вывод.ptr)];
}

/*******************************************************************************

        Decode Utf8 produced by the above вТкст() метод.

        If the вывод is provопрed off the стэк, it should be large
        enough в_ encompass the entire transcoding; failing в_ do
        so will cause the вывод в_ be moved onto the куча instead.

        Returns a срез of the вывод буфер, corresponding в_ the
        преобразованый characters. For optimum performance, the returned
        буфер should be specified as 'вывод' on subsequent calls.

        Where 'ate' is provопрed, it will be установи в_ the число of 
        элементы consumed из_ the ввод, и the вывод буфер 
        will not be resized (or allocated). This represents a
        Потокing режим, where slices of the ввод are processed
        in sequence rather than все at one время (should use 'ate'
        as an индекс for slicing преобр_в unconsumed ввод).

*******************************************************************************/

шим[] вТкст16 (ткст ввод, шим[] вывод=пусто, бцел* ate=пусто)
{
        цел     produced;
        сим*   pIn = ввод.ptr;
        сим*   pMax = pIn + ввод.length;
        сим*   pValid;

        if (ate is пусто)
            if (ввод.length > вывод.length)
                вывод.length = ввод.length;

        if (ввод.length)
        foreach (ref шим d; вывод)
                {
                pValid = pIn;
                шим b = cast(шим) *pIn;

                if (b & 0x80)
                    if (b < 0xe0)
                       {
                       b &= 0x1f;
                       b = cast(шим)((b << 6) | (*++pIn & 0x3f));
                       }
                    else
                       if (b < 0xf0)
                          {
                          b &= 0x0f;
                          b = cast(шим)((b << 6) | (pIn[1] & 0x3f));
                          b = cast(шим)((b << 6) | (pIn[2] & 0x3f));
                          pIn += 2;
                          }
                       else
                          // deal with surrogate-pairs
                          return вТкст16 (вТкст32(ввод, пусто, ate), вывод);

                d = b;
                ++produced;

                // dопр we читай past the конец of the ввод?
                if (++pIn >= pMax)
                    if (pIn > pMax)
                       {
                       // yep ~ return хвост or throw ошибка?
                       if (ate)
                          {
                          pIn = pValid;
                          --produced;
                          break;
                          }
                       onUnicodeError ("Unicode.вТкст16 : utf8 ввод неполон", pIn - ввод.ptr);
                       }
                    else
                       break;
                }

        // do we still have some ввод left?
        if (ate)
            *ate = pIn - ввод.ptr;
        else
           if (pIn < pMax)
               // this should never happen!
               onUnicodeError ("Unicode.вТкст16 : utf8 перебор", pIn - ввод.ptr);

        // return the produced вывод
        return вывод [0..produced];
}


/*******************************************************************************

        Encode Utf8 up в_ a maximum of 4 байты дол (five & six
        байт variations are not supported). Throws an исключение
        where the ввод дим is greater than 0x10ffff.

        If the вывод is provопрed off the стэк, it should be large
        enough в_ encompass the entire transcoding; failing в_ do
        so will cause the вывод в_ be moved onto the куча instead.

        Returns a срез of the вывод буфер, corresponding в_ the
        преобразованый characters. For optimum performance, the returned
        буфер should be specified as 'вывод' on subsequent calls.

        Where 'ate' is provопрed, it will be установи в_ the число of 
        элементы consumed из_ the ввод, и the вывод буфер 
        will not be resized (or allocated). This represents a
        Потокing режим, where slices of the ввод are processed
        in sequence rather than все at one время (should use 'ate'
        as an индекс for slicing преобр_в unconsumed ввод).

*******************************************************************************/

ткст вТкст (дим[] ввод, ткст вывод=пусто, бцел* ate=пусто)
{
        if (ate)
            *ate = ввод.length;
        else
           {
           // potentially reallocate вывод
           цел estimate = ввод.length * 2 + 4;
           if (вывод.length < estimate)
               вывод.length = estimate;
           }

        сим* pOut = вывод.ptr;
        сим* pMax = pOut + вывод.length - 4;

        foreach (цел eaten, дим b; ввод)
                {
                // about в_ перебор the вывод?
                if (pOut > pMax)
                   {
                   // if Потокing, just return the неиспользовано ввод
                   if (ate)
                      {
                      *ate = eaten;
                      break;
                      }

                   // reallocate the вывод буфер
                   цел длин = pOut - вывод.ptr;
                   вывод.length = длин + длин / 2;
                   pOut = вывод.ptr + длин;
                   pMax = вывод.ptr + вывод.length - 4;
                   }

                if (b < 0x80)
                    *pOut++ = b;
                else
                   if (b < 0x0800)
                      {
                      pOut[0] = cast(шим)(0xc0 | ((b >> 6) & 0x3f));
                      pOut[1] = cast(шим)(0x80 | (b & 0x3f));
                      pOut += 2;
                      }
                   else
                      if (b < 0x10000)
                         {
                         pOut[0] = cast(шим)(0xe0 | ((b >> 12) & 0x3f));
                         pOut[1] = cast(шим)(0x80 | ((b >> 6)  & 0x3f));
                         pOut[2] = cast(шим)(0x80 | (b & 0x3f));
                         pOut += 3;
                         }
                      else
                         if (b < 0x110000)
                            {
                            pOut[0] = cast(шим)(0xf0 | ((b >> 18) & 0x3f));
                            pOut[1] = cast(шим)(0x80 | ((b >> 12) & 0x3f));
                            pOut[2] = cast(шим)(0x80 | ((b >> 6)  & 0x3f));
                            pOut[3] = cast(шим)(0x80 | (b & 0x3f));
                            pOut += 4;
                            }
                         else
                            onUnicodeError ("Unicode.вТкст : неправильный дим", eaten);
                }

        // return the produced вывод
        return вывод [0..(pOut - вывод.ptr)];
}


/*******************************************************************************

        Decode Utf8 produced by the above вТкст() метод.

        If the вывод is provопрed off the стэк, it should be large
        enough в_ encompass the entire transcoding; failing в_ do
        so will cause the вывод в_ be moved onto the куча instead.

        Returns a срез of the вывод буфер, corresponding в_ the
        преобразованый characters. For optimum performance, the returned
        буфер should be specified as 'вывод' on subsequent calls.

        Where 'ate' is provопрed, it will be установи в_ the число of 
        элементы consumed из_ the ввод, и the вывод буфер 
        will not be resized (or allocated). This represents a
        Потокing режим, where slices of the ввод are processed
        in sequence rather than все at one время (should use 'ate'
        as an индекс for slicing преобр_в unconsumed ввод).

*******************************************************************************/

дим[] вТкст32 (ткст ввод, дим[] вывод=пусто, бцел* ate=пусто)
{
        цел     produced;
        сим*   pIn = ввод.ptr;
        сим*   pMax = pIn + ввод.length;
        сим*   pValid;

        if (ate is пусто)
            if (ввод.length > вывод.length)
                вывод.length = ввод.length;

        if (ввод.length)
        foreach (ref дим d; вывод)
                {
                pValid = pIn;
                дим b = cast(дим) *pIn;

                if (b & 0x80)
                    if (b < 0xe0)
                       {
                       b &= 0x1f;
                       b = (b << 6) | (*++pIn & 0x3f);
                       }
                    else
                       if (b < 0xf0)
                          {
                          b &= 0x0f;
                          b = (b << 6) | (pIn[1] & 0x3f);
                          b = (b << 6) | (pIn[2] & 0x3f);
                          pIn += 2;
                          }
                       else
                          {
                          b &= 0x07;
                          b = (b << 6) | (pIn[1] & 0x3f);
                          b = (b << 6) | (pIn[2] & 0x3f);
                          b = (b << 6) | (pIn[3] & 0x3f);

                          if (b >= 0x110000)
                              onUnicodeError ("Unicode.вТкст32 : utf8 ввод ошибочен", pIn - ввод.ptr);
                          pIn += 3;
                          }

                d = b;
                ++produced;

                // dопр we читай past the конец of the ввод?
                if (++pIn >= pMax)
                    if (pIn > pMax)
                       {
                       // yep ~ return хвост or throw ошибка?
                       if (ate)
                          {
                          pIn = pValid;
                          --produced;
                          break;
                          }
                       onUnicodeError ("Unicode.вТкст32 : utf8 ввод неполон", pIn - ввод.ptr);
                       }
                    else
                       break;
                }

        // do we still have some ввод left?
        if (ate)
            *ate = pIn - ввод.ptr;
        else
           if (pIn < pMax)
               // this should never happen!
               onUnicodeError ("Unicode.вТкст32 : utf8 перебор", pIn - ввод.ptr);

        // return the produced вывод
        return вывод [0..produced];
}

/*******************************************************************************

        Encode Utf16 up в_ a maximum of 2 байты дол. Throws an исключение
        where the ввод дим is greater than 0x10ffff.

        If the вывод is provопрed off the стэк, it should be large
        enough в_ encompass the entire transcoding; failing в_ do
        so will cause the вывод в_ be moved onto the куча instead.

        Returns a срез of the вывод буфер, corresponding в_ the
        преобразованый characters. For optimum performance, the returned
        буфер should be specified as 'вывод' on subsequent calls.

        Where 'ate' is provопрed, it will be установи в_ the число of 
        элементы consumed из_ the ввод, и the вывод буфер 
        will not be resized (or allocated). This represents a
        Потокing режим, where slices of the ввод are processed
        in sequence rather than все at one время (should use 'ate'
        as an индекс for slicing преобр_в unconsumed ввод).

*******************************************************************************/

шим[] вТкст16 (дим[] ввод, шим[] вывод=пусто, бцел* ate=пусто)
{
        if (ate)
            *ate = ввод.length;
        else
           {
           цел estimate = ввод.length * 2 + 2;
           if (вывод.length < estimate)
               вывод.length = estimate;
           }

        шим* pOut = вывод.ptr;
        шим* pMax = pOut + вывод.length - 2;

        foreach (цел eaten, дим b; ввод)
                {
                // about в_ перебор the вывод?
                if (pOut > pMax)
                   {
                   // if Потокing, just return the неиспользовано ввод
                   if (ate)
                      {
                      *ate = eaten;
                      break;
                      }

                   // reallocate the вывод буфер
                   цел длин = pOut - вывод.ptr;
                   вывод.length = длин + длин / 2;
                   pOut = вывод.ptr + длин;
                   pMax = вывод.ptr + вывод.length - 2;
                   }

                if (b < 0x10000)
                    *pOut++ = b;
                else
                   if (b < 0x110000)
                      {
                      pOut[0] = cast(шим)(0xd800 | (((b - 0x10000) >> 10) & 0x3ff));
                      pOut[1] = cast(шим)(0xdc00 | ((b - 0x10000) & 0x3ff));
                      pOut += 2;
                      }
                   else
                      onUnicodeError ("Unicode.вТкст16 : неправильный дим", eaten);
                }

        // return the produced вывод
        return вывод [0..(pOut - вывод.ptr)];
}

/*******************************************************************************

        Decode Utf16 produced by the above вТкст16() метод.

        If the вывод is provопрed off the стэк, it should be large
        enough в_ encompass the entire transcoding; failing в_ do
        so will cause the вывод в_ be moved onto the куча instead.

        Returns a срез of the вывод буфер, corresponding в_ the
        преобразованый characters. For optimum performance, the returned
        буфер should be specified as 'вывод' on subsequent calls.

        Where 'ate' is provопрed, it will be установи в_ the число of 
        элементы consumed из_ the ввод, и the вывод буфер 
        will not be resized (or allocated). This represents a
        Потокing режим, where slices of the ввод are processed
        in sequence rather than все at one время (should use 'ate'
        as an индекс for slicing преобр_в unconsumed ввод).

*******************************************************************************/

дим[] вТкст32 (шим[] ввод, дим[] вывод=пусто, бцел* ate=пусто)
{
        цел     produced;
        шим*  pIn = ввод.ptr;
        шим*  pMax = pIn + ввод.length;
        шим*  pValid;

        if (ate is пусто)
            if (ввод.length > вывод.length)
                вывод.length = ввод.length;

        if (ввод.length)
        foreach (ref дим d; вывод)
                {
                pValid = pIn;
                дим b = cast(дим) *pIn;

                // simple conversion ~ see http://www.unicode.org/faq/utf_bom.html#35
                if (b >= 0xd800 && b <= 0xdfff)
                    b = ((b - 0xd7c0) << 10) + (*++pIn - 0xdc00);

                if (b >= 0x110000)
                    onUnicodeError ("Unicode.вТкст32 :utf16 ввод неверен", pIn - ввод.ptr);

                d = b;
                ++produced;

                if (++pIn >= pMax)
                    if (pIn > pMax)
                       {
                       // yep ~ return хвост or throw ошибка?
                       if (ate)
                          {
                          pIn = pValid;
                          --produced;
                          break;
                          }
                       onUnicodeError ("Unicode.вТкст32 : utf16 ввод неполон", pIn - ввод.ptr);
                       }
                    else
                       break;
                }

        // do we still have some ввод left?
        if (ate)
            *ate = pIn - ввод.ptr;
        else
           if (pIn < pMax)
               // this should never happen!
               onUnicodeError ("Unicode.вТкст32 : utf16 перебор", pIn - ввод.ptr);

        // return the produced вывод
        return вывод [0..produced];
}


/*******************************************************************************

        Decodes a single дим из_ the given ист текст, и indicates как
        many симвы were consumed из_ ист в_ do so.

*******************************************************************************/

дим раскодируй (ткст ист, ref бцел ate)
{
        дим[1] возвр;
        return вТкст32 (ист, возвр, &ate)[0];
}

/*******************************************************************************

        Decodes a single дим из_ the given ист текст, и indicates как
        many wchars were consumed из_ ист в_ do so.

*******************************************************************************/

дим раскодируй (шим[] ист, ref бцел ate)
{
        дим[1] возвр;
        return вТкст32 (ист, возвр, &ate)[0];
}

/*******************************************************************************

        Encode a дим преобр_в the provопрed приёмн Массив, и return a срез of 
        it representing the кодировка

*******************************************************************************/

ткст кодируй (ткст приёмн, дим c)
{
        return вТкст ((&c)[0..1], приёмн);
}

/*******************************************************************************

        Encode a дим преобр_в the provопрed приёмн Массив, и return a срез of 
        it representing the кодировка

*******************************************************************************/

шим[] кодируй (шим[] приёмн, дим c)
{
        return вТкст16 ((&c)[0..1], приёмн);
}

/*******************************************************************************

        Is the given character действителен?

*******************************************************************************/

бул действителен (дим c)
{
        return (c < 0xD800 || (c > 0xDFFF && c <= 0x10FFFF));
}

/*******************************************************************************

        Convert из_ a ткст преобр_в the тип of the приёмн provопрed. 

        Returns a срез of the given приёмн, where it is sufficiently large
        в_ house the результат, or a куча-allocated Массив otherwise. Returns
        the original ввод where no conversion is требуется.

*******************************************************************************/

T[] изТкст8(T) (ткст s, T[] приёмн)
{
        static if (is (T == сим))
                   return s;

        static if (is (T == шим))
                   return .вТкст16 (s, приёмн);

        static if (is (T == дим))
                   return .вТкст32 (s, приёмн);
}

/*******************************************************************************

        Convert из_ a шим[] преобр_в the тип of the приёмн provопрed. 

        Returns a срез of the given приёмн, where it is sufficiently large
        в_ house the результат, or a куча-allocated Массив otherwise. Returns
        the original ввод where no conversion is требуется.

*******************************************************************************/

T[] изТкст16(T) (шим[] s, T[] приёмн)
{
        static if (is (T == шим))
                   return s;

        static if (is (T == сим))
                   return .вТкст (s, приёмн);

        static if (is (T == дим))
                   return .вТкст32 (s, приёмн);
}

/*******************************************************************************

        Convert из_ a дим[] преобр_в the тип of the приёмн provопрed. 

        Returns a срез of the given приёмн, where it is sufficiently large
        в_ house the результат, or a куча-allocated Массив otherwise. Returns
        the original ввод where no conversion is требуется.

*******************************************************************************/

T[] изТкст32(T) (дим[] s, T[] приёмн)
{
        static if (is (T == дим))
                   return s;

        static if (is (T == сим))
                   return .вТкст (s, приёмн);

        static if (is (T == шим))
                   return .вТкст16 (s, приёмн);
}

/*******************************************************************************

        Adjust the контент such that no partial encodings exist on the 
        left sопрe of the provопрed текст.

        Returns a срез of the ввод

*******************************************************************************/

T[] отрежьЛево(T) (T[] s)
{
        static if (is (T == сим))
                   for (цел i=0; i < s.length && (s[i] & 0x80); ++i)
                        if ((s[i] & 0xc0) is 0xc0)
                             return s [i..$];

        static if (is (T == шим))
                   // пропусти if первый сим is a trailing surrogate
                   if ((s[0] & 0xfffffc00) is 0xdc00)
                        return s [1..$];

        return s;
}

/*******************************************************************************

        Adjust the контент such that no partial encodings exist on the 
        right sопрe of the provопрed текст.

        Returns a срез of the ввод

*******************************************************************************/

T[] отрежьПраво(T) (T[] s)
{
        if (s.length)
           {
           бцел i = s.length - 1;
           static if (is (T == сим))
                      while (i && (s[i] & 0x80))
                             if ((s[i] & 0xc0) is 0xc0)
                                {
                                // located the первый байт of a sequence
                                ббайт b = s[i];
                                цел d = s.length - i;

                                // is it a 3 байт sequence?
                                if (b & 0x20)
                                    --d;
   
                                // or a four байт sequence?
                                if (b & 0x10)
                                    --d;

                                // is the sequence complete?
                                if (d is 2)
                                    i = s.length;
                                return s [0..i];
                                }
                             else 
                                --i;

           static if (is (T == шим))
                      // пропусти if последний сим is a leading surrogate
                      if ((s[i] & 0xfffffc00) is 0xd800)
                           return s [0..$-1];
           }
        return s;
}



/*******************************************************************************

*******************************************************************************/

debug (Utf)
{
        import io.Console;

        проц main()
        {
                auto s = "[\xc2\xa2\xc2\xa2\xc2\xa2]";
                Квывод (s).нс;

                Квывод (отрежьЛево(s[0..$])).нс;
                Квывод (отрежьЛево(s[1..$])).нс;
                Квывод (отрежьЛево(s[2..$])).нс;
                Квывод (отрежьЛево(s[3..$])).нс;
                Квывод (отрежьЛево(s[4..$])).нс;
                Квывод (отрежьЛево(s[5..$])).нс;

                Квывод (отрежьПраво(s[0..$])).нс;
                Квывод (отрежьПраво(s[0..$-1])).нс;
                Квывод (отрежьПраво(s[0..$-2])).нс;
                Квывод (отрежьПраво(s[0..$-3])).нс;
                Квывод (отрежьПраво(s[0..$-4])).нс;
                Квывод (отрежьПраво(s[0..$-5])).нс;
        }
}
