/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/lexer.d, _lexer.d)
 * Documentation:  https://dlang.org/phobos/dmd_lexer.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/lexer.d
 */

module drc.lexer.Lexer2;

import cidrus;

import dmd.entity;
import dmd.errors;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import util.ctfloat;
import util.outbuffer;
import util.port;
import util.rmem;
import util.string;
import drc.lexer.Tokens;
import util.utf;
import core.checkedint : mulu, addu;


private const LS = 0x2028;       // UTF line separator
private const PS = 0x2029;       // UTF paragraph separator

/********************************************
 * Do our own сим maps
 */
private static ббайт[] cmtable() {
    ббайт[256] table;
    foreach (c; new бцел[0 .. table.length])
    {
        if ('0' <= c && c <= '7')
            table[c] |= CMoctal;
        if (c_isxdigit(c))
            table[c] |= CMhex;
        if (c_isalnum(c) || c == '_')
            table[c] |= CMidchar;

        switch (c)
        {
            case 'x': case 'X':
            case 'b': case 'B':
                table[c] |= CMzerosecond;
                break;

            case '0':
			case '9':
            case 'e': case 'E':
            case 'f': case 'F':
            case 'l': case 'L':
            case 'p': case 'P':
            case 'u': case 'U':
            case 'i':
            case '.':
            case '_':
                table[c] |= CMzerosecond | CMdigitsecond;
                break;

            default:
                break;
        }

        switch (c)
        {
            case '\\':
            case '\n':
            case '\r':
            case 0:
            case 0x1A:
            case '\'':
                break;
            default:
                if (!(c & 0x80))
                    table[c] |= CMsinglechar;
                break;
        }
    }
    return table;
}

private
{
    const CMoctal  = 0x1;
    const CMhex    = 0x2;
    const CMidchar = 0x4;
    const CMzerosecond = 0x8;
    const CMdigitsecond = 0x10;
    const CMsinglechar = 0x20;
}

private бул isoctal(сим c)   
{
    return (cmtable[c] & CMoctal) != 0;
}

private бул ishex(сим c)   
{
    return (cmtable[c] & CMhex) != 0;
}

private бул isidchar(сим c)   
{
    return (cmtable[c] & CMidchar) != 0;
}

private бул isZeroSecond(сим c)   
{
    return (cmtable[c] & CMzerosecond) != 0;
}

private бул isDigitSecond(сим c)   
{
    return (cmtable[c] & CMdigitsecond) != 0;
}

private бул issinglechar(сим c)   
{
    return (cmtable[c] & CMsinglechar) != 0;
}

private бул c_isxdigit(цел c)   
{
    return (( c >= '0' && c <= '9') ||
            ( c >= 'a' && c <= 'f') ||
            ( c >= 'A' && c <= 'F'));
}

private бул c_isalnum(цел c)   
{
    return (( c >= '0' && c <= '9') ||
            ( c >= 'a' && c <= 'z') ||
            ( c >= 'A' && c <= 'Z'));
}

unittest
{
    //printf("lexer.unittest\n");
    /* Not much here, just trying things out.
     */
    ткст text = "цел"; // We rely on the implicit null-terminator
    scope Lexer lex1 = new Lexer(null, text.ptr, 0, text.length, 0, 0);
    ТОК2 tok;
    tok = lex1.nextToken();
    //printf("tok == %s, %d, %d\n", Сема2::вТкст0(tok), tok, ТОК2.int32);
    assert(tok == ТОК2.int32);
    tok = lex1.nextToken();
    assert(tok == ТОК2.endOfFile);
    tok = lex1.nextToken();
    assert(tok == ТОК2.endOfFile);
    tok = lex1.nextToken();
    assert(tok == ТОК2.endOfFile);
}

unittest
{
    // We don't want to see Lexer error output during these tests.
    бцел errors = глоб2.startGagging();
    scope(exit) глоб2.endGagging(errors);

    // Test malformed input: even malformed input should end in a ТОК2.endOfFile.
    static const ткст[] testcases =
    [   // Testcase must end with 0 or 0x1A.
        [0], // not malformed, but pathological
        ['\'', 0],
        ['\'', 0x1A],
        ['{', '{', 'q', '{', 0],
        [0xFF, 0],
        [0xFF, 0x80, 0],
        [0xFF, 0xFF, 0],
        [0xFF, 0xFF, 0],
        ['x', '"', 0x1A],
    ];

    foreach (testcase; testcases)
    {
        scope Lexer lex2 = new Lexer(null, testcase.ptr, 0, testcase.length-1, 0, 0);
        ТОК2 tok = lex2.nextToken();
        т_мера iterations = 1;
        while ((tok != ТОК2.endOfFile) && (iterations++ < testcase.length))
        {
            tok = lex2.nextToken();
        }
        assert(tok == ТОК2.endOfFile);
        tok = lex2.nextToken();
        assert(tok == ТОК2.endOfFile);
    }
}

/***********************************************************
 */
class Lexer
{
    private  БуфВыв stringbuffer;

    Место scanloc;            // for error messages
    Место prevloc;            // location of token before current

    ткст0 p;         // current character

    Сема2 token;

    private
    {
        ткст0 base;      // pointer to start of буфер
        ткст0 end;       // pointer to last element of буфер
        ткст0 line;      // start of current line

        бул doDocComment;      // collect doc коммент information
        бул anyToken;          // seen at least one token
        бул commentToken;      // comments are ТОК2.коммент's
        цел inTokenStringConstant; // can be larger than 1 when in nested q{} strings
        цел lastDocLine;        // last line of previous doc коммент

        Сема2* tokenFreelist;
    }

  

    /*********************
     * Creates a Lexer for the source code base[begoffset..endoffset+1].
     * The last character, base[endoffset], must be null (0) or EOF (0x1A).
     *
     * Параметры:
     *  имяф = используется for error messages
     *  base = source code, must be terminated by a null (0) or EOF (0x1A) character
     *  begoffset = starting смещение into base[]
     *  endoffset = the last смещение to читай into base[]
     *  doDocComment = handle documentation comments
     *  commentToken = comments become ТОК2.коммент's
     */
    this(ткст0 имяф, ткст0 base, т_мера begoffset,
        т_мера endoffset, бул doDocComment, бул commentToken) 
    {
        scanloc = Место(имяф, 1, 1);
        //printf("Lexer::Lexer(%p,%d)\n",base,length);
        //printf("lexer.имяф = %s\n", имяф);
        token = Сема2.init;
        this.base = base;
        this.end = base + endoffset;
        p = base + begoffset;
        line = p;
        this.doDocComment = doDocComment;
        this.commentToken = commentToken;
        this.inTokenStringConstant = 0;
        this.lastDocLine = 0;
        //initKeywords();
        /* If first line starts with '#!', ignore the line
         */
        if (p && p[0] == '#' && p[1] == '!')
        {
            p += 2;
            while (1)
            {
                сим c = *p++;
                switch (c)
                {
                case 0:
                case 0x1A:
                    p--;
                    goto case;
                case '\n':
                    break;
                default:
                    continue;
                }
                break;
            }
            endOfLine();
        }
    }

    /// Возвращает: a newly allocated `Сема2`.
    Сема2* allocateToken()   
    {
        if (tokenFreelist)
        {
            Сема2* t = tokenFreelist;
            tokenFreelist = t.следщ;
            t.следщ = null;
            return t;
        }
        return new Сема2();
    }

    /// Frees the given token by returning it to the freelist.
    private проц releaseToken(Сема2* token)    
    {
        if (mem.смИниц_ли)
            *token = Сема2.init;
        token.следщ = tokenFreelist;
        tokenFreelist = token;
    }

    final ТОК2 nextToken()
    {
        prevloc = token.место;
        if (token.следщ)
        {
            Сема2* t = token.следщ;
            memcpy(&token, t, Сема2.sizeof);
            releaseToken(t);
        }
        else
        {
            scan(&token);
        }
        //printf(token.вТкст0());
        return token.значение;
    }

    /***********************
     * Look ahead at следщ token's значение.
     */
    final ТОК2 peekNext()
    {
        return peek(&token).значение;
    }

    /***********************
     * Look 2 tokens ahead at значение.
     */
    final ТОК2 peekNext2()
    {
        Сема2* t = peek(&token);
        return peek(t).значение;
    }

    /****************************
     * Turn следщ token in буфер into a token.
     */
    final проц scan(Сема2* t)
    {
        const lastLine = scanloc.номстр;
        Место startLoc;
        t.blockComment = null;
        t.lineComment = null;

        while (1)
        {
            t.ptr = p;
            //printf("p = %p, *p = '%c'\n",p,*p);
            t.место = место();
            switch (*p)
            {
            case 0:
            case 0x1A:
                t.значение = ТОК2.endOfFile; // end of файл
                // Intentionally not advancing `p`, such that subsequent calls keep returning ТОК2.endOfFile.
                return;
            case ' ':
            case '\t':
            case '\v':
            case '\f':
                p++;
                continue; // skip white space
            case '\r':
                p++;
                if (*p != '\n') // if CR stands by itself
                    endOfLine();
                continue; // skip white space
            case '\n':
                p++;
                endOfLine();
                continue; // skip white space
            case '0':
                if (!isZeroSecond(p[1]))        // if numeric literal does not continue
                {
                    ++p;
                    t.unsvalue = 0;
                    t.значение = ТОК2.int32Literal;
                    return;
                }
                goto Lnumber;

			case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                if (!isDigitSecond(p[1]))       // if numeric literal does not continue
                {
                    t.unsvalue = *p - '0';
                    ++p;
                    t.значение = ТОК2.int32Literal;
                    return;
                }
            Lnumber:
                t.значение = number(t);
                return;

            case '\'':
                if (issinglechar(p[1]) && p[2] == '\'')
                {
                    t.unsvalue = p[1];        // simple one character literal
                    t.значение = ТОК2.charLiteral;
                    p += 3;
                }
                else
                    t.значение = charConstant(t);
                return;
            case 'r':
                if (p[1] != '"')
                    goto case_ident;
                p++;
                goto case '`';
            case '`':
                wysiwygStringConstant(t);
                return;
            case 'x':
                if (p[1] != '"')
                    goto case_ident;
                p++;
                auto start = p;
                auto hexString = new БуфВыв();
                t.значение = hexStringConstant(t);
                hexString.пиши(start[0 .. p - start]);
                выведиОшибку("Built-in hex ткст literals are obsolete, use `std.conv.hexString!%s` instead.", hexString.extractChars());
                return;
            case 'q':
                if (p[1] == '"')
                {
                    p++;
                    delimitedStringConstant(t);
                    return;
                }
                else if (p[1] == '{')
                {
                    p++;
                    tokenStringConstant(t);
                    return;
                }
                else
                    goto case_ident;
            case '"':
                escapeStringConstant(t);
                return;
            case 'a':
            case 'b':
            case 'c':
            case 'd':
            case 'e':
            case 'f':
            case 'g':
            case 'h':
            case 'i':
            case 'j':
            case 'k':
            case 'l':
            case 'm':
            case 'n':
            case 'o':
            case 'p':
                /*case 'q': case 'r':*/
            case 's':
            case 't':
            case 'u':
            case 'v':
            case 'w':
                /*case 'x':*/
            case 'y':
            case 'z':
            case 'A':
            case 'B':
            case 'C':
            case 'D':
            case 'E':
            case 'F':
            case 'G':
            case 'H':
            case 'I':
            case 'J':
            case 'K':
            case 'L':
            case 'M':
            case 'N':
            case 'O':
            case 'P':
            case 'Q':
            case 'R':
            case 'S':
            case 'T':
            case 'U':
            case 'V':
            case 'W':
            case 'X':
            case 'Y':
            case 'Z':
            case '_':
            case_ident:
                {
                    while (1)
                    {
                        const c = *++p;
                        if (isidchar(c))
                            continue;
                        else if (c & 0x80)
                        {
                            const s = p;
                            const u = decodeUTF();
                            if (isUniAlpha(u))
                                continue;
                            выведиОшибку("сим 0x%04x not allowed in идентификатор", u);
                            p = s;
                        }
                        break;
                    }
                    Идентификатор2 ид = Идентификатор2.idPool(cast(сим*)t.ptr, cast(бцел)(p - t.ptr));
                    t.идент = ид;
                    t.значение = cast(ТОК2)ид.дайЗначение();
                    anyToken = 1;
                    if (*t.ptr == '_') // if special идентификатор token
                    {
                         бул initdone = нет;
                         сим[11 + 1] date;
                         сим[8 + 1] time;
                         сим[24 + 1] timestamp;
                        if (!initdone) // lazy evaluation
                        {
                            initdone = да;
                            time_t ct;
                            .time(&ct);
                            const p = ctime(&ct);
                            assert(p);
                            sprintf(&date[0], "%.6s %.4s", p + 4, p + 20);
                            sprintf(&time[0], "%.8s", p + 11);
                            sprintf(&timestamp[0], "%.24s", p);
                        }
                        if (ид == Id.DATE)
                        {
                            t.ustring = date.ptr;
                            goto Lstr;
                        }
                        else if (ид == Id.TIME)
                        {
                            t.ustring = time.ptr;
                            goto Lstr;
                        }
                        else if (ид == Id.VENDOR)
                        {
                            t.ustring = глоб2.vendor.xarraydup.ptr;
                            goto Lstr;
                        }
                        else if (ид == Id.TIMESTAMP)
                        {
                            t.ustring = timestamp.ptr;
                        Lstr:
                            t.значение = ТОК2.string_;
                            t.postfix = 0;
                            t.len = cast(бцел)strlen(t.ustring);
                        }
                        else if (ид == Id.VERSIONX)
                        {
                            t.значение = ТОК2.int64Literal;
                            t.unsvalue = глоб2.versionNumber();
                        }
                        else if (ид == Id.EOFX)
                        {
                            t.значение = ТОК2.endOfFile;
                            // Advance scanner to end of файл
                            while (!(*p == 0 || *p == 0x1A))
                                p++;
                        }
                    }
                    //printf("t.значение = %d\n",t.значение);
                    return;
                }
            case '/':
                p++;
                switch (*p)
                {
                case '=':
                    p++;
                    t.значение = ТОК2.divAssign;
                    return;
                case '*':
                    p++;
                    startLoc = место();
                    while (1)
                    {
                        while (1)
                        {
                            const c = *p;
                            switch (c)
                            {
                            case '/':
                                break;
                            case '\n':
                                endOfLine();
                                p++;
                                continue;
                            case '\r':
                                p++;
                                if (*p != '\n')
                                    endOfLine();
                                continue;
                            case 0:
                            case 0x1A:
                                выведиОшибку("unterminated /* */ коммент");
                                p = end;
                                t.место = место();
                                t.значение = ТОК2.endOfFile;
                                return;
                            default:
                                if (c & 0x80)
                                {
                                    const u = decodeUTF();
                                    if (u == PS || u == LS)
                                        endOfLine();
                                }
                                p++;
                                continue;
                            }
                            break;
                        }
                        p++;
                        if (p[-2] == '*' && p - 3 != t.ptr)
                            break;
                    }
                    if (commentToken)
                    {
                        t.место = startLoc;
                        t.значение = ТОК2.коммент;
                        return;
                    }
                    else if (doDocComment && t.ptr[2] == '*' && p - 4 != t.ptr)
                    {
                        // if /** but not /**/
                        getDocComment(t, lastLine == startLoc.номстр, startLoc.номстр - lastDocLine > 1);
                        lastDocLine = scanloc.номстр;
                    }
                    continue;
                case '/': // do // style comments
                    startLoc = место();
                    while (1)
                    {
                        const c = *++p;
                        switch (c)
                        {
                        case '\n':
                            break;
                        case '\r':
                            if (p[1] == '\n')
                                p++;
                            break;
                        case 0:
                        case 0x1A:
                            if (commentToken)
                            {
                                p = end;
                                t.место = startLoc;
                                t.значение = ТОК2.коммент;
                                return;
                            }
                            if (doDocComment && t.ptr[2] == '/')
                            {
                                getDocComment(t, lastLine == startLoc.номстр, startLoc.номстр - lastDocLine > 1);
                                lastDocLine = scanloc.номстр;
                            }
                            p = end;
                            t.место = место();
                            t.значение = ТОК2.endOfFile;
                            return;
                        default:
                            if (c & 0x80)
                            {
                                const u = decodeUTF();
                                if (u == PS || u == LS)
                                    break;
                            }
                            continue;
                        }
                        break;
                    }
                    if (commentToken)
                    {
                        p++;
                        endOfLine();
                        t.место = startLoc;
                        t.значение = ТОК2.коммент;
                        return;
                    }
                    if (doDocComment && t.ptr[2] == '/')
                    {
                        getDocComment(t, lastLine == startLoc.номстр, startLoc.номстр - lastDocLine > 1);
                        lastDocLine = scanloc.номстр;
                    }
                    p++;
                    endOfLine();
                    continue;
                case '+':
                    {
                        цел nest;
                        startLoc = место();
                        p++;
                        nest = 1;
                        while (1)
                        {
                            сим c = *p;
                            switch (c)
                            {
                            case '/':
                                p++;
                                if (*p == '+')
                                {
                                    p++;
                                    nest++;
                                }
                                continue;
                            case '+':
                                p++;
                                if (*p == '/')
                                {
                                    p++;
                                    if (--nest == 0)
                                        break;
                                }
                                continue;
                            case '\r':
                                p++;
                                if (*p != '\n')
                                    endOfLine();
                                continue;
                            case '\n':
                                endOfLine();
                                p++;
                                continue;
                            case 0:
                            case 0x1A:
                                выведиОшибку("unterminated /+ +/ коммент");
                                p = end;
                                t.место = место();
                                t.значение = ТОК2.endOfFile;
                                return;
                            default:
                                if (c & 0x80)
                                {
                                    бцел u = decodeUTF();
                                    if (u == PS || u == LS)
                                        endOfLine();
                                }
                                p++;
                                continue;
                            }
                            break;
                        }
                        if (commentToken)
                        {
                            t.место = startLoc;
                            t.значение = ТОК2.коммент;
                            return;
                        }
                        if (doDocComment && t.ptr[2] == '+' && p - 4 != t.ptr)
                        {
                            // if /++ but not /++/
                            getDocComment(t, lastLine == startLoc.номстр, startLoc.номстр - lastDocLine > 1);
                            lastDocLine = scanloc.номстр;
                        }
                        continue;
                    }
                default:
                    break;
                }
                t.значение = ТОК2.div;
                return;
            case '.':
                p++;
                if (isdigit(*p))
                {
                    /* Note that we don't allow ._1 and ._ as being
                     * valid floating point numbers.
                     */
                    p--;
                    t.значение = inreal(t);
                }
                else if (p[0] == '.')
                {
                    if (p[1] == '.')
                    {
                        p += 2;
                        t.значение = ТОК2.dotDotDot;
                    }
                    else
                    {
                        p++;
                        t.значение = ТОК2.slice;
                    }
                }
                else
                    t.значение = ТОК2.dot;
                return;
            case '&':
                p++;
                if (*p == '=')
                {
                    p++;
                    t.значение = ТОК2.andAssign;
                }
                else if (*p == '&')
                {
                    p++;
                    t.значение = ТОК2.andAnd;
                }
                else
                    t.значение = ТОК2.and;
                return;
            case '|':
                p++;
                if (*p == '=')
                {
                    p++;
                    t.значение = ТОК2.orAssign;
                }
                else if (*p == '|')
                {
                    p++;
                    t.значение = ТОК2.orOr;
                }
                else
                    t.значение = ТОК2.or;
                return;
            case '-':
                p++;
                if (*p == '=')
                {
                    p++;
                    t.значение = ТОК2.minAssign;
                }
                else if (*p == '-')
                {
                    p++;
                    t.значение = ТОК2.minusMinus;
                }
                else
                    t.значение = ТОК2.min;
                return;
            case '+':
                p++;
                if (*p == '=')
                {
                    p++;
                    t.значение = ТОК2.addAssign;
                }
                else if (*p == '+')
                {
                    p++;
                    t.значение = ТОК2.plusPlus;
                }
                else
                    t.значение = ТОК2.add;
                return;
            case '<':
                p++;
                if (*p == '=')
                {
                    p++;
                    t.значение = ТОК2.lessOrEqual; // <=
                }
                else if (*p == '<')
                {
                    p++;
                    if (*p == '=')
                    {
                        p++;
                        t.значение = ТОК2.leftShiftAssign; // <<=
                    }
                    else
                        t.значение = ТОК2.leftShift; // <<
                }
                else
                    t.значение = ТОК2.lessThan; // <
                return;
            case '>':
                p++;
                if (*p == '=')
                {
                    p++;
                    t.значение = ТОК2.greaterOrEqual; // >=
                }
                else if (*p == '>')
                {
                    p++;
                    if (*p == '=')
                    {
                        p++;
                        t.значение = ТОК2.rightShiftAssign; // >>=
                    }
                    else if (*p == '>')
                    {
                        p++;
                        if (*p == '=')
                        {
                            p++;
                            t.значение = ТОК2.unsignedRightShiftAssign; // >>>=
                        }
                        else
                            t.значение = ТОК2.unsignedRightShift; // >>>
                    }
                    else
                        t.значение = ТОК2.rightShift; // >>
                }
                else
                    t.значение = ТОК2.greaterThan; // >
                return;
            case '!':
                p++;
                if (*p == '=')
                {
                    p++;
                    t.значение = ТОК2.notEqual; // !=
                }
                else
                    t.значение = ТОК2.not; // !
                return;
            case '=':
                p++;
                if (*p == '=')
                {
                    p++;
                    t.значение = ТОК2.equal; // ==
                }
                else if (*p == '>')
                {
                    p++;
                    t.значение = ТОК2.goesTo; // =>
                }
                else
                    t.значение = ТОК2.assign; // =
                return;
            case '~':
                p++;
                if (*p == '=')
                {
                    p++;
                    t.значение = ТОК2.concatenateAssign; // ~=
                }
                else
                    t.значение = ТОК2.tilde; // ~
                return;
            case '^':
                p++;
                if (*p == '^')
                {
                    p++;
                    if (*p == '=')
                    {
                        p++;
                        t.значение = ТОК2.powAssign; // ^^=
                    }
                    else
                        t.значение = ТОК2.pow; // ^^
                }
                else if (*p == '=')
                {
                    p++;
                    t.значение = ТОК2.xorAssign; // ^=
                }
                else
                    t.значение = ТОК2.xor; // ^
                return;
            case '(':
                p++;
                t.значение = ТОК2.leftParentheses;
                return;
            case ')':
                p++;
                t.значение = ТОК2.rightParentheses;
                return;
            case '[':
                p++;
                t.значение = ТОК2.leftBracket;
                return;
            case ']':
                p++;
                t.значение = ТОК2.rightBracket;
                return;
            case '{':
                p++;
                t.значение = ТОК2.leftCurly;
                return;
            case '}':
                p++;
                t.значение = ТОК2.rightCurly;
                return;
            case '?':
                p++;
                t.значение = ТОК2.question;
                return;
            case ',':
                p++;
                t.значение = ТОК2.comma;
                return;
            case ';':
                p++;
                t.значение = ТОК2.semicolon;
                return;
            case ':':
                p++;
                t.значение = ТОК2.colon;
                return;
            case '$':
                p++;
                t.значение = ТОК2.dollar;
                return;
            case '@':
                p++;
                t.значение = ТОК2.at;
                return;
            case '*':
                p++;
                if (*p == '=')
                {
                    p++;
                    t.значение = ТОК2.mulAssign;
                }
                else
                    t.значение = ТОК2.mul;
                return;
            case '%':
                p++;
                if (*p == '=')
                {
                    p++;
                    t.значение = ТОК2.modAssign;
                }
                else
                    t.значение = ТОК2.mod;
                return;
            case '#':
                {
                    p++;
                    Сема2 n;
                    scan(&n);
                    if (n.значение == ТОК2.идентификатор)
                    {
                        if (n.идент == Id.line)
                        {
                            poundLine();
                            continue;
                        }
                        else
                        {
                            const locx = место();
                            warning(locx, "C preprocessor directive `#%s` is not supported", n.идент.вТкст0());
                        }
                    }
                    else if (n.значение == ТОК2.if_)
                    {
                        выведиОшибку("C preprocessor directive `#if` is not supported, use `version` or `static if`");
                    }
                    t.значение = ТОК2.pound;
                    return;
                }
            default:
                {
                    dchar c = *p;
                    if (c & 0x80)
                    {
                        c = decodeUTF();
                        // Check for start of unicode идентификатор
                        if (isUniAlpha(c))
                            goto case_ident;
                        if (c == PS || c == LS)
                        {
                            endOfLine();
                            p++;
                            continue;
                        }
                    }
                    if (c < 0x80 && isprint(c))
                        выведиОшибку("character '%c' is not a valid token", c);
                    else
                        выведиОшибку("character 0x%02x is not a valid token", c);
                    p++;
                    continue;
                }
            }
        }
    }

    final Сема2* peek(Сема2* ct)
    {
        Сема2* t;
        if (ct.следщ)
            t = ct.следщ;
        else
        {
            t = allocateToken();
            scan(t);
            ct.следщ = t;
        }
        return t;
    }

    /*********************************
     * tk is on the opening (.
     * Look ahead and return token that is past the closing ).
     */
    final Сема2* peekPastParen(Сема2* tk)
    {
        //printf("peekPastParen()\n");
        цел parens = 1;
        цел curlynest = 0;
        while (1)
        {
            tk = peek(tk);
            //tk.print();
            switch (tk.значение)
            {
            case ТОК2.leftParentheses:
                parens++;
                continue;
            case ТОК2.rightParentheses:
                --parens;
                if (parens)
                    continue;
                tk = peek(tk);
                break;
            case ТОК2.leftCurly:
                curlynest++;
                continue;
            case ТОК2.rightCurly:
                if (--curlynest >= 0)
                    continue;
                break;
            case ТОК2.semicolon:
                if (curlynest)
                    continue;
                break;
            case ТОК2.endOfFile:
                break;
            default:
                continue;
            }
            return tk;
        }
    }

    /*******************************************
     * Parse ýñêàïèðóé sequence.
     */
    private бцел escapeSequence()
    {
        return Lexer.escapeSequence(token.место, p);
    }

    /**
    Parse the given ткст literal ýñêàïèðóé sequence into a single character.
    Параметры:
        место = the location of the current token
        sequence = pointer to ткст with ýñêàïèðóé sequence to parse. this is a reference
                   variable that is also используется to return the position after the sequence
    Возвращает:
        the escaped sequence as a single character
    */
    private static dchar escapeSequence(ref Место место, ref ткст0 sequence)
    {
        ткст0 p = sequence; // cache sequence reference on stack
        scope(exit) sequence = p;

        бцел c = *p;
        цел ndigits;
        switch (c)
        {
        case '\'':
        case '"':
        case '?':
        case '\\':
        Lconsume:
            p++;
            break;
        case 'a':
            c = 7;
            goto Lconsume;
        case 'b':
            c = 8;
            goto Lconsume;
        case 'f':
            c = 12;
            goto Lconsume;
        case 'n':
            c = 10;
            goto Lconsume;
        case 'r':
            c = 13;
            goto Lconsume;
        case 't':
            c = 9;
            goto Lconsume;
        case 'v':
            c = 11;
            goto Lconsume;
        case 'u':
            ndigits = 4;
            goto Lhex;
        case 'U':
            ndigits = 8;
            goto Lhex;
        case 'x':
            ndigits = 2;
        Lhex:
            p++;
            c = *p;
            if (ishex(cast(сим)c))
            {
                бцел v = 0;
                цел n = 0;
                while (1)
                {
                    if (isdigit(cast(сим)c))
                        c -= '0';
                    else if (islower(c))
                        c -= 'a' - 10;
                    else
                        c -= 'A' - 10;
                    v = v * 16 + c;
                    c = *++p;
                    if (++n == ndigits)
                        break;
                    if (!ishex(cast(сим)c))
                    {
                        .выведиОшибку(место, "ýñêàïèðóé hex sequence has %d hex digits instead of %d", n, ndigits);
                        break;
                    }
                }
                if (ndigits != 2 && !utf_isValidDchar(v))
                {
                    .выведиОшибку(место, "invalid UTF character \\U%08x", v);
                    v = '?'; // recover with valid UTF character
                }
                c = v;
            }
            else
            {
                .выведиОшибку(место, "undefined ýñêàïèðóé hex sequence \\%c%c", sequence[0], c);
                p++;
            }
            break;
        case '&':
            // named character entity
            for (const idstart = ++p; 1; p++)
            {
                switch (*p)
                {
                case ';':
                    c = HtmlNamedEntity(idstart, p - idstart);
                    if (c == ~0)
                    {
                        .выведиОшибку(место, "unnamed character entity &%.*s;", cast(цел)(p - idstart), idstart);
                        c = '?';
                    }
                    p++;
                    break;
                default:
                    if (isalpha(*p) || (p != idstart && isdigit(*p)))
                        continue;
                    .выведиОшибку(место, "unterminated named entity &%.*s;", cast(цел)(p - idstart + 1), idstart);
                    c = '?';
                    break;
                }
                break;
            }
            break;
        case 0:
        case 0x1A:
            // end of файл
            c = '\\';
            break;
        default:
            if (isoctal(cast(сим)c))
            {
                бцел v = 0;
                цел n = 0;
                do
                {
                    v = v * 8 + (c - '0');
                    c = *++p;
                }
                while (++n < 3 && isoctal(cast(сим)c));
                c = v;
                if (c > 0xFF)
                    .выведиОшибку(место, "ýñêàïèðóé octal sequence \\%03o is larger than \\377", c);
            }
            else
            {
                .выведиОшибку(место, "undefined ýñêàïèðóé sequence \\%c", c);
                p++;
            }
            break;
        }
        return c;
    }

    /**
    Lex a wysiwyg ткст. `p` must be pointing to the first character before the
    contents of the ткст literal. The character pointed to by `p` will be используется as
    the terminating character (i.e. backtick or double-quote).
    Параметры:
        результат = pointer to the token that accepts the результат
    */
    private проц wysiwygStringConstant(Сема2* результат)
    {
        результат.значение = ТОК2.string_;
        Место start = место();
        auto terminator = p[0];
        p++;
        stringbuffer.устРазм(0);
        while (1)
        {
            dchar c = p[0];
            p++;
            switch (c)
            {
            case '\n':
                endOfLine();
                break;
            case '\r':
                if (p[0] == '\n')
                    continue; // ignore
                c = '\n'; // treat EndOfLine as \n character
                endOfLine();
                break;
            case 0:
            case 0x1A:
                выведиОшибку("unterminated ткст constant starting at %s", start.вТкст0());
                результат.setString();
                // rewind `p` so it points to the EOF character
                p--;
                return;
            default:
                if (c == terminator)
                {
                    результат.setString(stringbuffer);
                    stringPostfix(результат);
                    return;
                }
                else if (c & 0x80)
                {
                    p--;
                    const u = decodeUTF();
                    p++;
                    if (u == PS || u == LS)
                        endOfLine();
                    stringbuffer.пишиЮ8(u);
                    continue;
                }
                break;
            }
            stringbuffer.пишиБайт(c);
        }
    }

    /**************************************
     * Lex hex strings:
     *      x"0A ae 34FE BD"
     */
    private ТОК2 hexStringConstant(Сема2* t)
    {
        Место start = место();
        бцел n = 0;
        бцел v = ~0; // dead assignment, needed to suppress warning
        p++;
        stringbuffer.устРазм(0);
        while (1)
        {
            dchar c = *p++;
            switch (c)
            {
            case ' ':
            case '\t':
            case '\v':
            case '\f':
                continue; // skip white space
            case '\r':
                if (*p == '\n')
                    continue; // ignore '\r' if followed by '\n'
                // Treat isolated '\r' as if it were a '\n'
                goto case '\n';
            case '\n':
                endOfLine();
                continue;
            case 0:
            case 0x1A:
                выведиОшибку("unterminated ткст constant starting at %s", start.вТкст0());
                t.setString();
                // decrement `p`, because it needs to point to the следщ token (the 0 or 0x1A character is the ТОК2.endOfFile token).
                p--;
                return ТОК2.hexadecimalString;
            case '"':
                if (n & 1)
                {
                    выведиОшибку("odd number (%d) of hex characters in hex ткст", n);
                    stringbuffer.пишиБайт(v);
                }
                t.setString(stringbuffer);
                stringPostfix(t);
                return ТОК2.hexadecimalString;
            default:
                if (c >= '0' && c <= '9')
                    c -= '0';
                else if (c >= 'a' && c <= 'f')
                    c -= 'a' - 10;
                else if (c >= 'A' && c <= 'F')
                    c -= 'A' - 10;
                else if (c & 0x80)
                {
                    p--;
                    const u = decodeUTF();
                    p++;
                    if (u == PS || u == LS)
                        endOfLine();
                    else
                        выведиОшибку("non-hex character \\u%04x in hex ткст", u);
                }
                else
                    выведиОшибку("non-hex character '%c' in hex ткст", c);
                if (n & 1)
                {
                    v = (v << 4) | c;
                    stringbuffer.пишиБайт(v);
                }
                else
                    v = c;
                n++;
                break;
            }
        }
        assert(0); // see bug 15731
    }

    /**
    Lex a delimited ткст. Some examples of delimited strings are:
    ---
    q"(foo(xxx))"      // "foo(xxx)"
    q"[foo$(LPAREN)]"  // "foo$(LPAREN)"
    q"/foo]/"          // "foo]"
    q"HERE
    foo
    HERE"              // "foo\n"
    ---
    It is assumed that `p` points to the opening double-quote '"'.
    Параметры:
        результат = pointer to the token that accepts the результат
    */
    private проц delimitedStringConstant(Сема2* результат)
    {
        результат.значение = ТОК2.string_;
        Место start = место();
        dchar delimleft = 0;
        dchar delimright = 0;
        бцел nest = 1;
        бцел nestcount = ~0; // dead assignment, needed to suppress warning
        Идентификатор2 hereid = null;
        бцел blankrol = 0;
        бцел startline = 0;
        p++;
        stringbuffer.устРазм(0);
        while (1)
        {
            dchar c = *p++;
            //printf("c = '%c'\n", c);
            switch (c)
            {
            case '\n':
            Lnextline:
                endOfLine();
                startline = 1;
                if (blankrol)
                {
                    blankrol = 0;
                    continue;
                }
                if (hereid)
                {
                    stringbuffer.пишиЮ8(c);
                    continue;
                }
                break;
            case '\r':
                if (*p == '\n')
                    continue; // ignore
                c = '\n'; // treat EndOfLine as \n character
                goto Lnextline;
            case 0:
            case 0x1A:
                выведиОшибку("unterminated delimited ткст constant starting at %s", start.вТкст0());
                результат.setString();
                // decrement `p`, because it needs to point to the следщ token (the 0 or 0x1A character is the ТОК2.endOfFile token).
                p--;
                return;
            default:
                if (c & 0x80)
                {
                    p--;
                    c = decodeUTF();
                    p++;
                    if (c == PS || c == LS)
                        goto Lnextline;
                }
                break;
            }
            if (delimleft == 0)
            {
                delimleft = c;
                nest = 1;
                nestcount = 1;
                if (c == '(')
                    delimright = ')';
                else if (c == '{')
                    delimright = '}';
                else if (c == '[')
                    delimright = ']';
                else if (c == '<')
                    delimright = '>';
                else if (isalpha(c) || c == '_' || (c >= 0x80 && isUniAlpha(c)))
                {
                    // Start of идентификатор; must be a heredoc
                    Сема2 tok;
                    p--;
                    scan(&tok); // читай in heredoc идентификатор
                    if (tok.значение != ТОК2.идентификатор)
                    {
                        выведиОшибку("идентификатор expected for heredoc, not %s", tok.вТкст0());
                        delimright = c;
                    }
                    else
                    {
                        hereid = tok.идент;
                        //printf("hereid = '%s'\n", hereid.вТкст0());
                        blankrol = 1;
                    }
                    nest = 0;
                }
                else
                {
                    delimright = c;
                    nest = 0;
                    if (isspace(c))
                        выведиОшибку("delimiter cannot be whitespace");
                }
            }
            else
            {
                if (blankrol)
                {
                    выведиОшибку("heredoc rest of line should be blank");
                    blankrol = 0;
                    continue;
                }
                if (nest == 1)
                {
                    if (c == delimleft)
                        nestcount++;
                    else if (c == delimright)
                    {
                        nestcount--;
                        if (nestcount == 0)
                            goto Ldone;
                    }
                }
                else if (c == delimright)
                    goto Ldone;
                if (startline && (isalpha(c) || c == '_' || (c >= 0x80 && isUniAlpha(c))) && hereid)
                {
                    Сема2 tok;
                    auto psave = p;
                    p--;
                    scan(&tok); // читай in possible heredoc идентификатор
                    //printf("endid = '%s'\n", tok.идент.вТкст0());
                    if (tok.значение == ТОК2.идентификатор && tok.идент is hereid)
                    {
                        /* should check that rest of line is blank
                         */
                        goto Ldone;
                    }
                    p = psave;
                }
                stringbuffer.пишиЮ8(c);
                startline = 0;
            }
        }
    Ldone:
        if (*p == '"')
            p++;
        else if (hereid)
            выведиОшибку("delimited ткст must end in %s\"", hereid.вТкст0());
        else
            выведиОшибку("delimited ткст must end in %c\"", delimright);
        результат.setString(stringbuffer);
        stringPostfix(результат);
    }

    /**
    Lex a token ткст. Some examples of token strings are:
    ---
    q{ foo(xxx) }    // " foo(xxx) "
    q{foo$(LPAREN)}  // "foo$(LPAREN)"
    q{{foo}"}"}      // "{foo}"}""
    ---
    It is assumed that `p` points to the opening curly-brace '{'.
    Параметры:
        результат = pointer to the token that accepts the результат
    */
    private проц tokenStringConstant(Сема2* результат)
    {
        результат.значение = ТОК2.string_;

        бцел nest = 1;
        const start = место();
        const pstart = ++p;
        inTokenStringConstant++;
        scope(exit) inTokenStringConstant--;
        while (1)
        {
            Сема2 tok;
            scan(&tok);
            switch (tok.значение)
            {
            case ТОК2.leftCurly:
                nest++;
                continue;
            case ТОК2.rightCurly:
                if (--nest == 0)
                {
                    результат.setString(pstart, p - 1 - pstart);
                    stringPostfix(результат);
                    return;
                }
                continue;
            case ТОК2.endOfFile:
                выведиОшибку("unterminated token ткст constant starting at %s", start.вТкст0());
                результат.setString();
                return;
            default:
                continue;
            }
        }
    }

    /**
    Scan a double-quoted ткст while building the processed ткст значение by
    handling ýñêàïèðóé sequences. The результат is returned in the given `t` token.
    This function assumes that `p` currently points to the opening double-quote
    of the ткст.
    Параметры:
        t = the token to set the результатing ткст to
    */
    private проц escapeStringConstant(Сема2* t)
    {
        t.значение = ТОК2.string_;

        const start = место();
        p++;
        stringbuffer.устРазм(0);
        while (1)
        {
            dchar c = *p++;
            switch (c)
            {
            case '\\':
                switch (*p)
                {
                case 'u':
                case 'U':
                case '&':
                    c = escapeSequence();
                    stringbuffer.пишиЮ8(c);
                    continue;
                default:
                    c = escapeSequence();
                    break;
                }
                break;
            case '\n':
                endOfLine();
                break;
            case '\r':
                if (*p == '\n')
                    continue; // ignore
                c = '\n'; // treat EndOfLine as \n character
                endOfLine();
                break;
            case '"':
                t.setString(stringbuffer);
                stringPostfix(t);
                return;
            case 0:
            case 0x1A:
                // decrement `p`, because it needs to point to the следщ token (the 0 or 0x1A character is the ТОК2.endOfFile token).
                p--;
                выведиОшибку("unterminated ткст constant starting at %s", start.вТкст0());
                t.setString();
                return;
            default:
                if (c & 0x80)
                {
                    p--;
                    c = decodeUTF();
                    if (c == LS || c == PS)
                    {
                        c = '\n';
                        endOfLine();
                    }
                    p++;
                    stringbuffer.пишиЮ8(c);
                    continue;
                }
                break;
            }
            stringbuffer.пишиБайт(c);
        }
    }

    /**************************************
     */
    private ТОК2 charConstant(Сема2* t)
    {
        ТОК2 tk = ТОК2.charLiteral;
        //printf("Lexer::charConstant\n");
        p++;
        dchar c = *p++;
        switch (c)
        {
        case '\\':
            switch (*p)
            {
            case 'u':
                t.unsvalue = escapeSequence();
                tk = ТОК2.wcharLiteral;
                break;
            case 'U':
            case '&':
                t.unsvalue = escapeSequence();
                tk = ТОК2.dcharLiteral;
                break;
            default:
                t.unsvalue = escapeSequence();
                break;
            }
            break;
        case '\n':
        L1:
            endOfLine();
            goto case;
        case '\r':
            goto case '\'';
        case 0:
        case 0x1A:
            // decrement `p`, because it needs to point to the следщ token (the 0 or 0x1A character is the ТОК2.endOfFile token).
            p--;
            goto case;
        case '\'':
            выведиОшибку("unterminated character constant");
            t.unsvalue = '?';
            return tk;
        default:
            if (c & 0x80)
            {
                p--;
                c = decodeUTF();
                p++;
                if (c == LS || c == PS)
                    goto L1;
                if (c < 0xD800 || (c >= 0xE000 && c < 0xFFFE))
                    tk = ТОК2.wcharLiteral;
                else
                    tk = ТОК2.dcharLiteral;
            }
            t.unsvalue = c;
            break;
        }
        if (*p != '\'')
        {
            while (*p != '\'' && *p != 0x1A && *p != 0 && *p != '\n' &&
                    *p != '\r' && *p != ';' && *p != ')' && *p != ']' && *p != '}')
            {
                if (*p & 0x80)
                {
                    const s = p;
                    c = decodeUTF();
                    if (c == LS || c == PS)
                    {
                        p = s;
                        break;
                    }
                }
                p++;
            }

            if (*p == '\'')
            {
                выведиОшибку("character constant has multiple characters");
                p++;
            }
            else
                выведиОшибку("unterminated character constant");
            t.unsvalue = '?';
            return tk;
        }
        p++;
        return tk;
    }

    /***************************************
     * Get postfix of ткст literal.
     */
    private проц stringPostfix(Сема2* t)  
    {
        switch (*p)
        {
        case 'c':
        case 'w':
        case 'd':
            t.postfix = *p;
            p++;
            break;
        default:
            t.postfix = 0;
            break;
        }
    }

    /**************************************
     * Read in a number.
     * If it's an integer, store it in tok.TKutok.Vlong.
     *      integers can be decimal, octal or hex
     *      Handle the suffixes U, UL, LU, L, etc.
     * If it's double, store it in tok.TKutok.Vdouble.
     * Возвращает:
     *      TKnum
     *      TKdouble,...
     */
    private ТОК2 number(Сема2* t)
    {
        цел base = 10;
        const start = p;
        uinteger_t n = 0; // unsigned >=64 bit integer тип
        цел d;
        бул err = нет;
        бул overflow = нет;
        бул anyBinaryDigitsNoSingleUS = нет;
        бул anyHexDigitsNoSingleUS = нет;
        dchar c = *p;
        if (c == '0')
        {
            ++p;
            c = *p;
            switch (c)
            {
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                base = 8;
                break;
            case 'x':
            case 'X':
                ++p;
                base = 16;
                break;
            case 'b':
            case 'B':
                ++p;
                base = 2;
                break;
            case '.':
                if (p[1] == '.')
                    goto Ldone; // if ".."
                if (isalpha(p[1]) || p[1] == '_' || p[1] & 0x80)
                    goto Ldone; // if ".идентификатор" or ".unicode"
                goto Lreal; // '.' is part of current token
            case 'i':
            case 'f':
            case 'F':
                goto Lreal;
            case '_':
                ++p;
                base = 8;
                break;
            case 'L':
                if (p[1] == 'i')
                    goto Lreal;
                break;
            default:
                break;
            }
        }
        while (1)
        {
            c = *p;
            switch (c)
            {
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                ++p;
                d = c - '0';
                break;
            case 'a':
            case 'b':
            case 'c':
            case 'd':
            case 'e':
            case 'f':
            case 'A':
            case 'B':
            case 'C':
            case 'D':
            case 'E':
            case 'F':
                ++p;
                if (base != 16)
                {
                    if (c == 'e' || c == 'E' || c == 'f' || c == 'F')
                        goto Lreal;
                }
                if (c >= 'a')
                    d = c + 10 - 'a';
                else
                    d = c + 10 - 'A';
                break;
            case 'L':
                if (p[1] == 'i')
                    goto Lreal;
                goto Ldone;
            case '.':
                if (p[1] == '.')
                    goto Ldone; // if ".."
                if (base == 10 && (isalpha(p[1]) || p[1] == '_' || p[1] & 0x80))
                    goto Ldone; // if ".идентификатор" or ".unicode"
                if (base == 16 && (!ishex(p[1]) || p[1] == '_' || p[1] & 0x80))
                    goto Ldone; // if ".идентификатор" or ".unicode"
                if (base == 2)
                    goto Ldone; // if ".идентификатор" or ".unicode"
                goto Lreal; // otherwise as part of a floating point literal
            case 'p':
            case 'P':
            case 'i':
            Lreal:
                p = start;
                return inreal(t);
            case '_':
                ++p;
                continue;
            default:
                goto Ldone;
            }
            // got a digit here, set any necessary flags, check for errors
            anyHexDigitsNoSingleUS = да;
            anyBinaryDigitsNoSingleUS = да;
            if (!err && d >= base)
            {
                выведиОшибку("%s digit expected, not `%c`", base == 2 ? "binary".ptr :
                                                     base == 8 ? "octal".ptr :
                                                     "decimal".ptr, c);
                err = да;
            }
            // Avoid expensive overflow check if we aren't at risk of overflow
            if (n <= 0x0FFF_FFFF_FFFF_FFFFUL)
                n = n * base + d;
            else
            {
                n = mulu(n, base, overflow);
                n = addu(n, d, overflow);
            }
        }
    Ldone:
        if (overflow && !err)
        {
            выведиОшибку("integer overflow");
            err = да;
        }
        if ((base == 2 && !anyBinaryDigitsNoSingleUS) ||
            (base == 16 && !anyHexDigitsNoSingleUS))
            выведиОшибку("`%.*s` isn't a valid integer literal, use `%.*s0` instead", cast(цел)(p - start), start, 2, start);
        enum FLAGS : цел
        {
            none = 0,
            decimal = 1, // decimal
            unsigned = 2, // u or U suffix
            long_ = 4, // L suffix
        }

        FLAGS flags = (base == 10) ? FLAGS.decimal : FLAGS.none;
        // Parse trailing 'u', 'U', 'l' or 'L' in any combination
        const psuffix = p;
        while (1)
        {
            FLAGS f;
            switch (*p)
            {
            case 'U':
            case 'u':
                f = FLAGS.unsigned;
                goto L1;
            case 'l':
                f = FLAGS.long_;
                выведиОшибку("lower case integer suffix 'l' is not allowed. Please use 'L' instead");
                goto L1;
            case 'L':
                f = FLAGS.long_;
            L1:
                p++;
                if ((flags & f) && !err)
                {
                    выведиОшибку("unrecognized token");
                    err = да;
                }
                flags = cast(FLAGS)(flags | f);
                continue;
            default:
                break;
            }
            break;
        }
        if (base == 8 && n >= 8)
        {
            if (err)
                // can't translate invalid octal значение, just show a generic message
                выведиОшибку("octal literals larger than 7 are no longer supported");
            else
                выведиОшибку("octal literals `0%llo%.*s` are no longer supported, use `std.conv.octal!%llo%.*s` instead",
                    n, cast(цел)(p - psuffix), psuffix, n, cast(цел)(p - psuffix), psuffix);
        }
        ТОК2 результат;
        switch (flags)
        {
        case FLAGS.none:
            /* Octal or Hexadecimal constant.
             * First that fits: цел, бцел, long, бдол
             */
            if (n & 0x8000000000000000L)
                результат = ТОК2.uns64Literal;
            else if (n & 0xFFFFFFFF00000000L)
                результат = ТОК2.int64Literal;
            else if (n & 0x80000000)
                результат = ТОК2.uns32Literal;
            else
                результат = ТОК2.int32Literal;
            break;
        case FLAGS.decimal:
            /* First that fits: цел, long, long long
             */
            if (n & 0x8000000000000000L)
            {
                результат = ТОК2.uns64Literal;
            }
            else if (n & 0xFFFFFFFF80000000L)
                результат = ТОК2.int64Literal;
            else
                результат = ТОК2.int32Literal;
            break;
        case FLAGS.unsigned:
        case FLAGS.decimal | FLAGS.unsigned:
            /* First that fits: бцел, бдол
             */
            if (n & 0xFFFFFFFF00000000L)
                результат = ТОК2.uns64Literal;
            else
                результат = ТОК2.uns32Literal;
            break;
        case FLAGS.decimal | FLAGS.long_:
            if (n & 0x8000000000000000L)
            {
                if (!err)
                {
                    выведиОшибку("signed integer overflow");
                    err = да;
                }
                результат = ТОК2.uns64Literal;
            }
            else
                результат = ТОК2.int64Literal;
            break;
        case FLAGS.long_:
            if (n & 0x8000000000000000L)
                результат = ТОК2.uns64Literal;
            else
                результат = ТОК2.int64Literal;
            break;
        case FLAGS.unsigned | FLAGS.long_:
        case FLAGS.decimal | FLAGS.unsigned | FLAGS.long_:
            результат = ТОК2.uns64Literal;
            break;
        default:
            debug
            {
                printf("%x\n", flags);
            }
            assert(0);
        }
        t.unsvalue = n;
        return результат;
    }

    /**************************************
     * Read in characters, converting them to real.
     * Bugs:
     *      Exponent overflow not detected.
     *      Too much requested precision is not detected.
     */
    private ТОК2 inreal(Сема2* t)
    {
        //printf("Lexer::inreal()\n");
        debug
        {
            assert(*p == '.' || isdigit(*p));
        }
        бул isWellformedString = да;
        stringbuffer.устРазм(0);
        auto pstart = p;
        бул hex = нет;
        dchar c = *p++;
        // Leading '0x'
        if (c == '0')
        {
            c = *p++;
            if (c == 'x' || c == 'X')
            {
                hex = да;
                c = *p++;
            }
        }
        // Digits to left of '.'
        while (1)
        {
            if (c == '.')
            {
                c = *p++;
                break;
            }
            if (isdigit(c) || (hex && isxdigit(c)) || c == '_')
            {
                c = *p++;
                continue;
            }
            break;
        }
        // Digits to right of '.'
        while (1)
        {
            if (isdigit(c) || (hex && isxdigit(c)) || c == '_')
            {
                c = *p++;
                continue;
            }
            break;
        }
        if (c == 'e' || c == 'E' || (hex && (c == 'p' || c == 'P')))
        {
            c = *p++;
            if (c == '-' || c == '+')
            {
                c = *p++;
            }
            бул anyexp = нет;
            while (1)
            {
                if (isdigit(c))
                {
                    anyexp = да;
                    c = *p++;
                    continue;
                }
                if (c == '_')
                {
                    c = *p++;
                    continue;
                }
                if (!anyexp)
                {
                    выведиОшибку("missing exponent");
                    isWellformedString = нет;
                }
                break;
            }
        }
        else if (hex)
        {
            выведиОшибку("exponent required for hex float");
            isWellformedString = нет;
        }
        --p;
        while (pstart < p)
        {
            if (*pstart != '_')
                stringbuffer.пишиБайт(*pstart);
            ++pstart;
        }
        stringbuffer.пишиБайт(0);
        auto sbufptr = cast(сим*)stringbuffer[].ptr;
        ТОК2 результат;
        бул isOutOfRange = нет;
        t.floatvalue = (isWellformedString ? CTFloat.parse(sbufptr, &isOutOfRange) : CTFloat.нуль);
        switch (*p)
        {
        case 'F':
        case 'f':
            if (isWellformedString && !isOutOfRange)
                isOutOfRange = Port.isFloat32LiteralOutOfRange(sbufptr);
            результат = ТОК2.float32Literal;
            p++;
            break;
        default:
            if (isWellformedString && !isOutOfRange)
                isOutOfRange = Port.isFloat64LiteralOutOfRange(sbufptr);
            результат = ТОК2.float64Literal;
            break;
        case 'l':
            выведиОшибку("use 'L' suffix instead of 'l'");
            goto case 'L';
        case 'L':
            результат = ТОК2.float80Literal;
            p++;
            break;
        }
        if (*p == 'i' || *p == 'I')
        {
            if (*p == 'I')
                выведиОшибку("use 'i' suffix instead of 'I'");
            p++;
            switch (результат)
            {
            case ТОК2.float32Literal:
                результат = ТОК2.imaginary32Literal;
                break;
            case ТОК2.float64Literal:
                результат = ТОК2.imaginary64Literal;
                break;
            case ТОК2.float80Literal:
                результат = ТОК2.imaginary80Literal;
                break;
            default:
                break;
            }
        }
        const isLong = (результат == ТОК2.float80Literal || результат == ТОК2.imaginary80Literal);
        if (isOutOfRange && !isLong)
        {
            const ткст0 suffix = (результат == ТОК2.float32Literal || результат == ТОК2.imaginary32Literal) ? "f" : "";
            выведиОшибку(scanloc, "number `%s%s` is not representable", sbufptr, suffix);
        }
        debug
        {
            switch (результат)
            {
            case ТОК2.float32Literal:
            case ТОК2.float64Literal:
            case ТОК2.float80Literal:
            case ТОК2.imaginary32Literal:
            case ТОК2.imaginary64Literal:
            case ТОК2.imaginary80Literal:
                break;
            default:
                assert(0);
            }
        }
        return результат;
    }

    final Место место()  
    {
        scanloc.имяс = cast(бцел)(1 + p - line);
        return scanloc;
    }

    final проц выведиОшибку(ткст0 format, ...)
    {
        va_list args;
        va_start(args, format);
        .verror(token.место, format, args);
        va_end(args);
    }

    final проц выведиОшибку(ref Место место, ткст0 format, ...)
    {
        va_list args;
        va_start(args, format);
        .verror(место, format, args);
        va_end(args);
    }

    final проц deprecation(ткст0 format, ...)
    {
        va_list args;
        va_start(args, format);
        .vdeprecation(token.место, format, args);
        va_end(args);
    }

    /*********************************************
     * parse:
     *      #line номстр [filespec]
     * also allow __LINE__ for номстр, and __FILE__ for filespec
     */
    private проц poundLine()
    {
        auto номстр = this.scanloc.номстр;
        ткст0 filespec = null;
        const место = this.место();
        Сема2 tok;
        scan(&tok);
        if (tok.значение == ТОК2.int32Literal || tok.значение == ТОК2.int64Literal)
        {
            const lin = cast(цел)(tok.unsvalue - 1);
            if (lin != tok.unsvalue - 1)
                выведиОшибку("line number `%lld` out of range", cast(бдол)tok.unsvalue);
            else
                номстр = lin;
        }
        else if (tok.значение == ТОК2.line)
        {
        }
        else
            goto Lerr;
        while (1)
        {
            switch (*p)
            {
            case 0:
            case 0x1A:
            case '\n':
            Lnewline:
                if (!inTokenStringConstant)
                {
                    this.scanloc.номстр = номстр;
                    if (filespec)
                        this.scanloc.имяф = filespec;
                }
                return;
            case '\r':
                p++;
                if (*p != '\n')
                {
                    p--;
                    goto Lnewline;
                }
                continue;
            case ' ':
            case '\t':
            case '\v':
            case '\f':
                p++;
                continue; // skip white space
            case '_':
                if (memcmp(p, "__FILE__".ptr, 8) == 0)
                {
                    p += 8;
                    filespec = mem.xstrdup(scanloc.имяф);
                    continue;
                }
                goto Lerr;
            case '"':
                if (filespec)
                    goto Lerr;
                stringbuffer.устРазм(0);
                p++;
                while (1)
                {
                    бцел c;
                    c = *p;
                    switch (c)
                    {
                    case '\n':
                    case '\r':
                    case 0:
                    case 0x1A:
                        goto Lerr;
                    case '"':
                        stringbuffer.пишиБайт(0);
                        filespec = mem.xstrdup(cast(сим*)stringbuffer[].ptr);
                        p++;
                        break;
                    default:
                        if (c & 0x80)
                        {
                            бцел u = decodeUTF();
                            if (u == PS || u == LS)
                                goto Lerr;
                        }
                        stringbuffer.пишиБайт(c);
                        p++;
                        continue;
                    }
                    break;
                }
                continue;
            default:
                if (*p & 0x80)
                {
                    бцел u = decodeUTF();
                    if (u == PS || u == LS)
                        goto Lnewline;
                }
                goto Lerr;
            }
        }
    Lerr:
        выведиОшибку(место, "#line integer [\"filespec\"]\\n expected");
    }

    /********************************************
     * Decode UTF character.
     * Issue error messages for invalid sequences.
     * Return decoded character, advance p to last character in UTF sequence.
     */
    private бцел decodeUTF()
    {
        const s = p;
        assert(*s & 0x80);
        // Check length of remaining ткст up to 4 UTF-8 characters
        т_мера len;
        for (len = 1; len < 4 && s[len]; len++)
        {
        }
        т_мера idx = 0;
        dchar u;
        const msg = utf_decodeChar(s[0 .. len], idx, u);
        p += idx - 1;
        if (msg)
        {
            выведиОшибку("%.*s", cast(цел)msg.length, msg.ptr);
        }
        return u;
    }

    /***************************************************
     * Parse doc коммент embedded between t.ptr and p.
     * Remove trailing blanks and tabs from строки.
     * Replace all newlines with \n.
     * Remove leading коммент character from each line.
     * Decide if it's a lineComment or a blockComment.
     * Append to previous one for this token.
     *
     * If newParagraph is да, an extra newline will be
     * added between adjoining doc comments.
     */
    private проц getDocComment(Сема2* t, бцел lineComment, бул newParagraph) 
    {
        /* ct tells us which вид of коммент it is: '/', '*', or '+'
         */
        const ct = t.ptr[2];
        /* Start of коммент text skips over / * *, / + +, or / / /
         */
        ткст0 q = t.ptr + 3; // start of коммент text
        ткст0 qend = p;
        if (ct == '*' || ct == '+')
            qend -= 2;
        /* Scan over initial row of ****'s or ++++'s or ////'s
         */
        for (; q < qend; q++)
        {
            if (*q != ct)
                break;
        }
        /* Remove leading spaces until start of the коммент
         */
        цел linestart = 0;
        if (ct == '/')
        {
            while (q < qend && (*q == ' ' || *q == '\t'))
                ++q;
        }
        else if (q < qend)
        {
            if (*q == '\r')
            {
                ++q;
                if (q < qend && *q == '\n')
                    ++q;
                linestart = 1;
            }
            else if (*q == '\n')
            {
                ++q;
                linestart = 1;
            }
        }
        /* Remove trailing row of ****'s or ++++'s
         */
        if (ct != '/')
        {
            for (; q < qend; qend--)
            {
                if (qend[-1] != ct)
                    break;
            }
        }
        /* Comment is now [q .. qend].
         * Canonicalize it into буф[].
         */
        БуфВыв буф;

        проц trimTrailingWhitespace()
        {
            const s = буф[];
            auto len = s.length;
            while (len && (s[len - 1] == ' ' || s[len - 1] == '\t'))
                --len;
            буф.устРазм(len);
        }

        for (; q < qend; q++)
        {
            сим c = *q;
            switch (c)
            {
            case '*':
            case '+':
                if (linestart && c == ct)
                {
                    linestart = 0;
                    /* Trim preceding whitespace up to preceding \n
                     */
                    trimTrailingWhitespace();
                    continue;
                }
                break;
            case ' ':
            case '\t':
                break;
            case '\r':
                if (q[1] == '\n')
                    continue; // skip the \r
                goto Lnewline;
            default:
                if (c == 226)
                {
                    // If LS or PS
                    if (q[1] == 128 && (q[2] == 168 || q[2] == 169))
                    {
                        q += 2;
                        goto Lnewline;
                    }
                }
                linestart = 0;
                break;
            Lnewline:
                c = '\n'; // replace all newlines with \n
                goto case;
            case '\n':
                linestart = 1;
                /* Trim trailing whitespace
                 */
                trimTrailingWhitespace();
                break;
            }
            буф.пишиБайт(c);
        }
        /* Trim trailing whitespace (if the last line does not have newline)
         */
        trimTrailingWhitespace();

        // Always end with a newline
        const s = буф[];
        if (s.length == 0 || s[$ - 1] != '\n')
            буф.пишиБайт('\n');

        // It's a line коммент if the start of the doc коммент comes
        // after other non-whitespace on the same line.
        auto dc = (lineComment && anyToken) ? &t.lineComment : &t.blockComment;
        // Combine with previous doc коммент, if any
        if (*dc)
            *dc = combineComments(*dc, буф[], newParagraph).вТкстД();
        else
            *dc = буф.извлекиСрез(да);
    }

    /********************************************
     * Combine two document comments into one,
     * separated by an extra newline if newParagraph is да.
     */
    static ткст0 combineComments(ткст c1, ткст c2, бул newParagraph) 
    {
        //printf("Lexer::combineComments('%s', '%s', '%i')\n", c1, c2, newParagraph);
        const цел newParagraphSize = newParagraph ? 1 : 0; // Size of the combining '\n'
        if (!c1)
            return c2.ptr;
        if (!c2)
            return c1.ptr;

        цел insertNewLine = 0;
        if (c1.length && c1[$ - 1] != '\n')
            insertNewLine = 1;
        const retSize = c1.length + insertNewLine + newParagraphSize + c2.length;
        auto p = cast(сим*)mem.xmalloc_noscan(retSize + 1);
        p[0 .. c1.length] = c1[];
        if (insertNewLine)
            p[c1.length] = '\n';
        if (newParagraph)
            p[c1.length + insertNewLine] = '\n';
        p[retSize - c2.length .. retSize] = c2[];
        p[retSize] = 0;
        return p;
    }

private:
    проц endOfLine()   
    {
        scanloc.номстр++;
        line = p;
    }
}
/+
unittest
{
    import dmd.console;
     бул assertDiagnosticHandler(ref Место место, Color headerColor, ткст0 header,
                                   ткст0 format, va_list ap, ткст0 p1, ткст0 p2)
    {
        assert(0);
    }
    diagnosticHandler = &assertDiagnosticHandler;

    static проц test(T)(ткст sequence, T expected)
    {
        auto p = cast(сим*)sequence.ptr;
        assert(expected == Lexer.escapeSequence(Место.initial, p));
        assert(p == sequence.ptr + sequence.length);
    }

    test(`'`, '\'');
    test(`"`, '"');
    test(`?`, '?');
    test(`\`, '\\');
    test(`0`, '\0');
    test(`a`, '\a');
    test(`b`, '\b');
    test(`f`, '\f');
    test(`n`, '\n');
    test(`r`, '\r');
    test(`t`, '\t');
    test(`v`, '\v');

    test(`x00`, 0x00);
    test(`xff`, 0xff);
    test(`xFF`, 0xff);
    test(`xa7`, 0xa7);
    test(`x3c`, 0x3c);
    test(`xe2`, 0xe2);

    test(`1`, '\1');
    test(`42`, '\42');
    test(`357`, '\357');

    test(`u1234`, '\u1234');
    test(`uf0e4`, '\uf0e4');

    test(`U0001f603`, '\U0001f603');

    test(`&quot;`, '"');
    test(`&lt;`, '<');
    test(`&gt;`, '>');

    diagnosticHandler = null;
}
unittest
{
    import dmd.console;
    ткст expected;
    бул gotError;

     бул expectDiagnosticHandler(ref Место место, Color headerColor, ткст0 header,
                                         ткст0 format, va_list ap, ткст0 p1, ткст0 p2)
    {
        assert(cast(Classification)headerColor == Classification.error);

        gotError = да;
        сим[100] буфер = проц;
        auto actual = буфер[0 .. vsprintf(буфер.ptr, format, ap)];
        assert(expected == actual);
        return да;
    }

    diagnosticHandler = &expectDiagnosticHandler;

    проц test(ткст sequence, ткст expectedError, dchar expectedReturnValue, бцел expectedScanLength)
    {
        бцел errors = глоб2.errors;
        gotError = нет;
        expected = expectedError;
        auto p = cast(сим*)sequence.ptr;
        auto actualReturnValue = Lexer.escapeSequence(Место.initial, p);
        assert(gotError);
        assert(expectedReturnValue == actualReturnValue);

        auto actualScanLength = p - sequence.ptr;
        assert(expectedScanLength == actualScanLength);
        глоб2.errors = errors;
    }

    test("c", `undefined ýñêàïèðóé sequence \c`, 'c', 1);
    test("!", `undefined ýñêàïèðóé sequence \!`, '!', 1);

    test("x1", `ýñêàïèðóé hex sequence has 1 hex digits instead of 2`, '\x01', 2);

    test("u1"  , `ýñêàïèðóé hex sequence has 1 hex digits instead of 4`,   0x1, 2);
    test("u12" , `ýñêàïèðóé hex sequence has 2 hex digits instead of 4`,  0x12, 3);
    test("u123", `ýñêàïèðóé hex sequence has 3 hex digits instead of 4`, 0x123, 4);

    test("U0"      , `ýñêàïèðóé hex sequence has 1 hex digits instead of 8`,       0x0, 2);
    test("U00"     , `ýñêàïèðóé hex sequence has 2 hex digits instead of 8`,      0x00, 3);
    test("U000"    , `ýñêàïèðóé hex sequence has 3 hex digits instead of 8`,     0x000, 4);
    test("U0000"   , `ýñêàïèðóé hex sequence has 4 hex digits instead of 8`,    0x0000, 5);
    test("U0001f"  , `ýñêàïèðóé hex sequence has 5 hex digits instead of 8`,   0x0001f, 6);
    test("U0001f6" , `ýñêàïèðóé hex sequence has 6 hex digits instead of 8`,  0x0001f6, 7);
    test("U0001f60", `ýñêàïèðóé hex sequence has 7 hex digits instead of 8`, 0x0001f60, 8);

    test("ud800"    , `invalid UTF character \U0000d800`, '?', 5);
    test("udfff"    , `invalid UTF character \U0000dfff`, '?', 5);
    test("U00110000", `invalid UTF character \U00110000`, '?', 9);

    test("xg0"      , `undefined ýñêàïèðóé hex sequence \xg`, 'g', 2);
    test("ug000"    , `undefined ýñêàïèðóé hex sequence \ug`, 'g', 2);
    test("Ug0000000", `undefined ýñêàïèðóé hex sequence \Ug`, 'g', 2);

    test("&BAD;", `unnamed character entity &BAD;`  , '?', 5);
    test("&quot", `unterminated named entity &quot;`, '?', 5);

    test("400", `ýñêàïèðóé octal sequence \400 is larger than \377`, 0x100, 3);

    diagnosticHandler = null;
}
+/