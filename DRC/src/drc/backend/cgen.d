/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1985-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/cgen.d, backend/cgen.d)
 */

module drc.backend.cgen;

version (SCPP)
    version = COMPILE;
version (Dinrus)
    version = COMPILE;

version (COMPILE)
{

import cidrus;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.code;
import drc.backend.code_x86;
import drc.backend.codebuilder;
import drc.backend.mem;
import drc.backend.el;
import drc.backend.глоб2;
import drc.backend.obj;
import drc.backend.ty;
import drc.backend.тип;

version (SCPP)
{
    import msgs2;
}

/*extern (C++):*/



dt_t *dt_get_nzeros(бцел n);

extern  CGstate cgstate;

/*****************************
 * Find last code in list.
 */

code *code_last(code *c)
{
    if (c)
    {   while (c.следщ)
            c = c.следщ;
    }
    return c;
}

/*****************************
 * Set флаг bits on last code in list.
 */

проц code_orflag(code *c,бцел флаг)
{
    if (флаг && c)
    {   while (c.следщ)
            c = c.следщ;
        c.Iflags |= флаг;
    }
}

/*****************************
 * Set rex bits on last code in list.
 */

проц code_orrex(code *c,бцел rex)
{
    if (rex && c)
    {   while (c.следщ)
            c = c.следщ;
        c.Irex |= rex;
    }
}


/*****************************
 * Concatenate two code lists together. Return pointer to результат.
 */

code *cat(code *c1,code *c2)
{   code **pc;

    if (!c1)
        return c2;
    for (pc = &c1.следщ; *pc; pc = &(*pc).следщ)
    { }
    *pc = c2;
    return c1;
}


/*****************************
 * Add code to end of linked list.
 * Note that unused operands are garbage.
 * gen1() and gen2() are shortcut routines.
 * Input:
 *      c ->    linked list that code is to be added to end of
 *      cs ->   данные for the code
 * Возвращает:
 *      pointer to start of code list
 */

code *gen(code *c,code *cs)
{
    debug assert(cs);
    assert(I64 || cs.Irex == 0);
    code* ce = code_malloc();
    *ce = *cs;
    //printf("ce = %p %02x\n", ce, ce.Iop);
    //ccheck(ce);
    simplify_code(ce);
    ce.следщ = null;
    if (c)
    {   code* cstart = c;
        while (code_next(c)) c = code_next(c);  /* найди end of list     */
        c.следщ = ce;                      /* link into list       */
        return cstart;
    }
    return ce;
}

code *gen1(code *c,opcode_t op)
{
    code* ce;
    code* cstart;

  ce = code_calloc();
  ce.Iop = op;
  //ccheck(ce);
  assert(op != LEA);
  if (c)
  {     cstart = c;
        while (code_next(c)) c = code_next(c);  /* найди end of list     */
        c.следщ = ce;                      /* link into list       */
        return cstart;
  }
  return ce;
}

code *gen2(code *c,opcode_t op,бцел rm)
{
    code* ce;
    code* cstart;

  cstart = ce = code_calloc();
  /*cxcalloc++;*/
  ce.Iop = op;
  ce.Iea = rm;
  //ccheck(ce);
  if (c)
  {     cstart = c;
        while (code_next(c)) c = code_next(c);  /* найди end of list     */
        c.следщ = ce;                      /* link into list       */
  }
  return cstart;
}


code *gen2sib(code *c,opcode_t op,бцел rm,бцел sib)
{
    code* ce;
    code* cstart;

  cstart = ce = code_calloc();
  /*cxcalloc++;*/
  ce.Iop = op;
  ce.Irm = cast(ббайт)rm;
  ce.Isib = cast(ббайт)sib;
  ce.Irex = cast(ббайт)((rm | (sib & (REX_B << 16))) >> 16);
  if (sib & (REX_R << 16))
        ce.Irex |= REX_X;
  //ccheck(ce);
  if (c)
  {     cstart = c;
        while (code_next(c)) c = code_next(c);  /* найди end of list     */
        c.следщ = ce;                      /* link into list       */
  }
  return cstart;
}


code *genc2(code *c,opcode_t op,бцел ea,targ_т_мера EV2)
{   code cs;

    cs.Iop = op;
    cs.Iea = ea;
    //ccheck(&cs);
    cs.Iflags = CFoff;
    cs.IFL2 = FLconst;
    cs.IEV2.Vт_мера = EV2;
    return gen(c,&cs);
}

/*****************
 * Generate code.
 */

code *genc(code *c,opcode_t op,бцел ea,бцел FL1,targ_т_мера EV1,бцел FL2,targ_т_мера EV2)
{   code cs;

    assert(FL1 < FLMAX);
    cs.Iop = op;
    cs.Iea = ea;
    //ccheck(&cs);
    cs.Iflags = CFoff;
    cs.IFL1 = cast(ббайт)FL1;
    cs.IEV1.Vт_мера = EV1;
    assert(FL2 < FLMAX);
    cs.IFL2 = cast(ббайт)FL2;
    cs.IEV2.Vт_мера = EV2;
    return gen(c,&cs);
}


/********************************
 * Generate 'instruction' which is actually a line number.
 */

code *genlinnum(code *c,Srcpos srcpos)
{   code cs;

    //srcpos.print("genlinnum");
    cs.Iop = ESCAPE | ESClinnum;
    cs.IEV1.Vsrcpos = srcpos;
    return gen(c,&cs);
}

/*****************************
 * Prepend line number to existing code.
 */

проц cgen_prelinnum(code **pc,Srcpos srcpos)
{
    *pc = cat(genlinnum(null,srcpos),*pc);
}

/********************************
 * Generate 'instruction' which tells the scheduler that the fpu stack has
 * changed.
 */

code *genadjfpu(code *c, цел смещение)
{   code cs;

    if (!I16 && смещение)
    {
        cs.Iop = ESCAPE | ESCadjfpu;
        cs.IEV1.Vint = смещение;
        return gen(c,&cs);
    }
    else
        return c;
}


/********************************
 * Generate 'nop'
 */

code *gennop(code *c)
{
    return gen1(c,NOP);
}


/****************************************
 * Clean stack after call to codelem().
 */

проц gencodelem(ref CodeBuilder cdb,elem *e,regm_t *pretregs,бул constflag)
{
    if (e)
    {
        бцел stackpushsave;
        цел stackcleansave;

        stackpushsave = stackpush;
        stackcleansave = cgstate.stackclean;
        cgstate.stackclean = 0;                         // defer cleaning of stack
        codelem(cdb,e,pretregs,constflag);
        assert(cgstate.stackclean == 0);
        cgstate.stackclean = stackcleansave;
        genstackclean(cdb,stackpush - stackpushsave,*pretregs);       // do defered cleaning
    }
}

/**********************************
 * Determine if one of the registers in regm has значение in it.
 * If so, return !=0 and set *preg to which register it is.
 */

бул reghasvalue(regm_t regm,targ_т_мера значение,reg_t *preg)
{
    //printf("reghasvalue(%s, %llx)\n", regm_str(regm), cast(бдол)значение);
    /* See if another register has the right значение      */
    reg_t r = 0;
    for (regm_t mreg = regcon.immed.mval; mreg; mreg >>= 1)
    {
        if (mreg & regm & 1 && regcon.immed.значение[r] == значение)
        {   *preg = r;
            return да;
        }
        r++;
        regm >>= 1;
    }
    return нет;
}

/**************************************
 * Load a register from the mask regm with значение.
 * Output:
 *      *preg   the register selected
 */

проц regwithvalue(ref CodeBuilder cdb,regm_t regm,targ_т_мера значение,reg_t *preg,regm_t flags)
{
    //printf("regwithvalue(значение = %lld)\n", (long long)значение);
    reg_t reg;
    if (!preg)
        preg = &reg;

    // If we don't already have a register with the right значение in it
    if (!reghasvalue(regm,значение,preg))
    {
        regm_t save = regcon.immed.mval;
        allocreg(cdb,&regm,preg,TYint);  // размести register
        regcon.immed.mval = save;
        movregconst(cdb,*preg,значение,flags);   // store значение into reg
    }
}

/************************
 * When we don't know whether a function symbol is defined or not
 * within this module, we stuff it in an массив of references to be
 * fixed up later.
 */
struct Fixup
{
    Symbol      *sym;       // the referenced Symbol
    цел         seg;        // where the fixup is going (CODE or DATA, never UDATA)
    цел         flags;      // CFxxxx
    targ_т_мера смещение;     // addr of reference to Symbol
    targ_т_мера val;        // значение to add into location
static if (TARGET_OSX)
{
    Symbol      *funcsym;   // function the Symbol goes in
}
}

struct FixupArray
{

    Fixup *ptr;
    т_мера dim, cap;

    проц сунь(ref Fixup e)
    {
        if (dim == cap)
        {
            // 0x800 determined experimentally to minimize reallocations
            cap = cap
                ? (3 * cap) / 2 // use 'Tau' of 1.5
                : 0x800;
            ptr = cast(Fixup *)mem_realloc(ptr, cap * Fixup.sizeof);
        }
        ptr[dim++] = e;
    }

    Fixup opIndex(т_мера idx)
    {
        assert(idx < dim);
        return ptr[idx];
    }

    проц clear()
    {
        dim = 0;
    }
}

private  FixupArray fixups;

/****************************
 * Add to the fix list.
 */

т_мера addtofixlist(Symbol *s,targ_т_мера смещение,цел seg,targ_т_мера val,цел flags)
{
        static const ббайт[8] zeros = 0;

        //printf("addtofixlist(%p '%s')\n",s,s.Sident);
        assert(I32 || flags);
        Fixup f;
        f.sym = s;
        f.смещение = смещение;
        f.seg = seg;
        f.flags = flags;
        f.val = val;
static if (TARGET_OSX)
{
        f.funcsym = funcsym_p;
}
        fixups.сунь(f);

        т_мера numbytes;
static if (TARGET_SEGMENTED)
{
        switch (flags & (CFoff | CFseg))
        {
            case CFoff:         numbytes = tysize(TYnptr);      break;
            case CFseg:         numbytes = 2;                   break;
            case CFoff | CFseg: numbytes = tysize(TYfptr);      break;
            default:            assert(0);
        }
}
else
{
        numbytes = tysize(TYnptr);
        if (I64 && !(flags & CFoffset64))
            numbytes = 4;

static if (TARGET_WINDOS)
{
        /* This can happen when generating CV8 данные
         */
        if (flags & CFseg)
            numbytes += 2;
}
}
        debug assert(numbytes <= zeros.sizeof);
        objmod.bytes(seg,смещение,cast(бцел)numbytes,cast(ббайт*)zeros.ptr);
        return numbytes;
}

static if (0)
{
проц searchfixlist (Symbol *s )
{
    //printf("searchfixlist(%s)\n", s.Sident);
}
}

/****************************
 * Output fixups as references to external or static Symbol.
 * First emit данные for still undefined static Symbols or mark non-static Symbols as SCextern.
 */
private проц outfixup(ref Fixup f)
{
    symbol_debug(f.sym);
    //printf("outfixup '%s' смещение %04x\n", f.sym.Sident, f.смещение);

static if (TARGET_SEGMENTED)
{
    if (tybasic(f.sym.ty()) == TYf16func)
    {
        Obj.far16thunk(f.sym);          /* make it into a thunk         */
        objmod.reftoident(f.seg, f.смещение, f.sym, f.val, f.flags);
        return;
    }
}

    if (f.sym.Sxtrnnum == 0)
    {
        if (f.sym.Sclass == SCstatic)
        {
version (SCPP)
{
            if (f.sym.Sdt)
            {
                outdata(f.sym);
            }
            else if (f.sym.Sseg == UNKNOWN)
                synerr(EM_no_static_def,prettyident(f.sym)); // no definition found for static
}
else // Dinrus
{
            // OBJ_OMF does not set Sxtrnnum for static Symbols, so check
            // whether the Symbol was assigned to a segment instead, compare
            // outdata(Symbol *s)
            if (f.sym.Sseg == UNKNOWN)
            {
                printf("Error: no definition for static %s\n", prettyident(f.sym)); // no definition found for static
                err_exit(); // BUG: do better
            }
}
        }
        else if (f.sym.Sflags & SFLwasstatic)
        {
            // Put it in BSS
            f.sym.Sclass = SCstatic;
            f.sym.Sfl = FLunde;
            f.sym.Sdt = dt_get_nzeros(cast(бцел)type_size(f.sym.Stype));
            outdata(f.sym);
        }
        else if (f.sym.Sclass != SCsinline)
        {
            f.sym.Sclass = SCextern;   /* make it external             */
            objmod.external(f.sym);
            if (f.sym.Sflags & SFLweak)
                objmod.wkext(f.sym, null);
        }
    }

static if (TARGET_OSX)
{
    Symbol *funcsymsave = funcsym_p;
    funcsym_p = f.funcsym;
    objmod.reftoident(f.seg, f.смещение, f.sym, f.val, f.flags);
    funcsym_p = funcsymsave;
}
else
{
    objmod.reftoident(f.seg, f.смещение, f.sym, f.val, f.flags);
}
}

/****************************
 * End of module. Output fixups as references
 * to external Symbols.
 */
проц outfixlist()
{
    for (т_мера i = 0; i < fixups.dim; ++i)
        outfixup(fixups[i]);
    fixups.clear();
}

}
