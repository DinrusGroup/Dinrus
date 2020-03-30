/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1985-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/el.d, backend/el.d)
 */

module drc.backend.el;

// Online documentation: https://dlang.org/phobos/dmd_backend_el.html

import drc.backend.cdef;
import drc.backend.cc;
import drc.backend.глоб2;
import drc.backend.oper;
import drc.backend.тип;

import drc.backend.cc : Symbol;

import drc.backend.dlist;
import util.longdouble : longdouble;

alias longdouble targ_ldouble;
alias drc.backend.ty.tym_t tym_t;

/*extern (C++):*/
/*:*/


/* Routines to handle elems.                            */

alias ббайт eflags_t;
enum
{
    EFLAGS_variadic = 1,   // variadic function call
}

alias бцел pef_flags_t;
enum
{
    PEFnotlvalue    = 1,       // although elem may look like
                               // an lvalue, it isn't
    PEFtemplate_id  = 0x10,    // symbol is a template-ид
    PEFparentheses  = 0x20,    // Выражение was within ()
    PEFaddrmem      = 0x40,    // address of member
    PEFdependent    = 0x80,    // значение-dependent
    PEFmember       = 0x100,   // was a class member access
}

alias ббайт nflags_t;
enum
{
    NFLli     = 1,     // loop invariant
    NFLnogoal = 2,     // evaluate elem for side effects only
    NFLassign = 8,     // unambiguous assignment elem
    NFLaecp   = 0x10,  // AE or CP or VBE Выражение
    NFLdelcse = 0x40,  // this is not the generating CSE
    NFLtouns  = 0x80,  // relational operator was changed from signed to unsigned
}

/******************************************
 * Elems:
 *      Elems are the basic tree element. They can be either
 *      terminal elems (leaves), unary elems (left subtree exists)
 *      or binary elems (left and right subtrees exist).
 */

struct elem
{
    debug ushort      ид;
    const IDelem = 0x4C45;   // 'EL'

    version (OSX) // workaround https://issues.dlang.org/show_bug.cgi?ид=16466
        align(16) eve EV; // variants for each тип of elem
    else
        eve EV;           // variants for each тип of elem

    ббайт Eoper;        // operator (OPxxxx)
    ббайт Ecount;       // # of parents of this elem - 1,
                        // always 0 until CSE elimination is done
    eflags_t Eflags;

    union
    {
        // PARSER
        struct
        {
            version (SCPP)
                Symbol* Emember;       // if PEFmember, this is the member
            version (HTOD)
                Symbol* Emember;       // if PEFmember, this is the member
            pef_flags_t PEFflags;
        }

        // OPTIMIZER
        struct
        {
            tym_t Ety;         // данные тип (TYxxxx)
            бцел Eexp;         // index into expnod[]
            бцел Edef;         // index into expdef[]

            // These flags are all temporary markers, используется once and then
            // thrown away.
            nflags_t Nflags;   // NFLxxx

            // Dinrus
            ббайт Ejty;        // original Mars тип
        }

        // CODGEN
        struct
        {
            // Ety2: Must be in same position as Ety!
            tym_t Ety2;        // данные тип (TYxxxx)
            ббайт Ecomsub;     // number of remaining references to
                               // this common subexp (используется to determine
                               // first, intermediate, and last references
                               // to a CSE)
        }
    }

    тип *ET;            // pointer to тип of elem if TYstruct | TYarray
    Srcpos Esrcpos;      // source файл position
}

проц elem_debug( elem* e)
{
    debug assert(e.ид == e.IDelem);
}

version (Dinrus)
    tym_t typemask( elem* e) { return e.Ety; }
else
    tym_t typemask( elem* e) { return PARSER ? e.ET.Tty : e.Ety; }

FL el_fl( elem* e) { return cast(FL)e.EV.Vsym.Sfl; }

//#define Eoffset         EV.sp.Voffset
//#define Esymnum         EV.sp.Vsymnum

elem* list_elem(inout list_t list) { return cast(elem*)list_ptr(list); }

проц list_setelem(list_t list, ук ptr) { list.ptr = cast(elem *)ptr; }

//#define cnst(e) ((e)->Eoper == OPconst) /* Determine if elem is a constant */
//#define E1        EV.eop.Eleft          /* left child                   */
//#define E2        EV.eop.Eright         /* right child                  */
//#define Erd       EV.sp.spu.Erd         // reaching definition

проц el_init();
проц el_reset();
проц el_term();
elem *el_calloc();
проц el_free(elem *);
elem *el_combine(elem *,elem *);
elem *el_param(elem *,elem *);
elem *el_params(elem *, ...);
elem *el_params(проц **args, цел length);
elem *el_combines(проц **args, цел length);
цел el_nparams(elem *e);
проц el_paramArray(elem ***parray, elem *e);
elem *el_pair(tym_t, elem *, elem *);
проц el_copy(elem *,elem *);
elem *el_alloctmp(tym_t);
elem *el_selecte1(elem *);
elem *el_selecte2(elem *);
elem *el_copytree(elem *);
проц  el_replace_sym(elem *e,Symbol *s1,Symbol *s2);
elem *el_scancommas(elem *);
цел el_countCommas(elem *);
цел el_sideeffect(elem *);
цел el_depends(elem *ea,elem *eb);
targ_llong el_tolongt(elem *);
targ_llong el_tolong(elem *);
бул el_allbits( elem*, цел);
бул el_signx32( elem *);
targ_ldouble el_toldouble(elem *);
проц el_toconst(elem *);
elem *el_same(elem **);
elem *el_copytotmp(elem **);
бул el_match( elem *,  elem *);
бул el_match2( elem *,  elem *);
бул el_match3( elem *,  elem *);
бул el_match4( elem *,  elem *);
бул el_match5( elem *,  elem *);
цел el_appears(elem *e,Symbol *s);
Symbol *el_basesym(elem *e);
бул el_anydef(elem *ed, elem *e);
elem* el_bint(OPER, тип*,elem*, elem*);
elem* el_unat(OPER, тип*, elem*);
elem* el_bin(OPER, tym_t, elem*, elem*);
elem* el_una(OPER, tym_t, elem*);
extern(C) elem *el_longt(тип *,targ_llong);
elem *el_settype(elem *,тип *);
elem *el_typesize(тип *);
elem *el_ptr_offset(Symbol *s,targ_т_мера смещение);
проц el_replacesym(elem *,Symbol *,Symbol *);
elem *el_nelems(тип *);

extern (C) elem *el_long(tym_t,targ_llong);

бул ERTOL(elem *);
бул el_returns(elem *);
//elem *el_dctor(elem *e,проц *decl);
//elem *el_ddtor(elem *e,проц *decl);
elem *el_ctor_dtor(elem *ec, elem *ed, elem **pedtor);
elem *el_ctor(elem *ector,elem *e,Symbol *sdtor);
elem *el_dtor(elem *edtor,elem *e);
elem *el_zero(тип *t);
elem *el_const(tym_t, eve *);
elem *el_test(tym_t, eve *);
elem ** el_parent(elem *,elem **);

//#ifdef DEBUG
//проц el_check(elem*);
//#else
//#define el_check(e)     ((проц)0)
//#endif

elem *el_convfloat(elem *);
elem *el_convstring(elem *);
elem *el_convert(elem *e);
бул el_isdependent(elem *);
бцел el_alignsize(elem *);

т_мера el_opN(elem *e, бцел op);
проц el_opArray(elem ***parray, elem *e, бцел op);
проц el_opFree(elem *e, бцел op);
extern (C) elem *el_opCombine(elem **args, т_мера length, бцел op, бцел ty);

проц elem_print( elem *, цел nestlevel = 0);
проц elem_print_const( elem *);
проц el_hydrate(elem **);
проц el_dehydrate(elem **);

// elpicpie.d
elem *el_var(Symbol *);
elem *el_ptr(Symbol *);

