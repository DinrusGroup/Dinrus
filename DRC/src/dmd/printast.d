/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/printast.d, _printast.d)
 * Documentation:  https://dlang.org/phobos/dmd_printast.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/printast.d
 */

module dmd.printast;

version(PRINTF) import cidrus;
else import common;

import drc.ast.Expression;
import drc.lexer.Tokens;
import drc.ast.Visitor;

/********************
 * Выводит структуру данных АСД в приятном формате.
 * Параметры:
 *  e = распечатываемое выражение АСД
 *  отступ = уровень идентации
 */
проц выведиАСД(Выражение e, цел отступ = 0)
{
    scope PrintASTVisitor pav = new PrintASTVisitor(отступ);
    e.прими(pav);
}

private:

 final class PrintASTVisitor : Визитор2
{
    alias Визитор2.посети посети;

    цел отступ;

    this(цел отступ)
    {
        this.отступ = отступ;
    }

    override проц посети(Выражение e)
    {
        печатайОтступ(отступ);
    version(PRINTF)    
        printf("%s %s\n", Сема2.вТкст0(e.op), e.тип ? e.тип.вТкст0() : "");
      else выдай.форматнс("{} {}", Сема2.вТкст0(e.op), e.тип ? e.тип.вТкст0() : "");
    }

    override проц посети(StructLiteralExp e)
    {
        печатайОтступ(отступ);
      version(PRINTF) 
        printf("%s %s, %s\n", Сема2.вТкст0(e.op), e.тип ? e.тип.вТкст0() : "", e.вТкст0());
        else  выдай.форматнс("{} {}, {}", Сема2.вТкст0(e.op), e.тип ? e.тип.вТкст0() : "", e.вТкст0());
    }

    override проц посети(SymbolExp e)
    {
        посети(cast(Выражение)e);
        печатайОтступ(отступ + 2);
      version(PRINTF) 
        printf(".var: %s\n", e.var ? e.var.вТкст0() : "");
        else выдай.форматнс(".var: %s\n", e.var ? e.var.вТкст0() : "");
    }

    override проц посети(DsymbolExp e)
    {
        посети(cast(Выражение)e);
        печатайОтступ(отступ + 2);
      version(PRINTF) 
        printf(".s: %s\n", e.s ? e.s.вТкст0() : "");
        else  выдай.форматнс(".s: {}", e.s ? e.s.вТкст0() : "");
    }

    override проц посети(DotIdExp e)
    {
        посети(cast(Выражение)e);
        печатайОтступ(отступ + 2);
        version(PRINTF) 
        printf(".идент: %s\n", e.идент.вТкст0());
            else  выдай.форматнс(".идент: {}", e.идент.вТкст0());
        выведиАСД(e.e1, отступ + 2);
    }

    override проц посети(UnaExp e)
    {
        посети(cast(Выражение)e);
        выведиАСД(e.e1, отступ + 2);
    }

    override проц посети(BinExp e)
    {
        посети(cast(Выражение)e);
        выведиАСД(e.e1, отступ + 2);
        выведиАСД(e.e2, отступ + 2);
    }

    override проц посети(DelegateExp e)
    {
        посети(cast(Выражение)e);
        печатайОтступ(отступ + 2);
    version(PRINTF)
        printf(".func: %s\n", e.func ? e.func.вТкст0() : "");
        else  выдай.форматнс(".func: {}", e.func ? e.func.вТкст0() : "");
    }

    static проц печатайОтступ(цел отступ)
    {
        foreach (i; new бцел[0 .. отступ])
            version(PRINTF)  putc(' ', stdout);
                else выдай(' ');
    }
}


