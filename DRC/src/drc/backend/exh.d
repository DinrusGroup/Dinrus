/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1993-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/exh.d, backend/exh.d)
 */

module drc.backend.exh;

// Online documentation: https://dlang.org/phobos/dmd_backend_exh.html

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.el;
import drc.backend.тип;

/*extern (C++):*/
/*:*/


struct Aobject
{
    Symbol *AOsym;              // Symbol for active объект
    targ_т_мера AOoffset;       // смещение from that объект
    Symbol *AOfunc;             // cleanup function
}


/* except.c */
проц  except_init();
проц  except_term();
elem *except_obj_ctor(elem *e,Symbol *s,targ_т_мера смещение,Symbol *sdtor);
elem *except_obj_dtor(elem *e,Symbol *s,targ_т_мера смещение);
elem *except_throw_Выражение();
тип *except_declaration(Symbol *cv);
проц  except_exception_spec(тип *t);
проц  except_index_set(цел index);
цел   except_index_get();
проц  except_pair_setoffset(проц *p,targ_т_мера смещение);
проц  except_pair_append(проц *p, цел index);
проц  except_push(проц *p,elem *e,block *b);
проц  except_pop(проц *p,elem *e,block *b);
проц  except_mark();
проц  except_release();
Symbol *except_gensym();
Symbol *except_gentables();
проц except_fillInEHTable(Symbol *s);
проц  except_reset();

/* pdata.c */
проц win64_pdata(Symbol *sf);

