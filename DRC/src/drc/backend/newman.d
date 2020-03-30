/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1992-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/newman.c, backend/newman.c)
 */

module drc.backend.newman;

version (SCPP)
{
    version = COMPILE;
    version = SCPPorMARS;
    version = SCPPorHTOD;
}
version (HTOD)
{
    version = COMPILE;
    version = SCPPorMARS;
    version = SCPPorHTOD;
}
version (Dinrus)
{
    version = COMPILE;
    version = SCPPorMARS;
}

version (COMPILE)
{

import cidrus;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.code;
import drc.backend.code_x86;
import drc.backend.mem;
import drc.backend.el;
import drc.backend.exh;
import drc.backend.глоб2;
import drc.backend.obj;
import drc.backend.oper;
import drc.backend.rtlsym;
import drc.backend.ty;
import drc.backend.тип;
import drc.backend.xmm;

version (SCPPorHTOD)
{
    import cpp;
    import dtoken;
    import msgs2;
    import parser;
    import scopeh;
}

version (Dinrus)
    struct token_t;

/*extern (C++):*/



бул NEWTEMPMANGLE() { return !(config.flags4 & CFG4oldtmangle); }     // do new template mangling

const BUFIDMAX = 2 * IDMAX;

struct Mangle
{
    сим[BUFIDMAX + 2] буф;

    сим *np;                   // index into буф[]

    // Used for compression of redundant znames
    сим*[10] zname;
    цел znamei;

    тип*[10] arg;              // argument_replicator
    цел argi;                   // number используется in arg[]
}

private 
{
    Mangle mangle;

    цел mangle_inuse;
}

struct MangleInuse
{
static if (0)
{
    this(цел i)
    {
        assert(mangle_inuse == 0);
        mangle_inuse++;
    }

    ~this()
    {
        assert(mangle_inuse == 1);
        mangle_inuse--;
    }
}
}

/* Names for special variables  */

const{
сим[3] cpp_name_new     = "?2";
сим[3] cpp_name_delete  = "?3";
сим[4] cpp_name_anew    = "?_P";
сим[4] cpp_name_adelete = "?_Q";
сим[3] cpp_name_ct      = "?0";
сим[3] cpp_name_dt      = "?1";
сим[3] cpp_name_as      = "?4";
сим[4] cpp_name_vc      = "?_H";
сим[4] cpp_name_primdt  = "?_D";
сим[4] cpp_name_scaldeldt = "?_G";
сим[4] cpp_name_priminv = "?_R";
}


/****************************
 */

version (Dinrus)
{
struct OPTABLE
{
    ббайт tokn;
    ббайт oper;
    ткст0 ткст;
    ткст0 pretty;
}
}

version (SCPPorHTOD)
{
 OPTABLE[57] oparray = [
    {   TKnew, OPnew,           cpp_name_new.ptr,   "new" },
    {   TKdelete, OPdelete,     cpp_name_delete.ptr,"del" },
    {   TKadd, OPadd,           "?H",           "+" },
    {   TKadd, OPuadd,          "?H",           "+" },
    {   TKmin, OPmin,           "?G",           "-" },
    {   TKmin, OPneg,           "?G",           "-" },
    {   TKstar, OPmul,          "?D",           "*" },
    {   TKstar, OPind,          "?D",           "*" },
    {   TKdiv, OPdiv,           "?K",           "/" },
    {   TKmod, OPmod,           "?L",           "%" },
    {   TKxor, OPxor,           "?T",           "^" },
    {   TKand, OPand,           "?I",           "&" },
    {   TKand, OPaddr,          "?I",           "&" },
    {   TKor, OPor,             "?U",           "|" },
    {   TKcom, OPcom,           "?S",           "~" },
    {   TKnot, OPnot,           "?7",           "!" },
    {   TKeq, OPeq,             cpp_name_as.ptr,    "=" },
    {   TKeq, OPstreq,          "?4",           "=" },
    {   TKlt, OPlt,             "?M",           "<" },
    {   TKgt, OPgt,             "?O",           ">" },
    {   TKnew, OPanew,          cpp_name_anew.ptr,  "n[]" },
    {   TKdelete, OPadelete,    cpp_name_adelete.ptr,"d[]" },
    {   TKunord, OPunord,       "?_S",          "!<>=" },
    {   TKlg, OPlg,             "?_T",          "<>"   },
    {   TKleg, OPleg,           "?_U",          "<>="  },
    {   TKule, OPule,           "?_V",          "!>"   },
    {   TKul, OPul,             "?_W",          "!>="  },
    {   TKuge, OPuge,           "?_X",          "!<"   },
    {   TKug, OPug,             "?_Y",          "!<="  },
    {   TKue, OPue,             "?_Z",          "!<>"  },
    {   TKaddass, OPaddass,     "?Y",           "+=" },
    {   TKminass, OPminass,     "?Z",           "-=" },
    {   TKmulass, OPmulass,     "?X",           "*=" },
    {   TKdivass, OPdivass,     "?_0",          "/=" },
    {   TKmodass, OPmodass,     "?_1",          "%=" },
    {   TKxorass, OPxorass,     "?_6",          "^=" },
    {   TKandass, OPandass,     "?_4",          "&=" },
    {   TKorass, OPorass,       "?_5",          "|=" },
    {   TKshl, OPshl,           "?6",           "<<" },
    {   TKshr, OPshr,           "?5",           ">>" },
    {   TKshrass, OPshrass,     "?_2",          ">>=" },
    {   TKshlass, OPshlass,     "?_3",          "<<=" },
    {   TKeqeq, OPeqeq,         "?8",           "==" },
    {   TKne, OPne,             "?9",           "!=" },
    {   TKle, OPle,             "?N",           "<=" },
    {   TKge, OPge,             "?P",           ">=" },
    {   TKandand, OPandand,     "?V",           "&&" },
    {   TKoror, OPoror,         "?W",           "||" },
    {   TKplpl, OPpostinc,      "?E",           "++" },
    {   TKplpl, OPpreinc,       "?E",           "++" },
    {   TKmimi, OPpostdec,      "?F",           "--" },
    {   TKmimi, OPpredec,       "?F",           "--" },
    {   TKlpar, OPcall,         "?R",           "()" },
    {   TKlbra, OPbrack,        "?A",           "[]" },
    {   TKarrow, OParrow,       "?C",           "->" },
    {   TKcomma, OPcomma,       "?Q",           "," },
    {   TKarrowstar, OParrowstar, "?J",         "->*" },
];
}

/****************************************
 * Convert from идентификатор to operator
 */
version (SCPPorHTOD)
{

static if (0) //__GNUC__    // NOT DONE - FIX
{
сим * unmangle_pt(сим** s)
{
    return cast(сим *)*s;
}
}
else
{
    extern (C) сим *unmangle_pt(сим**);
}

сим *cpp_unmangleident(ткст0 p)
{
    MangleInuse m;

    //printf("cpp_unmangleident('%s')\n", p);
    if (*p == '$')              // if template имя
    {
    L1:
        ткст0 q = p;
        ткст0 s = unmangle_pt(&q);
        if (s)
        {   if (strlen(s) <= BUFIDMAX)
                p = strcpy(mangle.буф.ptr, s);
            free(s);
        }
    }
    else if (*p == '?')         // if operator имя
    {   цел i;

        if (NEWTEMPMANGLE && p[1] == '$')       // if template имя
            goto L1;
        for (i = 0; i < oparray.length; i++)
        {   if (strcmp(p,oparray[i].ткст) == 0)
            {   ткст0 s;

                strcpy(mangle.буф.ptr, "operator ");
                switch (oparray[i].oper)
                {   case OPanew:
                        s = "new[]";
                        break;
                    case OPadelete:
                        s = "delete[]";
                        break;
                    case OPdelete:
                        s = "delete";
                        break;
                    default:
                        s = oparray[i].pretty.ptr;
                        break;
                }
                strcat(mangle.буф.ptr,s);
                p = mangle.буф.ptr;
                break;
            }
        }
    }
    //printf("-cpp_unmangleident() = '%s'\n", p);
    return cast(сим *)p;
}
}

/****************************************
 * Find index in oparray[] for operator.
 * Возвращает:
 *      index or -1 if not found
 */

version (SCPPorHTOD)
{

цел cpp_opidx(цел op)
{   цел i;

    for (i = 0; i < oparray.length; i++)
        if (oparray[i].oper == op)
            return i;
    return -1;
}

}

/***************************************
 * Find идентификатор ткст associated with operator.
 * Возвращает:
 *      null if not found
 */

version (SCPPorHTOD)
{

сим *cpp_opident(цел op)
{   цел i;

    i = cpp_opidx(op);
    return (i == -1) ? null : cast(сим*)oparray[i].ткст;
}

}

/**********************************
 * Convert from operator token to имя.
 * Output:
 *      *poper  OPxxxx
 *      *pt     set to тип for user defined conversion
 * Возвращает:
 *      pointer to corresponding имя
 */

version (SCPPorHTOD)
{

сим *cpp_operator(цел *poper,тип **pt)
{
    цел i;
    тип *typ_spec;
    сим *s;

    *pt = null;
    stoken();                           /* skip over operator keyword   */
    for (i = 0; i < oparray.length; i++)
    {   if (oparray[i].tokn == tok.TKval)
            goto L1;
    }

    /* Look for тип conversion */
    if (type_specifier(&typ_spec))
    {   тип *t;

        t = ptr_operator(typ_spec);     // parse ptr-operator
        fixdeclar(t);
        type_free(typ_spec);
        *pt = t;
        return cpp_typetostring(t,cast(сим*)"?B".ptr);
    }

    cpperr(EM_not_overloadable);        // that token cannot be overloaded
    s = cast(сим*)"_".ptr;
    goto L2;

L1:
    s = cast(сим*)oparray[i].ткст;
    *poper = oparray[i].oper;
    switch (*poper)
    {   case OPcall:
            if (stoken() != TKrpar)
                synerr(EM_rpar);                /* ')' expected                 */
            break;

        case OPbrack:
            if (stoken() != TKrbra)
                synerr(EM_rbra);                /* ']' expected                 */
            break;

        case OPnew:
            if (stoken() != TKlbra)
                goto Lret;
            *poper = OPanew;            // operator new[]
            s = cpp_name_anew.ptr;
            goto L3;

        case OPdelete:
            if (stoken() != TKlbra)
                goto Lret;
            *poper = OPadelete;         // operator delete[]
            s = cpp_name_adelete.ptr;
        L3:
            if (stoken() != TKrbra)
                synerr(EM_rbra);                // ']' expected
            if (!(config.flags4 & CFG4anew))
            {   cpperr(EM_enable_anew);         // throw -Aa to support this
                config.flags4 |= CFG4anew;
            }
            break;

        default:
            break;
    }
L2:
    stoken();
Lret:
    return s;
}

/******************************************
 * Alternate version that works on a list of token's.
 * Input:
 *      to      list of tokens
 * Output:
 *      *pcastoverload  1 if user defined тип conversion
 */

сим *cpp_operator2(token_t *to, цел *pcastoverload)
{
    цел i;
    сим *s;
    token_t *tn;
    цел oper;

    *pcastoverload = 0;
    if (!to || !to.TKnext)
        return null;

    for (i = 0; i < oparray.length; i++)
    {
        //printf("[%d] %d, %d\n", i, oparray[i].tokn, tok.TKval);
        if (oparray[i].tokn == to.TKval)
            goto L1;
    }

    //printf("cpp_operator2(): castoverload\n");
    *pcastoverload = 1;
    return null;

L1:
    tn = to.TKnext;
    s = cast(сим*)oparray[i].ткст;
    oper = oparray[i].oper;
    switch (oper)
    {   case OPcall:
            if (tn.TKval != TKrpar)
                synerr(EM_rpar);        // ')' expected
            break;

        case OPbrack:
            if (tn.TKval != TKrbra)
                synerr(EM_rbra);        // ']' expected
            break;

        case OPnew:
            if (tn.TKval != TKlbra)
                break;
            oper = OPanew;              // operator new[]
            s = cpp_name_anew.ptr;
            goto L3;

        case OPdelete:
            if (tn.TKval != TKlbra)
                break;
            oper = OPadelete;           // operator delete[]
            s = cpp_name_adelete.ptr;
        L3:
            if (tn.TKval != TKrbra)
                synerr(EM_rbra);                // ']' expected
            if (!(config.flags4 & CFG4anew))
            {   cpperr(EM_enable_anew);         // throw -Aa to support this
                config.flags4 |= CFG4anew;
            }
            break;

        default:
            break;
    }
    return s;
}

}

/***********************************
 * Generate and return a pointer to a ткст constructed from
 * the тип, appended to the префикс.
 * Since these generated strings determine the uniqueness of имена,
 * they are also используется to determine if two types are the same.
 * Возвращает:
 *      pointer to static имя[]
 */

сим *cpp_typetostring(тип *t,сим *префикс)
{   цел i;

    if (префикс)
    {   strcpy(mangle.буф.ptr,префикс);
        i = cast(цел)strlen(префикс);
    }
    else
        i = 0;
    //dbg_printf("cpp_typetostring:\n");
    //type_print(t);
    MangleInuse m;
    mangle.znamei = 0;
    mangle.argi = 0;
    mangle.np = mangle.буф.ptr + i;
    mangle.буф[BUFIDMAX + 1] = 0x55;
    cpp_data_type(t);
    *mangle.np = 0;                     // 0-terminate mangle.буф[]
    //dbg_printf("cpp_typetostring: '%s'\n", mangle.буф);
    assert(strlen(mangle.буф.ptr) <= BUFIDMAX);
    assert(mangle.буф[BUFIDMAX + 1] == 0x55);
    return mangle.буф.ptr;
}

version (Dinrus) { } else
{

/********************************
 * 'Mangle' a имя for output.
 * Возвращает:
 *      pointer to mangled имя (a static буфер)
 */

сим *cpp_mangle(Symbol *s)
{
    symbol_debug(s);
    //printf("cpp_mangle(s = %p, '%s')\n", s, s.Sident);
    //type_print(s.Stype);

version (SCPPorHTOD)
{
    if (!CPP)
        return symbol_ident(s);
}

    if (type_mangle(s.Stype) != mTYman_cpp)
        return symbol_ident(s);
    else
    {
        MangleInuse m;

        mangle.znamei = 0;
        mangle.argi = 0;
        mangle.np = mangle.буф.ptr;
        mangle.буф[BUFIDMAX + 1] = 0x55;
        cpp_decorated_name(s);
        *mangle.np = 0;                 // 0-terminate cpp_name[]
        //dbg_printf("cpp_mangle() = '%s'\n", mangle.буф);
        assert(strlen(mangle.буф.ptr) <= BUFIDMAX);
        assert(mangle.буф[BUFIDMAX + 1] == 0x55);
        return mangle.буф.ptr;
    }
}

}
///////////////////////////////////////////////////////

/*********************************
 * Add сим into cpp_name[].
 */

private проц CHAR(цел c)
{
    if (mangle.np < &mangle.буф[BUFIDMAX])
        *mangle.np++ = cast(сим)c;
}

/*********************************
 * Add сим into cpp_name[].
 */

private проц STR(ткст0 p)
{
    т_мера len;

    len = strlen(p);
    if (mangle.np + len <= &mangle.буф[BUFIDMAX])
    {   memcpy(mangle.np,p,len);
        mangle.np += len;
    }
    else
        for (; *p; p++)
            CHAR(*p);
}

/***********************************
 * Convert const volatile combinations into 0..3
 */

private цел cpp_cvidx(tym_t ty)
{   цел i;

    i  = (ty & mTYconst) ? 1 : 0;
    i |= (ty & mTYvolatile) ? 2 : 0;
    return i;
}

/******************************
 * Turn защита into 0..2
 */

private цел cpp_protection(Symbol *s)
{   цел i;

    switch (s.Sflags & SFLpmask)
    {   case SFLprivate:        i = 0;  break;
        case SFLprotected:      i = 1;  break;
        case SFLpublic:         i = 2;  break;
        default:
            symbol_print(s);
            assert(0);
    }
    return i;
}

/***********************************
 * Create mangled имя for template instantiation.
 */

version (SCPPorHTOD)
{

сим *template_mangle(Symbol *s,param_t *arglist)
{
    /*  mangling ::= '$' template_name { тип | expr }
        тип ::= "T" mangled тип
        expr ::= integer | ткст | address | float | double | long_double
        integer ::= "I" dimension
        ткст ::= "S" ткст
        address ::= "R" zname
        float ::= "F" hex_digits
        double ::= "D" hex_digits
        long_double ::= "L" hex_digits
     */
    param_t *p;

    assert(s);
    symbol_debug(s);
    //assert(s.Sclass == SCtemplate);

    //printf("\ntemplate_mangle(s = '%s', arglist = %p)\n", s.Sident, arglist);
    //arglist.print_list();

    MangleInuse m;
    mangle.znamei = 0;
    mangle.argi = 0;
    mangle.np = mangle.буф.ptr;
    mangle.буф[BUFIDMAX + 1] = 0x55;

    if (NEWTEMPMANGLE)
        STR("?$");
    else
        CHAR('$');

    // BUG: this is for templates nested inside class scopes.
    // Need to check if it creates имена that are properly unmanglable.
    cpp_zname(s.Sident.ptr);
    if (s.Sscope)
        cpp_scope(s.Sscope);

    for (p = arglist; p; p = p.Pnext)
    {
        if (p.Ptype)
        {   /* Argument is a тип       */
            if (!NEWTEMPMANGLE)
                CHAR('T');
            cpp_argument_list(p.Ptype, 1);
        }
        else if (p.Psym)
        {
            CHAR('V');  // this is a 'class' имя, but it should be a 'template' имя
            cpp_ecsu_name(p.Psym);
        }
        else
        {   /* Argument is an Выражение        */
            elem *e = p.Pelem;
            tym_t ty = tybasic(e.ET.Tty);
            сим *p2;
            сим[2] a = проц;
            цел ni;
            сим c;

        L2:
            switch (e.Eoper)
            {   case OPconst:
                    switch (ty)
                    {   case TYfloat:   ni = FLOATSIZE;  c = 'F'; goto L1;
                        case TYdouble_alias:
                        case TYdouble:  ni = DOUBLESIZE; c = 'D'; goto L1;
                        case TYldouble: ni = tysize(TYldouble); c = 'L'; goto L1;
                        L1:
                            if (NEWTEMPMANGLE)
                                CHAR('$');
                            CHAR(c);
                            p2 = cast(сим *)&e.EV.Vdouble;
                            while (ni--)
                            {   сим ch;
                                static const сим[16] hex = "0123456789ABCDEF";

                                ch = *p2++;
                                CHAR(hex[ch & 15]);
                                CHAR(hex[(ch >> 4) & 15]);
                            }
                            break;
                        default:
debug
{
                            if (!tyintegral(ty) && !tymptr(ty))
                                elem_print(e);
}
                            assert(tyintegral(ty) || tymptr(ty));
                            if (NEWTEMPMANGLE)
                                STR("$0");
                            else
                                CHAR('I');
                            cpp_dimension(el_tolongt(e));
                            break;
                    }
                    break;
                case OPstring:
                    if (NEWTEMPMANGLE)
                        STR("$S");
                    else
                        CHAR('S');
                    if (e.EV.Voffset)
                        synerr(EM_const_init);          // constant инициализатор expected
                    cpp_string(e.EV.Vstring,e.EV.Vstrlen);
                    break;
                case OPrelconst:
                    if (e.EV.Voffset)
                        synerr(EM_const_init);          // constant инициализатор expected
                    s = e.EV.Vsym;
                    if (NEWTEMPMANGLE)
                    {   STR("$1");
                        cpp_decorated_name(s);
                    }
                    else
                    {   CHAR('R');
                        cpp_zname(s.Sident.ptr);
                    }
                    break;
                case OPvar:
                    if (e.EV.Vsym.Sflags & SFLvalue &&
                        tybasic(e.ET.Tty) != TYstruct)
                    {
                        e = e.EV.Vsym.Svalue;
                        goto L2;
                    }
                    else if (e.EV.Vsym.Sclass == SCconst /*&&
                             pstate.STintemplate*/)
                    {
                        CHAR('V');              // pretend to be a class имя
                        cpp_zname(e.EV.Vsym.Sident.ptr);
                        break;
                    }
                    goto default;

                default:
version (SCPPorHTOD)
{
debug
{
                    if (!errcnt)
                        elem_print(e);
}
                    synerr(EM_const_init);              // constant инициализатор expected
                    assert(errcnt);
}
                    break;
            }
        }
    }
    *mangle.np = 0;
    //printf("template_mangle() = '%s'\n", mangle.буф);
    assert(strlen(mangle.буф.ptr) <= BUFIDMAX);
    assert(mangle.буф[BUFIDMAX + 1] == 0x55);
    return mangle.буф.ptr;
}

}

//////////////////////////////////////////////////////
// Functions corresponding to the имя mangling grammar in the
// "Microsoft Object Mapping Specification"

private проц cpp_string(сим *s,т_мера len)
{   сим c;

    for (; --len; s++)
    {   static const сим[11] special_char = ",/\\:. \n\t'-";
        сим *p;

        c = *s;
        if (c & 0x80 && isalpha(c & 0x7F))
        {   CHAR('?');
            c &= 0x7F;
        }
        else if (isalnum(c))
        { }
        else
        {
            CHAR('?');
            if ((p = cast(сим *)strchr(special_char.ptr,c)) != null)
                c = cast(сим)('0' + (p - special_char.ptr));
            else
            {
                CHAR('$');
                CHAR('A' + ((c >> 4) & 0x0F));
                c = 'A' + (c & 0x0F);
            }
        }
        CHAR(c);
    }
    CHAR('@');
}

private проц cpp_dimension(targ_ullong u)
{
    if (u && u <= 10)
        CHAR('0' + cast(сим)u - 1);
    else
    {   сим[u.sizeof * 2 + 1] буфер = проц;
        сим *p;

        буфер[буфер.length - 1] = 0;
        for (p = &буфер[буфер.length - 1]; u; u >>= 4)
        {
            *--p = 'A' + (u & 0x0F);
        }
        STR(p);
        CHAR('@');
    }
}

static if (0)
{
private проц cpp_dimension_ld(targ_ldouble ld)
{   ббайт[targ_ldouble.sizeof] ldbuf = проц;

    memcpy(ldbuf.ptr,&ld,ld.sizeof);
    if (u && u <= 10)
        CHAR('0' + cast(сим)u - 1);
    else
    {   сим[u.sizeof * 2 + 1] буфер = проц;
        сим *p;

        буфер[буфер.length - 1] = 0;
        for (p = &буфер[буфер.length - 1]; u; u >>= 4)
        {
            *--p = 'A' + (u & 0x0F);
        }
        STR(p);
        CHAR('@');
    }
}
}

private проц cpp_enum_name(Symbol *s)
{   тип *t;
    сим c;

    t = tstypes[TYint];
    switch (tybasic(t.Tty))
    {
        case TYschar:   c = '0';        break;
        case TYuchar:   c = '1';        break;
        case TYshort:   c = '2';        break;
        case TYushort:  c = '3';        break;
        case TYint:     c = '4';        break;
        case TYuint:    c = '5';        break;
        case TYlong:    c = '6';        break;
        case TYulong:   c = '7';        break;
        default:        assert(0);
    }
    CHAR(c);
    cpp_ecsu_name(s);
}

private проц cpp_reference_data_type(тип *t, цел флаг)
{
    if (tybasic(t.Tty) == TYarray)
    {
        цел ndim;
        тип *tn;
        цел i;

        CHAR('Y');

        // Compute number of dimensions (we have at least one)
        ndim = 0;
        tn = t;
        do
        {   ndim++;
            tn = tn.Tnext;
        } while (tybasic(tn.Tty) == TYarray);

        cpp_dimension(ndim);
        for (; tybasic(t.Tty) == TYarray; t = t.Tnext)
        {
            if (t.Tflags & TFvla)
                CHAR('X');                      // DMC++ extension
            else
                cpp_dimension(t.Tdim);
        }

        // DMC++ extension
        if (флаг)                       // if template тип argument
        {
            i = cpp_cvidx(t.Tty);
            if (i)
            {   CHAR('_');
                //CHAR('X' + i - 1);            // _X, _Y, _Z
                CHAR('O' + i - 1);              // _O, _P, _Q
            }
        }

        cpp_basic_data_type(t);
    }
    else
        cpp_basic_data_type(t);
}

private проц cpp_pointer_data_type(тип *t)
{
    if (tybasic(t.Tty) == TYvoid)
        CHAR('X');
    else
        cpp_reference_data_type(t, 0);
}

private проц cpp_ecsu_data_type(тип *t)
{   сим c;
    Symbol *stag;
    цел i;

    type_debug(t);
    switch (tybasic(t.Tty))
    {
        case TYstruct:
            stag = t.Ttag;
            switch (stag.Sstruct.Sflags & (STRclass | STRunion))
            {   case 0:         c = 'U';        break;
                case STRunion:  c = 'T';        break;
                case STRclass:  c = 'V';        break;
                default:
                    assert(0);
            }
            CHAR(c);
            cpp_ecsu_name(stag);
            break;
        case TYenum:
            CHAR('W');
            cpp_enum_name(t.Ttag);
            break;
        default:
            debug
            type_print(t);

            assert(0);
    }
}

private проц cpp_basic_data_type(тип *t)
{   сим c;
    цел i;

    //printf("cpp_basic_data_type(t)\n");
    //type_print(t);
    switch (tybasic(t.Tty))
    {
        case TYschar:   c = 'C';        goto dochar;
        case TYchar:    c = 'D';        goto dochar;
        case TYuchar:   c = 'E';        goto dochar;
        case TYshort:   c = 'F';        goto dochar;
        case TYushort:  c = 'G';        goto dochar;
        case TYint:     c = 'H';        goto dochar;
        case TYuint:    c = 'I';        goto dochar;
        case TYlong:    c = 'J';        goto dochar;
        case TYulong:   c = 'K';        goto dochar;
        case TYfloat:   c = 'M';        goto dochar;
        case TYdouble:  c = 'N';        goto dochar;

        case TYdouble_alias:
                        if (_tysize[TYint] == 4)
                        {   c = 'O';
                            goto dochar;
                        }
                        c = 'Z';
                        goto dochar2;

        case TYldouble:
                        if (_tysize[TYint] == 2)
                        {   c = 'O';
                            goto dochar;
                        }
                        c = 'Z';
                        goto dochar2;
        dochar:
            CHAR(c);
            break;

        case TYllong:   c = 'J';        goto dochar2;
        case TYullong:  c = 'K';        goto dochar2;
        case TYбул:    c = 'N';        goto dochar2;   // was 'X' prior to 8.1b8
        case TYwchar_t:
            if (config.flags4 & CFG4nowchar_t)
            {
                c = 'G';
                goto dochar;    // same as TYushort
            }
            else
            {
                pstate.STflags |= PFLmfc;
                c = 'Y';
                goto dochar2;
            }

        // Digital Mars extensions
        case TYifloat:  c = 'R';        goto dochar2;
        case TYidouble: c = 'S';        goto dochar2;
        case TYildouble: c = 'T';       goto dochar2;
        case TYcfloat:  c = 'U';        goto dochar2;
        case TYcdouble: c = 'V';        goto dochar2;
        case TYcldouble: c = 'W';       goto dochar2;

        case TYchar16:   c = 'X';       goto dochar2;
        case TYdchar:    c = 'Y';       goto dochar2;
        case TYnullptr:  c = 'Z';       goto dochar2;

        dochar2:
            CHAR('_');
            goto dochar;

        case TYsptr:
        case TYcptr:
        case TYf16ptr:
        case TYfptr:
        case TYhptr:
        case TYvptr:
        case TYmemptr:
        case TYnptr:
        case TYimmutPtr:
        case TYsharePtr:
        case TYfgPtr:
            c = cast(сим)('P' + cpp_cvidx(t.Tty));
            CHAR(c);
            if(I64)
                CHAR('E'); // __ptr64 modifier
            cpp_pointer_type(t);
            break;
        case TYstruct:
        case TYenum:
            cpp_ecsu_data_type(t);
            break;
        case TYarray:
            i = cpp_cvidx(t.Tty);
            i |= 1;                     // always const
            CHAR('P' + i);
            cpp_pointer_type(t);
            break;
        case TYvoid:
            c = 'X';
            goto dochar;
version (SCPPorHTOD)
{
        case TYident:
            if (pstate.STintemplate)
            {
                CHAR('V');              // pretend to be a class имя
                cpp_zname(t.Tident);
            }
            else
            {
version (SCPPorHTOD)
{
                cpperr(EM_no_type,t.Tident);   // no тип for argument
}
                c = 'X';
                goto dochar;
            }
            break;
        case TYtemplate:
            if (pstate.STintemplate)
            {
                CHAR('V');              // pretend to be a class имя
                cpp_zname((cast(typetemp_t *)t).Tsym.Sident.ptr);
            }
            else
                goto Ldefault;
            break;
}

        default:
        Ldefault:
            if (tyfunc(t.Tty))
                cpp_function_type(t);
            else
            {
version (SCPPorHTOD)
{
                debug
                if (!errcnt)
                    type_print(t);
                assert(errcnt);
}
            }
    }
}

private проц cpp_function_indirect_type(тип *t)
{   цел farfunc;

    farfunc = tyfarfunc(t.Tnext.Tty) != 0;
version (SCPPorHTOD)
{
    if (tybasic(t.Tty) == TYmemptr)
    {
        CHAR('8' + farfunc);
        cpp_scope(t.Ttag);
        CHAR('@');
        //cpp_this_type(t.Tnext,t.Ttag);      // MSC doesn't do this
    }
    else
        CHAR('6' + farfunc);
}
else
    CHAR('6' + farfunc);
}

private проц cpp_data_indirect_type(тип *t)
{   цел i;
version (SCPPorHTOD)
{
    if (tybasic(t.Tty) == TYmemptr)    // if pointer to member
    {
        i = cpp_cvidx(t.Tty);
        if (t.Tty & mTYfar)
            i += 4;
        CHAR('Q' + i);
        cpp_scope(t.Ttag);
        CHAR('@');
    }
    else
        cpp_ecsu_data_indirect_type(t);
}
else
{
    cpp_ecsu_data_indirect_type(t);
}
}

private проц cpp_ecsu_data_indirect_type(тип *t)
{   цел i;
    tym_t ty;

    i = 0;
    if (t.Tnext)
    {   ty = t.Tnext.Tty & (mTYconst | mTYvolatile);
        switch (tybasic(t.Tty))
        {
            case TYfptr:
            case TYvptr:
            case TYfref:
                ty |= mTYfar;
                break;

            case TYhptr:
                i += 8;
                break;
            case TYref:
            case TYarray:
                if (LARGEDATA && !(ty & mTYLINK))
                    ty |= mTYfar;
                break;

            default:
                break;
        }
    }
    else
        ty = t.Tty & (mTYLINK | mTYconst | mTYvolatile);
    i |= cpp_cvidx(ty);
    if (ty & (mTYcs | mTYfar))
        i += 4;
    CHAR('A' + i);
}

private проц cpp_pointer_type(тип *t)
{   tym_t ty;

    if (tyfunc(t.Tnext.Tty))
    {
        cpp_function_indirect_type(t);
        cpp_function_type(t.Tnext);
    }
    else
    {
        cpp_data_indirect_type(t);
        cpp_pointer_data_type(t.Tnext);
    }
}

private проц cpp_reference_type(тип *t)
{
    cpp_data_indirect_type(t);
    cpp_reference_data_type(t.Tnext, 0);
}

private проц cpp_primary_data_type(тип *t)
{
    if (tyref(t.Tty))
    {
static if (1)
{
        // C++98 8.3.2 says cv-qualified references are ignored
        CHAR('A');
}
else
{
        switch (t.Tty & (mTYconst | mTYvolatile))
        {
            case 0:                      CHAR('A');     break;
            case mTYvolatile:            CHAR('B');     break;

            // Digital Mars extensions
            case mTYconst | mTYvolatile: CHAR('_'); CHAR('L');  break;
            case mTYconst:               CHAR('_'); CHAR('M');  break;

            default:
                break;
        }
}
        cpp_reference_type(t);
    }
    else
        cpp_basic_data_type(t);
}

/*****
 * флаг: 1 = template argument
 */

private проц cpp_argument_list(тип *t, цел флаг)
{   цел i;
    tym_t ty;

    //printf("cpp_argument_list(флаг = %d)\n", флаг);
    // If a данные тип that encodes only into one character
    ty = tybasic(t.Tty);
    if (ty <= TYldouble && ty != TYenum
        && ty != TYбул         // added for versions >= 8.1b9
        && !(t.Tty & (mTYconst | mTYvolatile))
       )
    {
        cpp_primary_data_type(t);
    }
    else
    {
        // See if a match with a previously используется тип
        for (i = 0; 1; i++)
        {
            if (i == mangle.argi)               // no match
            {
                if (ty <= TYcldouble || ty == TYstruct)
                {
                    цел cvidx = cpp_cvidx(t.Tty);
                    if (cvidx)
                    {
                        // Digital Mars extensions
                        CHAR('_');
                        CHAR('N' + cvidx);      // _O, _P, _Q префикс
                    }
                }
                if (флаг && tybasic(t.Tty) == TYarray)
                {
                   cpp_reference_data_type(t, флаг);
                }
                else
                    cpp_primary_data_type(t);
                if (mangle.argi < 10)
                    mangle.arg[mangle.argi++] = t;
                break;
            }
            if (typematch(t,mangle.arg[i],0))
            {
                CHAR('0' + i);          // argument_replicator
                break;
            }
        }
    }
}

private проц cpp_argument_types(тип *t)
{   param_t *p;
    сим c;

    //printf("cpp_argument_types()\n");
    //type_debug(t);
    for (p = t.Tparamtypes; p; p = p.Pnext)
        cpp_argument_list(p.Ptype, 0);
    if (t.Tflags & TFfixed)
        c = t.Tparamtypes ? '@' : 'X';
    else
        c = 'Z';
    CHAR(c);
}

private проц cpp_calling_convention(тип *t)
{   сим c;

    switch (tybasic(t.Tty))
    {
        case TYnfunc:
        case TYhfunc:
        case TYffunc:
            c = 'A';        break;
        case TYf16func:
        case TYfpfunc:
        case TYnpfunc:
            c = 'C';        break;
        case TYnsfunc:
        case TYfsfunc:
            c = 'G';        break;
        case TYjfunc:
        case TYmfunc:
        case TYnsysfunc:
        case TYfsysfunc:
            c = 'E';       break;
        case TYifunc:
            c = 'K';        break;
        default:
            assert(0);
    }
    CHAR(c);
}

private проц cpp_vcall_model_type()
{
}

version (SCPPorMARS)
{

private проц cpp_this_type(тип *tfunc,Classsym *stag)
{   тип *t;

    type_debug(tfunc);
    symbol_debug(stag);

version (Dinrus)
    t = type_pointer(stag.Stype);
else
    t = cpp_thistype(tfunc,stag);

    //cpp_data_indirect_type(t);
    cpp_ecsu_data_indirect_type(t);
    type_free(t);
}

}

private проц cpp_storage_convention(Symbol *s)
{   tym_t ty;
    тип *t = s.Stype;

    ty = t.Tty;
    if (LARGEDATA && !(ty & mTYLINK))
        t.Tty |= mTYfar;
    cpp_data_indirect_type(t);
    t.Tty = ty;
}

private проц cpp_data_type(тип *t)
{
    type_debug(t);
    switch (tybasic(t.Tty))
    {   case TYvoid:
            CHAR('X');
            break;
        case TYstruct:
        case TYenum:
            CHAR('?');
            cpp_ecsu_data_indirect_type(t);
            cpp_ecsu_data_type(t);
            break;
        default:
            cpp_primary_data_type(t);
            break;
    }
}

private проц cpp_return_type(Symbol *s)
{
    if (s.Sfunc.Fflags & (Fctor | Fdtor))     // if ctor or dtor
        CHAR('@');                              // no тип
    else
        cpp_data_type(s.Stype.Tnext);
}

private проц cpp_ecsu_name(Symbol *s)
{
    //printf("cpp_ecsu_name(%s)\n", symbol_ident(s));
    cpp_zname(symbol_ident(s));
version (SCPPorMARS)
{
    if (s.Sscope)
        cpp_scope(s.Sscope);
}
    CHAR('@');
}

private проц cpp_throw_types(тип *t)
{
    //cpp_argument_types(?);
    CHAR('Z');
}

private проц cpp_function_type(тип *t)
{   tym_t ty;
    тип *tn;

    //printf("cpp_function_type()\n");
    //type_debug(t);
    assert(tyfunc(t.Tty));
    cpp_calling_convention(t);
    //cpp_return_type(s);
    tn = t.Tnext;
    ty = tn.Tty;
    if (LARGEDATA && (tybasic(ty) == TYstruct || tybasic(ty) == TYenum) &&
        !(ty & mTYLINK))
        tn.Tty |= mTYfar;
    cpp_data_type(tn);
    tn.Tty = ty;
    cpp_argument_types(t);
    cpp_throw_types(t);
}

private проц cpp_adjustor_thunk_type(Symbol *s)
{
}

private проц cpp_vftable_type(Symbol *s)
{
    cpp_ecsu_data_indirect_type(s.Stype);
//      vpath_name();
    CHAR('@');
}

private проц cpp_local_static_data_type(Symbol *s)
{
    //cpp_lexical_frame(?);
    cpp_external_data_type(s);
}

private проц cpp_static_member_data_type(Symbol *s)
{
    cpp_external_data_type(s);
}

private проц cpp_static_member_function_type(Symbol *s)
{
    cpp_function_type(s.Stype);
}

version (SCPPorMARS)
{
private проц cpp_member_function_type(Symbol *s)
{
    assert(tyfunc(s.Stype.Tty));
    cpp_this_type(s.Stype,cast(Classsym *)s.Sscope);
    if (s.Sfunc.Fflags & (Fctor | Fdtor))
    {   тип *t = s.Stype;

        cpp_calling_convention(t);
        CHAR('@');                      // return_type for ctors & dtors
        cpp_argument_types(t);
        cpp_throw_types(t);
    }
    else
        cpp_static_member_function_type(s);
}
}

private проц cpp_external_data_type(Symbol *s)
{
    cpp_primary_data_type(s.Stype);
    cpp_storage_convention(s);
}

private проц cpp_external_function_type(Symbol *s)
{
    cpp_function_type(s.Stype);
}

private проц cpp_type_encoding(Symbol *s)
{   сим c;

    //printf("cpp_type_encoding()\n");
    if (tyfunc(s.Stype.Tty))
    {   цел farfunc;

        farfunc = tyfarfunc(s.Stype.Tty) != 0;
version (SCPPorMARS)
{
        if (isclassmember(s))
        {   // Member function
            цел защита;
            цел ftype;

            защита = cpp_protection(s);
            if (s.Sfunc.Fthunk && !(s.Sfunc.Fflags & Finstance))
                ftype = 3;
            else
                switch (s.Sfunc.Fflags & (Fvirtual | Fstatic))
                {   case Fvirtual:      ftype = 2;      break;
                    case Fstatic:       ftype = 1;      break;
                    case 0:             ftype = 0;      break;
                    default:            assert(0);
                }
            CHAR('A' + farfunc + защита * 8 + ftype * 2);
            switch (ftype)
            {   case 0: cpp_member_function_type(s);            break;
                case 1: cpp_static_member_function_type(s);     break;
                case 2: cpp_member_function_type(s);            break;
                case 3: cpp_adjustor_thunk_type(s);             break;
                default:
                    break;
            }
        }
        else
        {   // Non-member function
            CHAR('Y' + farfunc);
            cpp_external_function_type(s);
        }
}
else
{
        // Non-member function
        CHAR('Y' + farfunc);
        cpp_external_function_type(s);
}
    }
    else
    {
version (SCPPorMARS)
{
        if (isclassmember(s))
        {
            // Static данные member
            CHAR(cpp_protection(s) + '0');
            cpp_static_member_data_type(s);
        }
        else
        {
            if (s.Sclass == SCstatic ||
                (s.Sscope &&
                 s.Sscope.Sclass != SCstruct &&
                 s.Sscope.Sclass != SCnamespace))
            {
                CHAR('4');
                cpp_local_static_data_type(s);
            }
            else
            {
                CHAR('3');
                cpp_external_data_type(s);
            }
        }
}
else
{
        if (s.Sclass == SCstatic)
        {
            CHAR('4');
            cpp_local_static_data_type(s);
        }
        else
        {
            CHAR('3');
            cpp_external_data_type(s);
        }
}
    }
}

private проц cpp_scope(Symbol *s)
{
    /*  scope ::=
                zname [ scope ]
                '?' decorated_name [ scope ]
                '?' lexical_frame [ scope ]
                '?' '$' template_name [ scope ]
     */
    while (s)
    {   сим *p;

        symbol_debug(s);
        switch (s.Sclass)
        {
            case SCnamespace:
                cpp_zname(s.Sident.ptr);
                break;

            case SCstruct:
                cpp_zname(symbol_ident(s));
                break;

            default:
                STR("?1?");                     // Why? Who knows.
                cpp_decorated_name(s);
                break;
        }

version (SCPPorMARS)
        s = s.Sscope;
else
        break;

    }
}

private проц cpp_zname(ткст0 p)
{
    //printf("cpp_zname(%s)\n", p);
    if (*p != '?' ||                            // if not operator_name
        (NEWTEMPMANGLE && p[1] == '$'))         // ?$ is a template имя
    {
version (Dinrus)
{
        /* Scan forward past any dots
         */
        for (ткст0 q = p; *q; q++)
        {
            if (*q == '.')
                p = q + 1;
        }
}

        for (цел i = 0; i < mangle.znamei; i++)
        {
            if (strcmp(p,mangle.zname[i]) == 0)
            {   CHAR('0' + i);
                return;
            }
        }
        if (mangle.znamei < 10)
            mangle.zname[mangle.znamei++] = p;
        STR(p);
        CHAR('@');
    }
    else if (p[1] == 'B')
        STR("?B");                      // skip return значение encoding
    else
    {
        STR(p);
    }
}

private проц cpp_symbol_name(Symbol *s)
{   сим *p;

    p = s.Sident.ptr;
version (SCPPorHTOD)
{
    if (tyfunc(s.Stype.Tty) && s.Sfunc)
    {
        if (s.Sfunc.Fflags & Finstance)
        {
            Mangle save = mangle;
            сим *q;
            цел len;

            p = template_mangle(s, s.Sfunc.Fptal);
            len = strlen(p);
            q = cast(сим *)alloca(len + 1);
            assert(q);
            memcpy(q, p, len + 1);
            mangle = save;
            p = q;
        }
        else if (s.Sfunc.Fflags & Foperator)
        {   // operator_name ::= '?' operator_code
            //CHAR('?');                        // already there
            STR(p);
            return;
        }
    }
}
version (none) //#if Dinrus && 0
{
    //It mangles correctly, but the ABI doesn't match,
    // leading to copious segfaults. At least with the
    // wrong mangling you get link errors.
    if (tyfunc(s.Stype.Tty) && s.Sfunc)
    {
        if (s.Sfunc.Fflags & Fctor)
        {
            cpp_zname(cpp_name_ct);
            return;
        }
        if (s.Sfunc.Fflags & Fdtor)
        {
            cpp_zname(cpp_name_dt);
            return;
        }
    }
}
    cpp_zname(p);
}

private проц cpp_decorated_name(Symbol *s)
{   сим *p;

    CHAR('?');
    cpp_symbol_name(s);
version (SCPPorMARS)
{
    if (s.Sscope)
        cpp_scope(s.Sscope);
}
    CHAR('@');
    cpp_type_encoding(s);
}

/*********************************
 * Mangle a vtbl or vbtbl имя.
 * Возвращает:
 *      pointer to generated symbol with mangled имя
 */

version (SCPPorHTOD)
{

Symbol *mangle_tbl(
        цел флаг,       // 0: vtbl, 1: vbtbl
        тип *t,        // тип for symbol
        Classsym *stag, // class we're putting tbl in
        baseclass_t *b) // base class (null if none)
{   ткст0 ид;
    Symbol *s;

static if (0)
{
    printf("mangle_tbl(stag = '%s', sbase = '%s', родитель = '%s')\n",
        stag.Sident.ptr,b ? b.BCbase.Sident.ptr : "null", b ? b.родитель.Sident.ptr : "null");
}
    if (флаг == 0)
        ид = config.flags3 & CFG3rtti ? "?_Q" : "?_7";
    else
        ид = "?_8";
    MangleInuse m;
    mangle.znamei = 0;
    mangle.argi = 0;
    mangle.np = mangle.буф.ptr;
    CHAR('?');
    cpp_zname(ид);
    cpp_scope(stag);
    CHAR('@');
    CHAR('6' + флаг);
    cpp_ecsu_data_indirect_type(t);
static if (1)
{
    while (b)
    {
        cpp_scope(b.BCbase);
        CHAR('@');
        b = b.BCpbase;
    }
}
else
{
    if (b)
    {   cpp_scope(b.BCbase);
        CHAR('@');
        // BUG: what if b is more than one уровень down?
        if (b.родитель != stag)
        {   cpp_scope(b.BCparent);
            CHAR('@');
        }
    }
}
    CHAR('@');
    *mangle.np = 0;                     // 0-terminate mangle.буф[]
    assert(strlen(mangle.буф.ptr) <= BUFIDMAX);
    s = scope_define(mangle.буф.ptr,SCTglobal | SCTnspace | SCTlocal,SCunde);
    s.Stype = t;
    t.Tcount++;
    return s;
}

}

}
