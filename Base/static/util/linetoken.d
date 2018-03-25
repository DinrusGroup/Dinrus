/**************************************************************************

        @файл linetoken.d

        Copyright (c) 2005 Derek Parnell

        This software is provided 'as-is', without any express or implied
        warranty. In no event will the authors be held liable for damages
        of any kind arising from the use of this software.

        Permission is hereby granted to anyone to use this software for any
        purpose, including commercial applications, и to alter it и/or
        redistribute it freely, subject to the following restrictions:

        1. The origin of this software must not be misrepresented; you must
           not claim that you wrote the original software. If you use this
           software in a product, an acknowledgment внутри documentation of
           said product would be оценена достойно, но не является обязательной.

        2. Altered source versions must be plainly marked as such, и must
           not неверно представлены, как оригинальное ПО.

        3. This notice may not be removed or altered from any ни в каком дистрибутиве
           of the source.

        4. Derivative works are permitted, but they must carry this notice
           in full и credit the original source.


                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


        @version        Initial version, January 2005
        @author         Derek Parnell


**************************************************************************/
module util.linetoken;

private {
   import stdrus;

}
ткст[] разбериСтроку(ткст pSource,
                      ткст pDelim = ",",
                      ткст pComment = "//",
                      ткст pEscape = "\\")
{
    дим[][] lTemp;
    ткст[] lResult;

    lTemp= разбериСтроку( вЮ32(pSource),
                         вЮ32(pDelim),
                         вЮ32(pComment),
                         вЮ32(pEscape) );
    foreach( юткст lLine; lTemp )
    {
        lResult ~= вЮ8( lLine );
    }

    return lResult;
}

юткст[] разбериСтроку(юткст pSource,
                       юткст pDelim = ",",
                       юткст pComment = "//",
                       юткст pEscape = "\\")
{
    юткст[] lResult;
    дим lOpenBracket;
    дим lCloseBracket;
    цел lNestLevel;
    цел lInToken;
    юткст lDelim;
    цел lTrimSpot;
    цел lPos;
    бул lLitMode;

    static юткст vOpenBracket  = "\"'([{`";
    static юткст vCloseBracket = "\"')]}`";

    if (pDelim.length > 0)
        // Only use single-сим разграничители. Excess chars are ignored.
        lDelim ~= pDelim[0];
    else
        lDelim = "";   // Meaning 'any group of whitespace chars'

    lInToken = -1;
    lTrimSpot = -1;
    foreach(цел i, дим c; pSource)
    {
        if (lNestLevel == 0)
        {   // Check for comment string.
            if (pComment.length > 0)
            {
                if (c == pComment[0])
                {
                    if ((pSource.length - i) > pComment.length)
                    {
                        if (pSource[i .. i + pComment.length] == pComment)
                            break;
                    }
                }
            }
        }

        if(lInToken == -1)
        {
            // Not in a токен yet.
            if (межбукв_ли(c))
                continue;  // Skip over spaces

            // Non-space so a токен is about to start.
            lInToken = lResult.length;
            lResult.length = lInToken + 1;
            lTrimSpot = -1;
        }

        if (lLitMode)
        {   // In literal character mode, so just accept the сим
            // without examining it.
            lResult[lInToken] ~= c;
            lLitMode = false;
            lTrimSpot = -1;
            continue;
        }

        if (pEscape.length > 0 && (c == pEscape[0]))
        {   // Slip into literal character mode
            lLitMode = true;
            continue;
        }

        if (lNestLevel == 0)
        {   // Only проверь for разграничители if not in 'bracket'-mode.
            if (lDelim.length == 0)
            {
                if (межбукв_ли(c))
                {
                    lTrimSpot = -1;
                    lInToken = -1;
                    // Go fetch next character.
                    continue;
                }
            }
            else if (c == lDelim[0])
            {
                // Found a токен delimiter, so I end the текущ токен.
                if (lTrimSpot != -1)
                {
                    // But первый I убери off trailing spaces.
                    lResult[lInToken].length = lTrimSpot-1;
                    lTrimSpot = -1;
                }
                lInToken = lResult.length;
                lResult.length = lInToken + 1;
                // Go fetch next character.
                continue;
            }
        }

        if (lResult[lInToken].length == 0)
        {
            // Not started a токен yet.
            юткст lChar;

            lChar.length = 1;
            lChar[0] = c;
            lPos = найди(вЮ8(vOpenBracket), вЮ8(lChar));
            if (lPos != -1)
            {
                // An 'открой' bracket was found, so make this its
                // own токен, start another new one, и go into
                // 'bracket'-mode.
                lResult[lInToken] ~= c;

                lInToken = lResult.length;
                lResult.length = lInToken + 1;

                lOpenBracket = c;
                lCloseBracket = vCloseBracket[lPos];
                lNestLevel = 1;
                // Go fetch next character.
                continue;
            }
        }

        if (lNestLevel > 0)
        {
            if (c == lCloseBracket)
            {
                lNestLevel--;
                if (lNestLevel == 0)
                {
                    // Okay, I've found the end of the bracketed chars.
                    // Note that this doesn't necessarily mean the end of
                    // a токен was also found. And I can start проверьing
                    // again for trailing spaces.
                    lTrimSpot = -1;

                    // Go fetch next character
                    continue;
                }
            } else if (c == lOpenBracket)
            {
                // Note that the сим is added to the токен too.
                lNestLevel++;
            }
        }

        // Finally, I дай to add this сим to the токен.
        lResult[lInToken] ~= c;

        if (lNestLevel == 0)
            // Only проверь for trailing spaces if not in 'bracket'-mode
            if (межбукв_ли(c))
            {
                // It was a space, so it is potentially a trailing space,
                // thus I метка its spot (if it's the первый in a установи of spaces.)
                if (lTrimSpot == -1)
                    lTrimSpot = lResult[lInToken].length;
            }
            else
               lTrimSpot = -1;

    }

    if (lResult.length == 0)
        lResult ~= "";

    if (lTrimSpot != -1)
    {
        // Trim off trailing spaces on последний токен.
        lResult[$-1].length = lTrimSpot-1;
    }

    return lResult;
}

/* How To Use ===============================
Insert this into your код ...

  private import linetoken;

Then to call it use ...

   ткст Toks;
   ткст InputLine;
   ткст DelimChar;
   ткст CommentString;

   Toks = разбериСтроку(InputLine, DelimChar, CommentString);
** Note that it accepts all 'ткст' or all 'дим[]' аргументы.

The routine scans the input string и returns a установи of strings, one
per токен found in the input string.

The токены are delimited by the single character in DelimChar. However,
if DelimChar is an empty string, then токены are delimited by any group
of one or more white-space characters. By default, DelimChar is ",".

If CommentString is not empty, then all parts of the input string from
the begining of the comment to the end are ignored. By default
CommentString is "//".

If a токен начинается_с with a quote (single, double or back), then you will
дай back two токены. The первый is the quote as a single character string,
и the секунда is all the characters up to, but not including the next
quote of the same тип. The ending quote is discarded.

If a токен начинается_с with a bracket (parenthesis, square, or brace), then you
will дай back two токены. The первый is the opening bracket as a single
character string, и the секунда is all the characters up to, but not
including, the совпадают end bracket, taking nested brackets (of the same
тип) into consideration.

All whitespace in between токены is ignored, и not returned.

If the tokenizer finds a back-slash character (\), then next character
is always considered as a part of a токен. You can use this to force
the delimiter character or spaces to be inserted into a токен.

Examples:
   разбериСтроку(" abc, def , ghi, ")
 --> {"abc", "def", "ghi", ""}

   разбериСтроку("character    or spaces to be \t inserted", "")
 --> {"character", "or", "spaces", "to", "be", "inserted"}

   разбериСтроку(" abc; def , ghi; ", ";")
 --> {"abc", "def , ghi", "" }

   разбериСтроку(" abc, [def , ghi]           ")
 --> {"abc", "[", "def , ghi"}

   разбериСтроку(" abc, [def , ghi] // comment")
 --> {"abc", "[", "def , ghi"}

   разбериСтроку(" abc, [def , [ghi, jkl] ]  ")
 --> {"abc", "[", "def , [ghi, jkl] "}

   разбериСтроку(" abc, def , ghi ; comment", ",", ";")
 --> {"abc", "def", "ghi"}

   разбериСтроку(` abc, "def , ghi" , jkl `)
 --> {"abc", `"`, "def , ghi", "jkl"}
*/
