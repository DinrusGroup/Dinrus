/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1994-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/outbuf.d, backend/outbuf.d)
 * Documentation: https://dlang.org/phobos/dmd_backend_outbuf.html
 */

module drc.backend.outbuf;

import cidrus;

// Output буфер

// (This используется to be called БуфВыв, renamed to avoid имя conflicts with Mars.)

/*extern (C++):*/

private  проц err_nomem();

class Outbuffer
{
    ббайт *буф;         // the буфер itself
    ббайт *pend;        // pointer past the end of the буфер
    ббайт *p;           // current position in буфер
    ббайт *origbuf;     // external буфер

  
    this(т_мера initialSize)
    {
        enlarge(initialSize);
    }

    this(ббайт *bufx, т_мера bufxlen, бцел incx)
    {
        буф = bufx; pend = bufx + bufxlen; p = bufx; origbuf = bufx;
    }

    //~this() { dtor(); }

    проц dtor()
    {
        if (буф != origbuf)
        {
            if (буф)
                free(буф);
        }
    }

    проц сбрось()
    {
        p = буф;
    }

    // Reserve члобайт in буфер
    проц резервируй(т_мера члобайт)
    {
        if (pend - p < члобайт)
            enlarge(члобайт);
    }

    // Reserve члобайт in буфер
    проц enlarge(т_мера члобайт)
    {
        const т_мера oldlen = pend - буф;
        const т_мера используется = p - буф;

        т_мера len = используется + члобайт;
        if (len <= oldlen)
            return;

        const т_мера newlen = oldlen + (oldlen >> 1);   // oldlen * 1.5
        if (len < newlen)
            len = newlen;
        len = (len + 15) & ~15;

        if (буф == origbuf && origbuf)
        {
            буф = cast(ббайт*) malloc(len);
            if (буф)
                memcpy(буф, origbuf, используется);
        }
        else
            буф = cast(ббайт*) realloc(буф,len);
        if (!буф)
            err_nomem();

        pend = буф + len;
        p = буф + используется;
    }


    // Write n zeros; return pointer to start of zeros
    проц *writezeros(т_мера n)
    {
        if (pend - p < n)
            резервируй(n);
        проц *pstart = memset(p,0,n);
        p += n;
        return pstart;
    }

    // Position буфер to прими the specified number of bytes at смещение
    проц position(т_мера смещение, т_мера члобайт)
    {
        if (смещение + члобайт > pend - буф)
        {
            enlarge(смещение + члобайт - (p - буф));
        }
        p = буф + смещение;

        debug assert(буф <= p);
        debug assert(p <= pend);
        debug assert(p + члобайт <= pend);
    }

    // Write an массив to the буфер, no резервируй check
    проц writen( проц *b, т_мера len)
    {
        memcpy(p,b,len);
        p += len;
    }

    // Clear bytes, no резервируй check
    проц clearn(т_мера len)
    {
        foreach (i; new бцел[0 .. len])
            *p++ = 0;
    }

    // Write an массив to the буфер.
    extern (D)
    проц пиши(проц[] b)
    {
        if (pend - p < b.length)
            резервируй(b.length);
        memcpy(p, b.ptr, b.length);
        p += b.length;
    }

    проц пиши(ук b, т_мера len)
    {
        пиши(b[0 .. len]);
    }

    проц пиши(Outbuffer *b) { пиши(b.буф[0 .. b.p - b.буф]); }

    /**
     * Flushes the stream. This will пиши any buffered
     * output bytes.
     */
    проц flush() { }

    /**
     * Writes an 8 bit byte, no резервируй check.
     */
    проц writeByten(ббайт v)
    {
        *p++ = v;
    }

    /**
     * Writes an 8 bit byte.
     */
    проц пишиБайт(цел v)
    {
        if (pend == p)
            резервируй(1);
        *p++ = cast(ббайт)v;
    }

    /**
     * Writes a 16 bit little-end short, no резервируй check.
     */
    проц writeWordn(цел v)
    {
        version (LittleEndian)
        {
            *cast(ushort *)p = cast(ushort)v;
        }
        else
        {
            p[0] = v;
            p[1] = v >> 8;
        }
        p += 2;
    }


    /**
     * Writes a 16 bit little-end short.
     */
    проц writeWord(цел v)
    {
        резервируй(2);
        writeWordn(v);
    }


    /**
     * Writes a 16 bit big-end short.
     */
    проц writeShort(цел v)
    {
        if (pend - p < 2)
            резервируй(2);
        ббайт *q = p;
        q[0] = cast(ббайт)(v >> 8);
        q[1] = cast(ббайт)v;
        p += 2;
    }

    /**
     * Writes a 16 bit сим.
     */
    проц writeChar(цел v)
    {
        writeShort(v);
    }

    /**
     * Writes a 32 bit цел.
     */
    проц write32(цел v)
    {
        if (pend - p < 4)
            резервируй(4);
        *cast(цел *)p = v;
        p += 4;
    }

    /**
     * Writes a 64 bit long.
     */
    проц write64(long v)
    {
        if (pend - p < 8)
            резервируй(8);
        *cast(long *)p = v;
        p += 8;
    }


    /**
     * Writes a 32 bit float.
     */
    проц writeFloat(float v)
    {
        if (pend - p < float.sizeof)
            резервируй(float.sizeof);
        *cast(float *)p = v;
        p += float.sizeof;
    }

    /**
     * Writes a 64 bit double.
     */
    проц writeDouble(double v)
    {
        if (pend - p < double.sizeof)
            резервируй(double.sizeof);
        *cast(double *)p = v;
        p += double.sizeof;
    }

    /**
     * Writes a String as a sequence of bytes.
     */
    проц пиши(ткст0 s)
    {
        пиши(s[0 .. strlen(s)]);
    }

    /**
     * Writes a String as a sequence of bytes.
     */
    проц пиши(ббайт* s)
    {
        пиши(cast(сим*)s);
    }

    /**
     * Writes a 0 terminated String
     */
    проц writeString(ткст0 s)
    {
        пиши(s[0 .. strlen(s)+1]);
    }

    /**
     * Inserts ткст at beginning of буфер.
     */
    проц prependBytes(ткст0 s)
    {
        prepend(s, strlen(s));
    }

    /**
     * Inserts bytes at beginning of буфер.
     */
    проц prepend(ук b, т_мера len)
    {
        резервируй(len);
        memmove(буф + len,буф,p - буф);
        memcpy(буф,b,len);
        p += len;
    }

    /**
     * Bracket буфер contents with c1 and c2.
     */
    проц bracket(сим c1,сим c2)
    {
        резервируй(2);
        memmove(буф + 1,буф,p - буф);
        буф[0] = c1;
        p[1] = c2;
        p += 2;
    }

    /**
     * Возвращает the number of bytes written.
     */
    т_мера size()
    {
        return p - буф;
    }

    /**
     * Convert to a ткст.
     */

    сим * вТкст0()
    {
        if (pend == p)
            резервируй(1);
        *p = 0;                     // terminate ткст
        return cast(сим*)буф;
    }

    /**
     * Set current size of буфер.
     */

    проц устРазм(т_мера size)
    {
        p = буф + size;
        //debug assert(буф <= p);
        //debug assert(p <= pend);
    }

    проц writesLEB128(цел значение)
    {
        while (1)
        {
            ббайт b = значение & 0x7F;

            значение >>= 7;            // arithmetic right shift
            if (значение == 0 && !(b & 0x40) ||
                значение == -1 && (b & 0x40))
            {
                 пишиБайт(b);
                 break;
            }
            пишиБайт(b | 0x80);
        }
    }

    проц writeuLEB128(бцел значение)
    {
        do
        {
            ббайт b = значение & 0x7F;

            значение >>= 7;
            if (значение)
                b |= 0x80;
            пишиБайт(b);
        } while (значение);
    }
}
