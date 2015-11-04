/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Apr 2004: Initial release
                        Dec 2006: South Seas version

        author:         Kris


        Placeholder for a variety of wee functions. These functions are все
        templated with the intent of being used for массивы of сим, шим,
        and дим. However, they operate correctly with другой Массив типы
        also.

        Several of these functions return an индекс значение, representing where
        some criteria was опрentified. When saопр criteria is not matched, the
        functions return a значение representing the Массив length provопрed в_
        them. That is, for those scenarios where C functions might typically
        return -1 these functions return length instead. This operate nicely
        with D slices:
        ---
        auto текст = "happy:faces";
        
        assert (текст[0 .. locate (текст, ':')] == "happy");
        
        assert (текст[0 .. locate (текст, '!')] == "happy:faces");
        ---

        The содержит() function is ещё convenient for trivial отыщи
        cases:
        ---
        if (содержит ("fubar", '!'))
            ...
        ---

        Note that where some functions expect a т_мера as an аргумент, the
        D template-matching algorithm will краш where an цел is provопрed
        instead. This is the typically the cause of "template не найден"
        ошибки. Also note that имя overloading is not supported cleanly
        by IFTI at this время, so is not applied here.


        Applying the D "import alias" mechanism в_ this module is highly
        recommended, in order в_ предел namespace pollution:
        ---
        import Util = text.Util;

        auto s = Util.trim ("  foo ");
        ---
                

        Function templates:
        ---
        trim (источник)                               // trim пробел
        triml (источник)                              // trim пробел
        trimr (источник)                              // trim пробел
        strip (источник, match)                       // trim elements
        strИПl (источник, match)                      // trim elements
        strИПr (источник, match)                      // trim elements
        chopl (источник, match)                       // trim образец match
        chopr (источник, match)                       // trim образец match
        delimit (ист, установи)                          // разбей on delims
        разбей (источник, образец)                     // разбей on образец
        splitLines (источник);                        // разбей on lines
        голова (источник, образец, хвост)                // разбей в_ голова & хвост
        объедини (источник, postfix, вывод)              // объедини текст segments
        префикс (приёмн, префикс, контент...)            // префикс текст segments
        postfix (приёмн, postfix, контент...)          // postfix текст segments
        combine (приёмн, префикс, postfix, контент...)  // combine lotsa stuff
        repeat (источник, счёт, вывод)              // repeat источник 
        замени (источник, match, replacement)        // замени chars
        подставь (источник, match, replacement)     // замени/удали matches
        счёт (источник, match)                       // счёт instances
        содержит (источник, match)                    // есть сим?
        containsPattern (источник, match)             // есть образец?
        индекс (источник, match, старт)                // найди match индекс
        locate (источник, match, старт)               // найди сим
        locatePrior (источник, match, старт)          // найди prior сим
        locatePattern (источник, match, старт);       // найди образец
        locatePatternPrior (источник, match, старт);  // найди prior образец
        indexOf (s*, match, length)                 // low-уровень отыщи
        не_совпадают (s1*, s2*, length)                 // low-уровень compare
        matching (s1*, s2*, length)                 // low-уровень compare
        isSpace (match)                             // is пробел?
        unescape(источник, вывод)                    // преобразуй '\' prefixes
        выкладка (destination, форматируй ...)            // featherweight printf
        lines (ткт)                                 // foreach lines
        quotes (ткт, установи)                           // foreach quotes
        delimiters (ткт, установи)                       // foreach delimiters
        образцы (ткт, образец)                     // foreach образцы
        ---

        Please note that any 'образец' referred в_ within this module
        refers в_ a образец of characters, and not some kind of regex
        descrИПtor. Use the Regex module for regex operation.

*******************************************************************************/

module text.Util;

/******************************************************************************

        Trim the provопрed Массив by strИПping пробел из_ Всё
        ends. Returns a срез of the original контент

******************************************************************************/

T[] trim(T) (T[] источник)
{
        T*   голова = источник.ptr,
             хвост = голова + источник.length;

        while (голова < хвост && isSpace(*голова))
               ++голова;

        while (хвост > голова && isSpace(*(хвост-1)))
               --хвост;

        return голова [0 .. хвост - голова];
}

/******************************************************************************

        Trim the provопрed Массив by strИПping пробел из_ the left.
        Returns a срез of the original контент

******************************************************************************/

T[] triml(T) (T[] источник)
{
        T*   голова = источник.ptr,
             хвост = голова + источник.length;

        while (голова < хвост && isSpace(*голова))
               ++голова;

        return голова [0 .. хвост - голова];
}

/******************************************************************************

        Trim the provопрed Массив by strИПping пробел из_ the right.
        Returns a срез of the original контент

******************************************************************************/

T[] trimr(T) (T[] источник)
{
        T*   голова = источник.ptr,
             хвост = голова + источник.length;

        while (хвост > голова && isSpace(*(хвост-1)))
               --хвост;

        return голова [0 .. хвост - голова];
}

/******************************************************************************

        Trim the given Массив by strИПping the provопрed match из_
        Всё ends. Returns a срез of the original контент

******************************************************************************/

T[] strip(T) (T[] источник, T match)
{
        T*   голова = источник.ptr,
             хвост = голова + источник.length;

        while (голова < хвост && *голова is match)
               ++голова;

        while (хвост > голова && *(хвост-1) is match)
               --хвост;

        return голова [0 .. хвост - голова];
}

/******************************************************************************

        Trim the given Массив by strИПping the provопрed match из_
        the left hand sопрe. Returns a срез of the original контент

******************************************************************************/

T[] strИПl(T) (T[] источник, T match)
{
        T*   голова = источник.ptr,
             хвост = голова + источник.length;

        while (голова < хвост && *голова is match)
               ++голова;

        return голова [0 .. хвост - голова];
}

/******************************************************************************

        Trim the given Массив by strИПping the provопрed match из_
        the right hand sопрe. Returns a срез of the original контент

******************************************************************************/

T[] strИПr(T) (T[] источник, T match)
{
        T*   голова = источник.ptr,
             хвост = голова + источник.length;

        while (хвост > голова && *(хвост-1) is match)
               --хвост;

        return голова [0 .. хвост - голова];
}

/******************************************************************************

        Chop the given источник by strИПping the provопрed match из_
        the left hand sопрe. Returns a срез of the original контент

******************************************************************************/

T[] chopl(T) (T[] источник, T[] match)
{
        if (match.length <= источник.length)
            if (источник[0 .. match.length] == match)
                источник = источник [match.length .. $];

        return источник;
}

/******************************************************************************

        Chop the given источник by strИПping the provопрed match из_
        the right hand sопрe. Returns a срез of the original контент

******************************************************************************/

T[] chopr(T) (T[] источник, T[] match)
{
        if (match.length <= источник.length)
            if (источник[$-match.length .. $] == match)
                источник = источник [0 .. $-match.length];

        return источник;
}

/******************************************************************************

        Замени все instances of one element with другой (in place)

******************************************************************************/

T[] замени(T) (T[] источник, T match, T replacement)
{
        foreach (ref c; источник)
                 if (c is match)
                     c = replacement;
        return источник;
}

/******************************************************************************

        Substitute все instances of match из_ источник. Набор replacement
        в_ пусто in order в_ удали instead of замени

******************************************************************************/

T[] подставь(T) (T[] источник, T[] match, T[] replacement)
{
        T[] вывод;

        foreach (s; образцы (источник, match, replacement))
                    вывод ~= s;
        return вывод;
}

/******************************************************************************

        Count все instances of match within источник 

******************************************************************************/

т_мера счёт(T) (T[] источник, T[] match)
{
        т_мера c;

        foreach (s; образцы (источник, match))
                    ++c;
        assert(c > 0);
        return c - 1;
}

/******************************************************************************

        Returns whether or not the provопрed Массив содержит an экземпляр
        of the given match
        
******************************************************************************/

бул содержит(T) (T[] источник, T match)
{
        return indexOf (источник.ptr, match, источник.length) != источник.length;
}

/******************************************************************************

        Returns whether or not the provопрed Массив содержит an экземпляр
        of the given match
        
******************************************************************************/

бул containsPattern(T) (T[] источник, T[] match)
{
        return locatePattern (источник, match) != источник.length;
}

/******************************************************************************

        Return the индекс of the следщ экземпляр of 'match' starting at
        позиция 'старт', or источник.length where there is no match.

        Parameter 'старт' defaults в_ 0

******************************************************************************/

т_мера индекс(T, U=т_мера) (T[] источник, T[] match, U старт=0)
{return индекс!(T) (источник, match, старт);}

т_мера индекс(T) (T[] источник, T[] match, т_мера старт=0)
{
        return (match.length is 1) ? locate (источник, match[0], старт) 
                                   : locatePattern (источник, match, старт);
}

/******************************************************************************

        Return the индекс of the prior экземпляр of 'match' starting
        just before 'старт', or источник.length where there is no match.

        Parameter 'старт' defaults в_ источник.length

******************************************************************************/

т_мера rindex(T, U=т_мера) (T[] источник, T[] match, U старт=U.max)
{return rindex!(T)(источник, match, старт);}

т_мера rindex(T) (T[] источник, T[] match, т_мера старт=т_мера.max)
{
        return (match.length is 1) ? locatePrior (источник, match[0], старт) 
                                   : locatePatternPrior (источник, match, старт);
}

/******************************************************************************

        Return the индекс of the следщ экземпляр of 'match' starting at
        позиция 'старт', or источник.length where there is no match.

        Parameter 'старт' defaults в_ 0

******************************************************************************/

т_мера locate(T, U=т_мера) (T[] источник, T match, U старт=0)
{return locate!(T) (источник, match, старт);}

т_мера locate(T) (T[] источник, T match, т_мера старт=0)
{
        if (старт > источник.length)
            старт = источник.length;
        
        return indexOf (источник.ptr+старт, match, источник.length - старт) + старт;
}

/******************************************************************************

        Return the индекс of the prior экземпляр of 'match' starting
        just before 'старт', or источник.length where there is no match.

        Parameter 'старт' defaults в_ источник.length

******************************************************************************/

т_мера locatePrior(T, U=т_мера) (T[] источник, T match, U старт=U.max)
{return locatePrior!(T)(источник, match, старт);}

т_мера locatePrior(T) (T[] источник, T match, т_мера старт=т_мера.max)
{
        if (старт > источник.length)
            старт = источник.length;

        while (старт > 0)
               if (источник[--старт] is match)
                   return старт;
        return источник.length;
}

/******************************************************************************

        Return the индекс of the следщ экземпляр of 'match' starting at
        позиция 'старт', or источник.length where there is no match. 

        Parameter 'старт' defaults в_ 0

******************************************************************************/

т_мера locatePattern(T, U=т_мера) (T[] источник, T[] match, U старт=0)
{return locatePattern!(T) (источник, match, старт);}

т_мера locatePattern(T) (T[] источник, T[] match, т_мера старт=0)
{
        т_мера    инд;
        T*      p = источник.ptr + старт;
        т_мера    протяженность = источник.length - старт - match.length + 1;

        if (match.length && протяженность <= источник.length)
            while (протяженность)
                   if ((инд = indexOf (p, match[0], протяженность)) is протяженность)
                        break;
                   else
                      if (matching (p+=инд, match.ptr, match.length))
                          return p - источник.ptr;
                      else
                         {
                         протяженность -= (инд+1);
                         ++p;
                         }

        return источник.length;
}
   
/******************************************************************************

        Return the индекс of the prior экземпляр of 'match' starting
        just before 'старт', or источник.length where there is no match.

        Parameter 'старт' defaults в_ источник.length

******************************************************************************/

т_мера locatePatternPrior(T, U=т_мера) (T[] источник, T[] match, U старт=U.max)
{return locatePatternPrior!(T)(источник, match, старт);}

т_мера locatePatternPrior(T) (T[] источник, T[] match, т_мера старт=т_мера.max)
{
        auto длин = источник.length;
        
        if (старт > длин)
            старт = длин;

        if (match.length && match.length <= длин)
            while (старт)
                  {
                  старт = locatePrior (источник, match[0], старт);
                  if (старт is длин)
                      break;
                  else
                     if ((старт + match.length) <= длин)
                          if (matching (источник.ptr+старт, match.ptr, match.length))
                              return старт;
                  }

        return длин;
}

/******************************************************************************

        разбей the provопрed Массив on the first образец экземпляр, and 
        return the resultant голова and хвост. The образец is excluded 
        из_ the two segments. 

        Where a segment is не найден, хвост will be пусто and the return
        значение will be the original Массив.
        
******************************************************************************/

T[] голова(T) (T[] ист, T[] образец, out T[] хвост)
{
        auto i = locatePattern (ист, образец);
        if (i != ист.length)
           {
           хвост = ист [i + образец.length .. $];
           ист = ист [0 .. i];
           }
        return ист;
}

/******************************************************************************

        разбей the provопрed Массив on the последний образец экземпляр, and 
        return the resultant голова and хвост. The образец is excluded 
        из_ the two segments. 

        Where a segment is не найден, голова will be пусто and the return
        значение will be the original Массив.
        
******************************************************************************/

T[] хвост(T) (T[] ист, T[] образец, out T[] голова)
{
        auto i = locatePatternPrior (ист, образец);
        if (i != ист.length)
           {
           голова = ист [0 .. i];
           ист = ист [i + образец.length .. $];
           }
        return ист;
}

/******************************************************************************

        разбей the provопрed Массив wherever a delimiter-установи экземпляр is
        найдено, and return the resultant segments. The delimiters are
        excluded из_ each of the segments. Note that delimiters are
        matched as a установи of alternates rather than as a образец.

        Splitting on a single delimiter is consопрerably faster than
        splitting upon a установи of alternatives. 

        Note that the ист контент is not duplicated by this function, 
        but is sliced instead.

******************************************************************************/

T[][] delimit(T) (T[] ист, T[] установи)
{
        T[][] результат;

        foreach (segment; delimiters (ист, установи))
                 результат ~= segment;
        return результат;
}

/******************************************************************************

        разбей the provопрed Массив wherever a образец экземпляр is
        найдено, and return the resultant segments. The образец is
        excluded из_ each of the segments.
        
        Note that the ист контент is not duplicated by this function, 
        but is sliced instead.

******************************************************************************/

T[][] разбей(T) (T[] ист, T[] образец)
{
        T[][] результат;

        foreach (segment; образцы (ист, образец))
                 результат ~= segment;
        return результат;
}

/******************************************************************************

        Convert текст преобр_в a установи of lines, where each строка is опрentified
        by a \n or \r\n combination. The строка terminator is очищенный из_
        each resultant Массив

        Note that the ист контент is not duplicated by this function, but
        is sliced instead.

******************************************************************************/

alias вСтроки splitLines;
T[][] вСтроки(T) (T[] ист)
{

        T[][] результат;

        foreach (строка; lines (ист))
                 результат ~= строка;
        return результат;
}

/******************************************************************************

        Return the indexed строка, where each строка is опрentified by a \n 
        or \r\n combination. The строка terminator is очищенный из_ the 
        resultant строка

        Note that ист контент is not duplicated by this function, but
        is sliced instead.

******************************************************************************/

T[] lineOf(T) (T[] ист, т_мера индекс)
{
        цел i = 0;
        foreach (строка; lines (ист))
                 if (i++ is индекс)
                     return строка;
        return пусто;
}

/******************************************************************************

        Combine a series of текст segments together, each appended with 
        a postfix образец. An optional вывод буфер can be provопрed в_
        avoопр куча activity - it should be large enough в_ contain the 
        entire вывод, otherwise the куча will be used instead.

        Returns a valid срез of the вывод, containing the concatenated
        текст.

******************************************************************************/

T[] объедини(T) (T[][] ист, T[] postfix=пусто, T[] приёмн=пусто)
{
        return combine!(T) (приёмн, пусто, postfix, ист);
}

/******************************************************************************

        Combine a series of текст segments together, each prepended with 
        a префикс образец. An optional вывод буфер can be provопрed в_ 
        avoопр куча activity - it should be large enough в_ contain the 
        entire вывод, otherwise the куча will be used instead.

        Note that, unlike объедини(), the вывод буфер is specified first
        such that a установи of trailing strings can be provопрed. 

        Returns a valid срез of the вывод, containing the concatenated
        текст.

******************************************************************************/

T[] префикс(T) (T[] приёмн, T[] префикс, T[][] ист...)
{
        return combine!(T) (приёмн, префикс, пусто, ист);
}

/******************************************************************************

        Combine a series of текст segments together, each appended with an 
        optional postfix образец. An optional вывод буфер can be provопрed
        в_ avoопр куча activity - it should be large enough в_ contain the 
        entire вывод, otherwise the куча will be used instead.

        Note that, unlike объедини(), the вывод буфер is specified first
        such that a установи of trailing strings can be provопрed. 

        Returns a valid срез of the вывод, containing the concatenated
        текст.

******************************************************************************/

T[] postfix(T) (T[] приёмн, T[] postfix, T[][] ист...)
{
        return combine!(T) (приёмн, пусто, postfix, ист);
}

/******************************************************************************

        Combine a series of текст segments together, each псеп_в_начале and/or 
        postfixed with optional strings. An optional вывод буфер can be 
        provопрed в_ avoопр куча activity - which should be large enough в_ 
        contain the entire вывод, otherwise the куча will be used instead.

        Note that, unlike объедини(), the вывод буфер is specified first
        such that a установи of trailing strings can be provопрed. 

        Returns a valid срез of the вывод, containing the concatenated
        текст.

******************************************************************************/

T[] combine(T) (T[] приёмн, T[] префикс, T[] postfix, T[][] ист ...)
{
        т_мера длин = ист.length * префикс.length + 
                   ист.length * postfix.length;

        foreach (segment; ист)
                 длин += segment.length;
               
        if (приёмн.length < длин)
            приёмн.length = длин;
            
        T* p = приёмн.ptr;
        foreach (segment; ист)
                {
                p[0 .. префикс.length] = префикс;
                p += префикс.length;
                p[0 .. segment.length] = segment;
                p += segment.length;
                p[0 .. postfix.length] = postfix;
                p += postfix.length;
                }

        // удали trailing seperator
        if (длин)
            длин -= postfix.length;
        return приёмн [0 .. длин];       
}

/******************************************************************************

        Repeat an Массив for a specific число of times. An optional вывод 
        буфер can be provопрed в_ avoопр куча activity - it should be large 
        enough в_ contain the entire вывод, otherwise the куча will be used 
        instead.

        Returns a valid срез of the вывод, containing the concatenated
        текст.

******************************************************************************/

T[] repeat(T, U=т_мера) (T[] ист, U счёт, T[] приёмн=пусто)
{return repeat!(T)(ист, счёт, приёмн);}

T[] repeat(T) (T[] ист, т_мера счёт, T[] приёмн=пусто)
{
        т_мера длин = ист.length * счёт;
        if (длин is 0)
            return пусто;

        if (приёмн.length < длин)
            приёмн.length = длин;
            
        for (auto p = приёмн.ptr; счёт--; p += ист.length)
             p[0 .. ист.length] = ист;

        return приёмн [0 .. длин];
}

/******************************************************************************

        Is the аргумент a пробел character?

******************************************************************************/

бул isSpace(T) (T c)
{
        static if (T.sizeof is 1)
                   return (c <= 32 && (c is ' ' || c is '\t' || c is '\r' || c is '\n' || c is '\f' || c is '\v'));
        else
           return (c <= 32 && (c is ' ' || c is '\t' || c is '\r' || c is '\n' || c is '\f' || c is '\v')) || (c is '\u2028' || c is '\u2029');
}

/******************************************************************************

        Return whether or not the two массивы have matching контент
        
******************************************************************************/

бул matching(T, U=т_мера) (T* s1, T* s2, U length)
{return matching!(T) (s1, s2, length);}

бул matching(T) (T* s1, T* s2, т_мера length)
{
        return не_совпадают(s1, s2, length) is length;
}

/******************************************************************************

        Returns the индекс of the first match in ткт, failing once
        length is reached. Note that we return 'length' for failure
        and a 0-based индекс on success

******************************************************************************/

т_мера indexOf(T, U=т_мера) (T* ткт, T match, U length)
{return indexOf!(T) (ткт, match, length);}

т_мера indexOf(T) (T* ткт, T match, т_мера length)
{
        //assert (ткт);

        static if (T.sizeof == 1)
                   enum : т_мера {m1 = cast(т_мера) 0x0101010101010101, 
                                  m2 = cast(т_мера) 0x8080808080808080}
        static if (T.sizeof == 2)
                   enum : т_мера {m1 = cast(т_мера) 0x0001000100010001, 
                                  m2 = cast(т_мера) 0x8000800080008000}
        static if (T.sizeof == 4)
                   enum : т_мера {m1 = cast(т_мера) 0x0000000100000001, 
                                  m2 = cast(т_мера) 0x8000000080000000}

        static if (T.sizeof < т_мера.sizeof)
        {
                if (length)
                   {
                   т_мера m = match;
                   m += m << (8 * T.sizeof);

                   static if (T.sizeof < т_мера.sizeof / 2)
                              m += (m << (8 * T.sizeof * 2));

                   static if (T.sizeof < т_мера.sizeof / 4)
                              m += (m << (8 * T.sizeof * 4));

                   auto p = ткт;
                   auto e = p + length - т_мера.sizeof/T.sizeof;
                   while (p < e)
                         {
                         // сотри matching T segments
                         auto v = (*cast(т_мера*) p) ^ m;
                         // тест for zero, courtesy of Alan Mycroft
                         if ((v - m1) & ~v & m2)
                              break;
                         p += т_мера.sizeof/T.sizeof;
                         }

                   e += т_мера.sizeof/T.sizeof;
                   while (p < e)
                          if (*p++ is match)
                              return p - ткт - 1;
                   }
                return length;
        }
        else
        {
                auto длин = length;
                for (auto p=ткт-1; длин--;)
                     if (*++p is match)
                         return p - ткт;
                return length;
        }
}

/******************************************************************************

        Returns the индекс of a не_совпадают between s1 & s2, failing when
        length is reached. Note that we return 'length' upon failure
        (Массив контент matches) and a 0-based индекс upon success.

        Use this as a faster opEquals. Also provопрes the basis for a
        faster opCmp, since the индекс of the first mismatched character
        can be used в_ determine the return значение

******************************************************************************/

т_мера не_совпадают(T, U=т_мера) (T* s1, T* s2, U length)
{return не_совпадают!(T)(s1, s2, length);}

т_мера не_совпадают(T) (T* s1, T* s2, т_мера length)
{
        assert (s1 && s2);

        static if (T.sizeof < т_мера.sizeof)
        {
                if (length)
                   {
                   auto старт = s1;
                   auto e = старт + length - т_мера.sizeof/T.sizeof;

                   while (s1 < e)
                         {
                         if (*cast(т_мера*) s1 != *cast(т_мера*) s2)
                             break;
                         s1 += т_мера.sizeof/T.sizeof;
                         s2 += т_мера.sizeof/T.sizeof;
                         }

                   e += т_мера.sizeof/T.sizeof;
                   while (s1 < e)
                          if (*s1++ != *s2++)
                              return s1 - старт - 1;
                   }
                return length;
        }
        else
        {
                auto длин = length;
                for (auto p=s1-1; длин--;)
                     if (*++p != *s2++)
                         return p - s1;
                return length;
        }
}

/******************************************************************************

        Обходчик в_ isolate lines.

        Converts текст преобр_в a установи of lines, where each строка is опрentified
        by a \n or \r\n combination. The строка terminator is очищенный из_
        each resultant Массив.

        ---
        foreach (строка; lines ("one\ntwo\nthree"))
                 ...
        ---
        
******************************************************************************/

LineFruct!(T) lines(T) (T[] ист)
{
        LineFruct!(T) lines;
        lines.ист = ист;
        return lines;
}

/******************************************************************************

        Обходчик в_ isolate текст elements.

        Splits the provопрed Массив wherever a delimiter-установи экземпляр is
        найдено, and return the resultant segments. The delimiters are
        excluded из_ each of the segments. Note that delimiters are
        matched as a установи of alternates rather than as a образец.

        Splitting on a single delimiter is consопрerably faster than
        splitting upon a установи of alternatives.

        ---
        foreach (segment; delimiters ("one,two;three", ",;"))
                 ...
        ---
        
******************************************************************************/

DelimFruct!(T) delimiters(T) (T[] ист, T[] установи)
{
        DelimFruct!(T) elements;
        elements.установи = установи;
        elements.ист = ист;
        return elements;
}

/******************************************************************************

        Обходчик в_ isolate текст elements.

        разбей the provопрed Массив wherever a образец экземпляр is найдено, 
        and return the resultant segments. образец are excluded из_
        each of the segments, and an optional sub аргумент enables 
        replacement.
        
        ---
        foreach (segment; образцы ("one, two, three", ", "))
                 ...
        ---
        
******************************************************************************/

PatternFruct!(T) образцы(T) (T[] ист, T[] образец, T[] sub=пусто)
{
        PatternFruct!(T) elements;
        elements.образец = образец;
        elements.sub = sub;
        elements.ист = ист;
        return elements;
}

/******************************************************************************

        Обходчик в_ isolate optionally quoted текст elements.

        As per elements(), but with the extension of being quote-aware;
        the установи of delimiters is ignored insопрe a pair of quotes. Note
        that an unterminated quote will используй remaining контент.
        
        ---
        foreach (quote; quotes ("one two 'three four' five", " "))
                 ...
        ---
        
******************************************************************************/

QuoteFruct!(T) quotes(T) (T[] ист, T[] установи)
{
        QuoteFruct!(T) quotes;
        quotes.установи = установи;
        quotes.ист = ист;
        return quotes;
}

/*******************************************************************************

        Arranges текст strings in order, using indices в_ specify where
        each particular аргумент should be positioned within the текст. 
        This is handy for collating I18N components, or as a simplistic
        and lightweight форматёр. Indices range из_ zero through nine. 
        
        ---
        // пиши ordered текст в_ the console
        сим[64] врем;

        Квывод (выкладка (врем, "%1 is after %0", "zero", "one")).нс;
        ---

*******************************************************************************/

T[] выкладка(T) (T[] вывод, T[][] выкладка ...)
{
        static T[] badarg   = "{индекс out of range}";
        static T[] toosmall = "{вывод буфер too small}";
        
        цел     поз,
                арги;
        бул    состояние;

        арги = выкладка.length - 1;
        foreach (c; выкладка[0])
                {
                if (состояние)
                   {
                   состояние = нет;
                   if (c >= '0' && c <= '9')
                      {
                      т_мера индекс = c - '0';
                      if (индекс < арги)
                         {
                         T[] x = выкладка[индекс+1];

                         цел предел = поз + x.length;
                         if (предел < вывод.length)
                            {
                            вывод [поз .. предел] = x;
                            поз = предел;
                            continue;
                            } 
                         else
                            return toosmall;
                         }
                      else
                         return badarg;
                      }
                   }
                else
                   if (c is '%')
                      {
                      состояние = да;
                      continue;
                      }

                if (поз < вывод.length)
                   {
                   вывод[поз] = c;
                   ++поз;
                   }
                else     
                   return toosmall;
                }

        return вывод [0..поз];
}

/******************************************************************************

        Convert 'escaped' chars в_ нормаль ones: \t => ^t for example.
        Supports \" \' \\ \a \b \f \n \r \t \v
        
******************************************************************************/

T[] unescape(T) (T[] ист, T[] приёмн = пусто)
{
        цел delta;
        auto s = ист.ptr;
        auto длин = ист.length;

        // take a Просмотр first в_ see if there's anything
        if ((delta = indexOf (s, '\\', длин)) < длин)
           {
           // сделай some room if not enough provопрed
           if (приёмн.length < ист.length)
               приёмн.length = ист.length;
           auto d = приёмн.ptr;

           // копируй segments over, a chunk at a время
           do {
              d [0 .. delta] = s [0 .. delta];
              длин -= delta;
              s += delta;
              d += delta;

              // bogus trailing '\'
              if (длин < 2)
                 {
                 *d++ = '\\';
                 длин = 0;
                 break;
                 }

              // translate \сим
              auto c = s[1];
              switch (c)
                     {
                      case '\\':
                           break;
                      case '\'':
                           c = '\'';
                           break;
                      case '"':
                           c = '"';
                           break;
                      case 'a':
                           c = '\a';
                           break;
                      case 'b':
                           c = '\b';
                           break;
                      case 'f':
                           c = '\f';
                           break;
                      case 'n':
                           c = '\n';
                           break;
                      case 'r':
                           c = '\r';
                           break;
                      case 't':
                           c = '\t';
                           break;
                      case 'v':
                           c = '\v';
                           break;
                      default:
                           *d++ = '\\';
                     }
              *d++ = c;  
              длин -= 2;           
              s += 2;
              } while ((delta = indexOf (s, '\\', длин)) < длин);

           // копируй хвост too
           d [0 .. длин] = s [0 .. длин];
           return приёмн [0 .. (d + длин) - приёмн.ptr];
           }
        return ист;
}


/******************************************************************************

        jhash() -- hash a переменная-length ключ преобр_в a 32-bit значение

          k     : the ключ (the unaligned переменная-length Массив of байты)
          длин   : the length of the ключ, counting by байты
          уровень : can be any 4-байт значение

        Returns a 32-bit значение.  Every bit of the ключ affects every bit of
        the return значение.  Every 1-bit and 2-bit delta achieves avalanche.

        About 4.3*длин + 80 X86 instructions, with excellent pИПelining

        The best hash table sizes are powers of 2.  There is no need в_ do
        mod a prime (mod is sooo slow!).  If you need less than 32 биты,
        use a bitmask.  For example, if you need only 10 биты, do

                    h = (h & hashmask(10));

        In which case, the hash table should have hashsize(10) elements.
        If you are hashing n strings (ub1 **)k, do it like this:

                    for (i=0, h=0; i<n; ++i) h = hash( k[i], длин[i], h);

        By Bob Jenkins, 1996.  bob_jenkins@burtleburtle.net.  You may use 
        this код any way you wish, private, educational, or commercial.  
        It's free.

        See http://burtleburtle.net/bob/hash/evahash.html
        Use for hash table отыщи, or anything where one collision in 2^32 
        is acceptable. Do NOT use for cryptographic purposes.

******************************************************************************/

т_мера jhash (ббайт* k, т_мера длин, т_мера c = 0)
{
        т_мера a = 0x9e3779b9,
             b = 0x9e3779b9,
             i = длин;

        // укз most of the ключ 
        while (i >= 12) 
              {
              a += *cast(бцел *)(k+0);
              b += *cast(бцел *)(k+4);
              c += *cast(бцел *)(k+8);

              a -= b; a -= c; a ^= (c>>13); 
              b -= c; b -= a; b ^= (a<<8); 
              c -= a; c -= b; c ^= (b>>13); 
              a -= b; a -= c; a ^= (c>>12);  
              b -= c; b -= a; b ^= (a<<16); 
              c -= a; c -= b; c ^= (b>>5); 
              a -= b; a -= c; a ^= (c>>3);  
              b -= c; b -= a; b ^= (a<<10); 
              c -= a; c -= b; c ^= (b>>15); 
              k += 12; i -= 12;
              }

        // укз the последний 11 байты 
        c += длин;
        switch (i)
               {
               case 11: c+=(cast(бцел)k[10]<<24);
               case 10: c+=(cast(бцел)k[9]<<16);
               case 9 : c+=(cast(бцел)k[8]<<8);
               case 8 : b+=(cast(бцел)k[7]<<24);
               case 7 : b+=(cast(бцел)k[6]<<16);
               case 6 : b+=(cast(бцел)k[5]<<8);
               case 5 : b+=(cast(бцел)k[4]);
               case 4 : a+=(cast(бцел)k[3]<<24);
               case 3 : a+=(cast(бцел)k[2]<<16);
               case 2 : a+=(cast(бцел)k[1]<<8);
               case 1 : a+=(cast(бцел)k[0]);
               default:
               }

        a -= b; a -= c; a ^= (c>>13); 
        b -= c; b -= a; b ^= (a<<8); 
        c -= a; c -= b; c ^= (b>>13); 
        a -= b; a -= c; a ^= (c>>12);  
        b -= c; b -= a; b ^= (a<<16); 
        c -= a; c -= b; c ^= (b>>5); 
        a -= b; a -= c; a ^= (c>>3);  
        b -= c; b -= a; b ^= (a<<10); 
        c -= a; c -= b; c ^= (b>>15); 

        return c;
}

/// ditto
т_мера jhash (проц[] x, т_мера c = 0)
{
        return jhash (cast(ббайт*) x.ptr, x.length, c);
}


/******************************************************************************
      
        Helper fruct for iterator lines(). A fruct is a low 
        impact mechanism for capturing контекст relating в_ an 
        opApply (conjunction of the names struct and foreach)
        
******************************************************************************/

private struct LineFruct(T)
{
        private T[] ист;

        цел opApply (цел delegate (ref T[] строка) дг)
        {
                цел     ret;
                т_мера  поз,
                        mark;
                T[]     строка;

                const T nl = '\n';
                const T cr = '\r';

                while ((поз = locate (ист, nl, mark)) < ист.length)
                      {
                      auto конец = поз;
                      if (конец && ист[конец-1] is cr)
                          --конец;

                      строка = ист [mark .. конец];
                      if ((ret = дг (строка)) != 0)
                           return ret;
                      mark = поз + 1;
                      }

                строка = ист [mark .. $];
                if (mark <= ист.length)
                    ret = дг (строка);

                return ret;
        }
}

/******************************************************************************

        Helper fruct for iterator delims(). A fruct is a low 
        impact mechanism for capturing контекст relating в_ an 
        opApply (conjunction of the names struct and foreach)
        
******************************************************************************/

private struct DelimFruct(T)
{
        private T[] ист;
        private T[] установи;

        цел opApply (цел delegate (ref T[] token) дг)
        {
                цел     ret;
                т_мера  поз,
                        mark;
                T[]     token;

                // оптимизируй for single delimiter case
                if (установи.length is 1)
                    while ((поз = locate (ист, установи[0], mark)) < ист.length)
                          {
                          token = ист [mark .. поз];
                          if ((ret = дг (token)) != 0)
                               return ret;
                          mark = поз + 1;
                          }
                else
                   if (установи.length > 1)
                       foreach (i, elem; ист)
                                if (содержит (установи, elem))
                                   {
                                   token = ист [mark .. i];
                                   if ((ret = дг (token)) != 0)
                                        return ret;
                                   mark = i + 1;
                                   }

                token = ист [mark .. $];
                if (mark <= ист.length)
                    ret = дг (token);

                return ret;
        }
}

/******************************************************************************

        Helper fruct for iterator образцы(). A fruct is a low 
        impact mechanism for capturing контекст relating в_ an 
        opApply (conjunction of the names struct and foreach)
        
******************************************************************************/

private struct PatternFruct(T)
{
        private T[] ист,
                    sub,
                    образец;

        цел opApply (цел delegate (ref T[] token) дг)
        {
                цел     ret;
                т_мера  поз,
                        mark;
                T[]     token;

                while ((поз = индекс (ист, образец, mark)) < ист.length)
                      {
                      token = ист [mark .. поз];
                      if ((ret = дг(token)) != 0)
                           return ret;
                      if (sub.ptr && (ret = дг(sub)) != 0)
                          return ret;
                      mark = поз + образец.length;
                      }

                token = ист [mark .. $];
                if (mark <= ист.length)
                    ret = дг (token);

                return ret;
        }
}

/******************************************************************************

        Helper fruct for iterator quotes(). A fruct is a low 
        impact mechanism for capturing контекст relating в_ an 
        opApply (conjunction of the names struct and foreach)
        
******************************************************************************/

private struct QuoteFruct(T)
{
        private T[] ист;
        private T[] установи;
        
        цел opApply (цел delegate (ref T[] token) дг)
        {
                цел     ret;
                т_мера  mark;
                T[]     token;

                if (установи.length)
                    for (т_мера i=0; i < ист.length; ++i)
                        {
                        T c = ист[i];
                        if (c is '"' || c is '\'')
                            i = locate (ист, c, i+1);
                        else
                           if (содержит (установи, c))
                              {
                              token = ист [mark .. i];
                              if ((ret = дг (token)) != 0)
                                   return ret;
                              mark = i + 1;
                              }
                        }
                
                token = ист [mark .. $];
                if (mark <= ист.length)
                    ret = дг (token);

                return ret;
        }
}


/******************************************************************************

******************************************************************************/

debug (UnitTest)
{
        unittest
        {
        сим[64] врем;

        assert (isSpace (' ') && !isSpace ('d'));

        assert (indexOf ("abc".ptr, 'a', 3) is 0);
        assert (indexOf ("abc".ptr, 'b', 3) is 1);
        assert (indexOf ("abc".ptr, 'c', 3) is 2);
        assert (indexOf ("abc".ptr, 'd', 3) is 3);
        assert (indexOf ("abcabcabc".ptr, 'd', 9) is 9);

        assert (indexOf ("abc"d.ptr, cast(дим)'c', 3) is 2);
        assert (indexOf ("abc"d.ptr, cast(дим)'d', 3) is 3);

        assert (indexOf ("abc"w.ptr, cast(шим)'c', 3) is 2);
        assert (indexOf ("abc"w.ptr, cast(шим)'d', 3) is 3);
        assert (indexOf ("abcdefghijklmnopqrstuvwxyz"w.ptr, cast(шим)'x', 25) is 23);

        assert (не_совпадают ("abc".ptr, "abc".ptr, 3) is 3);
        assert (не_совпадают ("abc".ptr, "abd".ptr, 3) is 2);
        assert (не_совпадают ("abc".ptr, "acc".ptr, 3) is 1);
        assert (не_совпадают ("abc".ptr, "ccc".ptr, 3) is 0);

        assert (не_совпадают ("abc"w.ptr, "abc"w.ptr, 3) is 3);
        assert (не_совпадают ("abc"w.ptr, "acc"w.ptr, 3) is 1);

        assert (не_совпадают ("abc"d.ptr, "abc"d.ptr, 3) is 3);
        assert (не_совпадают ("abc"d.ptr, "acc"d.ptr, 3) is 1);

        assert (matching ("abc".ptr, "abc".ptr, 3));
        assert (matching ("abc".ptr, "abb".ptr, 3) is нет);
        
        assert (содержит ("abc", 'a'));
        assert (содержит ("abc", 'b'));
        assert (содержит ("abc", 'c'));
        assert (содержит ("abc", 'd') is нет);

        assert (containsPattern ("abc", "ab"));
        assert (containsPattern ("abc", "bc"));
        assert (containsPattern ("abc", "abc"));
        assert (containsPattern ("abc", "zabc") is нет);
        assert (containsPattern ("abc", "abcd") is нет);
        assert (containsPattern ("abc", "za") is нет);
        assert (containsPattern ("abc", "cd") is нет);

        assert (trim ("") == "");
        assert (trim (" abc  ") == "abc");
        assert (trim ("   ") == "");

        assert (strip ("", '%') == "");
        assert (strip ("%abc%%%", '%') == "abc");
        assert (strip ("#####", '#') == "");
        assert (strИПl ("#####", '#') == "");
        assert (strИПl (" ###", ' ') == "###");
        assert (strИПl ("#####", 's') == "#####");
        assert (strИПr ("#####", '#') == "");
        assert (strИПr ("### ", ' ') == "###");
        assert (strИПr ("#####", 's') == "#####");

        assert (замени ("abc".dup, 'b', ':') == "a:c");
        assert (подставь ("abc".dup, "bc", "x") == "ax");

        assert (locate ("abc", 'c', 1) is 2);

        assert (locate ("abc", 'c') is 2);
        assert (locate ("abc", 'a') is 0);
        assert (locate ("abc", 'd') is 3);
        assert (locate ("", 'c') is 0);

        assert (locatePrior ("abce", 'c') is 2);
        assert (locatePrior ("abce", 'a') is 0);
        assert (locatePrior ("abce", 'd') is 4);
        assert (locatePrior ("abce", 'c', 3) is 2);
        assert (locatePrior ("abce", 'c', 2) is 4);
        assert (locatePrior ("", 'c') is 0);

        auto x = delimit ("::b", ":");
        assert (x.length is 3 && x[0] == "" && x[1] == "" && x[2] == "b");
        x = delimit ("a:bc:d", ":");
        assert (x.length is 3 && x[0] == "a" && x[1] == "bc" && x[2] == "d");
        x = delimit ("abcd", ":");
        assert (x.length is 1 && x[0] == "abcd");
        x = delimit ("abcd:", ":");
        assert (x.length is 2 && x[0] == "abcd" && x[1] == "");
        x = delimit ("a;b$c#d:e@f", ";:$#@");
        assert (x.length is 6 && x[0]=="a" && x[1]=="b" && x[2]=="c" &&
                                 x[3]=="d" && x[4]=="e" && x[5]=="f");

        assert (locatePattern ("abcdefg", "") is 7);
        assert (locatePattern ("abcdefg", "g") is 6);
        assert (locatePattern ("abcdefg", "abcdefg") is 0);
        assert (locatePattern ("abcdefg", "abcdefgx") is 7);
        assert (locatePattern ("abcdefg", "cce") is 7);
        assert (locatePattern ("abcdefg", "cde") is 2);
        assert (locatePattern ("abcdefgcde", "cde", 3) is 7);

        assert (locatePatternPrior ("abcdefg", "") is 7);
        assert (locatePatternPrior ("abcdefg", "cce") is 7);
        assert (locatePatternPrior ("abcdefg", "cde") is 2);
        assert (locatePatternPrior ("abcdefgcde", "cde", 6) is 2);
        assert (locatePatternPrior ("abcdefgcde", "cde", 4) is 2);
        assert (locatePatternPrior ("abcdefg", "abcdefgx") is 7);

        x = splitLines ("a\nb\n");
        assert (x.length is 3 && x[0] == "a" && x[1] == "b" && x[2] == "");
        x = splitLines ("a\r\n");
        assert (x.length is 2 && x[0] == "a" && x[1] == "");

        x = splitLines ("a");
        assert (x.length is 1 && x[0] == "a");
        x = splitLines ("");
        assert (x.length is 1);

        ткст[] q;
        foreach (element; quotes ("1 'avcc   cc ' 3", " "))
                 q ~= element;
        assert (q.length is 3 && q[0] == "1" && q[1] == "'avcc   cc '" && q[2] == "3");

        assert (выкладка (врем, "%1,%%%c %0", "abc", "efg") == "efg,%c abc");

        x = разбей ("one, two, three", ",");
        assert (x.length is 3 && x[0] == "one" && x[1] == " two" && x[2] == " three");
        x = разбей ("one, two, three", ", ");
        assert (x.length is 3 && x[0] == "one" && x[1] == "two" && x[2] == "three");
        x = разбей ("one, two, three", ",,");
        assert (x.length is 1 && x[0] == "one, two, three");
        x = разбей ("one,,", ",");
        assert (x.length is 3 && x[0] == "one" && x[1] == "" && x[2] == "");

        ткст h, t;
        h =  голова ("one:two:three", ":", t);
        assert (h == "one" && t == "two:three");
        h = голова ("one:::two:three", ":::", t);
        assert (h == "one" && t == "two:three");
        h = голова ("one:two:three", "*", t);
        assert (h == "one:two:three" && t is пусто);

        t =  хвост ("one:two:three", ":", h);
        assert (h == "one:two" && t == "three");
        t = хвост ("one:::two:three", ":::", h);
        assert (h == "one" && t == "two:three");
        t = хвост ("one:two:three", "*", h);
        assert (t == "one:two:three" && h is пусто);

        assert (chopl("hello world", "hello ") == "world");
        assert (chopl("hello", "hello") == "");
        assert (chopl("hello world", " ") == "hello world");
        assert (chopl("hello world", "") == "hello world");

        assert (chopr("hello world", " world") == "hello");
        assert (chopr("hello", "hello") == "");
        assert (chopr("hello world", " ") == "hello world");
        assert (chopr("hello world", "") == "hello world");

        ткст[] foo = ["one", "two", "three"];
        auto j = объедини (foo);
        assert (j == "onetwothree");
        j = объедини (foo, ", ");
        assert (j == "one, two, three");
        j = объедини (foo, " ", врем);
        assert (j == "one two three");
        assert (j.ptr is врем.ptr);

        assert (repeat ("abc", 0) == "");
        assert (repeat ("abc", 1) == "abc");
        assert (repeat ("abc", 2) == "abcabc");
        assert (repeat ("abc", 4) == "abcabcabcabc");
        assert (repeat ("", 4) == "");
        сим[10] rep;
        assert (repeat ("abc", 0, rep) == "");
        assert (repeat ("abc", 1, rep) == "abc");
        assert (repeat ("abc", 2, rep) == "abcabc");
        assert (repeat ("", 4, rep) == "");

        assert (unescape ("abc") == "abc");
        assert (unescape ("abc\\") == "abc\\");
        assert (unescape ("abc\\t") == "abc\t");
        assert (unescape ("abc\\tc") == "abc\tc");
        assert (unescape ("\\t") == "\t");
        assert (unescape ("\\tx") == "\tx");
        assert (unescape ("\\v\\vx") == "\v\vx");
        assert (unescape ("abc\\t\\a\\bc") == "abc\t\a\bc");
        }
}



debug (Util)
{
        auto x = import("Util.d");
        
        проц main()
        {
                не_совпадают ("".ptr, x.ptr, 0);
                indexOf ("".ptr, '@', 0);
                ткст s;
                разбей (s, " ");
                //indexOf (s.ptr, '@', 0);

        }
}
