/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 *              Copyright (C) 2018-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/iasm.d, _iasm.d)
 * Documentation:  https://dlang.org/phobos/dmd_iasm.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/iasm.d
 */

/* Встроенный ассемблер для компилятора D
 */

module dmd.iasm;

import dmd.dscope;
import dmd.func;
import dmd.инструкция;

version (Dinrus)
{
    import dmd.iasmdmd;
}
else version (IN_GCC)
{
    import dmd.iasmgcc;
}

/************************ AsmStatement ***************************************/

Инструкция2 asmSemantic(AsmStatement s, Scope *sc)
{
    //printf("AsmStatement.semantic()\n");

    FuncDeclaration fd = sc.родитель.isFuncDeclaration();
    assert(fd);

    if (!s.tokens)
        return null;

    // Assume assembler code takes care of setting the return значение
    sc.func.hasReturnExp |= 8;

    version (Dinrus)
    {
        auto ias = new InlineAsmStatement(s.место, s.tokens);
        return inlineAsmSemantic(ias, sc);
    }
    else version (IN_GCC)
    {
        auto eas = new GccAsmStatement(s.место, s.tokens);
        return gccAsmSemantic(eas, sc);
    }
    else
    {
        s.выведиОшибку("Инлайн инструкции ассемблера не поддерживаются в D");
        return new ErrorStatement();
    }
}
