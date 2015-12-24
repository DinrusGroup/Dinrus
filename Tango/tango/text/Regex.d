﻿/*******************************************************************************

    copyright:      Copyright (c) 2007-2008 Jascha Wetzel. все rights reserved.

    license:        BSD стиль: $(LICENSE)

    version:        Initial release: Jan 2008

    authors:        Jascha Wetzel

    This is a regular expression compiler and interpreter based on the Tagged NFA/DFA метод.

    See <a href="http://en.wikИПedia.org/wiki/Regular_expression">Wikpedia's article on regular expressions</a>
    for details on regular expressions in general.

    The used метод implies, that the expressions are <i>regular</i>, in the way language theory defines it,
    as opposed в_ what &quot;regular expression&quot; means in most implementations
    (e.g. PCRE or those из_ the стандарт libraries of Perl, Java or Python).
    The advantage of this метод is it's performance, it's disadvantage is the inability в_ realize some features
    that Perl-like regular expressions have (e.g. back-references).
    See <a href="http://swtch.com/~rsc/regexp/regexp1.html">&quot;Regular Expression Matching Can Be Simple And Быстрый&quot;</a>
    for details on the differences.

    The время for matching a regular expression against an ввод ткст of length N is in O(M*N), where M depends on the
    число of matching brackets and the complexity of the expression. That is, M is constant wrt. the ввод
    and therefore matching is a linear-время process.

    The syntax of a regular expressions is as follows.
    <i>X</i> and <i>Y</i> stand for an arbitrary regular expression.

    <table border=1 cellspacing=0 cellpдобавьing=5>
    <caption>Operators</caption>
    $(TR $(TD X|Y) $(TD alternation, i.e. X or Y) )
    $(TR $(TD (X)) $(TD matching brackets - creates a sub-match) )
    $(TR $(TD (?X)) $(TD non-matching brackets - only groups X, no sub-match is создан) )
    $(TR $(TD [Z]) $(TD character class specification, Z is a ткст of characters or character ranges, e.g. [a-zA-Z0-9_.\-]) )
    $(TR $(TD [^Z]) $(TD negated character class specification) )
    $(TR $(TD &lt;X) $(TD lookbehind, X may be a single character or a character class) )
    $(TR $(TD &gt;X) $(TD lookahead, X may be a single character or a character class) )
    $(TR $(TD ^) $(TD старт of ввод or старт of строка) )
    $(TR $(TD $) $(TD конец of ввод or конец of строка) )
    $(TR $(TD \b) $(TD старт or конец of word, равно (?&lt;\s&gt;\S|&lt;\S&gt;\s)) )
    $(TR $(TD \B) $(TD opposite of \b, равно (?&lt;\S&gt;\S|&lt;\s&gt;\s)) )
    </table>

    <table border=1 cellspacing=0 cellpдобавьing=5>
    <caption>Quantifiers</caption>
    $(TR $(TD X?) $(TD zero or one) )
    $(TR $(TD X*) $(TD zero or ещё) )
    $(TR $(TD X+) $(TD one or ещё) )
    $(TR $(TD X{n,m}) $(TD at least n, at most m instances of X.<br>If n is missing, it's установи в_ 0.<br>If m is missing, it is установи в_ infinity.) )
    $(TR $(TD X??) $(TD non-greedy version of the above operators) )
    $(TR $(TD X*?) $(TD see above) )
    $(TR $(TD X+?) $(TD see above) )
    $(TR $(TD X{n,m}?) $(TD see above) )
    </table>

    <table border=1 cellspacing=0 cellpдобавьing=5>
    <caption>Pre-defined character classes</caption>
    $(TR $(TD .) $(TD any printable character) )
    $(TR $(TD \s) $(TD пробел) )
    $(TR $(TD \S) $(TD non-пробел) )
    $(TR $(TD \w) $(TD альфа-numeric characters or underscore) )
    $(TR $(TD \W) $(TD opposite of \w) )
    $(TR $(TD \d) $(TD digits) )
    $(TR $(TD \D) $(TD non-цифра) )
    </table>
*******************************************************************************/
module text.Regex;

debug(TangoRegex) import io.Stdout;

/* *****************************************************************************
    A simple pair
*******************************************************************************/
private struct Пара(T)
{
    static Пара opCall(T a, T b)
    {
        Пара p;
        p.a = a;
        p.b = b;
        return p;
    }

    union
    {
        struct {
            T first, сукунда;
        }
        struct {
            T a, b;
        }
    }
}

/* *****************************************************************************
    Double linked список
*******************************************************************************/
private class List(T)
{
    class Element
    {
        T значение;
        Element prev,
                следщ;

        this(T v)
        {
            значение = v;
        }
    }

    т_мера  длин;
    Element голова,
            хвост;

    List opCatAssign(T v)
    {
        if ( хвост is пусто )
            голова = хвост = new Element(v);
        else {
            хвост.следщ = new Element(v);
            хвост.следщ.prev = хвост;
            хвост = хвост.следщ;
        }
        ++длин;
        return this;
    }

    List insertAfter(T w, T v)
    {
        foreach ( e; &this.elements )
        {
            if ( e.значение is w )
                return insertAfter(e, v);
        }
        return пусто;
    }

    List insertAfter(Element e, T v)
    {
        auto врем = new Element(v);
        врем.prev = e;
        врем.следщ = e.следщ;
        e.следщ.prev = врем;
        e.следщ = врем;
        if ( e is хвост )
            хвост = врем;
        ++длин;
        return this;
    }

    List opCatAssign(List l)
    {
        if ( l.пустой )
            return this;
        if ( хвост is пусто ) {
            голова = l.голова;
            хвост = l.хвост;
        }
        else {
            хвост.следщ = l.голова;
            хвост.следщ.prev = хвост;
            хвост = l.хвост;
        }
        длин += l.длин;
        return this;
    }

    List pushFront(T v)
    {
        if ( голова is пусто )
            голова = хвост = new Element(v);
        else
        {
            голова.prev = new Element(v);
            голова.prev.следщ = голова;
            голова = голова.prev;
        }
        ++длин;
        return this;
    }

    List insertBefore(T w, T v)
    {
        foreach ( e; &this.elements )
        {
            if ( e.значение is w )
                return insertBefore(e, v);
        }
        return пусто;
    }

    List insertBefore(Element e, T v)
    {
        auto врем = new Element(v);
        врем.prev = e.prev;
        врем.следщ = e;
        e.prev.следщ = врем;
        e.prev = врем;
        if ( e is голова )
            голова = врем;
        ++длин;
        return this;
    }

    List pushFront(List l)
    {
        if ( l.пустой )
            return this;
        if ( голова is пусто ) {
            голова = l.голова;
            хвост = l.хвост;
        }
        else {
            голова.prev = l.хвост;
            голова.prev.следщ = голова;
            голова = l.голова;
        }
        длин += l.длин;
        return this;
    }

    т_мера length()
    {
        return длин;
    }

    бул пустой()
    {
        return голова is пусто;
    }

    проц сотри()
    {
        голова = пусто;
        хвост = пусто;
        длин = 0;
    }

    проц вынь()
    {
        удали(хвост);
    }

    проц удали(Element e)
    {
        if ( e is пусто )
            return;
        if ( e.prev is пусто )
            голова = e.следщ;
        else
            e.prev.следщ = e.следщ;
        if ( e.следщ is пусто )
            хвост = e.prev;
        else
            e.следщ.prev = e.prev;
        --длин;
    }

    цел elements(цел delegate(ref Element) дг)
    {
        for ( Element e=голова; e !is пусто; e = e.следщ )
        {
            цел ret = дг(e);
            if ( ret )
                return ret;
        }
        return 0;
    }

    цел элементы_реверс(цел delegate(ref Element) дг)
    {
        for ( Element e=хвост; e !is пусто; e = e.prev )
        {
            цел ret = дг(e);
            if ( ret )
                return ret;
        }
        return 0;
    }

    цел opApply(цел delegate(ref T) дг)
    {
        for ( Element e=голова; e !is пусто; e = e.следщ )
        {
            цел ret = дг(e.значение);
            if ( ret )
                return ret;
        }
        return 0;
    }

    цел opApplyReverse(цел delegate(ref T) дг)
    {
        for ( Element e=хвост; e !is пусто; e = e.prev )
        {
            цел ret = дг(e.значение);
            if ( ret )
                return ret;
        }
        return 0;
    }
}

/* *****************************************************************************
    Stack based on dynamic Массив
*******************************************************************************/
private struct Stack(T)
{
    т_мера  _top;
    T[]     stack;

    проц push(T v)
    {
        if ( _top >= stack.length )
            stack.length = stack.length*2+1;
        stack[_top] = v;
        ++_top;
    }
    alias push opCatAssign;

    проц opCatAssign(T[] vs)
    {
        т_мера конец = _top+vs.length;
        if ( конец > stack.length )
            stack.length = конец*2;
        stack[_top..конец] = vs;
        _top = конец;
    }

    проц вынь(т_мера num)
    {
        assert(_top>=num);
        _top -= num;
    }

    T вынь()
    {
        assert(_top>0);
        return stack[--_top];
    }

    T top()
    {
        assert(_top>0);
        return stack[_top-1];
    }

    T* укзНаВерх()
    {
        assert(_top>0);
        return &stack[_top-1];
    }

    бул пустой()
    {
        return _top == 0;
    }

    проц сотри()
    {
        _top = 0;
    }

    т_мера length()
    {
        return _top;
    }

    T[] Массив()
    {
        return stack[0.._top];
    }

    T opIndex(т_мера i)
    {
        return stack[i];
    }

    Stack dup()
    {
        Stack s;
        s._top = _top;
        s.stack = stack.dup;
        return s;
    }
}

/* ************************************************************************************************
    Набор container based on assoc Массив
**************************************************************************************************/
private struct Набор(T)
{
    бул[T] данные;

    static Набор opCall()
    {
        Набор s;
        return s;
    }

    static Набор opCall(T v)
    {
        Набор s;
        s ~= v;
        return s;
    }

    проц opAddAssign(T v)
    {
        данные[v] = да;
    }

    проц opAddAssign(Набор s)
    {
        foreach ( v; s.elements )
            данные[v] = да;
    }
    alias opAddAssign opCatAssign;

    т_мера length()
    {
        return данные.length;
    }

    T[] elements()
    {
        return данные.ключи;
    }

    бул удали(T v)
    {
        if ( (v in данные) is пусто )
            return нет;
        данные.удали(v);
        return да;
    }

    бул содержит(T v)
    {
        return (v in данные) !is пусто;
    }

    бул содержит(Набор s)
    {
        Набор врем = s - *this;
        return врем.пустой;
    }

    бул пустой()
    {
        return данные.length==0;
    }

    Набор opSub(Набор s)
    {
        Набор рез = dup;
        foreach ( v; s.elements )
            рез.удали(v);
        return рез;
    }

    Набор dup()
    {
        Набор s;
        foreach ( v; данные.ключи )
            s.данные[v] = да;
        return s;
    }
}

/* ************************************************************************************************

**************************************************************************************************/
проц быстрСорт(T)(T[] a)
{
    быстрСорт(a,cast(т_мера)0,a.length);
}

проц быстрСорт(T)(T[] a, т_мера l, т_мера r)
{
    T t;
    auto i = r-l;
    if ( i < 3 )
    {
        if ( i < 2 )
            return;
        if ( a[l] < a[l+1] )
            return;
        t = a[l];
        a[l] = a[l+1];
        a[l+1] = t;
        return;
    }

    auto p = a[l];
    i = l;
    auto j = r;

    while ( да )
    {
        ++i;
        for ( ; i < j && a[i] < p; ++i ) {}
        --j;
        for ( ; i < j && a[j] >= p; --j ) {}
        if ( i >= j )
            break;
        t = a[i];
        a[i] = a[j];
        a[j] = t;
    }
    --i;
    a[l] = a[i];
    a[i] = p;

    быстрСорт(a, l, i);
    быстрСорт(a, i+1, r);
}
import math.Math;

/* ************************************************************************************************
    A range of characters
**************************************************************************************************/
struct ДиапазонСимволов(т_сим)
{
    т_сим  l_, r_;

    static ДиапазонСимволов opCall(т_сим c)
    {
        ДиапазонСимволов cr;
        cr.l_ = c;
        cr.r_ = c;
        return cr;
    }

    static ДиапазонСимволов opCall(т_сим a, т_сим b)
    {
        ДиапазонСимволов cr;
        cr.l_ = min(a,b);
        cr.r_ = max(a,b);
        return cr;
    }

    т_сим l()
    {
        return l_;
    }

    т_сим r()
    {
        return r_;
    }

    /* ********************************************************************************************
        Compares the ranges according в_ their beginning.
    **********************************************************************************************/
    цел opCmp(ДиапазонСимволов cr)
    {
        if ( l_ == cr.l_ )
            return 0;
        if ( l_ < cr.l_ )
            return -1;
        return 1;
    }

    цел opEquals(ДиапазонСимволов cr)
    {
        if ( l_ == cr.l_ && r_ == cr.r_ )
            return 1;
        return 0;
    }

    бул содержит(т_сим c)
    {
        return c >= l_ && c <= r_;
    }

    бул содержит(ДиапазонСимволов cr)
    {
        return l_ <= cr.l_ && r_ >= cr.r_;
    }

    бул пересекает(ДиапазонСимволов cr)
    {
        return r_ >= cr.l_ && l_ <= cr.r_;
    }

    ДиапазонСимволов пересечение(ДиапазонСимволов cr)
    {
        assert(пересекает(cr));
        ДиапазонСимволов ir;
        ir.l_ = max(l_, cr.l_);
        ir.r_ = min(r_, cr.r_);
        if ( ir.l_ > ir.r_ )
            ir.l_ = ir.r_ = т_сим.min;
        return ir;
    }

    ДиапазонСимволов[] вычти(ДиапазонСимволов cr)
    {
        ДиапазонСимволов[] sr;
        if ( cr.содержит(*this) )
            return sr;
        if ( !пересекает(cr) )
            sr ~= *this;
        else
        {
            ДиапазонСимволов d;
            if ( содержит(cr) )
            {
                d.l_ = l_;
                d.r_ = cr.l_-1;
                if ( d.l_ <= d.r_ )
                    sr ~= d;
                d.l_ = cr.r_+1;
                d.r_ = r_;
                if ( d.l_ <= d.r_ )
                    sr ~= d;
            }
            else if ( cr.r_ > l_ )
            {
                d.l_ = cr.r_+1;
                d.r_ = r_;
                if ( d.l_ <= d.r_ )
                    sr ~= d;
            }
            else if ( cr.l_ < r_ )
            {
                d.l_ = l_;
                d.r_ = cr.l_-1;
                if ( d.l_ <= d.r_ )
                    sr ~= d;
            }
        }
        return sr;
    }

    ткст вТкст()
    {
        ткст ткт;
        if ( l_ == r_ )
        {
            if ( l_ > 0x20 && l_ < 0x7f )
                ткт = Формат.преобразуй("'{}'", l_);
            else
                ткт = Формат.преобразуй("({:x})", cast(цел)l_);
        }
        else
        {
            if ( l_ > 0x20 && l_ < 0x7f )
                ткт = Формат.преобразуй("'{}'", l_);
            else
                ткт = Формат.преобразуй("({:x})", cast(цел)l_);
            ткт ~= "-";
            if ( r_ > 0x20 && r_ < 0x7f )
                ткт ~= Формат.преобразуй("'{}'", r_);
            else
                ткт ~= Формат.преобразуй("({:x})", cast(цел)r_);
        }
        return ткт;
    }
}

/* ************************************************************************************************
    Represents a class of characters as used in regular expressions (e.g. [0-9a-z], etc.)
**************************************************************************************************/
struct КлассСимволов(т_сим)
{
    alias ДиапазонСимволов!(т_сим) т_диапазон;

    //---------------------------------------------------------------------------------------------
    // pre-defined character classes
    static const КлассСимволов!(т_сим)
        начкон_стр = {части: [
            {l_:0x00, r_:0x00},
            {l_:0x0a, r_:0x0a},
            {l_:0x13, r_:0x13}
        ]},
        цифра = {части: [
            {l_:0x30, r_:0x39}
        ]},
        пробел = {части: [
            {l_:0x09, r_:0x09},
            {l_:0x0a, r_:0x0a},
            {l_:0x0b, r_:0x0b},
            {l_:0x13, r_:0x13},
            {l_:0x14, r_:0x14},
            {l_:0x20, r_:0x20}
        ]};

    // 8bit classes
    static if ( is(т_сим == сим) )
    {
        static const КлассСимволов!(т_сим)
            any_char = {части: [
                {l_:0x01, r_:0xff}
            ]},
            dot_oper = {части: [
                {l_:0x09, r_:0x13},   // basic control chars
                {l_:0x20, r_:0x7e},   // basic latin
                {l_:0xa0, r_:0xff}    // latin-1 supplement
            ]},
            alphanum_ = {части: [
                {l_:0x30, r_:0x39},
                {l_:0x41, r_:0x5a},
                {l_:0x5f, r_:0x5f},
                {l_:0x61, r_:0x7a}
            ]};
    }
    // 16bit and 32bit classes
    static if ( is(т_сим == шим) || is(т_сим == дим) )
    {
        static const КлассСимволов!(т_сим)
            any_char = {части: [
                {l_:0x0001, r_:0xffff}
            ]},
            dot_oper = {части: [
                {l_:0x09,r_:0x13},{l_:0x20, r_:0x7e},{l_:0xa0, r_:0xff},
                {l_:0x0100, r_:0x017f},   // latin extended a
                {l_:0x0180, r_:0x024f},   // latin extended b
                {l_:0x20a3, r_:0x20b5},   // currency symbols
            ]},
            alphanum_ = {части: [
                {l_:0x30, r_:0x39},
                {l_:0x41, r_:0x5a},
                {l_:0x5f, r_:0x5f},
                {l_:0x61, r_:0x7a}
            ]};
    }

    //---------------------------------------------------------------------------------------------
    т_диапазон[] части;

    invariant()
    {
//        foreach ( i, p; части )
//            assert(p.l_<=p.r_, Int.вТкст(i)~": "~Int.вТкст(p.l_)~" > "~Int.вТкст(p.r_));
    }

    static КлассСимволов opCall(КлассСимволов cc)
    {
        КлассСимволов ncc;
        ncc.части = cc.части.dup;
        return ncc;
    }

    цел opCmp(КлассСимволов cc)
    {
        if ( части.length < cc.части.length )
            return -1;
        if ( части.length > cc.части.length )
            return 1;
        foreach ( i, p; cc.части )
        {
            if ( p.l_ != части[i].l_ || p.r_ != части[i].r_ )
                return 1;
        }
        return 0;
    }

    бул пустой()
    {
        return части.length <= 0;
    }

    бул matches(т_сим c)
    {
        foreach ( p; части )
        {
            if ( p.содержит(c) )
                return да;
        }
        return нет;
    }

    КлассСимволов пересечение(КлассСимволов cc)
    {
        КлассСимволов ic;
        foreach ( p; части )
        {
            foreach ( cp; cc.части )
            {
                if ( p.пересекает(cp) )
                    ic.части ~= p.пересечение(cp);
            }
        }
        return ic;
    }

    // requires the class в_ be optimized
    бул содержит(т_диапазон cr)
    {
        foreach ( p; части )
        {
            if ( p.содержит(cr) )
                return да;
        }
        return нет;
    }

    // requires the class в_ be optimized
    бул содержит(КлассСимволов cc)
    {
        Louter: foreach ( p; cc.части )
        {
            foreach ( p2; части )
            {
                if ( p2.содержит(p) )
                    continue Louter;
            }
            return нет;
        }
        return да;
    }

    проц вычти(КлассСимволов cc)
    {
        negate;
        добавь(cc);
        negate;
    }

    проц добавь(КлассСимволов cc)
    {
        части ~= cc.части;
    }

    проц добавь(т_диапазон cr)
    {
        части ~= cr;
    }

    проц добавь(т_сим c)
    {
        части ~= ДиапазонСимволов!(т_сим)(c);
    }

    /* ********************************************************************************************
        Requires the КлассСимволов в_ be optimized.
    **********************************************************************************************/
    проц negate()
    {
        оптимизируй;
        т_сим  старт = т_сим.min;

        // first часть touches left boundary of значение range
        if ( части.length > 0 && части[0].l_ == старт )
        {
            старт = части[0].r_;
            if ( старт < т_сим.max )
                ++старт;

            foreach ( i, ref cr; части[0 .. $-1] )
            {
                cr.l_ = старт;
                cr.r_ = части[i+1].l_-1;
                старт = части[i+1].r_;
                if ( старт < т_сим.max )
                    ++старт;
            }
            if ( старт != т_сим.max ) {
                части[$-1].l_ = старт;
                части[$-1].r_ = т_сим.max;
            }
            else
                части.length = части.length-1;
            return;
        }

        foreach ( i, ref cr; части )
        {
            т_сим врем = cr.l_-1;
            cr.l_ = старт;
            старт = cr.r_;
            if ( старт < т_сим.max )
                ++старт;
            cr.r_ = врем;
        }

        // последний часть does not touch right boundary
        if ( старт != т_сим.max )
            части ~= т_диапазон(старт, т_сим.max);
    }

    проц оптимизируй()
    {
        if ( пустой )
            return;

        части.сортируй;

        т_мера i = 0;
        foreach ( p; части[1 .. $] )
        {
            if ( p.l_ > части[i].r_+1 ) {
                ++i;
                части[i].l_ = p.l_;
                части[i].r_ = p.r_;
                continue;
            }
            части[i].r_ = max(p.r_, части[i].r_);
            if ( части[i].r_ >= т_сим.max )
                break;
        }
        части.length = i+1;
    }

    ткст вТкст()
    {
        ткст ткт;
        ткт ~= "[";
        foreach ( p; части )
            ткт ~= p.вТкст;
        ткт ~= "]";
        return ткт;
    }
}

debug(UnitTest)
{
unittest
{
    static КлассСимволов!(сим) cc = { части: [{l_:0,r_:10},{l_:0,r_:6},{l_:5,r_:12},{l_:12,r_:17},{l_:20,r_:100}] };
    assert(cc.вТкст, "[(0)-(a)(0)-(6)(5)-(c)(c)-(11)(14)-'d']");
    cc.оптимизируй;
    assert(cc.вТкст,  "[(0)-(11)(14)-'d']");
    cc.negate;
    assert(cc.вТкст,  " [(12)-(13)'e'-(ff)]");
    cc.оптимизируй;
    assert(cc.вТкст,  "[(0)-(11)(14)-'d']");
    cc.negate;
    assert(cc.вТкст,  "[(12)-(13)'e'-(ff)]");
    
    static КлассСимволов!(сим) cc2 = { части: [] };
    assert(cc.вТкст,  "[]");
    cc2.оптимизируй;
    assert(cc.вТкст,  "[]");
    cc2.negate;
    assert(cc.вТкст,  "[(0)-(ff)]");
    cc2.оптимизируй;
    assert(cc.вТкст,  "[(0)-(ff)]");
    cc2.negate;
    assert(cc.вТкст,  "[]");
    
    static КлассСимволов!(сим) cc3 = { части: [{l_:0,r_:100},{l_:200,r_:0xff},] };
    assert(cc3.вТкст, "[(0)-'d'(c8)-(ff)]");
    cc3.negate;
    assert(cc.вТкст,  "['e'-(c7)]");
    cc3.negate;
    assert(cc.вТкст,  "[(0)-'d'(c8)-(ff)]");
    
    static КлассСимволов!(сим) cc4 = { части: [{l_:0,r_:200},{l_:100,r_:0xff},] };
    assert(cc.вТкст,  "[(0)-(c8)'d'-(ff)]");
    cc4.оптимизируй;
    assert(cc.вТкст,  "[(9)-(13)(20)-'~'(a0)-(ff)(100)-(17f)(180)-(24f)(20a3)-(20b5)]");
    
    static КлассСимволов!(дим) cc5 = { части: [{l_:0x9,r_:0x13},{0x20,r_:'~'},{l_:0xa0,r_:0xff},{l_:0x100,r_:0x17f},{l_:0x180,r_:0x24f},{l_:0x20a3,r_:0x20b5}] };
    cc5.оптимизируй;
    assert(cc.вТкст,  "[(9)-(13)(20)-'~'(a0)-(24f)(20a3)-(20b5)]");
    cc5.negate;
    assert(cc.вТкст,  "[(0)-(8)(14)-(1f)(7f)-(9f)(250)-(20a2)(20b6)-(10ffff)]");
    cc5.оптимизируй;
    assert(cc.вТкст,  "[(0)-(8)(14)-(1f)(7f)-(9f)(250)-(20a2)(20b6)-(10ffff)]");
    cc5.negate;
    assert(cc.вТкст,  "[(9)-(13)(20)-'~'(a0)-(24f)(20a3)-(20b5)]");
}
}

/* ************************************************************************************************

**************************************************************************************************/
private struct Predicate(т_сим)
{
    alias т_ткст              т_ткст;
    alias КлассСимволов!(т_сим)    т_кс;
    alias ДиапазонСимволов!(т_сим)    т_дс;

    // generic данные
    enum Тип {
        используй, epsilon, lookahead, lookbehind
    }

    т_кс    ввод;
    Тип    тип;

    // данные for compiled predicates
    const бцел  MAX_BITMAP_LENGTH = 256,
                MAX_SEARCдлина = 256;
    enum MatchMode {
        generic, generic_l,
        single_char, bitmap, string_search,         // используй
        single_char_l, bitmap_l, string_search_l    // lookahead
    }

    MatchMode   режим;
    // data_chr had в_ be pulled out of the union due в_
    // http://d.puremagic.com/issues/show_bug.cgi?опр=2632 --- don't помести it back
    // in until this is resolved!
    //
    // Keep in mind that data_str.length can't be изменён directly unless the
    // new length is strictly greater than the old length. This is essentially
    // because ббайт.sizeof can be less than т_сим.sizeof. If you установи
    // data_str.length в_ anything less than or equal в_ data_bmp.length,
    // data_str will not be reallocated: only the length значение will change but
    // nothing will realize that not that much пространство есть actually been
    // allocated. data_str will be too small and you'll likely получи segfaults or
    // such.
    //
    // In крат: don't mess with data_str.length. If you have в_, удали the
    // union entirely.
    //
    // -- Deewiant
    union {
        ббайт[]     data_bmp;
        т_ткст    data_str;
    };
    т_сим      data_chr;


    проц компилируй()
    {
        assert(ввод.части.length > 0);

        // single сим?
        if ( ввод.части.length == 1 && ввод.части[0].l_ == ввод.части[0].r_ )
        {
            режим = тип==Тип.используй ? MatchMode.single_char : MatchMode.single_char_l;
            data_chr = ввод.части[0].l_;
            return;
        }
        // check whether we can use a bitmap
        foreach ( p; ввод.части )
        {
            if ( p.l_ > MAX_BITMAP_LENGTH || p.r_ > MAX_BITMAP_LENGTH )
                goto LnoBitmap;
        }

        // установи bitmap
        data_bmp.length = MAX_BITMAP_LENGTH/8;
        foreach ( p; ввод.части )
        {
            for ( т_сим c = p.l_; c <= p.r_; ++c )
                data_bmp[c/8] |= 1 << (c&7);
        }
        режим = тип==Тип.используй ? MatchMode.bitmap : MatchMode.bitmap_l;
        return;

    LnoBitmap:
/*
        // check whether the class is small enough в_ justify a ткст-search
        // TODO: consопрer inverse class for 8bit chars?
        бцел class_size;
        foreach ( p; ввод.части )
            class_size += cast(бцел)p.r_+1-p.l_;
        if ( class_size > MAX_SEARCдлина )
            goto Lgeneric;
        data_str.length = class_size;
        т_мера ind;
        foreach ( p; ввод.части )
        {
            for ( т_сим c = p.l_; c <= p.r_; ++c )
                data_str[ind++] = c;
        }
        режим = тип==Тип.используй ? MatchMode.string_search : MatchMode.string_search_l;
        return;
*/
    Lgeneric:
        data_str = cast(т_ткст)ввод.части;
        режим = тип==Тип.используй ? MatchMode.generic : MatchMode.generic_l;
    }

    бул matches(т_сим c)
    {
        if ( тип == Тип.используй || тип == Тип.lookahead )
            return ввод.matches(c);
        assert(0);
    }

    Predicate пересечение(Predicate p)
    {
        Predicate p2;
        if ( тип != Тип.epsilon && p.тип != Тип.epsilon )
            p2.ввод = ввод.пересечение(p.ввод);
        return p2;
    }

    бул пересекает(Predicate p)
    {
        if ( тип != p.тип )
            return нет;
        foreach ( cr; ввод.части )
        {
            foreach ( cr2; p.ввод.части )
            {
                if ( cr.пересекает(cr2) )
                    return да;
            }
        }
        return нет;
    }

    бул превышаетМакс(бцел maxc)
    {
        foreach ( p; ввод.части )
        {
            if ( p.l_ > maxc || p.r_ > maxc )
                return да;
        }

        return нет;
    }

    бул пустой()
    {
        return тип != Тип.epsilon && ввод.пустой;
    }

    проц вычти(Predicate p)
    {
        if ( тип != Тип.epsilon && p.тип != Тип.epsilon )
            ввод.вычти(p.ввод);
    }

    проц negate()
    {
        assert(тип != Тип.epsilon);
        ввод.negate;
    }

    проц оптимизируй()
    {
        assert(тип != Тип.epsilon);
        ввод.оптимизируй;
    }

    цел opCmp(Predicate p)
    {
        return ввод.opCmp(p.ввод);
    }

    цел opEquals(Predicate p)
    {
        if ( тип != p.тип )
            return 0;
        if ( ввод.opCmp(p.ввод) != 0 )
            return 0;
        return 1;
    }

    т_кс дайВвод()
    {
        return ввод;
    }

    проц установиВвод(т_кс cc)
    {
        ввод = cc;
    }

    проц добавьВвод(т_дс cr)
    {
        ввод.добавь(cr);
    }

    проц добавьВвод(т_кс cc)
    {
        ввод.добавь(cc);
    }

    проц добавьВвод(Predicate p)
    {
        ввод.добавь(p.ввод);
    }

    ткст вТкст()
    {
        ткст ткт;
        switch ( тип )
        {
            case Тип.используй:      ткт = ввод.вТкст;       break;
            case Тип.epsilon:      ткт = "eps";                break;
            case Тип.lookahead:    ткт = "la:"~ввод.вТкст; break;
            case Тип.lookbehind:   ткт = "lb:"~ввод.вТкст; break;
            default:
                assert(0);
        }
        return ткт;
    }
}
import Utf = text.convert.Utf;
import text.convert.Format;

/* ************************************************************************************************

**************************************************************************************************/
class ИсклРегВыр : Исключение
{
    this(ткст сооб)
    {
        super("RegExp: "~сооб);
    }
}

/* ************************************************************************************************
    TNFA состояние
**************************************************************************************************/
private class TNFAState(т_сим)
{
    бул    прими = нет,
            visited = нет;
    бцел    индекс;
    List!(TNFATransition!(т_сим))  transitions;

    this()
    {
        transitions = new List!(TNFATransition!(т_сим));
    }
}


/* ************************************************************************************************
    Priority classes used в_ linearize priorities after non-linear transition creation.
**************************************************************************************************/
private enum PriorityClass {
    greedy=0, нормаль=1, reluctant=2, extraReluctant=3
}

/* ********************************************************************************
    TNFA tagged transition
***********************************************************************************/
private class TNFATransition(т_сим)
{
    TNFAState!(т_сим)  мишень;
    Predicate!(т_сим)  predicate;
    бцел                priority,
                        тэг;        /// one-based тэг число, 0 = untagged
    PriorityClass       priorityClass;

    this(PriorityClass pc)
    {
        priorityClass = pc;
    }

    /******************************************************************************
        Move through states only going via epsilon transitions, and only choosing
        the one with highest priority. If the highest priority transition из_ a 
        состояние isn't an epsilon transition, нет is returned. 
        If the accepting NFA состояние can be reached in this manner, да is returned. 

        NOTE: This метод does not look for cycles which should be kept in mind for
        later. larsivi 20090827
    *******************************************************************************/
    бул canFinish()
    {
        TNFAState!(т_сим)  t = мишень;
        while (!t.прими) {
            TNFATransition!(т_сим) highestPriTrans;
            foreach (trans; t.transitions) {
                if (!highestPriTrans || highestPriTrans.priority > trans.priority)
                    highestPriTrans = trans;
            }
            if (!(highestPriTrans.predicate.тип == Predicate!(т_сим).Тип.epsilon))
                return нет;
            
            t = highestPriTrans.мишень;
        }
        return да;
    }

}

/* ************************************************************************************************
    Fragments of TNFAs as used in the Thompson метод
**************************************************************************************************/
private class TNFAFragment(т_сим)
{
    alias TNFAState!(т_сим)        state_t;
    alias TNFATransition!(т_сим)   trans_t;

    List!(trans_t)  записи,        /// transitions в_ be добавьed в_ the Запись состояние
                    exits,          /// transitions в_ be добавьed в_ the exit состояние
                    entry_state,    /// transitions в_ пиши the Запись состояние в_
                    exit_state;     /// transitions в_ пиши the exit состояние в_

    бул свопMatchingBracketSyntax;

    this()
    {
        записи     = new List!(trans_t);
        exits       = new List!(trans_t);
        entry_state = new List!(trans_t);
        exit_state  = new List!(trans_t);
    }

    /* ********************************************************************************************
        Write the given состояние as Запись состояние в_ this fragment.
    **********************************************************************************************/
    проц setEntry(state_t состояние)
    {
        состояние.transitions ~= записи;
        foreach ( t; entry_state )
            t.мишень = состояние;
    }

    /* ********************************************************************************************
        Write the given состояние as exit состояние в_ this fragment.
    **********************************************************************************************/
    проц setExit(state_t состояние)
    {
        состояние.transitions ~= exits;
        foreach ( t; exit_state )
            t.мишень = состояние;
    }
}

/* ************************************************************************************************
    Tagged NFA
**************************************************************************************************/
private final class TNFA(т_сим)
{
    alias TNFATransition!(т_сим)   trans_t;
    alias TNFAFragment!(т_сим)     frag_t;
    alias TNFAState!(т_сим)        state_t;
    alias Predicate!(т_сим)        predicate_t;
    alias т_ткст                  т_ткст;
    alias ДиапазонСимволов!(т_сим)        т_диапазон;
    alias КлассСимволов!(т_сим)        т_кс;

    т_ткст    образец;
    state_t[]   states;
    state_t     старт;

    бул свопMatchingBracketSyntax; /// whether в_ сделай (?...) matching and (...) non-matching

    /* ********************************************************************************************
        Creates the TNFA из_ the given regex образец
    **********************************************************************************************/
    this(т_ткст regex)
    {
        next_tag        = 1;
        transitions     = new List!(trans_t);

        образец = regex;
    }

    /* ********************************************************************************************
        Print the TNFA (tabular representation of the delta function)
    **********************************************************************************************/
    debug(TangoRegex) проц выведи()
    {
        foreach ( цел i, s; states )
        {
            Стдвыв.форматируй("{}{:d2}{}", s is старт?">":" ", i, s.прими?"*":" ");

            бул first=да;
            Стдвыв(" {");
            foreach ( t; s.transitions )
            {
                Стдвыв.форматируй("{}{}{}:{}->{}", first?"":", ", t.priority, "gnrx"[t.priorityClass], t.predicate.вТкст, t.мишень is пусто?-1:t.мишень.индекс);
                if ( t.тэг > 0 ) {
                    Стдвыв.форматируй(" t{}", t.тэг);
                }
                first = нет;
            }
            Стдвыв("}").нс;
        }
    }

    бцел tagCount()
    {
        return next_tag-1;
    }

    /* ********************************************************************************************
        Constructs the TNFA using extended Thompson метод.
        Uses a slightly extended version of Dijkstra's shunting yard algorithm в_ преобразуй
        the regexp из_ infix notation.
    **********************************************************************************************/
    проц разбор(бул unanchored)
    {
        List!(frag_t)       frags       = new List!(frag_t);
        Stack!(Operator)    opStack;
        Stack!(бцел)        tagStack;
        Stack!(Пара!(бцел)) occurStack;
        opStack ~= Operator.eos;

        /* ****************************************************************************************
            Perform action on operator stack
        ******************************************************************************************/
        бул perform(Operator next_op, бул explicit_operator=да)
        {
            // calculate индекс in action matrix
            цел индекс = cast(цел)opStack.top*(Operator.max+1);
            индекс += cast(цел)next_op;

            debug(tnfa) Стдвыв.форматнс("\t{}:{} -> {}  {} frag(s)",
                operator_names[opStack.top], operator_names[next_op], action_names[action_lookup[индекс]], frags.length
            );
            switch ( action_lookup[индекс] )
            {
                case Act.pua:
                    opStack ~= next_op;
                    if ( next_op == Operator.open_par ) {
                        tagStack ~= next_tag;
                        next_tag += 2;
                    }
                    break;
                case Act.poc:
                    switch ( opStack.top )
                    {
                        case Operator.concat:       constructConcat(frags);                             break;
                        case Operator.altern:       constructAltern(frags);                             break;
                        case Operator.zero_one_g:   constructZeroOne(frags, PriorityClass.greedy);      break;
                        case Operator.zero_one_ng:  constructZeroOne(frags, PriorityClass.reluctant);   break;
                        case Operator.zero_one_xr:  constructZeroOne(frags, PriorityClass.extraReluctant);  break;
                        case Operator.zero_more_g:  constructZeroMore(frags, PriorityClass.greedy);     break;
                        case Operator.zero_more_ng: constructZeroMore(frags, PriorityClass.reluctant);  break;
                        case Operator.zero_more_xr: constructZeroMore(frags, PriorityClass.extraReluctant); break;
                        case Operator.one_more_g:   constructOneMore(frags, PriorityClass.greedy);      break;
                        case Operator.one_more_ng:  constructOneMore(frags, PriorityClass.reluctant);   break;
                        case Operator.one_more_xr:  constructOneMore(frags, PriorityClass.extraReluctant);  break;
                        case Operator.occur_g:
                            Пара!(бцел) occur = occurStack.вынь;
                            constructOccur(frags, occur.a, occur.b, PriorityClass.greedy);
                            break;
                        case Operator.occur_ng:
                            Пара!(бцел) occur = occurStack.вынь;
                            constructOccur(frags, occur.a, occur.b, PriorityClass.reluctant);
                            break;
                        default:
                            throw new ИсклРегВыр("cannot process operand at \""~Utf.вТкст(образец[cursor..$])~"\"");
                    }
                    opStack.вынь;

                    perform(next_op, нет);
                    break;
                case Act.poa:
                    opStack.вынь;
                    break;
                case Act.pca:
                    if ( opStack.top == Operator.open_par )
                    {
                        if ( tagStack.пустой )
                            throw new ИсклРегВыр(Формат.преобразуй("Missing opening parentheses for closing parentheses at сим {} \"{}\"", cursor, Utf.вТкст(образец[cursor..$])));
                        constructBracket(frags, tagStack.top);
                        tagStack.вынь;
                    }
                    else {
                        assert(opStack.top == Operator.open_par_nm);
                        constructBracket(frags);
                    }
                    opStack.вынь;
                    break;
                case Act.don:
                    return да;
                case Act.err:
                default:
                    throw new ИсклРегВыр(Формат.преобразуй("Unexpected operand at сим {} \"{}\" in \"{}\"", cursor, Utf.вТкст(образец[cursor..$]), Utf.вТкст(образец)));
            }

            return нет;
        }

        // добавь implicit extra reluctant .* (with . == any_char) at the beginning for unanchored matches
        // and matching bracket for total match группа
        if ( unanchored ) {
            frags ~= constructChars(т_кс.any_char, predicate_t.Тип.используй);
            perform(Operator.zero_more_xr, нет);
            perform(Operator.concat, нет);
            perform(Operator.open_par, нет);
        }

        // преобразуй regex в_ postfix and создай TNFA
        бул implicit_concat;
        predicate_t.Тип pred_type;

        while ( !endOfPattern )
        {
            pred_type = predicate_t.Тип.используй;

            дим c = readPattern;
            switch ( c )
            {
                case '|':
                    perform(Operator.altern);
                    implicit_concat = нет;
                    break;
                case '(':
                    if ( implicit_concat )
                        perform(Operator.concat, нет);
                    implicit_concat = нет;
                    if ( ПросмотрPattern == '?' ) {
                        readPattern;
                        perform(свопMatchingBracketSyntax?Operator.open_par:Operator.open_par_nm);
                    }
                    else
                        perform(свопMatchingBracketSyntax?Operator.open_par_nm:Operator.open_par);
                    break;
                case ')':
                    perform(Operator.close_par);
                    break;
                case '?':
                    if ( ПросмотрPattern == '?' ) {
                        readPattern;
                        perform(Operator.zero_one_ng);
                    }
                    else
                        perform(Operator.zero_one_g);
                    break;
                case '*':
                    if ( ПросмотрPattern == '?' ) {
                        readPattern;
                        perform(Operator.zero_more_ng);
                    }
                    else
                        perform(Operator.zero_more_g);
                    break;
                case '+':
                    if ( ПросмотрPattern == '?' ) {
                        readPattern;
                        perform(Operator.one_more_ng);
                    }
                    else
                        perform(Operator.one_more_g);
                    break;
                case '{':
                    Пара!(бцел) occur;
                    parseOccurCount(occur.a, occur.b);
                    occurStack ~= occur;
                    if ( ПросмотрPattern == '?' ) {
                        readPattern;
                        perform(Operator.occur_ng);
                    }
                    else
                        perform(Operator.occur_g);
                    break;
                case '[':
                    if ( implicit_concat )
                        perform(Operator.concat, нет);
                    implicit_concat = да;
                    frags ~= constructCharClass(pred_type);
                    break;
                case '.':
                    if ( implicit_concat )
                        perform(Operator.concat, нет);
                    implicit_concat = да;
                    frags ~= constructChars(т_кс.dot_oper, pred_type);
                    break;
                case '$':
                    if ( implicit_concat )
                        perform(Operator.concat, нет);
                    implicit_concat = да;

                    frags ~= constructChars(т_кс.начкон_стр, predicate_t.Тип.lookahead);
                    break;
                case '^':
                    if ( implicit_concat )
                        perform(Operator.concat, нет);
                    implicit_concat = да;

                    frags ~= constructChars(т_кс.начкон_стр, predicate_t.Тип.lookbehind);
                    break;
                case '>':
                    c = readPattern;
                    pred_type = predicate_t.Тип.lookahead;
                    if ( c == '[' )
                        goto case '[';
                    else if ( c == '\\' )
                        goto case '\\';
                    else if ( c == '.' )
                        goto case '.';
                    else
                        goto default;
                case '<':
                    c = readPattern;
                    pred_type = predicate_t.Тип.lookbehind;
                    if ( c == '[' )
                        goto case '[';
                    else if ( c == '\\' )
                        goto case '\\';
                    else if ( c == '.' )
                        goto case '.';
                    else
                        goto default;
                case '\\':
                    c = readPattern;

                    if ( implicit_concat )
                        perform(Operator.concat, нет);
                    implicit_concat = да;

                    switch ( c )
                    {
                        case 't':
                            frags ~= constructSingleChar('\t', pred_type);
                            break;
                        case 'n':
                            frags ~= constructSingleChar('\n', pred_type);
                            break;
                        case 'r':
                            frags ~= constructSingleChar('\r', pred_type);
                            break;
                        case 'w':   // alphanumeric and _
                            frags ~= constructChars(т_кс.alphanum_, pred_type);
                            break;
                        case 'W':   // non-(alphanum and _)
                            auto cc = т_кс(т_кс.alphanum_);
                            cc.negate;
                            frags ~= constructChars(cc, pred_type);
                            break;
                        case 's':   // пробел
                            frags ~= constructChars(т_кс.пробел, pred_type);
                            break;
                        case 'S':   // non-пробел
                            auto cc = т_кс(т_кс.пробел);
                            cc.negate;
                            frags ~= constructChars(cc, pred_type);
                            break;
                        case 'd':   // цифра
                            frags ~= constructChars(т_кс.цифра, pred_type);
                            break;
                        case 'D':   // non-цифра
                            auto cc = т_кс(т_кс.цифра);
                            cc.negate;
                            frags ~= constructChars(cc, pred_type);
                            break;
                        case 'b':   // either конец of word
                            if ( pred_type != predicate_t.Тип.используй )
                                throw new ИсклРегВыр("Escape sequence \\b not allowed in look-ahead or -behind");

                            // создай (?<\S>\s|<\s>\S)
                            auto cc = т_кс(т_кс.пробел);
                            cc.negate;

                            perform(Operator.open_par_nm);

                            frags ~= constructChars(cc, predicate_t.Тип.lookbehind);
                            perform(Operator.concat, нет);
                            frags ~= constructChars(т_кс.пробел, predicate_t.Тип.lookahead);
                            perform(Operator.altern, нет);
                            frags ~= constructChars(т_кс.пробел, predicate_t.Тип.lookbehind);
                            perform(Operator.concat, нет);
                            frags ~= constructChars(cc, predicate_t.Тип.lookahead);

                            perform(Operator.close_par, нет);
                            break;
                        case 'B':   // neither конец of word
                            if ( pred_type != predicate_t.Тип.используй )
                                throw new ИсклРегВыр("Escape sequence \\B not allowed in look-ahead or -behind");

                            // создай (?<\S>\S|<\s>\s)
                            auto cc = т_кс(т_кс.пробел);
                            cc.negate;

                            perform(Operator.open_par_nm);

                            frags ~= constructChars(cc, predicate_t.Тип.lookbehind);
                            perform(Operator.concat, нет);
                            frags ~= constructChars(cc, predicate_t.Тип.lookahead);
                            perform(Operator.altern, нет);
                            frags ~= constructChars(т_кс.пробел, predicate_t.Тип.lookbehind);
                            perform(Operator.concat, нет);
                            frags ~= constructChars(т_кс.пробел, predicate_t.Тип.lookahead);

                            perform(Operator.close_par, нет);
                            break;
                        case '(':
                        case ')':
                        case '[':
                        case ']':
                        case '{':
                        case '}':
                        case '*':
                        case '+':
                        case '?':
                        case '.':
                        case '\\':
                        case '^':
                        case '$':
                        case '|':
                        case '<':
                        case '>':
                        default:
                            frags ~= constructSingleChar(c, pred_type);
                            break;
//                            throw new ИсклРегВыр(Формат.преобразуй("Unknown escape sequence \\{}", c));
                    }
                    break;

                default:
                    if ( implicit_concat )
                        perform(Operator.concat, нет);
                    implicit_concat = да;
                    frags ~= constructSingleChar(c, pred_type);
            }
        }

        // добавь implicit reluctant .* (with . == any_char) at the конец for unanchored matches
        if ( unanchored )
        {
            perform(Operator.close_par, нет);
            if ( implicit_concat )
                perform(Operator.concat, нет);
            frags ~= constructChars(т_кс.any_char, predicate_t.Тип.используй);
            perform(Operator.zero_more_ng, нет);
        }

        // пустой operator stack
        while ( !perform(Operator.eos) ) {}

        // установи старт and финиш states
        старт = добавьСостояние;
        state_t финиш = добавьСостояние;
        финиш.прими = да;

        foreach ( f; frags ) {
            f.setExit(финиш);
            f.setEntry(старт);
        }

        // установи transition priorities
        List!(trans_t)[PriorityClass.max+1] trans;
        foreach ( ref t; trans )
            t = new List!(trans_t);

        Stack!(trans_t) todo;
        state_t состояние = старт;

        while ( !todo.пустой || !состояние.visited )
        {
            if ( !состояние.visited )
            {
                состояние.visited = да;
                foreach_reverse ( t; состояние.transitions )
                    todo ~= t;
            }

            if ( todo.пустой )
                break;
            trans_t t = todo.top;
            todo.вынь;
            assert(t.priorityClass<=PriorityClass.max);
            trans[t.priorityClass] ~= t;
            состояние = t.мишень;
        }

        бцел nextPrio;
        foreach ( ts; trans )
        {
            foreach ( t; ts )
                t.priority = nextPrio++;
        }
    }

private:
    бцел            next_tag;
    т_мера          cursor,
                    next_cursor;
    List!(trans_t)  transitions;

    state_t[state_t]    clonedStates;
    trans_t[trans_t]    clonedTransitions;

    /// RegEx operators
    enum Operator {
        eos, concat, altern, open_par, close_par,
        zero_one_g, zero_more_g, one_more_g,        // greedy
        zero_one_ng, zero_more_ng, one_more_ng,     // non-greedy/reluctant
        zero_one_xr, zero_more_xr, one_more_xr,     // extra-reluctant
        open_par_nm, occur_g, occur_ng
    }
    const ткст[] operator_names = ["EOS", "concat", "|", "(", ")", "?", "*", "+", "??", "*?", "+?", "??x", "*?x", "+?x", "(?", "{x,y}", "{x,y}?"];

    /// Actions for в_-postfix transformation
    enum Act {
        pua, poc, poa, pca, don, err
    }
    const ткст[] action_names = ["push+advance", "вынь+копируй", "вынь+advance", "вынь+копируй+advance", "готово", "ошибка"];

    /// Action отыщи for в_-postfix transformation
    const Act[] action_lookup =
    [
    //  eos      concat   |        (        )        ?        *        +        ??       *?       +?       ??extra  *?extra  +?extra  (?       {x,y}    {x,y}?
        Act.don, Act.pua, Act.pua, Act.pua, Act.err, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua,
        Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua,
        Act.poc, Act.pua, Act.poc, Act.pua, Act.poc, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua,
        Act.err, Act.pua, Act.pua, Act.pua, Act.pca, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua,
        Act.err, Act.err, Act.err, Act.err, Act.err, Act.err, Act.err, Act.err, Act.err, Act.err, Act.err, Act.err, Act.err, Act.err, Act.err, Act.err, Act.err,
        Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc,
        Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc,
        Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc,
        Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc,
        Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc,
        Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc,
        Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc,
        Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc,
        Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc,
        Act.err, Act.pua, Act.pua, Act.pua, Act.pca, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua, Act.pua,
        Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc,
        Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.poc, Act.pua, Act.poc, Act.poc
    ];

    final дим ПросмотрPattern()
    {
        auto врем = next_cursor;
        if ( врем < образец.length )
            return раскодируй(образец, врем);
        return 0;
    }

    final дим readPattern()
    {
        cursor = next_cursor;
        if ( next_cursor < образец.length )
            return раскодируй(образец, next_cursor);
        return 0;
    }

    final бул endOfPattern()
    {
        return next_cursor >= образец.length;
    }

    state_t добавьСостояние()
    {
        state_t s = new state_t;
        s.индекс = states.length;
        states ~= s;
        return s;
    }

    trans_t добавьПроход(PriorityClass pc = PriorityClass.нормаль)
    {
        trans_t trans = new trans_t(pc);
        transitions ~= trans;
        return trans;
    }

    бцел parseNumber()
    {
        бцел рез;
        while ( !endOfPattern )
        {
            auto c = ПросмотрPattern;
            if ( c < '0' || c > '9' )
                break;
            рез = рез*10+(c-'0');
            readPattern;
        }
        return рез;
    }

    проц parseOccurCount(out бцел minOccur, out бцел maxOccur)
    {
        assert(образец[cursor] == '{');

        minOccur = parseNumber;
        if ( ПросмотрPattern == '}' ) {
            readPattern;
            maxOccur = minOccur;
            return;
        }
        if ( ПросмотрPattern != ',' )
            throw new ИсклРегВыр("Invalid occurence range at \""~Utf.вТкст(образец[cursor..$])~"\"");
        readPattern;
        maxOccur = parseNumber;
        if ( ПросмотрPattern != '}' )
            throw new ИсклРегВыр("Invalid occurence range at \""~Utf.вТкст(образец[cursor..$])~"\"");
        readPattern;
        if ( maxOccur > 0 && maxOccur < minOccur )
            throw new ИсклРегВыр("Invalid occurence range (max < min) at \""~Utf.вТкст(образец[cursor..$])~"\"");
    }

    trans_t clone(trans_t t)
    {
        if ( t is пусто )
            return пусто;
        trans_t* врем = t in clonedTransitions;
        if ( врем !is пусто )
            return *врем;

        trans_t t2 = new trans_t(t.priorityClass);
        clonedTransitions[t] = t2;
        t2.тэг = t.тэг;
        t2.priority = t.priority;
        t2.predicate = t.predicate;
        t2.мишень = clone(t.мишень);
        transitions ~= t2;
        return t2;
    }

    state_t clone(state_t s)
    {
        if ( s is пусто )
            return пусто;
        state_t* врем = s in clonedStates;
        if ( врем !is пусто )
            return *врем;

        state_t s2 = new state_t;
        clonedStates[s] = s2;
        s2.прими = s.прими;
        s2.visited = s.visited;
        foreach ( t; s.transitions )
            s2.transitions ~= clone(t);
        s2.индекс = states.length;
        states ~= s2;
        return s2;
    }

    frag_t clone(frag_t f)
    {
        if ( f is пусто )
            return пусто;
        clonedStates = пусто;
        clonedTransitions = пусто;

        frag_t f2 = new frag_t;
        foreach ( t; f.записи )
            f2.записи ~= clone(t);
        foreach ( t; f.exits )
            f2.exits ~= clone(t);
        foreach ( t; f.entry_state )
            f2.entry_state ~= clone(t);
        foreach ( t; f.exit_state )
            f2.exit_state ~= clone(t);
        return f2;
    }

    //---------------------------------------------------------------------------------------------
    // Thompson constructions of NFA fragments

    frag_t constructSingleChar(т_сим c, predicate_t.Тип тип)
    {
        debug(tnfa) Стдвыв.форматнс("constructCharFrag {}", c);

        trans_t trans = добавьПроход;
        trans.predicate.добавьВвод(ДиапазонСимволов!(т_сим)(c));

        trans.predicate.тип = тип;

        frag_t frag = new frag_t;
        frag.exit_state ~= trans;
        frag.записи    ~= trans;
        return frag;
    }

    frag_t constructChars(т_ткст chars, predicate_t.Тип тип)
    {
        т_кс cc;
        for ( цел i = 0; i < chars.length; ++i )
            cc.добавь(chars[i]);

        return constructChars(cc, тип);
    }

    frag_t constructChars(т_кс charclass, predicate_t.Тип тип)
    {
        debug(tnfa) Стдвыв.форматируй("constructChars тип={}", тип);

        trans_t trans = добавьПроход;
        trans.predicate.тип = тип;

        trans.predicate.установиВвод(т_кс(charclass));

        trans.predicate.оптимизируй;
        debug(tnfa) Стдвыв.форматнс("-> {}", trans.predicate.вТкст);

        frag_t frag = new frag_t;
        frag.exit_state ~= trans;
        frag.записи    ~= trans;
        return frag;
    }

    frag_t constructCharClass(predicate_t.Тип тип)
    {
        debug(tnfa) Стдвыв.форматируй("constructCharClass тип={}", тип);
        auto oldCursor = cursor;

        trans_t trans = добавьПроход;

        бул negated=нет;
        if ( ПросмотрPattern == '^' ) {
            readPattern;
            negated = да;
        }

        т_сим  последний;
        бул    have_range_start,
                first_char = да;
        for ( ; !endOfPattern && ПросмотрPattern != ']'; )
        {
            дим c = readPattern;
            switch ( c )
            {
                case '-':
                    if ( first_char ) {
                        trans.predicate.добавьВвод(т_диапазон(c));
                        break;
                    }
                    if ( !have_range_start )
                        throw new ИсклРегВыр("Missing range старт for '-' operator after \""~Utf.вТкст(образец)~"\"");
                    else if ( endOfPattern || ПросмотрPattern == ']' )
                        throw new ИсклРегВыр("Missing range конец for '-' operator after \""~Utf.вТкст(образец)~"\"");
                    else {
                        c = readPattern;
                        trans.predicate.добавьВвод(т_диапазон(последний, c));
                        have_range_start = нет;
                    }
                    break;
                case '\\':
                    if ( endOfPattern )
                        throw new ИсклРегВыр("unexpected конец of ткст after \""~Utf.вТкст(образец)~"\"");
                    c = readPattern;
                    switch ( c )
                    {
                        case 't':
                            c = '\t';
                            break;
                        case 'n':
                            c = '\n';
                            break;
                        case 'r':
                            c = '\r';
                            break;
                        default:
                            break;
                    }
                default:
                    if ( have_range_start )
                        trans.predicate.добавьВвод(т_диапазон(последний));
                    последний = c;
                    have_range_start = да;
            }
            first_char = нет;
        }
        if ( !endOfPattern )
            readPattern;
        if ( последний != т_сим.init )
            trans.predicate.добавьВвод(т_диапазон(последний));
        debug(tnfa) Стдвыв.форматнс(" {}", образец[oldCursor..cursor]);

        if ( negated ) {
            auto врем = т_кс(т_кс.any_char);
            врем.вычти(trans.predicate.ввод);
            trans.predicate.ввод = врем;
        }
        else
            trans.predicate.оптимизируй;
        debug(tnfa) Стдвыв.форматнс("-> {}", trans.predicate.вТкст);

        trans.predicate.тип = тип;

        frag_t frag = new frag_t;
        frag.exit_state ~= trans;
        frag.записи    ~= trans;
        return frag;
    }

    проц constructBracket(List!(frag_t) frags, бцел тэг=0)
    {
        debug(tnfa) Стдвыв.форматнс("constructBracket");

        state_t Запись = добавьСостояние,
                exit = добавьСостояние;
        frags.хвост.значение.setEntry(Запись);
        frags.хвост.значение.setExit(exit);

        trans_t tag1 = добавьПроход,
                tag2 = добавьПроход;
        tag1.predicate.тип = predicate_t.Тип.epsilon;
        tag2.predicate.тип = predicate_t.Тип.epsilon;
        if ( тэг > 0 )
        {
            // сделай sure the тэг indeces for bracket x are always
            // x*2 for the opening bracket and x*2+1 for the closing bracket
            tag1.тэг = тэг++;
            tag2.тэг = тэг;
        }
        tag1.мишень = Запись;
        exit.transitions ~= tag2;

        frag_t frag = new frag_t;
        frag.записи ~= tag1;
        frag.exit_state ~= tag2;
        frags.вынь;
        frags ~= frag;
    }

    проц constructOneMore(List!(frag_t) frags, PriorityClass prioClass)
    {
        debug(tnfa) Стдвыв.форматнс("constructOneMore");

        if ( frags.пустой )
            throw new ИсклРегВыр("too few аргументы for + at \""~Utf.вТкст(образец[cursor..$])~"\"");

        trans_t repeat = добавьПроход(prioClass),
                cont = добавьПроход;
        repeat.predicate.тип = predicate_t.Тип.epsilon;
        cont.predicate.тип = predicate_t.Тип.epsilon;

        state_t s = добавьСостояние;
        frags.хвост.значение.setExit(s);
        s.transitions ~= repeat;
        s.transitions ~= cont;

        frag_t frag = new frag_t;
        frag.записи ~= frags.хвост.значение.записи;
        frag.entry_state ~= frags.хвост.значение.entry_state;
        frag.entry_state ~= repeat;
        frag.exit_state ~= cont;
        frags.вынь;
        frags ~= frag;
    }

    проц constructZeroMore(List!(frag_t) frags, PriorityClass prioClass)
    {
        debug(tnfa) Стдвыв.форматнс("constructZeroMore");

        if ( frags.пустой )
            throw new ИсклРегВыр("too few аргументы for * at \""~Utf.вТкст(образец[cursor..$])~"\"");

        trans_t enter = добавьПроход(prioClass),
                repeat = добавьПроход(prioClass),
                пропусти = добавьПроход;
        пропусти.predicate.тип = predicate_t.Тип.epsilon;
        repeat.predicate.тип = predicate_t.Тип.epsilon;
        enter.predicate.тип = predicate_t.Тип.epsilon;

        state_t Запись = добавьСостояние,
                exit = добавьСостояние;
        frags.хвост.значение.setEntry(Запись);
        frags.хвост.значение.setExit(exit);
        exit.transitions ~= repeat;
        enter.мишень = Запись;

        frag_t frag = new frag_t;
        frag.записи ~= пропусти;
        frag.записи ~= enter;
        frag.exit_state ~= пропусти;
        frag.entry_state ~= repeat;
        frags.вынь;
        frags ~= frag;
    }

    проц constructZeroOne(List!(frag_t) frags, PriorityClass prioClass)
    {
        debug(tnfa) Стдвыв.форматнс("constructZeroOne");

        if ( frags.пустой )
            throw new ИсклРегВыр("too few аргументы for ? at \""~Utf.вТкст(образец[cursor..$])~"\"");

        trans_t use = добавьПроход(prioClass),
                пропусти = добавьПроход;
        use.predicate.тип = predicate_t.Тип.epsilon;
        пропусти.predicate.тип = predicate_t.Тип.epsilon;

        state_t s = добавьСостояние;
        frags.хвост.значение.setEntry(s);
        use.мишень = s;

        frag_t frag = new frag_t;
        frag.записи ~= use;
        frag.записи ~= пропусти;
        frag.exits ~= frags.хвост.значение.exits;
        frag.exit_state ~= frags.хвост.значение.exit_state;
        frag.exit_state ~= пропусти;
        frags.вынь;
        frags ~= frag;
    }

    проц constructOccur(List!(frag_t) frags, бцел minOccur, бцел maxOccur, PriorityClass prioClass)
    {
        debug(tnfa) Стдвыв.форматнс("constructOccur {},{}", minOccur, maxOccur);

        if ( frags.пустой )
            throw new ИсклРегВыр("too few аргументы for {x,y} at \""~Utf.вТкст(образец[cursor..$])~"\"");

        state_t s;
        frag_t  total = new frag_t,
                prev;

        for ( цел i = 0; i < minOccur; ++i )
        {
            frag_t f = clone(frags.хвост.значение);
            if ( prev !is пусто ) {
                s = добавьСостояние;
                prev.setExit(s);
                f.setEntry(s);
            }
            else {
                total.записи = f.записи;
                total.entry_state = f.entry_state;
            }
            prev = f;
        }

        if ( maxOccur == 0 )
        {
            frag_t f = frags.хвост.значение;
            trans_t t = добавьПроход;
            t.predicate.тип = predicate_t.Тип.epsilon;
            f.записи ~= t;
            f.exit_state ~= t;

            t = добавьПроход;
            t.predicate.тип = predicate_t.Тип.epsilon;
            f.exits ~= t;
            f.entry_state ~= t;

            s = добавьСостояние;
            f.setEntry(s);

            if ( prev !is пусто )
                prev.setExit(s);
            else {
                total.записи = f.записи;
                total.entry_state = f.entry_state;
            }

            prev = f;
        }

        for ( цел i = minOccur; i < maxOccur; ++i )
        {
            frag_t f;
            if ( i < maxOccur-1 )
                f = clone(frags.хвост.значение);
            else
                f = frags.хвост.значение;
            trans_t t = добавьПроход;
            t.predicate.тип = predicate_t.Тип.epsilon;
            f.записи ~= t;
            f.exit_state ~= t;

            if ( prev !is пусто ) {
                s = добавьСостояние;
                prev.setExit(s);
                f.setEntry(s);
            }
            else {
                total.записи = f.записи;
                total.entry_state = f.entry_state;
            }
            prev = f;
        }

        total.exits = prev.exits;
        total.exit_state = prev.exit_state;

        frags.вынь;
        frags ~= total;
    }

    проц constructAltern(List!(frag_t) frags)
    {
        debug(tnfa) Стдвыв.форматнс("constructAltern");

        if ( frags.пустой || frags.голова is frags.хвост )
            throw new ИсклРегВыр("too few аргументы for | at \""~Utf.вТкст(образец[cursor..$])~"\"");

        frag_t  frag = new frag_t,
                f1 = frags.хвост.значение,
                f2 = frags.хвост.prev.значение;
        frag.entry_state ~= f2.entry_state;
        frag.entry_state ~= f1.entry_state;
        frag.exit_state ~= f2.exit_state;
        frag.exit_state ~= f1.exit_state;
        frag.записи ~= f2.записи;
        frag.записи ~= f1.записи;
        frag.exits ~= f2.exits;
        frag.exits ~= f1.exits;

        frags.вынь;
        frags.вынь;
        frags ~= frag;
    }

    проц constructConcat(List!(frag_t) frags)
    {
        debug(tnfa) Стдвыв.форматнс("constructConcat");

        if ( frags.пустой || frags.голова is frags.хвост )
            throw new ИсклРегВыр("too few operands for concatenation at \""~Utf.вТкст(образец[cursor..$])~"\"");

        frag_t  f1 = frags.хвост.значение,
                f2 = frags.хвост.prev.значение;

        state_t состояние = добавьСостояние;
        f2.setExit(состояние);
        f1.setEntry(состояние);

        frag_t frag = new frag_t;
        frag.записи ~= f2.записи;
        frag.exits ~= f1.exits;
        frag.entry_state ~= f2.entry_state;
        frag.exit_state ~= f1.exit_state;
        frags.вынь;
        frags.вынь;
        frags ~= frag;
    }
}
import core.Array;

/* ************************************************************************************************
    Tagged DFA
**************************************************************************************************/
private class TDFA(т_сим)
{
    alias Predicate!(т_сим)    predicate_t;
    alias ДиапазонСимволов!(т_сим)    т_диапазон;
    alias КлассСимволов!(т_сим)    charclass_t;
    alias т_ткст              т_ткст;

    const бцел CURRENT_POSITION_REGISTER = ~0;

    /* ********************************************************************************************
        Tag карта assignment команда
    **********************************************************************************************/
    struct Command
    {
        бцел        приёмн,    /// регистрируй индекс в_ recieve данные
                    ист;    /// регистрируй индекс or CURRENT_POSITION_REGISTER for current позиция

        ткст вТкст()
        {
            return Формат.преобразуй("{}<-{}", приёмн, ист==CURRENT_POSITION_REGISTER?"p":Формат.преобразуй("{}", ист));
        }

        /* ****************************************************************************************
            Order transitions by the order of their predicates.
        ******************************************************************************************/
        цел opCmp(Command cmd)
        {
            if ( ист == CURRENT_POSITION_REGISTER && cmd.ист != CURRENT_POSITION_REGISTER )
                return 1;
            if ( ист != CURRENT_POSITION_REGISTER && cmd.ист == CURRENT_POSITION_REGISTER )
                return -1;
            if ( приёмн < cmd.приёмн )
                return -1;
            if ( приёмн == cmd.приёмн )
                return 0;
            return 1;
        }

        цел opEquals(Command cmd)
        {
            if ( приёмн != cmd.приёмн || ист != cmd.ист )
                return 0;
            return 1;
        }
    }

    struct TagIndex
    {
        бцел    тэг,
                индекс;
    }

    /* ********************************************************************************************
        TDFA состояние
    **********************************************************************************************/
    class Состояние
    {
        enum Mode {
            GENERIC, MIXED, LOOKUP
        }

        const бцел  LOOKUP_LENGTH = 256,
                    INVALID_STATE = 255;

        бул            прими = нет;
        бул            reluctant = нет;
        бцел            индекс;
        Transition[]    transitions,
                        generic_transitions;
        Command[]       finishers;

        ббайт[]         отыщи;
        Mode            режим;

        проц оптимизируй()
        {
            // merge transitions with equal targets (same состояние индекс and equal commands)
            т_мера[] remove_indeces;
            foreach ( i, t; transitions[0 .. $-1] )
            {
                foreach ( t2; transitions[i+1 .. $] )
                {
                    if ( t.predicate.тип != t2.predicate.тип || !t.equalTarget(t2) )
                        continue;
                    t2.predicate.добавьВвод(t.predicate);
                    remove_indeces ~= i;
                    break;
                }
            }

            // удали transitions that have been merged преобр_в другой
            if ( remove_indeces.length > 0 )
            {
                Transition[] врем;
                врем.length = transitions.length - remove_indeces.length;
                т_мера next_remove, следщ;
                foreach ( i, t; transitions )
                {
                    if ( next_remove < remove_indeces.length && remove_indeces[next_remove] == i ) {
                        ++next_remove;
                        continue;
                    }
                    врем[следщ++] = t;
                }
                transitions = врем;

                foreach ( t; transitions )
                    t.predicate.оптимизируй;
            }
        }

        проц createLookup()
        {
            т_мера счёт;
            foreach ( t; transitions )
            {
                if ( !t.predicate.превышаетМакс(LOOKUP_LENGTH) )
                    ++счёт;
            }

            if ( счёт < 1 || transitions.length > INVALID_STATE ) {
                generic_transitions.length = transitions.length;
                generic_transitions[] = transitions;
                return;
            }

            foreach ( t; transitions )
            {
                if ( t.predicate.превышаетМакс(LOOKUP_LENGTH) )
                    generic_transitions ~= t;
            }

            // установи отыщи table
            отыщи.length = LOOKUP_LENGTH;
            отыщи[] = INVALID_STATE;
            foreach ( i, t; transitions )
            {
                foreach ( p; t.predicate.ввод.части )
                {
                    if ( p.l_ >= отыщи.length )
                        continue;
                    for ( т_сим c = p.l_; c <= min(p.r_, LOOKUP_LENGTH-1); ++c )
                        отыщи[c] = cast(ббайт)i;
                }
            }

            режим = счёт < transitions.length? Mode.MIXED : Mode.LOOKUP;
        }
    }

    /* ********************************************************************************************
        TDFA transition
    **********************************************************************************************/
    class Transition
    {
        Состояние       мишень;
        predicate_t predicate;
        Command[]   commands;

        /* ****************************************************************************************
            Order transitions by the order of their predicates.
        ******************************************************************************************/
        final цел opCmp(Объект o)
        {
            Transition t = cast(Transition)o;
            assert(t !is пусто);
            return predicate.opCmp(t.predicate);
        }

        final цел opEquals(Объект o)
        {
            auto t = cast(Transition)o;
            if ( t is пусто )
                return 0;
            if ( equalTarget(t) && t.predicate == predicate )
                return 1;
            return 0;
        }

        бул equalTarget(Transition t)
        {
            if ( t.мишень.индекс != мишень.индекс )
                return нет;
            if ( commands.length != t.commands.length )
                return нет;
            Louter: foreach ( cmd; commands )
            {
                foreach ( cmd2; t.commands )
                {
                    if ( cmd == cmd2 )
                        continue Louter;
                }
                return нет;
            }
            return да;
        }
    }


    Состояние[]     states;
    Состояние       старт;
    Command[]   initializer;
    бцел        num_tags;

    бцел[TagIndex]  registers;
    бцел            next_register;

    бцел num_regs()
    {
        return next_register;
    }

    /* ********************************************************************************************
        Constructs the TDFA из_ the given TNFA using extended power установи метод
    **********************************************************************************************/
    this(TNFA!(т_сим) tnfa)
    {
        num_tags        = tnfa.tagCount;

        next_register   = num_tags;
        for ( цел i = 1; i <= num_tags; ++i ) {
            TagIndex ti;
            ti.тэг = i;
            registers[ti] = i-1;
        }

        // создай epsilon closure of TNFA старт состояние
        SubsetState subset_start    = new SubsetState;
        StateElement se             = new StateElement;
        se.nfa_state = tnfa.старт;
        subset_start.elms ~= se;

        // apply lookbehind closure for ткст/строка старт
        predicate_t tmp_pred;
        tmp_pred.установиВвод(КлассСимволов!(т_сим).начкон_стр);
        subset_start = epsilonClosure(lookbehindClosure(epsilonClosure(subset_start, subset_start), tmp_pred), subset_start);

        старт = добавьСостояние;
        subset_start.dfa_state = старт;

        // generate initializer and finisher commands for TDFA старт состояние
        generateInitializers(subset_start);
        generateFinishers(subset_start);

        // инициализуй stack for состояние traversal
        List!(SubsetState)  subset_states   = new List!(SubsetState),
                            unmarked        = new List!(SubsetState);
        subset_states   ~= subset_start;
        unmarked        ~= subset_start;
        debug(tdfa) Стдвыв.форматнс("\n{} = {}\n", subset_start.dfa_state.индекс, subset_start.вТкст);

        while ( !unmarked.пустой )
        {
            SubsetState состояние = unmarked.хвост.значение;
            unmarked.вынь;

            // создай transitions for each class, creating new states when necessary
            foreach ( пред; disjointPredicates(состояние) )
            {
                // найди NFA состояние we reach with пред
                // reach will установи predicate тип correctly
                debug(tdfa) Стдвыв.форматируй("из_ {} with {} reach", состояние.dfa_state.индекс, пред.вТкст);
                SubsetState мишень = reach(состояние, пред);
                if ( мишень is пусто ) {
                    continue;
                    debug(tdfa) Стдвыв.форматнс(" nothing - lookbehind at beginning, skИПping");
                }
                debug(tdfa) Стдвыв.форматнс(" {}", мишень.вТкст);
                мишень = epsilonClosure(lookbehindClosure(epsilonClosure(мишень, состояние), пред), состояние);

                Transition trans = new Transition;
                состояние.dfa_state.transitions ~= trans;
                debug (tdfa_new_trans) Стдвыв.форматнс("Creating with пред: {}", пред);
                trans.predicate = пред;

                // generate indeces for поз commands
                // delay creation of поз команда until we have reorder-commands
                бцел[бцел] cmds = пусто;
                foreach ( e; мишень.elms )
                {
                    foreach ( тэг, ref индекс; e.tags )
                    {
                        бул найдено=нет;
                        foreach ( e2; состояние.elms )
                        {
                            цел* i = тэг in e2.tags;
                            if ( i !is пусто && *i == индекс ) {
                                найдено=да;
                                break;
                            }
                        }
                        if ( !найдено )
                        {
                            // if индекс is < 0 it is a temporary индекс
                            // used only в_ distinguish the состояние из_ existing ones.
                            // the previous индекс can be reused instead.
                            if ( индекс < 0 )
                                индекс = -индекс-1;
                            cmds[тэг] = индекс;
                        }
                        else
                            assert(индекс>=0);
                    }
                }

                // check whether a состояние есть_ли that is опрentical except for тэг индекс reorder-commands
                бул есть_ли=нет;
                foreach ( equivTarget; subset_states )
                {
                    if ( reorderTagIndeces(мишень, equivTarget, состояние, trans) ) {
                        мишень = equivTarget;
                        есть_ли = да;
                        break;
                    }
                }
                // else создай new мишень состояние
                if ( !есть_ли )
                {
                    Состояние ts = добавьСостояние;
                    мишень.dfa_state = ts;
                    subset_states   ~= мишень;
                    unmarked        ~= мишень;
                    debug(tdfa_добавь) {
                        Стдвыв.форматнс("\nдобавьed {} = {}\n", мишень.dfa_state.индекс, мишень.вТкст);
                    }
                    generateFinishers(мишень);
                }

                // сейчас generate поз commands, rewriting reorder-commands if existent
                foreach ( тэг, индекс; cmds )
                {
                    // check whether reordering used this тэг, if so, overwrite the команда directly,
                    // for it's effect would be overwritten by a subsequent поз-команда anyway
                    бцел reg = registerFromTagIndex(тэг, индекс);
                    бул найдено = нет;
                    foreach ( ref cmd; trans.commands )
                    {
                        if ( cmd.ист == reg ) {
                            найдено = да;
                            cmd.ист = CURRENT_POSITION_REGISTER;
                            break;
                        }
                    }
                    if ( !найдено ) {
                        Command cmd;
                        cmd.приёмн = reg;
                        cmd.ист = CURRENT_POSITION_REGISTER;
                        trans.commands ~= cmd;
                    }
                }

                trans.мишень = мишень.dfa_state;
                debug(tdfa) {
                    Стдвыв.форматнс("=> из_ {} with {} reach {}", состояние.dfa_state.индекс, пред.вТкст, мишень.dfa_state.индекс);
                }
            }

            состояние.dfa_state.оптимизируй;
        }

        // renumber registers continuously
        бцел[бцел]  regNums;

        for ( next_register = 0; next_register < num_tags; ++next_register )
            regNums[next_register] = next_register;

        проц renumberCommand(ref Command cmd)
        {
            if ( cmd.ист != CURRENT_POSITION_REGISTER && (cmd.ист in regNums) is пусто )
                regNums[cmd.ист] = next_register++;
            if ( (cmd.приёмн in regNums) is пусто )
                regNums[cmd.приёмн] = next_register++;
            if ( cmd.ист != CURRENT_POSITION_REGISTER )
                cmd.ист = regNums[cmd.ист];
            cmd.приёмн = regNums[cmd.приёмн];
        }

        foreach ( состояние; states )
        {
            foreach ( ref cmd; состояние.finishers )
                renumberCommand(cmd);
            // сделай sure поз-commands are executed after reorder-commands and
            // reorder-commands do not overwrite each другой
            состояние.finishers.сортируй;

            foreach ( trans; состояние.transitions )
            {
                foreach ( ref cmd; trans.commands )
                    renumberCommand(cmd);
                trans.commands.сортируй;
                trans.predicate.компилируй;
            }
        }

        debug(TangoRegex)
        {
            foreach ( ref v; registers )
            {
                if ( (v in regNums) !is пусто )
                    v = regNums[v];
            }
        }

        minimizeDFA;

        foreach ( состояние; states )
            состояние.createLookup;

        // TODO: оптимизируй память выкладка of TDFA

        // TODO: добавь lookahead for ткст-конец somewhere
        // TODO: mark dead-конец states (not leaving a non-finishing susbet)
        // TODO: mark states that can покинь the finishing поднабор of DFA states or use a greedy transition
        //       (execution may stop in that состояние)
    }

    /* ********************************************************************************************
        Print the TDFA (tabular representation of the delta function)
    **********************************************************************************************/
    debug(TangoRegex) проц выведи()
    {
        Стдвыв.форматнс("#tags = {}", num_tags);

        auto tis = new TagIndex[registers.length];
        foreach ( k, v; registers )
            tis [v] = k;
        foreach ( r, ti; tis ) {
            Стдвыв.форматнс("тэг({},{}) in reg {}", ti.тэг, ti.индекс, r);
        }
        Стдвыв.форматнс("Initializer:");
        foreach ( cmd; initializer ) {
            Стдвыв.форматнс("{}", cmd.вТкст);
        }
        Стдвыв.форматнс("Delta function:");
        foreach ( цел i, s; states )
        {
            Стдвыв.форматируй("{}{:d2}{}", s is старт?">":" ", i, s.прими?"*":" ");

            бул first=да;
            Стдвыв(" {");
            foreach ( t; s.transitions )
            {
                Стдвыв.форматируй("{}{}->{} (", first?"":", ", t.predicate.вТкст, t.мишень.индекс);
                бул firstcmd=да;
                foreach ( cmd; t.commands )
                {
                    if ( firstcmd )
                        firstcmd = нет;
                    else
                        Стдвыв(",");
                    Стдвыв.форматируй("{}", cmd.вТкст);
                }
                Стдвыв(")");
                first = нет;
            }
            Стдвыв("} (");

            бул firstcmd=да;
            foreach ( cmd; s.finishers )
            {
                if ( firstcmd )
                    firstcmd = нет;
                else
                    Стдвыв(",");
                Стдвыв.форматируй("{}", cmd.вТкст);
            }
            Стдвыв.форматнс(")");
        }
    }

private:
    /* ********************************************************************************************
        A (TNFA состояние, tags) pair element of a поднабор состояние.
    **********************************************************************************************/
    class StateElement
    {
        TNFAState!(т_сим)  nfa_state;
        цел[бцел]           tags;
        // use place-значение priority with 2 places, значение(maxPrio) > значение(lastPrio)
        бцел                maxPriority,
                            lastPriority;

        бул prioGreater(StateElement se)
        {
            if ( maxPriority < se.maxPriority )
                return да;
            if ( maxPriority == se.maxPriority ) {
                assert(lastPriority != se.lastPriority);
                return lastPriority < se.lastPriority;
            }
            return нет;
        }

        цел opCmp(Объект o)
        {
            StateElement se = cast(StateElement)o;
            assert(se !is пусто);
            if ( maxPriority < se.maxPriority )
                return 1;
            if ( maxPriority == se.maxPriority )
            {
                if ( lastPriority == se.lastPriority )
                    return 0;
                return lastPriority < se.lastPriority;
            }
            return -1;
        }

        ткст вТкст()
        {
            ткст ткт;
            ткт = Формат.преобразуй("{} p{}.{} {{", nfa_state.индекс, maxPriority, lastPriority);
            бул first = да;
            foreach ( k, v; tags ) {
                ткт ~= Формат.преобразуй("{}m({},{})", first?"":",", k, v);
                first = нет;
            }
            ткт ~= "}";
            return ткт;
        }
    }

    /* ********************************************************************************************
        Represents a состояние in the NFA в_ DFA conversion.
        Contains the установи of states (StateElements) the NFA might be in at the same время and the
        corresponding DFA состояние that we создай.
    **********************************************************************************************/
    class SubsetState
    {
        StateElement[]  elms;
        Состояние           dfa_state;

        this(StateElement[] elms=пусто)
        {
            this.elms = elms;
        }

        цел opApply(цел delegate (ref TNFATransition!(т_сим)) дг)
        {
            цел рез;
            foreach ( elm; elms )
            {
                foreach ( t; elm.nfa_state.transitions )
                {
                    рез = дг(t);
                    if ( рез )
                        return рез;
                }
            }
            return рез;
        }

        ткст вТкст()
        {
            ткст ткт = "[ ";
            бул first = да;
            foreach ( s; elms ) {
                if ( !first )
                    ткт ~= ", ";
                ткт ~= s.вТкст;
                first = нет;
            }
            return ткт~" ]";
        }
    }

    /* ********************************************************************************************
        Temporary structure used for disjoint predicate computation
    **********************************************************************************************/
    struct Mark
    {
        т_сим  c;
        бул    конец;    /// нет = старт of range

        цел opCmp(Mark m)
        {
            if ( c < m.c )
                return -1;
            if ( c > m.c )
                return 1;
            if ( конец < m.конец )
                return -1;
            if ( конец > m.конец )
                return 1;
            return 0;
        }
    }

    /* ********************************************************************************************
        Calculates the регистрируй индекс for a given тэг карта Запись. The TDFA implementation uses
        registers в_ save potential тэг positions, the индекс пространство gets linearized here.

        Параметры:     тэг =   тэг число
                    индекс = тэг карта индекс
        Возвращает:    индекс of the регистрируй в_ use for the тэг карта Запись
    **********************************************************************************************/
    бцел registerFromTagIndex(бцел тэг, бцел индекс)
    {
        if ( индекс > 0 )
        {
            TagIndex ti;
            ti.тэг = тэг;
            ti.индекс = индекс;
            бцел* i = ti in registers;
            if ( i !is пусто )
                return *i;
            return registers[ti] = next_register++;
        }
        else
            return тэг-1;
    }

    Mark[] marks_;

    /* ********************************************************************************************
        Добавь new TDFA состояние в_ the automaton.
    **********************************************************************************************/
    Состояние добавьСостояние()
    {
        Состояние s = new Состояние;
        s.индекс = states.length;
        states ~= s;
        return s;
    }

    /* ********************************************************************************************
        Creates disjoint predicates из_ все outgoing, potentially overlapping TNFA transitions.

        Параметры:     состояние = SubsetState в_ создай the predicates из_
        Возвращает:    List of disjoint predicates that can be used for a DFA состояние
    **********************************************************************************************/
    predicate_t[] disjointPredicates(SubsetState состояние)
    {
        alias ДиапазонСимволов!(т_сим) т_диапазон;
        debug(tdfa) Стдвыв.форматнс("disjointPredicates()");

        т_мера num_marks;
        foreach ( t; состояние )
        {
            // partitioning will consопрer lookbehind transitions,
            // st. lb-closure will not расширь for transitions with a superset of the lb-predicate
            if ( t.predicate.тип != predicate_t.Тип.epsilon )
            {
                debug(tdfa) Стдвыв.форматнс("{}", t.predicate.вТкст);
                if ( marks_.length < num_marks+2*t.predicate.дайВвод.части.length )
                    marks_.length = num_marks+2*t.predicate.дайВвод.части.length;
                foreach ( p; t.predicate.дайВвод.части ) {
                    marks_[num_marks++] = Mark(p.l, нет);
                    marks_[num_marks++] = Mark(p.r, да);
                }
            }
        }

        if ( num_marks <= 1 )
            throw new Исключение("disjointPredicates: No transitions in поднабор состояние");

        debug(tdfa) Стдвыв("\nsorting...").нс;
        // using built-in сортируй somtimes gives an AV in ИнфОТипе.своп
        быстрСорт(marks_[0 .. num_marks]);
        assert(!marks_[0].конец);

        debug(tdfa)
        {
            Стдвыв("\nsorted marks:\n");
            бул first=да;
            foreach ( m; marks_[0 .. num_marks] )
            {
                if ( first )
                    first = нет;
                else
                    Стдвыв(",");
                if ( m.c > 0x20 && m.c < 0x7f )
                    Стдвыв.форматируй("{}{}", m.конец?"e":"s", m.c);
                else
                    Стдвыв.форматируй("{}{:x}", m.конец?"e":"s", cast(цел)m.c);
            }
            Стдвыв.нс;
        }

        т_мера  следщ,
                активное = 1;
        т_сим  старт = marks_[0].c,
                конец;
        т_диапазон[]   disjoint = new т_диапазон[num_marks/2+1];

        foreach ( m; marks_[1 .. num_marks] )
        {
            if ( m.конец )
            {
                assert(активное>0);
                --активное;
                if ( m.c < старт )
                    continue;
                конец = m.c;
                // the следщ range cannot старт at the same поз
                // because starts are sorted before endings
                if ( активное > 0 )
                    ++m.c;
            }
            else
            {
                ++активное;
                if ( активное == 1 )
                {
                    // пропусти uncovered интервал
                    if ( m.c > старт ) {
                        старт = m.c;
                        continue;
                    }
                    конец = m.c;
                    ++m.c;
                }
                // пропусти range старт if cursor already marks it
                else if ( m.c <= старт )
                    continue;
                else
                    конец = m.c-1;
            }

            // save range
            if ( disjoint.length <= следщ )
                disjoint.length = disjoint.length*2;

            disjoint[следщ].l_ = старт;
            disjoint[следщ].r_ = конец;
            ++следщ;

            // advance cursor
            старт = m.c;
        }
        disjoint.length = следщ;

        // merge isolated ranges преобр_в sets of ranges
        // no range in a установи may occur separated из_ the другие in any predicate
        predicate_t[]   preds;
        preds.length = 1;
        Lmerge: foreach ( r; disjoint )
        {
            if ( preds[$-1].пустой )
                preds[$-1].добавьВвод(r);
            else
            {
                // we can merge r преобр_в the current predicate if
                // пред содержит r <=> пред содержит все the другой ranges
                foreach ( t; состояние )
                {
                    if ( t.predicate.тип == predicate_t.Тип.epsilon )
                        continue;

                    if ( t.predicate.дайВвод.содержит(r)
                        != t.predicate.дайВвод.содержит(preds[$-1].дайВвод) )
                    {
                        preds.length = preds.length+1;
                        break;
                    }
                }
                preds[$-1].добавьВвод(r);
            }
        }

        debug(tdfa)
        {
            Стдвыв("\ndisjoint ranges:\n");
            first=да;
            foreach ( r; disjoint )
            {
                if ( first )
                    first = нет;
                else
                    Стдвыв(",");
                Стдвыв.форматируй("{}", r);
            }
            Стдвыв.нс;
            Стдвыв("\ndisjoint predicates:\n");
            first=да;
            foreach ( ref p; preds )
            {
                if ( first )
                    first = нет;
                else
                    Стдвыв(",");
                Стдвыв.форматируй("{}", p.вТкст);
            }
            Стдвыв.нс;
        }

        debug(tdfa) Стдвыв.форматнс("disjointPredicates() конец");
        return preds;
    }

    /* ********************************************************************************************
        Finds все TNFA states that can be reached directly with the given predicate and creates
        a new SubsetState containing those мишень states.

        Параметры:     subst = SubsetState в_ старт из_
                    пред =  predicate that is matched against outgoing transitions
        Возвращает:    SubsetState containing the reached мишень states
    **********************************************************************************************/
    SubsetState reach(SubsetState subst, ref predicate_t пред)
    {
        // в_ укз the special case of overlapping используй and lookahead predicates,
        // we найди the different intersecting predicate типы
        бул    have_consume,
                have_lookahead;
        foreach ( t; subst )
        {
            if ( t.predicate.тип != predicate_t.Тип.используй && t.predicate.тип != predicate_t.Тип.lookahead )
                continue;
            auto intpred = t.predicate.пересечение(пред);
            if ( !intpred.пустой )
            {
                if ( t.predicate.тип == predicate_t.Тип.используй )
                    have_consume = да;
                else if ( t.predicate.тип == predicate_t.Тип.lookahead )
                    have_lookahead = да;
            }
        }

        // if there is используй/lookahead overlap,
        // lookahead predicates are handled first
        predicate_t.Тип processed_type;
        if ( have_lookahead )
            processed_type = predicate_t.Тип.lookahead;
        else if ( have_consume )
            processed_type = predicate_t.Тип.используй;
        else {
            debug(tdfa) Стдвыв.форматнс("\nERROR: reach найдено no используй/lookahead symbol for {} in \n{}", пред.вТкст, subst.вТкст);
            return пусто;
        }
        пред.тип = processed_type;

        // добавь destination states в_ new subsetstate
        SubsetState r = new SubsetState;
        foreach ( s; subst.elms )
        {
            foreach ( t; s.nfa_state.transitions )
            {
                if ( t.predicate.тип != processed_type )
                    continue;
                auto intpred = t.predicate.пересечение(пред);
                if ( !intpred.пустой ) {
                    StateElement se = new StateElement;
                    se.maxPriority = max(t.priority, s.maxPriority);
                    se.lastPriority = t.priority;
                    se.nfa_state = t.мишень;
                    se.tags = s.tags;
                    r.elms ~= se;
                }
            }
        }

        // if we prioritized lookaheads, the states that may используй are also добавьed в_ the new поднабор состояние
        // this behaviour is somewhat similar в_ an epsilon closure
        if ( have_lookahead && have_consume )
        {
            foreach ( s; subst.elms )
            {
                foreach ( t; s.nfa_state.transitions )
                {
                    if ( t.predicate.тип != predicate_t.Тип.используй )
                        continue;
                    auto intpred = t.predicate.пересечение(пред);
                    if ( !intpred.пустой ) {
                        r.elms ~= s;
                        break;
                    }
                }
            }
        }
        return r;
    }

    /* ********************************************************************************************
        Extends the given SubsetState with the states that are reached through lookbehind transitions.

        Параметры:     из_ =      SubsetState в_ создай the lookbehind closure for
                    previous =  predicate "из_" was reached with
        Возвращает:    SubsetState containing "из_" and все states of it's lookbehind closure
    **********************************************************************************************/
    SubsetState lookbehindClosure(SubsetState из_, predicate_t пред)
    {
        List!(StateElement) stack = new List!(StateElement);
        StateElement[бцел]  closure;

        foreach ( e; из_.elms )
        {
            stack ~= e;
            closure[e.nfa_state.индекс] = e;
        }

        while ( !stack.пустой )
        {
            StateElement se = stack.хвост.значение;
            stack.вынь;
            foreach ( t; se.nfa_state.transitions )
            {
                if ( t.predicate.тип != predicate_t.Тип.lookbehind )
                    continue;
                if ( t.predicate.пересечение(пред).пустой )
                    continue;
                бцел new_maxPri = max(t.priority, se.maxPriority);

                StateElement* врем = t.мишень.индекс in closure;
                if ( врем !is пусто )
                {
                    // if higher prio (smaller значение) есть_ли, do not use this transition
                    if ( врем.maxPriority < new_maxPri ) {
//                         debug(tdfa) Стдвыв.форматнс("maxPrio({}) {} beats {}, continuing", t.мишень.индекс, врем.maxPriority, new_maxPri);
                        continue;
                    }
                    else if ( врем.maxPriority == new_maxPri )
                    {
                        // "equal lastPrio -> first-come-first-serve"
                        // doesn't work for lexer - как в_ solve it properly?
                        if ( врем.lastPriority <= t.priority ) {
//                             debug(tdfa) Стдвыв.форматнс("lastPrio({}) {} beats {}, continuing", t.мишень.индекс, врем.lastPriority, t.priority);
                            continue;
                        }
//                         else
//                             debug(tdfa) Стдвыв.форматнс("lastPrio({}) {} beats {}", t.мишень.индекс, t.priority, врем.lastPriority);
                    }
//                     else
//                         debug(tdfa) Стдвыв.форматнс("maxPrio({}) {} beats {}", t.мишень.индекс, new_maxPri, врем.maxPriority);
                }

                StateElement new_se = new StateElement;
                new_se.maxPriority = max(t.priority, se.maxPriority);
                new_se.lastPriority = t.priority;
                new_se.nfa_state = t.мишень;
                new_se.tags = se.tags;

                closure[t.мишень.индекс] = new_se;
                stack ~= new_se;
            }
        }

        SubsetState рез = new SubsetState;
        рез.elms = closure.values;
        return рез;
    }

    /* ********************************************************************************************
        Generates the epsilon closure of the given поднабор состояние, creating тэг карта записи
        if tags are passed. Takes priorities преобр_в account, effectively realizing
        greediness and reluctancy.

        Параметры:     из_ =      SubsetState в_ создай the epsilon closure for
                    previous =  SubsetState "из_" was reached из_
        Возвращает:    SubsetState containing "из_" and все states of it's epsilon closure
    **********************************************************************************************/
    SubsetState epsilonClosure(SubsetState из_, SubsetState previous)
    {
        цел firstFreeIndex=-1;
        foreach ( e; previous.elms )
        {
            foreach ( ti; e.tags )
                firstFreeIndex = max(firstFreeIndex, cast(цел)ti);
        }
        ++firstFreeIndex;

        List!(StateElement) stack = new List!(StateElement);
        StateElement[бцел]  closure;

        foreach ( e; из_.elms )
        {
            stack ~= e;
            closure[e.nfa_state.индекс] = e;
        }

        while ( !stack.пустой )
        {
            StateElement se = stack.хвост.значение;
            stack.вынь;
            foreach ( t; se.nfa_state.transitions )
            {
                if ( t.predicate.тип != predicate_t.Тип.epsilon )
                    continue;
                // this is different из_ Ville Laurikari's algorithm, but it's crucial
                // в_ take the max (instead of t.priority) в_ сделай reluctant operators work
                бцел new_maxPri = max(t.priority, se.maxPriority);

                StateElement* врем = t.мишень.индекс in closure;
                if ( врем !is пусто )
                {
                    // if higher prio (smaller значение) есть_ли, do not use this transition
                    if ( врем.maxPriority < new_maxPri ) {
//                         debug(tdfa) Стдвыв.форматнс("maxPrio({}) {} beats {}, continuing", t.мишень.индекс, врем.maxPriority, new_maxPri);
                        continue;
                    }
                    else if ( врем.maxPriority == new_maxPri )
                    {
                        // "equal lastPrio -> first-come-first-serve"
                        // doesn't work for lexer - как в_ solve it properly?
                        if ( врем.lastPriority <= t.priority ) {
//                             debug(tdfa) Стдвыв.форматнс("lastPrio({}) {} beats {}, continuing", t.мишень.индекс, врем.lastPriority, t.priority);
                            continue;
                        }
//                         else
//                             debug(tdfa) Стдвыв.форматнс("lastPrio({}) {} beats {}", t.мишень.индекс, t.priority, врем.lastPriority);
                    }
//                     else
//                         debug(tdfa) Стдвыв.форматнс("maxPrio({}) {} beats {}", t.мишень.индекс, new_maxPri, врем.maxPriority);
                }

                auto new_se = new StateElement;
                new_se.maxPriority = new_maxPri;
                new_se.lastPriority = t.priority;
                new_se.nfa_state = t.мишень;

                if ( t.тэг > 0 )
                {
                    foreach ( k, v; se.tags )
                        new_se.tags[k] = v;
                    new_se.tags[t.тэг] = firstFreeIndex;
                }
                else
                    new_se.tags = se.tags;

                closure[t.мишень.индекс] = new_se;
                stack ~= new_se;
            }
        }

        SubsetState рез = new SubsetState;
        рез.elms = closure.values;

        // оптимизируй тэг usage
        // все we need в_ do is в_ check whether the largest тэг-индекс из_ the
        // previous состояние is actually used in the new состояние and перемести все tags with
        // firstFreeIndex down by one if not, but only if firstFreeIndex is not 0
        if ( firstFreeIndex > 0 )
        {
            бул seenLastUsedIndex = нет;
            sluiLoop: foreach ( e; рез.elms )
            {
                foreach ( i; e.tags )
                {
                    if ( i == firstFreeIndex-1 ) {
                        seenLastUsedIndex = да;
                        break sluiLoop;
                    }
                }
            }
            if ( !seenLastUsedIndex )
            {
                foreach ( e; рез.elms )
                {
                    foreach ( ref i; e.tags )
                    {
                        // mark индекс by making it negative
                        // в_ signal that it can be decremented
                        // after it есть been detected в_ be a newly used индекс
                        if ( i == firstFreeIndex )
                            i = -firstFreeIndex;
                    }
                }
            }
        }

        return рез;
    }

    /* ********************************************************************************************
        Tries в_ создай commands that reorder the тэг карта of "previous", such that "из_" becomes
        тэг-wise опрentical в_ "в_". If successful, these commands are добавьed в_ "trans". This
        is готово for состояние re-use.

        Параметры:     из_ =      SubsetState в_ check for тэг-wise equality в_ "в_"
                    в_ =        existing SubsetState that we want в_ re-use
                    previous =  SubsetState we're coming из_
                    trans =     Transition we went along
        Возвращает:    да if "из_" is тэг-wise опрentical в_ "в_" and the necessary commands have
                    been добавьed в_ "trans"
    **********************************************************************************************/
    бул reorderTagIndeces(SubsetState из_, SubsetState в_, SubsetState previous, Transition trans)
    {
        if ( из_.elms.length != в_.elms.length )
            return нет;

        бул[Command]
            cmds;
        бцел[TagIndex]
            reorderedIndeces;
        StateElement[TagIndex]
            reordered_elements;

        Louter: foreach ( fe; из_.elms )
        {
            foreach ( te; в_.elms )
            {
                if ( te.nfa_state.индекс != fe.nfa_state.индекс )
                    continue;
                if ( fe.tags.length != te.tags.length )
                    return нет;
                foreach ( тэг, findex; fe.tags )
                {
                    if ( (тэг in te.tags) is пусто )
                        return нет;

                    TagIndex ti;
                    ti.тэг = тэг;
                    ti.индекс = te.tags[тэг];

                    // apply priority for conflicting тэг indeces
                    if ( (ti in reorderedIndeces) !is пусто )
                    {
                        auto rse = reordered_elements[ti];
                        auto ri = reorderedIndeces[ti];
                        if ( ri != findex
                            && ( rse.maxPriority < fe.maxPriority
                                || rse.maxPriority == fe.maxPriority
                                && rse.lastPriority <= fe.lastPriority )
                        )
                            continue;
                        Command cmd;
                        cmd.ист = registerFromTagIndex(тэг,ri);
                        cmd.приёмн = registerFromTagIndex(тэг,te.tags[тэг]);
                        cmds.удали(cmd);
                    }
                    // if мишень индекс differs, создай reordering команда
                    if ( te.tags[тэг] != findex )
                    {
                        Command cmd;
                        cmd.ист = registerFromTagIndex(тэг,findex);
                        cmd.приёмн = registerFromTagIndex(тэг,te.tags[тэг]);
                        cmds[cmd] = да;
                    }

                    reorderedIndeces[ti] = findex;
                    reordered_elements[ti] = fe;
                }
                continue Louter;
            }
            return нет;
        }

        debug(tdfa) {
            Стдвыв.форматнс("\nreorder {} в_ {}\n", из_.вТкст, в_.dfa_state.индекс);
        }

        trans.commands ~= cmds.ключи;
        return да;
    }

    /* ********************************************************************************************
        Generate тэг карта initialization commands for старт состояние.
    **********************************************************************************************/
    проц generateInitializers(SubsetState старт)
    {
        бцел[бцел] cmds;
        foreach ( nds; старт.elms )
        {
            foreach ( k, v; nds.tags )
                cmds[k] = v;
        }

        foreach ( k, v; cmds ) {
            Command cmd;
            cmd.приёмн = registerFromTagIndex(k,v);
            cmd.ист = CURRENT_POSITION_REGISTER;
            initializer ~= cmd;
        }
    }

    /* ********************************************************************************************
        Generates finisher commands for accepting states.
    **********************************************************************************************/
    проц generateFinishers(SubsetState r)
    {
        // if at least one of the TNFA states accepts,
        // установи the finishers из_ активное tags in increasing priority
        StateElement[]  sorted_elms = r.elms.dup.сортируй;
        бул reluctant = нет;
        foreach ( se; sorted_elms ) {
            debug (Finishers) Стдвыв.форматнс("Finisher: {}", se);
            if ( se.nfa_state.прими )
            {
                r.dfa_state.прими = да;

                // Knowing that we're looking at an epsilon closure with an accepting
                // состояние, we look at the involved transitions - if the путь из_ the
                // nfa состояние in the установи with the highest incoming priority (последний in
                // sorted_elms список) в_ the accepting nfa состояние is via the highest
                // priority transitions, and they are все epsilon transitions, this
                // suggests we're looking at a regex ending with a reluctant образец.
                // The NFA->DFA transformation will most likely extend the automata
                // further, but we want the matching в_ stop here.
                // NOTE: The grounds for choosing the последний element in sorted_elms
                // are somewhat weak (empirical testing), but sofar no new
                // regressions have been discovered. larsivi 20090827
                TNFATransition!(т_сим) highestPriTrans;
                foreach ( trans; sorted_elms[$-1].nfa_state.transitions ) {
                    if (trans.canFinish()) {
                        r.dfa_state.reluctant = да;
                        break;
                    }
                }

                бул[бцел]  finished_tags;
                {
                    foreach ( t, i; se.tags )
                        if ( i > 0 && !(t in finished_tags) ) {
                            finished_tags[t] = да;
                            Command cmd;
                            cmd.приёмн = registerFromTagIndex(t, 0);
                            cmd.ист = registerFromTagIndex(t, i);
                            r.dfa_state.finishers ~= cmd;
                        }
                }
            }
        }
    }

    /* ********************************************************************************************
        Assumes that the команда-lists are sorted and transitions are optimized
    **********************************************************************************************/
    проц minimizeDFA()
    {
        class DiffTable
        {
            this(т_мера num) {
                diff_ = new бул[num*(num+1)/2];
            }

            ~this() { delete diff_; }

            бул opCall(т_мера a, т_мера b)
            {
                if ( a < b )
                    return diff_[b*(b+1)/2+a];
                return diff_[a*(a+1)/2+b];
            }

            проц установи(т_мера a, т_мера b)
            {
                if ( a < b )
                    diff_[b*(b+1)/2+a] = да;
                else
                    diff_[a*(a+1)/2+b] = да;
            }

            бул[]  diff_;
        }

        debug(tdfa) Стдвыв.форматнс("Minimizing TDFA");

        scope diff = new DiffTable(states.length);
        бул new_diff = да;

        while ( new_diff )
        {
            new_diff = нет;
            foreach ( i, a; states[0 .. $-1] )
            {
                Linner: foreach ( j, b; states[i+1 .. $] )
                {
                    if ( diff(i, j+i+1) )
                        continue;

                    // assume optimized transitions
                    if ( a.прими != b.прими || a.transitions.length != b.transitions.length ) {
                        diff.установи(i, j+i+1);
                        new_diff = да;
                        continue;
                    }

                    if ( a.прими ) // b accepts too
                    {
                        // assume sorted finishers
                        if ( a.finishers.length != b.finishers.length ) {
                            diff.установи(i, j+i+1);
                            new_diff = да;
                            continue;
                        }
                        foreach ( k, cmd; a.finishers )
                        {
                            if ( cmd != b.finishers[k] ) {
                                diff.установи(i, j+i+1);
                                new_diff = да;
                                continue Linner;
                            }
                        }
                    }

                    Ltrans: foreach ( ta; a.transitions )
                    {
                        foreach ( tb; b.transitions )
                        {
                            if ( ta.predicate.пересекает(tb.predicate) )
                            {
                                if ( diff(ta.мишень.индекс, tb.мишень.индекс) ) {
                                    diff.установи(i, j+i+1);
                                    new_diff = да;
                                    continue Linner;
                                }
                                // assume sorted commands
                                if ( ta.commands.length != tb.commands.length ) {
                                    diff.установи(i, j+i+1);
                                    new_diff = да;
                                    continue Linner;
                                }
                                foreach ( k, cmd; ta.commands )
                                {
                                    if ( cmd != tb.commands[k] ) {
                                        diff.установи(i, j+i+1);
                                        new_diff = да;
                                        continue Linner;
                                    }
                                }
                                continue Ltrans;
                            }
                        }

                        diff.установи(i, j+i+1);
                        new_diff = да;
                        continue Linner;
                    }

                }
            }
        }

        foreach ( i, a; states[0 .. $-1] )
        {
            foreach ( j, b; states[i+1 .. $] )
            {
                if ( !diff(i, j+i+1) )
                {
                    debug(tdfa) Стдвыв.форматнс("Состояние {} == {}", i, j+i+1);
                    // remap b в_ a
                    foreach ( k, c; states )
                    {
                        foreach ( t; c.transitions )
                        {
                            if ( t.мишень.индекс == j+i+1 )
                                t.мишень = a;
                        }
                    }
                }
            }
        }

    }
}
import text.Util;

/**************************************************************************************************
    Regular expression compiler and interpreter.
**************************************************************************************************/
class RegExpT(т_сим)
{
    alias TDFA!(дим)      tdfa_t;
    alias TNFA!(дим)      tnfa_t;
    alias КлассСимволов!(дим) charclass_t;
    alias Predicate!(дим) predicate_t;

    /**********************************************************************************************
        Construct a RegExpT объект.
        Параметры:
            образец = Regular expression.
        Throws: ИсклРегВыр if there are any compilation ошибки.
        Example:
            Declare two variables and присвой в_ them a Regex объект:
            ---
            auto r = new Regex("образец");
            auto s = new Regex(r"p[1-5]\s*");
            ---
    **********************************************************************************************/
    this(т_ткст образец, т_ткст атрибуты=пусто)
    {
        this(образец, нет, да);
    }

    /** ditto */
    this(т_ткст образец, бул свопMBS, бул unanchored, бул printNFA=нет)
    {
        pattern_ = образец;

        debug(TangoRegex) {}
        else { scope tnfa_t tnfa_; }
        static if ( is(т_сим == дим) ) {
            tnfa_ = new tnfa_t(pattern_);
        }
        else {
            tnfa_ = new tnfa_t(text.convert.Utf.toString32(pattern_));
        }
        tnfa_.свопMatchingBracketSyntax = свопMBS;
        tnfa_.разбор(unanchored);
        if ( printNFA ) {
            debug(TangoRegex) Стдвыв.форматнс("\nTNFA:");
            debug(TangoRegex) tnfa_.выведи;
        }
        tdfa_ = new tdfa_t(tnfa_);
        registers_.length = tdfa_.num_regs;
    }

    /**********************************************************************************************
        Generate экземпляр of Regex.
        Параметры:
            образец = Regular expression.
        Throws: ИсклРегВыр if there are any compilation ошибки.
        Example:
            Declare two variables and присвой в_ them a Regex объект:
            ---
            auto r = Regex("образец");
            auto s = Regex(r"p[1-5]\s*");
            ---
    **********************************************************************************************/
    static RegExpT!(т_сим) opCall(т_ткст образец, т_ткст атрибуты = пусто)
    {
        return new RegExpT!(т_сим)(образец, атрибуты);
    }

    /**********************************************************************************************
        Набор up for старт of foreach loop.
        Возвращает:    Instance of RegExpT установи up в_ search ввод.
        Example:
            ---
            import io.Stdout;
            import text.Regex;

            проц main()
            {
                foreach(m; Regex("ab").search("qwerabcabcababqwer"))
                    Стдвыв.форматнс("{}[{}]{}", m.pre, m.match(0), m.post);
            }
            // Prints:
            // qwer[ab]cabcababqwer
            // qwerabc[ab]cababqwer
            // qwerabcabc[ab]abqwer
            // qwerabcabcab[ab]qwer
            ---
    **********************************************************************************************/
    public RegExpT!(т_сим) search(т_ткст ввод)
    {
        input_ = ввод;
        next_start_ = 0;
        last_start_ = 0;
        return this;
    }

    /** ditto */
    public цел opApply(цел delegate(ref RegExpT!(т_сим)) дг)
    {
        цел результат;
        while ( !результат && тест() )
            результат = дг(this);
        return результат;
    }

    /**********************************************************************************************
        Search ввод for match.
        Возвращает: нет for no match, да for match
    **********************************************************************************************/
    бул тест(т_ткст ввод)
    {
        this.input_ = ввод;
        next_start_ = 0;
        last_start_ = 0;
        return тест();
    }

    /**********************************************************************************************
        Pick up where последний тест(ввод) or тест() left off, and search again.
        Возвращает: нет for no match, да for match
    **********************************************************************************************/
    бул тест()
    {
        // инициализуй registers
        assert(registers_.length == tdfa_.num_regs);
        registers_[0..$] = -1;
        foreach ( cmd; tdfa_.initializer ) {
            assert(cmd.ист == tdfa_.CURRENT_POSITION_REGISTER);
            registers_[cmd.приёмн] = 0;
        }

        // DFA execution
        auto inp = input_[next_start_ .. $];
        auto s = tdfa_.старт;

        debug(TangoRegex) Стдвыв.форматнс("{}{}: {}", s.прими?"*":" ", s.индекс, inp);
        LmainLoop: for ( т_мера p, next_p; p < inp.length; )
        {
        Lread_char:
            дим c = cast(дим)inp[p];
            if ( c & 0x80 )
                c = раскодируй(inp, next_p);
            else
                next_p = p+1;

        Lprocess_char:
            debug(TangoRegex) Стдвыв.форматнс("{} (0x{:x})", c, cast(цел)c);

            tdfa_t.Transition t =void;
            switch ( s.режим )
            {
                case s.Mode.LOOKUP:
                    if ( c < s.LOOKUP_LENGTH )
                    {
                        debug(TangoRegex) Стдвыв.форматнс("отыщи");
                        auto i = s.отыщи[c];
                        if ( i == s.INVALID_STATE )
                            break LmainLoop;
                        t = s.transitions[ i ];
                        if ( t.predicate.тип != t.predicate.Тип.используй )
                            goto Lno_consume;
                        goto Lconsume;
                    }
                    break LmainLoop;

                case s.Mode.MIXED:
                    if ( c < s.LOOKUP_LENGTH )
                    {
                        debug(TangoRegex) Стдвыв.форматнс("mixed");
                        auto i = s.отыщи[c];
                        if ( i == s.INVALID_STATE )
                            break;
                        t = s.transitions[ i ];
                        if ( t.predicate.тип != t.predicate.Тип.используй )
                            goto Lno_consume;
                        goto Lconsume;
                    }
                    break;

                case s.Mode.GENERIC:
                default:
                    break;
            }

            Ltrans_loop: for ( tdfa_t.Transition* tp = &s.generic_transitions[0], tp_end = tp+s.generic_transitions.length;
                tp < tp_end; ++tp )
            {
                t = *tp;
                switch ( t.predicate.режим )
                {
                    // single сим
                    case predicate_t.MatchMode.single_char:
                        debug(TangoRegex) Стдвыв.форматнс("single сим 0x{:x} == 0x{:x}", cast(цел)c, cast(цел)t.predicate.data_chr);
                        if ( c != t.predicate.data_chr )
                            continue Ltrans_loop;
                        goto Lconsume;
                    case predicate_t.MatchMode.single_char_l:
                        debug(TangoRegex) Стдвыв.форматнс("single сим 0x{:x} == 0x{:x}", cast(цел)c, cast(цел)t.predicate.data_chr);
                        if ( c != t.predicate.data_chr )
                            continue Ltrans_loop;
                        goto Lno_consume;

                    // bitmap
                    case predicate_t.MatchMode.bitmap:
                        debug(TangoRegex) Стдвыв.форматнс("bitmap {}\n{}", c, t.predicate.вТкст);
                        if ( c <= predicate_t.MAX_BITMAP_LENGTH && ( t.predicate.data_bmp[c/8] & (1 << (c&7)) ) )
                            goto Lconsume;
                        continue Ltrans_loop;
                    case predicate_t.MatchMode.bitmap_l:
                        debug(TangoRegex) Стдвыв.форматнс("bitmap {}\n{}", c, t.predicate.вТкст);
                        if ( c <= predicate_t.MAX_BITMAP_LENGTH && ( t.predicate.data_bmp[c/8] & (1 << (c&7)) ) )
                            goto Lno_consume;
                        continue Ltrans_loop;

                    // ткст search
                    case predicate_t.MatchMode.string_search:
                        debug(TangoRegex) Стдвыв.форматнс("ткст search {} in {}", c, t.predicate.data_str);
                        if ( indexOf(t.predicate.data_str.ptr, c, t.predicate.data_str.length) >= t.predicate.data_str.length )
                            continue Ltrans_loop;
                        goto Lconsume;
                    case predicate_t.MatchMode.string_search_l:
                        debug(TangoRegex) Стдвыв.форматнс("ткст search {} in {}", c, t.predicate.data_str);
                        if ( indexOf(t.predicate.data_str.ptr, c, t.predicate.data_str.length) >= t.predicate.data_str.length )
                            continue Ltrans_loop;
                        goto Lno_consume;

                    // generic
                    case predicate_t.MatchMode.generic:
                        debug(TangoRegex) Стдвыв.форматнс("generic {}\n{}", c, t.predicate.вТкст);
                        for ( auto cmp = t.predicate.data_str.ptr,
                            cmpend = cmp + t.predicate.data_str.length;
                            cmp < cmpend; ++cmp )
                        {
                            if ( c < *cmp ) {
                                ++cmp;
                                continue;
                            }
                            ++cmp;
                            if ( c <= *cmp )
                                goto Lconsume;
                        }
                        continue Ltrans_loop;
                    case predicate_t.MatchMode.generic_l:
                        debug(TangoRegex) Стдвыв.форматнс("generic {}\n{}", c, t.predicate.вТкст);
                        for ( auto cmp = t.predicate.data_str.ptr,
                            cmpend = cmp + t.predicate.data_str.length;
                            cmp < cmpend; ++cmp )
                        {
                            if ( c < *cmp ) {
                                ++cmp;
                                continue;
                            }
                            ++cmp;
                            if ( c <= *cmp )
                                goto Lno_consume;
                        }
                        continue Ltrans_loop;

                    default:
                        assert(0);
                }

            Lconsume:
                p = next_p;
            Lno_consume:

                s = t.мишень;
                debug(TangoRegex) Стдвыв.форматнс("{}{}: {}", s.прими?"*":" ", s.индекс, inp[p..$]);
                debug(TangoRegex) Стдвыв.форматнс("{} commands", t.commands.length);

                foreach ( cmd; t.commands )
                {
                    if ( cmd.ист == tdfa_.CURRENT_POSITION_REGISTER )
                        registers_[cmd.приёмн] = p;
                    else
                        registers_[cmd.приёмн] = registers_[cmd.ист];
                }

                if (s.прими && s.reluctant)
                    // Don't continue matching, the current найди should be correct
                    goto Laccept;

                // if все ввод was consumed and we do not already прими, try в_ 
                // добавь an explicit ткст/строка конец
                if ( p >= inp.length )
                {
                    if ( s.прими || c == 0 )
                        break;
                    c = 0;
                    goto Lprocess_char;
                }
                goto Lread_char;
            }
            // no applicable transition
            break;
        }

        if ( s.прими )
        {
        Laccept:
            foreach ( cmd; s.finishers ) {
                assert(cmd.ист != tdfa_.CURRENT_POSITION_REGISTER);
                registers_[cmd.приёмн] = registers_[cmd.ист];
            }
            if ( registers_.length > 1 && registers_[1] >= 0 ) {
                last_start_ = next_start_;
                next_start_ += registers_[1];
            }
            return да;
        }

        return нет;
    }

    /**********************************************************************************************
        Return submatch with the given индекс.
        Параметры:
            индекс   индекс = 0 returns whole match, индекс > 0 returns submatch of bracket #индекс
        Возвращает:
            Slice of ввод for the requested submatch, or пусто if no such submatch есть_ли.
    **********************************************************************************************/
    т_ткст match(бцел индекс)
    {
        if ( индекс > tdfa_.num_tags )
            return пусто;
        цел старт   = last_start_+registers_[индекс*2],
            конец     = last_start_+registers_[индекс*2+1];
        if ( старт >= 0 && старт < конец && конец <= input_.length )
            return input_[старт .. конец];
        return пусто;
    }

    /** ditto */
    т_ткст opIndex(бцел индекс)
    {
        return match(индекс);
    }

    /**********************************************************************************************
        Return the срез of the ввод that precedes the matched substring.
        If no match was найдено, пусто is returned.
    **********************************************************************************************/
    т_ткст pre()
    {
        auto старт = registers_[0];
        if ( старт < 0 )
            return пусто;
        return input_[0 .. last_start_+старт];
    }

    /**********************************************************************************************
        Return the срез of the ввод that follows the matched substring.
        If no match was найдено, the whole срез of the ввод that was processed in the последний тест.
    **********************************************************************************************/
    т_ткст post()
    {
        if ( registers_[1] >= 0 )
            return input_[next_start_ .. $];
        return input_[last_start_ .. $];
    }

    /**********************************************************************************************
        Splits the ввод at the matches of this regular expression преобр_в an Массив of slices.
        Example:
            ---
            import io.Stdout;
            import text.Regex;

            проц main()
            {
                auto strs = Regex("ab").разбей("abcabcababqwer");
                foreach( s; strs )
                    Стдвыв.форматнс("{}", s);
            }
            // Prints:
            // c
            // c
            // qwer
            ---
    **********************************************************************************************/
    т_ткст[] разбей(т_ткст ввод)
    {
        auto рез = new т_ткст[PREALLOC];
        бцел индекс;
        т_ткст врем = ввод;

        foreach ( r; search(ввод) )
        {
            врем = pre;
            рез[индекс++] = врем[last_start_ .. $];
            if ( индекс >= рез.length )
                рез.length = рез.length*2;
            врем = post;
        }

        рез[индекс++] = врем;
        рез.length = индекс;
        return рез;
    }

    /**********************************************************************************************
        Returns a копируй of the ввод with все matches replaced by replacement.
    **********************************************************************************************/
    т_ткст replaceAll(т_ткст ввод, т_ткст replacement, т_ткст output_buffer=пусто)
    {
        т_ткст врем = ввод;
        if ( output_buffer.length <= 0 )
            output_buffer = new т_сим[ввод.length+replacement.length];
        output_buffer.length = 0;

        foreach ( r; search(ввод) )
        {
            врем = pre;
            if ( врем.length > last_start_ )
                output_buffer ~= врем[last_start_ .. $];
            output_buffer ~= replacement;
            врем = post;
        }
        output_buffer ~= врем;
        return output_buffer;
    }

    /**********************************************************************************************
        Returns a копируй of the ввод with the последний match replaced by replacement.
    **********************************************************************************************/
    т_ткст replaceLast(т_ткст ввод, т_ткст replacement, т_ткст output_buffer=пусто)
    {
        т_ткст tmp_pre, tmp_post;
        if ( output_buffer.length <= 0 )
            output_buffer = new т_сим[ввод.length+replacement.length];
        output_buffer.length = 0;

        foreach ( r; search(ввод) ) {
            tmp_pre = pre;
            tmp_post = post;
        }

        if ( tmp_pre !is пусто || tmp_post !is пусто ) {
            output_buffer ~= tmp_pre;
            output_buffer ~= replacement;
            output_buffer ~= tmp_post;
        }
        else
            output_buffer ~= ввод;

        return output_buffer;
    }

    /**********************************************************************************************
        Returns a копируй of the ввод with the first match replaced by replacement.
    **********************************************************************************************/
    т_ткст replaceFirst(т_ткст ввод, т_ткст replacement, т_ткст output_buffer=пусто)
    {
        т_ткст врем = ввод;
        if ( output_buffer.length <= 0 )
            output_buffer = new т_сим[ввод.length+replacement.length];
        output_buffer.length = 0;

        if ( тест(ввод) )
        {
            врем = pre;
            if ( врем.length > last_start_ )
                output_buffer ~= врем[last_start_ .. $];
            output_buffer ~= replacement;
            врем = post;
        }
        output_buffer ~= врем;
        return output_buffer;
    }

    /**********************************************************************************************
        Calls дг for each match and replaces it with дг's return значение.
    **********************************************************************************************/
    т_ткст replaceAll(т_ткст ввод, т_ткст delegate(RegExpT!(т_сим)) дг, т_ткст output_buffer=пусто)
    {
        т_ткст    врем = ввод;
        бцел        смещение;
        if ( output_buffer.length <= 0 )
            output_buffer = new т_сим[ввод.length];
        output_buffer.length = 0;

        foreach ( r; search(ввод) )
        {
            врем = pre;
            if ( врем.length > last_start_ )
                output_buffer ~= врем[last_start_ .. $];
            output_buffer ~= дг(this);
            врем = post;
        }
        output_buffer ~= врем;
        return output_buffer;
    }

    /**********************************************************************************************
        Compiles the regular expression в_ D код.

        NOTE : Remember в_ import this module (text.Regex) in the module where you помести the
        generated D код.

    **********************************************************************************************/
    // TODO: ввод-конец special case
    ткст compileToD(ткст func_name = "match", бул lexer=нет)
    {
        ткст код;
        ткст str_type;
        static if ( is(т_сим == сим) )
            str_type = "ткст";
        static if ( is(т_сим == шим) )
            str_type = "шим[]";
        static if ( is(т_сим == дим) )
            str_type = "дим[]";

        if ( lexer )
            код = Формат.преобразуй("// {}\nbool {}({} ввод, out бцел token, out {} match", pattern_, func_name, str_type, str_type);
        else {
            код = Формат.преобразуй("// {}\nbool match({} ввод", pattern_, str_type);
            код ~= Формат.преобразуй(", ref {}[] groups", str_type);
        }
        код ~= Формат.преобразуй(")\n{{\n    бцел s = {};", tdfa_.старт.индекс);

        бцел num_vars = tdfa_.num_regs;
        if ( num_vars > 0 )
        {
            if ( lexer )
                код ~= "\n    static цел ";
            else
                код ~= "\n    цел ";
            бул first = да;
            for ( цел i = 0, used = 0; i < num_vars; ++i )
            {
                бул hasInit = нет;
                foreach ( cmd; tdfa_.initializer )
                {
                    if ( cmd.приёмн == i ) {
                        hasInit = да;
                        break;
                    }
                }

                if ( first )
                    first = нет;
                else
                    код ~= ", ";
                if ( used > 0 && used % 10 == 0 )
                    код ~= "\n        ";
                ++used;
                код ~= Формат.преобразуй("r{}", i);

                if ( hasInit )
                    код ~= "=0";
                else
                    код ~= "=-1";
            }
            код ~= ";";
        }

        код ~= "\n\n    for ( т_мера p, next_p; p < ввод.length; )\n    {";
        код ~= "\n        дим c = cast(дим)ввод[p];\n        if ( c & 0x80 )\n            раскодируй(ввод, next_p);";
        код ~= "\n        else\n            next_p = p+1;\n        switch ( s )\n        {";

        бцел[] finish_states;
        foreach ( s; tdfa_.states )
        {
            код ~= Формат.преобразуй("\n            case {}:", s.индекс);

            if ( s.прими )
            {
                finish_states ~= s.индекс;

                tdfa_t.Состояние мишень;
                foreach ( t; s.transitions )
                {
                    if ( мишень is пусто )
                        мишень = t.мишень;
                    else if ( мишень !is t.мишень )
                    {
                        мишень = пусто;
                        break;
                    }
                }
                if ( мишень !is пусто && мишень is s )
                    s.transitions = пусто;
            }

            бул first_if=да;
            charclass_t cc, ccTest;

            foreach ( t; s.transitions.сортируй )
            {
                ccTest.добавь(t.predicate.дайВвод);
                ccTest.оптимизируй;
                if ( t.predicate.дайВвод < ccTest )
                    cc = t.predicate.дайВвод;
                else
                    cc = ccTest;

                if ( first_if ) {
                    код ~= "\n                if ( ";
                    first_if = нет;
                }
                else
                    код ~= "\n                else if ( ";
                бул first_cond=да;
                foreach ( cr; cc.части )
                {
                    if ( first_cond )
                        first_cond = нет;
                    else
                        код ~= " || ";
                    if ( cr.l == cr.r )
                        код ~= Формат.преобразуй("c == 0x{:x}", cast(цел)cr.l);
                    else
                        код ~= Формат.преобразуй("c >= 0x{:x} && c <= 0x{:x}", cast(цел)cr.l, cast(цел)cr.r);
                }
                код ~= Формат.преобразуй(" ) {{\n                    s = {};", t.мишень.индекс);

                if ( t.predicate.тип == typeof(t.predicate.тип).используй )
                    код ~= "\n                    p = next_p;";
                foreach ( cmd; t.commands )
                    код ~= compileCommand(cmd, "                    ");
/*
                // if inp ends here and we do not already прими, try в_ добавь an explicit ткст/строка конец
                if ( p >= inp.length && !s.прими && c != 0 ) {
                    c = 0;
                    goto Lprocess_char;
                }
*/
                код ~= "\n                }";
            }

            if ( !first_if )
                код ~= Формат.преобразуй(
                    "\n                else\n                    {};\n                break;",
                    s.прими?Формат.преобразуй("goto финиш{}", s.индекс):"return нет"
                );
            else
                код ~= Формат.преобразуй("\n                {};", s.прими?Формат.преобразуй("goto финиш{}", s.индекс):"return нет");
        }

        // создай finisher groups
        бцел[][бцел] finisherGroup;
        foreach ( fs; finish_states )
        {
            // check if finisher группа with same commands есть_ли
            бул haveFinisher = нет;
            foreach ( fg; finisherGroup.ключи )
            {
                бул equalCommands = нет;
                if ( tdfa_.states[fs].finishers.length == tdfa_.states[fg].finishers.length )
                {
                    equalCommands = да;
                    foreach ( i, cmd; tdfa_.states[fs].finishers )
                    {
                        if ( cmd != tdfa_.states[fg].finishers[i] ) {
                            equalCommands = нет;
                            break;
                        }
                    }
                }
                if ( equalCommands ) {
                    // use existing группа for this состояние
                    finisherGroup[fg] ~= fs;
                    haveFinisher = да;
                    break;
                }
            }
            // создай new группа
            if ( !haveFinisher )
                finisherGroup[fs] ~= fs;
        }


        код ~= "\n            default:\n                assert(0);\n        }\n    }\n\n    switch ( s )\n    {";
        foreach ( группа, states; finisherGroup )
        {
            foreach ( s; states )
                код ~= Формат.преобразуй("\n        case {}: финиш{}:", s, s);

            foreach ( cmd; tdfa_.states[группа].finishers )
            {
                if ( lexer )
                {
                    if ( tdfa_.states[группа].finishers.length > 1 )
                        throw new ИсклРегВыр("Lexer ошибка: ещё than one finisher in flm lexer!");
                    if ( cmd.приёмн % 2 == 0 || cmd.приёмн >= tdfa_.num_tags )
                        throw new ИсклРегВыр(Формат.преобразуй("Lexer ошибка: unexpected приёмн регистрируй {} in flm lexer!", cmd.приёмн));
                    код ~= Формат.преобразуй("\n            match = ввод[0 .. r{}];\n            token = {};", cmd.ист, cmd.приёмн/2);
                }
                else
                    код ~= compileCommand(cmd, "            ");
            }

            код ~= "\n            break;";
        }
        код ~= "\n        default:\n            return нет;\n    }\n";

        if ( !lexer )
        {
            код ~= Формат.преобразуй("\n    groups.length = {};", tdfa_.num_tags/2);
            for ( цел i = 0; i < tdfa_.num_tags/2; ++i )
                код ~= Формат.преобразуй("\n    if ( r{} > -1 && r{} > -1 )\n        groups[{}] = ввод[r{} .. r{}];", 2*i, 2*i+1, i, 2*i, 2*i+1);
        }

        код ~= "\n    return да;\n}";
        return код;
    }

    /*********************************************************************************************
        Get the образец with which this regex was constructed. 
    **********************************************************************************************/
    public т_ткст образец() 
    { 
        return pattern_; 
    }

    /*********************************************************************************************
        Get the тэг счёт of this regex, representing the число of sub-matches. 

        This значение is the max valid значение for match/opIndex.
    **********************************************************************************************/
    бцел tagCount()
    {
        return tdfa_.num_tags;
    }

    цел[]       registers_;
    т_мера      next_start_,
                last_start_;

    debug(TangoRegex) tnfa_t tnfa_;
    tdfa_t      tdfa_;
private:
    const цел   PREALLOC = 16;
    т_ткст    input_,
                pattern_;

    ткст compileCommand(tdfa_t.Command cmd, т_ткст indent)
    {
        ткст  код,
                приёмн;
        код ~= Формат.преобразуй("\n{}r{} = ", indent, cmd.приёмн);
        if ( cmd.ист == tdfa_.CURRENT_POSITION_REGISTER )
            код ~= "p;";
        else
            код ~= Формат.преобразуй("r{};", cmd.ист);
        return код;
    }
}

alias RegExpT!(сим) Regex;

private alias ткст ткст;

debug(utf) import rt.core.stdc.stdio;
// the following block is stolen из_ phobos.
// the copyright notice applies for this block only.
/*
 *  Copyright (C) 2003-2004 by Digital Mars, www.digitalmars.com
 *  Written by Walter Bright
 *
 *  This software is provопрed 'as-is', without any express or implied
 *  warranty. In no событие will the authors be held liable for any damages
 *  arising из_ the use of this software.
 *
 *  Permission is granted в_ anyone в_ use this software for any purpose,
 *  включая commercial applications, and в_ alter it and redistribute it
 *  freely, субъект в_ the following restrictions:
 *
 *  o  The origin of this software must not be misrepresented; you must not
 *     claim that you wrote the original software. If you use this software
 *     in a product, an acknowledgment in the product documentation would be
 *     appreciated but is not required.
 *  o  Altered источник versions must be plainly marked as such, and must not
 *     be misrepresented as being the original software.
 *  o  This notice may not be removed or altered из_ any источник
 *     distribution.
 */

class ИсклУТФ : Исключение
{
    т_мера инд; /// индекс in ткст of where ошибка occurred

    this(ткст s, т_мера i)
    {
        инд = i;
        super(s);
    }
}

бул isValidDchar(дим c)
{
    /* Note: FFFE and FFFF are specifically permitted by the
     * Unicode стандарт for application internal use, but are not
     * allowed for interchange.
     * (thanks в_ Arcane Jill)
     */

    return c < 0xD800 ||
        (c > 0xDFFF && c <= 0x10FFFF /*&& c != 0xFFFE && c != 0xFFFF*/);
}

/* *************
 * Decodes and returns character starting at s[инд]. инд is advanced past the
 * decoded character. If the character is not well formed, a ИсклУТФ is
 * thrown and инд remains unchanged.
 */

дим раскодируй(in ткст s, ref т_мера инд)
    {
        т_мера длин = s.length;
        дим V;
        т_мера i = инд;
        сим u = s[i];

        if (u & 0x80)
        {   бцел n;
            сим u2;

            /* The following encodings are valid, except for the 5 and 6 байт
             * combinations:
             *  0xxxxxxx
             *  110xxxxx 10xxxxxx
             *  1110xxxx 10xxxxxx 10xxxxxx
             *  11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
             *  111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
             *  1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
             */
            for (n = 1; ; n++)
            {
                if (n > 4)
                    goto Lerr;          // only do the first 4 of 6 encodings
                if (((u << n) & 0x80) == 0)
                {
                    if (n == 1)
                        goto Lerr;
                    break;
                }
            }

            // Pick off (7 - n) significant биты of B из_ first байт of octet
            V = cast(дим)(u & ((1 << (7 - n)) - 1));

            if (i + (n - 1) >= длин)
                goto Lerr;                      // off конец of ткст

            /* The following combinations are overlong, and illegal:
             *  1100000x (10xxxxxx)
             *  11100000 100xxxxx (10xxxxxx)
             *  11110000 1000xxxx (10xxxxxx 10xxxxxx)
             *  11111000 10000xxx (10xxxxxx 10xxxxxx 10xxxxxx)
             *  11111100 100000xx (10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx)
             */
            u2 = s[i + 1];
            if ((u & 0xFE) == 0xC0 ||
                (u == 0xE0 && (u2 & 0xE0) == 0x80) ||
                (u == 0xF0 && (u2 & 0xF0) == 0x80) ||
                (u == 0xF8 && (u2 & 0xF8) == 0x80) ||
                (u == 0xFC && (u2 & 0xFC) == 0x80))
                goto Lerr;                      // overlong combination

            for (бцел j = 1; j != n; j++)
            {
                u = s[i + j];
                if ((u & 0xC0) != 0x80)
                    goto Lerr;                  // trailing байты are 10xxxxxx
                V = (V << 6) | (u & 0x3F);
            }
            if (!isValidDchar(V))
                goto Lerr;
            i += n;
        }
        else
        {
            V = cast(дим) u;
            i++;
        }

        инд = i;
        return V;

      Lerr:
        throw new Исключение("4invalid UTF-8 sequence");
    }

/*  ditto */

дим раскодируй(шим[] s, ref т_мера инд)
    in
    {
        assert(инд >= 0 && инд < s.length);
    }
    out (результат)
    {
        assert(isValidDchar(результат));
    }
    body
    {
        ткст сооб;
        дим V;
        т_мера i = инд;
        бцел u = s[i];

        if (u & ~0x7F)
        {   if (u >= 0xD800 && u <= 0xDBFF)
            {   бцел u2;

                if (i + 1 == s.length)
                {   сооб = "surrogate UTF-16 high значение past конец of ткст";
                    goto Lerr;
                }
                u2 = s[i + 1];
                if (u2 < 0xDC00 || u2 > 0xDFFF)
                {   сооб = "surrogate UTF-16 low значение out of range";
                    goto Lerr;
                }
                u = ((u - 0xD7C0) << 10) + (u2 - 0xDC00);
                i += 2;
            }
            else if (u >= 0xDC00 && u <= 0xDFFF)
            {   сооб = "unpaired surrogate UTF-16 значение";
                goto Lerr;
            }
            else if (u == 0xFFFE || u == 0xFFFF)
            {   сооб = "illegal UTF-16 значение";
                goto Lerr;
            }
            else
                i++;
        }
        else
        {
            i++;
        }

        инд = i;
        return cast(дим)u;

      Lerr:
        throw new ИсклУТФ(сооб, i);
    }

/*  ditto */

дим раскодируй(дим[] s, ref т_мера инд)
    in
    {
        assert(инд >= 0 && инд < s.length);
    }
    body
    {
        т_мера i = инд;
        дим c = s[i];

        if (!isValidDchar(c))
            goto Lerr;
        инд = i + 1;
        return c;

      Lerr:
        throw new ИсклУТФ("5invalid UTF-32 значение", i);
    }



/* =================== Encode ======================= */

/* *****************************
 * Encodes character c and appends it в_ Массив s[].
 */

проц кодируй(ref ткст s, дим c)
    in
    {
        assert(isValidDchar(c));
    }
    body
    {
        ткст r = s;

        if (c <= 0x7F)
        {
            r ~= cast(сим) c;
        }
        else
        {
            сим[4] буф;
            бцел L;

            if (c <= 0x7FF)
            {
                буф[0] = cast(сим)(0xC0 | (c >> 6));
                буф[1] = cast(сим)(0x80 | (c & 0x3F));
                L = 2;
            }
            else if (c <= 0xFFFF)
            {
                буф[0] = cast(сим)(0xE0 | (c >> 12));
                буф[1] = cast(сим)(0x80 | ((c >> 6) & 0x3F));
                буф[2] = cast(сим)(0x80 | (c & 0x3F));
                L = 3;
            }
            else if (c <= 0x10FFFF)
            {
                буф[0] = cast(сим)(0xF0 | (c >> 18));
                буф[1] = cast(сим)(0x80 | ((c >> 12) & 0x3F));
                буф[2] = cast(сим)(0x80 | ((c >> 6) & 0x3F));
                буф[3] = cast(сим)(0x80 | (c & 0x3F));
                L = 4;
            }
            else
            {
                assert(0);
            }
            r ~= буф[0 .. L];
        }
        s = r;
    }

/*  ditto */

проц кодируй(ref шим[] s, дим c)
    in
    {
        assert(isValidDchar(c));
    }
    body
    {
        шим[] r = s;

        if (c <= 0xFFFF)
        {
            r ~= cast(шим) c;
        }
        else
        {
            шим[2] буф;

            буф[0] = cast(шим) ((((c - 0x10000) >> 10) & 0x3FF) + 0xD800);
            буф[1] = cast(шим) (((c - 0x10000) & 0x3FF) + 0xDC00);
            r ~= буф;
        }
        s = r;
    }

/*  ditto */

проц кодируй(ref дим[] s, дим c)
    in
    {
        assert(isValidDchar(c));
    }
    body
    {
        s ~= c;
    }