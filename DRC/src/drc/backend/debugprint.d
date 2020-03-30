/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1985-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/debug.c, backend/debugprint.d)
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/backend/debug.c
 */

module drc.backend.debugprint;

version (SCPP)
    version = COMPILE;
version (Dinrus)
    version = COMPILE;
version (HTOD)
    version = COMPILE;

version (COMPILE)
{

import cidrus;

import drc.backend.cdef;
import drc.backend.cc;
import drc.backend.el;
import drc.backend.глоб2;
import drc.backend.code;
import drc.backend.code_x86;
import drc.backend.goh;
import drc.backend.oper;
import drc.backend.ty;
import drc.backend.тип;

import drc.backend.dlist;
import drc.backend.dvec;

/*extern (C++):*/



проц ferr(ткст0 p) { printf("%s", p); }

/*******************************
 * Write out storage class.
 */

ткст0 str_class(SC c)
{
     const сим[10][SCMAX] sc =
    [
        "unde",
        "auto",
        "static",
        "thread",
        "extern",
        "register",
        "pseudo",
        "глоб2",
        "comdat",
        "параметр",
        "regpar",
        "fastpar",
        "shadowreg",
        "typedef",
        "explicit",
        "mutable",
        "label",
        "struct",
        "enum",
        "field",
        "const",
        "member",
        "anon",
        "inline",
        "sinline",
        "einline",
        "overload",
        "friend",
        "virtual",
        "locstat",
        "template",
        "functempl",
        "ftexpspec",
        "компонаж",
        "public",
        "comdef",
        "bprel",
        "namespace",
        "alias",
        "funcalias",
        "memalias",
        "stack",
        "adl",
    ];
     сим[9 + 3] буфер;

  static assert(sc.length == SCMAX);
  if (cast(бцел) c < SCMAX)
        sprintf(буфер.ptr,"SC%s",sc[c].ptr);
  else
        sprintf(буфер.ptr,"SC%u",cast(бцел)c);
  return буфер.ptr;
}

проц WRclass(SC c)
{
    printf("%11s ",str_class(c));
}

/***************************
 * Write out oper numbers.
 */

проц WROP(бцел oper)
{
  if (oper >= OPMAX)
  {     printf("op = x%x, OPMAX = %d\n",oper,OPMAX);
        assert(0);
  }
  ferr(debtab[oper]);
  ferr(" ");
}

/*******************************
 * Write TYxxxx
 */

проц WRTYxx(tym_t t)
{
    if (t & mTYnear)
        printf("mTYnear|");
    if (t & mTYfar)
        printf("mTYfar|");
    if (t & mTYcs)
        printf("mTYcs|");
    if (t & mTYconst)
        printf("mTYconst|");
    if (t & mTYvolatile)
        printf("mTYvolatile|");
    if (t & mTYshared)
        printf("mTYshared|");
//#if !Dinrus && (__linux__ || __APPLE__ || __FreeBSD__ || __OpenBSD__ || __sun)
//    if (t & mTYtransu)
//        printf("mTYtransu|");
//#endif
    t = tybasic(t);
    if (t >= TYMAX)
    {   printf("TY %x\n",cast(цел)t);
        assert(0);
    }
    printf("TY%s ",tystring[tybasic(t)]);
}

проц WRBC(бцел bc)
{
     const сим[7][BCMAX] bcs =
        ["unde  ","goto  ","да  ","ret   ","retexp",
         "exit  ","asm   ","switch","ifthen","jmptab",
         "try   ","catch ","jump  ",
         "_try  ","_filte","_final","_ret  ","_excep",
         "jcatch","_lpad ",
        ];

    assert(bc < BCMAX);
    printf("BC%s",bcs[bc].ptr);
}

/************************
 * Write arglst
 */

проц WRarglst(list_t a)
{ цел n = 1;

  if (!a) printf("0 args\n");
  while (a)
  {     ткст0 c = cast(сим*)list_ptr(a);
        printf("arg %d: '%s'\n", n, c ? c : "NULL");
        a = a.следщ;
        n++;
  }
}

/***************************
 * Write out equation elem.
 */

проц WReqn(elem *e)
{  цел nest;

  if (!e)
        return;
  if (OTunary(e.Eoper))
  {
        WROP(e.Eoper);
        if (OTbinary(e.EV.E1.Eoper))
        {       nest++;
                ferr("(");
                WReqn(e.EV.E1);
                ferr(")");
                nest--;
        }
        else
                WReqn(e.EV.E1);
  }
  else if (e.Eoper == OPcomma && !nest)
  {     WReqn(e.EV.E1);
        printf(";\n\t");
        WReqn(e.EV.E2);
  }
  else if (OTbinary(e.Eoper))
  {
        if (OTbinary(e.EV.E1.Eoper))
        {       nest++;
                ferr("(");
                WReqn(e.EV.E1);
                ferr(")");
                nest--;
        }
        else
                WReqn(e.EV.E1);
        ferr(" ");
        WROP(e.Eoper);
        if (e.Eoper == OPstreq)
            printf("%d", cast(цел)type_size(e.ET));
        ferr(" ");
        if (OTbinary(e.EV.E2.Eoper))
        {       nest++;
                ferr("(");
                WReqn(e.EV.E2);
                ferr(")");
                nest--;
        }
        else
                WReqn(e.EV.E2);
  }
  else
  {
        switch (e.Eoper)
        {   case OPconst:
                elem_print_const(e);
                break;
            case OPrelconst:
                ferr("#");
                goto case OPvar;

            case OPvar:
                printf("%s",e.EV.Vsym.Sident.ptr);
                if (e.EV.Vsym.Ssymnum != -1)
                    printf("(%d)",e.EV.Vsym.Ssymnum);
                if (e.EV.Voffset != 0)
                {
                    if (e.EV.Voffset.sizeof == 8)
                        printf(".x%llx", cast(бдол)e.EV.Voffset);
                    else
                        printf(".%d",cast(цел)e.EV.Voffset);
                }
                break;
            case OPasm:
            case OPstring:
                printf("\"%s\"",e.EV.Vstring);
                if (e.EV.Voffset)
                    printf("+%lld",cast(long)e.EV.Voffset);
                break;
            case OPmark:
            case OPgot:
            case OPframeptr:
            case OPhalt:
            case OPdctor:
            case OPddtor:
                WROP(e.Eoper);
                break;
            case OPstrthis:
                break;
            default:
                WROP(e.Eoper);
                assert(0);
        }
  }
}

проц WRblocklist(list_t bl)
{
    foreach (bl2; ListRange(bl))
    {
        block *b = list_block(bl2);

        if (b && b.Bweight)
            printf("B%d (%p) ",b.Bdfoidx,b);
        else
            printf("%p ",b);
    }
    ferr("\n");
}

проц WRdefnod()
{ цел i;

  for (i = 0; i < go.defnod.length; i++)
  {     printf("defnod[%d] in B%d = (", go.defnod[i].DNblock.Bdfoidx, i);
        WReqn(go.defnod[i].DNelem);
        printf(");\n");
  }
}

проц WRFL(FL fl)
{
     сим[7][FLMAX] fls =
    [    "unde  ","const ","oper  ","func  ","данные  ",
         "reg   ",
         "pseudo",
         "auto  ","fast  ","para  ","extrn ",
         "code  ","block ","udata ","cs    ","swit  ",
         "fltrg ","offst ","datsg ",
         "ctor  ","dtor  ","regsav","asm   ",
         "ndp   ",
         "farda ","csdat ",
         "local ","tlsdat",
         "bprel ","frameh","blocko","alloca",
         "stack ","dsym  ",
         "got   ","gotoff",
         "funcar",
    ];

    if (cast(бцел)fl >= FLMAX)
        printf("FL%d",fl);
    else
      printf("FL%s",fls[fl].ptr);
}

/***********************
 * Write out block.
 */

проц WRblock(block *b)
{
    if (OPTIMIZER)
    {
        if (b && b.Bweight)
                printf("B%d: (%p), weight=%d",b.Bdfoidx,b,b.Bweight);
        else
                printf("block %p",b);
        if (!b)
        {       ferr("\n");
                return;
        }
        printf(" flags=x%x weight=%d",b.Bflags,b.Bweight);
        //printf("\tfile %p, line %d",b.Bfilptr,b.Blinnum);
        printf(" ");
        WRBC(b.BC);
        printf(" Btry=%p Bindex=%d",b.Btry,b.Bindex);
        if (b.BC == BCtry)
            printf(" catchvar = %p",b.catchvar);
        printf("\n");
        printf("\tBpred: "); WRblocklist(b.Bpred);
        printf("\tBsucc: "); WRblocklist(b.Bsucc);
        if (b.Belem)
        {       if (debugf)                     /* if full output       */
                        elem_print(b.Belem);
                else
                {       ferr("\t");
                        WReqn(b.Belem);
                        printf(";\n");
                }
        }
        version (Dinrus)
        {
        if (b.Bcode)
            b.Bcode.print();
        }
        version (SCPP)
        {
        if (b.Bcode)
            b.Bcode.print();
        }
        ferr("\n");
    }
    else
    {
        targ_llong *pu;
        цел ncases;

        assert(b);
        printf("%2d: ", b.Bnumber); WRBC(b.BC);
        if (b.Btry)
            printf(" Btry=B%d",b.Btry ? b.Btry.Bnumber : 0);
        if (b.Bindex)
            printf(" Bindex=%d",b.Bindex);
        if (b.BC == BC_finally)
            printf(" b_ret=B%d", b.b_ret ? b.b_ret.Bnumber : 0);
version (Dinrus)
{
        if (b.Bsrcpos.Sfilename)
            printf(" %s(%u)", b.Bsrcpos.Sfilename, b.Bsrcpos.Slinnum);
}
        printf("\n");
        if (b.Belem)
        {
            if (debugf)
                elem_print(b.Belem);
            else
            {
                ferr("\t");
                WReqn(b.Belem);
                printf(";\n");
            }
        }
        if (b.Bpred)
        {
            printf("\tBpred:");
            foreach (bl; ListRange(b.Bpred))
                printf(" B%d",list_block(bl).Bnumber);
            printf("\n");
        }
        list_t bl = b.Bsucc;
        switch (b.BC)
        {
            case BCswitch:
                pu = b.Bswitch;
                assert(pu);
                ncases = cast(цел)*pu;
                printf("\tncases = %d\n",ncases);
                printf("\tdefault: B%d\n",list_block(bl) ? list_block(bl).Bnumber : 0);
                while (ncases--)
                {   bl = list_next(bl);
                    printf("\tcase %lld: B%d\n", cast(long)*++pu,list_block(bl).Bnumber);
                }
                break;
            case BCiftrue:
            case BCgoto:
            case BCasm:
            case BCtry:
            case BCcatch:
            case BCjcatch:
            case BC_try:
            case BC_filter:
            case BC_finally:
            case BC_lpad:
            case BC_ret:
            case BC_except:

                if (bl)
                {
                    printf("\tBsucc:");
                    for ( ; bl; bl = list_next(bl))
                        printf(" B%d",list_block(bl).Bnumber);
                    printf("\n");
                }
                break;
            case BCret:
            case BCretexp:
            case BCexit:
                break;
            default:
                printf("bc = %d\n", b.BC);
                assert(0);
        }
    }
}

/*****************************
 * Number the blocks starting at 1.
 * So much more convenient than pointer values.
 */
проц numberBlocks(block *startblock)
{
    бцел number = 0;
    for (block *b = startblock; b; b = b.Bnext)
        b.Bnumber = ++number;
}

проц WRfunc()
{
        printf("func: '%s'\n",funcsym_p.Sident.ptr);

        numberBlocks(startblock);

        for (block *b = startblock; b; b = b.Bnext)
                WRblock(b);
}

}
