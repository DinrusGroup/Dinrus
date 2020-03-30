/***
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/root/ctfloat.d, root/_ctfloat.d)
 * Documentation: https://dlang.org/phobos/dmd_root_ctfloat.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/root/ctfloat.d
 */

module util.ctfloat;

//static import core.math, core.stdc.math;
import cidrus;



// Тип используется by the front-end for compile-time reals
public import util.longdouble : real_t = longdouble;

private
{
    version(CRuntime_DigitalMars)  extern (C) extern ткст0 __locale_decpoint;

    version(CRuntime_Microsoft) 
    {
        public import util.longdouble : longdouble_soft, ld_sprint;
        import util.strtold;
    }
}

// Compile-time floating-point helper
 struct CTFloat
{

version (GNU) 
		const yl2x_supported = нет;
version(Dinrus){
    const yl2x_supported = нет;
}else{
    const yl2x_supported = __traits(compiles, core.math.yl2x(1.0L, 2.0L));    
}
const yl2xp1_supported = yl2x_supported;

    static проц yl2x( real_t* x, real_t* y, real_t* res) 
    {
        static if (yl2x_supported)
            *res = core.math.yl2x(*x, *y);
        else
            assert(0);
    }

    static проц yl2xp1( real_t* x, real_t* y, real_t* res) 
    {
        static if (yl2xp1_supported)
            *res = core.math.yl2xp1(*x, *y);
        else
            assert(0);
    }

    static if (!is(real_t == real))
    {
        alias  util.longdouble.sinl sin;
        alias  util.longdouble.cosl cos;
        alias  util.longdouble.tanl tan;
        alias  util.longdouble.sqrtl sqrt;
        alias  util.longdouble.fabsl fabs;
        alias  util.longdouble.ldexpl ldexp;
    }
    else
    {
         static real_t sin(real_t x) { return core.math.sin(x); }
         static real_t cos(real_t x) { return core.math.cos(x); }
        static real_t tan(real_t x) { return core.stdc.math.tanl(x); }
         static real_t sqrt(real_t x) { return core.math.sqrt(x); }
         static real_t fabs(real_t x) { return core.math.fabs(x); }
         static real_t ldexp(real_t n, цел exp) { return core.math.ldexp(n, exp); }
    }

    static if (!is(real_t == real))
    {
        static real_t round(real_t x) { return real_t(cast(double)core.stdc.math.roundl(cast(double)x)); }
        static real_t floor(real_t x) { return real_t(cast(double)core.stdc.math.floor(cast(double)x)); }
        static real_t ceil(real_t x) { return real_t(cast(double)core.stdc.math.ceil(cast(double)x)); }
        static real_t trunc(real_t x) { return real_t(cast(double)core.stdc.math.trunc(cast(double)x)); }
        static real_t log(real_t x) { return real_t(cast(double)core.stdc.math.logl(cast(double)x)); }
        static real_t log2(real_t x) { return real_t(cast(double)core.stdc.math.log2l(cast(double)x)); }
        static real_t log10(real_t x) { return real_t(cast(double)core.stdc.math.log10l(cast(double)x)); }
        static real_t pow(real_t x, real_t y) { return real_t(cast(double)core.stdc.math.powl(cast(double)x, cast(double)y)); }
        static real_t exp(real_t x) { return real_t(cast(double)core.stdc.math.expl(cast(double)x)); }
        static real_t expm1(real_t x) { return real_t(cast(double)core.stdc.math.expm1l(cast(double)x)); }
        static real_t exp2(real_t x) { return real_t(cast(double)core.stdc.math.exp2l(cast(double)x)); }
        static real_t copysign(real_t x, real_t s) { return real_t(cast(double)core.stdc.math.copysignl(cast(double)x, cast(double)s)); }
    }
    else
    {
        static real_t round(real_t x) { return core.stdc.math.roundl(x); }
        static real_t floor(real_t x) { return core.stdc.math.floor(x); }
        static real_t ceil(real_t x) { return core.stdc.math.ceil(x); }
        static real_t trunc(real_t x) { return core.stdc.math.trunc(x); }
        static real_t log(real_t x) { return core.stdc.math.logl(x); }
        static real_t log2(real_t x) { return core.stdc.math.log2l(x); }
        static real_t log10(real_t x) { return core.stdc.math.log10l(x); }
        static real_t pow(real_t x, real_t y) { return core.stdc.math.powl(x, y); }
        static real_t exp(real_t x) { return core.stdc.math.expl(x); }
        static real_t expm1(real_t x) { return core.stdc.math.expm1l(x); }
        static real_t exp2(real_t x) { return core.stdc.math.exp2l(x); }
        static real_t copysign(real_t x, real_t s) { return core.stdc.math.copysignl(x, s); }
    }

    
    static real_t fmin(real_t x, real_t y) { return x < y ? x : y; }
    
    static real_t fmax(real_t x, real_t y) { return x > y ? x : y; }

    
    static real_t fma(real_t x, real_t y, real_t z) { return (x * y) + z; }
    
    static бул isIdentical(real_t a, real_t b)
    {
        // don't compare pad bytes in extended precision
        const sz = (real_t.mant_dig == 64) ? 10 : real_t.sizeof;
        return memcmp(&a, &b, sz) == 0;
    }

    import util.хэш : calcHash;
    static т_мера хэш(real_t a)
    {
        if (isNaN(a))
            a = real_t.nan;
        const sz = (real_t.mant_dig == 64) ? 10 : real_t.sizeof;
        return calcHash((cast(ббайт*) &a)[0 .. sz]);
    }

    
    static бул isNaN(real_t r)
    {
        return !(r == r);
    }

    
    static бул isSNaN(real_t r)
    {
        return isNaN(r) && !(((cast(ббайт*)&r)[7]) & 0x40);
    }

    // the implementation of longdouble for MSVC is a struct, so mangling
    //  doesn't match with the C++ header.
    // add a wrapper just for isSNaN as this is the only function called from C++
    version(CRuntime_Microsoft) static if (is(real_t == real))
        
        static бул isSNaN(longdouble_soft ld)
        {
            return isSNaN(cast(real)ld);
        }

    static бул isInfinity(real_t r) 
    {
        return isIdentical(fabs(r), real_t.infinity);
    }

   // @system
    static real_t parse(ткст0 literal, бул* isOutOfRange = null)
    {
        errno = 0;
        version(CRuntime_DigitalMars)
        {
            auto save = __locale_decpoint;
            __locale_decpoint = ".";
        }
        version(CRuntime_Microsoft)
        {
            auto r = cast(real_t) strtold_dm(literal, null);
        }
        else
            auto r = strtold(literal, null);
        version(CRuntime_DigitalMars) __locale_decpoint = save;
        if (isOutOfRange)
            *isOutOfRange = (errno == ERANGE);
        return r;
    }

   // @system
    static цел sprint(ткст0 str, сим fmt, real_t x)
    {
        version(CRuntime_Microsoft)
        {
            return cast(цел)ld_sprint(str, fmt, longdouble_soft(x));
        }
        else
        {
            if (real_t(cast(бдол)x) == x)
            {
                // ((1.5 -> 1 -> 1.0) == 1.5) is нет
                // ((1.0 -> 1 -> 1.0) == 1.0) is да
                // see http://en.cppreference.com/w/cpp/io/c/fprintf
                сим[5] sfmt = "%#Lg\0";
                sfmt[3] = fmt;
                return sprintf(str, sfmt.ptr, x);
            }
            else
            {
                сим[4] sfmt = "%Lg\0";
                sfmt[2] = fmt;
                return sprintf(str, sfmt.ptr, x);
            }
        }
    }

    // Constant real values 0, 1, -1 and 0.5.
     real_t нуль;
     real_t one;
     real_t minusone;
     real_t half;

   
    static проц initialize()
    {
        нуль = real_t(0);
        one = real_t(1);
        minusone = real_t(-1);
        half = real_t(0.5);
    }
}
