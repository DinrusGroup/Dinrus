/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/dstruct.d, _dstruct.d)
 * Documentation:  https://dlang.org/phobos/dmd_dstruct.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/dstruct.d
 */

module dmd.dstruct;

import dmd.aggregate;
import dmd.arraytypes;
import dmd.declaration;
import dmd.dmodule;
import dmd.dscope;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.dtemplate;
import dmd.errors;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.mtype;
import dmd.opover;
import dmd.semantic3;
import dmd.target;
import drc.lexer.Tokens;
import dmd.typesem;
import dmd.typinf;
import drc.ast.Visitor;
import util.ctfloat : CTFloat;

/***************************************
 * Search sd for a member function of the form:
 *   `extern (D) ткст вТкст();`
 * Параметры:
 *   sd = struct declaration to search
 * Возвращает:
 *   FuncDeclaration of `вТкст()` if found, `null` if not
 */
 FuncDeclaration search_вТкст(StructDeclaration sd)
{
    ДСимвол s = search_function(sd, Id.tostring);
    FuncDeclaration fd = s ? s.isFuncDeclaration() : null;
    if (fd)
    {
         TypeFunction tftostring;
        if (!tftostring)
        {
            tftostring = new TypeFunction(СписокПараметров(), Тип.tstring, LINK.d);
            tftostring = tftostring.merge().toTypeFunction();
        }
        fd = fd.overloadExactMatch(tftostring);
    }
    return fd;
}

/***************************************
 * Request additional semantic analysis for TypeInfo generation.
 * Параметры:
 *      sc = context
 *      t = тип that TypeInfo is being generated for
 */
 проц semanticTypeInfo(Scope* sc, Тип t)
{
    if (sc)
    {
        if (!sc.func)
            return;
        if (sc.intypeof)
            return;
        if (sc.flags & (SCOPE.ctfe | SCOPE.compile))
            return;
    }

    if (!t)
        return;

    проц visitVector(TypeVector t)
    {
        semanticTypeInfo(sc, t.basetype);
    }

    проц visitAArray(TypeAArray t)
    {
        semanticTypeInfo(sc, t.index);
        semanticTypeInfo(sc, t.следщ);
    }

    проц visitStruct(TypeStruct t)
    {
        //printf("semanticTypeInfo.посети(TypeStruct = %s)\n", t.вТкст0());
        StructDeclaration sd = t.sym;

        /* Step 1: создай TypeInfoDeclaration
         */
        if (!sc) // inline may request TypeInfo.
        {
            Scope scx;
            scx._module = sd.getModule();
            getTypeInfoType(sd.место, t, &scx);
            sd.requestTypeInfo = да;
        }
        else if (!sc.minst)
        {
            // don't yet have to generate TypeInfo instance if
            // the typeid(T) Выражение exists in speculative scope.
        }
        else
        {
            getTypeInfoType(sd.место, t, sc);
            sd.requestTypeInfo = да;

            // https://issues.dlang.org/show_bug.cgi?ид=15149
            // if the typeid operand тип comes from a
            // результат of auto function, it may be yet speculative.
            // unSpeculative(sc, sd);
        }

        /* Step 2: If the TypeInfo generation requires sd.semantic3, run it later.
         * This should be done even if typeid(T) exists in speculative scope.
         * Because it may appear later in non-speculative scope.
         */
        if (!sd.члены)
            return; // opaque struct
        if (!sd.xeq && !sd.xcmp && !sd.postblit && !sd.dtor && !sd.xhash && !search_вТкст(sd))
            return; // none of TypeInfo-specific члены

        // If the struct is in a non-root module, run semantic3 to get
        // correct symbols for the member function.
        if (sd.semanticRun >= PASS.semantic3)
        {
            // semantic3 is already done
        }
        else if (TemplateInstance ti = sd.isInstantiated())
        {
            if (ti.minst && !ti.minst.isRoot())
                Module.addDeferredSemantic3(sd);
        }
        else
        {
            if (sd.inNonRoot())
            {
                //printf("deferred sem3 for TypeInfo - sd = %s, inNonRoot = %d\n", sd.вТкст0(), sd.inNonRoot());
                Module.addDeferredSemantic3(sd);
            }
        }
    }

    проц visitTuple(КортежТипов t)
    {
        if (t.arguments)
        {
            foreach (arg; *t.arguments)
            {
                semanticTypeInfo(sc, arg.тип);
            }
        }
    }

    /* Note structural similarity of this Тип walker to that in isSpeculativeType()
     */

    Тип tb = t.toBasetype();
    switch (tb.ty)
    {
        case Tvector:   visitVector(tb.isTypeVector()); break;
        case Taarray:   visitAArray(tb.isTypeAArray()); break;
        case Tstruct:   visitStruct(tb.isTypeStruct()); break;
        case Ttuple:    visitTuple (tb.isTypeTuple());  break;

        case Tclass:
        case Tenum:     break;

        default:        semanticTypeInfo(sc, tb.nextOf()); break;
    }
}

enum StructFlags : цел
{
    none        = 0x0,
    hasPointers = 0x1, // NB: should use noPointers as in ClassFlags
}

enum StructPOD : цел
{
    no,    // struct is not POD
    yes,   // struct is POD
    fwd,   // POD not yet computed
}

/***********************************************************
 * All `struct` declarations are an instance of this.
 */
 class StructDeclaration : AggregateDeclaration
{
    бул zeroInit;              // !=0 if initialize with 0 fill
    бул hasIdentityAssign;     // да if has identity opAssign
    бул hasIdentityEquals;     // да if has identity opEquals
    бул hasNoFields;           // has no fields
    FuncDeclarations postblits; // МассивДРК of postblit functions
    FuncDeclaration postblit;   // aggregate postblit

    бул hasCopyCtor;       // копируй constructor

    FuncDeclaration xeq;        // TypeInfo_Struct.xopEquals
    FuncDeclaration xcmp;       // TypeInfo_Struct.xopCmp
    FuncDeclaration xhash;      // TypeInfo_Struct.xtoHash
      FuncDeclaration xerreq;   // объект.xopEquals
      FuncDeclaration xerrcmp;  // объект.xopCmp

    structalign_t alignment;    // alignment applied outside of the struct
    StructPOD ispod;            // if struct is POD

    // For 64 bit Efl function call/return ABI
    Тип arg1type;
    Тип arg2type;

    // Even if struct is defined as non-root symbol, some built-in operations
    // (e.g. TypeidExp, NewExp, ArrayLiteralExp, etc) request its TypeInfo.
    // For those, today TypeInfo_Struct is generated in COMDAT.
    бул requestTypeInfo;

    this(ref Место место, Идентификатор2 ид, бул inObject)
    {
        super(место, ид);
        zeroInit = нет; // assume нет until we do semantic processing
        ispod = StructPOD.fwd;
        // For forward references
        тип = new TypeStruct(this);

        if (inObject)
        {
            if (ид == Id.ModuleInfo && !Module.moduleinfo)
                Module.moduleinfo = this;
        }
    }

    static StructDeclaration создай(Место место, Идентификатор2 ид, бул inObject)
    {
        return new StructDeclaration(место, ид, inObject);
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        StructDeclaration sd =
            s ? cast(StructDeclaration)s
              : new StructDeclaration(место, идент, нет);
        return ScopeDsymbol.syntaxCopy(sd);
    }

    final проц semanticTypeInfoMembers()
    {
        if (xeq &&
            xeq._scope &&
            xeq.semanticRun < PASS.semantic3done)
        {
            бцел errors = глоб2.startGagging();
            xeq.semantic3(xeq._scope);
            if (глоб2.endGagging(errors))
                xeq = xerreq;
        }

        if (xcmp &&
            xcmp._scope &&
            xcmp.semanticRun < PASS.semantic3done)
        {
            бцел errors = глоб2.startGagging();
            xcmp.semantic3(xcmp._scope);
            if (глоб2.endGagging(errors))
                xcmp = xerrcmp;
        }

        FuncDeclaration ftostr = search_вТкст(this);
        if (ftostr &&
            ftostr._scope &&
            ftostr.semanticRun < PASS.semantic3done)
        {
            ftostr.semantic3(ftostr._scope);
        }

        if (xhash &&
            xhash._scope &&
            xhash.semanticRun < PASS.semantic3done)
        {
            xhash.semantic3(xhash._scope);
        }

        if (postblit &&
            postblit._scope &&
            postblit.semanticRun < PASS.semantic3done)
        {
            postblit.semantic3(postblit._scope);
        }

        if (dtor &&
            dtor._scope &&
            dtor.semanticRun < PASS.semantic3done)
        {
            dtor.semantic3(dtor._scope);
        }
    }

    override final ДСимвол search(ref Место место, Идентификатор2 идент, цел flags = SearchLocalsOnly)
    {
        //printf("%s.StructDeclaration::search('%s', flags = x%x)\n", вТкст0(), идент.вТкст0(), flags);
        if (_scope && !symtab)
            dsymbolSemantic(this, _scope);

        if (!члены || !symtab) // opaque or semantic() is not yet called
        {
            // .stringof is always defined (but may be hidden by some other symbol)
            if(идент != Id.stringof)
                выведиОшибку("is forward referenced when looking for `%s`", идент.вТкст0());
            return null;
        }

        return ScopeDsymbol.search(место, идент, flags);
    }

    override ткст0 вид()
    {
        return "struct";
    }

    override final проц finalizeSize()
    {
        //printf("StructDeclaration::finalizeSize() %s, sizeok = %d\n", вТкст0(), sizeok);
        assert(sizeok != Sizeok.done);

        if (sizeok == Sizeok.inProcess)
        {
            return;
        }
        sizeok = Sizeok.inProcess;

        //printf("+StructDeclaration::finalizeSize() %s, fields.dim = %d, sizeok = %d\n", вТкст0(), fields.dim, sizeok);

        fields.устДим(0);   // workaround

        // Set the offsets of the fields and determine the size of the struct
        бцел смещение = 0;
        бул isunion = isUnionDeclaration() !is null;
        for (т_мера i = 0; i < члены.dim; i++)
        {
            ДСимвол s = (*члены)[i];
            s.setFieldOffset(this, &смещение, isunion);
        }
        if (тип.ty == Terror)
        {
            errors = да;
            return;
        }

        // 0 sized struct's are set to 1 byte
        if (structsize == 0)
        {
            hasNoFields = да;
            structsize = 1;
            alignsize = 1;
        }

        // Round struct size up to следщ alignsize boundary.
        // This will ensure that arrays of structs will get their internals
        // aligned properly.
        if (alignment == STRUCTALIGN_DEFAULT)
            structsize = (structsize + alignsize - 1) & ~(alignsize - 1);
        else
            structsize = (structsize + alignment - 1) & ~(alignment - 1);

        sizeok = Sizeok.done;

        //printf("-StructDeclaration::finalizeSize() %s, fields.dim = %d, structsize = %d\n", вТкст0(), fields.dim, structsize);

        if (errors)
            return;

        // Calculate fields[i].overlapped
        if (checkOverlappedFields())
        {
            errors = да;
            return;
        }

        // Determine if struct is all zeros or not
        zeroInit = да;
        foreach (vd; fields)
        {
            if (vd._иниц)
            {
                if (vd._иниц.isVoidInitializer())
                    /* Treat as 0 for the purposes of putting the инициализатор
                     * in the BSS segment, or doing a mass set to 0
                     */
                    continue;

                // Zero size fields are нуль initialized
                if (vd.тип.size(vd.место) == 0)
                    continue;

                // Examine init to see if it is all 0s.
                auto exp = vd.getConstInitializer();
                if (!exp || !_isZeroInit(exp))
                {
                    zeroInit = нет;
                    break;
                }
            }
            else if (!vd.тип.isZeroInit(место))
            {
                zeroInit = нет;
                break;
            }
        }

        auto tt = target.toArgTypes(тип);
        т_мера dim = tt ? tt.arguments.dim : 0;
        if (dim >= 1)
        {
            assert(dim <= 2);
            arg1type = (*tt.arguments)[0].тип;
            if (dim == 2)
                arg2type = (*tt.arguments)[1].тип;
        }
    }

    /***************************************
     * Fit elements[] to the corresponding types of the struct's fields.
     *
     * Параметры:
     *      место = location to use for error messages
     *      sc = context
     *      elements = explicit arguments используется to construct объект
     *      stype = the constructed объект тип.
     * Возвращает:
     *      нет if any errors occur,
     *      otherwise да and elements[] are rewritten for the output.
     */
    final бул fit(ref Место место, Scope* sc, Выражения* elements, Тип stype)
    {
        if (!elements)
            return да;

        const nfields = nonHiddenFields();
        т_мера смещение = 0;
        for (т_мера i = 0; i < elements.dim; i++)
        {
            Выражение e = (*elements)[i];
            if (!e)
                continue;

            e = resolveProperties(sc, e);
            if (i >= nfields)
            {
                if (i <= fields.dim && e.op == ТОК2.null_)
                {
                    // CTFE sometimes creates null as hidden pointer; we'll allow this.
                    continue;
                }
                .выведиОшибку(место, "more initializers than fields (%d) of `%s`", nfields, вТкст0());
                return нет;
            }
            VarDeclaration v = fields[i];
            if (v.смещение < смещение)
            {
                .выведиОшибку(место, "overlapping initialization for `%s`", v.вТкст0());
                if (!isUnionDeclaration())
                {
                    const errorMsg = "`struct` initializers that contain анонимный unions" ~
                                        " must initialize only the first member of a `union`. All subsequent" ~
                                        " non-overlapping fields are default initialized";
                    .errorSupplemental(место, errorMsg);
                }
                return нет;
            }
            смещение = cast(бцел)(v.смещение + v.тип.size());

            Тип t = v.тип;
            if (stype)
                t = t.addMod(stype.mod);
            Тип origType = t;
            Тип tb = t.toBasetype();

            const hasPointers = tb.hasPointers();
            if (hasPointers)
            {
                if ((stype.alignment() < target.ptrsize ||
                     (v.смещение & (target.ptrsize - 1))) &&
                    (sc.func && sc.func.setUnsafe()))
                {
                    .выведиОшибку(место, "field `%s.%s` cannot assign to misaligned pointers in `` code",
                        вТкст0(), v.вТкст0());
                    return нет;
                }
            }

            /* Look for case of initializing a static массив with a too-short
             * ткст literal, such as:
             *  сим[5] foo = "abc";
             * Allow this by doing an explicit cast, which will lengthen the ткст
             * literal.
             */
            if (e.op == ТОК2.string_ && tb.ty == Tsarray)
            {
                StringExp se = cast(StringExp)e;
                Тип typeb = se.тип.toBasetype();
                TY tynto = tb.nextOf().ty;
                if (!se.committed &&
                    (typeb.ty == Tarray || typeb.ty == Tsarray) &&
                    (tynto == Tchar || tynto == Twchar || tynto == Tdchar) &&
                    se.numberOfCodeUnits(tynto) < (cast(TypeSArray)tb).dim.toInteger())
                {
                    e = se.castTo(sc, t);
                    goto L1;
                }
            }

            while (!e.implicitConvTo(t) && tb.ty == Tsarray)
            {
                /* Static массив initialization, as in:
                 *  T[3][5] = e;
                 */
                t = tb.nextOf();
                tb = t.toBasetype();
            }
            if (!e.implicitConvTo(t))
                t = origType; // restore тип for better diagnostic

            e = e.implicitCastTo(sc, t);
        L1:
            if (e.op == ТОК2.error)
                return нет;

            (*elements)[i] = doCopyOrMove(sc, e);
        }
        return да;
    }

    /***************************************
     * Determine if struct is POD (Plain Old Data).
     *
     * POD is defined as:
     *      $(OL
     *      $(LI not nested)
     *      $(LI no postblits, destructors, or assignment operators)
     *      $(LI no `ref` fields or fields that are themselves non-POD)
     *      )
     * The idea being these are compatible with C structs.
     *
     * Возвращает:
     *     да if struct is POD
     */
    final бул isPOD()
    {
        // If we've already determined whether this struct is POD.
        if (ispod != StructPOD.fwd)
            return (ispod == StructPOD.yes);

        ispod = StructPOD.yes;

        if (enclosing || postblit || dtor || hasCopyCtor)
            ispod = StructPOD.no;

        // Recursively check all fields are POD.
        for (т_мера i = 0; i < fields.dim; i++)
        {
            VarDeclaration v = fields[i];
            if (v.класс_хранения & STC.ref_)
            {
                ispod = StructPOD.no;
                break;
            }

            Тип tv = v.тип.baseElemOf();
            if (tv.ty == Tstruct)
            {
                TypeStruct ts = cast(TypeStruct)tv;
                StructDeclaration sd = ts.sym;
                if (!sd.isPOD())
                {
                    ispod = StructPOD.no;
                    break;
                }
            }
        }

        return (ispod == StructPOD.yes);
    }

    override final StructDeclaration isStructDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/**********************************
 * Determine if exp is all binary zeros.
 * Параметры:
 *      exp = Выражение to check
 * Возвращает:
 *      да if it's all binary 0
 */
private бул _isZeroInit(Выражение exp)
{
    switch (exp.op)
    {
        case ТОК2.int64:
            return exp.toInteger() == 0;

        case ТОК2.null_:
        case ТОК2.false_:
            return да;

        case ТОК2.structLiteral:
        {
            auto sle = cast(StructLiteralExp) exp;
            foreach (i; new бцел[0 .. sle.sd.fields.dim])
            {
                auto field = sle.sd.fields[i];
                if (field.тип.size(field.место))
                {
                    auto e = (*sle.elements)[i];
                    if (e ? !_isZeroInit(e)
                          : !field.тип.isZeroInit(field.место))
                        return нет;
                }
            }
            return да;
        }

        case ТОК2.arrayLiteral:
        {
            auto ale = cast(ArrayLiteralExp)exp;

            const dim = ale.elements ? ale.elements.dim : 0;

            if (ale.тип.toBasetype().ty == Tarray) // if initializing a dynamic массив
                return dim == 0;

            foreach (i; new бцел[0 .. dim])
            {
                if (!_isZeroInit(ale[i]))
                    return нет;
            }

            /* Note that да is returned for all T[0]
             */
            return да;
        }

        case ТОК2.string_:
        {
            StringExp se = cast(StringExp)exp;

            if (se.тип.toBasetype().ty == Tarray) // if initializing a dynamic массив
                return se.len == 0;

            foreach (i; new бцел[0 .. se.len])
            {
                if (se.getCodeUnit(i))
                    return нет;
            }
            return да;
        }

        case ТОК2.vector:
        {
            auto ve = cast(VectorExp) exp;
            return _isZeroInit(ve.e1);
        }

        case ТОК2.float64:
        case ТОК2.complex80:
        {
            return (exp.toReal()      is CTFloat.нуль) &&
                   (exp.toImaginary() is CTFloat.нуль);
        }

        default:
            return нет;
    }
}

/***********************************************************
 * Unions are a variation on structs.
 */
 final class UnionDeclaration : StructDeclaration
{
    this(ref Место место, Идентификатор2 ид)
    {
        super(место, ид, нет);
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        auto ud = new UnionDeclaration(место, идент);
        return StructDeclaration.syntaxCopy(ud);
    }

    override ткст0 вид()
    {
        return "union";
    }

    override UnionDeclaration isUnionDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}
