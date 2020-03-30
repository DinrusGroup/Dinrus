/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/инструкция.d, _statement.d)
 * Documentation:  https://dlang.org/phobos/dmd_statement.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/инструкция.d
 */

module dmd.инструкция;

import cidrus;

import dmd.aggregate;
import dmd.arraytypes;
import dmd.attrib;
import drc.ast.AstCodegen;
import  drc.ast.Node;
import dmd.gluelayer;
import dmd.canthrow;
import dmd.cond;
import dmd.dclass;
import dmd.declaration;
import dmd.denum;
import dmd.dimport;
import dmd.dscope;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.dtemplate;
import dmd.errors;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.func;
import dmd.globals;
import dmd.hdrgen;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.dinterpret;
import dmd.mtype;
import drc.parser.Parser2;
import util.outbuffer;
import drc.ast.Node;
import dmd.sapply;
import dmd.sideeffect;
import dmd.staticassert;
import drc.lexer.Tokens;
import drc.ast.Visitor;
import dmd.statementsem;

/**
 * Возвращает:
 *     `TypeIdentifier` corresponding to `объект.Throwable`
 */
TypeIdentifier getThrowable()
{
    auto tid = new TypeIdentifier(Место.initial, Id.empty);
    tid.addIdent(Id.объект);
    tid.addIdent(Id.Throwable);
    return tid;
}

/**
 * Возвращает:
 *      TypeIdentifier corresponding to `объект.Exception`
 */
TypeIdentifier getException()
{
    auto tid = new TypeIdentifier(Место.initial, Id.empty);
    tid.addIdent(Id.объект);
    tid.addIdent(Id.Exception);
    return tid;
}

/********************************
 * Identify Инструкция2 types with this enum rather than
 * virtual functions.
 */

enum STMT : ббайт
{
    Error,
    Peel,
    Exp, DtorExp,
    Compile,
    Compound, CompoundDeclaration, CompoundAsm,
    UnrolledLoop,
    Scope,
    Forwarding,
    While,
    Do,
    For,
    Foreach,
    ForeachRange,
    If,
    Conditional,
    StaticForeach,
    Pragma,
    StaticAssert,
    Switch,
    Case,
    CaseRange,
    Default,
    GotoDefault,
    GotoCase,
    SwitchError,
    Return,
    Break,
    Continue,
    Synchronized,
    With,
    TryCatch,
    TryFinally,
    ScopeGuard,
    Throw,
    Debug,
    Goto,
    Label,
    Asm, InlineAsm, GccAsm,
    Импорт,
}


/***********************************************************
 * Specification: http://dlang.org/spec/инструкция.html
 */
 abstract class Инструкция2 : УзелАСД
{
    const Место место;
    const STMT stmt;

    override final ДИНКАСТ динкаст()
    {
        return ДИНКАСТ.инструкция;
    }

    final this(ref Место место, STMT stmt)
    {
        this.место = место;
        this.stmt = stmt;
        // If this is an in{} contract scope инструкция (skip for determining
        //  inlineStatus of a function body for header content)
    }

    Инструкция2 syntaxCopy()
    {
        assert(0);
    }

    /*************************************
     * Do syntax копируй of an массив of Инструкция2's.
     */
    static Инструкции* arraySyntaxCopy(Инструкции* a)
    {
        Инструкции* b = null;
        if (a)
        {
            b = a.копируй();
            foreach (i, s; *a)
            {
                (*b)[i] = s ? s.syntaxCopy() : null;
            }
        }
        return b;
    }

    override final ткст0 вТкст0() 
    {
        HdrGenState hgs;
        БуфВыв буф;
        .toCBuffer(this, &буф, &hgs);
        буф.пишиБайт(0);
        return буф.извлекиСрез().ptr;
    }

    final проц выведиОшибку(ткст0 format, ...)
    {
        va_list ap;
        va_start(ap, format);
        .verror(место, format, ap);
        va_end(ap);
    }

    final проц warning(ткст0 format, ...)
    {
        va_list ap;
        va_start(ap, format);
        .vwarning(место, format, ap);
        va_end(ap);
    }

    final проц deprecation(ткст0 format, ...)
    {
        va_list ap;
        va_start(ap, format);
        .vdeprecation(место, format, ap);
        va_end(ap);
    }

    Инструкция2 getRelatedLabeled()
    {
        return this;
    }

    /****************************
     * Determine if an enclosed `break` would apply to this
     * инструкция, such as if it is a loop or switch инструкция.
     * Возвращает:
     *     `да` if it does
     */
    бул hasBreak()   
    {
        //printf("Инструкция2::hasBreak()\n");
        return нет;
    }

    /****************************
     * Determine if an enclosed `continue` would apply to this
     * инструкция, such as if it is a loop инструкция.
     * Возвращает:
     *     `да` if it does
     */
    бул hasContinue()   
    {
        return нет;
    }

    /**********************************
     * Возвращает:
     *     `да` if инструкция uses exception handling
     */
    final бул usesEH()
    {
         final class UsesEH : StoppableVisitor
        {
            alias  typeof(super).посети посети ;
        public:
            override проц посети(Инструкция2 s)
            {
            }

            override проц посети(TryCatchStatement s)
            {
                stop = да;
            }

            override проц посети(TryFinallyStatement s)
            {
                stop = да;
            }

            override проц посети(ScopeGuardStatement s)
            {
                stop = да;
            }

            override проц посети(SynchronizedStatement s)
            {
                stop = да;
            }
        }

        scope UsesEH ueh = new UsesEH();
        return walkPostorder(this, ueh);
    }

    /**********************************
     * Возвращает:
     *   `да` if инструкция 'comes from' somewhere else, like a goto
     */
    final бул comeFrom()
    {
         final class ComeFrom : StoppableVisitor
        {
            alias  typeof(super).посети посети ;
        public:
            override проц посети(Инструкция2 s)
            {
            }

            override проц посети(CaseStatement s)
            {
                stop = да;
            }

            override проц посети(DefaultStatement s)
            {
                stop = да;
            }

            override проц посети(LabelStatement s)
            {
                stop = да;
            }

            override проц посети(AsmStatement s)
            {
                stop = да;
            }
        }

        scope ComeFrom cf = new ComeFrom();
        return walkPostorder(this, cf);
    }

    /**********************************
     * Возвращает:
     *   `да` if инструкция has executable code.
     */
    final бул hasCode()
    {
         final class HasCode : StoppableVisitor
        {
            alias  typeof(super).посети посети ;
        public:
            override проц посети(Инструкция2 s)
            {
                stop = да;
            }

            override проц посети(ExpStatement s)
            {
                if (s.exp !is null)
                {
                    stop = s.exp.hasCode();
                }
            }

            override проц посети(CompoundStatement s)
            {
            }

            override проц посети(ScopeStatement s)
            {
            }

            override проц посети(ImportStatement s)
            {
            }
        }

        scope HasCode hc = new HasCode();
        return walkPostorder(this, hc);
    }

    /****************************************
     * If this инструкция has code that needs to run in a finally clause
     * at the end of the current scope, return that code in the form of
     * a Инструкция2.
     * Параметры:
     *     sc = context
     *     sentry     = set to code executed upon entry to the scope
     *     sexception = set to code executed upon exit from the scope via exception
     *     sfinally   = set to code executed in finally block
     * Возвращает:
     *    code to be run in the finally clause
     */
    Инструкция2 scopeCode(Scope* sc, Инструкция2* sentry, Инструкция2* sexception, Инструкция2* sfinally)
    {
        //printf("Инструкция2::scopeCode()\n");
        *sentry = null;
        *sexception = null;
        *sfinally = null;
        return this;
    }

    /*********************************
     * Flatten out the scope by presenting the инструкция
     * as an массив of statements.
     * Параметры:
     *     sc = context
     * Возвращает:
     *     The массив of `Инструкции`, or `null` if no flattening necessary
     */
    Инструкции* flatten(Scope* sc)
    {
        return null;
    }

    /*******************************
     * Find last инструкция in a sequence of statements.
     * Возвращает:
     *  the last инструкция, or `null` if there isn't one
     */
    Инструкция2 last()  
    {
        return this;
    }

    /**************************
     * Support Визитор2 Pattern
     * Параметры:
     *  v = visitor
     */
    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }

    /************************************
     * Does this инструкция end with a return инструкция?
     *
     * I.e. is it a single return инструкция or some compound инструкция
     * that unconditionally hits a return инструкция.
     * Возвращает:
     *  return инструкция it ends with, otherwise null
     */
      
    ReturnStatement endsWithReturnStatement() { return null; }
/+
  final  inout  /*:*/

    /********************
     * A cheaper method of doing downcasting of Инструкции.
     * Возвращает:
     *    the downcast инструкция if it can be downcasted, otherwise `null`
     */
    inout(ErrorStatement)       isErrorStatement()       { return stmt == STMT.Error       ? cast(typeof(return))this : null; }
    inout(ScopeStatement)       isScopeStatement()       { return stmt == STMT.Scope       ? cast(typeof(return))this : null; }
    inout(ExpStatement)         isExpStatement()         { return stmt == STMT.Exp         ? cast(typeof(return))this : null; }
    inout(CompoundStatement)    isCompoundStatement()    { return stmt == STMT.Compound    ? cast(typeof(return))this : null; }
    inout(ReturnStatement)      isReturnStatement()      { return stmt == STMT.Return      ? cast(typeof(return))this : null; }
    inout(IfStatement)          isIfStatement()          { return stmt == STMT.If          ? cast(typeof(return))this : null; }
    inout(CaseStatement)        isCaseStatement()        { return stmt == STMT.Case        ? cast(typeof(return))this : null; }
    inout(DefaultStatement)     isDefaultStatement()     { return stmt == STMT.Default     ? cast(typeof(return))this : null; }
    inout(LabelStatement)       isLabelStatement()       { return stmt == STMT.Label       ? cast(typeof(return))this : null; }
    inout(GotoStatement)        isGotoStatement()        { return stmt == STMT.Goto        ? cast(typeof(return))this : null; }
    inout(GotoDefaultStatement) isGotoDefaultStatement() { return stmt == STMT.GotoDefault ? cast(typeof(return))this : null; }
    inout(GotoCaseStatement)    isGotoCaseStatement()    { return stmt == STMT.GotoCase    ? cast(typeof(return))this : null; }
    inout(BreakStatement)       isBreakStatement()       { return stmt == STMT.Break       ? cast(typeof(return))this : null; }
    inout(DtorExpStatement)     isDtorExpStatement()     { return stmt == STMT.DtorExp     ? cast(typeof(return))this : null; }
    inout(ForwardingStatement)  isForwardingStatement()  { return stmt == STMT.Forwarding  ? cast(typeof(return))this : null; }
    inout(DoStatement)          isDoStatement()          { return stmt == STMT.Do          ? cast(typeof(return))this : null; }
    inout(WhileStatement)       isWhileStatement()       { return stmt == STMT.While       ? cast(typeof(return))this : null; }
    inout(ForStatement)         isForStatement()         { return stmt == STMT.For         ? cast(typeof(return))this : null; }
    inout(ForeachStatement)     isForeachStatement()     { return stmt == STMT.Foreach     ? cast(typeof(return))this : null; }
    inout(SwitchStatement)      isSwitchStatement()      { return stmt == STMT.Switch      ? cast(typeof(return))this : null; }
    inout(ContinueStatement)    isContinueStatement()    { return stmt == STMT.Continue    ? cast(typeof(return))this : null; }
    inout(WithStatement)        isWithStatement()        { return stmt == STMT.With        ? cast(typeof(return))this : null; }
    inout(TryCatchStatement)    isTryCatchStatement()    { return stmt == STMT.TryCatch    ? cast(typeof(return))this : null; }
    inout(ThrowStatement)       isThrowStatement()       { return stmt == STMT.Throw       ? cast(typeof(return))this : null; }
    inout(TryFinallyStatement)  isTryFinallyStatement()  { return stmt == STMT.TryFinally  ? cast(typeof(return))this : null; }
    inout(SwitchErrorStatement)  isSwitchErrorStatement()  { return stmt == STMT.SwitchError  ? cast(typeof(return))this : null; }
    inout(UnrolledLoopStatement) isUnrolledLoopStatement() { return stmt == STMT.UnrolledLoop ? cast(typeof(return))this : null; }
    inout(ForeachRangeStatement) isForeachRangeStatement() { return stmt == STMT.ForeachRange ? cast(typeof(return))this : null; }
    inout(CompoundDeclarationStatement) isCompoundDeclarationStatement() { return stmt == STMT.CompoundDeclaration ? cast(typeof(return))this : null; }
+/
}

/***********************************************************
 * Any Инструкция2 that fails semantic() or has a component that is an ErrorExp or
 * a TypeError should return an ErrorStatement from semantic().
 */
 final class ErrorStatement : Инструкция2
{
    this()
    {
        super(Место.initial, STMT.Error);
        assert(глоб2.gaggedErrors || глоб2.errors);
    }

    override Инструкция2 syntaxCopy()
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
 final class PeelStatement : Инструкция2
{
    Инструкция2 s;

    this(Инструкция2 s)
    {
        super(s.место, STMT.Peel);
        this.s = s;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * Convert TemplateMixin члены (== Дсимволы) to Инструкции.
 */
private Инструкция2 toStatement(ДСимвол s)
{
     final class ToStmt : Визитор2
    {
        alias Визитор2.посети посети;
    public:
        Инструкция2 результат;

        Инструкция2 visitMembers(Место место, Дсимволы* a)
        {
            if (!a)
                return null;

            auto statements = new Инструкции();
            foreach (s; *a)
            {
                statements.сунь(toStatement(s));
            }
            return new CompoundStatement(место, statements);
        }

        override проц посети(ДСимвол s)
        {
            .выведиОшибку(Место.initial, "Internal Compiler Error: cannot mixin %s `%s`\n", s.вид(), s.вТкст0());
            результат = new ErrorStatement();
        }

        override проц посети(TemplateMixin tm)
        {
            auto a = new Инструкции();
            foreach (m; *tm.члены)
            {
                Инструкция2 s = toStatement(m);
                if (s)
                    a.сунь(s);
            }
            результат = new CompoundStatement(tm.место, a);
        }

        /* An actual declaration symbol will be converted to DeclarationExp
         * with ExpStatement.
         */
        Инструкция2 declStmt(ДСимвол s)
        {
            auto de = new DeclarationExp(s.место, s);
            de.тип = Тип.tvoid; // avoid repeated semantic
            return new ExpStatement(s.место, de);
        }

        override проц посети(VarDeclaration d)
        {
            результат = declStmt(d);
        }

        override проц посети(AggregateDeclaration d)
        {
            результат = declStmt(d);
        }

        override проц посети(FuncDeclaration d)
        {
            результат = declStmt(d);
        }

        override проц посети(EnumDeclaration d)
        {
            результат = declStmt(d);
        }

        override проц посети(AliasDeclaration d)
        {
            результат = declStmt(d);
        }

        override проц посети(TemplateDeclaration d)
        {
            результат = declStmt(d);
        }

        /* All attributes have been already picked by the semantic analysis of
         * 'bottom' declarations (function, struct, class, etc).
         * So we don't have to копируй them.
         */
        override проц посети(StorageClassDeclaration d)
        {
            результат = visitMembers(d.место, d.decl);
        }

        override проц посети(DeprecatedDeclaration d)
        {
            результат = visitMembers(d.место, d.decl);
        }

        override проц посети(LinkDeclaration d)
        {
            результат = visitMembers(d.место, d.decl);
        }

        override проц посети(ProtDeclaration d)
        {
            результат = visitMembers(d.место, d.decl);
        }

        override проц посети(AlignDeclaration d)
        {
            результат = visitMembers(d.место, d.decl);
        }

        override проц посети(UserAttributeDeclaration d)
        {
            результат = visitMembers(d.место, d.decl);
        }

        override проц посети(ForwardingAttribDeclaration d)
        {
            результат = visitMembers(d.место, d.decl);
        }

        override проц посети(StaticAssert s)
        {
        }

        override проц посети(Импорт s)
        {
        }

        override проц посети(PragmaDeclaration d)
        {
        }

        override проц посети(ConditionalDeclaration d)
        {
            результат = visitMembers(d.место, d.include(null));
        }

        override проц посети(StaticForeachDeclaration d)
        {
            assert(d.sfe && !!d.sfe.aggrfe ^ !!d.sfe.rangefe);
            результат = visitMembers(d.место, d.include(null));
        }

        override проц посети(CompileDeclaration d)
        {
            результат = visitMembers(d.место, d.include(null));
        }
    }

    if (!s)
        return null;

    scope ToStmt v = new ToStmt();
    s.прими(v);
    return v.результат;
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#ВыражениеStatement
 */
 class ExpStatement : Инструкция2
{
    Выражение exp;

    final this(ref Место место, Выражение exp)
    {
        super(место, STMT.Exp);
        this.exp = exp;
    }

    final this(ref Место место, Выражение exp, STMT stmt)
    {
        super(место, stmt);
        this.exp = exp;
    }

    final this(ref Место место, ДСимвол declaration)
    {
        super(место, STMT.Exp);
        this.exp = new DeclarationExp(место, declaration);
    }

    static ExpStatement создай(Место место, Выражение exp)
    {
        return new ExpStatement(место, exp);
    }

    override Инструкция2 syntaxCopy()
    {
        return new ExpStatement(место, exp ? exp.syntaxCopy() : null);
    }

    override final Инструкция2 scopeCode(Scope* sc, Инструкция2* sentry, Инструкция2* sexception, Инструкция2* sfinally)
    {
        //printf("ExpStatement::scopeCode()\n");

        *sentry = null;
        *sexception = null;
        *sfinally = null;

        if (exp && exp.op == ТОК2.declaration)
        {
            auto de = cast(DeclarationExp)exp;
            auto v = de.declaration.isVarDeclaration();
            if (v && !v.isDataseg())
            {
                if (v.needsScopeDtor())
                {
                    *sfinally = new DtorExpStatement(место, v.edtor, v);
                    v.класс_хранения |= STC.nodtor; // don't add in dtor again
                }
            }
        }
        return this;
    }

    override final Инструкции* flatten(Scope* sc)
    {
        /* https://issues.dlang.org/show_bug.cgi?ид=14243
         * expand template mixin in инструкция scope
         * to handle variable destructors.
         */
        if (exp && exp.op == ТОК2.declaration)
        {
            ДСимвол d = (cast(DeclarationExp)exp).declaration;
            if (TemplateMixin tm = d.isTemplateMixin())
            {
                Выражение e = exp.ВыражениеSemantic(sc);
                if (e.op == ТОК2.error || tm.errors)
                {
                    auto a = new Инструкции();
                    a.сунь(new ErrorStatement());
                    return a;
                }
                assert(tm.члены);

                Инструкция2 s = toStatement(tm);
                version (none)
                {
                    БуфВыв буф;
                    буф.doindent = 1;
                    HdrGenState hgs;
                    hgs.hdrgen = да;
                    toCBuffer(s, &буф, &hgs);
                    printf("tm ==> s = %s\n", буф.peekChars());
                }
                auto a = new Инструкции();
                a.сунь(s);
                return a;
            }
        }
        return null;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class DtorExpStatement : ExpStatement
{
    // Wraps an Выражение that is the destruction of 'var'
    VarDeclaration var;

    this(ref Место место, Выражение exp, VarDeclaration var)
    {
        super(место, exp, STMT.DtorExp);
        this.var = var;
    }

    override Инструкция2 syntaxCopy()
    {
        return new DtorExpStatement(место, exp ? exp.syntaxCopy() : null, var);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#mixin-инструкция
 */
 final class CompileStatement : Инструкция2
{
    Выражения* exps;

    this(ref Место место, Выражение exp)
    {
        Выражения* exps = new Выражения();
        exps.сунь(exp);
        this(место, exps);
    }

    this(ref Место место, Выражения* exps)
    {
        super(место, STMT.Compile);
        this.exps = exps;
    }

    override Инструкция2 syntaxCopy()
    {
        return new CompileStatement(место, Выражение.arraySyntaxCopy(exps));
    }

    private Инструкции* compileIt(Scope* sc)
    {
        //printf("CompileStatement::compileIt() %s\n", exp.вТкст0());

        проц[] errorStatements()
        {
            auto a = new Инструкции();
            a.сунь(new ErrorStatement());
            return a;
        }


        БуфВыв буф;
        if (выраженияВТкст(буф, sc, exps))
            return errorStatements();

        const errors = глоб2.errors;
        const len = буф.length;
        буф.пишиБайт(0);
        const str = буф.извлекиСрез()[0 .. len];
        scope p = new Parser!(ASTCodegen)(место, sc._module, str, нет);
        p.nextToken();

        auto a = new Инструкции();
        while (p.token.значение != ТОК2.endOfFile)
        {
            Инструкция2 s = p.parseStatement(ParseStatementFlags.semi | ParseStatementFlags.curlyScope);
            if (!s || глоб2.errors != errors)
                return errorStatements();
            a.сунь(s);
        }
        return a;
    }

    override Инструкции* flatten(Scope* sc)
    {
        //printf("CompileStatement::flatten() %s\n", exp.вТкст0());
        return compileIt(sc);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 class CompoundStatement : Инструкция2
{
    Инструкции* statements;

    /**
     * Construct a `CompoundStatement` using an already existing
     * массив of `Инструкция2`s
     *
     * Параметры:
     *   место = Instantiation information
     *   statements   = An массив of `Инструкция2`s, that will referenced by this class
     */
    final this(ref Место место, Инструкции* statements)
    {
        super(место, STMT.Compound);
        this.statements = statements;
    }

    final this(ref Место место, Инструкции* statements, STMT stmt)
    {
        super(место, stmt);
        this.statements = statements;
    }

    /**
     * Construct a `CompoundStatement` from an массив of `Инструкция2`s
     *
     * Параметры:
     *   место = Instantiation information
     *   sts   = A variadic массив of `Инструкция2`s, that will copied in this class
     *         The entries themselves will not be copied.
     */
    final this(ref Место место, Инструкция2[] sts...)
    {
        super(место, STMT.Compound);
        statements = new Инструкции();
        statements.резервируй(sts.length);
        foreach (s; sts)
            statements.сунь(s);
    }

    static CompoundStatement создай(Место место, Инструкция2 s1, Инструкция2 s2)
    {
        return new CompoundStatement(место, s1, s2);
    }

    override Инструкция2 syntaxCopy()
    {
        return new CompoundStatement(место, Инструкция2.arraySyntaxCopy(statements));
    }

    override Инструкции* flatten(Scope* sc)
    {
        return statements;
    }

    override final ReturnStatement endsWithReturnStatement()  
    {
        foreach (s; *statements)
        {
            if (s)
            {
                if (auto rs = s.endsWithReturnStatement())
                    return rs;
            }
        }
        return null;
    }

    override final Инструкция2 last()   
    {
        Инструкция2 s = null;
        for (т_мера i = statements.dim; i; --i)
        {
            s = cast(Инструкция2)(*statements)[i - 1];
            if (s)
            {
                s = cast(Инструкция2)s.last();
                if (s)
                    break;
            }
        }
        return s;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class CompoundDeclarationStatement : CompoundStatement
{
    this(ref Место место, Инструкции* statements)
    {
        super(место, statements, STMT.CompoundDeclaration);
    }

    override Инструкция2 syntaxCopy()
    {
        auto a = new Инструкции(statements.dim);
        foreach (i, s; *statements)
        {
            (*a)[i] = s ? s.syntaxCopy() : null;
        }
        return new CompoundDeclarationStatement(место, a);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * The purpose of this is so that continue will go to the следщ
 * of the statements, and break will go to the end of the statements.
 */
 final class UnrolledLoopStatement : Инструкция2
{
    Инструкции* statements;

    this(ref Место место, Инструкции* statements)
    {
        super(место, STMT.UnrolledLoop);
        this.statements = statements;
    }

    override Инструкция2 syntaxCopy()
    {
        auto a = new Инструкции(statements.dim);
        foreach (i, s; *statements)
        {
            (*a)[i] = s ? s.syntaxCopy() : null;
        }
        return new UnrolledLoopStatement(место, a);
    }

    override бул hasBreak()  
    {
        return да;
    }

    override бул hasContinue()  
    {
        return да;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 class ScopeStatement : Инструкция2
{
    Инструкция2 инструкция;
    Место endloc;                 // location of closing curly bracket

    this(ref Место место, Инструкция2 инструкция, Место endloc)
    {
        super(место, STMT.Scope);
        this.инструкция = инструкция;
        this.endloc = endloc;
    }
    override Инструкция2 syntaxCopy()
    {
        return new ScopeStatement(место, инструкция ? инструкция.syntaxCopy() : null, endloc);
    }

    override ReturnStatement endsWithReturnStatement()  
    {
        if (инструкция)
            return инструкция.endsWithReturnStatement();
        return null;
    }

    override бул hasBreak()   
    {
        //printf("ScopeStatement::hasBreak() %s\n", вТкст0());
        return инструкция ? инструкция.hasBreak() : нет;
    }

    override бул hasContinue()   
    {
        return инструкция ? инструкция.hasContinue() : нет;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * Инструкция2 whose symbol table содержит foreach index variables in a
 * local scope and forwards other члены to the родитель scope.  This
 * wraps a инструкция.
 *
 * Also see: `dmd.attrib.ForwardingAttribDeclaration`
 */
 final class ForwardingStatement : Инструкция2
{
    /// The symbol containing the `static foreach` variables.
    ForwardingScopeDsymbol sym = null;
    /// The wrapped инструкция.
    Инструкция2 инструкция;

    this(ref Место место, ForwardingScopeDsymbol sym, Инструкция2 инструкция)
    {
        super(место, STMT.Forwarding);
        this.sym = sym;
        assert(инструкция);
        this.инструкция = инструкция;
    }

    this(ref Место место, Инструкция2 инструкция)
    {
        auto sym = new ForwardingScopeDsymbol(null);
        sym.symtab = new DsymbolTable();
        this(место, sym, инструкция);
    }

    override Инструкция2 syntaxCopy()
    {
        return new ForwardingStatement(место, инструкция.syntaxCopy());
    }

    /***********************
     * ForwardingStatements are distributed over the flattened
     * sequence of statements. This prevents flattening to be
     * "blocked" by a ForwardingStatement and is necessary, for
     * example, to support generating scope guards with `static
     * foreach`:
     *
     *     static foreach(i; 0 .. 10) scope(exit) writeln(i);
     *     writeln("this is printed first");
     *     // then, it prints 10, 9, 8, 7, ...
     */

    override Инструкции* flatten(Scope* sc)
    {
        if (!инструкция)
        {
            return null;
        }
        sc = sc.сунь(sym);
        auto a = инструкция.flatten(sc);
        sc = sc.вынь();
        if (!a)
        {
            return a;
        }
        auto b = new Инструкции(a.dim);
        foreach (i, s; *a)
        {
            (*b)[i] = s ? new ForwardingStatement(s.место, sym, s) : null;
        }
        return b;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}


/***********************************************************
 * https://dlang.org/spec/инструкция.html#while-инструкция
 */
 final class WhileStatement : Инструкция2
{
    Выражение условие;
    Инструкция2 _body;
    Место endloc;             // location of closing curly bracket

    this(ref Место место, Выражение условие, Инструкция2 _body, Место endloc)
    {
        super(место, STMT.While);
        this.условие = условие;
        this._body = _body;
        this.endloc = endloc;
    }

    override Инструкция2 syntaxCopy()
    {
        return new WhileStatement(место,
            условие.syntaxCopy(),
            _body ? _body.syntaxCopy() : null,
            endloc);
    }

    override бул hasBreak()   
    {
        return да;
    }

    override бул hasContinue()   
    {
        return да;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#do-инструкция
 */
 final class DoStatement : Инструкция2
{
    Инструкция2 _body;
    Выражение условие;
    Место endloc;                 // location of ';' after while

    this(ref Место место, Инструкция2 _body, Выражение условие, Место endloc)
    {
        super(место, STMT.Do);
        this._body = _body;
        this.условие = условие;
        this.endloc = endloc;
    }

    override Инструкция2 syntaxCopy()
    {
        return new DoStatement(место,
            _body ? _body.syntaxCopy() : null,
            условие.syntaxCopy(),
            endloc);
    }

    override бул hasBreak()   
    {
        return да;
    }

    override бул hasContinue()   
    {
        return да;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#for-инструкция
 */
 final class ForStatement : Инструкция2
{
    Инструкция2 _иниц;
    Выражение условие;
    Выражение increment;
    Инструкция2 _body;
    Место endloc;             // location of closing curly bracket

    // When wrapped in try/finally clauses, this points to the outermost one,
    // which may have an associated label. Internal break/continue statements
    // treat that label as referring to this loop.
    Инструкция2 relatedLabeled;

    this(ref Место место, Инструкция2 _иниц, Выражение условие, Выражение increment, Инструкция2 _body, Место endloc)
    {
        super(место, STMT.For);
        this._иниц = _иниц;
        this.условие = условие;
        this.increment = increment;
        this._body = _body;
        this.endloc = endloc;
    }

    override Инструкция2 syntaxCopy()
    {
        return new ForStatement(место,
            _иниц ? _иниц.syntaxCopy() : null,
            условие ? условие.syntaxCopy() : null,
            increment ? increment.syntaxCopy() : null,
            _body.syntaxCopy(),
            endloc);
    }

    override Инструкция2 scopeCode(Scope* sc, Инструкция2* sentry, Инструкция2* sexception, Инструкция2* sfinally)
    {
        //printf("ForStatement::scopeCode()\n");
        Инструкция2.scopeCode(sc, sentry, sexception, sfinally);
        return this;
    }

    override Инструкция2 getRelatedLabeled()
    {
        return relatedLabeled ? relatedLabeled : this;
    }

    override бул hasBreak()   
    {
        //printf("ForStatement::hasBreak()\n");
        return да;
    }

    override бул hasContinue()   
    {
        return да;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#foreach-инструкция
 */
 final class ForeachStatement : Инструкция2
{
    ТОК2 op;                     // ТОК2.foreach_ or ТОК2.foreach_reverse_
    Параметры* parameters;     // массив of Параметры, one for each ForeachType
    Выражение aggr;            // ForeachAggregate
    Инструкция2 _body;            // NoScopeNonEmptyStatement
    Место endloc;                 // location of closing curly bracket

    VarDeclaration ключ;
    VarDeclaration значение;

    FuncDeclaration func;       // function we're lexically in

    Инструкции* cases;          // put breaks, continues, gotos and returns here
    ScopeStatements* gotos;     // forward referenced goto's go here

    this(ref Место место, ТОК2 op, Параметры* parameters, Выражение aggr, Инструкция2 _body, Место endloc)
    {
        super(место, STMT.Foreach);
        this.op = op;
        this.parameters = parameters;
        this.aggr = aggr;
        this._body = _body;
        this.endloc = endloc;
    }

    override Инструкция2 syntaxCopy()
    {
        return new ForeachStatement(место, op,
            Параметр2.arraySyntaxCopy(parameters),
            aggr.syntaxCopy(),
            _body ? _body.syntaxCopy() : null,
            endloc);
    }

    override бул hasBreak()   
    {
        return да;
    }

    override бул hasContinue()   
    {
        return да;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#foreach-range-инструкция
 */
 final class ForeachRangeStatement : Инструкция2
{
    ТОК2 op;                 // ТОК2.foreach_ or ТОК2.foreach_reverse_
    Параметр2 prm;          // loop index variable
    Выражение lwr;
    Выражение upr;
    Инструкция2 _body;
    Место endloc;             // location of closing curly bracket

    VarDeclaration ключ;

    this(ref Место место, ТОК2 op, Параметр2 prm, Выражение lwr, Выражение upr, Инструкция2 _body, Место endloc)
    {
        super(место, STMT.ForeachRange);
        this.op = op;
        this.prm = prm;
        this.lwr = lwr;
        this.upr = upr;
        this._body = _body;
        this.endloc = endloc;
    }

    override Инструкция2 syntaxCopy()
    {
        return new ForeachRangeStatement(место, op, prm.syntaxCopy(), lwr.syntaxCopy(), upr.syntaxCopy(), _body ? _body.syntaxCopy() : null, endloc);
    }

    override бул hasBreak()   
    {
        return да;
    }

    override бул hasContinue()   
    {
        return да;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#if-инструкция
 */
 final class IfStatement : Инструкция2
{
    Параметр2 prm;
    Выражение условие;
    Инструкция2 ifbody;
    Инструкция2 elsebody;
    VarDeclaration match;   // for MatchВыражение результатs
    Место endloc;                 // location of closing curly bracket

    this(ref Место место, Параметр2 prm, Выражение условие, Инструкция2 ifbody, Инструкция2 elsebody, Место endloc)
    {
        super(место, STMT.If);
        this.prm = prm;
        this.условие = условие;
        this.ifbody = ifbody;
        this.elsebody = elsebody;
        this.endloc = endloc;
    }

    override Инструкция2 syntaxCopy()
    {
        return new IfStatement(место,
            prm ? prm.syntaxCopy() : null,
            условие.syntaxCopy(),
            ifbody ? ifbody.syntaxCopy() : null,
            elsebody ? elsebody.syntaxCopy() : null,
            endloc);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/version.html#ConditionalStatement
 */
 final class ConditionalStatement : Инструкция2
{
    Condition условие;
    Инструкция2 ifbody;
    Инструкция2 elsebody;

    this(ref Место место, Condition условие, Инструкция2 ifbody, Инструкция2 elsebody)
    {
        super(место, STMT.Conditional);
        this.условие = условие;
        this.ifbody = ifbody;
        this.elsebody = elsebody;
    }

    override Инструкция2 syntaxCopy()
    {
        return new ConditionalStatement(место, условие.syntaxCopy(), ifbody.syntaxCopy(), elsebody ? elsebody.syntaxCopy() : null);
    }

    override Инструкции* flatten(Scope* sc)
    {
        Инструкция2 s;

        //printf("ConditionalStatement::flatten()\n");
        if (условие.include(sc))
        {
            DebugCondition dc = условие.isDebugCondition();
            if (dc)
                s = new DebugStatement(место, ifbody);
            else
                s = ifbody;
        }
        else
            s = elsebody;

        auto a = new Инструкции();
        a.сунь(s);
        return a;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/version.html#StaticForeachStatement
 * Static foreach statements, like:
 *      проц main()
 *      {
 *           static foreach(i; 0 .. 10)
 *           {
 *               pragma(msg, i);
 *           }
 *      }
 */
 final class StaticForeachStatement : Инструкция2
{
    StaticForeach sfe;

    this(ref Место место, StaticForeach sfe)
    {
        super(место, STMT.StaticForeach);
        this.sfe = sfe;
    }

    override Инструкция2 syntaxCopy()
    {
        return new StaticForeachStatement(место, sfe.syntaxCopy());
    }

    override Инструкции* flatten(Scope* sc)
    {
        sfe.prepare(sc);
        if (sfe.ready())
        {
            
            auto s = makeTupleForeach!(да, нет)(sc, sfe.aggrfe, sfe.needExpansion);
            auto результат = s.flatten(sc);
            if (результат)
            {
                return результат;
            }
            результат = new Инструкции();
            результат.сунь(s);
            return результат;
        }
        else
        {
            auto результат = new Инструкции();
            результат.сунь(new ErrorStatement());
            return результат;
        }
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#pragma-инструкция
 */
 final class PragmaStatement : Инструкция2
{
    const Идентификатор2 идент;
    Выражения* args;      // массив of Выражение's
    Инструкция2 _body;

    this(ref Место место, Идентификатор2 идент, Выражения* args, Инструкция2 _body)
    {
        super(место, STMT.Pragma);
        this.идент = идент;
        this.args = args;
        this._body = _body;
    }

    override Инструкция2 syntaxCopy()
    {
        return new PragmaStatement(место, идент, Выражение.arraySyntaxCopy(args), _body ? _body.syntaxCopy() : null);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/version.html#StaticAssert
 */
 final class StaticAssertStatement : Инструкция2
{
    StaticAssert sa;

    this(StaticAssert sa)
    {
        super(sa.место, STMT.StaticAssert);
        this.sa = sa;
    }

    override Инструкция2 syntaxCopy()
    {
        return new StaticAssertStatement(cast(StaticAssert)sa.syntaxCopy(null));
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#switch-инструкция
 */
 final class SwitchStatement : Инструкция2
{
    Выражение условие;           /// switch(условие)
    Инструкция2 _body;                ///
    бул isFinal;                   /// https://dlang.org/spec/инструкция.html#final-switch-инструкция

    DefaultStatement sdefault;      /// default:
    Инструкция2 tryBody;              /// set to TryCatchStatement or TryFinallyStatement if in _body portion
    TryFinallyStatement tf;         /// set if in the 'finally' block of a TryFinallyStatement
    GotoCaseStatements gotoCases;   /// массив of unresolved GotoCaseStatement's
    CaseStatements* cases;          /// массив of CaseStatement's
    цел hasNoDefault;               /// !=0 if no default инструкция
    цел hasVars;                    /// !=0 if has variable case values
    VarDeclaration lastVar;         /// last observed variable declaration in this инструкция

    this(ref Место место, Выражение условие, Инструкция2 _body, бул isFinal)
    {
        super(место, STMT.Switch);
        this.условие = условие;
        this._body = _body;
        this.isFinal = isFinal;
    }

    override Инструкция2 syntaxCopy()
    {
        return new SwitchStatement(место, условие.syntaxCopy(), _body.syntaxCopy(), isFinal);
    }

    override бул hasBreak()   
    {
        return да;
    }

    /************************************
     * Возвращает:
     *  да if error
     */
    extern (D) бул checkLabel()
    {
        /*
         * Checks the scope of a label for existing variable declaration.
         * Параметры:
         *   vd = last variable declared before this case/default label
         * Возвращает: `да` if the variables declared in this label would be skipped.
         */
        бул checkVar(VarDeclaration vd)
        {
            for (auto v = vd; v && v != lastVar; v = v.lastVar)
            {
                if (v.isDataseg() || (v.класс_хранения & (STC.manifest | STC.temp)) || v._иниц.isVoidInitializer())
                    continue;
                if (vd.идент == Id.withSym)
                    выведиОшибку("`switch` skips declaration of `with` temporary at %s", v.место.вТкст0());
                else
                    выведиОшибку("`switch` skips declaration of variable `%s` at %s", v.toPrettyChars(), v.место.вТкст0());
                return да;
            }
            return нет;
        }

        const error = да;

        if (sdefault && checkVar(sdefault.lastVar))
            return !error; // return error once fully deprecated

        foreach (scase; *cases)
        {
            if (scase && checkVar(scase.lastVar))
                return !error; // return error once fully deprecated
        }
        return !error;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#CaseStatement
 */
 final class CaseStatement : Инструкция2
{
    Выражение exp;
    Инструкция2 инструкция;

    цел index;              // which case it is (since we sort this)
    VarDeclaration lastVar;
    ук extra;            // for use by Statement_toIR()

    this(ref Место место, Выражение exp, Инструкция2 инструкция)
    {
        super(место, STMT.Case);
        this.exp = exp;
        this.инструкция = инструкция;
    }

    override Инструкция2 syntaxCopy()
    {
        return new CaseStatement(место, exp.syntaxCopy(), инструкция.syntaxCopy());
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#CaseRangeStatement
 */
 final class CaseRangeStatement : Инструкция2
{
    Выражение first;
    Выражение last;
    Инструкция2 инструкция;

    this(ref Место место, Выражение first, Выражение last, Инструкция2 инструкция)
    {
        super(место, STMT.CaseRange);
        this.first = first;
        this.last = last;
        this.инструкция = инструкция;
    }

    override Инструкция2 syntaxCopy()
    {
        return new CaseRangeStatement(место, first.syntaxCopy(), last.syntaxCopy(), инструкция.syntaxCopy());
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#DefaultStatement
 */
 final class DefaultStatement : Инструкция2
{
    Инструкция2 инструкция;

    VarDeclaration lastVar;

    this(ref Место место, Инструкция2 инструкция)
    {
        super(место, STMT.Default);
        this.инструкция = инструкция;
    }

    override Инструкция2 syntaxCopy()
    {
        return new DefaultStatement(место, инструкция.syntaxCopy());
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#GotoStatement
 */
 final class GotoDefaultStatement : Инструкция2
{
    SwitchStatement sw;

    this(ref Место место)
    {
        super(место, STMT.GotoDefault);
    }

    override Инструкция2 syntaxCopy()
    {
        return new GotoDefaultStatement(место);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#GotoStatement
 */
 final class GotoCaseStatement : Инструкция2
{
    Выражение exp;     // null, or which case to goto

    CaseStatement cs;   // case инструкция it resolves to

    this(ref Место место, Выражение exp)
    {
        super(место, STMT.GotoCase);
        this.exp = exp;
    }

    override Инструкция2 syntaxCopy()
    {
        return new GotoCaseStatement(место, exp ? exp.syntaxCopy() : null);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class SwitchErrorStatement : Инструкция2
{
    Выражение exp;

    this(ref Место место)
    {
        super(место, STMT.SwitchError);
    }

    final this(ref Место место, Выражение exp)
    {
        super(место, STMT.SwitchError);
        this.exp = exp;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#return-инструкция
 */
 final class ReturnStatement : Инструкция2
{
    Выражение exp;
    т_мера caseDim;

    this(ref Место место, Выражение exp)
    {
        super(место, STMT.Return);
        this.exp = exp;
    }

    override Инструкция2 syntaxCopy()
    {
        return new ReturnStatement(место, exp ? exp.syntaxCopy() : null);
    }

    override ReturnStatement endsWithReturnStatement()   
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#break-инструкция
 */
 final class BreakStatement : Инструкция2
{
    Идентификатор2 идент;

    this(ref Место место, Идентификатор2 идент)
    {
        super(место, STMT.Break);
        this.идент = идент;
    }

    override Инструкция2 syntaxCopy()
    {
        return new BreakStatement(место, идент);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#continue-инструкция
 */
 final class ContinueStatement : Инструкция2
{
    Идентификатор2 идент;

    this(ref Место место, Идентификатор2 идент)
    {
        super(место, STMT.Continue);
        this.идент = идент;
    }

    override Инструкция2 syntaxCopy()
    {
        return new ContinueStatement(место, идент);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#SynchronizedStatement
 */
 final class SynchronizedStatement : Инструкция2
{
    Выражение exp;
    Инструкция2 _body;

    this(ref Место место, Выражение exp, Инструкция2 _body)
    {
        super(место, STMT.Synchronized);
        this.exp = exp;
        this._body = _body;
    }

    override Инструкция2 syntaxCopy()
    {
        return new SynchronizedStatement(место, exp ? exp.syntaxCopy() : null, _body ? _body.syntaxCopy() : null);
    }

    override бул hasBreak()   
    {
        return нет; //да;
    }

    override бул hasContinue()   
    {
        return нет; //да;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#with-инструкция
 */
 final class WithStatement : Инструкция2
{
    Выражение exp;
    Инструкция2 _body;
    VarDeclaration wthis;
    Место endloc;

    this(ref Место место, Выражение exp, Инструкция2 _body, Место endloc)
    {
        super(место, STMT.With);
        this.exp = exp;
        this._body = _body;
        this.endloc = endloc;
    }

    override Инструкция2 syntaxCopy()
    {
        return new WithStatement(место, exp.syntaxCopy(), _body ? _body.syntaxCopy() : null, endloc);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#try-инструкция
 */
 final class TryCatchStatement : Инструкция2
{
    Инструкция2 _body;
    Уловители* catches;

    Инструкция2 tryBody;   /// set to enclosing TryCatchStatement or TryFinallyStatement if in _body portion

    this(ref Место место, Инструкция2 _body, Уловители* catches)
    {
        super(место, STMT.TryCatch);
        this._body = _body;
        this.catches = catches;
    }

    override Инструкция2 syntaxCopy()
    {
        auto a = new Уловители(catches.dim);
        foreach (i, c; *catches)
        {
            (*a)[i] = c.syntaxCopy();
        }
        return new TryCatchStatement(место, _body.syntaxCopy(), a);
    }

    override бул hasBreak()   
    {
        return нет;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#Уловитель
 */
 final class Уловитель : КорневойОбъект
{
    const Место место;
    Тип тип;
    Идентификатор2 идент;
    Инструкция2 handler;

    VarDeclaration var;
    бул errors;                // set if semantic processing errors

    // was generated by the compiler, wasn't present in source code
    бул internalCatch;

    this(ref Место место, Тип тип, Идентификатор2 идент, Инструкция2 handler)
    {
        //printf("Уловитель(%s, место = %s)\n", ид.вТкст0(), место.вТкст0());
        this.место = место;
        this.тип = тип;
        this.идент = идент;
        this.handler = handler;
    }

    Уловитель syntaxCopy()
    {
        auto c = new Уловитель(место, тип ? тип.syntaxCopy() : getThrowable(), идент, (handler ? handler.syntaxCopy() : null));
        c.internalCatch = internalCatch;
        return c;
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#try-инструкция
 */
 final class TryFinallyStatement : Инструкция2
{
    Инструкция2 _body;
    Инструкция2 finalbody;

    Инструкция2 tryBody;   /// set to enclosing TryCatchStatement or TryFinallyStatement if in _body portion
    бул bodyFallsThru;  /// да if _body falls through to finally

    this(ref Место место, Инструкция2 _body, Инструкция2 finalbody)
    {
        super(место, STMT.TryFinally);
        this._body = _body;
        this.finalbody = finalbody;
        this.bodyFallsThru = да;      // assume да until statementSemantic()
    }

    static TryFinallyStatement создай(Место место, Инструкция2 _body, Инструкция2 finalbody)
    {
        return new TryFinallyStatement(место, _body, finalbody);
    }

    override Инструкция2 syntaxCopy()
    {
        return new TryFinallyStatement(место, _body.syntaxCopy(), finalbody.syntaxCopy());
    }

    override бул hasBreak()   
    {
        return нет; //да;
    }

    override бул hasContinue()   
    {
        return нет; //да;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#scope-guard-инструкция
 */
 final class ScopeGuardStatement : Инструкция2
{
    ТОК2 tok;
    Инструкция2 инструкция;

    this(ref Место место, ТОК2 tok, Инструкция2 инструкция)
    {
        super(место, STMT.ScopeGuard);
        this.tok = tok;
        this.инструкция = инструкция;
    }

    override Инструкция2 syntaxCopy()
    {
        return new ScopeGuardStatement(место, tok, инструкция.syntaxCopy());
    }

    override Инструкция2 scopeCode(Scope* sc, Инструкция2* sentry, Инструкция2* sexception, Инструкция2* sfinally)
    {
        //printf("ScopeGuardStatement::scopeCode()\n");
        *sentry = null;
        *sexception = null;
        *sfinally = null;

        Инструкция2 s = new PeelStatement(инструкция);

        switch (tok)
        {
        case ТОК2.onScopeExit:
            *sfinally = s;
            break;

        case ТОК2.onScopeFailure:
            *sexception = s;
            break;

        case ТОК2.onScopeSuccess:
            {
                /* Create:
                 *  sentry:   бул x = нет;
                 *  sexception:    x = да;
                 *  sfinally: if (!x) инструкция;
                 */
                auto v = copyToTemp(0, "__os", IntegerExp.createBool(нет));
                v.dsymbolSemantic(sc);
                *sentry = new ExpStatement(место, v);

                Выражение e = IntegerExp.createBool(да);
                e = new AssignExp(Место.initial, new VarExp(Место.initial, v), e);
                *sexception = new ExpStatement(Место.initial, e);

                e = new VarExp(Место.initial, v);
                e = new NotExp(Место.initial, e);
                *sfinally = new IfStatement(Место.initial, null, e, s, null, Место.initial);

                break;
            }
        default:
            assert(0);
        }
        return null;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#throw-инструкция
 */
 final class ThrowStatement : Инструкция2
{
    Выражение exp;

    // was generated by the compiler, wasn't present in source code
    бул internalThrow;

    this(ref Место место, Выражение exp)
    {
        super(место, STMT.Throw);
        this.exp = exp;
    }

    override Инструкция2 syntaxCopy()
    {
        auto s = new ThrowStatement(место, exp.syntaxCopy());
        s.internalThrow = internalThrow;
        return s;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class DebugStatement : Инструкция2
{
    Инструкция2 инструкция;

    this(ref Место место, Инструкция2 инструкция)
    {
        super(место, STMT.Debug);
        this.инструкция = инструкция;
    }

    override Инструкция2 syntaxCopy()
    {
        return new DebugStatement(место, инструкция ? инструкция.syntaxCopy() : null);
    }

    override Инструкции* flatten(Scope* sc)
    {
        Инструкции* a = инструкция ? инструкция.flatten(sc) : null;
        if (a)
        {
            foreach (ref s; *a)
            {
                s = new DebugStatement(место, s);
            }
        }
        return a;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#goto-инструкция
 */
 final class GotoStatement : Инструкция2
{
    Идентификатор2 идент;
    LabelDsymbol label;
    Инструкция2 tryBody;              /// set to TryCatchStatement or TryFinallyStatement if in _body portion
    TryFinallyStatement tf;
    ScopeGuardStatement ос;
    VarDeclaration lastVar;

    this(ref Место место, Идентификатор2 идент)
    {
        super(место, STMT.Goto);
        this.идент = идент;
    }

    override Инструкция2 syntaxCopy()
    {
        return new GotoStatement(место, идент);
    }

    extern (D) бул checkLabel()
    {
        if (!label.инструкция)
            return да;        // error should have been issued for this already

        if (label.инструкция.ос != ос)
        {
            if (ос && ос.tok == ТОК2.onScopeFailure && !label.инструкция.ос)
            {
                // Jump out from scope(failure) block is allowed.
            }
            else
            {
                if (label.инструкция.ос)
                    выведиОшибку("cannot `goto` in to `%s` block", Сема2.вТкст0(label.инструкция.ос.tok));
                else
                    выведиОшибку("cannot `goto` out of `%s` block", Сема2.вТкст0(ос.tok));
                return да;
            }
        }

        if (label.инструкция.tf != tf)
        {
            выведиОшибку("cannot `goto` in or out of `finally` block");
            return да;
        }

        Инструкция2 stbnext;
        for (auto stb = tryBody; stb != label.инструкция.tryBody; stb = stbnext)
        {
            if (!stb)
            {
                выведиОшибку("cannot `goto` into `try` block");
                return да;
            }
            if (auto stf = stb.isTryFinallyStatement())
                stbnext = stf.tryBody;
            else if (auto stc = stb.isTryCatchStatement())
                stbnext = stc.tryBody;
            else
                assert(0);
        }

        VarDeclaration vd = label.инструкция.lastVar;
        if (!vd || vd.isDataseg() || (vd.класс_хранения & STC.manifest))
            return нет;

        VarDeclaration last = lastVar;
        while (last && last != vd)
            last = last.lastVar;
        if (last == vd)
        {
            // All good, the label's scope has no variables
        }
        else if (vd.класс_хранения & STC.exptemp)
        {
            // Lifetime ends at end of Выражение, so no issue with skipping the инструкция
        }
        else if (vd.идент == Id.withSym)
        {
            выведиОшибку("`goto` skips declaration of `with` temporary at %s", vd.место.вТкст0());
            return да;
        }
        else
        {
            выведиОшибку("`goto` skips declaration of variable `%s` at %s", vd.toPrettyChars(), vd.место.вТкст0());
            return да;
        }

        return нет;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#LabeledStatement
 */
 final class LabelStatement : Инструкция2
{
    Идентификатор2 идент;
    Инструкция2 инструкция;

    Инструкция2 tryBody;              /// set to TryCatchStatement or TryFinallyStatement if in _body portion
    TryFinallyStatement tf;
    ScopeGuardStatement ос;
    VarDeclaration lastVar;
    Инструкция2 gotoTarget;       // interpret
    ук extra;                // используется by Statement_toIR()
    бул breaks;                // someone did a 'break идент'

    this(ref Место место, Идентификатор2 идент, Инструкция2 инструкция)
    {
        super(место, STMT.Label);
        this.идент = идент;
        this.инструкция = инструкция;
    }

    override Инструкция2 syntaxCopy()
    {
        return new LabelStatement(место, идент, инструкция ? инструкция.syntaxCopy() : null);
    }

    override Инструкции* flatten(Scope* sc)
    {
        Инструкции* a = null;
        if (инструкция)
        {
            a = инструкция.flatten(sc);
            if (a)
            {
                if (!a.dim)
                {
                    a.сунь(new ExpStatement(место, cast(Выражение)null));
                }

                // reuse 'this' LabelStatement
                this.инструкция = (*a)[0];
                (*a)[0] = this;
            }
        }
        return a;
    }

    override Инструкция2 scopeCode(Scope* sc, Инструкция2* sentry, Инструкция2* sexit, Инструкция2* sfinally)
    {
        //printf("LabelStatement::scopeCode()\n");
        if (инструкция)
            инструкция = инструкция.scopeCode(sc, sentry, sexit, sfinally);
        else
        {
            *sentry = null;
            *sexit = null;
            *sfinally = null;
        }
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 */
 final class LabelDsymbol : ДСимвол
{
    LabelStatement инструкция;

    бул deleted;           // set if rewritten to return in foreach delegate
    бул iasm;              // set if используется by inline assembler

    this(Идентификатор2 идент)
    {
        super(идент);
    }

    static LabelDsymbol создай(Идентификатор2 идент)
    {
        return new LabelDsymbol(идент);
    }

    // is this a LabelDsymbol()?
    override LabelDsymbol isLabel()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/инструкция.html#asm
 */
 class AsmStatement : Инструкция2
{
    Сема2* tokens;

    this(ref Место место, Сема2* tokens)
    {
        super(место, STMT.Asm);
        this.tokens = tokens;
    }

    this(ref Место место, Сема2* tokens, STMT stmt)
    {
        super(место, stmt);
        this.tokens = tokens;
    }

    override Инструкция2 syntaxCopy()
    {
        return new AsmStatement(место, tokens);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/iasm.html
 */
 final class InlineAsmStatement : AsmStatement
{
    code* asmcode;
    бцел asmalign;  // alignment of this инструкция
    бцел regs;      // mask of registers modified (must match regm_t in back end)
    бул refparam;  // да if function параметр is referenced
    бул naked;     // да if function is to be naked

    this(ref Место место, Сема2* tokens)
    {
        super(место, tokens, STMT.InlineAsm);
    }

    override Инструкция2 syntaxCopy()
    {
        return new InlineAsmStatement(место, tokens);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html
 * Assembler instructions with D Выражение operands.
 */
 final class GccAsmStatement : AsmStatement
{
    КлассХранения stc;           // attributes of the asm {} block
    Выражение insn;            // ткст Выражение that is the template for assembler code
    Выражения* args;          // input and output operands of the инструкция
    бцел outputargs;            // of the operands in 'args', the number of output operands
    Идентификаторы* имена;         // list of symbolic имена for the operands
    Выражения* constraints;   // list of ткст constants specifying constraints on operands
    Выражения* clobbers;      // list of ткст constants specifying clobbers and scratch registers
    Идентификаторы* labels;        // list of goto labels
    GotoStatements* gotos;      // of the goto labels, the equivalent statements they represent

    this(ref Место место, Сема2* tokens)
    {
        super(место, tokens, STMT.GccAsm);
    }

    override Инструкция2 syntaxCopy()
    {
        return new GccAsmStatement(место, tokens);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * a complete asm {} block
 */
 final class CompoundAsmStatement : CompoundStatement
{
    КлассХранения stc; // postfix attributes like //@trusted

    this(ref Место место, Инструкции* statements, КлассХранения stc)
    {
        super(место, statements, STMT.CompoundAsm);
        this.stc = stc;
    }

    override CompoundAsmStatement syntaxCopy()
    {
        auto a = new Инструкции(statements.dim);
        foreach (i, s; *statements)
        {
            (*a)[i] = s ? s.syntaxCopy() : null;
        }
        return new CompoundAsmStatement(место, a, stc);
    }

    override Инструкции* flatten(Scope* sc)
    {
        return null;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/module.html#ImportDeclaration
 */
 final class ImportStatement : Инструкция2
{
    Дсимволы* imports;      // МассивДРК of Импорт's

    this(ref Место место, Дсимволы* imports)
    {
        super(место, STMT.Импорт);
        this.imports = imports;
    }

    override Инструкция2 syntaxCopy()
    {
        auto m = new Дсимволы(imports.dim);
        foreach (i, s; *imports)
        {
            (*m)[i] = s.syntaxCopy(null);
        }
        return new ImportStatement(место, m);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}
