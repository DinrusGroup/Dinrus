/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/init.d, _иниц.d)
 * Documentation:  https://dlang.org/phobos/dmd_init.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/init.d
 */

module dmd.init;

import cidrus;
//import core.checkedint;

import dmd.arraytypes;
import  drc.ast.Node;
import dmd.дсимвол;
import drc.ast.Expression;
import dmd.globals;
import dmd.hdrgen;
import drc.lexer.Identifier;
import dmd.mtype;
import util.outbuffer;
import drc.ast.Node;
import drc.lexer.Tokens;
import drc.ast.Visitor;

enum NeedInterpret : цел
{
    INITnointerpret,
    INITinterpret,
}

alias  NeedInterpret.INITnointerpret INITnointerpret;
alias  NeedInterpret.INITinterpret INITinterpret;

/*************
 * Discriminant for which вид of инициализатор
 */
enum InitKind : ббайт
{
    void_,
    error,
    struct_,
    массив,
    exp,
}

/***********************************************************
 */
 class Инициализатор : УзелАСД
{
    Место место;
    InitKind вид;


    this(ref Место место, InitKind вид)
    {
        this.место = место;
        this.вид = вид;
    }

    override final ткст0 вТкст0()
    {
        БуфВыв буф;
        HdrGenState hgs;
        .toCBuffer(this, &буф, &hgs);
        return буф.extractChars();
    }

    final ErrorInitializer isErrorInitializer() 
    {
        // Use ук cast to skip dynamic casting call
        return вид == InitKind.error ? cast(ErrorInitializer)cast(ук)this : null;
    }

    final VoidInitializer isVoidInitializer() 
    {
        return вид == InitKind.void_ ? cast(VoidInitializer)cast(ук)this : null;
    }

    final StructInitializer isStructInitializer() 
    {
        return вид == InitKind.struct_ ? cast(StructInitializer)cast(ук)this : null;
    }

    final ArrayInitializer isArrayInitializer() 
    {
        return вид == InitKind.массив ? cast( ArrayInitializer)cast(ук)this : null;
    }

    final ExpInitializer isExpInitializer() 
    {
        return вид == InitKind.exp ? cast( ExpInitializer)cast(ук)this : null;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class VoidInitializer : Инициализатор
{
    Тип тип;      // тип that this will initialize to

    this(ref Место место)
    {
        super(место, InitKind.void_);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class ErrorInitializer : Инициализатор
{
    this()
    {
        super(Место.initial, InitKind.error);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class StructInitializer : Инициализатор
{
    Идентификаторы field;      // of Идентификатор2 *'s
    Инициализаторы значение;     // parallel массив of Инициализатор *'s

    this(ref Место место)
    {
        super(место, InitKind.struct_);
    }

    extern (D) проц addInit(Идентификатор2 field, Инициализатор значение)
    {
        //printf("StructInitializer::addInit(field = %p, значение = %p)\n", field, значение);
        this.field.сунь(field);
        this.значение.сунь(значение);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class ArrayInitializer : Инициализатор
{
    Выражения index;      // indices
    Инициализаторы значение;     // of Инициализатор *'s
    бцел dim;               // length of массив being initialized
    Тип тип;              // тип that массив will be используется to initialize
    бул sem;               // да if semantic() is run

    this(ref Место место)
    {
        super(место, InitKind.массив);
    }

    extern (D) проц addInit(Выражение index, Инициализатор значение)
    {
        this.index.сунь(index);
        this.значение.сунь(значение);
        dim = 0;
        тип = null;
    }

    бул isAssociativeArray() 
    {
        foreach (idx; index)
        {
            if (idx)
                return да;
        }
        return нет;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class ExpInitializer : Инициализатор
{
    бул expandTuples;
    Выражение exp;

    this(ref Место место, Выражение exp)
    {
        super(место, InitKind.exp);
        this.exp = exp;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

version (all)
{
     бул hasNonConstPointers(Выражение e)
    {
        static бул checkArray(Выражения* elems)
        {
            foreach (e; *elems)
            {
                if (e && hasNonConstPointers(e))
                    return да;
            }
            return нет;
        }

        if (e.тип.ty == Terror)
            return нет;
        if (e.op == ТОК2.null_)
            return нет;
        if (auto se = e.isStructLiteralExp())
        {
            return checkArray(se.elements);
        }
        if (auto ae = e.isArrayLiteralExp())
        {
            if (!ae.тип.nextOf().hasPointers())
                return нет;
            return checkArray(ae.elements);
        }
        if (auto ae = e.isAssocArrayLiteralExp())
        {
            if (ae.тип.nextOf().hasPointers() && checkArray(ae.values))
                return да;
            if ((cast(TypeAArray)ae.тип).index.hasPointers())
                return checkArray(ae.keys);
            return нет;
        }
        if (auto ae = e.isAddrExp())
        {
            if (auto se = ae.e1.isStructLiteralExp())
            {
                if (!(se.stageflags & stageSearchPointers))
                {
                    const old = se.stageflags;
                    se.stageflags |= stageSearchPointers;
                    бул ret = checkArray(se.elements);
                    se.stageflags = old;
                    return ret;
                }
                else
                {
                    return нет;
                }
            }
            return да;
        }
        if (e.тип.ty == Tpointer && e.тип.nextOf().ty != Tfunction)
        {
            if (e.op == ТОК2.symbolOffset) // address of a глоб2 is OK
                return нет;
            if (e.op == ТОК2.int64) // cast(проц *)цел is OK
                return нет;
            if (e.op == ТОК2.string_) // "abc".ptr is OK
                return нет;
            return да;
        }
        return нет;
    }
}


/****************************************
 * Copy the AST for Инициализатор.
 * Параметры:
 *      inx = Инициализатор AST to копируй
 * Возвращает:
 *      the копируй
 */
Инициализатор syntaxCopy(Инициализатор inx)
{
    static Инициализатор copyStruct(StructInitializer vi)
    {
        auto si = new StructInitializer(vi.место);
        assert(vi.field.dim == vi.значение.dim);
        si.field.устДим(vi.field.dim);
        si.значение.устДим(vi.значение.dim);
        foreach ( i; new цел[0 .. vi.field.dim])
        {
            si.field[i] = vi.field[i];
            si.значение[i] = vi.значение[i].syntaxCopy();
        }
        return si;
    }

    static Инициализатор copyArray(ArrayInitializer vi)
    {
        auto ai = new ArrayInitializer(vi.место);
        assert(vi.index.dim == vi.значение.dim);
        ai.index.устДим(vi.index.dim);
        ai.значение.устДим(vi.значение.dim);
        foreach ( i; new цел[0 .. vi.значение.dim])
        {
            ai.index[i] = vi.index[i] ? vi.index[i].syntaxCopy() : null;
            ai.значение[i] = vi.значение[i].syntaxCopy();
        }
        return ai;
    }

    switch (inx.вид)
    {
        case InitKind.void_:   return new VoidInitializer(inx.место);
        case InitKind.error:   return inx;
        case InitKind.struct_: return copyStruct(cast(StructInitializer)inx);
        case InitKind.массив:   return copyArray(cast(ArrayInitializer)inx);
        case InitKind.exp:     return new ExpInitializer(inx.место, (cast(ExpInitializer)inx).exp.syntaxCopy());
    }
}
