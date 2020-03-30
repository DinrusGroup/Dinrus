/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 *              Copyright (C) 2018-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     Iain Buclaw
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/iasmgcc.d, _iasmgcc.d)
 * Documentation:  https://dlang.org/phobos/dmd_iasmgcc.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/iasmgcc.d
 */

/* Inline assembler for the GCC D compiler.
 */

module dmd.iasmgcc;

import cidrus;

import dmd.arraytypes;
import drc.ast.AstCodegen;
import dmd.dscope;
import dmd.errors;
import drc.ast.Expression;
import dmd.expressionsem;
import drc.lexer.Identifier;
import dmd.globals;
import drc.parser.Parser2;
import drc.lexer.Tokens;
import dmd.инструкция;
import dmd.statementsem;

private:

/***********************************
 * Parse list of extended asm input or output operands.
 * Grammar:
 *      | Operands:
 *      |     SymbolicName(opt) StringLiteral AssignВыражение
 *      |     SymbolicName(opt) StringLiteral AssignВыражение , Operands
 *      |
 *      | SymbolicName:
 *      |     [ Идентификатор2 ]
 * Параметры:
 *      p = parser state
 *      s = asm инструкция to parse
 * Возвращает:
 *      number of operands added to the gcc asm инструкция
 */
цел parseExtAsmOperands(Parser)(Parser p, GccAsmStatement s)
{
    цел numargs = 0;

    while (1)
    {
        Выражение arg;
        Идентификатор2 имя;
        Выражение constraint;

        switch (p.token.значение)
        {
            case ТОК2.semicolon:
            case ТОК2.colon:
            case ТОК2.endOfFile:
                return numargs;

            case ТОК2.leftBracket:
                if (p.peekNext() == ТОК2.идентификатор)
                {
                    // Skip over opening `[`
                    p.nextToken();
                    // Store the symbolic имя
                    имя = p.token.идент;
                    p.nextToken();
                }
                else
                {
                    p.выведиОшибку(s.место, "ожидался идентификатор после `[`");
                    goto Lerror;
                }
                // Look for closing `]`
                p.check(ТОК2.rightBracket);
                // Look for the ткст literal and fall through
                if (p.token.значение == ТОК2.string_)
                    goto case;
                else
                    goto default;

            case ТОК2.string_:
                constraint = p.parsePrimaryExp();
                arg = p.parseAssignExp();

                if (!s.args)
                {
                    s.имена = new Идентификаторы();
                    s.constraints = new Выражения();
                    s.args = new Выражения();
                }
                s.имена.сунь(имя);
                s.args.сунь(arg);
                s.constraints.сунь(constraint);
                numargs++;

                if (p.token.значение == ТОК2.comma)
                    p.nextToken();
                break;

            default:
                p.выведиОшибку("expected constant ткст constraint for operand, not `%s`",
                        p.token.вТкст0());
                goto Lerror;
        }
    }
Lerror:
    while (p.token.значение != ТОК2.rightCurly &&
           p.token.значение != ТОК2.semicolon &&
           p.token.значение != ТОК2.endOfFile)
        p.nextToken();

    return numargs;
}

/***********************************
 * Parse list of extended asm clobbers.
 * Grammar:
 *      | Clobbers:
 *      |     StringLiteral
 *      |     StringLiteral , Clobbers
 * Параметры:
 *      p = parser state
 * Возвращает:
 *      массив of parsed clobber Выражения
 */
Выражения *parseExtAsmClobbers(Parser)(Parser p)
{
    Выражения *clobbers;

    while (1)
    {
        Выражение clobber;

        switch (p.token.значение)
        {
            case ТОК2.semicolon:
            case ТОК2.colon:
            case ТОК2.endOfFile:
                return clobbers;

            case ТОК2.string_:
                clobber = p.parsePrimaryExp();
                if (!clobbers)
                    clobbers = new Выражения();
                clobbers.сунь(clobber);

                if (p.token.значение == ТОК2.comma)
                    p.nextToken();
                break;

            default:
                p.выведиОшибку("expected constant ткст constraint for clobber имя, not `%s`",
                        p.token.вТкст0());
                goto Lerror;
        }
    }
Lerror:
    while (p.token.значение != ТОК2.rightCurly &&
           p.token.значение != ТОК2.semicolon &&
           p.token.значение != ТОК2.endOfFile)
        p.nextToken();

    return clobbers;
}

/***********************************
 * Parse list of extended asm goto labels.
 * Grammar:
 *      | GotoLabels:
 *      |     Идентификатор2
 *      |     Идентификатор2 , GotoLabels
 * Параметры:
 *      p = parser state
 * Возвращает:
 *      массив of parsed goto labels
 */
Идентификаторы *parseExtAsmGotoLabels(Parser)(Parser p)
{
    Идентификаторы *labels;

    while (1)
    {
        switch (p.token.значение)
        {
            case ТОК2.semicolon:
            case ТОК2.endOfFile:
                return labels;

            case ТОК2.идентификатор:
                if (!labels)
                    labels = new Идентификаторы();
                labels.сунь(p.token.идент);

                if (p.nextToken() == ТОК2.comma)
                    p.nextToken();
                break;

            default:
                p.выведиОшибку("expected идентификатор for goto label имя, not `%s`",
                        p.token.вТкст0());
                goto Lerror;
        }
    }
Lerror:
    while (p.token.значение != ТОК2.rightCurly &&
           p.token.значение != ТОК2.semicolon &&
           p.token.значение != ТОК2.endOfFile)
        p.nextToken();

    return labels;
}

/***********************************
 * Parse a gcc asm инструкция.
 * There are three forms of inline asm statements, basic, extended, and goto.
 * Grammar:
 *      | AsmInstruction:
 *      |     BasicAsmInstruction
 *      |     ExtAsmInstruction
 *      |     GotoAsmInstruction
 *      |
 *      | BasicAsmInstruction:
 *      |     Выражение
 *      |
 *      | ExtAsmInstruction:
 *      |     Выражение : Operands(opt) : Operands(opt) : Clobbers(opt)
 *      |
 *      | GotoAsmInstruction:
 *      |     Выражение : : Operands(opt) : Clobbers(opt) : GotoLabels(opt)
 * Параметры:
 *      p = parser state
 *      s = asm инструкция to parse
 * Возвращает:
 *      the parsed gcc asm инструкция
 */
GccAsmStatement parseGccAsm(Parser)(Parser p, GccAsmStatement s)
{
    s.insn = p.parseВыражение();
    if (p.token.значение == ТОК2.semicolon || p.token.значение == ТОК2.endOfFile)
        goto Ldone;

    // No semicolon followed after instruction template, treat as extended asm.
    foreach (section; new бцел[0 .. 4])
    {
        p.check(ТОК2.colon);

        switch (section)
        {
            case 0:
                s.outputargs = p.parseExtAsmOperands(s);
                break;

            case 1:
                p.parseExtAsmOperands(s);
                break;

            case 2:
                s.clobbers = p.parseExtAsmClobbers();
                break;

            case 3:
                s.labels = p.parseExtAsmGotoLabels();
                break;
        }

        if (p.token.значение == ТОК2.semicolon || p.token.значение == ТОК2.endOfFile)
            goto Ldone;
    }
Ldone:
    p.check(ТОК2.semicolon);

    return s;
}

/***********************************
 * Parse and run semantic analysis on a GccAsmStatement.
 * Параметры:
 *      s  = gcc asm инструкция being parsed
 *      sc = the scope where the asm инструкция is located
 * Возвращает:
 *      the completed gcc asm инструкция, or null if errors occurred
 */
public Инструкция2 gccAsmSemantic(GccAsmStatement s, Scope *sc)
{
    //printf("GccAsmStatement.semantic()\n");
    scope p = new Parser!(ASTCodegen)(sc._module, ";", нет);

    // Make a safe копируй of the token list before parsing.
    Сема2 *toklist = null;
    Сема2 **ptoklist = &toklist;

    for (Сема2 *token = s.tokens; token; token = token.следщ)
    {
        *ptoklist = p.allocateToken();
        memcpy(*ptoklist, token, Сема2.sizeof);
        ptoklist = &(*ptoklist).следщ;
        *ptoklist = null;
    }
    p.token = *toklist;
    p.scanloc = s.место;

    // Parse the gcc asm инструкция.
    const errors = глоб2.errors;
    s = p.parseGccAsm(s);
    if (errors != глоб2.errors)
        return null;
    s.stc = sc.stc;

    // Fold the instruction template ткст.
    s.insn = semanticString(sc, s.insn, "asm instruction template");

    if (s.labels && s.outputargs)
        s.выведиОшибку("extended asm statements with labels cannot have output constraints");

    // Analyse all input and output operands.
    if (s.args)
    {
        foreach (i; new бцел[0 .. s.args.dim])
        {
            Выражение e = (*s.args)[i];
            e = e.ВыражениеSemantic(sc);
            // Check argument is a valid lvalue/rvalue.
            if (i < s.outputargs)
                e = e.modifiableLvalue(sc, null);
            else if (e.checkValue())
                e = new ErrorExp();
            (*s.args)[i] = e;

            e = (*s.constraints)[i];
            e = e.ВыражениеSemantic(sc);
            assert(e.op == ТОК2.string_ && (cast(StringExp) e).sz == 1);
            (*s.constraints)[i] = e;
        }
    }

    // Analyse all clobbers.
    if (s.clobbers)
    {
        foreach (i; new бцел[0 .. s.clobbers.dim])
        {
            Выражение e = (*s.clobbers)[i];
            e = e.ВыражениеSemantic(sc);
            assert(e.op == ТОК2.string_ && (cast(StringExp) e).sz == 1);
            (*s.clobbers)[i] = e;
        }
    }

    // Analyse all goto labels.
    if (s.labels)
    {
        foreach (i; new бцел[0 .. s.labels.dim])
        {
            Идентификатор2 идент = (*s.labels)[i];
            GotoStatement gs = new GotoStatement(s.место, идент);
            if (!s.gotos)
                s.gotos = new GotoStatements();
            s.gotos.сунь(gs);
            gs.statementSemantic(sc);
        }
    }

    return s;
}
/+
import dmd.mtype : TypeBasic;
unittest
{
    бцел errors = глоб2.startGagging();
    scope(exit) глоб2.endGagging(errors);

    // If this check fails, then Тип._иниц() was called before reaching here,
    // and the entire chunk of code that follows can be removed.
    assert(ASTCodegen.Тип.tint32 is null);
    // Minimally initialize the cached types in ASTCodegen.Тип, as they are
    // dependencies for some fail asm tests to succeed.
    ASTCodegen.Тип.stringtable._иниц();
    scope(exit)
    {
        ASTCodegen.Тип.deinitialize();
        ASTCodegen.Тип.tint32 = null;
    }
    scope tint32 = new TypeBasic(ASTCodegen.Tint32);
    ASTCodegen.Тип.tint32 = tint32;

    // Imitates asmSemantic if version = IN_GCC.
    static цел semanticAsm(Сема2* tokens)
    {
        const errors = глоб2.errors;
        scope gas = new GccAsmStatement(Место.initial, tokens);
        scope p = new Parser!(ASTCodegen)(null, ";", нет);
        p.token = *tokens;
        p.parseGccAsm(gas);
        return глоб2.errors - errors;
    }

    // Imitates parseStatement for asm statements.
    static проц parseAsm(ткст input, бул expectError)
    {
        // Generate tokens from input test.
        scope p = new Parser!(ASTCodegen)(null, input, нет);
        p.nextToken();

        Сема2* toklist = null;
        Сема2** ptoklist = &toklist;
        p.check(ТОК2.asm_);
        p.check(ТОК2.leftCurly);
        while (1)
        {
            if (p.token.значение == ТОК2.rightCurly || p.token.значение == ТОК2.endOfFile)
                break;
            *ptoklist = p.allocateToken();
            memcpy(*ptoklist, &p.token, Сема2.sizeof);
            ptoklist = &(*ptoklist).следщ;
            *ptoklist = null;
            p.nextToken();
        }
        p.check(ТОК2.rightCurly);

        auto res = semanticAsm(toklist);
        // Checks for both unexpected passes and failures.
        assert((res == 0) != expectError);
    }

    /// Assembly Tests, all should pass.
    /// Note: Frontend is not initialized, use only strings and identifiers.
    const ткст[] passAsmTests = [
        // Basic asm инструкция
        q{ asm { "nop";
        } },

        // Extended asm инструкция
        q{ asm { "cpuid"
               : "=a" (a), "=b" (b), "=c" (c), "=d" (d)
               : "a" input;
        } },

        // Assembly with symbolic имена
        q{ asm { "bts %[base], %[смещение]"
               : [base] "+rm" *ptr,
               : [смещение] "Ir" bitnum;
        } },

        // Assembly with clobbers
        q{ asm { "cpuid"
               : "=a" a
               : "a" input
               : "ebx", "ecx", "edx";
        } },

        // Goto asm инструкция
        q{ asm { "jmp %l0"
               :
               :
               :
               : Ljmplabel;
        } },

        // Any CTFE-able ткст allowed as instruction template.
        q{ asm { generateAsm();
        } },

        // Likewise mixins, permissible so long as the результат is a ткст.
        q{ asm { mixin(`"repne"`, `~ "scasb"`);
        } },
    ];

    const ткст[] failAsmTests = [
        // Found 'h' when expecting ';'
        q{ asm { ""h;
        } },

        // https://issues.dlang.org/show_bug.cgi?ид=20592
        q{ asm { "nop" : [имя] ткст (expr); } },

        // Выражение expected, not ';'
        q{ asm { ""[;
        } },

        // Выражение expected, not ':'
        q{ asm { ""
               :
               : "g" a ? b : : c;
        } },
    ];

    foreach (test; passAsmTests)
        parseAsm(test, нет);

    foreach (test; failAsmTests)
        parseAsm(test, да);
}
+/