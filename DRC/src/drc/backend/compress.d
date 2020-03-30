/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/compress.d, backend/compress.d)
 */

import cidrus;



/****************************************
 * Find longest match of pattern[0..plen] in dict[0..dlen].
 * Возвращает:
 *      да if match found
 */

private бул longest_match(сим *dict, цел dlen, сим *pattern, цел plen,
        цел *pmatchoff, цел *pmatchlen)
{
    цел matchlen = 0;
    цел matchoff;

    сим c = pattern[0];
    for (цел i = 0; i < dlen; i++)
    {
        if (dict[i] == c)
        {
            цел len = dlen - i;
            if (plen < len)
                len = plen;
            цел j;
            for (j = 1; j < len; j++)
            {
                if (dict[i + j] != pattern[j])
                    break;
            }
            if (j >= matchlen)
            {
                matchlen = j;
                matchoff = i;
            }
        }
    }

    if (matchlen > 1)
    {
        *pmatchlen = matchlen;
        *pmatchoff = matchoff;
        return да;                    // found a match
    }
    return нет;                       // no match
}

/******************************************
 * Compress an идентификатор for имя mangling purposes.
 * Format is if ASCII, then it's just the сим.
 * If high bit set, then it's a length/смещение pair
 *
 * Параметры:
 *      ид = ткст to compress
 *      idlen = length of ид
 *      plen = where to store length of compressed результат
 * Возвращает:
 *      malloc'd compressed 0-terminated идентификатор
 */

extern(C) сим *id_compress(сим *ид, цел idlen, т_мера *plen)
{
    цел count = 0;
    сим *p = cast(сим *)malloc(idlen + 1);
    for (цел i = 0; i < idlen; i++)
    {
        цел matchoff;
        цел matchlen;

        цел j = 0;
        if (i > 1023)
            j = i - 1023;

        if (longest_match(ид + j, i - j, ид + i, idlen - i, &matchoff, &matchlen))
        {   цел off;

            matchoff += j;
            off = i - matchoff;
            //printf("matchoff = %3d, matchlen = %2d, off = %d\n", matchoff, matchlen, off);
            assert(off >= matchlen);

            if (off <= 8 && matchlen <= 8)
            {
                p[count] = cast(сим) (0xC0 | ((off - 1) << 3) | (matchlen - 1));
                count++;
                i += matchlen - 1;
                continue;
            }
            else if (matchlen > 2 && off < 1024)
            {
                if (matchlen >= 1024)
                    matchlen = 1023;    // longest representable match
                p[count + 0] = cast(сим) (0x80 | ((matchlen >> 4) & 0x38) | ((off >> 7) & 7));
                p[count + 1] = cast(сим) (0x80 | matchlen);
                p[count + 2] = cast(сим) (0x80 | off);
                count += 3;
                i += matchlen - 1;
                continue;
            }
        }
        p[count] = ид[i];
        count++;
    }
    p[count] = 0;
    //printf("old size = %d, new size = %d\n", idlen, count);
    assert(count <= idlen);
    *plen = count;
    return p;
}
