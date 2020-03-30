/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/nogc.d, _nogc.d)
 * Documentation:  https://dlang.org/phobos/dmd_nogc.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/nogc.d
 */

module dmd.nogc;

import dmd.aggregate;
import dmd.apply;
import dmd.declaration;
import dmd.dscope;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import dmd.init;
import dmd.mtype;
import drc.lexer.Tokens;
import drc.ast.Visitor;

/**************************************
 * Look for СМ-allocations
 */
 final class NOGCVisitor : StoppableVisitor
{
    alias typeof(super).посети посети;
public:
    FuncDeclaration f;
    бул err;

    this(FuncDeclaration f)
    {
        this.f = f;
    }

    проц doCond(Выражение exp)
    {
        if (exp)
            walkPostorder(exp, this);
    }

    override проц посети(Выражение e)
    {
    }

    override проц посети(DeclarationExp e)
    {
        // Note that, walkPostorder does not support DeclarationExp today.
        VarDeclaration v = e.declaration.isVarDeclaration();
        if (v && !(v.класс_хранения & STC.manifest) && !v.isDataseg() && v._иниц)
        {
            if (ExpInitializer ei = v._иниц.isExpInitializer())
            {
                doCond(ei.exp);
            }
        }
    }

    override проц посети(CallExp e)
    {
       // import drc.lexer.Id : Id;
       // import core.stdc.stdio : printf;
        if (!e.f)
            return;

        auto fd = stripHookTraceImpl(e.f);
        if (fd.идент == Id._d_arraysetlengthT)
        {
            if (f.setGC())
            {
                e.выведиОшибку("setting `length` in `` %s `%s` may cause a СМ allocation",
                    f.вид(), f.toPrettyChars());
                err = да;
                return;
            }
            f.printGCUsage(e.место, "setting `length` may cause a СМ allocation");
        }
    }

    override проц посети(ArrayLiteralExp e)
    {
        if (e.тип.ty != Tarray || !e.elements || !e.elements.dim)
            return;
        if (f.setGC())
        {
            e.выведиОшибку("массив literal in `` %s `%s` may cause a СМ allocation",
                f.вид(), f.toPrettyChars());
            err = да;
            return;
        }
        f.printGCUsage(e.место, "массив literal may cause a СМ allocation");
    }

    override проц посети(AssocArrayLiteralExp e)
    {
        if (!e.keys.dim)
            return;
        if (f.setGC())
        {
            e.выведиОшибку("associative массив literal in `` %s `%s` may cause a СМ allocation",
                f.вид(), f.toPrettyChars());
            err = да;
            return;
        }
        f.printGCUsage(e.место, "associative массив literal may cause a СМ allocation");
    }

    override проц посети(NewExp e)
    {
        if (e.member && !e.member.isNogc() && f.setGC())
        {
            // -ness is already checked in NewExp::semantic
            return;
        }
        if (e.onstack)
            return;
        if (e.allocator)
            return;
        if (глоб2.парамы.ehnogc && e.thrownew)
            return;                     // separate allocator is called for this, not the СМ
        if (f.setGC())
        {
            e.выведиОшибку("cannot use `new` in `` %s `%s`",
                f.вид(), f.toPrettyChars());
            err = да;
            return;
        }
        f.printGCUsage(e.место, "`new` causes a СМ allocation");
    }

    override проц посети(DeleteExp e)
    {
        if (e.e1.op == ТОК2.variable)
        {
            VarDeclaration v = (cast(VarExp)e.e1).var.isVarDeclaration();
            if (v && v.onstack)
                return; // delete for scope allocated class объект
        }

        Тип tb = e.e1.тип.toBasetype();
        AggregateDeclaration ad = null;
        switch (tb.ty)
        {
        case Tclass:
            ad = (cast(TypeClass)tb).sym;
            break;

        case Tpointer:
            tb = (cast(TypePointer)tb).следщ.toBasetype();
            if (tb.ty == Tstruct)
                ad = (cast(TypeStruct)tb).sym;
            break;

        default:
            break;
        }

        if (f.setGC())
        {
            e.выведиОшибку("cannot use `delete` in `` %s `%s`",
                f.вид(), f.toPrettyChars());
            err = да;
            return;
        }
        f.printGCUsage(e.место, "`delete` requires the СМ");
    }

    override проц посети(IndexExp e)
    {
        Тип t1b = e.e1.тип.toBasetype();
        if (t1b.ty == Taarray)
        {
            if (f.setGC())
            {
                e.выведиОшибку("indexing an associative массив in `` %s `%s` may cause a СМ allocation",
                    f.вид(), f.toPrettyChars());
                err = да;
                return;
            }
            f.printGCUsage(e.место, "indexing an associative массив may cause a СМ allocation");
        }
    }

    override проц посети(AssignExp e)
    {
        if (e.e1.op == ТОК2.arrayLength)
        {
            if (f.setGC())
            {
                e.выведиОшибку("setting `length` in `` %s `%s` may cause a СМ allocation",
                    f.вид(), f.toPrettyChars());
                err = да;
                return;
            }
            f.printGCUsage(e.место, "setting `length` may cause a СМ allocation");
        }
    }

    override проц посети(CatAssignExp e)
    {
        if (f.setGC())
        {
            e.выведиОшибку("cannot use operator `~=` in `` %s `%s`",
                f.вид(), f.toPrettyChars());
            err = да;
            return;
        }
        f.printGCUsage(e.место, "operator `~=` may cause a СМ allocation");
    }

    override проц посети(CatExp e)
    {
        if (f.setGC())
        {
            e.выведиОшибку("cannot use operator `~` in `` %s `%s`",
                f.вид(), f.toPrettyChars());
            err = да;
            return;
        }
        f.printGCUsage(e.место, "operator `~` may cause a СМ allocation");
    }
}

Выражение checkGC(Scope* sc, Выражение e)
{
    FuncDeclaration f = sc.func;
    if (e && e.op != ТОК2.error && f && sc.intypeof != 1 && !(sc.flags & SCOPE.ctfe) &&
           (f.тип.ty == Tfunction &&
            (cast(TypeFunction)f.тип).isnogc || (f.flags & FUNCFLAG.nogcInprocess) || глоб2.парамы.vgc) &&
           !(sc.flags & SCOPE.debug_))
    {
        scope NOGCVisitor gcv = new NOGCVisitor(f);
        walkPostorder(e, gcv);
        if (gcv.err)
            return new ErrorExp();
    }
    return e;
}

/**
 * Removes `_d_HookTraceImpl` if found from `fd`.
 * This is needed to be able to найди hooks that are called though the hook's `*Trace` wrapper.
 * Параметры:
 *  fd = The function declaration to удали `_d_HookTraceImpl` from
 */
private FuncDeclaration stripHookTraceImpl(FuncDeclaration fd)
{
    //import drc.lexer.Id : Id;
   // import dmd.дсимвол : ДСимвол;
   // import drc.ast.Node : КорневойОбъект, ДИНКАСТ;

    if (fd.идент != Id._d_HookTraceImpl)
        return fd;

    // Get the Hook from the second template параметр
    auto templateInstance = fd.родитель.isTemplateInstance;
    КорневойОбъект hook = (*templateInstance.tiargs)[1];
    assert(hook.динкаст() == ДИНКАСТ.дсимвол, "Expected _d_HookTraceImpl's second template параметр to be an alias to the hook!");
    return (cast(ДСимвол)hook).isFuncDeclaration;
}
