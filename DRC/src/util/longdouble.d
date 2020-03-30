/* Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * All Rights Reserved, written by Rainer Schuetze
 * http://www.digitalmars.com
 * Distributed under the Boost Software License, Version 1.0.
 * (See accompanying файл LICENSE or копируй at http://www.boost.org/LICENSE_1_0.txt)
 * https://github.com/dlang/dmd/blob/master/src/root/longdouble.d
 */

// 80-bit floating point значение implementation if the C/D compiler does not support them natively

module util.longdouble;

static if (real.sizeof > 8)
    alias  real longdouble;
else
    alias longdouble_soft longdouble;

// longdouble_soft needed when building the backend with
// Visual C or the frontend with LDC on Windows
version(CRuntime_Microsoft):
/*extern(C++):*/

/*:*/

version(D_InlineAsm_X86_64)
    version = AsmX86;
else version(D_InlineAsm_X86)
    version = AsmX86;
else
    static assert(нет, "longdouble_soft не поддерживается на этой платформе");

бул initFPU()
{
    version(D_InlineAsm_X86_64)
    {
        // set precision to 64-bit mantissa and rounding control to nearest
        asm  
        {
            сунь    RAX;                 // add space on stack
            fstcw   word ptr [RSP];
            movzx   EAX,word ptr [RSP];  // also return old CW in EAX
            and     EAX, ~0xF00;         // mask for PC and RC
            or      EAX, 0x300;
            mov     dword ptr [RSP],EAX;
            fldcw   word ptr [RSP];
            вынь     RAX;
        }
    }
    else version(D_InlineAsm_X86)
    {
        // set precision to 64-bit mantissa and rounding control to nearest
        asm  
        {
            сунь    EAX;                 // add space on stack
            fstcw   word ptr [ESP];
            movzx   EAX,word ptr [ESP];  // also return old CW in EAX
            and     EAX, ~0xF00;         // mask for PC and RC
            or      EAX, 0x300;
            mov     dword ptr [ESP],EAX;
            fldcw   word ptr [ESP];
            вынь     EAX;
        }
    }

    return да;
}
/+
debug(unittest) version(CRuntime_Microsoft)
 static this()
{
    initFPU(); // otherwise not guaranteed to be run before  unittest below
}
+/
проц ld_clearfpu()
{
    version(AsmX86)
    {
        asm  
        {
            fclex;
        }
    }
}


 // LDC: LLVM __asm is @system AND requires taking the address of variables

struct longdouble_soft
{
    // DMD's x87 `real` on Windows is packed (alignof = 2 -> sizeof = 10).
    align(2) бдол mantissa = 0xC000000000000000UL; // default to qnan
    ushort exp_sign = 0x7fff; // sign is highest bit

    this(бдол m, ushort es) { mantissa = m; exp_sign = es; }
    this(longdouble_soft ld) { mantissa = ld.mantissa; exp_sign = ld.exp_sign; }
    this(цел i) { ld_set(&this, i); }
    this(бцел i) { ld_set(&this, i); }
    this(long i) { ld_setll(&this, i); }
    this(бдол i) { ld_setull(&this, i); }
    this(float f) { ld_set(&this, f); }
    this(double d)
    {
        // allow нуль initialization at compile time
        if (__ctfe && d == 0)
        {
            mantissa = 0;
            exp_sign = 0;
        }
        else
            ld_set(&this, d);
    }
    this(real r)
    {
        static if (real.sizeof > 8)
            *cast(real*)&this = r;
        else
            this(cast(double)r);
    }

    ushort exponent(){ return exp_sign & 0x7fff; }
    бул sign(){ return (exp_sign & 0x8000) != 0; }

    extern(D)
    {
        longdouble_soft opAssign(longdouble_soft ld) { mantissa = ld.mantissa; exp_sign = ld.exp_sign; return this; }
        longdouble_soft opAssign(T)(T rhs) { this = longdouble_soft(rhs); return this; }

        longdouble_soft opUnary(ткст op)() 
        {
            static if (op == "-") return longdouble_soft(mantissa, exp_sign ^ 0x8000);
            else static assert(нет, "Operator `"~op~"` is not implemented");
        }

        бул opEquals(T)(T rhs){ return this.ld_cmpe(longdouble_soft(rhs)); }
        цел  opCmp(T)(T rhs){ return this.ld_cmp(longdouble_soft(rhs)); }

        longdouble_soft opBinary(ткст op, T)(T rhs) 
        {
            static if      (op == "+") return this.ld_add(longdouble_soft(rhs));
            else static if (op == "-") return this.ld_sub(longdouble_soft(rhs));
            else static if (op == "*") return this.ld_mul(longdouble_soft(rhs));
            else static if (op == "/") return this.ld_div(longdouble_soft(rhs));
            else static if (op == "%") return this.ld_mod(longdouble_soft(rhs));
            else static assert(нет, "Operator `"~op~"` is not implemented");
        }

        longdouble_soft opBinaryRight(ткст op, T)(T rhs) 
        {
            static if      (op == "+") return longdouble_soft(rhs).ld_add(this);
            else static if (op == "-") return longdouble_soft(rhs).ld_sub(this);
            else static if (op == "*") return longdouble_soft(rhs).ld_mul(this);
            else static if (op == "%") return longdouble_soft(rhs).ld_mod(this);
            else static assert(нет, "Operator `"~op~"` is not implemented");
        }

        longdouble_soft opOpAssign(ткст op)(longdouble_soft rhs)
        {
            mixin("this = this " ~ op ~ " rhs;");
            return this;
        }

        T opCast(T)() 
        {
            static      if (is(T == бул))   return mantissa != 0 || (exp_sign & 0x7fff) != 0;
            else static if (is(T == byte))   return cast(T)ld_read(&this);
            else static if (is(T == ббайт))  return cast(T)ld_read(&this);
            else static if (is(T == short))  return cast(T)ld_read(&this);
            else static if (is(T == ushort)) return cast(T)ld_read(&this);
            else static if (is(T == цел))    return cast(T)ld_read(&this);
            else static if (is(T == бцел))   return cast(T)ld_read(&this);
            else static if (is(T == float))  return cast(T)ld_read(&this);
            else static if (is(T == double)) return cast(T)ld_read(&this);
            else static if (is(T == long))   return ld_readll(&this);
            else static if (is(T == бдол))  return ld_readull(&this);
            else static if (is(T == real))
            {
                // convert to front end real if built with dmd
                if (real.sizeof > 8)
                    return *cast(real*)&this;
                else
                    return ld_read(&this);
            }
            else static assert(нет, "usupported тип");
        }
    }

    // a qnan
    static longdouble_soft nan() { return longdouble_soft(0xC000000000000000UL, 0x7fff); }
    static longdouble_soft infinity() { return longdouble_soft(0x8000000000000000UL, 0x7fff); }
    static longdouble_soft нуль() { return longdouble_soft(0, 0); }
    static longdouble_soft max() { return longdouble_soft(0xffffffffffffffffUL, 0x7ffe); }
    static longdouble_soft min_normal() { return longdouble_soft(0x8000000000000000UL, 1); }
    static longdouble_soft epsilon() { return longdouble_soft(0x8000000000000000UL, 0x3fff - 63); }

    static бцел dig() { return 18; }
    static бцел mant_dig() { return 64; }
    static бцел max_exp() { return 16384; }
    static бцел min_exp() { return -16381; }
    static бцел max_10_exp() { return 4932; }
    static бцел min_10_exp() { return -4932; }
}

static assert(longdouble_soft.alignof == longdouble.alignof);
static assert(longdouble_soft.sizeof == longdouble.sizeof);

version(LDC)
{
    import ldc.llvmasm;

    extern(D):
    private:
    ткст fld_arg  (ткст arg)() { return `__asm("fldt $0",  "*m,~{st}",  &` ~ arg ~ `);`; }
    ткст fstp_arg (ткст arg)() { return `__asm("fstpt $0", "=*m,~{st}", &` ~ arg ~ `);`; }
    ткст fld_parg (ткст arg)() { return `__asm("fldt $0",  "*m,~{st}",   ` ~ arg ~ `);`; }
    ткст fstp_parg(ткст arg)() { return `__asm("fstpt $0", "=*m,~{st}",  ` ~ arg ~ `);`; }
}
else version(D_InlineAsm_X86_64)
{
    // longdouble_soft passed by reference
    extern(D):
    private:
    ткст fld_arg(ткст arg)()
    {
        return "asm    { mov RAX, " ~ arg ~ "; fld real ptr [RAX]; }";
    }
    ткст fstp_arg(ткст arg)()
    {
        return "asm    { mov RAX, " ~ arg ~ "; fstp real ptr [RAX]; }";
    }
    alias  fld_arg fld_parg;
    alias  fstp_arg fstp_parg;
}
else version(D_InlineAsm_X86)
{
    // longdouble_soft passed by значение
    extern(D):
    private:
    ткст fld_arg(ткст arg)()
    {
        return "asm    { lea EAX, " ~ arg ~ "; fld real ptr [EAX]; }";
    }
    ткст fstp_arg(ткст arg)()
    {
        return "asm    { lea EAX, " ~ arg ~ "; fstp real ptr [EAX]; }";
    }
    ткст fld_parg(ткст arg)()
    {
        return "asm    { mov EAX, " ~ arg ~ "; fld real ptr [EAX]; }";
    }
    ткст fstp_parg(ткст arg)()
    {
        return "asm    { mov EAX, " ~ arg ~ "; fstp real ptr [EAX]; }";
    }
}

double ld_read( longdouble_soft* pthis)
{
    double res;
    version(AsmX86)
    {
        mixin(fld_parg!("pthis"));
        asm   
        {
            fstp res;
        }
    }
    return res;
}

long ld_readll( longdouble_soft* pthis)
{
    return ld_readull(pthis);
}

бдол ld_readull( longdouble_soft* pthis)
{
    // somehow the FPU does not respect the CHOP mode of the rounding control
    // in 64-bit mode
    // so we roll our own conversion (it also allows the usual C wrap-around
    // instead of the "invalid значение" created by the FPU)
    цел expo = pthis.exponent - 0x3fff;
    бдол u;
    if(expo < 0 || expo > 127)
        return 0;
    if(expo < 64)
        u = pthis.mantissa >> (63 - expo);
    else
        u = pthis.mantissa << (expo - 63);
    if(pthis.sign)
        u = ~u + 1;
    return u;
}

цел ld_statusfpu()
{
    цел res = 0;
    version(AsmX86)
    {
        asm   
        {
            fstsw word ptr [res];
        }
    }
    return res;
}

проц ld_set(longdouble_soft* pthis, double d)
{
    version(AsmX86)
    {
        asm   
        {
            fld d;
        }
        mixin(fstp_parg!("pthis"));
    }
}

проц ld_setll(longdouble_soft* pthis, long d)
{
    version(AsmX86)
    {
        asm   
        {
            fild qword ptr d;
        }
        mixin(fstp_parg!("pthis"));
    }
}

проц ld_setull(longdouble_soft* pthis, бдол d)
{
    d ^= (1L << 63);
    version(AsmX86)
    {
        auto pTwoPow63 = &twoPow63;
        mixin(fld_parg!("pTwoPow63"));
        asm   
        {
            fild qword ptr d;
            faddp;
        }
        mixin(fstp_parg!("pthis"));
    }
}

// using an argument as результат to avoid RVO, see https://issues.dlang.org/show_bug.cgi?ид=18758
longdouble_soft ldexpl(longdouble_soft ld, цел exp)
{
    version(AsmX86)
    {
        asm   
        {
            fild    dword ptr exp;
        }
        mixin(fld_arg!("ld"));
        asm   
        {
            fscale;                 // ST(0) = ST(0) * (2**ST(1))
            fstp    ST(1);
        }
        mixin(fstp_arg!("ld"));
    }
    return ld;
}

///////////////////////////////////////////////////////////////////////
longdouble_soft ld_add(longdouble_soft ld1, longdouble_soft ld2)
{
    version(AsmX86)
    {
        mixin(fld_arg!("ld1"));
        mixin(fld_arg!("ld2"));
        asm   
        {
            fadd;
        }
        mixin(fstp_arg!("ld1"));
    }
    return ld1;
}

longdouble_soft ld_sub(longdouble_soft ld1, longdouble_soft ld2)
{
    version(AsmX86)
    {
        mixin(fld_arg!("ld1"));
        mixin(fld_arg!("ld2"));
        asm   
        {
            fsub;
        }
        mixin(fstp_arg!("ld1"));
    }
    return ld1;
}

longdouble_soft ld_mul(longdouble_soft ld1, longdouble_soft ld2)
{
    version(AsmX86)
    {
        mixin(fld_arg!("ld1"));
        mixin(fld_arg!("ld2"));
        asm   
        {
            fmul;
        }
        mixin(fstp_arg!("ld1"));
    }
    return ld1;
}

longdouble_soft ld_div(longdouble_soft ld1, longdouble_soft ld2)
{
    version(AsmX86)
    {
        mixin(fld_arg!("ld1"));
        mixin(fld_arg!("ld2"));
        asm   
        {
            fdiv;
        }
        mixin(fstp_arg!("ld1"));
    }
    return ld1;
}

бул ld_cmpb(longdouble_soft x, longdouble_soft y)
{
    short sw;
    бул res;
    version(AsmX86)
    {
        mixin(fld_arg!("y"));
        mixin(fld_arg!("x"));
        asm   
        {
            fucomip ST(1);
            setb    AL;
            setnp   AH;
            and     AL,AH;
            mov     res,AL;
            fstp    ST(0);
        }
    }
    return res;
}

бул ld_cmpbe(longdouble_soft x, longdouble_soft y)
{
    short sw;
    бул res;
    version(AsmX86)
    {
        mixin(fld_arg!("y"));
        mixin(fld_arg!("x"));
        asm   
        {
            fucomip ST(1);
            setbe   AL;
            setnp   AH;
            and     AL,AH;
            mov     res,AL;
            fstp    ST(0);
        }
    }
    return res;
}

бул ld_cmpa(longdouble_soft x, longdouble_soft y)
{
    short sw;
    бул res;
    version(AsmX86)
    {
        mixin(fld_arg!("y"));
        mixin(fld_arg!("x"));
        asm   
        {
            fucomip ST(1);
            seta    AL;
            setnp   AH;
            and     AL,AH;
            mov     res,AL;
            fstp    ST(0);
        }
    }
    return res;
}

бул ld_cmpae(longdouble_soft x, longdouble_soft y)
{
    short sw;
    бул res;
    version(AsmX86)
    {
        mixin(fld_arg!("y"));
        mixin(fld_arg!("x"));
        asm   
        {
            fucomip ST(1);
            setae   AL;
            setnp   AH;
            and     AL,AH;
            mov     res,AL;
            fstp    ST(0);
        }
    }
    return res;
}

бул ld_cmpe(longdouble_soft x, longdouble_soft y)
{
    short sw;
    бул res;
    version(AsmX86)
    {
        mixin(fld_arg!("y"));
        mixin(fld_arg!("x"));
        asm   
        {
            fucomip ST(1);
            sete    AL;
            setnp   AH;
            and     AL,AH;
            mov     res,AL;
            fstp    ST(0);
        }
    }
    return res;
}

бул ld_cmpne(longdouble_soft x, longdouble_soft y)
{
    short sw;
    бул res;
    version(AsmX86)
    {
        mixin(fld_arg!("y"));
        mixin(fld_arg!("x"));
        asm   
        {
            fucomip ST(1);
            setne   AL;
            setp    AH;
            or      AL,AH;
            mov     res,AL;
            fstp    ST(0);
        }
    }
    return res;
}

цел ld_cmp(longdouble_soft x, longdouble_soft y)
{
    // return -1 if x < y, 0 if x == y or unordered, 1 if x > y
    short sw;
    цел res;
    version(AsmX86)
    {
        mixin(fld_arg!("y"));
        mixin(fld_arg!("x"));
        asm   
        {
            fucomip ST(1);
            seta    AL;
            setb    AH;
            setp    DL;
            or      AL, DL;
            or      AH, DL;
            sub     AL, AH;
            movsx   EAX, AL;
            fstp    ST(0);
            mov     res, EAX;
        }
    }
}


цел _isnan(longdouble_soft ld)
{
    return (ld.exponent == 0x7fff && ld.mantissa != 0 && ld.mantissa != (1L << 63)); // exclude pseudo-infinity and infinity, but not FP Indefinite
}

longdouble_soft fabsl(longdouble_soft ld)
{
    ld.exp_sign = ld.exponent;
    return ld;
}

longdouble_soft sqrtl(longdouble_soft ld)
{
    version(AsmX86)
    {
        mixin(fld_arg!("ld"));
        asm   
        {
            fsqrt;
        }
        mixin(fstp_arg!("ld"));
    }
    return ld;
}

longdouble_soft sqrt(longdouble_soft ld) { return sqrtl(ld); }

longdouble_soft sinl (longdouble_soft ld)
{
    version(AsmX86)
    {
        mixin(fld_arg!("ld"));
        asm   
        {
            fsin; // exact for |x|<=PI/4
        }
        mixin(fstp_arg!("ld"));
    }
    return ld;
}
longdouble_soft cosl (longdouble_soft ld)
{
    version(AsmX86)
    {
        mixin(fld_arg!("ld"));
        asm   
        {
            fcos; // exact for |x|<=PI/4
        }
        mixin(fstp_arg!("ld"));
    }
    return ld;
}
longdouble_soft tanl (longdouble_soft ld)
{
    version(AsmX86)
    {
        mixin(fld_arg!("ld"));
        asm   
        {
            fptan;
            fstp ST(0); // always 1
        }
        mixin(fstp_arg!("ld"));
    }
    return ld;
}

longdouble_soft fmodl(longdouble_soft x, longdouble_soft y)
{
    return ld_mod(x, y);
}

longdouble_soft ld_mod(longdouble_soft x, longdouble_soft y)
{
    short sw;
    version(AsmX86)
    {
        mixin(fld_arg!("y"));
        mixin(fld_arg!("x"));
        asm   
        {
        FM1:    // We don't use fprem1 because for some inexplicable
                // reason we get -5 when we do _modulo(15, 10)
            fprem;                          // ST = ST % ST1
            fstsw   word ptr sw;
            fwait;
            mov     AH,byte ptr sw+1;       // get msb of status word in AH
            sahf;                           // transfer to flags
            jp      FM1;                    // continue till ST < ST1
            fstp    ST(1);                  // leave remainder on stack
        }
        mixin(fstp_arg!("x"));
    }
    return x;
}

//////////////////////////////////////////////////////////////

/*::*/

 const
{
    longdouble_soft ld_qnan = longdouble_soft(0xC000000000000000UL, 0x7fff);
    longdouble_soft ld_inf  = longdouble_soft(0x8000000000000000UL, 0x7fff);

    longdouble_soft ld_zero  = longdouble_soft(0, 0);
    longdouble_soft ld_one   = longdouble_soft(0x8000000000000000UL, 0x3fff);
    longdouble_soft ld_pi    = longdouble_soft(0xc90fdaa22168c235UL, 0x4000);
    longdouble_soft ld_log2t = longdouble_soft(0xd49a784bcd1b8afeUL, 0x4000);
    longdouble_soft ld_log2e = longdouble_soft(0xb8aa3b295c17f0bcUL, 0x3fff);
    longdouble_soft ld_log2  = longdouble_soft(0x9a209a84fbcff799UL, 0x3ffd);
    longdouble_soft ld_ln2   = longdouble_soft(0xb17217f7d1cf79acUL, 0x3ffe);

    longdouble_soft ld_pi2     = longdouble_soft(0xc90fdaa22168c235UL, 0x4001);
    longdouble_soft ld_piOver2 = longdouble_soft(0xc90fdaa22168c235UL, 0x3fff);
    longdouble_soft ld_piOver4 = longdouble_soft(0xc90fdaa22168c235UL, 0x3ffe);

    longdouble_soft twoPow63 = longdouble_soft(1UL << 63, 0x3fff + 63);
}

//////////////////////////////////////////////////////////////

const LD_TYPE_OTHER    = 0;
const LD_TYPE_ZERO     = 1;
const LD_TYPE_INFINITE = 2;
const LD_TYPE_SNAN     = 3;
const LD_TYPE_QNAN     = 4;

цел ld_type(longdouble_soft x)
{
    // see https://en.wikipedia.org/wiki/Extended_precision
    if(x.exponent == 0)
        return x.mantissa == 0 ? LD_TYPE_ZERO : LD_TYPE_OTHER; // dnormal if not нуль
    if(x.exponent != 0x7fff)
        return LD_TYPE_OTHER;    // normal or denormal
    бцел  upper2  = x.mantissa >> 62;
    бдол lower62 = x.mantissa & ((1L << 62) - 1);
    if(upper2 == 0 && lower62 == 0)
        return LD_TYPE_INFINITE; // pseudo-infinity
    if(upper2 == 2 && lower62 == 0)
        return LD_TYPE_INFINITE; // infinity
    if(upper2 == 2 && lower62 != 0)
        return LD_TYPE_SNAN;
    return LD_TYPE_QNAN;         // qnan, indefinite, pseudo-nan
}

// consider sprintf 
private extern(C) цел sprintf(ткст0 s,  ткст0 format, ...)   ;

т_мера ld_sprint(ткст0 str, цел fmt, longdouble_soft x)
{
    // ensure dmc compatible strings for nan and inf
    switch(ld_type(x))
    {
        case LD_TYPE_QNAN:
        case LD_TYPE_SNAN:
            return sprintf(str, "nan");
        case LD_TYPE_INFINITE:
            return sprintf(str, x.sign ? "-inf" : "inf");
        default:
            break;
    }

    // fmt is 'a','A','f' or 'g'
    if(fmt != 'a' && fmt != 'A')
    {
        if (longdouble_soft(ld_readull(&x)) == x)
        {   // ((1.5 -> 1 -> 1.0) == 1.5) is нет
            // ((1.0 -> 1 -> 1.0) == 1.0) is да
            // see http://en.cppreference.com/w/cpp/io/c/fprintf
            сим[5] format = ['%', '#', 'L', cast(сим)fmt, 0];
            return sprintf(str, format.ptr, ld_read(&x));
        }
        сим[3] format = ['%', cast(сим)fmt, 0];
        return sprintf(str, format.ptr, ld_read(&x));
    }

    ushort exp = x.exponent;
    бдол mantissa = x.mantissa;

    if(ld_type(x) == LD_TYPE_ZERO)
        return sprintf(str, fmt == 'a' ? "0x0.0L" : "0X0.0L");

    т_мера len = 0;
    if(x.sign)
        str[len++] = '-';
    str[len++] = '0';
    str[len++] = cast(сим)('X' + fmt - 'A');
    str[len++] = mantissa & (1L << 63) ? '1' : '0';
    str[len++] = '.';
    mantissa = mantissa << 1;
    while(mantissa)
    {
        цел dig = (mantissa >> 60) & 0xf;
        dig += dig < 10 ? '0' : fmt - 10;
        str[len++] = cast(сим)dig;
        mantissa = mantissa << 4;
    }
    str[len++] = cast(сим)('P' + fmt - 'A');
    if(exp < 0x3fff)
    {
        str[len++] = '-';
        exp = cast(ushort)(0x3fff - exp);
    }
    else
    {
        str[len++] = '+';
        exp = cast(ushort)(exp - 0x3fff);
    }
    т_мера exppos = len;
    for(цел i = 12; i >= 0; i -= 4)
    {
        цел dig = (exp >> i) & 0xf;
        if(dig != 0 || len > exppos || i == 0)
            str[len++] = cast(сим)(dig + (dig < 10 ? '0' : fmt - 10));
    }
    str[len] = 0;
    return len;
}

//////////////////////////////////////////////////////////////

unittest
{
   // import core.stdc.ткст;
    //import core.stdc.stdio;

    сим[32] буфер;
    ld_sprint(буфер.ptr, 'a', ld_pi);
    assert(strcmp(буфер.ptr, "0x1.921fb54442d1846ap+1") == 0);

    ld_sprint(буфер.ptr, 'g', longdouble_soft(2.0));
    assert(strcmp(буфер.ptr, "2.00000") == 0);

    ld_sprint(буфер.ptr, 'g', longdouble_soft(1234567.89));
    assert(strcmp(буфер.ptr, "1.23457e+06") == 0);

    ld_sprint(буфер.ptr, 'g', ld_inf);
    assert(strcmp(буфер.ptr, "inf") == 0);

    ld_sprint(буфер.ptr, 'g', ld_qnan);
    assert(strcmp(буфер.ptr, "nan") == 0);

    longdouble_soft ldb = longdouble_soft(0.4);
    long b = cast(long)ldb;
    assert(b == 0);

    b = cast(long)longdouble_soft(0.9);
    assert(b == 0);

    long x = 0x12345678abcdef78L;
    longdouble_soft ldx = longdouble_soft(x);
    assert(ldx > ld_zero);
    long y = cast(long)ldx;
    assert(x == y);

    x = -0x12345678abcdef78L;
    ldx = longdouble_soft(x);
    assert(ldx < ld_zero);
    y = cast(long)ldx;
    assert(x == y);

    бдол u = 0x12345678abcdef78L;
    longdouble_soft ldu = longdouble_soft(u);
    assert(ldu > ld_zero);
    бдол v = cast(бдол)ldu;
    assert(u == v);

    u = 0xf234567812345678UL;
    ldu = longdouble_soft(u);
    assert(ldu > ld_zero);
    v = cast(бдол)ldu;
    assert(u == v);

    u = 0xf2345678;
    ldu = longdouble_soft(u);
    ldu = ldu * ldu;
    ldu = sqrt(ldu);
    v = cast(бдол)ldu;
    assert(u == v);

    u = 0x123456789A;
    ldu = longdouble_soft(u);
    ldu = ldu * longdouble_soft(1L << 23);
    v = cast(бдол)ldu;
    u = u * (1L << 23);
    assert(u == v);
}
