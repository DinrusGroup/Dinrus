/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1984-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/util2.d, backend/util2.d)
 */

// Only используется for DMD

module drc.backend.util2;

// Utility subroutines

import cidrus;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.глоб2;
import drc.backend.mem;

/*extern (C++):*/



проц *ph_malloc(т_мера члобайт);
проц *ph_calloc(т_мера члобайт);
проц ph_free(проц *p);
проц *ph_realloc(проц *p , т_мера члобайт);

extern (C) проц printInternalFailure(FILE* stream); // from dmd/mars.d

проц file_progress()
{
}

/*******************************
 * Alternative assert failure.
 */

проц util_assert(ткст0 файл, цел line)
{
    fflush(stdout);
    printInternalFailure(stdout);
    printf("Internal error: %s %d\n",файл,line);
    err_exit();
//#if __clang__
//    __builtin_unreachable();
//#endif
}

/****************************
 * Clean up and exit program.
 */

проц err_exit()
{
    util_exit(EXIT_FAILURE);
}

/********************************
 * Clean up and exit program.
 */

проц err_break()
{
    util_exit(255);
}


/****************************
 * Clean up and exit program.
 */

проц util_exit(цел exitcode)
{
    exit(exitcode);                     /* terminate abnormally         */
}

version (CRuntime_DigitalMars)
{

extern (C) extern  цел controlc_saw;

/********************************
 * Control C interrupts go here.
 */

private extern (C) проц controlc_handler()
{
    //printf("saw controlc\n");
    controlc_saw = 1;
}

/*********************************
 * Trap control C interrupts.
 */

version (Dinrus) { } else
{

extern (C)
{
проц controlc_open();
проц controlc_close();
alias проц function() _controlc_handler_t;
extern  _controlc_handler_t _controlc_handler;

проц _STI_controlc()
{
    //printf("_STI_controlc()\n");
    _controlc_handler = &controlc_handler;
    controlc_open();                    /* trap control C               */
}

проц _STD_controlc()
{
    //printf("_STD_controlc()\n");
    controlc_close();
}
}

}
}

/***********************************
 * Send progress report.
 */

проц util_progress()
{
    version (Dinrus) { } else {
    version (CRuntime_DigitalMars)
    {
        if (controlc_saw)
            err_break();
    }
    }
}

проц util_progress(цел номстр)
{
    version (Dinrus) { } else {
    version (CRuntime_DigitalMars)
    {
        if (controlc_saw)
            err_break();
    }
    }
}


/**********************************
 * Binary ткст search.
 * Input:
 *      p .    ткст of characters
 *      tab     массив of pointers to strings
 *      n =     number of pointers in the массив
 * Возвращает:
 *      index (0..n-1) into tab[] if we found a ткст match
 *      else -1
 */

version (X86) version (CRuntime_DigitalMars)
    version = X86asm;

цел binary(ткст0 p, ткст0  *table,цел high)
{
version (X86asm)
{
    alias high len;        // reuse параметр storage
    asm
    {

// First найди the length of the идентификатор.
        xor     EAX,EAX         ; // Scan for a 0.
        mov     EDI,p           ;
        mov     ECX,EAX         ;
        dec     ECX             ; // Longest possible ткст.
        repne                   ;
        scasb                   ;
        mov     EDX,high        ; // EDX = high
        not     ECX             ; // length of the ид including '/0', stays in ECX
        dec     EDX             ; // high--
        js      short Lnotfound ;
        dec     EAX             ; // EAX = -1, so that eventually EBX = low (0)
        mov     len,ECX         ;

        even                    ;
L4D:    lea     EBX,[EAX + 1]   ; // low = mid + 1
        cmp     EBX,EDX         ;
        jg      Lnotfound       ;

        even                    ;
L15:    lea     EAX,[EBX + EDX] ; // EAX = low + high

// Do the ткст compare.

        mov     EDI,table       ;
        sar     EAX,1           ; // mid = (low + high) >> 1
        mov     ESI,p           ;
        mov     EDI,[4*EAX+EDI] ; // Load table[mid]
        mov     ECX,len         ; // length of ид
        repe                    ;
        cmpsb                   ;

        je      short L63       ; // return mid if equal
        jns     short L4D       ; // if (cond < 0)
        lea     EDX,-1[EAX]     ; // high = mid - 1
        cmp     EBX,EDX         ;
        jle     L15             ;

Lnotfound:
        mov     EAX,-1          ; // Return -1.

        even                    ;
L63:                            ;
    }
}
else
{
    цел low = 0;
    сим cp = *p;
    high--;
    p++;

    while (low <= high)
    {
        цел mid = (low + high) >> 1;
        цел cond = table[mid][0] - cp;
        if (cond == 0)
            cond = strcmp(table[mid] + 1,p);
        if (cond > 0)
            high = mid - 1;
        else if (cond < 0)
            low = mid + 1;
        else
            return mid;                 /* match index                  */
    }
    return -1;
}
}


// search table[0 .. high] for p[0 .. len] (where p.length not necessairily equal to len)
цел binary(ткст0 p, т_мера len, сим** table, цел high)
{
    цел low = 0;
    сим cp = *p;
    high--;
    p++;
    len--;

    while (low <= high)
    {
        цел mid = (low + high) >> 1;
        цел cond = table[mid][0] - cp;

        if (cond == 0)
        {
            cond = strncmp(table[mid] + 1, p, len);
            if (cond == 0)
                cond = table[mid][len+1]; // same as: if (table[mid][len+1] != '\0') cond = 1;
        }

        if (cond > 0)
            high = mid - 1;
        else if (cond < 0)
            low = mid + 1;
        else
            return mid;                 /* match index                  */
    }
    return -1;
}

/**********************
 * If c is a power of 2, return that power else -1.
 */

цел ispow2(uint64_t c)
{       цел i;

        if (c == 0 || (c & (c - 1)))
            i = -1;
        else
            for (i = 0; c >>= 1; i++)
            { }
        return i;
}

/***************************
 */

const UTIL_PH = да;

version (MEM_DEBUG)
    const MEM_DEBUG = нет; //да;
else
    const MEM_DEBUG = нет;

version (Windows)
{
проц *util_malloc(бцел n,бцел size)
{
static if (MEM_DEBUG)
{
    проц *p;

    p = mem_malloc(n * size);
    //dbg_printf("util_calloc(%d) = %p\n",n * size,p);
    return p;
}
else static if (UTIL_PH)
{
    return ph_malloc(n * size);
}
else
{
    т_мера члобайт = cast(т_мера)n * cast(т_мера)size;
    проц *p = malloc(члобайт);
    if (!p && члобайт)
        err_nomem();
    return p;
}
}
}

/***************************
 */

version (Windows)
{
проц *util_calloc(бцел n,бцел size)
{
static if (MEM_DEBUG)
{
    проц *p;

    p = mem_calloc(n * size);
    //dbg_printf("util_calloc(%d) = %p\n",n * size,p);
    return p;
}
else static if (UTIL_PH)
{
    return ph_calloc(n * size);
}
else
{
    т_мера члобайт = cast(т_мера) n * cast(т_мера) size;
    проц *p = calloc(n,size);
    if (!p && члобайт)
        err_nomem();
    return p;
}
}
}

/***************************
 */

version (Windows)
{
проц util_free(проц *p)
{
    //dbg_printf("util_free(%p)\n",p);
static if (MEM_DEBUG)
{
    mem_free(p);
}
else static if (UTIL_PH)
{
    ph_free(p);
}
else
{
    free(p);
}
}
}

/***************************
 */

version (Windows)
{
проц *util_realloc(проц *oldp,бцел n,бцел size)
{
static if (MEM_DEBUG)
{
    //dbg_printf("util_realloc(%p,%d)\n",oldp,n * size);
    return mem_realloc(oldp,n * size);
}
else static if (UTIL_PH)
{
    return ph_realloc(oldp,n * size);
}
else
{
    т_мера члобайт = cast(т_мера) n * cast(т_мера) size;
    проц *p = realloc(oldp,члобайт);
    if (!p && члобайт)
        err_nomem();
    return p;
}
}
}

/*****************************
 */
проц *mem_malloc2(бцел size)
{
    return mem_malloc(size);
}
