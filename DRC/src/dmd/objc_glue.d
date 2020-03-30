/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 2015-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/objc_glue.d, _objc_glue.d)
 * Documentation:  https://dlang.org/phobos/dmd_objc_glue.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/objc_glue.d
 */

module dmd.objc_glue;

import cidrus;

import dmd.aggregate;
import dmd.arraytypes;
import dmd.dclass;
import dmd.declaration;
import dmd.dmodule;
import dmd.дсимвол;
import drc.ast.Expression;
import dmd.func;
import dmd.glue;
import drc.lexer.Identifier;
import dmd.mtype;
import dmd.objc;
import dmd.target;

import util.stringtable;

import drc.backend.dt;
import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.el;
import drc.backend.глоб2;
import drc.backend.oper;
import drc.backend.outbuf;
import drc.backend.ty;
import drc.backend.тип;
import drc.backend.mach;
import drc.backend.obj;

private  ObjcGlue _objc;

ObjcGlue objc()
{
    return _objc;
}

// Should be an interface
/*extern(C++)*/ abstract class ObjcGlue
{
    struct Elemрезультат
    {
        elem* ec;
        elem* ethis;
    }

    static проц initialize()
    {
        if (target.objc.supported)
            _objc = new Supported;
        else
            _objc = new Unsupported;
    }

    abstract проц setupMethodSelector(FuncDeclaration fd, elem** esel);

    abstract Elemрезультат setupMethodCall(FuncDeclaration fd, TypeFunction tf,
        бул directcall, elem* ec, elem* ehidden, elem* ethis);

    abstract проц setupEp(elem* esel, elem** ep, цел leftToRight);
    abstract проц generateModuleInfo(Module module_);

    /// Возвращает: the given Выражение converted to an `elem` structure
    abstract elem* toElem(ObjcClassReferenceExp e) ;

    /// Outputs the given Objective-C class to the объект файл.
    abstract проц toObjFile(ClassDeclaration classDeclaration) ;

    /**
     * Adds the selector параметр to the given list of parameters.
     *
     * For Objective-C methods the selector параметр is added. For
     * non-Objective-C methods `parameters` is unchanged.
     *
     * Параметры:
     *  functionDeclaration = the function declaration to add the selector
     *      параметр from
     *  parameters = the list of parameters to add the selector параметр to
     *  parameterCount = the number of parameters
     *
     * Возвращает: the new number of parameters
     */
    abstract т_мера addSelectorParameterSymbol(
        FuncDeclaration functionDeclaration,
        Symbol** parameters, т_мера parameterCount) ;

    /**
     * Возвращает the смещение of the given variable declaration `var`.
     *
     * This is используется in a `DotVarExp` to get the смещение of the variable the
     * Выражение is accessing.
     *
     * Instance variables in Objective-C are non-fragile. That means that the
     * base class can change (add or удали instance variables) without the
     * subclasses needing to recompile or relink. This is implemented instance
     * variables having a dynamic смещение. This is achieved by going through an
     * indirection in the form of a symbol generated in the binary. The compiler
     * outputs the static смещение in the generated symbol. Then, at load time,
     * the symbol is updated with the correct смещение, if necessary.
     *
     * Параметры:
     *  var = the variable declaration to return the смещение of
     *  тип = the тип of the `DotVarExp`
     *  смещение = the existing смещение
     *
     * Возвращает: a symbol containing the смещение of the variable declaration
     */
    abstract elem* getOffset(VarDeclaration var, Тип тип, elem* смещение) ;
}

private:

/*extern(C++)*/ final class Unsupported : ObjcGlue
{
    override проц setupMethodSelector(FuncDeclaration fd, elem** esel)
    {
        // noop
    }

    override Elemрезультат setupMethodCall(FuncDeclaration, TypeFunction, бул,
        elem*, elem*, elem*)
    {
        assert(0, "Should never be called when Objective-C is not supported");
    }

    override проц setupEp(elem* esel, elem** ep, цел reverse)
    {
        // noop
    }

    override проц generateModuleInfo(Module)
    {
        // noop
    }

    override elem* toElem(ObjcClassReferenceExp e) 
    {
        assert(0, "Should never be called when Objective-C is not supported");
    }

    override проц toObjFile(ClassDeclaration classDeclaration) 
    {
        assert(0, "Should never be called when Objective-C is not supported");
    }

    override т_мера addSelectorParameterSymbol(FuncDeclaration, Symbol**,
        т_мера count) 
    {
        return count;
    }

    override elem* getOffset(VarDeclaration var, Тип тип, elem* смещение) 
    {
        return смещение;
    }
}

/*extern(C++)*/ final class Supported : ObjcGlue
{
    this()
    {
        Segments.initialize();
        Symbols.initialize();
    }

    override проц setupMethodSelector(FuncDeclaration fd, elem** esel)
    {
        if (fd && fd.selector && !*esel)
        {
            *esel = el_var(Symbols.getMethVarRef(fd.selector.вТкст()));
        }
    }

    override Elemрезультат setupMethodCall(FuncDeclaration fd, TypeFunction tf,
        бул directcall, elem* ec, elem* ehidden, elem* ethis)
    {
//        import dmd.e2ir : addressElem;

        if (directcall) // super call
        {
            Elemрезультат результат;
            // call through Objective-C runtime dispatch
            результат.ec = el_var(Symbols.getMsgSendSuper(ehidden !is null));

            // need to change this pointer to a pointer to an two-word
            // objc_super struct of the form { this ptr, class ptr }.
            auto cd = fd.isThis.isClassDeclaration;
            assert(cd, "call to objc_msgSendSuper with no class declaration");

            // faking objc_super тип as delegate
            auto classRef = el_var(Symbols.getClassReference(cd));
            auto super_ = el_pair(TYdelegate, ethis, classRef);

            результат.ethis = addressElem(super_, tf);

            return результат;
        }

        else
        {
            // make objc-style "virtual" call using dispatch function
            assert(ethis);
            Тип tret = tf.следщ;

            Elemрезультат результат = {
                ec: el_var(Symbols.getMsgSend(tret, ehidden !is null)),
                ethis: ethis
            };

            return результат;
        }
    }

    override проц setupEp(elem* esel, elem** ep, цел leftToRight)
    {
        if (esel)
        {
            // using objc-style "virtual" call
            // add hidden argument (second to 'this') for selector используется by dispatch function
            if (leftToRight)
                *ep = el_param(esel, *ep);
            else
                *ep = el_param(*ep, esel);
        }
    }

    override проц generateModuleInfo(Module module_)
    {
        ClassDeclarations classes;
        ClassDeclarations categories;

        module_.члены.foreachDsymbol(/*m =>*/ m.addObjcSymbols(&classes, &categories));

        if (classes.length || categories.length || Symbols.hasSymbols)
            Symbols.getModuleInfo(classes, categories);
    }

    override elem* toElem(ObjcClassReferenceExp e) 
    {
        return el_var(Symbols.getClassReference(e.classDeclaration));
    }

    override проц toObjFile(ClassDeclaration classDeclaration) 
    in
    {
        assert(classDeclaration !is null);
        assert(classDeclaration.classKind == ClassKind.objc);
    }
    body
    {
        if (!classDeclaration.objc.isMeta)
            ObjcClassDeclaration(classDeclaration, нет).toObjFile();
    }

    override т_мера addSelectorParameterSymbol(FuncDeclaration fd,
        Symbol** парамы, т_мера count) 
    in
    {
        assert(fd);
    }
    body
    {
        if (!fd.selector)
            return count;

        assert(fd.selectorParameter);
        auto selectorSymbol = fd.selectorParameter.toSymbol();
        memmove(парамы + 1, парамы, count * парамы[0].sizeof);
        парамы[0] = selectorSymbol;

        return count + 1;
    }

    override elem* getOffset(VarDeclaration var, Тип тип, elem* смещение) 
    {
        auto typeClass = тип.isTypeClass;

        if (!typeClass || typeClass.sym.classKind != ClassKind.objc)
            return смещение;

        return el_var(ObjcClassDeclaration(typeClass.sym, нет).getIVarOffset(var));
    }
}

struct Segments
{
    enum Id
    {
        classlist,
        classname,
        classrefs,
        const_,
        данные,
        imageinfo,
        ivar,
        methname,
        methtype,
        selrefs
    }

    private
    {
         цел[Id] segments;
         Segments[Id] segmentData;

        ткст0 sectionName;
        ткст0 segmentName;
        const цел flags;
        const цел alignment;

        this(typeof(this.tupleof) кортеж)
        {
            this.tupleof = кортеж;
        }

        static проц initialize()
        {
            /+
            segmentData = [
                Id.classlist: Segments("__objc_classlist", "__DATA", S_REGULAR | S_ATTR_NO_DEAD_STRIP, 3),
                Id.classname: Segments("__objc_classname", "__TEXT", S_CSTRING_LITERALS, 0),
                Id.classrefs: Segments("__objc_classrefs", "__DATA", S_REGULAR | S_ATTR_NO_DEAD_STRIP, 3),
                Id.const_: Segments("__objc_const", "__DATA", S_REGULAR, 3),
                Id.данные: Segments("__objc_data", "__DATA", S_REGULAR, 3),
                Id.imageinfo: Segments("__objc_imageinfo", "__DATA", S_REGULAR | S_ATTR_NO_DEAD_STRIP, 0),
                Id.ivar: Segments("__objc_ivar", "__DATA", S_REGULAR, 3),
                Id.methname: Segments("__objc_methname", "__TEXT", S_CSTRING_LITERALS, 0),
                Id.methtype: Segments("__objc_methtype", "__TEXT", S_CSTRING_LITERALS, 0),
                Id.selrefs: Segments("__objc_selrefs", "__DATA", S_LITERAL_POINTERS | S_ATTR_NO_DEAD_STRIP, 3),
            ];
            +/
        }
    }

    static цел opIndex(Id ид)
    {
        if (auto segment = ид in segments)
            return *segment;

        const seg = segmentData[ид];

        version (OSX)
        {
            return segments[ид] = Obj.getsegment(
                seg.sectionName,
                seg.segmentName,
                seg.alignment,
                seg.flags
            );
        }

        else
        {
            // This should never happen. If the platform is not OSX an error
            // should have occurred sooner which should have prevented the
            // code from getting here.
            assert(0);
        }
    }
}

struct Symbols
{
static:

    private 
    {
        бул hasSymbols_ = нет;

        Symbol* objc_msgSend = null;
        Symbol* objc_msgSend_stret = null;
        Symbol* objc_msgSend_fpret = null;
        Symbol* objc_msgSend_fp2ret = null;

        Symbol* objc_msgSendSuper = null;
        Symbol* objc_msgSendSuper_stret = null;

        Symbol* imageInfo = null;
        Symbol* moduleInfo = null;

        Symbol* emptyCache = null;
        Symbol* emptyVTable = null;

        // Cache for `_OBJC_METACLASS_$_`/`_OBJC_CLASS_$_` symbols.
        ТаблицаСтрок!(Symbol*)* classNameTable = null;

        // Cache for `L_OBJC_CLASSLIST_REFERENCES_` symbols.
        ТаблицаСтрок!(Symbol*)* classReferenceTable = null;

        ТаблицаСтрок!(Symbol*)* methVarNameTable = null;
        ТаблицаСтрок!(Symbol*)* methVarRefTable = null;
        ТаблицаСтрок!(Symbol*)* methVarTypeTable = null;

        // Cache for instance variable offsets
        ТаблицаСтрок!(Symbol*)* ivarOffsetTable = null;
    }

    проц initialize()
    {
        initializeStringTables();
    }

    private проц initializeStringTables()
    {
        alias typeof(this) This;

        foreach (m ; __traits(allMembers, This))
        {
            static if (is(typeof(__traits(getMember, This, m)) == ТаблицаСтрок!(Symbol*)*))
            {
                __traits(getMember, This, m) = new ТаблицаСтрок!(Symbol*)();
                __traits(getMember, This, m)._иниц();
            }
        }
    }

    бул hasSymbols()
    {
        if (hasSymbols_)
            return да;

        alias typeof(this) This;

        foreach (m ; __traits(allMembers, This))
        {
            static if (is(typeof(__traits(getMember, This, m)) == Symbol*))
            {
                if (__traits(getMember, This, m) !is null)
                    return да;
            }
        }

        return нет;
    }

    /**
     * Convenience wrapper around `drc.backend.глоб2.symbol_name`.
     *
     * Allows to pass the имя of the symbol as a D ткст.
     */
    Symbol* symbolName(ткст имя, цел sclass, тип* t)
    {
        return symbol_name(имя.ptr, cast(бцел) имя.length, sclass, t);
    }

    /**
     * Gets a глоб2 symbol.
     *
     * Параметры:
     *  имя = the имя of the symbol
     *  t = the тип of the symbol
     *
     * Возвращает: the symbol
     */
    Symbol* getGlobal(ткст имя, тип* t = type_fake(TYnptr))
    {
        return symbolName(имя, SCglobal, t);
    }

    /**
     * Gets a static symbol.
     *
     * Параметры:
     *  имя = the имя of the symbol
     *  t = the тип of the symbol
     *
     * Возвращает: the symbol
     */
    Symbol* getStatic(ткст имя, тип* t = type_fake(TYnptr))
    {
        return symbolName(имя, SCstatic, t);
    }

    Symbol* getCString(ткст str, ткст symbolName, Segments.Id segment)
    {
        hasSymbols_ = да;

        // создай данные
        auto dtb = DtBuilder(0);
        dtb.члобайт(cast(бцел) (str.length + 1), str.вТкст0());

        // найди segment
        auto seg = Segments[segment];

        // создай symbol
        auto s = getStatic(symbolName, type_allocn(TYarray, tstypes[TYchar]));
        s.Sdt = dtb.finish();
        s.Sseg = seg;
        return s;
    }

    Symbol* getMethVarName(ткст имя)
    {
        hasSymbols_ = да;

        auto stringValue = methVarNameTable.update(имя);
        auto symbol = stringValue.значение;

        if (!symbol)
        {
             т_мера classNameCount = 0;
            сим[42] буфер;
            const symbolName = format(буфер, "L_OBJC_METH_VAR_NAME_%lu", classNameCount++);
            symbol = getCString(имя, symbolName, Segments.Id.methname);
            stringValue.значение = symbol;
        }

        return symbol;
    }

    Symbol* getMethVarName(Идентификатор2 идент)
    {
        return getMethVarName(идент.вТкст());
    }

    Symbol* getMsgSend(Тип returnType, бул hasHiddenArgument)
    {
        if (hasHiddenArgument)
            return setMsgSendSymbol!("_objc_msgSend_stret")(TYhfunc);
        // not sure if DMD can handle this
        else if (returnType.ty == Tcomplex80)
            return setMsgSendSymbol!("_objc_msgSend_fp2ret");
        else if (returnType.ty == Tfloat80)
            return setMsgSendSymbol!("_objc_msgSend_fpret");
        else
            return setMsgSendSymbol!("_objc_msgSend");

        assert(0);
    }

    Symbol* getMsgSendSuper(бул hasHiddenArgument)
    {
        if (hasHiddenArgument)
            return setMsgSendSymbol!("_objc_msgSendSuper_stret")(TYhfunc);
        else
            return setMsgSendSymbol!("_objc_msgSendSuper")(TYnfunc);
    }

    Symbol* getImageInfo()
    {
        if (imageInfo)
            return imageInfo;

        auto dtb = DtBuilder(0);
        dtb.dword(0); // version
        dtb.dword(64); // flags

        imageInfo = symbol_name("L_OBJC_IMAGE_INFO", SCstatic, type_allocn(TYarray, tstypes[TYchar]));
        imageInfo.Sdt = dtb.finish();
        imageInfo.Sseg = Segments[Segments.Id.imageinfo];
        outdata(imageInfo);

        return imageInfo;
    }

    Symbol* getModuleInfo(/*const*/ ref ClassDeclarations classes,
        /*const*/ ref ClassDeclarations categories)
    {
        assert(!moduleInfo); // only allow once per объект файл

        auto dtb = DtBuilder(0);

        foreach (c; classes)
            dtb.xoff(getClassName(c), 0);

        foreach (c; categories)
            dtb.xoff(getClassName(c), 0);

        Symbol* symbol = symbol_name("L_OBJC_LABEL_CLASS_$", SCstatic, type_allocn(TYarray, tstypes[TYchar]));
        symbol.Sdt = dtb.finish();
        symbol.Sseg = Segments[Segments.Id.classlist];
        outdata(symbol);

        getImageInfo(); // make sure we also generate image info

        return moduleInfo;
    }

    /**
     * Возвращает: the `_OBJC_METACLASS_$_`/`_OBJC_CLASS_$_` symbol for the given
     *  class declaration.
     */
    Symbol* getClassName(ObjcClassDeclaration objcClass)
    {
        hasSymbols_ = да;

        const префикс = objcClass.isMeta ? "_OBJC_METACLASS_$_" : "_OBJC_CLASS_$_";
        auto имя = префикс ~ objcClass.classDeclaration.objc.идентификатор.вТкст();

        auto stringValue = classNameTable.update(имя);
        auto symbol = stringValue.значение;

        if (symbol)
            return symbol;

        symbol = getGlobal(имя);
        stringValue.значение = symbol;

        return symbol;
    }

    /// ditto
    Symbol* getClassName(ClassDeclaration classDeclaration, бул isMeta = нет)
    in
    {
        assert(classDeclaration !is null);
    }
    body
    {
        return getClassName(ObjcClassDeclaration(classDeclaration, isMeta));
    }

    /*
     * Возвращает: the `L_OBJC_CLASSLIST_REFERENCES_$_` symbol for the given class
     *  declaration.
     */
    Symbol* getClassReference(ClassDeclaration classDeclaration)
    {
        hasSymbols_ = да;

        auto имя = classDeclaration.objc.идентификатор.вТкст();

        auto stringValue = classReferenceTable.update(имя);
        auto symbol = stringValue.значение;

        if (symbol)
            return symbol;

        auto dtb = DtBuilder(0);
        auto className = getClassName(classDeclaration);
        dtb.xoff(className, 0, TYnptr);

        auto segment = Segments[Segments.Id.classrefs];

         т_мера classReferenceCount = 0;

        сим[42] nameString;
        auto результат = format(nameString, "L_OBJC_CLASSLIST_REFERENCES_$_%lu", classReferenceCount++);
        symbol = getStatic(результат);
        symbol.Sdt = dtb.finish();
        symbol.Sseg = segment;
        outdata(symbol);

        stringValue.значение = symbol;

        return symbol;
    }

    Symbol* getMethVarRef(ткст имя)
    {
        hasSymbols_ = да;

        auto stringValue = methVarRefTable.update(имя);
        auto refSymbol = stringValue.значение;
        if (refSymbol is null)
        {
            // создай данные
            auto dtb = DtBuilder(0);
            auto selector = getMethVarName(имя);
            dtb.xoff(selector, 0, TYnptr);

            // найди segment
            auto seg = Segments[Segments.Id.selrefs];

            // создай symbol
             т_мера selectorCount = 0;
            сим[42] nameString;
            sprintf(nameString.ptr, "L_OBJC_SELECTOR_REFERENCES_%lu", selectorCount);
            refSymbol = symbol_name(nameString.ptr, SCstatic, type_fake(TYnptr));

            refSymbol.Sdt = dtb.finish();
            refSymbol.Sseg = seg;
            outdata(refSymbol);
            stringValue.значение = refSymbol;

            ++selectorCount;
        }
        return refSymbol;
    }

    Symbol* getMethVarRef(Идентификатор2 идент)
    {
        return getMethVarRef(идент.вТкст());
    }

    /**
     * Возвращает the Objective-C тип encoding for the given тип.
     *
     * The доступно тип encodings are documented by Apple, доступно at
     * $(LINK2 https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100, Тип Encoding).
     * The тип encodings can also be obtained by running an Objective-C
     * compiler and using the `@encode()` compiler directive.
     *
     * Параметры:
     *  тип = the тип to return the тип encoding for
     *
     * Возвращает: a ткст containing the тип encoding
     */
    ткст getTypeEncoding(Тип тип)
    in
    {
        assert(тип !is null);
    }
    body
    {
        const assertMessage = "imaginary types are not supported by Objective-C";

        with (ENUMTY) switch (тип.ty)
        {
            case Tvoid: return "v";
            case Tbool: return "B";
            case Tint8: return "c";
            case Tuns8: return "C";
            case Tchar: return "C";
            case Tint16: return "s";
            case Tuns16: return "S";
            case Twchar: return "S";
            case Tint32: return "i";
            case Tuns32: return "I";
            case Tdchar: return "I";
            case Tint64: return "q";
            case Tuns64: return "Q";
            case Tfloat32: return "f";
            case Tcomplex32: return "jf";
            case Tfloat64: return "d";
            case Tcomplex64: return "jd";
            case Tfloat80: return "D";
            case Tcomplex80: return "jD";
            case Timaginary32: assert(нет, assertMessage);
            case Timaginary64: assert(нет, assertMessage);
            case Timaginary80: assert(нет, assertMessage);
            default: return "?"; // unknown
            // TODO: add "*" сим*, "#" Class, "@" ид, ":" SEL
            // TODO: add "^"<тип> indirection and "^^" double indirection
        }
    }

    /**
     * Возвращает: the `L_OBJC_METH_VAR_TYPE_` symbol containing the given
     * тип encoding.
     */
    Symbol* getMethVarType(ткст typeEncoding)
    {
        hasSymbols_ = да;

        auto stringValue = methVarTypeTable.update(typeEncoding);
        auto symbol = stringValue.значение;

        if (symbol)
            return symbol;

         т_мера count = 0;
        сим[42] nameString;
        const symbolName = format(nameString, "L_OBJC_METH_VAR_TYPE_%lu", count++);
        symbol = getCString(typeEncoding, symbolName, Segments.Id.methtype);

        stringValue.значение = symbol;
        outdata(symbol);

        return symbol;
    }

    /// ditto
    Symbol* getMethVarType(Тип[] types ...)
    {
        ткст typeCode;
        typeCode.резервируй(types.length);

        foreach (тип; types)
            typeCode ~= getTypeEncoding(тип);

        return getMethVarType(typeCode);
    }

    /// ditto
    Symbol* getMethVarType(FuncDeclaration func)
    {
        Тип[] types = [func.тип.nextOf]; // return тип first

        if (func.parameters)
        {
            types.резервируй(func.parameters.length);

            foreach (e; *func.parameters)
                types ~= e.тип;
        }

        return getMethVarType(types);
    }

    /// Возвращает: the externally defined `__objc_empty_cache` symbol
    Symbol* getEmptyCache()
    {
        return emptyCache = emptyCache ? emptyCache : getGlobal("__objc_empty_cache");
    }

    /// Возвращает: the externally defined `__objc_empty_vtable` symbol
    Symbol* getEmptyVTable()
    {
        return emptyVTable = emptyVTable ? emptyVTable : getGlobal("__objc_empty_vtable");
    }

    /// Возвращает: the `L_OBJC_CLASS_NAME_` symbol for a class with the given имя
    Symbol* getClassNameRo(ткст имя)
    {
        hasSymbols_ = да;

        auto stringValue = classNameTable.update(имя);
        auto symbol = stringValue.значение;

         т_мера count = 0;
        сим[42] nameString;
        const symbolName = format(nameString, "L_OBJC_CLASS_NAME_%lu", count++);
        symbol = getCString(имя, symbolName, Segments.Id.classname);
        stringValue.значение = symbol;

        return symbol;
    }

    /// ditto
    Symbol* getClassNameRo( Идентификатор2 идент)
    {
        return getClassNameRo(идент.вТкст());
    }

    Symbol* getIVarOffset(ClassDeclaration cd, VarDeclaration var, бул outputSymbol)
    {
        hasSymbols_ = да;

        const className = cd.objc.идентификатор.вТкст;
        const varName = var.идент.вТкст;
        const имя = "_OBJC_IVAR_$_" ~ className ~ '.' ~ varName;

        auto stringValue = ivarOffsetTable.update(имя);
        auto symbol = stringValue.значение;

        if (!symbol)
        {
            symbol = getGlobal(имя);
            symbol.Sfl |= FLextern;
            stringValue.значение = symbol;
        }

        if (!outputSymbol)
            return symbol;

        auto dtb = DtBuilder(0);
        dtb.size(var.смещение);

        symbol.Sdt = dtb.finish();
        symbol.Sseg = Segments[Segments.Id.ivar];
        symbol.Sfl &= ~FLextern;

        outdata(symbol);

        return symbol;
    }

    private Symbol* setMsgSendSymbol(ткст имя)(tym_t ty = TYnfunc)
    {
        alias typeof(this) This ;
        const fieldName = имя[1 .. $];

        if (!__traits(getMember, This, fieldName))
            __traits(getMember, This, fieldName) = getGlobal(имя, type_fake(ty));

        return __traits(getMember, This, fieldName);
    }
}

private:

/**
 * Functionality for outputting symbols for a specific Objective-C class
 * declaration.
 */
struct ObjcClassDeclaration
{
    /// Indicates what вид of class this is.
    private enum Flags
    {
        /// Regular class.
        regular = 0x00000,

        /// Meta class.
        meta = 0x00001,

        /// Root class. A class without any base class.
        root = 0x00002
    }

    /// The class declaration
    ClassDeclaration classDeclaration;

    /// `да` if this class is a metaclass.
    бул isMeta;

    this(ClassDeclaration classDeclaration, бул isMeta)
    in
    {
        assert(classDeclaration !is null);
    }
    body
    {
        this.classDeclaration = classDeclaration;
        this.isMeta = isMeta;
    }

    /**
     * Outputs the class declaration to the объект файл.
     *
     * Возвращает: the exported symbol, that is, `_OBJC_METACLASS_$_` or
     * `_OBJC_CLASS_$_`
     */
    Symbol* toObjFile()
    {
        if (classDeclaration.objc.isExtern)
            return null; // only a declaration for an externally-defined class

        auto dtb = DtBuilder(0);
        toDt(dtb);

        auto symbol = Symbols.getClassName(this);
        symbol.Sdt = dtb.finish();
        symbol.Sseg = Segments[Segments.Id.данные];
        outdata(symbol);

        return symbol;
    }

private:

    /**
     * Outputs the class declaration to the объект файл.
     *
     * Параметры:
     *  dtb = the `DtBuilder` to output the class declaration to
     */
    проц toDt(ref DtBuilder dtb)
    {
        auto baseClassSymbol = classDeclaration.baseClass ?
            Symbols.getClassName(classDeclaration.baseClass, isMeta) : null;

        dtb.xoff(getMetaclass(), 0); // pointer to metaclass
        dtb.xoffOrNull(baseClassSymbol); // pointer to base class
        dtb.xoff(Symbols.getEmptyCache(), 0);
        dtb.xoff(Symbols.getEmptyVTable(), 0);
        dtb.xoff(getClassRo(), 0);
    }

    /// Возвращает: the имя of the metaclass of this class declaration
    Symbol* getMetaclass()
    {
        if (isMeta)
        {
            // metaclass: return root class's имя
            // (will be replaced with metaclass reference at load)

            auto metaclassDeclaration = classDeclaration;

            while (metaclassDeclaration.baseClass)
                metaclassDeclaration = metaclassDeclaration.baseClass;

            return Symbols.getClassName(metaclassDeclaration, да);
        }

        else
        {
            // regular class: return metaclass with the same имя
            return ObjcClassDeclaration(classDeclaration, да).toObjFile();
        }
    }

    /**
     * Возвращает: the `l_OBJC_CLASS_RO_$_`/`l_OBJC_METACLASS_RO_$_` symbol for
     * this class declaration
     */
    Symbol* getClassRo()
    {
        auto dtb = DtBuilder(0);

        dtb.dword(flags);
        dtb.dword(instanceStart);
        dtb.dword(instanceSize);
        dtb.dword(0); // reserved

        dtb.size(0); // ivar layout
        dtb.xoff(Symbols.getClassNameRo(classDeclaration.идент), 0); // имя of the class

        dtb.xoffOrNull(getMethodList()); // instance method list
        dtb.xoffOrNull(getProtocolList()); // protocol list

        if (isMeta)
        {
            dtb.size(0); // instance variable list
            dtb.size(0); // weak ivar layout
            dtb.size(0); // properties
        }

        else
        {
            dtb.xoffOrNull(getIVarList()); // instance variable list
            dtb.size(0); // weak ivar layout
            dtb.xoffOrNull(getPropertyList()); // properties
        }

        const префикс = isMeta ? "l_OBJC_METACLASS_RO_$_" : "l_OBJC_CLASS_RO_$_";
        const symbolName = префикс ~ classDeclaration.objc.идентификатор.вТкст();
        auto symbol = Symbols.getStatic(symbolName);

        symbol.Sdt = dtb.finish();
        symbol.Sseg = Segments[Segments.Id.const_];
        outdata(symbol);

        return symbol;
    }

    /**
     * Возвращает method list for this class declaration.
     *
     * This is a list of all methods defined in this class declaration, i.e.
     * methods with a body.
     *
     * Возвращает: the symbol for the method list, `l_OBJC_$_CLASS_METHODS_` or
     * `l_OBJC_$_INSTANCE_METHODS_`
     */
    Symbol* getMethodList()
    {
        /**
         * Возвращает the number of methods that should be added to the binary.
         *
         * Only methods with a body should be added.
         *
         * Параметры:
         *  члены = the члены of the class declaration
         */
        static цел methodCount(Дсимволы* члены)
        {
            цел count;

            члены.foreachDsymbol((member) {
                const func = member.isFuncDeclaration;

                if (func && func.fbody)
                    count++;
            });

            return count;
        }

        auto methods = isMeta ? classDeclaration.objc.metaclass.objc.methodList :
            classDeclaration.objc.methodList;

        const count = methodCount(methods);

        if (count == 0)
            return null;

        auto dtb = DtBuilder(0);

        dtb.dword(24); // _objc_method.sizeof
        dtb.dword(count); // method count

        methods.foreachDsymbol((method) {
            auto func = method.isFuncDeclaration;

            if (func && func.fbody)
            {
                assert(func.selector);
                dtb.xoff(func.selector.toNameSymbol(), 0); // method имя
                dtb.xoff(Symbols.getMethVarType(func), 0); // method тип ткст
                dtb.xoff(func.toSymbol(), 0); // function implementation
            }
        });

        const префикс = isMeta ? "l_OBJC_$_CLASS_METHODS_" : "l_OBJC_$_INSTANCE_METHODS_";
        const symbolName = префикс ~ classDeclaration.objc.идентификатор.вТкст();
        auto symbol = Symbols.getStatic(symbolName);

        symbol.Sdt = dtb.finish();
        symbol.Sseg = Segments[Segments.Id.const_];

        return symbol;
    }

    Symbol* getProtocolList()
    {
        // protocols are not supported yet
        return null;
    }

    Symbol* getIVarList()
    {
        if (isMeta || classDeclaration.fields.length == 0)
            return null;

        auto dtb = DtBuilder(0);

        dtb.dword(32); // entsize, _ivar_t.sizeof
        dtb.dword(cast(цел) classDeclaration.fields.length); // ivar count

        foreach (field; classDeclaration.fields)
        {
            auto var = field.isVarDeclaration;
            assert(var);
            assert((var.класс_хранения & STC.static_) == 0);

            dtb.xoff(Symbols.getIVarOffset(classDeclaration, var, да), 0); // pointer to ivar смещение
            dtb.xoff(Symbols.getMethVarName(var.идент), 0); // имя
            dtb.xoff(Symbols.getMethVarType(var.тип), 0); // тип ткст
            dtb.dword(var.alignment);
            dtb.dword(cast(цел) var.size(var.место));
        }

        const префикс = "l_OBJC_$_INSTANCE_VARIABLES_";
        const symbolName = префикс ~ classDeclaration.objc.идентификатор.вТкст();
        auto symbol = Symbols.getStatic(symbolName);

        symbol.Sdt = dtb.finish();
        symbol.Sseg = Segments[Segments.Id.const_];

        return symbol;
    }

    Symbol* getPropertyList()
    {
        // properties are not supported yet
        return null;
    }

    Symbol* getIVarOffset(VarDeclaration var)
    {
        if (var.toParent() is classDeclaration)
            return Symbols.getIVarOffset(classDeclaration, var, нет);

        else if (classDeclaration.baseClass)
            return ObjcClassDeclaration(classDeclaration.baseClass, нет)
                .getIVarOffset(var);

        else
            assert(нет, "Trying to get the base class of a root class");
    }

    /**
     * Возвращает the flags for this class declaration.
     *
     * That is, if this is a regular class, a metaclass and/or a root class.
     *
     * Возвращает: the flags
     */
    бцел flags()
    {
        бцел flags = isMeta ? Flags.meta : Flags.regular;

        if (classDeclaration.objc.isRootClass)
            flags |= Flags.root;

        return flags;
    }

    /**
     * Возвращает the смещение of where an instance of this class starts.
     *
     * For a metaclass this is always `40`. For a class with no instance
     * variables this is the size of the class declaration. For a class with
     * instance variables it's the смещение of the first instance variable.
     *
     * Возвращает: the instance start
     */
    цел instanceStart()
    {
        if (isMeta)
            return 40;

        const start = cast(бцел) classDeclaration.size(classDeclaration.место);

        if (!classDeclaration.члены || classDeclaration.члены.length == 0)
            return start;

        foreach (member; *classDeclaration.члены)
        {
            auto var = member.isVarDeclaration;

            if (var && var.isField)
                return var.смещение;
        }

        return start;
    }

    /// Возвращает: the size of an instance of this class
    цел instanceSize()
    {
        return isMeta ? 40 : cast(цел) classDeclaration.size(classDeclaration.место);
    }
}

/*
 * Formats the given arguments into the given буфер.
 *
 * Convenience wrapper around `snprintf`.
 *
 * Параметры:
 *  bufLength = length of the буфер
 *  буфер = the буфер where to store the результат
 *  format = the format ткст
 *  args = the arguments to format
 *
 * Возвращает: the formatted результат, a slice of the given буфер
 */
ткст format(т_мера bufLength, Args...)(ref сим[bufLength] буфер,
    ткст0 format,  Args args)
{
    auto length = snprintf(буфер.ptr, буфер.length, format, args);

    assert(length >= 0, "An output error occurred");
    assert(length < буфер.length, "Output was truncated");

    return буфер[0 .. length];
}

/// Возвращает: the symbol of the given selector
Symbol* toNameSymbol(ObjcSelector* selector)
{
    return Symbols.getMethVarName(selector.вТкст());
}

/**
 * Adds a reference to the given `symbol` or null if the symbol is null.
 *
 * Параметры:
 *  dtb = the dt builder to add the symbol to
 *  symbol = the symbol to add
 */
проц xoffOrNull(ref DtBuilder dtb, Symbol* symbol)
{
    if (symbol)
        dtb.xoff(symbol, 0);
    else
        dtb.size(0);
}

/**
 * Converts the given D ткст to a null terminated C ткст.
 *
 * Asserts if `str` is longer than `maxLength`, with assertions enabled. With
 * assertions disabled it will truncate the результат to `maxLength`.
 *
 * Параметры:
 *  maxLength = the max length of `str`
 *  str = the ткст to convert
 *  буф = the буфер where to размести the результат. By default this will be
 *      allocated in the caller scope using `alloca`. If the буфер is created
 *      by the callee it needs to be able to fit at least `str.length + 1` bytes
 *
 * Возвращает: the given ткст converted to a C ткст, a slice of `str` or the
 *  given буфер `буфер`
 */
ткст0 вТкст0(т_мера maxLength = 4095)(in ткст str,
     проц[] буфер = alloca(maxLength + 1)[0 .. maxLength + 1]) 
in
{
    assert(maxLength >= str.length);
}
out(результат)
{
    assert(str.length == результат.strlen);
}
body
{
    if (str.length == 0)
        return "".ptr;

    const maxLength = буфер.length - 1;
    const len = str.length > maxLength ? maxLength : str.length;
    auto буф = cast(ткст) буфер[0 .. len + 1];
    буф[0 .. len] = str[0 .. len];
    буф[len] = '\0';

    return cast(сим*) буф.ptr;
}
