/**
 * Flow analysis for Ownership/Borrowing
 *
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2019 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/ob.d, _ob.d)
 * Documentation:  https://dlang.org/phobos/dmd_escape.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/ob.d
 */

module dmd.ob;

import cidrus;

import util.array;
import drc.ast.Node;
import util.rmem;

import dmd.aggregate;
import dmd.apply;
import dmd.arraytypes;
import dmd.declaration;
import dmd.dscope;
import dmd.дсимвол;
import dmd.dtemplate;
import dmd.errors;
import dmd.escape;
import drc.ast.Expression;
import dmd.foreachvar;
import dmd.func;
import dmd.globals;
import drc.lexer.Identifier;
import dmd.init;
import dmd.mtype;
import dmd.printast;
import dmd.инструкция;
import drc.lexer.Tokens;
import drc.ast.Visitor;

import util.bitarray;
import util.outbuffer;

/**********************************
 * Perform ownership/borrowing checks for funcdecl.
 * Does not modify the AST, just checks for errors.
 */

проц oblive(FuncDeclaration funcdecl)
{
    //printf("oblive() %s\n", funcdecl.вТкст0());
    //printf("fbody: %s\n", funcdecl.fbody.вТкст0());
    ObState obstate;

    /* Build the flow graph
     */
    setLabelStatementExtraFields(funcdecl.labtab);
    toObNodes(obstate.nodes, funcdecl.fbody);
    insertFinallyBlockCalls(obstate.nodes);
    insertFinallyBlockGotos(obstate.nodes);
    removeUnreachable(obstate.nodes);
    computePreds(obstate.nodes);

    numberNodes(obstate.nodes);
    //foreach (ob; obstate.nodes) ob.print();

    collectVars(funcdecl, obstate.vars);
    allocStates(obstate);
    doDataFlowAnalysis(obstate);

    checkObErrors(obstate);
}

alias МассивДРК!(ObNode*) ObNodes;

/*******************************************
 * Collect the state information.
 */
struct ObState
{
    ObNodes nodes;
    VarDeclarations vars;

    МассивДРК!(т_мера) varStack;      /// temporary storage
    МассивДРК!(бул) mutableStack;    /// parallel to varStack[], is тип mutable?

    PtrVarState[] varPool;      /// memory pool

    ~this()
    {
        mem.xfree(varPool.ptr);
    }
}

/***********************************************
 * A узел in the function's Выражение graph, and its edges to predecessors and successors.
 */
struct ObNode
{
    Выражение exp;     /// Выражение for the узел
    ObNodes preds;      /// predecessors
    ObNodes succs;      /// successors
    ObNode* tryBlock;   /// try-finally block we're inside
    ObType obtype;
    бцел index;         /// index of this in obnodes

    PtrVarState[] gen;    /// new states generated for this узел
    PtrVarState[] input;  /// variable states on entry to exp
    PtrVarState[] output; /// variable states on exit to exp

    this(ObNode* tryBlock)
    {
        this.tryBlock = tryBlock;
    }

    проц print()
    {
        printf("%d: %s %s\n", index, obtype.вТкст.ptr, exp ? exp.вТкст0() : "-");
        printf("  preds: ");
        foreach (ob; preds)
            printf(" %d", ob.index);
        printf("\n  succs: ");
        foreach (ob; succs)
            printf(" %d", ob.index);
        printf("\n\n");
    }
}


enum ObType : ббайт
{
    goto_,              /// goto one of the succs[]
    return_,            /// returns from function
    retexp,             /// returns Выражение from function
    throw_,             /// exits with throw
    exit,               /// exits program
    try_,
    finally_,
    fend,
}

ткст вТкст(ObType obtype)
{
    return obtype == ObType.goto_     ? "goto  "  :
           obtype == ObType.return_   ? "ret   "  :
           obtype == ObType.retexp    ? "retexp"  :
           obtype == ObType.throw_    ? "throw"   :
           obtype == ObType.exit      ? "exit"    :
           obtype == ObType.try_      ? "try"     :
           obtype == ObType.finally_  ? "finally" :
           obtype == ObType.fend      ? "fend"    :
           "---";
}

/***********
 Pointer variable states:

    Undefined   not in a usable state

                T* p = проц;

    Owner       mutable pointer

                T* p = инициализатор;

    Borrowed    scope mutable pointer, borrowed from [p]

                T* p = инициализатор;
                scope T* b = p;

    Readonly    scope const pointer, copied from [p]

                T* p = инициализатор;
                scope const(T)* cp = p;

 Examples:

    T* p = инициализатор; // p is owner
    T** pp = &p;        // pp borrows from p

    T* p = initialize;  // p is owner
    T* q = p;           // transfer: q is owner, p is undefined
 */

enum PtrState : ббайт
{
    Undefined, Owner, Borrowed, Readonly
}

/************
 */
ткст0 вТкст0(PtrState state)
{
    return ["Undefined", "Owner", "Borrowed", "Readonly"][state].ptr;
}

/******
 * Carries the state of a pointer variable.
 */
struct PtrVarState
{
    МассивБит deps;           /// dependencies
    PtrState state;          /// state the pointer variable is in

    проц opAssign(ref PtrVarState pvs)
    {
        state = pvs.state;
        deps = pvs.deps;
    }

    /* Combine `this` and `pvs` into `this`,
     * on the idea that the `this` and the `pvs` paths
     * are being merged
     * Параметры:
     *  pvs = path to be merged with `this`
     */
    проц combine(ref PtrVarState pvs, т_мера vi, PtrVarState[] gen)
    {
        static бцел X(PtrState x1, PtrState x2) { return x1 * (PtrState.max + 1) + x2; }

        with (PtrState)
        {
            switch (X(state, pvs.state))
            {
                case X(Undefined, Undefined):
                case X(Undefined, Owner    ):
                case X(Undefined, Borrowed ):
                case X(Undefined, Readonly ):
                    break;

                case X(Owner    , Owner   ):
                    break;

                case X(Borrowed , Borrowed):
                case X(Readonly , Readonly):
                    deps.or(pvs.deps);
                    break;

                default:
                    makeUndefined(vi, gen);
                    break;
            }
        }
    }

    бул opEquals(ref PtrVarState pvs) 
    {
        return state == pvs.state &&
                deps == pvs.deps;
    }

    /***********************
     */
    проц print(VarDeclaration[] vars)
    {
        ткст s = ["Undefined", "Owner", "Borrowed", "Lent", "Readonly", "View"][state];
        printf("%.*s [", cast(цел)s.length, s.ptr);
        assert(vars.length == deps.length);
        БуфВыв буф;
        depsToBuf(буф, vars);
        ткст t = буф[];
        printf("%.*s]\n", cast(цел)t.length, t.ptr);
    }

    /*****************************
     * Produce a user-readable comma separated ткст of the
     * dependencies.
     * Параметры:
     *  буф = пиши результатing ткст here
     *  vars = массив from which to get the variable имена
     */
    проц depsToBuf(ref БуфВыв буф,  VarDeclaration[] vars)
    {
        бул any = нет;
        foreach (i; new бцел[0 .. deps.length])
        {
            if (deps[i])
            {
                if (any)
                    буф.пишиСтр(", ");
                буф.пишиСтр(vars[i].вТкст());
                any = да;
            }
        }
    }
}


/*****************************************
 * Set the `.extra` field for LabelStatements in labtab[].
 */
проц setLabelStatementExtraFields(DsymbolTable labtab)
{
    if (labtab)
        foreach (ключЗначение; labtab.tab.asRange)
        {
            //printf("  KV: %s = %s\n", ключЗначение.ключ.вТкст0(), ключЗначение.значение.вТкст0());
            auto label = cast(LabelDsymbol)ключЗначение.значение;
            if (label.инструкция)
                label.инструкция.extra = cast(ук) new ObNode(null);
        }
}

/*****************************************
 * Convert инструкция into ObNodes.
 */

проц toObNodes(ref ObNodes obnodes, Инструкция2 s)
{
    ObNode* breakBlock;
    ObNode* contBlock;
    ObNode* switchBlock;
    ObNode* defaultBlock;
    ObNode* tryBlock;

    ObNode* curblock = new ObNode(tryBlock);
    obnodes.сунь(curblock);

    проц посети(Инструкция2 s)
    {
        if (!s)
            return;

        ObNode* newNode()
        {
            return new ObNode(tryBlock);
        }

        ObNode* nextNodeIs(ObNode* ob)
        {
            obnodes.сунь(ob);
            curblock = ob;
            return ob;
        }

        ObNode* nextNode()
        {
            return nextNodeIs(newNode());
        }

        ObNode* gotoNextNodeIs(ObNode* ob)
        {
            obnodes.сунь(ob);
            curblock.succs.сунь(ob);
            curblock = ob;
            return ob;
        }

        // block_goto(blx, BCgoto, null)
        ObNode* gotoNextNode()
        {
            return gotoNextNodeIs(newNode());
        }

        /***
         * Doing a goto to dest
         */
        ObNode* gotoDest(ObNode* dest)
        {
            curblock.succs.сунь(dest);
            return nextNode();
        }

        проц visitExp(ExpStatement s)
        {
            curblock.obtype = ObType.goto_;
            curblock.exp = s.exp;
            gotoNextNode();
        }

        проц visitDtorExp(DtorExpStatement s)
        {
            visitExp(s);
        }

        проц visitCompound(CompoundStatement s)
        {
            if (s.statements)
            {
                foreach (s2; *s.statements)
                {
                    посети(s2);
                }
            }
        }

        проц visitCompoundDeclaration(CompoundDeclarationStatement s)
        {
            visitCompound(s);
        }

        проц visitUnrolledLoop(UnrolledLoopStatement s)
        {
            auto breakBlockSave = breakBlock;
            breakBlock = newNode();
            auto contBlockSave = contBlock;

            gotoNextNode();

            foreach (s2; *s.statements)
            {
                if (s2)
                {
                    contBlock = newNode();

                    посети(s2);

                    gotoNextNodeIs(contBlock);
                }
            }

            gotoNextNodeIs(breakBlock);

            contBlock = contBlockSave;
            breakBlock = breakBlockSave;
        }

        проц visitScope(ScopeStatement s)
        {
            if (s.инструкция)
            {
                посети(s.инструкция);

                if (breakBlock)
                {
                    gotoNextNodeIs(breakBlock);
                }
            }
        }

        проц visitDo(DoStatement s)
        {
            auto breakBlockSave = breakBlock;
            auto contBlockSave = contBlock;

            breakBlock = newNode();
            contBlock = newNode();

            auto bpre = curblock;

            auto ob = newNode();
            obnodes.сунь(ob);
            curblock.succs.сунь(ob);
            curblock = ob;
            bpre.succs.сунь(curblock);

            contBlock.succs.сунь(curblock);
            contBlock.succs.сунь(breakBlock);

            посети(s._body);

            gotoNextNodeIs(contBlock);
            contBlock.exp = s.условие;
            nextNodeIs(breakBlock);

            contBlock = contBlockSave;
            breakBlock = breakBlockSave;
        }

        проц visitFor(ForStatement s)
        {
            //printf("посети(ForStatement)) %u..%u\n", s.место.номстр, s.endloc.номстр);
            auto breakBlockSave = breakBlock;
            auto contBlockSave = contBlock;

            breakBlock = newNode();
            contBlock = newNode();

            посети(s._иниц);

            auto bcond = gotoNextNode();
            contBlock.succs.сунь(bcond);

            if (s.условие)
            {
                bcond.exp = s.условие;
                auto ob = newNode();
                obnodes.сунь(ob);
                bcond.succs.сунь(ob);
                bcond.succs.сунь(breakBlock);
                curblock = ob;
            }
            else
            {   /* No conditional, it's a straight goto
                 */
                bcond.exp = s.условие;
                bcond.succs.сунь(nextNode());
            }

            посети(s._body);
            /* End of the body goes to the continue block
             */
            curblock.succs.сунь(contBlock);
            nextNodeIs(contBlock);

            if (s.increment)
                curblock.exp = s.increment;

            /* The 'break' block follows the for инструкция.
             */
            nextNodeIs(breakBlock);

            contBlock = contBlockSave;
            breakBlock = breakBlockSave;
        }

        проц visitIf(IfStatement s)
        {
            // bexit is the block that gets control after this IfStatement is done
            auto bexit = breakBlock ? breakBlock : newNode();

            curblock.exp = s.условие;

            auto bcond = curblock;
            gotoNextNode();

            посети(s.ifbody);
            curblock.succs.сунь(bexit);

            if (s.elsebody)
            {
                bcond.succs.сунь(nextNode());

                посети(s.elsebody);

                gotoNextNodeIs(bexit);
            }
            else
            {
                bcond.succs.сунь(bexit);
                nextNodeIs(bexit);
            }
        }

        проц visitSwitch(SwitchStatement s)
        {
            auto breakBlockSave = breakBlock;
            auto switchBlockSave = switchBlock;
            auto defaultBlockSave = defaultBlock;

            switchBlock = curblock;

            /* Block for where "break" goes to
             */
            breakBlock = newNode();

            /* Block for where "default" goes to.
             * If there is a default инструкция, then that is where default goes.
             * If not, then do:
             *   default: break;
             * by making the default block the same as the break block.
             */
            defaultBlock = s.sdefault ? newNode() : breakBlock;

            const numcases = s.cases ? s.cases.dim : 0;

            /* размести a block for each case
             */
            if (numcases)
                foreach (cs; *s.cases)
                {
                    cs.extra = cast(ук)newNode();
                }

            curblock.exp = s.условие;

            if (s.hasVars)
            {   /* Generate a sequence of if-then-else blocks for the cases.
                 */
                if (numcases)
                    foreach (cs; *s.cases)
                    {
                        auto ecase = newNode();
                        obnodes.сунь(ecase);
                        ecase.exp = cs.exp;
                        curblock.succs.сунь(ecase);

                        auto cn = cast(ObNode*)cs.extra;
                        ecase.succs.сунь(cn);
                        ecase.succs.сунь(nextNode());
                    }

                /* The final 'else' clause goes to the default
                 */
                curblock.succs.сунь(defaultBlock);
                nextNode();

                посети(s._body);

                /* Have the end of the switch body fall through to the block
                 * following the switch инструкция.
                 */
                gotoNextNodeIs(breakBlock);

                breakBlock = breakBlockSave;
                switchBlock = switchBlockSave;
                defaultBlock = defaultBlockSave;
                return;
            }

            auto ob = newNode();
            obnodes.сунь(ob);
            curblock = ob;

            switchBlock.succs.сунь(defaultBlock);

            посети(s._body);

            /* Have the end of the switch body fall through to the block
             * following the switch инструкция.
             */
            gotoNextNodeIs(breakBlock);

            breakBlock = breakBlockSave;
            switchBlock = switchBlockSave;
            defaultBlock = defaultBlockSave;
        }

        проц visitCase(CaseStatement s)
        {
            auto cb = cast(ObNode*)s.extra;
            cb.tryBlock = tryBlock;
            switchBlock.succs.сунь(cb);
            cb.tryBlock = tryBlock;
            gotoNextNodeIs(cb);

            посети(s.инструкция);
        }

        проц visitDefault(DefaultStatement s)
        {
            defaultBlock.tryBlock = tryBlock;
            gotoNextNodeIs(defaultBlock);
            посети(s.инструкция);
        }

        проц visitGotoDefault(GotoDefaultStatement s)
        {
            gotoDest(defaultBlock);
        }

        проц visitGotoCase(GotoCaseStatement s)
        {
            gotoDest(cast(ObNode*)s.cs.extra);
        }

        проц visitSwitchError(SwitchErrorStatement s)
        {
            curblock.obtype = ObType.throw_;
            curblock.exp = s.exp;

            nextNode();
        }

        проц visitReturn(ReturnStatement s)
        {
            //printf("visitReturn() %s\n", s.вТкст0());
            curblock.obtype = s.exp && s.exp.тип.toBasetype().ty != Tvoid
                        ? ObType.retexp
                        : ObType.return_;
            curblock.exp = s.exp;

            nextNode();
        }

        проц visitBreak(BreakStatement s)
        {
            gotoDest(breakBlock);
        }

        проц visitContinue(ContinueStatement s)
        {
            gotoDest(contBlock);
        }

        проц visitWith(WithStatement s)
        {
            посети(s._body);
        }

        проц visitTryCatch(TryCatchStatement s)
        {
            /* tryblock
             * body
             * breakBlock
             * catches
             * breakBlock2
             */

            auto breakBlockSave = breakBlock;
            breakBlock = newNode();

            auto tryblock = gotoNextNode();

            посети(s._body);

            gotoNextNodeIs(breakBlock);

            // создай new break block that follows all the catches
            auto breakBlock2 = newNode();

            gotoDest(breakBlock2);

            foreach (cs; *s.catches)
            {
                /* Each catch block is a successor to tryblock
                 * and the last block of try body
                 */
                auto bcatch = curblock;
                tryblock.succs.сунь(bcatch);
                breakBlock.succs.сунь(bcatch);

                nextNode();

                посети(cs.handler);

                gotoDest(breakBlock2);
            }

            curblock.succs.сунь(breakBlock2);
            obnodes.сунь(breakBlock2);
            curblock = breakBlock2;

            breakBlock = breakBlockSave;
        }

        проц visitTryFinally(TryFinallyStatement s)
        {
            /* Build this:
             *  1  goto     [2]
             *  2  try_     [3] [5] [7]
             *  3  body
             *  4  goto     [8]
             *  5  finally_ [6]
             *  6  finalbody
             *  7  fend     [8]
             *  8  lastblock
             */

            auto b2 = gotoNextNode();
            b2.obtype = ObType.try_;
            tryBlock = b2;

            gotoNextNode();

            посети(s._body);

            auto b4 = gotoNextNode();

            tryBlock = b2.tryBlock;

            auto b5 = newNode();
            b5.obtype = ObType.finally_;
            nextNodeIs(b5);
            gotoNextNode();

            посети(s.finalbody);

            auto b7 = gotoNextNode();
            b7.obtype = ObType.fend;

            auto b8 = gotoNextNode();

            b2.succs.сунь(b5);
            b2.succs.сунь(b7);

            b4.succs.сунь(b8);
        }

        проц visitThrow(ThrowStatement s)
        {
            curblock.obtype = ObType.throw_;
            curblock.exp = s.exp;
            nextNode();
        }

        проц visitGoto(GotoStatement s)
        {
            gotoDest(cast(ObNode*)s.label.инструкция.extra);
        }

        проц visitLabel(LabelStatement s)
        {
            auto ob = cast(ObNode*)s.extra;
            ob.tryBlock = tryBlock;
            посети(s.инструкция);
        }

        switch (s.stmt)
        {
            case STMT.Exp:                 visitExp(s.isExpStatement()); break;
            case STMT.DtorExp:             visitDtorExp(s.isDtorExpStatement()); break;
            case STMT.Compound:            visitCompound(s.isCompoundStatement()); break;
            case STMT.CompoundDeclaration: visitCompoundDeclaration(s.isCompoundDeclarationStatement()); break;
            case STMT.UnrolledLoop:        visitUnrolledLoop(s.isUnrolledLoopStatement()); break;
            case STMT.Scope:               visitScope(s.isScopeStatement()); break;
            case STMT.Do:                  visitDo(s.isDoStatement()); break;
            case STMT.For:                 visitFor(s.isForStatement()); break;
            case STMT.If:                  visitIf(s.isIfStatement()); break;
            case STMT.Switch:              visitSwitch(s.isSwitchStatement()); break;
            case STMT.Case:                visitCase(s.isCaseStatement()); break;
            case STMT.Default:             visitDefault(s.isDefaultStatement()); break;
            case STMT.GotoDefault:         visitGotoDefault(s.isGotoDefaultStatement()); break;
            case STMT.GotoCase:            visitGotoCase(s.isGotoCaseStatement()); break;
            case STMT.SwitchError:         visitSwitchError(s.isSwitchErrorStatement()); break;
            case STMT.Return:              visitReturn(s.isReturnStatement()); break;
            case STMT.Break:               visitBreak(s.isBreakStatement()); break;
            case STMT.Continue:            visitContinue(s.isContinueStatement()); break;
            case STMT.With:                visitWith(s.isWithStatement()); break;
            case STMT.TryCatch:            visitTryCatch(s.isTryCatchStatement()); break;
            case STMT.TryFinally:          visitTryFinally(s.isTryFinallyStatement()); break;
            case STMT.Throw:               visitThrow(s.isThrowStatement()); break;
            case STMT.Goto:                visitGoto(s.isGotoStatement()); break;
            case STMT.Label:               visitLabel(s.isLabelStatement()); break;

            case STMT.CompoundAsm:
            case STMT.Asm:
            case STMT.InlineAsm:
            case STMT.GccAsm:

            case STMT.Pragma:
            case STMT.Импорт:
            case STMT.ScopeGuard:
            case STMT.Error:
                break;          // ignore these

            case STMT.Foreach:
            case STMT.ForeachRange:
            case STMT.Debug:
            case STMT.CaseRange:
            case STMT.StaticForeach:
            case STMT.StaticAssert:
            case STMT.Conditional:
            case STMT.While:
            case STMT.Forwarding:
            case STMT.Compile:
            case STMT.Peel:
            case STMT.Synchronized:
                debug printf("s: %s\n", s.вТкст0());
                assert(0);              // should have been rewritten
        }
    }

    посети(s);
    curblock.obtype = ObType.return_;

    assert(breakBlock is null);
    assert(contBlock is null);
    assert(switchBlock is null);
    assert(defaultBlock is null);
    assert(tryBlock is null);
}

/***************************************************
 * Insert finally block calls when doing a goto from
 * inside a try block to outside.
 * Done after blocks are generated because then we know all
 * the edges of the graph, but before the pred's are computed.
 * Параметры:
 *      obnodes = graph of the function
 */

проц insertFinallyBlockCalls(ref ObNodes obnodes)
{
    ObNode* bcret = null;
    ObNode* bcretexp = null;

    const log = нет;

    static if (log)
    {
        printf("------- before ----------\n");
        numberNodes(obnodes);
        foreach (ob; obnodes) ob.print();
        printf("-------------------------\n");
    }

    foreach (ob; obnodes)
    {
        if (!ob.tryBlock)
            continue;

        switch (ob.obtype)
        {
            case ObType.return_:
                // Rewrite into a ObType.goto_ => ObType.return_
                if (!bcret)
                {
                    bcret = new ObNode();
                    bcret.obtype = ob.obtype;
                }
                ob.obtype = ObType.goto_;
                ob.succs.сунь(bcret);
                goto case_goto;

            case ObType.retexp:
                // Rewrite into a ObType.goto_ => ObType.retexp
                if (!bcretexp)
                {
                    bcretexp = new ObNode();
                    bcretexp.obtype = ob.obtype;
                }
                ob.obtype = ObType.goto_;
                ob.succs.сунь(bcretexp);
                goto case_goto;

            case ObType.goto_:
                if (ob.succs.length != 1)
                    break;

            case_goto:
            {
                auto target = ob.succs[0];              // destination of goto
                ob.succs.устДим(0);
                auto lasttry = target.tryBlock;
                auto blast = ob;
                for (auto bt = ob.tryBlock; bt != lasttry; bt = bt.tryBlock)
                {
                    assert(bt.obtype == ObType.try_);
                    auto bf = bt.succs[1];
                    assert(bf.obtype == ObType.finally_);
                    auto bfend = bt.succs[2];
                    assert(bfend.obtype == ObType.fend);

                    if (!blast.succs.содержит(bf.succs[0]))
                        blast.succs.сунь(bf.succs[0]);

                    blast = bfend;
                }
                if (!blast.succs.содержит(target))
                    blast.succs.сунь(target);

                break;
            }

            default:
                break;
        }
    }
    if (bcret)
        obnodes.сунь(bcret);
    if (bcretexp)
        obnodes.сунь(bcretexp);

    static if (log)
    {
        printf("------- after ----------\n");
        numberNodes(obnodes);
        foreach (ob; obnodes) ob.print();
        printf("-------------------------\n");
    }
}

/***************************************************
 * Remove try-finally scaffolding.
 * Параметры:
 *      obnodes = nodes for the function
 */

проц insertFinallyBlockGotos(ref ObNodes obnodes)
{
    /* Remove all the try_, finally_, lpad and ret nodes.
     * Actually, just make them into no-ops.
     */
    foreach (ob; obnodes)
    {
        ob.tryBlock = null;
        switch (ob.obtype)
        {
            case ObType.try_:
                ob.obtype = ObType.goto_;
                ob.succs.удали(2);     // удали fend
                ob.succs.удали(1);     // удали finally_
                break;

            case ObType.finally_:
                ob.obtype = ObType.goto_;
                break;

            case ObType.fend:
                ob.obtype = ObType.goto_;
                break;

            default:
                break;
        }
    }
}

/*********************************
 * Set the `index` field of each ObNode
 * to its index in the массив.
 */
проц numberNodes(ref ObNodes obnodes)
{
    foreach (i, ob; obnodes)
    {
        ob.index = cast(бцел)i;
    }
}


/*********************************
 * Remove unreachable nodes and compress
 * them out of obnodes[].
 * Параметры:
 *      obnodes = массив of nodes
 */
проц removeUnreachable(ref ObNodes obnodes)
{
    if (!obnodes.length)
        return;

    /* Mark all nodes as unreachable,
     * temporarilly reusing ObNode.index
     */
    foreach (ob; obnodes)
        ob.index = 0;

    /* Recurseively mark ob and all its successors as reachable
     */
    static проц mark(ObNode* ob)
    {
        ob.index = 1;
        foreach (succ; ob.succs)
        {
            if (!succ.index)
                mark(succ);
        }
    }

    mark(obnodes[0]);   // first узел is entry point

    /* Remove unreachable nodes by shifting the remainder left
     */
    т_мера j = 1;
    foreach (i; new бцел[1 .. obnodes.length])
    {
        if (obnodes[i].index)
        {
            if (i != j)
                obnodes[j] = obnodes[i];
            ++j;
        }
        else
        {
            obnodes[i].разрушь();
        }
    }
    obnodes.устДим(j);
}



/*************************************
 * Compute predecessors.
 */
проц computePreds(ref ObNodes obnodes)
{
    foreach (ob; obnodes)
    {
        foreach (succ; ob.succs)
        {
            succ.preds.сунь(ob);
        }
    }
}

/*******************************
 * Are we interested in tracking this variable?
 */
бул isTrackableVar(VarDeclaration v)
{
    /* Currently only dealing with pointers
     */
    if (v.тип.toBasetype().ty != Tpointer)
        return нет;
    if (v.needsScopeDtor())
        return нет;
    if (v.класс_хранения & STC.параметр && !v.тип.isMutable())
        return нет;
    return !v.isDataseg();
}

/*******************************
 * Are we interested in tracking this Выражение?
 * Возвращает:
 *      variable if so, null if not
 */
VarDeclaration isTrackableVarExp(Выражение e)
{
    if (auto ve = e.isVarExp())
    {
        if (auto v = ve.var.isVarDeclaration())
            if (isTrackableVar(v))
                return v;
    }
    return null;
}


/**************
 * Find the pointer variable declarations in this function,
 * and fill `vars` with them.
 * Параметры:
 *      funcdecl = function we are in
 *      vars = массив to fill in
 */
проц collectVars(FuncDeclaration funcdecl, out VarDeclarations vars)
{
    const log = нет;
    if (log)
        printf("----------------collectVars()---------------\n");

    if (funcdecl.parameters)
        foreach (v; (*funcdecl.parameters)[])
        {
            if (isTrackableVar(v))
                vars.сунь(v);
        }

    проц dgVar(VarDeclaration v)
    {
        if (isTrackableVar(v))
            vars.сунь(v);
    }

    проц dgExp(Выражение e)
    {
        foreachVar(e, &dgVar);
    }

    foreachExpAndVar(funcdecl.fbody, &dgExp, &dgVar);

    static if (log)
    {
        foreach (i, v; vars[])
        {
            printf("vars[%d] = %s\n", cast(цел)i, v.вТкст0());
        }
    }
}

/***********************************
 * Allocate BitArrays in PtrVarState.
 * Can be allocated much more efficiently by subdividing a single
 * large массив of bits
 */
проц allocDeps(PtrVarState[] pvss)
{
    //printf("allocDeps()\n");
    foreach (ref pvs; pvss)
    {
        pvs.deps.length = pvss.length;
    }
}


/**************************************
 * Allocate state variables foreach узел.
 */
проц allocStates(ref ObState obstate)
{
    //printf("---------------allocStates()------------------\n");
    const vlen = obstate.vars.length;
    PtrVarState* p = cast(PtrVarState*) mem.xcalloc(obstate.nodes.length * 3 * vlen, PtrVarState.sizeof);
    obstate.varPool = p[0 .. obstate.nodes.length * 3 * vlen];
    foreach (i, ob; obstate.nodes)
    {
        //printf(" [%d]\n", cast(цел)i);
//        ob.kill.length = obstate.vars.length;
//        ob.comb.length = obstate.vars.length;
        ob.gen         = p[0 .. vlen]; p += vlen;
        ob.input       = p[0 .. vlen]; p += vlen;
        ob.output      = p[0 .. vlen]; p += vlen;

        allocDeps(ob.gen);
        allocDeps(ob.input);
        allocDeps(ob.output);
    }
}

/******************************
 * Does v meet the definiton of a `Borrowed` pointer?
 * Возвращает:
 *      да if it does
 */
бул isBorrowedPtr(VarDeclaration v)
{
    return v.isScope() && !v.isowner && v.тип.nextOf().isMutable();
}

/******************************
 * Does v meet the definiton of a `Readonly` pointer?
 * Возвращает:
 *      да if it does
 */
бул isReadonlyPtr(VarDeclaration v)
{
    return v.isScope() && !v.тип.nextOf().isMutable();
}

/***************************************
 * Compute the gen/comb/kill vectors for each узел.
 */
проц genKill(ref ObState obstate, ObNode* ob)
{
    const log = нет;
    if (log)
        printf("-----------computeGenKill()-----------\n");

    /***************
     * Assigning результат of Выражение `e` to variable `v`.
     */
    проц dgWriteVar(ObNode* ob, VarDeclaration v, Выражение e, бул инициализатор)
    {
        const vi = obstate.vars.найди(v);
        assert(vi != т_мера.max);
        PtrVarState* pvs = &ob.gen[vi];
        if (e)
        {
            if (isBorrowedPtr(v))
                pvs.state = PtrState.Borrowed;
            else if (isReadonlyPtr(v))
                pvs.state = PtrState.Readonly;
            else
                pvs.state = PtrState.Owner;
            pvs.deps.нуль();

            EscapeByрезультатs er;
            escapeByValue(e, &er, да);
            бул any = нет;           // if any variables are assigned to v

            проц by(VarDeclaration r)
            {
                const ri = obstate.vars.найди(r);
                if (ri != т_мера.max && ri != vi)
                {
                    pvs.deps[ri] = да;         // v took from r
                    auto pvsr = &ob.gen[ri];
                    any = да;

                    if (isBorrowedPtr(v))
                    {
                        // v is borrowing from r
                        pvs.state = PtrState.Borrowed;
                    }
                    else if (isReadonlyPtr(v))
                    {
                        pvs.state = PtrState.Readonly;
                    }
                    else
                    {
                        // move r to v, which "consumes" r
                        pvsr.state = PtrState.Undefined;
                        pvsr.deps.нуль();
                    }
                }
            }

            foreach (VarDeclaration v2; er.byvalue)
                by(v2);
            foreach (VarDeclaration v2; er.byref)
                by(v2);

            /* Make v an Owner for initializations like:
             *    scope v = malloc();
             */
            if (инициализатор && !any && isBorrowedPtr(v))
            {
                v.isowner = да;
                pvs.state = PtrState.Owner;
            }
        }
        else
        {
            if (isBorrowedPtr(v))
                pvs.state = PtrState.Borrowed;
            else if (isReadonlyPtr(v))
                pvs.state = PtrState.Readonly;
            else
                pvs.state = PtrState.Owner;
            pvs.deps.нуль();
        }
    }

    проц dgReadVar(ref Место место, ObNode* ob, VarDeclaration v, бул mutable)
    {
        if (log)
            printf("dgReadVar() %s %d\n", v.вТкст0(), mutable);
        const vi = obstate.vars.найди(v);
        assert(vi != т_мера.max);
        readVar(ob, vi, mutable, ob.gen);
    }

    проц foreachExp(ObNode* ob, Выражение e)
    {
         final class ExpWalker : Визитор2
        {
            alias  typeof(super).посети посети ;
            extern (D) проц delegate(ObNode*, VarDeclaration, Выражение, бул) dgWriteVar;
            extern (D) проц delegate(ref Место место, ObNode* ob, VarDeclaration v, бул mutable) dgReadVar;
            ObNode* ob;
            ObState* obstate;

            this(проц delegate(ObNode*, VarDeclaration, Выражение, бул) dgWriteVar,
                            проц delegate(ref Место место, ObNode* ob, VarDeclaration v, бул mutable) dgReadVar,
                            ObNode* ob, ref ObState obstate)
            {
                this.dgWriteVar = dgWriteVar;
                this.dgReadVar  = dgReadVar;
                this.ob = ob;
                this.obstate = &obstate;
            }

            override проц посети(Выражение e)
            {
                //printf("[%s] %s: %s\n", e.место.вТкст0(), Сема2.вТкст0(e.op), e.вТкст0());
                //assert(0);
            }

            проц visitAssign(AssignExp ae, бул инициализатор)
            {
                ae.e2.прими(this);
                if (auto ve = ae.e1.isVarExp())
                {
                    if (auto v = ve.var.isVarDeclaration())
                        if (isTrackableVar(v))
                            dgWriteVar(ob, v, ae.e2, инициализатор);
                }
                else
                    ae.e1.прими(this);
            }

            override проц посети(AssignExp ae)
            {
                visitAssign(ae, нет);
            }

            override проц посети(DeclarationExp e)
            {
                проц Dsymbol_visit(ДСимвол s)
                {
                    if (auto vd = s.isVarDeclaration())
                    {
                        s = s.toAlias();
                        if (s != vd)
                            return Dsymbol_visit(s);
                        if (!isTrackableVar(vd))
                            return;

                        if (!(vd._иниц && vd._иниц.isVoidInitializer()))
                        {
                            auto ei = vd._иниц ? vd._иниц.isExpInitializer() : null;
                            if (ei)
                                visitAssign(cast(AssignExp)ei.exp, да);
                            else
                                dgWriteVar(ob, vd, null, нет);
                        }
                    }
                    else if (auto td = s.isTupleDeclaration())
                    {
                        foreach (o; *td.objects)
                        {
                            if (auto eo = o.выражение_ли())
                            {
                                if (auto se = eo.isDsymbolExp())
                                {
                                    Dsymbol_visit(se.s);
                                }
                            }
                        }
                    }
                }

                Dsymbol_visit(e.declaration);
            }

            override проц посети(VarExp ve)
            {
                //printf("VarExp: %s\n", ve.вТкст0());
                if (auto v = ve.var.isVarDeclaration())
                    if (isTrackableVar(v))
                    {
                        dgReadVar(ve.место, ob, v, isMutableRef(ve.тип));
                    }
            }

            override проц посети(CallExp ce)
            {
                //printf("CallExp() %s\n", ce.вТкст0());
                ce.e1.прими(this);
                auto t = ce.e1.тип.toBasetype();
                auto tf = t.isTypeFunction();
                if (!tf)
                {
                    assert(t.ty == Tdelegate);
                    tf = t.nextOf().isTypeFunction();
                    assert(tf);
                }

                // j=1 if _arguments[] is first argument
                const цел j = tf.isDstyleVariadic();
                бул hasOut;
                const varStackSave = obstate.varStack.length;

                foreach ( i, arg; (*ce.arguments)[])
                {
                    if (i - j < tf.parameterList.length &&
                        i >= j)
                    {
                        Параметр2 p = tf.parameterList[i - j];
                        auto pt = p.тип.toBasetype();

                        EscapeByрезультатs er;
                        escapeByValue(arg, &er, да);

                        if (!(p.классХранения & STC.out_ && arg.isVarExp()))
                            arg.прими(this);

                        проц by(VarDeclaration v)
                        {
                            if (!isTrackableVar(v))
                                return;

                            const vi = obstate.vars.найди(v);
                            if (vi == т_мера.max)
                                return;

                            auto pvs = &ob.gen[vi];

                            if (p.классХранения & STC.out_)
                            {
                                /// initialize
                                hasOut = да;
                                makeUndefined(vi, ob.gen);
                            }
                            else if (p.классХранения & STC.scope_)
                            {
                                // borrow
                                obstate.varStack.сунь(vi);
                                obstate.mutableStack.сунь(isMutableRef(pt));
                            }
                            else
                            {
                                // move (i.e. consume arg)
                                makeUndefined(vi, ob.gen);
                            }
                        }

                        foreach (VarDeclaration v2; er.byvalue)
                            by(v2);
                        foreach (VarDeclaration v2; er.byref)
                            by(v2);
                    }
                    else // variadic args
                    {
                        arg.прими(this);

                        EscapeByрезультатs er;
                        escapeByValue(arg, &er, да);

                        проц byv(VarDeclaration v)
                        {
                            if (!isTrackableVar(v))
                                return;

                            const vi = obstate.vars.найди(v);
                            if (vi == т_мера.max)
                                return;

                            auto pvs = &ob.gen[vi];
                            obstate.varStack.сунь(vi);
                            obstate.mutableStack.сунь(isMutableRef(arg.тип));

                            // move (i.e. consume arg)
                            makeUndefined(vi, ob.gen);
                        }

                        foreach (VarDeclaration v2; er.byvalue)
                            byv(v2);
                        foreach (VarDeclaration v2; er.byref)
                            byv(v2);
                    }
                }

                /* Do a dummy 'читай' of each variable passed to the function,
                 * to detect O/B errors
                 */
                assert(obstate.varStack.length == obstate.mutableStack.length);
                foreach (i; new бцел[varStackSave .. obstate.varStack.length])
                {
                    const vi = obstate.varStack[i];
                    auto pvs = &ob.gen[vi];
                    auto v = obstate.vars[vi];
                    //if (pvs.state == PtrState.Undefined)
                        //v.выведиОшибку(ce.место, "is Undefined, cannot pass to function");

                    dgReadVar(ce.место, ob, v, obstate.mutableStack[i]);
                }

                /* Pop off stack all variables for this function call
                 */
                obstate.varStack.устДим(varStackSave);
                obstate.mutableStack.устДим(varStackSave);

                if (hasOut)
                    // Initialization of out's only happens after the function call
                    foreach ( i, arg; (*ce.arguments)[])
                    {
                        if (i - j < tf.parameterList.length &&
                            i >= j)
                        {
                            Параметр2 p = tf.parameterList[i - j];
                            if (p.классХранения & STC.out_)
                            {
                                if (auto v = isTrackableVarExp(arg))
                                    dgWriteVar(ob, v, null, да);
                            }
                        }
                    }
            }

            override проц посети(SymOffExp e)
            {
                if (auto v = e.var.isVarDeclaration())
                    if (isTrackableVar(v))
                    {
                        dgReadVar(e.место, ob, v, isMutableRef(e.тип));
                    }
            }

            override проц посети(LogicalExp e)
            {
                e.e1.прими(this);

                const vlen = obstate.vars.length;
                auto p = cast(PtrVarState*)mem.xcalloc(vlen, PtrVarState.sizeof);
                PtrVarState[] gen1 = p[0 .. vlen];
                foreach (i, ref pvs; gen1)
                {
                    pvs = ob.gen[i];
                }

                e.e2.прими(this);

                // Merge gen1 into ob.gen
                foreach (i; new бцел[0 .. vlen])
                {
                    ob.gen[i].combine(gen1[i], i, ob.gen);
                }

                mem.xfree(p); // should free .deps too
            }

            override проц посети(CondExp e)
            {
                e.econd.прими(this);

                const vlen = obstate.vars.length;
                auto p = cast(PtrVarState*)mem.xcalloc(vlen, PtrVarState.sizeof);
                PtrVarState[] gen1 = p[0 .. vlen];
                foreach (i, ref pvs; gen1)
                {
                    pvs = ob.gen[i];
                }

                e.e1.прими(this);

                // Swap gen1 with ob.gen
                foreach (i; new бцел[0 .. vlen])
                {
                    gen1[i].deps.swap(ob.gen[i].deps);
                    const state = gen1[i].state;
                    gen1[i].state = ob.gen[i].state;
                    ob.gen[i].state = state;
                }

                e.e2.прими(this);

                /* xxx1 is the state from Выражение e1, ob.xxx is the state from e2.
                 * Merge xxx1 into ob.xxx to get the state from `e`.
                 */
                foreach (i; new бцел[0 .. vlen])
                {
                    ob.gen[i].combine(gen1[i], i, ob.gen);
                }

                mem.xfree(p); // should free .deps too
            }

            override проц посети(AddrExp e)
            {
                /* Taking the address of struct literal is normally not
                 * allowed, but CTFE can generate one out of a new Выражение,
                 * but it'll be placed in static данные so no need to check it.
                 */
                if (e.e1.op != ТОК2.structLiteral)
                    e.e1.прими(this);
            }

            override проц посети(UnaExp e)
            {
                e.e1.прими(this);
            }

            override проц посети(BinExp e)
            {
                e.e1.прими(this);
                e.e2.прими(this);
            }

            override проц посети(ArrayLiteralExp e)
            {
                Тип tb = e.тип.toBasetype();
                if (tb.ty == Tsarray || tb.ty == Tarray)
                {
                    if (e.basis)
                        e.basis.прими(this);
                    foreach (el; *e.elements)
                    {
                        if (el)
                            el.прими(this);
                    }
                }
            }

            override проц посети(StructLiteralExp e)
            {
                if (e.elements)
                {
                    foreach (ex; *e.elements)
                    {
                        if (ex)
                            ex.прими(this);
                    }
                }
            }

            override проц посети(AssocArrayLiteralExp e)
            {
                if (e.keys)
                {
                    foreach (i, ключ; *e.keys)
                    {
                        if (ключ)
                            ключ.прими(this);
                        if (auto значение = (*e.values)[i])
                            значение.прими(this);
                    }
                }
            }

            override проц посети(NewExp e)
            {
                Тип tb = e.newtype.toBasetype();
                if (e.arguments)
                {
                    foreach (ex; *e.arguments)
                    {
                        if (ex)
                            ex.прими(this);
                    }
                }
            }

            override проц посети(SliceExp e)
            {
                e.e1.прими(this);
                if (e.lwr)
                    e.lwr.прими(this);
                if (e.upr)
                    e.upr.прими(this);
            }
        }

        if (e)
        {
            scope ExpWalker ew = new ExpWalker(&dgWriteVar, &dgReadVar, ob, obstate);
            e.прими(ew);
        }
    }

    foreachExp(ob, ob.exp);
}

/***************************************
 * Determine the state of a variable based on
 * its тип and storage class.
 */
PtrState toPtrState(VarDeclaration v)
{
    /* pointer to mutable:        Owner
     * pointer to mutable, scope: Borrowed
     * pointer to const:          Owner
     * pointer to const, scope:   Readonly
     * ref:                       Borrowed
     * ref:                 Readonly
     */
    auto tb = v.тип.toBasetype();
    if (v.isRef())
    {
        return tb.isMutable() ? PtrState.Borrowed : PtrState.Readonly;
    }
    auto tp = tb.isTypePointer();
    assert(tp);
    if (v.isScope())
    {
        return tp.nextOf().isMutable() ? PtrState.Borrowed : PtrState.Readonly;
    }
    else
        return PtrState.Owner;
}


/***************************************
 * Do the данные flow analysis (i.e. compute the input[]
 * and output[] vectors for each ObNode).
 */
проц doDataFlowAnalysis(ref ObState obstate)
{
    const log = нет;
    if (log)
        printf("-----------------doDataFlowAnalysis()-------------------------\n");

    if (!obstate.nodes.length)
        return;

    auto startnode = obstate.nodes[0];
    assert(startnode.preds.length == 0);

    /* Set opening state `input[]` for first узел
     */
    foreach (i, ref ps; startnode.input)
    {
        auto v = obstate.vars[i];
        auto state = toPtrState(v);
        if (v.isParameter())
        {
            if (v.isOut())
                state = PtrState.Undefined;
            else
                state = PtrState.Owner;
        }
        else
            state = PtrState.Undefined;
        ps.state = state;
        ps.deps.нуль();
        startnode.gen[i] = ps;
    }

    /* Set all output[]s to Undefined
     */
    foreach (ob; obstate.nodes[])
    {
        foreach (ref ps; ob.output)
        {
            ps.state = PtrState.Undefined;
            ps.deps.нуль();
        }
    }

    const vlen = obstate.vars.length;
    PtrVarState pvs;
    pvs.deps.length = vlen;
    цел counter = 0;
    бул changes;
    do
    {
        changes = нет;
        assert(++counter <= 1000);      // should converge, but don't hang if it doesn't
        foreach (ob; obstate.nodes[])
        {
            /* Construct ob.gen[] by combining the .output[]s of each ob.preds[]
             * and set ob.input[] to the same state
             */
            if (ob != startnode)
            {
                assert(ob.preds.length);

                foreach (i; new бцел[0 .. vlen])
                {
                    ob.gen[i] = ob.preds[0].output[i];
                }

                foreach (j; new бцел[1 .. ob.preds.length])
                {
                    foreach (i; new бцел[0 .. vlen])
                    {
                        ob.gen[i].combine(ob.preds[j].output[i], i, ob.gen);
                    }
                }

                /* Set ob.input[] to ob.gen[],
                 * if any changes were made we'll have to do another iteration
                 */
                foreach (i; new бцел[0 .. vlen])
                {
                    if (ob.gen[i] != ob.input[i])
                    {
                        ob.input[i] = ob.gen[i];
                        changes = да;
                    }
                }
            }

            /* Compute gen[] for узел ob
             */
            genKill(obstate, ob);

            foreach (i; new бцел[0 .. vlen])
            {
                if (ob.gen[i] != ob.output[i])
                {
                    ob.output[i] = ob.gen[i];
                    changes = да;
                }
            }
        }
    } while (changes);

    static if (log)
    {
        foreach (obi, ob; obstate.nodes)
        {
            printf("%d: %s\n", obi, ob.exp ? ob.exp.вТкст0() : "".ptr);
            printf("  input:\n");
            foreach (i, ref pvs2; ob.input[])
            {
                printf("    %s: ", obstate.vars[i].вТкст0()); pvs2.print(obstate.vars[]);
            }

            printf("  output:\n");
            foreach (i, ref pvs2; ob.output[])
            {
                printf("    %s: ", obstate.vars[i].вТкст0()); pvs2.print(obstate.vars[]);
            }
        }
        printf("\n");
    }
}


/***************************************
 * Check for Ownership/Borrowing errors.
 */
проц checkObErrors(ref ObState obstate)
{
    const log = нет;
    if (log)
        printf("------------checkObErrors()----------\n");

    проц dgWriteVar(ObNode* ob, PtrVarState[] cpvs, VarDeclaration v, Выражение e)
    {
        if (log) printf("dgWriteVar(v:%s, e:%s)\n", v.вТкст0(), e ? e.вТкст0() : "null");
        const vi = obstate.vars.найди(v);
        assert(vi != т_мера.max);
        PtrVarState* pvs = &cpvs[vi];
        if (e)
        {
            if (isBorrowedPtr(v))
                pvs.state = PtrState.Borrowed;
            else if (isReadonlyPtr(v))
                pvs.state = PtrState.Readonly;
            else
                pvs.state = PtrState.Owner;
            pvs.deps.нуль();

            EscapeByрезультатs er;
            escapeByValue(e, &er, да);

            проц by(VarDeclaration r)   // `v` = `r`
            {
                //printf("  by(%s)\n", r.вТкст0());
                const ri = obstate.vars.найди(r);
                if (ri == т_мера.max)
                    return;

                with (PtrState)
                {
                    pvs.deps[ri] = да;         // v took from r
                    auto pvsr = &cpvs[ri];

                    if (pvsr.state == Undefined)
                    {
                        v.выведиОшибку(e.место, "is reading from `%s` which is Undefined", r.вТкст0());
                    }
                    else if (isBorrowedPtr(v))  // v is going to borrow from r
                    {
                        if (pvsr.state == Readonly)
                            v.выведиОшибку(e.место, "is borrowing from `%s` which is Readonly", r.вТкст0());

                        pvs.state = Borrowed;
                    }
                    else if (isReadonlyPtr(v))
                    {
                        pvs.state = Readonly;
                    }
                    else
                    {
                        // move from r to v
                        pvsr.state = Undefined;
                        pvsr.deps.нуль();
                    }
                }
            }

            foreach (VarDeclaration v2; er.byvalue)
                by(v2);
            foreach (VarDeclaration v2; er.byref)
                by(v2);
        }
        else
        {
            if (isBorrowedPtr(v))
                pvs.state = PtrState.Borrowed;
            else if (isReadonlyPtr(v))
                pvs.state = PtrState.Readonly;
            else
                pvs.state = PtrState.Owner;
            pvs.deps.нуль();
        }
    }

    проц dgReadVar(ref Место место, ObNode* ob, VarDeclaration v, бул mutable, PtrVarState[] gen)
    {
        if (log) printf("dgReadVar() %s\n", v.вТкст0());
        const vi = obstate.vars.найди(v);
        assert(vi != т_мера.max);
        auto pvs = &gen[vi];
        if (pvs.state == PtrState.Undefined)
            v.выведиОшибку(место, "has undefined state and cannot be читай");

        readVar(ob, vi, mutable, gen);
    }

    проц foreachExp(ObNode* ob, Выражение e, PtrVarState[] cpvs)
    {
         final class ExpWalker : Визитор2
        {
            alias  typeof(super).посети посети ;
            extern (D) проц delegate(ObNode*, PtrVarState[], VarDeclaration, Выражение) dgWriteVar;
            extern (D) проц delegate(ref Место место, ObNode* ob, VarDeclaration v, бул mutable, PtrVarState[]) dgReadVar;
            PtrVarState[] cpvs;
            ObNode* ob;
            ObState* obstate;

            this(проц delegate(ref Место место, ObNode* ob, VarDeclaration v, бул mutable, PtrVarState[]) dgReadVar,
                            проц delegate(ObNode*, PtrVarState[], VarDeclaration, Выражение) dgWriteVar,
                            PtrVarState[] cpvs, ObNode* ob, ref ObState obstate)
            {
                this.dgReadVar  = dgReadVar;
                this.dgWriteVar = dgWriteVar;
                this.cpvs = cpvs;
                this.ob = ob;
                this.obstate = &obstate;
            }

            override проц посети(Выражение)
            {
            }

            override проц посети(DeclarationExp e)
            {
                проц Dsymbol_visit(ДСимвол s)
                {
                    if (auto vd = s.isVarDeclaration())
                    {
                        s = s.toAlias();
                        if (s != vd)
                            return Dsymbol_visit(s);
                        if (!isTrackableVar(vd))
                            return;

                        if (vd._иниц && vd._иниц.isVoidInitializer())
                            return;

                        auto ei = vd._иниц ? vd._иниц.isExpInitializer() : null;
                        if (ei)
                        {
                            auto e = ei.exp;
                            if (auto ae = e.isConstructExp())
                                e = ae.e2;
                            dgWriteVar(ob, cpvs, vd, e);
                        }
                        else
                            dgWriteVar(ob, cpvs, vd, null);
                    }
                    else if (auto td = s.isTupleDeclaration())
                    {
                        foreach (o; *td.objects)
                        {
                            if (auto eo = o.выражение_ли())
                            {
                                if (auto se = eo.isDsymbolExp())
                                {
                                    Dsymbol_visit(se.s);
                                }
                            }
                        }
                    }
                }

                Dsymbol_visit(e.declaration);
            }

            override проц посети(AssignExp ae)
            {
                ae.e2.прими(this);
                if (auto ve = ae.e1.isVarExp())
                {
                    if (auto v = ve.var.isVarDeclaration())
                        if (isTrackableVar(v))
                            dgWriteVar(ob, cpvs, v, ae.e2);
                }
                else
                    ae.e1.прими(this);
            }

            override проц посети(VarExp ve)
            {
                //printf("VarExp: %s\n", ve.вТкст0());
                if (auto v = ve.var.isVarDeclaration())
                    if (isTrackableVar(v))
                    {
                        dgReadVar(ve.место, ob, v, isMutableRef(ve.тип), cpvs);
                    }
            }

            override проц посети(CallExp ce)
            {
                //printf("CallExp(%s)\n", ce.вТкст0());
                ce.e1.прими(this);
                auto t = ce.e1.тип.toBasetype();
                auto tf = t.isTypeFunction();
                if (!tf)
                {
                    assert(t.ty == Tdelegate);
                    tf = t.nextOf().isTypeFunction();
                    assert(tf);
                }

                // j=1 if _arguments[] is first argument
                const цел j = tf.isDstyleVariadic();
                бул hasOut;
                const varStackSave = obstate.varStack.length;

                foreach ( i, arg; (*ce.arguments)[])
                {
                    if (i - j < tf.parameterList.length &&
                        i >= j)
                    {
                        Параметр2 p = tf.parameterList[i - j];
                        auto pt = p.тип.toBasetype();

                        if (!(p.классХранения & STC.out_ && arg.isVarExp()))
                            arg.прими(this);

                        EscapeByрезультатs er;
                        escapeByValue(arg, &er, да);

                        проц by(VarDeclaration v)
                        {
                            if (!isTrackableVar(v))
                                return;

                            const vi = obstate.vars.найди(v);
                            if (vi == т_мера.max)
                                return;

                            auto pvs = &cpvs[vi];

                            if (p.классХранения & STC.out_)
                            {
                                /// initialize
                                hasOut = да;
                                makeUndefined(vi, cpvs);
                            }
                            else if (p.классХранения & STC.scope_)
                            {
                                // borrow
                                obstate.varStack.сунь(vi);
                                obstate.mutableStack.сунь(isMutableRef(pt));
                            }
                            else
                            {
                                // move (i.e. consume arg)
                                if (pvs.state != PtrState.Owner)
                                    v.выведиОшибку(arg.место, "is not Owner, cannot consume its значение");
                                makeUndefined(vi, cpvs);
                            }
                        }

                        foreach (VarDeclaration v2; er.byvalue)
                            by(v2);
                        foreach (VarDeclaration v2; er.byref)
                            by(v2);
                    }
                    else // variadic args
                    {
                        arg.прими(this);

                        EscapeByрезультатs er;
                        escapeByValue(arg, &er, да);

                        проц byv(VarDeclaration v)
                        {
                            if (!isTrackableVar(v))
                                return;

                            const vi = obstate.vars.найди(v);
                            if (vi == т_мера.max)
                                return;

                            auto pvs = &cpvs[vi];
                            obstate.varStack.сунь(vi);
                            obstate.mutableStack.сунь(isMutableRef(arg.тип));

                            // move (i.e. consume arg)
                            if (pvs.state != PtrState.Owner)
                                v.выведиОшибку(arg.место, "is not Owner, cannot consume its значение");
                            makeUndefined(vi, cpvs);
                        }

                        foreach (VarDeclaration v2; er.byvalue)
                            byv(v2);
                        foreach (VarDeclaration v2; er.byref)
                            byv(v2);
                    }
                }

                /* Do a dummy 'читай' of each variable passed to the function,
                 * to detect O/B errors
                 */
                assert(obstate.varStack.length == obstate.mutableStack.length);
                foreach (i; new бцел[varStackSave .. obstate.varStack.length])
                {
                    const vi = obstate.varStack[i];
                    auto pvs = &cpvs[vi];
                    auto v = obstate.vars[vi];
                    //if (pvs.state == PtrState.Undefined)
                        //v.выведиОшибку(ce.место, "is Undefined, cannot pass to function");

                    dgReadVar(ce.место, ob, v, obstate.mutableStack[i], cpvs);

                    if (pvs.state == PtrState.Owner)
                    {
                        for (т_мера k = i + 1; k < obstate.varStack.length;++k)
                        {
                            const vk = obstate.varStack[k];
                            if (vk == vi)
                            {
                                if (obstate.mutableStack[vi] || obstate.mutableStack[vk])
                                {
                                    v.выведиОшибку(ce.место, "is passed as Owner more than once");
                                    break;  // no need to continue
                                }
                            }
                        }
                    }
                }

                /* Pop off stack all variables for this function call
                 */
                obstate.varStack.устДим(varStackSave);
                obstate.mutableStack.устДим(varStackSave);

                if (hasOut)
                    // Initialization of out's only happens after the function call
                    foreach ( i, arg; (*ce.arguments)[])
                    {
                        if (i - j < tf.parameterList.length &&
                            i >= j)
                        {
                            Параметр2 p = tf.parameterList[i - j];
                            if (p.классХранения & STC.out_)
                            {
                                if (auto v = isTrackableVarExp(arg))
                                {
                                    dgWriteVar(ob, cpvs, v, null);
                                }
                            }
                        }
                    }
            }

            override проц посети(SymOffExp e)
            {
                if (auto v = e.var.isVarDeclaration())
                    if (isTrackableVar(v))
                    {
                        dgReadVar(e.место, ob, v, isMutableRef(e.тип), cpvs);
                    }
            }

            override проц посети(LogicalExp e)
            {
                e.e1.прими(this);

                const vlen = obstate.vars.length;
                auto p = cast(PtrVarState*)mem.xcalloc(vlen, PtrVarState.sizeof);
                PtrVarState[] out1 = p[0 .. vlen];
                foreach (i, ref pvs; out1)
                {
                    pvs = cpvs[i];
                }

                e.e2.прими(this);

                // Merge out1 into cpvs
                foreach (i; new бцел[0 .. vlen])
                {
                    cpvs[i].combine(out1[i], i, cpvs);
                }

                mem.xfree(p); // should free .deps too
            }

            override проц посети(CondExp e)
            {
                e.econd.прими(this);

                const vlen = obstate.vars.length;
                auto p = cast(PtrVarState*)mem.xcalloc(vlen, PtrVarState.sizeof);
                PtrVarState[] out1 = p[0 .. vlen];
                foreach (i, ref pvs; out1)
                {
                    pvs = cpvs[i];
                }

                e.e1.прими(this);

                // Swap out1 with cpvs
                foreach (i; new бцел[0 .. vlen])
                {
                    out1[i].deps.swap(cpvs[i].deps);
                    const state = out1[i].state;
                    out1[i].state = cpvs[i].state;
                    cpvs[i].state = state;
                }

                e.e2.прими(this);

                // Merge out1 into cpvs
                foreach (i; new бцел[0 .. vlen])
                {
                    cpvs[i].combine(out1[i], i, cpvs);
                }

                mem.xfree(p); // should free .deps too
            }

            override проц посети(AddrExp e)
            {
                /* Taking the address of struct literal is normally not
                 * allowed, but CTFE can generate one out of a new Выражение,
                 * but it'll be placed in static данные so no need to check it.
                 */
                if (e.e1.op != ТОК2.structLiteral)
                    e.e1.прими(this);
            }

            override проц посети(UnaExp e)
            {
                e.e1.прими(this);
            }

            override проц посети(BinExp e)
            {
                e.e1.прими(this);
                e.e2.прими(this);
            }

            override проц посети(ArrayLiteralExp e)
            {
                Тип tb = e.тип.toBasetype();
                if (tb.ty == Tsarray || tb.ty == Tarray)
                {
                    if (e.basis)
                        e.basis.прими(this);
                    foreach (el; *e.elements)
                    {
                        if (el)
                            el.прими(this);
                    }
                }
            }

            override проц посети(StructLiteralExp e)
            {
                if (e.elements)
                {
                    foreach (ex; *e.elements)
                    {
                        if (ex)
                            ex.прими(this);
                    }
                }
            }

            override проц посети(AssocArrayLiteralExp e)
            {
                if (e.keys)
                {
                    foreach (i, ключ; *e.keys)
                    {
                        if (ключ)
                            ключ.прими(this);
                        if (auto значение = (*e.values)[i])
                            значение.прими(this);
                    }
                }
            }

            override проц посети(NewExp e)
            {
                Тип tb = e.newtype.toBasetype();
                if (e.arguments)
                {
                    foreach (ex; *e.arguments)
                    {
                        if (ex)
                            ex.прими(this);
                    }
                }
            }

            override проц посети(SliceExp e)
            {
                e.e1.прими(this);
                if (e.lwr)
                    e.lwr.прими(this);
                if (e.upr)
                    e.upr.прими(this);
            }
        }

        if (e)
        {
            scope ExpWalker ew = new ExpWalker(&dgReadVar, &dgWriteVar, cpvs, ob, obstate);
            e.прими(ew);
        }
    }

    const vlen = obstate.vars.length;
    auto p = cast(PtrVarState*)mem.xcalloc(vlen, PtrVarState.sizeof);
    PtrVarState[] cpvs = p[0 .. vlen];
    foreach (ref pvs; cpvs)
        pvs.deps.length = vlen;

    foreach (obi, ob; obstate.nodes)
    {
        static if (log)
        {
            printf("%d: %s\n", obi, ob.exp ? ob.exp.вТкст0() : "".ptr);
            printf("  input:\n");
            foreach (i, ref pvs; ob.input[])
            {
                printf("    %s: ", obstate.vars[i].вТкст0()); pvs.print(obstate.vars[]);
            }
        }

        /* Combine the .output[]s of each ob.preds[] looking for errors
         */
        if (obi)   // skip startnode
        {
            assert(ob.preds.length);

            foreach (i; new бцел[0 .. vlen])
            {
                ob.gen[i] = ob.preds[0].output[i];
            }

            foreach (j; new бцел[1 .. ob.preds.length])
            {
                foreach (i; new бцел[0 .. vlen])
                {
                    auto pvs1 = &ob.gen[i];
                    auto pvs2 = &ob.preds[j].output[i];
                    const s1 = pvs1.state;
                    const s2 = pvs2.state;
                    if (s1 != s2 && (s1 == PtrState.Owner || s2 == PtrState.Owner))
                    {
                        auto v = obstate.vars[i];
                        v.выведиОшибку(ob.exp ? ob.exp.место : v.место, "is both %s and %s", s1.вТкст0(), s2.вТкст0());
                    }
                    pvs1.combine(*pvs2, i, ob.gen);
                }
            }
        }

        /* Prolly should use gen[] instead of cpvs[], or vice versa
         */
        foreach (i, ref pvs; ob.input)
        {
            cpvs[i] = pvs;
        }

        foreachExp(ob, ob.exp, cpvs);

        static if (log)
        {
            printf("  cpvs:\n");
            foreach (i, ref pvs; cpvs[])
            {
                printf("    %s: ", obstate.vars[i].вТкст0()); pvs.print(obstate.vars[]);
            }
            printf("  output:\n");
            foreach (i, ref pvs; ob.output[])
            {
                printf("    %s: ", obstate.vars[i].вТкст0()); pvs.print(obstate.vars[]);
            }
        }

        if (ob.obtype == ObType.retexp)
        {
            EscapeByрезультатs er;
            escapeByValue(ob.exp, &er, да);

            проц by(VarDeclaration r)   // `r` is the rvalue
            {
                const ri = obstate.vars.найди(r);
                if (ri == т_мера.max)
                    return;
                with (PtrState)
                {
                    auto pvsr = &ob.output[ri];
                    switch (pvsr.state)
                    {
                        case Undefined:
                            r.выведиОшибку(ob.exp.место, "is returned but is Undefined");
                            break;

                        case Owner:
                            pvsr.state = Undefined;     // returning a pointer "consumes" it
                            break;

                        case Borrowed:
                        case Readonly:
                            break;

                        default:
                            assert(0);
                    }
                }
            }

            foreach (VarDeclaration v2; er.byvalue)
                by(v2);
            foreach (VarDeclaration v2; er.byref)
                by(v2);
        }

        if (ob.obtype == ObType.return_ || ob.obtype == ObType.retexp)
        {
            foreach (i, ref pvs; ob.output[])
            {
                //printf("%s: ", obstate.vars[i].вТкст0()); pvs.print(obstate.vars[]);
                if (pvs.state == PtrState.Owner)
                {
                    auto v = obstate.vars[i];
                    v.выведиОшибку(v.место, "is left dangling at return");
                }
            }
        }
    }
}


/***************************************************
 * Read from variable vi.
 * The beginning of the 'scope' of a variable is when it is first читай.
 * Hence, when a читай is done, instead of when assignment to the variable is done, the O/B rules are enforced.
 * (Also called "non-lexical scoping".)
 */
проц readVar(ObNode* ob,  т_мера vi, бул mutable, PtrVarState[] gen)
{
    //printf("readVar(v%d)\n", cast(цел)vi);
    auto pvso = &gen[vi];
    switch (pvso.state)
    {
        case PtrState.Owner:
            //printf("t: %s\n", t.вТкст0());
            if (mutable) // if mutable читай
            {
                makeChildrenUndefined(vi, gen);
            }
            else // const читай
            {
                // If there's a Borrow child, set that to Undefined
                foreach (di; new бцел[0 .. gen.length])
                {
                    auto pvsd = &gen[di];
                    if (pvsd.deps[vi] && pvsd.state == PtrState.Borrowed) // if di borrowed vi
                    {
                        makeUndefined(di, gen);
                    }
                }
            }
            break;

        case PtrState.Borrowed:
            /* All children become Undefined
             */
            makeChildrenUndefined(vi, gen);
            break;

        case PtrState.Readonly:
            break;

        case PtrState.Undefined:
            break;

        default:
            break;
    }
}

/********************
 * Recursively make Undefined all who list vi as a dependency
 */
проц makeChildrenUndefined(т_мера vi, PtrVarState[] gen)
{
    //printf("makeChildrenUndefined(%d)\n", vi);
    auto pvs = &gen[vi];
    foreach (di; new бцел[0 .. gen.length])
    {
        if (gen[di].deps[vi])    // if di depends on vi
        {
            if (gen[di].state != PtrState.Undefined)
            {
                gen[di].state = PtrState.Undefined;  // set this first to avoid infinite recursion
                makeChildrenUndefined(di, gen);
                gen[di].deps.нуль();
            }
        }
    }
}


/********************
 * Recursively make Undefined vi undefined and all who list vi as a dependency
 */
проц makeUndefined(т_мера vi, PtrVarState[] gen)
{
    auto pvs = &gen[vi];
    pvs.state = PtrState.Undefined;  // set this first to avoid infinite recursion
    makeChildrenUndefined(vi, gen);
    pvs.deps.нуль();
}

/*************************
 * Is тип `t` a reference to a const or a reference to a mutable?
 */
бул isMutableRef(Тип t)
{
    auto tb = t.toBasetype();
    return (tb.nextOf() ? tb.nextOf() : tb).isMutable();
}
