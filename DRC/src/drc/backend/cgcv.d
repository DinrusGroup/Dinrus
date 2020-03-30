/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1985-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/cgcv.c, backend/cgcv.c)
 */

/* Header for cgcv.c    */

module drc.backend.cgcv;

// Online documentation: https://dlang.org/phobos/dmd_backend_cgcv.html

import drc.backend.cc : Classsym, Symbol;
import drc.backend.dlist;
import drc.backend.тип;

/*extern (C++):*/
/*:*/


alias LIST* symlist_t;

extern  ткст0 ftdbname;

проц cv_init();
бцел cv_typidx(тип* t);
проц cv_outsym(Symbol* s);
проц cv_func(Symbol* s);
проц cv_term();
бцел cv4_struct(Classsym*, цел);


/* =================== Added for Dinrus compiler ========================= */

alias бцел idx_t;        // тип of тип index

/* Data structure for a тип record     */

struct debtyp_t
{
  align(1):
    бцел prev;          // previous debtyp_t with same хэш
    ushort length;      // length of following массив
    ббайт[2] данные;      // variable size массив
}

struct Cgcv
{
    бцел signature;
    symlist_t list;     // deferred list of symbols to output
    idx_t deb_offset;   // смещение added to тип index
    бцел sz_idx;        // size of stored тип index
    цел LCFDoffset;
    цел LCFDpointer;
    цел FD_code;        // frame for references to code
}

 Cgcv cgcv;

debtyp_t* debtyp_alloc(бцел length);
цел cv_stringbytes(ткст0 имя);
бцел cv4_numericbytes(бцел значение);
проц cv4_storenumeric(ббайт* p, бцел значение);
бцел cv4_signednumericbytes(цел значение);
проц cv4_storesignednumeric(ббайт* p, цел значение);
idx_t cv_debtyp(debtyp_t* d);
цел cv_namestring(ббайт* p, ткст0 имя, цел length = -1);
бцел cv4_typidx(тип* t);
idx_t cv4_arglist(тип* t, бцел* pnparam);
ббайт cv4_callconv(тип* t);
idx_t cv_numdebtypes();

проц TOWORD(ббайт* a, бцел b)
{
    *cast(ushort*)a = cast(ushort)b;
}

проц TOLONG(ббайт* a, бцел b)
{
    *cast(бцел*)a = b;
}

проц TOIDX(ббайт* a, бцел b)
{
    if (cgcv.sz_idx == 4)
        TOLONG(a,b);
    else
        TOWORD(a,b);
}

const DEBSYM = 5;               // segment of symbol info
const DEBTYP = 6;               // segment of тип info

/* ======================== Added for Codeview 8 =========================== */

проц cv8_initfile(ткст0 имяф);
проц cv8_termfile(ткст0 objfilename);
проц cv8_initmodule(ткст0 имяф, ткст0 modulename);
проц cv8_termmodule();
проц cv8_func_start(Symbol* sfunc);
проц cv8_func_term(Symbol* sfunc);
//проц cv8_linnum(Srcpos srcpos, бцел смещение);  // Srcpos isn't доступно yet
проц cv8_outsym(Symbol* s);
проц cv8_udt(ткст0 ид, idx_t typidx);
цел cv8_regnum(Symbol* s);
idx_t cv8_fwdref(Symbol* s);
idx_t cv8_darray(тип* tnext, idx_t etypidx);
idx_t cv8_ddelegate(тип* t, idx_t functypidx);
idx_t cv8_daarray(тип* t, idx_t keyidx, idx_t validx);


