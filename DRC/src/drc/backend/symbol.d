/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1984-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      https://github.com/dlang/dmd/blob/master/src/dmd/backend/symbol.d
 */

module drc.backend.symbol;

version (SCPP)
{
    version = COMPILE;
    version = SCPP_HTOD;
}
version (HTOD)
{
    version = COMPILE;
    version = SCPP_HTOD;
}
version (Dinrus)
{
    version = COMPILE;
    const HYDRATE = нет;
    const DEHYDRATE = нет;
}

version (COMPILE)
{
import cidrus;

import drc.backend.cdef;
import drc.backend.cc;
import drc.backend.cgcv;
import drc.backend.dlist;
import drc.backend.dt;
import drc.backend.dvec;
import drc.backend.el;
import drc.backend.глоб2;
import drc.backend.mem;
import drc.backend.oper;
import drc.backend.ty;
import drc.backend.тип;

version (SCPP_HTOD)
{
    import cpp;
    import dtoken;
    import scopeh;
    import msgs2;
    import parser;
    import precomp;

     проц baseclass_free(baseclass_t *b);
}


/*extern (C++):*/



alias  mem_malloc MEM_PH_MALLOC;
alias  mem_calloc MEM_PH_CALLOC;
alias  mem_free MEM_PH_FREE;
alias  mem_freefp MEM_PH_FREEFP;
alias  mem_strdup MEM_PH_STRDUP;
alias  mem_realloc MEM_PH_REALLOC;
alias  mem_malloc MEM_PARF_MALLOC;
alias  mem_calloc MEM_PARF_CALLOC;
alias  mem_realloc MEM_PARF_REALLOC;
alias  mem_free MEM_PARF_FREE;
alias  mem_strdup MEM_PARF_STRDUP;

version (SCPP_HTOD)
    const mBP = 0x20;
else
    import drc.backend.code_x86;

проц struct_free(struct_t *st) { }

func_t* func_calloc() { return cast(func_t *) calloc(1, func_t.sizeof); }
проц func_free(func_t* f) { free(f); }

/*********************************
 * Allocate/free symbol table.
 */

extern (C) Symbol **symtab_realloc(Symbol **tab, т_мера symmax)
{   Symbol **newtab;

    if (config.flags2 & (CFG2phgen | CFG2phuse | CFG2phauto | CFG2phautoy))
    {
        newtab = cast(Symbol **) MEM_PH_REALLOC(tab, symmax * (Symbol *).sizeof);
    }
    else
    {
        newtab = cast(Symbol **) realloc(tab, symmax * (Symbol *).sizeof);
        if (!newtab)
            err_nomem();
    }
    return newtab;
}

Symbol **symtab_malloc(т_мера symmax)
{   Symbol **newtab;

    if (config.flags2 & (CFG2phgen | CFG2phuse | CFG2phauto | CFG2phautoy))
    {
        newtab = cast(Symbol **) MEM_PH_MALLOC(symmax * (Symbol *).sizeof);
    }
    else
    {
        newtab = cast(Symbol **) malloc(symmax * (Symbol *).sizeof);
        if (!newtab)
            err_nomem();
    }
    return newtab;
}

Symbol **symtab_calloc(т_мера symmax)
{   Symbol **newtab;

    if (config.flags2 & (CFG2phgen | CFG2phuse | CFG2phauto | CFG2phautoy))
    {
        newtab = cast(Symbol **) MEM_PH_CALLOC(symmax * (Symbol *).sizeof);
    }
    else
    {
        newtab = cast(Symbol **) calloc(symmax, (Symbol *).sizeof);
        if (!newtab)
            err_nomem();
    }
    return newtab;
}

проц symtab_free(Symbol **tab)
{
    if (config.flags2 & (CFG2phgen | CFG2phuse | CFG2phauto | CFG2phautoy))
        MEM_PH_FREE(tab);
    else if (tab)
        free(tab);
}

/*******************************
 * Тип out symbol information.
 */

проц symbol_print( Symbol *s)
{
debug
{
version (COMPILE)
{
    if (!s) return;
    printf("symbol %p '%s'\n ",s,s.Sident.ptr);
    printf(" Sclass = "); WRclass(cast(SC) s.Sclass);
    printf(" Ssymnum = %d",s.Ssymnum);
    printf(" Sfl = "); WRFL(cast(FL) s.Sfl);
    printf(" Sseg = %d\n",s.Sseg);
//  printf(" Ssize   = x%02x\n",s.Ssize);
    printf(" Soffset = x%04llx",cast(бдол)s.Soffset);
    printf(" Sweight = %d",s.Sweight);
    printf(" Sflags = x%04x",cast(бцел)s.Sflags);
    printf(" Sxtrnnum = %d\n",s.Sxtrnnum);
    printf("  Stype   = %p",s.Stype);
version (SCPP_HTOD)
{
    printf(" Ssequence = %x", s.Ssequence);
    printf(" Scover  = %p", s.Scover);
}
    printf(" Sl      = %p",s.Sl);
    printf(" Sr      = %p\n",s.Sr);
    if (s.Sscope)
        printf(" Sscope = '%s'\n",s.Sscope.Sident.ptr);
    if (s.Stype)
        type_print(s.Stype);
    if (s.Sclass == SCmember || s.Sclass == SCfield)
    {
        printf("  Smemoff =%5lld", cast(long)s.Smemoff);
        printf("  Sbit    =%3d",s.Sbit);
        printf("  Swidth  =%3d\n",s.Swidth);
    }
version (SCPP_HTOD)
{
    if (s.Sclass == SCstruct)
    {
        printf("  Svbptr = %p, Svptr = %p\n",s.Sstruct.Svbptr,s.Sstruct.Svptr);
    }
}
}
}
}


/*********************************
 * Terminate use of symbol table.
 */

private  Symbol *keep;

проц symbol_term()
{
    symbol_free(keep);
}

/****************************************
 * Keep symbol around until symbol_term().
 */

static if (TERMCODE)
{

проц symbol_keep(Symbol *s)
{
    symbol_debug(s);
    s.Sr = keep;       // use Sr so symbol_free() doesn't nest
    keep = s;
}

}

/****************************************
 * Return alignment of symbol.
 */
цел Symbol_Salignsize(Symbol* s)
{
    if (s.Salignment > 0)
        return s.Salignment;
    цел alignsize = type_alignsize(s.Stype);

    /* Reduce alignment faults when SIMD vectors
     * are reinterpreted cast to other types with less alignment.
     */
    if (config.fpxmmregs && alignsize < 16 &&
        s.Sclass == SCauto &&
        type_size(s.Stype) == 16)
    {
        alignsize = 16;
    }

    return alignsize;
}

/****************************************
 * Aver if Symbol is not only merely dead, but really most sincerely dead.
 * Параметры:
 *      anyInlineAsm = да if there's any inline assembler code
 * Возвращает:
 *      да if symbol is dead.
 */

бул Symbol_Sisdead( Symbol* s, бул anyInlineAsm)
{
    version (Dinrus)
        const vol = нет;
    else
        const vol = да;
    return s.Sflags & SFLdead ||
           /* SFLdead means the optimizer found no references to it.
            * The rest deals with variables that the compiler never needed
            * to читай from memory because they were cached in registers,
            * and so no memory needs to be allocated for them.
            * Code that does пиши those variables to memory gets NOPed out
            * during address assignment.
            */
           (!anyInlineAsm && !(s.Sflags & SFLread) && s.Sflags & SFLunambig &&

            // mTYvolatile means this variable has been reference by a nested function
            (vol || !(s.Stype.Tty & mTYvolatile)) &&

            (config.flags4 & CFG4optimized || !config.fulltypes));
}

/****************************************
 * Determine if symbol needs a 'this' pointer.
 */

цел Symbol_needThis( Symbol* s)
{
    //printf("needThis() '%s'\n", Sident.ptr);

    debug assert(isclassmember(s));

    if (s.Sclass == SCmember || s.Sclass == SCfield)
        return 1;
    if (tyfunc(s.Stype.Tty) && !(s.Sfunc.Fflags & Fstatic))
        return 1;
    return 0;
}

/************************************
 * Determine if `s` may be affected if an assignment is done through
 * a pointer.
 * Параметры:
 *      s = symbol to check
 * Возвращает:
 *      да if it may be modified by assignment through a pointer
 */

бул Symbol_isAffected(ref Symbol s)
{
    //printf("s: %s %d\n", s.Sident.ptr, !(s.Sflags & SFLunambig) && !(s.ty() & (mTYconst | mTYimmutable)));
    //symbol_print(s);

    /* If nobody took its address and it's not statically allocated,
     * then it is not accessible via pointer and so is not affected.
     */
    if (s.Sflags & SFLunambig)
        return нет;

    /* If it's const, it can't be affected
     */
    if (s.ty() & (mTYconst | mTYimmutable))
    {
        return нет;
    }
    return да;
}


/***********************************
 * Get user имя of symbol.
 */

ткст0 symbol_ident( Symbol *s)
{
version (SCPP_HTOD)
{
     ткст0 noname = cast(сим*)"__unnamed".ptr;
    switch (s.Sclass)
    {   case SCstruct:
            if (s.Sstruct.Salias)
                return s.Sstruct.Salias.Sident.ptr;
            else if (s.Sstruct.Sflags & STRnotagname)
                return noname;
            break;
        case SCenum:
            if (CPP)
            {   if (s.Senum.SEalias)
                    return s.Senum.SEalias.Sident.ptr;
                else if (s.Senum.SEflags & SENnotagname)
                    return noname;
            }
            break;

        case SCnamespace:
            if (s.Sident[0] == '?' && s.Sident.ptr[1] == '%')
                return cast(сим*)"unique".ptr;        // an unnamed namespace
            break;

        default:
            break;
    }
}
    return s.Sident.ptr;
}

/****************************************
 * Create a new symbol.
 */

Symbol * symbol_calloc(ткст0 ид)
{
    return symbol_calloc(ид, cast(бцел)strlen(ид));
}

Symbol * symbol_calloc(ткст0 ид, бцел len)
{   Symbol *s;

    //printf("sizeof(symbol)=%d, sizeof(s.Sident)=%d, len=%d\n",sizeof(symbol),sizeof(s.Sident),(цел)len);
    s = cast(Symbol *) mem_fmalloc(Symbol.sizeof - s.Sident.length + len + 1 + 5);
    memset(s,0,Symbol.sizeof - s.Sident.length);
version (SCPP_HTOD)
{
    s.Ssequence = pstate.STsequence;
    pstate.STsequence += 1;
    //if (s.Ssequence == 0x21) *cast(сим*)0=0;
}
debug
{
    if (debugy)
        printf("symbol_calloc('%s') = %p\n",ид,s);
    s.ид = Symbol.IDsymbol;
}
    memcpy(s.Sident.ptr,ид,len + 1);
    s.Ssymnum = -1;
    return s;
}

/****************************************
 * Create a symbol, given a имя and тип.
 */

Symbol * symbol_name(ткст0 имя,цел sclass,тип *t)
{
    return symbol_name(имя, cast(бцел)strlen(имя), sclass, t);
}

Symbol * symbol_name(ткст0 имя, бцел len, цел sclass, тип *t)
{
    type_debug(t);
    Symbol *s = symbol_calloc(имя, len);
    s.Sclass = cast(сим) sclass;
    s.Stype = t;
    s.Stype.Tcount++;

    if (tyfunc(t.Tty))
        symbol_func(s);
    return s;
}

/****************************************
 * Create a symbol that is an alias to another function symbol.
 */

Funcsym *symbol_funcalias(Funcsym *sf)
{
    Funcsym *s;

    symbol_debug(sf);
    assert(tyfunc(sf.Stype.Tty));
    if (sf.Sclass == SCfuncalias)
        sf = sf.Sfunc.Falias;
    s = cast(Funcsym *)symbol_name(sf.Sident.ptr,SCfuncalias,sf.Stype);
    s.Sfunc.Falias = sf;

version (SCPP_HTOD)
    s.Scover = sf.Scover;

    return s;
}

/****************************************
 * Create a symbol, give it a имя, storage class and тип.
 */

Symbol * symbol_generate(цел sclass,тип *t)
{
     цел tmpnum;
    сим[4 + tmpnum.sizeof * 3 + 1] имя;

    //printf("symbol_generate(_TMP%d)\n", tmpnum);
    sprintf(имя.ptr,"_TMP%d",tmpnum++);
    Symbol *s = symbol_name(имя.ptr,sclass,t);
    //symbol_print(s);

version (Dinrus)
    s.Sflags |= SFLnodebug | SFLartifical;

    return s;
}

/****************************************
 * Generate an auto symbol, and add it to the symbol table.
 */

Symbol * symbol_genauto(тип *t)
{   Symbol *s;

    s = symbol_generate(SCauto,t);
version (SCPP_HTOD)
{
    //printf("symbol_genauto(t) '%s'\n", s.Sident.ptr);
    if (pstate.STdefertemps)
    {   symbol_keep(s);
        s.Ssymnum = -1;
    }
    else
    {   s.Sflags |= SFLfree;
        if (init_staticctor)
        {   // variable goes into _STI_xxxx
            s.Ssymnum = -1;            // deferred allocation
//printf("test2\n");
//if (s.Sident[4] == '2') *(сим*)0=0;
        }
        else
        {
            symbol_add(s);
        }
    }
}
else
{
    s.Sflags |= SFLfree;
    symbol_add(s);
}
    return s;
}

/******************************************
 * Generate symbol into which we can копируй the contents of Выражение e.
 */

Symbol *symbol_genauto(elem *e)
{
    return symbol_genauto(type_fake(e.Ety));
}

/******************************************
 * Generate symbol into which we can копируй the contents of Выражение e.
 */

Symbol *symbol_genauto(tym_t ty)
{
    return symbol_genauto(type_fake(ty));
}

/****************************************
 * Add in the variants for a function symbol.
 */

проц symbol_func(Symbol *s)
{
    //printf("symbol_func(%s, x%x)\n", s.Sident.ptr, fregsaved);
    symbol_debug(s);
    s.Sfl = FLfunc;
    // Interrupt functions modify all registers
    // BUG: do interrupt functions really save BP?
    // Note that fregsaved may not be set yet
    s.Sregsaved = (s.Stype && tybasic(s.Stype.Tty) == TYifunc) ? cast(regm_t) mBP : fregsaved;
    s.Sseg = UNKNOWN;          // don't know what segment it is in
    if (!s.Sfunc)
        s.Sfunc = func_calloc();
}

/***************************************
 * Add a field to a struct s.
 * Input:
 *      s       the struct symbol
 *      имя    field имя
 *      t       the тип of the field
 *      смещение  смещение of the field
 */

проц symbol_struct_addField(Symbol *s, ткст0 имя, тип *t, бцел смещение)
{
    Symbol *s2 = symbol_name(имя, SCmember, t);
    s2.Smemoff = смещение;
    list_append(&s.Sstruct.Sfldlst, s2);
}

/********************************
 * Define symbol in specified symbol table.
 * Возвращает:
 *      pointer to symbol
 */

version (SCPP_HTOD)
{
Symbol * defsy(ткст0 p,Symbol **родитель)
{
   Symbol *s = symbol_calloc(p);
   symbol_addtotree(родитель,s);
   return s;
}
}

/********************************
 * Check integrity of symbol данные structure.
 */

debug
{

проц symbol_check(Symbol *s)
{
    //printf("symbol_check('%s',%p)\n",s.Sident.ptr,s);
    symbol_debug(s);
    if (s.Stype) type_debug(s.Stype);
    assert(cast(бцел)s.Sclass < cast(бцел)SCMAX);
version (SCPP_HTOD)
{
    if (s.Sscope)
        symbol_check(s.Sscope);
    if (s.Scover)
        symbol_check(s.Scover);
}
}

проц symbol_tree_check(Symbol* s)
{
    while (s)
    {   symbol_check(s);
        symbol_tree_check(s.Sl);
        s = s.Sr;
    }
}

}

/********************************
 * Insert symbol in specified symbol table.
 */

version (SCPP_HTOD)
{

проц symbol_addtotree(Symbol **родитель,Symbol *s)
{  Symbol *rover;
   byte cmp;
   т_мера len;
   ткст0 p;
   сим c;

   //printf("symbol_addtotree('%s',%p)\n",s.Sident.ptr,*родитель);
debug
{
   symbol_tree_check(*родитель);
   assert(!s.Sl && !s.Sr);
}
   symbol_debug(s);
   p = s.Sident.ptr;
   c = *p;
   len = strlen(p);
   p++;
   rover = *родитель;
   while (rover != null)                // while we haven't run out of tree
   {    symbol_debug(rover);
        if ((cmp = cast(byte)(c - rover.Sident[0])) == 0)
        {   cmp = cast(byte)memcmp(p,rover.Sident.ptr + 1,len); // compare идентификатор strings
            if (cmp == 0)               // found it if strings match
            {
                if (CPP)
                {   Symbol *s2;

                    switch (rover.Sclass)
                    {   case SCstruct:
                            s2 = rover;
                            goto case_struct;

                        case_struct:
                            if (s2.Sstruct.Sctor &&
                                !(s2.Sstruct.Sctor.Sfunc.Fflags & Fgen))
                                cpperr(EM_ctor_disallowed,p);   // no ctor allowed for class rover
                            s2.Sstruct.Sflags |= STRnoctor;
                            goto case_cover;

                        case_cover:
                            // Replace rover with the new symbol s, and
                            // have s 'cover' the tag symbol s2.
                            // BUG: memory leak on rover if s2!=rover
                            assert(!s2.Scover);
                            s.Sl = rover.Sl;
                            s.Sr = rover.Sr;
                            s.Scover = s2;
                            *родитель = s;
                            rover.Sl = rover.Sr = null;
                            return;

                        case SCenum:
                            s2 = rover;
                            goto case_cover;

                        case SCtemplate:
                            s2 = rover;
                            s2.Stemplate.TMflags |= STRnoctor;
                            goto case_cover;

                        case SCalias:
                            s2 = rover.Smemalias;
                            if (s2.Sclass == SCstruct)
                                goto case_struct;
                            if (s2.Sclass == SCenum)
                                goto case_cover;
                            break;

                        default:
                            break;
                    }
                }
                synerr(EM_multiple_def,p - 1);  // symbol is already defined
                //symbol_undef(s);              // undefine the symbol
                return;
            }
        }
        родитель = (cmp < 0) ?            /* if we go down left side      */
            &(rover.Sl) :              /* then get left child          */
            &(rover.Sr);               /* else get right child         */
        rover = *родитель;                /* get child                    */
   }
   /* not in table, so вставь into table        */
   *родитель = s;                         /* link new symbol into tree    */
}
}

/*************************************
 * Search for symbol in multiple symbol tables,
 * starting with most recently nested one.
 * Input:
 *      p .    идентификатор ткст
 * Возвращает:
 *      pointer to symbol
 *      null if couldn't найди it
 */

static if (0)
{
Symbol * lookupsym(ткст0 p)
{
    return scope_search(p,SCTglobal | SCTlocal);
}
}

/*************************************
 * Search for symbol in symbol table.
 * Input:
 *      p .    идентификатор ткст
 *      rover . where to start looking
 * Возвращает:
 *      pointer to symbol (null if not found)
 */

version (SCPP_HTOD)
{

Symbol * findsy(ткст0 p,Symbol *rover)
{
/+
#if TX86 && __DMC__
    volatile цел len;
    __asm
    {
#if !_WIN32
        сунь    DS
        вынь     ES
#endif
        mov     EDI,p
        xor     AL,AL

        mov     BL,[EDI]
        mov     ECX,-1

        repne   scasb

        not     ECX
        mov     EDX,p

        dec     ECX
        inc     EDX

        mov     len,ECX
        mov     AL,BL

        mov     EBX,rover
        mov     ESI,EDX

        test    EBX,EBX
        je      L6

        cmp     AL,symbol.Sident[EBX]
        js      L2

        lea     EDI,symbol.Sident+1[EBX]
        je      L5

        mov     EBX,symbol.Sr[EBX]
        jmp     L3

L1:             mov     ECX,len
L2:             mov     EBX,symbol.Sl[EBX]

L3:             test    EBX,EBX
                je      L6

L4:             cmp     AL,symbol.Sident[EBX]
                js      L2

                lea     EDI,symbol.Sident+1[EBX]
                je      L5

                mov     EBX,symbol.Sr[EBX]
                jmp     L3

L5:             rep     cmpsb

                mov     ESI,EDX
                js      L1

                je      L6

                mov     EBX,symbol.Sr[EBX]
                mov     ECX,len

                test    EBX,EBX
                jne     L4

L6:     mov     EAX,EBX
    }
#else
+/
    т_мера len;
    byte cmp;                           /* set to значение of strcmp       */
    сим c = *p;

    len = strlen(p);
    p++;                                // will pick up 0 on memcmp
    while (rover != null)               // while we haven't run out of tree
    {   symbol_debug(rover);
        if ((cmp = cast(byte)(c - rover.Sident[0])) == 0)
        {   cmp = cast(byte)memcmp(p,rover.Sident.ptr + 1,len); /* compare идентификатор strings */
            if (cmp == 0)
                return rover;           /* found it if strings match    */
        }
        rover = (cmp < 0) ? rover.Sl : rover.Sr;
    }
    return rover;                       // failed to найди it
//#endif
}

}

/***********************************
 * Create a new symbol table.
 */

version (SCPP_HTOD)
{

проц createglobalsymtab()
{
    assert(!scope_end);
    if (CPP)
        scope_push(null,cast(scope_fp)&findsy, SCTcglobal);
    else
        scope_push(null,cast(scope_fp)&findsy, SCTglobaltag);
    scope_push(null,cast(scope_fp)&findsy, SCTglobal);
}


проц createlocalsymtab()
{
    assert(scope_end);
    if (!CPP)
        scope_push(null,cast(scope_fp)&findsy, SCTtag);
    scope_push(null,cast(scope_fp)&findsy, SCTlocal);
}


/***********************************
 * Delete current symbol table and back up one.
 */

проц deletesymtab()
{   Symbol *root;

    root = cast(Symbol *)scope_pop();
    if (root)
    {
        if (funcsym_p)
            list_prepend(&funcsym_p.Sfunc.Fsymtree,root);
        else
            symbol_free(root);  // free symbol table
    }

    if (!CPP)
    {
        root = cast(Symbol *)scope_pop();
        if (root)
        {
            if (funcsym_p)
                list_prepend(&funcsym_p.Sfunc.Fsymtree,root);
            else
                symbol_free(root);      // free symbol table
        }
    }
}

}

/*********************************
 * Delete symbol from symbol table, taking care to delete
 * all children of a symbol.
 * Make sure there are no more forward references (labels, tags).
 * Input:
 *      pointer to a symbol
 */

проц meminit_free(meminit_t *m)         /* helper for symbol_free()     */
{
    list_free(&m.MIelemlist,cast(list_free_fp)&el_free);
    MEM_PARF_FREE(m);
}

проц symbol_free(Symbol *s)
{
    while (s)                           /* if symbol exists             */
    {   Symbol *sr;

debug
{
        if (debugy)
            printf("symbol_free('%s',%p)\n",s.Sident.ptr,s);
        symbol_debug(s);
        assert(/*s.Sclass != SCunde &&*/ cast(цел) s.Sclass < cast(цел) SCMAX);
}
        {   тип *t = s.Stype;

            if (t)
                type_debug(t);
            if (t && tyfunc(t.Tty) && s.Sfunc)
            {
                func_t *f = s.Sfunc;

                debug assert(f);
                blocklist_free(&f.Fstartblock);
                freesymtab(f.Flocsym.tab,0,f.Flocsym.top);

                symtab_free(f.Flocsym.tab);
              if (CPP)
              {
                if (f.Fflags & Fnotparent)
                {   debug if (debugy) printf("not родитель, returning\n");
                    return;
                }

                /* We could be freeing the symbol before it's class is  */
                /* freed, so удали it from the class's field list      */
                if (f.Fclass)
                {   list_t tl;

                    symbol_debug(f.Fclass);
                    tl = list_inlist(f.Fclass.Sstruct.Sfldlst,s);
                    if (tl)
                        list_setsymbol(tl, null);
                }

                if (f.Foversym && f.Foversym.Sfunc)
                {   f.Foversym.Sfunc.Fflags &= ~Fnotparent;
                    f.Foversym.Sfunc.Fclass = null;
                    symbol_free(f.Foversym);
                }

                if (f.Fexplicitspec)
                    symbol_free(f.Fexplicitspec);

                /* If operator function, удали from list of such functions */
                if (f.Fflags & Foperator)
                {   assert(f.Foper && f.Foper < OPMAX);
                    //if (list_inlist(cpp_operfuncs[f.Foper],s))
                    //  list_subtract(&cpp_operfuncs[f.Foper],s);
                }

                list_free(&f.Fclassfriends,FPNULL);
                list_free(&f.Ffwdrefinstances,FPNULL);
                param_free(&f.Farglist);
                param_free(&f.Fptal);
                list_free(&f.Fexcspec,cast(list_free_fp)&type_free);

version (SCPP_HTOD)
                token_free(f.Fbody);

                el_free(f.Fbaseinit);
                if (f.Fthunk && !(f.Fflags & Finstance))
                    MEM_PH_FREE(f.Fthunk);
                list_free(&f.Fthunks,cast(list_free_fp)&symbol_free);
              }
                list_free(&f.Fsymtree,cast(list_free_fp)&symbol_free);
                f.typesTable.__dtor();
                func_free(f);
            }
            switch (s.Sclass)
            {
version (SCPP_HTOD)
{
                case SClabel:
                    if (!s.Slabel)
                        synerr(EM_unknown_label,s.Sident.ptr);
                    break;
}
                case SCstruct:
version (SCPP_HTOD)
{
                  if (CPP)
                  {
                    struct_t *st = s.Sstruct;
                    assert(st);
                    list_free(&st.Sclassfriends,FPNULL);
                    list_free(&st.Sfriendclass,FPNULL);
                    list_free(&st.Sfriendfuncs,FPNULL);
                    list_free(&st.Scastoverload,FPNULL);
                    list_free(&st.Sopoverload,FPNULL);
                    list_free(&st.Svirtual,&MEM_PH_FREEFP);
                    list_free(&st.Sfldlst,FPNULL);
                    symbol_free(st.Sroot);
                    baseclass_t* b,bn;

                    for (b = st.Sbase; b; b = bn)
                    {   bn = b.BCnext;
                        list_free(&b.BCpublics,FPNULL);
                        baseclass_free(b);
                    }
                    for (b = st.Svirtbase; b; b = bn)
                    {   bn = b.BCnext;
                        baseclass_free(b);
                    }
                    for (b = st.Smptrbase; b; b = bn)
                    {   bn = b.BCnext;
                        list_free(&b.BCmptrlist,&MEM_PH_FREEFP);
                        baseclass_free(b);
                    }
                    for (b = st.Svbptrbase; b; b = bn)
                    {   bn = b.BCnext;
                        baseclass_free(b);
                    }
                    param_free(&st.Sarglist);
                    param_free(&st.Spr_arglist);
                    struct_free(st);
                  }
}
                  if (!CPP)
                  {
                    debug if (debugy)
                        printf("freeing члены %p\n",s.Sstruct.Sfldlst);

                    list_free(&s.Sstruct.Sfldlst,FPNULL);
                    symbol_free(s.Sstruct.Sroot);
                    struct_free(s.Sstruct);
                  }
static if (0)       /* Don't complain anymore about these, ANSI C says  */
{
                    /* it's ok                                          */
                    if (t && t.Tflags & TFsizeunknown)
                        synerr(EM_unknown_tag,s.Sident.ptr);
}
                    break;
                case SCenum:
                    /* The actual member symbols are either in a local  */
                    /* table or on the member list of a class, so we    */
                    /* don't free them here.                            */
                    assert(s.Senum);
                    list_free(&s.Senum.SEenumlist,FPNULL);
                    MEM_PH_FREE(s.Senum);
                    s.Senum = null;
                    break;

version (SCPP_HTOD)
{
                case SCtemplate:
                {   template_t *tm = s.Stemplate;

                    list_free(&tm.TMinstances,FPNULL);
                    list_free(&tm.TMmemberfuncs,cast(list_free_fp)&tmf_free);
                    list_free(&tm.TMexplicit,cast(list_free_fp)&tme_free);
                    list_free(&tm.TMnestedexplicit,cast(list_free_fp)&tmne_free);
                    list_free(&tm.TMnestedfriends,cast(list_free_fp)&tmnf_free);
                    param_free(&tm.TMptpl);
                    param_free(&tm.TMptal);
                    token_free(tm.TMbody);
                    symbol_free(tm.TMpartial);
                    list_free(&tm.TMfriends,FPNULL);
                    MEM_PH_FREE(tm);
                    break;
                }
                case SCnamespace:
                    symbol_free(s.Snameroot);
                    list_free(&s.Susing,FPNULL);
                    break;

                case SCmemalias:
                case SCfuncalias:
                case SCadl:
                    list_free(&s.Spath,FPNULL);
                    break;
}
                case SCparameter:
                case SCregpar:
                case SCfastpar:
                case SCshadowreg:
                case SCregister:
                case SCauto:
                    vec_free(s.Srange);
static if (0)
{
                    goto case SCconst;
                case SCconst:
                    if (s.Sflags & (SFLvalue | SFLdtorexp))
                        el_free(s.Svalue);
}
                    break;
                default:
                    break;
            }
            if (s.Sflags & (SFLvalue | SFLdtorexp))
                el_free(s.Svalue);
            if (s.Sdt)
                dt_free(s.Sdt);
            type_free(t);
            symbol_free(s.Sl);
version (SCPP_HTOD)
{
            if (s.Scover)
                symbol_free(s.Scover);
}
            sr = s.Sr;
debug
{
            s.ид = 0;
}
            mem_ffree(s);
        }
        s = sr;
    }
}

/********************************
 * Undefine a symbol.
 * Assume error msg was already printed.
 */

static if (0)
{
private проц symbol_undef(Symbol *s)
{
  s.Sclass = SCunde;
  s.Ssymnum = -1;
  type_free(s.Stype);                  /* free тип данные               */
  s.Stype = null;
}
}

/*****************************
 * Add symbol to current symbol массив.
 */

SYMIDX symbol_add(Symbol *s)
{
    return symbol_add(cstate.CSpsymtab, s);
}

SYMIDX symbol_add(symtab_t* symtab, Symbol* s)
{   SYMIDX sitop;

    //printf("symbol_add('%s')\n", s.Sident.ptr);
debug
{
    if (!s || !s.Sident[0])
    {   printf("bad symbol\n");
        assert(0);
    }
}
    symbol_debug(s);
    if (pstate.STinsizeof)
    {   symbol_keep(s);
        return -1;
    }
    debug assert(symtab);
    sitop = symtab.top;
    assert(sitop <= symtab.symmax);
    if (sitop == symtab.symmax)
    {
debug
    const SYMINC = 1;                       /* flush out reallocation bugs  */
else
    const SYMINC = 99;

        symtab.symmax += (symtab == &globsym) ? SYMINC : 1;
        //assert(symtab.symmax * (Symbol *).sizeof < 4096 * 4);
        symtab.tab = symtab_realloc(symtab.tab, symtab.symmax);
    }
    symtab.tab[sitop] = s;

    debug if (debugy)
        printf("symbol_add(%p '%s') = %d\n",s,s.Sident.ptr,symtab.top);

    assert(s.Ssymnum == -1);
    return s.Ssymnum = symtab.top++;
}

/********************************************
 * Insert s into symtab at position n.
 * Возвращает:
 *      position in table
 */
SYMIDX symbol_insert(symtab_t* symtab, Symbol* s, SYMIDX n)
{
    const sinew = symbol_add(s);        // added at end, have to move it
    for (SYMIDX i = sinew; i > n; --i)
    {
        symtab.tab[i] = symtab.tab[i - 1];
        symtab.tab[i].Ssymnum += 1;
    }
    globsym.tab[n] = s;
    s.Ssymnum = n;
    return n;
}

/****************************
 * Free up the symbol table, from symbols n1 through n2, not
 * including n2.
 */

проц freesymtab(Symbol **stab,SYMIDX n1,SYMIDX n2)
{   SYMIDX si;

    if (!stab)
        return;

    debug if (debugy)
        printf("freesymtab(from %d to %d)\n",n1,n2);

    assert(stab != globsym.tab || (n1 <= n2 && n2 <= globsym.top));
    for (si = n1; si < n2; si++)
    {   Symbol *s;

        s = stab[si];
        if (s && s.Sflags & SFLfree)
        {   stab[si] = null;

debug
{
            if (debugy)
                printf("Freeing %p '%s' (%d)\n",s,s.Sident.ptr,si);
            symbol_debug(s);
}
            s.Sl = s.Sr = null;
            s.Ssymnum = -1;
            symbol_free(s);
        }
    }
}

/****************************
 * Create a копируй of a symbol.
 */

Symbol * symbol_copy(Symbol *s)
{   Symbol *scopy;
    тип *t;

    symbol_debug(s);
    /*printf("symbol_copy(%s)\n",s.Sident.ptr);*/
    scopy = symbol_calloc(s.Sident.ptr);
    memcpy(scopy,s,Symbol.sizeof - s.Sident.sizeof);
    scopy.Sl = scopy.Sr = scopy.Snext = null;
    scopy.Ssymnum = -1;
    if (scopy.Sdt)
    {
        auto dtb = DtBuilder(0);
        dtb.nzeros(cast(бцел)type_size(scopy.Stype));
        scopy.Sdt = dtb.finish();
    }
    if (scopy.Sflags & (SFLvalue | SFLdtorexp))
        scopy.Svalue = el_copytree(s.Svalue);
    t = scopy.Stype;
    if (t)
    {   t.Tcount++;            /* one more родитель of the тип  */
        type_debug(t);
    }
    return scopy;
}

/*******************************
 * Search list for a symbol with an идентификатор that matches.
 * Возвращает:
 *      pointer to matching symbol
 *      null if not found
 */

version (SCPP_HTOD)
{

Symbol * symbol_searchlist(symlist_t sl,ткст0 vident)
{
    debug
    цел count = 0;

    //printf("searchlist(%s)\n",vident);
    foreach (sln; ListRange(sl))
    {
        Symbol* s = list_symbol(sln);
        symbol_debug(s);
        /*printf("\tcomparing with %s\n",s.Sident.ptr);*/
        if (strcmp(vident,s.Sident.ptr) == 0)
            return s;

        debug assert(++count < 300);          /* prevent infinite loops       */
    }
    return null;
}

/***************************************
 * Search for symbol in sequence of symbol tables.
 * Input:
 *      glbl    !=0 if глоб2 symbol table only
 */

Symbol *symbol_search(ткст0 ид)
{
    Scope *sc;
    if (CPP)
    {   бцел sct;

        sct = pstate.STclasssym ? SCTclass : 0;
        sct |= SCTmfunc | SCTlocal | SCTwith | SCTglobal | SCTnspace | SCTtemparg | SCTtempsym;
        return scope_searchx(ид,sct,&sc);
    }
    else
        return scope_searchx(ид,SCTglobal | SCTlocal,&sc);
}

}


/*******************************************
 * Hydrate a symbol tree.
 */

static if (HYDRATE)
{
проц symbol_tree_hydrate(Symbol **ps)
{   Symbol *s;

    while (isdehydrated(*ps))           /* if symbol is dehydrated      */
    {
        s = symbol_hydrate(ps);
        symbol_debug(s);
        if (s.Scover)
            symbol_hydrate(&s.Scover);
        symbol_tree_hydrate(&s.Sl);
        ps = &s.Sr;
    }

}
}

/*******************************************
 * Dehydrate a symbol tree.
 */

static if (DEHYDRATE)
{
проц symbol_tree_dehydrate(Symbol **ps)
{   Symbol *s;

    while ((s = *ps) != null && !isdehydrated(s)) /* if symbol exists   */
    {
        symbol_debug(s);
        symbol_dehydrate(ps);
version (DEBUG_XSYMGEN)
{
        if (xsym_gen && ph_in_head(s))
            return;
}
        symbol_dehydrate(&s.Scover);
        symbol_tree_dehydrate(&s.Sl);
        ps = &s.Sr;
    }
}
}

/*******************************************
 * Hydrate a symbol.
 */

static if (HYDRATE)
{
Symbol *symbol_hydrate(Symbol **ps)
{   Symbol *s;

    s = *ps;
    if (isdehydrated(s))                /* if symbol is dehydrated      */
    {   тип *t;
        struct_t *st;

        s = cast(Symbol *) ph_hydrate(cast(ук*)ps);

        debug debugy && printf("symbol_hydrate('%s')\n",s.Sident.ptr);

        symbol_debug(s);
        if (!isdehydrated(s.Stype))    // if this symbol is already dehydrated
            return s;                   // no need to do it again
        if (pstate.SThflag != FLAG_INPLACE && s.Sfl != FLreg)
            s.Sxtrnnum = 0;            // not written to .OBJ файл yet
        type_hydrate(&s.Stype);
        //printf("symbol_hydrate(%p, '%s', t = %p)\n",s,s.Sident.ptr,s.Stype);
        t = s.Stype;
        if (t)
            type_debug(t);

        if (t && tyfunc(t.Tty) && ph_hydrate(cast(ук*)&s.Sfunc))
        {
            func_t *f = s.Sfunc;
            SYMIDX si;

            debug assert(f);

            list_hydrate(&f.Fsymtree,cast(list_free_fp)&symbol_tree_hydrate);
            blocklist_hydrate(&f.Fstartblock);

            ph_hydrate(cast(ук*)&f.Flocsym.tab);
            for (si = 0; si < f.Flocsym.top; si++)
                symbol_hydrate(&f.Flocsym.tab[si]);

            srcpos_hydrate(&f.Fstartline);
            srcpos_hydrate(&f.Fendline);

            symbol_hydrate(&f.F__func__);

            if (CPP)
            {
                symbol_hydrate(&f.Fparsescope);
                Classsym_hydrate(&f.Fclass);
                symbol_hydrate(&f.Foversym);
                symbol_hydrate(&f.Fexplicitspec);
                symbol_hydrate(&f.Fsurrogatesym);

                list_hydrate(&f.Fclassfriends,cast(list_free_fp)&symbol_hydrate);
                el_hydrate(&f.Fbaseinit);
                token_hydrate(&f.Fbody);
                symbol_hydrate(&f.Falias);
                list_hydrate(&f.Fthunks,cast(list_free_fp)&symbol_hydrate);
                if (f.Fflags & Finstance)
                    symbol_hydrate(&f.Ftempl);
                else
                    thunk_hydrate(&f.Fthunk);
                param_hydrate(&f.Farglist);
                param_hydrate(&f.Fptal);
                list_hydrate(&f.Ffwdrefinstances,cast(list_free_fp)&symbol_hydrate);
                list_hydrate(&f.Fexcspec,cast(list_free_fp)&type_hydrate);
            }
        }
        if (CPP)
            symbol_hydrate(&s.Sscope);
        switch (s.Sclass)
        {
            case SCstruct:
              if (CPP)
              {
                st = cast(struct_t *) ph_hydrate(cast(ук*)&s.Sstruct);
                assert(st);
                symbol_tree_hydrate(&st.Sroot);
                ph_hydrate(cast(ук*)&st.Spvirtder);
                list_hydrate(&st.Sfldlst,cast(list_free_fp)&symbol_hydrate);
                list_hydrate(&st.Svirtual,cast(list_free_fp)&mptr_hydrate);
                list_hydrate(&st.Sopoverload,cast(list_free_fp)&symbol_hydrate);
                list_hydrate(&st.Scastoverload,cast(list_free_fp)&symbol_hydrate);
                list_hydrate(&st.Sclassfriends,cast(list_free_fp)&symbol_hydrate);
                list_hydrate(&st.Sfriendclass,cast(list_free_fp)&symbol_hydrate);
                list_hydrate(&st.Sfriendfuncs,cast(list_free_fp)&symbol_hydrate);
                assert(!st.Sinlinefuncs);

                baseclass_hydrate(&st.Sbase);
                baseclass_hydrate(&st.Svirtbase);
                baseclass_hydrate(&st.Smptrbase);
                baseclass_hydrate(&st.Sprimary);
                baseclass_hydrate(&st.Svbptrbase);

                ph_hydrate(cast(ук*)&st.Svecctor);
                ph_hydrate(cast(ук*)&st.Sctor);
                ph_hydrate(cast(ук*)&st.Sdtor);
                ph_hydrate(cast(ук*)&st.Sprimdtor);
                ph_hydrate(cast(ук*)&st.Spriminv);
                ph_hydrate(cast(ук*)&st.Sscaldeldtor);
                ph_hydrate(cast(ук*)&st.Sinvariant);
                ph_hydrate(cast(ук*)&st.Svptr);
                ph_hydrate(cast(ук*)&st.Svtbl);
                ph_hydrate(cast(ук*)&st.Sopeq);
                ph_hydrate(cast(ук*)&st.Sopeq2);
                ph_hydrate(cast(ук*)&st.Scpct);
                ph_hydrate(cast(ук*)&st.Sveccpct);
                ph_hydrate(cast(ук*)&st.Salias);
                ph_hydrate(cast(ук*)&st.Stempsym);
                param_hydrate(&st.Sarglist);
                param_hydrate(&st.Spr_arglist);
                ph_hydrate(cast(ук*)&st.Svbptr);
                ph_hydrate(cast(ук*)&st.Svbptr_parent);
                ph_hydrate(cast(ук*)&st.Svbtbl);
              }
              else
              {
                ph_hydrate(cast(ук*)&s.Sstruct);
                symbol_tree_hydrate(&s.Sstruct.Sroot);
                list_hydrate(&s.Sstruct.Sfldlst,cast(list_free_fp)&symbol_hydrate);
              }
                break;

            case SCenum:
                assert(s.Senum);
                ph_hydrate(cast(ук*)&s.Senum);
                if (CPP)
                {   ph_hydrate(cast(ук*)&s.Senum.SEalias);
                    list_hydrate(&s.Senum.SEenumlist,cast(list_free_fp)&symbol_hydrate);
                }
                break;

            case SCtemplate:
            {   template_t *tm;

                tm = cast(template_t *) ph_hydrate(cast(ук*)&s.Stemplate);
                list_hydrate(&tm.TMinstances,cast(list_free_fp)&symbol_hydrate);
                list_hydrate(&tm.TMfriends,cast(list_free_fp)&symbol_hydrate);
                param_hydrate(&tm.TMptpl);
                param_hydrate(&tm.TMptal);
                token_hydrate(&tm.TMbody);
                list_hydrate(&tm.TMmemberfuncs,cast(list_free_fp)&tmf_hydrate);
                list_hydrate(&tm.TMexplicit,cast(list_free_fp)&tme_hydrate);
                list_hydrate(&tm.TMnestedexplicit,cast(list_free_fp)&tmne_hydrate);
                list_hydrate(&tm.TMnestedfriends,cast(list_free_fp)&tmnf_hydrate);
                ph_hydrate(cast(ук*)&tm.TMnext);
                symbol_hydrate(&tm.TMpartial);
                symbol_hydrate(&tm.TMprimary);
                break;
            }

            case SCnamespace:
                symbol_tree_hydrate(&s.Snameroot);
                list_hydrate(&s.Susing,cast(list_free_fp)&symbol_hydrate);
                break;

            case SCmemalias:
            case SCfuncalias:
            case SCadl:
                list_hydrate(&s.Spath,cast(list_free_fp)&symbol_hydrate);
                goto case SCalias;

            case SCalias:
                ph_hydrate(cast(ук*)&s.Smemalias);
                break;

            default:
                if (s.Sflags & (SFLvalue | SFLdtorexp))
                    el_hydrate(&s.Svalue);
                break;
        }
        {   dt_t **pdt;
            dt_t *dt;

            for (pdt = &s.Sdt; isdehydrated(*pdt); pdt = &dt.DTnext)
            {
                dt = cast(dt_t *) ph_hydrate(cast(ук*)pdt);
                switch (dt.dt)
                {   case DT_abytes:
                    case DT_nbytes:
                        ph_hydrate(cast(ук*)&dt.DTpbytes);
                        break;
                    case DT_xoff:
                        symbol_hydrate(&dt.DTsym);
                        break;

                    default:
                        break;
                }
            }
        }
        if (s.Scover)
            symbol_hydrate(&s.Scover);
    }
    return s;
}
}

/*******************************************
 * Dehydrate a symbol.
 */

static if (DEHYDRATE)
{
проц symbol_dehydrate(Symbol **ps)
{
    Symbol *s;

    if ((s = *ps) != null && !isdehydrated(s)) /* if symbol exists      */
    {   тип *t;
        struct_t *st;

        debug
        if (debugy)
            printf("symbol_dehydrate('%s')\n",s.Sident.ptr);

        ph_dehydrate(ps);
version (DEBUG_XSYMGEN)
{
        if (xsym_gen && ph_in_head(s))
            return;
}
        symbol_debug(s);
        t = s.Stype;
        if (isdehydrated(t))
            return;
        type_dehydrate(&s.Stype);

        if (tyfunc(t.Tty) && !isdehydrated(s.Sfunc))
        {
            func_t *f = s.Sfunc;
            SYMIDX si;

            debug assert(f);
            ph_dehydrate(&s.Sfunc);

            list_dehydrate(&f.Fsymtree,cast(list_free_fp)&symbol_tree_dehydrate);
            blocklist_dehydrate(&f.Fstartblock);
            assert(!isdehydrated(&f.Flocsym.tab));

version (DEBUG_XSYMGEN)
{
            if (!xsym_gen || !ph_in_head(f.Flocsym.tab))
                for (si = 0; si < f.Flocsym.top; si++)
                    symbol_dehydrate(&f.Flocsym.tab[si]);
}
else
{
            for (si = 0; si < f.Flocsym.top; si++)
                symbol_dehydrate(&f.Flocsym.tab[si]);
}
            ph_dehydrate(&f.Flocsym.tab);

            srcpos_dehydrate(&f.Fstartline);
            srcpos_dehydrate(&f.Fendline);
            symbol_dehydrate(&f.F__func__);
            if (CPP)
            {
            symbol_dehydrate(&f.Fparsescope);
            ph_dehydrate(&f.Fclass);
            symbol_dehydrate(&f.Foversym);
            symbol_dehydrate(&f.Fexplicitspec);
            symbol_dehydrate(&f.Fsurrogatesym);

            list_dehydrate(&f.Fclassfriends,FPNULL);
            el_dehydrate(&f.Fbaseinit);
version (DEBUG_XSYMGEN)
{
            if (xsym_gen && s.Sclass == SCfunctempl)
                ph_dehydrate(&f.Fbody);
            else
                token_dehydrate(&f.Fbody);
}
else
            token_dehydrate(&f.Fbody);

            symbol_dehydrate(&f.Falias);
            list_dehydrate(&f.Fthunks,cast(list_free_fp)&symbol_dehydrate);
            if (f.Fflags & Finstance)
                symbol_dehydrate(&f.Ftempl);
            else
                thunk_dehydrate(&f.Fthunk);
//#if !TX86 && DEBUG_XSYMGEN
//            if (xsym_gen && s.Sclass == SCfunctempl)
//                ph_dehydrate(&f.Farglist);
//            else
//#endif
            param_dehydrate(&f.Farglist);
            param_dehydrate(&f.Fptal);
            list_dehydrate(&f.Ffwdrefinstances,cast(list_free_fp)&symbol_dehydrate);
            list_dehydrate(&f.Fexcspec,cast(list_free_fp)&type_dehydrate);
            }
        }
        if (CPP)
            ph_dehydrate(&s.Sscope);
        switch (s.Sclass)
        {
            case SCstruct:
              if (CPP)
              {
                st = s.Sstruct;
                if (isdehydrated(st))
                    break;
                ph_dehydrate(&s.Sstruct);
                assert(st);
                symbol_tree_dehydrate(&st.Sroot);
                ph_dehydrate(&st.Spvirtder);
                list_dehydrate(&st.Sfldlst,cast(list_free_fp)&symbol_dehydrate);
                list_dehydrate(&st.Svirtual,cast(list_free_fp)&mptr_dehydrate);
                list_dehydrate(&st.Sopoverload,cast(list_free_fp)&symbol_dehydrate);
                list_dehydrate(&st.Scastoverload,cast(list_free_fp)&symbol_dehydrate);
                list_dehydrate(&st.Sclassfriends,cast(list_free_fp)&symbol_dehydrate);
                list_dehydrate(&st.Sfriendclass,cast(list_free_fp)&ph_dehydrate);
                list_dehydrate(&st.Sfriendfuncs,cast(list_free_fp)&ph_dehydrate);
                assert(!st.Sinlinefuncs);

                baseclass_dehydrate(&st.Sbase);
                baseclass_dehydrate(&st.Svirtbase);
                baseclass_dehydrate(&st.Smptrbase);
                baseclass_dehydrate(&st.Sprimary);
                baseclass_dehydrate(&st.Svbptrbase);

                ph_dehydrate(&st.Svecctor);
                ph_dehydrate(&st.Sctor);
                ph_dehydrate(&st.Sdtor);
                ph_dehydrate(&st.Sprimdtor);
                ph_dehydrate(&st.Spriminv);
                ph_dehydrate(&st.Sscaldeldtor);
                ph_dehydrate(&st.Sinvariant);
                ph_dehydrate(&st.Svptr);
                ph_dehydrate(&st.Svtbl);
                ph_dehydrate(&st.Sopeq);
                ph_dehydrate(&st.Sopeq2);
                ph_dehydrate(&st.Scpct);
                ph_dehydrate(&st.Sveccpct);
                ph_dehydrate(&st.Salias);
                ph_dehydrate(&st.Stempsym);
                param_dehydrate(&st.Sarglist);
                param_dehydrate(&st.Spr_arglist);
                ph_dehydrate(&st.Svbptr);
                ph_dehydrate(&st.Svbptr_parent);
                ph_dehydrate(&st.Svbtbl);
              }
              else
              {
                symbol_tree_dehydrate(&s.Sstruct.Sroot);
                list_dehydrate(&s.Sstruct.Sfldlst,cast(list_free_fp)&symbol_dehydrate);
                ph_dehydrate(&s.Sstruct);
              }
                break;

            case SCenum:
                assert(s.Senum);
                if (!isdehydrated(s.Senum))
                {
                    if (CPP)
                    {   ph_dehydrate(&s.Senum.SEalias);
                        list_dehydrate(&s.Senumlist,cast(list_free_fp)&ph_dehydrate);
                    }
                    ph_dehydrate(&s.Senum);
                }
                break;

            case SCtemplate:
            {   template_t *tm;

                tm = s.Stemplate;
                if (!isdehydrated(tm))
                {
                    ph_dehydrate(&s.Stemplate);
                    list_dehydrate(&tm.TMinstances,cast(list_free_fp)&symbol_dehydrate);
                    list_dehydrate(&tm.TMfriends,cast(list_free_fp)&symbol_dehydrate);
                    list_dehydrate(&tm.TMnestedfriends,cast(list_free_fp)&tmnf_dehydrate);
                    param_dehydrate(&tm.TMptpl);
                    param_dehydrate(&tm.TMptal);
                    token_dehydrate(&tm.TMbody);
                    list_dehydrate(&tm.TMmemberfuncs,cast(list_free_fp)&tmf_dehydrate);
                    list_dehydrate(&tm.TMexplicit,cast(list_free_fp)&tme_dehydrate);
                    list_dehydrate(&tm.TMnestedexplicit,cast(list_free_fp)&tmne_dehydrate);
                    ph_dehydrate(&tm.TMnext);
                    symbol_dehydrate(&tm.TMpartial);
                    symbol_dehydrate(&tm.TMprimary);
                }
                break;
            }

            case SCnamespace:
                symbol_tree_dehydrate(&s.Snameroot);
                list_dehydrate(&s.Susing,cast(list_free_fp)&symbol_dehydrate);
                break;

            case SCmemalias:
            case SCfuncalias:
            case SCadl:
                list_dehydrate(&s.Spath,cast(list_free_fp)&symbol_dehydrate);
            case SCalias:
                ph_dehydrate(&s.Smemalias);
                break;

            default:
                if (s.Sflags & (SFLvalue | SFLdtorexp))
                    el_dehydrate(&s.Svalue);
                break;
        }
        {   dt_t **pdt;
            dt_t *dt;

            for (pdt = &s.Sdt;
                 (dt = *pdt) != null && !isdehydrated(dt);
                 pdt = &dt.DTnext)
            {
                ph_dehydrate(pdt);
                switch (dt.dt)
                {   case DT_abytes:
                    case DT_nbytes:
                        ph_dehydrate(&dt.DTpbytes);
                        break;
                    case DT_xoff:
                        symbol_dehydrate(&dt.DTsym);
                        break;
                }
            }
        }
        if (s.Scover)
            symbol_dehydrate(&s.Scover);
    }
}
}

/***************************
 * Dehydrate threaded list of symbols.
 */

static if (DEHYDRATE)
{
проц symbol_symdefs_dehydrate(Symbol **ps)
{
    Symbol *s;

    for (; *ps; ps = &s.Snext)
    {
        s = *ps;
        symbol_debug(s);
        //printf("symbol_symdefs_dehydrate(%p, '%s')\n",s,s.Sident.ptr);
        symbol_dehydrate(ps);
    }
}
}


/***************************
 * Hydrate threaded list of symbols.
 * Input:
 *      *psx    start of threaded list
 *      *родитель root of symbol table to add symbol into
 *      флаг    !=0 means add onto existing stuff
 *              0 means hydrate in place
 */

version (SCPP_HTOD)
{

проц symbol_symdefs_hydrate(Symbol **psx,Symbol **родитель,цел флаг)
{   Symbol *s;

    //printf("symbol_symdefs_hydrate(флаг = %d)\n",флаг);
debug
{
    цел count = 0;

    if (флаг) symbol_tree_check(*родитель);
}
    for (; *psx; psx = &s.Snext)
    {
        //printf("%p ",*psx);
debug
        count++;

        s = dohydrate ? symbol_hydrate(psx) : *psx;

        //if (s.Sclass == SCstruct)
        //printf("symbol_symdefs_hydrate(%p, '%s')\n",s,s.Sident.ptr);
        symbol_debug(s);
static if (0)
{
        if (tyfunc(s.Stype.Tty))
        {   Outbuffer буф;
            сим *p1;

            p1 = param_tostring(&буф,s.Stype);
            printf("'%s%s'\n",cpp_prettyident(s),p1);
        }
}
        type_debug(s.Stype);
        if (флаг)
        {   сим *p;
            Symbol **ps;
            Symbol *rover;
            сим c;
            т_мера len;

            p = s.Sident.ptr;
            c = *p;

            // Put symbol s into symbol table

static if (MMFIO)
{
            if (s.Sl || s.Sr)         // avoid writing to page if possible
                s.Sl = s.Sr = null;
}
else
                s.Sl = s.Sr = null;

            len = strlen(p);
            p++;
            ps = родитель;
            while ((rover = *ps) != null)
            {   byte cmp;

                if ((cmp = cast(byte)(c - rover.Sident[0])) == 0)
                {   cmp = cast(byte)memcmp(p,rover.Sident.ptr + 1,len); // compare идентификатор strings
                    if (cmp == 0)
                    {
                        if (CPP && tyfunc(s.Stype.Tty) && tyfunc(rover.Stype.Tty))
                        {   Symbol **psym;
                            Symbol *sn;
                            Symbol *so;

                            so = s;
                            do
                            {
                                // Tack onto end of overloaded function list
                                for (psym = &rover; *psym; psym = &(*psym).Sfunc.Foversym)
                                {   if (cpp_funccmp(so, *psym))
                                    {   //printf("function '%s' already in list\n",so.Sident.ptr);
                                        goto L2;
                                    }
                                }
                                //printf("appending '%s' to rover\n",so.Sident.ptr);
                                *psym = so;
                            L2:
                                sn = so.Sfunc.Foversym;
                                so.Sfunc.Foversym = null;
                                so = sn;
                            } while (so);
                            //printf("overloading...\n");
                        }
                        else if (s.Sclass == SCstruct)
                        {
                            if (CPP && rover.Scover)
                            {   ps = &rover.Scover;
                                rover = *ps;
                            }
                            else
                            if (rover.Sclass == SCstruct)
                            {
                                if (!(s.Stype.Tflags & TFforward))
                                {   // Replace rover with s in symbol table
                                    //printf("Replacing '%s'\n",s.Sident.ptr);
                                    *ps = s;
                                    s.Sl = rover.Sl;
                                    s.Sr = rover.Sr;
                                    rover.Sl = rover.Sr = null;
                                    rover.Stype.Ttag = cast(Classsym *)s;
                                    symbol_keep(rover);
                                }
                                else
                                    s.Stype.Ttag = cast(Classsym *)rover;
                            }
                        }
                        break;//goto L1;
                    }
                }
                ps = (cmp < 0) ?        /* if we go down left side      */
                    &rover.Sl :
                    &rover.Sr;
            }
            *ps = s;
            if (s.Sclass == SCcomdef)
            {   s.Sclass = SCglobal;
                outcommon(s,type_size(s.Stype));
            }
        }
 // L1:
    } // for
debug
{
    if (флаг) symbol_tree_check(*родитель);
    printf("%d symbols hydrated\n",count);
}
}

}

static if (0)
{

/*************************************
 * Put symbol table s into родитель symbol table.
 */

проц symboltable_hydrate(Symbol *s,Symbol **родитель)
{
    while (s)
    {   Symbol* sl,sr;
        сим *p;

        symbol_debug(s);

        sl = s.Sl;
        sr = s.Sr;
        p = s.Sident.ptr;

        //printf("symboltable_hydrate('%s')\n",p);

        /* Put symbol s into symbol table       */
        {   Symbol **ps;
            Symbol *rover;
            цел c = *p;

            ps = родитель;
            while ((rover = *ps) != null)
            {   цел cmp;

                if ((cmp = c - rover.Sident[0]) == 0)
                {   cmp = strcmp(p,rover.Sident.ptr); /* compare идентификатор strings */
                    if (cmp == 0)
                    {
                        if (CPP && tyfunc(s.Stype.Tty) && tyfunc(rover.Stype.Tty))
                        {   Symbol **ps;
                            Symbol *sn;

                            do
                            {
                                // Tack onto end of overloaded function list
                                for (ps = &rover; *ps; ps = &(*ps).Sfunc.Foversym)
                                {   if (cpp_funccmp(s, *ps))
                                        goto L2;
                                }
                                s.Sl = s.Sr = null;
                                *ps = s;
                            L2:
                                sn = s.Sfunc.Foversym;
                                s.Sfunc.Foversym = null;
                                s = sn;
                            } while (s);
                        }
                        else
                        {
                            if (!typematch(s.Stype,rover.Stype,0))
                            {
                                // cpp_predefine() will define this again
                                if (type_struct(rover.Stype) &&
                                    rover.Sstruct.Sflags & STRpredef)
                                {   s.Sl = s.Sr = null;
                                    symbol_keep(s);
                                }
                                else
                                    synerr(EM_multiple_def,p);  // already defined
                            }
                        }
                        goto L1;
                    }
                }
                ps = (cmp < 0) ?        /* if we go down left side      */
                    &rover.Sl :
                    &rover.Sr;
            }
            {
                s.Sl = s.Sr = null;
                *ps = s;
            }
        }
    L1:
        symboltable_hydrate(sl,родитель);
        s = sr;
    }
}

}


/************************************
 * Hydrate/dehydrate an mptr_t.
 */

static if (HYDRATE)
{
private проц mptr_hydrate(mptr_t **pm)
{   mptr_t *m;

    m = cast(mptr_t *) ph_hydrate(cast(ук*)pm);
    symbol_hydrate(&m.MPf);
    symbol_hydrate(&m.MPparent);
}
}

static if (DEHYDRATE)
{
private проц mptr_dehydrate(mptr_t **pm)
{   mptr_t *m;

    m = *pm;
    if (m && !isdehydrated(m))
    {
        ph_dehydrate(pm);
version (DEBUG_XSYMGEN)
{
        if (xsym_gen && ph_in_head(m.MPf))
            ph_dehydrate(&m.MPf);
        else
            symbol_dehydrate(&m.MPf);
}
else
        symbol_dehydrate(&m.MPf);

        symbol_dehydrate(&m.MPparent);
    }
}
}

/************************************
 * Hydrate/dehydrate a baseclass_t.
 */

static if (HYDRATE)
{
private проц baseclass_hydrate(baseclass_t **pb)
{   baseclass_t *b;

    assert(pb);
    while (isdehydrated(*pb))
    {
        b = cast(baseclass_t *) ph_hydrate(cast(ук*)pb);

        ph_hydrate(cast(ук*)&b.BCbase);
        ph_hydrate(cast(ук*)&b.BCpbase);
        list_hydrate(&b.BCpublics,cast(list_free_fp)&symbol_hydrate);
        list_hydrate(&b.BCmptrlist,cast(list_free_fp)&mptr_hydrate);
        symbol_hydrate(&b.BCvtbl);
        Classsym_hydrate(&b.BCparent);

        pb = &b.BCnext;
    }
}
}

/**********************************
 * Dehydrate a baseclass_t.
 */

static if (DEHYDRATE)
{
private проц baseclass_dehydrate(baseclass_t **pb)
{   baseclass_t *b;

    while ((b = *pb) != null && !isdehydrated(b))
    {
        ph_dehydrate(pb);

version (DEBUG_XSYMGEN)
{
        if (xsym_gen && ph_in_head(b))
            return;
}

        ph_dehydrate(&b.BCbase);
        ph_dehydrate(&b.BCpbase);
        list_dehydrate(&b.BCpublics,cast(list_free_fp)&symbol_dehydrate);
        list_dehydrate(&b.BCmptrlist,cast(list_free_fp)&mptr_dehydrate);
        symbol_dehydrate(&b.BCvtbl);
        Classsym_dehydrate(&b.BCparent);

        pb = &b.BCnext;
    }
}
}

/***************************
 * Look down baseclass list to найди sbase.
 * Возвращает:
 *      null    not found
 *      pointer to baseclass
 */

baseclass_t *baseclass_find(baseclass_t *bm,Classsym *sbase)
{
    symbol_debug(sbase);
    for (; bm; bm = bm.BCnext)
        if (bm.BCbase == sbase)
            break;
    return bm;
}

baseclass_t *baseclass_find_nest(baseclass_t *bm,Classsym *sbase)
{
    symbol_debug(sbase);
    for (; bm; bm = bm.BCnext)
    {
        if (bm.BCbase == sbase ||
            baseclass_find_nest(bm.BCbase.Sstruct.Sbase, sbase))
            break;
    }
    return bm;
}

/******************************
 * Calculate number of baseclasses in list.
 */

цел baseclass_nitems(baseclass_t *b)
{   цел i;

    for (i = 0; b; b = b.BCnext)
        i++;
    return i;
}


/*****************************
 * Go through symbol table preparing it to be written to a precompiled
 * header. That means removing references to things in the .OBJ файл.
 */

version (SCPP_HTOD)
{

проц symboltable_clean(Symbol *s)
{
    while (s)
    {
        struct_t *st;

        //printf("clean('%s')\n",s.Sident.ptr);
        if (config.fulltypes != CVTDB && s.Sxtrnnum && s.Sfl != FLreg)
            s.Sxtrnnum = 0;    // eliminate debug info тип index
        switch (s.Sclass)
        {
            case SCstruct:
                s.Stypidx = 0;
                st = s.Sstruct;
                assert(st);
                symboltable_clean(st.Sroot);
                //list_apply(&st.Sfldlst,cast(list_free_fp)&symboltable_clean);
                break;

            case SCtypedef:
            case SCenum:
                s.Stypidx = 0;
                break;

            case SCtemplate:
            {   template_t *tm = s.Stemplate;

                list_apply(&tm.TMinstances,cast(list_free_fp)&symboltable_clean);
                break;
            }

            case SCnamespace:
                symboltable_clean(s.Snameroot);
                break;

            default:
                if (s.Sxtrnnum && s.Sfl != FLreg)
                    s.Sxtrnnum = 0;    // eliminate external symbol index
                if (tyfunc(s.Stype.Tty))
                {
                    func_t *f = s.Sfunc;
                    SYMIDX si;

                    debug assert(f);

                    list_apply(&f.Fsymtree,cast(list_free_fp)&symboltable_clean);
                    for (si = 0; si < f.Flocsym.top; si++)
                        symboltable_clean(f.Flocsym.tab[si]);
                    if (f.Foversym)
                        symboltable_clean(f.Foversym);
                    if (f.Fexplicitspec)
                        symboltable_clean(f.Fexplicitspec);
                }
                break;
        }
        if (s.Sl)
            symboltable_clean(s.Sl);
        if (s.Scover)
            symboltable_clean(s.Scover);
        s = s.Sr;
    }
}

}

version (SCPP_HTOD)
{

/*
 * Balance our symbol tree in place. This is nice for precompiled headers, since they
 * will typically be written out once, but читай in many times. We balance the tree in
 * place by traversing the tree inorder and writing the pointers out to an ordered
 * list. Once we have a list of symbol pointers, we can создай a tree by recursively
 * dividing the list, using the midpoint of each division as the new root for that
 * subtree.
 */

struct Balance
{
    бцел nsyms;
    Symbol **массив;
    бцел index;
}

private  Balance balance;

private проц count_symbols(Symbol *s)
{
    while (s)
    {
        balance.nsyms++;
        switch (s.Sclass)
        {
            case SCnamespace:
                symboltable_balance(&s.Snameroot);
                break;

            case SCstruct:
                symboltable_balance(&s.Sstruct.Sroot);
                break;

            default:
                break;
        }
        count_symbols(s.Sl);
        s = s.Sr;
    }
}

private проц place_in_array(Symbol *s)
{
    while (s)
    {
        place_in_array(s.Sl);
        balance.массив[balance.index++] = s;
        s = s.Sr;
    }
}

/*
 * Create a tree in place by subdividing between lo and hi inclusive, using i
 * as the root for the tree. When the lo-hi interval is one, we've either
 * reached a leaf or an empty узел. We subdivide below i by halving the interval
 * between i and lo, and using i-1 as our new hi point. A similar subdivision
 * is created above i.
 */
private Symbol * create_tree(цел i, цел lo, цел hi)
{
    Symbol *s = balance.массив[i];

    if (i < lo || i > hi)               /* empty узел ? */
        return null;

    assert(cast(бцел) i < balance.nsyms);
    if (i == lo && i == hi) {           /* leaf узел ? */
        s.Sl = null;
        s.Sr = null;
        return s;
    }

    s.Sl = create_tree((i + lo) / 2, lo, i - 1);
    s.Sr = create_tree((i + hi + 1) / 2, i + 1, hi);

    return s;
}

const METRICS = нет;

проц symboltable_balance(Symbol **ps)
{
    Balance balancesave;
static if (METRICS)
{
    clock_t ticks;

    printf("symbol table before balance:\n");
    symbol_table_metrics();
    ticks = clock();
}
    balancesave = balance;              // so we can nest
    balance.nsyms = 0;
    count_symbols(*ps);
    //printf("Number of глоб2 symbols = %d\n",balance.nsyms);

    // Use malloc instead of mem because of pagesize limits
    balance.массив = cast(Symbol **) malloc(balance.nsyms * (Symbol *).sizeof);
    if (!balance.массив)
        goto Lret;                      // no error, just don't balance

    balance.index = 0;
    place_in_array(*ps);

    *ps = create_tree(balance.nsyms / 2, 0, balance.nsyms - 1);

    free(balance.массив);
static if (METRICS)
{
    printf("time to balance: %ld\n", clock() - ticks);
    printf("symbol table after balance:\n");
    symbol_table_metrics();
}
Lret:
    balance = balancesave;
}

}

/*****************************************
 * Symbol table search routine for члены of structs, given that
 * we don't know which struct it is in.
 * Give error message if it appears more than once.
 * Возвращает:
 *      null            member not found
 *      symbol*         symbol matching member
 */

version (SCPP_HTOD)
{

struct Paramblock       // to minimize stack использование in helper function
{   ткст0 ид;     // идентификатор we are looking for
    Symbol *sm;         // where to put результат
    Symbol *s;
}

private проц membersearchx(Paramblock *p,Symbol *s)
{
    while (s)
    {
        symbol_debug(s);

        switch (s.Sclass)
        {
            case SCstruct:
                foreach (sl; ListRange(s.Sstruct.Sfldlst))
                {
                    Symbol* sm = list_symbol(sl);
                    symbol_debug(sm);
                    if ((sm.Sclass == SCmember || sm.Sclass == SCfield) &&
                        strcmp(p.ид,sm.Sident.ptr) == 0)
                    {
                        if (p.sm && p.sm.Smemoff != sm.Smemoff)
                            synerr(EM_ambig_member,p.ид,s.Sident.ptr,p.s.Sident.ptr);       // ambiguous reference to ид
                        p.s = s;
                        p.sm = sm;
                        break;
                    }
                }
                break;

            default:
                break;
        }

        if (s.Sl)
            membersearchx(p,s.Sl);
        s = s.Sr;
    }
}

Symbol *symbol_membersearch(ткст0 ид)
{
    list_t sl;
    Paramblock pb;
    Scope *sc;

    pb.ид = ид;
    pb.sm = null;
    for (sc = scope_end; sc; sc = sc.следщ)
    {
        if (sc.sctype & (CPP ? (SCTglobal | SCTlocal) : (SCTglobaltag | SCTtag)))
            membersearchx(cast(Paramblock *)&pb,cast(Symbol *)sc.root);
    }
    return pb.sm;
}

/*******************************************
 * Generate debug info for глоб2 struct tag symbols.
 */

private проц symbol_gendebuginfox(Symbol *s)
{
    for (; s; s = s.Sr)
    {
        if (s.Sl)
            symbol_gendebuginfox(s.Sl);
        if (s.Scover)
            symbol_gendebuginfox(s.Scover);
        switch (s.Sclass)
        {
            case SCenum:
                if (CPP && s.Senum.SEflags & SENnotagname)
                    break;
                goto Lout;
            case SCstruct:
                if (s.Sstruct.Sflags & STRanonymous)
                    break;
                goto Lout;
            case SCtypedef:
            Lout:
                if (!s.Stypidx)
                    cv_outsym(s);
                break;

            default:
                break;
        }
    }
}

проц symbol_gendebuginfo()
{   Scope *sc;

    for (sc = scope_end; sc; sc = sc.следщ)
    {
        if (sc.sctype & (SCTglobaltag | SCTglobal))
            symbol_gendebuginfox(cast(Symbol *)sc.root);
    }
}

}

/*************************************
 * Reset Symbol so that it's now an "extern" to the следщ obj файл being created.
 */
проц symbol_reset(Symbol *s)
{
    s.Soffset = 0;
    s.Sxtrnnum = 0;
    s.Stypidx = 0;
    s.Sflags &= ~(STRoutdef | SFLweak);
    s.Sdw_ref_idx = 0;
    if (s.Sclass == SCglobal || s.Sclass == SCcomdat ||
        s.Sfl == FLudata || s.Sclass == SCstatic)
    {   s.Sclass = SCextern;
        s.Sfl = FLextern;
    }
}

/****************************************
 * Determine pointer тип needed to access a Symbol,
 * essentially what тип an OPrelconst should get
 * for that Symbol.
 * Параметры:
 *      s = pointer to Symbol
 * Возвращает:
 *      pointer тип to access it
 */
tym_t symbol_pointerType( Symbol* s)
{
    return s.Stype.Tty & mTYimmutable ? TYimmutPtr : TYnptr;
}

}
