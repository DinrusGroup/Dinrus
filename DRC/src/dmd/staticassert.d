/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/staticassert.d, _staticassert.d)
 * Documentation:  https://dlang.org/phobos/dmd_staticassert.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/staticassert.d
 */

module dmd.staticassert;

import dmd.dscope;
import dmd.дсимвол;
import drc.ast.Expression;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.mtype;
import drc.ast.Visitor;

/***********************************************************
 */
 final class StaticAssert : ДСимвол
{
    Выражение exp;
    Выражение msg;

    this(ref Место место, Выражение exp, Выражение msg)
    {
        super(место, Id.empty);
        this.exp = exp;
        this.msg = msg;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        return new StaticAssert(место, exp.syntaxCopy(), msg ? msg.syntaxCopy() : null);
    }

    override проц addMember(Scope* sc, ScopeDsymbol sds)
    {
        // we didn't add anything
    }

    override бул oneMember(ДСимвол* ps, Идентификатор2 идент)
    {
        //printf("StaticAssert::oneMember())\n");
        *ps = null;
        return да;
    }

    override ткст0 вид()
    {
        return "static assert";
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}
