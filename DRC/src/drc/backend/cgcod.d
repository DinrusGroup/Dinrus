/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1985-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/cgcod.d, backend/cgcod.d)
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/backend/cgcod.d
 */

module drc.backend.cgcod;

version = FRAMEPTR;

version (SCPP)
    version = COMPILE;
version (Dinrus)
    version = COMPILE;

version (COMPILE)
{

import cidrus;

import drc.backend.backend;
import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.code;
import drc.backend.cgcse;
import drc.backend.code_x86;
import drc.backend.codebuilder;
import drc.backend.dlist;
import drc.backend.dvec;
import drc.backend.melf;
import drc.backend.mem;
import drc.backend.el;
import drc.backend.exh;
import drc.backend.глоб2;
import drc.backend.obj;
import drc.backend.oper;
import drc.backend.outbuf;
import drc.backend.rtlsym;
import drc.backend.ty;
import drc.backend.тип;
import drc.backend.xmm;

import drc.backend.barray;

version (SCPP)
{
    import parser;
    import precomp;
}

/*extern (C++):*/



alias  extern(C)  цел function(ук, ук) _compare_fp_t;
extern(C) проц qsort(ук base, т_мера nmemb, т_мера size, _compare_fp_t compar);

version (Dinrus)
    const Dinrus = да;
else
    const Dinrus = нет;

проц dwarf_except_gentables(Funcsym *sfunc, бцел startoffset, бцел retoffset);
цел REGSIZE();

private бцел mask(бцел m) { return 1 << m; }



//{
бул floatreg;                  // !=0 if floating register is required

цел hasframe;                   // !=0 if this function has a stack frame
бул enforcealign;              // enforced stack alignment
targ_т_мера spoff;
targ_т_мера Foff;               // BP смещение of floating register
targ_т_мера CSoff;              // смещение of common sub Выражения
targ_т_мера NDPoff;             // смещение of saved 8087 registers
targ_т_мера pushoff;            // смещение of saved registers
бул pushoffuse;                // using pushoff
цел BPoff;                      // смещение from BP
цел EBPtoESP;                   // add to EBP смещение to get ESP смещение
LocalSection Para;              // section of function parameters
LocalSection Auto;              // section of automatics and registers
LocalSection Fast;              // section of fastpar
LocalSection EEStack;           // смещение of SCstack variables from ESP
LocalSection Alloca;            // данные for alloca() temporary

REGSAVE regsave;

CGstate cgstate;                // state of code generator

regm_t BYTEREGS = BYTEREGS_INIT;
regm_t ALLREGS = ALLREGS_INIT;


/************************************
 * # of bytes that SP is beyond BP.
 */

бцел stackpush;

цел stackchanged;               /* set to !=0 if any use of the stack
                                   other than accessing parameters. Used
                                   to see if we can address parameters
                                   with ESP rather than EBP.
                                 */
цел refparam;           // !=0 if we referenced any parameters
цел reflocal;           // !=0 if we referenced any locals
бул anyiasm;           // !=0 if any inline assembler
сим calledafunc;       // !=0 if we called a function
сим needframe;         // if да, then we will need the frame
                        // pointer (BP for the 8088)
сим gotref;            // !=0 if the GOTsym was referenced
бцел usednteh;              // if !=0, then используется NT exception handling
бул calledFinally;     // да if called a BC_finally block

/* Register contents    */
con_t regcon;

цел pass;                       // PASSxxxx

private Symbol *retsym;          // set to symbol that should be placed in
                                // register AX

/****************************
 * Register masks.
 */

regm_t msavereg;        // Mask of registers that we would like to save.
                        // they are temporaries (set by scodelem())
regm_t mfuncreg;        // Mask of registers preserved by a function

regm_t allregs;                // ALLREGS optionally including mBP

цел dfoidx;                     /* which block we are in                */

targ_т_мера     funcoffset;     // смещение of start of function
targ_т_мера     prolog_allocoffset;     // смещение past adj of stack allocation
targ_т_мера     startoffset;    // size of function entry code
targ_т_мера     retoffset;      /* смещение from start of func to ret code */
targ_т_мера     retsize;        /* size of function return              */

private regm_t lastretregs,last2retregs,last3retregs,last4retregs,last5retregs;

//}

/*********************************
 * Generate code for a function.
 * Note at the end of this routine mfuncreg will contain the mask
 * of registers not affected by the function. Some minor optimization
 * possibilities are here.
 * Параметры:
 *      sfunc = function to generate code for
 */

проц codgen(Symbol *sfunc)
{
    бул флаг;
    block *btry;

    // Register использование. If a bit is on, the corresponding register is live
    // in that basic block.

    //printf("codgen('%s')\n",funcsym_p.Sident.ptr);
    assert(sfunc == funcsym_p);
    assert(cseg == funcsym_p.Sseg);

    cgreg_init();
    CSE.initialize();
    tym_t functy = tybasic(sfunc.ty());
    cod3_initregs();
    allregs = ALLREGS;
    pass = PASSinitial;
    Alloca.init();
    anyiasm = 0;

    if (config.ehmethod == EHmethod.EH_DWARF)
    {
        /* The dwarf unwinder relies on the function epilog to exist
         */
        for (block* b = startblock; b; b = b.Bnext)
        {
            if (b.BC == BCexit)
                b.BC = BCret;
        }
    }

tryagain:
    debug
    if (debugr)
        printf("------------------ PASS%s -----------------\n",
            (pass == PASSinitial) ? "init".ptr : ((pass == PASSreg) ? "reg".ptr : "final".ptr));

    lastretregs = last2retregs = last3retregs = last4retregs = last5retregs = 0;

    // if no parameters, assume we don't need a stack frame
    needframe = 0;
    enforcealign = нет;
    gotref = 0;
    stackchanged = 0;
    stackpush = 0;
    refparam = 0;
    calledafunc = 0;
    retsym = null;

    cgstate.stackclean = 1;
    cgstate.funcarg.init();
    cgstate.funcargtos = ~0;
    cgstate.accessedTLS = нет;
    STACKALIGN = TARGET_STACKALIGN;

    regsave.сбрось();
    memset(global87.stack.ptr,0,global87.stack.sizeof);

    calledFinally = нет;
    usednteh = 0;

    static if (Dinrus && TARGET_WINDOS)
    {
        if (sfunc.Sfunc.Fflags3 & Fjmonitor)
            usednteh |= NTEHjmonitor;
    }
    else version (SCPP)
    {
        if (CPP)
        {
            if (config.exe == EX_WIN32 &&
                (sfunc.Stype.Tflags & TFemptyexc || sfunc.Stype.Texcspec))
                usednteh |= NTEHexcspec;
            except_reset();
        }
    }

    // Set on a trial basis, turning it off if anything might throw
    sfunc.Sfunc.Fflags3 |= Fnothrow;

    floatreg = нет;
    assert(global87.stackused == 0);             /* nobody in 8087 stack         */

    CSE.start();
    memset(&regcon,0,regcon.sizeof);
    regcon.cse.mval = regcon.cse.mops = 0;      // no common subs yet
    msavereg = 0;
    бцел nretblocks = 0;
    mfuncreg = fregsaved;               // so we can see which are используется
                                        // (bit is cleared each time
                                        //  we use one)
    for (block* b = startblock; b; b = b.Bnext)
    {
        memset(&b.Bregcon,0,b.Bregcon.sizeof);       // Clear out values in registers
        if (b.Belem)
            resetEcomsub(b.Belem);     // сбрось all the Ecomsubs
        if (b.BC == BCasm)
            anyiasm = 1;                // we have inline assembler
        if (b.BC == BCret || b.BC == BCretexp)
            nretblocks++;
    }

    if (!config.fulltypes || (config.flags4 & CFG4optimized))
    {
        regm_t noparams = 0;
        for (цел i = 0; i < globsym.top; i++)
        {
            Symbol *s = globsym.tab[i];
            s.Sflags &= ~SFLread;
            switch (s.Sclass)
            {
                case SCfastpar:
                case SCshadowreg:
                    regcon.парамы |= s.Spregm();
                    goto case SCparameter;

                case SCparameter:
                    if (s.Sfl == FLreg)
                        noparams |= s.Sregm;
                    break;

                default:
                    break;
            }
        }
        regcon.парамы &= ~noparams;
    }

    if (config.flags4 & CFG4optimized)
    {
        if (nretblocks == 0 &&                  // if no return blocks in function
            !(sfunc.ty() & mTYnaked))      // naked functions may have hidden veys of returning
            sfunc.Sflags |= SFLexit;       // mark function as never returning

        assert(dfo);

        cgreg_reset();
        for (dfoidx = 0; dfoidx < dfo.length; dfoidx++)
        {
            regcon.используется = msavereg | regcon.cse.mval;   // registers already in use
            block* b = dfo[dfoidx];
            blcodgen(b);                        // gen code in depth-first order
            //printf("b.Bregcon.используется = %s\n", regm_str(b.Bregcon.используется));
            cgreg_used(dfoidx, b.Bregcon.используется); // gather register используется information
        }
    }
    else
    {
        pass = PASSfinal;
        for (block* b = startblock; b; b = b.Bnext)
            blcodgen(b);                // generate the code for each block
    }
    regcon.immed.mval = 0;
    assert(!regcon.cse.mops);           // should have all been используется

    // See which variables we can put into registers
    if (pass != PASSfinal &&
        !anyiasm)                               // possible LEA or LES opcodes
    {
        allregs |= cod3_useBP();                // see if we can use EBP

        // If pic code, but EBX was never needed
        if (!(allregs & mask(PICREG)) && !gotref)
        {
            allregs |= mask(PICREG);            // EBX can now be используется
            cgreg_assign(retsym);
            pass = PASSreg;
        }
        else if (cgreg_assign(retsym))          // if we found some registers
            pass = PASSreg;
        else
            pass = PASSfinal;
        for (block* b = startblock; b; b = b.Bnext)
        {
            code_free(b.Bcode);
            b.Bcode = null;
        }
        goto tryagain;
    }
    cgreg_term();

    version (SCPP)
    {
        if (CPP)
            cgcod_eh();
    }

    // See if we need to enforce a particular stack alignment
    auto arr =[globsym.top];
    foreach (i; arr)
    {
        Symbol *s = globsym.tab[i];

        if (Symbol_Sisdead(s, anyiasm))
            continue;

        switch (s.Sclass)
        {
            case SCregister:
            case SCauto:
            case SCfastpar:
                if (s.Sfl == FLreg)
                    break;

                const sz = type_alignsize(s.Stype);
                if (sz > STACKALIGN && (I64 || config.exe == EX_OSX))
                {
                    STACKALIGN = sz;
                    enforcealign = да;
                }
                break;

            default:
                break;
        }
    }

    stackoffsets(1);            // compute addresses of stack variables
    cod5_prol_epi();            // see where to place prolog/epilog
    CSE.finish();               // compute addresses and sizes of CSE saves

    if (configv.addlinenumbers)
        objmod.номстр(sfunc.Sfunc.Fstartline,sfunc.Sseg,Offset(sfunc.Sseg));

    // Otherwise, jmp's to startblock will execute the prolog again
    assert(!startblock.Bpred);

    CodeBuilder cdbprolog; cdbprolog.ctor();
    prolog(cdbprolog);           // gen function start code
    code *cprolog = cdbprolog.finish();
    if (cprolog)
        pinholeopt(cprolog,null);       // optimize

    funcoffset = Offset(sfunc.Sseg);
    targ_т_мера coffset = Offset(sfunc.Sseg);

    if (eecontext.EEelem)
        genEEcode();

    for (block* b = startblock; b; b = b.Bnext)
    {
        // We couldn't do this before because localsize was unknown
        switch (b.BC)
        {
            case BCret:
                if (configv.addlinenumbers && b.Bsrcpos.Slinnum && !(sfunc.ty() & mTYnaked))
                {
                    CodeBuilder cdb; cdb.ctor();
                    cdb.приставь(b.Bcode);
                    cdb.genlinnum(b.Bsrcpos);
                    b.Bcode = cdb.finish();
                }
                goto case BCretexp;

            case BCretexp:
                epilog(b);
                break;

            default:
                if (b.Bflags & BFLepilog)
                    epilog(b);
                break;
        }
        assignaddr(b);                  // assign addresses
        pinholeopt(b.Bcode,b);         // do pinhole optimization
        if (b.Bflags & BFLprolog)      // do function prolog
        {
            startoffset = coffset + calcblksize(cprolog) - funcoffset;
            b.Bcode = cat(cprolog,b.Bcode);
        }
        cgsched_block(b);
        b.Bsize = calcblksize(b.Bcode);       // calculate block size
        if (b.Balign)
        {
            targ_т_мера u = b.Balign - 1;
            coffset = (coffset + u) & ~u;
        }
        b.Boffset = coffset;           /* смещение of this block         */
        coffset += b.Bsize;            /* смещение of following block    */
    }

    debug
    debugw && printf("code addr complete\n");

    // Do jump optimization
    do
    {
        флаг = нет;
        for (block* b = startblock; b; b = b.Bnext)
        {
            if (b.Bflags & BFLjmpoptdone)      /* if no more jmp opts for this blk */
                continue;
            цел i = branch(b,0);            // see if jmp => jmp short
            if (i)                          // if any bytes saved
            {   targ_т_мера смещение;

                b.Bsize -= i;
                смещение = b.Boffset + b.Bsize;
                for (block* bn = b.Bnext; bn; bn = bn.Bnext)
                {
                    if (bn.Balign)
                    {   targ_т_мера u = bn.Balign - 1;

                        смещение = (смещение + u) & ~u;
                    }
                    bn.Boffset = смещение;
                    смещение += bn.Bsize;
                }
                coffset = смещение;
                флаг = да;
            }
        }
        if (!I16 && !(config.flags4 & CFG4optimized))
            break;                      // use the long conditional jmps
    } while (флаг);                     // loop till no more bytes saved

    debug
    debugw && printf("code jump optimization complete\n");

    version (Dinrus)
    {
        if (usednteh & NTEH_try)
        {
            // Do this before code is emitted because we patch some instructions
            nteh_filltables();
        }
    }

    // Compute starting смещение for switch tables
    targ_т_мера swoffset;
    цел jmpseg = -1;
    if (config.flags & CFGromable)
    {
        jmpseg = 0;
        swoffset = coffset;
    }

    // Emit the generated code
    if (eecontext.EEcompile == 1)
    {
        codout(sfunc.Sseg,eecontext.EEcode);
        code_free(eecontext.EEcode);
        version (SCPP)
        {
            el_free(eecontext.EEelem);
        }
    }
    else
    {
        for (block* b = startblock; b; b = b.Bnext)
        {
            if (b.BC == BCjmptab || b.BC == BCswitch)
            {
                if (jmpseg == -1)
                {
                    jmpseg = objmod.jmpTableSegment(sfunc);
                    swoffset = Offset(jmpseg);
                }
                swoffset = _align(0,swoffset);
                b.Btableoffset = swoffset;     /* смещение of sw tab */
                swoffset += b.Btablesize;
            }
            jmpaddr(b.Bcode);          /* assign jump addresses        */

            debug
            if (debugc)
            {
                printf("Boffset = x%x, Bsize = x%x, Coffset = x%x\n",
                    cast(цел)b.Boffset,cast(цел)b.Bsize,cast(цел)Offset(sfunc.Sseg));
                if (b.Bcode)
                    printf( "First opcode of block is: %0x\n", b.Bcode.Iop );
            }

            if (b.Balign)
            {   бцел u = b.Balign;
                бцел nalign = (u - cast(бцел)Offset(sfunc.Sseg)) & (u - 1);

                cod3_align_bytes(sfunc.Sseg, nalign);
            }
            assert(b.Boffset == Offset(sfunc.Sseg));

            version (SCPP)
            {
                if (CPP && !(config.exe == EX_WIN32))
                {
                    //printf("b = %p, index = %d\n",b,b.Bindex);
                    //except_index_set(b.Bindex);

                    if (btry != b.Btry)
                    {
                        btry = b.Btry;
                        except_pair_setoffset(b,Offset(sfunc.Sseg) - funcoffset);
                    }
                    if (b.BC == BCtry)
                    {
                        btry = b;
                        except_pair_setoffset(b,Offset(sfunc.Sseg) - funcoffset);
                    }
                }
            }

            codout(sfunc.Sseg,b.Bcode);   // output code
        }
        if (coffset != Offset(sfunc.Sseg))
        {
            debug
            printf("coffset = %d, Offset(sfunc.Sseg) = %d\n",cast(цел)coffset,cast(цел)Offset(sfunc.Sseg));

            assert(0);
        }
        sfunc.Ssize = Offset(sfunc.Sseg) - funcoffset;    // size of function

        static if (NTEXCEPTIONS || Dinrus)
        {
            version (Dinrus)
                const nteh = usednteh & NTEH_try;
            else static if (NTEXCEPTIONS)
                const nteh = usednteh & NTEHcpp;
            else
                const nteh = да;
            if (nteh)
            {
                assert(!(config.flags & CFGromable));
                //printf("framehandleroffset = x%x, coffset = x%x\n",framehandleroffset,coffset);
                objmod.reftocodeseg(sfunc.Sseg,framehandleroffset,coffset);
            }
        }

        // Write out switch tables
        флаг = нет;                       // да if last active block was a ret
        for (block* b = startblock; b; b = b.Bnext)
        {
            switch (b.BC)
            {
                case BCjmptab:              /* if jump table                */
                    outjmptab(b);           /* пиши out jump table         */
                    goto Ldefault;

                case BCswitch:
                    outswitab(b);           /* пиши out switch table       */
                    goto Ldefault;

                case BCret:
                case BCretexp:
                    /* Compute смещение to return code from start of function */
                    retoffset = b.Boffset + b.Bsize - retsize - funcoffset;
                    version (Dinrus)
                    {
                        /* Add 3 bytes to retoffset in case we have an exception
                         * handler. THIS PROBABLY NEEDS TO BE IN ANOTHER SPOT BUT
                         * IT FIXES THE PROBLEM HERE AS WELL.
                         */
                        if (usednteh & NTEH_try)
                            retoffset += 3;
                    }
                    флаг = да;
                    break;

                default:
                Ldefault:
                    retoffset = b.Boffset + b.Bsize - funcoffset;
                    break;
            }
        }
        if (configv.addlinenumbers && !(sfunc.ty() & mTYnaked))
            /* put line number at end of function on the
               start of the last instruction
             */
            /* Instead, try смещение to cleanup code  */
            if (retoffset < sfunc.Ssize)
                objmod.номстр(sfunc.Sfunc.Fendline,sfunc.Sseg,funcoffset + retoffset);

        static if (TARGET_WINDOS && Dinrus)
        {
            if (config.exe == EX_WIN64)
                win64_pdata(sfunc);
        }

        static if (Dinrus)
        {
            if (usednteh & NTEH_try)
            {
                // Do this before code is emitted because we patch some instructions
                nteh_gentables(sfunc);
            }
            if (usednteh & EHtry &&             // saw BCtry or BC_try (test EHcleanup too?)
                config.ehmethod == EHmethod.EH_DM)
            {
                except_gentables();
            }
            if (config.ehmethod == EHmethod.EH_DWARF)
            {
                sfunc.Sfunc.Fstartblock = startblock;
                dwarf_except_gentables(sfunc, cast(бцел)startoffset, cast(бцел)retoffset);
                sfunc.Sfunc.Fstartblock = null;
            }
        }

        version (SCPP)
        {
            // Write out frame handler
            if (NTEXCEPTIONS && usednteh & NTEHcpp)
            {
                nteh_framehandler(sfunc, except_gentables());
            }
            else
            {
                if (NTEXCEPTIONS && usednteh & NTEH_try)
                {
                    nteh_gentables(sfunc);
                }
                else
                {
                    if (CPP)
                        except_gentables();
                }
            }
        }

        for (block* b = startblock; b; b = b.Bnext)
        {
            code_free(b.Bcode);
            b.Bcode = null;
        }
    }

    // Mask of regs saved
    // BUG: do interrupt functions save BP?
    sfunc.Sregsaved = (functy == TYifunc) ? cast(regm_t) mBP : (mfuncreg | fregsaved);

    debug
    if (global87.stackused != 0)
      printf("stackused = %d\n",global87.stackused);

    assert(global87.stackused == 0);             /* nobody in 8087 stack         */

    /* Clean up ndp save массив  */
    mem_free(global87.save);
    global87.save = null;
    global87.savetop = 0;
    global87.savemax = 0;
}

/*********************************************
 * Align sections on the stack.
 *  base        negative смещение of section from frame pointer
 *  alignment   alignment to use
 *  bias        difference between where frame pointer points and the STACKALIGNed
 *              part of the stack
 * Возвращает:
 *  base        revised downward so it is aligned
 */
targ_т_мера alignsection(targ_т_мера base, бцел alignment, цел bias)
{
    assert(cast(цел)base <= 0);
    if (alignment > STACKALIGN)
        alignment = STACKALIGN;
    if (alignment)
    {
        цел sz = cast(цел)(-base + bias);
        assert(sz >= 0);
        sz &= (alignment - 1);
        if (sz)
            base -= alignment - sz;
    }
    return base;
}

/*******************************
 * Generate code for a function start.
 * Input:
 *      Offset(cseg)         address of start of code
 *      Auto.alignment
 * Output:
 *      Offset(cseg)         adjusted for size of code generated
 *      EBPtoESP
 *      hasframe
 *      BPoff
 */
проц prolog(ref CodeBuilder cdb)
{
    бул enter;

    //printf("cod3.prolog() %s, needframe = %d, Auto.alignment = %d\n", funcsym_p.Sident, needframe, Auto.alignment);
    debug debugw && printf("funcstart()\n");
    regcon.immed.mval = 0;                      /* no values in registers yet   */
    version (FRAMEPTR)
        EBPtoESP = 0;
    else
        EBPtoESP = -REGSIZE;
    hasframe = 0;
    бул pushds = нет;
    BPoff = 0;
    бул pushalloc = нет;
    tym_t tyf = funcsym_p.ty();
    tym_t tym = tybasic(tyf);
    бцел farfunc = tyfarfunc(tym);

    // Special Intel 64 bit ABI prolog setup for variadic functions
    Symbol *sv64 = null;                        // set to __va_argsave
    if (I64 && variadic(funcsym_p.Stype))
    {
        /* The Intel 64 bit ABI scheme.
         * abi_sysV_amd64.pdf
         * Load arguments passed in registers into the varargs save area
         * so they can be accessed by va_arg().
         */
        /* Look for __va_argsave
         */
        for (SYMIDX si = 0; si < globsym.top; si++)
        {
            Symbol *s = globsym.tab[si];
            if (s.Sident[0] == '_' && strcmp(s.Sident.ptr, "__va_argsave") == 0)
            {
                if (!(s.Sflags & SFLdead))
                    sv64 = s;
                break;
            }
        }
    }

    if (config.flags & CFGalwaysframe ||
        funcsym_p.Sfunc.Fflags3 & Ffakeeh ||
        /* The exception stack unwinding mechanism relies on the EBP chain being intact,
         * so need frame if function can possibly throw
         */
        !(config.exe == EX_WIN32) && !(funcsym_p.Sfunc.Fflags3 & Fnothrow) ||
        cgstate.accessedTLS ||
        sv64
       )
        needframe = 1;

    CodeBuilder cdbx; cdbx.ctor();

Lagain:
    spoff = 0;
    сим guessneedframe = needframe;
    цел cfa_offset = 0;
//    if (needframe && config.exe & (EX_LINUX | EX_FREEBSD | EX_SOLARIS) && !(usednteh & (NTEH_try | NTEH_except | NTEHcpp | EHcleanup | EHtry | NTEHpassthru)))
//      usednteh |= NTEHpassthru;

    /* Compute BP offsets for variables on stack.
     * The organization is:
     *  Para.size    parameters
     * -------- stack is aligned to STACKALIGN
     *          seg of return addr      (if far function)
     *          IP of return addr
     *  BP.    caller's BP
     *          DS                      (if Windows prolog/epilog)
     *          exception handling context symbol
     *  Fast.size fastpar
     *  Auto.size    autos and regs
     *  regsave.off  any saved registers
     *  Foff    floating register
     *  Alloca.size  alloca temporary
     *  CSoff   common subs
     *  NDPoff  any 8087 saved registers
     *          monitor context record
     *          any saved registers
     */

    if (tym == TYifunc)
        Para.size = 26; // how is this number derived?
    else
    {
        version (FRAMEPTR)
        {
            Para.size = ((farfunc ? 2 : 1) + needframe) * REGSIZE;
            if (needframe)
                EBPtoESP = -REGSIZE;
        }
        else
            Para.size = ((farfunc ? 2 : 1) + 1) * REGSIZE;
    }

    /* The real reason for the FAST section is because the implementation of contracts
     * requires a consistent stack frame location for the 'this' pointer. But if varying
     * stuff in Auto.смещение causes different alignment for that section, the entire block can
     * shift around, causing a crash in the contracts.
     * Fortunately, the 'this' is always an SCfastpar, so we put the fastpar's in their
     * own FAST section, which is never aligned at a size bigger than REGSIZE, and so
     * its alignment never shifts around.
     * But more work needs to be done, see Bugzilla 9200. Really, each section should be aligned
     * individually rather than as a group.
     */
    Fast.size = 0;
    static if (NTEXCEPTIONS == 2)
    {
        Fast.size -= nteh_contextsym_size();
        version (Dinrus)
        {
            static if (TARGET_WINDOS)
            {
                if (funcsym_p.Sfunc.Fflags3 & Ffakeeh && nteh_contextsym_size() == 0)
                    Fast.size -= 5 * 4;
            }
        }
    }

    /* Despite what the коммент above says, aligning Fast section to size greater
     * than REGSIZE does not break contract implementation. Fast.смещение and
     * Fast.alignment must be the same for the overriding and
     * the overridden function, since they have the same parameters. Fast.size
     * must be the same because otherwise, contract inheritance wouldn't work
     * even if we didn't align Fast section to size greater than REGSIZE. Therefore,
     * the only way aligning the section could cause problems with contract
     * inheritance is if bias (declared below) differed for the overridden
     * and the overriding function.
     *
     * Bias depends on Para.size and needframe. The значение of Para.size depends on
     * whether the function is an interrupt handler and whether it is a farfunc.
     * DMD does not have _interrupt attribute and D does not make a distinction
     * between near and far functions, so Para.size should always be 2 * REGSIZE
     * for D.
     *
     * The значение of needframe depends on a глоб2 setting that is only set
     * during backend's initialization and on function флаг Ffakeeh. On Windows,
     * that флаг is always set for virtual functions, for which contracts are
     * defined and on other platforms, it is never set. Because of that
     * the значение of neadframe should always be the same for the overridden
     * and the overriding function, and so bias should be the same too.
     */

version (FRAMEPTR)
    цел bias = enforcealign ? 0 : cast(цел)(Para.size);
else
    цел bias = enforcealign ? 0 : cast(цел)(Para.size + (needframe ? 0 : REGSIZE));

    if (Fast.alignment < REGSIZE)
        Fast.alignment = REGSIZE;

    Fast.size = alignsection(Fast.size - Fast.смещение, Fast.alignment, bias);

    if (Auto.alignment < REGSIZE)
        Auto.alignment = REGSIZE;       // necessary because localsize must be REGSIZE aligned
    Auto.size = alignsection(Fast.size - Auto.смещение, Auto.alignment, bias);

    regsave.off = alignsection(Auto.size - regsave.top, regsave.alignment, bias);
    //printf("regsave.off = x%x, size = x%x, alignment = %x\n",
        //cast(цел)regsave.off, cast(цел)(regsave.top), cast(цел)regsave.alignment);

    if (floatreg)
    {
        бцел floatregsize = config.fpxmmregs || I32 ? 16 : DOUBLESIZE;
        Foff = alignsection(regsave.off - floatregsize, STACKALIGN, bias);
        //printf("Foff = x%x, size = x%x\n", cast(цел)Foff, cast(цел)floatregsize);
    }
    else
        Foff = regsave.off;

    Alloca.alignment = REGSIZE;
    Alloca.смещение = alignsection(Foff - Alloca.size, Alloca.alignment, bias);

    CSoff = alignsection(Alloca.смещение - CSE.size(), CSE.alignment(), bias);
    //printf("CSoff = x%x, size = x%x, alignment = %x\n",
        //cast(цел)CSoff, CSE.size(), cast(цел)CSE.alignment);

    NDPoff = alignsection(CSoff - global87.savetop * tysize(TYldouble), REGSIZE, bias);

    regm_t topush = fregsaved & ~mfuncreg;          // mask of registers that need saving
    pushoffuse = нет;
    pushoff = NDPoff;
    /* We don't keep track of all the pushes and pops in a function. Hence,
     * using POP REG to restore registers in the epilog doesn't work, because the Dwarf unwinder
     * won't be setting ESP correctly. With pushoffuse, the registers are restored
     * from EBP, which is kept track of properly.
     */
    if ((config.flags4 & CFG4speed || config.ehmethod == EHmethod.EH_DWARF) && (I32 || I64))
    {
        /* Instead of pushing the registers onto the stack one by one,
         * размести space in the stack frame and копируй/restore them there.
         */
        цел xmmtopush = numbitsset(topush & XMMREGS);   // XMM regs take 16 bytes
        цел gptopush = numbitsset(topush) - xmmtopush;  // general purpose registers to save
        if (NDPoff || xmmtopush || cgstate.funcarg.size)
        {
            pushoff = alignsection(pushoff - (gptopush * REGSIZE + xmmtopush * 16),
                    xmmtopush ? STACKALIGN : REGSIZE, bias);
            pushoffuse = да;          // tell others we're using this strategy
        }
    }

    //printf("Fast.size = x%x, Auto.size = x%x\n", (цел)Fast.size, (цел)Auto.size);

    cgstate.funcarg.alignment = cgstate.funcarg.size ? STACKALIGN : REGSIZE;
    cgstate.funcarg.смещение = alignsection(pushoff - cgstate.funcarg.size, cgstate.funcarg.alignment, bias);

    localsize = -cgstate.funcarg.смещение;

    //printf("Alloca.смещение = x%llx, cstop = x%llx, CSoff = x%llx, NDPoff = x%llx, localsize = x%llx\n",
        //(long long)Alloca.смещение, (long long)CSE.size(), (long long)CSoff, (long long)NDPoff, (long long)localsize);
    assert(cast(targ_ptrdiff_t)localsize >= 0);

    // Keep the stack aligned by 8 for any subsequent function calls
    if (!I16 && calledafunc &&
        (STACKALIGN >= 16 || config.flags4 & CFG4stackalign))
    {
        цел npush = numbitsset(topush);            // number of registers that need saving
        npush += numbitsset(topush & XMMREGS);     // XMM regs take 16 bytes, so count them twice
        if (pushoffuse)
            npush = 0;

        //printf("npush = %d Para.size = x%x needframe = %d localsize = x%x\n",
               //npush, Para.size, needframe, localsize);

        цел sz = cast(цел)(localsize + npush * REGSIZE);
        if (!enforcealign)
        {
            version (FRAMEPTR)
                sz += Para.size;
            else
                sz += Para.size + (needframe ? 0 : -REGSIZE);
        }
        if (sz & (STACKALIGN - 1))
            localsize += STACKALIGN - (sz & (STACKALIGN - 1));
    }
    cgstate.funcarg.смещение = -localsize;

    //printf("Foff x%02x Auto.size x%02x NDPoff x%02x CSoff x%02x Para.size x%02x localsize x%02x\n",
        //(цел)Foff,(цел)Auto.size,(цел)NDPoff,(цел)CSoff,(цел)Para.size,(цел)localsize);

    бцел xlocalsize = cast(бцел)localsize;    // amount to subtract from ESP to make room for locals

    if (tyf & mTYnaked)                 // if no prolog/epilog for function
    {
        hasframe = 1;
        return;
    }

    if (tym == TYifunc)
    {
        prolog_ifunc(cdbx,&tyf);
        hasframe = 1;
        cdb.приставь(cdbx);
        goto Lcont;
    }

    /* Determine if we need BP set up   */
    if (enforcealign)
    {
        // we need BP to сбрось the stack before return
        // otherwise the return address is lost
        needframe = 1;

    }
    else if (config.flags & CFGalwaysframe)
        needframe = 1;
    else
    {
        if (localsize)
        {
            if (I16 ||
                !(config.flags4 & CFG4speed) ||
                config.target_cpu < TARGET_Pentium ||
                farfunc ||
                config.flags & CFGstack ||
                xlocalsize >= 0x1000 ||
                (usednteh & (NTEH_try | NTEH_except | NTEHcpp | EHcleanup | EHtry | NTEHpassthru)) ||
                anyiasm ||
                Alloca.size
               )
                needframe = 1;
        }
        if (refparam && (anyiasm || I16))
            needframe = 1;
    }

    if (needframe)
    {
        assert(mfuncreg & mBP);         // shouldn't have используется mBP

        if (!guessneedframe)            // if guessed wrong
            goto Lagain;
    }

    if (I16 && config.wflags & WFwindows && farfunc)
    {
        prolog_16bit_windows_farfunc(cdbx, &tyf, &pushds);
        enter = нет;                  // don't use ENTER instruction
        hasframe = 1;                   // we have a stack frame
    }
    else if (needframe)                 // if variables or parameters
    {
        prolog_frame(cdbx, farfunc, &xlocalsize, &enter, &cfa_offset);
        hasframe = 1;
    }

    /* Align the stack if necessary */
    prolog_stackalign(cdbx);

    /* Subtract from stack pointer the size of the local stack frame
     */
    if (config.flags & CFGstack)        // if stack overflow check
    {
        prolog_frameadj(cdbx, tyf, xlocalsize, enter, &pushalloc);
        if (Alloca.size)
            prolog_setupalloca(cdbx);
    }
    else if (needframe)                      /* if variables or parameters   */
    {
        if (xlocalsize)                 /* if any stack смещение          */
        {
            prolog_frameadj(cdbx, tyf, xlocalsize, enter, &pushalloc);
            if (Alloca.size)
                prolog_setupalloca(cdbx);
        }
        else
            assert(Alloca.size == 0);
    }
    else if (xlocalsize)
    {
        assert(I32 || I64);
        prolog_frameadj2(cdbx, tyf, xlocalsize, &pushalloc);
        version (FRAMEPTR) { } else
            BPoff += REGSIZE;
    }
    else
        assert((localsize | Alloca.size) == 0 || (usednteh & NTEHjmonitor));
    EBPtoESP += xlocalsize;
    if (hasframe)
        EBPtoESP += REGSIZE;

    /* Win64 unwind needs the amount of code generated so far
     */
    if (config.exe == EX_WIN64)
    {
        code *c = cdbx.peek();
        pinholeopt(c, null);
        prolog_allocoffset = calcblksize(c);
    }

    version (SCPP)
    {
        /*  The idea is to generate trace for all functions if -Nc is not thrown.
         *  If -Nc is thrown, generate trace only for глоб2 COMDATs, because those
         *  are relevant to the FUNCTIONS инструкция in the linker .DEF файл.
         *  This same logic should be in epilog().
         */
        if (config.flags & CFGtrace &&
            (!(config.flags4 & CFG4allcomdat) ||
             funcsym_p.Sclass == SCcomdat ||
             funcsym_p.Sclass == SCglobal ||
             (config.flags2 & CFG2comdat && SymInline(funcsym_p))
            )
           )
        {
            бцел spalign = 0;
            цел sz = cast(цел)localsize;
            if (!enforcealign)
            {
                version (FRAMEPTR)
                    sz += Para.size;
                else
                    sz += Para.size + (needframe ? 0 : -REGSIZE);
            }
            if (STACKALIGN >= 16 && (sz & (STACKALIGN - 1)))
                spalign = STACKALIGN - (sz & (STACKALIGN - 1));

            if (spalign)
            {   /* This could be avoided by moving the function call to after the
                 * registers are saved. But I don't remember why the call is here
                 * and not there.
                 */
                cod3_stackadj(cdbx, spalign);
            }

            бцел regsaved;
            prolog_trace(cdbx, farfunc != 0, &regsaved);

            if (spalign)
                cod3_stackadj(cdbx, -spalign);
            useregs((ALLREGS | mBP | mES) & ~regsaved);
        }
    }

    version (Dinrus)
    {
        if (usednteh & NTEHjmonitor)
        {   Symbol *sthis;

            for (SYMIDX si = 0; 1; si++)
            {   assert(si < globsym.top);
                sthis = globsym.tab[si];
                if (strcmp(sthis.Sident.ptr,"this".ptr) == 0)
                    break;
            }
            nteh_monitor_prolog(cdbx,sthis);
            EBPtoESP += 3 * 4;
        }
    }

    cdb.приставь(cdbx);
    prolog_saveregs(cdb, topush, cfa_offset);

Lcont:

    if (config.exe == EX_WIN64)
    {
        if (variadic(funcsym_p.Stype))
            prolog_gen_win64_varargs(cdb);
        regm_t namedargs;
        prolog_loadparams(cdb, tyf, pushalloc, namedargs);
        return;
    }

    prolog_ifunc2(cdb, tyf, tym, pushds);

    static if (NTEXCEPTIONS == 2)
    {
        if (usednteh & NTEH_except)
            nteh_setsp(cdb, 0x89);            // MOV __context[EBP].esp,ESP
    }

    // Load register parameters off of the stack. Do not use
    // assignaddr(), as it will replace the stack reference with
    // the register!
    regm_t namedargs;
    prolog_loadparams(cdb, tyf, pushalloc, namedargs);

    if (sv64)
        prolog_genvarargs(cdb, sv64, namedargs);

    /* Alignment checks
     */
    //assert(Auto.alignment <= STACKALIGN);
    //assert(((Auto.size + Para.size + BPoff) & (Auto.alignment - 1)) == 0);
}

/************************************
 * Predicate for sorting auto symbols for qsort().
 * Возвращает:
 *      < 0     s1 goes farther from frame pointer
 *      > 0     s1 goes nearer the frame pointer
 *      = 0     no difference
 */

extern (C) цел
 autosort_cmp( проц *ps1,  проц *ps2)
{
    Symbol *s1 = *cast(Symbol **)ps1;
    Symbol *s2 = *cast(Symbol **)ps2;

    /* Largest align size goes furthest away from frame pointer,
     * so they get allocated first.
     */
    бцел alignsize1 = Symbol_Salignsize(s1);
    бцел alignsize2 = Symbol_Salignsize(s2);
    if (alignsize1 < alignsize2)
        return 1;
    else if (alignsize1 > alignsize2)
        return -1;

    /* move variables nearer the frame pointer that have higher Sweights
     * because addressing mode is fewer bytes. Grouping together high Sweight
     * variables also may put them in the same cache
     */
    if (s1.Sweight < s2.Sweight)
        return -1;
    else if (s1.Sweight > s2.Sweight)
        return 1;

    /* More:
     * 1. put static arrays nearest the frame pointer, so буфер overflows
     *    can't change other variable contents
     * 2. Do the coloring at the byte уровень to minimize stack использование
     */
    return 0;
}

/******************************
 * Compute offsets for remaining tmp, automatic and register variables
 * that did not make it into registers.
 * Input:
 *      flags   0: do estimate only
 *              1: final
 */
проц stackoffsets(цел flags)
{
    //printf("stackoffsets() %s\n", funcsym_p.Sident);

    Para.init();        // параметр смещение
    Fast.init();        // SCfastpar смещение
    Auto.init();        // automatic & register смещение
    EEStack.init();     // for SCstack's

    // Set if doing optimization of auto layout
    бул doAutoOpt = flags && config.flags4 & CFG4optimized;

    // Put autos in another массив so we can do optimizations on the stack layout
    Symbol*[10] autotmp;
    Symbol **autos = null;
    if (doAutoOpt)
    {
        if (globsym.top <= autotmp.length)
            autos = autotmp.ptr;
        else
        {   autos = cast(Symbol **)malloc(globsym.top * (*autos).sizeof);
            assert(autos);
        }
    }
    т_мера autosi = 0;  // number используется in autos[]

    for (цел si = 0; si < globsym.top; si++)
    {   Symbol *s = globsym.tab[si];

        /* Don't размести space for dead or нуль size parameters
         */
        switch (s.Sclass)
        {
            case SCfastpar:
                if (!(funcsym_p.Sfunc.Fflags3 & Ffakeeh))
                    goto Ldefault;   // don't need consistent stack frame
                break;

            case SCparameter:
                if (type_zeroSize(s.Stype, tybasic(funcsym_p.Stype.Tty)))
                {
                    Para.смещение = _align(REGSIZE,Para.смещение); // align on word stack boundary
                    s.Soffset = Para.смещение;
                    continue;
                }
                break;          // размести even if it's dead

            case SCshadowreg:
                break;          // размести even if it's dead

            default:
            Ldefault:
                if (Symbol_Sisdead(s, anyiasm))
                    continue;       // don't размести space
                break;
        }

        targ_т_мера sz = type_size(s.Stype);
        if (sz == 0)
            sz++;               // can't handle 0 length structs

        бцел alignsize = Symbol_Salignsize(s);
        if (alignsize > STACKALIGN)
            alignsize = STACKALIGN;         // no point if the stack is less aligned

        //printf("symbol '%s', size = x%lx, alignsize = %d, читай = %x\n",s.Sident,(long)sz, (цел)alignsize, s.Sflags & SFLread);
        assert(cast(цел)sz >= 0);

        switch (s.Sclass)
        {
            case SCfastpar:
                /* Get these
                 * right следщ to the stack frame pointer, EBP.
                 * Needed so we can call nested contract functions
                 * frequire and fensure.
                 */
                if (s.Sfl == FLreg)        // if allocated in register
                    continue;
                /* Needed because storing fastpar's on the stack in prolog()
                 * does the entire register
                 */
                if (sz < REGSIZE)
                    sz = REGSIZE;

                Fast.смещение = _align(sz,Fast.смещение);
                s.Soffset = Fast.смещение;
                Fast.смещение += sz;
                //printf("fastpar '%s' sz = %d, fast смещение =  x%x, %p\n",s.Sident,(цел)sz,(цел)s.Soffset, s);

                if (alignsize > Fast.alignment)
                    Fast.alignment = alignsize;
                break;

            case SCregister:
            case SCauto:
                if (s.Sfl == FLreg)        // if allocated in register
                    break;

                if (doAutoOpt)
                {   autos[autosi++] = s;    // deal with later
                    break;
                }

                Auto.смещение = _align(sz,Auto.смещение);
                s.Soffset = Auto.смещение;
                Auto.смещение += sz;
                //printf("auto    '%s' sz = %d, auto смещение =  x%lx\n",s.Sident,sz,(long)s.Soffset);

                if (alignsize > Auto.alignment)
                    Auto.alignment = alignsize;
                break;

            case SCstack:
                EEStack.смещение = _align(sz,EEStack.смещение);
                s.Soffset = EEStack.смещение;
                //printf("EEStack.смещение =  x%lx\n",(long)s.Soffset);
                EEStack.смещение += sz;
                break;

            case SCshadowreg:
            case SCparameter:
                if (config.exe == EX_WIN64)
                {
                    assert((Para.смещение & 7) == 0);
                    s.Soffset = Para.смещение;
                    Para.смещение += 8;
                    break;
                }
                /* Alignment on OSX 32 is odd. reals are 16 byte aligned in general,
                 * but are 4 byte aligned on the OSX 32 stack.
                 */
                Para.смещение = _align(REGSIZE,Para.смещение); /* align on word stack boundary */
                if (alignsize >= 16 &&
                    (I64 || (config.exe == EX_OSX &&
                         (tyaggregate(s.ty()) || tyvector(s.ty())))))
                    Para.смещение = (Para.смещение + (alignsize - 1)) & ~(alignsize - 1);
                s.Soffset = Para.смещение;
                //printf("%s param смещение =  x%lx, alignsize = %d\n",s.Sident,(long)s.Soffset, (цел)alignsize);
                Para.смещение += (s.Sflags & SFLdouble)
                            ? type_size(tstypes[TYdouble])   // float passed as double
                            : type_size(s.Stype);
                break;

            case SCpseudo:
            case SCstatic:
            case SCbprel:
                break;
            default:
                symbol_print(s);
                assert(0);
        }
    }

    if (autosi)
    {
        qsort(autos, autosi, (Symbol *).sizeof, &autosort_cmp);

        vec_t tbl = vec_calloc(autosi);

        for (т_мера si = 0; si < autosi; si++)
        {
            Symbol *s = autos[si];

            targ_т_мера sz = type_size(s.Stype);
            if (sz == 0)
                sz++;               // can't handle 0 length structs

            бцел alignsize = Symbol_Salignsize(s);
            if (alignsize > STACKALIGN)
                alignsize = STACKALIGN;         // no point if the stack is less aligned

            /* See if we can share storage with another variable
             * if their live ranges do not overlap.
             */
            if (// Don't share because could stomp on variables
                // используется in finally blocks
                !(usednteh & (NTEH_try | NTEH_except | NTEHcpp | EHcleanup | EHtry | NTEHpassthru)) &&
                s.Srange && !(s.Sflags & SFLspill))
            {
                for (т_мера i = 0; i < si; i++)
                {
                    if (!vec_testbit(i,tbl))
                        continue;
                    Symbol *sp = autos[i];
//printf("auto    s = '%s', sp = '%s', %d, %d, %d\n",s.Sident,sp.Sident,dfo.length,vec_numbits(s.Srange),vec_numbits(sp.Srange));
                    if (vec_disjoint(s.Srange,sp.Srange) &&
                        !(sp.Soffset & (alignsize - 1)) &&
                        sz <= type_size(sp.Stype))
                    {
                        vec_or(sp.Srange,sp.Srange,s.Srange);
                        //printf("sharing space - '%s' onto '%s'\n",s.Sident,sp.Sident);
                        s.Soffset = sp.Soffset;
                        goto L2;
                    }
                }
            }
            Auto.смещение = _align(sz,Auto.смещение);
            s.Soffset = Auto.смещение;
            //printf("auto    '%s' sz = %d, auto смещение =  x%lx\n",s.Sident,sz,(long)s.Soffset);
            Auto.смещение += sz;
            if (s.Srange && !(s.Sflags & SFLspill))
                vec_setbit(si,tbl);

            if (alignsize > Auto.alignment)
                Auto.alignment = alignsize;
        L2: { }
        }

        vec_free(tbl);

        if (autos != autotmp.ptr)
            free(autos);
    }
}

/****************************
 * Generate code for a block.
 */

private проц blcodgen(block *bl)
{
    regm_t mfuncregsave = mfuncreg;

    //dbg_printf("blcodgen(%p)\n",bl);

    /* Determine existing immediate values in registers by ANDing
        together the values from all the predecessors of b.
     */
    assert(bl.Bregcon.immed.mval == 0);
    regcon.immed.mval = 0;      // assume no previous contents in registers
//    regcon.cse.mval = 0;
    foreach (bpl; ListRange(bl.Bpred))
    {
        block *bp = list_block(bpl);

        if (bpl == bl.Bpred)
        {   regcon.immed = bp.Bregcon.immed;
            regcon.парамы = bp.Bregcon.парамы;
//          regcon.cse = bp.Bregcon.cse;
        }
        else
        {
            цел i;

            regcon.парамы &= bp.Bregcon.парамы;
            if ((regcon.immed.mval &= bp.Bregcon.immed.mval) != 0)
                // Actual values must match, too
                for (i = 0; i < REGMAX; i++)
                {
                    if (regcon.immed.значение[i] != bp.Bregcon.immed.значение[i])
                        regcon.immed.mval &= ~mask(i);
                }
        }
    }
    regcon.cse.mops &= regcon.cse.mval;

    // Set regcon.mvar according to what variables are in registers for this block
    CodeBuilder cdb; cdb.ctor();
    regcon.mvar = 0;
    regcon.mpvar = 0;
    regcon.indexregs = 1;
    цел anyspill = 0;
    сим *sflsave = null;
    if (config.flags4 & CFG4optimized)
    {
        CodeBuilder cdbload; cdbload.ctor();
        CodeBuilder cdbstore; cdbstore.ctor();

        sflsave = cast(сим *) alloca(globsym.top * сим.sizeof);
        for (SYMIDX i = 0; i < globsym.top; i++)
        {
            Symbol *s = globsym.tab[i];

            sflsave[i] = s.Sfl;
            if (regParamInPreg(s) &&
                regcon.парамы & s.Spregm() &&
                vec_testbit(dfoidx,s.Srange))
            {
//                regcon.используется |= s.Spregm();
            }

            if (s.Sfl == FLreg)
            {
                if (vec_testbit(dfoidx,s.Srange))
                {
                    regcon.mvar |= s.Sregm;
                    if (s.Sclass == SCfastpar || s.Sclass == SCshadowreg)
                        regcon.mpvar |= s.Sregm;
                }
            }
            else if (s.Sflags & SFLspill)
            {
                if (vec_testbit(dfoidx,s.Srange))
                {
                    anyspill = i + 1;
                    cgreg_spillreg_prolog(bl,s,cdbstore,cdbload);
                    if (vec_testbit(dfoidx,s.Slvreg))
                    {
                        s.Sfl = FLreg;
                        regcon.mvar |= s.Sregm;
                        regcon.cse.mval &= ~s.Sregm;
                        regcon.immed.mval &= ~s.Sregm;
                        regcon.парамы &= ~s.Sregm;
                        if (s.Sclass == SCfastpar || s.Sclass == SCshadowreg)
                            regcon.mpvar |= s.Sregm;
                    }
                }
            }
        }
        if ((regcon.cse.mops & regcon.cse.mval) != regcon.cse.mops)
        {
            cse_save(cdb,regcon.cse.mops & ~regcon.cse.mval);
        }
        cdb.приставь(cdbstore);
        cdb.приставь(cdbload);
        mfuncreg &= ~regcon.mvar;               // use these registers
        regcon.используется |= regcon.mvar;

        // Determine if we have more than 1 uncommitted index register
        regcon.indexregs = IDXREGS & ~regcon.mvar;
        regcon.indexregs &= regcon.indexregs - 1;
    }

    /* This doesn't work when calling the BC_finally function,
     * as it is one block calling another.
     */
    //regsave.idx = 0;

    reflocal = 0;
    цел refparamsave = refparam;
    refparam = 0;
    assert((regcon.cse.mops & regcon.cse.mval) == regcon.cse.mops);

    outblkexitcode(cdb, bl, anyspill, sflsave, &retsym, mfuncregsave);
    bl.Bcode = cdb.finish();

    for (цел i = 0; i < anyspill; i++)
    {
        Symbol *s = globsym.tab[i];
        s.Sfl = sflsave[i];    // undo block register assignments
    }

    if (reflocal)
        bl.Bflags |= BFLreflocal;
    if (refparam)
        bl.Bflags |= BFLrefparam;
    refparam |= refparamsave;
    bl.Bregcon.immed = regcon.immed;
    bl.Bregcon.cse = regcon.cse;
    bl.Bregcon.используется = regcon.используется;
    bl.Bregcon.парамы = regcon.парамы;

    debug
    debugw && printf("code gen complete\n");
}

/*****************************************
 * Add in exception handling code.
 */

version (SCPP)
{

private проц cgcod_eh()
{
    list_t stack;
    цел idx;
    цел tryidx;

    if (!(usednteh & (EHtry | EHcleanup)))
        return;

    // Compute Bindex for each block
    for (block *b = startblock; b; b = b.Bnext)
    {
        b.Bindex = -1;
        b.Bflags &= ~BFLvisited;               /* mark as unvisited    */
    }
    block *btry = null;
    цел lastidx = 0;
    startblock.Bindex = 0;
    for (block *b = startblock; b; b = b.Bnext)
    {
        if (btry == b.Btry && b.BC == BCcatch)  // if don't need to вынь try block
        {
            block *br = list_block(b.Bpred);          // найди corresponding try block
            assert(br.BC == BCtry);
            b.Bindex = br.Bindex;
        }
        else if (btry != b.Btry && b.BC != BCcatch ||
                 !(b.Bflags & BFLvisited))
            b.Bindex = lastidx;
        b.Bflags |= BFLvisited;

        debug
        if (debuge)
        {
            WRBC(b.BC);
            printf(" block (%p) Btry=%p Bindex=%d\n",b,b.Btry,b.Bindex);
        }

        except_index_set(b.Bindex);
        if (btry != b.Btry)                    // exited previous try block
        {
            except_pop(b,null,btry);
            btry = b.Btry;
        }
        if (b.BC == BCtry)
        {
            except_push(b,null,b);
            btry = b;
            tryidx = except_index_get();
            CodeBuilder cdb; cdb.ctor();
            nteh_gensindex(cdb,tryidx - 1);
            cdb.приставь(b.Bcode);
            b.Bcode = cdb.finish();
        }

        stack = null;
        for (code *c = b.Bcode; c; c = code_next(c))
        {
            if ((c.Iop & ESCAPEmask) == ESCAPE)
            {
                code *c1 = null;
                switch (c.Iop & 0xFFFF00)
                {
                    case ESCctor:
                        //printf("ESCctor\n");
                        except_push(c,c.IEV1.Vtor,null);
                        goto L1;

                    case ESCdtor:
                        //printf("ESCdtor\n");
                        except_pop(c,c.IEV1.Vtor,null);
                    L1: if (config.exe == EX_WIN32)
                        {
                            CodeBuilder cdb; cdb.ctor();
                            nteh_gensindex(cdb,except_index_get() - 1);
                            c1 = cdb.finish();
                            c1.следщ = code_next(c);
                            c.следщ = c1;
                        }
                        break;

                    case ESCmark:
                        //printf("ESCmark\n");
                        idx = except_index_get();
                        list_prependdata(&stack,idx);
                        except_mark();
                        break;

                    case ESCrelease:
                        //printf("ESCrelease\n");
                        version (SCPP)
                        {
                            idx = list_data(stack);
                            list_pop(&stack);
                            if (idx != except_index_get())
                            {
                                if (config.exe == EX_WIN32)
                                {
                                    CodeBuilder cdb; cdb.ctor();
                                    nteh_gensindex(cdb,idx - 1);
                                    c1 = cdb.finish();
                                    c1.следщ = code_next(c);
                                    c.следщ = c1;
                                }
                                else
                                {   except_pair_append(c,idx - 1);
                                    c.Iop = ESCAPE | ESCoffset;
                                }
                            }
                            except_release();
                        }
                        break;

                    case ESCmark2:
                        //printf("ESCmark2\n");
                        except_mark();
                        break;

                    case ESCrelease2:
                        //printf("ESCrelease2\n");
                        version (SCPP)
                        {
                            except_release();
                        }
                        break;

                    default:
                        break;
                }
            }
        }
        assert(stack == null);
        b.Bendindex = except_index_get();

        if (b.BC != BCret && b.BC != BCretexp)
            lastidx = b.Bendindex;

        // Set starting index for each of the successors
        цел i = 0;
        foreach (bl; ListRange(b.Bsucc))
        {
            block *bs = list_block(bl);
            if (b.BC == BCtry)
            {
                switch (i)
                {
                    case 0:                             // block after catches
                        bs.Bindex = b.Bendindex;
                        break;

                    case 1:                             // 1st catch block
                        bs.Bindex = tryidx;
                        break;

                    default:                            // subsequent catch blocks
                        bs.Bindex = b.Bindex;
                        break;
                }

                debug
                if (debuge)
                {
                    printf(" 1setting %p to %d\n",bs,bs.Bindex);
                }
            }
            else if (!(bs.Bflags & BFLvisited))
            {
                bs.Bindex = b.Bendindex;

                debug
                if (debuge)
                {
                    printf(" 2setting %p to %d\n",bs,bs.Bindex);
                }
            }
            bs.Bflags |= BFLvisited;
            i++;
        }
    }

    if (config.exe == EX_WIN32)
        for (block *b = startblock; b; b = b.Bnext)
        {
            if (/*!b.Bcount ||*/ b.BC == BCtry)
                continue;
            foreach (bl; ListRange(b.Bpred))
            {
                цел pi = list_block(bl).Bendindex;
                if (b.Bindex != pi)
                {
                    CodeBuilder cdb; cdb.ctor();
                    nteh_gensindex(cdb,b.Bindex - 1);
                    cdb.приставь(b.Bcode);
                    b.Bcode = cdb.finish();
                    break;
                }
            }
        }
}

}

/******************************
 * Count the number of bits set in a register mask.
 */

цел numbitsset(regm_t regm)
{
    цел n = 0;
    if (regm)
        do
            n++;
        while ((regm &= regm - 1) != 0);
    return n;
}

/******************************
 * Given a register mask, найди and return the number
 * of the first register that fits.
 */

reg_t findreg(regm_t regm)
{
    return findreg(regm, __LINE__, __FILE__);
}

reg_t findreg(regm_t regm, цел line, ткст0 файл)
{
    debug
    regm_t regmsave = regm;

    reg_t i = 0;
    while (1)
    {
        if (!(regm & 0xF))
        {
            regm >>= 4;
            i += 4;
            if (!regm)
                break;
        }
        if (regm & 1)
            return i;
        regm >>= 1;
        i++;
    }

    debug
    printf("findreg(%s, line=%d, файл='%s', function = '%s')\n",regm_str(regmsave),line,файл,funcsym_p.Sident.ptr);
    fflush(stdout);

//    *(сим*)0=0;
    assert(0);
}

/***************
 * Free element (but not it's leaves! (assume they are already freed))
 * Don't decrement Ecount! This is so we can detect if the common subexp
 * has already been evaluated.
 * If common subВыражение is not required anymore, eliminate
 * references to it.
 */

проц freenode(elem *e)
{
    elem_debug(e);
    //dbg_printf("freenode(%p) : comsub = %d, count = %d\n",e,e.Ecomsub,e.Ecount);
    if (e.Ecomsub--) return;             /* использование count                  */
    if (e.Ecount)                        /* if it was a CSE              */
    {
        for (т_мера i = 0; i < regcon.cse.значение.length; i++)
        {
            if (regcon.cse.значение[i] == e)       /* if a register is holding it  */
            {
                regcon.cse.mval &= ~mask(cast(бцел)i);
                regcon.cse.mops &= ~mask(cast(бцел)i);    /* free masks                   */
            }
        }
        CSE.удали(e);
    }
}

/*********************************
 * Reset Ecomsub for all elem nodes, i.e. reverse the effects of freenode().
 */

private проц resetEcomsub(elem *e)
{
    while (1)
    {
        elem_debug(e);
        e.Ecomsub = e.Ecount;
        const op = e.Eoper;
        if (!OTleaf(op))
        {
            if (OTbinary(op))
                resetEcomsub(e.EV.E2);
            e = e.EV.E1;
        }
        else
            break;
    }
}

/*********************************
 * Determine if elem e is a register variable.
 * If so:
 *      *pregm = mask of registers that make up the variable
 *      *preg = the least significant register
 *      returns да
 * Else
 *      returns нет
 */

цел isregvar(elem *e,regm_t *pregm,reg_t *preg)
{
    Symbol *s;
    бцел u;
    regm_t m;
    regm_t regm;
    reg_t reg;

    elem_debug(e);
    if (e.Eoper == OPvar || e.Eoper == OPrelconst)
    {
        s = e.EV.Vsym;
        switch (s.Sfl)
        {
            case FLreg:
                if (s.Sclass == SCparameter)
                {   refparam = да;
                    reflocal = да;
                }
                reg = e.EV.Voffset == REGSIZE ? s.Sregmsw : s.Sreglsw;
                regm = s.Sregm;
                //assert(tyreg(s.ty()));
static if (0)
{
                // Let's just see if there is a CSE in a reg we can use
                // instead. This helps avoid AGI's.
                if (e.Ecount && e.Ecount != e.Ecomsub)
                {   цел i;

                    for (i = 0; i < arraysize(regcon.cse.значение); i++)
                    {
                        if (regcon.cse.значение[i] == e)
                        {   reg = i;
                            break;
                        }
                    }
                }
}
                assert(regm & regcon.mvar && !(regm & ~regcon.mvar));
                goto Lreg;

            case FLpseudo:
                version (Dinrus)
                {
                    u = s.Sreglsw;
                    m = mask(u);
                    if (m & ALLREGS && (u & ~3) != 4) // if not BP,SP,EBP,ESP,or ?H
                    {
                        reg = u & 7;
                        regm = m;
                        goto Lreg;
                    }
                }
                else
                {
                    u = s.Sreglsw;
                    m = pseudomask[u];
                    if (m & ALLREGS && (u & ~3) != 4) // if not BP,SP,EBP,ESP,or ?H
                    {
                        reg = pseudoreg[u] & 7;
                        regm = m;
                        goto Lreg;
                    }
                }
                break;

            default:
                break;
        }
    }
    return нет;

Lreg:
    if (preg)
        *preg = reg;
    if (pregm)
        *pregm = regm;
    return да;
}

/*********************************
 * Allocate some registers.
 * Input:
 *      pretregs        Pointer to mask of registers to make selection from.
 *      tym             Mask of тип we will store in registers.
 * Output:
 *      *pretregs       Mask of allocated registers.
 *      *preg           Register number of first allocated register.
 *      msavereg,mfuncreg       retregs bits are cleared.
 *      regcon.cse.mval,regcon.cse.mops updated
 * Возвращает:
 *      pointer to code generated if necessary to save any regcon.cse.mops on the
 *      stack.
 */

проц allocreg(ref CodeBuilder cdb,regm_t *pretregs,reg_t *preg,tym_t tym)
{
    allocreg(cdb, pretregs, preg, tym, __LINE__, __FILE__);
}

проц allocreg(ref CodeBuilder cdb,regm_t *pretregs,reg_t *preg,tym_t tym
        ,цел line,ткст0 файл)
{
        reg_t reg;

static if (0)
{
        if (pass == PASSfinal)
        {
            printf("allocreg %s,%d: regcon.mvar %s regcon.cse.mval %s msavereg %s *pretregs %s tym ",
                файл,line,regm_str(regcon.mvar),regm_str(regcon.cse.mval),
                regm_str(msavereg),regm_str(*pretregs));
            WRTYxx(tym);
            dbg_printf("\n");
        }
}
        tym = tybasic(tym);
        бцел size = _tysize[tym];
        *pretregs &= mES | allregs | XMMREGS;
        regm_t retregs = *pretregs;

        debug if (retregs == 0)
            printf("allocreg: файл %s(%d)\n", файл, line);

        if ((retregs & regcon.mvar) == retregs) // if exactly in reg vars
        {
            if (size <= REGSIZE || (retregs & XMMREGS))
            {
                *preg = findreg(retregs);
                assert(retregs == mask(*preg)); /* no more bits are set */
            }
            else if (size <= 2 * REGSIZE)
            {
                *preg = findregmsw(retregs);
                assert(retregs & mLSW);
            }
            else
                assert(0);
            getregs(cdb,retregs);
            return;
        }
        цел count = 0;
L1:
        //printf("L1: allregs = %s, *pretregs = %s\n", regm_str(allregs), regm_str(*pretregs));
        assert(++count < 20);           /* fail instead of hanging if blocked */
        assert(retregs);
        reg_t msreg = NOREG, lsreg = NOREG;  /* no значение assigned yet        */
L3:
        //printf("L2: allregs = %s, *pretregs = %s\n", regm_str(allregs), regm_str(*pretregs));
        regm_t r = retregs & ~(msavereg | regcon.cse.mval | regcon.парамы);
        if (!r)
        {
            r = retregs & ~(msavereg | regcon.cse.mval);
            if (!r)
            {
                r = retregs & ~(msavereg | regcon.cse.mops);
                if (!r)
                {   r = retregs & ~msavereg;
                    if (!r)
                        r = retregs;
                }
            }
        }

        if (size <= REGSIZE || retregs & XMMREGS)
        {
            if (r & ~mBP)
                r &= ~mBP;

            // If only one index register, prefer to not use LSW registers
            if (!regcon.indexregs && r & ~mLSW)
                r &= ~mLSW;

            if (pass == PASSfinal && r & ~lastretregs && !I16)
            {   // Try not to always размести the same register,
                // to schedule better

                r &= ~lastretregs;
                if (r & ~last2retregs)
                {
                    r &= ~last2retregs;
                    if (r & ~last3retregs)
                    {
                        r &= ~last3retregs;
                        if (r & ~last4retregs)
                        {
                            r &= ~last4retregs;
//                          if (r & ~last5retregs)
//                              r &= ~last5retregs;
                        }
                    }
                }
                if (r & ~mfuncreg)
                    r &= ~mfuncreg;
            }
            reg = findreg(r);
            retregs = mask(reg);
        }
        else if (size <= 2 * REGSIZE)
        {
            /* Select pair with both regs free. Failing */
            /* that, select pair with one reg free.             */

            if (r & mBP)
            {
                retregs &= ~mBP;
                goto L3;
            }

            if (r & mMSW)
            {
                if (r & mDX)
                    msreg = DX;                 /* prefer to use DX over CX */
                else
                    msreg = findregmsw(r);
                r &= mLSW;                      /* see if there's an LSW also */
                if (r)
                    lsreg = findreg(r);
                else if (lsreg == NOREG)   /* if don't have LSW yet */
                {
                    retregs &= mLSW;
                    goto L3;
                }
            }
            else
            {
                if (I64 && !(r & mLSW))
                {
                    retregs = *pretregs & (mMSW | mLSW);
                    assert(retregs);
                    goto L1;
                }
                lsreg = findreglsw(r);
                if (msreg == NOREG)
                {
                    retregs &= mMSW;
                    assert(retregs);
                    goto L3;
                }
            }
            reg = (msreg == ES) ? lsreg : msreg;
            retregs = mask(msreg) | mask(lsreg);
        }
        else if (I16 && (tym == TYdouble || tym == TYdouble_alias))
        {
            debug
            if (retregs != DOUBLEREGS)
                printf("retregs = %s, *pretregs = %s\n", regm_str(retregs), regm_str(*pretregs));

            assert(retregs == DOUBLEREGS);
            reg = AX;
        }
        else
        {
            debug
            {
                WRTYxx(tym);
                printf("\nallocreg: fil %s lin %d, regcon.mvar %s msavereg %s *pretregs %s, reg %d, tym x%x\n",
                    файл,line,regm_str(regcon.mvar),regm_str(msavereg),regm_str(*pretregs),*preg,tym);
            }
            assert(0);
        }
        if (retregs & regcon.mvar)              // if conflict with reg vars
        {
            if (!(size > REGSIZE && *pretregs == (mAX | mDX)))
            {
                retregs = (*pretregs &= ~(retregs & regcon.mvar));
                goto L1;                // try other registers
            }
        }
        *preg = reg;
        *pretregs = retregs;

        //printf("Allocating %s\n",regm_str(retregs));
        last5retregs = last4retregs;
        last4retregs = last3retregs;
        last3retregs = last2retregs;
        last2retregs = lastretregs;
        lastretregs = retregs;
        getregs(cdb, retregs);
}

/******************************
 * Determine registers that should be destroyed upon arrival
 * to code entry point for exception handling.
 */
regm_t lpadregs()
{
    regm_t используется;
    if (config.ehmethod == EHmethod.EH_DWARF)
        используется = allregs & ~mfuncreg;
    else
        используется = (I32 | I64) ? allregs : (ALLREGS | mES);
    //printf("lpadregs(): используется=%s, allregs=%s, mfuncreg=%s\n", regm_str(используется), regm_str(allregs), regm_str(mfuncreg));
    return используется;
}


/*************************
 * Mark registers as используется.
 */

проц useregs(regm_t regm)
{
    //printf("useregs(x%x) %s\n", regm, regm_str(regm));
    mfuncreg &= ~regm;
    regcon.используется |= regm;                // registers используется in this block
    regcon.парамы &= ~regm;
    if (regm & regcon.mpvar)            // if modified a fastpar register variable
        regcon.парамы = 0;              // toss them all out
}

/*************************
 * We are going to use the registers in mask r.
 * Generate any code necessary to save any regs.
 */

проц getregs(ref CodeBuilder cdb, regm_t r)
{
    //printf("getregs(x%x) %s\n", r, regm_str(r));
    regm_t ms = r & regcon.cse.mops;           // mask of common subs we must save
    useregs(r);
    regcon.cse.mval &= ~r;
    msavereg &= ~r;                     // regs that are destroyed
    regcon.immed.mval &= ~r;
    if (ms)
        cse_save(cdb, ms);
}

/*************************
 * We are going to use the registers in mask r.
 * Same as getregs(), but assert if code is needed to be generated.
 */
проц getregsNoSave(regm_t r)
{
    //printf("getregsNoSave(x%x) %s\n", r, regm_str(r));
    assert(!(r & regcon.cse.mops));            // mask of common subs we must save
    useregs(r);
    regcon.cse.mval &= ~r;
    msavereg &= ~r;                     // regs that are destroyed
    regcon.immed.mval &= ~r;
}

/*****************************************
 * Copy registers in cse.mops into memory.
 */

private проц cse_save(ref CodeBuilder cdb, regm_t ms)
{
    assert((ms & regcon.cse.mops) == ms);
    regcon.cse.mops &= ~ms;

    /* Skip CSEs that are already saved */
    for (regm_t regm = 1; regm < mask(NUMREGS); regm <<= 1)
    {
        if (regm & ms)
        {
            const e = regcon.cse.значение[findreg(regm)];
            const sz = tysize(e.Ety);
            foreach (ref cse; CSE.filter(e))
            {
                if (sz <= REGSIZE ||
                    sz <= 2 * REGSIZE &&
                        (regm & mMSW && cse.regm & mMSW ||
                         regm & mLSW && cse.regm & mLSW) ||
                    sz == 4 * REGSIZE && regm == cse.regm
                   )
                {
                    ms &= ~regm;
                    if (!ms)
                        return;
                    break;
                }
            }
        }
    }

    while (ms)
    {
        auto cse = CSE.add();
        reg_t reg = findreg(ms);          /* the register to save         */
        cse.e = regcon.cse.значение[reg];
        cse.regm = mask(reg);

        ms &= ~mask(reg);           /* turn off reg bit in ms       */

        // If we can simply reload the CSE, we don't need to save it
        if (cse_simple(&cse.csimple, cse.e))
            cse.flags |= CSEsimple;
        else
        {
            CSE.updateSizeAndAlign(cse.e);
            gen_storecse(cdb, cse.e.Ety, reg, cse.slot);
            reflocal = да;
        }
    }
}

/******************************************
 * Getregs without marking immediate register values as gone.
 */

проц getregs_imm(ref CodeBuilder cdb, regm_t r)
{
    regm_t save = regcon.immed.mval;
    getregs(cdb,r);
    regcon.immed.mval = save;
}

/******************************************
 * Flush all CSE's out of registers and into memory.
 * Input:
 *      do87    !=0 means save 87 registers too
 */

проц cse_flush(ref CodeBuilder cdb, цел do87)
{
    //dbg_printf("cse_flush()\n");
    cse_save(cdb,regcon.cse.mops);      // save any CSEs to memory
    if (do87)
        save87(cdb);    // save any 8087 temporaries
}

/*************************
 * Common subВыражения exist in registers. Note this in regcon.cse.mval.
 * Input:
 *      e       the subВыражение
 *      regm    mask of registers holding it
 *      opsflag if != 0 then regcon.cse.mops gets set too
 * Возвращает:
 *      нет   not saved as a CSE
 *      да    saved as a CSE
 */

бул cssave(elem *e,regm_t regm,бцел opsflag)
{
    бул результат = нет;

    /*if (e.Ecount && e.Ecount == e.Ecomsub)*/
    if (e.Ecount && e.Ecomsub)
    {
        if (!opsflag && pass != PASSfinal && (I32 || I64))
            return нет;

        //printf("cssave(e = %p, regm = %s, opsflag = x%x)\n", e, regm_str(regm), opsflag);
        regm &= mBP | ALLREGS | mES | XMMREGS;    /* just to be sure              */

/+
        /* Do not register CSEs if they are register variables and      */
        /* are not operator nodes. This forces the register allocation  */
        /* to go through allocreg(), which will prevent using register  */
        /* variables for scratch.                                       */
        if (opsflag || !(regm & regcon.mvar))
+/
            for (бцел i = 0; regm; i++)
            {
                regm_t mi = mask(i);
                if (regm & mi)
                {
                    regm &= ~mi;

                    // If we don't need this CSE, and the register already
                    // holds a CSE that we do need, don't mark the new one
                    if (regcon.cse.mval & mi && regcon.cse.значение[i] != e &&
                        !opsflag && regcon.cse.mops & mi)
                        continue;

                    regcon.cse.mval |= mi;
                    if (opsflag)
                        regcon.cse.mops |= mi;
                    //printf("cssave set: regcon.cse.значение[%s] = %p\n",regstring[i],e);
                    regcon.cse.значение[i] = e;
                    результат = да;
                }
            }
    }
    return результат;
}

/*************************************
 * Determine if a computation should be done into a register.
 */

бул evalinregister(elem *e)
{
    if (config.exe == EX_WIN64 && e.Eoper == OPrelconst)
        return да;

    if (e.Ecount == 0)             /* elem is not a CSE, therefore */
                                    /* we don't need to evaluate it */
                                    /* in a register                */
        return нет;
    if (!OTleaf(e.Eoper))          /* operators are always in register */
        return да;

    // Need to rethink this code if float or double can be CSE'd
    бцел sz = tysize(e.Ety);
    if (e.Ecount == e.Ecomsub)    /* elem is a CSE that needs     */
                                    /* to be generated              */
    {
        if ((I32 || I64) &&
            //pass == PASSfinal && // bug 8987
            sz <= REGSIZE)
        {
            // Do it only if at least 2 registers are доступно
            regm_t m = allregs & ~regcon.mvar;
            if (sz == 1)
                m &= BYTEREGS;
            if (m & (m - 1))        // if more than one register
            {   // Need to be at least 3 registers доступно, as
                // addressing modes can use up 2.
                while (!(m & 1))
                    m >>= 1;
                m >>= 1;
                if (m & (m - 1))
                    return да;
            }
        }
        return нет;
    }

    /* Elem is now a CSE that might have been generated. If so, and */
    /* it's in a register already, the computation should be done   */
    /* using that register.                                         */
    regm_t emask = 0;
    for (бцел i = 0; i < regcon.cse.значение.length; i++)
        if (regcon.cse.значение[i] == e)
            emask |= mask(i);
    emask &= regcon.cse.mval;       // mask of доступно CSEs
    if (sz <= REGSIZE)
        return emask != 0;      /* the CSE is in a register     */
    else if (sz <= 2 * REGSIZE)
        return (emask & mMSW) && (emask & mLSW);
    return да;                    /* cop-out for now              */
}

/*******************************************************
 * Return mask of scratch registers.
 */

regm_t getscratch()
{
    regm_t scratch = 0;
    if (pass == PASSfinal)
    {
        scratch = allregs & ~(regcon.mvar | regcon.mpvar | regcon.cse.mval |
                  regcon.immed.mval | regcon.парамы | mfuncreg);
    }
    return scratch;
}

/******************************
 * Evaluate an elem that is a common subexp that has been encountered
 * before.
 * Look first to see if it is already in a register.
 */

private проц comsub(ref CodeBuilder cdb,elem *e,regm_t *pretregs)
{
    tym_t tym;
    regm_t regm,emask;
    reg_t reg;
    бцел byte_,sz;

    //printf("comsub(e = %p, *pretregs = %s)\n",e,regm_str(*pretregs));
    elem_debug(e);

    debug
    {
        if (e.Ecomsub > e.Ecount)
            elem_print(e);
    }

    assert(e.Ecomsub <= e.Ecount);

    if (*pretregs == 0)        // no possible side effects anyway
    {
        return;
    }

    /* First construct a mask, emask, of all the registers that
     * have the right contents.
     */
    emask = 0;
    for (бцел i = 0; i < regcon.cse.значение.length; i++)
    {
        //dbg_printf("regcon.cse.значение[%d] = %p\n",i,regcon.cse.значение[i]);
        if (regcon.cse.значение[i] == e)   // if contents are right
                emask |= mask(i);       // turn on bit for reg
    }
    emask &= regcon.cse.mval;                     // make sure all bits are valid

    if (emask & XMMREGS && *pretregs == mPSW)
        { }
    else if (tyxmmreg(e.Ety) && config.fpxmmregs)
    {
        if (*pretregs & (mST0 | mST01))
        {
            regm_t retregs = *pretregs & mST0 ? XMMREGS : mXMM0 | mXMM1;
            comsub(cdb, e, &retregs);
            fixрезультат(cdb,e,retregs,pretregs);
            return;
        }
    }
    else if (tyfloating(e.Ety) && config.inline8087)
    {
        comsub87(cdb,e,pretregs);
        return;
    }


    /* создай mask of CSEs */
    regm_t csemask = CSE.mask(e);
    csemask &= ~emask;            // stuff already in registers

    debug if (debugw)
    {
        printf("comsub(e=%p): *pretregs=%s, emask=%s, csemask=%s, regcon.cse.mval=%s, regcon.mvar=%s\n",
                e,regm_str(*pretregs),regm_str(emask),regm_str(csemask),
                regm_str(regcon.cse.mval),regm_str(regcon.mvar));
        if (regcon.cse.mval & 1)
            elem_print(regcon.cse.значение[0]);
    }

    tym = tybasic(e.Ety);
    sz = _tysize[tym];
    byte_ = sz == 1;

    if (sz <= REGSIZE || (tyxmmreg(tym) && config.fpxmmregs)) // if данные will fit in one register
    {
        /* First see if it is already in a correct register     */

        regm = emask & *pretregs;
        if (regm == 0)
            regm = emask;               /* try any other register       */
        if (regm)                       /* if it's in a register        */
        {
            if (!OTleaf(e.Eoper) || !(regm & regcon.mvar) || (*pretregs & regcon.mvar) == *pretregs)
            {
                regm = mask(findreg(regm));
                fixрезультат(cdb,e,regm,pretregs);
                return;
            }
        }

        if (OTleaf(e.Eoper))                  /* if not op or func            */
            goto reload;                      /* reload данные                  */

        foreach (ref cse; CSE.filter(e))
        {
            regm_t retregs;

            if (cse.flags & CSEsimple)
            {
                retregs = *pretregs;
                if (byte_ && !(retregs & BYTEREGS))
                    retregs = BYTEREGS;
                else if (!(retregs & allregs))
                    retregs = allregs;
                allocreg(cdb,&retregs,&reg,tym);
                code *cr = &cse.csimple;
                cr.setReg(reg);
                if (I64 && reg >= 4 && tysize(cse.e.Ety) == 1)
                    cr.Irex |= REX;
                cdb.gen(cr);
                goto L10;
            }
            else
            {
                reflocal = да;
                cse.flags |= CSEload;
                if (*pretregs == mPSW)  // if результат in CCs only
                {
                    if (config.fpxmmregs && (tyxmmreg(cse.e.Ety) || tyvector(cse.e.Ety)))
                    {
                        retregs = XMMREGS;
                        allocreg(cdb,&retregs,&reg,tym);
                        gen_loadcse(cdb, cse.e.Ety, reg, cse.slot);
                        regcon.cse.mval |= mask(reg); // cs is in a reg
                        regcon.cse.значение[reg] = e;
                        fixрезультат(cdb,e,retregs,pretregs);
                    }
                    else
                    {
                        // CMP cs[BP],0
                        gen_testcse(cdb, cse.e.Ety, sz, cse.slot);
                    }
                }
                else
                {
                    retregs = *pretregs;
                    if (byte_ && !(retregs & BYTEREGS))
                        retregs = BYTEREGS;
                    allocreg(cdb,&retregs,&reg,tym);
                    gen_loadcse(cdb, cse.e.Ety, reg, cse.slot);
                L10:
                    regcon.cse.mval |= mask(reg); // cs is in a reg
                    regcon.cse.значение[reg] = e;
                    fixрезультат(cdb,e,retregs,pretregs);
                }
            }
            return;
        }

        debug
        {
            printf("couldn't найди cse e = %p, pass = %d\n",e,pass);
            elem_print(e);
        }
        assert(0);                      /* should have found it         */
    }
    else                                  /* reg pair is req'd            */
    if (sz <= 2 * REGSIZE)
    {
        reg_t msreg,lsreg;

        /* see if we have both  */
        if (!((emask | csemask) & mMSW && (emask | csemask) & (mLSW | mBP)))
        {                               /* we don't have both           */
            debug if (!OTleaf(e.Eoper))
            {
                printf("e = %p, op = x%x, emask = %s, csemask = %s\n",
                    e,e.Eoper,regm_str(emask),regm_str(csemask));
                //printf("mMSW = x%x, mLSW = x%x\n", mMSW, mLSW);
                elem_print(e);
            }

            assert(OTleaf(e.Eoper));        /* must have both for operators */
            goto reload;
        }

        /* Look for right vals in any regs      */
        regm = *pretregs & mMSW;
        if (emask & regm)
            msreg = findreg(emask & regm);
        else if (emask & mMSW)
            msreg = findregmsw(emask);
        else                    /* reload from cse массив        */
        {
            if (!regm)
                regm = mMSW & ALLREGS;
            allocreg(cdb,&regm,&msreg,TYint);
            loadcse(cdb,e,msreg,mMSW);
        }

        regm = *pretregs & (mLSW | mBP);
        if (emask & regm)
            lsreg = findreg(emask & regm);
        else if (emask & (mLSW | mBP))
            lsreg = findreglsw(emask);
        else
        {
            if (!regm)
                regm = mLSW;
            allocreg(cdb,&regm,&lsreg,TYint);
            loadcse(cdb,e,lsreg,mLSW | mBP);
        }

        regm = mask(msreg) | mask(lsreg);       /* mask of результат       */
        fixрезультат(cdb,e,regm,pretregs);
        return;
    }
    else if (tym == TYdouble || tym == TYdouble_alias)    // double
    {
        assert(I16);
        if (((csemask | emask) & DOUBLEREGS_16) == DOUBLEREGS_16)
        {
            static const reg_t[4] dblreg = [ BX,DX,NOREG,CX ]; // duplicate of one in cod4.d
            for (reg = 0; reg != NOREG; reg = dblreg[reg])
            {
                assert(cast(цел) reg >= 0 && reg <= 7);
                if (mask(reg) & csemask)
                    loadcse(cdb,e,reg,mask(reg));
            }
            regm = DOUBLEREGS_16;
            fixрезультат(cdb,e,regm,pretregs);
            return;
        }
        if (OTleaf(e.Eoper)) goto reload;

        debug
        printf("e = %p, csemask = %s, emask = %s\n",e,regm_str(csemask),regm_str(emask));

        assert(0);
    }
    else
    {
        debug
        printf("e = %p, tym = x%x\n",e,tym);

        assert(0);
    }

reload:                                 /* reload результат from memory    */
    switch (e.Eoper)
    {
        case OPrelconst:
            cdrelconst(cdb,e,pretregs);
            break;

static if (TARGET_LINUX || TARGET_OSX || TARGET_FREEBSD || TARGET_OPENBSD || TARGET_DRAGONFLYBSD || TARGET_SOLARIS)
{
        case OPgot:
            cdgot(cdb,e,pretregs);
            break;
}
        default:
            if (*pretregs == mPSW &&
                config.fpxmmregs &&
                (tyxmmreg(tym) || tysimd(tym)))
            {
                regm_t retregs = XMMREGS | mPSW;
                loaddata(cdb,e,&retregs);
                cssave(e,retregs,нет);
                return;
            }
            loaddata(cdb,e,pretregs);
            break;
    }
    cssave(e,*pretregs,нет);
}


/*****************************
 * Load reg from cse save area on stack.
 */

private проц loadcse(ref CodeBuilder cdb,elem *e,reg_t reg,regm_t regm)
{
    foreach (ref cse; CSE.filter(e))
    {
        //printf("CSE[%d] = %p, regm = %s\n", i, cse.e, regm_str(cse.regm));
        if (cse.regm & regm)
        {
            reflocal = да;
            cse.flags |= CSEload;    /* it was loaded        */
            regcon.cse.значение[reg] = e;
            regcon.cse.mval |= mask(reg);
            getregs(cdb,mask(reg));
            gen_loadcse(cdb, cse.e.Ety, reg, cse.slot);
            return;
        }
    }
    debug
    {
        printf("loadcse(e = %p, reg = %d, regm = %s)\n",e,reg,regm_str(regm));
        elem_print(e);
    }
    assert(0);
}

/***************************
 * Generate code sequence for an elem.
 * Input:
 *      pretregs =      mask of possible registers to return результат in
 *                      Note:   longs are in AX,BX or CX,DX or SI,DI
 *                              doubles are AX,BX,CX,DX only
 *      constflag =     1 for user of результат will not modify the
 *                      registers returned in *pretregs.
 *                      2 for freenode() not called.
 * Output:
 *      *pretregs       mask of registers результат is returned in
 * Возвращает:
 *      pointer to code sequence generated
 */

проц callcdxxx(ref CodeBuilder cdb, elem *e, regm_t *pretregs, OPER op)
{
    (*cdxxx[op])(cdb,e,pretregs);
}

// jump table
private /*extern (C++) __gshared */ проц function (ref CodeBuilder,elem *,regm_t *)[OPMAX] cdxxx =
[
    OPunde:    &cderr,
    OPadd:     &cdorth,
    OPmul:     &cdmul,
    OPand:     &cdorth,
    OPmin:     &cdorth,
    OPnot:     &cdnot,
    OPcom:     &cdcom,
    OPcond:    &cdcond,
    OPcomma:   &cdcomma,
    OPremquo:  &cdmul,
    OPdiv:     &cdmul,
    OPmod:     &cdmul,
    OPxor:     &cdorth,
    OPstring:  &cderr,
    OPrelconst: &cdrelconst,
    OPinp:     &cdport,
    OPoutp:    &cdport,
    OPasm:     &cdasm,
    OPinfo:    &cdinfo,
    OPdctor:   &cddctor,
    OPddtor:   &cdddtor,
    OPctor:    &cdctor,
    OPdtor:    &cddtor,
    OPmark:    &cdmark,
    OPvoid:    &cdvoid,
    OPhalt:    &cdhalt,
    OPnullptr: &cderr,
    OPpair:    &cdpair,
    OPrpair:   &cdpair,

    OPor:      &cdorth,
    OPoror:    &cdloglog,
    OPandand:  &cdloglog,
    OProl:     &cdshift,
    OPror:     &cdshift,
    OPshl:     &cdshift,
    OPshr:     &cdshift,
    OPashr:    &cdshift,
    OPbit:     &cderr,
    OPind:     &cdind,
    OPaddr:    &cderr,
    OPneg:     &cdneg,
    OPuadd:    &cderr,
    OPabs:     &cdabs,
    OPsqrt:    &cdneg,
    OPsin:     &cdneg,
    OPcos:     &cdneg,
    OPscale:   &cdscale,
    OPyl2x:    &cdscale,
    OPyl2xp1:  &cdscale,
    OPcmpxchg:     &cdcmpxchg,
    OPrint:    &cdneg,
    OPrndtol:  &cdrndtol,
    OPstrlen:  &cdstrlen,
    OPstrcpy:  &cdstrcpy,
    OPmemcpy:  &cdmemcpy,
    OPmemset:  &cdmemset,
    OPstrcat:  &cderr,
    OPstrcmp:  &cdstrcmp,
    OPmemcmp:  &cdmemcmp,
    OPsetjmp:  &cdsetjmp,
    OPnegass:  &cdaddass,
    OPpreinc:  &cderr,
    OPpredec:  &cderr,
    OPstreq:   &cdstreq,
    OPpostinc: &cdpost,
    OPpostdec: &cdpost,
    OPeq:      &cdeq,
    OPaddass:  &cdaddass,
    OPminass:  &cdaddass,
    OPmulass:  &cdmulass,
    OPdivass:  &cdmulass,
    OPmodass:  &cdmulass,
    OPshrass:  &cdshass,
    OPashrass: &cdshass,
    OPshlass:  &cdshass,
    OPandass:  &cdaddass,
    OPxorass:  &cdaddass,
    OPorass:   &cdaddass,

    OPle:      &cdcmp,
    OPgt:      &cdcmp,
    OPlt:      &cdcmp,
    OPge:      &cdcmp,
    OPeqeq:    &cdcmp,
    OPne:      &cdcmp,

    OPunord:   &cdcmp,
    OPlg:      &cdcmp,
    OPleg:     &cdcmp,
    OPule:     &cdcmp,
    OPul:      &cdcmp,
    OPuge:     &cdcmp,
    OPug:      &cdcmp,
    OPue:      &cdcmp,
    OPngt:     &cdcmp,
    OPnge:     &cdcmp,
    OPnlt:     &cdcmp,
    OPnle:     &cdcmp,
    OPord:     &cdcmp,
    OPnlg:     &cdcmp,
    OPnleg:    &cdcmp,
    OPnule:    &cdcmp,
    OPnul:     &cdcmp,
    OPnuge:    &cdcmp,
    OPnug:     &cdcmp,
    OPnue:     &cdcmp,

    OPvp_fp:   &cdcnvt,
    OPcvp_fp:  &cdcnvt,
    OPoffset:  &cdlngsht,
    OPnp_fp:   &cdshtlng,
    OPnp_f16p: &cdfar16,
    OPf16p_np: &cdfar16,

    OPs16_32:  &cdshtlng,
    OPu16_32:  &cdshtlng,
    OPd_s32:   &cdcnvt,
    OPb_8:     &cdcnvt,
    OPs32_d:   &cdcnvt,
    OPd_s16:   &cdcnvt,
    OPs16_d:   &cdcnvt,
    OPd_u16:   &cdcnvt,
    OPu16_d:   &cdcnvt,
    OPd_u32:   &cdcnvt,
    OPu32_d:   &cdcnvt,
    OP32_16:   &cdlngsht,
    OPd_f:     &cdcnvt,
    OPf_d:     &cdcnvt,
    OPd_ld:    &cdcnvt,
    OPld_d:    &cdcnvt,
    OPc_r:     &cdconvt87,
    OPc_i:     &cdconvt87,
    OPu8_16:   &cdbyteint,
    OPs8_16:   &cdbyteint,
    OP16_8:    &cdlngsht,
    OPu32_64:  &cdshtlng,
    OPs32_64:  &cdshtlng,
    OP64_32:   &cdlngsht,
    OPu64_128: &cdshtlng,
    OPs64_128: &cdshtlng,
    OP128_64:  &cdlngsht,
    OPmsw:     &cdmsw,

    OPd_s64:   &cdcnvt,
    OPs64_d:   &cdcnvt,
    OPd_u64:   &cdcnvt,
    OPu64_d:   &cdcnvt,
    OPld_u64:  &cdcnvt,
    OPparam:   &cderr,
    OPsizeof:  &cderr,
    OParrow:   &cderr,
    OParrowstar: &cderr,
    OPcolon:   &cderr,
    OPcolon2:  &cderr,
    OPбул:    &cdnot,
    OPcall:    &cdfunc,
    OPucall:   &cdfunc,
    OPcallns:  &cdfunc,
    OPucallns: &cdfunc,
    OPstrpar:  &cderr,
    OPstrctor: &cderr,
    OPstrthis: &cdstrthis,
    OPconst:   &cderr,
    OPvar:     &cderr,
    OPnew:     &cderr,
    OPanew:    &cderr,
    OPdelete:  &cderr,
    OPadelete: &cderr,
    OPbrack:   &cderr,
    OPframeptr: &cdframeptr,
    OPgot:     &cdgot,

    OPbsf:     &cdbscan,
    OPbsr:     &cdbscan,
    OPbtst:    &cdbtst,
    OPbt:      &cdbt,
    OPbtc:     &cdbt,
    OPbtr:     &cdbt,
    OPbts:     &cdbt,

    OPbswap:   &cdbswap,
    OPpopcnt:  &cdpopcnt,
    OPvector:  &cdvector,
    OPvecsto:  &cdvecsto,
    OPvecfill: &cdvecfill,
    OPva_start: &cderr,
    OPprefetch: &cdprefetch,
];


проц codelem(ref CodeBuilder cdb,elem *e,regm_t *pretregs,бцел constflag)
{
    Symbol *s;

    debug if (debugw)
    {
        printf("+codelem(e=%p,*pretregs=%s) ",e,regm_str(*pretregs));
        WROP(e.Eoper);
        printf("msavereg=%s regcon.cse.mval=%s regcon.cse.mops=%s\n",
                regm_str(msavereg),regm_str(regcon.cse.mval),regm_str(regcon.cse.mops));
        printf("Ecount = %d, Ecomsub = %d\n", e.Ecount, e.Ecomsub);
    }

    assert(e);
    elem_debug(e);
    if ((regcon.cse.mops & regcon.cse.mval) != regcon.cse.mops)
    {
        debug
        {
            printf("+codelem(e=%p,*pretregs=%s) ", e, regm_str(*pretregs));
            elem_print(e);
            printf("msavereg=%s regcon.cse.mval=%s regcon.cse.mops=%s\n",
                    regm_str(msavereg),regm_str(regcon.cse.mval),regm_str(regcon.cse.mops));
            printf("Ecount = %d, Ecomsub = %d\n", e.Ecount, e.Ecomsub);
        }
        assert(0);
    }

    if (!(constflag & 1) && *pretregs & (mES | ALLREGS | mBP | XMMREGS) & ~regcon.mvar)
        *pretregs &= ~regcon.mvar;                      /* can't use register vars */

    бцел op = e.Eoper;
    if (e.Ecount && e.Ecount != e.Ecomsub)     // if common subexp
    {
        comsub(cdb,e,pretregs);
        goto L1;
    }

    if (configv.addlinenumbers && e.Esrcpos.Slinnum)
        cdb.genlinnum(e.Esrcpos);

    switch (op)
    {
        default:
            if (e.Ecount)                          /* if common subexp     */
            {
                /* if no return значение       */
                if ((*pretregs & (mSTACK | mES | ALLREGS | mBP | XMMREGS)) == 0)
                {
                    if (*pretregs & (mST0 | mST01))
                    {
                        //printf("generate ST0 comsub for:\n");
                        //elem_print(e);

                        regm_t retregs = *pretregs & mST0 ? mXMM0 : mXMM0|mXMM1;
                        (*cdxxx[op])(cdb,e,&retregs);
                        cssave(e,retregs,!OTleaf(op));
                        fixрезультат(cdb, e, retregs, pretregs);
                        goto L1;
                    }
                    if (tysize(e.Ety) == 1)
                        *pretregs |= BYTEREGS;
                    else if ((tyxmmreg(e.Ety) || tysimd(e.Ety)) && config.fpxmmregs)
                        *pretregs |= XMMREGS;
                    else if (tybasic(e.Ety) == TYdouble || tybasic(e.Ety) == TYdouble_alias)
                        *pretregs |= DOUBLEREGS;
                    else
                        *pretregs |= ALLREGS;       /* make one             */
                }

                /* BUG: For CSEs, make sure we have both an MSW             */
                /* and an LSW specified in *pretregs                        */
            }
            assert(op <= OPMAX);
            (*cdxxx[op])(cdb,e,pretregs);
            break;

        case OPrelconst:
            cdrelconst(cdb,e,pretregs);
            break;

        case OPvar:
            if (constflag & 1 && (s = e.EV.Vsym).Sfl == FLreg &&
                (s.Sregm & *pretregs) == s.Sregm)
            {
                if (tysize(e.Ety) <= REGSIZE && tysize(s.Stype.Tty) == 2 * REGSIZE)
                    *pretregs &= mPSW | (s.Sregm & mLSW);
                else
                    *pretregs &= mPSW | s.Sregm;
            }
            goto case OPconst;

        case OPconst:
            if (*pretregs == 0 && (e.Ecount >= 3 || e.Ety & mTYvolatile))
            {
                switch (tybasic(e.Ety))
                {
                    case TYбул:
                    case TYchar:
                    case TYschar:
                    case TYuchar:
                        *pretregs |= BYTEREGS;
                        break;

                    case TYnref:
                    case TYnptr:
                    case TYsptr:
                    case TYcptr:
                    case TYfgPtr:
                    case TYimmutPtr:
                    case TYsharePtr:
                        *pretregs |= I16 ? IDXREGS : ALLREGS;
                        break;

                    case TYshort:
                    case TYushort:
                    case TYint:
                    case TYuint:
                    case TYlong:
                    case TYulong:
                    case TYllong:
                    case TYullong:
                    case TYcent:
                    case TYucent:
                    case TYfptr:
                    case TYhptr:
                    case TYvptr:
                        *pretregs |= ALLREGS;
                        break;

                    default:
                        break;
                }
            }
            loaddata(cdb,e,pretregs);
            break;
    }
    cssave(e,*pretregs,!OTleaf(op));
L1:
    if (!(constflag & 2))
        freenode(e);

    debug if (debugw)
    {
        printf("-codelem(e=%p,*pretregs=%s) ",e,regm_str(*pretregs));
        WROP(op);
        printf("msavereg=%s regcon.cse.mval=%s regcon.cse.mops=%s\n",
                regm_str(msavereg),regm_str(regcon.cse.mval),regm_str(regcon.cse.mops));
    }
}

/*******************************
 * Same as codelem(), but do not разрушь the registers in keepmsk.
 * Use scratch registers as much as possible, then use stack.
 * Input:
 *      constflag       да if user of результат will not modify the
 *                      registers returned in *pretregs.
 */

проц scodelem(ref CodeBuilder cdb, elem *e,regm_t *pretregs,regm_t keepmsk,бул constflag)
{
    regm_t touse;

    debug if (debugw)
        printf("+scodelem(e=%p *pretregs=%s keepmsk=%s constflag=%d\n",
                e,regm_str(*pretregs),regm_str(keepmsk),constflag);

    elem_debug(e);
    if (constflag)
    {
        regm_t regm;
        reg_t reg;

        if (isregvar(e,&regm,&reg) &&           // if e is a register variable
            (regm & *pretregs) == regm &&       // in one of the right regs
            e.EV.Voffset == 0
           )
        {
            бцел sz1 = tysize(e.Ety);
            бцел sz2 = tysize(e.EV.Vsym.Stype.Tty);
            if (sz1 <= REGSIZE && sz2 > REGSIZE)
                regm &= mLSW | XMMREGS;
            fixрезультат(cdb,e,regm,pretregs);
            cssave(e,regm,0);
            freenode(e);

            debug if (debugw)
                printf("-scodelem(e=%p *pretregs=%s keepmsk=%s constflag=%d\n",
                        e,regm_str(*pretregs),regm_str(keepmsk),constflag);

            return;
        }
    }
    regm_t overlap = msavereg & keepmsk;
    msavereg |= keepmsk;          /* add to mask of regs to save          */
    regm_t oldregcon = regcon.cse.mval;
    regm_t oldregimmed = regcon.immed.mval;
    regm_t oldmfuncreg = mfuncreg;       /* remember old one                     */
    mfuncreg = (XMMREGS | mBP | mES | ALLREGS) & ~regcon.mvar;
    бцел stackpushsave = stackpush;
    сим calledafuncsave = calledafunc;
    calledafunc = 0;
    CodeBuilder cdbx; cdbx.ctor();
    codelem(cdbx,e,pretregs,constflag);    // generate code for the elem

    regm_t tosave = keepmsk & ~msavereg; /* registers to save                    */
    if (tosave)
    {
        cgstate.stackclean++;
        genstackclean(cdbx,stackpush - stackpushsave,*pretregs | msavereg);
        cgstate.stackclean--;
    }

    /* Assert that no new CSEs are generated that are not reflected       */
    /* in mfuncreg.                                                       */
    debug if ((mfuncreg & (regcon.cse.mval & ~oldregcon)) != 0)
        printf("mfuncreg %s, regcon.cse.mval %s, oldregcon %s, regcon.mvar %s\n",
                regm_str(mfuncreg),regm_str(regcon.cse.mval),regm_str(oldregcon),regm_str(regcon.mvar));

    assert((mfuncreg & (regcon.cse.mval & ~oldregcon)) == 0);

    /* bugzilla 3521
     * The problem is:
     *    reg op (reg = exp)
     * where reg must be preserved (in keepregs) while the Выражение to be evaluated
     * must change it.
     * The only solution is to make this variable not a register.
     */
    if (regcon.mvar & tosave)
    {
        //elem_print(e);
        //printf("test1: regcon.mvar %s tosave %s\n", regm_str(regcon.mvar), regm_str(tosave));
        cgreg_unregister(regcon.mvar & tosave);
    }

    /* which registers can we use to save other registers in? */
    if (config.flags4 & CFG4space ||              // if optimize for space
        config.target_cpu >= TARGET_80486)        // PUSH/POP ops are 1 cycle
        touse = 0;                              // PUSH/POP pairs are always shorter
    else
    {
        touse = mfuncreg & allregs & ~(msavereg | oldregcon | regcon.cse.mval);
        /* Don't use registers we'll have to save/restore               */
        touse &= ~(fregsaved & oldmfuncreg);
        /* Don't use registers that have constant values in them, since
           the code generated might have используется the значение.
         */
        touse &= ~oldregimmed;
    }

    CodeBuilder cdbs1; cdbs1.ctor();
    code *cs2 = null;
    цел adjesp = 0;

    for (бцел i = 0; tosave; i++)
    {
        regm_t mi = mask(i);

        assert(i < REGMAX);
        if (mi & tosave)        /* i = register to save                 */
        {
            if (touse)          /* if any scratch registers             */
            {
                бцел j;
                for (j = 0; j < 8; j++)
                {
                    regm_t mj = mask(j);

                    if (touse & mj)
                    {
                        genmovreg(cdbs1,j,i);
                        cs2 = cat(genmovreg(i,j),cs2);
                        touse &= ~mj;
                        mfuncreg &= ~mj;
                        regcon.используется |= mj;
                        break;
                    }
                }
                assert(j < 8);
            }
            else                        // else use memory
            {
                CodeBuilder cdby; cdby.ctor();
                бцел size = gensaverestore(mask(i), cdbs1, cdby);
                cs2 = cat(cdby.finish(),cs2);
                if (size)
                {
                    stackchanged = 1;
                    adjesp += size;
                }
            }
            getregs(cdbx,mi);
            tosave &= ~mi;
        }
    }
    CodeBuilder cdbs2; cdbs2.ctor();
    if (adjesp)
    {
        // If this is done an odd number of times, it
        // will throw off the 8 byte stack alignment.
        // We should *only* worry about this if a function
        // was called in the code generation by codelem().
        цел sz = -(adjesp & (STACKALIGN - 1)) & (STACKALIGN - 1);
        if (calledafunc && !I16 && sz && (STACKALIGN >= 16 || config.flags4 & CFG4stackalign))
        {
            regm_t mval_save = regcon.immed.mval;
            regcon.immed.mval = 0;      // prevent reghasvalue() optimizations
                                        // because c hasn't been executed yet
            cod3_stackadj(cdbs1, sz);
            regcon.immed.mval = mval_save;
            cdbs1.genadjesp(sz);

            cod3_stackadj(cdbs2, -sz);
            cdbs2.genadjesp(-sz);
        }
        cdbs2.приставь(cs2);


        cdbs1.genadjesp(adjesp);
        cdbs2.genadjesp(-adjesp);
    }
    else
        cdbs2.приставь(cs2);

    calledafunc |= calledafuncsave;
    msavereg &= ~keepmsk | overlap; /* удали from mask of regs to save   */
    mfuncreg &= oldmfuncreg;        /* update original                    */

    debug if (debugw)
        printf("-scodelem(e=%p *pretregs=%s keepmsk=%s constflag=%d\n",
                e,regm_str(*pretregs),regm_str(keepmsk),constflag);

    cdb.приставь(cdbs1);
    cdb.приставь(cdbx);
    cdb.приставь(cdbs2);
    return;
}

/*********************************************
 * Turn register mask into a ткст suitable for printing.
 */

ткст0 regm_str(regm_t rm)
{
    const NUM = 10;
    const SMAX = 128;
     сим[SMAX + 1][NUM] str;
     цел i;

    if (rm == 0)
        return "0";
    if (rm == ALLREGS)
        return "ALLREGS";
    if (rm == BYTEREGS)
        return "BYTEREGS";
    if (rm == allregs)
        return "allregs";
    if (rm == XMMREGS)
        return "XMMREGS";
    сим *p = str[i].ptr;
    if (++i == NUM)
        i = 0;
    *p = 0;
    for (т_мера j = 0; j < 32; j++)
    {
        if (mask(cast(бцел)j) & rm)
        {
            strcat(p,regstring[j]);
            rm &= ~mask(cast(бцел)j);
            if (rm)
                strcat(p,"|");
        }
    }
    if (rm)
    {   сим *s = p + strlen(p);
        sprintf(s,"x%02x",rm);
    }
    assert(strlen(p) <= SMAX);
    return strdup(p);
}

/*********************************
 * Scan down comma-Выражения.
 * Output:
 *      *pe = first elem down right side that is not an OPcomma
 * Возвращает:
 *      code generated for left branches of comma-Выражения
 */

проц docommas(ref CodeBuilder cdb,elem **pe)
{
    бцел stackpushsave = stackpush;
    цел stackcleansave = cgstate.stackclean;
    cgstate.stackclean = 0;
    elem* e = *pe;
    while (1)
    {
        if (configv.addlinenumbers && e.Esrcpos.Slinnum)
        {
            cdb.genlinnum(e.Esrcpos);
            //e.Esrcpos.Slinnum = 0;               // don't do it twice
        }
        if (e.Eoper != OPcomma)
            break;
        regm_t retregs = 0;
        codelem(cdb,e.EV.E1,&retregs,да);
        elem* eold = e;
        e = e.EV.E2;
        freenode(eold);
    }
    *pe = e;
    assert(cgstate.stackclean == 0);
    cgstate.stackclean = stackcleansave;
    genstackclean(cdb,stackpush - stackpushsave,0);
}

/**************************
 * For elems in regcon that don't match regconsave,
 * clear the corresponding bit in regcon.cse.mval.
 * Do same for regcon.immed.
 */

проц andregcon(con_t *pregconsave)
{
    regm_t m = ~1;
    for (цел i = 0; i < REGMAX; i++)
    {
        if (pregconsave.cse.значение[i] != regcon.cse.значение[i])
            regcon.cse.mval &= m;
        if (pregconsave.immed.значение[i] != regcon.immed.значение[i])
            regcon.immed.mval &= m;
        m <<= 1;
        m |= 1;
    }
    //printf("regcon.cse.mval = %s, regconsave.mval = %s ",regm_str(regcon.cse.mval),regm_str(pregconsave.cse.mval));
    regcon.используется |= pregconsave.используется;
    regcon.cse.mval &= pregconsave.cse.mval;
    regcon.immed.mval &= pregconsave.immed.mval;
    regcon.парамы &= pregconsave.парамы;
    //printf("regcon.cse.mval&regcon.cse.mops = %s, regcon.cse.mops = %s\n",regm_str(regcon.cse.mval & regcon.cse.mops), regm_str(regcon.cse.mops));
    regcon.cse.mops &= regcon.cse.mval;
}

}
