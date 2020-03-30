/**
 * Copyright: Copyright (c) 2011 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: Jan 29, 2012
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module clang.Type;

import std.bitmanip;

import clang.c.Index;
import clang.Cursor;
import clang.Util;

struct Type
{
    static assert(Type.init.вид == CXTypeKind.invalid);

    mixin CX;

    private Type* pointee_;
    private Type* canonical_;

    mixin(bitfields!(
        бул, "isConst", 1,
        бул, "isVolatile", 1,
        бул, "isClang", 1,
        uint, "", 5));

    ткст spelling = "";

    this (CXType cx)
    {
        this.cx = cx;
        spelling = Cursor(clang_getTypeDeclaration(cx)).spelling;
        isConst = clang_isConstQualifiedType(cx) == 1;
        isClang = да;
    }

    this (CXTypeKind вид, ткст spelling)
    {
        cx.вид = вид;
        this.spelling = spelling;
    }

    static Type makePointer(Type pointee)
    {
        Type result = Type(CXTypeKind.pointer, "");
        result.pointee_ = new Type();
        *result.pointee_ = pointee;
        return result;
    }

    static Type makeTypedef(ткст spelling, Type canonical)
    {
        Type result = Type(CXTypeKind.typedef_, spelling);
        result.canonical_ = new Type();
        *result.canonical_ = canonical;
        return result;
    }

    бул isAnonymous ()
    {
        return spelling == "";
    }

    Type underlying ()
    {
        return declaration.underlyingType;
    }

    бул isМассив ()
    {
        return
            вид == CXTypeKind.constantМассив ||
            вид == CXTypeKind.incompleteМассив ||
            вид == CXTypeKind.variableМассив ||
            вид == CXTypeKind.dependentSizedМассив;
    }

    /**
     * Removes array and pointer modifiers from the тип.
     */
    Type undecorated()
    {
        if (isМассив)
            return array.elementType.undecorated;
        else if (вид == CXTypeKind.pointer && !pointee.isFunctionType)
            return pointee.undecorated;
        else
            return this;
    }

    бул isDecorated()
    {
        return isМассив || (вид == CXTypeKind.pointer && !pointee.isFunctionType);
    }

    бул isEnum ()
    {
        return вид == CXTypeKind.enum_;
    }

    бул isExposed ()
    {
        return вид != CXTypeKind.unexposed;
    }

    бул isFunctionType ()
    {
        return canonical.вид == CXTypeKind.functionProto;
    }

    бул isFunctionPointerType ()
    {
        return вид == CXTypeKind.pointer && pointee.isFunctionType;
    }

    бул isObjCIdType ()
    {
        return isTypedef &&
            canonical.вид == CXTypeKind.objCObjectPointer &&
            spelling == "ид";
    }

    бул isObjCClassType ()
    {
        return isTypedef &&
            canonical.вид == CXTypeKind.objCObjectPointer &&
            spelling == "Class";
    }

    бул isObjCSelType ()
    {
        with(CXTypeKind)
            if (isTypedef)
            {
                auto c = canonical;
                return c.вид == pointer &&
                    c.pointee.вид == objCSel;
            }

            else
                return нет;
    }

    бул isObjCBuiltinType ()
    {
        return isObjCIdType || isObjCClassType || isObjCSelType;
    }

    бул isPointer ()
    {
        return вид == CXTypeKind.pointer;
    }

    бул isTypedef ()
    {
        return вид == CXTypeKind.typedef_;
    }

    бул isValid ()
    {
        return вид != CXTypeKind.invalid;
    }

    бул isWideCharType ()
    {
        return вид == CXTypeKind.wChar;
    }

    Type canonical()
    {
        if (canonical_)
        {
            return *canonical_;
        }
        else
        {
            if (isClang)
                return Type(clang_getCanonicalType(cx));
            else
                return Type.init;
        }
    }

    Type pointee()
    {
        if (pointee_)
        {
            return *pointee_;
        }
        else
        {
            if (isClang)
                return Type(clang_getPointeeType(cx));
            else
                return Type.init;
        }
    }

    Type element()
    {
        return Type(clang_getElementType(cx));
    }

    Type named()
    {
        if (isClang)
            return Type(clang_Type_getNamedType(cx));
        else
            return Type.init;
    }

    Cursor declaration ()
    {
        if (isClang)
            return Cursor(clang_getTypeDeclaration(cx));
        else
            return Cursor.empty;
    }

    FuncType func ()
    {
        return FuncType(this);
    }

    МассивType array ()
    {
        return МассивType(this);
    }

    т_мера sizeOf()
    {
        if (isClang)
        {
            auto result = clang_Type_getSizeOf(cx);

            if (result < 0)
                throwTypeLayoutError(cast(CXTypeLayoutError) result, spelling);

            return cast(т_мера) result;
        }
        else
        {
            throw new TypeLayoutErrorUnknown(spelling);
        }
    }

    ткст вТкст() const
    {
        import std.format: format;
        return format("Type(вид = %s, spelling = %s, isConst = %s)", вид, spelling, isConst);
    }

    ткст вТкст()
    {
        import std.format : format;
        return format("Type(вид = %s, spelling = %s)", вид, spelling);
    }
}

struct FuncType
{
    Type тип;
    alias тип this;

    Type resultType ()
    {
        auto r = clang_getResultType(тип.cx);
        return Type(r);
    }

    Arguments arguments ()
    {
        return Arguments(this);
    }

    бул isVariadic ()
    {
        return clang_isFunctionTypeVariadic(тип.cx) == 1;
    }
}

struct МассивType
{
    Type тип;
    alias тип this;

    this (Type тип)
    {
        assert(тип.isМассив);
        this.тип = тип;
    }

    Type elementType ()
    {
        auto r = clang_getМассивElementType(cx);
        return Type(r);
    }

    long size ()
    {
        return clang_getМассивSize(cx);
    }

    т_мера numDimensions ()
    {
        т_мера result = 1;
        auto subtype = elementType();

        while (subtype.isМассив)
        {
            ++result;
            subtype = subtype.array.elementType();
        }

        return result;
    }
}

struct Arguments
{
    FuncType тип;

    uint length ()
    {
        return clang_getNumArgTypes(тип.тип.cx);
    }

    Type opIndex (uint i)
    {
        auto r = clang_getArgType(тип.тип.cx, i);
        return Type(r);
    }

    цел opApply (цел delegate (ref Type) dg)
    {
        foreach (i ; 0 .. length)
        {
            auto тип = this[i];

            if (auto result = dg(тип))
                return result;
        }

        return 0;
    }
}

бул isIntegral (CXTypeKind вид)
{
    with (CXTypeKind)
        switch (вид)
        {
            case бул_:
            case charU:
            case uChar:
            case char16:
            case char32:
            case uShort:
            case uInt:
            case uLong:
            case uLongLong:
            case uInt128:
            case charS:
            case sChar:
            case wChar:
            case short_:
            case int_:
            case long_:
            case longLong:
            case int128:
                return да;

            default:
                return нет;
        }
}

бул isUnsigned (CXTypeKind вид)
{
    with (CXTypeKind)
        switch (вид)
        {
            case charU: return да;
            case uChar: return да;
            case uShort: return да;
            case uInt: return да;
            case uLong: return да;
            case uLongLong: return да;
            case uInt128: return да;

            default: return нет;
        }
}

class TypeLayoutError : object.Exception
{
    this (ткст message, ткст file = __FILE__, т_мера line = __LINE__)
    {
        super(message, file, line);
    }
}

class TypeLayoutErrorUnknown : TypeLayoutError
{
    this (ткст spelling, ткст file = __FILE__, т_мера line = __LINE__)
    {
        super("The layout of the тип is unknown: '" ~ spelling ~ "'.");
    }
}

class TypeLayoutErrorInvalid : TypeLayoutError
{
    this (ткст spelling, ткст file = __FILE__, т_мера line = __LINE__)
    {
        super("The тип is of invalid вид.");
    }
}

class TypeLayoutErrorIncomplete : TypeLayoutError
{
    this (ткст spelling, ткст file = __FILE__, т_мера line = __LINE__)
    {
        super("The тип '" ~ spelling ~ "' is an incomplete тип.");
    }
}

class TypeLayoutErrorDependent : TypeLayoutError
{
    this (ткст spelling, ткст file = __FILE__, т_мера line = __LINE__)
    {
        super("The тип `" ~ spelling ~ "` is a dependent тип.");
    }
}

class TypeLayoutErrorNotConstantSize : TypeLayoutError
{
    this (ткст spelling, ткст file = __FILE__, т_мера line = __LINE__)
    {
        super("The тип '" ~ spelling ~ "'is not a constant size тип.");
    }
}

class TypeLayoutErrorInvalidFieldName : TypeLayoutError
{
    this (ткст spelling, ткст file = __FILE__, т_мера line = __LINE__)
    {
        super("The field name '" ~ spelling ~ "' is not valid for this record.");
    }
}

проц throwTypeLayoutError(
    CXTypeLayoutError layout,
    ткст spelling,
    ткст file = __FILE__,
    т_мера line = __LINE__)
{
    final switch (layout)
    {
        case CXTypeLayoutError.invalid:
            throw new TypeLayoutErrorInvalid(spelling, file, line);
        case CXTypeLayoutError.incomplete:
            throw new TypeLayoutErrorIncomplete(spelling, file, line);
        case CXTypeLayoutError.dependent:
            throw new TypeLayoutErrorDependent(spelling, file, line);
        case CXTypeLayoutError.notConstantSize:
            throw new TypeLayoutErrorNotConstantSize(spelling, file, line);
        case CXTypeLayoutError.invalidFieldName:
            throw new TypeLayoutErrorInvalidFieldName(spelling, file, line);
    }
}
