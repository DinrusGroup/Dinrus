/*
Redistribution и use in source и binary forms, with or without
modification, are permitted provided that the following conditions
are met:

    Redistributions of source код must retain the above copyright
    notice, this list of conditions и the following disclaimer.

    Redistributions in binary form must reproduce the above
    copyright notice, this list of conditions и the following
    disclaimer in the documentation и/or друг materials provided
    with the ни в каком дистрибутиве.

    Neither имя of Victor Nakoryakov nor the names of
    its contributors may be использован to endorse or promote products
    derived from this software without specific приор written
    permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2006. Victor Nakoryakov.
*/
/**
В модуле содержатся основные числовые процедуры, часто используемые
в прочих модулях, либо применияемые в проектах, где используется линейная алгебра.

Authors:
    Victor Nakoryakov, nail-mail[at]mail.ru
*/
module linalg.basic;

import stdrus;
import linalg.config;

/**
Функция приблизительного равенства. Фактически копия функциии feqrel,
но с видоизменениями, делающими её пригодной для сравнения почти нулевых чисел.
However the cost of such possibility is little calculation overhead.

Params:
    x, y        = Numbers to сравни.
    отнпрец     = Minimal number of mantissa биты that have to be _equal in x и y
                  to suppose their's equality. Makes sense in comparisons of значения
                  enough far from ноль.
    абспрец     = If absolute difference between x и y is меньше than 2^(-абспрец)
                  they supposed to be _equal. Makes sense in comparisons of значения
                  enough near to ноль.
                
Возвращает:
    true if x и y are supposed to be _equal, false otherwise.
*/
бул равны(реал x, реал y, цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
{
    /* Author: Don Clugston, 18 Aug 2005.
     */

    if (x == y)
        return true; // ensure diff!=0, cope with INF.

    реал diff = фабс(x - y);
    
    бкрат *pa = cast(бкрат*)(&x);
    бкрат *pb = cast(бкрат*)(&y);
    бкрат *pd = cast(бкрат*)(&diff);

    // This проверь is added by me. If absolute difference between
    // x и y is меньше than 2^(-абспрец) then count them равны.
    if (pd[4] < 0x3FFF - абспрец)
        return true;

    // The difference in _абс(exponent) between x or y и _абс(x-y)
    // is равны to the number of mantissa биты of x which are
    // равны to y. If negative, x и y have different exponents.
    // If positive, x и y are равны to 'bitsdiff' биты.
    // AND with 0x7FFF to form the absolute value.
    // To avoid out-by-1 errors, we subtract 1 so it rounds down
    // if the exponents were different. This means 'bitsdiff' is
    // always 1 lower than we want, except that if bitsdiff==0,
    // they could have 0 or 1 биты in common.
    цел bitsdiff = ( ((pa[4]&0x7FFF) + (pb[4]&0x7FFF)-1)>>1) - pd[4];

    if (pd[4] == 0)
    {   // Difference is denormal
        // For denormals, we need to add the number of zeros that
        // lie at the start of diff's mantissa.
        // We do this by multiplying by 2^реал.mant_dig
        diff *= 0x1p+63;
        return bitsdiff + реал.mant_dig - pd[4] >= отнпрец;
    }

    if (bitsdiff > 0)
        return bitsdiff + 1 >= отнпрец; // add the 1 we subtracted before

    // Avoid out-by-1 errors when фактор is almost 2.
    return (bitsdiff == 0) ? (отнпрец <= 1) : false;
}


template РавенствоПоНорм(Т)
{
    бул равны(Т a, Т b, цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
    {
        return .равны((b - a).квадратНорм, 0.L, отнпрец, абспрец);
    }
}


бул меньше(реал a, реал b, цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
{
    return a < b && !равны(a, b, отнпрец, абспрец);
}


бул больше(реал a, реал b, цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
{
    return a > b && !равны(a, b, отнпрец, абспрец);
}

/**
Функция линейной интерполяции.
Возвращает:
    Значение, интерполированное из a в b по значению t. Если t не входит в диапазон [0; 1],
    то применяется линейная экстраполяция.
*/
реал лининтерп(реал a, реал b, реал t)
{
    return a * (1 - t) + b * t;
}


template Лининтерп(Т)
{
    Т лининтерп(Т a, Т b, реал t)
    {
        return a * (1 - t) + b * t;
    }
}

/**
Содержит функции мин и макс для генерных типов, обеспечивающих
opCmp.
*/
template МинМакс(Т)
{
    /**
    Возвращает:
        Наибольшее из a и b.
    */
    Т макс(Т a, Т b)
    {
        return (a > b) ? a : b;
    }

    /**
    Возвращает:
        Наименьшее из a и b.
    */
    Т мин(Т a, Т b)
    {
        return (a < b) ? a : b;
    }
}

/// Introduce мин и макс functions for basic numeric types.
alias МинМакс!(бул).мин     мин;
alias МинМакс!(бул).макс     макс; /// описано
alias МинМакс!(байт).мин     мин; /// описано
alias МинМакс!(байт).макс     макс; /// описано
alias МинМакс!(ббайт).мин    мин; /// описано
alias МинМакс!(ббайт).макс    макс; /// описано
alias МинМакс!(крат).мин    мин; /// описано
alias МинМакс!(крат).макс    макс; /// описано
alias МинМакс!(бкрат).мин   мин; /// описано
alias МинМакс!(бкрат).макс   макс; /// описано
alias МинМакс!(цел).мин      мин; /// описано
alias МинМакс!(цел).макс      макс; /// описано
alias МинМакс!(бцел).мин     мин; /// описано
alias МинМакс!(бцел).макс     макс; /// описано
alias МинМакс!(дол).мин     мин; /// описано
alias МинМакс!(дол).макс     макс; /// описано
alias МинМакс!(бдол).мин    мин; /// описано
alias МинМакс!(бдол).макс    макс; /// описано
alias МинМакс!(плав).мин    мин; /// описано
alias МинМакс!(плав).макс    макс; /// описано
alias МинМакс!(дво).мин   мин; /// описано
alias МинМакс!(дво).макс   макс; /// описано
alias МинМакс!(реал).мин     мин; /// описано
alias МинМакс!(реал).макс     макс; /// описано


/**
Contains clamping functions for генерный types to which мин и макс
functions can be applied.
*/
template Закрепи(Т)
{
    /**
    Makes value of x to be not меньше than беск. Method can change value of x.
    Возвращает:
        Copy of x after clamping is applied.
    */
    Т закрепиПод(inout Т x, Т беск)
    {
        return x = макс(x, беск);
    }

    /**
    Makes value of x to be not больше than sup. Method can change value of x.
    Возвращает:
        Copy of x after clamping is applied.
    */
    Т закрепиНад(inout Т x, Т sup)
    {
        return x = мин(x, sup);
    }

    /**
    Makes value of x to be nor меньше than беск nor больше than sup.
    Method can change value of x.
    Возвращает:
        Copy of x after clamping is applied.
    */
    Т закрепи(inout Т x, Т беск, Т sup)
    {
        закрепиПод(x, беск);
        return закрепиНад(x, sup);
    }
}

/// Introduce clamping functions for basic numeric types.
alias Закрепи!(бул).закрепиПод   закрепиПод;
alias Закрепи!(бул).закрепиНад   закрепиНад; /// описано
alias Закрепи!(бул).закрепи        закрепи;      /// описано
alias Закрепи!(байт).закрепиПод   закрепиПод; /// описано
alias Закрепи!(байт).закрепиНад   закрепиНад; /// описано
alias Закрепи!(байт).закрепи        закрепи;      /// описано
alias Закрепи!(ббайт).закрепиПод  закрепиПод; /// описано
alias Закрепи!(ббайт).закрепиНад  закрепиНад; /// описано
alias Закрепи!(ббайт).закрепи       закрепи;      /// описано
alias Закрепи!(крат).закрепиПод  закрепиПод; /// описано
alias Закрепи!(крат).закрепиНад  закрепиНад; /// описано
alias Закрепи!(крат).закрепи       закрепи;      /// описано
alias Закрепи!(бкрат).закрепиПод закрепиПод; /// описано
alias Закрепи!(бкрат).закрепиНад закрепиНад; /// описано
alias Закрепи!(бкрат).закрепи      закрепи;      /// описано
alias Закрепи!(цел).закрепиПод    закрепиПод; /// описано
alias Закрепи!(цел).закрепиНад    закрепиНад; /// описано
alias Закрепи!(цел).закрепи         закрепи;      /// описано
alias Закрепи!(бцел).закрепиПод   закрепиПод; /// описано
alias Закрепи!(бцел).закрепиНад   закрепиНад; /// описано
alias Закрепи!(бцел).закрепи        закрепи;      /// описано
alias Закрепи!(дол).закрепиПод   закрепиПод; /// описано
alias Закрепи!(дол).закрепиНад   закрепиНад; /// описано
alias Закрепи!(дол).закрепи        закрепи;      /// описано
alias Закрепи!(бдол).закрепиПод  закрепиПод; /// описано
alias Закрепи!(бдол).закрепиНад  закрепиНад; /// описано
alias Закрепи!(бдол).закрепи       закрепи;      /// описано
alias Закрепи!(плав).закрепиПод  закрепиПод; /// описано
alias Закрепи!(плав).закрепиНад  закрепиНад; /// описано
alias Закрепи!(плав).закрепи       закрепи;      /// описано
alias Закрепи!(дво).закрепиПод закрепиПод; /// описано
alias Закрепи!(дво).закрепиНад закрепиНад; /// описано
alias Закрепи!(дво).закрепи      закрепи;      /// описано
alias Закрепи!(реал).закрепиПод   закрепиПод; /// описано
alias Закрепи!(реал).закрепиНад   закрепиНад; /// описано
alias Закрепи!(реал).закрепи        закрепи;      /// описано

/** Contains переставь function for генерный types. */
template ПростойПерестанов(Т)
{
    /** Swaps значения of a и b. */
    void переставь(inout Т a, inout Т b)
    {
        Т temp = a;
        a = b;
        b = temp;
    }
}

/// Introduces переставь function for basic numeric types.
alias ПростойПерестанов!(бул).переставь   переставь;
alias ПростойПерестанов!(байт).переставь   переставь; /// описано
alias ПростойПерестанов!(ббайт).переставь  переставь; /// описано
alias ПростойПерестанов!(крат).переставь  переставь; /// описано
alias ПростойПерестанов!(бкрат).переставь переставь; /// описано
alias ПростойПерестанов!(цел).переставь    переставь; /// описано
alias ПростойПерестанов!(бцел).переставь   переставь; /// описано
alias ПростойПерестанов!(дол).переставь   переставь; /// описано
alias ПростойПерестанов!(бдол).переставь  переставь; /// описано
alias ПростойПерестанов!(плав).переставь  переставь; /// описано
alias ПростойПерестанов!(дво).переставь переставь; /// описано
alias ПростойПерестанов!(реал).переставь   переставь; /// описано
