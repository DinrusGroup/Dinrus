/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/tocsym.d, _s2ir.d)
 * Documentation: $(LINK https://dlang.org/phobos/dmd_s2ir.html)
 * Coverage:    $(LINK https://codecov.io/gh/dlang/dmd/src/master/src/dmd/s2ir.d)
 */

module dmd.s2ir;

import cidrus;

import util.array;
import util.rmem;
import drc.ast.Node;

import dmd.aggregate;
import dmd.dclass;
import dmd.declaration;
import dmd.denum;
import dmd.dmodule;
import dmd.дсимвол;
import dmd.dstruct;
import dmd.dtemplate;
import dmd.e2ir;
import dmd.errors;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import dmd.glue;
import drc.lexer.Id;
import dmd.init;
import dmd.irstate;
import dmd.mtype;
import dmd.инструкция;
import dmd.target;
import dmd.toctype;
import dmd.tocsym;
import dmd.toir;
import drc.lexer.Tokens;
import drc.ast.Visitor;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.cgcv;
import drc.backend.code;
import drc.backend.code_x86;
import drc.backend.cv4;
import drc.backend.dlist;
import drc.backend.dt;
import drc.backend.el;
import drc.backend.глоб2;
import drc.backend.obj;
import drc.backend.oper;
import drc.backend.rtlsym;
import drc.backend.ty;
import drc.backend.тип;

/*extern (C++):*/

alias  dmd.tocsym.toSymbol toSymbol;
alias dmd.glue.toSymbol toSymbol;


проц elem_setLoc(elem *e, ref Место место)  
{
    srcpos_setLoc(e.Esrcpos, место);
}

private проц block_setLoc(block *b, ref Место место)  
{
    srcpos_setLoc(b.Bsrcpos, место);
}

private проц srcpos_setLoc(ref Srcpos s, ref Место место)  
{
    s.set(место.имяф, место.номстр, место.имяс);
}


/***********************************************
 * Generate code to set index into scope table.
 */

private проц setScopeIndex(Blockx *blx, block *b, цел scope_index)
{
    if (config.ehmethod == EHmethod.EH_WIN32 && !(blx.funcsym.Sfunc.Fflags3 & Feh_none))
        block_appendexp(b, nteh_setScopeTableIndex(blx, scope_index));
}

/****************************************
 * Allocate a new block, and set the tryblock.
 */

private block *block_calloc(Blockx *blx)
{
    block *b = drc.backend.глоб2.block_calloc();
    b.Btry = blx.tryblock;
    return b;
}

/**************************************
 * Add in code to increment использование count for номстр.
 */

private проц incUsage(IRState *irs, ref Место место)
{

    if (irs.парамы.cov && место.номстр)
    {
        block_appendexp(irs.blx.curblock, incUsageElem(irs, место));
    }
}


private  class S2irVisitor : Визитор2
{
    IRState *irs;

    this(IRState *irs)
    {
        this.irs = irs;
    }

    alias Визитор2.посети посети;

    /****************************************
     * This should be overridden by each инструкция class.
     */

    override проц посети(Инструкция2 s)
    {
        assert(0);
    }

    /*************************************
     */

    override проц посети(ScopeGuardStatement s)
    {
    }

    /****************************************
     */

    override проц посети(IfStatement s)
    {
        elem *e;
        Blockx *blx = irs.blx;

        //printf("IfStatement.toIR('%s')\n", s.условие.вТкст0());

        IRState mystate = IRState(irs, s);

        // bexit is the block that gets control after this IfStatement is done
        block *bexit = mystate.breakBlock ? mystate.breakBlock : drc.backend.глоб2.block_calloc();

        incUsage(irs, s.место);
        e = toElemDtor(s.условие, &mystate);
        block_appendexp(blx.curblock, e);
        block *bcond = blx.curblock;
        block_next(blx, BCiftrue, null);

        bcond.appendSucc(blx.curblock);
        if (s.ifbody)
            Statement_toIR(s.ifbody, &mystate);
        blx.curblock.appendSucc(bexit);

        if (s.elsebody)
        {
            block_next(blx, BCgoto, null);
            bcond.appendSucc(blx.curblock);
            Statement_toIR(s.elsebody, &mystate);
            blx.curblock.appendSucc(bexit);
        }
        else
            bcond.appendSucc(bexit);

        block_next(blx, BCgoto, bexit);

    }

    /**************************************
     */

    override проц посети(PragmaStatement s)
    {
        //printf("PragmaStatement.toIR()\n");
        if (s.идент == Id.startaddress)
        {
            assert(s.args && s.args.dim == 1);
            Выражение e = (*s.args)[0];
            ДСимвол sa = getDsymbol(e);
            FuncDeclaration f = sa.isFuncDeclaration();
            assert(f);
            Symbol *sym = toSymbol(f);
            while (irs.prev)
                irs = irs.prev;
            irs.startaddress = sym;
        }
    }

    /***********************
     */

    override проц посети(WhileStatement s)
    {
        assert(0); // was "lowered"
    }

    /******************************************
     */

    override проц посети(DoStatement s)
    {
        Blockx *blx = irs.blx;

        IRState mystate = IRState(irs,s);
        mystate.breakBlock = block_calloc(blx);
        mystate.contBlock = block_calloc(blx);

        block *bpre = blx.curblock;
        block_next(blx, BCgoto, null);
        bpre.appendSucc(blx.curblock);

        mystate.contBlock.appendSucc(blx.curblock);
        mystate.contBlock.appendSucc(mystate.breakBlock);

        if (s._body)
            Statement_toIR(s._body, &mystate);
        blx.curblock.appendSucc(mystate.contBlock);

        block_next(blx, BCgoto, mystate.contBlock);
        incUsage(irs, s.условие.место);
        block_appendexp(mystate.contBlock, toElemDtor(s.условие, &mystate));
        block_next(blx, BCiftrue, mystate.breakBlock);

    }

    /*****************************************
     */

    override проц посети(ForStatement s)
    {
        //printf("посети(ForStatement)) %u..%u\n", s.место.номстр, s.endloc.номстр);
        Blockx *blx = irs.blx;

        IRState mystate = IRState(irs,s);
        mystate.breakBlock = block_calloc(blx);
        mystate.contBlock = block_calloc(blx);

        if (s._иниц)
            Statement_toIR(s._иниц, &mystate);
        block *bpre = blx.curblock;
        block_next(blx,BCgoto,null);
        block *bcond = blx.curblock;
        bpre.appendSucc(bcond);
        mystate.contBlock.appendSucc(bcond);
        if (s.условие)
        {
            incUsage(irs, s.условие.место);
            block_appendexp(bcond, toElemDtor(s.условие, &mystate));
            block_next(blx,BCiftrue,null);
            bcond.appendSucc(blx.curblock);
            bcond.appendSucc(mystate.breakBlock);
        }
        else
        {   /* No conditional, it's a straight goto
             */
            block_next(blx,BCgoto,null);
            bcond.appendSucc(blx.curblock);
        }

        if (s._body)
            Statement_toIR(s._body, &mystate);
        /* End of the body goes to the continue block
         */
        blx.curblock.appendSucc(mystate.contBlock);
        block_setLoc(blx.curblock, s.endloc);
        block_next(blx, BCgoto, mystate.contBlock);

        if (s.increment)
        {
            incUsage(irs, s.increment.место);
            block_appendexp(mystate.contBlock, toElemDtor(s.increment, &mystate));
        }

        /* The 'break' block follows the for инструкция.
         */
        block_next(blx,BCgoto, mystate.breakBlock);
    }


    /**************************************
     */

    override проц посети(ForeachStatement s)
    {
        printf("ForeachStatement.toIR() %s\n", s.вТкст0());
        assert(0);  // done by "lowering" in the front end
    }


    /**************************************
     */

    override проц посети(ForeachRangeStatement s)
    {
        assert(0);
    }


    /****************************************
     */

    override проц посети(BreakStatement s)
    {
        block *bbreak;
        block *b;
        Blockx *blx = irs.blx;

        bbreak = irs.getBreakBlock(s.идент);
        assert(bbreak);
        b = blx.curblock;
        incUsage(irs, s.место);

        // Adjust exception handler scope index if in different try blocks
        if (b.Btry != bbreak.Btry)
        {
            //setScopeIndex(blx, b, bbreak.Btry ? bbreak.Btry.Bscope_index : -1);
        }

        /* Nothing more than a 'goto' to the current break destination
         */
        b.appendSucc(bbreak);
        block_setLoc(b, s.место);
        block_next(blx, BCgoto, null);
    }

    /************************************
     */

    override проц посети(ContinueStatement s)
    {
        block *bcont;
        block *b;
        Blockx *blx = irs.blx;

        //printf("ContinueStatement.toIR() %p\n", this);
        bcont = irs.getContBlock(s.идент);
        assert(bcont);
        b = blx.curblock;
        incUsage(irs, s.место);

        // Adjust exception handler scope index if in different try blocks
        if (b.Btry != bcont.Btry)
        {
            //setScopeIndex(blx, b, bcont.Btry ? bcont.Btry.Bscope_index : -1);
        }

        /* Nothing more than a 'goto' to the current continue destination
         */
        b.appendSucc(bcont);
        block_setLoc(b, s.место);
        block_next(blx, BCgoto, null);
    }


    /**************************************
     */

    override проц посети(GotoStatement s)
    {
        Blockx *blx = irs.blx;

        assert(s.label.инструкция);
        assert(s.tf == s.label.инструкция.tf);

        block* bdest = cast(block*)s.label.инструкция.extra;
        block *b = blx.curblock;
        incUsage(irs, s.место);
        b.appendSucc(bdest);
        block_setLoc(b, s.место);

        block_next(blx,BCgoto,null);
    }

    override проц посети(LabelStatement s)
    {
        //printf("LabelStatement.toIR() %p, инструкция: `%s`\n", this, s.инструкция.вТкст0());
        Blockx *blx = irs.blx;
        block *bc = blx.curblock;
        IRState mystate = IRState(irs,s);
        mystate.идент = s.идент;

        block* bdest = cast(block*)s.extra;
        // At last, we know which try block this label is inside
        bdest.Btry = blx.tryblock;

        block_next(blx, BCgoto, bdest);
        bc.appendSucc(blx.curblock);
        if (s.инструкция)
            Statement_toIR(s.инструкция, &mystate);
    }

    /**************************************
     */

    override проц посети(SwitchStatement s)
    {
        Blockx *blx = irs.blx;

        //printf("SwitchStatement.toIR()\n");
        IRState mystate = IRState(irs,s);

        mystate.switchBlock = blx.curblock;

        /* Block for where "break" goes to
         */
        mystate.breakBlock = block_calloc(blx);

        /* Block for where "default" goes to.
         * If there is a default инструкция, then that is where default goes.
         * If not, then do:
         *   default: break;
         * by making the default block the same as the break block.
         */
        mystate.defaultBlock = s.sdefault ? block_calloc(blx) : mystate.breakBlock;

        const numcases = s.cases ? s.cases.dim : 0;

        /* размести a block for each case
         */
        if (numcases)
            foreach (cs; *s.cases)
            {
                cs.extra = cast(ук)block_calloc(blx);
            }

        incUsage(irs, s.место);
        elem *econd = toElemDtor(s.условие, &mystate);
        if (s.hasVars)
        {   /* Generate a sequence of if-then-else blocks for the cases.
             */
            if (econd.Eoper != OPvar)
            {
                elem *e = exp2_copytotemp(econd);
                block_appendexp(mystate.switchBlock, e);
                econd = e.EV.E2;
            }

            if (numcases)
                foreach (cs; *s.cases)
                {
                    elem *ecase = toElemDtor(cs.exp, &mystate);
                    elem *e = el_bin(OPeqeq, TYбул, el_copytree(econd), ecase);
                    block *b = blx.curblock;
                    block_appendexp(b, e);
                    block* cb = cast(block*)cs.extra;
                    block_next(blx, BCiftrue, null);
                    b.appendSucc(cb);
                    b.appendSucc(blx.curblock);
                }

            /* The final 'else' clause goes to the default
             */
            block *b = blx.curblock;
            block_next(blx, BCgoto, null);
            b.appendSucc(mystate.defaultBlock);

            Statement_toIR(s._body, &mystate);

            /* Have the end of the switch body fall through to the block
             * following the switch инструкция.
             */
            block_goto(blx, BCgoto, mystate.breakBlock);
            return;
        }

        if (s.условие.тип.isString())
        {
            // This codepath was replaced by lowering during semantic
            // to объект.__switch in druntime.
            assert(0);
        }

        block_appendexp(mystate.switchBlock, econd);
        block_next(blx,BCswitch,null);

        // Corresponding free is in block_free
        alias typeof(mystate.switchBlock.Bswitch[0]) TCase;
        auto pu = cast(TCase *)Пам.check(.malloc(TCase.sizeof * (numcases + 1)));
        mystate.switchBlock.Bswitch = pu;
        /* First pair is the number of cases, and the default block
         */
        *pu++ = numcases;
        mystate.switchBlock.appendSucc(mystate.defaultBlock);

        /* Fill in the first entry for each pair, which is the case значение.
         * CaseStatement.toIR() will fill in
         * the second entry for each pair with the block.
         */
        if (numcases)
            foreach (cs; *s.cases)
                *pu++ = cs.exp.toInteger();

        Statement_toIR(s._body, &mystate);

        /* Have the end of the switch body fall through to the block
         * following the switch инструкция.
         */
        block_goto(blx, BCgoto, mystate.breakBlock);
    }

    override проц посети(CaseStatement s)
    {
        Blockx *blx = irs.blx;
        block *bcase = blx.curblock;
        block* cb = cast(block*)s.extra;
        block_next(blx, BCgoto, cb);
        block *bsw = irs.getSwitchBlock();
        if (bsw.BC == BCswitch)
            bsw.appendSucc(cb);   // second entry in pair
        bcase.appendSucc(cb);
        incUsage(irs, s.место);
        if (s.инструкция)
            Statement_toIR(s.инструкция, irs);
    }

    override проц посети(DefaultStatement s)
    {
        Blockx *blx = irs.blx;
        block *bcase = blx.curblock;
        block *bdefault = irs.getDefaultBlock();
        block_next(blx,BCgoto,bdefault);
        bcase.appendSucc(blx.curblock);
        incUsage(irs, s.место);
        if (s.инструкция)
            Statement_toIR(s.инструкция, irs);
    }

    override проц посети(GotoDefaultStatement s)
    {
        block *b;
        Blockx *blx = irs.blx;
        block *bdest = irs.getDefaultBlock();

        b = blx.curblock;

        // The rest is equivalent to GotoStatement

        b.appendSucc(bdest);
        incUsage(irs, s.место);
        block_next(blx,BCgoto,null);
    }

    override проц посети(GotoCaseStatement s)
    {
        Blockx *blx = irs.blx;
        block *bdest = cast(block*)s.cs.extra;
        block *b = blx.curblock;

        // The rest is equivalent to GotoStatement

        b.appendSucc(bdest);
        incUsage(irs, s.место);
        block_next(blx,BCgoto,null);
    }

    override проц посети(SwitchErrorStatement s)
    {
        // SwitchErrors are lowered to a CallВыражение to объект.__switch_error() in druntime
        // We still need the call wrapped in SwitchErrorStatement to pass compiler error checks.
        assert(s.exp !is null, "SwitchErrorStatement needs to have a valid Выражение.");

        Blockx *blx = irs.blx;

        //printf("SwitchErrorStatement.toIR(), exp = %s\n", s.exp ? s.exp.вТкст0() : "");
        incUsage(irs, s.место);
        block_appendexp(blx.curblock, toElemDtor(s.exp, irs));
    }

    /**************************************
     */

    override проц посети(ReturnStatement s)
    {
        //printf("s2ir.ReturnStatement: %s\n", s.вТкст0());
        Blockx *blx = irs.blx;
        BC bc;

        incUsage(irs, s.место);
        if (s.exp)
        {
            elem *e;

            FuncDeclaration func = irs.getFunc();
            assert(func);
            auto tf = func.тип.isTypeFunction();
            assert(tf);

            RET retmethod = retStyle(tf, func.needThis());
            if (retmethod == RET.stack)
            {
                elem *es;
                бул writetohp;

                /* If returning struct literal, пиши результат
                 * directly into return значение
                 */
                if (auto sle = s.exp.isStructLiteralExp())
                {
                    sle.sym = irs.shidden;
                    writetohp = да;
                }
                /* Detect function call that returns the same struct
                 * and construct directly into *shidden
                 */
                else if (auto ce = s.exp.isCallExp())
                {
                    if (ce.e1.op == ТОК2.variable || ce.e1.op == ТОК2.star)
                    {
                        Тип t = ce.e1.тип.toBasetype();
                        if (t.ty == Tdelegate)
                            t = t.nextOf();
                        if (t.ty == Tfunction && retStyle(cast(TypeFunction)t, ce.f && ce.f.needThis()) == RET.stack)
                        {
                            irs.ehidden = el_var(irs.shidden);
                            e = toElemDtor(s.exp, irs);
                            e = el_una(OPaddr, TYnptr, e);
                            goto L1;
                        }
                    }
                    else if (auto dve = ce.e1.isDotVarExp())
                    {
                        auto fd = dve.var.isFuncDeclaration();
                        if (fd && fd.isCtorDeclaration())
                        {
                            if (auto sle = dve.e1.isStructLiteralExp())
                            {
                                sle.sym = irs.shidden;
                                writetohp = да;
                            }
                        }
                        Тип t = ce.e1.тип.toBasetype();
                        if (t.ty == Tdelegate)
                            t = t.nextOf();
                        if (t.ty == Tfunction && retStyle(cast(TypeFunction)t, fd && fd.needThis()) == RET.stack)
                        {
                            irs.ehidden = el_var(irs.shidden);
                            e = toElemDtor(s.exp, irs);
                            e = el_una(OPaddr, TYnptr, e);
                            goto L1;
                        }
                    }
                }
                e = toElemDtor(s.exp, irs);
                assert(e);

                if (writetohp ||
                    (func.nrvo_can && func.nrvo_var))
                {
                    // Return значение via hidden pointer passed as параметр
                    // Write exp; return shidden;
                    es = e;
                }
                else
                {
                    // Return значение via hidden pointer passed as параметр
                    // Write *shidden=exp; return shidden;
                    es = el_una(OPind,e.Ety,el_var(irs.shidden));
                    es = elAssign(es, e, s.exp.тип, null);
                }
                e = el_var(irs.shidden);
                e = el_bin(OPcomma, e.Ety, es, e);
            }
            else if (tf.isref)
            {
                // Reference return, so convert to a pointer
                e = toElemDtor(s.exp, irs);
                e = addressElem(e, s.exp.тип.pointerTo());
            }
            else
            {
                e = toElemDtor(s.exp, irs);
                assert(e);
            }
        L1:
            elem_setLoc(e, s.место);
            block_appendexp(blx.curblock, e);
            bc = BCretexp;
//            if (type_zeroCopy(Type_toCtype(s.exp.тип)))
//                bc = BCret;
        }
        else
            bc = BCret;

        block *finallyBlock;
        if (config.ehmethod != EHmethod.EH_DWARF &&
            !irs.isNothrow() &&
            (finallyBlock = irs.getFinallyBlock()) != null)
        {
            assert(finallyBlock.BC == BC_finally);
            blx.curblock.appendSucc(finallyBlock);
        }

        block_next(blx, bc, null);
    }

    /**************************************
     */

    override проц посети(ExpStatement s)
    {
        Blockx *blx = irs.blx;

        //printf("ExpStatement.toIR(), exp = %s\n", s.exp ? s.exp.вТкст0() : "");
        if (s.exp)
        {
            if (s.exp.hasCode)
                incUsage(irs, s.место);

            block_appendexp(blx.curblock, toElemDtor(s.exp, irs));
        }
    }

    /**************************************
     */

    override проц посети(CompoundStatement s)
    {
        if (s.statements)
        {
            foreach (s2; *s.statements)
            {
                if (s2)
                    Statement_toIR(s2, irs);
            }
        }
    }


    /**************************************
     */

    override проц посети(UnrolledLoopStatement s)
    {
        Blockx *blx = irs.blx;

        IRState mystate = IRState(irs,s);
        mystate.breakBlock = block_calloc(blx);

        block *bpre = blx.curblock;
        block_next(blx, BCgoto, null);

        block *bdo = blx.curblock;
        bpre.appendSucc(bdo);

        block *bdox;

        foreach (s2; *s.statements)
        {
            if (s2)
            {
                mystate.contBlock = block_calloc(blx);

                Statement_toIR(s2, &mystate);

                bdox = blx.curblock;
                block_next(blx, BCgoto, mystate.contBlock);
                bdox.appendSucc(mystate.contBlock);
            }
        }

        bdox = blx.curblock;
        block_next(blx, BCgoto, mystate.breakBlock);
        bdox.appendSucc(mystate.breakBlock);
    }


    /**************************************
     */

    override проц посети(ScopeStatement s)
    {
        if (s.инструкция)
        {
            Blockx *blx = irs.blx;
            IRState mystate = IRState(irs,s);

            if (mystate.prev.идент)
                mystate.идент = mystate.prev.идент;

            Statement_toIR(s.инструкция, &mystate);

            if (mystate.breakBlock)
                block_goto(blx,BCgoto,mystate.breakBlock);
        }
    }

    /***************************************
     */

    override проц посети(WithStatement s)
    {
        //printf("WithStatement.toIR()\n");
        if (s.exp.op == ТОК2.scope_ || s.exp.op == ТОК2.тип)
        {
        }
        else
        {
            // Declare with handle
            auto sp = toSymbol(s.wthis);
            symbol_add(sp);

            // Perform initialization of with handle
            auto ie = s.wthis._иниц.isExpInitializer();
            assert(ie);
            auto ei = toElemDtor(ie.exp, irs);
            auto e = el_var(sp);
            e = el_bin(OPeq,e.Ety, e, ei);
            elem_setLoc(e, s.место);
            incUsage(irs, s.место);
            block_appendexp(irs.blx.curblock,e);
        }
        // Execute with block
        if (s._body)
            Statement_toIR(s._body, irs);
    }


    /***************************************
     */

    override проц посети(ThrowStatement s)
    {
        // throw(exp)

        Blockx *blx = irs.blx;

        incUsage(irs, s.место);
        elem *e = toElemDtor(s.exp, irs);
        const цел rtlthrow = config.ehmethod == EHmethod.EH_DWARF ? RTLSYM_THROWDWARF : RTLSYM_THROWC;
        e = el_bin(OPcall, TYvoid, el_var(getRtlsym(rtlthrow)),e);
        block_appendexp(blx.curblock, e);
        block_next(blx, BCexit, null);          // throw never returns
    }

    /***************************************
     * Builds the following:
     *      _try
     *      block
     *      jcatch
     *      handler
     * A try-catch инструкция.
     */

    override проц посети(TryCatchStatement s)
    {
        Blockx *blx = irs.blx;

        if (blx.funcsym.Sfunc.Fflags3 & Feh_none) printf("посети %s\n", blx.funcsym.Sident.ptr);
        if (blx.funcsym.Sfunc.Fflags3 & Feh_none) assert(0);

        if (config.ehmethod == EHmethod.EH_WIN32)
            nteh_declarvars(blx);

        IRState mystate = IRState(irs,s);

        block *tryblock = block_goto(blx,BCgoto,null);

        цел previndex = blx.scope_index;
        tryblock.Blast_index = previndex;
        blx.scope_index = tryblock.Bscope_index = blx.next_index++;

        // Set the current scope index
        setScopeIndex(blx,tryblock,tryblock.Bscope_index);

        // This is the catch variable
        tryblock.jcatchvar = symbol_genauto(type_fake(mTYvolatile | TYnptr));

        blx.tryblock = tryblock;
        block *breakblock = block_calloc(blx);
        block_goto(blx,BC_try,null);
        if (s._body)
        {
            Statement_toIR(s._body, &mystate);
        }
        blx.tryblock = tryblock.Btry;

        // break block goes here
        block_goto(blx, BCgoto, breakblock);

        setScopeIndex(blx,blx.curblock, previndex);
        blx.scope_index = previndex;

        // создай new break block that follows all the catches
        block *breakblock2 = block_calloc(blx);

        blx.curblock.appendSucc(breakblock2);
        block_next(blx,BCgoto,null);

        assert(s.catches);
        if (config.ehmethod == EHmethod.EH_DWARF)
        {
            /*
             * BCjcatch:
             *  __hander = __RDX;
             *  __exception_object = __RAX;
             *  jcatchvar = *(__exception_object - target.ptrsize); // old way
             *  jcatchvar = __dmd_catch_begin(__exception_object);   // new way
             *  switch (__handler)
             *      case 1:     // first catch handler
             *          *(sclosure + cs.var.смещение) = cs.var;
             *          ...handler body ...
             *          break;
             *      ...
             *      default:
             *          HALT
             */
            // volatile so optimizer won't delete it
            Symbol *seax = symbol_name("__EAX", SCpseudo, type_fake(mTYvolatile | TYnptr));
            seax.Sreglsw = 0;          // EAX, RAX, whatevs
            symbol_add(seax);
            Symbol *sedx = symbol_name("__EDX", SCpseudo, type_fake(mTYvolatile | TYint));
            sedx.Sreglsw = 2;          // EDX, RDX, whatevs
            symbol_add(sedx);
            Symbol *shandler = symbol_name("__handler", SCauto, tstypes[TYint]);
            symbol_add(shandler);
            Symbol *seo = symbol_name("__exception_object", SCauto, tspvoid);
            symbol_add(seo);

            elem *e1 = el_bin(OPeq, TYvoid, el_var(shandler), el_var(sedx)); // __handler = __RDX
            elem *e2 = el_bin(OPeq, TYvoid, el_var(seo), el_var(seax)); // __exception_object = __RAX

            version (none)
            {
                // jcatchvar = *(__exception_object - target.ptrsize)
                elem *e = el_bin(OPmin, TYnptr, el_var(seo), el_long(TYт_мера, target.ptrsize));
                elem *e3 = el_bin(OPeq, TYvoid, el_var(tryblock.jcatchvar), el_una(OPind, TYnptr, e));
            }
            else
            {
                //  jcatchvar = __dmd_catch_begin(__exception_object);
                elem *ebegin = el_var(getRtlsym(RTLSYM_BEGIN_CATCH));
                elem *e = el_bin(OPcall, TYnptr, ebegin, el_var(seo));
                elem *e3 = el_bin(OPeq, TYvoid, el_var(tryblock.jcatchvar), e);
            }

            block *bcatch = blx.curblock;
            tryblock.appendSucc(bcatch);
            block_goto(blx, BCjcatch, null);

            block *defaultblock = block_calloc(blx);

            block *bswitch = blx.curblock;
            bswitch.Belem = el_combine(el_combine(e1, e2),
                                        el_combine(e3, el_var(shandler)));

            const numcases = s.catches.dim;
            bswitch.Bswitch = cast(targ_llong *) Пам.check(.malloc((targ_llong).sizeof * (numcases + 1)));
            bswitch.Bswitch[0] = numcases;
            bswitch.appendSucc(defaultblock);
            block_next(blx, BCswitch, null);

            foreach (i, cs; *s.catches)
            {
                bswitch.Bswitch[1 + i] = 1 + i;

                if (cs.var)
                    cs.var.csym = tryblock.jcatchvar;

                assert(cs.тип);

                /* The catch тип can be a C++ class or a D class.
                 * If a D class, вставь a pointer to TypeInfo into the typesTable[].
                 * If a C++ class, вставь a pointer to __cpp_type_info_ptr into the typesTable[].
                 */
                Тип tcatch = cs.тип.toBasetype();
                ClassDeclaration cd = tcatch.isClassHandle();
                бул isCPPclass = cd.isCPPclass();
                Symbol *catchtype;
                if (isCPPclass)
                {
                    catchtype = toSymbolCpp(cd);
                    if (i == 0)
                    {
                        // rewrite ebegin to use __cxa_begin_catch
                        Symbol *s2 = getRtlsym(RTLSYM_CXA_BEGIN_CATCH);
                        ebegin.EV.Vsym = s2;
                    }
                }
                else
                    catchtype = toSymbol(tcatch);

                /* Look for catchtype in typesTable[] using linear search,
                 * вставь if not already there,
                 * log index in Action Table (i.e. switch case table)
                 */
                func_t *f = blx.funcsym.Sfunc;

                foreach (j, ct; f.typesTable[])
                {
                    if (ct == catchtype)
                    {
                        bswitch.Bswitch[1 + i] = 1 + j;  // index starts at 1
                        goto L1;
                    }
                }
                f.typesTable.сунь(catchtype);
                bswitch.Bswitch[1 + i] = f.typesTable.length;  // index starts at 1
           L1:
                block *bcase = blx.curblock;
                bswitch.appendSucc(bcase);

                if (cs.handler !is null)
                {
                    IRState catchState = IRState(irs, s);

                    /* Append to block:
                     *   *(sclosure + cs.var.смещение) = cs.var;
                     */
                    if (cs.var && cs.var.смещение) // if member of a closure
                    {
                        tym_t tym = totym(cs.var.тип);
                        elem *ex = el_var(irs.sclosure);
                        ex = el_bin(OPadd, TYnptr, ex, el_long(TYт_мера, cs.var.смещение));
                        ex = el_una(OPind, tym, ex);
                        ex = el_bin(OPeq, tym, ex, el_var(toSymbol(cs.var)));
                        block_appendexp(catchState.blx.curblock, ex);
                    }
                    if (isCPPclass)
                    {
                        /* C++ catches need to end with call to __cxa_end_catch().
                         * Create:
                         *   try { handler } finally { __cxa_end_catch(); }
                         * Note that this is worst case code because it always sets up an exception handler.
                         * At some point should try to do better.
                         */
                        FuncDeclaration fdend = FuncDeclaration.genCfunc(null, Тип.tvoid, "__cxa_end_catch");
                        Выражение ec = VarExp.создай(Место.initial, fdend);
                        Выражение ecc = CallExp.создай(Место.initial, ec);
                        ecc.тип = Тип.tvoid;
                        Инструкция2 sf = ExpStatement.создай(Место.initial, ecc);
                        Инструкция2 stf = TryFinallyStatement.создай(Место.initial, cs.handler, sf);
                        Statement_toIR(stf, &catchState);
                    }
                    else
                        Statement_toIR(cs.handler, &catchState);
                }
                blx.curblock.appendSucc(breakblock2);
                if (i + 1 == numcases)
                {
                    block_next(blx, BCgoto, defaultblock);
                    defaultblock.Belem = el_calloc();
                    defaultblock.Belem.Ety = TYvoid;
                    defaultblock.Belem.Eoper = OPhalt;
                    block_next(blx, BCexit, null);
                }
                else
                    block_next(blx, BCgoto, null);
            }

            /* Make a копируй of the switch case table, which will later become the Action Table.
             * Need a копируй since the bswitch may get rewritten by the optimizer.
             */
            alias typeof(bcatch.actionTable[0]) TAction;
            bcatch.actionTable = cast(TAction*)Пам.check(.malloc(TAction.sizeof * (numcases + 1)));
            foreach (i; new бцел[0 .. numcases + 1])
                bcatch.actionTable[i] = cast(TAction)bswitch.Bswitch[i];

        }
        else
        {
            foreach (cs; *s.catches)
            {
                if (cs.var)
                    cs.var.csym = tryblock.jcatchvar;
                block *bcatch = blx.curblock;
                if (cs.тип)
                    bcatch.Bcatchtype = toSymbol(cs.тип.toBasetype());
                tryblock.appendSucc(bcatch);
                block_goto(blx, BCjcatch, null);
                if (cs.handler !is null)
                {
                    IRState catchState = IRState(irs, s);

                    /* Append to block:
                     *   *(sclosure + cs.var.смещение) = cs.var;
                     */
                    if (cs.var && cs.var.смещение) // if member of a closure
                    {
                        tym_t tym = totym(cs.var.тип);
                        elem *ex = el_var(irs.sclosure);
                        ex = el_bin(OPadd, TYnptr, ex, el_long(TYт_мера, cs.var.смещение));
                        ex = el_una(OPind, tym, ex);
                        ex = el_bin(OPeq, tym, ex, el_var(toSymbol(cs.var)));
                        block_appendexp(catchState.blx.curblock, ex);
                    }
                    Statement_toIR(cs.handler, &catchState);
                }
                blx.curblock.appendSucc(breakblock2);
                block_next(blx, BCgoto, null);
            }
        }

        block_next(blx,cast(BC)blx.curblock.BC, breakblock2);
    }

    /****************************************
     * A try-finally инструкция.
     * Builds the following:
     *      _try
     *      block
     *      _finally
     *      finalbody
     *      _ret
     */

    override проц посети(TryFinallyStatement s)
    {
        //printf("TryFinallyStatement.toIR()\n");

        Blockx *blx = irs.blx;

        if (config.ehmethod == EHmethod.EH_WIN32 && !(blx.funcsym.Sfunc.Fflags3 & Feh_none))
            nteh_declarvars(blx);

        /* Successors to BC_try block:
         *      [0] start of try block code
         *      [1] BC_finally
         */
        block *tryblock = block_goto(blx, BCgoto, null);

        цел previndex = blx.scope_index;
        tryblock.Blast_index = previndex;
        tryblock.Bscope_index = blx.next_index++;
        blx.scope_index = tryblock.Bscope_index;

        // Current scope index
        setScopeIndex(blx,tryblock,tryblock.Bscope_index);

        blx.tryblock = tryblock;
        block_goto(blx,BC_try,null);

        IRState bodyirs = IRState(irs, s);

        block *finallyblock = block_calloc(blx);

        tryblock.appendSucc(finallyblock);
        finallyblock.BC = BC_finally;
        bodyirs.finallyBlock = finallyblock;

        if (s._body)
            Statement_toIR(s._body, &bodyirs);
        blx.tryblock = tryblock.Btry;     // back to previous tryblock

        setScopeIndex(blx,blx.curblock,previndex);
        blx.scope_index = previndex;

        block *breakblock = block_calloc(blx);
        block *retblock = block_calloc(blx);

        if (config.ehmethod == EHmethod.EH_DWARF && !(blx.funcsym.Sfunc.Fflags3 & Feh_none))
        {
            /* Build this:
             *  BCgoto     [BC_try]
             *  BC_try     [body] [BC_finally]
             *  body
             *  BCgoto     [breakblock]
             *  BC_finally [BC_lpad] [finalbody] [breakblock]
             *  BC_lpad    [finalbody]
             *  finalbody
             *  BCgoto     [BC_ret]
             *  BC_ret
             *  breakblock
             */
            blx.curblock.appendSucc(breakblock);
            block_next(blx,BCgoto,finallyblock);

            block *landingPad = block_goto(blx,BC_finally,null);
            block_goto(blx,BC_lpad,null);               // lpad is [0]
            finallyblock.appendSucc(blx.curblock);    // start of finalybody is [1]
            finallyblock.appendSucc(breakblock);       // breakblock is [2]

            /* Declare флаг variable
             */
            Symbol *sflag = symbol_name("__flag", SCauto, tstypes[TYint]);
            symbol_add(sflag);
            finallyblock.флаг = sflag;
            finallyblock.b_ret = retblock;
            assert(!finallyblock.Belem);

            /* Add code to landingPad block:
             *  exception_object = RAX;
             *  _flag = 0;
             */
            // Make it volatile so optimizer won't delete it
            Symbol *sreg = symbol_name("__EAX", SCpseudo, type_fake(mTYvolatile | TYnptr));
            sreg.Sreglsw = 0;          // EAX, RAX, whatevs
            symbol_add(sreg);
            Symbol *seo = symbol_name("__exception_object", SCauto, tspvoid);
            symbol_add(seo);
            assert(!landingPad.Belem);
            elem *e = el_bin(OPeq, TYvoid, el_var(seo), el_var(sreg));
            landingPad.Belem = el_combine(e, el_bin(OPeq, TYvoid, el_var(sflag), el_long(TYint, 0)));

            /* Add code to BC_ret block:
             *  (!_flag && _Unwind_Resume(exception_object));
             */
            elem *eu = el_bin(OPcall, TYvoid, el_var(getRtlsym(RTLSYM_UNWIND_RESUME)), el_var(seo));
            eu = el_bin(OPandand, TYvoid, el_una(OPnot, TYбул, el_var(sflag)), eu);
            assert(!retblock.Belem);
            retblock.Belem = eu;

            IRState finallyState = IRState(irs, s);

            setScopeIndex(blx, blx.curblock, previndex);
            if (s.finalbody)
                Statement_toIR(s.finalbody, &finallyState);
            block_goto(blx, BCgoto, retblock);

            block_next(blx,BC_ret,breakblock);
        }
        else if (config.ehmethod == EHmethod.EH_NONE || blx.funcsym.Sfunc.Fflags3 & Feh_none)
        {
            /* Build this:
             *  BCgoto     [BC_try]
             *  BC_try     [body] [BC_finally]
             *  body
             *  BCgoto     [breakblock]
             *  BC_finally [BC_lpad] [finalbody] [breakblock]
             *  BC_lpad    [finalbody]
             *  finalbody
             *  BCgoto     [BC_ret]
             *  BC_ret
             *  breakblock
             */
            if (s.bodyFallsThru)
            {
                // BCgoto [breakblock]
                blx.curblock.appendSucc(breakblock);
                block_next(blx,BCgoto,finallyblock);
            }
            else
            {
                if (!irs.парамы.optimize)
                {
                    /* If this is reached at runtime, there's a bug
                     * in the computation of s.bodyFallsThru. Inserting a HALT
                     * makes it far easier to track down such failures.
                     * But it makes for slower code, so only generate it for
                     * non-optimized code.
                     */
                    elem *e = el_calloc();
                    e.Ety = TYvoid;
                    e.Eoper = OPhalt;
                    elem_setLoc(e, s.место);
                    block_appendexp(blx.curblock, e);
                }

                block_next(blx,BCexit,finallyblock);
            }

            block *landingPad = block_goto(blx,BC_finally,null);
            block_goto(blx,BC_lpad,null);               // lpad is [0]
            finallyblock.appendSucc(blx.curblock);    // start of finalybody is [1]
            finallyblock.appendSucc(breakblock);       // breakblock is [2]

            /* Declare флаг variable
             */
            Symbol *sflag = symbol_name("__flag", SCauto, tstypes[TYint]);
            symbol_add(sflag);
            finallyblock.флаг = sflag;
            finallyblock.b_ret = retblock;
            assert(!finallyblock.Belem);

            landingPad.Belem = el_bin(OPeq, TYvoid, el_var(sflag), el_long(TYint, 0)); // __flag = 0;

            IRState finallyState = IRState(irs, s);

            setScopeIndex(blx, blx.curblock, previndex);
            if (s.finalbody)
                Statement_toIR(s.finalbody, &finallyState);
            block_goto(blx, BCgoto, retblock);

            block_next(blx,BC_ret,breakblock);
        }
        else
        {
            block_goto(blx,BCgoto, breakblock);
            block_goto(blx,BCgoto,finallyblock);

            /* Successors to BC_finally block:
             *  [0] landing pad, same as start of finally code
             *  [1] block that comes after BC_ret
             */
            block_goto(blx,BC_finally,null);

            IRState finallyState = IRState(irs, s);

            setScopeIndex(blx, blx.curblock, previndex);
            if (s.finalbody)
                Statement_toIR(s.finalbody, &finallyState);
            block_goto(blx, BCgoto, retblock);

            block_next(blx,BC_ret,null);

            /* Append the last successor to finallyblock, which is the first block past the BC_ret block.
             */
            finallyblock.appendSucc(blx.curblock);

            retblock.appendSucc(blx.curblock);

            /* The BCfinally..BC_ret blocks form a function that gets called from stack unwinding.
             * The successors to BC_ret blocks are both the следщ outer BCfinally and the destination
             * after the unwinding is complete.
             */
            for (block *b = tryblock; b != finallyblock; b = b.Bnext)
            {
                block *btry = b.Btry;

                if (b.BC == BCgoto && b.numSucc() == 1)
                {
                    block *bdest = b.nthSucc(0);
                    if (btry && bdest.Btry != btry)
                    {
                        //printf("test1 b %p b.Btry %p bdest %p bdest.Btry %p\n", b, btry, bdest, bdest.Btry);
                        block *bfinally = btry.nthSucc(1);
                        if (bfinally == finallyblock)
                        {
                            b.appendSucc(finallyblock);
                        }
                    }
                }

                // If the goto exits a try block, then the finally block is also a successor
                if (b.BC == BCgoto && b.numSucc() == 2) // if goto exited a tryblock
                {
                    block *bdest = b.nthSucc(0);

                    // If the last finally block executed by the goto
                    if (bdest.Btry == tryblock.Btry)
                    {
                        // The finally block will exit and return to the destination block
                        retblock.appendSucc(bdest);
                    }
                }

                if (b.BC == BC_ret && b.Btry == tryblock)
                {
                    // b is nested inside this TryFinally, and so this finally will be called следщ
                    b.appendSucc(finallyblock);
                }
            }
        }
    }

    /****************************************
     */

    override проц посети(SynchronizedStatement s)
    {
        assert(0);
    }


    /****************************************
     */

    override проц посети(InlineAsmStatement s)
//    { .посети(irs, s); }
    {
        block *bpre;
        block *basm;
        Symbol *sym;
        Blockx *blx = irs.blx;

        //printf("AsmStatement.toIR(asmcode = %x)\n", asmcode);
        bpre = blx.curblock;
        block_next(blx,BCgoto,null);
        basm = blx.curblock;
        bpre.appendSucc(basm);
        basm.Bcode = s.asmcode;
        basm.Balign = cast(ббайт)s.asmalign;

        // Loop through each instruction, fixing Дсимволы into Symbol's
        for (code *c = s.asmcode; c; c = c.следщ)
        {
            switch (c.IFL1)
            {
                case FLblockoff:
                case FLblock:
                {
                    // FLblock and FLblockoff have LabelDsymbol's - convert to blocks
                    LabelDsymbol label = cast(LabelDsymbol)c.IEV1.Vlsym;
                    block *b = cast(block*)label.инструкция.extra;
                    basm.appendSucc(b);
                    c.IEV1.Vblock = b;
                    break;
                }

                case FLdsymbol:
                case FLfunc:
                    sym = toSymbol(cast(ДСимвол)c.IEV1.Vdsym);
                    if (sym.Sclass == SCauto && sym.Ssymnum == -1)
                        symbol_add(sym);
                    c.IEV1.Vsym = sym;
                    c.IFL1 = sym.Sfl ? sym.Sfl : FLauto;
                    break;

                default:
                    break;
            }

            // Repeat for second operand
            switch (c.IFL2)
            {
                case FLblockoff:
                case FLblock:
                {
                    LabelDsymbol label = cast(LabelDsymbol)c.IEV2.Vlsym;
                    block *b = cast(block*)label.инструкция.extra;
                    basm.appendSucc(b);
                    c.IEV2.Vblock = b;
                    break;
                }

                case FLdsymbol:
                case FLfunc:
                {
                    Declaration d = cast(Declaration)c.IEV2.Vdsym;
                    sym = toSymbol(cast(ДСимвол)d);
                    if (sym.Sclass == SCauto && sym.Ssymnum == -1)
                        symbol_add(sym);
                    c.IEV2.Vsym = sym;
                    c.IFL2 = sym.Sfl ? sym.Sfl : FLauto;
                    if (d.isDataseg())
                        sym.Sflags |= SFLlivexit;
                    break;
                }

                default:
                    break;
            }
        }

        basm.bIasmrefparam = s.refparam;             // are parameters reference?
        basm.usIasmregs = s.regs;                    // registers modified

        block_next(blx,BCasm, null);
        basm.prependSucc(blx.curblock);

        if (s.naked)
        {
            blx.funcsym.Stype.Tty |= mTYnaked;
        }
    }

    /****************************************
     */

    override проц посети(ImportStatement s)
    {
    }

    static проц Statement_toIR(Инструкция2 s, IRState *irs)
    {
        scope v = new S2irVisitor(irs);
        s.прими(v);
    }
}

проц Statement_toIR(Инструкция2 s, IRState *irs)
{
    /* Generate a block for each label
     */
    FuncDeclaration fd = irs.getFunc();
    if (auto labtab = fd.labtab)
        foreach (ключЗначение; labtab.tab.asRange)
        {
            //printf("  KV: %s = %s\n", ключЗначение.ключ.вТкст0(), ключЗначение.значение.вТкст0());
            LabelDsymbol label = cast(LabelDsymbol)ключЗначение.значение;
            if (label.инструкция)
                label.инструкция.extra = drc.backend.глоб2.block_calloc();
        }

    scope v = new S2irVisitor(irs);
    s.прими(v);
}

/***************************************************
 * Insert finally block calls when doing a goto from
 * inside a try block to outside.
 * Done after blocks are generated because then we know all
 * the edges of the graph, but before the Bpred's are computed.
 * Only for EH_DWARF exception unwinding.
 * Параметры:
 *      startblock = first block in function
 */

проц insertFinallyBlockCalls(block *startblock)
{
    цел flagvalue = 0;          // 0 is forunwind_resume
    block *bcret = null;

    block *bcretexp = null;
    Symbol *stmp;

    const log = нет;

    static if (log)
    {
        printf("------- before ----------\n");
        numberBlocks(startblock);
        foreach (b; BlockRange(startblock)) WRblock(b);
        printf("-------------------------\n");
    }

    block **pb;
    block **pbnext;
    for (pb = &startblock; *pb; pb = pbnext)
    {
        block *b = *pb;
        pbnext = &b.Bnext;
        if (!b.Btry)
            continue;

        switch (b.BC)
        {
            case BCret:
                // Rewrite into a BCgoto => BCret
                if (!bcret)
                {
                    bcret = drc.backend.глоб2.block_calloc();
                    bcret.BC = BCret;
                }
                b.BC = BCgoto;
                b.appendSucc(bcret);
                goto case_goto;

            case BCretexp:
            {
                // Rewrite into a BCgoto => BCretexp
                elem *e = b.Belem;
                tym_t ty = tybasic(e.Ety);
                if (!bcretexp)
                {
                    bcretexp = drc.backend.глоб2.block_calloc();
                    bcretexp.BC = BCretexp;
                    тип *t;
                    if ((ty == TYstruct || ty == TYarray) && e.ET)
                        t = e.ET;
                    else
                        t = type_fake(ty);
                    stmp = symbol_genauto(t);
                    bcretexp.Belem = el_var(stmp);
                    if ((ty == TYstruct || ty == TYarray) && e.ET)
                        bcretexp.Belem.ET = t;
                }
                b.BC = BCgoto;
                b.appendSucc(bcretexp);
                b.Belem = elAssign(el_var(stmp), e, null, e.ET);
                goto case_goto;
            }

            case BCgoto:
            case_goto:
            {
                /* From this:
                 *  BCgoto     [breakblock]
                 *  BC_try     [body] [BC_finally]
                 *  body
                 *  BCgoto     [breakblock]
                 *  BC_finally [BC_lpad] [finalbody] [breakblock]
                 *  BC_lpad    [finalbody]
                 *  finalbody
                 *  BCgoto     [BC_ret]
                 *  BC_ret
                 *  breakblock
                 *
                 * Build this:
                 *  BCgoto     [BC_try]
                 *  BC_try     [body] [BC_finally]
                 *  body
                 *x BCgoto     sflag=n; [finalbody]
                 *  BC_finally [BC_lpad] [finalbody] [breakblock]
                 *  BC_lpad    [finalbody]
                 *  finalbody
                 *  BCgoto     [BCiftrue]
                 *x BCiftrue   (sflag==n) [breakblock]
                 *x BC_ret
                 *  breakblock
                 */
                block *breakblock = b.nthSucc(0);
                block *lasttry = breakblock.Btry;
                block *blast = b;
                ++flagvalue;
                for (block *bt = b.Btry; bt != lasttry; bt = bt.Btry)
                {
                    assert(bt.BC == BC_try);
                    block *bf = bt.nthSucc(1);
                    if (bf.BC == BCjcatch)
                        continue;                       // skip try-catch
                    assert(bf.BC == BC_finally);

                    block *retblock = bf.b_ret;
                    assert(retblock.BC == BC_ret);
                    assert(retblock.numSucc() == 0);

                    // Append (_flag = flagvalue) to b.Belem
                    Symbol *sflag = bf.флаг;
                    elem *e = el_bin(OPeq, TYint, el_var(sflag), el_long(TYint, flagvalue));
                    b.Belem = el_combine(b.Belem, e);

                    if (blast.BC == BCiftrue)
                    {
                        blast.setNthSucc(0, bf.nthSucc(1));
                    }
                    else
                    {
                        assert(blast.BC == BCgoto);
                        blast.setNthSucc(0, bf.nthSucc(1));
                    }

                    // Create new block, bnew, which will replace retblock
                    block *bnew = drc.backend.глоб2.block_calloc();

                    /* Rewrite BC_ret block as:
                     *  if (sflag == flagvalue) goto breakblock; else goto bnew;
                     */
                    e = el_bin(OPeqeq, TYбул, el_var(sflag), el_long(TYint, flagvalue));
                    retblock.Belem = el_combine(retblock.Belem, e);
                    retblock.BC = BCiftrue;
                    retblock.appendSucc(breakblock);
                    retblock.appendSucc(bnew);

                    bnew.Bnext = retblock.Bnext;
                    retblock.Bnext = bnew;

                    bnew.BC = BC_ret;
                    bnew.Btry = retblock.Btry;
                    bf.b_ret = bnew;

                    blast = retblock;
                }
                break;
            }

            default:
                break;
        }
    }
    if (bcret)
    {
        *pb = bcret;
        pb = &(*pb).Bnext;
    }
    if (bcretexp)
        *pb = bcretexp;

    static if (log)
    {
        printf("------- after ----------\n");
        numberBlocks(startblock);
        foreach (b; BlockRange(startblock)) WRblock(b);
        printf("-------------------------\n");
    }
}

/***************************************************
 * Insert gotos to finally blocks when doing a return or goto from
 * inside a try block to outside.
 * Done after blocks are generated because then we know all
 * the edges of the graph, but before the Bpred's are computed.
 * Only for functions with no exception handling.
 * Very similar to insertFinallyBlockCalls().
 * Параметры:
 *      startblock = first block in function
 */

проц insertFinallyBlockGotos(block *startblock)
{
    const log = нет;

    // Insert all the goto's
    insertFinallyBlockCalls(startblock);

    /* Remove all the BC_try, BC_finally, BC_lpad and BC_ret
     * blocks.
     * Actually, just make them into no-ops and let the optimizer
     * delete them.
     */
    foreach (b; BlockRange(startblock))
    {
        b.Btry = null;
        switch (b.BC)
        {
            case BC_try:
                b.BC = BCgoto;
                list_subtract(&b.Bsucc, b.nthSucc(1));
                break;

            case BC_finally:
                b.BC = BCgoto;
                list_subtract(&b.Bsucc, b.nthSucc(2));
                list_subtract(&b.Bsucc, b.nthSucc(0));
                break;

            case BC_lpad:
                b.BC = BCgoto;
                break;

            case BC_ret:
                b.BC = BCexit;
                break;

            default:
                break;
        }
    }

    static if (log)
    {
        printf("------- after ----------\n");
        numberBlocks(startblock);
        foreach (b; BlockRange(startblock)) WRblock(b);
        printf("-------------------------\n");
    }
}
