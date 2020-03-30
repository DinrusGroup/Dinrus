/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1995-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/ee.d, backend/ee.d)
 */
module drc.backend.ee;

/*
 * Code to handle debugger Выражение evaluation
 */

version (SPP) {} else
{

import cidrus;
import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.глоб2;
import drc.backend.тип;
import drc.backend.oper;
import drc.backend.el;
import drc.backend.exh;
import drc.backend.cgcv;

version (SCPP)
{
import parser;
}

import drc.backend.iasm;

/*extern(C++):*/



version (Dinrus)
{
 EEcontext eecontext;
}

//////////////////////////////////////
// Convert any symbols generated for the debugger Выражение to SCstack
// storage class.

проц eecontext_convs(бцел marksi)
{   бцел u;
    бцел top;
    symtab_t *ps;

    // Change all generated SCauto's to SCstack's
version (SCPP)
{
    ps = &globsym;
}
else
{
    ps = cstate.CSpsymtab;
}
    top = ps.top;
    //printf("eecontext_convs(%d,%d)\n",marksi,top);
    for (u = marksi; u < top; u++)
    {   Symbol *s;

        s = ps.tab[u];
        switch (s.Sclass)
        {
            case SCauto:
            case SCregister:
                s.Sclass = SCstack;
                s.Sfl = FLstack;
                break;
            default:
                break;
        }
    }
}

////////////////////////////////////////
// Parse the debugger Выражение.

version (SCPP)
{

проц eecontext_parse()
{
    if (eecontext.EEimminent)
    {   тип *t;
        бцел marksi;
        Symbol *s;

        //printf("imminent\n");
        marksi = globsym.top;
        eecontext.EEin++;
        s = symbol_genauto(tspvoid);
        eecontext.EEelem = func_expr_dtor(да);
        t = eecontext.EEelem.ET;
        if (tybasic(t.Tty) != TYvoid)
        {   бцел op;
            elem *e;

            e = el_unat(OPind,t,el_var(s));
            op = tyaggregate(t.Tty) ? OPstreq : OPeq;
            eecontext.EEelem = el_bint(op,t,e,eecontext.EEelem);
        }
        eecontext.EEin--;
        eecontext.EEimminent = 0;
        eecontext.EEfunc = funcsym_p;

        eecontext_convs(marksi);

        // Generate the typedef
        if (eecontext.EEtypedef && config.fulltypes)
        {   Symbol *s;

            s = symbol_name(eecontext.EEtypedef,SCtypedef,t);
            cv_outsym(s);
            symbol_free(s);
        }
    }
}

}
}
