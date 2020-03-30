/**
 * Various глоб2 symbols.
 *
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1984-1995 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/cg.c, backend/cg.d)
 */

module drc.backend.cg;

import drc.backend.cdef;
import drc.backend.cc;
import drc.backend.глоб2;
import drc.backend.code;
import drc.backend.code_x86;
import drc.backend.тип;

/*extern (C++):*/

///////////////////// GLOBALS /////////////////////


//{
targ_т_мера     framehandleroffset;     // смещение of C++ frame handler
targ_т_мера     localgotoffset; // смещение of where localgot refers to

цел cseg = CODE;                // current code segment
                                // (negative values mean it is the negative
                                // of the public имя index of a COMDAT)

/* Stack offsets        */
targ_т_мера localsize;          /* amt subtracted from SP for local vars */

/* The following are initialized for the 8088. cod3_set32() or cod3_set64()
 * will change them as appropriate.
 */
цел     BPRM = 6;               /* R/M значение for [BP] or [EBP]          */
regm_t  fregsaved;              // mask of registers saved across function calls

regm_t  FLOATREGS = FLOATREGS_16;
regm_t  FLOATREGS2 = FLOATREGS2_16;
regm_t  DOUBLEREGS = DOUBLEREGS_16;

Symbol *localgot;               // reference to GOT for this function
Symbol *tls_get_addr_sym;       // function __tls_get_addr

цел TARGET_STACKALIGN = 2;      // default for 16 bit code
цел STACKALIGN = 2;             // varies for each function


/// Is fl данные?
бул[FLMAX] datafl() {
    бул[FLMAX] datafl;
    auto массив = [ FLdata,FLudata,FLreg,FLpseudo,FLauto,FLfast,FLpara,FLextern,
			  FLcs,FLfltreg,FLallocatmp,FLdatseg,FLtlsdata,FLbprel,
	FLstack,FLregsave,FLfuncarg,
	FLndp, FLfardata,
	];

    foreach (fl; массив)
    {
        datafl[fl] = да;
    }
    return datafl;
};


/// Is fl on the stack?
бул[FLMAX] stackfl() {
    бул[FLMAX] stackfl;
    auto массив = [ FLauto,FLfast,FLpara,FLcs,FLfltreg,FLallocatmp,FLbprel,FLstack,FLregsave,
                   FLfuncarg,
	FLndp,
	];
    foreach (fl; массив )
    {
        stackfl[fl] = да;
    }
    return stackfl;
} ;

/// What segment register is associated with it?
ббайт[FLMAX] segfl () {
    ббайт[FLMAX] segfl;

    // Segment registers
    const ES = 0;
    const CS = 1;
    const SS = 2;
    const DS = 3;
    const NO = ббайт.max;        // no register

    foreach (fl, ref seg; segfl)
    {
        switch (fl)
        {
            case 0:              seg = NO;  break;
            case FLconst:        seg = NO;  break;
            case FLoper:         seg = NO;  break;
            case FLfunc:         seg = CS;  break;
            case FLdata:         seg = DS;  break;
            case FLudata:        seg = DS;  break;
            case FLreg:          seg = NO;  break;
            case FLpseudo:       seg = NO;  break;
            case FLauto:         seg = SS;  break;
            case FLfast:         seg = SS;  break;
            case FLstack:        seg = SS;  break;
            case FLbprel:        seg = SS;  break;
            case FLpara:         seg = SS;  break;
            case FLextern:       seg = DS;  break;
            case FLcode:         seg = CS;  break;
            case FLblock:        seg = CS;  break;
            case FLblockoff:     seg = CS;  break;
            case FLcs:           seg = SS;  break;
            case FLregsave:      seg = SS;  break;
            case FLndp:          seg = SS;  break;
            case FLswitch:       seg = NO;  break;
            case FLfltreg:       seg = SS;  break;
            case FLoffset:       seg = NO;  break;
            case FLfardata:      seg = NO;  break;
            case FLcsdata:       seg = CS;  break;
            case FLdatseg:       seg = DS;  break;
            case FLctor:         seg = NO;  break;
            case FLdtor:         seg = NO;  break;
            case FLdsymbol:      seg = NO;  break;
            case FLgot:          seg = NO;  break;
            case FLgotoff:       seg = NO;  break;
            case FLtlsdata:      seg = NO;  break;
            case FLlocalsize:    seg = NO;  break;
            case FLframehandler: seg = NO;  break;
            case FLasm:          seg = NO;  break;
            case FLallocatmp:    seg = SS;  break;
            case FLfuncarg:      seg = SS;  break;

            default:
                assert(0);
        }
    }

    return segfl;
} ;

/// Is fl in the symbol table?
бул[FLMAX] flinsymtab () {
    бул[FLMAX] flinsymtab;
    auto массив = [ FLdata,FLudata,FLreg,FLpseudo,FLauto,FLfast,FLpara,FLextern,FLfunc,
                   FLtlsdata,FLbprel,FLstack,
	FLfardata,FLcsdata,
	];
    foreach (fl; массив)
    {
        flinsymtab[fl] = да;
    }
    return flinsymtab;
};

//}
