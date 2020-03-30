/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/aliasthis.d, _aliasthis.d)
 * Documentation:  https://dlang.org/phobos/dmd_aliasthis.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/aliasthis.d
 */

module dmd.aliasthis;

import cidrus;

import dmd.aggregate;
import dmd.dscope;
import dmd.дсимвол;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.globals;
import drc.lexer.Identifier;
import dmd.mtype;
import dmd.opover;
import drc.lexer.Tokens;
import drc.ast.Visitor;
import dmd.dclass : ClassDeclaration;
import dmd.errors : deprecation;
import dmd.dsymbolsem : getMessage;
/***********************************************************
 * alias идент this;
 */
 final class AliasThis : ДСимвол
{
    Идентификатор2 идент;
    /// The symbol this `alias this` resolves to
    ДСимвол sym;
    /// Whether this `alias this` is deprecated or not
    бул isDeprecated_;

    this(ref Место место, Идентификатор2 идент)
    {
        super(место, null);    // it's анонимный (no идентификатор)
        this.идент = идент;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        auto at = new AliasThis(место, идент);
        at.коммент = коммент;
        return at;
    }

    override ткст0 вид()
    {
        return "alias this";
    }

    AliasThis isAliasThis()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }

    override бул isDeprecated()
    {
        return this.isDeprecated_;
    }
}

Выражение resolveAliasThis(Scope* sc, Выражение e, бул gag = нет)
{
    for (AggregateDeclaration ad = isAggregate(e.тип); ad;)
    {
        if (ad.aliasthis)
        {
            бцел olderrors = gag ? глоб2.startGagging() : 0;
            Место место = e.место;
            Тип tthis = (e.op == ТОК2.тип ? e.тип : null);
            e = new DotIdExp(место, e, ad.aliasthis.идент);
            e = e.ВыражениеSemantic(sc);
            if (tthis && ad.aliasthis.sym.needThis())
            {
                if (e.op == ТОК2.variable)
                {
                    if (auto fd = (cast(VarExp)e).var.isFuncDeclaration())
                    {
                        // https://issues.dlang.org/show_bug.cgi?ид=13009
                        // Support better match for the overloaded alias this.
                        бул hasOverloads;
                        if (auto f = fd.overloadModMatch(место, tthis, hasOverloads))
                        {
                            if (!hasOverloads)
                                fd = f;     // use exact match
                            e = new VarExp(место, fd, hasOverloads);
                            e.тип = f.тип;
                            e = new CallExp(место, e);
                            goto L1;
                        }
                    }
                }
                /* non- function is not called inside typeof(),
                 * so resolve it ahead.
                 */
                {
                    цел save = sc.intypeof;
                    sc.intypeof = 1; // bypass "need this" error check
                    e = resolveProperties(sc, e);
                    sc.intypeof = save;
                }
            L1:
                e = new TypeExp(место, new TypeTypeof(место, e));
                e = e.ВыражениеSemantic(sc);
            }
            e = resolveProperties(sc, e);
            if (!gag)
                ad.aliasthis.checkDeprecatedAliasThis(место, sc);
            else if (глоб2.endGagging(olderrors))
                e = null;
        }

         auto cd = ad.isClassDeclaration();
        if ((!e || !ad.aliasthis) && cd && cd.baseClass && cd.baseClass != ClassDeclaration.объект)
        {
            ad = cd.baseClass;
            continue;
        }
        break;
    }
    return e;
}

/**
 * Check if an `alias this` is deprecated
 *
 * Usually one would use `Выражение.checkDeprecated(scope, aliasthis)` to
 * check if `Выражение` uses a deprecated `aliasthis`, but this calls
 * `toPrettyChars` which lead to the following message:
 * "Deprecation: alias this `fullyqualified.aggregate.__anonymous` is deprecated"
 *
 * Параметры:
 *   at  = The `AliasThis` объект to check
 *   место = `Место` of the Выражение triggering the access to `at`
 *   sc  = `Scope` of the Выражение
 *         (deprecations do not trigger in deprecated scopes)
 *
 * Возвращает:
 *   Whether the alias this was reported as deprecated.
 */
бул checkDeprecatedAliasThis(AliasThis at, ref Место место, Scope* sc)
{

    if (глоб2.парамы.useDeprecated != DiagnosticReporting.off
        && at.isDeprecated() && !sc.isDeprecated())
    {
            ткст0 message = null;
            for (ДСимвол p = at; p; p = p.родитель)
            {
                message = p.depdecl ? p.depdecl.getMessage() : null;
                if (message)
                    break;
            }
            if (message)
                deprecation(место, "`alias %s this` is deprecated - %s",
                            at.sym.вТкст0(), message);
            else
                deprecation(место, "`alias %s this` is deprecated",
                            at.sym.вТкст0());
        return да;
    }
    return нет;
}
