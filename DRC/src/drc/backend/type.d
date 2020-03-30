/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1985-1998 by Symantec
 *              Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/тип.d, backend/_type.d)
 */

module drc.backend.тип;

// Online documentation: https://dlang.org/phobos/dmd_backend_type.html

import drc.backend.cdef;
import drc.backend.cc : block, Blockx, Classsym, Symbol, param_t;
import drc.backend.code;
import drc.backend.dlist;
import drc.backend.el : elem;
import drc.backend.ty;


alias drc.backend.ty.tym_t tym_t;

/*extern (C++):*/
/*:*/


// тип.h

alias  ббайт mangle_t;
enum
{
    mTYman_c      = 1,      // C mangling
    mTYman_cpp    = 2,      // C++ mangling
    mTYman_pas    = 3,      // Pascal mangling
    mTYman_for    = 4,      // FORTRAN mangling
    mTYman_sys    = 5,      // _syscall mangling
    mTYman_std    = 6,      // _stdcall mangling
    mTYman_d      = 7,      // D mangling
}

/// Values for Tflags:
alias  ushort type_flags_t;
enum
{
    TFprototype   = 1,      // if this function is prototyped
    TFfixed       = 2,      // if prototype has a fixed # of parameters
    TFgenerated   = 4,      // C: if we generated the prototype ourselves
    TFdependent   = 4,      // CPP: template dependent тип
    TFforward     = 8,      // TYstruct: if forward reference of tag имя
    TFsizeunknown = 0x10,   // TYstruct,TYarray: if size of тип is unknown
                            // TYmptr: the Stag is TYident тип
    TFfuncret     = 0x20,   // C++,tyfunc(): overload based on function return значение
    TFfuncparam   = 0x20,   // TYarray: top уровень function параметр
    TFhydrated    = 0x20,   // тип данные already hydrated
    TFstatic      = 0x40,   // TYarray: static dimension
    TFvla         = 0x80,   // TYarray: variable length массив
    TFemptyexc    = 0x100,  // tyfunc(): empty exception specification
}

alias  TYPE тип;

проц type_incCount(тип* t);
проц type_setIdent(тип* t, ткст0 идент);

проц symbol_struct_addField(Symbol* s, ткст0 имя, тип* t, бцел смещение);

// Return да if тип is a struct, class or union
бул type_struct( тип* t) { return tybasic(t.Tty) == TYstruct; }

struct TYPE
{
    debug ushort ид;
    const IDtype = 0x1234;

    tym_t Tty;     /* mask (TYxxx)                         */
    type_flags_t Tflags; // TFxxxxx

    mangle_t Tmangle; // имя mangling

    бцел Tcount; // # pointing to this тип
    ткст0 Tident; // TYident: идентификатор; TYdarray, TYaarray: pretty имя for debug info
    TYPE* Tnext; // следщ in list
                                // TYenum: gives base тип
    union
    {
        targ_т_мера Tdim;   // TYarray: # of elements in массив
        elem* Tel;          // TFvla: gives dimension (NULL if '*')
        param_t* Tparamtypes; // TYfunc, TYtemplate: types of function parameters
        Classsym* Ttag;     // TYstruct,TYmemptr: tag symbol
                            // TYenum,TYvtshape: tag symbol
        тип* Talternate;   // C++: typtr: тип of параметр before converting
        тип* Tkey;         // typtr: ключ тип for associative arrays
    }

    list_t Texcspec;        // tyfunc(): list of types of exception specification
    Symbol *Ttypedef;       // if this тип came from a typedef, this is
                            // the typedef symbol
}

struct typetemp_t
{
    TYPE Ttype;

    /* Tsym should really be part of a derived class, as we only
        размести room for it if TYtemplate
     */
    Symbol *Tsym;               // primary class template symbol
}

проц type_debug( тип* t)
{
    debug assert(t.ид == t.IDtype);
}

// Return имя mangling of тип
mangle_t type_mangle( тип *t) { return t.Tmangle; }

// Return да if function тип has a variable number of arguments
бул variadic( тип *t) { return (t.Tflags & (TFprototype | TFfixed)) == TFprototype; }

extern  тип*[TYMAX] tstypes;
extern  тип*[TYMAX] tsptr2types;

extern 
{
    тип* tslogical;
    тип* chartype;
    тип* tsclib;
    тип* tsdlib;
    тип* tspvoid;
    тип* tspcvoid;
    тип* tsptrdiff;
    тип* tssize;
    тип* tstrace;
}

/* Functions    */
проц type_print( тип* t);
проц type_free(тип *);
проц type_init();
проц type_term();
тип *type_copy(тип *);
elem *type_vla_fix(тип **pt);
тип *type_setdim(тип **,targ_т_мера);
тип *type_setdependent(тип *t);
цел type_isdependent(тип *t);
проц type_hydrate(тип **);
проц type_dehydrate(тип **);

version (SCPP)
    targ_т_мера type_size(тип *);
version (HTOD)
    targ_т_мера type_size(тип *);

targ_т_мера type_size( тип *);
бцел type_alignsize(тип *);
бул type_zeroSize(тип *t, tym_t tyf);
бцел type_parameterSize(тип *t, tym_t tyf);
бцел type_paramsize(тип *t);
тип *type_alloc(tym_t);
тип *type_alloc_template(Symbol *s);
тип *type_allocn(tym_t,тип *tn);
тип *type_allocmemptr(Classsym *stag,тип *tn);
тип *type_fake(tym_t);
тип *type_setty(тип **,бцел);
тип *type_settype(тип **pt, тип *t);
тип *type_setmangle(тип **pt,mangle_t mangle);
тип *type_setcv(тип **pt,tym_t cv);
цел type_embed(тип *t,тип *u);
цел type_isvla(тип *t);

param_t *param_calloc();
param_t *param_append_type(param_t **,тип *);
проц param_free_l(param_t *);
проц param_free(param_t **);
Symbol *param_search(ткст0 имя, param_t **pp);
проц param_hydrate(param_t **);
проц param_dehydrate(param_t **);
цел typematch(тип *t1, тип *t2, цел relax);

тип *type_pointer(тип *tnext);
тип *type_dyn_array(тип *tnext);
extern (C) тип *type_static_array(targ_т_мера dim, тип *tnext);
тип *type_assoc_array(тип *tkey, тип *tvalue);
тип *type_delegate(тип *tnext);
extern (C) тип *type_function(tym_t tyf, тип*[] ptypes, бул variadic, тип *tret);
тип *type_enum(сим *имя, тип *tbase);
тип *type_struct_class(ткст0 имя, бцел alignsize, бцел structsize,
        тип *arg1type, тип *arg2type, бул isUnion, бул isClass, бул isPOD, бул is0size);

