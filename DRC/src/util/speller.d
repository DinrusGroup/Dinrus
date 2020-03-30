/**
 * Compiler implementation of the D programming language
 * http://dlang.org
 *
 * Copyright: Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:   Walter Bright, http://www.digitalmars.com
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:    $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/root/speller.d, root/_speller.d)
 * Documentation:  https://dlang.org/phobos/dmd_root_speller.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/root/speller.d
 */

module util.speller;

import cidrus;

const ткст idchars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_";

/**************************************************
 * combine a new результат from the spell checker to
 * найди the one with the closest symbol with
 * respect to the cost defined by the search function
 * Input/Output:
 *      p       best found spelling (NULL if none found yet)
 *      cost    cost of p (цел.max if none found yet)
 * Input:
 *      np      new found spelling (NULL if none found)
 *      ncost   cost of np if non-NULL
 * Возвращает:
 *      да    if the cost is less or equal 0
 *      нет   otherwise
 */
private бул combineSpellerрезультат(T)(ref T p, ref цел cost, T np, цел ncost)
{
    if (np && ncost < cost)
    {
        p = np;
        cost = ncost;
        if (cost <= 0)
            return да;
    }
    return нет;
}

private T spellerY(alias dg)(ткст seed, т_мера index, ref цел cost)
{
    if (!seed.length)
        return null;
    сим[30] tmp;
    ткст буф;
    if (seed.length <= tmp.sizeof - 1)
        буф = tmp;
    else
    {
        буф = (cast(сим*)alloca(seed.length + 1))[0 .. seed.length + 1]; // leave space for extra сим
        if (!буф.ptr)
            return null; // no matches
    }
    буф[0 .. index] = seed[0 .. index];
    cost = цел.max;
    searchFunctionType!(dg) p = null;
    цел ncost;
    /* Delete at seed[index] */
    if (index < seed.length)
    {
        буф[index .. seed.length - 1] = seed[index + 1 .. $];
        auto np = dg(буф[0 .. seed.length - 1], ncost);
        if (combineSpellerрезультат(p, cost, np, ncost))
            return p;
    }
    /* Substitutions */
    if (index < seed.length)
    {
        буф[0 .. seed.length] = seed;
        foreach (s; idchars)
        {
            буф[index] = s;
            //printf("sub буф = '%s'\n", буф);
            auto np = dg(буф[0 .. seed.length], ncost);
            if (combineSpellerрезультат(p, cost, np, ncost))
                return p;
        }
    }
    /* Insertions */
    буф[index + 1 .. seed.length + 1] = seed[index .. $];
    foreach (s; idchars)
    {
        буф[index] = s;
        //printf("ins буф = '%s'\n", буф);
        auto np = dg(буф[0 .. seed.length + 1], ncost);
        if (combineSpellerрезультат(p, cost, np, ncost))
            return p;
    }
    return p; // return "best" результат
}

private T spellerX(alias dg)(ткст seed, бул флаг)
{
    if (!seed.length)
        return null;
    сим[30] tmp;
    ткст буф;
    if (seed.length <= tmp.sizeof - 1)
        буф = tmp;
    else
    {
        буф = (cast(сим*)alloca(seed.length + 1))[0 .. seed.length + 1]; // leave space for extra сим
    }
    цел cost = цел.max, ncost;
    searchFunctionType!(dg) p = null, np;
    /* Deletions */
    буф[0 .. seed.length - 1] = seed[1 .. $];
    for (т_мера i = 0; i < seed.length; i++)
    {
        //printf("del буф = '%s'\n", буф);
        if (флаг)
            np = spellerY!(dg)(буф[0 .. seed.length - 1], i, ncost);
        else
            np = dg(буф[0 .. seed.length - 1], ncost);
        if (combineSpellerрезультат(p, cost, np, ncost))
            return p;
        буф[i] = seed[i];
    }
    /* Transpositions */
    if (!флаг)
    {
        буф[0 .. seed.length] = seed;
        for (т_мера i = 0; i + 1 < seed.length; i++)
        {
            // swap [i] and [i + 1]
            буф[i] = seed[i + 1];
            буф[i + 1] = seed[i];
            //printf("tra буф = '%s'\n", буф);
            if (combineSpellerрезультат(p, cost, dg(буф[0 .. seed.length], ncost), ncost))
                return p;
            буф[i] = seed[i];
        }
    }
    /* Substitutions */
    буф[0 .. seed.length] = seed;
    for (т_мера i = 0; i < seed.length; i++)
    {
        foreach (s; idchars)
        {
            буф[i] = s;
            //printf("sub буф = '%s'\n", буф);
            if (флаг)
                np = spellerY!(dg)(буф[0 .. seed.length], i + 1, ncost);
            else
                np = dg(буф[0 .. seed.length], ncost);
            if (combineSpellerрезультат(p, cost, np, ncost))
                return p;
        }
        буф[i] = seed[i];
    }
    /* Insertions */
    буф[1 .. seed.length + 1] = seed;
    for (т_мера i = 0; i <= seed.length; i++) // yes, do seed.length+1 iterations
    {
        foreach (s; idchars)
        {
            буф[i] = s;
            //printf("ins буф = '%s'\n", буф);
            if (флаг)
                np = spellerY!(dg)(буф[0 .. seed.length + 1], i + 1, ncost);
            else
                np = dg(буф[0 .. seed.length + 1], ncost);
            if (combineSpellerрезультат(p, cost, np, ncost))
                return p;
        }
        if (i < seed.length)
            буф[i] = seed[i];
    }
    return p; // return "best" результат
}

/**************************************************
 * Looks for correct spelling.
 * Currently only looks a 'distance' of one from the seed[].
 * This does an exhaustive search, so can potentially be very slow.
 * Параметры:
 *      seed = wrongly spelled word
 *      dg = search delegate
 * Возвращает:
 *      null = no correct spellings found, otherwise
 *      the значение returned by dg() for first possible correct spelling
 */
T speller(alias dg)(ткст seed)
{
    if (isSearchFunction!(dg))
    {
        т_мера maxdist = seed.length < 4 ? seed.length / 2 : 2;
        for (цел distance = 0; distance < maxdist; distance++)
        {
            auto p = spellerX!(dg)(seed, distance > 0);
            if (p)
                return p;
            //      if (seedlen > 10)
            //          break;
        }
        return null; // didn't найди it
    }
}

//enum isSearchFunction(alias fun) = is(searchFunctionType!(fun));     
//alias  typeof(() {цел x; return fun("", x);}()) searchFunctionType(alias fun);

unittest
{
    static const ткст[][] cases =
    [
        ["hello", "hell", "y"],
        ["hello", "hel", "y"],
        ["hello", "ello", "y"],
        ["hello", "llo", "y"],
        ["hello", "hellox", "y"],
        ["hello", "helloxy", "y"],
        ["hello", "xhello", "y"],
        ["hello", "xyhello", "y"],
        ["hello", "ehllo", "y"],
        ["hello", "helol", "y"],
        ["hello", "abcd", "n"],
        ["hello", "helxxlo", "y"],
        ["hello", "ehlxxlo", "n"],
        ["hello", "heaao", "y"],
        ["_123456789_123456789_123456789_123456789", "_123456789_123456789_123456789_12345678", "y"],
    ];
    //printf("unittest_speller()\n");

    ткст dgarg;

    ткст speller_test(ткст s, ref цел cost)
    {
        assert(s[$-1] != '\0');
        //printf("speller_test(%s, %s)\n", dgarg, s);
        cost = 0;
        if (dgarg == s)
            return dgarg;
        return null;
    }

    dgarg = "hell";
    auto p = speller!(speller_test)("hello");
    assert(p !is null);
    foreach (testCase; cases)
    {
        //printf("case [%d]\n", i);
        dgarg = testCase[1];
        auto p2 = speller!(speller_test)(testCase[0]);
        if (p2)
            assert(testCase[2][0] == 'y');
        else
            assert(testCase[2][0] == 'n');
    }
    //printf("unittest_speller() успех\n");
}
