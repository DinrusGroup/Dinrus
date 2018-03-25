module util.str;

private{
    static import util.linetoken;
    static import util.booltype;   // definition of Да и Нет
    alias util.booltype.Да Да;
    alias util.booltype.Нет Нет;
    alias util.booltype.Бул Бул;

    import stdrus;
    // --------- C externals ----------------
    extern (C)
    {
        сим*   getenv  (сим *);
        цел     putenv  (сим *);
    }
}
debug = стр;
public{



///topic Strings
///proc замениСим(inout stringtype pText, дим pFrom, дим pTo)
///desc Replace all occurances a character with another.
//This examines each character in /i pText и where it совпадает /i pFrom
// it is replaced with /i pTo. /n
///b Note that /i pText can be a /ткст, /шим[], /юткст or /ббайт[] datatypes. /n
///b Note that if /i pText is a ббайт[] тип, the /i pFrom и /i pTo must
//be either /b ббайт or /b сим datatypes.
//
//Example:
///код
//  ткст test;
//  test = "abc,de,frgh,ijk,kmn";
//  замениСим( test, ',', ':');
//  assert(test == "abc:de:frgh:ijk:kmn");
///endcode

//----------------------------------------------------------
ббайт[] замениСим(in ббайт[] pText, ббайт pFrom, ббайт pTo)
//----------------------------------------------------------
out (pResult){
    ббайт[] lTempA;
    ббайт[] lTempB;

    assert( ! (pResult is пусто) );

    lTempA = pText;
    lTempB = pResult;
    assert(lTempA.length == lTempB.length);
    if ( pFrom != pTo)
    {
        foreach (бцел i, ббайт c; lTempA)
        {
            if (c == pFrom)
            {
                assert(pTo == lTempB[i]);
            }
            else
            {
                assert(lTempA[i] == lTempB[i]);
            }
        }
    }
    else
        assert(lTempA == lTempB);
}
body {

    if (pFrom == pTo)
        return pText;

    foreach( бцел i, inout ббайт lTestChar; pText)
    {
        if(lTestChar == pFrom) {
            ббайт[] lTemp = pText.dup;
            foreach( inout ббайт lNextChar; lTemp[i .. length]){
                if(lNextChar == pFrom) {
                    lNextChar = pTo;
                }
            }

            return lTemp;
        }
        else {
            if (i == pText.length-1)
            {
                return pText;
            }
            else
                continue;
        }

    }
    return pText;
}

//----------------------------------------------------------
ббайт[] замениСим(in ббайт[] pText, сим pFrom, сим pTo)
//----------------------------------------------------------
{
    return замениСим( pText, cast(ббайт)pFrom, cast(ббайт)pTo);
}


//----------------------------------------------------------
юткст замениСим(in юткст pText, дим pFrom, дим pTo)
//----------------------------------------------------------
out (pResult){
    юткст lTempA;
    юткст lTempB;

    assert( ! (pResult is пусто) );

    lTempA = pText;
    lTempB = pResult;
    assert(lTempA.length == lTempB.length);
    if ( pFrom != pTo)
    {
        foreach (бцел i, дим c; lTempA)
        {
            if (c == pFrom)
            {
                assert(pTo == lTempB[i]);
            }
            else
            {
                assert(lTempA[i] == lTempB[i]);
            }
        }
    }
    else
        assert(lTempA == lTempB);
}
body {
    if (pFrom == pTo)
        return pText;

    else {
    foreach( бцел i, inout дим lTestChar; pText){
        if(lTestChar == pFrom) {
            юткст lTemp = pText.dup;
            foreach( inout дим lNextChar; lTemp[i .. length]){
                if(lNextChar == pFrom) {
                    lNextChar = pTo;
                }
            }

            return lTemp;
        }


    }
    // If I дай here, no changes were done.
    return pText;
}
}


//----------------------------------------------------------
ткст замениСим(in ткст pText, дим pFrom, дим pTo)
//----------------------------------------------------------
body {

    return вЮ8( замениСим( вЮ32(pText), pFrom, pTo) );

}

//----------------------------------------------------------
шткст замениСим(in шткст pText, дим pFrom, дим pTo)
//----------------------------------------------------------
body {

    return вЮ16( замениСим( вЮ32(pText), pFrom, pTo) );

}

//----------------------------------------------------------
ббайт[] вТкстН(ббайт[] pData)
//----------------------------------------------------------
{
    ббайт[] lTemp;

    lTemp = pData.dup;
    lTemp ~= '\0';
    return lTemp;
}

//----------------------------------------------------------
ткст вТкстН(ткст pData)
//----------------------------------------------------------
{
    ткст lTemp;

    lTemp = pData.dup;
    lTemp ~= '\0';
    return lTemp;
}

//----------------------------------------------------------
ббайт[] вТкстА(ткст pData)
//----------------------------------------------------------
{
    ббайт[] lTemp;

    lTemp.length = pData.length;
    foreach( цел i, сим lCurrChar; pData)
    {
        lTemp[i] = cast(ббайт)lCurrChar;
    }

    return lTemp;
}
//----------------------------------------------------------
ббайт[] вТкстА(шткст pData)
//----------------------------------------------------------
{
    ббайт[] lTemp;
    ткст lInter;

    lInter = вЮ8( pData );
    lTemp.length = lInter.length;
    foreach( цел i, сим lCurrChar; lInter)
    {
        lTemp[i] = cast(ббайт)lCurrChar;
    }

    return lTemp;
}
//----------------------------------------------------------
ббайт[] вТкстА(юткст pData)
//----------------------------------------------------------
{
    ббайт[] lTemp;
    ткст lInter;

    lInter = вЮ8( pData );
    lTemp.length = lInter.length;
    foreach( цел i, сим lCurrChar; lInter)
    {
        lTemp[i] = cast(ббайт)lCurrChar;
    }

    return lTemp;
}
}

//----------------------------------------------------------
//----------------------------------------------------------
//----------------------------------------------------------
unittest{
    debug(стр) скажифнс("%s", "стр.UT01: b = замениСим ( ткст a, lit, lit) ");
    ткст testA;
    ткст testB;
    ткст testC;

    testA = "abcdbefbq";
    testB = "a cd ef q";
    testC = замениСим(testA, 'b', ' ');
    assert( testC == testB);
    assert( testA != testB);
}

unittest{
    debug(стр)  скажифнс("%s", "стр.UT02: a = замениСим ( ткст a, lit, lit) ");
    ткст testA;
    ткст testB;
    ткст testC;

    testA = "abcdbefbq";
    testB = "a cd ef q";
    testA = замениСим(testA, 'b', ' ');
    assert( testA == testB);
}

unittest{
    debug(стр)  скажифнс("%s", "стр.UT03: замениСим ( ткст, 'b', 'b') ");
    ткст testA;
    ткст testB;
    ткст testC;

    testA = "abcdbefbq";
    testB = "abcdbefbq";
    testC = замениСим(testA, 'b', 'b');
    assert( testC == testB);
    assert( testA == testB);
}

unittest{
    debug(стр)  скажифнс("%s", "стр.UT04: замениСим ( шим[], lit, lit) ");
    шткст testA;
    шткст testB;
    шткст testC;

    testA = "abcdbefbq";
    testB = "a cd ef q";
    testC = замениСим(testA, 'b', ' ');
    assert( testC == testB);
    assert( testA != testB);
}

unittest{
    debug(стр)  скажифнс("%s", "стр.UT05: замениСим ( дим[], lit, lit) ");
    юткст testA;
    юткст testB;
    юткст testC;

    testA = "abcdbefbq";
    testB = "a cd ef q";
    testC = замениСим(testA, 'b', ' ');
    assert( testC == testB);
    assert( testA != testB);
}

unittest{
    debug(стр)  скажифнс("%s", "стр.UT06: замениСим ( ткст, шим, шим) ");
    ткст testA;
    ткст testB;
    ткст testC;
    шим f,t;

    testA = "abcdbefbq";
    testB = "a cd ef q";
    f = 'b';
    t = ' ';
    testC = замениСим(testA, f, t);
    assert( testC == testB);
    assert( testA != testB);

}

unittest{
    debug(стр)  скажифнс("%s", "стр.UT07: замениСим ( дим[], дим, дим) ");
    юткст testA;
    юткст testB;
    юткст testC;
    дим f,t;

    testA = "abcdbefbq";
    testB = "axcdxefxq";
    f = 'b';
    t = 'x';
    testC = замениСим(testA, f, t);
    assert( testC == testB);
    assert( testA != testB);
}

unittest{
    debug(стр)  скажифнс("%s", "стр.UT08: замениСим ( ббайт[], ббайт, ббайт) ");
    ббайт[] testA;
    ббайт[] testB;
    ббайт[] testC;
    ббайт f,t;

    testA = вТкстА(cast(ткст)"abcdbefbq");
    testB = вТкстА(cast(ткст)"a cd ef q");
    f = 'b';
    t = ' ';
    testC = замениСим(testA, f, t);
    assert( testC == testB);
    assert( testA != testB);
}

unittest{
    debug(стр)  скажифнс("%s", "стр.UT09: замениСим ( ббайт[], сим, сим) ");
    ббайт[] testA;
    ббайт[] testB;
    ббайт[] testC;
    сим f,t;

    testA = вТкстА(cast(ткст)"abcdbefbq");
    testB = вТкстА(cast(ткст)"a cd ef q");
    f = 'b';
    t = ' ';
    testC = замениСим(testA, f, t);
    assert( testC == testB);
    assert( testA != testB);
}

    // ---- вТкстА() -----
unittest{
    debug(стр)  скажифнс("%s", "стр.UT10: вТкстА( ткст) ");
    ббайт[] testA;
    ткст testB;
    ббайт[] testC;
    цел c;

    testB = "abcdef";
    testA = вТкстА(testB);
    c = 0;
    assert(testA.length == testB.length);
    foreach (бцел i, ббайт x; testA)
    {
        if (x == testB[i])
            c++;
    }
    assert( c == testA.length);
}

unittest{
    debug(стр)  скажифнс("%s", "стр.UT11: вТкстА( шим[]) ");
    ббайт[] testA;
    шткст testB;
    ббайт[] testC;
    цел c;

    testB = "abcdef";
    testA = вТкстА(testB);
    c = 0;
    assert(testA.length == testB.length);
    foreach (бцел i, ббайт x; testA)
    {
        if (x == testB[i])
            c++;
    }
    assert( c == testA.length);
}

unittest{
    debug(стр)  скажифнс("%s", "стр.UT12: вТкстА( дим[]) ");
    ббайт[] testA;
    юткст testB;
    ббайт[] testC;
    цел c;

    testB = "abcdef";
    testA = вТкстА(testB);
    c = 0;
    assert(testA.length == testB.length);
    foreach (бцел i, ббайт x; testA)
    {
        if (x == testB[i])
            c++;
    }
    assert( c == testA.length);
}

public {
/*
    подобен_ли does a simple pattern совпадают process. The pattern
    string can contain special токены ...
       '*'   Represents zero or more characters in the text.
       '?'   Represents exactly one character in the text.
       '\'   Is the escape pattern. The next text character
             must exactly сверь the character following the
             escape character. This is использован to сверь the
             токены if they appear in the text.


*/
Бул подобен_ли(юткст pText, юткст pPattern)
body {
    const дим kZeroOrMore = '*';
    const дим kExactlyOne = '?';
    const дим kEscape     = '\\';
    бцел  lTX = 0;
    бцел  lPX = 0;
    бцел  lPMark;
    бцел  lTMark;

    lPMark = pPattern.length;
    lTMark = 0;

    // If we haven't got any pattern or text left then we can finish.
    while(lPX < pPattern.length && lTX < pText.length)
    {
        if (pPattern[lPX] == kZeroOrMore)
        {
            // Skip over any adjacent '*'
            while( lPX < pPattern.length &&
                   pPattern[lPX] == kZeroOrMore)
            {
                lPMark = lPX;
                lPX++;
            }

            // Look for next сверь in text for текущ pattern сим
            if ( lPX >= pPattern.length)
            {
                // Skip rest of text if there is no pattern left. This
                // can occur when the pattern оканчивается_на with a '*'.
                lTX = pText.length;
            }
            else while( lPX < pPattern.length && lTX < pText.length)
            {
                // Skip over any escape lead-in сим.
                if (pPattern[lPX] == kEscape && lPX < pPattern.length - 1)
                    lPX++;

                if (pPattern[lPX] == pText[lTX] ||
                    pPattern[lPX] == kExactlyOne)
                {
                    // We found the start of a potentially совпадают sequence.
                    // so increment over the совпадают сим in preparation
                    // for a new subsequence scan.
                    lPX++;
                    lTX++;
                    // Mark the place in the text in case we have to do
                    // a rescan later.
                    lTMark = lTX;

                    // Stop doing this subsequence scan.
                    break;
                }
                else
                {
                    // No сверь found yet, so look at the next text сим.
                    lTX++;
                }
            }
        }
        else if (pPattern[lPX] == kExactlyOne)
        {
            // Don't bother comparing the text сим, just assume it совпадает.
            lTX++;
            lPX++;
        }
        else
        {
            if (pPattern[lPX] == kEscape)
            {
                // Skip over the escape lead-in сим.
                lPX++;
            }

            if (pText[lTX] == pPattern[lPX])
            {
                // Text сим совпадает pattern сим so slide both to next сим.
                lTX++;
                lPX++;
            }
            else
            {
                // Non-сверь, so установи index to последний проверь point значения,
                // и try a new subsequence scan.
                lPX = lPMark;
                lTX = lTMark;
            }
        }
    }

    if (lTX >= pText.length)
    {
        // Skip over any final '*' in pattern.
        while( lPX < pPattern.length && pPattern[lPX] == kZeroOrMore)
        {
            lPX++;
        }
    }

    // If I have no text и no pattern left then the text matched the pattern.
    if (lTX >= pText.length  && lPX >= pPattern.length)
        return Да;
    // otherwise it doesn't.
    return Нет;
}

Бул подобен_ли(ткст pText, ткст pPattern )
{
    return подобен_ли( вЮ32(pText), вЮ32(pPattern));
}

}


//-------------------------------------------------------
Бул начинается_с(ткст pString, ткст pSubString)
//-------------------------------------------------------
{
    return начинается_с( вЮ32(pString), вЮ32(pSubString));
}

//-------------------------------------------------------
Бул начинается_с(шткст pString, шткст pSubString)
//-------------------------------------------------------
{
    return начинается_с( вЮ32(pString), вЮ32(pSubString));
}

//-------------------------------------------------------
Бул начинается_с(юткст pString, юткст pSubString)
//-------------------------------------------------------
{
    if (pString.length < pSubString.length)
        return Нет;
    if (pSubString.length == 0)
        return Нет;

    if (pString[0..pSubString.length] == pSubString)
        return Да;
    return Нет;
}

//-------------------------------------------------------
Бул оканчивается_на(ткст pString, ткст pSubString)
//-------------------------------------------------------
{
    return оканчивается_на( вЮ32(pString), вЮ32(pSubString));
}

//-------------------------------------------------------
Бул оканчивается_на(шткст pString, шткст pSubString)
//-------------------------------------------------------
{
    return оканчивается_на( вЮ32(pString), вЮ32(pSubString));
}

//-------------------------------------------------------
Бул оканчивается_на(юткст pString, юткст pSubString)
//-------------------------------------------------------
{
    бцел lРазмер;

    if (pString.length < pSubString.length)
        return Нет;
    if (pSubString.length == 0)
        return Нет;

    lРазмер = pString.length-pSubString.length;
    if (pString[lРазмер .. $] != pSubString)
        return Нет;

    return Да;
}


//-------------------------------------------------------
ткст в_кавычках(ткст pString, сим pTrigger = ' ', ткст pPrefix = `"`, ткст pSuffix = `"`)
//-------------------------------------------------------
{
    if ( (pString.length > 0) &&
         (stdrus.найди(pString, pTrigger) != -1) &&
		 (начинается_с(pString, pPrefix) == Нет) &&
		 (оканчивается_на(pString, pSuffix) == Нет)
       )
        return pPrefix ~ pString ~ pSuffix;

    return pString;
}

//-------------------------------------------------------
шткст в_кавычках(шткст pString, шим pTrigger = ' ', шткст pPrefix = `"`, шткст pSuffix = `"`)
//-------------------------------------------------------
{
    шткст lTrigger;
    lTrigger.length = 1;
    lTrigger[0] = pTrigger;
    if ( (pString.length > 0) &&
         (найди(pString, lTrigger,0 ) != -1) &&
		 (начинается_с(pString, pPrefix) == Нет) &&
		 (оканчивается_на(pString, pSuffix) == Нет)
       )
        return pPrefix ~ pString ~ pSuffix;

    return pString;
}

//-------------------------------------------------------
юткст в_кавычках(юткст pString, дим pTrigger = ' ', юткст pPrefix = `"`, юткст pSuffix = `"`)
//-------------------------------------------------------
{
    юткст lTrigger;
    lTrigger.length = 1;
    lTrigger[0] = pTrigger;
    if ( (pString.length > 0) &&
         (найди(pString, lTrigger,0) != -1) &&
		 (начинается_с(pString, pPrefix) == Нет) &&
		 (оканчивается_на(pString, pSuffix) == Нет)
       )
        return pPrefix ~ pString ~ pSuffix;

    return pString;
}

unittest
{ // подобен_ли
     debug(стр)  скажифнс("стр.подобен_ли.UT00");
     assert( подобен_ли( "foobar"c, "foo?*"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT01");
     assert( подобен_ли( "foobar"c, "foo*"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT02");
     assert( подобен_ли( "foobar"c, "*bar"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT03");
     assert( подобен_ли( ""c, "foo*"c) == Нет);
     debug(стр)  скажифнс("стр.подобен_ли.UT04");
     assert( подобен_ли( ""c, "*bar"c) == Нет);
     debug(стр)  скажифнс("стр.подобен_ли.UT05");
     assert( подобен_ли( ""c, "?"c) == Нет);
     debug(стр)  скажифнс("стр.подобен_ли.UT06");
     assert( подобен_ли( ""c, "*"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT06a");
     assert( подобен_ли( ""c, "x"c) == Нет);
     debug(стр)  скажифнс("стр.подобен_ли.UT06b");
     assert( подобен_ли( "x"c, ""c) == Нет);
     debug(стр)  скажифнс("стр.подобен_ли.UT07");
     assert( подобен_ли( "f"c, "?"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT08");
     assert( подобен_ли( "f"c, "*"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT09");
     assert( подобен_ли( "foo"c, "?oo"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT10");
     assert( подобен_ли( "foobar"c, "?oo"c) == Нет);
     debug(стр)  скажифнс("стр.подобен_ли.UT11");
     assert( подобен_ли( "foobar"c, "?oo*"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT12");
     assert( подобен_ли( "foobar"c, "*oo*b*"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT13");
     assert( подобен_ли( "foobar"c, "*oo*ar"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT14");
     assert( подобен_ли( "terrainformatica.com"c, "*.com"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT15");
     assert( подобен_ли( "12abcdef"c, "*abc?e*"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT16");
     assert( подобен_ли( "12abcdef"c, "**abc?e**"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT17");
     assert( подобен_ли( "12abcdef"c, "*"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT18");
     assert( подобен_ли( "12abcdef"c, "?*"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT19");
     assert( подобен_ли( "12abcdef"c, "*?"c) == Нет);
     debug(стр)  скажифнс("стр.подобен_ли.UT20");
     assert( подобен_ли( "12abcdef"c, "?*?"c) == Нет);
     debug(стр)  скажифнс("стр.подобен_ли.UT21");
     assert( подобен_ли( "12abcdef"c, "*?*"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT22");
     assert( подобен_ли( "12"c, "??"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT23");
     assert( подобен_ли( "123"c, "??"c) == Нет);
     debug(стр)  скажифнс("стр.подобен_ли.UT24");
     assert( подобен_ли( "12"c, "??3"c) == Нет);
     debug(стр)  скажифнс("стр.подобен_ли.UT25");
     assert( подобен_ли( "12"c, "???"c) == Нет);
     debug(стр)  скажифнс("стр.подобен_ли.UT25a");
     assert( подобен_ли( "123"c, "?2?"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT25b");
     assert( подобен_ли( "abc123def"c, "*?2?*"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT25c");
     assert( подобен_ли( "2"c, "2?*"c) == Нет);
     debug(стр)  скажифнс("стр.подобен_ли.UT26");
     assert( подобен_ли( ""c, ""c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT27");
     assert( подобен_ли( "abc"c, "abc"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT28");
     assert( подобен_ли( "abc"c, ""c) == Нет);
     debug(стр)  скажифнс("стр.подобен_ли.UT29");
     assert( подобен_ли( "abc*d"c, "abc\\*d"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT30");
     assert( подобен_ли( "abc?d"c, "abc\\?d"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT31");
     assert( подобен_ли( "abc\\d"c, "abc\\\\d"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT31a");
     assert( подобен_ли( "abc*d"c, "abc\\*d"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT31b");
     assert( подобен_ли( "abc\\d"c, "abc\\*d"c) == Нет);
     debug(стр)  скажифнс("стр.подобен_ли.UT31c");
     assert( подобен_ли( "abc\\d"c, "abc\\*d"c) == Нет);
     debug(стр)  скажифнс("стр.подобен_ли.UT31d");
     assert( подобен_ли( "abc\\d"c, "*\\*d"c) == Нет);
     debug(стр)  скажифнс("стр.подобен_ли.UT31e");
     assert( подобен_ли( "abc\\d"c, "*\\\\d"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT32");
     assert( подобен_ли( "foobar"c, "foo???"c) == Да);
     debug(стр)  скажифнс("стр.подобен_ли.UT33");
     assert(  подобен_ли( "foobar"c, "foo????"c) == Нет);
     debug(стр)  скажифнс("стр.подобен_ли.UT34");
     assert(  подобен_ли( "c:\\dindx_a\\index_000.html"c, "*index_???.html"c) == Да);
}


unittest
{  // начинается_с
     debug(стр)  скажифнс("стр.начинается_с.UT01");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"o") == Нет);
     debug(стр)  скажифнс("стр.начинается_с.UT02");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"f") == Да);
     debug(стр)  скажифнс("стр.начинается_с.UT03");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"fo") == Да);
     debug(стр)  скажифнс("стр.начинается_с.UT04");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"foo") == Да);
     debug(стр)  скажифнс("стр.начинается_с.UT05");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"foob") == Да);
     debug(стр)  скажифнс("стр.начинается_с.UT06");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"fooba") == Да);
     debug(стр)  скажифнс("стр.начинается_с.UT07");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"foobar") == Да);
     debug(стр)  скажифнс("стр.начинается_с.UT08");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"foobarx") == Нет);
     debug(стр)  скажифнс("стр.начинается_с.UT09");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"oo") == Нет);
     debug(стр)  скажифнс("стр.начинается_с.UT10");
     assert( начинается_с( cast(ткст)"foobar", cast(ткст)"") == Нет);
     debug(стр)  скажифнс("стр.начинается_с.UT11");
     assert( начинается_с( cast(ткст)"", cast(ткст)"") == Нет);
}

unittest
{  // оканчивается_на
     debug(стр)  скажифнс("стр.оканчивается_на.UT01");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"a") == Нет);
     debug(стр)  скажифнс("стр.оканчивается_на.UT02");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"r") == Да);
     debug(стр)  скажифнс("стр.оканчивается_на.UT03");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"ar") == Да);
     debug(стр)  скажифнс("стр.оканчивается_на.UT04");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"bar") == Да);
     debug(стр)  скажифнс("стр.оканчивается_на.UT05");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"obar") == Да);
     debug(стр)  скажифнс("стр.оканчивается_на.UT06");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"oobar") == Да);
     debug(стр)  скажифнс("стр.оканчивается_на.UT07");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"foobar") == Да);
     debug(стр)  скажифнс("стр.оканчивается_на.UT08");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"foobarx") == Нет);
     debug(стр)  скажифнс("стр.оканчивается_на.UT09");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"oo") == Нет);
     debug(стр)  скажифнс("стр.оканчивается_на.UT10");
     assert( оканчивается_на( cast(ткст)"foobar", cast(ткст)"") == Нет);
     debug(стр)  скажифнс("стр.оканчивается_на.UT11");
     assert( оканчивается_на( cast(ткст)"", cast(ткст)"") == Нет);
}

ткст раскрой(ткст pOriginal, ткст pTokenList,
                ткст pLeading = "{", ткст pTrailing = "}")
{
    return вЮ8( раскрой (
                    вЮ32(pOriginal),
                    вЮ32(pTokenList),
                    вЮ32(pLeading),
                    вЮ32(pTrailing)
                    ) ) ;

}

юткст раскрой(юткст pOriginal, юткст pTokenList,
                юткст pLeading = "{", юткст pTrailing = "}")
{
    юткст lResult;
    дим[][] lTokens;
    цел lPos;
    struct KV
    {
        юткст Key;
        юткст Value;
    }

    KV[] lKeyValues;

    lResult = pOriginal.dup;

    // Split up токен list into separate токен pairs.
    lTokens = util.linetoken.разбериСтроку(pTokenList, ","d, "", "");
    foreach(дим [] lKV; lTokens)
    {
        дим[][] lKeyValue;
        if (lKV.length > 0)
        {
            lKeyValue = util.linetoken.разбериСтроку(lKV, "="d, "", "");
            lKeyValues.length = lKeyValues.length + 1;
            lKeyValues[$-1].Key = lKeyValue[0];
            lKeyValues[$-1].Value = lKeyValue[1];
        }
    }

    // First to the simple replacements.
    foreach(KV lKV; lKeyValues)
    {
        юткст lToken;

        lToken = pLeading ~ lKV.Key ~ pTrailing;
        while( (lPos = найди(lResult, lToken,0 )) != -1 )
        {
            lResult = lResult[0..lPos] ~
                      lKV.Value ~
                      lResult[lPos + lToken.length .. $];
        }
    }

    // Now проверь for conditional replacements
    foreach(KV lKV; lKeyValues)
    {
        юткст lToken;
        юткст lOptValue;

        // First проверь for missing conditionals...
        lToken = pLeading ~ "?" ~ lKV.Key ~ ":";
        while ( (lPos = найди(lResult, lToken,0)) != -1)
        {
            цел lEndPos;
            lEndPos = найди(lResult, pTrailing, lPos+lToken.length);
            if (lEndPos != -1)
            {
                lOptValue = lResult[lPos+lToken.length..lEndPos].dup;
                if (lKV.Value.length == 0)
                {
                    lResult = lResult[0..lPos] ~
                              lOptValue ~
                              lResult[lEndPos+pTrailing.length .. $];
                }
                else
                {
                    lResult = lResult[0..lPos] ~
                              lKV.Value ~
                              lResult[lEndPos+pTrailing.length .. $];
                }
            }

        }

        // Next проверь for present conditionals...
        lToken = pLeading ~ "?" ~ lKV.Key ~ "=";
        while ( (lPos = найди(lResult, lToken, 0)) != -1)
        {
            цел lEndPos;
            lEndPos = найди(lResult, pTrailing, lPos+lToken.length);
            if (lEndPos != -1)
            {
                lOptValue = lResult[lPos+lToken.length..lEndPos].dup;
                if (lKV.Value.length != 0)
                {
                    lResult = lResult[0..lPos] ~
                              lOptValue ~
                              lResult[lEndPos+pTrailing.length .. $];
                }
                else
                {
                    lResult = lResult[0..lPos] ~
                              lResult[lEndPos+pTrailing.length .. $];
                }
            }

        }
    }

    // Now remove all неиспользовано токены.
    while( (lPos = найди(lResult, pLeading,0 )) != -1)
    {
        цел lPos1;
        цел lPos2;
        цел lPos3;

        lPos2 = найди(lResult, pTrailing, lPos + 1 );
        if (lPos2 == -1)
            break;

        if (lResult[lPos+1] == '?')
        {
            lPos3 = найди(lResult, ":"d, lPos + 1 );
            if (lPos3 != -1 && lPos3 < lPos2)
            {
                // Replace entire токен with default value from внутри токен.
                lResult = lResult[0 .. lPos] ~
                    lResult[lPos3+1 .. lPos2] ~
                    lResult[lPos2 + pTrailing.length .. $];
            }
            else
            {
                // Remove entire токен from result.
                lResult = lResult[0 .. lPos] ~
                    lResult[lPos2 + pTrailing.length .. $];
            }
        }
        else
            // Remove entire токен from result.
            lResult = lResult[0 .. lPos] ~
                lResult[lPos2 + pTrailing.length .. $];
    }

    return lResult;
}
unittest
{  // раскрой
     assert( раскрой( "foo{что}"c, "что=bar"c) == "foobar");
     assert( раскрой( "foo{что}"c, "when=bar"c) == "foo");
     assert( раскрой( "foo{что}"d, "что="d) == "foo");
     assert( раскрой( "foo что"c, "что=bar"c) == "foo что");
     assert( раскрой( "foo^что$"c, "что=bar"c, "^"c, "$"c) == "foobar");
     assert( раскрой( "foo$(что)"c, "что=bar"c, "$("c, ")"c) == "foobar");
     assert( раскрой( "foo{?что:who}bar"c, "что="c) == "foowhobar");
     assert( раскрой( "foo{?что:who}bar"c, ""c) == "foowhobar");
     assert( раскрой( "foo{?что:who}bar"c, "who=why"c) == "foowhobar");
     assert( раскрой( "foo{?что:who}bar"c, "что=when"c) == "foowhenbar");
     assert( раскрой( "foo{?что=who}bar"c, "что="c) == "foobar");
     assert( раскрой( "foo{?что=who}bar"c, ""c) == "foobar");
     assert( раскрой( "foo{?что=who}bar"c, "who=why"c) == "foobar");
     assert( раскрой( "foo{?что=,}bar"c, "что=when"c) == "foo,bar");
}

ткст вАСКИ(ткст pUTF8)
{
    бул lChanged;
    ткст lResult;
    // Convert non-ASCII chars based on the Microsoft DOS Western Europe charset
    static ткст lTranslateTable =
        "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F"
        "\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1A\x1B\x1C\x1D\x1E\x1F"
        " !\"#$%&'()*+,-./0123456789:;<=>?"
        "@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_"
        "`abcdefghijklmnopqrstuvwxyz{|}~ "
        "CueaaaaceeeiiiAAEaAooouuyOUo$Oxf"
        "aiounNa0?R!24!<>-----AAAC----c$-"
        "------aA-------$dDEEEiIII----|I-"
        "OBOOoOmdDUUUyY-'-+=3PS/,0:.132- ";
    lResult = pUTF8;
    for (цел i = 0; i < lResult.length; i++)
    {
        if (lResult[i] > 127)
        {
            if (lChanged == false)
            {
                lResult = pUTF8.dup;
                lChanged = true;
            }
            lResult[i] = lTranslateTable[lResult[i]];
        }
    }
    return lResult;
}

/**************************************
 * Split s[] into an массив of строки,
 * using CR, LF, or CR-LF as the delimiter.
 * The delimiter is not included in the line.
 */


private static юткст Unicode_WhiteSpace =
    "\u0009\u000A\u000B\u000C\u000D"  // TAB, NL, , NP, CR
    // "\u0020"  // SPACE
    "\u0085" // <control-0085>
    // "\u00A0" // NO-BREAK SPACE
    "\u1680" // OGHAM SPACE MARK
    "\u180E" // MONGOLIAN VOWEL SEPARATOR
    "\u2000\u2001\u2002\u2003\u2004"
    "\u2005\u2006\u2007\u2008"
    "\u2009\u200A" // EN QUAD..HAIR SPACE
    "\u2028" // LINE SEPARATOR
    "\u2029" // PARAGRAPH SEPARATOR
    // "\u202F" // NARROW NO-BREAK SPACE
    "\u205F" // MEDIUM MATHEMATICAL SPACE
    "\u3000" // IDEOGRAPHIC SPACE
    "\ufffd" // Stop
    ;

бул ЮК_пбел_ли(дим pChar)
{
    цел i;
    if (pChar == '\u0020') // Common case первый.
        return true;

    while( pChar > Unicode_WhiteSpace[i])
        i++;
    return (pChar == Unicode_WhiteSpace[i] ? true : false);
}

// Returns a slice up to the первый whitespace (if any)
ткст найдипбел(ткст pText)
{
    foreach(цел lPos, дим c; pText)
    {
        if (ЮК_пбел_ли(c))
            return pText[0..lPos];
    }
    return pText;
}
unittest
{
    assert(найдипбел("abc def") == "abc");
    assert(найдипбел("\u3056\u2123 def") == "\u3056\u2123");
    assert(найдипбел("\u3056\u2123\u2028def") == "\u3056\u2123");
}

// Returns a slice from the последний whitespace (if any) to the end
юткст найдипбелрек(юткст pText)
{
    цел lPos = pText.length-1;
    while (lPos >= 0 && !ЮК_пбел_ли(pText[lPos]))
        lPos--;

    return pText[lPos+1..$];
}

/*****************************************
 * Strips leading or trailing whitespace, or both.
 */

юткст уберил(юткст s)
{
    цел i;

    foreach (цел p, дим c; s)
    {
	    if (!ЮК_пбел_ли(c))
	    {
    	    i = p;
	        break;
        }
    }
    return s[i .. s.length];
}
ткст уберил(ткст s) /// ditto
{
    return вЮ8(уберил(вЮ32(s)));
}


юткст уберип(юткст s) /// ditto
{
    цел i;

    for (i = s.length-1; i >= 0; i--)
    {
	if (!ЮК_пбел_ли(s[i]))
	    break;
    }
    return s[0 .. i+1];
}

ткст уберип(ткст s) /// ditto
{
    return вЮ8(уберип(вЮ32(s)));
}

юткст убери(юткст s) /// ditto
{
    return уберип(уберил(s));
}

шткст убери(шткст s) /// ditto
{
    return вЮ16(уберип(уберил(вЮ32(s))));
}

ткст убери(ткст s) /// ditto
{
    return вЮ8(уберип(уберил(вЮ32(s))));
}

unittest
{
    юткст s;

    s = убери("  foo\t "d);
    assert(s == "foo"d);
    s = уберип("  foo\t "d);
    assert(s == "  foo"d);
    s = уберил("  foo\t "d);
    assert(s == "foo\t "d);
}

template Шнайди(T)
{
    цел найди(T[] pText, T[] pSubText, цел pFrom = 0)
    {
        цел lTexti;
        цел lSubi;
        цел lPos;
        цел lTextEnd;

        if (pFrom < 0)
            pFrom = 0;

        // locate первый сверь.
        lSubi = 0;
        lTexti = pFrom;
        // No point in looking past this позиция.
        lTextEnd = pText.length - pSubText.length + 1;
        while(lSubi < pSubText.length)
        {
            while(lTexti < lTextEnd && pSubText[lSubi] != pText[lTexti])
            {
                lTexti++;
            }
            if (lTexti >= pText.length)
                return -1;

            lPos = lTexti;  // Mark possible start of substring сверь.

            lTexti++;
            lSubi++;
            // Locate all совпадает
            while(lTexti < pText.length && lSubi < pSubText.length &&
                        pSubText[lSubi] == pText[lTexti])
            {
                lTexti++;
                lSubi++;
            }
            if (lSubi == pSubText.length)
                return lPos;
            lSubi = 0;
            lTexti = lPos + 1;
        }
        return -1;
    }
}
alias Шнайди!(дим).найди найди;
alias Шнайди!(шим).найди найди;

unittest
{
    юткст Target = "abcdefgcdemn"d;
    assert( найди(Target, "mno") == -1);
    assert( найди(Target, "mn") == 10);
    assert( найди(Target, "cde") == 2);
    assert( найди(Target, "cde"d, 3) == 7);
    assert( найди(Target, "cde"d, 8) == -1);
    assert( найди(Target, "cdg") == -1);
    assert( найди(Target, "f") == 5);
    assert( найди(Target, "q") == -1);
    assert( найди(Target, "a"d, 200) == -1);
    assert( найди(Target, "") == -1);
    assert( найди("", Target, 0) == -1);
    assert( найди(""d, "") == -1);
    assert( найди(Target, "d"d, -4) == 3);
}

ткст транслируйЭск(ткст pText)
{
    ткст lResult;
    цел lInPos;
    цел lOutPos;

    if (stdrus.найди(pText, '\\') == -1)
        return pText;

    lResult.length = pText.length;
    lInPos = 0;
    lOutPos = 0;

    while(lInPos < pText.length)
    {
        if (pText[lInPos] == '\\' && lInPos+1 != pText.length)
        {
            switch (pText[lInPos+1])
            {
                case 'n':
                    lInPos += 2;
                    lResult[lOutPos] = '\n';
                    break;
                case 't':
                    lInPos += 2;
                    lResult[lOutPos] = '\t';
                    break;
                case 'r':
                    lInPos += 2;
                    lResult[lOutPos] = '\r';
                    break;
                case '\\':
                    lInPos += 2;
                    lResult[lOutPos] = '\\';
                    break;
                default:
                    lResult[lOutPos] = pText[lInPos];
                    lInPos++;
            }
        }
        else
        {
            lResult[lOutPos] = pText[lInPos];
            lInPos++;
        }

        lOutPos++;
    }

    return lResult[0..lOutPos];
}

unittest
{
    assert( транслируйЭск("abc") == "abc");
    assert( транслируйЭск("\\n") == "\n");
    assert( транслируйЭск("\\t") == "\t");
    assert( транслируйЭск("\\r") == "\r");
    assert( транслируйЭск("\\\\") == "\\");
    assert( транслируйЭск("\\q") == "\\q");
}

// Function to replace токены in the form %<SYM>%  with environment data.
// Note that '%%' is replaced by a single '%'.
// -------------------------------------------
ткст разверниПеремСреды(ткст pLine)
// -------------------------------------------
{
    ткст lLine;
    ткст lSymName;
    цел lPos;
    цел lEnd;

    lPos = stdrus.найди(pLine, '%');
    if (lPos == -1)
        return pLine;

    lLine = pLine[0.. lPos].dup;
    for( ; lPos < pLine.length; lPos++ )
    {
        if (pLine[lPos] == '%')
        {
            if (lPos+1 != pLine.length && pLine[lPos+1] == '%')
            {
                lLine ~= '%';
                lPos++;
                continue;
            }

            for(lEnd = lPos+1; (lEnd < pLine.length) && (pLine[lEnd] != '%'); lEnd++ )
            {
            }
            if (lEnd < pLine.length)
            {
                lSymName = pLine[lPos+1..lEnd];

                if (lSymName.length > 0)
                {
                    lLine ~= дайСред(вЮ8(lSymName));
                }
                lPos = lEnd;
            }
            else
            {
                lLine ~= pLine[lPos];
            }
        }
        else
        {
            lLine ~= pLine[lPos];
        }
    }
    return lLine;
}
unittest {
    устСред("EEVA", __FILE__ );
    устСред("EEVB", __DATE__ );
    устСред("EEVC", __TIME__ );
    assert( разверниПеремСреды("The файл '%EEVA%' was compiled on %EEVB% at %EEVC%") ==
      "The файл '" ~ __FILE__ ~"' was compiled on " ~
      __DATE__ ~ " at " ~ __TIME__);
}

//-------------------------------------------------------
ткст дайСред(ткст pSymbol)
//-------------------------------------------------------
{
    return вТкст(getenv(вТкст0(pSymbol)));
}

//-------------------------------------------------------
проц устСред(ткст pSymbol, ткст pValue, бул pOverwrite = true)
//-------------------------------------------------------
{
    if (pOverwrite || дайСред(pSymbol).length == 0)
        putenv(вТкст0(pSymbol ~ "=" ~ pValue));
}

unittest {
    устСред("SetEnvUnitTest", __FILE__ ~ __TIMESTAMP__);
    assert( дайСред("SetEnvUnitTest") == __FILE__ ~ __TIMESTAMP__);
}

template Шдн(T)
{
//-------------------------------------------------------
бул ДаНет(T[] pText, бул pDefault)
//-------------------------------------------------------
{
    бул lResult = pDefault;
    foreach(цел i, дим c; pText)
    {
        if (c == '=' || c == ':')
        {
            pText = уберил(pText[i+1 .. $]);
            break;
        }
    }
    if (pText.length > 0)
    {
        if (pText[0] == 'Y' || pText[0] == 'y')
            lResult = true;
        else if (pText[0] == 'N' || pText[0] == 'n')
            lResult = false;
    }

    return lResult;
}
//-------------------------------------------------------
проц ДаНет(T[] pText, out бул pResult, бул pDefault)
//-------------------------------------------------------
{
    pResult = ДаНет(pText, pDefault);
}

//-------------------------------------------------------
проц ДаНет(T[] pText, out T[] pResult, бул pDefault)
//-------------------------------------------------------
{
    pResult = (ДаНет(pText, pDefault) ? cast(T[])"Y" : cast(T[])"N").dup;
}

//-------------------------------------------------------
проц ДаНет(T[] pText, out T pResult, бул pDefault)
//-------------------------------------------------------
{
    pResult = (ДаНет(pText, pDefault) ? 'Y' : 'N');
}
//-------------------------------------------------------
проц ДаНет(T[] pText, out Бул pResult, Бул pDefault)
//-------------------------------------------------------
{
    pResult = (ДаНет(pText, (pDefault==Да?true:false)) ? Да : Нет);
}
}
alias Шдн!(дим).ДаНет ДаНет;
alias Шдн!(сим).ДаНет ДаНет;
