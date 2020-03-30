/**
 * Defines `TemplateDeclaration`, `TemplateInstance` and a few utilities
 *
 * This modules holds the two main template types:
 * `TemplateDeclaration`, which is the user-provided declaration of a template,
 * and `TemplateInstance`, which is an instance of a `TemplateDeclaration`
 * with specific arguments.
 *
 * Template_Parameter:
 * Additionally, the classes for template parameters are defined in this module.
 * The base class, `ПараметрШаблона2`, is inherited by:
 * - `TemplateTypeParameter`
 * - `TemplateThisParameter`
 * - `TemplateValueParameter`
 * - `TemplateAliasParameter`
 * - `TemplateTupleParameter`
 *
 * Templates_semantic:
 * The start of the template instantiation process looks like this:
 * - A `TypeInstance` or `TypeIdentifier` is encountered.
 *   `TypeInstance` have a bang (e.g. `Foo!(arg)`) while `TypeIdentifier` don't.
 * - A `TemplateInstance` is instantiated
 * - Semantic is run on the `TemplateInstance` (see `dmd.dsymbolsem`)
 * - The `TemplateInstance` search for its `TemplateDeclaration`,
 *   runs semantic on the template arguments and deduce the best match
 *   among the possible overloads.
 * - The `TemplateInstance` search for existing instances with the same
 *   arguments, and uses it if found.
 * - Otherwise, the rest of semantic is run on the `TemplateInstance`.
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/dtemplate.d, _dtemplate.d)
 * Documentation:  https://dlang.org/phobos/dmd_dtemplate.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/dtemplate.d
 */

module dmd.dtemplate;

import cidrus;
import dmd.aggregate;
import dmd.aliasthis;
import dmd.arraytypes;
import  drc.ast.Node;
import dmd.dcast;
import dmd.dclass;
import dmd.declaration;
import dmd.dmangle;
import dmd.dmodule;
import dmd.dscope;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.errors;
import drc.ast.Expression;
import dmd.expressionsem;
import dmd.func;
import dmd.globals;
import dmd.hdrgen;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.impcnvtab;
import dmd.init;
import dmd.initsem;
import dmd.mtype;
import dmd.opover;
import util.array;
import util.outbuffer;
import drc.ast.Node;
import dmd.semantic2;
import dmd.semantic3;
import drc.lexer.Tokens;
import dmd.typesem;
import drc.ast.Visitor;
import util.хэш : mixHash;
import dmd.templateparamsem;
import util.ctfloat : CTFloat;
import util.хэш : calcHash, mixHash;
import dmd.staticcond;
//debug = FindExistingInstance; // print debug stats of findExistingInstance
private const LOG = нет;

const IDX_NOTFOUND = 0x12345678;

  
public{

/********************************************
 * These functions substitute for dynamic_cast. dynamic_cast does not work
 * on earlier versions of gcc.
 */
 Выражение выражение_ли(inout КорневойОбъект o)
{
    //return dynamic_cast<Выражение *>(o);
    if (!o || o.динкаст() != ДИНКАСТ.Выражение)
        return null;
    return cast(Выражение)o;
}

 ДСимвол isDsymbol(inout КорневойОбъект o)
{
    //return dynamic_cast<ДСимвол *>(o);
    if (!o || o.динкаст() != ДИНКАСТ.дсимвол)
        return null;
    return cast(ДСимвол)o;
}

 Тип тип_ли(inout КорневойОбъект o)
{
    //return dynamic_cast<Тип *>(o);
    if (!o || o.динкаст() != ДИНКАСТ.тип)
        return null;
    return cast(Тип)o;
}

 Tuple кортеж_ли(inout КорневойОбъект o)
{
    //return dynamic_cast<Tuple *>(o);
    if (!o || o.динкаст() != ДИНКАСТ.кортеж)
        return null;
    return cast(Tuple)o;
}

 Параметр2 isParameter(inout КорневойОбъект o)
{
    //return dynamic_cast<Параметр2 *>(o);
    if (!o || o.динкаст() != ДИНКАСТ.параметр)
        return null;
    return cast(Параметр2)o;
}

 ПараметрШаблона2 isTemplateParameter(inout КорневойОбъект o)
{
    if (!o || o.динкаст() != ДИНКАСТ.шаблонпараметр)
        return null;
    return cast(ПараметрШаблона2)o;
}

/**************************************
 * Is this Object an error?
 */
 бул isError(КорневойОбъект o)
{
    if(auto t = тип_ли(o))
        return (t.ty == Terror);
    if(auto e = выражение_ли(o))
        return (e.op == ТОК2.error || !e.тип || e.тип.ty == Terror);
    if(auto v = кортеж_ли(o))
        return arrayObjectIsError(&v.objects);
    const s = isDsymbol(o);
    assert(s);
    if (s.errors)
        return да;
    return s.родитель ? isError(s.родитель) : нет;
}

/**************************************
 * Are any of the Объекты an error?
 */
бул arrayObjectIsError(Объекты* args)
{
    foreach (o; *args)
    {
        if (isError(o))
            return да;
    }
    return нет;
}

/***********************
 * Try to get arg as a тип.
 */
Тип getType(inout КорневойОбъект o)
{
    auto t = тип_ли(o);
    if (!t)
    {
        if (auto e = выражение_ли(o))
            return e.тип;
    }
    return t;
}

}

ДСимвол getDsymbol(КорневойОбъект oarg)
{
    //printf("getDsymbol()\n");
    //printf("e %p s %p t %p v %p\n", выражение_ли(oarg), isDsymbol(oarg), тип_ли(oarg), кортеж_ли(oarg));
    if (auto ea = выражение_ли(oarg))
    {
        // Try to convert Выражение to symbol
        if (auto ve = ea.isVarExp())
            return ve.var;
        else if (auto fe = ea.isFuncExp())
            return fe.td ? fe.td : fe.fd;
        else if (auto te = ea.isTemplateExp())
            return te.td;
        else if (auto te = ea.isScopeExp())
            return te.sds;
        else
            return null;
    }
    else
    {
        // Try to convert Тип to symbol
        if (auto ta = тип_ли(oarg))
            return ta.toDsymbol(null);
        else
            return isDsymbol(oarg); // if already a symbol
    }
}


private Выражение дайЗначение(ref ДСимвол s)
{
    if (s)
    {
        if (VarDeclaration v = s.isVarDeclaration())
        {
            if (v.класс_хранения & STC.manifest)
                return v.getConstInitializer();
        }
    }
    return null;
}

/***********************
 * Try to get значение from manifest constant
 */
private Выражение дайЗначение(Выражение e)
{
    if (e && e.op == ТОК2.variable)
    {
        VarDeclaration v = (cast(VarExp)e).var.isVarDeclaration();
        if (v && v.класс_хранения & STC.manifest)
        {
            e = v.getConstInitializer();
        }
    }
    return e;
}

private Выражение getВыражение(КорневойОбъект o)
{
    auto s = isDsymbol(o);
    return s ? .дайЗначение(s) : .дайЗначение(выражение_ли(o));
}

/******************************
 * If o1 matches o2, return да.
 * Else, return нет.
 */
private бул match(КорневойОбъект o1, КорневойОбъект o2)
{
    const log = нет;

    static if (log)
    {
        printf("match() o1 = %p %s (%d), o2 = %p %s (%d)\n",
            o1, o1.вТкст0(), o1.динкаст(), o2, o2.вТкст0(), o2.динкаст());
    }

    /* A proper implementation of the various равен() overrides
     * should make it possible to just do o1.равен(o2), but
     * we'll do that another day.
     */
    /* Manifest constants should be compared by their values,
     * at least in template arguments.
     */

    if (auto t1 = тип_ли(o1))
    {
        auto t2 = тип_ли(o2);
        if (!t2)
            goto Lnomatch;

        static if (log)
        {
            printf("\tt1 = %s\n", t1.вТкст0());
            printf("\tt2 = %s\n", t2.вТкст0());
        }
        if (!t1.равен(t2))
            goto Lnomatch;

        goto Lmatch;
    }
    if (auto e1 = getВыражение(o1))
    {
        auto e2 = getВыражение(o2);
        if (!e2)
            goto Lnomatch;

        static if (log)
        {
            printf("\te1 = %s '%s' %s\n", e1.тип ? e1.тип.вТкст0() : "null", Сема2.вТкст0(e1.op), e1.вТкст0());
            printf("\te2 = %s '%s' %s\n", e2.тип ? e2.тип.вТкст0() : "null", Сема2.вТкст0(e2.op), e2.вТкст0());
        }

        // two Выражения can be equal although they do not have the same
        // тип; that happens when they have the same значение. So check тип
        // as well as Выражение equality to ensure templates are properly
        // matched.
        if (!(e1.тип && e2.тип && e1.тип.равен(e2.тип)) || !e1.равен(e2))
            goto Lnomatch;

        goto Lmatch;
    }
    if (auto s1 = isDsymbol(o1))
    {
        auto s2 = isDsymbol(o2);
        if (!s2)
            goto Lnomatch;

        static if (log)
        {
            printf("\ts1 = %s \n", s1.вид(), s1.вТкст0());
            printf("\ts2 = %s \n", s2.вид(), s2.вТкст0());
        }
        if (!s1.равен(s2))
            goto Lnomatch;
        if (s1.родитель != s2.родитель && !s1.isFuncDeclaration() && !s2.isFuncDeclaration())
            goto Lnomatch;

        goto Lmatch;
    }
    if (auto u1 = кортеж_ли(o1))
    {
        auto u2 = кортеж_ли(o2);
        if (!u2)
            goto Lnomatch;

        static if (log)
        {
            printf("\tu1 = %s\n", u1.вТкст0());
            printf("\tu2 = %s\n", u2.вТкст0());
        }
        if (!arrayObjectMatch(&u1.objects, &u2.objects))
            goto Lnomatch;

        goto Lmatch;
    }
Lmatch:
    static if (log)
        printf("\t. match\n");
    return да;

Lnomatch:
    static if (log)
        printf("\t. nomatch\n");
    return нет;
}

/************************************
 * Match an массив of them.
 */
private бул arrayObjectMatch(Объекты* oa1, Объекты* oa2)
{
    if (oa1 == oa2)
        return да;
    if (oa1.dim != oa2.dim)
        return нет;
    const oa1dim = oa1.dim;
    auto oa1d = (*oa1)[].ptr;
    auto oa2d = (*oa2)[].ptr;
    foreach (j; new бцел[0 .. oa1dim])
    {
        КорневойОбъект o1 = oa1d[j];
        КорневойОбъект o2 = oa2d[j];
        if (!match(o1, o2))
        {
            return нет;
        }
    }
    return да;
}

/************************************
 * Return хэш of Объекты.
 */
private т_мера arrayObjectHash(Объекты* oa1)
{
    

    т_мера хэш = 0;
    foreach (o1; *oa1)
    {
        /* Must follow the logic of match()
         */
        if (auto t1 = тип_ли(o1))
            хэш = mixHash(хэш, cast(т_мера)t1.deco);
        else if (auto e1 = getВыражение(o1))
            хэш = mixHash(хэш, ВыражениеHash(e1));
        else if (auto s1 = isDsymbol(o1))
        {
            auto fa1 = s1.isFuncAliasDeclaration();
            if (fa1)
                s1 = fa1.toAliasFunc();
            хэш = mixHash(хэш, mixHash(cast(т_мера)cast(ук)s1.getIdent(), cast(т_мера)cast(ук)s1.родитель));
        }
        else if (auto u1 = кортеж_ли(o1))
            хэш = mixHash(хэш, arrayObjectHash(&u1.objects));
    }
    return хэш;
}


/************************************
 * Computes хэш of Выражение.
 * Handles all Выражение classes and MUST match their равен method,
 * i.e. e1.равен(e2) implies ВыражениеHash(e1) == ВыражениеHash(e2).
 */
private т_мера ВыражениеHash(Выражение e)
{


    switch (e.op)
    {
    case ТОК2.int64:
        return cast(т_мера) (cast(IntegerExp)e).getInteger();

    case ТОК2.float64:
        return CTFloat.хэш((cast(RealExp)e).значение);

    case ТОК2.complex80:
        auto ce = cast(ComplexExp)e;
        return mixHash(CTFloat.хэш(ce.toReal), CTFloat.хэш(ce.toImaginary));

    case ТОК2.идентификатор:
        return cast(т_мера)cast(ук) (cast(IdentifierExp)e).идент;

    case ТОК2.null_:
        return cast(т_мера)cast(ук) (cast(NullExp)e).тип;

    case ТОК2.string_:
        return calcHash(e.isStringExp.peekData());

    case ТОК2.кортеж:
    {
        auto te = cast(TupleExp)e;
        т_мера хэш = 0;
        хэш += te.e0 ? ВыражениеHash(te.e0) : 0;
        foreach (elem; *te.exps)
            хэш = mixHash(хэш, ВыражениеHash(elem));
        return хэш;
    }

    case ТОК2.arrayLiteral:
    {
        auto ae = cast(ArrayLiteralExp)e;
        т_мера хэш;
        foreach (i; new бцел[0 .. ae.elements.dim])
            хэш = mixHash(хэш, ВыражениеHash(ae[i]));
        return хэш;
    }

    case ТОК2.assocArrayLiteral:
    {
        auto ae = cast(AssocArrayLiteralExp)e;
        т_мера хэш;
        foreach (i; new бцел[0 .. ae.keys.dim])
            // reduction needs associative op as keys are unsorted (use XOR)
            хэш ^= mixHash(ВыражениеHash((*ae.keys)[i]), ВыражениеHash((*ae.values)[i]));
        return хэш;
    }

    case ТОК2.structLiteral:
    {
        auto se = cast(StructLiteralExp)e;
        т_мера хэш;
        foreach (elem; *se.elements)
            хэш = mixHash(хэш, elem ? ВыражениеHash(elem) : 0);
        return хэш;
    }

    case ТОК2.variable:
        return cast(т_мера)cast(ук) (cast(VarExp)e).var;

    case ТОК2.function_:
        return cast(т_мера)cast(ук) (cast(FuncExp)e).fd;

    default:
        // no custom равен for this Выражение
        assert((&e.равен).funcptr is &КорневойОбъект.равен);
        // равен based on identity
        return cast(т_мера)cast(ук) e;
    }
}

КорневойОбъект objectSyntaxCopy(КорневойОбъект o)
{
    if (!o)
        return null;
    if (Тип t = тип_ли(o))
        return t.syntaxCopy();
    if (Выражение e = выражение_ли(o))
        return e.syntaxCopy();
    return o;
}

 final class Tuple : КорневойОбъект
{
    Объекты objects;

    this() {}

    /**
    Параметры:
        numObjects = The initial number of objects.
    */
    this(т_мера numObjects)
    {
        objects.устДим(numObjects);
    }

    // kludge for template.тип_ли()
    override ДИНКАСТ динкаст()
    {
        return ДИНКАСТ.кортеж;
    }

    override ткст0 вТкст0()
    {
        return objects.вТкст0();
    }
}

struct TemplatePrevious
{
    TemplatePrevious* prev;
    Scope* sc;
    Объекты* dedargs;
}

/***********************************************************
 * [mixin] template Идентификатор2 (parameters) [Constraint]
 * https://dlang.org/spec/template.html
 * https://dlang.org/spec/template-mixin.html
 */
 final class TemplateDeclaration : ScopeDsymbol
{
    import util.array : МассивДРК;

    ПараметрыШаблона* parameters;     // массив of ПараметрШаблона2's
    ПараметрыШаблона* origParameters; // originals for Ddoc

    Выражение constraint;

    // Hash table to look up TemplateInstance's of this TemplateDeclaration
    TemplateInstance[TemplateInstanceBox] instances;

    TemplateDeclaration overnext;       // следщ overloaded TemplateDeclaration
    TemplateDeclaration overroot;       // first in overnext list
    FuncDeclaration funcroot;           // first function in unified overload list

    ДСимвол onemember;      // if !=null then one member of this template

    бул literal;           // this template declaration is a literal
    бул ismixin;           // this is a mixin template declaration
    бул статичен_ли;          // this is static template declaration
    Prot защита;
    цел inuse;              /// for recursive expansion detection

    // threaded list of previous instantiation attempts on stack
    TemplatePrevious* previous;

    private Выражение lastConstraint; /// the constraint after the last failed evaluation
    private МассивДРК!(Выражение) lastConstraintNegs; /// its negative parts
    private Объекты* lastConstraintTiargs; /// template instance arguments for `lastConstraint`

    this(ref Место место, Идентификатор2 идент, ПараметрыШаблона* parameters, Выражение constraint, Дсимволы* decldefs, бул ismixin = нет, бул literal = нет)
    {
        super(место, идент);
        static if (LOG)
        {
            printf("TemplateDeclaration(this = %p, ид = '%s')\n", this, ид.вТкст0());
        }
        version (none)
        {
            if (parameters)
                for (цел i = 0; i < parameters.dim; i++)
                {
                    ПараметрШаблона2 tp = (*parameters)[i];
                    //printf("\tparameter[%d] = %p\n", i, tp);
                    TemplateTypeParameter ttp = tp.isTemplateTypeParameter();
                    if (ttp)
                    {
                        printf("\tparameter[%d] = %s : %s\n", i, tp.идент.вТкст0(), ttp.specType ? ttp.specType.вТкст0() : "");
                    }
                }
        }
        this.parameters = parameters;
        this.origParameters = parameters;
        this.constraint = constraint;
        this.члены = decldefs;
        this.literal = literal;
        this.ismixin = ismixin;
        this.статичен_ли = да;
        this.защита = Prot(Prot.Kind.undefined);

        // Compute in advance for Ddoc's use
        // https://issues.dlang.org/show_bug.cgi?ид=11153: идент could be NULL if parsing fails.
        if (члены && идент)
        {
            ДСимвол s;
            if (ДСимвол.oneMembers(члены, &s, идент) && s)
            {
                onemember = s;
                s.родитель = this;
            }
        }
    }

    override ДСимвол syntaxCopy(ДСимвол)
    {
        //printf("TemplateDeclaration.syntaxCopy()\n");
        ПараметрыШаблона* p = null;
        if (parameters)
        {
            p = new ПараметрыШаблона(parameters.dim);
            for (т_мера i = 0; i < p.dim; i++)
                (*p)[i] = (*parameters)[i].syntaxCopy();
        }
        return new TemplateDeclaration(место, идент, p, constraint ? constraint.syntaxCopy() : null, ДСимвол.arraySyntaxCopy(члены), ismixin, literal);
    }

    /**********************************
     * Overload existing TemplateDeclaration 'this' with the new one 's'.
     * Return да if successful; i.e. no conflict.
     */
    override бул overloadInsert(ДСимвол s)
    {
        static if (LOG)
        {
            printf("TemplateDeclaration.overloadInsert('%s')\n", s.вТкст0());
        }
        FuncDeclaration fd = s.isFuncDeclaration();
        if (fd)
        {
            if (funcroot)
                return funcroot.overloadInsert(fd);
            funcroot = fd;
            return funcroot.overloadInsert(this);
        }

        // https://issues.dlang.org/show_bug.cgi?ид=15795
        // if candidate is an alias and its sema is not run then
        // insertion can fail because the thing it alias is not known
        if (AliasDeclaration ad = s.isAliasDeclaration())
        {
            if (s._scope)
                aliasSemantic(ad, s._scope);
            if (ad.aliassym && ad.aliassym is this)
                return нет;
        }
        TemplateDeclaration td = s.toAlias().isTemplateDeclaration();
        if (!td)
            return нет;

        TemplateDeclaration pthis = this;
        TemplateDeclaration* ptd;
        for (ptd = &pthis; *ptd; ptd = &(*ptd).overnext)
        {
        }

        td.overroot = this;
        *ptd = td;
        static if (LOG)
        {
            printf("\ttrue: no conflict\n");
        }
        return да;
    }

    override бул hasStaticCtorOrDtor()
    {
        return нет; // don't scan uninstantiated templates
    }

    override ткст0 вид()
    {
        return (onemember && onemember.isAggregateDeclaration()) ? onemember.вид() : "template";
    }

    override ткст0 вТкст0()
    {
        if (literal)
            return ДСимвол.вТкст0();

        БуфВыв буф;
        HdrGenState hgs;

        буф.пишиСтр(идент.вТкст());
        буф.пишиБайт('(');
        for (т_мера i = 0; i < parameters.dim; i++)
        {
            const ПараметрШаблона2 tp = (*parameters)[i];
            if (i)
                буф.пишиСтр(", ");
            .toCBuffer(tp, &буф, &hgs);
        }
        буф.пишиБайт(')');

        if (onemember)
        {
            const FuncDeclaration fd = onemember.isFuncDeclaration();
            if (fd && fd.тип)
            {
                TypeFunction tf = cast(TypeFunction)fd.тип;
                буф.пишиСтр(parametersTypeToChars(tf.parameterList));
            }
        }

        if (constraint)
        {
            буф.пишиСтр(" if (");
            .toCBuffer(constraint, &буф, &hgs);
            буф.пишиБайт(')');
        }
        return буф.extractChars();
    }

    /****************************
     * Similar to `вТкст0`, but does not print the template constraints
     */
    ткст0 toCharsNoConstraints()
    {
        if (literal)
            return ДСимвол.вТкст0();

        БуфВыв буф;
        HdrGenState hgs;

        буф.пишиСтр(идент.вТкст0());
        буф.пишиБайт('(');
        foreach (i, tp; *parameters)
        {
            if (i > 0)
                буф.пишиСтр(", ");
            .toCBuffer(tp, &буф, &hgs);
        }
        буф.пишиБайт(')');

        if (onemember)
        {
            FuncDeclaration fd = onemember.isFuncDeclaration();
            if (fd && fd.тип)
            {
                TypeFunction tf = fd.тип.isTypeFunction();
                буф.пишиСтр(parametersTypeToChars(tf.parameterList));
            }
        }
        return буф.extractChars();
    }

    override Prot prot()    
    {
        return защита;
    }

    /****************************
     * Check to see if constraint is satisfied.
     */
    extern (D) бул evaluateConstraint(TemplateInstance ti, Scope* sc, Scope* paramscope, Объекты* dedargs, FuncDeclaration fd)
    {
        /* Detect recursive attempts to instantiate this template declaration,
         * https://issues.dlang.org/show_bug.cgi?ид=4072
         *  проц foo(T)(T x) if (is(typeof(foo(x)))) { }
         *  static assert(!is(typeof(foo(7))));
         * Recursive attempts are regarded as a constraint failure.
         */
        /* There's a chicken-and-egg problem here. We don't know yet if this template
         * instantiation will be a local one (enclosing is set), and we won't know until
         * after selecting the correct template. Thus, function we're nesting inside
         * is not on the sc scope chain, and this can cause errors in FuncDeclaration.getLevel().
         * Workaround the problem by setting a флаг to relax the checking on frame errors.
         */

        for (TemplatePrevious* p = previous; p; p = p.prev)
        {
            if (arrayObjectMatch(p.dedargs, dedargs))
            {
                //printf("recursive, no match p.sc=%p %p %s\n", p.sc, this, this.вТкст0());
                /* It must be a subscope of p.sc, other scope chains are not recursive
                 * instantiations.
                 * the chain of enclosing scopes is broken by paramscope (its enclosing
                 * scope is _scope, but paramscope.callsc is the instantiating scope). So
                 * it's good enough to check the chain of callsc
                 */
                for (Scope* scx = paramscope.callsc; scx; scx = scx.callsc)
                {
                    if (scx == p.sc)
                        return нет;
                }
            }
            /* BUG: should also check for ref param differences
             */
        }

        TemplatePrevious pr;
        pr.prev = previous;
        pr.sc = paramscope.callsc;
        pr.dedargs = dedargs;
        previous = &pr; // add this to threaded list

        Scope* scx = paramscope.сунь(ti);
        scx.родитель = ti;
        scx.tinst = null;
        scx.minst = null;

        assert(!ti.symtab);
        if (fd)
        {
            /* Declare all the function parameters as variables and add them to the scope
             * Making parameters is similar to FuncDeclaration.semantic3
             */
            TypeFunction tf = cast(TypeFunction)fd.тип;
            assert(tf.ty == Tfunction);

            scx.родитель = fd;

            Параметры* fparameters = tf.parameterList.parameters;
            т_мера nfparams = tf.parameterList.length;
            for (т_мера i = 0; i < nfparams; i++)
            {
                Параметр2 fparam = tf.parameterList[i];
                fparam.классХранения &= (STC.in_ | STC.out_ | STC.ref_ | STC.lazy_ | STC.final_ | STC.TYPECTOR | STC.nodtor);
                fparam.классХранения |= STC.параметр;
                if (tf.parameterList.varargs == ВарАрг.typesafe && i + 1 == nfparams)
                {
                    fparam.классХранения |= STC.variadic;
                    /* Don't need to set STC.scope_ because this will only
                     * be evaluated at compile time
                     */
                }
            }
            for (т_мера i = 0; i < fparameters.dim; i++)
            {
                Параметр2 fparam = (*fparameters)[i];
                if (!fparam.идент)
                    continue;
                // don't add it, if it has no имя
                auto v = new VarDeclaration(место, fparam.тип, fparam.идент, null);
                v.класс_хранения = fparam.классХранения;
                v.dsymbolSemantic(scx);
                if (!ti.symtab)
                    ti.symtab = new DsymbolTable();
                if (!scx.вставь(v))
                    выведиОшибку("параметр `%s.%s` is already defined", вТкст0(), v.вТкст0());
                else
                    v.родитель = fd;
            }
            if (статичен_ли)
                fd.класс_хранения |= STC.static_;
            auto hiddenParams = fd.declareThis(scx, fd.isThis());
            fd.vthis = hiddenParams.vthis;
            fd.isThis2 = hiddenParams.isThis2;
            fd.selectorParameter = hiddenParams.selectorParameter;
        }

        lastConstraint = constraint.syntaxCopy();
        lastConstraintTiargs = ti.tiargs;
        lastConstraintNegs.устДим(0);

        assert(ti.inst is null);
        ti.inst = ti; // temporary instantiation to enable genIdent()
        scx.flags |= SCOPE.constraint;
        бул errors;
        const бул результат = evalStaticCondition(scx, constraint, lastConstraint, errors, &lastConstraintNegs);
        if (результат || errors)
        {
            lastConstraint = null;
            lastConstraintTiargs = null;
            lastConstraintNegs.устДим(0);
        }
        ti.inst = null;
        ti.symtab = null;
        scx = scx.вынь();
        previous = pr.prev; // unlink from threaded list
        if (errors)
            return нет;
        return результат;
    }

    /****************************
     * Destructively get the error message from the last constraint evaluation
     * Параметры:
     *      tip = tip to show after printing all overloads
     */
    ткст0 getConstraintEvalError(ref ткст0 tip)
    {
        // there will be a full tree view in verbose mode, and more compact list in the usual
        const full = глоб2.парамы.verbose;
        бцел count;
        const msg = visualizeStaticCondition(constraint, lastConstraint, lastConstraintNegs[], full, count);
        scope (exit)
        {
            lastConstraint = null;
            lastConstraintTiargs = null;
            lastConstraintNegs.устДим(0);
        }
        if (msg)
        {
            БуфВыв буф;

            assert(parameters && lastConstraintTiargs);
            if (parameters.length > 0)
            {
                formatParamsWithTiargs(*lastConstraintTiargs, буф);
                буф.нс();
            }
            if (!full)
            {
                // choosing singular/plural
                const s = (count == 1) ?
                    "  must satisfy the following constraint:" :
                    "  must satisfy one of the following constraints:";
                буф.пишиСтр(s);
                буф.нс();
                // the constraints
                буф.пишиБайт('`');
                буф.пишиСтр(msg);
                буф.пишиБайт('`');
            }
            else
            {
                буф.пишиСтр("  whose parameters have the following constraints:");
                буф.нс();
                const sep = "  `~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`";
                буф.пишиСтр(sep);
                буф.нс();
                // the constraints
                буф.пишиБайт('`');
                буф.пишиСтр(msg);
                буф.пишиБайт('`');
                буф.пишиСтр(sep);
                tip = "not satisfied constraints are marked with `>`";
            }
            return буф.extractChars();
        }
        else
            return null;
    }

    private проц formatParamsWithTiargs(ref Объекты tiargs, ref БуфВыв буф)
    {
        буф.пишиСтр("  with `");

        // пиши usual arguments line-by-line
        // skips trailing default ones - they are not present in `tiargs`
        const бул variadic = isVariadic() !is null;
        const end = cast(цел)parameters.length - (variadic ? 1 : 0);
        бцел i;
        for (; i < tiargs.length && i < end; i++)
        {
            if (i > 0)
            {
                буф.пишиБайт(',');
                буф.нс();
                буф.пишиСтр("       ");
            }
            буф.пиши((*parameters)[i]);
            буф.пишиСтр(" = ");
            буф.пиши(tiargs[i]);
        }
        // пиши remaining variadic arguments on the last line
        if (variadic)
        {
            if (i > 0)
            {
                буф.пишиБайт(',');
                буф.нс();
                буф.пишиСтр("       ");
            }
            буф.пиши((*parameters)[end]);
            буф.пишиСтр(" = ");
            буф.пишиБайт('(');
            if (cast(цел)tiargs.length - end > 0)
            {
                буф.пиши(tiargs[end]);
                foreach (j; new бцел[parameters.length .. tiargs.length])
                {
                    буф.пишиСтр(", ");
                    буф.пиши(tiargs[j]);
                }
            }
            буф.пишиБайт(')');
        }
        буф.пишиБайт('`');
    }

    /******************************
     * Create a scope for the parameters of the TemplateInstance
     * `ti` in the родитель scope sc from the ScopeDsymbol paramsym.
     *
     * If paramsym is null a new ScopeDsymbol is используется in place of
     * paramsym.
     * Параметры:
     *      ti = the TemplateInstance whose parameters to generate the scope for.
     *      sc = the родитель scope of ti
     * Возвращает:
     *      a scope for the parameters of ti
     */
    Scope* scopeForTemplateParameters(TemplateInstance ti, Scope* sc)
    {
        ScopeDsymbol paramsym = new ScopeDsymbol();
        paramsym.родитель = _scope.родитель;
        Scope* paramscope = _scope.сунь(paramsym);
        paramscope.tinst = ti;
        paramscope.minst = sc.minst;
        paramscope.callsc = sc;
        paramscope.stc = 0;
        return paramscope;
    }

    /***************************************
     * Given that ti is an instance of this TemplateDeclaration,
     * deduce the types of the parameters to this, and store
     * those deduced types in dedtypes[].
     * Input:
     *      флаг    1: don't do semantic() because of dummy types
     *              2: don't change types in matchArg()
     * Output:
     *      dedtypes        deduced arguments
     * Return match уровень.
     */
    extern (D) MATCH matchWithInstance(Scope* sc, TemplateInstance ti, Объекты* dedtypes, Выражения* fargs, цел флаг)
    {
        const LOGM = 0;
        static if (LOGM)
        {
            printf("\n+TemplateDeclaration.matchWithInstance(this = %s, ti = %s, флаг = %d)\n", вТкст0(), ti.вТкст0(), флаг);
        }
        version (none)
        {
            printf("dedtypes.dim = %d, parameters.dim = %d\n", dedtypes.dim, parameters.dim);
            if (ti.tiargs.dim)
                printf("ti.tiargs.dim = %d, [0] = %p\n", ti.tiargs.dim, (*ti.tiargs)[0]);
        }
        MATCH m;
        т_мера dedtypes_dim = dedtypes.dim;

        dedtypes.нуль();

        if (errors)
            return MATCH.nomatch;

        т_мера parameters_dim = parameters.dim;
        цел variadic = isVariadic() !is null;

        // If more arguments than parameters, no match
        if (ti.tiargs.dim > parameters_dim && !variadic)
        {
            static if (LOGM)
            {
                printf(" no match: more arguments than parameters\n");
            }
            return MATCH.nomatch;
        }

        assert(dedtypes_dim == parameters_dim);
        assert(dedtypes_dim >= ti.tiargs.dim || variadic);

        assert(_scope);

        // Set up scope for template parameters
        Scope* paramscope = scopeForTemplateParameters(ti,sc);

        // Attempt тип deduction
        m = MATCH.exact;
        for (т_мера i = 0; i < dedtypes_dim; i++)
        {
            MATCH m2;
            ПараметрШаблона2 tp = (*parameters)[i];
            Declaration sparam;

            //printf("\targument [%d]\n", i);
            static if (LOGM)
            {
                //printf("\targument [%d] is %s\n", i, oarg ? oarg.вТкст0() : "null");
                TemplateTypeParameter ttp = tp.isTemplateTypeParameter();
                if (ttp)
                    printf("\tparameter[%d] is %s : %s\n", i, tp.идент.вТкст0(), ttp.specType ? ttp.specType.вТкст0() : "");
            }

            inuse++;
            m2 = tp.matchArg(ti.место, paramscope, ti.tiargs, i, parameters, dedtypes, &sparam);
            inuse--;
            //printf("\tm2 = %d\n", m2);
            if (m2 == MATCH.nomatch)
            {
                version (none)
                {
                    printf("\tmatchArg() for параметр %i failed\n", i);
                }
                goto Lnomatch;
            }

            if (m2 < m)
                m = m2;

            if (!флаг)
                sparam.dsymbolSemantic(paramscope);
            if (!paramscope.вставь(sparam)) // TODO: This check can make more early
            {
                // in TemplateDeclaration.semantic, and
                // then we don't need to make sparam if flags == 0
                goto Lnomatch;
            }
        }

        if (!флаг)
        {
            /* Any параметр left without a тип gets the тип of
             * its corresponding arg
             */
            for (т_мера i = 0; i < dedtypes_dim; i++)
            {
                if (!(*dedtypes)[i])
                {
                    assert(i < ti.tiargs.dim);
                    (*dedtypes)[i] = cast(Тип)(*ti.tiargs)[i];
                }
            }
        }

        if (m > MATCH.nomatch && constraint && !флаг)
        {
            if (ti.hasNestedArgs(ti.tiargs, this.статичен_ли)) // TODO: should gag error
                ti.родитель = ti.enclosing;
            else
                ti.родитель = this.родитель;

            // Similar to doHeaderInstantiation
            FuncDeclaration fd = onemember ? onemember.isFuncDeclaration() : null;
            if (fd)
            {
                assert(fd.тип.ty == Tfunction);
                TypeFunction tf = cast(TypeFunction)fd.тип.syntaxCopy();

                fd = new FuncDeclaration(fd.место, fd.endloc, fd.идент, fd.класс_хранения, tf);
                fd.родитель = ti;
                fd.inferRetType = да;

                // Shouldn't run semantic on default arguments and return тип.
                for (т_мера i = 0; i < tf.parameterList.parameters.dim; i++)
                    (*tf.parameterList.parameters)[i].defaultArg = null;
                tf.следщ = null;
                tf.incomplete = да;

                // Resolve параметр types and 'auto ref's.
                tf.fargs = fargs;
                бцел olderrors = глоб2.startGagging();
                fd.тип = tf.typeSemantic(место, paramscope);
                глоб2.endGagging(olderrors);
                if (fd.тип.ty != Tfunction)
                    goto Lnomatch;
                fd.originalType = fd.тип; // for mangling
            }

            // TODO: dedtypes => ti.tiargs ?
            if (!evaluateConstraint(ti, sc, paramscope, dedtypes, fd))
                goto Lnomatch;
        }

        static if (LOGM)
        {
            // Print out the результатs
            printf("--------------------------\n");
            printf("template %s\n", вТкст0());
            printf("instance %s\n", ti.вТкст0());
            if (m > MATCH.nomatch)
            {
                for (т_мера i = 0; i < dedtypes_dim; i++)
                {
                    ПараметрШаблона2 tp = (*parameters)[i];
                    КорневойОбъект oarg;
                    printf(" [%d]", i);
                    if (i < ti.tiargs.dim)
                        oarg = (*ti.tiargs)[i];
                    else
                        oarg = null;
                    tp.print(oarg, (*dedtypes)[i]);
                }
            }
            else
                goto Lnomatch;
        }
        static if (LOGM)
        {
            printf(" match = %d\n", m);
        }
        goto Lret;

    Lnomatch:
        static if (LOGM)
        {
            printf(" no match\n");
        }
        m = MATCH.nomatch;

    Lret:
        paramscope.вынь();
        static if (LOGM)
        {
            printf("-TemplateDeclaration.matchWithInstance(this = %p, ti = %p) = %d\n", this, ti, m);
        }
        return m;
    }

    /********************************************
     * Determine partial specialization order of 'this' vs td2.
     * Возвращает:
     *      match   this is at least as specialized as td2
     *      0       td2 is more specialized than this
     */
    MATCH leastAsSpecialized(Scope* sc, TemplateDeclaration td2, Выражения* fargs)
    {
        const LOG_LEASTAS = 0;
        static if (LOG_LEASTAS)
        {
            printf("%s.leastAsSpecialized(%s)\n", вТкст0(), td2.вТкст0());
        }

        /* This works by taking the template parameters to this template
         * declaration and feeding them to td2 as if it were a template
         * instance.
         * If it works, then this template is at least as specialized
         * as td2.
         */

        // Set тип arguments to dummy template instance to be types
        // generated from the parameters to this template declaration
        auto tiargs = new Объекты();
        tiargs.резервируй(parameters.dim);
        for (т_мера i = 0; i < parameters.dim; i++)
        {
            ПараметрШаблона2 tp = (*parameters)[i];
            if (tp.dependent)
                break;
            КорневойОбъект p = cast(КорневойОбъект)tp.dummyArg();
            if (!p)
                break;

            tiargs.сунь(p);
        }
        scope TemplateInstance ti = new TemplateInstance(Место.initial, идент, tiargs); // создай dummy template instance

        // Temporary МассивДРК to hold deduced types
        Объекты dedtypes = Объекты(td2.parameters.dim);

        // Attempt a тип deduction
        MATCH m = td2.matchWithInstance(sc, ti, &dedtypes, fargs, 1);
        if (m > MATCH.nomatch)
        {
            /* A non-variadic template is more specialized than a
             * variadic one.
             */
            TemplateTupleParameter tp = isVariadic();
            if (tp && !tp.dependent && !td2.isVariadic())
                goto L1;

            static if (LOG_LEASTAS)
            {
                printf("  matches %d, so is least as specialized\n", m);
            }
            return m;
        }
    L1:
        static if (LOG_LEASTAS)
        {
            printf("  doesn't match, so is not as specialized\n");
        }
        return MATCH.nomatch;
    }

    /*************************************************
     * Match function arguments against a specific template function.
     * Input:
     *      ti
     *      sc              instantiation scope
     *      fd
     *      tthis           'this' argument if !NULL
     *      fargs           arguments to function
     * Output:
     *      fd              Partially instantiated function declaration
     *      ti.tdtypes     Выражение/Тип deduced template arguments
     * Возвращает:
     *      match уровень
     *          bit 0-3     Match template parameters by inferred template arguments
     *          bit 4-7     Match template parameters by initial template arguments
     */
    extern (D) MATCH deduceFunctionTemplateMatch(TemplateInstance ti, Scope* sc, ref FuncDeclaration fd, Тип tthis, Выражения* fargs)
    {
        т_мера nfparams;
        т_мера nfargs;
        т_мера ntargs; // массив size of tiargs
        т_мера fptupindex = IDX_NOTFOUND;
        MATCH match = MATCH.exact;
        MATCH matchTiargs = MATCH.exact;
        СписокПараметров fparameters; // function параметр list
        ВарАрг fvarargs; // function varargs
        бцел wildmatch = 0;
        т_мера inferStart = 0;

        Место instLoc = ti.место;
        Объекты* tiargs = ti.tiargs;
        auto dedargs = new Объекты();
        Объекты* dedtypes = &ti.tdtypes; // for T:T*, the dedargs is the T*, dedtypes is the T

        version (none)
        {
            printf("\nTemplateDeclaration.deduceFunctionTemplateMatch() %s\n", вТкст0());
            for (т_мера i = 0; i < (fargs ? fargs.dim : 0); i++)
            {
                Выражение e = (*fargs)[i];
                printf("\tfarg[%d] is %s, тип is %s\n", i, e.вТкст0(), e.тип.вТкст0());
            }
            printf("fd = %s\n", fd.вТкст0());
            printf("fd.тип = %s\n", fd.тип.вТкст0());
            if (tthis)
                printf("tthis = %s\n", tthis.вТкст0());
        }

        assert(_scope);

        dedargs.устДим(parameters.dim);
        dedargs.нуль();

        dedtypes.устДим(parameters.dim);
        dedtypes.нуль();

        if (errors || fd.errors)
            return MATCH.nomatch;

        // Set up scope for parameters
        Scope* paramscope = scopeForTemplateParameters(ti,sc);

        // Mark the параметр scope as deprecated if the templated
        // function is deprecated (since paramscope.enclosing is the
        // calling scope already)
        paramscope.stc |= fd.класс_хранения & STC.deprecated_;

        TemplateTupleParameter tp = isVariadic();
        Tuple declaredTuple = null;

        version (none)
        {
            for (т_мера i = 0; i < dedargs.dim; i++)
            {
                printf("\tdedarg[%d] = ", i);
                КорневойОбъект oarg = (*dedargs)[i];
                if (oarg)
                    printf("%s", oarg.вТкст0());
                printf("\n");
            }
        }

        ntargs = 0;
        if (tiargs)
        {
            // Set initial template arguments
            ntargs = tiargs.dim;
            т_мера n = parameters.dim;
            if (tp)
                n--;
            if (ntargs > n)
            {
                if (!tp)
                    goto Lnomatch;

                /* The extra initial template arguments
                 * now form the кортеж argument.
                 */
                auto t = new Tuple(ntargs - n);
                assert(parameters.dim);
                (*dedargs)[parameters.dim - 1] = t;

                for (т_мера i = 0; i < t.objects.dim; i++)
                {
                    t.objects[i] = (*tiargs)[n + i];
                }
                declareParameter(paramscope, tp, t);
                declaredTuple = t;
            }
            else
                n = ntargs;

            memcpy(dedargs.tdata(), tiargs.tdata(), n * (*dedargs.tdata()).sizeof);

            for (т_мера i = 0; i < n; i++)
            {
                assert(i < parameters.dim);
                Declaration sparam = null;
                MATCH m = (*parameters)[i].matchArg(instLoc, paramscope, dedargs, i, parameters, dedtypes, &sparam);
                //printf("\tdeduceType m = %d\n", m);
                if (m <= MATCH.nomatch)
                    goto Lnomatch;
                if (m < matchTiargs)
                    matchTiargs = m;

                sparam.dsymbolSemantic(paramscope);
                if (!paramscope.вставь(sparam))
                    goto Lnomatch;
            }
            if (n < parameters.dim && !declaredTuple)
            {
                inferStart = n;
            }
            else
                inferStart = parameters.dim;
            //printf("tiargs matchTiargs = %d\n", matchTiargs);
        }
        version (none)
        {
            for (т_мера i = 0; i < dedargs.dim; i++)
            {
                printf("\tdedarg[%d] = ", i);
                КорневойОбъект oarg = (*dedargs)[i];
                if (oarg)
                    printf("%s", oarg.вТкст0());
                printf("\n");
            }
        }

        fparameters = fd.getParameterList();
        nfparams = fparameters.length; // number of function parameters
        nfargs = fargs ? fargs.dim : 0; // number of function arguments

        /* Check for match of function arguments with variadic template
         * параметр, such as:
         *
         * проц foo(T, A...)(T t, A a);
         * проц main() { foo(1,2,3); }
         */
        if (tp) // if variadic
        {
            // TemplateTupleParameter always makes most lesser matching.
            matchTiargs = MATCH.convert;

            if (nfparams == 0 && nfargs != 0) // if no function parameters
            {
                if (!declaredTuple)
                {
                    auto t = new Tuple();
                    //printf("t = %p\n", t);
                    (*dedargs)[parameters.dim - 1] = t;
                    declareParameter(paramscope, tp, t);
                    declaredTuple = t;
                }
            }
            else
            {
                /* Figure out which of the function parameters matches
                 * the кортеж template параметр. Do this by matching
                 * тип identifiers.
                 * Set the index of this function параметр to fptupindex.
                 */
                for (fptupindex = 0; fptupindex < nfparams; fptupindex++)
                {
                    auto fparam = (*fparameters.parameters)[fptupindex]; // fparameters[fptupindex] ?
                    if (fparam.тип.ty != Tident)
                        continue;
                    TypeIdentifier tid = cast(TypeIdentifier)fparam.тип;
                    if (!tp.идент.равен(tid.идент) || tid.idents.dim)
                        continue;

                    if (fparameters.varargs != ВарАрг.none) // variadic function doesn't
                        goto Lnomatch; // go with variadic template

                    goto L1;
                }
                fptupindex = IDX_NOTFOUND;           
            }
        }
 L1:
        if (toParent().isModule() || (_scope.stc & STC.static_))
            tthis = null;
        if (tthis)
        {
            бул hasttp = нет;

            // Match 'tthis' to any TemplateThisParameter's
            for (т_мера i = 0; i < parameters.dim; i++)
            {
                TemplateThisParameter ttp = (*parameters)[i].isTemplateThisParameter();
                if (ttp)
                {
                    hasttp = да;

                    Тип t = new TypeIdentifier(Место.initial, ttp.идент);
                    MATCH m = deduceType(tthis, paramscope, t, parameters, dedtypes);
                    if (m <= MATCH.nomatch)
                        goto Lnomatch;
                    if (m < match)
                        match = m; // pick worst match
                }
            }

            // Match attributes of tthis against attributes of fd
            if (fd.тип && !fd.isCtorDeclaration())
            {
                КлассХранения stc = _scope.stc | fd.storage_class2;
                // Propagate родитель storage class, https://issues.dlang.org/show_bug.cgi?ид=5504
                ДСимвол p = родитель;
                while (p.isTemplateDeclaration() || p.isTemplateInstance())
                    p = p.родитель;
                AggregateDeclaration ad = p.isAggregateDeclaration();
                if (ad)
                    stc |= ad.класс_хранения;

                ббайт mod = fd.тип.mod;
                if (stc & STC.immutable_)
                    mod = MODFlags.immutable_;
                else
                {
                    if (stc & (STC.shared_ | STC.synchronized_))
                        mod |= MODFlags.shared_;
                    if (stc & STC.const_)
                        mod |= MODFlags.const_;
                    if (stc & STC.wild)
                        mod |= MODFlags.wild;
                }

                ббайт thismod = tthis.mod;
                if (hasttp)
                    mod = MODmerge(thismod, mod);
                MATCH m = MODmethodConv(thismod, mod);
                if (m <= MATCH.nomatch)
                    goto Lnomatch;
                if (m < match)
                    match = m;
            }
        }

        // Loop through the function parameters
        {
            //printf("%s\n\tnfargs = %d, nfparams = %d, tuple_dim = %d\n", вТкст0(), nfargs, nfparams, declaredTuple ? declaredTuple.objects.dim : 0);
            //printf("\ttp = %p, fptupindex = %d, found = %d, declaredTuple = %s\n", tp, fptupindex, fptupindex != IDX_NOTFOUND, declaredTuple ? declaredTuple.вТкст0() : NULL);
            т_мера argi = 0;
            т_мера nfargs2 = nfargs; // nfargs + supplied defaultArgs
            for (т_мера parami = 0; parami < nfparams; parami++)
            {
                Параметр2 fparam = fparameters[parami];

                // Apply function параметр storage classes to параметр types
                Тип prmtype = fparam.тип.addStorageClass(fparam.классХранения);

                Выражение farg;

                /* See function parameters which wound up
                 * as part of a template кортеж параметр.
                 */
                if (fptupindex != IDX_NOTFOUND && parami == fptupindex)
                {
                    assert(prmtype.ty == Tident);
                    TypeIdentifier tid = cast(TypeIdentifier)prmtype;
                    if (!declaredTuple)
                    {
                        /* The types of the function arguments
                         * now form the кортеж argument.
                         */
                        declaredTuple = new Tuple();
                        (*dedargs)[parameters.dim - 1] = declaredTuple;

                        /* Count function parameters with no defaults following a кортеж параметр.
                         * проц foo(U, T...)(цел y, T, U, double, цел bar = 0) {}  // rem == 2 (U, double)
                         */
                        т_мера rem = 0;
                        for (т_мера j = parami + 1; j < nfparams; j++)
                        {
                            Параметр2 p = fparameters[j];
                            if (p.defaultArg)
                            {
                               break;
                            }
                            if (!reliesOnTemplateParameters(p.тип, (*parameters)[inferStart .. parameters.dim]))
                            {
                                Тип pt = p.тип.syntaxCopy().typeSemantic(fd.место, paramscope);
                                rem += pt.ty == Ttuple ? (cast(КортежТипов)pt).arguments.dim : 1;
                            }
                            else
                            {
                                ++rem;
                            }
                        }

                        if (nfargs2 - argi < rem)
                            goto Lnomatch;
                        declaredTuple.objects.устДим(nfargs2 - argi - rem);
                        for (т_мера i = 0; i < declaredTuple.objects.dim; i++)
                        {
                            farg = (*fargs)[argi + i];

                            // Check invalid arguments to detect errors early.
                            if (farg.op == ТОК2.error || farg.тип.ty == Terror)
                                goto Lnomatch;

                            if (!(fparam.классХранения & STC.lazy_) && farg.тип.ty == Tvoid)
                                goto Lnomatch;

                            Тип tt;
                            MATCH m;
                            if (ббайт wm = deduceWildHelper(farg.тип, &tt, tid))
                            {
                                wildmatch |= wm;
                                m = MATCH.constant;
                            }
                            else
                            {
                                m = deduceTypeHelper(farg.тип, &tt, tid);
                            }
                            if (m <= MATCH.nomatch)
                                goto Lnomatch;
                            if (m < match)
                                match = m;

                            /* Remove top const for dynamic массив types and pointer types
                             */
                            if ((tt.ty == Tarray || tt.ty == Tpointer) && !tt.isMutable() && (!(fparam.классХранения & STC.ref_) || (fparam.классХранения & STC.auto_) && !farg.isLvalue()))
                            {
                                tt = tt.mutableOf();
                            }
                            declaredTuple.objects[i] = tt;
                        }
                        declareParameter(paramscope, tp, declaredTuple);
                    }
                    else
                    {
                        // https://issues.dlang.org/show_bug.cgi?ид=6810
                        // If declared кортеж is not a тип кортеж,
                        // it cannot be function параметр types.
                        for (т_мера i = 0; i < declaredTuple.objects.dim; i++)
                        {
                            if (!тип_ли(declaredTuple.objects[i]))
                                goto Lnomatch;
                        }
                    }
                    assert(declaredTuple);
                    argi += declaredTuple.objects.dim;
                    continue;
                }

                // If параметр тип doesn't depend on inferred template parameters,
                // semantic it to get actual тип.
                if (!reliesOnTemplateParameters(prmtype, (*parameters)[inferStart .. parameters.dim]))
                {
                    // should копируй prmtype to avoid affecting semantic результат
                    prmtype = prmtype.syntaxCopy().typeSemantic(fd.место, paramscope);

                    if (prmtype.ty == Ttuple)
                    {
                        КортежТипов tt = cast(КортежТипов)prmtype;
                        т_мера tt_dim = tt.arguments.dim;
                        for (т_мера j = 0; j < tt_dim; j++, ++argi)
                        {
                            Параметр2 p = (*tt.arguments)[j];
                            if (j == tt_dim - 1 && fparameters.varargs == ВарАрг.typesafe &&
                                parami + 1 == nfparams && argi < nfargs)
                            {
                                prmtype = p.тип;
                                goto Lvarargs;
                            }
                            if (argi >= nfargs)
                            {
                                if (p.defaultArg)
                                    continue;

                                // https://issues.dlang.org/show_bug.cgi?ид=19888
                                if (fparam.defaultArg)
                                    break;

                                goto Lnomatch;
                            }
                            farg = (*fargs)[argi];
                            if (!farg.implicitConvTo(p.тип))
                                goto Lnomatch;
                        }
                        continue;
                    }
                }

                if (argi >= nfargs) // if not enough arguments
                {
                    if (!fparam.defaultArg)
                        goto Lvarargs;

                    /* https://issues.dlang.org/show_bug.cgi?ид=2803
                     * Before the starting of тип deduction from the function
                     * default arguments, set the already deduced parameters into paramscope.
                     * It's necessary to avoid breaking existing acceptable code. Cases:
                     *
                     * 1. Already deduced template parameters can appear in fparam.defaultArg:
                     *  auto foo(A, B)(A a, B b = A.stringof);
                     *  foo(1);
                     *  // at fparam == 'B b = A.ткст', A is equivalent with the deduced тип 'цел'
                     *
                     * 2. If prmtype depends on default-specified template параметр, the
                     * default тип should be preferred.
                     *  auto foo(N = т_мера, R)(R r, N start = 0)
                     *  foo([1,2,3]);
                     *  // at fparam `N start = 0`, N should be 'т_мера' before
                     *  // the deduction результат from fparam.defaultArg.
                     */
                    if (argi == nfargs)
                    {
                        for (т_мера i = 0; i < dedtypes.dim; i++)
                        {
                            Тип at = тип_ли((*dedtypes)[i]);
                            if (at && at.ty == Tnone)
                            {
                                TypeDeduced xt = cast(TypeDeduced)at;
                                (*dedtypes)[i] = xt.tded; // 'unbox'
                            }
                        }
                        for (т_мера i = ntargs; i < dedargs.dim; i++)
                        {
                            ПараметрШаблона2 tparam = (*parameters)[i];

                            КорневойОбъект oarg = (*dedargs)[i];
                            КорневойОбъект oded = (*dedtypes)[i];
                            if (!oarg)
                            {
                                if (oded)
                                {
                                    if (tparam.specialization() || !tparam.isTemplateTypeParameter())
                                    {
                                        /* The specialization can work as long as afterwards
                                         * the oded == oarg
                                         */
                                        (*dedargs)[i] = oded;
                                        MATCH m2 = tparam.matchArg(instLoc, paramscope, dedargs, i, parameters, dedtypes, null);
                                        //printf("m2 = %d\n", m2);
                                        if (m2 <= MATCH.nomatch)
                                            goto Lnomatch;
                                        if (m2 < matchTiargs)
                                            matchTiargs = m2; // pick worst match
                                        if (!(*dedtypes)[i].равен(oded))
                                            выведиОшибку("specialization not allowed for deduced параметр `%s`", tparam.идент.вТкст0());
                                    }
                                    else
                                    {
                                        if (MATCH.convert < matchTiargs)
                                            matchTiargs = MATCH.convert;
                                    }
                                    (*dedargs)[i] = declareParameter(paramscope, tparam, oded);
                                }
                                else
                                {
                                    inuse++;
                                    oded = tparam.defaultArg(instLoc, paramscope);
                                    inuse--;
                                    if (oded)
                                        (*dedargs)[i] = declareParameter(paramscope, tparam, oded);
                                }
                            }
                        }
                    }
                    nfargs2 = argi + 1;

                    /* If prmtype does not depend on any template parameters:
                     *
                     *  auto foo(T)(T v, double x = 0);
                     *  foo("str");
                     *  // at fparam == 'double x = 0'
                     *
                     * or, if all template parameters in the prmtype are already deduced:
                     *
                     *  auto foo(R)(R range, ElementType!R sum = 0);
                     *  foo([1,2,3]);
                     *  // at fparam == 'ElementType!R sum = 0'
                     *
                     * Deducing prmtype from fparam.defaultArg is not necessary.
                     */
                    if (prmtype.deco || prmtype.syntaxCopy().trySemantic(место, paramscope))
                    {
                        ++argi;
                        continue;
                    }

                    // Deduce prmtype from the defaultArg.
                    farg = fparam.defaultArg.syntaxCopy();
                    farg = farg.ВыражениеSemantic(paramscope);
                    farg = resolveProperties(paramscope, farg);
                }
                else
                {
                    farg = (*fargs)[argi];
                }
                {
                    // Check invalid arguments to detect errors early.
                    if (farg.op == ТОК2.error || farg.тип.ty == Terror)
                        goto Lnomatch;

                    Тип att = null;
                Lretry:
                    version (none)
                    {
                        printf("\tfarg.тип   = %s\n", farg.тип.вТкст0());
                        printf("\tfparam.тип = %s\n", prmtype.вТкст0());
                    }
                    Тип argtype = farg.тип;

                    if (!(fparam.классХранения & STC.lazy_) && argtype.ty == Tvoid && farg.op != ТОК2.function_)
                        goto Lnomatch;

                    // https://issues.dlang.org/show_bug.cgi?ид=12876
                    // Optimize argument to allow CT-known length matching
                    farg = farg.optimize(WANTvalue, (fparam.классХранения & (STC.ref_ | STC.out_)) != 0);
                    //printf("farg = %s %s\n", farg.тип.вТкст0(), farg.вТкст0());

                    КорневойОбъект oarg = farg;
                    if ((fparam.классХранения & STC.ref_) && (!(fparam.классХранения & STC.auto_) || farg.isLvalue()))
                    {
                        /* Allow Выражения that have CT-known boundaries and тип [] to match with [dim]
                         */
                        Тип taai;
                        if (argtype.ty == Tarray && (prmtype.ty == Tsarray || prmtype.ty == Taarray && (taai = (cast(TypeAArray)prmtype).index).ty == Tident && (cast(TypeIdentifier)taai).idents.dim == 0))
                        {
                            if (farg.op == ТОК2.string_)
                            {
                                StringExp se = cast(StringExp)farg;
                                argtype = se.тип.nextOf().sarrayOf(se.len);
                            }
                            else if (farg.op == ТОК2.arrayLiteral)
                            {
                                ArrayLiteralExp ae = cast(ArrayLiteralExp)farg;
                                argtype = ae.тип.nextOf().sarrayOf(ae.elements.dim);
                            }
                            else if (farg.op == ТОК2.slice)
                            {
                                SliceExp se = cast(SliceExp)farg;
                                if (Тип tsa = toStaticArrayType(se))
                                    argtype = tsa;
                            }
                        }

                        oarg = argtype;
                    }
                    else if ((fparam.классХранения & STC.out_) == 0 && (argtype.ty == Tarray || argtype.ty == Tpointer) && templateParameterLookup(prmtype, parameters) != IDX_NOTFOUND && (cast(TypeIdentifier)prmtype).idents.dim == 0)
                    {
                        /* The farg passing to the prmtype always make a копируй. Therefore,
                         * we can shrink the set of the deduced тип arguments for prmtype
                         * by adjusting top-qualifier of the argtype.
                         *
                         *  prmtype         argtype     ta
                         *  T            <- const(E)[]  const(E)[]
                         *  T            <- const(E[])  const(E)[]
                         *  qualifier(T) <- const(E)[]  const(E[])
                         *  qualifier(T) <- const(E[])  const(E[])
                         */
                        Тип ta = argtype.castMod(prmtype.mod ? argtype.nextOf().mod : 0);
                        if (ta != argtype)
                        {
                            Выражение ea = farg.копируй();
                            ea.тип = ta;
                            oarg = ea;
                        }
                    }

                    if (fparameters.varargs == ВарАрг.typesafe && parami + 1 == nfparams && argi + 1 < nfargs)
                        goto Lvarargs;

                    бцел wm = 0;
                    MATCH m = deduceType(oarg, paramscope, prmtype, parameters, dedtypes, &wm, inferStart);
                    //printf("\tL%d deduceType m = %d, wm = x%x, wildmatch = x%x\n", __LINE__, m, wm, wildmatch);
                    wildmatch |= wm;

                    /* If no match, see if the argument can be matched by using
                     * implicit conversions.
                     */
                    if (m == MATCH.nomatch && prmtype.deco)
                        m = farg.implicitConvTo(prmtype);

                    if (m == MATCH.nomatch)
                    {
                        AggregateDeclaration ad = isAggregate(farg.тип);
                        if (ad && ad.aliasthis && argtype != att)
                        {
                            if (!att && argtype.checkAliasThisRec())   // https://issues.dlang.org/show_bug.cgi?ид=12537
                                att = argtype;
                            /* If a semantic error occurs while doing alias this,
                             * eg purity(https://issues.dlang.org/show_bug.cgi?ид=7295),
                             * just regard it as not a match.
                             */
                            if (auto e = resolveAliasThis(sc, farg, да))
                            {
                                farg = e;
                                goto Lretry;
                            }
                        }
                    }

                    if (m > MATCH.nomatch && (fparam.классХранения & (STC.ref_ | STC.auto_)) == STC.ref_)
                    {
                        if (!farg.isLvalue())
                        {
                            if ((farg.op == ТОК2.string_ || farg.op == ТОК2.slice) && (prmtype.ty == Tsarray || prmtype.ty == Taarray))
                            {
                                // Allow conversion from T[lwr .. upr] to ref T[upr-lwr]
                            }
                            else
                                goto Lnomatch;
                        }
                    }
                    if (m > MATCH.nomatch && (fparam.классХранения & STC.out_))
                    {
                        if (!farg.isLvalue())
                            goto Lnomatch;
                        if (!farg.тип.isMutable()) // https://issues.dlang.org/show_bug.cgi?ид=11916
                            goto Lnomatch;
                    }
                    if (m == MATCH.nomatch && (fparam.классХранения & STC.lazy_) && prmtype.ty == Tvoid && farg.тип.ty != Tvoid)
                        m = MATCH.convert;
                    if (m != MATCH.nomatch)
                    {
                        if (m < match)
                            match = m; // pick worst match
                        argi++;
                        continue;
                    }
                }

            Lvarargs:
                /* The following code for variadic arguments closely
                 * matches TypeFunction.callMatch()
                 */
                if (!(fparameters.varargs == ВарАрг.typesafe && parami + 1 == nfparams))
                    goto Lnomatch;

                /* Check for match with function параметр T...
                 */
                Тип tb = prmtype.toBasetype();
                switch (tb.ty)
                {
                    // 6764 fix - TypeAArray may be TypeSArray have not yet run semantic().
                case Tsarray:
                case Taarray:
                    {
                        // Perhaps we can do better with this, see TypeFunction.callMatch()
                        if (tb.ty == Tsarray)
                        {
                            TypeSArray tsa = cast(TypeSArray)tb;
                            dinteger_t sz = tsa.dim.toInteger();
                            if (sz != nfargs - argi)
                                goto Lnomatch;
                        }
                        else if (tb.ty == Taarray)
                        {
                            TypeAArray taa = cast(TypeAArray)tb;
                            Выражение dim = new IntegerExp(instLoc, nfargs - argi, Тип.tт_мера);

                            т_мера i = templateParameterLookup(taa.index, parameters);
                            if (i == IDX_NOTFOUND)
                            {
                                Выражение e;
                                Тип t;
                                ДСимвол s;
                                Scope *sco;

                                бцел errors = глоб2.startGagging();
                                /* ref: https://issues.dlang.org/show_bug.cgi?ид=11118
                                 * The параметр isn't part of the template
                                 * ones, let's try to найди it in the
                                 * instantiation scope 'sc' and the one
                                 * belonging to the template itself. */
                                sco = sc;
                                taa.index.resolve(instLoc, sco, &e, &t, &s);
                                if (!e)
                                {
                                    sco = paramscope;
                                    taa.index.resolve(instLoc, sco, &e, &t, &s);
                                }
                                глоб2.endGagging(errors);

                                if (!e)
                                {
                                    goto Lnomatch;
                                }

                                e = e.ctfeInterpret();
                                e = e.implicitCastTo(sco, Тип.tт_мера);
                                e = e.optimize(WANTvalue);
                                if (!dim.равен(e))
                                    goto Lnomatch;
                            }
                            else
                            {
                                // This code matches code in TypeInstance.deduceType()
                                ПараметрШаблона2 tprm = (*parameters)[i];
                                TemplateValueParameter tvp = tprm.isTemplateValueParameter();
                                if (!tvp)
                                    goto Lnomatch;
                                Выражение e = cast(Выражение)(*dedtypes)[i];
                                if (e)
                                {
                                    if (!dim.равен(e))
                                        goto Lnomatch;
                                }
                                else
                                {
                                    Тип vt = tvp.valType.typeSemantic(Место.initial, sc);
                                    MATCH m = dim.implicitConvTo(vt);
                                    if (m <= MATCH.nomatch)
                                        goto Lnomatch;
                                    (*dedtypes)[i] = dim;
                                }
                            }
                        }
                        goto case Tarray;
                    }
                case Tarray:
                    {
                        TypeArray ta = cast(TypeArray)tb;
                        Тип tret = fparam.isLazyArray();
                        for (; argi < nfargs; argi++)
                        {
                            Выражение arg = (*fargs)[argi];
                            assert(arg);

                            MATCH m;
                            /* If lazy массив of delegates,
                             * convert arg(s) to delegate(s)
                             */
                            if (tret)
                            {
                                if (ta.следщ.равен(arg.тип))
                                {
                                    m = MATCH.exact;
                                }
                                else
                                {
                                    m = arg.implicitConvTo(tret);
                                    if (m == MATCH.nomatch)
                                    {
                                        if (tret.toBasetype().ty == Tvoid)
                                            m = MATCH.convert;
                                    }
                                }
                            }
                            else
                            {
                                бцел wm = 0;
                                m = deduceType(arg, paramscope, ta.следщ, parameters, dedtypes, &wm, inferStart);
                                wildmatch |= wm;
                            }
                            if (m == MATCH.nomatch)
                                goto Lnomatch;
                            if (m < match)
                                match = m;
                        }
                        goto Lmatch;
                    }
                case Tclass:
                case Tident:
                    goto Lmatch;

                default:
                    goto Lnomatch;
                }
                assert(0);
            }
            //printf(". argi = %d, nfargs = %d, nfargs2 = %d\n", argi, nfargs, nfargs2);
            if (argi != nfargs2 && fparameters.varargs == ВарАрг.none)
                goto Lnomatch;
        }

    Lmatch:
        for (т_мера i = 0; i < dedtypes.dim; i++)
        {
            Тип at = тип_ли((*dedtypes)[i]);
            if (at)
            {
                if (at.ty == Tnone)
                {
                    TypeDeduced xt = cast(TypeDeduced)at;
                    at = xt.tded; // 'unbox'
                }
                (*dedtypes)[i] = at.merge2();
            }
        }
        for (т_мера i = ntargs; i < dedargs.dim; i++)
        {
            ПараметрШаблона2 tparam = (*parameters)[i];
            //printf("tparam[%d] = %s\n", i, tparam.идент.вТкст0());

            /* For T:T*, the dedargs is the T*, dedtypes is the T
             * But for function templates, we really need them to match
             */
            КорневойОбъект oarg = (*dedargs)[i];
            КорневойОбъект oded = (*dedtypes)[i];
            //printf("1dedargs[%d] = %p, dedtypes[%d] = %p\n", i, oarg, i, oded);
            //if (oarg) printf("oarg: %s\n", oarg.вТкст0());
            //if (oded) printf("oded: %s\n", oded.вТкст0());
            if (!oarg)
            {
                if (oded)
                {
                    if (tparam.specialization() || !tparam.isTemplateTypeParameter())
                    {
                        /* The specialization can work as long as afterwards
                         * the oded == oarg
                         */
                        (*dedargs)[i] = oded;
                        MATCH m2 = tparam.matchArg(instLoc, paramscope, dedargs, i, parameters, dedtypes, null);
                        //printf("m2 = %d\n", m2);
                        if (m2 <= MATCH.nomatch)
                            goto Lnomatch;
                        if (m2 < matchTiargs)
                            matchTiargs = m2; // pick worst match
                        if (!(*dedtypes)[i].равен(oded))
                            выведиОшибку("specialization not allowed for deduced параметр `%s`", tparam.идент.вТкст0());
                    }
                    else
                    {
                        // Discussion: https://issues.dlang.org/show_bug.cgi?ид=16484
                        if (MATCH.convert < matchTiargs)
                            matchTiargs = MATCH.convert;
                    }
                }
                else
                {
                    inuse++;
                    oded = tparam.defaultArg(instLoc, paramscope);
                    inuse--;
                    if (!oded)
                    {
                        // if кортеж параметр and
                        // кортеж параметр was not in function параметр list and
                        // we're one or more arguments short (i.e. no кортеж argument)
                        if (tparam == tp &&
                            fptupindex == IDX_NOTFOUND &&
                            ntargs <= dedargs.dim - 1)
                        {
                            // make кортеж argument an empty кортеж
                            oded = new Tuple();
                        }
                        else
                            goto Lnomatch;
                    }
                    if (isError(oded))
                        goto Lerror;
                    ntargs++;

                    /* At the template параметр T, the picked default template argument
                     * X!цел should be matched to T in order to deduce dependent
                     * template параметр A.
                     *  auto foo(T : X!A = X!цел, A...)() { ... }
                     *  foo();  // T <-- X!цел, A <-- (цел)
                     */
                    if (tparam.specialization())
                    {
                        (*dedargs)[i] = oded;
                        MATCH m2 = tparam.matchArg(instLoc, paramscope, dedargs, i, parameters, dedtypes, null);
                        //printf("m2 = %d\n", m2);
                        if (m2 <= MATCH.nomatch)
                            goto Lnomatch;
                        if (m2 < matchTiargs)
                            matchTiargs = m2; // pick worst match
                        if (!(*dedtypes)[i].равен(oded))
                            выведиОшибку("specialization not allowed for deduced параметр `%s`", tparam.идент.вТкст0());
                    }
                }
                oded = declareParameter(paramscope, tparam, oded);
                (*dedargs)[i] = oded;
            }
        }

        /* https://issues.dlang.org/show_bug.cgi?ид=7469
         * As same as the code for 7469 in findBestMatch,
         * expand a Tuple in dedargs to normalize template arguments.
         */
        if (auto d = dedargs.dim)
        {
            if (auto va = кортеж_ли((*dedargs)[d - 1]))
            {
                dedargs.устДим(d - 1);
                dedargs.вставь(d - 1, &va.objects);
            }
        }
        ti.tiargs = dedargs; // update to the normalized template arguments.

        // Partially instantiate function for constraint and fd.leastAsSpecialized()
        {
            assert(paramscope.scopesym);
            Scope* sc2 = _scope;
            sc2 = sc2.сунь(paramscope.scopesym);
            sc2 = sc2.сунь(ti);
            sc2.родитель = ti;
            sc2.tinst = ti;
            sc2.minst = sc.minst;
            sc2.stc |= fd.класс_хранения & STC.deprecated_;

            fd = doHeaderInstantiation(ti, sc2, fd, tthis, fargs);

            sc2 = sc2.вынь();
            sc2 = sc2.вынь();

            if (!fd)
                goto Lnomatch;
        }

        if (constraint)
        {
            if (!evaluateConstraint(ti, sc, paramscope, dedargs, fd))
                goto Lnomatch;
        }

        version (none)
        {
            for (т_мера i = 0; i < dedargs.dim; i++)
            {
                КорневойОбъект o = (*dedargs)[i];
                printf("\tdedargs[%d] = %d, %s\n", i, o.динкаст(), o.вТкст0());
            }
        }

        paramscope.вынь();
        //printf("\tmatch %d\n", match);
        return cast(MATCH)(match | (matchTiargs << 4));

    Lnomatch:
        paramscope.вынь();
        //printf("\tnomatch\n");
        return MATCH.nomatch;

    Lerror:
        // todo: for the future improvement
        paramscope.вынь();
        //printf("\terror\n");
        return MATCH.nomatch;
    }

    /**************************************************
     * Declare template параметр tp with значение o, and install it in the scope sc.
     */
    КорневойОбъект declareParameter(Scope* sc, ПараметрШаблона2 tp, КорневойОбъект o)
    {
        //printf("TemplateDeclaration.declareParameter('%s', o = %p)\n", tp.идент.вТкст0(), o);
        Тип ta = тип_ли(o);
        Выражение ea = выражение_ли(o);
        ДСимвол sa = isDsymbol(o);
        Tuple va = кортеж_ли(o);

        Declaration d;
        VarDeclaration v = null;

        if (ea && ea.op == ТОК2.тип)
            ta = ea.тип;
        else if (ea && ea.op == ТОК2.scope_)
            sa = (cast(ScopeExp)ea).sds;
        else if (ea && (ea.op == ТОК2.this_ || ea.op == ТОК2.super_))
            sa = (cast(ThisExp)ea).var;
        else if (ea && ea.op == ТОК2.function_)
        {
            if ((cast(FuncExp)ea).td)
                sa = (cast(FuncExp)ea).td;
            else
                sa = (cast(FuncExp)ea).fd;
        }

        if (ta)
        {
            //printf("тип %s\n", ta.вТкст0());
            auto ad = new AliasDeclaration(Место.initial, tp.идент, ta);
            ad.wasTemplateParameter = да;
            d = ad;
        }
        else if (sa)
        {
            //printf("Alias %s %s;\n", sa.идент.вТкст0(), tp.идент.вТкст0());
            auto ad = new AliasDeclaration(Место.initial, tp.идент, sa);
            ad.wasTemplateParameter = да;
            d = ad;
        }
        else if (ea)
        {
            // tdtypes.данные[i] always matches ea here
            Инициализатор _иниц = new ExpInitializer(место, ea);
            TemplateValueParameter tvp = tp.isTemplateValueParameter();
            Тип t = tvp ? tvp.valType : null;
            v = new VarDeclaration(место, t, tp.идент, _иниц);
            v.класс_хранения = STC.manifest | STC.шаблонпараметр;
            d = v;
        }
        else if (va)
        {
            //printf("\ttuple\n");
            d = new TupleDeclaration(место, tp.идент, &va.objects);
        }
        else
        {
            assert(0);
        }
        d.класс_хранения |= STC.шаблонпараметр;

        if (ta)
        {
            Тип t = ta;
            // consistent with Тип.checkDeprecated()
            while (t.ty != Tenum)
            {
                if (!t.nextOf())
                    break;
                t = (cast(TypeNext)t).следщ;
            }
            if (ДСимвол s = t.toDsymbol(sc))
            {
                if (s.isDeprecated())
                    d.класс_хранения |= STC.deprecated_;
            }
        }
        else if (sa)
        {
            if (sa.isDeprecated())
                d.класс_хранения |= STC.deprecated_;
        }

        if (!sc.вставь(d))
            выведиОшибку("declaration `%s` is already defined", tp.идент.вТкст0());
        d.dsymbolSemantic(sc);
        /* So the caller's o gets updated with the результат of semantic() being run on o
         */
        if (v)
            o = v._иниц.инициализаторВВыражение();
        return o;
    }

    /*************************************************
     * Limited function template instantiation for using fd.leastAsSpecialized()
     */
    extern (D) FuncDeclaration doHeaderInstantiation(TemplateInstance ti, Scope* sc2, FuncDeclaration fd, Тип tthis, Выражения* fargs)
    {
        assert(fd);
        version (none)
        {
            printf("doHeaderInstantiation this = %s\n", вТкст0());
        }

        // function body and contracts are not need
        if (fd.isCtorDeclaration())
            fd = new CtorDeclaration(fd.место, fd.endloc, fd.класс_хранения, fd.тип.syntaxCopy());
        else
            fd = new FuncDeclaration(fd.место, fd.endloc, fd.идент, fd.класс_хранения, fd.тип.syntaxCopy());
        fd.родитель = ti;

        assert(fd.тип.ty == Tfunction);
        TypeFunction tf = cast(TypeFunction)fd.тип;
        tf.fargs = fargs;

        if (tthis)
        {
            // Match 'tthis' to any TemplateThisParameter's
            бул hasttp = нет;
            for (т_мера i = 0; i < parameters.dim; i++)
            {
                ПараметрШаблона2 tp = (*parameters)[i];
                TemplateThisParameter ttp = tp.isTemplateThisParameter();
                if (ttp)
                    hasttp = да;
            }
            if (hasttp)
            {
                tf = cast(TypeFunction)tf.addSTC(ModToStc(tthis.mod));
                assert(!tf.deco);
            }
        }

        Scope* scx = sc2.сунь();

        // Shouldn't run semantic on default arguments and return тип.
        for (т_мера i = 0; i < tf.parameterList.parameters.dim; i++)
            (*tf.parameterList.parameters)[i].defaultArg = null;
        tf.incomplete = да;

        if (fd.isCtorDeclaration())
        {
            // For constructors, emitting return тип is necessary for
            // isReturnIsolated() in functionResolve.
            scx.flags |= SCOPE.ctor;

            ДСимвол родитель = toParentDecl();
            Тип tret;
            AggregateDeclaration ad = родитель.isAggregateDeclaration();
            if (!ad || родитель.isUnionDeclaration())
            {
                tret = Тип.tvoid;
            }
            else
            {
                tret = ad.handleType();
                assert(tret);
                tret = tret.addStorageClass(fd.класс_хранения | scx.stc);
                tret = tret.addMod(tf.mod);
            }
            tf.следщ = tret;
            if (ad && ad.isStructDeclaration())
                tf.isref = 1;
            //printf("tf = %s\n", tf.вТкст0());
        }
        else
            tf.следщ = null;
        fd.тип = tf;
        fd.тип = fd.тип.addSTC(scx.stc);
        fd.тип = fd.тип.typeSemantic(fd.место, scx);
        scx = scx.вынь();

        if (fd.тип.ty != Tfunction)
            return null;

        fd.originalType = fd.тип; // for mangling
        //printf("\t[%s] fd.тип = %s, mod = %x, ", место.вТкст0(), fd.тип.вТкст0(), fd.тип.mod);
        //printf("fd.needThis() = %d\n", fd.needThis());

        return fd;
    }

    debug (FindExistingInstance)
    {
         бцел nFound, nNotFound, nAdded, nRemoved;

        static ~this()
        {
            printf("debug (FindExistingInstance) nFound %u, nNotFound: %u, nAdded: %u, nRemoved: %u\n",
                   nFound, nNotFound, nAdded, nRemoved);
        }
    }

    /****************************************************
     * Given a new instance tithis of this TemplateDeclaration,
     * see if there already exists an instance.
     * If so, return that existing instance.
     */
    extern (D) TemplateInstance findExistingInstance(TemplateInstance tithis, Выражения* fargs)
    {
        //printf("findExistingInstance(%p)\n", tithis);
        tithis.fargs = fargs;
        auto tibox = TemplateInstanceBox(tithis);
        auto p = tibox in instances;
        debug (FindExistingInstance) ++(p ? nFound : nNotFound);
        //if (p) printf("\tfound %p\n", *p); else printf("\tnot found\n");
        return p ? *p : null;
    }

    /********************************************
     * Add instance ti to TemplateDeclaration's table of instances.
     * Return a handle we can use to later удали it if it fails instantiation.
     */
    extern (D) TemplateInstance addInstance(TemplateInstance ti)
    {
        //printf("addInstance() %p %p\n", instances, ti);
        auto tibox = TemplateInstanceBox(ti);
        instances[tibox] = ti;
        debug (FindExistingInstance) ++nAdded;
        return ti;
    }

    /*******************************************
     * Remove TemplateInstance from table of instances.
     * Input:
     *      handle returned by addInstance()
     */
    extern (D) проц removeInstance(TemplateInstance ti)
    {
        //printf("removeInstance()\n");
        auto tibox = TemplateInstanceBox(ti);
        debug (FindExistingInstance) ++nRemoved;
        instances.удали(tibox);
    }

    override TemplateDeclaration isTemplateDeclaration()
    {
        return this;
    }

    /**
     * Check if the last template параметр is a кортеж one,
     * and returns it if so, else returns `null`.
     *
     * Возвращает:
     *   The last template параметр if it's a `TemplateTupleParameter`
     */
    TemplateTupleParameter isVariadic()
    {
        т_мера dim = parameters.dim;
        if (dim == 0)
            return null;
        return (*parameters)[dim - 1].isTemplateTupleParameter();
    }

    /***********************************
     * We can overload templates.
     */
    override бул перегружаем_ли()
    {
        return да;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

 final class TypeDeduced : Тип
{
    Тип tded;
    Выражения argexps; // corresponding Выражения
    Types tparams; // tparams[i].mod

    this(Тип tt, Выражение e, Тип tparam)
    {
        super(Tnone);
        tded = tt;
        argexps.сунь(e);
        tparams.сунь(tparam);
    }

    проц update(Выражение e, Тип tparam)
    {
        argexps.сунь(e);
        tparams.сунь(tparam);
    }

    проц update(Тип tt, Выражение e, Тип tparam)
    {
        tded = tt;
        argexps.сунь(e);
        tparams.сунь(tparam);
    }

    MATCH matchAll(Тип tt)
    {
        MATCH match = MATCH.exact;
        for (т_мера j = 0; j < argexps.dim; j++)
        {
            Выражение e = argexps[j];
            assert(e);
            if (e == emptyArrayElement)
                continue;

            Тип t = tt.addMod(tparams[j].mod).substWildTo(MODFlags.const_);

            MATCH m = e.implicitConvTo(t);
            if (match > m)
                match = m;
            if (match <= MATCH.nomatch)
                break;
        }
        return match;
    }
}


/*************************************************
 * Given function arguments, figure out which template function
 * to expand, and return matching результат.
 * Параметры:
 *      m           = matching результат
 *      dstart      = the root of overloaded function templates
 *      место         = instantiation location
 *      sc          = instantiation scope
 *      tiargs      = initial list of template arguments
 *      tthis       = if !NULL, the 'this' pointer argument
 *      fargs       = arguments to function
 *      pMessage    = address to store error message, or null
 */
проц functionResolve(ref MatchAccumulator m, ДСимвол dstart, Место место, Scope* sc, Объекты* tiargs,
    Тип tthis, Выражения* fargs, сим** pMessage = null)
{
    Выражение[] fargs_ = fargs.peekSlice();
    version (none)
    {
        printf("functionResolve() dstart = %s\n", dstart.вТкст0());
        printf("    tiargs:\n");
        if (tiargs)
        {
            for (т_мера i = 0; i < tiargs.dim; i++)
            {
                КорневойОбъект arg = (*tiargs)[i];
                printf("\t%s\n", arg.вТкст0());
            }
        }
        printf("    fargs:\n");
        for (т_мера i = 0; i < (fargs ? fargs.dim : 0); i++)
        {
            Выражение arg = (*fargs)[i];
            printf("\t%s %s\n", arg.тип.вТкст0(), arg.вТкст0());
            //printf("\tty = %d\n", arg.тип.ty);
        }
        //printf("stc = %llx\n", dstart.scope.stc);
        //printf("match:t/f = %d/%d\n", ta_last, m.last);
    }

    // результатs
    цел property = 0;   // 0: uninitialized
                        // 1: seen 
                        // 2: not 
    т_мера ov_index = 0;
    TemplateDeclaration td_best;
    TemplateInstance ti_best;
    MATCH ta_last = m.last != MATCH.nomatch ? MATCH.exact : MATCH.nomatch;
    Тип tthis_best;

    цел applyFunction(FuncDeclaration fd)
    {
        // skip duplicates
        if (fd == m.lastf)
            return 0;
        // explicitly specified tiargs never match to non template function
        if (tiargs && tiargs.dim > 0)
            return 0;

        // constructors need a valid scope in order to detect semantic errors
        if (!fd.isCtorDeclaration &&
            fd.semanticRun < PASS.semanticdone)
        {
            Ungag ungag = fd.ungagSpeculative();
            fd.dsymbolSemantic(null);
        }
        if (fd.semanticRun < PASS.semanticdone)
        {
            .выведиОшибку(место, "forward reference to template `%s`", fd.вТкст0());
            return 1;
        }
        //printf("fd = %s %s, fargs = %s\n", fd.вТкст0(), fd.тип.вТкст0(), fargs.вТкст0());
        auto tf = cast(TypeFunction)fd.тип;

        цел prop = tf.isproperty ? 1 : 2;
        if (property == 0)
            property = prop;
        else if (property != prop)
            выведиОшибку(fd.место, "cannot overload both property and non-property functions");

        /* For constructors, qualifier check will be opposite direction.
         * Qualified constructor always makes qualified объект, then will be checked
         * that it is implicitly convertible to tthis.
         */
        Тип tthis_fd = fd.needThis() ? tthis : null;
        бул isCtorCall = tthis_fd && fd.isCtorDeclaration();
        if (isCtorCall)
        {
            //printf("%s tf.mod = x%x tthis_fd.mod = x%x %d\n", tf.вТкст0(),
            //        tf.mod, tthis_fd.mod, fd.isReturnIsolated());
            if (MODimplicitConv(tf.mod, tthis_fd.mod) ||
                tf.isWild() && tf.isShared() == tthis_fd.isShared() ||
                fd.isReturnIsolated())
            {
                /* && tf.isShared() == tthis_fd.isShared()*/
                // Uniquely constructed объект can ignore shared qualifier.
                // TODO: Is this appropriate?
                tthis_fd = null;
            }
            else
                return 0;   // MATCH.nomatch
        }
        /* Fix Issue 17970:
           If a struct is declared as shared the dtor is automatically
           considered to be shared, but when the struct is instantiated
           the instance is no longer considered to be shared when the
           function call matching is done. The fix makes it so that if a
           struct declaration is shared, when the destructor is called,
           the instantiated struct is also considered shared.
        */
        if (auto dt = fd.isDtorDeclaration())
        {
            auto dtmod = dt.тип.toTypeFunction();
            auto shared_dtor = dtmod.mod & MODFlags.shared_;
            auto shared_this = tthis_fd !is null ?
                tthis_fd.mod & MODFlags.shared_ : 0;
            if (shared_dtor && !shared_this)
                tthis_fd = dtmod;
            else if (shared_this && !shared_dtor && tthis_fd !is null)
                tf.mod = tthis_fd.mod;
        }
        MATCH mfa = tf.callMatch(tthis_fd, fargs_, 0, pMessage, sc);
        //printf("test1: mfa = %d\n", mfa);
        if (mfa > MATCH.nomatch)
        {
            if (mfa > m.last) goto LfIsBetter;
            if (mfa < m.last) goto LlastIsBetter;

            /* See if one of the matches overrides the other.
             */
            assert(m.lastf);
            if (m.lastf.overrides(fd)) goto LlastIsBetter;
            if (fd.overrides(m.lastf)) goto LfIsBetter;

            /* Try to disambiguate using template-style partial ordering rules.
             * In essence, if f() and g() are ambiguous, if f() can call g(),
             * but g() cannot call f(), then pick f().
             * This is because f() is "more specialized."
             */
            {
                MATCH c1 = fd.leastAsSpecialized(m.lastf);
                MATCH c2 = m.lastf.leastAsSpecialized(fd);
                //printf("c1 = %d, c2 = %d\n", c1, c2);
                if (c1 > c2) goto LfIsBetter;
                if (c1 < c2) goto LlastIsBetter;
            }

            /* The 'overrides' check above does covariant checking only
             * for virtual member functions. It should do it for all functions,
             * but in order to not risk breaking code we put it after
             * the 'leastAsSpecialized' check.
             * In the future try moving it before.
             * I.e. a not-the-same-but-covariant match is preferred,
             * as it is more restrictive.
             */
            if (!m.lastf.тип.равен(fd.тип))
            {
                //printf("cov: %d %d\n", m.lastf.тип.covariant(fd.тип), fd.тип.covariant(m.lastf.тип));
                const цел lastCovariant = m.lastf.тип.covariant(fd.тип);
                const цел firstCovariant = fd.тип.covariant(m.lastf.тип);

                if (lastCovariant == 1 || lastCovariant == 2)
                {
                    if (firstCovariant != 1 && firstCovariant != 2)
                    {
                        goto LlastIsBetter;
                    }
                }
                else if (firstCovariant == 1 || firstCovariant == 2)
                {
                    goto LfIsBetter;
                }
            }

            /* If the two functions are the same function, like:
             *    цел foo(цел);
             *    цел foo(цел x) { ... }
             * then pick the one with the body.
             *
             * If none has a body then don't care because the same
             * real function would be linked to the decl (e.g from объект файл)
             */
            if (tf.равен(m.lastf.тип) &&
                fd.класс_хранения == m.lastf.класс_хранения &&
                fd.родитель == m.lastf.родитель &&
                fd.защита == m.lastf.защита &&
                fd.компонаж == m.lastf.компонаж)
            {
                if (fd.fbody && !m.lastf.fbody)
                    goto LfIsBetter;
                if (!fd.fbody)
                    goto LlastIsBetter;
            }

            // https://issues.dlang.org/show_bug.cgi?ид=14450
            // Prefer exact qualified constructor for the creating объект тип
            if (isCtorCall && tf.mod != m.lastf.тип.mod)
            {
                if (tthis.mod == tf.mod) goto LfIsBetter;
                if (tthis.mod == m.lastf.тип.mod) goto LlastIsBetter;
            }

            m.nextf = fd;
            m.count++;
            return 0;

        LlastIsBetter:
            return 0;

        LfIsBetter:
            td_best = null;
            ti_best = null;
            ta_last = MATCH.exact;
            m.last = mfa;
            m.lastf = fd;
            tthis_best = tthis_fd;
            ov_index = 0;
            m.count = 1;
            return 0;
        }
        return 0;
    }

    цел applyTemplate(TemplateDeclaration td)
    {
        //printf("applyTemplate()\n");
        if (td.inuse)
        {
            td.выведиОшибку(место, "recursive template expansion");
            return 1;
        }
        if (td == td_best)   // skip duplicates
            return 0;

        if (!sc)
            sc = td._scope; // workaround for Тип.aliasthisOf

        if (td.semanticRun == PASS.init && td._scope)
        {
            // Try to fix forward reference. Ungag errors while doing so.
            Ungag ungag = td.ungagSpeculative();
            td.dsymbolSemantic(td._scope);
        }
        if (td.semanticRun == PASS.init)
        {
            .выведиОшибку(место, "forward reference to template `%s`", td.вТкст0());
        Lerror:
            m.lastf = null;
            m.count = 0;
            m.last = MATCH.nomatch;
            return 1;
        }
        //printf("td = %s\n", td.вТкст0());

        auto f = td.onemember ? td.onemember.isFuncDeclaration() : null;
        if (!f)
        {
            if (!tiargs)
                tiargs = new Объекты();
            auto ti = new TemplateInstance(место, td, tiargs);
            Объекты dedtypes = Объекты(td.parameters.dim);
            assert(td.semanticRun != PASS.init);
            MATCH mta = td.matchWithInstance(sc, ti, &dedtypes, fargs, 0);
            //printf("matchWithInstance = %d\n", mta);
            if (mta <= MATCH.nomatch || mta < ta_last)   // no match or less match
                return 0;

            ti.templateInstanceSemantic(sc, fargs);
            if (!ti.inst)               // if template failed to expand
                return 0;

            ДСимвол s = ti.inst.toAlias();
            FuncDeclaration fd;
            if (auto tdx = s.isTemplateDeclaration())
            {
                Объекты dedtypesX;      // empty tiargs

                // https://issues.dlang.org/show_bug.cgi?ид=11553
                // Check for recursive instantiation of tdx.
                for (TemplatePrevious* p = tdx.previous; p; p = p.prev)
                {
                    if (arrayObjectMatch(p.dedargs, &dedtypesX))
                    {
                        //printf("recursive, no match p.sc=%p %p %s\n", p.sc, this, this.вТкст0());
                        /* It must be a subscope of p.sc, other scope chains are not recursive
                         * instantiations.
                         */
                        for (Scope* scx = sc; scx; scx = scx.enclosing)
                        {
                            if (scx == p.sc)
                            {
                                выведиОшибку(место, "recursive template expansion while looking for `%s.%s`", ti.вТкст0(), tdx.вТкст0());
                                goto Lerror;
                            }
                        }
                    }
                    /* BUG: should also check for ref param differences
                     */
                }

                TemplatePrevious pr;
                pr.prev = tdx.previous;
                pr.sc = sc;
                pr.dedargs = &dedtypesX;
                tdx.previous = &pr;             // add this to threaded list

                fd = resolveFuncCall(место, sc, s, null, tthis, fargs, FuncResolveFlag.quiet);

                tdx.previous = pr.prev;         // unlink from threaded list
            }
            else if (s.isFuncDeclaration())
            {
                fd = resolveFuncCall(место, sc, s, null, tthis, fargs, FuncResolveFlag.quiet);
            }
            else
                goto Lerror;

            if (!fd)
                return 0;

            if (fd.тип.ty != Tfunction)
            {
                m.lastf = fd;   // to propagate "error match"
                m.count = 1;
                m.last = MATCH.nomatch;
                return 1;
            }

            Тип tthis_fd = fd.needThis() && !fd.isCtorDeclaration() ? tthis : null;

            auto tf = cast(TypeFunction)fd.тип;
            MATCH mfa = tf.callMatch(tthis_fd, fargs_, 0, null, sc);
            if (mfa < m.last)
                return 0;

            if (mta < ta_last) goto Ltd_best2;
            if (mta > ta_last) goto Ltd2;

            if (mfa < m.last) goto Ltd_best2;
            if (mfa > m.last) goto Ltd2;

            // td_best and td are ambiguous
            //printf("Lambig2\n");
            m.nextf = fd;
            m.count++;
            return 0;

        Ltd_best2:
            return 0;

        Ltd2:
            // td is the new best match
            assert(td._scope);
            td_best = td;
            ti_best = null;
            property = 0;   // (backward compatibility)
            ta_last = mta;
            m.last = mfa;
            m.lastf = fd;
            tthis_best = tthis_fd;
            ov_index = 0;
            m.nextf = null;
            m.count = 1;
            return 0;
        }

        //printf("td = %s\n", td.вТкст0());
        for (т_мера ovi = 0; f; f = f.overnext0, ovi++)
        {
            if (f.тип.ty != Tfunction || f.errors)
                goto Lerror;

            /* This is a 'dummy' instance to evaluate constraint properly.
             */
            auto ti = new TemplateInstance(место, td, tiargs);
            ti.родитель = td.родитель;  // Maybe calculating valid 'enclosing' is unnecessary.

            auto fd = f;
            цел x = td.deduceFunctionTemplateMatch(ti, sc, fd, tthis, fargs);
            MATCH mta = cast(MATCH)(x >> 4);
            MATCH mfa = cast(MATCH)(x & 0xF);
            //printf("match:t/f = %d/%d\n", mta, mfa);
            if (!fd || mfa == MATCH.nomatch)
                continue;

            Тип tthis_fd = fd.needThis() ? tthis : null;

            бул isCtorCall = tthis_fd && fd.isCtorDeclaration();
            if (isCtorCall)
            {
                // Constructor call requires additional check.

                auto tf = cast(TypeFunction)fd.тип;
                assert(tf.следщ);
                if (MODimplicitConv(tf.mod, tthis_fd.mod) ||
                    tf.isWild() && tf.isShared() == tthis_fd.isShared() ||
                    fd.isReturnIsolated())
                {
                    tthis_fd = null;
                }
                else
                    continue;   // MATCH.nomatch
            }

            if (mta < ta_last) goto Ltd_best;
            if (mta > ta_last) goto Ltd;

            if (mfa < m.last) goto Ltd_best;
            if (mfa > m.last) goto Ltd;

            if (td_best)
            {
                // Disambiguate by picking the most specialized TemplateDeclaration
                MATCH c1 = td.leastAsSpecialized(sc, td_best, fargs);
                MATCH c2 = td_best.leastAsSpecialized(sc, td, fargs);
                //printf("1: c1 = %d, c2 = %d\n", c1, c2);
                if (c1 > c2) goto Ltd;
                if (c1 < c2) goto Ltd_best;
            }
            assert(fd && m.lastf);
            {
                // Disambiguate by tf.callMatch
                auto tf1 = cast(TypeFunction)fd.тип;
                assert(tf1.ty == Tfunction);
                auto tf2 = cast(TypeFunction)m.lastf.тип;
                assert(tf2.ty == Tfunction);
                MATCH c1 = tf1.callMatch(tthis_fd, fargs_, 0, null, sc);
                MATCH c2 = tf2.callMatch(tthis_best, fargs_, 0, null, sc);
                //printf("2: c1 = %d, c2 = %d\n", c1, c2);
                if (c1 > c2) goto Ltd;
                if (c1 < c2) goto Ltd_best;
            }
            {
                // Disambiguate by picking the most specialized FunctionDeclaration
                MATCH c1 = fd.leastAsSpecialized(m.lastf);
                MATCH c2 = m.lastf.leastAsSpecialized(fd);
                //printf("3: c1 = %d, c2 = %d\n", c1, c2);
                if (c1 > c2) goto Ltd;
                if (c1 < c2) goto Ltd_best;
            }

            // https://issues.dlang.org/show_bug.cgi?ид=14450
            // Prefer exact qualified constructor for the creating объект тип
            if (isCtorCall && fd.тип.mod != m.lastf.тип.mod)
            {
                if (tthis.mod == fd.тип.mod) goto Ltd;
                if (tthis.mod == m.lastf.тип.mod) goto Ltd_best;
            }

            m.nextf = fd;
            m.count++;
            continue;

        Ltd_best:           // td_best is the best match so far
            //printf("Ltd_best\n");
            continue;

        Ltd:                // td is the new best match
            //printf("Ltd\n");
            assert(td._scope);
            td_best = td;
            ti_best = ti;
            property = 0;   // (backward compatibility)
            ta_last = mta;
            m.last = mfa;
            m.lastf = fd;
            tthis_best = tthis_fd;
            ov_index = ovi;
            m.nextf = null;
            m.count = 1;
            continue;
        }
        return 0;
    }

    auto td = dstart.isTemplateDeclaration();
    if (td && td.funcroot)
        dstart = td.funcroot;
    overloadApply(dstart, (ДСимвол s)
    {
        if (s.errors)
            return 0;
        if (auto fd = s.isFuncDeclaration())
            return applyFunction(fd);
        if (auto td = s.isTemplateDeclaration())
            return applyTemplate(td);
        return 0;
    }, sc);

    //printf("td_best = %p, m.lastf = %p\n", td_best, m.lastf);
    if (td_best && ti_best && m.count == 1)
    {
        // Matches to template function
        assert(td_best.onemember && td_best.onemember.isFuncDeclaration());
        /* The best match is td_best with arguments tdargs.
         * Now instantiate the template.
         */
        assert(td_best._scope);
        if (!sc)
            sc = td_best._scope; // workaround for Тип.aliasthisOf

        auto ti = new TemplateInstance(место, td_best, ti_best.tiargs);
        ti.templateInstanceSemantic(sc, fargs);

        m.lastf = ti.toAlias().isFuncDeclaration();
        if (!m.lastf)
            goto Lnomatch;
        if (ti.errors)
        {
        Lerror:
            m.count = 1;
            assert(m.lastf);
            m.last = MATCH.nomatch;
            return;
        }

        // look forward instantiated overload function
        // ДСимвол.oneMembers is alredy called in TemplateInstance.semantic.
        // it has filled overnext0d
        while (ov_index--)
        {
            m.lastf = m.lastf.overnext0;
            assert(m.lastf);
        }

        tthis_best = m.lastf.needThis() && !m.lastf.isCtorDeclaration() ? tthis : null;

        auto tf = cast(TypeFunction)m.lastf.тип;
        if (tf.ty == Terror)
            goto Lerror;
        assert(tf.ty == Tfunction);
        if (!tf.callMatch(tthis_best, fargs_, 0, null, sc))
            goto Lnomatch;

        /* As https://issues.dlang.org/show_bug.cgi?ид=3682 shows,
         * a template instance can be matched while instantiating
         * that same template. Thus, the function тип can be incomplete. Complete it.
         *
         * https://issues.dlang.org/show_bug.cgi?ид=9208
         * For auto function, completion should be deferred to the end of
         * its semantic3. Should not complete it in here.
         */
        if (tf.следщ && !m.lastf.inferRetType)
        {
            m.lastf.тип = tf.typeSemantic(место, sc);
        }
    }
    else if (m.lastf)
    {
        // Matches to non template function,
        // or found matches were ambiguous.
        assert(m.count >= 1);
    }
    else
    {
    Lnomatch:
        m.count = 0;
        m.lastf = null;
        m.last = MATCH.nomatch;
    }
}

/* ======================== Тип ============================================ */

/****
 * Given an идентификатор, figure out which ПараметрШаблона2 it is.
 * Return IDX_NOTFOUND if not found.
 */
private т_мера templateIdentifierLookup(Идентификатор2 ид, ПараметрыШаблона* parameters)
{
    for (т_мера i = 0; i < parameters.dim; i++)
    {
        ПараметрШаблона2 tp = (*parameters)[i];
        if (tp.идент.равен(ид))
            return i;
    }
    return IDX_NOTFOUND;
}

private т_мера templateParameterLookup(Тип tparam, ПараметрыШаблона* parameters)
{
    if (tparam.ty == Tident)
    {
        TypeIdentifier tident = cast(TypeIdentifier)tparam;
        //printf("\ttident = '%s'\n", tident.вТкст0());
        return templateIdentifierLookup(tident.идент, parameters);
    }
    return IDX_NOTFOUND;
}

private ббайт deduceWildHelper(Тип t, Тип* at, Тип tparam)
{
    if ((tparam.mod & MODFlags.wild) == 0)
        return 0;

    *at = null;

    Z X(T, U)(T U, U T)
    {
        return (U << 4) | T;
    }

    switch (X(tparam.mod, t.mod))
    {
    case X(MODFlags.wild, 0):
    case X(MODFlags.wild, MODFlags.const_):
    case X(MODFlags.wild, MODFlags.shared_):
    case X(MODFlags.wild, MODFlags.shared_ | MODFlags.const_):
    case X(MODFlags.wild, MODFlags.immutable_):
    case X(MODFlags.wildconst, 0):
    case X(MODFlags.wildconst, MODFlags.const_):
    case X(MODFlags.wildconst, MODFlags.shared_):
    case X(MODFlags.wildconst, MODFlags.shared_ | MODFlags.const_):
    case X(MODFlags.wildconst, MODFlags.immutable_):
    case X(MODFlags.shared_ | MODFlags.wild, MODFlags.shared_):
    case X(MODFlags.shared_ | MODFlags.wild, MODFlags.shared_ | MODFlags.const_):
    case X(MODFlags.shared_ | MODFlags.wild, MODFlags.immutable_):
    case X(MODFlags.shared_ | MODFlags.wildconst, MODFlags.shared_):
    case X(MODFlags.shared_ | MODFlags.wildconst, MODFlags.shared_ | MODFlags.const_):
    case X(MODFlags.shared_ | MODFlags.wildconst, MODFlags.immutable_):
        {
            ббайт wm = (t.mod & ~MODFlags.shared_);
            if (wm == 0)
                wm = MODFlags.mutable;
            ббайт m = (t.mod & (MODFlags.const_ | MODFlags.immutable_)) | (tparam.mod & t.mod & MODFlags.shared_);
            *at = t.unqualify(m);
            return wm;
        }
    case X(MODFlags.wild, MODFlags.wild):
    case X(MODFlags.wild, MODFlags.wildconst):
    case X(MODFlags.wild, MODFlags.shared_ | MODFlags.wild):
    case X(MODFlags.wild, MODFlags.shared_ | MODFlags.wildconst):
    case X(MODFlags.wildconst, MODFlags.wild):
    case X(MODFlags.wildconst, MODFlags.wildconst):
    case X(MODFlags.wildconst, MODFlags.shared_ | MODFlags.wild):
    case X(MODFlags.wildconst, MODFlags.shared_ | MODFlags.wildconst):
    case X(MODFlags.shared_ | MODFlags.wild, MODFlags.shared_ | MODFlags.wild):
    case X(MODFlags.shared_ | MODFlags.wild, MODFlags.shared_ | MODFlags.wildconst):
    case X(MODFlags.shared_ | MODFlags.wildconst, MODFlags.shared_ | MODFlags.wild):
    case X(MODFlags.shared_ | MODFlags.wildconst, MODFlags.shared_ | MODFlags.wildconst):
        {
            *at = t.unqualify(tparam.mod & t.mod);
            return MODFlags.wild;
        }
    default:
        return 0;
    }
}

/**
 * Возвращает the common тип of the 2 types.
 */
private Тип rawTypeMerge(Тип t1, Тип t2)
{
    if (t1.равен(t2))
        return t1;
    if (t1.equivalent(t2))
        return t1.castMod(MODmerge(t1.mod, t2.mod));

    auto t1b = t1.toBasetype();
    auto t2b = t2.toBasetype();
    if (t1b.равен(t2b))
        return t1b;
    if (t1b.equivalent(t2b))
        return t1b.castMod(MODmerge(t1b.mod, t2b.mod));

    auto ty = cast(TY)impcnvрезультат[t1b.ty][t2b.ty];
    if (ty != Terror)
        return Тип.basic[ty];

    return null;
}

private MATCH deduceTypeHelper(Тип t, Тип* at, Тип tparam)
{
    // 9*9 == 81 cases

    Z X(T, U)(T U, U T)
    {
        return (U << 4) | T;
    }

    switch (X(tparam.mod, t.mod))
    {
    case X(0, 0):
    case X(0, MODFlags.const_):
    case X(0, MODFlags.wild):
    case X(0, MODFlags.wildconst):
    case X(0, MODFlags.shared_):
    case X(0, MODFlags.shared_ | MODFlags.const_):
    case X(0, MODFlags.shared_ | MODFlags.wild):
    case X(0, MODFlags.shared_ | MODFlags.wildconst):
    case X(0, MODFlags.immutable_):
        // foo(U)                       T                       => T
        // foo(U)                       const(T)                => const(T)
        // foo(U)                       inout(T)                => inout(T)
        // foo(U)                       inout(const(T))         => inout(const(T))
        // foo(U)                       shared(T)               => shared(T)
        // foo(U)                       shared(const(T))        => shared(const(T))
        // foo(U)                       shared(inout(T))        => shared(inout(T))
        // foo(U)                       shared(inout(const(T))) => shared(inout(const(T)))
        // foo(U)                       const(T)            => const(T)
        {
            *at = t;
            return MATCH.exact;
        }
    case X(MODFlags.const_, MODFlags.const_):
    case X(MODFlags.wild, MODFlags.wild):
    case X(MODFlags.wildconst, MODFlags.wildconst):
    case X(MODFlags.shared_, MODFlags.shared_):
    case X(MODFlags.shared_ | MODFlags.const_, MODFlags.shared_ | MODFlags.const_):
    case X(MODFlags.shared_ | MODFlags.wild, MODFlags.shared_ | MODFlags.wild):
    case X(MODFlags.shared_ | MODFlags.wildconst, MODFlags.shared_ | MODFlags.wildconst):
    case X(MODFlags.immutable_, MODFlags.immutable_):
        // foo(const(U))                const(T)                => T
        // foo(inout(U))                inout(T)                => T
        // foo(inout(const(U)))         inout(const(T))         => T
        // foo(shared(U))               shared(T)               => T
        // foo(shared(const(U)))        shared(const(T))        => T
        // foo(shared(inout(U)))        shared(inout(T))        => T
        // foo(shared(inout(const(U)))) shared(inout(const(T))) => T
        // foo(const(U))            const(T)            => T
        {
            *at = t.mutableOf().unSharedOf();
            return MATCH.exact;
        }
    case X(MODFlags.const_, MODFlags.shared_ | MODFlags.const_):
    case X(MODFlags.wild, MODFlags.shared_ | MODFlags.wild):
    case X(MODFlags.wildconst, MODFlags.shared_ | MODFlags.wildconst):
        // foo(const(U))                shared(const(T))        => shared(T)
        // foo(inout(U))                shared(inout(T))        => shared(T)
        // foo(inout(const(U)))         shared(inout(const(T))) => shared(T)
        {
            *at = t.mutableOf();
            return MATCH.exact;
        }
    case X(MODFlags.const_, 0):
    case X(MODFlags.const_, MODFlags.wild):
    case X(MODFlags.const_, MODFlags.wildconst):
    case X(MODFlags.const_, MODFlags.shared_ | MODFlags.wild):
    case X(MODFlags.const_, MODFlags.shared_ | MODFlags.wildconst):
    case X(MODFlags.const_, MODFlags.immutable_):
    case X(MODFlags.shared_ | MODFlags.const_, MODFlags.immutable_):
        // foo(const(U))                T                       => T
        // foo(const(U))                inout(T)                => T
        // foo(const(U))                inout(const(T))         => T
        // foo(const(U))                shared(inout(T))        => shared(T)
        // foo(const(U))                shared(inout(const(T))) => shared(T)
        // foo(const(U))                const(T)            => T
        // foo(shared(const(U)))        const(T)            => T
        {
            *at = t.mutableOf();
            return MATCH.constant;
        }
    case X(MODFlags.const_, MODFlags.shared_):
        // foo(const(U))                shared(T)               => shared(T)
        {
            *at = t;
            return MATCH.constant;
        }
    case X(MODFlags.shared_, MODFlags.shared_ | MODFlags.const_):
    case X(MODFlags.shared_, MODFlags.shared_ | MODFlags.wild):
    case X(MODFlags.shared_, MODFlags.shared_ | MODFlags.wildconst):
        // foo(shared(U))               shared(const(T))        => const(T)
        // foo(shared(U))               shared(inout(T))        => inout(T)
        // foo(shared(U))               shared(inout(const(T))) => inout(const(T))
        {
            *at = t.unSharedOf();
            return MATCH.exact;
        }
    case X(MODFlags.shared_ | MODFlags.const_, MODFlags.shared_):
        // foo(shared(const(U)))        shared(T)               => T
        {
            *at = t.unSharedOf();
            return MATCH.constant;
        }
    case X(MODFlags.wildconst, MODFlags.immutable_):
    case X(MODFlags.shared_ | MODFlags.const_, MODFlags.shared_ | MODFlags.wildconst):
    case X(MODFlags.shared_ | MODFlags.wildconst, MODFlags.immutable_):
    case X(MODFlags.shared_ | MODFlags.wildconst, MODFlags.shared_ | MODFlags.wild):
        // foo(inout(const(U)))         const(T)            => T
        // foo(shared(const(U)))        shared(inout(const(T))) => T
        // foo(shared(inout(const(U))))(T)            => T
        // foo(shared(inout(const(U)))) shared(inout(T))        => T
        {
            *at = t.unSharedOf().mutableOf();
            return MATCH.constant;
        }
    case X(MODFlags.shared_ | MODFlags.const_, MODFlags.shared_ | MODFlags.wild):
        // foo(shared(const(U)))        shared(inout(T))        => T
        {
            *at = t.unSharedOf().mutableOf();
            return MATCH.constant;
        }
    case X(MODFlags.wild, 0):
    case X(MODFlags.wild, MODFlags.const_):
    case X(MODFlags.wild, MODFlags.wildconst):
    case X(MODFlags.wild, MODFlags.immutable_):
    case X(MODFlags.wild, MODFlags.shared_):
    case X(MODFlags.wild, MODFlags.shared_ | MODFlags.const_):
    case X(MODFlags.wild, MODFlags.shared_ | MODFlags.wildconst):
    case X(MODFlags.wildconst, 0):
    case X(MODFlags.wildconst, MODFlags.const_):
    case X(MODFlags.wildconst, MODFlags.wild):
    case X(MODFlags.wildconst, MODFlags.shared_):
    case X(MODFlags.wildconst, MODFlags.shared_ | MODFlags.const_):
    case X(MODFlags.wildconst, MODFlags.shared_ | MODFlags.wild):
    case X(MODFlags.shared_, 0):
    case X(MODFlags.shared_, MODFlags.const_):
    case X(MODFlags.shared_, MODFlags.wild):
    case X(MODFlags.shared_, MODFlags.wildconst):
    case X(MODFlags.shared_, MODFlags.immutable_):
    case X(MODFlags.shared_ | MODFlags.const_, 0):
    case X(MODFlags.shared_ | MODFlags.const_, MODFlags.const_):
    case X(MODFlags.shared_ | MODFlags.const_, MODFlags.wild):
    case X(MODFlags.shared_ | MODFlags.const_, MODFlags.wildconst):
    case X(MODFlags.shared_ | MODFlags.wild, 0):
    case X(MODFlags.shared_ | MODFlags.wild, MODFlags.const_):
    case X(MODFlags.shared_ | MODFlags.wild, MODFlags.wild):
    case X(MODFlags.shared_ | MODFlags.wild, MODFlags.wildconst):
    case X(MODFlags.shared_ | MODFlags.wild, MODFlags.immutable_):
    case X(MODFlags.shared_ | MODFlags.wild, MODFlags.shared_):
    case X(MODFlags.shared_ | MODFlags.wild, MODFlags.shared_ | MODFlags.const_):
    case X(MODFlags.shared_ | MODFlags.wild, MODFlags.shared_ | MODFlags.wildconst):
    case X(MODFlags.shared_ | MODFlags.wildconst, 0):
    case X(MODFlags.shared_ | MODFlags.wildconst, MODFlags.const_):
    case X(MODFlags.shared_ | MODFlags.wildconst, MODFlags.wild):
    case X(MODFlags.shared_ | MODFlags.wildconst, MODFlags.wildconst):
    case X(MODFlags.shared_ | MODFlags.wildconst, MODFlags.shared_):
    case X(MODFlags.shared_ | MODFlags.wildconst, MODFlags.shared_ | MODFlags.const_):
    case X(MODFlags.immutable_, 0):
    case X(MODFlags.immutable_, MODFlags.const_):
    case X(MODFlags.immutable_, MODFlags.wild):
    case X(MODFlags.immutable_, MODFlags.wildconst):
    case X(MODFlags.immutable_, MODFlags.shared_):
    case X(MODFlags.immutable_, MODFlags.shared_ | MODFlags.const_):
    case X(MODFlags.immutable_, MODFlags.shared_ | MODFlags.wild):
    case X(MODFlags.immutable_, MODFlags.shared_ | MODFlags.wildconst):
        // foo(inout(U))                T                       => nomatch
        // foo(inout(U))                const(T)                => nomatch
        // foo(inout(U))                inout(const(T))         => nomatch
        // foo(inout(U))                const(T)            => nomatch
        // foo(inout(U))                shared(T)               => nomatch
        // foo(inout(U))                shared(const(T))        => nomatch
        // foo(inout(U))                shared(inout(const(T))) => nomatch
        // foo(inout(const(U)))         T                       => nomatch
        // foo(inout(const(U)))         const(T)                => nomatch
        // foo(inout(const(U)))         inout(T)                => nomatch
        // foo(inout(const(U)))         shared(T)               => nomatch
        // foo(inout(const(U)))         shared(const(T))        => nomatch
        // foo(inout(const(U)))         shared(inout(T))        => nomatch
        // foo(shared(U))               T                       => nomatch
        // foo(shared(U))               const(T)                => nomatch
        // foo(shared(U))               inout(T)                => nomatch
        // foo(shared(U))               inout(const(T))         => nomatch
        // foo(shared(U))               const(T)            => nomatch
        // foo(shared(const(U)))        T                       => nomatch
        // foo(shared(const(U)))        const(T)                => nomatch
        // foo(shared(const(U)))        inout(T)                => nomatch
        // foo(shared(const(U)))        inout(const(T))         => nomatch
        // foo(shared(inout(U)))        T                       => nomatch
        // foo(shared(inout(U)))        const(T)                => nomatch
        // foo(shared(inout(U)))        inout(T)                => nomatch
        // foo(shared(inout(U)))        inout(const(T))         => nomatch
        // foo(shared(inout(U)))        const(T)            => nomatch
        // foo(shared(inout(U)))        shared(T)               => nomatch
        // foo(shared(inout(U)))        shared(const(T))        => nomatch
        // foo(shared(inout(U)))        shared(inout(const(T))) => nomatch
        // foo(shared(inout(const(U)))) T                       => nomatch
        // foo(shared(inout(const(U))))(T)                => nomatch
        // foo(shared(inout(const(U)))) inout(T)                => nomatch
        // foo(shared(inout(const(U)))) inout(const(T))         => nomatch
        // foo(shared(inout(const(U)))) shared(T)               => nomatch
        // foo(shared(inout(const(U)))) shared(const(T))        => nomatch
        // foo(const(U))            T                       => nomatch
        // foo(const(U))            const(T)                => nomatch
        // foo(const(U))            inout(T)                => nomatch
        // foo(const(U))            inout(const(T))         => nomatch
        // foo(const(U))            shared(T)               => nomatch
        // foo(const(U))            shared(const(T))        => nomatch
        // foo(const(U))            shared(inout(T))        => nomatch
        // foo(const(U))            shared(inout(const(T))) => nomatch
        return MATCH.nomatch;

    default:
        assert(0);
    }
}

 Выражение emptyArrayElement = null;

/* These form the heart of template argument deduction.
 * Given 'this' being the тип argument to the template instance,
 * it is matched against the template declaration параметр specialization
 * 'tparam' to determine the тип to be используется for the параметр.
 * Example:
 *      template Foo(T:T*)      // template declaration
 *      Foo!(цел*)              // template instantiation
 * Input:
 *      this = цел*
 *      tparam = T*
 *      parameters = [ T:T* ]   // МассивДРК of ПараметрШаблона2's
 * Output:
 *      dedtypes = [ цел ]      // МассивДРК of Выражение/Тип's
 */
MATCH deduceType(КорневойОбъект o, Scope* sc, Тип tparam, ПараметрыШаблона* parameters, Объекты* dedtypes, бцел* wm = null, т_мера inferStart = 0, бул ignoreAliasThis = нет)
{
     final class DeduceType : Визитор2
    {
        alias Визитор2.посети посети;
    public:
        Scope* sc;
        Тип tparam;
        ПараметрыШаблона* parameters;
        Объекты* dedtypes;
        бцел* wm;
        т_мера inferStart;
        бул ignoreAliasThis;
        MATCH результат;

        this(Scope* sc, Тип tparam, ПараметрыШаблона* parameters, Объекты* dedtypes, бцел* wm, т_мера inferStart, бул ignoreAliasThis)
        {
            this.sc = sc;
            this.tparam = tparam;
            this.parameters = parameters;
            this.dedtypes = dedtypes;
            this.wm = wm;
            this.inferStart = inferStart;
            this.ignoreAliasThis = ignoreAliasThis;
            результат = MATCH.nomatch;
        }

        override проц посети(Тип t)
        {
            if (!tparam)
                goto Lnomatch;

            if (t == tparam)
                goto Lexact;

            if (tparam.ty == Tident)
            {
                // Determine which параметр tparam is
                т_мера i = templateParameterLookup(tparam, parameters);
                if (i == IDX_NOTFOUND)
                {
                    if (!sc)
                        goto Lnomatch;

                    /* Need a место to go with the semantic routine.
                     */
                    Место место;
                    if (parameters.dim)
                    {
                        ПараметрШаблона2 tp = (*parameters)[0];
                        место = tp.место;
                    }

                    /* BUG: what if tparam is a template instance, that
                     * has as an argument another Tident?
                     */
                    tparam = tparam.typeSemantic(место, sc);
                    assert(tparam.ty != Tident);
                    результат = deduceType(t, sc, tparam, parameters, dedtypes, wm);
                    return;
                }

                ПараметрШаблона2 tp = (*parameters)[i];

                TypeIdentifier tident = cast(TypeIdentifier)tparam;
                if (tident.idents.dim > 0)
                {
                    //printf("matching %s to %s\n", tparam.вТкст0(), t.вТкст0());
                    ДСимвол s = t.toDsymbol(sc);
                    for (т_мера j = tident.idents.dim; j-- > 0;)
                    {
                        КорневойОбъект ид = tident.idents[j];
                        if (ид.динкаст() == ДИНКАСТ.идентификатор)
                        {
                            if (!s || !s.родитель)
                                goto Lnomatch;
                            ДСимвол s2 = s.родитель.search(Место.initial, cast(Идентификатор2)ид);
                            if (!s2)
                                goto Lnomatch;
                            s2 = s2.toAlias();
                            //printf("[%d] s = %s %s, s2 = %s %s\n", j, s.вид(), s.вТкст0(), s2.вид(), s2.вТкст0());
                            if (s != s2)
                            {
                                if (Тип tx = s2.getType())
                                {
                                    if (s != tx.toDsymbol(sc))
                                        goto Lnomatch;
                                }
                                else
                                    goto Lnomatch;
                            }
                            s = s.родитель;
                        }
                        else
                            goto Lnomatch;
                    }
                    //printf("[e] s = %s\n", s?s.вТкст0():"(null)");
                    if (tp.isTemplateTypeParameter())
                    {
                        Тип tt = s.getType();
                        if (!tt)
                            goto Lnomatch;
                        Тип at = cast(Тип)(*dedtypes)[i];
                        if (at && at.ty == Tnone)
                            at = (cast(TypeDeduced)at).tded;
                        if (!at || tt.равен(at))
                        {
                            (*dedtypes)[i] = tt;
                            goto Lexact;
                        }
                    }
                    if (tp.isTemplateAliasParameter())
                    {
                        ДСимвол s2 = cast(ДСимвол)(*dedtypes)[i];
                        if (!s2 || s == s2)
                        {
                            (*dedtypes)[i] = s;
                            goto Lexact;
                        }
                    }
                    goto Lnomatch;
                }

                // Found the corresponding параметр tp
                if (!tp.isTemplateTypeParameter())
                    goto Lnomatch;
                Тип at = cast(Тип)(*dedtypes)[i];
                Тип tt;
                if (ббайт wx = wm ? deduceWildHelper(t, &tt, tparam) : 0)
                {
                    // тип vs (none)
                    if (!at)
                    {
                        (*dedtypes)[i] = tt;
                        *wm |= wx;
                        результат = MATCH.constant;
                        return;
                    }

                    // тип vs Выражения
                    if (at.ty == Tnone)
                    {
                        TypeDeduced xt = cast(TypeDeduced)at;
                        результат = xt.matchAll(tt);
                        if (результат > MATCH.nomatch)
                        {
                            (*dedtypes)[i] = tt;
                            if (результат > MATCH.constant)
                                результат = MATCH.constant; // limit уровень for inout matches
                        }
                        return;
                    }

                    // тип vs тип
                    if (tt.равен(at))
                    {
                        (*dedtypes)[i] = tt; // Prefer current тип match
                        goto Lconst;
                    }
                    if (tt.implicitConvTo(at.constOf()))
                    {
                        (*dedtypes)[i] = at.constOf().mutableOf();
                        *wm |= MODFlags.const_;
                        goto Lconst;
                    }
                    if (at.implicitConvTo(tt.constOf()))
                    {
                        (*dedtypes)[i] = tt.constOf().mutableOf();
                        *wm |= MODFlags.const_;
                        goto Lconst;
                    }
                    goto Lnomatch;
                }
                else if (MATCH m = deduceTypeHelper(t, &tt, tparam))
                {
                    // тип vs (none)
                    if (!at)
                    {
                        (*dedtypes)[i] = tt;
                        результат = m;
                        return;
                    }

                    // тип vs Выражения
                    if (at.ty == Tnone)
                    {
                        TypeDeduced xt = cast(TypeDeduced)at;
                        результат = xt.matchAll(tt);
                        if (результат > MATCH.nomatch)
                        {
                            (*dedtypes)[i] = tt;
                        }
                        return;
                    }

                    // тип vs тип
                    if (tt.равен(at))
                    {
                        goto Lexact;
                    }
                    if (tt.ty == Tclass && at.ty == Tclass)
                    {
                        результат = tt.implicitConvTo(at);
                        return;
                    }
                    if (tt.ty == Tsarray && at.ty == Tarray && tt.nextOf().implicitConvTo(at.nextOf()) >= MATCH.constant)
                    {
                        goto Lexact;
                    }
                }
                goto Lnomatch;
            }

            if (tparam.ty == Ttypeof)
            {
                /* Need a место to go with the semantic routine.
                 */
                Место место;
                if (parameters.dim)
                {
                    ПараметрШаблона2 tp = (*parameters)[0];
                    место = tp.место;
                }

                tparam = tparam.typeSemantic(место, sc);
            }
            if (t.ty != tparam.ty)
            {
                if (ДСимвол sym = t.toDsymbol(sc))
                {
                    if (sym.isforwardRef() && !tparam.deco)
                        goto Lnomatch;
                }

                MATCH m = t.implicitConvTo(tparam);
                if (m == MATCH.nomatch && !ignoreAliasThis)
                {
                    if (t.ty == Tclass)
                    {
                        TypeClass tc = cast(TypeClass)t;
                        if (tc.sym.aliasthis && !(tc.att & AliasThisRec.tracingDT))
                        {
                            if (auto ato = t.aliasthisOf())
                            {
                                tc.att = cast(AliasThisRec)(tc.att | AliasThisRec.tracingDT);
                                m = deduceType(ato, sc, tparam, parameters, dedtypes, wm);
                                tc.att = cast(AliasThisRec)(tc.att & ~AliasThisRec.tracingDT);
                            }
                        }
                    }
                    else if (t.ty == Tstruct)
                    {
                        TypeStruct ts = cast(TypeStruct)t;
                        if (ts.sym.aliasthis && !(ts.att & AliasThisRec.tracingDT))
                        {
                            if (auto ato = t.aliasthisOf())
                            {
                                ts.att = cast(AliasThisRec)(ts.att | AliasThisRec.tracingDT);
                                m = deduceType(ato, sc, tparam, parameters, dedtypes, wm);
                                ts.att = cast(AliasThisRec)(ts.att & ~AliasThisRec.tracingDT);
                            }
                        }
                    }
                }
                результат = m;
                return;
            }

            if (t.nextOf())
            {
                if (tparam.deco && !tparam.hasWild())
                {
                    результат = t.implicitConvTo(tparam);
                    return;
                }

                Тип tpn = tparam.nextOf();
                if (wm && t.ty == Taarray && tparam.isWild())
                {
                    // https://issues.dlang.org/show_bug.cgi?ид=12403
                    // In IFTI, stop inout matching on transitive part of AA types.
                    tpn = tpn.substWildTo(MODFlags.mutable);
                }

                результат = deduceType(t.nextOf(), sc, tpn, parameters, dedtypes, wm);
                return;
            }

        Lexact:
            результат = MATCH.exact;
            return;

        Lnomatch:
            результат = MATCH.nomatch;
            return;

        Lconst:
            результат = MATCH.constant;
        }

        override проц посети(TypeVector t)
        {
            if (tparam.ty == Tvector)
            {
                TypeVector tp = cast(TypeVector)tparam;
                результат = deduceType(t.basetype, sc, tp.basetype, parameters, dedtypes, wm);
                return;
            }
            посети(cast(Тип)t);
        }

        override проц посети(TypeDArray t)
        {
            посети(cast(Тип)t);
        }

        override проц посети(TypeSArray t)
        {
            // Extra check that массив dimensions must match
            if (tparam)
            {
                if (tparam.ty == Tarray)
                {
                    MATCH m = deduceType(t.следщ, sc, tparam.nextOf(), parameters, dedtypes, wm);
                    результат = (m >= MATCH.constant) ? MATCH.convert : MATCH.nomatch;
                    return;
                }

                ПараметрШаблона2 tp = null;
                Выражение edim = null;
                т_мера i;
                if (tparam.ty == Tsarray)
                {
                    TypeSArray tsa = cast(TypeSArray)tparam;
                    if (tsa.dim.op == ТОК2.variable && (cast(VarExp)tsa.dim).var.класс_хранения & STC.шаблонпараметр)
                    {
                        Идентификатор2 ид = (cast(VarExp)tsa.dim).var.идент;
                        i = templateIdentifierLookup(ид, parameters);
                        assert(i != IDX_NOTFOUND);
                        tp = (*parameters)[i];
                    }
                    else
                        edim = tsa.dim;
                }
                else if (tparam.ty == Taarray)
                {
                    TypeAArray taa = cast(TypeAArray)tparam;
                    i = templateParameterLookup(taa.index, parameters);
                    if (i != IDX_NOTFOUND)
                        tp = (*parameters)[i];
                    else
                    {
                        Выражение e;
                        Тип tx;
                        ДСимвол s;
                        taa.index.resolve(Место.initial, sc, &e, &tx, &s);
                        edim = s ? дайЗначение(s) : дайЗначение(e);
                    }
                }
                if (tp && tp.matchArg(sc, t.dim, i, parameters, dedtypes, null) || edim && edim.toInteger() == t.dim.toInteger())
                {
                    результат = deduceType(t.следщ, sc, tparam.nextOf(), parameters, dedtypes, wm);
                    return;
                }
            }
            посети(cast(Тип)t);
        }

        override проц посети(TypeAArray t)
        {
            // Extra check that index тип must match
            if (tparam && tparam.ty == Taarray)
            {
                TypeAArray tp = cast(TypeAArray)tparam;
                if (!deduceType(t.index, sc, tp.index, parameters, dedtypes))
                {
                    результат = MATCH.nomatch;
                    return;
                }
            }
            посети(cast(Тип)t);
        }

        override проц посети(TypeFunction t)
        {
            // Extra check that function characteristics must match
            if (tparam && tparam.ty == Tfunction)
            {
                TypeFunction tp = cast(TypeFunction)tparam;
                if (t.parameterList.varargs != tp.parameterList.varargs || t.компонаж != tp.компонаж)
                {
                    результат = MATCH.nomatch;
                    return;
                }

                foreach (fparam; *tp.parameterList.parameters)
                {
                    // https://issues.dlang.org/show_bug.cgi?ид=2579
                    // Apply function параметр storage classes to параметр types
                    fparam.тип = fparam.тип.addStorageClass(fparam.классХранения);
                    fparam.классХранения &= ~(STC.TYPECTOR | STC.in_);

                    // https://issues.dlang.org/show_bug.cgi?ид=15243
                    // Resolve параметр тип if it's not related with template parameters
                    if (!reliesOnTemplateParameters(fparam.тип, (*parameters)[inferStart .. parameters.dim]))
                    {
                        auto tx = fparam.тип.typeSemantic(Место.initial, sc);
                        if (tx.ty == Terror)
                        {
                            результат = MATCH.nomatch;
                            return;
                        }
                        fparam.тип = tx;
                    }
                }

                т_мера nfargs = t.parameterList.length;
                т_мера nfparams = tp.parameterList.length;

                /* See if кортеж match
                 */
                if (nfparams > 0 && nfargs >= nfparams - 1)
                {
                    /* See if 'A' of the template параметр matches 'A'
                     * of the тип of the last function параметр.
                     */
                    Параметр2 fparam = tp.parameterList[nfparams - 1];
                    assert(fparam);
                    assert(fparam.тип);
                    if (fparam.тип.ty != Tident)
                        goto L1;
                    TypeIdentifier tid = cast(TypeIdentifier)fparam.тип;
                    if (tid.idents.dim)
                        goto L1;

                    /* Look through parameters to найди кортеж matching tid.идент
                     */
                    т_мера tupi = 0;
                    for (; 1; tupi++)
                    {
                        if (tupi == parameters.dim)
                            goto L1;
                        ПараметрШаблона2 tx = (*parameters)[tupi];
                        TemplateTupleParameter tup = tx.isTemplateTupleParameter();
                        if (tup && tup.идент.равен(tid.идент))
                            break;
                    }

                    /* The types of the function arguments [nfparams - 1 .. nfargs]
                     * now form the кортеж argument.
                     */
                    т_мера tuple_dim = nfargs - (nfparams - 1);

                    /* See if existing кортеж, and whether it matches or not
                     */
                    КорневойОбъект o = (*dedtypes)[tupi];
                    if (o)
                    {
                        // Existing deduced argument must be a кортеж, and must match
                        Tuple tup = кортеж_ли(o);
                        if (!tup || tup.objects.dim != tuple_dim)
                        {
                            результат = MATCH.nomatch;
                            return;
                        }
                        for (т_мера i = 0; i < tuple_dim; i++)
                        {
                            Параметр2 arg = t.parameterList[nfparams - 1 + i];
                            if (!arg.тип.равен(tup.objects[i]))
                            {
                                результат = MATCH.nomatch;
                                return;
                            }
                        }
                    }
                    else
                    {
                        // Create new кортеж
                        auto tup = new Tuple(tuple_dim);
                        for (т_мера i = 0; i < tuple_dim; i++)
                        {
                            Параметр2 arg = t.parameterList[nfparams - 1 + i];
                            tup.objects[i] = arg.тип;
                        }
                        (*dedtypes)[tupi] = tup;
                    }
                    nfparams--; // don't consider the last параметр for тип deduction
                    goto L2;
                }

            L1:
                if (nfargs != nfparams)
                {
                    результат = MATCH.nomatch;
                    return;
                }
            L2:
                for (т_мера i = 0; i < nfparams; i++)
                {
                    Параметр2 a  = t .parameterList[i];
                    Параметр2 ap = tp.parameterList[i];

                    if (!a.isCovariant(t.isref, ap) ||
                        !deduceType(a.тип, sc, ap.тип, parameters, dedtypes))
                    {
                        результат = MATCH.nomatch;
                        return;
                    }
                }
            }
            посети(cast(Тип)t);
        }

        override проц посети(TypeIdentifier t)
        {
            // Extra check
            if (tparam && tparam.ty == Tident)
            {
                TypeIdentifier tp = cast(TypeIdentifier)tparam;
                for (т_мера i = 0; i < t.idents.dim; i++)
                {
                    КорневойОбъект id1 = t.idents[i];
                    КорневойОбъект id2 = tp.idents[i];
                    if (!id1.равен(id2))
                    {
                        результат = MATCH.nomatch;
                        return;
                    }
                }
            }
            посети(cast(Тип)t);
        }

        override проц посети(TypeInstance t)
        {
            // Extra check
            if (tparam && tparam.ty == Tinstance && t.tempinst.tempdecl)
            {
                TemplateDeclaration tempdecl = t.tempinst.tempdecl.isTemplateDeclaration();
                assert(tempdecl);

                TypeInstance tp = cast(TypeInstance)tparam;

                //printf("tempinst.tempdecl = %p\n", tempdecl);
                //printf("tp.tempinst.tempdecl = %p\n", tp.tempinst.tempdecl);
                if (!tp.tempinst.tempdecl)
                {
                    //printf("tp.tempinst.имя = '%s'\n", tp.tempinst.имя.вТкст0());

                    /* Handle case of:
                     *  template Foo(T : sa!(T), alias sa)
                     */
                    т_мера i = templateIdentifierLookup(tp.tempinst.имя, parameters);
                    if (i == IDX_NOTFOUND)
                    {
                        /* Didn't найди it as a параметр идентификатор. Try looking
                         * it up and seeing if is an alias.
                         * https://issues.dlang.org/show_bug.cgi?ид=1454
                         */
                        auto tid = new TypeIdentifier(tp.место, tp.tempinst.имя);
                        Тип tx;
                        Выражение e;
                        ДСимвол s;
                        tid.resolve(tp.место, sc, &e, &tx, &s);
                        if (tx)
                        {
                            s = tx.toDsymbol(sc);
                            if (TemplateInstance ti = s ? s.родитель.isTemplateInstance() : null)
                            {
                                // https://issues.dlang.org/show_bug.cgi?ид=14290
                                // Try to match with ti.tempecl,
                                // only when ti is an enclosing instance.
                                ДСимвол p = sc.родитель;
                                while (p && p != ti)
                                    p = p.родитель;
                                if (p)
                                    s = ti.tempdecl;
                            }
                        }
                        if (s)
                        {
                            s = s.toAlias();
                            TemplateDeclaration td = s.isTemplateDeclaration();
                            if (td)
                            {
                                if (td.overroot)
                                    td = td.overroot;
                                for (; td; td = td.overnext)
                                {
                                    if (td == tempdecl)
                                        goto L2;
                                }
                            }
                        }
                        goto Lnomatch;
                    }
                    ПараметрШаблона2 tpx = (*parameters)[i];
                    if (!tpx.matchArg(sc, tempdecl, i, parameters, dedtypes, null))
                        goto Lnomatch;
                }
                else if (tempdecl != tp.tempinst.tempdecl)
                    goto Lnomatch;

            L2:
                for (т_мера i = 0; 1; i++)
                {
                    //printf("\ttest: tempinst.tiargs[%d]\n", i);
                    КорневойОбъект o1 = null;
                    if (i < t.tempinst.tiargs.dim)
                        o1 = (*t.tempinst.tiargs)[i];
                    else if (i < t.tempinst.tdtypes.dim && i < tp.tempinst.tiargs.dim)
                    {
                        // Pick up default arg
                        o1 = t.tempinst.tdtypes[i];
                    }
                    else if (i >= tp.tempinst.tiargs.dim)
                        break;

                    if (i >= tp.tempinst.tiargs.dim)
                    {
                        т_мера dim = tempdecl.parameters.dim - (tempdecl.isVariadic() ? 1 : 0);
                        while (i < dim && ((*tempdecl.parameters)[i].dependent || (*tempdecl.parameters)[i].hasDefaultArg()))
                        {
                            i++;
                        }
                        if (i >= dim)
                            break; // match if all remained parameters are dependent
                        goto Lnomatch;
                    }

                    КорневойОбъект o2 = (*tp.tempinst.tiargs)[i];
                    Тип t2 = тип_ли(o2);

                    т_мера j = (t2 && t2.ty == Tident && i == tp.tempinst.tiargs.dim - 1)
                        ? templateParameterLookup(t2, parameters) : IDX_NOTFOUND;
                    if (j != IDX_NOTFOUND && j == parameters.dim - 1 &&
                        (*parameters)[j].isTemplateTupleParameter())
                    {
                        /* Given:
                         *  struct A(B...) {}
                         *  alias A!(цел, float) X;
                         *  static if (is(X Y == A!(Z), Z...)) {}
                         * deduce that Z is a кортеж(цел, float)
                         */

                        /* Create кортеж from remaining args
                         */
                        т_мера vtdim = (tempdecl.isVariadic() ? t.tempinst.tiargs.dim : t.tempinst.tdtypes.dim) - i;
                        auto vt = new Tuple(vtdim);
                        for (т_мера k = 0; k < vtdim; k++)
                        {
                            КорневойОбъект o;
                            if (k < t.tempinst.tiargs.dim)
                                o = (*t.tempinst.tiargs)[i + k];
                            else // Pick up default arg
                                o = t.tempinst.tdtypes[i + k];
                            vt.objects[k] = o;
                        }

                        Tuple v = cast(Tuple)(*dedtypes)[j];
                        if (v)
                        {
                            if (!match(v, vt))
                                goto Lnomatch;
                        }
                        else
                            (*dedtypes)[j] = vt;
                        break;
                    }
                    else if (!o1)
                        break;

                    Тип t1 = тип_ли(o1);
                    ДСимвол s1 = isDsymbol(o1);
                    ДСимвол s2 = isDsymbol(o2);
                    Выражение e1 = s1 ? дайЗначение(s1) : дайЗначение(выражение_ли(o1));
                    Выражение e2 = выражение_ли(o2);
                    version (none)
                    {
                        Tuple v1 = кортеж_ли(o1);
                        Tuple v2 = кортеж_ли(o2);
                        if (t1)
                            printf("t1 = %s\n", t1.вТкст0());
                        if (t2)
                            printf("t2 = %s\n", t2.вТкст0());
                        if (e1)
                            printf("e1 = %s\n", e1.вТкст0());
                        if (e2)
                            printf("e2 = %s\n", e2.вТкст0());
                        if (s1)
                            printf("s1 = %s\n", s1.вТкст0());
                        if (s2)
                            printf("s2 = %s\n", s2.вТкст0());
                        if (v1)
                            printf("v1 = %s\n", v1.вТкст0());
                        if (v2)
                            printf("v2 = %s\n", v2.вТкст0());
                    }

                    if (t1 && t2)
                    {
                        if (!deduceType(t1, sc, t2, parameters, dedtypes))
                            goto Lnomatch;
                    }
                    else if (e1 && e2)
                    {
                    Le:
                        e1 = e1.ctfeInterpret();

                        /* If it is one of the template parameters for this template,
                         * we should not attempt to interpret it. It already has a значение.
                         */
                        if (e2.op == ТОК2.variable && ((cast(VarExp)e2).var.класс_хранения & STC.шаблонпараметр))
                        {
                            /*
                             * (T:Number!(e2), цел e2)
                             */
                            j = templateIdentifierLookup((cast(VarExp)e2).var.идент, parameters);
                            if (j != IDX_NOTFOUND)
                                goto L1;
                            // The template параметр was not from this template
                            // (it may be from a родитель template, for example)
                        }

                        e2 = e2.ВыражениеSemantic(sc); // https://issues.dlang.org/show_bug.cgi?ид=13417
                        e2 = e2.ctfeInterpret();

                        //printf("e1 = %s, тип = %s %d\n", e1.вТкст0(), e1.тип.вТкст0(), e1.тип.ty);
                        //printf("e2 = %s, тип = %s %d\n", e2.вТкст0(), e2.тип.вТкст0(), e2.тип.ty);
                        if (!e1.равен(e2))
                        {
                            if (!e2.implicitConvTo(e1.тип))
                                goto Lnomatch;

                            e2 = e2.implicitCastTo(sc, e1.тип);
                            e2 = e2.ctfeInterpret();
                            if (!e1.равен(e2))
                                goto Lnomatch;
                        }
                    }
                    else if (e1 && t2 && t2.ty == Tident)
                    {
                        j = templateParameterLookup(t2, parameters);
                    L1:
                        if (j == IDX_NOTFOUND)
                        {
                            t2.resolve((cast(TypeIdentifier)t2).место, sc, &e2, &t2, &s2);
                            if (e2)
                                goto Le;
                            goto Lnomatch;
                        }
                        if (!(*parameters)[j].matchArg(sc, e1, j, parameters, dedtypes, null))
                            goto Lnomatch;
                    }
                    else if (s1 && s2)
                    {
                    Ls:
                        if (!s1.равен(s2))
                            goto Lnomatch;
                    }
                    else if (s1 && t2 && t2.ty == Tident)
                    {
                        j = templateParameterLookup(t2, parameters);
                        if (j == IDX_NOTFOUND)
                        {
                            t2.resolve((cast(TypeIdentifier)t2).место, sc, &e2, &t2, &s2);
                            if (s2)
                                goto Ls;
                            goto Lnomatch;
                        }
                        if (!(*parameters)[j].matchArg(sc, s1, j, parameters, dedtypes, null))
                            goto Lnomatch;
                    }
                    else
                        goto Lnomatch;
                }
            }
            посети(cast(Тип)t);
            return;

        Lnomatch:
            //printf("no match\n");
            результат = MATCH.nomatch;
        }

        override проц посети(TypeStruct t)
        {
            /* If this struct is a template struct, and we're matching
             * it against a template instance, convert the struct тип
             * to a template instance, too, and try again.
             */
            TemplateInstance ti = t.sym.родитель.isTemplateInstance();

            if (tparam && tparam.ty == Tinstance)
            {
                if (ti && ti.toAlias() == t.sym)
                {
                    auto tx = new TypeInstance(Место.initial, ti);
                    результат = deduceType(tx, sc, tparam, parameters, dedtypes, wm);
                    return;
                }

                /* Match things like:
                 *  S!(T).foo
                 */
                TypeInstance tpi = cast(TypeInstance)tparam;
                if (tpi.idents.dim)
                {
                    КорневойОбъект ид = tpi.idents[tpi.idents.dim - 1];
                    if (ид.динкаст() == ДИНКАСТ.идентификатор && t.sym.идент.равен(cast(Идентификатор2)ид))
                    {
                        Тип tparent = t.sym.родитель.getType();
                        if (tparent)
                        {
                            /* Slice off the .foo in S!(T).foo
                             */
                            tpi.idents.dim--;
                            результат = deduceType(tparent, sc, tpi, parameters, dedtypes, wm);
                            tpi.idents.dim++;
                            return;
                        }
                    }
                }
            }

            // Extra check
            if (tparam && tparam.ty == Tstruct)
            {
                TypeStruct tp = cast(TypeStruct)tparam;

                //printf("\t%d\n", (MATCH) t.implicitConvTo(tp));
                if (wm && t.deduceWild(tparam, нет))
                {
                    результат = MATCH.constant;
                    return;
                }
                результат = t.implicitConvTo(tp);
                return;
            }
            посети(cast(Тип)t);
        }

        override проц посети(TypeEnum t)
        {
            // Extra check
            if (tparam && tparam.ty == Tenum)
            {
                TypeEnum tp = cast(TypeEnum)tparam;
                if (t.sym == tp.sym)
                    посети(cast(Тип)t);
                else
                    результат = MATCH.nomatch;
                return;
            }
            Тип tb = t.toBasetype();
            if (tb.ty == tparam.ty || tb.ty == Tsarray && tparam.ty == Taarray)
            {
                результат = deduceType(tb, sc, tparam, parameters, dedtypes, wm);
                return;
            }
            посети(cast(Тип)t);
        }

        /* Helper for TypeClass.deduceType().
         * Classes can match with implicit conversion to a base class or interface.
         * This is complicated, because there may be more than one base class which
         * matches. In such cases, one or more parameters remain ambiguous.
         * For example,
         *
         *   interface I(X, Y) {}
         *   class C : I(бцел, double), I(сим, double) {}
         *   C x;
         *   foo(T, U)( I!(T, U) x)
         *
         *   deduces that U is double, but T remains ambiguous (could be сим or бцел).
         *
         * Given a baseclass b, and initial deduced types 'dedtypes', this function
         * tries to match tparam with b, and also tries all base interfaces of b.
         * If a match occurs, numBaseClassMatches is incremented, and the new deduced
         * types are ANDed with the current 'best' estimate for dedtypes.
         */
        static проц deduceBaseClassParameters(ref КлассОснова2 b, Scope* sc, Тип tparam, ПараметрыШаблона* parameters, Объекты* dedtypes, Объекты* best, ref цел numBaseClassMatches)
        {
            TemplateInstance parti = b.sym ? b.sym.родитель.isTemplateInstance() : null;
            if (parti)
            {
                // Make a temporary копируй of dedtypes so we don't разрушь it
                auto tmpdedtypes = new Объекты(dedtypes.dim);
                memcpy(tmpdedtypes.tdata(), dedtypes.tdata(), dedtypes.dim * (ук).sizeof);

                auto t = new TypeInstance(Место.initial, parti);
                MATCH m = deduceType(t, sc, tparam, parameters, tmpdedtypes);
                if (m > MATCH.nomatch)
                {
                    // If this is the first ever match, it becomes our best estimate
                    if (numBaseClassMatches == 0)
                        memcpy(best.tdata(), tmpdedtypes.tdata(), tmpdedtypes.dim * (ук).sizeof);
                    else
                        for (т_мера k = 0; k < tmpdedtypes.dim; ++k)
                        {
                            // If we've found more than one possible тип for a параметр,
                            // mark it as unknown.
                            if ((*tmpdedtypes)[k] != (*best)[k])
                                (*best)[k] = (*dedtypes)[k];
                        }
                    ++numBaseClassMatches;
                }
            }

            // Now recursively test the inherited interfaces
            foreach (ref bi; b.baseInterfaces)
            {
                deduceBaseClassParameters(bi, sc, tparam, parameters, dedtypes, best, numBaseClassMatches);
            }
        }

        override проц посети(TypeClass t)
        {
            //printf("TypeClass.deduceType(this = %s)\n", t.вТкст0());

            /* If this class is a template class, and we're matching
             * it against a template instance, convert the class тип
             * to a template instance, too, and try again.
             */
            TemplateInstance ti = t.sym.родитель.isTemplateInstance();

            if (tparam && tparam.ty == Tinstance)
            {
                if (ti && ti.toAlias() == t.sym)
                {
                    auto tx = new TypeInstance(Место.initial, ti);
                    MATCH m = deduceType(tx, sc, tparam, parameters, dedtypes, wm);
                    // Even if the match fails, there is still a chance it could match
                    // a base class.
                    if (m != MATCH.nomatch)
                    {
                        результат = m;
                        return;
                    }
                }

                /* Match things like:
                 *  S!(T).foo
                 */
                TypeInstance tpi = cast(TypeInstance)tparam;
                if (tpi.idents.dim)
                {
                    КорневойОбъект ид = tpi.idents[tpi.idents.dim - 1];
                    if (ид.динкаст() == ДИНКАСТ.идентификатор && t.sym.идент.равен(cast(Идентификатор2)ид))
                    {
                        Тип tparent = t.sym.родитель.getType();
                        if (tparent)
                        {
                            /* Slice off the .foo in S!(T).foo
                             */
                            tpi.idents.dim--;
                            результат = deduceType(tparent, sc, tpi, parameters, dedtypes, wm);
                            tpi.idents.dim++;
                            return;
                        }
                    }
                }

                // If it matches exactly or via implicit conversion, we're done
                посети(cast(Тип)t);
                if (результат != MATCH.nomatch)
                    return;

                /* There is still a chance to match via implicit conversion to
                 * a base class or interface. Because there could be more than one such
                 * match, we need to check them all.
                 */

                цел numBaseClassMatches = 0; // Have we found an interface match?

                // Our best guess at dedtypes
                auto best = new Объекты(dedtypes.dim);

                ClassDeclaration s = t.sym;
                while (s && s.baseclasses.dim > 0)
                {
                    // Test the base class
                    deduceBaseClassParameters(*(*s.baseclasses)[0], sc, tparam, parameters, dedtypes, best, numBaseClassMatches);

                    // Test the interfaces inherited by the base class
                    foreach (b; s.interfaces)
                    {
                        deduceBaseClassParameters(*b, sc, tparam, parameters, dedtypes, best, numBaseClassMatches);
                    }
                    s = (*s.baseclasses)[0].sym;
                }

                if (numBaseClassMatches == 0)
                {
                    результат = MATCH.nomatch;
                    return;
                }

                // If we got at least one match, копируй the known types into dedtypes
                memcpy(dedtypes.tdata(), best.tdata(), best.dim * (ук).sizeof);
                результат = MATCH.convert;
                return;
            }

            // Extra check
            if (tparam && tparam.ty == Tclass)
            {
                TypeClass tp = cast(TypeClass)tparam;

                //printf("\t%d\n", (MATCH) t.implicitConvTo(tp));
                if (wm && t.deduceWild(tparam, нет))
                {
                    результат = MATCH.constant;
                    return;
                }
                результат = t.implicitConvTo(tp);
                return;
            }
            посети(cast(Тип)t);
        }

        override проц посети(Выражение e)
        {
            //printf("Выражение.deduceType(e = %s)\n", e.вТкст0());
            т_мера i = templateParameterLookup(tparam, parameters);
            if (i == IDX_NOTFOUND || (cast(TypeIdentifier)tparam).idents.dim > 0)
            {
                if (e == emptyArrayElement && tparam.ty == Tarray)
                {
                    Тип tn = (cast(TypeNext)tparam).следщ;
                    результат = deduceType(emptyArrayElement, sc, tn, parameters, dedtypes, wm);
                    return;
                }
                e.тип.прими(this);
                return;
            }

            TemplateTypeParameter tp = (*parameters)[i].isTemplateTypeParameter();
            if (!tp)
                return; // nomatch

            if (e == emptyArrayElement)
            {
                if ((*dedtypes)[i])
                {
                    результат = MATCH.exact;
                    return;
                }
                if (tp.defaultType)
                {
                    tp.defaultType.прими(this);
                    return;
                }
            }

            /* Возвращает `да` if `t` is a reference тип, or an массив of reference types
             */
            бул isTopRef(Тип t)
            {
                auto tb = t.baseElemOf();
                return tb.ty == Tclass ||
                       tb.ty == Taarray ||
                       tb.ty == Tstruct && tb.hasPointers();
            }

            Тип at = cast(Тип)(*dedtypes)[i];
            Тип tt;
            if (ббайт wx = deduceWildHelper(e.тип, &tt, tparam))
            {
                *wm |= wx;
                результат = MATCH.constant;
            }
            else if (MATCH m = deduceTypeHelper(e.тип, &tt, tparam))
            {
                результат = m;
            }
            else if (!isTopRef(e.тип))
            {
                /* https://issues.dlang.org/show_bug.cgi?ид=15653
                 * In IFTI, recognize top-qualifier conversions
                 * through the значение копируй, e.g.
                 *      цел --> const(цел)
                 *      const(ткст[]) --> const(ткст)[]
                 */
                tt = e.тип.mutableOf();
                результат = MATCH.convert;
            }
            else
                return; // nomatch

            // Выражение vs (none)
            if (!at)
            {
                (*dedtypes)[i] = new TypeDeduced(tt, e, tparam);
                return;
            }

            TypeDeduced xt = null;
            if (at.ty == Tnone)
            {
                xt = cast(TypeDeduced)at;
                at = xt.tded;
            }

            // From previous matched Выражения to current deduced тип
            MATCH match1 = xt ? xt.matchAll(tt) : MATCH.nomatch;

            // From current Выражения to previous deduced тип
            Тип pt = at.addMod(tparam.mod);
            if (*wm)
                pt = pt.substWildTo(*wm);
            MATCH match2 = e.implicitConvTo(pt);

            if (match1 > MATCH.nomatch && match2 > MATCH.nomatch)
            {
                if (at.implicitConvTo(tt) <= MATCH.nomatch)
                    match1 = MATCH.nomatch; // Prefer at
                else if (tt.implicitConvTo(at) <= MATCH.nomatch)
                    match2 = MATCH.nomatch; // Prefer tt
                else if (tt.isTypeBasic() && tt.ty == at.ty && tt.mod != at.mod)
                {
                    if (!tt.isMutable() && !at.isMutable())
                        tt = tt.mutableOf().addMod(MODmerge(tt.mod, at.mod));
                    else if (tt.isMutable())
                    {
                        if (at.mod == 0) // Prefer unshared
                            match1 = MATCH.nomatch;
                        else
                            match2 = MATCH.nomatch;
                    }
                    else if (at.isMutable())
                    {
                        if (tt.mod == 0) // Prefer unshared
                            match2 = MATCH.nomatch;
                        else
                            match1 = MATCH.nomatch;
                    }
                    //printf("tt = %s, at = %s\n", tt.вТкст0(), at.вТкст0());
                }
                else
                {
                    match1 = MATCH.nomatch;
                    match2 = MATCH.nomatch;
                }
            }
            if (match1 > MATCH.nomatch)
            {
                // Prefer current match: tt
                if (xt)
                    xt.update(tt, e, tparam);
                else
                    (*dedtypes)[i] = tt;
                результат = match1;
                return;
            }
            if (match2 > MATCH.nomatch)
            {
                // Prefer previous match: (*dedtypes)[i]
                if (xt)
                    xt.update(e, tparam);
                результат = match2;
                return;
            }

            /* Deduce common тип
             */
            if (Тип t = rawTypeMerge(at, tt))
            {
                if (xt)
                    xt.update(t, e, tparam);
                else
                    (*dedtypes)[i] = t;

                pt = tt.addMod(tparam.mod);
                if (*wm)
                    pt = pt.substWildTo(*wm);
                результат = e.implicitConvTo(pt);
                return;
            }

            результат = MATCH.nomatch;
        }

        MATCH deduceEmptyArrayElement()
        {
            if (!emptyArrayElement)
            {
                emptyArrayElement = new IdentifierExp(Место.initial, Id.p); // dummy
                emptyArrayElement.тип = Тип.tvoid;
            }
            assert(tparam.ty == Tarray);

            Тип tn = (cast(TypeNext)tparam).следщ;
            return deduceType(emptyArrayElement, sc, tn, parameters, dedtypes, wm);
        }

        override проц посети(NullExp e)
        {
            if (tparam.ty == Tarray && e.тип.ty == Tnull)
            {
                // tparam:T[] <- e:null (проц[])
                результат = deduceEmptyArrayElement();
                return;
            }
            посети(cast(Выражение)e);
        }

        override проц посети(StringExp e)
        {
            Тип taai;
            if (e.тип.ty == Tarray && (tparam.ty == Tsarray || tparam.ty == Taarray && (taai = (cast(TypeAArray)tparam).index).ty == Tident && (cast(TypeIdentifier)taai).idents.dim == 0))
            {
                // Consider compile-time known boundaries
                e.тип.nextOf().sarrayOf(e.len).прими(this);
                return;
            }
            посети(cast(Выражение)e);
        }

        override проц посети(ArrayLiteralExp e)
        {
            // https://issues.dlang.org/show_bug.cgi?ид=20092
            if (e.elements && e.elements.dim && e.тип.toBasetype().nextOf().ty == Tvoid)
            {
                результат = deduceEmptyArrayElement();
                return;
            }
            if ((!e.elements || !e.elements.dim) && e.тип.toBasetype().nextOf().ty == Tvoid && tparam.ty == Tarray)
            {
                // tparam:T[] <- e:[] (проц[])
                результат = deduceEmptyArrayElement();
                return;
            }

            if (tparam.ty == Tarray && e.elements && e.elements.dim)
            {
                Тип tn = (cast(TypeDArray)tparam).следщ;
                результат = MATCH.exact;
                if (e.basis)
                {
                    MATCH m = deduceType(e.basis, sc, tn, parameters, dedtypes, wm);
                    if (m < результат)
                        результат = m;
                }
                for (т_мера i = 0; i < e.elements.dim; i++)
                {
                    if (результат <= MATCH.nomatch)
                        break;
                    auto el = (*e.elements)[i];
                    if (!el)
                        continue;
                    MATCH m = deduceType(el, sc, tn, parameters, dedtypes, wm);
                    if (m < результат)
                        результат = m;
                }
                return;
            }

            Тип taai;
            if (e.тип.ty == Tarray && (tparam.ty == Tsarray || tparam.ty == Taarray && (taai = (cast(TypeAArray)tparam).index).ty == Tident && (cast(TypeIdentifier)taai).idents.dim == 0))
            {
                // Consider compile-time known boundaries
                e.тип.nextOf().sarrayOf(e.elements.dim).прими(this);
                return;
            }
            посети(cast(Выражение)e);
        }

        override проц посети(AssocArrayLiteralExp e)
        {
            if (tparam.ty == Taarray && e.keys && e.keys.dim)
            {
                TypeAArray taa = cast(TypeAArray)tparam;
                результат = MATCH.exact;
                for (т_мера i = 0; i < e.keys.dim; i++)
                {
                    MATCH m1 = deduceType((*e.keys)[i], sc, taa.index, parameters, dedtypes, wm);
                    if (m1 < результат)
                        результат = m1;
                    if (результат <= MATCH.nomatch)
                        break;
                    MATCH m2 = deduceType((*e.values)[i], sc, taa.следщ, parameters, dedtypes, wm);
                    if (m2 < результат)
                        результат = m2;
                    if (результат <= MATCH.nomatch)
                        break;
                }
                return;
            }
            посети(cast(Выражение)e);
        }

        override проц посети(FuncExp e)
        {
            //printf("e.тип = %s, tparam = %s\n", e.тип.вТкст0(), tparam.вТкст0());
            if (e.td)
            {
                Тип to = tparam;
                if (!to.nextOf() || to.nextOf().ty != Tfunction)
                    return;
                TypeFunction tof = cast(TypeFunction)to.nextOf();

                // Параметр2 types inference from 'tof'
                assert(e.td._scope);
                TypeFunction tf = cast(TypeFunction)e.fd.тип;
                //printf("\ttof = %s\n", tof.вТкст0());
                //printf("\ttf  = %s\n", tf.вТкст0());
                т_мера dim = tf.parameterList.length;

                if (tof.parameterList.length != dim || tof.parameterList.varargs != tf.parameterList.varargs)
                    return;

                auto tiargs = new Объекты();
                tiargs.резервируй(e.td.parameters.dim);

                for (т_мера i = 0; i < e.td.parameters.dim; i++)
                {
                    ПараметрШаблона2 tp = (*e.td.parameters)[i];
                    т_мера u = 0;
                    for (; u < dim; u++)
                    {
                        Параметр2 p = tf.parameterList[u];
                        if (p.тип.ty == Tident && (cast(TypeIdentifier)p.тип).идент == tp.идент)
                        {
                            break;
                        }
                    }
                    assert(u < dim);
                    Параметр2 pto = tof.parameterList[u];
                    if (!pto)
                        break;
                    Тип t = pto.тип.syntaxCopy(); // https://issues.dlang.org/show_bug.cgi?ид=11774
                    if (reliesOnTemplateParameters(t, (*parameters)[inferStart .. parameters.dim]))
                        return;
                    t = t.typeSemantic(e.место, sc);
                    if (t.ty == Terror)
                        return;
                    tiargs.сунь(t);
                }

                // Set target of return тип inference
                if (!tf.следщ && tof.следщ)
                    e.fd.treq = tparam;

                auto ti = new TemplateInstance(e.место, e.td, tiargs);
                Выражение ex = (new ScopeExp(e.место, ti)).ВыражениеSemantic(e.td._scope);

                // Reset inference target for the later re-semantic
                e.fd.treq = null;

                if (ex.op == ТОК2.error)
                    return;
                if (ex.op != ТОК2.function_)
                    return;
                посети(ex.тип);
                return;
            }

            Тип t = e.тип;

            if (t.ty == Tdelegate && tparam.ty == Tpointer)
                return;

            // Allow conversion from implicit function pointer to delegate
            if (e.tok == ТОК2.reserved && t.ty == Tpointer && tparam.ty == Tdelegate)
            {
                TypeFunction tf = cast(TypeFunction)t.nextOf();
                t = (new TypeDelegate(tf)).merge();
            }
            //printf("tparam = %s <= e.тип = %s, t = %s\n", tparam.вТкст0(), e.тип.вТкст0(), t.вТкст0());
            посети(t);
        }

        override проц посети(SliceExp e)
        {
            Тип taai;
            if (e.тип.ty == Tarray && (tparam.ty == Tsarray || tparam.ty == Taarray && (taai = (cast(TypeAArray)tparam).index).ty == Tident && (cast(TypeIdentifier)taai).idents.dim == 0))
            {
                // Consider compile-time known boundaries
                if (Тип tsa = toStaticArrayType(e))
                {
                    tsa.прими(this);
                    return;
                }
            }
            посети(cast(Выражение)e);
        }

        override проц посети(CommaExp e)
        {
            e.e2.прими(this);
        }
    }

    scope DeduceType v = new DeduceType(sc, tparam, parameters, dedtypes, wm, inferStart, ignoreAliasThis);
    if (Тип t = тип_ли(o))
        t.прими(v);
    else if (Выражение e = выражение_ли(o))
    {
        assert(wm);
        e.прими(v);
    }
    else
        assert(0);
    return v.результат;
}

/***********************************************************
 * Check whether the тип t representation relies on one or more the template parameters.
 * Параметры:
 *      t           = Tested тип, if null, returns нет.
 *      tparams     = Template parameters.
 *      iStart      = Start index of tparams to limit the tested parameters. If it's
 *                    nonzero, tparams[0..iStart] will be excluded from the test target.
 */
бул reliesOnTident(Тип t, ПараметрыШаблона* tparams, т_мера iStart = 0)
{
    return reliesOnTemplateParameters(t, (*tparams)[0 .. tparams.dim]);
}

/***********************************************************
 * Check whether the тип t representation relies on one or more the template parameters.
 * Параметры:
 *      t           = Tested тип, if null, returns нет.
 *      tparams     = Template parameters.
 */
private бул reliesOnTemplateParameters(Тип t, ПараметрШаблона2[] tparams)
{
    бул visitVector(TypeVector t)
    {
        return t.basetype.reliesOnTemplateParameters(tparams);
    }

    бул visitAArray(TypeAArray t)
    {
        return t.следщ.reliesOnTemplateParameters(tparams) ||
               t.index.reliesOnTemplateParameters(tparams);
    }

    бул visitFunction(TypeFunction t)
    {
        foreach (i;  new бцел[0 .. t.parameterList.length])
        {
            Параметр2 fparam = t.parameterList[i];
            if (fparam.тип.reliesOnTemplateParameters(tparams))
                return да;
        }
        return t.следщ.reliesOnTemplateParameters(tparams);
    }

    бул visitIdentifier(TypeIdentifier t)
    {
        foreach (tp; tparams)
        {
            if (tp.идент.равен(t.идент))
                return да;
        }
        return нет;
    }

    бул visitInstance(TypeInstance t)
    {
        foreach (tp; tparams)
        {
            if (t.tempinst.имя == tp.идент)
                return да;
        }

        if (t.tempinst.tiargs)
            foreach (arg; *t.tempinst.tiargs)
            {
                if (Тип ta = тип_ли(arg))
                {
                    if (ta.reliesOnTemplateParameters(tparams))
                        return да;
                }
            }

        return нет;
    }

    бул visitTypeof(TypeTypeof t)
    {
        //printf("TypeTypeof.reliesOnTemplateParameters('%s')\n", t.вТкст0());
        return t.exp.reliesOnTemplateParameters(tparams);
    }

    бул visitTuple(КортежТипов t)
    {
        if (t.arguments)
            foreach (arg; *t.arguments)
            {
                if (arg.тип.reliesOnTemplateParameters(tparams))
                    return да;
            }

        return нет;
    }

    if (!t)
        return нет;

    Тип tb = t.toBasetype();
    switch (tb.ty)
    {
        case Tvector:   return visitVector(tb.isTypeVector());
        case Taarray:   return visitAArray(tb.isTypeAArray());
        case Tfunction: return visitFunction(tb.isTypeFunction());
        case Tident:    return visitIdentifier(tb.isTypeIdentifier());
        case Tinstance: return visitInstance(tb.isTypeInstance());
        case Ttypeof:   return visitTypeof(tb.isTypeTypeof());
        case Ttuple:    return visitTuple(tb.isTypeTuple());
        case Tenum:     return нет;
        default:        return tb.nextOf().reliesOnTemplateParameters(tparams);
    }
}

/***********************************************************
 * Check whether the Выражение representation relies on one or more the template parameters.
 * Параметры:
 *      e           = Выражение to test
 *      tparams     = Template parameters.
 * Возвращает:
 *      да if it does
 */
private бул reliesOnTemplateParameters(Выражение e, ПараметрШаблона2[] tparams)
{
     final class ReliesOnTemplateParameters : Визитор2
    {
        alias Визитор2.посети посети;
    public:
        ПараметрШаблона2[] tparams;
        бул результат;

        this(ПараметрШаблона2[] tparams)
        {
            this.tparams = tparams;
        }

        override проц посети(Выражение e)
        {
            //printf("Выражение.reliesOnTemplateParameters('%s')\n", e.вТкст0());
        }

        override проц посети(IdentifierExp e)
        {
            //printf("IdentifierExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            foreach (tp; tparams)
            {
                if (e.идент == tp.идент)
                {
                    результат = да;
                    return;
                }
            }
        }

        override проц посети(TupleExp e)
        {
            //printf("TupleExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            if (e.exps)
            {
                foreach (ea; *e.exps)
                {
                    ea.прими(this);
                    if (результат)
                        return;
                }
            }
        }

        override проц посети(ArrayLiteralExp e)
        {
            //printf("ArrayLiteralExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            if (e.elements)
            {
                foreach (el; *e.elements)
                {
                    el.прими(this);
                    if (результат)
                        return;
                }
            }
        }

        override проц посети(AssocArrayLiteralExp e)
        {
            //printf("AssocArrayLiteralExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            foreach (ek; *e.keys)
            {
                ek.прими(this);
                if (результат)
                    return;
            }
            foreach (ev; *e.values)
            {
                ev.прими(this);
                if (результат)
                    return;
            }
        }

        override проц посети(StructLiteralExp e)
        {
            //printf("StructLiteralExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            if (e.elements)
            {
                foreach (ea; *e.elements)
                {
                    ea.прими(this);
                    if (результат)
                        return;
                }
            }
        }

        override проц посети(TypeExp e)
        {
            //printf("TypeExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            результат = e.тип.reliesOnTemplateParameters(tparams);
        }

        override проц посети(NewExp e)
        {
            //printf("NewExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            if (e.thisexp)
                e.thisexp.прими(this);
            if (!результат && e.newargs)
            {
                foreach (ea; *e.newargs)
                {
                    ea.прими(this);
                    if (результат)
                        return;
                }
            }
            результат = e.newtype.reliesOnTemplateParameters(tparams);
            if (!результат && e.arguments)
            {
                foreach (ea; *e.arguments)
                {
                    ea.прими(this);
                    if (результат)
                        return;
                }
            }
        }

        override проц посети(NewAnonClassExp e)
        {
            //printf("NewAnonClassExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            результат = да;
        }

        override проц посети(FuncExp e)
        {
            //printf("FuncExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            результат = да;
        }

        override проц посети(TypeidExp e)
        {
            //printf("TypeidExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            if (auto ea = выражение_ли(e.obj))
                ea.прими(this);
            else if (auto ta = тип_ли(e.obj))
                результат = ta.reliesOnTemplateParameters(tparams);
        }

        override проц посети(TraitsExp e)
        {
            //printf("TraitsExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            if (e.args)
            {
                foreach (oa; *e.args)
                {
                    if (auto ea = выражение_ли(oa))
                        ea.прими(this);
                    else if (auto ta = тип_ли(oa))
                        результат = ta.reliesOnTemplateParameters(tparams);
                    if (результат)
                        return;
                }
            }
        }

        override проц посети(IsExp e)
        {
            //printf("IsExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            результат = e.targ.reliesOnTemplateParameters(tparams);
        }

        override проц посети(UnaExp e)
        {
            //printf("UnaExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            e.e1.прими(this);
        }

        override проц посети(DotTemplateInstanceExp e)
        {
            //printf("DotTemplateInstanceExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            посети(cast(UnaExp)e);
            if (!результат && e.ti.tiargs)
            {
                foreach (oa; *e.ti.tiargs)
                {
                    if (auto ea = выражение_ли(oa))
                        ea.прими(this);
                    else if (auto ta = тип_ли(oa))
                        результат = ta.reliesOnTemplateParameters(tparams);
                    if (результат)
                        return;
                }
            }
        }

        override проц посети(CallExp e)
        {
            //printf("CallExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            посети(cast(UnaExp)e);
            if (!результат && e.arguments)
            {
                foreach (ea; *e.arguments)
                {
                    ea.прими(this);
                    if (результат)
                        return;
                }
            }
        }

        override проц посети(CastExp e)
        {
            //printf("CallExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            посети(cast(UnaExp)e);
            // e.to can be null for /*cast()*/ with no тип
            if (!результат && e.to)
                результат = e.to.reliesOnTemplateParameters(tparams);
        }

        override проц посети(SliceExp e)
        {
            //printf("SliceExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            посети(cast(UnaExp)e);
            if (!результат && e.lwr)
                e.lwr.прими(this);
            if (!результат && e.upr)
                e.upr.прими(this);
        }

        override проц посети(IntervalExp e)
        {
            //printf("IntervalExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            e.lwr.прими(this);
            if (!результат)
                e.upr.прими(this);
        }

        override проц посети(ArrayExp e)
        {
            //printf("ArrayExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            посети(cast(UnaExp)e);
            if (!результат && e.arguments)
            {
                foreach (ea; *e.arguments)
                    ea.прими(this);
            }
        }

        override проц посети(BinExp e)
        {
            //printf("BinExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            e.e1.прими(this);
            if (!результат)
                e.e2.прими(this);
        }

        override проц посети(CondExp e)
        {
            //printf("BinExp.reliesOnTemplateParameters('%s')\n", e.вТкст0());
            e.econd.прими(this);
            if (!результат)
                посети(cast(BinExp)e);
        }
    }

    scope ReliesOnTemplateParameters v = new ReliesOnTemplateParameters(tparams);
    e.прими(v);
    return v.результат;
}

/***********************************************************
 * https://dlang.org/spec/template.html#ПараметрШаблона2
 */
 class ПараметрШаблона2 : УзелАСД
{
    Место место;
    Идентификатор2 идент;

    /* True if this is a part of precedent параметр specialization pattern.
     *
     *  template A(T : X!TL, alias X, TL...) {}
     *  // X and TL are dependent template параметр
     *
     * A dependent template параметр should return MATCH.exact in matchArg()
     * to respect the match уровень of the corresponding precedent параметр.
     */
    бул dependent;

    /* ======================== ПараметрШаблона2 =============================== */
    this(ref Место место, Идентификатор2 идент)
    {
        this.место = место;
        this.идент = идент;
    }

    TemplateTypeParameter isTemplateTypeParameter()
    {
        return null;
    }

    TemplateValueParameter isTemplateValueParameter()
    {
        return null;
    }

    TemplateAliasParameter isTemplateAliasParameter()
    {
        return null;
    }

    TemplateThisParameter isTemplateThisParameter()
    {
        return null;
    }

    TemplateTupleParameter isTemplateTupleParameter()
    {
        return null;
    }

    abstract ПараметрШаблона2 syntaxCopy();

    abstract бул declareParameter(Scope* sc);

    abstract проц print(КорневойОбъект oarg, КорневойОбъект oded);

    abstract КорневойОбъект specialization();

    abstract КорневойОбъект defaultArg(Место instLoc, Scope* sc);

    abstract бул hasDefaultArg();

    override ткст0 вТкст0()
    {
        return this.идент.вТкст0();
    }

    override ДИНКАСТ динкаст()
    {
        return ДИНКАСТ.шаблонпараметр;
    }

    /* Create dummy argument based on параметр.
     */
    abstract ук dummyArg();

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/template.html#TemplateTypeParameter
 * Syntax:
 *  идент : specType = defaultType
 */
 class TemplateTypeParameter : ПараметрШаблона2
{
    Тип specType;      // if !=null, this is the тип specialization
    Тип defaultType;

    extern (D)  Тип tdummy = null;

    this(ref Место место, Идентификатор2 идент, Тип specType, Тип defaultType)
    {
        super(место, идент);
        this.specType = specType;
        this.defaultType = defaultType;
    }

    override final TemplateTypeParameter isTemplateTypeParameter()
    {
        return this;
    }

    override ПараметрШаблона2 syntaxCopy()
    {
        return new TemplateTypeParameter(место, идент, specType ? specType.syntaxCopy() : null, defaultType ? defaultType.syntaxCopy() : null);
    }

    override final бул declareParameter(Scope* sc)
    {
        //printf("TemplateTypeParameter.declareParameter('%s')\n", идент.вТкст0());
        auto ti = new TypeIdentifier(место, идент);
        Declaration ad = new AliasDeclaration(место, идент, ti);
        return sc.вставь(ad) !is null;
    }

    override final проц print(КорневойОбъект oarg, КорневойОбъект oded)
    {
        printf(" %s\n", идент.вТкст0());

        Тип t = тип_ли(oarg);
        Тип ta = тип_ли(oded);
        assert(ta);

        if (specType)
            printf("\tSpecialization: %s\n", specType.вТкст0());
        if (defaultType)
            printf("\tDefault:        %s\n", defaultType.вТкст0());
        printf("\tParameter:       %s\n", t ? t.вТкст0() : "NULL");
        printf("\tDeduced Тип:   %s\n", ta.вТкст0());
    }

    override final КорневойОбъект specialization()
    {
        return specType;
    }

    override final КорневойОбъект defaultArg(Место instLoc, Scope* sc)
    {
        Тип t = defaultType;
        if (t)
        {
            t = t.syntaxCopy();
            t = t.typeSemantic(место, sc); // use the параметр место
        }
        return t;
    }

    override final бул hasDefaultArg()
    {
        return defaultType !is null;
    }

    override final ук dummyArg()
    {
        Тип t = specType;
        if (!t)
        {
            // Use this for alias-параметр's too (?)
            if (!tdummy)
                tdummy = new TypeIdentifier(место, идент);
            t = tdummy;
        }
        return cast(ук)t;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/template.html#TemplateThisParameter
 * Syntax:
 *  this идент : specType = defaultType
 */
 final class TemplateThisParameter : TemplateTypeParameter
{
    this(ref Место место, Идентификатор2 идент, Тип specType, Тип defaultType)
    {
        super(место, идент, specType, defaultType);
    }

    override TemplateThisParameter isTemplateThisParameter()
    {
        return this;
    }

    override ПараметрШаблона2 syntaxCopy()
    {
        return new TemplateThisParameter(место, идент, specType ? specType.syntaxCopy() : null, defaultType ? defaultType.syntaxCopy() : null);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/template.html#TemplateValueParameter
 * Syntax:
 *  valType идент : specValue = defaultValue
 */
 final class TemplateValueParameter : ПараметрШаблона2
{
    Тип valType;
    Выражение specValue;
    Выражение defaultValue;

    extern (D)  Выражение[ук] edummies;

    this(ref Место место, Идентификатор2 идент, Тип valType,
        Выражение specValue, Выражение defaultValue)
    {
        super(место, идент);
        this.valType = valType;
        this.specValue = specValue;
        this.defaultValue = defaultValue;
    }

    override TemplateValueParameter isTemplateValueParameter()
    {
        return this;
    }

    override ПараметрШаблона2 syntaxCopy()
    {
        return new TemplateValueParameter(место, идент,
            valType.syntaxCopy(),
            specValue ? specValue.syntaxCopy() : null,
            defaultValue ? defaultValue.syntaxCopy() : null);
    }

    override бул declareParameter(Scope* sc)
    {
        auto v = new VarDeclaration(место, valType, идент, null);
        v.класс_хранения = STC.шаблонпараметр;
        return sc.вставь(v) !is null;
    }

    override проц print(КорневойОбъект oarg, КорневойОбъект oded)
    {
        printf(" %s\n", идент.вТкст0());
        Выражение ea = выражение_ли(oded);
        if (specValue)
            printf("\tSpecialization: %s\n", specValue.вТкст0());
        printf("\tParameter Значение: %s\n", ea ? ea.вТкст0() : "NULL");
    }

    override КорневойОбъект specialization()
    {
        return specValue;
    }

    override КорневойОбъект defaultArg(Место instLoc, Scope* sc)
    {
        Выражение e = defaultValue;
        if (e)
        {
            e = e.syntaxCopy();
            бцел olderrs = глоб2.errors;
            if ((e = e.ВыражениеSemantic(sc)) is null)
                return null;
            if ((e = resolveProperties(sc, e)) is null)
                return null;
            e = e.resolveLoc(instLoc, sc); // use the instantiated место
            e = e.optimize(WANTvalue);
            if (глоб2.errors != olderrs)
                e = new ErrorExp();
        }
        return e;
    }

    override бул hasDefaultArg()
    {
        return defaultValue !is null;
    }

    override ук dummyArg()
    {
        Выражение e = specValue;
        if (!e)
        {
            // Create a dummy значение
            auto pe = cast(ук)valType in edummies;
            if (!pe)
            {
                e = valType.defaultInit(Место.initial);
                edummies[cast(ук)valType] = e;
            }
            else
                e = *pe;
        }
        return cast(ук)e;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/template.html#TemplateAliasParameter
 * Syntax:
 *  specType идент : specAlias = defaultAlias
 */
 final class TemplateAliasParameter : ПараметрШаблона2
{
    Тип specType;
    КорневойОбъект specAlias;
    КорневойОбъект defaultAlias;

    extern (D)  ДСимвол sdummy = null;

    this(ref Место место, Идентификатор2 идент, Тип specType, КорневойОбъект specAlias, КорневойОбъект defaultAlias)
    {
        super(место, идент);
        this.specType = specType;
        this.specAlias = specAlias;
        this.defaultAlias = defaultAlias;
    }

    override TemplateAliasParameter isTemplateAliasParameter()
    {
        return this;
    }

    override ПараметрШаблона2 syntaxCopy()
    {
        return new TemplateAliasParameter(место, идент, specType ? specType.syntaxCopy() : null, objectSyntaxCopy(specAlias), objectSyntaxCopy(defaultAlias));
    }

    override бул declareParameter(Scope* sc)
    {
        auto ti = new TypeIdentifier(место, идент);
        Declaration ad = new AliasDeclaration(место, идент, ti);
        return sc.вставь(ad) !is null;
    }

    override проц print(КорневойОбъект oarg, КорневойОбъект oded)
    {
        printf(" %s\n", идент.вТкст0());
        ДСимвол sa = isDsymbol(oded);
        assert(sa);
        printf("\tParameter alias: %s\n", sa.вТкст0());
    }

    override КорневойОбъект specialization()
    {
        return specAlias;
    }

    override КорневойОбъект defaultArg(Место instLoc, Scope* sc)
    {
        КорневойОбъект da = defaultAlias;
        Тип ta = тип_ли(defaultAlias);
        if (ta)
        {
            if (ta.ty == Tinstance)
            {
                // If the default arg is a template, instantiate for each тип
                da = ta.syntaxCopy();
            }
        }

        КорневойОбъект o = aliasParameterSemantic(место, sc, da, null); // use the параметр место
        return o;
    }

    override бул hasDefaultArg()
    {
        return defaultAlias !is null;
    }

    override ук dummyArg()
    {
        КорневойОбъект s = specAlias;
        if (!s)
        {
            if (!sdummy)
                sdummy = new ДСимвол();
            s = sdummy;
        }
        return cast(ук)s;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/template.html#TemplateSequenceParameter
 * Syntax:
 *  идент ...
 */
 final class TemplateTupleParameter : ПараметрШаблона2
{
    this(ref Место место, Идентификатор2 идент)
    {
        super(место, идент);
    }

    override TemplateTupleParameter isTemplateTupleParameter()
    {
        return this;
    }

    override ПараметрШаблона2 syntaxCopy()
    {
        return new TemplateTupleParameter(место, идент);
    }

    override бул declareParameter(Scope* sc)
    {
        auto ti = new TypeIdentifier(место, идент);
        Declaration ad = new AliasDeclaration(место, идент, ti);
        return sc.вставь(ad) !is null;
    }

    override проц print(КорневойОбъект oarg, КорневойОбъект oded)
    {
        printf(" %s... [", идент.вТкст0());
        Tuple v = кортеж_ли(oded);
        assert(v);

        //printf("|%d| ", v.objects.dim);
        for (т_мера i = 0; i < v.objects.dim; i++)
        {
            if (i)
                printf(", ");

            КорневойОбъект o = v.objects[i];
            ДСимвол sa = isDsymbol(o);
            if (sa)
                printf("alias: %s", sa.вТкст0());
            Тип ta = тип_ли(o);
            if (ta)
                printf("тип: %s", ta.вТкст0());
            Выражение ea = выражение_ли(o);
            if (ea)
                printf("exp: %s", ea.вТкст0());

            assert(!кортеж_ли(o)); // no nested Tuple arguments
        }
        printf("]\n");
    }

    override КорневойОбъект specialization()
    {
        return null;
    }

    override КорневойОбъект defaultArg(Место instLoc, Scope* sc)
    {
        return null;
    }

    override бул hasDefaultArg()
    {
        return нет;
    }

    override ук dummyArg()
    {
        return null;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
 * https://dlang.org/spec/template.html#explicit_tmp_instantiation
 * Given:
 *  foo!(args) =>
 *      имя = foo
 *      tiargs = args
 */
 class TemplateInstance : ScopeDsymbol
{
    Идентификатор2 имя;

    // МассивДРК of Types/Выражения of template
    // instance arguments [цел*, сим, 10*10]
    Объекты* tiargs;

    // МассивДРК of Types/Выражения corresponding
    // to TemplateDeclaration.parameters
    // [цел, сим, 100]
    Объекты tdtypes;

    // Modules imported by this template instance
    Modules importedModules;

    ДСимвол tempdecl;           // referenced by foo.bar.abc
    ДСимвол enclosing;          // if referencing local symbols, this is the context
    ДСимвол aliasdecl;          // !=null if instance is an alias for its sole member
    TemplateInstance inst;      // refer to existing instance
    ScopeDsymbol argsym;        // argument symbol table
    цел inuse;                  // for recursive expansion detection
    цел nest;                   // for recursive pretty printing detection
    бул semantictiargsdone;    // has semanticTiargs() been done?
    бул havetempdecl;          // if используется second constructor
    бул gagged;                // if the instantiation is done with error gagging
    т_мера хэш;                // cached результат of toHash()
    Выражения* fargs;         // for function template, these are the function arguments

    TemplateInstances* deferred;

    Module memberOf;            // if !null, then this TemplateInstance appears in memberOf.члены[]

    // Used to determine the instance needs code generation.
    // Note that these are inaccurate until semantic analysis phase completed.
    TemplateInstance tinst;     // enclosing template instance
    TemplateInstance tnext;     // non-first instantiated instances
    Module minst;               // the top module that instantiated this instance

    this(ref Место место, Идентификатор2 идент, Объекты* tiargs)
    {
        super(место, null);
        static if (LOG)
        {
            printf("TemplateInstance(this = %p, идент = '%s')\n", this, идент ? идент.вТкст0() : "null");
        }
        this.имя = идент;
        this.tiargs = tiargs;
    }

    /*****************
     * This constructor is only called when we figured out which function
     * template to instantiate.
     */
    this(ref Место место, TemplateDeclaration td, Объекты* tiargs)
    {
        super(место, null);
        static if (LOG)
        {
            printf("TemplateInstance(this = %p, tempdecl = '%s')\n", this, td.вТкст0());
        }
        this.имя = td.идент;
        this.tiargs = tiargs;
        this.tempdecl = td;
        this.semantictiargsdone = да;
        this.havetempdecl = да;
        assert(tempdecl._scope);
    }

    extern (D) static Объекты* arraySyntaxCopy(Объекты* objs)
    {
        Объекты* a = null;
        if (objs)
        {
            a = new Объекты(objs.dim);
            for (т_мера i = 0; i < objs.dim; i++)
                (*a)[i] = objectSyntaxCopy((*objs)[i]);
        }
        return a;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        TemplateInstance ti = s ? cast(TemplateInstance)s : new TemplateInstance(место, имя, null);
        ti.tiargs = arraySyntaxCopy(tiargs);
        TemplateDeclaration td;
        if (inst && tempdecl && (td = tempdecl.isTemplateDeclaration()) !is null)
            td.ScopeDsymbol.syntaxCopy(ti);
        else
            ScopeDsymbol.syntaxCopy(ti);
        return ti;
    }

    // resolve real symbol
    override final ДСимвол toAlias()
    {
        static if (LOG)
        {
            printf("TemplateInstance.toAlias()\n");
        }
        if (!inst)
        {
            // Maybe we can resolve it
            if (_scope)
            {
                dsymbolSemantic(this, _scope);
            }
            if (!inst)
            {
                выведиОшибку("cannot resolve forward reference");
                errors = да;
                return this;
            }
        }

        if (inst != this)
            return inst.toAlias();

        if (aliasdecl)
        {
            return aliasdecl.toAlias();
        }

        return inst;
    }

    override ткст0 вид()
    {
        return "template instance";
    }

    override бул oneMember(ДСимвол* ps, Идентификатор2 идент)
    {
        *ps = null;
        return да;
    }

    override ткст0 вТкст0()
    {
        БуфВыв буф;
        toCBufferInstance(this, &буф);
        return буф.extractChars();
    }

    override final ткст0 toPrettyCharsHelper()
    {
        БуфВыв буф;
        toCBufferInstance(this, &буф, да);
        return буф.extractChars();
    }

    /**************************************
     * Given an error instantiating the TemplateInstance,
     * give the nested TemplateInstance instantiations that got
     * us here. Those are a list threaded into the nested scopes.
     */
    final проц printInstantiationTrace()
    {
        if (глоб2.gag)
            return;

        const бцел max_shown = 6;
        ткст0 format = "instantiated from here: `%s`";

        // determine instantiation depth and number of recursive instantiations
        цел n_instantiations = 1;
        цел n_totalrecursions = 0;
        for (TemplateInstance cur = this; cur; cur = cur.tinst)
        {
            ++n_instantiations;
            // If two instantiations use the same declaration, they are recursive.
            // (this works even if they are instantiated from different places in the
            // same template).
            // In principle, we could also check for multiple-template recursion, but it's
            // probably not worthwhile.
            if (cur.tinst && cur.tempdecl && cur.tinst.tempdecl && cur.tempdecl.место.равен(cur.tinst.tempdecl.место))
                ++n_totalrecursions;
        }

        // show full trace only if it's short or verbose is on
        if (n_instantiations <= max_shown || глоб2.парамы.verbose)
        {
            for (TemplateInstance cur = this; cur; cur = cur.tinst)
            {
                cur.errors = да;
                errorSupplemental(cur.место, format, cur.вТкст0());
            }
        }
        else if (n_instantiations - n_totalrecursions <= max_shown)
        {
            // By collapsing recursive instantiations into a single line,
            // we can stay under the limit.
            цел recursionDepth = 0;
            for (TemplateInstance cur = this; cur; cur = cur.tinst)
            {
                cur.errors = да;
                if (cur.tinst && cur.tempdecl && cur.tinst.tempdecl && cur.tempdecl.место.равен(cur.tinst.tempdecl.место))
                {
                    ++recursionDepth;
                }
                else
                {
                    if (recursionDepth)
                        errorSupplemental(cur.место, "%d recursive instantiations from here: `%s`", recursionDepth + 2, cur.вТкст0());
                    else
                        errorSupplemental(cur.место, format, cur.вТкст0());
                    recursionDepth = 0;
                }
            }
        }
        else
        {
            // Even after collapsing the recursions, the depth is too deep.
            // Just display the first few and last few instantiations.
            бцел i = 0;
            for (TemplateInstance cur = this; cur; cur = cur.tinst)
            {
                cur.errors = да;

                if (i == max_shown / 2)
                    errorSupplemental(cur.место, "... (%d instantiations, -v to show) ...", n_instantiations - max_shown);

                if (i < max_shown / 2 || i >= n_instantiations - max_shown + max_shown / 2)
                    errorSupplemental(cur.место, format, cur.вТкст0());
                ++i;
            }
        }
    }

    /*************************************
     * Lazily generate идентификатор for template instance.
     * This is because 75% of the идент's are never needed.
     */
    override final Идентификатор2 getIdent()
    {
        if (!идент && inst && !errors)
            идент = genIdent(tiargs); // need an идентификатор for имя mangling purposes.
        return идент;
    }

    /*************************************
     * Compare proposed template instantiation with existing template instantiation.
     * Note that this is not commutative because of the auto ref check.
     * Параметры:
     *  ti = existing template instantiation
     * Возвращает:
     *  да for match
     */
    final бул equalsx(TemplateInstance ti)
    {
        //printf("this = %p, ti = %p\n", this, ti);
        assert(tdtypes.dim == ti.tdtypes.dim);

        // Nesting must match
        if (enclosing != ti.enclosing)
        {
            //printf("test2 enclosing %s ti.enclosing %s\n", enclosing ? enclosing.вТкст0() : "", ti.enclosing ? ti.enclosing.вТкст0() : "");
            goto Lnotequals;
        }
        //printf("родитель = %s, ti.родитель = %s\n", родитель.toPrettyChars(), ti.родитель.toPrettyChars());

        if (!arrayObjectMatch(&tdtypes, &ti.tdtypes))
            goto Lnotequals;

        /* Template functions may have different instantiations based on
         * "auto ref" parameters.
         */
        if (auto fd = ti.toAlias().isFuncDeclaration())
        {
            if (!fd.errors)
            {
                auto fparameters = fd.getParameterList();
                т_мера nfparams = fparameters.length;   // Num function parameters
                for (т_мера j = 0; j < nfparams; j++)
                {
                    Параметр2 fparam = fparameters[j];
                    if (fparam.классХранения & STC.autoref)       // if "auto ref"
                    {
                        Выражение farg = fargs && j < fargs.dim ? (*fargs)[j] : fparam.defaultArg;
                        if (!farg)
                            goto Lnotequals;
                        if (farg.isLvalue())
                        {
                            if (!(fparam.классХранения & STC.ref_))
                                goto Lnotequals; // auto ref's don't match
                        }
                        else
                        {
                            if (fparam.классХранения & STC.ref_)
                                goto Lnotequals; // auto ref's don't match
                        }
                    }
                }
            }
        }
        return да;

    Lnotequals:
        return нет;
    }

    final т_мера toHash()
    {
        if (!хэш)
        {
            хэш = cast(т_мера)cast(ук)enclosing;
            хэш += arrayObjectHash(&tdtypes);
            хэш += хэш == 0;
        }
        return хэш;
    }

    /***********************************************
     * Возвращает да if this is not instantiated in non-root module, and
     * is a part of non-speculative instantiatiation.
     *
     * Note: minst does not stabilize until semantic analysis is completed,
     * so don't call this function during semantic analysis to return precise результат.
     */
    final бул needsCodegen()
    {
        // Now -allInst is just for the backward compatibility.
        if (глоб2.парамы.allInst)
        {
            //printf("%s minst = %s, enclosing (%s).isNonRoot = %d\n",
            //    toPrettyChars(), minst ? minst.вТкст0() : NULL,
            //    enclosing ? enclosing.toPrettyChars() : NULL, enclosing && enclosing.inNonRoot());
            if (enclosing)
            {
                /* https://issues.dlang.org/show_bug.cgi?ид=14588
                 * If the captured context is not a function
                 * (e.g. class), the instance layout determination is guaranteed,
                 * because the semantic/semantic2 pass will be executed
                 * even for non-root instances.
                 */
                if (!enclosing.isFuncDeclaration())
                    return да;

                /* https://issues.dlang.org/show_bug.cgi?ид=14834
                 * If the captured context is a function,
                 * this excessive instantiation may cause ODR violation, because
                 * -allInst and others doesn't guarantee the semantic3 execution
                 * for that function.
                 *
                 * If the enclosing is also an instantiated function,
                 * we have to rely on the ancestor's needsCodegen() результат.
                 */
                if (TemplateInstance ti = enclosing.isInstantiated())
                    return ti.needsCodegen();

                /* https://issues.dlang.org/show_bug.cgi?ид=13415
                 * If and only if the enclosing scope needs codegen,
                 * this nested templates would also need code generation.
                 */
                return !enclosing.inNonRoot();
            }
            return да;
        }

        if (!minst)
        {
            // If this is a speculative instantiation,
            // 1. do codegen if ancestors really needs codegen.
            // 2. become non-speculative if siblings are not speculative

            TemplateInstance tnext = this.tnext;
            TemplateInstance tinst = this.tinst;
            // At first, disconnect chain first to prevent infinite recursion.
            this.tnext = null;
            this.tinst = null;

            // Determine necessity of tinst before tnext.
            if (tinst && tinst.needsCodegen())
            {
                minst = tinst.minst; // cache результат
                assert(minst);
                assert(minst.isRoot() || minst.rootImports());
                return да;
            }
            if (tnext && (tnext.needsCodegen() || tnext.minst))
            {
                minst = tnext.minst; // cache результат
                assert(minst);
                return minst.isRoot() || minst.rootImports();
            }

            // Elide codegen because this is really speculative.
            return нет;
        }

        /* Even when this is reached to the codegen pass,
         * a non-root nested template should not generate code,
         * due to avoid ODR violation.
         */
        if (enclosing && enclosing.inNonRoot())
        {
            if (tinst)
            {
                auto r = tinst.needsCodegen();
                minst = tinst.minst; // cache результат
                return r;
            }
            if (tnext)
            {
                auto r = tnext.needsCodegen();
                minst = tnext.minst; // cache результат
                return r;
            }
            return нет;
        }

        /* The issue is that if the importee is compiled with a different -debug
         * setting than the importer, the importer may believe it exists
         * in the compiled importee when it does not, when the instantiation
         * is behind a conditional debug declaration.
         */
        // workaround for https://issues.dlang.org/show_bug.cgi?ид=11239
        if (глоб2.парамы.useUnitTests ||
            глоб2.парамы.debuglevel)
        {
            // Prefer instantiations from root modules, to maximize link-ability.
            if (minst.isRoot())
                return да;

            TemplateInstance tnext = this.tnext;
            TemplateInstance tinst = this.tinst;
            this.tnext = null;
            this.tinst = null;

            if (tinst && tinst.needsCodegen())
            {
                minst = tinst.minst; // cache результат
                assert(minst);
                assert(minst.isRoot() || minst.rootImports());
                return да;
            }
            if (tnext && tnext.needsCodegen())
            {
                minst = tnext.minst; // cache результат
                assert(minst);
                assert(minst.isRoot() || minst.rootImports());
                return да;
            }

            // https://issues.dlang.org/show_bug.cgi?ид=2500 case
            if (minst.rootImports())
                return да;

            // Elide codegen because this is not included in root instances.
            return нет;
        }
        else
        {
            // Prefer instantiations from non-root module, to minimize объект code size.

            /* If a TemplateInstance is ever instantiated by non-root modules,
             * we do not have to generate code for it,
             * because it will be generated when the non-root module is compiled.
             *
             * But, if the non-root 'minst' imports any root modules, it might still need codegen.
             *
             * The problem is if A imports B, and B imports A, and both A
             * and B instantiate the same template, does the compilation of A
             * or the compilation of B do the actual instantiation?
             *
             * See https://issues.dlang.org/show_bug.cgi?ид=2500.
             */
            if (!minst.isRoot() && !minst.rootImports())
                return нет;

            TemplateInstance tnext = this.tnext;
            this.tnext = null;

            if (tnext && !tnext.needsCodegen() && tnext.minst)
            {
                minst = tnext.minst; // cache результат
                assert(!minst.isRoot());
                return нет;
            }

            // Do codegen because this is not included in non-root instances.
            return да;
        }
    }

    /**********************************************
     * Find template declaration corresponding to template instance.
     *
     * Возвращает:
     *      нет if finding fails.
     * Note:
     *      This function is reentrant against error occurrence. If returns нет,
     *      any члены of this объект won't be modified, and repetition call will
     *      reproduce same error.
     */
    extern (D) final бул findTempDecl(Scope* sc, WithScopeSymbol* pwithsym)
    {
        if (pwithsym)
            *pwithsym = null;

        if (havetempdecl)
            return да;

        //printf("TemplateInstance.findTempDecl() %s\n", вТкст0());
        if (!tempdecl)
        {
            /* Given:
             *    foo!( ... )
             * figure out which TemplateDeclaration foo refers to.
             */
            Идентификатор2 ид = имя;
            ДСимвол scopesym;
            ДСимвол s = sc.search(место, ид, &scopesym);
            if (!s)
            {
                s = sc.search_correct(ид);
                if (s)
                    выведиОшибку("template `%s` is not defined, did you mean %s?", ид.вТкст0(), s.вТкст0());
                else
                    выведиОшибку("template `%s` is not defined", ид.вТкст0());
                return нет;
            }
            static if (LOG)
            {
                printf("It's an instance of '%s' вид '%s'\n", s.вТкст0(), s.вид());
                if (s.родитель)
                    printf("s.родитель = '%s'\n", s.родитель.вТкст0());
            }
            if (pwithsym)
                *pwithsym = scopesym.isWithScopeSymbol();

            /* We might have found an alias within a template when
             * we really want the template.
             */
            TemplateInstance ti;
            if (s.родитель && (ti = s.родитель.isTemplateInstance()) !is null)
            {
                if (ti.tempdecl && ti.tempdecl.идент == ид)
                {
                    /* This is so that one can refer to the enclosing
                     * template, even if it has the same имя as a member
                     * of the template, if it has a !(arguments)
                     */
                    TemplateDeclaration td = ti.tempdecl.isTemplateDeclaration();
                    assert(td);
                    if (td.overroot) // if not start of overloaded list of TemplateDeclaration's
                        td = td.overroot; // then get the start
                    s = td;
                }
            }

            if (!updateTempDecl(sc, s))
            {
                return нет;
            }
        }
        assert(tempdecl);

        // Look for forward references
        auto tovers = tempdecl.isOverloadSet();
        foreach (т_мера oi; new бцел[0 .. tovers] ? tovers.a.dim : 1)
        {
            ДСимвол dstart = tovers ? tovers.a[oi] : tempdecl;
            цел r = overloadApply(dstart, (ДСимвол s)
            {
                auto td = s.isTemplateDeclaration();
                if (!td)
                    return 0;

                if (td.semanticRun == PASS.init)
                {
                    if (td._scope)
                    {
                        // Try to fix forward reference. Ungag errors while doing so.
                        Ungag ungag = td.ungagSpeculative();
                        td.dsymbolSemantic(td._scope);
                    }
                    if (td.semanticRun == PASS.init)
                    {
                        выведиОшибку("`%s` forward references template declaration `%s`",
                            вТкст0(), td.вТкст0());
                        return 1;
                    }
                }
                return 0;
            });
            if (r)
                return нет;
        }
        return да;
    }

    /**********************************************
     * Confirm s is a valid template, then store it.
     * Input:
     *      sc
     *      s   candidate symbol of template. It may be:
     *          TemplateDeclaration
     *          FuncDeclaration with findTemplateDeclRoot() != NULL
     *          OverloadSet which содержит candidates
     * Возвращает:
     *      да if updating succeeds.
     */
    extern (D) final бул updateTempDecl(Scope* sc, ДСимвол s)
    {
        if (s)
        {
            Идентификатор2 ид = имя;
            s = s.toAlias();

            /* If an OverloadSet, look for a unique member that is a template declaration
             */
            OverloadSet ос = s.isOverloadSet();
            if (ос)
            {
                s = null;
                for (т_мера i = 0; i < ос.a.dim; i++)
                {
                    ДСимвол s2 = ос.a[i];
                    if (FuncDeclaration f = s2.isFuncDeclaration())
                        s2 = f.findTemplateDeclRoot();
                    else
                        s2 = s2.isTemplateDeclaration();
                    if (s2)
                    {
                        if (s)
                        {
                            tempdecl = ос;
                            return да;
                        }
                        s = s2;
                    }
                }
                if (!s)
                {
                    выведиОшибку("template `%s` is not defined", ид.вТкст0());
                    return нет;
                }
            }

            OverDeclaration od = s.isOverDeclaration();
            if (od)
            {
                tempdecl = od; // TODO: more strict check
                return да;
            }

            /* It should be a TemplateDeclaration, not some other symbol
             */
            if (FuncDeclaration f = s.isFuncDeclaration())
                tempdecl = f.findTemplateDeclRoot();
            else
                tempdecl = s.isTemplateDeclaration();
            if (!tempdecl)
            {
                if (!s.родитель && глоб2.errors)
                    return нет;
                if (!s.родитель && s.getType())
                {
                    ДСимвол s2 = s.getType().toDsymbol(sc);
                    if (!s2)
                    {
                        .выведиОшибку(место, "`%s` is not a valid template instance, because `%s` is not a template declaration but a тип (`%s == %s`)", вТкст0(), ид.вТкст0(), ид.вТкст0(), s.getType.вид());
                        return нет;
                    }
                    // because s can be the alias created for a ПараметрШаблона2
                    const AliasDeclaration ad = s.isAliasDeclaration();
                    version (none)
                    {
                        if (ad && ad.wasTemplateParameter)
                            printf("`%s` is an alias created from a template параметр\n", s.вТкст0());
                    }
                    if (!ad || !ad.wasTemplateParameter)
                        s = s2;
                }
                debug
                {
                    //if (!s.родитель) printf("s = %s %s\n", s.вид(), s.вТкст0());
                }
                //assert(s.родитель);
                TemplateInstance ti = s.родитель ? s.родитель.isTemplateInstance() : null;
                if (ti && (ti.имя == s.идент || ti.toAlias().идент == s.идент) && ti.tempdecl)
                {
                    /* This is so that one can refer to the enclosing
                     * template, even if it has the same имя as a member
                     * of the template, if it has a !(arguments)
                     */
                    TemplateDeclaration td = ti.tempdecl.isTemplateDeclaration();
                    assert(td);
                    if (td.overroot) // if not start of overloaded list of TemplateDeclaration's
                        td = td.overroot; // then get the start
                    tempdecl = td;
                }
                else
                {
                    выведиОшибку("`%s` is not a template declaration, it is a %s", ид.вТкст0(), s.вид());
                    return нет;
                }
            }
        }
        return (tempdecl !is null);
    }

    /**********************************
     * Run semantic of tiargs as arguments of template.
     * Input:
     *      место
     *      sc
     *      tiargs  массив of template arguments
     *      flags   1: replace const variables with their initializers
     *              2: don't devolve Параметр2 to Тип
     * Возвращает:
     *      нет if one or more arguments have errors.
     */
    extern (D) static бул semanticTiargs(ref Место место, Scope* sc, Объекты* tiargs, цел flags)
    {
        // Run semantic on each argument, place результатs in tiargs[]
        //printf("+TemplateInstance.semanticTiargs()\n");
        if (!tiargs)
            return да;
        бул err = нет;
        for (т_мера j = 0; j < tiargs.dim; j++)
        {
            КорневойОбъект o = (*tiargs)[j];
            Тип ta = тип_ли(o);
            Выражение ea = выражение_ли(o);
            ДСимвол sa = isDsymbol(o);

            //printf("1: (*tiargs)[%d] = %p, s=%p, v=%p, ea=%p, ta=%p\n", j, o, isDsymbol(o), кортеж_ли(o), ea, ta);
            if (ta)
            {
                //printf("тип %s\n", ta.вТкст0());

                // It might really be an Выражение or an Alias
                ta.resolve(место, sc, &ea, &ta, &sa, (flags & 1) != 0);
                if (ea)
                    goto Lexpr;
                if (sa)
                    goto Ldsym;
                if (ta is null)
                {
                    assert(глоб2.errors);
                    ta = Тип.terror;
                }

            Ltype:
                if (ta.ty == Ttuple)
                {
                    // Expand кортеж
                    КортежТипов tt = cast(КортежТипов)ta;
                    т_мера dim = tt.arguments.dim;
                    tiargs.удали(j);
                    if (dim)
                    {
                        tiargs.резервируй(dim);
                        for (т_мера i = 0; i < dim; i++)
                        {
                            Параметр2 arg = (*tt.arguments)[i];
                            if (flags & 2 && (arg.идент || arg.userAttribDecl))
                                tiargs.вставь(j + i, arg);
                            else
                                tiargs.вставь(j + i, arg.тип);
                        }
                    }
                    j--;
                    continue;
                }
                if (ta.ty == Terror)
                {
                    err = да;
                    continue;
                }
                (*tiargs)[j] = ta.merge2();
            }
            else if (ea)
            {
            Lexpr:
                //printf("+[%d] ea = %s %s\n", j, Сема2.вТкст0(ea.op), ea.вТкст0());
                if (flags & 1) // only используется by __traits
                {
                    ea = ea.ВыражениеSemantic(sc);

                    // must not interpret the args, excepting template parameters
                    if (ea.op != ТОК2.variable || ((cast(VarExp)ea).var.класс_хранения & STC.шаблонпараметр))
                    {
                        ea = ea.optimize(WANTvalue);
                    }
                }
                else
                {
                    sc = sc.startCTFE();
                    ea = ea.ВыражениеSemantic(sc);
                    sc = sc.endCTFE();

                    if (ea.op == ТОК2.variable)
                    {
                        /* This test is to skip substituting a const var with
                         * its инициализатор. The problem is the инициализатор won't
                         * match with an 'alias' параметр. Instead, do the
                         * const substitution in TemplateValueParameter.matchArg().
                         */
                    }
                    else if (definitelyValueParameter(ea))
                    {
                        if (ea.checkValue()) // check проц Выражение
                            ea = new ErrorExp();
                        бцел olderrs = глоб2.errors;
                        ea = ea.ctfeInterpret();
                        if (глоб2.errors != olderrs)
                            ea = new ErrorExp();
                    }
                }
                //printf("-[%d] ea = %s %s\n", j, Сема2.вТкст0(ea.op), ea.вТкст0());
                if (ea.op == ТОК2.кортеж)
                {
                    // Expand кортеж
                    TupleExp te = cast(TupleExp)ea;
                    т_мера dim = te.exps.dim;
                    tiargs.удали(j);
                    if (dim)
                    {
                        tiargs.резервируй(dim);
                        for (т_мера i = 0; i < dim; i++)
                            tiargs.вставь(j + i, (*te.exps)[i]);
                    }
                    j--;
                    continue;
                }
                if (ea.op == ТОК2.error)
                {
                    err = да;
                    continue;
                }
                (*tiargs)[j] = ea;

                if (ea.op == ТОК2.тип)
                {
                    ta = ea.тип;
                    goto Ltype;
                }
                if (ea.op == ТОК2.scope_)
                {
                    sa = (cast(ScopeExp)ea).sds;
                    goto Ldsym;
                }
                if (ea.op == ТОК2.function_)
                {
                    FuncExp fe = cast(FuncExp)ea;
                    /* A function literal, that is passed to template and
                     * already semanticed as function pointer, never requires
                     * outer frame. So convert it to глоб2 function is valid.
                     */
                    if (fe.fd.tok == ТОК2.reserved && fe.тип.ty == Tpointer)
                    {
                        // change to non-nested
                        fe.fd.tok = ТОК2.function_;
                        fe.fd.vthis = null;
                    }
                    else if (fe.td)
                    {
                        /* If template argument is a template lambda,
                         * get template declaration itself. */
                        //sa = fe.td;
                        //goto Ldsym;
                    }
                }
                if (ea.op == ТОК2.dotVariable && !(flags & 1))
                {
                    // translate Выражение to дсимвол.
                    sa = (cast(DotVarExp)ea).var;
                    goto Ldsym;
                }
                if (ea.op == ТОК2.template_)
                {
                    sa = (cast(TemplateExp)ea).td;
                    goto Ldsym;
                }
                if (ea.op == ТОК2.dotTemplateDeclaration && !(flags & 1))
                {
                    // translate Выражение to дсимвол.
                    sa = (cast(DotTemplateExp)ea).td;
                    goto Ldsym;
                }
            }
            else if (sa)
            {
            Ldsym:
                //printf("dsym %s %s\n", sa.вид(), sa.вТкст0());
                if (sa.errors)
                {
                    err = да;
                    continue;
                }

                TupleDeclaration d = sa.toAlias().isTupleDeclaration();
                if (d)
                {
                    // Expand кортеж
                    tiargs.удали(j);
                    tiargs.вставь(j, d.objects);
                    j--;
                    continue;
                }
                if (FuncAliasDeclaration fa = sa.isFuncAliasDeclaration())
                {
                    FuncDeclaration f = fa.toAliasFunc();
                    if (!fa.hasOverloads && f.isUnique())
                    {
                        // Strip FuncAlias only when the aliased function
                        // does not have any overloads.
                        sa = f;
                    }
                }
                (*tiargs)[j] = sa;

                TemplateDeclaration td = sa.isTemplateDeclaration();
                if (td && td.semanticRun == PASS.init && td.literal)
                {
                    td.dsymbolSemantic(sc);
                }
                FuncDeclaration fd = sa.isFuncDeclaration();
                if (fd)
                    fd.functionSemantic();
            }
            else if (isParameter(o))
            {
            }
            else
            {
                assert(0);
            }
            //printf("1: (*tiargs)[%d] = %p\n", j, (*tiargs)[j]);
        }
        version (none)
        {
            printf("-TemplateInstance.semanticTiargs()\n");
            for (т_мера j = 0; j < tiargs.dim; j++)
            {
                КорневойОбъект o = (*tiargs)[j];
                Тип ta = тип_ли(o);
                Выражение ea = выражение_ли(o);
                ДСимвол sa = isDsymbol(o);
                Tuple va = кортеж_ли(o);
                printf("\ttiargs[%d] = ta %p, ea %p, sa %p, va %p\n", j, ta, ea, sa, va);
            }
        }
        return !err;
    }

    /**********************************
     * Run semantic on the elements of tiargs.
     * Input:
     *      sc
     * Возвращает:
     *      нет if one or more arguments have errors.
     * Note:
     *      This function is reentrant against error occurrence. If returns нет,
     *      all elements of tiargs won't be modified.
     */
    extern (D) final бул semanticTiargs(Scope* sc)
    {
        //printf("+TemplateInstance.semanticTiargs() %s\n", вТкст0());
        if (semantictiargsdone)
            return да;
        if (semanticTiargs(место, sc, tiargs, 0))
        {
            // cache the результат iff semantic analysis succeeded entirely
            semantictiargsdone = 1;
            return да;
        }
        return нет;
    }

    extern (D) final бул findBestMatch(Scope* sc, Выражения* fargs)
    {
        if (havetempdecl)
        {
            TemplateDeclaration tempdecl = this.tempdecl.isTemplateDeclaration();
            assert(tempdecl);
            assert(tempdecl._scope);
            // Deduce tdtypes
            tdtypes.устДим(tempdecl.parameters.dim);
            if (!tempdecl.matchWithInstance(sc, this, &tdtypes, fargs, 2))
            {
                выведиОшибку("incompatible arguments for template instantiation");
                return нет;
            }
            // TODO: Normalizing tiargs for https://issues.dlang.org/show_bug.cgi?ид=7469 is necessary?
            return да;
        }

        static if (LOG)
        {
            printf("TemplateInstance.findBestMatch()\n");
        }

        бцел errs = глоб2.errors;
        TemplateDeclaration td_last = null;
        Объекты dedtypes;

        /* Since there can be multiple TemplateDeclaration's with the same
         * имя, look for the best match.
         */
        auto tovers = tempdecl.isOverloadSet();
        foreach (т_мера oi; new бцел[0 .. tovers] ? tovers.a.dim : 1)
        {
            TemplateDeclaration td_best;
            TemplateDeclaration td_ambig;
            MATCH m_best = MATCH.nomatch;

            ДСимвол dstart = tovers ? tovers.a[oi] : tempdecl;
            overloadApply(dstart, (ДСимвол s)
            {
                auto td = s.isTemplateDeclaration();
                if (!td)
                    return 0;
                if (td.inuse)
                {
                    td.выведиОшибку(место, "recursive template expansion");
                    return 1;
                }
                if (td == td_best)   // skip duplicates
                    return 0;

                //printf("td = %s\n", td.toPrettyChars());
                // If more arguments than parameters,
                // then this is no match.
                if (td.parameters.dim < tiargs.dim)
                {
                    if (!td.isVariadic())
                        return 0;
                }

                dedtypes.устДим(td.parameters.dim);
                dedtypes.нуль();
                assert(td.semanticRun != PASS.init);

                MATCH m = td.matchWithInstance(sc, this, &dedtypes, fargs, 0);
                //printf("matchWithInstance = %d\n", m);
                if (m <= MATCH.nomatch) // no match at all
                    return 0;
                if (m < m_best) goto Ltd_best;
                if (m > m_best) goto Ltd;

                // Disambiguate by picking the most specialized TemplateDeclaration
                {
                MATCH c1 = td.leastAsSpecialized(sc, td_best, fargs);
                MATCH c2 = td_best.leastAsSpecialized(sc, td, fargs);
                //printf("c1 = %d, c2 = %d\n", c1, c2);
                if (c1 > c2) goto Ltd;
                if (c1 < c2) goto Ltd_best;
                }

                td_ambig = td;
                return 0;

            Ltd_best:
                // td_best is the best match so far
                td_ambig = null;
                return 0;

            Ltd:
                // td is the new best match
                td_ambig = null;
                td_best = td;
                m_best = m;
                tdtypes.устДим(dedtypes.dim);
                memcpy(tdtypes.tdata(), dedtypes.tdata(), tdtypes.dim * (ук).sizeof);
                return 0;
            });

            if (td_ambig)
            {
                .выведиОшибку(место, "%s `%s.%s` matches more than one template declaration:\n%s:     `%s`\nand\n%s:     `%s`",
                    td_best.вид(), td_best.родитель.toPrettyChars(), td_best.идент.вТкст0(),
                    td_best.место.вТкст0(), td_best.вТкст0(),
                    td_ambig.место.вТкст0(), td_ambig.вТкст0());
                return нет;
            }
            if (td_best)
            {
                if (!td_last)
                    td_last = td_best;
                else if (td_last != td_best)
                {
                    ScopeDsymbol.multiplyDefined(место, td_last, td_best);
                    return нет;
                }
            }
        }

        if (td_last)
        {
            /* https://issues.dlang.org/show_bug.cgi?ид=7469
             * Normalize tiargs by using corresponding deduced
             * template значение parameters and tuples for the correct mangling.
             *
             * By doing this before hasNestedArgs, CTFEable local variable will be
             * accepted as a значение параметр. For example:
             *
             *  проц foo() {
             *    struct S(цел n) {}   // non-глоб2 template
             *    const цел num = 1;   // CTFEable local variable
             *    S!num s;             // S!1 is instantiated, not S!num
             *  }
             */
            т_мера dim = td_last.parameters.dim - (td_last.isVariadic() ? 1 : 0);
            for (т_мера i = 0; i < dim; i++)
            {
                if (tiargs.dim <= i)
                    tiargs.сунь(tdtypes[i]);
                assert(i < tiargs.dim);

                auto tvp = (*td_last.parameters)[i].isTemplateValueParameter();
                if (!tvp)
                    continue;
                assert(tdtypes[i]);
                // tdtypes[i] is already normalized to the required тип in matchArg

                (*tiargs)[i] = tdtypes[i];
            }
            if (td_last.isVariadic() && tiargs.dim == dim && tdtypes[dim])
            {
                Tuple va = кортеж_ли(tdtypes[dim]);
                assert(va);
                tiargs.суньСрез(va.objects[]);
            }
        }
        else if (errors && inst)
        {
            // instantiation was failed with error reporting
            assert(глоб2.errors);
            return нет;
        }
        else
        {
            auto tdecl = tempdecl.isTemplateDeclaration();

            if (errs != глоб2.errors)
                errorSupplemental(место, "while looking for match for `%s`", вТкст0());
            else if (tdecl && !tdecl.overnext)
            {
                // Only one template, so we can give better error message
                ткст0 msg = "does not match template declaration";
                ткст0 tip;
                const tmsg = tdecl.toCharsNoConstraints();
                const cmsg = tdecl.getConstraintEvalError(tip);
                if (cmsg)
                {
                    выведиОшибку("%s `%s`\n%s", msg, tmsg, cmsg);
                    if (tip)
                        .tip(tip);
                }
                else
                    выведиОшибку("%s `%s`", msg, tmsg);
            }
            else
                .выведиОшибку(место, "%s `%s.%s` does not match any template declaration", tempdecl.вид(), tempdecl.родитель.toPrettyChars(), tempdecl.идент.вТкст0());
            return нет;
        }

        /* The best match is td_last
         */
        tempdecl = td_last;

        static if (LOG)
        {
            printf("\tIt's a match with template declaration '%s'\n", tempdecl.вТкст0());
        }
        return (errs == глоб2.errors);
    }

    /*****************************************************
     * Determine if template instance is really a template function,
     * and that template function needs to infer types from the function
     * arguments.
     *
     * Like findBestMatch, iterate possible template candidates,
     * but just looks only the necessity of тип inference.
     */
    extern (D) final бул needsTypeInference(Scope* sc, цел флаг = 0)
    {
        //printf("TemplateInstance.needsTypeInference() %s\n", вТкст0());
        if (semanticRun != PASS.init)
            return нет;

        бцел olderrs = глоб2.errors;
        Объекты dedtypes;
        т_мера count = 0;

        auto tovers = tempdecl.isOverloadSet();
        foreach (т_мера oi; new бцел[0 .. tovers] ? tovers.a.dim : 1)
        {
            ДСимвол dstart = tovers ? tovers.a[oi] : tempdecl;
            цел r = overloadApply(dstart, (ДСимвол s)
            {
                auto td = s.isTemplateDeclaration();
                if (!td)
                    return 0;
                if (td.inuse)
                {
                    td.выведиОшибку(место, "recursive template expansion");
                    return 1;
                }

                /* If any of the overloaded template declarations need inference,
                 * then return да
                 */
                if (!td.onemember)
                    return 0;
                if (auto td2 = td.onemember.isTemplateDeclaration())
                {
                    if (!td2.onemember || !td2.onemember.isFuncDeclaration())
                        return 0;
                    if (tiargs.dim >= td.parameters.dim - (td.isVariadic() ? 1 : 0))
                        return 0;
                    return 1;
                }
                auto fd = td.onemember.isFuncDeclaration();
                if (!fd || fd.тип.ty != Tfunction)
                    return 0;

                foreach (tp; *td.parameters)
                {
                    if (tp.isTemplateThisParameter())
                        return 1;
                }

                /* Determine if the instance arguments, tiargs, are all that is necessary
                 * to instantiate the template.
                 */
                //printf("tp = %p, td.parameters.dim = %d, tiargs.dim = %d\n", tp, td.parameters.dim, tiargs.dim);
                auto tf = cast(TypeFunction)fd.тип;
                if (т_мера dim = tf.parameterList.length)
                {
                    auto tp = td.isVariadic();
                    if (tp && td.parameters.dim > 1)
                        return 1;

                    if (!tp && tiargs.dim < td.parameters.dim)
                    {
                        // Can remain tiargs be filled by default arguments?
                        foreach (т_мера i; new бцел[tiargs.dim .. td.parameters.dim])
                        {
                            if (!(*td.parameters)[i].hasDefaultArg())
                                return 1;
                        }
                    }

                    foreach (т_мера i; new бцел[0 .. dim])
                    {
                        // 'auto ref' needs inference.
                        if (tf.parameterList[i].классХранения & STC.auto_)
                            return 1;
                    }
                }

                if (!флаг)
                {
                    /* Calculate the need for overload resolution.
                     * When only one template can match with tiargs, inference is not necessary.
                     */
                    dedtypes.устДим(td.parameters.dim);
                    dedtypes.нуль();
                    if (td.semanticRun == PASS.init)
                    {
                        if (td._scope)
                        {
                            // Try to fix forward reference. Ungag errors while doing so.
                            Ungag ungag = td.ungagSpeculative();
                            td.dsymbolSemantic(td._scope);
                        }
                        if (td.semanticRun == PASS.init)
                        {
                            выведиОшибку("`%s` forward references template declaration `%s`", вТкст0(), td.вТкст0());
                            return 1;
                        }
                    }
                    MATCH m = td.matchWithInstance(sc, this, &dedtypes, null, 0);
                    if (m <= MATCH.nomatch)
                        return 0;
                }

                /* If there is more than one function template which matches, we may
                 * need тип inference (see https://issues.dlang.org/show_bug.cgi?ид=4430)
                 */
                return ++count > 1 ? 1 : 0;
            });
            if (r)
                return да;
        }

        if (olderrs != глоб2.errors)
        {
            if (!глоб2.gag)
            {
                errorSupplemental(место, "while looking for match for `%s`", вТкст0());
                semanticRun = PASS.semanticdone;
                inst = this;
            }
            errors = да;
        }
        //printf("нет\n");
        return нет;
    }

    /*****************************************
     * Determines if a TemplateInstance will need a nested
     * generation of the TemplateDeclaration.
     * Sets enclosing property if so, and returns != 0;
     */
    extern (D) final бул hasNestedArgs(Объекты* args, бул статичен_ли)
    {
        цел nested = 0;
        //printf("TemplateInstance.hasNestedArgs('%s')\n", tempdecl.идент.вТкст0());

        // arguments from родитель instances are also accessible
        if (!enclosing)
        {
            if (TemplateInstance ti = tempdecl.toParent().isTemplateInstance())
                enclosing = ti.enclosing;
        }

        /* A nested instance happens when an argument references a local
         * symbol that is on the stack.
         */
        for (т_мера i = 0; i < args.dim; i++)
        {
            КорневойОбъект o = (*args)[i];
            Выражение ea = выражение_ли(o);
            ДСимвол sa = isDsymbol(o);
            Tuple va = кортеж_ли(o);
            if (ea)
            {
                if (ea.op == ТОК2.variable)
                {
                    sa = (cast(VarExp)ea).var;
                    goto Lsa;
                }
                if (ea.op == ТОК2.this_)
                {
                    sa = (cast(ThisExp)ea).var;
                    goto Lsa;
                }
                if (ea.op == ТОК2.function_)
                {
                    if ((cast(FuncExp)ea).td)
                        sa = (cast(FuncExp)ea).td;
                    else
                        sa = (cast(FuncExp)ea).fd;
                    goto Lsa;
                }
                // Emulate Выражение.toMangleBuffer call that had exist in TemplateInstance.genIdent.
                if (ea.op != ТОК2.int64 && ea.op != ТОК2.float64 && ea.op != ТОК2.complex80 && ea.op != ТОК2.null_ && ea.op != ТОК2.string_ && ea.op != ТОК2.arrayLiteral && ea.op != ТОК2.assocArrayLiteral && ea.op != ТОК2.structLiteral)
                {
                    ea.выведиОшибку("Выражение `%s` is not a valid template значение argument", ea.вТкст0());
                    errors = да;
                }
            }
            else if (sa)
            {
            Lsa:
                sa = sa.toAlias();
                TemplateDeclaration td = sa.isTemplateDeclaration();
                if (td)
                {
                    TemplateInstance ti = sa.toParent().isTemplateInstance();
                    if (ti && ti.enclosing)
                        sa = ti;
                }
                TemplateInstance ti = sa.isTemplateInstance();
                Declaration d = sa.isDeclaration();
                if ((td && td.literal) || (ti && ti.enclosing) || (d && !d.isDataseg() && !(d.класс_хранения & STC.manifest) && (!d.isFuncDeclaration() || d.isFuncDeclaration().isNested()) && !isTemplateMixin()))
                {
                    ДСимвол dparent = sa.toParent2();
                    if (!dparent)
                        goto L1;
                    else if (!enclosing)
                        enclosing = dparent;
                    else if (enclosing != dparent)
                    {
                        /* Select the more deeply nested of the two.
                         * Error if one is not nested inside the other.
                         */
                        for (ДСимвол p = enclosing; p; p = p.родитель)
                        {
                            if (p == dparent)
                                goto L1; // enclosing is most nested
                        }
                        for (ДСимвол p = dparent; p; p = p.родитель)
                        {
                            if (p == enclosing)
                            {
                                enclosing = dparent;
                                goto L1; // dparent is most nested
                            }
                        }
                        выведиОшибку("`%s` is nested in both `%s` and `%s`", вТкст0(), enclosing.вТкст0(), dparent.вТкст0());
                        errors = да;
                    }
                L1:
                    //printf("\tnested inside %s\n", enclosing.вТкст0());
                    nested |= 1;
                }
            }
            else if (va)
            {
                nested |= cast(цел)hasNestedArgs(&va.objects, статичен_ли);
            }
        }
        //printf("-TemplateInstance.hasNestedArgs('%s') = %d\n", tempdecl.идент.вТкст0(), nested);
        return nested != 0;
    }

    /*****************************************
     * Append 'this' to the specific module члены[]
     */
    extern (D) final Дсимволы* appendToModuleMember()
    {
        Module mi = minst; // instantiated . inserted module

        if (глоб2.парамы.useUnitTests || глоб2.парамы.debuglevel)
        {
            // Turn all non-root instances to speculative
            if (mi && !mi.isRoot())
                mi = null;
        }

        //printf("%s.appendToModuleMember() enclosing = %s mi = %s\n",
        //    toPrettyChars(),
        //    enclosing ? enclosing.toPrettyChars() : null,
        //    mi ? mi.toPrettyChars() : null);
        if (!mi || mi.isRoot())
        {
            /* If the instantiated module is speculative or root, вставь to the
             * member of a root module. Then:
             *  - semantic3 pass will get called on the instance члены.
             *  - codegen pass will get a selection chance to do/skip it.
             */
            static ДСимвол getStrictEnclosing(TemplateInstance ti)
            {
                do
                {
                    if (ti.enclosing)
                        return ti.enclosing;
                    ti = ti.tempdecl.isInstantiated();
                } while (ti);
                return null;
            }

            ДСимвол enc = getStrictEnclosing(this);
            // вставь target is made stable by using the module
            // where tempdecl is declared.
            mi = (enc ? enc : tempdecl).getModule();
            if (!mi.isRoot())
                mi = mi.importedFrom;
            assert(mi.isRoot());
        }
        else
        {
            /* If the instantiated module is non-root, вставь to the member of the
             * non-root module. Then:
             *  - semantic3 pass won't be called on the instance.
             *  - codegen pass won't reach to the instance.
             */
        }
        //printf("\t-. mi = %s\n", mi.toPrettyChars());

        if (memberOf is mi)     // already a member
        {
            debug               // make sure it really is a member
            {
                auto a = mi.члены;
                for (т_мера i = 0; 1; ++i)
                {
                    assert(i != a.dim);
                    if (this == (*a)[i])
                        break;
                }
            }
            return null;
        }

        Дсимволы* a = mi.члены;
        a.сунь(this);
        memberOf = mi;
        if (mi.semanticRun >= PASS.semantic2done && mi.isRoot())
            Module.addDeferredSemantic2(this);
        if (mi.semanticRun >= PASS.semantic3done && mi.isRoot())
            Module.addDeferredSemantic3(this);
        return a;
    }

    /****************************************************
     * Declare parameters of template instance, initialize them with the
     * template instance arguments.
     */
    extern (D) final проц declareParameters(Scope* sc)
    {
        TemplateDeclaration tempdecl = this.tempdecl.isTemplateDeclaration();
        assert(tempdecl);

        //printf("TemplateInstance.declareParameters()\n");
        for (т_мера i = 0; i < tdtypes.dim; i++)
        {
            ПараметрШаблона2 tp = (*tempdecl.parameters)[i];
            //КорневойОбъект *o = (*tiargs)[i];
            КорневойОбъект o = tdtypes[i]; // инициализатор for tp

            //printf("\ttdtypes[%d] = %p\n", i, o);
            tempdecl.declareParameter(sc, tp, o);
        }
    }

    /****************************************
     * This instance needs an идентификатор for имя mangling purposes.
     * Create one by taking the template declaration имя and adding
     * the тип signature for it.
     */
    extern (D) final Идентификатор2 genIdent(Объекты* args)
    {
        //printf("TemplateInstance.genIdent('%s')\n", tempdecl.идент.вТкст0());
        assert(args is tiargs);
        БуфВыв буф;
        mangleToBuffer(this, &буф);
        //printf("\tgenIdent = %s\n", буф.peekChars());
        return Идентификатор2.idPool(буф[]);
    }

    extern (D) final проц expandMembers(Scope* sc2)
    {
        члены.foreachDsymbol( (s) { s.setScope (sc2); } );

        члены.foreachDsymbol( (s) { s.importAll(sc2); } );

        проц symbolDg(ДСимвол s)
        {
            //printf("\t[%d] semantic on '%s' %p вид %s in '%s'\n", i, s.вТкст0(), s, s.вид(), this.вТкст0());
            //printf("test: enclosing = %d, sc2.родитель = %s\n", enclosing, sc2.родитель.вТкст0());
            //if (enclosing)
            //    s.родитель = sc.родитель;
            //printf("test3: enclosing = %d, s.родитель = %s\n", enclosing, s.родитель.вТкст0());
            s.dsymbolSemantic(sc2);
            //printf("test4: enclosing = %d, s.родитель = %s\n", enclosing, s.родитель.вТкст0());
            Module.runDeferredSemantic();
        }

        члены.foreachDsymbol(&symbolDg);
    }

    extern (D) final проц tryExpandMembers(Scope* sc2)
    {
         цел nest;
        // extracted to a function to allow windows SEH to work without destructors in the same function
        //printf("%d\n", nest);
        if (++nest > глоб2.recursionLimit)
        {
            глоб2.gag = 0; // ensure error message gets printed
            выведиОшибку("recursive expansion exceeded allowed nesting limit");
            fatal();
        }

        expandMembers(sc2);

        nest--;
    }

    extern (D) final проц trySemantic3(Scope* sc2)
    {
        // extracted to a function to allow windows SEH to work without destructors in the same function
         цел nest;
        //printf("%d\n", nest);
        if (++nest > глоб2.recursionLimit)
        {
            глоб2.gag = 0; // ensure error message gets printed
            выведиОшибку("recursive expansion exceeded allowed nesting limit");
            fatal();
        }

        semantic3(this, sc2);

        --nest;
    }

    override final TemplateInstance isTemplateInstance()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/**************************************
 * IsВыражение can evaluate the specified тип speculatively, and even if
 * it instantiates any symbols, they are normally unnecessary for the
 * final executable.
 * However, if those symbols leak to the actual code, compiler should remark
 * them as non-speculative to generate their code and link to the final executable.
 */
проц unSpeculative(Scope* sc, КорневойОбъект o)
{
    if (!o)
        return;

    if (Tuple tup = кортеж_ли(o))
    {
        for (т_мера i = 0; i < tup.objects.dim; i++)
        {
            unSpeculative(sc, tup.objects[i]);
        }
        return;
    }

    ДСимвол s = getDsymbol(o);
    if (!s)
        return;

    if (Declaration d = s.isDeclaration())
    {
        if (VarDeclaration vd = d.isVarDeclaration())
            o = vd.тип;
        else if (AliasDeclaration ad = d.isAliasDeclaration())
        {
            o = ad.getType();
            if (!o)
                o = ad.toAlias();
        }
        else
            o = d.toAlias();

        s = getDsymbol(o);
        if (!s)
            return;
    }

    if (TemplateInstance ti = s.isTemplateInstance())
    {
        // If the instance is already non-speculative,
        // or it is leaked to the speculative scope.
        if (ti.minst !is null || sc.minst is null)
            return;

        // Remark as non-speculative instance.
        ti.minst = sc.minst;
        if (!ti.tinst)
            ti.tinst = sc.tinst;

        unSpeculative(sc, ti.tempdecl);
    }

    if (TemplateInstance ti = s.isInstantiated())
        unSpeculative(sc, ti);
}

/**********************************
 * Return да if e could be valid only as a template значение параметр.
 * Return нет if it might be an alias or кортеж.
 * (Note that even in this case, it could still turn out to be a значение).
 */
бул definitelyValueParameter(Выражение e)
{
    // None of these can be значение parameters
    if (e.op == ТОК2.кортеж || e.op == ТОК2.scope_ ||
        e.op == ТОК2.тип || e.op == ТОК2.dotType ||
        e.op == ТОК2.template_ || e.op == ТОК2.dotTemplateDeclaration ||
        e.op == ТОК2.function_ || e.op == ТОК2.error ||
        e.op == ТОК2.this_ || e.op == ТОК2.super_)
        return нет;

    if (e.op != ТОК2.dotVariable)
        return да;

    /* Template instantiations involving a DotVar Выражение are difficult.
     * In most cases, they should be treated as a значение параметр, and interpreted.
     * But they might also just be a fully qualified имя, which should be treated
     * as an alias.
     */

    // x.y.f cannot be a значение
    FuncDeclaration f = (cast(DotVarExp)e).var.isFuncDeclaration();
    if (f)
        return нет;

    while (e.op == ТОК2.dotVariable)
    {
        e = (cast(DotVarExp)e).e1;
    }
    // this.x.y and super.x.y couldn't possibly be valid values.
    if (e.op == ТОК2.this_ || e.op == ТОК2.super_)
        return нет;

    // e.тип.x could be an alias
    if (e.op == ТОК2.dotType)
        return нет;

    // var.x.y is the only other possible form of alias
    if (e.op != ТОК2.variable)
        return да;

    VarDeclaration v = (cast(VarExp)e).var.isVarDeclaration();
    // func.x.y is not an alias
    if (!v)
        return да;

    // https://issues.dlang.org/show_bug.cgi?ид=16685
    // var.x.y where var is a constant доступно at compile time
    if (v.класс_хранения & STC.manifest)
        return да;

    // TODO: Should we force CTFE if it is a глоб2 constant?
    return нет;
}

/***********************************************************
 * https://dlang.org/spec/template-mixin.html
 * Syntax:
 *    mixin MixinTemplateName [TemplateArguments] [Идентификатор2];
 */
 final class TemplateMixin : TemplateInstance
{
    TypeQualified tqual;

    this(ref Место место, Идентификатор2 идент, TypeQualified tqual, Объекты* tiargs)
    {
        super(место,
              tqual.idents.dim ? cast(Идентификатор2)tqual.idents[tqual.idents.dim - 1] : (cast(TypeIdentifier)tqual).идент,
              tiargs ? tiargs : new Объекты());
        //printf("TemplateMixin(идент = '%s')\n", идент ? идент.вТкст0() : "");
        this.идент = идент;
        this.tqual = tqual;
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        auto tm = new TemplateMixin(место, идент, cast(TypeQualified)tqual.syntaxCopy(), tiargs);
        return TemplateInstance.syntaxCopy(tm);
    }

    override ткст0 вид()
    {
        return "mixin";
    }

    override бул oneMember(ДСимвол* ps, Идентификатор2 идент)
    {
        return ДСимвол.oneMember(ps, идент);
    }

    override цел apply(Dsymbol_apply_ft_t fp, ук param)
    {
        if (_scope) // if fwd reference
            dsymbolSemantic(this, null); // try to resolve it

        return члены.foreachDsymbol( (s) { return s && s.apply(fp, param); } );
    }

    override бул hasPointers()
    {
        //printf("TemplateMixin.hasPointers() %s\n", вТкст0());
        return члены.foreachDsymbol( (s) { return s.hasPointers(); } ) != 0;
    }

    override проц setFieldOffset(AggregateDeclaration ad, бцел* poffset, бул isunion)
    {
        //printf("TemplateMixin.setFieldOffset() %s\n", вТкст0());
        if (_scope) // if fwd reference
            dsymbolSemantic(this, null); // try to resolve it

        члены.foreachDsymbol( (s) { s.setFieldOffset(ad, poffset, isunion); } );
    }

    override ткст0 вТкст0()
    {
        БуфВыв буф;
        toCBufferInstance(this, &буф);
        return буф.extractChars();
    }

    extern (D) бул findTempDecl(Scope* sc)
    {
        // Follow qualifications to найди the TemplateDeclaration
        if (!tempdecl)
        {
            Выражение e;
            Тип t;
            ДСимвол s;
            tqual.resolve(место, sc, &e, &t, &s);
            if (!s)
            {
                выведиОшибку("is not defined");
                return нет;
            }
            s = s.toAlias();
            tempdecl = s.isTemplateDeclaration();
            OverloadSet ос = s.isOverloadSet();

            /* If an OverloadSet, look for a unique member that is a template declaration
             */
            if (ос)
            {
                ДСимвол ds = null;
                for (т_мера i = 0; i < ос.a.dim; i++)
                {
                    ДСимвол s2 = ос.a[i].isTemplateDeclaration();
                    if (s2)
                    {
                        if (ds)
                        {
                            tempdecl = ос;
                            break;
                        }
                        ds = s2;
                    }
                }
            }
            if (!tempdecl)
            {
                выведиОшибку("`%s` isn't a template", s.вТкст0());
                return нет;
            }
        }
        assert(tempdecl);

        // Look for forward references
        auto tovers = tempdecl.isOverloadSet();
        foreach (т_мера oi; new бцел[0 .. tovers] ? tovers.a.dim : 1)
        {
            ДСимвол dstart = tovers ? tovers.a[oi] : tempdecl;
            цел r = overloadApply(dstart, (ДСимвол s)
            {
                auto td = s.isTemplateDeclaration();
                if (!td)
                    return 0;

                if (td.semanticRun == PASS.init)
                {
                    if (td._scope)
                        td.dsymbolSemantic(td._scope);
                    else
                    {
                        semanticRun = PASS.init;
                        return 1;
                    }
                }
                return 0;
            });
            if (r)
                return нет;
        }
        return да;
    }

    override TemplateMixin isTemplateMixin()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/************************************
 * This struct is needed for TemplateInstance to be the ключ in an associative массив.
 * Fixing https://issues.dlang.org/show_bug.cgi?ид=15812 and
 * https://issues.dlang.org/show_bug.cgi?ид=15813 would make it unnecessary.
 */
struct TemplateInstanceBox
{
    TemplateInstance ti;

    this(TemplateInstance ti)
    {
        this.ti = ti;
        this.ti.toHash();
        assert(this.ti.хэш);
    }

    т_мера toHash()
    {
        assert(ti.хэш);
        return ti.хэш;
    }

    бул opEquals(ref TemplateInstanceBox s)
    {
        бул res = проц;
        if (ti.inst && s.ti.inst)
            /* This clause is only используется when an instance with errors
             * is replaced with a correct instance.
             */
            res = ti is s.ti;
        else
            /* Used when a proposed instance is используется to see if there's
             * an existing instance.
             */
            res = (/*cast()*/s.ti).equalsx(/*cast()*/ti);

        debug (FindExistingInstance) ++(res ? nHits : nCollisions);
        return res;
    }

    debug (FindExistingInstance)
    {
         бцел nHits, nCollisions;

        static ~this()
        {
            printf("debug (FindExistingInstance) TemplateInstanceBox.равен hits: %u collisions: %u\n",
                   nHits, nCollisions);
        }
    }
}

/*******************************************
 * Match to a particular ПараметрШаблона2.
 * Input:
 *      instLoc         location that the template is instantiated.
 *      tiargs[]        actual arguments to template instance
 *      i               i'th argument
 *      parameters[]    template parameters
 *      dedtypes[]      deduced arguments to template instance
 *      *psparam        set to symbol declared and initialized to dedtypes[i]
 */
MATCH matchArg(ПараметрШаблона2 tp, Место instLoc, Scope* sc, Объекты* tiargs, т_мера i, ПараметрыШаблона* parameters, Объекты* dedtypes, Declaration* psparam)
{
    MATCH matchArgNoMatch()
    {
        if (psparam)
            *psparam = null;
        return MATCH.nomatch;
    }

    MATCH matchArgParameter()
    {
        КорневойОбъект oarg;

        if (i < tiargs.dim)
            oarg = (*tiargs)[i];
        else
        {
            // Get default argument instead
            oarg = tp.defaultArg(instLoc, sc);
            if (!oarg)
            {
                assert(i < dedtypes.dim);
                // It might have already been deduced
                oarg = (*dedtypes)[i];
                if (!oarg)
                    return matchArgNoMatch();
            }
        }
        return tp.matchArg(sc, oarg, i, parameters, dedtypes, psparam);
    }

    MATCH matchArgTuple(TemplateTupleParameter ttp)
    {
        /* The rest of the actual arguments (tiargs[]) form the match
         * for the variadic параметр.
         */
        assert(i + 1 == dedtypes.dim); // must be the last one
        Tuple ovar;

        if (Tuple u = кортеж_ли((*dedtypes)[i]))
        {
            // It has already been deduced
            ovar = u;
        }
        else if (i + 1 == tiargs.dim && кортеж_ли((*tiargs)[i]))
            ovar = кортеж_ли((*tiargs)[i]);
        else
        {
            ovar = new Tuple();
            //printf("ovar = %p\n", ovar);
            if (i < tiargs.dim)
            {
                //printf("i = %d, tiargs.dim = %d\n", i, tiargs.dim);
                ovar.objects.устДим(tiargs.dim - i);
                for (т_мера j = 0; j < ovar.objects.dim; j++)
                    ovar.objects[j] = (*tiargs)[i + j];
            }
        }
        return ttp.matchArg(sc, ovar, i, parameters, dedtypes, psparam);
    }

    if (auto ttp = tp.isTemplateTupleParameter())
        return matchArgTuple(ttp);
    else
        return matchArgParameter();
}

MATCH matchArg(ПараметрШаблона2 tp, Scope* sc, КорневойОбъект oarg, т_мера i, ПараметрыШаблона* parameters, Объекты* dedtypes, Declaration* psparam)
{
    MATCH matchArgNoMatch()
    {
        //printf("\tm = %d\n", MATCH.nomatch);
        if (psparam)
            *psparam = null;
        return MATCH.nomatch;
    }

    MATCH matchArgType(TemplateTypeParameter ttp)
    {
        //printf("TemplateTypeParameter.matchArg('%s')\n", ttp.идент.вТкст0());
        MATCH m = MATCH.exact;
        Тип ta = тип_ли(oarg);
        if (!ta)
        {
            //printf("%s %p %p %p\n", oarg.вТкст0(), выражение_ли(oarg), isDsymbol(oarg), кортеж_ли(oarg));
            return matchArgNoMatch();
        }
        //printf("ta is %s\n", ta.вТкст0());

        if (ttp.specType)
        {
            if (!ta || ta == TemplateTypeParameter.tdummy)
                return matchArgNoMatch();

            //printf("\tcalling deduceType(): ta is %s, specType is %s\n", ta.вТкст0(), ttp.specType.вТкст0());
            MATCH m2 = deduceType(ta, sc, ttp.specType, parameters, dedtypes);
            if (m2 <= MATCH.nomatch)
            {
                //printf("\tfailed deduceType\n");
                return matchArgNoMatch();
            }

            if (m2 < m)
                m = m2;
            if ((*dedtypes)[i])
            {
                Тип t = cast(Тип)(*dedtypes)[i];

                if (ttp.dependent && !t.равен(ta)) // https://issues.dlang.org/show_bug.cgi?ид=14357
                    return matchArgNoMatch();

                /* This is a self-dependent параметр. For example:
                 *  template X(T : T*) {}
                 *  template X(T : S!T, alias S) {}
                 */
                //printf("t = %s ta = %s\n", t.вТкст0(), ta.вТкст0());
                ta = t;
            }
        }
        else
        {
            if ((*dedtypes)[i])
            {
                // Must match already deduced тип
                Тип t = cast(Тип)(*dedtypes)[i];

                if (!t.равен(ta))
                {
                    //printf("t = %s ta = %s\n", t.вТкст0(), ta.вТкст0());
                    return matchArgNoMatch();
                }
            }
            else
            {
                // So that matches with specializations are better
                m = MATCH.convert;
            }
        }
        (*dedtypes)[i] = ta;

        if (psparam)
            *psparam = new AliasDeclaration(ttp.место, ttp.идент, ta);
        //printf("\tm = %d\n", m);
        return ttp.dependent ? MATCH.exact : m;
    }

    MATCH matchArgValue(TemplateValueParameter tvp)
    {
        //printf("TemplateValueParameter.matchArg('%s')\n", tvp.идент.вТкст0());
        MATCH m = MATCH.exact;

        Выражение ei = выражение_ли(oarg);
        Тип vt;

        if (!ei && oarg)
        {
            ДСимвол si = isDsymbol(oarg);
            FuncDeclaration f = si ? si.isFuncDeclaration() : null;
            if (!f || !f.fbody || f.needThis())
                return matchArgNoMatch();

            ei = new VarExp(tvp.место, f);
            ei = ei.ВыражениеSemantic(sc);

            /* If a function is really property-like, and then
             * it's CTFEable, ei will be a literal Выражение.
             */
            бцел olderrors = глоб2.startGagging();
            ei = resolveProperties(sc, ei);
            ei = ei.ctfeInterpret();
            if (глоб2.endGagging(olderrors) || ei.op == ТОК2.error)
                return matchArgNoMatch();

            /* https://issues.dlang.org/show_bug.cgi?ид=14520
             * A property-like function can match to both
             * TemplateAlias and ValueParameter. But for template overloads,
             * it should always prefer alias параметр to be consistent
             * template match результат.
             *
             *   template X(alias f) { const X = 1; }
             *   template X(цел val) { const X = 2; }
             *   цел f1() { return 0; }  // CTFEable
             *   цел f2();               // body-less function is not CTFEable
             *   const x1 = X!f1;    // should be 1
             *   const x2 = X!f2;    // should be 1
             *
             * e.g. The x1 значение must be same even if the f1 definition will be moved
             *      into di while stripping body code.
             */
            m = MATCH.convert;
        }

        if (ei && ei.op == ТОК2.variable)
        {
            // Resolve const variables that we had skipped earlier
            ei = ei.ctfeInterpret();
        }

        //printf("\tvalType: %s, ty = %d\n", tvp.valType.вТкст0(), tvp.valType.ty);
        vt = tvp.valType.typeSemantic(tvp.место, sc);
        //printf("ei: %s, ei.тип: %s\n", ei.вТкст0(), ei.тип.вТкст0());
        //printf("vt = %s\n", vt.вТкст0());

        if (ei.тип)
        {
            MATCH m2 = ei.implicitConvTo(vt);
            //printf("m: %d\n", m);
            if (m2 < m)
                m = m2;
            if (m <= MATCH.nomatch)
                return matchArgNoMatch();
            ei = ei.implicitCastTo(sc, vt);
            ei = ei.ctfeInterpret();
        }

        if (tvp.specValue)
        {
            if (ei is null || (cast(ук)ei.тип in TemplateValueParameter.edummies &&
                               TemplateValueParameter.edummies[cast(ук)ei.тип] == ei))
                return matchArgNoMatch();

            Выражение e = tvp.specValue;

            sc = sc.startCTFE();
            e = e.ВыражениеSemantic(sc);
            e = resolveProperties(sc, e);
            sc = sc.endCTFE();
            e = e.implicitCastTo(sc, vt);
            e = e.ctfeInterpret();

            ei = ei.syntaxCopy();
            sc = sc.startCTFE();
            ei = ei.ВыражениеSemantic(sc);
            sc = sc.endCTFE();
            ei = ei.implicitCastTo(sc, vt);
            ei = ei.ctfeInterpret();
            //printf("\tei: %s, %s\n", ei.вТкст0(), ei.тип.вТкст0());
            //printf("\te : %s, %s\n", e.вТкст0(), e.тип.вТкст0());
            if (!ei.равен(e))
                return matchArgNoMatch();
        }
        else
        {
            if ((*dedtypes)[i])
            {
                // Must match already deduced значение
                Выражение e = cast(Выражение)(*dedtypes)[i];
                if (!ei || !ei.равен(e))
                    return matchArgNoMatch();
            }
        }
        (*dedtypes)[i] = ei;

        if (psparam)
        {
            Инициализатор _иниц = new ExpInitializer(tvp.место, ei);
            Declaration sparam = new VarDeclaration(tvp.место, vt, tvp.идент, _иниц);
            sparam.класс_хранения = STC.manifest;
            *psparam = sparam;
        }
        return tvp.dependent ? MATCH.exact : m;
    }

    MATCH matchArgAlias(TemplateAliasParameter tap)
    {
        //printf("TemplateAliasParameter.matchArg('%s')\n", tap.идент.вТкст0());
        MATCH m = MATCH.exact;
        Тип ta = тип_ли(oarg);
        КорневойОбъект sa = ta && !ta.deco ? null : getDsymbol(oarg);
        Выражение ea = выражение_ли(oarg);
        if (ea && (ea.op == ТОК2.this_ || ea.op == ТОК2.super_))
            sa = (cast(ThisExp)ea).var;
        else if (ea && ea.op == ТОК2.scope_)
            sa = (cast(ScopeExp)ea).sds;
        if (sa)
        {
            if ((cast(ДСимвол)sa).isAggregateDeclaration())
                m = MATCH.convert;

            /* specType means the alias must be a declaration with a тип
             * that matches specType.
             */
            if (tap.specType)
            {
                Declaration d = (cast(ДСимвол)sa).isDeclaration();
                if (!d)
                    return matchArgNoMatch();
                if (!d.тип.равен(tap.specType))
                    return matchArgNoMatch();
            }
        }
        else
        {
            sa = oarg;
            if (ea)
            {
                if (tap.specType)
                {
                    if (!ea.тип.равен(tap.specType))
                        return matchArgNoMatch();
                }
            }
            else if (ta && ta.ty == Tinstance && !tap.specAlias)
            {
                /* Specialized параметр should be preferred
                 * match to the template тип параметр.
                 *  template X(alias a) {}                      // a == this
                 *  template X(alias a : B!A, alias B, A...) {} // B!A => ta
                 */
            }
            else if (sa && sa == TemplateTypeParameter.tdummy)
            {
                /* https://issues.dlang.org/show_bug.cgi?ид=2025
                 * Aggregate Types should preferentially
                 * match to the template тип параметр.
                 *  template X(alias a) {}  // a == this
                 *  template X(T) {}        // T => sa
                 */
            }
            else if (ta && ta.ty != Tident)
            {
                /* Match any тип that's not a TypeIdentifier to alias parameters,
                 * but prefer тип параметр.
                 * template X(alias a) { }  // a == ta
                 *
                 * TypeIdentifiers are excluded because they might be not yet resolved ники.
                 */
                m = MATCH.convert;
            }
            else
                return matchArgNoMatch();
        }

        if (tap.specAlias)
        {
            if (sa == TemplateAliasParameter.sdummy)
                return matchArgNoMatch();
            ДСимвол sx = isDsymbol(sa);
            if (sa != tap.specAlias && sx)
            {
                Тип talias = тип_ли(tap.specAlias);
                if (!talias)
                    return matchArgNoMatch();

                TemplateInstance ti = sx.isTemplateInstance();
                if (!ti && sx.родитель)
                {
                    ti = sx.родитель.isTemplateInstance();
                    if (ti && ti.имя != sx.идент)
                        return matchArgNoMatch();
                }
                if (!ti)
                    return matchArgNoMatch();

                Тип t = new TypeInstance(Место.initial, ti);
                MATCH m2 = deduceType(t, sc, talias, parameters, dedtypes);
                if (m2 <= MATCH.nomatch)
                    return matchArgNoMatch();
            }
        }
        else if ((*dedtypes)[i])
        {
            // Must match already deduced symbol
            КорневойОбъект si = (*dedtypes)[i];
            if (!sa || si != sa)
                return matchArgNoMatch();
        }
        (*dedtypes)[i] = sa;

        if (psparam)
        {
            if (ДСимвол s = isDsymbol(sa))
            {
                *psparam = new AliasDeclaration(tap.место, tap.идент, s);
            }
            else if (Тип t = тип_ли(sa))
            {
                *psparam = new AliasDeclaration(tap.место, tap.идент, t);
            }
            else
            {
                assert(ea);

                // Declare manifest constant
                Инициализатор _иниц = new ExpInitializer(tap.место, ea);
                auto v = new VarDeclaration(tap.место, null, tap.идент, _иниц);
                v.класс_хранения = STC.manifest;
                v.dsymbolSemantic(sc);
                *psparam = v;
            }
        }
        return tap.dependent ? MATCH.exact : m;
    }

    MATCH matchArgTuple(TemplateTupleParameter ttp)
    {
        //printf("TemplateTupleParameter.matchArg('%s')\n", ttp.идент.вТкст0());
        Tuple ovar = кортеж_ли(oarg);
        if (!ovar)
            return MATCH.nomatch;
        if ((*dedtypes)[i])
        {
            Tuple tup = кортеж_ли((*dedtypes)[i]);
            if (!tup)
                return MATCH.nomatch;
            if (!match(tup, ovar))
                return MATCH.nomatch;
        }
        (*dedtypes)[i] = ovar;

        if (psparam)
            *psparam = new TupleDeclaration(ttp.место, ttp.идент, &ovar.objects);
        return ttp.dependent ? MATCH.exact : MATCH.convert;
    }

    if (auto ttp = tp.isTemplateTypeParameter())
        return matchArgType(ttp);
    else if (auto tvp = tp.isTemplateValueParameter())
        return matchArgValue(tvp);
    else if (auto tap = tp.isTemplateAliasParameter())
        return matchArgAlias(tap);
    else if (auto ttp = tp.isTemplateTupleParameter())
        return matchArgTuple(ttp);
    else
        assert(0);
}
