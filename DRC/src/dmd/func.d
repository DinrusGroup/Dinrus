/***
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/func.d, _func.d)
 * Documentation:  https://dlang.org/phobos/dmd_func.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/func.d
 */

module dmd.func;

import cidrus;
import dmd.aggregate;
import dmd.arraytypes;
import dmd.blockexit;
import dmd.gluelayer;
import dmd.dclass;
import dmd.declaration;
import dmd.delegatize;
import dmd.dinterpret;
import dmd.dmodule;
import dmd.dscope;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.dtemplate;
import dmd.errors;
import dmd.escape;
import drc.ast.Expression;
import dmd.globals;
import dmd.hdrgen;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.init;
import dmd.mtype;
import dmd.objc;
import util.outbuffer;
import drc.ast.Node;
import util.string;
import dmd.semantic2;
import dmd.semantic3;
import dmd.statement_rewrite_walker;
import dmd.инструкция;
import dmd.statementsem;
import drc.lexer.Tokens;
import drc.ast.Visitor;
import dmd.access : checkSymbolAccess;
import dmd.staticcond;
import dmd.statement_rewrite_walker;

/// Inline Status
enum ILS : цел
{
    uninitialized,       /// not computed yet
    no,                  /// cannot inline
    yes,                 /// can inline
}

enum BUILTIN : цел
{
    unknown = -1,    /// not known if this is a builtin
    no,              /// this is not a builtin
    yes,             /// this is a builtin
}


/* Tweak all return statements and dtor call for nrvo_var, for correct NRVO.
 */
 final class NrvoWalker : StatementRewriteWalker
{
    alias  typeof(super).посети посети ;
public:
    FuncDeclaration fd;
    Scope* sc;

    override проц посети(ReturnStatement s)
    {
        // See if all returns are instead to be replaced with a goto returnLabel;
        if (fd.returnLabel)
        {
            /* Rewrite:
             *  return exp;
             * as:
             *  vрезультат = exp; goto Lрезультат;
             */
            auto gs = new GotoStatement(s.место, Id.returnLabel);
            gs.label = fd.returnLabel;

            Инструкция2 s1 = gs;
            if (s.exp)
                s1 = new CompoundStatement(s.место, new ExpStatement(s.место, s.exp), gs);

            replaceCurrent(s1);
        }
    }

    override проц посети(TryFinallyStatement s)
    {
        DtorExpStatement des;
        if (fd.nrvo_can && s.finalbody && (des = s.finalbody.isDtorExpStatement()) !is null &&
            fd.nrvo_var == des.var)
        {
            if (!(глоб2.парамы.useExceptions && ClassDeclaration.throwable))
            {
                /* Don't need to call destructor at all, since it is nrvo
                 */
                replaceCurrent(s._body);
                s._body.прими(this);
                return;
            }

            /* Normally local variable dtors are called regardless exceptions.
             * But for nrvo_var, its dtor should be called only when exception is thrown.
             *
             * Rewrite:
             *      try { s.body; } finally { nrvo_var.edtor; }
             *      // equivalent with:
             *      //    s.body; scope(exit) nrvo_var.edtor;
             * as:
             *      try { s.body; } catch(Throwable __o) { nrvo_var.edtor; throw __o; }
             *      // equivalent with:
             *      //    s.body; scope(failure) nrvo_var.edtor;
             */
            Инструкция2 sexception = new DtorExpStatement(Место.initial, fd.nrvo_var.edtor, fd.nrvo_var);
            Идентификатор2 ид = Идентификатор2.генерируйИд("__o");

            Инструкция2 handler = new PeelStatement(sexception);
            if (sexception.blockExit(fd, нет) & BE.fallthru)
            {
                auto ts = new ThrowStatement(Место.initial, new IdentifierExp(Место.initial, ид));
                ts.internalThrow = да;
                handler = new CompoundStatement(Место.initial, handler, ts);
            }

            auto catches = new Уловители();
            auto ctch = new Уловитель(Место.initial, getThrowable(), ид, handler);
            ctch.internalCatch = да;
            ctch.catchSemantic(sc); // Run semantic to resolve идентификатор '__o'
            catches.сунь(ctch);

            Инструкция2 s2 = new TryCatchStatement(Место.initial, s._body, catches);
            fd.eh_none = нет;
            replaceCurrent(s2);
            s2.прими(this);
        }
        else
            StatementRewriteWalker.посети(s);
    }
}

enum FUNCFLAG : бцел
{
    purityInprocess  = 1,      /// working on determining purity
    safetyInprocess  = 2,      /// working on determining safety
    nothrowInprocess = 4,      /// working on determining 
    nogcInprocess    = 8,      /// working on determining 
    returnInprocess  = 0x10,   /// working on inferring 'return' for parameters
    inlineScanned    = 0x20,   /// function has been scanned for inline possibilities
    inferScope       = 0x40,   /// infer 'scope' for parameters
    hasCatches       = 0x80,   /// function has try-catch statements
    compileTimeOnly  = 0x100,  /// is a compile time only function; no code will be generated for it
}

/***********************************************************
 * Tuple of результат идентификатор (possibly null) and инструкция.
 * This is используется to store out contracts: out(ид){ ensure }
 */
 struct Гарант
{
    Идентификатор2 ид;
    Инструкция2 ensure;

    Гарант syntaxCopy()
    {
        return Гарант(ид, ensure.syntaxCopy());
    }

    /*****************************************
     * Do syntax копируй of an массив of Гарант's.
     */
    static Гаранты* arraySyntaxCopy(Гаранты* a)
    {
        Гаранты* b = null;
        if (a)
        {
            b = a.копируй();
            foreach (i, e; *a)
            {
                (*b)[i] = e.syntaxCopy();
            }
        }
        return b;
    }

}

/***********************************************************
 */
 class FuncDeclaration : Declaration
{
    /// All hidden parameters bundled.
    struct HiddenParameters
    {
        /**
         * The `this` параметр for methods or nested functions.
         *
         * For methods, it would be the class объект or struct значение the
         * method is called on. For nested functions it would be the enclosing
         * function's stack frame.
         */
        VarDeclaration vthis;

        /**
         * Is 'this' a pointer to a static массив holding two contexts.
         */
        бул isThis2;

        /// The selector параметр for Objective-C methods.
        VarDeclaration selectorParameter;
    }

    Инструкции* frequires;              /// in contracts
    Гаранты* fensures;                  /// out contracts
    Инструкция2 frequire;                 /// lowered in contract
    Инструкция2 fensure;                  /// lowered out contract
    Инструкция2 fbody;                    /// function body

    FuncDeclarations foverrides;        /// functions this function overrides
    FuncDeclaration fdrequire;          /// function that does the in contract
    FuncDeclaration fdensure;           /// function that does the out contract

    Выражения* fdrequireParams;       /// argument list for __require
    Выражения* fdensureParams;        /// argument list for __ensure

    ткст0 mangleString;          /// mangled symbol created from mangleExact()

    VarDeclaration vрезультат;             /// результат variable for out contracts
    LabelDsymbol returnLabel;           /// where the return goes

    // используется to prevent symbols in different
    // scopes from having the same имя
    DsymbolTable localsymtab;
    VarDeclaration vthis;               /// 'this' параметр (member and nested)
    бул isThis2;                       /// has a dual-context 'this' параметр
    VarDeclaration v_arguments;         /// '_arguments' параметр
    ObjcSelector* selector;             /// Objective-C method selector (member function only)
    VarDeclaration selectorParameter;   /// Objective-C implicit selector параметр

    VarDeclaration v_argptr;            /// '_argptr' variable
    VarDeclarations* parameters;        /// МассивДРК of VarDeclaration's for parameters
    DsymbolTable labtab;                /// инструкция label symbol table
    ДСимвол overnext;                   /// следщ in overload list
    FuncDeclaration overnext0;          /// следщ in overload list (only используется during IFTI)
    Место endloc;                         /// location of closing curly bracket
    цел vtblIndex = -1;                 /// for member functions, index into vtbl[]
    бул naked;                         /// да if naked
    бул generated;                     /// да if function was generated by the compiler rather than
                                        /// supplied by the user
    ббайт isCrtCtorDtor;                /// has attribute pragma(crt_constructor(1)/crt_destructor(2))
                                        /// not set before the glue layer

    ILS inlineStatusStmt = ILS.uninitialized;
    ILS inlineStatusExp = ILS.uninitialized;
    PINLINE inlining = PINLINE.default_;

    цел inlineNest;                     /// !=0 if nested inline
    бул isArrayOp;                     /// да if массив operation
    бул eh_none;                       /// да if no exception unwinding is needed

    бул semantic3Errors;               /// да if errors in semantic3 this function's frame ptr
    ForeachStatement fes;               /// if foreach body, this is the foreach
    КлассОснова2* interfaceVirtual;        /// if virtual, but only appears in base interface vtbl[]
    бул introducing;                   /// да if 'introducing' function
    /** if !=NULL, then this is the тип
    of the 'introducing' function
    this one is overriding
    */
    Тип tintro;

    бул inferRetType;                  /// да if return тип is to be inferred
    КлассХранения storage_class2;        /// storage class for template onemember's

    // Things that should really go into Scope

    /// 1 if there's a return exp; инструкция
    /// 2 if there's a throw инструкция
    /// 4 if there's an assert(0)
    /// 8 if there's inline asm
    /// 16 if there are multiple return statements
    цел hasReturnExp;

    // Support for NRVO (named return значение optimization)
    бул nrvo_can = да;               /// да means we can do NRVO
    VarDeclaration nrvo_var;            /// variable to replace with shidden
    Symbol* shidden;                    /// hidden pointer passed to function

    ReturnStatements* returns;

    GotoStatements* gotos;              /// Gotos with forward references

    /// set if this is a known, builtin function we can evaluate at compile time
    BUILTIN builtin = BUILTIN.unknown;

    /// set if someone took the address of this function
    цел tookAddressOf;

    бул requiresClosure;               // this function needs a closure

    /** local variables in this function which are referenced by nested functions
     * (They'll get put into the "closure" for this function.)
     */
    VarDeclarations closureVars;

    /** Outer variables which are referenced by this nested function
     * (the inverse of closureVars)
     */
    VarDeclarations outerVars;

    /// Sibling nested functions which called this one
    FuncDeclarations siblingCallers;

    FuncDeclarations *inlinedNestedCallees;

    бцел flags;                        /// FUNCFLAG.xxxxx

    this(ref Место место, ref Место endloc, Идентификатор2 идент, КлассХранения класс_хранения, Тип тип)
    {
        super(место, идент);
        //printf("FuncDeclaration(ид = '%s', тип = %p)\n", ид.вТкст0(), тип);
        //printf("класс_хранения = x%x\n", класс_хранения);
        this.класс_хранения = класс_хранения;
        this.тип = тип;
        if (тип)
        {
            // Normalize класс_хранения, because function-тип related attributes
            // are already set in the 'тип' in parsing phase.
            this.класс_хранения &= ~(STC.TYPECTOR | STC.FUNCATTR);
        }
        this.endloc = endloc;
        /* The тип given for "infer the return тип" is a TypeFunction with
         * NULL for the return тип.
         */
        inferRetType = (тип && тип.nextOf() is null);
    }

    static FuncDeclaration создай(ref Место место, ref Место endloc, Идентификатор2 ид, КлассХранения класс_хранения, Тип тип)
    {
        return new FuncDeclaration(место, endloc, ид, класс_хранения, тип);
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        //printf("FuncDeclaration::syntaxCopy('%s')\n", вТкст0());
        FuncDeclaration f = s ? cast(FuncDeclaration)s : new FuncDeclaration(место, endloc, идент, класс_хранения, тип.syntaxCopy());
        f.frequires = frequires ? Инструкция2.arraySyntaxCopy(frequires) : null;
        f.fensures = fensures ? Гарант.arraySyntaxCopy(fensures) : null;
        f.fbody = fbody ? fbody.syntaxCopy() : null;
        return f;
    }

    /****************************************************
     * Resolve forward reference of function signature -
     * параметр types, return тип, and attributes.
     * Возвращает нет if any errors exist in the signature.
     */
    final бул functionSemantic()
    {
        if (!_scope)
            return !errors;

        if (!originalType) // semantic not yet run
        {
            TemplateInstance spec = isSpeculative();
            бцел olderrs = глоб2.errors;
            бцел oldgag = глоб2.gag;
            if (глоб2.gag && !spec)
                глоб2.gag = 0;
            dsymbolSemantic(this, _scope);
            глоб2.gag = oldgag;
            if (spec && глоб2.errors != olderrs)
                spec.errors = (глоб2.errors - olderrs != 0);
            if (olderrs != глоб2.errors) // if errors compiling this function
                return нет;
        }

        this.cppnamespace = _scope.namespace;

        // if inferring return тип, sematic3 needs to be run
        // - When the function body содержит any errors, we cannot assume
        //   the inferred return тип is valid.
        //   So, the body errors should become the function signature error.
        if (inferRetType && тип && !тип.nextOf())
            return functionSemantic3();

        TemplateInstance ti;
        if (isInstantiated() && !isVirtualMethod() &&
            ((ti = родитель.isTemplateInstance()) is null || ti.isTemplateMixin() || ti.tempdecl.идент == идент))
        {
            AggregateDeclaration ad = isMemberLocal();
            if (ad && ad.sizeok != Sizeok.done)
            {
                /* Currently dmd cannot resolve forward references per methods,
                 * then setting SIZOKfwd is too conservative and would break existing code.
                 * So, just stop method attributes inference until ad.dsymbolSemantic() done.
                 */
                //ad.sizeok = Sizeok.fwd;
            }
            else
                return functionSemantic3() || !errors;
        }

        if (класс_хранения & STC.inference)
            return functionSemantic3() || !errors;

        return !errors;
    }

    /****************************************************
     * Resolve forward reference of function body.
     * Возвращает нет if any errors exist in the body.
     */
    final бул functionSemantic3()
    {
        if (semanticRun < PASS.semantic3 && _scope)
        {
            /* Forward reference - we need to run semantic3 on this function.
             * If errors are gagged, and it's not part of a template instance,
             * we need to temporarily ungag errors.
             */
            TemplateInstance spec = isSpeculative();
            бцел olderrs = глоб2.errors;
            бцел oldgag = глоб2.gag;
            if (глоб2.gag && !spec)
                глоб2.gag = 0;
            semantic3(this, _scope);
            глоб2.gag = oldgag;

            // If it is a speculatively-instantiated template, and errors occur,
            // we need to mark the template as having errors.
            if (spec && глоб2.errors != olderrs)
                spec.errors = (глоб2.errors - olderrs != 0);
            if (olderrs != глоб2.errors) // if errors compiling this function
                return нет;
        }

        return !errors && !semantic3Errors;
    }

    /****************************************************
     * Check that this function тип is properly resolved.
     * If not, report "forward reference error" and return да.
     */
    extern (D) final бул checkForwardRef(ref Место место)
    {
        if (!functionSemantic())
            return да;

        /* No deco means the functionSemantic() call could not resolve
         * forward referenes in the тип of this function.
         */
        if (!тип.deco)
        {
            бул inSemantic3 = (inferRetType && semanticRun >= PASS.semantic3);
            .выведиОшибку(место, "forward reference to %s`%s`",
                (inSemantic3 ? "inferred return тип of function " : "").ptr,
                вТкст0());
            return да;
        }
        return нет;
    }

    // called from semantic3
    /**
     * Creates and returns the hidden parameters for this function declaration.
     *
     * Hidden parameters include the `this` параметр of a class, struct or
     * nested function and the selector параметр for Objective-C methods.
     */
    extern (D) final HiddenParameters declareThis(Scope* sc, AggregateDeclaration ad)
    {
        if (toParent2() != toParentLocal())
        {
            Тип tthis2 = Тип.tvoidptr.sarrayOf(2).pointerTo();
            tthis2 = tthis2.addMod(тип.mod)
                           .addStorageClass(класс_хранения);
            VarDeclaration v2 = new VarDeclaration(место, tthis2, Id.this2, null);
            v2.класс_хранения |= STC.параметр | STC.nodtor;
            if (тип.ty == Tfunction)
            {
                TypeFunction tf = cast(TypeFunction)тип;
                if (tf.isreturn)
                    v2.класс_хранения |= STC.return_;
                if (tf.isscope)
                    v2.класс_хранения |= STC.scope_;
                // if member function is marked 'inout', then this is 'return ref'
                if (tf.iswild & 2)
                    v2.класс_хранения |= STC.return_;
            }
            if (flags & FUNCFLAG.inferScope && !(v2.класс_хранения & STC.scope_))
                v2.класс_хранения |= STC.maybescope;
            v2.dsymbolSemantic(sc);
            if (!sc.вставь(v2))
                assert(0);
            v2.родитель = this;
            return HiddenParameters(v2, да);
        }
        if (ad)
        {
            //printf("declareThis() %s\n", вТкст0());
            Тип thandle = ad.handleType();
            assert(thandle);
            thandle = thandle.addMod(тип.mod);
            thandle = thandle.addStorageClass(класс_хранения);
            VarDeclaration v = new ThisDeclaration(место, thandle);
            v.класс_хранения |= STC.параметр;
            if (thandle.ty == Tstruct)
            {
                v.класс_хранения |= STC.ref_;
                // if member function is marked 'inout', then 'this' is 'return ref'
                if (тип.ty == Tfunction && (cast(TypeFunction)тип).iswild & 2)
                    v.класс_хранения |= STC.return_;
            }
            if (тип.ty == Tfunction)
            {
                TypeFunction tf = cast(TypeFunction)тип;
                if (tf.isreturn)
                    v.класс_хранения |= STC.return_;
                if (tf.isscope)
                    v.класс_хранения |= STC.scope_;
            }
            if (flags & FUNCFLAG.inferScope && !(v.класс_хранения & STC.scope_))
                v.класс_хранения |= STC.maybescope;

            v.dsymbolSemantic(sc);
            if (!sc.вставь(v))
                assert(0);
            v.родитель = this;
            return HiddenParameters(v, нет, objc.createSelectorParameter(this, sc));
        }
        if (isNested())
        {
            /* The 'this' for a nested function is the link to the
             * enclosing function's stack frame.
             * Note that nested functions and member functions are disjoint.
             */
            VarDeclaration v = new VarDeclaration(место, Тип.tvoid.pointerTo(), Id.capture, null);
            v.класс_хранения |= STC.параметр | STC.nodtor;
            if (тип.ty == Tfunction)
            {
                TypeFunction tf = cast(TypeFunction)тип;
                if (tf.isreturn)
                    v.класс_хранения |= STC.return_;
                if (tf.isscope)
                    v.класс_хранения |= STC.scope_;
            }
            if (flags & FUNCFLAG.inferScope && !(v.класс_хранения & STC.scope_))
                v.класс_хранения |= STC.maybescope;

            v.dsymbolSemantic(sc);
            if (!sc.вставь(v))
                assert(0);
            v.родитель = this;
            return HiddenParameters(v);
        }
        return HiddenParameters.init;
    }

    override final бул равен(КорневойОбъект o)
    {
        if (this == o)
            return да;

        if (auto s = isDsymbol(o))
        {
            auto fd1 = this;
            auto fd2 = s.isFuncDeclaration();
            if (!fd2)
                return нет;

            auto fa1 = fd1.isFuncAliasDeclaration();
            auto faf1 = fa1 ? fa1.toAliasFunc() : fd1;

            auto fa2 = fd2.isFuncAliasDeclaration();
            auto faf2 = fa2 ? fa2.toAliasFunc() : fd2;

            if (fa1 && fa2)
            {
                return faf1.равен(faf2) && fa1.hasOverloads == fa2.hasOverloads;
            }

            бул b1 = fa1 !is null;
            if (b1 && faf1.isUnique() && !fa1.hasOverloads)
                b1 = нет;

            бул b2 = fa2 !is null;
            if (b2 && faf2.isUnique() && !fa2.hasOverloads)
                b2 = нет;

            if (b1 != b2)
                return нет;

            return faf1.toParent().равен(faf2.toParent()) &&
                   faf1.идент.равен(faf2.идент) &&
                   faf1.тип.равен(faf2.тип);
        }
        return нет;
    }

    /****************************************************
     * Determine if 'this' overrides fd.
     * Return !=0 if it does.
     */
    final цел overrides(FuncDeclaration fd)
    {
        цел результат = 0;
        if (fd.идент == идент)
        {
            цел cov = тип.covariant(fd.тип);
            if (cov)
            {
                ClassDeclaration cd1 = toParent().isClassDeclaration();
                ClassDeclaration cd2 = fd.toParent().isClassDeclaration();
                if (cd1 && cd2 && cd2.isBaseOf(cd1, null))
                    результат = 1;
            }
        }
        return результат;
    }

    /*************************************************
     * Find index of function in vtbl[0..dim] that
     * this function overrides.
     * Prefer an exact match to a covariant one.
     * Параметры:
     *      vtbl     = vtable to use
     *      dim      = maximal vtable dimension
     *      fix17349 = enable fix https://issues.dlang.org/show_bug.cgi?ид=17349
     * Возвращает:
     *      -1      didn't найди one
     *      -2      can't determine because of forward references
     */
    final цел findVtblIndex(Дсимволы* vtbl, цел dim, бул fix17349 = да)
    {
        //printf("findVtblIndex() %s\n", вТкст0());
        FuncDeclaration mismatch = null;
        КлассХранения mismatchstc = 0;
        цел mismatchvi = -1;
        цел exactvi = -1;
        цел bestvi = -1;
        for (цел vi = 0; vi < dim; vi++)
        {
            FuncDeclaration fdv = (*vtbl)[vi].isFuncDeclaration();
            if (fdv && fdv.идент == идент)
            {
                if (тип.равен(fdv.тип)) // if exact match
                {
                    if (fdv.родитель.isClassDeclaration())
                    {
                        if (fdv.isFuture())
                        {
                            bestvi = vi;
                            continue;           // keep looking
                        }
                        return vi; // no need to look further
                    }

                    if (exactvi >= 0)
                    {
                        выведиОшибку("cannot determine overridden function");
                        return exactvi;
                    }
                    exactvi = vi;
                    bestvi = vi;
                    continue;
                }

                КлассХранения stc = 0;
                цел cov = тип.covariant(fdv.тип, &stc, fix17349);
                //printf("\tbaseclass cov = %d\n", cov);
                switch (cov)
                {
                case 0:
                    // types are distinct
                    break;

                case 1:
                    bestvi = vi; // covariant, but not identical
                    break;
                    // keep looking for an exact match

                case 2:
                    mismatchvi = vi;
                    mismatchstc = stc;
                    mismatch = fdv; // overrides, but is not covariant
                    break;
                    // keep looking for an exact match

                case 3:
                    return -2; // forward references

                default:
                    assert(0);
                }
            }
        }
        if (bestvi == -1 && mismatch)
        {
            //тип.print();
            //mismatch.тип.print();
            //printf("%s %s\n", тип.deco, mismatch.тип.deco);
            //printf("stc = %llx\n", mismatchstc);
            if (mismatchstc)
            {
                // Fix it by modifying the тип to add the storage classes
                тип = тип.addStorageClass(mismatchstc);
                bestvi = mismatchvi;
            }
        }
        return bestvi;
    }

    /*********************************
     * If function a function in a base class,
     * return that base class.
     * Возвращает:
     *  base class if overriding, null if not
     */
    final КлассОснова2* overrideInterface()
    {
        if (ClassDeclaration cd = toParent2().isClassDeclaration())
        {
            foreach (b; cd.interfaces)
            {
                auto v = findVtblIndex(&b.sym.vtbl, cast(цел)b.sym.vtbl.dim);
                if (v >= 0)
                    return b;
            }
        }
        return null;
    }

    /****************************************************
     * Overload this FuncDeclaration with the new one f.
     * Return да if successful; i.e. no conflict.
     */
    override бул overloadInsert(ДСимвол s)
    {
        //printf("FuncDeclaration::overloadInsert(s = %s) this = %s\n", s.вТкст0(), вТкст0());
        assert(s != this);
        AliasDeclaration ad = s.isAliasDeclaration();
        if (ad)
        {
            if (overnext)
                return overnext.overloadInsert(ad);
            if (!ad.aliassym && ad.тип.ty != Tident && ad.тип.ty != Tinstance && ad.тип.ty != Ttypeof)
            {
                //printf("\tad = '%s'\n", ad.тип.вТкст0());
                return нет;
            }
            overnext = ad;
            //printf("\ttrue: no conflict\n");
            return да;
        }
        TemplateDeclaration td = s.isTemplateDeclaration();
        if (td)
        {
            if (!td.funcroot)
                td.funcroot = this;
            if (overnext)
                return overnext.overloadInsert(td);
            overnext = td;
            return да;
        }
        FuncDeclaration fd = s.isFuncDeclaration();
        if (!fd)
            return нет;

        version (none)
        {
            /* Disable this check because:
             *  const проц foo();
             * semantic() isn't run yet on foo(), so the const hasn't been
             * applied yet.
             */
            if (тип)
            {
                printf("тип = %s\n", тип.вТкст0());
                printf("fd.тип = %s\n", fd.тип.вТкст0());
            }
            // fd.тип can be NULL for overloaded constructors
            if (тип && fd.тип && fd.тип.covariant(тип) && fd.тип.mod == тип.mod && !isFuncAliasDeclaration())
            {
                //printf("\tfalse: conflict %s\n", вид());
                return нет;
            }
        }

        if (overnext)
        {
            td = overnext.isTemplateDeclaration();
            if (td)
                fd.overloadInsert(td);
            else
                return overnext.overloadInsert(fd);
        }
        overnext = fd;
        //printf("\ttrue: no conflict\n");
        return да;
    }

    /********************************************
     * Find function in overload list that exactly matches t.
     */
    extern (D) final FuncDeclaration overloadExactMatch(Тип t)
    {
        FuncDeclaration fd;
        overloadApply(this, (ДСимвол s)
        {
            auto f = s.isFuncDeclaration();
            if (!f)
                return 0;
            if (t.равен(f.тип))
            {
                fd = f;
                return 1;
            }

            /* Allow covariant matches, as long as the return тип
             * is just a const conversion.
             * This allows things like  functions to match with an impure function тип.
             */
            if (t.ty == Tfunction)
            {
                auto tf = cast(TypeFunction)f.тип;
                if (tf.covariant(t) == 1 &&
                    tf.nextOf().implicitConvTo(t.nextOf()) >= MATCH.constant)
                {
                    fd = f;
                    return 1;
                }
            }
            return 0;
        });
        return fd;
    }

    /********************************************
     * Find function in overload list that matches to the 'this' modifier.
     * There's four результат types.
     *
     * 1. If the 'tthis' matches only one candidate, it's an "exact match".
     *    Возвращает the function and 'hasOverloads' is set to нет.
     *      eg. If 'tthis" is mutable and there's only one mutable method.
     * 2. If there's two or more match candidates, but a candidate function will be
     *    a "better match".
     *    Возвращает the better match function but 'hasOverloads' is set to да.
     *      eg. If 'tthis' is mutable, and there's both mutable and const methods,
     *          the mutable method will be a better match.
     * 3. If there's two or more match candidates, but there's no better match,
     *    Возвращает null and 'hasOverloads' is set to да to represent "ambiguous match".
     *      eg. If 'tthis' is mutable, and there's two or more mutable methods.
     * 4. If there's no candidates, it's "no match" and returns null with error report.
     *      e.g. If 'tthis' is const but there's no const methods.
     */
    extern (D) final FuncDeclaration overloadModMatch(ref Место место, Тип tthis, ref бул hasOverloads)
    {
        //printf("FuncDeclaration::overloadModMatch('%s')\n", вТкст0());
        MatchAccumulator m;
        overloadApply(this, (ДСимвол s)
        {
            auto f = s.isFuncDeclaration();
            if (!f || f == m.lastf) // skip duplicates
                return 0;

            auto tf = f.тип.toTypeFunction();
            //printf("tf = %s\n", tf.вТкст0());

            MATCH match;
            if (tthis) // non-static functions are preferred than static ones
            {
                if (f.needThis())
                    match = f.isCtorDeclaration() ? MATCH.exact : MODmethodConv(tthis.mod, tf.mod);
                else
                    match = MATCH.constant; // keep static function in overload candidates
            }
            else // static functions are preferred than non-static ones
            {
                if (f.needThis())
                    match = MATCH.convert;
                else
                    match = MATCH.exact;
            }
            if (match == MATCH.nomatch)
                return 0;

            if (match > m.last) goto LcurrIsBetter;
            if (match < m.last) goto LlastIsBetter;

            // See if one of the matches overrides the other.
            if (m.lastf.overrides(f)) goto LlastIsBetter;
            if (f.overrides(m.lastf)) goto LcurrIsBetter;

            //printf("\tambiguous\n");
            m.nextf = f;
            m.count++;
            return 0;

        LlastIsBetter:
            //printf("\tlastbetter\n");
            m.count++; // count up
            return 0;

        LcurrIsBetter:
            //printf("\tisbetter\n");
            if (m.last <= MATCH.convert)
            {
                // clear last secondary matching
                m.nextf = null;
                m.count = 0;
            }
            m.last = match;
            m.lastf = f;
            m.count++; // count up
            return 0;
        });

        if (m.count == 1)       // exact match
        {
            hasOverloads = нет;
        }
        else if (m.count > 1)   // better or ambiguous match
        {
            hasOverloads = да;
        }
        else                    // no match
        {
            hasOverloads = да;
            auto tf = this.тип.toTypeFunction();
            assert(tthis);
            assert(!MODimplicitConv(tthis.mod, tf.mod)); // modifier mismatch
            {
                БуфВыв thisBuf, funcBuf;
                MODMatchToBuffer(&thisBuf, tthis.mod, tf.mod);
                MODMatchToBuffer(&funcBuf, tf.mod, tthis.mod);
                .выведиОшибку(место, "%smethod %s is not callable using a %sobject",
                    funcBuf.peekChars(), this.toPrettyChars(), thisBuf.peekChars());
            }
        }
        return m.lastf;
    }

    /********************************************
     * найди function template root in overload list
     */
    extern (D) final TemplateDeclaration findTemplateDeclRoot()
    {
        FuncDeclaration f = this;
        while (f && f.overnext)
        {
            //printf("f.overnext = %p %s\n", f.overnext, f.overnext.вТкст0());
            TemplateDeclaration td = f.overnext.isTemplateDeclaration();
            if (td)
                return td;
            f = f.overnext.isFuncDeclaration();
        }
        return null;
    }

    /********************************************
     * Возвращает да if function was declared
     * directly or indirectly in a unittest block
     */
    final бул inUnittest()
    {
        ДСимвол f = this;
        do
        {
            if (f.isUnitTestDeclaration())
                return да;
            f = f.toParent();
        }
        while (f);
        return нет;
    }

    /*************************************
     * Determine partial specialization order of 'this' vs g.
     * This is very similar to TemplateDeclaration::leastAsSpecialized().
     * Возвращает:
     *      match   'this' is at least as specialized as g
     *      0       g is more specialized than 'this'
     */
    final MATCH leastAsSpecialized(FuncDeclaration g)
    {
        const LOG_LEASTAS = 0;
        static if (LOG_LEASTAS)
        {
            printf("%s.leastAsSpecialized(%s)\n", вТкст0(), g.вТкст0());
            printf("%s, %s\n", тип.вТкст0(), g.тип.вТкст0());
        }

        /* This works by calling g() with f()'s parameters, and
         * if that is possible, then f() is at least as specialized
         * as g() is.
         */

        TypeFunction tf = тип.toTypeFunction();
        TypeFunction tg = g.тип.toTypeFunction();
        т_мера nfparams = tf.parameterList.length;

        /* If both functions have a 'this' pointer, and the mods are not
         * the same and g's is not const, then this is less specialized.
         */
        if (needThis() && g.needThis() && tf.mod != tg.mod)
        {
            if (isCtorDeclaration())
            {
                if (!MODimplicitConv(tg.mod, tf.mod))
                    return MATCH.nomatch;
            }
            else
            {
                if (!MODimplicitConv(tf.mod, tg.mod))
                    return MATCH.nomatch;
            }
        }

        /* Create a dummy массив of arguments out of the parameters to f()
         */
        Выражения args = Выражения(nfparams);
        for (т_мера u = 0; u < nfparams; u++)
        {
            Параметр2 p = tf.parameterList[u];
            Выражение e;
            if (p.классХранения & (STC.ref_ | STC.out_))
            {
                e = new IdentifierExp(Место.initial, p.идент);
                e.тип = p.тип;
            }
            else
                e = p.тип.defaultInitLiteral(Место.initial);
            args[u] = e;
        }

        MATCH m = tg.callMatch(null, args[], 1);
        if (m > MATCH.nomatch)
        {
            /* A variadic параметр list is less specialized than a
             * non-variadic one.
             */
            if (tf.parameterList.varargs && !tg.parameterList.varargs)
                goto L1; // less specialized

            static if (LOG_LEASTAS)
            {
                printf("  matches %d, so is least as specialized\n", m);
            }
            return m;
        }
    L1:
        static if (LOG_LEASTAS)
        {
            printf("  doesn't match, so is not as specialized\n");
        }
        return MATCH.nomatch;
    }

    /********************************
     * Labels are in a separate scope, one per function.
     */
    final LabelDsymbol searchLabel(Идентификатор2 идент)
    {
        ДСимвол s;
        if (!labtab)
            labtab = new DsymbolTable(); // guess we need one

        s = labtab.lookup(идент);
        if (!s)
        {
            s = new LabelDsymbol(идент);
            labtab.вставь(s);
        }
        return cast(LabelDsymbol)s;
    }

    /*****************************************
     * Determine lexical уровень difference from `this` to nested function `fd`.
     * Параметры:
     *      fd = target of call
     *      intypeof = !=0 if inside typeof
     * Возвращает:
     *      0       same уровень
     *      >0      decrease nesting by number
     *      -1      increase nesting by 1 (`fd` is nested within `this`)
     *      LevelError  error, `this` cannot call `fd`
     */
    final цел getLevel(FuncDeclaration fd, цел intypeof)
    {
        //printf("FuncDeclaration::getLevel(fd = '%s')\n", fd.вТкст0());
        ДСимвол fdparent = fd.toParent2();
        if (fdparent == this)
            return -1;

        ДСимвол s = this;
        цел уровень = 0;
        while (fd != s && fdparent != s.toParent2())
        {
            //printf("\ts = %s, '%s'\n", s.вид(), s.вТкст0());
            if (auto thisfd = s.isFuncDeclaration())
            {
                if (!thisfd.isNested() && !thisfd.vthis && !intypeof)
                    return LevelError;
            }
            else
            {
                if (auto thiscd = s.isAggregateDeclaration())
                {
                    /* AggregateDeclaration::isNested returns да only when
                     * it has a hidden pointer.
                     * But, calling the function belongs unrelated lexical scope
                     * is still allowed inside typeof.
                     *
                     * struct Map(alias fun) {
                     *   typeof({ return fun(); }) RetType;
                     *   // No member function makes Map struct 'not nested'.
                     * }
                     */
                    if (!thiscd.isNested() && !intypeof)
                        return LevelError;
                }
                else
                    return LevelError;
            }

            s = s.toParentP(fd);
            assert(s);
            уровень++;
        }
        return уровень;
    }

    /***********************************
     * Determine lexical уровень difference from `this` to nested function `fd`.
     * Issue error if `this` cannot call `fd`.
     * Параметры:
     *      место = location for error messages
     *      sc = context
     *      fd = target of call
     * Возвращает:
     *      0       same уровень
     *      >0      decrease nesting by number
     *      -1      increase nesting by 1 (`fd` is nested within 'this')
     *      LevelError  error
     */
    final цел getLevelAndCheck(ref Место место, Scope* sc, FuncDeclaration fd)
    {
        цел уровень = getLevel(fd, sc.intypeof);
        if (уровень != LevelError)
            return уровень;

        // Don't give error if in template constraint
        if (!(sc.flags & SCOPE.constraint))
        {
            ткст0 xstatic = isStatic() ? "static " : "";
            // better diagnostics for static functions
            .выведиОшибку(место, "%s%s %s cannot access frame of function %s",
                xstatic, вид(), toPrettyChars(), fd.toPrettyChars());
            return LevelError;
        }
        return 1;
    }

    const LevelError = -2;

    override ткст0 toPrettyChars(бул QualifyTypes = нет)
    {
        if (isMain())
            return "D main";
        else
            return ДСимвол.toPrettyChars(QualifyTypes);
    }

    /** for diagnostics, e.g. 'цел foo(цел x, цел y) ' */
    final ткст0 toFullSignature()
    {
        БуфВыв буф;
        functionToBufferWithIdent(тип.toTypeFunction(), &буф, вТкст0());
        return буф.extractChars();
    }

    final бул isMain()
    {
        return идент == Id.main && компонаж != LINK.c && !isMember() && !isNested();
    }

    final бул isCMain()
    {
        return идент == Id.main && компонаж == LINK.c && !isMember() && !isNested();
    }

    final бул isWinMain()
    {
        //printf("FuncDeclaration::isWinMain() %s\n", вТкст0());
        version (none)
        {
            бул x = идент == Id.WinMain && компонаж != LINK.c && !isMember();
            printf("%s\n", x ? "yes" : "no");
            return x;
        }
        else
        {
            return идент == Id.WinMain && компонаж != LINK.c && !isMember();
        }
    }

    final бул isDllMain()
    {
        return идент == Id.DllMain && компонаж != LINK.c && !isMember();
    }

    final бул isRtInit()
    {
        return идент == Id.rt_init && компонаж == LINK.c && !isMember() && !isNested();
    }

    override final бул isExport()
    {
        return защита.вид == Prot.Kind.export_;
    }

    override final бул isImportedSymbol()
    {
        //printf("isImportedSymbol()\n");
        //printf("защита = %d\n", защита);
        return (защита.вид == Prot.Kind.export_) && !fbody;
    }

    override final бул isCodeseg()  
    {
        return да; // functions are always in the code segment
    }

    override final бул перегружаем_ли()
    {
        return да; // functions can be overloaded
    }

    /***********************************
     * Override so it can work even if semantic() hasn't yet
     * been run.
     */
    override final бул isAbstract()
    {
        if (класс_хранения & STC.abstract_)
            return да;
        if (semanticRun >= PASS.semanticdone)
            return нет;

        if (_scope)
        {
           if (_scope.stc & STC.abstract_)
                return да;
           родитель = _scope.родитель;
           ДСимвол родитель = toParent();
           if (родитель.isInterfaceDeclaration())
                return да;
        }
        return нет;
    }

    /**********************************
     * Decide if attributes for this function can be inferred from examining
     * the function body.
     * Возвращает:
     *  да if can
     */
    final бул canInferAttributes(Scope* sc)
    {
        if (!fbody)
            return нет;

        if (isVirtualMethod())
            return нет;               // since they may be overridden

        if (sc.func &&
            /********** this is for backwards compatibility for the moment ********/
            (!isMember() || sc.func.isSafeBypassingInference() && !isInstantiated()))
            return да;

        if (isFuncLiteralDeclaration() ||               // externs are not possible with literals
            (класс_хранения & STC.inference) ||           // do attribute inference
            (inferRetType && !isCtorDeclaration()))
            return да;

        if (isInstantiated())
        {
            auto ti = родитель.isTemplateInstance();
            if (ti is null || ti.isTemplateMixin() || ti.tempdecl.идент == идент)
                return да;
        }

        return нет;
    }

    /*****************************************
     * Initialize for inferring the attributes of this function.
     */
    final проц initInferAttributes()
    {
        //printf("initInferAttributes() for %s (%s)\n", toPrettyChars(), идент.вТкст0());
        TypeFunction tf = тип.toTypeFunction();
        if (tf.purity == PURE.impure) // purity not specified
            flags |= FUNCFLAG.purityInprocess;

        if (tf.trust == TRUST.default_)
            flags |= FUNCFLAG.safetyInprocess;

        if (!tf.isnothrow)
            flags |= FUNCFLAG.nothrowInprocess;

        if (!tf.isnogc)
            flags |= FUNCFLAG.nogcInprocess;

        if (!isVirtual() || introducing)
            flags |= FUNCFLAG.returnInprocess;

        // Initialize for inferring STC.scope_
        if (глоб2.парамы.vsafe)
            flags |= FUNCFLAG.inferScope;
    }

    final PURE isPure()
    {
        //printf("FuncDeclaration::isPure() '%s'\n", вТкст0());
        TypeFunction tf = тип.toTypeFunction();
        if (flags & FUNCFLAG.purityInprocess)
            setImpure();
        if (tf.purity == PURE.fwdref)
            tf.purityLevel();
        PURE purity = tf.purity;
        if (purity > PURE.weak && isNested())
            purity = PURE.weak;
        if (purity > PURE.weak && needThis())
        {
            // The attribute of the 'this' reference affects purity strength
            if (тип.mod & MODFlags.immutable_)
            {
            }
            else if (тип.mod & (MODFlags.const_ | MODFlags.wild) && purity >= PURE.const_)
                purity = PURE.const_;
            else
                purity = PURE.weak;
        }
        tf.purity = purity;
        // ^ This rely on the current situation that every FuncDeclaration has a
        //   unique TypeFunction.
        return purity;
    }

    final PURE isPureBypassingInference()
    {
        if (flags & FUNCFLAG.purityInprocess)
            return PURE.fwdref;
        else
            return isPure();
    }

    /**************************************
     * The function is doing something impure,
     * so mark it as impure.
     * If there's a purity error, return да.
     */
    extern (D) final бул setImpure()
    {
        if (flags & FUNCFLAG.purityInprocess)
        {
            flags &= ~FUNCFLAG.purityInprocess;
            if (fes)
                fes.func.setImpure();
        }
        else if (isPure())
            return да;
        return нет;
    }

    final бул isSafe()
    {
        if (flags & FUNCFLAG.safetyInprocess)
            setUnsafe();
        return тип.toTypeFunction().trust == TRUST.safe;
    }

    final бул isSafeBypassingInference()
    {
        return !(flags & FUNCFLAG.safetyInprocess) && isSafe();
    }

    final бул isTrusted()
    {
        if (flags & FUNCFLAG.safetyInprocess)
            setUnsafe();
        return тип.toTypeFunction().trust == TRUST.trusted;
    }

    /**************************************
     * The function is doing something unsafe,
     * so mark it as unsafe.
     * If there's a safe error, return да.
     */
    extern (D) final бул setUnsafe()
    {
        if (flags & FUNCFLAG.safetyInprocess)
        {
            flags &= ~FUNCFLAG.safetyInprocess;
            тип.toTypeFunction().trust = TRUST.system;
            if (fes)
                fes.func.setUnsafe();
        }
        else if (isSafe())
            return да;
        return нет;
    }

    final бул isNogc()
    {
        //printf("isNogc() %s, inprocess: %d\n", вТкст0(), !!(flags & FUNCFLAG.nogcInprocess));
        if (flags & FUNCFLAG.nogcInprocess)
            setGC();
        return тип.toTypeFunction().isnogc;
    }

    final бул isNogcBypassingInference()
    {
        return !(flags & FUNCFLAG.nogcInprocess) && isNogc();
    }

    /**************************************
     * The function is doing something that may размести with the СМ,
     * so mark it as not nogc (not no-how).
     * Возвращает:
     *      да if function is marked as , meaning a user error occurred
     */
    extern (D) final бул setGC()
    {
        //printf("setGC() %s\n", вТкст0());
        if (flags & FUNCFLAG.nogcInprocess && semanticRun < PASS.semantic3 && _scope)
        {
            this.semantic2(_scope);
            this.semantic3(_scope);
        }

        if (flags & FUNCFLAG.nogcInprocess)
        {
            flags &= ~FUNCFLAG.nogcInprocess;
            тип.toTypeFunction().isnogc = нет;
            if (fes)
                fes.func.setGC();
        }
        else if (isNogc())
            return да;
        return нет;
    }

    extern (D) final проц printGCUsage(ref Место место, ткст0 warn)
    {
        if (!глоб2.парамы.vgc)
            return;

        Module m = getModule();
        if (m && m.isRoot() && !inUnittest())
        {
            message(место, "vgc: %s", warn);
        }
    }

    /********************************************
     * See if pointers from function parameters, mutable globals, or uplevel functions
     * could leak into return значение.
     * Возвращает:
     *   да if the function return значение is isolated from
     *   any inputs to the function
     */
    extern (D) final бул isReturnIsolated()
    {
        TypeFunction tf = тип.toTypeFunction();
        assert(tf.следщ);

        Тип treti = tf.следщ;
        if (tf.isref)
            return isTypeIsolatedIndirect(treti);              // check influence from parameters

        return isTypeIsolated(treti);
    }

    /********************
     * See if pointers from function parameters, mutable globals, or uplevel functions
     * could leak into тип `t`.
     * Параметры:
     *   t = тип to check if it is isolated
     * Возвращает:
     *   да if `t` is isolated from
     *   any inputs to the function
     */
    extern (D) final бул isTypeIsolated(Тип t)
    {
        //printf("isTypeIsolated(t: %s)\n", t.вТкст0());

        t = t.baseElemOf();
        switch (t.ty)
        {
            case Tarray:
            case Tpointer:
                return isTypeIsolatedIndirect(t.nextOf()); // go down one уровень

            case Taarray:
            case Tclass:
                return isTypeIsolatedIndirect(t);

            case Tstruct:
                /* Drill down and check the struct's fields
                 */
                auto sym = t.toDsymbol(null).isStructDeclaration();
                foreach (v; sym.fields)
                {
                    Тип tmi = v.тип.addMod(t.mod);
                    //printf("\tt = %s, tmi = %s\n", t.вТкст0(), tmi.вТкст0());
                    if (!isTypeIsolated(tmi))
                        return нет;
                }
                return да;

            default:
                return да;
        }
    }

    /********************************************
     * Параметры:
     *    t = тип of объект to test one уровень of indirection down
     * Возвращает:
     *    да if an объект typed `t` has no indirections
     *    which could have come from the function's parameters, mutable
     *    globals, or uplevel functions.
     */
    private бул isTypeIsolatedIndirect(Тип t)
    {
        //printf("isTypeIsolatedIndirect(t: %s)\n", t.вТкст0());
        assert(t);

        /* Since `t` is one уровень down from an indirection, it could pick
         * up a reference to a mutable глоб2 or an outer function, so
         * return нет.
         */
        if (!isPureBypassingInference() || isNested())
            return нет;

        TypeFunction tf = тип.toTypeFunction();

        //printf("isTypeIsolatedIndirect(%s) t = %s\n", tf.вТкст0(), t.вТкст0());

        т_мера dim = tf.parameterList.length;
        for (т_мера i = 0; i < dim; i++)
        {
            Параметр2 fparam = tf.parameterList[i];
            Тип tp = fparam.тип;
            if (!tp)
                continue;

            if (fparam.классХранения & (STC.lazy_ | STC.out_ | STC.ref_))
            {
                if (!traverseIndirections(tp, t))
                    return нет;
                continue;
            }

            /* Goes down one уровень of indirection, then calls traverseIndirection() on
             * the результат.
             * Возвращает:
             *  да if t is isolated from tp
             */
            static бул traverse(Тип tp, Тип t)
            {
                tp = tp.baseElemOf();
                switch (tp.ty)
                {
                    case Tarray:
                    case Tpointer:
                        return traverseIndirections(tp.nextOf(), t);

                    case Taarray:
                    case Tclass:
                        return traverseIndirections(tp, t);

                    case Tstruct:
                        /* Drill down and check the struct's fields
                         */
                        auto sym = tp.toDsymbol(null).isStructDeclaration();
                        foreach (v; sym.fields)
                        {
                            Тип tprmi = v.тип.addMod(tp.mod);
                            //printf("\ttp = %s, tprmi = %s\n", tp.вТкст0(), tprmi.вТкст0());
                            if (!traverse(tprmi, t))
                                return нет;
                        }
                        return да;

                    default:
                        return да;
                }
            }

            if (!traverse(tp, t))
                return нет;
        }
        // The 'this' reference is a параметр, too
        if (AggregateDeclaration ad = isCtorDeclaration() ? null : isThis())
        {
            Тип tthis = ad.getType().addMod(tf.mod);
            //printf("\ttthis = %s\n", tthis.вТкст0());
            if (!traverseIndirections(tthis, t))
                return нет;
        }

        return да;
    }

    /****************************************
     * Determine if function needs a static frame pointer.
     * Возвращает:
     *  `да` if function is really nested within other function.
     * Contracts:
     *  If isNested() returns да, isThis() should return нет,
     *  unless the function needs a dual-context pointer.
     */
    бул isNested()
    {
        auto f = toAliasFunc();
        //printf("\ttoParent2() = '%s'\n", f.toParent2().вТкст0());
        return ((f.класс_хранения & STC.static_) == 0) &&
                (f.компонаж == LINK.d) &&
                (f.toParent2().isFuncDeclaration() !is null ||
                 f.toParent2() !is f.toParentLocal());
    }

    /****************************************
     * Determine if function is a non-static member function
     * that has an implicit 'this' Выражение.
     * Возвращает:
     *  The aggregate it is a member of, or null.
     * Contracts:
     *  Both isThis() and isNested() should return да if function needs a dual-context pointer,
     *  otherwise if isThis() returns да, isNested() should return нет.
     */
    override AggregateDeclaration isThis()
    {
        //printf("+FuncDeclaration::isThis() '%s'\n", вТкст0());
        auto ad = (класс_хранения & STC.static_) ? objc.isThis(this) : isMemberLocal();
        //printf("-FuncDeclaration::isThis() %p\n", ad);
        return ad;
    }

    override final бул needThis()
    {
        //printf("FuncDeclaration::needThis() '%s'\n", вТкст0());
        return toAliasFunc().isThis() !is null;
    }

    // Determine if a function is pedantically virtual
    final бул isVirtualMethod()
    {
        if (toAliasFunc() != this)
            return toAliasFunc().isVirtualMethod();

        //printf("FuncDeclaration::isVirtualMethod() %s\n", вТкст0());
        if (!isVirtual())
            return нет;
        // If it's a final method, and does not override anything, then it is not virtual
        if (isFinalFunc() && foverrides.dim == 0)
        {
            return нет;
        }
        return да;
    }

    // Determine if function goes into virtual function pointer table
    бул isVirtual()
    {
        if (toAliasFunc() != this)
            return toAliasFunc().isVirtual();

        auto p = toParent();

        if (!isMember || !p.isClassDeclaration)
            return нет;
                                                             // https://issues.dlang.org/show_bug.cgi?ид=19654
        if (p.isClassDeclaration.classKind == ClassKind.objc && !p.isInterfaceDeclaration)
            return objc.isVirtual(this);

        version (none)
        {
            printf("FuncDeclaration::isVirtual(%s)\n", вТкст0());
            printf("isMember:%p isStatic:%d private:%d ctor:%d !Dlinkage:%d\n", isMember(), isStatic(), защита == Prot.Kind.private_, isCtorDeclaration(), компонаж != LINK.d);
            printf("результат is %d\n", isMember() && !(isStatic() || защита == Prot.Kind.private_ || защита == Prot.Kind.package_) && p.isClassDeclaration() && !(p.isInterfaceDeclaration() && isFinalFunc()));
        }
        return !(isStatic() || защита.вид == Prot.Kind.private_ || защита.вид == Prot.Kind.package_) && !(p.isInterfaceDeclaration() && isFinalFunc());
    }

    final бул isFinalFunc()
    {
        if (toAliasFunc() != this)
            return toAliasFunc().isFinalFunc();

        version (none)
        {{
            auto cd = toParent().isClassDeclaration();
            printf("FuncDeclaration::isFinalFunc(%s), %x\n", вТкст0(), Declaration.isFinal());
            printf("%p %d %d %d\n", isMember(), isStatic(), Declaration.isFinal(), ((cd = toParent().isClassDeclaration()) !is null && cd.класс_хранения & STC.final_));
            printf("результат is %d\n", isMember() && (Declaration.isFinal() || (cd !is null && cd.класс_хранения & STC.final_)));
            if (cd)
                printf("\tmember of %s\n", cd.вТкст0());
        }}
        if (!isMember())
            return нет;
        if (Declaration.isFinal())
            return да;
        auto cd = toParent().isClassDeclaration();
        return (cd !is null) && (cd.класс_хранения & STC.final_);
    }

    бул addPreInvariant()
    {
        auto ad = isThis();
        ClassDeclaration cd = ad ? ad.isClassDeclaration() : null;
        return (ad && !(cd && cd.isCPPclass()) && глоб2.парамы.useInvariants == CHECKENABLE.on && (защита.вид == Prot.Kind.protected_ || защита.вид == Prot.Kind.public_ || защита.вид == Prot.Kind.export_) && !naked);
    }

    бул addPostInvariant()
    {
        auto ad = isThis();
        ClassDeclaration cd = ad ? ad.isClassDeclaration() : null;
        return (ad && !(cd && cd.isCPPclass()) && ad.inv && глоб2.парамы.useInvariants == CHECKENABLE.on && (защита.вид == Prot.Kind.protected_ || защита.вид == Prot.Kind.public_ || защита.вид == Prot.Kind.export_) && !naked);
    }

    override ткст0 вид()
    {
        return generated ? "generated function" : "function";
    }

    /********************************************
     * Возвращает:
     *  да if there are no overloads of this function
     */
    final бул isUnique()
    {
        бул результат = нет;
        overloadApply(/*cast()*/ this, (ДСимвол s)
        {
            auto f = s.isFuncDeclaration();
            if (!f)
                return 0;
            if (результат)
            {
                результат = нет;
                return 1; // ambiguous, done
            }
            else
            {
                результат = да;
                return 0;
            }
        });
        return результат;
    }

    /*********************************************
     * In the current function, we are calling 'this' function.
     * 1. Check to see if the current function can call 'this' function, issue error if not.
     * 2. If the current function is not the родитель of 'this' function, then add
     *    the current function to the list of siblings of 'this' function.
     * 3. If the current function is a literal, and it's accessing an uplevel scope,
     *    then mark it as a delegate.
     * Возвращает да if error occurs.
     */
    extern (D) final бул checkNestedReference(Scope* sc, ref Место место)
    {
        //printf("FuncDeclaration::checkNestedReference() %s\n", toPrettyChars());

        if (auto fld = this.isFuncLiteralDeclaration())
        {
            if (fld.tok == ТОК2.reserved)
            {
                fld.tok = ТОК2.function_;
                fld.vthis = null;
            }
        }

        if (!родитель || родитель == sc.родитель)
            return нет;
        if (идент == Id.require || идент == Id.ensure)
            return нет;
        if (!isThis() && !isNested())
            return нет;

        // The current function
        FuncDeclaration fdthis = sc.родитель.isFuncDeclaration();
        if (!fdthis)
            return нет; // out of function scope

        ДСимвол p = toParentLocal();
        ДСимвол p2 = toParent2();

        // Function literals from fdthis to p must be delegates
        ensureStaticLinkTo(fdthis, p);
        if (p != p2)
            ensureStaticLinkTo(fdthis, p2);

        if (isNested())
        {
            // The function that this function is in
            бул checkEnclosing(FuncDeclaration fdv)
            {
                if (!fdv)
                    return нет;
                if (fdv == fdthis)
                    return нет;

                //printf("this = %s in [%s]\n", this.вТкст0(), this.место.вТкст0());
                //printf("fdv  = %s in [%s]\n", fdv .вТкст0(), fdv .место.вТкст0());
                //printf("fdthis = %s in [%s]\n", fdthis.вТкст0(), fdthis.место.вТкст0());

                // Add this function to the list of those which called us
                if (fdthis != this)
                {
                    бул found = нет;
                    for (т_мера i = 0; i < siblingCallers.dim; ++i)
                    {
                        if (siblingCallers[i] == fdthis)
                            found = да;
                    }
                    if (!found)
                    {
                        //printf("\tadding sibling %s\n", fdthis.toPrettyChars());
                        if (!sc.intypeof && !(sc.flags & SCOPE.compile))
                            siblingCallers.сунь(fdthis);
                    }
                }

                const lv = fdthis.getLevelAndCheck(место, sc, fdv);
                if (lv == LevelError)
                    return да; // error
                if (lv == -1)
                    return нет; // downlevel call
                if (lv == 0)
                    return нет; // same уровень call

                return нет; // Uplevel call
            }

            if (checkEnclosing(p.isFuncDeclaration()))
                return да;
            if (checkEnclosing(p == p2 ? null : p2.isFuncDeclaration()))
                return да;
        }
        return нет;
    }

    /*******************************
     * Look at all the variables in this function that are referenced
     * by nested functions, and determine if a closure needs to be
     * created for them.
     */
    final бул needsClosure()
    {
        /* Need a closure for all the closureVars[] if any of the
         * closureVars[] are accessed by a
         * function that escapes the scope of this function.
         * We take the conservative approach and decide that a function needs
         * a closure if it:
         * 1) is a virtual function
         * 2) has its address taken
         * 3) has a родитель that escapes
         * 4) calls another nested function that needs a closure
         *
         * Note that since a non-virtual function can be called by
         * a virtual one, if that non-virtual function accesses a closure
         * var, the closure still has to be taken. Hence, we check for isThis()
         * instead of isVirtual(). (thanks to David Friedman)
         *
         * When the function returns a local struct or class, `requiresClosure`
         * is already set to `да` upon entering this function when the
         * struct/class refers to a local variable and a closure is needed.
         */

        //printf("FuncDeclaration::needsClosure() %s\n", вТкст0());

        if (requiresClosure)
            goto Lyes;

        for (т_мера i = 0; i < closureVars.dim; i++)
        {
            VarDeclaration v = closureVars[i];
            //printf("\tv = %s\n", v.вТкст0());

            for (т_мера j = 0; j < v.nestedrefs.dim; j++)
            {
                FuncDeclaration f = v.nestedrefs[j];
                assert(f != this);

                /* __require and __ensure will always get called directly,
                 * so they never make outer functions closure.
                 */
                if (f.идент == Id.require || f.идент == Id.ensure)
                    continue;

                //printf("\t\tf = %p, %s, isVirtual=%d, isThis=%p, tookAddressOf=%d\n", f, f.вТкст0(), f.isVirtual(), f.isThis(), f.tookAddressOf);

                /* Look to see if f escapes. We consider all parents of f within
                 * this, and also all siblings which call f; if any of them ýñêàïèðóé,
                 * so does f.
                 * Mark all affected functions as requiring closures.
                 */
                for (ДСимвол s = f; s && s != this; s = s.toParentP(this))
                {
                    FuncDeclaration fx = s.isFuncDeclaration();
                    if (!fx)
                        continue;
                    if (fx.isThis() || fx.tookAddressOf)
                    {
                        //printf("\t\tfx = %s, isVirtual=%d, isThis=%p, tookAddressOf=%d\n", fx.вТкст0(), fx.isVirtual(), fx.isThis(), fx.tookAddressOf);

                        /* Mark as needing closure any functions between this and f
                         */
                        markAsNeedingClosure((fx == f) ? fx.toParentP(this) : fx, this);

                        requiresClosure = да;
                    }

                    /* We also need to check if any sibling functions that
                     * called us, have escaped. This is recursive: we need
                     * to check the callers of our siblings.
                     */
                    if (checkEscapingSiblings(fx, this))
                        requiresClosure = да;

                    /* https://issues.dlang.org/show_bug.cgi?ид=12406
                     * Iterate all closureVars to mark all descendant
                     * nested functions that access to the closing context of this function.
                     */
                }
            }
        }
        if (requiresClosure)
            goto Lyes;

        return нет;

    Lyes:
        //printf("\tneeds closure\n");
        return да;
    }

    /***********************************************
     * Check that the function содержит any closure.
     * If it's , report suitable errors.
     * This is mostly consistent with FuncDeclaration::needsClosure().
     *
     * Возвращает:
     *      да if any errors occur.
     */
    extern (D) final бул checkClosure()
    {
        if (!needsClosure())
            return нет;

        if (setGC())
        {
            выведиОшибку("is `` yet allocates closures with the СМ");
            if (глоб2.gag)     // need not report supplemental errors
                return да;
        }
        else
        {
            printGCUsage(место, "using closure causes СМ allocation");
            return нет;
        }

        FuncDeclarations a;
        foreach (v; closureVars)
        {
            foreach (f; v.nestedrefs)
            {
                assert(f !is this);

            LcheckAncestorsOfANestedRef:
                for (ДСимвол s = f; s && s !is this; s = s.toParentP(this))
                {
                    auto fx = s.isFuncDeclaration();
                    if (!fx)
                        continue;
                    if (fx.isThis() ||
                        fx.tookAddressOf ||
                        checkEscapingSiblings(fx, this))
                    {
                        foreach (f2; a)
                        {
                            if (f2 == f)
                                break LcheckAncestorsOfANestedRef;
                        }
                        a.сунь(f);
                        .errorSupplemental(f.место, "%s closes over variable %s at %s",
                            f.toPrettyChars(), v.вТкст0(), v.место.вТкст0());
                        break LcheckAncestorsOfANestedRef;
                    }
                }
            }
        }

        return да;
    }

    /***********************************************
     * Determine if function's variables are referenced by a function
     * nested within it.
     */
    final бул hasNestedFrameRefs()
    {
        if (closureVars.dim)
            return да;

        /* If a virtual function has contracts, assume its variables are referenced
         * by those contracts, even if they aren't. Because they might be referenced
         * by the overridden or overriding function's contracts.
         * This can happen because frequire and fensure are implemented as nested functions,
         * and they can be called directly by an overriding function and the overriding function's
         * context had better match, or
         * https://issues.dlang.org/show_bug.cgi?ид=7335 will bite.
         */
        if (fdrequire || fdensure)
            return да;

        if (foverrides.dim && isVirtualMethod())
        {
            for (т_мера i = 0; i < foverrides.dim; i++)
            {
                FuncDeclaration fdv = foverrides[i];
                if (fdv.hasNestedFrameRefs())
                    return да;
            }
        }
        return нет;
    }

    /****************************************************
     * Check whether результат variable can be built.
     * Возвращает:
     *     `да` if the function has a return тип that
     *     is different from `проц`.
     */
    extern (D) private бул canBuildрезультатVar()
    {
        auto f = cast(TypeFunction)тип;
        return f && f.nextOf() && f.nextOf().toBasetype().ty != Tvoid;
    }

    /****************************************************
     * Declare результат variable lazily.
     */
    extern (D) final проц buildрезультатVar(Scope* sc, Тип tret)
    {
        if (!vрезультат)
        {
            Место место = fensure ? fensure.место : this.место;

            /* If inferRetType is да, tret may not be a correct return тип yet.
             * So, in here it may be a temporary тип for vрезультат, and after
             * fbody.dsymbolSemantic() running, vрезультат.тип might be modified.
             */
            vрезультат = new VarDeclaration(место, tret, Id.результат, null);
            vрезультат.класс_хранения |= STC.nodtor | STC.temp;
            if (!isVirtual())
                vрезультат.класс_хранения |= STC.const_;
            vрезультат.класс_хранения |= STC.результат;

            // set before the semantic() for checkNestedReference()
            vрезультат.родитель = this;
        }

        if (sc && vрезультат.semanticRun == PASS.init)
        {
            TypeFunction tf = тип.toTypeFunction();
            if (tf.isref)
                vрезультат.класс_хранения |= STC.ref_;
            vрезультат.тип = tret;

            vрезультат.dsymbolSemantic(sc);

            if (!sc.вставь(vрезультат))
                выведиОшибку("out результат %s is already defined", vрезультат.вТкст0());
            assert(vрезультат.родитель == this);
        }
    }

    /****************************************************
     * Merge into this function the 'in' contracts of all it overrides.
     * 'in's are OR'd together, i.e. only one of them needs to pass.
     */
    extern (D) final Инструкция2 mergeFrequire(Инструкция2 sf, Выражения* парамы)
    {
        /* If a base function and its override both have an IN contract, then
         * only one of them needs to succeed. This is done by generating:
         *
         * проц derived.in() {
         *  try {
         *    base.in();
         *  }
         *  catch () {
         *    ... body of derived.in() ...
         *  }
         * }
         *
         * So if base.in() doesn't throw, derived.in() need not be executed, and the contract is valid.
         * If base.in() throws, then derived.in()'s body is executed.
         */

        foreach (fdv; foverrides)
        {
            /* The semantic pass on the contracts of the overridden functions must
             * be completed before code generation occurs.
             * https://issues.dlang.org/show_bug.cgi?ид=3602
             */
            if (fdv.frequires && fdv.semanticRun != PASS.semantic3done)
            {
                assert(fdv._scope);
                Scope* sc = fdv._scope.сунь();
                sc.stc &= ~STC.override_;
                fdv.semantic3(sc);
                sc.вынь();
            }

            sf = fdv.mergeFrequire(sf, парамы);
            if (sf && fdv.fdrequire)
            {
                //printf("fdv.frequire: %s\n", fdv.frequire.вТкст0());
                /* Make the call:
                 *   try { __require(парамы); }
                 *   catch (Throwable) { frequire; }
                 */
                парамы = Выражение.arraySyntaxCopy(парамы);
                Выражение e = new CallExp(место, new VarExp(место, fdv.fdrequire, нет), парамы);
                Инструкция2 s2 = new ExpStatement(место, e);

                auto c = new Уловитель(место, getThrowable(), null, sf);
                c.internalCatch = да;
                auto catches = new Уловители();
                catches.сунь(c);
                sf = new TryCatchStatement(место, s2, catches);
            }
            else
                return null;
        }
        return sf;
    }

    /****************************************************
     * Determine whether an 'out' contract is declared inside
     * the given function or any of its overrides.
     * Параметры:
     *      fd = the function to search
     * Возвращает:
     *      да    found an 'out' contract
     */
    static бул needsFensure(FuncDeclaration fd)
    {
        if (fd.fensures)
            return да;

        foreach (fdv; fd.foverrides)
        {
            if (needsFensure(fdv))
                return да;
        }
        return нет;
    }

    /****************************************************
     * Rewrite contracts as statements.
     */
    final проц buildEnsureRequire()
    {

        if (frequires)
        {
            /*   in { statements1... }
             *   in { statements2... }
             *   ...
             * becomes:
             *   in { { statements1... } { statements2... } ... }
             */
            assert(frequires.dim);
            auto место = (*frequires)[0].место;
            auto s = new Инструкции;
            foreach (r; *frequires)
            {
                s.сунь(new ScopeStatement(r.место, r, r.место));
            }
            frequire = new CompoundStatement(место, s);
        }

        if (fensures)
        {
            /*   out(id1) { statements1... }
             *   out(id2) { statements2... }
             *   ...
             * becomes:
             *   out(__результат) { { ref id1 = __результат; { statements1... } }
             *                   { ref id2 = __результат; { statements2... } } ... }
             */
            assert(fensures.dim);
            auto место = (*fensures)[0].ensure.место;
            auto s = new Инструкции;
            foreach (r; *fensures)
            {
                if (r.ид && canBuildрезультатVar())
                {
                    auto rloc = r.ensure.место;
                    auto результатId = new IdentifierExp(rloc, Id.результат);
                    auto init = new ExpInitializer(rloc, результатId);
                    auto stc = STC.ref_ | STC.temp | STC.результат;
                    auto decl = new VarDeclaration(rloc, null, r.ид, init, stc);
                    auto sdecl = new ExpStatement(rloc, decl);
                    s.сунь(new ScopeStatement(rloc, new CompoundStatement(rloc, sdecl, r.ensure), rloc));
                }
                else
                {
                    s.сунь(r.ensure);
                }
            }
            fensure = new CompoundStatement(место, s);
        }

        if (!isVirtual())
            return;

        /* Rewrite contracts as nested functions, then call them. Doing it as nested
         * functions means that overriding functions can call them.
         */
        TypeFunction f = cast(TypeFunction) тип;

        /* Make a копируй of the parameters and make them all ref */
        static Параметры* toRefCopy(Параметры* парамы)
        {
            auto результат = new Параметры();

            цел toRefDg(т_мера n, Параметр2 p)
            {
                p = p.syntaxCopy();
                if (!(p.классХранения & STC.lazy_))
                    p.классХранения = (p.классХранения | STC.ref_) & ~STC.out_;
                p.defaultArg = null; // won't be the same with ref
                результат.сунь(p);
                return 0;
            }

            Параметр2._foreach(парамы, &toRefDg);
            return результат;
        }

        if (frequire)
        {
            /*   in { ... }
             * becomes:
             *   проц __require(ref парамы) { ... }
             *   __require(парамы);
             */
            Место место = frequire.место;
            fdrequireParams = new Выражения();
            if (parameters)
            {
                foreach (vd; *parameters)
                    fdrequireParams.сунь(new VarExp(место, vd));
            }
            auto fo = cast(TypeFunction)(originalType ? originalType : f);
            auto fparams = toRefCopy(fo.parameterList.parameters);
            auto tf = new TypeFunction(СписокПараметров(fparams), Тип.tvoid, LINK.d);
            tf.isnothrow = f.isnothrow;
            tf.isnogc = f.isnogc;
            tf.purity = f.purity;
            tf.trust = f.trust;
            auto fd = new FuncDeclaration(место, место, Id.require, STC.undefined_, tf);
            fd.fbody = frequire;
            Инструкция2 s1 = new ExpStatement(место, fd);
            Выражение e = new CallExp(место, new VarExp(место, fd, нет), fdrequireParams);
            Инструкция2 s2 = new ExpStatement(место, e);
            frequire = new CompoundStatement(место, s1, s2);
            fdrequire = fd;
        }

        /* We need to set fdensureParams here and not in the block below to
         * have the parameters доступно when calling a base class ensure(),
         * even if this function doesn't have an out contract.
         */
        fdensureParams = new Выражения();
        if (canBuildрезультатVar())
            fdensureParams.сунь(new IdentifierExp(место, Id.результат));
        if (parameters)
        {
            foreach (vd; *parameters)
                fdensureParams.сунь(new VarExp(место, vd));
        }

        if (fensure)
        {
            /*   out (результат) { ... }
             * becomes:
             *   проц __ensure(ref tret результат, ref парамы) { ... }
             *   __ensure(результат, парамы);
             */
            Место место = fensure.место;
            auto fparams = new Параметры();
            if (canBuildрезультатVar())
            {
                Параметр2 p = new Параметр2(STC.ref_ | STC.const_, f.nextOf(), Id.результат, null, null);
                fparams.сунь(p);
            }
            auto fo = cast(TypeFunction)(originalType ? originalType : f);
            fparams.суньСрез((*toRefCopy(fo.parameterList.parameters))[]);
            auto tf = new TypeFunction(СписокПараметров(fparams), Тип.tvoid, LINK.d);
            tf.isnothrow = f.isnothrow;
            tf.isnogc = f.isnogc;
            tf.purity = f.purity;
            tf.trust = f.trust;
            auto fd = new FuncDeclaration(место, место, Id.ensure, STC.undefined_, tf);
            fd.fbody = fensure;
            Инструкция2 s1 = new ExpStatement(место, fd);
            Выражение e = new CallExp(место, new VarExp(место, fd, нет), fdensureParams);
            Инструкция2 s2 = new ExpStatement(место, e);
            fensure = new CompoundStatement(место, s1, s2);
            fdensure = fd;
        }
    }

    /****************************************************
     * Merge into this function the 'out' contracts of all it overrides.
     * 'out's are AND'd together, i.e. all of them need to pass.
     */
    extern (D) final Инструкция2 mergeFensure(Инструкция2 sf, Идентификатор2 oid, Выражения* парамы)
    {
        /* Same comments as for mergeFrequire(), except that we take care
         * of generating a consistent reference to the 'результат' local by
         * explicitly passing 'результат' to the nested function as a reference
         * argument.
         * This won't work for the 'this' параметр as it would require changing
         * the semantic code for the nested function so that it looks on the параметр
         * list for the 'this' pointer, something that would need an unknown amount
         * of tweaking of various parts of the compiler that I'd rather leave alone.
         */
        foreach (fdv; foverrides)
        {
            /* The semantic pass on the contracts of the overridden functions must
             * be completed before code generation occurs.
             * https://issues.dlang.org/show_bug.cgi?ид=3602 and
             * https://issues.dlang.org/show_bug.cgi?ид=5230
             */
            if (needsFensure(fdv) && fdv.semanticRun != PASS.semantic3done)
            {
                assert(fdv._scope);
                Scope* sc = fdv._scope.сунь();
                sc.stc &= ~STC.override_;
                fdv.semantic3(sc);
                sc.вынь();
            }

            sf = fdv.mergeFensure(sf, oid, парамы);
            if (fdv.fdensure)
            {
                //printf("fdv.fensure: %s\n", fdv.fensure.вТкст0());
                // Make the call: __ensure(результат, парамы)
                парамы = Выражение.arraySyntaxCopy(парамы);
                if (canBuildрезультатVar())
                {
                    Тип t1 = fdv.тип.nextOf().toBasetype();
                    Тип t2 = this.тип.nextOf().toBasetype();
                    if (t1.isBaseOf(t2, null))
                    {
                        /* Making temporary reference variable is necessary
                         * in covariant return.
                         * https://issues.dlang.org/show_bug.cgi?ид=5204
                         * https://issues.dlang.org/show_bug.cgi?ид=10479
                         */
                        Выражение* eрезультат = &(*парамы)[0];
                        auto ei = new ExpInitializer(Место.initial, *eрезультат);
                        auto v = new VarDeclaration(Место.initial, t1, Идентификатор2.генерируйИд("__covres"), ei);
                        v.класс_хранения |= STC.temp;
                        auto de = new DeclarationExp(Место.initial, v);
                        auto ve = new VarExp(Место.initial, v);
                        *eрезультат = new CommaExp(Место.initial, de, ve);
                    }
                }
                Выражение e = new CallExp(место, new VarExp(место, fdv.fdensure, нет), парамы);
                Инструкция2 s2 = new ExpStatement(место, e);

                if (sf)
                {
                    sf = new CompoundStatement(sf.место, s2, sf);
                }
                else
                    sf = s2;
            }
        }
        return sf;
    }

    /*********************************************
     * Возвращает: the function's параметр list, and whether
     * it is variadic or not.
     */
    final СписокПараметров getParameterList()
    {
        if (тип)
        {
            TypeFunction fdtype = тип.isTypeFunction();
            return fdtype.parameterList;
        }

        return СписокПараметров(null, ВарАрг.none);
    }

    /**********************************
     * Generate a FuncDeclaration for a runtime library function.
     */
    static FuncDeclaration genCfunc(Параметры* fparams, Тип treturn, ткст0 имя, КлассХранения stc = 0)
    {
        return genCfunc(fparams, treturn, Идентификатор2.idPool(имя, cast(бцел)strlen(имя)), stc);
    }

    static FuncDeclaration genCfunc(Параметры* fparams, Тип treturn, Идентификатор2 ид, КлассХранения stc = 0)
    {
        FuncDeclaration fd;
        TypeFunction tf;
        ДСимвол s;
         DsymbolTable st = null;

        //printf("genCfunc(имя = '%s')\n", ид.вТкст0());
        //printf("treturn\n\t"); treturn.print();

        // See if already in table
        if (!st)
            st = new DsymbolTable();
        s = st.lookup(ид);
        if (s)
        {
            fd = s.isFuncDeclaration();
            assert(fd);
            assert(fd.тип.nextOf().равен(treturn));
        }
        else
        {
            tf = new TypeFunction(СписокПараметров(fparams), treturn, LINK.c, stc);
            fd = new FuncDeclaration(Место.initial, Место.initial, ид, STC.static_, tf);
            fd.защита = Prot(Prot.Kind.public_);
            fd.компонаж = LINK.c;

            st.вставь(fd);
        }
        return fd;
    }

    /******************
     * Check parameters and return тип of D main() function.
     * Issue error messages.
     */
    extern (D) final проц checkDmain()
    {
        TypeFunction tf = тип.toTypeFunction();
        const nparams = tf.parameterList.length;
        бул argerr;
        if (nparams == 1)
        {
            auto fparam0 = tf.parameterList[0];
            auto t = fparam0.тип.toBasetype();
            if (t.ty != Tarray ||
                t.nextOf().ty != Tarray ||
                t.nextOf().nextOf().ty != Tchar ||
                fparam0.классХранения & (STC.out_ | STC.ref_ | STC.lazy_))
            {
                argerr = да;
            }
        }

        if (!tf.nextOf())
            выведиОшибку("must return `цел` or `проц`");
        else if (tf.nextOf().ty != Tint32 && tf.nextOf().ty != Tvoid)
            выведиОшибку("must return `цел` or `проц`, not `%s`", tf.nextOf().вТкст0());
        else if (tf.parameterList.varargs || nparams >= 2 || argerr)
            выведиОшибку("parameters must be `main()` or `main(ткст[] args)`");
    }

    /***********************************************
     * Check all return statements for a function to verify that returning
     * using NRVO is possible.
     *
     * Возвращает:
     *      да if the результат cannot be returned by hidden reference.
     */
    final бул checkNrvo()
    {
        if (!nrvo_can)
            return да;

        if (returns is null)
            return да;

        auto tf = тип.toTypeFunction();

        foreach (rs; *returns)
        {
            if (rs.exp.op == ТОК2.variable)
            {
                auto ve = cast(VarExp)rs.exp;
                auto v = ve.var.isVarDeclaration();
                if (tf.isref)
                {
                    // Function returns a reference
                    return да;
                }
                else if (!v || v.isOut() || v.isRef())
                    return да;
                else if (nrvo_var is null)
                {
                    if (!v.isDataseg() && !v.isParameter() && v.toParent2() == this)
                    {
                        //printf("Setting nrvo to %s\n", v.вТкст0());
                        nrvo_var = v;
                    }
                    else
                        return да;
                }
                else if (nrvo_var != v)
                    return да;
            }
            else //if (!exp.isLvalue())    // keep NRVO-ability
                return да;
        }
        return нет;
    }

    override final FuncDeclaration isFuncDeclaration()
    {
        return this;
    }

    FuncDeclaration toAliasFunc()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/********************************************************
 * Generate Выражение to call the invariant.
 * Input:
 *      ad      aggregate with the invariant
 *      vthis   variable with 'this'
 * Возвращает:
 *      проц Выражение that calls the invariant
 */
Выражение addInvariant(ref Место место, Scope* sc, AggregateDeclaration ad, VarDeclaration vthis)
{
    Выражение e = null;
    // Call invariant directly only if it exists
    FuncDeclaration inv = ad.inv;
    ClassDeclaration cd = ad.isClassDeclaration();

    while (!inv && cd)
    {
        cd = cd.baseClass;
        if (!cd)
            break;
        inv = cd.inv;
    }
    if (inv)
    {
        version (all)
        {
            // Workaround for https://issues.dlang.org/show_bug.cgi?ид=13394
            // For the correct mangling,
            // run attribute inference on inv if needed.
            inv.functionSemantic();
        }

        //e = new DsymbolExp(Место.initial, inv);
        //e = new CallExp(Место.initial, e);
        //e = e.semantic(sc2);

        /* https://issues.dlang.org/show_bug.cgi?ид=13113
         * Currently virtual invariant calls completely
         * bypass attribute enforcement.
         * Change the behavior of pre-invariant call by following it.
         */
        e = new ThisExp(Место.initial);
        e.тип = ad.тип.addMod(vthis.тип.mod);
        e = new DotVarExp(Место.initial, e, inv, нет);
        e.тип = inv.тип;
        e = new CallExp(Место.initial, e);
        e.тип = Тип.tvoid;
    }
    return e;
}

/***************************************************
 * Visit each overloaded function/template in turn, and call dg(s) on it.
 * Exit when no more, or dg(s) returns nonzero.
 *
 * Параметры:
 *  fstart = symbol to start from
 *  dg = the delegate to be called on the overload
 *  sc = context используется to check if symbol is accessible (and therefore visible),
 *       can be null
 *
 * Возвращает:
 *      ==0     continue
 *      !=0     done (and the return значение from the last dg() call)
 */
extern (D) цел overloadApply(ДСимвол fstart, цел delegate(ДСимвол) dg, Scope* sc = null)
{
    ДСимвол следщ;
    for (auto d = fstart; d; d = следщ)
    {
        if (auto od = d.isOverDeclaration())
        {
            if (od.hasOverloads)
            {
                /* The scope is needed here to check whether a function in
                   an overload set was added by means of a private alias (or a
                   selective import). If the scope where the alias is created
                   is imported somewhere, the overload set is visible, but the private
                   alias is not.
                 */
                if (sc)
                {
                    if (checkSymbolAccess(sc, od))
                    {
                        if (цел r = overloadApply(od.aliassym, dg, sc))
                            return r;
                    }
                }
                else if (цел r = overloadApply(od.aliassym, dg, sc))
                    return r;
            }
            else
            {
                if (цел r = dg(od.aliassym))
                    return r;
            }
            следщ = od.overnext;
        }
        else if (auto fa = d.isFuncAliasDeclaration())
        {
            if (fa.hasOverloads)
            {
                if (цел r = overloadApply(fa.funcalias, dg, sc))
                    return r;
            }
            else if (auto fd = fa.toAliasFunc())
            {
                if (цел r = dg(fd))
                    return r;
            }
            else
            {
                d.выведиОшибку("is aliased to a function");
                break;
            }
            следщ = fa.overnext;
        }
        else if (auto ad = d.isAliasDeclaration())
        {
            if (sc)
            {
                if (checkSymbolAccess(sc, ad))
                    следщ = ad.toAlias();
            }
            else
               следщ = ad.toAlias();
            if (следщ == ad)
                break;
            if (следщ == fstart)
                break;
        }
        else if (auto td = d.isTemplateDeclaration())
        {
            if (цел r = dg(td))
                return r;
            следщ = td.overnext;
        }
        else if (auto fd = d.isFuncDeclaration())
        {
            if (цел r = dg(fd))
                return r;
            следщ = fd.overnext;
        }
        else
        {
            d.выведиОшибку("is aliased to a function");
            break;
            // BUG: should print error message?
        }
    }
    return 0;
}

/**
Checks for mismatching modifiers between `lhsMod` and `rhsMod` and prints the
mismatching modifiers to `буф`.

The modifiers of the `lhsMod` mismatching the ones with the `rhsMod` are printed, i.e.
lhs(shared) vs. rhs() prints "`shared`", wheras lhs() vs rhs(shared) prints "non-shared".

Параметры:
    буф = output буфер to пиши to
    lhsMod = modifier on the left-hand side
    lhsMod = modifier on the right-hand side

Возвращает:

A кортеж with `isMutable` and `isNotShared` set
if the `lhsMod` is missing those modifiers (compared to rhs).
*/
Mismatches MODMatchToBuffer(БуфВыв* буф, ббайт lhsMod, ббайт rhsMod)
{
    struct Mismatches
    {
        бул isNotShared;
        бул isMutable;
    }

    Mismatches mismatches;

    бул bothMutable = ((lhsMod & rhsMod) == 0);
    бул sharedMismatch = ((lhsMod ^ rhsMod) & MODFlags.shared_) != 0;
    бул sharedMismatchOnly = ((lhsMod ^ rhsMod) == MODFlags.shared_);

    if (lhsMod & MODFlags.shared_)
        буф.пишиСтр("`shared` ");
    else if (sharedMismatch && !(lhsMod & MODFlags.immutable_))
    {
        буф.пишиСтр("non-shared ");
        mismatches.isNotShared = да;
    }

    if (bothMutable && sharedMismatchOnly)
    {
    }
    else if (lhsMod & MODFlags.immutable_)
        буф.пишиСтр("`const` ");
    else if (lhsMod & MODFlags.const_)
        буф.пишиСтр("`const` ");
    else if (lhsMod & MODFlags.wild)
        буф.пишиСтр("`inout` ");
    else
    {
        буф.пишиСтр("mutable ");
        mismatches.isMutable = да;
    }

    return mismatches;
}

///
unittest
{
    БуфВыв буф;
    auto mismatches = MODMatchToBuffer(&буф, MODFlags.shared_, 0);
    assert(буф[] == "`shared` ");
    assert(!mismatches.isNotShared);

    буф.устРазм(0);
    mismatches = MODMatchToBuffer(&буф, 0, MODFlags.shared_);
    assert(буф[] == "non-shared ");
    assert(mismatches.isNotShared);

    буф.устРазм(0);
    mismatches = MODMatchToBuffer(&буф, MODFlags.const_, 0);
    assert(буф[] == "`const` ");
    assert(!mismatches.isMutable);

    буф.устРазм(0);
    mismatches = MODMatchToBuffer(&буф, 0, MODFlags.const_);
    assert(буф[] == "mutable ");
    assert(mismatches.isMutable);
}

private ткст0 prependSpace(ткст0 str)
{
    if (!str || !*str) return "";

    return (" " ~ str.вТкстД() ~ "\0").ptr;
}

/// Flag используется by $(LREF resolveFuncCall).
enum FuncResolveFlag : ббайт
{
    standard = 0,       /// issue error messages, solve the call.
    quiet = 1,          /// do not issue error message on no match, just return `null`.
    overloadOnly = 2,   /// only resolve overloads.
}

/*******************************************
 * Given a symbol that could be either a FuncDeclaration or
 * a function template, resolve it to a function symbol.
 * Параметры:
 *      место =           instantiation location
 *      sc =            instantiation scope
 *      s =             instantiation symbol
 *      tiargs =        initial list of template arguments
 *      tthis =         if !NULL, the `this` argument тип
 *      fargs =         arguments to function
 *      flags =         see $(LREF FuncResolveFlag).
 * Возвращает:
 *      if match is found, then function symbol, else null
 */
FuncDeclaration resolveFuncCall(ref Место место, Scope* sc, ДСимвол s,
    Объекты* tiargs, Тип tthis, Выражения* fargs, FuncResolveFlag flags)
{
    if (!s)
        return null; // no match

    version (none)
    {
        printf("resolveFuncCall('%s')\n", s.вТкст0());
        if (tthis)
            printf("\tthis: %s\n", tthis.вТкст0());
        if (fargs)
        {
            for (т_мера i = 0; i < fargs.dim; i++)
            {
                Выражение arg = (*fargs)[i];
                assert(arg.тип);
                printf("\t%s: ", arg.вТкст0());
                arg.тип.print();
            }
        }
    }

    if (tiargs && arrayObjectIsError(tiargs) ||
        fargs && arrayObjectIsError(cast(Объекты*)fargs))
    {
        return null;
    }

    MatchAccumulator m;
    functionResolve(m, s, место, sc, tiargs, tthis, fargs, null);
    auto orig_s = s;

    if (m.last > MATCH.nomatch && m.lastf)
    {
        if (m.count == 1) // exactly one match
        {
            if (!(flags & FuncResolveFlag.quiet))
                m.lastf.functionSemantic();
            return m.lastf;
        }
        if ((flags & FuncResolveFlag.overloadOnly) && !tthis && m.lastf.needThis())
        {
            return m.lastf;
        }
    }

    /* Failed to найди a best match.
     * Do nothing or print error.
     */
    if (m.last <= MATCH.nomatch)
    {
        // error was caused on matched function, not on the matching itself,
        // so return the function to produce a better diagnostic
        if (m.count == 1)
            return m.lastf;
    }

    // We are done at this point, as the rest of this function generate
    // a diagnostic on invalid match
    if (flags & FuncResolveFlag.quiet)
        return null;

    auto fd = s.isFuncDeclaration();
    auto od = s.isOverDeclaration();
    auto td = s.isTemplateDeclaration();
    if (td && td.funcroot)
        s = fd = td.funcroot;

    БуфВыв tiargsBuf;
    arrayObjectsToBuffer(&tiargsBuf, tiargs);

    БуфВыв fargsBuf;
    fargsBuf.пишиБайт('(');
    argExpTypesToCBuffer(&fargsBuf, fargs);
    fargsBuf.пишиБайт(')');
    if (tthis)
        tthis.modToBuffer(&fargsBuf);

    // The call is ambiguous
    if (m.lastf && m.nextf)
    {
        TypeFunction tf1 = m.lastf.тип.toTypeFunction();
        TypeFunction tf2 = m.nextf.тип.toTypeFunction();
        ткст0 lastprms = parametersTypeToChars(tf1.parameterList);
        ткст0 nextprms = parametersTypeToChars(tf2.parameterList);

        ткст0 mod1 = prependSpace(MODtoChars(tf1.mod));
        ткст0 mod2 = prependSpace(MODtoChars(tf2.mod));

        .выведиОшибку(место, "`%s.%s` called with argument types `%s` matches both:\n%s:     `%s%s%s`\nand:\n%s:     `%s%s%s`",
            s.родитель.toPrettyChars(), s.идент.вТкст0(),
            fargsBuf.peekChars(),
            m.lastf.место.вТкст0(), m.lastf.toPrettyChars(), lastprms, mod1,
            m.nextf.место.вТкст0(), m.nextf.toPrettyChars(), nextprms, mod2);
        return null;
    }

    // no match, generate an error messages
    if (!fd)
    {
        // all of overloads are templates
        if (td)
        {
            .выведиОшибку(место, "%s `%s.%s` cannot deduce function from argument types `!(%s)%s`, candidates are:",
                   td.вид(), td.родитель.toPrettyChars(), td.идент.вТкст0(),
                   tiargsBuf.peekChars(), fargsBuf.peekChars());

            printCandidates(место, td);
            return null;
        }
        /* This case happens when several ctors are mixed in an agregate.
           A (bad) error message is already generated in overloadApply().
           see https://issues.dlang.org/show_bug.cgi?ид=19729
        */
        if (!od)
            return null;
    }

    if (od)
    {
        .выведиОшибку(место, "none of the overloads of `%s` are callable using argument types `!(%s)%s`",
               od.идент.вТкст0(), tiargsBuf.peekChars(), fargsBuf.peekChars());
        return null;
    }

    // удали when deprecation period of class allocators and deallocators is over
    if (fd.isNewDeclaration() && fd.checkDisabled(место, sc))
        return null;

    бул hasOverloads = fd.overnext !is null;
    auto tf = fd.тип.toTypeFunction();
    if (tthis && !MODimplicitConv(tthis.mod, tf.mod)) // modifier mismatch
    {
        БуфВыв thisBuf, funcBuf;
        MODMatchToBuffer(&thisBuf, tthis.mod, tf.mod);
        auto mismatches = MODMatchToBuffer(&funcBuf, tf.mod, tthis.mod);
        if (hasOverloads)
        {
            .выведиОшибку(место, "none of the overloads of `%s` are callable using a %sobject, candidates are:",
                   fd.идент.вТкст0(), thisBuf.peekChars());
            printCandidates(место, fd);
            return null;
        }

        ткст0 failMessage;
        functionResolve(m, orig_s, место, sc, tiargs, tthis, fargs, &failMessage);
        if (failMessage)
        {
            .выведиОшибку(место, "%s `%s%s%s` is not callable using argument types `%s`",
                   fd.вид(), fd.toPrettyChars(), parametersTypeToChars(tf.parameterList),
                   tf.modToChars(), fargsBuf.peekChars());
            errorSupplemental(место, failMessage);
            return null;
        }

        auto fullFdPretty = fd.toPrettyChars();
        .выведиОшибку(место, "%smethod `%s` is not callable using a %sobject",
               funcBuf.peekChars(), fullFdPretty, thisBuf.peekChars());

        if (mismatches.isNotShared)
            .errorSupplemental(место, "Consider adding `shared` to %s", fullFdPretty);
        else if (mismatches.isMutable)
            .errorSupplemental(место, "Consider adding `const` or `inout` to %s", fullFdPretty);
        return null;
    }

    //printf("tf = %s, args = %s\n", tf.deco, (*fargs)[0].тип.deco);
    if (hasOverloads)
    {
        .выведиОшибку(место, "none of the overloads of `%s` are callable using argument types `%s`, candidates are:",
               fd.вТкст0(), fargsBuf.peekChars());
        printCandidates(место, fd);
        return null;
    }

    .выведиОшибку(место, "%s `%s%s%s` is not callable using argument types `%s`",
           fd.вид(), fd.toPrettyChars(), parametersTypeToChars(tf.parameterList),
           tf.modToChars(), fargsBuf.peekChars());
    // re-resolve to check for supplemental message
    ткст0 failMessage;
    functionResolve(m, orig_s, место, sc, tiargs, tthis, fargs, &failMessage);
    if (failMessage)
        errorSupplemental(место, failMessage);
    return null;
}

/*******************************************
 * Prints template and function overload candidates as supplemental errors.
 * Параметры:
 *      место =           instantiation location
 *      declaration =   the declaration to print overload candidates for
 */
private проц printCandidates(Decl)(ref Место место, Decl declaration){
if (is(Decl == TemplateDeclaration) || is(Decl == FuncDeclaration))
{
    // max num of overloads to print (-v overrides this).
    цел numToDisplay = 5;
    ткст0 constraintsTip;

    overloadApply(declaration, (ДСимвол s)
    {
        ДСимвол nextOverload;

        if (auto fd = s.isFuncDeclaration())
        {
            if (fd.errors || fd.тип.ty == Terror)
                return 0;

            auto tf = cast(TypeFunction) fd.тип;
            .errorSupplemental(fd.место, "`%s%s`", fd.toPrettyChars(),
                parametersTypeToChars(tf.parameterList));
            nextOverload = fd.overnext;
        }
        else if (auto td = s.isTemplateDeclaration())
        {
            const tmsg = td.toCharsNoConstraints();
            const cmsg = td.getConstraintEvalError(constraintsTip);
            if (cmsg)
                .errorSupplemental(td.место, "`%s`\n%s", tmsg, cmsg);
            else
                .errorSupplemental(td.место, "`%s`", tmsg);
            nextOverload = td.overnext;
        }

        if (глоб2.парамы.verbose || --numToDisplay != 0)
            return 0;

        // Too many overloads to sensibly display.
        // Just show count of remaining overloads.
        цел num = 0;
        overloadApply(nextOverload, (s) { ++num; return 0; });

        if (num > 0)
            .errorSupplemental(место, "... (%d more, -v to show) ...", num);
        return 1;   // stop iterating
    });
    // should be only in verbose mode
    if (constraintsTip)
        .tip(constraintsTip);
}
}

/**************************************
 * Возвращает an indirect тип one step from t.
 */
Тип getIndirection(Тип t)
{
    t = t.baseElemOf();
    if (t.ty == Tarray || t.ty == Tpointer)
        return t.nextOf().toBasetype();
    if (t.ty == Taarray || t.ty == Tclass)
        return t;
    if (t.ty == Tstruct)
        return t.hasPointers() ? t : null; // TODO

    // should consider TypeDelegate?
    return null;
}

/**************************************
 * Performs тип-based alias analysis between a newly created значение and a pre-
 * existing memory reference:
 *
 * Assuming that a reference A to a значение of тип `ta` was доступно to the code
 * that created a reference B to a значение of тип `tb`, it returns whether B
 * might alias memory reachable from A based on the types involved (either
 * directly or via any number of indirections in either A or B).
 *
 * This relation is not symmetric in the two arguments. For example, a
 * a `const(цел)` reference can point to a pre-existing `цел`, but not the other
 * way round.
 *
 * Examples:
 *
 *      ta,           tb,               результат
 *      `const(цел)`, `цел`,            `нет`
 *      `цел`,        `const(цел)`,     `да`
 *      `цел`,        `const(цел)`, `нет`
 *      const(const(цел)*), const(цел)*, нет   // BUG: returns да
 *
 * Параметры:
 *      ta = значение тип being referred to
 *      tb = referred to значение тип that could be constructed from ta
 *
 * Возвращает:
 *      да if reference to `tb` is isolated from reference to `ta`
 */
private бул traverseIndirections(Тип ta, Тип tb)
{
    //printf("traverseIndirections(%s, %s)\n", ta.вТкст0(), tb.вТкст0());

    /* Threaded list of aggregate types already examined,
     * используется to break cycles.
     * Cycles in тип graphs can only occur with aggregates.
     */
    struct Ctxt
    {
        Ctxt* prev;
        Тип тип;      // an aggregate тип
    }

    static бул traverse(Тип ta, Тип tb, Ctxt* ctxt, бул reversePass)
    {
        //printf("traverse(%s, %s)\n", ta.вТкст0(), tb.вТкст0());
        ta = ta.baseElemOf();
        tb = tb.baseElemOf();

        // First, check if the pointed-to types are convertible to each other such
        // that they might alias directly.
        static бул mayAliasDirect(Тип source, Тип target)
        {
            return
                // if source is the same as target or can be const-converted to target
                source.constConv(target) != MATCH.nomatch ||
                // if target is проц and source can be const-converted to target
                (target.ty == Tvoid && MODimplicitConv(source.mod, target.mod));
        }

        if (mayAliasDirect(reversePass ? tb : ta, reversePass ? ta : tb))
        {
            //printf(" да  mayalias %s %s %d\n", ta.вТкст0(), tb.вТкст0(), reversePass);
            return нет;
        }
        if (ta.nextOf() && ta.nextOf() == tb.nextOf())
        {
             //printf(" следщ==следщ %s %s %d\n", ta.вТкст0(), tb.вТкст0(), reversePass);
             return да;
        }

        if (tb.ty == Tclass || tb.ty == Tstruct)
        {
            for (Ctxt* c = ctxt; c; c = c.prev)
                if (tb == c.тип)
                    return да;
            Ctxt c;
            c.prev = ctxt;
            c.тип = tb;

            /* Traverse the тип of each field of the aggregate
             */
            AggregateDeclaration sym = tb.toDsymbol(null).isAggregateDeclaration();
            foreach (v; sym.fields)
            {
                Тип tprmi = v.тип.addMod(tb.mod);
                //printf("\ttb = %s, tprmi = %s\n", tb.вТкст0(), tprmi.вТкст0());
                if (!traverse(ta, tprmi, &c, reversePass))
                    return нет;
            }
        }
        else if (tb.ty == Tarray || tb.ty == Taarray || tb.ty == Tpointer)
        {
            Тип tind = tb.nextOf();
            if (!traverse(ta, tind, ctxt, reversePass))
                return нет;
        }
        else if (tb.hasPointers())
        {
            // BUG: consider the context pointer of delegate types
            return нет;
        }

        // Still no match, so try breaking up ta if we have not done so yet.
        if (!reversePass)
            return traverse(tb, ta, ctxt, да);

        return да;
    }

    // To handle arbitrary levels of indirections in both parameters, we
    // recursively descend into aggregate члены/levels of indirection in both
    // `ta` and `tb` while avoiding cycles. Start with the original types.
    const результат = traverse(ta, tb, null, нет);
    //printf("  returns %d\n", результат);
    return результат;
}

/* For all functions between outerFunc and f, mark them as needing
 * a closure.
 */
private проц markAsNeedingClosure(ДСимвол f, FuncDeclaration outerFunc)
{
    for (ДСимвол sx = f; sx && sx != outerFunc; sx = sx.toParentP(outerFunc))
    {
        FuncDeclaration fy = sx.isFuncDeclaration();
        if (fy && fy.closureVars.dim)
        {
            /* fy needs a closure if it has closureVars[],
             * because the frame pointer in the closure will be accessed.
             */
            fy.requiresClosure = да;
        }
    }
}

/********
 * Given a nested function f inside a function outerFunc, check
 * if any sibling callers of f have escaped. If so, mark
 * all the enclosing functions as needing closures.
 * This is recursive: we need to check the callers of our siblings.
 * Note that nested functions can only call lexically earlier nested
 * functions, so loops are impossible.
 * Параметры:
 *      f = inner function (nested within outerFunc)
 *      outerFunc = outer function
 *      p = for internal recursion use
 * Возвращает:
 *      да if any closures were needed
 */
private бул checkEscapingSiblings(FuncDeclaration f, FuncDeclaration outerFunc, ук p = null)
{
    struct PrevSibling
    {
        PrevSibling* p;
        FuncDeclaration f;
    }

    PrevSibling ps;
    ps.p = cast(PrevSibling*)p;
    ps.f = f;

    //printf("checkEscapingSiblings(f = %s, outerfunc = %s)\n", f.вТкст0(), outerFunc.вТкст0());
    бул bAnyClosures = нет;
    for (т_мера i = 0; i < f.siblingCallers.dim; ++i)
    {
        FuncDeclaration g = f.siblingCallers[i];
        if (g.isThis() || g.tookAddressOf)
        {
            markAsNeedingClosure(g, outerFunc);
            bAnyClosures = да;
        }

        for (auto родитель = g.toParentP(outerFunc); родитель && родитель !is outerFunc; родитель = родитель.toParentP(outerFunc))
        {
            // A родитель of the sibling had its address taken.
            // Assume escaping of родитель affects its children, so needs propagating.
            // see https://issues.dlang.org/show_bug.cgi?ид=19679
            FuncDeclaration parentFunc = родитель.isFuncDeclaration;
            if (parentFunc && parentFunc.tookAddressOf)
            {
                markAsNeedingClosure(parentFunc, outerFunc);
                bAnyClosures = да;
            }
        }

        PrevSibling* prev = cast(PrevSibling*)p;
        while (1)
        {
            if (!prev)
            {
                bAnyClosures |= checkEscapingSiblings(g, outerFunc, &ps);
                break;
            }
            if (prev.f == g)
                break;
            prev = prev.p;
        }
    }
    //printf("\t%d\n", bAnyClosures);
    return bAnyClosures;
}

/***********************************************************
 * Used as a way to import a set of functions from another scope into this one.
 */
 final class FuncAliasDeclaration : FuncDeclaration
{
    FuncDeclaration funcalias;
    бул hasOverloads;

    this(Идентификатор2 идент, FuncDeclaration funcalias, бул hasOverloads = да)
    {
        super(funcalias.место, funcalias.endloc, идент, funcalias.класс_хранения, funcalias.тип);
        assert(funcalias != this);
        this.funcalias = funcalias;

        this.hasOverloads = hasOverloads;
        if (hasOverloads)
        {
            if (FuncAliasDeclaration fad = funcalias.isFuncAliasDeclaration())
                this.hasOverloads = fad.hasOverloads;
        }
        else
        {
            // for internal use
            assert(!funcalias.isFuncAliasDeclaration());
            this.hasOverloads = нет;
        }
        userAttribDecl = funcalias.userAttribDecl;
    }

    override FuncAliasDeclaration isFuncAliasDeclaration()
    {
        return this;
    }

    override ткст0 вид()
    {
        return "function alias";
    }

    override FuncDeclaration toAliasFunc()
    {
        return funcalias.toAliasFunc();
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class FuncLiteralDeclaration : FuncDeclaration
{
    ТОК2 tok;        // ТОК2.function_ or ТОК2.delegate_
    Тип treq;      // target of return тип inference

    // backend
    бул deferToObj;

    this(ref Место место, ref Место endloc, Тип тип, ТОК2 tok, ForeachStatement fes, Идентификатор2 ид = null)
    {
        super(место, endloc, null, STC.undefined_, тип);
        this.идент = ид ? ид : Id.empty;
        this.tok = tok;
        this.fes = fes;
        // Always infer scope for function literals
        // See https://issues.dlang.org/show_bug.cgi?ид=20362
        this.flags |= FUNCFLAG.inferScope;
        //printf("FuncLiteralDeclaration() ид = '%s', тип = '%s'\n", this.идент.вТкст0(), тип.вТкст0());
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        //printf("FuncLiteralDeclaration::syntaxCopy('%s')\n", вТкст0());
        assert(!s);
        auto f = new FuncLiteralDeclaration(место, endloc, тип.syntaxCopy(), tok, fes, идент);
        f.treq = treq; // don't need to копируй
        return FuncDeclaration.syntaxCopy(f);
    }

    override бул isNested()
    {
        //printf("FuncLiteralDeclaration::isNested() '%s'\n", вТкст0());
        return (tok != ТОК2.function_) && !isThis();
    }

    override AggregateDeclaration isThis()
    {
        return tok == ТОК2.delegate_ ? super.isThis() : null;
    }

    override бул isVirtual()
    {
        return нет;
    }

    override бул addPreInvariant()
    {
        return нет;
    }

    override бул addPostInvariant()
    {
        return нет;
    }

    /*******************************
     * Modify all Выражение тип of return statements to tret.
     *
     * On function literals, return тип may be modified based on the context тип
     * after its semantic3 is done, in FuncExp::implicitCastTo.
     *
     *  A function() dg = (){ return new B(); } // OK if is(B : A) == да
     *
     * If B to A conversion is convariant that requires offseet adjusting,
     * all return statements should be adjusted to return Выражения typed A.
     */
    проц modifyReturns(Scope* sc, Тип tret)
    {
         final class RetWalker : StatementRewriteWalker
        {
            alias  typeof(super).посети посети ;
        public:
            Scope* sc;
            Тип tret;
            FuncLiteralDeclaration fld;

            override проц посети(ReturnStatement s)
            {
                Выражение exp = s.exp;
                if (exp && !exp.тип.равен(tret))
                {
                    s.exp = exp.castTo(sc, tret);
                }
            }
        }

        if (semanticRun < PASS.semantic3done)
            return;

        if (fes)
            return;

        scope RetWalker w = new RetWalker();
        w.sc = sc;
        w.tret = tret;
        w.fld = this;
        fbody.прими(w);

        // Also update the inferred function тип to match the new return тип.
        // This is required so the code generator does not try to cast the
        // modified returns back to the original тип.
        if (inferRetType && тип.nextOf() != tret)
            тип.toTypeFunction().следщ = tret;
    }

    override FuncLiteralDeclaration isFuncLiteralDeclaration()
    {
        return this;
    }

    override ткст0 вид()
    {
        // GCC requires the (сим*) casts
        return (tok != ТОК2.function_) ? "delegate" : "function";
    }

    override ткст0 toPrettyChars(бул QualifyTypes = нет)
    {
        if (родитель)
        {
            TemplateInstance ti = родитель.isTemplateInstance();
            if (ti)
                return ti.tempdecl.toPrettyChars(QualifyTypes);
        }
        return ДСимвол.toPrettyChars(QualifyTypes);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class CtorDeclaration : FuncDeclaration
{
    бул isCpCtor;
    this(ref Место место, ref Место endloc, КлассХранения stc, Тип тип, бул isCpCtor = нет)
    {
        super(место, endloc, Id.ctor, stc, тип);
        this.isCpCtor = isCpCtor;
        //printf("CtorDeclaration(место = %s) %s\n", место.вТкст0(), вТкст0());
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        auto f = new CtorDeclaration(место, endloc, класс_хранения, тип.syntaxCopy());
        return FuncDeclaration.syntaxCopy(f);
    }

    override ткст0 вид()
    {
        return isCpCtor ? "копируй constructor" : "constructor";
    }

    override ткст0 вТкст0()
    {
        return "this";
    }

    override бул isVirtual()
    {
        return нет;
    }

    override бул addPreInvariant()
    {
        return нет;
    }

    override бул addPostInvariant()
    {
        return (isThis() && vthis && глоб2.парамы.useInvariants == CHECKENABLE.on);
    }

    override CtorDeclaration isCtorDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class PostBlitDeclaration : FuncDeclaration
{
    this(ref Место место, ref Место endloc, КлассХранения stc, Идентификатор2 ид)
    {
        super(место, endloc, ид, stc, null);
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        auto dd = new PostBlitDeclaration(место, endloc, класс_хранения, идент);
        return FuncDeclaration.syntaxCopy(dd);
    }

    override бул isVirtual()
    {
        return нет;
    }

    override бул addPreInvariant()
    {
        return нет;
    }

    override бул addPostInvariant()
    {
        return (isThis() && vthis && глоб2.парамы.useInvariants == CHECKENABLE.on);
    }

    override бул overloadInsert(ДСимвол s)
    {
        return нет; // cannot overload postblits
    }

    override PostBlitDeclaration isPostBlitDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class DtorDeclaration : FuncDeclaration
{
    this(ref Место место, ref Место endloc)
    {
        super(место, endloc, Id.dtor, STC.undefined_, null);
    }

    this(ref Место место, ref Место endloc, КлассХранения stc, Идентификатор2 ид)
    {
        super(место, endloc, ид, stc, null);
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        auto dd = new DtorDeclaration(место, endloc, класс_хранения, идент);
        return FuncDeclaration.syntaxCopy(dd);
    }

    override ткст0 вид()
    {
        return "destructor";
    }

    override ткст0 вТкст0()
    {
        return "~this";
    }

    override бул isVirtual()
    {
        // D dtor's don't get put into the vtbl[]
        // this is a hack so that /*extern(C++)*/ destructors report as virtual, which are manually added to the vtable
        return vtblIndex != -1;
    }

    override бул addPreInvariant()
    {
        return (isThis() && vthis && глоб2.парамы.useInvariants == CHECKENABLE.on);
    }

    override бул addPostInvariant()
    {
        return нет;
    }

    override бул overloadInsert(ДСимвол s)
    {
        return нет; // cannot overload destructors
    }

    override DtorDeclaration isDtorDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 class StaticCtorDeclaration : FuncDeclaration
{
    this(ref Место место, ref Место endloc, КлассХранения stc)
    {
        super(место, endloc, Идентификатор2.generateIdWithLoc("_staticCtor", место), STC.static_ | stc, null);
    }

    this(ref Место место, ref Место endloc, ткст имя, КлассХранения stc)
    {
        super(место, endloc, Идентификатор2.generateIdWithLoc(имя, место), STC.static_ | stc, null);
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        auto scd = new StaticCtorDeclaration(место, endloc, класс_хранения);
        return FuncDeclaration.syntaxCopy(scd);
    }

    override final AggregateDeclaration isThis()
    {
        return null;
    }

    override final бул isVirtual()
    {
        return нет;
    }

    override final бул addPreInvariant()
    {
        return нет;
    }

    override final бул addPostInvariant()
    {
        return нет;
    }

    override final бул hasStaticCtorOrDtor()
    {
        return да;
    }

    override final StaticCtorDeclaration isStaticCtorDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class SharedStaticCtorDeclaration : StaticCtorDeclaration
{
    this(ref Место место, ref Место endloc, КлассХранения stc)
    {
        super(место, endloc, "_sharedStaticCtor", stc);
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        auto scd = new SharedStaticCtorDeclaration(место, endloc, класс_хранения);
        return FuncDeclaration.syntaxCopy(scd);
    }

    override SharedStaticCtorDeclaration isSharedStaticCtorDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 class StaticDtorDeclaration : FuncDeclaration
{
    VarDeclaration vgate; // 'gate' variable

    this(ref Место место, ref Место endloc, КлассХранения stc)
    {
        super(место, endloc, Идентификатор2.generateIdWithLoc("_staticDtor", место), STC.static_ | stc, null);
    }

    this(ref Место место, ref Место endloc, ткст имя, КлассХранения stc)
    {
        super(место, endloc, Идентификатор2.generateIdWithLoc(имя, место), STC.static_ | stc, null);
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        auto sdd = new StaticDtorDeclaration(место, endloc, класс_хранения);
        return FuncDeclaration.syntaxCopy(sdd);
    }

    override final AggregateDeclaration isThis()
    {
        return null;
    }

    override final бул isVirtual()
    {
        return нет;
    }

    override final бул hasStaticCtorOrDtor()
    {
        return да;
    }

    override final бул addPreInvariant()
    {
        return нет;
    }

    override final бул addPostInvariant()
    {
        return нет;
    }

    override final StaticDtorDeclaration isStaticDtorDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class SharedStaticDtorDeclaration : StaticDtorDeclaration
{
    this(ref Место место, ref Место endloc, КлассХранения stc)
    {
        super(место, endloc, "_sharedStaticDtor", stc);
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        auto sdd = new SharedStaticDtorDeclaration(место, endloc, класс_хранения);
        return FuncDeclaration.syntaxCopy(sdd);
    }

    override SharedStaticDtorDeclaration isSharedStaticDtorDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class InvariantDeclaration : FuncDeclaration
{
    this(ref Место место, ref Место endloc, КлассХранения stc, Идентификатор2 ид, Инструкция2 fbody)
    {
        super(место, endloc, ид ? ид : Идентификатор2.генерируйИд("__invariant"), stc, null);
        this.fbody = fbody;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        auto ид = new InvariantDeclaration(место, endloc, класс_хранения, null, null);
        return FuncDeclaration.syntaxCopy(ид);
    }

    override бул isVirtual()
    {
        return нет;
    }

    override бул addPreInvariant()
    {
        return нет;
    }

    override бул addPostInvariant()
    {
        return нет;
    }

    override InvariantDeclaration isInvariantDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}


/***********************************************************
 */
 final class UnitTestDeclaration : FuncDeclaration
{
    ткст0 codedoc;      // for documented unittest

    // toObjFile() these nested functions after this one
    FuncDeclarations deferredNested;

    this(ref Место место, ref Место endloc, КлассХранения stc, ткст0 codedoc)
    {
        super(место, endloc, Идентификатор2.generateIdWithLoc("__unittest", место), stc, null);
        this.codedoc = codedoc;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        auto utd = new UnitTestDeclaration(место, endloc, класс_хранения, codedoc);
        return FuncDeclaration.syntaxCopy(utd);
    }

    override AggregateDeclaration isThis()
    {
        return null;
    }

    override бул isVirtual()
    {
        return нет;
    }

    override бул addPreInvariant()
    {
        return нет;
    }

    override бул addPostInvariant()
    {
        return нет;
    }

    override UnitTestDeclaration isUnitTestDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class NewDeclaration : FuncDeclaration
{
    Параметры* parameters;
    ВарАрг varargs;

    this(ref Место место, ref Место endloc, КлассХранения stc, Параметры* fparams, ВарАрг varargs)
    {
        super(место, endloc, Id.classNew, STC.static_ | stc, null);
        this.parameters = fparams;
        this.varargs = varargs;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        assert(!s);
        auto f = new NewDeclaration(место, endloc, класс_хранения, Параметр2.arraySyntaxCopy(parameters), varargs);
        return FuncDeclaration.syntaxCopy(f);
    }

    override ткст0 вид()
    {
        return "allocator";
    }

    override бул isVirtual()
    {
        return нет;
    }

    override бул addPreInvariant()
    {
        return нет;
    }

    override бул addPostInvariant()
    {
        return нет;
    }

    override NewDeclaration isNewDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}
