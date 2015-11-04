/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
        
        version:        Initial release: Nov 2005
        
        author:         Kris

        A установи of functions for converting between ткст and целое 
        values. 

        Applying the D "import alias" mechanism в_ this module is highly
        recommended, in order в_ предел namespace pollution:
        ---
        import Целое = text.convert.Integer;

        auto i = Целое.разбор ("32767");
        ---
        
*******************************************************************************/

module text.convert.Integer;

private import exception;

/******************************************************************************

        Parse an целое значение из_ the provопрed 'digits' ткст. 

        The ткст is inspected for a sign and an optional radix 
        префикс. A radix may be provопрed as an аргумент instead, 
        whereupon it must match the префикс (where present). When
        radix is установи в_ zero, conversion will default в_ decimal.

        Throws: ИсклНелегальногоАргумента where the ввод текст is not parsable
        in its entirety.

        See_also: the low уровень functions разбор() and преобразуй()

******************************************************************************/

цел вЦел(T, U=бцел) (T[] digits, U radix=0)
{return вЦел!(T)(digits, radix);}

цел вЦел(T) (T[] digits, бцел radix=0)
{
        auto x = toLong (digits, radix);
        if (x > цел.max)
            throw new ИсклНелегальногоАргумента ("Целое.вЦел :: целое перебор");
        return cast(цел) x;
}

/******************************************************************************

        Parse an целое значение из_ the provопрed 'digits' ткст.

        The ткст is inspected for a sign and an optional radix
        префикс. A radix may be provопрed as an аргумент instead,
        whereupon it must match the префикс (where present). When
        radix is установи в_ zero, conversion will default в_ decimal.

        Throws: ИсклНелегальногоАргумента where the ввод текст is not parsable
        in its entirety.

        See_also: the low уровень functions разбор() and преобразуй()

******************************************************************************/

дол toLong(T, U=бцел) (T[] digits, U radix=0)
{return toLong!(T)(digits, radix);}

дол toLong(T) (T[] digits, бцел radix=0)
{
        бцел длин;

        auto x = разбор (digits, radix, &длин);
        if (длин < digits.length)
            throw new ИсклНелегальногоАргумента ("Целое.toLong :: не_годится literal");
        return x;
}

/******************************************************************************

        Wrapper в_ сделай life simpler. Returns a текст version
        of the provопрed значение.

        See форматируй() for details

******************************************************************************/

ткст вТкст (дол i, ткст фмт = пусто)
{
        сим[66] врем =void;
        return форматируй (врем, i, фмт).dup;
}
               
/******************************************************************************

        Wrapper в_ сделай life simpler. Returns a текст version
        of the provопрed значение.

        See форматируй() for details

******************************************************************************/

шим[] вТкст16 (дол i, шим[] фмт = пусто)
{
        шим[66] врем =void;
        return форматируй (врем, i, фмт).dup;
}
               
/******************************************************************************

        Wrapper в_ сделай life simpler. Returns a текст version
        of the provопрed значение.

        See форматируй() for details

******************************************************************************/

дим[] toString32 (дол i, дим[] фмт = пусто)
{
        дим[66] врем =void;
        return форматируй (врем, i, фмт).dup;
}
               
/*******************************************************************************

        Supports форматируй specifications via an Массив, where форматируй follows
        the notation given below:
        ---
        тип width префикс
        ---

        Тип is one of [d, g, u, b, x, o] or uppercase equivalent, and
        dictates the conversion radix or другой semantics.

        Wопрth is optional and indicates a minimum width for zero-паддинг,
        while the optional префикс is one of ['#', ' ', '+'] and indicates
        what variety of префикс should be placed in the вывод. e.g.
        ---
        "d"     => целое
        "u"     => unsigned
        "o"     => octal
        "b"     => binary
        "x"     => hexadecimal
        "X"     => hexadecimal uppercase

        "d+"    => целое псеп_в_начале with "+"
        "b#"    => binary псеп_в_начале with "0b"
        "x#"    => hexadecimal псеп_в_начале with "0x"
        "X#"    => hexadecimal псеп_в_начале with "0X"

        "d8"    => decimal псеп_в_конце в_ 8 places as required
        "b8"    => binary псеп_в_конце в_ 8 places as required
        "b8#"   => binary псеп_в_конце в_ 8 places and псеп_в_начале with "0b"
        ---

        Note that the specified width is исключительно of the префикс, though
        the width паддинг will be shrunk as necessary in order в_ ensure
        a requested префикс can be inserted преобр_в the provопрed вывод.

*******************************************************************************/

T[] форматируй(T, U=дол) (T[] приёмн, U i, T[] фмт = пусто)
{return форматируй!(T)(приёмн, cast(дол) i, фмт);}

T[] форматируй(T) (T[] приёмн, дол i, T[] фмт = пусто)
{
        сим    pre,
                тип;
        цел     width;

        раскодируй (фмт, тип, pre, width);
        return форматёр (приёмн, i, тип, pre, width);
} 

private проц раскодируй(T) (T[] фмт, ref сим тип, out сим pre, out цел width)
{
        if (фмт.length is 0)
            тип = 'd';
        else
           {
           тип = фмт[0];
           if (фмт.length > 1)
              {
              auto p = &фмт[1];
              for (цел j=1; j < фмт.length; ++j, ++p)
                   if (*p >= '0' && *p <= '9')
                       width = width * 10 + (*p - '0');
                   else
                      pre = *p;
              }
           }
} 


T[] форматёр(T, U=дол, X=сим, Y=сим) (T[] приёмн, U i, X тип, Y pre, цел width)
{return форматёр!(T)(приёмн, cast(дол) i, тип, pre, width);}


private struct ИнфоОФорматировщике(T)
{
		бцел    radix;
		T[]     префикс;
		T[]     numbers;
}

T[] форматёр(T) (T[] приёмн, дол i, сим тип, сим pre, цел width)
{
        const T[] lower = "0123456789abcdef";
        const T[] upper = "0123456789ABCDEF";
        
        alias ИнфоОФорматировщике!(T) Инфо;

        const   Инфо[] formats = 
                [
                {10, пусто, lower}, 
                {10, "-",  lower}, 
                {10, " ",  lower}, 
                {10, "+",  lower}, 
                { 2, "0b", lower}, 
                { 8, "0o", lower}, 
                {16, "0x", lower}, 
                {16, "0X", upper},
                ];

        ббайт индекс;
        цел   длин = приёмн.length;

        if (длин)
           {
           switch (тип)
                  {
                  case 'd':
                  case 'D':
                  case 'g':
                  case 'G':
                       if (i < 0)
                          {
                          индекс = 1;
                          i = -i;
                          }
                       else
                          if (pre is ' ')
                              индекс = 2;
                          else
                             if (pre is '+')
                                 индекс = 3;
                  case 'u':
                  case 'U':
                       pre = '#';
                       break;

                  case 'b':
                  case 'B':
                       индекс = 4;
                       break;

                  case 'o':
                  case 'O':
                       индекс = 5;
                       break;

                  case 'x':
                       индекс = 6;
                       break;

                  case 'X':
                       индекс = 7;
                       break;

                  default:
                        return cast(T[])"{неизвестное форматируй '"~cast(T)тип~"'}";
                  }

           auto инфо = &formats[индекс];
           auto numbers = инфо.numbers;
           auto radix = инфо.radix;

           // преобразуй число в_ текст
           auto p = приёмн.ptr + длин;
           if (бцел.max >= cast(бдол) i)
              {
              auto v = cast (бцел) i;
              do {
                 *--p = numbers [v % radix];
                 } while ((v /= radix) && --длин);
              }
           else
              {
              auto v = cast (бдол) i;
              do {
                 *--p = numbers [cast(бцел) (v % radix)];
                 } while ((v /= radix) && --длин);
              }
        
           auto префикс = (pre is '#') ? инфо.префикс : пусто;
           if (длин > префикс.length)
              {
              длин -= префикс.length + 1;

              // префикс число with zeros? 
              if (width)
                 {
                 width = приёмн.length - width - префикс.length;
                 while (длин > width && длин > 0)
                       {
                       *--p = '0';
                       --длин;
                       }
                 }
              // пиши optional префикс ткст ...
              приёмн [длин .. длин + префикс.length] = префикс;

              // return срез of provопрed вывод буфер
              return приёмн [длин .. $];                               
              }
           }
        
        return "{вывод width too small}";
} 


/******************************************************************************

        Parse an целое значение из_ the provопрed 'digits' ткст. 

        The ткст is inspected for a sign and an optional radix 
        префикс. A radix may be provопрed as an аргумент instead, 
        whereupon it must match the префикс (where present). When
        radix is установи в_ zero, conversion will default в_ decimal.

        A non-пусто 'ate' will return the число of characters used
        в_ construct the returned значение.

        Throws: Неук. The 'ate' param should be checked for valid ввод.

******************************************************************************/

дол разбор(T, U=бцел) (T[] digits, U radix=0, бцел* ate=пусто)
{return разбор!(T)(digits, radix, ate);}

дол разбор(T) (T[] digits, бцел radix=0, бцел* ate=пусто)
{
        бул sign;

        auto eaten = trim (digits, sign, radix);
        auto значение = преобразуй (digits[eaten..$], radix, ate);

        // check *ate > 0 в_ сделай sure we don't разбор "-" as 0.
        if (ate && *ate > 0)
            *ate += eaten;

        return cast(дол) (sign ? -значение : значение);
}

/******************************************************************************

        Convert the provопрed 'digits' преобр_в an целое значение,
        without checking for a sign or radix. The radix defaults
        в_ decimal (10).

        Returns the значение and updates 'ate' with the число of
        characters consumed.

        Throws: Неук. The 'ate' param should be checked for valid ввод.

******************************************************************************/

бдол преобразуй(T, U=бцел) (T[] digits, U radix=10, бцел* ate=пусто)
{return преобразуй!(T)(digits, radix, ate);}

бдол преобразуй(T) (T[] digits, бцел radix=10, бцел* ate=пусто)
{
        бцел  eaten;
        бдол значение;

        foreach (c; digits)
                {
                if (c >= '0' && c <= '9')
                   {}
                else
                   if (c >= 'a' && c <= 'z')
                       c -= 39;
                   else
                      if (c >= 'A' && c <= 'Z')
                          c -= 7;
                      else
                         break;

                if ((c -= '0') < radix)
                   {
                   значение = значение * radix + c;
                   ++eaten;
                   }
                else
                   break;
                }

        if (ate)
            *ate = eaten;

        return значение;
}


/******************************************************************************

        StrИП leading пробел, extract an optional +/- sign,
        and an optional radix префикс. If the radix значение matches
        an optional префикс, or the radix is zero, the префикс will
        be consumed and assigned. Where the radix is non zero and
        does not match an explicit префикс, the latter will remain 
        unconsumed. Otherwise, radix will default в_ 10.

        Returns the число of characters consumed.

******************************************************************************/

бцел trim(T, U=бцел) (T[] digits, ref бул sign, ref U radix)
{return trim!(T)(digits, sign, radix);}

бцел trim(T) (T[] digits, ref бул sign, ref бцел radix)
{
        T       c;
        T*      p = digits.ptr;
        цел     длин = digits.length;

        if (длин)
           {
           // strip off пробел and sign characters
           for (c = *p; длин; c = *++p, --длин)
                if (c is ' ' || c is '\t')
                   {}
                else
                   if (c is '-')
                       sign = да;
                   else
                      if (c is '+')
                          sign = нет;
                   else
                      break;

           // strip off a radix specifier also?
           auto r = radix;
           if (c is '0' && длин > 1)
               switch (*++p)
                      {
                      case 'x':
                      case 'X':
                           ++p;
                           r = 16;
                           break;
 
                      case 'b':
                      case 'B':
                           ++p;
                           r = 2;
                           break;
 
                      case 'o':
                      case 'O':
                           ++p;
                           r = 8;
                           break;
 
                      default: 
                            --p;
                           break;
                      } 

           // default the radix в_ 10
           if (r is 0)
               radix = 10;
           else
              // explicit radix must match (optional) префикс
              if (radix != r)
                  if (radix)
                      p -= 2;
                  else
                     radix = r;
           }

        // return число of characters eaten
        return (p - digits.ptr);
}


/******************************************************************************

        быстро & dirty текст-в_-unsigned цел converter. Use only when you
        know what the контент is, or use разбор() or преобразуй() instead.

        Return the разобрано бцел
        
******************************************************************************/

бцел atoi(T) (T[] s, цел radix = 10)
{
        бцел значение;

        foreach (c; s)
                 if (c >= '0' && c <= '9')
                     значение = значение * radix + (c - '0');
                 else
                    break;
        return значение;
}


/******************************************************************************

        быстро & dirty unsigned в_ текст converter, where the provопрed вывод
        must be large enough в_ house the результат (10 digits in the largest
        case). For mainПоток use, consопрer utilizing форматируй() instead.

        Returns a populated срез of the provопрed вывод
        
******************************************************************************/

T[] itoa(T, U=бцел) (T[] вывод, U значение, цел radix = 10)
{return itoa!(T)(вывод, значение, radix);}

T[] itoa(T) (T[] вывод, бцел значение, цел radix = 10)
{
        T* p = вывод.ptr + вывод.length;

        do {
           *--p = cast(T)(значение % radix + '0');
           } while (значение /= radix);
        return вывод[p-вывод.ptr .. $];
}


/******************************************************************************

        Consume a число из_ the ввод without converting it. Аргумент
        'fp' enables floating-point consumption. Supports hex ввод for
        numbers which are псеп_в_начале appropriately

        Since version 0.99.9

******************************************************************************/

T[] используй(T) (T[] ист, бул fp=нет)
{
        T       c;
        бул    sign;
        бцел    radix;

        // удали leading пространство, and sign
        auto e = ист.ptr + ист.length;
        auto p = ист.ptr + trim (ист, sign, radix);
        auto b = p;

        // bail out if the ткст is пустой
        if (ист.length is 0 || p > &ист[$-1])
            return пусто;

        // читай leading digits
        for (c=*p; p < e && ((c >= '0' && c <= '9') || 
            (radix is 16 && ((c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F'))));)
             c = *++p;

        if (fp)
           {
           // gobble up a point
           if (c is '.' && p < e)
               c = *++p;

           // читай fractional digits
           while (c >= '0' && c <= '9' && p < e)
                  c = *++p;

           // dопр we используй anything?
           if (p > b)
              {
              // используй exponent?
              if ((c is 'e' || c is 'E') && p < e )
                 {
                 c = *++p;
                 if (c is '+' || c is '-')
                     c = *++p;
                 while (c >= '0' && c <= '9' && p < e)
                        c = *++p;
                 }
              }
           }
        return ист [0 .. p-ист.ptr];
}


/******************************************************************************

******************************************************************************/

debug (UnitTest)
{
        unittest
        {
        сим[64] врем;
        
        assert (вЦел("1") is 1);
        assert (toLong("1") is 1);
        assert (вЦел("1", 10) is 1);
        assert (toLong("1", 10) is 1);

        assert (atoi ("12345") is 12345);
        assert (itoa (врем, 12345) == "12345");

        assert(разбор( "0"w ) ==  0 );
        assert(разбор( "1"w ) ==  1 );
        assert(разбор( "-1"w ) ==  -1 );
        assert(разбор( "+1"w ) ==  1 );

        // numerical limits
        assert(разбор( "-2147483648" ) == цел.min );
        assert(разбор(  "2147483647" ) == цел.max );
        assert(разбор(  "4294967295" ) == бцел.max );

        assert(разбор( "-9223372036854775808" ) == дол.min );
        assert(разбор( "9223372036854775807" ) == дол.max );
        assert(разбор( "18446744073709551615" ) == бдол.max );

        // hex
        assert(разбор( "a", 16) == 0x0A );
        assert(разбор( "b", 16) == 0x0B );
        assert(разбор( "c", 16) == 0x0C );
        assert(разбор( "d", 16) == 0x0D );
        assert(разбор( "e", 16) == 0x0E );
        assert(разбор( "f", 16) == 0x0F );
        assert(разбор( "A", 16) == 0x0A );
        assert(разбор( "B", 16) == 0x0B );
        assert(разбор( "C", 16) == 0x0C );
        assert(разбор( "D", 16) == 0x0D );
        assert(разбор( "E", 16) == 0x0E );
        assert(разбор( "F", 16) == 0x0F );
        assert(разбор( "FFFF", 16) == бкрат.max );
        assert(разбор( "ffffFFFF", 16) == бцел.max );
        assert(разбор( "ffffFFFFffffFFFF", 16u ) == бдол.max );
        // oct
        assert(разбор( "55", 8) == 055 );
        assert(разбор( "100", 8) == 0100 );
        // bin
        assert(разбор( "10000", 2) == 0x10 );
        // trim
        assert(разбор( "    \t20") == 20 );
        assert(разбор( "    \t-20") == -20 );
        assert(разбор( "-    \t 20") == -20 );
        // recognise radix префикс
        assert(разбор( "0xFFFF" ) == бкрат.max );
        assert(разбор( "0XffffFFFF" ) == бцел.max );
        assert(разбор( "0o55") == 055 );
        assert(разбор( "0O55" ) == 055 );
        assert(разбор( "0b10000") == 0x10 );
        assert(разбор( "0B10000") == 0x10 );

        // префикс tests
        ткст ткт = "0x";
        assert(разбор( ткт[0..1] ) ==  0 );
        assert(разбор("0x10", 10) == 0);
        assert(разбор("0b10", 10) == 0);
        assert(разбор("0o10", 10) == 0);
        assert(разбор("0b10") == 0b10);
        assert(разбор("0o10") == 010);
        assert(разбор("0b10", 2) == 0b10);
        assert(разбор("0o10", 8) == 010);

        // revised tests
        assert (форматируй(врем, 10, "d") == "10");
        assert (форматируй(врем, -10, "d") == "-10");

        assert (форматируй(врем, 10L, "u") == "10");
        assert (форматируй(врем, 10L, "U") == "10");
        assert (форматируй(врем, 10L, "g") == "10");
        assert (форматируй(врем, 10L, "G") == "10");
        assert (форматируй(врем, 10L, "o") == "12");
        assert (форматируй(врем, 10L, "O") == "12");
        assert (форматируй(врем, 10L, "b") == "1010");
        assert (форматируй(врем, 10L, "B") == "1010");
        assert (форматируй(врем, 10L, "x") == "a");
        assert (форматируй(врем, 10L, "X") == "A");

        assert (форматируй(врем, 10L, "d+") == "+10");
        assert (форматируй(врем, 10L, "d ") == " 10");
        assert (форматируй(врем, 10L, "d#") == "10");
        assert (форматируй(врем, 10L, "x#") == "0xa");
        assert (форматируй(врем, 10L, "X#") == "0XA");
        assert (форматируй(врем, 10L, "b#") == "0b1010");
        assert (форматируй(врем, 10L, "o#") == "0o12");

        assert (форматируй(врем, 10L, "d1") == "10");
        assert (форматируй(врем, 10L, "d8") == "00000010");
        assert (форматируй(врем, 10L, "x8") == "0000000a");
        assert (форматируй(врем, 10L, "X8") == "0000000A");
        assert (форматируй(врем, 10L, "b8") == "00001010");
        assert (форматируй(врем, 10L, "o8") == "00000012");

        assert (форматируй(врем, 10L, "d1#") == "10");
        assert (форматируй(врем, 10L, "d6#") == "000010");
        assert (форматируй(врем, 10L, "x6#") == "0x00000a");
        assert (форматируй(врем, 10L, "X6#") == "0X00000A");

        сим[8] tmp1;
        assert (форматируй(tmp1, 10L, "b12#") == "0b001010");
        assert (форматируй(tmp1, 10L, "o12#") == "0o000012");
        }
}

/******************************************************************************

******************************************************************************/

debug (Целое)
{
        import io.Stdout;

        проц main()
        {
                сим[8] врем;

                Стдвыв.форматнс ("d '{}'", форматируй(врем, 10));
                Стдвыв.форматнс ("d '{}'", форматируй(врем, -10));

                Стдвыв.форматнс ("u '{}'", форматируй(врем, 10L, "u"));
                Стдвыв.форматнс ("U '{}'", форматируй(врем, 10L, "U"));
                Стдвыв.форматнс ("g '{}'", форматируй(врем, 10L, "g"));
                Стдвыв.форматнс ("G '{}'", форматируй(врем, 10L, "G"));
                Стдвыв.форматнс ("o '{}'", форматируй(врем, 10L, "o"));
                Стдвыв.форматнс ("O '{}'", форматируй(врем, 10L, "O"));
                Стдвыв.форматнс ("b '{}'", форматируй(врем, 10L, "b"));
                Стдвыв.форматнс ("B '{}'", форматируй(врем, 10L, "B"));
                Стдвыв.форматнс ("x '{}'", форматируй(врем, 10L, "x"));
                Стдвыв.форматнс ("X '{}'", форматируй(врем, 10L, "X"));

                Стдвыв.форматнс ("d+ '{}'", форматируй(врем, 10L, "d+"));
                Стдвыв.форматнс ("ds '{}'", форматируй(врем, 10L, "d "));
                Стдвыв.форматнс ("d# '{}'", форматируй(врем, 10L, "d#"));
                Стдвыв.форматнс ("x# '{}'", форматируй(врем, 10L, "x#"));
                Стдвыв.форматнс ("X# '{}'", форматируй(врем, 10L, "X#"));
                Стдвыв.форматнс ("b# '{}'", форматируй(врем, 10L, "b#"));
                Стдвыв.форматнс ("o# '{}'", форматируй(врем, 10L, "o#"));

                Стдвыв.форматнс ("d1 '{}'", форматируй(врем, 10L, "d1"));
                Стдвыв.форматнс ("d8 '{}'", форматируй(врем, 10L, "d8"));
                Стдвыв.форматнс ("x8 '{}'", форматируй(врем, 10L, "x8"));
                Стдвыв.форматнс ("X8 '{}'", форматируй(врем, 10L, "X8"));
                Стдвыв.форматнс ("b8 '{}'", форматируй(врем, 10L, "b8"));
                Стдвыв.форматнс ("o8 '{}'", форматируй(врем, 10L, "o8"));

                Стдвыв.форматнс ("d1# '{}'", форматируй(врем, 10L, "d1#"));
                Стдвыв.форматнс ("d6# '{}'", форматируй(врем, 10L, "d6#"));
                Стдвыв.форматнс ("x6# '{}'", форматируй(врем, 10L, "x6#"));
                Стдвыв.форматнс ("X6# '{}'", форматируй(врем, 10L, "X6#"));

                Стдвыв.форматнс ("b12# '{}'", форматируй(врем, 10L, "b12#"));
                Стдвыв.форматнс ("o12# '{}'", форматируй(врем, 10L, "o12#")).нс;

                Стдвыв.форматнс (используй("10"));
                Стдвыв.форматнс (используй("0x1f"));
                Стдвыв.форматнс (используй("0.123"));
                Стдвыв.форматнс (используй("0.123", да));
                Стдвыв.форматнс (используй("0.123e-10", да)).нс;

                Стдвыв.форматнс (используй("10  s"));
                Стдвыв.форматнс (используй("0x1f   s"));
                Стдвыв.форматнс (используй("0.123  s"));
                Стдвыв.форматнс (используй("0.123  s", да));
                Стдвыв.форматнс (используй("0.123e-10  s", да)).нс;
        }
}



