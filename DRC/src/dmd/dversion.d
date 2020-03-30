/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/dversion.d, _dversion.d)
 * Documentation:  https://dlang.org/phobos/dmd_dversion.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/dversion.d
 */

module dmd.dversion;

import dmd.arraytypes;
import dmd.cond;
import dmd.dmodule;
import dmd.dscope;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.globals;
import drc.lexer.Identifier;
import util.outbuffer;
import drc.ast.Visitor;

/***********************************************************
 * DebugSymbol's happen for statements like:
 *      debug = идентификатор;
 *      debug = integer;
 */
 final class DebugSymbol : ДСимвол
{
    бцел уровень;

    this(ref Место место, Идентификатор2 идент)
    {
        super(место, идент);
    }

    this(ref Место место, бцел уровень)
    {
        super(место, null);
        this.уровень = уровень;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        auto ds = new DebugSymbol(место, идент);
        ds.коммент = коммент;
        ds.уровень = уровень;
        return ds;
    }

    override ткст0 вТкст0()
    {
        if (идент)
            return идент.вТкст0();
        else
        {
            БуфВыв буф;
            буф.print(уровень);
            return буф.extractChars();
        }
    }

    override проц addMember(Scope* sc, ScopeDsymbol sds)
    {
        //printf("DebugSymbol::addMember('%s') %s\n", sds.вТкст0(), вТкст0());
        Module m = sds.isModule();
        // Do not add the member to the symbol table,
        // just make sure subsequent debug declarations work.
        if (идент)
        {
            if (!m)
            {
                выведиОшибку("declaration must be at module уровень");
                errors = да;
            }
            else
            {
                if (findCondition(m.debugidsNot, идент))
                {
                    выведиОшибку("defined after use");
                    errors = да;
                }
                if (!m.debugids)
                    m.debugids = new Идентификаторы();
                m.debugids.сунь(идент);
            }
        }
        else
        {
            if (!m)
            {
                выведиОшибку("уровень declaration must be at module уровень");
                errors = да;
            }
            else
                m.debuglevel = уровень;
        }
    }

    override ткст0 вид()
    {
        return "debug";
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * VersionSymbol's happen for statements like:
 *      version = идентификатор;
 *      version = integer;
 */
 final class VersionSymbol : ДСимвол
{
    бцел уровень;

    this(ref Место место, Идентификатор2 идент)
    {
        super(место, идент);
    }

    this(ref Место место, бцел уровень)
    {
        super(место, null);
        this.уровень = уровень;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        auto ds = идент ? new VersionSymbol(место, идент)
                        : new VersionSymbol(место, уровень);
        ds.коммент = коммент;
        return ds;
    }

    override ткст0 вТкст0()
    {
        if (идент)
            return идент.вТкст0();
        else
        {
            БуфВыв буф;
            буф.print(уровень);
            return буф.extractChars();
        }
    }

    override проц addMember(Scope* sc, ScopeDsymbol sds)
    {
        //printf("VersionSymbol::addMember('%s') %s\n", sds.вТкст0(), вТкст0());
        Module m = sds.isModule();
        // Do not add the member to the symbol table,
        // just make sure subsequent debug declarations work.
        if (идент)
        {
            VersionCondition.checkReserved(место, идент.вТкст());
            if (!m)
            {
                выведиОшибку("declaration must be at module уровень");
                errors = да;
            }
            else
            {
                if (findCondition(m.versionidsNot, идент))
                {
                    выведиОшибку("defined after use");
                    errors = да;
                }
                if (!m.versionids)
                    m.versionids = new Идентификаторы();
                m.versionids.сунь(идент);
            }
        }
        else
        {
            if (!m)
            {
                выведиОшибку("уровень declaration must be at module уровень");
                errors = да;
            }
            else
                m.versionlevel = уровень;
        }
    }

    override ткст0 вид()
    {
        return "version";
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}
