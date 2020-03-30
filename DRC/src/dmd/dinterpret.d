/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/dinterpret.d, _dinterpret.d)
 * Documentation:  https://dlang.org/phobos/dmd_dinterpret.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/dinterpret.d
 */

module dmd.dinterpret;

import cidrus;
import dmd.apply;
import dmd.arraytypes;
import dmd.attrib;
import dmd.builtin;
import dmd.constfold;
import dmd.ctfeexpr;
import dmd.dclass;
import dmd.declaration;
import dmd.dstruct;
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
import dmd.init;
import dmd.initsem;
import dmd.mtype;
import util.rmem;
import util.array;
import util.region;
import drc.ast.Node;
import dmd.инструкция;
import drc.lexer.Tokens;
import util.utf;
import drc.ast.Visitor;

/*************************************
 * Entry point for CTFE.
 * A compile-time результат is required. Give an error if not possible.
 *
 * `e` must be semantically valid Выражение. In other words, it should not
 * contain any `ErrorExp`s in it. But, CTFE interpretation will cross over
 * functions and may invoke a function that содержит `ErrorStatement` in its body.
 * If that, the "CTFE failed because of previous errors" error is raised.
 */
public Выражение ctfeInterpret(Выражение e)
{
    switch (e.op)
    {
        case ТОК2.int64:
        case ТОК2.float64:
        case ТОК2.complex80:
        case ТОК2.null_:
        case ТОК2.void_:
        case ТОК2.string_:
        case ТОК2.this_:
        case ТОК2.super_:
        case ТОК2.тип:
        case ТОК2.typeid_:
             if (e.тип.ty == Terror)
                return new ErrorExp();
            goto case ТОК2.error;

        case ТОК2.error:
            return e;

        default:
            break;
    }

    assert(e.тип); // https://issues.dlang.org/show_bug.cgi?ид=14642
    //assert(e.тип.ty != Terror);    // FIXME
    if (e.тип.ty == Terror)
        return new ErrorExp();

    auto rgnpos = ctfeGlobals.region.savePos();

    Выражение результат = interpret(e, null);

    результат = copyRegionExp(результат);

    if (!CTFEExp.isCantExp(результат))
        результат = scrubReturnValue(e.место, результат);
    if (CTFEExp.isCantExp(результат))
        результат = new ErrorExp();

    ctfeGlobals.region.release(rgnpos);

    return результат;
}

/* Run CTFE on the Выражение, but allow the Выражение to be a TypeExp
 *  or a кортеж containing a TypeExp. (This is required by pragma(msg)).
 */
public Выражение ctfeInterpretForPragmaMsg(Выражение e)
{
    if (e.op == ТОК2.error || e.op == ТОК2.тип)
        return e;

    // It's also OK for it to be a function declaration (happens only with
    // __traits(getOverloads))
    if (auto ve = e.isVarExp())
        if (ve.var.isFuncDeclaration())
        {
            return e;
        }

    auto tup = e.isTupleExp();
    if (!tup)
        return e.ctfeInterpret();

    // Tuples need to be treated separately, since they are
    // allowed to contain a TypeExp in this case.

    Выражения* expsx = null;
    foreach (i, g; *tup.exps)
    {
        auto h = ctfeInterpretForPragmaMsg(g);
        if (h != g)
        {
            if (!expsx)
            {
                expsx = tup.exps.копируй();
            }
            (*expsx)[i] = h;
        }
    }
    if (expsx)
    {
        auto te = new TupleExp(e.место, expsx);
        expandTuples(te.exps);
        te.тип = new КортежТипов(te.exps);
        return te;
    }
    return e;
}

public  Выражение дайЗначение(VarDeclaration vd)
{
    return ctfeGlobals.stack.дайЗначение(vd);
}

/*************************************************
 * Allocate an Выражение in the ctfe region.
 * Параметры:
 *      T = тип of Выражение to размести
 *      args = arguments to Выражение's constructor
 * Возвращает:
 *      allocated Выражение
 */
T ctfeEmplaceExp(T : Выражение, Args...)(Args args)
{
    if (mem.смИниц_ли)
        return new T(args);
    auto p = ctfeGlobals.region.malloc(__traits(classInstanceSize, T));
    emplaceExp!(T)(p, args);
    return cast(T)p;
}

// CTFE diagnostic information
public  проц printCtfePerformanceStats()
{
    debug (SHOWPERFORMANCE)
    {
        printf("        ---- CTFE Performance ----\n");
        printf("max call depth = %d\tmax stack = %d\n", ctfeGlobals.maxCallDepth, ctfeGlobals.stack.maxStackUsage());
        printf("массив allocs = %d\tassignments = %d\n\n", ctfeGlobals.numArrayAllocs, ctfeGlobals.numAssignments);
    }
}

/**************************
 */

проц incArrayAllocs()
{
    ++ctfeGlobals.numArrayAllocs;
}

/* ================================================ Implementation ======================================= */

private:

/***************
 * Collect together globals используется by CTFE
 */
struct CtfeGlobals
{
    Регион region;

    CtfeStack stack;

    цел callDepth = 0;        // current number of recursive calls

    // When printing a stack trace, suppress this number of calls
    цел stackTraceCallsToSuppress = 0;

    цел maxCallDepth = 0;     // highest number of recursive calls
    цел numArrayAllocs = 0;   // Number of allocated arrays
    цел numAssignments = 0;   // total number of assignments executed
}

 CtfeGlobals ctfeGlobals;

enum CtfeGoal : цел
{
    ctfeNeedRvalue,     // Must return an Rvalue (== CTFE значение)
    ctfeNeedLvalue,     // Must return an Lvalue (== CTFE reference)
    ctfeNeedNothing,    // The return значение is not required
}

alias  CtfeGoal.ctfeNeedRvalue ctfeNeedRvalue;
alias  CtfeGoal.ctfeNeedLvalue ctfeNeedLvalue;
alias  CtfeGoal.ctfeNeedNothing ctfeNeedNothing;

//debug = LOG;
//debug = LOGASSIGN;
//debug = LOGCOMPILE;
//debug = SHOWPERFORMANCE;

// Maximum allowable recursive function calls in CTFE
const CTFE_RECURSION_LIMIT = 1000;

/**
 The values of all CTFE variables
 */
struct CtfeStack
{
private:
    /* The stack. Every declaration we encounter is pushed here,
     * together with the VarDeclaration, and the previous
     * stack address of that variable, so that we can restore it
     * when we leave the stack frame.
     * Note that when a function is forward referenced, the interpreter must
     * run semantic3, and that may start CTFE again with a NULL istate. Thus
     * the stack might not be empty when CTFE begins.
     *
     * Ctfe Stack addresses are just 0-based integers, but we save
     * them as 'проц *' because МассивДРК can only do pointers.
     */
    Выражения values;         // values on the stack
    VarDeclarations vars;       // corresponding variables
    МассивДРК!(ук) savedId;      // ид of the previous state of that var

    МассивДРК!(ук) frames;       // all previous frame pointers
    Выражения savedThis;      // all previous values of localThis

    /* Global constants get saved here after evaluation, so we never
     * have to redo them. This saves a lot of time and memory.
     */
    Выражения globalValues;   // values of глоб2 constants

    т_мера framepointer;        // current frame pointer
    т_мера maxStackPointer;     // most stack we've ever используется
    Выражение localThis;       // значение of 'this', or NULL if none

public:
     т_мера stackPointer()
    {
        return values.dim;
    }

    // The current значение of 'this', or NULL if none
     Выражение getThis()
    {
        return localThis;
    }

    // Largest number of stack positions we've используется
     т_мера maxStackUsage()
    {
        return maxStackPointer;
    }

    // Start a new stack frame, using the provided 'this'.
     проц startFrame(Выражение thisexp)
    {
        frames.сунь(cast(ук)cast(т_мера)framepointer);
        savedThis.сунь(localThis);
        framepointer = stackPointer();
        localThis = thisexp;
    }

     проц endFrame()
    {
        т_мера oldframe = cast(т_мера)frames[frames.dim - 1];
        localThis = savedThis[savedThis.dim - 1];
        popAll(framepointer);
        framepointer = oldframe;
        frames.устДим(frames.dim - 1);
        savedThis.устДим(savedThis.dim - 1);
    }

     бул isInCurrentFrame(VarDeclaration v)
    {
        if (v.isDataseg() && !v.isCTFE())
            return нет; // It's a глоб2
        return v.ctfeAdrOnStack >= framepointer;
    }

     Выражение дайЗначение(VarDeclaration v)
    {
        if ((v.isDataseg() || v.класс_хранения & STC.manifest) && !v.isCTFE())
        {
            assert(v.ctfeAdrOnStack < globalValues.dim);
            return globalValues[v.ctfeAdrOnStack];
        }
        assert(v.ctfeAdrOnStack < stackPointer());
        return values[v.ctfeAdrOnStack];
    }

     проц setValue(VarDeclaration v, Выражение e)
    {
        assert(!v.isDataseg() || v.isCTFE());
        assert(v.ctfeAdrOnStack < stackPointer());
        values[v.ctfeAdrOnStack] = e;
    }

     проц сунь(VarDeclaration v)
    {
        assert(!v.isDataseg() || v.isCTFE());
        if (v.ctfeAdrOnStack != VarDeclaration.AdrOnStackNone && v.ctfeAdrOnStack >= framepointer)
        {
            // Already exists in this frame, reuse it.
            values[v.ctfeAdrOnStack] = null;
            return;
        }
        savedId.сунь(cast(ук)cast(т_мера)v.ctfeAdrOnStack);
        v.ctfeAdrOnStack = cast(бцел)values.dim;
        vars.сунь(v);
        values.сунь(null);
    }

     проц вынь(VarDeclaration v)
    {
        assert(!v.isDataseg() || v.isCTFE());
        assert(!(v.класс_хранения & (STC.ref_ | STC.out_)));
        const oldid = v.ctfeAdrOnStack;
        v.ctfeAdrOnStack = cast(бцел)cast(т_мера)savedId[oldid];
        if (v.ctfeAdrOnStack == values.dim - 1)
        {
            values.вынь();
            vars.вынь();
            savedId.вынь();
        }
    }

     проц popAll(т_мера stackpointer)
    {
        if (stackPointer() > maxStackPointer)
            maxStackPointer = stackPointer();
        assert(values.dim >= stackpointer);
        for (т_мера i = stackpointer; i < values.dim; ++i)
        {
            VarDeclaration v = vars[i];
            v.ctfeAdrOnStack = cast(бцел)cast(т_мера)savedId[i];
        }
        values.устДим(stackpointer);
        vars.устДим(stackpointer);
        savedId.устДим(stackpointer);
    }

     проц saveGlobalConstant(VarDeclaration v, Выражение e)
    {
        assert(v._иниц && (v.isConst() || v.isImmutable() || v.класс_хранения & STC.manifest) && !v.isCTFE());
        v.ctfeAdrOnStack = cast(бцел)globalValues.dim;
        globalValues.сунь(copyRegionExp(e));
    }
}

private struct InterState
{
    InterState* caller;     // calling function's InterState
    FuncDeclaration fd;     // function being interpreted
    Инструкция2 start;        // if !=NULL, start execution at this инструкция

    /* target of CTFEExp результат; also
     * target of labelled CTFEExp or
     * CTFEExp. (null if no label).
     */
    Инструкция2 gotoTarget;
}

/*************************************
 * Attempt to interpret a function given the arguments.
 * Параметры:
 *      pue       = storage for результат
 *      fd        = function being called
 *      istate    = state for calling function (NULL if none)
 *      arguments = function arguments
 *      thisarg   = 'this', if a needThis() function, NULL if not.
 *
 * Возвращает:
 * результат Выражение if successful, ТОК2.cantВыражение if not,
 * or CTFEExp if function returned проц.
 */
private Выражение interpretFunction(UnionExp* pue, FuncDeclaration fd, InterState* istate, Выражения* arguments, Выражение thisarg)
{
    debug (LOG)
    {
        printf("\n********\n%s FuncDeclaration::interpret(istate = %p) %s\n", fd.место.вТкст0(), istate, fd.вТкст0());
    }
    assert(pue);
    if (fd.semanticRun == PASS.semantic3)
    {
        fd.выведиОшибку("circular dependency. Functions cannot be interpreted while being compiled");
        return CTFEExp.cantexp;
    }
    if (!fd.functionSemantic3())
        return CTFEExp.cantexp;
    if (fd.semanticRun < PASS.semantic3done)
        return CTFEExp.cantexp;

    Тип tb = fd.тип.toBasetype();
    assert(tb.ty == Tfunction);
    TypeFunction tf = cast(TypeFunction)tb;
    if (tf.parameterList.varargs != ВарАрг.none && arguments &&
        ((fd.parameters && arguments.dim != fd.parameters.dim) || (!fd.parameters && arguments.dim)))
    {
        fd.выведиОшибку("C-style variadic functions are not yet implemented in CTFE");
        return CTFEExp.cantexp;
    }

    // Nested functions always inherit the 'this' pointer from the родитель,
    // except for delegates. (Note that the 'this' pointer may be null).
    // Func literals report isNested() even if they are in глоб2 scope,
    // so we need to check that the родитель is a function.
    if (fd.isNested() && fd.toParentLocal().isFuncDeclaration() && !thisarg && istate)
        thisarg = ctfeGlobals.stack.getThis();

    if (fd.needThis() && !thisarg)
    {
        // error, no this. Prevent segfault.
        // Here should be unreachable by the strict 'this' check in front-end.
        fd.выведиОшибку("need `this` to access member `%s`", fd.вТкст0());
        return CTFEExp.cantexp;
    }

    // Place to hold all the arguments to the function while
    // we are evaluating them.
    т_мера dim = arguments ? arguments.dim : 0;
    assert((fd.parameters ? fd.parameters.dim : 0) == dim);

    /* Evaluate all the arguments to the function,
     * store the результатs in eargs[]
     */
    Выражения eargs = Выражения(dim);
    for (т_мера i = 0; i < dim; i++)
    {
        Выражение earg = (*arguments)[i];
        Параметр2 fparam = tf.parameterList[i];

        if (fparam.классХранения & (STC.out_ | STC.ref_))
        {
            if (!istate && (fparam.классХранения & STC.out_))
            {
                // initializing an out параметр involves writing to it.
                earg.выведиОшибку("глоб2 `%s` cannot be passed as an `out` параметр at compile time", earg.вТкст0());
                return CTFEExp.cantexp;
            }
            // Convert all reference arguments into lvalue references
            earg = interpretRegion(earg, istate, ctfeNeedLvalue);
            if (CTFEExp.isCantExp(earg))
                return earg;
        }
        else if (fparam.классХранения & STC.lazy_)
        {
        }
        else
        {
            /* Значение parameters
             */
            Тип ta = fparam.тип.toBasetype();
            if (ta.ty == Tsarray)
                if (auto eaddr = earg.isAddrExp())
                {
                    /* Static arrays are passed by a simple pointer.
                     * Skip past this to get at the actual arg.
                     */
                    earg = eaddr.e1;
                }

            earg = interpretRegion(earg, istate);
            if (CTFEExp.isCantExp(earg))
                return earg;

            /* Struct literals are passed by значение, but we don't need to
             * копируй them if they are passed as const
             */
            if (earg.op == ТОК2.structLiteral && !(fparam.классХранения & (STC.const_ | STC.immutable_)))
                earg = copyLiteral(earg).копируй();
        }
        if (earg.op == ТОК2.thrownException)
        {
            if (istate)
                return earg;
            (cast(ThrownExceptionExp)earg).generateUncaughtError();
            return CTFEExp.cantexp;
        }
        eargs[i] = earg;
    }

    // Now that we've evaluated all the arguments, we can start the frame
    // (this is the moment when the 'call' actually takes place).
    InterState istatex;
    istatex.caller = istate;
    istatex.fd = fd;

    if (fd.isThis2)
    {
        Выражение arg0 = thisarg;
        if (arg0 && arg0.тип.ty == Tstruct)
        {
            Тип t = arg0.тип.pointerTo();
            arg0 = ctfeEmplaceExp!(AddrExp)(arg0.место, arg0);
            arg0.тип = t;
        }
        auto elements = new Выражения(2);
        (*elements)[0] = arg0;
        (*elements)[1] = ctfeGlobals.stack.getThis();
        Тип t2 = Тип.tvoidptr.sarrayOf(2);
        const место = thisarg ? thisarg.место : fd.место;
        thisarg = ctfeEmplaceExp!(ArrayLiteralExp)(место, t2, elements);
        thisarg = ctfeEmplaceExp!(AddrExp)(место, thisarg);
        thisarg.тип = t2.pointerTo();
    }

    ctfeGlobals.stack.startFrame(thisarg);
    if (fd.vthis && thisarg)
    {
        ctfeGlobals.stack.сунь(fd.vthis);
        setValue(fd.vthis, thisarg);
    }

    for (т_мера i = 0; i < dim; i++)
    {
        Выражение earg = eargs[i];
        Параметр2 fparam = tf.parameterList[i];
        VarDeclaration v = (*fd.parameters)[i];
        debug (LOG)
        {
            printf("arg[%d] = %s\n", i, earg.вТкст0());
        }
        ctfeGlobals.stack.сунь(v);

        if ((fparam.классХранения & (STC.out_ | STC.ref_)) && earg.op == ТОК2.variable &&
            (cast(VarExp)earg).var.toParent2() == fd)
        {
            VarDeclaration vx = (cast(VarExp)earg).var.isVarDeclaration();
            if (!vx)
            {
                fd.выведиОшибку("cannot interpret `%s` as a `ref` параметр", earg.вТкст0());
                return CTFEExp.cantexp;
            }

            /* vx is a variable that is declared in fd.
             * It means that fd is recursively called. e.g.
             *
             *  проц fd(цел n, ref цел v = dummy) {
             *      цел vx;
             *      if (n == 1) fd(2, vx);
             *  }
             *  fd(1);
             *
             * The old значение of vx on the stack in fd(1)
             * should be saved at the start of fd(2, vx) call.
             */
            const oldadr = vx.ctfeAdrOnStack;

            ctfeGlobals.stack.сунь(vx);
            assert(!hasValue(vx)); // vx is made uninitialized

            // https://issues.dlang.org/show_bug.cgi?ид=14299
            // v.ctfeAdrOnStack should be saved already
            // in the stack before the overwrite.
            v.ctfeAdrOnStack = oldadr;
            assert(hasValue(v)); // ref параметр v should refer existing значение.
        }
        else
        {
            // Значение parameters and non-trivial references
            setValueWithoutChecking(v, earg);
        }
        debug (LOG)
        {
            printf("interpreted arg[%d] = %s\n", i, earg.вТкст0());
            showCtfeExpr(earg);
        }
        debug (LOGASSIGN)
        {
            printf("interpreted arg[%d] = %s\n", i, earg.вТкст0());
            showCtfeExpr(earg);
        }
    }

    if (fd.vрезультат)
        ctfeGlobals.stack.сунь(fd.vрезультат);

    // Enter the function
    ++ctfeGlobals.callDepth;
    if (ctfeGlobals.callDepth > ctfeGlobals.maxCallDepth)
        ctfeGlobals.maxCallDepth = ctfeGlobals.callDepth;

    Выражение e = null;
    while (1)
    {
        if (ctfeGlobals.callDepth > CTFE_RECURSION_LIMIT)
        {
            // This is a compiler error. It must not be suppressed.
            глоб2.gag = 0;
            fd.выведиОшибку("CTFE recursion limit exceeded");
            e = CTFEExp.cantexp;
            break;
        }
        e = interpret(pue, fd.fbody, &istatex);
        if (CTFEExp.isCantExp(e))
        {
            debug (LOG)
            {
                printf("function body failed to interpret\n");
            }
        }

        if (istatex.start)
        {
            fd.выведиОшибку("CTFE internal error: failed to resume at инструкция `%s`", istatex.start.вТкст0());
            return CTFEExp.cantexp;
        }

        /* This is how we deal with a recursive инструкция AST
         * that has arbitrary goto statements in it.
         * Bubble up a 'результат' which is the target of the goto
         * инструкция, then go recursively down the AST looking
         * for that инструкция, then execute starting there.
         */
        if (CTFEExp.isGotoExp(e))
        {
            istatex.start = istatex.gotoTarget; // set starting инструкция
            istatex.gotoTarget = null;
        }
        else
        {
            assert(!e || (e.op != ТОК2.continue_ && e.op != ТОК2.break_));
            break;
        }
    }
    // If fell off the end of a проц function, return проц
    if (!e && tf.следщ.ty == Tvoid)
        e = CTFEExp.voidexp;
    if (tf.isref && e.op == ТОК2.variable && (cast(VarExp)e).var == fd.vthis)
        e = thisarg;
    if (tf.isref && fd.isThis2 && e.op == ТОК2.index)
    {
        auto ie = cast(IndexExp)e;
        auto pe = ie.e1.isPtrExp();
        auto ve = !pe ?  null : pe.e1.isVarExp();
        if (ve && ve.var == fd.vthis)
        {
            auto ne = ie.e2.isIntegerExp();
            assert(ne);
            assert(thisarg.op == ТОК2.address);
            e = (cast(AddrExp)thisarg).e1;
            e = (*(cast(ArrayLiteralExp)e).elements)[cast(т_мера)ne.getInteger()];
            if (e.op == ТОК2.address)
            {
                e = (cast(AddrExp)e).e1;
            }
        }
    }
    assert(e !is null);

    // Leave the function
    --ctfeGlobals.callDepth;

    ctfeGlobals.stack.endFrame();

    // If it generated an uncaught exception, report error.
    if (!istate && e.op == ТОК2.thrownException)
    {
        if (e == pue.exp())
            e = pue.копируй();
        (cast(ThrownExceptionExp)e).generateUncaughtError();
        e = CTFEExp.cantexp;
    }

    return e;
}

private  final class Interpreter : Визитор2
{
    alias Визитор2.посети посети;
public:
    InterState* istate;
    CtfeGoal goal;
    Выражение результат;
    UnionExp* pue;              // storage for `результат`

    this(UnionExp* pue, InterState* istate, CtfeGoal goal)
    {
        this.pue = pue;
        this.istate = istate;
        this.goal = goal;
    }

    // If e is ТОК2.throw_exception or ТОК2.cantВыражение,
    // set it to 'результат' and returns да.
    бул exceptionOrCant(Выражение e)
    {
        if (exceptionOrCantInterpret(e))
        {
            // Make sure e is not pointing to a stack temporary
            результат = (e.op == ТОК2.cantВыражение) ? CTFEExp.cantexp : e;
            return да;
        }
        return нет;
    }

    static Выражения* copyArrayOnWrite(Выражения* exps, Выражения* original)
    {
        if (exps is original)
        {
            if (!original)
                exps = new Выражения();
            else
                exps = original.копируй();
            ++ctfeGlobals.numArrayAllocs;
        }
        return exps;
    }

    /******************************** Инструкция2 ***************************/

    override проц посети(Инструкция2 s)
    {
        debug (LOG)
        {
            printf("%s Инструкция2::interpret()\n", s.место.вТкст0());
        }
        if (istate.start)
        {
            if (istate.start != s)
                return;
            istate.start = null;
        }

        s.выведиОшибку("инструкция `%s` cannot be interpreted at compile time", s.вТкст0());
        результат = CTFEExp.cantexp;
    }

    override проц посети(ExpStatement s)
    {
        debug (LOG)
        {
            printf("%s ExpStatement::interpret(%s)\n", s.место.вТкст0(), s.exp ? s.exp.вТкст0() : "");
        }
        if (istate.start)
        {
            if (istate.start != s)
                return;
            istate.start = null;
        }

        Выражение e = interpret(pue, s.exp, istate, ctfeNeedNothing);
        if (exceptionOrCant(e))
            return;
    }

    override проц посети(CompoundStatement s)
    {
        debug (LOG)
        {
            printf("%s CompoundStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start == s)
            istate.start = null;

        const dim = s.statements ? s.statements.dim : 0;
        foreach (i; new бцел[0 .. dim])
        {
            Инструкция2 sx = (*s.statements)[i];
            результат = interpret(pue, sx, istate);
            if (результат)
                break;
        }
        debug (LOG)
        {
            printf("%s -CompoundStatement::interpret() %p\n", s.место.вТкст0(), результат);
        }
    }

    override проц посети(UnrolledLoopStatement s)
    {
        debug (LOG)
        {
            printf("%s UnrolledLoopStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start == s)
            istate.start = null;

        const dim = s.statements ? s.statements.dim : 0;
        foreach (i; new бцел[0 .. dim])
        {
            Инструкция2 sx = (*s.statements)[i];
            Выражение e = interpret(pue, sx, istate);
            if (!e) // succeeds to interpret, or goto target was not found
                continue;
            if (exceptionOrCant(e))
                return;
            if (e.op == ТОК2.break_)
            {
                if (istate.gotoTarget && istate.gotoTarget != s)
                {
                    результат = e; // break at a higher уровень
                    return;
                }
                istate.gotoTarget = null;
                результат = null;
                return;
            }
            if (e.op == ТОК2.continue_)
            {
                if (istate.gotoTarget && istate.gotoTarget != s)
                {
                    результат = e; // continue at a higher уровень
                    return;
                }
                istate.gotoTarget = null;
                continue;
            }

            // Выражение from return инструкция, or thrown exception
            результат = e;
            break;
        }
    }

    override проц посети(IfStatement s)
    {
        debug (LOG)
        {
            printf("%s IfStatement::interpret(%s)\n", s.место.вТкст0(), s.условие.вТкст0());
        }
        if (istate.start == s)
            istate.start = null;
        if (istate.start)
        {
            Выражение e = null;
            e = interpret(s.ifbody, istate);
            if (!e && istate.start)
                e = interpret(s.elsebody, istate);
            результат = e;
            return;
        }

        UnionExp ue = проц;
        Выражение e = interpret(&ue, s.условие, istate);
        assert(e);
        if (exceptionOrCant(e))
            return;

        if (isTrueBool(e))
            результат = interpret(pue, s.ifbody, istate);
        else if (e.isBool(нет))
            результат = interpret(pue, s.elsebody, istate);
        else
        {
            // no error, or assert(0)?
            результат = CTFEExp.cantexp;
        }
    }

    override проц посети(ScopeStatement s)
    {
        debug (LOG)
        {
            printf("%s ScopeStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start == s)
            istate.start = null;

        результат = interpret(pue, s.инструкция, istate);
    }

    /**
     Given an Выражение e which is about to be returned from the current
     function, generate an error if it содержит pointers to local variables.

     Only checks Выражения passed by значение (pointers to local variables
     may already be stored in члены of classes, arrays, or AAs which
     were passed as mutable function parameters).
     Возвращает:
        да if it is safe to return, нет if an error was generated.
     */
    static бул stopPointersEscaping(ref Место место, Выражение e)
    {
        if (!e.тип.hasPointers())
            return да;
        if (isPointer(e.тип))
        {
            Выражение x = e;
            if (auto eaddr = e.isAddrExp())
                x = eaddr.e1;
            VarDeclaration v;
            while (x.op == ТОК2.variable && (v = (cast(VarExp)x).var.isVarDeclaration()) !is null)
            {
                if (v.класс_хранения & STC.ref_)
                {
                    x = дайЗначение(v);
                    if (auto eaddr = e.isAddrExp())
                        eaddr.e1 = x;
                    continue;
                }
                if (ctfeGlobals.stack.isInCurrentFrame(v))
                {
                    выведиОшибку(место, "returning a pointer to a local stack variable");
                    return нет;
                }
                else
                    break;
            }
            // TODO: If it is a ТОК2.dotVariable or ТОК2.index, we should check that it is not
            // pointing to a local struct or static массив.
        }
        if (auto se = e.isStructLiteralExp())
        {
            return stopPointersEscapingFromArray(место, se.elements);
        }
        if (auto ale = e.isArrayLiteralExp())
        {
            return stopPointersEscapingFromArray(место, ale.elements);
        }
        if (auto aae = e.isAssocArrayLiteralExp())
        {
            if (!stopPointersEscapingFromArray(место, aae.keys))
                return нет;
            return stopPointersEscapingFromArray(место, aae.values);
        }
        return да;
    }

    // Check all elements of an массив for escaping local variables. Return нет if error
    static бул stopPointersEscapingFromArray(ref Место место, Выражения* elems)
    {
        foreach (e; *elems)
        {
            if (e && !stopPointersEscaping(место, e))
                return нет;
        }
        return да;
    }

    override проц посети(ReturnStatement s)
    {
        debug (LOG)
        {
            printf("%s ReturnStatement::interpret(%s)\n", s.место.вТкст0(), s.exp ? s.exp.вТкст0() : "");
        }
        if (istate.start)
        {
            if (istate.start != s)
                return;
            istate.start = null;
        }

        if (!s.exp)
        {
            результат = CTFEExp.voidexp;
            return;
        }

        assert(istate && istate.fd && istate.fd.тип && istate.fd.тип.ty == Tfunction);
        TypeFunction tf = cast(TypeFunction)istate.fd.тип;

        /* If the function returns a ref AND it's been called from an assignment,
         * we need to return an lvalue. Otherwise, just do an (rvalue) interpret.
         */
        if (tf.isref)
        {
            результат = interpret(pue, s.exp, istate, ctfeNeedLvalue);
            return;
        }
        if (tf.следщ && tf.следщ.ty == Tdelegate && istate.fd.closureVars.dim > 0)
        {
            // To support this, we need to копируй all the closure vars
            // into the delegate literal.
            s.выведиОшибку("closures are not yet supported in CTFE");
            результат = CTFEExp.cantexp;
            return;
        }

        // We need to treat pointers specially, because ТОК2.symbolOffset can be используется to
        // return a значение OR a pointer
        Выражение e = interpret(pue, s.exp, istate);
        if (exceptionOrCant(e))
            return;

        // Disallow returning pointers to stack-allocated variables (bug 7876)
        if (!stopPointersEscaping(s.место, e))
        {
            результат = CTFEExp.cantexp;
            return;
        }

        if (needToCopyLiteral(e))
            e = copyLiteral(e).копируй();
        debug (LOGASSIGN)
        {
            printf("RETURN %s\n", s.место.вТкст0());
            showCtfeExpr(e);
        }
        результат = e;
    }

    static Инструкция2 findGotoTarget(InterState* istate, Идентификатор2 идент)
    {
        Инструкция2 target = null;
        if (идент)
        {
            LabelDsymbol label = istate.fd.searchLabel(идент);
            assert(label && label.инструкция);
            LabelStatement ls = label.инструкция;
            target = ls.gotoTarget ? ls.gotoTarget : ls.инструкция;
        }
        return target;
    }

    override проц посети(BreakStatement s)
    {
        debug (LOG)
        {
            printf("%s BreakStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start)
        {
            if (istate.start != s)
                return;
            istate.start = null;
        }

        istate.gotoTarget = findGotoTarget(istate, s.идент);
        результат = CTFEExp.breakexp;
    }

    override проц посети(ContinueStatement s)
    {
        debug (LOG)
        {
            printf("%s ContinueStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start)
        {
            if (istate.start != s)
                return;
            istate.start = null;
        }

        istate.gotoTarget = findGotoTarget(istate, s.идент);
        результат = CTFEExp.continueexp;
    }

    override проц посети(WhileStatement s)
    {
        debug (LOG)
        {
            printf("WhileStatement::interpret()\n");
        }
        assert(0); // rewritten to ForStatement
    }

    override проц посети(DoStatement s)
    {
        debug (LOG)
        {
            printf("%s DoStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start == s)
            istate.start = null;

        while (1)
        {
            Выражение e = interpret(s._body, istate);
            if (!e && istate.start) // goto target was not found
                return;
            assert(!istate.start);

            if (exceptionOrCant(e))
                return;
            if (e && e.op == ТОК2.break_)
            {
                if (istate.gotoTarget && istate.gotoTarget != s)
                {
                    результат = e; // break at a higher уровень
                    return;
                }
                istate.gotoTarget = null;
                break;
            }
            if (e && e.op == ТОК2.continue_)
            {
                if (istate.gotoTarget && istate.gotoTarget != s)
                {
                    результат = e; // continue at a higher уровень
                    return;
                }
                istate.gotoTarget = null;
                e = null;
            }
            if (e)
            {
                результат = e; // bubbled up from ReturnStatement
                return;
            }

            UnionExp ue = проц;
            e = interpret(&ue, s.условие, istate);
            if (exceptionOrCant(e))
                return;
            if (!e.isConst())
            {
                результат = CTFEExp.cantexp;
                return;
            }
            if (e.isBool(нет))
                break;
            assert(isTrueBool(e));
        }
        assert(результат is null);
    }

    override проц посети(ForStatement s)
    {
        debug (LOG)
        {
            printf("%s ForStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start == s)
            istate.start = null;

        UnionExp ueinit = проц;
        Выражение ei = interpret(&ueinit, s._иниц, istate);
        if (exceptionOrCant(ei))
            return;
        assert(!ei); // s.init never returns from function, or jumps out from it

        while (1)
        {
            if (s.условие && !istate.start)
            {
                UnionExp ue = проц;
                Выражение e = interpret(&ue, s.условие, istate);
                if (exceptionOrCant(e))
                    return;
                if (e.isBool(нет))
                    break;
                assert(isTrueBool(e));
            }

            Выражение e = interpret(pue, s._body, istate);
            if (!e && istate.start) // goto target was not found
                return;
            assert(!istate.start);

            if (exceptionOrCant(e))
                return;
            if (e && e.op == ТОК2.break_)
            {
                if (istate.gotoTarget && istate.gotoTarget != s)
                {
                    результат = e; // break at a higher уровень
                    return;
                }
                istate.gotoTarget = null;
                break;
            }
            if (e && e.op == ТОК2.continue_)
            {
                if (istate.gotoTarget && istate.gotoTarget != s)
                {
                    результат = e; // continue at a higher уровень
                    return;
                }
                istate.gotoTarget = null;
                e = null;
            }
            if (e)
            {
                результат = e; // bubbled up from ReturnStatement
                return;
            }

            UnionExp uei = проц;
            e = interpret(&uei, s.increment, istate, ctfeNeedNothing);
            if (exceptionOrCant(e))
                return;
        }
        assert(результат is null);
    }

    override проц посети(ForeachStatement s)
    {
        assert(0); // rewritten to ForStatement
    }

    override проц посети(ForeachRangeStatement s)
    {
        assert(0); // rewritten to ForStatement
    }

    override проц посети(SwitchStatement s)
    {
        debug (LOG)
        {
            printf("%s SwitchStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start == s)
            istate.start = null;
        if (istate.start)
        {
            Выражение e = interpret(s._body, istate);
            if (istate.start) // goto target was not found
                return;
            if (exceptionOrCant(e))
                return;
            if (e && e.op == ТОК2.break_)
            {
                if (istate.gotoTarget && istate.gotoTarget != s)
                {
                    результат = e; // break at a higher уровень
                    return;
                }
                istate.gotoTarget = null;
                e = null;
            }
            результат = e;
            return;
        }

        UnionExp uecond = проц;
        Выражение econdition = interpret(&uecond, s.условие, istate);
        if (exceptionOrCant(econdition))
            return;

        Инструкция2 scase = null;
        if (s.cases)
            foreach (cs; *s.cases)
            {
                UnionExp uecase = проц;
                Выражение ecase = interpret(&uecase, cs.exp, istate);
                if (exceptionOrCant(ecase))
                    return;
                if (ctfeEqual(cs.exp.место, ТОК2.equal, econdition, ecase))
                {
                    scase = cs;
                    break;
                }
            }
        if (!scase)
        {
            if (s.hasNoDefault)
                s.выведиОшибку("no `default` or `case` for `%s` in `switch` инструкция", econdition.вТкст0());
            scase = s.sdefault;
        }

        assert(scase);

        /* Jump to scase
         */
        istate.start = scase;
        Выражение e = interpret(pue, s._body, istate);
        assert(!istate.start); // jump must not fail
        if (e && e.op == ТОК2.break_)
        {
            if (istate.gotoTarget && istate.gotoTarget != s)
            {
                результат = e; // break at a higher уровень
                return;
            }
            istate.gotoTarget = null;
            e = null;
        }
        результат = e;
    }

    override проц посети(CaseStatement s)
    {
        debug (LOG)
        {
            printf("%s CaseStatement::interpret(%s) this = %p\n", s.место.вТкст0(), s.exp.вТкст0(), s);
        }
        if (istate.start == s)
            istate.start = null;

        результат = interpret(pue, s.инструкция, istate);
    }

    override проц посети(DefaultStatement s)
    {
        debug (LOG)
        {
            printf("%s DefaultStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start == s)
            istate.start = null;

        результат = interpret(pue, s.инструкция, istate);
    }

    override проц посети(GotoStatement s)
    {
        debug (LOG)
        {
            printf("%s GotoStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start)
        {
            if (istate.start != s)
                return;
            istate.start = null;
        }

        assert(s.label && s.label.инструкция);
        istate.gotoTarget = s.label.инструкция;
        результат = CTFEExp.gotoexp;
    }

    override проц посети(GotoCaseStatement s)
    {
        debug (LOG)
        {
            printf("%s GotoCaseStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start)
        {
            if (istate.start != s)
                return;
            istate.start = null;
        }

        assert(s.cs);
        istate.gotoTarget = s.cs;
        результат = CTFEExp.gotoexp;
    }

    override проц посети(GotoDefaultStatement s)
    {
        debug (LOG)
        {
            printf("%s GotoDefaultStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start)
        {
            if (istate.start != s)
                return;
            istate.start = null;
        }

        assert(s.sw && s.sw.sdefault);
        istate.gotoTarget = s.sw.sdefault;
        результат = CTFEExp.gotoexp;
    }

    override проц посети(LabelStatement s)
    {
        debug (LOG)
        {
            printf("%s LabelStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start == s)
            istate.start = null;

        результат = interpret(pue, s.инструкция, istate);
    }

    override проц посети(TryCatchStatement s)
    {
        debug (LOG)
        {
            printf("%s TryCatchStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start == s)
            istate.start = null;
        if (istate.start)
        {
            Выражение e = null;
            e = interpret(pue, s._body, istate);
            foreach (ca; *s.catches)
            {
                if (e || !istate.start) // goto target was found
                    break;
                e = interpret(pue, ca.handler, istate);
            }
            результат = e;
            return;
        }

        Выражение e = interpret(s._body, istate);

        // An exception was thrown
        if (e && e.op == ТОК2.thrownException)
        {
            ThrownExceptionExp ex = cast(ThrownExceptionExp)e;
            Тип extype = ex.thrown.originalClass().тип;

            // Search for an appropriate catch clause.
            foreach (ca; *s.catches)
            {
                Тип catype = ca.тип;
                if (!catype.равен(extype) && !catype.isBaseOf(extype, null))
                    continue;

                // Execute the handler
                if (ca.var)
                {
                    ctfeGlobals.stack.сунь(ca.var);
                    setValue(ca.var, ex.thrown);
                }
                e = interpret(ca.handler, istate);
                if (CTFEExp.isGotoExp(e))
                {
                    /* This is an optimization that relies on the locality of the jump target.
                     * If the label is in the same catch handler, the following scan
                     * would найди it quickly and can reduce jump cost.
                     * Otherwise, the catch block may be unnnecessary scanned again
                     * so it would make CTFE speed slower.
                     */
                    InterState istatex = *istate;
                    istatex.start = istate.gotoTarget; // set starting инструкция
                    istatex.gotoTarget = null;
                    Выражение eh = interpret(ca.handler, &istatex);
                    if (!istatex.start)
                    {
                        istate.gotoTarget = null;
                        e = eh;
                    }
                }
                break;
            }
        }
        результат = e;
    }

    static бул isAnErrorException(ClassDeclaration cd)
    {
        return cd == ClassDeclaration.errorException || ClassDeclaration.errorException.isBaseOf(cd, null);
    }

    static ThrownExceptionExp chainExceptions(ThrownExceptionExp oldest, ThrownExceptionExp newest)
    {
        debug (LOG)
        {
            printf("Collided exceptions %s %s\n", oldest.thrown.вТкст0(), newest.thrown.вТкст0());
        }
        // Little sanity check to make sure it's really a Throwable
        ClassReferenceExp boss = oldest.thrown;
        const следщ = 4;                         // index of Throwable.следщ
        assert((*boss.значение.elements)[следщ].тип.ty == Tclass); // Throwable.следщ
        ClassReferenceExp collateral = newest.thrown;
        if (isAnErrorException(collateral.originalClass()) && !isAnErrorException(boss.originalClass()))
        {
            /* Find the index of the Error.bypassException field
             */
            auto bypass = следщ + 1;
            if ((*collateral.значение.elements)[bypass].тип.ty == Tuns32)
                bypass += 1;  // skip over _refcount field
            assert((*collateral.значение.elements)[bypass].тип.ty == Tclass);

            // The new exception bypass the existing chain
            (*collateral.значение.elements)[bypass] = boss;
            return newest;
        }
        while ((*boss.значение.elements)[следщ].op == ТОК2.classReference)
        {
            boss = cast(ClassReferenceExp)(*boss.значение.elements)[следщ];
        }
        (*boss.значение.elements)[следщ] = collateral;
        return oldest;
    }

    override проц посети(TryFinallyStatement s)
    {
        debug (LOG)
        {
            printf("%s TryFinallyStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start == s)
            istate.start = null;
        if (istate.start)
        {
            Выражение e = null;
            e = interpret(pue, s._body, istate);
            // Jump into/out from finalbody is disabled in semantic analysis.
            // and jump inside will be handled by the ScopeStatement == finalbody.
            результат = e;
            return;
        }

        Выражение ex = interpret(s._body, istate);
        if (CTFEExp.isCantExp(ex))
        {
            результат = ex;
            return;
        }
        while (CTFEExp.isGotoExp(ex))
        {
            // If the goto target is within the body, we must not interpret the finally инструкция,
            // because that will call destructors for objects within the scope, which we should not do.
            InterState istatex = *istate;
            istatex.start = istate.gotoTarget; // set starting инструкция
            istatex.gotoTarget = null;
            Выражение bex = interpret(s._body, &istatex);
            if (istatex.start)
            {
                // The goto target is outside the current scope.
                break;
            }
            // The goto target was within the body.
            if (CTFEExp.isCantExp(bex))
            {
                результат = bex;
                return;
            }
            *istate = istatex;
            ex = bex;
        }

        Выражение ey = interpret(s.finalbody, istate);
        if (CTFEExp.isCantExp(ey))
        {
            результат = ey;
            return;
        }
        if (ey && ey.op == ТОК2.thrownException)
        {
            // Check for collided exceptions
            if (ex && ex.op == ТОК2.thrownException)
                ex = chainExceptions(cast(ThrownExceptionExp)ex, cast(ThrownExceptionExp)ey);
            else
                ex = ey;
        }
        результат = ex;
    }

    override проц посети(ThrowStatement s)
    {
        debug (LOG)
        {
            printf("%s ThrowStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start)
        {
            if (istate.start != s)
                return;
            istate.start = null;
        }

        Выражение e = interpretRegion(s.exp, istate);
        if (exceptionOrCant(e))
            return;

        assert(e.op == ТОК2.classReference);
        результат = ctfeEmplaceExp!(ThrownExceptionExp)(s.место, e.isClassReferenceExp());
    }

    override проц посети(ScopeGuardStatement s)
    {
        assert(0);
    }

    override проц посети(WithStatement s)
    {
        debug (LOG)
        {
            printf("%s WithStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start == s)
            istate.start = null;
        if (istate.start)
        {
            результат = s._body ? interpret(s._body, istate) : null;
            return;
        }

        // If it is with(Enum) {...}, just execute the body.
        if (s.exp.op == ТОК2.scope_ || s.exp.op == ТОК2.тип)
        {
            результат = interpret(pue, s._body, istate);
            return;
        }

        Выражение e = interpret(s.exp, istate);
        if (exceptionOrCant(e))
            return;

        if (s.wthis.тип.ty == Tpointer && s.exp.тип.ty != Tpointer)
        {
            e = ctfeEmplaceExp!(AddrExp)(s.место, e, s.wthis.тип);
        }
        ctfeGlobals.stack.сунь(s.wthis);
        setValue(s.wthis, e);
        e = interpret(s._body, istate);
        if (CTFEExp.isGotoExp(e))
        {
            /* This is an optimization that relies on the locality of the jump target.
             * If the label is in the same WithStatement, the following scan
             * would найди it quickly and can reduce jump cost.
             * Otherwise, the инструкция body may be unnnecessary scanned again
             * so it would make CTFE speed slower.
             */
            InterState istatex = *istate;
            istatex.start = istate.gotoTarget; // set starting инструкция
            istatex.gotoTarget = null;
            Выражение ex = interpret(s._body, &istatex);
            if (!istatex.start)
            {
                istate.gotoTarget = null;
                e = ex;
            }
        }
        ctfeGlobals.stack.вынь(s.wthis);
        результат = e;
    }

    override проц посети(AsmStatement s)
    {
        debug (LOG)
        {
            printf("%s AsmStatement::interpret()\n", s.место.вТкст0());
        }
        if (istate.start)
        {
            if (istate.start != s)
                return;
            istate.start = null;
        }
        s.выведиОшибку("`asm` statements cannot be interpreted at compile time");
        результат = CTFEExp.cantexp;
    }

    override проц посети(ImportStatement s)
    {
        debug (LOG)
        {
            printf("ImportStatement::interpret()\n");
        }
        if (istate.start)
        {
            if (istate.start != s)
                return;
            istate.start = null;
        }
    }

    /******************************** Выражение ***************************/

    override проц посети(Выражение e)
    {
        debug (LOG)
        {
            printf("%s Выражение::interpret() '%s' %s\n", e.место.вТкст0(), Сема2.вТкст0(e.op), e.вТкст0());
            printf("тип = %s\n", e.тип.вТкст0());
            showCtfeExpr(e);
        }
        e.выведиОшибку("cannot interpret `%s` at compile time", e.вТкст0());
        результат = CTFEExp.cantexp;
    }

    override проц посети(TypeExp e)
    {
        debug (LOG)
        {
            printf("%s TypeExp.interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        результат = e;
    }

    override проц посети(ThisExp e)
    {
        debug (LOG)
        {
            printf("%s ThisExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        if (goal == ctfeNeedLvalue)
        {
            // We might end up here with istate being нуль
            // https://issues.dlang.org/show_bug.cgi?ид=16382
            if (istate && istate.fd.vthis)
            {
                результат = ctfeEmplaceExp!(VarExp)(e.место, istate.fd.vthis);
                if (istate.fd.isThis2)
                {
                    результат = ctfeEmplaceExp!(PtrExp)(e.место, результат);
                    результат.тип = Тип.tvoidptr.sarrayOf(2);
                    результат = ctfeEmplaceExp!(IndexExp)(e.место, результат, IntegerExp.literal!(0));
                }
                результат.тип = e.тип;
            }
            else
                результат = e;
            return;
        }

        результат = ctfeGlobals.stack.getThis();
        if (результат)
        {
            if (istate && istate.fd.isThis2)
            {
                assert(результат.op == ТОК2.address);
                результат = (cast(AddrExp)результат).e1;
                assert(результат.op == ТОК2.arrayLiteral);
                результат = (*(cast(ArrayLiteralExp)результат).elements)[0];
                if (e.тип.ty == Tstruct)
                {
                    результат = (cast(AddrExp)результат).e1;
                }
                return;
            }
            assert(результат.op == ТОК2.structLiteral || результат.op == ТОК2.classReference || результат.op == ТОК2.тип);
            return;
        }
        e.выведиОшибку("значение of `this` is not known at compile time");
        результат = CTFEExp.cantexp;
    }

    override проц посети(NullExp e)
    {
        результат = e;
    }

    override проц посети(IntegerExp e)
    {
        debug (LOG)
        {
            printf("%s IntegerExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        результат = e;
    }

    override проц посети(RealExp e)
    {
        debug (LOG)
        {
            printf("%s RealExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        результат = e;
    }

    override проц посети(ComplexExp e)
    {
        результат = e;
    }

    override проц посети(StringExp e)
    {
        debug (LOG)
        {
            printf("%s StringExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        /* Attempts to modify ткст literals are prevented
         * in BinExp::interpretAssignCommon.
         */
        результат = e;
    }

    override проц посети(FuncExp e)
    {
        debug (LOG)
        {
            printf("%s FuncExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        результат = e;
    }

    override проц посети(SymOffExp e)
    {
        debug (LOG)
        {
            printf("%s SymOffExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        if (e.var.isFuncDeclaration() && e.смещение == 0)
        {
            результат = e;
            return;
        }
        if (isTypeInfo_Class(e.тип) && e.смещение == 0)
        {
            результат = e;
            return;
        }
        if (e.тип.ty != Tpointer)
        {
            // Probably impossible
            e.выведиОшибку("cannot interpret `%s` at compile time", e.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }
        Тип pointee = (cast(TypePointer)e.тип).следщ;
        if (e.var.isThreadlocal())
        {
            e.выведиОшибку("cannot take address of thread-local variable %s at compile time", e.var.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }
        // Check for taking an address of a shared variable.
        // If the shared variable is an массив, the смещение might not be нуль.
        Тип fromType = null;
        if (e.var.тип.ty == Tarray || e.var.тип.ty == Tsarray)
        {
            fromType = (cast(TypeArray)e.var.тип).следщ;
        }
        if (e.var.isDataseg() && ((e.смещение == 0 && isSafePointerCast(e.var.тип, pointee)) || (fromType && isSafePointerCast(fromType, pointee))))
        {
            результат = e;
            return;
        }

        Выражение val = getVarExp(e.место, istate, e.var, goal);
        if (exceptionOrCant(val))
            return;
        if (val.тип.ty == Tarray || val.тип.ty == Tsarray)
        {
            // Check for unsupported тип painting operations
            Тип elemtype = (cast(TypeArray)val.тип).следщ;
            d_uns64 elemsize = elemtype.size();

            // It's OK to cast from fixed length to dynamic массив, eg &цел[3] to цел[]*
            if (val.тип.ty == Tsarray && pointee.ty == Tarray && elemsize == pointee.nextOf().size())
            {
                emplaceExp!(AddrExp)(pue, e.место, val, e.тип);
                результат = pue.exp();
                return;
            }

            // It's OK to cast from fixed length to fixed length массив, eg &цел[n] to цел[d]*.
            if (val.тип.ty == Tsarray && pointee.ty == Tsarray && elemsize == pointee.nextOf().size())
            {
                т_мера d = cast(т_мера)(cast(TypeSArray)pointee).dim.toInteger();
                Выражение elwr = ctfeEmplaceExp!(IntegerExp)(e.место, e.смещение / elemsize, Тип.tт_мера);
                Выражение eupr = ctfeEmplaceExp!(IntegerExp)(e.место, e.смещение / elemsize + d, Тип.tт_мера);

                // Create a CTFE pointer &val[ofs..ofs+d]
                auto se = ctfeEmplaceExp!(SliceExp)(e.место, val, elwr, eupr);
                se.тип = pointee;
                emplaceExp!(AddrExp)(pue, e.место, se, e.тип);
                результат = pue.exp();
                return;
            }

            if (!isSafePointerCast(elemtype, pointee))
            {
                // It's also OK to cast from &ткст to ткст*.
                if (e.смещение == 0 && isSafePointerCast(e.var.тип, pointee))
                {
                    // Create a CTFE pointer &var
                    auto ve = ctfeEmplaceExp!(VarExp)(e.место, e.var);
                    ve.тип = elemtype;
                    emplaceExp!(AddrExp)(pue, e.место, ve, e.тип);
                    результат = pue.exp();
                    return;
                }
                e.выведиОшибку("reinterpreting cast from `%s` to `%s` is not supported in CTFE", val.тип.вТкст0(), e.тип.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }

            const dinteger_t sz = pointee.size();
            dinteger_t indx = e.смещение / sz;
            assert(sz * indx == e.смещение);
            Выражение aggregate = null;
            if (val.op == ТОК2.arrayLiteral || val.op == ТОК2.string_)
            {
                aggregate = val;
            }
            else if (auto se = val.isSliceExp())
            {
                aggregate = se.e1;
                UnionExp uelwr = проц;
                Выражение lwr = interpret(&uelwr, se.lwr, istate);
                indx += lwr.toInteger();
            }
            if (aggregate)
            {
                // Create a CTFE pointer &aggregate[ofs]
                auto ofs = ctfeEmplaceExp!(IntegerExp)(e.место, indx, Тип.tт_мера);
                auto ei = ctfeEmplaceExp!(IndexExp)(e.место, aggregate, ofs);
                ei.тип = elemtype;
                emplaceExp!(AddrExp)(pue, e.место, ei, e.тип);
                результат = pue.exp();
                return;
            }
        }
        else if (e.смещение == 0 && isSafePointerCast(e.var.тип, pointee))
        {
            // Create a CTFE pointer &var
            auto ve = ctfeEmplaceExp!(VarExp)(e.место, e.var);
            ve.тип = e.var.тип;
            emplaceExp!(AddrExp)(pue, e.место, ve, e.тип);
            результат = pue.exp();
            return;
        }

        e.выведиОшибку("cannot convert `&%s` to `%s` at compile time", e.var.тип.вТкст0(), e.тип.вТкст0());
        результат = CTFEExp.cantexp;
    }

    override проц посети(AddrExp e)
    {
        debug (LOG)
        {
            printf("%s AddrExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        if (auto ve = e.e1.isVarExp())
        {
            Declaration decl = ve.var;

            // We cannot take the address of an imported symbol at compile time
            if (decl.isImportedSymbol()) {
                e.выведиОшибку("cannot take address of imported symbol `%s` at compile time", decl.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }

            if (decl.isDataseg()) {
                // Normally this is already done by optimize()
                // Do it here in case optimize(WANTvalue) wasn't run before CTFE
                emplaceExp!(SymOffExp)(pue, e.место, (cast(VarExp)e.e1).var, 0);
                результат = pue.exp();
                результат.тип = e.тип;
                return;
            }
        }
        auto er = interpret(e.e1, istate, ctfeNeedLvalue);
        if (auto ve = er.isVarExp())
            if (ve.var == istate.fd.vthis)
                er = interpret(er, istate);

        if (exceptionOrCant(er))
            return;

        // Return a simplified address Выражение
        emplaceExp!(AddrExp)(pue, e.место, er, e.тип);
        результат = pue.exp();
    }

    override проц посети(DelegateExp e)
    {
        debug (LOG)
        {
            printf("%s DelegateExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        // TODO: Really we should создай a CTFE-only delegate Выражение
        // of a pointer and a funcptr.

        // If it is &nestedfunc, just return it
        // TODO: We should save the context pointer
        if (auto ve1 = e.e1.isVarExp())
            if (ve1.var == e.func)
            {
                результат = e;
                return;
            }

        auto er = interpret(pue, e.e1, istate);
        if (exceptionOrCant(er))
            return;
        if (er == e.e1)
        {
            // If it has already been CTFE'd, just return it
            результат = e;
        }
        else
        {
            er = (er == pue.exp()) ? pue.копируй() : er;
            emplaceExp!(DelegateExp)(pue, e.место, er, e.func, нет);
            результат = pue.exp();
            результат.тип = e.тип;
        }
    }

    static Выражение getVarExp(ref Место место, InterState* istate, Declaration d, CtfeGoal goal)
    {
        Выражение e = CTFEExp.cantexp;
        if (VarDeclaration v = d.isVarDeclaration())
        {
            /* Magic variable __ctfe always returns да when interpreting
             */
            if (v.идент == Id.ctfe)
                return IntegerExp.createBool(да);

            if (!v.originalType && v.semanticRun < PASS.semanticdone) // semantic() not yet run
            {
                v.dsymbolSemantic(null);
                if (v.тип.ty == Terror)
                    return CTFEExp.cantexp;
            }

            if ((v.isConst() || v.isImmutable() || v.класс_хранения & STC.manifest) && !hasValue(v) && v._иниц && !v.isCTFE())
            {
                if (v.inuse)
                {
                    выведиОшибку(место, "circular initialization of %s `%s`", v.вид(), v.toPrettyChars());
                    return CTFEExp.cantexp;
                }
                if (v._scope)
                {
                    v.inuse++;
                    v._иниц = v._иниц.initializerSemantic(v._scope, v.тип, INITinterpret); // might not be run on aggregate члены
                    v.inuse--;
                }
                e = v._иниц.инициализаторВВыражение(v.тип);
                if (!e)
                    return CTFEExp.cantexp;
                assert(e.тип);

                if (e.op == ТОК2.construct || e.op == ТОК2.blit)
                {
                    AssignExp ae = cast(AssignExp)e;
                    e = ae.e2;
                }

                if (e.op == ТОК2.error)
                {
                    // FIXME: Ultimately all errors should be detected in prior semantic analysis stage.
                }
                else if (v.isDataseg() || (v.класс_хранения & STC.manifest))
                {
                    /* https://issues.dlang.org/show_bug.cgi?ид=14304
                     * e is a значение that is not yet owned by CTFE.
                     * Mark as "cached", and use it directly during interpretation.
                     */
                    e = scrubCacheValue(e);
                    ctfeGlobals.stack.saveGlobalConstant(v, e);
                }
                else
                {
                    v.inuse++;
                    e = interpret(e, istate);
                    v.inuse--;
                    if (CTFEExp.isCantExp(e) && !глоб2.gag && !ctfeGlobals.stackTraceCallsToSuppress)
                        errorSupplemental(место, "while evaluating %s.init", v.вТкст0());
                    if (exceptionOrCantInterpret(e))
                        return e;
                }
            }
            else if (v.isCTFE() && !hasValue(v))
            {
                if (v._иниц && v.тип.size() != 0)
                {
                    if (v._иниц.isVoidInitializer())
                    {
                        // var should have been initialized when it was created
                        выведиОшибку(место, "CTFE internal error: trying to access uninitialized var");
                        assert(0);
                    }
                    e = v._иниц.инициализаторВВыражение();
                }
                else
                    e = v.тип.defaultInitLiteral(e.место);

                e = interpret(e, istate);
            }
            else if (!(v.isDataseg() || v.класс_хранения & STC.manifest) && !v.isCTFE() && !istate)
            {
                выведиОшибку(место, "variable `%s` cannot be читай at compile time", v.вТкст0());
                return CTFEExp.cantexp;
            }
            else
            {
                e = hasValue(v) ? дайЗначение(v) : null;
                if (!e && !v.isCTFE() && v.isDataseg())
                {
                    выведиОшибку(место, "static variable `%s` cannot be читай at compile time", v.вТкст0());
                    return CTFEExp.cantexp;
                }
                if (!e)
                {
                    assert(!(v._иниц && v._иниц.isVoidInitializer()));
                    // CTFE initiated from inside a function
                    выведиОшибку(место, "variable `%s` cannot be читай at compile time", v.вТкст0());
                    return CTFEExp.cantexp;
                }
                if (auto vie = e.isVoidInitExp())
                {
                    выведиОшибку(место, "cannot читай uninitialized variable `%s` in ctfe", v.toPrettyChars());
                    errorSupplemental(vie.var.место, "`%s` was uninitialized and используется before set", vie.var.вТкст0());
                    return CTFEExp.cantexp;
                }
                if (goal != ctfeNeedLvalue && (v.isRef() || v.isOut()))
                    e = interpret(e, istate, goal);
            }
            if (!e)
                e = CTFEExp.cantexp;
        }
        else if (SymbolDeclaration s = d.isSymbolDeclaration())
        {
            // Struct static initializers, for example
            e = s.dsym.тип.defaultInitLiteral(место);
            if (e.op == ТОК2.error)
                выведиОшибку(место, "CTFE failed because of previous errors in `%s.init`", s.вТкст0());
            e = e.ВыражениеSemantic(null);
            if (e.op == ТОК2.error)
                e = CTFEExp.cantexp;
            else // Convert NULL to CTFEExp
                e = interpret(e, istate, goal);
        }
        else
            выведиОшибку(место, "cannot interpret declaration `%s` at compile time", d.вТкст0());
        return e;
    }

    override проц посети(VarExp e)
    {
        debug (LOG)
        {
            printf("%s VarExp::interpret() `%s`, goal = %d\n", e.место.вТкст0(), e.вТкст0(), goal);
        }
        if (e.var.isFuncDeclaration())
        {
            результат = e;
            return;
        }

        if (goal == ctfeNeedLvalue)
        {
            VarDeclaration v = e.var.isVarDeclaration();
            if (v && !v.isDataseg() && !v.isCTFE() && !istate)
            {
                e.выведиОшибку("variable `%s` cannot be читай at compile time", v.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }
            if (v && !hasValue(v))
            {
                if (!v.isCTFE() && v.isDataseg())
                    e.выведиОшибку("static variable `%s` cannot be читай at compile time", v.вТкст0());
                else // CTFE initiated from inside a function
                    e.выведиОшибку("variable `%s` cannot be читай at compile time", v.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }

            if (v && (v.класс_хранения & (STC.out_ | STC.ref_)) && hasValue(v))
            {
                // Strip off the nest of ref variables
                Выражение ev = дайЗначение(v);
                if (ev.op == ТОК2.variable ||
                    ev.op == ТОК2.index ||
                    ev.op == ТОК2.slice ||
                    ev.op == ТОК2.dotVariable)
                {
                    результат = interpret(pue, ev, istate, goal);
                    return;
                }
            }
            результат = e;
            return;
        }
        результат = getVarExp(e.место, istate, e.var, goal);
        if (exceptionOrCant(результат))
            return;
        if ((e.var.класс_хранения & (STC.ref_ | STC.out_)) == 0 && e.тип.baseElemOf().ty != Tstruct)
        {
            /* Ultimately, STC.ref_|STC.out_ check should be enough to see the
             * necessity of тип repainting. But currently front-end paints
             * non-ref struct variables by the const тип.
             *
             *  auto foo(ref const S cs);
             *  S s;
             *  foo(s); // VarExp('s') will have const(S)
             */
            // A VarExp may include an implicit cast. It must be done explicitly.
            результат = paintTypeOntoLiteral(pue, e.тип, результат);
        }
    }

    override проц посети(DeclarationExp e)
    {
        debug (LOG)
        {
            printf("%s DeclarationExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        ДСимвол s = e.declaration;
        if (VarDeclaration v = s.isVarDeclaration())
        {
            if (TupleDeclaration td = v.toAlias().isTupleDeclaration())
            {
                результат = null;

                // Reserve stack space for all кортеж члены
                if (!td.objects)
                    return;
                foreach (o; *td.objects)
                {
                    Выражение ex = выражение_ли(o);
                    DsymbolExp ds = ex ? ex.isDsymbolExp() : null;
                    VarDeclaration v2 = ds ? ds.s.isVarDeclaration() : null;
                    assert(v2);
                    if (v2.isDataseg() && !v2.isCTFE())
                        continue;

                    ctfeGlobals.stack.сунь(v2);
                    if (v2._иниц)
                    {
                        Выражение einit;
                        if (ExpInitializer ie = v2._иниц.isExpInitializer())
                        {
                            einit = interpretRegion(ie.exp, istate, goal);
                            if (exceptionOrCant(einit))
                                return;
                        }
                        else if (v2._иниц.isVoidInitializer())
                        {
                            einit = voidInitLiteral(v2.тип, v2).копируй();
                        }
                        else
                        {
                            e.выведиОшибку("declaration `%s` is not yet implemented in CTFE", e.вТкст0());
                            результат = CTFEExp.cantexp;
                            return;
                        }
                        setValue(v2, einit);
                    }
                }
                return;
            }
            if (v.isStatic())
            {
                // Just ignore static variables which aren't читай or written yet
                результат = null;
                return;
            }
            if (!(v.isDataseg() || v.класс_хранения & STC.manifest) || v.isCTFE())
                ctfeGlobals.stack.сунь(v);
            if (v._иниц)
            {
                if (ExpInitializer ie = v._иниц.isExpInitializer())
                {
                    результат = interpretRegion(ie.exp, istate, goal);
                }
                else if (v._иниц.isVoidInitializer())
                {
                    результат = voidInitLiteral(v.тип, v).копируй();
                    // There is no AssignExp for проц initializers,
                    // so set it here.
                    setValue(v, результат);
                }
                else
                {
                    e.выведиОшибку("declaration `%s` is not yet implemented in CTFE", e.вТкст0());
                    результат = CTFEExp.cantexp;
                }
            }
            else if (v.тип.size() == 0)
            {
                // Zero-length arrays don't need an инициализатор
                результат = v.тип.defaultInitLiteral(e.место);
            }
            else
            {
                e.выведиОшибку("variable `%s` cannot be modified at compile time", v.вТкст0());
                результат = CTFEExp.cantexp;
            }
            return;
        }
        if (s.isAttribDeclaration() || s.isTemplateMixin() || s.isTupleDeclaration())
        {
            // Check for static struct declarations, which aren't executable
            AttribDeclaration ad = e.declaration.isAttribDeclaration();
            if (ad && ad.decl && ad.decl.dim == 1)
            {
                ДСимвол sparent = (*ad.decl)[0];
                if (sparent.isAggregateDeclaration() || sparent.isTemplateDeclaration() || sparent.isAliasDeclaration())
                {
                    результат = null;
                    return; // static (template) struct declaration. Nothing to do.
                }
            }

            // These can be made to work, too lazy now
            e.выведиОшибку("declaration `%s` is not yet implemented in CTFE", e.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }

        // Others should not contain executable code, so are trivial to evaluate
        результат = null;
        debug (LOG)
        {
            printf("-DeclarationExp::interpret(%s): %p\n", e.вТкст0(), результат);
        }
    }

    override проц посети(TypeidExp e)
    {
        debug (LOG)
        {
            printf("%s TypeidExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        if (Тип t = тип_ли(e.obj))
        {
            результат = e;
            return;
        }
        if (Выражение ex = выражение_ли(e.obj))
        {
            результат = interpret(pue, ex, istate);
            if (exceptionOrCant(ex))
                return;

            if (результат.op == ТОК2.null_)
            {
                e.выведиОшибку("null pointer dereference evaluating typeid. `%s` is `null`", ex.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }
            if (результат.op != ТОК2.classReference)
            {
                e.выведиОшибку("CTFE internal error: determining classinfo");
                результат = CTFEExp.cantexp;
                return;
            }

            ClassDeclaration cd = (cast(ClassReferenceExp)результат).originalClass();
            assert(cd);

            emplaceExp!(TypeidExp)(pue, e.место, cd.тип);
            результат = pue.exp();
            результат.тип = e.тип;
            return;
        }
        посети(cast(Выражение)e);
    }

    override проц посети(TupleExp e)
    {
        debug (LOG)
        {
            printf("%s TupleExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        if (exceptionOrCant(interpretRegion(e.e0, istate, ctfeNeedNothing)))
            return;

        auto expsx = e.exps;
        foreach (i, exp; *expsx)
        {
            Выражение ex = interpretRegion(exp, istate);
            if (exceptionOrCant(ex))
                return;

            // A кортеж of assignments can contain проц (Bug 5676).
            if (goal == ctfeNeedNothing)
                continue;
            if (ex.op == ТОК2.voidВыражение)
            {
                e.выведиОшибку("CTFE internal error: проц element `%s` in кортеж", exp.вТкст0());
                assert(0);
            }

            /* If any changes, do Copy On Write
             */
            if (ex !is exp)
            {
                expsx = copyArrayOnWrite(expsx, e.exps);
                (*expsx)[i] = copyRegionExp(ex);
            }
        }

        if (expsx !is e.exps)
        {
            expandTuples(expsx);
            emplaceExp!(TupleExp)(pue, e.место, expsx);
            результат = pue.exp();
            результат.тип = new КортежТипов(expsx);
        }
        else
            результат = e;
    }

    override проц посети(ArrayLiteralExp e)
    {
        debug (LOG)
        {
            printf("%s ArrayLiteralExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        if (e.ownedByCtfe >= OwnedBy.ctfe) // We've already interpreted all the elements
        {
            результат = e;
            return;
        }

        Тип tn = e.тип.toBasetype().nextOf().toBasetype();
        бул wantCopy = (tn.ty == Tsarray || tn.ty == Tstruct);

        auto basis = interpretRegion(e.basis, istate);
        if (exceptionOrCant(basis))
            return;

        auto expsx = e.elements;
        т_мера dim = expsx ? expsx.dim : 0;
        for (т_мера i = 0; i < dim; i++)
        {
            Выражение exp = (*expsx)[i];
            Выражение ex;
            if (!exp)
            {
                ex = copyLiteral(basis).копируй();
            }
            else
            {
                // segfault bug 6250
                assert(exp.op != ТОК2.index || (cast(IndexExp)exp).e1 != e);

                ex = interpretRegion(exp, istate);
                if (exceptionOrCant(ex))
                    return;

                /* Each elements should have distinct CTFE memory.
                 *  цел[1] z = 7;
                 *  цел[1][] pieces = [z,z];    // here
                 */
                if (wantCopy)
                    ex = copyLiteral(ex).копируй();
            }

            /* If any changes, do Copy On Write
             */
            if (ex !is exp)
            {
                expsx = copyArrayOnWrite(expsx, e.elements);
                (*expsx)[i] = ex;
            }
        }

        if (expsx !is e.elements)
        {
            // todo: all кортеж expansions should go in semantic phase.
            expandTuples(expsx);
            if (expsx.dim != dim)
            {
                e.выведиОшибку("CTFE internal error: invalid массив literal");
                результат = CTFEExp.cantexp;
                return;
            }
            emplaceExp!(ArrayLiteralExp)(pue, e.место, e.тип, basis, expsx);
            auto ale = cast(ArrayLiteralExp)pue.exp();
            ale.ownedByCtfe = OwnedBy.ctfe;
            результат = ale;
        }
        else if ((cast(TypeNext)e.тип).следщ.mod & (MODFlags.const_ | MODFlags.immutable_))
        {
            // If it's const, we don't need to dup it
            результат = e;
        }
        else
        {
            *pue = copyLiteral(e);
            результат = pue.exp();
        }
    }

    override проц посети(AssocArrayLiteralExp e)
    {
        debug (LOG)
        {
            printf("%s AssocArrayLiteralExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        if (e.ownedByCtfe >= OwnedBy.ctfe) // We've already interpreted all the elements
        {
            результат = e;
            return;
        }

        auto keysx = e.keys;
        auto valuesx = e.values;
        foreach (i, ekey; *keysx)
        {
            auto evalue = (*valuesx)[i];

            auto ek = interpretRegion(ekey, istate);
            if (exceptionOrCant(ek))
                return;
            auto ev = interpretRegion(evalue, istate);
            if (exceptionOrCant(ev))
                return;

            /* If any changes, do Copy On Write
             */
            if (ek !is ekey ||
                ev !is evalue)
            {
                keysx = copyArrayOnWrite(keysx, e.keys);
                valuesx = copyArrayOnWrite(valuesx, e.values);
                (*keysx)[i] = ek;
                (*valuesx)[i] = ev;
            }
        }
        if (keysx !is e.keys)
            expandTuples(keysx);
        if (valuesx !is e.values)
            expandTuples(valuesx);
        if (keysx.dim != valuesx.dim)
        {
            e.выведиОшибку("CTFE internal error: invalid AA");
            результат = CTFEExp.cantexp;
            return;
        }

        /* Remove duplicate keys
         */
        for (т_мера i = 1; i < keysx.dim; i++)
        {
            auto ekey = (*keysx)[i - 1];
            for (т_мера j = i; j < keysx.dim; j++)
            {
                auto ekey2 = (*keysx)[j];
                if (!ctfeEqual(e.место, ТОК2.equal, ekey, ekey2))
                    continue;

                // Remove ekey
                keysx = copyArrayOnWrite(keysx, e.keys);
                valuesx = copyArrayOnWrite(valuesx, e.values);
                keysx.удали(i - 1);
                valuesx.удали(i - 1);

                i -= 1; // redo the i'th iteration
                break;
            }
        }

        if (keysx !is e.keys ||
            valuesx !is e.values)
        {
            assert(keysx !is e.keys &&
                   valuesx !is e.values);
            auto aae = ctfeEmplaceExp!(AssocArrayLiteralExp)(e.место, keysx, valuesx);
            aae.тип = e.тип;
            aae.ownedByCtfe = OwnedBy.ctfe;
            результат = aae;
        }
        else
        {
            *pue = copyLiteral(e);
            результат = pue.exp();
        }
    }

    override проц посети(StructLiteralExp e)
    {
        debug (LOG)
        {
            printf("%s StructLiteralExp::interpret() %s ownedByCtfe = %d\n", e.место.вТкст0(), e.вТкст0(), e.ownedByCtfe);
        }
        if (e.ownedByCtfe >= OwnedBy.ctfe)
        {
            результат = e;
            return;
        }

        т_мера dim = e.elements ? e.elements.dim : 0;
        auto expsx = e.elements;

        if (dim != e.sd.fields.dim)
        {
            // guaranteed by AggregateDeclaration.fill and TypeStruct.defaultInitLiteral
            const nvthis = e.sd.fields.dim - e.sd.nonHiddenFields();
            assert(e.sd.fields.dim - dim == nvthis);

            /* If a nested struct has no initialized hidden pointer,
             * set it to null to match the runtime behaviour.
             */
            foreach ( i; new бцел[0 .. nvthis])
            {
                auto ne = ctfeEmplaceExp!(NullExp)(e.место);
                auto vthis = i == 0 ? e.sd.vthis : e.sd.vthis2;
                ne.тип = vthis.тип;

                expsx = copyArrayOnWrite(expsx, e.elements);
                expsx.сунь(ne);
                ++dim;
            }
        }
        assert(dim == e.sd.fields.dim);

        foreach (i; new бцел[0 .. dim])
        {
            auto v = e.sd.fields[i];
            Выражение exp = (*expsx)[i];
            Выражение ex;
            if (!exp)
            {
                ex = voidInitLiteral(v.тип, v).копируй();
            }
            else
            {
                ex = interpretRegion(exp, istate);
                if (exceptionOrCant(ex))
                    return;
                if ((v.тип.ty != ex.тип.ty) && v.тип.ty == Tsarray)
                {
                    // Block assignment from inside struct literals
                    auto tsa = cast(TypeSArray)v.тип;
                    auto len = cast(т_мера)tsa.dim.toInteger();
                    UnionExp ue = проц;
                    ex = createBlockDuplicatedArrayLiteral(&ue, ex.место, v.тип, ex, len);
                    if (ex == ue.exp())
                        ex = ue.копируй();
                }
            }

            /* If any changes, do Copy On Write
             */
            if (ex !is exp)
            {
                expsx = copyArrayOnWrite(expsx, e.elements);
                (*expsx)[i] = ex;
            }
        }

        if (expsx !is e.elements)
        {
            expandTuples(expsx);
            if (expsx.dim != e.sd.fields.dim)
            {
                e.выведиОшибку("CTFE internal error: invalid struct literal");
                результат = CTFEExp.cantexp;
                return;
            }
            emplaceExp!(StructLiteralExp)(pue, e.место, e.sd, expsx);
            auto sle = cast(StructLiteralExp)pue.exp();
            sle.тип = e.тип;
            sle.ownedByCtfe = OwnedBy.ctfe;
            sle.origin = e.origin;
            результат = sle;
        }
        else
        {
            *pue = copyLiteral(e);
            результат = pue.exp();
        }
    }

    // Create an массив literal of тип 'newtype' with dimensions given by
    // 'arguments'[argnum..$]
    static Выражение recursivelyCreateArrayLiteral(UnionExp* pue, ref Место место, Тип newtype, InterState* istate, Выражения* arguments, цел argnum)
    {
        Выражение lenExpr = interpret(pue, (*arguments)[argnum], istate);
        if (exceptionOrCantInterpret(lenExpr))
            return lenExpr;
        т_мера len = cast(т_мера)lenExpr.toInteger();
        Тип elemType = (cast(TypeArray)newtype).следщ;
        if (elemType.ty == Tarray && argnum < arguments.dim - 1)
        {
            Выражение elem = recursivelyCreateArrayLiteral(pue, место, elemType, istate, arguments, argnum + 1);
            if (exceptionOrCantInterpret(elem))
                return elem;

            auto elements = new Выражения(len);
            foreach (ref element; *elements)
                element = copyLiteral(elem).копируй();
            emplaceExp!(ArrayLiteralExp)(pue, место, newtype, elements);
            auto ae = cast(ArrayLiteralExp)pue.exp();
            ae.ownedByCtfe = OwnedBy.ctfe;
            return ae;
        }
        assert(argnum == arguments.dim - 1);
        if (elemType.ty == Tchar || elemType.ty == Twchar || elemType.ty == Tdchar)
        {
            const ch = cast(dchar)elemType.defaultInitLiteral(место).toInteger();
            const sz = cast(ббайт)elemType.size();
            return createBlockDuplicatedStringLiteral(pue, место, newtype, ch, len, sz);
        }
        else
        {
            auto el = interpret(elemType.defaultInitLiteral(место), istate);
            return createBlockDuplicatedArrayLiteral(pue, место, newtype, el, len);
        }
    }

    override проц посети(NewExp e)
    {
        debug (LOG)
        {
            printf("%s NewExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        if (e.allocator)
        {
            e.выведиОшибку("member allocators not supported by CTFE");
            результат = CTFEExp.cantexp;
            return;
        }

        Выражение epre = interpret(pue, e.argprefix, istate, ctfeNeedNothing);
        if (exceptionOrCant(epre))
            return;

        if (e.newtype.ty == Tarray && e.arguments)
        {
            результат = recursivelyCreateArrayLiteral(pue, e.место, e.newtype, istate, e.arguments, 0);
            return;
        }
        if (auto ts = e.newtype.toBasetype().isTypeStruct())
        {
            if (e.member)
            {
                Выражение se = e.newtype.defaultInitLiteral(e.место);
                se = interpret(se, istate);
                if (exceptionOrCant(se))
                    return;
                результат = interpretFunction(pue, e.member, istate, e.arguments, se);

                // Repaint as same as CallExp::interpret() does.
                результат.место = e.место;
            }
            else
            {
                StructDeclaration sd = ts.sym;
                auto exps = new Выражения();
                exps.резервируй(sd.fields.dim);
                if (e.arguments)
                {
                    exps.устДим(e.arguments.dim);
                    foreach (i, ex; *e.arguments)
                    {
                        ex = interpretRegion(ex, istate);
                        if (exceptionOrCant(ex))
                            return;
                        (*exps)[i] = ex;
                    }
                }
                sd.fill(e.место, exps, нет);

                auto se = ctfeEmplaceExp!(StructLiteralExp)(e.место, sd, exps, e.newtype);
                se.origin = se;
                se.тип = e.newtype;
                se.ownedByCtfe = OwnedBy.ctfe;
                результат = interpret(pue, se, istate);
            }
            if (exceptionOrCant(результат))
                return;
            Выражение ev = (результат == pue.exp()) ? pue.копируй() : результат;
            emplaceExp!(AddrExp)(pue, e.место, ev, e.тип);
            результат = pue.exp();
            return;
        }
        if (auto tc = e.newtype.toBasetype().isTypeClass())
        {
            ClassDeclaration cd = tc.sym;
            т_мера totalFieldCount = 0;
            for (ClassDeclaration c = cd; c; c = c.baseClass)
                totalFieldCount += c.fields.dim;
            auto elems = new Выражения(totalFieldCount);
            т_мера fieldsSoFar = totalFieldCount;
            for (ClassDeclaration c = cd; c; c = c.baseClass)
            {
                fieldsSoFar -= c.fields.dim;
                foreach (i, v; c.fields)
                {
                    if (v.inuse)
                    {
                        e.выведиОшибку("circular reference to `%s`", v.toPrettyChars());
                        результат = CTFEExp.cantexp;
                        return;
                    }
                    Выражение m;
                    if (v._иниц)
                    {
                        if (v._иниц.isVoidInitializer())
                            m = voidInitLiteral(v.тип, v).копируй();
                        else
                            m = v.getConstInitializer(да);
                    }
                    else
                        m = v.тип.defaultInitLiteral(e.место);
                    if (exceptionOrCant(m))
                        return;
                    (*elems)[fieldsSoFar + i] = copyLiteral(m).копируй();
                }
            }
            // Hack: we store a ClassDeclaration instead of a StructDeclaration.
            // We probably won't get away with this.
//            auto se = new StructLiteralExp(e.место, cast(StructDeclaration)cd, elems, e.newtype);
            auto se = ctfeEmplaceExp!(StructLiteralExp)(e.место, cast(StructDeclaration)cd, elems, e.newtype);
            se.origin = se;
            se.ownedByCtfe = OwnedBy.ctfe;
            emplaceExp!(ClassReferenceExp)(pue, e.место, se, e.тип);
            Выражение eref = pue.exp();
            if (e.member)
            {
                // Call constructor
                if (!e.member.fbody)
                {
                    Выражение ctorfail = evaluateIfBuiltin(pue, istate, e.место, e.member, e.arguments, eref);
                    if (ctorfail)
                    {
                        if (exceptionOrCant(ctorfail))
                            return;
                        результат = eref;
                        return;
                    }
                    e.member.выведиОшибку("`%s` cannot be constructed at compile time, because the constructor has no доступно source code", e.newtype.вТкст0());
                    результат = CTFEExp.cantexp;
                    return;
                }
                UnionExp ue = проц;
                Выражение ctorfail = interpretFunction(&ue, e.member, istate, e.arguments, eref);
                if (exceptionOrCant(ctorfail))
                    return;

                /* https://issues.dlang.org/show_bug.cgi?ид=14465
                 * Repaint the место, because a super() call
                 * in the constructor modifies the место of ClassReferenceExp
                 * in CallExp::interpret().
                 */
                eref.место = e.место;
            }
            результат = eref;
            return;
        }
        if (e.newtype.toBasetype().isscalar())
        {
            Выражение newval;
            if (e.arguments && e.arguments.dim)
                newval = (*e.arguments)[0];
            else
                newval = e.newtype.defaultInitLiteral(e.место);
            newval = interpretRegion(newval, istate);
            if (exceptionOrCant(newval))
                return;

            // Create a CTFE pointer &[newval][0]
            auto elements = new Выражения(1);
            (*elements)[0] = newval;
            auto ae = ctfeEmplaceExp!(ArrayLiteralExp)(e.место, e.newtype.arrayOf(), elements);
            ae.ownedByCtfe = OwnedBy.ctfe;

            auto ei = ctfeEmplaceExp!(IndexExp)(e.место, ae, ctfeEmplaceExp!(IntegerExp)(Место.initial, 0, Тип.tт_мера));
            ei.тип = e.newtype;
            emplaceExp!(AddrExp)(pue, e.место, ei, e.тип);
            результат = pue.exp();
            return;
        }
        e.выведиОшибку("cannot interpret `%s` at compile time", e.вТкст0());
        результат = CTFEExp.cantexp;
    }

    override проц посети(UnaExp e)
    {
        debug (LOG)
        {
            printf("%s UnaExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        UnionExp ue = проц;
        Выражение e1 = interpret(&ue, e.e1, istate);
        if (exceptionOrCant(e1))
            return;
        switch (e.op)
        {
        case ТОК2.negate:
            *pue = Neg(e.тип, e1);
            break;

        case ТОК2.tilde:
            *pue = Com(e.тип, e1);
            break;

        case ТОК2.not:
            *pue = Not(e.тип, e1);
            break;

        default:
            assert(0);
        }
        результат = (*pue).exp();
    }

    override проц посети(DotTypeExp e)
    {
        debug (LOG)
        {
            printf("%s DotTypeExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        UnionExp ue = проц;
        Выражение e1 = interpret(&ue, e.e1, istate);
        if (exceptionOrCant(e1))
            return;
        if (e1 == e.e1)
            результат = e; // optimize: reuse this CTFE reference
        else
        {
            auto edt = cast(DotTypeExp)e.копируй();
            edt.e1 = (e1 == ue.exp()) ? e1.копируй() : e1; // don't return pointer to ue
            результат = edt;
        }
    }

    extern (D) private проц interpretCommon(BinExp e, fp_t fp)
    {
        debug (LOG)
        {
            printf("%s BinExp::interpretCommon() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        if (e.e1.тип.ty == Tpointer && e.e2.тип.ty == Tpointer && e.op == ТОК2.min)
        {
            UnionExp ue1 = проц;
            Выражение e1 = interpret(&ue1, e.e1, istate);
            if (exceptionOrCant(e1))
                return;
            UnionExp ue2 = проц;
            Выражение e2 = interpret(&ue2, e.e2, istate);
            if (exceptionOrCant(e2))
                return;
            *pue = pointerDifference(e.место, e.тип, e1, e2);
            результат = (*pue).exp();
            return;
        }
        if (e.e1.тип.ty == Tpointer && e.e2.тип.isintegral())
        {
            UnionExp ue1 = проц;
            Выражение e1 = interpret(&ue1, e.e1, istate);
            if (exceptionOrCant(e1))
                return;
            UnionExp ue2 = проц;
            Выражение e2 = interpret(&ue2, e.e2, istate);
            if (exceptionOrCant(e2))
                return;
            *pue = pointerArithmetic(e.место, e.op, e.тип, e1, e2);
            результат = (*pue).exp();
            return;
        }
        if (e.e2.тип.ty == Tpointer && e.e1.тип.isintegral() && e.op == ТОК2.add)
        {
            UnionExp ue1 = проц;
            Выражение e1 = interpret(&ue1, e.e1, istate);
            if (exceptionOrCant(e1))
                return;
            UnionExp ue2 = проц;
            Выражение e2 = interpret(&ue2, e.e2, istate);
            if (exceptionOrCant(e2))
                return;
            *pue = pointerArithmetic(e.место, e.op, e.тип, e2, e1);
            результат = (*pue).exp();
            return;
        }
        if (e.e1.тип.ty == Tpointer || e.e2.тип.ty == Tpointer)
        {
            e.выведиОшибку("pointer Выражение `%s` cannot be interpreted at compile time", e.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }

        бул evalOperand(UnionExp* pue, Выражение ex, out Выражение er)
        {
            er = interpret(pue, ex, istate);
            if (exceptionOrCant(er))
                return нет;
            if (er.isConst() != 1)
            {
                if (er.op == ТОК2.arrayLiteral)
                    // Until we get it to work, issue a reasonable error message
                    e.выведиОшибку("cannot interpret массив literal Выражение `%s` at compile time", e.вТкст0());
                else
                    e.выведиОшибку("CTFE internal error: non-constant значение `%s`", ex.вТкст0());
                результат = CTFEExp.cantexp;
                return нет;
            }
            return да;
        }

        UnionExp ue1 = проц;
        Выражение e1;
        if (!evalOperand(&ue1, e.e1, e1))
            return;

        UnionExp ue2 = проц;
        Выражение e2;
        if (!evalOperand(&ue2, e.e2, e2))
            return;

        if (e.op == ТОК2.rightShift || e.op == ТОК2.leftShift || e.op == ТОК2.unsignedRightShift)
        {
            const sinteger_t i2 = e2.toInteger();
            const d_uns64 sz = e1.тип.size() * 8;
            if (i2 < 0 || i2 >= sz)
            {
                e.выведиОшибку("shift by %lld is outside the range 0..%llu", i2, cast(бдол)sz - 1);
                результат = CTFEExp.cantexp;
                return;
            }
        }
        *pue = (*fp)(e.место, e.тип, e1, e2);
        результат = (*pue).exp();
        if (CTFEExp.isCantExp(результат))
            e.выведиОшибку("`%s` cannot be interpreted at compile time", e.вТкст0());
    }

    extern (D) private проц interpretCompareCommon(BinExp e, fp2_t fp)
    {
        debug (LOG)
        {
            printf("%s BinExp::interpretCompareCommon() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        UnionExp ue1 = проц;
        UnionExp ue2 = проц;
        if (e.e1.тип.ty == Tpointer && e.e2.тип.ty == Tpointer)
        {
            Выражение e1 = interpret(&ue1, e.e1, istate);
            if (exceptionOrCant(e1))
                return;
            Выражение e2 = interpret(&ue2, e.e2, istate);
            if (exceptionOrCant(e2))
                return;
            //printf("e1 = %s %s, e2 = %s %s\n", e1.тип.вТкст0(), e1.вТкст0(), e2.тип.вТкст0(), e2.вТкст0());
            dinteger_t ofs1, ofs2;
            Выражение agg1 = getAggregateFromPointer(e1, &ofs1);
            Выражение agg2 = getAggregateFromPointer(e2, &ofs2);
            //printf("agg1 = %p %s, agg2 = %p %s\n", agg1, agg1.вТкст0(), agg2, agg2.вТкст0());
            const cmp = comparePointers(e.op, agg1, ofs1, agg2, ofs2);
            if (cmp == -1)
            {
                сим dir = (e.op == ТОК2.greaterThan || e.op == ТОК2.greaterOrEqual) ? '<' : '>';
                e.выведиОшибку("the ordering of pointers to unrelated memory blocks is indeterminate in CTFE. To check if they point to the same memory block, use both `>` and `<` inside `&&` or `||`, eg `%s && %s %c= %s + 1`", e.вТкст0(), e.e1.вТкст0(), dir, e.e2.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }
            if (e.тип.равен(Тип.tбул))
                результат = IntegerExp.createBool(cmp != 0);
            else
            {
                emplaceExp!(IntegerExp)(pue, e.место, cmp, e.тип);
                результат = (*pue).exp();
            }
            return;
        }
        Выражение e1 = interpret(&ue1, e.e1, istate);
        if (exceptionOrCant(e1))
            return;
        if (!isCtfeComparable(e1))
        {
            e.выведиОшибку("cannot compare `%s` at compile time", e1.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }
        Выражение e2 = interpret(&ue2, e.e2, istate);
        if (exceptionOrCant(e2))
            return;
        if (!isCtfeComparable(e2))
        {
            e.выведиОшибку("cannot compare `%s` at compile time", e2.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }
        const cmp = (*fp)(e.место, e.op, e1, e2);
        if (e.тип.равен(Тип.tбул))
            результат = IntegerExp.createBool(cmp);
        else
        {
            emplaceExp!(IntegerExp)(pue, e.место, cmp, e.тип);
            результат = (*pue).exp();
        }
    }

    override проц посети(BinExp e)
    {
        switch (e.op)
        {
        case ТОК2.add:
            interpretCommon(e, &Add);
            return;

        case ТОК2.min:
            interpretCommon(e, &Min);
            return;

        case ТОК2.mul:
            interpretCommon(e, &Mul);
            return;

        case ТОК2.div:
            interpretCommon(e, &Div);
            return;

        case ТОК2.mod:
            interpretCommon(e, &Mod);
            return;

        case ТОК2.leftShift:
            interpretCommon(e, &Shl);
            return;

        case ТОК2.rightShift:
            interpretCommon(e, &Shr);
            return;

        case ТОК2.unsignedRightShift:
            interpretCommon(e, &Ushr);
            return;

        case ТОК2.and:
            interpretCommon(e, &And);
            return;

        case ТОК2.or:
            interpretCommon(e, &Or);
            return;

        case ТОК2.xor:
            interpretCommon(e, &Xor);
            return;

        case ТОК2.pow:
            interpretCommon(e, &Pow);
            return;

        case ТОК2.equal:
        case ТОК2.notEqual:
            interpretCompareCommon(e, &ctfeEqual);
            return;

        case ТОК2.identity:
        case ТОК2.notIdentity:
            interpretCompareCommon(e, &ctfeIdentity);
            return;

        case ТОК2.lessThan:
        case ТОК2.lessOrEqual:
        case ТОК2.greaterThan:
        case ТОК2.greaterOrEqual:
            interpretCompareCommon(e, &ctfeCmp);
            return;

        default:
            printf("be = '%s' %s at [%s]\n", Сема2.вТкст0(e.op), e.вТкст0(), e.место.вТкст0());
            assert(0);
        }
    }

    /* Helper functions for BinExp::interpretAssignCommon
     */
    // Возвращает the variable which is eventually modified, or NULL if an rvalue.
    // thisval is the current значение of 'this'.
    static VarDeclaration findParentVar(Выражение e)
    {
        for (;;)
        {
            if (auto ve = e.isVarExp())
            {
                VarDeclaration v = ve.var.isVarDeclaration();
                assert(v);
                return v;
            }
            if (auto ie = e.isIndexExp())
                e = ie.e1;
            else if (auto dve = e.isDotVarExp())
                e = dve.e1;
            else if (auto dtie = e.isDotTemplateInstanceExp())
                e = dtie.e1;
            else if (auto se = e.isSliceExp())
                e = se.e1;
            else
                return null;
        }
    }

    extern (D) private проц interpretAssignCommon(BinExp e, fp_t fp, цел post = 0)
    {
        debug (LOG)
        {
            printf("%s BinExp::interpretAssignCommon() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        результат = CTFEExp.cantexp;

        Выражение e1 = e.e1;
        if (!istate)
        {
            e.выведиОшибку("значение of `%s` is not known at compile time", e1.вТкст0());
            return;
        }

        ++ctfeGlobals.numAssignments;

        /* Before we begin, we need to know if this is a reference assignment
         * (dynamic массив, AA, or class) or a значение assignment.
         * Determining this for slice assignments are tricky: we need to know
         * if it is a block assignment (a[] = e) rather than a direct slice
         * assignment (a[] = b[]). Note that initializers of multi-dimensional
         * static arrays can have 2D block assignments (eg, цел[7][7] x = 6;).
         * So we need to recurse to determine if it is a block assignment.
         */
        бул isBlockAssignment = нет;
        if (e1.op == ТОК2.slice)
        {
            // a[] = e can have const e. So we compare the naked types.
            Тип tdst = e1.тип.toBasetype();
            Тип tsrc = e.e2.тип.toBasetype();
            while (tdst.ty == Tsarray || tdst.ty == Tarray)
            {
                tdst = (cast(TypeArray)tdst).следщ.toBasetype();
                if (tsrc.equivalent(tdst))
                {
                    isBlockAssignment = да;
                    break;
                }
            }
        }

        // ---------------------------------------
        //      Deal with reference assignment
        // ---------------------------------------
        // If it is a construction of a ref variable, it is a ref assignment
        if ((e.op == ТОК2.construct || e.op == ТОК2.blit) &&
            ((cast(AssignExp)e).memset & MemorySet.referenceInit))
        {
            assert(!fp);

            Выражение newval = interpretRegion(e.e2, istate, ctfeNeedLvalue);
            if (exceptionOrCant(newval))
                return;

            VarDeclaration v = (cast(VarExp)e1).var.isVarDeclaration();
            setValue(v, newval);

            // Get the значение to return. Note that 'newval' is an Lvalue,
            // so if we need an Rvalue, we have to interpret again.
            if (goal == ctfeNeedRvalue)
                результат = interpretRegion(newval, istate);
            else
                результат = e1; // VarExp is a CTFE reference
            return;
        }

        if (fp)
        {
            while (e1.op == ТОК2.cast_)
            {
                CastExp ce = cast(CastExp)e1;
                e1 = ce.e1;
            }
        }

        // ---------------------------------------
        //      Interpret left hand side
        // ---------------------------------------
        AssocArrayLiteralExp existingAA = null;
        Выражение lastIndex = null;
        Выражение oldval = null;
        if (e1.op == ТОК2.index && (cast(IndexExp)e1).e1.тип.toBasetype().ty == Taarray)
        {
            // ---------------------------------------
            //      Deal with AA index assignment
            // ---------------------------------------
            /* This needs special treatment if the AA doesn't exist yet.
             * There are two special cases:
             * (1) If the AA is itself an index of another AA, we may need to создай
             *     multiple nested AA literals before we can вставь the new значение.
             * (2) If the ultimate AA is null, no insertion happens at all. Instead,
             *     we создай nested AA literals, and change it into a assignment.
             */
            IndexExp ie = cast(IndexExp)e1;
            цел depth = 0; // how many nested AA indices are there?
            while (ie.e1.op == ТОК2.index && (cast(IndexExp)ie.e1).e1.тип.toBasetype().ty == Taarray)
            {
                assert(ie.modifiable);
                ie = cast(IndexExp)ie.e1;
                ++depth;
            }

            // Get the AA значение to be modified.
            Выражение aggregate = interpretRegion(ie.e1, istate);
            if (exceptionOrCant(aggregate))
                return;
            if ((existingAA = aggregate.isAssocArrayLiteralExp()) !is null)
            {
                // Normal case, ultimate родитель AA already exists
                // We need to walk from the deepest index up, checking that an AA literal
                // already exists on each уровень.
                lastIndex = interpretRegion((cast(IndexExp)e1).e2, istate);
                lastIndex = resolveSlice(lastIndex); // only happens with AA assignment
                if (exceptionOrCant(lastIndex))
                    return;

                while (depth > 0)
                {
                    // Walk the syntax tree to найди the indexExp at this depth
                    IndexExp xe = cast(IndexExp)e1;
                    foreach (d; new бцел[0 .. depth])
                        xe = cast(IndexExp)xe.e1;

                    Выражение ekey = interpretRegion(xe.e2, istate);
                    if (exceptionOrCant(ekey))
                        return;
                    UnionExp ekeyTmp = проц;
                    ekey = resolveSlice(ekey, &ekeyTmp); // only happens with AA assignment

                    // Look up this index in it up in the existing AA, to get the следщ уровень of AA.
                    AssocArrayLiteralExp newAA = cast(AssocArrayLiteralExp)findKeyInAA(e.место, existingAA, ekey);
                    if (exceptionOrCant(newAA))
                        return;
                    if (!newAA)
                    {
                        // Doesn't exist yet, создай an empty AA...
                        auto keysx = new Выражения();
                        auto valuesx = new Выражения();
                        newAA = ctfeEmplaceExp!(AssocArrayLiteralExp)(e.место, keysx, valuesx);
                        newAA.тип = xe.тип;
                        newAA.ownedByCtfe = OwnedBy.ctfe;
                        //... and вставь it into the existing AA.
                        existingAA.keys.сунь(ekey);
                        existingAA.values.сунь(newAA);
                    }
                    existingAA = newAA;
                    --depth;
                }

                if (fp)
                {
                    oldval = findKeyInAA(e.место, existingAA, lastIndex);
                    if (!oldval)
                        oldval = copyLiteral(e.e1.тип.defaultInitLiteral(e.место)).копируй();
                }
            }
            else
            {
                /* The AA is currently null. 'aggregate' is actually a reference to
                 * whatever содержит it. It could be anything: var, dotvarexp, ...
                 * We rewrite the assignment from:
                 *     aa[i][j] op= newval;
                 * into:
                 *     aa = [i:[j:T.init]];
                 *     aa[j] op= newval;
                 */
                oldval = copyLiteral(e.e1.тип.defaultInitLiteral(e.место)).копируй();

                Выражение newaae = oldval;
                while (e1.op == ТОК2.index && (cast(IndexExp)e1).e1.тип.toBasetype().ty == Taarray)
                {
                    Выражение ekey = interpretRegion((cast(IndexExp)e1).e2, istate);
                    if (exceptionOrCant(ekey))
                        return;
                    ekey = resolveSlice(ekey); // only happens with AA assignment

                    auto keysx = new Выражения();
                    auto valuesx = new Выражения();
                    keysx.сунь(ekey);
                    valuesx.сунь(newaae);

                    auto aae = ctfeEmplaceExp!(AssocArrayLiteralExp)(e.место, keysx, valuesx);
                    aae.тип = (cast(IndexExp)e1).e1.тип;
                    aae.ownedByCtfe = OwnedBy.ctfe;
                    if (!existingAA)
                    {
                        existingAA = aae;
                        lastIndex = ekey;
                    }
                    newaae = aae;
                    e1 = (cast(IndexExp)e1).e1;
                }

                // We must set to aggregate with newaae
                e1 = interpretRegion(e1, istate, ctfeNeedLvalue);
                if (exceptionOrCant(e1))
                    return;
                e1 = assignToLvalue(e, e1, newaae);
                if (exceptionOrCant(e1))
                    return;
            }
            assert(existingAA && lastIndex);
            e1 = null; // stomp
        }
        else if (e1.op == ТОК2.arrayLength)
        {
            oldval = interpretRegion(e1, istate);
            if (exceptionOrCant(oldval))
                return;
        }
        else if (e.op == ТОК2.construct || e.op == ТОК2.blit)
        {
            // Unless we have a simple var assignment, we're
            // only modifying part of the variable. So we need to make sure
            // that the родитель variable exists.
            VarDeclaration ultimateVar = findParentVar(e1);
            if (auto ve = e1.isVarExp())
            {
                VarDeclaration v = ve.var.isVarDeclaration();
                assert(v);
                if (v.класс_хранения & STC.out_)
                    goto L1;
            }
            else if (ultimateVar && !дайЗначение(ultimateVar))
            {
                Выражение ex = interpretRegion(ultimateVar.тип.defaultInitLiteral(e.место), istate);
                if (exceptionOrCant(ex))
                    return;
                setValue(ultimateVar, ex);
            }
            else
                goto L1;
        }
        else
        {
        L1:
            e1 = interpretRegion(e1, istate, ctfeNeedLvalue);
            if (exceptionOrCant(e1))
                return;

            if (e1.op == ТОК2.index && (cast(IndexExp)e1).e1.тип.toBasetype().ty == Taarray)
            {
                IndexExp ie = cast(IndexExp)e1;
                assert(ie.e1.op == ТОК2.assocArrayLiteral);
                existingAA = cast(AssocArrayLiteralExp)ie.e1;
                lastIndex = ie.e2;
            }
        }

        // ---------------------------------------
        //      Interpret right hand side
        // ---------------------------------------
        Выражение newval = interpretRegion(e.e2, istate);
        if (exceptionOrCant(newval))
            return;
        if (e.op == ТОК2.blit && newval.op == ТОК2.int64)
        {
            Тип tbn = e.тип.baseElemOf();
            if (tbn.ty == Tstruct)
            {
                /* Look for special case of struct being initialized with 0.
                 */
                newval = e.тип.defaultInitLiteral(e.место);
                if (newval.op == ТОК2.error)
                {
                    результат = CTFEExp.cantexp;
                    return;
                }
                newval = interpretRegion(newval, istate); // копируй and set ownedByCtfe флаг
                if (exceptionOrCant(newval))
                    return;
            }
        }

        // ----------------------------------------------------
        //  Deal with читай-modify-пиши assignments.
        //  Set 'newval' to the final assignment значение
        //  Also determine the return значение (except for slice
        //  assignments, which are more complicated)
        // ----------------------------------------------------
        if (fp)
        {
            if (!oldval)
            {
                // Load the left hand side after interpreting the right hand side.
                oldval = interpretRegion(e1, istate);
                if (exceptionOrCant(oldval))
                    return;
            }

            if (e.e1.тип.ty != Tpointer)
            {
                // ~= can создай new values (see bug 6052)
                if (e.op == ТОК2.concatenateAssign || e.op == ТОК2.concatenateElemAssign || e.op == ТОК2.concatenateDcharAssign)
                {
                    // We need to dup it and repaint the тип. For a dynamic массив
                    // we can skip duplication, because it gets copied later anyway.
                    if (newval.тип.ty != Tarray)
                    {
                        newval = copyLiteral(newval).копируй();
                        newval.тип = e.e2.тип; // repaint тип
                    }
                    else
                    {
                        newval = paintTypeOntoLiteral(e.e2.тип, newval);
                        newval = resolveSlice(newval);
                    }
                }
                oldval = resolveSlice(oldval);

                newval = (*fp)(e.место, e.тип, oldval, newval).копируй();
            }
            else if (e.e2.тип.isintegral() &&
                     (e.op == ТОК2.addAssign ||
                      e.op == ТОК2.minAssign ||
                      e.op == ТОК2.plusPlus ||
                      e.op == ТОК2.minusMinus))
            {
                newval = pointerArithmetic(e.место, e.op, e.тип, oldval, newval).копируй();
            }
            else
            {
                e.выведиОшибку("pointer Выражение `%s` cannot be interpreted at compile time", e.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }
            if (exceptionOrCant(newval))
            {
                if (CTFEExp.isCantExp(newval))
                    e.выведиОшибку("cannot interpret `%s` at compile time", e.вТкст0());
                return;
            }
        }

        if (existingAA)
        {
            if (existingAA.ownedByCtfe != OwnedBy.ctfe)
            {
                e.выведиОшибку("cannot modify читай-only constant `%s`", existingAA.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }

            //printf("\t+L%d existingAA = %s, lastIndex = %s, oldval = %s, newval = %s\n",
            //    __LINE__, existingAA.вТкст0(), lastIndex.вТкст0(), oldval ? oldval.вТкст0() : NULL, newval.вТкст0());
            assignAssocArrayElement(e.место, existingAA, lastIndex, newval);

            // Determine the return значение
            результат = ctfeCast(pue, e.место, e.тип, e.тип, fp && post ? oldval : newval);
            return;
        }
        if (e1.op == ТОК2.arrayLength)
        {
            /* Change the assignment from:
             *  arr.length = n;
             * into:
             *  arr = new_length_array; (результат is n)
             */

            // Determine the return значение
            результат = ctfeCast(pue, e.место, e.тип, e.тип, fp && post ? oldval : newval);
            if (exceptionOrCant(результат))
                return;

            if (результат == pue.exp())
                результат = pue.копируй();

            т_мера oldlen = cast(т_мера)oldval.toInteger();
            т_мера newlen = cast(т_мера)newval.toInteger();
            if (oldlen == newlen) // no change required -- we're done!
                return;

            // We have changed it into a reference assignment
            // Note that returnValue is still the new length.
            e1 = (cast(ArrayLengthExp)e1).e1;
            Тип t = e1.тип.toBasetype();
            if (t.ty != Tarray)
            {
                e.выведиОшибку("`%s` is not yet supported at compile time", e.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }
            e1 = interpretRegion(e1, istate, ctfeNeedLvalue);
            if (exceptionOrCant(e1))
                return;

            if (oldlen != 0) // Get the old массив literal.
                oldval = interpretRegion(e1, istate);
            UnionExp utmp = проц;
            oldval = resolveSlice(oldval, &utmp);

            newval = changeArrayLiteralLength(e.место, cast(TypeArray)t, oldval, oldlen, newlen).копируй();

            e1 = assignToLvalue(e, e1, newval);
            if (exceptionOrCant(e1))
                return;

            return;
        }

        if (!isBlockAssignment)
        {
            newval = ctfeCast(pue, e.место, e.тип, e.тип, newval);
            if (exceptionOrCant(newval))
                return;
            if (newval == pue.exp())
                newval = pue.копируй();

            // Determine the return значение
            if (goal == ctfeNeedLvalue) // https://issues.dlang.org/show_bug.cgi?ид=14371
                результат = e1;
            else
            {
                результат = ctfeCast(pue, e.место, e.тип, e.тип, fp && post ? oldval : newval);
                if (результат == pue.exp())
                    результат = pue.копируй();
            }
            if (exceptionOrCant(результат))
                return;
        }
        if (exceptionOrCant(newval))
            return;

        debug (LOGASSIGN)
        {
            printf("ASSIGN: %s=%s\n", e1.вТкст0(), newval.вТкст0());
            showCtfeExpr(newval);
        }

        /* Block assignment or element-wise assignment.
         */
        if (e1.op == ТОК2.slice ||
            e1.op == ТОК2.vector ||
            e1.op == ТОК2.arrayLiteral ||
            e1.op == ТОК2.string_ ||
            e1.op == ТОК2.null_ && e1.тип.toBasetype().ty == Tarray)
        {
            // Note that slice assignments don't support things like ++, so
            // we don't need to remember 'returnValue'.
            результат = interpretAssignToSlice(pue, e, e1, newval, isBlockAssignment);
            if (exceptionOrCant(результат))
                return;
            if (auto se = e.e1.isSliceExp())
            {
                Выражение e1x = interpretRegion(se.e1, istate, ctfeNeedLvalue);
                if (auto dve = e1x.isDotVarExp())
                {
                    auto ex = dve.e1;
                    auto sle = ex.op == ТОК2.structLiteral ? (cast(StructLiteralExp)ex)
                             : ex.op == ТОК2.classReference ? (cast(ClassReferenceExp)ex).значение
                             : null;
                    auto v = dve.var.isVarDeclaration();
                    if (!sle || !v)
                    {
                        e.выведиОшибку("CTFE internal error: dotvar slice assignment");
                        результат = CTFEExp.cantexp;
                        return;
                    }
                    stompOverlappedFields(sle, v);
                }
            }
            return;
        }
        assert(результат);

        /* Assignment to a CTFE reference.
         */
        if (Выражение ex = assignToLvalue(e, e1, newval))
            результат = ex;

        return;
    }

    /* Set all sibling fields which overlap with v to VoidExp.
     */
    private проц stompOverlappedFields(StructLiteralExp sle, VarDeclaration v)
    {
        if (!v.overlapped)
            return;
        foreach (т_мера i, v2; sle.sd.fields)
        {
            if (v is v2 || !v.isOverlappedWith(v2))
                continue;
            auto e = (*sle.elements)[i];
            if (e.op != ТОК2.void_)
                (*sle.elements)[i] = voidInitLiteral(e.тип, v).копируй();
        }
    }

    private Выражение assignToLvalue(BinExp e, Выражение e1, Выражение newval)
    {
        VarDeclaration vd = null;
        Выражение* payload = null; // dead-store to prevent spurious warning
        Выражение oldval;
        цел from;

        if (auto ve = e1.isVarExp())
        {
            vd = ve.var.isVarDeclaration();
            oldval = дайЗначение(vd);
        }
        else if (auto dve = e1.isDotVarExp())
        {
            /* Assignment to member variable of the form:
             *  e.v = newval
             */
            auto ex = dve.e1;
            auto sle = ex.op == ТОК2.structLiteral ? (cast(StructLiteralExp)ex)
                     : ex.op == ТОК2.classReference ? (cast(ClassReferenceExp)ex).значение
                     : null;
            auto v = (cast(DotVarExp)e1).var.isVarDeclaration();
            if (!sle || !v)
            {
                e.выведиОшибку("CTFE internal error: dotvar assignment");
                return CTFEExp.cantexp;
            }
            if (sle.ownedByCtfe != OwnedBy.ctfe)
            {
                e.выведиОшибку("cannot modify читай-only constant `%s`", sle.вТкст0());
                return CTFEExp.cantexp;
            }

            цел fieldi = ex.op == ТОК2.structLiteral ? findFieldIndexByName(sle.sd, v)
                       : (cast(ClassReferenceExp)ex).findFieldIndexByName(v);
            if (fieldi == -1)
            {
                e.выведиОшибку("CTFE internal error: cannot найди field `%s` in `%s`", v.вТкст0(), ex.вТкст0());
                return CTFEExp.cantexp;
            }
            assert(0 <= fieldi && fieldi < sle.elements.dim);

            // If it's a union, set all other члены of this union to проц
            stompOverlappedFields(sle, v);

            payload = &(*sle.elements)[fieldi];
            oldval = *payload;
        }
        else if (auto ie = e1.isIndexExp())
        {
            assert(ie.e1.тип.toBasetype().ty != Taarray);

            Выражение aggregate;
            uinteger_t indexToModify;
            if (!resolveIndexing(ie, istate, &aggregate, &indexToModify, да))
            {
                return CTFEExp.cantexp;
            }
            т_мера index = cast(т_мера)indexToModify;

            if (auto existingSE = aggregate.isStringExp())
            {
                if (existingSE.ownedByCtfe != OwnedBy.ctfe)
                {
                    e.выведиОшибку("cannot modify читай-only ткст literal `%s`", ie.e1.вТкст0());
                    return CTFEExp.cantexp;
                }
                existingSE.setCodeUnit(index, cast(dchar)newval.toInteger());
                return null;
            }
            if (aggregate.op != ТОК2.arrayLiteral)
            {
                e.выведиОшибку("index assignment `%s` is not yet supported in CTFE ", e.вТкст0());
                return CTFEExp.cantexp;
            }

            ArrayLiteralExp existingAE = cast(ArrayLiteralExp)aggregate;
            if (existingAE.ownedByCtfe != OwnedBy.ctfe)
            {
                e.выведиОшибку("cannot modify читай-only constant `%s`", existingAE.вТкст0());
                return CTFEExp.cantexp;
            }

            payload = &(*existingAE.elements)[index];
            oldval = *payload;
        }
        else
        {
            e.выведиОшибку("`%s` cannot be evaluated at compile time", e.вТкст0());
            return CTFEExp.cantexp;
        }

        Тип t1b = e1.тип.toBasetype();
        бул wantCopy = t1b.baseElemOf().ty == Tstruct;

        if (newval.op == ТОК2.structLiteral && oldval)
        {
            assert(oldval.op == ТОК2.structLiteral || oldval.op == ТОК2.arrayLiteral || oldval.op == ТОК2.string_);
            newval = copyLiteral(newval).копируй();
            assignInPlace(oldval, newval);
        }
        else if (wantCopy && e.op == ТОК2.assign)
        {
            // Currently postblit/destructor calls on static массив are done
            // in the druntime internal functions so they don't appear in AST.
            // Therefore interpreter should handle them specially.

            assert(oldval);
            version (all) // todo: instead we can directly access to each elements of the slice
            {
                newval = resolveSlice(newval);
                if (CTFEExp.isCantExp(newval))
                {
                    e.выведиОшибку("CTFE internal error: assignment `%s`", e.вТкст0());
                    return CTFEExp.cantexp;
                }
            }
            assert(oldval.op == ТОК2.arrayLiteral);
            assert(newval.op == ТОК2.arrayLiteral);

            Выражения* oldelems = (cast(ArrayLiteralExp)oldval).elements;
            Выражения* newelems = (cast(ArrayLiteralExp)newval).elements;
            assert(oldelems.dim == newelems.dim);

            Тип elemtype = oldval.тип.nextOf();
            foreach (i, ref oldelem; *oldelems)
            {
                Выражение newelem = paintTypeOntoLiteral(elemtype, (*newelems)[i]);
                // https://issues.dlang.org/show_bug.cgi?ид=9245
                if (e.e2.isLvalue())
                {
                    if (Выражение ex = evaluatePostblit(istate, newelem))
                        return ex;
                }
                // https://issues.dlang.org/show_bug.cgi?ид=13661
                if (Выражение ex = evaluateDtor(istate, oldelem))
                    return ex;
                oldelem = newelem;
            }
        }
        else
        {
            // e1 has its own payload, so we have to создай a new literal.
            if (wantCopy)
                newval = copyLiteral(newval).копируй();

            if (t1b.ty == Tsarray && e.op == ТОК2.construct && e.e2.isLvalue())
            {
                // https://issues.dlang.org/show_bug.cgi?ид=9245
                if (Выражение ex = evaluatePostblit(istate, newval))
                    return ex;
            }

            oldval = newval;
        }

        if (vd)
            setValue(vd, oldval);
        else
            *payload = oldval;

        // Blit assignment should return the newly created значение.
        if (e.op == ТОК2.blit)
            return oldval;

        return null;
    }

    /*************
     * Deal with assignments of the form:
     *  dest[] = newval
     *  dest[low..upp] = newval
     * where newval has already been interpreted
     *
     * This could be a slice assignment or a block assignment, and
     * dest could be either an массив literal, or a ткст.
     *
     * Возвращает ТОК2.cantВыражение on failure. If there are no errors,
     * it returns aggregate[low..upp], except that as an optimisation,
     * if goal == ctfeNeedNothing, it will return NULL
     */
    private Выражение interpretAssignToSlice(UnionExp* pue, BinExp e, Выражение e1, Выражение newval, бул isBlockAssignment)
    {
        dinteger_t lowerbound;
        dinteger_t upperbound;
        dinteger_t firstIndex;

        Выражение aggregate;

        if (auto se = e1.isSliceExp())
        {
            // ------------------------------
            //   aggregate[] = newval
            //   aggregate[low..upp] = newval
            // ------------------------------
            version (all) // should be move in interpretAssignCommon as the evaluation of e1
            {
                Выражение oldval = interpretRegion(se.e1, istate);

                // Set the $ variable
                uinteger_t dollar = resolveArrayLength(oldval);
                if (se.lengthVar)
                {
                    Выражение dollarExp = ctfeEmplaceExp!(IntegerExp)(e1.место, dollar, Тип.tт_мера);
                    ctfeGlobals.stack.сунь(se.lengthVar);
                    setValue(se.lengthVar, dollarExp);
                }
                Выражение lwr = interpretRegion(se.lwr, istate);
                if (exceptionOrCantInterpret(lwr))
                {
                    if (se.lengthVar)
                        ctfeGlobals.stack.вынь(se.lengthVar);
                    return lwr;
                }
                Выражение upr = interpretRegion(se.upr, istate);
                if (exceptionOrCantInterpret(upr))
                {
                    if (se.lengthVar)
                        ctfeGlobals.stack.вынь(se.lengthVar);
                    return upr;
                }
                if (se.lengthVar)
                    ctfeGlobals.stack.вынь(se.lengthVar); // $ is defined only in [L..U]

                const dim = dollar;
                lowerbound = lwr ? lwr.toInteger() : 0;
                upperbound = upr ? upr.toInteger() : dim;

                if (lowerbound < 0 || dim < upperbound)
                {
                    e.выведиОшибку("массив bounds `[0..%llu]` exceeded in slice `[%llu..%llu]`",
                        cast(бдол)dim, cast(бдол)lowerbound, cast(бдол)upperbound);
                    return CTFEExp.cantexp;
                }
            }
            aggregate = oldval;
            firstIndex = lowerbound;

            if (auto oldse = aggregate.isSliceExp())
            {
                // Slice of a slice --> change the bounds
                if (oldse.upr.toInteger() < upperbound + oldse.lwr.toInteger())
                {
                    e.выведиОшибку("slice `[%llu..%llu]` exceeds массив bounds `[0..%llu]`",
                        cast(бдол)lowerbound, cast(бдол)upperbound, oldse.upr.toInteger() - oldse.lwr.toInteger());
                    return CTFEExp.cantexp;
                }
                aggregate = oldse.e1;
                firstIndex = lowerbound + oldse.lwr.toInteger();
            }
        }
        else
        {
            if (auto ale = e1.isArrayLiteralExp())
            {
                lowerbound = 0;
                upperbound = ale.elements.dim;
            }
            else if (auto se = e1.isStringExp())
            {
                lowerbound = 0;
                upperbound = se.len;
            }
            else if (e1.op == ТОК2.null_)
            {
                lowerbound = 0;
                upperbound = 0;
            }
            else if (VectorExp ve = e1.isVectorExp())
            {
                // ve is not handled but a proper error message is returned
                // this is to prevent https://issues.dlang.org/show_bug.cgi?ид=20042
                lowerbound = 0;
                upperbound = ve.dim;
            }
            else
                assert(0);

            aggregate = e1;
            firstIndex = lowerbound;
        }
        if (upperbound == lowerbound)
            return newval;

        // For slice assignment, we check that the lengths match.
        if (!isBlockAssignment)
        {
            const srclen = resolveArrayLength(newval);
            if (srclen != (upperbound - lowerbound))
            {
                e.выведиОшибку("массив length mismatch assigning `[0..%llu]` to `[%llu..%llu]`",
                    cast(бдол)srclen, cast(бдол)lowerbound, cast(бдол)upperbound);
                return CTFEExp.cantexp;
            }
        }

        if (auto existingSE = aggregate.isStringExp())
        {
            if (existingSE.ownedByCtfe != OwnedBy.ctfe)
            {
                e.выведиОшибку("cannot modify читай-only ткст literal `%s`", existingSE.вТкст0());
                return CTFEExp.cantexp;
            }

            if (auto se = newval.isSliceExp())
            {
                auto aggr2 = se.e1;
                const srclower = se.lwr.toInteger();
                const srcupper = se.upr.toInteger();

                if (aggregate == aggr2 &&
                    lowerbound < srcupper && srclower < upperbound)
                {
                    e.выведиОшибку("overlapping slice assignment `[%llu..%llu] = [%llu..%llu]`",
                        cast(бдол)lowerbound, cast(бдол)upperbound, cast(бдол)srclower, cast(бдол)srcupper);
                    return CTFEExp.cantexp;
                }
                version (all) // todo: instead we can directly access to each elements of the slice
                {
                    Выражение orignewval = newval;
                    newval = resolveSlice(newval);
                    if (CTFEExp.isCantExp(newval))
                    {
                        e.выведиОшибку("CTFE internal error: slice `%s`", orignewval.вТкст0());
                        return CTFEExp.cantexp;
                    }
                }
                assert(newval.op != ТОК2.slice);
            }
            if (auto se = newval.isStringExp())
            {
                sliceAssignStringFromString(existingSE, se, cast(т_мера)firstIndex);
                return newval;
            }
            if (auto ale = newval.isArrayLiteralExp())
            {
                /* Mixed slice: it was initialized as a ткст literal.
                 * Now a slice of it is being set with an массив literal.
                 */
                sliceAssignStringFromArrayLiteral(existingSE, ale, cast(т_мера)firstIndex);
                return newval;
            }

            // String literal block slice assign
            const значение = cast(dchar)newval.toInteger();
            foreach (i; new бцел[0 .. upperbound - lowerbound])
            {
                existingSE.setCodeUnit(cast(т_мера)(i + firstIndex), значение);
            }
            if (goal == ctfeNeedNothing)
                return null; // avoid creating an unused literal
            auto retslice = ctfeEmplaceExp!(SliceExp)(e.место, existingSE,
                        ctfeEmplaceExp!(IntegerExp)(e.место, firstIndex, Тип.tт_мера),
                        ctfeEmplaceExp!(IntegerExp)(e.место, firstIndex + upperbound - lowerbound, Тип.tт_мера));
            retslice.тип = e.тип;
            return interpret(pue, retslice, istate);
        }
        if (auto existingAE = aggregate.isArrayLiteralExp())
        {
            if (existingAE.ownedByCtfe != OwnedBy.ctfe)
            {
                e.выведиОшибку("cannot modify читай-only constant `%s`", existingAE.вТкст0());
                return CTFEExp.cantexp;
            }

            if (newval.op == ТОК2.slice && !isBlockAssignment)
            {
                auto se = cast(SliceExp)newval;
                auto aggr2 = se.e1;
                const srclower = se.lwr.toInteger();
                const srcupper = se.upr.toInteger();
                const wantCopy = (newval.тип.toBasetype().nextOf().baseElemOf().ty == Tstruct);

                //printf("oldval = %p %s[%d..%u]\nnewval = %p %s[%llu..%llu] wantCopy = %d\n",
                //    aggregate, aggregate.вТкст0(), lowerbound, upperbound,
                //    aggr2, aggr2.вТкст0(), srclower, srcupper, wantCopy);
                if (wantCopy)
                {
                    // Currently overlapping for struct массив is allowed.
                    // The order of elements processing depends on the overlapping.
                    // https://issues.dlang.org/show_bug.cgi?ид=14024
                    assert(aggr2.op == ТОК2.arrayLiteral);
                    Выражения* oldelems = existingAE.elements;
                    Выражения* newelems = (cast(ArrayLiteralExp)aggr2).elements;

                    Тип elemtype = aggregate.тип.nextOf();
                    бул needsPostblit = e.e2.isLvalue();

                    if (aggregate == aggr2 && srclower < lowerbound && lowerbound < srcupper)
                    {
                        // reverse order
                        for (auto i = upperbound - lowerbound; 0 < i--;)
                        {
                            Выражение oldelem = (*oldelems)[cast(т_мера)(i + firstIndex)];
                            Выражение newelem = (*newelems)[cast(т_мера)(i + srclower)];
                            newelem = copyLiteral(newelem).копируй();
                            newelem.тип = elemtype;
                            if (needsPostblit)
                            {
                                if (Выражение x = evaluatePostblit(istate, newelem))
                                    return x;
                            }
                            if (Выражение x = evaluateDtor(istate, oldelem))
                                return x;
                            (*oldelems)[cast(т_мера)(lowerbound + i)] = newelem;
                        }
                    }
                    else
                    {
                        // normal order
                        for (auto i = 0; i < upperbound - lowerbound; i++)
                        {
                            Выражение oldelem = (*oldelems)[cast(т_мера)(i + firstIndex)];
                            Выражение newelem = (*newelems)[cast(т_мера)(i + srclower)];
                            newelem = copyLiteral(newelem).копируй();
                            newelem.тип = elemtype;
                            if (needsPostblit)
                            {
                                if (Выражение x = evaluatePostblit(istate, newelem))
                                    return x;
                            }
                            if (Выражение x = evaluateDtor(istate, oldelem))
                                return x;
                            (*oldelems)[cast(т_мера)(lowerbound + i)] = newelem;
                        }
                    }

                    //assert(0);
                    return newval; // oldval?
                }
                if (aggregate == aggr2 &&
                    lowerbound < srcupper && srclower < upperbound)
                {
                    e.выведиОшибку("overlapping slice assignment `[%llu..%llu] = [%llu..%llu]`",
                        cast(бдол)lowerbound, cast(бдол)upperbound, cast(бдол)srclower, cast(бдол)srcupper);
                    return CTFEExp.cantexp;
                }
                version (all) // todo: instead we can directly access to each elements of the slice
                {
                    Выражение orignewval = newval;
                    newval = resolveSlice(newval);
                    if (CTFEExp.isCantExp(newval))
                    {
                        e.выведиОшибку("CTFE internal error: slice `%s`", orignewval.вТкст0());
                        return CTFEExp.cantexp;
                    }
                }
                // no overlapping
                //length?
                assert(newval.op != ТОК2.slice);
            }
            if (newval.op == ТОК2.string_ && !isBlockAssignment)
            {
                /* Mixed slice: it was initialized as an массив literal of chars/integers.
                 * Now a slice of it is being set with a ткст.
                 */
                sliceAssignArrayLiteralFromString(existingAE, cast(StringExp)newval, cast(т_мера)firstIndex);
                return newval;
            }
            if (newval.op == ТОК2.arrayLiteral && !isBlockAssignment)
            {
                Выражения* oldelems = existingAE.elements;
                Выражения* newelems = (cast(ArrayLiteralExp)newval).elements;
                Тип elemtype = existingAE.тип.nextOf();
                бул needsPostblit = e.op != ТОК2.blit && e.e2.isLvalue();
                foreach (j, newelem; *newelems)
                {
                    newelem = paintTypeOntoLiteral(elemtype, newelem);
                    if (needsPostblit)
                    {
                        Выражение x = evaluatePostblit(istate, newelem);
                        if (exceptionOrCantInterpret(x))
                            return x;
                    }
                    (*oldelems)[cast(т_мера)(j + firstIndex)] = newelem;
                }
                return newval;
            }

            /* Block assignment, initialization of static arrays
             *   x[] = newval
             *  x may be a multidimensional static массив. (Note that this
             *  only happens with массив literals, never with strings).
             */
            struct RecursiveBlock
            {
                InterState* istate;
                Выражение newval;
                бул refCopy;
                бул needsPostblit;
                бул needsDtor;

                 Выражение assignTo(ArrayLiteralExp ae)
                {
                    return assignTo(ae, 0, ae.elements.dim);
                }

                 Выражение assignTo(ArrayLiteralExp ae, т_мера lwr, т_мера upr)
                {
                    Выражения* w = ae.elements;
                    assert(ae.тип.ty == Tsarray || ae.тип.ty == Tarray);
                    бул directblk = (cast(TypeArray)ae.тип).следщ.equivalent(newval.тип);
                    for (т_мера k = lwr; k < upr; k++)
                    {
                        if (!directblk && (*w)[k].op == ТОК2.arrayLiteral)
                        {
                            // Multidimensional массив block assign
                            if (Выражение ex = assignTo(cast(ArrayLiteralExp)(*w)[k]))
                                return ex;
                        }
                        else if (refCopy)
                        {
                            (*w)[k] = newval;
                        }
                        else if (!needsPostblit && !needsDtor)
                        {
                            assignInPlace((*w)[k], newval);
                        }
                        else
                        {
                            Выражение oldelem = (*w)[k];
                            Выражение tmpelem = needsDtor ? copyLiteral(oldelem).копируй() : null;
                            assignInPlace(oldelem, newval);
                            if (needsPostblit)
                            {
                                if (Выражение ex = evaluatePostblit(istate, oldelem))
                                    return ex;
                            }
                            if (needsDtor)
                            {
                                // https://issues.dlang.org/show_bug.cgi?ид=14860
                                if (Выражение ex = evaluateDtor(istate, tmpelem))
                                    return ex;
                            }
                        }
                    }
                    return null;
                }
            }

            Тип tn = newval.тип.toBasetype();
            бул wantRef = (tn.ty == Tarray || isAssocArray(tn) || tn.ty == Tclass);
            бул cow = newval.op != ТОК2.structLiteral && newval.op != ТОК2.arrayLiteral && newval.op != ТОК2.string_;
            Тип tb = tn.baseElemOf();
            StructDeclaration sd = (tb.ty == Tstruct ? (cast(TypeStruct)tb).sym : null);

            RecursiveBlock rb;
            rb.istate = istate;
            rb.newval = newval;
            rb.refCopy = wantRef || cow;
            rb.needsPostblit = sd && sd.postblit && e.op != ТОК2.blit && e.e2.isLvalue();
            rb.needsDtor = sd && sd.dtor && e.op == ТОК2.assign;
            if (Выражение ex = rb.assignTo(existingAE, cast(т_мера)lowerbound, cast(т_мера)upperbound))
                return ex;

            if (goal == ctfeNeedNothing)
                return null; // avoid creating an unused literal
            auto retslice = ctfeEmplaceExp!(SliceExp)(e.место, existingAE,
                ctfeEmplaceExp!(IntegerExp)(e.место, firstIndex, Тип.tт_мера),
                ctfeEmplaceExp!(IntegerExp)(e.место, firstIndex + upperbound - lowerbound, Тип.tт_мера));
            retslice.тип = e.тип;
            return interpret(pue, retslice, istate);
        }

        e.выведиОшибку("slice operation `%s = %s` cannot be evaluated at compile time", e1.вТкст0(), newval.вТкст0());
        return CTFEExp.cantexp;
    }

    override проц посети(AssignExp e)
    {
        interpretAssignCommon(e, null);
    }

    override проц посети(BinAssignExp e)
    {
        switch (e.op)
        {
        case ТОК2.addAssign:
            interpretAssignCommon(e, &Add);
            return;

        case ТОК2.minAssign:
            interpretAssignCommon(e, &Min);
            return;

        case ТОК2.concatenateAssign:
        case ТОК2.concatenateElemAssign:
        case ТОК2.concatenateDcharAssign:
            interpretAssignCommon(e, &ctfeCat);
            return;

        case ТОК2.mulAssign:
            interpretAssignCommon(e, &Mul);
            return;

        case ТОК2.divAssign:
            interpretAssignCommon(e, &Div);
            return;

        case ТОК2.modAssign:
            interpretAssignCommon(e, &Mod);
            return;

        case ТОК2.leftShiftAssign:
            interpretAssignCommon(e, &Shl);
            return;

        case ТОК2.rightShiftAssign:
            interpretAssignCommon(e, &Shr);
            return;

        case ТОК2.unsignedRightShiftAssign:
            interpretAssignCommon(e, &Ushr);
            return;

        case ТОК2.andAssign:
            interpretAssignCommon(e, &And);
            return;

        case ТОК2.orAssign:
            interpretAssignCommon(e, &Or);
            return;

        case ТОК2.xorAssign:
            interpretAssignCommon(e, &Xor);
            return;

        case ТОК2.powAssign:
            interpretAssignCommon(e, &Pow);
            return;

        default:
            assert(0);
        }
    }

    override проц посети(PostExp e)
    {
        debug (LOG)
        {
            printf("%s PostExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        if (e.op == ТОК2.plusPlus)
            interpretAssignCommon(e, &Add, 1);
        else
            interpretAssignCommon(e, &Min, 1);
        debug (LOG)
        {
            if (CTFEExp.isCantExp(результат))
                printf("PostExp::interpret() CANT\n");
        }
    }

    /* Return 1 if e is a p1 > p2 or p1 >= p2 pointer comparison;
     *       -1 if e is a p1 < p2 or p1 <= p2 pointer comparison;
     *        0 otherwise
     */
    static цел isPointerCmpExp(Выражение e, Выражение* p1, Выражение* p2)
    {
        цел ret = 1;
        while (e.op == ТОК2.not)
        {
            ret *= -1;
            e = (cast(NotExp)e).e1;
        }
        switch (e.op)
        {
        case ТОК2.lessThan:
        case ТОК2.lessOrEqual:
            ret *= -1;
            goto case; /+ fall through +/
        case ТОК2.greaterThan:
        case ТОК2.greaterOrEqual:
            *p1 = (cast(BinExp)e).e1;
            *p2 = (cast(BinExp)e).e2;
            if (!(isPointer((*p1).тип) && isPointer((*p2).тип)))
                ret = 0;
            break;

        default:
            ret = 0;
            break;
        }
        return ret;
    }

    /** If this is a four pointer relation, evaluate it, else return NULL.
     *
     *  This is an Выражение of the form (p1 > q1 && p2 < q2) or (p1 < q1 || p2 > q2)
     *  where p1, p2 are Выражения yielding pointers to memory block p,
     *  and q1, q2 are Выражения yielding pointers to memory block q.
     *  This Выражение is valid even if p and q are independent memory
     *  blocks and are therefore not normally comparable; the && form returns да
     *  if [p1..p2] lies inside [q1..q2], and нет otherwise; the || form returns
     *  да if [p1..p2] lies outside [q1..q2], and нет otherwise.
     *
     *  Within the Выражение, any ordering of p1, p2, q1, q2 is permissible;
     *  the comparison operators can be any of >, <, <=, >=, provided that
     *  both directions (p > q and p < q) are checked. Additionally the
     *  relational sub-Выражения can be negated, eg
     *  (!(q1 < p1) && p2 <= q2) is valid.
     */
    private проц interpretFourPointerRelation(UnionExp* pue, BinExp e)
    {
        assert(e.op == ТОК2.andAnd || e.op == ТОК2.orOr);

        /*  It can only be an isInside Выражение, if both e1 and e2 are
         *  directional pointer comparisons.
         *  Note that this check can be made statically; it does not depends on
         *  any runtime values. This allows a JIT implementation to compile a
         *  special AndAndPossiblyInside, keeping the normal AndAnd case efficient.
         */

        // Save the pointer Выражения and the comparison directions,
        // so we can use them later.
        Выражение p1 = null;
        Выражение p2 = null;
        Выражение p3 = null;
        Выражение p4 = null;
        цел dir1 = isPointerCmpExp(e.e1, &p1, &p2);
        цел dir2 = isPointerCmpExp(e.e2, &p3, &p4);
        if (dir1 == 0 || dir2 == 0)
        {
            результат = null;
            return;
        }

        //printf("FourPointerRelation %s\n", вТкст0());

        UnionExp ue1 = проц;
        UnionExp ue2 = проц;
        UnionExp ue3 = проц;
        UnionExp ue4 = проц;

        // Evaluate the first two pointers
        p1 = interpret(&ue1, p1, istate);
        if (exceptionOrCant(p1))
            return;
        p2 = interpret(&ue2, p2, istate);
        if (exceptionOrCant(p2))
            return;
        dinteger_t ofs1, ofs2;
        Выражение agg1 = getAggregateFromPointer(p1, &ofs1);
        Выражение agg2 = getAggregateFromPointer(p2, &ofs2);

        if (!pointToSameMemoryBlock(agg1, agg2) && agg1.op != ТОК2.null_ && agg2.op != ТОК2.null_)
        {
            // Here it is either CANT_INTERPRET,
            // or an IsInside comparison returning нет.
            p3 = interpret(&ue3, p3, istate);
            if (CTFEExp.isCantExp(p3))
                return;
            // Note that it is NOT legal for it to throw an exception!
            Выражение except = null;
            if (exceptionOrCantInterpret(p3))
                except = p3;
            else
            {
                p4 = interpret(&ue4, p4, istate);
                if (CTFEExp.isCantExp(p4))
                {
                    результат = p4;
                    return;
                }
                if (exceptionOrCantInterpret(p4))
                    except = p4;
            }
            if (except)
            {
                e.выведиОшибку("comparison `%s` of pointers to unrelated memory blocks remains indeterminate at compile time because exception `%s` was thrown while evaluating `%s`", e.e1.вТкст0(), except.вТкст0(), e.e2.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }
            dinteger_t ofs3, ofs4;
            Выражение agg3 = getAggregateFromPointer(p3, &ofs3);
            Выражение agg4 = getAggregateFromPointer(p4, &ofs4);
            // The valid cases are:
            // p1 > p2 && p3 > p4  (same direction, also for < && <)
            // p1 > p2 && p3 < p4  (different direction, also < && >)
            // Changing any > into >= doesn't affect the результат
            if ((dir1 == dir2 && pointToSameMemoryBlock(agg1, agg4) && pointToSameMemoryBlock(agg2, agg3)) ||
                (dir1 != dir2 && pointToSameMemoryBlock(agg1, agg3) && pointToSameMemoryBlock(agg2, agg4)))
            {
                // it's a legal two-sided comparison
                emplaceExp!(IntegerExp)(pue, e.место, (e.op == ТОК2.andAnd) ? 0 : 1, e.тип);
                результат = pue.exp();
                return;
            }
            // It's an invalid four-pointer comparison. Either the second
            // comparison is in the same direction as the first, or else
            // more than two memory blocks are involved (either two independent
            // invalid comparisons are present, or else agg3 == agg4).
            e.выведиОшибку("comparison `%s` of pointers to unrelated memory blocks is indeterminate at compile time, even when combined with `%s`.", e.e1.вТкст0(), e.e2.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }
        // The first pointer Выражение didn't need special treatment, so we
        // we need to interpret the entire Выражение exactly as a normal && or ||.
        // This is easy because we haven't evaluated e2 at all yet, and we already
        // know it will return a бул.
        // But we mustn't evaluate the pointer Выражения in e1 again, in case
        // they have side-effects.
        бул nott = нет;
        Выражение ex = e.e1;
        while (1)
        {
            if (auto ne = ex.isNotExp())
            {
                nott = !nott;
                ex = ne.e1;
            }
            else
                break;
        }

        /** Negate relational operator, eg >= becomes <
         * Параметры:
         *      op = comparison operator to negate
         * Возвращает:
         *      negate operator
         */
        static ТОК2 negateRelation(ТОК2 op) 
        {
            switch (op)
            {
                case ТОК2.greaterOrEqual:  op = ТОК2.lessThan;       break;
                case ТОК2.greaterThan:     op = ТОК2.lessOrEqual;    break;
                case ТОК2.lessOrEqual:     op = ТОК2.greaterThan;    break;
                case ТОК2.lessThan:        op = ТОК2.greaterOrEqual; break;
                default:                  assert(0);
            }
            return op;
        }

        const ТОК2 cmpop = nott ? negateRelation(ex.op) : ex.op;
        const cmp = comparePointers(cmpop, agg1, ofs1, agg2, ofs2);
        // We already know this is a valid comparison.
        assert(cmp >= 0);
        if (e.op == ТОК2.andAnd && cmp == 1 || e.op == ТОК2.orOr && cmp == 0)
        {
            результат = interpret(pue, e.e2, istate);
            return;
        }
        emplaceExp!(IntegerExp)(pue, e.место, (e.op == ТОК2.andAnd) ? 0 : 1, e.тип);
        результат = pue.exp();
    }

    override проц посети(LogicalExp e)
    {
        debug (LOG)
        {
            printf("%s LogicalExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        // Check for an insidePointer Выражение, evaluate it if so
        interpretFourPointerRelation(pue, e);
        if (результат)
            return;

        UnionExp ue1 = проц;
        результат = interpret(&ue1, e.e1, istate);
        if (exceptionOrCant(результат))
            return;

        бул res;
        const andand = e.op == ТОК2.andAnd;
        if (andand ? результат.isBool(нет) : isTrueBool(результат))
            res = !andand;
        else if (andand ? isTrueBool(результат) : результат.isBool(нет))
        {
            UnionExp ue2 = проц;
            результат = interpret(&ue2, e.e2, istate);
            if (exceptionOrCant(результат))
                return;
            if (результат.op == ТОК2.voidВыражение)
            {
                assert(e.тип.ty == Tvoid);
                результат = null;
                return;
            }
            if (результат.isBool(нет))
                res = нет;
            else if (isTrueBool(результат))
                res = да;
            else
            {
                e.выведиОшибку("`%s` does not evaluate to a `бул`", результат.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }
        }
        else
        {
            e.выведиОшибку("`%s` cannot be interpreted as a `бул`", результат.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }
        if (goal != ctfeNeedNothing)
        {
            if (e.тип.равен(Тип.tбул))
                результат = IntegerExp.createBool(res);
            else
            {
                emplaceExp!(IntegerExp)(pue, e.место, res, e.тип);
                результат = pue.exp();
            }
        }
    }


    // Print a stack trace, starting from callingExp which called fd.
    // To shorten the stack trace, try to detect recursion.
    private проц showCtfeBackTrace(CallExp callingExp, FuncDeclaration fd)
    {
        if (ctfeGlobals.stackTraceCallsToSuppress > 0)
        {
            --ctfeGlobals.stackTraceCallsToSuppress;
            return;
        }
        errorSupplemental(callingExp.место, "called from here: `%s`", callingExp.вТкст0());
        // Quit if it's not worth trying to compress the stack trace
        if (ctfeGlobals.callDepth < 6 || глоб2.парамы.verbose)
            return;
        // Recursion happens if the current function already exists in the call stack.
        цел numToSuppress = 0;
        цел recurseCount = 0;
        цел depthSoFar = 0;
        InterState* lastRecurse = istate;
        for (InterState* cur = istate; cur; cur = cur.caller)
        {
            if (cur.fd == fd)
            {
                ++recurseCount;
                numToSuppress = depthSoFar;
                lastRecurse = cur;
            }
            ++depthSoFar;
        }
        // We need at least three calls to the same function, to make compression worthwhile
        if (recurseCount < 2)
            return;
        // We found a useful recursion.  Print all the calls involved in the recursion
        errorSupplemental(fd.место, "%d recursive calls to function `%s`", recurseCount, fd.вТкст0());
        for (InterState* cur = istate; cur.fd != fd; cur = cur.caller)
        {
            errorSupplemental(cur.fd.место, "recursively called from function `%s`", cur.fd.вТкст0());
        }
        // We probably didn't enter the recursion in this function.
        // Go deeper to найди the real beginning.
        InterState* cur = istate;
        while (lastRecurse.caller && cur.fd == lastRecurse.caller.fd)
        {
            cur = cur.caller;
            lastRecurse = lastRecurse.caller;
            ++numToSuppress;
        }
        ctfeGlobals.stackTraceCallsToSuppress = numToSuppress;
    }

    override проц посети(CallExp e)
    {
        debug (LOG)
        {
            printf("%s CallExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        Выражение pthis = null;
        FuncDeclaration fd = null;

        Выражение ecall = interpretRegion(e.e1, istate);
        if (exceptionOrCant(ecall))
            return;

        if (auto dve = ecall.isDotVarExp())
        {
            // Calling a member function
            pthis = dve.e1;
            fd = dve.var.isFuncDeclaration();
            assert(fd);

            if (auto dte = pthis.isDotTypeExp())
                pthis = dte.e1;
        }
        else if (auto ve = ecall.isVarExp())
        {
            fd = ve.var.isFuncDeclaration();
            assert(fd);

            // If `_d_HookTraceImpl` is found, resolve the underlying hook and replace `e` and `fd` with it.
            removeHookTraceImpl(e, fd);

            if (fd.идент == Id.__МассивPostblit || fd.идент == Id.__МассивDtor)
            {
                assert(e.arguments.dim == 1);
                Выражение ea = (*e.arguments)[0];
                // printf("1 ea = %s %s\n", ea.тип.вТкст0(), ea.вТкст0());
                if (auto se = ea.isSliceExp())
                    ea = se.e1;
                if (auto ce = ea.isCastExp())
                    ea = ce.e1;

                // printf("2 ea = %s, %s %s\n", ea.тип.вТкст0(), Сема2.вТкст0(ea.op), ea.вТкст0());
                if (ea.op == ТОК2.variable || ea.op == ТОК2.symbolOffset)
                    результат = getVarExp(e.место, istate, (cast(SymbolExp)ea).var, ctfeNeedRvalue);
                else if (auto ae = ea.isAddrExp())
                    результат = interpretRegion(ae.e1, istate);

                // https://issues.dlang.org/show_bug.cgi?ид=18871
                // https://issues.dlang.org/show_bug.cgi?ид=18819
                else if (auto ale = ea.isArrayLiteralExp())
                    результат = interpretRegion(ale, istate);

                else
                    assert(0);
                if (CTFEExp.isCantExp(результат))
                    return;

                if (fd.идент == Id.__МассивPostblit)
                    результат = evaluatePostblit(istate, результат);
                else
                    результат = evaluateDtor(istate, результат);
                if (!результат)
                    результат = CTFEExp.voidexp;
                return;
            }
            else if (fd.идент == Id._d_arraysetlengthT)
            {
                // In Выражениеsem.d `ea.length = eb;` got lowered to `_d_arraysetlengthT(ea, eb);`.
                // The following code will rewrite it back to `ea.length = eb` and then interpret that Выражение.
                assert(e.arguments.dim == 2);

                Выражение ea = (*e.arguments)[0];
                Выражение eb = (*e.arguments)[1];

                auto ale = ctfeEmplaceExp!(ArrayLengthExp)(e.место, ea);
                ale.тип = Тип.tт_мера;
                AssignExp ae = ctfeEmplaceExp!(AssignExp)(e.место, ale, eb);
                ae.тип = ea.тип;

                // if (глоб2.парамы.verbose)
                //     message("interpret  %s =>\n          %s", e.вТкст0(), ae.вТкст0());
                результат = interpretRegion(ae, istate);
                return;
            }
        }
        else if (auto soe = ecall.isSymOffExp())
        {
            fd = soe.var.isFuncDeclaration();
            assert(fd && soe.смещение == 0);
        }
        else if (auto de = ecall.isDelegateExp())
        {
            // Calling a delegate
            fd = de.func;
            pthis = de.e1;

            // Special handling for: &nestedfunc --> DelegateExp(VarExp(nestedfunc), nestedfunc)
            if (auto ve = pthis.isVarExp())
                if (ve.var == fd)
                    pthis = null; // context is not necessary for CTFE
        }
        else if (auto fe = ecall.isFuncExp())
        {
            // Calling a delegate literal
            fd = fe.fd;
        }
        else
        {
            // delegate.funcptr()
            // others
            e.выведиОшибку("cannot call `%s` at compile time", e.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }
        if (!fd)
        {
            e.выведиОшибку("CTFE internal error: cannot evaluate `%s` at compile time", e.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }
        if (pthis)
        {
            // Member function call

            // Currently this is satisfied because closure is not yet supported.
            assert(!fd.isNested() || fd.needThis());

            if (pthis.op == ТОК2.typeid_)
            {
                pthis.выведиОшибку("static variable `%s` cannot be читай at compile time", pthis.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }
            assert(pthis);

            if (pthis.op == ТОК2.null_)
            {
                assert(pthis.тип.toBasetype().ty == Tclass);
                e.выведиОшибку("function call through null class reference `%s`", pthis.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }

            assert(pthis.op == ТОК2.structLiteral || pthis.op == ТОК2.classReference || pthis.op == ТОК2.тип);

            if (fd.isVirtual() && !e.directcall)
            {
                // Make a virtual function call.
                // Get the function from the vtable of the original class
                assert(pthis.op == ТОК2.classReference);
                ClassDeclaration cd = (cast(ClassReferenceExp)pthis).originalClass();

                // We can't just use the vtable index to look it up, because
                // vtables for interfaces don't get populated until the glue layer.
                fd = cd.findFunc(fd.идент, cast(TypeFunction)fd.тип);
                assert(fd);
            }
        }

        if (fd && fd.semanticRun >= PASS.semantic3done && fd.semantic3Errors)
        {
            e.выведиОшибку("CTFE failed because of previous errors in `%s`", fd.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }

        // Check for built-in functions
        результат = evaluateIfBuiltin(pue, istate, e.место, fd, e.arguments, pthis);
        if (результат)
            return;

        if (!fd.fbody)
        {
            e.выведиОшибку("`%s` cannot be interpreted at compile time, because it has no доступно source code", fd.вТкст0());
            результат = CTFEExp.showcontext;
            return;
        }

        результат = interpretFunction(pue, fd, istate, e.arguments, pthis);
        if (результат.op == ТОК2.voidВыражение)
            return;
        if (!exceptionOrCantInterpret(результат))
        {
            if (goal != ctfeNeedLvalue) // Peel off CTFE reference if it's unnecessary
            {
                if (результат == pue.exp())
                    результат = pue.копируй();
                результат = interpret(pue, результат, istate);
            }
        }
        if (!exceptionOrCantInterpret(результат))
        {
            результат = paintTypeOntoLiteral(pue, e.тип, результат);
            результат.место = e.место;
        }
        else if (CTFEExp.isCantExp(результат) && !глоб2.gag)
            showCtfeBackTrace(e, fd); // Print a stack trace.
    }

    override проц посети(CommaExp e)
    {
        debug (LOG)
        {
            printf("%s CommaExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }

        // If it creates a variable, and there's no context for
        // the variable to be created in, we need to создай one now.
        InterState istateComma;
        if (!istate && firstComma(e.e1).op == ТОК2.declaration)
        {
            ctfeGlobals.stack.startFrame(null);
            istate = &istateComma;
        }

        проц endTempStackFrame()
        {
            // If we created a temporary stack frame, end it now.
            if (istate == &istateComma)
                ctfeGlobals.stack.endFrame();
        }

        результат = CTFEExp.cantexp;

        // If the comma returns a temporary variable, it needs to be an lvalue
        // (this is particularly important for struct constructors)
        if (e.e1.op == ТОК2.declaration &&
            e.e2.op == ТОК2.variable &&
            (cast(DeclarationExp)e.e1).declaration == (cast(VarExp)e.e2).var &&
            (cast(VarExp)e.e2).var.класс_хранения & STC.ctfe)
        {
            VarExp ve = cast(VarExp)e.e2;
            VarDeclaration v = ve.var.isVarDeclaration();
            ctfeGlobals.stack.сунь(v);
            if (!v._иниц && !дайЗначение(v))
            {
                setValue(v, copyLiteral(v.тип.defaultInitLiteral(e.место)).копируй());
            }
            if (!дайЗначение(v))
            {
                Выражение newval = v._иниц.инициализаторВВыражение();
                // Bug 4027. Copy constructors are a weird case where the
                // инициализатор is a проц function (the variable is modified
                // through a reference параметр instead).
                newval = interpretRegion(newval, istate);
                if (exceptionOrCant(newval))
                    return endTempStackFrame();
                if (newval.op != ТОК2.voidВыражение)
                {
                    // v isn't necessarily null.
                    setValueWithoutChecking(v, copyLiteral(newval).копируй());
                }
            }
        }
        else
        {
            UnionExp ue = проц;
            auto e1 = interpret(&ue, e.e1, istate, ctfeNeedNothing);
            if (exceptionOrCant(e1))
                return endTempStackFrame();
        }
        результат = interpret(pue, e.e2, istate, goal);
        return endTempStackFrame();
    }

    override проц посети(CondExp e)
    {
        debug (LOG)
        {
            printf("%s CondExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        UnionExp uecond = проц;
        Выражение econd;
        econd = interpret(&uecond, e.econd, istate);
        if (exceptionOrCant(econd))
            return;

        if (isPointer(e.econd.тип))
        {
            if (econd.op != ТОК2.null_)
            {
                econd = IntegerExp.createBool(да);
            }
        }

        if (isTrueBool(econd))
            результат = interpret(pue, e.e1, istate, goal);
        else if (econd.isBool(нет))
            результат = interpret(pue, e.e2, istate, goal);
        else
        {
            e.выведиОшибку("`%s` does not evaluate to булean результат at compile time", e.econd.вТкст0());
            результат = CTFEExp.cantexp;
        }
    }

    override проц посети(ArrayLengthExp e)
    {
        debug (LOG)
        {
            printf("%s ArrayLengthExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        UnionExp ue1;
        Выражение e1 = interpret(&ue1, e.e1, istate);
        assert(e1);
        if (exceptionOrCant(e1))
            return;
        if (e1.op != ТОК2.string_ && e1.op != ТОК2.arrayLiteral && e1.op != ТОК2.slice && e1.op != ТОК2.null_)
        {
            e.выведиОшибку("`%s` cannot be evaluated at compile time", e.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }
        emplaceExp!(IntegerExp)(pue, e.место, resolveArrayLength(e1), e.тип);
        результат = pue.exp();
    }

    /**
     * Interpret the vector Выражение as an массив literal.
     * Параметры:
     *    pue = non-null pointer to temporary storage that can be используется to store the return значение
     *    e = Выражение to interpret
     * Возвращает:
     *    результатing массив literal or 'e' if unable to interpret
     */
    static Выражение interpretVectorToArray(UnionExp* pue, VectorExp e)
    {
        if (auto ale = e.e1.isArrayLiteralExp())
            return ale;
        if (e.e1.op == ТОК2.int64 || e.e1.op == ТОК2.float64)
        {
            // Convert literal __vector(цел) -> __vector([массив])
            auto elements = new Выражения(e.dim);
            foreach (ref element; *elements)
                element = copyLiteral(e.e1).копируй();
            auto тип = (e.тип.ty == Tvector) ? e.тип.isTypeVector().basetype : e.тип.isTypeSArray();
            assert(тип);
            emplaceExp!(ArrayLiteralExp)(pue, e.место, тип, elements);
            auto ale = cast(ArrayLiteralExp)pue.exp();
            ale.ownedByCtfe = OwnedBy.ctfe;
            return ale;
        }
        return e;
    }

    override проц посети(VectorExp e)
    {
        debug (LOG)
        {
            printf("%s VectorExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        if (e.ownedByCtfe >= OwnedBy.ctfe) // We've already interpreted all the elements
        {
            результат = e;
            return;
        }
        Выражение e1 = interpret(pue, e.e1, istate);
        assert(e1);
        if (exceptionOrCant(e1))
            return;
        if (e1.op != ТОК2.arrayLiteral && e1.op != ТОК2.int64 && e1.op != ТОК2.float64)
        {
            e.выведиОшибку("`%s` cannot be evaluated at compile time", e.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }
        if (e1 == pue.exp())
            e1 = pue.копируй();
        emplaceExp!(VectorExp)(pue, e.место, e1, e.to);
        auto ve = cast(VectorExp)pue.exp();
        ve.тип = e.тип;
        ve.dim = e.dim;
        ve.ownedByCtfe = OwnedBy.ctfe;
        результат = ve;
    }

    override проц посети(VectorArrayExp e)
    {
        debug (LOG)
        {
            printf("%s VectorArrayExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        Выражение e1 = interpret(pue, e.e1, istate);
        assert(e1);
        if (exceptionOrCant(e1))
            return;
        if (auto ve = e1.isVectorExp())
        {
            результат = interpretVectorToArray(pue, ve);
            if (результат.op != ТОК2.vector)
                return;
        }
        e.выведиОшибку("`%s` cannot be evaluated at compile time", e.вТкст0());
        результат = CTFEExp.cantexp;
    }

    override проц посети(DelegatePtrExp e)
    {
        debug (LOG)
        {
            printf("%s DelegatePtrExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        Выражение e1 = interpret(pue, e.e1, istate);
        assert(e1);
        if (exceptionOrCant(e1))
            return;
        e.выведиОшибку("`%s` cannot be evaluated at compile time", e.вТкст0());
        результат = CTFEExp.cantexp;
    }

    override проц посети(DelegateFuncptrExp e)
    {
        debug (LOG)
        {
            printf("%s DelegateFuncptrExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        Выражение e1 = interpret(pue, e.e1, istate);
        assert(e1);
        if (exceptionOrCant(e1))
            return;
        e.выведиОшибку("`%s` cannot be evaluated at compile time", e.вТкст0());
        результат = CTFEExp.cantexp;
    }

    static бул resolveIndexing(IndexExp e, InterState* istate, Выражение* pagg, uinteger_t* pidx, бул modify)
    {
        assert(e.e1.тип.toBasetype().ty != Taarray);

        if (e.e1.тип.toBasetype().ty == Tpointer)
        {
            // Indexing a pointer. Note that there is no $ in this case.
            Выражение e1 = interpretRegion(e.e1, istate);
            if (exceptionOrCantInterpret(e1))
                return нет;

            Выражение e2 = interpretRegion(e.e2, istate);
            if (exceptionOrCantInterpret(e2))
                return нет;
            sinteger_t indx = e2.toInteger();

            dinteger_t ofs;
            Выражение agg = getAggregateFromPointer(e1, &ofs);

            if (agg.op == ТОК2.null_)
            {
                e.выведиОшибку("cannot index through null pointer `%s`", e.e1.вТкст0());
                return нет;
            }
            if (agg.op == ТОК2.int64)
            {
                e.выведиОшибку("cannot index through invalid pointer `%s` of значение `%s`", e.e1.вТкст0(), e1.вТкст0());
                return нет;
            }
            // Pointer to a non-массив variable
            if (agg.op == ТОК2.symbolOffset)
            {
                e.выведиОшибку("mutable variable `%s` cannot be %s at compile time, even through a pointer", cast(сим*)(modify ? "modified" : "читай"), (cast(SymOffExp)agg).var.вТкст0());
                return нет;
            }

            if (agg.op == ТОК2.arrayLiteral || agg.op == ТОК2.string_)
            {
                dinteger_t len = resolveArrayLength(agg);
                if (ofs + indx >= len)
                {
                    e.выведиОшибку("pointer index `[%lld]` exceeds allocated memory block `[0..%lld]`", ofs + indx, len);
                    return нет;
                }
            }
            else
            {
                if (ofs + indx != 0)
                {
                    e.выведиОшибку("pointer index `[%lld]` lies outside memory block `[0..1]`", ofs + indx);
                    return нет;
                }
            }
            *pagg = agg;
            *pidx = ofs + indx;
            return да;
        }

        Выражение e1 = interpretRegion(e.e1, istate);
        if (exceptionOrCantInterpret(e1))
            return нет;
        if (e1.op == ТОК2.null_)
        {
            e.выведиОшибку("cannot index null массив `%s`", e.e1.вТкст0());
            return нет;
        }
        if (auto ve = e1.isVectorExp())
        {
            UnionExp ue = проц;
            e1 = interpretVectorToArray(&ue, ve);
            e1 = (e1 == ue.exp()) ? ue.копируй() : e1;
        }

        // Set the $ variable, and найди the массив literal to modify
        dinteger_t len;
        if (e1.op == ТОК2.variable && e1.тип.toBasetype().ty == Tsarray)
            len = e1.тип.toBasetype().isTypeSArray().dim.toInteger();
        else
        {
            if (e1.op != ТОК2.arrayLiteral && e1.op != ТОК2.string_ && e1.op != ТОК2.slice && e1.op != ТОК2.vector)
            {
                e.выведиОшибку("cannot determine length of `%s` at compile time", e.e1.вТкст0());
                return нет;
            }
            len = resolveArrayLength(e1);
        }

        if (e.lengthVar)
        {
            Выражение dollarExp = ctfeEmplaceExp!(IntegerExp)(e.место, len, Тип.tт_мера);
            ctfeGlobals.stack.сунь(e.lengthVar);
            setValue(e.lengthVar, dollarExp);
        }
        Выражение e2 = interpretRegion(e.e2, istate);
        if (e.lengthVar)
            ctfeGlobals.stack.вынь(e.lengthVar); // $ is defined only inside []
        if (exceptionOrCantInterpret(e2))
            return нет;
        if (e2.op != ТОК2.int64)
        {
            e.выведиОшибку("CTFE internal error: non-integral index `[%s]`", e.e2.вТкст0());
            return нет;
        }

        if (auto se = e1.isSliceExp())
        {
            // Simplify index of slice: agg[lwr..upr][indx] --> agg[indx']
            uinteger_t index = e2.toInteger();
            uinteger_t ilwr = se.lwr.toInteger();
            uinteger_t iupr = se.upr.toInteger();

            if (index > iupr - ilwr)
            {
                e.выведиОшибку("index %llu exceeds массив length %llu", index, iupr - ilwr);
                return нет;
            }
            *pagg = (cast(SliceExp)e1).e1;
            *pidx = index + ilwr;
        }
        else
        {
            *pagg = e1;
            *pidx = e2.toInteger();
            if (len <= *pidx)
            {
                e.выведиОшибку("массив index %lld is out of bounds `[0..%lld]`", *pidx, len);
                return нет;
            }
        }
        return да;
    }

    override проц посети(IndexExp e)
    {
        debug (LOG)
        {
            printf("%s IndexExp::interpret() %s, goal = %d\n", e.место.вТкст0(), e.вТкст0(), goal);
        }
        if (e.e1.тип.toBasetype().ty == Tpointer)
        {
            Выражение agg;
            uinteger_t indexToAccess;
            if (!resolveIndexing(e, istate, &agg, &indexToAccess, нет))
            {
                результат = CTFEExp.cantexp;
                return;
            }
            if (agg.op == ТОК2.arrayLiteral || agg.op == ТОК2.string_)
            {
                if (goal == ctfeNeedLvalue)
                {
                    // if we need a reference, IndexExp shouldn't be interpreting
                    // the Выражение to a значение, it should stay as a reference
                    emplaceExp!(IndexExp)(pue, e.место, agg, ctfeEmplaceExp!(IntegerExp)(e.e2.место, indexToAccess, e.e2.тип));
                    результат = pue.exp();
                    результат.тип = e.тип;
                    return;
                }
                результат = ctfeIndex(pue, e.место, e.тип, agg, indexToAccess);
                return;
            }
            else
            {
                assert(indexToAccess == 0);
                результат = interpretRegion(agg, istate, goal);
                if (exceptionOrCant(результат))
                    return;
                результат = paintTypeOntoLiteral(pue, e.тип, результат);
                return;
            }
        }

        if (e.e1.тип.toBasetype().ty == Taarray)
        {
            Выражение e1 = interpretRegion(e.e1, istate);
            if (exceptionOrCant(e1))
                return;
            if (e1.op == ТОК2.null_)
            {
                if (goal == ctfeNeedLvalue && e1.тип.ty == Taarray && e.modifiable)
                {
                    assert(0); // does not reach here?
                }
                e.выведиОшибку("cannot index null массив `%s`", e.e1.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }
            Выражение e2 = interpretRegion(e.e2, istate);
            if (exceptionOrCant(e2))
                return;

            if (goal == ctfeNeedLvalue)
            {
                // Pointer or reference of a scalar тип
                if (e1 == e.e1 && e2 == e.e2)
                    результат = e;
                else
                {
                    emplaceExp!(IndexExp)(pue, e.место, e1, e2);
                    результат = pue.exp();
                    результат.тип = e.тип;
                }
                return;
            }

            assert(e1.op == ТОК2.assocArrayLiteral);
            UnionExp e2tmp = проц;
            e2 = resolveSlice(e2, &e2tmp);
            результат = findKeyInAA(e.место, cast(AssocArrayLiteralExp)e1, e2);
            if (!результат)
            {
                e.выведиОшибку("ключ `%s` not found in associative массив `%s`", e2.вТкст0(), e.e1.вТкст0());
                результат = CTFEExp.cantexp;
            }
            return;
        }

        Выражение agg;
        uinteger_t indexToAccess;
        if (!resolveIndexing(e, istate, &agg, &indexToAccess, нет))
        {
            результат = CTFEExp.cantexp;
            return;
        }

        if (goal == ctfeNeedLvalue)
        {
            Выражение e2 = ctfeEmplaceExp!(IntegerExp)(e.e2.место, indexToAccess, Тип.tт_мера);
            emplaceExp!(IndexExp)(pue, e.место, agg, e2);
            результат = pue.exp();
            результат.тип = e.тип;
            return;
        }

        результат = ctfeIndex(pue, e.место, e.тип, agg, indexToAccess);
        if (exceptionOrCant(результат))
            return;
        if (результат.op == ТОК2.void_)
        {
            e.выведиОшибку("`%s` is используется before initialized", e.вТкст0());
            errorSupplemental(результат.место, "originally uninitialized here");
            результат = CTFEExp.cantexp;
            return;
        }
        if (результат == pue.exp())
            результат = результат.копируй();
    }

    override проц посети(SliceExp e)
    {
        debug (LOG)
        {
            printf("%s SliceExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        if (e.e1.тип.toBasetype().ty == Tpointer)
        {
            // Slicing a pointer. Note that there is no $ in this case.
            Выражение e1 = interpretRegion(e.e1, istate);
            if (exceptionOrCant(e1))
                return;
            if (e1.op == ТОК2.int64)
            {
                e.выведиОшибку("cannot slice invalid pointer `%s` of значение `%s`", e.e1.вТкст0(), e1.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }

            /* Evaluate lower and upper bounds of slice
             */
            Выражение lwr = interpretRegion(e.lwr, istate);
            if (exceptionOrCant(lwr))
                return;
            Выражение upr = interpretRegion(e.upr, istate);
            if (exceptionOrCant(upr))
                return;
            uinteger_t ilwr = lwr.toInteger();
            uinteger_t iupr = upr.toInteger();

            dinteger_t ofs;
            Выражение agg = getAggregateFromPointer(e1, &ofs);
            ilwr += ofs;
            iupr += ofs;
            if (agg.op == ТОК2.null_)
            {
                if (iupr == ilwr)
                {
                    результат = ctfeEmplaceExp!(NullExp)(e.место);
                    результат.тип = e.тип;
                    return;
                }
                e.выведиОшибку("cannot slice null pointer `%s`", e.e1.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }
            if (agg.op == ТОК2.symbolOffset)
            {
                e.выведиОшибку("slicing pointers to static variables is not supported in CTFE");
                результат = CTFEExp.cantexp;
                return;
            }
            if (agg.op != ТОК2.arrayLiteral && agg.op != ТОК2.string_)
            {
                e.выведиОшибку("pointer `%s` cannot be sliced at compile time (it does not point to an массив)", e.e1.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }
            assert(agg.op == ТОК2.arrayLiteral || agg.op == ТОК2.string_);
            dinteger_t len = ArrayLength(Тип.tт_мера, agg).exp().toInteger();
            //Тип *pointee = ((TypePointer *)agg.тип)->следщ;
            if (iupr > (len + 1) || iupr < ilwr)
            {
                e.выведиОшибку("pointer slice `[%lld..%lld]` exceeds allocated memory block `[0..%lld]`", ilwr, iupr, len);
                результат = CTFEExp.cantexp;
                return;
            }
            if (ofs != 0)
            {
                lwr = ctfeEmplaceExp!(IntegerExp)(e.место, ilwr, lwr.тип);
                upr = ctfeEmplaceExp!(IntegerExp)(e.место, iupr, upr.тип);
            }
            emplaceExp!(SliceExp)(pue, e.место, agg, lwr, upr);
            результат = pue.exp();
            результат.тип = e.тип;
            return;
        }

        CtfeGoal goal1 = ctfeNeedRvalue;
        if (goal == ctfeNeedLvalue)
        {
            if (e.e1.тип.toBasetype().ty == Tsarray)
                if (auto ve = e.e1.isVarExp())
                    if (auto vd = ve.var.isVarDeclaration())
                        if (vd.класс_хранения & STC.ref_)
                            goal1 = ctfeNeedLvalue;
        }
        Выражение e1 = interpret(e.e1, istate, goal1);
        if (exceptionOrCant(e1))
            return;

        if (!e.lwr)
        {
            результат = paintTypeOntoLiteral(pue, e.тип, e1);
            return;
        }
        if (auto ve = e1.isVectorExp())
        {
            e1 = interpretVectorToArray(pue, ve);
            e1 = (e1 == pue.exp()) ? pue.копируй() : e1;
        }

        /* Set dollar to the length of the массив
         */
        uinteger_t dollar;
        if ((e1.op == ТОК2.variable || e1.op == ТОК2.dotVariable) && e1.тип.toBasetype().ty == Tsarray)
            dollar = e1.тип.toBasetype().isTypeSArray().dim.toInteger();
        else
        {
            if (e1.op != ТОК2.arrayLiteral && e1.op != ТОК2.string_ && e1.op != ТОК2.null_ && e1.op != ТОК2.slice && e1.op != ТОК2.vector)
            {
                e.выведиОшибку("cannot determine length of `%s` at compile time", e1.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }
            dollar = resolveArrayLength(e1);
        }

        /* Set the $ variable
         */
        if (e.lengthVar)
        {
            auto dollarExp = ctfeEmplaceExp!(IntegerExp)(e.место, dollar, Тип.tт_мера);
            ctfeGlobals.stack.сунь(e.lengthVar);
            setValue(e.lengthVar, dollarExp);
        }

        /* Evaluate lower and upper bounds of slice
         */
        Выражение lwr = interpretRegion(e.lwr, istate);
        if (exceptionOrCant(lwr))
        {
            if (e.lengthVar)
                ctfeGlobals.stack.вынь(e.lengthVar);
            return;
        }
        Выражение upr = interpretRegion(e.upr, istate);
        if (exceptionOrCant(upr))
        {
            if (e.lengthVar)
                ctfeGlobals.stack.вынь(e.lengthVar);
            return;
        }
        if (e.lengthVar)
            ctfeGlobals.stack.вынь(e.lengthVar); // $ is defined only inside [L..U]

        uinteger_t ilwr = lwr.toInteger();
        uinteger_t iupr = upr.toInteger();
        if (e1.op == ТОК2.null_)
        {
            if (ilwr == 0 && iupr == 0)
            {
                результат = e1;
                return;
            }
            e1.выведиОшибку("slice `[%llu..%llu]` is out of bounds", ilwr, iupr);
            результат = CTFEExp.cantexp;
            return;
        }
        if (auto se = e1.isSliceExp())
        {
            // Simplify slice of slice:
            //  aggregate[lo1..up1][lwr..upr] ---> aggregate[lwr'..upr']
            uinteger_t lo1 = se.lwr.toInteger();
            uinteger_t up1 = se.upr.toInteger();
            if (ilwr > iupr || iupr > up1 - lo1)
            {
                e.выведиОшибку("slice `[%llu..%llu]` exceeds массив bounds `[%llu..%llu]`", ilwr, iupr, lo1, up1);
                результат = CTFEExp.cantexp;
                return;
            }
            ilwr += lo1;
            iupr += lo1;
            emplaceExp!(SliceExp)(pue, e.место, se.e1,
                ctfeEmplaceExp!(IntegerExp)(e.место, ilwr, lwr.тип),
                ctfeEmplaceExp!(IntegerExp)(e.место, iupr, upr.тип));
            результат = pue.exp();
            результат.тип = e.тип;
            return;
        }
        if (e1.op == ТОК2.arrayLiteral || e1.op == ТОК2.string_)
        {
            if (iupr < ilwr || dollar < iupr)
            {
                e.выведиОшибку("slice `[%lld..%lld]` exceeds массив bounds `[0..%lld]`", ilwr, iupr, dollar);
                результат = CTFEExp.cantexp;
                return;
            }
        }
        emplaceExp!(SliceExp)(pue, e.место, e1, lwr, upr);
        результат = pue.exp();
        результат.тип = e.тип;
    }

    override проц посети(InExp e)
    {
        debug (LOG)
        {
            printf("%s InExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        Выражение e1 = interpretRegion(e.e1, istate);
        if (exceptionOrCant(e1))
            return;
        Выражение e2 = interpretRegion(e.e2, istate);
        if (exceptionOrCant(e2))
            return;
        if (e2.op == ТОК2.null_)
        {
            emplaceExp!(NullExp)(pue, e.место, e.тип);
            результат = pue.exp();
            return;
        }
        if (e2.op != ТОК2.assocArrayLiteral)
        {
            e.выведиОшибку("`%s` cannot be interpreted at compile time", e.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }

        e1 = resolveSlice(e1);
        результат = findKeyInAA(e.место, cast(AssocArrayLiteralExp)e2, e1);
        if (exceptionOrCant(результат))
            return;
        if (!результат)
        {
            emplaceExp!(NullExp)(pue, e.место, e.тип);
            результат = pue.exp();
        }
        else
        {
            // Create a CTFE pointer &aa[index]
            результат = ctfeEmplaceExp!(IndexExp)(e.место, e2, e1);
            результат.тип = e.тип.nextOf();
            emplaceExp!(AddrExp)(pue, e.место, результат, e.тип);
            результат = pue.exp();
        }
    }

    override проц посети(CatExp e)
    {
        debug (LOG)
        {
            printf("%s CatExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }

        UnionExp ue1 = проц;
        Выражение e1 = interpret(&ue1, e.e1, istate);
        if (exceptionOrCant(e1))
            return;

        UnionExp ue2 = проц;
        Выражение e2 = interpret(&ue2, e.e2, istate);
        if (exceptionOrCant(e2))
            return;

        UnionExp e1tmp = проц;
        e1 = resolveSlice(e1, &e1tmp);

        UnionExp e2tmp = проц;
        e2 = resolveSlice(e2, &e2tmp);

        /* e1 and e2 can't go on the stack because of x~[y] and [x]~y will
         * результат in [x,y] and then x or y is on the stack.
         * But if they are both strings, we can, because it isn't the x~[y] case.
         */
        if (!(e1.op == ТОК2.string_ && e2.op == ТОК2.string_))
        {
            if (e1 == ue1.exp())
                e1 = ue1.копируй();
            if (e2 == ue2.exp())
                e2 = ue2.копируй();
        }

        *pue = ctfeCat(e.место, e.тип, e1, e2);
        результат = pue.exp();

        if (CTFEExp.isCantExp(результат))
        {
            e.выведиОшибку("`%s` cannot be interpreted at compile time", e.вТкст0());
            return;
        }
        // We know we still own it, because we interpreted both e1 and e2
        if (auto ale = результат.isArrayLiteralExp())
        {
            ale.ownedByCtfe = OwnedBy.ctfe;

            // https://issues.dlang.org/show_bug.cgi?ид=14686
            foreach (elem; *ale.elements)
            {
                Выражение ex = evaluatePostblit(istate, elem);
                if (exceptionOrCant(ex))
                    return;
            }
        }
        else if (auto se = результат.isStringExp())
            se.ownedByCtfe = OwnedBy.ctfe;
    }

    override проц посети(DeleteExp e)
    {
        debug (LOG)
        {
            printf("%s DeleteExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        результат = interpretRegion(e.e1, istate);
        if (exceptionOrCant(результат))
            return;

        if (результат.op == ТОК2.null_)
        {
            результат = CTFEExp.voidexp;
            return;
        }

        auto tb = e.e1.тип.toBasetype();
        switch (tb.ty)
        {
        case Tclass:
            if (результат.op != ТОК2.classReference)
            {
                e.выведиОшибку("`delete` on invalid class reference `%s`", результат.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }

            auto cre = cast(ClassReferenceExp)результат;
            auto cd = cre.originalClass();

            if (cd.dtor)
            {
                результат = interpretFunction(pue, cd.dtor, istate, null, cre);
                if (exceptionOrCant(результат))
                    return;
            }
            break;

        case Tpointer:
            tb = (cast(TypePointer)tb).следщ.toBasetype();
            if (tb.ty == Tstruct)
            {
                if (результат.op != ТОК2.address ||
                    (cast(AddrExp)результат).e1.op != ТОК2.structLiteral)
                {
                    e.выведиОшибку("`delete` on invalid struct pointer `%s`", результат.вТкст0());
                    результат = CTFEExp.cantexp;
                    return;
                }

                auto sd = (cast(TypeStruct)tb).sym;
                auto sle = cast(StructLiteralExp)(cast(AddrExp)результат).e1;

                if (sd.dtor)
                {
                    результат = interpretFunction(pue, sd.dtor, istate, null, sle);
                    if (exceptionOrCant(результат))
                        return;
                }
            }
            break;

        case Tarray:
            auto tv = tb.nextOf().baseElemOf();
            if (tv.ty == Tstruct)
            {
                if (результат.op != ТОК2.arrayLiteral)
                {
                    e.выведиОшибку("`delete` on invalid struct массив `%s`", результат.вТкст0());
                    результат = CTFEExp.cantexp;
                    return;
                }

                auto sd = (cast(TypeStruct)tv).sym;

                if (sd.dtor)
                {
                    auto ale = cast(ArrayLiteralExp)результат;
                    foreach (el; *ale.elements)
                    {
                        результат = interpretFunction(pue, sd.dtor, istate, null, el);
                        if (exceptionOrCant(результат))
                            return;
                    }
                }
            }
            break;

        default:
            assert(0);
        }
        результат = CTFEExp.voidexp;
    }

    override проц посети(CastExp e)
    {
        debug (LOG)
        {
            printf("%s CastExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        Выражение e1 = interpretRegion(e.e1, istate, goal);
        if (exceptionOrCant(e1))
            return;
        // If the Выражение has been cast to проц, do nothing.
        if (e.to.ty == Tvoid)
        {
            результат = CTFEExp.voidexp;
            return;
        }
        if (e.to.ty == Tpointer && e1.op != ТОК2.null_)
        {
            Тип pointee = (cast(TypePointer)e.тип).следщ;
            // Implement special cases of normally-unsafe casts
            if (e1.op == ТОК2.int64)
            {
                // Happens with Windows HANDLEs, for example.
                результат = paintTypeOntoLiteral(pue, e.to, e1);
                return;
            }

            бул castToSarrayPointer = нет;
            бул castBackFromVoid = нет;
            if (e1.тип.ty == Tarray || e1.тип.ty == Tsarray || e1.тип.ty == Tpointer)
            {
                // Check for unsupported тип painting operations
                // For slices, we need the тип being sliced,
                // since it may have already been тип painted
                Тип elemtype = e1.тип.nextOf();
                if (auto se = e1.isSliceExp())
                    elemtype = se.e1.тип.nextOf();

                // Allow casts from X* to проц *, and X** to ук* for any X.
                // But don't allow cast from X* to ук*.
                // So, we strip all matching * from source and target to найди X.
                // Allow casts to X* from ук only if the 'проц' was originally an X;
                // we check this later on.
                Тип ultimatePointee = pointee;
                Тип ultimateSrc = elemtype;
                while (ultimatePointee.ty == Tpointer && ultimateSrc.ty == Tpointer)
                {
                    ultimatePointee = ultimatePointee.nextOf();
                    ultimateSrc = ultimateSrc.nextOf();
                }
                if (ultimatePointee.ty == Tsarray && ultimatePointee.nextOf().equivalent(ultimateSrc))
                {
                    castToSarrayPointer = да;
                }
                else if (ultimatePointee.ty != Tvoid && ultimateSrc.ty != Tvoid && !isSafePointerCast(elemtype, pointee))
                {
                    e.выведиОшибку("reinterpreting cast from `%s*` to `%s*` is not supported in CTFE", elemtype.вТкст0(), pointee.вТкст0());
                    результат = CTFEExp.cantexp;
                    return;
                }
                if (ultimateSrc.ty == Tvoid)
                    castBackFromVoid = да;
            }

            if (auto se = e1.isSliceExp())
            {
                if (se.e1.op == ТОК2.null_)
                {
                    результат = paintTypeOntoLiteral(pue, e.тип, se.e1);
                    return;
                }
                // Create a CTFE pointer &aggregate[1..2]
                auto ei = ctfeEmplaceExp!(IndexExp)(e.место, se.e1, se.lwr);
                ei.тип = e.тип.nextOf();
                emplaceExp!(AddrExp)(pue, e.место, ei, e.тип);
                результат = pue.exp();
                return;
            }
            if (e1.op == ТОК2.arrayLiteral || e1.op == ТОК2.string_)
            {
                // Create a CTFE pointer &[1,2,3][0] or &"abc"[0]
                auto ei = ctfeEmplaceExp!(IndexExp)(e.место, e1, ctfeEmplaceExp!(IntegerExp)(e.место, 0, Тип.tт_мера));
                ei.тип = e.тип.nextOf();
                emplaceExp!(AddrExp)(pue, e.место, ei, e.тип);
                результат = pue.exp();
                return;
            }
            if (e1.op == ТОК2.index && !(cast(IndexExp)e1).e1.тип.равен(e1.тип))
            {
                // тип painting operation
                IndexExp ie = cast(IndexExp)e1;
                if (castBackFromVoid)
                {
                    // get the original тип. For strings, it's just the тип...
                    Тип origType = ie.e1.тип.nextOf();
                    // ..but for arrays of тип ук, it's the тип of the element
                    if (ie.e1.op == ТОК2.arrayLiteral && ie.e2.op == ТОК2.int64)
                    {
                        ArrayLiteralExp ale = cast(ArrayLiteralExp)ie.e1;
                        const indx = cast(т_мера)ie.e2.toInteger();
                        if (indx < ale.elements.dim)
                        {
                            if (Выражение xx = (*ale.elements)[indx])
                            {
                                if (auto iex = xx.isIndexExp())
                                    origType = iex.e1.тип.nextOf();
                                else if (auto ae = xx.isAddrExp())
                                    origType = ae.e1.тип;
                                else if (auto ve = xx.isVarExp())
                                    origType = ve.var.тип;
                            }
                        }
                    }
                    if (!isSafePointerCast(origType, pointee))
                    {
                        e.выведиОшибку("using `ук` to reinterpret cast from `%s*` to `%s*` is not supported in CTFE", origType.вТкст0(), pointee.вТкст0());
                        результат = CTFEExp.cantexp;
                        return;
                    }
                }
                emplaceExp!(IndexExp)(pue, e1.место, ie.e1, ie.e2);
                результат = pue.exp();
                результат.тип = e.тип;
                return;
            }

            if (auto ae = e1.isAddrExp())
            {
                Тип origType = ae.e1.тип;
                if (isSafePointerCast(origType, pointee))
                {
                    emplaceExp!(AddrExp)(pue, e.место, ae.e1, e.тип);
                    результат = pue.exp();
                    return;
                }

                if (castToSarrayPointer && pointee.toBasetype().ty == Tsarray && ae.e1.op == ТОК2.index)
                {
                    // &val[idx]
                    dinteger_t dim = (cast(TypeSArray)pointee.toBasetype()).dim.toInteger();
                    IndexExp ie = cast(IndexExp)ae.e1;
                    Выражение lwr = ie.e2;
                    Выражение upr = ctfeEmplaceExp!(IntegerExp)(ie.e2.место, ie.e2.toInteger() + dim, Тип.tт_мера);

                    // Create a CTFE pointer &val[idx..idx+dim]
                    auto er = ctfeEmplaceExp!(SliceExp)(e.место, ie.e1, lwr, upr);
                    er.тип = pointee;
                    emplaceExp!(AddrExp)(pue, e.место, er, e.тип);
                    результат = pue.exp();
                    return;
                }
            }

            if (e1.op == ТОК2.variable || e1.op == ТОК2.symbolOffset)
            {
                // тип painting operation
                Тип origType = (cast(SymbolExp)e1).var.тип;
                if (castBackFromVoid && !isSafePointerCast(origType, pointee))
                {
                    e.выведиОшибку("using `ук` to reinterpret cast from `%s*` to `%s*` is not supported in CTFE", origType.вТкст0(), pointee.вТкст0());
                    результат = CTFEExp.cantexp;
                    return;
                }
                if (auto ve = e1.isVarExp())
                    emplaceExp!(VarExp)(pue, e.место, ve.var);
                else
                    emplaceExp!(SymOffExp)(pue, e.место, (cast(SymOffExp)e1).var, (cast(SymOffExp)e1).смещение);
                результат = pue.exp();
                результат.тип = e.to;
                return;
            }

            // Check if we have a null pointer (eg, inside a struct)
            e1 = interpretRegion(e1, istate);
            if (e1.op != ТОК2.null_)
            {
                e.выведиОшибку("pointer cast from `%s` to `%s` is not supported at compile time", e1.тип.вТкст0(), e.to.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }
        }
        if (e.to.ty == Tsarray && e.e1.тип.ty == Tvector)
        {
            // Special handling for: cast(float[4])__vector([w, x, y, z])
            e1 = interpretRegion(e.e1, istate);
            if (exceptionOrCant(e1))
                return;
            assert(e1.op == ТОК2.vector);
            e1 = interpretVectorToArray(pue, e1.isVectorExp());
        }
        if (e.to.ty == Tarray && e1.op == ТОК2.slice)
        {
            // Note that the slice may be проц[], so when checking for dangerous
            // casts, we need to use the original тип, which is se.e1.
            SliceExp se = cast(SliceExp)e1;
            if (!isSafePointerCast(se.e1.тип.nextOf(), e.to.nextOf()))
            {
                e.выведиОшибку("массив cast from `%s` to `%s` is not supported at compile time", se.e1.тип.вТкст0(), e.to.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }
            emplaceExp!(SliceExp)(pue, e1.место, se.e1, se.lwr, se.upr);
            результат = pue.exp();
            результат.тип = e.to;
            return;
        }
        // Disallow массив тип painting, except for conversions between built-in
        // types of identical size.
        if ((e.to.ty == Tsarray || e.to.ty == Tarray) && (e1.тип.ty == Tsarray || e1.тип.ty == Tarray) && !isSafePointerCast(e1.тип.nextOf(), e.to.nextOf()))
        {
            e.выведиОшибку("массив cast from `%s` to `%s` is not supported at compile time", e1.тип.вТкст0(), e.to.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }
        if (e.to.ty == Tsarray)
            e1 = resolveSlice(e1);
        if (e.to.toBasetype().ty == Tbool && e1.тип.ty == Tpointer)
        {
            emplaceExp!(IntegerExp)(pue, e.место, e1.op != ТОК2.null_, e.to);
            результат = pue.exp();
            return;
        }
        результат = ctfeCast(pue, e.место, e.тип, e.to, e1);
    }

    override проц посети(AssertExp e)
    {
        debug (LOG)
        {
            printf("%s AssertExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        Выражение e1 = interpret(pue, e.e1, istate);
        if (exceptionOrCant(e1))
            return;
        if (isTrueBool(e1))
        {
        }
        else if (e1.isBool(нет))
        {
            if (e.msg)
            {
                UnionExp ue = проц;
                результат = interpret(&ue, e.msg, istate);
                if (exceptionOrCant(результат))
                    return;
                e.выведиОшибку("`%s`", результат.вТкст0());
            }
            else
                e.выведиОшибку("`%s` failed", e.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }
        else
        {
            e.выведиОшибку("`%s` is not a compile time булean Выражение", e1.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }
        результат = e1;
        return;
    }

    override проц посети(PtrExp e)
    {
        debug (LOG)
        {
            printf("%s PtrExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        // Check for цел<->float and long<->double casts.
        if (auto soe1 = e.e1.isSymOffExp())
            if (soe1.смещение == 0 && soe1.var.isVarDeclaration() && isFloatIntPaint(e.тип, soe1.var.тип))
            {
                // *(cast(цел*)&v), where v is a float variable
                результат = paintFloatInt(pue, getVarExp(e.место, istate, soe1.var, ctfeNeedRvalue), e.тип);
                return;
            }

        if (auto ce1 = e.e1.isCastExp())
            if (auto ae11 = ce1.e1.isAddrExp())
            {
                // *(cast(цел*)&x), where x is a float Выражение
                Выражение x = ae11.e1;
                if (isFloatIntPaint(e.тип, x.тип))
                {
                    результат = paintFloatInt(pue, interpretRegion(x, istate), e.тип);
                    return;
                }
            }

        // Constant fold *(&structliteral + смещение)
        if (auto ae = e.e1.isAddExp())
        {
            if (ae.e1.op == ТОК2.address && ae.e2.op == ТОК2.int64)
            {
                AddrExp ade = cast(AddrExp)ae.e1;
                Выражение ex = interpretRegion(ade.e1, istate);
                if (exceptionOrCant(ex))
                    return;
                if (auto se = ex.isStructLiteralExp())
                {
                    dinteger_t смещение = ae.e2.toInteger();
                    результат = se.getField(e.тип, cast(бцел)смещение);
                    if (результат)
                        return;
                }
            }
        }

        // It's possible we have an массив bounds error. We need to make sure it
        // errors with this line number, not the one where the pointer was set.
        результат = interpretRegion(e.e1, istate);
        if (exceptionOrCant(результат))
            return;

        if (результат.op == ТОК2.function_)
            return;
        if (auto soe = результат.isSymOffExp())
        {
            if (soe.смещение == 0 && soe.var.isFuncDeclaration())
                return;
            e.выведиОшибку("cannot dereference pointer to static variable `%s` at compile time", soe.var.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }

        if (результат.op != ТОК2.address)
        {
            if (результат.op == ТОК2.null_)
                e.выведиОшибку("dereference of null pointer `%s`", e.e1.вТкст0());
            else
                e.выведиОшибку("dereference of invalid pointer `%s`", результат.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }

        // *(&x) ==> x
        результат = (cast(AddrExp)результат).e1;

        if (результат.op == ТОК2.slice && e.тип.toBasetype().ty == Tsarray)
        {
            /* aggr[lwr..upr]
             * upr may exceed the upper boundary of aggr, but the check is deferred
             * until those out-of-bounds elements will be touched.
             */
            return;
        }
        результат = interpret(pue, результат, istate, goal);
        if (exceptionOrCant(результат))
            return;

        debug (LOG)
        {
            if (CTFEExp.isCantExp(результат))
                printf("PtrExp::interpret() %s = CTFEExp::cantexp\n", e.вТкст0());
        }
    }

    override проц посети(DotVarExp e)
    {
        debug (LOG)
        {
            printf("%s DotVarExp::interpret() %s, goal = %d\n", e.место.вТкст0(), e.вТкст0(), goal);
        }
        Выражение ex = interpretRegion(e.e1, istate);
        if (exceptionOrCant(ex))
            return;

        if (FuncDeclaration f = e.var.isFuncDeclaration())
        {
            if (ex == e.e1)
                результат = e; // optimize: reuse this CTFE reference
            else
            {
                emplaceExp!(DotVarExp)(pue, e.место, ex, f, нет);
                результат = pue.exp();
                результат.тип = e.тип;
            }
            return;
        }

        VarDeclaration v = e.var.isVarDeclaration();
        if (!v)
        {
            e.выведиОшибку("CTFE internal error: `%s`", e.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }

        if (ex.op == ТОК2.null_)
        {
            if (ex.тип.toBasetype().ty == Tclass)
                e.выведиОшибку("class `%s` is `null` and cannot be dereferenced", e.e1.вТкст0());
            else
                e.выведиОшибку("CTFE internal error: null this `%s`", e.e1.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }
        if (ex.op != ТОК2.structLiteral && ex.op != ТОК2.classReference)
        {
            e.выведиОшибку("`%s.%s` is not yet implemented at compile time", e.e1.вТкст0(), e.var.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }

        StructLiteralExp se;
        цел i;

        // We can't use getField, because it makes a копируй
        if (ex.op == ТОК2.classReference)
        {
            se = (cast(ClassReferenceExp)ex).значение;
            i = (cast(ClassReferenceExp)ex).findFieldIndexByName(v);
        }
        else
        {
            se = cast(StructLiteralExp)ex;
            i = findFieldIndexByName(se.sd, v);
        }
        if (i == -1)
        {
            e.выведиОшибку("couldn't найди field `%s` of тип `%s` in `%s`", v.вТкст0(), e.тип.вТкст0(), se.вТкст0());
            результат = CTFEExp.cantexp;
            return;
        }

        if (goal == ctfeNeedLvalue)
        {
            Выражение ev = (*se.elements)[i];
            if (!ev || ev.op == ТОК2.void_)
                (*se.elements)[i] = voidInitLiteral(e.тип, v).копируй();
            // just return the (simplified) dotvar Выражение as a CTFE reference
            if (e.e1 == ex)
                результат = e;
            else
            {
                emplaceExp!(DotVarExp)(pue, e.место, ex, v);
                результат = pue.exp();
                результат.тип = e.тип;
            }
            return;
        }

        результат = (*se.elements)[i];
        if (!результат)
        {
            // https://issues.dlang.org/show_bug.cgi?ид=19897
            // Zero-length fields don't have an инициализатор.
            if (v.тип.size() == 0)
                результат = voidInitLiteral(e.тип, v).копируй();
            else
            {
                e.выведиОшибку("Internal Compiler Error: null field `%s`", v.вТкст0());
                результат = CTFEExp.cantexp;
                return;
            }
        }
        if (auto vie = результат.isVoidInitExp())
        {
            const s = vie.var.вТкст0();
            if (v.overlapped)
            {
                e.выведиОшибку("reinterpretation through overlapped field `%s` is not allowed in CTFE", s);
                результат = CTFEExp.cantexp;
                return;
            }
            e.выведиОшибку("cannot читай uninitialized variable `%s` in CTFE", s);
            результат = CTFEExp.cantexp;
            return;
        }

        if (v.тип.ty != результат.тип.ty && v.тип.ty == Tsarray)
        {
            // Block assignment from inside struct literals
            auto tsa = cast(TypeSArray)v.тип;
            auto len = cast(т_мера)tsa.dim.toInteger();
            UnionExp ue = проц;
            результат = createBlockDuplicatedArrayLiteral(&ue, ex.место, v.тип, ex, len);
            if (результат == ue.exp())
                результат = ue.копируй();
            (*se.elements)[i] = результат;
        }
        debug (LOG)
        {
            if (CTFEExp.isCantExp(результат))
                printf("DotVarExp::interpret() %s = CTFEExp::cantexp\n", e.вТкст0());
        }
    }

    override проц посети(RemoveExp e)
    {
        debug (LOG)
        {
            printf("%s RemoveExp::interpret() %s\n", e.место.вТкст0(), e.вТкст0());
        }
        Выражение agg = interpret(e.e1, istate);
        if (exceptionOrCant(agg))
            return;
        Выражение index = interpret(e.e2, istate);
        if (exceptionOrCant(index))
            return;
        if (agg.op == ТОК2.null_)
        {
            результат = CTFEExp.voidexp;
            return;
        }

        AssocArrayLiteralExp aae = agg.isAssocArrayLiteralExp();
        Выражения* keysx = aae.keys;
        Выражения* valuesx = aae.values;
        т_мера removed = 0;
        foreach (j, evalue; *valuesx)
        {
            Выражение ekey = (*keysx)[j];
            цел eq = ctfeEqual(e.место, ТОК2.equal, ekey, index);
            if (eq)
                ++removed;
            else if (removed != 0)
            {
                (*keysx)[j - removed] = ekey;
                (*valuesx)[j - removed] = evalue;
            }
        }
        valuesx.dim = valuesx.dim - removed;
        keysx.dim = keysx.dim - removed;
        результат = IntegerExp.createBool(removed != 0);
    }

    override проц посети(ClassReferenceExp e)
    {
        //printf("ClassReferenceExp::interpret() %s\n", e.значение.вТкст0());
        результат = e;
    }

    override проц посети(VoidInitExp e)
    {
        e.выведиОшибку("CTFE internal error: trying to читай uninitialized variable");
        assert(0);
    }

    override проц посети(ThrownExceptionExp e)
    {
        assert(0); // This should never be interpreted
    }
}

/********************************************
 * Interpret the Выражение.
 * Параметры:
 *    pue = non-null pointer to temporary storage that can be используется to store the return значение
 *    e = Выражение to interpret
 *    istate = context
 *    goal = what the результат will be используется for
 * Возвращает:
 *    результатing Выражение
 */

Выражение interpret(UnionExp* pue, Выражение e, InterState* istate, CtfeGoal goal = ctfeNeedRvalue)
{
    if (!e)
        return null;
    scope Interpreter v = new Interpreter(pue, istate, goal);
    e.прими(v);
    Выражение ex = v.результат;
    assert(goal == ctfeNeedNothing || ex !is null);
    return ex;
}

///
Выражение interpret(Выражение e, InterState* istate, CtfeGoal goal = ctfeNeedRvalue)
{
    UnionExp ue = проц;
    auto результат = interpret(&ue, e, istate, goal);
    if (результат == ue.exp())
        результат = ue.копируй();
    return результат;
}

/*****************************
 * Same as interpret(), but return результат allocated in Регион.
 * Параметры:
 *    e = Выражение to interpret
 *    istate = context
 *    goal = what the результат will be используется for
 * Возвращает:
 *    результатing Выражение
 */
Выражение interpretRegion(Выражение e, InterState* istate, CtfeGoal goal = ctfeNeedRvalue)
{
    UnionExp ue = проц;
    auto результат = interpret(&ue, e, istate, goal);
    auto uexp = ue.exp();
    if (результат != uexp)
        return результат;
    if (mem.смИниц_ли)
        return ue.копируй();

    // mimicking UnionExp.копируй, but with region allocation
    switch (uexp.op)
    {
        case ТОК2.cantВыражение: return CTFEExp.cantexp;
        case ТОК2.voidВыражение: return CTFEExp.voidexp;
        case ТОК2.break_:         return CTFEExp.breakexp;
        case ТОК2.continue_:      return CTFEExp.continueexp;
        case ТОК2.goto_:          return CTFEExp.gotoexp;
        default:                 break;
    }
    auto p = ctfeGlobals.region.malloc(uexp.size);
    return cast(Выражение)memcpy(p, cast(ук)uexp, uexp.size);
}

/***********************************
 * Interpret the инструкция.
 * Параметры:
 *    pue = non-null pointer to temporary storage that can be используется to store the return значение
 *    s = Инструкция2 to interpret
 *    istate = context
 * Возвращает:
 *      NULL    continue to следщ инструкция
 *      ТОК2.cantВыражение      cannot interpret инструкция at compile time
 *      !NULL   Выражение from return инструкция, or thrown exception
 */
Выражение interpret(UnionExp* pue, Инструкция2 s, InterState* istate)
{
    if (!s)
        return null;
    scope Interpreter v = new Interpreter(pue, istate, ctfeNeedNothing);
    s.прими(v);
    return v.результат;
}

///
Выражение interpret(Инструкция2 s, InterState* istate)
{
    UnionExp ue = проц;
    auto результат = interpret(&ue, s, istate);
    if (результат == ue.exp())
        результат = ue.копируй();
    return результат;
}

/**
 * All результатs destined for use outside of CTFE need to have their CTFE-specific
 * features removed.
 * In particular,
 * 1. all slices must be resolved.
 * 2. all .ownedByCtfe set to OwnedBy.code
 */
private Выражение scrubReturnValue(ref Место место, Выражение e)
{
    /* Возвращает: да if e is проц,
     * or is an массив literal or struct literal of проц elements.
     */
    static бул isVoid(Выражение e, бул checkArrayType = нет) 
    {
        if (e.op == ТОК2.void_)
            return да;

        static бул isEntirelyVoid(Выражения* elems)
        {
            foreach (e; *elems)
            {
                // It can be NULL for performance reasons,
                // see StructLiteralExp::interpret().
                if (e && !isVoid(e))
                    return нет;
            }
            return да;
        }

        if (auto sle = e.isStructLiteralExp())
            return isEntirelyVoid(sle.elements);

        if (checkArrayType && e.тип.ty != Tsarray)
            return нет;

        if (auto ale = e.isArrayLiteralExp())
            return isEntirelyVoid(ale.elements);

        return нет;
    }


    /* Scrub all elements of elems[].
     * Возвращает: null for успех, error Выражение for failure
     */
    Выражение scrubArray(Выражения* elems, бул structlit = нет)
    {
        foreach (ref e; *elems)
        {
            // It can be NULL for performance reasons,
            // see StructLiteralExp::interpret().
            if (!e)
                continue;

            // A struct .init may contain проц члены.
            // Static массив члены are a weird special case https://issues.dlang.org/show_bug.cgi?ид=10994
            if (structlit && isVoid(e, да))
            {
                e = null;
            }
            else
            {
                e = scrubReturnValue(место, e);
                if (CTFEExp.isCantExp(e) || e.op == ТОК2.error)
                    return e;
            }
        }
        return null;
    }

    Выражение scrubSE(StructLiteralExp sle)
    {
        sle.ownedByCtfe = OwnedBy.code;
        if (!(sle.stageflags & stageScrub))
        {
            const old = sle.stageflags;
            sle.stageflags |= stageScrub;       // prevent infinite recursion
            if (auto ex = scrubArray(sle.elements, да))
                return ex;
            sle.stageflags = old;
        }
        return null;
    }

    if (e.op == ТОК2.classReference)
    {
        StructLiteralExp sle = (cast(ClassReferenceExp)e).значение;
        if (auto ex = scrubSE(sle))
            return ex;
    }
    else if (auto vie = e.isVoidInitExp())
    {
        выведиОшибку(место, "uninitialized variable `%s` cannot be returned from CTFE", vie.var.вТкст0());
        return new ErrorExp();
    }

    e = resolveSlice(e);

    if (auto sle = e.isStructLiteralExp())
    {
        if (auto ex = scrubSE(sle))
            return ex;
    }
    else if (auto se = e.isStringExp())
    {
        se.ownedByCtfe = OwnedBy.code;
    }
    else if (auto ale = e.isArrayLiteralExp())
    {
        ale.ownedByCtfe = OwnedBy.code;
        if (auto ex = scrubArray(ale.elements))
            return ex;
    }
    else if (auto aae = e.isAssocArrayLiteralExp())
    {
        aae.ownedByCtfe = OwnedBy.code;
        if (auto ex = scrubArray(aae.keys))
            return ex;
        if (auto ex = scrubArray(aae.values))
            return ex;
        aae.тип = toBuiltinAAType(aae.тип);
    }
    else if (auto ve = e.isVectorExp())
    {
        ve.ownedByCtfe = OwnedBy.code;
        if (auto ale = ve.e1.isArrayLiteralExp())
        {
            ale.ownedByCtfe = OwnedBy.code;
            if (auto ex = scrubArray(ale.elements))
                return ex;
        }
    }
    return e;
}

/**************************************
 * Transitively set all .ownedByCtfe to OwnedBy.cache
 */
private Выражение scrubCacheValue(Выражение e)
{
    if (!e)
        return e;

    Выражение scrubArrayCache(Выражения* elems)
    {
        foreach (ref e; *elems)
            e = scrubCacheValue(e);
        return null;
    }

    Выражение scrubSE(StructLiteralExp sle)
    {
        sle.ownedByCtfe = OwnedBy.cache;
        if (!(sle.stageflags & stageScrub))
        {
            const old = sle.stageflags;
            sle.stageflags |= stageScrub;       // prevent infinite recursion
            if (auto ex = scrubArrayCache(sle.elements))
                return ex;
            sle.stageflags = old;
        }
        return null;
    }

    if (e.op == ТОК2.classReference)
    {
        if (auto ex = scrubSE((cast(ClassReferenceExp)e).значение))
            return ex;
    }
    else if (auto sle = e.isStructLiteralExp())
    {
        if (auto ex = scrubSE(sle))
            return ex;
    }
    else if (auto se = e.isStringExp())
    {
        se.ownedByCtfe = OwnedBy.cache;
    }
    else if (auto ale = e.isArrayLiteralExp())
    {
        ale.ownedByCtfe = OwnedBy.cache;
        if (Выражение ex = scrubArrayCache(ale.elements))
            return ex;
    }
    else if (auto aae = e.isAssocArrayLiteralExp())
    {
        aae.ownedByCtfe = OwnedBy.cache;
        if (auto ex = scrubArrayCache(aae.keys))
            return ex;
        if (auto ex = scrubArrayCache(aae.values))
            return ex;
    }
    else if (auto ve = e.isVectorExp())
    {
        ve.ownedByCtfe = OwnedBy.cache;
        if (auto ale = ve.e1.isArrayLiteralExp())
        {
            ale.ownedByCtfe = OwnedBy.cache;
            if (auto ex = scrubArrayCache(ale.elements))
                return ex;
        }
    }
    return e;
}

/********************************************
 * Transitively replace all Выражения allocated in ctfeGlobals.region
 * with Пам owned copies.
 * Параметры:
 *      e = possible ctfeGlobals.region owned Выражение
 * Возвращает:
 *      Пам owned Выражение
 */
private Выражение copyRegionExp(Выражение e)
{
    if (!e)
        return e;

    static проц copyArray(Выражения* elems)
    {
        foreach (ref e; *elems)
        {
            auto ex = e;
            e = null;
            e = copyRegionExp(ex);
        }
    }

    static проц copySE(StructLiteralExp sle)
    {
        if (1 || !(sle.stageflags & stageScrub))
        {
            const old = sle.stageflags;
            sle.stageflags |= stageScrub;       // prevent infinite recursion
            copyArray(sle.elements);
            sle.stageflags = old;
        }
    }

    switch (e.op)
    {
        case ТОК2.classReference:
        {
            auto cre = e.isClassReferenceExp();
            cre.значение = copyRegionExp(cre.значение).isStructLiteralExp();
            break;
        }

        case ТОК2.structLiteral:
        {
            auto sle = e.isStructLiteralExp();

            /* The following is to take care of updating sle.origin correctly,
             * which may have multiple objects pointing to it.
             */
            if (sle.isOriginal && !ctfeGlobals.region.содержит(cast(ук)sle.origin))
            {
                /* This means sle has already been moved out of the region,
                 * and sle.origin is the new location.
                 */
                return sle.origin;
            }
            copySE(sle);
            sle.isOriginal = sle is sle.origin;

            auto slec = ctfeGlobals.region.содержит(cast(ук)e)
                ? e.копируй().isStructLiteralExp()         // move sle out of region to slec
                : sle;

            if (ctfeGlobals.region.содержит(cast(ук)sle.origin))
            {
                auto sleo = sle.origin == sle ? slec : sle.origin.копируй().isStructLiteralExp();
                sle.origin = sleo;
                slec.origin = sleo;
            }
            return slec;
        }

        case ТОК2.arrayLiteral:
        {
            auto ale = e.isArrayLiteralExp();
            ale.basis = copyRegionExp(ale.basis);
            copyArray(ale.elements);
            break;
        }

        case ТОК2.assocArrayLiteral:
            copyArray(e.isAssocArrayLiteralExp().keys);
            copyArray(e.isAssocArrayLiteralExp().values);
            break;

        case ТОК2.slice:
        {
            auto se = e.isSliceExp();
            se.e1  = copyRegionExp(se.e1);
            se.upr = copyRegionExp(se.upr);
            se.lwr = copyRegionExp(se.lwr);
            break;
        }

        case ТОК2.кортеж:
        {
            auto te = e.isTupleExp();
            te.e0 = copyRegionExp(te.e0);
            copyArray(te.exps);
            break;
        }

        case ТОК2.address:
        case ТОК2.delegate_:
        case ТОК2.vector:
        case ТОК2.dotVariable:
        {
            UnaExp ue = cast(UnaExp)e;
            ue.e1 = copyRegionExp(ue.e1);
            break;
        }

        case ТОК2.index:
        {
            BinExp be = cast(BinExp)e;
            be.e1 = copyRegionExp(be.e1);
            be.e2 = copyRegionExp(be.e2);
            break;
        }

        case ТОК2.this_:
        case ТОК2.super_:
        case ТОК2.variable:
        case ТОК2.тип:
        case ТОК2.function_:
        case ТОК2.typeid_:
        case ТОК2.string_:
        case ТОК2.int64:
        case ТОК2.error:
        case ТОК2.float64:
        case ТОК2.complex80:
        case ТОК2.null_:
        case ТОК2.void_:
        case ТОК2.symbolOffset:
        case ТОК2.char_:
            break;

        case ТОК2.cantВыражение:
        case ТОК2.voidВыражение:
        case ТОК2.showCtfeContext:
            return e;

        default:
            printf("e: %s, %s\n", Сема2.вТкст0(e.op), e.вТкст0());
            assert(0);
    }

    if (ctfeGlobals.region.содержит(cast(ук)e))
    {
        return e.копируй();
    }
    return e;
}

/******************************* Special Functions ***************************/

private Выражение interpret_length(UnionExp* pue, InterState* istate, Выражение earg)
{
    //printf("interpret_length()\n");
    earg = interpret(pue, earg, istate);
    if (exceptionOrCantInterpret(earg))
        return earg;
    dinteger_t len = 0;
    if (auto aae = earg.isAssocArrayLiteralExp())
        len = aae.keys.dim;
    else
        assert(earg.op == ТОК2.null_);
    emplaceExp!(IntegerExp)(pue, earg.место, len, Тип.tт_мера);
    return pue.exp();
}

private Выражение interpret_keys(UnionExp* pue, InterState* istate, Выражение earg, Тип returnType)
{
    debug (LOG)
    {
        printf("interpret_keys()\n");
    }
    earg = interpret(pue, earg, istate);
    if (exceptionOrCantInterpret(earg))
        return earg;
    if (earg.op == ТОК2.null_)
    {
        emplaceExp!(NullExp)(pue, earg.место, earg.тип);
        return pue.exp();
    }
    if (earg.op != ТОК2.assocArrayLiteral && earg.тип.toBasetype().ty != Taarray)
        return null;
    AssocArrayLiteralExp aae = earg.isAssocArrayLiteralExp();
    auto ae = ctfeEmplaceExp!(ArrayLiteralExp)(aae.место, returnType, aae.keys);
    ae.ownedByCtfe = aae.ownedByCtfe;
    *pue = copyLiteral(ae);
    return pue.exp();
}

private Выражение interpret_values(UnionExp* pue, InterState* istate, Выражение earg, Тип returnType)
{
    debug (LOG)
    {
        printf("interpret_values()\n");
    }
    earg = interpret(pue, earg, istate);
    if (exceptionOrCantInterpret(earg))
        return earg;
    if (earg.op == ТОК2.null_)
    {
        emplaceExp!(NullExp)(pue, earg.место, earg.тип);
        return pue.exp();
    }
    if (earg.op != ТОК2.assocArrayLiteral && earg.тип.toBasetype().ty != Taarray)
        return null;
    auto aae = earg.isAssocArrayLiteralExp();
    auto ae = ctfeEmplaceExp!(ArrayLiteralExp)(aae.место, returnType, aae.values);
    ae.ownedByCtfe = aae.ownedByCtfe;
    //printf("результат is %s\n", e.вТкст0());
    *pue = copyLiteral(ae);
    return pue.exp();
}

private Выражение interpret_dup(UnionExp* pue, InterState* istate, Выражение earg)
{
    debug (LOG)
    {
        printf("interpret_dup()\n");
    }
    earg = interpret(pue, earg, istate);
    if (exceptionOrCantInterpret(earg))
        return earg;
    if (earg.op == ТОК2.null_)
    {
        emplaceExp!(NullExp)(pue, earg.место, earg.тип);
        return pue.exp();
    }
    if (earg.op != ТОК2.assocArrayLiteral && earg.тип.toBasetype().ty != Taarray)
        return null;
    auto aae = copyLiteral(earg).копируй().isAssocArrayLiteralExp();
    for (т_мера i = 0; i < aae.keys.dim; i++)
    {
        if (Выражение e = evaluatePostblit(istate, (*aae.keys)[i]))
            return e;
        if (Выражение e = evaluatePostblit(istate, (*aae.values)[i]))
            return e;
    }
    aae.тип = earg.тип.mutableOf(); // repaint тип from const(цел[цел]) to const(цел)[цел]
    //printf("результат is %s\n", aae.вТкст0());
    return aae;
}

// signature is цел delegate(ref Значение) OR цел delegate(ref Ключ, ref Значение)
private Выражение interpret_aaApply(UnionExp* pue, InterState* istate, Выражение aa, Выражение deleg)
{
    aa = interpret(aa, istate);
    if (exceptionOrCantInterpret(aa))
        return aa;
    if (aa.op != ТОК2.assocArrayLiteral)
    {
        emplaceExp!(IntegerExp)(pue, deleg.место, 0, Тип.tт_мера);
        return pue.exp();
    }

    FuncDeclaration fd = null;
    Выражение pthis = null;
    if (auto de = deleg.isDelegateExp())
    {
        fd = de.func;
        pthis = de.e1;
    }
    else if (auto fe = deleg.isFuncExp())
        fd = fe.fd;

    assert(fd && fd.fbody);
    assert(fd.parameters);
    т_мера numParams = fd.parameters.dim;
    assert(numParams == 1 || numParams == 2);

    Параметр2 fparam = fd.тип.isTypeFunction().parameterList[numParams - 1];
    бул wantRefValue = 0 != (fparam.классХранения & (STC.out_ | STC.ref_));

    Выражения args = Выражения(numParams);

    AssocArrayLiteralExp ae = cast(AssocArrayLiteralExp)aa;
    if (!ae.keys || ae.keys.dim == 0)
        return ctfeEmplaceExp!(IntegerExp)(deleg.место, 0, Тип.tт_мера);
    Выражение eрезультат;

    for (т_мера i = 0; i < ae.keys.dim; ++i)
    {
        Выражение ekey = (*ae.keys)[i];
        Выражение evalue = (*ae.values)[i];
        if (wantRefValue)
        {
            Тип t = evalue.тип;
            evalue = ctfeEmplaceExp!(IndexExp)(deleg.место, ae, ekey);
            evalue.тип = t;
        }
        args[numParams - 1] = evalue;
        if (numParams == 2)
            args[0] = ekey;

        UnionExp ue = проц;
        eрезультат = interpretFunction(&ue, fd, istate, &args, pthis);
        if (eрезультат == ue.exp())
            eрезультат = ue.копируй();
        if (exceptionOrCantInterpret(eрезультат))
            return eрезультат;

        if (eрезультат.isIntegerExp().getInteger() != 0)
            return eрезультат;
    }
    return eрезультат;
}

/* Decoding UTF strings for foreach loops. Duplicates the functionality of
 * the twelve _aApplyXXn functions in aApply.d in the runtime.
 */
private Выражение foreachApplyUtf(UnionExp* pue, InterState* istate, Выражение str, Выражение deleg, бул rvs)
{
    debug (LOG)
    {
        printf("foreachApplyUtf(%s, %s)\n", str.вТкст0(), deleg.вТкст0());
    }
    FuncDeclaration fd = null;
    Выражение pthis = null;
    if (auto de = deleg.isDelegateExp())
    {
        fd = de.func;
        pthis = de.e1;
    }
    else if (auto fe = deleg.isFuncExp())
        fd = fe.fd;

    assert(fd && fd.fbody);
    assert(fd.parameters);
    т_мера numParams = fd.parameters.dim;
    assert(numParams == 1 || numParams == 2);
    Тип charType = (*fd.parameters)[numParams - 1].тип;
    Тип indexType = numParams == 2 ? (*fd.parameters)[0].тип : Тип.tт_мера;
    т_мера len = cast(т_мера)resolveArrayLength(str);
    if (len == 0)
    {
        emplaceExp!(IntegerExp)(pue, deleg.место, 0, indexType);
        return pue.exp();
    }

    UnionExp strTmp = проц;
    str = resolveSlice(str, &strTmp);

    auto se = str.isStringExp();
    auto ale = str.isArrayLiteralExp();
    if (!se && !ale)
    {
        str.выведиОшибку("CTFE internal error: cannot foreach `%s`", str.вТкст0());
        return CTFEExp.cantexp;
    }
    Выражения args = Выражения(numParams);

    Выражение eрезультат = null; // ded-store to prevent spurious warning

    // Buffers for encoding; also используется for decoding массив literals
    сим[4] utf8buf = проц;
    wchar[2] utf16buf = проц;

    т_мера start = rvs ? len : 0;
    т_мера end = rvs ? 0 : len;
    for (т_мера indx = start; indx != end;)
    {
        // Step 1: Decode the следщ dchar from the ткст.

        ткст errmsg = null; // Used for reporting decoding errors
        dchar rawvalue; // Holds the decoded dchar
        т_мера currentIndex = indx; // The index of the decoded character

        if (ale)
        {
            // If it is an массив literal, копируй the code points into the буфер
            т_мера buflen = 1; // #code points in the буфер
            т_мера n = 1; // #code points in this сим
            т_мера sz = cast(т_мера)ale.тип.nextOf().size();

            switch (sz)
            {
            case 1:
                if (rvs)
                {
                    // найди the start of the ткст
                    --indx;
                    buflen = 1;
                    while (indx > 0 && buflen < 4)
                    {
                        Выражение r = (*ale.elements)[indx];
                        сим x = cast(сим)r.isIntegerExp().getInteger();
                        if ((x & 0xC0) != 0x80)
                            break;
                        --indx;
                        ++buflen;
                    }
                }
                else
                    buflen = (indx + 4 > len) ? len - indx : 4;
                for (т_мера i = 0; i < buflen; ++i)
                {
                    Выражение r = (*ale.elements)[indx + i];
                    utf8buf[i] = cast(сим)r.isIntegerExp().getInteger();
                }
                n = 0;
                errmsg = utf_decodeChar(utf8buf[0 .. buflen], n, rawvalue);
                break;

            case 2:
                if (rvs)
                {
                    // найди the start of the ткст
                    --indx;
                    buflen = 1;
                    Выражение r = (*ale.elements)[indx];
                    ushort x = cast(ushort)r.isIntegerExp().getInteger();
                    if (indx > 0 && x >= 0xDC00 && x <= 0xDFFF)
                    {
                        --indx;
                        ++buflen;
                    }
                }
                else
                    buflen = (indx + 2 > len) ? len - indx : 2;
                for (т_мера i = 0; i < buflen; ++i)
                {
                    Выражение r = (*ale.elements)[indx + i];
                    utf16buf[i] = cast(ushort)r.isIntegerExp().getInteger();
                }
                n = 0;
                errmsg = utf_decodeWchar(utf16buf[0 .. buflen], n, rawvalue);
                break;

            case 4:
                {
                    if (rvs)
                        --indx;
                    Выражение r = (*ale.elements)[indx];
                    rawvalue = cast(dchar)r.isIntegerExp().getInteger();
                    n = 1;
                }
                break;

            default:
                assert(0);
            }
            if (!rvs)
                indx += n;
        }
        else
        {
            // String literals
            т_мера saveindx; // используется for reverse iteration

            switch (se.sz)
            {
            case 1:
            {
                if (rvs)
                {
                    // найди the start of the ткст
                    --indx;
                    while (indx > 0 && ((se.getCodeUnit(indx) & 0xC0) == 0x80))
                        --indx;
                    saveindx = indx;
                }
                auto slice = se.peekString();
                errmsg = utf_decodeChar(slice, indx, rawvalue);
                if (rvs)
                    indx = saveindx;
                break;
            }

            case 2:
                if (rvs)
                {
                    // найди the start
                    --indx;
                    auto wc = se.getCodeUnit(indx);
                    if (wc >= 0xDC00 && wc <= 0xDFFF)
                        --indx;
                    saveindx = indx;
                }
                const slice = se.peekWstring();
                errmsg = utf_decodeWchar(slice, indx, rawvalue);
                if (rvs)
                    indx = saveindx;
                break;

            case 4:
                if (rvs)
                    --indx;
                rawvalue = se.getCodeUnit(indx);
                if (!rvs)
                    ++indx;
                break;

            default:
                assert(0);
            }
        }
        if (errmsg)
        {
            deleg.выведиОшибку("`%.*s`", cast(цел)errmsg.length, errmsg.ptr);
            return CTFEExp.cantexp;
        }

        // Step 2: encode the dchar in the target encoding

        цел charlen = 1; // How many codepoints are involved?
        switch (charType.size())
        {
        case 1:
            charlen = utf_codeLengthChar(rawvalue);
            utf_encodeChar(&utf8buf[0], rawvalue);
            break;
        case 2:
            charlen = utf_codeLengthWchar(rawvalue);
            utf_encodeWchar(&utf16buf[0], rawvalue);
            break;
        case 4:
            break;
        default:
            assert(0);
        }
        if (rvs)
            currentIndex = indx;

        // Step 3: call the delegate once for each code point

        // The index only needs to be set once
        if (numParams == 2)
            args[0] = ctfeEmplaceExp!(IntegerExp)(deleg.место, currentIndex, indexType);

        Выражение val = null;

        foreach (k; new бцел[0 .. charlen])
        {
            dchar codepoint;
            switch (charType.size())
            {
            case 1:
                codepoint = utf8buf[k];
                break;
            case 2:
                codepoint = utf16buf[k];
                break;
            case 4:
                codepoint = rawvalue;
                break;
            default:
                assert(0);
            }
            val = ctfeEmplaceExp!(IntegerExp)(str.место, codepoint, charType);

            args[numParams - 1] = val;

            UnionExp ue = проц;
            eрезультат = interpretFunction(&ue, fd, istate, &args, pthis);
            if (eрезультат == ue.exp())
                eрезультат = ue.копируй();
            if (exceptionOrCantInterpret(eрезультат))
                return eрезультат;
            if (eрезультат.isIntegerExp().getInteger() != 0)
                return eрезультат;
        }
    }
    return eрезультат;
}

/* If this is a built-in function, return the interpreted результат,
 * Otherwise, return NULL.
 */
private Выражение evaluateIfBuiltin(UnionExp* pue, InterState* istate, ref Место место, FuncDeclaration fd, Выражения* arguments, Выражение pthis)
{
    Выражение e = null;
    т_мера nargs = arguments ? arguments.dim : 0;
    if (!pthis)
    {
        if (isBuiltin(fd) == BUILTIN.yes)
        {
            Выражения args = Выражения(nargs);
            foreach (i, ref arg; args)
            {
                Выражение earg = (*arguments)[i];
                earg = interpret(earg, istate);
                if (exceptionOrCantInterpret(earg))
                    return earg;
                arg = earg;
            }
            e = eval_builtin(место, fd, &args);
            if (!e)
            {
                выведиОшибку(место, "cannot evaluate unimplemented builtin `%s` at compile time", fd.вТкст0());
                e = CTFEExp.cantexp;
            }
        }
    }
    if (!pthis)
    {
        if (nargs == 1 || nargs == 3)
        {
            Выражение firstarg = (*arguments)[0];
            if (auto firstAAtype = firstarg.тип.toBasetype().isTypeAArray())
            {
                const ид = fd.идент;
                if (nargs == 1)
                {
                    if (ид == Id.aaLen)
                        return interpret_length(pue, istate, firstarg);

                    if (fd.toParent2().идент == Id.объект)
                    {
                        if (ид == Id.keys)
                            return interpret_keys(pue, istate, firstarg, firstAAtype.index.arrayOf());
                        if (ид == Id.values)
                            return interpret_values(pue, istate, firstarg, firstAAtype.nextOf().arrayOf());
                        if (ид == Id.rehash)
                            return interpret(pue, firstarg, istate);
                        if (ид == Id.dup)
                            return interpret_dup(pue, istate, firstarg);
                    }
                }
                else // (nargs == 3)
                {
                    if (ид == Id._aaApply)
                        return interpret_aaApply(pue, istate, firstarg, (*arguments)[2]);
                    if (ид == Id._aaApply2)
                        return interpret_aaApply(pue, istate, firstarg, (*arguments)[2]);
                }
            }
        }
    }
    if (pthis && !fd.fbody && fd.isCtorDeclaration() && fd.родитель && fd.родитель.родитель && fd.родитель.родитель.идент == Id.объект)
    {
        if (pthis.op == ТОК2.classReference && fd.родитель.идент == Id.Throwable)
        {
            // At present, the constructors just копируй their arguments into the struct.
            // But we might need some magic if stack tracing gets added to druntime.
            StructLiteralExp se = (cast(ClassReferenceExp)pthis).значение;
            assert(arguments.dim <= se.elements.dim);
            foreach (i, arg; *arguments)
            {
                auto elem = interpret(arg, istate);
                if (exceptionOrCantInterpret(elem))
                    return elem;
                (*se.elements)[i] = elem;
            }
            return CTFEExp.voidexp;
        }
    }
    if (nargs == 1 && !pthis && (fd.идент == Id.criticalenter || fd.идент == Id.criticalexit))
    {
        // Support synchronized{} as a no-op
        return CTFEExp.voidexp;
    }
    if (!pthis)
    {
        const idlen = fd.идент.вТкст().length;
        const ид = fd.идент.вТкст0();
        if (nargs == 2 && (idlen == 10 || idlen == 11) && !strncmp(ид, "_aApply", 7))
        {
            // Functions from aApply.d and aApplyR.d in the runtime
            бул rvs = (idlen == 11); // да if foreach_reverse
            сим c = ид[idlen - 3]; // сим width: 'c', 'w', or 'd'
            сим s = ид[idlen - 2]; // ткст width: 'c', 'w', or 'd'
            сим n = ид[idlen - 1]; // numParams: 1 or 2.
            // There are 12 combinations
            if ((n == '1' || n == '2') &&
                (c == 'c' || c == 'w' || c == 'd') &&
                (s == 'c' || s == 'w' || s == 'd') &&
                c != s)
            {
                Выражение str = (*arguments)[0];
                str = interpret(str, istate);
                if (exceptionOrCantInterpret(str))
                    return str;
                return foreachApplyUtf(pue, istate, str, (*arguments)[1], rvs);
            }
        }
    }
    return e;
}

private Выражение evaluatePostblit(InterState* istate, Выражение e)
{
    auto ts = e.тип.baseElemOf().isTypeStruct();
    if (!ts)
        return null;
    StructDeclaration sd = ts.sym;
    if (!sd.postblit)
        return null;

    if (auto ale = e.isArrayLiteralExp())
    {
        foreach (elem; *ale.elements)
        {
            if (auto ex = evaluatePostblit(istate, elem))
                return ex;
        }
        return null;
    }
    if (e.op == ТОК2.structLiteral)
    {
        // e.__postblit()
        UnionExp ue = проц;
        e = interpretFunction(&ue, sd.postblit, istate, null, e);
        if (e == ue.exp())
            e = ue.копируй();
        if (exceptionOrCantInterpret(e))
            return e;
        return null;
    }
    assert(0);
}

private Выражение evaluateDtor(InterState* istate, Выражение e)
{
    auto ts = e.тип.baseElemOf().isTypeStruct();
    if (!ts)
        return null;
    StructDeclaration sd = ts.sym;
    if (!sd.dtor)
        return null;

    UnionExp ue = проц;
    if (auto ale = e.isArrayLiteralExp())
    {
        foreach_reverse (elem; *ale.elements)
            e = evaluateDtor(istate, elem);
    }
    else if (e.op == ТОК2.structLiteral)
    {
        // e.__dtor()
        e = interpretFunction(&ue, sd.dtor, istate, null, e);
    }
    else
        assert(0);
    if (exceptionOrCantInterpret(e))
    {
        if (e == ue.exp())
            e = ue.копируй();
        return e;
    }
    return null;
}

/*************************** CTFE Sanity Checks ***************************/
/* Setter functions for CTFE variable values.
 * These functions exist to check for compiler CTFE bugs.
 */
private бул hasValue(VarDeclaration vd)
{
    return vd.ctfeAdrOnStack != VarDeclaration.AdrOnStackNone &&
           дайЗначение(vd) !is null;
}

// Don't check for validity
private проц setValueWithoutChecking(VarDeclaration vd, Выражение newval)
{
    ctfeGlobals.stack.setValue(vd, newval);
}

private проц setValue(VarDeclaration vd, Выражение newval)
{
    version (none)
    {
        if (!((vd.класс_хранения & (STC.out_ | STC.ref_)) ? isCtfeReferenceValid(newval) : isCtfeValueValid(newval)))
        {
            printf("[%s] vd = %s %s, newval = %s\n", vd.место.вТкст0(), vd.тип.вТкст0(), vd.вТкст0(), newval.вТкст0());
        }
    }
    assert((vd.класс_хранения & (STC.out_ | STC.ref_)) ? isCtfeReferenceValid(newval) : isCtfeValueValid(newval));
    ctfeGlobals.stack.setValue(vd, newval);
}

/**
 * Removes `_d_HookTraceImpl` if found from `ce` and `fd`.
 * This is needed for the CTFE interception code to be able to найди hooks that are called though the hook's `*Trace`
 * wrapper.
 *
 * This is done by replacing `_d_HookTraceImpl!(T, Hook, errMsg)(..., parameters)` with `Hook(parameters)`.
 * Параметры:
 *  ce = The CallExp that possible will be be replaced
 *  fd = Fully resolve function declaration that `ce` would call
 */
private проц removeHookTraceImpl(ref CallExp ce, ref FuncDeclaration fd)
{
    if (fd.идент != Id._d_HookTraceImpl)
        return;

    auto oldCE = ce;

    // Get the Hook from the second template параметр
    TemplateInstance templateInstance = fd.родитель.isTemplateInstance;
    КорневойОбъект hook = (*templateInstance.tiargs)[1];
    assert(hook.динкаст() == ДИНКАСТ.дсимвол, "Expected _d_HookTraceImpl's second template параметр to be an alias to the hook!");
    fd = (cast(ДСимвол)hook).isFuncDeclaration;

    // Remove the first three trace parameters
    auto arguments = new Выражения();
    arguments.резервируй(ce.arguments.dim - 3);
    arguments.суньСрез((*ce.arguments)[3 .. $]);

    ce = ctfeEmplaceExp!(CallExp)(ce.место, ctfeEmplaceExp!(VarExp)(ce.место, fd, нет), arguments);

    if (глоб2.парамы.verbose)
        message("strip     %s =>\n          %s", oldCE.вТкст0(), ce.вТкст0());
}
