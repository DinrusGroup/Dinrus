/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1985-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/codebuilder.d, backend/_codebuilder.d)
 * Documentation: https://dlang.org/phobos/dmd_backend_codebuilder.html
 */

module drc.backend.codebuilder;

import cidrus;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.code;
import drc.backend.code_x86;
import drc.backend.mem;
import drc.backend.outbuf;
import drc.backend.ty;
import drc.backend.тип;

alias drc.backend.cc.Symbol Symbol;
alias drc.backend.ty.tym_t tym_t;

 struct CodeBuilder
{
  private:

    code *head;
    code **pTail;

  
  public:
    //this() { pTail = &head; }
    //this(code *c);

    проц ctor()
    {
        pTail = &head;
    }

    проц ctor(code* c)
    {
        head = c;
        pTail = c ? &code_last(c).следщ : &head;
    }

    code *finish()
    {
        return head;
    }

    code *peek() { return head; }       // non-destructively look at the list

    проц сбрось() { head = null; pTail = &head; }

    проц приставь(ref CodeBuilder cdb)
    {
        if (cdb.head)
        {
            *pTail = cdb.head;
            pTail = cdb.pTail;
        }
    }

    проц приставь(ref CodeBuilder cdb1, ref CodeBuilder cdb2)
    {
        приставь(cdb1);
        приставь(cdb2);
    }

    проц приставь(ref CodeBuilder cdb1, ref CodeBuilder cdb2, ref CodeBuilder cdb3)
    {
        приставь(cdb1);
        приставь(cdb2);
        приставь(cdb3);
    }

    проц приставь(ref CodeBuilder cdb1, ref CodeBuilder cdb2, ref CodeBuilder cdb3, ref CodeBuilder cdb4)
    {
        приставь(cdb1);
        приставь(cdb2);
        приставь(cdb3);
        приставь(cdb4);
    }

    проц приставь(ref CodeBuilder cdb1, ref CodeBuilder cdb2, ref CodeBuilder cdb3, ref CodeBuilder cdb4, ref CodeBuilder cdb5)
    {
        приставь(cdb1);
        приставь(cdb2);
        приставь(cdb3);
        приставь(cdb4);
        приставь(cdb5);
    }

    проц приставь(code *c)
    {
        if (c)
        {
            CodeBuilder cdb = проц;
            cdb.ctor(c);
            приставь(cdb);
        }
    }

    проц gen(code *cs)
    {
        /* this is a high использование routine */
        debug assert(cs);
        assert(I64 || cs.Irex == 0);
        code* ce = code_malloc();
        *ce = *cs;
        //printf("ce = %p %02x\n", ce, ce.Iop);
        //code_print(ce);
        ccheck(ce);
        simplify_code(ce);
        ce.следщ = null;

        *pTail = ce;
        pTail = &ce.следщ;
    }

    проц gen1(opcode_t op)
    {
        code *ce = code_calloc();
        ce.Iop = op;
        ccheck(ce);
        assert(op != LEA);

        *pTail = ce;
        pTail = &ce.следщ;
    }

    проц gen2(opcode_t op, бцел rm)
    {
        code *ce = code_calloc();
        ce.Iop = op;
        ce.Iea = rm;
        ccheck(ce);

        *pTail = ce;
        pTail = &ce.следщ;
    }

    /***************************************
     * Generate floating point instruction.
     */
    проц genf2(opcode_t op, бцел rm)
    {
        genfwait(this);
        gen2(op, rm);
    }

    проц gen2sib(opcode_t op, бцел rm, бцел sib)
    {
        code *ce = code_calloc();
        ce.Iop = op;
        ce.Irm = cast(ббайт)rm;
        ce.Isib = cast(ббайт)sib;
        ce.Irex = cast(ббайт)((rm | (sib & (REX_B << 16))) >> 16);
        if (sib & (REX_R << 16))
            ce.Irex |= REX_X;
        ccheck(ce);

        *pTail = ce;
        pTail = &ce.следщ;
    }

    /********************************
     * Generate an ASM sequence.
     */
    проц genasm(сим *s, бцел slen)
    {
        code *ce = code_calloc();
        ce.Iop = ASM;
        ce.IFL1 = FLasm;
        ce.IEV1.len = slen;
        ce.IEV1.bytes = cast(сим *) mem_malloc(slen);
        memcpy(ce.IEV1.bytes,s,slen);

        *pTail = ce;
        pTail = &ce.следщ;
    }

version (Dinrus)
{
    проц genasm(_LabelDsymbol *label)
    {
        code *ce = code_calloc();
        ce.Iop = ASM;
        ce.Iflags = CFaddrsize;
        ce.IFL1 = FLblockoff;
        ce.IEV1.Vsym = cast(Symbol*)label;

        *pTail = ce;
        pTail = &ce.следщ;
    }
}

    проц genasm(block *label)
    {
        code *ce = code_calloc();
        ce.Iop = ASM;
        ce.Iflags = CFaddrsize;
        ce.IFL1 = FLblockoff;
        ce.IEV1.Vblock = label;
        label.Bflags |= BFLlabel;

        *pTail = ce;
        pTail = &ce.следщ;
    }

    проц gencs(opcode_t op, бцел ea, бцел FL2, Symbol *s)
    {
        code cs;
        cs.Iop = op;
        cs.Iflags = 0;
        cs.Iea = ea;
        ccheck(&cs);
        cs.IFL2 = cast(ббайт)FL2;
        cs.IEV2.Vsym = s;
        cs.IEV2.Voffset = 0;

        gen(&cs);
    }

    проц genc2(opcode_t op, бцел ea, targ_т_мера EV2)
    {
        code cs;
        cs.Iop = op;
        cs.Iflags = 0;
        cs.Iea = ea;
        ccheck(&cs);
        cs.Iflags = CFoff;
        cs.IFL2 = FLconst;
        cs.IEV2.Vт_мера = EV2;

        gen(&cs);
    }

    проц genc1(opcode_t op, бцел ea, бцел FL1, targ_т_мера EV1)
    {
        code cs;
        assert(FL1 < FLMAX);
        cs.Iop = op;
        cs.Iflags = CFoff;
        cs.Iea = ea;
        ccheck(&cs);
        cs.IFL1 = cast(ббайт)FL1;
        cs.IEV1.Vт_мера = EV1;

        gen(&cs);
    }

    проц genc(opcode_t op, бцел ea, бцел FL1, targ_т_мера EV1, бцел FL2, targ_т_мера EV2)
    {
        code cs;
        assert(FL1 < FLMAX);
        cs.Iop = op;
        cs.Iea = ea;
        ccheck(&cs);
        cs.Iflags = CFoff;
        cs.IFL1 = cast(ббайт)FL1;
        cs.IEV1.Vт_мера = EV1;
        assert(FL2 < FLMAX);
        cs.IFL2 = cast(ббайт)FL2;
        cs.IEV2.Vт_мера = EV2;

        gen(&cs);
    }

    /********************************
     * Generate 'instruction' which is actually a line number.
     */
    проц genlinnum(Srcpos srcpos)
    {
        code cs;
        //srcpos.print("genlinnum");
        cs.Iop = ESCAPE | ESClinnum;
        cs.Iflags = 0;
        cs.Iea = 0;
        cs.IEV1.Vsrcpos = srcpos;
        gen(&cs);
    }

    /********************************
     * Generate 'instruction' which tells the address resolver that the stack has
     * changed.
     */
    проц genadjesp(цел смещение)
    {
        if (!I16 && смещение)
        {
            code cs;
            cs.Iop = ESCAPE | ESCadjesp;
            cs.Iflags = 0;
            cs.Iea = 0;
            cs.IEV1.Vint = смещение;
            gen(&cs);
        }
    }

    /********************************
     * Generate 'instruction' which tells the scheduler that the fpu stack has
     * changed.
     */
    проц genadjfpu(цел смещение)
    {
        if (!I16 && смещение)
        {
            code cs;
            cs.Iop = ESCAPE | ESCadjfpu;
            cs.Iflags = 0;
            cs.Iea = 0;
            cs.IEV1.Vint = смещение;
            gen(&cs);
        }
    }

    проц gennop()
    {
        gen1(NOP);
    }

    /**************************
     * Generate code to deal with floatreg.
     */
    проц genfltreg(opcode_t opcode,бцел reg,targ_т_мера смещение)
    {
        floatreg = да;
        reflocal = да;
        if ((opcode & ~7) == 0xD8)
            genfwait(this);
        genc1(opcode,modregxrm(2,reg,BPRM),FLfltreg,смещение);
    }

    проц genxmmreg(opcode_t opcode,reg_t xreg,targ_т_мера смещение, tym_t tym)
    {
        assert(isXMMreg(xreg));
        floatreg = да;
        reflocal = да;
        genc1(opcode,modregxrm(2,xreg - XMM0,BPRM),FLfltreg,смещение);
        checkSetVex(last(), tym);
    }

    /*****************
     * Возвращает:
     *  code that pTail points to
     */
    code *last()
    {
        // g++ and clang++ complain about offsetof() because of the code::code() constructor.
        // return (code *)((сим *)pTail - offsetof(code, следщ));
        // So do our own.
        return cast(code *)(cast(проц *)pTail - (cast(ук)&(*pTail).следщ - cast(ук)*pTail));
    }

    /*************************************
     * Handy function to answer the question: who the heck is generating this piece of code?
     */
    static проц ccheck(code *cs)
    {
    //    if (cs.Iop == LEA && (cs.Irm & 0x3F) == 0x34 && cs.Isib == 7) *(сим*)0=0;
    //    if (cs.Iop == 0x31) *(сим*)0=0;
    //    if (cs.Irm == 0x3D) *(сим*)0=0;
    //    if (cs.Iop == LEA && cs.Irm == 0xCB) *(сим*)0=0;
    }
}
