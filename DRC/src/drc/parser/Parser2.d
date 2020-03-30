/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/parse.d, _parse.d)
 * Documentation:  https://dlang.org/phobos/dmd_parse.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/parse.d
 */

module drc.parser.Parser2;

import cidrus;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import drc.lexer.Lexer2;
import dmd.errors;
import util.filename;
import util.outbuffer;
import util.rmem;
import drc.ast.Node;
import util.string;
import drc.lexer.Tokens;

// Как происходит разбор нескольких деклараций.
// Если 1, рассматривать как C.
// Если 0, рассматривать:
//      цел *p, i;
// как:
//      цел* p;
//      цел* i;
private const CDECLSYNTAX = 0;

// Поддержка синтаксиса C cast:
//      (тип)(Выражение)
private const CCASTSYNTAX = 1;

// Поддержка постфиксных деклараций массивов C, таких как
//      цел a[3][4];
private const CARRAYDECL = 1;

/**********************************
 * Установка прециденции операторов.
 *
 * Used by hdrgen
 */
const PREC[ТОК2.max_] precedence =
[
    ТОК2.тип : PREC.expr,
    ТОК2.error : PREC.expr,
    ТОК2.objcClassReference : PREC.expr, // Objective-C class reference, same as ТОК2.тип

    ТОК2.typeof_ : PREC.primary,
    ТОК2.mixin_ : PREC.primary,

    ТОК2.import_ : PREC.primary,
    ТОК2.dotVariable : PREC.primary,
    ТОК2.scope_ : PREC.primary,
    ТОК2.идентификатор : PREC.primary,
    ТОК2.this_ : PREC.primary,
    ТОК2.super_ : PREC.primary,
    ТОК2.int64 : PREC.primary,
    ТОК2.float64 : PREC.primary,
    ТОК2.complex80 : PREC.primary,
    ТОК2.null_ : PREC.primary,
    ТОК2.string_ : PREC.primary,
    ТОК2.arrayLiteral : PREC.primary,
    ТОК2.assocArrayLiteral : PREC.primary,
    ТОК2.classReference : PREC.primary,
    ТОК2.файл : PREC.primary,
    ТОК2.fileFullPath : PREC.primary,
    ТОК2.line : PREC.primary,
    ТОК2.moduleString : PREC.primary,
    ТОК2.functionString : PREC.primary,
    ТОК2.prettyFunction : PREC.primary,
    ТОК2.typeid_ : PREC.primary,
    ТОК2.is_ : PREC.primary,
    ТОК2.assert_ : PREC.primary,
    ТОК2.halt : PREC.primary,
    ТОК2.template_ : PREC.primary,
    ТОК2.dSymbol : PREC.primary,
    ТОК2.function_ : PREC.primary,
    ТОК2.variable : PREC.primary,
    ТОК2.symbolOffset : PREC.primary,
    ТОК2.structLiteral : PREC.primary,
    ТОК2.arrayLength : PREC.primary,
    ТОК2.delegatePointer : PREC.primary,
    ТОК2.delegateFunctionPointer : PREC.primary,
    ТОК2.удали : PREC.primary,
    ТОК2.кортеж : PREC.primary,
    ТОК2.traits : PREC.primary,
    ТОК2.default_ : PREC.primary,
    ТОК2.overloadSet : PREC.primary,
    ТОК2.void_ : PREC.primary,
    ТОК2.vectorArray : PREC.primary,

    // post
    ТОК2.dotTemplateInstance : PREC.primary,
    ТОК2.dotIdentifier : PREC.primary,
    ТОК2.dotTemplateDeclaration : PREC.primary,
    ТОК2.dot : PREC.primary,
    ТОК2.dotType : PREC.primary,
    ТОК2.plusPlus : PREC.primary,
    ТОК2.minusMinus : PREC.primary,
    ТОК2.prePlusPlus : PREC.primary,
    ТОК2.preMinusMinus : PREC.primary,
    ТОК2.call : PREC.primary,
    ТОК2.slice : PREC.primary,
    ТОК2.массив : PREC.primary,
    ТОК2.index : PREC.primary,

    ТОК2.delegate_ : PREC.unary,
    ТОК2.address : PREC.unary,
    ТОК2.star : PREC.unary,
    ТОК2.negate : PREC.unary,
    ТОК2.uadd : PREC.unary,
    ТОК2.not : PREC.unary,
    ТОК2.tilde : PREC.unary,
    ТОК2.delete_ : PREC.unary,
    ТОК2.new_ : PREC.unary,
    ТОК2.newAnonymousClass : PREC.unary,
    ТОК2.cast_ : PREC.unary,

    ТОК2.vector : PREC.unary,
    ТОК2.pow : PREC.pow,

    ТОК2.mul : PREC.mul,
    ТОК2.div : PREC.mul,
    ТОК2.mod : PREC.mul,

    ТОК2.add : PREC.add,
    ТОК2.min : PREC.add,
    ТОК2.concatenate : PREC.add,

    ТОК2.leftShift : PREC.shift,
    ТОК2.rightShift : PREC.shift,
    ТОК2.unsignedRightShift : PREC.shift,

    ТОК2.lessThan : PREC.rel,
    ТОК2.lessOrEqual : PREC.rel,
    ТОК2.greaterThan : PREC.rel,
    ТОК2.greaterOrEqual : PREC.rel,
    ТОК2.in_ : PREC.rel,

    /* Заметьте, прециденция нами изменена, теперь у < и != она
     * одинаковая. Это изменение также появилось и в парсере.
     */
    ТОК2.equal : PREC.rel,
    ТОК2.notEqual : PREC.rel,
    ТОК2.identity : PREC.rel,
    ТОК2.notIdentity : PREC.rel,

    ТОК2.and : PREC.and,
    ТОК2.xor : PREC.xor,
    ТОК2.or : PREC.or,

    ТОК2.andAnd : PREC.andand,
    ТОК2.orOr : PREC.oror,

    ТОК2.question : PREC.cond,

    ТОК2.assign : PREC.assign,
    ТОК2.construct : PREC.assign,
    ТОК2.blit : PREC.assign,
    ТОК2.addAssign : PREC.assign,
    ТОК2.minAssign : PREC.assign,
    ТОК2.concatenateAssign : PREC.assign,
    ТОК2.concatenateElemAssign : PREC.assign,
    ТОК2.concatenateDcharAssign : PREC.assign,
    ТОК2.mulAssign : PREC.assign,
    ТОК2.divAssign : PREC.assign,
    ТОК2.modAssign : PREC.assign,
    ТОК2.powAssign : PREC.assign,
    ТОК2.leftShiftAssign : PREC.assign,
    ТОК2.rightShiftAssign : PREC.assign,
    ТОК2.unsignedRightShiftAssign : PREC.assign,
    ТОК2.andAssign : PREC.assign,
    ТОК2.orAssign : PREC.assign,
    ТОК2.xorAssign : PREC.assign,

    ТОК2.comma : PREC.expr,
    ТОК2.declaration : PREC.expr,

    ТОК2.interval : PREC.assign,
];

enum ParseStatementFlags : цел
{
    semi          = 1,        // пустые инструкции ';' допустимы, но депрекированы
    scope_        = 2,        // начать новый масштаб
    curly         = 4,        // { } требуется инструкция
    curlyScope    = 8,        // { } начинает новый масштаб
    semiOk        = 0x10,     // пустые ';' реально ok
}

private struct PrefixAttributes(AST)
{
    КлассХранения классХранения;
    AST.Выражение depmsg;
    LINK link;
    AST.Prot защита;
    бул setAlignment;
    AST.Выражение ealign;
    AST.Выражения* udas;
    ткст0 коммент;
}

/*****************************
 * Destructively extract storage class from pAttrs.
 */
private КлассХранения getStorageClass(AST)(PrefixAttributes!(AST)* pAttrs)
{
    КлассХранения stc = AST.STC.undefined_;
    if (pAttrs)
    {
        stc = pAttrs.классХранения;
        pAttrs.классХранения = AST.STC.undefined_;
    }
    return stc;
}

/**************************************
 * dump mixin expansion to файл for better debugging
 */
private бул writeMixin(ткст s, ref Место место)
{
    if (!глоб2.парамы.mixinOut)
        return нет;

    БуфВыв* ob = глоб2.парамы.mixinOut;

    ob.пишиСтр("// expansion at ");
    ob.пишиСтр(место.вТкст0());
    ob.нс();

    глоб2.парамы.mixinLines++;

    место = Место(глоб2.парамы.mixinFile, глоб2.парамы.mixinLines + 1, место.имяс);

    // пиши by line to создай consistent line endings
    т_мера lastpos = 0;
    for (т_мера i = 0; i < s.length; ++i)
    {
        // detect LF and CRLF
        const c = s[i];
        if (c == '\n' || (c == '\r' && i+1 < s.length && s[i+1] == '\n'))
        {
            ob.пишиСтр(s[lastpos .. i]);
            ob.нс();
            глоб2.парамы.mixinLines++;
            if (c == '\r')
                ++i;
            lastpos = i + 1;
        }
    }

    if(lastpos < s.length)
        ob.пишиСтр(s[lastpos .. $]);

    if (s.length == 0 || s[$-1] != '\n')
    {
        ob.нс(); // ensure empty line after expansion
        глоб2.парамы.mixinLines++;
    }
    ob.нс();
    глоб2.парамы.mixinLines++;

    return да;
}

/***********************************************************
 */
final class Parser(AST) : Lexer
{
    AST.ModuleDeclaration* md;
    alias AST.STC STC;

    private
    {
        AST.Module mod;
        LINK компонаж;
        CPPMANGLE cppmangle;
        Место endloc; // set to location of last right curly
        цел inBrackets; // inside [] of массив index or slice
        Место lookingForElse; // location of lonely if looking for an else
    }

    /*********************
     * Use this constructor for ткст mixins.
     * Input:
     *      место     location in source файл of mixin
     */
    this(ref Место место, AST.Module _module, ткст input, бул doDocComment)
    {
        super(_module ? _module.srcfile.вТкст0() : null, input.ptr, 0, input.length, doDocComment, нет);

        //printf("Parser::Parser()\n");
        scanloc = место;

        if (!writeMixin(input, scanloc) && место.имяф)
        {
            /* Create a pseudo-имяф for the mixin ткст, as it may not even exist
             * in the source файл.
             */
            ткст0 имяф = cast(сим*)mem.xmalloc(strlen(место.имяф) + 7 + (место.номстр).sizeof * 3 + 1);
            sprintf(имяф, "%s-mixin-%d", место.имяф, cast(цел)место.номстр);
            scanloc.имяф = имяф;
        }

        mod = _module;
        компонаж = LINK.d;
        //nextToken();              // start up the scanner
    }

    this(AST.Module _module, ткст input, бул doDocComment)
    {
        super(_module ? _module.srcfile.вТкст0() : null, input.ptr, 0, input.length, doDocComment, нет);

        //printf("Parser::Parser()\n");
        mod = _module;
        компонаж = LINK.d;
        //nextToken();              // start up the scanner
    }

    AST.Дсимволы* parseModule()
    {
        const коммент = token.blockComment;
        бул isdeprecated = нет;
        AST.Выражение msg = null;
        AST.Выражения* udas = null;
        AST.Дсимволы* decldefs;
        AST.ДСимвол lastDecl = mod; // for attaching ddoc unittests to module decl

        Сема2* tk;
        if (skipAttributes(&token, &tk) && tk.значение == ТОК2.module_)
        {
            while (token.значение != ТОК2.module_)
            {
                switch (token.значение)
                {
                case ТОК2.deprecated_:
                    {
                        // deprecated (...) module ...
                        if (isdeprecated)
                            выведиОшибку("на каждую декларацию модуля допустим только один атрибут деприкации");
                        isdeprecated = да;
                        nextToken();
                        if (token.значение == ТОК2.leftParentheses)
                        {
                            check(ТОК2.leftParentheses);
                            msg = parseAssignExp();
                            check(ТОК2.rightParentheses);
                        }
                        break;
                    }
                case ТОК2.at:
                    {
                        AST.Выражения* exps = null;
                        const stc = parseAttribute(&exps);
                        if (stc & atAttrGroup)
                        {
                            выведиОшибку("атрибут `@%s` для декларации модуля не поддерживается", token.вТкст0());
                        }
                        else
                        {
                            udas = AST.UserAttributeDeclaration.concat(udas, exps);
                        }
                        if (stc)
                            nextToken();
                        break;
                    }
                default:
                    {
                        выведиОшибку("`module` ожидалось вместо `%s`", token.вТкст0());
                        nextToken();
                        break;
                    }
                }
            }
        }

        if (udas)
        {
            auto a = new AST.Дсимволы();
            auto udad = new AST.UserAttributeDeclaration(udas, a);
            mod.userAttribDecl = udad;
        }

        // ModuleDeclation leads off
        if (token.значение == ТОК2.module_)
        {
            const место = token.место;

            nextToken();
            if (token.значение != ТОК2.идентификатор)
            {
                выведиОшибку("идентификатор ожидался после `module`");
                goto Lerr;
            }

            AST.Идентификаторы* a = null;
            Идентификатор2 ид = token.идент;

            while (nextToken() == ТОК2.dot)
            {
                if (!a)
                    a = new AST.Идентификаторы();
                a.сунь(ид);
                nextToken();
                if (token.значение != ТОК2.идентификатор)
                {
                    выведиОшибку("идентификатор ожидался после `package`");
                    goto Lerr;
                }
                ид = token.идент;
            }

            md = new AST.ModuleDeclaration(место, a, ид, msg, isdeprecated);

            if (token.значение != ТОК2.semicolon)
                выведиОшибку("`;` ожидалась после декларации модуля вместо `%s`", token.вТкст0());
            nextToken();
            добавьКоммент(mod, коммент);
        }

        decldefs = parseDeclDefs(0, &lastDecl);
        if (token.значение != ТОК2.endOfFile)
        {
            выведиОшибку(token.место, "нераспознанная декларация");
            goto Lerr;
        }
        return decldefs;

    Lerr:
        while (token.значение != ТОК2.semicolon && token.значение != ТОК2.endOfFile)
            nextToken();
        nextToken();
        return new AST.Дсимволы();
    }

    private КлассХранения parseDeprecatedAttribute(ref AST.Выражение msg)
    {
        if (peekNext() != ТОК2.leftParentheses)
            return STC.deprecated_;

        nextToken();
        check(ТОК2.leftParentheses);
        AST.Выражение e = parseAssignExp();
        check(ТОК2.rightParentheses);
        if (msg)
        {
            выведиОшибку("конфликтующие классы хранения `deprecated(%s)` и `deprecated(%s)`", msg.вТкст0(), e.вТкст0());
        }
        msg = e;
        return STC.undefined_;
    }

    AST.Дсимволы* parseDeclDefs(цел once, AST.ДСимвол* pLastDecl = null, PrefixAttributes!(AST)* pAttrs = null)
    {
        AST.ДСимвол lastDecl = null; // используется to link unittest to its previous declaration
        if (!pLastDecl)
            pLastDecl = &lastDecl;

        const linksave = компонаж; // save глоб2 state

        //printf("Parser::parseDeclDefs()\n");
        auto decldefs = new AST.Дсимволы();
        do
        {
            // parse результат
            AST.ДСимвол s = null;
            AST.Дсимволы* a = null;

            PrefixAttributes!(AST) attrs;
            if (!once || !pAttrs)
            {
                pAttrs = &attrs;
                pAttrs.коммент = token.blockComment.ptr;
            }
            AST.Prot.Kind prot;
            КлассХранения stc;
            AST.Condition условие;

            компонаж = linksave;

            switch (token.значение)
            {
            case ТОК2.enum_:
                {
                    /* Determine if this is a manifest constant declaration,
                     * or a conventional enum.
                     */
                    const tv = peekNext();
                    if (tv == ТОК2.leftCurly || tv == ТОК2.colon)
                        s = parseEnum();
                    else if (tv != ТОК2.идентификатор)
                        goto Ldeclaration;
                    else
                    {
                        const nextv = peekNext2();
                        if (nextv == ТОК2.leftCurly || nextv == ТОК2.colon || nextv == ТОК2.semicolon)
                            s = parseEnum();
                        else
                            goto Ldeclaration;
                    }
                    break;
                }
            case ТОК2.import_:
                a = parseImport();
                // keep pLastDecl
                break;

            case ТОК2.template_:
                s = cast(AST.ДСимвол)parseTemplateDeclaration();
                break;

            case ТОК2.mixin_:
                {
                    const место = token.место;
                    switch (peekNext())
                    {
                    case ТОК2.leftParentheses:
                        {
                            // mixin(ткст)
                            nextToken();
                            auto exps = parseArguments();
                            check(ТОК2.semicolon);
                            s = new AST.CompileDeclaration(место, exps);
                            break;
                        }
                    case ТОК2.template_:
                        // mixin template
                        nextToken();
                        s = cast(AST.ДСимвол)parseTemplateDeclaration(да);
                        break;

                    default:
                        s = parseMixin();
                        break;
                    }
                    break;
                }
            case ТОК2.wchar_:
            case ТОК2.dchar_:
            case ТОК2.бул_:
            case ТОК2.char_:
            case ТОК2.int8:
            case ТОК2.uns8:
            case ТОК2.int16:
            case ТОК2.uns16:
            case ТОК2.int32:
            case ТОК2.uns32:
            case ТОК2.int64:
            case ТОК2.uns64:
            case ТОК2.int128:
            case ТОК2.uns128:
            case ТОК2.float32:
            case ТОК2.float64:
            case ТОК2.float80:
            case ТОК2.imaginary32:
            case ТОК2.imaginary64:
            case ТОК2.imaginary80:
            case ТОК2.complex32:
            case ТОК2.complex64:
            case ТОК2.complex80:
            case ТОК2.void_:
            case ТОК2.alias_:
            case ТОК2.идентификатор:
            case ТОК2.super_:
            case ТОК2.typeof_:
            case ТОК2.dot:
            case ТОК2.vector:
            case ТОК2.struct_:
            case ТОК2.union_:
            case ТОК2.class_:
            case ТОК2.interface_:
            case ТОК2.traits:
            Ldeclaration:
                a = parseDeclarations(нет, pAttrs, pAttrs.коммент);
                if (a && a.dim)
                    *pLastDecl = (*a)[a.dim - 1];
                break;

            case ТОК2.this_:
                if (peekNext() == ТОК2.dot)
                    goto Ldeclaration;
                s = parseCtor(pAttrs);
                break;

            case ТОК2.tilde:
                s = parseDtor(pAttrs);
                break;

            case ТОК2.invariant_:
                const tv = peekNext();
                if (tv == ТОК2.leftParentheses || tv == ТОК2.leftCurly)
                {
                    // invariant { statements... }
                    // invariant() { statements... }
                    // invariant (Выражение);
                    s = parseInvariant(pAttrs);
                    break;
                }
                выведиОшибку("ожидалось тело инварианта, а не `%s`", token.вТкст0());
                goto Lerror;

            case ТОК2.unittest_:
                if (глоб2.парамы.useUnitTests || глоб2.парамы.doDocComments || глоб2.парамы.doHdrGeneration)
                {
                    s = parseUnitTest(pAttrs);
                    if (*pLastDecl)
                        (*pLastDecl).ddocUnittest = cast(AST.UnitTestDeclaration)s;
                }
                else
                {
                    // Skip over unittest block by counting { }
                    Место место = token.место;
                    цел braces = 0;
                    while (1)
                    {
                        nextToken();
                        switch (token.значение)
                        {
                        case ТОК2.leftCurly:
                            ++braces;
                            continue;

                        case ТОК2.rightCurly:
                            if (--braces)
                                continue;
                            nextToken();
                            break;

                        case ТОК2.endOfFile:
                            /* { */
                            выведиОшибку(место, "закрывающая `}` для unittest до конца файла не найдена");
                            goto Lerror;

                        default:
                            continue;
                        }
                        break;
                    }
                    // Workaround 14894. Add an empty unittest declaration to keep
                    // the number of symbols in this scope independent of -unittest.
                    s = new AST.UnitTestDeclaration(место, token.место, STC.undefined_, null);
                }
                break;

            case ТОК2.new_:
                s = parseNew(pAttrs);
                break;

            case ТОК2.colon:
            case ТОК2.leftCurly:
                выведиОшибку("ожидалась декларация, а не `%s`", token.вТкст0());
                goto Lerror;

            case ТОК2.rightCurly:
            case ТОК2.endOfFile:
                if (once)
                    выведиОшибку("ожидалась декларация, а не `%s`", token.вТкст0());
                return decldefs;

            case ТОК2.static_:
                {
                    const следщ = peekNext();
                    if (следщ == ТОК2.this_)
                        s = parseStaticCtor(pAttrs);
                    else if (следщ == ТОК2.tilde)
                        s = parseStaticDtor(pAttrs);
                    else if (следщ == ТОК2.assert_)
                        s = parseStaticAssert();
                    else if (следщ == ТОК2.if_)
                    {
                        условие = parseStaticIfCondition();
                        AST.Дсимволы* athen;
                        if (token.значение == ТОК2.colon)
                            athen = parseBlock(pLastDecl);
                        else
                        {
                            const lookingForElseSave = lookingForElse;
                            lookingForElse = token.место;
                            athen = parseBlock(pLastDecl);
                            lookingForElse = lookingForElseSave;
                        }
                        AST.Дсимволы* aelse = null;
                        if (token.значение == ТОК2.else_)
                        {
                            const elseloc = token.место;
                            nextToken();
                            aelse = parseBlock(pLastDecl);
                            checkDanglingElse(elseloc);
                        }
                        s = new AST.StaticIfDeclaration(условие, athen, aelse);
                    }
                    else if (следщ == ТОК2.import_)
                    {
                        a = parseImport();
                        // keep pLastDecl
                    }
                    else if (следщ == ТОК2.foreach_ || следщ == ТОК2.foreach_reverse_)
                    {
                        s = parseForeach!(да,да)(token.место, pLastDecl);
                    }
                    else
                    {
                        stc = STC.static_;
                        goto Lstc;
                    }
                    break;
                }
            case ТОК2.const_:
                if (peekNext() == ТОК2.leftParentheses)
                    goto Ldeclaration;
                stc = STC.const_;
                goto Lstc;

            case ТОК2.immutable_:
                if (peekNext() == ТОК2.leftParentheses)
                    goto Ldeclaration;
                stc = STC.immutable_;
                goto Lstc;

            case ТОК2.shared_:
                {
                    const следщ = peekNext();
                    if (следщ == ТОК2.leftParentheses)
                        goto Ldeclaration;
                    if (следщ == ТОК2.static_)
                    {
                        ТОК2 next2 = peekNext2();
                        if (next2 == ТОК2.this_)
                        {
                            s = parseSharedStaticCtor(pAttrs);
                            break;
                        }
                        if (next2 == ТОК2.tilde)
                        {
                            s = parseSharedStaticDtor(pAttrs);
                            break;
                        }
                    }
                    stc = STC.shared_;
                    goto Lstc;
                }
            case ТОК2.inout_:
                if (peekNext() == ТОК2.leftParentheses)
                    goto Ldeclaration;
                stc = STC.wild;
                goto Lstc;

            case ТОК2.final_:
                stc = STC.final_;
                goto Lstc;

            case ТОК2.auto_:
                stc = STC.auto_;
                goto Lstc;

            case ТОК2.scope_:
                stc = STC.scope_;
                goto Lstc;

            case ТОК2.override_:
                stc = STC.override_;
                goto Lstc;

            case ТОК2.abstract_:
                stc = STC.abstract_;
                goto Lstc;

            case ТОК2.synchronized_:
                stc = STC.synchronized_;
                goto Lstc;

            case ТОК2.nothrow_:
                stc = STC.nothrow_;
                goto Lstc;

            case ТОК2.pure_:
                stc = STC.pure_;
                goto Lstc;

            case ТОК2.ref_:
                stc = STC.ref_;
                goto Lstc;

            case ТОК2.gshared:
                stc = STC.gshared;
                goto Lstc;

            case ТОК2.at:
                {
                    AST.Выражения* exps = null;
                    stc = parseAttribute(&exps);
                    if (stc)
                        goto Lstc; // it's a predefined attribute
                    // no redundant/conflicting check for UDAs
                    pAttrs.udas = AST.UserAttributeDeclaration.concat(pAttrs.udas, exps);
                    goto Lautodecl;
                }
            Lstc:
                pAttrs.классХранения = appendStorageClass(pAttrs.классХранения, stc);
                nextToken();

            Lautodecl:

                /* Look for auto initializers:
                 *      класс_хранения идентификатор = инициализатор;
                 *      класс_хранения идентификатор(...) = инициализатор;
                 */
                if (token.значение == ТОК2.идентификатор && hasOptionalParensThen(peek(&token), ТОК2.assign))
                {
                    a = parseAutoDeclarations(getStorageClass!(AST)(pAttrs), pAttrs.коммент);
                    if (a && a.dim)
                        *pLastDecl = (*a)[a.dim - 1];
                    if (pAttrs.udas)
                    {
                        s = new AST.UserAttributeDeclaration(pAttrs.udas, a);
                        pAttrs.udas = null;
                    }
                    break;
                }

                /* Look for return тип inference for template functions.
                 */
                Сема2* tk;
                if (token.значение == ТОК2.идентификатор && skipParens(peek(&token), &tk) && skipAttributes(tk, &tk) &&
                    (tk.значение == ТОК2.leftParentheses || tk.значение == ТОК2.leftCurly || tk.значение == ТОК2.in_ ||
                     tk.значение == ТОК2.out_ || tk.значение == ТОК2.do_ ||
                     tk.значение == ТОК2.идентификатор && tk.идент == Id._body))
                {
                    version (none)
                    {
                        // This deprecation has been disabled for the time being, see PR10763
                        // @@@DEPRECATED@@@
                        // https://github.com/dlang/DIPs/blob/1f5959abe482b1f9094f6484a7d0a3ade77fc2fc/DIPs/accepted/DIP1003.md
                        // Deprecated in 2.091 - Can be removed from 2.101
                        if (tk.значение == ТОК2.идентификатор && tk.идент == Id._body)
                            deprecation("Использование ключевого слова `body` депрекировано. Вместо него используется `do`.");
                    }
                    a = parseDeclarations(да, pAttrs, pAttrs.коммент);
                    if (a && a.dim)
                        *pLastDecl = (*a)[a.dim - 1];
                    if (pAttrs.udas)
                    {
                        s = new AST.UserAttributeDeclaration(pAttrs.udas, a);
                        pAttrs.udas = null;
                    }
                    break;
                }

                a = parseBlock(pLastDecl, pAttrs);
                auto stc2 = getStorageClass!(AST)(pAttrs);
                if (stc2 != STC.undefined_)
                {
                    s = new AST.StorageClassDeclaration(stc2, a);
                }
                if (pAttrs.udas)
                {
                    if (s)
                    {
                        a = new AST.Дсимволы();
                        a.сунь(s);
                    }
                    s = new AST.UserAttributeDeclaration(pAttrs.udas, a);
                    pAttrs.udas = null;
                }
                break;

            case ТОК2.deprecated_:
                {
                    if (КлассХранения _stc = parseDeprecatedAttribute(pAttrs.depmsg))
                    {
                        stc = _stc;
                        goto Lstc;
                    }
                    a = parseBlock(pLastDecl, pAttrs);
                    if (pAttrs.depmsg)
                    {
                        s = new AST.DeprecatedDeclaration(pAttrs.depmsg, a);
                        pAttrs.depmsg = null;
                    }
                    break;
                }
            case ТОК2.leftBracket:
                {
                    if (peekNext() == ТОК2.rightBracket)
                        выведиОшибку("не допускается пустой список атрибутов");
                    выведиОшибку("используем `@(attributes)` вместо `[attributes]`");
                    AST.Выражения* exps = parseArguments();
                    // no redundant/conflicting check for UDAs

                    pAttrs.udas = AST.UserAttributeDeclaration.concat(pAttrs.udas, exps);
                    a = parseBlock(pLastDecl, pAttrs);
                    if (pAttrs.udas)
                    {
                        s = new AST.UserAttributeDeclaration(pAttrs.udas, a);
                        pAttrs.udas = null;
                    }
                    break;
                }
            case ТОК2.extern_:
                {
                    if (peekNext() != ТОК2.leftParentheses)
                    {
                        stc = STC.extern_;
                        goto Lstc;
                    }

                    const linkLoc = token.место;
                    AST.Идентификаторы* idents = null;
                    AST.Выражения* identExps = null;
                    CPPMANGLE cppmangle;
                    бул cppMangleOnly = нет;
                    const link = parseLinkage(&idents, &identExps, cppmangle, cppMangleOnly);
                    if (pAttrs.link != LINK.default_)
                    {
                        if (pAttrs.link != link)
                        {
                            выведиОшибку("конфликтующая компоновка `extern (%s)` и `extern (%s)`", AST.компонажВТкст0(pAttrs.link), AST.компонажВТкст0(link));
                        }
                        else if (idents || identExps || cppmangle != CPPMANGLE.def)
                        {
                            // Allow:
                            //      extern(C++, foo) extern(C++, bar) проц foo();
                            // to be equivalent with:
                            //      extern(C++, foo.bar) проц foo();
                            // Allow also:
                            //      extern(C++, "ns") extern(C++, class) struct test {}
                            //      extern(C++, class) extern(C++, "ns") struct test {}
                        }
                        else
                            выведиОшибку("вторящаяся компоновка `extern (%s)`", AST.компонажВТкст0(pAttrs.link));
                    }
                    pAttrs.link = link;
                    this.компонаж = link;
                    a = parseBlock(pLastDecl, pAttrs);
                    if (idents)
                    {
                        assert(link == LINK.cpp);
                        assert(idents.dim);
                        for (т_мера i = idents.dim; i;)
                        {
                            Идентификатор2 ид = (*idents)[--i];
                            if (s)
                            {
                                a = new AST.Дсимволы();
                                a.сунь(s);
                            }
                            if (cppMangleOnly)
                                s = new AST.CPPNamespaceDeclaration(ид, a);
                            else
                                s = new AST.Nspace(linkLoc, ид, null, a);
                        }
                        pAttrs.link = LINK.default_;
                    }
                    else if (identExps)
                    {
                        assert(link == LINK.cpp);
                        assert(identExps.dim);
                        for (т_мера i = identExps.dim; i;)
                        {
                            AST.Выражение exp = (*identExps)[--i];
                            if (s)
                            {
                                a = new AST.Дсимволы();
                                a.сунь(s);
                            }
                            if (cppMangleOnly)
                                s = new AST.CPPNamespaceDeclaration(exp, a);
                            else
                                s = new AST.Nspace(linkLoc, null, exp, a);
                        }
                        pAttrs.link = LINK.default_;
                    }
                    else if (cppmangle != CPPMANGLE.def)
                    {
                        assert(link == LINK.cpp);
                        s = new AST.CPPMangleDeclaration(cppmangle, a);
                    }
                    else if (pAttrs.link != LINK.default_)
                    {
                        s = new AST.LinkDeclaration(pAttrs.link, a);
                        pAttrs.link = LINK.default_;
                    }
                    break;
                }

            case ТОК2.private_:
                prot = AST.Prot.Kind.private_;
                goto Lprot;

            case ТОК2.package_:
                prot = AST.Prot.Kind.package_;
                goto Lprot;

            case ТОК2.protected_:
                prot = AST.Prot.Kind.protected_;
                goto Lprot;

            case ТОК2.public_:
                prot = AST.Prot.Kind.public_;
                goto Lprot;

            case ТОК2.export_:
                prot = AST.Prot.Kind.export_;
                goto Lprot;
            Lprot:
                {
                    if (pAttrs.защита.вид != AST.Prot.Kind.undefined)
                    {
                        if (pAttrs.защита.вид != prot)
                            выведиОшибку("конфликтующие атрибуты защиты `%s` и `%s`", AST.защитуВТкст0(pAttrs.защита.вид), AST.защитуВТкст0(prot));
                        else
                            выведиОшибку("вторящийся атрибут защиты `%s`", AST.защитуВТкст0(prot));
                    }
                    pAttrs.защита.вид = prot;

                    nextToken();

                    // optional qualified package идентификатор to bind
                    // защита to
                    AST.Идентификаторы* pkg_prot_idents = null;
                    if (pAttrs.защита.вид == AST.Prot.Kind.package_ && token.значение == ТОК2.leftParentheses)
                    {
                        pkg_prot_idents = parseQualifiedIdentifier("защита package");
                        if (pkg_prot_idents)
                            check(ТОК2.rightParentheses);
                        else
                        {
                            while (token.значение != ТОК2.semicolon && token.значение != ТОК2.endOfFile)
                                nextToken();
                            nextToken();
                            break;
                        }
                    }

                    const attrloc = token.место;
                    a = parseBlock(pLastDecl, pAttrs);
                    if (pAttrs.защита.вид != AST.Prot.Kind.undefined)
                    {
                        if (pAttrs.защита.вид == AST.Prot.Kind.package_ && pkg_prot_idents)
                            s = new AST.ProtDeclaration(attrloc, pkg_prot_idents, a);
                        else
                            s = new AST.ProtDeclaration(attrloc, pAttrs.защита, a);

                        pAttrs.защита = AST.Prot(AST.Prot.Kind.undefined);
                    }
                    break;
                }
            case ТОК2.align_:
                {
                    const attrLoc = token.место;

                    nextToken();

                    AST.Выражение e = null; // default
                    if (token.значение == ТОК2.leftParentheses)
                    {
                        nextToken();
                        e = parseAssignExp();
                        check(ТОК2.rightParentheses);
                    }

                    if (pAttrs.setAlignment)
                    {
                        if (e)
                            выведиОшибку("redundant alignment attribute `align(%s)`", e.вТкст0());
                        else
                            выведиОшибку("redundant alignment attribute `align`");
                    }

                    pAttrs.setAlignment = да;
                    pAttrs.ealign = e;
                    a = parseBlock(pLastDecl, pAttrs);
                    if (pAttrs.setAlignment)
                    {
                        s = new AST.AlignDeclaration(attrLoc, pAttrs.ealign, a);
                        pAttrs.setAlignment = нет;
                        pAttrs.ealign = null;
                    }
                    break;
                }
            case ТОК2.pragma_:
                {
                    AST.Выражения* args = null;
                    const место = token.место;

                    nextToken();
                    check(ТОК2.leftParentheses);
                    if (token.значение != ТОК2.идентификатор)
                    {
                        выведиОшибку("ожидалось `pragma(идентификатор)`");
                        goto Lerror;
                    }
                    Идентификатор2 идент = token.идент;
                    nextToken();
                    if (token.значение == ТОК2.comma && peekNext() != ТОК2.rightParentheses)
                        args = parseArguments(); // pragma(идентификатор, args...)
                    else
                        check(ТОК2.rightParentheses); // pragma(идентификатор)

                    AST.Дсимволы* a2 = null;
                    if (token.значение == ТОК2.semicolon)
                    {
                        /* https://issues.dlang.org/show_bug.cgi?ид=2354
                         * Accept single semicolon as an empty
                         * DeclarationBlock following attribute.
                         *
                         * Attribute DeclarationBlock
                         * Pragma    DeclDef
                         *           ;
                         */
                        nextToken();
                    }
                    else
                        a2 = parseBlock(pLastDecl);
                    s = new AST.PragmaDeclaration(место, идент, args, a2);
                    break;
                }
            case ТОК2.debug_:
                nextToken();
                if (token.значение == ТОК2.assign)
                {
                    nextToken();
                    if (token.значение == ТОК2.идентификатор)
                        s = new AST.DebugSymbol(token.место, token.идент);
                    else if (token.значение == ТОК2.int32Literal || token.значение == ТОК2.int64Literal)
                        s = new AST.DebugSymbol(token.место, cast(бцел)token.unsvalue);
                    else
                    {
                        выведиОшибку("идентификатор or integer expected, not `%s`", token.вТкст0());
                        s = null;
                    }
                    nextToken();
                    if (token.значение != ТОК2.semicolon)
                        выведиОшибку("semicolon expected");
                    nextToken();
                    break;
                }

                условие = parseDebugCondition();
                goto Lcondition;

            case ТОК2.version_:
                nextToken();
                if (token.значение == ТОК2.assign)
                {
                    nextToken();
                    if (token.значение == ТОК2.идентификатор)
                        s = new AST.VersionSymbol(token.место, token.идент);
                    else if (token.значение == ТОК2.int32Literal || token.значение == ТОК2.int64Literal)
                        s = new AST.VersionSymbol(token.место, cast(бцел)token.unsvalue);
                    else
                    {
                        выведиОшибку("идентификатор or integer expected, not `%s`", token.вТкст0());
                        s = null;
                    }
                    nextToken();
                    if (token.значение != ТОК2.semicolon)
                        выведиОшибку("semicolon expected");
                    nextToken();
                    break;
                }
                условие = parseVersionCondition();
                goto Lcondition;

            Lcondition:
                {
                    AST.Дсимволы* athen;
                    if (token.значение == ТОК2.colon)
                        athen = parseBlock(pLastDecl);
                    else
                    {
                        const lookingForElseSave = lookingForElse;
                        lookingForElse = token.место;
                        athen = parseBlock(pLastDecl);
                        lookingForElse = lookingForElseSave;
                    }
                    AST.Дсимволы* aelse = null;
                    if (token.значение == ТОК2.else_)
                    {
                        const elseloc = token.место;
                        nextToken();
                        aelse = parseBlock(pLastDecl);
                        checkDanglingElse(elseloc);
                    }
                    s = new AST.ConditionalDeclaration(условие, athen, aelse);
                    break;
                }
            case ТОК2.semicolon:
                // empty declaration
                //выведиОшибку("empty declaration");
                nextToken();
                continue;

            default:
                выведиОшибку("declaration expected, not `%s`", token.вТкст0());
            Lerror:
                while (token.значение != ТОК2.semicolon && token.значение != ТОК2.endOfFile)
                    nextToken();
                nextToken();
                s = null;
                continue;
            }

            if (s)
            {
                if (!s.isAttribDeclaration())
                    *pLastDecl = s;
                decldefs.сунь(s);
                добавьКоммент(s, pAttrs.коммент);
            }
            else if (a && a.dim)
            {
                decldefs.приставь(a);
            }
        }
        while (!once);

        компонаж = linksave;

        return decldefs;
    }

    /*****************************************
     * Parse auto declarations of the form:
     *   классХранения идент = init, идент = init, ... ;
     * and return the массив of them.
     * Starts with token on the first идент.
     * Ends with scanner past closing ';'
     */
    private AST.Дсимволы* parseAutoDeclarations(КлассХранения классХранения, ткст0 коммент)
    {
        //printf("parseAutoDeclarations\n");
        auto a = new AST.Дсимволы();

        while (1)
        {
            const место = token.место;
            Идентификатор2 идент = token.идент;
            nextToken(); // skip over идент

            AST.ПараметрыШаблона* tpl = null;
            if (token.значение == ТОК2.leftParentheses)
                tpl = parseTemplateParameterList();

            check(ТОК2.assign);   // skip over '='
            AST.Инициализатор _иниц = parseInitializer();
            auto v = new AST.VarDeclaration(место, null, идент, _иниц, классХранения);

            AST.ДСимвол s = v;
            if (tpl)
            {
                auto a2 = new AST.Дсимволы();
                a2.сунь(v);
                auto tempdecl = new AST.TemplateDeclaration(место, идент, tpl, null, a2, 0);
                s = tempdecl;
            }
            a.сунь(s);
            switch (token.значение)
            {
            case ТОК2.semicolon:
                nextToken();
                добавьКоммент(s, коммент);
                break;

            case ТОК2.comma:
                nextToken();
                if (!(token.значение == ТОК2.идентификатор && hasOptionalParensThen(peek(&token), ТОК2.assign)))
                {
                    выведиОшибку("идентификатор expected following comma");
                    break;
                }
                добавьКоммент(s, коммент);
                continue;

            default:
                выведиОшибку("semicolon expected following auto declaration, not `%s`", token.вТкст0());
                break;
            }
            break;
        }
        return a;
    }

    /********************************************
     * Parse declarations after an align, защита, or extern decl.
     */
    private AST.Дсимволы* parseBlock(AST.ДСимвол* pLastDecl, PrefixAttributes!(AST)* pAttrs = null)
    {
        AST.Дсимволы* a = null;

        //printf("parseBlock()\n");
        switch (token.значение)
        {
        case ТОК2.semicolon:
            выведиОшибку("declaration expected following attribute, not `;`");
            nextToken();
            break;

        case ТОК2.endOfFile:
            выведиОшибку("declaration expected following attribute, not end of файл");
            break;

        case ТОК2.leftCurly:
            {
                const lookingForElseSave = lookingForElse;
                lookingForElse = Место();

                nextToken();
                a = parseDeclDefs(0, pLastDecl);
                if (token.значение != ТОК2.rightCurly)
                {
                    /* { */
                    выведиОшибку("matching `}` expected, not `%s`", token.вТкст0());
                }
                else
                    nextToken();
                lookingForElse = lookingForElseSave;
                break;
            }
        case ТОК2.colon:
            nextToken();
            a = parseDeclDefs(0, pLastDecl); // grab declarations up to closing curly bracket
            break;

        default:
            a = parseDeclDefs(1, pLastDecl, pAttrs);
            break;
        }
        return a;
    }

    /*********************************************
     * Give error on redundant/conflicting storage class.
     */
    private КлассХранения appendStorageClass(КлассХранения классХранения, КлассХранения stc)
    {
        if ((классХранения & stc) || (классХранения & STC.in_ && stc & (STC.const_ | STC.scope_)) || (stc & STC.in_ && классХранения & (STC.const_ | STC.scope_)))
        {
            БуфВыв буф;
            AST.stcToBuffer(&буф, stc);
            выведиОшибку("redundant attribute `%s`", буф.peekChars());
            return классХранения | stc;
        }

        классХранения |= stc;

        if (stc & (STC.const_ | STC.immutable_ | STC.manifest))
        {
            КлассХранения u = классХранения & (STC.const_ | STC.immutable_ | STC.manifest);
            if (u & (u - 1))
                выведиОшибку("conflicting attribute `%s`", Сема2.вТкст0(token.значение));
        }
        if (stc & (STC.gshared | STC.shared_ | STC.tls))
        {
            КлассХранения u = классХранения & (STC.gshared | STC.shared_ | STC.tls);
            if (u & (u - 1))
                выведиОшибку("conflicting attribute `%s`", Сема2.вТкст0(token.значение));
        }
        if (stc & STC.safeGroup)
        {
            КлассХранения u = классХранения & STC.safeGroup;
            if (u & (u - 1))
                выведиОшибку("conflicting attribute `@%s`", token.вТкст0());
        }

        return классХранения;
    }

    /***********************************************
     * Parse attribute, lexer is on '@'.
     * Input:
     *      pudas           массив of UDAs to приставь to
     * Возвращает:
     *      storage class   if a predefined attribute; also scanner remains on идентификатор.
     *      0               if not a predefined attribute
     *      *pudas          set if user defined attribute, scanner is past UDA
     *      *pudas          NULL if not a user defined attribute
     */
    private КлассХранения parseAttribute(AST.Выражения** pudas)
    {
        nextToken();
        AST.Выражения* udas = null;
        КлассХранения stc = 0;
        if (token.значение == ТОК2.идентификатор)
        {
            stc = isBuiltinAtAttribute(token.идент);
            if (!stc)
            {
                // Allow идентификатор, template instantiation, or function call
                AST.Выражение exp = parsePrimaryExp();
                if (token.значение == ТОК2.leftParentheses)
                {
                    const место = token.место;
                    exp = new AST.CallExp(место, exp, parseArguments());
                }

                udas = new AST.Выражения();
                udas.сунь(exp);
            }
        }
        else if (token.значение == ТОК2.leftParentheses)
        {
            // @( ArgumentList )
            // Concatenate with existing
            if (peekNext() == ТОК2.rightParentheses)
                выведиОшибку("empty attribute list is not allowed");
            udas = parseArguments();
        }
        else
        {
            выведиОшибку("@идентификатор or @(ArgumentList) expected, not `@%s`", token.вТкст0());
        }

        if (stc)
        {
        }
        else if (udas)
        {
            *pudas = AST.UserAttributeDeclaration.concat(*pudas, udas);
        }
        else
            выведиОшибку("valid attributes are ``, ``, `@trusted`, `@system`, `@disable`, ``");
        return stc;
    }

    /***********************************************
     * Parse const/const/shared/inout// postfix
     */
    private КлассХранения parsePostfix(КлассХранения классХранения, AST.Выражения** pudas)
    {
        while (1)
        {
            КлассХранения stc;
            switch (token.значение)
            {
            case ТОК2.const_:
                stc = STC.const_;
                break;

            case ТОК2.immutable_:
                stc = STC.immutable_;
                break;

            case ТОК2.shared_:
                stc = STC.shared_;
                break;

            case ТОК2.inout_:
                stc = STC.wild;
                break;

            case ТОК2.nothrow_:
                stc = STC.nothrow_;
                break;

            case ТОК2.pure_:
                stc = STC.pure_;
                break;

            case ТОК2.return_:
                stc = STC.return_;
                break;

            case ТОК2.scope_:
                stc = STC.scope_;
                break;

            case ТОК2.at:
                {
                    AST.Выражения* udas = null;
                    stc = parseAttribute(&udas);
                    if (udas)
                    {
                        if (pudas)
                            *pudas = AST.UserAttributeDeclaration.concat(*pudas, udas);
                        else
                        {
                            // Disallow:
                            //      проц function() @uda fp;
                            //      () @uda { return 1; }
                            выведиОшибку("user-defined attributes cannot appear as postfixes");
                        }
                        continue;
                    }
                    break;
                }
            default:
                return классХранения;
            }
            классХранения = appendStorageClass(классХранения, stc);
            nextToken();
        }
    }

    private КлассХранения parseTypeCtor()
    {
        КлассХранения классХранения = STC.undefined_;

        while (1)
        {
            if (peekNext() == ТОК2.leftParentheses)
                return классХранения;

            КлассХранения stc;
            switch (token.значение)
            {
            case ТОК2.const_:
                stc = STC.const_;
                break;

            case ТОК2.immutable_:
                stc = STC.immutable_;
                break;

            case ТОК2.shared_:
                stc = STC.shared_;
                break;

            case ТОК2.inout_:
                stc = STC.wild;
                break;

            default:
                return классХранения;
            }
            классХранения = appendStorageClass(классХранения, stc);
            nextToken();
        }
    }

    /**************************************
     * Parse constraint.
     * Constraint is of the form:
     *      if ( ConstraintВыражение )
     */
    private AST.Выражение parseConstraint()
    {
        AST.Выражение e = null;
        if (token.значение == ТОК2.if_)
        {
            nextToken(); // skip over 'if'
            check(ТОК2.leftParentheses);
            e = parseВыражение();
            check(ТОК2.rightParentheses);
        }
        return e;
    }

    /**************************************
     * Parse a TemplateDeclaration.
     */
    private AST.TemplateDeclaration parseTemplateDeclaration(бул ismixin = нет)
    {
        AST.TemplateDeclaration tempdecl;
        Идентификатор2 ид;
        AST.ПараметрыШаблона* tpl;
        AST.Дсимволы* decldefs;
        AST.Выражение constraint = null;
        const место = token.место;

        nextToken();
        if (token.значение != ТОК2.идентификатор)
        {
            выведиОшибку("идентификатор expected following `template`");
            goto Lerr;
        }
        ид = token.идент;
        nextToken();
        tpl = parseTemplateParameterList();
        if (!tpl)
            goto Lerr;

        constraint = parseConstraint();

        if (token.значение != ТОК2.leftCurly)
        {
            выведиОшибку("члены of template declaration expected");
            goto Lerr;
        }
        decldefs = parseBlock(null);

        tempdecl = new AST.TemplateDeclaration(место, ид, tpl, constraint, decldefs, ismixin);
        return tempdecl;

    Lerr:
        return null;
    }

    /******************************************
     * Parse template параметр list.
     * Input:
     *      флаг    0: parsing "( list )"
     *              1: parsing non-empty "list $(RPAREN)"
     */
    private AST.ПараметрыШаблона* parseTemplateParameterList(цел флаг = 0)
    {
        auto tpl = new AST.ПараметрыШаблона();

        if (!флаг && token.значение != ТОК2.leftParentheses)
        {
            выведиОшибку("parenthesized template параметр list expected following template идентификатор");
            goto Lerr;
        }
        nextToken();

        // Get массив of ПараметрыШаблона
        if (флаг || token.значение != ТОК2.rightParentheses)
        {
            цел isvariadic = 0;
            while (token.значение != ТОК2.rightParentheses)
            {
                AST.ПараметрШаблона2 tp;
                Место место;
                Идентификатор2 tp_ident = null;
                AST.Тип tp_spectype = null;
                AST.Тип tp_valtype = null;
                AST.Тип tp_defaulttype = null;
                AST.Выражение tp_specvalue = null;
                AST.Выражение tp_defaultvalue = null;

                // Get ПараметрШаблона2

                // First, look ahead to see if it is a TypeParameter or a ValueParameter
                const tv = peekNext();
                if (token.значение == ТОК2.alias_)
                {
                    // AliasParameter
                    nextToken();
                    место = token.место; // todo
                    AST.Тип spectype = null;
                    if (isDeclaration(&token, NeedDeclaratorId.must, ТОК2.reserved, null))
                    {
                        spectype = parseType(&tp_ident);
                    }
                    else
                    {
                        if (token.значение != ТОК2.идентификатор)
                        {
                            выведиОшибку("идентификатор expected for template alias параметр");
                            goto Lerr;
                        }
                        tp_ident = token.идент;
                        nextToken();
                    }
                    КорневойОбъект spec = null;
                    if (token.значение == ТОК2.colon) // : Тип
                    {
                        nextToken();
                        if (isDeclaration(&token, NeedDeclaratorId.no, ТОК2.reserved, null))
                            spec = parseType();
                        else
                            spec = parseCondExp();
                    }
                    КорневойОбъект def = null;
                    if (token.значение == ТОК2.assign) // = Тип
                    {
                        nextToken();
                        if (isDeclaration(&token, NeedDeclaratorId.no, ТОК2.reserved, null))
                            def = parseType();
                        else
                            def = parseCondExp();
                    }
                    tp = new AST.TemplateAliasParameter(место, tp_ident, spectype, spec, def);
                }
                else if (tv == ТОК2.colon || tv == ТОК2.assign || tv == ТОК2.comma || tv == ТОК2.rightParentheses)
                {
                    // TypeParameter
                    if (token.значение != ТОК2.идентификатор)
                    {
                        выведиОшибку("идентификатор expected for template тип параметр");
                        goto Lerr;
                    }
                    место = token.место;
                    tp_ident = token.идент;
                    nextToken();
                    if (token.значение == ТОК2.colon) // : Тип
                    {
                        nextToken();
                        tp_spectype = parseType();
                    }
                    if (token.значение == ТОК2.assign) // = Тип
                    {
                        nextToken();
                        tp_defaulttype = parseType();
                    }
                    tp = new AST.TemplateTypeParameter(место, tp_ident, tp_spectype, tp_defaulttype);
                }
                else if (token.значение == ТОК2.идентификатор && tv == ТОК2.dotDotDot)
                {
                    // идент...
                    if (isvariadic)
                        выведиОшибку("variadic template параметр must be last");
                    isvariadic = 1;
                    место = token.место;
                    tp_ident = token.идент;
                    nextToken();
                    nextToken();
                    tp = new AST.TemplateTupleParameter(место, tp_ident);
                }
                else if (token.значение == ТОК2.this_)
                {
                    // ThisParameter
                    nextToken();
                    if (token.значение != ТОК2.идентификатор)
                    {
                        выведиОшибку("идентификатор expected for template this параметр");
                        goto Lerr;
                    }
                    место = token.место;
                    tp_ident = token.идент;
                    nextToken();
                    if (token.значение == ТОК2.colon) // : Тип
                    {
                        nextToken();
                        tp_spectype = parseType();
                    }
                    if (token.значение == ТОК2.assign) // = Тип
                    {
                        nextToken();
                        tp_defaulttype = parseType();
                    }
                    tp = new AST.TemplateThisParameter(место, tp_ident, tp_spectype, tp_defaulttype);
                }
                else
                {
                    // ValueParameter
                    место = token.место; // todo
                    tp_valtype = parseType(&tp_ident);
                    if (!tp_ident)
                    {
                        выведиОшибку("идентификатор expected for template значение параметр");
                        tp_ident = Идентификатор2.idPool("error");
                    }
                    if (token.значение == ТОК2.colon) // : CondВыражение
                    {
                        nextToken();
                        tp_specvalue = parseCondExp();
                    }
                    if (token.значение == ТОК2.assign) // = CondВыражение
                    {
                        nextToken();
                        tp_defaultvalue = parseDefaultInitExp();
                    }
                    tp = new AST.TemplateValueParameter(место, tp_ident, tp_valtype, tp_specvalue, tp_defaultvalue);
                }
                tpl.сунь(tp);
                if (token.значение != ТОК2.comma)
                    break;
                nextToken();
            }
        }
        check(ТОК2.rightParentheses);

    Lerr:
        return tpl;
    }

    /******************************************
     * Parse template mixin.
     *      mixin Foo;
     *      mixin Foo!(args);
     *      mixin a.b.c!(args).Foo!(args);
     *      mixin Foo!(args) идентификатор;
     *      mixin typeof(expr).идентификатор!(args);
     */
    private AST.ДСимвол parseMixin()
    {
        AST.TemplateMixin tm;
        Идентификатор2 ид;
        AST.Объекты* tiargs;

        //printf("parseMixin()\n");
        const locMixin = token.место;
        nextToken(); // skip 'mixin'

        auto место = token.место;
        AST.TypeQualified tqual = null;
        if (token.значение == ТОК2.dot)
        {
            ид = Id.empty;
        }
        else
        {
            if (token.значение == ТОК2.typeof_)
            {
                tqual = parseTypeof();
                check(ТОК2.dot);
            }
            if (token.значение != ТОК2.идентификатор)
            {
                выведиОшибку("идентификатор expected, not `%s`", token.вТкст0());
                ид = Id.empty;
            }
            else
                ид = token.идент;
            nextToken();
        }

        while (1)
        {
            tiargs = null;
            if (token.значение == ТОК2.not)
            {
                tiargs = parseTemplateArguments();
            }

            if (tiargs && token.значение == ТОК2.dot)
            {
                auto tempinst = new AST.TemplateInstance(место, ид, tiargs);
                if (!tqual)
                    tqual = new AST.TypeInstance(место, tempinst);
                else
                    tqual.addInst(tempinst);
                tiargs = null;
            }
            else
            {
                if (!tqual)
                    tqual = new AST.TypeIdentifier(место, ид);
                else
                    tqual.addIdent(ид);
            }

            if (token.значение != ТОК2.dot)
                break;

            nextToken();
            if (token.значение != ТОК2.идентификатор)
            {
                выведиОшибку("идентификатор expected following `.` instead of `%s`", token.вТкст0());
                break;
            }
            место = token.место;
            ид = token.идент;
            nextToken();
        }

        ид = null;
        if (token.значение == ТОК2.идентификатор)
        {
            ид = token.идент;
            nextToken();
        }

        tm = new AST.TemplateMixin(locMixin, ид, tqual, tiargs);
        if (token.значение != ТОК2.semicolon)
            выведиОшибку("`;` expected after mixin");
        nextToken();

        return tm;
    }

    /******************************************
     * Parse template arguments.
     * Input:
     *      current token is opening '!'
     * Output:
     *      current token is one after closing '$(RPAREN)'
     */
    private AST.Объекты* parseTemplateArguments()
    {
        AST.Объекты* tiargs;

        nextToken();
        if (token.значение == ТОК2.leftParentheses)
        {
            // идент!(template_arguments)
            tiargs = parseTemplateArgumentList();
        }
        else
        {
            // идент!template_argument
            tiargs = parseTemplateSingleArgument();
        }
        if (token.значение == ТОК2.not)
        {
            ТОК2 tok = peekNext();
            if (tok != ТОК2.is_ && tok != ТОК2.in_)
            {
                выведиОшибку("multiple ! arguments are not allowed");
            Lagain:
                nextToken();
                if (token.значение == ТОК2.leftParentheses)
                    parseTemplateArgumentList();
                else
                    parseTemplateSingleArgument();
                if (token.значение == ТОК2.not && (tok = peekNext()) != ТОК2.is_ && tok != ТОК2.in_)
                    goto Lagain;
            }
        }
        return tiargs;
    }

    /******************************************
     * Parse template argument list.
     * Input:
     *      current token is opening '$(LPAREN)',
     *          or ',' for __traits
     * Output:
     *      current token is one after closing '$(RPAREN)'
     */
    private AST.Объекты* parseTemplateArgumentList()
    {
        //printf("Parser::parseTemplateArgumentList()\n");
        auto tiargs = new AST.Объекты();
        ТОК2 endtok = ТОК2.rightParentheses;
        assert(token.значение == ТОК2.leftParentheses || token.значение == ТОК2.comma);
        nextToken();

        // Get TemplateArgumentList
        while (token.значение != endtok)
        {
            tiargs.сунь(parseTypeOrAssignExp());
            if (token.значение != ТОК2.comma)
                break;
            nextToken();
        }
        check(endtok, "template argument list");
        return tiargs;
    }

    /***************************************
     * Parse a Тип or an Выражение
     * Возвращает:
     *  КорневойОбъект representing the AST
     */
    КорневойОбъект parseTypeOrAssignExp(ТОК2 endtoken = ТОК2.reserved)
    {
        return isDeclaration(&token, NeedDeclaratorId.no, endtoken, null)
            ? parseType()           // argument is a тип
            : parseAssignExp();     // argument is an Выражение
    }

    /*****************************
     * Parse single template argument, to support the syntax:
     *      foo!arg
     * Input:
     *      current token is the arg
     */
    private AST.Объекты* parseTemplateSingleArgument()
    {
        //printf("parseTemplateSingleArgument()\n");
        auto tiargs = new AST.Объекты();
        AST.Тип ta;
        switch (token.значение)
        {
        case ТОК2.идентификатор:
            ta = new AST.TypeIdentifier(token.место, token.идент);
            goto LabelX;

        case ТОК2.vector:
            ta = parseVector();
            goto LabelX;

        case ТОК2.void_:
            ta = AST.Тип.tvoid;
            goto LabelX;

        case ТОК2.int8:
            ta = AST.Тип.tint8;
            goto LabelX;

        case ТОК2.uns8:
            ta = AST.Тип.tuns8;
            goto LabelX;

        case ТОК2.int16:
            ta = AST.Тип.tint16;
            goto LabelX;

        case ТОК2.uns16:
            ta = AST.Тип.tuns16;
            goto LabelX;

        case ТОК2.int32:
            ta = AST.Тип.tint32;
            goto LabelX;

        case ТОК2.uns32:
            ta = AST.Тип.tuns32;
            goto LabelX;

        case ТОК2.int64:
            ta = AST.Тип.tint64;
            goto LabelX;

        case ТОК2.uns64:
            ta = AST.Тип.tuns64;
            goto LabelX;

        case ТОК2.int128:
            ta = AST.Тип.tint128;
            goto LabelX;

        case ТОК2.uns128:
            ta = AST.Тип.tuns128;
            goto LabelX;

        case ТОК2.float32:
            ta = AST.Тип.tfloat32;
            goto LabelX;

        case ТОК2.float64:
            ta = AST.Тип.tfloat64;
            goto LabelX;

        case ТОК2.float80:
            ta = AST.Тип.tfloat80;
            goto LabelX;

        case ТОК2.imaginary32:
            ta = AST.Тип.timaginary32;
            goto LabelX;

        case ТОК2.imaginary64:
            ta = AST.Тип.timaginary64;
            goto LabelX;

        case ТОК2.imaginary80:
            ta = AST.Тип.timaginary80;
            goto LabelX;

        case ТОК2.complex32:
            ta = AST.Тип.tcomplex32;
            goto LabelX;

        case ТОК2.complex64:
            ta = AST.Тип.tcomplex64;
            goto LabelX;

        case ТОК2.complex80:
            ta = AST.Тип.tcomplex80;
            goto LabelX;

        case ТОК2.бул_:
            ta = AST.Тип.tбул;
            goto LabelX;

        case ТОК2.char_:
            ta = AST.Тип.tchar;
            goto LabelX;

        case ТОК2.wchar_:
            ta = AST.Тип.twchar;
            goto LabelX;

        case ТОК2.dchar_:
            ta = AST.Тип.tdchar;
            goto LabelX;
        LabelX:
            tiargs.сунь(ta);
            nextToken();
            break;

        case ТОК2.int32Literal:
        case ТОК2.uns32Literal:
        case ТОК2.int64Literal:
        case ТОК2.uns64Literal:
        case ТОК2.int128Literal:
        case ТОК2.uns128Literal:
        case ТОК2.float32Literal:
        case ТОК2.float64Literal:
        case ТОК2.float80Literal:
        case ТОК2.imaginary32Literal:
        case ТОК2.imaginary64Literal:
        case ТОК2.imaginary80Literal:
        case ТОК2.null_:
        case ТОК2.true_:
        case ТОК2.false_:
        case ТОК2.charLiteral:
        case ТОК2.wcharLiteral:
        case ТОК2.dcharLiteral:
        case ТОК2.string_:
        case ТОК2.hexadecimalString:
        case ТОК2.файл:
        case ТОК2.fileFullPath:
        case ТОК2.line:
        case ТОК2.moduleString:
        case ТОК2.functionString:
        case ТОК2.prettyFunction:
        case ТОК2.this_:
            {
                // Template argument is an Выражение
                AST.Выражение ea = parsePrimaryExp();
                tiargs.сунь(ea);
                break;
            }
        default:
            выведиОшибку("template argument expected following `!`");
            break;
        }
        return tiargs;
    }

    /**********************************
     * Parse a static assertion.
     * Current token is 'static'.
     */
    private AST.StaticAssert parseStaticAssert()
    {
        const место = token.место;
        AST.Выражение exp;
        AST.Выражение msg = null;

        //printf("parseStaticAssert()\n");
        nextToken();
        nextToken();
        check(ТОК2.leftParentheses);
        exp = parseAssignExp();
        if (token.значение == ТОК2.comma)
        {
            nextToken();
            if (token.значение != ТОК2.rightParentheses)
            {
                msg = parseAssignExp();
                if (token.значение == ТОК2.comma)
                    nextToken();
            }
        }
        check(ТОК2.rightParentheses);
        check(ТОК2.semicolon);
        return new AST.StaticAssert(место, exp, msg);
    }

    /***********************************
     * Parse typeof(Выражение).
     * Current token is on the 'typeof'.
     */
    private AST.TypeQualified parseTypeof()
    {
        AST.TypeQualified t;
        const место = token.место;

        nextToken();
        check(ТОК2.leftParentheses);
        if (token.значение == ТОК2.return_) // typeof(return)
        {
            nextToken();
            t = new AST.TypeReturn(место);
        }
        else
        {
            AST.Выражение exp = parseВыражение(); // typeof(Выражение)
            t = new AST.TypeTypeof(место, exp);
        }
        check(ТОК2.rightParentheses);
        return t;
    }

    /***********************************
     * Parse __vector(тип).
     * Current token is on the '__vector'.
     */
    private AST.Тип parseVector()
    {
        nextToken();
        check(ТОК2.leftParentheses);
        AST.Тип tb = parseType();
        check(ТОК2.rightParentheses);
        return new AST.TypeVector(tb);
    }

    /***********************************
     * Parse:
     *      extern (компонаж)
     *      extern (C++, namespaces)
     *      extern (C++, "namespace", "namespaces", ...)
     *      extern (C++, (StringExp))
     * The parser is on the 'extern' token.
     */
    private LINK parseLinkage(AST.Идентификаторы** pidents, AST.Выражения** pIdentExps, out CPPMANGLE cppmangle, out бул cppMangleOnly)
    {
        AST.Идентификаторы* idents = null;
        AST.Выражения* identExps = null;
        cppmangle = CPPMANGLE.def;
        LINK link = LINK.d; // default
        nextToken();
        assert(token.значение == ТОК2.leftParentheses);
        nextToken();
        if (token.значение == ТОК2.идентификатор)
        {
            Идентификатор2 ид = token.идент;
            nextToken();
            if (ид == Id.Windows)
                link = LINK.windows;
            else if (ид == Id.Pascal)
            {
                deprecation("`extern(Pascal)` is deprecated. You might want to use `extern(Windows)` instead.");
                link = LINK.pascal;
            }
            else if (ид == Id.D)
            { /* already set */}
            else if (ид == Id.C)
            {
                link = LINK.c;
                if (token.значение == ТОК2.plusPlus)
                {
                    link = LINK.cpp;
                    nextToken();
                    if (token.значение == ТОК2.comma) // , namespaces or class or struct
                    {
                        nextToken();
                        if (token.значение == ТОК2.class_ || token.значение == ТОК2.struct_)
                        {
                            cppmangle = token.значение == ТОК2.class_ ? CPPMANGLE.asClass : CPPMANGLE.asStruct;
                            nextToken();
                        }
                        else if (token.значение == ТОК2.идентификатор) // named scope namespace
                        {
                            idents = new AST.Идентификаторы();
                            while (1)
                            {
                                Идентификатор2 idn = token.идент;
                                idents.сунь(idn);
                                nextToken();
                                if (token.значение == ТОК2.dot)
                                {
                                    nextToken();
                                    if (token.значение == ТОК2.идентификатор)
                                        continue;
                                    выведиОшибку("идентификатор expected for C++ namespace");
                                    idents = null;  // error occurred, invalidate list of elements.
                                }
                                break;
                            }
                        }
                        else // non-scoped StringExp namespace
                        {
                            cppMangleOnly = да;
                            identExps = new AST.Выражения();
                            while (1)
                            {
                                identExps.сунь(parseCondExp());
                                if (token.значение != ТОК2.comma)
                                    break;
                                nextToken();
                            }
                        }
                    }
                }
            }
            else if (ид == Id.Objective) // Looking for tokens "Objective-C"
            {
                if (token.значение == ТОК2.min)
                {
                    nextToken();
                    if (token.идент == Id.C)
                    {
                        link = LINK.objc;
                        nextToken();
                    }
                    else
                        goto LinvalidLinkage;
                }
                else
                    goto LinvalidLinkage;
            }
            else if (ид == Id.System)
            {
                link = LINK.system;
            }
            else
            {
            LinvalidLinkage:
                выведиОшибку("valid компонаж identifiers are `D`, `C`, `C++`, `Objective-C`, `Pascal`, `Windows`, `System`");
                link = LINK.d;
            }
        }
        check(ТОК2.rightParentheses);
        *pidents = idents;
        *pIdentExps = identExps;
        return link;
    }

    /***********************************
     * Parse ident1.ident2.ident3
     *
     * Параметры:
     *  entity = what qualified идентификатор is expected to resolve into.
     *     Used only for better error message
     *
     * Возвращает:
     *     массив of identifiers with actual qualified one stored last
     */
    private AST.Идентификаторы* parseQualifiedIdentifier(ткст0 entity)
    {
        AST.Идентификаторы* qualified = null;

        do
        {
            nextToken();
            if (token.значение != ТОК2.идентификатор)
            {
                выведиОшибку("`%s` expected as dot-separated identifiers, got `%s`", entity, token.вТкст0());
                return null;
            }

            Идентификатор2 ид = token.идент;
            if (!qualified)
                qualified = new AST.Идентификаторы();
            qualified.сунь(ид);

            nextToken();
        }
        while (token.значение == ТОК2.dot);

        return qualified;
    }

    /**************************************
     * Parse a debug conditional
     */
    private AST.Condition parseDebugCondition()
    {
        бцел уровень = 1;
        Идентификатор2 ид = null;

        if (token.значение == ТОК2.leftParentheses)
        {
            nextToken();

            if (token.значение == ТОК2.идентификатор)
                ид = token.идент;
            else if (token.значение == ТОК2.int32Literal || token.значение == ТОК2.int64Literal)
                уровень = cast(бцел)token.unsvalue;
            else
                выведиОшибку("идентификатор or integer expected inside debug(...), not `%s`", token.вТкст0());
            nextToken();
            check(ТОК2.rightParentheses);
        }
        return new AST.DebugCondition(mod, уровень, ид);
    }

    /**************************************
     * Parse a version conditional
     */
    private AST.Condition parseVersionCondition()
    {
        бцел уровень = 1;
        Идентификатор2 ид = null;

        if (token.значение == ТОК2.leftParentheses)
        {
            nextToken();
            /* Allow:
             *    version (unittest)
             *    version (assert)
             * even though they are keywords
             */
            if (token.значение == ТОК2.идентификатор)
                ид = token.идент;
            else if (token.значение == ТОК2.int32Literal || token.значение == ТОК2.int64Literal)
                уровень = cast(бцел)token.unsvalue;
            else if (token.значение == ТОК2.unittest_)
                ид = Идентификатор2.idPool(Сема2.вТкст(ТОК2.unittest_));
            else if (token.значение == ТОК2.assert_)
                ид = Идентификатор2.idPool(Сема2.вТкст(ТОК2.assert_));
            else
                выведиОшибку("идентификатор or integer expected inside version(...), not `%s`", token.вТкст0());
            nextToken();
            check(ТОК2.rightParentheses);
        }
        else
            выведиОшибку("(условие) expected following `version`");
        return new AST.VersionCondition(mod, уровень, ид);
    }

    /***********************************************
     *      static if (Выражение)
     *          body
     *      else
     *          body
     * Current token is 'static'.
     */
    private AST.Condition parseStaticIfCondition()
    {
        AST.Выражение exp;
        AST.Condition условие;
        const место = token.место;

        nextToken();
        nextToken();
        if (token.значение == ТОК2.leftParentheses)
        {
            nextToken();
            exp = parseAssignExp();
            check(ТОК2.rightParentheses);
        }
        else
        {
            выведиОшибку("(Выражение) expected following `static if`");
            exp = null;
        }
        условие = new AST.StaticIfCondition(место, exp);
        return условие;
    }

    /*****************************************
     * Parse a constructor definition:
     *      this(parameters) { body }
     * or postblit:
     *      this(this) { body }
     * or constructor template:
     *      this(templateparameters)(parameters) { body }
     * Current token is 'this'.
     */
    private AST.ДСимвол parseCtor(PrefixAttributes!(AST)* pAttrs)
    {
        AST.Выражения* udas = null;
        const место = token.место;
        КлассХранения stc = getStorageClass!(AST)(pAttrs);

        nextToken();
        if (token.значение == ТОК2.leftParentheses && peekNext() == ТОК2.this_ && peekNext2() == ТОК2.rightParentheses)
        {
            // this(this) { ... }
            nextToken();
            nextToken();
            check(ТОК2.rightParentheses);

            stc = parsePostfix(stc, &udas);
            if (stc & STC.immutable_)
                deprecation("`const` postblit is deprecated. Please use an unqualified postblit.");
            if (stc & STC.shared_)
                deprecation("`shared` postblit is deprecated. Please use an unqualified postblit.");
            if (stc & STC.const_)
                deprecation("`const` postblit is deprecated. Please use an unqualified postblit.");
            if (stc & STC.static_)
                выведиОшибку(место, "postblit cannot be `static`");

            auto f = new AST.PostBlitDeclaration(место, Место.initial, stc, Id.postblit);
            AST.ДСимвол s = parseContracts(f);
            if (udas)
            {
                auto a = new AST.Дсимволы();
                a.сунь(f);
                s = new AST.UserAttributeDeclaration(udas, a);
            }
            return s;
        }

        /* Look ahead to see if:
         *   this(...)(...)
         * which is a constructor template
         */
        AST.ПараметрыШаблона* tpl = null;
        if (token.значение == ТОК2.leftParentheses && peekPastParen(&token).значение == ТОК2.leftParentheses)
        {
            tpl = parseTemplateParameterList();
        }

        /* Just a regular constructor
         */
        AST.ВарАрг varargs;
        AST.Параметры* parameters = parseParameters(&varargs);
        stc = parsePostfix(stc, &udas);

        if (varargs != AST.ВарАрг.none || AST.Параметр2.dim(parameters) != 0)
        {
            if (stc & STC.static_)
                выведиОшибку(место, "constructor cannot be static");
        }
        else if (КлассХранения ss = stc & (STC.shared_ | STC.static_)) // this()
        {
            if (ss == STC.static_)
                выведиОшибку(место, "use `static this()` to declare a static constructor");
            else if (ss == (STC.shared_ | STC.static_))
                выведиОшибку(место, "use `shared static this()` to declare a shared static constructor");
        }

        AST.Выражение constraint = tpl ? parseConstraint() : null;

        AST.Тип tf = new AST.TypeFunction(AST.СписокПараметров(parameters, varargs), null, компонаж, stc); // RetrunType -> auto
        tf = tf.addSTC(stc);

        auto f = new AST.CtorDeclaration(место, Место.initial, stc, tf);
        AST.ДСимвол s = parseContracts(f);
        if (udas)
        {
            auto a = new AST.Дсимволы();
            a.сунь(f);
            s = new AST.UserAttributeDeclaration(udas, a);
        }

        if (tpl)
        {
            // Wrap a template around it
            auto decldefs = new AST.Дсимволы();
            decldefs.сунь(s);
            s = new AST.TemplateDeclaration(место, f.идент, tpl, constraint, decldefs);
        }

        return s;
    }

    /*****************************************
     * Parse a destructor definition:
     *      ~this() { body }
     * Current token is '~'.
     */
    private AST.ДСимвол parseDtor(PrefixAttributes!(AST)* pAttrs)
    {
        AST.Выражения* udas = null;
        const место = token.место;
        КлассХранения stc = getStorageClass!(AST)(pAttrs);

        nextToken();
        check(ТОК2.this_);
        check(ТОК2.leftParentheses);
        check(ТОК2.rightParentheses);

        stc = parsePostfix(stc, &udas);
        if (КлассХранения ss = stc & (STC.shared_ | STC.static_))
        {
            if (ss == STC.static_)
                выведиОшибку(место, "use `static ~this()` to declare a static destructor");
            else if (ss == (STC.shared_ | STC.static_))
                выведиОшибку(место, "use `shared static ~this()` to declare a shared static destructor");
        }

        auto f = new AST.DtorDeclaration(место, Место.initial, stc, Id.dtor);
        AST.ДСимвол s = parseContracts(f);
        if (udas)
        {
            auto a = new AST.Дсимволы();
            a.сунь(f);
            s = new AST.UserAttributeDeclaration(udas, a);
        }
        return s;
    }

    /*****************************************
     * Parse a static constructor definition:
     *      static this() { body }
     * Current token is 'static'.
     */
    private AST.ДСимвол parseStaticCtor(PrefixAttributes!(AST)* pAttrs)
    {
        //Выражения *udas = NULL;
        const место = token.место;
        КлассХранения stc = getStorageClass!(AST)(pAttrs);

        nextToken();
        nextToken();
        check(ТОК2.leftParentheses);
        check(ТОК2.rightParentheses);

        stc = parsePostfix(stc & ~STC.TYPECTOR, null) | stc;
        if (stc & STC.shared_)
            выведиОшибку(место, "use `shared static this()` to declare a shared static constructor");
        else if (stc & STC.static_)
            appendStorageClass(stc, STC.static_); // complaint for the redundancy
        else if (КлассХранения modStc = stc & STC.TYPECTOR)
        {
            БуфВыв буф;
            AST.stcToBuffer(&буф, modStc);
            выведиОшибку(место, "static constructor cannot be `%s`", буф.peekChars());
        }
        stc &= ~(STC.static_ | STC.TYPECTOR);

        auto f = new AST.StaticCtorDeclaration(место, Место.initial, stc);
        AST.ДСимвол s = parseContracts(f);
        return s;
    }

    /*****************************************
     * Parse a static destructor definition:
     *      static ~this() { body }
     * Current token is 'static'.
     */
    private AST.ДСимвол parseStaticDtor(PrefixAttributes!(AST)* pAttrs)
    {
        AST.Выражения* udas = null;
        const место = token.место;
        КлассХранения stc = getStorageClass!(AST)(pAttrs);

        nextToken();
        nextToken();
        check(ТОК2.this_);
        check(ТОК2.leftParentheses);
        check(ТОК2.rightParentheses);

        stc = parsePostfix(stc & ~STC.TYPECTOR, &udas) | stc;
        if (stc & STC.shared_)
            выведиОшибку(место, "use `shared static ~this()` to declare a shared static destructor");
        else if (stc & STC.static_)
            appendStorageClass(stc, STC.static_); // complaint for the redundancy
        else if (КлассХранения modStc = stc & STC.TYPECTOR)
        {
            БуфВыв буф;
            AST.stcToBuffer(&буф, modStc);
            выведиОшибку(место, "static destructor cannot be `%s`", буф.peekChars());
        }
        stc &= ~(STC.static_ | STC.TYPECTOR);

        auto f = new AST.StaticDtorDeclaration(место, Место.initial, stc);
        AST.ДСимвол s = parseContracts(f);
        if (udas)
        {
            auto a = new AST.Дсимволы();
            a.сунь(f);
            s = new AST.UserAttributeDeclaration(udas, a);
        }
        return s;
    }

    /*****************************************
     * Parse a shared static constructor definition:
     *      shared static this() { body }
     * Current token is 'shared'.
     */
    private AST.ДСимвол parseSharedStaticCtor(PrefixAttributes!(AST)* pAttrs)
    {
        //Выражения *udas = NULL;
        const место = token.место;
        КлассХранения stc = getStorageClass!(AST)(pAttrs);

        nextToken();
        nextToken();
        nextToken();
        check(ТОК2.leftParentheses);
        check(ТОК2.rightParentheses);

        stc = parsePostfix(stc & ~STC.TYPECTOR, null) | stc;
        if (КлассХранения ss = stc & (STC.shared_ | STC.static_))
            appendStorageClass(stc, ss); // complaint for the redundancy
        else if (КлассХранения modStc = stc & STC.TYPECTOR)
        {
            БуфВыв буф;
            AST.stcToBuffer(&буф, modStc);
            выведиОшибку(место, "shared static constructor cannot be `%s`", буф.peekChars());
        }
        stc &= ~(STC.static_ | STC.TYPECTOR);

        auto f = new AST.SharedStaticCtorDeclaration(место, Место.initial, stc);
        AST.ДСимвол s = parseContracts(f);
        return s;
    }

    /*****************************************
     * Parse a shared static destructor definition:
     *      shared static ~this() { body }
     * Current token is 'shared'.
     */
    private AST.ДСимвол parseSharedStaticDtor(PrefixAttributes!(AST)* pAttrs)
    {
        AST.Выражения* udas = null;
        const место = token.место;
        КлассХранения stc = getStorageClass!(AST)(pAttrs);

        nextToken();
        nextToken();
        nextToken();
        check(ТОК2.this_);
        check(ТОК2.leftParentheses);
        check(ТОК2.rightParentheses);

        stc = parsePostfix(stc & ~STC.TYPECTOR, &udas) | stc;
        if (КлассХранения ss = stc & (STC.shared_ | STC.static_))
            appendStorageClass(stc, ss); // complaint for the redundancy
        else if (КлассХранения modStc = stc & STC.TYPECTOR)
        {
            БуфВыв буф;
            AST.stcToBuffer(&буф, modStc);
            выведиОшибку(место, "shared static destructor cannot be `%s`", буф.peekChars());
        }
        stc &= ~(STC.static_ | STC.TYPECTOR);

        auto f = new AST.SharedStaticDtorDeclaration(место, Место.initial, stc);
        AST.ДСимвол s = parseContracts(f);
        if (udas)
        {
            auto a = new AST.Дсимволы();
            a.сунь(f);
            s = new AST.UserAttributeDeclaration(udas, a);
        }
        return s;
    }

    /*****************************************
     * Parse an invariant definition:
     *      invariant { statements... }
     *      invariant() { statements... }
     *      invariant (Выражение);
     * Current token is 'invariant'.
     */
    private AST.ДСимвол parseInvariant(PrefixAttributes!(AST)* pAttrs)
    {
        const место = token.место;
        КлассХранения stc = getStorageClass!(AST)(pAttrs);

        nextToken();
        if (token.значение == ТОК2.leftParentheses) // optional () or invariant (Выражение);
        {
            nextToken();
            if (token.значение != ТОК2.rightParentheses) // invariant (Выражение);
            {
                AST.Выражение e = parseAssignExp(), msg = null;
                if (token.значение == ТОК2.comma)
                {
                    nextToken();
                    if (token.значение != ТОК2.rightParentheses)
                    {
                        msg = parseAssignExp();
                        if (token.значение == ТОК2.comma)
                            nextToken();
                    }
                }
                check(ТОК2.rightParentheses);
                check(ТОК2.semicolon);
                e = new AST.AssertExp(место, e, msg);
                auto fbody = new AST.ExpStatement(место, e);
                auto f = new AST.InvariantDeclaration(место, token.место, stc, null, fbody);
                return f;
            }
            nextToken();
        }

        auto fbody = parseStatement(ParseStatementFlags.curly);
        auto f = new AST.InvariantDeclaration(место, token.место, stc, null, fbody);
        return f;
    }

    /*****************************************
     * Parse a unittest definition:
     *      unittest { body }
     * Current token is 'unittest'.
     */
    private AST.ДСимвол parseUnitTest(PrefixAttributes!(AST)* pAttrs)
    {
        const место = token.место;
        КлассХранения stc = getStorageClass!(AST)(pAttrs);

        nextToken();

        ткст0 begPtr = token.ptr + 1; // skip '{'
        ткст0 endPtr = null;
        AST.Инструкция2 sbody = parseStatement(ParseStatementFlags.curly, &endPtr);

        /** Extract unittest body as a ткст. Must be done eagerly since memory
         will be released by the lexer before doc gen. */
        ткст0 docline = null;
        if (глоб2.парамы.doDocComments && endPtr > begPtr)
        {
            /* Remove trailing whitespaces */
            for (ткст0 p = endPtr - 1; begPtr <= p && (*p == ' ' || *p == '\r' || *p == '\n' || *p == '\t'); --p)
            {
                endPtr = p;
            }

            т_мера len = endPtr - begPtr;
            if (len > 0)
            {
                docline = cast(сим*)mem.xmalloc_noscan(len + 2);
                memcpy(docline, begPtr, len);
                docline[len] = '\n'; // Terminate all строки by LF
                docline[len + 1] = '\0';
            }
        }

        auto f = new AST.UnitTestDeclaration(место, token.место, stc, docline);
        f.fbody = sbody;
        return f;
    }

    /*****************************************
     * Parse a new definition:
     *      new(parameters) { body }
     * Current token is 'new'.
     */
    private AST.ДСимвол parseNew(PrefixAttributes!(AST)* pAttrs)
    {
        const место = token.место;
        КлассХранения stc = getStorageClass!(AST)(pAttrs);

        nextToken();

        AST.ВарАрг varargs;
        AST.Параметры* parameters = parseParameters(&varargs);
        auto f = new AST.NewDeclaration(место, Место.initial, stc, parameters, varargs);
        AST.ДСимвол s = parseContracts(f);
        return s;
    }

    /**********************************************
     * Parse параметр list.
     */
    private AST.Параметры* parseParameters(AST.ВарАрг* pvarargs, AST.ПараметрыШаблона** tpl = null)
    {
        auto parameters = new AST.Параметры();
        AST.ВарАрг varargs = AST.ВарАрг.none;
        цел hasdefault = 0;

        check(ТОК2.leftParentheses);
        while (1)
        {
            Идентификатор2 ai = null;
            AST.Тип at;
            КлассХранения классХранения = 0;
            КлассХранения stc;
            AST.Выражение ae;
            AST.Выражения* udas = null;
            for (; 1; nextToken())
            {
            L3:
                switch (token.значение)
                {
                case ТОК2.rightParentheses:
                    if (классХранения != 0 || udas !is null)
                        выведиОшибку("basic тип expected, not `)`");
                    break;

                case ТОК2.dotDotDot:
                    varargs = AST.ВарАрг.variadic;
                    nextToken();
                    break;

                case ТОК2.const_:
                    if (peekNext() == ТОК2.leftParentheses)
                        goto default;
                    stc = STC.const_;
                    goto L2;

                case ТОК2.immutable_:
                    if (peekNext() == ТОК2.leftParentheses)
                        goto default;
                    stc = STC.immutable_;
                    goto L2;

                case ТОК2.shared_:
                    if (peekNext() == ТОК2.leftParentheses)
                        goto default;
                    stc = STC.shared_;
                    goto L2;

                case ТОК2.inout_:
                    if (peekNext() == ТОК2.leftParentheses)
                        goto default;
                    stc = STC.wild;
                    goto L2;
                case ТОК2.at:
                    {
                        AST.Выражения* exps = null;
                        КлассХранения stc2 = parseAttribute(&exps);
                        if (stc2 & atAttrGroup)
                        {
                            выведиОшибку("`@%s` attribute for function параметр is not supported", token.вТкст0());
                        }
                        else
                        {
                            udas = AST.UserAttributeDeclaration.concat(udas, exps);
                        }
                        if (token.значение == ТОК2.dotDotDot)
                            выведиОшибку("variadic параметр cannot have user-defined attributes");
                        if (stc2)
                            nextToken();
                        goto L3;
                        // Don't call nextToken again.
                    }
                case ТОК2.in_:
                    stc = STC.in_;
                    goto L2;

                case ТОК2.out_:
                    stc = STC.out_;
                    goto L2;

                case ТОК2.ref_:
                    stc = STC.ref_;
                    goto L2;

                case ТОК2.lazy_:
                    stc = STC.lazy_;
                    goto L2;

                case ТОК2.scope_:
                    stc = STC.scope_;
                    goto L2;

                case ТОК2.final_:
                    stc = STC.final_;
                    goto L2;

                case ТОК2.auto_:
                    stc = STC.auto_;
                    goto L2;

                case ТОК2.return_:
                    stc = STC.return_;
                    goto L2;
                L2:
                    классХранения = appendStorageClass(классХранения, stc);
                    continue;

                    version (none)
                    {
                    case ТОК2.static_:
                        stc = STC.static_;
                        goto L2;

                    case ТОК2.auto_:
                        классХранения = STC.auto_;
                        goto L4;

                    case ТОК2.alias_:
                        классХранения = STC.alias_;
                        goto L4;
                    L4:
                        nextToken();
                        ai = null;
                        if (token.значение == ТОК2.идентификатор)
                        {
                            ai = token.идент;
                            nextToken();
                        }

                        at = null; // no тип
                        ae = null; // no default argument
                        if (token.значение == ТОК2.assign) // = defaultArg
                        {
                            nextToken();
                            ae = parseDefaultInitExp();
                            hasdefault = 1;
                        }
                        else
                        {
                            if (hasdefault)
                                выведиОшибку("default argument expected for `alias %s`", ai ? ai.вТкст0() : "");
                        }
                        goto L3;
                    }
                default:
                    {
                        stc = классХранения & (STC.in_ | STC.out_ | STC.ref_ | STC.lazy_);
                        // if stc is not a power of 2
                        if (stc & (stc - 1) && !(stc == (STC.in_ | STC.ref_)))
                            выведиОшибку("incompatible параметр storage classes");
                        //if ((классХранения & STC.scope_) && (классХранения & (STC.ref_ | STC.out_)))
                            //выведиОшибку("scope cannot be ref or out");

                        if (tpl && token.значение == ТОК2.идентификатор)
                        {
                            const tv = peekNext();
                            if (tv == ТОК2.comma || tv == ТОК2.rightParentheses || tv == ТОК2.dotDotDot)
                            {
                                Идентификатор2 ид = Идентификатор2.генерируйИд("__T");
                                const место = token.место;
                                at = new AST.TypeIdentifier(место, ид);
                                if (!*tpl)
                                    *tpl = new AST.ПараметрыШаблона();
                                AST.ПараметрШаблона2 tp = new AST.TemplateTypeParameter(место, ид, null, null);
                                (*tpl).сунь(tp);

                                ai = token.идент;
                                nextToken();
                            }
                            else goto _else;
                        }
                        else
                        {
                        _else:
                            at = parseType(&ai);
                        }
                        ae = null;
                        if (token.значение == ТОК2.assign) // = defaultArg
                        {
                            nextToken();
                            ae = parseDefaultInitExp();
                            hasdefault = 1;
                        }
                        else
                        {
                            if (hasdefault)
                                выведиОшибку("default argument expected for `%s`", ai ? ai.вТкст0() : at.вТкст0());
                        }
                        auto param = new AST.Параметр2(классХранения, at, ai, ae, null);
                        if (udas)
                        {
                            auto a = new AST.Дсимволы();
                            auto udad = new AST.UserAttributeDeclaration(udas, a);
                            param.userAttribDecl = udad;
                        }
                        if (token.значение == ТОК2.at)
                        {
                            AST.Выражения* exps = null;
                            КлассХранения stc2 = parseAttribute(&exps);
                            if (stc2 & atAttrGroup)
                            {
                                выведиОшибку("`@%s` attribute for function параметр is not supported", token.вТкст0());
                            }
                            else
                            {
                                выведиОшибку("user-defined attributes cannot appear as postfixes", token.вТкст0());
                            }
                            if (stc2)
                                nextToken();
                        }
                        if (token.значение == ТОК2.dotDotDot)
                        {
                            /* This is:
                             *      at ai ...
                             */
                            if (классХранения & (STC.out_ | STC.ref_))
                                выведиОшибку("variadic argument cannot be `out` or `ref`");
                            varargs = AST.ВарАрг.typesafe;
                            parameters.сунь(param);
                            nextToken();
                            break;
                        }
                        parameters.сунь(param);
                        if (token.значение == ТОК2.comma)
                        {
                            nextToken();
                            goto L1;
                        }
                        break;
                    }
                }
                break;
            }
            break;       
        }
         L1:
        check(ТОК2.rightParentheses);
        *pvarargs = varargs;
        return parameters;
    }

    /*************************************
     */
    private AST.EnumDeclaration parseEnum()
    {
        AST.EnumDeclaration e;
        Идентификатор2 ид;
        AST.Тип memtype;
        auto место = token.место;

        // printf("Parser::parseEnum()\n");
        nextToken();
        ид = null;
        if (token.значение == ТОК2.идентификатор)
        {
            ид = token.идент;
            nextToken();
        }

        memtype = null;
        if (token.значение == ТОК2.colon)
        {
            nextToken();
            цел alt = 0;
            const typeLoc = token.место;
            memtype = parseBasicType();
            memtype = parseDeclarator(memtype, &alt, null);
            checkCstyleTypeSyntax(typeLoc, memtype, alt, null);
        }

        e = new AST.EnumDeclaration(место, ид, memtype);
        if (token.значение == ТОК2.semicolon && ид)
            nextToken();
        else if (token.значение == ТОК2.leftCurly)
        {
            бул isAnonymousEnum = !ид;
            ТОК2 prevTOK;

            //printf("enum definition\n");
            e.члены = new AST.Дсимволы();
            nextToken();
            ткст коммент = token.blockComment;
            while (token.значение != ТОК2.rightCurly)
            {
                /* Can take the following forms...
                 *  1. идент
                 *  2. идент = значение
                 *  3. тип идент = значение
                 *  ... prefixed by valid attributes
                 */
                место = token.место;

                AST.Тип тип = null;
                Идентификатор2 идент = null;

                AST.Выражения* udas;
                КлассХранения stc;
                AST.Выражение deprecationMessage;
                const attributeErrorMessage = "`%s` is not a valid attribute for enum члены";
                while(token.значение != ТОК2.rightCurly
                    && token.значение != ТОК2.comma
                    && token.значение != ТОК2.assign)
                {
                    switch(token.значение)
                    {
                        case ТОК2.at:
                            if (КлассХранения _stc = parseAttribute(&udas))
                            {
                                if (_stc == STC.disable)
                                    stc |= _stc;
                                else
                                {
                                    БуфВыв буф;
                                    AST.stcToBuffer(&буф, _stc);
                                    выведиОшибку(attributeErrorMessage, буф.peekChars());
                                }
                                prevTOK = token.значение;
                                nextToken();
                            }
                            break;
                        case ТОК2.deprecated_:
                            if (КлассХранения _stc = parseDeprecatedAttribute(deprecationMessage))
                            {
                                stc |= _stc;
                                prevTOK = token.значение;
                                nextToken();
                            }
                            break;
                        case ТОК2.идентификатор:
                            const tv = peekNext();
                            if (tv == ТОК2.assign || tv == ТОК2.comma || tv == ТОК2.rightCurly)
                            {
                                идент = token.идент;
                                тип = null;
                                prevTOK = token.значение;
                                nextToken();
                            }
                            else
                            {
                                goto default;
                            }
                            break;
                        default:
                            if (isAnonymousEnum)
                            {
                                тип = parseType(&идент, null);
                                if (тип == AST.Тип.terror)
                                {
                                    тип = null;
                                    prevTOK = token.значение;
                                    nextToken();
                                }
                                else
                                {
                                    prevTOK = ТОК2.идентификатор;
                                }
                            }
                            else
                            {
                                выведиОшибку(attributeErrorMessage, token.вТкст0());
                                prevTOK = token.значение;
                                nextToken();
                            }
                            break;
                    }
                    if (token.значение == ТОК2.comma)
                    {
                        prevTOK = token.значение;
                    }
                }

                if (тип && тип != AST.Тип.terror)
                {
                    if (!идент)
                        выведиОшибку("no идентификатор for declarator `%s`", тип.вТкст0());
                    if (!isAnonymousEnum)
                        выведиОшибку("тип only allowed if анонимный enum and no enum тип");
                }
                AST.Выражение значение;
                if (token.значение == ТОК2.assign)
                {
                    if (prevTOK == ТОК2.идентификатор)
                    {
                        nextToken();
                        значение = parseAssignExp();
                    }
                    else
                    {
                        выведиОшибку("assignment must be preceded by an идентификатор");
                        nextToken();
                    }
                }
                else
                {
                    значение = null;
                    if (тип && тип != AST.Тип.terror && isAnonymousEnum)
                        выведиОшибку("if тип, there must be an инициализатор");
                }

                AST.UserAttributeDeclaration uad;
                if (udas)
                    uad = new AST.UserAttributeDeclaration(udas, null);

                AST.DeprecatedDeclaration dd;
                if (deprecationMessage)
                {
                    dd = new AST.DeprecatedDeclaration(deprecationMessage, null);
                    stc |= STC.deprecated_;
                }

                auto em = new AST.EnumMember(место, идент, значение, тип, stc, uad, dd);
                e.члены.сунь(em);

                if (token.значение == ТОК2.rightCurly)
                {
                }
                else
                {
                    добавьКоммент(em, коммент);
                    коммент = null;
                    check(ТОК2.comma);
                }
                добавьКоммент(em, коммент);
                коммент = token.blockComment;

                if (token.значение == ТОК2.endOfFile)
                {
                    выведиОшибку("premature end of файл");
                    break;
                }
            }
            nextToken();
        }
        else
            выведиОшибку("enum declaration is invalid");

        //printf("-parseEnum() %s\n", e.вТкст0());
        return e;
    }

    /********************************
     * Parse struct, union, interface, class.
     */
    private AST.ДСимвол parseAggregate()
    {
        AST.ПараметрыШаблона* tpl = null;
        AST.Выражение constraint;
        const место = token.место;
        ТОК2 tok = token.значение;

        //printf("Parser::parseAggregate()\n");
        nextToken();
        Идентификатор2 ид;
        if (token.значение != ТОК2.идентификатор)
        {
            ид = null;
        }
        else
        {
            ид = token.идент;
            nextToken();

            if (token.значение == ТОК2.leftParentheses)
            {
                // struct/class template declaration.
                tpl = parseTemplateParameterList();
                constraint = parseConstraint();
            }
        }

        // Collect base class(es)
        AST.КлассыОсновы* baseclasses = null;
        if (token.значение == ТОК2.colon)
        {
            if (tok != ТОК2.interface_ && tok != ТОК2.class_)
                выведиОшибку("base classes are not allowed for `%s`, did you mean `;`?", Сема2.вТкст0(tok));
            nextToken();
            baseclasses = parseBaseClasses();
        }

        if (token.значение == ТОК2.if_)
        {
            if (constraint)
                выведиОшибку("template constraints appear both before and after BaseClassList, put them before");
            constraint = parseConstraint();
        }
        if (constraint)
        {
            if (!ид)
                выведиОшибку("template constraints not allowed for анонимный `%s`", Сема2.вТкст0(tok));
            if (!tpl)
                выведиОшибку("template constraints only allowed for templates");
        }

        AST.Дсимволы* члены = null;
        if (token.значение == ТОК2.leftCurly)
        {
            //printf("aggregate definition\n");
            const lookingForElseSave = lookingForElse;
            lookingForElse = Место();
            nextToken();
            члены = parseDeclDefs(0);
            lookingForElse = lookingForElseSave;
            if (token.значение != ТОК2.rightCurly)
            {
                /* { */
                выведиОшибку("`}` expected following члены in `%s` declaration at %s",
                    Сема2.вТкст0(tok), место.вТкст0());
            }
            nextToken();
        }
        else if (token.значение == ТОК2.semicolon && ид)
        {
            if (baseclasses || constraint)
                выведиОшибку("члены expected");
            nextToken();
        }
        else
        {
            выведиОшибку("{ } expected following `%s` declaration", Сема2.вТкст0(tok));
        }

        AST.AggregateDeclaration a;
        switch (tok)
        {
        case ТОК2.interface_:
            if (!ид)
                выведиОшибку(место, "анонимный interfaces not allowed");
            a = new AST.InterfaceDeclaration(место, ид, baseclasses);
            a.члены = члены;
            break;

        case ТОК2.class_:
            if (!ид)
                выведиОшибку(место, "анонимный classes not allowed");
            бул inObject = md && !md.пакеты && md.ид == Id.объект;
            a = new AST.ClassDeclaration(место, ид, baseclasses, члены, inObject);
            break;

        case ТОК2.struct_:
            if (ид)
            {
                бул inObject = md && !md.пакеты && md.ид == Id.объект;
                a = new AST.StructDeclaration(место, ид, inObject);
                a.члены = члены;
            }
            else
            {
                /* Anonymous structs/unions are more like attributes.
                 */
                assert(!tpl);
                return new AST.AnonDeclaration(место, нет, члены);
            }
            break;

        case ТОК2.union_:
            if (ид)
            {
                a = new AST.UnionDeclaration(место, ид);
                a.члены = члены;
            }
            else
            {
                /* Anonymous structs/unions are more like attributes.
                 */
                assert(!tpl);
                return new AST.AnonDeclaration(место, да, члены);
            }
            break;

        default:
            assert(0);
        }

        if (tpl)
        {
            // Wrap a template around the aggregate declaration
            auto decldefs = new AST.Дсимволы();
            decldefs.сунь(a);
            auto tempdecl = new AST.TemplateDeclaration(место, ид, tpl, constraint, decldefs);
            return tempdecl;
        }
        return a;
    }

    /*******************************************
     */
    private AST.КлассыОсновы* parseBaseClasses()
    {
        auto baseclasses = new AST.КлассыОсновы();

        for (; 1; nextToken())
        {
            auto b = new AST.КлассОснова2(parseBasicType());
            baseclasses.сунь(b);
            if (token.значение != ТОК2.comma)
                break;
        }
        return baseclasses;
    }

    private AST.Дсимволы* parseImport()
    {
        auto decldefs = new AST.Дсимволы();
        Идентификатор2 aliasid = null;

        цел статичен_ли = token.значение == ТОК2.static_;
        if (статичен_ли)
            nextToken();

        //printf("Parser::parseImport()\n");
        do
        {
        L1:
            nextToken();
            if (token.значение != ТОК2.идентификатор)
            {
                выведиОшибку("идентификатор expected following `import`");
                break;
            }

            const место = token.место;
            Идентификатор2 ид = token.идент;
            AST.Идентификаторы* a = null;
            nextToken();
            if (!aliasid && token.значение == ТОК2.assign)
            {
                aliasid = ид;
                goto L1;
            }
            while (token.значение == ТОК2.dot)
            {
                if (!a)
                    a = new AST.Идентификаторы();
                a.сунь(ид);
                nextToken();
                if (token.значение != ТОК2.идентификатор)
                {
                    выведиОшибку("идентификатор expected following `package`");
                    break;
                }
                ид = token.идент;
                nextToken();
            }

            auto s = new AST.Импорт(место, a, ид, aliasid, статичен_ли);
            decldefs.сунь(s);

            /* Look for
             *      : alias=имя, alias=имя;
             * syntax.
             */
            if (token.значение == ТОК2.colon)
            {
                do
                {
                    nextToken();
                    if (token.значение != ТОК2.идентификатор)
                    {
                        выведиОшибку("идентификатор expected following `:`");
                        break;
                    }
                    Идентификатор2 _alias = token.идент;
                    Идентификатор2 имя;
                    nextToken();
                    if (token.значение == ТОК2.assign)
                    {
                        nextToken();
                        if (token.значение != ТОК2.идентификатор)
                        {
                            выведиОшибку("идентификатор expected following `%s=`", _alias.вТкст0());
                            break;
                        }
                        имя = token.идент;
                        nextToken();
                    }
                    else
                    {
                        имя = _alias;
                        _alias = null;
                    }
                    s.добавьНик(имя, _alias);
                }
                while (token.значение == ТОК2.comma);
                break; // no comma-separated imports of this form
            }
            aliasid = null;
        }
        while (token.значение == ТОК2.comma);

        if (token.значение == ТОК2.semicolon)
            nextToken();
        else
        {
            выведиОшибку("`;` expected");
            nextToken();
        }

        return decldefs;
    }

    AST.Тип parseType(Идентификатор2* pident = null, AST.ПараметрыШаблона** ptpl = null)
    {
        /* Take care of the storage class prefixes that
         * serve as тип attributes:
         *               const тип
         *           const тип
         *              shared тип
         *               inout тип
         *         inout const тип
         *        shared const тип
         *        shared inout тип
         *  shared inout const тип
         */
        КлассХранения stc = 0;
        while (1)
        {
            switch (token.значение)
            {
            case ТОК2.const_:
                if (peekNext() == ТОК2.leftParentheses)
                    break; // const as тип constructor
                stc |= STC.const_; // const as storage class
                nextToken();
                continue;

            case ТОК2.immutable_:
                if (peekNext() == ТОК2.leftParentheses)
                    break;
                stc |= STC.immutable_;
                nextToken();
                continue;

            case ТОК2.shared_:
                if (peekNext() == ТОК2.leftParentheses)
                    break;
                stc |= STC.shared_;
                nextToken();
                continue;

            case ТОК2.inout_:
                if (peekNext() == ТОК2.leftParentheses)
                    break;
                stc |= STC.wild;
                nextToken();
                continue;

            default:
                break;
            }
            break;
        }

        const typeLoc = token.место;

        AST.Тип t;
        t = parseBasicType();

        цел alt = 0;
        t = parseDeclarator(t, &alt, pident, ptpl);
        checkCstyleTypeSyntax(typeLoc, t, alt, pident ? *pident : null);

        t = t.addSTC(stc);
        return t;
    }

    private AST.Тип parseBasicType(бул dontLookDotIdents = нет)
    {
        AST.Тип t;
        Место место;
        Идентификатор2 ид;
        //printf("parseBasicType()\n");
        switch (token.значение)
        {
        case ТОК2.void_:
            t = AST.Тип.tvoid;
            goto LabelX;

        case ТОК2.int8:
            t = AST.Тип.tint8;
            goto LabelX;

        case ТОК2.uns8:
            t = AST.Тип.tuns8;
            goto LabelX;

        case ТОК2.int16:
            t = AST.Тип.tint16;
            goto LabelX;

        case ТОК2.uns16:
            t = AST.Тип.tuns16;
            goto LabelX;

        case ТОК2.int32:
            t = AST.Тип.tint32;
            goto LabelX;

        case ТОК2.uns32:
            t = AST.Тип.tuns32;
            goto LabelX;

        case ТОК2.int64:
            t = AST.Тип.tint64;
            nextToken();
            if (token.значение == ТОК2.int64)   // if `long long`
            {
                выведиОшибку("use `long` for a 64 bit integer instead of `long long`");
                nextToken();
            }
            else if (token.значение == ТОК2.float64)   // if `long double`
            {
                выведиОшибку("use `real` instead of `long double`");
                t = AST.Тип.tfloat80;
                nextToken();
            }
            break;

        case ТОК2.uns64:
            t = AST.Тип.tuns64;
            goto LabelX;

        case ТОК2.int128:
            t = AST.Тип.tint128;
            goto LabelX;

        case ТОК2.uns128:
            t = AST.Тип.tuns128;
            goto LabelX;

        case ТОК2.float32:
            t = AST.Тип.tfloat32;
            goto LabelX;

        case ТОК2.float64:
            t = AST.Тип.tfloat64;
            goto LabelX;

        case ТОК2.float80:
            t = AST.Тип.tfloat80;
            goto LabelX;

        case ТОК2.imaginary32:
            t = AST.Тип.timaginary32;
            goto LabelX;

        case ТОК2.imaginary64:
            t = AST.Тип.timaginary64;
            goto LabelX;

        case ТОК2.imaginary80:
            t = AST.Тип.timaginary80;
            goto LabelX;

        case ТОК2.complex32:
            t = AST.Тип.tcomplex32;
            goto LabelX;

        case ТОК2.complex64:
            t = AST.Тип.tcomplex64;
            goto LabelX;

        case ТОК2.complex80:
            t = AST.Тип.tcomplex80;
            goto LabelX;

        case ТОК2.бул_:
            t = AST.Тип.tбул;
            goto LabelX;

        case ТОК2.char_:
            t = AST.Тип.tchar;
            goto LabelX;

        case ТОК2.wchar_:
            t = AST.Тип.twchar;
            goto LabelX;

        case ТОК2.dchar_:
            t = AST.Тип.tdchar;
            goto LabelX;
        LabelX:
            nextToken();
            break;

        case ТОК2.this_:
        case ТОК2.super_:
        case ТОК2.идентификатор:
            место = token.место;
            ид = token.идент;
            nextToken();
            if (token.значение == ТОК2.not)
            {
                // идент!(template_arguments)
                auto tempinst = new AST.TemplateInstance(место, ид, parseTemplateArguments());
                t = parseBasicTypeStartingAt(new AST.TypeInstance(место, tempinst), dontLookDotIdents);
            }
            else
            {
                t = parseBasicTypeStartingAt(new AST.TypeIdentifier(место, ид), dontLookDotIdents);
            }
            break;

        case ТОК2.mixin_:
            // https://dlang.org/spec/Выражение.html#mixin_types
            nextToken();
            место = token.место;
            if (token.значение != ТОК2.leftParentheses)
                выведиОшибку("found `%s` when expecting `%s` following %s", token.вТкст0(), Сема2.вТкст0(ТОК2.leftParentheses), "`mixin`".ptr);
            auto exps = parseArguments();
            t = new AST.TypeMixin(место, exps);
            break;

        case ТОК2.dot:
            // Leading . as in .foo
            t = parseBasicTypeStartingAt(new AST.TypeIdentifier(token.место, Id.empty), dontLookDotIdents);
            break;

        case ТОК2.typeof_:
            // typeof(Выражение)
            t = parseBasicTypeStartingAt(parseTypeof(), dontLookDotIdents);
            break;

        case ТОК2.vector:
            t = parseVector();
            break;

        case ТОК2.traits:
            if (AST.TraitsExp te = cast(AST.TraitsExp) parsePrimaryExp())
                if (te.идент && te.args)
                {
                    t = new AST.TypeTraits(token.место, te);
                    break;
                }
            t = new AST.TypeError;
            break;

        case ТОК2.const_:
            // const(тип)
            nextToken();
            check(ТОК2.leftParentheses);
            t = parseType().addSTC(STC.const_);
            check(ТОК2.rightParentheses);
            break;

        case ТОК2.immutable_:
            // const(тип)
            nextToken();
            check(ТОК2.leftParentheses);
            t = parseType().addSTC(STC.immutable_);
            check(ТОК2.rightParentheses);
            break;

        case ТОК2.shared_:
            // shared(тип)
            nextToken();
            check(ТОК2.leftParentheses);
            t = parseType().addSTC(STC.shared_);
            check(ТОК2.rightParentheses);
            break;

        case ТОК2.inout_:
            // wild(тип)
            nextToken();
            check(ТОК2.leftParentheses);
            t = parseType().addSTC(STC.wild);
            check(ТОК2.rightParentheses);
            break;

        default:
            выведиОшибку("basic тип expected, not `%s`", token.вТкст0());
            if (token.значение == ТОК2.else_)
                errorSupplemental(token.место, "There's no `static else`, use `else` instead.");
            t = AST.Тип.terror;
            break;
        }
        return t;
    }

    private AST.Тип parseBasicTypeStartingAt(AST.TypeQualified tid, бул dontLookDotIdents)
    {
        AST.Тип maybeArray = null;
        // See https://issues.dlang.org/show_bug.cgi?ид=1215
        // A basic тип can look like MyType (typical case), but also:
        //  MyType.T -> A тип
        //  MyType[expr] -> Either a static массив of MyType or a тип (iif MyType is a Ttuple)
        //  MyType[expr].T -> A тип.
        //  MyType[expr].T[expr] ->  Either a static массив of MyType[expr].T or a тип
        //                           (iif MyType[expr].T is a Ttuple)
        while (1)
        {
            switch (token.значение)
            {
            case ТОК2.dot:
                {
                    nextToken();
                    if (token.значение != ТОК2.идентификатор)
                    {
                        выведиОшибку("идентификатор expected following `.` instead of `%s`", token.вТкст0());
                        break;
                    }
                    if (maybeArray)
                    {
                        // This is actually a КортежТипов index, not an {a/s}массив.
                        // We need to have a while loop to unwind all index taking:
                        // T[e1][e2].U   ->  T, addIndex(e1), addIndex(e2)
                        AST.Объекты dimStack;
                        AST.Тип t = maybeArray;
                        while (да)
                        {
                            if (t.ty == AST.Tsarray)
                            {
                                // The index Выражение is an Выражение.
                                AST.TypeSArray a = cast(AST.TypeSArray)t;
                                dimStack.сунь(a.dim.syntaxCopy());
                                t = a.следщ.syntaxCopy();
                            }
                            else if (t.ty == AST.Taarray)
                            {
                                // The index Выражение is a Тип. It will be interpreted as an Выражение at semantic time.
                                AST.TypeAArray a = cast(AST.TypeAArray)t;
                                dimStack.сунь(a.index.syntaxCopy());
                                t = a.следщ.syntaxCopy();
                            }
                            else
                            {
                                break;
                            }
                        }
                        assert(dimStack.dim > 0);
                        // We're good. Replay indices in the reverse order.
                        tid = cast(AST.TypeQualified)t;
                        while (dimStack.dim)
                        {
                            tid.addIndex(dimStack.вынь());
                        }
                        maybeArray = null;
                    }
                    const место = token.место;
                    Идентификатор2 ид = token.идент;
                    nextToken();
                    if (token.значение == ТОК2.not)
                    {
                        auto tempinst = new AST.TemplateInstance(место, ид, parseTemplateArguments());
                        tid.addInst(tempinst);
                    }
                    else
                        tid.addIdent(ид);
                    continue;
                }
            case ТОК2.leftBracket:
                {
                    if (dontLookDotIdents) // workaround for https://issues.dlang.org/show_bug.cgi?ид=14911
                        goto Lend;

                    nextToken();
                    AST.Тип t = maybeArray ? maybeArray : cast(AST.Тип)tid;
                    if (token.значение == ТОК2.rightBracket)
                    {
                        // It's a dynamic массив, and we're done:
                        // T[].U does not make sense.
                        t = new AST.TypeDArray(t);
                        nextToken();
                        return t;
                    }
                    else if (isDeclaration(&token, NeedDeclaratorId.no, ТОК2.rightBracket, null))
                    {
                        // This can be one of two things:
                        //  1 - an associative массив declaration, T[тип]
                        //  2 - an associative массив declaration, T[expr]
                        // These  can only be disambiguated later.
                        AST.Тип index = parseType(); // [ тип ]
                        maybeArray = new AST.TypeAArray(t, index);
                        check(ТОК2.rightBracket);
                    }
                    else
                    {
                        // This can be one of three things:
                        //  1 - an static массив declaration, T[expr]
                        //  2 - a slice, T[expr .. expr]
                        //  3 - a template параметр pack index Выражение, T[expr].U
                        // 1 and 3 can only be disambiguated later.
                        //printf("it's тип[Выражение]\n");
                        inBrackets++;
                        AST.Выражение e = parseAssignExp(); // [ Выражение ]
                        if (token.значение == ТОК2.slice)
                        {
                            // It's a slice, and we're done.
                            nextToken();
                            AST.Выражение e2 = parseAssignExp(); // [ exp .. exp ]
                            t = new AST.TypeSlice(t, e, e2);
                            inBrackets--;
                            check(ТОК2.rightBracket);
                            return t;
                        }
                        else
                        {
                            maybeArray = new AST.TypeSArray(t, e);
                            inBrackets--;
                            check(ТОК2.rightBracket);
                            continue;
                        }
                    }
                    break;
                }
            default:
                goto Lend;
            }
        }
    Lend:
        return maybeArray ? maybeArray : cast(AST.Тип)tid;
    }

    /******************************************
     * Parse things that follow the initial тип t.
     *      t *
     *      t []
     *      t [тип]
     *      t [Выражение]
     *      t [Выражение .. Выражение]
     *      t function
     *      t delegate
     */
    private AST.Тип parseBasicType2(AST.Тип t)
    {
        //printf("parseBasicType2()\n");
        while (1)
        {
            switch (token.значение)
            {
            case ТОК2.mul:
                t = new AST.TypePointer(t);
                nextToken();
                continue;

            case ТОК2.leftBracket:
                // Handle []. Make sure things like
                //     цел[3][1] a;
                // is (массив[1] of массив[3] of цел)
                nextToken();
                if (token.значение == ТОК2.rightBracket)
                {
                    t = new AST.TypeDArray(t); // []
                    nextToken();
                }
                else if (isDeclaration(&token, NeedDeclaratorId.no, ТОК2.rightBracket, null))
                {
                    // It's an associative массив declaration
                    //printf("it's an associative массив\n");
                    AST.Тип index = parseType(); // [ тип ]
                    t = new AST.TypeAArray(t, index);
                    check(ТОК2.rightBracket);
                }
                else
                {
                    //printf("it's тип[Выражение]\n");
                    inBrackets++;
                    AST.Выражение e = parseAssignExp(); // [ Выражение ]
                    if (token.значение == ТОК2.slice)
                    {
                        nextToken();
                        AST.Выражение e2 = parseAssignExp(); // [ exp .. exp ]
                        t = new AST.TypeSlice(t, e, e2);
                    }
                    else
                    {
                        t = new AST.TypeSArray(t, e);
                    }
                    inBrackets--;
                    check(ТОК2.rightBracket);
                }
                continue;

            case ТОК2.delegate_:
            case ТОК2.function_:
                {
                    // Handle delegate declaration:
                    //      t delegate(параметр list)  
                    //      t function(параметр list)  
                    ТОК2 save = token.значение;
                    nextToken();

                    AST.ВарАрг varargs;
                    AST.Параметры* parameters = parseParameters(&varargs);

                    КлассХранения stc = parsePostfix(STC.undefined_, null);
                    auto tf = new AST.TypeFunction(AST.СписокПараметров(parameters, varargs), t, компонаж, stc);
                    if (stc & (STC.const_ | STC.immutable_ | STC.shared_ | STC.wild | STC.return_))
                    {
                        if (save == ТОК2.function_)
                            выведиОшибку("`const`/`const`/`shared`/`inout`/`return` attributes are only valid for non-static member functions");
                        else
                            tf = cast(AST.TypeFunction)tf.addSTC(stc);
                    }
                    t = save == ТОК2.delegate_ ? new AST.TypeDelegate(tf) : new AST.TypePointer(tf); // pointer to function
                    continue;
                }
            default:
                return t;
            }
            assert(0);
        }
        assert(0);
    }

    private AST.Тип parseDeclarator(AST.Тип t, цел* palt, Идентификатор2* pident, AST.ПараметрыШаблона** tpl = null, КлассХранения классХранения = 0, цел* pdisable = null, AST.Выражения** pudas = null)
    {
        //printf("parseDeclarator(tpl = %p)\n", tpl);
        t = parseBasicType2(t);
        AST.Тип ts;
        switch (token.значение)
        {
        case ТОК2.идентификатор:
            if (pident)
                *pident = token.идент;
            else
                выведиОшибку("unexpected идентификатор `%s` in declarator", token.идент.вТкст0());
            ts = t;
            nextToken();
            break;

        case ТОК2.leftParentheses:
            {
                // like: T (*fp)();
                // like: T ((*fp))();
                if (peekNext() == ТОК2.mul || peekNext() == ТОК2.leftParentheses)
                {
                    /* Parse things with parentheses around the идентификатор, like:
                     *  цел (*идент[3])[]
                     * although the D style would be:
                     *  цел[]*[3] идент
                     */
                    *palt |= 1;
                    nextToken();
                    ts = parseDeclarator(t, palt, pident);
                    check(ТОК2.rightParentheses);
                    break;
                }
                ts = t;

                Сема2* peekt = &token;
                /* Completely disallow C-style things like:
                 *   T (a);
                 * Improve error messages for the common bug of a missing return тип
                 * by looking to see if (a) looks like a параметр list.
                 */
                if (isParameters(&peekt))
                {
                    выведиОшибку("function declaration without return тип. (Note that constructors are always named `this`)");
                }
                else
                    выведиОшибку("unexpected `(` in declarator");
                break;
            }
        default:
            ts = t;
            break;
        }

        // parse DeclaratorSuffixes
        while (1)
        {
            switch (token.значение)
            {
                static if (CARRAYDECL)
                {
                    /* Support C style массив syntax:
                     *   цел идент[]
                     * as opposed to D-style:
                     *   цел[] идент
                     */
                case ТОК2.leftBracket:
                    {
                        // This is the old C-style post [] syntax.
                        AST.TypeNext ta;
                        nextToken();
                        if (token.значение == ТОК2.rightBracket)
                        {
                            // It's a dynamic массив
                            ta = new AST.TypeDArray(t); // []
                            nextToken();
                            *palt |= 2;
                        }
                        else if (isDeclaration(&token, NeedDeclaratorId.no, ТОК2.rightBracket, null))
                        {
                            // It's an associative массив
                            //printf("it's an associative массив\n");
                            AST.Тип index = parseType(); // [ тип ]
                            check(ТОК2.rightBracket);
                            ta = new AST.TypeAArray(t, index);
                            *palt |= 2;
                        }
                        else
                        {
                            //printf("It's a static массив\n");
                            AST.Выражение e = parseAssignExp(); // [ Выражение ]
                            ta = new AST.TypeSArray(t, e);
                            check(ТОК2.rightBracket);
                            *palt |= 2;
                        }

                        /* Insert ta into
                         *   ts -> ... -> t
                         * so that
                         *   ts -> ... -> ta -> t
                         */
                        AST.Тип* pt;
                        for (pt = &ts; *pt != t; pt = &(cast(AST.TypeNext)*pt).следщ)
                        {
                        }
                        *pt = ta;
                        continue;
                    }
                }
            case ТОК2.leftParentheses:
                {
                    if (tpl)
                    {
                        Сема2* tk = peekPastParen(&token);
                        if (tk.значение == ТОК2.leftParentheses)
                        {
                            /* Look ahead to see if this is (...)(...),
                             * i.e. a function template declaration
                             */
                            //printf("function template declaration\n");

                            // Gather template параметр list
                            *tpl = parseTemplateParameterList();
                        }
                        else if (tk.значение == ТОК2.assign)
                        {
                            /* or (...) =,
                             * i.e. a variable template declaration
                             */
                            //printf("variable template declaration\n");
                            *tpl = parseTemplateParameterList();
                            break;
                        }
                    }

                    AST.ВарАрг varargs;
                    AST.Параметры* parameters = parseParameters(&varargs);

                    /* Parse const/const/shared/inout///return postfix
                     */
                    // merge префикс storage classes
                    КлассХранения stc = parsePostfix(классХранения, pudas);

                    AST.Тип tf = new AST.TypeFunction(AST.СписокПараметров(parameters, varargs), t, компонаж, stc);
                    tf = tf.addSTC(stc);
                    if (pdisable)
                        *pdisable = stc & STC.disable ? 1 : 0;

                    /* Insert tf into
                     *   ts -> ... -> t
                     * so that
                     *   ts -> ... -> tf -> t
                     */
                    AST.Тип* pt;
                    for (pt = &ts; *pt != t; pt = &(cast(AST.TypeNext)*pt).следщ)
                    {
                    }
                    *pt = tf;
                    break;
                }
            default:
                break;
            }
            break;
        }
        return ts;
    }

    private проц parseStorageClasses(ref КлассХранения класс_хранения, ref LINK link,
        ref бул setAlignment, ref AST.Выражение ealign, ref AST.Выражения* udas)
    {
        КлассХранения stc;
        бул sawLinkage = нет; // seen a компонаж declaration

        while (1)
        {
            switch (token.значение)
            {
            case ТОК2.const_:
                if (peekNext() == ТОК2.leftParentheses)
                    break; // const as тип constructor
                stc = STC.const_; // const as storage class
                goto L1;

            case ТОК2.immutable_:
                if (peekNext() == ТОК2.leftParentheses)
                    break;
                stc = STC.immutable_;
                goto L1;

            case ТОК2.shared_:
                if (peekNext() == ТОК2.leftParentheses)
                    break;
                stc = STC.shared_;
                goto L1;

            case ТОК2.inout_:
                if (peekNext() == ТОК2.leftParentheses)
                    break;
                stc = STC.wild;
                goto L1;

            case ТОК2.static_:
                stc = STC.static_;
                goto L1;

            case ТОК2.final_:
                stc = STC.final_;
                goto L1;

            case ТОК2.auto_:
                stc = STC.auto_;
                goto L1;

            case ТОК2.scope_:
                stc = STC.scope_;
                goto L1;

            case ТОК2.override_:
                stc = STC.override_;
                goto L1;

            case ТОК2.abstract_:
                stc = STC.abstract_;
                goto L1;

            case ТОК2.synchronized_:
                stc = STC.synchronized_;
                goto L1;

            case ТОК2.deprecated_:
                stc = STC.deprecated_;
                goto L1;

            case ТОК2.nothrow_:
                stc = STC.nothrow_;
                goto L1;

            case ТОК2.pure_:
                stc = STC.pure_;
                goto L1;

            case ТОК2.ref_:
                stc = STC.ref_;
                goto L1;

            case ТОК2.gshared:
                stc = STC.gshared;
                goto L1;

            case ТОК2.enum_:
                {
                    const tv = peekNext();
                    if (tv == ТОК2.leftCurly || tv == ТОК2.colon)
                        break;
                    if (tv == ТОК2.идентификатор)
                    {
                        const nextv = peekNext2();
                        if (nextv == ТОК2.leftCurly || nextv == ТОК2.colon || nextv == ТОК2.semicolon)
                            break;
                    }
                    stc = STC.manifest;
                    goto L1;
                }

            case ТОК2.at:
                {
                    stc = parseAttribute(&udas);
                    if (stc)
                        goto L1;
                    continue;
                }
            L1:
                класс_хранения = appendStorageClass(класс_хранения, stc);
                nextToken();
                continue;

            case ТОК2.extern_:
                {
                    if (peekNext() != ТОК2.leftParentheses)
                    {
                        stc = STC.extern_;
                        goto L1;
                    }

                    if (sawLinkage)
                        выведиОшибку("redundant компонаж declaration");
                    sawLinkage = да;
                    AST.Идентификаторы* idents = null;
                    AST.Выражения* identExps = null;
                    CPPMANGLE cppmangle;
                    бул cppMangleOnly = нет;
                    link = parseLinkage(&idents, &identExps, cppmangle, cppMangleOnly);
                    if (idents || identExps)
                    {
                        выведиОшибку("C++ имя spaces not allowed here");
                    }
                    if (cppmangle != CPPMANGLE.def)
                    {
                        выведиОшибку("C++ mangle declaration not allowed here");
                    }
                    continue;
                }
            case ТОК2.align_:
                {
                    nextToken();
                    setAlignment = да;
                    if (token.значение == ТОК2.leftParentheses)
                    {
                        nextToken();
                        ealign = parseВыражение();
                        check(ТОК2.rightParentheses);
                    }
                    continue;
                }
            default:
                break;
            }
            break;
        }
    }

    /**********************************
     * Parse Declarations.
     * These can be:
     *      1. declarations at глоб2/class уровень
     *      2. declarations at инструкция уровень
     * Return массив of Declaration *'s.
     */
    private AST.Дсимволы* parseDeclarations(бул autodecl, PrefixAttributes!(AST)* pAttrs, ткст0 коммент)
    {
        КлассХранения класс_хранения = STC.undefined_;
        ТОК2 tok = ТОК2.reserved;
        LINK link = компонаж;
        бул setAlignment = нет;
        AST.Выражение ealign;
        AST.Выражения* udas = null;

        //printf("parseDeclarations() %s\n", token.вТкст0());
        if (!коммент)
            коммент = token.blockComment.ptr;

        if (token.значение == ТОК2.alias_)
        {
            const место = token.место;
            tok = token.значение;
            nextToken();

            /* Look for:
             *   alias идентификатор this;
             */
            if (token.значение == ТОК2.идентификатор && peekNext() == ТОК2.this_)
            {
                auto s = new AST.AliasThis(место, token.идент);
                nextToken();
                check(ТОК2.this_);
                check(ТОК2.semicolon);
                auto a = new AST.Дсимволы();
                a.сунь(s);
                добавьКоммент(s, коммент);
                return a;
            }
            version (none)
            {
                /* Look for:
                 *  alias this = идентификатор;
                 */
                if (token.значение == ТОК2.this_ && peekNext() == ТОК2.assign && peekNext2() == ТОК2.идентификатор)
                {
                    check(ТОК2.this_);
                    check(ТОК2.assign);
                    auto s = new AliasThis(место, token.идент);
                    nextToken();
                    check(ТОК2.semicolon);
                    auto a = new Дсимволы();
                    a.сунь(s);
                    добавьКоммент(s, коммент);
                    return a;
                }
            }
            /* Look for:
             *  alias идентификатор = тип;
             *  alias идентификатор(...) = тип;
             */
            if (token.значение == ТОК2.идентификатор && hasOptionalParensThen(peek(&token), ТОК2.assign))
            {
                auto a = new AST.Дсимволы();
                while (1)
                {
                    auto идент = token.идент;
                    nextToken();
                    AST.ПараметрыШаблона* tpl = null;
                    if (token.значение == ТОК2.leftParentheses)
                        tpl = parseTemplateParameterList();
                    check(ТОК2.assign);

                    бул hasParsedAttributes;
                    проц parseAttributes()
                    {
                        if (hasParsedAttributes) // only parse once
                            return;
                        hasParsedAttributes = да;
                        udas = null;
                        класс_хранения = STC.undefined_;
                        link = компонаж;
                        setAlignment = нет;
                        ealign = null;
                        parseStorageClasses(класс_хранения, link, setAlignment, ealign, udas);
                    }

                    if (token.значение == ТОК2.at)
                        parseAttributes;

                    AST.Declaration v;
                    AST.ДСимвол s;

                    // try to parse function тип:
                    // TypeCtors? BasicType ( Параметры ) MemberFunctionAttributes
                    бул attributesAppended;
                    const КлассХранения funcStc = parseTypeCtor();
                    Сема2* tlu = &token;
                    Сема2* tk;
                    if (token.значение != ТОК2.function_ &&
                        token.значение != ТОК2.delegate_ &&
                        isBasicType(&tlu) && tlu &&
                        tlu.значение == ТОК2.leftParentheses)
                    {
                        AST.ВарАрг vargs;
                        AST.Тип tret = parseBasicType();
                        AST.Параметры* prms = parseParameters(&vargs);
                        AST.СписокПараметров pl = AST.СписокПараметров(prms, vargs);

                        parseAttributes();
                        if (udas)
                            выведиОшибку("user-defined attributes not allowed for `alias` declarations");

                        attributesAppended = да;
                        класс_хранения = appendStorageClass(класс_хранения, funcStc);
                        AST.Тип tf = new AST.TypeFunction(pl, tret, link, класс_хранения);
                        v = new AST.AliasDeclaration(место, идент, tf);
                    }
                    else if (token.значение == ТОК2.function_ ||
                        token.значение == ТОК2.delegate_ ||
                        token.значение == ТОК2.leftParentheses &&
                            skipAttributes(peekPastParen(&token), &tk) &&
                            (tk.значение == ТОК2.goesTo || tk.значение == ТОК2.leftCurly) ||
                        token.значение == ТОК2.leftCurly ||
                        token.значение == ТОК2.идентификатор && peekNext() == ТОК2.goesTo ||
                        token.значение == ТОК2.ref_ && peekNext() == ТОК2.leftParentheses &&
                            skipAttributes(peekPastParen(peek(&token)), &tk) &&
                            (tk.значение == ТОК2.goesTo || tk.значение == ТОК2.leftCurly)
                       )
                    {
                        // function (parameters) { statements... }
                        // delegate (parameters) { statements... }
                        // (parameters) { statements... }
                        // (parameters) => Выражение
                        // { statements... }
                        // идентификатор => Выражение
                        // ref (parameters) { statements... }
                        // ref (parameters) => Выражение

                        s = parseFunctionLiteral();

                        if (udas !is null)
                        {
                            if (класс_хранения != 0)
                                выведиОшибку("Cannot put a storage-class in an alias declaration.");
                            // parseAttributes shouldn't have set these variables
                            assert(link == компонаж && !setAlignment && ealign is null);
                            auto tpl_ = cast(AST.TemplateDeclaration) s;
                            assert(tpl_ !is null && tpl_.члены.dim == 1);
                            auto fd = cast(AST.FuncLiteralDeclaration) (*tpl_.члены)[0];
                            auto tf = cast(AST.TypeFunction) fd.тип;
                            assert(tf.parameterList.parameters.dim > 0);
                            auto as = new AST.Дсимволы();
                            (*tf.parameterList.parameters)[0].userAttribDecl = new AST.UserAttributeDeclaration(udas, as);
                        }

                        v = new AST.AliasDeclaration(место, идент, s);
                    }
                    else
                    {
                        parseAttributes();
                        // StorageClasses тип
                        if (udas)
                            выведиОшибку("user-defined attributes not allowed for `%s` declarations", Сема2.вТкст0(tok));

                        auto t = parseType();
                        v = new AST.AliasDeclaration(место, идент, t);
                    }
                    if (!attributesAppended)
                        класс_хранения = appendStorageClass(класс_хранения, funcStc);
                    v.класс_хранения = класс_хранения;

                    s = v;
                    if (tpl)
                    {
                        auto a2 = new AST.Дсимволы();
                        a2.сунь(s);
                        auto tempdecl = new AST.TemplateDeclaration(место, идент, tpl, null, a2);
                        s = tempdecl;
                    }
                    if (link != компонаж)
                    {
                        auto a2 = new AST.Дсимволы();
                        a2.сунь(s);
                        s = new AST.LinkDeclaration(link, a2);
                    }
                    a.сунь(s);

                    switch (token.значение)
                    {
                    case ТОК2.semicolon:
                        nextToken();
                        добавьКоммент(s, коммент);
                        break;

                    case ТОК2.comma:
                        nextToken();
                        добавьКоммент(s, коммент);
                        if (token.значение != ТОК2.идентификатор)
                        {
                            выведиОшибку("идентификатор expected following comma, not `%s`", token.вТкст0());
                            break;
                        }
                        if (peekNext() != ТОК2.assign && peekNext() != ТОК2.leftParentheses)
                        {
                            выведиОшибку("`=` expected following идентификатор");
                            nextToken();
                            break;
                        }
                        continue;

                    default:
                        выведиОшибку("semicolon expected to close `%s` declaration", Сема2.вТкст0(tok));
                        break;
                    }
                    break;
                }
                return a;
            }

            // alias StorageClasses тип идент;
        }

        AST.Тип ts;

        if (!autodecl)
        {
            parseStorageClasses(класс_хранения, link, setAlignment, ealign, udas);

            if (token.значение == ТОК2.enum_)
            {
                AST.ДСимвол d = parseEnum();
                auto a = new AST.Дсимволы();
                a.сунь(d);

                if (udas)
                {
                    d = new AST.UserAttributeDeclaration(udas, a);
                    a = new AST.Дсимволы();
                    a.сунь(d);
                }

                добавьКоммент(d, коммент);
                return a;
            }
            if (token.значение == ТОК2.struct_ ||
                     token.значение == ТОК2.union_ ||
                     token.значение == ТОК2.class_ ||
                     token.значение == ТОК2.interface_)
            {
                AST.ДСимвол s = parseAggregate();
                auto a = new AST.Дсимволы();
                a.сунь(s);

                if (класс_хранения)
                {
                    s = new AST.StorageClassDeclaration(класс_хранения, a);
                    a = new AST.Дсимволы();
                    a.сунь(s);
                }
                if (setAlignment)
                {
                    s = new AST.AlignDeclaration(s.место, ealign, a);
                    a = new AST.Дсимволы();
                    a.сунь(s);
                }
                if (link != компонаж)
                {
                    s = new AST.LinkDeclaration(link, a);
                    a = new AST.Дсимволы();
                    a.сунь(s);
                }
                if (udas)
                {
                    s = new AST.UserAttributeDeclaration(udas, a);
                    a = new AST.Дсимволы();
                    a.сунь(s);
                }

                добавьКоммент(s, коммент);
                return a;
            }

            /* Look for auto initializers:
             *  класс_хранения идентификатор = инициализатор;
             *  класс_хранения идентификатор(...) = инициализатор;
             */
            if ((класс_хранения || udas) && token.значение == ТОК2.идентификатор && hasOptionalParensThen(peek(&token), ТОК2.assign))
            {
                AST.Дсимволы* a = parseAutoDeclarations(класс_хранения, коммент);
                if (udas)
                {
                    AST.ДСимвол s = new AST.UserAttributeDeclaration(udas, a);
                    a = new AST.Дсимволы();
                    a.сунь(s);
                }
                return a;
            }

            /* Look for return тип inference for template functions.
             */
            {
                Сема2* tk;
                if ((класс_хранения || udas) && token.значение == ТОК2.идентификатор && skipParens(peek(&token), &tk) &&
                    skipAttributes(tk, &tk) &&
                    (tk.значение == ТОК2.leftParentheses || tk.значение == ТОК2.leftCurly || tk.значение == ТОК2.in_ || tk.значение == ТОК2.out_ ||
                     tk.значение == ТОК2.do_ || tk.значение == ТОК2.идентификатор && tk.идент == Id._body))
                {
                    version (none)
                    {
                        // This deprecation has been disabled for the time being, see PR10763
                        // @@@DEPRECATED@@@
                        // https://github.com/dlang/DIPs/blob/1f5959abe482b1f9094f6484a7d0a3ade77fc2fc/DIPs/accepted/DIP1003.md
                        // Deprecated in 2.091 - Can be removed from 2.101
                        if (tk.значение == ТОК2.идентификатор && tk.идент == Id._body)
                            deprecation("Использование of the `body` keyword is deprecated. Use `do` instead.");
                    }
                    ts = null;
                }
                else
                {
                    ts = parseBasicType();
                    ts = parseBasicType2(ts);
                }
            }
        }

        if (pAttrs)
        {
            класс_хранения |= pAttrs.классХранения;
            //pAttrs.классХранения = STC.undefined_;
        }

        AST.Тип tfirst = null;
        auto a = new AST.Дсимволы();

        while (1)
        {
            AST.ПараметрыШаблона* tpl = null;
            цел disable;
            цел alt = 0;

            const место = token.место;
            Идентификатор2 идент = null;

            auto t = parseDeclarator(ts, &alt, &идент, &tpl, класс_хранения, &disable, &udas);
            assert(t);
            if (!tfirst)
                tfirst = t;
            else if (t != tfirst)
                выведиОшибку("multiple declarations must have the same тип, not `%s` and `%s`", tfirst.вТкст0(), t.вТкст0());

            бул isThis = (t.ty == AST.Tident && (cast(AST.TypeIdentifier)t).идент == Id.This && token.значение == ТОК2.assign);
            if (идент)
                checkCstyleTypeSyntax(место, t, alt, идент);
            else if (!isThis && (t != AST.Тип.terror))
                выведиОшибку("no идентификатор for declarator `%s`", t.вТкст0());

            if (tok == ТОК2.alias_)
            {
                AST.Declaration v;
                AST.Инициализатор _иниц = null;

                /* Aliases can no longer have multiple declarators, storage classes,
                 * linkages, or auto declarations.
                 * These never made any sense, anyway.
                 * The code below needs to be fixed to reject them.
                 * The grammar has already been fixed to preclude them.
                 */

                if (udas)
                    выведиОшибку("user-defined attributes not allowed for `%s` declarations", Сема2.вТкст0(tok));

                if (token.значение == ТОК2.assign)
                {
                    nextToken();
                    _иниц = parseInitializer();
                }
                if (_иниц)
                {
                    if (isThis)
                        выведиОшибку("cannot use syntax `alias this = %s`, use `alias %s this` instead", _иниц.вТкст0(), _иниц.вТкст0());
                    else
                        выведиОшибку("alias cannot have инициализатор");
                }
                v = new AST.AliasDeclaration(место, идент, t);

                v.класс_хранения = класс_хранения;
                if (pAttrs)
                {
                    /* AliasDeclaration distinguish , @system, attributes
                     * on префикс and postfix.
                     *    alias проц function() FP1;
                     *   alias  проц function() FP2;    // FP2 is not 
                     *   alias проц function()  FP3;
                     */
                    pAttrs.классХранения &= STC.safeGroup;
                }
                AST.ДСимвол s = v;

                if (link != компонаж)
                {
                    auto ax = new AST.Дсимволы();
                    ax.сунь(v);
                    s = new AST.LinkDeclaration(link, ax);
                }
                a.сунь(s);
                switch (token.значение)
                {
                case ТОК2.semicolon:
                    nextToken();
                    добавьКоммент(s, коммент);
                    break;

                case ТОК2.comma:
                    nextToken();
                    добавьКоммент(s, коммент);
                    continue;

                default:
                    выведиОшибку("semicolon expected to close `%s` declaration", Сема2.вТкст0(tok));
                    break;
                }
            }
            else if (t.ty == AST.Tfunction)
            {
                AST.Выражение constraint = null;
                //printf("%s funcdecl t = %s, класс_хранения = x%lx\n", место.вТкст0(), t.вТкст0(), класс_хранения);
                auto f = new AST.FuncDeclaration(место, Место.initial, идент, класс_хранения | (disable ? STC.disable : 0), t);
                if (pAttrs)
                    pAttrs.классХранения = STC.undefined_;
                if (tpl)
                    constraint = parseConstraint();
                AST.ДСимвол s = parseContracts(f);
                auto tplIdent = s.идент;

                if (link != компонаж)
                {
                    auto ax = new AST.Дсимволы();
                    ax.сунь(s);
                    s = new AST.LinkDeclaration(link, ax);
                }
                if (udas)
                {
                    auto ax = new AST.Дсимволы();
                    ax.сунь(s);
                    s = new AST.UserAttributeDeclaration(udas, ax);
                }

                /* A template параметр list means it's a function template
                 */
                if (tpl)
                {
                    // Wrap a template around the function declaration
                    auto decldefs = new AST.Дсимволы();
                    decldefs.сунь(s);
                    auto tempdecl = new AST.TemplateDeclaration(место, tplIdent, tpl, constraint, decldefs);
                    s = tempdecl;

                    if (класс_хранения & STC.static_)
                    {
                        assert(f.класс_хранения & STC.static_);
                        f.класс_хранения &= ~STC.static_;
                        auto ax = new AST.Дсимволы();
                        ax.сунь(s);
                        s = new AST.StorageClassDeclaration(STC.static_, ax);
                    }
                }
                a.сунь(s);
                добавьКоммент(s, коммент);
            }
            else if (идент)
            {
                AST.Инициализатор _иниц = null;
                if (token.значение == ТОК2.assign)
                {
                    nextToken();
                    _иниц = parseInitializer();
                }

                auto v = new AST.VarDeclaration(место, t, идент, _иниц);
                v.класс_хранения = класс_хранения;
                if (pAttrs)
                    pAttrs.классХранения = STC.undefined_;

                AST.ДСимвол s = v;

                if (tpl && _иниц)
                {
                    auto a2 = new AST.Дсимволы();
                    a2.сунь(s);
                    auto tempdecl = new AST.TemplateDeclaration(место, идент, tpl, null, a2, 0);
                    s = tempdecl;
                }
                if (setAlignment)
                {
                    auto ax = new AST.Дсимволы();
                    ax.сунь(s);
                    s = new AST.AlignDeclaration(v.место, ealign, ax);
                }
                if (link != компонаж)
                {
                    auto ax = new AST.Дсимволы();
                    ax.сунь(s);
                    s = new AST.LinkDeclaration(link, ax);
                }
                if (udas)
                {
                    auto ax = new AST.Дсимволы();
                    ax.сунь(s);
                    s = new AST.UserAttributeDeclaration(udas, ax);
                }
                a.сунь(s);
                switch (token.значение)
                {
                case ТОК2.semicolon:
                    nextToken();
                    добавьКоммент(s, коммент);
                    break;

                case ТОК2.comma:
                    nextToken();
                    добавьКоммент(s, коммент);
                    continue;

                default:
                    выведиОшибку("semicolon expected, not `%s`", token.вТкст0());
                    break;
                }
            }
            break;
        }
        return a;
    }

    private AST.ДСимвол parseFunctionLiteral()
    {
        const место = token.место;
        AST.ПараметрыШаблона* tpl = null;
        AST.Параметры* parameters = null;
        AST.ВарАрг varargs = AST.ВарАрг.none;
        AST.Тип tret = null;
        КлассХранения stc = 0;
        ТОК2 save = ТОК2.reserved;

        switch (token.значение)
        {
        case ТОК2.function_:
        case ТОК2.delegate_:
            save = token.значение;
            nextToken();
            if (token.значение == ТОК2.ref_)
            {
                // function ref (parameters) { statements... }
                // delegate ref (parameters) { statements... }
                stc = STC.ref_;
                nextToken();
            }
            if (token.значение != ТОК2.leftParentheses && token.значение != ТОК2.leftCurly)
            {
                // function тип (parameters) { statements... }
                // delegate тип (parameters) { statements... }
                tret = parseBasicType();
                tret = parseBasicType2(tret); // function return тип
            }

            if (token.значение == ТОК2.leftParentheses)
            {
                // function (parameters) { statements... }
                // delegate (parameters) { statements... }
            }
            else
            {
                // function { statements... }
                // delegate { statements... }
                break;
            }
            goto case ТОК2.leftParentheses;

        case ТОК2.ref_:
            {
                // ref (parameters) => Выражение
                // ref (parameters) { statements... }
                stc = STC.ref_;
                nextToken();
                goto case ТОК2.leftParentheses;
            }
        case ТОК2.leftParentheses:
            {
                // (parameters) => Выражение
                // (parameters) { statements... }
                parameters = parseParameters(&varargs, &tpl);
                stc = parsePostfix(stc, null);
                if (КлассХранения modStc = stc & STC.TYPECTOR)
                {
                    if (save == ТОК2.function_)
                    {
                        БуфВыв буф;
                        AST.stcToBuffer(&буф, modStc);
                        выведиОшибку("function literal cannot be `%s`", буф.peekChars());
                    }
                    else
                        save = ТОК2.delegate_;
                }
                break;
            }
        case ТОК2.leftCurly:
            // { statements... }
            break;

        case ТОК2.идентификатор:
            {
                // идентификатор => Выражение
                parameters = new AST.Параметры();
                Идентификатор2 ид = Идентификатор2.генерируйИд("__T");
                AST.Тип t = new AST.TypeIdentifier(место, ид);
                parameters.сунь(new AST.Параметр2(0, t, token.идент, null, null));

                tpl = new AST.ПараметрыШаблона();
                AST.ПараметрШаблона2 tp = new AST.TemplateTypeParameter(место, ид, null, null);
                tpl.сунь(tp);

                nextToken();
                break;
            }
        default:
            assert(0);
        }

        auto tf = new AST.TypeFunction(AST.СписокПараметров(parameters, varargs), tret, компонаж, stc);
        tf = cast(AST.TypeFunction)tf.addSTC(stc);
        auto fd = new AST.FuncLiteralDeclaration(место, Место.initial, tf, save, null);

        if (token.значение == ТОК2.goesTo)
        {
            check(ТОК2.goesTo);
            const returnloc = token.место;
            AST.Выражение ae = parseAssignExp();
            fd.fbody = new AST.ReturnStatement(returnloc, ae);
            fd.endloc = token.место;
        }
        else
        {
            parseContracts(fd);
        }

        if (tpl)
        {
            // Wrap a template around function fd
            auto decldefs = new AST.Дсимволы();
            decldefs.сунь(fd);
            return new AST.TemplateDeclaration(fd.место, fd.идент, tpl, null, decldefs, нет, да);
        }
        return fd;
    }

    /*****************************************
     * Parse contracts following function declaration.
     */
    private AST.FuncDeclaration parseContracts(AST.FuncDeclaration f)
    {
        LINK linksave = компонаж;

        бул literal = f.isFuncLiteralDeclaration() !is null;

        // The following is irrelevant, as it is overridden by sc.компонаж in
        // TypeFunction::semantic
        компонаж = LINK.d; // nested functions have D компонаж
        бул requireDo = нет;
    L1:
        switch (token.значение)
        {
        case ТОК2.leftCurly:
            if (requireDo)
                выведиОшибку("missing `do { ... }` after `in` or `out`");
            f.fbody = parseStatement(ParseStatementFlags.semi);
            f.endloc = endloc;
            break;

        case ТОК2.идентификатор:
            if (token.идент == Id._body)
            {
                version (none)
                {
                    // This deprecation has been disabled for the time being, see PR10763
                    // @@@DEPRECATED@@@
                    // https://github.com/dlang/DIPs/blob/1f5959abe482b1f9094f6484a7d0a3ade77fc2fc/DIPs/accepted/DIP1003.md
                    // Deprecated in 2.091 - Can be removed from 2.101
                    deprecation("Использование of the `body` keyword is deprecated. Use `do` instead.");
                }
                goto case ТОК2.do_;
            }
            goto default;

        case ТОК2.do_:
            nextToken();
            f.fbody = parseStatement(ParseStatementFlags.curly);
            f.endloc = endloc;
            break;

            version (none)
            {
                // Do we want this for function declarations, so we can do:
                // цел x, y, foo(), z;
            case ТОК2.comma:
                nextToken();
                continue;
            }

        case ТОК2.in_:
            // in { statements... }
            // in (Выражение)
            auto место = token.место;
            nextToken();
            if (!f.frequires)
            {
                f.frequires = new AST.Инструкции;
            }
            if (token.значение == ТОК2.leftParentheses)
            {
                nextToken();
                AST.Выражение e = parseAssignExp(), msg = null;
                if (token.значение == ТОК2.comma)
                {
                    nextToken();
                    if (token.значение != ТОК2.rightParentheses)
                    {
                        msg = parseAssignExp();
                        if (token.значение == ТОК2.comma)
                            nextToken();
                    }
                }
                check(ТОК2.rightParentheses);
                e = new AST.AssertExp(место, e, msg);
                f.frequires.сунь(new AST.ExpStatement(место, e));
                requireDo = нет;
            }
            else
            {
                f.frequires.сунь(parseStatement(ParseStatementFlags.curly | ParseStatementFlags.scope_));
                requireDo = да;
            }
            goto L1;

        case ТОК2.out_:
            // out { statements... }
            // out (; Выражение)
            // out (идентификатор) { statements... }
            // out (идентификатор; Выражение)
            auto место = token.место;
            nextToken();
            if (!f.fensures)
            {
                f.fensures = new AST.Гаранты;
            }
            Идентификатор2 ид = null;
            if (token.значение != ТОК2.leftCurly)
            {
                check(ТОК2.leftParentheses);
                if (token.значение != ТОК2.идентификатор && token.значение != ТОК2.semicolon)
                    выведиОшибку("`(идентификатор) { ... }` or `(идентификатор; Выражение)` following `out` expected, not `%s`", token.вТкст0());
                if (token.значение != ТОК2.semicolon)
                {
                    ид = token.идент;
                    nextToken();
                }
                if (token.значение == ТОК2.semicolon)
                {
                    nextToken();
                    AST.Выражение e = parseAssignExp(), msg = null;
                    if (token.значение == ТОК2.comma)
                    {
                        nextToken();
                        if (token.значение != ТОК2.rightParentheses)
                        {
                            msg = parseAssignExp();
                            if (token.значение == ТОК2.comma)
                                nextToken();
                        }
                    }
                    check(ТОК2.rightParentheses);
                    e = new AST.AssertExp(место, e, msg);
                    f.fensures.сунь(AST.Гарант(ид, new AST.ExpStatement(место, e)));
                    requireDo = нет;
                    goto L1;
                }
                check(ТОК2.rightParentheses);
            }
            f.fensures.сунь(AST.Гарант(ид, parseStatement(ParseStatementFlags.curly | ParseStatementFlags.scope_)));
            requireDo = да;
            goto L1;

        case ТОК2.semicolon:
            if (!literal)
            {
                // https://issues.dlang.org/show_bug.cgi?ид=15799
                // Semicolon becomes a part of function declaration
                // only when 'do' is not required
                if (!requireDo)
                    nextToken();
                break;
            }
            goto default;

        default:
            if (literal)
            {
                ткст0 sbody = requireDo ? "do " : "";
                выведиОшибку("missing `%s{ ... }` for function literal", sbody);
            }
            else if (!requireDo) // allow contracts even with no body
            {
                ТОК2 t = token.значение;
                if (t == ТОК2.const_ || t == ТОК2.immutable_ || t == ТОК2.inout_ || t == ТОК2.return_ ||
                        t == ТОК2.shared_ || t == ТОК2.nothrow_ || t == ТОК2.pure_)
                    выведиОшибку("'%s' cannot be placed after a template constraint", token.вТкст0);
                else if (t == ТОК2.at)
                    выведиОшибку("attributes cannot be placed after a template constraint");
                else if (t == ТОК2.if_)
                    выведиОшибку("cannot use function constraints for non-template functions. Use `static if` instead");
                else
                    выведиОшибку("semicolon expected following function declaration");
            }
            break;
        }
        if (literal && !f.fbody)
        {
            // Set empty function body for error recovery
            f.fbody = new AST.CompoundStatement(Место.initial, cast(AST.Инструкция2)null);
        }

        компонаж = linksave;

        return f;
    }

    /*****************************************
     */
    private проц checkDanglingElse(Место elseloc)
    {
        if (token.значение != ТОК2.else_ && token.значение != ТОК2.catch_ && token.значение != ТОК2.finally_ && lookingForElse.номстр != 0)
        {
            warning(elseloc, "else is dangling, add { } after условие at %s", lookingForElse.вТкст0());
        }
    }

    private проц checkCstyleTypeSyntax(Место место, AST.Тип t, цел alt, Идентификатор2 идент)
    {
        if (!alt)
            return;

        ткст0 sp = !идент ? "" : " ";
        ткст0 s = !идент ? "" : идент.вТкст0();
        выведиОшибку(место, "instead of C-style syntax, use D-style `%s%s%s`", t.вТкст0(), sp, s);
    }

    /*****************************************
     * Determines additional argument types for parseForeach.
     */
    private template ParseForeachArgs(бул isStatic, бул isDecl)
    {
        static alias T Seq(T...);
        static if(isDecl)
        {
            alias Seq!(AST.ДСимвол*) ParseForeachArgs;
        }
        else
        {
            alias  Seq!() ParseForeachArgs;
        }
    }
    /*****************************************
     * Determines the результат тип for parseForeach.
     */
    private template ParseForeachRet(бул isStatic, бул isDecl)
    {
        static if(!isStatic)
        {
            alias AST.Инструкция2 ParseForeachRet;
        }
        else static if(isDecl)
        {
            alias  AST.StaticForeachDeclaration ParseForeachRet;
        }
        else
        {
            alias AST.StaticForeachStatement ParseForeachRet;
        }
    }
    /*****************************************
     * Parses `foreach` statements, `static foreach` statements and
     * `static foreach` declarations.  The template параметр
     * `isStatic` is да, iff a `static foreach` should be parsed.
     * If `isStatic` is да, `isDecl` can be да to indicate that a
     * `static foreach` declaration should be parsed.
     */
    private ParseForeachRet!(isStatic, isDecl) parseForeach(бул isStatic, бул isDecl)(Место место, ParseForeachArgs!(isStatic, isDecl) args)
    {
        static if(isDecl)
        {
            static assert(isStatic);
        }
        static if(isStatic)
        {
            nextToken();
            static if(isDecl) auto pLastDecl = args[0];
        }

        ТОК2 op = token.значение;

        nextToken();
        check(ТОК2.leftParentheses);

        auto parameters = new AST.Параметры();
        while (1)
        {
            Идентификатор2 ai = null;
            AST.Тип at;

            КлассХранения классХранения = 0;
            КлассХранения stc = 0;
        Lagain:
            if (stc)
            {
                классХранения = appendStorageClass(классХранения, stc);
                nextToken();
            }
            switch (token.значение)
            {
                case ТОК2.ref_:
                    stc = STC.ref_;
                    goto Lagain;

                case ТОК2.enum_:
                    stc = STC.manifest;
                    goto Lagain;

                case ТОК2.alias_:
                    классХранения = appendStorageClass(классХранения, STC.alias_);
                    nextToken();
                    break;

                case ТОК2.const_:
                    if (peekNext() != ТОК2.leftParentheses)
                    {
                        stc = STC.const_;
                        goto Lagain;
                    }
                    break;

                case ТОК2.immutable_:
                    if (peekNext() != ТОК2.leftParentheses)
                    {
                        stc = STC.immutable_;
                        goto Lagain;
                    }
                    break;

                case ТОК2.shared_:
                    if (peekNext() != ТОК2.leftParentheses)
                    {
                        stc = STC.shared_;
                        goto Lagain;
                    }
                    break;

                case ТОК2.inout_:
                    if (peekNext() != ТОК2.leftParentheses)
                    {
                        stc = STC.wild;
                        goto Lagain;
                    }
                    break;

                default:
                    break;
            }
            if (token.значение == ТОК2.идентификатор)
            {
                const tv = peekNext();
                if (tv == ТОК2.comma || tv == ТОК2.semicolon)
                {
                    ai = token.идент;
                    at = null; // infer argument тип
                    nextToken();
                    goto Larg;
                }
            }
            at = parseType(&ai);
            if (!ai)
                выведиОшибку("no идентификатор for declarator `%s`", at.вТкст0());
        Larg:
            auto p = new AST.Параметр2(классХранения, at, ai, null, null);
            parameters.сунь(p);
            if (token.значение == ТОК2.comma)
            {
                nextToken();
                continue;
            }
            break;
        }
        check(ТОК2.semicolon);

        AST.Выражение aggr = parseВыражение();
        if (token.значение == ТОК2.slice && parameters.dim == 1)
        {
            AST.Параметр2 p = (*parameters)[0];
            nextToken();
            AST.Выражение upr = parseВыражение();
            check(ТОК2.rightParentheses);
            Место endloc;
            static if (!isDecl)
            {
                AST.Инструкция2 _body = parseStatement(0, null, &endloc);
            }
            else
            {
                AST.Инструкция2 _body = null;
            }
            auto rangefe = new AST.ForeachRangeStatement(место, op, p, aggr, upr, _body, endloc);
            static if (!isStatic)
            {
                return rangefe;
            }
            else static if(isDecl)
            {
                return new AST.StaticForeachDeclaration(new AST.StaticForeach(место, null, rangefe), parseBlock(pLastDecl));
            }
            else
            {
                return new AST.StaticForeachStatement(место, new AST.StaticForeach(место, null, rangefe));
            }
        }
        else
        {
            check(ТОК2.rightParentheses);
            Место endloc;
            static if (!isDecl)
            {
                AST.Инструкция2 _body = parseStatement(0, null, &endloc);
            }
            else
            {
                AST.Инструкция2 _body = null;
            }
            auto aggrfe = new AST.ForeachStatement(место, op, parameters, aggr, _body, endloc);
            static if(!isStatic)
            {
                return aggrfe;
            }
            else static if(isDecl)
            {
                return new AST.StaticForeachDeclaration(new AST.StaticForeach(место, aggrfe, null), parseBlock(pLastDecl));
            }
            else
            {
                return new AST.StaticForeachStatement(место, new AST.StaticForeach(место, aggrfe, null));
            }
        }

    }

    /*****************************************
     * Input:
     *      flags   PSxxxx
     * Output:
     *      pEndloc if { ... statements ... }, store location of closing brace, otherwise место of last token of инструкция
     */
    AST.Инструкция2 parseStatement(цел flags, сим** endPtr = null, Место* pEndloc = null)
    {
        AST.Инструкция2 s;
        AST.Condition cond;
        AST.Инструкция2 ifbody;
        AST.Инструкция2 elsebody;
        бул isfinal;
        const место = token.место;

        //printf("parseStatement()\n");
        if (flags & ParseStatementFlags.curly && token.значение != ТОК2.leftCurly)
            выведиОшибку("инструкция expected to be `{ }`, not `%s`", token.вТкст0());

        switch (token.значение)
        {
        case ТОК2.идентификатор:
            {
                /* A leading идентификатор can be a declaration, label, or Выражение.
                 * The easiest case to check first is label:
                 */
                if (peekNext() == ТОК2.colon)
                {
                    if (peekNext2() == ТОК2.colon)
                    {
                        // skip идент::
                        nextToken();
                        nextToken();
                        nextToken();
                        выведиОшибку("use `.` for member lookup, not `::`");
                        break;
                    }
                    // It's a label
                    Идентификатор2 идент = token.идент;
                    nextToken();
                    nextToken();
                    if (token.значение == ТОК2.rightCurly)
                        s = null;
                    else if (token.значение == ТОК2.leftCurly)
                        s = parseStatement(ParseStatementFlags.curly | ParseStatementFlags.scope_);
                    else
                        s = parseStatement(ParseStatementFlags.semiOk);
                    s = new AST.LabelStatement(место, идент, s);
                    break;
                }
                goto case ТОК2.dot;
            }
        case ТОК2.dot:
        case ТОК2.typeof_:
        case ТОК2.vector:
        case ТОК2.traits:
            /* https://issues.dlang.org/show_bug.cgi?ид=15163
             * If tokens can be handled as
             * old C-style declaration or D Выражение, prefer the latter.
             */
            if (isDeclaration(&token, NeedDeclaratorId.mustIfDstyle, ТОК2.reserved, null))
                goto Ldeclaration;
            goto Lexp;

        case ТОК2.assert_:
        case ТОК2.this_:
        case ТОК2.super_:
        case ТОК2.int32Literal:
        case ТОК2.uns32Literal:
        case ТОК2.int64Literal:
        case ТОК2.uns64Literal:
        case ТОК2.int128Literal:
        case ТОК2.uns128Literal:
        case ТОК2.float32Literal:
        case ТОК2.float64Literal:
        case ТОК2.float80Literal:
        case ТОК2.imaginary32Literal:
        case ТОК2.imaginary64Literal:
        case ТОК2.imaginary80Literal:
        case ТОК2.charLiteral:
        case ТОК2.wcharLiteral:
        case ТОК2.dcharLiteral:
        case ТОК2.null_:
        case ТОК2.true_:
        case ТОК2.false_:
        case ТОК2.string_:
        case ТОК2.hexadecimalString:
        case ТОК2.leftParentheses:
        case ТОК2.cast_:
        case ТОК2.mul:
        case ТОК2.min:
        case ТОК2.add:
        case ТОК2.tilde:
        case ТОК2.not:
        case ТОК2.plusPlus:
        case ТОК2.minusMinus:
        case ТОК2.new_:
        case ТОК2.delete_:
        case ТОК2.delegate_:
        case ТОК2.function_:
        case ТОК2.typeid_:
        case ТОК2.is_:
        case ТОК2.leftBracket:
        case ТОК2.файл:
        case ТОК2.fileFullPath:
        case ТОК2.line:
        case ТОК2.moduleString:
        case ТОК2.functionString:
        case ТОК2.prettyFunction:
        Lexp:
            {
                AST.Выражение exp = parseВыражение();
                check(ТОК2.semicolon, "инструкция");
                s = new AST.ExpStatement(место, exp);
                break;
            }
        case ТОК2.static_:
            {
                // Look ahead to see if it's static assert() or static if()
                const tv = peekNext();
                if (tv == ТОК2.assert_)
                {
                    s = new AST.StaticAssertStatement(parseStaticAssert());
                    break;
                }
                if (tv == ТОК2.if_)
                {
                    cond = parseStaticIfCondition();
                    goto Lcondition;
                }
                if (tv == ТОК2.foreach_ || tv == ТОК2.foreach_reverse_)
                {
                    s = parseForeach!(да,нет)(место);
                    if (flags & ParseStatementFlags.scope_)
                        s = new AST.ScopeStatement(место, s, token.место);
                    break;
                }
                if (tv == ТОК2.import_)
                {
                    AST.Дсимволы* imports = parseImport();
                    s = new AST.ImportStatement(место, imports);
                    if (flags & ParseStatementFlags.scope_)
                        s = new AST.ScopeStatement(место, s, token.место);
                    break;
                }
                goto Ldeclaration;
            }
        case ТОК2.final_:
            if (peekNext() == ТОК2.switch_)
            {
                nextToken();
                isfinal = да;
                goto Lswitch;
            }
            goto Ldeclaration;

        case ТОК2.wchar_:
        case ТОК2.dchar_:
        case ТОК2.бул_:
        case ТОК2.char_:
        case ТОК2.int8:
        case ТОК2.uns8:
        case ТОК2.int16:
        case ТОК2.uns16:
        case ТОК2.int32:
        case ТОК2.uns32:
        case ТОК2.int64:
        case ТОК2.uns64:
        case ТОК2.int128:
        case ТОК2.uns128:
        case ТОК2.float32:
        case ТОК2.float64:
        case ТОК2.float80:
        case ТОК2.imaginary32:
        case ТОК2.imaginary64:
        case ТОК2.imaginary80:
        case ТОК2.complex32:
        case ТОК2.complex64:
        case ТОК2.complex80:
        case ТОК2.void_:
            // bug 7773: цел.max is always a part of Выражение
            if (peekNext() == ТОК2.dot)
                goto Lexp;
            if (peekNext() == ТОК2.leftParentheses)
                goto Lexp;
            goto case;

        case ТОК2.alias_:
        case ТОК2.const_:
        case ТОК2.auto_:
        case ТОК2.abstract_:
        case ТОК2.extern_:
        case ТОК2.align_:
        case ТОК2.immutable_:
        case ТОК2.shared_:
        case ТОК2.inout_:
        case ТОК2.deprecated_:
        case ТОК2.nothrow_:
        case ТОК2.pure_:
        case ТОК2.ref_:
        case ТОК2.gshared:
        case ТОК2.at:
        case ТОК2.struct_:
        case ТОК2.union_:
        case ТОК2.class_:
        case ТОК2.interface_:
        Ldeclaration:
            {
                AST.Дсимволы* a = parseDeclarations(нет, null, null);
                if (a.dim > 1)
                {
                    auto as = new AST.Инструкции();
                    as.резервируй(a.dim);
                    foreach (i; new бцел[0 .. a.dim])
                    {
                        AST.ДСимвол d = (*a)[i];
                        s = new AST.ExpStatement(место, d);
                        as.сунь(s);
                    }
                    s = new AST.CompoundDeclarationStatement(место, as);
                }
                else if (a.dim == 1)
                {
                    AST.ДСимвол d = (*a)[0];
                    s = new AST.ExpStatement(место, d);
                }
                else
                    s = new AST.ExpStatement(место, cast(AST.Выражение)null);
                if (flags & ParseStatementFlags.scope_)
                    s = new AST.ScopeStatement(место, s, token.место);
                break;
            }
        case ТОК2.enum_:
            {
                /* Determine if this is a manifest constant declaration,
                 * or a conventional enum.
                 */
                AST.ДСимвол d;
                const tv = peekNext();
                if (tv == ТОК2.leftCurly || tv == ТОК2.colon)
                    d = parseEnum();
                else if (tv != ТОК2.идентификатор)
                    goto Ldeclaration;
                else
                {
                    const nextv = peekNext2();
                    if (nextv == ТОК2.leftCurly || nextv == ТОК2.colon || nextv == ТОК2.semicolon)
                        d = parseEnum();
                    else
                        goto Ldeclaration;
                }
                s = new AST.ExpStatement(место, d);
                if (flags & ParseStatementFlags.scope_)
                    s = new AST.ScopeStatement(место, s, token.место);
                break;
            }
        case ТОК2.mixin_:
            {
                if (isDeclaration(&token, NeedDeclaratorId.mustIfDstyle, ТОК2.reserved, null))
                    goto Ldeclaration;
                if (peekNext() == ТОК2.leftParentheses)
                {
                    // mixin(ткст)
                    AST.Выражение e = parseAssignExp();
                    check(ТОК2.semicolon);
                    if (e.op == ТОК2.mixin_)
                    {
                        AST.CompileExp cpe = cast(AST.CompileExp)e;
                        s = new AST.CompileStatement(место, cpe.exps);
                    }
                    else
                    {
                        s = new AST.ExpStatement(место, e);
                    }
                    break;
                }
                AST.ДСимвол d = parseMixin();
                s = new AST.ExpStatement(место, d);
                if (flags & ParseStatementFlags.scope_)
                    s = new AST.ScopeStatement(место, s, token.место);
                break;
            }
        case ТОК2.leftCurly:
            {
                const lookingForElseSave = lookingForElse;
                lookingForElse = Место.initial;

                nextToken();
                //if (token.значение == ТОК2.semicolon)
                //    выведиОшибку("use `{ }` for an empty инструкция, not `;`");
                auto statements = new AST.Инструкции();
                while (token.значение != ТОК2.rightCurly && token.значение != ТОК2.endOfFile)
                {
                    statements.сунь(parseStatement(ParseStatementFlags.semi | ParseStatementFlags.curlyScope));
                }
                if (endPtr)
                    *endPtr = token.ptr;
                endloc = token.место;
                if (pEndloc)
                {
                    *pEndloc = token.место;
                    pEndloc = null; // don't set it again
                }
                s = new AST.CompoundStatement(место, statements);
                if (flags & (ParseStatementFlags.scope_ | ParseStatementFlags.curlyScope))
                    s = new AST.ScopeStatement(место, s, token.место);
                check(ТОК2.rightCurly, "compound инструкция");
                lookingForElse = lookingForElseSave;
                break;
            }
        case ТОК2.while_:
            {
                nextToken();
                check(ТОК2.leftParentheses);
                AST.Выражение условие = parseВыражение();
                check(ТОК2.rightParentheses);
                Место endloc;
                AST.Инструкция2 _body = parseStatement(ParseStatementFlags.scope_, null, &endloc);
                s = new AST.WhileStatement(место, условие, _body, endloc);
                break;
            }
        case ТОК2.semicolon:
            if (!(flags & ParseStatementFlags.semiOk))
            {
                if (flags & ParseStatementFlags.semi)
                    deprecation("use `{ }` for an empty инструкция, not `;`");
                else
                    выведиОшибку("use `{ }` for an empty инструкция, not `;`");
            }
            nextToken();
            s = new AST.ExpStatement(место, cast(AST.Выражение)null);
            break;

        case ТОК2.do_:
            {
                AST.Инструкция2 _body;
                AST.Выражение условие;

                nextToken();
                const lookingForElseSave = lookingForElse;
                lookingForElse = Место.initial;
                _body = parseStatement(ParseStatementFlags.scope_);
                lookingForElse = lookingForElseSave;
                check(ТОК2.while_);
                check(ТОК2.leftParentheses);
                условие = parseВыражение();
                check(ТОК2.rightParentheses);
                if (token.значение == ТОК2.semicolon)
                    nextToken();
                else
                    выведиОшибку("terminating `;` required after do-while инструкция");
                s = new AST.DoStatement(место, _body, условие, token.место);
                break;
            }
        case ТОК2.for_:
            {
                AST.Инструкция2 _иниц;
                AST.Выражение условие;
                AST.Выражение increment;

                nextToken();
                check(ТОК2.leftParentheses);
                if (token.значение == ТОК2.semicolon)
                {
                    _иниц = null;
                    nextToken();
                }
                else
                {
                    const lookingForElseSave = lookingForElse;
                    lookingForElse = Место.initial;
                    _иниц = parseStatement(0);
                    lookingForElse = lookingForElseSave;
                }
                if (token.значение == ТОК2.semicolon)
                {
                    условие = null;
                    nextToken();
                }
                else
                {
                    условие = parseВыражение();
                    check(ТОК2.semicolon, "`for` условие");
                }
                if (token.значение == ТОК2.rightParentheses)
                {
                    increment = null;
                    nextToken();
                }
                else
                {
                    increment = parseВыражение();
                    check(ТОК2.rightParentheses);
                }
                Место endloc;
                AST.Инструкция2 _body = parseStatement(ParseStatementFlags.scope_, null, &endloc);
                s = new AST.ForStatement(место, _иниц, условие, increment, _body, endloc);
                break;
            }
        case ТОК2.foreach_:
        case ТОК2.foreach_reverse_:
            {
                s = parseForeach!(нет,нет)(место);
                break;
            }
        case ТОК2.if_:
            {
                AST.Параметр2 param = null;
                AST.Выражение условие;

                nextToken();
                check(ТОК2.leftParentheses);

                КлассХранения классХранения = 0;
                КлассХранения stc = 0;
            LagainStc:
                if (stc)
                {
                    классХранения = appendStorageClass(классХранения, stc);
                    nextToken();
                }
                switch (token.значение)
                {
                case ТОК2.ref_:
                    stc = STC.ref_;
                    goto LagainStc;

                case ТОК2.auto_:
                    stc = STC.auto_;
                    goto LagainStc;

                case ТОК2.const_:
                    if (peekNext() != ТОК2.leftParentheses)
                    {
                        stc = STC.const_;
                        goto LagainStc;
                    }
                    break;

                case ТОК2.immutable_:
                    if (peekNext() != ТОК2.leftParentheses)
                    {
                        stc = STC.immutable_;
                        goto LagainStc;
                    }
                    break;

                case ТОК2.shared_:
                    if (peekNext() != ТОК2.leftParentheses)
                    {
                        stc = STC.shared_;
                        goto LagainStc;
                    }
                    break;

                case ТОК2.inout_:
                    if (peekNext() != ТОК2.leftParentheses)
                    {
                        stc = STC.wild;
                        goto LagainStc;
                    }
                    break;

                default:
                    break;
                }
                auto n = peek(&token);
                if (классХранения != 0 && token.значение == ТОК2.идентификатор &&
                    n.значение != ТОК2.assign && n.значение != ТОК2.идентификатор)
                {
                    выведиОшибку("found `%s` while expecting `=` or идентификатор", n.вТкст0());
                }
                else if (классХранения != 0 && token.значение == ТОК2.идентификатор && n.значение == ТОК2.assign)
                {
                    Идентификатор2 ai = token.идент;
                    AST.Тип at = null; // infer параметр тип
                    nextToken();
                    check(ТОК2.assign);
                    param = new AST.Параметр2(классХранения, at, ai, null, null);
                }
                else if (isDeclaration(&token, NeedDeclaratorId.must, ТОК2.assign, null))
                {
                    Идентификатор2 ai;
                    AST.Тип at = parseType(&ai);
                    check(ТОК2.assign);
                    param = new AST.Параметр2(классХранения, at, ai, null, null);
                }

                условие = parseВыражение();
                check(ТОК2.rightParentheses);
                {
                    const lookingForElseSave = lookingForElse;
                    lookingForElse = место;
                    ifbody = parseStatement(ParseStatementFlags.scope_);
                    lookingForElse = lookingForElseSave;
                }
                if (token.значение == ТОК2.else_)
                {
                    const elseloc = token.место;
                    nextToken();
                    elsebody = parseStatement(ParseStatementFlags.scope_);
                    checkDanglingElse(elseloc);
                }
                else
                    elsebody = null;
                if (условие && ifbody)
                    s = new AST.IfStatement(место, param, условие, ifbody, elsebody, token.место);
                else
                    s = null; // don't propagate parsing errors
                break;
            }

        case ТОК2.else_:
            выведиОшибку("found `else` without a corresponding `if`, `version` or `debug` инструкция");
            goto Lerror;

        case ТОК2.scope_:
            if (peekNext() != ТОК2.leftParentheses)
                goto Ldeclaration; // scope используется as storage class
            nextToken();
            check(ТОК2.leftParentheses);
            if (token.значение != ТОК2.идентификатор)
            {
                выведиОшибку("scope идентификатор expected");
                goto Lerror;
            }
            else
            {
                ТОК2 t = ТОК2.onScopeExit;
                Идентификатор2 ид = token.идент;
                if (ид == Id.exit)
                    t = ТОК2.onScopeExit;
                else if (ид == Id.failure)
                    t = ТОК2.onScopeFailure;
                else if (ид == Id.успех)
                    t = ТОК2.onScopeSuccess;
                else
                    выведиОшибку("valid scope identifiers are `exit`, `failure`, or `успех`, not `%s`", ид.вТкст0());
                nextToken();
                check(ТОК2.rightParentheses);
                AST.Инструкция2 st = parseStatement(ParseStatementFlags.scope_);
                s = new AST.ScopeGuardStatement(место, t, st);
                break;
            }

        case ТОК2.debug_:
            nextToken();
            if (token.значение == ТОК2.assign)
            {
                выведиОшибку("debug conditions can only be declared at module scope");
                nextToken();
                nextToken();
                goto Lerror;
            }
            cond = parseDebugCondition();
            goto Lcondition;

        case ТОК2.version_:
            nextToken();
            if (token.значение == ТОК2.assign)
            {
                выведиОшибку("version conditions can only be declared at module scope");
                nextToken();
                nextToken();
                goto Lerror;
            }
            cond = parseVersionCondition();
            goto Lcondition;

        Lcondition:
            {
                const lookingForElseSave = lookingForElse;
                lookingForElse = место;
                ifbody = parseStatement(0);
                lookingForElse = lookingForElseSave;
            }
            elsebody = null;
            if (token.значение == ТОК2.else_)
            {
                const elseloc = token.место;
                nextToken();
                elsebody = parseStatement(0);
                checkDanglingElse(elseloc);
            }
            s = new AST.ConditionalStatement(место, cond, ifbody, elsebody);
            if (flags & ParseStatementFlags.scope_)
                s = new AST.ScopeStatement(место, s, token.место);
            break;

        case ТОК2.pragma_:
            {
                Идентификатор2 идент;
                AST.Выражения* args = null;
                AST.Инструкция2 _body;

                nextToken();
                check(ТОК2.leftParentheses);
                if (token.значение != ТОК2.идентификатор)
                {
                    выведиОшибку("`pragma(идентификатор)` expected");
                    goto Lerror;
                }
                идент = token.идент;
                nextToken();
                if (token.значение == ТОК2.comma && peekNext() != ТОК2.rightParentheses)
                    args = parseArguments(); // pragma(идентификатор, args...);
                else
                    check(ТОК2.rightParentheses); // pragma(идентификатор);
                if (token.значение == ТОК2.semicolon)
                {
                    nextToken();
                    _body = null;
                }
                else
                    _body = parseStatement(ParseStatementFlags.semi);
                s = new AST.PragmaStatement(место, идент, args, _body);
                break;
            }
        case ТОК2.switch_:
            isfinal = нет;
            goto Lswitch;

        Lswitch:
            {
                nextToken();
                check(ТОК2.leftParentheses);
                AST.Выражение условие = parseВыражение();
                check(ТОК2.rightParentheses);
                AST.Инструкция2 _body = parseStatement(ParseStatementFlags.scope_);
                s = new AST.SwitchStatement(место, условие, _body, isfinal);
                break;
            }
        case ТОК2.case_:
            {
                AST.Выражение exp;
                AST.Выражения cases; // массив of Выражение's
                AST.Выражение last = null;

                while (1)
                {
                    nextToken();
                    exp = parseAssignExp();
                    cases.сунь(exp);
                    if (token.значение != ТОК2.comma)
                        break;
                }
                check(ТОК2.colon);

                /* case exp: .. case last:
                 */
                if (token.значение == ТОК2.slice)
                {
                    if (cases.dim > 1)
                        выведиОшибку("only one `case` allowed for start of case range");
                    nextToken();
                    check(ТОК2.case_);
                    last = parseAssignExp();
                    check(ТОК2.colon);
                }

                if (flags & ParseStatementFlags.curlyScope)
                {
                    auto statements = new AST.Инструкции();
                    while (token.значение != ТОК2.case_ && token.значение != ТОК2.default_ && token.значение != ТОК2.endOfFile && token.значение != ТОК2.rightCurly)
                    {
                        statements.сунь(parseStatement(ParseStatementFlags.semi | ParseStatementFlags.curlyScope));
                    }
                    s = new AST.CompoundStatement(место, statements);
                }
                else
                {
                    s = parseStatement(ParseStatementFlags.semi);
                }
                s = new AST.ScopeStatement(место, s, token.место);

                if (last)
                {
                    s = new AST.CaseRangeStatement(место, exp, last, s);
                }
                else
                {
                    // Keep cases in order by building the case statements backwards
                    for (т_мера i = cases.dim; i; i--)
                    {
                        exp = cases[i - 1];
                        s = new AST.CaseStatement(место, exp, s);
                    }
                }
                break;
            }
        case ТОК2.default_:
            {
                nextToken();
                check(ТОК2.colon);

                if (flags & ParseStatementFlags.curlyScope)
                {
                    auto statements = new AST.Инструкции();
                    while (token.значение != ТОК2.case_ && token.значение != ТОК2.default_ && token.значение != ТОК2.endOfFile && token.значение != ТОК2.rightCurly)
                    {
                        statements.сунь(parseStatement(ParseStatementFlags.semi | ParseStatementFlags.curlyScope));
                    }
                    s = new AST.CompoundStatement(место, statements);
                }
                else
                    s = parseStatement(ParseStatementFlags.semi);
                s = new AST.ScopeStatement(место, s, token.место);
                s = new AST.DefaultStatement(место, s);
                break;
            }
        case ТОК2.return_:
            {
                AST.Выражение exp;
                nextToken();
                exp = token.значение == ТОК2.semicolon ? null : parseВыражение();
                check(ТОК2.semicolon, "`return` инструкция");
                s = new AST.ReturnStatement(место, exp);
                break;
            }
        case ТОК2.break_:
            {
                Идентификатор2 идент;
                nextToken();
                идент = null;
                if (token.значение == ТОК2.идентификатор)
                {
                    идент = token.идент;
                    nextToken();
                }
                check(ТОК2.semicolon, "`break` инструкция");
                s = new AST.BreakStatement(место, идент);
                break;
            }
        case ТОК2.continue_:
            {
                Идентификатор2 идент;
                nextToken();
                идент = null;
                if (token.значение == ТОК2.идентификатор)
                {
                    идент = token.идент;
                    nextToken();
                }
                check(ТОК2.semicolon, "`continue` инструкция");
                s = new AST.ContinueStatement(место, идент);
                break;
            }
        case ТОК2.goto_:
            {
                Идентификатор2 идент;
                nextToken();
                if (token.значение == ТОК2.default_)
                {
                    nextToken();
                    s = new AST.GotoDefaultStatement(место);
                }
                else if (token.значение == ТОК2.case_)
                {
                    AST.Выражение exp = null;
                    nextToken();
                    if (token.значение != ТОК2.semicolon)
                        exp = parseВыражение();
                    s = new AST.GotoCaseStatement(место, exp);
                }
                else
                {
                    if (token.значение != ТОК2.идентификатор)
                    {
                        выведиОшибку("идентификатор expected following `goto`");
                        идент = null;
                    }
                    else
                    {
                        идент = token.идент;
                        nextToken();
                    }
                    s = new AST.GotoStatement(место, идент);
                }
                check(ТОК2.semicolon, "`goto` инструкция");
                break;
            }
        case ТОК2.synchronized_:
            {
                AST.Выражение exp;
                AST.Инструкция2 _body;

                Сема2* t = peek(&token);
                if (skipAttributes(t, &t) && t.значение == ТОК2.class_)
                    goto Ldeclaration;

                nextToken();
                if (token.значение == ТОК2.leftParentheses)
                {
                    nextToken();
                    exp = parseВыражение();
                    check(ТОК2.rightParentheses);
                }
                else
                    exp = null;
                _body = parseStatement(ParseStatementFlags.scope_);
                s = new AST.SynchronizedStatement(место, exp, _body);
                break;
            }
        case ТОК2.with_:
            {
                AST.Выражение exp;
                AST.Инструкция2 _body;
                Место endloc = место;

                nextToken();
                check(ТОК2.leftParentheses);
                exp = parseВыражение();
                check(ТОК2.rightParentheses);
                _body = parseStatement(ParseStatementFlags.scope_, null, &endloc);
                s = new AST.WithStatement(место, exp, _body, endloc);
                break;
            }
        case ТОК2.try_:
            {
                AST.Инструкция2 _body;
                AST.Уловители* catches = null;
                AST.Инструкция2 finalbody = null;

                nextToken();
                const lookingForElseSave = lookingForElse;
                lookingForElse = Место.initial;
                _body = parseStatement(ParseStatementFlags.scope_);
                lookingForElse = lookingForElseSave;
                while (token.значение == ТОК2.catch_)
                {
                    AST.Инструкция2 handler;
                    AST.Уловитель c;
                    AST.Тип t;
                    Идентификатор2 ид;
                    const catchloc = token.место;

                    nextToken();
                    if (token.значение == ТОК2.leftCurly || token.значение != ТОК2.leftParentheses)
                    {
                        t = null;
                        ид = null;
                    }
                    else
                    {
                        check(ТОК2.leftParentheses);
                        ид = null;
                        t = parseType(&ид);
                        check(ТОК2.rightParentheses);
                    }
                    handler = parseStatement(0);
                    c = new AST.Уловитель(catchloc, t, ид, handler);
                    if (!catches)
                        catches = new AST.Уловители();
                    catches.сунь(c);
                }

                if (token.значение == ТОК2.finally_)
                {
                    nextToken();
                    finalbody = parseStatement(ParseStatementFlags.scope_);
                }

                s = _body;
                if (!catches && !finalbody)
                    выведиОшибку("`catch` or `finally` expected following `try`");
                else
                {
                    if (catches)
                        s = new AST.TryCatchStatement(место, _body, catches);
                    if (finalbody)
                        s = new AST.TryFinallyStatement(место, s, finalbody);
                }
                break;
            }
        case ТОК2.throw_:
            {
                AST.Выражение exp;
                nextToken();
                exp = parseВыражение();
                check(ТОК2.semicolon, "`throw` инструкция");
                s = new AST.ThrowStatement(место, exp);
                break;
            }

        case ТОК2.asm_:
            {
                // Parse the asm block into a sequence of AsmStatements,
                // each AsmStatement is one instruction.
                // Separate out labels.
                // Defer parsing of AsmStatements until semantic processing.

                Место labelloc;

                nextToken();
                КлассХранения stc = parsePostfix(STC.undefined_, null);
                if (stc & (STC.const_ | STC.immutable_ | STC.shared_ | STC.wild))
                    выведиОшибку("`const`/`const`/`shared`/`inout` attributes are not allowed on `asm` blocks");

                check(ТОК2.leftCurly);
                Сема2* toklist = null;
                Сема2** ptoklist = &toklist;
                Идентификатор2 label = null;
                auto statements = new AST.Инструкции();
                т_мера nestlevel = 0;
                while (1)
                {
                    switch (token.значение)
                    {
                    case ТОК2.идентификатор:
                        if (!toklist)
                        {
                            // Look ahead to see if it is a label
                            if (peekNext() == ТОК2.colon)
                            {
                                // It's a label
                                label = token.идент;
                                labelloc = token.место;
                                nextToken();
                                nextToken();
                                continue;
                            }
                        }
                        goto default;

                    case ТОК2.leftCurly:
                        ++nestlevel;
                        goto default;

                    case ТОК2.rightCurly:
                        if (nestlevel > 0)
                        {
                            --nestlevel;
                            goto default;
                        }
                        if (toklist || label)
                        {
                            выведиОшибку("`asm` statements must end in `;`");
                        }
                        break;

                    case ТОК2.semicolon:
                        if (nestlevel != 0)
                            выведиОшибку("mismatched number of curly brackets");

                        s = null;
                        if (toklist || label)
                        {
                            // Create AsmStatement from list of tokens we've saved
                            s = new AST.AsmStatement(token.место, toklist);
                            toklist = null;
                            ptoklist = &toklist;
                            if (label)
                            {
                                s = new AST.LabelStatement(labelloc, label, s);
                                label = null;
                            }
                            statements.сунь(s);
                        }
                        nextToken();
                        continue;

                    case ТОК2.endOfFile:
                        /* { */
                        выведиОшибку("matching `}` expected, not end of файл");
                        goto Lerror;

                    default:
                        *ptoklist = allocateToken();
                        memcpy(*ptoklist, &token, Сема2.sizeof);
                        ptoklist = &(*ptoklist).следщ;
                        *ptoklist = null;
                        nextToken();
                        continue;
                    }
                    break;
                }
                s = new AST.CompoundAsmStatement(место, statements, stc);
                nextToken();
                break;
            }
        case ТОК2.import_:
            {
                /* https://issues.dlang.org/show_bug.cgi?ид=16088
                 *
                 * At this point it can either be an
                 * https://dlang.org/spec/grammar.html#ImportВыражение
                 * or an
                 * https://dlang.org/spec/grammar.html#ImportDeclaration.
                 * See if the следщ token after `import` is a `(`; if so,
                 * then it is an import Выражение.
                 */
                if (peekNext() == ТОК2.leftParentheses)
                {
                    AST.Выражение e = parseВыражение();
                    check(ТОК2.semicolon);
                    s = new AST.ExpStatement(место, e);
                }
                else
                {
                    AST.Дсимволы* imports = parseImport();
                    s = new AST.ImportStatement(место, imports);
                    if (flags & ParseStatementFlags.scope_)
                        s = new AST.ScopeStatement(место, s, token.место);
                }
                break;
            }
        case ТОК2.template_:
            {
                AST.ДСимвол d = parseTemplateDeclaration();
                s = new AST.ExpStatement(место, d);
                break;
            }
        default:
            выведиОшибку("found `%s` instead of инструкция", token.вТкст0());
            goto Lerror;

        Lerror:
            while (token.значение != ТОК2.rightCurly && token.значение != ТОК2.semicolon && token.значение != ТОК2.endOfFile)
                nextToken();
            if (token.значение == ТОК2.semicolon)
                nextToken();
            s = null;
            break;
        }
        if (pEndloc)
            *pEndloc = prevloc;
        return s;
    }

    /*****************************************
     * Parse инициализатор for variable declaration.
     */
    private AST.Инициализатор parseInitializer()
    {
        AST.StructInitializer _is;
        AST.ArrayInitializer ia;
        AST.ExpInitializer ie;
        AST.Выражение e;
        Идентификатор2 ид;
        AST.Инициализатор значение;
        цел comma;
        const место = token.место;
        Сема2* t;
        цел braces;
        цел brackets;

        switch (token.значение)
        {
        case ТОК2.leftCurly:
            /* Scan ahead to discern between a struct инициализатор and
             * parameterless function literal.
             *
             * We'll scan the topmost curly bracket уровень for инструкция-related
             * tokens, thereby ruling out a struct инициализатор.  (A struct
             * инициализатор which itself содержит function literals may have
             * statements at nested curly bracket levels.)
             *
             * It's important that this function literal check not be
             * pendantic, otherwise a function having the slightest syntax
             * error would emit confusing errors when we proceed to parse it
             * as a struct инициализатор.
             *
             * The following two ambiguous cases will be treated as a struct
             * инициализатор (best we can do without тип info):
             *     {}
             *     {{statements...}}  - i.e. it could be struct инициализатор
             *        with one function literal, or function literal having an
             *        extra уровень of curly brackets
             * If a function literal is intended in these cases (unlikely),
             * source can use a more explicit function literal syntax
             * (e.g. префикс with "()" for empty параметр list).
             */
            braces = 1;
            for (t = peek(&token); 1; t = peek(t))
            {
                switch (t.значение)
                {
                /* Look for a semicolon or keyword of statements which don't
                 * require a semicolon (typically containing BlockStatement).
                 * Tokens like "else", "catch", etc. are omitted where the
                 * leading token of the инструкция is sufficient.
                 */
                case ТОК2.asm_:
                case ТОК2.class_:
                case ТОК2.debug_:
                case ТОК2.enum_:
                case ТОК2.if_:
                case ТОК2.interface_:
                case ТОК2.pragma_:
                case ТОК2.scope_:
                case ТОК2.semicolon:
                case ТОК2.struct_:
                case ТОК2.switch_:
                case ТОК2.synchronized_:
                case ТОК2.try_:
                case ТОК2.union_:
                case ТОК2.version_:
                case ТОК2.while_:
                case ТОК2.with_:
                    if (braces == 1)
                        goto LВыражение;
                    continue;

                case ТОК2.leftCurly:
                    braces++;
                    continue;

                case ТОК2.rightCurly:
                    if (--braces == 0)
                        break;
                    continue;

                case ТОК2.endOfFile:
                    break;

                default:
                    continue;
                }
                break;
            }

            _is = new AST.StructInitializer(место);
            nextToken();
            comma = 2;
            while (1)
            {
                switch (token.значение)
                {
                case ТОК2.идентификатор:
                    if (comma == 1)
                        выведиОшибку("comma expected separating field initializers");
                    t = peek(&token);
                    if (t.значение == ТОК2.colon)
                    {
                        ид = token.идент;
                        nextToken();
                        nextToken(); // skip over ':'
                    }
                    else
                    {
                        ид = null;
                    }
                    значение = parseInitializer();
                    _is.addInit(ид, значение);
                    comma = 1;
                    continue;

                case ТОК2.comma:
                    if (comma == 2)
                        выведиОшибку("Выражение expected, not `,`");
                    nextToken();
                    comma = 2;
                    continue;

                case ТОК2.rightCurly: // allow trailing comma's
                    nextToken();
                    break;

                case ТОК2.endOfFile:
                    выведиОшибку("found end of файл instead of инициализатор");
                    break;

                default:
                    if (comma == 1)
                        выведиОшибку("comma expected separating field initializers");
                    значение = parseInitializer();
                    _is.addInit(null, значение);
                    comma = 1;
                    continue;
                    //выведиОшибку("found `%s` instead of field инициализатор", token.вТкст0());
                    //break;
                }
                break;
            }
            return _is;

        case ТОК2.leftBracket:
            /* Scan ahead to see if it is an массив инициализатор or
             * an Выражение.
             * If it ends with a ';' ',' or '}', it is an массив инициализатор.
             */
            brackets = 1;
            for (t = peek(&token); 1; t = peek(t))
            {
                switch (t.значение)
                {
                case ТОК2.leftBracket:
                    brackets++;
                    continue;

                case ТОК2.rightBracket:
                    if (--brackets == 0)
                    {
                        t = peek(t);
                        if (t.значение != ТОК2.semicolon && t.значение != ТОК2.comma && t.значение != ТОК2.rightBracket && t.значение != ТОК2.rightCurly)
                            goto LВыражение;
                        break;
                    }
                    continue;

                case ТОК2.endOfFile:
                    break;

                default:
                    continue;
                }
                break;
            }

            ia = new AST.ArrayInitializer(место);
            nextToken();
            comma = 2;
            while (1)
            {
                switch (token.значение)
                {
                default:
                    if (comma == 1)
                    {
                        выведиОшибку("comma expected separating массив initializers, not `%s`", token.вТкст0());
                        nextToken();
                        break;
                    }
                    e = parseAssignExp();
                    if (!e)
                        break;
                    if (token.значение == ТОК2.colon)
                    {
                        nextToken();
                        значение = parseInitializer();
                    }
                    else
                    {
                        значение = new AST.ExpInitializer(e.место, e);
                        e = null;
                    }
                    ia.addInit(e, значение);
                    comma = 1;
                    continue;

                case ТОК2.leftCurly:
                case ТОК2.leftBracket:
                    if (comma == 1)
                        выведиОшибку("comma expected separating массив initializers, not `%s`", token.вТкст0());
                    значение = parseInitializer();
                    if (token.значение == ТОК2.colon)
                    {
                        nextToken();
                        if (auto ei = значение.isExpInitializer())
                        {
                            e = ei.exp;
                            значение = parseInitializer();
                        }
                        else
                            выведиОшибку("инициализатор Выражение expected following colon, not `%s`", token.вТкст0());
                    }
                    else
                        e = null;
                    ia.addInit(e, значение);
                    comma = 1;
                    continue;

                case ТОК2.comma:
                    if (comma == 2)
                        выведиОшибку("Выражение expected, not `,`");
                    nextToken();
                    comma = 2;
                    continue;

                case ТОК2.rightBracket: // allow trailing comma's
                    nextToken();
                    break;

                case ТОК2.endOfFile:
                    выведиОшибку("found `%s` instead of массив инициализатор", token.вТкст0());
                    break;
                }
                break;
            }
            return ia;

        case ТОК2.void_:
            const tv = peekNext();
            if (tv == ТОК2.semicolon || tv == ТОК2.comma)
            {
                nextToken();
                return new AST.VoidInitializer(место);
            }
            goto LВыражение;

        default:
        LВыражение:
            e = parseAssignExp();
            ie = new AST.ExpInitializer(место, e);
            return ie;
        }
    }

    /*****************************************
     * Parses default argument инициализатор Выражение that is an assign Выражение,
     * with special handling for __FILE__, __FILE_DIR__, __LINE__, __MODULE__, __FUNCTION__, and __PRETTY_FUNCTION__.
     */
    private AST.Выражение parseDefaultInitExp()
    {
        AST.Выражение e = null;
        const tv = peekNext();
        if (tv == ТОК2.comma || tv == ТОК2.rightParentheses)
        {
            switch (token.значение)
            {
            case ТОК2.файл:           e = new AST.FileInitExp(token.место, ТОК2.файл); break;
            case ТОК2.fileFullPath:   e = new AST.FileInitExp(token.место, ТОК2.fileFullPath); break;
            case ТОК2.line:           e = new AST.LineInitExp(token.место); break;
            case ТОК2.moduleString:   e = new AST.ModuleInitExp(token.место); break;
            case ТОК2.functionString: e = new AST.FuncInitExp(token.место); break;
            case ТОК2.prettyFunction: e = new AST.PrettyFuncInitExp(token.место); break;
            default: goto LExp;
            }
            nextToken();
            return e;
        }
        LExp:
        return parseAssignExp();
    }

    private проц check(Место место, ТОК2 значение)
    {
        if (token.значение != значение)
            выведиОшибку(место, "found `%s` when expecting `%s`", token.вТкст0(), Сема2.вТкст0(значение));
        nextToken();
    }

    проц check(ТОК2 значение)
    {
        check(token.место, значение);
    }

    private проц check(ТОК2 значение, ткст0 ткст)
    {
        if (token.значение != значение)
            выведиОшибку("found `%s` when expecting `%s` following %s", token.вТкст0(), Сема2.вТкст0(значение), ткст);
        nextToken();
    }

    private проц checkParens(ТОК2 значение, AST.Выражение e)
    {
        if (precedence[e.op] == PREC.rel && !e.parens)
            выведиОшибку(e.место, "`%s` must be surrounded by parentheses when следщ to operator `%s`", e.вТкст0(), Сема2.вТкст0(значение));
    }

    ///
    private enum NeedDeclaratorId
    {
        no,             // Declarator part must have no идентификатор
        opt,            // Declarator part идентификатор is optional
        must,           // Declarator part must have идентификатор
        mustIfDstyle,   // Declarator part must have идентификатор, but don't recognize old C-style syntax
    }

    /************************************
     * Determine if the scanner is sitting on the start of a declaration.
     * Параметры:
     *      t       = current token of the scanner
     *      needId  = флаг with additional requirements for a declaration
     *      endtok  = ending token
     *      pt      = will be set ending token (if not null)
     * Output:
     *      да if the token `t` is a declaration, нет otherwise
     */
    private бул isDeclaration(Сема2* t, NeedDeclaratorId needId, ТОК2 endtok, Сема2** pt)
    {
        //printf("isDeclaration(needId = %d)\n", needId);
        цел haveId = 0;
        цел haveTpl = 0;

        while (1)
        {
            if ((t.значение == ТОК2.const_ || t.значение == ТОК2.immutable_ || t.значение == ТОК2.inout_ || t.значение == ТОК2.shared_) && peek(t).значение != ТОК2.leftParentheses)
            {
                /* const тип
                 * const тип
                 * shared тип
                 * wild тип
                 */
                t = peek(t);
                continue;
            }
            break;
        }

        if (!isBasicType(&t))
        {
            goto Lisnot;
        }
        if (!isDeclarator(&t, &haveId, &haveTpl, endtok, needId != NeedDeclaratorId.mustIfDstyle))
            goto Lisnot;
        if ((needId == NeedDeclaratorId.no && !haveId) ||
            (needId == NeedDeclaratorId.opt) ||
            (needId == NeedDeclaratorId.must && haveId) ||
            (needId == NeedDeclaratorId.mustIfDstyle && haveId))
        {
            if (pt)
                *pt = t;
            goto Lis;
        }
        goto Lisnot;

    Lis:
        //printf("\tis declaration, t = %s\n", t.вТкст0());
        return да;

    Lisnot:
        //printf("\tis not declaration\n");
        return нет;
    }

    private бул isBasicType(Сема2** pt)
    {
        // This code parallels parseBasicType()
        Сема2* t = *pt;
        switch (t.значение)
        {
        case ТОК2.wchar_:
        case ТОК2.dchar_:
        case ТОК2.бул_:
        case ТОК2.char_:
        case ТОК2.int8:
        case ТОК2.uns8:
        case ТОК2.int16:
        case ТОК2.uns16:
        case ТОК2.int32:
        case ТОК2.uns32:
        case ТОК2.int64:
        case ТОК2.uns64:
        case ТОК2.int128:
        case ТОК2.uns128:
        case ТОК2.float32:
        case ТОК2.float64:
        case ТОК2.float80:
        case ТОК2.imaginary32:
        case ТОК2.imaginary64:
        case ТОК2.imaginary80:
        case ТОК2.complex32:
        case ТОК2.complex64:
        case ТОК2.complex80:
        case ТОК2.void_:
            t = peek(t);
            break;

        case ТОК2.идентификатор:
        L5:
            t = peek(t);
            if (t.значение == ТОК2.not)
            {
                goto L4;
            }
            goto L3;
            while (1)
            {
            L2:
                t = peek(t);
            L3:
                if (t.значение == ТОК2.dot)
                {
                Ldot:
                    t = peek(t);
                    if (t.значение != ТОК2.идентификатор)
                        goto Lfalse;
                    t = peek(t);
                    if (t.значение != ТОК2.not)
                        goto L3;
                L4:
                    /* Seen a !
                     * Look for:
                     * !( args ), !идентификатор, etc.
                     */
                    t = peek(t);
                    switch (t.значение)
                    {
                    case ТОК2.идентификатор:
                        goto L5;

                    case ТОК2.leftParentheses:
                        if (!skipParens(t, &t))
                            goto Lfalse;
                        goto L3;

                    case ТОК2.wchar_:
                    case ТОК2.dchar_:
                    case ТОК2.бул_:
                    case ТОК2.char_:
                    case ТОК2.int8:
                    case ТОК2.uns8:
                    case ТОК2.int16:
                    case ТОК2.uns16:
                    case ТОК2.int32:
                    case ТОК2.uns32:
                    case ТОК2.int64:
                    case ТОК2.uns64:
                    case ТОК2.int128:
                    case ТОК2.uns128:
                    case ТОК2.float32:
                    case ТОК2.float64:
                    case ТОК2.float80:
                    case ТОК2.imaginary32:
                    case ТОК2.imaginary64:
                    case ТОК2.imaginary80:
                    case ТОК2.complex32:
                    case ТОК2.complex64:
                    case ТОК2.complex80:
                    case ТОК2.void_:
                    case ТОК2.int32Literal:
                    case ТОК2.uns32Literal:
                    case ТОК2.int64Literal:
                    case ТОК2.uns64Literal:
                    case ТОК2.int128Literal:
                    case ТОК2.uns128Literal:
                    case ТОК2.float32Literal:
                    case ТОК2.float64Literal:
                    case ТОК2.float80Literal:
                    case ТОК2.imaginary32Literal:
                    case ТОК2.imaginary64Literal:
                    case ТОК2.imaginary80Literal:
                    case ТОК2.null_:
                    case ТОК2.true_:
                    case ТОК2.false_:
                    case ТОК2.charLiteral:
                    case ТОК2.wcharLiteral:
                    case ТОК2.dcharLiteral:
                    case ТОК2.string_:
                    case ТОК2.hexadecimalString:
                    case ТОК2.файл:
                    case ТОК2.fileFullPath:
                    case ТОК2.line:
                    case ТОК2.moduleString:
                    case ТОК2.functionString:
                    case ТОК2.prettyFunction:
                        goto L2;

                    default:
                        goto Lfalse;
                    }
                }
                break;
            }
            break;

        case ТОК2.dot:
            goto Ldot;

        case ТОК2.typeof_:
        case ТОК2.vector:
        case ТОК2.mixin_:
            /* typeof(exp).идентификатор...
             */
            t = peek(t);
            if (!skipParens(t, &t))
                goto Lfalse;
            goto L3;

        case ТОК2.traits:
            // __traits(getMember
            t = peek(t);
            if (t.значение != ТОК2.leftParentheses)
                goto Lfalse;
            auto lp = t;
            t = peek(t);
            if (t.значение != ТОК2.идентификатор || t.идент != Id.getMember)
                goto Lfalse;
            if (!skipParens(lp, &lp))
                goto Lfalse;
            // we are in a lookup for decl VS инструкция
            // so we expect a declarator following __trait if it's a тип.
            // other usages wont be ambiguous (alias, template instance, тип qual, etc.)
            if (lp.значение != ТОК2.идентификатор)
                goto Lfalse;

            break;

        case ТОК2.const_:
        case ТОК2.immutable_:
        case ТОК2.shared_:
        case ТОК2.inout_:
            // const(тип)  or  const(тип)  or  shared(тип)  or  wild(тип)
            t = peek(t);
            if (t.значение != ТОК2.leftParentheses)
                goto Lfalse;
            t = peek(t);
            if (!isDeclaration(t, NeedDeclaratorId.no, ТОК2.rightParentheses, &t))
            {
                goto Lfalse;
            }
            t = peek(t);
            break;

        default:
            goto Lfalse;
        }
        *pt = t;
        //printf("is\n");
        return да;

    Lfalse:
        //printf("is not\n");
        return нет;
    }

    private бул isDeclarator(Сема2** pt, цел* haveId, цел* haveTpl, ТОК2 endtok, бул allowAltSyntax = да)
    {
        // This code parallels parseDeclarator()
        Сема2* t = *pt;
        цел parens;

        //printf("Parser::isDeclarator() %s\n", t.вТкст0());
        if (t.значение == ТОК2.assign)
            return нет;

        while (1)
        {
            parens = нет;
            switch (t.значение)
            {
            case ТОК2.mul:
            //case ТОК2.and:
                t = peek(t);
                continue;

            case ТОК2.leftBracket:
                t = peek(t);
                if (t.значение == ТОК2.rightBracket)
                {
                    t = peek(t);
                }
                else if (isDeclaration(t, NeedDeclaratorId.no, ТОК2.rightBracket, &t))
                {
                    // It's an associative массив declaration
                    t = peek(t);

                    // ...[тип].идент
                    if (t.значение == ТОК2.dot && peek(t).значение == ТОК2.идентификатор)
                    {
                        t = peek(t);
                        t = peek(t);
                    }
                }
                else
                {
                    // [ Выражение ]
                    // [ Выражение .. Выражение ]
                    if (!выражение_ли(&t))
                        return нет;
                    if (t.значение == ТОК2.slice)
                    {
                        t = peek(t);
                        if (!выражение_ли(&t))
                            return нет;
                        if (t.значение != ТОК2.rightBracket)
                            return нет;
                        t = peek(t);
                    }
                    else
                    {
                        if (t.значение != ТОК2.rightBracket)
                            return нет;
                        t = peek(t);
                        // ...[index].идент
                        if (t.значение == ТОК2.dot && peek(t).значение == ТОК2.идентификатор)
                        {
                            t = peek(t);
                            t = peek(t);
                        }
                    }
                }
                continue;

            case ТОК2.идентификатор:
                if (*haveId)
                    return нет;
                *haveId = да;
                t = peek(t);
                break;

            case ТОК2.leftParentheses:
                if (!allowAltSyntax)
                    return нет;   // Do not recognize C-style declarations.

                t = peek(t);
                if (t.значение == ТОК2.rightParentheses)
                    return нет; // () is not a declarator

                /* Regard ( идентификатор ) as not a declarator
                 * BUG: what about ( *идентификатор ) in
                 *      f(*p)(x);
                 * where f is a class instance with overloaded () ?
                 * Should we just disallow C-style function pointer declarations?
                 */
                if (t.значение == ТОК2.идентификатор)
                {
                    Сема2* t2 = peek(t);
                    if (t2.значение == ТОК2.rightParentheses)
                        return нет;
                }

                if (!isDeclarator(&t, haveId, null, ТОК2.rightParentheses))
                    return нет;
                t = peek(t);
                parens = да;
                break;

            case ТОК2.delegate_:
            case ТОК2.function_:
                t = peek(t);
                if (!isParameters(&t))
                    return нет;
                skipAttributes(t, &t);
                continue;

            default:
                break;
            }
            break;
        }

        while (1)
        {
            switch (t.значение)
            {
                static if (CARRAYDECL)
                {
                case ТОК2.leftBracket:
                    parens = нет;
                    t = peek(t);
                    if (t.значение == ТОК2.rightBracket)
                    {
                        t = peek(t);
                    }
                    else if (isDeclaration(t, NeedDeclaratorId.no, ТОК2.rightBracket, &t))
                    {
                        // It's an associative массив declaration
                        t = peek(t);
                    }
                    else
                    {
                        // [ Выражение ]
                        if (!выражение_ли(&t))
                            return нет;
                        if (t.значение != ТОК2.rightBracket)
                            return нет;
                        t = peek(t);
                    }
                    continue;
                }

            case ТОК2.leftParentheses:
                parens = нет;
                if (Сема2* tk = peekPastParen(t))
                {
                    if (tk.значение == ТОК2.leftParentheses)
                    {
                        if (!haveTpl)
                            return нет;
                        *haveTpl = 1;
                        t = tk;
                    }
                    else if (tk.значение == ТОК2.assign)
                    {
                        if (!haveTpl)
                            return нет;
                        *haveTpl = 1;
                        *pt = tk;
                        return да;
                    }
                }
                if (!isParameters(&t))
                    return нет;
                while (1)
                {
                    switch (t.значение)
                    {
                    case ТОК2.const_:
                    case ТОК2.immutable_:
                    case ТОК2.shared_:
                    case ТОК2.inout_:
                    case ТОК2.pure_:
                    case ТОК2.nothrow_:
                    case ТОК2.return_:
                    case ТОК2.scope_:
                        t = peek(t);
                        continue;

                    case ТОК2.at:
                        t = peek(t); // skip '@'
                        t = peek(t); // skip идентификатор
                        continue;

                    default:
                        break;
                    }
                    break;
                }
                continue;

            // Valid tokens that follow a declaration
            case ТОК2.rightParentheses:
            case ТОК2.rightBracket:
            case ТОК2.assign:
            case ТОК2.comma:
            case ТОК2.dotDotDot:
            case ТОК2.semicolon:
            case ТОК2.leftCurly:
            case ТОК2.in_:
            case ТОК2.out_:
            case ТОК2.do_:
                // The !parens is to disallow unnecessary parentheses
                if (!parens && (endtok == ТОК2.reserved || endtok == t.значение))
                {
                    *pt = t;
                    return да;
                }
                return нет;

            case ТОК2.идентификатор:
                if (t.идент == Id._body)
                {
                    version (none)
                    {
                        // This deprecation has been disabled for the time being, see PR10763
                        // @@@DEPRECATED@@@
                        // https://github.com/dlang/DIPs/blob/1f5959abe482b1f9094f6484a7d0a3ade77fc2fc/DIPs/accepted/DIP1003.md
                        // Deprecated in 2.091 - Can be removed from 2.101
                        deprecation("Использование of the `body` keyword is deprecated. Use `do` instead.");
                    }
                    goto case ТОК2.do_;
                }
                goto default;

            case ТОК2.if_:
                return haveTpl ? да : нет;

            // Used for mixin тип parsing
            case ТОК2.endOfFile:
                if (endtok == ТОК2.endOfFile)
                    goto case ТОК2.do_;
                return нет;

            default:
                return нет;
            }
        }
        assert(0);
    }

    private бул isParameters(Сема2** pt)
    {
        // This code parallels parseParameters()
        Сема2* t = *pt;

        //printf("isParameters()\n");
        if (t.значение != ТОК2.leftParentheses)
            return нет;

        t = peek(t);
        for (; 1; t = peek(t))
        {
        L1:
            switch (t.значение)
            {
            case ТОК2.rightParentheses:
                break;

            case ТОК2.dotDotDot:
                t = peek(t);
                break;

            case ТОК2.in_:
            case ТОК2.out_:
            case ТОК2.ref_:
            case ТОК2.lazy_:
            case ТОК2.scope_:
            case ТОК2.final_:
            case ТОК2.auto_:
            case ТОК2.return_:
                continue;

            case ТОК2.const_:
            case ТОК2.immutable_:
            case ТОК2.shared_:
            case ТОК2.inout_:
                t = peek(t);
                if (t.значение == ТОК2.leftParentheses)
                {
                    t = peek(t);
                    if (!isDeclaration(t, NeedDeclaratorId.no, ТОК2.rightParentheses, &t))
                        return нет;
                    t = peek(t); // skip past closing ')'
                    goto L2;
                }
                goto L1;

                version (none)
                {
                case ТОК2.static_:
                    continue;
                case ТОК2.auto_:
                case ТОК2.alias_:
                    t = peek(t);
                    if (t.значение == ТОК2.идентификатор)
                        t = peek(t);
                    if (t.значение == ТОК2.assign)
                    {
                        t = peek(t);
                        if (!выражение_ли(&t))
                            return нет;
                    }
                    goto L3;
                }

            default:
                {
                    if (!isBasicType(&t))
                        return нет;
                L2:
                    цел tmp = нет;
                    if (t.значение != ТОК2.dotDotDot && !isDeclarator(&t, &tmp, null, ТОК2.reserved))
                        return нет;
                    if (t.значение == ТОК2.assign)
                    {
                        t = peek(t);
                        if (!выражение_ли(&t))
                            return нет;
                    }
                    if (t.значение == ТОК2.dotDotDot)
                    {
                        t = peek(t);
                        break;
                    }
                }
                if (t.значение == ТОК2.comma)
                {
                    continue;
                }
                break;
            }
            break;
        }
        if (t.значение != ТОК2.rightParentheses)
            return нет;
        t = peek(t);
        *pt = t;
        return да;
    }

    private бул выражение_ли(Сема2** pt)
    {
        // This is supposed to determine if something is an Выражение.
        // What it actually does is scan until a closing right bracket
        // is found.

        Сема2* t = *pt;
        цел brnest = 0;
        цел panest = 0;
        цел curlynest = 0;

        for (;; t = peek(t))
        {
            switch (t.значение)
            {
            case ТОК2.leftBracket:
                brnest++;
                continue;

            case ТОК2.rightBracket:
                if (--brnest >= 0)
                    continue;
                break;

            case ТОК2.leftParentheses:
                panest++;
                continue;

            case ТОК2.comma:
                if (brnest || panest)
                    continue;
                break;

            case ТОК2.rightParentheses:
                if (--panest >= 0)
                    continue;
                break;

            case ТОК2.leftCurly:
                curlynest++;
                continue;

            case ТОК2.rightCurly:
                if (--curlynest >= 0)
                    continue;
                return нет;

            case ТОК2.slice:
                if (brnest)
                    continue;
                break;

            case ТОК2.semicolon:
                if (curlynest)
                    continue;
                return нет;

            case ТОК2.endOfFile:
                return нет;

            default:
                continue;
            }
            break;
        }

        *pt = t;
        return да;
    }

    /*******************************************
     * Skip parens, brackets.
     * Input:
     *      t is on opening $(LPAREN)
     * Output:
     *      *pt is set to closing token, which is '$(RPAREN)' on успех
     * Возвращает:
     *      да    successful
     *      нет   some parsing error
     */
    private бул skipParens(Сема2* t, Сема2** pt)
    {
        if (t.значение != ТОК2.leftParentheses)
            return нет;

        цел parens = 0;

        while (1)
        {
            switch (t.значение)
            {
            case ТОК2.leftParentheses:
                parens++;
                break;

            case ТОК2.rightParentheses:
                parens--;
                if (parens < 0)
                    goto Lfalse;
                if (parens == 0)
                    goto Ldone;
                break;

            case ТОК2.endOfFile:
                goto Lfalse;

            default:
                break;
            }
            t = peek(t);
        }
    Ldone:
        if (pt)
            *pt = peek(t); // skip found rparen
        return да;

    Lfalse:
        return нет;
    }

    private бул skipParensIf(Сема2* t, Сема2** pt)
    {
        if (t.значение != ТОК2.leftParentheses)
        {
            if (pt)
                *pt = t;
            return да;
        }
        return skipParens(t, pt);
    }

    //returns да if the следщ значение (after optional matching parens) is expected
    private бул hasOptionalParensThen(Сема2* t, ТОК2 expected)
    {
        Сема2* tk;
        if (!skipParensIf(t, &tk))
            return нет;
        return tk.значение == expected;
    }

    /*******************************************
     * Skip attributes.
     * Input:
     *      t is on a candidate attribute
     * Output:
     *      *pt is set to first non-attribute token on успех
     * Возвращает:
     *      да    successful
     *      нет   some parsing error
     */
    private бул skipAttributes(Сема2* t, Сема2** pt)
    {
        while (1)
        {
            switch (t.значение)
            {
            case ТОК2.const_:
            case ТОК2.immutable_:
            case ТОК2.shared_:
            case ТОК2.inout_:
            case ТОК2.final_:
            case ТОК2.auto_:
            case ТОК2.scope_:
            case ТОК2.override_:
            case ТОК2.abstract_:
            case ТОК2.synchronized_:
                break;

            case ТОК2.deprecated_:
                if (peek(t).значение == ТОК2.leftParentheses)
                {
                    t = peek(t);
                    if (!skipParens(t, &t))
                        goto Lerror;
                    // t is on the следщ of closing parenthesis
                    continue;
                }
                break;

            case ТОК2.nothrow_:
            case ТОК2.pure_:
            case ТОК2.ref_:
            case ТОК2.gshared:
            case ТОК2.return_:
                break;

            case ТОК2.at:
                t = peek(t);
                if (t.значение == ТОК2.идентификатор)
                {
                    /* @идентификатор
                     * @идентификатор!arg
                     * @идентификатор!(arglist)
                     * any of the above followed by (arglist)
                     * @predefined_attribute
                     */
                    if (isBuiltinAtAttribute(t.идент))
                        break;
                    t = peek(t);
                    if (t.значение == ТОК2.not)
                    {
                        t = peek(t);
                        if (t.значение == ТОК2.leftParentheses)
                        {
                            // @идентификатор!(arglist)
                            if (!skipParens(t, &t))
                                goto Lerror;
                            // t is on the следщ of closing parenthesis
                        }
                        else
                        {
                            // @идентификатор!arg
                            // Do low rent skipTemplateArgument
                            if (t.значение == ТОК2.vector)
                            {
                                // идентификатор!__vector(тип)
                                t = peek(t);
                                if (!skipParens(t, &t))
                                    goto Lerror;
                            }
                            else
                                t = peek(t);
                        }
                    }
                    if (t.значение == ТОК2.leftParentheses)
                    {
                        if (!skipParens(t, &t))
                            goto Lerror;
                        // t is on the следщ of closing parenthesis
                        continue;
                    }
                    continue;
                }
                if (t.значение == ТОК2.leftParentheses)
                {
                    // @( ArgumentList )
                    if (!skipParens(t, &t))
                        goto Lerror;
                    // t is on the следщ of closing parenthesis
                    continue;
                }
                goto Lerror;

            default:
                goto Ldone;
            }
            t = peek(t);
        }
    Ldone:
        if (pt)
            *pt = t;
        return да;

    Lerror:
        return нет;
    }

    AST.Выражение parseВыражение()
    {
        auto место = token.место;

        //printf("Parser::parseВыражение() место = %d\n", место.номстр);
        auto e = parseAssignExp();
        while (token.значение == ТОК2.comma)
        {
            nextToken();
            auto e2 = parseAssignExp();
            e = new AST.CommaExp(место, e, e2, нет);
            место = token.место;
        }
        return e;
    }

    /********************************* Выражение Parser ***************************/

    AST.Выражение parsePrimaryExp()
    {
        AST.Выражение e;
        AST.Тип t;
        Идентификатор2 ид;
        const место = token.место;

        //printf("parsePrimaryExp(): место = %d\n", место.номстр);
        switch (token.значение)
        {
        case ТОК2.идентификатор:
            {
                if (peekNext() == ТОК2.min && peekNext2() == ТОК2.greaterThan)
                {
                    // skip идент.
                    nextToken();
                    nextToken();
                    nextToken();
                    выведиОшибку("use `.` for member lookup, not `->`");
                    goto Lerr;
                }

                if (peekNext() == ТОК2.goesTo)
                    goto case_delegate;

                ид = token.идент;
                nextToken();
                ТОК2 save;
                if (token.значение == ТОК2.not && (save = peekNext()) != ТОК2.is_ && save != ТОК2.in_)
                {
                    // идентификатор!(template-argument-list)
                    auto tempinst = new AST.TemplateInstance(место, ид, parseTemplateArguments());
                    e = new AST.ScopeExp(место, tempinst);
                }
                else
                    e = new AST.IdentifierExp(место, ид);
                break;
            }
        case ТОК2.dollar:
            if (!inBrackets)
                выведиОшибку("`$` is valid only inside [] of index or slice");
            e = new AST.DollarExp(место);
            nextToken();
            break;

        case ТОК2.dot:
            // Signal глоб2 scope '.' operator with "" идентификатор
            e = new AST.IdentifierExp(место, Id.empty);
            break;

        case ТОК2.this_:
            e = new AST.ThisExp(место);
            nextToken();
            break;

        case ТОК2.super_:
            e = new AST.SuperExp(место);
            nextToken();
            break;

        case ТОК2.int32Literal:
            e = new AST.IntegerExp(место, cast(d_int32)token.intvalue, AST.Тип.tint32);
            nextToken();
            break;

        case ТОК2.uns32Literal:
            e = new AST.IntegerExp(место, cast(d_uns32)token.unsvalue, AST.Тип.tuns32);
            nextToken();
            break;

        case ТОК2.int64Literal:
            e = new AST.IntegerExp(место, token.intvalue, AST.Тип.tint64);
            nextToken();
            break;

        case ТОК2.uns64Literal:
            e = new AST.IntegerExp(место, token.unsvalue, AST.Тип.tuns64);
            nextToken();
            break;

        case ТОК2.float32Literal:
            e = new AST.RealExp(место, token.floatvalue, AST.Тип.tfloat32);
            nextToken();
            break;

        case ТОК2.float64Literal:
            e = new AST.RealExp(место, token.floatvalue, AST.Тип.tfloat64);
            nextToken();
            break;

        case ТОК2.float80Literal:
            e = new AST.RealExp(место, token.floatvalue, AST.Тип.tfloat80);
            nextToken();
            break;

        case ТОК2.imaginary32Literal:
            e = new AST.RealExp(место, token.floatvalue, AST.Тип.timaginary32);
            nextToken();
            break;

        case ТОК2.imaginary64Literal:
            e = new AST.RealExp(место, token.floatvalue, AST.Тип.timaginary64);
            nextToken();
            break;

        case ТОК2.imaginary80Literal:
            e = new AST.RealExp(место, token.floatvalue, AST.Тип.timaginary80);
            nextToken();
            break;

        case ТОК2.null_:
            e = new AST.NullExp(место);
            nextToken();
            break;

        case ТОК2.файл:
            {
                ткст0 s = место.имяф ? место.имяф : mod.идент.вТкст0();
                e = new AST.StringExp(место, s.вТкстД());
                nextToken();
                break;
            }
        case ТОК2.fileFullPath:
            {
                assert(место.isValid(), "__FILE_FULL_PATH__ does not work with an invalid location");
                const s = ИмяФайла.toAbsolute(место.имяф);
                e = new AST.StringExp(место, s.вТкстД());
                nextToken();
                break;
            }

        case ТОК2.line:
            e = new AST.IntegerExp(место, место.номстр, AST.Тип.tint32);
            nextToken();
            break;

        case ТОК2.moduleString:
            {
                ткст0 s = md ? md.вТкст0() : mod.вТкст0();
                e = new AST.StringExp(место, s.вТкстД());
                nextToken();
                break;
            }
        case ТОК2.functionString:
            e = new AST.FuncInitExp(место);
            nextToken();
            break;

        case ТОК2.prettyFunction:
            e = new AST.PrettyFuncInitExp(место);
            nextToken();
            break;

        case ТОК2.true_:
            e = new AST.IntegerExp(место, 1, AST.Тип.tбул);
            nextToken();
            break;

        case ТОК2.false_:
            e = new AST.IntegerExp(место, 0, AST.Тип.tбул);
            nextToken();
            break;

        case ТОК2.charLiteral:
            e = new AST.IntegerExp(место, cast(d_uns8)token.unsvalue, AST.Тип.tchar);
            nextToken();
            break;

        case ТОК2.wcharLiteral:
            e = new AST.IntegerExp(место, cast(d_uns16)token.unsvalue, AST.Тип.twchar);
            nextToken();
            break;

        case ТОК2.dcharLiteral:
            e = new AST.IntegerExp(место, cast(d_uns32)token.unsvalue, AST.Тип.tdchar);
            nextToken();
            break;

        case ТОК2.string_:
        case ТОК2.hexadecimalString:
            {
                // cat adjacent strings
                auto s = token.ustring;
                auto len = token.len;
                auto postfix = token.postfix;
                while (1)
                {
                    const prev = token;
                    nextToken();
                    if (token.значение == ТОК2.string_ || token.значение == ТОК2.hexadecimalString)
                    {
                        if (token.postfix)
                        {
                            if (token.postfix != postfix)
                                выведиОшибку("mismatched ткст literal postfixes `'%c'` and `'%c'`", postfix, token.postfix);
                            postfix = token.postfix;
                        }

                        выведиОшибку("Implicit ткст concatenation is deprecated, use %s ~ %s instead",
                                    prev.вТкст0(), token.вТкст0());

                        const len1 = len;
                        const len2 = token.len;
                        len = len1 + len2;
                        auto s2 = cast(сим*)mem.xmalloc_noscan(len * сим.sizeof);
                        memcpy(s2, s, len1 * сим.sizeof);
                        memcpy(s2 + len1, token.ustring, len2 * сим.sizeof);
                        s = s2;
                    }
                    else
                        break;
                }
                e = new AST.StringExp(место, s[0 .. len], len, 1, postfix);
                break;
            }
        case ТОК2.void_:
            t = AST.Тип.tvoid;
            goto LabelX;

        case ТОК2.int8:
            t = AST.Тип.tint8;
            goto LabelX;

        case ТОК2.uns8:
            t = AST.Тип.tuns8;
            goto LabelX;

        case ТОК2.int16:
            t = AST.Тип.tint16;
            goto LabelX;

        case ТОК2.uns16:
            t = AST.Тип.tuns16;
            goto LabelX;

        case ТОК2.int32:
            t = AST.Тип.tint32;
            goto LabelX;

        case ТОК2.uns32:
            t = AST.Тип.tuns32;
            goto LabelX;

        case ТОК2.int64:
            t = AST.Тип.tint64;
            goto LabelX;

        case ТОК2.uns64:
            t = AST.Тип.tuns64;
            goto LabelX;

        case ТОК2.int128:
            t = AST.Тип.tint128;
            goto LabelX;

        case ТОК2.uns128:
            t = AST.Тип.tuns128;
            goto LabelX;

        case ТОК2.float32:
            t = AST.Тип.tfloat32;
            goto LabelX;

        case ТОК2.float64:
            t = AST.Тип.tfloat64;
            goto LabelX;

        case ТОК2.float80:
            t = AST.Тип.tfloat80;
            goto LabelX;

        case ТОК2.imaginary32:
            t = AST.Тип.timaginary32;
            goto LabelX;

        case ТОК2.imaginary64:
            t = AST.Тип.timaginary64;
            goto LabelX;

        case ТОК2.imaginary80:
            t = AST.Тип.timaginary80;
            goto LabelX;

        case ТОК2.complex32:
            t = AST.Тип.tcomplex32;
            goto LabelX;

        case ТОК2.complex64:
            t = AST.Тип.tcomplex64;
            goto LabelX;

        case ТОК2.complex80:
            t = AST.Тип.tcomplex80;
            goto LabelX;

        case ТОК2.бул_:
            t = AST.Тип.tбул;
            goto LabelX;

        case ТОК2.char_:
            t = AST.Тип.tchar;
            goto LabelX;

        case ТОК2.wchar_:
            t = AST.Тип.twchar;
            goto LabelX;

        case ТОК2.dchar_:
            t = AST.Тип.tdchar;
            goto LabelX;
        LabelX:
            nextToken();
            if (token.значение == ТОК2.leftParentheses)
            {
                e = new AST.TypeExp(место, t);
                e = new AST.CallExp(место, e, parseArguments());
                break;
            }
            check(ТОК2.dot, t.вТкст0());
            if (token.значение != ТОК2.идентификатор)
            {
                выведиОшибку("found `%s` when expecting идентификатор following `%s`.", token.вТкст0(), t.вТкст0());
                goto Lerr;
            }
            e = new AST.DotIdExp(место, new AST.TypeExp(место, t), token.идент);
            nextToken();
            break;

        case ТОК2.typeof_:
            {
                t = parseTypeof();
                e = new AST.TypeExp(место, t);
                break;
            }
        case ТОК2.vector:
            {
                t = parseVector();
                e = new AST.TypeExp(место, t);
                break;
            }
        case ТОК2.typeid_:
            {
                nextToken();
                check(ТОК2.leftParentheses, "`typeid`");
                КорневойОбъект o = parseTypeOrAssignExp();
                check(ТОК2.rightParentheses);
                e = new AST.TypeidExp(место, o);
                break;
            }
        case ТОК2.traits:
            {
                /* __traits(идентификатор, args...)
                 */
                Идентификатор2 идент;
                AST.Объекты* args = null;

                nextToken();
                check(ТОК2.leftParentheses);
                if (token.значение != ТОК2.идентификатор)
                {
                    выведиОшибку("`__traits(идентификатор, args...)` expected");
                    goto Lerr;
                }
                идент = token.идент;
                nextToken();
                if (token.значение == ТОК2.comma)
                    args = parseTemplateArgumentList(); // __traits(идентификатор, args...)
                else
                    check(ТОК2.rightParentheses); // __traits(идентификатор)

                e = new AST.TraitsExp(место, идент, args);
                break;
            }
        case ТОК2.is_:
            {
                AST.Тип targ;
                Идентификатор2 идент = null;
                AST.Тип tspec = null;
                ТОК2 tok = ТОК2.reserved;
                ТОК2 tok2 = ТОК2.reserved;
                AST.ПараметрыШаблона* tpl = null;

                nextToken();
                if (token.значение == ТОК2.leftParentheses)
                {
                    nextToken();
                    if (token.значение == ТОК2.идентификатор && peekNext() == ТОК2.leftParentheses)
                    {
                        выведиОшибку(место, "unexpected `(` after `%s`, inside `is` Выражение. Try enclosing the contents of `is` with a `typeof` Выражение", token.вТкст0());
                        nextToken();
                        Сема2* tempTok = peekPastParen(&token);
                        memcpy(&token, tempTok, Сема2.sizeof);
                        goto Lerr;
                    }
                    targ = parseType(&идент);
                    if (token.значение == ТОК2.colon || token.значение == ТОК2.equal)
                    {
                        tok = token.значение;
                        nextToken();
                        if (tok == ТОК2.equal && (token.значение == ТОК2.struct_ || token.значение == ТОК2.union_
                            || token.значение == ТОК2.class_ || token.значение == ТОК2.super_ || token.значение == ТОК2.enum_
                            || token.значение == ТОК2.interface_ || token.значение == ТОК2.package_ || token.значение == ТОК2.module_
                            || token.значение == ТОК2.argumentTypes || token.значение == ТОК2.parameters
                            || token.значение == ТОК2.const_ && peekNext() == ТОК2.rightParentheses
                            || token.значение == ТОК2.immutable_ && peekNext() == ТОК2.rightParentheses
                            || token.значение == ТОК2.shared_ && peekNext() == ТОК2.rightParentheses
                            || token.значение == ТОК2.inout_ && peekNext() == ТОК2.rightParentheses || token.значение == ТОК2.function_
                            || token.значение == ТОК2.delegate_ || token.значение == ТОК2.return_
                            || (token.значение == ТОК2.vector && peekNext() == ТОК2.rightParentheses)))
                        {
                            tok2 = token.значение;
                            nextToken();
                        }
                        else
                        {
                            tspec = parseType();
                        }
                    }
                    if (tspec)
                    {
                        if (token.значение == ТОК2.comma)
                            tpl = parseTemplateParameterList(1);
                        else
                        {
                            tpl = new AST.ПараметрыШаблона();
                            check(ТОК2.rightParentheses);
                        }
                    }
                    else
                        check(ТОК2.rightParentheses);
                }
                else
                {
                    выведиОшибку("`тип идентификатор : specialization` expected following `is`");
                    goto Lerr;
                }
                e = new AST.IsExp(место, targ, идент, tok, tspec, tok2, tpl);
                break;
            }
        case ТОК2.assert_:
            {
                // https://dlang.org/spec/Выражение.html#assert_Выражениеs
                AST.Выражение msg = null;

                nextToken();
                check(ТОК2.leftParentheses, "`assert`");
                e = parseAssignExp();
                if (token.значение == ТОК2.comma)
                {
                    nextToken();
                    if (token.значение != ТОК2.rightParentheses)
                    {
                        msg = parseAssignExp();
                        if (token.значение == ТОК2.comma)
                            nextToken();
                    }
                }
                check(ТОК2.rightParentheses);
                e = new AST.AssertExp(место, e, msg);
                break;
            }
        case ТОК2.mixin_:
            {
                // https://dlang.org/spec/Выражение.html#mixin_Выражениеs
                nextToken();
                if (token.значение != ТОК2.leftParentheses)
                    выведиОшибку("found `%s` when expecting `%s` following %s", token.вТкст0(), Сема2.вТкст0(ТОК2.leftParentheses), "`mixin`".ptr);
                auto exps = parseArguments();
                e = new AST.CompileExp(место, exps);
                break;
            }
        case ТОК2.import_:
            {
                nextToken();
                check(ТОК2.leftParentheses, "`import`");
                e = parseAssignExp();
                check(ТОК2.rightParentheses);
                e = new AST.ImportExp(место, e);
                break;
            }
        case ТОК2.new_:
            e = parseNewExp(null);
            break;

        case ТОК2.ref_:
            {
                if (peekNext() == ТОК2.leftParentheses)
                {
                    Сема2* tk = peekPastParen(peek(&token));
                    if (skipAttributes(tk, &tk) && (tk.значение == ТОК2.goesTo || tk.значение == ТОК2.leftCurly))
                    {
                        // ref (arguments) => Выражение
                        // ref (arguments) { statements... }
                        goto case_delegate;
                    }
                }
                nextToken();
                выведиОшибку("found `%s` when expecting function literal following `ref`", token.вТкст0());
                goto Lerr;
            }
        case ТОК2.leftParentheses:
            {
                Сема2* tk = peekPastParen(&token);
                if (skipAttributes(tk, &tk) && (tk.значение == ТОК2.goesTo || tk.значение == ТОК2.leftCurly))
                {
                    // (arguments) => Выражение
                    // (arguments) { statements... }
                    goto case_delegate;
                }

                // ( Выражение )
                nextToken();
                e = parseВыражение();
                e.parens = 1;
                check(место, ТОК2.rightParentheses);
                break;
            }
        case ТОК2.leftBracket:
            {
                /* Parse массив literals and associative массив literals:
                 *  [ значение, значение, значение ... ]
                 *  [ ключ:значение, ключ:значение, ключ:значение ... ]
                 */
                auto values = new AST.Выражения();
                AST.Выражения* keys = null;

                nextToken();
                while (token.значение != ТОК2.rightBracket && token.значение != ТОК2.endOfFile)
                {
                    e = parseAssignExp();
                    if (token.значение == ТОК2.colon && (keys || values.dim == 0))
                    {
                        nextToken();
                        if (!keys)
                            keys = new AST.Выражения();
                        keys.сунь(e);
                        e = parseAssignExp();
                    }
                    else if (keys)
                    {
                        выведиОшибку("`ключ:значение` expected for associative массив literal");
                        keys = null;
                    }
                    values.сунь(e);
                    if (token.значение == ТОК2.rightBracket)
                        break;
                    check(ТОК2.comma);
                }
                check(место, ТОК2.rightBracket);

                if (keys)
                    e = new AST.AssocArrayLiteralExp(место, keys, values);
                else
                    e = new AST.ArrayLiteralExp(место, null, values);
                break;
            }
        case ТОК2.leftCurly:
        case ТОК2.function_:
        case ТОК2.delegate_:
        case_delegate:
            {
                AST.ДСимвол s = parseFunctionLiteral();
                e = new AST.FuncExp(место, s);
                break;
            }
        default:
            выведиОшибку("Выражение expected, not `%s`", token.вТкст0());
        Lerr:
            // Anything for e, as long as it's not NULL
            e = new AST.IntegerExp(место, 0, AST.Тип.tint32);
            nextToken();
            break;
        }
        return e;
    }

    private AST.Выражение parseUnaryExp()
    {
        AST.Выражение e;
        const место = token.место;

        switch (token.значение)
        {
        case ТОК2.and:
            nextToken();
            e = parseUnaryExp();
            e = new AST.AddrExp(место, e);
            break;

        case ТОК2.plusPlus:
            nextToken();
            e = parseUnaryExp();
            //e = new AddAssignExp(место, e, new IntegerExp(место, 1, Тип::tint32));
            e = new AST.PreExp(ТОК2.prePlusPlus, место, e);
            break;

        case ТОК2.minusMinus:
            nextToken();
            e = parseUnaryExp();
            //e = new MinAssignExp(место, e, new IntegerExp(место, 1, Тип::tint32));
            e = new AST.PreExp(ТОК2.preMinusMinus, место, e);
            break;

        case ТОК2.mul:
            nextToken();
            e = parseUnaryExp();
            e = new AST.PtrExp(место, e);
            break;

        case ТОК2.min:
            nextToken();
            e = parseUnaryExp();
            e = new AST.NegExp(место, e);
            break;

        case ТОК2.add:
            nextToken();
            e = parseUnaryExp();
            e = new AST.UAddExp(место, e);
            break;

        case ТОК2.not:
            nextToken();
            e = parseUnaryExp();
            e = new AST.NotExp(место, e);
            break;

        case ТОК2.tilde:
            nextToken();
            e = parseUnaryExp();
            e = new AST.ComExp(место, e);
            break;

        case ТОК2.delete_:
            nextToken();
            e = parseUnaryExp();
            e = new AST.DeleteExp(место, e, нет);
            break;

        case ТОК2.cast_: // cast(тип) Выражение
            {
                nextToken();
                check(ТОК2.leftParentheses);
                /* Look for cast(), cast(const), cast(const),
                 * cast(shared), cast(shared const), cast(wild), cast(shared wild)
                 */
                ббайт m = 0;
                while (1)
                {
                    switch (token.значение)
                    {
                    case ТОК2.const_:
                        if (peekNext() == ТОК2.leftParentheses)
                            break; // const as тип constructor
                        m |= AST.MODFlags.const_; // const as storage class
                        nextToken();
                        continue;

                    case ТОК2.immutable_:
                        if (peekNext() == ТОК2.leftParentheses)
                            break;
                        m |= AST.MODFlags.immutable_;
                        nextToken();
                        continue;

                    case ТОК2.shared_:
                        if (peekNext() == ТОК2.leftParentheses)
                            break;
                        m |= AST.MODFlags.shared_;
                        nextToken();
                        continue;

                    case ТОК2.inout_:
                        if (peekNext() == ТОК2.leftParentheses)
                            break;
                        m |= AST.MODFlags.wild;
                        nextToken();
                        continue;

                    default:
                        break;
                    }
                    break;
                }
                if (token.значение == ТОК2.rightParentheses)
                {
                    nextToken();
                    e = parseUnaryExp();
                    e = new AST.CastExp(место, e, m);
                }
                else
                {
                    AST.Тип t = parseType(); // cast( тип )
                    t = t.addMod(m); // cast( const тип )
                    check(ТОК2.rightParentheses);
                    e = parseUnaryExp();
                    e = new AST.CastExp(место, e, t);
                }
                break;
            }
        case ТОК2.inout_:
        case ТОК2.shared_:
        case ТОК2.const_:
        case ТОК2.immutable_: // const(тип)(arguments) / const(тип).init
            {
                КлассХранения stc = parseTypeCtor();

                AST.Тип t = parseBasicType();
                t = t.addSTC(stc);

                if (stc == 0 && token.значение == ТОК2.dot)
                {
                    nextToken();
                    if (token.значение != ТОК2.идентификатор)
                    {
                        выведиОшибку("идентификатор expected following `(тип)`.");
                        return null;
                    }
                    e = new AST.DotIdExp(место, new AST.TypeExp(место, t), token.идент);
                    nextToken();
                    e = parsePostExp(e);
                }
                else
                {
                    e = new AST.TypeExp(место, t);
                    if (token.значение != ТОК2.leftParentheses)
                    {
                        выведиОшибку("`(arguments)` expected following `%s`", t.вТкст0());
                        return e;
                    }
                    e = new AST.CallExp(место, e, parseArguments());
                }
                break;
            }
        case ТОК2.leftParentheses:
            {
                auto tk = peek(&token);
                static if (CCASTSYNTAX)
                {
                    // If cast
                    if (isDeclaration(tk, NeedDeclaratorId.no, ТОК2.rightParentheses, &tk))
                    {
                        tk = peek(tk); // skip over right parenthesis
                        switch (tk.значение)
                        {
                        case ТОК2.not:
                            tk = peek(tk);
                            if (tk.значение == ТОК2.is_ || tk.значение == ТОК2.in_) // !is or !in
                                break;
                            goto case;

                        case ТОК2.dot:
                        case ТОК2.plusPlus:
                        case ТОК2.minusMinus:
                        case ТОК2.delete_:
                        case ТОК2.new_:
                        case ТОК2.leftParentheses:
                        case ТОК2.идентификатор:
                        case ТОК2.this_:
                        case ТОК2.super_:
                        case ТОК2.int32Literal:
                        case ТОК2.uns32Literal:
                        case ТОК2.int64Literal:
                        case ТОК2.uns64Literal:
                        case ТОК2.int128Literal:
                        case ТОК2.uns128Literal:
                        case ТОК2.float32Literal:
                        case ТОК2.float64Literal:
                        case ТОК2.float80Literal:
                        case ТОК2.imaginary32Literal:
                        case ТОК2.imaginary64Literal:
                        case ТОК2.imaginary80Literal:
                        case ТОК2.null_:
                        case ТОК2.true_:
                        case ТОК2.false_:
                        case ТОК2.charLiteral:
                        case ТОК2.wcharLiteral:
                        case ТОК2.dcharLiteral:
                        case ТОК2.string_:
                            version (none)
                            {
                            case ТОК2.tilde:
                            case ТОК2.and:
                            case ТОК2.mul:
                            case ТОК2.min:
                            case ТОК2.add:
                            }
                        case ТОК2.function_:
                        case ТОК2.delegate_:
                        case ТОК2.typeof_:
                        case ТОК2.traits:
                        case ТОК2.vector:
                        case ТОК2.файл:
                        case ТОК2.fileFullPath:
                        case ТОК2.line:
                        case ТОК2.moduleString:
                        case ТОК2.functionString:
                        case ТОК2.prettyFunction:
                        case ТОК2.wchar_:
                        case ТОК2.dchar_:
                        case ТОК2.бул_:
                        case ТОК2.char_:
                        case ТОК2.int8:
                        case ТОК2.uns8:
                        case ТОК2.int16:
                        case ТОК2.uns16:
                        case ТОК2.int32:
                        case ТОК2.uns32:
                        case ТОК2.int64:
                        case ТОК2.uns64:
                        case ТОК2.int128:
                        case ТОК2.uns128:
                        case ТОК2.float32:
                        case ТОК2.float64:
                        case ТОК2.float80:
                        case ТОК2.imaginary32:
                        case ТОК2.imaginary64:
                        case ТОК2.imaginary80:
                        case ТОК2.complex32:
                        case ТОК2.complex64:
                        case ТОК2.complex80:
                        case ТОК2.void_:
                            {
                                // (тип) una_exp
                                nextToken();
                                auto t = parseType();
                                check(ТОК2.rightParentheses);

                                // if .идентификатор
                                // or .идентификатор!( ... )
                                if (token.значение == ТОК2.dot)
                                {
                                    if (peekNext() != ТОК2.идентификатор && peekNext() != ТОК2.new_)
                                    {
                                        выведиОшибку("идентификатор or new keyword expected following `(...)`.");
                                        return null;
                                    }
                                    e = new AST.TypeExp(место, t);
                                    e.parens = да;
                                    e = parsePostExp(e);
                                }
                                else
                                {
                                    e = parseUnaryExp();
                                    e = new AST.CastExp(место, e, t);
                                    выведиОшибку("C style cast illegal, use `%s`", e.вТкст0());
                                }
                                return e;
                            }
                        default:
                            break;
                        }
                    }
                }
                e = parsePrimaryExp();
                e = parsePostExp(e);
                break;
            }
        default:
            e = parsePrimaryExp();
            e = parsePostExp(e);
            break;
        }
        assert(e);

        // ^^ is right associative and has higher precedence than the unary operators
        while (token.значение == ТОК2.pow)
        {
            nextToken();
            AST.Выражение e2 = parseUnaryExp();
            e = new AST.PowExp(место, e, e2);
        }

        return e;
    }

    private AST.Выражение parsePostExp(AST.Выражение e)
    {
        while (1)
        {
            const место = token.место;
            switch (token.значение)
            {
            case ТОК2.dot:
                nextToken();
                if (token.значение == ТОК2.идентификатор)
                {
                    Идентификатор2 ид = token.идент;

                    nextToken();
                    if (token.значение == ТОК2.not && peekNext() != ТОК2.is_ && peekNext() != ТОК2.in_)
                    {
                        AST.Объекты* tiargs = parseTemplateArguments();
                        e = new AST.DotTemplateInstanceExp(место, e, ид, tiargs);
                    }
                    else
                        e = new AST.DotIdExp(место, e, ид);
                    continue;
                }
                if (token.значение == ТОК2.new_)
                {
                    e = parseNewExp(e);
                    continue;
                }
                выведиОшибку("идентификатор or `new` expected following `.`, not `%s`", token.вТкст0());
                break;

            case ТОК2.plusPlus:
                e = new AST.PostExp(ТОК2.plusPlus, место, e);
                break;

            case ТОК2.minusMinus:
                e = new AST.PostExp(ТОК2.minusMinus, место, e);
                break;

            case ТОК2.leftParentheses:
                e = new AST.CallExp(место, e, parseArguments());
                continue;

            case ТОК2.leftBracket:
                {
                    // массив dereferences:
                    //      массив[index]
                    //      массив[]
                    //      массив[lwr .. upr]
                    AST.Выражение index;
                    AST.Выражение upr;
                    auto arguments = new AST.Выражения();

                    inBrackets++;
                    nextToken();
                    while (token.значение != ТОК2.rightBracket && token.значение != ТОК2.endOfFile)
                    {
                        index = parseAssignExp();
                        if (token.значение == ТОК2.slice)
                        {
                            // массив[..., lwr..upr, ...]
                            nextToken();
                            upr = parseAssignExp();
                            arguments.сунь(new AST.IntervalExp(место, index, upr));
                        }
                        else
                            arguments.сунь(index);
                        if (token.значение == ТОК2.rightBracket)
                            break;
                        check(ТОК2.comma);
                    }
                    check(ТОК2.rightBracket);
                    inBrackets--;
                    e = new AST.ArrayExp(место, e, arguments);
                    continue;
                }
            default:
                return e;
            }
            nextToken();
        }
    }

    private AST.Выражение parseMulExp()
    {
        const место = token.место;
        auto e = parseUnaryExp();

        while (1)
        {
            switch (token.значение)
            {
            case ТОК2.mul:
                nextToken();
                auto e2 = parseUnaryExp();
                e = new AST.MulExp(место, e, e2);
                continue;

            case ТОК2.div:
                nextToken();
                auto e2 = parseUnaryExp();
                e = new AST.DivExp(место, e, e2);
                continue;

            case ТОК2.mod:
                nextToken();
                auto e2 = parseUnaryExp();
                e = new AST.ModExp(место, e, e2);
                continue;

            default:
                break;
            }
            break;
        }
        return e;
    }

    private AST.Выражение parseAddExp()
    {
        const место = token.место;
        auto e = parseMulExp();

        while (1)
        {
            switch (token.значение)
            {
            case ТОК2.add:
                nextToken();
                auto e2 = parseMulExp();
                e = new AST.AddExp(место, e, e2);
                continue;

            case ТОК2.min:
                nextToken();
                auto e2 = parseMulExp();
                e = new AST.MinExp(место, e, e2);
                continue;

            case ТОК2.tilde:
                nextToken();
                auto e2 = parseMulExp();
                e = new AST.CatExp(место, e, e2);
                continue;

            default:
                break;
            }
            break;
        }
        return e;
    }

    private AST.Выражение parseShiftExp()
    {
        const место = token.место;
        auto e = parseAddExp();

        while (1)
        {
            switch (token.значение)
            {
            case ТОК2.leftShift:
                nextToken();
                auto e2 = parseAddExp();
                e = new AST.ShlExp(место, e, e2);
                continue;

            case ТОК2.rightShift:
                nextToken();
                auto e2 = parseAddExp();
                e = new AST.ShrExp(место, e, e2);
                continue;

            case ТОК2.unsignedRightShift:
                nextToken();
                auto e2 = parseAddExp();
                e = new AST.UshrExp(место, e, e2);
                continue;

            default:
                break;
            }
            break;
        }
        return e;
    }

    private AST.Выражение parseCmpExp()
    {
        const место = token.место;

        auto e = parseShiftExp();
        ТОК2 op = token.значение;

        switch (op)
        {
        case ТОК2.equal:
        case ТОК2.notEqual:
            nextToken();
            auto e2 = parseShiftExp();
            e = new AST.EqualExp(op, место, e, e2);
            break;

        case ТОК2.is_:
            op = ТОК2.identity;
            goto L1;

        case ТОК2.not:
        {
            // Attempt to identify '!is'
            const tv = peekNext();
            if (tv == ТОК2.in_)
            {
                nextToken();
                nextToken();
                auto e2 = parseShiftExp();
                e = new AST.InExp(место, e, e2);
                e = new AST.NotExp(место, e);
                break;
            }
            if (tv != ТОК2.is_)
                break;
            nextToken();
            op = ТОК2.notIdentity;
            goto L1;
        }
        L1:
            nextToken();
            auto e2 = parseShiftExp();
            e = new AST.IdentityExp(op, место, e, e2);
            break;

        case ТОК2.lessThan:
        case ТОК2.lessOrEqual:
        case ТОК2.greaterThan:
        case ТОК2.greaterOrEqual:
            nextToken();
            auto e2 = parseShiftExp();
            e = new AST.CmpExp(op, место, e, e2);
            break;

        case ТОК2.in_:
            nextToken();
            auto e2 = parseShiftExp();
            e = new AST.InExp(место, e, e2);
            break;

        default:
            break;
        }
        return e;
    }

    private AST.Выражение parseAndExp()
    {
        Место место = token.место;
        auto e = parseCmpExp();
        while (token.значение == ТОК2.and)
        {
            checkParens(ТОК2.and, e);
            nextToken();
            auto e2 = parseCmpExp();
            checkParens(ТОК2.and, e2);
            e = new AST.AndExp(место, e, e2);
            место = token.место;
        }
        return e;
    }

    private AST.Выражение parseXorExp()
    {
        const место = token.место;

        auto e = parseAndExp();
        while (token.значение == ТОК2.xor)
        {
            checkParens(ТОК2.xor, e);
            nextToken();
            auto e2 = parseAndExp();
            checkParens(ТОК2.xor, e2);
            e = new AST.XorExp(место, e, e2);
        }
        return e;
    }

    private AST.Выражение parseOrExp()
    {
        const место = token.место;

        auto e = parseXorExp();
        while (token.значение == ТОК2.or)
        {
            checkParens(ТОК2.or, e);
            nextToken();
            auto e2 = parseXorExp();
            checkParens(ТОК2.or, e2);
            e = new AST.OrExp(место, e, e2);
        }
        return e;
    }

    private AST.Выражение parseAndAndExp()
    {
        const место = token.место;

        auto e = parseOrExp();
        while (token.значение == ТОК2.andAnd)
        {
            nextToken();
            auto e2 = parseOrExp();
            e = new AST.LogicalExp(место, ТОК2.andAnd, e, e2);
        }
        return e;
    }

    private AST.Выражение parseOrOrExp()
    {
        const место = token.место;

        auto e = parseAndAndExp();
        while (token.значение == ТОК2.orOr)
        {
            nextToken();
            auto e2 = parseAndAndExp();
            e = new AST.LogicalExp(место, ТОК2.orOr, e, e2);
        }
        return e;
    }

    private AST.Выражение parseCondExp()
    {
        const место = token.место;

        auto e = parseOrOrExp();
        if (token.значение == ТОК2.question)
        {
            nextToken();
            auto e1 = parseВыражение();
            check(ТОК2.colon);
            auto e2 = parseCondExp();
            e = new AST.CondExp(место, e, e1, e2);
        }
        return e;
    }

    AST.Выражение parseAssignExp()
    {
        AST.Выражение e;
        e = parseCondExp();
        if (e is null)
            return e;

        // require parens for e.g. `t ? a = 1 : b = 2`
        // Deprecated in 2018-05.
        // @@@DEPRECATED_2.091@@@.
        if (e.op == ТОК2.question && !e.parens && precedence[token.значение] == PREC.assign)
            dmd.errors.deprecation(e.место, "`%s` must be surrounded by parentheses when следщ to operator `%s`",
                e.вТкст0(), Сема2.вТкст0(token.значение));

        const место = token.место;
        switch (token.значение)
        {
        case ТОК2.assign:
            nextToken();
            auto e2 = parseAssignExp();
            e = new AST.AssignExp(место, e, e2);
            break;

        case ТОК2.addAssign:
            nextToken();
            auto e2 = parseAssignExp();
            e = new AST.AddAssignExp(место, e, e2);
            break;

        case ТОК2.minAssign:
            nextToken();
            auto e2 = parseAssignExp();
            e = new AST.MinAssignExp(место, e, e2);
            break;

        case ТОК2.mulAssign:
            nextToken();
            auto e2 = parseAssignExp();
            e = new AST.MulAssignExp(место, e, e2);
            break;

        case ТОК2.divAssign:
            nextToken();
            auto e2 = parseAssignExp();
            e = new AST.DivAssignExp(место, e, e2);
            break;

        case ТОК2.modAssign:
            nextToken();
            auto e2 = parseAssignExp();
            e = new AST.ModAssignExp(место, e, e2);
            break;

        case ТОК2.powAssign:
            nextToken();
            auto e2 = parseAssignExp();
            e = new AST.PowAssignExp(место, e, e2);
            break;

        case ТОК2.andAssign:
            nextToken();
            auto e2 = parseAssignExp();
            e = new AST.AndAssignExp(место, e, e2);
            break;

        case ТОК2.orAssign:
            nextToken();
            auto e2 = parseAssignExp();
            e = new AST.OrAssignExp(место, e, e2);
            break;

        case ТОК2.xorAssign:
            nextToken();
            auto e2 = parseAssignExp();
            e = new AST.XorAssignExp(место, e, e2);
            break;

        case ТОК2.leftShiftAssign:
            nextToken();
            auto e2 = parseAssignExp();
            e = new AST.ShlAssignExp(место, e, e2);
            break;

        case ТОК2.rightShiftAssign:
            nextToken();
            auto e2 = parseAssignExp();
            e = new AST.ShrAssignExp(место, e, e2);
            break;

        case ТОК2.unsignedRightShiftAssign:
            nextToken();
            auto e2 = parseAssignExp();
            e = new AST.UshrAssignExp(место, e, e2);
            break;

        case ТОК2.concatenateAssign:
            nextToken();
            auto e2 = parseAssignExp();
            e = new AST.CatAssignExp(место, e, e2);
            break;

        default:
            break;
        }

        return e;
    }

    /*************************
     * Collect argument list.
     * Assume current token is ',', '$(LPAREN)' or '['.
     */
    private AST.Выражения* parseArguments()
    {
        // function call
        AST.Выражения* arguments;

        arguments = new AST.Выражения();
        const endtok = token.значение == ТОК2.leftBracket ? ТОК2.rightBracket : ТОК2.rightParentheses;

        nextToken();

        while (token.значение != endtok && token.значение != ТОК2.endOfFile)
        {
            auto arg = parseAssignExp();
            arguments.сунь(arg);
            if (token.значение != ТОК2.comma)
                break;

            nextToken(); //comma
        }

        check(endtok);

        return arguments;
    }

    /*******************************************
     */
    private AST.Выражение parseNewExp(AST.Выражение thisexp)
    {
        const место = token.место;

        nextToken();
        AST.Выражения* newargs = null;
        AST.Выражения* arguments = null;
        if (token.значение == ТОК2.leftParentheses)
        {
            newargs = parseArguments();
        }

        // An анонимный nested class starts with "class"
        if (token.значение == ТОК2.class_)
        {
            nextToken();
            if (token.значение == ТОК2.leftParentheses)
                arguments = parseArguments();

            AST.КлассыОсновы* baseclasses = null;
            if (token.значение != ТОК2.leftCurly)
                baseclasses = parseBaseClasses();

            Идентификатор2 ид = null;
            AST.Дсимволы* члены = null;

            if (token.значение != ТОК2.leftCurly)
            {
                выведиОшибку("`{ члены }` expected for анонимный class");
            }
            else
            {
                nextToken();
                члены = parseDeclDefs(0);
                if (token.значение != ТОК2.rightCurly)
                    выведиОшибку("class member expected");
                nextToken();
            }

            auto cd = new AST.ClassDeclaration(место, ид, baseclasses, члены, нет);
            auto e = new AST.NewAnonClassExp(место, thisexp, newargs, cd, arguments);
            return e;
        }

        const stc = parseTypeCtor();
        auto t = parseBasicType(да);
        t = parseBasicType2(t);
        t = t.addSTC(stc);
        if (t.ty == AST.Taarray)
        {
            AST.TypeAArray taa = cast(AST.TypeAArray)t;
            AST.Тип index = taa.index;
            auto edim = AST.типВВыражение(index);
            if (!edim)
            {
                выведиОшибку("cannot создай a `%s` with `new`", t.вТкст0);
                return new AST.NullExp(место);
            }
            t = new AST.TypeSArray(taa.следщ, edim);
        }
        else if (token.значение == ТОК2.leftParentheses && t.ty != AST.Tsarray)
        {
            arguments = parseArguments();
        }

        auto e = new AST.NewExp(место, thisexp, newargs, t, arguments);
        return e;
    }

    /**********************************************
     */
    private проц добавьКоммент(AST.ДСимвол s, ткст0 blockComment)
    {
        if (s !is null)
            this.добавьКоммент(s, blockComment.вТкстД());
    }

    private проц добавьКоммент(AST.ДСимвол s, ткст blockComment)
    {
        if (s !is null)
        {
            s.добавьКоммент(combineComments(blockComment, token.lineComment, да));
            token.lineComment = null;
        }
    }

    /**********************************************
     * Recognize builtin @ attributes
     * Параметры:
     *  идент = идентификатор
     * Возвращает:
     *  storage class for attribute, 0 if not
     */
    static КлассХранения isBuiltinAtAttribute(Идентификатор2 идент)
    {
        return (идент == Id.property) ? AST.STC.property :
               (идент == Id.nogc)     ? AST.STC.nogc     :
               (идент == Id.safe)     ? AST.STC.safe     :
               (идент == Id.trusted)  ? AST.STC.trusted  :
               (идент == Id.system)   ? AST.STC.system   :
               (идент == Id.live)     ? AST.STC.live     :
               (идент == Id.future)   ? AST.STC.future   :
               (идент == Id.disable)  ? AST.STC.disable  :
               0;
    }

    const КлассХранения atAttrGroup =
                AST.STC.property |
                AST.STC.nogc     |
                AST.STC.safe     |
                AST.STC.trusted  |
                AST.STC.system   |
                AST.STC.live     |
                /*AST.STC.future   |*/ // probably should be included
                AST.STC.disable;
    }

enum PREC : цел
{
    нуль,
    expr,
    assign,
    cond,
    oror,
    andand,
    or,
    xor,
    and,
    equal,
    rel,
    shift,
    add,
    mul,
    pow,
    unary,
    primary,
}
