/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/irstate.d, _irstate.d)
 * Documentation: https://dlang.org/phobos/dmd_irstate.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/irstate.d
 */

module dmd.irstate;

import util.array;

import dmd.arraytypes;
import drc.backend.тип;
import dmd.dclass;
import dmd.dmodule;
import dmd.дсимвол;
import dmd.func;
import drc.lexer.Identifier;
import dmd.инструкция;
import dmd.globals;
import dmd.mtype;

import drc.backend.cc;
import drc.backend.el;

/****************************************
 * Our label symbol
 */

struct Label
{
    block *lblock;      // The block to which the label is defined.
}

/***********************************************************
 */
struct IRState
{
    IRState* prev;
    Инструкция2 инструкция;
    Module m;                       // module
    private FuncDeclaration symbol; // function that code is being generate for
    Идентификатор2 идент;
    Symbol* shidden;                // hidden параметр to function
    Symbol* sthis;                  // 'this' параметр to function (member and nested)
    Symbol* sclosure;               // pointer to closure instance
    Blockx* blx;
    Дсимволы* deferToObj;           // массив of ДСимвол's to run toObjFile(бул multiobj) on later
    elem* ehidden;                  // transmit hidden pointer to CallExp::toElem()
    Symbol* startaddress;
    МассивДРК!(elem*)* varsInScope;     // variables that are in scope that will need destruction later
    Label*[ук]* labels;          // table of labels используется/declared in function
    const Param* парамы;            // command line parameters
    бул mayThrow;                  // the Выражение being evaluated may throw

    block* breakBlock;
    block* contBlock;
    block* switchBlock;
    block* defaultBlock;
    block* finallyBlock;

    this(IRState* irs, Инструкция2 s)
    {
        prev = irs;
        инструкция = s;
        if (irs)
        {
            m = irs.m;
            shidden = irs.shidden;
            sclosure = irs.sclosure;
            sthis = irs.sthis;
            blx = irs.blx;
            deferToObj = irs.deferToObj;
            varsInScope = irs.varsInScope;
            labels = irs.labels;
            парамы = irs.парамы;
            mayThrow = irs.mayThrow;
        }
    }

    this(Module m, FuncDeclaration fd, МассивДРК!(elem*)* varsInScope, Дсимволы* deferToObj, Label*[ук]* labels,
         Param* парамы)
    {
        this.m = m;
        this.symbol = fd;
        this.varsInScope = varsInScope;
        this.deferToObj = deferToObj;
        this.labels = labels;
        this.парамы = парамы;
        mayThrow = глоб2.парамы.useExceptions
            && ClassDeclaration.throwable
            && !(fd && fd.eh_none);
    }

    /****
     * Access labels AA from C++ code.
     * Параметры:
     *  s = ключ
     * Возвращает:
     *  pointer to значение if it's there, null if not
     */
    Label** lookupLabel(Инструкция2 s)
    {
        return cast(ук)s in *labels;
    }

    /****
     * Access labels AA from C++ code.
     * Параметры:
     *  s = ключ
     *  label = значение
     */
    проц insertLabel(Инструкция2 s, Label* label)
    {
        (*labels)[cast(ук)s] = label;
    }

    block* getBreakBlock(Идентификатор2 идент)
    {
        IRState* bc;
        if (идент)
        {
            Инструкция2 related = null;
            block* ret = null;
            for (bc = &this; bc; bc = bc.prev)
            {
                // The label for a breakBlock may actually be some levels up (e.g.
                // on a try/finally wrapping a loop). We'll see if this breakBlock
                // is the one to return once we reach that outer инструкция (which
                // in many cases will be this same инструкция).
                if (bc.breakBlock)
                {
                    related = bc.инструкция.getRelatedLabeled();
                    ret = bc.breakBlock;
                }
                if (bc.инструкция == related && bc.prev.идент == идент)
                    return ret;
            }
        }
        else
        {
            for (bc = &this; bc; bc = bc.prev)
            {
                if (bc.breakBlock)
                    return bc.breakBlock;
            }
        }
        return null;
    }

    block* getContBlock(Идентификатор2 идент)
    {
        IRState* bc;
        if (идент)
        {
            block* ret = null;
            for (bc = &this; bc; bc = bc.prev)
            {
                // The label for a contBlock may actually be some levels up (e.g.
                // on a try/finally wrapping a loop). We'll see if this contBlock
                // is the one to return once we reach that outer инструкция (which
                // in many cases will be this same инструкция).
                if (bc.contBlock)
                {
                    ret = bc.contBlock;
                }
                if (bc.prev && bc.prev.идент == идент)
                    return ret;
            }
        }
        else
        {
            for (bc = &this; bc; bc = bc.prev)
            {
                if (bc.contBlock)
                    return bc.contBlock;
            }
        }
        return null;
    }

    block* getSwitchBlock()
    {
        IRState* bc;
        for (bc = &this; bc; bc = bc.prev)
        {
            if (bc.switchBlock)
                return bc.switchBlock;
        }
        return null;
    }

    block* getDefaultBlock()
    {
        IRState* bc;
        for (bc = &this; bc; bc = bc.prev)
        {
            if (bc.defaultBlock)
                return bc.defaultBlock;
        }
        return null;
    }

    block* getFinallyBlock()
    {
        IRState* bc;
        for (bc = &this; bc; bc = bc.prev)
        {
            if (bc.finallyBlock)
                return bc.finallyBlock;
        }
        return null;
    }

    FuncDeclaration getFunc()
    {
        for (auto bc = &this; 1; bc = bc.prev)
        {
            if (!bc.prev)
                return bc.symbol;
        }
    }

    /**********************
     * Возвращает:
     *    да if do массив bounds checking for the current function
     */
    бул arrayBoundsCheck()
    {
        бул результат;
        switch (глоб2.парамы.useArrayBounds)
        {
        case CHECKENABLE.off:
            результат = нет;
            break;
        case CHECKENABLE.on:
            результат = да;
            break;
        case CHECKENABLE.safeonly:
            {
                результат = нет;
                FuncDeclaration fd = getFunc();
                if (fd)
                {
                    Тип t = fd.тип;
                    if (t.ty == Tfunction && (cast(TypeFunction)t).trust == TRUST.safe)
                        результат = да;
                }
                break;
            }
        case CHECKENABLE._default:
            assert(0);
        }
        return результат;
    }

    /****************************
     * Возвращает:
     *  да if in a  section of code
     */
    бул isNothrow()
    {
        return !mayThrow;
    }
}
