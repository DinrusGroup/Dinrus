/**
 * Compiler implementation of the D programming language
 * http://dlang.org
 *
 * Copyright: Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:   Walter Bright, http://www.digitalmars.com
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:    $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/root/outbuffer.d, root/_outbuffer.d)
 * Documentation: https://dlang.org/phobos/dmd_root_outbuffer.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/root/outbuffer.d
 */

module util.outbuffer;

import cidrus;
import util.rmem;
import util.string;
import drc.ast.Node;

debug
{
    debug = stomp; // flush out dangling pointer problems by stomping on unused memory
}

struct БуфВыв
{
    private ббайт[] данные;
    private т_мера смещение;
    private бул notlinehead;
    бул doindent;
    цел уровень;

    static ~this() 
    {
        debug (stomp) memset(данные.ptr, 0xFF, данные.length);
        mem.xfree(данные.ptr);
    }

     т_мера length() { return смещение; }

    /**********************
     * Перемещает владение размещенными данными вызывающему.
     * Возвращает:
     *  указатель на размещённые данные
     */
     ткст0 извлекиДанные()   
    {
        ткст0 p = cast(сим*)данные.ptr;
        данные = null;
        смещение = 0;
        return p;
    }

     проц разрушь()  
    {
        debug (stomp) memset(данные.ptr, 0xFF, данные.length);
        mem.xfree(извлекиДанные());
    }

     проц резервируй(т_мера члобайт)  
    {
        //debug (stomp) printf("БуфВыв::резервируй: size = %lld, смещение = %lld, члобайт = %lld\n", данные.length, смещение, члобайт);
        if (данные.length - смещение < члобайт)
        {
            /* Increase by factor of 1.5; round up to 16 bytes.
             * The odd formulation is so it will map onto single x86 LEA instruction.
             */
            const size = (((смещение + члобайт) * 3 + 30) / 2) & ~15;

            debug (stomp)
            {
                auto p = cast(ббайт*)mem.xmalloc(size);
                memcpy(p, данные.ptr, смещение);
                memset(данные.ptr, 0xFF, данные.length);  // stomp old location
                mem.xfree(данные.ptr);
                memset(p + смещение, 0xff, size - смещение); // stomp unused данные
            }
            else
            {
                auto p = cast(ббайт*)mem.xrealloc(данные.ptr, size);
                if (mem.смИниц_ли) // clear currently unused данные to avoid нет pointers
                    memset(p + смещение + члобайт, 0xff, size - смещение - члобайт);
            }
            данные = p[0 .. size];
        }
    }

    /************************
     * Сокращает размер данных до `size`.
     * Параметры:
     *  size = новый размер данных, должен быть <= `.length`
     */
     проц устРазм(т_мера size)    
    {
        assert(size <= смещение);
        смещение = size;
    }

     проц сбрось()    
    {
        смещение = 0;
    }

    private проц отступ()  
    {
        if (уровень)
        {
            резервируй(уровень);
            данные[смещение .. смещение + уровень] = '\t';
            смещение += уровень;
        }
        notlinehead = да;
    }

     проц пиши(ук данные, т_мера члобайт)  
    {
        пиши(данные[0 .. члобайт]);
    }

    проц пиши(проц[] буф)  
    {
        if (doindent && !notlinehead)
            отступ();
        резервируй(буф.length);
        memcpy(this.данные.ptr + смещение, буф.ptr, буф.length);
        смещение += буф.length;
    }

     проц пишиСтр(ткст0 ткст)  
    {
        пиши(ткст.вТкстД);
    }

    проц пишиСтр(ткст s)  
    {
        пиши(s);
    }

    проц пишиСтр(ткст s)  
    {
        пиши(s);
    }

     проц преставьСтр(ткст0 ткст)  
    {
        т_мера len = strlen(ткст);
        резервируй(len);
        memmove(данные.ptr + len, данные.ptr, смещение);
        memcpy(данные.ptr, ткст, len);
        смещение += len;
    }

    // пиши newline
     проц нс()  
    {
        version (Windows)
        {
            пишиУорд(0x0A0D); // newline is CR,LF on Microsoft OS's
        }
        else
        {
            пишиБайт('\n');
        }
        if (doindent)
            notlinehead = нет;
    }

     проц пишиБайт(бцел b)  
    {
        if (doindent && !notlinehead && b != '\n')
            отступ();
        резервируй(1);
        this.данные[смещение] = cast(ббайт)b;
        смещение++;
    }

     проц пишиЮ8(бцел b)  
    {
        резервируй(6);
        if (b <= 0x7F)
        {
            this.данные[смещение] = cast(ббайт)b;
            смещение++;
        }
        else if (b <= 0x7FF)
        {
            this.данные[смещение + 0] = cast(ббайт)((b >> 6) | 0xC0);
            this.данные[смещение + 1] = cast(ббайт)((b & 0x3F) | 0x80);
            смещение += 2;
        }
        else if (b <= 0xFFFF)
        {
            this.данные[смещение + 0] = cast(ббайт)((b >> 12) | 0xE0);
            this.данные[смещение + 1] = cast(ббайт)(((b >> 6) & 0x3F) | 0x80);
            this.данные[смещение + 2] = cast(ббайт)((b & 0x3F) | 0x80);
            смещение += 3;
        }
        else if (b <= 0x1FFFFF)
        {
            this.данные[смещение + 0] = cast(ббайт)((b >> 18) | 0xF0);
            this.данные[смещение + 1] = cast(ббайт)(((b >> 12) & 0x3F) | 0x80);
            this.данные[смещение + 2] = cast(ббайт)(((b >> 6) & 0x3F) | 0x80);
            this.данные[смещение + 3] = cast(ббайт)((b & 0x3F) | 0x80);
            смещение += 4;
        }
        else
            assert(0);
    }

     проц преставьБайт(бцел b)  
    {
        резервируй(1);
        memmove(данные.ptr + 1, данные.ptr, смещение);
        данные[0] = cast(ббайт)b;
        смещение++;
    }

     проц пишиШим(бцел w)  
    {
        version (Windows)
        {
            пишиУорд(w);
        }
        else
        {
            пиши4(w);
        }
    }

     проц пишиУорд(бцел w)  
    {
        version (Windows)
        {
            бцел newline = 0x0A0D;
        }
        else
        {
            бцел newline = '\n';
        }
        if (doindent && !notlinehead && w != newline)
            отступ();

        резервируй(2);
        *cast(ushort*)(this.данные.ptr + смещение) = cast(ushort)w;
        смещение += 2;
    }

     проц пишиЮ16(бцел w)  
    {
        резервируй(4);
        if (w <= 0xFFFF)
        {
            *cast(ushort*)(this.данные.ptr + смещение) = cast(ushort)w;
            смещение += 2;
        }
        else if (w <= 0x10FFFF)
        {
            *cast(ushort*)(this.данные.ptr + смещение) = cast(ushort)((w >> 10) + 0xD7C0);
            *cast(ushort*)(this.данные.ptr + смещение + 2) = cast(ushort)((w & 0x3FF) | 0xDC00);
            смещение += 4;
        }
        else
            assert(0);
    }

     проц пиши4(бцел w)  
    {
        version (Windows)
        {
            бул notnewline = w != 0x000A000D;
        }
        else
        {
            бул notnewline = да;
        }
        if (doindent && !notlinehead && notnewline)
            отступ();
        резервируй(4);
        *cast(бцел*)(this.данные.ptr + смещение) = w;
        смещение += 4;
    }

     проц пиши(БуфВыв* буф)  
    {
        if (буф)
        {
            резервируй(буф.смещение);
            memcpy(данные.ptr + смещение, буф.данные.ptr, буф.смещение);
            смещение += буф.смещение;
        }
    }

     проц пиши(КорневойОбъект obj)
    {
        if (obj)
        {
            пишиСтр(obj.вТкст0());
        }
    }

     проц занули(т_мера члобайт)  
    {
        резервируй(члобайт);
        memset(данные.ptr + смещение, 0, члобайт);
        смещение += члобайт;
    }

    /**
     * Разместить пространство, но оставить неинициализованным.
     * Параметры:
     *  члобайт = размещаемое количество
     * Возвращает:
     *  срез размещённого пространства для заполнения
     */
    ткст размести(т_мера члобайт)  
    {
        резервируй(члобайт);
        смещение += члобайт;
        return cast(ткст)данные[смещение - члобайт .. смещение];
    }

     проц vprintf(ткст0 format, va_list args) 
    {
        цел count;
        if (doindent && !notlinehead)
            отступ();
        бцел psize = 128;
        for (;;)
        {
            резервируй(psize);
            va_list va;
            va_copy(va, args);
            /*
                Функции vprintf(), vfprintf(), vsprintf(), vsnprintf()
                эквивалентны функциям printf(), fprintf(), sprintf(),
                snprintf(), соответственно, за исключением того, что вызываются с
                va_list вместо переменного числа аргументов. Эти функции
                не вызывают макрос va_end. В следствие этого значение
                ap после вызова неопределённое. Приложение должно вызвать
                va_end(ap) впоследствии самостоятельно.
                */
            count = vsnprintf(cast(сим*)данные.ptr + смещение, psize, format, va);
            va_end(va);
            if (count == -1) // snn.lib and older libcmt.lib return -1 if буфер too small
                psize *= 2;
            else if (count >= psize)
                psize = count + 1;
            else
                break;
        }
        смещение += count;
        if (mem.смИниц_ли)
            memset(данные.ptr + смещение, 0xff, psize - count);
    }

     проц printf(ткст0 format, ...) 
    {
        va_list ap;
        va_start(ap, format);
        vprintf(format, ap);
        va_end(ap);
    }

    /**************************************
     * Convert `u` to a ткст and приставь it to the буфер.
     * Параметры:
     *  u = integral значение to приставь
     */
     проц print(бдол u)  
    {
        //import core.internal.ткст;  // not доступно
        UnsignedStringBuf буф = проц;
        пишиСтр(unsignedToTempString(u, буф));
    }

     проц bracket(сим left, сим right)  
    {
        резервируй(2);
        memmove(данные.ptr + 1, данные.ptr, смещение);
        данные[0] = left;
        данные[смещение + 1] = right;
        смещение += 2;
    }

    /******************
     * Insert left at i, and right at j.
     * Return index just past right.
     */
     т_мера bracket(т_мера i, ткст0 left, т_мера j, ткст0 right)  
    {
        т_мера leftlen = strlen(left);
        т_мера rightlen = strlen(right);
        резервируй(leftlen + rightlen);
        вставь(i, left, leftlen);
        вставь(j + leftlen, right, rightlen);
        return j + leftlen + rightlen;
    }

     проц spread(т_мера смещение, т_мера члобайт)  
    {
        резервируй(члобайт);
        memmove(данные.ptr + смещение + члобайт, данные.ptr + смещение, this.смещение - смещение);
        this.смещение += члобайт;
    }

    /****************************************
     * Возвращает: смещение + члобайт
     */
     т_мера вставь(т_мера смещение, ук p, т_мера члобайт)  
    {
        spread(смещение, члобайт);
        memmove(данные.ptr + смещение, p, члобайт);
        return смещение + члобайт;
    }

    т_мера вставь(т_мера смещение, ткст s)  
    {
        return вставь(смещение, s.ptr, s.length);
    }

     проц удали(т_мера смещение, т_мера члобайт)   
    {
        memmove(данные.ptr + смещение, данные.ptr + смещение + члобайт, this.смещение - (смещение + члобайт));
        this.смещение -= члобайт;
    }

    /**
     * Возвращает:
     *   a non-owning const slice of the буфер contents
     */
    extern (D) ткст opSlice() 
    {
        return cast(ткст)данные[0 .. смещение];
    }

    extern (D) ткст opSlice(т_мера lwr, т_мера upr) 
    {
        return cast(ткст)данные[lwr .. upr];
    }

    extern (D) сим opIndex(т_мера i) 
    {
        return cast(сим)данные[i];
    }

    /***********************************
     * Extract the данные as a slice and take ownership of it.
     *
     * When `да` is passed as an argument, this function behaves
     * like `util.utils.вТкстД(thisbuffer.extractChars())`.
     *
     * Параметры:
     *   nullTerminate = When `да`, the данные will be `null` terminated.
     *                   This is useful to call C functions or store
     *                   the результат in `Strings`. Defaults to `нет`.
     */
    extern (D) ткст извлекиСрез(бул nullTerminate = нет) 
    {
        const length = смещение;
        if (!nullTerminate)
            return извлекиДанные()[0 .. length];
        // There's already a terminating `'\0'`
        if (length && данные[length - 1] == '\0')
            return извлекиДанные()[0 .. length - 1];
        пишиБайт(0);
        return извлекиДанные()[0 .. length];
    }

    // Append terminating null if necessary and get view of internal буфер
     ткст0 peekChars()  
    {
        if (!смещение || данные[смещение - 1] != '\0')
        {
            пишиБайт(0);
            смещение--; // allow appending more
        }
        return cast(сим*)данные.ptr;
    }

    // Append terminating null if necessary and take ownership of данные
     ткст0 extractChars()  
    {
        if (!смещение || данные[смещение - 1] != '\0')
            пишиБайт(0);
        return извлекиДанные();
    }
}

/****** copied from core.internal.ткст *************/

private:

alias сим[20] UnsignedStringBuf;

ткст unsignedToTempString(бдол значение, ткст буф, бцел radix = 10)    
{
    т_мера i = буф.length;
    do
    {
        if (значение < radix)
        {
            ббайт x = cast(ббайт)значение;
            буф[--i] = cast(сим)((x < 10) ? x + '0' : x - 10 + 'a');
            break;
        }
        else
        {
            ббайт x = cast(ббайт)(значение % radix);
            значение = значение / radix;
            буф[--i] = cast(сим)((x < 10) ? x + '0' : x - 10 + 'a');
        }
    } while (значение);
    return буф[i .. $];
}

/************* unit tests **************************************************/

unittest
{
    БуфВыв буф;
    буф.printf("betty");
    буф.вставь(1, "xx".ptr, 2);
    буф.вставь(3, "yy");
    буф.удали(4, 1);
    буф.bracket('(', ')');
    const ткст s = буф[];
    assert(s == "(bxxyetty)");
    буф.разрушь();
}

unittest
{
    БуфВыв буф;
    буф.пишиСтр("abc".ptr);
    буф.преставьСтр("def");
    буф.преставьБайт('x');
    БуфВыв buf2;
    buf2.пишиСтр("mmm");
    буф.пиши(&buf2);
    ткст s = буф.извлекиСрез();
    assert(s == "xdefabcmmm");
}

unittest
{
    БуфВыв буф;
    буф.пишиБайт('a');
    ткст s = буф.извлекиСрез();
    assert(s == "a");

    буф.пишиБайт('b');
    ткст t = буф.извлекиСрез();
    assert(t == "b");
}

unittest
{
    БуфВыв буф;
    ткст0 p = буф.peekChars();
    assert(*p == 0);

    буф.пишиБайт('s');
    ткст0 q = буф.peekChars();
    assert(strcmp(q, "s") == 0);
}

unittest
{
    сим[10] буф;
    ткст s = unsignedToTempString(278, буф[], 10);
    assert(s == "278");

    s = unsignedToTempString(1, буф[], 10);
    assert(s == "1");

    s = unsignedToTempString(8, буф[], 2);
    assert(s == "1000");

    s = unsignedToTempString(29, буф[], 16);
    assert(s == "1d");
}
