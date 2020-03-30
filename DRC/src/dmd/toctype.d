/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/toctype.d, _toctype.d)
 * Documentation:  https://dlang.org/phobos/dmd_toctype.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/toctype.d
 */

module dmd.toctype;

import cidrus;

import drc.backend.cc : Classsym, Symbol;
import drc.backend.ty;
import drc.backend.тип;

import util.rmem;

import dmd.declaration;
import dmd.denum;
import dmd.dstruct;
import dmd.globals;
import dmd.glue;
import drc.lexer.Id;
import dmd.mtype;
import dmd.tocvdebug;
import drc.ast.Visitor;


/*******************
 * Determine backend tym bits corresponding to MOD
 * Параметры:
 *  mod = mod bits
 * Возвращает:
 *  corresponding tym_t bits
 */
tym_t modToTym(MOD mod) 
{
    switch (mod)
    {
        case 0:
            return 0;

        case MODFlags.const_:
        case MODFlags.wild:
        case MODFlags.wildconst:
            return mTYconst;

        case MODFlags.shared_:
            return mTYshared;

        case MODFlags.shared_ | MODFlags.const_:
        case MODFlags.shared_ | MODFlags.wild:
        case MODFlags.shared_ | MODFlags.wildconst:
            return mTYshared | mTYconst;

        case MODFlags.immutable_:
            return mTYimmutable;

        default:
            assert(0);
    }
}


/************************************
 * Convert front end тип `t` to backend тип `t.ctype`.
 * Memoize the результат.
 * Параметры:
 *      t = front end `Тип`
 * Возвращает:
 *      back end equivalent `тип`
 */
 тип* Type_toCtype(Тип t)
{
    if (!t.ctype)
    {
        scope ToCtypeVisitor v = new ToCtypeVisitor();
        t.прими(v);
    }
    return t.ctype;
}

private  final class ToCtypeVisitor : Визитор2
{
    alias Визитор2.посети посети;
public:
    this()
    {
    }

    override проц посети(Тип t)
    {
        t.ctype = type_fake(totym(t));
        t.ctype.Tcount++;
    }

    override проц посети(TypeSArray t)
    {
        t.ctype = type_static_array(t.dim.toInteger(), Type_toCtype(t.следщ));
    }

    override проц посети(TypeDArray t)
    {
        t.ctype = type_dyn_array(Type_toCtype(t.следщ));
        t.ctype.Tident = t.toPrettyChars(да);
    }

    override проц посети(TypeAArray t)
    {
        t.ctype = type_assoc_array(Type_toCtype(t.index), Type_toCtype(t.следщ));
        t.ctype.Tident = t.toPrettyChars(да);
    }

    override проц посети(TypePointer t)
    {
        //printf("TypePointer::toCtype() %s\n", t.вТкст0());
        t.ctype = type_pointer(Type_toCtype(t.следщ));
    }

    override проц посети(TypeFunction t)
    {
        const nparams = t.parameterList.length;
        тип*[10] tmp = проц;
        тип** ptypes = (nparams <= tmp.length)
                        ? tmp.ptr
                        : cast(тип**)Пам.check(malloc((тип*).sizeof * nparams));
        тип*[] types = ptypes[0 .. nparams];

        foreach (i; new бцел[0 .. nparams])
        {
            Параметр2 p = t.parameterList[i];
            тип* tp = Type_toCtype(p.тип);
            if (p.классХранения & (STC.out_ | STC.ref_))
                tp = type_allocn(TYnref, tp);
            else if (p.классХранения & STC.lazy_)
            {
                // Mangle as delegate
                тип* tf = type_function(TYnfunc, null, нет, tp);
                tp = type_delegate(tf);
            }
            types[i] = tp;
        }
        t.ctype = type_function(totym(t), types, t.parameterList.varargs == ВарАрг.variadic, Type_toCtype(t.следщ));
        if (types.ptr != tmp.ptr)
            free(types.ptr);
    }

    override проц посети(TypeDelegate t)
    {
        t.ctype = type_delegate(Type_toCtype(t.следщ));
    }

    override проц посети(TypeStruct t)
    {
        //printf("TypeStruct::toCtype() '%s'\n", t.sym.вТкст0());
        if (t.mod == 0)
        {
            // Create a new backend тип
            StructDeclaration sym = t.sym;
            t.ctype = type_struct_class(sym.toPrettyChars(да), sym.alignsize, sym.structsize, sym.arg1type ? Type_toCtype(sym.arg1type) : null, sym.arg2type ? Type_toCtype(sym.arg2type) : null, sym.isUnionDeclaration() !is null, нет, sym.isPOD() != 0, sym.hasNoFields);
            /* Add in fields of the struct
             * (after setting ctype to avoid infinite recursion)
             */
            if (глоб2.парамы.symdebug && !глоб2.errors)
            {
                foreach (v; sym.fields)
                {
                    symbol_struct_addField(cast(Symbol*)t.ctype.Ttag, v.идент.вТкст0(), Type_toCtype(v.тип), v.смещение);
                }
            }

            if (глоб2.парамы.symdebugref)
                toDebug(sym);

            return;
        }

        // Copy mutable version of backend тип and add modifiers
        тип* mctype = Type_toCtype(t.castMod(0));
        t.ctype = type_alloc(tybasic(mctype.Tty));
        t.ctype.Tcount++;
        if (t.ctype.Tty == TYstruct)
        {
            t.ctype.Ttag = mctype.Ttag; // structure tag имя
        }
        t.ctype.Tty |= modToTym(t.mod);
        //printf("t = %p, Tflags = x%x\n", ctype, ctype.Tflags);
    }

    override проц посети(TypeEnum t)
    {
        //printf("TypeEnum::toCtype() '%s'\n", t.sym.вТкст0());
        if (t.mod == 0)
        {
            EnumDeclaration sym = t.sym;
            auto symMemtype = sym.memtype;
            if (!symMemtype)
            {
                // https://issues.dlang.org/show_bug.cgi?ид=13792
                t.ctype = Type_toCtype(Тип.tvoid);
            }
            else if (sym.идент == Id.__c_long)
            {
                t.ctype = type_fake(totym(t));
                t.ctype.Tcount++;
                return;
            }
            else if (symMemtype.toBasetype().ty == Tint32)
            {
                t.ctype = type_enum(sym.toPrettyChars(да), Type_toCtype(symMemtype));
            }
            else
            {
                t.ctype = Type_toCtype(symMemtype);
            }

            if (глоб2.парамы.symdebugref)
                toDebug(t.sym);

            return;
        }

        // Copy mutable version of backend тип and add modifiers
        тип* mctype = Type_toCtype(t.castMod(0));
        if (tybasic(mctype.Tty) == TYenum)
        {
            Classsym* s = mctype.Ttag;
            assert(s);
            t.ctype = type_allocn(TYenum, mctype.Tnext);
            t.ctype.Ttag = s; // enum tag имя
            t.ctype.Tcount++;
            t.ctype.Tty |= modToTym(t.mod);
        }
        else
            t.ctype = mctype;

        //printf("t = %p, Tflags = x%x\n", t, t.Tflags);
    }

    override проц посети(TypeClass t)
    {
        if (t.mod == 0)
        {
            //printf("TypeClass::toCtype() %s\n", вТкст0());
            тип* tc = type_struct_class(t.sym.toPrettyChars(да), t.sym.alignsize, t.sym.structsize, null, null, нет, да, да, нет);
            t.ctype = type_pointer(tc);
            /* Add in fields of the class
             * (after setting ctype to avoid infinite recursion)
             */
            if (глоб2.парамы.symdebug)
            {
                foreach (v; t.sym.fields)
                {
                    symbol_struct_addField(cast(Symbol*)tc.Ttag, v.идент.вТкст0(), Type_toCtype(v.тип), v.смещение);
                }
            }

            if (глоб2.парамы.symdebugref)
                toDebug(t.sym);
            return;
        }

        // Copy mutable version of backend тип and add modifiers
        тип* mctype = Type_toCtype(t.castMod(0));
        t.ctype = type_allocn(tybasic(mctype.Tty), mctype.Tnext); // pointer to class instance
        t.ctype.Tcount++;
        t.ctype.Tty |= modToTym(t.mod);
    }
}
