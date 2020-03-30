/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/nspace.d, _nspace.d)
 * Documentation:  https://dlang.org/phobos/dmd_nspace.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/nspace.d
 */

module dmd.nspace;

import dmd.aggregate;
import dmd.arraytypes;
import dmd.dscope;
import dmd.дсимвол;
import dmd.dsymbolsem;
import drc.ast.Expression;
import dmd.globals;
import drc.lexer.Identifier;
import drc.ast.Visitor;
import cidrus;

private const LOG = нет;

/***********************************************************
 * A namespace corresponding to a C++ namespace.
 * Implies extern(C++).
 */
 final class Nspace : ScopeDsymbol
{
    /**
     * Namespace идентификатор resolved during semantic.
     */
    Выражение identExp;

    this(ref Место место, Идентификатор2 идент, Выражение identExp, Дсимволы* члены)
    {
        super(место, идент);
        //printf("Nspace::Nspace(идент = %s)\n", идент.вТкст0());
        this.члены = члены;
        this.identExp = identExp;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        auto ns = new Nspace(место, идент, identExp, null);
        return ScopeDsymbol.syntaxCopy(ns);
    }

    override проц addMember(Scope* sc, ScopeDsymbol sds)
    {
        ScopeDsymbol.addMember(sc, sds);

        if (члены)
        {
            if (!symtab)
                symtab = new DsymbolTable();
            // The namespace becomes 'imported' into the enclosing scope
            for (Scope* sce = sc; 1; sce = sce.enclosing)
            {
                ScopeDsymbol sds2 = sce.scopesym;
                if (sds2)
                {
                    sds2.importScope(this, Prot(Prot.Kind.public_));
                    break;
                }
            }
            assert(sc);
            sc = sc.сунь(this);
            sc.компонаж = LINK.cpp; // namespaces default to C++ компонаж
            sc.родитель = this;
            члены.foreachDsymbol(/*s =>*/ s.addMember(sc, this));
            sc.вынь();
        }
    }

    override проц setScope(Scope* sc)
    {
        ScopeDsymbol.setScope(sc);
        if (члены)
        {
            assert(sc);
            sc = sc.сунь(this);
            sc.компонаж = LINK.cpp; // namespaces default to C++ компонаж
            sc.родитель = this;
            члены.foreachDsymbol(/*s =>*/ s.setScope(sc));
            sc.вынь();
        }
    }

    override бул oneMember(ДСимвол* ps, Идентификатор2 идент)
    {
        return ДСимвол.oneMember(ps, идент);
    }

    override ДСимвол search(ref Место место, Идентификатор2 идент, цел flags = cast(цел) SearchLocalsOnly)
    {
        //printf("%s.Nspace.search('%s')\n", вТкст0(), идент.вТкст0());
        if (_scope && !symtab)
            dsymbolSemantic(this, _scope);

        if (!члены || !symtab) // opaque or semantic() is not yet called
        {
            выведиОшибку("is forward referenced when looking for `%s`", идент.вТкст0());
            return null;
        }

        return ScopeDsymbol.search(место, идент, flags);
    }

    override цел apply(Dsymbol_apply_ft_t fp, ук param)
    {
        return члены.foreachDsymbol( (s) { return s && s.apply(fp, param); } );
    }

    override бул hasPointers()
    {
        //printf("Nspace::hasPointers() %s\n", вТкст0());
        return члены.foreachDsymbol( (s) { return s.hasPointers(); } ) != 0;
    }

    override проц setFieldOffset(AggregateDeclaration ad, бцел* poffset, бул isunion)
    {
        //printf("Nspace::setFieldOffset() %s\n", вТкст0());
        if (_scope) // if fwd reference
            dsymbolSemantic(this, null); // try to resolve it
        члены.foreachDsymbol(/* s =>*/ s.setFieldOffset(ad, poffset, isunion) );
    }

    override ткст0 вид() 
    {
        return "namespace";
    }

    override Nspace isNspace() 
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}
