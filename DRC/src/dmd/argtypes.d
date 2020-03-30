/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/argtypes.d, _argtypes.d)
 * Documentation:  https://dlang.org/phobos/dmd_argtypes.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/argtypes.d
 */

module dmd.argtypes;

import cidrus;
import core.checkedint;

import dmd.declaration;
import dmd.globals;
import dmd.mtype;
import drc.ast.Visitor;

private бул isDMDx64Target()
{
    version (Dinrus)
        return глоб2.парамы.is64bit;
    else
        return нет;
}

/****************************************************
 * This breaks a тип down into 'simpler' types that can be passed to a function
 * in registers, and returned in registers.
 * It's highly platform dependent.
 * Параметры:
 *      t = тип to break down
 * Возвращает:
 *      кортеж of types, each element can be passed in a register.
 *      A кортеж of нуль length means the тип cannot be passed/returned in registers.
 *      null indicates a `проц`.
 * References:
 *  For 64 bit code, follows Itanium C++ ABI 1.86 Chapter 3
 *  http://refspecs.linux-foundation.org/cxxabi-1.86.html#calls
 */
 КортежТипов toArgTypes(Тип t)
{
     final class ToArgTypes : Визитор2
    {
        alias Визитор2.посети посети;
    public:
        КортежТипов результат;

        /*****
         * Pass тип in memory (i.e. on the stack), a кортеж of one тип, or a кортеж of 2 types
         */
        проц memory()
        {
            //printf("\ttoArgTypes() %s => [ ]\n", t.вТкст0());
            результат = new КортежТипов(); // pass on the stack
        }

        ///
        проц oneType(Тип t)
        {
            результат = new КортежТипов(t);
        }

        ///
        проц twoTypes(Тип t1, Тип t2)
        {
            результат = new КортежТипов(t1, t2);
        }


        override проц посети(Тип)
        {
            // not valid for a параметр
        }

        override проц посети(TypeError)
        {
            результат = new КортежТипов(Тип.terror);
        }

        override проц посети(TypeBasic t)
        {
            Тип t1 = null;
            Тип t2 = null;
            switch (t.ty)
            {
            case Tvoid:
                return;
            case Tbool:
            case Tint8:
            case Tuns8:
            case Tint16:
            case Tuns16:
            case Tint32:
            case Tuns32:
            case Tfloat32:
            case Tint64:
            case Tuns64:
            case Tint128:
            case Tuns128:
            case Tfloat64:
            case Tfloat80:
                t1 = t;
                break;
            case Timaginary32:
                t1 = Тип.tfloat32;
                break;
            case Timaginary64:
                t1 = Тип.tfloat64;
                break;
            case Timaginary80:
                t1 = Тип.tfloat80;
                break;
            case Tcomplex32:
                if (isDMDx64Target())
                    t1 = Тип.tfloat64;
                else
                {
                    t1 = Тип.tfloat64;
                    t2 = Тип.tfloat64;
                }
                break;
            case Tcomplex64:
                t1 = Тип.tfloat64;
                t2 = Тип.tfloat64;
                break;
            case Tcomplex80:
                t1 = Тип.tfloat80;
                t2 = Тип.tfloat80;
                break;
            case Tchar:
                t1 = Тип.tuns8;
                break;
            case Twchar:
                t1 = Тип.tuns16;
                break;
            case Tdchar:
                t1 = Тип.tuns32;
                break;
            default:
                assert(0);
            }
            if (t1)
            {
                if (t2)
                    return twoTypes(t1, t2);
                else
                    return oneType(t1);
            }
            else
                return memory();
        }

        override проц посети(TypeVector t)
        {
            return oneType(t);
        }

        override проц посети(TypeAArray)
        {
            return oneType(Тип.tvoidptr);
        }

        override проц посети(TypePointer)
        {
            return oneType(Тип.tvoidptr);
        }

        /*************************************
         * Convert a floating point тип into the equivalent integral тип.
         */
        static Тип mergeFloatToInt(Тип t)
        {
            switch (t.ty)
            {
            case Tfloat32:
            case Timaginary32:
                t = Тип.tint32;
                break;
            case Tfloat64:
            case Timaginary64:
            case Tcomplex32:
                t = Тип.tint64;
                break;
            default:
                debug
                {
                    printf("mergeFloatToInt() %s\n", t.вТкст0());
                }
                assert(0);
            }
            return t;
        }

        /*************************************
         * This merges two types into an 8byte тип.
         * Параметры:
         *      t1 = first тип (can be null)
         *      t2 = second тип (can be null)
         *      offset2 = смещение of t2 from start of t1
         * Возвращает:
         *      тип that encompasses both t1 and t2, null if cannot be done
         */
        static Тип argtypemerge(Тип t1, Тип t2, бцел offset2)
        {
            //printf("argtypemerge(%s, %s, %d)\n", t1 ? t1.вТкст0() : "", t2 ? t2.вТкст0() : "", offset2);
            if (!t1)
            {
                assert(!t2 || offset2 == 0);
                return t2;
            }
            if (!t2)
                return t1;
            const sz1 = t1.size(Место.initial);
            const sz2 = t2.size(Место.initial);
            assert(sz1 != SIZE_INVALID && sz2 != SIZE_INVALID);
            if (t1.ty != t2.ty && (t1.ty == Tfloat80 || t2.ty == Tfloat80))
                return null;
            // [float,float] => [cfloat]
            if (t1.ty == Tfloat32 && t2.ty == Tfloat32 && offset2 == 4)
                return Тип.tfloat64;
            // Merging floating and non-floating types produces the non-floating тип
            if (t1.isfloating())
            {
                if (!t2.isfloating())
                    t1 = mergeFloatToInt(t1);
            }
            else if (t2.isfloating())
                t2 = mergeFloatToInt(t2);
            Тип t;
            // Pick тип with larger size
            if (sz1 < sz2)
                t = t2;
            else
                t = t1;
            // If t2 does not lie within t1, need to increase the size of t to enclose both
            бул overflow;
            const offset3 = addu(offset2, sz2, overflow);
            assert(!overflow);
            if (offset2 && sz1 < offset3)
            {
                switch (offset3)
                {
                case 2:
                    t = Тип.tint16;
                    break;
                case 3:
                case 4:
                    t = Тип.tint32;
                    break;
                default:
                    t = Тип.tint64;
                    break;
                }
            }
            return t;
        }

        override проц посети(TypeDArray)
        {
            /* Should be done as if it were:
             * struct S { т_мера length; ук ptr; }
             */
            if (isDMDx64Target() && !глоб2.парамы.isLP64)
            {
                // For AMD64 ILP32 ABI, D arrays fit into a single integer register.
                const смещение = cast(бцел)Тип.tт_мера.size(Место.initial);
                Тип t = argtypemerge(Тип.tт_мера, Тип.tvoidptr, смещение);
                if (t)
                {
                    return oneType(t);
                }
            }
            return twoTypes(Тип.tт_мера, Тип.tvoidptr);
        }

        override проц посети(TypeDelegate)
        {
            /* Should be done as if it were:
             * struct S { ук funcptr; ук ptr; }
             */
            if (isDMDx64Target() && !глоб2.парамы.isLP64)
            {
                // For AMD64 ILP32 ABI, delegates fit into a single integer register.
                const смещение = cast(бцел)Тип.tт_мера.size(Место.initial);
                Тип t = argtypemerge(Тип.tvoidptr, Тип.tvoidptr, смещение);
                if (t)
                {
                    return oneType(t);
                }
            }
            return twoTypes(Тип.tvoidptr, Тип.tvoidptr);
        }

        override проц посети(TypeSArray t)
        {
            const sz = t.size(Место.initial);
            if (sz > 16)
                return memory();

            const dim = t.dim.toInteger();
            Тип tn = t.следщ;
            const tnsize = tn.size();
            const tnalignsize = tn.alignsize();

            /*****
             * Get the nth element of this массив.
             * Параметры:
             *   n = element number, from 0..dim
             *   смещение = set to смещение of the element from the start of the массив
             *   alignsize = set to the aligned size of the element
             * Возвращает:
             *   тип of the element
             */
            extern (D) Тип getNthElement(т_мера n, out бцел смещение, out бцел alignsize)
            {
                смещение = cast(бцел)(n * tnsize);
                alignsize = tnalignsize;
                return tn;
            }

            aggregate(sz, cast(т_мера)dim, &getNthElement);
        }

        override проц посети(TypeStruct t)
        {
            //printf("TypeStruct.toArgTypes() %s\n", t.вТкст0());

            if (!t.sym.isPOD())
                return memory();

            /*****
             * Get the nth field of this struct.
             * Параметры:
             *   n = field number, from 0..nfields
             *   смещение = set to смещение of the field from the start of the тип
             *   alignsize = set to the aligned size of the field
             * Возвращает:
             *   тип of the field
             */
            extern (D) Тип getNthField(т_мера n, out бцел смещение, out бцел alignsize)
            {
                auto field = t.sym.fields[n];
                смещение = field.смещение;
                alignsize = field.тип.alignsize();
                return field.тип;
            }

            aggregate(t.size(Место.initial), t.sym.fields.dim, &getNthField);
        }

        /*******************
         * Handle aggregates (struct, union, and static массив) and set `результат`
         * Параметры:
         *      sz = total size of aggregate
         *      nfields = number of fields in the aggregate (dimension for static arrays)
         *      getFieldInfo = get information about the nth field in the aggregate
         */
        extern (D) проц aggregate(d_uns64 sz, т_мера nfields, Тип delegate(т_мера, out бцел, out бцел) getFieldInfo)
        {
            if (nfields == 0)
                return memory();

            if (isDMDx64Target())
            {
                if (sz == 0 || sz > 16)
                    return memory();

                Тип t1 = null;
                Тип t2 = null;

                foreach (n; new бцел[0 .. nfields])
                {
                    бцел foffset;
                    бцел falignsize;
                    Тип ftype = getFieldInfo(n, foffset, falignsize);

                    //printf("  [%u] ftype = %s\n", n, ftype.вТкст0());
                    КортежТипов tup = toArgTypes(ftype);
                    if (!tup)
                        return memory();
                    const dim = tup.arguments.dim;
                    Тип ft1 = null;
                    Тип ft2 = null;
                    switch (dim)
                    {
                    case 2:
                        ft1 = (*tup.arguments)[0].тип;
                        ft2 = (*tup.arguments)[1].тип;
                        break;
                    case 1:
                        if (foffset < 8)
                            ft1 = (*tup.arguments)[0].тип;
                        else
                            ft2 = (*tup.arguments)[0].тип;
                        break;
                    default:
                        return memory();
                    }
                    if (foffset & 7)
                    {
                        // Misaligned fields goto Lmemory
                        if (foffset & (falignsize - 1))
                            return memory();

                        // Fields that overlap the 8byte boundary goto memory
                        const fieldsz = ftype.size(Место.initial);
                        бул overflow;
                        const nextOffset = addu(foffset, fieldsz, overflow);
                        assert(!overflow);
                        if (foffset < 8 && nextOffset > 8)
                            return memory();
                    }
                    // First field in 8byte must be at start of 8byte
                    assert(t1 || foffset == 0);
                    //printf("ft1 = %s\n", ft1 ? ft1.вТкст0() : "null");
                    //printf("ft2 = %s\n", ft2 ? ft2.вТкст0() : "null");
                    if (ft1)
                    {
                        t1 = argtypemerge(t1, ft1, foffset);
                        if (!t1)
                            return memory();
                    }
                    if (ft2)
                    {
                        const off2 = ft1 ? 8 : foffset;
                        if (!t2 && off2 != 8)
                            return memory();
                        assert(t2 || off2 == 8);
                        t2 = argtypemerge(t2, ft2, off2 - 8);
                        if (!t2)
                            return memory();
                    }
                }
                if (t2)
                {
                    if (t1.isfloating() && t2.isfloating())
                    {
                        if ((t1.ty == Tfloat32 || t1.ty == Tfloat64) && (t2.ty == Tfloat32 || t2.ty == Tfloat64))
                        {
                        }
                        else
                            return memory();
                    }
                    else if (t1.isfloating() || t2.isfloating())
                        return memory();
                    return twoTypes(t1, t2);
                }

                //printf("\ttoArgTypes() %s => [%s,%s]\n", t.вТкст0(), t1 ? t1.вТкст0() : "", t2 ? t2.вТкст0() : "");
                if (t1)
                    return oneType(t1);
                else
                    return memory();
            }
            else
            {
                Тип t1 = null;
                switch (cast(бцел)sz)
                {
                case 1:
                    t1 = Тип.tint8;
                    break;
                case 2:
                    t1 = Тип.tint16;
                    break;
                case 4:
                    t1 = Тип.tint32;
                    break;
                case 8:
                    t1 = Тип.tint64;
                    break;
                case 16:
                    t1 = null; // could be a TypeVector
                    break;
                default:
                    return memory();
                }
                if (глоб2.парамы.isFreeBSD && nfields == 1 &&
                    (sz == 4 || sz == 8))
                {
                    /* FreeBSD changed their 32 bit ABI at some point before 10.3 for the following:
                     *  struct { float f;  } => arg1type is float
                     *  struct { double d; } => arg1type is double
                     * Cannot найди any documentation on it.
                     */

                    бцел foffset;
                    бцел falignsize;
                    Тип ftype = getFieldInfo(0, foffset, falignsize);
                    КортежТипов tup = toArgTypes(ftype);
                    if (tup && tup.arguments.dim == 1)
                    {
                        Тип ft1 = (*tup.arguments)[0].тип;
                        if (ft1.ty == Tfloat32 || ft1.ty == Tfloat64)
                            return oneType(ft1);
                    }
                }

                if (t1)
                    return oneType(t1);
                else
                    return memory();
            }
        }

        override проц посети(TypeEnum t)
        {
            t.toBasetype().прими(this);
        }

        override проц посети(TypeClass)
        {
            результат = new КортежТипов(Тип.tvoidptr);
        }
    }

    scope ToArgTypes v = new ToArgTypes();
    t.прими(v);
    return v.результат;
}
