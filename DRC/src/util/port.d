/**
 * Compiler implementation of the D programming language
 * http://dlang.org
 *
 * Copyright: Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:   Walter Bright, http://www.digitalmars.com
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:    $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/root/port.d, root/_port.d)
 * Documentation:  https://dlang.org/phobos/dmd_root_port.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/root/port.d
 */

module util.port;

import cidrus;

private extern (C)
{
    version(CRuntime_DigitalMars)  extern ткст0 __locale_decpoint;

    version(CRuntime_Microsoft)
    {
        const _OVERFLOW  = 3;   /* overflow range error */
        const _UNDERFLOW = 4;   /* underflow range error */

        цел _atoflt(float*  значение, ткст0 str);
        цел _atodbl(double* значение, ткст0 str);
    }
}

 struct Port
{

    static цел memicmp( ткст0 s1,  ткст0 s2, т_мера n) 
    {
        цел результат = 0;

        foreach (i; new бцел[0 .. n])
        {
            сим c1 = s1[i];
            сим c2 = s2[i];

            результат = c1 - c2;
            if (результат)
            {
                результат = toupper(c1) - toupper(c2);
                if (результат)
                    break;
            }
        }
        return результат;
    }

    static ткст0 strupr(ткст0 s) 
    {
        ткст0 t = s;

        while (*s)
        {
            *s = cast(сим)toupper(*s);
            s++;
        }

        return t;
    }

    static бул isFloat32LiteralOutOfRange( ткст0 s)
    {
        errno = 0;
        version (CRuntime_DigitalMars)
        {
            auto save = __locale_decpoint;
            __locale_decpoint = ".";
        }
        version (CRuntime_Microsoft)
        {
            float r;
            цел res = _atoflt(&r, s);
            if (res == _UNDERFLOW || res == _OVERFLOW)
                errno = ERANGE;
        }
        else
        {
            strtof(s, null);
        }
        version (CRuntime_DigitalMars) __locale_decpoint = save;
        return errno == ERANGE;
    }

    static бул isFloat64LiteralOutOfRange( ткст0 s)
    {
        errno = 0;
        version (CRuntime_DigitalMars)
        {
            auto save = __locale_decpoint;
            __locale_decpoint = ".";
        }
        version (CRuntime_Microsoft)
        {
            double r;
            цел res = _atodbl(&r, s);
            if (res == _UNDERFLOW || res == _OVERFLOW)
                errno = ERANGE;
        }
        else
        {
            strtod(s, null);
        }
        version (CRuntime_DigitalMars) __locale_decpoint = save;
        return errno == ERANGE;
    }

    // Little endian
    static проц writelongLE(бцел значение, ук буфер) 
    {
        auto p = cast(ббайт*)буфер;
        p[3] = cast(ббайт)(значение >> 24);
        p[2] = cast(ббайт)(значение >> 16);
        p[1] = cast(ббайт)(значение >> 8);
        p[0] = cast(ббайт)(значение);
    }

    // Little endian
    static бцел readlongLE(ук буфер) 
    {
        auto p = cast( ббайт*)буфер;
        return (((((p[3] << 8) | p[2]) << 8) | p[1]) << 8) | p[0];
    }

    // Big endian
    static проц writelongBE(бцел значение,  ук буфер) 
    {
        auto p = cast(ббайт*)буфер;
        p[0] = cast(ббайт)(значение >> 24);
        p[1] = cast(ббайт)(значение >> 16);
        p[2] = cast(ббайт)(значение >> 8);
        p[3] = cast(ббайт)(значение);
    }

    // Big endian
    static бцел readlongBE( ук буфер) 
    {
        auto p = cast(ббайт*)буфер;
        return (((((p[0] << 8) | p[1]) << 8) | p[2]) << 8) | p[3];
    }

    // Little endian
    static бцел readwordLE( ук буфер) 
    {
        auto p = cast(ббайт*)буфер;
        return (p[1] << 8) | p[0];
    }

    // Big endian
    static бцел readwordBE( ук буфер) 
    {
        auto p = cast(ббайт*)буфер;
        return (p[0] << 8) | p[1];
    }

    static проц valcpy( проц *dst, бдол val, т_мера size) 
    {
        switch (size)
        {
            case 1: *cast(ббайт *)dst = cast(ббайт)val; break;
            case 2: *cast(ushort *)dst = cast(ushort)val; break;
            case 4: *cast(бцел *)dst = cast(бцел)val; break;
            case 8: *cast(бдол *)dst = cast(бдол)val; break;
            default: assert(0);
        }
    }
}
