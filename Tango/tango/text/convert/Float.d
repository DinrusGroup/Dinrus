/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
        
        version:        Nov 2005: Initial release
                        Jan 2010: добавьed internal ecvt() 

        author:         Kris

        A установи of functions for converting between ткст and floating-
        point values.

        Applying the D "import alias" mechanism в_ this module is highly
        recommended, in order в_ предел namespace pollution:
        ---
        import Float = text.convert.Float;

        auto f = Float.разбор ("3.14159");
        ---
        
*******************************************************************************/

module text.convert.Float;

private import exception;

/******************************************************************************

        выбери an internal version
                
******************************************************************************/

version = float_internal;

private alias реал NumType;

/******************************************************************************

        optional math functions
                
******************************************************************************/

private extern (C)
{
        дво лог10 (дво x);
        дво потолок (дво num);
        дво modf (дво num, дво *i);
        дво степ  (дво основа, дво эксп);

        реал log10l (реал x);
        реал ceill (реал num);
        реал modfl (реал num, реал *i);
        реал powl  (реал основа, реал эксп);

        цел printf (сим*, ...);
        version (Windows)
                {
                alias ecvt econvert;
                alias ecvt fconvert;
                }
        else
           {
           alias ecvtl econvert;
           alias ecvtl fconvert;
           }

        сим* ecvt (дво d, цел digits, цел* decpt, цел* sign);
        сим* fcvt (дво d, цел digits, цел* decpt, цел* sign);
        сим* ecvtl (реал d, цел digits, цел* decpt, цел* sign);
        сим* fcvtl (реал d, цел digits, цел* decpt, цел* sign);
}

/******************************************************************************

        Constants
                
******************************************************************************/

private enum 
{
        Pad = 0,                // default trailing decimal zero
        Dec = 2,                // default decimal places
        Exp = 10,               // default switch в_ scientific notation
}

/******************************************************************************

        Convert a formatted ткст of digits в_ a floating-point
        число. Throws an исключение where the ввод текст is not
        parsable in its entirety.
        
******************************************************************************/

NumType toFloat(T) (T[] ист)
{
        бцел длин;

        auto x = разбор (ист, &длин);
        if (длин < ист.length || длин == 0)
            throw new ИсклНелегальногоАргумента ("Float.toFloat :: не_годится число");
        return x;
}

/******************************************************************************

        Template wrapper в_ сделай life simpler. Returns a текст version
        of the provопрed значение.

        See форматируй() for details

******************************************************************************/

ткст вТкст (NumType d, бцел decimals=Dec, цел e=Exp)
{
        сим[64] врем =void;
        
        return форматируй (врем, d, decimals, e).dup;
}
               
/******************************************************************************

        Template wrapper в_ сделай life simpler. Returns a текст version
        of the provопрed значение.

        See форматируй() for details

******************************************************************************/

шим[] вТкст16 (NumType d, бцел decimals=Dec, цел e=Exp)
{
        шим[64] врем =void;
        
        return форматируй (врем, d, decimals, e).dup;
}
               
/******************************************************************************

        Template wrapper в_ сделай life simpler. Returns a текст version
        of the provопрed значение.

        See форматируй() for details

******************************************************************************/

дим[] toString32 (NumType d, бцел decimals=Dec, цел e=Exp)
{
        дим[64] врем =void;
        
        return форматируй (врем, d, decimals, e).dup;
}
               
/******************************************************************************

        Truncate trailing '0' and '.' из_ a ткст, such that 200.000 
        becomes 200, and 20.10 becomes 20.1

        Returns a potentially shorter срез of what you give it.

******************************************************************************/

T[] обрежь(T) (T[] s)
{
        auto врем = s;
        цел i = врем.length;
        foreach (цел инд, T c; врем)
                 if (c is '.')
                     while (--i >= инд)
                            if (врем[i] != '0')
                               {  
                               if (врем[i] is '.')
                                   --i;
                               s = врем [0 .. i+1];
                               while (--i >= инд)
                                      if (врем[i] is 'e')
                                          return врем;
                               break;
                               }
        return s;
}

/******************************************************************************

        Extract a sign-bit

******************************************************************************/

private бул negative (NumType x)
{
        static if (NumType.sizeof is 4) 
                   return ((*cast(бцел *)&x) & 0x8000_0000) != 0;
        else
           static if (NumType.sizeof is 8) 
                      return ((*cast(бдол *)&x) & 0x8000_0000_0000_0000) != 0;
                else
                   {
                   auto pe = cast(ббайт *)&x;
                   return (pe[9] & 0x80) != 0;
                   }
}


/******************************************************************************

        Convert a floating-point число в_ a ткст. 

        The e parameter controls the число of exponent places излейted, 
        and can thus control where the вывод switches в_ the scientific 
        notation. For example, настройка e=2 for 0.01 or 10.0 would результат
        in нормаль вывод. Whereas настройка e=1 would результат in Всё those
        values being rendered in scientific notation instead. Setting e
        в_ 0 forces that notation on for everything. Parameter pad will
        добавь trailing '0' decimals when установи ~ otherwise trailing '0's 
        will be elопрed

******************************************************************************/

T[] форматируй(T, D=NumType, U=цел) (T[] приёмн, D x, U decimals=Dec, U e=Exp, бул pad=Pad)
{return форматируй!(T)(приёмн, x, decimals, e, pad);}

T[] форматируй(T) (T[] приёмн, NumType x, цел decimals=Dec, цел e=Exp, бул pad=Pad)
{
        сим*           конец,
                        ткт;
        цел             эксп,
                        sign,
                        режим=5;
        сим[32]        буф =void;

        // тест exponent в_ determine режим
        эксп = (x is 0) ? 1 : cast(цел) log10l (x < 0 ? -x : x);
        if (эксп <= -e || эксп >= e)
            режим = 2, ++decimals;

version (float_internal)
         ткт = convertl (буф.ptr, x, decimals, &эксп, &sign, режим is 5);
version (float_dtoa)
         ткт = dtoa (x, режим, decimals, &эксп, &sign, &конец);
version (float_lib)
        {
        if (режим is 5)
            ткт = fconvert (x, decimals, &эксп, &sign);
        else
           ткт = econvert (x, decimals, &эксп, &sign);
        }

        auto p = приёмн.ptr;
        if (sign)
            *p++ = '-';

        if (эксп is 9999)
            while (*ткт) 
                   *p++ = *ткт++;
        else
           {
           if (режим is 2)
              {
              --эксп;
              *p++ = *ткт++;
              if (*ткт || pad)
                 {
                 auto d = p;
                 *p++ = '.';
                 while (*ткт)
                        *p++ = *ткт++;
                 if (pad)
                     while (p-d < decimals)
                            *p++ = '0';
                 }
              *p++ = 'e';
              if (эксп < 0)
                  *p++ = '-', эксп = -эксп;
              else
                 *p++ = '+';
              if (эксп >= 1000)
                 {
                 *p++ = cast(T)((эксп/1000) + '0');
                 эксп %= 1000;
                 }
              if (эксп >= 100)
                 {
                 *p++ = эксп / 100 + '0';
                 эксп %= 100;
                 }
              *p++ = эксп / 10 + '0';
              *p++ = эксп % 10 + '0';
              }
           else
              {
              if (эксп <= 0)
                  *p++ = '0';
              else
                 for (; эксп > 0; --эксп)
                        *p++ = (*ткт) ? *ткт++ : '0';
              if (*ткт || pad)
                 {
                 *p++ = '.';
                 auto d = p;
                 for (; эксп < 0; ++эксп)
                        *p++ = '0';
                 while (*ткт)
                        *p++ = *ткт++;
                 if (pad)
                     while (p-d < decimals)
                            *p++ = '0';
                 }
              } 
           }

        // stuff a C terminator in there too ...
        *p = 0;
        return приёмн[0..(p - приёмн.ptr)];
}


/******************************************************************************

        ecvt() and fcvt() for 80bit FP, which DMD does not include. Based
        upon the following:

        Copyright (c) 2009 Ian Piumarta
        
        все rights reserved.

        Permission is hereby granted, free of charge, в_ any person 
        obtaining a копируй of this software and associated documentation 
        файлы (the 'Software'), в_ deal in the Software without restriction, 
        включая without limitation the rights в_ use, копируй, modify, merge, 
        publish, distribute, and/or sell copies of the Software, and в_ permit 
        persons в_ whom the Software is furnished в_ do so, provопрed that the 
        above copyright notice(s) and this permission notice appear in все 
        copies of the Software.  

******************************************************************************/

version (float_internal)
{
private сим *convertl (сим* буф, реал значение, цел ndigit, цел *decpt, цел *sign, цел fflag)
{
        if ((*sign = negative(значение)) != 0)
             значение = -значение;

        *decpt = 9999;
        if (значение !<>= значение)
            return "nan\0";

        if (значение is значение.infinity)
            return "inf\0";

        цел exp10 = (значение is 0) ? !fflag : cast(цел) ceill(log10l(значение));
        if (exp10 < -4931) 
            exp10 = -4931;	
        значение *= powl (10.0, -exp10);
        if (значение) 
           {
           while (значение <  0.1) { значение *= 10;  --exp10; }
           while (значение >= 1.0) { значение /= 10;  ++exp10; }
           }
        assert(значение is 0 || (0.1 <= значение && значение < 1.0));
        //auto zero = pad ? цел.max : 1;
        auto zero = 1;
        if (fflag) 
           {
           // if (! pad)
                 zero = exp10;
           if (ndigit + exp10 < 0) 
              {
              *decpt= -ndigit;
              return "\0";
              }
           ndigit += exp10;
           }
        *decpt = exp10;
        int ptr = 1;

        if (ndigit > реал.dig) 
            ndigit = реал.dig;
        //printf ("< flag %d, digits %d, exp10 %d, decpt %d\n", fflag, ndigit, exp10, *decpt);
        while (ptr <= ndigit) 
              {
              реал i =void;
              значение = modfl (значение * 10, &i);
              буф [ptr++]= '0' + cast(цел) i;
              }

        if (значение >= 0.5)
            while (--ptr && ++буф[ptr] > '9')
                   буф[ptr] = (ptr > zero) ? '\0' : '0';
        else
           for (auto i=ptr; i && --i > zero && буф[i] is '0';)
                буф[i] = '\0';

        if (ptr) 
           {
           буф [ndigit + 1] = '\0';
           return буф + 1;
           }
        if (fflag) 
           {
           ++ndigit;
           ++*decpt;
           }
        буф[0]= '1';
        буф[ndigit]= '\0';
        return буф;
}
}


/******************************************************************************

        David Gay's extended conversions between ткст and floating-point
        numeric representations. Use these where you need extended accuracy
        for convertions. 

        Note that this class requires the attendent файл dtoa.c be compiled 
        and linked в_ the application

******************************************************************************/

version (float_dtoa)
{
        private extern(C)
        {
        // these should be linked in via dtoa.c
        дво strtod (сим* s00, сим** se);
        сим*  dtoa (дво d, цел режим, цел ndigits, цел* decpt, цел* sign, сим** rve);
        }

        /**********************************************************************

                Convert a formatted ткст of digits в_ a floating-
                point число. 

        **********************************************************************/

        NumType разбор (ткст ист, бцел* ate=пусто)
        {
                сим* конец;

                auto значение = strtod (ист.ptr, &конец);
                assert (конец <= ист.ptr + ист.length);
                if (ate)
                    *ate = конец - ист.ptr;
                return значение;
        }

        /**********************************************************************

                Convert a formatted ткст of digits в_ a floating-
                point число.

        **********************************************************************/

        NumType разбор (шим[] ист, бцел* ate=пусто)
        {
                // cheesy hack в_ avoопр pre-parsing :: max digits == 100
                сим[100] врем =void;
                auto p = врем.ptr;
                auto e = p + врем.length;
                foreach (c; ист)
                         if (p < e && (c & 0x80) is 0)
                             *p++ = c;                        
                         else
                            break;

                return разбор (врем[0..p-врем.ptr], ate);
        }

        /**********************************************************************

                Convert a formatted ткст of digits в_ a floating-
                point число. 

        **********************************************************************/

        NumType разбор (дим[] ист, бцел* ate=пусто)
        {
                // cheesy hack в_ avoопр pre-parsing :: max digits == 100
                сим[100] врем =void;
                auto p = врем.ptr;
                auto e = p + врем.length;
                foreach (c; ист)
                         if (p < e && (c & 0x80) is 0)
                             *p++ = c;
                         else
                            break;
                return разбор (врем[0..p-врем.ptr], ate);
        }
}
else
{
private import Целое = text.convert.Integer;

/******************************************************************************

        Convert a formatted ткст of digits в_ a floating-point число.
        Good for general use, but use David Gay's dtoa package if serious
        rounding adjustments should be applied.

******************************************************************************/

NumType разбор(T) (T[] ист, бцел* ate=пусто)
{
        T               c;
        T*              p;
        цел             эксп;
        бул            sign;
        бцел            radix;
        NumType         значение = 0.0;

        static бул match (T* aa, T[] bb)
        {
                foreach (b; bb)
                        {
                        auto a = *aa++;
                        if (a >= 'A' && a <= 'Z')
                            a += 'a' - 'A';
                        if (a != b)
                            return нет;
                        }
                return да;
        }

        // удали leading пространство, and sign
        p = ист.ptr + Целое.trim (ист, sign, radix);

        // bail out if the ткст is пустой
        if (ист.length is 0 || p > &ист[$-1])
            return NumType.nan;
        c = *p;

        // укз non-decimal representations
        if (radix != 10)
           {
           дол v = Целое.разбор (ист, radix, ate); 
           return cast(NumType) v;
           }

        // установи begin and конец checks
        auto begin = p;
        auto конец = ист.ptr + ист.length;

        // читай leading digits; note that leading
        // zeros are simply multИПlied away
        while (c >= '0' && c <= '9' && p < конец)
              {
              значение = значение * 10 + (c - '0');
              c = *++p;
              }

        // gobble up the point
        if (c is '.' && p < конец)
            c = *++p;

        // читай fractional digits; note that we accumulate
        // все digits ... very дол numbers impact accuracy
        // в_ a degree, but perhaps not as much as one might
        // expect. A prior version limited the цифра счёт,
        // but dопр not show marked improvement. For maximum
        // accuracy when reading and writing, use David Gay's
        // dtoa package instead
        while (c >= '0' && c <= '9' && p < конец)
              {
              значение = значение * 10 + (c - '0');
              c = *++p;
              --эксп;
              } 

        // dопр we получи something?
        if (p > begin)
           {
           // разбор base10 exponent?
           if ((c is 'e' || c is 'E') && p < конец )
              {
              бцел eaten;
              эксп += Целое.разбор (ист[(++p-ист.ptr) .. $], 0, &eaten);
              p += eaten;
              }

           // исправь mantissa; note that the exponent есть
           // already been adjusted for fractional digits
           if (эксп < 0)
               значение /= pow10 (-эксп);
           else
              значение *= pow10 (эксп);
           }
        else
           if (конец - p >= 3)
               switch (*p)
                      {
                      case 'I': case 'i':
                           if (match (p+1, "nf"))
                              {
                              значение = значение.infinity;
                              p += 3;
                              if (конец - p >= 5 && match (p, "inity"))
                                  p += 5;
                              }
                           break;

                      case 'N': case 'n':
                           if (match (p+1, "an"))
                              {
                              значение = значение.nan;
                              p += 3;
                              }
                           break;
                      default:
                           break;
                      }

        // установи разбор length, and return значение
        if (ate)
            *ate = p - ист.ptr;

        if (sign)
            значение = -значение;
        return значение;
}

/******************************************************************************

        Internal function в_ преобразуй an exponent specifier в_ a floating
        point значение.

******************************************************************************/

private NumType pow10 (бцел эксп)
{
        static  NumType[] Powers = 
                [
                1.0e1L,
                1.0e2L,
                1.0e4L,
                1.0e8L,
                1.0e16L,
                1.0e32L,
                1.0e64L,
                1.0e128L,
                1.0e256L,
                1.0e512L,
                1.0e1024L,
                1.0e2048L,
                1.0e4096L,
                1.0e8192L,
                ];

        if (эксп >= 16384)
            throw new ИсклНелегальногоАргумента ("Float.pow10 :: exponent too large");

        NumType mult = 1.0;
        foreach (NumType power; Powers)
                {
                if (эксп & 1)
                    mult *= power;
                if ((эксп >>= 1) is 0)
                     break;
                }
        return mult;
}
}

version (float_old)
{
/******************************************************************************

        Convert a плав в_ a ткст. This produces pretty good results
        for the most часть, though one should use David Gay's dtoa package
        for best accuracy.

        Note that the approach first normalizes a base10 mantissa, then
        pulls digits из_ the left sопрe whilst излейting them (rightward)
        в_ the вывод.

        The e parameter controls the число of exponent places излейted, 
        and can thus control where the вывод switches в_ the scientific 
        notation. For example, настройка e=2 for 0.01 or 10.0 would результат
        in нормаль вывод. Whereas настройка e=1 would результат in Всё those
        values being rendered in scientific notation instead. Setting e
        в_ 0 forces that notation on for everything.

        TODO: this should be replaced, as it is not sufficiently accurate 

******************************************************************************/

T[] форматируй(T, D=дво, U=бцел) (T[] приёмн, D x, U decimals=Dec, цел e=Exp, бул pad=Pad)
{return форматируй!(T)(приёмн, x, decimals, e, pad);}

T[] форматируй(T) (T[] приёмн, NumType x, бцел decimals=Dec, цел e=Exp, бул pad=Pad)
{
        static T[] inf = "-inf";
        static T[] nan = "-nan";

        // strip digits из_ the left of a normalized основа-10 число
        static цел toDigit (ref NumType v, ref цел счёт)
        {
                цел цифра;

                // Don't exceed max digits storable in a реал
                // (-1 because the последний цифра is not always storable)
                if (--счёт <= 0)
                    цифра = 0;
                else
                   {
                   // удали leading цифра, and bump
                   цифра = cast(цел) v;
                   v = (v - цифра) * 10.0;
                   }
                return цифра + '0';
        }

        // extract the sign
        бул sign = negative (x);
        if (sign)
            x = -x;

        if (x !<>= x)
            return sign ? nan : nan[1..$];

        if (x is x.infinity)
            return sign ? inf : inf[1..$];

        // assume no exponent
        цел эксп = 0;
        цел абс = 0;

        // don't шкала if zero
        if (x > 0.0)
           {
           // extract base10 exponent
           эксп = cast(цел) log10l (x);

           // округли up a bit
           auto d = decimals;
           if (эксп < 0)
               d -= эксп;
           x += 0.5 / pow10 (d);

           // нормализуй base10 mantissa (0 < m < 10)
           абс = эксп = cast(цел) log10l (x);
           if (эксп > 0)
               x /= pow10 (эксп);
           else
              абс = -эксп;

           // switch в_ exponent display as necessary
           if (абс >= e)
               e = 0; 
           }

        T* p = приёмн.ptr;
        цел счёт = NumType.dig;

        // излей sign
        if (sign)
            *p++ = '-';
        
        // are we doing +/-эксп форматируй?
        if (e is 0)
           {
           assert (приёмн.length > decimals + 7);

           if (эксп < 0)
               x *= pow10 (абс+1);

           // излей first цифра, and decimal point
           *p++ = cast(T) toDigit (x, счёт);
           if (decimals)
              {
              *p++ = '.';

              // излей rest of mantissa
              while (decimals-- > 0)
                     *p++ = cast(T) toDigit (x, счёт);
              
              if (pad is нет)
                 {
                 while (*(p-1) is '0')
                        --p;
                 if (*(p-1) is '.')
                     --p;
                 }
              }

           // излей exponent, if non zero
           if (абс)
              {
              *p++ = 'e';
              *p++ = (эксп < 0) ? '-' : '+';
              if (абс >= 1000)
                 {
                 *p++ = cast(T)((абс/1000) + '0');
                 абс %= 1000;
                 *p++ = cast(T)((абс/100) + '0');
                 абс %= 100;
                 }
              else
                 if (абс >= 100)
                    {
                    *p++ = cast(T)((абс/100) + '0');
                    абс %= 100;
                    }
              *p++ = cast(T)((абс/10) + '0');
              *p++ = cast(T)((абс%10) + '0');
              }
           }
        else
           {
           assert (приёмн.length >= (((эксп < 0) ? 0 : эксп) + decimals + 1));

           // if дробь only, излей a leading zero
           if (эксп < 0)
              {
              x *= pow10 (абс);
              *p++ = '0';
              }
           else
              // излей все digits в_ the left of point
              for (; эксп >= 0; --эксп)
                     *p++ = cast(T )toDigit (x, счёт);

           // излей point
           if (decimals)
              {
              *p++ = '.';

              // излей leading fractional zeros?
              for (++эксп; эксп < 0 && decimals > 0; --decimals, ++эксп)
                   *p++ = '0';

              // вывод remaining digits, if any. Trailing
              // zeros are also returned из_ toDigit()
              while (decimals-- > 0)
                     *p++ = cast(T) toDigit (x, счёт);

              if (pad is нет)
                 {
                 while (*(p-1) is '0')
                        --p;
                 if (*(p-1) is '.')
                     --p;
                 }
              }
           }

        return приёмн [0..(p - приёмн.ptr)];
}
}

/******************************************************************************

******************************************************************************/

debug (UnitTest)
{
        import io.Console;
      
        unittest
        {
                сим[164] врем;

                auto f = разбор ("nan");
                assert (форматируй(врем, f) == "nan");
                f = разбор ("inf");
                assert (форматируй(врем, f) == "inf");
                f = разбор ("-nan");
                assert (форматируй(врем, f) == "-nan");
                f = разбор (" -inf");
                assert (форматируй(врем, f) == "-inf");

                assert (форматируй (врем, 3.14159, 6) == "3.14159");
                assert (форматируй (врем, 3.14159, 4) == "3.1416");
                assert (разбор ("3.5") == 3.5);
                assert (форматируй(врем, разбор ("3.14159"), 6) == "3.14159");
        }
}


debug (Float)
{
        import io.Console;

        проц main() 
        {
                сим[500] врем;
/+
                Квывод (форматируй(врем, NumType.max)).нс;
                Квывод (форматируй(врем, -NumType.nan)).нс;
                Квывод (форматируй(врем, -NumType.infinity)).нс;
                Квывод (форматируй(врем, toFloat("nan"w))).нс;
                Квывод (форматируй(врем, toFloat("-nan"d))).нс;
                Квывод (форматируй(врем, toFloat("inf"))).нс;
                Квывод (форматируй(врем, toFloat("-inf"))).нс;
+/
                Квывод (форматируй(врем, toFloat ("0.000000e+00"))).нс;
                Квывод (форматируй(врем, toFloat("0x8000000000000000"))).нс;
                Квывод (форматируй(врем, 1)).нс;
                Квывод (форматируй(врем, -0)).нс;
                Квывод (форматируй(врем, 0.000001)).нс.нс;

                Квывод (форматируй(врем, 3.14159, 6, 0)).нс;
                Квывод (форматируй(врем, 3.0e10, 6, 3)).нс;
                Квывод (форматируй(врем, 314159, 6)).нс;
                Квывод (форматируй(врем, 314159123213, 6, 15)).нс;
                Квывод (форматируй(врем, 3.14159, 6, 2)).нс;
                Квывод (форматируй(врем, 3.14159, 3, 2)).нс;
                Квывод (форматируй(врем, 0.00003333, 6, 2)).нс;
                Квывод (форматируй(врем, 0.00333333, 6, 3)).нс;
                Квывод (форматируй(врем, 0.03333333, 6, 2)).нс;
                Квывод.нс;

                Квывод (форматируй(врем, -3.14159, 6, 0)).нс;
                Квывод (форматируй(врем, -3e100, 6, 3)).нс;
                Квывод (форматируй(врем, -314159, 6)).нс;
                Квывод (форматируй(врем, -314159123213, 6, 15)).нс;
                Квывод (форматируй(врем, -3.14159, 6, 2)).нс;
                Квывод (форматируй(врем, -3.14159, 2, 2)).нс;
                Квывод (форматируй(врем, -0.00003333, 6, 2)).нс;
                Квывод (форматируй(врем, -0.00333333, 6, 3)).нс;
                Квывод (форматируй(врем, -0.03333333, 6, 2)).нс;
                Квывод.нс;

                Квывод (форматируй(врем, -0.9999999, 7, 3)).нс;
                Квывод (форматируй(врем, -3.0e100, 6, 3)).нс;
                Квывод ((форматируй(врем, 1.0, 6))).нс;
                Квывод ((форматируй(врем, 30, 6))).нс;
                Квывод ((форматируй(врем, 3.14159, 6, 0))).нс;
                Квывод ((форматируй(врем, 3e100, 6, 3))).нс;
                Квывод ((форматируй(врем, 314159, 6))).нс;
                Квывод ((форматируй(врем, 314159123213.0, 3, 15))).нс;
                Квывод ((форматируй(врем, 3.14159, 6, 2))).нс;
                Квывод ((форматируй(врем, 3.14159, 4, 2))).нс;
                Квывод ((форматируй(врем, 0.00003333, 6, 2))).нс;
                Квывод ((форматируй(врем, 0.00333333, 6, 3))).нс;
                Квывод ((форматируй(врем, 0.03333333, 6, 2))).нс;
                Квывод (форматируй(врем, NumType.min, 6)).нс;
                Квывод (форматируй(врем, -1)).нс;
                Квывод (форматируй(врем, toFloat(форматируй(врем, -1)))).нс;
                Квывод.нс;
        }
}
