/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 2015-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     Rainer Schuetze
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/dvarstats.d, backend/dvarstats.d)
 */

module drc.backend.dvarstats;

/******************************************
 * support for lexical scope of local variables
 */

import cidrus;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.глоб2;
import drc.backend.code;

/*extern (C++):*/



alias extern(C) цел function(ук, ук) _compare_fp_t;
extern(C) проц qsort(ук base, т_мера nmemb, т_мера size, _compare_fp_t compar);

version (all) // free function version
{
    import drc.backend.dvarstats;

    проц varStats_writeSymbolTable(symtab_t* symtab,
            проц function(Symbol*) fnWriteVar, проц function() fnEndArgs,
            проц function(цел off,цел len) fnBeginBlock, проц function()  fnEndBlock)
    {
        varStats.writeSymbolTable(symtab, fnWriteVar, fnEndArgs, fnBeginBlock, fnEndBlock);
    }

    проц varStats_startFunction()
    {
        varStats.startFunction();
    }

    проц varStats_recordLineOffset(Srcpos src, targ_т_мера off)
    {
        varStats.recordLineOffset(src, off);
    }

     VarStatistics varStats;
}


// estimate of variable life time
struct LifeTime
{
    Symbol* sym;
    цел offCreate;  // variable created before this code смещение
    цел offDestroy; // variable destroyed after this code смещение
}

struct LineOffset
{
    targ_т_мера смещение;
    бцел номстр;
    бцел diffNextOffset;
}

struct VarStatistics
{
private:

    LifeTime* lifeTimes;
    цел cntAllocLifeTimes;
    цел cntUsedLifeTimes;

    // symbol table sorted by смещение of variable creation
    symtab_t sortedSymtab;
    SYMIDX* nextSym;      // следщ symbol with идентификатор with same хэш, same size as sortedSymtab
    цел uniquecnt;        // number of variables that have unique имя and don't need lexical scope

    // line number records for the current function
    LineOffset* lineOffsets;
    цел cntAllocLineOffsets;
    цел cntUsedLineOffsets;
    ткст0 srcfile;  // only one файл supported, no inline

public проц startFunction()
{
    cntUsedLineOffsets = 0;
    srcfile = null;
}

// figure if can we can add a lexical scope for the variable
// (this should exclude variables from inlined functions as there is
//  no support for gathering stats from different files)
private бул isLexicalScopeVar(Symbol* sa)
{
    if (sa.lnoscopestart <= 0 || sa.lnoscopestart > sa.lnoscopeend)
        return нет;

    // is it inside the function? Unfortunately we cannot verify the source файл in case of inlining
    if (sa.lnoscopestart < funcsym_p.Sfunc.Fstartline.Slinnum)
        return нет;
    if (sa.lnoscopeend > funcsym_p.Sfunc.Fendline.Slinnum)
        return нет;

    return да;
}

// compare function to sort symbols by line offsets of their creation
private extern (C) static цел cmpLifeTime(ук p1, ук p2)
{
     LifeTime* lt1 = cast(LifeTime*)p1;
     LifeTime* lt2 = cast(LifeTime*)p2;

    return lt1.offCreate - lt2.offCreate;
}

// a родитель scope содержит the creation смещение of the child scope
private static SYMIDX isParentScope(LifeTime* lifetimes, SYMIDX родитель, SYMIDX si)
{
    if(родитель < 0) // full function
        return да;
    return lifetimes[родитель].offCreate <= lifetimes[si].offCreate &&
           lifetimes[родитель].offDestroy > lifetimes[si].offCreate;
}

// найди a symbol that includes the creation of the given symbol as part of its life time
private static SYMIDX findParentScope(LifeTime* lifetimes, SYMIDX si)
{
    for(SYMIDX sj = si - 1; sj >= 0; --sj)
        if(isParentScope(lifetimes, sj, si))
           return sj;
    return -1;
}

private static цел getHash(ткст0 s)
{
    цел хэш = 0;
    for (; *s; s++)
        хэш = хэш * 11 + *s;
    return хэш;
}

private бул hashSymbolIdentifiers(symtab_t* symtab)
{
    // build circular-linked lists of symbols with same идентификатор хэш
    бул hashCollisions = нет;
    SYMIDX[256] firstSym = проц;
    memset(firstSym.ptr, -1, (firstSym).sizeof);
    for (SYMIDX si = 0; si < symtab.top; si++)
    {
        Symbol* sa = symtab.tab[si];
        цел хэш = getHash(sa.Sident.ptr) & 255;
        SYMIDX first = firstSym[хэш];
        if (first == -1)
        {
            // connect full circle, so we don't have to recalculate the хэш
            nextSym[si] = si;
            firstSym[хэш] = si;
        }
        else
        {
            // вставь after first entry
            nextSym[si] = nextSym[first];
            nextSym[first] = si;
            hashCollisions = да;
        }
    }
    return hashCollisions;
}

private бул hasUniqueIdentifier(symtab_t* symtab, SYMIDX si)
{
    Symbol* sa = symtab.tab[si];
    for (SYMIDX sj = nextSym[si]; sj != si; sj = nextSym[sj])
        if (strcmp(sa.Sident.ptr, symtab.tab[sj].Sident.ptr) == 0)
            return нет;
    return да;
}

// gather statistics about creation and destructions of variables that are
//  используется by the current function
private symtab_t* calcLexicalScope(symtab_t* symtab)
{
    // make a копируй of the symbol table
    // - arguments should be kept at the very beginning
    // - variables with unique имя come first (will be emitted with full function scope)
    // - variables with duplicate имена are added with ascending code смещение
    if (sortedSymtab.symmax < symtab.top)
    {
        nextSym = cast(цел*)util_realloc(nextSym, symtab.top, (*nextSym).sizeof);
        sortedSymtab.tab = cast(Symbol**) util_realloc(sortedSymtab.tab, symtab.top, (Symbol*).sizeof);
        sortedSymtab.symmax = symtab.top;
    }

    if (!hashSymbolIdentifiers(symtab))
    {
        // without any collisions, there are no duplicate symbol имена, so bail out early
        uniquecnt = symtab.top;
        return symtab;
    }

    SYMIDX argcnt;
    for (argcnt = 0; argcnt < symtab.top; argcnt++)
    {
        Symbol* sa = symtab.tab[argcnt];
        if (sa.Sclass != SCparameter && sa.Sclass != SCregpar && sa.Sclass != SCfastpar && sa.Sclass != SCshadowreg)
            break;
        sortedSymtab.tab[argcnt] = sa;
    }

    // найди symbols with identical имена, only these need lexical scope
    uniquecnt = argcnt;
    SYMIDX dupcnt = 0;
    for (SYMIDX sj, si = argcnt; si < symtab.top; si++)
    {
        Symbol* sa = symtab.tab[si];
        if (!isLexicalScopeVar(sa) || hasUniqueIdentifier(symtab, si))
            sortedSymtab.tab[uniquecnt++] = sa;
        else
            sortedSymtab.tab[symtab.top - 1 - dupcnt++] = sa; // fill from the top
    }
    sortedSymtab.top = symtab.top;
    if(dupcnt == 0)
        return symtab;

    sortLineOffsets();

    // precalc the lexical blocks to emit so that identically named symbols don't overlap
    if (cntAllocLifeTimes < dupcnt)
    {
        lifeTimes = cast(LifeTime*) util_realloc(lifeTimes, dupcnt, (LifeTime).sizeof);
        cntAllocLifeTimes = dupcnt;
    }

    for (SYMIDX si = 0; si < dupcnt; si++)
    {
        lifeTimes[si].sym = sortedSymtab.tab[uniquecnt + si];
        lifeTimes[si].offCreate = cast(цел)getLineOffset(lifeTimes[si].sym.lnoscopestart);
        lifeTimes[si].offDestroy = cast(цел)getLineOffset(lifeTimes[si].sym.lnoscopeend);
    }
    cntUsedLifeTimes = dupcnt;
    qsort(lifeTimes, dupcnt, (LifeTime).sizeof, &cmpLifeTime);

    // ensure that an inner block does not extend beyond the end of a родитель block
    for (SYMIDX si = 0; si < dupcnt; si++)
    {
        SYMIDX sj = findParentScope(lifeTimes, si);
        if(sj >= 0 && lifeTimes[si].offDestroy > lifeTimes[sj].offDestroy)
            lifeTimes[si].offDestroy = lifeTimes[sj].offDestroy;
    }

    // extend life time to the creation of the следщ symbol that is not contained in the родитель scope
    // or that has the same имя
    for (SYMIDX sj, si = 0; si < dupcnt; si++)
    {
        SYMIDX родитель = findParentScope(lifeTimes, si);

        for (sj = si + 1; sj < dupcnt; sj++)
            if(!isParentScope(lifeTimes, родитель, sj))
                break;
            else if (strcmp(lifeTimes[si].sym.Sident.ptr, lifeTimes[sj].sym.Sident.ptr) == 0)
                break;

        lifeTimes[si].offDestroy = cast(цел)(sj < dupcnt ? lifeTimes[sj].offCreate : retoffset + retsize); // function length
    }

    // store duplicate symbols back with new ordering
    for (SYMIDX si = 0; si < dupcnt; si++)
        sortedSymtab.tab[uniquecnt + si] = lifeTimes[si].sym;

    return &sortedSymtab;
}

public проц writeSymbolTable(symtab_t* symtab,
            проц function(Symbol*)  fnWriteVar, проц function()  fnEndArgs,
            проц function(цел off,цел len)  fnBeginBlock, проц function()  fnEndBlock)
{
    symtab = calcLexicalScope(symtab);

    цел openBlocks = 0;
    цел lastOffset = 0;

    // Write local symbol table
    бул endarg = нет;
    for (SYMIDX si = 0; si < symtab.top; si++)
    {
        Symbol *sa = symtab.tab[si];
        if (endarg == нет &&
            sa.Sclass != SCparameter &&
            sa.Sclass != SCfastpar &&
            sa.Sclass != SCregpar &&
            sa.Sclass != SCshadowreg)
        {
            if(fnEndArgs)
                (*fnEndArgs)();
            endarg = да;
        }
        if (si >= uniquecnt)
        {
            цел off = lifeTimes[si - uniquecnt].offCreate;
            // close scopes that end before the creation of this symbol
            for (SYMIDX sj = si - 1; sj >= uniquecnt; --sj)
            {
                if (lastOffset < lifeTimes[sj - uniquecnt].offDestroy && lifeTimes[sj - uniquecnt].offDestroy <= off)
                {
                    assert(openBlocks > 0);
                    if(fnEndBlock)
                        (*fnEndBlock)();
                    openBlocks--;
                }
            }
            цел len = lifeTimes[si - uniquecnt].offDestroy - off;
            // don't emit a block for length 0, it isn't captured by the close условие above
            if (len > 0)
            {
                if(fnBeginBlock)
                    (*fnBeginBlock)(off, len);
                openBlocks++;
            }
            lastOffset = off;
        }
        (*fnWriteVar)(sa);
    }

    while (openBlocks > 0)
    {
        if(fnEndBlock)
            (*fnEndBlock)();
        openBlocks--;
    }
}

// compare function to sort line offsets ascending by line (and смещение on identical line)
private extern (C) static цел cmpLineOffsets(ук off1, ук off2)
{
     LineOffset* loff1 = cast(LineOffset*)off1;
     LineOffset* loff2 = cast(LineOffset*)off2;

    if (loff1.номстр == loff2.номстр)
        return cast(цел)(loff1.смещение - loff2.смещение);
    return loff1.номстр - loff2.номстр;
}

private проц sortLineOffsets()
{
    if (cntUsedLineOffsets == 0)
        return;

    // remember the смещение to the следщ recorded смещение on another line
    for (цел i = 1; i < cntUsedLineOffsets; i++)
        lineOffsets[i-1].diffNextOffset = cast(бцел)(lineOffsets[i].смещение - lineOffsets[i-1].смещение);
    lineOffsets[cntUsedLineOffsets - 1].diffNextOffset = cast(бцел)(retoffset + retsize - lineOffsets[cntUsedLineOffsets - 1].смещение);

    // sort line records and удали duplicate строки preferring smaller offsets
    qsort(lineOffsets, cntUsedLineOffsets, (*lineOffsets).sizeof, &cmpLineOffsets);
    цел j = 0;
    for (цел i = 1; i < cntUsedLineOffsets; i++)
        if (lineOffsets[i].номстр > lineOffsets[j].номстр)
            lineOffsets[++j] = lineOffsets[i];
    cntUsedLineOffsets = j + 1;
}

private targ_т_мера getLineOffset(цел номстр)
{
    цел idx = findLineIndex(номстр);
    if (idx >= cntUsedLineOffsets || lineOffsets[idx].номстр < номстр)
        return retoffset + retsize; // function length
    if (idx > 0 && lineOffsets[idx].номстр != номстр)
        // for inexact line numbers, use the смещение following the previous line
        return lineOffsets[idx-1].смещение + lineOffsets[idx-1].diffNextOffset;
    return lineOffsets[idx].смещение;
}

// return the first record index in the lineOffsets массив with номстр >= line
private цел findLineIndex(бцел line)
{
    цел low = 0;
    цел high = cntUsedLineOffsets;
    while (low < high)
    {
        цел mid = (low + high) >> 1;
        цел ln = lineOffsets[mid].номстр;
        if (line < ln)
            high = mid;
        else if (line > ln)
            low = mid + 1;
        else
            return mid;
    }
    return low;
}

public проц recordLineOffset(Srcpos src, targ_т_мера off)
{
    // only record line numbers from one файл, symbol info does not include source файл
    if (!src.Sfilename || !src.Slinnum)
        return;
    if (!srcfile)
        srcfile = src.Sfilename;
    if (srcfile != src.Sfilename && strcmp (srcfile, src.Sfilename) != 0)
        return;

    // assume ascending code offsets generated during codegen, ignore any other
    //  (e.g. there is an additional line number emitted at the end of the function
    //   or multiple line numbers at the same смещение)
    if (cntUsedLineOffsets > 0 && lineOffsets[cntUsedLineOffsets-1].смещение >= off)
        return;

    if (cntUsedLineOffsets > 0 && lineOffsets[cntUsedLineOffsets-1].номстр == src.Slinnum)
    {
        // optimize common case: new смещение on same line
        return;
    }
    // don't care for lineOffsets being ordered now, that is taken care of later (calcLexicalScope)
    if (cntUsedLineOffsets >= cntAllocLineOffsets)
    {
        cntAllocLineOffsets = 2 * cntUsedLineOffsets + 16;
        lineOffsets = cast(LineOffset*) util_realloc(lineOffsets, cntAllocLineOffsets, (*lineOffsets).sizeof);
    }
    lineOffsets[cntUsedLineOffsets].номстр = src.Slinnum;
    lineOffsets[cntUsedLineOffsets].смещение = off;
    cntUsedLineOffsets++;
}

}
