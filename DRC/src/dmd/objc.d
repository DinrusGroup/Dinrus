/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/objc.d, _objc.d)
 * Documentation:  https://dlang.org/phobos/dmd_objc.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/objc.d
 */

module dmd.objc;

import dmd.aggregate;
import dmd.arraytypes;
import dmd.attrib;
import dmd.cond;
import dmd.dclass;
import dmd.declaration;
import dmd.dmangle;
import dmd.dmodule;
import dmd.dscope;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.errors;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.func;
import dmd.globals;
import dmd.gluelayer;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.mtype;
import util.outbuffer;
import util.stringtable;
import dmd.target;

struct ObjcSelector
{
    // MARK: Selector
    private  ТаблицаСтрок!(ObjcSelector*) stringtable;
    private  цел incnum = 0;
    ткст0 stringvalue;
    т_мера stringlen;
    т_мера paramCount;

     static проц _иниц()
    {
        stringtable._иниц();
    }

    this(ткст0 sv, т_мера len, т_мера pcount)
    {
        stringvalue = sv;
        stringlen = len;
        paramCount = pcount;
    }

    extern (D) static ObjcSelector* lookup(ткст0 s)
    {
        т_мера len = 0;
        т_мера pcount = 0;
        ткст0 i = s;
        while (*i != 0)
        {
            ++len;
            if (*i == ':')
                ++pcount;
            ++i;
        }
        return lookup(s, len, pcount);
    }

    extern (D) static ObjcSelector* lookup(ткст0 s, т_мера len, т_мера pcount)
    {
        auto sv = stringtable.update(s, len);
        ObjcSelector* sel = sv.значение;
        if (!sel)
        {
            sel = new ObjcSelector(sv.toDchars(), len, pcount);
            sv.значение = sel;
        }
        return sel;
    }

     static ObjcSelector* создай(FuncDeclaration fdecl)
    {
        БуфВыв буф;
        т_мера pcount = 0;
        TypeFunction ftype = cast(TypeFunction)fdecl.тип;
        const ид = fdecl.идент.вТкст();
        // Special case: property setter
        if (ftype.isproperty && ftype.parameterList.parameters && ftype.parameterList.parameters.dim == 1)
        {
            // rewrite "идентификатор" as "setIdentifier"
            сим firstChar = ид[0];
            if (firstChar >= 'a' && firstChar <= 'z')
                firstChar = cast(сим)(firstChar - 'a' + 'A');
            буф.пишиСтр("set");
            буф.пишиБайт(firstChar);
            буф.пиши(ид[1 .. ид.length - 1]);
            буф.пишиБайт(':');
            goto Lcomplete;
        }
        // пиши идентификатор in selector
        буф.пиши(ид[]);
        // add mangled тип and colon for each параметр
        if (ftype.parameterList.parameters && ftype.parameterList.parameters.dim)
        {
            буф.пишиБайт('_');
            Параметры* arguments = ftype.parameterList.parameters;
            т_мера dim = Параметр2.dim(arguments);
            for (т_мера i = 0; i < dim; i++)
            {
                Параметр2 arg = Параметр2.getNth(arguments, i);
                mangleToBuffer(arg.тип, &буф);
                буф.пишиБайт(':');
            }
            pcount = dim;
        }
    Lcomplete:
        буф.пишиБайт('\0');
        // the slice is not expected to include a terminating 0
        return lookup(cast(сим*)буф[].ptr, буф.length - 1, pcount);
    }

    extern (D) ткст вТкст() 
    {
        return stringvalue[0 .. stringlen];
    }
}

private  Objc _objc;

Objc objc()
{
    return _objc;
}


/**
 * Contains all данные for a class declaration that is needed for the Objective-C
 * integration.
 */
 struct ObjcClassDeclaration
{
    /// `да` if this class is a metaclass.
    бул isMeta = нет;

    /// `да` if this class is externally defined.
    бул isExtern = нет;

    /// Name of this class.
    Идентификатор2 идентификатор;

    /// The class declaration this belongs to.
    ClassDeclaration classDeclaration;

    /// The metaclass of this class.
    ClassDeclaration metaclass;

    /// List of non-inherited methods.
    Дсимволы* methodList;

    this(ClassDeclaration classDeclaration)
    {
        this.classDeclaration = classDeclaration;
        methodList = new Дсимволы;
    }

    бул isRootClass()
    {
        return classDeclaration.classKind == ClassKind.objc &&
            !metaclass &&
            !classDeclaration.baseClass;
    }
}

// Should be an interface
/*extern(C++)*/ abstract class Objc
{
    static проц _иниц()
    {
        if (target.objc.supported)
            _objc = new Supported;
        else
            _objc = new Unsupported;
    }

    /**
     * Deinitializes the глоб2 state of the compiler.
     *
     * This can be используется to restore the state set by `_иниц` to its original
     * state.
     */
    static проц deinitialize()
    {
        _objc = _objc.init;
    }

    abstract проц setObjc(ClassDeclaration cd);
    abstract проц setObjc(InterfaceDeclaration);

    /**
     * Deprecate the given Objective-C interface.
     *
     * Representing an Objective-C class as a D interface has been deprecated.
     * Classes have now been properly implemented and the `class` keyword should
     * be используется instead.
     *
     * In the future, `extern(Objective-C)` interfaces will be используется to represent
     * Objective-C protocols.
     *
     * Параметры:
     *  interfaceDeclaration = the interface declaration to deprecate
     */
    abstract проц deprecate(InterfaceDeclaration interfaceDeclaration);

    abstract проц setSelector(FuncDeclaration, Scope* sc);
    abstract проц validateSelector(FuncDeclaration fd);
    abstract проц checkLinkage(FuncDeclaration fd);

    /**
     * Возвращает `да` if the given function declaration is virtual.
     *
     * Function declarations with Objective-C компонаж and which are static or
     * final are considered virtual.
     *
     * Параметры:
     *  fd = the function declaration to check if it's virtual
     *
     * Возвращает: `да` if the given function declaration is virtual
     */
    abstract бул isVirtual(FuncDeclaration fd);

    /**
     * Gets the родитель of the given function declaration.
     *
     * Handles Objective-C static member functions, which are virtual functions
     * of the metaclass, by returning the родитель class declaration to the
     * metaclass.
     *
     * Параметры:
     *  fd = the function declaration to get the родитель of
     *  cd = the current родитель, i.e. the class declaration the given function
     *      declaration belongs to
     *
     * Возвращает: the родитель
     */
    abstract ClassDeclaration getParent(FuncDeclaration fd,
        ClassDeclaration cd);

    /**
     * Adds the given function to the list of Objective-C methods.
     *
     * This list will later be используется output the necessary Objective-C module info.
     *
     * Параметры:
     *  fd = the function declaration to be added to the list
     *  cd = the class declaration the function belongs to
     */
    abstract проц addToClassMethodList(FuncDeclaration fd,
        ClassDeclaration cd);

    /**
     * Возвращает the `this` pointer of the given function declaration.
     *
     * This is only используется for class/static methods. For instance methods, no
     * Objective-C specialization is necessary.
     *
     * Параметры:
     *  funcDeclaration = the function declaration to get the `this` pointer for
     *
     * Возвращает: the `this` pointer of the given function declaration, or `null`
     *  if the given function declaration is not an Objective-C method.
     */
    abstract AggregateDeclaration isThis( FuncDeclaration funcDeclaration);

    /**
     * Creates the selector параметр for the given function declaration.
     *
     * Objective-C methods has an extra hidden параметр that comes after the
     * `this` параметр. The selector параметр is of the Objective-C тип `SEL`
     * and содержит the selector which this method was called with.
     *
     * Параметры:
     *  fd = the function declaration to создай the параметр for
     *  sc = the scope from the semantic phase
     *
     * Возвращает: the newly created selector параметр or `null` for
     *  non-Objective-C functions
     */
    abstract VarDeclaration createSelectorParameter(FuncDeclaration fd, Scope* sc);

    /**
     * Creates and sets the metaclass on the given class/interface declaration.
     *
     * Will only be performed on regular Objective-C classes, not on metaclasses.
     *
     * Параметры:
     *  classDeclaration = the class/interface declaration to set the metaclass on
     */
    abstract проц setMetaclass(InterfaceDeclaration interfaceDeclaration, Scope* sc);

    /// ditto
    abstract проц setMetaclass(ClassDeclaration classDeclaration, Scope* sc);

    /**
     * Возвращает Objective-C runtime metaclass of the given class declaration.
     *
     * `ClassDeclaration.ObjcClassDeclaration.metaclass` содержит the metaclass
     * from the semantic point of view. This function returns the metaclass from
     * the Objective-C runtime's point of view. Here, the metaclass of a
     * metaclass is the root metaclass, not `null`. The root metaclass's
     * metaclass is itself.
     *
     * Параметры:
     *  classDeclaration = The class declaration to return the metaclass of
     *
     * Возвращает: the Objective-C runtime metaclass of the given class declaration
     */
    abstract ClassDeclaration getRuntimeMetaclass(ClassDeclaration classDeclaration);

    ///
    abstract проц addSymbols(AttribDeclaration attribDeclaration,
        ClassDeclarations* classes, ClassDeclarations* categories);

    ///
    abstract проц addSymbols(ClassDeclaration classDeclaration,
        ClassDeclarations* classes, ClassDeclarations* categories);

    /**
     * Issues a compile time error if the `.offsetof`/`.tupleof` property is
     * используется on a field of an Objective-C class.
     *
     * To solve the fragile base class problem in Objective-C, fields have a
     * dynamic смещение instead of a static смещение. The compiler outputs a
     * statically known смещение which later the dynamic loader can update, if
     * necessary, when the application is loaded. Due to this behavior it
     * doesn't make sense to be able to get the смещение of a field at compile
     * time, because this смещение might not actually be the same at runtime.
     *
     * To get the смещение of a field that is correct at runtime, functionality
     * from the Objective-C runtime can be используется instead.
     *
     * Параметры:
     *  Выражение = the `.offsetof`/`.tupleof` Выражение
     *  aggregateDeclaration = the aggregate declaration the field of the
     *      `.offsetof`/`.tupleof` Выражение belongs to
     *  тип = the тип of the receiver of the `.tupleof` Выражение
     *
     * See_Also:
     *  $(LINK2 https://en.wikipedia.org/wiki/Fragile_binary_interface_problem,
     *      Fragile Binary Interface Problem)
     *
     * See_Also:
     *  $(LINK2 https://developer.apple.com/documentation/objectivec/objective_c_runtime,
     *      Objective-C Runtime)
     */
    abstract проц checkOffsetof(Выражение Выражение, AggregateDeclaration aggregateDeclaration);

    /// ditto
    abstract проц checkTupleof(Выражение Выражение, TypeClass тип);
}

/*extern(C++)*/ private final class Unsupported : Objc
{
    extern(D) final this()
    {
        ObjcGlue.initialize();
    }

    override проц setObjc(ClassDeclaration cd)
    {
        cd.выведиОшибку("Objective-C classes not supported");
    }

    override проц setObjc(InterfaceDeclaration ид)
    {
        ид.выведиОшибку("Objective-C interfaces not supported");
    }

    override проц deprecate(InterfaceDeclaration)
    {
        // noop
    }

    override проц setSelector(FuncDeclaration, Scope*)
    {
        // noop
    }

    override проц validateSelector(FuncDeclaration)
    {
        // noop
    }

    override проц checkLinkage(FuncDeclaration)
    {
        // noop
    }

    override бул isVirtual( FuncDeclaration)
    {
        assert(0, "Should never be called when Objective-C is not supported");
    }

    override ClassDeclaration getParent(FuncDeclaration, ClassDeclaration cd)
    {
        return cd;
    }

    override проц addToClassMethodList(FuncDeclaration, ClassDeclaration)
    {
        // noop
    }

    override AggregateDeclaration isThis( FuncDeclaration funcDeclaration)
    {
        return null;
    }

    override VarDeclaration createSelectorParameter(FuncDeclaration, Scope*)
    {
        return null;
    }

    override проц setMetaclass(InterfaceDeclaration, Scope*)
    {
        // noop
    }

    override проц setMetaclass(ClassDeclaration, Scope*)
    {
        // noop
    }

    override ClassDeclaration getRuntimeMetaclass(ClassDeclaration classDeclaration)
    {
        assert(0, "Should never be called when Objective-C is not supported");
    }

    override проц addSymbols(AttribDeclaration attribDeclaration,
        ClassDeclarations* classes, ClassDeclarations* categories)
    {
        // noop
    }

    override проц addSymbols(ClassDeclaration classDeclaration,
        ClassDeclarations* classes, ClassDeclarations* categories)
    {
        // noop
    }

    override проц checkOffsetof(Выражение Выражение, AggregateDeclaration aggregateDeclaration)
    {
        // noop
    }

    override проц checkTupleof(Выражение Выражение, TypeClass тип)
    {
        // noop
    }
}

/*extern(C++)*/ private final class Supported : Objc
{
    extern(D) final this()
    {
        VersionCondition.addPredefinedGlobalIdent("D_ObjectiveC");

        ObjcGlue.initialize();
        ObjcSelector._иниц();
    }

    override проц setObjc(ClassDeclaration cd)
    {
        cd.classKind = ClassKind.objc;
        cd.objc.isExtern = (cd.класс_хранения & STC.extern_) > 0;
    }

    override проц setObjc(InterfaceDeclaration ид)
    {
        ид.classKind = ClassKind.objc;
        ид.objc.isExtern = да;
    }

    override проц deprecate(InterfaceDeclaration ид)
    in
    {
        assert(ид.classKind == ClassKind.objc);
    }
    body
    {
        // don't report deprecations for the metaclass to avoid duplicated
        // messages.
        if (ид.objc.isMeta)
            return;

        ид.deprecation("Objective-C interfaces have been deprecated");
        deprecationSupplemental(ид.место, "Representing an Objective-C class " ~
            "as a D interface has been deprecated. Please use "~
            "`extern (Objective-C) extern class` instead");
    }

    override проц setSelector(FuncDeclaration fd, Scope* sc)
    {
        //import drc.lexer.Tokens;

        if (!fd.userAttribDecl)
            return;
        Выражения* udas = fd.userAttribDecl.getAttributes();
        arrayВыражениеSemantic(udas, sc, да);
        for (т_мера i = 0; i < udas.dim; i++)
        {
            Выражение uda = (*udas)[i];
            assert(uda);
            if (uda.op != ТОК2.кортеж)
                continue;
            Выражения* exps = (cast(TupleExp)uda).exps;
            for (т_мера j = 0; j < exps.dim; j++)
            {
                Выражение e = (*exps)[j];
                assert(e);
                if (e.op != ТОК2.structLiteral)
                    continue;
                StructLiteralExp literal = cast(StructLiteralExp)e;
                assert(literal.sd);
                if (!isUdaSelector(literal.sd))
                    continue;
                if (fd.selector)
                {
                    fd.выведиОшибку("can only have one Objective-C selector per method");
                    return;
                }
                assert(literal.elements.dim == 1);
                StringExp se = (*literal.elements)[0].вТкстExp();
                assert(se);
                fd.selector = ObjcSelector.lookup(cast(сим*)se.toUTF8(sc).peekString().ptr);
            }
        }
    }

    override проц validateSelector(FuncDeclaration fd)
    {
        if (!fd.selector)
            return;
        TypeFunction tf = cast(TypeFunction)fd.тип;
        if (fd.selector.paramCount != tf.parameterList.parameters.dim)
            fd.выведиОшибку("number of colons in Objective-C selector must match number of parameters");
        if (fd.родитель && fd.родитель.isTemplateInstance())
            fd.выведиОшибку("template cannot have an Objective-C selector attached");
    }

    override проц checkLinkage(FuncDeclaration fd)
    {
        if (fd.компонаж != LINK.objc && fd.selector)
            fd.выведиОшибку("must have Objective-C компонаж to attach a selector");
    }

    override бул isVirtual(FuncDeclaration fd)
    in
    {
        assert(fd.selector);
        assert(fd.isMember);
    }
    body
    {
        // * final member functions are kept virtual with Objective-C компонаж
        //   because the Objective-C runtime always use dynamic dispatch.
        // * static member functions are kept virtual too, as they represent
        //   methods of the metaclass.
        with (fd.защита)
            return !(вид == Prot.Kind.private_ || вид == Prot.Kind.package_);
    }

    override ClassDeclaration getParent(FuncDeclaration fd, ClassDeclaration cd)
    out(metaclass)
    {
        assert(metaclass);
    }
    body
    {
        if (cd.classKind == ClassKind.objc && fd.isStatic && !cd.objc.isMeta)
            return cd.objc.metaclass;
        else
            return cd;
    }

    override проц addToClassMethodList(FuncDeclaration fd, ClassDeclaration cd)
    in
    {
        assert(fd.родитель.isClassDeclaration);
    }
    body
    {
        if (cd.classKind != ClassKind.objc)
            return;

        if (!fd.selector)
            return;

        assert(fd.isStatic ? cd.objc.isMeta : !cd.objc.isMeta);

        cd.objc.methodList.сунь(fd);
    }

    override AggregateDeclaration isThis( FuncDeclaration funcDeclaration)
    {
        with(funcDeclaration)
        {
            if (!selector)
                return null;

            // Use Objective-C class объект as 'this'
            auto cd = isMember2().isClassDeclaration();

            if (cd.classKind == ClassKind.objc)
            {
                if (!cd.objc.isMeta)
                    return cd.objc.metaclass;
            }

            return null;
        }
    }

    override VarDeclaration createSelectorParameter(FuncDeclaration fd, Scope* sc)
    in
    {
        assert(fd.selectorParameter is null);
    }
    body
    {
        if (!fd.selector)
            return null;

        auto var = new VarDeclaration(fd.место, Тип.tvoidptr, Идентификатор2.анонимный, null);
        var.класс_хранения |= STC.параметр;
        var.dsymbolSemantic(sc);
        if (!sc.вставь(var))
            assert(нет);
        var.родитель = fd;

        return var;
    }

    override проц setMetaclass(InterfaceDeclaration interfaceDeclaration, Scope* sc)
    {
        static InterfaceDeclaration newMetaclass(Место место, КлассыОсновы* metaBases)
        {
            return new InterfaceDeclaration(место, null, metaBases);
        }

        .setMetaclass!(newMetaclass)(interfaceDeclaration, sc);
    }

    override проц setMetaclass(ClassDeclaration classDeclaration, Scope* sc)
    {
        ClassDeclaration newMetaclass(Место место, КлассыОсновы* metaBases)
        {
            return new ClassDeclaration(место, null, metaBases, new Дсимволы(), 0);
        }

        .setMetaclass!(newMetaclass)(classDeclaration, sc);
    }

    override ClassDeclaration getRuntimeMetaclass(ClassDeclaration classDeclaration)
    {
        if (!classDeclaration.objc.metaclass && classDeclaration.objc.isMeta)
        {
            if (classDeclaration.baseClass)
                return getRuntimeMetaclass(classDeclaration.baseClass);
            else
                return classDeclaration;
        }
        else
            return classDeclaration.objc.metaclass;
    }

    override проц addSymbols(AttribDeclaration attribDeclaration,
        ClassDeclarations* classes, ClassDeclarations* categories)
    {
        auto symbols = attribDeclaration.include(null);

        if (!symbols)
            return;

        foreach (symbol; *symbols)
            symbol.addObjcSymbols(classes, categories);
    }

    override проц addSymbols(ClassDeclaration classDeclaration,
        ClassDeclarations* classes, ClassDeclarations* categories)
    {
        with (classDeclaration)
            if (classKind == ClassKind.objc && !objc.isExtern && !objc.isMeta)
                classes.сунь(classDeclaration);
    }

    override проц checkOffsetof(Выражение Выражение, AggregateDeclaration aggregateDeclaration)
    {
        if (aggregateDeclaration.classKind != ClassKind.objc)
            return;

        const errorMessage = "no property `offsetof` for member `%s` of тип " ~
            "`%s`";

        const supplementalMessage = "`offsetof` is not доступно for члены " ~
            "of Objective-C classes. Please use the Objective-C runtime instead";

        Выражение.выведиОшибку(errorMessage, Выражение.вТкст0(),
            Выражение.тип.вТкст0());
        Выражение.errorSupplemental(supplementalMessage);
    }

    override проц checkTupleof(Выражение Выражение, TypeClass тип)
    {
        if (тип.sym.classKind != ClassKind.objc)
            return;

        Выражение.выведиОшибку("no property `tupleof` for тип `%s`", тип.вТкст0());
        Выражение.errorSupplemental("`tupleof` is not доступно for члены " ~
            "of Objective-C classes. Please use the Objective-C runtime instead");
    }

    extern(D) private бул isUdaSelector(StructDeclaration sd)
    {
        if (sd.идент != Id.udaSelector || !sd.родитель)
            return нет;
        Module _module = sd.родитель.isModule();
        return _module && _module.isCoreModule(Id.attribute);
    }
}

/*
 * Creates and sets the metaclass on the given class/interface declaration.
 *
 * Will only be performed on regular Objective-C classes, not on metaclasses.
 *
 * Параметры:
 *  newMetaclass = a function that returns the metaclass to set. This should
 *      return the same тип as `T`.
 *  classDeclaration = the class/interface declaration to set the metaclass on
 */
private проц setMetaclass(alias newMetaclass, T)(T classDeclaration, Scope* sc)
//if (is(T == ClassDeclaration) || is(T == InterfaceDeclaration))
{
    static if (is(T == ClassDeclaration))
        const errorType = "class";
    else
        const errorType = "interface";

    with (classDeclaration)
    {
        if (classKind != ClassKind.objc || objc.isMeta || objc.metaclass)
            return;

        if (!objc.идентификатор)
            objc.идентификатор = classDeclaration.идент;

        auto metaBases = new КлассыОсновы();

        foreach (base ; baseclasses.opSlice)
        {
            auto baseCd = base.sym;
            assert(baseCd);

            if (baseCd.classKind == ClassKind.objc)
            {
                assert(baseCd.objc.metaclass);
                assert(baseCd.objc.metaclass.objc.isMeta);
                assert(baseCd.objc.metaclass.тип.ty == Tclass);

                auto metaBase = new КлассОснова2(baseCd.objc.metaclass.тип);
                metaBase.sym = baseCd.objc.metaclass;
                metaBases.сунь(metaBase);
            }
            else
            {
                выведиОшибку("base " ~ errorType ~ " for an Objective-C " ~
                      errorType ~ " must be `extern (Objective-C)`");
            }
        }

        objc.metaclass = newMetaclass(место, metaBases);
        objc.metaclass.класс_хранения |= STC.static_;
        objc.metaclass.classKind = ClassKind.objc;
        objc.metaclass.objc.isMeta = да;
        objc.metaclass.objc.isExtern = objc.isExtern;
        objc.metaclass.objc.идентификатор = objc.идентификатор;

        if (baseClass)
            objc.metaclass.baseClass = baseClass.objc.metaclass;

        члены.сунь(objc.metaclass);
        objc.metaclass.addMember(sc, classDeclaration);

        objc.metaclass.dsymbolSemantic(sc);
    }
}
