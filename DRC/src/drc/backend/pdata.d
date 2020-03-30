/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 2012-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/pdata.d, backend/pdata.d)
 */

// This module generates the .pdata and .xdata sections for Win64

module drc.backend.pdata;

version (Dinrus)
{

import cidrus;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.code;
import drc.backend.code_x86;
import drc.backend.dt;
import drc.backend.el;
import drc.backend.exh;
import drc.backend.глоб2;
import drc.backend.obj;
import drc.backend.rtlsym;
import drc.backend.ty;
import drc.backend.тип;

/*extern (C++):*/



static if (TARGET_WINDOS)
{

// Determine if this Symbol is stored in a COMDAT
бул symbol_iscomdat3(Symbol* s)
{
    version (Dinrus)
    {
        return s.Sclass == SCcomdat ||
            config.flags2 & CFG2comdat && s.Sclass == SCinline ||
            config.flags4 & CFG4allcomdat && s.Sclass == SCglobal;
    }
    else
    {
        return s.Sclass == SCcomdat ||
            config.flags2 & CFG2comdat && s.Sclass == SCinline ||
            config.flags4 & CFG4allcomdat && (s.Sclass == SCglobal || s.Sclass == SCstatic);
    }
}

const ALLOCA_LIMIT = 0x10000;

/**********************************
 * The .pdata section is используется on Win64 by the VS debugger and dbghelp to get information
 * to walk the stack and unwind exceptions.
 * Absent it, it is assumed to be a "leaf function" where [RSP] is the return address.
 * Creates an instance of struct RUNTIME_FUNCTION:
 *   http://msdn.microsoft.com/en-US/library/ft9x1kdx(v=vs.80).aspx
 *
 * Input:
 *      sf      function to generate unwind данные for
 */

проц win64_pdata(Symbol *sf)
{
//    return; // doesn't work yet

    //printf("win64_pdata()\n");
    assert(config.exe == EX_WIN64);

    // Generate the pdata имя, which is $pdata$funcname
    т_мера sflen = strlen(sf.Sident.ptr);
    сим *pdata_name = cast(сим *)(sflen < ALLOCA_LIMIT ? alloca(7 + sflen + 1) : malloc(7 + sflen + 1));
    assert(pdata_name);
    memcpy(pdata_name, "$pdata$".ptr, 7);
    memcpy(pdata_name + 7, sf.Sident.ptr, sflen + 1);      // include terminating 0

    Symbol *spdata = symbol_name(pdata_name,SCstatic,tstypes[TYint]);
    symbol_keep(spdata);
    symbol_debug(spdata);

    Symbol *sunwind = win64_unwind(sf);

    /* 3 pointers are emitted:
     *  1. pointer to start of function sf
     *  2. pointer past end of function sf
     *  3. pointer to unwind данные
     */

    auto dtb = DtBuilder(0);
    dtb.xoff(sf,0,TYint);       // Note the TYint, these are 32 bit fixups
    dtb.xoff(sf,cast(бцел)(retoffset + retsize),TYint);
    dtb.xoff(sunwind,0,TYint);
    spdata.Sdt = dtb.finish();

    spdata.Sseg = symbol_iscomdat3(sf) ? MsCoffObj_seg_pdata_comdat(sf) : MsCoffObj_seg_pdata();
    spdata.Salignment = 4;
    outdata(spdata);

    if (sflen >= ALLOCA_LIMIT) free(pdata_name);
}

/**************************************************
 * Unwind данные symbol goes in the .xdata section.
 * Input:
 *      sf      function to generate unwind данные for
 * Возвращает:
 *      generated symbol referring to unwind данные
 */

Symbol *win64_unwind(Symbol *sf)
{
    // Generate the unwind имя, which is $unwind$funcname
    т_мера sflen = strlen(sf.Sident.ptr);
    сим *unwind_name = cast(сим *)(sflen < ALLOCA_LIMIT ? alloca(8 + sflen + 1) : malloc(8 + sflen + 1));
    assert(unwind_name);
    memcpy(unwind_name, "$unwind$".ptr, 8);
    memcpy(unwind_name + 8, sf.Sident.ptr, sflen + 1);     // include terminating 0

    Symbol *sunwind = symbol_name(unwind_name,SCstatic,tstypes[TYint]);
    symbol_keep(sunwind);
    symbol_debug(sunwind);

    sunwind.Sdt = unwind_data();
    sunwind.Sseg = symbol_iscomdat3(sf) ? MsCoffObj_seg_xdata_comdat(sf) : MsCoffObj_seg_xdata();
    sunwind.Salignment = 1;
    outdata(sunwind);

    if (sflen >= ALLOCA_LIMIT) free(unwind_name);
    return sunwind;
}

/************************* Win64 Unwind Data ******************************************/

/************************************************************************
 * Creates an instance of struct UNWIND_INFO:
 *   http://msdn.microsoft.com/en-US/library/ddssxxy8(v=vs.80).aspx
 */

enum UWOP
{   // http://www.osronline.com/ddkx/kmarch/64bitamd_7btz.htm
    // http://uninformed.org/index.cgi?v=4&a=1&p=17
    PUSH_NONVOL,     // сунь saved register, OpInfo is register
    ALLOC_LARGE,     // alloc large size on stack, OpInfo is 0 or 1
    ALLOC_SMALL,     // alloc small size on stack, OpInfo is size / 8 - 1
    SET_FPREG,       // set frame pointer
    SAVE_NONVOL,     // save register, OpInfo is reg, frame смещение in следщ FrameOffset
    SAVE_NONVOL_FAR, // save register, OpInfo is reg, frame смещение in следщ 2 FrameOffsets
    SAVE_XMM128,     // save 64 bits of XMM reg, frame смещение in следщ FrameOffset
    SAVE_XMM128_FAR, // save 64 bits of XMM reg, frame смещение in следщ 2 FrameOffsets
    PUSH_MACHFRAME   // сунь interrupt frame, OpInfo is 0 or 1 (pushes error code too)
}

union UNWIND_CODE
{
/+
    struct
    {
        ббайт CodeOffset;       // смещение of start of следщ instruction
        ббайт UnwindOp : 4;     // UWOP
        ббайт OpInfo   : 4;     // extra information depending on UWOP
    } op;
+/
    ushort FrameOffset;
}

ushort setUnwindCode(ббайт CodeOffset, ббайт UnwindOp, ббайт OpInfo)
{
    return cast(ushort)(CodeOffset | (UnwindOp << 8) | (OpInfo << 12));
}

enum
{
    UNW_FLAG_EHANDLER  = 1,  // function has an exception handler
    UNW_FLAG_UHANDLER  = 2,  // function has a termination handler
    UNW_FLAG_CHAININFO = 4   // not the primary one for the function
}

struct UNWIND_INFO
{
    ббайт Version;    //: 3;    // 1
    //ббайт Flags       : 5;    // UNW_FLAG_xxxx
    ббайт SizeOfProlog;         // bytes in the function prolog
    ббайт CountOfCodes;         // dimension of UnwindCode[]
    ббайт FrameRegister; //: 4; // if !=0, then frame pointer register
    //ббайт FrameOffset    : 4; // frame register смещение from RSP divided by 16
    UNWIND_CODE[6] UnwindCode;
static if (0)
{
    UNWIND_CODE[((CountOfCodes + 1) & ~1) - 1]  MoreUnwindCode;
    union
    {
        // UNW_FLAG_EHANDLER | UNW_FLAG_UHANDLER
        struct
        {
            бцел ExceptionHandler;
            проц[n] Language_specific_handler_data;
        }

        // UNW_FLAG_CHAININFO
        RUNTIME_FUNCTION chained_unwind_info;
    }
}
}



dt_t *unwind_data()
{
    UNWIND_INFO ui;

    /* 4 allocation size strategy:
     *  0:           no unwind instruction
     *  8..128:      UWOP.ALLOC_SMALL
     *  136..512K-8: UWOP.ALLOC_LARGE, OpInfo = 0
     *  512K..4GB-8: UWOP.ALLOC_LARGE, OpInfo = 1
     */
    targ_т_мера sz = localsize;
    assert((localsize & 7) == 0);
    цел strategy;
    if (sz == 0)
        strategy = 0;
    else if (sz <= 128)
        strategy = 1;
    else if (sz <= 512 * 1024 - 8)
        strategy = 2;
    else
        // 512KB to 4GB-8
        strategy = 3;

    ui.Version = 1;
    //ui.Flags = 0;
    ui.SizeOfProlog = cast(ббайт)startoffset;
static if (0)
{
    ui.CountOfCodes = strategy + 1;
    ui.FrameRegister = 0;
    //ui.FrameOffset = 0;
}
else
{
    strategy = 0;
    ui.CountOfCodes = cast(ббайт)(strategy + 2);
    ui.FrameRegister = BP;
    //ui.FrameOffset = 0; //cod3_spoff() / 16;
}

static if (0)
{
    switch (strategy)
    {
        case 0:
            break;

        case 1:
            ui.UnwindCode[0].FrameOffset = setUnwindCode(prolog_allocoffset, UWOP.ALLOC_SMALL, (sz - 8) / 8);
            break;

        case 2:
            ui.UnwindCode[0].FrameOffset = setUnwindCode(prolog_allocoffset, UWOP.ALLOC_LARGE, 0);
            ui.UnwindCode[1].FrameOffset = (sz - 8) / 8;
            break;

        case 3:
            ui.UnwindCode[0].FrameOffset = setUnwindCode(prolog_allocoffset, UWOP.ALLOC_LARGE, 1);
            ui.UnwindCode[1].FrameOffset = sz & 0x0FFFF;
            ui.UnwindCode[2].FrameOffset = sz / 0x10000;
            break;
    }
}

static if (1)
{
    ui.UnwindCode[ui.CountOfCodes-2].FrameOffset = setUnwindCode(4, UWOP.SET_FPREG, 0);
}

    ui.UnwindCode[ui.CountOfCodes-1].FrameOffset = setUnwindCode(1, UWOP.PUSH_NONVOL, BP);

    auto dtb = DtBuilder(0);
    dtb.члобайт(4 + ((ui.CountOfCodes + 1) & ~1) * 2,cast(сим *)&ui);
    return dtb.finish();
}

}
}

